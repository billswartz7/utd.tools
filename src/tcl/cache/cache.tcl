#!/usr/local/bin/wish -f
#
# $Log: cache.tcl,v $
# Revision 1.15  2021/05/03 12:47:01  bill
# Added some debug statements to verify working cache load.
#
# Revision 1.14  2020/05/04 13:17:59  bill
# Added score column to database.
#
# Revision 1.13  2020/05/04 12:40:23  bill
# Changes made to work with older versions of Tcl and work
# on NoMachine by changing -test to test.
#

namespace eval utdcache {

  variable questionS
  variable questionIdS 0
  variable answerS
  variable addressS ""
  variable wayS 1
  variable dbS
  variable usedS
  variable max_addrS 0
  variable linesizeS 4B
  variable libpathS ./
  variable max_rangeS 0x9F
  variable optionS
  variable canobjS
  variable balloonS
  variable explainS
  variable multiIdS 0
  variable explain_howS	""
  variable computed_answerS ""
  variable answer_formatS "decimal"
  variable qtypeS "icachesize dcachesize iaddressmap daddressmap ipartition dpartition iaddress daddress"
  # variable qtypeS "daddress"

  proc display {args} {

    variable addressS
    variable libpathS
    variable canobjS
    variable optionS
    variable balloonS
    global env
    global utdsymbolicNameG
    global auto_path
    set routine ::utdcache::display
    set msg ""

    # Load default values so use can change on the command line.
    cache_defaults

    set num_args [llength $args]
    for {set i 0} {$i < $num_args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-debug" } {
	set optionS(debug) true
      } elseif {$arg_el == "-message" } {
	incr i
	if {$i < $num_args} {
	  set msg [lindex $args $i]
	} else {
	  utdmsg errmsg $routine "Missing argument to -message\n"
	  return ;
	}
      } elseif {$arg_el == "-low_res" } {
	set optionS(low_res) true
      } elseif {$arg_el == "-test" } {
	incr i
	if {$i < $num_args} {
	  set optionS(test) [lindex $args $i]
	} else {
	  utdmsg errmsg $routine "Missing argument to -test\n"
	  return ;
	}
      } elseif {$arg_el == "-libpath" } {
	incr i
	if {$i < $num_args} {
	  set libpathS [lindex $args $i]
	  utdmsg imsg $routine "Library path set to: $libpathS\n"
	} else {
	  utdmsg errmsg $routine "Missing argument to -libpath\n"
	  return ;
	}
      } else {
	utdmsg errmsg $routine "Unknown arguments: $args len:$num_args i:$i arg:$arg_el\n"
	utdmsg errmsg null "Supported arguments:-debug, -message, -lowres, -libpath\n"
	return ;
      }
    }
    set w .utdcache

    # First make sure main dialog doesn't exist.
    if {[winfo exists $w]} {
      wm withdraw $w
      wm deiconify $w
      return ;
    }

    # Set auto path
    if {[info exists env(UTDTOOLS)]} {
      set utddir $env(UTDTOOLS)
    } {
      puts stderr "ERROR:cannot get UTD tools environment variable:UTDTOOLS"
      exit 1
    }
    if {[info exists env(UTDTOOLSVERSION)]} {
      set utdversion $env(UTDTOOLSVERSION)
    } {
      puts stderr "ERROR:cannot get UTD tools environment variable:UTDTOOLSVERSION"
      exit 1
    }
    set common [file join $utddir $utdversion tcl utdtools]
    lappend auto_path $common
    set libpathS [file join $utddir $utdversion tcl cache]
    lappend auto_path $libpathS

    if {($optionS(test) != "")} {
      set netid [::utdcache::test_login]
      set optionS(low_res) true
      set optionS(netid) $netid
      set msg "UTD Cache Memory Testing Tool:"
    }


    toplevel $w  \
      -background {lightgray} \
      -highlightbackground {lightgray}

    # Window manager configurations
    # wm minsize $w  28
    # wm sizefrom $w program
    # wm positionfrom $w program
    if {($optionS(test) != "")} {
      wm title $w {Cache Memory Testing Tool}
    } else {
      wm title $w {Cache Memory Practice Tool}
    }
    wm protocol $w WM_DELETE_WINDOW utdexit
    # We create the frame and the two ScrolledListBox widgets
    # at the top of the dialog box
    #
    frame $w.labframe -borderwidth 1 -relief raised
    if {$msg != ""} {
      set msg_width [string length $msg]
      label $w.labframe.lab -text $msg -width $msg_width
    } else {
      label $w.labframe.lab -text "UTD Cache Memory Practice Tool:" -width 46
    }
    set fdata [frame $w.memory -relief raised -bd 1]

    package require tablelist

    option add *memory.tbl.activeStyle  frame
    option add *memory.tbl.setGrid      yes
    option add *memory.tbl.background   gray96
    option add *memory.tbl.stripeBackground  #e0e8f0
    option add *memory.tbl*selectBackground navy
    option add *memory.tbl*selectForeground white
    option add *memory.tbl*Entry.background ivory

    set tbl $fdata.tbl
    set vsb $fdata.vsb
    set hsb $fdata.hsb
    set fields {0 " " left \
10 "Offset" center \
10 "0" center \
10 "1" center \
10 "2" center \
10 "3" center \
10 "4" center \
10 "5" center \
10 "6" center \
10 "7" center \
10 "8" center \
10 "9" center \
10 "A" center \
10 "B" center \
10 "C" center \
10 "D" center \
10 "E" center \
10 "F" center }

    if {$optionS(low_res)} {
      set table_height 3
      set pady 0
    } else {
      set table_height 5
      set pady 10
    }
    tablelist::tablelist $tbl -columns $fields -height $table_height \
      -xscrollcommand [list $hsb set] -yscrollcommand [list $vsb set]
    scrollbar $vsb -orient vertical   -command [list $tbl yview]
    scrollbar $hsb -orient horizontal -command [list $tbl xview]

    table_build_data $tbl

    label $fdata.question -text "Question: Click the New Question button to start the program asking questions!" \
      -textvariable ::utdcache::questionS -foreground red

