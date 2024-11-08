#
#  Copyright (c) 1999 Internet CAD, Inc.# 
# @(#)$RCSfile: gui.tcl,v $ $Revision: 1.51 $ $Date: 2022/11/06 15:56:17 $
# $Log: gui.tcl,v $
# Revision 1.51  2022/11/06 15:56:17  bills
# Updated to use the twez namespace to avoid name clashes and
# to reorganize the code better.
#
# Revision 1.50  2022/07/22 21:25:06  bills
# Changed AlertBox references to ::twalert::AlertBox which is the proper
# name.
#
# Revision 1.49  2021/01/13 03:01:55  bills
# Added Font Selection to the menu so one can change font sizes.
#
# Revision 1.48  2008/04/30 19:42:56  bills
# Added screen capture command.
#
# Revision 1.47  2007/06/17  02:58:39  bills
# Added Capture Screen command for completeness and utility.
#
# Revision 1.46  2005/11/01  14:14:33  bills
# Added TclLib man pages.
#
# Revision 1.45  2005/03/10  17:17:00  bills
# Fixed problem with editor window during a search.
#
# Revision 1.44  2005/03/09  01:33:40  bills
# Added ez:design_info and added command for generating PDF documentation.
# Changed for P_editing to E_editing variable because it really
# isn't persistent.
#
# Revision 1.43  2005/01/07  20:49:26  bills
# Added support for displaying the design log file.
#
# Revision 1.42  2004/12/22  23:03:47  bills
# Got rid of pid debug statement.
#
# Revision 1.41  2004/07/19  15:36:37  bills
# Now we support multiple pids for ez:check_pids.
#
# Revision 1.40  2004/07/02  15:34:44  bills
# Now we put waiting message in the lower left status window.
#
# Revision 1.39  2004/06/25  16:27:01  bills
# Changed requeuing message to waiting for pids to finish...
#
# Revision 1.38  2004/06/18  19:17:01  bills
# Modified so that the user cannot change hypertext while a program
# is running.
#
# Revision 1.37  2004/03/16  23:03:30  bills
# Changes made for new utdalert_user and ez_message command.  Also
# ran thru Tcl ProCheck.
#
# Revision 1.36  2004/03/16  07:39:20  bills
# Updated the code for new Tk version 8.4.5.  Needed to change some
# accelerator key settings.
#
# Revision 1.35  2004/03/04  18:36:27  bills
# Temporary changes to make editor work.
#
# Revision 1.34  2003/03/23  01:34:25  bills
# Changed ez_message so that it uses a switch and so it has more
# flexibility.
#
# Revision 1.33  2003/02/02  19:52:47  bills
# Added support for recent projects.
#
# Revision 1.32  2003/01/31  15:48:17  bills
# Major rewrite of EZ so we can support projects.  We introduced the
# E_xxx variable and changed many variables from P_xxx to S_xxx so
# we can make the users life easier.
#
# Revision 1.31  2003/01/22  17:03:16  bills
# Now set the default search for manpages to {*.n}
#
# Revision 1.30  2002/09/19  20:44:42  bills
# Updated for new ::iccmds::commands which replaces ic:cmds function.
#
# Revision 1.29  2002/03/31  03:07:11  bills
# Added ic:cmds auto help command to help menu.
#
# Revision 1.28  2000/05/25  04:32:26  bills
# Added version info command.
#
# Revision 1.27  1999/10/31  17:26:11  bills
# Added the Flow Monitor program to the top level menus.
#
# Revision 1.26  1999/06/28  04:01:17  bills
# Added location and history to the EZ display.
#
# Revision 1.25  1999/06/17  11:01:14  bills
# Updated for iTools name change.
#
# Revision 1.24  1998/11/17  21:00:33  bills
# Changed the name of the EZedit: commands because we need to add a window wrapper.
#
# Revision 1.23  1998/10/14  05:11:04  bills
# Turned off debug of rerender command.
#
# Revision 1.22  1998/10/13  19:11:22  bills
# Now handle the redrawing of relative anchors in icrerender.
#
# Revision 1.21  1998/10/05  22:33:32  bills
# Added arguments to ez:rerender.  Now ez:rerender takes a filename as
# a HTML reference (HREF).
#
# Revision 1.20  1998/08/07  02:01:22  bills
# Changed S_developer (saved) to P_developer (persistent) variable.  Now
# update the menu so that developer is not present if ICDEVELOPER is
# not set.  Previously, it always showed up in the menu.  Now use the
# ICvarsG(P_rcmd,$cur_page) variable to restore the raise command in
# the ez:render_home command so that we can restore when all goes bad.
#
# Revision 1.19  1998/08/05  16:53:09  bills
# Now allow searching the edit window as well as the html window.  If
# edit window is open it has priority.
#
# Revision 1.18  1998/08/01  18:50:18  bills
# Moved the cut, copy and paste routines to editor.tcl.
#
# Revision 1.17  1998/07/31  21:16:01  bills
# Moved the ez:edit_html functions to edit.tcl.
#
# Revision 1.16  1998/07/27  21:55:39  bills
# Added the ez:native_browser command and changed the S_checksum variables
# to P_checksum.
#
# Revision 1.15  1998/07/23  15:57:15  bills
# Now the search page is called from the icon button.
#
# Revision 1.14  1998/07/23  15:10:56  bills
# Added better fonts to icons.  Added ez:stop_render command so that
# stop icon now works.  Fixed problems with HMTL notebook variables.
#
# Revision 1.13  1998/07/21  21:59:55  bills
# Modified tcl so that autosaving will work properly.
#
# Revision 1.12  1998/07/16  18:41:26  bills
# Added native browser checks and fixed problem with enter and leave button
# hightlighting.
#
# Revision 1.11  1998/07/14  02:33:54  bills
# Added fancy compound buttons to the native browser.  Fixed the problem
# with the search mechanism.  Fixed problems with ez:rerender.
#
# Revision 1.10  1998/07/06  19:50:07  bills
# Now the native browser uses compound images in its buttons.
#
# Revision 1.9  1996/07/18  18:20:08  bills
# Commented out debug statements.
#
# Revision 1.8  1996/05/29 19:49:32  bills
# Rewrote the clipboard mechanism to agree with Tk's text mechanism.
# Added an argument to ez:user_update function.
#
# Revision 1.7  1996/05/24  23:50:23  bills
# Added user mode to option dialog.  Added the Help menu and search mechanism.
# Now the rerender reloads the same page.
#
# Revision 1.6  1996/05/05  15:11:39  bills
# Added man pages, hypertext editing functions and added more icons
# to the iconbar.  Also the back and forward mechanism works properly
# now.
#
#


namespace eval twez {

