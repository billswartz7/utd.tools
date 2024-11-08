whatis("Description: ngSpice electrical simulator ")
help(
[[
ngSpice is a general-purpose analog electronic circuit simulator.  It 
is an open source version of the famous electrical simulator name SPICE 
(Simulation Program with Integrated Circuit Emphasis).  It can be used to
verify and predict the electrical behaviour of integrated circuit designs.

To launch ngspice enter the command

ngspice < "spice_file_name"

on the command line.

]])

local version = "27.0"
local ngspice_path = "/home/cad/ee5325/ngspice/bin"

prepend_path("PATH", ngspice_path)


