#
# $Id: dump_fields.tcl,v 1.1 2021/03/27 14:11:06 bill Exp $
# $Log: dump_fields.tcl,v $
# Revision 1.1  2021/03/27 14:11:06  bill
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

  proc simplify_data {string_p} {
    set out_string ""
    set len [string length $string_p]
    for {set idx 0} {$idx < $len} {incr idx} {
      set sub [string range $string_p $idx end]
      # puts stderr "sub:$sub"
      if {[string equal -length 6 $sub "%0D%0A"]} {
	# Implement a crude tab
	append out_string "        "
	incr idx 5
	puts stderr "skip return"
	continue
      }
      set char [string index $string_p $idx]
      if {$char == {%}} {
	set last_idx [expr $idx + 2]
	set ascii_char [string range $string_p $idx $last_idx]
	set ascii_num "0x[string range $ascii_char 1 2]"
	append out_string [format %c $ascii_num]
	incr idx 2
	puts stderr "skip raw ascii character"
	continue
      } elseif {$char == { }} {
	continue ;
      } elseif {$char == "+"} {
	append out_string " "
      } else {
	append out_string $char
      }
    }
    return $out_string
  }

}


global argv
set fields ""
set database ""
set multi_piece_field ""
set args $argv
set basename "report"
set num_args [llength $args]
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  puts stderr "arg($i): $arg_el"
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
    icmessage imsg null "  dump_fields -file <name> <SQLdatabase> <field1> ...\n\n"
    exit 0
  } elseif {$database == ""} {
    set database $arg_el
  } elseif {$multi_piece_field != ""} {
    set lchar [string index $arg_el end]
    if {$lchar == {"}} {
      append multi_piece_field " [string range $arg_el 0 end-1]"
      puts stderr "multi_piece_field end:'$multi_piece_field'"
      lappend fields $multi_piece_field
      set multi_piece_field ""
    } else {
      append multi_piece_field " $arg_el"
    }
  } else {
    set fchar [string index $arg_el 0]
    if {$fchar == {"}} {
      puts stderr "multi_piece_field start"
      set multi_piece_field [string range $arg_el 1 end]
    } else {
      lappend fields $arg_el
    }
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
package require itools_table 1.0
set ntable [ictable create]
foreach field $fields {
  $ntable addfield $field string $field
}
for {set item 1} {$item <= $num_items} {incr item} {
  $ntable newrecord
  foreach field $fields {
    set data [utd::query_db $field $item]
    puts stderr "$field $item: $data"
    set data [utd::simplify_data $data]
    puts stderr "$field $item: $data"
    $ntable data $field $data
  }
}

puts $fout "[$ntable print]"

close $fout

utd::close_db $db
icexit
