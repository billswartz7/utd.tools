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
To launch the vcs simulator alone, enter the following on the command line:
  vcs
]])

local baseyear = "2010"
local year = "2016"
local vcs_version = "vcs-mx_vL-2016.06-SP1-1"
local syn_version = "syn_vL-2016.03-SP3"
local lc_version = "lc_vL-2016.06-SP"
local os = "lnx86_64"
local snpslmd_license_file = "1700@dmv"
local lm_license_file = "1700@dmv"
local malloc_check = "0"
local vcs_arch_override = "linux"
local arch = "suse64"

-- This is complicated by the fact that we have two different Synopsys
-- homes for the two tools

-- Need to make of the form: "/proj/cad/synopsys/synopsys-2016.lnx86_64xxx"
-- export PATH=$PATH:/proj/cad/synopsys/synopsys-2016.lnx86_64_lc_vL-2016.06-SP1/bin
local base = "/proj/cad/synopsys/synopsys"
local synhome_path = string.format('%s-%s.%s', base, baseyear, os )

-- export VCS_HOME=/proj/cad/synopsys/synopsys-2016.lnx86_64_vcs-mx_vL-2016.06-SP1-1
local vcs_synhome_path = string.format('%s-%s.%s_%s', base, year, os, vcs_version )

local syn_path = string.format('%s/bin', synhome_path)
local vcs_home = string.format('%s', vcs_synhome_path)
local vcs_path = string.format('%s/bin', vcs_home)
local ldlib_path = string.format('%s/nt/%s/lib', synhome_path, arch)
local lc_root = string.format('%s-%s.%s_%s', base, year, os, lc_version )
local syn_root = string.format('%s-%s.%s_%s', base, year, os, syn_version )

setenv( "LM_LICENSE_FILE",lm_license_file)
setenv( "SNPSLMD_LICENSE_FILE",snpslmd_license_file)
setenv( "VCS_HOME",vcs_home)
setenv( "MALLOC_CHECK", malloc_check)
setenv( "VCS_ARCH_OVERRIDE", vcs_arch_override)
setenv( "SYNOPSYS_SYN_ROOT", syn_root)
setenv( "SYNOPSYS_LC_ROOT", lc_root)

prepend_path("PATH", syn_path)
append_path("PATH", vcs_path)
-- append_path("LD_LIBRARY_PATH", ldlib_path)
