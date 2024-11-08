#
#  Copyright (c) 2022 by William P Swartz, Jr.
#


namespace eval twez {
  proc ez_area {w} {
      # Get the global variable which holds the current user state.
      variable configS

      # Set the parameters which control the display of Tix combo box.
      set name [tixOptionName $w]
      option add *$name*TixComboBox*label.width 13
      option add *$name*TixComboBox*label.anchor e
      option add *$name*TixComboBox*entry.width 40
      
      # Make sure to turn off history.  Causes problems in rerendering.
      # Create a combo box which we will configure to become a pull down menu.
      tixComboBox $w.area -label "Area of Study" \
	  -editable false -dropdown true -command "::twez::user:select_area $w.area" \
	  -history 0
   
      # Insert the options into the pulldown menu
      $w.area insert end {Computer Architecture}
      $w.area insert end {Digital Logic Design}
      $w.area insert end {Embedded Systems}
      $w.area insert end {Hardware Description Languages}
      $w.area insert end {Unix}

      # Now lets set it to the current user mode.
      if {$configS(S_study) == ""} {
	set configS(S_study) $configS(E_study_default)
      }
      tixSetSilent $w.area $configS(S_study)

      # Now pack the widget so we can see the embedded window.
      pack $w.area -side top -padx 20 -anchor center -pady 3

  }

  proc set_area {topic} {
    variable configS
    if {($topic == "HDL") || ($topic == {Hardware Description Languages})} {
      set configS(S_study) {Hardware Description Languages}
    } elseif {($topic == "CA") || ($topic == {Computer Architecture})} {
      set configS(S_study) {Computer Architecture}
    } elseif {($topic == "digital") || ($topic == {Digital Logic Design})} {
      set configS(S_study) {Digital Logic Design}
    } elseif {($topic == "embedded") || ($topic == "embed") || ($topic == {Embedded Systems})} {
      set configS(S_study) {Embedded Systems}
    } elseif {($topic == "unix") || ($topic == {Unix})} {
      set configS(S_study) {Unix}
    } else {
      utdmsg error "::twez::set_area" "Unknown area of study: $topic\n" 
    }
  }

  proc user:select_area {w s} {
      variable configS
      # Update the global user state.
      EZset_state -area $s

      # Change the value of the selector.
      tixSetSilent $w $s

      # Tell the user the new mode. 
      ez_message msg "Selected area of study:$s"
      puts stderr "Selected area of study:$s"

      # Rerender the hypertext in the new user mode.
      if {$configS(S_autorender)} {
	ez:user_update rerender
      }

      reset_lesson

  }

  proc ez_get_area {args} {
    variable configS
    return $configS(S_study)
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
