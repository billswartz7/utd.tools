#
# $Id: build_exams.tcl,v 1.3 2021/05/05 02:43:49 bill Exp bill $
# $Log: build_exams.tcl,v $
# Revision 1.3  2021/05/05 02:43:49  bill
# Make sure to remove leading and trailing {}.  Added more
# debug.
#
# Revision 1.2  2020/05/02 18:57:28  bill
# Added debug and ability to stop the cleanup of generated
# files for debugging purposes.
#
# Revision 1.1  2020/04/06 14:58:22  bill
# Initial revision
#
#

namespace eval utd {
  variable dbS
  variable tableS

  proc open_db {filename} {
    global env
    global argv
    global autopath
    variable dbS
    set routine "::utd::open_db"
    utdtools::env_check true
    package require sqlite3
    puts stderr "opening sqlite3 database $filename..."
    set status [sqlite3 exam $filename]
    set dbS exam
    return exam
  }

  proc close_db {database} {
    puts stderr "closing database $database..."
    $database close
  }

  proc query_db_cmd {database table field idx} {
    set vals [$database eval "SELECT `$field` FROM $table WHERE `Index` == '$idx'"]
    return $vals
  }

  proc num_items {database table_name} {
    set vals [$database eval "SELECT COUNT(*) FROM $table_name"]
    return $vals
  }

  proc query_db {field idx} {
    variable dbS
    variable tableS
    set vals [query_db_cmd $dbS $tableS $field $idx]
    return $vals
  }

  proc basename {full_filename} {
    set idx [string first . $full_filename 0]
    if {$idx >= 0} {
      incr idx -1
      set full_filename [string range $full_filename 0 $idx]
    } 
    return $full_filename
  }

  proc set_table {table_name} {
    variable tableS
    set tableS $table_name
    return $table_name
  }

  proc copy_exam_data {test_dir exam_dir} {
    set routine "copy_exam_data"
    foreach fname [glob -nocomplain -directory $test_dir *] {
      set fext [file extension $fname]
      if {$fext == ".aux"} {
	continue ;
      } elseif {$fext == ".out"} {
	continue ;
      } elseif {$fext == ".log"} {
	continue ;
      } elseif {$fext == ".tex"} {
	continue ;
      } elseif {$fext == ".gz"} {
	set idx [string last ".synctex.gz" $fname]
	if {$idx > 0} {
	  continue ;
	}
      }
      puts stderr "file copy -force -- $fname $exam_dir..."
      if {[catch {file copy -force -- $fname $exam_dir} result_msg]} {
	icmessage errmsg $routine \
	  "An error occurred copying $fname.\n$result_msg\n\n"
      }
    }
  }

  proc read_latex { filename exam_dir userid db_idx args } {
    variable questionS

    set routine "utd::read_latex"
    if {$filename == ""} {
      icmessage errmsg $routine "No file name specified.\n"
      return ;
    }
    set f [open $filename "r"]
    if {$f == ""} {
      icmessage errmsg $routine "Could not open file:$filename\n"
      return ;
    }
    set file_data [read $f]
    close $f

    set master_full [file tail $filename]
    set master [file root $master_full]
    set fname [file join $exam_dir ${master}.${userid}.tex]
    icmessage imsg $routine "Creating file:$fname\n"
    set fout [open $fname "w"]
    if {$fout == ""} {
      icmessage errmsg $routine "Could not open file:$fname\n"
      return ;
    }

    icmessage imsg $routine "Preparing exam: $userid\n"
    set debug_flag true

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
	    icmessage imsg $routine "found match ($lcount:$idx) : $line\n"
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
	    set val [query_db $utd_var $db_idx]
	    set fchar [string index $val 0]
	    if {$fchar == "\{" } {
	      set val [string range $val 1 end-1]
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
    if {$debug_flag} {
      puts stderr "closing file:$fname"
    }
    return $fname
  }

  proc convert_to_pdf {tex_bin_dir exam_dir tex_file debug cleanup_files} {
    set routine "convert_to_pdf"
    if {$debug} {
      puts stderr "bin:$tex_bin_dir"
      puts stderr "tex:$tex_file"
    }
    # pdflatex --file-line-error --synctex=1 --shell-escape
    set program pdflatex
    set pgm [file join $tex_bin_dir $program]

    # set basename [file rootname $filename]
    # set outname "${basename}.pdf"
    set input_file [file tail $tex_file]

    cd $exam_dir
    set cmd "$pgm --file-line-error --synctex=1 --shell-escape $input_file"
    if {$debug} {
      puts stderr "command: $cmd\n"
    }

    for {set tries 1} {$tries <= 2} {incr tries} {
      if {[catch {eval exec $cmd} result_msg]} {
	icmessage errmsg $routine "An error occurred converting $input_file.\n\
Make sure base exam builds properly.\n\n"
	icmessage errmsg $routine " problem message :\n$result_msg\n\n"
	exit 1
      } 
    }
    # Remove conversion files 
    if {$cleanup_files} {
      foreach f [glob -nocomplain *.aux *.log *.out *.gz] {
	file delete -force -- $f
      }
    }
    cd ..
  }

}


global argv
set database ""
set args $argv
set args [utdscript_args]
# puts stderr "args: $args"
set num_args [llength $args]
set debug_flag false
set single_item false
set cleanup_files true
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debug_flag on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "-single" } {
    set single_item true
  } elseif {$arg_el == "-nocleanup" } {
    set cleanup_files false
  } elseif {$arg_el == "help" } {
    icmessage imsg null "Usage:\n"
    icmessage imsg null "  build_exams \[-single] \[-nocleanup] <SQLdatabase>\n"
    icmessage imsg null "  build_exams \[help]\n\n"
    exit 0
  } else {
    set database $arg_el
  }
}

if {$debug_flag} {
  puts stderr "args: $args"
}

set tex_bin_dir /usr/local/texlive/2015/bin/x86_64-darwin/
set table [utd::set_table exam]
set db [utd::open_db $database]
set num_items [utd::num_items $db $table]
if {$single_item} {
  puts stderr "single test processing mode...\n"
  set num_items 1
}
puts stderr "num_items: $num_items"

set basename [utd::basename $database]
set tex_base_name "${basename}.tex"
set tex_name [file join [pwd] base_test $tex_base_name]
puts stderr "texname : $tex_name"
set exam_dir exams

file mkdir $exam_dir
utd::copy_exam_data base_test $exam_dir

for {set item 1} {$item <= $num_items} {incr item} {
  set userid [utd::query_db Username $item]
  puts stderr "userid: $userid"
  set user_tex [utd::read_latex $tex_name $exam_dir $userid $item]
  utd::convert_to_pdf $tex_bin_dir $exam_dir $user_tex $debug_flag $cleanup_files
}

utd::close_db $db
icexit
