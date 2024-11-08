#
# $Id: autotest.tcl,v 1.2 2022/09/22 03:25:19 billswartz7 Exp billswartz7 $
# $Log: autotest.tcl,v $
# Revision 1.2  2022/09/22 03:25:19  billswartz7
# Added support for libpath.
#
# Revision 1.1  2021/05/10 21:44:30  bill
# Initial revision
#
#


proc usage { } {
  utdmsg imsg null "Usage:\n"
  utdmsg imsg null "  Privileged commands:\n"
  utdmsg imsg null "  autotest variables : add variable to database\n"
  utdmsg imsg null "  autotest load : load problems into database\n\n"
  utdmsg imsg null "  User commands:\n"
  utdmsg imsg null "  autotest generate : generate new instance of last added problem.\n"
  utdmsg imsg null "  autotest generate <problem #>: generate new instance of a problem.\n"
  utdmsg imsg null "  autotest generated : list the instance type of problem.\n"
  utdmsg imsg null "  autotest generated <type> : list the instances of a given problem type.\n"
  utdmsg imsg null "  autotest show <instance #>: show problem instance\n"
  utdmsg imsg null "  autotest list : show available problem types or templates\n\n"
}

proc rand_range {min max} { 
  return [expr int(rand()*($max-$min+1)) + $min] 
}


proc process_problem {problem_filename database debug_flag} {

  set routine "process_problem"
  if {$problem_filename == ""} {
    utdmsg errmsg $routine "No file name specified.\n"
    return ;
  }
  set f [open [file join problems $problem_filename] "r"]
  if {$f == ""} {
    utdmsg errmsg $routine "Could not open file:$problem_filename\n"
    return ;
  }
  set file_data [read $f]
  close $f

  set lines [split $file_data "\r\n"]
  set lcount 0
  set type ""
  set output ""
  set variables ""
  set definition ""
  set in_problem false
  foreach line $lines {
    set startidx 0
    set outline true
    incr lcount
    set after_options -1
    set line_len [string len $line]
    set end_idx [expr $line_len - 1]

    if {!($in_problem)} {
      set parsed_line [split $line ",:'{} \t"]
      set adj_line ""
      foreach piece $parsed_line {
	if {$piece != ""} {
	  lappend adj_line $piece
	}
      }
      if {$adj_line == ""} {
	continue
      }
      set line_length [llength $adj_line]
      set argv_0 [lindex $adj_line 0]

      if {$argv_0 == "TYPE"} {
	set type [lindex $adj_line 1]
	puts stderr "type set to $type"
	continue
      } elseif {$argv_0 == "OUTPUT"} {
	set output [string range $line 7 end]
	puts stderr "output set to $output"
	continue
      } elseif {$argv_0 == "#FILECHECK"} {
	set filecheck [string range $line 10 end]
	puts stderr "filecheck set to $filecheck"
	continue
      } elseif {$argv_0 == "#LIBCHECK"} {
	set libcheck [string range $line 8 end]
	puts stderr "libcheck set to $libcheck"
	continue
      } elseif {$argv_0 == "PROBLEM"} {
	set in_problem true
      } 
    }

    while {1} {
      set idx [string first UTDx $line $startidx]
      if {$idx >= 0} {
	if {($idx > $after_options) && ($startidx > 0)} {
	  set after_end [expr $idx - 1]
	  if {$debug_flag} {
	    puts stderr "string output ($after_options:$after_end):\
	    '[string range $line $after_options $after_end]'"
	  }
	  append definition "[string range $line $after_options $after_end]"
	  set after_options -1
	}
	set outline false
	if {$debug_flag} {
	  utdmsg imsg $routine "found match ($lcount:$idx) : $line\n"
	}
	set intro [expr {$idx-1}]
	append definition "[string range $line $startidx $intro]"
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
	  lappend variables $utd_var
	  append definition "UTDx\{$utd_var\}"
	  set startidx $after_options
	  if {$debug_flag} {
	    puts stderr "after_option:$after_options line_len:$line_len e:$end_idx"
	  }
	  continue
	}
      } elseif {($after_options >= 0)} {
	if {($after_options <= $end_idx)} {
	  if {$debug_flag} {
	    puts stderr "string output ($after_options:end)"
	  }
	  append definition "[string range $line $after_options end]"
	  append definition "\n"
	} else {
	  append definition "\n"
	}
      }
      break ;
    }
    if {$outline} {
      append definition "$line\n"
    }
  }
  puts stderr "definition set to $definition"
  set num_problems [utdtools::db::num_items $database problems]
  puts stderr "num problems:$num_problems"
  incr num_problems
  if {[catch {set status [$database eval {INSERT INTO problems VALUES(:num_problems,:type,:output,:definition,:variables)}]} msg]} {
    puts stderr "msg:$msg database busy... waiting..."
  }
}