  proc ez_page_init {notebook page} {
      # Get to the right page.
      set w [$notebook subwidget $page]

      # Create a frame for the hypertext widget.
      frame $w.f
      pack $w.f -side left  -padx 2 -pady 2 -fill both -expand yes

      # Create a complex window inside the ScrolledWindow widget.
      #
      # [Hint] Be sure you create and pack new widgets inside the
      #	     "window" subwidget and NOT inside $w.top.a itself!
      #
      tixScrolledText $w.f.a -bd 5
      pack $w.f.a -expand yes -fill both -padx 10 -pady 10 -side left

      # Get the subwidget to build the HTML renderer.
      set w [$w.f.a subwidget text]
  }

  proc ez_hypertext {notebook page filename} {
      variable configS

      # Signal that we are  busy.
      ez_busy

      # Check any editing that might have been done.
      ::twez::check_edit

      # Get to the right page.
      set w [$notebook subwidget $page]

      # Get the subwidget to build the HTML renderer.
      set w [$w.f.a subwidget text]

      ::twez::HTML_view $notebook $page $w $filename $configS(S_fontsize) $configS(S_indent)

      if {$notebook == $configS(E_notebook)} {
	EZset_state -page $page
      }

  }

  proc ez_build_gui {w} {

      # Order is very important here.
      set frame1 [ez_main_menu $w]
      set frame2 [ez_main_status $w]
      set frame3 [ez_main_iconbar $w]

      pack $frame1 -side top -fill x
      pack $frame3 -side top -fill x
      pack $frame2 -side bottom -fill x

  }


  proc ez_main_menu {top} {
      variable configS
      set w [frame $top.f1 -bd 2 -relief raised]

      # The first menu button - File.
      menubutton $w.file -menu $w.file.m -text File -underline 0 \
	-takefocus 0
      menu $w.file.m
      $w.file.m add command   -label "New Lesson..." -command ::twez::new_lesson -underline 1 \
	-accelerator "Ctrl+Shift+N"
      $w.file.m add command   -label "Open Lesson..." -command ::twez:open_lesson -underline 1 \
	-accelerator "Ctrl+Shift+O"
      $w.file.m add command   -label "Close Lesson..." -command ::twez::close_lesson -underline 1 \
	-accelerator "Ctrl+Shift+C"
      $w.file.m add separator
      $w.file.m add command   -label "Save Lesson" -command "::twez::lesson_save 1" -underline 1 \
	-accelerator "Ctrl+Shift+S"
      $w.file.m add command   -label "Save Lesson As..." -command "::twez::lesson_save_as"
      $w.file.m add separator
      $w.file.m add cascade   -label "Recent Lessons..." -menu $w.file.m.lessons
      $w.file.m add separator
      $w.file.m add command   -label "Print       " -command ::twez::ez:print -underline 1 \
	-accelerator "Ctrl+P"
      $w.file.m add separator
      $w.file.m add command   -label "Capture Screen" -command ::iccapture::display -underline 1
      $w.file.m add separator
      $w.file.m add command   -label "Exit        " -command ez_exit -underline 1

      set m2 [menu $w.file.m.projects -tearoff 0]
      EZset_state -project_menu $m2
      update_project_menu

      # The second menu button - Edit.
      menubutton $w.edit -menu $w.edit.m -text Edit -underline 0 \
	-takefocus 0
      menu $w.edit.m
      $w.edit.m add command -label "Undo    " -command ::utdeditor::undo_win \
	-underline 1 -accelerator "Ctrl+z" -state disabled
      $w.edit.m add command -label "Redo    " -command ::utdeditor::redo_win \
	-underline 1 -accelerator "Ctrl+Z" -state disabled
      $w.edit.m add separator
      $w.edit.m add command -label "Cut     " -command ::utdeditor::cut_win -underline 1 \
	-accelerator "Ctrl+X" -state disabled
      $w.edit.m add command -label "Copy    " -command ::utdeditor::copy_win -underline 1 \
	-accelerator "Ctrl+C" -state disabled
      $w.edit.m add command -label "Paste   " -command ::utdeditor::paste_win -underline 1 \
	-accelerator "Ctrl+y" -state disabled

      # The third menu button - Options.
      menubutton $w.options -menu $w.options.m -text Options -underline 0 \
	-takefocus 0
      menu $w.options.m
      $w.options.m add cascade -label "Auto Rerender"  \
	-underline 1 \
	-menu $w.options.m.sub1
      $w.options.m add command -label "Font Selector"  \
	-command {::twez::ez:font_select} \
	-underline 0
      $w.options.m add cascade -label "Font Size"  \
	-underline 1 -accelerator "Ctrl+F" \
	-menu $w.options.m.sub2
      $w.options.m add cascade -label "Indent Amount"  \
	-underline 1 \
	-menu $w.options.m.sub3
      $w.options.m add cascade -label "User Mode"  \
	-underline 1 \
	-menu $w.options.m.sub4

      # The fourth menu button - Tools.
      menubutton $w.tools -menu $w.tools.m -text Tools -underline 0 \
	-takefocus 0
      menu $w.tools.m
      $w.tools.m add command   -label "Create PDF Documentation" -command "::twez::display" -underline 1
      $w.tools.m add command   -label "Screen Capture" -command "::iccapture::display" -underline 1
      if {$configS(E_developer) == 1} {
	$w.tools.m add separator
	$w.tools.m add command -label "Source Tcl   " -command ::twez::ez:source_tcl \
	  -underline 1 -accelerator "Ctrl+S"
      }

      # Build the Autorender submenu
      set m2 [menu $w.options.m.sub1 -tearoff 0]
      $m2 add radiobutton -label On -value 1 -variable ::twez::configS(S_autorender)
      $m2 add radiobutton -label Off -value 0 -variable ::twez::configS(S_autorender)

      # Build the Font Size Submenu.
      set m2 [menu $w.options.m.sub2 -tearoff 0]
      $m2 add radiobutton -label small -value 0 -variable ::twez::configS(S_fontsize) \
	-command {::twez::ez:font_size $::twez::configS(S_fontsize) -rerender}
      $m2 add radiobutton -label medium -value 4 -variable ::twez::configS(S_fontsize) \
	-command "::twez::ez:font_size $::twez::configS(S_fontsize) -rerender"
      $m2 add radiobutton -label large -value 12 -variable ::twez::configS(S_fontsize) \
	-command {::twez::ez:font_size $::twez::configS(S_fontsize) -rerender}
      set ic_font_size $configS(S_fontsize)

      # Build the Indent Amount Submenu.
      set m2 [menu $w.options.m.sub3 -tearoff 0]
      $m2 add radiobutton -label small -value 0.6 -variable ::twez::configS(S_indent) \
	-command {::twez::ez:indent_amt $::twez::configS(S_indent) -rerender}
      $m2 add radiobutton -label medium -value 1.2 -variable ::twez::configS(S_indent) \
	-command {::twez::ez:indent_amt $::twez::configS(S_indent) -rerender}
      $m2 add radiobutton -label large -value 2.4 -variable ::twez::configS(S_indent) \
	-command {::twez::ez:indent_amt $::twez::configS(S_indent) -rerender}

      set m2 [menu $w.options.m.sub4 -tearoff 0]
      $m2 add radiobutton -label Novice -value Novice -variable ::twez::configS(S_user) \
	-command {::twez::ez:user_update rerender}
      $m2 add radiobutton -label Intermediate -value Intermediate \
	-variable ::twez::configS(S_user) -command {::twez::ez:user_update rerender}
      $m2 add radiobutton -label Expert -value Expert -variable ::twez::configS(S_user) \
	-command {::twez::ez:user_update rerender}
      if {$configS(E_developer)} {
	$m2 add radiobutton -label Developer -value Developer \
	  -variable ::twez::configS(S_user) -command {::twez::ez:user_update rerender}
      }


      # Build the Help Menu
      menubutton $w.help -menu $w.help.m -text Help -underline 0 \
	-takefocus 0
      menu $w.help.m
      $w.help.m add command -label "Commands" -command "::iccmds::commands" \
	-underline 1
      $w.help.m add cascade -label "Man Pages" -menu $w.help.m.man \
	  -underline 1 -accelerator "Ctrl+M"
      $w.help.m add command -label "Where Is It?" -command ::twez::ez:help_search \
	-underline 1 -accelerator "Ctrl+W" 
      $w.help.m add command -label "Version" -command ::twez::ez:version
      $w.help.m add command -label "Design Info" -command ::twez::ez:design_info

      # Now build the man page submenu.
      set m2 [menu $w.help.m.man -tearoff 0]
      $m2 add command -label "Tcl" -command {::twez::ez:man_pages tcl} -underline 1
      $m2 add command -label "Tk" -command {::twez::ez:man_pages tk} -underline 1
      $m2 add command -label "Tix" -command {::twez::ez:man_pages tix} -underline 1
      $m2 add command -label "TclLib" -command {::twez::ez:man_pages tcllib} -underline 1
      $m2 add command -label "Man Section 1" -command {::twez::ez:man_pages man1} \
	-underline 1

      tixForm $w.file
      tixForm $w.edit -left "$w.file 10"
      tixForm $w.options -left "$w.edit 10"
      tixForm $w.tools -left "$w.options 10"
      tixForm $w.help -right -0

      # Accelerator bindings
      bind all <Control-p> "ez:print"

      return $w ;
  }

