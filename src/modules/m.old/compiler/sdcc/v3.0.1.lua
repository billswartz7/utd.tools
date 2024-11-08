whatis("Description: PicoBlaze Small C Compiler")
help(
[[
This is a C cross compiler to generate PicoBlaze micro-controller
assembly code or a .psm file.
To use the compiler type

sdcc <C filename>

Afterwards, you can user opbasm using module assembler/opbasm to 
convert this assembly code to Verilog or VHDL to build a custom FPGA
PicoBlaze micro-controller.

]])

local base = "/home/cad/ee5325/sdcc"
local bin_path = string.format('%s/bin', base)

prepend_path("PATH", bin_path)