proc database_init {database debug_flag} {
  set db [utdtools::db::open_db $database]
  # puts stderr "db:$db"
  set col_info [utdtools::db::column_info $db problems]
  if {$col_info == ""} {
    # This is the first time generating anything so set up the columns
    set status [utdtools::db::create_table $db problems `Index` INTEGER]
    utdtools::db::column_add $db problems type TEXT
    utdtools::db::column_add $db problems output TEXT
    utdtools::db::column_add $db problems definition TEXT
    utdtools::db::column_add $db problems variables TEXT
    set status [utdtools::db::create_table_with_default $db instances `Index` INTEGER -1]
    utdtools::db::column_add $db instances problem INTEGER
    set status [utdtools::db::create_table $db variables `Index` INTEGER]
    utdtools::db::column_add $db variables var TEXT
    utdtools::db::column_add $db variables type TEXT
    utdtools::db::column_add $db variables definition TEXT
  }
  utdtools::db::close_db $db
}

proc load_problems {database debug_flag} {
  database_init $database $debug_flag

  set db [utdtools::db::open_db $database]
  set files [glob -nocomplain -tails -directory problems problem*]
  foreach f $files {
    process_problem $f $db $debug_flag
  }
  utdtools::db::close_db $db
}

proc generate_instances {database libpath problem debug_flag} {
  set db [utdtools::db::open_db $database]
  set num_problems [utdtools::db::num_items $db problems]
  if {$problem == 0} {
    set problem $num_problems
  }
  if {$debug_flag} {
    puts stderr "num_problems:$problem"
  }
  update_sources $db $libpath $debug_flag
  create_problem $db $problem $debug_flag

  utdtools::db::close_db $db
}

proc generate_data {db inst vname vtype vdef} {
  set routine "generate_data"
  switch $vtype {
    "list" {
      set vdef [lindex $vdef 0]
      set ldata [lindex $vdef 1]
      set data_len [llength $ldata]
      set max_data [expr $data_len - 1]
      set data_idx [rand_range 0 $max_data]
      set val [lindex $ldata $data_idx]
      utdtools::db::set_user_field_value $db instances $vname Index $inst $val
    }
    "bounds" {
	  set lexpr $key_data(lower_expr,$vname)
	  set hexpr $key_data(upper_expr,$vname)
	  if {[catch {set lo [eval $lexpr]} result_msg]} {
	    set lo $lexpr
	  }
	  if {[catch {set hi [eval $hexpr]} result_msg]} {
	    set hi $hexpr
	  }
	  set val [rand_range $lo $hi]
	  set $vname $val
	  set dataS($i,$vname) $val
     }
     "UTDunique" {
	  set ldata $key_data(values,$vname)
	  set unique_id $key_data(id,$vname)
	  set old_varname [lindex $unique_id 0]
	  set idx [lindex $unique_id 1]
	  set lo [lindex $unique_id 2]
	  if {$idx == $lo} {
	    # just pick
	    set ldata $key_data(values,$vname)
	    set data_len [llength $ldata]
	    set max_data [expr $data_len - 1]
	    set data_idx [rand_range 0 $max_data]
	    set val [lindex $ldata $data_idx]
	    set $vname $val
	    set dataS($i,$vname) $val
	  } else {
	    set ldata $key_data(values,$vname)
	    set data_len [llength $ldata]
	    set max_data [expr $data_len - 1]
	    for {set v $lo} {$v < $idx} {incr v} {
	      set new_vname ${old_varname}$v
	      set old_data $dataS($i,$new_vname)
	      set invalid($old_data) $old_data
	    }
	    set used [array names invalid]
	    set max_count 1000000
	    for {set count 1} {$count <= $max_count} {incr count} {
	      set data_idx [rand_range 0 $max_data]
	      set val [lindex $ldata $data_idx]
	      set fail false
	      foreach old $used {
		if {$val == $old} {
		  set fail true
		}
	      }
	      if {!($fail)} {
		set dataS($i,$vname) $val
		unset invalid
		break 
	      }
	    }
	    if {$count >= $max_count} {
	      puts stderr "caught in an infinite loop"
	    }
	  }
     }
     "UTDexpr" {
	puts stderr "inst:$inst vname:$vname vtype:$vtype vdef:$vdef"
	set vdef [lindex $vdef 0]
	set e_expr [lrange $vdef 2 end]
	puts stderr "e_expr:'${e_expr}'"
	if {[catch {set val [eval $e_expr]} result_msg]} {
	  puts stderr "ERROR(UTDexpr): vname:$vname $result_msg"
	  set val -1
	}
	utdtools::db::set_user_field_value $db instances $vname Index $inst $val
     }
     default {
      utdmsg errmsg $routine "unknown operation:$vtype\n"
    }
  }

}

