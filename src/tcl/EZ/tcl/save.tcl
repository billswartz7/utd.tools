#
#  Copyright (c) 1996, 1999 by Internet CAD, Inc.
# 
# @(#)$RCSfile: save.tcl,v $
# $Log: save.tcl,v $
# Revision 1.23  2022/11/06 15:56:17  bills
# Updated to use the twez namespace to avoid name clashes and
# to reorganize the code better.
#
# Revision 1.22  2018/11/11 22:49:03  bills
# Updated for RCS fiasco.
#
# Revision 1.23  2015/05/28 11:12:07  bills
# Fixed problems with project file not being created properly.
#
# Revision 1.22  2015/05/27 17:46:40  bills
# Now we can take a design name to build a project path.
#
# Revision 1.21  2007/09/12 20:34:54  bills
# Now we check to make sure any link to .itools is valid.
#
# Revision 1.20  2005/02/01  18:06:53  bills
# Upon reload we need to clean out the old Tcl variables.
#
# Revision 1.19  2005/01/07  14:37:23  bills
# Improved the EZ startup when specifying a project file.  Now the command
# EZ <projectFileName> works with both full and partial pathnames.
#
# Revision 1.18  2004/03/16  23:03:30  bills
# Changes made for new utdalert_user and ez_message command.  Also
# ran thru Tcl ProCheck.
#
# Revision 1.17  2004/02/09  20:54:11  bills
# Now we restore the initial directory when we start a new project.
#
# Revision 1.16  2004/01/20  17:56:56  bills
# Got rid of ezdir creation as it is unnecessary.  In addition, now
# we save the initwd directory.
#
# Revision 1.15  2003/11/06  07:35:06  bills
# Now save the itools version in the save file.
#
# Revision 1.14  2003/03/23  01:34:53  bills
# Now we use ez.ini.pid so we can have multiple EZ's running.
#
# Revision 1.13  2003/02/02  19:53:01  bills
# Added recent project support.  Not completely correct yet.
#
# Revision 1.12  2003/01/31  15:48:17  bills
# Major rewrite of EZ so we can support projects.  We introduced the
# E_xxx variable and changed many variables from P_xxx to S_xxx so
# we can make the users life easier.
#
# Revision 1.11  2000/06/24  17:22:03  bills
# Updated save.tcl to use nativename call.
#
# Revision 1.10  2000/04/26  16:37:35  bills
# Got rid of [exec date] call and now use the native [clock seconds]
# command so we dont need to use bgexec.
#
# Revision 1.9  1999/06/17  11:01:14  bills
# Updated for iTools name change.
#
# Revision 1.8  1998/11/08  19:45:49  bills
# Now prevent a crash when the current working directory is out of
# sync or invalid.
#
# Revision 1.7  1998/08/07  23:33:46  bills
# Now create the ~/.itools directory if it doesn't exist.
#
# Revision 1.6  1998/07/27  21:49:43  bills
# Changed global ICreadparG to ICparG.
#
# Revision 1.5  1998/07/23  15:10:39  bills
# Got rid of messages.
#
# Revision 1.4  1998/07/21  21:59:55  bills
# Modified tcl so that autosaving will work properly.
#
# Revision 1.3  1998/07/16  18:45:09  bills
# Non-working verion of save.  Only works for native version.
#
# Revision 1.2  1998/07/15  15:39:08  bills
# Now the name of ez init file is ez.ini.  In addition, we added save
# features for native browsers.
#
#

