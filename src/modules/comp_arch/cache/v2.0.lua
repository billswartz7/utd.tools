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

local utdtools_env = "/home/cad/ee4304/utd.tools"
local utdtoolsos_env = "Linux-x86_64"
local utdtools_version_env = "v1.0.0"
local utdtools_library_path = "/home/cad/ee4304/utd.tools/v1.0.0/lib/Linux-x86_64"
local utdtools_path1 = string.format('%s/%s/bin', utdtools_env, utdtools_version_env )
local utdtools_path2 = string.format('%s/%s/bin/%s', utdtools_env, utdtools_version_env, utdtoolsos_env)
 
setenv( "UTDTOOLS",utdtools_env)
setenv( "UTDTOOLSOS",utdtoolsos_env)
setenv( "UTDTOOLSVERSION",utdtools_version_env)
prepend_path("LD_LIBRARY_PATH",utdtools_library_path)
prepend_path("PATH", utdtools_path1)
prepend_path("PATH", utdtools_path2)