  proc ez_main_status {top} {
      variable configS

      set w [frame $top.f2 -bd 1 -relief raised]
      set configS(E_statusbar) [label $w.status -relief sunken -bd 1 \
	-font -Adobe-Helvetica-Bold-R-Normal--*-120-*-*-*-*-*-* \
	-background {red} \
	-foreground {white}]
      $w.status configure -text Busy
      set configS(E_message) [label $w.message -relief sunken -bd 1 \
	-font -*-helvetica-medium-r-normal-*-14-*-*-*-*-*-*-*]
      pack $configS(E_statusbar) -padx 3 -pady 3 -side left 
      pack $configS(E_message) -padx 3 -pady 3 -side left -expand yes -fill both

      return $w ;
  }

  proc ez_main_iconbar {top} {
      variable configS
      variable EZiconS

      set rootdir $configS(E_rootdir)
      set message $configS(E_message) ; # status bar at the bottom.

      set w [frame $top.f3 -bd 3 -relief ridge]

      # Add the icons
      set EZiconS(font) "-*-helvetica-medium-r-normal-*-*-120-*-*-*-*-*-*"

      # the back icon.
      set back_img [image create pixmap -file $rootdir/tcl/EZ/icons/back.xpm]
      button $w.back -command "::twez::ez:html_traverse back"
      set EZiconS(back_cmp) [image create compound -window $w.back]
      set EZiconS(back_cmpA) [image create compound -window $w.back -foreground blue]
      $EZiconS(back_cmp) add image -image $back_img
      $EZiconS(back_cmp) add line -anchor w
      $EZiconS(back_cmp) add text -text " Back" -anchor c -font $EZiconS(font)
      $EZiconS(back_cmpA) add image -image $back_img
      $EZiconS(back_cmpA) add line -anchor w
      $EZiconS(back_cmpA) add text -text " Back" -anchor c -font $EZiconS(font)
      $w.back config -image $EZiconS(back_cmp) -width 49 -height 39
      pack $w.back -padx 0 -pady 0 -side left
      pack propagate $w.back 1
      bind $w.back <Enter> "$w.back config -image $EZiconS(back_cmpA)"
      bind $w.back <Leave> "$w.back config -image $EZiconS(back_cmp)"

      # the forward icon.
      set forward_img [image create pixmap -file $rootdir/tcl/EZ/icons/forward.xpm]
      button $w.forward -image $forward_img -command "::twez::ez:html_traverse forward"
      set EZiconS(forward_cmp) [image create compound -window $w.forward]
      set EZiconS(forward_cmpA) [image create compound -window $w.forward \
				  -foreground blue]
      $EZiconS(forward_cmp) add image -image $forward_img
      $EZiconS(forward_cmp) add line -anchor w
      $EZiconS(forward_cmp) add text -text " Forward" -anchor c \
	-font $EZiconS(font)
      $EZiconS(forward_cmpA) add image -image $forward_img
      $EZiconS(forward_cmpA) add line -anchor w
      $EZiconS(forward_cmpA) add text -text " Forward" -anchor c \
	-font $EZiconS(font)
      $w.forward config -image $EZiconS(forward_cmp) -width 49 -height 39
      pack $w.forward -padx 0 -pady 0 -side left
      pack propagate $w.forward 0
      bind $w.forward <Enter> "$w.forward config -image $EZiconS(forward_cmpA)"
      bind $w.forward <Leave> "$w.forward config -image $EZiconS(forward_cmp)"

      # the reload icon.
      set reload_img [image create pixmap -file $rootdir/tcl/EZ/icons/reload.xpm]
      button $w.reload -image $reload_img -command "::twez::ez:rerender"
      set EZiconS(reload_cmp) [image create compound -window $w.reload]
      set EZiconS(reload_cmpA) [image create compound -window $w.reload \
				 -foreground blue]
      $EZiconS(reload_cmp) add image -image $reload_img
      $EZiconS(reload_cmp) add line -anchor w
      $EZiconS(reload_cmp) add text -text " Reload" -anchor c -font $EZiconS(font)
      $EZiconS(reload_cmpA) add image -image $reload_img
      $EZiconS(reload_cmpA) add line -anchor w
      $EZiconS(reload_cmpA) add text -text " Reload" -anchor c -font $EZiconS(font)
      $w.reload config -image $EZiconS(reload_cmp) -width 49 -height 39
      pack $w.reload -padx 0 -pady 0 -side left
      pack propagate $w.reload 0
      bind $w.reload <Enter> "$w.reload config -image $EZiconS(reload_cmpA)"
      bind $w.reload <Leave> "$w.reload config -image $EZiconS(reload_cmp)"

      # the home icon.
      set home_img [image create pixmap -file $rootdir/tcl/EZ/icons/home.xpm]
      button $w.home -image $home_img -command "::twez::ez:render_home"
      set EZiconS(home_cmp) [image create compound -window $w.home]
      set EZiconS(home_cmpA) [image create compound -window $w.home \
			       -foreground blue]
      $EZiconS(home_cmp) add image -image $home_img
      $EZiconS(home_cmp) add line -anchor w
      $EZiconS(home_cmp) add text -text " Home" -anchor c -font $EZiconS(font)
      $EZiconS(home_cmpA) add image -image $home_img
      $EZiconS(home_cmpA) add line -anchor w
      $EZiconS(home_cmpA) add text -text " Home" -anchor c -font $EZiconS(font)
      $w.home config -image $EZiconS(home_cmp) -width 49 -height 39
      pack $w.home -padx 0 -pady 0 -side left
      pack propagate $w.home 0
      bind $w.home <Enter> "$w.home config -image $EZiconS(home_cmpA)"
      bind $w.home <Leave> "$w.home config -image $EZiconS(home_cmp)"

      # the search icon.
      set search_img [image create pixmap -file $rootdir/tcl/EZ/icons/search.xpm]
      button $w.search -image $search_img -command "::twez::ez:search_the_html"
      set EZiconS(search_cmp) [image create compound -window $w.search]
      set EZiconS(search_cmpA) [image create compound -window $w.search \
				 -foreground blue]
      $EZiconS(search_cmp) add image -image $search_img
      $EZiconS(search_cmp) add line -anchor w
      $EZiconS(search_cmp) add text -text " Search" -anchor c -font $EZiconS(font)
      $EZiconS(search_cmpA) add image -image $search_img
      $EZiconS(search_cmpA) add line -anchor w
      $EZiconS(search_cmpA) add text -text " Search" -anchor c -font $EZiconS(font)
      $w.search config -image $EZiconS(search_cmp) -width 49 -height 39
      pack $w.search -padx 0 -pady 0 -side left
      pack propagate $w.search 0
      bind $w.search <Enter> "$w.search config -image $EZiconS(search_cmpA)"
      bind $w.search <Leave> "$w.search config -image $EZiconS(search_cmp)"

      set edit_img [image create pixmap -file $rootdir/tcl/EZ/icons/edit.xpm]
      set view_img [image create pixmap -file $rootdir/tcl/EZ/icons/view.xpm]
      # the edit/view html icon.
      button $w.edit 
      set EZiconS(edit_cmp) [image create compound -window $w.edit]
      set EZiconS(edit_cmpA) [image create compound -window $w.edit \
			       -foreground blue]
      $EZiconS(edit_cmp) add image -image $edit_img
      $EZiconS(edit_cmp) add line -anchor w
      $EZiconS(edit_cmp) add text -text " Edit" -anchor c -font $EZiconS(font)
      $EZiconS(edit_cmpA) add image -image $edit_img
      $EZiconS(edit_cmpA) add line -anchor w
      $EZiconS(edit_cmpA) add text -text " Edit" -anchor c -font $EZiconS(font)

      set EZiconS(view_cmp) [image create compound -window $w.edit]
      set EZiconS(view_cmpA) [image create compound -window $w.edit \
			       -foreground blue]
      $EZiconS(view_cmp) add image -image $view_img
      $EZiconS(view_cmp) add line -anchor w
      $EZiconS(view_cmp) add text -text " View" -anchor c -font $EZiconS(font)
      $EZiconS(view_cmpA) add image -image $view_img
      $EZiconS(view_cmpA) add line -anchor w
      $EZiconS(view_cmpA) add text -text " View" -anchor c -font $EZiconS(font)
      if {$configS(S_user) == "Developer"} {
	$w.edit config -image $EZiconS(edit_cmp) -command "::twez::edit_html edit" \
		       -width 49 -height 39
	bind $w.edit <Enter> "$w.edit config -image $EZiconS(edit_cmpA)"
	bind $w.edit <Leave> "$w.edit config -image $EZiconS(edit_cmp)"
      } else {
	$w.edit config -image $EZiconS(view_cmp) -command "::twez::edit_html view" \
		       -width 49 -height 39
	bind $w.edit <Enter> "$w.edit config -image $EZiconS(view_cmpA)"
	bind $w.edit <Leave> "$w.edit config -image $EZiconS(view_cmp)"
      }
      pack $w.edit -padx 0 -pady 0 -side left
      pack propagate $w.edit 0
      set configS(edit_img) $EZiconS(edit_cmp)
      set configS(view_img) $EZiconS(view_cmp)

      # the save html icon.
      set save_img [image create pixmap -file $rootdir/tcl/EZ/icons/save.xpm]
      button $w.save -image $save_img -command "::twez::save_html"
      set EZiconS(save_cmp) [image create compound -window $w.save]
      set EZiconS(save_cmpA) [image create compound -window $w.save \
			       -foreground blue]
      $EZiconS(save_cmp) add image -image $save_img
      $EZiconS(save_cmp) add line -anchor w
      $EZiconS(save_cmp) add text -text " Save" -anchor c -font $EZiconS(font)
      $EZiconS(save_cmpA) add image -image $save_img
      $EZiconS(save_cmpA) add line -anchor w
      $EZiconS(save_cmpA) add text -text " Save" -anchor c -font $EZiconS(font)
      $w.save config -image $EZiconS(save_cmp) -width 49 -height 39
      $w.save configure -state disabled
      pack $w.save -padx 0 -pady 0 -side left
      pack propagate $w.save 0
      bind $w.save <Enter> "$w.save config -image $EZiconS(save_cmpA)"
      bind $w.save <Leave> "$w.save config -image $EZiconS(save_cmp)"

      # the stop html icon.
      set stop_img [image create pixmap -file $rootdir/tcl/EZ/icons/stop.xpm]
      button $w.stop -command "::twez::ez:stop_render"
      set EZiconS(stop_cmp) [image create compound -window $w.stop]
      set EZiconS(stop_cmpA) [image create compound -window $w.stop \
			       -foreground blue]
      $EZiconS(stop_cmp) add image -image $stop_img
      $EZiconS(stop_cmp) add line -anchor w
      $EZiconS(stop_cmp) add text -text " Stop" -anchor c -font $EZiconS(font)
      $EZiconS(stop_cmpA) add image -image $stop_img
      $EZiconS(stop_cmpA) add line -anchor w
      $EZiconS(stop_cmpA) add text -text " Stop" -anchor c -font $EZiconS(font)
      $w.stop config -image $EZiconS(stop_cmp) -width 49 -height 39
      pack $w.stop -padx 0 -pady 0 -side left
      pack propagate $w.stop 0
      bind $w.stop <Enter> "$w.stop config -image $EZiconS(stop_cmpA)"
      bind $w.stop <Leave> "$w.stop config -image $EZiconS(stop_cmp)"

      tixBalloon $w.b -statusbar $message
      $w.b bind $w.back -balloonmsg "Go to previous HTML" \
	-statusmsg "Return to your previous place in the hypertext." 
      $w.b bind $w.forward -balloonmsg "Go to the next HTML" \
	-statusmsg "Return forward to your previous place in the hypertext." 
      $w.b bind $w.reload -balloonmsg "Reload the current HTML" \
	-statusmsg "Reread the current hypertext document." 
      $w.b bind $w.home -balloonmsg "Reload the topics toplevel HTML" \
	-statusmsg "Renders the entry point HTML of the current topic or tab." 
      $w.b bind $w.search -balloonmsg "Search for a topic" \
	-statusmsg "Enter the search mode for a topic." 
      if {$configS(S_user) == "Developer"} {
	$w.b bind $w.edit -balloonmsg "Edit the current HTML" \
	-statusmsg "Show the source and allow editing of the current hypertext document." 
      } else {
	$w.b bind $w.edit -balloonmsg "View the current HTML" \
	-statusmsg "Show the source of the current hypertext document." 
      }
      $w.b bind $w.save -balloonmsg "Save the source of the current HTML" \
	-statusmsg "Save the source of the currently editted hypertext document." 
      $w.b bind $w.stop -balloonmsg "Stop display of current HTML" \
	-statusmsg "Use this button to stop the current document from being rendered." 
      # Now add a combo box with the history.
      tixComboBox $w.history -label "Location:" -editable true -history true \
	-anchor e -variable ::twez::configS(S_url) \
	-command "::twez::ez:location $w.history" \
	-historylimit 20 -prunehistory true \
	-options {
	  entry.width 80
	}
      pack $w.history -padx 10 -pady 0 -side left

      return $w ;
  }