proc generate_random_instance {db problem debug_flag} {
  set vars [utdtools::db::get_index_field $db problems variables $problem]
  if {$vars == ""} {
    utdmsg errmsg $routine "no variables found for problem:$problem\n"
    return ;
  }
  set col_info [utdtools::db::column_info $db instances]
  if {!([utdtools::db::column_exists $col_info definition])} {
    utdtools::db::column_add $db instances definition TEXT
  }
  set num_instances [utdtools::db::num_items $db instances]
  puts stderr "num instances: $num_instances"
  incr num_instances
  expr {srand($num_instances)}
  if {[catch {set status [$db eval {INSERT INTO instances DEFAULT VALUES}]} msg]} {
    puts stderr "msg:$msg database busy... waiting..."
  }

  utdtools::db::set_user_field_value $db instances Index Index -1 $num_instances
  utdtools::db::set_user_field_value $db instances problem Index $num_instances $problem


  set var_list [lindex $vars 0]
  foreach v $var_list {
    # puts stderr "var: $v"
    set vdef [utdtools::db::get_field_data $db variables definition var $v]
    # puts stderr "vdef: $vdef"
    set vtype [utdtools::db::get_field_data $db variables type var $v]
    # puts stderr "vtype: $vtype"
    if {!([utdtools::db::column_exists $col_info $v])} {
      utdtools::db::column_add $db instances $v TEXT
    }
    if {$v == "UTDID"} {
      continue
    }
    generate_data $db $num_instances $v $vtype $vdef
  }
  return $num_instances
}

proc update_sources {db libpath debug_flag} {

  set routine "update_sources"
  set srcs [utdtools::db::get_field_data $db variables definition var source]
  if {$srcs == ""} {
    utdmsg errmsg $routine "no sources found\n"
    return ;
  }
  set srcs [lindex $srcs 0]
  set fname_base [lindex $srcs 1]
  if {$fname_base != ""} {
    source [file join $libpath variables $fname_base]
  }
}


proc create_problem {db problem debug_flag} {

  set routine "create_problem"
  set definition [utdtools::db::get_index_field $db problems definition $problem]
  if {$definition == ""} {
    return "" ;
  }
  if {$debug_flag} { 
    puts stderr "initial def:$definition\n########\n"
  }
  set instnum [generate_random_instance $db $problem $debug_flag]

  if {$debug_flag} {
    puts stderr "definition:$definition\n"
    puts stderr "len:[llength $definition]"
  }
  set file_data [lindex $definition 0]

  set lines [split $file_data "\r\n"]
  set lcount 0
  set type ""
  set output ""
  set variables ""
  set definition ""
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
	  append definition "[string range $line $after_options $after_end]"
	  set after_options -1
	}
	set outline false
	if {$debug_flag} {
	  utdmsg imsg $routine "found match ($lcount:$idx) : $line\n"
	}
	set intro [expr {$idx-1}]
	append definition "[string range $line $startidx $intro]"
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
	  if {$utd_var == "UTDID"} {
	    set val $instnum
	  } else {
	    set val [utdtools::db::query_db_cmd $db instances $utd_var $instnum]
	  }
	  set fchar [string index $val 0]
	  if {$fchar == "\{" } {
	    set val [string range $val 1 end-1]
	  }

	  append definition "$val"
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
	append definition "[string range $line $after_options end]"
	append definition "\n"
      }
      break ;
    }

    if {$outline} {
      if {$line == ""} {
	append definition "\n"
      }
      append definition "$line\n"
    }
  }
  # append definition "PROGRAMID:$instnum\n"

  while {1} {
    if {[catch {set vals [$db eval "UPDATE instances SET `definition` = :definition WHERE `Index` == '$instnum'"]} msg]} {
	puts stderr "set_user_field_value:database busy... waiting..."
	puts stderr "message:$msg..."
	puts stderr "field:$field..."
	puts stderr "user_field:$user_field..."
	puts stderr "user:$user..."
	after 1000
	continue
    }
    break
  }
  puts stderr "$definition"
}

