#
# $Id: cleanup_exams.tcl,v 1.1 2021/05/05 02:45:35 bill Exp $
# $Log: cleanup_exams.tcl,v $
# Revision 1.1  2021/05/05 02:45:35  bill
# Initial revision
#

global argv
expr {srand(3)}
set routine "cleanup_exams"
set filename ""
set vars_filename ""
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
    icmessage imsg null "  $routine <CSVfilename>\n\n"
    exit 0
  } elseif {$filename == ""} {
    set filename $arg_el
  } else {
    set vars_filename $arg_el
  }
}
set basename [file rootname $filename]
set suffix [file extension $filename]
if {$suffix != ".csv"} {
  twmessage errmsg $routine "file needs to be the root csv file.\n"
  twexit 1
}

set files [glob -nocomplain ${basename}.data.*]
set old_files [glob -nocomplain *~]
lappend files $old_files
lappend files exams
puts stderr "files to delete:$files"
foreach fname $files {
  if {[catch {file delete -force -- $fname} result_msg]} {
    icmessage errmsg $routine "An error occurred deleting $fname.\n$result_msg\n\n"
  }
}
icexit