  proc ez:location {history path} {
      variable urlS
      variable configS
      variable loadedS

      # puts stderr "history:$history path:$path"
      if {$configS(S_busy)} {
      } else {
	if {$urlS != $path && $loadedS} {
	  set urlS $path
	  $history config -disablecallback true
	  ez:rerender
	}
      }
      $history config -disablecallback false
      $history addhistory $path
  }

  proc ez:button_state {button state} {
      variable configS

      set top $configS(E_toplevel)
      set but $top.f3.$button

      $but configure -state $state
  }

  proc ez:menu_state {menu index state} {
      variable configS

      set top $configS(E_toplevel)
      set menu_win $top.f1.$menu.m

      if {$index == "all"} {
	set num [$menu_win index end]
	for {set i 1} {$i <= $num} {incr i} {
	  catch {$menu_win entryconfigure $i -state $state}
	}
      } else {
	$menu_win entryconfigure $index -state $state
      }
  }

  proc ez:user_update {render_flag} {
      variable EZiconS
      variable configS

      set top $configS(E_toplevel)
      set but $top.f3.edit 
      set w $top.f3

      if {$configS(S_user) == "Developer"} {
	bind $but <Enter> {}
	bind $but <Leave> {}
	$but configure -image $EZiconS(edit_cmp) -command "::twez::edit_html edit"
	update
	bind $but <Enter> "$but config -image $EZiconS(edit_cmpA)"
	bind $but <Leave> "$but config -image $EZiconS(edit_cmp)"
	$w.b bind $w.edit -balloonmsg "Edit the current HTML" -statusmsg \
	"Show the source and allow editing of the current hypertext document." 
    }
      if {$render_flag == "rerender"} {
	after idle {::twez::ez:rerender}
      }
  }

