
namespace eval tomasulo {
  variable icntS  0
  variable clockS 0
  variable ls_listS
  variable rs_listS
  variable memoryS
  variable decoderS
  variable languageS IBM360
  variable cdb_busyS 0
  variable register_nameS ""
  variable load_storeS ""
  variable instructionS ""
  variable register_resultS ""
  variable reservation_stationS
  variable issue_to_exec_latencyS

  proc display {args} {
    variable register_nameS
    variable load_storeS
    variable instructionS
    variable register_resultS
    variable reservation_stationS

    set wname .wtomas
    if {[winfo exists $wname]} {
      wm withdraw $wname
      wm deiconify $wname
      return ;
    }

    toplevel $wname
    package require tablelist

    # Window manager configurations
    wm positionfrom $wname ""
    wm sizefrom $wname ""
    wm title $wname {Tomasulo Simulator}


    set ftop [frame $wname.top -borderwidth {1} -relief {raised}]
    # Instruction Table
    set finstructions [build_table "Instruction status:" ${ftop}.itable \
      [list Instruction Outreg j k Issue {Exec Comp} {Write Result}] false]
    set instructionS ${finstructions}.tbl

    # Load / Store Table
    set floadstore [build_table "Load Store Units:" ${ftop}.ltable \
      [list Instance  Busy  Op Address Vj Qj Type Time State Inst] false]
    set load_storeS ${floadstore}.tbl
    # One of two forms of this command.
#    catch {$load_storeS togglevisibility {3}}
#    catch {$load_storeS togglecolumnhide {3}}
#    catch {$load_storeS togglevisibility {4}}
#    catch {$load_storeS togglecolumnhide {4}}
#    catch {$load_storeS togglevisibility {5}}
#    catch {$load_storeS togglecolumnhide {5}}

    # Reservation Stations Table
    set freservations [build_table "Reservation Stations:" ${ftop}.rtable \
      [list Time Name Busy Op Vi Vj Vk  Qj  Qk Type State Inst] \
      true]
    set reservation_stationS ${freservations}.tbl
    #catch {$reservation_stationS togglevisibility {8}}
    #catch {$reservation_stationS togglecolumnhide {8}}

    # Register Result Status
    set fresult [build_table "Register Result Status:" ${ftop}.otable \
      $register_nameS true]
    set register_resultS ${fresult}.tbl
    $register_resultS configure -height 3
    $register_resultS insert end {} ; # add a null row
    $register_resultS insert end {} ; # add a null row
    $register_resultS insert end {} ; # add a null row


    set fclock [build_clock ${ftop}]

    grid $finstructions $floadstore
    grid $freservations x
    grid $fclock $fresult
    grid $finstructions -sticky news
    grid $floadstore -sticky news
    grid $freservations -sticky news -columnspan 2
    grid $fclock -sticky news
    grid $fresult -sticky news
    grid propagate $ftop true
    grid columnconfigure $ftop 0 -weight 1
    grid columnconfigure $ftop 1 -weight 1
    grid rowconfigure $ftop 0 -weight 1
    grid rowconfigure $ftop 1 -weight 1
    pack $ftop -side top -padx 0 -fill both -expand true

  }

  proc build_table {tname wtable heading horz_scroll} {
    set ftable [frame $wtable -borderwidth {1} -relief {raised}]
    set tbl $ftable.tbl
    set hsb $ftable.hsb
    set vsb $ftable.vsb
    set fields ""
    foreach val $heading {
      lappend fields "0" 
      lappend fields $val
      lappend fields left
    }

    option add *tbl.activeStyle  frame
    option add *tbl.setGrid      yes
    option add *tbl.background   gray96
    option add *tbl.stripeBackground  #e0e8f0
    option add *tbl*selectBackground navy
    option add *tbl*selectForeground white
    option add *tbl*Entry.background ivory


    tablelist::tablelist $tbl -columns $fields \
       -labelcommand tablelist::sortByColumn \
       -stretch all \
       -yscrollcommand [list $vsb set] \
       -width 60

    # Give the columns a name for easier manipulation
    set c 0
    foreach val $heading {
      $tbl columnconfigure $c -name $val
      incr c
    }

    if {$horz_scroll} {
      $tbl configure -xscrollcommand [list $hsb set] 
    }
    scrollbar $vsb -orient vertical   -command [list $tbl yview]
    if {$horz_scroll} {
      scrollbar $hsb -orient horizontal -command [list $tbl xview]
    }
    label $ftable.lab -text $tname -anchor w

    grid $ftable.lab x 
    grid $tbl -row 1 -column 0 -sticky news
    grid $vsb -row 1 -column 1 -sticky ns
    if {$horz_scroll} {
      grid $hsb -row 2 -column 0 -sticky ew
    }
    grid $ftable.lab -sticky news -columnspan 2
    grid rowconfigure    $ftable 0 -weight 0
    grid rowconfigure    $ftable 1 -weight 1
    grid rowconfigure    $ftable 2 -weight 0
    grid columnconfigure $ftable 0 -weight 1
    grid columnconfigure $ftable 1 -weight 0
    grid propagate $ftable true
    return $wtable
  }

