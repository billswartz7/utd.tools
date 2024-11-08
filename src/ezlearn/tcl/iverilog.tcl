#
#  Copyright (c) 1999 by Internet CAD, Inc.
# 
# @(#)$RCSfile: translate.tcl,v $ $Revision: 1.1 $ $Date: 2023/03/14 00:03:06 $
# $Log: translate.tcl,v $
#

namespace eval utd_iverilog {

  proc ez_find_line {x y} {
      global verilog_winG
      global verilog_pipeG

      set idx [$verilog_winG index insert]
      # puts stderr "Index of insert:$idx"
      set line [$verilog_winG get "$idx linestart" "$idx lineend"]
      # puts stderr "line:$line"
      set idx [string first % $line]
      if {$idx != -1} {
	set idx [expr {$idx + 1}]
	set a [string range $line $idx end]
      } else {
	set a $line
      }
      set a [string trim $a]
      # puts stderr "line:$a"
      puts $verilog_pipeG "$a\n"
      flush $verilog_pipeG
  }

  proc show_window {icdir w} {
      global verilog_winG
      global verilog_pipeG

      tixScrolledText $w.output -bd 5 -height 300
      pack $w.output -fill both -padx 0 -pady 3 -side top 

      # Get the subwidget to build the HTML renderer.
      set verilog_winG [$w.output subwidget text]
      $verilog_winG configure -wrap none

      bind $verilog_winG <Return> {
	::utd_iverilog::ez_find_line %x %y
      }

      # First determine path of program
      set icos $icdir/bin/icos
      set pgm [exec $icos -noexec itranslate]

      set dsn_file [file nativename ~/.itools/ez.dsn]
      set f [open $dsn_file {RDONLY}]
      if {$f != ""} {
	set dname [gets $f]
	close $f
	if {$dname == ""} {
	  set dname test
	}
      } else {
	set dname test
      }
      set verilog_pipeG [open "|$pgm -n -i -v -e $dname 2>@stdout" r+]
      fileevent $verilog_pipeG readable \
	  [list ::utd_iverilog::ezreader $verilog_pipeG $verilog_winG]
      fileevent stdin readable [list ::utd_iverilog::ezstdin $verilog_pipeG]
      fconfigure $verilog_pipeG -blocking 0
      focus -force $verilog_winG
  }

  proc ezreader { pipe win } {
      if {[eof $pipe]} {
	catch {close $pipe} msg
	puts stderr "closing pipe:$msg"
	utdexit ;
	return ; # Should not reach here
      }
      set line [read $pipe 80]
      $win insert end "$line"
      $win see end
      $win index insert
  }

  # This routine reads from stdin and redirects it into the pipe.
  proc ezstdin { pipe } {
      if {[eof stdin]} {
	catch {close stdin} msg
	puts stderr "closing stdin:$msg with utdexit"
	# This must call utdexit to properly work!
	utdexit
      }
      gets stdin line
      puts stderr "line:$line"
      puts $pipe "$line"
      flush $pipe
  }
}

if {[info exists env(ICDIR)]} {
    set icdir $env(ICDIR)
} else {
    puts stderr "ERROR:cannot get iTools environment variable:$ICDIR"
    exit ;
}

::utdtools::init
wm deiconify .
::utd_iverilog::show_window $icdir ""