proc strip_grader_info { def } {
  set idx [string first PROBLEM: $def]
  if {$idx < 0} {
    return $def
  }
  incr idx 7
  set new_def [string range $def $idx end]
  return [list $new_def]
}

proc show_instance {database inst debug_flag} {
  set routine show_instance
  set db [utdtools::db::open_db $database]
  set num_insts [utdtools::db::num_items $db instances]
  if {($inst <= 0) || ($inst > $num_insts)} {
    utdmsg errmsg $routine "instance number out of bounds:$inst\n"
    utdmsg errmsg null "There are only $num_insts instances present.\n\n"
    exit 1
  }
  set definition [utdtools::db::get_index_field $db instances definition $inst]
  set definition [strip_grader_info $definition]
  puts stdout "Problem definition:"
  puts stdout "[lindex $definition 0]"
  utdtools::db::close_db $db
}

proc list_problems {database verbose_flag debug_flag} {
  set db [utdtools::db::open_db $database]
  set num_problems [utdtools::db::num_items $db problems]
  for {set p 1} {$p <= $num_problems} {incr p} {
    set type [utdtools::db::get_index_field $db problems type $p]
    set definition [utdtools::db::get_index_field $db problems definition $p]
    puts stdout "$p : $type"
    if {$verbose_flag} {
      puts stdout "    [string range $definition 0 200]"
    }
  }
  utdtools::db::close_db $db
}

proc show_types {database filter_type debug_flag} {
  set routine show_types
  set db [utdtools::db::open_db $database]
  set num_insts [utdtools::db::num_items $db instances]
  for {set inst 1} {$inst <= $num_insts} {incr inst} {
    set type_num [utdtools::db::get_index_field $db instances problem $inst]
    set type [utdtools::db::get_index_field $db problems type $type_num]
    if {($filter_type != "") && ($type != $filter_type)} {
      continue 
    }
    puts stdout "$inst : $type"
  }
  utdtools::db::close_db $db
}

proc add_variables {database var_filename debug_flag} {
  database_init $database $debug_flag
  set db [utdtools::db::open_db $database]
  set num_variables [utdtools::db::num_items $db variables]
  puts stderr "num variables:$num_variables"
  if {$var_filename == ""} {
    set var_filename [file join variables tests.vars]
  }
  utdmsg imsg null "Trying to read $var_filename..."
  if {[file exists $var_filename]} {
    utdmsg imsg null "exists.  Good!\n" 
  } else {
    utdmsg imsg null "Does not exists. Must abort!\n"
    exit 1
  }
  set fvars [open $var_filename "r"]
  if {$fvars == ""} {
    utdmsg errmsg $routine "Could not open file:$var_filename\n"
    exit 1 ;
  }
  set file_data [read $fvars]
  close $fvars

  set lines [split $file_data "\r\n"]
  set cnt 0
  set need_to_exit false
  foreach line $lines {
    incr cnt
    set parsed_line [split $line " \t"]
    set adj_line ""
    foreach piece $parsed_line {
      if {$piece != ""} {
	lappend adj_line $piece
      }
    }
    if {$adj_line == ""} {
      continue
    }
    set argv_0 [lindex $adj_line 0]
    if {[string index $argv_0 0] == "#"} {
      continue ; # comment.
    }
    set len [llength $line]
    if {$debug_flag} {
      puts stderr "line($cnt): $line args:$len"
    }
    if {$len < 2} {
      utdmsg errmsg $routine "Syntax error in $var_file on line $cnt\n"
      set need_to_exit true
      continue
    }
    set var_name [lindex $line 0]
    if {$var_name == "UTDunique"} {
      set var_type $var_name
      set var_name [lindex $line 1]
    } elseif {$var_name == "UTDexpr"} {
      set var_type $var_name
      set var_name [lindex $line 1]
    } elseif {$var_name == "UTDsource"} {
      set var_type $var_name
      set var_name source
      # puts stderr "UTDsource var_type:$var_type var_name:$var_name line:$line"
    } else {
      if {$len == 2} {
	set var_type list
      } else {
	set var_type bounds
      }
    }
    incr num_variables
    if {[catch {set status [$db eval {INSERT INTO variables VALUES(:num_variables,:var_name,:var_type,:line)}]} msg]} {
      puts stderr "msg:$msg database busy... waiting..."
    }
  }
  utdtools::db::close_db $db
}


global env
global max_problemsG

