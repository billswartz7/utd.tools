#!/usr/local/bin/wish -f
# Program: common file select interface
# $Id: fselect.tcl,v 1.7 2022/07/11 20:38:28 bills Exp $
# $Log: fselect.tcl,v $
# Revision 1.7  2022/07/11 20:38:28  bills
# Added the set_browse_cmd so we can reconfigure which files to search.
#
# Revision 1.6  2008/01/10 05:43:39  bills
# Now we allow multiple file suffixes but the first one given is the
# default suffix.
#
# Revision 1.5  2005/12/19  15:15:10  bills
# Changed errmsg to warning message when file is canceled.
#
# Revision 1.4  2005/05/06  05:29:01  bills
# Added options -noborders and -noblank options.  Added display proc.
#
# Revision 1.3  2005/02/08  17:46:53  bills
# Added -directory and -toplevel arguments to file selection.
#
# Revision 1.2  2003/01/31  16:07:21  bills
# Now file selector returns boolean denoting whether user selected or not.
#
# Revision 1.1  2003/01/06  08:35:21  bills
# Initial revision
#
#

namespace eval utdtoolsgui {

  namespace eval fileselect {
    variable checkS
    variable stateS

    proc chose {cmd dialog_label sel_label utdvar suffix filetype pgm_update} {
      variable stateS
      set w .utdfselect
      if [winfo exists $w] {
	wm deiconify $w
	raise $w
	return 0 ;
      }
      toplevel $w
      wm title $w $dialog_label
      set f [select_file $w $sel_label $utdvar $suffix $filetype]
      if {$f} {
	if {$pgm_update} {
	  update
	}
	if {$stateS($icvar) != ""} {
	  eval $cmd $stateS($icvar)
	} else {
	  eval $cmd
	}
	if {$pgm_update} {
	  update
	}
	return 1
      } else {
	utdmsg warnmsg utdtoolsgui::fileselect::chose "Restore canceled.\n"
      }
      return 0
    }

    proc display {w dialog_label sel_label utdvar suffix filetype args} {
      variable stateS
      if [winfo exists $w] {
	wm deiconify $w
	raise $w
	return 0 ;
      }
      toplevel $w
      wm title $w $dialog_label
      set f [select_file $w $sel_label $utdvar $suffix $filetype $args]
      return $f
    }

    proc select_file {w sel_label utdvar suffix filetype args} {
      variable stateS
      variable checkS

      set topwin $w
      set border_val 1
      set blank_allowed 1
      set num_args [llength $args]
      for {set i 0} {$i < $num_args} {incr i} {
	set arg_el [lindex $args $i]
	if {$arg_el == "-directory" } {
	  incr i
	  set stateS(dir,$icvar) [lindex $args $i]
	} elseif {$arg_el == "-topwindow" } {
	  incr i
	  set topwin [lindex $args $i]
	} elseif {$arg_el == "-noborders" } {
	  set border_val 0
	} elseif {$arg_el == "-noblank" } {
	  set blank_allowed 0
	} else {
	  utdmsg errmsg ::utdtoolsgui::fileselect::select_file "Unknown arguments: $args\n"
	  return ;
	}
      }


      # Create a variable and set it to NULL.
      if {[info exists stateS($utdvar)] == 0} {
	set stateS($utdvar) {}
      }

      tixButtonBox $w.box -orientation horizontal
      $w.box add accept   -text Ok    -underline 0 \
	-command "set ::utdtoolsgui::fileselect::checkS true;destroy $topwin"
      $w.box add cancel -text {Cancel} -underline 0 \
	-command "set ::utdtoolsgui::fileselect::checkS false;destroy $topwin"

      frame $w.top -border $border_val -relief raised
      if {$blank_allowed} {
	frame $w.labframe -border 1 -relief raised
	label $w.labframe.lab -text { Leave Entry Form Blank for Default Filename}
      }

      tixLabelEntry $w.top.ent -label $sel_label -labelside top -options "
	entry.width 45
	entry.textVariable ::utdtoolsgui::fileselect::stateS($utdvar)
	label.anchor w
      "

      bind [$w.top.ent subwidget entry] <Return> "::utdtoolsgui::fileselect::okcmd $w $utdvar"

      button $w.top.btn -text "Browse ..." \
	-command "[list ::utdtoolsgui::fileselect::browse $utdvar $suffix $filetype $topwin]"

      pack $w.top.ent -side left -expand yes -fill x -anchor s -padx 4 -pady 4
      pack $w.top.btn -side left -anchor s -padx 4 -pady 4
      pack $w.top -side top -fill both -expand yes
      pack $w.box -side top -fill x
      if {$blank_allowed} {
	pack $w.labframe.lab -side left -anchor c
	pack $w.labframe -side bottom -fill x
      }
      tkwait window $w

     if {$checkS} {
       unset checkS
       return true
     } else {
       unset checkS
       return false
     }
    }

    proc browse { utdvar suffix filetype w } {
      variable stateS

      set dialog [tix filedialog tixExFileSelectDialog]
      $dialog config -command "::utdtoolsgui::fileselect::file_set $w $utdvar"
      if {[info exists stateS(dir,$utdvar)]} {
	$dialog subwidget fsbox config -dir $stateS(dir,$utdvar)
      } else {
	$dialog subwidget fsbox config -dir [pwd]
      }

      if {$suffix != ""} {
	lappend fpat [list "*" "*     -- All files"]
	foreach suf $suffix {
	  lappend fpat [list "*.$suf" "*.$suf -- $filetype"]
	}
	$dialog subwidget fsbox config -filetypes $fpat
	set default_suffix [lindex $suffix 0]
	$dialog subwidget fsbox config -pattern "*\.$default_suffix"
      } else {
	set fpat [list [list "*" "*     -- All files"]]
	$dialog subwidget fsbox config -filetypes $fpat
	$dialog subwidget fsbox config -pattern "*"
      }
      update
      $dialog subwidget fsbox filter
      # puts stderr "dialog:$dialog"
      $dialog popup
    }

    proc okcmd {w utdvar} {
      variable stateS

      if {$stateS($utdvar) != {}} {
	utdmsg imsg null "You have selected the file $stateS($utdvar)\n"
      } else {
	utdmsg errmsg ::utdtoolsgui::fileselect::okcmd "You haven't selected any file\n"
      }
    }

    proc file_set {w utdvar file} {
      variable stateS

      # puts stderr "file:$file icvar:$icvar"
      utmsg imsg null "Selected file:$file...\n"
      set stateS($utdvar) $file
      if [winfo exists $w] {
	wm deiconify $w
	raise $w
      }
    }

    proc selected_file { utdvar } {
      variable stateS

      if {([info exists stateS($utdvar)]) && ($stateS($utdvar) != "")} {
	return $stateS($utdvar)
      } else {
	return ""
      }
    }

    proc set_browse_cmd {w utdvar suffix filetype} {
      $w.top.btn configure -command "[list ::utdtoolsgui::fileselect::browse $utdvar $suffix $filetype $w]"
    }
  }
}
