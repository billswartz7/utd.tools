#
#  Copyright (c) 1999 by Internet CAD, Inc.
# 
# @(#)$RCSfile: nextpage.tcl,v $ $Revision: 1.9 $ $Date: 2022/11/06 15:56:17 $
# $Log: nextpage.tcl,v $
# Revision 1.9  2022/11/06 15:56:17  bills
# Updated to use the twez namespace to avoid name clashes and
# to reorganize the code better.
#
# Revision 1.8  2005/02/01 17:58:19  bills
# Added support for adding links for PDF documentation.
#
# Revision 1.7  2004/06/18  19:17:01  bills
# Modified so that the user cannot change hypertext while a program
# is running.
#
# Revision 1.6  2003/01/31  15:48:17  bills
# Major rewrite of EZ so we can support projects.  We introduced the
# E_xxx variable and changed many variables from P_xxx to S_xxx so
# we can make the users life easier.
#
# Revision 1.5  1999/06/17  11:01:14  bills
# Updated for iTools name change.
#
# Revision 1.4  1998/07/21  21:59:55  bills
# Modified tcl so that autosaving will work properly.
#
# Revision 1.3  1998/07/16  18:43:50  bills
# Now next page works in plugin.
#
# Revision 1.2  1996/05/05  15:09:07  bills
# Added Copyright.
#
#

namespace eval twez {
  proc ez_nextpage {w page} {
      variable configS

      puts stderr "debug: entered ez_nextpage: $w $page"
      if {$page == "configure"} {
	if {$configS(S_lesson) == ""} {
	  return
	} else {
	  set page lesson
	}
      }

      set pagename [$configS(E_notebook) pagecget $page -label]
      puts stderr "debug: pagename: $pagename"

      tixButtonBox $w.npage -orientation horizontal
      $w.npage add goto -text "Next Page:$pagename" -underline 0 \
	  -command "::twez::ez_raise_page $page"

      # Now set the color of the buttons
      catch {$w.npage subwidget goto config -bg blue -fg white \
	-activebackground white -activeforeground blue} result

      pack $w.npage -side bottom -fill x

      if {([info exists configS(P_dumping_doc)])} {
	set rcmd "$configS(E_rcmd,$page)"
	set href [lindex $rcmd 3]
	set base_file [file tail $href]
	set next_page [file dirname $href]
	set relative [file tail $next_page]
	set new_href "../${relative}/${base_file}"
	::ezdumphtml::create_href "-&gt;" $new_href
      }

  }

  proc ez_raise_page {page} {
      variable configS

      if {[info exists configS(rendering_locked)]} {
	icalert_user errmsg ez:rerender \
	"Changing the notebook page is not possible when a program is running.  Either kill the \
  program with pid:$ic(rendering_locked) or wait for it to finish. If the \
  program was started inside an EZ window, make sure to hit the Exit button."
	return ;
      }

      $configS(E_notebook) raise $page
  }
}
