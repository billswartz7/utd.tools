#
# $Id: db2xcel.tcl,v 1.1 2021/03/27 14:08:16 bill Exp $
# $Log: db2xcel.tcl,v $
# Revision 1.1  2021/03/27 14:08:16  bill
# Initial revision
#
# Revision 1.1  2017/12/06 05:08:40  bill
# Initial revision
#
#

namespace eval utd {
  variable dbS
  variable dataS 
  variable fieldS 
  variable lookupS 
  variable num_dataS 

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
    global debugG
    if {$debugG} {
      puts stderr "opening sqlite3 database $filename..."
    }
    set status [sqlite3 exam $filename]
    set dbS exam
    return exam
  }

  proc close_db {database} {
    global debugG
    if {$debugG} {
      puts stderr "closing database $database..."
    }
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

  proc user_exists {database table field item} {
    set vals [$database eval "SELECT * FROM $table WHERE `$field` == '$item'"]
    return $vals
  }

  proc get_user_field {database table field_name user} {
    set vals [$database eval "SELECT $field_name FROM $table WHERE `Username` == '$user'"]
    return $vals
  }

  proc column_info {database table} {
    set vals [$database eval "PRAGMA table_info('$table')"]
    return $vals
  }

  proc column_exists {col_info column} {
    set num_items [llength $col_info]
    for {set item 0} {$item < $num_items} {incr item 5} {
      set col_id [lindex $col_info $item]
      incr item
      set col_name [lindex $col_info $item]
      # puts  "column id:$col_id item:$col_name"
      if {$col_name == $column} {
	return true
      }
    }
    return false
  }

  proc column_add {database table field type} {
    set vals [$database eval "ALTER TABLE $table ADD COLUMN $field $type"]
    return $vals
  }

  proc set_user_field_value {database table field user value} {
    set vals [$database eval "UPDATE $table SET `$field` = '$value' WHERE `Username` == '$user'"]
    return $vals
  }

  proc set_field_init_value {database table field value} {
    set vals [$database eval "UPDATE $table SET `$field` = '$value'"]
    return $vals
  }
   
  proc query_db {field idx} {
    variable dbS
    variable tableS
    set vals [query_db_cmd $dbS $tableS $field $idx]
    return $vals
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

  proc chose_fields2 {fields csv_line} {
    variable field2S 

    set len [llength $csv_line]
    foreach defined_field $fields {
      for {set i 0} {$i < $len} {incr i} {
	set f [lindex $csv_line $i]
	set cval [string compare $f $defined_field]
	if {$cval == 0} {
	  set field2S($f) $i
	}
      }
    }
  }


  proc read_csv { filename fields args } {
    variable dataS 
    variable fieldS 
    variable num_dataS 

    package require csv

    set debug_flag 1
    set routine "utd::read_csv"
    icmessage imsg $routine "Welcome to the Spread Sheet Loader\n\n"

    if {$filename == ""} {
      icmessage errmsg $routine "No file name specified.\n"
      return ;
    }
    set f [open $filename "r"]
    if {$f == ""} {
      icmessage errmsg $routine "Could not open file:$filename\n"
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
      puts stderr "first line len:$len parsed_line: $parsed_line"
    }
    chose_fields $fields $parsed_line

    if {$debug_flag} {
      puts stderr "array: [array get fieldS]\n"
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
    puts stderr "Total data items read: $num_dataS\n\n"

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


  proc build_csv { basename fields grade_field_name database_user database_column args } {
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
      icmessage errmsg $routine "Could not open file:$fname\n"
      return ;
    }

    generate_header $fout $fields
    generate_body $fout $fields $grade_field_name $database_user $database_column

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

  proc generate_body {fout fields grade_field_name database_user database_column} {
    variable dbS
    variable dataS 
    variable fieldS 
    variable num_dataS

    puts stderr "entering generating body"
    set found_grade_flag false

    if {[info exists fieldS($database_user)]} {
      set user_idx $fieldS($database_user)
      puts stderr "Field $database_user is index $user_idx\n"
    } else {
      twmessage errmsg generate_body "no $database_user field found\n\n"
      set user_idx 0
    }

    for {set i 1} {$i <= $num_dataS} {incr i} {
      set first_field true
      foreach item $fields {
	if {[info exists fieldS($item)]} {
	  set idx $fieldS($item)
	  if {$item == $grade_field_name} {
	    set this_user $dataS($i,$user_idx)
	    puts stderr "this user: $this_user"
	    set new_val [find_grade $this_user $database_column]
	    if {($new_val != "") && ($new_val != "{}")} {
	      set val $new_val
	    } else {
	      set val ""
	    }
	    set found_grade_flag true
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

}


# wm withdraw .
# define the fields
lappend basic_fields {Last Name}
lappend basic_fields {First Name}
lappend basic_fields {Username}
set fields $basic_fields

global argv
global debugG
set debugG off
set approximate_flag true
set filename ""
set filename2 ""
set args $argv
# These two need to be inputs
set column cache_qscore_val
set column membanks_banks_score_val
set output_field {Grade}
set database_user {Username}
set routine "db2xcel"
set num_args [llength $args]
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debugG on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "help" } {
    icmessage imsg $routine "Usage:\n"
    icmessage imsg null "  db2xcel <SQLDBname> <CSVfilename>\n"
    twmessage imsg null "  optionally: column <database_field> field <csvFieldName>\n\n"
    exit 0
  } elseif {$arg_el == "column" } {
    incr i
    if {$i < $num_args} {
      set column [lindex $args $i]
    } else {
      twmessage imsg $routine "missing argument to column option\n"
      exit 1
    }
  } elseif {$arg_el == "field" } {
    incr i
    if {$i < $num_args} {
      set output_field [lindex $args $i]
    } else {
      twmessage imsg $routine "missing argument to field option\n"
      exit 1
    }
  } elseif {$filename ==""} {
    set filename $arg_el
  } else {
    set filename2 $arg_el
  }
}

puts stderr "column: $column"
puts stderr "output_field: $output_field"
puts stderr "database $filename"
puts stderr "CSV $filename2"

if {$filename == ""} {
  icmessage imsg null "  ERROR: Database filename was not specified\n"
  icmessage imsg null "  db2xcel <SQLDBname> <CSVfilename>\n\n"
  exit 0
}

if {$filename2 == ""} {
  icmessage imsg null "  ERROR: CSV filename was not specified\n"
  icmessage imsg null "  db2xcel <SQLDBname> <CSVfilename>\n\n"
  exit 0
}

if {!([file exists $filename])} {
  twmessage errmsg $routine "Database does not exist\n\n"
  exit 1
}

if {!([file exists $filename2])} {
  twmessage errmsg $routine "CSV filename does not exist\n\n"
  exit 1
}

lappend fields $output_field
set ::utd::dbS [::utd::open_db $filename]
set col_info [::utd::column_info $::utd::dbS exam]

# Make sure column exists
set exists [::utd::column_exists $col_info $column]
if {!($exists)} {
  twmessage errmsg $routine "Column $column does not exist\n\n"
  exit 1
}
twmessage imsg $routine "Column $column exists.  Good!\n\n"

utd::read_csv $filename2 $fields
set failed [utd::check_fields $filename2 $basic_fields]
if {($failed)} {
  twmessage imsg $routine "Could not find basic fields.  Must abort\n"
  exit 1
}

set failed [utd::check_fields $filename2 $fields]
if {($failed) && ($approximate_flag)} {
  # Try approximate output field
  set new_field [utd::check_approximate_field $output_field]
  if {$new_field != ""} {
    set output_field $new_field
    twmessage imsg $routine "Found approximate field: $new_field\n"
    set fields $basic_fields
    lappend fields $output_field
    # This better work now
    set failed [utd::check_fields $filename2 $fields]
    if {$failed} {
      twmessage imsg $routine "Could not find output field: $output_field\n\n"
      exit 1
    }
  } else {
    twmessage imsg $routine "Could not find output field: $output_field\n\n"
    exit 1
  }
}

utd::build_csv ${filename2}.out $fields $output_field $database_user $column
flush stdout

after 2000 exit
icwait
