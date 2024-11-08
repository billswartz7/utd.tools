whatis("Description: IVerilog Verilog/VHDL simulator ")
help(
[[
IVerilog is a Verilog/VDL simulator.

To run the tool use

iverilog : shows the options to the program
iverilog <filenames> : create an ./a.out simulator with given
                       filenames
iverilog -c <command_file> : create an ./a.out simulator with
                      files listed in the <command_file>
iverilog -c <command_file> -o <program_name> : create a simulator
                      with the name <program_name> with the
		      files listed in the <command_file>

]])

local utdtools_path = "/home/eng/w/wps100020/utdtools/utd.tools"
local utdversion = "v1.0.0"
local utdos = "Linux-x86_64"
local utdtools_lib_path = string.format('%s/%s/lib/%s', utdtools_path,utdversion,utdos)
local utdtools_bin_path = string.format('%s/%s/bin/%s', utdtools_path,utdversion,utdos)
setenv( "UTDTOOLS", utdtools_path)
setenv( "UTDTOOLSOS", utdos)
setenv( "UTDTOOLSVERSION", utdversion)
prepend_path("LD_LIBRARY_PATH", utdtools_lib_path)
prepend_path("PATH", utdtools_bin_path)
