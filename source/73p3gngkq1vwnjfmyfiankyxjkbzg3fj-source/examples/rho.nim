import ../pari

const MAX_STACK_SIZE = 8000000
pari_init(MAX_STACK_SIZE,200000)
pari_default_prec = 30
discard sd_realprecision(($pari_default_prec).cstring, d_SILENT)


proc rho(n: GEN):GEN=
  var
    x = newGEN(2)
    y = newGEN(5)
  while ggcd(y- x, n) == gen_1:
    x = (gsqr(x) + 1) mod n;
    y = (gsqr(y) + 1) mod n;
    y = (gsqr(y) + 1) mod n;
  return ggcd(n, gsub(y, x));

proc rhobrent(n:GEN)=
  var
    ctop = avma
    x1 = newGEN(2)
    x = newGEN(2)
    y = newGEN(2)
    k = newGEN(1)
    pl = newGEN(1)
    p = max(newGEN(1)^1, newGEN(1))
    c = newGEN(0)
    g = newGEN()

  while true:
    x = (x*x+1) mod n
    p = (p*(x1-x)) mod n
    c = c+1
    if  c == newGEN(20):
      if ggcd(p,n) > gen_1:
        y = x
        c = newGEN()
    k = k-1
    if k == gen_0:
      if  ggcd(p,n) > gen_1:
        break
      x1 = x
      k = pl
      pl = pl << 1
      for j in 1..k.toInt:
        x = (x*x+1) mod n
      y=x
      c=newGEN()

  var ltop = avma
  y = (y*y+1) mod n
  g = ggcd(x1-y,n)

  while g == gen_1:
    if  getstack() > int(MAX_STACK_SIZE*0.7):
      gerepileall(ltop, 2, addr g, addr y)
    y = (y*y+1) mod n
    g = ggcd(x1-y,n)

  if g == n:
    echo "error algorithm failed!"
  else:
    echo g
  avma=ctop

echo rho(newGEN(11)^51)

rhobrent(newGEN(11)^51)
