# $Log: login.tcl,v $
# Revision 1.4  2021/05/08 04:41:24  bill
# Now we repeat writing to the database if the database is busy.
#
# Revision 1.3  2020/05/04 22:57:51  bill
# Fixed typo with put when trying to perform a catch.
#
# Revision 1.2  2020/05/04 17:57:28  bill
# Now we try multiple times to access the database.   Try until we can make it.
#
# Revision 1.1  2020/05/03 20:16:42  bill
# Initial revision
#
#
package require uri
package require base64
package require html
package require Expect
package require sqlite3

namespace eval utdcache {

  proc open_db {filename} {
    global env
    global argv
    variable dbS
    variable optionS
    set routine "::utdcache::open_db"
    if {[info exists env(ICDIR)]} {
      set icdir $env(ICDIR)
    } else {
      puts stderr "ERROR:cannot get iTools environment variable:ICDIR"
      exit 1
    }
    package require sqlite3
    if {$optionS(debug)} {
      puts stderr "opening sqlite3 database $filename..."
    }
    if {!([file exists $filename])} {
      twmessage errmsg $routine "could not open $filename...\n\n"
      exit 1
    }
    set status [sqlite3 exam $filename]
    set dbS exam
    return $dbS
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

  proc set_user_field_value {database table field user value} {
    while {1} {
      if {[catch {set vals [$database eval "UPDATE $table SET `$field` = '$value' WHERE `Username` == '$user'"]} msg]} {
	puts stderr "database busy... waiting..."
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
   
  proc query_db {field idx} {
    variable dbS
    variable tableS
    set vals [query_db_cmd $dbS $tableS $field $idx]
    return $vals
  }

  proc get_test_name { } {
    variable optionS
    return $optionS(test_name)
  }

  proc get_test_field {netid question field_type} {
    variable dbS

    set test_name [get_test_name]
    switch $field_type {
      "correct" {
	set full_field_name "${test_name}_${question}_stat"
	set field_type INTEGER
	set field_init false
      }
      "answer" {
	set full_field_name "${test_name}_${question}_val"
	set field_type TEXT
	set field_init false
      }
      "tries" {
	set full_field_name "${test_name}_${question}_try"
	set field_type INTEGER
	set field_init true
	set field_init_value 0
      }
    }
    set col_info [column_info $dbS exam] 

    set exists [column_exists $col_info $full_field_name]
    if {!($exists)} {
      column_add $dbS exam $full_field_name $field_type
      if {$field_init} {
	set_field_init_value $dbS exam $full_field_name $field_init_value
      } else {
	return "" ; # Nothing there
      }
    }
    # It exists so retrieve current value
    set field_info [get_user_field $dbS exam $full_field_name $netid]
    return $field_info
  }

  proc set_test_field {netid question field_type value} {
    variable dbS

    set test_name [get_test_name]
    switch $field_type {
      "correct" {
	set full_field_name "${test_name}_${question}_stat"
	set field_type INTEGER
	set field_init false
      }
      "answer" {
	set full_field_name "${test_name}_${question}_val"
	set field_type TEXT
	set field_init false
      }
      "tries" {
	set full_field_name "${test_name}_${question}_try"
	set field_type INTEGER
	set field_init true
	set field_init_value 0
      }
    }
    set col_info [column_info $dbS exam] 

    set exists [column_exists $col_info $full_field_name]
    if {!($exists)} {
      column_add $dbS exam $full_field_name $field_type
      if {$field_init} {
	set_field_init_value $dbS exam $full_field_name $field_init_value
      } 
    }
    set_user_field_value $dbS exam $full_field_name $netid $value
  }

  proc test_login { } {
    variable optionS
    variable dbS
    variable netidS
    variable firstS
    variable lastS
    variable passwdS

    # First see if we can open test database
    open_db $optionS(test)

    set w .utdcache_login

    # First make sure main dialog doesn't exist.
    if {[winfo exists $w]} {
      wm withdraw $w
      wm deiconify $w
      return $netidS ;
    }

    toplevel $w  \
      -background {lightgray} \
      -highlightbackground {lightgray}

    wm protocol $w WM_DELETE_WINDOW "exit 1"

    tixLabelFrame $w.info -label {Name} -labelside acrosstop \
      -options {
	label.padX 5
	label.padY 0
    }
    set fname [$w.info subwidget frame]

    tixComboBox $fname.first -labelside left -label "First Name:" \
      -variable ::utdcache::firstS -selectmode immediate \
      -dropdown true -editable true -width 20 \
      -options {
	listbox.height 6
	label.width 10
	label.anchor e
      }
    tixComboBox $fname.last -labelside left -label "Last Name:" \
      -variable ::utdcache::lastS -selectmode immediate \
      -dropdown true -editable true  -width 20 \
      -options {
	listbox.height 6
	label.width 10
	label.anchor e
      }
    tixComboBox $fname.netid -labelside left -label "Net ID:" \
      -variable ::utdcache::netidS -selectmode immediate \
      -dropdown true -editable true  -width 20 \
      -options {
	listbox.height 6
	label.width 10
	label.anchor e
      }
    tixComboBox $fname.password -labelside left -label "Password:" \
      -variable ::utdcache::passwdS -selectmode immediate \
      -dropdown true -editable true  -width 20 \
      -options {
	listbox.height 6
	label.width 10
	label.anchor e
      }
    set fentry [$fname.password subwidget entry]
    $fentry configure -show *

    label $fname.message -text "" -foreground red -textvariable ::utdcache::msgS

    pack $fname.first -side top -expand yes -fill x
    pack $fname.last -side top -expand yes -fill x
    pack $fname.netid -side top -expand yes -fill x
    pack $fname.password  -side top -expand yes -fill x
    pack $fname.message  -side top -expand yes -fill x
    tixButtonBox $w.buttons -orientation horizontal
    $w.buttons add new -text "Submit" -command "::utdcache::submit $w"

    pack $w.info -side top -fill both -expand yes
    pack $w.buttons -side top -fill x -expand yes
    tkwait window $w
    return $netidS

  }

  proc submit {w} {
    variable dbS
    variable msgS
    variable netidS
    variable firstS
    variable lastS
    variable passwdS
# set firstS William
# set lastS Swartz
# set netidS wps100020
# set passwdS pw1462244
    if {$firstS == ""} {
      set msgS "Please enter first name"
      return ;
    }
    if {$lastS == ""} {
      set msgS "Please enter last name"
      return ;
    }
    if {$netidS == ""} {
      set msgS "Please enter net id"
      return ;
    }
    if {$passwdS == ""} {
      set msgS "Please enter password"
      return ;
    }
    set user_info [user_exists $dbS exam Username $netidS]
    if {$user_info == ""} {
      set msgS "Username $netidS not found.  Netid is lower case"
      return ;
    }
    set passwd_info [get_user_field $dbS exam Password $netidS]
    if {$passwd_info == ""} {
      set msgS "Username ${netidS}'s password not found. Please report."
      return ;
    }
    if {$passwdS != $passwd_info} {
      set msgS "Username ${netidS}'s passwords do not match."
      return ;
    }
    destroy $w
  }

  proc get_user_data {netid field} {
    variable dbS
    set info [get_user_field $dbS exam $field $netid]
  }

}

