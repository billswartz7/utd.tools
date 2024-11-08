utdpython::mode tcl_python
utdtcl.eval("source vars.tcl")
dsn = 'foo'
print ( dsn )
extra_new_design = 'whatUp'
dsn = utdcomet::name_set(extra_new_design)
puts('stderr','design in Tcl afterwards:$dsn')
print(f'dsn in Python afterwards = {dsn}')
print(f'extra_new_design = {extra_new_design}')
