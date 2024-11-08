
namespace eval utdcache {
  variable regfile_vals

  proc display_regfile {args} {
    set w .utdregfile

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
    wm title $w {Register File}
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
    set fields {0 "Register" left 10 "Alias" center 10 "Value" center 40 "Usage" center}

    tablelist::tablelist $tbl -columns $fields -width 80 -height 18 \
      -labelcommand tablelist::sortByColumn \
      -xscrollcommand [list $hsb set] -yscrollcommand [list $vsb set]
    scrollbar $vsb -orient vertical   -command [list $tbl yview]
    scrollbar $hsb -orient horizontal -command [list $tbl xview]
    regfile_build $tbl

    $tbl columnconfigure 2 -name value -editable yes 
    $tbl configure -editstartcommand ::utdcache::edit_start
    $tbl configure -editendcommand ::utdcache::update_check

    grid $tbl -row 0 -column 0 -sticky news
    grid $vsb -row 0 -column 1 -sticky ns
    grid $hsb -row 1 -column 0 -sticky ew
    grid rowconfigure    $fdata 0 -weight 1
    grid columnconfigure $fdata 0 -weight 1
    grid propagate $fdata 1 
    pack $w.regfile -side top -anchor w -padx 0 -fill both -expand yes

  }

  proc regfile_build {tbl} {
    $tbl columnconfigure 0 -name name
    $tbl columnconfigure 1 -name alias
    $tbl columnconfigure 2 -name value
    $tbl columnconfigure 3 -name usage
    # Mips registers
    $tbl insert end [list 0 zero [regval 0] {hardwired 0}]
    $tbl insert end [list 1 at [regval 1] {reserved for the assembler}]
    $tbl insert end [list 2 v0 [regval 2] {return value and expression evaluation}]
    $tbl insert end [list 3 v1 [regval 3] {return value and expression evaluation}]
    $tbl insert end [list 4 a0 [regval 4] {arguments}]
    $tbl insert end [list 5 a1 [regval 5] {arguments}]
    $tbl insert end [list 6 a2 [regval 6] {arguments}]
    $tbl insert end [list 7 a3 [regval 7] {arguments}]
    $tbl insert end [list 8 t0 [regval 8] {temporary values}]
    $tbl insert end [list 9 t1 [regval 9] {temporary values}]
    $tbl insert end [list 10 t2 [regval 10] {temporary values}]
    $tbl insert end [list 11 t3 [regval 11] {temporary values}]
    $tbl insert end [list 12 t4 [regval 12] {temporary values}]
    $tbl insert end [list 13 t5 [regval 13] {temporary values}]
    $tbl insert end [list 14 t6 [regval 14] {temporary values}]
    $tbl insert end [list 15 t7 [regval 15] {temporary values}]
    $tbl insert end [list 16 s0 [regval 16] {saved values}]
    $tbl insert end [list 17 s1 [regval 17] {saved values}]
    $tbl insert end [list 18 s2 [regval 18] {saved values}]
    $tbl insert end [list 19 s3 [regval 19] {saved values}]
    $tbl insert end [list 20 s4 [regval 20] {saved values}]
    $tbl insert end [list 21 s5 [regval 21] {saved values}]
    $tbl insert end [list 22 s6 [regval 22] {saved values}]
    $tbl insert end [list 23 s7 [regval 23] {saved values}]
    $tbl insert end [list 24 t8 [regval 24] {temporary values}]
    $tbl insert end [list 25 t9 [regval 25] {temporary values}]
    $tbl insert end [list 26 k0 [regval 26] {reserved for kernel}]
    $tbl insert end [list 27 k1 [regval 27] {reserved for kernel}]
    $tbl insert end [list 28 gp [regval 28] {global pointer}]
    $tbl insert end [list 29 sp [regval 29] {stack pointer}]
    $tbl insert end [list 30 fp [regval 30] {frame pointer}]
    $tbl insert end [list 31 ra [regval 31] {return address}]
  }

  proc regval {regnum} {
    variable regfile_vals
    if {!([info exists regfile_vals($regnum)])} {
      set regfile_vals($regnum) 0
    }
    return $regfile_vals($regnum)
  }

  proc edit_start {tbl row col text} {
    # puts stderr "row: $row col:$col text: $text"
    return $text
  }

  proc is_valid_number {text} {
    set prefix [string range $text 0 1]
    if {($prefix == "0x") || ($prefix == "0X") } {
      set digits [string range $text 2 end]
      if {$digits != ""} {
	return [string is xdigit $digits]
      }
      return true
    } else {
      if {[string is integer $text]} {
	return true
      }
    }
    return false
  }

  proc update_check {tbl row col text} {
    variable regfile_vals

    set field [$tbl columncget $col -name]
    if {[is_valid_number $text]} {
      if {$row != 0} {
	set regfile_vals($row) $text
      } else {
	set text 0
      }
    } else {
      set text $regfile_vals($row)
    }
    return $text
  }

}
