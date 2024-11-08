#
# $Id: section_update.tcl,v 1.2 2021/07/20 19:54:31 bill Exp $
# $Log: section_update.tcl,v $
# Revision 1.2  2021/07/20 19:54:31  bill
# Modified code to work with UTDTOOLS.
#
# Revision 1.1  2021/07/13 19:13:33  bill
# Initial revision
#
#

namespace eval utd {
  variable dbS
  variable dataS
  variable tableS
  variable grade_tallyS

  proc open_db {filename} {
    global env
    global argv
    variable dbS
    set routine "::utd::open_db"
    if {[info exists env(ICDIR)]} {
      set icdir $env(ICDIR)
    } else {
      puts stderr "ERROR:cannot get iTools environment variable:ICDIR"
      exit 1
    }
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

  proc get_user_field {database table field_name user} {
    set vals [$database eval "SELECT $field_name FROM $table WHERE `Username` == '$user'"]
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
	utdmsg errmsg $routine \
	  "An error occurred copying $fname.\n$result_msg\n\n"
      }
    }
  }

  proc build_csv { basename fields grade_field_name input_field db } {
    set routine build_csv
    set count 1
    puts stderr "Entered CSV:$basename\n"
    while {1} {
      set fname "${basename}.${count}.csv"
      if {!([file exists $fname])} {
	break ;
      }
      incr count
    }
    puts stderr "Creating file:$fname\n"
    set fout [open $fname "w"]
    if {$fout == ""} {
      utdmsg errmsg $routine "Could not open file:$fname\n"
      return ;
    }

    generate_header $fout $fields
    generate_body $fout $fields $grade_field_name $input_field $db

    close $fout
    return $fname
  }

  proc generate_header {fout fields} {
    set first_field true
    foreach field $fields {
      if {!($first_field)} {
	puts -nonewline $fout ","
      }
      puts -nonewline $fout "\"$field\""
      set first_field false
    }
    puts $fout ""
  }

  proc generate_body {fout fields grade_field_name input_field db} {
    variable dbS
    variable dataS 
    variable fieldS 
    variable num_dataS

    puts stderr "entering generating body"
    set found_grade_flag false
    for {set i 1} {$i <= $num_dataS} {incr i} {
      set first_field true
      set userid ""
      foreach item $fields {
	if {[info exists fieldS($item)]} {
	  set idx $fieldS($item)
	  if {$item == "Username"} {
	    set val $dataS($i,$idx)
	    set userid $val
	  } elseif {$item == $grade_field_name} {
	    if {$userid == ""} {
	      utdmsg errmsg generate_body "userid is NULL\n"
	      continue
	    }
	    set val [utd::get_user_field $db exam $input_field $userid]
	    puts stderr "userid:$userid val:$val"
	    if {$val == "{}"} {
	      set val 0
	    }
	    set found_grade_flag true
	    keep_grade_tally $val
	  } else {
	    set val $dataS($i,$idx)
	  }
	  if {!($first_field)} {
	    puts -nonewline $fout ","
	  }
	  puts -nonewline $fout "\"$val\""
	  set first_field false
	}
      }
      puts $fout ""
    }
    if {!($found_grade_flag)} {
      puts stderr "ERROR: never found $grade_field_name field.  Check input CSV\n" 
    }
  }

  proc find_grade {netid grade_field_name} {
    variable dbS
    set user_grade [get_user_field $dbS exam $grade_field_name $netid]
    return $user_grade
  }

  proc read_csv { filename fields args } {
    variable dataS 
    variable itemS 
    variable fieldS 
    variable num_dataS 

    package require csv

    set debug_flag 0
    set routine "utd::read_csv"
    utdmsg imsg $routine "Welcome to the Section Update program\n\n"

    if {$filename == ""} {
      utdmsg errmsg $routine "No file name specified.\n"
      return ;
    }
    set f [open $filename "r"]
    if {$f == ""} {
      utdmsg errmsg $routine "Could not open file:$filename\n"
      exit 1 ;
    }
    set file_data [read $f]
    close $f
    set rootname [file rootname $filename]


    # Break data into lines
    set lines [split $file_data "\r\n"]
    if {$debug_flag} {
      set cnt 0
      foreach line $lines {
	incr cnt
	puts stderr "line($cnt): $line"
      }
    }

    # variables to control parsing
    set first_line [lindex $lines 0]
    set parsed_line [::csv::split $first_line]
    set len [llength $parsed_line]
    if {$debug_flag} {
      puts "first line len:$len parsed_line: $parsed_line"
    }
    chose_fields $fields $parsed_line

    if {$debug_flag} {
      puts stderr "array: [array get fieldS]"
    }

    # Now process the file
    set lcount 0
    set num_dataS 0
    set items [array names fieldS]
    foreach line $lines {
      incr lcount
      if {$lcount == 1} {
	continue  ;
      }
      set parsed_line [::csv::split $line]
      if {$parsed_line != ""} {
	incr num_dataS
	foreach item $items {
	  set idx $fieldS($item)
	  set dataS($num_dataS,$idx)  [lindex $parsed_line $idx]
	}
      }
    }
    utdmsg imsg null "Total data items read: $num_dataS\n"

  }

  proc check_fields { file_name fields args } {
    variable fieldS 

    set fail_flag false
    foreach item $fields {
      if {!([info exists fieldS($item)])} {
	set fail_flag true
	puts stderr "ERROR: Could not find field:\"$item\" in CSV: $file_name\n"
	flush stderr 
      }
    }
    return $fail_flag
  }

  proc check_approximate_field { output_field args } {
    variable fieldS 
    set field_names [array names fieldS]
    foreach item $field_names {
      if {([string compare -nocase -length 7 $output_field $item] == 0)} {
	return $item
      }
    }
    # Look for first space in item and make search that length
    foreach item $field_names {
      set sidx [string first " " $item]
      if {$sidx > 2} {
	if {([string compare -nocase -length $sidx $output_field $item] == 0)} {
	  return $item
	}
      }
    }

    return ""
  }

  proc chose_fields {fields csv_line} {
    variable fieldS 

    set len [llength $csv_line]
    foreach defined_field $fields {
      for {set i 0} {$i < $len} {incr i} {
	set f [lindex $csv_line $i]
	set fieldS($f) $i
	# set cval [string compare $f $defined_field]
	# if {$cval == 0} {
	#   set fieldS($f) $i
        # 	}
      }
    }
  }

  proc keep_grade_tally { grade } {
    variable grade_tallyS

    if {[info exists grade_tallyS($grade)]} {
      set num $grade_tallyS($grade)
      incr num
      set grade_tallyS($grade) $num
    } else {
      set grade_tallyS($grade) 1
    }
  }

  proc dump_grade_tally { } {
    variable grade_tallyS

    if {[info exists grade_tallyS]} {
      utdmsg imsg dump_grade_tally "Grade tally\n"
      set grade_types [array names grade_tallyS]
      set grade_types [lsort $grade_types]
      utdmsg imsg null "grades: $grade_types\n"
      set total 0
      foreach grade $grade_types {
	set num_achieved $grade_tallyS($grade)
	utdmsg imsg null "$grade $num_achieved\n"
	incr total $num_achieved
      }
      utdmsg imsg null "total: $total\n"
    } else {
      utdmsg imsg dump_grade_tally "No grade tally exists\n"
    }
  }

}

