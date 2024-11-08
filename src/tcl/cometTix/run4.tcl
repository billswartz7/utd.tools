utdpython::mode python
print('In Python mode')
def foo(i):
    print(i)
    print(i+1)
print(dir(__builtins__))
foo(504)
utdtcl.eval("source vars.tcl")
utdtcl.eval("set a 1")
a =  4
utdtcl.eval('puts stderr "a:$a"')
print('Changing to Tcl...')
utdtcl.trans('dsn = utdcomet::name_set(extra_new_design)')
print(f'The operating mode is: {utdtcl.mode()}')
utdtcl.mode('tcl')

puts stderr "we are in Tcl: a is $a"
puts stderr "In this mode we can explicitly call individual Python interpreters"
set a [utdpython::interpreter]
$a exec {
exec(open("test.py").read())
}
$a exec {foo(7)}

utdpython::mode python
foo(8)
