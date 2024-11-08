# $Log: cadence.tcl,v $
# Revision 1.1  2024/09/12 16:53:28  wps100020
# Initial revision
#
# Revision 1.1  2021/09/14 18:10:17  billswartz7
# Initial revision
#
# Revision 1.13  2021/05/07 23:06:31  bill
# Added the ability to commit suicide so that we can avoid creating
# excessive zombies.
#
# Revision 1.12  2021/04/07 21:59:58  bill
# Added the status mechanism for students to get their scores.
#
# Revision 1.11  2021/04/07 18:30:41  bill
# Now prevent a crash when the number of questions is zero, that is,
# when there are only polls.
#
# Revision 1.10  2021/02/03 17:22:35  bill
# Fixed the problem with forked zombies.   After access we close the connection.
#
# Revision 1.9  2020/09/03 21:52:31  bill
# Now we made it redirect to the proper page for convenience.
#
# Revision 1.8  2020/08/27 21:19:07  bill
# Now added time stamp so we can see when students connected.
#
# Revision 1.7  2020/08/27 16:43:45  bill
# Added the ability to add polls to the test.
#
# Revision 1.6  2020/08/24 15:42:03  bill
# Added ability to have feedback questions in the test.   Added loops
# so that a busy database will not affect the answer.
#
# Revision 1.5  2020/05/07 18:25:30  bill
# Added the password and maxtries options to the tool
#
# Revision 1.4  2020/05/03 15:24:42  bill
# This version supports debug and port selection to make life easier.
#
# Revision 1.3  2020/04/16 00:39:20  bill
# Made code backward compatible with Tcl 8.4.5
#
#
 package require uri
 package require base64
 package require html
 set eversion [package require Expect]
 puts stderr "eversion:$eversion"
 package require sqlite3

 proc process_data { fname file_data } {

    global test_localG
    set debug_flag true
    set routine process_data
    set fout [open $fname "w"]
    if {$fout == ""} {
      utdmsg errmsg $routine "Could not open file:$fname\n"
      return ;
    }
    set lines [split $file_data "\r\n"]
    set lcount 0
    foreach line $lines {
      set startidx 0
      set outline true
      incr lcount
      set after_options -1
      set line_len [string len $line]
      set end_idx [expr $line_len - 1]
      while {1} {
	set idx [string first UTDx $line $startidx]
	if {$idx >= 0} {
	  if {($idx > $after_options) && ($startidx > 0)} {
	    set after_end [expr $idx - 1]
	    if {$debug_flag} {
	      puts stderr "string output ($after_options:$after_end):\
	      '[string range $line $after_options $after_end]'"
	    }
	    puts -nonewline $fout "[string range $line $after_options $after_end]"
	    set after_options -1
	  }
	  set outline false
	  if {$debug_flag} {
	    utdmsg imsg $routine "found match ($lcount:$idx) : $line\n"
	  }
	  set intro [expr {$idx-1}]
	  puts -nonewline $fout "[string range $line $startidx $intro]"
	  # Now find the index of the opening brace
	  set open_brace_idx [string first "{" $line $idx]
	  set close_brace_idx [string first "}" $line $idx]
	  if {($open_brace_idx >= 0) && ($close_brace_idx >= 0)} {
 	    set after_options [expr {$close_brace_idx + 1}]
 	    incr open_brace_idx
 	    incr close_brace_idx -1
 	    set utd_var [string range $line $open_brace_idx $close_brace_idx]
	    if {$debug_flag} {
	      puts stderr "utd_var: $utd_var"
	    }
	    if {$utd_var == "register"} {
	      if {$test_localG} {
		set val "localhost:9001/register"
	      } else {
		set val "fury.utdallas.edu:9001/register"
	      }
	    }
	    set fchar [string index $val 0]
	    if {$fchar == "\{" } {
	      set val [string range $val 1 end-1]
	    }
	    if {$debug_flag} {
	      puts stderr "value: $val"
	    }
 	    puts -nonewline $fout "$val"
	    set startidx $after_options
	    if {$debug_flag} {
	      puts stderr "after_option:$after_options line_len:$line_len"
	    }
	    continue
	  }
	} elseif {($after_options >= 0) && ($after_options <= $end_idx)} {
	  if {$debug_flag} {
	    puts stderr "string output ($after_options:end)"
	  }
	  puts $fout "[string range $line $after_options end]"
	}
	break ;
      }

      if {$outline} {
	puts $fout "$line"
      }
    }
    puts stderr "closing data output\n"
    close $fout
 }

 proc HTTPD {port certfile keyfile userpwds realm handler} {
  if {![llength [info commands Log]]} { proc Log {args} { puts $args } }
  namespace eval httpd [list set handlers $handler]
  namespace eval httpd [list set realm $realm]
  foreach up $userpwds { namespace eval httpd [list lappend auths [base64::encode $up]] }
  namespace eval httpd {
    variable dbS
    variable tableS
    proc respond {sock code body {head ""}} {
      puts -nonewline $sock "HTTP/1.0 $code ???\nContent-Type: text/html; charset=ISO-8859-1\nConnection: close\nContent-length: [string length $body]\n$head\n$body"
    }
    proc checkauth {sock ip auth} {
      variable auths
      variable realm
      if {[info exist auths] && [lsearch -exact $auths $auth]==-1} {
        respond $sock 401 Unauthorized "WWW-Authenticate: Basic realm=\"$realm\"\n"
        error "Unauthorized from $ip"
      }
    }
    proc handler {sock ip reqstring auth} {
      variable auths
      variable handlers
      checkauth $sock $ip $auth
      array set req $reqstring
      switch -glob $req(path) [concat $handlers [list default { respond $sock 404 "Error" }]]
    }
    proc accept {sock ip port} {
      set pid [fork]
      if {$pid < 0} {
	puts stderr "fork failed in accept\n"
      } elseif {$pid == 0} {
	# in child
	if {[catch {
	  gets $sock line
	  set auth ""
	  for {set c 0} {[gets $sock temp]>=0 && $temp ne "\r" && $temp ne ""} {incr c} {
	    regexp {Authorization: Basic ([^\r\n]+)} $temp -- auth
	    if {$c == 30} { error "Too many lines from $ip" }
	  }
	  if {[eof $sock]} { 
	    error "Connection closed from $ip : [clock format [clock seconds]]" 
	  }
	  foreach {method url version} $line { break }
	  switch -exact $method {
	    GET { handler $sock $ip [uri::split $url] $auth }
	    default { error "Unsupported method '$method' from $ip: [clock format [clock seconds]]" }
	  }
	} msg]} {
	  Log "Error: $msg"
	}
	Log "Msg: about to close socket:$sock"
	close $sock
	# Log "Msg: socket closed"
	Log "child pid is really: [pid]"
	exit 0
      } else {
	# In parent
	Log "Msg: we should be waiting for pid:$pid"
	wait -nowait -pid $pid
      }
    }

  }
  if {$certfile ne ""} {
  package require tls
  ::tls::init \
    -certfile $certfile \
    -keyfile  $keyfile \
    -ssl2 1 \
    -ssl3 1 \
    -tls1 0 \
    -require 0 \
    -request 0
  ::tls::socket -server httpd::accept $port
  } else {
    socket -server httpd::accept $port
  }

}


