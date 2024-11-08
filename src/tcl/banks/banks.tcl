#!/usr/local/bin/wish -f
#
# $Log: banks.tcl,v $
# Revision 1.7  2020/05/04 19:48:27  bill
# Changed from stdout to stderr so we don't have to worry about flushing
# stream which didn't work on NoMachine.
#
# Revision 1.6  2020/05/04 19:43:05  bill
# Fixed problem with calling compute_answer too many times.
#
# Revision 1.5  2020/05/04 16:48:02  bill
# Added missing blocking initialization statement for NoMachine.
#
# Revision 1.4  2020/05/04 12:49:15  bill
# Added ability to test using SQL database.
#
# Revision 1.3  2020/05/02 02:27:14  bill
# New improved version which takes addresses rather than word indices.
#

namespace eval utdmbanks {
  variable rootdirS
  variable indexS "8001 8011 8021 8031 8041 8051 8061 8071 8081 8091 8101 8111"
  variable addresseS "0 32 64 96"
  variable numbankS 8
  variable addr_widthS 4
  variable readyS
  variable clockS 0
  variable issue_cycleS 1
  variable busy_cycleS 5
  variable filenameS "banks.rpt"

  proc init { } {
    global env
    global auto_path
    variable rootdirS
    if {[info exists env(UTDTOOLS)]} {
      set rootdirS [file join $env(UTDTOOLS) $env(UTDTOOLSVERSION)]
    } {
      puts stderr "ERROR:cannot get UTD tools environment variable:UTDTOOLS"
      exit
    }
    if {[info exists rootdirS]} {
      lappend auto_path [file join $rootdirS tcl utdtools]
    }
  }

  proc report {args} {
    variable indexS
    variable clockS
    variable readyS
    variable numbankS
    variable filenameS
    variable addresseS
    variable addr_widthS
    variable busy_cycleS 
    variable issue_cycleS
    set routine "::utdmbanks::report"

    initialize_data

    # set defaults
    set data_output "file"
    set num_args [llength $args]
    for {set i 0} {$i < $num_args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-file" } {
	# -file <filename>
	incr i
	if {$i < $num_args} {
	  set filenameS [lindex $args $i]
	  set file file
	  set data_output "file"
	} else {
	  utdmsg errmsg $routine "Missing net argument to -file command\n"
	  return ;
	}
      } elseif {$arg_el == "-screen" } {
	set data_output "screen"
      } elseif {$arg_el == "-numbanks" } {
	# -numbanks <integer>
	incr i
	if {$i < $num_args} {
	  set numbankS [lindex $args $i]
	} else {
	  utdmsg errmsg $routine "Missing number of banks argument to -numbanks command\n"
	  return ;
	}
      } elseif {$arg_el == "-index" } {
	# -index {list}
	incr i
	if {$i < $num_args} {
	  set indexS [lindex $args $i]
	} else {
	  utdmsg errmsg $routine "Missing list of word indices to -index command\n"
	  return ;
	}
      } elseif {$arg_el == "-addresses" } {
	# -addresses {list}
	incr i
	if {$i < $num_args} {
	  set addresseS [lindex $args $i]
	  set indexS ""
	} else {
	  utdmsg errmsg $routine "Missing list of word indices to -index command\n"
	  return ;
	}
      } elseif {$arg_el == "-busy" } {
	# -numbusy <integer>
	incr i
	if {$i < $num_args} {
	  set busy_cycleS [lindex $args $i]
	} else {
	  utdmsg errmsg $routine "Missing number of busy cycles argument to -busy command\n"
	  return ;
	}
      } elseif {$arg_el == "-issue" } {
	# -issue <integer>
	incr i
	if {$i < $num_args} {
	  set issue_cycleS [lindex $args $i]
	} else {
	  utdmsg errmsg $routine "Missing number of issue cycles argument to -issue command\n"
	  return ;
	}
      } elseif {$arg_el == "-width" } {
	# -issue <integer>
	incr i
	if {$i < $num_args} {
	  set addr_widthS [lindex $args $i]
	} else {
	  utdmsg errmsg $routine "Missing size of address width to the -width command\n"
	  return ;
	}
      } else { 
	utdmsg errmsg $routine "Unknown argument:$arg_el\n"
      }
    }

