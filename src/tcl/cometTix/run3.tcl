utdpython::init
source vars.tcl
set a [utdpython::interpreter]
global bG
set bG 14
set c 15
set design "our_design"
set dsn [::utdcomet::name_set $design]

$a exec {
print("writing builtins")
print(dir(__builtins__))
}
$a exec {
print("calling explicit code")
utdtcl.eval("set a 1")
utdtcl.eval('puts stderr "a:$a"')
utdtcl.eval('puts stderr "bG:$bG"')
utdtcl.eval('puts stderr "c:$c"')
utdtcl.eval('puts stderr "design:$design"')
utdtcl.eval('set dsn [::utdcomet::name_set new_design]')
utdtcl.eval('puts stderr "design after:$dsn"')
print(utdtcl.trans('set(bG,1)'))
print(f'bg is now {utdtcl.trans("set(bG,1)")} ')
utdtcl.trans('dsn = utdcomet::name_set(extra_new_design)')
}
puts stderr "we are sill in Tcl!"
