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

local base = string.format('/proj/cad/_xilinx_%s_DELETE_/%s/ISE_DS', version, version)
local ise_bin_path = string.format('%s/ISE/bin/lin64', base)
setenv( "ISE_BIN_PATH", ise_bin_path)
unsetenv( "QT_PLUGIN_PATH")

local ise_lib_path = string.format('%s/ISE/lib/lin64', base)
setenv( "ISE_LIB_PATH", ise_lib_path)

local plan_ahead_path = string.format('%s/PlanAhead/bin', base)
setenv( "PLANAHEAD_PATH", plan_ahead_path)

local edk_path = string.format('%s/EDK/bin/lin64', base)
setenv( "EDK_PATH", edk_path)

local common_path = string.format('%s/common/bin/lin64', base)
setenv( "COMMON_PATH", common_path)

prepend_path("PATH", common_path)
prepend_path("PATH", edk_path)
prepend_path("PATH", plan_ahead_path)
prepend_path("PATH", ise_lib_path)
prepend_path("PATH", ise_bin_path)

setenv("XILINXD_LICENSE_FILE", license_file)
setenv("LM_LICENSE_FILE", lm_license_file )
