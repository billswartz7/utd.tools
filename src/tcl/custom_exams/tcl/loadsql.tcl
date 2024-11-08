#
# $Id: loadsql.tcl,v 1.1 2020/04/06 14:59:52 bill Exp bill $
# $Log: loadsql.tcl,v $
# Revision 1.1  2020/04/06 14:59:52  bill
# Initial revision
#
#

namespace eval utd {

  proc create_tab_separated_file {csv_file tsv_file} {
    # This is a stupid file which is only momentarily exists
    # We want to document fields in the .csv but the copy
    # command treats the header as data so we just ignore the
    # first line and copy out the data.
    set fin [open $csv_file "r"]
    if {$fin == ""} {
      utdmsg errmsg $routine "could not open $csv_file for reading...\n"
      exit 1
    }
    set fout [open $tsv_file "w"]
    if {$fout == ""} {
      utdmsg errmsg $routine "could not open $tsv_file for writing...\n"
      exit 1
    }
    set file_data [read $fin]
    close $fin

    set lines [split $file_data "\r\n"]
    set cnt 0
    foreach line $lines {
      incr cnt
      if {$cnt == 1} {
	continue 
      }
      if {$line == ""} {
	continue
      }
      puts $fout $line
    }
    close $fout
  }

  proc load_sql {filename} {
    global env
    global argv
    global autopath
    set routine "::utd::convert_to_pdf"
    utdtools::env_check true
    package require sqlite3
    set rootname [file rootname $filename]
    set sql_file "${rootname}.sql"
    set db_file "${rootname}.db"
    set csv_file "${rootname}.csv"
    set tsv_file "${rootname}.tsv"

    sqlite3 exam $db_file -create true
    exam eval [exec cat $sql_file]
    create_tab_separated_file $csv_file $tsv_file
    exam copy replace exam $tsv_file

    exam close
  }

}

set filename ""
global argv
set args $argv
set args [utdscript_args]
set num_args [llength $args]
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debug_flag on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  loadsql <CSVfilename>\n\n"
    exit 0
  } else {
    set filename $arg_el
  }
}

utd::load_sql $filename

set basename [file rootname $filename]
puts stderr "\nYou should next run build_exam to build the exams:\n"
puts stderr "   build_exams ${basename}.db\n\n"
utdexit