  proc build_clock {wclock} {
    set fclock [frame ${wclock}.fclock -borderwidth {1} -relief {raised}]

    label ${fclock}.lab -text "Clock:" -anchor w
    entry ${fclock}.ent -width 4 -textvariable ::tomasulo::clockS
    button ${fclock}.arrow1 -text "<=" -command ::tomasulo::rewind_clock
    button ${fclock}.arrow2 -text "=>" -command ::tomasulo::advance_clock
    frame ${fclock}.space -relief flat

    grid x ${fclock}.lab ${fclock}.ent x
    grid x x ${fclock}.arrow1 x
    grid x x ${fclock}.arrow2 x
    grid ${fclock}.space x x x
    grid ${fclock}.lab -sticky ns -columnspan 1
    grid ${fclock}.ent -sticky news -columnspan 1
    grid ${fclock}.arrow1 -sticky ns
    grid ${fclock}.arrow2 -sticky ns
    grid ${fclock}.space -sticky news
    grid columnconfigure $fclock 0 -weight 1
    grid columnconfigure $fclock 1 -weight 0
    grid columnconfigure $fclock 2 -weight 0
    grid columnconfigure $fclock 3 -weight 1
    grid rowconfigure    $fclock 0 -weight 0
    grid rowconfigure    $fclock 1 -weight 0
    grid rowconfigure    $fclock 2 -weight 0
    grid rowconfigure    $fclock 3 -weight 1
    grid propagate $fclock true
    return $fclock
  }

  # Utility functions to update table
  proc instruction_get {idx field} {
    variable instructionS
    set idata [$instructionS cellcget ${idx},${field} -text]
    return $idata
  }

  proc instruction_set {idx field val} {
    variable instructionS
    $instructionS cellconfigure ${idx},${field} -text $val
  }

  proc instruction_size { } {
    variable instructionS
    set isize [$instructionS size]
    return $isize
  }

  proc ls_get {idx field} {
    variable load_storeS
    set field [field_alias $field]
    set sdata [$load_storeS cellcget ${idx},${field} -text]
    return $sdata
  }

  proc ls_set {idx field val} {
    variable load_storeS
    set field [field_alias $field]
    $load_storeS cellconfigure ${idx},${field} -text $val
  }

  proc ls_size { } {
    variable load_storeS
    set ls_size [$load_storeS size]
    return $ls_size
  }

  proc ls_reset {idx} {
    ls_set $idx Busy No
    ls_set $idx Op ""
    ls_set $idx Address ""
    ls_set $idx Vj ""
    ls_set $idx Qj ""
    ls_set $idx Inst ""
    ls_set $idx State ""
  }

  proc rs_get {idx field} {
    variable reservation_stationS
    set field [field_alias $field]
    set rdata [$reservation_stationS cellcget ${idx},${field} -text]
    return $rdata
  }

  proc rs_set {idx field val} {
    variable reservation_stationS
    set field [field_alias $field]
    $reservation_stationS cellconfigure ${idx},${field} -text $val
  }

  proc rs_size { } {
    variable reservation_stationS
    set rs_size [$reservation_stationS size]
    return $rs_size
  }

  proc rs_reset {idx} {
    rs_set $idx Busy No
    rs_set $idx Op ""
    rs_set $idx Vi ""
    rs_set $idx Vj ""
    rs_set $idx Vk ""
    rs_set $idx Qj ""
    rs_set $idx Qk ""
    rs_set $idx Inst ""
    rs_set $idx Time ""
    rs_set $idx State ""
  }

  proc field_alias {field} {
    set fchar [string index $field 0]
    if {$fchar == "$"} {
      set field [string range $field 1 end]
    } elseif {$fchar == "R"} {
      set field [string range $field 1 end]
    }
    return $field
  }

