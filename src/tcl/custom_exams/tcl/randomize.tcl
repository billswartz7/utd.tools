#
# $Id: randomize.tcl,v 1.7 2024/09/20 19:53:31 billswartz7 Exp $
# $Log: randomize.tcl,v $
# Revision 1.7  2024/09/20 19:53:31  billswartz7
# Updated for utdtools.
#
# Revision 1.6  2021/05/05 02:44:52  bill
# Remember of the item that we are processing for later
# lookup.
#
# Revision 1.5  2020/05/02 20:29:41  bill
# Added UTDsource command and added utility function rand_list_choice to
# allow extensive user programming.
#
# Revision 1.4  2020/05/02 18:56:22  bill
# Added better error messages for UTDexpr evaluation.
# Now allow a different vars_filename than the database
# file.
#
# Revision 1.3  2020/04/06 14:58:42  bill
# Added support for UTDexpr where a variable is the result of a calculation.
#
# Revision 1.2  2020/04/04 02:50:22  bill
# Added the UTDunique function which makes sure the choices are unique.
#
# Revision 1.1  2019/12/10 19:43:28  bill
# Initial revision
#
# Revision 1.1  2017/12/06 05:08:40  bill
# Initial revision
#
#

namespace eval utd {

  variable dataS 
  variable itemS 
  variable fieldS 
  variable lookupS 
  variable num_dataS 

  proc generate_header {fout type} {
    puts -nonewline $fout "<html>\n"
    puts -nonewline $fout "<head>\n"
    puts -nonewline $fout "<title>Randomly generated exam by $type</title>\n"
    puts -nonewline $fout "</head>\n"
    puts -nonewline $fout "<body bgcolor=\"#FFFFFF\">\n"
    puts -nonewline $fout "<h3>Randomly generated exam by $type</h3>\n"
    puts -nonewline $fout "<HR>\n"

  }

  proc generate_space {fields fout} {
    puts -nonewline $fout "<TR>\n"
    puts -nonewline $fout "</TR>\n\n"
  }

  proc generate_item {fields fout fout2 type item} {
    variable dataS 
    variable fieldS 

    puts -nonewline $fout "<TR>\n"
    puts -nonewline $fout2 "${item}"
    foreach field $fields {
      if {[info exists fieldS($field)]} {
	set idx $fieldS($field)
	set val $dataS($item,$idx)
      } else {
	if {[info exists dataS($item,$field)]} {
	  set val $dataS($item,$field)
	} else {
	  set val ""
	}
      }
      puts -nonewline $fout "<TD ALIGN=\"CENTER\" BGCOLOR=\"#C0C0C0\"><B>\n"
      puts -nonewline $fout "<FONT COLOR=\"#000080\">${val}</FONT></B></TD>\n"
      puts -nonewline $fout2 "\t"
      puts -nonewline $fout2 "${val}"
    }
    puts -nonewline $fout "</TR>\n\n"
    puts -nonewline $fout2 "\n"
  }

  proc generate_body {fields fout fout2 type} {
    variable dataS 
    variable fieldS 
    variable num_dataS 
    variable lookupS 
    variable numgroupS 

    puts -nonewline $fout "<TABLE BORDER=\"1\" ALIGN=\"CENTER\" "
    puts -nonewline $fout "CELLPADDING=\"5\" "
    puts -nonewline $fout "CELLSPACING=\"2\" BGCOLOR=\"#FFFFFF\">\n"
    puts -nonewline $fout "<TR>\n"
    puts -nonewline $fout2 "Index"
    foreach field $fields {
      puts -nonewline $fout "<TD ALIGN=\"CENTER\" BGCOLOR=\"#C0C0C0\"><B>\n"
      puts -nonewline $fout "<FONT COLOR=\"#000080\">${field}</FONT></B></TD>\n"
      puts -nonewline $fout2 "\t"
      puts -nonewline $fout2 "${field}"
    }
    puts -nonewline $fout "</TR>\n"
    puts -nonewline $fout2 "\n"
    for {set item 1} {$item <= $num_dataS} {incr item} {
      generate_item $fields $fout $fout2 $type $item
    }

  }
  proc generate_trailer {fout type} {
    puts $fout "</body>"
    puts $fout "</html>"
  }