  proc ez_message {args} {
      variable configS

      set num [llength $args]
      if {$num == 1} {
	set type errmsg
	set user_msg [lindex $args 0]
	set msg "ERROR:$user_msg"
      } elseif {$num == 2} {
	set type [lindex $args 0]
	set user_msg [lindex $args 1]
	set mtype [utdalert_error_type $type]
	if {$mtype != ""} {
	  set msg "$mtype:$user_msg"
	} else {
	  set msg "$user_msg"
	}
      } elseif {$num == 3} {
	set type [lindex $args 0]
	set routine [lindex $args 1]
	set user_msg [lindex $args 2]
	set mtype [utdalert_error_type $type]
	if {($routine != "") && ($routine != "null")} {
	  set msg "$mtype\[$routine\]:$user_msg"
	} else {
	  set msg "$mtype:$user_msg"
	}
      } else {
	puts stderr "ERROR\[ez_message]: unknown message args : $args"
	return ;
      }

      switch -exact $type {
	msg {$configS(E_message) configure -text $msg -foreground black}
	imsg {$configS(E_message) configure -text $msg -foreground red}
	warn {$configS(E_message) configure -text $msg -foreground blue}
	warnmsg {$configS(E_message) configure -text $msg -foreground blue}
	error {$configS(E_message) configure -text $msg -foreground red}
	errmsg {$configS(E_message) configure -text $msg -foreground red}
	default {$configS(E_message) configure -text "Unknown $msg" -foreground red}
      }
  }


  proc ez_busy {} {
      variable configS

      if {[info exists configS(rendering_locked)]} {
	$configS(E_statusbar) configure -text "Waiting for $configS(rendering_locked) to finish..." \
	  -background {red} -foreground {white}
      } else {
	$configS(E_statusbar) configure -text Busy -background {red} -foreground {white}
      }
      set configS(S_busy) true

  }

  proc ez_ready {} {
      variable configS

      if {[info exists configS(rendering_locked)]} {
	$configS(E_statusbar) configure -text "Waiting for $configS(rendering_locked) to finish..." \
	  -background {red} -foreground {white}
      } else {
	$configS(E_statusbar) configure -text Ready -background {green} \
	  -foreground {black}
      }
      set configS(S_busy) false
  }

