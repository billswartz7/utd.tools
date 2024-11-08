whatis("Description: Code Composer Studio is an Integrated Design Environment for TI Microcontrollers ")
help(
[[
Code Composer Studio is an Integrated Design Environment (IDE) which enables you to program and test microcontrollers from Texas Instruments such at the MSP430xxx family of microcontrollers.

To launch Code Composer Studio, on the command line type
  ccstudio
]])

local version = "6.1.2"

local base = "/usr/local/ti"
local ccs_path = string.format('%s/ccsv6/eclipse', base)

prepend_path("PATH", ccs_path)