global argv
set max_problemsG 1
expr {srand(3)}
set problem ""
set debug_flag false
set database "tests.db"

set args [utdscript_args]
set args [string trimright $args]
set num_args [llength $args]
# puts stderr "num_args:$num_args a:$args"
if {$num_args < 1} {
  usage
  exit 0
}

set op ""
set libpath ""
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {($arg_el == "libpath") || ($arg_el == "-libpath") } {
    incr i
    if {$i >= $num_args} {
      puts stderr "not enough arguments to libpath"
      exit 1 ;
    }
    set libpath [lindex $args $i]
  } elseif {$op == ""} {
    set op $arg_el
  }
}

# puts stderr "op is $op"

# Set auto path
global autopath
utdtools::env_check true
# puts stderr "we get here auto_path:$auto_path\n"
if {$libpath != ""} {
  lappend auto_path $libpath
} else {
  lappend auto_path [pwd]
}

if {$op == "help"} {
  usage
  exit 0
} elseif {$op == "load"} {
  for {set i 1} {$i < $num_args} {incr i} {
    set arg_el [lindex $args $i]
    if {$arg_el == "debug" } {
      set debug_flag on
    } elseif {$arg_el == "database" } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to database"
	exit 1 ;
      }
      set database [lindex $args $i]
    }
  }
  utdtools::privilege
  load_problems $database $debug_flag
} elseif {$op == "list"} {
  set verbose_flag false
  for {set i 1} {$i < $num_args} {incr i} {
    set arg_el [lindex $args $i]
    if {$arg_el == "debug" } {
      set debug_flag on
    } elseif {($arg_el == "libpath") || ($arg_el == "-libpath") } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to libpath"
	exit 1 ;
      }
    } elseif {$arg_el == "database" } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to database"
	exit 1 ;
      }
      set database [lindex $args $i]
    }
  }
  list_problems $database $verbose_flag $debug_flag
} elseif {$op == "generate"} {
  set problem 0
  for {set i 1} {$i < $num_args} {incr i} {
    set arg_el [lindex $args $i]
    if {$arg_el == "debug" } {
      set debug_flag on
    } elseif {($arg_el == "libpath") || ($arg_el == "-libpath") } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to libpath"
	exit 1 ;
      }
      set libpath [lindex $args $i]
    } elseif {$arg_el == "database" } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to database"
	exit 1 ;
      }
      set database [lindex $args $i]
    } else {
      set problem $arg_el
    }
  }
  generate_instances $database $libpath $problem $debug_flag
} elseif {$op == "show"} {
  set inst 0
  for {set i 1} {$i < $num_args} {incr i} {
    set arg_el [lindex $args $i]
    if {$arg_el == "debug" } {
      set debug_flag on
    } elseif {($arg_el == "libpath") || ($arg_el == "-libpath") } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to libpath"
	exit 1 ;
      }
    } elseif {$arg_el == "database" } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to database"
	exit 1 ;
      }
      set database [lindex $args $i]
    } else {
      set inst $arg_el
    }
  }
  if {$inst == 0} {
    utdmsg errmsg autotest "no instance id furnished for show command.\n"
    exit 1
  }
  show_instance $database $inst $debug_flag

} elseif {$op == "generated"} {
  set type ""
  set verbose_flag false
  for {set i 0} {$i < $num_args} {incr i} {
    set arg_el [lindex $args $i]
    if {$arg_el == "debug" } {
      set debug_flag on
    } elseif {($arg_el == "libpath") || ($arg_el == "-libpath") } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to libpath"
	exit 1 ;
      }
    } elseif {$arg_el == "database" } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to database"
	exit 1 ;
      }
      set database [lindex $args $i]
    } elseif {$arg_el == "generated" } {
    } else {
      set type $arg_el
    }
  }
  show_types $database $type $debug_flag

} elseif {$op == "variables"} {
  set debug_flag false
  set var_filename ""
  for {set i 1} {$i < $num_args} {incr i} {
    set arg_el [lindex $args $i]
    if {$arg_el == "debug" } {
      set debug_flag on
    } elseif {($arg_el == "libpath") || ($arg_el == "-libpath") } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to libpath"
	exit 1 ;
      }
    } elseif {$arg_el == "database" } {
      incr i
      if {$i >= $num_args} {
	puts stderr "not enough arguments to database"
	exit 1 ;
      }
      set database [lindex $args $i]
    }
  }
  utdtools::privilege
  add_variables $database $var_filename $debug_flag

} else {
  usage
  exit 1
}

utdexit
