#
# $Id: update_student_pwds.tcl,v 1.2 2023/10/02 18:51:52 billswartz7 Exp $
# $Log: update_student_pwds.tcl,v $
# Revision 1.2  2023/10/02 18:51:52  billswartz7
# Code to update a database.
#
# Revision 1.1  2023/10/02 15:34:18  billswartz7
# Initial revision
#
# Revision 1.1  2023/09/29 21:25:11  billswartz7
# Initial revision
#
#

namespace eval utd {

  proc open_db {filename db_cmd} {
    global env
    global argv
    set routine "::utd::open_db"
    if {[info exists env(ICDIR)]} {
      set icdir $env(ICDIR)
    } else {
      puts stderr "ERROR:cannot get iTools environment variable:ICDIR"
      exit 1
    }
    package require sqlite3
    puts stderr "opening sqlite3 database $filename..."
    set status [sqlite3 $db_cmd $filename]
    if {$status == ""} {
      return $db_cmd
    } else {
      puts stderr "status:$status"
    }
    return ""
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
    set vals [$database eval "SELECT `${field_name}` FROM $table WHERE `Username` == '$user'"]
    return $vals
  }

  proc query_db {db table field idx} {
    set vals [query_db_cmd $db $table $field $idx]
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

  proc get_tables {database} {
    set tableNames [$database eval {SELECT tbl_name FROM sqlite_master}]
    return $tableNames
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

  proc column_name {col_info column_id} {
    set num_cols [num_columns $col_info]
    if {($column_id <= 0) || ($column_id > $num_cols)} {
      return ""
    }
    set idx [expr ($column_id-1) * 6]
    incr idx
    set col_name [lindex $col_info $idx]
    return $col_name
  }

  proc column_type {col_info column} {
    set num_items [llength $col_info]
    for {set item 0} {$item < $num_items} {incr item 5} {
      set col_id [lindex $col_info $item]
      incr item
      set col_name [lindex $col_info $item]
      # puts  "column id:$col_id item:$col_name"
      if {$col_name == $column} {
	incr item
	set col_type [lindex $col_info $item]
	return $col_type
      }
    }
    return text
  }

  proc num_columns {col_info} {
    set num_items [llength $col_info]
    set num_cols [expr $num_items / 6]
    return $num_cols
  }

  proc column_add {database table field type} {
    while {1} {
      if {[catch {set vals [$database eval "ALTER TABLE $table ADD COLUMN $field $type"]} msg]} {
	puts stderr "database busy... waiting..."
	after 1000
	continue
      }
      break
    }
    return $vals
  }

  proc row_add {database table values} {
    while {1} {
      if {[catch {set vals [$database eval "INSERT INTO $table VALUES\(${values}\)"]} msg]} {
	puts stderr "database busy... waiting..."
	puts stderr "msg:$msg\n"
	puts stderr "values:$values\n"
	after 1000
	continue
      }
      break
    }
    return $vals
  }

  proc common_columns {columns1 columns2} {
    set len1 [llength $columns1]
    set len2 [llength $columns2]
    puts stderr "len1:$len1 len2:$len2"
    if {$len2 < $len1} {
      #reverse columns
      set tmp $len2
      set len2 $len1
      set len1 $tmp
      set tmp_cols $columns2
      set columns2 $columns1
      set columns1 $tmp_cols
    }
    puts stderr "$len1: $columns1\n"
    puts stderr "$len2: $columns2\n"
    set common ""
    for {set item 0} {$item < $len1} {incr item 5} {
      set col_id [lindex $columns1 $item]
      incr item
      set col_name [lindex $columns1 $item]

      for {set item2 0} {$item2 < $len2} {incr item2 5} {
	set col_id2 [lindex $columns2 $item2]
	incr item2
	set col_name2 [lindex $columns2 $item2]
	if {$col_name == $col_name2} {
	  puts stderr "common:$col_name"
	  lappend common $col_name
	}
      }
    }
    return $common
  }

  proc backup_file {ddir basename} {
    set backup_char ":"
    set filename [file join $ddir $basename]
    if {[file exists $filename]} {
      for {set i 1} {1} {incr i} {
	set bfname "${basename}${backup_char}${i}"
	set bfilename [file join $ddir $bfname]
	if {!([file exists $bfilename])} {
	  file rename -force -- $filename $bfilename
	  return "$bfilename"
	}
      }
    } 
    return ""
  }


}

global argv
set old_database ""
set new_database ""
set args $argv
# puts stderr "args: $args"
set num_args [llength $args]
set debug_flag false
set input_field {Score}
set output_field {Grade}
set routine section_update
set approximate_flag true

for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debug_flag on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "help" } {
    twmessage imsg null "Usage:\n"
    twmessage imsg null "  update_students <oldSQLdatabase> <newSQLdatabase\n\n\n"
    exit 0
  } elseif {$old_database == ""} {
    set old_database $arg_el
  } elseif {$new_database == ""} {
    set new_database $arg_el
  }
}

