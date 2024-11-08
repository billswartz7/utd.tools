whatis("Description: Design Vision is logical sythesis tool from Synopsys ")
help(
[[
Design Vision is a graphical interface into Synopsys's logic synthesizer. It will
take hardware description languages (HDL) and synthesize them in to gate-level networks.
Both VHDL and Verilog languages are supported.   There is also a command line
version of the program called dc_shell-xg-t.  In addition, the VCS simulator is also 
available from the command line. 

To launch the graphical logic synthesizer program, enter the following on the command line:
  design_vision
To launch the vhdl analyzer, use 
  vhdlan <vhdl_files>
To launch the vcs simulator alone, enter the following on the command line:
  vcs
]])

local synopsys_version = "2018"
local dv_version = "vO-2018.06-SP1"
local vcs_version = "vO-2018.09-1"
local os = "lnx86_64"
local lib_compiler_version = "vL-2016.06-SP1"
local snpslmd_license_file = "1700@engdmv"
local lm_license_file = "1700@engdmv"
local malloc_check = "0"
local vcs_arch_override = "linux"

-- This is complicated by the fact that we have two different Synopsys
-- homes for the two tools

local base = "/proj/cad/synopsys"
local home = "/proj/cad/synopsys/synopsys"

-- Synopsys design vision
local dv_synhome_path = string.format('%s/synopsys_%s/syn_%s', base, synopsys_version, dv_version)
local designvision_path = string.format('%s/bin', dv_synhome_path)

-- lib compiler
local lib_compiler = string.format('%s/lc_%s', base, lib_compiler_version)
local lib_compiler_path = string.format('%s/bin', lib_compiler)

-- VCS MX
local vcs_home = string.format('%s/synopsys_%s/vcs-mx_%s', base, synopsys_version, vcs_version)
local vcs_path = string.format('%s/bin', vcs_home)

-- license info
setenv( "LM_LICENSE_FILE",lm_license_file)
setenv( "SNPSLMD_LICENSE_FILE",snpslmd_license_file)

-- Now set the environment variables and paths
setenv( "SYNOPSYS_BASE",base)
setenv( "SYNOPSYS_HOME",home)

prepend_path("PATH", designvision_path)
setenv( "SYNOPSYS_SYN_ROOT",dv_synhome_path)

-- Library Compiler  lc_shell
prepend_path("PATH", lib_compiler_path)
setenv( "SYNOPSYS_LC_ROOT",lib_compiler)

-- VCS
prepend_path("PATH", vcs_path)
setenv( "VCS_HOME",vcs_home)
setenv( "MALLOC_CHECK", malloc_check)
setenv( "VCS_ARCH_OVERRIDE", vcs_arch_override)

