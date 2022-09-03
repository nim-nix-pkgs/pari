import strutils
import pari
import locks
import os

type
  MessageKind = enum
    print, stop
  Message = object
    case kind: MessageKind
    of print:
      test: ptr GEN
    of stop:
      nil

const
  numthd=3
  pstacksize=2_000_010

var
  channel: array [0..numthd-1, Channel[Message]]
  thread: array [0..numthd-1,Thread[int]]
  init_lock: Lock
  init_done= numthd
  shared_gen : seq[ptr GEN] = @[]

template fort(body:stmt) :stmt {.dirty, immediate.}=  ## Threads's for loop
  for i in 0..high(thread):
    body

proc toSeq(g:GEN):seq[float]=
  result = @[]
  var t = $type0(g)
  case t[1 .. ^2]
  of "t_INT", "t_REAL":
    result.add(g.gtodouble())
  of "t_VEC", "t_COL":
    for i in 1..g.glength:
      result.add(gtodouble(safegel(g,i)[]))
  else :
    result.add(0.0)

initLock(init_lock)

template start_pari_thread( stack_size: int= pstacksize): stmt=
  pari_init( stack_size,11)
  var parth: pari_thread
  pari_thread_alloc(addr parth, stack_size-10,nil)
  discard pari_thread_start(addr parth)

proc pari_child(tnum: int){.thread.}=

  acquire(init_lock) ## wait all thread initialized
  start_pari_thread()

  init_done=init_done-1
  release(init_lock)
  while init_done!=0:
    os.sleep(1)

  echo "[Thread: $#]: init done" % $tnum
  while true:
    let msg = recv channel[tnum]
    case msg.kind:
      of print:
        var g =msg.test[]
        echo "[Thread: $#]: " % $tnum, gel(factor(g),1).toSeq
      of stop:
        echo "[Thread: $#]: close" % $tnum
        pari_thread_close()
        break

proc stopth {.noconv.} =
  fort:
    channel[i].send Message(kind: stop)
    joinThread thread[i]
    close channel[i]
  for el in shared_gen:
    discard reallocShared(el, 0)

proc newSharedGen(nthr: int, g: GEN):ptr GEN=
  result = cast[ptr GEN](allocShared(sizeof(GEN)))
  result[] = cast[GEN](allocShared(g.gsizebyte))
  shared_gen.add (result)
  copyMem(result[], g, g.gsizebyte )

start_pari_thread()

fort:
  open channel[i]
  createThread(thread[i], pari_child, i)


fort:
  channel[i].send Message(kind: print, test: newSharedGen(i, newGEN("(2^120+1)^2-2")))

for k in [81,64,99]:
  fort:
    channel[i].send Message(kind: print, test: newSharedGen(i, newGEN("(2^$#+1)-2" % $k)))
  echo k, " dispatched"




addQuitProc stopth
