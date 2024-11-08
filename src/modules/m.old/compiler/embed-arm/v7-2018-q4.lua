whatis("Description: Latest Embedded ARM GCC cross compiler, linker and debugger")
help(
[[
This GCC C, C++ compiler, and GDB debugger is the ARM embedded toolchain for development of embedded systems.

To launch the compiler program run the command

arm-none-eabi-gcc
for C or 
arm-none-eabi-g++
for C++

after the module is installed.

The following tools are present and available in this module:
arm-none-eabi-addr2line
arm-none-eabi-ar
arm-none-eabi-as
arm-none-eabi-c++
arm-none-eabi-c++filt
arm-none-eabi-cpp
arm-none-eabi-elfedit
arm-none-eabi-g++
arm-none-eabi-gcc
arm-none-eabi-gcc-7.3.1
arm-none-eabi-gcc-ar
arm-none-eabi-gcc-nm
arm-none-eabi-gcc-ranlib
arm-none-eabi-gcov
arm-none-eabi-gcov-dump
arm-none-eabi-gcov-tool
arm-none-eabi-gdb
arm-none-eabi-gdb-py
arm-none-eabi-gprof
arm-none-eabi-ld
arm-none-eabi-ld.bfd
arm-none-eabi-nm
arm-none-eabi-objcopy
arm-none-eabi-objdump
arm-none-eabi-ranlib
arm-none-eabi-readelf
arm-none-eabi-size
arm-none-eabi-strings
arm-none-eabi-strip


]])

local base = "/home/cad/ee4370/arm-embed/gcc-arm-none-eabi-7-2018-q4-major"
local bin_path = string.format('%s/bin', base)
local lib_path = string.format('%s/lib/gcc/arm-none-eabi/7.3.1', base)

prepend_path("PATH", bin_path)
prepend_path("LD_LIBRARY_PATH", lib_path)
