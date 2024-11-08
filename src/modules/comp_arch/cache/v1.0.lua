whatis("Description: Cache Memory Practice is teaching tool to help students understand cache computer memory")
help(
[[
The memory practice tool is a Tcl/Tk script program running under the TimberWolf placement and
route system.

To launch the graphical program run the command
  cachepractice

Use 
  cachepractice low_res

to execute the tool when only low resolution graphics settings are available.

]])

-- Need to make of the form: "/proj/cad/synopsys/synopsys-2013.lnx86_64"
local cache_path = "/home/cad/ee4304/cache"

append_path("PATH", cache_path)
