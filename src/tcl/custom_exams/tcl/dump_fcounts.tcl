#
# $Id: dump_fcounts.tcl,v 1.2 2020/12/13 14:01:43 bill Exp $
# $Log: dump_fcounts.tcl,v $
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

  proc build_hash_lookup {htable fout db_idx} {
    set netid [query_db Username $db_idx]
    set count [query_db Count $db_idx]
    set count2 [query_db Count2 $db_idx]
    set count3 [query_db Count3 $db_idx]
    set count4 [query_db Count4 $db_idx]
    set count5 [query_db Count5 $db_idx]
    puts $fout "  adc_add_count_data( ${htable}, \"${netid}\", $count ) ;"
    puts $fout "  adc_add_count_data( ${htable}, \"${netid}\", $count2 ) ;"
    puts $fout "  adc_add_count_data( ${htable}, \"${netid}\", $count3 ) ;"
    puts $fout "  adc_add_count_data( ${htable}, \"${netid}\", $count4 ) ;"
    puts $fout "  adc_add_count_data( ${htable}, \"${netid}\", $count5 ) ;"
    puts $fout "  adc_add_count_data( ${htable}, \"${netid}\", -1 ) ;"
  }

}


global argv
set database ""
set args $argv
set filename "final.c"
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
      set filename [lindex $args $i]
    } else {
      icmessage errmsg dump_counts "Missing argument to -file\n"
      return ;
    }
  } elseif {$arg_el == "help" } {
    icmessage imsg null "Usage:\n"
    icmessage imsg null "  dump_counts -file <name> <SQLdatabase>\n\n"
    exit 0
  } else {
    set database $arg_el
  }
}

set table [utd::set_table exam]
set db [utd::open_db $database]
set num_items [utd::num_items $db $table]
puts stderr "num_items: $num_items"

set fout [open $filename "w"]
if {$fout == ""} {
  icmessage errmsg $routine "Could not open file:$filename\n"
  return ;
}

for {set item 1} {$item <= $num_items} {incr item} {
  utd::build_hash_lookup htable $fout $item
}
close $fout

utd::close_db $db
icexit
