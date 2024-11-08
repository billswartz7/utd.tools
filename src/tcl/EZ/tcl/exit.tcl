#
#  Copyright (c) 1999 by Internet CAD, Inc.# 
# @(#)$RCSfile: exit.tcl,v $ $Revision: 1.6 $ $Date: 2022/11/06 15:56:17 $
# $Log: exit.tcl,v $
# Revision 1.6  2022/11/06 15:56:17  bills
# Updated to use the twez namespace to avoid name clashes and
# to reorganize the code better.
#
# Revision 1.5  2022/07/22 21:24:15  bills
# Changed exit.builtin to twexit so we can properly close the graphics.
#
# Revision 1.4  2008/05/12 20:04:17  bills
# Added ez:close_connections so we don't have run on programs.
#
# Revision 1.3  2003/01/31  15:48:17  bills
# Major rewrite of EZ so we can support projects.  We introduced the
# E_xxx variable and changed many variables from P_xxx to S_xxx so
# we can make the users life easier.
#
# Revision 1.2  1999/06/17  11:01:14  bills
# Updated for iTools name change.
#
# Revision 1.1  1998/07/27  21:51:49  bills
# Initial revision
#
#

proc ez_exit { args } {
  puts stderr "calling ez_exit with args: $args"
  ::twez::auto_save
  set abort_exit [::twez::project_save 0]
  if {$abort_exit} {
    return ;
  }
  rename ez_exit {}
  ::twez::close_connections

  if {$args != ""} {
    utdexit $args
  } else {
    utdexit 0
  }
}

namespace eval twez {

  proc close_connections { } {
      variable configS

      if {([info exists configS(rendering_locked)]) && ($configS(rendering_locked) != "")} {
	foreach pid $configS(rendering_locked) {
	  if {[utdpid exists $pid]} {
	    utdpid kill 0
	  }
	}
      }
  }
}
