import ../pari

const MAX_STACK_SIZE = 8000000
pari_init(MAX_STACK_SIZE,200000)
pari_default_prec = 30
discard sd_realprecision(($pari_default_prec).cstring, d_SILENT)

proc bench()=
  #var lim = stack_lim(avma, 1)
  var ltop = avma
  var
    u = newGEN()+1
    v = newGEN(1)
    p = newGEN(1)
    q = newGEN(1)
  #var ltop = avma

  for k in 1..2000:
    v = v+u
    u = v-u
    p = p*v
    q =  glcm(q,v)
    if  getstack() > int(MAX_STACK_SIZE*0.7):
      gerepileall(ltop, 4, addr v, addr u, addr p, addr q)
    if k mod 50 == 0 :
      var ttop = avma
      echo k, " ",   p.glog/ q.glog
      avma=ttop
    if  getstack() > int(MAX_STACK_SIZE*0.7):
      gerepileall(ltop, 4, addr v, addr u, addr p, addr q)
      #gerepile(ltop, lbot)
bench()