    package require utd_table 1.0
    set ntable [utdtable create] 
    $ntable addfield "Memory Address" integer addr
    $ntable addfield "Hex Address" string hex
    $ntable addfield "Binary Rep of Address" string addr_binrep
    $ntable addfield "Binary Rep of Word" string binrep
    $ntable addfield "Memory Word Index" integer word
    $ntable addfield "Bankbits" string bits
    $ntable addfield "Bank" integer bank
    $ntable addfield "Issued" string issue
    $ntable addfield "Busy" string busy
    $ntable addfield "Ready" integer ready


    set nbits [log2 $numbankS]
    if {$indexS == ""} {
      set address_flag true
      set indexS $addresseS
    } else {
      set address_flag false
    }
    set all_aligned true
    foreach item $indexS {
      $ntable newrecord
      set aligned_flag true
      if {$address_flag} {
	set addr_orig $item
	set item [expr {int($item / $addr_widthS)}]
	set addr [expr {$item * $addr_widthS}]
	if {$addr != $addr_orig} {
	  set aligned_flag false
	  set all_aligned false
	}
	$ntable data word $item
      } else {
	$ntable data word $item
	set addr [expr {$item * $addr_widthS}]
      }
      $ntable data addr $addr
      set hexval [format %X $addr]
      set hex "0x${hexval}"
      if {$aligned_flag} {
	$ntable data hex $hex
      } else {
	set hexval_orig [format %X $addr_orig]
	set hex_orig "0x${hexval_orig}"
	$ntable data hex "* $hex_orig $hex"
      }
      set binrep [dec2bin $item]
      $ntable data binrep $binrep
      set addr_binrep [dec2bin $addr]
      $ntable data addr_binrep $addr_binrep
      set binrep_len [string length $binrep]
      set last [expr {$binrep_len - $nbits}]
      set bits [string range $binrep $last end]
      $ntable data bits $bits
      set bank_idx [expr {$item % $numbankS}]
      $ntable data bank $bank_idx
      incr clockS
      # Now see if we are ready.
      if {[info exists readyS($bank_idx)]} {
	set available $readyS($bank_idx)
      } else {
	set available $clockS
      }
      if {$clockS >= $available} {
	set issue $clockS
      } else {
	set issue $available
      }
      # Now update clock to issue
      set clockS $issue
      set busy_cycles ""
      if {$issue_cycleS > 1} {
	set issue_cycles $issue
	for {set i 2} {$i <= $issue_cycleS} {incr i} {
	  incr issue
	  lappend issue_cycles $issue
	}
	$ntable data issue $issue_cycles
      } else {
	$ntable data issue $issue
      }
      for {set b 1} {$b <= $busy_cycleS} {incr b} {
	incr issue
	lappend busy_cycles $issue
      }
      $ntable data busy $busy_cycles

      # We are ready on the next cycle.
      incr issue
      set readyS($bank_idx) $issue
      $ntable data ready $issue

    }
    set seconds [clock seconds]
    # set odata "Memory Bank report generated by itools:[ictools_version] @\
    set odata "Memory Bank report generated by itools @\
[clock format $seconds -format "%b %d %H:%M:%S %Y"]\n\n"
    append odata "Address size (bytes)         : $addr_widthS\n"
    append odata "Number of Banks              : $numbankS\n"
    append odata "Issue Time in Cycles         : $issue_cycleS\n"
    append odata "Memory Access Time in Cycles : $busy_cycleS\n\n"
    append odata [$ntable print]
    $ntable free

    set addr_bits [log2 $addr_widthS]
    if {$addr_bits > 0} {
      append odata "\nIt take $addr_bits bits to represent the natural word size.\n"
      append odata "We discard these rightmost $addr_bits bits to arrive at the word representation\n\n"
    }

