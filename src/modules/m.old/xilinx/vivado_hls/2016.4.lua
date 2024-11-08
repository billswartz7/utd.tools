whatis("Description: Xilinx High Level Synthesis integrated design system environment ")
help(
[[
Xilinx Vivado HLS is a graphical integrated design environment for simulating and implementing FPGAs manufactured by Xilinx thru the use of high
level languages like C.   Using the Xilinx integrated editor, you can create, simulate, and develop designs written in either C, C++, or SystemC.

To launch Xilinx Vivado HLS run the command
  vivado_hls
]])

local version = "2016.4"
local product = "Vivado_HLS"
-- local license_file = "2100@engls"
-- local lm_license_file = "2100@engls"
-- local mgsl_license_file = "1717@engdmv"

local base = string.format('/proj/cad/xilinx_vivado_design_suite_%s/%s/%s', version, product, version)
local vivado_bin_path = string.format('%s/bin', base)

prepend_path("PATH", vivado_bin_path )

-- Don't know if I need license stuff yet
-- setenv("XILINXD_LICENSE_FILE", license_file)
-- setenv("LM_LICENSE_FILE", lm_license_file )
-- 
-- setenv("MGC_HOME", mgc_home )
-- setenv("MGLS_LICENSE_FILE", mgsl_license_file)
