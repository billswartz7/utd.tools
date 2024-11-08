whatis("Description: Memory Banks Practice is teaching tool to help students understand cache computer memory")
help(
[[
The memory banks practice tool is a Tcl/Tk script program running under the TimberWolf placement and
route system.   This program will ask the user to enter different parameters of a computer memory bank
system and show the clock timing.

To launch the program run the command
  membanks

]])

-- Need to make of the form: "/proj/cad/synopsys/synopsys-2013.lnx86_64"
local membanks_path = "/home/cad/ee4304/membanks"

append_path("PATH", membanks_path)