if {$debug_flag} {
  puts stderr "args: $args"
}

puts stderr "old_database: $old_database"
puts stderr "new_database: $new_database"

if {$old_database == ""} {
  twmessage imsg null "  ERROR: old database filename was not specified\n"
  twmessage imsg null "  update_database <oldSqliteDB> <newSqliteDB>\n\n"
  exit 0
}

if {$new_database == ""} {
  twmessage imsg null "  ERROR: new CSV filename was not specified\n"
  twmessage imsg null "  update_database <oldSqliteDB> <newSqliteDB>\n\n"
  exit 0
}

if {!([file exists $old_database])} {
  twmessage errmsg $routine "old SQLdatabase filename does not exist: $old_database\n\n"
  exit 1
}

if {!([file exists $new_database])} {
  twmessage errmsg $routine "new SQLdatabase filename does not exist: $new_database\n\n"
  exit 1
}


set old_db [::utd::open_db $old_database db1]
set new_db [::utd::open_db $new_database db2]

set old_tables [::utd::get_tables $old_db]
puts stderr "old tables:$old_tables"
set new_tables [::utd::get_tables $new_db]
puts stderr "new tables:$new_tables"
if {$old_tables != $new_tables} {
  utd::close_db $old_db
  utd::close_db $new_db
  twmessage errmsg $routine "database tables do not match\n" 
  exit 1
}

foreach table $old_tables {
  puts stderr "processing table:$table"
  set old_rows [::utd::num_items $old_db $table]
  puts stderr "db1:$old_db old rows:$old_rows"
  set new_rows [::utd::num_items $new_db $table]
  puts stderr "db2:$new_db new rows:$new_rows"
  set old_columns [::utd::column_info $old_db $table]
  set num_cols [::utd::num_columns $old_columns]
  puts stderr " old columns:$old_columns\n"
  set new_columns [::utd::column_info $new_db $table]
  puts stderr " new columns:$new_columns\n"
  set common_columns [::utd::common_columns $old_columns $new_columns]
  puts stderr "common columns: $common_columns"
  foreach col $common_columns {
    set col_type [::utd::column_type $old_columns $col]
    puts stderr "col:$col type:$col_type"
  }
  # See if we have the same username field in both dbs
  set field Username
  set extra_users ""
  for {set idx 1} {$idx <= $new_rows} {incr idx} {
    set new_user [::utd::query_db $new_db $table $field $idx]
    set old_user [::utd::get_user_field $old_db $table $field $new_user]
    if {$old_user == ""} {
      puts stderr "did not find user:$new_user in old database\n"
      lappend extra_users $new_user
    }
  }

  if {$extra_users != ""} {
    set new_name "${new_database}.updated"
    ::utd::backup_file . $new_name
    catch {file copy -force $old_database $new_name}
    set update_db [::utd::open_db $new_name update_db]
    set new_idx $old_rows
    foreach nuser $extra_users {
      incr new_idx
      set values $new_idx
      for {set c 2} {$c <= $num_cols} {incr c} {
	set oldc_name [::utd::column_name $old_columns $c]
	if {$oldc_name != ""} {
	  set oldc_type [::utd::column_type $old_columns $oldc_name]
	  puts stderr "col name: $oldc_name type:$oldc_type"
	  if {[::utd::column_exists $new_columns $oldc_name]} {
	    set new_info [::utd::get_user_field $new_db $table $oldc_name $nuser]
	  } else {
	    set new_info ""
	  }
	  if {$new_info != ""} {
	    append values ",'${new_info}'"
	  } else {
	    set itype [string tolower $oldc_type]
	    if {$itype == "integer"} {
	      append values ",0"
	    } else {
	      append values ",NULL"
	    }
	  }
	}
      }
      ::utd::row_add $update_db $table $values
    }
    utd::close_db $update_db



  }


}


utd::close_db $old_db
utd::close_db $new_db

exit 0

utd::close_db $db
flush stdout

after 2000 exit
icwait