  proc ez:render_home {} {
      variable urlS
      variable configS

      set cur_page [$configS(E_notebook) raised]
      set rcmd $configS(E_rcmd,$cur_page)
      $configS(E_notebook) pageconfig $cur_page -raisecmd $rcmd
      set urlS [lindex $rcmd 3]
      ez:rerender
  }


  # User commands.
  proc ez:rerender {args} {
      variable urlS
      variable configS
      variable html_winS

      if {[info exists configS(rendering_locked)]} {
	utdalert_user errmsg ez:rerender \
	"Rerendering is not possible when a program is running.  Either kill the \
  program with pid:$configS(rendering_locked) or wait for it to finish. If the \
  program was started inside an EZ window, make sure to hit the Exit button."
	return ;
      }

      ::twez::HTML_save_enable 0
      set cur_page [$configS(E_notebook) raised]
      set rcmd [$configS(E_notebook) pagecget $cur_page -raisecmd]
      if {$args != ""} {
	set filename [lindex $args 0]
	ez:save_state $html_winS $urlS
	set relative [string range $filename 0 0]
	if {$relative == "#" } {
	  set urlS ${urlS}$filename
	} else {
	  set dir [file dirname [lindex $rcmd 3]]
	  set urlS ${dir}/$filename
	}
	# puts stderr "urlS:\{$urlS\}"
	ez:rerender
	return ;
      }
      if {[catch {$html_winS yview} message]} {
	puts stderr "ERROR:$message\n[stacktrace]"
	set view 0.0
      } else {
	set view [lindex $message 0]
      }
      if {($html_winS != "")} {
	set rcmd [lreplace $rcmd 3 3 $urlS]
	if {$configS(E_editing) == 1} {
	  $html_winS config -state normal
	}
      }
      eval $rcmd
      # Try to put us back in the same place"
      if {$view != 0.0} {
	if {[catch {$html_winS yview moveto $view} message]} {
	  utdalert_user error "ERROR:$message\n[stacktrace]"
	}
      }
      ::twez::HTML_save_enable 1
  }

  proc page {page args} {
      variable configS
      variable html_winS

      if {$args != ""} {

	variable urlS

	set filename [lindex $args 0]
	# First change the raise command to the current file so can raise the
	# correct file.
	set need_restore 0
	if {[catch {$configS(E_notebook) pageconfig $page -raisecmd} message]} {
	  puts stderr "ERROR:$message\n[stacktrace]"
	} else {
	  set rcmd [lindex $message 4]
	  set renderfile [lindex $rcmd 3]
	  if {[string compare $filename $renderfile] != 0} {
	    set need_restore 1
	    set newrcmd [lreplace $rcmd 3 3 $filename]
	    $configS(E_notebook) pageconfig $page -raisecmd $newrcmd
	  }
	}
	# Now that we have swapped the file it is ok to raise the notebook page.
	$configS(E_notebook) raise $page

	# See if we have an offset
	set len [llength $args]
	if {$len == 2} {
	  ::twez::link_callback $html_winS $filename
	  set view [lindex $args 1]
	  if {[catch {$html_winS yview moveto $view} message]} {
	    utdalert_user error "ERROR:$message\n[stacktrace]"
	  }
	}
	if {$need_restore} {
	  $configS(E_notebook) pageconfig $page -raisecmd $rcmd
	}

      } else {
	if {[catch {$configS(E_notebook) raise $page} message]} {
	  puts stderr "ERROR:$message\n[stacktrace]"
	}
      }
  }

  proc ez:font_size {size args} {
      variable configS
      set configS(S_fontsize) $size
      foreach i $args {
	if {$i == "-rerender"} {
	  ez:rerender
	}
      }
  }

  proc ez:indent_amt {amount args} {
      variable configS
      set configS(S_indent) $amount

      foreach i $args {
	if {$i == "-rerender"} {
	  ez:rerender
	}
      }
  }

  proc ez:html_traverse { direction } {
      variable urlS
      variable configS
      variable html_winS
      variable ::twez::loc_stackS

      if {[info exists configS(rendering_locked)]} {
	utdalert_user errmsg ez:html_traverse \
	"Rerendering is not possible when a program is running.  Either kill the \
  program with pid:$configS(rendering_locked) or wait for it to finish.  If the \
  program was started inside an EZ window, make sure to hit the Exit button."
	return ;
      }

      ::twez::check_edit

      if {$direction == "back"} {
	# puts stderr "Calling back..."
	if {$::twez::loc_stackS(index) == $::twez::loc_stackS(max)} {
	  # save where we were for forward.
	  ::twez::HTML_save_place
	  set cb [::twez::HTML_pop]
	}
	set cb [::twez::HTML_pop]
      } else {
	# puts stderr "Calling forward..."
	set cb [::twez::HTML_next]
      }

      if {$cb != "" } {
	# puts stderr "popped:$cb"
	set ::twez::loc_stackS(valid) 0
	# puts stderr "valid:$::twez::loc_stackS(valid)"
	set len [llength $cb]
	# This does the top level notebook.
	set w [lindex $cb 0]
	upvar #0 HM$w var
	set notebook $var(S_notebook)
	if {$notebook != $configS(E_notebook)} {
	  puts stderr "ERROR:Notebook should be a top level notebook."
	}
	set filename [lindex $cb 1]
	set page $var(S_page)
	set cur_page [$notebook raised]
	if {$page != $cur_page} {
	  # temporarily turn off the raise cmd
	  set rcmd [$configS(E_notebook) pagecget $page -raisecmd]
	  $notebook pageconfigure $page -raisecmd {}
	  $notebook raise $page
	  # now turn the raise command back on.
	  $notebook pageconfigure $page -raisecmd $rcmd
	  # puts stderr "got to here without rendering"
	}
	::twez::HTML_view $notebook $page $w $filename $configS(S_fontsize) $configS(S_indent)
	$w yview moveto [lindex $cb 2]
	if {$len == 6} {
	  puts stderr "cb len:$len"
	  set w [lindex $cb 3]
	  upvar #0 HM$w var
	  set subnotebook $var(S_notebook)
	  if {$subnotebook == $configS(E_notebook)} {
	    puts stderr "ERROR:Notebook should not be a top level notebook."
	  }
	  puts stderr "subnotebook:$subnotebook"
	  set filename [lindex $cb 4]
	  set page $var(S_page)
	  set cur_page [$notebook raised]
	  puts stderr "subnotebook page:$page raised:$cur_page"
	  if {$page != $cur_page} {
	    # temporarily turn off the raise cmd
	    set rcmd [$subnotebook pagecget $page -raisecmd]
	    $subnotebook pageconfigure $page -raisecmd {}
	    $subnotebook raise $page
	    # now turn the raise command back on.
	    $subnotebook pageconfigure $page -raisecmd $rcmd
	    # puts stderr "got to here without rendering"
	  }
	  ::twez::HTML_view $subnotebook $page $w $filename $configS(S_fontsize) $configS(S_indent)
	  $w yview moveto [lindex $cb 5]
	}
	set ::twez::loc_stackS(valid) 1
      } else {
	# puts stderr "empty stack $cb"
      }
  }


