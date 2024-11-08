#
# $Id$
# $Log$
#
 
proc extract_id { fname } {
  set fidx [string first _attempt $fname]
  if {$fidx < 0} {
    return ""
  }
  incr fidx -1
  set startidx [expr $fidx - 8]
  set name [string range $fname $startidx $fidx]
  return $name

}

proc extract_shortname { fname } {
  set fidx [string first _attempt $fname]
  if {$fidx < 0} {
    return ""
  }
  set slen [string length $fname]
  incr fidx 9
  set str_start ""
  for {set c $fidx} {$c < $slen} {incr c} {
    set ch [string index $fname $c]
    # puts stderr "c:$c ch:$ch"
    if {$ch == "_"} {
      set str_start [expr $c + 1]
      break ;
    }
  }
  if {$str_start == ""} {
    return ""
  }
  set shortname [string range $fname $str_start end]
  return $shortname

}
 
set student_dir students
set files [glob -nocomplain "*"]
foreach f $files {
  set student_id [extract_id $f]
  puts stderr "sid: $student_id"

  if {$student_id != ""} {
    if {!([file exists $student_dir])} {
      file mkdir $student_dir
    }
    set full_student_dir [file join $student_dir $student_id]
    if {!([file exists $full_student_dir])} {
      file mkdir $full_student_dir
    }
    set short_name [extract_shortname $f]
    puts stderr "short_name: $short_name"
    set short_pathname [file join $full_student_dir $short_name]

    # puts stderr "file rename -force -- $f $short_pathname"
    file rename -force -- $f $short_pathname
  }
}
twexit 0
