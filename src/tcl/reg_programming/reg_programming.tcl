#!/usr/local/bin/wish -f
#

namespace eval utdreg_mapped {

  variable questionS
  variable explanationS
  variable answerS
  variable user_answerS 0
  variable low_reS false
  variable libpathS ./
  variable canvS 

  proc display {args} {

    variable low_reS
    variable addressS
    variable libpathS
    variable canvS 
    set routine ::utdreg_mapped::display
    set msg ""
    set debug_flag false
    set num_args [llength $args]
    set canvS(idx_text_offset) 0
    for {set i 0} {$i < $num_args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-debug" } {
	set debug_flag true
      } elseif {$arg_el == "-message" } {
	incr i
	if {$i < $num_args} {
	  set msg [lindex $args $i]
	} else {
	  utdmsg errmsg $routine "Missing argument to -message\n"
	  return ;
	}
      } elseif {$arg_el == "-low_res" } {
	set low_reS true
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
	utdmsg errmsg $routine "Unknown arguments: $args\n"
	utdmsg errmsg null "Supported arguments:-debug, -message\n"
	return ;
      }
    }
    set w .utdreg_mapped

    # First make sure main dialog doesn't exist.
    if {[winfo exists $w]} {
      wm withdraw $w
      wm deiconify $w
      return ;
    }

    toplevel $w  \
      -background {lightgray} \
      -highlightbackground {lightgray}

    set canvS(toplevel_win) $w

    # Window manager configurations
    # wm minsize $w 9 10
    # wm sizefrom $w program
    # wm positionfrom $w program
    wm title $w {Memory Mapped Register Practice Tool}
    wm protocol $w WM_DELETE_WINDOW utdexit
    # We create the frame and the two ScrolledListBox widgets
    # at the top of the dialog box
    #
    frame $w.labframe -borderwidth 1 -relief raised
    if {$msg != ""} {
      set msg_width [string length $msg]
      label $w.labframe.lab -text $msg -width $msg_width
    } else {
      label $w.labframe.lab -text "UTD Memory Mapped Register Practice Tool:" -width 46
    }

    # tixScrolledWindow $w.canvas_frame
    # set sub_frame [$w.canvas_frame subwidget window]
    # canvas $sub_frame.canvas
    # pack $sub_frame.canvas -expand yes -fill both -padx 10 -pady 10


    set fdata [frame $w.reg_info -relief raised -bd 1]
    set canvas_window [tixCObjView $fdata.canv]
    # puts stderr "canvas window: $canvas_window"
    # puts stderr "children: [winfo children $canvas_window]"
    set canvS(canvas_window) [$canvas_window subwidget canvas]
    # puts stderr "cwin:$canvS(canvas_window)"

    label $fdata.question -text "Question: Click the New Question button to start the program questions?\n " \
      -textvariable ::utdreg_mapped::questionS 

    label $fdata.explanation -text "Explanation:\n " \
      -textvariable ::utdreg_mapped::explanationS -anchor w -justify left


    set finfo [frame $fdata.answer -borderwidth 1 -relief raised]
    label $finfo.qlab -text "Your Answer: "
    entry $finfo.answer -textvariable ::utdreg_mapped::answerS

    tixComboBox $finfo.fmat -label "Format:" -dropdown true \
      -editable false -variable ::utdreg_mapped::formatS
    $finfo.fmat insert end binary
    $finfo.fmat insert end decimal
    $finfo.fmat insert end hexadecimal
    $finfo.fmat insert end complement2
    tixSetSilent $finfo.fmat hexadecimal

    pack $finfo.qlab -side left
    pack $finfo.answer -side left -fill x -expand true
    pack $finfo.fmat -side right


    grid $fdata.canv -row 0 -column 0 -columnspan 2 -sticky news -pady 0
    grid $fdata.question -row 1 -column 0 -sticky nsw -pady 10
    grid $fdata.explanation -row 2 -column 0 -sticky nws -pady 10
    grid $finfo -row 3 -column 0 -columnspan 2 -sticky news -pady 0

    grid rowconfigure    $fdata 0 -weight 1
    grid columnconfigure $fdata 0 -weight 1
    grid propagate $fdata 1 

    tixButtonBox $w.buttons -orientation horizontal
    $w.buttons add new -text "New Question" -command "::utdreg_mapped::new_question $w"
    $w.buttons add check -text "Check Answer" -command "::utdreg_mapped::check_answer $w"
    $w.buttons add show -text "Show Answer" -command "::utdreg_mapped::show_answer $w"
    $w.buttons add random -text "New Random Test" -command "::utdreg_mapped::random_mem $w"
    $w.buttons add fonts -text "Fonts" -command "::utdfonts::display"

