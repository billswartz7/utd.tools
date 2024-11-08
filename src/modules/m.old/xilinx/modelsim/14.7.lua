whatis("Description: Xilinx integrated design system environment ")
help(
[[
Xilinx ISE is a graphical integrated design environment for simulating and implementing FPGAs manufactured by Xilinx.  Using the Xilinx integrated editor, you can create, simulate, and develop designs written in either the Verilog or VHDL languages.  You can design either using a structural description or unleash the power of behavioral synthesis.

To launch Xilinx run the command
  ise
]])

local version = "14.7"
local license_file = "2100@engls"
local lm_license_file = "2100@engls"
local mgsl_license_file = "1717@engdmv"

local base = string.format('/proj/cad/xilinx_%s/%s/ISE_DS', version, version)
local ise_bin_path = string.format('%s/ISE/bin/lin64', base)
setenv( "ISE_BIN_PATH", ise_bin_path)

local ise_lib_path = string.format('%s/ISE/lib/lin64', base)
setenv( "ISE_LIB_PATH", ise_lib_path)

local plan_ahead_path = string.format('%s/PlanAhead/bin', base)
setenv( "PLANAHEAD_PATH", plan_ahead_path)

local edk_path = string.format('%s/EDK/bin/lin64', base)
setenv( "EDK_PATH", edk_path)

local common_path = string.format('%s/common/bin/lin64', base)
setenv( "COMMON_PATH", common_path)

local mgc_os = "lnx86"
local mgc_base = "/proj/cad/mentor"
local mgc_home = string.format('%s/cal_2011.1_36.23.%s', mgc_base, mgc_os)
local mgc_home_path = string.format('%s/bin', mgc_home )
local modeltech_path = string.format('%s/modeltech.%s/modeltech/bin', mgc_base, mgc_os )

prepend_path("PATH", common_path)
prepend_path("PATH", edk_path)
prepend_path("PATH", plan_ahead_path)
prepend_path("PATH", ise_lib_path)
prepend_path("PATH", ise_bin_path)

prepend_path("PATH", mgc_home_path)
append_path("PATH", modeltech_path)

setenv("XILINXD_LICENSE_FILE", license_file)
setenv("LM_LICENSE_FILE", lm_license_file )

setenv("MGC_HOME", mgc_home )
setenv("MGLS_LICENSE_FILE", mgsl_license_file)