namespace eval twez {
  proc auto_save { } {
      variable urlS
      variable configS
      variable html_winS

      puts stderr "entered auto_save: $configS(E_autosave)"
      if {$configS(E_autosave) == 0} {
	return ;
      }

      set user_utdtoolsdir [file nativename ~/.utdtools]
      if {([file exists $user_utdtoolsdir])} {
	if {[file isdirectory $user_utdtoolsdir] == 0} {
	  set ftype [file type $user_utdtoolsdir]
	  if {$ftype == "link"} {
	    # make sure we can read the link.
	    set flink [file readlink $user_utdtoolsdir]
	    if {!([file exists $flink])} {
	      utdmsg errmsg auto_save "The .utdtools directory $user_utdtoolsdir \
    points to a directory $flink which doesn't exist.  Please fix the link or \
    delete it entirely.\n\n"
	      exit 1
	    }
	  }
	}
      } else {
	exec mkdir $user_utdtoolsdir
      }

      # Now save the project information.
      set pid_name [pid]
      set filename [file join $user_utdtoolsdir ez.ini.${pid_name}]
      set f [open $filename w]
      # Get the date.
      set secs [clock seconds]
      set todays_date [clock format $secs]

      if {$urlS != ""} {
	set configS(S_url) $urlS
      }
      set configS(S_page) [$configS(E_notebook) raised]
      puts $f "# State of EZ utdTools [utdtools_version] @ $todays_date"
      puts $f "# Current directory"
      # Get the current directory.
      puts $f "if \{\[file exists [pwd]\]\} \{"
      puts $f "  cd [pwd]"
      puts $f "\}"

      puts $f "# Current values of EZlearn variables"
      set a [array get configS S_*]
      save_array $f configS $a

      puts $f "# Current hypertext file"
      if {$urlS != ""} {
	puts $f "set ::twez::urlS $urlS"
      } else {
	puts $f "set ::twez::urlS \{\}"
      }
      puts $f "# Current hypertext window"
      if {$html_winS != ""} {
	puts $f "set ::twez::html_winS $html_winS"
      } else {
	puts $f "set ::twez::html_winS \{\}"
      }
      close $f

      update
  }

  proc update_projects {filename} {
      variable configS

      set user_utdtoolsdir [file nativename ~/.utdtools]
      set pid_name [pid]
      set new_ini [file join $user_utdtoolsdir ez.ini.${pid_name}]
      if {$filename == $new_ini} {
	return ; # Don't save ez.ini as a project.
      }

      # Now update the project file.
      if {([info exists configS(S_study)]) && \
	  ([info exists configS(S_lesson)]) && \
	  ([info exists configS(S_project)]) && \
	  ($configS(S_study) != "") && \
	  ($configS(S_project) != "") && \
	  ($configS(S_lesson) != "")} {
	set prjfilename [file join $user_utdtoolsdir project.ini]
	if {[file exists $prjfilename]} {
	  source $prjfilename
	}
	set configS(timestamp,$filename) [clock seconds]
	set fp [open $prjfilename w] 
	if {$fp != ""} {
	  set a [array get configS timestamp,*]
	  save_array $fp configS $a
	  close $fp
	}
	update_project_menu
      }
  }

  proc update_project_menu { } {
      variable configS

      set user_utdtoolsdir [file nativename ~/.utdtools]
      set prjfilename [file join $user_utdtoolsdir project.ini]
      if {[file exists $prjfilename]} {
	source $prjfilename
	# Now sort the file by timestamp.
	set project_list ""
	foreach {key value} [array get configS timestamp,*] {
	  lappend project_list [list $key $value]
	}
	set sorted_projects [lsort -integer -index 1 -decreasing $project_list]
	set cnt 0
	set m2 $configS(E_project_menu)
	$m2 delete 0 end

	foreach project $sorted_projects {
	  set encoded_dsn_info [lindex $project 0]
	  set dsn_info [split $encoded_dsn_info ,]
	  if {[llength $dsn_info] == 2} {
	    incr cnt
	    set project [lindex $dsn_info 1]
	    $m2 add command -label "$cnt $project" \
	      -command "::twez::open_recent_project $project"
	  }
	}
      }
  }

  proc save_array { f arrname a } {
      set len [llength $a]
      puts $f "# variable ::twez::$arrname"
      for {set i 0} {$i < $len} {incr i} {
	puts -nonewline $f "set ::twez::${arrname}"
	puts -nonewline $f "\("
	puts -nonewline $f "[lindex $a $i]"
	puts -nonewline $f "\)"
	incr i 
	set val [lindex $a $i]
	puts -nonewline $f " \{"
	puts -nonewline $f "[lindex $a $i]"
	puts $f "\}"
      }
  }

  proc open_project { } {
    variable configS
    auto_save
    set abort_open [project_save 0]
    if {$abort_open} {
      return ;
    }
    set picked [::utdtoolsgui::fileselect::chose open_cmd {Open Project...} \
      {Project File} {S_project} {epj} {Itools Project} false]
  }

