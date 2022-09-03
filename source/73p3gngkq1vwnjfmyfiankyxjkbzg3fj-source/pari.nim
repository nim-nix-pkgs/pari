 {.deadCodeElim: on.}
when defined(windows):
  const
    libname* = "libpari.dll"
elif defined(macosx):
  const
    libname* = "libpari.dylib"
else:
  const
    libname* = "libpari.so"
## #--+--

type va_list* {.importc: "va_list", header: "<stdio.h>".} = pointer
var pari_default_prec*:clong = 33

type
  pari_ulong* = culong
  GEN* = ptr clong

const
  t_INT* = 1
  t_REAL* = 2
  t_INTMOD* = 3
  t_FRAC* = 4
  t_FFELT* = 5
  t_COMPLEX* = 6
  t_PADIC* = 7
  t_QUAD* = 8
  t_POLMOD* = 9
  t_POL* = 10
  t_SER* = 11
  t_RFRAC* = 13
  t_QFR* = 15
  t_QFI* = 16
  t_VEC* = 17
  t_COL* = 18
  t_MAT* = 19
  t_LIST* = 20
  t_STR* = 21
  t_VECSMALL* = 22
  t_CLOSURE* = 23
  t_ERROR* = 24

type
  pari_timer* = object
    s*: clong
    us*: clong

  byteptr* = ptr cuchar
  pari_sp* = pari_ulong
  forprime_t* = object
    strategy*: cint
    bb*: GEN
    c*: pari_ulong
    q*: pari_ulong
    d*: byteptr
    p*: pari_ulong
    b*: pari_ulong
    sieve*: ptr cuchar
    cache*: array[9, pari_ulong]
    chunk*: pari_ulong
    a*: pari_ulong
    `end`*: pari_ulong
    sieveb*: pari_ulong
    pos*: pari_ulong
    maxpos*: pari_ulong
    pp*: GEN

  forcomposite_t* = object
    first*: cint
    b*: GEN
    n*: GEN
    p*: GEN
    T*: forprime_t

  forvec_t* = object
    first*: clong
    a*: ptr GEN
    m*: ptr GEN
    M*: ptr GEN
    n*: clong
    next*: proc (a2: ptr forvec_t): GEN {.cdecl.}

  forpart_t* = object
    k*: clong
    amax*: clong
    amin*: clong
    nmin*: clong
    nmax*: clong
    strip*: clong
    v*: GEN

  GENbin* = object
    len*: csize
    x*: GEN
    base*: GEN
    canon*: cint

  pari_mainstack* = object
    top*: pari_sp
    bot*: pari_sp
    avma*: pari_sp
    memused*: csize

  pari_thread* = object
    st*: pari_mainstack
    data*: GEN

  pariFILE* = object
    file*: ptr FILE
    `type`*: cint
    name*: cstring
    prev*: ptr pariFILE
    next*: ptr pariFILE


const
  mf_IN* = 1
  mf_PIPE* = 2
  mf_FALSE* = 4
  mf_OUT* = 8
  mf_PERM* = 16

type
  entree* = object
    name*: cstring
    valence*: pari_ulong
    value*: pointer
    menu*: clong
    code*: cstring
    help*: cstring
    pvalue*: pointer
    arity*: clong
    next*: ptr entree

  pari_parsestate* = object
    node*: clong
    once*: cint
    discarded*: clong
    lex_start*: cstring
    unused_chars*: cstring
    lasterror*: GEN

  pari_compilestate* = object
    opcode*: clong
    operand*: clong
    data*: clong
    localvars*: clong
    frames*: clong
    dbginfo*: clong
    offset*: clong
    dbgstart*: cstring

  pari_evalstate* = object
    avma*: pari_sp
    sp*: clong
    rp*: clong
    `var`*: clong
    lvars*: clong
    trace*: clong
    pending_threads*: clong
    comp*: pari_compilestate

  gp_context* = object
    listloc*: clong
    prettyp*: clong
    eval*: pari_evalstate
    parse*: pari_parsestate
    file*: ptr pariFILE
    err_data*: GEN

  mt_state* = object
    worker*: GEN
    pending*: GEN
    workid*: clong

  pari_mt* = object
    mt*: mt_state
    get*: proc (mt: ptr mt_state; workid: ptr clong; pending: ptr clong): GEN {.cdecl.}
    submit*: proc (mt: ptr mt_state; workid: clong; work: GEN) {.cdecl.}
    `end`*: proc () {.cdecl.}

  PariOUT* = object
    putch*: proc (a2: char) {.cdecl.}
    puts*: proc (a2: cstring) {.cdecl.}
    flush*: proc () {.cdecl.}

  hashentry* = object
    key*: pointer
    val*: pointer
    hash*: pari_ulong
    next*: ptr hashentry

  hashtable* = object
    len*: pari_ulong
    table*: ptr ptr hashentry
    nb*: pari_ulong
    maxnb*: pari_ulong
    pindex*: pari_ulong
    hash*: proc (k: pointer): pari_ulong {.cdecl.}
    eq*: proc (k1: pointer; k2: pointer): cint {.cdecl.}
    use_stack*: cint

  pari_stack* = object
    data*: ptr pointer
    n*: clong
    alloc*: clong
    size*: csize


var
  pariOut* {.importc: "pariOut", dynlib: libname.}: ptr PariOUT
  pariErrc* {.importc: "pariErr", dynlib: libname.}: ptr PariOUT

var
  pari_outfile* {.importc: "pari_outfile", dynlib: libname.}: ptr FILE
  pari_logfile* {.importc: "pari_logfile", dynlib: libname.}: ptr FILE
  pari_infile* {.importc: "pari_infile", dynlib: libname.}: ptr FILE
  pari_errfile* {.importc: "pari_errfile", dynlib: libname.}: ptr FILE

var logstyle* {.importc: "logstyle", dynlib: libname.}: pari_ulong

type
  logstyles* {.size: sizeof(cint).} = enum
    logstyle_none, logstyle_plain, logstyle_color, logstyle_TeX


const
  c_ERR* = 0
  c_HIST* = 1
  c_PROMPT* = 2
  c_INPUT* = 3
  c_OUTPUT* = 4
  c_HELP* = 5
  c_TIME* = 6
  c_LAST* = 7
  c_NONE* = 0x0000FFFF

const
  TEXSTYLE_PAREN* = 2
  TEXSTYLE_BREAK* = 4

var
  avma* {.importc: "avma", dynlib: libname.}: pari_sp
  bot* {.importc: "bot", dynlib: libname.}: pari_sp
  top* {.importc: "top", dynlib: libname.}: pari_sp

var memused* {.importc: "memused", dynlib: libname.}: csize

var diffptr* {.importc: "diffptr", dynlib: libname.}: byteptr

var
  current_psfile* {.importc: "current_psfile", dynlib: libname.}: cstring
  pari_datadir* {.importc: "pari_datadir", dynlib: libname.}: cstring


var CATCH_ALL* {.importc: "CATCH_ALL", dynlib: libname.}: clong


var
  LOG2* {.importc: "LOG2", dynlib: libname.}: cdouble
  LOG10_2* {.importc: "LOG10_2", dynlib: libname.}: cdouble
  LOG2_10* {.importc: "LOG2_10", dynlib: libname.}: cdouble

var
  new_galois_format* {.importc: "new_galois_format", dynlib: libname.}: cint
  factor_add_primes* {.importc: "factor_add_primes", dynlib: libname.}: cint
  factor_proven* {.importc: "factor_proven", dynlib: libname.}: cint

var
  DEBUGFILES* {.importc: "DEBUGFILES", dynlib: libname.}: pari_ulong
  DEBUGLEVEL* {.importc: "DEBUGLEVEL", dynlib: libname.}: pari_ulong
  DEBUGMEM* {.importc: "DEBUGMEM", dynlib: libname.}: pari_ulong
  precdl* {.importc: "precdl", dynlib: libname.}: pari_ulong

var DEBUGVAR* {.importc: "DEBUGVAR", dynlib: libname.}: clong

var pari_mt_nbthreads* {.importc: "pari_mt_nbthreads", dynlib: libname.}: pari_ulong

var bernzone* {.importc: "bernzone", dynlib: libname.}: GEN

var primetab* {.importc: "primetab", dynlib: libname.}: GEN

var
  gen_m1* {.importc: "gen_m1", dynlib: libname.}: GEN
  gen_1* {.importc: "gen_1", dynlib: libname.}: GEN
  gen_2* {.importc: "gen_2", dynlib: libname.}: GEN
  gen_m2* {.importc: "gen_m2", dynlib: libname.}: GEN
  ghalf* {.importc: "ghalf", dynlib: libname.}: GEN
  gen_0* {.importc: "gen_0", dynlib: libname.}: GEN
  gnil* {.importc: "gnil", dynlib: libname.}: GEN
  err_e_STACK* {.importc: "err_e_STACK", dynlib: libname.}: GEN

var
  PARI_SIGINT_block* {.importc: "PARI_SIGINT_block", dynlib: libname.}: cint
  PARI_SIGINT_pending* {.importc: "PARI_SIGINT_pending", dynlib: libname.}: cint

var lontyp* {.importc: "lontyp", dynlib: libname.}: ptr clong

var cb_pari_ask_confirm*: proc (a2: cstring) {.cdecl.}

var cb_pari_whatnow*: proc (`out`: ptr PariOUT; a3: cstring; a4: cint): cint {.cdecl.}

var cb_pari_sigint*: proc () {.cdecl.}

var cb_pari_handle_exception*: proc (a2: clong): cint {.cdecl.}

var cb_pari_pre_recover*: proc (a2: clong) {.cdecl.}

var cb_pari_err_recover*: proc (a2: clong) {.cdecl.}

var pari_library_path* {.importc: "pari_library_path", dynlib: libname.}: cstring

type
  manage_var_t* {.size: sizeof(cint).} = enum
    manage_var_create, manage_var_delete, manage_var_init, manage_var_next,
    manage_var_max_avail, manage_var_pop


const
  INIT_JMPm* = 1
  INIT_SIGm* = 2
  INIT_DFTm* = 4
  INIT_noPRIMEm* = 8
  INIT_noIMTm* = 16


type
  err_list* {.size: sizeof(cint).} = enum
    e_SYNTAX = 1, e_BUG, e_ALARM, e_FILE, e_MISC, e_FLAG, e_IMPL, e_ARCH, e_PACKAGE,
    e_NOTFUNC, e_PREC, e_TYPE, e_DIM, e_VAR, e_PRIORITY, e_USER, e_STACK, e_OVERFLOW,
    e_DOMAIN, e_COMPONENT, e_MAXPRIME, e_CONSTPOL, e_IRREDPOL, e_COPRIME, e_PRIME,
    e_MODULUS, e_ROOTS0, e_OP, e_TYPE2, e_INV, e_MEM, e_SQRTN, e_NONE


const
  warner* = 0
  warnprec* = 1
  warnfile* = 2
  warnmem* = 3
  warnuser* = 4


const
  typ_NULL* = 0
  typ_POL* = 1
  typ_Q* = 2
  typ_NF* = 3
  typ_BNF* = 4
  typ_BNR* = 5
  typ_ELL* = 6
  typ_QUA* = 7
  typ_GAL* = 8
  typ_BID* = 9
  typ_PRID* = 10
  typ_MODPR* = 11
  typ_RNF* = 12

const
  id_PRINCIPAL* = 0
  id_PRIME* = 1
  id_MAT* = 2

type
  nfbasic_t* = object
    x*: GEN
    x0*: GEN
    bas*: GEN
    r1*: clong
    dK*: GEN
    dKP*: GEN
    index*: GEN
    unscale*: GEN
    dx*: GEN
    basden*: GEN

  nfmaxord_t* = object
    T*: GEN
    dT*: GEN
    T0*: GEN
    unscale*: GEN
    dK*: GEN
    index*: GEN
    dTP*: GEN
    dTE*: GEN
    dKP*: GEN
    dKE*: GEN
    basis*: GEN

  nffp_t* = object
    x*: GEN
    ro*: GEN
    r1*: clong
    basden*: GEN
    prec*: clong
    extraprec*: clong
    M*: GEN
    G*: GEN

  qfr_data* = object
    D*: GEN
    sqrtD*: GEN
    isqrtD*: GEN


const
  nf_ORIG* = 1
  nf_GEN* = 1
  nf_ABSOLUTE* = 2
  nf_FORCE* = 2
  nf_ALL* = 4
  nf_GENMAT* = 4
  nf_INITc* = 4
  nf_RAW* = 8
  nf_RED* = 8
  nf_PARTIALFACT* = 16
  nf_ROUND2* = 64
  nf_ADDZK* = 256
  nf_GEN_IF_PRINCIPAL* = 512

const
  rnf_REL* = 1
  rnf_COND* = 2

const
  LLL_KER* = 1
  LLL_IM* = 2
  LLL_ALL* = 4
  LLL_GRAM* = 0x00000100
  LLL_KEEP_FIRST* = 0x00000200
  LLL_INPLACE* = 0x00000400

const
  hnf_MODID* = 1
  hnf_PART* = 2
  hnf_CENTER* = 4

const
  min_ALL* = 0
  min_FIRST* = 1
  min_PERF* = 2
  min_VECSMALL* = 3
  min_VECSMALL2* = 4

type
  FP_chk_fun* = object
    f*: proc (a2: pointer; a3: GEN): GEN {.cdecl.}
    f_init*: proc (a2: ptr FP_chk_fun; a3: GEN; a4: GEN): GEN {.cdecl.}
    f_post*: proc (a2: ptr FP_chk_fun; a3: GEN; a4: GEN): GEN {.cdecl.}
    data*: pointer
    skipfirst*: clong

  zlog_S* = object
    lists*: GEN
    ind*: GEN
    P*: GEN
    e*: GEN
    archp*: GEN
    n*: clong
    U*: GEN


proc fincke_pohst*(a: GEN; BOUND: GEN; stockmax: clong; PREC: clong;
                  CHECK: ptr FP_chk_fun): GEN {.cdecl, importc: "fincke_pohst",
    dynlib: libname.}
proc remake_GM*(nf: GEN; F: ptr nffp_t; prec: clong=pari_default_prec) {.cdecl, importc: "remake_GM",
    dynlib: libname.}
proc nfbasic_to_nf*(T: ptr nfbasic_t; ro: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "nfbasic_to_nf", dynlib: libname.}
proc init_zlog_bid*(S: ptr zlog_S; bid: GEN) {.cdecl, importc: "init_zlog_bid",
    dynlib: libname.}
proc log_gen_arch*(S: ptr zlog_S; index: clong): GEN {.cdecl, importc: "log_gen_arch",
    dynlib: libname.}
proc log_gen_pr*(S: ptr zlog_S; index: clong; nf: GEN; e: clong): GEN {.cdecl,
    importc: "log_gen_pr", dynlib: libname.}
proc zlog*(nf: GEN; a: GEN; sgn: GEN; S: ptr zlog_S): GEN {.cdecl, importc: "zlog",
    dynlib: libname.}
proc poltobasis*(nf: GEN; x: GEN): GEN {.cdecl, importc: "poltobasis", dynlib: libname.}
proc coltoalg*(nf: GEN; x: GEN): GEN {.cdecl, importc: "coltoalg", dynlib: libname.}
proc archstar_full_rk*(x: GEN; bas: GEN; v: GEN; gen: GEN): GEN {.cdecl,
    importc: "archstar_full_rk", dynlib: libname.}
proc check_and_build_cycgen*(bnf: GEN): GEN {.cdecl,
    importc: "check_and_build_cycgen", dynlib: libname.}
proc check_LIMC*(LIMC: clong; LIMCMAX: clong): clong {.cdecl, importc: "check_LIMC",
    dynlib: libname.}
proc checkbid_i*(bid: GEN): GEN {.cdecl, importc: "checkbid_i", dynlib: libname.}
proc checkbnf_i*(bnf: GEN): GEN {.cdecl, importc: "checkbnf_i", dynlib: libname.}
proc checknf_i*(nf: GEN): GEN {.cdecl, importc: "checknf_i", dynlib: libname.}
proc pow_ei_mod_p*(nf: GEN; I: clong; n: GEN; p: GEN): GEN {.cdecl,
    importc: "pow_ei_mod_p", dynlib: libname.}
proc galoisbig*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "galoisbig", dynlib: libname.}
proc get_arch_real*(nf: GEN; x: GEN; emb: ptr GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "get_arch_real", dynlib: libname.}
proc get_bas_den*(bas: GEN): GEN {.cdecl, importc: "get_bas_den", dynlib: libname.}
proc nf_set_multable*(nf: GEN; bas: GEN; basden: GEN) {.cdecl,
    importc: "nf_set_multable", dynlib: libname.}
proc get_nfindex*(bas: GEN): GEN {.cdecl, importc: "get_nfindex", dynlib: libname.}
proc get_proj_modT*(basis: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "get_proj_modT",
    dynlib: libname.}
proc get_roots*(x: GEN; r1: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "get_roots",
    dynlib: libname.}
proc get_theta_abstorel*(T: GEN; pol: GEN; k: GEN): GEN {.cdecl,
    importc: "get_theta_abstorel", dynlib: libname.}
proc idealsqrtn*(nf: GEN; x: GEN; gn: GEN; strict: cint): GEN {.cdecl,
    importc: "idealsqrtn", dynlib: libname.}
proc init_unif_mod_fZ*(L: GEN): GEN {.cdecl, importc: "init_unif_mod_fZ",
                                  dynlib: libname.}
proc init_units*(BNF: GEN): GEN {.cdecl, importc: "init_units", dynlib: libname.}
proc make_integral*(nf: GEN; L0: GEN; f: GEN; listpr: GEN): GEN {.cdecl,
    importc: "make_integral", dynlib: libname.}
proc maxord_i*(p: GEN; f: GEN; mf: clong; w: GEN; flag: clong): GEN {.cdecl,
    importc: "maxord_i", dynlib: libname.}
proc nf_deg1_prime*(nf: GEN): GEN {.cdecl, importc: "nf_deg1_prime", dynlib: libname.}
proc nfpol_to_Flx*(nf: GEN; pol: GEN; ptp: ptr pari_ulong): GEN {.cdecl,
    importc: "nfpol_to_Flx", dynlib: libname.}
proc nfroots_split*(nf: GEN; pol: GEN): GEN {.cdecl, importc: "nfroots_split",
                                        dynlib: libname.}
proc pidealprimeinv*(nf: GEN; x: GEN): GEN {.cdecl, importc: "pidealprimeinv",
                                       dynlib: libname.}
proc primedec_apply_kummer*(nf: GEN; pol: GEN; e: clong; p: GEN): GEN {.cdecl,
    importc: "primedec_apply_kummer", dynlib: libname.}
proc prodid*(nf: GEN; I: GEN): GEN {.cdecl, importc: "prodid", dynlib: libname.}
proc rnfallbase*(nf: GEN; ppol: ptr GEN; pD1: ptr GEN; pd: ptr GEN; pfi: ptr GEN): GEN {.cdecl,
    importc: "rnfallbase", dynlib: libname.}
proc rnf_basM*(rnf: GEN): GEN {.cdecl, importc: "rnf_basM", dynlib: libname.}
proc special_anti_uniformizer*(nf: GEN; pr: GEN): GEN {.cdecl,
    importc: "special_anti_uniformizer", dynlib: libname.}
proc subgroupcondlist*(cyc: GEN; bound: GEN; listKer: GEN): GEN {.cdecl,
    importc: "subgroupcondlist", dynlib: libname.}
proc testprimes*(bnf: GEN; bound: GEN) {.cdecl, importc: "testprimes", dynlib: libname.}
proc to_Fp_simple*(nf: GEN; x: GEN; ffproj: GEN): GEN {.cdecl, importc: "to_Fp_simple",
    dynlib: libname.}
proc unif_mod_fZ*(pr: GEN; F: GEN): GEN {.cdecl, importc: "unif_mod_fZ", dynlib: libname.}
proc unnf_minus_x*(x: GEN): GEN {.cdecl, importc: "unnf_minus_x", dynlib: libname.}
proc ideallog_sgn*(nf: GEN; x: GEN; sgn: GEN; bid: GEN): GEN {.cdecl,
    importc: "ideallog_sgn", dynlib: libname.}
proc zlog_units*(nf: GEN; U: GEN; sgnU: GEN; bid: GEN): GEN {.cdecl, importc: "zlog_units",
    dynlib: libname.}
proc zlog_units_noarch*(nf: GEN; U: GEN; bid: GEN): GEN {.cdecl,
    importc: "zlog_units_noarch", dynlib: libname.}
proc zeta_get_limx*(r1: clong; r2: clong; bit: clong): GEN {.cdecl,
    importc: "zeta_get_limx", dynlib: libname.}
proc zeta_get_i0*(r1: clong; r2: clong; bit: clong; limx: GEN): clong {.cdecl,
    importc: "zeta_get_i0", dynlib: libname.}
proc zeta_get_N0*(C: GEN; limx: GEN): clong {.cdecl, importc: "zeta_get_N0",
                                        dynlib: libname.}

type
  bb_group* = object
    mul*: proc (E: pointer; a3: GEN; a4: GEN): GEN {.cdecl.}
    pow*: proc (E: pointer; a3: GEN; a4: GEN): GEN {.cdecl.}
    rand*: proc (E: pointer): GEN {.cdecl.}
    hash*: proc (a2: GEN): pari_ulong {.cdecl.}
    equal*: proc (a2: GEN; a3: GEN): cint {.cdecl.}
    equal1*: proc (a2: GEN): cint {.cdecl.}
    easylog*: proc (E: pointer; a3: GEN; a4: GEN; a5: GEN): GEN {.cdecl.}

  bb_field* = object
    red*: proc (E: pointer; a3: GEN): GEN {.cdecl.}
    add*: proc (E: pointer; a3: GEN; a4: GEN): GEN {.cdecl.}
    mul*: proc (E: pointer; a3: GEN; a4: GEN): GEN {.cdecl.}
    neg*: proc (E: pointer; a3: GEN): GEN {.cdecl.}
    inv*: proc (E: pointer; a3: GEN): GEN {.cdecl.}
    equal0*: proc (a2: GEN): cint {.cdecl.}
    s*: proc (E: pointer; a3: clong): GEN {.cdecl.}

  bb_algebra* = object
    red*: proc (E: pointer; x: GEN): GEN {.cdecl.}
    add*: proc (E: pointer; x: GEN; y: GEN): GEN {.cdecl.}
    mul*: proc (E: pointer; x: GEN; y: GEN): GEN {.cdecl.}
    sqr*: proc (E: pointer; x: GEN): GEN {.cdecl.}
    one*: proc (E: pointer): GEN {.cdecl.}
    zero*: proc (E: pointer): GEN {.cdecl.}


proc bernvec*(nomb: clong): GEN {.cdecl, importc: "bernvec", dynlib: libname.}
proc buchimag*(D: GEN; c1: GEN; c2: GEN; gCO: GEN): GEN {.cdecl, importc: "buchimag",
    dynlib: libname.}
proc buchreal*(D: GEN; gsens: GEN; c1: GEN; c2: GEN; gRELSUP: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "buchreal", dynlib: libname.}
proc zidealstar*(nf: GEN; x: GEN): GEN {.cdecl, importc: "zidealstar", dynlib: libname.}
proc zidealstarinit*(nf: GEN; x: GEN): GEN {.cdecl, importc: "zidealstarinit",
                                       dynlib: libname.}
proc zidealstarinitgen*(nf: GEN; x: GEN): GEN {.cdecl, importc: "zidealstarinitgen",
    dynlib: libname.}
proc rootmod*(f: GEN; p: GEN): GEN {.cdecl, importc: "rootmod", dynlib: libname.}
proc rootmod2*(f: GEN; p: GEN): GEN {.cdecl, importc: "rootmod2", dynlib: libname.}
proc factmod*(f: GEN; p: GEN): GEN {.cdecl, importc: "factmod", dynlib: libname.}
proc simplefactmod*(f: GEN; p: GEN): GEN {.cdecl, importc: "simplefactmod",
                                     dynlib: libname.}
proc listcreate*(): GEN {.cdecl, importc: "listcreate", dynlib: libname.}
proc listkill*(list: GEN) {.cdecl, importc: "listkill", dynlib: libname.}
proc discrayabs*(bnr: GEN; subgroup: GEN): GEN {.cdecl, importc: "discrayabs",
    dynlib: libname.}
proc discrayabscond*(bnr: GEN; subgroup: GEN): GEN {.cdecl, importc: "discrayabscond",
    dynlib: libname.}
proc discrayrel*(bnr: GEN; subgroup: GEN): GEN {.cdecl, importc: "discrayrel",
    dynlib: libname.}
proc discrayrelcond*(bnr: GEN; subgroup: GEN): GEN {.cdecl, importc: "discrayrelcond",
    dynlib: libname.}
proc isprincipalforce*(bnf: GEN; x: GEN): GEN {.cdecl, importc: "isprincipalforce",
    dynlib: libname.}
proc isprincipalgen*(bnf: GEN; x: GEN): GEN {.cdecl, importc: "isprincipalgen",
                                        dynlib: libname.}
proc isprincipalgenforce*(bnf: GEN; x: GEN): GEN {.cdecl,
    importc: "isprincipalgenforce", dynlib: libname.}
proc F2c_to_Flc*(x: GEN): GEN {.cdecl, importc: "F2c_to_Flc", dynlib: libname.}
proc F2c_to_ZC*(x: GEN): GEN {.cdecl, importc: "F2c_to_ZC", dynlib: libname.}
proc F2c_to_mod*(x: GEN): GEN {.cdecl, importc: "F2c_to_mod", dynlib: libname.}
proc F2m_rowslice*(x: GEN; a: clong; b: clong): GEN {.cdecl, importc: "F2m_rowslice",
    dynlib: libname.}
proc F2m_to_Flm*(z: GEN): GEN {.cdecl, importc: "F2m_to_Flm", dynlib: libname.}
proc F2m_to_ZM*(z: GEN): GEN {.cdecl, importc: "F2m_to_ZM", dynlib: libname.}
proc F2m_to_mod*(z: GEN): GEN {.cdecl, importc: "F2m_to_mod", dynlib: libname.}
proc F2v_add_inplace*(x: GEN; y: GEN) {.cdecl, importc: "F2v_add_inplace",
                                   dynlib: libname.}
proc F2v_dotproduct*(x: GEN; y: GEN): pari_ulong {.cdecl, importc: "F2v_dotproduct",
    dynlib: libname.}
proc F2v_slice*(x: GEN; a: clong; b: clong): GEN {.cdecl, importc: "F2v_slice",
    dynlib: libname.}
proc F2x_F2xq_eval*(Q: GEN; x: GEN; T: GEN): GEN {.cdecl, importc: "F2x_F2xq_eval",
    dynlib: libname.}
proc F2x_F2xqV_eval*(P: GEN; V: GEN; T: GEN): GEN {.cdecl, importc: "F2x_F2xqV_eval",
    dynlib: libname.}
proc F2x_1_add*(y: GEN): GEN {.cdecl, importc: "F2x_1_add", dynlib: libname.}
proc F2x_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "F2x_add", dynlib: libname.}
proc F2x_deflate*(x0: GEN; d: clong): GEN {.cdecl, importc: "F2x_deflate",
                                      dynlib: libname.}
proc F2x_degree*(x: GEN): clong {.cdecl, importc: "F2x_degree", dynlib: libname.}
proc F2x_deriv*(x: GEN): GEN {.cdecl, importc: "F2x_deriv", dynlib: libname.}
proc F2x_divrem*(x: GEN; y: GEN; pr: ptr GEN): GEN {.cdecl, importc: "F2x_divrem",
    dynlib: libname.}
proc F2x_even_odd*(p: GEN; pe: ptr GEN; po: ptr GEN) {.cdecl, importc: "F2x_even_odd",
    dynlib: libname.}
proc F2x_extgcd*(a: GEN; b: GEN; ptu: ptr GEN; ptv: ptr GEN): GEN {.cdecl,
    importc: "F2x_extgcd", dynlib: libname.}
proc F2x_gcd*(a: GEN; b: GEN): GEN {.cdecl, importc: "F2x_gcd", dynlib: libname.}
proc F2x_halfgcd*(a: GEN; b: GEN): GEN {.cdecl, importc: "F2x_halfgcd", dynlib: libname.}
proc F2x_issquare*(a: GEN): cint {.cdecl, importc: "F2x_issquare", dynlib: libname.}
proc F2x_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "F2x_mul", dynlib: libname.}
proc F2x_rem*(x: GEN; y: GEN): GEN {.cdecl, importc: "F2x_rem", dynlib: libname.}
proc F2x_shift*(y: GEN; d: clong): GEN {.cdecl, importc: "F2x_shift", dynlib: libname.}
proc F2x_sqr*(x: GEN): GEN {.cdecl, importc: "F2x_sqr", dynlib: libname.}
proc F2x_sqrt*(x: GEN): GEN {.cdecl, importc: "F2x_sqrt", dynlib: libname.}
proc F2x_to_F2v*(x: GEN; n: clong): GEN {.cdecl, importc: "F2x_to_F2v", dynlib: libname.}
proc F2x_to_Flx*(x: GEN): GEN {.cdecl, importc: "F2x_to_Flx", dynlib: libname.}
proc F2x_to_ZX*(x: GEN): GEN {.cdecl, importc: "F2x_to_ZX", dynlib: libname.}
proc F2x_valrem*(x: GEN; Z: ptr GEN): clong {.cdecl, importc: "F2x_valrem",
                                       dynlib: libname.}
proc F2xC_to_ZXC*(x: GEN): GEN {.cdecl, importc: "F2xC_to_ZXC", dynlib: libname.}
proc F2xV_to_F2m*(v: GEN; n: clong): GEN {.cdecl, importc: "F2xV_to_F2m", dynlib: libname.}
proc F2xq_Artin_Schreier*(a: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_Artin_Schreier",
    dynlib: libname.}
proc FlxqXQV_autsum*(aut: GEN; n: clong; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQV_autsum", dynlib: libname.}
proc F2xq_autpow*(x: GEN; n: clong; T: GEN): GEN {.cdecl, importc: "F2xq_autpow",
    dynlib: libname.}
proc F2xq_conjvec*(x: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_conjvec", dynlib: libname.}
proc F2xq_div*(x: GEN; y: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_div", dynlib: libname.}
proc F2xq_inv*(x: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_inv", dynlib: libname.}
proc F2xq_invsafe*(x: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_invsafe", dynlib: libname.}
proc F2xq_log*(a: GEN; g: GEN; ord: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_log",
    dynlib: libname.}
proc F2xq_matrix_pow*(y: GEN; n: clong; m: clong; P: GEN): GEN {.cdecl,
    importc: "F2xq_matrix_pow", dynlib: libname.}
proc F2xq_mul*(x: GEN; y: GEN; pol: GEN): GEN {.cdecl, importc: "F2xq_mul", dynlib: libname.}
proc F2xq_order*(a: GEN; ord: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_order",
    dynlib: libname.}
proc F2xq_pow*(x: GEN; n: GEN; pol: GEN): GEN {.cdecl, importc: "F2xq_pow", dynlib: libname.}
proc F2xq_powu*(x: GEN; n: pari_ulong; pol: GEN): GEN {.cdecl, importc: "F2xq_powu",
    dynlib: libname.}
proc F2xq_powers*(x: GEN; par_l: clong; T: GEN): GEN {.cdecl, importc: "F2xq_powers",
    dynlib: libname.}
proc F2xq_sqr*(x: GEN; pol: GEN): GEN {.cdecl, importc: "F2xq_sqr", dynlib: libname.}
proc F2xq_sqrt*(a: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_sqrt", dynlib: libname.}
proc F2xq_sqrt_fast*(c: GEN; sqx: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_sqrt_fast",
    dynlib: libname.}
proc F2xq_sqrtn*(a: GEN; n: GEN; T: GEN; zeta: ptr GEN): GEN {.cdecl, importc: "F2xq_sqrtn",
    dynlib: libname.}
proc F2xq_trace*(x: GEN; T: GEN): pari_ulong {.cdecl, importc: "F2xq_trace",
    dynlib: libname.}
proc Flm_to_F2m*(x: GEN): GEN {.cdecl, importc: "Flm_to_F2m", dynlib: libname.}
proc Flv_to_F2v*(x: GEN): GEN {.cdecl, importc: "Flv_to_F2v", dynlib: libname.}
proc Flx_to_F2x*(x: GEN): GEN {.cdecl, importc: "Flx_to_F2x", dynlib: libname.}
proc Rg_to_F2xq*(x: GEN; T: GEN): GEN {.cdecl, importc: "Rg_to_F2xq", dynlib: libname.}
proc RgM_to_F2m*(x: GEN): GEN {.cdecl, importc: "RgM_to_F2m", dynlib: libname.}
proc RgV_to_F2v*(x: GEN): GEN {.cdecl, importc: "RgV_to_F2v", dynlib: libname.}
proc RgX_to_F2x*(x: GEN): GEN {.cdecl, importc: "RgX_to_F2x", dynlib: libname.}
proc Z_to_F2x*(x: GEN; v: clong): GEN {.cdecl, importc: "Z_to_F2x", dynlib: libname.}
proc ZM_to_F2m*(x: GEN): GEN {.cdecl, importc: "ZM_to_F2m", dynlib: libname.}
proc ZV_to_F2v*(x: GEN): GEN {.cdecl, importc: "ZV_to_F2v", dynlib: libname.}
proc ZX_to_F2x*(x: GEN): GEN {.cdecl, importc: "ZX_to_F2x", dynlib: libname.}
proc ZXT_to_FlxT*(z: GEN; p: pari_ulong): GEN {.cdecl, importc: "ZXT_to_FlxT",
    dynlib: libname.}
proc ZXX_to_F2xX*(B: GEN; v: clong): GEN {.cdecl, importc: "ZXX_to_F2xX", dynlib: libname.}
proc gener_F2xq*(T: GEN; po: ptr GEN): GEN {.cdecl, importc: "gener_F2xq", dynlib: libname.}
proc get_F2xq_field*(E: ptr pointer; T: GEN): ptr bb_field {.cdecl,
    importc: "get_F2xq_field", dynlib: libname.}
proc random_F2x*(d: clong; vs: clong): GEN {.cdecl, importc: "random_F2x",
                                       dynlib: libname.}
proc F2xq_ellcard*(a2: GEN; a6: GEN; T: GEN): GEN {.cdecl, importc: "F2xq_ellcard",
    dynlib: libname.}
proc F2xq_ellgens*(a2: GEN; a6: GEN; ch: GEN; D: GEN; m: GEN; T: GEN): GEN {.cdecl,
    importc: "F2xq_ellgens", dynlib: libname.}
proc F2xq_ellgroup*(a2: GEN; a6: GEN; N: GEN; T: GEN; pt_m: ptr GEN): GEN {.cdecl,
    importc: "F2xq_ellgroup", dynlib: libname.}
proc F2xqE_add*(P: GEN; Q: GEN; a2: GEN; T: GEN): GEN {.cdecl, importc: "F2xqE_add",
    dynlib: libname.}
proc F2xqE_changepoint*(x: GEN; ch: GEN; T: GEN): GEN {.cdecl,
    importc: "F2xqE_changepoint", dynlib: libname.}
proc F2xqE_changepointinv*(x: GEN; ch: GEN; T: GEN): GEN {.cdecl,
    importc: "F2xqE_changepointinv", dynlib: libname.}
proc F2xqE_dbl*(P: GEN; a2: GEN; T: GEN): GEN {.cdecl, importc: "F2xqE_dbl",
                                        dynlib: libname.}
proc F2xqE_log*(a: GEN; b: GEN; o: GEN; a2: GEN; T: GEN): GEN {.cdecl, importc: "F2xqE_log",
    dynlib: libname.}
proc F2xqE_mul*(P: GEN; n: GEN; a2: GEN; T: GEN): GEN {.cdecl, importc: "F2xqE_mul",
    dynlib: libname.}
proc F2xqE_neg*(P: GEN; a2: GEN; T: GEN): GEN {.cdecl, importc: "F2xqE_neg",
                                        dynlib: libname.}
proc F2xqE_order*(z: GEN; o: GEN; a2: GEN; T: GEN): GEN {.cdecl, importc: "F2xqE_order",
    dynlib: libname.}
proc F2xqE_sub*(P: GEN; Q: GEN; a2: GEN; T: GEN): GEN {.cdecl, importc: "F2xqE_sub",
    dynlib: libname.}
proc F2xqE_tatepairing*(t: GEN; s: GEN; m: GEN; a2: GEN; T: GEN): GEN {.cdecl,
    importc: "F2xqE_tatepairing", dynlib: libname.}
proc F2xqE_weilpairing*(t: GEN; s: GEN; m: GEN; a2: GEN; T: GEN): GEN {.cdecl,
    importc: "F2xqE_weilpairing", dynlib: libname.}
proc get_F2xqE_group*(E: ptr pointer; a2: GEN; a6: GEN; T: GEN): ptr bb_group {.cdecl,
    importc: "get_F2xqE_group", dynlib: libname.}
proc RgE_to_F2xqE*(x: GEN; T: GEN): GEN {.cdecl, importc: "RgE_to_F2xqE", dynlib: libname.}
proc random_F2xqE*(a2: GEN; a6: GEN; T: GEN): GEN {.cdecl, importc: "random_F2xqE",
    dynlib: libname.}
proc Fl_to_Flx*(x: pari_ulong; sv: clong): GEN {.cdecl, importc: "Fl_to_Flx",
    dynlib: libname.}
proc Flc_to_ZC*(z: GEN): GEN {.cdecl, importc: "Flc_to_ZC", dynlib: libname.}
proc Flm_to_FlxV*(x: GEN; sv: clong): GEN {.cdecl, importc: "Flm_to_FlxV",
                                      dynlib: libname.}
proc Flm_to_FlxX*(x: GEN; v: clong; w: clong): GEN {.cdecl, importc: "Flm_to_FlxX",
    dynlib: libname.}
proc Flm_to_ZM*(z: GEN): GEN {.cdecl, importc: "Flm_to_ZM", dynlib: libname.}
proc Flv_to_Flx*(x: GEN; vs: clong): GEN {.cdecl, importc: "Flv_to_Flx", dynlib: libname.}
proc Flv_to_ZV*(z: GEN): GEN {.cdecl, importc: "Flv_to_ZV", dynlib: libname.}
proc Flv_polint*(xa: GEN; ya: GEN; p: pari_ulong; vs: clong): GEN {.cdecl,
    importc: "Flv_polint", dynlib: libname.}
proc Flv_roots_to_pol*(a: GEN; p: pari_ulong; vs: clong): GEN {.cdecl,
    importc: "Flv_roots_to_pol", dynlib: libname.}
proc Fly_to_FlxY*(B: GEN; v: clong): GEN {.cdecl, importc: "Fly_to_FlxY", dynlib: libname.}
proc Flx_Fl_add*(y: GEN; x: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Flx_Fl_add", dynlib: libname.}
proc Flx_Fl_mul*(y: GEN; x: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Flx_Fl_mul", dynlib: libname.}
proc Flx_Fl_mul_to_monic*(y: GEN; x: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Flx_Fl_mul_to_monic", dynlib: libname.}
proc Flx_Flxq_eval*(f: GEN; x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flx_Flxq_eval", dynlib: libname.}
proc Flx_FlxqV_eval*(f: GEN; x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flx_FlxqV_eval", dynlib: libname.}
proc Flx_add*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_add",
    dynlib: libname.}
proc Flx_deflate*(x0: GEN; d: clong): GEN {.cdecl, importc: "Flx_deflate",
                                      dynlib: libname.}
proc Flx_deriv*(z: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_deriv",
                                        dynlib: libname.}
proc Flx_double*(y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_double",
    dynlib: libname.}
proc Flx_div_by_X_x*(a: GEN; x: pari_ulong; p: pari_ulong; rem: ptr pari_ulong): GEN {.
    cdecl, importc: "Flx_div_by_X_x", dynlib: libname.}
proc Flx_divrem*(x: GEN; y: GEN; p: pari_ulong; pr: ptr GEN): GEN {.cdecl,
    importc: "Flx_divrem", dynlib: libname.}
proc Flx_equal*(V: GEN; W: GEN): cint {.cdecl, importc: "Flx_equal", dynlib: libname.}
proc Flx_eval*(x: GEN; y: pari_ulong; p: pari_ulong): pari_ulong {.cdecl,
    importc: "Flx_eval", dynlib: libname.}
proc Flx_extgcd*(a: GEN; b: GEN; p: pari_ulong; ptu: ptr GEN; ptv: ptr GEN): GEN {.cdecl,
    importc: "Flx_extgcd", dynlib: libname.}
proc Flx_extresultant*(a: GEN; b: GEN; p: pari_ulong; ptU: ptr GEN; ptV: ptr GEN): pari_ulong {.
    cdecl, importc: "Flx_extresultant", dynlib: libname.}
proc Flx_gcd*(a: GEN; b: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_gcd",
    dynlib: libname.}
proc Flx_get_red*(T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_get_red",
    dynlib: libname.}
proc Flx_halfgcd*(a: GEN; b: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_halfgcd",
    dynlib: libname.}
proc Flx_inflate*(x0: GEN; d: clong): GEN {.cdecl, importc: "Flx_inflate",
                                      dynlib: libname.}
proc Flx_invBarrett*(T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_invBarrett",
    dynlib: libname.}
proc Flx_is_squarefree*(z: GEN; p: pari_ulong): cint {.cdecl,
    importc: "Flx_is_squarefree", dynlib: libname.}
proc Flx_is_smooth*(g: GEN; r: clong; p: pari_ulong): cint {.cdecl,
    importc: "Flx_is_smooth", dynlib: libname.}
proc Flx_mod_Xn1*(T: GEN; n: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Flx_mod_Xn1", dynlib: libname.}
proc Flx_mod_Xnm1*(T: GEN; n: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Flx_mod_Xnm1", dynlib: libname.}
proc Flx_mul*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_mul",
    dynlib: libname.}
proc Flx_neg*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_neg", dynlib: libname.}
proc Flx_neg_inplace*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_neg_inplace",
    dynlib: libname.}
proc Flx_normalize*(z: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_normalize",
    dynlib: libname.}
proc Flx_pow*(x: GEN; n: clong; p: pari_ulong): GEN {.cdecl, importc: "Flx_pow",
    dynlib: libname.}
proc Flx_recip*(x: GEN): GEN {.cdecl, importc: "Flx_recip", dynlib: libname.}
proc Flx_red*(z: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_red", dynlib: libname.}
proc Flx_rem*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_rem",
    dynlib: libname.}
proc Flx_renormalize*(x: GEN; par_l: clong): GEN {.cdecl, importc: "Flx_renormalize",
    dynlib: libname.}
proc Flx_resultant*(a: GEN; b: GEN; p: pari_ulong): pari_ulong {.cdecl,
    importc: "Flx_resultant", dynlib: libname.}
proc Flx_shift*(a: GEN; n: clong): GEN {.cdecl, importc: "Flx_shift", dynlib: libname.}
proc Flx_splitting*(p: GEN; k: clong): GEN {.cdecl, importc: "Flx_splitting",
                                       dynlib: libname.}
proc Flx_sqr*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_sqr", dynlib: libname.}
proc Flx_sub*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_sub",
    dynlib: libname.}
proc Flx_to_Flv*(x: GEN; N: clong): GEN {.cdecl, importc: "Flx_to_Flv", dynlib: libname.}
proc Flx_to_FlxX*(z: GEN; v: clong): GEN {.cdecl, importc: "Flx_to_FlxX", dynlib: libname.}
proc Flx_to_ZX*(z: GEN): GEN {.cdecl, importc: "Flx_to_ZX", dynlib: libname.}
proc Flx_to_ZX_inplace*(z: GEN): GEN {.cdecl, importc: "Flx_to_ZX_inplace",
                                   dynlib: libname.}
proc Flx_triple*(y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_triple",
    dynlib: libname.}
proc Flx_val*(x: GEN): clong {.cdecl, importc: "Flx_val", dynlib: libname.}
proc Flx_valrem*(x: GEN; Z: ptr GEN): clong {.cdecl, importc: "Flx_valrem",
                                       dynlib: libname.}
proc FlxC_to_ZXC*(x: GEN): GEN {.cdecl, importc: "FlxC_to_ZXC", dynlib: libname.}
proc FlxM_Flx_add_shallow*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxM_Flx_add_shallow", dynlib: libname.}
proc FlxM_to_ZXM*(z: GEN): GEN {.cdecl, importc: "FlxM_to_ZXM", dynlib: libname.}
proc FlxT_red*(z: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxT_red", dynlib: libname.}
proc FlxV_to_ZXV*(x: GEN): GEN {.cdecl, importc: "FlxV_to_ZXV", dynlib: libname.}
proc FlxV_Flc_mul*(V: GEN; W: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxV_Flc_mul",
    dynlib: libname.}
proc FlxV_red*(z: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxV_red", dynlib: libname.}
proc FlxV_to_Flm*(v: GEN; n: clong): GEN {.cdecl, importc: "FlxV_to_Flm", dynlib: libname.}
proc FlxX_Fl_mul*(x: GEN; y: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "FlxX_Fl_mul", dynlib: libname.}
proc FlxX_Flx_add*(y: GEN; x: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxX_Flx_add",
    dynlib: libname.}
proc FlxX_Flx_mul*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxX_Flx_mul",
    dynlib: libname.}
proc FlxX_add*(P: GEN; Q: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxX_add",
    dynlib: libname.}
proc FlxX_double*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxX_double",
    dynlib: libname.}
proc FlxX_neg*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxX_neg", dynlib: libname.}
proc FlxX_sub*(P: GEN; Q: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxX_sub",
    dynlib: libname.}
proc FlxX_swap*(x: GEN; n: clong; ws: clong): GEN {.cdecl, importc: "FlxX_swap",
    dynlib: libname.}
proc FlxX_renormalize*(x: GEN; lx: clong): GEN {.cdecl, importc: "FlxX_renormalize",
    dynlib: libname.}
proc FlxX_shift*(a: GEN; n: clong): GEN {.cdecl, importc: "FlxX_shift", dynlib: libname.}
proc FlxX_to_Flm*(v: GEN; n: clong): GEN {.cdecl, importc: "FlxX_to_Flm", dynlib: libname.}
proc FlxX_to_FlxC*(x: GEN; N: clong; sv: clong): GEN {.cdecl, importc: "FlxX_to_FlxC",
    dynlib: libname.}
proc FlxX_to_ZXX*(B: GEN): GEN {.cdecl, importc: "FlxX_to_ZXX", dynlib: libname.}
proc FlxX_triple*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxX_triple",
    dynlib: libname.}
proc FlxXV_to_FlxM*(v: GEN; n: clong; sv: clong): GEN {.cdecl, importc: "FlxXV_to_FlxM",
    dynlib: libname.}
proc FlxY_Flxq_evalx*(P: GEN; x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxY_Flxq_evalx", dynlib: libname.}
proc FlxY_Flx_div*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxY_Flx_div",
    dynlib: libname.}
proc FlxY_evalx*(Q: GEN; x: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "FlxY_evalx", dynlib: libname.}
proc FlxYqq_pow*(x: GEN; n: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxYqq_pow", dynlib: libname.}
proc Flxq_autpow*(x: GEN; n: pari_ulong; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_autpow", dynlib: libname.}
proc Flxq_autsum*(x: GEN; n: pari_ulong; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_autsum", dynlib: libname.}
proc Flxq_charpoly*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_charpoly", dynlib: libname.}
proc Flxq_conjvec*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flxq_conjvec",
    dynlib: libname.}
proc Flxq_div*(x: GEN; y: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flxq_div",
    dynlib: libname.}
proc Flxq_inv*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flxq_inv",
    dynlib: libname.}
proc Flxq_invsafe*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flxq_invsafe",
    dynlib: libname.}
proc Flxq_issquare*(x: GEN; T: GEN; p: pari_ulong): cint {.cdecl,
    importc: "Flxq_issquare", dynlib: libname.}
proc Flxq_is2npower*(x: GEN; n: clong; T: GEN; p: pari_ulong): cint {.cdecl,
    importc: "Flxq_is2npower", dynlib: libname.}
proc Flxq_log*(a: GEN; g: GEN; ord: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_log", dynlib: libname.}
proc Flxq_lroot*(a: GEN; T: GEN; p: clong): GEN {.cdecl, importc: "Flxq_lroot",
    dynlib: libname.}
proc Flxq_lroot_fast*(a: GEN; sqx: GEN; T: GEN; p: clong): GEN {.cdecl,
    importc: "Flxq_lroot_fast", dynlib: libname.}
proc Flxq_matrix_pow*(y: GEN; n: clong; m: clong; P: GEN; par_l: pari_ulong): GEN {.cdecl,
    importc: "Flxq_matrix_pow", dynlib: libname.}
proc Flxq_minpoly*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flxq_minpoly",
    dynlib: libname.}
proc Flxq_mul*(x: GEN; y: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flxq_mul",
    dynlib: libname.}
proc Flxq_norm*(x: GEN; T: GEN; p: pari_ulong): pari_ulong {.cdecl, importc: "Flxq_norm",
    dynlib: libname.}
proc Flxq_order*(a: GEN; ord: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_order", dynlib: libname.}
proc Flxq_pow*(x: GEN; n: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flxq_pow",
    dynlib: libname.}
proc Flxq_powu*(x: GEN; n: pari_ulong; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_powu", dynlib: libname.}
proc Flxq_powers*(x: GEN; par_l: clong; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_powers", dynlib: libname.}
proc Flxq_sqr*(y: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flxq_sqr",
    dynlib: libname.}
proc Flxq_sqrt*(a: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flxq_sqrt",
    dynlib: libname.}
proc Flxq_sqrtn*(a: GEN; n: GEN; T: GEN; p: pari_ulong; zetan: ptr GEN): GEN {.cdecl,
    importc: "Flxq_sqrtn", dynlib: libname.}
proc Flxq_trace*(x: GEN; T: GEN; p: pari_ulong): pari_ulong {.cdecl,
    importc: "Flxq_trace", dynlib: libname.}
proc FlxqV_dotproduct*(x: GEN; y: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqV_dotproduct", dynlib: libname.}
proc FlxqV_roots_to_pol*(V: GEN; T: GEN; p: pari_ulong; v: clong): GEN {.cdecl,
    importc: "FlxqV_roots_to_pol", dynlib: libname.}
proc FlxqX_FlxqXQ_eval*(Q: GEN; x: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_FlxqXQ_eval", dynlib: libname.}
proc FlxqX_FlxqXQV_eval*(P: GEN; V: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_FlxqXQV_eval", dynlib: libname.}
proc FlxqX_Flxq_mul*(P: GEN; U: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_Flxq_mul", dynlib: libname.}
proc FlxqX_Flxq_mul_to_monic*(P: GEN; U: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_Flxq_mul_to_monic", dynlib: libname.}
proc FlxqX_divrem*(x: GEN; y: GEN; T: GEN; p: pari_ulong; pr: ptr GEN): GEN {.cdecl,
    importc: "FlxqX_divrem", dynlib: libname.}
proc FlxqX_extgcd*(a: GEN; b: GEN; T: GEN; p: pari_ulong; ptu: ptr GEN; ptv: ptr GEN): GEN {.
    cdecl, importc: "FlxqX_extgcd", dynlib: libname.}
proc FlxqX_gcd*(P: GEN; Q: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqX_gcd",
    dynlib: libname.}
proc FlxqX_invBarrett*(T: GEN; Q: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_invBarrett", dynlib: libname.}
proc FlxqX_mul*(x: GEN; y: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqX_mul",
    dynlib: libname.}
proc FlxqX_normalize*(z: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_normalize", dynlib: libname.}
proc FlxqX_pow*(V: GEN; n: clong; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_pow", dynlib: libname.}
proc FlxqX_red*(z: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqX_red",
    dynlib: libname.}
proc FlxqX_rem_Barrett*(x: GEN; mg: GEN; T: GEN; Q: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_rem_Barrett", dynlib: libname.}
proc FlxqX_safegcd*(P: GEN; Q: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_safegcd", dynlib: libname.}
proc FlxqX_sqr*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqX_sqr",
    dynlib: libname.}
proc FlxqXQ_div*(x: GEN; y: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQ_div", dynlib: libname.}
proc FlxqXQ_inv*(x: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQ_inv", dynlib: libname.}
proc FlxqXQ_invsafe*(x: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQ_invsafe", dynlib: libname.}
proc FlxqXQ_matrix_pow*(x: GEN; n: clong; m: clong; S: GEN; T: GEN; p: pari_ulong): GEN {.
    cdecl, importc: "FlxqXQ_matrix_pow", dynlib: libname.}
proc FlxqXQ_mul*(x: GEN; y: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQ_mul", dynlib: libname.}
proc FlxqXQ_pow*(x: GEN; n: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQ_pow", dynlib: libname.}
proc FlxqXQ_powers*(x: GEN; n: clong; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQ_powers", dynlib: libname.}
proc FlxqXQ_sqr*(x: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQ_sqr", dynlib: libname.}
proc FlxqXQV_autpow*(x: GEN; n: clong; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQV_autpow", dynlib: libname.}
proc FlxqXV_prod*(V: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqXV_prod",
    dynlib: libname.}
proc Kronecker_to_FlxqX*(z: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Kronecker_to_FlxqX", dynlib: libname.}
proc Rg_to_F2*(x: GEN): pari_ulong {.cdecl, importc: "Rg_to_F2", dynlib: libname.}
proc Rg_to_Fl*(x: GEN; p: pari_ulong): pari_ulong {.cdecl, importc: "Rg_to_Fl",
    dynlib: libname.}
proc Rg_to_Flxq*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "Rg_to_Flxq",
    dynlib: libname.}
proc RgX_to_Flx*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "RgX_to_Flx",
    dynlib: libname.}
proc Z_to_Flx*(x: GEN; p: pari_ulong; v: clong): GEN {.cdecl, importc: "Z_to_Flx",
    dynlib: libname.}
proc ZX_to_Flx*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "ZX_to_Flx",
                                        dynlib: libname.}
proc ZXV_to_FlxV*(v: GEN; p: pari_ulong): GEN {.cdecl, importc: "ZXV_to_FlxV",
    dynlib: libname.}
proc ZXX_to_FlxX*(B: GEN; p: pari_ulong; v: clong): GEN {.cdecl, importc: "ZXX_to_FlxX",
    dynlib: libname.}
proc ZXXV_to_FlxXV*(V: GEN; p: pari_ulong; v: clong): GEN {.cdecl,
    importc: "ZXXV_to_FlxXV", dynlib: libname.}
proc gener_Flxq*(T: GEN; p: pari_ulong; o: ptr GEN): GEN {.cdecl, importc: "gener_Flxq",
    dynlib: libname.}
proc get_Flx_degree*(T: GEN): clong {.cdecl, importc: "get_Flx_degree", dynlib: libname.}
proc get_Flx_mod*(T: GEN): GEN {.cdecl, importc: "get_Flx_mod", dynlib: libname.}
proc get_Flx_var*(T: GEN): clong {.cdecl, importc: "get_Flx_var", dynlib: libname.}
proc get_Flxq_field*(E: ptr pointer; T: GEN; p: pari_ulong): ptr bb_field {.cdecl,
    importc: "get_Flxq_field", dynlib: libname.}
proc pol1_FlxX*(v: clong; sv: clong): GEN {.cdecl, importc: "pol1_FlxX", dynlib: libname.}
proc polx_FlxX*(v: clong; sv: clong): GEN {.cdecl, importc: "polx_FlxX", dynlib: libname.}
proc random_Flx*(d1: clong; v: clong; p: pari_ulong): GEN {.cdecl, importc: "random_Flx",
    dynlib: libname.}
proc zxX_to_Kronecker*(P: GEN; Q: GEN): GEN {.cdecl, importc: "zxX_to_Kronecker",
                                        dynlib: libname.}
proc Flxq_ellcard*(a4: GEN; a6: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_ellcard", dynlib: libname.}
proc Flxq_ellgens*(a4: GEN; a6: GEN; ch: GEN; D: GEN; m: GEN; T: GEN; p: pari_ulong): GEN {.
    cdecl, importc: "Flxq_ellgens", dynlib: libname.}
proc Flxq_ellgroup*(a4: GEN; a6: GEN; N: GEN; T: GEN; p: pari_ulong; pt_m: ptr GEN): GEN {.
    cdecl, importc: "Flxq_ellgroup", dynlib: libname.}
proc Flxq_ellj*(a4: GEN; a6: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_ellj", dynlib: libname.}
proc FlxqE_add*(P: GEN; Q: GEN; a4: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqE_add", dynlib: libname.}
proc FlxqE_changepoint*(x: GEN; ch: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqE_changepoint", dynlib: libname.}
proc FlxqE_changepointinv*(x: GEN; ch: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqE_changepointinv", dynlib: libname.}
proc FlxqE_dbl*(P: GEN; a4: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqE_dbl",
    dynlib: libname.}
proc FlxqE_log*(a: GEN; b: GEN; o: GEN; a4: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqE_log", dynlib: libname.}
proc FlxqE_mul*(P: GEN; n: GEN; a4: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqE_mul", dynlib: libname.}
proc FlxqE_neg*(P: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqE_neg",
    dynlib: libname.}
proc FlxqE_order*(z: GEN; o: GEN; a4: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqE_order", dynlib: libname.}
proc FlxqE_sub*(P: GEN; Q: GEN; a4: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqE_sub", dynlib: libname.}
proc FlxqE_tatepairing*(t: GEN; s: GEN; m: GEN; a4: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqE_tatepairing", dynlib: libname.}
proc FlxqE_weilpairing*(t: GEN; s: GEN; m: GEN; a4: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqE_weilpairing", dynlib: libname.}
proc get_FlxqE_group*(E: ptr pointer; a4: GEN; a6: GEN; T: GEN; p: pari_ulong): ptr bb_group {.
    cdecl, importc: "get_FlxqE_group", dynlib: libname.}
proc RgE_to_FlxqE*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "RgE_to_FlxqE",
    dynlib: libname.}
proc random_FlxqE*(a4: GEN; a6: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "random_FlxqE", dynlib: libname.}
proc Fl_elltrace*(a4: pari_ulong; a6: pari_ulong; p: pari_ulong): clong {.cdecl,
    importc: "Fl_elltrace", dynlib: libname.}
proc Fle_add*(P: GEN; Q: GEN; a4: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Fle_add", dynlib: libname.}
proc Fle_dbl*(P: GEN; a4: pari_ulong; p: pari_ulong): GEN {.cdecl, importc: "Fle_dbl",
    dynlib: libname.}
proc Fle_mul*(P: GEN; n: GEN; a4: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Fle_mul", dynlib: libname.}
proc Fle_mulu*(P: GEN; n: pari_ulong; a4: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Fle_mulu", dynlib: libname.}
proc Fle_order*(z: GEN; o: GEN; a4: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Fle_order", dynlib: libname.}
proc Fle_sub*(P: GEN; Q: GEN; a4: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Fle_sub", dynlib: libname.}
proc Fp_ellcard*(a4: GEN; a6: GEN; p: GEN): GEN {.cdecl, importc: "Fp_ellcard",
    dynlib: libname.}
proc Fp_elldivpol*(a4: GEN; a6: GEN; n: clong; p: GEN): GEN {.cdecl,
    importc: "Fp_elldivpol", dynlib: libname.}
proc Fp_ellgens*(a4: GEN; a6: GEN; ch: GEN; D: GEN; m: GEN; p: GEN): GEN {.cdecl,
    importc: "Fp_ellgens", dynlib: libname.}
proc Fp_ellgroup*(a4: GEN; a6: GEN; N: GEN; p: GEN; pt_m: ptr GEN): GEN {.cdecl,
    importc: "Fp_ellgroup", dynlib: libname.}
proc Fp_ellj*(a4: GEN; a6: GEN; p: GEN): GEN {.cdecl, importc: "Fp_ellj", dynlib: libname.}
proc Fp_ffellcard*(a4: GEN; a6: GEN; q: GEN; n: clong; p: GEN): GEN {.cdecl,
    importc: "Fp_ffellcard", dynlib: libname.}
proc FpE_add*(P: GEN; Q: GEN; a4: GEN; p: GEN): GEN {.cdecl, importc: "FpE_add",
    dynlib: libname.}
proc FpE_changepoint*(x: GEN; ch: GEN; p: GEN): GEN {.cdecl, importc: "FpE_changepoint",
    dynlib: libname.}
proc FpE_changepointinv*(x: GEN; ch: GEN; p: GEN): GEN {.cdecl,
    importc: "FpE_changepointinv", dynlib: libname.}
proc FpE_dbl*(P: GEN; a4: GEN; p: GEN): GEN {.cdecl, importc: "FpE_dbl", dynlib: libname.}
proc FpE_log*(a: GEN; b: GEN; o: GEN; a4: GEN; p: GEN): GEN {.cdecl, importc: "FpE_log",
    dynlib: libname.}
proc FpE_mul*(P: GEN; n: GEN; a4: GEN; p: GEN): GEN {.cdecl, importc: "FpE_mul",
    dynlib: libname.}
proc FpE_neg*(P: GEN; p: GEN): GEN {.cdecl, importc: "FpE_neg", dynlib: libname.}
proc FpE_order*(z: GEN; o: GEN; a4: GEN; p: GEN): GEN {.cdecl, importc: "FpE_order",
    dynlib: libname.}
proc FpE_sub*(P: GEN; Q: GEN; a4: GEN; p: GEN): GEN {.cdecl, importc: "FpE_sub",
    dynlib: libname.}
proc FpE_to_mod*(P: GEN; p: GEN): GEN {.cdecl, importc: "FpE_to_mod", dynlib: libname.}
proc FpE_tatepairing*(t: GEN; s: GEN; m: GEN; a4: GEN; p: GEN): GEN {.cdecl,
    importc: "FpE_tatepairing", dynlib: libname.}
proc FpE_weilpairing*(t: GEN; s: GEN; m: GEN; a4: GEN; p: GEN): GEN {.cdecl,
    importc: "FpE_weilpairing", dynlib: libname.}
proc FpXQ_ellcard*(a4: GEN; a6: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_ellcard",
    dynlib: libname.}
proc FpXQ_elldivpol*(a4: GEN; a6: GEN; n: clong; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQ_elldivpol", dynlib: libname.}
proc FpXQ_ellgens*(a4: GEN; a6: GEN; ch: GEN; D: GEN; m: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQ_ellgens", dynlib: libname.}
proc FpXQ_ellgroup*(a4: GEN; a6: GEN; N: GEN; T: GEN; p: GEN; pt_m: ptr GEN): GEN {.cdecl,
    importc: "FpXQ_ellgroup", dynlib: libname.}
proc FpXQ_ellj*(a4: GEN; a6: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_ellj",
    dynlib: libname.}
proc FpXQE_add*(P: GEN; Q: GEN; a4: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQE_add",
    dynlib: libname.}
proc FpXQE_changepoint*(x: GEN; ch: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQE_changepoint", dynlib: libname.}
proc FpXQE_changepointinv*(x: GEN; ch: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQE_changepointinv", dynlib: libname.}
proc FpXQE_dbl*(P: GEN; a4: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQE_dbl",
    dynlib: libname.}
proc FpXQE_log*(a: GEN; b: GEN; o: GEN; a4: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQE_log", dynlib: libname.}
proc FpXQE_mul*(P: GEN; n: GEN; a4: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQE_mul",
    dynlib: libname.}
proc FpXQE_neg*(P: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQE_neg", dynlib: libname.}
proc FpXQE_order*(z: GEN; o: GEN; a4: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQE_order", dynlib: libname.}
proc FpXQE_sub*(P: GEN; Q: GEN; a4: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQE_sub",
    dynlib: libname.}
proc FpXQE_tatepairing*(t: GEN; s: GEN; m: GEN; a4: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQE_tatepairing", dynlib: libname.}
proc FpXQE_weilpairing*(t: GEN; s: GEN; m: GEN; a4: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQE_weilpairing", dynlib: libname.}
proc Fq_elldivpolmod*(a4: GEN; a6: GEN; n: clong; h: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "Fq_elldivpolmod", dynlib: libname.}
proc RgE_to_FpE*(x: GEN; p: GEN): GEN {.cdecl, importc: "RgE_to_FpE", dynlib: libname.}
proc RgE_to_FpXQE*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "RgE_to_FpXQE",
    dynlib: libname.}
proc get_FpE_group*(E: ptr pointer; a4: GEN; a6: GEN; p: GEN): ptr bb_group {.cdecl,
    importc: "get_FpE_group", dynlib: libname.}
proc get_FpXQE_group*(E: ptr pointer; a4: GEN; a6: GEN; T: GEN; p: GEN): ptr bb_group {.cdecl,
    importc: "get_FpXQE_group", dynlib: libname.}
proc elltrace_extension*(t: GEN; n: clong; p: GEN): GEN {.cdecl,
    importc: "elltrace_extension", dynlib: libname.}
proc random_Fle*(a4: pari_ulong; a6: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "random_Fle", dynlib: libname.}
proc random_FpE*(a4: GEN; a6: GEN; p: GEN): GEN {.cdecl, importc: "random_FpE",
    dynlib: libname.}
proc random_FpXQE*(a4: GEN; a6: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "random_FpXQE",
    dynlib: libname.}
proc Fp_issquare*(x: GEN; p: GEN): cint {.cdecl, importc: "Fp_issquare", dynlib: libname.}
proc Fp_FpX_sub*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "Fp_FpX_sub",
                                        dynlib: libname.}
proc Fp_FpXQ_log*(a: GEN; g: GEN; ord: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "Fp_FpXQ_log", dynlib: libname.}
proc FpV_inv*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpV_inv", dynlib: libname.}
proc FpV_roots_to_pol*(V: GEN; p: GEN; v: clong): GEN {.cdecl,
    importc: "FpV_roots_to_pol", dynlib: libname.}
proc FpX_Fp_add*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_Fp_add",
                                        dynlib: libname.}
proc FpX_Fp_add_shallow*(y: GEN; x: GEN; p: GEN): GEN {.cdecl,
    importc: "FpX_Fp_add_shallow", dynlib: libname.}
proc FpX_Fp_mul*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_Fp_mul",
                                        dynlib: libname.}
proc FpX_Fp_mul_to_monic*(y: GEN; x: GEN; p: GEN): GEN {.cdecl,
    importc: "FpX_Fp_mul_to_monic", dynlib: libname.}
proc FpX_Fp_mulspec*(y: GEN; x: GEN; p: GEN; ly: clong): GEN {.cdecl,
    importc: "FpX_Fp_mulspec", dynlib: libname.}
proc FpX_Fp_sub*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_Fp_sub",
                                        dynlib: libname.}
proc FpX_Fp_sub_shallow*(y: GEN; x: GEN; p: GEN): GEN {.cdecl,
    importc: "FpX_Fp_sub_shallow", dynlib: libname.}
proc FpX_FpXQ_eval*(f: GEN; x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpX_FpXQ_eval",
    dynlib: libname.}
proc FpX_FpXQV_eval*(f: GEN; x: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpX_FpXQV_eval", dynlib: libname.}
proc FpX_add*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_add", dynlib: libname.}
proc FpX_center*(x: GEN; p: GEN; pov2: GEN): GEN {.cdecl, importc: "FpX_center",
    dynlib: libname.}
proc FpX_chinese_coprime*(x: GEN; y: GEN; Tx: GEN; Ty: GEN; Tz: GEN; p: GEN): GEN {.cdecl,
    importc: "FpX_chinese_coprime", dynlib: libname.}
proc FpX_deriv*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpX_deriv", dynlib: libname.}
proc FpX_disc*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpX_disc", dynlib: libname.}
proc FpX_div_by_X_x*(a: GEN; x: GEN; p: GEN; r: ptr GEN): GEN {.cdecl,
    importc: "FpX_div_by_X_x", dynlib: libname.}
proc FpX_divrem*(x: GEN; y: GEN; p: GEN; pr: ptr GEN): GEN {.cdecl, importc: "FpX_divrem",
    dynlib: libname.}
proc FpX_eval*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_eval", dynlib: libname.}
proc FpX_extgcd*(x: GEN; y: GEN; p: GEN; ptu: ptr GEN; ptv: ptr GEN): GEN {.cdecl,
    importc: "FpX_extgcd", dynlib: libname.}
proc FpX_gcd*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_gcd", dynlib: libname.}
proc FpX_get_red*(T: GEN; p: GEN): GEN {.cdecl, importc: "FpX_get_red", dynlib: libname.}
proc FpX_halfgcd*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_halfgcd",
    dynlib: libname.}
proc FpX_invBarrett*(T: GEN; p: GEN): GEN {.cdecl, importc: "FpX_invBarrett",
                                      dynlib: libname.}
proc FpX_is_squarefree*(f: GEN; p: GEN): cint {.cdecl, importc: "FpX_is_squarefree",
    dynlib: libname.}
proc FpX_mul*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_mul", dynlib: libname.}
proc FpX_mulspec*(a: GEN; b: GEN; p: GEN; na: clong; nb: clong): GEN {.cdecl,
    importc: "FpX_mulspec", dynlib: libname.}
proc FpX_mulu*(x: GEN; y: pari_ulong; p: GEN): GEN {.cdecl, importc: "FpX_mulu",
    dynlib: libname.}
proc FpX_neg*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpX_neg", dynlib: libname.}
proc FpX_normalize*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpX_normalize",
                                     dynlib: libname.}
proc FpX_red*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpX_red", dynlib: libname.}
proc FpX_rem*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_rem", dynlib: libname.}
proc FpX_rescale*(P: GEN; h: GEN; p: GEN): GEN {.cdecl, importc: "FpX_rescale",
    dynlib: libname.}
proc FpX_resultant*(a: GEN; b: GEN; p: GEN): GEN {.cdecl, importc: "FpX_resultant",
    dynlib: libname.}
proc FpX_sqr*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpX_sqr", dynlib: libname.}
proc FpX_sub*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpX_sub", dynlib: libname.}
proc FpX_valrem*(x0: GEN; t: GEN; p: GEN; py: ptr GEN): clong {.cdecl,
    importc: "FpX_valrem", dynlib: libname.}
proc FpXQ_autpow*(x: GEN; n: pari_ulong; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQ_autpow", dynlib: libname.}
proc FpXQ_autpowers*(aut: GEN; f: clong; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQ_autpowers", dynlib: libname.}
proc FpXQ_autsum*(x: GEN; n: pari_ulong; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQ_autsum", dynlib: libname.}
proc FpXQ_charpoly*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_charpoly",
    dynlib: libname.}
proc FpXQ_conjvec*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_conjvec",
    dynlib: libname.}
proc FpXQ_div*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_div",
    dynlib: libname.}
proc FpXQ_inv*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_inv", dynlib: libname.}
proc FpXQ_invsafe*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_invsafe",
    dynlib: libname.}
proc FpXQ_issquare*(x: GEN; T: GEN; p: GEN): cint {.cdecl, importc: "FpXQ_issquare",
    dynlib: libname.}
proc FpXQ_log*(a: GEN; g: GEN; ord: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_log",
    dynlib: libname.}
proc FpXQ_matrix_pow*(y: GEN; n: clong; m: clong; P: GEN; par1: GEN): GEN {.cdecl,
    importc: "FpXQ_matrix_pow", dynlib: libname.}
proc FpXQ_minpoly*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_minpoly",
    dynlib: libname.}
proc FpXQ_mul*(y: GEN; x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_mul",
    dynlib: libname.}
proc FpXQ_norm*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_norm", dynlib: libname.}
proc FpXQ_order*(a: GEN; ord: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_order",
    dynlib: libname.}
proc FpXQ_pow*(x: GEN; n: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_pow",
    dynlib: libname.}
proc FpXQ_powu*(x: GEN; n: pari_ulong; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_powu",
    dynlib: libname.}
proc FpXQ_powers*(x: GEN; par_l: clong; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQ_powers", dynlib: libname.}
proc FpXQ_red*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_red", dynlib: libname.}
proc FpXQ_sqr*(y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_sqr", dynlib: libname.}
proc FpXQ_sqrt*(a: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_sqrt", dynlib: libname.}
proc FpXQ_sqrtn*(a: GEN; n: GEN; T: GEN; p: GEN; zetan: ptr GEN): GEN {.cdecl,
    importc: "FpXQ_sqrtn", dynlib: libname.}
proc FpXQ_trace*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_trace",
                                        dynlib: libname.}
proc FpXQC_to_mod*(z: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQC_to_mod",
    dynlib: libname.}
proc FpXT_red*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpXT_red", dynlib: libname.}
proc FpXV_prod*(V: GEN; p: GEN): GEN {.cdecl, importc: "FpXV_prod", dynlib: libname.}
proc FpXV_red*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpXV_red", dynlib: libname.}
proc Fq_issquare*(x: GEN; T: GEN; p: GEN): cint {.cdecl, importc: "Fq_issquare",
    dynlib: libname.}
proc FqV_inv*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqV_inv", dynlib: libname.}
proc Z_to_FpX*(a: GEN; p: GEN; v: clong): GEN {.cdecl, importc: "Z_to_FpX", dynlib: libname.}
proc gener_FpXQ*(T: GEN; p: GEN; o: ptr GEN): GEN {.cdecl, importc: "gener_FpXQ",
    dynlib: libname.}
proc gener_FpXQ_local*(T: GEN; p: GEN; L: GEN): GEN {.cdecl, importc: "gener_FpXQ_local",
    dynlib: libname.}
proc get_FpX_degree*(T: GEN): clong {.cdecl, importc: "get_FpX_degree", dynlib: libname.}
proc get_FpX_mod*(T: GEN): GEN {.cdecl, importc: "get_FpX_mod", dynlib: libname.}
proc get_FpX_var*(T: GEN): clong {.cdecl, importc: "get_FpX_var", dynlib: libname.}
proc get_FpXQ_star*(E: ptr pointer; T: GEN; p: GEN): ptr bb_group {.cdecl,
    importc: "get_FpXQ_star", dynlib: libname.}
proc random_FpX*(d: clong; v: clong; p: GEN): GEN {.cdecl, importc: "random_FpX",
    dynlib: libname.}
proc F2x_factor*(f: GEN): GEN {.cdecl, importc: "F2x_factor", dynlib: libname.}
proc F2x_is_irred*(f: GEN): cint {.cdecl, importc: "F2x_is_irred", dynlib: libname.}
proc F2xV_to_FlxV_inplace*(v: GEN) {.cdecl, importc: "F2xV_to_FlxV_inplace",
                                  dynlib: libname.}
proc F2xV_to_ZXV_inplace*(v: GEN) {.cdecl, importc: "F2xV_to_ZXV_inplace",
                                 dynlib: libname.}
proc Flx_is_irred*(f: GEN; p: pari_ulong): cint {.cdecl, importc: "Flx_is_irred",
    dynlib: libname.}
proc Flx_degfact*(f: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_degfact",
    dynlib: libname.}
proc Flx_factor*(f: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_factor",
    dynlib: libname.}
proc Flx_nbfact*(z: GEN; p: pari_ulong): clong {.cdecl, importc: "Flx_nbfact",
    dynlib: libname.}
proc Flx_nbfact_by_degree*(z: GEN; nb: ptr clong; p: pari_ulong): GEN {.cdecl,
    importc: "Flx_nbfact_by_degree", dynlib: libname.}
proc Flx_nbroots*(f: GEN; p: pari_ulong): clong {.cdecl, importc: "Flx_nbroots",
    dynlib: libname.}
proc Flx_oneroot*(f: GEN; p: pari_ulong): pari_ulong {.cdecl, importc: "Flx_oneroot",
    dynlib: libname.}
proc Flx_roots*(f: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_roots",
                                        dynlib: libname.}
proc FlxqX_Frobenius*(S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqX_Frobenius", dynlib: libname.}
proc FlxqXQ_halfFrobenius*(a: GEN; S: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqXQ_halfFrobenius", dynlib: libname.}
proc FlxqX_nbroots*(f: GEN; T: GEN; p: pari_ulong): clong {.cdecl,
    importc: "FlxqX_nbroots", dynlib: libname.}
proc FlxV_to_ZXV_inplace*(v: GEN) {.cdecl, importc: "FlxV_to_ZXV_inplace",
                                 dynlib: libname.}
proc FpX_degfact*(f: GEN; p: GEN): GEN {.cdecl, importc: "FpX_degfact", dynlib: libname.}
proc FpX_is_irred*(f: GEN; p: GEN): cint {.cdecl, importc: "FpX_is_irred",
                                     dynlib: libname.}
proc FpX_is_totally_split*(f: GEN; p: GEN): cint {.cdecl,
    importc: "FpX_is_totally_split", dynlib: libname.}
proc FpX_factor*(f: GEN; p: GEN): GEN {.cdecl, importc: "FpX_factor", dynlib: libname.}
proc FpX_factorff*(P: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpX_factorff",
    dynlib: libname.}
proc FpX_nbfact*(f: GEN; p: GEN): clong {.cdecl, importc: "FpX_nbfact", dynlib: libname.}
proc FpX_nbroots*(f: GEN; p: GEN): clong {.cdecl, importc: "FpX_nbroots", dynlib: libname.}
proc FpX_oneroot*(f: GEN; p: GEN): GEN {.cdecl, importc: "FpX_oneroot", dynlib: libname.}
proc FpX_roots*(f: GEN; p: GEN): GEN {.cdecl, importc: "FpX_roots", dynlib: libname.}
proc FpX_rootsff*(P: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpX_rootsff",
    dynlib: libname.}
proc FpXQX_Frobenius*(S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQX_Frobenius",
    dynlib: libname.}
proc FpXQX_nbfact*(u: GEN; T: GEN; p: GEN): clong {.cdecl, importc: "FpXQX_nbfact",
    dynlib: libname.}
proc FpXQX_nbroots*(f: GEN; T: GEN; p: GEN): clong {.cdecl, importc: "FpXQX_nbroots",
    dynlib: libname.}
proc FpXQXQ_halfFrobenius*(a: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQXQ_halfFrobenius", dynlib: libname.}
proc FqX_deriv*(f: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqX_deriv", dynlib: libname.}
proc FqX_factor*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqX_factor",
                                        dynlib: libname.}
proc FqX_is_squarefree*(P: GEN; T: GEN; p: GEN): clong {.cdecl,
    importc: "FqX_is_squarefree", dynlib: libname.}
proc FqX_nbfact*(u: GEN; T: GEN; p: GEN): clong {.cdecl, importc: "FqX_nbfact",
    dynlib: libname.}
proc FqX_nbroots*(f: GEN; T: GEN; p: GEN): clong {.cdecl, importc: "FqX_nbroots",
    dynlib: libname.}
proc FqX_roots*(f: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqX_roots", dynlib: libname.}
proc factcantor*(x: GEN; p: GEN): GEN {.cdecl, importc: "factcantor", dynlib: libname.}
proc factorff*(f: GEN; p: GEN; a: GEN): GEN {.cdecl, importc: "factorff", dynlib: libname.}
proc factormod0*(f: GEN; p: GEN; flag: clong): GEN {.cdecl, importc: "factormod0",
    dynlib: libname.}
proc polrootsff*(f: GEN; p: GEN; T: GEN): GEN {.cdecl, importc: "polrootsff",
                                        dynlib: libname.}
proc rootmod0*(f: GEN; p: GEN; flag: clong): GEN {.cdecl, importc: "rootmod0",
    dynlib: libname.}
proc FpXQX_FpXQ_mul*(P: GEN; U: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQX_FpXQ_mul", dynlib: libname.}
proc FpXQX_FpXQXQV_eval*(P: GEN; V: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQX_FpXQXQV_eval", dynlib: libname.}
proc FpXQX_FpXQXQ_eval*(P: GEN; x: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQX_FpXQXQ_eval", dynlib: libname.}
proc FpXQX_divrem*(x: GEN; y: GEN; T: GEN; p: GEN; pr: ptr GEN): GEN {.cdecl,
    importc: "FpXQX_divrem", dynlib: libname.}
proc FpXQX_divrem_Barrett*(x: GEN; B: GEN; S: GEN; T: GEN; p: GEN; pr: ptr GEN): GEN {.cdecl,
    importc: "FpXQX_divrem_Barrett", dynlib: libname.}
proc FpXQX_extgcd*(x: GEN; y: GEN; T: GEN; p: GEN; ptu: ptr GEN; ptv: ptr GEN): GEN {.cdecl,
    importc: "FpXQX_extgcd", dynlib: libname.}
proc FpXQX_gcd*(P: GEN; Q: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQX_gcd",
    dynlib: libname.}
proc FpXQX_invBarrett*(S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQX_invBarrett",
    dynlib: libname.}
proc FpXQX_mul*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQX_mul",
    dynlib: libname.}
proc FpXQX_red*(z: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQX_red", dynlib: libname.}
proc FpXQX_rem*(x: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQX_rem",
    dynlib: libname.}
proc FpXQX_rem_Barrett*(x: GEN; mg: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQX_rem_Barrett", dynlib: libname.}
proc FpXQX_sqr*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQX_sqr", dynlib: libname.}
proc FpXQXQ_div*(x: GEN; y: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQXQ_div",
    dynlib: libname.}
proc FpXQXQ_inv*(x: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQXQ_inv",
    dynlib: libname.}
proc FpXQXQ_invsafe*(x: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQXQ_invsafe", dynlib: libname.}
proc FpXQXQ_matrix_pow*(y: GEN; n: clong; m: clong; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQXQ_matrix_pow", dynlib: libname.}
proc FpXQXQ_mul*(x: GEN; y: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQXQ_mul",
    dynlib: libname.}
proc FpXQXQ_pow*(x: GEN; n: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQXQ_pow",
    dynlib: libname.}
proc FpXQXQ_powers*(x: GEN; n: clong; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQXQ_powers", dynlib: libname.}
proc FpXQXQ_sqr*(x: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXQXQ_sqr",
    dynlib: libname.}
proc FpXQXQV_autpow*(aut: GEN; n: clong; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQXQV_autpow", dynlib: libname.}
proc FpXQXQV_autsum*(aut: GEN; n: clong; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXQXQV_autsum", dynlib: libname.}
proc FpXQXV_prod*(V: GEN; Tp: GEN; p: GEN): GEN {.cdecl, importc: "FpXQXV_prod",
    dynlib: libname.}
proc FpXX_Fp_mul*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpXX_Fp_mul",
    dynlib: libname.}
proc FpXX_FpX_mul*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpXX_FpX_mul",
    dynlib: libname.}
proc FpXX_add*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpXX_add", dynlib: libname.}
proc FpXX_mulu*(P: GEN; u: pari_ulong; p: GEN): GEN {.cdecl, importc: "FpXX_mulu",
    dynlib: libname.}
proc FpXX_neg*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpXX_neg", dynlib: libname.}
proc FpXX_red*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpXX_red", dynlib: libname.}
proc FpXX_sub*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpXX_sub", dynlib: libname.}
proc FpXY_FpXQ_evalx*(P: GEN; x: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FpXY_FpXQ_evalx", dynlib: libname.}
proc FpXY_eval*(Q: GEN; y: GEN; x: GEN; p: GEN): GEN {.cdecl, importc: "FpXY_eval",
    dynlib: libname.}
proc FpXY_evalx*(Q: GEN; x: GEN; p: GEN): GEN {.cdecl, importc: "FpXY_evalx",
                                        dynlib: libname.}
proc FpXY_evaly*(Q: GEN; y: GEN; p: GEN; vy: clong): GEN {.cdecl, importc: "FpXY_evaly",
    dynlib: libname.}
proc FpXYQQ_pow*(x: GEN; n: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FpXYQQ_pow",
    dynlib: libname.}
proc Kronecker_to_FpXQX*(z: GEN; pol: GEN; p: GEN): GEN {.cdecl,
    importc: "Kronecker_to_FpXQX", dynlib: libname.}
proc Kronecker_to_ZXX*(z: GEN; N: clong; v: clong): GEN {.cdecl,
    importc: "Kronecker_to_ZXX", dynlib: libname.}
proc ZXX_mul_Kronecker*(x: GEN; y: GEN; n: clong): GEN {.cdecl,
    importc: "ZXX_mul_Kronecker", dynlib: libname.}
proc F2m_F2c_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "F2m_F2c_mul", dynlib: libname.}
proc F2m_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "F2m_mul", dynlib: libname.}
proc F2m_powu*(x: GEN; n: pari_ulong): GEN {.cdecl, importc: "F2m_powu", dynlib: libname.}
proc Flc_Fl_div*(x: GEN; y: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Flc_Fl_div", dynlib: libname.}
proc Flc_Fl_div_inplace*(x: GEN; y: pari_ulong; p: pari_ulong) {.cdecl,
    importc: "Flc_Fl_div_inplace", dynlib: libname.}
proc Flc_Fl_mul*(x: GEN; y: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Flc_Fl_mul", dynlib: libname.}
proc Flc_Fl_mul_inplace*(x: GEN; y: pari_ulong; p: pari_ulong) {.cdecl,
    importc: "Flc_Fl_mul_inplace", dynlib: libname.}
proc Flc_Fl_mul_part_inplace*(x: GEN; y: pari_ulong; p: pari_ulong; par_l: clong) {.
    cdecl, importc: "Flc_Fl_mul_part_inplace", dynlib: libname.}
proc Flc_to_mod*(z: GEN; pp: pari_ulong): GEN {.cdecl, importc: "Flc_to_mod",
    dynlib: libname.}
proc Flm_Fl_add*(x: GEN; y: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Flm_Fl_add", dynlib: libname.}
proc Flm_Fl_mul*(y: GEN; x: pari_ulong; p: pari_ulong): GEN {.cdecl,
    importc: "Flm_Fl_mul", dynlib: libname.}
proc Flm_Fl_mul_inplace*(y: GEN; x: pari_ulong; p: pari_ulong) {.cdecl,
    importc: "Flm_Fl_mul_inplace", dynlib: libname.}
proc Flm_Flc_mul*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_Flc_mul",
    dynlib: libname.}
proc Flm_center*(z: GEN; p: pari_ulong; ps2: pari_ulong): GEN {.cdecl,
    importc: "Flm_center", dynlib: libname.}
proc Flm_mul*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_mul",
    dynlib: libname.}
proc Flm_neg*(y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_neg", dynlib: libname.}
proc Flm_powu*(x: GEN; n: pari_ulong; p: pari_ulong): GEN {.cdecl, importc: "Flm_powu",
    dynlib: libname.}
proc Flm_to_mod*(z: GEN; pp: pari_ulong): GEN {.cdecl, importc: "Flm_to_mod",
    dynlib: libname.}
proc Flm_transpose*(x: GEN): GEN {.cdecl, importc: "Flm_transpose", dynlib: libname.}
proc Flv_add*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flv_add",
    dynlib: libname.}
proc Flv_add_inplace*(x: GEN; y: GEN; p: pari_ulong) {.cdecl,
    importc: "Flv_add_inplace", dynlib: libname.}
proc Flv_dotproduct*(x: GEN; y: GEN; p: pari_ulong): pari_ulong {.cdecl,
    importc: "Flv_dotproduct", dynlib: libname.}
proc Flv_center*(z: GEN; p: pari_ulong; ps2: pari_ulong): GEN {.cdecl,
    importc: "Flv_center", dynlib: libname.}
proc Flv_sub*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flv_sub",
    dynlib: libname.}
proc Flv_sub_inplace*(x: GEN; y: GEN; p: pari_ulong) {.cdecl,
    importc: "Flv_sub_inplace", dynlib: libname.}
proc Flv_sum*(x: GEN; p: pari_ulong): pari_ulong {.cdecl, importc: "Flv_sum",
    dynlib: libname.}
proc Fp_to_mod*(z: GEN; p: GEN): GEN {.cdecl, importc: "Fp_to_mod", dynlib: libname.}
proc FpC_FpV_mul*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpC_FpV_mul",
    dynlib: libname.}
proc FpC_Fp_mul*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpC_Fp_mul",
                                        dynlib: libname.}
proc FpC_center*(z: GEN; p: GEN; pov2: GEN): GEN {.cdecl, importc: "FpC_center",
    dynlib: libname.}
proc FpC_red*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpC_red", dynlib: libname.}
proc FpC_to_mod*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpC_to_mod", dynlib: libname.}
proc FpM_FpC_mul*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpM_FpC_mul",
    dynlib: libname.}
proc FpM_FpC_mul_FpX*(x: GEN; y: GEN; p: GEN; v: clong): GEN {.cdecl,
    importc: "FpM_FpC_mul_FpX", dynlib: libname.}
proc FpM_center*(z: GEN; p: GEN; pov2: GEN): GEN {.cdecl, importc: "FpM_center",
    dynlib: libname.}
proc FpM_mul*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpM_mul", dynlib: libname.}
proc FpM_powu*(x: GEN; n: pari_ulong; p: GEN): GEN {.cdecl, importc: "FpM_powu",
    dynlib: libname.}
proc FpM_red*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpM_red", dynlib: libname.}
proc FpM_to_mod*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpM_to_mod", dynlib: libname.}
proc FpMs_FpC_mul*(M: GEN; B: GEN; p: GEN): GEN {.cdecl, importc: "FpMs_FpC_mul",
    dynlib: libname.}
proc FpMs_FpCs_solve*(M: GEN; B: GEN; nbrow: clong; p: GEN): GEN {.cdecl,
    importc: "FpMs_FpCs_solve", dynlib: libname.}
proc FpMs_FpCs_solve_safe*(M: GEN; A: GEN; nbrow: clong; p: GEN): GEN {.cdecl,
    importc: "FpMs_FpCs_solve_safe", dynlib: libname.}
proc FpMs_leftkernel_elt*(M: GEN; nbrow: clong; p: GEN): GEN {.cdecl,
    importc: "FpMs_leftkernel_elt", dynlib: libname.}
proc FpC_add*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpC_add", dynlib: libname.}
proc FpC_sub*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpC_sub", dynlib: libname.}
proc FpV_FpMs_mul*(B: GEN; M: GEN; p: GEN): GEN {.cdecl, importc: "FpV_FpMs_mul",
    dynlib: libname.}
proc FpV_add*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpV_add", dynlib: libname.}
proc FpV_sub*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpV_sub", dynlib: libname.}
proc FpV_dotproduct*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpV_dotproduct",
    dynlib: libname.}
proc FpV_dotsquare*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpV_dotsquare",
                                     dynlib: libname.}
proc FpV_red*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpV_red", dynlib: libname.}
proc FpV_to_mod*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpV_to_mod", dynlib: libname.}
proc FpVV_to_mod*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpVV_to_mod", dynlib: libname.}
proc FpX_to_mod*(z: GEN; p: GEN): GEN {.cdecl, importc: "FpX_to_mod", dynlib: libname.}
proc ZV_zMs_mul*(B: GEN; M: GEN): GEN {.cdecl, importc: "ZV_zMs_mul", dynlib: libname.}
proc ZpMs_ZpCs_solve*(M: GEN; B: GEN; nbrow: clong; p: GEN; e: clong): GEN {.cdecl,
    importc: "ZpMs_ZpCs_solve", dynlib: libname.}
proc gen_FpM_Wiedemann*(E: pointer; f: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; B: GEN;
                       p: GEN): GEN {.cdecl, importc: "gen_FpM_Wiedemann",
                                   dynlib: libname.}
proc gen_ZpM_Dixon*(E: pointer; f: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; B: GEN;
                   p: GEN; e: clong): GEN {.cdecl, importc: "gen_ZpM_Dixon",
                                       dynlib: libname.}
proc gen_matid*(n: clong; E: pointer; S: ptr bb_field): GEN {.cdecl, importc: "gen_matid",
    dynlib: libname.}
proc matid_F2m*(n: clong): GEN {.cdecl, importc: "matid_F2m", dynlib: libname.}
proc matid_Flm*(n: clong): GEN {.cdecl, importc: "matid_Flm", dynlib: libname.}
proc matid_F2xqM*(n: clong; T: GEN): GEN {.cdecl, importc: "matid_F2xqM", dynlib: libname.}
proc matid_FlxqM*(n: clong; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "matid_FlxqM",
    dynlib: libname.}
proc scalar_Flm*(s: clong; n: clong): GEN {.cdecl, importc: "scalar_Flm", dynlib: libname.}
proc zCs_to_ZC*(C: GEN; nbrow: clong): GEN {.cdecl, importc: "zCs_to_ZC", dynlib: libname.}
proc zMs_to_ZM*(M: GEN; nbrow: clong): GEN {.cdecl, importc: "zMs_to_ZM", dynlib: libname.}
proc zMs_ZC_mul*(M: GEN; B: GEN): GEN {.cdecl, importc: "zMs_ZC_mul", dynlib: libname.}
proc Zp_sqrtlift*(b: GEN; a: GEN; p: GEN; e: clong): GEN {.cdecl, importc: "Zp_sqrtlift",
    dynlib: libname.}
proc Zp_sqrtnlift*(b: GEN; n: GEN; a: GEN; p: GEN; e: clong): GEN {.cdecl,
    importc: "Zp_sqrtnlift", dynlib: libname.}
proc ZpX_liftfact*(pol: GEN; Q: GEN; T: GEN; p: GEN; e: clong; pe: GEN): GEN {.cdecl,
    importc: "ZpX_liftfact", dynlib: libname.}
proc ZpX_liftroot*(f: GEN; a: GEN; p: GEN; e: clong): GEN {.cdecl, importc: "ZpX_liftroot",
    dynlib: libname.}
proc ZpX_liftroots*(f: GEN; S: GEN; q: GEN; e: clong): GEN {.cdecl,
    importc: "ZpX_liftroots", dynlib: libname.}
proc ZpXQ_inv*(a: GEN; T: GEN; p: GEN; e: clong): GEN {.cdecl, importc: "ZpXQ_inv",
    dynlib: libname.}
proc ZpXQ_invlift*(b: GEN; a: GEN; T: GEN; p: GEN; e: clong): GEN {.cdecl,
    importc: "ZpXQ_invlift", dynlib: libname.}
proc ZpXQ_log*(a: GEN; T: GEN; p: GEN; N: clong): GEN {.cdecl, importc: "ZpXQ_log",
    dynlib: libname.}
proc ZpXQ_sqrtnlift*(b: GEN; n: GEN; a: GEN; T: GEN; p: GEN; e: clong): GEN {.cdecl,
    importc: "ZpXQ_sqrtnlift", dynlib: libname.}
proc ZpXQX_liftroot*(f: GEN; a: GEN; T: GEN; p: GEN; e: clong): GEN {.cdecl,
    importc: "ZpXQX_liftroot", dynlib: libname.}
proc ZpXQX_liftroot_vald*(f: GEN; a: GEN; v: clong; T: GEN; p: GEN; e: clong): GEN {.cdecl,
    importc: "ZpXQX_liftroot_vald", dynlib: libname.}
proc gen_ZpX_Dixon*(F: GEN; V: GEN; q: GEN; p: GEN; N: clong; E: pointer; lin: proc (
    E: pointer; F: GEN; d: GEN; q: GEN): GEN {.cdecl.};
                   invl: proc (E: pointer; d: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_ZpX_Dixon", dynlib: libname.}
proc gen_ZpX_Newton*(x: GEN; p: GEN; n: clong; E: pointer;
                    eval: proc (E: pointer; f: GEN; q: GEN): GEN {.cdecl.}; invd: proc (
    E: pointer; V: GEN; v: GEN; q: GEN; M: clong): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_ZpX_Newton", dynlib: libname.}
proc polhensellift*(pol: GEN; fct: GEN; p: GEN; exp: clong): GEN {.cdecl,
    importc: "polhensellift", dynlib: libname.}
proc quadratic_prec_mask*(n: clong): pari_ulong {.cdecl,
    importc: "quadratic_prec_mask", dynlib: libname.}
proc QX_factor*(x: GEN): GEN {.cdecl, importc: "QX_factor", dynlib: libname.}
proc ZX_factor*(x: GEN): GEN {.cdecl, importc: "ZX_factor", dynlib: libname.}
proc ZX_is_irred*(x: GEN): clong {.cdecl, importc: "ZX_is_irred", dynlib: libname.}
proc ZX_squff*(f: GEN; ex: ptr GEN): GEN {.cdecl, importc: "ZX_squff", dynlib: libname.}
proc polcyclofactors*(f: GEN): GEN {.cdecl, importc: "polcyclofactors", dynlib: libname.}
proc poliscyclo*(f: GEN): clong {.cdecl, importc: "poliscyclo", dynlib: libname.}
proc poliscycloprod*(f: GEN): clong {.cdecl, importc: "poliscycloprod", dynlib: libname.}
proc RgC_Rg_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgC_Rg_add", dynlib: libname.}
proc RgC_Rg_div*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgC_Rg_div", dynlib: libname.}
proc RgC_Rg_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgC_Rg_mul", dynlib: libname.}
proc RgC_RgM_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgC_RgM_mul", dynlib: libname.}
proc RgC_RgV_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgC_RgV_mul", dynlib: libname.}
proc RgC_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgC_add", dynlib: libname.}
proc RgC_neg*(x: GEN): GEN {.cdecl, importc: "RgC_neg", dynlib: libname.}
proc RgC_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgC_sub", dynlib: libname.}
proc RgM_Rg_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_Rg_add", dynlib: libname.}
proc RgM_Rg_add_shallow*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_Rg_add_shallow",
    dynlib: libname.}
proc RgM_Rg_div*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_Rg_div", dynlib: libname.}
proc RgM_Rg_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_Rg_mul", dynlib: libname.}
proc RgM_Rg_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_Rg_sub", dynlib: libname.}
proc RgM_Rg_sub_shallow*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_Rg_sub_shallow",
    dynlib: libname.}
proc RgM_RgC_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_RgC_mul", dynlib: libname.}
proc RgM_RgV_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_RgV_mul", dynlib: libname.}
proc RgM_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_add", dynlib: libname.}
proc RgM_det_triangular*(x: GEN): GEN {.cdecl, importc: "RgM_det_triangular",
                                    dynlib: libname.}
proc RgM_is_ZM*(x: GEN): cint {.cdecl, importc: "RgM_is_ZM", dynlib: libname.}
proc RgM_isdiagonal*(x: GEN): cint {.cdecl, importc: "RgM_isdiagonal", dynlib: libname.}
proc RgM_isidentity*(x: GEN): cint {.cdecl, importc: "RgM_isidentity", dynlib: libname.}
proc RgM_isscalar*(x: GEN; s: GEN): cint {.cdecl, importc: "RgM_isscalar",
                                     dynlib: libname.}
proc RgM_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_mul", dynlib: libname.}
proc RgM_multosym*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_multosym", dynlib: libname.}
proc RgM_neg*(x: GEN): GEN {.cdecl, importc: "RgM_neg", dynlib: libname.}
proc RgM_powers*(x: GEN; par_l: clong): GEN {.cdecl, importc: "RgM_powers",
                                        dynlib: libname.}
proc RgM_sqr*(x: GEN): GEN {.cdecl, importc: "RgM_sqr", dynlib: libname.}
proc RgM_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_sub", dynlib: libname.}
proc RgM_transmul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_transmul", dynlib: libname.}
proc RgM_transmultosym*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_transmultosym",
    dynlib: libname.}
proc RgM_zc_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_zc_mul", dynlib: libname.}
proc RgM_zm_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_zm_mul", dynlib: libname.}
proc RgMrow_RgC_mul*(x: GEN; y: GEN; i: clong): GEN {.cdecl, importc: "RgMrow_RgC_mul",
    dynlib: libname.}
proc RgV_RgM_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgV_RgM_mul", dynlib: libname.}
proc RgV_RgC_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgV_RgC_mul", dynlib: libname.}
proc RgV_Rg_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgV_Rg_mul", dynlib: libname.}
proc RgV_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgV_add", dynlib: libname.}
proc RgV_dotproduct*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgV_dotproduct",
                                      dynlib: libname.}
proc RgV_dotsquare*(x: GEN): GEN {.cdecl, importc: "RgV_dotsquare", dynlib: libname.}
proc RgV_is_ZMV*(V: GEN): cint {.cdecl, importc: "RgV_is_ZMV", dynlib: libname.}
proc RgV_isin*(v: GEN; x: GEN): clong {.cdecl, importc: "RgV_isin", dynlib: libname.}
proc RgV_neg*(x: GEN): GEN {.cdecl, importc: "RgV_neg", dynlib: libname.}
proc RgV_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgV_sub", dynlib: libname.}
proc RgV_sum*(v: GEN): GEN {.cdecl, importc: "RgV_sum", dynlib: libname.}
proc RgV_sumpart*(v: GEN; n: clong): GEN {.cdecl, importc: "RgV_sumpart", dynlib: libname.}
proc RgV_sumpart2*(v: GEN; m: clong; n: clong): GEN {.cdecl, importc: "RgV_sumpart2",
    dynlib: libname.}
proc RgV_zc_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgV_zc_mul", dynlib: libname.}
proc RgV_zm_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgV_zm_mul", dynlib: libname.}
proc RgX_RgM_eval*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgX_RgM_eval", dynlib: libname.}
proc RgX_RgMV_eval*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgX_RgMV_eval",
                                     dynlib: libname.}
proc isdiagonal*(x: GEN): cint {.cdecl, importc: "isdiagonal", dynlib: libname.}
proc matid*(n: clong): GEN {.cdecl, importc: "matid", dynlib: libname.}
proc scalarcol*(x: GEN; n: clong): GEN {.cdecl, importc: "scalarcol", dynlib: libname.}
proc scalarcol_shallow*(x: GEN; n: clong): GEN {.cdecl, importc: "scalarcol_shallow",
    dynlib: libname.}
proc scalarmat*(x: GEN; n: clong): GEN {.cdecl, importc: "scalarmat", dynlib: libname.}
proc scalarmat_shallow*(x: GEN; n: clong): GEN {.cdecl, importc: "scalarmat_shallow",
    dynlib: libname.}
proc scalarmat_s*(x: clong; n: clong): GEN {.cdecl, importc: "scalarmat_s",
                                       dynlib: libname.}
proc Kronecker_to_mod*(z: GEN; pol: GEN): GEN {.cdecl, importc: "Kronecker_to_mod",
    dynlib: libname.}
proc QX_ZXQV_eval*(P: GEN; V: GEN; dV: GEN): GEN {.cdecl, importc: "QX_ZXQV_eval",
    dynlib: libname.}
proc QXQ_powers*(a: GEN; n: clong; T: GEN): GEN {.cdecl, importc: "QXQ_powers",
    dynlib: libname.}
proc QXQX_to_mod_shallow*(z: GEN; T: GEN): GEN {.cdecl, importc: "QXQX_to_mod_shallow",
    dynlib: libname.}
proc QXQV_to_mod*(V: GEN; T: GEN): GEN {.cdecl, importc: "QXQV_to_mod", dynlib: libname.}
proc QXQXV_to_mod*(V: GEN; T: GEN): GEN {.cdecl, importc: "QXQXV_to_mod", dynlib: libname.}
proc QXV_QXQ_eval*(v: GEN; a: GEN; T: GEN): GEN {.cdecl, importc: "QXV_QXQ_eval",
    dynlib: libname.}
proc QXX_QXQ_eval*(v: GEN; a: GEN; T: GEN): GEN {.cdecl, importc: "QXX_QXQ_eval",
    dynlib: libname.}
proc Rg_to_RgV*(x: GEN; N: clong): GEN {.cdecl, importc: "Rg_to_RgV", dynlib: libname.}
proc RgM_to_RgXV*(x: GEN; v: clong): GEN {.cdecl, importc: "RgM_to_RgXV", dynlib: libname.}
proc RgM_to_RgXX*(x: GEN; v: clong; w: clong): GEN {.cdecl, importc: "RgM_to_RgXX",
    dynlib: libname.}
proc RgV_to_RgX*(x: GEN; v: clong): GEN {.cdecl, importc: "RgV_to_RgX", dynlib: libname.}
proc RgV_to_RgM*(v: GEN; n: clong): GEN {.cdecl, importc: "RgV_to_RgM", dynlib: libname.}
proc RgV_to_RgX_reverse*(x: GEN; v: clong): GEN {.cdecl, importc: "RgV_to_RgX_reverse",
    dynlib: libname.}
proc RgXQC_red*(P: GEN; T: GEN): GEN {.cdecl, importc: "RgXQC_red", dynlib: libname.}
proc RgXQV_red*(P: GEN; T: GEN): GEN {.cdecl, importc: "RgXQV_red", dynlib: libname.}
proc RgXQX_RgXQ_mul*(x: GEN; y: GEN; T: GEN): GEN {.cdecl, importc: "RgXQX_RgXQ_mul",
    dynlib: libname.}
proc RgXQX_divrem*(x: GEN; y: GEN; T: GEN; r: ptr GEN): GEN {.cdecl,
    importc: "RgXQX_divrem", dynlib: libname.}
proc RgXQX_mul*(x: GEN; y: GEN; T: GEN): GEN {.cdecl, importc: "RgXQX_mul", dynlib: libname.}
proc RgXQX_pseudodivrem*(x: GEN; y: GEN; T: GEN; `ptr`: ptr GEN): GEN {.cdecl,
    importc: "RgXQX_pseudodivrem", dynlib: libname.}
proc RgXQX_pseudorem*(x: GEN; y: GEN; T: GEN): GEN {.cdecl, importc: "RgXQX_pseudorem",
    dynlib: libname.}
proc RgXQX_red*(P: GEN; T: GEN): GEN {.cdecl, importc: "RgXQX_red", dynlib: libname.}
proc RgXQX_sqr*(x: GEN; T: GEN): GEN {.cdecl, importc: "RgXQX_sqr", dynlib: libname.}
proc RgXQX_translate*(P: GEN; c: GEN; T: GEN): GEN {.cdecl, importc: "RgXQX_translate",
    dynlib: libname.}
proc RgXQ_matrix_pow*(y: GEN; n: clong; m: clong; P: GEN): GEN {.cdecl,
    importc: "RgXQ_matrix_pow", dynlib: libname.}
proc RgXQ_norm*(x: GEN; T: GEN): GEN {.cdecl, importc: "RgXQ_norm", dynlib: libname.}
proc RgXQ_pow*(x: GEN; n: GEN; T: GEN): GEN {.cdecl, importc: "RgXQ_pow", dynlib: libname.}
proc RgXQ_powu*(x: GEN; n: pari_ulong; T: GEN): GEN {.cdecl, importc: "RgXQ_powu",
    dynlib: libname.}
proc RgXQ_powers*(x: GEN; par_l: clong; T: GEN): GEN {.cdecl, importc: "RgXQ_powers",
    dynlib: libname.}
proc RgXV_to_RgM*(v: GEN; n: clong): GEN {.cdecl, importc: "RgXV_to_RgM", dynlib: libname.}
proc RgXV_unscale*(v: GEN; h: GEN): GEN {.cdecl, importc: "RgXV_unscale", dynlib: libname.}
proc RgXX_to_RgM*(v: GEN; n: clong): GEN {.cdecl, importc: "RgXX_to_RgM", dynlib: libname.}
proc RgXY_swap*(x: GEN; n: clong; w: clong): GEN {.cdecl, importc: "RgXY_swap",
    dynlib: libname.}
proc RgXY_swapspec*(x: GEN; n: clong; w: clong; nx: clong): GEN {.cdecl,
    importc: "RgXY_swapspec", dynlib: libname.}
proc RgX_RgXQ_eval*(f: GEN; x: GEN; T: GEN): GEN {.cdecl, importc: "RgX_RgXQ_eval",
    dynlib: libname.}
proc RgX_RgXQV_eval*(P: GEN; V: GEN; T: GEN): GEN {.cdecl, importc: "RgX_RgXQV_eval",
    dynlib: libname.}
proc RgX_Rg_add*(y: GEN; x: GEN): GEN {.cdecl, importc: "RgX_Rg_add", dynlib: libname.}
proc RgX_Rg_add_shallow*(y: GEN; x: GEN): GEN {.cdecl, importc: "RgX_Rg_add_shallow",
    dynlib: libname.}
proc RgX_Rg_div*(y: GEN; x: GEN): GEN {.cdecl, importc: "RgX_Rg_div", dynlib: libname.}
proc RgX_Rg_divexact*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgX_Rg_divexact",
                                       dynlib: libname.}
proc RgX_Rg_mul*(y: GEN; x: GEN): GEN {.cdecl, importc: "RgX_Rg_mul", dynlib: libname.}
proc RgX_Rg_sub*(y: GEN; x: GEN): GEN {.cdecl, importc: "RgX_Rg_sub", dynlib: libname.}
proc RgX_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgX_add", dynlib: libname.}
proc RgX_blocks*(P: GEN; n: clong; m: clong): GEN {.cdecl, importc: "RgX_blocks",
    dynlib: libname.}
proc RgX_deflate*(x0: GEN; d: clong): GEN {.cdecl, importc: "RgX_deflate",
                                      dynlib: libname.}
proc RgX_deriv*(x: GEN): GEN {.cdecl, importc: "RgX_deriv", dynlib: libname.}
proc RgX_div_by_X_x*(a: GEN; x: GEN; r: ptr GEN): GEN {.cdecl, importc: "RgX_div_by_X_x",
    dynlib: libname.}
proc RgX_divrem*(x: GEN; y: GEN; r: ptr GEN): GEN {.cdecl, importc: "RgX_divrem",
    dynlib: libname.}
proc RgX_divs*(y: GEN; x: clong): GEN {.cdecl, importc: "RgX_divs", dynlib: libname.}
proc RgX_equal*(x: GEN; y: GEN): clong {.cdecl, importc: "RgX_equal", dynlib: libname.}
proc RgX_even_odd*(p: GEN; pe: ptr GEN; po: ptr GEN) {.cdecl, importc: "RgX_even_odd",
    dynlib: libname.}
proc RgX_get_0*(x: GEN): GEN {.cdecl, importc: "RgX_get_0", dynlib: libname.}
proc RgX_get_1*(x: GEN): GEN {.cdecl, importc: "RgX_get_1", dynlib: libname.}
proc RgX_inflate*(x0: GEN; d: clong): GEN {.cdecl, importc: "RgX_inflate",
                                      dynlib: libname.}
proc RgX_modXn_shallow*(a: GEN; n: clong): GEN {.cdecl, importc: "RgX_modXn_shallow",
    dynlib: libname.}
proc RgX_modXn_eval*(Q: GEN; x: GEN; n: clong): GEN {.cdecl, importc: "RgX_modXn_eval",
    dynlib: libname.}
proc RgX_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgX_mul", dynlib: libname.}
proc RgX_mul_normalized*(A: GEN; a: clong; B: GEN; b: clong): GEN {.cdecl,
    importc: "RgX_mul_normalized", dynlib: libname.}
proc RgX_mulXn*(x: GEN; d: clong): GEN {.cdecl, importc: "RgX_mulXn", dynlib: libname.}
proc RgX_mullow*(f: GEN; g: GEN; n: clong): GEN {.cdecl, importc: "RgX_mullow",
    dynlib: libname.}
proc RgX_muls*(y: GEN; x: clong): GEN {.cdecl, importc: "RgX_muls", dynlib: libname.}
proc RgX_mulspec*(a: GEN; b: GEN; na: clong; nb: clong): GEN {.cdecl,
    importc: "RgX_mulspec", dynlib: libname.}
proc RgX_neg*(x: GEN): GEN {.cdecl, importc: "RgX_neg", dynlib: libname.}
proc RgX_pseudodivrem*(x: GEN; y: GEN; `ptr`: ptr GEN): GEN {.cdecl,
    importc: "RgX_pseudodivrem", dynlib: libname.}
proc RgX_pseudorem*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgX_pseudorem",
                                     dynlib: libname.}
proc RgX_recip*(x: GEN): GEN {.cdecl, importc: "RgX_recip", dynlib: libname.}
proc RgX_recip_shallow*(x: GEN): GEN {.cdecl, importc: "RgX_recip_shallow",
                                   dynlib: libname.}
proc RgX_renormalize_lg*(x: GEN; lx: clong): GEN {.cdecl,
    importc: "RgX_renormalize_lg", dynlib: libname.}
proc RgX_rescale*(P: GEN; h: GEN): GEN {.cdecl, importc: "RgX_rescale", dynlib: libname.}
proc RgX_rotate_shallow*(P: GEN; k: clong; p: clong): GEN {.cdecl,
    importc: "RgX_rotate_shallow", dynlib: libname.}
proc RgX_shift*(a: GEN; n: clong): GEN {.cdecl, importc: "RgX_shift", dynlib: libname.}
proc RgX_shift_shallow*(x: GEN; n: clong): GEN {.cdecl, importc: "RgX_shift_shallow",
    dynlib: libname.}
proc RgX_splitting*(p: GEN; k: clong): GEN {.cdecl, importc: "RgX_splitting",
                                       dynlib: libname.}
proc RgX_sqr*(x: GEN): GEN {.cdecl, importc: "RgX_sqr", dynlib: libname.}
proc RgX_sqrlow*(f: GEN; n: clong): GEN {.cdecl, importc: "RgX_sqrlow", dynlib: libname.}
proc RgX_sqrspec*(a: GEN; na: clong): GEN {.cdecl, importc: "RgX_sqrspec",
                                      dynlib: libname.}
proc RgX_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgX_sub", dynlib: libname.}
proc RgX_to_RgV*(x: GEN; N: clong): GEN {.cdecl, importc: "RgX_to_RgV", dynlib: libname.}
proc RgX_translate*(P: GEN; c: GEN): GEN {.cdecl, importc: "RgX_translate",
                                     dynlib: libname.}
proc RgX_unscale*(P: GEN; h: GEN): GEN {.cdecl, importc: "RgX_unscale", dynlib: libname.}
proc Rg_RgX_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "Rg_RgX_sub", dynlib: libname.}
proc ZX_translate*(P: GEN; c: GEN): GEN {.cdecl, importc: "ZX_translate", dynlib: libname.}
proc ZX_unscale*(P: GEN; h: GEN): GEN {.cdecl, importc: "ZX_unscale", dynlib: libname.}
proc ZX_unscale_div*(P: GEN; h: GEN): GEN {.cdecl, importc: "ZX_unscale_div",
                                      dynlib: libname.}
proc ZXQX_dvd*(x: GEN; y: GEN; T: GEN): cint {.cdecl, importc: "ZXQX_dvd", dynlib: libname.}
proc brent_kung_optpow*(d: clong; n: clong; m: clong): clong {.cdecl,
    importc: "brent_kung_optpow", dynlib: libname.}
proc gen_bkeval*(Q: GEN; d: clong; x: GEN; use_sqr: cint; E: pointer; ff: ptr bb_algebra;
                cmul: proc (E: pointer; P: GEN; a: clong; x: GEN): GEN {.cdecl.}): GEN {.
    cdecl, importc: "gen_bkeval", dynlib: libname.}
proc gen_bkeval_powers*(P: GEN; d: clong; V: GEN; E: pointer; ff: ptr bb_algebra; cmul: proc (
    E: pointer; P: GEN; a: clong; x: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_bkeval_powers", dynlib: libname.}
proc Flc_lincomb1_inplace*(X: GEN; Y: GEN; v: pari_ulong; q: pari_ulong) {.cdecl,
    importc: "Flc_lincomb1_inplace", dynlib: libname.}
proc RgM_check_ZM*(A: GEN; s: cstring) {.cdecl, importc: "RgM_check_ZM", dynlib: libname.}
proc RgV_check_ZV*(A: GEN; s: cstring) {.cdecl, importc: "RgV_check_ZV", dynlib: libname.}
proc ZC_ZV_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZC_ZV_mul", dynlib: libname.}
proc ZC_Z_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZC_Z_add", dynlib: libname.}
proc ZC_Z_divexact*(X: GEN; c: GEN): GEN {.cdecl, importc: "ZC_Z_divexact",
                                     dynlib: libname.}
proc ZC_Z_mul*(X: GEN; c: GEN): GEN {.cdecl, importc: "ZC_Z_mul", dynlib: libname.}
proc ZC_Z_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZC_Z_sub", dynlib: libname.}
proc ZC_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZC_add", dynlib: libname.}
proc ZC_copy*(x: GEN): GEN {.cdecl, importc: "ZC_copy", dynlib: libname.}
proc ZC_hnfremdiv*(x: GEN; y: GEN; Q: ptr GEN): GEN {.cdecl, importc: "ZC_hnfremdiv",
    dynlib: libname.}
proc ZC_lincomb*(u: GEN; v: GEN; X: GEN; Y: GEN): GEN {.cdecl, importc: "ZC_lincomb",
    dynlib: libname.}
proc ZC_lincomb1_inplace*(X: GEN; Y: GEN; v: GEN) {.cdecl,
    importc: "ZC_lincomb1_inplace", dynlib: libname.}
proc ZC_neg*(M: GEN): GEN {.cdecl, importc: "ZC_neg", dynlib: libname.}
proc ZC_reducemodlll*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZC_reducemodlll",
                                       dynlib: libname.}
proc ZC_reducemodmatrix*(v: GEN; y: GEN): GEN {.cdecl, importc: "ZC_reducemodmatrix",
    dynlib: libname.}
proc ZC_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZC_sub", dynlib: libname.}
proc ZC_z_mul*(X: GEN; c: clong): GEN {.cdecl, importc: "ZC_z_mul", dynlib: libname.}
proc ZM_ZC_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_ZC_mul", dynlib: libname.}
proc ZM_Z_divexact*(X: GEN; c: GEN): GEN {.cdecl, importc: "ZM_Z_divexact",
                                     dynlib: libname.}
proc ZM_Z_mul*(X: GEN; c: GEN): GEN {.cdecl, importc: "ZM_Z_mul", dynlib: libname.}
proc ZM_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_add", dynlib: libname.}
proc ZM_copy*(x: GEN): GEN {.cdecl, importc: "ZM_copy", dynlib: libname.}
proc ZM_det_triangular*(mat: GEN): GEN {.cdecl, importc: "ZM_det_triangular",
                                     dynlib: libname.}
proc ZM_equal*(A: GEN; B: GEN): cint {.cdecl, importc: "ZM_equal", dynlib: libname.}
proc ZM_hnfdivrem*(x: GEN; y: GEN; Q: ptr GEN): GEN {.cdecl, importc: "ZM_hnfdivrem",
    dynlib: libname.}
proc ZM_ishnf*(x: GEN): cint {.cdecl, importc: "ZM_ishnf", dynlib: libname.}
proc ZM_isidentity*(x: GEN): cint {.cdecl, importc: "ZM_isidentity", dynlib: libname.}
proc ZM_max_lg*(x: GEN): clong {.cdecl, importc: "ZM_max_lg", dynlib: libname.}
proc ZM_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_mul", dynlib: libname.}
proc ZM_multosym*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_multosym", dynlib: libname.}
proc ZM_neg*(x: GEN): GEN {.cdecl, importc: "ZM_neg", dynlib: libname.}
proc ZM_nm_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_nm_mul", dynlib: libname.}
proc ZM_pow*(x: GEN; n: GEN): GEN {.cdecl, importc: "ZM_pow", dynlib: libname.}
proc ZM_powu*(x: GEN; n: pari_ulong): GEN {.cdecl, importc: "ZM_powu", dynlib: libname.}
proc ZM_reducemodlll*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_reducemodlll",
                                       dynlib: libname.}
proc ZM_reducemodmatrix*(v: GEN; y: GEN): GEN {.cdecl, importc: "ZM_reducemodmatrix",
    dynlib: libname.}
proc ZM_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_sub", dynlib: libname.}
proc ZM_supnorm*(x: GEN): GEN {.cdecl, importc: "ZM_supnorm", dynlib: libname.}
proc ZM_to_Flm*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "ZM_to_Flm",
                                        dynlib: libname.}
proc ZM_to_zm*(z: GEN): GEN {.cdecl, importc: "ZM_to_zm", dynlib: libname.}
proc ZM_transmultosym*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_transmultosym",
                                        dynlib: libname.}
proc ZMV_to_zmV*(z: GEN): GEN {.cdecl, importc: "ZMV_to_zmV", dynlib: libname.}
proc ZM_togglesign*(M: GEN) {.cdecl, importc: "ZM_togglesign", dynlib: libname.}

proc ZM_zc_mu1l*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_zc_mul", dynlib: libname.}
proc ZM_zm_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZM_zm_mul", dynlib: libname.}
proc ZMrow_ZC_mul*(x: GEN; y: GEN; i: clong): GEN {.cdecl, importc: "ZMrow_ZC_mul",
    dynlib: libname.}
proc ZV_ZM_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZV_ZM_mul", dynlib: libname.}
proc ZV_abscmp*(x: GEN; y: GEN): cint {.cdecl, importc: "ZV_abscmp", dynlib: libname.}
proc ZV_cmp*(x: GEN; y: GEN): cint {.cdecl, importc: "ZV_cmp", dynlib: libname.}
proc ZV_content*(x: GEN): GEN {.cdecl, importc: "ZV_content", dynlib: libname.}
proc ZV_dotproduct*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZV_dotproduct",
                                     dynlib: libname.}
proc ZV_dotsquare*(x: GEN): GEN {.cdecl, importc: "ZV_dotsquare", dynlib: libname.}
proc ZV_equal*(V: GEN; W: GEN): cint {.cdecl, importc: "ZV_equal", dynlib: libname.}
proc ZV_equal0*(V: GEN): cint {.cdecl, importc: "ZV_equal0", dynlib: libname.}
proc ZV_max_lg*(x: GEN): clong {.cdecl, importc: "ZV_max_lg", dynlib: libname.}
proc ZV_neg_inplace*(M: GEN) {.cdecl, importc: "ZV_neg_inplace", dynlib: libname.}
proc ZV_prod*(v: GEN): GEN {.cdecl, importc: "ZV_prod", dynlib: libname.}
proc ZV_sum*(v: GEN): GEN {.cdecl, importc: "ZV_sum", dynlib: libname.}
proc ZV_to_Flv*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "ZV_to_Flv",
                                        dynlib: libname.}
proc ZV_to_nv*(z: GEN): GEN {.cdecl, importc: "ZV_to_nv", dynlib: libname.}
proc ZV_togglesign*(M: GEN) {.cdecl, importc: "ZV_togglesign", dynlib: libname.}
proc gram_matrix*(M: GEN): GEN {.cdecl, importc: "gram_matrix", dynlib: libname.}
proc nm_Z_mul*(X: GEN; c: GEN): GEN {.cdecl, importc: "nm_Z_mul", dynlib: libname.}
proc zm_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "zm_mul", dynlib: libname.}
proc zm_to_Flm*(z: GEN; p: pari_ulong): GEN {.cdecl, importc: "zm_to_Flm",
                                        dynlib: libname.}
proc zm_to_ZM*(z: GEN): GEN {.cdecl, importc: "zm_to_ZM", dynlib: libname.}
proc zm_zc_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "zm_zc_mul", dynlib: libname.}
proc zmV_to_ZMV*(z: GEN): GEN {.cdecl, importc: "zmV_to_ZMV", dynlib: libname.}
proc zv_content*(x: GEN): clong {.cdecl, importc: "zv_content", dynlib: libname.}
proc zv_dotproduct*(x: GEN; y: GEN): clong {.cdecl, importc: "zv_dotproduct",
                                       dynlib: libname.}
proc zv_equal*(V: GEN; W: GEN): cint {.cdecl, importc: "zv_equal", dynlib: libname.}
proc zv_equal0*(V: GEN): cint {.cdecl, importc: "zv_equal0", dynlib: libname.}
proc zv_neg*(x: GEN): GEN {.cdecl, importc: "zv_neg", dynlib: libname.}
proc zv_neg_inplace*(M: GEN): GEN {.cdecl, importc: "zv_neg_inplace", dynlib: libname.}
proc zv_prod*(v: GEN): clong {.cdecl, importc: "zv_prod", dynlib: libname.}
proc zv_prod_Z*(v: GEN): GEN {.cdecl, importc: "zv_prod_Z", dynlib: libname.}
proc zv_sum*(v: GEN): clong {.cdecl, importc: "zv_sum", dynlib: libname.}
proc zv_to_Flv*(z: GEN; p: pari_ulong): GEN {.cdecl, importc: "zv_to_Flv",
                                        dynlib: libname.}
proc zv_z_mul*(v: GEN; n: clong): GEN {.cdecl, importc: "zv_z_mul", dynlib: libname.}
proc zvV_equal*(V: GEN; W: GEN): cint {.cdecl, importc: "zvV_equal", dynlib: libname.}
proc RgX_check_QX*(x: GEN; s: cstring) {.cdecl, importc: "RgX_check_QX", dynlib: libname.}
proc RgX_check_ZX*(x: GEN; s: cstring) {.cdecl, importc: "RgX_check_ZX", dynlib: libname.}
proc RgX_check_ZXX*(x: GEN; s: cstring) {.cdecl, importc: "RgX_check_ZXX",
                                     dynlib: libname.}
proc Z_ZX_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "Z_ZX_sub", dynlib: libname.}
proc ZX_Z_add*(y: GEN; x: GEN): GEN {.cdecl, importc: "ZX_Z_add", dynlib: libname.}
proc ZX_Z_add_shallow*(y: GEN; x: GEN): GEN {.cdecl, importc: "ZX_Z_add_shallow",
                                        dynlib: libname.}
proc ZX_Z_divexact*(y: GEN; x: GEN): GEN {.cdecl, importc: "ZX_Z_divexact",
                                     dynlib: libname.}
proc ZX_Z_mul*(y: GEN; x: GEN): GEN {.cdecl, importc: "ZX_Z_mul", dynlib: libname.}
proc ZX_Z_sub*(y: GEN; x: GEN): GEN {.cdecl, importc: "ZX_Z_sub", dynlib: libname.}
proc ZX_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZX_add", dynlib: libname.}
proc ZX_copy*(x: GEN): GEN {.cdecl, importc: "ZX_copy", dynlib: libname.}
proc ZX_deriv*(x: GEN): GEN {.cdecl, importc: "ZX_deriv", dynlib: libname.}
proc ZX_equal*(V: GEN; W: GEN): cint {.cdecl, importc: "ZX_equal", dynlib: libname.}
proc ZX_eval1*(x: GEN): GEN {.cdecl, importc: "ZX_eval1", dynlib: libname.}
proc ZX_max_lg*(x: GEN): clong {.cdecl, importc: "ZX_max_lg", dynlib: libname.}
proc ZX_mod_Xnm1*(T: GEN; n: pari_ulong): GEN {.cdecl, importc: "ZX_mod_Xnm1",
    dynlib: libname.}
proc ZX_mul*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZX_mul", dynlib: libname.}
proc ZX_mulspec*(a: GEN; b: GEN; na: clong; nb: clong): GEN {.cdecl, importc: "ZX_mulspec",
    dynlib: libname.}
proc ZX_mulu*(y: GEN; x: pari_ulong): GEN {.cdecl, importc: "ZX_mulu", dynlib: libname.}
proc ZX_neg*(x: GEN): GEN {.cdecl, importc: "ZX_neg", dynlib: libname.}
proc ZX_rem*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZX_rem", dynlib: libname.}
proc ZX_remi2n*(y: GEN; n: clong): GEN {.cdecl, importc: "ZX_remi2n", dynlib: libname.}
proc ZX_rescale*(P: GEN; h: GEN): GEN {.cdecl, importc: "ZX_rescale", dynlib: libname.}
proc ZX_rescale_lt*(P: GEN): GEN {.cdecl, importc: "ZX_rescale_lt", dynlib: libname.}
proc ZX_shifti*(x: GEN; n: clong): GEN {.cdecl, importc: "ZX_shifti", dynlib: libname.}
proc ZX_sqr*(x: GEN): GEN {.cdecl, importc: "ZX_sqr", dynlib: libname.}
proc ZX_sqrspec*(a: GEN; na: clong): GEN {.cdecl, importc: "ZX_sqrspec", dynlib: libname.}
proc ZX_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZX_sub", dynlib: libname.}
proc ZX_val*(x: GEN): clong {.cdecl, importc: "ZX_val", dynlib: libname.}
proc ZX_valrem*(x: GEN; Z: ptr GEN): clong {.cdecl, importc: "ZX_valrem", dynlib: libname.}
proc ZXT_remi2n*(z: GEN; n: clong): GEN {.cdecl, importc: "ZXT_remi2n", dynlib: libname.}
proc ZXV_Z_mul*(y: GEN; x: GEN): GEN {.cdecl, importc: "ZXV_Z_mul", dynlib: libname.}
proc ZXV_dotproduct*(V: GEN; W: GEN): GEN {.cdecl, importc: "ZXV_dotproduct",
                                      dynlib: libname.}
proc ZXV_equal*(V: GEN; W: GEN): cint {.cdecl, importc: "ZXV_equal", dynlib: libname.}
proc ZXV_remi2n*(x: GEN; n: clong): GEN {.cdecl, importc: "ZXV_remi2n", dynlib: libname.}
proc ZXX_Z_divexact*(y: GEN; x: GEN): GEN {.cdecl, importc: "ZXX_Z_divexact",
                                      dynlib: libname.}
proc ZXX_max_lg*(x: GEN): clong {.cdecl, importc: "ZXX_max_lg", dynlib: libname.}
proc ZXX_renormalize*(x: GEN; lx: clong): GEN {.cdecl, importc: "ZXX_renormalize",
    dynlib: libname.}
proc ZXX_to_Kronecker*(P: GEN; n: clong): GEN {.cdecl, importc: "ZXX_to_Kronecker",
    dynlib: libname.}
proc ZXX_to_Kronecker_spec*(P: GEN; lP: clong; n: clong): GEN {.cdecl,
    importc: "ZXX_to_Kronecker_spec", dynlib: libname.}
proc scalar_ZX*(x: GEN; v: clong): GEN {.cdecl, importc: "scalar_ZX", dynlib: libname.}
proc scalar_ZX_shallow*(x: GEN; v: clong): GEN {.cdecl, importc: "scalar_ZX_shallow",
    dynlib: libname.}
proc zx_to_ZX*(z: GEN): GEN {.cdecl, importc: "zx_to_ZX", dynlib: libname.}
proc F2m_F2c_gauss*(a: GEN; b: GEN): GEN {.cdecl, importc: "F2m_F2c_gauss",
                                     dynlib: libname.}
proc F2m_F2c_invimage*(A: GEN; y: GEN): GEN {.cdecl, importc: "F2m_F2c_invimage",
                                        dynlib: libname.}
proc F2m_deplin*(x: GEN): GEN {.cdecl, importc: "F2m_deplin", dynlib: libname.}
proc F2m_det*(x: GEN): pari_ulong {.cdecl, importc: "F2m_det", dynlib: libname.}
proc F2m_det_sp*(x: GEN): pari_ulong {.cdecl, importc: "F2m_det_sp", dynlib: libname.}
proc F2m_gauss*(a: GEN; b: GEN): GEN {.cdecl, importc: "F2m_gauss", dynlib: libname.}
proc F2m_image*(x: GEN): GEN {.cdecl, importc: "F2m_image", dynlib: libname.}
proc F2m_indexrank*(x: GEN): GEN {.cdecl, importc: "F2m_indexrank", dynlib: libname.}
proc F2m_inv*(x: GEN): GEN {.cdecl, importc: "F2m_inv", dynlib: libname.}
proc F2m_invimage*(A: GEN; B: GEN): GEN {.cdecl, importc: "F2m_invimage", dynlib: libname.}
proc F2m_ker*(x: GEN): GEN {.cdecl, importc: "F2m_ker", dynlib: libname.}
proc F2m_ker_sp*(x: GEN; deplin: clong): GEN {.cdecl, importc: "F2m_ker_sp",
    dynlib: libname.}
proc F2m_rank*(x: GEN): clong {.cdecl, importc: "F2m_rank", dynlib: libname.}
proc F2m_suppl*(x: GEN): GEN {.cdecl, importc: "F2m_suppl", dynlib: libname.}
proc F2xqM_F2xqC_mul*(a: GEN; b: GEN; T: GEN): GEN {.cdecl, importc: "F2xqM_F2xqC_mul",
    dynlib: libname.}
proc F2xqM_det*(a: GEN; T: GEN): GEN {.cdecl, importc: "F2xqM_det", dynlib: libname.}
proc F2xqM_ker*(x: GEN; T: GEN): GEN {.cdecl, importc: "F2xqM_ker", dynlib: libname.}
proc F2xqM_image*(x: GEN; T: GEN): GEN {.cdecl, importc: "F2xqM_image", dynlib: libname.}
proc F2xqM_inv*(a: GEN; T: GEN): GEN {.cdecl, importc: "F2xqM_inv", dynlib: libname.}
proc F2xqM_mul*(a: GEN; b: GEN; T: GEN): GEN {.cdecl, importc: "F2xqM_mul", dynlib: libname.}
proc F2xqM_rank*(x: GEN; T: GEN): clong {.cdecl, importc: "F2xqM_rank", dynlib: libname.}
proc Flm_Flc_gauss*(a: GEN; b: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flm_Flc_gauss", dynlib: libname.}
proc Flm_Flc_invimage*(mat: GEN; y: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flm_Flc_invimage", dynlib: libname.}
proc Flm_deplin*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_deplin",
    dynlib: libname.}
proc Flm_det*(x: GEN; p: pari_ulong): pari_ulong {.cdecl, importc: "Flm_det",
    dynlib: libname.}
proc Flm_det_sp*(x: GEN; p: pari_ulong): pari_ulong {.cdecl, importc: "Flm_det_sp",
    dynlib: libname.}
proc Flm_gauss*(a: GEN; b: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_gauss",
    dynlib: libname.}
proc Flm_image*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_image",
                                        dynlib: libname.}
proc Flm_invimage*(m: GEN; v: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_invimage",
    dynlib: libname.}
proc Flm_indexrank*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_indexrank",
    dynlib: libname.}
proc Flm_inv*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_inv", dynlib: libname.}
proc Flm_ker*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_ker", dynlib: libname.}
proc Flm_ker_sp*(x: GEN; p: pari_ulong; deplin: clong): GEN {.cdecl,
    importc: "Flm_ker_sp", dynlib: libname.}
proc Flm_rank*(x: GEN; p: pari_ulong): clong {.cdecl, importc: "Flm_rank",
    dynlib: libname.}
proc Flm_suppl*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_suppl",
                                        dynlib: libname.}
proc FlxqM_FlxqC_gauss*(a: GEN; b: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqM_FlxqC_gauss", dynlib: libname.}
proc FlxqM_FlxqC_mul*(a: GEN; b: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqM_FlxqC_mul", dynlib: libname.}
proc FlxqM_det*(a: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqM_det",
    dynlib: libname.}
proc FlxqM_gauss*(a: GEN; b: GEN; T: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "FlxqM_gauss", dynlib: libname.}
proc FlxqM_ker*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqM_ker",
    dynlib: libname.}
proc FlxqM_image*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqM_image",
    dynlib: libname.}
proc FlxqM_inv*(x: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqM_inv",
    dynlib: libname.}
proc FlxqM_mul*(a: GEN; b: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc: "FlxqM_mul",
    dynlib: libname.}
proc FlxqM_rank*(x: GEN; T: GEN; p: pari_ulong): clong {.cdecl, importc: "FlxqM_rank",
    dynlib: libname.}
proc FpM_FpC_gauss*(a: GEN; b: GEN; p: GEN): GEN {.cdecl, importc: "FpM_FpC_gauss",
    dynlib: libname.}
proc FpM_FpC_invimage*(m: GEN; v: GEN; p: GEN): GEN {.cdecl, importc: "FpM_FpC_invimage",
    dynlib: libname.}
proc FpM_deplin*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpM_deplin", dynlib: libname.}
proc FpM_det*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpM_det", dynlib: libname.}
proc FpM_gauss*(a: GEN; b: GEN; p: GEN): GEN {.cdecl, importc: "FpM_gauss", dynlib: libname.}
proc FpM_image*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpM_image", dynlib: libname.}
proc FpM_indexrank*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpM_indexrank",
                                     dynlib: libname.}
proc FpM_intersect*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc: "FpM_intersect",
    dynlib: libname.}
proc FpM_inv*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpM_inv", dynlib: libname.}
proc FpM_invimage*(m: GEN; v: GEN; p: GEN): GEN {.cdecl, importc: "FpM_invimage",
    dynlib: libname.}
proc FpM_ker*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpM_ker", dynlib: libname.}
proc FpM_rank*(x: GEN; p: GEN): clong {.cdecl, importc: "FpM_rank", dynlib: libname.}
proc FpM_suppl*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpM_suppl", dynlib: libname.}
proc FqM_FqC_gauss*(a: GEN; b: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_FqC_gauss",
    dynlib: libname.}
proc FqM_FqC_mul*(a: GEN; b: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_FqC_mul",
    dynlib: libname.}
proc FqM_deplin*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_deplin",
                                        dynlib: libname.}
proc FqM_det*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_det", dynlib: libname.}
proc FqM_gauss*(a: GEN; b: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_gauss",
    dynlib: libname.}
proc FqM_ker*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_ker", dynlib: libname.}
proc FqM_image*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_image", dynlib: libname.}
proc FqM_inv*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_inv", dynlib: libname.}
proc FqM_mul*(a: GEN; b: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_mul",
    dynlib: libname.}
proc FqM_rank*(a: GEN; T: GEN; p: GEN): clong {.cdecl, importc: "FqM_rank", dynlib: libname.}
proc FqM_suppl*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqM_suppl", dynlib: libname.}
proc QM_inv*(M: GEN; dM: GEN): GEN {.cdecl, importc: "QM_inv", dynlib: libname.}
proc RgM_Fp_init*(a: GEN; p: GEN; pp: ptr pari_ulong): GEN {.cdecl,
    importc: "RgM_Fp_init", dynlib: libname.}
proc RgM_RgC_invimage*(A: GEN; B: GEN): GEN {.cdecl, importc: "RgM_RgC_invimage",
                                        dynlib: libname.}
proc RgM_diagonal*(m: GEN): GEN {.cdecl, importc: "RgM_diagonal", dynlib: libname.}
proc RgM_diagonal_shallow*(m: GEN): GEN {.cdecl, importc: "RgM_diagonal_shallow",
                                      dynlib: libname.}
proc RgM_Hadamard*(a: GEN): GEN {.cdecl, importc: "RgM_Hadamard", dynlib: libname.}
proc RgM_inv_upper*(a: GEN): GEN {.cdecl, importc: "RgM_inv_upper", dynlib: libname.}
proc RgM_invimage*(A: GEN; B: GEN): GEN {.cdecl, importc: "RgM_invimage", dynlib: libname.}
proc RgM_solve*(a: GEN; b: GEN): GEN {.cdecl, importc: "RgM_solve", dynlib: libname.}
proc RgM_solve_realimag*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_solve_realimag",
    dynlib: libname.}
proc RgMs_structelim*(M: GEN; N: clong; A: GEN; p_col: ptr GEN; p_lin: ptr GEN) {.cdecl,
    importc: "RgMs_structelim", dynlib: libname.}
proc ZM_det*(a: GEN): GEN {.cdecl, importc: "ZM_det", dynlib: libname.}
proc ZM_detmult*(A: GEN): GEN {.cdecl, importc: "ZM_detmult", dynlib: libname.}
proc ZM_gauss*(a: GEN; b: GEN): GEN {.cdecl, importc: "ZM_gauss", dynlib: libname.}
proc ZM_imagecompl*(x: GEN): GEN {.cdecl, importc: "ZM_imagecompl", dynlib: libname.}
proc ZM_indeximage*(x: GEN): GEN {.cdecl, importc: "ZM_indeximage", dynlib: libname.}
proc ZM_inv*(M: GEN; dM: GEN): GEN {.cdecl, importc: "ZM_inv", dynlib: libname.}
proc ZM_rank*(x: GEN): clong {.cdecl, importc: "ZM_rank", dynlib: libname.}
proc ZlM_gauss*(a: GEN; b: GEN; p: pari_ulong; e: clong; C: GEN): GEN {.cdecl,
    importc: "ZlM_gauss", dynlib: libname.}
proc closemodinvertible*(x: GEN; y: GEN): GEN {.cdecl, importc: "closemodinvertible",
    dynlib: libname.}
proc deplin*(x: GEN): GEN {.cdecl, importc: "deplin", dynlib: libname.}
proc det*(a: GEN): GEN {.cdecl, importc: "det", dynlib: libname.}
proc det0*(a: GEN; flag: clong): GEN {.cdecl, importc: "det0", dynlib: libname.}
proc det2*(a: GEN): GEN {.cdecl, importc: "det2", dynlib: libname.}
proc detint*(x: GEN): GEN {.cdecl, importc: "detint", dynlib: libname.}
proc eigen*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "eigen", dynlib: libname.}
proc gauss*(a: GEN; b: GEN): GEN {.cdecl, importc: "gauss", dynlib: libname.}
proc gaussmodulo*(M: GEN; D: GEN; Y: GEN): GEN {.cdecl, importc: "gaussmodulo",
    dynlib: libname.}
proc gaussmodulo2*(M: GEN; D: GEN; Y: GEN): GEN {.cdecl, importc: "gaussmodulo2",
    dynlib: libname.}
proc gen_Gauss*(a: GEN; b: GEN; E: pointer; ff: ptr bb_field): GEN {.cdecl,
    importc: "gen_Gauss", dynlib: libname.}
proc gen_Gauss_pivot*(x: GEN; rr: ptr clong; E: pointer; ff: ptr bb_field): GEN {.cdecl,
    importc: "gen_Gauss_pivot", dynlib: libname.}
proc gen_det*(a: GEN; E: pointer; ff: ptr bb_field): GEN {.cdecl, importc: "gen_det",
    dynlib: libname.}
proc gen_ker*(x: GEN; deplin: clong; E: pointer; ff: ptr bb_field): GEN {.cdecl,
    importc: "gen_ker", dynlib: libname.}
proc gen_matcolmul*(a: GEN; b: GEN; E: pointer; ff: ptr bb_field): GEN {.cdecl,
    importc: "gen_matcolmul", dynlib: libname.}
proc gen_matmul*(a: GEN; b: GEN; E: pointer; ff: ptr bb_field): GEN {.cdecl,
    importc: "gen_matmul", dynlib: libname.}
proc image*(x: GEN): GEN {.cdecl, importc: "image", dynlib: libname.}
proc image2*(x: GEN): GEN {.cdecl, importc: "image2", dynlib: libname.}
proc imagecompl*(x: GEN): GEN {.cdecl, importc: "imagecompl", dynlib: libname.}
proc indexrank*(x: GEN): GEN {.cdecl, importc: "indexrank", dynlib: libname.}
proc inverseimage*(mat: GEN; y: GEN): GEN {.cdecl, importc: "inverseimage",
                                      dynlib: libname.}
proc ker*(x: GEN): GEN {.cdecl, importc: "ker", dynlib: libname.}
proc keri*(x: GEN): GEN {.cdecl, importc: "keri", dynlib: libname.}
proc mateigen*(x: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "mateigen",
    dynlib: libname.}
proc matimage0*(x: GEN; flag: clong): GEN {.cdecl, importc: "matimage0", dynlib: libname.}
proc matker0*(x: GEN; flag: clong): GEN {.cdecl, importc: "matker0", dynlib: libname.}
proc matsolvemod0*(M: GEN; D: GEN; Y: GEN; flag: clong): GEN {.cdecl,
    importc: "matsolvemod0", dynlib: libname.}
proc rank*(x: GEN): clong {.cdecl, importc: "rank", dynlib: libname.}
proc reducemodinvertible*(x: GEN; y: GEN): GEN {.cdecl, importc: "reducemodinvertible",
    dynlib: libname.}
proc reducemodlll*(x: GEN; y: GEN): GEN {.cdecl, importc: "reducemodlll", dynlib: libname.}
proc split_realimag*(x: GEN; r1: clong; r2: clong): GEN {.cdecl,
    importc: "split_realimag", dynlib: libname.}
proc suppl*(x: GEN): GEN {.cdecl, importc: "suppl", dynlib: libname.}
proc FpM_charpoly*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpM_charpoly", dynlib: libname.}
proc FpM_hess*(x: GEN; p: GEN): GEN {.cdecl, importc: "FpM_hess", dynlib: libname.}
proc Flm_charpoly*(x: GEN; p: clong): GEN {.cdecl, importc: "Flm_charpoly",
                                      dynlib: libname.}
proc Flm_hess*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flm_hess", dynlib: libname.}
proc QM_minors_coprime*(x: GEN; pp: GEN): GEN {.cdecl, importc: "QM_minors_coprime",
    dynlib: libname.}
proc QM_ImZ_hnf*(x: GEN): GEN {.cdecl, importc: "QM_ImZ_hnf", dynlib: libname.}
proc QM_ImQ_hnf*(x: GEN): GEN {.cdecl, importc: "QM_ImQ_hnf", dynlib: libname.}
proc gnorml1_fake*(x: GEN): GEN {.cdecl, importc: "gnorml1_fake", dynlib: libname.}
proc ZM_charpoly*(x: GEN): GEN {.cdecl, importc: "ZM_charpoly", dynlib: libname.}
proc adj*(x: GEN): GEN {.cdecl, importc: "adj", dynlib: libname.}
proc adjsafe*(x: GEN): GEN {.cdecl, importc: "adjsafe", dynlib: libname.}
proc caract*(x: GEN; v: clong): GEN {.cdecl, importc: "caract", dynlib: libname.}
proc caradj*(x: GEN; v: clong; py: ptr GEN): GEN {.cdecl, importc: "caradj", dynlib: libname.}
proc carberkowitz*(x: GEN; v: clong): GEN {.cdecl, importc: "carberkowitz",
                                      dynlib: libname.}
proc carhess*(x: GEN; v: clong): GEN {.cdecl, importc: "carhess", dynlib: libname.}
proc charpoly*(x: GEN; v: clong): GEN {.cdecl, importc: "charpoly", dynlib: libname.}
proc charpoly0*(x: GEN; v: clong; flag: clong): GEN {.cdecl, importc: "charpoly0",
    dynlib: libname.}
proc gnorm*(x: GEN): GEN {.cdecl, importc: "gnorm", dynlib: libname.}
proc gnorml1*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gnorml1", dynlib: libname.}
proc gnormlp*(x: GEN; p: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gnormlp",
    dynlib: libname.}
proc gnorml2*(x: GEN): GEN {.cdecl, importc: "gnorml2", dynlib: libname.}
proc gsupnorm*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gsupnorm", dynlib: libname.}
proc gsupnorm_aux*(x: GEN; m: ptr GEN; msq: ptr GEN; prec: clong=pari_default_prec) {.cdecl,
    importc: "gsupnorm_aux", dynlib: libname.}
proc gtrace*(x: GEN): GEN {.cdecl, importc: "gtrace", dynlib: libname.}
proc hess*(x: GEN): GEN {.cdecl, importc: "hess", dynlib: libname.}
proc intersect*(x: GEN; y: GEN): GEN {.cdecl, importc: "intersect", dynlib: libname.}
proc jacobi*(a: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "jacobi", dynlib: libname.}
proc matadjoint0*(x: GEN; flag: clong): GEN {.cdecl, importc: "matadjoint0",
                                        dynlib: libname.}
proc matcompanion*(x: GEN): GEN {.cdecl, importc: "matcompanion", dynlib: libname.}
proc matrixqz0*(x: GEN; pp: GEN): GEN {.cdecl, importc: "matrixqz0", dynlib: libname.}
proc minpoly*(x: GEN; v: clong): GEN {.cdecl, importc: "minpoly", dynlib: libname.}
proc qfgaussred*(a: GEN): GEN {.cdecl, importc: "qfgaussred", dynlib: libname.}
proc qfgaussred_positive*(a: GEN): GEN {.cdecl, importc: "qfgaussred_positive",
                                     dynlib: libname.}
proc qfsign*(a: GEN): GEN {.cdecl, importc: "qfsign", dynlib: libname.}
proc apply0*(f: GEN; A: GEN): GEN {.cdecl, importc: "apply0", dynlib: libname.}
proc diagonal*(x: GEN): GEN {.cdecl, importc: "diagonal", dynlib: libname.}
proc diagonal_shallow*(x: GEN): GEN {.cdecl, importc: "diagonal_shallow",
                                  dynlib: libname.}
proc extract0*(x: GEN; l1: GEN; l2: GEN): GEN {.cdecl, importc: "extract0", dynlib: libname.}
proc genapply*(E: pointer; f: proc (E: pointer; x: GEN): GEN {.cdecl.}; A: GEN): GEN {.cdecl,
    importc: "genapply", dynlib: libname.}
proc genindexselect*(E: pointer; f: proc (E: pointer; x: GEN): clong {.cdecl.}; A: GEN): GEN {.
    cdecl, importc: "genindexselect", dynlib: libname.}
proc genselect*(E: pointer; f: proc (E: pointer; x: GEN): clong {.cdecl.}; A: GEN): GEN {.
    cdecl, importc: "genselect", dynlib: libname.}
proc gtomat*(x: GEN): GEN {.cdecl, importc: "gtomat", dynlib: libname.}
proc gtrans*(x: GEN): GEN {.cdecl, importc: "gtrans", dynlib: libname.}
proc matmuldiagonal*(x: GEN; d: GEN): GEN {.cdecl, importc: "matmuldiagonal",
                                      dynlib: libname.}
proc matmultodiagonal*(x: GEN; y: GEN): GEN {.cdecl, importc: "matmultodiagonal",
                                        dynlib: libname.}
proc matslice0*(A: GEN; x1: clong; x2: clong; y1: clong; y2: clong): GEN {.cdecl,
    importc: "matslice0", dynlib: libname.}
proc parapply*(V: GEN; C: GEN): GEN {.cdecl, importc: "parapply", dynlib: libname.}
proc parselect*(C: GEN; D: GEN; flag: clong): GEN {.cdecl, importc: "parselect",
    dynlib: libname.}
proc select0*(A: GEN; f: GEN; flag: clong): GEN {.cdecl, importc: "select0",
    dynlib: libname.}
proc shallowextract*(x: GEN; L: GEN): GEN {.cdecl, importc: "shallowextract",
                                      dynlib: libname.}
proc shallowtrans*(x: GEN): GEN {.cdecl, importc: "shallowtrans", dynlib: libname.}
proc vecapply*(E: pointer; f: proc (E: pointer; x: GEN): GEN {.cdecl.}; x: GEN): GEN {.cdecl,
    importc: "vecapply", dynlib: libname.}
proc veccatapply*(E: pointer; f: proc (E: pointer; x: GEN): GEN {.cdecl.}; x: GEN): GEN {.
    cdecl, importc: "veccatapply", dynlib: libname.}
proc veccatselapply*(Epred: pointer;
                    pred: proc (E: pointer; x: GEN): clong {.cdecl.}; Efun: pointer;
                    fun: proc (E: pointer; x: GEN): GEN {.cdecl.}; A: GEN): GEN {.cdecl,
    importc: "veccatselapply", dynlib: libname.}
proc vecrange*(a: GEN; b: GEN): GEN {.cdecl, importc: "vecrange", dynlib: libname.}
proc vecrangess*(a: clong; b: clong): GEN {.cdecl, importc: "vecrangess", dynlib: libname.}
proc vecselapply*(Epred: pointer; pred: proc (E: pointer; x: GEN): clong {.cdecl.};
                 Efun: pointer; fun: proc (E: pointer; x: GEN): GEN {.cdecl.}; A: GEN): GEN {.
    cdecl, importc: "vecselapply", dynlib: libname.}
proc vecselect*(E: pointer; f: proc (E: pointer; x: GEN): clong {.cdecl.}; A: GEN): GEN {.
    cdecl, importc: "vecselect", dynlib: libname.}
proc vecslice0*(A: GEN; y1: clong; y2: clong): GEN {.cdecl, importc: "vecslice0",
    dynlib: libname.}
proc vecsum*(v: GEN): GEN {.cdecl, importc: "vecsum", dynlib: libname.}
proc addhelp*(e: cstring; s: cstring) {.cdecl, importc: "addhelp", dynlib: libname.}
proc alias0*(s: cstring; old: cstring) {.cdecl, importc: "alias0", dynlib: libname.}
proc compile_str*(s: cstring): GEN {.cdecl, importc: "compile_str", dynlib: libname.}
proc chartoGENstr*(c: char): GEN {.cdecl, importc: "chartoGENstr", dynlib: libname.}
proc delete_var*(): clong {.cdecl, importc: "delete_var", dynlib: libname.}
proc fetch_named_var*(s: cstring): ptr entree {.cdecl, importc: "fetch_named_var",
    dynlib: libname.}
proc fetch_user_var*(s: cstring): clong {.cdecl, importc: "fetch_user_var",
                                      dynlib: libname.}
proc fetch_var*(): clong {.cdecl, importc: "fetch_var", dynlib: libname.}
proc fetch_var_value*(vx: clong; t: GEN): GEN {.cdecl, importc: "fetch_var_value",
    dynlib: libname.}
proc gp_read_str*(t: cstring): GEN {.cdecl, importc: "gp_read_str", dynlib: libname.}
proc install*(f: pointer; name: cstring; code: cstring): ptr entree {.cdecl,
    importc: "install", dynlib: libname.}
proc is_entry*(s: cstring): ptr entree {.cdecl, importc: "is_entry", dynlib: libname.}
proc kill0*(e: cstring) {.cdecl, importc: "kill0", dynlib: libname.}
proc manage_var*(n: clong; ep: ptr entree): clong {.cdecl, importc: "manage_var",
    dynlib: libname.}
proc pari_var_init*() {.cdecl, importc: "pari_var_init", dynlib: libname.}
proc pari_var_next*(): clong {.cdecl, importc: "pari_var_next", dynlib: libname.}
proc pari_var_next_temp*(): clong {.cdecl, importc: "pari_var_next_temp",
                                 dynlib: libname.}
proc pari_var_create*(ep: ptr entree) {.cdecl, importc: "pari_var_create",
                                    dynlib: libname.}
proc name_var*(n: clong; s: cstring) {.cdecl, importc: "name_var", dynlib: libname.}
proc readseq*(t: cstring): GEN {.cdecl, importc: "readseq", dynlib: libname.}
proc safegel*(x: GEN; par_l: clong): ptr GEN {.cdecl, importc: "safegel", dynlib: libname.}
proc safeel*(x: GEN; par_l: clong): ptr clong {.cdecl, importc: "safeel", dynlib: libname.}
proc safelistel*(x: GEN; par_l: clong): ptr GEN {.cdecl, importc: "safelistel",
    dynlib: libname.}
proc safegcoeff*(x: GEN; a: clong; b: clong): ptr GEN {.cdecl, importc: "safegcoeff",
    dynlib: libname.}
proc strntoGENstr*(s: cstring; n0: clong): GEN {.cdecl, importc: "strntoGENstr",
    dynlib: libname.}
proc strtoGENstr*(s: cstring): GEN {.cdecl, importc: "strtoGENstr", dynlib: libname.}
proc strtoi*(s: cstring): GEN {.cdecl, importc: "strtoi", dynlib: libname.}
proc strtor*(s: cstring; prec: clong=pari_default_prec): GEN {.cdecl, importc: "strtor", dynlib: libname.}
proc type0*(x: GEN): GEN {.cdecl, importc: "type0", dynlib: libname.}
proc isprimeAPRCL*(N: GEN): clong {.cdecl, importc: "isprimeAPRCL", dynlib: libname.}
proc Qfb0*(x: GEN; y: GEN; z: GEN; d: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "Qfb0",
    dynlib: libname.}
proc check_quaddisc*(x: GEN; s: ptr clong; r: ptr clong; f: cstring) {.cdecl,
    importc: "check_quaddisc", dynlib: libname.}
proc check_quaddisc_imag*(x: GEN; r: ptr clong; f: cstring) {.cdecl,
    importc: "check_quaddisc_imag", dynlib: libname.}
proc check_quaddisc_real*(x: GEN; r: ptr clong; f: cstring) {.cdecl,
    importc: "check_quaddisc_real", dynlib: libname.}
proc cornacchia*(d: GEN; p: GEN; px: ptr GEN; py: ptr GEN): clong {.cdecl,
    importc: "cornacchia", dynlib: libname.}
proc cornacchia2*(d: GEN; p: GEN; px: ptr GEN; py: ptr GEN): clong {.cdecl,
    importc: "cornacchia2", dynlib: libname.}
proc nucomp*(x: GEN; y: GEN; par1: GEN): GEN {.cdecl, importc: "nucomp", dynlib: libname.}
proc nudupl*(x: GEN; par1: GEN): GEN {.cdecl, importc: "nudupl", dynlib: libname.}
proc nupow*(x: GEN; n: GEN): GEN {.cdecl, importc: "nupow", dynlib: libname.}
proc primeform*(x: GEN; p: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "primeform",
    dynlib: libname.}
proc primeform_u*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "primeform_u",
    dynlib: libname.}
proc qfbcompraw*(x: GEN; y: GEN): GEN {.cdecl, importc: "qfbcompraw", dynlib: libname.}
proc qfbpowraw*(x: GEN; n: clong): GEN {.cdecl, importc: "qfbpowraw", dynlib: libname.}
proc qfbred0*(x: GEN; flag: clong; D: GEN; isqrtD: GEN; sqrtD: GEN): GEN {.cdecl,
    importc: "qfbred0", dynlib: libname.}
proc qfbsolve*(Q: GEN; n: GEN): GEN {.cdecl, importc: "qfbsolve", dynlib: libname.}
proc qfi*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc: "qfi", dynlib: libname.}
proc qfi_1*(x: GEN): GEN {.cdecl, importc: "qfi_1", dynlib: libname.}
proc qficomp*(x: GEN; y: GEN): GEN {.cdecl, importc: "qficomp", dynlib: libname.}
proc qficompraw*(x: GEN; y: GEN): GEN {.cdecl, importc: "qficompraw", dynlib: libname.}
proc qfipowraw*(x: GEN; n: clong): GEN {.cdecl, importc: "qfipowraw", dynlib: libname.}
proc qfisolvep*(Q: GEN; p: GEN): GEN {.cdecl, importc: "qfisolvep", dynlib: libname.}
proc qfisqr*(x: GEN): GEN {.cdecl, importc: "qfisqr", dynlib: libname.}
proc qfisqrraw*(x: GEN): GEN {.cdecl, importc: "qfisqrraw", dynlib: libname.}
proc qfr*(x: GEN; y: GEN; z: GEN; d: GEN): GEN {.cdecl, importc: "qfr", dynlib: libname.}
proc qfr3_comp*(x: GEN; y: GEN; S: ptr qfr_data): GEN {.cdecl, importc: "qfr3_comp",
    dynlib: libname.}
proc qfr3_pow*(x: GEN; n: GEN; S: ptr qfr_data): GEN {.cdecl, importc: "qfr3_pow",
    dynlib: libname.}
proc qfr3_red*(x: GEN; S: ptr qfr_data): GEN {.cdecl, importc: "qfr3_red", dynlib: libname.}
proc qfr3_rho*(x: GEN; S: ptr qfr_data): GEN {.cdecl, importc: "qfr3_rho", dynlib: libname.}
proc qfr3_to_qfr*(x: GEN; z: GEN): GEN {.cdecl, importc: "qfr3_to_qfr", dynlib: libname.}
proc qfr5_comp*(x: GEN; y: GEN; S: ptr qfr_data): GEN {.cdecl, importc: "qfr5_comp",
    dynlib: libname.}
proc qfr5_dist*(e: GEN; d: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "qfr5_dist",
    dynlib: libname.}
proc qfr5_pow*(x: GEN; n: GEN; S: ptr qfr_data): GEN {.cdecl, importc: "qfr5_pow",
    dynlib: libname.}
proc qfr5_red*(x: GEN; S: ptr qfr_data): GEN {.cdecl, importc: "qfr5_red", dynlib: libname.}
proc qfr5_rho*(x: GEN; S: ptr qfr_data): GEN {.cdecl, importc: "qfr5_rho", dynlib: libname.}
proc qfr5_to_qfr*(x: GEN; d0: GEN): GEN {.cdecl, importc: "qfr5_to_qfr", dynlib: libname.}
proc qfr_1*(x: GEN): GEN {.cdecl, importc: "qfr_1", dynlib: libname.}
proc qfr_data_init*(D: GEN; prec: clong=pari_default_prec; S: ptr qfr_data) {.cdecl,
    importc: "qfr_data_init", dynlib: libname.}
proc qfr_to_qfr5*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "qfr_to_qfr5",
                                        dynlib: libname.}
proc qfrcomp*(x: GEN; y: GEN): GEN {.cdecl, importc: "qfrcomp", dynlib: libname.}
proc qfrcompraw*(x: GEN; y: GEN): GEN {.cdecl, importc: "qfrcompraw", dynlib: libname.}
proc qfrpow*(x: GEN; n: GEN): GEN {.cdecl, importc: "qfrpow", dynlib: libname.}
proc qfrpowraw*(x: GEN; n: clong): GEN {.cdecl, importc: "qfrpowraw", dynlib: libname.}
proc qfrsolvep*(Q: GEN; p: GEN): GEN {.cdecl, importc: "qfrsolvep", dynlib: libname.}
proc qfrsqr*(x: GEN): GEN {.cdecl, importc: "qfrsqr", dynlib: libname.}
proc qfrsqrraw*(x: GEN): GEN {.cdecl, importc: "qfrsqrraw", dynlib: libname.}
proc quadgen*(x: GEN): GEN {.cdecl, importc: "quadgen", dynlib: libname.}
proc quadpoly*(x: GEN): GEN {.cdecl, importc: "quadpoly", dynlib: libname.}
proc quadpoly0*(x: GEN; v: clong): GEN {.cdecl, importc: "quadpoly0", dynlib: libname.}
proc redimag*(x: GEN): GEN {.cdecl, importc: "redimag", dynlib: libname.}
proc redreal*(x: GEN): GEN {.cdecl, importc: "redreal", dynlib: libname.}
proc redrealnod*(x: GEN; isqrtD: GEN): GEN {.cdecl, importc: "redrealnod",
                                       dynlib: libname.}
proc rhoreal*(x: GEN): GEN {.cdecl, importc: "rhoreal", dynlib: libname.}
proc rhorealnod*(x: GEN; isqrtD: GEN): GEN {.cdecl, importc: "rhorealnod",
                                       dynlib: libname.}
proc Fl_order*(a: pari_ulong; o: pari_ulong; p: pari_ulong): pari_ulong {.cdecl,
    importc: "Fl_order", dynlib: libname.}
proc Fl_powu*(x: pari_ulong; n: pari_ulong; p: pari_ulong): pari_ulong {.cdecl,
    importc: "Fl_powu", dynlib: libname.}
proc Fl_sqrt*(a: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc: "Fl_sqrt",
    dynlib: libname.}
proc Fp_factored_order*(a: GEN; o: GEN; p: GEN): GEN {.cdecl,
    importc: "Fp_factored_order", dynlib: libname.}
proc Fp_ispower*(x: GEN; K: GEN; p: GEN): cint {.cdecl, importc: "Fp_ispower",
    dynlib: libname.}
proc Fp_log*(a: GEN; g: GEN; ord: GEN; p: GEN): GEN {.cdecl, importc: "Fp_log",
    dynlib: libname.}
proc Fp_order*(a: GEN; o: GEN; p: GEN): GEN {.cdecl, importc: "Fp_order", dynlib: libname.}
proc Fp_pow*(a: GEN; n: GEN; m: GEN): GEN {.cdecl, importc: "Fp_pow", dynlib: libname.}
proc Fp_pows*(A: GEN; k: clong; N: GEN): GEN {.cdecl, importc: "Fp_pows", dynlib: libname.}
proc Fp_powu*(x: GEN; k: pari_ulong; p: GEN): GEN {.cdecl, importc: "Fp_powu",
    dynlib: libname.}
proc Fp_sqrt*(a: GEN; p: GEN): GEN {.cdecl, importc: "Fp_sqrt", dynlib: libname.}
proc Fp_sqrtn*(a: GEN; n: GEN; p: GEN; zetan: ptr GEN): GEN {.cdecl, importc: "Fp_sqrtn",
    dynlib: libname.}
proc Z_chinese*(a: GEN; b: GEN; A: GEN; B: GEN): GEN {.cdecl, importc: "Z_chinese",
    dynlib: libname.}
proc Z_chinese_all*(a: GEN; b: GEN; A: GEN; B: GEN; pC: ptr GEN): GEN {.cdecl,
    importc: "Z_chinese_all", dynlib: libname.}
proc Z_chinese_coprime*(a: GEN; b: GEN; A: GEN; B: GEN; C: GEN): GEN {.cdecl,
    importc: "Z_chinese_coprime", dynlib: libname.}
proc Z_chinese_post*(a: GEN; b: GEN; C: GEN; U: GEN; d: GEN): GEN {.cdecl,
    importc: "Z_chinese_post", dynlib: libname.}
proc Z_chinese_pre*(A: GEN; B: GEN; pC: ptr GEN; pU: ptr GEN; pd: ptr GEN) {.cdecl,
    importc: "Z_chinese_pre", dynlib: libname.}
proc Z_factor_listP*(N: GEN; L: GEN): GEN {.cdecl, importc: "Z_factor_listP",
                                      dynlib: libname.}
proc Z_isanypower*(x: GEN; y: ptr GEN): clong {.cdecl, importc: "Z_isanypower",
    dynlib: libname.}
proc Z_isfundamental*(x: GEN): clong {.cdecl, importc: "Z_isfundamental",
                                   dynlib: libname.}
proc Z_ispow2*(x: GEN): clong {.cdecl, importc: "Z_ispow2", dynlib: libname.}
proc Z_ispowerall*(x: GEN; k: pari_ulong; pt: ptr GEN): clong {.cdecl,
    importc: "Z_ispowerall", dynlib: libname.}
proc Z_issquareall*(x: GEN; pt: ptr GEN): clong {.cdecl, importc: "Z_issquareall",
    dynlib: libname.}
proc Zp_issquare*(a: GEN; p: GEN): clong {.cdecl, importc: "Zp_issquare", dynlib: libname.}
proc bestappr*(x: GEN; k: GEN): GEN {.cdecl, importc: "bestappr", dynlib: libname.}
proc bestapprPade*(x: GEN; B: clong): GEN {.cdecl, importc: "bestapprPade",
                                      dynlib: libname.}
proc cgcd*(a: clong; b: clong): clong {.cdecl, importc: "cgcd", dynlib: libname.}
proc chinese*(x: GEN; y: GEN): GEN {.cdecl, importc: "chinese", dynlib: libname.}
proc chinese1*(x: GEN): GEN {.cdecl, importc: "chinese1", dynlib: libname.}
proc chinese1_coprime_Z*(x: GEN): GEN {.cdecl, importc: "chinese1_coprime_Z",
                                    dynlib: libname.}
proc classno*(x: GEN): GEN {.cdecl, importc: "classno", dynlib: libname.}
proc classno2*(x: GEN): GEN {.cdecl, importc: "classno2", dynlib: libname.}
proc clcm*(a: clong; b: clong): clong {.cdecl, importc: "clcm", dynlib: libname.}
proc contfrac0*(x: GEN; b: GEN; flag: clong): GEN {.cdecl, importc: "contfrac0",
    dynlib: libname.}
proc contfracpnqn*(x: GEN; n: clong): GEN {.cdecl, importc: "contfracpnqn",
                                      dynlib: libname.}
proc fibo*(n: clong): GEN {.cdecl, importc: "fibo", dynlib: libname.}
proc gboundcf*(x: GEN; k: clong): GEN {.cdecl, importc: "gboundcf", dynlib: libname.}
proc gcf*(x: GEN): GEN {.cdecl, importc: "gcf", dynlib: libname.}
proc gcf2*(b: GEN; x: GEN): GEN {.cdecl, importc: "gcf2", dynlib: libname.}
proc get_Fp_field*(E: ptr pointer; p: GEN): ptr bb_field {.cdecl,
    importc: "get_Fp_field", dynlib: libname.}
proc pgener_Fl*(p: pari_ulong): pari_ulong {.cdecl, importc: "pgener_Fl",
    dynlib: libname.}
proc pgener_Fl_local*(p: pari_ulong; L: GEN): pari_ulong {.cdecl,
    importc: "pgener_Fl_local", dynlib: libname.}
proc pgener_Fp*(p: GEN): GEN {.cdecl, importc: "pgener_Fp", dynlib: libname.}
proc pgener_Fp_local*(p: GEN; L: GEN): GEN {.cdecl, importc: "pgener_Fp_local",
                                       dynlib: libname.}
proc pgener_Zl*(p: pari_ulong): pari_ulong {.cdecl, importc: "pgener_Zl",
    dynlib: libname.}
proc pgener_Zp*(p: GEN): GEN {.cdecl, importc: "pgener_Zp", dynlib: libname.}
proc gisanypower*(x: GEN; pty: ptr GEN): clong {.cdecl, importc: "gisanypower",
    dynlib: libname.}
proc gissquare*(x: GEN): GEN {.cdecl, importc: "gissquare", dynlib: libname.}
proc gissquareall*(x: GEN; pt: ptr GEN): GEN {.cdecl, importc: "gissquareall",
                                        dynlib: libname.}
proc hclassno*(x: GEN): GEN {.cdecl, importc: "hclassno", dynlib: libname.}
proc hilbert*(x: GEN; y: GEN; p: GEN): clong {.cdecl, importc: "hilbert", dynlib: libname.}
proc hilbertii*(x: GEN; y: GEN; p: GEN): clong {.cdecl, importc: "hilbertii",
    dynlib: libname.}
proc isfundamental*(x: GEN): clong {.cdecl, importc: "isfundamental", dynlib: libname.}
proc ispolygonal*(x: GEN; S: GEN; N: ptr GEN): clong {.cdecl, importc: "ispolygonal",
    dynlib: libname.}
proc ispower*(x: GEN; k: GEN; pty: ptr GEN): clong {.cdecl, importc: "ispower",
    dynlib: libname.}
proc isprimepower*(x: GEN; pty: ptr GEN): clong {.cdecl, importc: "isprimepower",
    dynlib: libname.}
proc issquare*(x: GEN): clong {.cdecl, importc: "issquare", dynlib: libname.}
proc issquareall*(x: GEN; pt: ptr GEN): clong {.cdecl, importc: "issquareall",
    dynlib: libname.}
proc krois*(x: GEN; y: clong): clong {.cdecl, importc: "krois", dynlib: libname.}
proc kroiu*(x: GEN; y: pari_ulong): clong {.cdecl, importc: "kroiu", dynlib: libname.}
proc kronecker*(x: GEN; y: GEN): clong {.cdecl, importc: "kronecker", dynlib: libname.}
proc krosi*(s: clong; x: GEN): clong {.cdecl, importc: "krosi", dynlib: libname.}
proc kross*(x: clong; y: clong): clong {.cdecl, importc: "kross", dynlib: libname.}
proc krouu*(x: pari_ulong; y: pari_ulong): clong {.cdecl, importc: "krouu",
    dynlib: libname.}
proc lcmii*(a: GEN; b: GEN): GEN {.cdecl, importc: "lcmii", dynlib: libname.}
proc logint*(B: GEN; y: GEN; ptq: ptr GEN): clong {.cdecl, importc: "logint",
    dynlib: libname.}
proc logint0*(B: GEN; y: GEN; ptq: ptr GEN): clong {.cdecl, importc: "logint0",
    dynlib: libname.}
proc mpfact*(n: clong): GEN {.cdecl, importc: "mpfact", dynlib: libname.}
proc mulu_interval*(a: pari_ulong; b: pari_ulong): GEN {.cdecl,
    importc: "mulu_interval", dynlib: libname.}
proc odd_prime_divisors*(q: GEN): GEN {.cdecl, importc: "odd_prime_divisors",
                                    dynlib: libname.}
proc order*(x: GEN): GEN {.cdecl, importc: "order", dynlib: libname.}
proc pnqn*(x: GEN): GEN {.cdecl, importc: "pnqn", dynlib: libname.}
proc qfbclassno0*(x: GEN; flag: clong): GEN {.cdecl, importc: "qfbclassno0",
                                        dynlib: libname.}
proc quaddisc*(x: GEN): GEN {.cdecl, importc: "quaddisc", dynlib: libname.}
proc quadregulator*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "quadregulator",
    dynlib: libname.}
proc quadunit*(x: GEN): GEN {.cdecl, importc: "quadunit", dynlib: libname.}
proc rootsof1_Fl*(n: pari_ulong; p: pari_ulong): pari_ulong {.cdecl,
    importc: "rootsof1_Fl", dynlib: libname.}
proc rootsof1_Fp*(n: GEN; p: GEN): GEN {.cdecl, importc: "rootsof1_Fp", dynlib: libname.}
proc rootsof1u_Fp*(n: pari_ulong; p: GEN): GEN {.cdecl, importc: "rootsof1u_Fp",
    dynlib: libname.}
proc sqrtint*(a: GEN): GEN {.cdecl, importc: "sqrtint", dynlib: libname.}
proc ugcd*(a: pari_ulong; b: pari_ulong): pari_ulong {.cdecl, importc: "ugcd",
    dynlib: libname.}
proc uisprimepower*(n: pari_ulong; p: ptr pari_ulong): clong {.cdecl,
    importc: "uisprimepower", dynlib: libname.}
proc uissquare*(A: pari_ulong): clong {.cdecl, importc: "uissquare", dynlib: libname.}
proc uissquareall*(A: pari_ulong; sqrtA: ptr pari_ulong): clong {.cdecl,
    importc: "uissquareall", dynlib: libname.}
proc unegisfundamental*(x: pari_ulong): clong {.cdecl, importc: "unegisfundamental",
    dynlib: libname.}
proc uposisfundamental*(x: pari_ulong): clong {.cdecl, importc: "uposisfundamental",
    dynlib: libname.}
proc znlog*(x: GEN; g: GEN; o: GEN): GEN {.cdecl, importc: "znlog", dynlib: libname.}
proc znorder*(x: GEN; o: GEN): GEN {.cdecl, importc: "znorder", dynlib: libname.}
proc znprimroot*(m: GEN): GEN {.cdecl, importc: "znprimroot", dynlib: libname.}
proc znstar*(x: GEN): GEN {.cdecl, importc: "znstar", dynlib: libname.}
proc Z_smoothen*(N: GEN; L: GEN; pP: ptr GEN; pe: ptr GEN): GEN {.cdecl,
    importc: "Z_smoothen", dynlib: libname.}
proc boundfact*(n: GEN; lim: pari_ulong): GEN {.cdecl, importc: "boundfact",
    dynlib: libname.}
proc check_arith_pos*(n: GEN; f: cstring): GEN {.cdecl, importc: "check_arith_pos",
    dynlib: libname.}
proc check_arith_non0*(n: GEN; f: cstring): GEN {.cdecl, importc: "check_arith_non0",
    dynlib: libname.}
proc check_arith_all*(n: GEN; f: cstring): GEN {.cdecl, importc: "check_arith_all",
    dynlib: libname.}
proc clean_Z_factor*(f: GEN): GEN {.cdecl, importc: "clean_Z_factor", dynlib: libname.}
proc corepartial*(n: GEN; par_l: clong): GEN {.cdecl, importc: "corepartial",
    dynlib: libname.}
proc core0*(n: GEN; flag: clong): GEN {.cdecl, importc: "core0", dynlib: libname.}
proc core2*(n: GEN): GEN {.cdecl, importc: "core2", dynlib: libname.}
proc core2partial*(n: GEN; par_l: clong): GEN {.cdecl, importc: "core2partial",
    dynlib: libname.}
proc coredisc*(n: GEN): GEN {.cdecl, importc: "coredisc", dynlib: libname.}
proc coredisc0*(n: GEN; flag: clong): GEN {.cdecl, importc: "coredisc0", dynlib: libname.}
proc coredisc2*(n: GEN): GEN {.cdecl, importc: "coredisc2", dynlib: libname.}
proc digits*(N: GEN; B: GEN): GEN {.cdecl, importc: "digits", dynlib: libname.}
proc divisors*(n: GEN): GEN {.cdecl, importc: "divisors", dynlib: libname.}
proc divisorsu*(n: pari_ulong): GEN {.cdecl, importc: "divisorsu", dynlib: libname.}
proc factor_pn_1*(p: GEN; n: pari_ulong): GEN {.cdecl, importc: "factor_pn_1",
    dynlib: libname.}
proc factor_pn_1_limit*(p: GEN; n: clong; lim: pari_ulong): GEN {.cdecl,
    importc: "factor_pn_1_limit", dynlib: libname.}
proc factoru_pow*(n: pari_ulong): GEN {.cdecl, importc: "factoru_pow", dynlib: libname.}
proc initprimes*(maxnum: pari_ulong; lenp: ptr clong; lastp: ptr pari_ulong): byteptr {.
    cdecl, importc: "initprimes", dynlib: libname.}
proc initprimetable*(maxnum: pari_ulong) {.cdecl, importc: "initprimetable",
                                        dynlib: libname.}
proc init_primepointer_geq*(a: pari_ulong; pd: ptr byteptr): pari_ulong {.cdecl,
    importc: "init_primepointer_geq", dynlib: libname.}
proc init_primepointer_gt*(a: pari_ulong; pd: ptr byteptr): pari_ulong {.cdecl,
    importc: "init_primepointer_gt", dynlib: libname.}
proc init_primepointer_leq*(a: pari_ulong; pd: ptr byteptr): pari_ulong {.cdecl,
    importc: "init_primepointer_leq", dynlib: libname.}
proc init_primepointer_lt*(a: pari_ulong; pd: ptr byteptr): pari_ulong {.cdecl,
    importc: "init_primepointer_lt", dynlib: libname.}
proc is_Z_factor*(f: GEN): cint {.cdecl, importc: "is_Z_factor", dynlib: libname.}
proc is_Z_factornon0*(f: GEN): cint {.cdecl, importc: "is_Z_factornon0",
                                  dynlib: libname.}
proc is_Z_factorpos*(f: GEN): cint {.cdecl, importc: "is_Z_factorpos", dynlib: libname.}
proc maxprime*(): pari_ulong {.cdecl, importc: "maxprime", dynlib: libname.}
proc maxprime_check*(c: pari_ulong) {.cdecl, importc: "maxprime_check",
                                   dynlib: libname.}
proc sumdigits*(n: GEN): GEN {.cdecl, importc: "sumdigits", dynlib: libname.}
proc sumdigitsu*(n: pari_ulong): pari_ulong {.cdecl, importc: "sumdigitsu",
    dynlib: libname.}
proc glambdak*(nfz: GEN; s: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "glambdak",
    dynlib: libname.}
proc gzetak*(nfz: GEN; s: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gzetak",
    dynlib: libname.}
proc gzetakall*(nfz: GEN; s: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "gzetakall", dynlib: libname.}
proc initzeta*(pol: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "initzeta", dynlib: libname.}
proc dirzetak*(nf: GEN; b: GEN): GEN {.cdecl, importc: "dirzetak", dynlib: libname.}
proc FpX_FpC_nfpoleval*(nf: GEN; pol: GEN; a: GEN; p: GEN): GEN {.cdecl,
    importc: "FpX_FpC_nfpoleval", dynlib: libname.}
proc embed_T2*(x: GEN; r1: clong): GEN {.cdecl, importc: "embed_T2", dynlib: libname.}
proc embednorm_T2*(x: GEN; r1: clong): GEN {.cdecl, importc: "embednorm_T2",
                                       dynlib: libname.}
proc embed_norm*(x: GEN; r1: clong): GEN {.cdecl, importc: "embed_norm", dynlib: libname.}
proc check_ZKmodule*(x: GEN; s: cstring) {.cdecl, importc: "check_ZKmodule",
                                      dynlib: libname.}
proc checkbid*(bid: GEN) {.cdecl, importc: "checkbid", dynlib: libname.}
proc checkbnf*(bnf: GEN): GEN {.cdecl, importc: "checkbnf", dynlib: libname.}
proc checkbnr*(bnr: GEN) {.cdecl, importc: "checkbnr", dynlib: libname.}
proc checkbnrgen*(bnr: GEN) {.cdecl, importc: "checkbnrgen", dynlib: libname.}
proc checkabgrp*(v: GEN) {.cdecl, importc: "checkabgrp", dynlib: libname.}
proc checksqmat*(x: GEN; N: clong) {.cdecl, importc: "checksqmat", dynlib: libname.}
proc checknf*(nf: GEN): GEN {.cdecl, importc: "checknf", dynlib: libname.}
proc checknfelt_mod*(nf: GEN; x: GEN; s: cstring): GEN {.cdecl,
    importc: "checknfelt_mod", dynlib: libname.}
proc checkprid*(bid: GEN) {.cdecl, importc: "checkprid", dynlib: libname.}
proc checkrnf*(rnf: GEN) {.cdecl, importc: "checkrnf", dynlib: libname.}
proc factoredpolred*(x: GEN; fa: GEN): GEN {.cdecl, importc: "factoredpolred",
                                       dynlib: libname.}
proc factoredpolred2*(x: GEN; fa: GEN): GEN {.cdecl, importc: "factoredpolred2",
                                        dynlib: libname.}
proc galoisapply*(nf: GEN; aut: GEN; x: GEN): GEN {.cdecl, importc: "galoisapply",
    dynlib: libname.}
proc get_bnf*(x: GEN; t: ptr clong): GEN {.cdecl, importc: "get_bnf", dynlib: libname.}
proc get_bnfpol*(x: GEN; bnf: ptr GEN; nf: ptr GEN): GEN {.cdecl, importc: "get_bnfpol",
    dynlib: libname.}
proc get_nf*(x: GEN; t: ptr clong): GEN {.cdecl, importc: "get_nf", dynlib: libname.}
proc get_nfpol*(x: GEN; nf: ptr GEN): GEN {.cdecl, importc: "get_nfpol", dynlib: libname.}
proc get_prid*(x: GEN): GEN {.cdecl, importc: "get_prid", dynlib: libname.}
proc idealfrobenius*(nf: GEN; gal: GEN; pr: GEN): GEN {.cdecl, importc: "idealfrobenius",
    dynlib: libname.}
proc idealramgroups*(nf: GEN; gal: GEN; pr: GEN): GEN {.cdecl, importc: "idealramgroups",
    dynlib: libname.}
proc nf_get_allroots*(nf: GEN): GEN {.cdecl, importc: "nf_get_allroots",
                                  dynlib: libname.}
proc nf_get_prec*(x: GEN): clong {.cdecl, importc: "nf_get_prec", dynlib: libname.}
proc nfcertify*(x: GEN): GEN {.cdecl, importc: "nfcertify", dynlib: libname.}
proc nfgaloismatrix*(nf: GEN; s: GEN): GEN {.cdecl, importc: "nfgaloismatrix",
                                       dynlib: libname.}

proc nfinit*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "nfinit", dynlib: libname.}

proc nfinit0*(x: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "nfinit0",
    dynlib: libname.}

proc nfinitall*(x: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "nfinitall",
    dynlib: libname.}

proc nfinitred*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "nfinitred", dynlib: libname.}

proc nfinitred2*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "nfinitred2",
                                       dynlib: libname.}
proc nfisincl*(a: GEN; b: GEN): GEN {.cdecl, importc: "nfisincl", dynlib: libname.}
proc nfisisom*(a: GEN; b: GEN): GEN {.cdecl, importc: "nfisisom", dynlib: libname.}
proc nfnewprec*(nf: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "nfnewprec", dynlib: libname.}
proc nfnewprec_shallow*(nf: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "nfnewprec_shallow", dynlib: libname.}
proc nfpoleval*(nf: GEN; pol: GEN; a: GEN): GEN {.cdecl, importc: "nfpoleval",
    dynlib: libname.}
proc nftyp*(x: GEN): clong {.cdecl, importc: "nftyp", dynlib: libname.}
proc polredord*(x: GEN): GEN {.cdecl, importc: "polredord", dynlib: libname.}
proc polgalois*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "polgalois", dynlib: libname.}
proc polred*(x: GEN): GEN {.cdecl, importc: "polred", dynlib: libname.}
proc polred0*(x: GEN; flag: clong; p: GEN): GEN {.cdecl, importc: "polred0",
    dynlib: libname.}
proc polred2*(x: GEN): GEN {.cdecl, importc: "polred2", dynlib: libname.}
proc polredabs*(x: GEN): GEN {.cdecl, importc: "polredabs", dynlib: libname.}
proc polredabs0*(x: GEN; flag: clong): GEN {.cdecl, importc: "polredabs0",
                                       dynlib: libname.}
proc polredabs2*(x: GEN): GEN {.cdecl, importc: "polredabs2", dynlib: libname.}
proc polredabsall*(x: GEN; flun: clong): GEN {.cdecl, importc: "polredabsall",
    dynlib: libname.}
proc polredbest*(x: GEN; flag: clong): GEN {.cdecl, importc: "polredbest",
                                       dynlib: libname.}
proc rnfpolredabs*(nf: GEN; pol: GEN; flag: clong): GEN {.cdecl, importc: "rnfpolredabs",
    dynlib: libname.}
proc rnfpolredbest*(nf: GEN; relpol: GEN; flag: clong): GEN {.cdecl,
    importc: "rnfpolredbest", dynlib: libname.}
proc smallpolred*(x: GEN): GEN {.cdecl, importc: "smallpolred", dynlib: libname.}
proc smallpolred2*(x: GEN): GEN {.cdecl, importc: "smallpolred2", dynlib: libname.}
proc tschirnhaus*(x: GEN): GEN {.cdecl, importc: "tschirnhaus", dynlib: libname.}
proc ZX_Q_normalize*(pol: GEN; ptlc: ptr GEN): GEN {.cdecl, importc: "ZX_Q_normalize",
    dynlib: libname.}
proc ZX_Z_normalize*(pol: GEN; ptk: ptr GEN): GEN {.cdecl, importc: "ZX_Z_normalize",
    dynlib: libname.}
proc ZX_to_monic*(pol: GEN; lead: ptr GEN): GEN {.cdecl, importc: "ZX_to_monic",
    dynlib: libname.}
proc ZX_primitive_to_monic*(pol: GEN; lead: ptr GEN): GEN {.cdecl,
    importc: "ZX_primitive_to_monic", dynlib: libname.}
proc Fq_to_nf*(x: GEN; modpr: GEN): GEN {.cdecl, importc: "Fq_to_nf", dynlib: libname.}
proc FqM_to_nfM*(z: GEN; modpr: GEN): GEN {.cdecl, importc: "FqM_to_nfM", dynlib: libname.}
proc FqV_to_nfV*(z: GEN; modpr: GEN): GEN {.cdecl, importc: "FqV_to_nfV", dynlib: libname.}
proc FqX_to_nfX*(x: GEN; modpr: GEN): GEN {.cdecl, importc: "FqX_to_nfX", dynlib: libname.}
proc Rg_nffix*(f: cstring; T: GEN; c: GEN; lift: cint): GEN {.cdecl, importc: "Rg_nffix",
    dynlib: libname.}
proc RgV_nffix*(f: cstring; T: GEN; P: GEN; lift: cint): GEN {.cdecl, importc: "RgV_nffix",
    dynlib: libname.}
proc RgX_nffix*(s: cstring; nf: GEN; x: GEN; lift: cint): GEN {.cdecl,
    importc: "RgX_nffix", dynlib: libname.}
proc ZpX_disc_val*(f: GEN; p: GEN): clong {.cdecl, importc: "ZpX_disc_val",
                                      dynlib: libname.}
proc ZpX_gcd*(f1: GEN; f2: GEN; p: GEN; pm: GEN): GEN {.cdecl, importc: "ZpX_gcd",
    dynlib: libname.}
proc ZpX_reduced_resultant*(x: GEN; y: GEN; p: GEN; pm: GEN): GEN {.cdecl,
    importc: "ZpX_reduced_resultant", dynlib: libname.}
proc ZpX_reduced_resultant_fast*(f: GEN; g: GEN; p: GEN; M: clong): GEN {.cdecl,
    importc: "ZpX_reduced_resultant_fast", dynlib: libname.}
proc ZpX_resultant_val*(f: GEN; g: GEN; p: GEN; M: clong): clong {.cdecl,
    importc: "ZpX_resultant_val", dynlib: libname.}
proc checkmodpr*(modpr: GEN) {.cdecl, importc: "checkmodpr", dynlib: libname.}
proc ZX_compositum_disjoint*(A: GEN; B: GEN): GEN {.cdecl,
    importc: "ZX_compositum_disjoint", dynlib: libname.}
proc compositum*(P: GEN; Q: GEN): GEN {.cdecl, importc: "compositum", dynlib: libname.}
proc compositum2*(P: GEN; Q: GEN): GEN {.cdecl, importc: "compositum2", dynlib: libname.}
proc nfdisc*(x: GEN): GEN {.cdecl, importc: "nfdisc", dynlib: libname.}
proc indexpartial*(P: GEN; DP: GEN): GEN {.cdecl, importc: "indexpartial",
                                     dynlib: libname.}
proc modpr_genFq*(modpr: GEN): GEN {.cdecl, importc: "modpr_genFq", dynlib: libname.}
proc nf_to_Fq_init*(nf: GEN; pr: ptr GEN; T: ptr GEN; p: ptr GEN): GEN {.cdecl,
    importc: "nf_to_Fq_init", dynlib: libname.}
proc nf_to_Fq*(nf: GEN; x: GEN; modpr: GEN): GEN {.cdecl, importc: "nf_to_Fq",
    dynlib: libname.}
proc nfM_to_FqM*(z: GEN; nf: GEN; modpr: GEN): GEN {.cdecl, importc: "nfM_to_FqM",
    dynlib: libname.}
proc nfV_to_FqV*(z: GEN; nf: GEN; modpr: GEN): GEN {.cdecl, importc: "nfV_to_FqV",
    dynlib: libname.}
proc nfX_to_FqX*(x: GEN; nf: GEN; modpr: GEN): GEN {.cdecl, importc: "nfX_to_FqX",
    dynlib: libname.}
proc nfbasis*(x: GEN; y: ptr GEN; p: GEN): GEN {.cdecl, importc: "nfbasis", dynlib: libname.}
proc nfbasis0*(x: GEN; flag: clong; p: GEN): GEN {.cdecl, importc: "nfbasis0",
    dynlib: libname.}
proc nfdisc0*(x: GEN; flag: clong; p: GEN): GEN {.cdecl, importc: "nfdisc0",
    dynlib: libname.}
proc nfmaxord*(S: ptr nfmaxord_t; T: GEN; flag: clong) {.cdecl, importc: "nfmaxord",
    dynlib: libname.}
proc nfmodprinit*(nf: GEN; pr: GEN): GEN {.cdecl, importc: "nfmodprinit", dynlib: libname.}
proc nfreducemodpr*(nf: GEN; x: GEN; modpr: GEN): GEN {.cdecl, importc: "nfreducemodpr",
    dynlib: libname.}
proc polcompositum0*(P: GEN; Q: GEN; flag: clong): GEN {.cdecl,
    importc: "polcompositum0", dynlib: libname.}
proc idealprimedec*(nf: GEN; p: GEN): GEN {.cdecl, importc: "idealprimedec",
                                      dynlib: libname.}
proc rnfbasis*(bnf: GEN; order: GEN): GEN {.cdecl, importc: "rnfbasis", dynlib: libname.}
proc rnfdedekind*(nf: GEN; T: GEN; pr: GEN; flag: clong): GEN {.cdecl,
    importc: "rnfdedekind", dynlib: libname.}
proc rnfdet*(nf: GEN; order: GEN): GEN {.cdecl, importc: "rnfdet", dynlib: libname.}
proc rnfdiscf*(nf: GEN; pol: GEN): GEN {.cdecl, importc: "rnfdiscf", dynlib: libname.}
proc rnfequation*(nf: GEN; pol: GEN): GEN {.cdecl, importc: "rnfequation",
                                      dynlib: libname.}
proc rnfequation0*(nf: GEN; pol: GEN; flall: clong): GEN {.cdecl,
    importc: "rnfequation0", dynlib: libname.}
proc rnfequation2*(nf: GEN; pol: GEN): GEN {.cdecl, importc: "rnfequation2",
                                       dynlib: libname.}
proc nf_rnfeq*(nf: GEN; relpol: GEN): GEN {.cdecl, importc: "nf_rnfeq", dynlib: libname.}
proc nf_rnfeqsimple*(nf: GEN; relpol: GEN): GEN {.cdecl, importc: "nf_rnfeqsimple",
    dynlib: libname.}
proc rnfequationall*(A: GEN; B: GEN; pk: ptr clong; pLPRS: ptr GEN): GEN {.cdecl,
    importc: "rnfequationall", dynlib: libname.}
proc rnfhnfbasis*(bnf: GEN; order: GEN): GEN {.cdecl, importc: "rnfhnfbasis",
    dynlib: libname.}
proc rnfisfree*(bnf: GEN; order: GEN): clong {.cdecl, importc: "rnfisfree",
    dynlib: libname.}
proc rnflllgram*(nf: GEN; pol: GEN; order: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "rnflllgram", dynlib: libname.}
proc rnfpolred*(nf: GEN; pol: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "rnfpolred",
    dynlib: libname.}
proc rnfpseudobasis*(nf: GEN; pol: GEN): GEN {.cdecl, importc: "rnfpseudobasis",
    dynlib: libname.}
proc rnfsimplifybasis*(bnf: GEN; order: GEN): GEN {.cdecl, importc: "rnfsimplifybasis",
    dynlib: libname.}
proc rnfsteinitz*(nf: GEN; order: GEN): GEN {.cdecl, importc: "rnfsteinitz",
                                        dynlib: libname.}
proc factorial_lval*(n: pari_ulong; p: pari_ulong): clong {.cdecl,
    importc: "factorial_lval", dynlib: libname.}
proc zk_to_Fq_init*(nf: GEN; pr: ptr GEN; T: ptr GEN; p: ptr GEN): GEN {.cdecl,
    importc: "zk_to_Fq_init", dynlib: libname.}
proc zk_to_Fq*(x: GEN; modpr: GEN): GEN {.cdecl, importc: "zk_to_Fq", dynlib: libname.}
proc zkmodprinit*(nf: GEN; pr: GEN): GEN {.cdecl, importc: "zkmodprinit", dynlib: libname.}
proc Idealstar*(nf: GEN; x: GEN; flun: clong): GEN {.cdecl, importc: "Idealstar",
    dynlib: libname.}
proc RgC_to_nfC*(nf: GEN; x: GEN): GEN {.cdecl, importc: "RgC_to_nfC", dynlib: libname.}
proc RgM_to_nfM*(nf: GEN; x: GEN): GEN {.cdecl, importc: "RgM_to_nfM", dynlib: libname.}
proc RgX_to_nfX*(nf: GEN; pol: GEN): GEN {.cdecl, importc: "RgX_to_nfX", dynlib: libname.}
proc algtobasis*(nf: GEN; x: GEN): GEN {.cdecl, importc: "algtobasis", dynlib: libname.}
proc basistoalg*(nf: GEN; x: GEN): GEN {.cdecl, importc: "basistoalg", dynlib: libname.}
proc ideallist*(nf: GEN; bound: clong): GEN {.cdecl, importc: "ideallist",
                                        dynlib: libname.}
proc ideallist0*(nf: GEN; bound: clong; flag: clong): GEN {.cdecl, importc: "ideallist0",
    dynlib: libname.}
proc ideallistarch*(nf: GEN; list: GEN; arch: GEN): GEN {.cdecl,
    importc: "ideallistarch", dynlib: libname.}
proc idealprincipalunits*(nf: GEN; pr: GEN; e: clong): GEN {.cdecl,
    importc: "idealprincipalunits", dynlib: libname.}
proc idealstar0*(nf: GEN; x: GEN; flag: clong): GEN {.cdecl, importc: "idealstar0",
    dynlib: libname.}
proc indices_to_vec01*(archp: GEN; r: clong): GEN {.cdecl, importc: "indices_to_vec01",
    dynlib: libname.}
proc matalgtobasis*(nf: GEN; x: GEN): GEN {.cdecl, importc: "matalgtobasis",
                                      dynlib: libname.}
proc matbasistoalg*(nf: GEN; x: GEN): GEN {.cdecl, importc: "matbasistoalg",
                                      dynlib: libname.}
proc nf_to_scalar_or_alg*(nf: GEN; x: GEN): GEN {.cdecl,
    importc: "nf_to_scalar_or_alg", dynlib: libname.}
proc nf_to_scalar_or_basis*(nf: GEN; x: GEN): GEN {.cdecl,
    importc: "nf_to_scalar_or_basis", dynlib: libname.}
proc nfadd*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "nfadd", dynlib: libname.}
proc nfarchstar*(nf: GEN; x: GEN; arch: GEN): GEN {.cdecl, importc: "nfarchstar",
    dynlib: libname.}
proc nfdiv*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "nfdiv", dynlib: libname.}
proc nfdiveuc*(nf: GEN; a: GEN; b: GEN): GEN {.cdecl, importc: "nfdiveuc", dynlib: libname.}
proc nfdivrem*(nf: GEN; a: GEN; b: GEN): GEN {.cdecl, importc: "nfdivrem", dynlib: libname.}
proc nfinv*(nf: GEN; x: GEN): GEN {.cdecl, importc: "nfinv", dynlib: libname.}
proc nfinvmodideal*(nf: GEN; x: GEN; ideal: GEN): GEN {.cdecl, importc: "nfinvmodideal",
    dynlib: libname.}
proc nfmod*(nf: GEN; a: GEN; b: GEN): GEN {.cdecl, importc: "nfmod", dynlib: libname.}
proc nfmul*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "nfmul", dynlib: libname.}
proc nfmuli*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "nfmuli", dynlib: libname.}
proc nfnorm*(nf: GEN; x: GEN): GEN {.cdecl, importc: "nfnorm", dynlib: libname.}
proc nfpow*(nf: GEN; x: GEN; k: GEN): GEN {.cdecl, importc: "nfpow", dynlib: libname.}
proc nfpow_u*(nf: GEN; z: GEN; n: pari_ulong): GEN {.cdecl, importc: "nfpow_u",
    dynlib: libname.}
proc nfpowmodideal*(nf: GEN; x: GEN; k: GEN; ideal: GEN): GEN {.cdecl,
    importc: "nfpowmodideal", dynlib: libname.}
proc nfsign*(nf: GEN; alpha: GEN): GEN {.cdecl, importc: "nfsign", dynlib: libname.}
proc nfsign_arch*(nf: GEN; alpha: GEN; arch: GEN): GEN {.cdecl, importc: "nfsign_arch",
    dynlib: libname.}
proc nfsign_from_logarch*(Larch: GEN; invpi: GEN; archp: GEN): GEN {.cdecl,
    importc: "nfsign_from_logarch", dynlib: libname.}
proc nfsqr*(nf: GEN; x: GEN): GEN {.cdecl, importc: "nfsqr", dynlib: libname.}
proc nfsqri*(nf: GEN; x: GEN): GEN {.cdecl, importc: "nfsqri", dynlib: libname.}
proc nftrace*(nf: GEN; x: GEN): GEN {.cdecl, importc: "nftrace", dynlib: libname.}
proc nfval*(nf: GEN; x: GEN; vp: GEN): clong {.cdecl, importc: "nfval", dynlib: libname.}
proc polmod_nffix*(f: cstring; rnf: GEN; x: GEN; lift: cint): GEN {.cdecl,
    importc: "polmod_nffix", dynlib: libname.}
proc polmod_nffix2*(f: cstring; T: GEN; relpol: GEN; x: GEN; lift: cint): GEN {.cdecl,
    importc: "polmod_nffix2", dynlib: libname.}
proc pr_equal*(nf: GEN; P: GEN; Q: GEN): cint {.cdecl, importc: "pr_equal", dynlib: libname.}
proc rnfalgtobasis*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfalgtobasis",
                                       dynlib: libname.}
proc rnfbasistoalg*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfbasistoalg",
                                       dynlib: libname.}
proc rnfeltnorm*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfeltnorm", dynlib: libname.}
proc rnfelttrace*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfelttrace", dynlib: libname.}
proc set_sign_mod_divisor*(nf: GEN; x: GEN; y: GEN; idele: GEN; sarch: GEN): GEN {.cdecl,
    importc: "set_sign_mod_divisor", dynlib: libname.}
proc vec01_to_indices*(arch: GEN): GEN {.cdecl, importc: "vec01_to_indices",
                                     dynlib: libname.}
proc vecmodii*(a: GEN; b: GEN): GEN {.cdecl, importc: "vecmodii", dynlib: libname.}
proc ideallog*(nf: GEN; x: GEN; bigideal: GEN): GEN {.cdecl, importc: "ideallog",
    dynlib: libname.}
proc multable*(nf: GEN; x: GEN): GEN {.cdecl, importc: "multable", dynlib: libname.}
proc tablemul*(TAB: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "tablemul", dynlib: libname.}
proc tablemul_ei*(M: GEN; x: GEN; i: clong): GEN {.cdecl, importc: "tablemul_ei",
    dynlib: libname.}
proc tablemul_ei_ej*(M: GEN; i: clong; j: clong): GEN {.cdecl, importc: "tablemul_ei_ej",
    dynlib: libname.}
proc tablemulvec*(M: GEN; x: GEN; v: GEN): GEN {.cdecl, importc: "tablemulvec",
    dynlib: libname.}
proc tablesqr*(tab: GEN; x: GEN): GEN {.cdecl, importc: "tablesqr", dynlib: libname.}
proc ei_multable*(nf: GEN; i: clong): GEN {.cdecl, importc: "ei_multable",
                                      dynlib: libname.}
proc ZC_nfval*(nf: GEN; x: GEN; P: GEN): clong {.cdecl, importc: "ZC_nfval",
    dynlib: libname.}
proc ZC_nfvalrem*(nf: GEN; x: GEN; P: GEN; t: ptr GEN): clong {.cdecl,
    importc: "ZC_nfvalrem", dynlib: libname.}
proc zk_multable*(nf: GEN; x: GEN): GEN {.cdecl, importc: "zk_multable", dynlib: libname.}
proc zk_scalar_or_multable*(a2: GEN; x: GEN): GEN {.cdecl,
    importc: "zk_scalar_or_multable", dynlib: libname.}
proc ZC_prdvd*(nf: GEN; x: GEN; P: GEN): cint {.cdecl, importc: "ZC_prdvd", dynlib: libname.}
proc RM_round_maxrank*(G: GEN): GEN {.cdecl, importc: "RM_round_maxrank",
                                  dynlib: libname.}
proc ZM_famat_limit*(fa: GEN; limit: GEN): GEN {.cdecl, importc: "ZM_famat_limit",
    dynlib: libname.}
proc famat_inv*(f: GEN): GEN {.cdecl, importc: "famat_inv", dynlib: libname.}
proc famat_inv_shallow*(f: GEN): GEN {.cdecl, importc: "famat_inv_shallow",
                                   dynlib: libname.}
proc famat_makecoprime*(nf: GEN; g: GEN; e: GEN; pr: GEN; prk: GEN; EX: GEN): GEN {.cdecl,
    importc: "famat_makecoprime", dynlib: libname.}
proc famat_mul*(f: GEN; g: GEN): GEN {.cdecl, importc: "famat_mul", dynlib: libname.}
proc famat_pow*(f: GEN; n: GEN): GEN {.cdecl, importc: "famat_pow", dynlib: libname.}
proc famat_sqr*(f: GEN): GEN {.cdecl, importc: "famat_sqr", dynlib: libname.}
proc famat_reduce*(fa: GEN): GEN {.cdecl, importc: "famat_reduce", dynlib: libname.}
proc famat_to_nf*(nf: GEN; f: GEN): GEN {.cdecl, importc: "famat_to_nf", dynlib: libname.}
proc famat_to_nf_modideal_coprime*(nf: GEN; g: GEN; e: GEN; id: GEN; EX: GEN): GEN {.cdecl,
    importc: "famat_to_nf_modideal_coprime", dynlib: libname.}
proc famat_to_nf_moddivisor*(nf: GEN; g: GEN; e: GEN; bid: GEN): GEN {.cdecl,
    importc: "famat_to_nf_moddivisor", dynlib: libname.}
proc famatsmall_reduce*(fa: GEN): GEN {.cdecl, importc: "famatsmall_reduce",
                                    dynlib: libname.}
proc idealtwoelt*(nf: GEN; ix: GEN): GEN {.cdecl, importc: "idealtwoelt", dynlib: libname.}
proc idealtwoelt0*(nf: GEN; ix: GEN; a: GEN): GEN {.cdecl, importc: "idealtwoelt0",
    dynlib: libname.}
proc idealtwoelt2*(nf: GEN; x: GEN; a: GEN): GEN {.cdecl, importc: "idealtwoelt2",
    dynlib: libname.}
proc idealadd*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "idealadd", dynlib: libname.}
proc idealaddmultoone*(nf: GEN; list: GEN): GEN {.cdecl, importc: "idealaddmultoone",
    dynlib: libname.}
proc idealaddtoone*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "idealaddtoone",
    dynlib: libname.}
proc idealaddtoone_i*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "idealaddtoone_i",
    dynlib: libname.}
proc idealaddtoone0*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "idealaddtoone0",
    dynlib: libname.}
proc idealappr*(nf: GEN; x: GEN): GEN {.cdecl, importc: "idealappr", dynlib: libname.}
proc idealappr0*(nf: GEN; x: GEN; fl: clong): GEN {.cdecl, importc: "idealappr0",
    dynlib: libname.}
proc idealapprfact*(nf: GEN; x: GEN): GEN {.cdecl, importc: "idealapprfact",
                                      dynlib: libname.}
proc idealchinese*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "idealchinese",
    dynlib: libname.}
proc idealcoprime*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "idealcoprime",
    dynlib: libname.}
proc idealcoprimefact*(nf: GEN; x: GEN; fy: GEN): GEN {.cdecl,
    importc: "idealcoprimefact", dynlib: libname.}
proc idealdiv*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "idealdiv", dynlib: libname.}
proc idealdiv0*(nf: GEN; x: GEN; y: GEN; flag: clong): GEN {.cdecl, importc: "idealdiv0",
    dynlib: libname.}
proc idealdivexact*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "idealdivexact",
    dynlib: libname.}
proc idealdivpowprime*(nf: GEN; x: GEN; vp: GEN; n: GEN): GEN {.cdecl,
    importc: "idealdivpowprime", dynlib: libname.}
proc idealmulpowprime*(nf: GEN; x: GEN; vp: GEN; n: GEN): GEN {.cdecl,
    importc: "idealmulpowprime", dynlib: libname.}
proc idealfactor*(nf: GEN; x: GEN): GEN {.cdecl, importc: "idealfactor", dynlib: libname.}
proc idealhnf*(nf: GEN; x: GEN): GEN {.cdecl, importc: "idealhnf", dynlib: libname.}
proc idealhnf_principal*(nf: GEN; x: GEN): GEN {.cdecl, importc: "idealhnf_principal",
    dynlib: libname.}
proc idealhnf_shallow*(nf: GEN; x: GEN): GEN {.cdecl, importc: "idealhnf_shallow",
    dynlib: libname.}
proc idealhnf_two*(nf: GEN; vp: GEN): GEN {.cdecl, importc: "idealhnf_two",
                                      dynlib: libname.}
proc idealhnf0*(nf: GEN; a: GEN; b: GEN): GEN {.cdecl, importc: "idealhnf0",
                                        dynlib: libname.}
proc idealintersect*(nf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "idealintersect",
    dynlib: libname.}
proc idealinv*(nf: GEN; ix: GEN): GEN {.cdecl, importc: "idealinv", dynlib: libname.}
proc idealred0*(nf: GEN; I: GEN; vdir: GEN): GEN {.cdecl, importc: "idealred0",
    dynlib: libname.}
proc idealmul*(nf: GEN; ix: GEN; iy: GEN): GEN {.cdecl, importc: "idealmul",
    dynlib: libname.}
proc idealmul0*(nf: GEN; ix: GEN; iy: GEN; flag: clong): GEN {.cdecl, importc: "idealmul0",
    dynlib: libname.}
proc idealmul_HNF*(nf: GEN; ix: GEN; iy: GEN): GEN {.cdecl, importc: "idealmul_HNF",
    dynlib: libname.}
proc idealmulred*(nf: GEN; ix: GEN; iy: GEN): GEN {.cdecl, importc: "idealmulred",
    dynlib: libname.}
proc idealnorm*(nf: GEN; x: GEN): GEN {.cdecl, importc: "idealnorm", dynlib: libname.}
proc idealnumden*(nf: GEN; x: GEN): GEN {.cdecl, importc: "idealnumden", dynlib: libname.}
proc idealpow*(nf: GEN; ix: GEN; n: GEN): GEN {.cdecl, importc: "idealpow", dynlib: libname.}
proc idealpow0*(nf: GEN; ix: GEN; n: GEN; flag: clong): GEN {.cdecl, importc: "idealpow0",
    dynlib: libname.}
proc idealpowred*(nf: GEN; ix: GEN; n: GEN): GEN {.cdecl, importc: "idealpowred",
    dynlib: libname.}
proc idealpows*(nf: GEN; ideal: GEN; iexp: clong): GEN {.cdecl, importc: "idealpows",
    dynlib: libname.}
proc idealprodprime*(nf: GEN; L: GEN): GEN {.cdecl, importc: "idealprodprime",
                                       dynlib: libname.}
proc idealsqr*(nf: GEN; x: GEN): GEN {.cdecl, importc: "idealsqr", dynlib: libname.}
proc idealtyp*(ideal: ptr GEN; arch: ptr GEN): clong {.cdecl, importc: "idealtyp",
    dynlib: libname.}
proc idealval*(nf: GEN; ix: GEN; vp: GEN): clong {.cdecl, importc: "idealval",
    dynlib: libname.}
proc isideal*(nf: GEN; x: GEN): clong {.cdecl, importc: "isideal", dynlib: libname.}
proc idealmin*(nf: GEN; ix: GEN; vdir: GEN): GEN {.cdecl, importc: "idealmin",
    dynlib: libname.}
proc nf_get_Gtwist*(nf: GEN; vdir: GEN): GEN {.cdecl, importc: "nf_get_Gtwist",
    dynlib: libname.}
proc nf_get_Gtwist1*(nf: GEN; i: clong): GEN {.cdecl, importc: "nf_get_Gtwist1",
    dynlib: libname.}
proc nfC_nf_mul*(nf: GEN; v: GEN; x: GEN): GEN {.cdecl, importc: "nfC_nf_mul",
    dynlib: libname.}
proc nfdetint*(nf: GEN; pseudo: GEN): GEN {.cdecl, importc: "nfdetint", dynlib: libname.}
proc nfdivmodpr*(nf: GEN; x: GEN; y: GEN; modpr: GEN): GEN {.cdecl, importc: "nfdivmodpr",
    dynlib: libname.}
proc nfhnf*(nf: GEN; x: GEN): GEN {.cdecl, importc: "nfhnf", dynlib: libname.}
proc nfhnfmod*(nf: GEN; x: GEN; d: GEN): GEN {.cdecl, importc: "nfhnfmod", dynlib: libname.}
proc nfkermodpr*(nf: GEN; x: GEN; modpr: GEN): GEN {.cdecl, importc: "nfkermodpr",
    dynlib: libname.}
proc nfmulmodpr*(nf: GEN; x: GEN; y: GEN; modpr: GEN): GEN {.cdecl, importc: "nfmulmodpr",
    dynlib: libname.}
proc nfpowmodpr*(nf: GEN; x: GEN; k: GEN; modpr: GEN): GEN {.cdecl, importc: "nfpowmodpr",
    dynlib: libname.}
proc nfreduce*(nf: GEN; x: GEN; ideal: GEN): GEN {.cdecl, importc: "nfreduce",
    dynlib: libname.}
proc nfsnf*(nf: GEN; x: GEN): GEN {.cdecl, importc: "nfsnf", dynlib: libname.}
proc nfsolvemodpr*(nf: GEN; a: GEN; b: GEN; modpr: GEN): GEN {.cdecl,
    importc: "nfsolvemodpr", dynlib: libname.}
proc to_famat*(x: GEN; y: GEN): GEN {.cdecl, importc: "to_famat", dynlib: libname.}
proc to_famat_shallow*(x: GEN; y: GEN): GEN {.cdecl, importc: "to_famat_shallow",
                                        dynlib: libname.}
proc vecdiv*(x: GEN; y: GEN): GEN {.cdecl, importc: "vecdiv", dynlib: libname.}
proc vecinv*(x: GEN): GEN {.cdecl, importc: "vecinv", dynlib: libname.}
proc vecmul*(x: GEN; y: GEN): GEN {.cdecl, importc: "vecmul", dynlib: libname.}
proc vecpow*(x: GEN; n: GEN): GEN {.cdecl, importc: "vecpow", dynlib: libname.}
proc eltreltoabs*(rnfeq: GEN; x: GEN): GEN {.cdecl, importc: "eltreltoabs",
                                       dynlib: libname.}
proc eltabstorel*(eq: GEN; P: GEN): GEN {.cdecl, importc: "eltabstorel", dynlib: libname.}
proc eltabstorel_lift*(rnfeq: GEN; P: GEN): GEN {.cdecl, importc: "eltabstorel_lift",
    dynlib: libname.}
proc nf_nfzk*(nf: GEN; rnfeq: GEN; zknf: ptr GEN; czknf: ptr GEN) {.cdecl,
    importc: "nf_nfzk", dynlib: libname.}
proc nfeltup*(nf: GEN; x: GEN; zknf: GEN; czknf: GEN): GEN {.cdecl, importc: "nfeltup",
    dynlib: libname.}
proc rnfeltabstorel*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfeltabstorel",
                                        dynlib: libname.}
proc rnfeltdown*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfeltdown", dynlib: libname.}
proc rnfeltreltoabs*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfeltreltoabs",
                                        dynlib: libname.}
proc rnfeltup*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfeltup", dynlib: libname.}
proc rnfidealabstorel*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfidealabstorel",
    dynlib: libname.}
proc rnfidealdown*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfidealdown",
                                      dynlib: libname.}
proc rnfidealhnf*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfidealhnf", dynlib: libname.}
proc rnfidealmul*(rnf: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "rnfidealmul",
    dynlib: libname.}
proc rnfidealnormabs*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfidealnormabs",
    dynlib: libname.}
proc rnfidealnormrel*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfidealnormrel",
    dynlib: libname.}
proc rnfidealreltoabs*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfidealreltoabs",
    dynlib: libname.}
proc rnfidealtwoelement*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfidealtwoelement",
    dynlib: libname.}
proc rnfidealup*(rnf: GEN; x: GEN): GEN {.cdecl, importc: "rnfidealup", dynlib: libname.}
proc rnfinit*(nf: GEN; pol: GEN): GEN {.cdecl, importc: "rnfinit", dynlib: libname.}
proc dlog_get_ordfa*(o: GEN): GEN {.cdecl, importc: "dlog_get_ordfa", dynlib: libname.}
proc dlog_get_ord*(o: GEN): GEN {.cdecl, importc: "dlog_get_ord", dynlib: libname.}
proc gen_PH_log*(a: GEN; g: GEN; ord: GEN; E: pointer; grp: ptr bb_group): GEN {.cdecl,
    importc: "gen_PH_log", dynlib: libname.}
proc gen_Shanks_sqrtn*(a: GEN; n: GEN; q: GEN; zetan: ptr GEN; E: pointer; grp: ptr bb_group): GEN {.
    cdecl, importc: "gen_Shanks_sqrtn", dynlib: libname.}
proc gen_gener*(o: GEN; E: pointer; grp: ptr bb_group): GEN {.cdecl, importc: "gen_gener",
    dynlib: libname.}
proc gen_ellgens*(d1: GEN; d2: GEN; m: GEN; E: pointer; grp: ptr bb_group; pairorder: proc (
    E: pointer; P: GEN; Q: GEN; m: GEN; F: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_ellgens", dynlib: libname.}
proc gen_ellgroup*(N: GEN; F: GEN; pt_m: ptr GEN; E: pointer; grp: ptr bb_group; pairorder: proc (
    E: pointer; P: GEN; Q: GEN; m: GEN; F: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_ellgroup", dynlib: libname.}
proc gen_factored_order*(a: GEN; o: GEN; E: pointer; grp: ptr bb_group): GEN {.cdecl,
    importc: "gen_factored_order", dynlib: libname.}
proc gen_order*(x: GEN; o: GEN; E: pointer; grp: ptr bb_group): GEN {.cdecl,
    importc: "gen_order", dynlib: libname.}
proc gen_select_order*(o: GEN; E: pointer; grp: ptr bb_group): GEN {.cdecl,
    importc: "gen_select_order", dynlib: libname.}
proc gen_plog*(x: GEN; g0: GEN; q: GEN; E: pointer; grp: ptr bb_group): GEN {.cdecl,
    importc: "gen_plog", dynlib: libname.}
proc gen_pow*(x: GEN; n: GEN; E: pointer;
             sqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.};
             mul: proc (a2: pointer; a3: GEN; a4: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_pow", dynlib: libname.}
proc gen_pow_i*(x: GEN; n: GEN; E: pointer;
               sqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.};
               mul: proc (a2: pointer; a3: GEN; a4: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_pow_i", dynlib: libname.}
proc gen_pow_fold*(x: GEN; n: GEN; E: pointer;
                  sqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.};
                  msqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_pow_fold", dynlib: libname.}
proc gen_pow_fold_i*(x: GEN; n: GEN; E: pointer;
                    sqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.};
                    msqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_pow_fold_i", dynlib: libname.}
proc gen_powers*(x: GEN; par_l: clong; use_sqr: cint; E: pointer;
                sqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.};
                mul: proc (a2: pointer; a3: GEN; a4: GEN): GEN {.cdecl.};
                one: proc (a2: pointer): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_powers", dynlib: libname.}
proc gen_powu*(x: GEN; n: pari_ulong; E: pointer;
              sqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.};
              mul: proc (a2: pointer; a3: GEN; a4: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_powu", dynlib: libname.}
proc gen_powu_i*(x: GEN; n: pari_ulong; E: pointer;
                sqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.};
                mul: proc (a2: pointer; a3: GEN; a4: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_powu_i", dynlib: libname.}
proc gen_powu_fold*(x: GEN; n: pari_ulong; E: pointer;
                   sqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.};
                   msqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_powu_fold", dynlib: libname.}
proc gen_powu_fold_i*(x: GEN; n: pari_ulong; E: pointer;
                     sqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.};
                     msqr: proc (a2: pointer; a3: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "gen_powu_fold_i", dynlib: libname.}
proc QR_init*(x: GEN; pB: ptr GEN; pQ: ptr GEN; pL: ptr GEN; prec: clong=pari_default_prec): cint {.cdecl,
    importc: "QR_init", dynlib: libname.}
proc R_from_QR*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "R_from_QR", dynlib: libname.}
proc RgM_QR_init*(x: GEN; pB: ptr GEN; pQ: ptr GEN; pL: ptr GEN; prec: clong=pari_default_prec): cint {.cdecl,
    importc: "RgM_QR_init", dynlib: libname.}
proc Xadic_lindep*(x: GEN): GEN {.cdecl, importc: "Xadic_lindep", dynlib: libname.}
proc algdep*(x: GEN; n: clong): GEN {.cdecl, importc: "algdep", dynlib: libname.}
proc algdep0*(x: GEN; n: clong; bit: clong): GEN {.cdecl, importc: "algdep0",
    dynlib: libname.}
proc forqfvec0*(a: GEN; BORNE: GEN; code: GEN) {.cdecl, importc: "forqfvec0",
    dynlib: libname.}
proc gaussred_from_QR*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gaussred_from_QR",
    dynlib: libname.}
proc lindep0*(x: GEN; flag: clong): GEN {.cdecl, importc: "lindep0", dynlib: libname.}
proc lindep*(x: GEN): GEN {.cdecl, importc: "lindep", dynlib: libname.}
proc lindep2*(x: GEN; bit: clong): GEN {.cdecl, importc: "lindep2", dynlib: libname.}
proc mathouseholder*(Q: GEN; v: GEN): GEN {.cdecl, importc: "mathouseholder",
                                      dynlib: libname.}
proc matqr*(x: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "matqr",
    dynlib: libname.}
proc minim*(a: GEN; borne: GEN; stockmax: GEN): GEN {.cdecl, importc: "minim",
    dynlib: libname.}
proc minim_raw*(a: GEN; borne: GEN; stockmax: GEN): GEN {.cdecl, importc: "minim_raw",
    dynlib: libname.}
proc minim2*(a: GEN; borne: GEN; stockmax: GEN): GEN {.cdecl, importc: "minim2",
    dynlib: libname.}
proc padic_lindep*(x: GEN): GEN {.cdecl, importc: "padic_lindep", dynlib: libname.}
proc perf*(a: GEN): GEN {.cdecl, importc: "perf", dynlib: libname.}
proc qfrep0*(a: GEN; borne: GEN; flag: clong): GEN {.cdecl, importc: "qfrep0",
    dynlib: libname.}
proc qfminim0*(a: GEN; borne: GEN; stockmax: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "qfminim0", dynlib: libname.}
proc seralgdep*(s: GEN; p: clong; r: clong): GEN {.cdecl, importc: "seralgdep",
    dynlib: libname.}
proc zncoppersmith*(P0: GEN; N: GEN; X: GEN; B: GEN): GEN {.cdecl,
    importc: "zncoppersmith", dynlib: libname.}
proc QXQ_reverse*(a: GEN; T: GEN): GEN {.cdecl, importc: "QXQ_reverse", dynlib: libname.}
proc RgV_polint*(X: GEN; Y: GEN; v: clong): GEN {.cdecl, importc: "RgV_polint",
    dynlib: libname.}
proc RgXQ_reverse*(a: GEN; T: GEN): GEN {.cdecl, importc: "RgXQ_reverse", dynlib: libname.}
proc ZV_indexsort*(L: GEN): GEN {.cdecl, importc: "ZV_indexsort", dynlib: libname.}
proc ZV_search*(x: GEN; y: GEN): clong {.cdecl, importc: "ZV_search", dynlib: libname.}
proc ZV_sort*(L: GEN): GEN {.cdecl, importc: "ZV_sort", dynlib: libname.}
proc ZV_sort_uniq*(L: GEN): GEN {.cdecl, importc: "ZV_sort_uniq", dynlib: libname.}
proc ZV_union_shallow*(x: GEN; y: GEN): GEN {.cdecl, importc: "ZV_union_shallow",
                                        dynlib: libname.}
proc binomial*(x: GEN; k: clong): GEN {.cdecl, importc: "binomial", dynlib: libname.}
proc binomialuu*(n: pari_ulong; k: pari_ulong): GEN {.cdecl, importc: "binomialuu",
    dynlib: libname.}
proc cmp_nodata*(data: pointer; x: GEN; y: GEN): cint {.cdecl, importc: "cmp_nodata",
    dynlib: libname.}
proc cmp_prime_ideal*(x: GEN; y: GEN): cint {.cdecl, importc: "cmp_prime_ideal",
                                        dynlib: libname.}
proc cmp_prime_over_p*(x: GEN; y: GEN): cint {.cdecl, importc: "cmp_prime_over_p",
    dynlib: libname.}
proc cmp_RgX*(x: GEN; y: GEN): cint {.cdecl, importc: "cmp_RgX", dynlib: libname.}
proc cmp_universal*(x: GEN; y: GEN): cint {.cdecl, importc: "cmp_universal",
                                      dynlib: libname.}
proc convol*(x: GEN; y: GEN): GEN {.cdecl, importc: "convol", dynlib: libname.}
proc gen_cmp_RgX*(data: pointer; x: GEN; y: GEN): cint {.cdecl, importc: "gen_cmp_RgX",
    dynlib: libname.}
proc polcyclo*(n: clong; v: clong): GEN {.cdecl, importc: "polcyclo", dynlib: libname.}
proc polcyclo_eval*(n: clong; x: GEN): GEN {.cdecl, importc: "polcyclo_eval",
                                       dynlib: libname.}
proc dirdiv*(x: GEN; y: GEN): GEN {.cdecl, importc: "dirdiv", dynlib: libname.}
proc dirmul*(x: GEN; y: GEN): GEN {.cdecl, importc: "dirmul", dynlib: libname.}
proc gen_indexsort*(x: GEN; E: pointer;
                   cmp: proc (a2: pointer; a3: GEN; a4: GEN): cint {.cdecl.}): GEN {.cdecl,
    importc: "gen_indexsort", dynlib: libname.}
proc gen_indexsort_uniq*(x: GEN; E: pointer; cmp: proc (a2: pointer; a3: GEN; a4: GEN): cint {.
    cdecl.}): GEN {.cdecl, importc: "gen_indexsort_uniq", dynlib: libname.}
proc gen_search*(x: GEN; y: GEN; flag: clong; data: pointer;
                cmp: proc (a2: pointer; a3: GEN; a4: GEN): cint {.cdecl.}): clong {.cdecl,
    importc: "gen_search", dynlib: libname.}
proc gen_setminus*(set1: GEN; set2: GEN; cmp: proc (a2: GEN; a3: GEN): cint {.cdecl.}): GEN {.
    cdecl, importc: "gen_setminus", dynlib: libname.}
proc gen_sort*(x: GEN; E: pointer;
              cmp: proc (a2: pointer; a3: GEN; a4: GEN): cint {.cdecl.}): GEN {.cdecl,
    importc: "gen_sort", dynlib: libname.}
proc gen_sort_inplace*(x: GEN; E: pointer;
                      cmp: proc (a2: pointer; a3: GEN; a4: GEN): cint {.cdecl.};
                      perm: ptr GEN) {.cdecl, importc: "gen_sort_inplace",
                                    dynlib: libname.}
proc gen_sort_uniq*(x: GEN; E: pointer;
                   cmp: proc (a2: pointer; a3: GEN; a4: GEN): cint {.cdecl.}): GEN {.cdecl,
    importc: "gen_sort_uniq", dynlib: libname.}
proc getstack*(): clong {.cdecl, importc: "getstack", dynlib: libname.}
proc gettime*(): clong {.cdecl, importc: "gettime", dynlib: libname.}
proc getabstime*(): clong {.cdecl, importc: "getabstime", dynlib: libname.}
proc gprec*(x: GEN; par_l: clong): GEN {.cdecl, importc: "gprec", dynlib: libname.}
proc gprec_wtrunc*(x: GEN; pr: clong): GEN {.cdecl, importc: "gprec_wtrunc",
                                       dynlib: libname.}
proc gprec_w*(x: GEN; pr: clong): GEN {.cdecl, importc: "gprec_w", dynlib: libname.}
proc gtoset*(x: GEN): GEN {.cdecl, importc: "gtoset", dynlib: libname.}
proc indexlexsort*(x: GEN): GEN {.cdecl, importc: "indexlexsort", dynlib: libname.}
proc indexsort*(x: GEN): GEN {.cdecl, importc: "indexsort", dynlib: libname.}
proc indexvecsort*(x: GEN; k: GEN): GEN {.cdecl, importc: "indexvecsort", dynlib: libname.}
proc laplace*(x: GEN): GEN {.cdecl, importc: "laplace", dynlib: libname.}
proc lexsort*(x: GEN): GEN {.cdecl, importc: "lexsort", dynlib: libname.}
proc mathilbert*(n: clong): GEN {.cdecl, importc: "mathilbert", dynlib: libname.}
proc matqpascal*(n: clong; q: GEN): GEN {.cdecl, importc: "matqpascal", dynlib: libname.}
proc merge_factor*(fx: GEN; fy: GEN; data: pointer;
                  cmp: proc (a2: pointer; a3: GEN; a4: GEN): cint {.cdecl.}): GEN {.cdecl,
    importc: "merge_factor", dynlib: libname.}
proc merge_sort_uniq*(x: GEN; y: GEN; data: pointer;
                     cmp: proc (a2: pointer; a3: GEN; a4: GEN): cint {.cdecl.}): GEN {.
    cdecl, importc: "merge_sort_uniq", dynlib: libname.}
proc modreverse*(x: GEN): GEN {.cdecl, importc: "modreverse", dynlib: libname.}
proc numtoperm*(n: clong; x: GEN): GEN {.cdecl, importc: "numtoperm", dynlib: libname.}
proc permtonum*(x: GEN): GEN {.cdecl, importc: "permtonum", dynlib: libname.}
proc polhermite*(n: clong; v: clong): GEN {.cdecl, importc: "polhermite", dynlib: libname.}
proc polhermite_eval*(n: clong; x: GEN): GEN {.cdecl, importc: "polhermite_eval",
    dynlib: libname.}
proc pollegendre*(n: clong; v: clong): GEN {.cdecl, importc: "pollegendre",
                                       dynlib: libname.}
proc pollegendre_eval*(n: clong; x: GEN): GEN {.cdecl, importc: "pollegendre_eval",
    dynlib: libname.}
proc polint*(xa: GEN; ya: GEN; x: GEN; dy: ptr GEN): GEN {.cdecl, importc: "polint",
    dynlib: libname.}
proc polchebyshev*(n: clong; kind: clong; v: clong): GEN {.cdecl,
    importc: "polchebyshev", dynlib: libname.}
proc polchebyshev_eval*(n: clong; kind: clong; x: GEN): GEN {.cdecl,
    importc: "polchebyshev_eval", dynlib: libname.}
proc polchebyshev1*(n: clong; v: clong): GEN {.cdecl, importc: "polchebyshev1",
    dynlib: libname.}
proc polchebyshev2*(n: clong; v: clong): GEN {.cdecl, importc: "polchebyshev2",
    dynlib: libname.}
proc polrecip*(x: GEN): GEN {.cdecl, importc: "polrecip", dynlib: libname.}
proc setbinop*(f: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "setbinop", dynlib: libname.}
proc setintersect*(x: GEN; y: GEN): GEN {.cdecl, importc: "setintersect", dynlib: libname.}
proc setisset*(x: GEN): clong {.cdecl, importc: "setisset", dynlib: libname.}
proc setminus*(x: GEN; y: GEN): GEN {.cdecl, importc: "setminus", dynlib: libname.}
proc setsearch*(x: GEN; y: GEN; flag: clong): clong {.cdecl, importc: "setsearch",
    dynlib: libname.}
proc setunion*(x: GEN; y: GEN): GEN {.cdecl, importc: "setunion", dynlib: libname.}
proc sort*(x: GEN): GEN {.cdecl, importc: "sort", dynlib: libname.}
proc sort_factor*(y: GEN; data: pointer;
                 cmp: proc (a2: pointer; a3: GEN; a4: GEN): cint {.cdecl.}): GEN {.cdecl,
    importc: "sort_factor", dynlib: libname.}
proc stirling*(n: clong; m: clong; flag: clong): GEN {.cdecl, importc: "stirling",
    dynlib: libname.}
proc stirling1*(n: pari_ulong; m: pari_ulong): GEN {.cdecl, importc: "stirling1",
    dynlib: libname.}
proc stirling2*(n: pari_ulong; m: pari_ulong): GEN {.cdecl, importc: "stirling2",
    dynlib: libname.}
proc tablesearch*(T: GEN; x: GEN; cmp: proc (a2: GEN; a3: GEN): cint {.cdecl.}): clong {.
    cdecl, importc: "tablesearch", dynlib: libname.}
proc vecbinome*(n: clong): GEN {.cdecl, importc: "vecbinome", dynlib: libname.}
proc vecsearch*(v: GEN; x: GEN; k: GEN): clong {.cdecl, importc: "vecsearch",
    dynlib: libname.}
proc vecsort*(x: GEN; k: GEN): GEN {.cdecl, importc: "vecsort", dynlib: libname.}
proc vecsort0*(x: GEN; k: GEN; flag: clong): GEN {.cdecl, importc: "vecsort0",
    dynlib: libname.}
proc zv_search*(x: GEN; y: clong): clong {.cdecl, importc: "zv_search", dynlib: libname.}
proc binaire*(x: GEN): GEN {.cdecl, importc: "binaire", dynlib: libname.}
proc bittest*(x: GEN; n: clong): clong {.cdecl, importc: "bittest", dynlib: libname.}
proc gbitand*(x: GEN; y: GEN): GEN {.cdecl, importc: "gbitand", dynlib: libname.}
proc gbitneg*(x: GEN; n: clong): GEN {.cdecl, importc: "gbitneg", dynlib: libname.}
proc gbitnegimply*(x: GEN; y: GEN): GEN {.cdecl, importc: "gbitnegimply", dynlib: libname.}
proc gbitor*(x: GEN; y: GEN): GEN {.cdecl, importc: "gbitor", dynlib: libname.}
proc gbittest*(x: GEN; n: clong): GEN {.cdecl, importc: "gbittest", dynlib: libname.}
proc gbitxor*(x: GEN; y: GEN): GEN {.cdecl, importc: "gbitxor", dynlib: libname.}
proc hammingweight*(n: GEN): clong {.cdecl, importc: "hammingweight", dynlib: libname.}
proc ibitand*(x: GEN; y: GEN): GEN {.cdecl, importc: "ibitand", dynlib: libname.}
proc ibitnegimply*(x: GEN; y: GEN): GEN {.cdecl, importc: "ibitnegimply", dynlib: libname.}
proc ibitor*(x: GEN; y: GEN): GEN {.cdecl, importc: "ibitor", dynlib: libname.}
proc ibitxor*(x: GEN; y: GEN): GEN {.cdecl, importc: "ibitxor", dynlib: libname.}
proc Buchquad*(D: GEN; c1: cdouble; c2: cdouble; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "Buchquad", dynlib: libname.}
proc quadclassunit0*(x: GEN; flag: clong; data: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "quadclassunit0", dynlib: libname.}
proc quadhilbert*(D: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "quadhilbert",
                                        dynlib: libname.}
proc quadray*(bnf: GEN; f: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "quadray",
    dynlib: libname.}
proc bnfcompress*(bnf: GEN): GEN {.cdecl, importc: "bnfcompress", dynlib: libname.}
proc bnfinit0*(P: GEN; flag: clong; data: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "bnfinit0", dynlib: libname.}
proc bnfnewprec*(nf: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "bnfnewprec",
                                        dynlib: libname.}
proc bnfnewprec_shallow*(nf: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "bnfnewprec_shallow", dynlib: libname.}
proc bnrnewprec*(bnr: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "bnrnewprec",
    dynlib: libname.}
proc bnrnewprec_shallow*(bnr: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "bnrnewprec_shallow", dynlib: libname.}
proc Buchall*(P: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "Buchall",
    dynlib: libname.}
proc Buchall_param*(P: GEN; bach: cdouble; bach2: cdouble; nbrelpid: clong; flun: clong;
                   prec: clong=pari_default_prec): GEN {.cdecl, importc: "Buchall_param",
                                    dynlib: libname.}
proc isprincipal*(bnf: GEN; x: GEN): GEN {.cdecl, importc: "isprincipal", dynlib: libname.}
proc bnfisprincipal0*(bnf: GEN; x: GEN; flall: clong): GEN {.cdecl,
    importc: "bnfisprincipal0", dynlib: libname.}
proc isprincipalfact*(bnf: GEN; C: GEN; L: GEN; f: GEN; flag: clong): GEN {.cdecl,
    importc: "isprincipalfact", dynlib: libname.}
proc isprincipalfact_or_fail*(bnf: GEN; C: GEN; P: GEN; e: GEN): GEN {.cdecl,
    importc: "isprincipalfact_or_fail", dynlib: libname.}
proc bnfisunit*(bignf: GEN; x: GEN): GEN {.cdecl, importc: "bnfisunit", dynlib: libname.}
proc signunits*(bignf: GEN): GEN {.cdecl, importc: "signunits", dynlib: libname.}
proc nfsign_units*(bnf: GEN; archp: GEN; add_zu: cint): GEN {.cdecl,
    importc: "nfsign_units", dynlib: libname.}
proc ABC_to_bnr*(A: GEN; B: GEN; C: GEN; H: ptr GEN; gen: cint): GEN {.cdecl,
    importc: "ABC_to_bnr", dynlib: libname.}
proc Buchray*(bnf: GEN; module: GEN; flag: clong): GEN {.cdecl, importc: "Buchray",
    dynlib: libname.}
proc bnrclassno*(bignf: GEN; ideal: GEN): GEN {.cdecl, importc: "bnrclassno",
    dynlib: libname.}
proc bnrclassno0*(A: GEN; B: GEN; C: GEN): GEN {.cdecl, importc: "bnrclassno0",
    dynlib: libname.}
proc bnrclassnolist*(bnf: GEN; listes: GEN): GEN {.cdecl, importc: "bnrclassnolist",
    dynlib: libname.}
proc bnrconductor0*(A: GEN; B: GEN; C: GEN; flag: clong): GEN {.cdecl,
    importc: "bnrconductor0", dynlib: libname.}
proc bnrconductor*(bnr: GEN; H0: GEN; flag: clong): GEN {.cdecl, importc: "bnrconductor",
    dynlib: libname.}
proc bnrconductorofchar*(bnr: GEN; chi: GEN): GEN {.cdecl,
    importc: "bnrconductorofchar", dynlib: libname.}
proc bnrdisc0*(A: GEN; B: GEN; C: GEN; flag: clong): GEN {.cdecl, importc: "bnrdisc0",
    dynlib: libname.}
proc bnrdisc*(bnr: GEN; H: GEN; flag: clong): GEN {.cdecl, importc: "bnrdisc",
    dynlib: libname.}
proc bnrdisclist0*(bnf: GEN; borne: GEN; arch: GEN): GEN {.cdecl,
    importc: "bnrdisclist0", dynlib: libname.}
proc bnrinit0*(bignf: GEN; ideal: GEN; flag: clong): GEN {.cdecl, importc: "bnrinit0",
    dynlib: libname.}
proc bnrisconductor0*(A: GEN; B: GEN; C: GEN): clong {.cdecl, importc: "bnrisconductor0",
    dynlib: libname.}
proc bnrisconductor*(bnr: GEN; H: GEN): clong {.cdecl, importc: "bnrisconductor",
    dynlib: libname.}
proc bnrisprincipal*(bnf: GEN; x: GEN; flag: clong): GEN {.cdecl,
    importc: "bnrisprincipal", dynlib: libname.}
proc bnrsurjection*(bnr1: GEN; bnr2: GEN): GEN {.cdecl, importc: "bnrsurjection",
    dynlib: libname.}
proc buchnarrow*(bignf: GEN): GEN {.cdecl, importc: "buchnarrow", dynlib: libname.}
proc bnfcertify*(bnf: GEN): clong {.cdecl, importc: "bnfcertify", dynlib: libname.}
proc bnfcertify0*(bnf: GEN; flag: clong): clong {.cdecl, importc: "bnfcertify0",
    dynlib: libname.}
proc decodemodule*(nf: GEN; fa: GEN): GEN {.cdecl, importc: "decodemodule",
                                      dynlib: libname.}
proc discrayabslist*(bnf: GEN; listes: GEN): GEN {.cdecl, importc: "discrayabslist",
    dynlib: libname.}
proc discrayabslistarch*(bnf: GEN; arch: GEN; bound: pari_ulong): GEN {.cdecl,
    importc: "discrayabslistarch", dynlib: libname.}
proc discrayabslistlong*(bnf: GEN; bound: pari_ulong): GEN {.cdecl,
    importc: "discrayabslistlong", dynlib: libname.}
proc idealmoddivisor*(bnr: GEN; x: GEN): GEN {.cdecl, importc: "idealmoddivisor",
    dynlib: libname.}
proc isprincipalray*(bnf: GEN; x: GEN): GEN {.cdecl, importc: "isprincipalray",
                                        dynlib: libname.}
proc isprincipalraygen*(bnf: GEN; x: GEN): GEN {.cdecl, importc: "isprincipalraygen",
    dynlib: libname.}
proc rnfconductor*(bnf: GEN; polrel: GEN): GEN {.cdecl, importc: "rnfconductor",
    dynlib: libname.}
proc rnfisabelian*(nf: GEN; pol: GEN): clong {.cdecl, importc: "rnfisabelian",
    dynlib: libname.}
proc rnfnormgroup*(bnr: GEN; polrel: GEN): GEN {.cdecl, importc: "rnfnormgroup",
    dynlib: libname.}
proc subgrouplist0*(bnr: GEN; indexbound: GEN; all: clong): GEN {.cdecl,
    importc: "subgrouplist0", dynlib: libname.}
proc bnfisnorm*(bnf: GEN; x: GEN; flag: clong): GEN {.cdecl, importc: "bnfisnorm",
    dynlib: libname.}
proc rnfisnorm*(S: GEN; x: GEN; flag: clong): GEN {.cdecl, importc: "rnfisnorm",
    dynlib: libname.}
proc rnfisnorminit*(bnf: GEN; relpol: GEN; polgalois: cint): GEN {.cdecl,
    importc: "rnfisnorminit", dynlib: libname.}
proc bnfissunit*(bnf: GEN; suni: GEN; x: GEN): GEN {.cdecl, importc: "bnfissunit",
    dynlib: libname.}
proc bnfsunit*(bnf: GEN; s: GEN; PREC: clong): GEN {.cdecl, importc: "bnfsunit",
    dynlib: libname.}
proc nfhilbert*(bnf: GEN; a: GEN; b: GEN): clong {.cdecl, importc: "nfhilbert",
    dynlib: libname.}
proc nfhilbert0*(bnf: GEN; a: GEN; b: GEN; p: GEN): clong {.cdecl, importc: "nfhilbert0",
    dynlib: libname.}
proc hyperell_locally_soluble*(pol: GEN; p: GEN): clong {.cdecl,
    importc: "hyperell_locally_soluble", dynlib: libname.}
proc nf_hyperell_locally_soluble*(nf: GEN; pol: GEN; p: GEN): clong {.cdecl,
    importc: "nf_hyperell_locally_soluble", dynlib: libname.}
proc closure_deriv*(G: GEN): GEN {.cdecl, importc: "closure_deriv", dynlib: libname.}
proc localvars_find*(pack: GEN; ep: ptr entree): clong {.cdecl,
    importc: "localvars_find", dynlib: libname.}
proc localvars_read_str*(str: cstring; pack: GEN): GEN {.cdecl,
    importc: "localvars_read_str", dynlib: libname.}
proc snm_closure*(ep: ptr entree; data: GEN): GEN {.cdecl, importc: "snm_closure",
    dynlib: libname.}
proc strtoclosure*(s: cstring; n: clong): GEN {.varargs, cdecl, importc: "strtoclosure",
    dynlib: libname.}
proc strtofunction*(s: cstring): GEN {.cdecl, importc: "strtofunction", dynlib: libname.}
proc concat*(x: GEN; y: GEN): GEN {.cdecl, importc: "concat", dynlib: libname.}
proc concat1*(x: GEN): GEN {.cdecl, importc: "concat1", dynlib: libname.}
proc matconcat*(v: GEN): GEN {.cdecl, importc: "matconcat", dynlib: libname.}
proc shallowconcat*(x: GEN; y: GEN): GEN {.cdecl, importc: "shallowconcat",
                                     dynlib: libname.}
proc shallowconcat1*(x: GEN): GEN {.cdecl, importc: "shallowconcat1", dynlib: libname.}
proc shallowmatconcat*(v: GEN): GEN {.cdecl, importc: "shallowmatconcat",
                                  dynlib: libname.}
proc vconcat*(A: GEN; B: GEN): GEN {.cdecl, importc: "vconcat", dynlib: libname.}
const
  d_SILENT* = 0
  d_ACKNOWLEDGE* = 1
  d_INITRC* = 2
  d_RETURN* = 3

proc default0*(a: cstring; b: cstring): GEN {.cdecl, importc: "default0", dynlib: libname.}
proc getrealprecision*(): clong {.cdecl, importc: "getrealprecision", dynlib: libname.}
proc pari_is_default*(s: cstring): cint {.cdecl, importc: "pari_is_default",
                                      dynlib: libname.}
proc sd_TeXstyle*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_TeXstyle",
    dynlib: libname.}
proc sd_colors*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_colors",
    dynlib: libname.}
proc sd_compatible*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_compatible",
    dynlib: libname.}
proc sd_datadir*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_datadir",
    dynlib: libname.}
proc sd_debug*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_debug",
    dynlib: libname.}
proc sd_debugfiles*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_debugfiles",
    dynlib: libname.}
proc sd_debugmem*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_debugmem",
    dynlib: libname.}
proc sd_factor_add_primes*(v: cstring; flag: clong): GEN {.cdecl,
    importc: "sd_factor_add_primes", dynlib: libname.}
proc sd_factor_proven*(v: cstring; flag: clong): GEN {.cdecl,
    importc: "sd_factor_proven", dynlib: libname.}
proc sd_format*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_format",
    dynlib: libname.}
proc sd_histsize*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_histsize",
    dynlib: libname.}
proc sd_log*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_log", dynlib: libname.}
proc sd_logfile*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_logfile",
    dynlib: libname.}
proc sd_nbthreads*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_nbthreads",
    dynlib: libname.}
proc sd_new_galois_format*(v: cstring; flag: clong): GEN {.cdecl,
    importc: "sd_new_galois_format", dynlib: libname.}
proc sd_output*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_output",
    dynlib: libname.}
proc sd_parisize*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_parisize",
    dynlib: libname.}
proc sd_path*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_path", dynlib: libname.}
proc sd_prettyprinter*(v: cstring; flag: clong): GEN {.cdecl,
    importc: "sd_prettyprinter", dynlib: libname.}
proc sd_primelimit*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_primelimit",
    dynlib: libname.}
proc sd_realprecision*(v: cstring; flag: clong): GEN {.cdecl,
    importc: "sd_realprecision", dynlib: libname.}
proc sd_secure*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_secure",
    dynlib: libname.}
proc sd_seriesprecision*(v: cstring; flag: clong): GEN {.cdecl,
    importc: "sd_seriesprecision", dynlib: libname.}
proc sd_simplify*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_simplify",
    dynlib: libname.}
proc sd_sopath*(v: cstring; flag: cint): GEN {.cdecl, importc: "sd_sopath",
    dynlib: libname.}
proc sd_strictargs*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_strictargs",
    dynlib: libname.}
proc sd_strictmatch*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_strictmatch",
    dynlib: libname.}
proc sd_string*(v: cstring; flag: clong; s: cstring; f: cstringArray): GEN {.cdecl,
    importc: "sd_string", dynlib: libname.}
proc sd_threadsize*(v: cstring; flag: clong): GEN {.cdecl, importc: "sd_threadsize",
    dynlib: libname.}
proc sd_toggle*(v: cstring; flag: clong; s: cstring; ptn: ptr cint): GEN {.cdecl,
    importc: "sd_toggle", dynlib: libname.}
proc sd_ulong*(v: cstring; flag: clong; s: cstring; ptn: ptr pari_ulong; Min: pari_ulong;
              Max: pari_ulong; msg: cstringArray): GEN {.cdecl, importc: "sd_ulong",
    dynlib: libname.}
proc setdefault*(s: cstring; v: cstring; flag: clong): GEN {.cdecl,
    importc: "setdefault", dynlib: libname.}
proc setrealprecision*(n: clong; prec: ptr clong): clong {.cdecl,
    importc: "setrealprecision", dynlib: libname.}
proc ellanalyticrank*(e: GEN; eps: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "ellanalyticrank", dynlib: libname.}
proc ellL1*(e: GEN; r: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellL1", dynlib: libname.}
proc ellconvertname*(s: GEN): GEN {.cdecl, importc: "ellconvertname", dynlib: libname.}
proc elldatagenerators*(E: GEN): GEN {.cdecl, importc: "elldatagenerators",
                                   dynlib: libname.}
proc ellidentify*(E: GEN): GEN {.cdecl, importc: "ellidentify", dynlib: libname.}
proc ellsearch*(A: GEN): GEN {.cdecl, importc: "ellsearch", dynlib: libname.}
proc ellsearchcurve*(name: GEN): GEN {.cdecl, importc: "ellsearchcurve",
                                   dynlib: libname.}
proc forell*(E: pointer; call: proc (a2: pointer; a3: GEN): clong {.cdecl.}; a: clong;
            b: clong) {.cdecl, importc: "forell", dynlib: libname.}
const
  t_ELL_Rg* = 0
  t_ELL_Q* = 1
  t_ELL_Qp* = 2
  t_ELL_Fp* = 3
  t_ELL_Fq* = 4

proc akell*(e: GEN; n: GEN): GEN {.cdecl, importc: "akell", dynlib: libname.}
proc anell*(e: GEN; n: clong): GEN {.cdecl, importc: "anell", dynlib: libname.}
proc anellsmall*(e: GEN; n: clong): GEN {.cdecl, importc: "anellsmall", dynlib: libname.}
proc bilhell*(e: GEN; z1: GEN; z2: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "bilhell",
    dynlib: libname.}
proc checkell*(e: GEN) {.cdecl, importc: "checkell", dynlib: libname.}
proc checkell_Fq*(e: GEN) {.cdecl, importc: "checkell_Fq", dynlib: libname.}
proc checkell_Q*(e: GEN) {.cdecl, importc: "checkell_Q", dynlib: libname.}
proc checkell_Qp*(e: GEN) {.cdecl, importc: "checkell_Qp", dynlib: libname.}
proc checkellpt*(z: GEN) {.cdecl, importc: "checkellpt", dynlib: libname.}
proc checkell5*(e: GEN) {.cdecl, importc: "checkell5", dynlib: libname.}
proc ellanal_globalred*(e: GEN; gr: ptr GEN): GEN {.cdecl, importc: "ellanal_globalred",
    dynlib: libname.}
proc ellQ_get_N*(e: GEN): GEN {.cdecl, importc: "ellQ_get_N", dynlib: libname.}
proc ellQ_get_Nfa*(e: GEN; N: ptr GEN; faN: ptr GEN) {.cdecl, importc: "ellQ_get_Nfa",
    dynlib: libname.}
proc ellQp_Tate_uniformization*(E: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "ellQp_Tate_uniformization", dynlib: libname.}
proc ellQp_u*(E: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellQp_u", dynlib: libname.}
proc ellQp_u2*(E: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellQp_u2", dynlib: libname.}
proc ellQp_q*(E: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellQp_q", dynlib: libname.}
proc ellQp_ab*(E: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellQp_ab", dynlib: libname.}
proc ellQp_root*(E: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellQp_root",
                                       dynlib: libname.}
proc ellR_ab*(E: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellR_ab", dynlib: libname.}
proc ellR_eta*(E: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellR_eta", dynlib: libname.}
proc ellR_omega*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellR_omega",
                                       dynlib: libname.}
proc ellR_roots*(E: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellR_roots",
                                       dynlib: libname.}
proc elladd*(e: GEN; z1: GEN; z2: GEN): GEN {.cdecl, importc: "elladd", dynlib: libname.}
proc ellap*(e: GEN; p: GEN): GEN {.cdecl, importc: "ellap", dynlib: libname.}
proc ellcard*(E: GEN; p: GEN): GEN {.cdecl, importc: "ellcard", dynlib: libname.}
proc ellchangecurve*(e: GEN; ch: GEN): GEN {.cdecl, importc: "ellchangecurve",
                                       dynlib: libname.}
proc ellchangeinvert*(w: GEN): GEN {.cdecl, importc: "ellchangeinvert", dynlib: libname.}
proc ellchangepoint*(x: GEN; ch: GEN): GEN {.cdecl, importc: "ellchangepoint",
                                       dynlib: libname.}
proc ellchangepointinv*(x: GEN; ch: GEN): GEN {.cdecl, importc: "ellchangepointinv",
    dynlib: libname.}
proc elldivpol*(e: GEN; n: clong; v: clong): GEN {.cdecl, importc: "elldivpol",
    dynlib: libname.}
proc elleisnum*(om: GEN; k: clong; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "elleisnum", dynlib: libname.}
proc elleta*(om: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "elleta", dynlib: libname.}
proc ellff_get_card*(E: GEN): GEN {.cdecl, importc: "ellff_get_card", dynlib: libname.}
proc ellff_get_gens*(E: GEN): GEN {.cdecl, importc: "ellff_get_gens", dynlib: libname.}
proc ellff_get_group*(E: GEN): GEN {.cdecl, importc: "ellff_get_group", dynlib: libname.}
proc ellff_get_o*(x: GEN): GEN {.cdecl, importc: "ellff_get_o", dynlib: libname.}
proc ellff_get_p*(E: GEN): GEN {.cdecl, importc: "ellff_get_p", dynlib: libname.}
proc ellfromj*(j: GEN): GEN {.cdecl, importc: "ellfromj", dynlib: libname.}
proc ellgenerators*(E: GEN): GEN {.cdecl, importc: "ellgenerators", dynlib: libname.}
proc ellglobalred*(e1: GEN): GEN {.cdecl, importc: "ellglobalred", dynlib: libname.}
proc ellgroup*(E: GEN; p: GEN): GEN {.cdecl, importc: "ellgroup", dynlib: libname.}
proc ellgroup0*(E: GEN; p: GEN; flag: clong): GEN {.cdecl, importc: "ellgroup0",
    dynlib: libname.}
proc ellheight0*(e: GEN; a: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "ellheight0", dynlib: libname.}
proc ellheegner*(e: GEN): GEN {.cdecl, importc: "ellheegner", dynlib: libname.}
proc ellinit*(x: GEN; p: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellinit",
    dynlib: libname.}
proc ellisoncurve*(e: GEN; z: GEN): GEN {.cdecl, importc: "ellisoncurve", dynlib: libname.}
proc elllseries*(e: GEN; s: GEN; A: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "elllseries",
    dynlib: libname.}
proc elllocalred*(e: GEN; p1: GEN): GEN {.cdecl, importc: "elllocalred", dynlib: libname.}
proc elllog*(e: GEN; a: GEN; g: GEN; o: GEN): GEN {.cdecl, importc: "elllog", dynlib: libname.}
proc ellminimalmodel*(E: GEN; ptv: ptr GEN): GEN {.cdecl, importc: "ellminimalmodel",
    dynlib: libname.}
proc ellmul*(e: GEN; z: GEN; n: GEN): GEN {.cdecl, importc: "ellmul", dynlib: libname.}
proc ellneg*(e: GEN; z: GEN): GEN {.cdecl, importc: "ellneg", dynlib: libname.}
proc ellorder*(e: GEN; p: GEN; o: GEN): GEN {.cdecl, importc: "ellorder", dynlib: libname.}
proc ellordinate*(e: GEN; x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellordinate",
    dynlib: libname.}
proc ellperiods*(w: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellperiods",
    dynlib: libname.}
proc ellrandom*(e: GEN): GEN {.cdecl, importc: "ellrandom", dynlib: libname.}
proc ellrootno*(e: GEN; p: GEN): clong {.cdecl, importc: "ellrootno", dynlib: libname.}
proc ellrootno_global*(e: GEN): clong {.cdecl, importc: "ellrootno_global",
                                    dynlib: libname.}
proc ellsigma*(om: GEN; z: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "ellsigma", dynlib: libname.}
proc ellsub*(e: GEN; z1: GEN; z2: GEN): GEN {.cdecl, importc: "ellsub", dynlib: libname.}
proc elltaniyama*(e: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "elltaniyama",
                                        dynlib: libname.}
proc elltatepairing*(E: GEN; t: GEN; s: GEN; m: GEN): GEN {.cdecl,
    importc: "elltatepairing", dynlib: libname.}
proc elltors*(e: GEN): GEN {.cdecl, importc: "elltors", dynlib: libname.}
proc elltors0*(e: GEN; flag: clong): GEN {.cdecl, importc: "elltors0", dynlib: libname.}
proc ellweilpairing*(E: GEN; t: GEN; s: GEN; m: GEN): GEN {.cdecl,
    importc: "ellweilpairing", dynlib: libname.}
proc ellwp*(w: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellwp", dynlib: libname.}
proc ellwp0*(w: GEN; z: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellwp0",
    dynlib: libname.}
proc ellwpseries*(e: GEN; v: clong; PRECDL: clong): GEN {.cdecl, importc: "ellwpseries",
    dynlib: libname.}
proc ellzeta*(om: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ellzeta",
    dynlib: libname.}
proc expIxy*(x: GEN; y: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "expIxy", dynlib: libname.}
proc ghell*(e: GEN; a: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ghell", dynlib: libname.}
proc mathell*(e: GEN; x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "mathell",
    dynlib: libname.}
proc oncurve*(e: GEN; z: GEN): cint {.cdecl, importc: "oncurve", dynlib: libname.}
proc orderell*(e: GEN; p: GEN): GEN {.cdecl, importc: "orderell", dynlib: libname.}
proc pointell*(e: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "pointell",
    dynlib: libname.}
proc zell*(e: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "zell", dynlib: libname.}
proc Fp_ellcard_SEA*(a4: GEN; a6: GEN; p: GEN; early_abort: clong): GEN {.cdecl,
    importc: "Fp_ellcard_SEA", dynlib: libname.}
proc Fq_ellcard_SEA*(a4: GEN; a6: GEN; q: GEN; T: GEN; p: GEN; early_abort: clong): GEN {.
    cdecl, importc: "Fq_ellcard_SEA", dynlib: libname.}
proc ellmodulareqn*(par_l: clong; vx: clong; vy: clong): GEN {.cdecl,
    importc: "ellmodulareqn", dynlib: libname.}
proc ellsea*(E: GEN; p: GEN; early_abort: clong): GEN {.cdecl, importc: "ellsea",
    dynlib: libname.}
proc GENtoGENstr_nospace*(x: GEN): GEN {.cdecl, importc: "GENtoGENstr_nospace",
                                     dynlib: libname.}
proc GENtoGENstr*(x: GEN): GEN {.cdecl, importc: "GENtoGENstr", dynlib: libname.}
proc GENtoTeXstr*(x: GEN): cstring {.cdecl, importc: "GENtoTeXstr", dynlib: libname.}
proc GENtostr*(x: GEN): cstring {.cdecl, importc: "GENtostr", dynlib: libname.}
proc GENtostr_unquoted*(x: GEN): cstring {.cdecl, importc: "GENtostr_unquoted",
                                       dynlib: libname.}
proc Str*(g: GEN): GEN {.cdecl, importc: "Str", dynlib: libname.}
proc Strchr*(g: GEN): GEN {.cdecl, importc: "Strchr", dynlib: libname.}
proc Strexpand*(g: GEN): GEN {.cdecl, importc: "Strexpand", dynlib: libname.}
proc Strtex*(g: GEN): GEN {.cdecl, importc: "Strtex", dynlib: libname.}
proc brute*(g: GEN; format: char; dec: clong) {.cdecl, importc: "brute", dynlib: libname.}
proc dbgGEN*(x: GEN; nb: clong) {.cdecl, importc: "dbgGEN", dynlib: libname.}
proc error0*(g: GEN) {.cdecl, importc: "error0", dynlib: libname.}
proc dbg_pari_heap*() {.cdecl, importc: "dbg_pari_heap", dynlib: libname.}
proc file_is_binary*(f: ptr FILE): cint {.cdecl, importc: "file_is_binary",
                                     dynlib: libname.}
proc err_flush*() {.cdecl, importc: "err_flush", dynlib: libname.}
proc err_printf*(pat: cstring) {.varargs, cdecl, importc: "err_printf", dynlib: libname.}
proc gp_getenv*(s: cstring): GEN {.cdecl, importc: "gp_getenv", dynlib: libname.}
proc gp_read_file*(s: cstring): GEN {.cdecl, importc: "gp_read_file", dynlib: libname.}
proc gp_read_stream*(f: ptr FILE): GEN {.cdecl, importc: "gp_read_stream",
                                    dynlib: libname.}
proc gp_readvec_file*(s: cstring): GEN {.cdecl, importc: "gp_readvec_file",
                                     dynlib: libname.}
proc gp_readvec_stream*(f: ptr FILE): GEN {.cdecl, importc: "gp_readvec_stream",
                                       dynlib: libname.}
proc gpinstall*(s: cstring; code: cstring; gpname: cstring; lib: cstring) {.cdecl,
    importc: "gpinstall", dynlib: libname.}
proc gsprintf*(fmt: cstring): GEN {.varargs, cdecl, importc: "gsprintf", dynlib: libname.}
proc gvsprintf*(fmt: cstring; ap: va_list): GEN {.cdecl, importc: "gvsprintf",
    dynlib: libname.}
proc itostr*(x: GEN): cstring {.cdecl, importc: "itostr", dynlib: libname.}
proc matbrute*(g: GEN; format: char; dec: clong) {.cdecl, importc: "matbrute",
    dynlib: libname.}
proc os_getenv*(s: cstring): cstring {.cdecl, importc: "os_getenv", dynlib: libname.}
## #--void (*os_signal(int sig, void (*f)(int)))(int);

proc outmat*(x: GEN) {.cdecl, importc: "outmat", dynlib: libname.}
proc output*(x: GEN) {.cdecl, importc: "output", dynlib: libname.}
proc RgV_to_str*(g: GEN; flag: clong): cstring {.cdecl, importc: "RgV_to_str",
    dynlib: libname.}
proc pari_add_hist*(z: GEN; t: clong) {.cdecl, importc: "pari_add_hist", dynlib: libname.}
proc pari_ask_confirm*(s: cstring) {.cdecl, importc: "pari_ask_confirm",
                                  dynlib: libname.}
proc pari_fclose*(f: ptr pariFILE) {.cdecl, importc: "pari_fclose", dynlib: libname.}
proc pari_flush*() {.cdecl, importc: "pari_flush", dynlib: libname.}
proc pari_fopen*(s: cstring; mode: cstring): ptr pariFILE {.cdecl,
    importc: "pari_fopen", dynlib: libname.}
proc pari_fopen_or_fail*(s: cstring; mode: cstring): ptr pariFILE {.cdecl,
    importc: "pari_fopen_or_fail", dynlib: libname.}
proc pari_fopengz*(s: cstring): ptr pariFILE {.cdecl, importc: "pari_fopengz",
    dynlib: libname.}
proc pari_fprintf*(file: ptr FILE; fmt: cstring) {.varargs, cdecl,
    importc: "pari_fprintf", dynlib: libname.}
proc pari_fread_chars*(b: pointer; n: csize; f: ptr FILE) {.cdecl,
    importc: "pari_fread_chars", dynlib: libname.}
proc pari_get_hist*(p: clong): GEN {.cdecl, importc: "pari_get_hist", dynlib: libname.}
proc pari_get_histtime*(p: clong): clong {.cdecl, importc: "pari_get_histtime",
                                       dynlib: libname.}
proc pari_get_homedir*(user: cstring): cstring {.cdecl, importc: "pari_get_homedir",
    dynlib: libname.}
proc pari_is_dir*(name: cstring): cint {.cdecl, importc: "pari_is_dir", dynlib: libname.}
proc pari_is_file*(name: cstring): cint {.cdecl, importc: "pari_is_file",
                                      dynlib: libname.}
proc pari_last_was_newline*(): cint {.cdecl, importc: "pari_last_was_newline",
                                   dynlib: libname.}
proc pari_set_last_newline*(last: cint) {.cdecl, importc: "pari_set_last_newline",
                                       dynlib: libname.}
proc pari_nb_hist*(): pari_ulong {.cdecl, importc: "pari_nb_hist", dynlib: libname.}
proc pari_printf*(fmt: cstring) {.varargs, cdecl, importc: "pari_printf",
                               dynlib: libname.}
proc pari_putc*(c: char) {.cdecl, importc: "pari_putc", dynlib: libname.}
proc pari_puts*(s: cstring) {.cdecl, importc: "pari_puts", dynlib: libname.}
proc pari_safefopen*(s: cstring; mode: cstring): ptr pariFILE {.cdecl,
    importc: "pari_safefopen", dynlib: libname.}
proc pari_sprintf*(fmt: cstring): cstring {.varargs, cdecl, importc: "pari_sprintf",
                                        dynlib: libname.}
proc pari_stdin_isatty*(): cint {.cdecl, importc: "pari_stdin_isatty", dynlib: libname.}
proc pari_strdup*(s: cstring): cstring {.cdecl, importc: "pari_strdup", dynlib: libname.}
proc pari_strndup*(s: cstring; n: clong): cstring {.cdecl, importc: "pari_strndup",
    dynlib: libname.}
proc pari_unique_dir*(s: cstring): cstring {.cdecl, importc: "pari_unique_dir",
    dynlib: libname.}
proc pari_unique_filename*(s: cstring): cstring {.cdecl,
    importc: "pari_unique_filename", dynlib: libname.}
proc pari_unlink*(s: cstring) {.cdecl, importc: "pari_unlink", dynlib: libname.}
proc pari_vfprintf*(file: ptr FILE; fmt: cstring; ap: va_list) {.cdecl,
    importc: "pari_vfprintf", dynlib: libname.}
proc pari_vprintf*(fmt: cstring; ap: va_list) {.cdecl, importc: "pari_vprintf",
    dynlib: libname.}
proc pari_vsprintf*(fmt: cstring; ap: va_list): cstring {.cdecl,
    importc: "pari_vsprintf", dynlib: libname.}
proc path_expand*(s: cstring): cstring {.cdecl, importc: "path_expand", dynlib: libname.}
proc out_print0*(`out`: ptr PariOUT; sep: cstring; g: GEN; flag: clong) {.cdecl,
    importc: "out_print0", dynlib: libname.}
proc out_printf*(`out`: ptr PariOUT; fmt: cstring) {.varargs, cdecl,
    importc: "out_printf", dynlib: libname.}
proc out_putc*(`out`: ptr PariOUT; c: char) {.cdecl, importc: "out_putc", dynlib: libname.}
proc out_puts*(`out`: ptr PariOUT; s: cstring) {.cdecl, importc: "out_puts",
    dynlib: libname.}
proc out_term_color*(`out`: ptr PariOUT; c: clong) {.cdecl, importc: "out_term_color",
    dynlib: libname.}
proc out_vprintf*(`out`: ptr PariOUT; fmt: cstring; ap: va_list) {.cdecl,
    importc: "out_vprintf", dynlib: libname.}
proc pari_sprint0*(msg: cstring; g: GEN; flag: clong): cstring {.cdecl,
    importc: "pari_sprint0", dynlib: libname.}
proc print*(g: GEN) {.cdecl, importc: "print", dynlib: libname.}
const
  f_RAW* = 0
  f_PRETTYMAT* = 1
  f_PRETTY* = 3
  f_TEX* = 4

proc print0*(g: GEN; flag: clong) {.cdecl, importc: "print0", dynlib: libname.}
proc print1*(g: GEN) {.cdecl, importc: "print1", dynlib: libname.}
proc printf0*(fmt: cstring; args: GEN) {.cdecl, importc: "printf0", dynlib: libname.}
proc printsep*(s: cstring; g: GEN; flag: clong) {.cdecl, importc: "printsep",
    dynlib: libname.}
proc printsep1*(s: cstring; g: GEN; flag: clong) {.cdecl, importc: "printsep1",
    dynlib: libname.}
proc printtex*(g: GEN) {.cdecl, importc: "printtex", dynlib: libname.}
proc stack_sprintf*(fmt: cstring): cstring {.varargs, cdecl, importc: "stack_sprintf",
    dynlib: libname.}
proc stack_strcat*(s: cstring; t: cstring): cstring {.cdecl, importc: "stack_strcat",
    dynlib: libname.}
proc stack_strdup*(s: cstring): cstring {.cdecl, importc: "stack_strdup",
                                      dynlib: libname.}
proc strftime_expand*(s: cstring; buf: cstring; max: clong) {.cdecl,
    importc: "strftime_expand", dynlib: libname.}
proc Strprintf*(fmt: cstring; args: GEN): GEN {.cdecl, importc: "Strprintf",
    dynlib: libname.}
proc switchin*(name: cstring): ptr FILE {.cdecl, importc: "switchin", dynlib: libname.}
proc switchout*(name: cstring) {.cdecl, importc: "switchout", dynlib: libname.}
proc term_color*(c: clong) {.cdecl, importc: "term_color", dynlib: libname.}
proc term_get_color*(s: cstring; c: clong): cstring {.cdecl, importc: "term_get_color",
    dynlib: libname.}
proc texe*(g: GEN; format: char; dec: clong) {.cdecl, importc: "texe", dynlib: libname.}
proc type_name*(t: clong): cstring {.cdecl, importc: "type_name", dynlib: libname.}
proc warning0*(g: GEN) {.cdecl, importc: "warning0", dynlib: libname.}
proc write0*(s: cstring; g: GEN) {.cdecl, importc: "write0", dynlib: libname.}
proc write1*(s: cstring; g: GEN) {.cdecl, importc: "write1", dynlib: libname.}
proc writebin*(name: cstring; x: GEN) {.cdecl, importc: "writebin", dynlib: libname.}
proc writetex*(s: cstring; g: GEN) {.cdecl, importc: "writetex", dynlib: libname.}
const
  br_NONE* = 0
  br_BREAK* = 1
  br_NEXT* = 2
  br_MULTINEXT* = 3
  br_RETURN* = 4

proc bincopy_relink*(C: GEN; vi: GEN) {.cdecl, importc: "bincopy_relink",
                                   dynlib: libname.}
proc break0*(n: clong): GEN {.cdecl, importc: "break0", dynlib: libname.}
proc closure_callgen1*(C: GEN; x: GEN): GEN {.cdecl, importc: "closure_callgen1",
                                        dynlib: libname.}
proc closure_callgen2*(C: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "closure_callgen2",
    dynlib: libname.}
proc closure_callgenall*(C: GEN; n: clong): GEN {.varargs, cdecl,
    importc: "closure_callgenall", dynlib: libname.}
proc closure_callgenvec*(C: GEN; args: GEN): GEN {.cdecl,
    importc: "closure_callgenvec", dynlib: libname.}
proc closure_callvoid1*(C: GEN; x: GEN) {.cdecl, importc: "closure_callvoid1",
                                     dynlib: libname.}
proc closure_context*(start: clong; level: clong): clong {.cdecl,
    importc: "closure_context", dynlib: libname.}
proc closure_disassemble*(n: GEN) {.cdecl, importc: "closure_disassemble",
                                 dynlib: libname.}
proc closure_err*(level: clong) {.cdecl, importc: "closure_err", dynlib: libname.}
proc closure_evalbrk*(C: GEN; status: ptr clong): GEN {.cdecl,
    importc: "closure_evalbrk", dynlib: libname.}
proc closure_evalgen*(C: GEN): GEN {.cdecl, importc: "closure_evalgen", dynlib: libname.}
proc closure_evalnobrk*(C: GEN): GEN {.cdecl, importc: "closure_evalnobrk",
                                   dynlib: libname.}
proc closure_evalres*(C: GEN): GEN {.cdecl, importc: "closure_evalres", dynlib: libname.}
proc closure_evalvoid*(C: GEN) {.cdecl, importc: "closure_evalvoid", dynlib: libname.}
proc closure_trapgen*(C: GEN; numerr: clong): GEN {.cdecl, importc: "closure_trapgen",
    dynlib: libname.}
proc copybin_unlink*(C: GEN): GEN {.cdecl, importc: "copybin_unlink", dynlib: libname.}
proc get_lex*(vn: clong): GEN {.cdecl, importc: "get_lex", dynlib: libname.}
proc gp_call*(E: pointer; x: GEN): GEN {.cdecl, importc: "gp_call", dynlib: libname.}
proc gp_callbool*(E: pointer; x: GEN): clong {.cdecl, importc: "gp_callbool",
    dynlib: libname.}
proc gp_callvoid*(E: pointer; x: GEN): clong {.cdecl, importc: "gp_callvoid",
    dynlib: libname.}
proc gp_eval*(E: pointer; x: GEN): GEN {.cdecl, importc: "gp_eval", dynlib: libname.}
proc gp_evalbool*(E: pointer; x: GEN): clong {.cdecl, importc: "gp_evalbool",
    dynlib: libname.}
proc gp_evalupto*(E: pointer; x: GEN): GEN {.cdecl, importc: "gp_evalupto",
                                       dynlib: libname.}
proc gp_evalvoid*(E: pointer; x: GEN): clong {.cdecl, importc: "gp_evalvoid",
    dynlib: libname.}
proc loop_break*(): clong {.cdecl, importc: "loop_break", dynlib: libname.}
proc next0*(n: clong): GEN {.cdecl, importc: "next0", dynlib: libname.}
proc pareval*(C: GEN): GEN {.cdecl, importc: "pareval", dynlib: libname.}
proc parsum*(a: GEN; b: GEN; code: GEN; x: GEN): GEN {.cdecl, importc: "parsum",
    dynlib: libname.}
proc parvector*(n: clong; code: GEN): GEN {.cdecl, importc: "parvector", dynlib: libname.}
proc pop_lex*(n: clong) {.cdecl, importc: "pop_lex", dynlib: libname.}
proc push_lex*(a: GEN; C: GEN) {.cdecl, importc: "push_lex", dynlib: libname.}
proc return0*(x: GEN): GEN {.cdecl, importc: "return0", dynlib: libname.}
proc set_lex*(vn: clong; x: GEN) {.cdecl, importc: "set_lex", dynlib: libname.}
proc FF_1*(a: GEN): GEN {.cdecl, importc: "FF_1", dynlib: libname.}
proc FF_Z_Z_muldiv*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc: "FF_Z_Z_muldiv",
    dynlib: libname.}
proc FF_Q_add*(x: GEN; y: GEN): GEN {.cdecl, importc: "FF_Q_add", dynlib: libname.}
proc FF_Z_add*(a: GEN; b: GEN): GEN {.cdecl, importc: "FF_Z_add", dynlib: libname.}
proc FF_Z_mul*(a: GEN; b: GEN): GEN {.cdecl, importc: "FF_Z_mul", dynlib: libname.}
proc FF_add*(a: GEN; b: GEN): GEN {.cdecl, importc: "FF_add", dynlib: libname.}
proc FF_charpoly*(x: GEN): GEN {.cdecl, importc: "FF_charpoly", dynlib: libname.}
proc FF_conjvec*(x: GEN): GEN {.cdecl, importc: "FF_conjvec", dynlib: libname.}
proc FF_div*(a: GEN; b: GEN): GEN {.cdecl, importc: "FF_div", dynlib: libname.}
proc FF_ellcard*(E: GEN): GEN {.cdecl, importc: "FF_ellcard", dynlib: libname.}
proc FF_ellgens*(E: GEN): GEN {.cdecl, importc: "FF_ellgens", dynlib: libname.}
proc FF_ellgroup*(E: GEN): GEN {.cdecl, importc: "FF_ellgroup", dynlib: libname.}
proc FF_elllog*(E: GEN; P: GEN; Q: GEN; o: GEN): GEN {.cdecl, importc: "FF_elllog",
    dynlib: libname.}
proc FF_ellmul*(E: GEN; P: GEN; n: GEN): GEN {.cdecl, importc: "FF_ellmul", dynlib: libname.}
proc FF_ellorder*(E: GEN; P: GEN; o: GEN): GEN {.cdecl, importc: "FF_ellorder",
    dynlib: libname.}
proc FF_ellrandom*(E: GEN): GEN {.cdecl, importc: "FF_ellrandom", dynlib: libname.}
proc FF_elltatepairing*(E: GEN; P: GEN; Q: GEN; m: GEN): GEN {.cdecl,
    importc: "FF_elltatepairing", dynlib: libname.}
proc FF_ellweilpairing*(E: GEN; P: GEN; Q: GEN; m: GEN): GEN {.cdecl,
    importc: "FF_ellweilpairing", dynlib: libname.}
proc FF_equal*(a: GEN; b: GEN): cint {.cdecl, importc: "FF_equal", dynlib: libname.}
proc FF_equal0*(x: GEN): cint {.cdecl, importc: "FF_equal0", dynlib: libname.}
proc FF_equal1*(x: GEN): cint {.cdecl, importc: "FF_equal1", dynlib: libname.}
proc FF_equalm1*(x: GEN): cint {.cdecl, importc: "FF_equalm1", dynlib: libname.}
proc FF_f*(x: GEN): clong {.cdecl, importc: "FF_f", dynlib: libname.}
proc FF_inv*(a: GEN): GEN {.cdecl, importc: "FF_inv", dynlib: libname.}
proc FF_issquare*(x: GEN): clong {.cdecl, importc: "FF_issquare", dynlib: libname.}
proc FF_issquareall*(x: GEN; pt: ptr GEN): clong {.cdecl, importc: "FF_issquareall",
    dynlib: libname.}
proc FF_ispower*(x: GEN; K: GEN; pt: ptr GEN): clong {.cdecl, importc: "FF_ispower",
    dynlib: libname.}
proc FF_log*(a: GEN; b: GEN; o: GEN): GEN {.cdecl, importc: "FF_log", dynlib: libname.}
proc FF_minpoly*(x: GEN): GEN {.cdecl, importc: "FF_minpoly", dynlib: libname.}
proc FF_mod*(x: GEN): GEN {.cdecl, importc: "FF_mod", dynlib: libname.}
proc FF_mul*(a: GEN; b: GEN): GEN {.cdecl, importc: "FF_mul", dynlib: libname.}
proc FF_mul2n*(a: GEN; n: clong): GEN {.cdecl, importc: "FF_mul2n", dynlib: libname.}
proc FF_neg*(a: GEN): GEN {.cdecl, importc: "FF_neg", dynlib: libname.}
proc FF_neg_i*(a: GEN): GEN {.cdecl, importc: "FF_neg_i", dynlib: libname.}
proc FF_norm*(x: GEN): GEN {.cdecl, importc: "FF_norm", dynlib: libname.}
proc FF_order*(x: GEN; o: GEN): GEN {.cdecl, importc: "FF_order", dynlib: libname.}
proc FF_p*(x: GEN): GEN {.cdecl, importc: "FF_p", dynlib: libname.}
proc FF_p_i*(x: GEN): GEN {.cdecl, importc: "FF_p_i", dynlib: libname.}
proc FF_pow*(x: GEN; n: GEN): GEN {.cdecl, importc: "FF_pow", dynlib: libname.}
proc FF_primroot*(x: GEN; o: ptr GEN): GEN {.cdecl, importc: "FF_primroot",
                                      dynlib: libname.}
proc FF_q*(x: GEN): GEN {.cdecl, importc: "FF_q", dynlib: libname.}
proc FF_samefield*(x: GEN; y: GEN): cint {.cdecl, importc: "FF_samefield",
                                     dynlib: libname.}
proc FF_sqr*(a: GEN): GEN {.cdecl, importc: "FF_sqr", dynlib: libname.}
proc FF_sqrt*(a: GEN): GEN {.cdecl, importc: "FF_sqrt", dynlib: libname.}
proc FF_sqrtn*(x: GEN; n: GEN; zetan: ptr GEN): GEN {.cdecl, importc: "FF_sqrtn",
    dynlib: libname.}
proc FF_sub*(x: GEN; y: GEN): GEN {.cdecl, importc: "FF_sub", dynlib: libname.}
proc FF_to_F2xq*(x: GEN): GEN {.cdecl, importc: "FF_to_F2xq", dynlib: libname.}
proc FF_to_F2xq_i*(x: GEN): GEN {.cdecl, importc: "FF_to_F2xq_i", dynlib: libname.}
proc FF_to_Flxq*(x: GEN): GEN {.cdecl, importc: "FF_to_Flxq", dynlib: libname.}
proc FF_to_Flxq_i*(x: GEN): GEN {.cdecl, importc: "FF_to_Flxq_i", dynlib: libname.}
proc FF_to_FpXQ*(x: GEN): GEN {.cdecl, importc: "FF_to_FpXQ", dynlib: libname.}
proc FF_to_FpXQ_i*(x: GEN): GEN {.cdecl, importc: "FF_to_FpXQ_i", dynlib: libname.}
proc FF_trace*(x: GEN): GEN {.cdecl, importc: "FF_trace", dynlib: libname.}
proc FF_zero*(a: GEN): GEN {.cdecl, importc: "FF_zero", dynlib: libname.}
proc FFM_FFC_mul*(M: GEN; C: GEN; ff: GEN): GEN {.cdecl, importc: "FFM_FFC_mul",
    dynlib: libname.}
proc FFM_det*(M: GEN; ff: GEN): GEN {.cdecl, importc: "FFM_det", dynlib: libname.}
proc FFM_image*(M: GEN; ff: GEN): GEN {.cdecl, importc: "FFM_image", dynlib: libname.}
proc FFM_inv*(M: GEN; ff: GEN): GEN {.cdecl, importc: "FFM_inv", dynlib: libname.}
proc FFM_ker*(M: GEN; ff: GEN): GEN {.cdecl, importc: "FFM_ker", dynlib: libname.}
proc FFM_mul*(M: GEN; N: GEN; ff: GEN): GEN {.cdecl, importc: "FFM_mul", dynlib: libname.}
proc FFM_rank*(M: GEN; ff: GEN): clong {.cdecl, importc: "FFM_rank", dynlib: libname.}
proc FFX_factor*(f: GEN; x: GEN): GEN {.cdecl, importc: "FFX_factor", dynlib: libname.}
proc FFX_roots*(f: GEN; x: GEN): GEN {.cdecl, importc: "FFX_roots", dynlib: libname.}
proc Z_FF_div*(a: GEN; b: GEN): GEN {.cdecl, importc: "Z_FF_div", dynlib: libname.}
proc ffgen*(T: GEN; v: clong): GEN {.cdecl, importc: "ffgen", dynlib: libname.}
proc fflog*(x: GEN; g: GEN; o: GEN): GEN {.cdecl, importc: "fflog", dynlib: libname.}
proc fforder*(x: GEN; o: GEN): GEN {.cdecl, importc: "fforder", dynlib: libname.}
proc ffprimroot*(x: GEN; o: ptr GEN): GEN {.cdecl, importc: "ffprimroot", dynlib: libname.}
proc ffrandom*(ff: GEN): GEN {.cdecl, importc: "ffrandom", dynlib: libname.}
proc Rg_is_FF*(c: GEN; ff: ptr GEN): cint {.cdecl, importc: "Rg_is_FF", dynlib: libname.}
proc RgC_is_FFC*(x: GEN; ff: ptr GEN): cint {.cdecl, importc: "RgC_is_FFC",
                                       dynlib: libname.}
proc RgM_is_FFM*(x: GEN; ff: ptr GEN): cint {.cdecl, importc: "RgM_is_FFM",
                                       dynlib: libname.}
proc p_to_FF*(p: GEN; v: clong): GEN {.cdecl, importc: "p_to_FF", dynlib: libname.}
proc checkgal*(gal: GEN): GEN {.cdecl, importc: "checkgal", dynlib: libname.}
proc checkgroup*(g: GEN; S: ptr GEN): GEN {.cdecl, importc: "checkgroup", dynlib: libname.}
proc embed_disc*(r: GEN; r1: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "embed_disc",
    dynlib: libname.}
proc embed_roots*(r: GEN; r1: clong): GEN {.cdecl, importc: "embed_roots",
                                      dynlib: libname.}
proc galois_group*(gal: GEN): GEN {.cdecl, importc: "galois_group", dynlib: libname.}
proc galoisconj*(nf: GEN; d: GEN): GEN {.cdecl, importc: "galoisconj", dynlib: libname.}
proc galoisconj0*(nf: GEN; flag: clong; d: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "galoisconj0", dynlib: libname.}
proc galoisexport*(gal: GEN; format: clong): GEN {.cdecl, importc: "galoisexport",
    dynlib: libname.}
proc galoisfixedfield*(gal: GEN; v: GEN; flag: clong; y: clong): GEN {.cdecl,
    importc: "galoisfixedfield", dynlib: libname.}
proc galoisidentify*(gal: GEN): GEN {.cdecl, importc: "galoisidentify", dynlib: libname.}
proc galoisinit*(nf: GEN; den: GEN): GEN {.cdecl, importc: "galoisinit", dynlib: libname.}
proc galoisisabelian*(gal: GEN; flag: clong): GEN {.cdecl, importc: "galoisisabelian",
    dynlib: libname.}
proc galoisisnormal*(gal: GEN; sub: GEN): clong {.cdecl, importc: "galoisisnormal",
    dynlib: libname.}
proc galoispermtopol*(gal: GEN; perm: GEN): GEN {.cdecl, importc: "galoispermtopol",
    dynlib: libname.}
proc galoissubgroups*(G: GEN): GEN {.cdecl, importc: "galoissubgroups", dynlib: libname.}
proc galoissubfields*(G: GEN; flag: clong; v: clong): GEN {.cdecl,
    importc: "galoissubfields", dynlib: libname.}
proc numberofconjugates*(T: GEN; pdepart: clong): clong {.cdecl,
    importc: "numberofconjugates", dynlib: libname.}
proc vandermondeinverse*(L: GEN; T: GEN; den: GEN; prep: GEN): GEN {.cdecl,
    importc: "vandermondeinverse", dynlib: libname.}
proc galoisnbpol*(a: clong): GEN {.cdecl, importc: "galoisnbpol", dynlib: libname.}
proc galoisgetpol*(a: clong; b: clong; s: clong): GEN {.cdecl, importc: "galoisgetpol",
    dynlib: libname.}
proc conjvec*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "conjvec", dynlib: libname.}
proc gadd*(x: GEN; y: GEN): GEN {.cdecl, importc: "gadd", dynlib: libname.}
proc gaddsg*(x: clong; y: GEN): GEN {.cdecl, importc: "gaddsg", dynlib: libname.}
proc gconj*(x: GEN): GEN {.cdecl, importc: "gconj", dynlib: libname.}
proc gdiv*(x: GEN; y: GEN): GEN {.cdecl, importc: "gdiv", dynlib: libname.}
proc gdivgs*(x: GEN; s: clong): GEN {.cdecl, importc: "gdivgs", dynlib: libname.}
proc ginv*(x: GEN): GEN {.cdecl, importc: "ginv", dynlib: libname.}
proc gmul*(x: GEN; y: GEN): GEN {.cdecl, importc: "gmul", dynlib: libname.}
proc gmul2n*(x: GEN; n: clong): GEN {.cdecl, importc: "gmul2n", dynlib: libname.}
proc gmulsg*(s: clong; y: GEN): GEN {.cdecl, importc: "gmulsg", dynlib: libname.}
proc gsqr*(x: GEN): GEN {.cdecl, importc: "gsqr", dynlib: libname.}
proc gsub*(x: GEN; y: GEN): GEN {.cdecl, importc: "gsub", dynlib: libname.}
proc gsubsg*(x: clong; y: GEN): GEN {.cdecl, importc: "gsubsg", dynlib: libname.}
proc inv_ser*(b: GEN): GEN {.cdecl, importc: "inv_ser", dynlib: libname.}
proc mulcxI*(x: GEN): GEN {.cdecl, importc: "mulcxI", dynlib: libname.}
proc mulcxmI*(x: GEN): GEN {.cdecl, importc: "mulcxmI", dynlib: libname.}
proc ser_normalize*(x: GEN): GEN {.cdecl, importc: "ser_normalize", dynlib: libname.}
proc gassoc_proto*(f: proc (a2: GEN; a3: GEN): GEN {.cdecl.}; a3: GEN; a4: GEN): GEN {.cdecl,
    importc: "gassoc_proto", dynlib: libname.}
proc map_proto_G*(f: proc (a2: GEN): GEN {.cdecl.}; x: GEN): GEN {.cdecl,
    importc: "map_proto_G", dynlib: libname.}
proc map_proto_lG*(f: proc (a2: GEN): clong {.cdecl.}; x: GEN): GEN {.cdecl,
    importc: "map_proto_lG", dynlib: libname.}
proc map_proto_lGL*(f: proc (a2: GEN; a3: clong): clong {.cdecl.}; x: GEN; y: clong): GEN {.
    cdecl, importc: "map_proto_lGL", dynlib: libname.}
proc Q_pval*(x: GEN; p: GEN): clong {.cdecl, importc: "Q_pval", dynlib: libname.}
proc Q_pvalrem*(x: GEN; p: GEN; y: ptr GEN): clong {.cdecl, importc: "Q_pvalrem",
    dynlib: libname.}
proc RgX_val*(x: GEN): clong {.cdecl, importc: "RgX_val", dynlib: libname.}
proc RgX_valrem*(x: GEN; z: ptr GEN): clong {.cdecl, importc: "RgX_valrem",
                                       dynlib: libname.}
proc RgX_valrem_inexact*(x: GEN; Z: ptr GEN): clong {.cdecl,
    importc: "RgX_valrem_inexact", dynlib: libname.}
proc ZV_Z_dvd*(v: GEN; p: GEN): cint {.cdecl, importc: "ZV_Z_dvd", dynlib: libname.}
proc ZV_pval*(x: GEN; p: GEN): clong {.cdecl, importc: "ZV_pval", dynlib: libname.}
proc ZV_pvalrem*(x: GEN; p: GEN; px: ptr GEN): clong {.cdecl, importc: "ZV_pvalrem",
    dynlib: libname.}
proc ZV_lval*(x: GEN; p: pari_ulong): clong {.cdecl, importc: "ZV_lval", dynlib: libname.}
proc ZV_lvalrem*(x: GEN; p: pari_ulong; px: ptr GEN): clong {.cdecl,
    importc: "ZV_lvalrem", dynlib: libname.}
proc ZX_lvalrem*(x: GEN; p: pari_ulong; px: ptr GEN): clong {.cdecl,
    importc: "ZX_lvalrem", dynlib: libname.}
proc ZX_lval*(x: GEN; p: pari_ulong): clong {.cdecl, importc: "ZX_lval", dynlib: libname.}
proc ZX_pval*(x: GEN; p: GEN): clong {.cdecl, importc: "ZX_pval", dynlib: libname.}
proc ZX_pvalrem*(x: GEN; p: GEN; px: ptr GEN): clong {.cdecl, importc: "ZX_pvalrem",
    dynlib: libname.}
proc Z_lval*(n: GEN; p: pari_ulong): clong {.cdecl, importc: "Z_lval", dynlib: libname.}
proc Z_lvalrem*(n: GEN; p: pari_ulong; py: ptr GEN): clong {.cdecl, importc: "Z_lvalrem",
    dynlib: libname.}
proc Z_lvalrem_stop*(n: ptr GEN; p: pari_ulong; stop: ptr cint): clong {.cdecl,
    importc: "Z_lvalrem_stop", dynlib: libname.}
proc Z_pval*(n: GEN; p: GEN): clong {.cdecl, importc: "Z_pval", dynlib: libname.}
proc Z_pvalrem*(x: GEN; p: GEN; py: ptr GEN): clong {.cdecl, importc: "Z_pvalrem",
    dynlib: libname.}
proc cgetp*(x: GEN): GEN {.cdecl, importc: "cgetp", dynlib: libname.}
proc cvstop2*(s: clong; y: GEN): GEN {.cdecl, importc: "cvstop2", dynlib: libname.}
proc cvtop*(x: GEN; p: GEN; par_l: clong): GEN {.cdecl, importc: "cvtop", dynlib: libname.}
proc cvtop2*(x: GEN; y: GEN): GEN {.cdecl, importc: "cvtop2", dynlib: libname.}
proc gabs*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gabs", dynlib: libname.}
proc gaffect*(x: GEN; y: GEN) {.cdecl, importc: "gaffect", dynlib: libname.}
proc gaffsg*(s: clong; x: GEN) {.cdecl, importc: "gaffsg", dynlib: libname.}
proc gcmp*(x: GEN; y: GEN): cint {.cdecl, importc: "gcmp", dynlib: libname.}
proc gequal0*(x: GEN): cint {.cdecl, importc: "gequal0", dynlib: libname.}
proc gequal1*(x: GEN): cint {.cdecl, importc: "gequal1", dynlib: libname.}
proc gequalX*(x: GEN): cint {.cdecl, importc: "gequalX", dynlib: libname.}
proc gequalm1*(x: GEN): cint {.cdecl, importc: "gequalm1", dynlib: libname.}
proc gcmpsg*(x: clong; y: GEN): cint {.cdecl, importc: "gcmpsg", dynlib: libname.}
proc gcvtop*(x: GEN; p: GEN; r: clong): GEN {.cdecl, importc: "gcvtop", dynlib: libname.}
proc gequal*(x: GEN; y: GEN): cint {.cdecl, importc: "gequal", dynlib: libname.}
proc gequalsg*(s: clong; x: GEN): cint {.cdecl, importc: "gequalsg", dynlib: libname.}
proc gexpo*(x: GEN): clong {.cdecl, importc: "gexpo", dynlib: libname.}
proc gvaluation*(x: GEN; p: GEN): clong {.cdecl, importc: "gvaluation", dynlib: libname.}
proc gidentical*(x: GEN; y: GEN): cint {.cdecl, importc: "gidentical", dynlib: libname.}
proc glength*(x: GEN): clong {.cdecl, importc: "glength", dynlib: libname.}
proc gmax*(x: GEN; y: GEN): GEN {.cdecl, importc: "gmax", dynlib: libname.}
proc gmaxgs*(x: GEN; y: clong): GEN {.cdecl, importc: "gmaxgs", dynlib: libname.}
proc gmin*(x: GEN; y: GEN): GEN {.cdecl, importc: "gmin", dynlib: libname.}
proc gmings*(x: GEN; y: clong): GEN {.cdecl, importc: "gmings", dynlib: libname.}
proc gneg*(x: GEN): GEN {.cdecl, importc: "gneg", dynlib: libname.}
proc gneg_i*(x: GEN): GEN {.cdecl, importc: "gneg_i", dynlib: libname.}
proc RgX_to_ser*(x: GEN; par_l: clong): GEN {.cdecl, importc: "RgX_to_ser",
                                        dynlib: libname.}
proc RgX_to_ser_inexact*(x: GEN; par_l: clong): GEN {.cdecl,
    importc: "RgX_to_ser_inexact", dynlib: libname.}
proc gsigne*(x: GEN): cint {.cdecl, importc: "gsigne", dynlib: libname.}
proc gtolist*(x: GEN): GEN {.cdecl, importc: "gtolist", dynlib: libname.}
proc gtolong*(x: GEN): clong {.cdecl, importc: "gtolong", dynlib: libname.}
proc lexcmp*(x: GEN; y: GEN): cint {.cdecl, importc: "lexcmp", dynlib: libname.}
proc listinsert*(list: GEN; `object`: GEN; index: clong): GEN {.cdecl,
    importc: "listinsert", dynlib: libname.}
proc listpop*(L: GEN; index: clong) {.cdecl, importc: "listpop", dynlib: libname.}
proc listput*(list: GEN; `object`: GEN; index: clong): GEN {.cdecl, importc: "listput",
    dynlib: libname.}
proc listsort*(list: GEN; flag: clong) {.cdecl, importc: "listsort", dynlib: libname.}
proc matsize*(x: GEN): GEN {.cdecl, importc: "matsize", dynlib: libname.}
proc mklistcopy*(x: GEN): GEN {.cdecl, importc: "mklistcopy", dynlib: libname.}
proc normalize*(x: GEN): GEN {.cdecl, importc: "normalize", dynlib: libname.}
proc normalizepol*(x: GEN): GEN {.cdecl, importc: "normalizepol", dynlib: libname.}
proc normalizepol_approx*(x: GEN; lx: clong): GEN {.cdecl,
    importc: "normalizepol_approx", dynlib: libname.}
proc normalizepol_lg*(x: GEN; lx: clong): GEN {.cdecl, importc: "normalizepol_lg",
    dynlib: libname.}
proc padic_to_Fl*(x: GEN; p: pari_ulong): pari_ulong {.cdecl, importc: "padic_to_Fl",
    dynlib: libname.}
proc padic_to_Fp*(x: GEN; Y: GEN): GEN {.cdecl, importc: "padic_to_Fp", dynlib: libname.}
proc quadtofp*(x: GEN; par_l: clong): GEN {.cdecl, importc: "quadtofp", dynlib: libname.}
proc rfrac_to_ser*(x: GEN; par_l: clong): GEN {.cdecl, importc: "rfrac_to_ser",
    dynlib: libname.}
proc sizedigit*(x: GEN): clong {.cdecl, importc: "sizedigit", dynlib: libname.}
proc u_lval*(x: pari_ulong; p: pari_ulong): clong {.cdecl, importc: "u_lval",
    dynlib: libname.}
proc u_lvalrem*(x: pari_ulong; p: pari_ulong; py: ptr pari_ulong): clong {.cdecl,
    importc: "u_lvalrem", dynlib: libname.}
proc u_lvalrem_stop*(n: ptr pari_ulong; p: pari_ulong; stop: ptr cint): clong {.cdecl,
    importc: "u_lvalrem_stop", dynlib: libname.}
proc u_pval*(x: pari_ulong; p: GEN): clong {.cdecl, importc: "u_pval", dynlib: libname.}
proc u_pvalrem*(x: pari_ulong; p: GEN; py: ptr pari_ulong): clong {.cdecl,
    importc: "u_pvalrem", dynlib: libname.}
proc vecindexmax*(x: GEN): clong {.cdecl, importc: "vecindexmax", dynlib: libname.}
proc vecindexmin*(x: GEN): clong {.cdecl, importc: "vecindexmin", dynlib: libname.}
proc vecmax0*(x: GEN; pv: ptr GEN): GEN {.cdecl, importc: "vecmax0", dynlib: libname.}
proc vecmax*(x: GEN): GEN {.cdecl, importc: "vecmax", dynlib: libname.}
proc vecmin0*(x: GEN; pv: ptr GEN): GEN {.cdecl, importc: "vecmin0", dynlib: libname.}
proc vecmin*(x: GEN): GEN {.cdecl, importc: "vecmin", dynlib: libname.}
proc z_lval*(s: clong; p: pari_ulong): clong {.cdecl, importc: "z_lval", dynlib: libname.}
proc z_lvalrem*(s: clong; p: pari_ulong; py: ptr clong): clong {.cdecl,
    importc: "z_lvalrem", dynlib: libname.}
proc z_pval*(n: clong; p: GEN): clong {.cdecl, importc: "z_pval", dynlib: libname.}
proc z_pvalrem*(n: clong; p: GEN; py: ptr clong): clong {.cdecl, importc: "z_pvalrem",
    dynlib: libname.}
proc padic_to_Q*(x: GEN): GEN {.cdecl, importc: "padic_to_Q", dynlib: libname.}
proc padic_to_Q_shallow*(x: GEN): GEN {.cdecl, importc: "padic_to_Q_shallow",
                                    dynlib: libname.}
proc QpV_to_QV*(v: GEN): GEN {.cdecl, importc: "QpV_to_QV", dynlib: libname.}
proc RgM_mulreal*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgM_mulreal", dynlib: libname.}
proc RgX_RgM_eval_col*(x: GEN; M: GEN; c: clong): GEN {.cdecl,
    importc: "RgX_RgM_eval_col", dynlib: libname.}
proc RgX_deflate_max*(x0: GEN; m: ptr clong): GEN {.cdecl, importc: "RgX_deflate_max",
    dynlib: libname.}
proc RgX_integ*(x: GEN): GEN {.cdecl, importc: "RgX_integ", dynlib: libname.}
proc ceil_safe*(x: GEN): GEN {.cdecl, importc: "ceil_safe", dynlib: libname.}
proc ceilr*(x: GEN): GEN {.cdecl, importc: "ceilr", dynlib: libname.}
proc centerlift*(x: GEN): GEN {.cdecl, importc: "centerlift", dynlib: libname.}
proc centerlift0*(x: GEN; v: clong): GEN {.cdecl, importc: "centerlift0", dynlib: libname.}
proc compo*(x: GEN; n: clong): GEN {.cdecl, importc: "compo", dynlib: libname.}
proc deg1pol*(x1: GEN; x0: GEN; v: clong): GEN {.cdecl, importc: "deg1pol", dynlib: libname.}
proc deg1pol_shallow*(x1: GEN; x0: GEN; v: clong): GEN {.cdecl,
    importc: "deg1pol_shallow", dynlib: libname.}
proc degree*(x: GEN): clong {.cdecl, importc: "degree", dynlib: libname.}
proc denom*(x: GEN): GEN {.cdecl, importc: "denom", dynlib: libname.}
proc deriv*(x: GEN; v: clong): GEN {.cdecl, importc: "deriv", dynlib: libname.}
proc derivser*(x: GEN): GEN {.cdecl, importc: "derivser", dynlib: libname.}
proc diffop*(x: GEN; v: GEN; dv: GEN): GEN {.cdecl, importc: "diffop", dynlib: libname.}
proc diffop0*(x: GEN; v: GEN; dv: GEN; n: clong): GEN {.cdecl, importc: "diffop0",
    dynlib: libname.}
proc diviiround*(x: GEN; y: GEN): GEN {.cdecl, importc: "diviiround", dynlib: libname.}
proc divrem*(x: GEN; y: GEN; v: clong): GEN {.cdecl, importc: "divrem", dynlib: libname.}
proc floor_safe*(x: GEN): GEN {.cdecl, importc: "floor_safe", dynlib: libname.}
proc gceil*(x: GEN): GEN {.cdecl, importc: "gceil", dynlib: libname.}
proc gcvtoi*(x: GEN; e: ptr clong): GEN {.cdecl, importc: "gcvtoi", dynlib: libname.}
proc gdeflate*(x: GEN; v: clong; d: clong): GEN {.cdecl, importc: "gdeflate",
    dynlib: libname.}
proc gdivent*(x: GEN; y: GEN): GEN {.cdecl, importc: "gdivent", dynlib: libname.}
proc gdiventgs*(x: GEN; y: clong): GEN {.cdecl, importc: "gdiventgs", dynlib: libname.}
proc gdiventsg*(x: clong; y: GEN): GEN {.cdecl, importc: "gdiventsg", dynlib: libname.}
proc gdiventres*(x: GEN; y: GEN): GEN {.cdecl, importc: "gdiventres", dynlib: libname.}
proc gdivmod*(x: GEN; y: GEN; pr: ptr GEN): GEN {.cdecl, importc: "gdivmod", dynlib: libname.}
proc gdivround*(x: GEN; y: GEN): GEN {.cdecl, importc: "gdivround", dynlib: libname.}
proc gdvd*(x: GEN; y: GEN): cint {.cdecl, importc: "gdvd", dynlib: libname.}
proc geq*(x: GEN; y: GEN): GEN {.cdecl, importc: "geq", dynlib: libname.}
proc geval*(x: GEN): GEN {.cdecl, importc: "geval", dynlib: libname.}
proc gfloor*(x: GEN): GEN {.cdecl, importc: "gfloor", dynlib: libname.}
proc gtrunc2n*(x: GEN; s: clong): GEN {.cdecl, importc: "gtrunc2n", dynlib: libname.}
proc gfrac*(x: GEN): GEN {.cdecl, importc: "gfrac", dynlib: libname.}
proc gge*(x: GEN; y: GEN): GEN {.cdecl, importc: "gge", dynlib: libname.}
proc ggrando*(x: GEN; n: clong): GEN {.cdecl, importc: "ggrando", dynlib: libname.}
proc ggt*(x: GEN; y: GEN): GEN {.cdecl, importc: "ggt", dynlib: libname.}
proc gimag*(x: GEN): GEN {.cdecl, importc: "gimag", dynlib: libname.}
proc gle*(x: GEN; y: GEN): GEN {.cdecl, importc: "gle", dynlib: libname.}
proc glt*(x: GEN; y: GEN): GEN {.cdecl, importc: "glt", dynlib: libname.}
proc gmod*(x: GEN; y: GEN): GEN {.cdecl, importc: "gmod", dynlib: libname.}
proc gmodgs*(x: GEN; y: clong): GEN {.cdecl, importc: "gmodgs", dynlib: libname.}
proc gmodsg*(x: clong; y: GEN): GEN {.cdecl, importc: "gmodsg", dynlib: libname.}
proc gmodulo*(x: GEN; y: GEN): GEN {.cdecl, importc: "gmodulo", dynlib: libname.}
proc gmodulsg*(x: clong; y: GEN): GEN {.cdecl, importc: "gmodulsg", dynlib: libname.}
proc gmodulss*(x: clong; y: clong): GEN {.cdecl, importc: "gmodulss", dynlib: libname.}
proc gne*(x: GEN; y: GEN): GEN {.cdecl, importc: "gne", dynlib: libname.}
proc gnot*(x: GEN): GEN {.cdecl, importc: "gnot", dynlib: libname.}
proc gpolvar*(y: GEN): GEN {.cdecl, importc: "gpolvar", dynlib: libname.}
proc gprecision*(x: GEN): clong {.cdecl, importc: "gprecision", dynlib: libname.}
proc greal*(x: GEN): GEN {.cdecl, importc: "greal", dynlib: libname.}
proc grndtoi*(x: GEN; e: ptr clong): GEN {.cdecl, importc: "grndtoi", dynlib: libname.}
proc ground*(x: GEN): GEN {.cdecl, importc: "ground", dynlib: libname.}
proc gshift*(x: GEN; n: clong): GEN {.cdecl, importc: "gshift", dynlib: libname.}
proc gsubst*(x: GEN; v: clong; y: GEN): GEN {.cdecl, importc: "gsubst", dynlib: libname.}
proc gsubstpol*(x: GEN; v: GEN; y: GEN): GEN {.cdecl, importc: "gsubstpol", dynlib: libname.}
proc gsubstvec*(x: GEN; v: GEN; y: GEN): GEN {.cdecl, importc: "gsubstvec", dynlib: libname.}
proc gtocol*(x: GEN): GEN {.cdecl, importc: "gtocol", dynlib: libname.}
proc gtocol0*(x: GEN; n: clong): GEN {.cdecl, importc: "gtocol0", dynlib: libname.}
proc gtocolrev*(x: GEN): GEN {.cdecl, importc: "gtocolrev", dynlib: libname.}
proc gtocolrev0*(x: GEN; n: clong): GEN {.cdecl, importc: "gtocolrev0", dynlib: libname.}
proc gtopoly*(x: GEN; v: clong): GEN {.cdecl, importc: "gtopoly", dynlib: libname.}
proc gtopolyrev*(x: GEN; v: clong): GEN {.cdecl, importc: "gtopolyrev", dynlib: libname.}
proc gtoser*(x: GEN; v: clong; precdl: clong): GEN {.cdecl, importc: "gtoser",
    dynlib: libname.}
proc gtovec*(x: GEN): GEN {.cdecl, importc: "gtovec", dynlib: libname.}
proc gtovec0*(x: GEN; n: clong): GEN {.cdecl, importc: "gtovec0", dynlib: libname.}
proc gtovecrev*(x: GEN): GEN {.cdecl, importc: "gtovecrev", dynlib: libname.}
proc gtovecrev0*(x: GEN; n: clong): GEN {.cdecl, importc: "gtovecrev0", dynlib: libname.}
proc gtovecsmall*(x: GEN): GEN {.cdecl, importc: "gtovecsmall", dynlib: libname.}
proc gtovecsmall0*(x: GEN; n: clong): GEN {.cdecl, importc: "gtovecsmall0",
                                      dynlib: libname.}
proc gtrunc*(x: GEN): GEN {.cdecl, importc: "gtrunc", dynlib: libname.}
proc gvar*(x: GEN): clong {.cdecl, importc: "gvar", dynlib: libname.}
proc gvar2*(x: GEN): clong {.cdecl, importc: "gvar2", dynlib: libname.}
proc hqfeval*(q: GEN; x: GEN): GEN {.cdecl, importc: "hqfeval", dynlib: libname.}
proc imag_i*(x: GEN): GEN {.cdecl, importc: "imag_i", dynlib: libname.}
proc integ*(x: GEN; v: clong): GEN {.cdecl, importc: "integ", dynlib: libname.}
proc integser*(x: GEN): GEN {.cdecl, importc: "integser", dynlib: libname.}
proc iscomplex*(x: GEN): cint {.cdecl, importc: "iscomplex", dynlib: libname.}
proc isexactzero*(g: GEN): cint {.cdecl, importc: "isexactzero", dynlib: libname.}
proc isrationalzeroscalar*(g: GEN): cint {.cdecl, importc: "isrationalzeroscalar",
                                       dynlib: libname.}
proc isinexact*(x: GEN): cint {.cdecl, importc: "isinexact", dynlib: libname.}
proc isinexactreal*(x: GEN): cint {.cdecl, importc: "isinexactreal", dynlib: libname.}
proc isint*(n: GEN; ptk: ptr GEN): cint {.cdecl, importc: "isint", dynlib: libname.}
proc isrationalzero*(g: GEN): cint {.cdecl, importc: "isrationalzero", dynlib: libname.}
proc issmall*(n: GEN; ptk: ptr clong): cint {.cdecl, importc: "issmall", dynlib: libname.}
proc lift*(x: GEN): GEN {.cdecl, importc: "lift", dynlib: libname.}
proc lift0*(x: GEN; v: clong): GEN {.cdecl, importc: "lift0", dynlib: libname.}
proc liftall*(x: GEN): GEN {.cdecl, importc: "liftall", dynlib: libname.}
proc liftall_shallow*(x: GEN): GEN {.cdecl, importc: "liftall_shallow", dynlib: libname.}
proc liftint*(x: GEN): GEN {.cdecl, importc: "liftint", dynlib: libname.}
proc liftint_shallow*(x: GEN): GEN {.cdecl, importc: "liftint_shallow", dynlib: libname.}
proc liftpol*(x: GEN): GEN {.cdecl, importc: "liftpol", dynlib: libname.}
proc liftpol_shallow*(x: GEN): GEN {.cdecl, importc: "liftpol_shallow", dynlib: libname.}
proc mkcoln*(n: clong): GEN {.varargs, cdecl, importc: "mkcoln", dynlib: libname.}
proc mkintn*(n: clong): GEN {.varargs, cdecl, importc: "mkintn", dynlib: libname.}
proc mkpoln*(n: clong): GEN {.varargs, cdecl, importc: "mkpoln", dynlib: libname.}
proc mkvecn*(n: clong): GEN {.varargs, cdecl, importc: "mkvecn", dynlib: libname.}
proc mkvecsmalln*(n: clong): GEN {.varargs, cdecl, importc: "mkvecsmalln",
                               dynlib: libname.}
proc mulreal*(x: GEN; y: GEN): GEN {.cdecl, importc: "mulreal", dynlib: libname.}
proc numer*(x: GEN): GEN {.cdecl, importc: "numer", dynlib: libname.}
proc padicprec*(x: GEN; p: GEN): clong {.cdecl, importc: "padicprec", dynlib: libname.}
proc padicprec_relative*(x: GEN): clong {.cdecl, importc: "padicprec_relative",
                                      dynlib: libname.}
proc polcoeff0*(x: GEN; n: clong; v: clong): GEN {.cdecl, importc: "polcoeff0",
    dynlib: libname.}
proc polcoeff_i*(x: GEN; n: clong; v: clong): GEN {.cdecl, importc: "polcoeff_i",
    dynlib: libname.}
proc poldegree*(x: GEN; v: clong): clong {.cdecl, importc: "poldegree", dynlib: libname.}
proc RgX_degree*(x: GEN; v: clong): clong {.cdecl, importc: "RgX_degree", dynlib: libname.}
proc poleval*(x: GEN; y: GEN): GEN {.cdecl, importc: "poleval", dynlib: libname.}
proc pollead*(x: GEN; v: clong): GEN {.cdecl, importc: "pollead", dynlib: libname.}
proc precision*(x: GEN): clong {.cdecl, importc: "precision", dynlib: libname.}
proc precision0*(x: GEN; n: clong): GEN {.cdecl, importc: "precision0", dynlib: libname.}
proc qf_apply_RgM*(q: GEN; M: GEN): GEN {.cdecl, importc: "qf_apply_RgM", dynlib: libname.}
proc qf_apply_ZM*(q: GEN; M: GEN): GEN {.cdecl, importc: "qf_apply_ZM", dynlib: libname.}
proc qfbil*(x: GEN; y: GEN; q: GEN): GEN {.cdecl, importc: "qfbil", dynlib: libname.}
proc qfeval*(q: GEN; x: GEN): GEN {.cdecl, importc: "qfeval", dynlib: libname.}
proc qfevalb*(q: GEN; x: GEN; y: GEN): GEN {.cdecl, importc: "qfevalb", dynlib: libname.}
proc qfnorm*(x: GEN; q: GEN): GEN {.cdecl, importc: "qfnorm", dynlib: libname.}
proc real_i*(x: GEN): GEN {.cdecl, importc: "real_i", dynlib: libname.}
proc round0*(x: GEN; pte: ptr GEN): GEN {.cdecl, importc: "round0", dynlib: libname.}
proc roundr*(x: GEN): GEN {.cdecl, importc: "roundr", dynlib: libname.}
proc roundr_safe*(x: GEN): GEN {.cdecl, importc: "roundr_safe", dynlib: libname.}
proc scalarpol*(x: GEN; v: clong): GEN {.cdecl, importc: "scalarpol", dynlib: libname.}
proc scalarpol_shallow*(x: GEN; v: clong): GEN {.cdecl, importc: "scalarpol_shallow",
    dynlib: libname.}
proc scalarser*(x: GEN; v: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "scalarser",
    dynlib: libname.}
proc ser_unscale*(P: GEN; h: GEN): GEN {.cdecl, importc: "ser_unscale", dynlib: libname.}
proc serreverse*(x: GEN): GEN {.cdecl, importc: "serreverse", dynlib: libname.}
proc simplify*(x: GEN): GEN {.cdecl, importc: "simplify", dynlib: libname.}
proc simplify_shallow*(x: GEN): GEN {.cdecl, importc: "simplify_shallow",
                                  dynlib: libname.}
proc tayl*(x: GEN; v: clong; precdl: clong): GEN {.cdecl, importc: "tayl", dynlib: libname.}
proc toser_i*(x: GEN): GEN {.cdecl, importc: "toser_i", dynlib: libname.}
proc trunc0*(x: GEN; pte: ptr GEN): GEN {.cdecl, importc: "trunc0", dynlib: libname.}
proc uu32toi*(a: pari_ulong; b: pari_ulong): GEN {.cdecl, importc: "uu32toi",
    dynlib: libname.}
proc genus2red*(Q: GEN; P: GEN; p: GEN): GEN {.cdecl, importc: "genus2red", dynlib: libname.}
proc group_ident*(G: GEN; S: GEN): clong {.cdecl, importc: "group_ident", dynlib: libname.}
proc group_ident_trans*(G: GEN; S: GEN): clong {.cdecl, importc: "group_ident_trans",
    dynlib: libname.}
proc hash_create*(minsize: pari_ulong;
                 hash: proc (a2: pointer): pari_ulong {.cdecl.};
                 eq: proc (a2: pointer; a3: pointer): cint {.cdecl.}; use_stack: cint): ptr hashtable {.
    cdecl, importc: "hash_create", dynlib: libname.}
proc hash_insert*(h: ptr hashtable; k: pointer; v: pointer) {.cdecl,
    importc: "hash_insert", dynlib: libname.}
proc hash_search*(h: ptr hashtable; k: pointer): ptr hashentry {.cdecl,
    importc: "hash_search", dynlib: libname.}
proc hash_remove*(h: ptr hashtable; k: pointer): ptr hashentry {.cdecl,
    importc: "hash_remove", dynlib: libname.}
proc hash_destroy*(h: ptr hashtable) {.cdecl, importc: "hash_destroy", dynlib: libname.}
proc hash_str*(str: cstring): pari_ulong {.cdecl, importc: "hash_str", dynlib: libname.}
proc hash_str2*(s: cstring): pari_ulong {.cdecl, importc: "hash_str2", dynlib: libname.}
proc hash_GEN*(x: GEN): pari_ulong {.cdecl, importc: "hash_GEN", dynlib: libname.}
proc Frobeniusform*(V: GEN; n: clong): GEN {.cdecl, importc: "Frobeniusform",
                                       dynlib: libname.}
proc RgM_hnfall*(A: GEN; pB: ptr GEN; remove: clong): GEN {.cdecl, importc: "RgM_hnfall",
    dynlib: libname.}
proc ZM_hnf*(x: GEN): GEN {.cdecl, importc: "ZM_hnf", dynlib: libname.}
proc ZM_hnfall*(A: GEN; ptB: ptr GEN; remove: clong): GEN {.cdecl, importc: "ZM_hnfall",
    dynlib: libname.}
proc ZM_hnfcenter*(M: GEN): GEN {.cdecl, importc: "ZM_hnfcenter", dynlib: libname.}
proc ZM_hnflll*(A: GEN; ptB: ptr GEN; remove: cint): GEN {.cdecl, importc: "ZM_hnflll",
    dynlib: libname.}
proc ZV_gcdext*(A: GEN): GEN {.cdecl, importc: "ZV_gcdext", dynlib: libname.}
proc ZM_hnfmod*(x: GEN; d: GEN): GEN {.cdecl, importc: "ZM_hnfmod", dynlib: libname.}
proc ZM_hnfmodall*(x: GEN; dm: GEN; flag: clong): GEN {.cdecl, importc: "ZM_hnfmodall",
    dynlib: libname.}
proc ZM_hnfmodid*(x: GEN; d: GEN): GEN {.cdecl, importc: "ZM_hnfmodid", dynlib: libname.}
proc ZM_hnfperm*(A: GEN; ptU: ptr GEN; ptperm: ptr GEN): GEN {.cdecl,
    importc: "ZM_hnfperm", dynlib: libname.}
proc ZM_snfclean*(d: GEN; u: GEN; v: GEN) {.cdecl, importc: "ZM_snfclean", dynlib: libname.}
proc ZM_snf*(x: GEN): GEN {.cdecl, importc: "ZM_snf", dynlib: libname.}
proc ZM_snf_group*(H: GEN; newU: ptr GEN; newUi: ptr GEN): GEN {.cdecl,
    importc: "ZM_snf_group", dynlib: libname.}
proc ZM_snfall*(x: GEN; ptU: ptr GEN; ptV: ptr GEN): GEN {.cdecl, importc: "ZM_snfall",
    dynlib: libname.}
proc ZM_snfall_i*(x: GEN; ptU: ptr GEN; ptV: ptr GEN; return_vec: cint): GEN {.cdecl,
    importc: "ZM_snfall_i", dynlib: libname.}
proc zlm_echelon*(x: GEN; early_abort: clong; p: pari_ulong; pm: pari_ulong): GEN {.cdecl,
    importc: "zlm_echelon", dynlib: libname.}
proc ZpM_echelon*(x: GEN; early_abort: clong; p: GEN; pm: GEN): GEN {.cdecl,
    importc: "ZpM_echelon", dynlib: libname.}
proc gsmith*(x: GEN): GEN {.cdecl, importc: "gsmith", dynlib: libname.}
proc gsmithall*(x: GEN): GEN {.cdecl, importc: "gsmithall", dynlib: libname.}
proc hnf*(x: GEN): GEN {.cdecl, importc: "hnf", dynlib: libname.}
proc hnf_divscale*(A: GEN; B: GEN; t: GEN): GEN {.cdecl, importc: "hnf_divscale",
    dynlib: libname.}
proc hnf_solve*(A: GEN; B: GEN): GEN {.cdecl, importc: "hnf_solve", dynlib: libname.}
proc hnf_invimage*(A: GEN; b: GEN): GEN {.cdecl, importc: "hnf_invimage", dynlib: libname.}
proc hnfall*(x: GEN): GEN {.cdecl, importc: "hnfall", dynlib: libname.}
proc hnfdivide*(A: GEN; B: GEN): cint {.cdecl, importc: "hnfdivide", dynlib: libname.}
proc hnflll*(x: GEN): GEN {.cdecl, importc: "hnflll", dynlib: libname.}
proc hnfmerge_get_1*(A: GEN; B: GEN): GEN {.cdecl, importc: "hnfmerge_get_1",
                                      dynlib: libname.}
proc hnfmod*(x: GEN; d: GEN): GEN {.cdecl, importc: "hnfmod", dynlib: libname.}

proc hnfmodi1d*(x: GEN; p: GEN): GEN {.cdecl, importc: "hnfmodid", dynlib: libname.}
proc hnfperm*(x: GEN): GEN {.cdecl, importc: "hnfperm", dynlib: libname.}
proc matfrobenius*(M: GEN; flag: clong; v: clong): GEN {.cdecl, importc: "matfrobenius",
    dynlib: libname.}
proc mathnf0*(x: GEN; flag: clong): GEN {.cdecl, importc: "mathnf0", dynlib: libname.}
proc matsnf0*(x: GEN; flag: clong): GEN {.cdecl, importc: "matsnf0", dynlib: libname.}
proc smith*(x: GEN): GEN {.cdecl, importc: "smith", dynlib: libname.}
proc smithall*(x: GEN): GEN {.cdecl, importc: "smithall", dynlib: libname.}
proc smithclean*(z: GEN): GEN {.cdecl, importc: "smithclean", dynlib: libname.}
proc Z_factor*(n: GEN): GEN {.cdecl, importc: "Z_factor", dynlib: libname.}
proc Z_factor_limit*(n: GEN; all: pari_ulong): GEN {.cdecl, importc: "Z_factor_limit",
    dynlib: libname.}
proc Z_factor_until*(n: GEN; limit: GEN): GEN {.cdecl, importc: "Z_factor_until",
    dynlib: libname.}
proc Z_issmooth*(m: GEN; lim: pari_ulong): clong {.cdecl, importc: "Z_issmooth",
    dynlib: libname.}
proc Z_issmooth_fact*(m: GEN; lim: pari_ulong): GEN {.cdecl,
    importc: "Z_issmooth_fact", dynlib: libname.}
proc Z_issquarefree*(x: GEN): clong {.cdecl, importc: "Z_issquarefree", dynlib: libname.}
proc absi_factor*(n: GEN): GEN {.cdecl, importc: "absi_factor", dynlib: libname.}
proc absi_factor_limit*(n: GEN; all: pari_ulong): GEN {.cdecl,
    importc: "absi_factor_limit", dynlib: libname.}
proc bigomega*(n: GEN): clong {.cdecl, importc: "bigomega", dynlib: libname.}
proc core*(n: GEN): GEN {.cdecl, importc: "core", dynlib: libname.}
proc coreu*(n: pari_ulong): pari_ulong {.cdecl, importc: "coreu", dynlib: libname.}
proc eulerphi*(n: GEN): GEN {.cdecl, importc: "eulerphi", dynlib: libname.}
proc eulerphiu*(n: pari_ulong): pari_ulong {.cdecl, importc: "eulerphiu",
    dynlib: libname.}
proc eulerphiu_fact*(f: GEN): pari_ulong {.cdecl, importc: "eulerphiu_fact",
                                       dynlib: libname.}
proc factorint*(n: GEN; flag: clong): GEN {.cdecl, importc: "factorint", dynlib: libname.}
proc factoru*(n: pari_ulong): GEN {.cdecl, importc: "factoru", dynlib: libname.}
proc ifac_isprime*(x: GEN): cint {.cdecl, importc: "ifac_isprime", dynlib: libname.}
proc ifac_next*(part: ptr GEN; p: ptr GEN; e: ptr clong): cint {.cdecl,
    importc: "ifac_next", dynlib: libname.}
proc ifac_read*(part: GEN; p: ptr GEN; e: ptr clong): cint {.cdecl, importc: "ifac_read",
    dynlib: libname.}
proc ifac_skip*(part: GEN) {.cdecl, importc: "ifac_skip", dynlib: libname.}
proc ifac_start*(n: GEN; moebius: cint): GEN {.cdecl, importc: "ifac_start",
    dynlib: libname.}
proc is_357_power*(x: GEN; pt: ptr GEN; mask: ptr pari_ulong): cint {.cdecl,
    importc: "is_357_power", dynlib: libname.}
proc is_pth_power*(x: GEN; pt: ptr GEN; T: ptr forprime_t; cutoffbits: pari_ulong): cint {.
    cdecl, importc: "is_pth_power", dynlib: libname.}
proc ispowerful*(n: GEN): clong {.cdecl, importc: "ispowerful", dynlib: libname.}
proc issquarefree*(x: GEN): clong {.cdecl, importc: "issquarefree", dynlib: libname.}
proc istotient*(n: GEN; px: ptr GEN): clong {.cdecl, importc: "istotient", dynlib: libname.}
proc moebius*(n: GEN): clong {.cdecl, importc: "moebius", dynlib: libname.}
proc moebiusu*(n: pari_ulong): clong {.cdecl, importc: "moebiusu", dynlib: libname.}
proc nextprime*(n: GEN): GEN {.cdecl, importc: "nextprime", dynlib: libname.}
proc numdiv*(n: GEN): GEN {.cdecl, importc: "numdiv", dynlib: libname.}
proc omega*(n: GEN): clong {.cdecl, importc: "omega", dynlib: libname.}
proc precprime*(n: GEN): GEN {.cdecl, importc: "precprime", dynlib: libname.}
proc sumdiv*(n: GEN): GEN {.cdecl, importc: "sumdiv", dynlib: libname.}
proc sumdivk*(n: GEN; k: clong): GEN {.cdecl, importc: "sumdivk", dynlib: libname.}
proc tridiv_bound*(n: GEN): pari_ulong {.cdecl, importc: "tridiv_bound",
                                     dynlib: libname.}
proc uis_357_power*(x: pari_ulong; pt: ptr pari_ulong; mask: ptr pari_ulong): cint {.
    cdecl, importc: "uis_357_power", dynlib: libname.}
proc uis_357_powermod*(x: pari_ulong; mask: ptr pari_ulong): cint {.cdecl,
    importc: "uis_357_powermod", dynlib: libname.}
proc uissquarefree*(n: pari_ulong): clong {.cdecl, importc: "uissquarefree",
                                        dynlib: libname.}
proc uissquarefree_fact*(f: GEN): clong {.cdecl, importc: "uissquarefree_fact",
                                      dynlib: libname.}
proc unextprime*(n: pari_ulong): pari_ulong {.cdecl, importc: "unextprime",
    dynlib: libname.}
proc uprecprime*(n: pari_ulong): pari_ulong {.cdecl, importc: "uprecprime",
    dynlib: libname.}
proc usumdivkvec*(n: pari_ulong; K: GEN): GEN {.cdecl, importc: "usumdivkvec",
    dynlib: libname.}
proc allocatemem*(newsize: pari_ulong) {.cdecl, importc: "allocatemem",
                                      dynlib: libname.}
proc timer_delay*(T: ptr pari_timer): clong {.cdecl, importc: "timer_delay",
    dynlib: libname.}
proc timer_get*(T: ptr pari_timer): clong {.cdecl, importc: "timer_get", dynlib: libname.}
proc timer_start*(T: ptr pari_timer) {.cdecl, importc: "timer_start", dynlib: libname.}
proc chk_gerepileupto*(x: GEN): cint {.cdecl, importc: "chk_gerepileupto",
                                   dynlib: libname.}
proc copy_bin*(x: GEN): ptr GENbin {.cdecl, importc: "copy_bin", dynlib: libname.}
proc copy_bin_canon*(x: GEN): ptr GENbin {.cdecl, importc: "copy_bin_canon",
                                      dynlib: libname.}
proc dbg_gerepile*(av: pari_sp) {.cdecl, importc: "dbg_gerepile", dynlib: libname.}
proc dbg_gerepileupto*(q: GEN) {.cdecl, importc: "dbg_gerepileupto", dynlib: libname.}
proc errname*(err: GEN): GEN {.cdecl, importc: "errname", dynlib: libname.}
proc gclone*(x: GEN): GEN {.cdecl, importc: "gclone", dynlib: libname.}
proc gcloneref*(x: GEN): GEN {.cdecl, importc: "gcloneref", dynlib: libname.}
proc gclone_refc*(x: GEN) {.cdecl, importc: "gclone_refc", dynlib: libname.}
proc gcopy*(x: GEN): GEN {.cdecl, importc: "gcopy", dynlib: libname.}
proc gcopy_avma*(x: GEN; AVMA: ptr pari_sp): GEN {.cdecl, importc: "gcopy_avma",
    dynlib: libname.}
proc gcopy_lg*(x: GEN; lx: clong): GEN {.cdecl, importc: "gcopy_lg", dynlib: libname.}
proc gerepile*(ltop: pari_sp; lbot: pari_sp; q: GEN): GEN {.cdecl, importc: "gerepile",
    dynlib: libname.}
proc gerepileallsp*(av: pari_sp; tetpil: pari_sp; n: cint) {.varargs, cdecl,
    importc: "gerepileallsp", dynlib: libname.}
proc gerepilecoeffssp*(av: pari_sp; tetpil: pari_sp; g: ptr clong; n: cint) {.cdecl,
    importc: "gerepilecoeffssp", dynlib: libname.}
proc gerepilemanysp*(av: pari_sp; tetpil: pari_sp; g: ptr ptr GEN; n: cint) {.cdecl,
    importc: "gerepilemanysp", dynlib: libname.}
proc getheap*(): GEN {.cdecl, importc: "getheap", dynlib: libname.}
proc gp_context_save*(rec: ptr gp_context) {.cdecl, importc: "gp_context_save",
    dynlib: libname.}
proc gp_context_restore*(rec: ptr gp_context) {.cdecl, importc: "gp_context_restore",
    dynlib: libname.}
proc gsizeword*(x: GEN): clong {.cdecl, importc: "gsizeword", dynlib: libname.}
proc gsizebyte*(x: GEN): clong {.cdecl, importc: "gsizebyte", dynlib: libname.}
proc gunclone*(x: GEN) {.cdecl, importc: "gunclone", dynlib: libname.}
proc gunclone_deep*(x: GEN) {.cdecl, importc: "gunclone_deep", dynlib: libname.}
proc listcopy*(x: GEN): GEN {.cdecl, importc: "listcopy", dynlib: libname.}
proc timer_printf*(T: ptr pari_timer; format: cstring) {.varargs, cdecl,
    importc: "timer_printf", dynlib: libname.}
proc msgtimer*(format: cstring) {.varargs, cdecl, importc: "msgtimer", dynlib: libname.}
proc name_numerr*(s: cstring): clong {.cdecl, importc: "name_numerr", dynlib: libname.}
proc newblock*(n: csize): GEN {.cdecl, importc: "newblock", dynlib: libname.}
proc numerr_name*(errnum: clong): cstring {.cdecl, importc: "numerr_name",
                                        dynlib: libname.}
proc obj_check*(S: GEN; K: clong): GEN {.cdecl, importc: "obj_check", dynlib: libname.}
proc obj_checkbuild*(S: GEN; tag: clong; build: proc (a2: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "obj_checkbuild", dynlib: libname.}
proc obj_checkbuild_padicprec*(S: GEN; tag: clong;
                              build: proc (a2: GEN; a3: clong): GEN {.cdecl.};
                              prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "obj_checkbuild_padicprec", dynlib: libname.}
proc obj_checkbuild_prec*(S: GEN; tag: clong;
                         build: proc (a2: GEN; a3: clong): GEN {.cdecl.}; prec: clong=pari_default_prec): GEN {.
    cdecl, importc: "obj_checkbuild_prec", dynlib: libname.}
proc obj_free*(S: GEN) {.cdecl, importc: "obj_free", dynlib: libname.}
proc obj_init*(d: clong; n: clong): GEN {.cdecl, importc: "obj_init", dynlib: libname.}
proc obj_insert*(S: GEN; K: clong; O: GEN): GEN {.cdecl, importc: "obj_insert",
    dynlib: libname.}
proc obj_insert_shallow*(S: GEN; K: clong; O: GEN): GEN {.cdecl,
    importc: "obj_insert_shallow", dynlib: libname.}
proc pari_add_function*(ep: ptr entree) {.cdecl, importc: "pari_add_function",
                                      dynlib: libname.}
proc pari_add_module*(ep: ptr entree) {.cdecl, importc: "pari_add_module",
                                    dynlib: libname.}
proc pari_add_defaults_module*(ep: ptr entree) {.cdecl,
    importc: "pari_add_defaults_module", dynlib: libname.}
proc pari_add_oldmodule*(ep: ptr entree) {.cdecl, importc: "pari_add_oldmodule",
                                       dynlib: libname.}
proc pari_close*() {.cdecl, importc: "pari_close", dynlib: libname.}
proc pari_close_opts*(init_opts: pari_ulong) {.cdecl, importc: "pari_close_opts",
    dynlib: libname.}
proc pari_daemon*(): cint {.cdecl, importc: "pari_daemon", dynlib: libname.}

proc pari_err*(numerr: cint) {.varargs, cdecl, importc: "pari_err", dynlib: libname.}

proc pari_err_last*(): GEN {.cdecl, importc: "pari_err_last", dynlib: libname.}

proc pari_err2str*(err: GEN): cstring {.cdecl, importc: "pari_err2str", dynlib: libname.}
proc pari_init_opts*(parisize: csize; maxprime: pari_ulong; init_opts: pari_ulong) {.
    cdecl, importc: "pari_init_opts", dynlib: libname.}
proc pari_init*(parisize: csize; maxprime: pari_ulong) {.cdecl, importc: "pari_init",
    dynlib: libname.}
proc pari_stackcheck_init*(pari_stack_base: pointer) {.cdecl,
    importc: "pari_stackcheck_init", dynlib: libname.}
proc pari_sig_init*(f: proc (a2: cint) {.cdecl.}) {.cdecl, importc: "pari_sig_init",
    dynlib: libname.}
proc pari_thread_alloc*(t: ptr pari_thread; s: csize; arg: GEN) {.cdecl,
    importc: "pari_thread_alloc", dynlib: libname.}
proc pari_thread_close*() {.cdecl, importc: "pari_thread_close", dynlib: libname.}
proc pari_thread_free*(t: ptr pari_thread) {.cdecl, importc: "pari_thread_free",
    dynlib: libname.}
proc pari_thread_init*() {.cdecl, importc: "pari_thread_init", dynlib: libname.}
proc pari_thread_start*(t: ptr pari_thread): GEN {.cdecl,
    importc: "pari_thread_start", dynlib: libname.}
proc pari_version*(): GEN {.cdecl, importc: "pari_version", dynlib: libname.}
proc pari_warn*(numerr: cint) {.varargs, cdecl, importc: "pari_warn", dynlib: libname.}
proc trap0*(e: cstring; f: GEN; r: GEN): GEN {.cdecl, importc: "trap0", dynlib: libname.}
proc shiftaddress*(x: GEN; dec: clong) {.cdecl, importc: "shiftaddress", dynlib: libname.}
proc shiftaddress_canon*(x: GEN; dec: clong) {.cdecl, importc: "shiftaddress_canon",
    dynlib: libname.}
proc timer*(): clong {.cdecl, importc: "timer", dynlib: libname.}
proc timer2*(): clong {.cdecl, importc: "timer2", dynlib: libname.}
proc traverseheap*(f: proc (a2: GEN; a3: pointer) {.cdecl.}; data: pointer) {.cdecl,
    importc: "traverseheap", dynlib: libname.}
proc intcirc*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN; R: GEN;
             tab: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "intcirc", dynlib: libname.}
proc intfouriercos*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
                   b: GEN; x: GEN; tab: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "intfouriercos", dynlib: libname.}
proc intfourierexp*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
                   b: GEN; x: GEN; tab: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "intfourierexp", dynlib: libname.}
proc intfouriersin*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
                   b: GEN; x: GEN; tab: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "intfouriersin", dynlib: libname.}
proc intfuncinit*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
                 b: GEN; m: clong; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "intfuncinit", dynlib: libname.}
proc intlaplaceinv*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; sig: GEN;
                   x: GEN; tab: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "intlaplaceinv", dynlib: libname.}
proc intmellininv*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; sig: GEN;
                  x: GEN; tab: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "intmellininv",
    dynlib: libname.}
proc intmellininvshort*(sig: GEN; x: GEN; tab: GEN; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "intmellininvshort", dynlib: libname.}
proc intnum*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN; b: GEN;
            tab: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "intnum", dynlib: libname.}
proc intnuminit*(a: GEN; b: GEN; m: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "intnuminit", dynlib: libname.}
proc intnuminitgen*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
                   b: GEN; m: clong; flext: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "intnuminitgen", dynlib: libname.}
proc intnumromb*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
                b: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "intnumromb",
    dynlib: libname.}
proc intnumstep*(prec: clong=pari_default_prec): clong {.cdecl, importc: "intnumstep", dynlib: libname.}
proc sumnum*(E: pointer; f: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN; sig: GEN;
            tab: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "sumnum",
    dynlib: libname.}
proc sumnumalt*(E: pointer; f: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN; s: GEN;
               tab: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "sumnumalt",
    dynlib: libname.}
proc sumnuminit*(sig: GEN; m: clong; sgn: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "sumnuminit", dynlib: libname.}
proc padicfields0*(p: GEN; n: GEN; flag: clong): GEN {.cdecl, importc: "padicfields0",
    dynlib: libname.}
proc padicfields*(p: GEN; m: clong; d: clong; flag: clong): GEN {.cdecl,
    importc: "padicfields", dynlib: libname.}
proc rnfkummer*(bnr: GEN; subgroup: GEN; all: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "rnfkummer", dynlib: libname.}
proc ZM_lll_norms*(x: GEN; D: cdouble; flag: clong; B: ptr GEN): GEN {.cdecl,
    importc: "ZM_lll_norms", dynlib: libname.}
proc kerint*(x: GEN): GEN {.cdecl, importc: "kerint", dynlib: libname.}
proc lll*(x: GEN): GEN {.cdecl, importc: "lll", dynlib: libname.}
proc lllfp*(x: GEN; D: cdouble; flag: clong): GEN {.cdecl, importc: "lllfp",
    dynlib: libname.}
proc lllgen*(x: GEN): GEN {.cdecl, importc: "lllgen", dynlib: libname.}
proc lllgram*(x: GEN): GEN {.cdecl, importc: "lllgram", dynlib: libname.}
proc lllgramgen*(x: GEN): GEN {.cdecl, importc: "lllgramgen", dynlib: libname.}
proc lllgramint*(x: GEN): GEN {.cdecl, importc: "lllgramint", dynlib: libname.}
proc lllgramkerim*(x: GEN): GEN {.cdecl, importc: "lllgramkerim", dynlib: libname.}
proc lllgramkerimgen*(x: GEN): GEN {.cdecl, importc: "lllgramkerimgen", dynlib: libname.}
proc lllint*(x: GEN): GEN {.cdecl, importc: "lllint", dynlib: libname.}
proc lllintpartial*(mat: GEN): GEN {.cdecl, importc: "lllintpartial", dynlib: libname.}
proc lllintpartial_inplace*(mat: GEN): GEN {.cdecl, importc: "lllintpartial_inplace",
    dynlib: libname.}
proc lllkerim*(x: GEN): GEN {.cdecl, importc: "lllkerim", dynlib: libname.}
proc lllkerimgen*(x: GEN): GEN {.cdecl, importc: "lllkerimgen", dynlib: libname.}
proc matkerint0*(x: GEN; flag: clong): GEN {.cdecl, importc: "matkerint0",
                                       dynlib: libname.}
proc qflll0*(x: GEN; flag: clong): GEN {.cdecl, importc: "qflll0", dynlib: libname.}
proc qflllgram0*(x: GEN; flag: clong): GEN {.cdecl, importc: "qflllgram0",
                                       dynlib: libname.}
proc member_a1*(x: GEN): GEN {.cdecl, importc: "member_a1", dynlib: libname.}
proc member_a2*(x: GEN): GEN {.cdecl, importc: "member_a2", dynlib: libname.}
proc member_a3*(x: GEN): GEN {.cdecl, importc: "member_a3", dynlib: libname.}
proc member_a4*(x: GEN): GEN {.cdecl, importc: "member_a4", dynlib: libname.}
proc member_a6*(x: GEN): GEN {.cdecl, importc: "member_a6", dynlib: libname.}
proc member_area*(x: GEN): GEN {.cdecl, importc: "member_area", dynlib: libname.}
proc member_b2*(x: GEN): GEN {.cdecl, importc: "member_b2", dynlib: libname.}
proc member_b4*(x: GEN): GEN {.cdecl, importc: "member_b4", dynlib: libname.}
proc member_b6*(x: GEN): GEN {.cdecl, importc: "member_b6", dynlib: libname.}
proc member_b8*(x: GEN): GEN {.cdecl, importc: "member_b8", dynlib: libname.}
proc member_bid*(x: GEN): GEN {.cdecl, importc: "member_bid", dynlib: libname.}
proc member_bnf*(x: GEN): GEN {.cdecl, importc: "member_bnf", dynlib: libname.}
proc member_c4*(x: GEN): GEN {.cdecl, importc: "member_c4", dynlib: libname.}
proc member_c6*(x: GEN): GEN {.cdecl, importc: "member_c6", dynlib: libname.}
proc member_clgp*(x: GEN): GEN {.cdecl, importc: "member_clgp", dynlib: libname.}
proc member_codiff*(x: GEN): GEN {.cdecl, importc: "member_codiff", dynlib: libname.}
proc member_cyc*(clg: GEN): GEN {.cdecl, importc: "member_cyc", dynlib: libname.}
proc member_diff*(x: GEN): GEN {.cdecl, importc: "member_diff", dynlib: libname.}
proc member_disc*(x: GEN): GEN {.cdecl, importc: "member_disc", dynlib: libname.}
proc member_e*(x: GEN): GEN {.cdecl, importc: "member_e", dynlib: libname.}
proc member_eta*(x: GEN): GEN {.cdecl, importc: "member_eta", dynlib: libname.}
proc member_f*(x: GEN): GEN {.cdecl, importc: "member_f", dynlib: libname.}
proc member_fu*(x: GEN): GEN {.cdecl, importc: "member_fu", dynlib: libname.}
proc member_futu*(x: GEN): GEN {.cdecl, importc: "member_futu", dynlib: libname.}
proc member_gen*(x: GEN): GEN {.cdecl, importc: "member_gen", dynlib: libname.}
proc member_group*(x: GEN): GEN {.cdecl, importc: "member_group", dynlib: libname.}
proc member_index*(x: GEN): GEN {.cdecl, importc: "member_index", dynlib: libname.}
proc member_j*(x: GEN): GEN {.cdecl, importc: "member_j", dynlib: libname.}
proc member_mod*(x: GEN): GEN {.cdecl, importc: "member_mod", dynlib: libname.}
proc member_nf*(x: GEN): GEN {.cdecl, importc: "member_nf", dynlib: libname.}
proc member_no*(clg: GEN): GEN {.cdecl, importc: "member_no", dynlib: libname.}
proc member_omega*(x: GEN): GEN {.cdecl, importc: "member_omega", dynlib: libname.}
proc member_orders*(x: GEN): GEN {.cdecl, importc: "member_orders", dynlib: libname.}
proc member_p*(x: GEN): GEN {.cdecl, importc: "member_p", dynlib: libname.}
proc member_pol*(x: GEN): GEN {.cdecl, importc: "member_pol", dynlib: libname.}
proc member_polabs*(x: GEN): GEN {.cdecl, importc: "member_polabs", dynlib: libname.}
proc member_reg*(x: GEN): GEN {.cdecl, importc: "member_reg", dynlib: libname.}
proc member_r1*(x: GEN): GEN {.cdecl, importc: "member_r1", dynlib: libname.}
proc member_r2*(x: GEN): GEN {.cdecl, importc: "member_r2", dynlib: libname.}
proc member_roots*(x: GEN): GEN {.cdecl, importc: "member_roots", dynlib: libname.}
proc member_sign*(x: GEN): GEN {.cdecl, importc: "member_sign", dynlib: libname.}
proc member_t2*(x: GEN): GEN {.cdecl, importc: "member_t2", dynlib: libname.}
proc member_tate*(x: GEN): GEN {.cdecl, importc: "member_tate", dynlib: libname.}
proc member_tufu*(x: GEN): GEN {.cdecl, importc: "member_tufu", dynlib: libname.}
proc member_tu*(x: GEN): GEN {.cdecl, importc: "member_tu", dynlib: libname.}
proc member_zk*(x: GEN): GEN {.cdecl, importc: "member_zk", dynlib: libname.}
proc member_zkst*(bid: GEN): GEN {.cdecl, importc: "member_zkst", dynlib: libname.}
proc addmulii*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc: "addmulii", dynlib: libname.}
proc addmulii_inplace*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc: "addmulii_inplace",
    dynlib: libname.}
proc Fl_inv*(x: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc: "Fl_inv",
    dynlib: libname.}
proc Fl_invsafe*(x: pari_ulong; p: pari_ulong): pari_ulong {.cdecl,
    importc: "Fl_invsafe", dynlib: libname.}
proc Fp_ratlift*(x: GEN; m: GEN; amax: GEN; bmax: GEN; a: ptr GEN; b: ptr GEN): cint {.cdecl,
    importc: "Fp_ratlift", dynlib: libname.}
proc absi_cmp*(x: GEN; y: GEN): cint {.cdecl, importc: "absi_cmp", dynlib: libname.}
proc absi_equal*(x: GEN; y: GEN): cint {.cdecl, importc: "absi_equal", dynlib: libname.}
proc absr_cmp*(x: GEN; y: GEN): cint {.cdecl, importc: "absr_cmp", dynlib: libname.}
proc addii_sign*(x: GEN; sx: clong; y: GEN; sy: clong): GEN {.cdecl, importc: "addii_sign",
    dynlib: libname.}
proc addir_sign*(x: GEN; sx: clong; y: GEN; sy: clong): GEN {.cdecl, importc: "addir_sign",
    dynlib: libname.}
proc addrr_sign*(x: GEN; sx: clong; y: GEN; sy: clong): GEN {.cdecl, importc: "addrr_sign",
    dynlib: libname.}
proc addsi_sign*(x: clong; y: GEN; sy: clong): GEN {.cdecl, importc: "addsi_sign",
    dynlib: libname.}
proc addui_sign*(x: pari_ulong; y: GEN; sy: clong): GEN {.cdecl, importc: "addui_sign",
    dynlib: libname.}
proc addsr*(x: clong; y: GEN): GEN {.cdecl, importc: "addsr", dynlib: libname.}
proc addumului*(a: pari_ulong; b: pari_ulong; Y: GEN): GEN {.cdecl, importc: "addumului",
    dynlib: libname.}
proc affir*(x: GEN; y: GEN) {.cdecl, importc: "affir", dynlib: libname.}
proc affrr*(x: GEN; y: GEN) {.cdecl, importc: "affrr", dynlib: libname.}
proc bezout*(a: GEN; b: GEN; u: ptr GEN; v: ptr GEN): GEN {.cdecl, importc: "bezout",
    dynlib: libname.}
proc cbezout*(a: clong; b: clong; uu: ptr clong; vv: ptr clong): clong {.cdecl,
    importc: "cbezout", dynlib: libname.}
proc cmpii*(x: GEN; y: GEN): cint {.cdecl, importc: "cmpii", dynlib: libname.}
proc cmprr*(x: GEN; y: GEN): cint {.cdecl, importc: "cmprr", dynlib: libname.}
proc dblexpo*(x: cdouble): clong {.cdecl, importc: "dblexpo", dynlib: libname.}
proc dblmantissa*(x: cdouble): pari_ulong {.cdecl, importc: "dblmantissa",
                                        dynlib: libname.}
proc dbltor*(x: cdouble): GEN {.cdecl, importc: "dbltor", dynlib: libname.}
proc diviiexact*(x: GEN; y: GEN): GEN {.cdecl, importc: "diviiexact", dynlib: libname.}
proc divir*(x: GEN; y: GEN): GEN {.cdecl, importc: "divir", dynlib: libname.}
proc divis*(y: GEN; x: clong): GEN {.cdecl, importc: "divis", dynlib: libname.}
proc divis_rem*(x: GEN; y: clong; rem: ptr clong): GEN {.cdecl, importc: "divis_rem",
    dynlib: libname.}
proc diviu_rem*(y: GEN; x: pari_ulong; rem: ptr pari_ulong): GEN {.cdecl,
    importc: "diviu_rem", dynlib: libname.}
proc diviuuexact*(x: GEN; y: pari_ulong; z: pari_ulong): GEN {.cdecl,
    importc: "diviuuexact", dynlib: libname.}
proc diviuexact*(x: GEN; y: pari_ulong): GEN {.cdecl, importc: "diviuexact",
    dynlib: libname.}
proc divri*(x: GEN; y: GEN): GEN {.cdecl, importc: "divri", dynlib: libname.}
proc divrr*(x: GEN; y: GEN): GEN {.cdecl, importc: "divrr", dynlib: libname.}
proc divrs*(x: GEN; y: clong): GEN {.cdecl, importc: "divrs", dynlib: libname.}
proc divru*(x: GEN; y: pari_ulong): GEN {.cdecl, importc: "divru", dynlib: libname.}
proc divsi*(x: clong; y: GEN): GEN {.cdecl, importc: "divsi", dynlib: libname.}
proc divsr*(x: clong; y: GEN): GEN {.cdecl, importc: "divsr", dynlib: libname.}
proc divur*(x: pari_ulong; y: GEN): GEN {.cdecl, importc: "divur", dynlib: libname.}
proc dvmdii*(x: GEN; y: GEN; z: ptr GEN): GEN {.cdecl, importc: "dvmdii", dynlib: libname.}
proc equalii*(x: GEN; y: GEN): cint {.cdecl, importc: "equalii", dynlib: libname.}
proc equalrr*(x: GEN; y: GEN): cint {.cdecl, importc: "equalrr", dynlib: libname.}
proc floorr*(x: GEN): GEN {.cdecl, importc: "floorr", dynlib: libname.}
proc gcdii*(x: GEN; y: GEN): GEN {.cdecl, importc: "gcdii", dynlib: libname.}
proc int2n*(n: clong): GEN {.cdecl, importc: "int2n", dynlib: libname.}
proc int2u*(n: pari_ulong): GEN {.cdecl, importc: "int2u", dynlib: libname.}
proc int_normalize*(x: GEN; known_zero_words: clong): GEN {.cdecl,
    importc: "int_normalize", dynlib: libname.}
proc invmod*(a: GEN; b: GEN; res: ptr GEN): cint {.cdecl, importc: "invmod", dynlib: libname.}
proc invmod2BIL*(b: pari_ulong): pari_ulong {.cdecl, importc: "invmod2BIL",
    dynlib: libname.}
proc invr*(b: GEN): GEN {.cdecl, importc: "invr", dynlib: libname.}
proc mantissa_real*(x: GEN; e: ptr clong): GEN {.cdecl, importc: "mantissa_real",
    dynlib: libname.}
proc modii*(x: GEN; y: GEN): GEN {.cdecl, importc: "modii", dynlib: libname.}
proc modiiz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc: "modiiz", dynlib: libname.}
proc mulii*(x: GEN; y: GEN): GEN {.cdecl, importc: "mulii", dynlib: libname.}
proc mulir*(x: GEN; y: GEN): GEN {.cdecl, importc: "mulir", dynlib: libname.}
proc mulrr*(x: GEN; y: GEN): GEN {.cdecl, importc: "mulrr", dynlib: libname.}
proc mulsi*(x: clong; y: GEN): GEN {.cdecl, importc: "mulsi", dynlib: libname.}
proc mulsr*(x: clong; y: GEN): GEN {.cdecl, importc: "mulsr", dynlib: libname.}
proc mulss*(x: clong; y: clong): GEN {.cdecl, importc: "mulss", dynlib: libname.}
proc mului*(x: pari_ulong; y: GEN): GEN {.cdecl, importc: "mului", dynlib: libname.}
proc mulur*(x: pari_ulong; y: GEN): GEN {.cdecl, importc: "mulur", dynlib: libname.}
proc muluu*(x: pari_ulong; y: pari_ulong): GEN {.cdecl, importc: "muluu", dynlib: libname.}
proc muluui*(x: pari_ulong; y: pari_ulong; z: GEN): GEN {.cdecl, importc: "muluui",
    dynlib: libname.}
proc remi2n*(x: GEN; n: clong): GEN {.cdecl, importc: "remi2n", dynlib: libname.}
proc rtodbl*(x: GEN): cdouble {.cdecl, importc: "rtodbl", dynlib: libname.}
proc shifti*(x: GEN; n: clong): GEN {.cdecl, importc: "shifti", dynlib: libname.}
proc sqri*(x: GEN): GEN {.cdecl, importc: "sqri", dynlib: libname.}
proc sqrr*(x: GEN): GEN {.cdecl, importc: "sqrr", dynlib: libname.}
proc sqrs*(x: clong): GEN {.cdecl, importc: "sqrs", dynlib: libname.}
proc sqrtr_abs*(x: GEN): GEN {.cdecl, importc: "sqrtr_abs", dynlib: libname.}
proc sqrtremi*(S: GEN; R: ptr GEN): GEN {.cdecl, importc: "sqrtremi", dynlib: libname.}
proc sqru*(x: pari_ulong): GEN {.cdecl, importc: "sqru", dynlib: libname.}
proc subsr*(x: clong; y: GEN): GEN {.cdecl, importc: "subsr", dynlib: libname.}
proc truedvmdii*(x: GEN; y: GEN; z: ptr GEN): GEN {.cdecl, importc: "truedvmdii",
    dynlib: libname.}
proc truedvmdis*(x: GEN; y: clong; z: ptr GEN): GEN {.cdecl, importc: "truedvmdis",
    dynlib: libname.}
proc truedvmdsi*(x: clong; y: GEN; z: ptr GEN): GEN {.cdecl, importc: "truedvmdsi",
    dynlib: libname.}
proc trunc2nr*(x: GEN; n: clong): GEN {.cdecl, importc: "trunc2nr", dynlib: libname.}
proc mantissa2nr*(x: GEN; n: clong): GEN {.cdecl, importc: "mantissa2nr", dynlib: libname.}
proc truncr*(x: GEN): GEN {.cdecl, importc: "truncr", dynlib: libname.}
proc umodiu*(y: GEN; x: pari_ulong): pari_ulong {.cdecl, importc: "umodiu",
    dynlib: libname.}
proc vals*(x: pari_ulong): clong {.cdecl, importc: "vals", dynlib: libname.}
proc FpC_ratlift*(P: GEN; `mod`: GEN; amax: GEN; bmax: GEN; denom: GEN): GEN {.cdecl,
    importc: "FpC_ratlift", dynlib: libname.}
proc FpM_ratlift*(M: GEN; `mod`: GEN; amax: GEN; bmax: GEN; denom: GEN): GEN {.cdecl,
    importc: "FpM_ratlift", dynlib: libname.}
proc FpX_ratlift*(P: GEN; `mod`: GEN; amax: GEN; bmax: GEN; denom: GEN): GEN {.cdecl,
    importc: "FpX_ratlift", dynlib: libname.}
proc nffactor*(nf: GEN; x: GEN): GEN {.cdecl, importc: "nffactor", dynlib: libname.}
proc nffactormod*(nf: GEN; pol: GEN; pr: GEN): GEN {.cdecl, importc: "nffactormod",
    dynlib: libname.}
proc nfgcd*(P: GEN; Q: GEN; nf: GEN; den: GEN): GEN {.cdecl, importc: "nfgcd",
    dynlib: libname.}
proc nfgcd_all*(P: GEN; Q: GEN; T: GEN; den: GEN; Pnew: ptr GEN): GEN {.cdecl,
    importc: "nfgcd_all", dynlib: libname.}
proc nfroots*(nf: GEN; pol: GEN): GEN {.cdecl, importc: "nfroots", dynlib: libname.}
proc polfnf*(a: GEN; t: GEN): GEN {.cdecl, importc: "polfnf", dynlib: libname.}
proc rootsof1*(x: GEN): GEN {.cdecl, importc: "rootsof1", dynlib: libname.}
proc rootsof1_kannan*(nf: GEN): GEN {.cdecl, importc: "rootsof1_kannan",
                                  dynlib: libname.}
var paricfg_datadir* {.importc: "paricfg_datadir", dynlib: libname.}: cstring

var paricfg_version* {.importc: "paricfg_version", dynlib: libname.}: cstring

var paricfg_buildinfo* {.importc: "paricfg_buildinfo", dynlib: libname.}: cstring

var paricfg_version_code* {.importc: "paricfg_version_code", dynlib: libname.}: clong

var paricfg_vcsversion* {.importc: "paricfg_vcsversion", dynlib: libname.}: cstring

var paricfg_compiledate* {.importc: "paricfg_compiledate", dynlib: libname.}: cstring

var paricfg_mt_engine* {.importc: "paricfg_mt_engine", dynlib: libname.}: cstring

proc forpart*(E: pointer; call: proc (a2: pointer; a3: GEN): clong {.cdecl.}; k: clong;
             nbound: GEN; abound: GEN) {.cdecl, importc: "forpart", dynlib: libname.}
proc forpart_init*(T: ptr forpart_t; k: clong; abound: GEN; nbound: GEN) {.cdecl,
    importc: "forpart_init", dynlib: libname.}
proc forpart_next*(T: ptr forpart_t): GEN {.cdecl, importc: "forpart_next",
                                       dynlib: libname.}
proc forpart_prev*(T: ptr forpart_t): GEN {.cdecl, importc: "forpart_prev",
                                       dynlib: libname.}
proc numbpart*(x: GEN): GEN {.cdecl, importc: "numbpart", dynlib: libname.}
proc partitions*(k: clong; nbound: GEN; abound: GEN): GEN {.cdecl, importc: "partitions",
    dynlib: libname.}
proc abelian_group*(G: GEN): GEN {.cdecl, importc: "abelian_group", dynlib: libname.}
proc cyclicgroup*(g: GEN; s: clong): GEN {.cdecl, importc: "cyclicgroup", dynlib: libname.}
proc cyc_pow*(cyc: GEN; exp: clong): GEN {.cdecl, importc: "cyc_pow", dynlib: libname.}
proc cyc_pow_perm*(cyc: GEN; exp: clong): GEN {.cdecl, importc: "cyc_pow_perm",
    dynlib: libname.}
proc dicyclicgroup*(g1: GEN; g2: GEN; s1: clong; s2: clong): GEN {.cdecl,
    importc: "dicyclicgroup", dynlib: libname.}
proc group_abelianHNF*(G: GEN; L: GEN): GEN {.cdecl, importc: "group_abelianHNF",
                                        dynlib: libname.}
proc group_abelianSNF*(G: GEN; L: GEN): GEN {.cdecl, importc: "group_abelianSNF",
                                        dynlib: libname.}
proc group_domain*(G: GEN): clong {.cdecl, importc: "group_domain", dynlib: libname.}
proc group_elts*(G: GEN; n: clong): GEN {.cdecl, importc: "group_elts", dynlib: libname.}
proc group_export*(G: GEN; format: clong): GEN {.cdecl, importc: "group_export",
    dynlib: libname.}
proc group_isA4S4*(G: GEN): clong {.cdecl, importc: "group_isA4S4", dynlib: libname.}
proc group_isabelian*(G: GEN): clong {.cdecl, importc: "group_isabelian",
                                   dynlib: libname.}
proc group_leftcoset*(G: GEN; g: GEN): GEN {.cdecl, importc: "group_leftcoset",
                                       dynlib: libname.}
proc group_order*(G: GEN): clong {.cdecl, importc: "group_order", dynlib: libname.}
proc group_perm_normalize*(N: GEN; g: GEN): clong {.cdecl,
    importc: "group_perm_normalize", dynlib: libname.}
proc group_quotient*(G: GEN; H: GEN): GEN {.cdecl, importc: "group_quotient",
                                      dynlib: libname.}
proc group_rightcoset*(G: GEN; g: GEN): GEN {.cdecl, importc: "group_rightcoset",
                                        dynlib: libname.}
proc group_set*(G: GEN; n: clong): GEN {.cdecl, importc: "group_set", dynlib: libname.}
proc group_subgroup_isnormal*(G: GEN; H: GEN): clong {.cdecl,
    importc: "group_subgroup_isnormal", dynlib: libname.}
proc group_subgroups*(G: GEN): GEN {.cdecl, importc: "group_subgroups", dynlib: libname.}
proc groupelts_abelian_group*(S: GEN): GEN {.cdecl,
    importc: "groupelts_abelian_group", dynlib: libname.}
proc groupelts_center*(S: GEN): GEN {.cdecl, importc: "groupelts_center",
                                  dynlib: libname.}
proc groupelts_set*(G: GEN; n: clong): GEN {.cdecl, importc: "groupelts_set",
                                       dynlib: libname.}
proc perm_commute*(p: GEN; q: GEN): cint {.cdecl, importc: "perm_commute",
                                     dynlib: libname.}
proc perm_cycles*(v: GEN): GEN {.cdecl, importc: "perm_cycles", dynlib: libname.}
proc perm_order*(perm: GEN): clong {.cdecl, importc: "perm_order", dynlib: libname.}
proc perm_pow*(perm: GEN; exp: clong): GEN {.cdecl, importc: "perm_pow", dynlib: libname.}
proc quotient_group*(C: GEN; G: GEN): GEN {.cdecl, importc: "quotient_group",
                                      dynlib: libname.}
proc quotient_perm*(C: GEN; p: GEN): GEN {.cdecl, importc: "quotient_perm",
                                     dynlib: libname.}
proc quotient_subgroup_lift*(C: GEN; H: GEN; S: GEN): GEN {.cdecl,
    importc: "quotient_subgroup_lift", dynlib: libname.}
proc subgroups_tableset*(S: GEN; n: clong): GEN {.cdecl, importc: "subgroups_tableset",
    dynlib: libname.}
proc tableset_find_index*(tbl: GEN; set: GEN): clong {.cdecl,
    importc: "tableset_find_index", dynlib: libname.}
proc trivialgroup*(): GEN {.cdecl, importc: "trivialgroup", dynlib: libname.}
proc vecperm_orbits*(v: GEN; n: clong): GEN {.cdecl, importc: "vecperm_orbits",
                                        dynlib: libname.}
proc vec_insert*(v: GEN; n: clong; x: GEN): GEN {.cdecl, importc: "vec_insert",
    dynlib: libname.}
proc vec_is1to1*(v: GEN): cint {.cdecl, importc: "vec_is1to1", dynlib: libname.}
proc vec_isconst*(v: GEN): cint {.cdecl, importc: "vec_isconst", dynlib: libname.}
proc vecsmall_duplicate*(x: GEN): clong {.cdecl, importc: "vecsmall_duplicate",
                                      dynlib: libname.}
proc vecsmall_duplicate_sorted*(x: GEN): clong {.cdecl,
    importc: "vecsmall_duplicate_sorted", dynlib: libname.}
proc vecsmall_indexsort*(V: GEN): GEN {.cdecl, importc: "vecsmall_indexsort",
                                    dynlib: libname.}
proc vecsmall_sort*(V: GEN) {.cdecl, importc: "vecsmall_sort", dynlib: libname.}
proc vecsmall_uniq*(V: GEN): GEN {.cdecl, importc: "vecsmall_uniq", dynlib: libname.}
proc vecsmall_uniq_sorted*(V: GEN): GEN {.cdecl, importc: "vecsmall_uniq_sorted",
                                      dynlib: libname.}
proc vecvecsmall_indexsort*(x: GEN): GEN {.cdecl, importc: "vecvecsmall_indexsort",
                                       dynlib: libname.}
proc vecvecsmall_search*(x: GEN; y: GEN; flag: clong): clong {.cdecl,
    importc: "vecvecsmall_search", dynlib: libname.}
proc vecvecsmall_sort*(x: GEN): GEN {.cdecl, importc: "vecvecsmall_sort",
                                  dynlib: libname.}
proc vecvecsmall_sort_uniq*(x: GEN): GEN {.cdecl, importc: "vecvecsmall_sort_uniq",
                                       dynlib: libname.}
proc mt_broadcast*(code: GEN) {.cdecl, importc: "mt_broadcast", dynlib: libname.}
proc mt_sigint_block*() {.cdecl, importc: "mt_sigint_block", dynlib: libname.}
proc mt_sigint_unblock*() {.cdecl, importc: "mt_sigint_unblock", dynlib: libname.}
proc mt_queue_end*(pt: ptr pari_mt) {.cdecl, importc: "mt_queue_end", dynlib: libname.}
proc mt_queue_get*(pt: ptr pari_mt; jobid: ptr clong; pending: ptr clong): GEN {.cdecl,
    importc: "mt_queue_get", dynlib: libname.}
proc mt_queue_start*(pt: ptr pari_mt; worker: GEN) {.cdecl, importc: "mt_queue_start",
    dynlib: libname.}
proc mt_queue_submit*(pt: ptr pari_mt; jobid: clong; work: GEN) {.cdecl,
    importc: "mt_queue_submit", dynlib: libname.}
proc pari_mt_init*() {.cdecl, importc: "pari_mt_init", dynlib: libname.}
proc pari_mt_close*() {.cdecl, importc: "pari_mt_close", dynlib: libname.}
proc ZX_Zp_root*(f: GEN; a: GEN; p: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ZX_Zp_root",
    dynlib: libname.}
proc Zp_appr*(f: GEN; a: GEN): GEN {.cdecl, importc: "Zp_appr", dynlib: libname.}
proc factorpadic0*(f: GEN; p: GEN; r: clong; flag: clong): GEN {.cdecl,
    importc: "factorpadic0", dynlib: libname.}
proc factorpadic*(x: GEN; p: GEN; r: clong): GEN {.cdecl, importc: "factorpadic",
    dynlib: libname.}
proc gdeuc*(x: GEN; y: GEN): GEN {.cdecl, importc: "gdeuc", dynlib: libname.}
proc grem*(x: GEN; y: GEN): GEN {.cdecl, importc: "grem", dynlib: libname.}
proc padicappr*(f: GEN; a: GEN): GEN {.cdecl, importc: "padicappr", dynlib: libname.}
proc poldivrem*(x: GEN; y: GEN; pr: ptr GEN): GEN {.cdecl, importc: "poldivrem",
    dynlib: libname.}
proc rootpadic*(f: GEN; p: GEN; r: clong): GEN {.cdecl, importc: "rootpadic",
    dynlib: libname.}
proc rootpadicfast*(f: GEN; p: GEN; e: clong): GEN {.cdecl, importc: "rootpadicfast",
    dynlib: libname.}
proc Q_content*(x: GEN): GEN {.cdecl, importc: "Q_content", dynlib: libname.}
proc Q_denom*(x: GEN): GEN {.cdecl, importc: "Q_denom", dynlib: libname.}
proc Q_div_to_int*(x: GEN; c: GEN): GEN {.cdecl, importc: "Q_div_to_int", dynlib: libname.}
proc Q_gcd*(x: GEN; y: GEN): GEN {.cdecl, importc: "Q_gcd", dynlib: libname.}
proc Q_mul_to_int*(x: GEN; c: GEN): GEN {.cdecl, importc: "Q_mul_to_int", dynlib: libname.}
proc Q_muli_to_int*(x: GEN; d: GEN): GEN {.cdecl, importc: "Q_muli_to_int",
                                     dynlib: libname.}
proc Q_primitive_part*(x: GEN; ptc: ptr GEN): GEN {.cdecl, importc: "Q_primitive_part",
    dynlib: libname.}
proc Q_primpart*(x: GEN): GEN {.cdecl, importc: "Q_primpart", dynlib: libname.}
proc Q_remove_denom*(x: GEN; ptd: ptr GEN): GEN {.cdecl, importc: "Q_remove_denom",
    dynlib: libname.}
proc RgXQ_charpoly*(x: GEN; T: GEN; v: clong): GEN {.cdecl, importc: "RgXQ_charpoly",
    dynlib: libname.}
proc RgXQ_inv*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgXQ_inv", dynlib: libname.}
proc RgX_disc*(x: GEN): GEN {.cdecl, importc: "RgX_disc", dynlib: libname.}
proc RgX_extgcd*(x: GEN; y: GEN; U: ptr GEN; V: ptr GEN): GEN {.cdecl, importc: "RgX_extgcd",
    dynlib: libname.}
proc RgX_extgcd_simple*(a: GEN; b: GEN; pu: ptr GEN; pv: ptr GEN): GEN {.cdecl,
    importc: "RgX_extgcd_simple", dynlib: libname.}
proc RgX_gcd*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgX_gcd", dynlib: libname.}
proc RgX_gcd_simple*(x: GEN; y: GEN): GEN {.cdecl, importc: "RgX_gcd_simple",
                                      dynlib: libname.}
proc RgXQ_ratlift*(y: GEN; x: GEN; amax: clong; bmax: clong; P: ptr GEN; Q: ptr GEN): cint {.
    cdecl, importc: "RgXQ_ratlift", dynlib: libname.}
proc RgX_resultant_all*(P: GEN; Q: GEN; sol: ptr GEN): GEN {.cdecl,
    importc: "RgX_resultant_all", dynlib: libname.}
proc RgX_type*(x: GEN; ptp: ptr GEN; ptpol: ptr GEN; ptpa: ptr clong): clong {.cdecl,
    importc: "RgX_type", dynlib: libname.}
proc RgX_type_decode*(x: clong; t1: ptr clong; t2: ptr clong) {.cdecl,
    importc: "RgX_type_decode", dynlib: libname.}
proc RgX_type_is_composite*(t: clong): cint {.cdecl,
    importc: "RgX_type_is_composite", dynlib: libname.}
proc ZX_content*(x: GEN): GEN {.cdecl, importc: "ZX_content", dynlib: libname.}
proc centermod*(x: GEN; p: GEN): GEN {.cdecl, importc: "centermod", dynlib: libname.}
proc centermod_i*(x: GEN; p: GEN; ps2: GEN): GEN {.cdecl, importc: "centermod_i",
    dynlib: libname.}
proc centermodii*(x: GEN; p: GEN; po2: GEN): GEN {.cdecl, importc: "centermodii",
    dynlib: libname.}
proc content*(x: GEN): GEN {.cdecl, importc: "content", dynlib: libname.}
proc deg1_from_roots*(L: GEN; v: clong): GEN {.cdecl, importc: "deg1_from_roots",
    dynlib: libname.}
proc divide_conquer_assoc*(x: GEN; data: pointer; mul: proc (a2: pointer; a3: GEN; a4: GEN): GEN {.
    cdecl.}): GEN {.cdecl, importc: "divide_conquer_assoc", dynlib: libname.}
proc divide_conquer_prod*(x: GEN; mul: proc (a2: GEN; a3: GEN): GEN {.cdecl.}): GEN {.cdecl,
    importc: "divide_conquer_prod", dynlib: libname.}
proc factor*(x: GEN): GEN {.cdecl, importc: "factor", dynlib: libname.}
proc factor0*(x: GEN; flag: clong): GEN {.cdecl, importc: "factor0", dynlib: libname.}
proc factorback*(fa: GEN): GEN {.cdecl, importc: "factorback", dynlib: libname.}
proc factorback2*(fa: GEN; e: GEN): GEN {.cdecl, importc: "factorback2", dynlib: libname.}
proc famat_mul_shallow*(f: GEN; g: GEN): GEN {.cdecl, importc: "famat_mul_shallow",
    dynlib: libname.}
proc gbezout*(x: GEN; y: GEN; u: ptr GEN; v: ptr GEN): GEN {.cdecl, importc: "gbezout",
    dynlib: libname.}
proc gdivexact*(x: GEN; y: GEN): GEN {.cdecl, importc: "gdivexact", dynlib: libname.}
proc gen_factorback*(L: GEN; e: GEN; par_mul: proc (a2: pointer; a3: GEN; a4: GEN): GEN {.
    cdecl.}; par_pow: proc (a2: pointer; a3: GEN; a4: GEN): GEN {.cdecl.}; data: pointer): GEN {.
    cdecl, importc: "gen_factorback", dynlib: libname.}
proc ggcd*(x: GEN; y: GEN): GEN {.cdecl, importc: "ggcd", dynlib: libname.}
proc ggcd0*(x: GEN; y: GEN): GEN {.cdecl, importc: "ggcd0", dynlib: libname.}
proc ginvmod*(x: GEN; y: GEN): GEN {.cdecl, importc: "ginvmod", dynlib: libname.}
proc glcm*(x: GEN; y: GEN): GEN {.cdecl, importc: "glcm", dynlib: libname.}
proc glcm0*(x: GEN; y: GEN): GEN {.cdecl, importc: "glcm0", dynlib: libname.}
proc gp_factor0*(x: GEN; flag: GEN): GEN {.cdecl, importc: "gp_factor0", dynlib: libname.}
proc idealfactorback*(nf: GEN; L: GEN; e: GEN; red: cint): GEN {.cdecl,
    importc: "idealfactorback", dynlib: libname.}
proc isirreducible*(x: GEN): clong {.cdecl, importc: "isirreducible", dynlib: libname.}
proc newtonpoly*(x: GEN; p: GEN): GEN {.cdecl, importc: "newtonpoly", dynlib: libname.}
proc nffactorback*(nf: GEN; L: GEN; e: GEN): GEN {.cdecl, importc: "nffactorback",
    dynlib: libname.}
proc nfrootsQ*(x: GEN): GEN {.cdecl, importc: "nfrootsQ", dynlib: libname.}
proc poldisc0*(x: GEN; v: clong): GEN {.cdecl, importc: "poldisc0", dynlib: libname.}
proc polresultant0*(x: GEN; y: GEN; v: clong; flag: clong): GEN {.cdecl,
    importc: "polresultant0", dynlib: libname.}
proc polsym*(x: GEN; n: clong): GEN {.cdecl, importc: "polsym", dynlib: libname.}
proc primitive_part*(x: GEN; c: ptr GEN): GEN {.cdecl, importc: "primitive_part",
    dynlib: libname.}
proc primpart*(x: GEN): GEN {.cdecl, importc: "primpart", dynlib: libname.}
proc reduceddiscsmith*(pol: GEN): GEN {.cdecl, importc: "reduceddiscsmith",
                                    dynlib: libname.}
proc resultant2*(x: GEN; y: GEN): GEN {.cdecl, importc: "resultant2", dynlib: libname.}
proc resultant_all*(u: GEN; v: GEN; sol: ptr GEN): GEN {.cdecl, importc: "resultant_all",
    dynlib: libname.}
proc rnfcharpoly*(nf: GEN; T: GEN; alpha: GEN; v: clong): GEN {.cdecl,
    importc: "rnfcharpoly", dynlib: libname.}
proc roots_from_deg1*(x: GEN): GEN {.cdecl, importc: "roots_from_deg1", dynlib: libname.}
proc roots_to_pol*(a: GEN; v: clong): GEN {.cdecl, importc: "roots_to_pol",
                                      dynlib: libname.}
proc roots_to_pol_r1*(a: GEN; v: clong; r1: clong): GEN {.cdecl,
    importc: "roots_to_pol_r1", dynlib: libname.}
proc sturmpart*(x: GEN; a: GEN; b: GEN): clong {.cdecl, importc: "sturmpart",
    dynlib: libname.}
proc subresext*(x: GEN; y: GEN; U: ptr GEN; V: ptr GEN): GEN {.cdecl, importc: "subresext",
    dynlib: libname.}
proc sylvestermatrix*(x: GEN; y: GEN): GEN {.cdecl, importc: "sylvestermatrix",
                                       dynlib: libname.}
proc trivial_fact*(): GEN {.cdecl, importc: "trivial_fact", dynlib: libname.}
proc gcdext0*(x: GEN; y: GEN): GEN {.cdecl, importc: "gcdext0", dynlib: libname.}
proc polresultantext0*(x: GEN; y: GEN; v: clong): GEN {.cdecl,
    importc: "polresultantext0", dynlib: libname.}
proc polresultantext*(x: GEN; y: GEN): GEN {.cdecl, importc: "polresultantext",
                                       dynlib: libname.}
proc prime_fact*(x: GEN): GEN {.cdecl, importc: "prime_fact", dynlib: libname.}
proc Flx_FlxY_resultant*(a: GEN; b: GEN; pp: pari_ulong): GEN {.cdecl,
    importc: "Flx_FlxY_resultant", dynlib: libname.}
proc Flx_factorff_irred*(P: GEN; Q: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flx_factorff_irred", dynlib: libname.}
proc Flx_ffintersect*(P: GEN; Q: GEN; n: clong; par_l: pari_ulong; SP: ptr GEN; SQ: ptr GEN;
                     MA: GEN; MB: GEN) {.cdecl, importc: "Flx_ffintersect",
                                     dynlib: libname.}
proc Flx_ffisom*(P: GEN; Q: GEN; par_l: pari_ulong): GEN {.cdecl, importc: "Flx_ffisom",
    dynlib: libname.}
proc Flx_roots_naive*(f: GEN; p: pari_ulong): GEN {.cdecl, importc: "Flx_roots_naive",
    dynlib: libname.}
proc FlxX_resultant*(u: GEN; v: GEN; p: pari_ulong; sx: clong): GEN {.cdecl,
    importc: "FlxX_resultant", dynlib: libname.}
proc Flxq_ffisom_inv*(S: GEN; Tp: GEN; p: pari_ulong): GEN {.cdecl,
    importc: "Flxq_ffisom_inv", dynlib: libname.}
proc FpV_polint*(xa: GEN; ya: GEN; p: GEN; v: clong): GEN {.cdecl, importc: "FpV_polint",
    dynlib: libname.}
proc FpX_FpXY_resultant*(a: GEN; b0: GEN; p: GEN): GEN {.cdecl,
    importc: "FpX_FpXY_resultant", dynlib: libname.}
proc FpX_factorff_irred*(P: GEN; Q: GEN; p: GEN): GEN {.cdecl,
    importc: "FpX_factorff_irred", dynlib: libname.}
proc FpX_ffintersect*(P: GEN; Q: GEN; n: clong; pari_l: GEN; SP: ptr GEN; SQ: ptr GEN; MA: GEN;
                     MB: GEN) {.cdecl, importc: "FpX_ffintersect", dynlib: libname.}
proc FpX_ffisom*(P: GEN; Q: GEN; par1: GEN): GEN {.cdecl, importc: "FpX_ffisom",
    dynlib: libname.}
proc FpX_translate*(P: GEN; c: GEN; p: GEN): GEN {.cdecl, importc: "FpX_translate",
    dynlib: libname.}
proc FpXQ_ffisom_inv*(S: GEN; Tp: GEN; p: GEN): GEN {.cdecl, importc: "FpXQ_ffisom_inv",
    dynlib: libname.}
proc FpXV_FpC_mul*(V: GEN; W: GEN; p: GEN): GEN {.cdecl, importc: "FpXV_FpC_mul",
    dynlib: libname.}
proc FpXY_Fq_evaly*(Q: GEN; y: GEN; T: GEN; p: GEN; vx: clong): GEN {.cdecl,
    importc: "FpXY_Fq_evaly", dynlib: libname.}
proc Fq_Fp_mul*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_Fp_mul",
    dynlib: libname.}
proc Fq_add*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_add", dynlib: libname.}
proc Fq_div*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_div", dynlib: libname.}
proc Fq_inv*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_inv", dynlib: libname.}
proc Fq_invsafe*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_invsafe",
                                        dynlib: libname.}
proc Fq_mul*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_mul", dynlib: libname.}
proc Fq_mulu*(x: GEN; y: pari_ulong; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_mulu",
    dynlib: libname.}
proc Fq_neg*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_neg", dynlib: libname.}
proc Fq_neg_inv*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_neg_inv",
                                        dynlib: libname.}
proc Fq_pow*(x: GEN; n: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_pow", dynlib: libname.}
proc Fq_powu*(x: GEN; n: pari_ulong; pol: GEN; p: GEN): GEN {.cdecl, importc: "Fq_powu",
    dynlib: libname.}
proc Fq_sub*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_sub", dynlib: libname.}
proc Fq_sqr*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_sqr", dynlib: libname.}
proc Fq_sqrt*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Fq_sqrt", dynlib: libname.}
proc Fq_sqrtn*(x: GEN; n: GEN; T: GEN; p: GEN; zeta: ptr GEN): GEN {.cdecl,
    importc: "Fq_sqrtn", dynlib: libname.}
proc FqC_add*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqC_add",
    dynlib: libname.}
proc FqC_sub*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqC_sub",
    dynlib: libname.}
proc FqC_Fq_mul*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqC_Fq_mul",
    dynlib: libname.}
proc FqC_to_FlxC*(v: GEN; T: GEN; pp: GEN): GEN {.cdecl, importc: "FqC_to_FlxC",
    dynlib: libname.}
proc FqM_to_FlxM*(x: GEN; T: GEN; pp: GEN): GEN {.cdecl, importc: "FqM_to_FlxM",
    dynlib: libname.}
proc FqV_roots_to_pol*(V: GEN; T: GEN; p: GEN; v: clong): GEN {.cdecl,
    importc: "FqV_roots_to_pol", dynlib: libname.}
proc FqV_red*(z: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqV_red", dynlib: libname.}
proc FqV_to_FlxV*(v: GEN; T: GEN; pp: GEN): GEN {.cdecl, importc: "FqV_to_FlxV",
    dynlib: libname.}
proc FqX_Fq_add*(y: GEN; x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqX_Fq_add",
    dynlib: libname.}
proc FqX_Fq_mul_to_monic*(P: GEN; U: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FqX_Fq_mul_to_monic", dynlib: libname.}
proc FqX_eval*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqX_eval",
    dynlib: libname.}
proc FqX_normalize*(z: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqX_normalize",
    dynlib: libname.}
proc FqX_translate*(P: GEN; c: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqX_translate",
    dynlib: libname.}
proc FqXQ_powers*(x: GEN; par_l: clong; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FqXQ_powers", dynlib: libname.}
proc FqXQ_matrix_pow*(y: GEN; n: clong; m: clong; S: GEN; T: GEN; p: GEN): GEN {.cdecl,
    importc: "FqXQ_matrix_pow", dynlib: libname.}
proc FqXY_eval*(Q: GEN; y: GEN; x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqXY_eval",
    dynlib: libname.}
proc FqXY_evalx*(Q: GEN; x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "FqXY_evalx",
    dynlib: libname.}
proc QX_disc*(x: GEN): GEN {.cdecl, importc: "QX_disc", dynlib: libname.}
proc QX_gcd*(a: GEN; b: GEN): GEN {.cdecl, importc: "QX_gcd", dynlib: libname.}
proc QX_resultant*(A: GEN; B: GEN): GEN {.cdecl, importc: "QX_resultant", dynlib: libname.}
proc QXQ_intnorm*(A: GEN; B: GEN): GEN {.cdecl, importc: "QXQ_intnorm", dynlib: libname.}
proc QXQ_inv*(A: GEN; B: GEN): GEN {.cdecl, importc: "QXQ_inv", dynlib: libname.}
proc QXQ_norm*(A: GEN; B: GEN): GEN {.cdecl, importc: "QXQ_norm", dynlib: libname.}
proc Rg_is_Fp*(x: GEN; p: ptr GEN): cint {.cdecl, importc: "Rg_is_Fp", dynlib: libname.}
proc Rg_is_FpXQ*(x: GEN; pT: ptr GEN; pp: ptr GEN): cint {.cdecl, importc: "Rg_is_FpXQ",
    dynlib: libname.}
proc Rg_to_Fp*(x: GEN; p: GEN): GEN {.cdecl, importc: "Rg_to_Fp", dynlib: libname.}
proc Rg_to_FpXQ*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "Rg_to_FpXQ",
                                        dynlib: libname.}
proc RgC_to_Flc*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "RgC_to_Flc",
    dynlib: libname.}
proc RgC_to_FpC*(x: GEN; p: GEN): GEN {.cdecl, importc: "RgC_to_FpC", dynlib: libname.}
proc RgM_is_FpM*(x: GEN; p: ptr GEN): cint {.cdecl, importc: "RgM_is_FpM", dynlib: libname.}
proc RgM_to_Flm*(x: GEN; p: pari_ulong): GEN {.cdecl, importc: "RgM_to_Flm",
    dynlib: libname.}
proc RgM_to_FpM*(x: GEN; p: GEN): GEN {.cdecl, importc: "RgM_to_FpM", dynlib: libname.}
proc RgV_is_FpV*(x: GEN; p: ptr GEN): cint {.cdecl, importc: "RgV_is_FpV", dynlib: libname.}
proc RgV_to_FpV*(x: GEN; p: GEN): GEN {.cdecl, importc: "RgV_to_FpV", dynlib: libname.}
proc RgX_is_FpX*(x: GEN; p: ptr GEN): cint {.cdecl, importc: "RgX_is_FpX", dynlib: libname.}
proc RgX_to_FpX*(x: GEN; p: GEN): GEN {.cdecl, importc: "RgX_to_FpX", dynlib: libname.}
proc RgX_is_FpXQX*(x: GEN; pT: ptr GEN; pp: ptr GEN): cint {.cdecl,
    importc: "RgX_is_FpXQX", dynlib: libname.}
proc RgX_to_FpXQX*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "RgX_to_FpXQX",
    dynlib: libname.}
proc RgX_to_FqX*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc: "RgX_to_FqX",
                                        dynlib: libname.}
proc ZX_ZXY_rnfequation*(A: GEN; B: GEN; lambda: ptr clong): GEN {.cdecl,
    importc: "ZX_ZXY_rnfequation", dynlib: libname.}
proc ZXQ_charpoly*(A: GEN; T: GEN; v: clong): GEN {.cdecl, importc: "ZXQ_charpoly",
    dynlib: libname.}
proc ZX_disc*(x: GEN): GEN {.cdecl, importc: "ZX_disc", dynlib: libname.}
proc ZX_is_squarefree*(x: GEN): cint {.cdecl, importc: "ZX_is_squarefree",
                                   dynlib: libname.}
proc ZX_gcd*(A: GEN; B: GEN): GEN {.cdecl, importc: "ZX_gcd", dynlib: libname.}
proc ZX_gcd_all*(A: GEN; B: GEN; Anew: ptr GEN): GEN {.cdecl, importc: "ZX_gcd_all",
    dynlib: libname.}
proc ZX_resultant*(A: GEN; B: GEN): GEN {.cdecl, importc: "ZX_resultant", dynlib: libname.}
proc Z_incremental_CRT*(H: ptr GEN; Hp: pari_ulong; q: ptr GEN; p: pari_ulong): cint {.
    cdecl, importc: "Z_incremental_CRT", dynlib: libname.}
proc Z_init_CRT*(Hp: pari_ulong; p: pari_ulong): GEN {.cdecl, importc: "Z_init_CRT",
    dynlib: libname.}
proc ZM_incremental_CRT*(H: ptr GEN; Hp: GEN; q: ptr GEN; p: pari_ulong): cint {.cdecl,
    importc: "ZM_incremental_CRT", dynlib: libname.}
proc ZM_init_CRT*(Hp: GEN; p: pari_ulong): GEN {.cdecl, importc: "ZM_init_CRT",
    dynlib: libname.}
proc ZX_incremental_CRT*(ptH: ptr GEN; Hp: GEN; q: ptr GEN; p: pari_ulong): cint {.cdecl,
    importc: "ZX_incremental_CRT", dynlib: libname.}
proc ZX_init_CRT*(Hp: GEN; p: pari_ulong; v: clong): GEN {.cdecl, importc: "ZX_init_CRT",
    dynlib: libname.}
proc characteristic*(x: GEN): GEN {.cdecl, importc: "characteristic", dynlib: libname.}
proc ffinit*(p: GEN; n: clong; v: clong): GEN {.cdecl, importc: "ffinit", dynlib: libname.}
proc ffnbirred*(p: GEN; n: clong): GEN {.cdecl, importc: "ffnbirred", dynlib: libname.}
proc ffnbirred0*(p: GEN; n: clong; flag: clong): GEN {.cdecl, importc: "ffnbirred0",
    dynlib: libname.}
proc ffsumnbirred*(p: GEN; n: clong): GEN {.cdecl, importc: "ffsumnbirred",
                                      dynlib: libname.}
proc get_Fq_field*(E: ptr pointer; T: GEN; p: GEN): ptr bb_field {.cdecl,
    importc: "get_Fq_field", dynlib: libname.}
proc init_Fq*(p: GEN; n: clong; v: clong): GEN {.cdecl, importc: "init_Fq", dynlib: libname.}
proc pol_x_powers*(N: clong; v: clong): GEN {.cdecl, importc: "pol_x_powers",
                                        dynlib: libname.}
proc residual_characteristic*(x: GEN): GEN {.cdecl,
    importc: "residual_characteristic", dynlib: libname.}
proc BPSW_isprime*(x: GEN): clong {.cdecl, importc: "BPSW_isprime", dynlib: libname.}
proc BPSW_psp*(N: GEN): clong {.cdecl, importc: "BPSW_psp", dynlib: libname.}
proc addprimes*(primes: GEN): GEN {.cdecl, importc: "addprimes", dynlib: libname.}
proc gisprime*(x: GEN; flag: clong): GEN {.cdecl, importc: "gisprime", dynlib: libname.}
proc gispseudoprime*(x: GEN; flag: clong): GEN {.cdecl, importc: "gispseudoprime",
    dynlib: libname.}
proc gprimepi_upper_bound*(x: GEN): GEN {.cdecl, importc: "gprimepi_upper_bound",
                                      dynlib: libname.}
proc gprimepi_lower_bound*(x: GEN): GEN {.cdecl, importc: "gprimepi_lower_bound",
                                      dynlib: libname.}
proc isprime*(x: GEN): clong {.cdecl, importc: "isprime", dynlib: libname.}
proc ispseudoprime*(x: GEN; flag: clong): clong {.cdecl, importc: "ispseudoprime",
    dynlib: libname.}
proc millerrabin*(n: GEN; k: clong): clong {.cdecl, importc: "millerrabin",
                                       dynlib: libname.}
proc prime*(n: clong): GEN {.cdecl, importc: "prime", dynlib: libname.}
proc primepi*(x: GEN): GEN {.cdecl, importc: "primepi", dynlib: libname.}
proc primepi_upper_bound*(x: cdouble): cdouble {.cdecl,
    importc: "primepi_upper_bound", dynlib: libname.}
proc primepi_lower_bound*(x: cdouble): cdouble {.cdecl,
    importc: "primepi_lower_bound", dynlib: libname.}
proc primes*(n: clong): GEN {.cdecl, importc: "primes", dynlib: libname.}
proc primes_interval*(a: GEN; b: GEN): GEN {.cdecl, importc: "primes_interval",
                                       dynlib: libname.}
proc primes_interval_zv*(a: pari_ulong; b: pari_ulong): GEN {.cdecl,
    importc: "primes_interval_zv", dynlib: libname.}
proc primes_upto_zv*(b: pari_ulong): GEN {.cdecl, importc: "primes_upto_zv",
                                       dynlib: libname.}
proc primes0*(n: GEN): GEN {.cdecl, importc: "primes0", dynlib: libname.}
proc primes_zv*(m: clong): GEN {.cdecl, importc: "primes_zv", dynlib: libname.}
proc randomprime*(N: GEN): GEN {.cdecl, importc: "randomprime", dynlib: libname.}
proc removeprimes*(primes: GEN): GEN {.cdecl, importc: "removeprimes", dynlib: libname.}
proc uislucaspsp*(n: pari_ulong): cint {.cdecl, importc: "uislucaspsp", dynlib: libname.}
proc uisprime*(n: pari_ulong): cint {.cdecl, importc: "uisprime", dynlib: libname.}
proc uprime*(n: clong): pari_ulong {.cdecl, importc: "uprime", dynlib: libname.}
proc uprimepi*(n: pari_ulong): pari_ulong {.cdecl, importc: "uprimepi", dynlib: libname.}
proc qfauto*(g: GEN; flags: GEN): GEN {.cdecl, importc: "qfauto", dynlib: libname.}
proc qfauto0*(g: GEN; flags: GEN): GEN {.cdecl, importc: "qfauto0", dynlib: libname.}
proc qfautoexport*(g: GEN; flag: clong): GEN {.cdecl, importc: "qfautoexport",
    dynlib: libname.}
proc qfisom*(g: GEN; h: GEN; flags: GEN): GEN {.cdecl, importc: "qfisom", dynlib: libname.}
proc qfisom0*(g: GEN; h: GEN; flags: GEN): GEN {.cdecl, importc: "qfisom0", dynlib: libname.}
proc qfisominit*(g: GEN; flags: GEN): GEN {.cdecl, importc: "qfisominit", dynlib: libname.}
proc qfisominit0*(g: GEN; flags: GEN): GEN {.cdecl, importc: "qfisominit0",
                                       dynlib: libname.}
proc genrand*(N: GEN): GEN {.cdecl, importc: "genrand", dynlib: libname.}
proc getrand*(): GEN {.cdecl, importc: "getrand", dynlib: libname.}
proc pari_rand*(): pari_ulong {.cdecl, importc: "pari_rand", dynlib: libname.}
proc randomi*(x: GEN): GEN {.cdecl, importc: "randomi", dynlib: libname.}
proc randomr*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "randomr", dynlib: libname.}
proc random_Fl*(n: pari_ulong): pari_ulong {.cdecl, importc: "random_Fl",
    dynlib: libname.}
proc setrand*(seed: GEN) {.cdecl, importc: "setrand", dynlib: libname.}
proc QX_complex_roots*(p: GEN; par_l: clong): GEN {.cdecl, importc: "QX_complex_roots",
    dynlib: libname.}
proc ZX_graeffe*(p: GEN): GEN {.cdecl, importc: "ZX_graeffe", dynlib: libname.}
proc cleanroots*(x: GEN; par_l: clong): GEN {.cdecl, importc: "cleanroots",
                                        dynlib: libname.}
proc isrealappr*(x: GEN; par_l: clong): cint {.cdecl, importc: "isrealappr",
    dynlib: libname.}
proc polgraeffe*(p: GEN): GEN {.cdecl, importc: "polgraeffe", dynlib: libname.}
proc polmod_to_embed*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "polmod_to_embed",
    dynlib: libname.}
proc roots*(x: GEN; par_l: clong): GEN {.cdecl, importc: "roots", dynlib: libname.}
proc factor_Aurifeuille*(p: GEN; n: clong): GEN {.cdecl, importc: "factor_Aurifeuille",
    dynlib: libname.}
proc factor_Aurifeuille_prime*(p: GEN; n: clong): GEN {.cdecl,
    importc: "factor_Aurifeuille_prime", dynlib: libname.}
proc galoissubcyclo*(N: GEN; sg: GEN; flag: clong; v: clong): GEN {.cdecl,
    importc: "galoissubcyclo", dynlib: libname.}
proc polsubcyclo*(n: clong; d: clong; v: clong): GEN {.cdecl, importc: "polsubcyclo",
    dynlib: libname.}
proc nfsubfields*(nf: GEN; d: clong): GEN {.cdecl, importc: "nfsubfields",
                                      dynlib: libname.}
proc subgrouplist*(cyc: GEN; bound: GEN): GEN {.cdecl, importc: "subgrouplist",
    dynlib: libname.}
proc forsubgroup*(E: pointer; fun: proc (a2: pointer; a3: GEN): clong {.cdecl.}; cyc: GEN;
                 B: GEN) {.cdecl, importc: "forsubgroup", dynlib: libname.}
proc bnrL1*(bnr: GEN; sbgrp: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "bnrL1",
    dynlib: libname.}
proc bnrrootnumber*(bnr: GEN; chi: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "bnrrootnumber", dynlib: libname.}
proc bnrstark*(bnr: GEN; subgroup: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "bnrstark",
    dynlib: libname.}
proc derivnum*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; x: GEN;
              prec: clong=pari_default_prec): GEN {.cdecl, importc: "derivnum", dynlib: libname.}
proc derivfun*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; x: GEN;
              prec: clong=pari_default_prec): GEN {.cdecl, importc: "derivfun", dynlib: libname.}
proc direuler*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; ga: GEN;
              gb: GEN; c: GEN): GEN {.cdecl, importc: "direuler", dynlib: libname.}
proc forcomposite_init*(C: ptr forcomposite_t; a: GEN; b: GEN): cint {.cdecl,
    importc: "forcomposite_init", dynlib: libname.}
proc forcomposite_next*(C: ptr forcomposite_t): GEN {.cdecl,
    importc: "forcomposite_next", dynlib: libname.}
proc forprime_next*(T: ptr forprime_t): GEN {.cdecl, importc: "forprime_next",
    dynlib: libname.}
proc forprime_init*(T: ptr forprime_t; a: GEN; b: GEN): cint {.cdecl,
    importc: "forprime_init", dynlib: libname.}
proc forvec_init*(T: ptr forvec_t; x: GEN; flag: clong): cint {.cdecl,
    importc: "forvec_init", dynlib: libname.}
proc forvec_next*(T: ptr forvec_t): GEN {.cdecl, importc: "forvec_next", dynlib: libname.}
proc polzag*(n: clong; m: clong): GEN {.cdecl, importc: "polzag", dynlib: libname.}
proc prodeuler*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; ga: GEN;
               gb: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "prodeuler", dynlib: libname.}
proc prodinf*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
             prec: clong=pari_default_prec): GEN {.cdecl, importc: "prodinf", dynlib: libname.}
proc prodinf1*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
              prec: clong=pari_default_prec): GEN {.cdecl, importc: "prodinf1", dynlib: libname.}
proc sumalt*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
            prec: clong=pari_default_prec): GEN {.cdecl, importc: "sumalt", dynlib: libname.}
proc sumalt2*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
             prec: clong=pari_default_prec): GEN {.cdecl, importc: "sumalt2", dynlib: libname.}
proc sumpos*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
            prec: clong=pari_default_prec): GEN {.cdecl, importc: "sumpos", dynlib: libname.}
proc sumpos2*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
             prec: clong=pari_default_prec): GEN {.cdecl, importc: "sumpos2", dynlib: libname.}
proc suminf*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN;
            prec: clong=pari_default_prec): GEN {.cdecl, importc: "suminf", dynlib: libname.}
proc u_forprime_next*(T: ptr forprime_t): pari_ulong {.cdecl,
    importc: "u_forprime_next", dynlib: libname.}
proc u_forprime_init*(T: ptr forprime_t; a: pari_ulong; b: pari_ulong): cint {.cdecl,
    importc: "u_forprime_init", dynlib: libname.}
proc u_forprime_restrict*(T: ptr forprime_t; c: pari_ulong) {.cdecl,
    importc: "u_forprime_restrict", dynlib: libname.}
proc u_forprime_arith_init*(T: ptr forprime_t; a: pari_ulong; b: pari_ulong;
                           c: pari_ulong; q: pari_ulong): cint {.cdecl,
    importc: "u_forprime_arith_init", dynlib: libname.}
proc zbrent*(E: pointer; eval: proc (a2: pointer; a3: GEN): GEN {.cdecl.}; a: GEN; b: GEN;
            prec: clong=pari_default_prec): GEN {.cdecl, importc: "zbrent", dynlib: libname.}
proc bnfisintnorm*(x: GEN; y: GEN): GEN {.cdecl, importc: "bnfisintnorm", dynlib: libname.}
proc bnfisintnormabs*(bnf: GEN; a: GEN): GEN {.cdecl, importc: "bnfisintnormabs",
    dynlib: libname.}
proc thue*(thueres: GEN; rhs: GEN; ne: GEN): GEN {.cdecl, importc: "thue", dynlib: libname.}
proc thueinit*(pol: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "thueinit",
    dynlib: libname.}
proc Pi2n*(n: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "Pi2n", dynlib: libname.}
proc PiI2*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "PiI2", dynlib: libname.}
proc PiI2n*(n: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "PiI2n", dynlib: libname.}
proc Qp_exp*(x: GEN): GEN {.cdecl, importc: "Qp_exp", dynlib: libname.}
proc Qp_log*(x: GEN): GEN {.cdecl, importc: "Qp_log", dynlib: libname.}
proc Qp_sqrt*(x: GEN): GEN {.cdecl, importc: "Qp_sqrt", dynlib: libname.}
proc Qp_sqrtn*(x: GEN; n: GEN; zetan: ptr GEN): GEN {.cdecl, importc: "Qp_sqrtn",
    dynlib: libname.}
proc Zn_ispower*(a: GEN; q: GEN; K: GEN; pt: ptr GEN): clong {.cdecl, importc: "Zn_ispower",
    dynlib: libname.}
proc Zn_issquare*(x: GEN; n: GEN): clong {.cdecl, importc: "Zn_issquare", dynlib: libname.}
proc Zn_sqrt*(x: GEN; n: GEN): GEN {.cdecl, importc: "Zn_sqrt", dynlib: libname.}
proc Zp_teichmuller*(x: GEN; p: GEN; n: clong; q: GEN): GEN {.cdecl,
    importc: "Zp_teichmuller", dynlib: libname.}
proc agm*(x: GEN; y: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "agm", dynlib: libname.}
proc constcatalan*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "constcatalan", dynlib: libname.}
proc consteuler*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "consteuler", dynlib: libname.}
proc constlog2*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "constlog2", dynlib: libname.}
proc constpi*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "constpi", dynlib: libname.}
proc cxexpm1*(z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "cxexpm1", dynlib: libname.}
proc expIr*(x: GEN): GEN {.cdecl, importc: "expIr", dynlib: libname.}
proc exp1r_abs*(x: GEN): GEN {.cdecl, importc: "exp1r_abs", dynlib: libname.}
proc gcos*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gcos", dynlib: libname.}
proc gcotan*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gcotan", dynlib: libname.}
proc gexp*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gexp", dynlib: libname.}
proc gexpm1*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gexpm1", dynlib: libname.}
proc glog*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "glog", dynlib: libname.}
proc gpow*(x: GEN; n: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gpow", dynlib: libname.}
proc gpowgs*(x: GEN; n: clong): GEN {.cdecl, importc: "gpowgs", dynlib: libname.}
proc gsin*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gsin", dynlib: libname.}
proc gsincos*(x: GEN; s: ptr GEN; c: ptr GEN; prec: clong=pari_default_prec) {.cdecl, importc: "gsincos",
    dynlib: libname.}
proc gsqrt*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gsqrt", dynlib: libname.}
proc gsqrtn*(x: GEN; n: GEN; zetan: ptr GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gsqrtn",
    dynlib: libname.}
proc gtan*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gtan", dynlib: libname.}
proc logr_abs*(x: GEN): GEN {.cdecl, importc: "logr_abs", dynlib: libname.}
proc mpcos*(x: GEN): GEN {.cdecl, importc: "mpcos", dynlib: libname.}
proc mpeuler*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "mpeuler", dynlib: libname.}
proc mpcatalan*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "mpcatalan", dynlib: libname.}
proc mpsincosm1*(x: GEN; s: ptr GEN; c: ptr GEN) {.cdecl, importc: "mpsincosm1",
    dynlib: libname.}
proc mpexp*(x: GEN): GEN {.cdecl, importc: "mpexp", dynlib: libname.}
proc mpexpm1*(x: GEN): GEN {.cdecl, importc: "mpexpm1", dynlib: libname.}
proc mplog*(x: GEN): GEN {.cdecl, importc: "mplog", dynlib: libname.}
proc mplog2*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "mplog2", dynlib: libname.}
proc mppi*(prec: clong=pari_default_prec): GEN {.cdecl, importc: "mppi", dynlib: libname.}
proc mpsin*(x: GEN): GEN {.cdecl, importc: "mpsin", dynlib: libname.}
proc mpsincos*(x: GEN; s: ptr GEN; c: ptr GEN) {.cdecl, importc: "mpsincos", dynlib: libname.}
proc powis*(x: GEN; n: clong): GEN {.cdecl, importc: "powis", dynlib: libname.}
proc powiu*(p: GEN; k: pari_ulong): GEN {.cdecl, importc: "powiu", dynlib: libname.}
proc powrfrac*(x: GEN; n: clong; d: clong): GEN {.cdecl, importc: "powrfrac",
    dynlib: libname.}
proc powrs*(x: GEN; n: clong): GEN {.cdecl, importc: "powrs", dynlib: libname.}
proc powrshalf*(x: GEN; s: clong): GEN {.cdecl, importc: "powrshalf", dynlib: libname.}
proc powru*(x: GEN; n: pari_ulong): GEN {.cdecl, importc: "powru", dynlib: libname.}
proc powruhalf*(x: GEN; s: pari_ulong): GEN {.cdecl, importc: "powruhalf",
                                        dynlib: libname.}
proc powuu*(p: pari_ulong; k: pari_ulong): GEN {.cdecl, importc: "powuu", dynlib: libname.}
proc powgi*(x: GEN; n: GEN): GEN {.cdecl, importc: "powgi", dynlib: libname.}
proc serchop0*(s: GEN): GEN {.cdecl, importc: "serchop0", dynlib: libname.}
proc sqrtnint*(a: GEN; n: clong): GEN {.cdecl, importc: "sqrtnint", dynlib: libname.}
proc teich*(x: GEN): GEN {.cdecl, importc: "teich", dynlib: libname.}
proc trans_eval*(fun: cstring; f: proc (a2: GEN; a3: clong): GEN {.cdecl.}; x: GEN;
                prec: clong=pari_default_prec): GEN {.cdecl, importc: "trans_eval", dynlib: libname.}
proc upowuu*(p: pari_ulong; k: pari_ulong): pari_ulong {.cdecl, importc: "upowuu",
    dynlib: libname.}
proc usqrtn*(a: pari_ulong; n: pari_ulong): pari_ulong {.cdecl, importc: "usqrtn",
    dynlib: libname.}
proc usqrt*(a: pari_ulong): pari_ulong {.cdecl, importc: "usqrt", dynlib: libname.}
proc Qp_gamma*(x: GEN): GEN {.cdecl, importc: "Qp_gamma", dynlib: libname.}
proc bernfrac*(n: clong): GEN {.cdecl, importc: "bernfrac", dynlib: libname.}
proc bernpol*(k: clong; v: clong): GEN {.cdecl, importc: "bernpol", dynlib: libname.}
proc bernreal*(n: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "bernreal", dynlib: libname.}
proc gacosh*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gacosh", dynlib: libname.}
proc gacos*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gacos", dynlib: libname.}
proc garg*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "garg", dynlib: libname.}
proc gasinh*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gasinh", dynlib: libname.}
proc gasin*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gasin", dynlib: libname.}
proc gatan*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gatan", dynlib: libname.}
proc gatanh*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gatanh", dynlib: libname.}
proc gcosh*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gcosh", dynlib: libname.}
proc ggammah*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ggammah", dynlib: libname.}
proc ggamma*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ggamma", dynlib: libname.}
proc glngamma*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "glngamma", dynlib: libname.}
proc gpsi*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gpsi", dynlib: libname.}
proc gsinh*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gsinh", dynlib: libname.}
proc gtanh*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gtanh", dynlib: libname.}
proc mpbern*(nomb: clong; prec: clong=pari_default_prec) {.cdecl, importc: "mpbern", dynlib: libname.}
proc mpfactr*(n: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "mpfactr", dynlib: libname.}
proc sumformal*(T: GEN; v: clong): GEN {.cdecl, importc: "sumformal", dynlib: libname.}
proc dilog*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "dilog", dynlib: libname.}
proc eint1*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "eint1", dynlib: libname.}
proc eta*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "eta", dynlib: libname.}
proc eta0*(x: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "eta0", dynlib: libname.}
proc gerfc*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gerfc", dynlib: libname.}
proc gpolylog*(m: clong; x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gpolylog",
    dynlib: libname.}
proc gzeta*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "gzeta", dynlib: libname.}
proc hyperu*(a: GEN; b: GEN; gx: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "hyperu",
    dynlib: libname.}
proc incgam*(a: GEN; x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "incgam", dynlib: libname.}
proc incgam0*(a: GEN; x: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "incgam0",
    dynlib: libname.}
proc incgamc*(a: GEN; x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "incgamc",
    dynlib: libname.}
proc hbessel1*(n: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "hbessel1",
    dynlib: libname.}
proc hbessel2*(n: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "hbessel2",
    dynlib: libname.}
proc ibessel*(n: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "ibessel",
    dynlib: libname.}
proc jbessel*(n: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "jbessel",
    dynlib: libname.}
proc jbesselh*(n: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "jbesselh",
    dynlib: libname.}
proc mpeint1*(x: GEN; expx: GEN): GEN {.cdecl, importc: "mpeint1", dynlib: libname.}
proc mplambertW*(y: GEN): GEN {.cdecl, importc: "mplambertW", dynlib: libname.}
proc mpveceint1*(C: GEN; eC: GEN; n: clong): GEN {.cdecl, importc: "mpveceint1",
    dynlib: libname.}
proc powruvec*(e: GEN; n: pari_ulong): GEN {.cdecl, importc: "powruvec", dynlib: libname.}
proc nbessel*(n: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "nbessel",
    dynlib: libname.}
proc jell*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "jell", dynlib: libname.}
proc kbessel*(nu: GEN; gx: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "kbessel",
    dynlib: libname.}
proc polylog0*(m: clong; x: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "polylog0", dynlib: libname.}
proc sumdedekind_coprime*(h: GEN; k: GEN): GEN {.cdecl, importc: "sumdedekind_coprime",
    dynlib: libname.}
proc sumdedekind*(h: GEN; k: GEN): GEN {.cdecl, importc: "sumdedekind", dynlib: libname.}
proc szeta*(x: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "szeta", dynlib: libname.}
proc theta*(q: GEN; z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "theta", dynlib: libname.}
proc thetanullk*(q: GEN; k: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "thetanullk",
    dynlib: libname.}
proc trueeta*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "trueeta", dynlib: libname.}
proc u_sumdedekind_coprime*(h: clong; k: clong): GEN {.cdecl,
    importc: "u_sumdedekind_coprime", dynlib: libname.}
proc veceint1*(nmax: GEN; C: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "veceint1",
    dynlib: libname.}
proc vecthetanullk*(q: GEN; k: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "vecthetanullk", dynlib: libname.}
proc vecthetanullk_tau*(tau: GEN; k: clong; prec: clong=pari_default_prec): GEN {.cdecl,
    importc: "vecthetanullk_tau", dynlib: libname.}
proc weber0*(x: GEN; flag: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc: "weber0",
    dynlib: libname.}
proc weberf*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "weberf", dynlib: libname.}
proc weberf1*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "weberf1", dynlib: libname.}
proc weberf2*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "weberf2", dynlib: libname.}
proc glambertW*(y: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc: "glambertW", dynlib: libname.}

## Static files here
proc Fl_add*(a: pari_ulong; b: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc Fl_center*(u: pari_ulong; p: pari_ulong; ps2: pari_ulong): clong {.cdecl, importc, dynlib: libname.}
proc Fl_div*(a: pari_ulong; b: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc Fl_double*(a: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc Fl_mul*(a: pari_ulong; b: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc Fl_neg*(x: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc Fl_sqr*(a: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc Fl_sub*(a: pari_ulong; b: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc Fl_triple*(a: pari_ulong; p: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc absi*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc absi_shallow*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc absr*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc absrnz_equal1*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc absrnz_equal2n*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc addii*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc addiiz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc addir*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc addirz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc addis*(x: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc addri*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc addriz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc addrr*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc addrrz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc addrs*(x: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc addsi*(x: clong; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc addsiz*(s: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc addsrz*(s: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc addss*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc addssz*(s: clong; y: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc adduu*(x: pari_ulong; y: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc affgr*(x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}
proc affii*(x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}
proc affiz*(x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}
proc affrr_fixlg*(y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc affsi*(s: clong; x: GEN) {.cdecl, importc, dynlib: libname.}
proc affsr*(s: clong; x: GEN) {.cdecl, importc, dynlib: libname.}
proc affsz*(x: clong; y: GEN) {.cdecl, importc, dynlib: libname.}
proc affui*(s: pari_ulong; x: GEN) {.cdecl, importc, dynlib: libname.}
proc affur*(s: pari_ulong; x: GEN) {.cdecl, importc, dynlib: libname.}
proc cgetg*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc cgetg_block*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc cgetg_copy*(x: GEN; plx: ptr clong): GEN {.cdecl, importc, dynlib: libname.}
proc cgeti*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc cgetineg*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc cgetipos*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc cgetr*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc cgetr_block*(prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc cmpir*(x: GEN; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc cmpis*(x: GEN; y: clong): cint {.cdecl, importc, dynlib: libname.}
proc cmpiu*(x: GEN; y: pari_ulong): cint {.cdecl, importc, dynlib: libname.}
proc cmpri*(x: GEN; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc cmprs*(x: GEN; y: clong): cint {.cdecl, importc, dynlib: libname.}
proc cmpsi*(x: clong; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc cmpsr*(x: clong; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc cmpui*(x: pari_ulong; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc cxtofp*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc divii*(a: GEN; b: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc diviiz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc divirz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc divisz*(x: GEN; s: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc divriz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc divrrz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc divrsz*(y: GEN; s: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc divsi_rem*(x: clong; y: GEN; rem: ptr clong): GEN {.cdecl, importc, dynlib: libname.}
proc divsiz*(x: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc divsrz*(s: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc divss*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc divss_rem*(x: clong; y: clong; rem: ptr clong): GEN {.cdecl, importc, dynlib: libname.}
proc divssz*(x: clong; y: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc dvdii*(x: GEN; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc dvdiiz*(x: GEN; y: GEN; z: GEN): cint {.cdecl, importc, dynlib: libname.}
proc dvdis*(x: GEN; y: clong): cint {.cdecl, importc, dynlib: libname.}
proc dvdisz*(x: GEN; y: clong; z: GEN): cint {.cdecl, importc, dynlib: libname.}
proc dvdiu*(x: GEN; y: pari_ulong): cint {.cdecl, importc, dynlib: libname.}
proc dvdiuz*(x: GEN; y: pari_ulong; z: GEN): cint {.cdecl, importc, dynlib: libname.}
proc dvdsi*(x: clong; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc dvdui*(x: pari_ulong; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc dvmdiiz*(x: GEN; y: GEN; z: GEN; t: GEN) {.cdecl, importc, dynlib: libname.}
proc dvmdis*(x: GEN; y: clong; z: ptr GEN): GEN {.cdecl, importc, dynlib: libname.}
proc dvmdisz*(x: GEN; y: clong; z: GEN; t: GEN) {.cdecl, importc, dynlib: libname.}
proc dvmdsBIL*(n: clong; r: ptr clong): clong {.cdecl, importc, dynlib: libname.}
proc dvmdsi*(x: clong; y: GEN; z: ptr GEN): GEN {.cdecl, importc, dynlib: libname.}
proc dvmdsiz*(x: clong; y: GEN; z: GEN; t: GEN) {.cdecl, importc, dynlib: libname.}
proc dvmdss*(x: clong; y: clong; z: ptr GEN): GEN {.cdecl, importc, dynlib: libname.}
proc dvmdssz*(x: clong; y: clong; z: GEN; t: GEN) {.cdecl, importc, dynlib: libname.}
proc dvmduBIL*(n: pari_ulong; r: ptr pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc equalis*(x: GEN; y: clong): cint {.cdecl, importc, dynlib: libname.}
proc equaliu*(x: GEN; y: pari_ulong): cint {.cdecl, importc, dynlib: libname.}
proc equalsi*(x: clong; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc equalui*(x: pari_ulong; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc evalexpo*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc evallg*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc evalprecp*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc evalvalp*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc expi*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc expu*(x: pari_ulong): clong {.cdecl, importc, dynlib: libname.}
proc fixlg*(z: GEN; ly: clong) {.cdecl, importc, dynlib: libname.}
proc fractor*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc icopy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc icopyspec*(x: GEN; nx: clong): GEN {.cdecl, importc, dynlib: libname.}
proc icopy_avma*(x: GEN; av: pari_sp): GEN {.cdecl, importc, dynlib: libname.}
proc int_bit*(x: GEN; n: clong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc itor*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc itos*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc itos_or_0*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc itou*(x: GEN): pari_ulong {.cdecl, importc, dynlib: libname.}
proc itou_or_0*(x: GEN): pari_ulong {.cdecl, importc, dynlib: libname.}
proc leafcopy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc leafcopy_avma*(x: GEN; av: pari_sp): GEN {.cdecl, importc, dynlib: libname.}
proc maxdd*(x: cdouble; y: cdouble): cdouble {.cdecl, importc, dynlib: libname.}
proc maxss*(x: clong; y: clong): clong {.cdecl, importc, dynlib: libname.}
proc maxuu*(x: pari_ulong; y: pari_ulong): clong {.cdecl, importc, dynlib: libname.}
proc mindd*(x: cdouble; y: cdouble): cdouble {.cdecl, importc, dynlib: libname.}
proc minss*(x: clong; y: clong): clong {.cdecl, importc, dynlib: libname.}
proc minuu*(x: pari_ulong; y: pari_ulong): clong {.cdecl, importc, dynlib: libname.}
proc mod16*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc mod2*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc mod2BIL*(x: GEN): pari_ulong {.cdecl, importc, dynlib: libname.}
proc mod32*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc mod4*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc mod64*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc mod8*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc modis*(x: GEN; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc modisz*(y: GEN; s: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc modsi*(x: clong; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc modsiz*(s: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc modss*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc modssz*(s: clong; y: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mpabs*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpabs_shallow*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpadd*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpaddz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mpaff*(x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}
proc mpceil*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpcmp*(x: GEN; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc mpcopy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpdiv*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpexpo*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc mpfloor*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpmul*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpmulz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mpneg*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpodd*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc mpround*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpshift*(x: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mpsqr*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpsub*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mpsubz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mptrunc*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc muliiz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mulirz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mulis*(x: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc muliu*(x: GEN; s: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc mulri*(x: GEN; s: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mulriz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mulrrz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mulrs*(x: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mulru*(x: GEN; s: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc mulsiz*(s: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mulsrz*(s: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mulssz*(s: clong; y: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc negi*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc negr*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc new_chunk*(x: csize): GEN {.cdecl, importc, dynlib: libname.}
proc rcopy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rdivii*(x: GEN; y: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc rdiviiz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc rdivis*(x: GEN; y: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc rdivsi*(x: clong; y: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc rdivss*(x: clong; y: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc real2n*(n: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc real_m2n*(n: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc real_0*(prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc real_0_bit*(bitprec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc real_1*(prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc real_m1*(prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc remii*(a: GEN; b: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc remiiz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc remis*(x: GEN; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc remisz*(y: GEN; s: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc remsi*(x: clong; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc remsiz*(s: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc remss*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc remssz*(s: clong; y: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc rtor*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc sdivsi*(x: clong; y: GEN): clong {.cdecl, importc, dynlib: libname.}
proc sdivsi_rem*(x: clong; y: GEN; rem: ptr clong): clong {.cdecl, importc, dynlib: libname.}
proc sdivss_rem*(x: clong; y: clong; rem: ptr clong): clong {.cdecl, importc, dynlib: libname.}
proc udiviu_rem*(n: GEN; d: pari_ulong; r: ptr pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc udivuu_rem*(x: pari_ulong; y: pari_ulong; r: ptr pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc setabssign*(x: GEN) {.cdecl, importc, dynlib: libname.}
proc shift_left*(z2: GEN; z1: GEN; min: clong; M: clong; f: pari_ulong; sh: pari_ulong) {.cdecl, importc, dynlib: libname.}
proc shift_right*(z2: GEN; z1: GEN; min: clong; M: clong; f: pari_ulong; sh: pari_ulong) {.cdecl, importc, dynlib: libname.}
proc shiftl*(x: pari_ulong; y: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc shiftlr*(x: pari_ulong; y: pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc shiftr*(x: GEN; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc shiftr_inplace*(z: GEN; d: clong) {.cdecl, importc, dynlib: libname.}
proc smodis*(x: GEN; y: clong): clong {.cdecl, importc, dynlib: libname.}
proc smodss*(x: clong; y: clong): clong {.cdecl, importc, dynlib: libname.}
proc stackdummy*(av: pari_sp; ltop: pari_sp) {.cdecl, importc, dynlib: libname.}
proc stack_malloc*(N: csize): cstring {.cdecl, importc, dynlib: libname.}
proc stack_calloc*(N: csize): cstring {.cdecl, importc, dynlib: libname.}
proc stoi*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc stor*(x: clong; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc subii*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc subiiz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc subir*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc subirz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc subis*(x: GEN; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc subisz*(y: GEN; s: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc subri*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc subriz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc subrr*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc subrrz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc subrs*(x: GEN; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc subrsz*(y: GEN; s: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc subsi*(x: clong; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc subsiz*(s: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc subsrz*(s: clong; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc subss*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc subssz*(x: clong; y: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc subuu*(x: pari_ulong; y: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc togglesign*(x: GEN) {.cdecl, importc, dynlib: libname.}
proc togglesign_safe*(px: ptr GEN) {.cdecl, importc, dynlib: libname.}
proc affectsign*(x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}
proc affectsign_safe*(x: GEN; py: ptr GEN) {.cdecl, importc, dynlib: libname.}
proc truedivii*(a: GEN; b: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc truedivis*(a: GEN; b: clong): GEN {.cdecl, importc, dynlib: libname.}
proc truedivsi*(a: clong; b: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc udivui_rem*(x: pari_ulong; y: GEN; rem: ptr pari_ulong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc umodui*(x: pari_ulong; y: GEN): pari_ulong {.cdecl, importc, dynlib: libname.}
proc utoi*(x: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc utoineg*(x: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc utoipos*(x: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc utor*(s: pari_ulong; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc uutoi*(x: pari_ulong; y: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc uutoineg*(x: pari_ulong; y: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc vali*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc abgrp_get_cyc*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc abgrp_get_gen*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc abgrp_get_no*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bid_get_arch*(bid: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bid_get_cyc*(bid: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bid_get_gen*(bid: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bid_get_gen_nocheck*(bid: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bid_get_grp*(bid: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bid_get_ideal*(bid: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bid_get_mod*(bid: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bid_get_no*(bid: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_clgp*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_cyc*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_fu*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_fu_nocheck*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_gen*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_logfu*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_nf*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_no*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_reg*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_tuU*(bnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnf_get_tuN*(bnf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc bnr_get_bnf*(bnr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnr_get_clgp*(bnr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnr_get_cyc*(bnr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnr_get_gen*(bnr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnr_get_gen_nocheck*(bnr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnr_get_no*(bnr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnr_get_bid*(bnr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnr_get_mod*(bnr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bnr_get_nf*(bnr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_a1*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_a2*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_a3*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_a4*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_a6*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_b2*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_b4*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_b6*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_b8*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_c4*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_c6*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_disc*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_j*(e: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ell_get_type*(e: GEN): clong {.cdecl, importc, dynlib: libname.}
proc ell_is_inf*(z: GEN): cint {.cdecl, importc, dynlib: libname.}
proc ellinf*(): GEN {.cdecl, importc, dynlib: libname.}
proc ellff_get_field*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ellff_get_a4a6*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ellQp_get_p*(E: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ellQp_get_prec*(E: GEN): clong {.cdecl, importc, dynlib: libname.}
proc ellQp_get_zero*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ellR_get_prec*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc ellR_get_sign*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc gal_get_pol*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gal_get_p*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gal_get_e*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gal_get_mod*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gal_get_roots*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gal_get_invvdm*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gal_get_den*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gal_get_group*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gal_get_gen*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gal_get_orders*(gal: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc idealpseudomin*(I: GEN; G: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc idealpseudomin_nonscalar*(I: GEN; G: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc idealred_elt*(nf: GEN; I: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc idealred*(nf: GEN; I: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_M*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_G*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_Tr*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_diff*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_degree*(nf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc nf_get_disc*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_index*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_invzk*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_pol*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_r1*(nf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc nf_get_r2*(nf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc nf_get_roots*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_roundG*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nf_get_sign*(nf: GEN; r1: ptr clong; r2: ptr clong) {.cdecl, importc, dynlib: libname.}
proc nf_get_varn*(nf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc nf_get_zk*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc pr_get_e*(pr: GEN): clong {.cdecl, importc, dynlib: libname.}
proc pr_get_f*(pr: GEN): clong {.cdecl, importc, dynlib: libname.}
proc pr_get_gen*(pr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc pr_get_p*(pr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc pr_get_tau*(pr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc pr_is_inert*(P: GEN): cint {.cdecl, importc, dynlib: libname.}
proc pr_norm*(pr: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rnf_get_absdegree*(rnf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc rnf_get_degree*(rnf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc rnf_get_invzk*(rnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rnf_get_map*(rnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rnf_get_nf*(rnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rnf_get_nfdegree*(rnf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc rnf_get_nfpol*(rnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rnf_get_nfvarn*(rnf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc rnf_get_pol*(rnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rnf_get_polabs*(rnf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rnf_get_zk*(nf: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rnf_get_nfzk*(rnf: GEN; b: ptr GEN; cb: ptr GEN) {.cdecl, importc, dynlib: libname.}
proc rnf_get_varn*(rnf: GEN): clong {.cdecl, importc, dynlib: libname.}
proc closure_arity*(C: GEN): clong {.cdecl, importc, dynlib: libname.}
proc closure_codestr*(C: GEN): cstring {.cdecl, importc, dynlib: libname.}
proc closure_get_code*(C: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc closure_get_oper*(C: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc closure_get_data*(C: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc closure_get_dbg*(C: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc closure_get_text*(C: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc closure_get_frame*(C: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc addmuliu*(x: GEN; y: GEN; u: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc addmuliu_inplace*(x: GEN; y: GEN; u: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc lincombii*(u: GEN; v: GEN; x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mulsubii*(y: GEN; z: GEN; x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc submulii*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc submuliu*(x: GEN; y: GEN; u: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc submuliu_inplace*(x: GEN; y: GEN; u: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc FpXQ_add*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FpXQ_sub*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Flxq_add*(x: GEN; y: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc Flxq_sub*(x: GEN; y: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc FpXQX_div*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FlxqX_div*(x: GEN; y: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc FlxqX_rem*(x: GEN; y: GEN; T: GEN; p: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc Fq_red*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_Fp_mul*(P: GEN; U: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_Fq_mul*(P: GEN; U: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_add*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_div*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_divrem*(x: GEN; y: GEN; T: GEN; p: GEN; z: ptr GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_extgcd*(P: GEN; Q: GEN; T: GEN; p: GEN; U: ptr GEN; V: ptr GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_gcd*(P: GEN; Q: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_mul*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_mulu*(x: GEN; y: pari_ulong; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_neg*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_red*(z: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_rem*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_sqr*(x: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqX_sub*(x: GEN; y: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqXQ_add*(x: GEN; y: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqXQ_div*(x: GEN; y: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqXQ_inv*(x: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqXQ_invsafe*(x: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqXQ_mul*(x: GEN; y: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqXQ_pow*(x: GEN; n: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqXQ_sqr*(x: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FqXQ_sub*(x: GEN; y: GEN; S: GEN; T: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc F2m_coeff*(x: GEN; a: clong; b: clong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc F2m_clear*(x: GEN; a: clong; b: clong) {.cdecl, importc, dynlib: libname.}
proc F2m_flip*(x: GEN; a: clong; b: clong) {.cdecl, importc, dynlib: libname.}
proc F2m_set*(x: GEN; a: clong; b: clong) {.cdecl, importc, dynlib: libname.}
proc F2v_clear*(x: GEN; v: clong) {.cdecl, importc, dynlib: libname.}
proc F2v_coeff*(x: GEN; v: clong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc F2v_flip*(x: GEN; v: clong) {.cdecl, importc, dynlib: libname.}
proc F2v_to_F2x*(x: GEN; sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc F2v_set*(x: GEN; v: clong) {.cdecl, importc, dynlib: libname.}
proc F2x_clear*(x: GEN; v: clong) {.cdecl, importc, dynlib: libname.}
proc F2x_coeff*(x: GEN; v: clong): pari_ulong {.cdecl, importc, dynlib: libname.}
proc F2x_flip*(x: GEN; v: clong) {.cdecl, importc, dynlib: libname.}
proc F2x_set*(x: GEN; v: clong) {.cdecl, importc, dynlib: libname.}
proc F2x_equal1*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc F2x_equal*(V: GEN; W: GEN): cint {.cdecl, importc, dynlib: libname.}
proc F2x_div*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc F2x_renormalize*(x: GEN; lx: clong): GEN {.cdecl, importc, dynlib: libname.}
proc F2m_copy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc F2v_copy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc F2v_ei*(n: clong; i: clong): GEN {.cdecl, importc, dynlib: libname.}
proc Flm_copy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Flv_copy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Flx_equal1*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc Flx_copy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Flx_div*(x: GEN; y: GEN; p: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc Flx_lead*(x: GEN): pari_ulong {.cdecl, importc, dynlib: libname.}
proc Flx_mulu*(x: GEN; a: pari_ulong; p: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc FpV_FpC_mul*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FpXQX_renormalize*(x: GEN; lx: clong): GEN {.cdecl, importc, dynlib: libname.}
proc FpXX_renormalize*(x: GEN; lx: clong): GEN {.cdecl, importc, dynlib: libname.}
proc FpX_div*(x: GEN; y: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc FpX_renormalize*(x: GEN; lx: clong): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_add*(a: GEN; b: GEN; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_addmul*(x: GEN; y: GEN; z: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_center*(u: GEN; p: GEN; ps2: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_div*(a: GEN; b: GEN; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_inv*(a: GEN; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_invsafe*(a: GEN; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_mul*(a: GEN; b: GEN; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_muls*(a: GEN; b: clong; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_mulu*(a: GEN; b: pari_ulong; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_neg*(b: GEN; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_red*(x: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_sqr*(a: GEN; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Fp_sub*(a: GEN; b: GEN; m: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc GENbinbase*(p: ptr GENbin): GEN {.cdecl, importc, dynlib: libname.}
proc Q_abs*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Q_abs_shallow*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc QV_isscalar*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc RgC_fpnorml2*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc RgC_gtofp*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc RgC_gtomp*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc RgM_dimensions*(x: GEN; m: ptr clong; n: ptr clong) {.cdecl, importc, dynlib: libname.}
proc RgM_fpnorml2*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc RgM_gtofp*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc RgM_gtomp*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc RgM_inv*(a: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc RgM_minor*(a: GEN; i: clong; j: clong): GEN {.cdecl, importc, dynlib: libname.}
proc RgM_shallowcopy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc RgV_isscalar*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc RgV_is_ZV*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc RgV_is_QV*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc RgX_equal_var*(x: GEN; y: GEN): clong {.cdecl, importc, dynlib: libname.}
proc RgX_is_monomial*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc RgX_is_rational*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc RgX_is_QX*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc RgX_is_ZX*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc RgX_isscalar*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc RgX_shift_inplace*(x: GEN; v: clong): GEN {.cdecl, importc, dynlib: libname.}
proc RgX_shift_inplace_init*(v: clong) {.cdecl, importc, dynlib: libname.}
proc RgXQ_mul*(x: GEN; y: GEN; T: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc RgXQ_sqr*(x: GEN; T: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc RgXQX_div*(x: GEN; y: GEN; T: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc RgXQX_rem*(x: GEN; y: GEN; T: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc RgX_copy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc RgX_div*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc RgX_fpnorml2*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc RgX_gtofp*(x: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc RgX_rem*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc RgX_renormalize*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Rg_col_ei*(x: GEN; n: clong; i: clong): GEN {.cdecl, importc, dynlib: libname.}
proc ZC_hnfrem*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ZM_hnfrem*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ZM_lll*(x: GEN; D: cdouble; f: clong): GEN {.cdecl, importc, dynlib: libname.}
proc ZV_dvd*(x: GEN; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc ZV_isscalar*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc ZV_to_zv*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ZX_ZXY_resultant*(a: GEN; b: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ZX_equal1*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc ZX_renormalize*(x: GEN; lx: clong): GEN {.cdecl, importc, dynlib: libname.}
proc ZXQ_mul*(x: GEN; y: GEN; T: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc ZXQ_sqr*(x: GEN; T: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc Z_ispower*(x: GEN; k: pari_ulong): clong {.cdecl, importc, dynlib: libname.}
proc Z_issquare*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc absfrac*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc absfrac_shallow*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc affc_fixlg*(x: GEN; res: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc bin_copy*(p: ptr GENbin): GEN {.cdecl, importc, dynlib: libname.}
proc bit_accuracy*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc bit_accuracy_mul*(x: clong; y: cdouble): cdouble {.cdecl, importc, dynlib: libname.}
proc bit_prec*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc both_odd*(x: clong; y: clong): cint {.cdecl, importc, dynlib: libname.}
proc cgetc*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc cgetalloc*(t: clong; pari_l: csize): GEN {.cdecl, importc, dynlib: libname.}
proc cxcompotor*(z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc cgiv*(x: GEN) {.cdecl, importc, dynlib: libname.}
proc col_ei*(n: clong; i: clong): GEN {.cdecl, importc, dynlib: libname.}
proc const_col*(n: clong; x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc const_vec*(n: clong; x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc const_vecsmall*(n: clong; c: clong): GEN {.cdecl, importc, dynlib: libname.}
proc constant_term*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc cxnorm*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc cyclic_perm*(pari_l: clong; d: clong): GEN {.cdecl, importc, dynlib: libname.}
proc dbllog2r*(x: GEN): cdouble {.cdecl, importc, dynlib: libname.}
proc degpol*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc divsBIL*(n: clong): clong {.cdecl, importc, dynlib: libname.}
proc gabsz*(x: GEN; prec: clong=pari_default_prec; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gaddgs*(y: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc gaddz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gcmpgs*(y: GEN; s: clong): cint {.cdecl, importc, dynlib: libname.}
proc gdiventz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gdivsg*(s: clong; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gdivz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gen_I*(): GEN {.cdecl, importc, dynlib: libname.}
proc gerepileall*(av: pari_sp; n: cint) {.varargs, importc, cdecl, dynlib: libname.}
proc gerepilecoeffs*(av: pari_sp; x: GEN; n: cint) {.cdecl, importc, dynlib: libname.}
proc gerepilecopy*(av: pari_sp; x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gerepilemany*(av: pari_sp; g: ptr ptr GEN; n: cint) {.cdecl, importc, dynlib: libname.}
proc gequalgs*(y: GEN; s: clong): cint {.cdecl, importc, dynlib: libname.}
proc gerepileupto*(av: pari_sp; q: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gerepileuptoint*(av: pari_sp; q: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gerepileuptoleaf*(av: pari_sp; q: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gmaxsg*(s: clong; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gminsg*(s: clong; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc gmodz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gmul2nz*(x: GEN; s: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gmulgs*(y: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc gmulz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gnegz*(x: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gshiftz*(x: GEN; s: clong; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gsubgs*(y: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc gsubz*(x: GEN; y: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc gtodouble*(x: GEN): cdouble {.cdecl, importc, dynlib: libname.}
proc gtofp*(z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc gtomp*(z: GEN; prec: clong=pari_default_prec): GEN {.cdecl, importc, dynlib: libname.}
proc gtos*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc gval*(x: GEN; v: clong): clong {.cdecl, importc, dynlib: libname.}
proc identity_perm*(pari_l: clong): GEN {.cdecl, importc, dynlib: libname.}
proc equali1*(n: GEN): cint {.cdecl, importc, dynlib: libname.}
proc equalim1*(n: GEN): cint {.cdecl, importc, dynlib: libname.}
proc is_bigint*(n: GEN): cint {.cdecl, importc, dynlib: libname.}
proc is_const_t*(t: clong): cint {.cdecl, importc, dynlib: libname.}
proc is_extscalar_t*(t: clong): cint {.cdecl, importc, dynlib: libname.}
proc is_intreal_t*(t: clong): cint {.cdecl, importc, dynlib: libname.}
proc is_matvec_t*(t: clong): cint {.cdecl, importc, dynlib: libname.}
proc is_noncalc_t*(tx: clong): cint {.cdecl, importc, dynlib: libname.}
proc is_pm1*(n: GEN): cint {.cdecl, importc, dynlib: libname.}
proc is_rational_t*(t: clong): cint {.cdecl, importc, dynlib: libname.}
proc is_recursive_t*(t: clong): cint {.cdecl, importc, dynlib: libname.}
proc is_scalar_t*(t: clong): cint {.cdecl, importc, dynlib: libname.}
proc is_universal_constant*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc is_vec_t*(t: clong): cint {.cdecl, importc, dynlib: libname.}
proc isint1*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc isintm1*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc isintzero*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc ismpzero*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc isonstack*(x: GEN): cint {.cdecl, importc, dynlib: libname.}
proc killblock*(x: GEN) {.cdecl, importc, dynlib: libname.}
proc leading_term*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc lgcols*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc lgpol*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc matpascal*(n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkcol*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkcol2*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkcol2s*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkcol3*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkcol3s*(x: clong; y: clong; z: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkcol4*(x: GEN; y: GEN; z: GEN; t: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkcol4s*(x: clong; y: clong; z: clong; t: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkcol5*(x: GEN; y: GEN; z: GEN; t: GEN; u: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkcolcopy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkcols*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkcomplex*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkerr*(n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkfrac*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkfraccopy*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkintmod*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkintmodu*(x: pari_ulong; y: pari_ulong): GEN {.cdecl, importc, dynlib: libname.}
proc mkmat*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkmat2*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkmat3*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkmat4*(x: GEN; y: GEN; z: GEN; t: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkmat5*(x: GEN; y: GEN; z: GEN; t: GEN; u: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkmatcopy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkpolmod*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkqfi*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkquad*(n: GEN; x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkrfrac*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkrfraccopy*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkvec*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkvec2*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkvec2copy*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkvec2s*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkvec3*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkvec3s*(x: clong; y: clong; z: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkvec4*(x: GEN; y: GEN; z: GEN; t: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkvec4s*(x: clong; y: clong; z: clong; t: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkvec5*(x: GEN; y: GEN; z: GEN; t: GEN; u: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkveccopy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mkvecs*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkvecsmall*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkvecsmall2*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkvecsmall3*(x: clong; y: clong; z: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mkvecsmall4*(x: clong; y: clong; z: clong; t: clong): GEN {.cdecl, importc, dynlib: libname.}
proc mpcosz*(x: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mpexpz*(x: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mplogz*(x: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mpsinz*(x: GEN; z: GEN) {.cdecl, importc, dynlib: libname.}
proc mul_content*(cx: GEN; cy: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc mul_denom*(cx: GEN; cy: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc nbits2nlong*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc nbits2extraprec*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc nbits2prec*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc nbits2lg*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc nbrows*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc nchar2nlong*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc ndec2nlong*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc ndec2prec*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc normalize_frac*(z: GEN) {.cdecl, importc, dynlib: libname.}
proc odd*(x: clong): cint {.cdecl, importc, dynlib: libname.}
proc pari_free*(pointer: pointer) {.cdecl, importc, dynlib: libname.}
proc pari_calloc*(size: csize): pointer {.cdecl, importc, dynlib: libname.}
proc pari_malloc*(bytes: csize): pointer {.cdecl, importc, dynlib: libname.}
proc pari_realloc*(pointer: pointer; size: csize): pointer {.cdecl, importc, dynlib: libname.}
proc perm_conj*(s: GEN; t: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc perm_inv*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc perm_mul*(s: GEN; t: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc pol_0*(v: clong): GEN {.cdecl, importc, dynlib: libname.}
proc pol_1*(v: clong): GEN {.cdecl, importc, dynlib: libname.}
proc pol_x*(v: clong): GEN {.cdecl, importc, dynlib: libname.}
proc pol0_F2x*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc pol1_F2x*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc polx_F2x*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc pol0_Flx*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc pol1_Flx*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc polx_Flx*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc polx_zx*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc powii*(x: GEN; n: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc powIs*(n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc prec2nbits*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc prec2nbits_mul*(x: clong; y: cdouble): cdouble {.cdecl, importc, dynlib: libname.}
proc prec2ndec*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc precdbl*(x: clong): clong {.cdecl, importc, dynlib: libname.}
proc quad_disc1*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc qfb_disc*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc qfb_disc3*(x: GEN; y: GEN; z: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc quadnorm*(q: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc random_bits*(k: clong): clong {.cdecl, importc, dynlib: libname.}
proc remsBIL*(n: clong): clong {.cdecl, importc, dynlib: libname.}
proc resultant*(x: GEN; y: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc row*(A: GEN; x1: clong): GEN {.cdecl, importc, dynlib: libname.}
proc row_Flm*(A: GEN; x0: clong): GEN {.cdecl, importc, dynlib: libname.}
proc row_i*(A: GEN; x0: clong; x1: clong; x2: clong): GEN {.cdecl, importc, dynlib: libname.}
proc row_zm*(x: GEN; i: clong): GEN {.cdecl, importc, dynlib: libname.}
proc rowcopy*(A: GEN; x0: clong): GEN {.cdecl, importc, dynlib: libname.}
proc rowpermute*(A: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc rowslice*(A: GEN; x1: clong; x2: clong): GEN {.cdecl, importc, dynlib: libname.}
proc rowslicepermute*(A: GEN; p: GEN; x1: clong; x2: clong): GEN {.cdecl, importc, dynlib: libname.}
proc shallowcopy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc sqrfrac*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc sqrti*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc sqrtnr*(x: GEN; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc sqrtr*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc pari_stack_alloc*(s: ptr pari_stack; nb: clong) {.cdecl, importc, dynlib: libname.}
proc pari_stack_base*(s: ptr pari_stack): ptr pointer {.cdecl, importc, dynlib: libname.}
proc pari_stack_delete*(s: ptr pari_stack) {.cdecl, importc, dynlib: libname.}
proc pari_stack_init*(s: ptr pari_stack; size: csize; data: ptr pointer) {.cdecl, importc, dynlib: libname.}
proc pari_stack_new*(s: ptr pari_stack): clong {.cdecl, importc, dynlib: libname.}
proc pari_stack_pushp*(s: ptr pari_stack; u: pointer) {.cdecl, importc, dynlib: libname.}
proc sturm*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc truecoeff*(x: GEN; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc trunc_safe*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc vec_ei*(n: clong; i: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vec_lengthen*(v: GEN; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vec_setconst*(v: GEN; x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc vec_shorten*(v: GEN; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vec_to_vecsmall*(z: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc vecpermute*(A: GEN; p: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc vecreverse*(A: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc vecslice*(A: GEN; y1: clong; y2: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vecslicepermute*(A: GEN; p: GEN; y1: clong; y2: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vecsplice*(a: GEN; j: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmall_append*(V: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmall_coincidence*(u: GEN; v: GEN): clong {.cdecl, importc, dynlib: libname.}
proc vecsmall_concat*(u: GEN; v: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmall_copy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmall_ei*(n: clong; i: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmall_indexmax*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc vecsmall_indexmin*(x: GEN): clong {.cdecl, importc, dynlib: libname.}
proc vecsmall_isin*(v: GEN; x: clong): clong {.cdecl, importc, dynlib: libname.}
proc vecsmall_lengthen*(v: GEN; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmall_lexcmp*(x: GEN; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc vecsmall_max*(v: GEN): clong {.cdecl, importc, dynlib: libname.}
proc vecsmall_min*(v: GEN): clong {.cdecl, importc, dynlib: libname.}
proc vecsmall_pack*(V: GEN; base: clong; `mod`: clong): clong {.cdecl, importc, dynlib: libname.}
proc vecsmall_prefixcmp*(x: GEN; y: GEN): cint {.cdecl, importc, dynlib: libname.}
proc vecsmall_prepend*(V: GEN; s: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmall_shorten*(v: GEN; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmall_to_col*(z: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmall_to_vec*(z: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc vecsmalltrunc_append*(x: GEN; t: clong) {.cdecl, importc, dynlib: libname.}
proc vecsmalltrunc_init*(pari_l: clong): GEN {.cdecl, importc, dynlib: libname.}
proc vectrunc_append*(x: GEN; t: GEN) {.cdecl, importc, dynlib: libname.}
proc vectrunc_append_batch*(x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}
proc vectrunc_init*(pari_l: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zc_to_ZC*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc zero_F2m*(n: clong; m: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_F2m_copy*(n: clong; m: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_F2v*(m: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_F2x*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_Flm*(m: clong; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_Flm_copy*(m: clong; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_Flv*(n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_Flx*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_zm*(x: clong; y: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_zv*(x: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zero_zx*(sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zerocol*(n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zeromat*(m: clong; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zeromatcopy*(m: clong; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zeropadic*(p: GEN; e: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zeropadic_shallow*(p: GEN; e: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zeropol*(v: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zeroser*(v: clong; e: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zerovec*(n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zm_copy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc zm_to_zxV*(x: GEN; sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zm_transpose*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc zv_copy*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc zv_to_ZV*(x: GEN): GEN {.cdecl, importc, dynlib: libname.}
proc zv_to_zx*(x: GEN; sv: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zx_renormalize*(x: GEN; pari_l: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zx_shift*(x: GEN; n: clong): GEN {.cdecl, importc, dynlib: libname.}
proc zx_to_zv*(x: GEN; N: clong): GEN {.cdecl, importc, dynlib: libname.}
proc err_get_compo*(e: GEN; i: clong): GEN {.cdecl, importc, dynlib: libname.}
proc err_get_num*(e: GEN): clong {.cdecl, importc, dynlib: libname.}

proc pari_err_BUG*(f: cstring) {.cdecl, importc, dynlib: libname.}

proc pari_err_COMPONENT*(f: cstring; op: cstring; pari_l: GEN; x: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_CONSTPOL*(f: cstring) {.cdecl, importc, dynlib: libname.}

proc pari_err_COPRIME*(f: cstring; x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_DIM*(f: cstring) {.cdecl, importc, dynlib: libname.}

proc pari_err_DOMAIN*(f: cstring; v: cstring; op: cstring; pari_l: GEN; x: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_FILEc*(f: cstring; g: cstring) {.cdecl, importc, dynlib: libname.}

proc pari_err_FLAG*(f: cstring) {.cdecl, importc, dynlib: libname.}

proc pari_err_IMPL*(f: cstring) {.cdecl, importc, dynlib: libname.}

proc pari_err_INV*(f: cstring; x: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_IRREDPOL*(f: cstring; x: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_MAXPRIME*(c: pari_ulong) {.cdecl, importc, dynlib: libname.}

proc pari_err_MODULUS*(f: cstring; x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_OP*(f: cstring; x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_OVERFLOW*(f: cstring) {.cdecl, importc, dynlib: libname.}

proc pari_err_PACKAGE*(f: cstring) {.cdecl, importc, dynlib: libname.}

proc pari_err_PREC*(f: cstring) {.cdecl, importc, dynlib: libname.}

proc pari_err_PRIME*(f: cstring; x: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_PRIORITY*(f: cstring; x: GEN; op: cstring; v: clong) {.cdecl, importc, dynlib: libname.}

proc pari_err_SQRTN*(f: cstring; x: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_TYPE*(f: cstring; x: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_TYPE2*(f: cstring; x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_VAR*(f: cstring; x: GEN; y: GEN) {.cdecl, importc, dynlib: libname.}

proc pari_err_ROOTS0*(f: cstring) {.cdecl, importc, dynlib: libname.}
var SQRI_KARATSUBA_LIMIT*: clong

var MULII_KARATSUBA_LIMIT*: clong

var MULRR_MULII_LIMIT*: clong

var SQRI_FFT_LIMIT*: clong

var MULII_FFT_LIMIT*: clong

var Fp_POW_REDC_LIMIT*: clong

var Fp_POW_BARRETT_LIMIT*: clong

var INVMOD_GMP_LIMIT*: clong

var DIVRR_GMP_LIMIT*: clong

var Flx_MUL_KARATSUBA_LIMIT*: clong

var Flx_SQR_KARATSUBA_LIMIT*: clong

var Flx_MUL_HALFMULII_LIMIT*: clong

var Flx_SQR_HALFSQRI_LIMIT*: clong

var Flx_MUL_MULII_LIMIT*: clong

var Flx_SQR_SQRI_LIMIT*: clong

var Flx_MUL_MULII2_LIMIT*: clong

var Flx_SQR_SQRI2_LIMIT*: clong

var Flx_INVBARRETT_LIMIT*: clong

var Flx_DIVREM_BARRETT_LIMIT*: clong

var Flx_REM_BARRETT_LIMIT*: clong

var Flx_BARRETT_LIMIT*: clong

var Flx_HALFGCD_LIMIT*: clong

var Flx_GCD_LIMIT*: clong

var Flx_EXTGCD_LIMIT*: clong

var FpX_INVBARRETT_LIMIT*: clong

var FpX_DIVREM_BARRETT_LIMIT*: clong

var FpX_REM_BARRETT_LIMIT*: clong

var FpX_BARRETT_LIMIT*: clong

var FpX_HALFGCD_LIMIT*: clong

var FpX_GCD_LIMIT*: clong

var FpX_EXTGCD_LIMIT*: clong

var EXPNEWTON_LIMIT*: clong

var INVNEWTON_LIMIT*: clong

var LOGAGM_LIMIT*: clong

var LOGAGMCX_LIMIT*: clong

var AGM_ATAN_LIMIT*: clong

var RgX_SQR_LIMIT*: clong

var RgX_MUL_LIMIT*: clong

#--

proc newGEN*(a: string): Gen=
  gp_read_str(a)
proc newGEN*(a: GEN): Gen=
  gcopy(a)
proc newGEN*(a: int): Gen=
  stoi(a)
proc newGEN*(a: float): Gen=
  dbltor(a)
proc newGEN*(): Gen=
  gcopy(gen_0)


## #operators Macros
import macros

proc op2swap(op2: NimNode, pariop: NimNode): string {.inline.} =
  result = "proc `" & (op2.strval) & "`*(a:Gen, b:int):Gen=" & (pariop.strval) & "gs(a,b)\n"
  result &= "proc `" & (op2.strval) & "`*(a:int, b:Gen):Gen=" & (pariop.strval) & "(newGEN(a),b)\n"
  result &= "proc `" & (op2.strval) & "`*(a:Gen, b:float64):Gen=" & (pariop.strval) & "(a,newGEN(b))\n"
  result &= "proc `" & (op2.strval) & "`*(a:float64, b: Gen):Gen=" & (pariop.strval) & "(newGEN(a),b)\n"

macro ops(op2: string, pariop: string): stmt =
  var res =  "proc `" & (op2.strval) & "`*(a:Gen, b:Gen):Gen {.inline.}=" & (pariop.strval) & "(a,b)\n"
  res &= op2swap(op2, pariop)
  result = parseStmt(res)

ops("+","gadd")
ops("*","gmul")
ops("/","gdiv")
ops("-","gsub")
ops("^","gpow")

macro cmpg(op:string): stmt=
  parseStmt("proc `"& op.strval & "`*(a,b:GEN):bool=gcmp(a,b)" & op.strval & "0")
cmpg("==")
cmpg("<")
cmpg("<=")
cmpg(">=")
cmpg(">")
cmpg("!=")

proc `<<`*(a: GEN, num: clong):GEN=gshift(a,num)
proc `>>`*(a: GEN, num: clong):GEN=gshift(a,-num)

proc max*(a, b: GEN):GEN=gmax(a,b)
proc min*(a, b: GEN):GEN=gmin(a,b)

proc `mod`*(a,b: GEN):GEN= gmod(a,b)

proc `$`*(a:Gen):string =
  $Gentostr(a)

proc toInt*(a:GEN ): clong= itos_or_0(a)
proc toFloat*(a:Gen):float= gtodouble(a)
proc toStr*(a:Gen):string= $a

proc gel*(g:GEN, pos: int ):GEN=safegel(g, pos)[]
