package require utdpython
set a [utdpython create]
$a exec {
def foo(i):
    print(i)
}
$a exec {foo(501)}

