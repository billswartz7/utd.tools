whatis("Description: Memory Practice is teaching tool to help students understand computer memory")
help(
[[
The memory practice tool is a Tcl/Tk script program running under the TimberWolf placement and
route system.

To launch the graphical program run the command
  mempractice

Use 
  mempractice low_res

to execute the tool when only low resolution graphics settings are available.
]])

-- Need to make of the form: "/proj/cad/synopsys/synopsys-2013.lnx86_64"
local memory_path = "/home/cad/ee4304/memory"

append_path("PATH", memory_path)
