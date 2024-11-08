
namespace eval utdtools {
  namespace eval db {

    proc open_db {filename db_name args} {
      global env
      global argv
      set routine "::utd::open_db"
      ::utdtools::env_check true
      package require sqlite3
      set num_args [llength $args]
      set create_flag true
      for {set i 0} {$i < $num_args} {incr i} {
	set arg_el [lindex $args $i]
	if {$arg_el == "-nocreate" } {
	  set create_flag false
	}
      }
      puts stderr "opening sqlite3 database $filename..."
      if {[catch {set status [sqlite3 $db_name $filename -create $create_flag]} msg]} {
	return ""
      }
      return $db_name
    }

    proc add_header {fout fname} {
      set f [open $fname "r"]
      if {$f == ""} {
	utdmsg errmsg $routine "Could not open file:$fname\n"
	return ;
      }
      set file_data [read $f]
      close $f
      set lines [split $file_data "\r\n"]
      puts $fout [lindex $lines 0]
    }

    proc close_db {database} {
      puts stderr "closing database $database..."
      $database close
    }

    proc user_exists {database table field item} {
      set vals [$database eval "SELECT * FROM $table WHERE `$field` == '$item'"]
      return $vals
    }

    proc get_index_field {database table field_name itemval} {
      set vals [$database eval "SELECT $field_name FROM $table WHERE `Index` == '$itemval'"]
      return $vals
    }

    proc get_field_data {database table data_field_name search_field itemval} {
      set vals [$database eval "SELECT $data_field_name FROM $table WHERE `$search_field` == '$itemval'"]
      return $vals
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

    proc exec_sql_command { database sql } {
      set vals [$database eval $sql]
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


    proc column_add_with_default {database table field type default_val} {
      while {1} {
	if {[catch {set vals [$database eval "ALTER TABLE $table ADD COLUMN $field $type DEFAULT $default_val"]} msg]} {
	  puts stderr "database busy... waiting..."
	  puts stderr "message:$msg..."
	  after 1000
	  continue
	}
	break
      }
      return $vals
    }

    proc create_table {database table field type} {
      if {[catch {set vals [$database eval "CREATE TABLE IF NOT EXISTS $table ( $field $type )"]} msg]} {
	puts stderr "message:$msg..."
      }
      return $vals
    }

    proc create_table_with_default {database table field type default_val} {
      if {[catch {set vals [$database eval "CREATE TABLE IF NOT EXISTS $table ( $field $type DEFAULT $default_val )"]} msg]} {
	puts stderr "message:$msg..."
      }
      return $vals
    }


    proc set_user_field_value {database table field user_field user value} {
      while {1} {
	if {[catch {set vals [$database eval "UPDATE $table SET `$field` = '$value' WHERE `$user_field` == '$user'"]} msg]} {
	  puts stderr "set_user_field_value:database busy... waiting..."
	  puts stderr "message:$msg..."
	  puts stderr "field:$field..."
	  puts stderr "user_field:$user_field..."
	  puts stderr "user:$user..."
	  after 1000
	  continue
	}
	break
      }
      return $vals
    }

    proc set_field_init_value {database table field value} {
      while {1} {
	if {[catch {set vals [$database eval "UPDATE $table SET `$field` = '$value'"]} msg]} {
	  puts stderr "database busy... waiting..."
	  after 1000
	  continue
	}
	break
      }
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

  }
}
