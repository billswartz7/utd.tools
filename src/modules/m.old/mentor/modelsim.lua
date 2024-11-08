whatis("Description: Modelsim is a digital logic simulator ")
help(
[[
Mentor Modelsim is a simulator for Digital circuits and handles VHDL and Verilog languages.

To launch Modelsim run the command
  vsim
]])

local mgc_os = "lnx86"
local mgsl_license_file = "1717@engdmv"

local mgc_base = "/proj/cad/mentor"
local mgc_home = string.format('%s/cal_2011.1_36.23.%s', mgc_base, mgc_os)
local mgc_home_path = string.format('%s/bin', mgc_home )
local modeltech_path = string.format('%s/modeltech.%s/modeltech/bin', mgc_base, mgc_os )

prepend_path("PATH", mgc_home_path)
append_path("PATH", modeltech_path)

setenv("MGC_HOME", mgc_home )
setenv("MGLS_LICENSE_FILE", mgsl_license_file)
