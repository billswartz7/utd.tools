
namespace eval utdtools {
  namespace eval program {
    proc compile_solution {ansdir pgm_file pgm_name extra_args} {
      set cwd [pwd]
      cd $ansdir
      #######################################
      set cmd "gcc -o $pgm_name $pgm_file $extra_args"
      if {[catch {eval exec $cmd} result_msg]} {
	puts stderr "ERROR: $result_msg\n"
	puts stderr "cmd: $cmd\n"
      }

      global errorG
      global outputG
      set errorG ""
      set cmd "./${pgm_name}"
      if {[catch {eval bgexec statusG -output outputG -error errorG $cmd} msg]} {
	puts stderr "we got the following msg running $cmd:\n$msg\n"
      }
      #######################################
      cd $cwd
      return $errorG

    }

    proc prepare_solution { db table filename template_dir output_dir userid db_idx args } {
      variable questionS

      set debug_flag false
      set routine "utdtools::program::prepare_solution"
      if {$filename == ""} {
	utdmsg errmsg $routine "No file name specified.\n"
	return ;
      }
      set full_path [file join $template_dir $filename]
      set f [open $full_path "r"]
      if {$f == ""} {
	utdmsg errmsg $routine "Could not open file:$filename\n"
	return ;
      }
      set file_data [read $f]
      close $f

      set master_full [file tail $filename]
      set master [file root $master_full]
      set fname [file join $output_dir ${master}.${userid}.c]
      utdmsg imsg $routine "Creating file:$fname\n"
      set fout [open $fname "w"]
      if {$fout == ""} {
	utdmsg errmsg $routine "Could not open file:$fname\n"
	return ;
      }

      utdmsg imsg $routine "Preparing solution code: ${fname}\n"

      set lines [split $file_data "\r\n"]
      set lcount 0
      foreach line $lines {
	set startidx 0
	set outline true
	incr lcount
	set after_options -1
	set line_len [string len $line]
	set end_idx [expr $line_len - 1]
	while {1} {
	  set idx [string first UTDx $line $startidx]
	  if {$idx >= 0} {
	    if {($idx > $after_options) && ($startidx > 0)} {
	      set after_end [expr $idx - 1]
	      if {$debug_flag} {
		puts stderr "string output ($after_options:$after_end):\
		'[string range $line $after_options $after_end]'"
	      }
	      puts -nonewline $fout "[string range $line $after_options $after_end]"
	      set after_options -1
	    }
	    set outline false
	    if {$debug_flag} {
	      utdmsg imsg $routine "found match ($lcount:$idx) : $line\n"
	    }
	    set intro [expr {$idx-1}]
	    puts -nonewline $fout "[string range $line $startidx $intro]"
	    # Now find the index of the opening brace
	    set open_brace_idx [string first "{" $line $idx]
	    set close_brace_idx [string first "}" $line $idx]
	    if {($open_brace_idx >= 0) && ($close_brace_idx >= 0)} {
	      set after_options [expr {$close_brace_idx + 1}]
	      incr open_brace_idx
	      incr close_brace_idx -1
	      set utd_var [string range $line $open_brace_idx $close_brace_idx]
	      if {$debug_flag} {
		puts stderr "utd_var: $utd_var"
	      }
	      set val [utdtools::db::query_db_cmd $db $table $utd_var $db_idx]
	      # set val [query_db $utd_var $db_idx]
	      if {($utd_var == "Doperation")||($utd_var == "Fibop")} {
		set old_val $val
		if {$old_val == {{an $x^2$ on it}} } {
		  set val "my_x2"
		} elseif {$old_val == {{rounding up using the ceil function}} } {
		  set val "my_ceil"
		} elseif {$old_val == {{a sqrt}} } {
		  set val "my_sqrt"
		} elseif {$old_val == {{an $x^3$ on it}} } {
		  set val "my_x3"
		} elseif {$old_val == {{rounding down using the floor function}} } {
		  set val "my_floor"
		}
	      } elseif {$utd_var == "UTDID"} {
		set val $db_idx
	      }
	      if {$debug_flag} {
		puts stderr "value: $val"
	      }
	      puts -nonewline $fout "$val"
	      set startidx $after_options
	      if {$debug_flag} {
		puts stderr "after_option:$after_options line_len:$line_len"
	      }
	      continue
	    }
	  } elseif {($after_options >= 0) && ($after_options <= $end_idx)} {
	    if {$debug_flag} {
	      puts stderr "string output ($after_options:end)"
	    }
	    puts $fout "[string range $line $after_options end]"
	  }
	  break ;
	}

	if {$outline} {
	  puts $fout "$line"
	}
      }
      close $fout
      return [file tail $fname]
    }

