#!/usr/local/bin/wish -f
# $Id: editor.tcl,v 1.7 2004/03/17 00:22:24 bills Exp $
# $Log: editor.tcl,v $
# Revision 1.7  2004/03/17 00:22:24  bills
# Updated to pass TclPro Checker.
#
# Revision 1.6  2004/03/15  17:08:09  bills
# Updated for latest Tcl/Tk 8.4.5 which has built in undo/redo.
#
# Revision 1.5  2004/03/04  07:51:58  bills
# Hack to get editor commands working somewhat.
#
# Revision 1.4  2004/02/05  04:48:27  bills
# Added the Done button and the -nonone switch for the I/O Editor.
#
# Revision 1.3  2003/06/09  03:23:20  bills
# Now the editor properly works on multiple files.
#
# Revision 1.2  2003/02/19  19:53:45  bills
# Added the -view switch to build a view only version.
#
# Revision 1.1  2003/02/17  13:20:51  bills
# Initial revision
#
#
#

namespace eval utdeditor {
  variable editorS

  proc display {w name_label side args} { 

    variable editorS

    set need_none_button 1
    if {[info exists editorS(editor)] == 0} {
      set editorS(editor) tk
    }

    if {[info exists editorS(view)] == 0} {
      set editorS(view) 1
    }
    if {[info exists editorS(w)] == 0} {
      set editorS(w) .ictk_editor
    }
    if {[info exists editorS(filename,$w)] == 0} {
      set editorS(filename,$w) ""
    }
    if {[info exists editorS(command,$w)] == 0} {
      set editorS(command,$w) ""
    }
    set exec_button 0
    set done_button 0
    set num_args [llength $args]
    set editorS(view_only) 0
    for {set i 0} {$i < $num_args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-exec_button" } {
	set exec_button 1
      } elseif {$arg_el == "-view" } {
	set editorS(view_only) 1
      } elseif {$arg_el == "-nonone" } {
	set need_none_button 0
      } elseif {$arg_el == "-done_button" } {
	set done_button 1
      } elseif {$arg_el == "-command" } {
	incr i
	set editorS(command,$w) [lindex $args $i]
      } else {
	utdmsg errmsg ::utdeditor::display "Unknown arguments: $args\n"
	return ;
      }
    }

    tixLabelFrame $w.lframe -label $name_label -labelside $side
    set f [$w.lframe subwidget frame]
    set fedit [frame $f.editor]
    if {!($exec_button) && ($need_none_button)} {
      radiobutton $fedit.none \
	-text {none} \
	-value {none} \
	-variable ::utdeditor::editorS(editor) \
	-borderwidth {3}
    }
    radiobutton $fedit.tk \
      -text {tk} \
      -value {tk} \
      -variable ::utdeditor::editorS(editor) \
      -borderwidth {3}
    radiobutton $fedit.vi \
      -text {vi} \
      -value {vi} \
      -variable ::utdeditor::editorS(editor) \
      -borderwidth {3}
    radiobutton $fedit.emacs \
      -text {emacs} \
      -value {emacs} \
      -variable ::utdeditor::editorS(editor) \
      -borderwidth {3}
    if {[editor_exists nedit]} {
      radiobutton $fedit.nedit \
	-text {nedit} \
	-value {nedit} \
	-variable ::utdeditor::editorS(editor) \
	-borderwidth {3}
      set editorS(nedit) $fedit.nedit
    } else {
      set editorS(nedit) ""
    }
    if {[info exists env(EDITOR)]} {
      set user_editor $env(EDITOR)
      set editorname [file tail $user_editor]
      if {($editorname != "vi") && ($editorname != "emacs") && \
	($editorname != "nedit")} {
	set editorS(user_editor) $user_editor
	radiobutton $fedit.user \
	  -text $editorname \
	  -value {user} \
	  -variable ::utdeditor::editorS(editor) \
	  -borderwidth {3}
      }
    }
    if {!($exec_button) && ($need_none_button)} {
      pack $fedit.none -side left
    }
    pack $fedit.tk -side left
    pack $fedit.vi -side left
    pack $fedit.emacs -side left
    if {$editorS(nedit) != ""} {
      pack $fedit.nedit -side left
    }
    if {[info exists editorS(user_editor)]} {
      pack $fedit.user -side left
    }

