#
#  Copyright (c) 1999 by Internet CAD, Inc.
# 
# @(#)$RCSfile: user.tcl,v $ $Revision: 1.13 $ $Date: 2022/11/06 15:56:17 $
# $Log: user.tcl,v $
# Revision 1.13  2022/11/06 15:56:17  bills
# Updated to use the twez namespace to avoid name clashes and
# to reorganize the code better.
#
# Revision 1.12  2005/02/01 17:58:53  bills
# Added support for adding links for PDF documentation.
#
# Revision 1.11  2003/06/10  17:52:41  bills
# Now make script buttons red so they are easier to see.
#
# Revision 1.10  2003/01/31  15:48:17  bills
# Major rewrite of EZ so we can support projects.  We introduced the
# E_xxx variable and changed many variables from P_xxx to S_xxx so
# we can make the users life easier.
#
# Revision 1.9  2002/09/19  20:46:20  bills
# Now we user lindex $args 0 rather than ez:html_to_list function to
# remove extra parenthesis.
#
# Revision 1.8  2000/04/26  19:07:44  bills
# Added conversion for native browser so we can use arglist properly for
# ez_button.
#
# Revision 1.7  1999/06/17  11:01:14  bills
# Updated for iTools name change.
#
# Revision 1.6  1998/08/07  02:00:15  bills
# Changed S_developer from saved to persistent variable.
#
# Revision 1.5  1998/07/16  18:46:12  bills
# Added autorerender capability.
#
# Revision 1.4  1996/05/29  20:12:09  bills
# Added more comment and simplified the code for explanatory purposes.
#
# Revision 1.3  1996/05/05  15:05:04  bills
# Added developer mode and modified ez_message.
#
#


namespace eval twez {
  proc ez_user {w} {
      # Get the global variable which holds the current user state.
      variable configS

      # Set the parameters which control the display of Tix combo box.
      set name [tixOptionName $w]
      option add *$name*TixComboBox*label.width 16
      option add *$name*TixComboBox*label.anchor e
      option add *$name*TixComboBox*entry.width 20
      
      # Make sure to turn off history.  Causes problems in rerendering.
      # Create a combo box which we will configure to become a pull down menu.
      tixComboBox $w.user -label "Level of Expertise" \
	  -editable false -dropdown true -command "::twez::user:select_user $w.user" \
	  -history 0
   
      # Insert the options into the pulldown menu
      $w.user insert end Novice
      $w.user insert end Intermediate
      $w.user insert end Expert
      if {$configS(E_developer)} {
	$w.user insert end Developer
      }

      # Now lets set it to the current user mode.
      tixSetSilent $w.user $configS(S_user)

      # Now pack the widget so we can see the embedded window.
      pack $w.user -side top -padx 20 -anchor center -pady 3

  }

  proc user:select_user {w s} {
      variable configS
      # Update the global user state.
      EZset_state -user $s

      # Change the value of the selector.
      tixSetSilent $w $s

      # Tell the user the new mode. 
      ez_message msg "Selected user mode:$s"

      # Rerender the hypertext in the new user mode.
      if {$configS(S_autorender)} {
	ez:user_update rerender
      }

  }

  proc ez:level_of_expertise {s args} {
      variable configS
      EZset_state -user $s

      foreach i $args {
	if {$i == "-rerender"} {
	  if {$configS(S_autorender)} {
	    ez:rerender
	  }
	}
      }
  }


  proc ez_button {w args} {
      variable configS
      set args [lindex $args 0]

      button $w.but

      set len [llength $args]
      if {$len >= 1} {
	$w.but configure -text [lindex $args 0]
      }
      if {$len >= 2} {
	set cmd [lindex $args 1]
	$w.but configure -command $cmd
	if {([info exists configS(P_dumping_doc)])} {
	  if {!([catch {set pname [lindex $cmd 0]} result_msg])} {
	    if {($pname == "ez_goto_href")||($pname == "::twez::ez_goto_href")} {
	      set href [lindex $cmd 1]
	      ::ezdumphtml::create_href "-&gt;" $href
	    }
	  }
	}
      }
      if {$len >= 3} {
	eval $w.but configure [lindex $args 2]
      }
      # Now pack the widget so we can see the embedded window.
      pack $w.but 
  }
}