  proc open_cmd {project} {
    variable configS

    set suffix [file extension $project]
    if {$suffix == ".epj"} {

      set first_char [string index $project 0]
      if {($first_char != "~") && ($first_char != "/")} {
	if {([info exists configS(E_initwd)]) && ($configS(E_initwd) != "")} {
	  set project_path [file join $configS(E_initwd) $project]
	} else {
	  set project_path $project
	}
      } else {
	set project_path $project
      }
    } else {
      set assumed_root_name [file rootname $project]
      set assumed_dsn_name [file tail $assumed_root_name]
      set proposed_project "${assumed_dsn_name}.epj"
      set project_path [file join [pwd] $proposed_project]
      if {!([file exists $project_path])} {
	set configS(S_design_dir) [pwd]
	set configS(S_design) $assumed_dsn_name
	project_save true
      }
    }
    if {!([file exists $project_path])} {
      utdalert_user errmsg open_cmd "EZ project file: $project not found.\
   Assumed path: $project_path.  Opening last valid project."
      return 1
    }

    if {[info exists configS]} {
      set sav_vars [array get configS E*]
      unset configS
      array set configS $sav_vars
    }
    source $project_path
    update_projects $project

    if {[info exists configS(S_page)]} {
      page $configS(S_page)
    }
  }

  proc open_recent_project {project} {
    variable configS

    auto_save
    set abort_open [project_save 0]
    if {$abort_open} {
      return ;
    }

    source $project
    update_projects $project

    if {[info exists configS(S_page)]} {
      page $configS(S_page)
    }
  }

  proc clean_project {page} {
    variable configS
    auto_save
    set abort_cmd [project_save 0]
    if {$abort_cmd} {
      return ;
    }
    set user_utdtoolsdir [file nativename ~/.utdtools]
    set pid_name [pid]
    set new_ini [file join $user_utdtoolsdir ez.ini.${pid_name}]
    if {[file exists $new_ini]} {
      file delete -force -- $new_ini
    }
    array set tmp [array get configS E_*]
    unset configS
    array set configS [array get tmp]
    if {[file isdirectory $configS(E_initwd)]} {
      cd $configS(E_initwd)
    }
    ICinit_state $configS(E_icdir) $configS(E_initwd)
    page $page
  }

  proc close_project { } {
    clean_project welcome
  }

  proc new_project { } {
    clean_project start
  }

  proc save_project { } {
    auto_save
    project_save 1
  }

  proc project_save_as { } {
    set picked [::utdtoolsgui::fileselect::chose save_cmd {Save Project As...} \
      {Project File} {S_project} {epj} {Itools Project} false]

  }

  proc save_cmd {project} {
    variable configS
    auto_save
    set user_utdtoolsdir [file nativename ~/.utdtools]
    set pid_name [pid]
    set new_ini [file join $user_utdtoolsdir ez.ini.${pid_name}]
    file copy -force -- $new_ini $project
    update_projects $project
  }

