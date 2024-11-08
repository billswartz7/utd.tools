whatis("Description: Latest GCC compiler and linker.  Native x86_64 Linux")
help(
[[
This GCC C and C++ compiler is a GNU compiler (gcc version 7.3.0) which supports the latest version of C++17 features.

To launch the compiler program run the command

gcc
for C or 
g++
for C++

after the module is installed.

The following tools are present and available in this module:
c++
cpp
g++
gcc
gcc-ar
gcc-nm
gcc-ranlib
gcov
gcov-dump
gcov-tool

]])

local base = "/home/cad/ee4304/latestgcc"
local bin_path = string.format('%s/bin', base)
local lib_path = string.format('%s/lib', base)

prepend_path("PATH", bin_path)
prepend_path("LD_LIBRARY_PATH", lib_path)
