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
set column "cadence_reply"
set defaultval ""
set type TEXT
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  # puts stderr "arg_el:$arg_el"
  if {$arg_el == "debug" } {
    set debugG on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  calc_expired <student_database>\n"
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

set table students

set db [::utdtools::db::open_db $databaseG $table -nocreate]
if {$db == ""} {
  exit 1
}

set col_info [::utdtools::db::column_info $db $table]

set exists [::utdtools::db::column_exists $col_info $column]
if {!($exists)} {
  utdmsg errmsg cadence "Column $column does not exist in database:$databaseG\n\n"
  exit 1
}

set num_items [::utdtools::db::num_items $db $table]
for {set item 1} {$item <= $num_items} {incr item} {
  set username [::utdtools::db::query_db $db $table "Username" $item]
  set expired [::utdtools::db::query_db $db $table "expires" $item]
  if {($expired == "") || ($expired == "{}")} {
    set cadence_replied [::utdtools::db::query_db $db $table $column $item]
    if {($cadence_replied == "") || ($cadence_replied == "{}")} {
      puts stderr "no cadence replied for item:$item\n" 
    } else {
      puts stderr "cadence replied on $cadence_replied" 
      set expires [expr $cadence_replied + 365 * 24 * 3600]
      puts stderr "cadence expires on $expires\n" 
      set val [::utdtools::db::set_user_field_value $db $table "expires" Index $item $expires]
    }
  } else {
    puts stderr "User $username ($item) expires in $expired [clock format $expired]" 
  }
}

exit 0

