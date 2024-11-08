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
set quizdirG [pwd]
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debugG on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "password" } {
    set passwordG true
    puts stdout "password mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "restart" } {
    puts stdout "debug mode enabled.\n"
    flush stdout
    after 25000
  } elseif {$arg_el == "port" } {
    incr i
    if {$i < $num_args} {
      set portG [lindex $args $i]
    } else {
      utdmsg imsg quiztool "missing argument to port option\n"
      exit 1
    }
    flush stdout
  } elseif {$arg_el == "maxtries" } {
    incr i
    if {$i < $num_args} {
      set max_triesG [lindex $args $i]
      puts stderr "maxtries set to $max_triesG"
    } else {
      utdmsg imsg quiztool "missing argument to maxtries option\n"
      exit 1
    }
    flush stdout
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  quiztool <quiz.html> <student_database> \[debug\] \[password\] \[port <integer>\] \[maxtries integer\]\n"
    exit 0
  } else {
    set databaseG $arg_el
  }
}

if {$debugG} {
  puts stderr "args:$args"
}

if {!([file exists $databaseG])} {
  utdmsg errmsg cadence "Database does not exist\n\n"
  exit 1
}

set db [::utdtools::db::open_db $databaseG exam -nocreate]
if {$db == ""} {
  exit 1
}
set num_items [::utdtools::db::num_items $db exam]
puts stderr "num_items:$num_items"

for {set item 1} {$item <= $num_items} {incr item} {

  set userid [::utdtools::db::query_db $db exam Username $item]
  puts stderr "user:$userid"
}

set sql "ALTER TABLE exam RENAME TO students"
set val [::utdtools::db::exec_sql_command $db $sql]
puts stderr "val:$val"
exit 0
