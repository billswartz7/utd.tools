whatis("Description: System C design system environment ")
help(
[[
System C is a design environment for simulating integrated systems using C and C++.

To use Systemc version 2.3.3, you must use a recent version of gcc.  You
many use "module add compiler/gcc" to build programs correctly.
You may copy the example circuits to your home directory.  They may be
found in the /home/cad/ee5325/systemc-2.3.3/examples.tgz
A working example Makefile for the ASIC-World counter may be copied from
the SystemC home directory.   For example:

cp $SYSTEMC_HOME/Makefile .

]])

local version = "2.3.3"
local systemc_path = "/home/cad/ee5325/systemc-2.3.3"

setenv( "SYSTEMC_HOME", systemc_path)


