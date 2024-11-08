
package require Markdown 1.1.1

proc convert_md {file_data} {
  set html [::Markdown::convert $file_data]
  return $html
}


set fd [open README.md r]
if {$fd == ""} {
  twmsg errmsg mconvert "could not open README.md for reading.\n"
  exit 1
}

set fdata [read $fd]
close $fd

set html [convert_md $fdata]
set fout [open README.html w]

if {$fout == ""} {
  twmsg errmsg mconvert "could not open README.html for writing.\n"
  exit 1
}
puts $fout "<HTML>"
puts $fout "<HEAD>"
puts $fout "<TITLE>UTDTOOLS</TITLE>"
puts $fout "</HEAD>"
puts $fout "<BODY TEXT=\"#000010\" BGCOLOR=\"#FFFFFF\" LINK=\"#0000EE\" VLINK=\"#551A8B\" ALINK=\"#FF0000\">"
puts $fout $html
puts $fout "</BODY>"
puts $fout "</HTML>"
close $fout
