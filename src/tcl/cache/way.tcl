# $Log: way.tcl,v $
# Revision 1.3  2020/05/03 20:13:53  bill
# Improved the way display so we can see words and instruction cache 
# does not need a dirty bit.
#
#

namespace eval utdcache {
  variable regfile_vals

  proc display_way {way type} {
    variable ilineS
    variable dlineS
    variable ilinesizeS
    variable dlinesizeS

    set w .utdway_${type}_${way}

    # Now see if choose dialog exists.
    if {[winfo exists $w]} {
      wm withdraw $w
      wm deiconify $w
      return ;
    }

    toplevel $w  \
      -background {lightgray} \
      -highlightbackground {lightgray}

    # Window manager configurations
    wm minsize $w 32 20
    wm sizefrom $w program
    wm positionfrom $w program
    if {$type == "d"} {
      wm title $w "Data Cache Way $way"
      set linesize $dlinesizeS
      set lines $dlineS
      set cachename d${way}
    } else {
      wm title $w "Instruction Cache Way $way"
      set linesize $ilinesizeS
      set lines $ilineS
      set cachename i${way}
    }
    # We create the frame and the two ScrolledListBox widgets
    # at the top of the dialog box
    #
    set fdata [frame $w.regfile -relief raised -bd 1]

    package require tablelist

    option add *datapath.tbl.activeStyle  frame
    option add *datapath.tbl.setGrid      yes
    option add *datapath.tbl.background   gray96
    option add *datapath.tbl.stripeBackground  #e0e8f0
    option add *datapath.tbl*selectBackground navy
    option add *datapath.tbl*selectForeground white
    option add *datapath.tbl*Entry.background ivory

    set tbl $fdata.tbl
    set vsb $fdata.vsb
    set hsb $fdata.hsb
    if {$type == "d"} {
      set fields {0 "Line Number" right  0 "Valid" center 10 "Dirty" center 10 "Tag" right 5 "Data:" center}
    } else {
      set fields {0 "Line Number" right  0 "Valid" center 10 "Tag" right 5 "Data:" center}
    }
    set max_byte [expr {$linesize -1}]
    for {set byte 0} {$byte <= $max_byte} {incr byte} {
      set fields [concat $fields "0 $byte center"]
    }

    tablelist::tablelist $tbl -columns $fields -width 80 -height 18 \
      -labelcommand tablelist::sortByColumn \
      -xscrollcommand [list $hsb set] -yscrollcommand [list $vsb set]
    scrollbar $vsb -orient vertical   -command [list $tbl yview]
    scrollbar $hsb -orient horizontal -command [list $tbl xview]
    way_build $type $tbl $cachename $lines $linesize

    grid $tbl -row 0 -column 0 -sticky news
    grid $vsb -row 0 -column 1 -sticky ns
    grid $hsb -row 1 -column 0 -sticky ew
    grid rowconfigure    $fdata 0 -weight 1
    grid columnconfigure $fdata 0 -weight 1
    grid propagate $fdata 1 
    pack $w.regfile -side top -anchor w -padx 0 -fill both -expand yes

  }

  proc way_build {type tbl name lines linesize} {
    variable max_rangeS
    variable $name

    if {$type == "d"} {
      $tbl columnconfigure 0 -name valid
      $tbl columnconfigure 1 -name dirty
      $tbl columnconfigure 2 -name tag
      $tbl columnconfigure 3 -name data
    } else {
      $tbl columnconfigure 0 -name valid
      $tbl columnconfigure 1 -name tag
      $tbl columnconfigure 2 -name data
    }

    # First build the data
    for {set line 0} {$line < $lines} {incr line} {
      for {set byte [expr $linesize-1]} {$byte >= 0} {incr byte -1} {
	if {!([info exists ${name}($line,$byte)])} {
	  set new_data [rand_range 0 255]
	  set new_hex_data [format %02X $new_data]
	  set new_byte_val "0x${new_hex_data}"
	  set ${name}($line,$byte) $new_byte_val
	  set dirty_bit [rand_range 0 1]
	  set ${name}($line,dirty) $dirty_bit
	  if {($dirty_bit)} {
	    set valid_bit 1
	  } else {
	    set valid_bit [rand_range 0 1]
	  }
	  set ${name}($line,valid) $valid_bit
	  set new_tag [rand_range 0 $max_rangeS]
	  set new_hex_tag [format %02X $new_tag]
	  set new_tag_val "0x${new_hex_tag}"
	  set ${name}($line,tag) $new_tag_val
	}
      }
    }
    # Now add to the table
    # Build a line showing the description of the words.
    if {$type == "d"} {
      set linedata [list "" "" "" "" "Word"]
    } else {
      set linedata [list "" "" "" "Word"]
    }
    set word_size [::utdcache::get_machine_size]
    set word_idx 0
    for {set b 0} {$b < $linesize} {incr b} {
      set offset [expr {$b % $word_size}]
      if {$offset == 0} {
	lappend linedata $word_idx
	incr word_idx
      } else {
	lappend linedata ""
      }
    }
    $tbl insert end $linedata
    # Now add the lines
    for {set line 0} {$line < $lines} {incr line} {
      set valid [set ${name}($line,valid)]
      set dirty [set ${name}($line,dirty)]
      set tag [set ${name}($line,tag)]
      if {$type == "d"} {
	set linedata [list $line $valid $dirty $tag ""]
      } else {
	set linedata [list $line $valid $tag ""]
      }
      for {set byte [expr $linesize-1]} {$byte >= 0} {incr byte -1} {
	set byte_data [set ${name}($line,$byte)]
	set linedata [concat $linedata $byte_data]
      }
      $tbl insert end $linedata
    }
  }


}
