#
# $Id: mail_exams.tcl,v 1.1 2020/04/06 14:59:26 bill Exp $
# $Log: mail_exams.tcl,v $
# Revision 1.1  2020/04/06 14:59:26  bill
# Initial revision
#
#

namespace eval utd {

  proc basename {full_filename} {
    set idx [string first . $full_filename 0]
    if {$idx >= 0} {
      incr idx
      set last_idx [string first . $full_filename $idx]
      if {$last_idx >= 0} {
	incr last_idx -1
      } else {
	set last_idx end
      }
      set full_filename [string range $full_filename $idx $last_idx]
    } 
    return $full_filename
  }

  proc mail_the_file {user file_to_mail} {
    set routine "mail_the_file"
    set program sendit
    set pgm [file join . $program]

    set cmd "$pgm $user $file_to_mail"
    puts stderr "cmd: $cmd"

    if {[catch {eval exec $cmd} result_msg]} {
      icmessage imsg $routine ": $result_msg\n"
    }
  }

}


global argv
set directory ""
set routine "mail_exams"
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
    icmessage imsg null "  mail_exams <directory>\n\n"
    exit 0
  } else {
    set directory $arg_el
  }
}

if {$directory == ""} {
  icmessage errmsg $routine "directory not given\n"
  exit 1
}

if {!([file exists $directory])} {
  icmessage errmsg $routine "directory $directory does not exist!\n\n"
  exit 1
}


foreach fname [glob -nocomplain -directory ${directory} *.pdf] {
  puts stderr "file: $fname"
  set user [utd::basename $fname]
  puts stderr "user: $user"
  utd::mail_the_file $user $fname
}

icexit