  proc generate_html {basename fields type} {
    set routine generate_html
    set count 1
    while {1} {
      set fname "${basename}.data.${count}.html"
      if {!([file exists $fname])} {
	break ;
      }
      incr count
    }
    utdmsg imsg $routine "Creating file:$fname\n"
    set fout [open $fname "w"]
    if {$fout == ""} {
      utdmsg errmsg $routine "Could not open file:$fname\n"
      return ;
    }
    set fname2 "${basename}.data.${count}.csv"
    utdmsg imsg $routine "Creating file:$fname2\n"
    set fout2 [open $fname2 "w"]
    if {$fout2 == ""} {
      utdmsg errmsg $routine "Could not open file:$fname2\n"
      return ;
    }
    set fname3 "${basename}.data.${count}.sql"

    generate_header $fout $type
    generate_body $fields $fout $fout2 $type
    generate_trailer $fout $type
    generate_sql $fname3 $fields

    close $fout
    close $fout2
    return $fname
  }

  proc generate_sql {fname fields} {
    set routine "generate_sql"
    utdmsg imsg $routine "Creating file:$fname\n"
    set fout [open $fname "w"]
    if {$fout == ""} {
      utdmsg errmsg $routine "Could not open file:$fname\n"
      return ;
    }
    puts -nonewline $fout "CREATE TABLE exam(`Index` int"
    foreach field $fields {
      puts -nonewline $fout ",`${field}` text"
    }
    puts -nonewline $fout ")\n"

    close $fout

  } 

  proc chose_fields {fields csv_line} {
    variable fieldS 

    set len [llength $csv_line]
    foreach defined_field $fields {
      for {set i 0} {$i < $len} {incr i} {
	set f [lindex $csv_line $i]
	set cval [string compare $f $defined_field]
	if {$cval == 0} {
	  set fieldS($f) $i
	}
      }
    }
  }


  proc read_csv { filename var_file fields args } {
    variable dataS 
    variable itemS 
    variable fieldS 
    variable num_dataS 

    package require csv

    set debug_flag 0
    set routine "utd::read_csv"
    utdmsg imsg $routine "Welcome to the Random Team Builder program\n\n"

    if {$filename == ""} {
      utdmsg errmsg $routine "No file name specified.\n"
      return ;
    }
    set f [open $filename "r"]
    if {$f == ""} {
      utdmsg errmsg $routine "Could not open file:$filename\n"
      exit 1 ;
    }
    set file_data [read $f]
    close $f
    set rootname [file rootname $filename]


    # Break data into lines
    set lines [split $file_data "\r\n"]
    if {$debug_flag} {
      set cnt 0
      foreach line $lines {
	incr cnt
	puts stderr "line($cnt): $line"
      }
    }

    # variables to control parsing
    set first_line [lindex $lines 0]
    set parsed_line [::csv::split $first_line]
    set len [llength $parsed_line]
    if {$debug_flag} {
      puts "first line len:$len parsed_line: $parsed_line"
    }
    chose_fields $fields $parsed_line

    if {$debug_flag} {
      puts stderr "array: [array get fieldS]"
    }

    # Now process the file
    set lcount 0
    set num_dataS 0
    set items [array names fieldS]
    foreach line $lines {
      incr lcount
      if {$lcount == 1} {
	continue  ;
      }
      set parsed_line [::csv::split $line]
      if {$parsed_line != ""} {
	incr num_dataS
	foreach item $items {
	  set idx $fieldS($item)
	  set dataS($num_dataS,$idx)  [lindex $parsed_line $idx]
	}
      }
    }
    utdmsg imsg null "Total data items read: $num_dataS\n"

    if {$var_file == ""} {
      set var_file "${rootname}.vars"
    }
    utdmsg imsg null "Trying to read $var_file..."
    if {[file exists $var_file]} {
      utdmsg imsg null "exists.  Good!\n" 
    } else {
      utdmsg imsg null "Does not exists. Must abort!\n" 
      exit 1
    }
    set fvars [open $var_file "r"]
    if {$fvars == ""} {
      utdmsg errmsg $routine "Could not open file:$var_file\n"
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
	set var_name [lindex $line 1]
	set lo [lindex $line 2]
	set hi [lindex $line 3]
	for {set i $lo} {$i <= $hi} {incr i} {
	  set vname "${var_name}${i}"
	  lappend fields $vname
	  lappend keys $vname
	  set key_data(op,$vname) unique
	  set key_data(id,$vname) [list $var_name $i $lo]
	  set key_data(values,$vname) [lindex $line 4]
	}
      } elseif {$var_name == "UTDexpr"} {
	set var_name [lindex $line 1]
	set exp [lindex $line 2]
	set key_data(op,$var_name) expr
	set key_data(expr,$var_name) $exp
	lappend fields $var_name
	lappend keys $var_name
      } elseif {$var_name == "UTDsource"} {
	set source_filename [lindex $line 1]
	puts stderr "sourcing user file: $source_filename..."
	if {!([file exists $source_filename])} {
	  twmessage errmsg $routine "file:$source_filename does not exist.\n\n"
	  exit 1
	}
	source $source_filename
      } else {
	lappend fields $var_name
	lappend keys $var_name
	if {$len == 2} {
	  # We assume a list
	  set key_data(op,$var_name) list
	  set key_data(values,$var_name) [lindex $line 1]
	} else {
	  set key_data(op,$var_name) bounds
	  set key_data(lower_expr,$var_name) [lindex $line 1]
	  set key_data(upper_expr,$var_name) [lindex $line 2]
	}
      }
    }