    label $fdata.explain -text "" -textvariable ::utdcache::explainS
    tixBalloon $w.balloon -statusbar $fdata.explaina 
    set balloonS $w.balloon



    set finfo [frame $fdata.answer -borderwidth 1 -relief raised]
    label $finfo.qlab -text "Your Answer: "
    entry $finfo.answer -textvariable ::utdcache::answerS -width 66
    set utdsymbolicNameG(utdcommand) $finfo.answer

    tixComboBox $finfo.fmat -label "Format:" -dropdown true \
      -editable false -variable ::utdcache::formatS
    $finfo.fmat insert end binary
    $finfo.fmat insert end decimal
    $finfo.fmat insert end hexadecimal
    $finfo.fmat insert end complement2
    tixSetSilent $finfo.fmat decimal

    pack $finfo.qlab -side left
    pack $finfo.answer -side left
    pack $finfo.fmat -side left

    set fproc [frame $w.processor -borderwidth 1 -relief raised]

    # ######  Processor window ########
    set canobjS $fproc.fdraw
    tixCObjView $canobjS

    if {$optionS(low_res)} {
      set c [$canobjS subwidget canvas]
      $c configure -height 50
    }

    # ######  Program window ########
    set fprog [frame $fproc.frame -borderwidth 1 -relief raised]
    label $fprog.flab -text "Program: "
    tixScrolledListBox $fprog.pgm -scrollbar both
    if {$optionS(low_res)} {
      set listb [$fprog.pgm subwidget listbox]
      $listb configure -height 4
    }
    label $fprog.pclab -text "Program Counter: "
    entry $fprog.pc -textvariable ::utdcache::program_counterS -width 20


    label $fprog.qlab -text "Address Calc: "
    entry $fprog.answer -textvariable ::utdcache::addressS -width 20
    # pack $fprog.flab -side top -fill x
    # pack $fprog.pgm -side top -fill both -expand yes
    # pack $fprog.qlab -side left
    # pack $fprog.answer -side left
    # pack $fprog.pclab -side top
    # pack $fprog.pc -side top
    grid $fprog.flab x
    grid $fprog.flab -sticky nsw
    grid $fprog.pgm x
    grid $fprog.pgm -columnspan 2 -sticky news
    grid $fprog.qlab $fprog.answer
    grid $fprog.qlab -sticky nsw 
    grid $fprog.pclab $fprog.pc



    set ficons [frame $fproc.icons -borderwidth 1 -relief raised]
     
    # ######  CombinedProgram/Processor gridding ########
    grid $fprog $ficons $canobjS
    grid $fprog -sticky news
    grid $canobjS -sticky news
    grid columnconfigure $fproc 2 -weight 1
    grid rowconfigure  $fproc 0 -weight 1
    grid propagate $fproc 1 

    # ######  Config window ########
    set fconf [frame $w.cache_config -borderwidth 1 -relief raised]

    tixComboBox $fconf.word -label "Machine Address Size:" -dropdown true \
      -editable false -variable ::utdcache::wordS

    if {($optionS(test) != "")} {
      set machine_word [::utdcache::get_user_data $netid MachineSize]
      if {$machine_word == ""} {
	utdmsg errmsg $routine "could not get machine size for user $netid\n"
	exit 1
      }
      switch $machine_word {
	2 {
	  $fconf.word insert end "16bits 2B"
	  tixSetSilent $fconf.word "16bits 2B"
	}
	4 {
	  $fconf.word insert end "32bits 4B"
	  tixSetSilent $fconf.word "32bits 4B"
	}
	8 {
	  $fconf.word insert end "64bits 8B"
	  tixSetSilent $fconf.word "64bits 8B"
	}
      }
    } else {
      $fconf.word insert end "8bits 1B"
      $fconf.word insert end "16bits 2B"
      $fconf.word insert end "24bits 3B"
      $fconf.word insert end "32bits 4B"
      $fconf.word insert end "64bits 8B"
      tixSetSilent $fconf.word "32bits 4B"
    }

    # ######  I Config window ########
    tixLabelFrame $fconf.icache_config -label {I-Cache Configuration} -labelside acrosstop \
      -options {
	label.padX 5
	label.padY 0
    }
    set fconfig [$fconf.icache_config subwidget frame]

    tixComboBox $fconfig.ways -label "Number of Ways:" -dropdown true \
      -editable false -variable ::utdcache::iwayS -command ::utdcache::config_ways

    if {($optionS(test) != "")} {
      $fconfig.ways insert end 1
    } else {
      $fconfig.ways insert end 1
      $fconfig.ways insert end 2
      $fconfig.ways insert end 4
      $fconfig.ways insert end 8
      # $fconfig.ways insert end "fully-associated"
    }
    tixSetSilent $fconfig.ways 1

    tixComboBox $fconfig.word -label "Num Lines/Way:" -dropdown true \
      -editable false -variable ::utdcache::ilineS

    if {($optionS(test) != "")} {
      set ilines [::utdcache::get_user_data $netid IcacheLines]
      if {$ilines == ""} {
	utdmsg errmsg $routine "could not get ICache Number of Lines for user $netid\n"
	exit 1
      }
      $fconfig.word insert end $ilines
      tixSetSilent $fconfig.word $ilines
    } else {
      $fconfig.word insert end "1"
      $fconfig.word insert end "2"
      $fconfig.word insert end "4"
      $fconfig.word insert end "8"
      $fconfig.word insert end "16"
      $fconfig.word insert end "32"
      $fconfig.word insert end "64"
      $fconfig.word insert end "128"
      $fconfig.word insert end "256"
      $fconfig.word insert end "512"
      $fconfig.word insert end "1024"
      tixSetSilent $fconfig.word "8"
    }

    tixComboBox $fconfig.linesize -label "Line Size:" -dropdown true \
      -editable false -variable ::utdcache::ilinesizeS