    proc reduce_answer {answer} {
      set idx [string first ANSWER $answer]
      if {$idx > 0} {
	set len [string length "ANSWER:"]
	incr idx $len
	set answer [string range $answer $idx end]
	set answer [string trim $answer]
      }
      return $answer
    }

    proc compile_rerun {userid makefile_name} {

      set make_path "${userid}_${makefile_name}"
      set cmd "make -f $make_path"

      set status 0
      if {[catch {eval exec $cmd} result_msg]} {
	puts stderr "ERROR: $result_msg\n"
	set status 1
      }
      return $status
    }

    proc compile_check {userid makefile_name cfile_name output_name} {
      set status 0
      set make_path "${userid}_${makefile_name}"
      set cfile_path "${userid}_${cfile_name}"

      # Temporarily make a link to real name of c file.
      if {[catch {file link -symbolic $cfile_name $cfile_path} result_msg]} {
	puts stderr "ERROR: $result_msg\n"
	return 1 ;
      }
      set cmd "make -f $make_path"

      if {[catch {eval exec $cmd} result_msg]} {
	if {!([file exists $output_name])} {
	  set status 1
	  puts stderr "ERROR\[compile_check]: after running:$cmd\n$result_msg\n\n"
	}
      }
      return $status
    }

    proc answer_makefile {userid answerdir should_make makefile_name} {
      set make_path [file join $answerdir $makefile_name]

      set cmd "make -f $make_path"

      if {[catch {eval exec $cmd} result_msg]} {
	puts stderr "ERROR: $result_msg\n"
      }

      if {[file exists $should_make]} {
	return 0
      } else {
	return 1
      }

    }
    proc answer_makefile {userid answerdir depth should_make makefile_name user_response} {
      upvar $user_response response
      set make_path [file join $depth $answerdir $makefile_name]

      set cmd "make -f $make_path"

      if {[catch {eval exec $cmd} response]} {
	puts stderr "ERROR: $response\n"
      }

      if {[file exists $should_make]} {
	return 0
      } else {
	return 1
      }

    }


    proc reduced_match {students answer reduced_idx} {
      upvar $reduced_idx reduced_i
      # Take answer and reduce to 1 decimal
      set idx [string first . $answer]
      if {$idx > 0} {
	incr idx
	set new_answer [string range $answer 0 $idx]
	puts stderr "new answer: $new_answer students:$students"
	return [loose_match $students $new_answer $reduced_i]
      }
      return false
    }

    proc reduced_match2 {students answer reduced_idx} {
      upvar $reduced_idx reduced_i
      # Take answer and reduce to integer
      if {[catch {set new_answer [expr int($answer)]} msg]} {
	set new_answer ""
      }
      if {$new_answer == $answer} {
	puts stderr "executing reduced match2 using new_answer $new_answer..."
	return [loose_match $students $new_answer $reduced_i]
      }
      return false
    }

    proc loose_match {students answer new_idx} {
      upvar $new_idx idx
      set idx [string first $answer $students]
      if {$idx < 0} {
	return false
      }
      return true
    }

