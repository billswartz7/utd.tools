#
# $Id: dump_header.tcl,v 1.1 2021/03/27 14:11:33 bill Exp $
# $Log: dump_header.tcl,v $
# Revision 1.1  2021/03/27 14:11:33  bill
# Initial revision
#
# Revision 1.2  2020/12/13 14:01:43  bill
# Updated for FALL 2020 final.
#
# Revision 1.1  2020/12/08 04:33:01  bill
# Initial revision
#
# Revision 1.1  2020/04/06 15:00:17  bill
# Initial revision
#
#

namespace eval utd {
  variable dbS
  variable tableS

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
    sqlite3 exam $filename
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

  proc column_info { } {
    variable dbS
    variable tableS
    set vals [$dbS eval "PRAGMA table_info('$tableS')"]
    return $vals
  }

  proc column_header {col_info column_idx} {
    set num_items [llength $col_info]
    set num_items [expr $num_items / 6]
    # puts stderr "num_items:$num_items"
    if {($column_idx >= 0) && ($column_idx < $num_items)} {
      set column_offset [expr ($column_idx * 6) + 1]
      set col_data [lindex $col_info $column_offset]
      # puts stderr "col_data: $col_data"
      return $col_data
    }
    return ""
  }

}


global argv
set database ""
set args $argv
set basename "header"
set num_args [llength $args]
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debug_flag on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "-file" } {
    incr i
    if {$i < $num_args} {
      set basename [lindex $args $i]
    } else {
      icmessage errmsg dump_counts "Missing argument to -file\n"
      return ;
    }
  } elseif {$arg_el == "help" } {
    icmessage imsg null "Usage:\n"
    icmessage imsg null "  dump_header -file <name> <SQLdatabase>\n\n"
    exit 0
  } else {
    set database $arg_el
  }
}

set table [utd::set_table exam]
set db [utd::open_db $database]
set num_items [utd::num_items $db $table]
puts stderr "num_items: $num_items"

set count 1
while {1} {
  set filename "${basename}.${count}"
  if {!([file exists $filename])} {
    break ;
  }
  incr count
}
set fout [open $filename "w"]
if {$fout == ""} {
  icmessage errmsg $routine "Could not open file:$filename\n"
  return ;
}

set col_info [utd::column_info]
puts stderr "$col_info"
set num_cols [llength $col_info]
set num_cols [expr $num_cols / 6]
puts stderr "num_cols $num_cols"
for {set col 0} {$col < $num_cols} {incr col} {
  set col_name [utd::column_header $col_info $col]
  if {$col_name != ""} {
    set idx [string first " " $col_name]
    if {$idx < 0} {
      puts $fout "$col_name"
    } else {
      puts $fout "\\\"$col_name\\\""
    }
  }
}

close $fout

utd::close_db $db
icexit
