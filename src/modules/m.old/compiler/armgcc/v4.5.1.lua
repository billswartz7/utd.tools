whatis("Description: ARM cross-compiler and linker ")
help(
[[
The ARM cross-compiler is GNU compiler (gcc version 4.5.1) which is generates ARM compatible assembly and machine code.

To launch the cross compiler program run the command

arm-unknown-elf-gcc

To use the arm cross compiler to generate assembly code use:
arm-unknown-elf-gcc -S <filename.c>

To use the arm cross compiler to generate machine code use:
arm-unknown-elf-gcc -c <filename.c>

To use the arm cross compiler to generate optimized machine code use:
arm-unknown-elf-gcc -O2 -c <filename.c>

To use the arm cross compiler to generate optimized machine code with assembly code use:
arm-unknown-elf-gcc -O2 -S -c <filename.c>

To use the arm cross compiler to generate debug code used the -g option
arm-unknown-elf-gcc -g -O2 -S -c <filename.c>

To generate a full program omit the -c
arm-unknown-elf-gcc -g -O2 -S <filename.c>

Other useful commands:

To read the ELF (Executable and Linkable Format)
arm-unknown-elf-readelf -a <programName>

To dump the object of a program by disassemblying
arm-unknown-elf-objdump -d <programName>

]])

local base = "/home/cad/ee5325/armcross"
local bin_path = string.format('%s/bin', base)
local lib_path = string.format('%s/lib', base)

prepend_path("PATH", bin_path)
prepend_path("LD_LIBRARY_PATH", lib_path)
