#
#  Copyright (c) 1996-99 by Internet CAD, Inc.
# 
# @(#)$RCSfile: edit.tcl,v $ $Revision: 1.15 $ $Date: 2022/11/06 15:56:17 $
# $Log: edit.tcl,v $
# Revision 1.15  2022/11/06 15:56:17  bills
# Updated to use the twez namespace to avoid name clashes and
# to reorganize the code better.
#
# Revision 1.14  2005/02/01 18:09:32  bills
# Now editing is a E variable rather than a persistent variable
# so we can reload itools properly.
#
# Revision 1.13  2004/03/16  23:03:30  bills
# Changes made for new utdalert_user and ez_message command.  Also
# ran thru Tcl ProCheck.
#
# Revision 1.12  2004/03/16  07:37:48  bills
# Updated for the editor for the new Tk8.4.5 version which has
# internal undo/redo.
#
# Revision 1.11  2004/03/04  18:36:27  bills
# Temporary changes to make editor work.
#
# Revision 1.10  1999/10/13  19:43:19  bills
# Fixed the weakness in Tk.
#
# Revision 1.9  1999/06/17  11:01:14  bills
# Updated for iTools name change.
#
# Revision 1.8  1998/11/17  20:58:20  bills
# Set the wrap mode to word in the editor.
#
# Revision 1.7  1998/10/11  17:30:14  bills
# Fixed a problem which occurred when closing the edit window.  It is
# due to a weakness in Tk.
#
# Revision 1.6  1998/08/05  16:51:34  bills
# Prevent editing the wrong URL.  Also set the dirty function.  Also got
# rid of unnecessary new lines being added to the end of the text.
#
# Revision 1.5  1998/08/01  18:49:20  bills
# Broke edit.tcl into two files: one for requesting edit of the html
# and a second low level routine that is applicable to all kinds
# of Tk editor widgets.
#
# Revision 1.4  1998/07/27  21:52:25  bills
# Changed S_checksum variables to P_checksum variables.
#
# Revision 1.3  1996/05/29  19:48:00  bills
# Got rid of the subnotebook stuff.  Now disable editing of hypertext
# when in view mode.
#
# Revision 1.2  1996/05/27  13:16:32  bills
# Now allow the editing of a subnotebook.
#
# Revision 1.1  1996/05/05  15:16:35  bills
# Initial revision
#
#

namespace eval twez {

  variable save_editS