    pack $fedit -side top -fill x

    set fmode [frame $f.mode]
    label $fmode.lab -text  {Mode: }
    checkbutton $fmode.readonly -text {Read-Only} -variable \
      ::utdeditor::editorS(view) -offvalue {0} -onvalue {1}
    if {$editorS(view_only)} {
      $fmode.readonly configure -state disabled
      set exec_button_label {View File}
    } else {
      $fmode.readonly configure -state normal
      set exec_button_label {Edit File}
    }

    if {($exec_button) || ($done_button)} {
      set fexec [frame $f.exec]
      tixButtonBox $fexec.but -orientation horizontal -padx 0 -pady 0
      if {($exec_button)} {
	if {$editorS(command,$w) != ""} {
	  # take command apart so we pass $w as first argument.
	  $fexec.but add exec -text $exec_button_label -command \
	    "[lindex $::utdeditor::editorS(command,$w) 0] $w \
	    [lrange $::utdeditor::editorS(command,$w) 1 end]"
	} else {
	  $fexec.but add exec -text $exec_button_label -command \
	    "::utdeditor::edit_file $::utdeditor::editorS(filename,$w) $::utdeditor::editorS(w)"
	}
      }
      if {($done_button)} {
	$fexec.but add done -text Done -command "destroy $w"
      }
      pack $fexec.but -side top
    }