  proc ez:save_state {win file} {
      upvar #0 HM$win var
      variable configS
      variable ::twez::loc_stackS

      if {($::twez::loc_stackS(valid) != 1) || ($::twez::loc_stackS(valid2) != 1)} {
	# puts stderr "returning early valid:$::twez::loc_stackS(valid) \
	  valid2:$::twez::loc_stackS(valid2)..."
	return ;
      }

      # see if we have a subnotebook.
      set notebook $var(S_notebook)
      if {$notebook != $configS(E_notebook)} {
	puts stderr "Callback is different"
	# Find the top level notebook information.
	set cur_page $configS(P_page)
	puts stderr "cur_page:$cur_page"
	# Now get the page.
	set w [$configS(E_notebook) subwidget $cur_page]
	puts stderr "page:$w"
	# Get the subwidget text window.
	set w [$w.f.a subwidget text]
	puts stderr "text widget:$w"
	set index_glob [lindex [$w yview] 0]
	puts stderr "index:$index_glob"
	upvar #0 HM$w gvar
	set file_glob $gvar(S_file)
	puts stderr "file:$file_glob"
	# save the old spot.
	set index [lindex [$win yview] 0]
	::twez::HTML_push $w $file_glob $index_glob $win $file $index

      } else {

	# save the old spot.
	set index [lindex [$win yview] 0]

	# remember HTML_render cannot set the window except for a table.
	::twez::HTML_push $win $file $index
	# puts stderr "::twez::HTML_push $win $file $index"
      }
  }


  proc ez:reload_file {win filename} {
      variable configS
      upvar #0 HM$win var

      # Signal that we are  busy.
      ez_busy

      set notebook $var(S_notebook)
      if {$notebook != $configS(E_notebook)} {
	puts stderr "not implemented yet."
      } else {
	set page $var(S_page)

	# Get to the right page.
	set w [$notebook subwidget $page]

	# Get the subwidget to build the HTML renderer.
	set w [$w.f.a subwidget text]

	::twez::HTML_view $notebook $page $w $filename $configS(S_fontsize) $configS(S_indent)
      }
      if {$notebook == $configS(E_notebook)} {
	EZset_state -page $page
      }
  }

  proc ez:source_tcl {} {
      variable configS

      set dialog [tix filedialog tixExFileSelectDialog]
      $dialog config -command ::twez::ez:source_dialog

      $dialog subwidget fsbox config -filetypes {
	{{*}            {*     -- All files}}
	{{*.tcl}        {*.tcl -- Tcl source files}}
      }
      $dialog subwidget fsbox config -dir $configS(E_rootdir)/tcl/EZ/tcl
      $dialog subwidget fsbox config -pattern {*\.tcl}
      $dialog subwidget fsbox filter
      $dialog popup
  }

  proc ez:source_dialog {file} {
      ez_message msg "Sourcing file:$file..."
      source $file
  }

  proc ez:man_pages { man_request } {
      variable configS

      set rootdir $configS(E_rootdir)

      if {$man_request == "tcl"} {
	set man_dir $rootdir/tcl/libtcl/doc
      } elseif {$man_request == "tk"} {
	set man_dir $rootdir/tcl/libtk/doc
      } elseif {$man_request == "tix"} {
	set man_dir $rootdir/tcl/libtix/doc
      } elseif {$man_request == "tcllib"} {
	set man_dir $rootdir/tcl/tcllib/man/mann
      } elseif {$man_request == "man1"} {
	set man_dir /usr/man/man1
      } else {
	utdalert_user errmsg ez:man_pages "unknown man request:$man_request"
	return ;
      }
      set dialog [tix filedialog tixExFileSelectDialog]
      $dialog config -command ::twez::ez:read_man_page

      $dialog subwidget fsbox config -filetypes {
	{{*}            {*     -- All files}}
	{{*.1}          {*.1   -- Section 1 man pages}}
	{{*.n}          {*.n   -- Tcl source man pages}}
      }
      $dialog subwidget fsbox config -dir $man_dir
      $dialog subwidget fsbox config -pattern {*.n}
      $dialog popup
  }

  proc ez:read_man_page {file} {
      ez_message msg "Displaying man page:$file..."
      ez:browse_file .ezman $file manpage
  }

  proc ez:help_search {} {
      ez_message msg "Displaying help dialog..."
      set win .ez_help
      if {[winfo exists $win]} {
	wm deiconify $win
	raise $win 
	return
      }
      toplevel $win
      help_dialog $win
  }

  proc help_dialog {w} {
      variable configS

      # Create the label on the top of the dialog box
      #
      label $w.heading -padx 20 -pady 10 -border 1 -relief raised -anchor c -text \
	  "Find a keyword in the current text"

      set name [tixOptionName $w]
      option add *$name*TixComboBox*label.width 16
      option add *$name*TixComboBox*label.anchor n
      option add *$name*TixComboBox*entry.width 45
      
      tixComboBox $w.pattern -label "Search Pattern:" -labelside acrosstop \
	  -editable true -history true -dropdown true -variable ::twez::configS(pattern)

      tixLabelFrame $w.type -label {Pattern Type:} -labelside acrosstop -options {
	label.padX 5
      }
      set f [$w.type subwidget frame]
      radiobutton $f.exact -text Exact -variable ::twez::configS(pattern_type) \
	-relief flat -value exact -bd 2 -pady 0 -width 7 -anchor w
      radiobutton $f.regular -text {Regular Expression} -variable \
	::twez::configS(pattern_type) -relief flat -value regexp -bd 2 -pady 0 \
	-width 19 -anchor w
      pack $f.exact -side left -pady 0 -anchor w -padx 6
      pack $f.regular -side left -pady 0 -anchor w -padx 6

      tixLabelFrame $w.case -label {Case Sensitivity} -labelside acrosstop -options {
	label.padX 5
      }
      set f [$w.case subwidget frame]
      radiobutton $f.sensitive -text Sensitive -variable ::twez::configS(case) \
	-relief flat -value sensitive -bd 2 -pady 0 -width 7 -anchor w
      radiobutton $f.insensitive -text {Insensitive} -variable \
	::twez::configS(case) -relief flat -value insensitive -bd 2 -pady 0 \
	-width 19 -anchor w
      pack $f.sensitive -side left -pady 0 -anchor w -padx 6
      pack $f.insensitive -side left -pady 0 -anchor w -padx 6

      tixButtonBox $w.box -orientation horizontal
      $w.box add ok    -text {Start Search} -underline 0 \
	-command "::twez::ez:start_search $w.box init" -width 10
      $w.box add forward -text {Forward} -underline 0 \
	-command "::twez::ez:start_search $w.box forward" -width 8 -state disabled
      $w.box add backward -text {Backwards} -underline 0 \
	-command "::twez::ez:start_search $w.box backward" -width 9 -state disabled
      $w.box add close -text {Close} -underline 0 \
	-command "destroy $w" -width 6

      pack $w.heading -side top -fill both -expand yes
      pack $w.pattern -side top -expand yes -fill x -anchor s -padx 4 -pady 4
      pack $w.type -side top -padx 20 -anchor center -pady 3
      pack $w.case -side top -padx 20 -anchor center -pady 3
      pack $w.box -side bottom -fill x
  }