  proc result_get {field} {
    variable register_resultS

#    puts -nonewline stderr "field: $field"
    set field [field_alias $field]
    set rdata [$register_resultS cellcget 0,${field} -text]
#    puts stderr " adj: $field rdata:$rdata" 

    return $rdata
  }

  proc result_set {field val} {
    variable register_resultS
    set field [field_alias $field]
    $register_resultS cellconfigure 0,${field} -text $val
  }

  proc result_size { } {
    variable register_resultS
    set result_size [$register_resultS size]
    return $result_size
  }

  # This is the temp storage for storing a computation.  This really doesn't
  # exist but aids in debugging.
  proc result_temp_value_get {field} {
    variable register_resultS
    set rdata [$register_resultS cellcget 1,${field} -text]
    return $rdata
  }

  proc result_temp_value_set {field val} {
    variable register_resultS
    $register_resultS cellconfigure 1,${field} -text $val
  }


  # Register implementation
  proc registers_init { } {
    variable register_nameS
    foreach reg $register_nameS {
      registers_set $reg 0
    }
  }

  proc register_names { } {
    variable register_nameS
    return $register_nameS
  }

  proc registers_get {register} {
    variable register_resultS
    set register [field_alias $register]
    set rdata [$register_resultS cellcget 2,${register} -text]
    return $rdata
  }

  proc registers_set {register val} {
    variable register_resultS
    set register [field_alias $register]
    $register_resultS cellconfigure 2,${register} -text $val
  }

  # Return the current clock cycle
  proc clockcycle_get { } {
    variable clockS
    return $clockS
  }

  # Updates all timers
  proc clockcycle_timer_update { } {
    set num_station [rs_size]
    # Update all reservation stations.
    for {set rs 0} {$rs < $num_station} {incr rs} {
      set busy [rs_get $rs Busy]
      if {$busy == "Yes"} {
	set counter [rs_get $rs Time]
	if {$counter > 0} {
	  incr counter -1
	  rs_set $rs Time $counter
	}
      }
    }
    # Update all load store units
    set num_loadstores [ls_size]
    for {set ls 0} {$ls < $num_loadstores} {incr ls} {
      set busy [ls_get $ls Busy]
      if {$busy == "Yes"} {
	set counter [ls_get $ls Time]
	if {$counter > 0} {
	  incr counter -1
	  ls_set $ls Time $counter
	}
      }
    }
    # Reset the CDB for new cycle
    variable cdb_busyS
    set cdb_busyS 0

  }

