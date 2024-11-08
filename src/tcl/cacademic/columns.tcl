# $Log: requested.tcl,v $
# Revision 1.1  2024/09/12 16:53:28  wps100020
# Initial revision
#
package require uri
package require base64
package require html
set eversion [package require Expect]
puts stderr "eversion:$eversion"
package require sqlite3



global argv
global databaseG
global debugG
set databaseG ""
set debugG false
set args $argv
set args [utdscript_args]
set num_args [llength $args]
puts stderr "my_args: $args"
set column ""
set defaultval ""
set type TEXT
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  # puts stderr "arg_el:$arg_el"
  if {$arg_el == "debug" } {
    set debugG on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {($arg_el == "column") || ($arg_el == "-column")} {
    incr i
    if {$i < $num_args} {
      set column [lindex $args $i]
      puts stderr "column set to $type"
    } else {
      utdmsg imsg column "missing argument to column option\n"
      exit 1
    }
    flush stdout
  } elseif {($arg_el == "type") || ($arg_el == "-type")} {
    incr i
    if {$i < $num_args} {
      set type [lindex $args $i]
      puts stderr "type set to $type"
    } else {
      utdmsg imsg column "missing argument to type option\n"
      exit 1
    }
    flush stdout
  } elseif {($arg_el == "default") || ($arg_el == "-default")} {
    incr i
    if {$i < $num_args} {
      set defaultval [lindex $args $i]
      puts stderr "default set to $defaultval"
    } else {
      utdmsg imsg column "missing argument to type option\n"
      exit 1
    }
    flush stdout
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  column <student_database> column <column> type <type>\n"
    exit 0
  } else {
    set databaseG $arg_el
    puts stderr "database:$databaseG"
  }
}

if {$debugG} {
  puts stderr "args:$args"
}

if {!([file exists $databaseG])} {
  utdmsg errmsg cadence "Database does not exist\n\n"
  exit 1
}

set db [::utdtools::db::open_db $databaseG students -nocreate]
if {$db == ""} {
  exit 1
}

if {$column == ""} {
  utdmsg errmsg cadence "Column not set\n\n"
  exit 1
}

set col_info [::utdtools::db::column_info $db students]

set exists [::utdtools::db::column_exists $col_info $column]
if {$exists} {
  puts stderr "column already exists!\n"
} else {
  if {$defaultval != ""} {
    puts stderr "::utdtools::db::column_add_with_default $db students $column $type $defaultval"
    ::utdtools::db::column_add_with_default $db students $column $type $defaultval
  } else {
    puts stderr "::utdtools::db::column_add $db students c:$column t:$type"
    ::utdtools::db::column_add $db students $column $type
  }
}
exit 0

