package require utdpython
set a [utdpython create]
puts stderr "Python interpreter handle:$a"

$a exec {
exec(open("test.py").read())
}
$a exec {foo(500)}

