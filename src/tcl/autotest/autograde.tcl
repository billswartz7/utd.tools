#
# $Id$
# $Log$
#
#
proc extract_file_checks { def } {
  global num_lib_checksG
  global num_file_checksG
  global filecheckG
  global libcheckG
  set lines [split $def "\r\n"]
  set num_lib_checksG 0
  set num_file_checksG 0
  foreach line $lines {
    set startidx 0
    incr lcount
    set line_len [string len $line]
    set end_idx [expr $line_len - 1]

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

    if {$argv_0 == "FILECHECK"} {
      set fchr [string index $line 0]
      if {$fchr == "\{" } {
	set filecheck [string range $line 11 end]
      } else {
	set filecheck [string range $line 10 end]
      }
      incr num_file_checksG
      set filecheckG($num_file_checksG) $filecheck
      # puts stderr "filecheck set to $filecheck"
      continue
    } elseif {$argv_0 == "LIBCHECK"} {
      set fchr [string index $line 0]
      if {$fchr == "\{" } {
	set libcheck [string range $line 10 end]
      } else {
	set libcheck [string range $line 9 end]
      }
      incr num_lib_checksG
      set libcheckG($num_lib_checksG) $libcheck
      # puts stderr "libcheck set to $libcheck"
      continue
    }
  }
}

global env

set instance ""
set routine autograde
set database "tests.db"
set args [utdscript_args]
# puts stderr "raw args: $args"
set args [string trimright $args]
set num_args [llength $args]
set single_item false
set libpath ""
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debug_flag on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "libpath" } {
    incr i
    if {$i < $num_args} {
      set libpath [lindex $args $i]
      utdmsg imsg $routine "Library path set to: $libpath\n"
      set database [file join $libpath $database]
    } else {
      utdmsg errmsg $routine "Missing argument to -libpath\n"
      return ;
    }
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  autograde \[help]\n"
    utdmsg imsg null "  autograde <instance #> : grade a given problem instance\n\n"
    utdmsg imsg null "  autograde <instance #> <SQLdatabase> : grade a problem problem using named database.\n"
    exit 0
  } elseif {$instance == ""} {
    set instance $arg_el
    puts stderr "instance:$instance"
  } else {
    set database $arg_el
    puts stderr "database:$database"
  }
}

# Set auto path
global autopath
global num_lib_checksG
global num_file_checksG
global filecheckG
global libcheckG

utdtools::env_check true
if {$libpath != ""} {
  lappend auto_path $libpath
} else {
  lappend auto_path [pwd]
}

if {$instance == ""} {
  utdmsg errmsg null "Instance number must be specified.\n"
  exit 1
}

puts stdout "\nAutograder version 1.0\n"

set db [utdtools::db::open_db $database -nocreate]
if {$db == ""} {
  utdmsg errmsg $routine "cannot open database $database\n\n"
  exit 1
}
set num_items [utdtools::db::num_items $db instances]
if {($instance < 0) || ($instance > $num_items)} {
  utdmsg errmsg $routine  "instance $instance is out of bounds.\n"
  utdmsg errmsg null "There are only $num_items problem instances.\n\n"
  exit 1
}

# Now determine the problem from the instance
set problem [utdtools::db::get_index_field $db instances problem $instance]
set definition [utdtools::db::get_index_field $db instances definition $instance]
set file_checks [extract_file_checks $definition]

set basename problem${problem}
set ccode_base_name "${basename}.c"
set cppcode_base_name "${basename}.cpp"
set ccode_name [file join [pwd] $ccode_base_name]
set topdir graded.${basename}
set exam_dir work
set report_dir reports
set ansdir answers

# Now get data from the user.
fconfigure stdin -blocking on