# Define basic fields
lappend basic_fields {Last Name}
lappend basic_fields {First Name}
lappend basic_fields {Username}
set fields $basic_fields

global argv
set args $argv
set args [utdscript_args]

set database ""
set csv_file ""
# puts stderr "args: $args"
set num_args [llength $args]
set debug_flag false
set input_field {Grade}
set output_field {Grade}
set routine section_update
set approximate_flag true

for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debug_flag on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "input" } {
    incr i
    if {$i < $num_args} {
      set input_field [lindex $args $i]
    } else {
      utdmsg imsg $routine "missing argument to input field option\n"
      exit 1
    }
  } elseif {$arg_el == "output" } {
    incr i
    if {$i < $num_args} {
      set output_field [lindex $args $i]
    } else {
      utdmsg imsg $routine "missing argument to output field option\n"
      exit 1
    }
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  section_update <CSV_file> <SQLdatabase> \[input <input_field>] \[output <output_field>]\n\n\n"
    exit 0
  } elseif {$csv_file == ""} {
    set csv_file $arg_el
  } elseif {$database == ""} {
    set database $arg_el
  }
}

if {$debug_flag} {
  puts stderr "args: $args"
}

puts stderr "CSV $csv_file"
puts stderr "database $database"
puts stderr "input_field: $output_field"
puts stderr "output_field: $output_field"

if {$csv_file == ""} {
  utdmsg imsg null "  ERROR: CSV filename was not specified\n"
  utdmsg imsg null "  section_update <CSVfilename> <SqliteDB>\n\n"
  exit 0
}

if {$database == ""} {
  utdmsg imsg null "  ERROR: Database was not specified\n"
  utdmsg imsg null "  section_update <CSVfilename> <SqliteDB>\n\n"
  exit 0
}


if {!([file exists $csv_file])} {
  utdmsg errmsg $routine "CSV filename does not exist: $csv_file\n\n"
  exit 1
}

if {!([file exists $database])} {
  utdmsg errmsg $routine "Database does not exist: $database\n\n"
  exit 1
}


lappend fields $output_field

utd::read_csv $csv_file $fields
set failed [utd::check_fields $csv_file $basic_fields]
if {($failed)} {
  utdmsg imsg $routine "Could not find basic fields.  Must abort\n"
  exit 1
}

set failed [utd::check_fields $csv_file $fields]
if {($failed) && ($approximate_flag)} {
  # Try approximate output field
  set new_field [utd::check_approximate_field $output_field]
  if {$new_field != ""} {
    set output_field $new_field
    utdmsg imsg $routine "Found approximate field: $new_field\n"
    set fields $basic_fields
    lappend fields $output_field
    # This better work now
    set failed [utd::check_fields $csv_file $fields]
    if {$failed} {
      utdmsg imsg $routine "Could not find output field: $output_field\n\n"
      exit 1
    }
  } else {
    utdmsg imsg $routine "Could not find output field: $output_field\n\n"
    exit 1
  }
}

set db [utd::open_db $database]
utd::build_csv ${csv_file}.out $fields $output_field $input_field $db
utd::close_db $db
utd::dump_grade_tally
flush stdout

after 2000 exit
utdwait