    puts stderr "arr: [array get key_data]"

    # Now create the random data.
    for {set i 1} {$i <= $num_dataS} {incr i} {
      # Remember what we are processing for lookup.
      set itemS $i
      foreach vname $keys {
	set op $key_data(op,$vname)
	# puts stderr "vname:$vname op: $op"
	if {$op == "list"} {
	  set ldata $key_data(values,$vname)
	  set data_len [llength $ldata]
	  set max_data [expr $data_len - 1]
	  set data_idx [rand_range 0 $max_data]
	  set val [lindex $ldata $data_idx]
	  set $vname $val
	  set dataS($i,$vname) $val
	} elseif {$op == "bounds"} {
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
	} elseif {$op == "unique"} {
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
	} elseif {$op == "expr"} {
	  set e_expr $key_data(expr,$vname)
	  if {[catch {set val [eval $e_expr]} result_msg]} {
	    puts stderr "ERROR: $result_msg"
	    set val -1
	  }
	  set $vname $val
	  set dataS($i,$vname) $val
	} else {
	  utdmsg errmsg $routine "unknown operation:$op\n"
	}
      }

      # set val [rand_range 8 12]
      # set dataS($i,Bits) $val
      # set full_count [expr pow(2,$val)]
      # set half_count [expr pow(2,$val)/2]
      # set count [rand_range $half_count $full_count]
      # set dataS($i,Count) [expr int($count)]
      # set ref [rand_range 3 15]
      # set dataS($i,Reference) ${ref}
    }

    if ${need_to_exit} {
      exit 1
    }

    set name_fname [generate_html $rootname $fields name]
    if {$name_fname != ""} {
      convert_to_pdf $name_fname
    }
  }

  proc rand_range {min max} { 
    return [expr int(rand()*($max-$min+1)) + $min] 
  }

  proc lookup {vname} {
    variable dataS
    variable itemS
    if {[info exists dataS($itemS,$vname)]} {
      return $dataS($itemS,$vname)
    }
    return ""
  }

  proc rand_list_choice {ldata} {
    set data_len [llength $ldata]
    set max_data [expr $data_len - 1]
    set data_idx [rand_range 0 $max_data]
    set val [lindex $ldata $data_idx]
    return $val
  }

  proc convert_to_pdf {filename} {
    global env
    global argv
    set routine "::utd::convert_to_pdf"
    set pgm htmldoc

    set basename [file rootname $filename]
    set outname "${basename}.pdf"

    set cmd "$pgm --no-title --webpage $filename -f $outname"

    if {[catch {eval exec $cmd} result_msg]} {
      utdmsg imsg $routine ": $result_msg\n"
    }
  }

  proc opt_seed {basename} {
    # Look for .seed file
    set seed 0
    set seed_file ${basename}.seed
    if {[file exists $seed_file]} {
      puts stderr "reading seed file:$seed_file..."
      set f [open $seed_file "r"]
      if {$f == ""} {
	utdmsg errmsg $routine "Could not open file:$seed_file\n"
	exit 1 ;
      }
      set file_data [read $f]
      close $f
      set lines [split $file_data "\r\n"]
      foreach line $lines {
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
	set len [llength $adj_line]
	if {$len < 2} {
	  continue
	}
	set seed [lindex $adj_line 1]
      }
      if {$seed > 0} {
	puts stderr "setting random seed to $seed...\n"
	expr srand($seed)
      }
    }
  }

}

# wm withdraw .
# define the fields
lappend fields {Last Name}
lappend fields {First Name}
lappend fields {Username}

expr {srand(3)}
set filename ""

global argv
set args $argv
set args [utdscript_args]

set vars_filename ""
set num_args [llength $args]
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debug_flag on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  randomize <CSVfilename>\n\n"
    exit 0
  } elseif {$filename == ""} {
    set filename $arg_el
  } else {
    set vars_filename $arg_el
  }
}
set basename [file rootname $filename]

global autopath
utdtools::env_check true

utd::opt_seed $basename
utd::read_csv $filename $vars_filename $fields

puts stderr "\nYou should next run loadsql to build the database:\n"
set count 1
while {1} {
  set fname "${basename}.data.${count}.csv"
  if {!([file exists $fname])} {
    break ;
  }
  incr count
}
incr count -1
puts stderr "   loadsql ${basename}.data.${count}.csv\n\n"
utdexit