for {set f 1} {$f <= $num_file_checksG} {incr f} {
  set file_check_data $filecheckG($f)
  set file_type [lindex $file_check_data 0]
  puts -nonewline stdout "Enter your $file_type:"
  flush stdout
  set user_fname [gets stdin]
  set shortname [file tail $user_fname]
  flush stdout
  puts -nonewline stdout "Checking to see if file exists..."
  flush stdout
  if {[file exists $user_fname]} {
    puts stdout "yes."
    set p2 0
    set file_copy($f) $user_fname
  } else {
    puts stdout "no."
    set p2 1
  }
}
puts -nonewline stdout "Checking to see if main program file has correct name..."
if {($shortname != $ccode_base_name) && ($shortname != $cppcode_base_name)} {
  puts stdout "no."
  flush stdout
  utdmsg errmsg null "invalid name for program filename\n"
  utdmsg errmsg null "looking for $ccode_base_name or $cppcode_base_name\n"
  set p2 2
}
puts stdout "yes."
puts -nonewline stdout "Enter your Makefile filename:"
flush stdout
set user_Makename [gets stdin]
set Mshortname [file tail $user_Makename]
flush stdout
puts -nonewline stdout "Checking to see if file exists..."
flush stdout
if {[file exists $user_Makename]} {
  puts stdout "yes."
  set p1 0
  incr f
  set file_copy($f) $user_Makename
} else {
  puts stdout "no."
  set p1 1
}

puts -nonewline stdout "Checking to see if file has correct name..."
if {($Mshortname != "Makefile") && ($Mshortname != "makefile")} {
  puts stdout "no."
  flush stdout
  set p1 2

  utdmsg errmsg null "invalid name for Makefile filename\n"
  utdmsg errmsg null "looking for Makefile or makefile\n"
  set needs_make_alias true
} else {
  puts stdout "yes."
  set needs_make_alias false
}

puts -nonewline stdout "Determining user id..."
flush stdout
set userid [exec whoami]
puts stdout "$userid."

set cur_wd [pwd]
puts -nonewline stdout "Is current directory $cur_wd writable by $userid..."
set dir_write [file writable $cur_wd]
if {$dir_write} {
  puts stdout "yes."
} else {
  puts stdout "no."
}
if {$libpath != ""} {
  set homedir $libpath
} else {
  set homedir [pwd]
}
set home_ansdir [file join $homedir answers]

set basedir [pwd]
if {[file exist $topdir]} {
  catch {exec /bin/rm -rf $topdir}
}
file mkdir $topdir
# Will need to change these afterwards
file mkdir [file join $topdir $exam_dir]
file mkdir [file join $topdir $ansdir]
file mkdir [file join $topdir $report_dir]

set abs_topdir [file join $basedir $topdir]
set abs_examdir [file join $basedir $topdir $exam_dir]
set abs_ansdir [file join $basedir $topdir $ansdir]
set abs_reportdir [file join $basedir $topdir $report_dir]
puts stderr "top: $abs_topdir"
puts stderr "exam: $abs_examdir"
puts stderr "answer: $abs_ansdir"
puts stderr "report: $abs_reportdir"

# cd $exam_dir
 # Create a link to the libraries
 #if {[catch {file link -symbolic lib ../../program/lib} result_msg]} {
 #   puts stderr "ERROR creating link to lib"
 #}
# cd ../

set report_filename [file join $abs_reportdir report.${basename}.txt]
set freport [open $report_filename "w"]

set answer_pgm [utdtools::program::prepare_solution $db ${basename}.tmpl $home_ansdir $abs_ansdir $instance]
puts stderr "answer_pgm:$answer_pgm"
set answer [utdtools::program::compile_solution $abs_ansdir $answer_pgm]
set answer [utdtools::program::reduce_answer $answer]
puts stderr "desired answer:$answer"

# Now prepare the users solution
if {[info exists file_copy]} {
  set file_data [array get file_copy]
  foreach {f user_path} $file_data {
    file copy -force $user_path $abs_examdir
  }
}

cd $abs_examdir
set problems 0
set suffix [file extension $shortname]
if {($suffix == ".cpp") || ($suffix == ".cxx")} {
  set cplusplus_flag true
} else {
  set cplusplus_flag false
}

