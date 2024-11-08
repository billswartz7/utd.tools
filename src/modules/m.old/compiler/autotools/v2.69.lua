whatis("Description: GNU autotools ")
help(
[[
This module allows access to the latest version of autoconf and automake.

Common use:

To scan current source code and directory structure and generate an
initial configure.ac file (which will be named configure.scan)
autoscan

To rerun automake and autoconf automatically use,

autoreconf --install

For more information please visit
http://www.gnu.org/software/automake/manual/automake.html

]])

local base = "/home/cad/ee5325/autotools"
local bin_path = string.format('%s/bin', base)
local lib_path = string.format('%s/lib', base)

prepend_path("PATH", bin_path)
prepend_path("LD_LIBRARY_PATH", lib_path)
