
namespace eval twez {
  variable lesson_dictS
  variable lessonS

  proc read_lesson { filename } {
    variable configS
    variable lesson_dictS
    set routine "twez::read_lesson"

    package require json

    if {$filename == ""} {
      set filename [file join $configS(E_rootdir) share ezlearn ezlearn lessons.json]
    }
    set f [open $filename "r"]
    if {$f == ""} {
      utdmsg errmsg $routine "unable to open:$filename\n"
      return ;
    }
    set file_data [read $f]
    close $f

    if {[catch {set lesson_dictS [json::json2dict $file_data]} msg]} {
      puts stderr "ERROR:problem reading filename:$filename\n$msg\n"
      return ;
    }
  }

  proc available_lessons { area } {
    variable lesson_dictS
    set routine "twez::available_lessons"
    set top_keys [dict keys $lesson_dictS]
puts stderr "top_keys: $top_keys"
    set idx [lsearch -exact $top_keys $area]
    if {$idx < 0} {
      utdmsg errmsg $routine "area of study does not exist:$area\n"
      return ;
    }
    set area_data [dict get $lesson_dictS $area]

    if {[catch {set lessons [dict get $area_data lessons]} msg]} {
      puts stderr "error:$msg"
      return ;
    }
    # puts stderr "lessons:$lessons"
    # puts stderr "nlessons:[llength $lessons]"
    return $lessons ;
  }

  proc ez_lesson {w} {
      # Get the global variable which holds the current user state.
      variable configS
      variable lessonS
      set routine "twez::ez_lesson"

      read_lesson ""

      # Set the parameters which control the display of Tix combo box.
      set name [tixOptionName $w]
      option add *$name*TixComboBox*label.width 6
      option add *$name*TixComboBox*label.anchor e
      option add *$name*TixComboBox*entry.width 40
      
      # Make sure to turn off history.  Causes problems in rerendering.
      # Create a combo box which we will configure to become a pull down menu.
      tixComboBox $w.lesson -label "Lesson" \
	  -editable false -dropdown true \
	  -command "::twez::user:select_lesson $w.lesson" \
	  -variable ::twez::configS(lesson) \
	  -history 0

      set configS(E_lesson_win) $w.lesson

      # Insert the options into the pulldown menu
      set available [available_lessons $configS(S_study)]
      foreach {lesson lesson_info} $available {
	# puts stderr "l:$lesson"
	array set lesson_array $lesson_info
	set lessonS($lesson) $lesson_info
	# puts stderr "lnfo:$lesson_info"
	# puts stderr "larray:[array get lesson_array]"
	if {[info exists lesson_array(name)]} {
	  set this_lesson "$lesson $lesson_array(name)"
	  $w.lesson insert end $this_lesson
	} else {
	  $w.lesson insert end $lesson
	}
	unset lesson_array
      }

      # Now lets set it to the current user mode.
      tixSetSilent $w.lesson $configS(S_lesson)

      # Now pack the widget so we can see the embedded window.
      pack $w.lesson -side top -padx 20 -anchor center -pady 3

  }

  proc user:select_lesson {w s} {
      variable configS
      # Update the global user state.
      EZset_state -lesson $s

      # Change the value of the selector.
      tixSetSilent $w $s

      # Tell the user the new mode. 
      ez_message msg "Selected lesson of study:$s"

      # Rerender the hypertext in the new user mode.
      if {$configS(S_autorender)} {
	ez:user_update rerender
      }

  }

  proc lesson_description { w } {
    variable configS
    variable lessonS
    set f [frame $w.f -width 1024 -height 60 -background blue]
    tixLabelFrame $f.descr -label {Lesson Description:} -labelside acrosstop \
       -options {
	 label.padX 5
    }
    set f2 [$f.descr subwidget frame]
    pack $f.descr -side top -fill x -expand yes
    tixScrolledText $f2.output -bd 0

    # Get the subwidget so we can add text.
    set twin [$f2.output subwidget text]
    $twin configure -wrap none
    pack $f2.output -side bottom -fill both -expand yes
    pack $f -expand yes -fill both -padx 10 -pady 10 -side left
    if {$configS(S_lesson) == ""} {
      $twin insert end "Please select a lession\n"
    } else {
      set lesson [lindex $configS(S_lesson) 0]
      $twin insert end "Lesson:$lesson\n"
      array set lesson_data $lessonS($lesson)
      if {[info exists lesson_data(description)]} {
	$twin insert end "In this lesson, you will "
	$twin insert end "$lesson_data(description)"
      }
      # Now look at the commands to be updated.
      global env 
      set UTDTOOLS $env(UTDTOOLS)
      set UTDTOOLSVERSION $env(UTDTOOLSVERSION)
      if {[info exists lesson_data(tcl_init)]} {
	eval "$lesson_data(tcl_init)"
      }
      if {[info exists lesson_data(lesson_html)]} {
	eval "set lesson_html $lesson_data(lesson_html)"
	if {$lesson_html == "null"} {
	  set lesson_html ""
	}
	set_page_html lesson $lesson_html
      } else {
	set_page_html lesson ""
      }
      if {[info exists lesson_data(prob_html)]} {
	eval "set prob_html $lesson_data(prob_html)"
	if {$prob_html == "null"} {
	  set prob_html ""
	}
	puts stderr "prob_html:$prob_html"
	set_page_html problems $prob_html
      } else {
	set_page_html problems ""
      }
      if {[info exists lesson_data(sol_html)]} {
	eval "set sol_html $lesson_data(sol_html)"
	if {$sol_html == "null"} {
	  set sol_html ""
	}
	set_page_html solutions $sol_html
      } else {
	set_page_html solutions ""
      }
      if {[info exists lesson_data(res_html)]} {
	eval "set res_html $lesson_data(res_html)"
	set_page_html resources $res_html
      } else {
	set_page_html resources ""
      }
      if {[info exists lesson_data(project)]} {
	eval "set project_name $lesson_data(project)"
	EZset_state -project $project_name
      } else {
	EZset_state -project "unknown"
      }
      unset lesson_data
    }
    $twin see end
    $twin index insert


  }

  proc reset_lesson { } {
    variable configS
    if {[info exists configS(E_lesson_win)]} {
      set w $configS(E_lesson_win)
      set save_autorender $configS(S_autorender)
      set configS(S_autorender) false
      catch {user:select_lesson $w ""}
      set configS(S_autorender) $save_autorender
    }
  }

  proc eval_tclIndex {name_of_file} {
    global env 
    global auto_index
    set UTDTOOLS $env(UTDTOOLS)
    set UTDTOOLSVERSION $env(UTDTOOLSVERSION)
    set dir [file dirname $name_of_file]
    puts stderr "dir:$dir"
    source $name_of_file
  }

}


