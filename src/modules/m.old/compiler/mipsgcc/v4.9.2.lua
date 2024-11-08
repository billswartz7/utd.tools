whatis("Description: MIPS cross-compiler and linker using newlib")
help(
[[
The MIPS cross-compiler is GNU compiler (gcc version 4.9.2) which is generates MIPS compatible assembly and machine code.

To launch the cross compiler program run the command

mips-gcc

To use the MIPS cross compiler to generate assembly code use:
mips-gcc -S <filename.c>

To use the MIPS cross compiler to generate machine code use:
mips-gcc -c <filename.c>

To use the MIPS cross compiler to generate optimized machine code use:
mips-gcc -O2 -c <filename.c>

To use the MIPS cross compiler to generate optimized machine code with assembly code use:
mips-gcc -O2 -S -c <filename.c>

To use the MIPS cross compiler to generate debug code used the -g option
mips-gcc -g -O2 -S -c <filename.c>

To generate a full program omit the -c and add the following linking option -Tidt.ld
mips-gcc -Tidt.ld -g -o <programName> -O2 <filename.c>

Other useful commands:

To read the ELF (Executable and Linkable Format)
mips-readelf -a <programName>

To dump the object of a program by disassemblying
mips-objdump -d <programName>

]])

local base = "/home/cad/ee6304/mipscross/Linux"
local bin_path = string.format('%s/bin', base)
local lib_path = string.format('%s/lib', base)

prepend_path("PATH", bin_path)
prepend_path("LD_LIBRARY_PATH", lib_path)