    pack $fmode.lab -side left -padx 5
    pack $fmode.readonly -side left -padx 5
    pack $fmode -side top -fill x
    if {($exec_button) || ($done_button)} {
      pack $fexec -side top -fill x
    }
    pack $w.lframe -side top -fill x
  }


  proc edit_file {filename w args} {
    variable editorS

    if {[file exists $filename] == 0} {
      # Assume we are in EZ - if not just use the general message command.
      if {[catch {icalert_user errmsg edit_file "File $filename does not exist.\n"} msg]} {
	utdmsg errmsg edit_file "File $filename does not exist.\n"
      }
      return ;
    }

    set num_args [llength $args]
    for {set i 0} {$i < $num_args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-edit" } {
	set editorS(view) 0
      } elseif {$arg_el == "-view" } {
	set editorS(view) 1
      } else {
	utdmsg errmsg ::utdeditor::edit_file "Unknown arguments: $args\n"
	return ;
      }
    }

    if {[info exists editorS(editor)] == 0} {
      set editorS(editor) tk
    }

    set view $editorS(view)
    switch $editorS(editor) {
      "none" {
	return
      }
      "tk" {
	if {$view} {
	  load_file_name $w $filename file "Browsing $filename"
	} else {
	  load_file_name $w $filename edit_file "Editing $filename"
	}
      }
      "vi" {
	global statusG
	if {$view} {
	  bgexec statusG xterm -sb -sl 5000 -e view $filename
	} else {
	  bgexec statusG xterm -sb -sl 5000 -e vi $filename
	}
      }
      "emacs" {
	global statusG
	bgexec statusG emacs $filename
      }
      "nedit" {
	global statusG
	if {$view} {
	  bgexec statusG nedit -read $filename
	} else {
	  bgexec statusG nedit $filename
	}
      }
      "user" {
	global statusG
	bgexec statusG $utdeditorS(user_editor) $filename
      }
    }
  }

  proc editor_exists {editor} {
    global env
    set path $env(PATH)
    if {$path == ""} {
      return 0 ;
    }
    set pathdirs [split $path :]
    foreach dir $pathdirs {
      set testfile [file join ${dir} $editor]
      if {([file executable $testfile]) && ([file isfile $testfile])} {
	return 1 ;
      }
    }
    return 0 ;
  }



  proc load_file_name {w filename action title} {
    global tixOption

    if {[winfo exists $w]} {
	wm deiconify $w
	raise $w
	return
    }
    toplevel $w 
    wm title $w $title

    if {$action == "edit_file"} {
      button $w.b -text "Close/Discard Edit" -command "destroy $w"
      button $w.b2 -text "Close/Save" -command "::utdeditor::save_file_name $filename $w"
      set t [tixScrolledText $w.text]
      tixForm $w.b    -left 0 -bottom -0 -padx 4 -pady 4
      tixForm $w.text -left 0 -right -0 -top 0 -bottom $w.b
      tixForm $w.b2   -left "$w.b 10" -bottom -0 -padx 4 -pady 4
    } else {
      button $w.b -text Close -command "destroy $w"
      set t [tixScrolledText $w.text]
      tixForm $w.b    -left 0 -bottom -0 -padx 4 -pady 4
      tixForm $w.text -left 0 -right -0 -top 0 -bottom $w.b
    }

    $t subwidget text config -highlightcolor [$t cget -bg] -bd 2 \
	-bg [$t cget -bg] -font $tixOption(fixed_font) 
    if {$filename == {}} {
	return
    }

    set text [$w.text subwidget text]
    $text config -wrap none

    read_file $text $filename $action

    if {$action == "edit_file"} {
      $text config -state normal -undo true
      update
      # edit:init_bindings $text
    }

  }

  proc read_file {text filename action} {
    global mystatus man_data myerror
    set oldState [$text cget -state]
    $text config -state normal
    $text delete 0.0 end
    set curdir [pwd]

    switch $action {
      "file" {
	set fd [open $filename {RDONLY}]
	$text delete 1.0 end

	while {![eof $fd]} {
	    $text insert end [read $fd 1000]
	}
	close $fd
	$text see 1.0
	$text config -state disabled
      }
      "edit_file" {
	set fd [open $filename {RDONLY}]
	$text delete 1.0 end

	while {![eof $fd]} {
	    $text insert end [read $fd 1000]
	}
	close $fd
	$text see 1.0
	$text config -state normal
      }
    }

    # Restore current working directory.
    cd $curdir
  }

  proc save_file_name {filename topwin} {
    set f [open $filename w]

    set win [$topwin.text subwidget text]
    scan [$win index end-1c] %d numLines
    for {set i 1} {$i < $numLines} {incr i} {
      $win mark set last $i.0
      puts $f [$win get last "last lineend"]
    }
    close $f
    destroy $topwin
    update
  }

  proc set_filename {fname w} {
    variable editorS

    set editorS(filename,$w) $fname
  }

  proc set_command {cmd w} {
    variable editorS

    set editorS(command,$w) $cmd
  }

  proc set_window {w} {
    variable editorS
    set editorS(w) $w
  }

  proc undo_win { } {
    variable editorS
    if {([info exists editorS(w)]) && ($editorS(w) != "")} {
      if {[winfo exists $editorS(w)]} {
	$editorS(w) edit undo
      }
    }
  }

  proc redo_win { } {
    variable editorS
    if {([info exists editorS(w)]) && ($editorS(w) != "")} {
      if {[winfo exists $editorS(w)]} {
	$editorS(w) edit redo
      }
    }
  }

  proc cut_win { } {
    variable editorS
    if {([info exists editorS(w)]) && ($editorS(w) != "")} {
      if {[winfo exists $editorS(w)]} {
	tk_textCut $editorS(w)
      }
    }
  }

  proc copy_win { } {
    variable editorS
    if {([info exists editorS(w)]) && ($editorS(w) != "")} {
      if {[winfo exists $editorS(w)]} {
	tk_textCopy $editorS(w)
      }
    }
  }

  proc paste_win { } {
    variable editorS
    if {([info exists editorS(w)]) && ($editorS(w) != "")} {
      if {[winfo exists $editorS(w)]} {
	tk_textPaste $editorS(w)
      }
    }
  }

}