global argv
global databaseG
global site_htmlG
global debugG
global portG
global test_localG
global correct_ansG
set databaseG ""
set site_htmlG ""
set debugG false
set test_localG false
set args $argv
set restart off
set args [utdscript_args]
set num_args [llength $args]
puts stderr "my_args: $args"
set portG 9001
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debugG on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "localhost" } {
    set test_localG true
    puts stdout "localhost testing enabled.\n"
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
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  cadence <html> <student_database> \[debug\] \[localhost\] \[port <integer>\]\n"
    exit 0
  } else {
    if {$site_htmlG == ""} {
      set site_htmlG $arg_el
    } else {
      set databaseG $arg_el
    }
  }
}

if {$debugG} {
  puts stderr "args:$args"
}

if {!([file exists $databaseG])} {
  utdmsg errmsg cadence "Database does not exist\n\n"
  exit 1
}

proc valid_utd_user { netid } {
  global outputG
  if {[catch {bgexec statusG -output outputG id $netid} msg]} {  
    puts stderr "we got the following msg:$msg"
    return false
  }
  puts stderr "valid_utd_user:$outputG"
  return true
}

puts stderr "\nUsing Port:$portG"

 # Generating SSL key is very easy, just use these two commands:
 #  openssl genrsa -out server-private.pem 1024
 #  openssl req -new -x509 -key server-private.pem -out server-public.pem -days 365 
 # Or just don't specify the key files to use HTTP instead of HTTPS
 # HTTPD $portG server-public.pem server-private.pem {mike:pwd you:yourpwd} {AuthRealm} {
 # HTTPD $portG "" "" {mike:pwd} {AuthRealm} {
 # puts stderr "port is 9008..."
 HTTPD $portG "" "" "" {AuthRealm} {
    "" {
      global portG
      set ftmpl [open index.html.tmpl "r"]
      if {$ftmpl != ""} {
	set file_data [read $ftmpl]
	process_data index.html $file_data
	close $ftmpl
	set f [open index.html "r"]
	if {$f != ""} {
	  set file_data [read $f]
	  close $f
	  respond $sock 200 "$file_data"
	}
      }
    }
    "time" {
      respond $sock 200 "Time: [clock format [clock seconds]]" "Refresh: 6;URL=/\n"
    }
    "register" {
      global site_htmlG
      if {$site_htmlG != ""} {
	set f [open $site_htmlG "r"]
	if {$f != ""} {
	  set file_data [read $f]
	  close $f
	  respond $sock 200 "$file_data"
	}
      } else {
	respond $sock 200 "file does not exist."
      }
    }
    "cadence" {
      global databaseG
      if {[info exists req(query)]} {
	puts stderr "database:$databaseG"
	set db [::utdtools::db::open_db $databaseG students -nocreate]
	if {$db == ""} {
	  exit 1
	}
	set col_info [::utdtools::db::column_info $db students]
	set num_cols [::utdtools::db::num_columns $col_info]

	set student_answer $req(query)
	set vals [split $student_answer &]
	# Parse reply
	set netid ""
	foreach val $vals {
	  # puts stderr "val : $val"
	  set items [split $val =]
	  set num_items [llength $items]
	  if {$num_items == 2} {
	    set name [lindex $items 0]
	    set fchar [string index $name 0]
	    if {$name == "fname"} {
	      set first_name [lindex $items 1]
	    } elseif {$name == "lname"} {
	      set last_name [lindex $items 1]
	    } elseif {$name == "netid"} {
	      set netid [lindex $items 1]
	    }
	  }
	}
	if {$netid == ""} {
	  set reply "ERROR: no netid supplied!"
	} else {
	  set table students
	  set user_info [::utdtools::db::user_exists $db $table Username $netid]
	  if {$user_info == ""} {
	    if {[valid_utd_user $netid]} {
	      set reply "Adding request to user database for user:$netid."
	      set num_items [::utdtools::db::num_items $db $table]
	      set idx [expr $num_items + 1]
	      set data $idx
	      for {set c 2} {$c <= $num_cols} {incr c} {
		set field_name [::utdtools::db::column_name $col_info $c]
		set field_type [::utdtools::db::column_type $col_info $c]
		set field_type [string tolower $field_type]
		if {$field_name == "Last Name"} {
		  append data ",'${last_name}'"
		} elseif {$field_name == "First Name"} {
		  append data ",'${first_name}'"
		} elseif {$field_name == "Username"} {
		  append data ",'${netid}'"
		} elseif {$field_name == "requested"} {
		  append data ",[clock seconds]"
		} elseif {$field_type == "integer"} {
		  append data ",0"
		} else {
		  append data ",NULL"
		}
	      }
	      puts stderr "data:$data"
	      set vals [::utdtools::db::row_add $db $table $data]
	      puts stderr "return val:$vals"
	    } else {
	      set reply "ERROR: invalid UTD user:$netid. User does not have a valid UTD directory."
	    }
	  } else {
	    set reply "User:$netid"
	    set item [::utdtools::db::get_user_field $db $table Index $netid]
	    append reply " Index:$item"
	    if {$item != ""} {
	      set expired [::utdtools::db::query_db $db $table "expires" $item]
	      if {($expired == "") || ($expired == "{}")} {
		set cadence_replied [::utdtools::db::query_db $db $table cadence_reply $item]
		if {($cadence_replied == "") || ($cadence_replied == "{}")} {
		  set cur_date [clock seconds]
		  set reply "No reply from Cadence as of yet ([clock format $cur_date]) for user:$netid (database item:$item)\n" 
		} else {
		  set reply "Cadence replied on $cadence_replied" 
		  set expires [expr $cadence_replied + 365 * 24 * 3600]
		  append reply "\nCadence expires on $expires\n" 
		  set val [::utdtools::db::set_user_field_value $db $table "expires" Index $item $expires]
		}
	      } else {
		set reply "User $netid ($item) expires in $expired [clock format $expired]" 
	      }
	    }
	  }
	}

	::utdtools::db::close_db $db
      } else {
	set reply "no query data found"
      }
      respond $sock 200 "$reply  <BR><BR>Thank you!"
    }
    "requested" {
      global databaseG
      set reply requested
      set db [::utdtools::db::open_db $databaseG students -nocreate]
      if {$db == ""} {
	exit 1
      }
      set table students
      set col_info [::utdtools::db::column_info $db students]
      set num_cols [::utdtools::db::num_columns $col_info]
      set num_items [::utdtools::db::num_items $db $table]
      set first_flag true
      set filename "cadence.csv"
      ::utdtools::backup_file $filename
      set fp [open $filename "w"]
      if {$fp == ""} {
	utdmsg errmsg $routine "could not open $filename for writing...\n"
      }
      for {set item 1} {$item <= $num_items} {incr item} {
	# puts stderr "item:$item"
	set cadence_replied [::utdtools::db::query_db $db $table cadence_reply $item]
	#uts stderr "cadence_reply:$cadence_replied"
	if {($cadence_replied == "") || ($cadence_replied == "{}")} {
	  set last [::utdtools::db::query_db $db $table "Last Name" $item]
	  set first [::utdtools::db::query_db $db $table "First Name" $item]
	  set netid [::utdtools::db::query_db $db $table "Username" $item]
	  set requested [::utdtools::db::query_db $db $table "requested" $item]
	  if {$first_flag} {
	    set reply "<H3>The following students have requested access to the program:</H3>"
	    set first_flag false
	    if {$fp != ""} {
	      puts $fp "\"Last Name\",\"First Name\",\"Username\""
	    }
	  }
	  append reply "<P>$first $last $netid on [clock format $requested]</P>\n"
	  if {$fp != ""} {
	    puts $fp "\"${last}\",\"${first}\",\"${netid}\""
	  }
	}
      }
      if {$first_flag} {
	set reply "There are no outstanding requests for the Cadence program\n\n"
      }
      if {$fp != ""} {
	close $fp
      }
      ::utdtools::db::close_db $db
      respond $sock 200 "$reply  <BR><BR>Thank you!"
    }
 }
 vwait forever

