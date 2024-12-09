# $Log: utd_server.tcl,v $
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

 proc HTTPD {port certfile keyfile userpwds realm handler} {
  if {![llength [info commands Log]]} { proc Log {args} { puts $args } }
  namespace eval httpd [list set handlers $handler]
  namespace eval httpd [list set realm $realm]
  foreach up $userpwds { namespace eval httpd [list lappend auths [base64::encode $up]] }
  namespace eval httpd {
    variable dbS
    variable tableS
    variable header_lenS
    variable header_boundaryS
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
	  set method [lindex $line 0]
	  if {$method == "POST"} {
	    set url [lindex $line 1]
	    post_handler $sock $ip $url
	  } else {
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

    proc post_handler {sock ip url} {
      variable header_boundaryS
      variable header_filenameS
      global debugG
set debugG true
      # checkauth $sock $ip $auth
      puts stderr "sock:$sock ip:$ip url:$url"
      set linecnt 0
      set net_id ""
      set header_boundaryS "-invalid-"
      set header_filenameS ""
      while {[gets $sock line] >= 0} {
	incr linecnt
	if {[parse_http_header $line]} {
	  continue
	}
	puts stderr "line($linecnt):$line len:[string length $line]"
	set bidx [string first $header_boundaryS $line]
	if {$bidx >= 0} {
	  # puts stderr "boundary found"
	  break ;
	}
      }

      set upload_filename ""
      if {$header_boundaryS != "-invalid-"} {
	set fp ""
	set look_for_netid false
	while {[gets $sock line] >= 0} {
	  incr linecnt
	  if {$debugG} {
	    puts stderr "line($linecnt):$line len:[string length $line]"
	  }
	  set ret_code [parse_header_disposition $line]
	  if {$ret_code == 1} {
	    if {$header_filenameS != ""} {
	      if {($net_id != "")} {
		set upload_filename ${net_id}_${header_filenameS}
	      } else {
		set upload_filename ${header_filenameS}
	      }
	      set fp [open ${upload_filename} w]
	      if {$fp != ""} {
		# Through away blank line
		gets $sock line
		continue
	      }
	    }
	  } elseif {$ret_code == 2} {
	    set look_for_netid true
	    continue ;
	  }
	  set bidx [string first $header_boundaryS $line]
	  if {$bidx >= 0} {
	    set boundary_set true
	    set amt [chan pending input $sock]
	    if {$debugG} {
	      puts stderr "boundary detected:$amt"
	    }
	    if {$fp != ""} {
	      close $fp
	      set fp ""
	    }
	    if {$amt == 0} {
	      break ;
	    }
	  } else {
	    set boundary_set false
	  }
	  if {$fp != ""} {
	    # puts $fp [base64::decode $line]
	    puts $fp $line
	  } elseif {$look_for_netid} {
	    if {$line != ""} {
	      set net_id $line
	      if {$debugG} {
		puts stderr "netid is $net_id"
	      }
	      set look_for_netid false
	    }
	  }
	}
      }
      if {$upload_filename != ""} {
	respond $sock 200 "File $upload_filename uploaded<BR><BR>Thank you!"
      } else {
	respond $sock 200 "File was not uploaded<BR><BR>"
      }
    }

    proc parse_http_header { line } {
      variable header_lenS
      variable header_boundaryS
      set parsed_line [split $line :]
      set argc [llength $parsed_line]
      if {$argc >= 2} {
	set header_field [lindex $parsed_line 0]
	# puts stderr "header_field: $header_field"
	if {$header_field == "Content-Length"} {
	  set header_lenS [::utdstring::remove_whitespace [lindex $parsed_line 1]]
	  # puts stderr "header length: $header_lenS"
	} elseif {$header_field == "Content-Type"} {
	  set type_info [lindex $parsed_line 1]
	  # puts stderr "type:$type_info"
	  set sub_line [::utdstring::strparser $type_info {;}]
	  set ctype [lindex $sub_line 0]
	  set ctype [::utdstring::remove_whitespace $ctype]
	  # puts stderr "ctype:$ctype"
	  if {$ctype == "multipart/form-data"} {
	    set boun_string [lindex $sub_line 1]
	    set bidx [string first boundary= $boun_string]
	    if {$bidx > 0} {
	      # puts stderr "boun idx:$bidx"
	      incr bidx 9
	      set header_boundaryS [string range $boun_string $bidx end]
	      set len [string length $header_boundaryS]
	      for {set c 0} {$c < $len} {incr c} {
		set ch [string index $header_boundaryS $c]
		if {$ch != "-"} {
		  incr c -2
		  set header_boundaryS [string range $header_boundaryS $c end]
		  break ;
		}
	      }
	      # puts stderr "h boundary:$header_boundaryS len:[string length $header_boundaryS]"
	      return true
	    }
	  }
	}
      }
      return false
    }

    proc parse_header_disposition { line } {
      variable header_filenameS
      global debugG
      set parsed_line [split $line :]
      set argc [llength $parsed_line]
      if {$argc >= 2} {
	set header_field [lindex $parsed_line 0]
	# puts stderr "header_field: $header_field"
	if {$header_field == "Content-Type"} {
	  return 1
	} elseif {$header_field == "Content-Disposition"} {
	  set type_info [lindex $parsed_line 1]
	  # puts stderr "type:$type_info"
	  set sub_line [::utdstring::strparser $type_info {;}]
	  # puts stderr "sub:$sub_line"
	  set form_data [lindex $sub_line 0]
	  set form_data [::utdstring::remove_whitespace $form_data]
	  # puts stderr " f:$form_data"
	  if {$form_data == "form-data"} {
	    set name_type [lindex $sub_line 1]
	    set data_info [::utdstring::strparser $name_type {= }]
	    # puts stderr "da:'$data_info'"
	    set fname [lindex $data_info 0]
	    if {$fname == "name"} {
	      set data_type [lindex $data_info 1]
	      set data_type [::utdstring::remove_dquotes $data_type]
	      if {$debugG} {
		puts stderr "name found:'$data_type'"
	      }
	      if {$data_type == "netid"} {
		return 2
	      } elseif {($data_type == "file") || ($data_type == "file2")} {
		set name_type [lindex $sub_line 2]
		set data_info [::utdstring::strparser $name_type {= }]
		set fname [lindex $data_info 0]
		if {$fname == "filename"} {
		  set fname [lindex $data_info 0]
		  set filename [lindex $data_info 1]
		  if {$header_filenameS == ""} {
		    set header_filenameS [::utdstring::remove_dquotes $filename]
		  }
		  if {$debugG} {
		    puts stderr "$header_filenameS"
		  }
		}
	      }
	    }
	  }
	}
      }
      return 0
    }

    proc open_db {filename} {
      global env
      global argv
      variable dbS
      set routine "::utd::open_db"
      if {[info exists env(UTDTOOLS)]} {
	set utdtools $env(UTDTOOLS)
      } else {
	puts stderr "ERROR:cannot get UTDTOOLS environment variable:UTDTOOLS"
	exit 1
      }
      package require sqlite3
      global debugG
      if {$debugG} {
	puts stderr "opening sqlite3 database $filename..."
      }
      set status [sqlite3 exam $filename]
      set dbS exam
      return exam
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
      global test_htmlG
      set idx [string last / $test_htmlG]
      if {$idx < 0} {
	# No slash
	set base $test_htmlG
      } else {
	set start_idx [expr $idx + 1]
	set base [string range $test_htmlG $start_idx end]
      }
      # Now remove any . from the name
      set test_name [file rootname $base]
      return $test_name
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

proc read_answers {filename} {
  global correct_ansG
  set correct_ansG(num_questions) 0
  utdmsg imsg read_answers "analyzing $filename to find the answers.\n"

  set f [open $filename "r"]
  if {$f != ""} {
    set file_data [read $f]
    close $f
  }
  set lines [split $file_data "\n"]
  foreach line $lines {
    set parsed_line [split $line " \n\t"]
    set adj_line ""
    foreach piece $parsed_line {
      if {$piece != ""} {
	lappend adj_line $piece
      }
    }
    set argv_0 [lindex $adj_line 0]
    set fchar [string index $argv_0 0]
    if {($fchar == "q") || ($fchar == "Q")} {
      set question_number [string range $argv_0 1 end]
      if {[string is integer -strict $question_number]} {
	set correct_ansG($question_number) [lindex $adj_line 1]
	incr correct_ansG(num_questions)
      }
    }
  }
  utdmsg imsg read_answers "we found answers to $correct_ansG(num_questions) questions.\n"

}

global argv
global databaseG
global test_htmlG
global debugG
global portG
global quizdirG
global passwordG
global max_triesG
global correct_ansG
set databaseG ""
set test_htmlG ""
set debugG false
set passwordG false
set args $argv
set max_triesG 2
set restart off
set args [utdscript_args]
set num_args [llength $args]
puts stderr "my_args: $args"
set portG 9005
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
    if {$test_htmlG == ""} {
      set test_htmlG $arg_el
    } else {
      set databaseG $arg_el
    }
  }
}

if {$debugG} {
  puts stderr "args:$args"
}

if {!([file exists $databaseG])} {
  utdmsg errmsg quiztool "Database does not exist\n\n"
  exit 1
}
set answers "${test_htmlG}.ans"
if {!([file exists $answers])} {
  utdmsg errmsg quiztool "Answer file:$answers does not exist\n\n"
  exit 1
}
puts stderr "quiz:$test_htmlG database:$databaseG answers:$answers\n"
read_answers $answers

# See if column exists

puts stderr "\nUsing Port:$portG"

 # Generating SSL key is very easy, just use these two commands:
 #  openssl genrsa -out server-private.pem 1024
 #  openssl req -new -x509 -key server-private.pem -out server-public.pem -days 365 
 # Or just don't specify the key files to use HTTP instead of HTTPS
 # HTTPD $portG server-public.pem server-private.pem {mike:pwd you:yourpwd} {AuthRealm} {
 # HTTPD $portG "" "" {mike:pwd} {AuthRealm} {
 # puts stderr "port is 9008..."
 HTTPD $portG "" "" "" {AuthRealm} {
        "quizdata" {
	  if {[info exists req(query)]} {
	    global databaseG
	    global passwordG
	    global correct_ansG
	    global max_triesG
	    global portG
	    set dbS [open_db $databaseG]
	    set reply ""
	    set student_answer $req(query)
	    set col_info [column_info $dbS exam]

	    # puts stderr "col:$col_info\n"
	    # puts stderr "numcols:[llength $col_info]\n"

	    set test_name [get_test_name]
	    # puts stderr "test: $test_name"
	    set exists [column_exists $col_info $test_name]
	    if {$exists} {
	      # puts stderr "column $test_name exists"
	      set tries "${test_name}_tries"
	    } else {
	      column_add $dbS exam $test_name INTEGER
	      set tries "${test_name}_tries"
	      column_add $dbS exam $tries INTEGER
	      set_field_init_value $dbS exam $tries 0
	    }

	    puts stderr "reply: $student_answer @ [clock format [clock seconds]]"
	    set first_name ""
	    set last_name ""
	    set netid ""
	    set password ""
	    set vals [split $student_answer &]
	    set answer(exists) false 
	    set feedback(exists) false 
	    set poll(exists) false 
	    # Parse reply
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
		} elseif {$name == "password"} {
		  set password [lindex $items 1]
		} elseif {($fchar == "q") || ($fchar == "Q")} {
		  set question_number [string range $name 1 end]
		  if {[string is integer -strict $question_number]} {
		    set answer($question_number) [lindex $items 1]
		  }
		} elseif {($fchar == "f") || ($fchar == "F")} {
		  set feedback_number [string range $name 1 end]
		  if {[string is integer -strict $feedback_number]} {
		    set feedback($feedback_number) [lindex $items 1]
		    set feedback(exists) true 
		  }
		} elseif {($fchar == "p") || ($fchar == "P")} {
		  set poll_number [string range $name 1 end]
		  if {[string is integer -strict $poll_number]} {
		    set poll($poll_number) [lindex $items 1]
		    set poll(exists) true 
		  }
		}
	      }
	    }

	    set num_questions $correct_ansG(num_questions)

	    # See if a valid student
	    set user_info [user_exists $dbS exam Username $netid]
	    if {$user_info == ""} {
	      respond $sock 200 "ERROR: invalid user:$netid. Please try again.<BR><BR>Thank you!"
	    } else {
	      if {$passwordG} {
		set user_password [get_user_field $dbS exam Password $netid]
		if {$password != $user_password} {
		  respond $sock 200 "ERROR: invalid password for user:$netid. Please try again.<BR><BR>Thank you!"
		  Log "Error: invalid password:$password versus $user_password for user:$netid."
		  return ;
		}
	      }
	      append reply "<BR>Credentials verified: [lrange $user_info 0 3]<BR><BR>"
	      # See if user used up their tries
	      set user_tries [get_user_field $dbS exam $tries $netid]
	      # because haven't counted this try yet.
	      set max_tries [expr $max_triesG -1] ;
	      if {$user_tries > $max_tries} {
		set user_score [get_user_field $dbS exam $test_name $netid]
		append reply "<BR>Unfortunately, you used up your maximum number of tries."
		append reply "<BR>Your final score is $user_score / $num_questions."
	      } else { 
		# Now check answers
		# Read the answer file:
		#
		set num_correct 0
		for {set q 1} {$q <= $num_questions} {incr q} {
		  if {[info exists answer($q)]} {
		    set correct_answer $correct_ansG($q)
		    set your_answer $answer($q)
		    if {$your_answer != $correct_answer} {
		      append reply "<BR>Unfortunately, your answer to question $q is wrong."
		    } else {
		      append reply "<BR>Congrats $first_name.  Your answer to question $q is correct!"
		      incr num_correct
		    }
		  } else {
		    append reply "<BR>Your haven't answered question $q."
		  }
		}
		if {$num_questions > 0} {
		  append reply "<BR>You got $num_correct out of $num_questions correct.\n"
		}
		# Now we can update the database here.
		set_user_field_value $dbS exam $test_name $netid $num_correct
		incr user_tries
		set_user_field_value $dbS exam $tries $netid $user_tries
		append reply "<BR>You have used $user_tries out of a maximum $max_triesG possible tries.\n"
		append reply "<BR>Do *NOT* refresh your browser but use the back button to try again if you wish\n"
		if {$feedback(exists)} {
		  for {set f 1} {$f <= 10} {incr f} {
		    if {[info exists feedback($f)]} {
		      set fb_field_name "${test_name}_fb_${f}"
		      set exists [column_exists $col_info $fb_field_name]
		      if {!($exists)} {
			column_add $dbS exam $fb_field_name TEXT
		      }
		      set_user_field_value $dbS exam $fb_field_name $netid $feedback($f)
		    }
		  }
		}
		if {$poll(exists)} {
		  for {set p 1} {$p <= 10} {incr p} {
		    if {[info exists poll($p)]} {
		      set poll_field_name "${test_name}_poll_${p}"
		      set exists [column_exists $col_info $poll_field_name]
		      if {!($exists)} {
			column_add $dbS exam $poll_field_name INTEGER
		      }
		      set_user_field_value $dbS exam $poll_field_name $netid $poll($p)
		    }
		  }
		}
	      }
	    }
	    close_db $dbS
	  }

          respond $sock 200 "$reply  <BR><BR>Thank you!"

        }
        "" {
	  global portG
          respond $sock 200 "Want to know the <a href=\"/time\">time</a>? But really you want to go to <a href=\"http://[exec hostname]:$portG/test\">http://[exec hostname]:$portG/test </a>"
        }
        "time" {
          respond $sock 200 "Time: [clock format [clock seconds]]" "Refresh: 6;URL=/\n"
        }
        "test" {
	  global test_htmlG
	  if {$test_htmlG != ""} {
	    set f [open $test_htmlG "r"]
	    if {$f != ""} {
	      set file_data [read $f]
	      close $f
	      respond $sock 200 "$file_data"
	    }
	  } else {
	    respond $sock 200 "file does not exist."
	  }
        }
 }
 vwait forever