  proc ez:start_search { diag_win operation } {
      variable configS
      variable html_winS

      if {[info exists configS(rendering_locked)]} {
	utdalert_user errmsg ez:start_search \
	"Rerendering is not possible when a program is running.  Either kill the \
  program with pid:$configS(rendering_locked) or wait for it to finish.  If the \
  program was started inside an EZ window, make sure to hit the Exit button."
	return ;
      }

      if {([info exists ::utdeditor::editorS(w)]) && \
	  ($::utdeditor::editorS(w) != "") && \
	  ([winfo exists $::utdeditor::editorS(w)])} {
	set win $::utdeditor::editorS(w)
      } else {
	set win $html_winS
      }

      catch {$win tag delete ictag_search} msg
      # Now get the pattern.
      set help_toplevel [winfo parent $diag_win]
      set entry_win [$help_toplevel.pattern subwidget entry]
      set pattern [$entry_win get]
      # set f [$w.case subwidget frame]
      if {$pattern == ""} {
	utdalert_user errmsg ez:start_search "No pattern specified"
	$diag_win subwidget forward config -state disabled
	$diag_win subwidget backward config -state disabled
	return ;
      }
      if {$configS(pattern) != $pattern} {
	# Add to history if not in the history already.
	$help_toplevel.pattern addhistory $pattern
      }
      set configS(pattern) $pattern
      if {$configS(pattern_type) == ""} {
	utdalert_user errmsg ez:start_search "pattern type not specified."
	$diag_win subwidget forward config -state disabled
	$diag_win subwidget backward config -state disabled
	return ;
      }
      if {$operation == "init"} {
	set search_idx 1.0
	set direction -forwards
      } elseif {$operation == "forward"} {
	set search_idx "$configS(search_lastidx) wordend"
	set direction -forwards
      } elseif {$operation == "backward"} {
	set search_idx "$configS(search_lastidx) wordstart"
	set direction -backwards
      }
      if {$configS(case) == "insensitive"} {
	set idx [$win search -nocase $direction -$configS(pattern_type) \
	  $configS(pattern) $search_idx]
      } else {
	set idx [$win search $direction -$configS(pattern_type) \
	  $configS(pattern) $search_idx]
      }
      if {$idx == ""} {
	ez_message warn "No match found."
	$diag_win subwidget forward config -state disabled
	$diag_win subwidget backward config -state disabled
      } else {
	$win see $idx
	ez_message msg "Found match at $idx."
	$win tag add ictag_search $idx "$idx wordend"
	$win tag configure ictag_search  -foreground green
	$diag_win subwidget forward config -state normal
	$diag_win subwidget backward config -state normal
	set configS(search_lastidx) $idx
      }
  }

  proc ez:stop_render { } {
    variable urlS
    variable stopS
    set stopS 1
    ez_message warn "Rendering of $urlS stopped."
  }

  proc ez:search_the_html { } {
    variable urlS
    variable configS

    # Get to the right page.
    set w [$configS(E_notebook) subwidget $configS(P_page)]

    # Get the subwidget to build the HTML renderer.
    set w [$w.f.a subwidget text]

    ez:save_state $w $urlS

    set urlS $configS(E_rootdir)/tcl/EZ/html/search/search.html
    ez:rerender
  }

  proc ez:native_browser { } {
      return 1
  }

  proc ez:version { } {
      ::twalert::AlertBox "UTDtools version:\n[utdtools_version]"
  }

  proc ez:design_info { } {
      variable configS

      if {([info exists configS(S_design)]) && ($configS(S_design) != "")} {
	set msg "Design : $configS(S_design)\n"
      } else {
	set msg "Design : none (unset)\n"
      }
      if {([info exists configS(S_design_dir)]) && ($configS(S_design_dir) != "")} {
	append msg "Design Directory : $configS(S_design_dir)\n"
      } else {
	append msg "Design Directory : none (unset)\n"
      }
      ::twalert::AlertBox "$msg"
  }

  proc ez:notebook_state {frozen_state} {
      variable configS

      set win $configS(E_notebook)
      set pages [$win pages]
      foreach page $pages {
	if {$frozen_state} {
	  $win pageconfigure $page -state disabled
	} else {
	  $win pageconfigure $page -state normal
	}
      }
  }

  proc check_pids {pids args} {
      variable configS

      if {$args != ""} {
	lappend pids $args
      }

      if {$pids == ""} {
	ez:notebook_state false
	if {[info exists configS(rendering_locked)]} {
	  set configS(pids_finished) true
	  unset configS(rendering_locked)
	  ez_ready
	}
	return ;
      }
      set working false
      foreach pid $pids {
	if {[utdprocess exists $pid]} {
	  set working true
	  break ;
	}
      }
      if {$working} {
	# Requeue ourself
	foreach process_id $pids {
	  set code [utdprocess wait $process_id -nohang]
	  # puts stderr "wait code:$code"
	}
	after 2000 "::twez::check_pids $pids"
	# puts stderr "waiting for $pids to finish...\n"
	ez_busy
      } else {
	ez:notebook_state false
	if {[info exists configS(rendering_locked)]} {
	  set configS(pids_finished) true
	  unset configS(rendering_locked)
	  utdredraw event
	  ez_ready
	}
      }
  }

  proc lock_page {pids} {
      variable configS

      ez:notebook_state true
      set configS(rendering_locked) $pids
      ez_busy
      after 2000 "::twez::check_pids $pids"
  }

  proc ez:font_select { } {
      global env
      global icdirG
      if {[info exists env(ICDIR)]} {
	set icdirG $env(ICDIR)
	twfonts::display
      } else {
	puts stderr "ERROR:cannot get iTools environment variable"
      }
  }
}

proc ez_message {args} {
  eval ::twez::ez_message $args
}
