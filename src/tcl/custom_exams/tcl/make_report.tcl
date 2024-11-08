#
# $Id: make_report.tcl,v 1.1 2021/03/27 14:12:13 bill Exp $
# $Log: make_report.tcl,v $
# Revision 1.1  2021/03/27 14:12:13  bill
# Initial revision
#
#
#
#
#
global argv
global env

if {[info exists env(UTDEXAMS)]} {
  set utdexams $env(UTDEXAMS)
} else {
  puts stderr "ERROR:cannot get the environment variable:UTDEXAMS"
  exit 1
}

set src_name [file join $utdexams tcl report.tcl]
source $src_name

set filename ""
set output_dir ""
set args $argv
set num_args [llength $args]
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "debug" } {
    set debug_flag on
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "help" } {
    icmessage imsg null "Usage:\n"
    icmessage imsg null "  make_report <file> [output_dir]\n\n"
    exit 0
  } elseif {$filename == ""} {
    set filename $arg_el
  } else {
    set output_dir $arg_el
  }
}

set fin [open $filename "r"]
if {$fin == ""} {
  twmessage errmsg $routine "could not open $filename for reading...\n"
  exit 1
}
set file_data [read $fin]
close $fin

set basename [file rootname $filename]

set html_name [utd::report_create_html $basename $basename $file_data]

if {$html_name != ""} {
  utd::report_convert_to_pdf $html_name
}

icexit

utd::opt_seed $basename
