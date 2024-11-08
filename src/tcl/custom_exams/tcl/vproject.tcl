#
# $Id: build_exams.tcl,v 1.3 2021/05/05 02:43:49 bill Exp $
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

}


global argv
set database ""
set args $argv
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
    icmessage imsg null "  vproject \[-single] \[-nocleanup] <SQLdatabase>\n"
    icmessage imsg null "  vproject \[help]\n\n"
    exit 0
  } else {
    set database $arg_el
  }
}

if {$debug_flag} {
  puts stderr "args: $args"
}

set table [utd::set_table exam]
set db [utd::open_db $database]
set num_items [utd::num_items $db $table]
if {$single_item} {
  puts stderr "single test processing mode...\n"
  set num_items 1
}
puts stderr "num_items: $num_items"

set basename [utd::basename $database]

for {set item 1} {$item <= $num_items} {incr item} {
  set userid [utd::query_db Username $item]
  puts stderr "userid: $userid"
  set files [glob -nocomplain *${userid}* ]
  if {$files != ""} {
    file mkdir $userid
    puts stderr "f:$files"
    foreach f $files {
      file rename -force $f $userid
    }
  }
}

utd::close_db $db
icexit