  proc add_instruction {instr} {
    variable languageS
    variable instructionS

    set instr [string map {, {}} $instr]
    set parse_instr [split $instr " \t\r\n"]
    set argv_0 [lindex $parse_instr 0]
    set argv0_uc [string toupper $argv_0]
    if {$languageS == "IBM360"} {
      # special case to decode displacement out of LD or LDD
      # Need to add SD command as well.
      if {($argv0_uc == "LD") || ($argv0_uc == "LDD")} {
	set mem_ref [lindex $parse_instr 2]
	set idx [string first {(} $mem_ref]
	if {$idx >= 0} {
	  set out_reg [lindex $parse_instr 1]
	  set displacement_vals [split $mem_ref {()}]
	  set j [lindex $displacement_vals 0]
	  set k [lindex $displacement_vals 1]
	  set instr [list $argv_0 $out_reg $j $k]
	}
      }
      $instructionS insert end $instr
    } elseif {$languageS == "Mips32"} {
      if {($argv0_uc == "LW") || ($argv0_uc == "SW")} {
	set mem_ref [lindex $parse_instr 2]
	set idx [string first {(} $mem_ref]
	if {$idx >= 0} {
	  set out_reg [lindex $parse_instr 1]
	  set displacement_vals [split $mem_ref {()}]
	  set j [lindex $displacement_vals 0]
	  set k [lindex $displacement_vals 1]
	  mapregister $out_reg out_reg
	  mapregister $j j
	  mapregister $k k
	  set instr [list $argv_0 $out_reg $j $k]
	}
      } else {
	# Now map any MIPS registers
	set outfield [lindex $instr 1]
	set jfield [lindex $instr 2]
	set kfield [lindex $instr 3]
	set mapo [mapregister $outfield outfield]
	set mapj [mapregister $jfield jfield]
	set mapk [mapregister $kfield kfield]
	if {($mapo) || ($mapj) || ($mapk)} {
	  set instr [list $argv_0 $outfield $jfield $kfield]
	}
      }
      $instructionS insert end $instr
    }
  }

  proc mapregister {field field_ret} {
    upvar $field_ret f
    set fchar [string index $field 0]

    if {$fchar == "$"} {
      set f [string map {{$t0} {$8} {$t1} {$9} {$t2} {$10} {$t3} {$11} {$t4} {$12} {$t5} {$13} {$t6} {$14} {$t7} {$15}} $field] 
      return 1
    } else {
      return 0
    }
  }

  proc add_load_store {instance} {
    variable load_storeS
    $load_storeS insert end $instance
  }

  proc add_load_stores { } {
    variable ls_listS
    foreach {name type} $ls_listS {
      add_load_store [list $name No {} {} {} {} $type 0 {}]
    }
  }

  proc add_reservation_station {rs_data} {
    variable reservation_stationS
    $reservation_stationS insert end $rs_data
  }

  proc add_reservation_stations {} {
    variable rs_listS
    foreach {name type} $rs_listS {
      add_reservation_station [list {} $name No {} {} {} {} {} {} $type {}]
    }
  }

  # Implement memory using a hash table
  proc memory_init { } {
    variable memoryS
    if {[info exists memoryS]} {
      unset memoryS
    }
    set memoryS(0) 0
  }

  # To save space we implicitly store 0 / all other data is explicit
  proc memory_set {address data} {
    variable memoryS
    if {$data == 0} {
      if {[info exists memoryS($address)]} {
	unset memoryS($address)
      }
    } else {
      set memoryS($address) $data
    }
  }

  proc memory_get {address} {
    variable memoryS
    if {[info exists memoryS($address)]} {
      return $memoryS($address)
    } else {
      return 0
    }
  }



  proc read_architecture {filename} {
    variable ls_listS
    variable rs_listS
    variable decoderS
    variable register_nameS
    variable languageS
    variable issue_to_exec_latencyS
    set fd [open $filename "r"]
    if {$fd == ""} {
      puts stderr "ERROR: can't open $filename for reading.\n"
      exit 1 ;
    }
    set register_nameS ""
    set ls_listS ""
    set rs_listS ""
    if {[info exists decoderS]} {
      unset decoderS
    }
    set line_cnt 0
    set complete_line ""
    set continuation_flag false
    foreach line [split [read $fd] \n] {
      incr line_cnt
      if {[string index $line end] == "\\"} {
	append complete_line [string range $line 0 end-1]
	set continuation_flag true
	continue ;
      } else {
	if {$continuation_flag} {
	  set continuation_flag false
	  append complete_line " "
	  append complete_line $line
	} else {
	  set complete_line $line
	}
      }
      set parsed_line [split $complete_line " \r\t"]
      set adj_line ""
      foreach piece $parsed_line {
	if {$piece != ""} {
	  lappend adj_line $piece
	}
      }
      if {$adj_line == ""} {
	continue
      }
      set argv_0 [lindex $adj_line 0]
      if {[string index $argv_0 0] == "#"} {
	continue ; # comment.
      }
      set argv_0 [string toupper $argv_0]
      if {$argv_0 == "RS"} {
	set argc [llength $$adj_line]
	if {$argc != 3} {
	  puts stderr "ERROR: wrong number of arguments to RS statement.  Line:$line_cnt\n"
	  continue ;
	}
	set name [lindex $adj_line 1]
	set type [lindex $adj_line 2]
	lappend rs_listS $name
	lappend rs_listS $type

      } elseif {$argv_0 == "LS"} {
	set argc [llength $$adj_line]
	if {$argc != 3} {
	  puts stderr "ERROR: wrong number of arguments to LS statement.\n"
	  continue ;
	}
	set name [lindex $adj_line 1]
	set type [lindex $adj_line 2]
	lappend ls_listS $name
	lappend ls_listS $type

      } elseif {$argv_0 == "CMD"} {
	set argc [llength $$adj_line]
	if {$argc < 5} {
	  puts stderr "ERROR: wrong number of arguments to CMD statement.\n"
	  continue ;
	}
	set name [lindex $adj_line 1]
	set rs_type [lindex $adj_line 2]
	set temp_line [split $complete_line "{}"]
	set alt_line ""
	foreach piece $temp_line {
	  set piece [string trim $piece]
	  if {$piece != ""} {
	    lappend alt_line $piece
	  }
	}
	set argc [llength $alt_line]
	if {$argc != 3} {
	  puts stderr "ERROR: improperly formatted CMD statement: $name.\n"
	  continue ;
	}
	set exec_method [lindex $alt_line 1]
	set latency [lindex $alt_line 2]
	set len [llength $latency]
	if {$len != 3} {
	  puts stderr "ERROR: incorrect cycle format for command : $name\n"
	  continue ;
	}
	set issue_cycles [lindex $latency 0]
	set exec_cycles [lindex $latency 1]
	set commit_cycles [lindex $latency 2]
	set decoderS($name,type) $rs_type
	set decoderS($name,exec_method) $exec_method
	set decoderS($name,issue_cycles) $issue_cycles
	set decoderS($name,exec_cycles) $exec_cycles
	set decoderS($name,commit_cycles) $commit_cycles

      } elseif {$argv_0 == "REGISTERS"} {
	set argc [llength $$adj_line]
	if {$argc != 4} {
	  puts stderr "ERROR: wrong number of arguments to Register statement.\n"
	  continue ;
	}
	set type [lindex $adj_line 1]
	set start [lindex $adj_line 2]
	set end [lindex $adj_line 3]
	if {$type == "Integer"} {
	  set iflag true
	} elseif {$type == "Float"} {
	  set iflag false
	} else {
	  puts stderr "ERROR: unsupported register type: $type\n" 
	  continue ;
	}
	for {set r $start} {$r <= $end} {incr r} {
	  if {$iflag} {
	    lappend register_nameS "R${r}"
	  } else {
	    lappend register_nameS "F${r}"
	  }
	}

      } elseif {$argv_0 == "ISSUETOEXECLATENCY"} {
	set argc [llength $$adj_line]
	if {$argc != 2} {
	  puts stderr "ERROR: wrong number of arguments to IssueToExecLatency statement.\n"
	  continue ;
	}
	set issue_to_exec_latencyS [lindex $adj_line 1]
	puts stderr "issue -> exec is $issue_to_exec_latencyS cycles"

      } elseif {$argv_0 == "LANGUAGE"} {
	set argc [llength $$adj_line]
	if {$argc != 2} {
	  puts stderr "ERROR: wrong number of arguments to IssueToExecLatency statement.\n"
	  continue ;
	}
	set language [lindex $adj_line 1]
	if {($language == "Mips32") || ($language == "IBM360")} {
	  set languageS [lindex $adj_line 1]
	  puts stderr "Language is set to $languageS"
	} else {
	  puts stderr "ERROR: unknown language: $language\n"
	}

      } else {
	puts stderr "ERROR: unknown architecture command: $argv_0\n" 
      }
    }
    close $fd
  }

  proc read_instructions {filename} {
    variable icntS
    set icntS 0
    set fd [open $filename "r"]
    if {$fd == ""} {
      puts stderr "ERROR: can't open $filename for reading.\n"
      exit 1 ;
    }
    set line_cnt 0
    set complete_line ""
    set continuation_flag false
    foreach line [split [read $fd] \n] {
      incr line_cnt
      if {[string index $line end] == "\\"} {
	append complete_line [string range $line 0 end-1]
	set continuation_flag true
	continue ;
      } else {
	if {$continuation_flag} {
	  set continuation_flag false
	  append complete_line " "
	  append complete_line $line
	} else {
	  set complete_line $line
	}
      }
      add_instruction $complete_line
    }
    close $fd
  }


  proc rewind_clock { } {
    variable clockS
    incr clockS -1
    if {$clockS < 0} {
      set clockS 0
    }
  }

  # Fetch next command from instruction stream - single instruction fetch
  # Returns instruction name.
  proc fetch_next_command { } {
    variable icntS

    # Get the number of instructions
    set num_instr [instruction_size]

    # We don't increment instruction here because we might have
    # to stall because reservation is not open.
    # incr icntS
    if {$icntS >= $num_instr} {
      set icntS $num_instr
      return "" ; # No more instructions to fetch.
    }

    # Instructions are in a 0-based table 
    set row $icntS
    # Get the instruction
    set instr [instruction_get $row Instruction]
    return $instr
  }

  proc lookup_command_unit { cmd } {
    variable decoderS
    set key "${cmd},type"
    # puts stderr "key:$key"
    if {[info exists decoderS($key)]} {
      set itype $decoderS($key)
    } else {
      set itype ""
    }
    return $itype
  }

  proc command_cycle_time {cmd type} {
    variable decoderS
    if {[info exists decoderS(${cmd},${type})]} {
      return $decoderS(${cmd},${type})
    }
    puts stderr "ERROR: requested cycle type:$type not found for command:$cmd\n"
    return 0
  }

  proc command_execution_method {cmd} {
    variable decoderS
    if {[info exists decoderS(${cmd},exec_method)]} {
      return $decoderS(${cmd},exec_method)
    }
    puts stderr "ERROR: requested command execution method not found for command:$cmd\n"
    return 0
  }

  # Given a unit type (LoadStore,IntegerAdd,etc), return the first available
  # reservation station in list form: {rsIndex rsName rsType}.   Return NULL,
  # if nothing is open
  proc unit_open {unit} {

    if {$unit == "LoadStore"} {
      set num_loads [ls_size]
      # Look for a open load store
      for {set ls 0} {$ls < $num_loads} {incr ls} {
	set status [ls_get $ls Busy]
	if {$status == "No"} {
	  set name [ls_get $ls Instance]
	  return [list $ls $name "LoadStore"]
	}
      }
    } else {
      set num_station [rs_size]
      # Look for a open load store
      for {set s 0} {$s < $num_station} {incr s} {
	set rs_type [rs_get $s Type]
	if {$rs_type == $unit} {
	  set status [rs_get $s Busy]
	  if {$status == "No"} {
	    set name [rs_get $s Name]
	    return [list $s $name $unit]
	  }
	}
      }
    }
    return ""

  }


  # Decodes the command and returns the first open reservation station if
  # available.   Returns NULL if nothing is available or an error.
  proc decode_next_command {cmd inst_count} {
    variable icntS
    # Check to see if this is a valid command by seeing if it maps to a
    # reservation or load store unit.
    set unit [lookup_command_unit $cmd]
    if {$unit == ""} {
      puts stderr "ERROR: unrecognized command: $cmd at instruction counter:$inst_count\n"
      incr icntS
      return "" 
    }
    # See if there is an open unit
    set rs_info [unit_open $unit]
    if {$rs_info != ""} {
      lappend rs_info $icntS
      incr icntS
      return $rs_info
    }
    return ""

  }


  # Assign the reservation station and set the register result status
  proc dispatch_reservation {cmd rs_data} {

    set unit_index [lindex $rs_data 0]
    set name [lindex $rs_data 1]
    set unit [lindex $rs_data 2]
    set inst [lindex $rs_data 3]
    if {$unit == "LoadStore"} {
      set src_register [instruction_get $inst k]
      set rename_alias [result_get $src_register]
      if {$rename_alias != ""} {
	ls_set $unit_index Qj $rename_alias
	set src_r $rename_alias
      } else {
	ls_set $unit_index Vj $src_register
	ls_set $unit_index Qj ""
	set src_r $src_register
      }

      # Update address
      set displacement [instruction_get $inst j]
      set mem_ref "$src_r + $displacement"
      ls_set $unit_index Address $mem_ref

      # Set the issue counter and state.
      set issue_cycles [command_cycle_time $cmd issue_cycles]
      ls_set $unit_index Time $issue_cycles
      ls_set $unit_index State issue
      ls_set $unit_index Op $cmd
      ls_set $unit_index Busy Yes
      ls_set $unit_index Inst $inst

    } else {
      # First src J
      set srcJ_register [instruction_get $inst j]
      set renameJ_alias [result_get $srcJ_register]
      if {$renameJ_alias != ""} {
	rs_set $unit_index Qj $renameJ_alias
      } else {
	set srcJ_register_contents [registers_get $srcJ_register]
	rs_set $unit_index Vj $srcJ_register_contents
	rs_set $unit_index Qj ""
      }
      # Second src K
      set srcK_register [instruction_get $inst k]
      set renameK_alias [result_get $srcK_register]
      if {$renameK_alias != ""} {
	rs_set $unit_index Qk $renameK_alias
      } else {
	set srcK_register_contents [registers_get $srcK_register]
	rs_set $unit_index Vk $srcK_register_contents
	rs_set $unit_index Qk ""
      }
      # Set the command to op field
      rs_set $unit_index Op $cmd

      # Set issue counter and state
      set issue_cycles [command_cycle_time $cmd issue_cycles]
      rs_set $unit_index Time $issue_cycles
      rs_set $unit_index State issue
      rs_set $unit_index Busy Yes
      rs_set $unit_index Inst $inst
    }
    # Here we assign the Register Result Status
    set dest_register [instruction_get $inst Outreg]
    result_set $dest_register $name

    # Here we set the issue clock cycle.
    instruction_set $inst Issue [clockcycle_get]

    # puts stderr "dispatch: $cmd $rs_data"
  }

  proc execute_single_command {rs} {
    set Vj [rs_get $rs Vj]
    set Vk [rs_get $rs Vk]
    set cmd [rs_get $rs Op]
    set exec_method [command_execution_method $cmd]
    set exec_proc [lindex $exec_method 0]
    set op [lindex $exec_method 1]
    if {$exec_proc == "Tcl_builtin"} {
      set result [expr ($Vj $op $Vk)]
      rs_set $rs Vi $result
      set commit_cycles [command_cycle_time $cmd commit_cycles]
      rs_set $rs Time $commit_cycles
      rs_set $rs State completed
      set inst [rs_get $rs Inst]
      instruction_set $inst {Exec Comp} [clockcycle_get]
    }
  }

  proc calc_address {address_equation} {
    set vals [split $address_equation]
    set reg [lindex $vals 0]
    set reg_val [registers_get $reg]
    set plus [lindex $vals 1]
    set displacement [lindex $vals 2]
    set addr [expr $reg_val $plus $displacement]

  }


  # Execute ready commands.
  proc execute_cmds { } {

    variable languageS 
    variable issue_to_exec_latencyS

    # Look to execute command
    set num_loadstores [ls_size]
    for {set ls 0} {$ls < $num_loadstores} {incr ls} {
      set busy [ls_get $ls Busy]
      set counter [ls_get $ls Time]
      set state [ls_get $ls State]
      if {$busy == "Yes"} {
	if {$counter == 0} {
	  if {$state == "issue"} {
	    set Qj [ls_get $ls Qj]
	    if {$Qj == ""} {
	      # Calculate address if data is ready
	      set reg [ls_get $ls Vj]
	      set $reg [registers_get $reg]
	      # We make use of the form of address is always Rx + #
	      # We make this into a Tcl expresssion $Rx + # and evaluate it
	      if {$languageS == "IBM360"} {
		set displacement_str "$"
		append displacement_str [ls_get $ls Address]
		set calc_addr [expr $displacement_str]
	      } else {
		set address [ls_get $ls Address]
		set calc_addr [calc_address $address]
		set displacement_str ""
	      }
	      # Now set the address back into table.
	      ls_set $ls Address $calc_addr
	      # Load now read for execution.
	      set cmd [ls_get $ls Op]
	      set exec_cycles [command_cycle_time $cmd exec_cycles]
	      ls_set $ls Time $exec_cycles
	      ls_set $ls State exec
	    }
	  } elseif {$state == "exec"} {
	    # Read value into temp area
	    set calc_addr [ls_get $ls Address]
	    set contents [memory_get $calc_addr]
	    # Rewrite the value
	    set temp_val "MEM(${calc_addr})=${contents}"
	    ls_set $ls Address $temp_val
	    set cmd [ls_get $ls Op]
	    set commit_cycles [command_cycle_time $cmd commit_cycles]
	    ls_set $ls Time $commit_cycles
	    ls_set $ls State completed
	    set inst [ls_get $ls Inst]
	    instruction_set $inst {Exec Comp} [clockcycle_get]
	  }
	}
      }
    }

    set num_station [rs_size]
    # Look to execute command
    for {set rs 0} {$rs < $num_station} {incr rs} {
      set busy [rs_get $rs Busy]
      set counter [rs_get $rs Time]
      set state [rs_get $rs State]
      if {$busy == "Yes"} {
	if {$counter == 0} {
	  if {$state == "issue"} {
	    set Qj [rs_get $rs Qj]
	    set Qk [rs_get $rs Qk]
	    if {($Qj == "") && ($Qk == "")} {
	      # Command ready for execution.
	      set cmd [rs_get $rs Op]
	      set exec_cycles [command_cycle_time $cmd exec_cycles]
	      rs_set $rs State exec
	      rs_set $rs Time $exec_cycles
	      if {($issue_to_exec_latencyS == 0)} {
		if {($exec_cycles > 0)} {
		  incr exec_cycles -1
		}
		rs_set $rs Time $exec_cycles
		if {$exec_cycles == 0} {
		  execute_single_command $rs
		  rs_set $rs State completed
		}
	      }
	    }
	  } elseif {$state == "exec"} {
	    # Perform execution.
	    execute_single_command $rs
	    rs_set $rs State completed
	  }
	}
      }
    }

  }

  proc write_results { } {
    variable cdb_busyS
    set num_loadstores [ls_size]
    set num_station [rs_size]
    if {!($cdb_busyS)} {
      # Look to execute command
      for {set ls 0} {$ls < $num_loadstores} {incr ls} {
	set busy [ls_get $ls Busy]
	set state [ls_get $ls State]
	set counter [ls_get $ls Time]
	if {$busy == "Yes"} {
	  if {($state == "completed") && ($counter == 0)} {
	    # Broadcast to the CDB
	    set results ""
	    set name [ls_get $ls Instance]
	    # First the Register Result Status
	    foreach reg [register_names] {
	      # get value of register 
	      set reg_val [result_get $reg]
	      if {$reg_val == $name} {
		set result_val [ls_get $ls Address]
		set parsed_result [split $result_val =]
		set results [lindex $parsed_result 1]
		registers_set $reg $results
		result_set $reg ""
	      }
	    }
	    # Next Reservation Stations
	    for {set rs 0} {$rs < $num_station} {incr rs} {
	      set Qj [rs_get $rs Qj]
	      if {$Qj == $name} {
		rs_set $rs Vj $results
		rs_set $rs Qj ""
	      }
	      set Qk [rs_get $rs Qk]
	      if {$Qk == $name} {
		rs_set $rs Vk $results
		rs_set $rs Qk ""
	      }
	    }
	    # Free up the load store unit
	    set inst [ls_get $ls Inst]
	    ls_reset $ls
	    instruction_set $inst {Write Result} [clockcycle_get]
	    set cdb_busyS true
	    break ; # only one CDB
	  }
	}
      }
    }

    if {!($cdb_busyS)} {
      # Look to execute command
      for {set rs 0} {$rs < $num_station} {incr rs} {
	set busy [rs_get $rs Busy]
	set state [rs_get $rs State]
	set counter [rs_get $rs Time]
	if {$busy == "Yes"} {
	  if {($state == "completed") && ($counter == 0)} {
	    # Broadcast to the CDB
	    set results ""
	    set name [rs_get $rs Name]
	    set results [rs_get $rs Vi]
	    # First the Register Result Status
	    foreach reg [register_names] {
	      # get value of register 
	      set reg_val [result_get $reg]
	      if {$reg_val == $name} {
		registers_set $reg $results
		result_set $reg ""
	      }
	    }
	    # Next Reservation Stations
	    for {set rs_idx 0} {$rs_idx < $num_station} {incr rs_idx} {
	      set Qj [rs_get $rs_idx Qj]
	      if {$Qj == $name} {
		rs_set $rs_idx Vj $results
		rs_set $rs_idx Qj ""
	      }
	      set Qk [rs_get $rs_idx Qk]
	      if {$Qk == $name} {
		rs_set $rs_idx Vk $results
		rs_set $rs_idx Qk ""
	      }
	    }
	    # Free up the load store unit
	    set inst [rs_get $rs Inst]
	    rs_reset $rs
	    instruction_set $inst {Write Result} [clockcycle_get]
	    set cdb_busyS true
	    break ; # only one CDB
	  }
	}
      }
    }
  }

  # This is the heart of the algorithm update.  We are implementing page
  # 101 Chapter 2 of the book : Computer Architecture : a Quantitative
  # Approach
  proc advance_clock { } {
    variable icntS
    variable clockS

    # Update time and all counters
    incr clockS 
    clockcycle_timer_update


    # Perform a fetch
    set cmd [fetch_next_command]
    set inst_count $icntS

    # Perform a decode / dispatch
    if {$cmd != ""} {
      set rs_data [decode_next_command $cmd $inst_count]
      if {$rs_data != ""} {
	dispatch_reservation $cmd $rs_data
      }
    }

    # Execute
    execute_cmds 

    # Write Result for this cycle
    write_results

  }

}

# Setup the global auto_path so we can find package list
global auto_path
lappend auto_path [pwd]/tablelist5.2
wm withdraw .

tomasulo::read_architecture arch1
#tomasulo::read_architecture arch2
tomasulo::display
tomasulo::add_load_stores
tomasulo::add_reservation_stations
tomasulo::memory_init
tomasulo::registers_init
tomasulo::read_instructions main.s
# tomasulo::read_instructions ibm.s

# Set a few memory locations for our example
for {set m 1} {$m <= 50} {incr m} {
  tomasulo::memory_set $m  $m
}

# Set a few register values for our example
tomasulo::registers_set \$12 18
