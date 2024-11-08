whatis("Description: CPLEX is an Interactive Optimizer able compute linear and quadratic mathematical programs.")
help(
[[
CPLEX is an Interactive Optimizer which can solve linear programs known as LPs.  
The LPs may be contain continuous, integer, or mixture of both types.  CPLEX has 
Simplex, Primal/Dual, Barrier Optimizer, and Mixed Integer Branch and Bound 
algorithms at your disposal.  This module allows access to the interactive solver
but CPLEX is much more.  One can write C/C++ programs and incorporate CPLEX library
functions to solve your problems.   See the documentation under
file://home/cad/ibm/cplex/doc/html/en-US/

There are two ways of running CPLEX: interactive and batch mode.  Please
run batch mode if all possible because it allows more students to use the
tools without locking licenses.   Thanks.


To launch the batch version of CPLEX run the command
  cplex_run <linearProgramFile> 
  cplex_run <linearProgramFile> <mode>

To launch the interactive version of CPLEX use
  cplex

]])

-- Need to add batch path
local cplex_batch_path = "/home/cad/ee6301/bin"
append_path("PATH", cplex_batch_path)

-- Need to add base program path
local cplex_path = "/home/cad/ibm/cplex/cplex/bin/x86-64_sles10_4.1"
append_path("PATH", cplex_path)