  proc edit_html {edit_flag} {
      variable urlS
      variable configS
      variable html_winS
      variable save_editS

      set url $urlS
      if {![file exists $url]} {
	set idx [string last # $url]
	if {$idx != -1} {
	  if {$idx == 0} {
	    utdalert_user errmsg ::twez::edit_html "you cannot edit a fragment. Reload html."
	    return ;
	  } else {
	    # window with a fragment.  Remove fragment.
	    incr idx -1
	    set url [string range $url 0 $idx]
	    if {![file exists $url]} {
	      utdalert_user errmsg ::twez::edit_html "could not open:$url. No such file."
	      return ;
	    }
	  }
	} else {
	  utdalert_user errmsg ::twez::edit_html "could not open:$url. No such file."
	  return ;
	}
      }

      # Check to make sure that we haven't tried to open a different url when we
      # are already editing one.
      if {($save_editS(win) != "") && ($configS(E_editing) == 1) && \
	$save_editS(url) != $url} {
	utdalert_user errmsg ::twez::edit_html "Another url:$save_editS(url) is already open for editing"
	return ;
      }

      set win ".ez_html"
      if {[winfo exists $win]} {
	  wm deiconify $win
	  raise $win
	  return
      }

      ez_busy
      update

      # Now we need to build a text widget for use.
      toplevel $win 
      set widget_x [winfo rootx $html_winS]
      set widget_y [winfo rooty $html_winS]
      set widget_wid [winfo width $html_winS]
      set widget_hei [winfo height $html_winS]
      wm overrideredirect $win 1
      wm geometry $win "=${widget_wid}x${widget_hei}+${widget_x}+${widget_y}"
      wm overrideredirect $win 0
      # wm protocol $win WM_DELETE_WINDOW twez::check_edit
      bind $win <Destroy> {::twez::check_edit}

      button $win.b -text Close -command "::twez::close_edit_win $win"
      button $win.s -text Save -command "::twez::save_html"
      tixScrolledText $win.edit
      tixForm $win.b    -left 0 -bottom -0 -padx 4 -pady 4
      tixForm $win.s    -left $win.b -bottom -0 -padx 4 -pady 4
      tixForm $win.edit -left 0 -right -0 -top 0 -bottom $win.b

      # Get the text subwidget.
      set edit_win [$win.edit subwidget text]
      
      if {$edit_flag == "edit"} {
	wm title $win "Editing $url"
	# Set word wrap.
	$edit_win configure -wrap word -undo true
      } else {
	wm title $win "Browsing $url"
      }

      set save_editS(win) $edit_win

      # Now we can use the text edit window.
      set f [open $url]
      while {![eof $f]} {
	 $edit_win insert end [read $f 8192]
      }
      EZset_state -editing 1

      # Need this in case the user changes their mind.
      set save_editS(orig_text) [$edit_win get 1.0 end-1c]
      set save_editS(url) $url
      $edit_win edit modified 0
      close $f

      ez:menu_state edit all normal
      bind $edit_win <<Modified>> {
	::twez::ez:button_state save normal
      }
      # set window for copy, paste, cut, redo, and undo.
      ::utdeditor::set_window $edit_win

      if {$edit_flag == "edit"} {
	ez_message msg "Saving (canceling changes) will performed upon reloading the hypertext."
      } else {
	$edit_win config -state disabled
	ez_message msg "Reloading will remove the display of hypertext."
      }
      ez_ready
  }

  proc close_edit_win {win} {
      variable save_editS
      ::twez::check_edit
      # update
      # after 2000 "destroy $win"
      # Subtle problem - we can't delete window until all exposure event are
      # completed.  This is a weakness in Tk.  This weakness has been fixed.
      if {!($save_editS(canceled))} {
	destroy $win
	update
      }
  }

  proc check_edit { } {
      variable urlS
      variable configS
      variable save_editS

      set save_editS(canceled) 0
      if {($save_editS(win) != "") && ($configS(E_editing) == 1)} {
	if {[winfo exists $save_editS(win)]} {
	  if {[$save_editS(win) edit modified]} {
	    toplevel .ez_save_file
	    ::twez::edit_ask_user {.ez_save_file} 1
	    if {!($save_editS(canceled))} {
	      ez:button_state save disabled
	      ez:menu_state edit all disabled
	      $save_editS(win) edit modified 0
	    }
	  } else {
	    ez_message msg "Nothing was modified. No changes to be saved."
	  }
	} else {
	  # Editing is set to zero only when file is destroyed.
	  EZset_state -editing 0
	  ez:button_state save disabled
	  ez:menu_state edit all disabled
	}
      }
  }

  proc save_html { } {
      variable urlS
      variable configS
      variable save_editS

      set save_editS(canceled) 0
      if {($save_editS(win) != "") && ($configS(E_editing) == 1)} {
	if {[$save_editS(win) edit modified]} {
	  toplevel .ez_save_file
	  ::twez::edit_ask_user {.ez_save_file} 0
	  if {!($save_editS(canceled))} {
	    $save_editS(win) edit modified 0
	    ez:button_state save disabled
	  }
	} else {
	  ez_message msg "No changes have been made to $urlS..."
	}
	# Editing is set to zero only when file is destroyed.
	if {[winfo exists $save_editS(win)] == 0} {
	  EZset_state -editing 0
	}
      }
  }

  proc edit_ask_user {w discard_but} {
      variable urlS
      variable save_editS

      # Create the label on the top of the dialog box
      #
      label $w.top -padx 20 -pady 10 -border 1 -relief raised -anchor c -text \
	  "Changes made to hypertext:\n$save_editS(url).\nDo you wish to save the changes?"

      # Need to save text before it disappears.
      set win $save_editS(win)
      set save_editS(text) [$win get 1.0 end-1c]

      # Create the button box and add a few buttons in it. Set the
      # -width of all the buttons to the same value so that they
      # appear in the same size.
      #
      # Note that the -text, -underline, -command and -width options are all
      # standard options of the button widgets.
      #
      tixButtonBox $w.box -orientation horizontal
      $w.box add ok    -text Save    -underline 0 \
	-command "::twez::edit_reply $w true" -width 5
      $w.box add cancel -text {Cancel} -underline 0 \
	-command "::twez::edit_reply $w cancel" -width 16
      if {$discard_but} {
	$w.box add discard -text {Discard Changes} -underline 0 \
	  -command "::twez::edit_reply $w false" -width 16
      }

      pack $w.box -side bottom -fill x
      pack $w.top -side top -fill both -expand yes
      tkwait window $w
  }

  proc edit_reply { win save_flag } {
      variable save_editS

      if {$save_flag == "cancel"} {
	set save_editS(canceled) true
	destroy $win
	return ;
      } else {
	set save_editS(canceled) false
      }

      if {$save_flag} {
	set filename $save_editS(url)
	if {[file exists $filename.orig] == 0} {
	  exec mv $filename $filename.orig
	} else {
	  exec mv $filename $filename.bak
	}
	set f [open $filename w]
	puts -nonewline $f $save_editS(text)
	close $f
	$save_editS(win) edit reset
	ez_message msg "Saved changes to $filename..."
      } else {
	set filename $save_editS(url)
	ez_message msg "Discarded changes to $filename..."
	$save_editS(win) edit reset
      }
      destroy $win

  }

  proc edit_init { } {
      variable save_editS

      set save_editS(win) {}
  }
    
  proc dirty_func { } {
      EZset_state -editing 1
      ez:button_state save normal
      ez:menu_state edit all normal
  }

} ; # end namespace