    if {$all_aligned} {
      append odata "\nAll addresses are aligned.\n\n"
    } else {
      append odata "\n* Unaligned addresses are present, forced to alignment, and shown by asterisk.\n\n"
    }

puts stderr "data output: $data_output"
    if {$data_output == "screen"} {
      output_file $odata screen
    } elseif {$data_output == "tk"} {
      display_data .icroute_output "Routing Report" $odata
    } else {
      output_file $odata $filenameS
    }
  }


  proc display_data {w title data} {
    global tixOption

    if [winfo exists $w] {
	wm deiconify $w
	raise $w
	return
    }
    toplevel $w 
    wm title $w $title

    button $w.b -text Close -command "destroy $w"
    button $w.dump -text {Dump To File} -command "::icroute_statistics::output_file [list $data]"
    set t [tixScrolledText $w.text]
    tixForm $w.b    -left 0 -bottom -0 -padx 4 -pady 4
    tixForm $w.dump    -left $w.b -bottom -0 -padx 4 -pady 4
    tixForm $w.text -left 0 -right -0 -top 0 -bottom $w.b

    $t subwidget text config -highlightcolor [$t cget -bg] -bd 2 \
	-bg [$t cget -bg] -font $tixOption(fixed_font) 

    set text [$w.text subwidget text]
    $text config -wrap none
    $text delete 1.0 end
    if {$data != ""} {
      $text insert end $data\n
    } else {
      $text insert end "No instance data found\n"
    }
    $text see 1.0
    $text config -state disabled
  }

  proc output_file {odata args} {
    variable filenameS
    if {$args != ""} {
      if {$args == "screen"} {
	puts "$odata"
	flush stdout
	return ;
      } 
      set filename $args
    } else {
      if {[info exists $filenameS]} {
	set filename $filenameS
      } else {
	return ;
      }
    }
    set fp [open $filename "w"]
    puts $fp "$odata"
    close $fp
  }

  proc dec2bin x {
    set bin_rep [string trimleft [string map {0 {000} 1 {001} 2 {010} 3 {011} 4 {100} 5 {101} 6 {110} 7 {111}} [format %o $x]] 0]
    if {$bin_rep == ""} {
      set bin_rep 0
    }
    return $bin_rep
  }

  proc log2 {num} {
    expr {int(log($num)/log(2))}
  }

  proc pow2 {num} {
    expr {int(pow(2,$num))}
  }

  proc initialize_data {  } {
    variable readyS
    variable clockS

    set clockS 0
    if {[info exists readyS]} {
      unset readyS
    }
  }

  proc compute_answer {numbanks width latency addr} {
    variable readyS
    variable clockS

    set nbits [log2 $numbanks]
    set aligned_flag true
    set index [expr {int($addr / $width)}]
    set check_addr [expr {$index * $width}]
    if {$addr != $check_addr} {
      set aligned_flag false
    }

    set hexval [format %X $addr]
    set hex "0x${hexval}"
    set addr_binrep [dec2bin $addr]
    set binrep [dec2bin $index]
    set binrep_len [string length $binrep]
    set last [expr {$binrep_len - $nbits}]
    set bits [string range $binrep $last end]
    set bank_idx [expr {$index % $numbanks}]
    incr clockS
    # Now see if we are ready.
    if {[info exists readyS($bank_idx)]} {
      set available $readyS($bank_idx)
    } else {
      set available $clockS
    }
    if {$clockS >= $available} {
      set issue $clockS
    } else {
      set issue $available
    }
    # Now update clock to issue
    set clockS $issue
    set busy_cycles ""
    lappend issue_cycles $issue

    for {set b 1} {$b <= $latency} {incr b} {
      incr issue
      lappend busy_cycles $issue
    }
    # We are ready on the next cycle.
    incr issue
    set readyS($bank_idx) $issue
    set answer [list $hex $addr_binrep $index $binrep $bits $bank_idx $available $issue_cycles $busy_cycles $issue]
  }

  proc get_student_answer {netid question correct_answer} {

    set correct [::utdcache::get_test_field $netid $question correct]
    if {($correct != "") && ($correct != "{}")} {
      if {$correct} {
	puts stderr "Already answered correctly!"
	flush stdout
	return ;
      }
    }
    set tries [::utdcache::get_test_field $netid $question tries]
    if {$tries < 3} {
      for {set try 1} {$try <= 3} {incr try} {
	set user_answer [gets stdin]
	set user_val [string trim $user_answer]
	::utdcache::set_test_field $netid $question tries $try
	::utdcache::set_test_field $netid $question answer $user_val
	if {$user_val == $correct_answer} {
	  puts stderr "Correct!"
	  flush stdout
	  ::utdcache::set_test_field $netid $question correct true
	  return ;
	} else {
	  puts stderr "Incorrect!  Please try again."
	  flush stdout
	  ::utdcache::set_test_field $netid $question correct false
	}
      }
    }
    puts stderr "Unfortunately, you have used up all your attempts."
    flush stdout
  }

  proc question {netid q num_banks latency width addresses debug} {
    variable answerS
    set msg "Question $q):"
    switch $q {
      1 {
	set faddress [lindex $addresses 0]
	set answerS [compute_answer $num_banks $width $latency $faddress]
	print_answer $answerS $debug
	append msg "when is address $faddress issued? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 7]
      }
      2 {
	set faddress [lindex $addresses 0]
	print_answer $answerS $debug
	append msg "what is binary representation of $faddress? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 1]
      }
      3 {
	set faddress [lindex $addresses 0]
	print_answer $answerS $debug
	append msg "what is memory bank (in decimal) is accessed for $faddress? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 5]
      }
      4 {
	set faddress [lindex $addresses 0]
	print_answer $answerS $debug
	append msg "when is memory bank [lindex $answerS 5] available again after processing address $faddress? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 9]
      }
      5 {
	set address2 [lindex $addresses 1]
	set answerS [compute_answer $num_banks $width $latency $address2]
	print_answer $answerS $debug
	append msg "what is memory bank (in decimal) is accessed for $address2? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 5]
      }
      6 {
	set address2 [lindex $addresses 1]
	# set answerS [compute_answer $num_banks $width $latency $address2]
	print_answer $answerS $debug
	append msg "when is memory bank [lindex $answerS 5] available again after processing address $address2? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 9]
      }
      7 {
	set address3 [lindex $addresses 2]
	set answerS [compute_answer $num_banks $width $latency $address3]
	print_answer $answerS $debug
	append msg "what is memory bank (in decimal) is accessed for $address3? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 5]
      }
      8 {
	set address4 [lindex $addresses 3]
	set answerS [compute_answer $num_banks $width $latency $address4]
	print_answer $answerS $debug
	append msg "what is memory bank (in decimal) is accessed for $address4? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 5]
      }
      9 {
	set address5 [lindex $addresses 4]
	set answerS [compute_answer $num_banks $width $latency $address5]
	print_answer $answerS $debug
	append msg "what is memory bank (in decimal) is accessed for $address5? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 5]
      }
      10 {
	set address5 [lindex $addresses 4]
	# set answerS [compute_answer $num_banks $width $latency $address5]
	print_answer $answerS $debug
	append msg "when is memory bank [lindex $answerS 5] available again? "
	puts -nonewline stderr $msg
	flush stdout
	get_student_answer $netid $q [lindex $answerS 9]
      }
      default {
	append msg "the default\n"
	puts -nonewline stderr $msg
	flush stdout
      }
    }
  }

  proc print_answer {answer debug} {
    if {$debug} {
      set len [llength $answer]
      puts stderr "answer: $answer"
      for {set i 0} {$i < $len} {incr i} {
	set field [lindex $answer $i]
	puts stderr "answer($i): $field"
      }
    }
  }

  proc compute_score {netid num_questions} {
    set num_correct 0
    set num_answered 0
    for {set question 1} {$question <= $num_questions} {incr question} {
      set correct [::utdcache::get_test_field $netid $question correct]
      if {($correct != "") && ($correct != "{}")} {
	incr num_answered 
	if {$correct} {
	  incr num_correct
	}
      }
    }
    puts stderr "You scored $num_correct out of $num_questions"
    ::utdcache::set_test_field $netid banks_score answer $num_correct
  }

  proc test {database} {
    variable clockS
    wm withdraw .
    set clockS 0
    expr {srand(3)}
    set debug false
    set ::utdcache::optionS(test) $database
    set ::utdcache::optionS(test_name) "membanks"
    set ::utdcache::optionS(debug) off
    set netid [::utdcache::test_login]
    update
    set num_banks [::utdcache::get_user_data $netid Membanks]
    set latency [::utdcache::get_user_data $netid Latency]
    set width [::utdcache::get_user_data $netid Wide]
    set addresses [::utdcache::get_user_data $netid Addresses]
    set addresses [lindex $addresses 0]
    puts stderr "Your computer has $num_banks banks"
    puts stderr "The memory controller has a latency of $latency in addition to an issue time of 1 cycle"
    puts stderr "The natural machine size of your computer is $width bytes"
    puts stderr "The CPU has issued the following addresses: $addresses\n"
    flush stdout
    for {set q 1} {$q <= 10} {incr q} {
      question $netid $q $num_banks $latency $width $addresses $debug
    }
    compute_score $netid 10
    twexit 0

  }

}




