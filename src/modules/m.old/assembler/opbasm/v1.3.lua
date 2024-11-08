whatis("Description: OPBASM: The Open PicoBlaze Assembler program for Xilinx FPGAs")
help(
[[
The OPBASM Python3 script is an assember targeting Xilinx FPGAs.  A working
PicoBlaze micro-controller consists of three pieces:

1) the Xilinx PicoBlaze micro controller,
2) your circuit where you reference the micro controller,
3) your program

The template files necessary for all three pieces may be checked out
of opbasm by issuing the command:

opbasm.py -g

You will receive:
kcpsm6.v : the PicoBlaze micro controller in Verilog from Xilinx

kcpsm6_design_template.v : generalized template for connecting design 
                           from Xilinx.
myprocessor.v : any example where the connection has been performed 

ROM_form_JTAGLoader_14March13.v : template to generate your program from .psm

In normal use, you will generate your .psm file and convert it to Verilog
using the following command:

opbasm.py -t ROM_form_JTAGLoader_14March13.v <PSM_file>

For example, if my .psm file is named sum.psm, you should enter:

opbasm.py -t ROM_form_JTAGLoader_14March13.v sum.psm

In this case obpasm, will generate sum.v to include in your Verilog project.
You will put kcpsm6.v, some variant of kcpsm6_design_template.v, and sum.v into
your Xilinx project.

To launch the command line interface enter
  opbasm.py
for it's help function.   See also compiler/sdcc for converting C into PSM.

]])
local opbasm_path = "/home/cad/ee4370/bin"
local utdtools_path = "/home/cad/ee5325/utdtools"
local extra_lib = "/home/eng/w/wps100020/fpga/itools.2.0.1a/lib/Linux-x86_64"
local python_home_path = "/home/eng/w/wps100020/fpga/itools.2.0.1a/lib/Linux-x86_64/python"
local python_path = "/home/eng/w/wps100020/.local/lib/python3.7/site-packages"

setenv("TWPYTHONHOME",python_home_path)
setenv("TWPYTHONPATH",python_path)
append_path("PATH", opbasm_path)
append_path("LD_LIBRARY_PATH", extra_lib )
