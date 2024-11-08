whatis("Description: ABC: A system for sequential synthesis and verification")
help(
[[
The ABC synthesis system is an interactive tool which uses AIG and 
BDD structures to synthesize and simplify Boolean networks.
For more info, go to https://people.eecs.berkeley.edu/~alanmi/abc

To launch the command line interface enter
  abc
]])

local abc_path = "/home/cad/ee6301/abc/v1"

append_path("PATH", abc_path)