# Common startup code
::utdmbanks::init

global argv
set args $argv
set args [utdscript_args]
set args [string trimright $args]
set num_args [llength $args]
# puts stderr "args: $args $num_args"
set info [lindex $args 0]

# puts stderr "argv: $argv"

if {($info == "") || ($info == "help")} {
  puts stderr "\nUse:"
  puts stderr "membanks interact"
  puts stderr "  run the memory banks simulator interactively"
  exit 0
} elseif {($info == "test")} {
  source login.tcl
  set database ""
  for {set arg 1} {$arg < $num_args} {incr arg} {
    set arg_el [lindex $args $arg]
    set database $arg_el
  }
  puts stdout "\nMembanks Test Tool version 1.0\n"
  fconfigure stdin -blocking on
  ::utdmbanks::test $database

} elseif {($info == "interact")} {
  while {1} {
    puts stdout "\nMembanks simulator version 2.0\n"
    puts -nonewline stdout "How many memory banks are present? "
    flush stdout
    set numbanks [gets stdin]
    if {($numbanks == 1) || ($numbanks == 2) || ($numbanks == 4) || ($numbanks == 8) || ($numbanks == 16) || \
        ($numbanks == 32) || ($numbanks == 64) || ($numbanks == 128) || ($numbanks == 256) || ($numbanks == 512)} {
      break ;
    }
    if {($numbanks <= 0)} {
      puts stdout "Number of banks must not be less than 1. "
    } elseif {($numbanks > 512)} {
      puts stdout "Number of banks may not be greater than 512 at this time. "
    } else {
      puts stdout "Number of banks must be a power of 2. "
    }
    puts -nonewline stdout "How many memory banks are present? "
    flush stdout
  }
  puts -nonewline stdout "What is a bank's latency or how cycles does the banks stay busy? "
  flush stdout
  set busy [gets stdin]

  # puts -nonewline stdout "How many cycles does it take to issue a memory operation? "
  # flush stdout
  # set issue [gets stdin]
  set issue 1

  while {1} {
    puts -nonewline stdout "How wide is the memory address in bytes? "
    flush stdout
    set width [gets stdin]
    if {($width == 1) || ($width == 2) || ($width == 4) || ($width == 8) || ($width == 16) || ($width == 32)} {
      break ;
    }
    if {($width <= 0)} {
      puts stdout "Width of the address must be positive and a power of 2. "
    } elseif {($width > 32)} {
      puts stdout "Width of the address can not be greater than 32 Bytes at this time. "
    } else {
      puts stdout "Width of the address must be positive and a power of 2. "
    }
    puts -nonewline stdout "How wide is the memory address in bytes? "
    flush stdout
  }
  puts -nonewline stdout "What addresses in decimal or hex format will be accessed? "
  flush stdout
  set addresses [gets stdin]
  ::utdmbanks::report -screen -numbanks $numbanks -busy $busy -issue $issue -width $width -addresses $addresses
  utdexit

} else {
  ::utdmbanks::report 
  ::utdmbanks::report -file fourbanks.rpt -numbanks 4 -busy 2
  ::utdmbanks::report -file sixteen.rpt -numbanks 16 -busy 8 -issue 3
  ::utdmbanks::report -file 64.rpt -numbanks 8 -busy 4 -issue 2 -width 8
  ::utdmbanks::report -file simple.rpt -numbanks 4 -busy 2 -index {2 3 5 7 9 12 10}

  exec cat banks.rpt fourbanks.rpt sixteen.rpt 64.rpt simple.rpt >examples
  utdexit
}
