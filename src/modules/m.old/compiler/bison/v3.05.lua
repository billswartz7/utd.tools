whatis("Description: GNU bison ")
help(
[[
This module allows access to the latest version of the Bison compiler compiler.

Common use:

bison -v <file.y>


]])

local base = "/home/cad/ee4304/bison"
local bin_path = string.format('%s/bin', base)

prepend_path("PATH", bin_path)