    # This version allows loose matching
    proc file_answer {file_name answer student_response raw_answer match_num} {

      upvar $student_response their_answer
      upvar $raw_answer raw
      upvar $match_num match_id
      global errorG
      global outputG
      global statusG
      set cmd "./${file_name}"

      set raw ""
      set match_id -1
      set their_answer ""
      if {!([file exists $file_name])} {
	set their_answer ""
	set raw ""
	return 1
      }
      set pgm_timeout 30000
      set cancel_id [after $pgm_timeout {set statusG timeout}]
      if {[catch {eval bgexec statusG -output outputG -error errorG $cmd} msg]} {
	puts stderr "we got the following msg running $cmd:\n$msg\n"
	# return 1
      } else {
	after cancel $cancel_id
      }

      set outputG [string trimleft $outputG]
      set errorG [string trimleft $errorG]
      if {($outputG == "$answer") || ($errorG == "$answer")} {
	set their_answer $answer
	set raw $answer
	set match_id 1
	return 0
      }
      set alt_answer ${answer}0000
      if {($outputG == "$alt_answer") || ($errorG == "$alt_answer")} {
	set their_answer $answer
	set raw $answer
	set match_id 2
	return 0
      }
      if {$outputG != ""} {
	set match [loose_match $outputG $answer idx]
	if {($match)} {
	  set raw $outputG
	  set match_id 3
	  set their_answer [string range $outputG $idx end]
	  return 0 ; # a loose match didn't follow directions
	}
	set match [loose_match $outputG $alt_answer idx]
	if {($match)} {
	  set raw $outputG
	  set match_id 4
	  set their_answer [string range $outputG $idx end]
	  return 0 ; # a loose match didn't follow directions
	}
      }
      if {$errorG != ""} {
	set match [loose_match $errorG $answer idx]
	if {($match)} {
	  set raw $errorG
	  set match_id 5
	  set their_answer [string range $errorG $idx end]
	  return 0 ; # a loose match didn't follow directions
	}
	set match [loose_match $errorG $alt_answer idx]
	if {($match)} {
	  set raw $errorG
	  set match_id 6
	  set their_answer [string range $errorG $idx end]
	  return 0 ; # a loose match didn't follow directions
	}
      }
      if {$outputG != ""} {
	set match [reduced_match $outputG $answer idx]
	if {($match)} {
	  set raw $outputG
	  set match_id 7
	  set their_answer [string range $outputG $idx end]
	  return 3 ; # a reduced precision match
	}
      }
      if {$errorG != ""} {
	set match [reduced_match $errorG $answer idx]
	if {($match)} {
	  set raw $errorG
	  set match_id 8
	  set their_answer [string range $errorG $idx end]
	  return 3 ; # a reduced precision match 
	}
      }
      if {$outputG != ""} {
	set match [reduced_match2 $outputG $answer idx]
	if {($match)} {
	  set raw $outputG
	  set match_id 9
	  set their_answer [string range $outputG $idx end]
	  return 4 ; # a reduced precision match
	}
      }
      if {$errorG != ""} {
	set match [reduced_match2 $errorG $answer idx]
	if {($match)} {
	  set raw $errorG
	  set match_id 10
	  set their_answer [string range $errorG $idx end]
	  return 4 ; # a reduced precision match 
	}
      }
      set outlen [string length $outputG]
      set errlen [string length $errorG]
      if {$outlen > 0} {
	set their_answer $outputG
	set raw $outputG
      } else {
	set raw $errorG
	set their_answer $errorG
      }
      puts stderr "We got stdout:$outputG len:$outlen"
      puts stderr "       stderr:$errorG len:$errlen\n"
      return 1

    }

   
    proc explain {status_code} {
      if {$status_code == "0"} {
	return "yes"
      } elseif {$status_code == "1"} {
	return "no"
      } elseif {$status_code == "2"} {
	return "yes but not exactly"
      } elseif {$status_code == "-1"} {
	return "not applicable"
      } else {
	return "no"
      }
    }

  }
}
