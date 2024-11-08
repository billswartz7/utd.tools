whatis("Description: HSPice is an electrical simulator ")
help(
[[
HSPice is Synopsys's version of the SPICE (Simulation Program with Integrated Circuit
Emphasis) electrical simulator. 

To launch the SPICE simulation program run the command
  hspice
]])

local version = "14.7"
local snpslmd_license_file = "1700@dmv"
local lm_license_file = "1700@dmv"

local base = "/proj/cad/synopsys/synopsys-2010.lnx86_64"
local hspice_path = string.format('%s/hspice/hspice/bin', base)

setenv( "LM_LICENSE_FILE",lm_license_file)
setenv( "SNPSLMD_LICENSE_FILE",snpslmd_license_file)

prepend_path("PATH", hspice_path)
