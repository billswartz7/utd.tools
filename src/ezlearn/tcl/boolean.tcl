#!/usr/local/bin/wish -f
#

namespace eval utdboolean {

  variable modeS 0
  variable questionS
  variable explanationS
  variable indirectionS 0
  variable answerS
  variable user_addrS 0
  variable user_answerS 0
  variable low_reS false
  variable addressS 0
  variable libpathS ./
  variable max_rangeS 0x2F

  proc display {w} {

    variable low_reS
    variable addressS
    variable libpathS
    set routine ::utdboolean::display
    set msg ""
    set debug_flag false

    set utdtoolsdir $::twez::configS(E_rootdir)
    puts stderr "utdroot: $utdtoolsdir"

    frame $w.labframe -borderwidth 1 -relief raised
    if {$msg != ""} {
      set msg_width [string length $msg]
      label $w.labframe.lab -text $msg -width $msg_width
    } else {
      label $w.labframe.lab -text "UTD Embedded Practice Tool:" -width 46
    }
    set fdata [frame $w.boolean -relief raised -bd 1]

    image create photo embedded \
	    -file [file join $utdtoolsdir share ezlearn embedded memory_mapped.gif ]
    label $fdata.im -image embedded -bd 1 -relief sunken

    label $fdata.question -text "Question: Click the New Question button to start the program questions?" \
      -textvariable ::utdboolean::questionS 

    label $fdata.explanation -text "Explanation:" -textvariable ::utdboolean::explanationS 

    if {0} {


      set finfo [frame $fdata.answer -borderwidth 1 -relief raised]
      label $finfo.qlab -text "Your Answer: "
      entry $finfo.answer -textvariable ::utdboolean::answerS


      pack $finfo.qlab -side left
      pack $finfo.answer -side left -fill x -expand true
      pack $finfo.fmat -side right


      grid $finfo -row 2 -column 0 -columnspan 2 -sticky news -pady 30

  }
    tixButtonBox $w.buttons -orientation horizontal
    $w.buttons add new -text "New Question" -command "::utdboolean::new_question $w"
    $w.buttons add check -text "Check Answer" -command "::utdboolean::check_answer $w"
    $w.buttons add show -text "Show Answer" -command "::utdboolean::show_answer $w"
    $w.buttons add fonts -text "Fonts" -command "::utdfonts::display"

    grid $fdata.im -row 0 -column 0 -sticky news -pady 0
    grid $fdata.question -row 1 -column 0 -sticky news -pady 0
    grid $fdata.explanation -row 2 -column 0 -sticky news -pady 0
    grid rowconfigure    $fdata 0 -weight 1
    grid columnconfigure $fdata 0 -weight 1
    grid propagate $fdata 1 

    # pack widget top level window
    pack $w.labframe.lab -side left
    pack $w.labframe -side top -fill x -anchor center
    pack $fdata -side top -fill x 
    pack $w.buttons -side top -fill x

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
    $tbl cellconfigure $tablerow,$tablecol -text $val
  }

