namespace eval utdtools {
  variable vtopS
  variable clockS
  variable rootdirS
  variable rtl_allS
  variable designNameS
  variable numPartitionS 1
  variable flowS "default"
  variable begin_pgmS "start"
  variable end_pgmS ""
  variable feednameS ""
  variable lef_fileS ""
  variable def_fileS ""
  variable timing_fileS ""
  variable verilog_fileS ""
  variable sdc_fileS ""
  variable nographicS true
  variable run_in_xtermS false
  variable batch_modeS true

  proc init { } {
    global env
    global auto_path
    variable rootdirS
    if {[info exists env(UTDTOOLS)]} {
      set basedir $env(UTDTOOLS)
    } {
      puts stderr "ERROR:cannot get UTD tools environment variable:UTDTOOLS"
      exit
    }
    if {[info exists env(UTDTOOLSVERSION)]} {
      set rootdirS [file join $basedir $env(UTDTOOLSVERSION)]
    } {
      puts stderr "ERROR:cannot get UTD tools environment variable:UTDTOOLSVERSION"
      exit
    }
    if {[info exists rootdirS]} {
      lappend auto_path [file join $rootdirS tcl utdtools]
      lappend auto_path [file join $rootdirS tcl gui]
      lappend auto_path [file join $rootdirS tcl flow]
    }
  }
}

::utdtools::init

# eof
#
