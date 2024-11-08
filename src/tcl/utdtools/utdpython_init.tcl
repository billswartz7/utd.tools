#!/usr/local/bin/wish -f
#
# $Id: twpython_init.tcl,v 1.1 2019/08/26 14:13:56 bills Exp $
# $Log: twpython_init.tcl,v $
# Revision 1.1  2019/08/26 14:13:56  bills
# Initial revision
#

namespace eval utdpython {
  variable python_interpS ""
  variable initS 0

  proc init {args} {
    variable initS
    variable python_interpS

    package require utdpython
    set python_interpS [utdpython create]
    puts stderr "Created Python Interpreter: $python_interpS"
    # Make sure to import the utdtcl module
    $python_interpS exec {
import utdtcl
    }
    incr initS

  }

  proc interpreter {args} {
    variable python_interpS
    return $python_interpS
  }
  proc mode {args} {
    variable initS
    set debug_flag false
    set num_args [llength $args]
    for {set i 0} {$i < $num_args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-debug" } {
	set debug_flag true
      } elseif {$arg_el == "tcl" } {
	utdinterpreter_mode tcl
      } elseif {$arg_el == "tcl_python" } {
	if {$initS == 0} {
	  ::utdpython::init
	}
	utdinterpreter_mode tcl_python
      } elseif {$arg_el == "python" } {
	if {$initS == 0} {
	  ::utdpython::init
	}
	puts stderr "about to enter python mode."
	utdinterpreter_mode python
      } else {
	puts stderr "unknown mode: $arg_el"
      }
    }
    return [utdinterpreter_mode]
  }
}
