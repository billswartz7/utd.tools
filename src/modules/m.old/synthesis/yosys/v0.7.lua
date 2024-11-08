whatis("Description: Yosys: A system for RTL synthesis and optimization using ABC")
help(
[[
The Yosys synthesis system is an interactive tool which reads Hardware
Description Languages (HDL), performs technology mapping and logic
network optimiziation using ABC.  ABC uses AIG and 
BDD structures to synthesize and simplify Boolean networks.
For more info, go to https://people.eecs.berkeley.edu/~alanmi/abc

To launch the command line interface enter
  yosys
]])
local yosys_path = "/home/cad/ee5325/utdtools/yosys/bin"
local utdtools_path = "/home/cad/ee5325/utdtools"
local extra_lib = "/home/cad/ee5325/utdtools/tcl/lib"

setenv( "UTDTOOLS", utdtools_path)
prepend_path("PATH", yosys_path)
prepend_path("LD_LIBRARY_PATH", extra_lib )
