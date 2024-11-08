whatis("Description: Embedded Systems Problem Generator and Autograder")
help(
[[
This module can generate and test students ability to solve and program
problem written in C and C++.

To list a particular design problem use
  autotest show <instance number>
  
  For example,
  autotest show 3

 will display the problem definion for problem instance 3
 if it exists.

]])

-- Need to make of the form: "/proj/cad/synopsys/synopsys-2013.lnx86_64"
local autotest_path = "/home/cad/ee4370/autotest"

append_path("PATH", autotest_path)