    if {($optionS(test) != "")} {
      set ilinesize [::utdcache::get_user_data $netid IcacheLineSize]
      if {$ilinesize == ""} {
	utdmsg errmsg $routine "could not get ICache Line Size for user $netid\n"
	exit 1
      }
      $fconfig.linesize insert end $ilinesize
      tixSetSilent $fconfig.linesize $ilinesize
    } else {
      $fconfig.linesize insert end "1"
      $fconfig.linesize insert end "2"
      $fconfig.linesize insert end "4"
      $fconfig.linesize insert end "8"
      $fconfig.linesize insert end "16"
      $fconfig.linesize insert end "32"
      $fconfig.linesize insert end "64"
      $fconfig.linesize insert end "128"
      $fconfig.linesize insert end "256"
      tixSetSilent $fconfig.linesize 16
    }
    grid $fconfig.ways -sticky news -pady 0
    grid $fconfig.word -sticky news -pady 0
    grid $fconfig.linesize -sticky news -pady 0
    grid columnconfigure $fconfig 0 -weight 1
    grid propagate $fconfig 1 
    # #########  end Icache config section ###### 
    #
    # ######  D Config window ########
    tixLabelFrame $fconf.dcache_config -label {D-Cache Configuration} -labelside acrosstop \
      -options {
	label.padX 5
	label.padY 0
    }
    set fconfig [$fconf.dcache_config subwidget frame]

    tixComboBox $fconfig.ways -label "Number of Ways:" -dropdown true \
      -editable false -variable ::utdcache::dwayS -command ::utdcache::config_ways

    if {($optionS(test) != "")} {
      set dways [::utdcache::get_user_data $netid DCacheWays]
      if {$dways == ""} {
	utdmsg errmsg $routine "could not get DCache Number of Ways for user $netid\n"
	exit 1
      }
      $fconfig.ways insert end $dways
      tixSetSilent $fconfig.ways $dways
    } else {
      $fconfig.ways insert end 1
      $fconfig.ways insert end 2
      $fconfig.ways insert end 4
      $fconfig.ways insert end 8
      # $fconfig.ways insert end "fully-associated"
      tixSetSilent $fconfig.ways 1
    }

    tixComboBox $fconfig.word -label "Num Lines/Way:" -dropdown true \
      -editable false -variable ::utdcache::dlineS

    if {($optionS(test) != "")} {
      set dlines [::utdcache::get_user_data $netid DCacheLines]
      if {$dlines == ""} {
	utdmsg errmsg $routine "could not get DCache Number of Lines for user $netid\n"
	exit 1
      }
      $fconfig.word insert end $dlines
      tixSetSilent $fconfig.word $dlines
    } else {
      $fconfig.word insert end "1"
      $fconfig.word insert end "2"
      $fconfig.word insert end "4"
      $fconfig.word insert end "8"
      $fconfig.word insert end "16"
      $fconfig.word insert end "32"
      $fconfig.word insert end "64"
      $fconfig.word insert end "128"
      $fconfig.word insert end "256"
      $fconfig.word insert end "512"
      $fconfig.word insert end "1024"
      tixSetSilent $fconfig.word "16"
    }

    tixComboBox $fconfig.linesize -label "Line Size:" -dropdown true \
      -editable false -variable ::utdcache::dlinesizeS

    if {($optionS(test) != "")} {
      set dlinesize [::utdcache::get_user_data $netid DCacheLineSize]
      if {$dlinesize == ""} {
	utdmsg errmsg $routine "could not get DCache Line size for user $netid\n"
	exit 1
      }
      $fconfig.linesize insert end $dlinesize
      tixSetSilent $fconfig.linesize $dlinesize
    } else {
      $fconfig.linesize insert end "1"
      $fconfig.linesize insert end "2"
      $fconfig.linesize insert end "4"
      $fconfig.linesize insert end "8"
      $fconfig.linesize insert end "16"
      $fconfig.linesize insert end "32"
      $fconfig.linesize insert end "64"
      $fconfig.linesize insert end "128"
      $fconfig.linesize insert end "256"
      $fconfig.linesize insert end "512"
      $fconfig.linesize insert end "1024"
      tixSetSilent $fconfig.linesize 32
    }
    grid $fconfig.ways -sticky news -pady 0
    grid $fconfig.word -sticky news -pady 0
    grid $fconfig.linesize -sticky news -pady 0
    grid columnconfigure $fconfig 0 -weight 1
    grid propagate $fconfig 1 
    # #########  end Icache config section ###### 
     
    grid $fconf.word x
    grid $fconf.icache_config $fconf.dcache_config
    grid $fconf.word -columnspan 2 -sticky news
    # #########  end cache config section ###### 

    grid $tbl -row 1 -column 0 -sticky news
    grid $vsb -row 1 -column 1 -sticky ns
    grid $hsb -row 2 -column 0 -sticky ew
    grid $fdata.question -row 3 -column 0 -sticky news -pady 0
    grid $fdata.explain -row 4 -column 0 -sticky news -pady 0
    grid $finfo -row 5 -column 0 -sticky news -pady 0
    grid rowconfigure  $fdata 0 -weight 1
    grid columnconfigure $fdata 0 -weight 1

    tixButtonBox $w.buttons -orientation horizontal
    $w.buttons add new -text "New Question" -command "::utdcache::new_question $w"
    if {($optionS(test) != "")} {
      $w.buttons add check -text "Send Answer" -command "::utdcache::check_answer $w"
    } else {
      $w.buttons add check -text "Check Answer" -command "::utdcache::check_answer $w"
    }
    if {($optionS(test) != "")} {
      $w.buttons add show -text "Status" -command "::utdcache::show_status false"
      # set show_button [$w.buttons subwidget show]
      # $show_button configure -state disabled
    } else {
      $w.buttons add show -text "Show Answer" -command "::utdcache::show_answer $w"
    }
    $w.buttons add random -text "New Random Memory" -command "::utdcache::random_mem $w"

    # pack widget top level window
    pack $w.labframe.lab -side left
    pack $w.labframe -side top -fill x -anchor center
    pack $w.cache_config -side top -anchor w -padx 0 -fill x
    pack $fproc -side top -anchor w -padx 0 -fill both -expand yes
    pack $fdata -side top -anchor w -padx 0 -fill x 
    pack $w.buttons -side top -fill x

