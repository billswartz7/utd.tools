#
#  Copyright (c) 1999 by TimberWolf Systems, Inc.
# 
#
#


# #######################################################################
# Now execute the TCL.
#
#
set args [utdscript_args]
puts stderr "raw args: $args"
set args [string trimright $args]
set num_args [llength $args]
set routine "ezlearn"
set topic ""
# puts stderr "args: $args num: $num_args"
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "-debug" } {
    lappend options "-debug"
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "-topic" } {
    incr i
    if {$i < $num_args} {
      set topic [lindex $args $i]
    } else {
      utdmsg errmsg $routine "Missing argument to -topic\n"
      return ;
    }

  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  ezlearn.tcl \[-topic <name>]\n\n"
    exit 0
  } else {
    utdmsg errmsg ezterm "Unknown option: $arg_el\n"
    exit 1
  }
}

set ez_tcl_dir [file join [::utdtools::rootdir] share ezlearn tcl]
global auto_path
lappend auto_path $ez_tcl_dir
::twez::EZ
if {$topic != ""} {
  ::twez::set_area $topic
}
