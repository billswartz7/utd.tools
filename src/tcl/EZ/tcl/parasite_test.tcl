#

namespace eval twez {
  variable exec_pipeS

  proc test_verilog {w} {
      variable configS
      set f [frame $w.scr -bg green]

      # Create the label on the top of the dialog box
      #
      label $f.top -padx 20 -pady 10 -border 1 -relief raised -anchor c -text \
	  "This window tests parasites" -height 20 -width 80

      tixButtonBox $f.vbox -orientation horizontal
      $f.vbox add start -text {Start Test} -underline 0 \
	 -command "::twez::start_verilog $f.top" -width 26
      $f.vbox add stop -text {Exit Test} -underline 0 \
	 -command "::twez::stop_verilog $f.top" -width 26

      pack $f.vbox -side bottom -padx 20 -anchor center -pady 3
      pack $f.top -side top -fill both -expand yes
      pack $f -expand yes -fill both -padx 10 -pady 10
      # $w configure -background blue
  }


  proc exec_verilog {w} {
      variable configS
      set f [frame $w.scr -bg green]

      # Create the label on the top of the dialog box
      #
      label $f.top -padx 20 -pady 10 -border 1 -relief raised -anchor c -text \
	  "This window executes iVerilog" -height 20 -width 80

      tixButtonBox $f.vbox -orientation horizontal
      $f.vbox add start -text {Start Verilog} -underline 0 \
	 -command "::twez::start_verilog $f.top" -width 26
      $f.vbox add stop -text {Exit Verilog} -underline 0 \
	 -command "::twez::stop_verilog $f.top" -width 26

      pack $f.vbox -side bottom -padx 20 -anchor center -pady 3
      pack $f.top -side top -fill x 
      pack $f -expand yes -fill both -padx 10 -pady 10
      $f.top configure -background blue
      set configS(P_verilog) 0
  }

  proc start_verilog {w} {
      variable configS
      variable exec_pipeS

      if {([info exists configS(P_verilog)]) && ($configS(P_verilog))} {
	utdalert_user errmsg ez:start_translate "iverilog is already loaded.  Ignoring command."
	return
      }
      puts stderr "we past this: $w"

      set utdtoolsdir $configS(E_rootdir)
      puts stderr "utdroot: $utdtoolsdir"

      set id [winfo id $w]
      puts stderr "id:$id"
      set id [format %d $id]
      puts stderr "id:$id"

      # Now turn off the window.
      utdwin $w off

      # Generate a configure event and send it to the program when we scroll
      # so that menus work properly in the app (during scrolling).
      # set wscr [winfo parent $w]
      # set item [winfo parent $wscr]
      # bind $item <Configure> "event generate $id <Configure> -send true"

      # First determine path of program
      set comet_flag true
      if {$comet_flag} {
	set utdos $utdtoolsdir/bin/utdos
	set pgm [exec $utdos -noexec cometTix]
	puts stderr "pgm: $pgm"

	set dsn_file [file nativename ~/.itools/ez.dsn]
	set f [open $dsn_file w]
	if {$f == ""} {
	  utdalert_user errmsg twez::exec_verilog  "Could not open $dsn_file. Check permissions."
	  sleep 2
	} else {
	  puts $f "stdcell"
	  close $f
	}

	# Now call the cometTix program as a parasite.
	puts stderr "open: |$pgm -w $id -d -v $utdtoolsdir/share/ezlearn/tcl/iverilog.tcl 2>@stdout"
	set exec_pipeS [open \
	  "|$pgm -w $id -v $utdtoolsdir/share/ezlearn/tcl/iverilog.tcl 2>@stdout" w]
      } else {
        global env
	set icdir $env(ICDIR)
	set icos $icdir/bin/icos
	set pgm [exec $icos -noexec ICTk]

	set dsn_file [file nativename ~/.itools/ez.dsn]
	set f [open $dsn_file w]
	if {$f == ""} {
	  utdalert_user errmsg ez:start_translate "Could not open $dsn_file. Check permissions."
	  sleep 2
	} else {
	  puts $f "stdcell"
	  close $f
	}
	# Now call the iTools program.  For debug add -D -v
	set exec_pipeS [open \
	  "|$pgm -w $id $icdir/EZ/tcl/translate.tcl 2>@stdout" w]
      }

      set pids [pid $exec_pipeS]
      if {$pids != ""} {
	puts stderr "pid: $pids"
	lock_page $pids
	set configS(verilog_pids) $pids
      }
      fconfigure $exec_pipeS -blocking 0

      EZset_state -verilog 1
      ez_message msg "iVerilog started."
      # Add iVerilog code here.
      puts $exec_pipeS "set a 1" 
      flush $exec_pipeS

      update

  }

  proc check_close {pipe w} {
      if {[eof $pipe]} {
	puts stderr "Pipe is now closed\n"
      }
  }

  proc send_cmd { } {
      variable configS
      variable exec_pipeS
      if {[catch {puts $exec_pipeS "twhelp";flush $exec_pipeS} msg]} {
	utdalert_user errmsg twez::stop_verilog "iverilog is already stopped."
      }
  }

  proc stop_verilog {w} {
      variable configS
      variable exec_pipeS

      if {[catch {puts $exec_pipeS "twexit\n";flush $exec_pipeS} msg]} {
	EZset_state -translate 0
	utdalert_user errmsg twez::stop_verilog "iverilog is already stopped."
      }
      EZset_state -translate 0
      ez_message msg "Stopping iVerilog."
      utdwin $w on
      if {[info exists configS(verilog_pids)]} {
	foreach pid $configS(verilog_pids) {
	  utdprocess wait $pid
	}
	unset configS(verilog_pids)
      }
      set configS(P_verilog) 0
      utdredraw event
  }

  proc view_code {w type} {

    if {[info exists ic(S_route_script)] && $ic(S_route_script) == ""} {
      icalert_user errmsg ez:route_script "Need to generate or read in a route script file."
      return ;
    }
    set fname $ic(S_design).rdo
    view_code_file $w $fname $type

  }

  proc view_code_file {w fname type} {

    new_editor $w [list "$fname File" $fname]

  }
}