    InitIconBar
    update

    update_processor_state
    load_program $fprog.pgm $tbl $optionS(code) $optionS(isa)
    init_program_counter

  }

  proc get_address_size { } {
    set word_size [get_machine_size]
    set addr_size [expr {8 * $word_size}]
    return $addr_size
  }

  proc get_machine_size { } {
    variable wordS
    set val [lindex $wordS 1]
    set slen [string length $val]
    if {$slen > 1} {
      set smax [expr $slen -2]
      set msize [string range $val 0 $smax]
      return $msize
    }
    return 1
  }

  proc empty_string { val } { 
    return "" 
  }

  proc get_byte_contents { tbl address } {
    variable max_rangeS

    if {$address > $max_rangeS} {
      puts stderr "out of range of memory table"
      return " "
    }
    set faddress [format %04X $address]
    set flen [string length $faddress] 
    set offset_idx [expr $flen - 1]
    set rowend [expr $offset_idx - 1]
    set row [string range $faddress 0 $rowend]
    set offset [string range $faddress $offset_idx $offset_idx]
    set offset "0x${offset}"
    # Table is offset by 1, 2 to account for headings
    set tablerow [expr $row + 1]
    set tablecol [expr $offset + 2]
    # puts stderr "$address $faddress $tablerow $tablecol $offset"
    set contents [$tbl cellcget $tablerow,$tablecol -text]
    return $contents
  }

  proc set_byte_contents { tbl address val } {
    variable max_rangeS

    if {$address > $max_rangeS} {
      puts stderr "out of range of memory table"
      return
    }
    set faddress [format %04X $address]
    set faddr "0x${faddress}"
    set flen [string length $faddress] 
    set offset_idx [expr $flen - 1]
    set rowend [expr $offset_idx - 1]
    # set row [string range $faddress 0 $rowend]
    set row [expr {$faddr / 16}]
    set offset [string range $faddress $offset_idx $offset_idx]
    set offset "0x${offset}"
    # Table is offset by 1, 2 to account for headings
    set tablerow [expr $row + 1]
    set tablecol [expr $offset + 2]
    # puts stderr "$address $faddress $tablerow $tablecol $offset"
    $tbl cellconfigure $tablerow,$tablecol -text $val
  }

  proc table_build_data {tbl} {
    $tbl delete 0 end
    $tbl insert end [list "Address" " " Data Data Data Data Data Data Data Data Data Data Data Data Data Data Data Data]
    $tbl insert end [list 0x0 " " 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00]
    $tbl insert end [list 0x10 " "  0x8c 0x8a 0x00 0x00 0x8c 0x89 0x00 0x04 0x01 0x2a 0x58 0x20 0x11 0x60 0x00 0x02]
    $tbl insert end [list 0x20 " "  0x00 0x00 0x00 0x00 0x21 0x6b 0x00 0x01 0xac 0xab 0x00 0x10 0x00 0x00 0x00 0x00]
    $tbl insert end [list 0x30 " "  0x10 0x10 0x11 0x12 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x3D 0x00 0x1C 0x2F]
    $tbl insert end [list 0x40 " " 0x00 0xFF 0x3E 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x1F 0xFF 0x03 0x02]
    $tbl insert end [list 0x50 " "  0x10 0x10 0x11 0x12 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x3D 0x00 0x1C 0x2F]
    $tbl insert end [list 0x60 " " 0x00 0xFF 0x3E 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x1F 0xFF 0x03 0x02]
    $tbl insert end [list 0x70 " "  0x10 0x10 0x11 0x12 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x3D 0x00 0x1C 0x2F]
    $tbl insert end [list 0x80 " " 0x00 0xFF 0x3E 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x1F 0xFF 0x03 0x02]
    $tbl insert end [list 0x90 " "  0x10 0x10 0x11 0x12 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x3D 0x00 0x1C 0x2F]
  }

  proc rand_range {min max} { 
    return [expr int(rand()*($max-$min+1)) + $min] 
  }

  proc update_message {msg} {
    variable questionS
    .utdcache.memory.question configure -foreground red
    set questionS $msg
  }

  proc new_question {win} {
    variable linesizeS
    variable questionS
    variable iwayS
    variable dwayS
    variable usedS
    variable ilineS
    variable dlineS
    variable optionS
    variable addressS
    variable ilinesizeS
    variable dlinesizeS
    variable max_rangeS
    variable qtypeS
    variable explainS
    variable explain_howS
    variable questionIdS
    variable multiIdS
    variable answer_formatS
    variable computed_answerS

    .utdcache.memory.question configure -foreground black

    set explainS ""
    set addressS ""
    if {($optionS(test) != "")} {
      incr optionS(question_number)
    }
# puts stderr "qid: $questionIdS m:$multiIdS q:$optionS(question_number)"
    if {$multiIdS > 0} {
      switch [lindex $qtypeS $questionIdS] {
	iaddressmap {
	  if {$multiIdS == 2} {
	      set questionS "Question: Given the address size of ${::utdcache::wordS}, how many bits are allocated to the index field of the I-cache?"
	      set computed_answerS [log2 $ilineS]
	      set answer_formatS "decimal"
	      set explain_howS "Explaination: Number of bits = Log2(#lines/way) = Log2($ilineS) = $computed_answerS"
	      set multiIdS 1
	  } elseif {$multiIdS == 1} {
	      set questionS "Question: Given the address size of ${::utdcache::wordS}, how many bits are allocated to the tag field of the I-cache?"
	      set addr_width [get_address_size]
	      set blockbits [log2 $ilinesizeS]
	      set idxbits [log2 $ilineS]
	      set computed_answerS [expr $addr_width - $idxbits - $blockbits]
	      set answer_formatS "decimal"
	      set explain_howS "Explaination: Number of bits = Address width - Log2($ilineS) - Log2($ilinesizeS) = $addr_width - $idxbits - $blockbits = $computed_answerS   Address partition:  | $computed_answerS bits | $idxbits bits | $blockbits bits |" 
	      set multiIdS 0
	  } else {
	    puts stderr "why am i here: $multiIdS"
	  }
	}
	daddressmap {
	  if {$multiIdS == 2} {
	      set questionS "Question: Given the address size of ${::utdcache::wordS}, how many bits are allocated to the index field of the D-cache?"
	      set computed_answerS [log2 $dlineS]
	      set answer_formatS "decimal"
	      set explain_howS "Explaination: Number of bits = Log2(#lines/way) = Log2($dlineS) = $computed_answerS"
	      set multiIdS 1
	  } elseif {$multiIdS == 1} {
	      set questionS "Question: Given the address size of ${::utdcache::wordS}, how many bits are allocated to the tag field of the D-cache?"
	      set addr_width [get_address_size]
	      set blockbits [log2 $dlinesizeS]
	      set idxbits [log2 $dlineS]
	      set computed_answerS [expr $addr_width - $idxbits - $blockbits]
	      set answer_formatS "decimal"
	      set explain_howS "Explaination: Number of bits = Address width - Log2($dlineS) - Log2($dlinesizeS) = $addr_width - $idxbits - $blockbits = $computed_answerS   Address partition:  | $computed_answerS bits | $idxbits bits | $blockbits bits |" 
	      set multiIdS 0
	  } else {
	    puts stderr "why am i here: $multiIdS"
	  }
	}
      }
    } else {
      set nqtypes [llength $qtypeS]
      if {($optionS(test) != "")} {
	if {$optionS(test_question) == 0} {
	  set optionS(test_question) 1
	} else {
	  incr optionS(test_question)
	}
	set questionIdS $optionS(test_question)
	# puts stderr "questionIdS: $questionIdS $optionS(test_question)"
	if {$questionIdS > $nqtypes} {
	  set optionS(test_question) 1
	  set questionIdS 1
	  set optionS(question_number) 1
	  set multiIdS 0
	  # See if we have anything else to do.
	  set done true
	  for {set qnum 1} {$qnum <= $optionS(max_questions)} {incr qnum} {
	    set tries [get_test_field $optionS(netid) $qnum tries]
	    if {$tries <= 0} {
	      set done false
	      break
	    }
	    if {$tries < $optionS(max_tries)} {
	      set correct_flag [get_test_field $optionS(netid) $qnum correct]
	      if {!($correct_flag)} {
		update_message "You still can modify question:$qnum"
		after 3000
		set done false
		break ;
	      }
	    }
	  }

	  if {$done} {
	    set m [show_status true]
	    update_message "Test complete. Thank you. $m\n"
	    update
	    after 20000
	    twexit 0
	  }
	}

      } else {
	while {1} {
	  set questionIdS [rand_range 1 $nqtypes]
	  if {!([info exists usedS($questionIdS)])} {
	    set usedS($questionIdS) $questionIdS
	    if {[info exists usedS(0)]} {
	      incr usedS(0)
	    } else {
	      set usedS(0) 1
	    }
	    break ; 
	  }
	}
	if {$usedS(0) >= $nqtypes} {
	  unset usedS
	}
      }
      set questionIdS [expr {$questionIdS - 1}]
      switch [lindex $qtypeS $questionIdS] {
	icachesize {
	  set questionS "Question: What is the size of the Instruction Cache in Bytes?"
	  set computed_answerS [expr {$iwayS * $ilineS * $ilinesizeS}]
	  set answer_formatS "decimal"
	  set explain_howS "Explaination: Ways * Lines/Way * LineSize : $iwayS x $ilineS x $ilinesizeS = $computed_answerS"
	  set multiIdS 0
	}
	dcachesize {
	  set questionS "Question: What is the size of the Data Cache in Bytes?"
	  set computed_answerS [expr {$dwayS * $dlineS * $dlinesizeS}]
	  set answer_formatS "decimal"
	  set explain_howS "Explaination: Ways * Lines/Way * LineSize : $dwayS x $dlineS x $dlinesizeS = $computed_answerS"
	  set multiIdS 0
	}
	iaddressmap {
	  set questionS "Question: Given the address size of ${::utdcache::wordS}, how many bits are allocated to the byte offset of the I-cache?"
	  set computed_answerS [log2 $ilinesizeS]
	  set answer_formatS "decimal"
	  set explain_howS "Explaination: Number of bits = Log2(blocksize) = Log2($ilinesizeS) = $computed_answerS"
	  set multiIdS 2
	}
	daddressmap {
	  set questionS "Question: Given the address size of ${::utdcache::wordS}, how many bits are allocated to the byte offset of the D-cache?"
	  set computed_answerS [log2 $dlinesizeS]
	  set answer_formatS "decimal"
	  set explain_howS "Explaination: Number of bits = Log2(blocksize) = Log2($dlinesizeS) = $computed_answerS"
	  set multiIdS 2
	}
	ipartition {
	  set questionS "Question: Given the word size of ${::utdcache::wordS}, partition the instruction byte offset into words? Show the bit partition using format 'words : subword offset'"
	  set addr_bytes [get_machine_size]
	  set answer_formatS "string"
	  if {$ilinesizeS < $addr_bytes} {
	    set computed_answerS "impossible"
	    set explain_howS "Explaination: Instruction byte offset:$ilinesizeS is less than address word size:$addr_bytes.  Not a realistic scenario."
	    set multiIdS 0
	  } else {
	    set ibits [log2 $ilinesizeS]
	    set abits [log2 $addr_bytes]
	    set bit_diff [expr {$ibits - $abits}]
	    set iwords [pow2 $bit_diff]
	    set computed_answerS "$bit_diff : $abits"
	    set explain_howS "Explaination: Total line size bits: $ibits which is partitioned into $computed_answerS. There are $iwords instruction words which can be accessed."
	    set multiIdS 0
	  }
	}
	dpartition {
	  set questionS "Question: Given the word size of ${::utdcache::wordS}, partition the data byte offset into words? Show the bit partition using format 'words : subword offset'"
	  set addr_bytes [get_machine_size]
	  set answer_formatS "string"
	  if {$dlinesizeS < $addr_bytes} {
	    set computed_answerS "impossible"
	    set explain_howS "Explaination: Data byte offset:$dlinesizeS is less than address word size:$addr_bytes.  Not a realistic scenario."
	    set multiIdS 0
	  } else {
	    set dbits [log2 $dlinesizeS]
	    set abits [log2 $addr_bytes]
	    set bit_diff [expr {$dbits - $abits}]
	    set dwords [pow2 $bit_diff]
	    set computed_answerS "$bit_diff : $abits"
	    set explain_howS "Explaination: Total line size bits: $dbits which is partitioned into $computed_answerS. There are $dwords data words which can be accessed."
	    set multiIdS 0
	  }
	}
	iaddress {
	  set pc_counter [pick_program_counter]
	  set addressS $pc_counter
	  set questionS "Question: The program counter now reads $pc_counter, what line of the cache is searched?"
	  set cache_line [get_cache_line I $pc_counter bin_rep begin_idx end_idx bits_rep]
	  set tag_idx [expr $begin_idx - 1]
	  set byte_idx [expr $end_idx + 1]
	  set answer_formatS "string"
	  set computed_answerS "$cache_line"
	  set tag_bits [string range $bin_rep 0 $tag_idx]
	  set hex_tag_bits [bin2hex $tag_bits]
	  set index_bits [string range $bin_rep $begin_idx $end_idx]
	  set byte_offset [string range $bin_rep $byte_idx end]
	  set explain_howS "Explaination: The addresses binary representation is ${bin_rep}.  Partitioning we get\n\
$tag_bits | $index_bits | $byte_offset\n\
tag  : $tag_bits ($hex_tag_bits)\n\
index: $index_bits\n\
byte offset: $byte_offset"
	  set multiIdS 0
	}
	daddress {
	  set addressS [pick_mem_address]
	  set questionS "Question: The program is now referencing data at address $addressS, what line of the Data cache is searched?"
	  set cache_line [get_cache_line D $addressS bin_rep begin_idx end_idx bits_rep]
	  set tag_idx [expr $begin_idx - 1]
	  set byte_idx [expr $end_idx + 1]
	  set answer_formatS "string"
	  set computed_answerS "$cache_line"
	  set tag_bits [string range $bin_rep 0 $tag_idx]
	  set hex_tag_bits [bin2hex $tag_bits]
	  set index_bits [string range $bin_rep $begin_idx $end_idx]
	  set byte_offset [string range $bin_rep $byte_idx end]
	  set explain_howS "Explaination: The addresses binary representation is ${bin_rep}.  Partitioning we get\n\
$tag_bits | $index_bits | $byte_offset\n\
tag  : $tag_bits ($hex_tag_bits)\n\
index: $index_bits\n\
byte offset: $byte_offset"
	  set multiIdS 0
	}
      }
    }
    if {($optionS(test) != "")} {
      set tries [get_test_field $optionS(netid) $optionS(question_number) tries]
      if {$tries <=  0} {
	return ;
      }
      set old_val $questionS
      if {$tries >= $optionS(max_tries)} {
	set correct_flag [get_test_field $optionS(netid) $optionS(question_number) correct]
	set answer_val [get_test_field $optionS(netid) $optionS(question_number) answer]
	if {$correct_flag} {
	  update_message "$questionS\nYou have exceeded your number of tries for question:$optionS(question_number). Your answer $answer_val is correct."
	} else {
	  update_message "$questionS\nYou have exceeded your number of tries for question:$optionS(question_number). Your answer $answer_val is wrong."
	}
      } else {
	set correct_flag [get_test_field $optionS(netid) $optionS(question_number) correct]
	set answer_val [get_test_field $optionS(netid) $optionS(question_number) answer]
	if {$correct_flag} {
	  update_message "$questionS\nYour previous answer $answer_val is correct."
	} else {
	  update_message "$questionS\nYour previous answer $answer_val is wrong."
	}
      }
    }
  }


  proc calc_answer {win} {
    variable computed_answerS

    return $computed_answerS

  }

  proc get_cache_line {type addr bin_rep begin_idx end_idx bits_rep} {
    variable ilineS
    variable dlineS
    variable ilinesizeS
    variable dlinesizeS

    upvar $bin_rep bin
    upvar $begin_idx begin
    upvar $end_idx end
    upvar $bits_rep bits
    if {${type} == "I"} {
      set idx_bits [log2 $ilineS]
      set byte_offset_bits [log2 $ilinesizeS]
    } else {
      set idx_bits [log2 $dlineS]
      set byte_offset_bits [log2 $dlinesizeS]
    }
    set bin [dec2bin $addr]
    set bin [pad_zeros $bin]
    set binlen [string length $bin]
    set begin [expr {$binlen - $byte_offset_bits - $idx_bits}]
    set end [expr {$begin + $idx_bits - 1}]
    set bits [string range $bin $begin $end]
    set val [bin2dec $bits]
    return $val
  }

  proc pick_program_counter { } {
    variable max_addrS
    set word_size [get_machine_size]
    set num_insts [expr {$max_addrS / $word_size}]
    set inst [rand_range 0 $num_insts]
    set pc_val [expr {$inst * $word_size}]
    set pc [format %X $pc_val]
    return "0x${pc}"
  }

  proc pick_mem_address { } {
    variable max_addrS

    set address_bits [get_address_size]
    # puts stderr "add: $address_bits"
    if {$address_bits >= 64} {
      set address_bits 32
    }
    set max [pow2 $address_bits]
    set max [expr $max - 1]
    set val [rand_range 0 $max]
    set addr [format %X $val]
    return "0x${addr}"
  }

  proc pad_zeros { num } {
    set nbits [get_address_size]
    set fmt "%0${nbits}s"
    set padded_num [format $fmt $num]
    return $padded_num
  }

  proc log2 {num} {
    expr {int(log($num)/log(2))}
  }

  proc pow2 {num} {
    expr {int(pow(2,$num))}
  }

  proc strip_hex_format { val } {
    set xchar [string index $val 1]
    if {$xchar == "x"} {
      set val [string range $val 2 end]
    }
    return $val
  }

  proc dec2bin x {
    return [string trimleft [string map {0 {000} 1 {001} 2 {010} 3 {011} 4 {100} 5 {101} 6 {110} 7 {111}} [format %o $x]] 0]
  }

  proc bin2dec {bin} {
    binary scan [binary format B32 [format %032d $bin]] I int
    return $int
  }


  proc bin2dec {binum} {
    # =======================================================
    # # Converts an  binary number into the decimal equivalent.
    # # Binary must be integer and positive.
    # # Binary number is a string of binary digits (0 or 1).
    # # =======================================================
    
    # create an empty container to hold the answer
    set decnum 0
    # find number of digits of binary number and set length
    set length [string length $binum]
    # since string starts at position 0 adjust length
    set length [expr $length - 1]
    # loop to process all bits
    for {set i 0}  {$i < [expr $length + 1]}  {incr i} {
      # point to the digit to be processed
      set pointeur [expr $length - $i]
      # find the weight i.e. decimal value of that position
      # Nth bit from end has a value of 2^(N-1)
      set weight [expr pow(2,$i)]
      # get the bit value of the bit being processed
      set selectbit [string index $binum $pointeur]
      # multiply bit value by position weight to get
      # contribution of that particular bit to decimal number
      set  digitvalue   [expr $selectbit * $weight]
      # Accumulat into decnum the contribution of the bit
      set decnum [expr $decnum + $digitvalue]
    }
    # return from the procedure with the result
    set decnum [expr {int($decnum)}]
    return $decnum
  }

  proc bin2hex {binary_num} {
    set dec [bin2dec $binary_num]
    set new_hex_data [format %0X $dec]
    set new_hex_addr "0x${new_hex_data}"
    return $new_hex_addr
  }

  # SPEC : Get the 2's complement rappresentation 
  proc complement2 { hexval } {
    set slen [string length $hexval]
    if {$slen <= 4} {
      set decimal [expr $hexval + 0]
      if {$decimal <= 127} {
	return $decimal
      } else {
	return [expr $decimal - 256]
      }
    } else {
      set a [binary format s $hexval]
      binary scan $a s b
      return $b
    }
  }

  proc show_answer {win} {
    variable formatS
    variable answerS
    variable answer_formatS
    variable explainS
    variable explain_howS

    set contents [calc_answer $win]
    set answerS $contents
    if {$formatS != $answer_formatS} {
      if {$answer_formatS == "hexadecimal"} {
	set answerS [expr $answerS + 0]
	if {$formatS == "binary"} {
	  set answerS [dec2bin $answerS]
	} elseif {$formatS == "complement2"} {
	  set answerS [complement2 $answerS]
	}
      } elseif {$answer_formatS == "string"} {
      } else {
	# answer is decimal
	if {$formatS == "binary"} {
	  set answerS [dec2bin $answerS]
	} elseif {$formatS == "complement2"} {
	  set answerS [complement2 $answerS]
	} else {
	  set answerS [format %X $answerS]
	  set answerS "0x${answerS}"
	}
      }
    } 
    set explainS $explain_howS
    return $contents
  }

  proc correct_msg { } {
    puts stderr "correct"
    splash true
  }

  proc wrong_msg { } {
    puts stderr "wrong"
    splash false
  }

  proc convert_to_array {arry split_chars} {
    set split_array [split $arry $split_chars]
    set result ""
    foreach val $split_array {
      if {$val != ""} {
	lappend result $val
      }
    }
    return $result
  }

  proc check_array_match {answer_array user_array} {
    set answer_len [llength $answer_array]
    set user_len [llength $user_array]
    if {$user_len != $answer_len} {
      return false
    }
    for {set i 0} {$i < $answer_len} {incr i} {
      set answer_val [lindex $answer_array $i]
      set user_val [lindex $user_array $i]
      if {$user_val != $answer_val} {
	return false
      }
    }
    return true
  }

  proc check_answer {win} {
    variable answerS
    variable optionS
    variable answer_formatS

    set user_val $answerS
    set contents [calc_answer $win]
    set xchar [string index $user_val 1]

    if {($optionS(test) != "")} {
      set tries [get_test_field $optionS(netid) $optionS(question_number) tries]
      if {$tries >= $optionS(max_tries)} {
	set correct_flag [get_test_field $optionS(netid) $optionS(question_number) correct]
	set answer_val [get_test_field $optionS(netid) $optionS(question_number) answer]
	if {$correct_flag} {
	  update_message "You have exceeded your number of tries for question:$optionS(question_number). Your answer $answer_val is correct."
	} else {
	  update_message "You have exceeded your number of tries for question:$optionS(question_number). Your answer $answer_val is wrong."
	}
	return

      }
    }
    set correct_flag false
    if {$xchar == "x"} {
      # both are in hexadecimal
      if {$user_val == $contents} {
	correct_msg
	set correct_flag true
      } else {
	wrong_msg
	set correct_flag false
      }
    } else {
      if {$answer_formatS == "string"} {
	if {$contents == $user_val} {
	  correct_msg
	  set correct_flag true
	} else {
	  # See if we have special case of : 
	  set idx [string first : $contents]
	  if {$idx > 0} {
	    set answer_array [convert_to_array $contents {: }]
	    set user_array [convert_to_array $user_val {: }]
	    set ok [check_array_match $answer_array $user_array]
	    if {$ok} {
	      correct_msg
	      set correct_flag true
	    } else {
	      wrong_msg
	      set correct_flag false
	    }
	  } else {
	    wrong_msg
	    set correct_flag false
	  }
	}
      } else {
	# assume decimal
	set contents_dec [expr $contents + 0]
	if {$contents_dec == $user_val} {
	  correct_msg
	  set correct_flag true
	} else {
	  wrong_msg
	  set correct_flag false
	}
      }
    }
    if {($optionS(test) != "")} {
      incr tries
      set_test_field $optionS(netid) $optionS(question_number) tries $tries
      set_test_field $optionS(netid) $optionS(question_number) answer $user_val
      set_test_field $optionS(netid) $optionS(question_number) correct $correct_flag
      if {$correct_flag} {
	set answerS ""
	new_question $win
      }
    }
  }

  proc show_status {msg_only_flag} {
    variable optionS

    set num_answered 0
    set num_correct 0
    for {set q 1} {$q <= $optionS(max_questions)} {incr q} {
      set tries [get_test_field $optionS(netid) $q tries]
      if {$tries > 0} {
	incr num_answered
	set correct_flag [get_test_field $optionS(netid) $q correct]
	if {$correct_flag} {
	  incr num_correct
	}
      }
    }
    set msg "Status: You have answered $num_correct correctly out of $num_answered attempted."
    if {$msg_only_flag} {
      set_test_field $optionS(netid) qscore answer $num_correct
      return $msg
    }
    update_message $msg
  }

  proc random_mem {win} {
    variable max_rangeS
    set tbl "$win.memory.tbl"

    for {set addr 0} {$addr <= $max_rangeS} {incr addr} {
      set new_data [rand_range 0 255]
      set new_hex_data [format %02X $new_data]
      set new_byte_val "0x${new_hex_data}"
      set_byte_contents $tbl $addr $new_byte_val
    }
  }

  proc load_program {w tbl filename isa} {

    variable libpathS
    set routine "load_program"

    set fname [file join $libpathS $filename]
    set fp [open $fname r]
    if {$fp == ""} {
      utdmsg errmsg $routine "Could not open file:$filename\n"
      return ;
    }
    set file_data [read $fp]
    close $fp

    set lbox [$w subwidget listbox]
    $lbox configure -font {Courier -16 bold}
    set lines [split $file_data "\r\n"]
    foreach line $lines {
      # $lbox insert end $line
      set pline [split $line " :\r\t"]
      set parsed_line ""
      foreach piece $pline {
	if {$piece != ""} {
	  lappend parsed_line $piece
	}
      }
      set plen [llength $parsed_line]
      set addr [lrange $parsed_line 0 0]
      set asm [lrange $parsed_line 1 end-1]
      set machine_code [lrange $parsed_line end end]
      if {($addr != "") && ($machine_code != "") && ($plen > 2)} {
	# puts stderr "pline: $parsed_line plen: $plen addr:$addr end:$machine_code"
	# puts stderr "asm: $asm formatted: [asm_statement $asm]"
	load_machine_word $tbl $addr $machine_code
      }
    }
  }

  proc asm_statement {asm_list_form} {
    set asm ""
    foreach operand $asm_list_form {
      append asm $operand
      append asm " "
    }
    return $asm
  }


  proc incr_addr {addr increment} {
    set addr_next [expr $addr + $increment]
    set addr_hex_val [format %04X $addr_next]
    set addr_hex "0x${addr_hex_val}"
    # puts stderr "addr: $addr addr_next: $addr_next hex:$addr_hex"
    return $addr_hex
  }

  proc load_machine_word {tbl addr machine_code} {
    variable optionS
    variable max_addrS

    if {$addr > $max_addrS} {
      set max_addrS $addr
    }
    # puts stderr "max_addrS: max_addrS addr:$addr code:$machine_code"
    if {$optionS(isa) == "mips32"} {
      # Big endian machine : 0x00000000
      set byte [string range $machine_code 2 3]
      set hex_val "0x${byte}"
      set_byte_contents $tbl $addr $hex_val

      set addr [incr_addr $addr 1]
      set byte [string range $machine_code 4 5]
      set hex_val "0x${byte}"
      set_byte_contents $tbl $addr $hex_val

      set addr [incr_addr $addr 1]
      set byte [string range $machine_code 6 7]
      set hex_val "0x${byte}"
      set_byte_contents $tbl $addr $hex_val

      set addr [incr_addr $addr 1]
      set byte [string range $machine_code 8 9]
      set hex_val "0x${byte}"
      set_byte_contents $tbl $addr $hex_val
    }
  }

  proc init_program_counter { } {
    variable optionS
    set ::utdcache::program_counterS $optionS(program_counter)
  }

  proc cache_defaults { } {
    variable optionS
    set optionS(xsize) 1024
    set optionS(ysize) 2048
    set optionS(test) ""
    set optionS(netid) ""
    set optionS(test_name) "cache"
    set optionS(test_question) 0
    set optionS(question_number) 0
    set optionS(max_questions) 12
    set optionS(max_tries) 2
    set optionS(dot_radius) 3
    set optionS(idx_text_offset)   10
    set optionS(highlightsize) 3
    set optionS(dot_counter) 0
    set optionS(box_fields) "path"
    set optionS(filename) "dumpfile"
    set optionS(code) "prog.S"
    set optionS(isa) "mips32"
    set optionS(mode) normal
    set optionS(scale) 1.0
    set optionS(low_res) false
    set optionS(debug) false
    set optionS(program_counter)  0x10
    expr {srand(3)}
  }


}

set args [utdscript_args]
# puts stderr "raw args: $args"
set args [string trimright $args]
set num_args [llength $args]
set routine "cachepractice"
# puts stderr "args: $args num: $num_args"
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "-debug" } {
    lappend options "-debug"
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "low_res" } {
    lappend options "-low_res"
  } elseif {$arg_el == "test" } {
    incr i
    if {$i < $num_args} {
      lappend options "-test"
      lappend options [lindex $args $i]
    } else {
      utdmsg errmsg $routine "Missing argument to test\n"
      exit 1 ;
    }
  } elseif {$arg_el == "libpath" } {
    incr i
    if {$i < $num_args} {
      lappend options "-libpath"
      lappend options [lindex $args $i]
    } else {
      utdmsg errmsg $routine "Missing argument to -libpath\n"
      exit 1 ;
    }
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  cache.tcl [low_res | libpath <path>]\n\n"
    exit 0
  } else {
    utdmsg errmsg cachepractice "Unknown option: $arg_el\n"
    exit 1
  }
}

if {[info exists options]} {
  wm withdraw .
  eval ::utdcache::display $options
} else {
  eval ::utdcache::display
}
wm withdraw .