# Now try to compile program.
set p3 [utdtools::program::compile_check $Mshortname $shortname $basename]

# Look for existance of program
set p6 [utdtools::file_exists $basename]


set p5 -1
if {($p6)} {
  if {$cplusplus_flag} {
    set p5 [utdtools::program::answer_makefile $home_ansdir $basename M.${basename}]
  } else {
    set p5 [utdtools::program::answer_makefile $home_ansdir $basename Makefile.${basename}]
  }
  set p6 [utdtools::file_exists $basename]
}

# Is program executable 
set p7 [utdtools::file_executable $basename]

# Perform any library checks.
for {set f 1} {$f <= $num_lib_checksG} {incr f} {
  set lib_data $libcheckG($f)
  set lib_type [lindex $lib_data 0]
  puts stderr "looking for $lib_type..."
}

# Is program answer correct
set p8 [utdtools::program::file_answer $basename $answer student_answer raw_answer match_id]
if {($p8)} {
  set student_answer [utdtools::program::reduce_answer $student_answer]
  puts stderr "modified answer: $student_answer"
  set p8 [utdtools::program::file_answer $basename $answer student_answer raw_answer match_id]
}

set secs [clock seconds]
set todays_date [clock format $secs]

puts $freport "User: $userid"
puts $freport "Date: $todays_date"
puts $freport "Does Makefile exists? [utdtools::program::explain $p1] ($p1)"
puts $freport "Does $ccode_base_name or $cppcode_base_name exists? [utdtools::program::explain $p2] ($p2)"
puts $freport "Does makefile execute? [utdtools::program::explain $p3] ($p3)"
if {$cplusplus_flag} {
  puts $freport "Is the program C++? yes"
} else {
  puts $freport "Is the program C++? no"
}
puts $freport "Will the source compile with proper Makefile? [utdtools::program::explain $p5] ($p5)"
puts $freport "Is the program process generated? [utdtools::program::explain $p6] ($p6)"
puts $freport "Is the program process executable? [utdtools::program::explain $p7] ($p7)"
puts $freport "Does Program gives correct data? [utdtools::program::explain $p8] ($p8) match id:$match_id"
puts $freport "Correct answer:$answer"
if {($p8)} {
  if {$student_answer != ""} {
    puts $freport "Your answer:\'$student_answer\' (modified)"
  }
  puts $freport "Your raw answer:$raw_answer"
} else {
  puts $freport "Your answer:\'$student_answer\'"
}
# Calculate grade
set mistakes 0
if {$p8 == 2} {
  puts $freport "Imprecise answer: -1"
  incr mistakes -1
} elseif {$p8 == 1} {
  puts $freport "Wrong answer: -3"
  incr mistakes -3
}
if {$p7} {
  puts $freport "Program is not executable: -5"
  incr mistakes -5
}
if {$p6} {
  puts $freport "Program is not generated: -5"
  incr mistakes -5
}
if {$p5 != -1} {
  if {$p5} {
    puts $freport "Program won't compile with proper Makefile: -5"
    incr mistakes -5
  }
}
if {$p3} {
  puts $freport "Makefile doesn't execute: -5"
  incr mistakes -5
}
if {$p2} {
  puts $freport "Code doesn't exist: -5"
  incr mistakes -5
}
if {$p1} {
  puts $freport "Makefile doesn't exist: -5"
  incr mistakes -5
}
set grade [expr 40 + $mistakes]
puts $freport "Your grade: $grade out of 40"
puts $freport "# -------------------------------\n\n"
close $freport

puts stderr "Displaying report:$report_filename:\n"
set f [open $report_filename "r"]
if {$f == ""} {
  utdmsg errmsg $routine "Could not open file:$fname\n"
  exit 1 ;
}
set file_data [read $f]
close $f
puts stderr "$file_data\n"
flush stdout

utdtools::db::close_db $db
utdexit