  proc project_save {force_save} {
    variable configS

    set debug true
    set call_level [info level]
    incr call_level -1
    set call_data [info level $call_level]
    set calling_func [lindex $call_data 0]
puts stderr "project_save:calling: $calling_func call_data:$call_data"
    if {($calling_func == "ez_exit") || ($calling_func == "project_save") || \
        ($calling_func == "::twez::project_save")} {
      set project_output true
    } else {
      set project_output false
    }
    if {$debug} {
      puts stderr "call func: $calling_func project output: $project_output"
      puts stderr "entering project_save: forced: $force_save"
    }
    set user_utdtoolsdir [file nativename ~/.utdtools]
    if {([info exists configS(S_study)]) && \
	([info exists configS(S_lesson)]) && \
	([info exists configS(S_project)]) && \
	($configS(S_study) != "") && \
	($configS(S_project) != "") && \
	($configS(S_lesson) != "")} {
      set pid_name [pid]
      set link_ini [file join $user_utdtoolsdir ez.ini]
      set new_ini [file join $user_utdtoolsdir ez.ini.${pid_name}]
      set ezini_exists [file exists $new_ini]
      set pname $configS(S_project)
      set pname ${pname}.epj
      set old_ini [file join $user_utdtoolsdir $pname]
      if {([file exists $old_ini]) && ($ezini_exists)} {
	set diff [project_diff $new_ini $old_ini]
      } else {
	set diff 1
      }
      if {$diff != 0} {
	if {!($force_save)} {
	  set reply [save_display $configS(S_study) $configS(S_lesson)] 
	} else {
	  set reply 1
	}
	if {$reply == -1} {
	  return 1 ; # abort exit.
	} elseif {$reply == 1} {
	  if {[file exists $old_ini]} {
	    if {$debug} {
	      puts stderr "file rename -force -- $new_ini $old_ini"
	    }
	    file rename -force -- $new_ini $old_ini
	    project_link $link_ini $old_ini
	    update_projects $old_ini
	  } else {
	    if {($project_output)} {
	      file rename -force -- $new_ini $old_ini
	      project_link $link_ini $old_ini
	      update_projects $old_ini
	    } else {
	      project_link $link_ini $new_ini
	      update_projects $new_ini
	    }
	  }
	} else {
	  if {$debug} {
	    puts stderr "file delete -force -- $new_ini"
	  }
	  file delete -force -- $new_ini
	  if {[file exists $old_ini]} {
	    project_link $link_ini $old_ini
	  }
	}
      } else {
	file delete -force -- $new_ini
	project_link $link_ini $old_ini
      }
    } else {
      if {$force_save} {
	utdalert_user errmsg project_save "Design or design directory name is not set.  Save aborted."
	return 1
      }
    }
    return 0
  }

  proc project_diff {file1 file2} {
    set f1 [open $file1 r]
    set f2 [open $file2 r]
    set fcontents1 [read $f1]
    set idx1 [string first \n $fcontents1]
    if {$idx1 == -1} {
      return 1
    }
    set fcontents1 [string range $fcontents1 $idx1 end]
    close $f1
    set fcontents2 [read $f2]
    set idx2 [string first \n $fcontents2]
    if {$idx2 == -1} {
      return 1
    }
    set fcontents2 [string range $fcontents2 $idx2 end]
    close $f2
    string compare $fcontents1 $fcontents2
  }

  proc project_link {filename project_name} {
      # puts stderr "linking filename:$filename project: $project_name"
      set f [open $filename w]
      # Get the date.
      set secs [clock seconds]
      set todays_date [clock format $secs]
      puts $f "# State of EZ iTools @ $todays_date"
      puts $f "# EZ file linked"
      # Get the current directory.
      puts $f "if \{\[file exists $project_name\]\} \{"
      puts $f "  source $project_name"
      puts $f "\}"
      close $f
  }

  proc save_display {study lesson} {
    variable configS
    set w .utdsave
    if {[winfo exists $w]} {
      wm deiconify $w
      raise $w
      return ;
    }
    toplevel $w
    wm title $w "Save Project..."

    # Create the label on the top of the dialog box
    label $w.top -padx 20 -pady 10 -border 1 -relief raised -anchor c -text \
    "Do you want to save the project information for the lesson:\n\
  $lesson\nin \n$study?"

    set configS(reply) 1
    tixButtonBox $w.box -orientation horizontal
    $w.box add yes -text Yes    -underline 0 -command "::twez::save_pcmd $w 1" -width 5
    $w.box add no -text No -underline 0 -command "::twez::save_pcmd $w 0" -width 5
    $w.box add cancel -text Cancel -underline 0 -command "::twez::save_pcmd $w -1" -width 5

    pack $w.box -side bottom -fill x
    pack $w.top -side top -fill both -expand yes
    focus [$w.box subwidget yes] 
    tkwait window $w
    return $configS(reply)
  }

  proc save_pcmd {w state} {
    variable configS
    set configS(reply) $state
    destroy $w
  }

  proc ezset {args} {
    if {[catch {uplevel #0 eval set $args} msg]} {
      utdalert_user errmsg load "$msg"
    }
  }

  proc utdtools_version {args} {
    global env
    set version ""
    if {[info exists env(UTDTOOLSVERSION)]} {
      set version $env(UTDTOOLSVERSION)
    }
    return $version
  }
}