  proc set_byte_color { tbl address color } {
    variable max_rangeS

    if {$address > $max_rangeS} {
      return
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
    # set color [$tbl cellcget $tablerow,$tablecol -background]
    # puts stderr "$address $faddress $tablerow $tablecol $offset color:$color"
    $tbl cellconfigure $tablerow,$tablecol -background $color
  }

  proc table_build_data {tbl} {
    $tbl delete 0 end
    $tbl insert end [list "Address" " " Data Data Data Data Data Data Data Data Data Data Data Data Data Data Data Data]
    $tbl insert end [list 0x0 " " 0x00 0x02 0x2B 0x4F 0x00 0x00 0x00 0x1C 0x00 0x00 0x01 0x00 0x05 0x04 0x03 0x02]
    $tbl insert end [list 0x10 " "  0x10 0x10 0x11 0x12 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x3D 0x00 0x1C 0x2F]
    $tbl insert end [list 0x20 " " 0x00 0xFF 0x3E 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x1F 0xFF 0x03 0x02]
  }

  proc rand_range {min max} { 
    return [expr int(rand()*($max-$min+1)) + $min] 
  }

  proc new_question {win} {
    variable modeS
    variable alignedS
    variable questionS
    variable explanationS
    variable addressS
    variable user_addrS
    variable max_rangeS
    variable indirectionS

    if {$alignedS == "aligned"} {
      set word_size [get_machine_size]
    } else {
      set word_size 1
    }
    reset_table_colors $win
    set max_range $max_rangeS
    set max_word [expr int(($max_range / $word_size))]
    set word_index [rand_range 0 $max_word]
    set address [expr $word_index * $word_size]
    set address [format %02X $address]
    if {$user_addrS != 0} {
      set address $user_addrS
    }
    set addressS "0x${address}"
    if {$modeS > 0} {
      set indirectionS [rand_range 0 2]
    } else {
      set indirectionS 0
    }

    if {$modeS == 2} {
      set var_choices "a b conv argv myarray myaddress buffer edge node"
      set num_vars [llength $var_choices]
      incr num_vars -1
      set var_idx [rand_range 0 $num_vars]
      set varname [lindex $var_choices $var_idx]
      set questionS "Question: Given the following C definitions: "
      if {$word_size == 8} {
	set vsize "long long"
      } elseif {$word_size == 4} {
	set vsize "long"
      } elseif {$word_size == 3} {
	utdmsg errmsg "new_question" "Invalid word size for C\n"
	return ;
      } elseif {$word_size == 2} {
	set vsize "short"
      } else {
	set vsize "unsigned char"
      }

      if {$indirectionS == 2} {
	append questionS "\n$vsize **${varname} ;\nWhat is the value of \'**${varname}\'"
      } elseif {$indirectionS == 1} {
	append questionS "\n$vsize *${varname} ;\nWhat is the value of \'*${varname}\'"
      } else {
	append questionS "\n$vsize ${varname} ;\nWhat is the value of \'${varname}\'"
      }
      append questionS " if the compiler/linker locates the variable @ $addressS?"
    } else {
      if {$indirectionS == 2} {
	set questionS "Question: What is the indirect indirect contents of the address: $addressS or (((${addressS}))) or MEM\[MEM\[MEM\[${addressS}]]]?"
      } elseif {$indirectionS == 1} {
	set questionS "Question: What is the indirect contents of the address: $addressS or ((${addressS})) or MEM\[MEM\[${addressS}]]?"
      } else {
	set questionS "Question: What is the contents of the address: $addressS or (${addressS}) or MEM\[${addressS}]?"
      }
    }
    set explanationS "Explanation:"

  }

  proc reset_table_colors {win} {
    variable max_rangeS

    set tbl "$win.memory.tbl"
    set num_rows [$tbl size]
    set num_cols [$tbl columncount]
    for {set tablerow 0} {$tablerow < $num_rows} {incr tablerow} {
      if {([expr {$tablerow % 2}] == 0)} {
	set color white
      } else {
	set color #e0e8f0
      }
      for {set tablecol 0} {$tablecol < $num_cols} {incr tablecol} {
	$tbl cellconfigure $tablerow,$tablecol -background $color
      }
    }
  }

  proc get_contents {start_address word_size tbl color} {
    variable endianS

    set end_address [expr $start_address + $word_size - 1]
    set contents "0x"
    if {$endianS == "Big"} {
      for {set addr $start_address} {$addr <= $end_address} {incr addr} {
	set val [get_byte_contents $tbl $addr]
	append contents [strip_hex_format $val]
	if {$color != ""} {
	  set_byte_color $tbl $addr $color
	}
      }
    } else {
      for {set addr $end_address} {$addr >= $start_address} {incr addr -1} {
	set val [get_byte_contents $tbl $addr]
	append contents [strip_hex_format $val]
	if {$color != ""} {
	  set_byte_color $tbl $addr $color
	}
      }
    }
    return $contents
  }

  proc calc_answer {win contents1_var contents2_var contents3_var color_flag} {
    variable addressS
    variable endianS
    variable indirectionS
    variable user_answerS
    upvar $contents1_var contents1
    upvar $contents2_var contents2
    upvar $contents3_var contents3

    set contents1 ""
    set contents2 ""
    set contents3 ""

    if {$user_answerS != 0} {
      return $user_answerS
    }

    set tbl "$win.memory.tbl"
    set word_size [get_machine_size]

    if {$color_flag} {
      set color red
    } else {
      set color ""
    }
    set contents1 [get_contents $addressS $word_size $tbl $color]
    set contents $contents1
    if {$indirectionS >= 1} {
      if {$color_flag} {
	set color magenta
      } else {
	set color ""
      }
      set contents2 [get_contents $contents $word_size $tbl $color]
      set contents $contents2
    }
    if {$indirectionS >= 2} {
      if {$color_flag} {
	set color green
      } else {
	set color ""
      }
      set contents3 [get_contents $contents $word_size $tbl $color]
      set contents $contents3
    }
    return $contents

  }

  proc strip_hex_format { val } {
    set xchar [string index $val 1]
    if {$xchar == "x"} {
      set val [string range $val 2 end]
    }
    return $val
  }

  proc dec2bin x {
    set ret [string trimleft [string map {0 {000} 1 {001} 2 {010} 3 {011} 4 {100} 5 {101} 6 {110} 7 {111}} [format %o $x]] 0]
    if {$ret == ""} {
      set ret 0
    }
    return $ret
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
    variable explanationS

    set contents [calc_answer $win con1 con2 con3 true]
    set answerS $contents
    if {$formatS != "hexadecimal"} {
      set answerS [expr $answerS + 0]
      if {$formatS == "binary"} {
	set answerS [dec2bin $answerS]
      } elseif {$formatS == "complement2"} {
	set answerS [complement2 $answerS]
      }
    } 
    if {$con3 != ""} {
      set explanationS "Explanation: The contents of the first memory fetch \
is in red and its value is $con1.\nThe contents of ($con1) is shown by the \
magenta addresses and yields $con2.\nThe contents of ($con2) is shown by the \
green addresses\n"
    } elseif {$con2 != ""} {
      set explanationS "Explanation: The contents of the first memory fetch \
is in red and its value is $con1.\nThe contents of ($con1) is shown by the \
magenta addresses\n"
    } else {
      set explanationS "Explanation: The addresses involved in obtaining data contents are highlighted in red"
    }
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

  proc check_answer {win} {
    variable formatS
    variable answerS

    set user_val $answerS
    set contents [calc_answer $win con1 con2 con3 false]
    set xchar [string index $user_val 1]
    if {$xchar == "x"} {
      # both are in hexadecimal
      if {$user_val == $contents} {
	correct_msg
      } else {
	wrong_msg
      }
    } elseif {$formatS == "binary"} {
      set contents_dec [expr $contents + 0]
      set contents_bin [dec2bin $contents_dec]
      # puts stderr "user:$user_val contents: $contents_bin"
      if {$user_val == $contents_bin} {
	correct_msg
      } else {
	wrong_msg
      }
    } elseif {$formatS == "complement2"} {
      set contents_dec [expr $contents + 0]
      set contents2 [complement2 $contents_dec]
      # puts stderr "user:$user_val contents: $contents_bin"
      if {$user_val == $contents2} {
	correct_msg
      } else {
	wrong_msg
      }
    } else {
      # assume decimal
      set contents_dec [expr $contents + 0]
      if {$contents_dec == $user_val} {
	correct_msg
      } else {
	wrong_msg
      }
    }
  }

  proc random_mem {win} {
    variable modeS
    variable max_rangeS
    variable endianS
    set tbl "$win.memory.tbl"

    set memsize [get_machine_size]
    if {$modeS > 0} {
      set range [expr $max_rangeS / $memsize]
      # puts stderr "range: $range"
    } else {
      set range 255
      set memsize 1
    }
    # puts stderr "memsize: $memsize"
    for {set addr 0} {$addr <= $max_rangeS} {incr addr $memsize} {
      set next_address [expr {$addr + $memsize}]
      if {$endianS == "Big"} {
	for {set a $addr} {$a < $next_address} {incr a} {
	  set new_data 0
	  set new_hex_data [format %02X $new_data]
	  set new_byte_val "0x${new_hex_data}"
	  set_byte_contents $tbl $a $new_byte_val
	}
	set a [expr {$next_address - 1}]
	set new_data [rand_range 0 $range]
	set new_data [expr {$new_data * $memsize}]
	set new_hex_data [format %02X $new_data]
	set new_byte_val "0x${new_hex_data}"
	set_byte_contents $tbl $a $new_byte_val

      } else {
	set new_data [rand_range 0 $range]
	set new_data [expr {$new_data * $memsize}]
	set new_hex_data [format %02X $new_data]
	set new_byte_val "0x${new_hex_data}"
	set_byte_contents $tbl $addr $new_byte_val
	for {set a [expr {$addr + 1}]} {$a < $next_address} {incr a} {
	  set new_data 0
	  set new_hex_data [format %02X $new_data]
	  set new_byte_val "0x${new_hex_data}"
	  set_byte_contents $tbl $a $new_byte_val
	}
      }
    }
  }

  proc update_mode { w args } {
    variable modeS
    if {$modeS > 0} {
      set fdata $w.memory
      tixSetSilent $fdata.aligned aligned
    }
    random_mem $w
  }

  proc splash { correct_flag } {
    variable libpathS

    if {[winfo exists .splash]} {
      wm withdraw .splash
      wm deiconify .splash
      return ;
    }
    # wm withdraw .
    #
    wm deiconify .
    toplevel .splash -bd 3 -relief raised
    set sw [winfo screenwidth .]
    set sh [winfo screenheight .]
    set libpath ./
    if {$correct_flag} {
      image create photo splash \
	      -file [ file join $libpathS good.gif ]
    } else {
      image create photo splash \
	      -file [ file join $libpathS incorrect.gif ]
    }
    label .splash.im -image splash -bd 1 -relief sunken
    set ih [image height splash]
    set iw [image width splash]
    set x [expr {($sw - $iw) /2}]
    set y [expr {($sh - $ih) /2}]
    wm geometry .splash +$x+$y
    if {$correct_flag} {
      wm title .splash "Congratulations!  Good work!"
    } else {
      wm title .splash "Sorry, try again!"
    }
    # Can't use overrideredict because of a bug with raise.
    # wm overrideredirect .splash 1
    pack  .splash.im -side top -expand true -fill both
    raise .splash .
    wm withdraw .
    update idletasks
    after 2000 { catch { destroy .splash } }
  }

  proc dump_table { } {
    set win .utdboolean
    set tbl "$win.memory.tbl"
    set range 47
    set memsize 1
    set fp [open "table_info" w]
    if {$fp == ""} {
      utdmsg errmg dump_table "could not open table_info for writing.\n"
      return
    }
    puts $fp "Main memory"
    puts $fp "\\tiny"
    puts $fp "\\begin{center}"
    puts $fp "\\begin{tabular}{ |c||c|c|c|c|c|c|c|c|c|c|c|c|c|c|c|c| }\\hline"
    puts $fp "Address & Data & Data & Data & Data & Data & Data & Data & Data & Data & Data & Data & Data & Data & Data & Data & Data \\\\ \\hline"
    puts $fp "Offset  &  0 & 1 & 2 & 3 & 4 & 5 & 6 & 7 & 8 & 9 & A & B & C & D & E & F \\\\ \\hline"
    for {set addr 0} {$addr <= $range} {incr addr $memsize} {
      set val [get_byte_contents $tbl $addr]
      if {($addr % 16) == 0} {
	puts -nonewline $fp "0x[format %02X $addr]"
      }
      puts -nonewline $fp " & $val"
      if {([expr ($addr+1) % 16]) == 0} {
	puts $fp " \\\\ \\hline"
      }
    }
    puts $fp "\\hline"
    puts $fp "\\end{tabular}"
    puts $fp "\\end{center}"
    puts $fp ""
    puts $fp "\\normalsize"
    puts stderr "table info written"
    close $fp
  }

}



namespace eval twez {

  proc start_boolean_tool {w} {
      variable configS
      variable exec_pipeS

      if {([info exists configS(P_boolean)]) && ($configS(P_boolean))} {
	utdalert_user errmsg ez:start_translate "Boolean tool is already loaded.  Ignoring command."
	return
      }
      puts stderr "we past this: $w"

      set utdtoolsdir $configS(E_rootdir)
      puts stderr "utdroot: $utdtoolsdir"

      set id [winfo id $w]
      puts stderr "id:$id"
      set id [format %d $id]
      puts stderr "id:$id"
      ::utdboolean::display $w
      update

  }

}
