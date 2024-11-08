#
# $Id: delete_elearning_txt.tcl,v 1.1 2021/03/27 14:09:47 bill Exp $
# $Log: delete_elearning_txt.tcl,v $
# Revision 1.1  2021/03/27 14:09:47  bill
# Initial revision
#
#
#
#
#
set files [glob -nocomplain "*202\[0-9]-*\[0-9]*-\[0-9]*-\[0-9]*-\[0-9]*-\[0-9]*.txt"]
foreach f $files {
  # See if this is a valid candidate
  set fp [open $f r]
  set delete_file false
  if {$fp != ""} {
    set file_data [read $fp]
    close $fp
    set lines [split $file_data "\r\n"]
    set line1 [lindex $lines 0]
    set keyword "Name:"
    set keylen [string length $keyword]
    if {[string compare -length $keylen $line1 $keyword] == 0} {
      set line2 [lindex $lines 1]
      set keyword "Assignment:"
      set keylen [string length $keyword]
      if {[string compare -length $keylen $line2 $keyword] == 0} {
	set delete_file true
      }
    }
  }
  if {$delete_file} {
    file delete -force $f
  } else {
    twmessage imsg null "keeping non-elearning file:$f\n"
  }
}
twexit 0