    # pack widget top level window
    pack $w.labframe.lab -side left
    pack $w.labframe -side top -fill x -anchor center
    pack $w.reg_info -side top -anchor w -padx 0 -fill both -expand yes
    pack $w.buttons -side top -fill x

  }

  proc add_problem_to_canvas {bfilename x y scale winheight directions add_bindings} {
    # Adds a new problem to the canvas
    variable canvS

    set x1 $x
    set y1 $y
    set w $canvS(canvas_window)
    set boximg [image create photo]
    set txtcolor magenta
    $boximg read $bfilename -format gif
    set iwidth [image width $boximg]
    set iheight [image height $boximg]
    puts stderr "image size: $iwidth x $iheight"
    set hw [expr {int($iwidth / 2)}]
    set hh [expr {int($iheight / 2)}]
    set x2 [expr {$x1 + $iwidth}]
    set y2 [expr {$y1 + $iheight}]
    if {$scale < 1.0} {
      set x [expr {$scale * $x}]
      set y [expr {$scale * $y}]
      set x1 [expr {$scale * $x1}]
      set y1 [expr {$scale * $y1}]
      set x2 [expr {$scale * $x2}]
      set y2 [expr {$scale * $y2}]
      set hw [expr {$scale * $hw}]
      set hh [expr {$scale * $hh}]
      set new_data [$boximg scale [$boximg data] -scale $scale]
      image delete $boximg
      set boximg [image create photo]
      $boximg put $new_data
      set idx_text_offset [expr {$scale * $canvS(idx_text_offset)}]
    } else {
      set idx_text_offset $canvS(idx_text_offset)
    }
    if {$winheight > 0} {
      set ycanvas [expr {$winheight - $y}]
      set ynum [expr {$winheight - ($y1 - $idx_text_offset + $hh)}]
    } else {
      set ycanvas $y2
      set ynum [expr {($y1 + $idx_text_offset + $hh)}]
    }
    $w create image $x $ycanvas -image $boximg 
    set xpos [expr {$x - $idx_text_offset}]
    set item_info [$w create text \
	    $xpos $ynum \
	    -text $directions \
	    -anchor nw -fill $txtcolor]
    set fname [$w itemconfigure $item_info -font]
    set fname [lindex $fname 4]
    set foffset [calc_font_half_height $fname]
    set foffset [expr {$scale * $foffset}] 
    if {$winheight > 0} {
      set yname [expr {$winheight - (($y1+$y2)/2 - $hh + $foffset)}]
    } else {
      set yname [expr {(($y1+$y2)/2 + $hh - $foffset)}]
    }
    set large_font [font create -family Courier -size 24]
    set canvS(font) $large_font
    update_register true

    if {$add_bindings} {
      # $w bind box_$num <Button-1> "::twflow::box_button1 %W %x %y $num"
      # $w bind box_$num <Button-3> "::twflow::box_button3 %W %x %y $num %X %Y"
      # $w bind box_$num <Enter> "::twflow::box_enter %W %x %y $num"
      # $w bind box_$num <Leave> "::twflow::box_leave %W %x %y $num"
      # $w bind box_$num <Control-Button-1> "::twflow::box_ctrl_button1 %W %x %y $num"
      # $w bind box_$num <Double-Button-1> "::twflow::box_double_button1 %W %x %y $num"
      # boxlike_bindings $w $num
    }
  }

  proc create_text { w x y txt txtcolor font } {
    $w create text $x $y -text $txt -fill $txtcolor -font $font -tag regs
  }

  proc update_register { reset_flag } {
    variable canvS

    if { $reset_flag } {
      set canvS(15) ?
      set canvS(14) ?
      set canvS(13) ?
      set canvS(12) ?
      set canvS(11) ?
      set canvS(10) ?
      set canvS(9) ?
      set canvS(8) ?
      set canvS(7) ?
      set canvS(6) ?
      set canvS(5) ?
      set canvS(3) ?
    }

    set w $canvS(canvas_window)
    set large_font $canvS(font)
    $w delete regs
    create_text $w 100 544 $canvS(15) red $large_font
    create_text $w 155 544 $canvS(14) red $large_font
    create_text $w 210 544 $canvS(13) red $large_font
    create_text $w 260 544 $canvS(12) red $large_font
    create_text $w 310 544 $canvS(11) red $large_font
    create_text $w 360 544 $canvS(10) red $large_font
    create_text $w 410 544 $canvS(9) red $large_font
    create_text $w 460 544 $canvS(8) red $large_font
    create_text $w 510 544 $canvS(7) red $large_font
    create_text $w 570 544 $canvS(6) red $large_font
    create_text $w 620 544 $canvS(5) red $large_font
    create_text $w 730 544 $canvS(3) red $large_font
  }

  proc calc_font_half_height {fname} {
    set fm [font metrics $fname]
    set theight 0
    foreach {opt val} $fm {
      if {$opt == "-ascent"} {
	set theight [expr {$theight + $val}]
      } elseif {$opt == "-descent"} {
	set theight [expr {$theight + $val}]
      }
    }
    return [expr {int($theight / 2)}]
  }

  proc randomize_divider { divider_name } {
    variable dividerS

    set divider_vals [list 1 2 4 8]
    set v 0
    set val [rand_range 0 3]
    set used_already($val) $val
    set dividerS(${divider_name},0) $val

    for {set v 1} {$v <= 3} {incr v} {
      set val [rand_range 0 3]
      set max_count 1000000
      for {set count 1} {$count <= $max_count} {incr count} {
	set val [rand_range 0 3]
	if {!([info exists used_already($val)])} {
	  set dividerS(${divider_name},${v}) $val
	  set used_already($val) $val
	  break
	}
      }
      if {$count >= $max_count} {
	puts stderr "caught in an infinite loop"
      }
    }
  }

  proc divider_defs { divider_name } {
    variable dividerS
    set d $divider_name
    set out_string "${d} : "
    append out_string "divide_by    mux code\n"
    append out_string "             1                [binary_2bits $dividerS(${d},0)]\n"
    append out_string "             2                [binary_2bits $dividerS(${d},1)]\n"
    append out_string "             4                [binary_2bits $dividerS(${d},2)]\n"
    append out_string "             8                [binary_2bits $dividerS(${d},3)]\n"
    return $out_string

  }

  proc binary_2bits { x } {
    set val [dec2bin $x]
    set len [string length $val]
    if {$len > 2} {
      set offset [expr $len - 2]
      set val [string range $val $offset end]
    }
    return $val
  }

  proc load_problem { problem_image } {
    variable canvS

    calc_image_size $problem_image
    update
    set w $canvS(toplevel_win)
    set base_height $canvS(height)
    set h1 [winfo height $w.labframe]
    set h2 [winfo height $w.buttons]
    set fdata $w.reg_info
    set h3 [winfo height $fdata.question]
    set h4 [winfo height $fdata.explanation]

    set height [expr $base_height + $h1 + $h2 +$h3 + $h4 + $h4 + $h4]
    puts stderr "b:$base_height h1:$h1 h2:$h2 h3:$h3 h4:$h4 height:$height"
    wm geometry $canvS(toplevel_win) ${canvS(width)}x${height}

    randomize_divider DIVA
    randomize_divider DIVM
    randomize_divider DIVS
    set problem_defs "These are the divider mux definitions\n"
    append problem_defs [divider_defs DIVA]
    append problem_defs [divider_defs DIVM]
    append problem_defs [divider_defs DIVS]


    # add_problem_to_canvas image_file x y scale winheight text add_bindings
    ::utdreg_mapped::add_problem_to_canvas $problem_image $canvS(x) $canvS(y) 1.0 $canvS(height) $problem_defs false
  }

  proc calc_image_size { problem_image } {
    variable canvS

    set boximg [image create photo]
    $boximg read $problem_image -format gif
    set iwidth [image width $boximg]
    set iheight [image height $boximg]
    puts stderr "image size: $iwidth x $iheight"
    set canvS(x) [expr $iwidth / 2]
    set canvS(y) [expr $iheight / 2]
    set canvS(width) $iwidth
    set canvS(height) $iheight
  }



  proc empty_string { val } { 
    return "" 
  }

  proc new_divider { } {
    set val [rand_range 1 4]
    if {$val <= 2} {
      return $val
    } elseif {$val == 3} {
      return 4
    } else {
      return 8
    }
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
    variable dividerS


    set dividerS(divm) [new_divider]
    set dividerS(divs) [new_divider]
    set dividerS(diva) [new_divider]

    set questionS "Question: What is the C statement that will program the clock network if we wish the Master Clock to be divided by $dividerS(divm), \
the \nSubmaster Clock to be divided by $dividerS(divs), and the auxillary clock divided by $dividerS(diva)?"
    set explanationS "Explanation:"
    update_register true

  }


  proc calc_answer { need_explanation } {
    variable canvS
    variable dividerS
    variable explanationS

    set diva $dividerS(diva)
    set divm $dividerS(divm)
    set divs $dividerS(divs)

    set lookup(1) 0
    set lookup(2) 1
    set lookup(4) 2
    set lookup(8) 3

    set diva_bits [binary_2bits $dividerS(DIVA,$lookup(${diva}))]
    set divm_bits [binary_2bits $dividerS(DIVM,$lookup(${divm}))]
    set divs_bits [binary_2bits $dividerS(DIVS,$lookup(${divs}))]
    set selm_bits 00
    set sels 0
    set scg1 0
    set dcor 0
    set scg0 0
    set binary_answer "${diva_bits}${selm_bits}${divm_bits}${divs_bits}${sels}${scg1}${dcor}0${scg0}000"
    set easy_answer "${diva_bits}${selm_bits}_${divm_bits}${divs_bits}_${sels}${scg1}${dcor}0_${scg0}000"
    # puts stderr "binary answer: $binary_answer easy_answer: $easy_answer"
    set answer [bin2hex $binary_answer]
    if { $need_explanation } {
      set canvS(15) [string index $diva_bits 0]
      set canvS(14) [string index $diva_bits 1]
      set canvS(13) 0
      set canvS(12) 0
      set canvS(11) [string index $divm_bits 0]
      set canvS(10) [string index $divm_bits 1]
      set canvS(9) [string index $divs_bits 0]
      set canvS(8) [string index $divs_bits 1]
      set canvS(7) 0
      set canvS(6) 0
      set canvS(5) 0
      set canvS(3) 0
      set explanationS "Explanation: DIVA bits : $diva_bits DIVM bits: $divm_bits DIVS bits: $divs_bits\n"
      append explanationS "\t\t\tYielding the binary: $easy_answer -> converted to hex:$answer"
      update_register false
    }
    return $answer

  }

  proc strip_hex_format { val } {
    set xchar [string index $val 1]
    if {$xchar == "x"} {
      set val [string range $val 2 end]
    }
    return $val
  }

  proc dec2bin x {
    set ret [string trimleft [string map {0 {000} 1 {001} 2 {010} 3 {011} 4 {100} 5 {101} 6 {110} 7 {111}} [format %2o $x]] 0]
    if {$ret == ""} {
      set ret 0
    }
    return $ret
  }

  proc bin2dec {bin} {
    if {$bin == 0} {
        return 0
    } elseif {[string match -* $bin]} {
        set sign -
        set bin [string range $bin[set bin {}] 1 end]
    } else {
        set sign {}
    }
    set res 0
    for {set j 0} {$j < [string length $bin]} {incr j} {
        set bit [string index $bin $j]
        set res [expr {$res << 1}]
        set res [expr {$res | $bit}]
    }
    return $sign$res
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

  proc bin2hex {binary_num} {
    # puts stderr "bin2hex binary_num : $binary_num"
    set dec [bin2dec $binary_num]
    # puts stderr "bin2hex dec : $dec"
    set new_hex_data [format %0X $dec]
    # puts stderr "new hex: $new_hex_data"
    set new_hex_addr "0x${new_hex_data}"
    # puts stderr "new hex_addr: $new_hex_addr"
    return $new_hex_addr
  }

  proc show_answer {win} {
    variable answerS

    set raw_answer [calc_answer true]
    set answerS "CLOCKCONTROL = $raw_answer ;"
    return $answerS
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
    set raw_answer [calc_answer false]
    if {$formatS == "hexadecimal"} {
      # both are in hexadecimal
      # Try to parse it
      set num_scanned [scan $user_val "CLOCKCONTROL = %X;" val]
      if {$num_scanned >= 1} {
	set hex_data [format %0X $val]
	set new_hex_data "0x${hex_data}"
	puts stderr "hex $new_hex_data raw:$raw_answer"
	if {$new_hex_data == $raw_answer} {
	  correct_msg
	} else {
	  wrong_msg
	}
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


}


set args [utdscript_args]
puts stderr "args: $args"
set args [string trimright $args]
set num_args [llength $args]
set libpath ""
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  # puts stderr "arg_el($i): $arg_el"
  if {$arg_el == "debug" } {
    set debug_flag on
    puts stdout "debug mode enabled.\n"
    puts stderr "args: $args num: $num_args"
    flush stdout
  } elseif {($arg_el == "low_res") || ($arg_el == "lowres")} {
    lappend options "-low_res"
  } elseif {$arg_el == "libpath" } {
    incr i
    if {$i < $num_args} {
      lappend options "-libpath"
      set libpath [lindex $args $i]
      lappend options $libpath
    } else {
      utdmsg errmsg $routine "Missing argument to -libpath\n"
      return ;
    }
  } elseif {($arg_el == "help") || ($arg_el == "-help")} {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  memory.tcl \[low_res | libpath <path>]\n\n"
    after 5000 ;
    exit 0
  }
}

utdmsg imsg null "\nEmbedded Systems Register Mapped Memory Practice Program Version 1.0\n"

if {[info exists options]} {
  eval ::utdreg_mapped::display $options
} else {
  eval ::utdreg_mapped::display
}
wm withdraw .
# Add problem
set problem_image [file join $libpath memory_mapped.gif]
::utdreg_mapped::load_problem $problem_image
