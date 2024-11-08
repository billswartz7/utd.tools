namespace eval utdtools {
  variable vtopS
  variable clockS
  variable rootdirS ""
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

  proc env_check {exit_flag args} { 
    global env
    variable rootdirS
    if {([info exists env(UTDTOOLS)]) && ([info exists env(UTDTOOLSVERSION)])} {
      set rootdirS [file join $env(UTDTOOLS) $env(UTDTOOLSVERSION)]
      return false
    } elseif {$exit_flag} {
      puts stderr "ERROR:cannot get UTD tools environment variable:UTDTOOLS UTDTOOLSVERSION"
      exit 1
    }
    return true

  }

  proc init { } {
    global auto_path
    variable rootdirS

    env_check true
    if {[info exists rootdirS]} {
      lappend auto_path [file join $rootdirS tcl utdtools]
      lappend auto_path [file join $rootdirS tcl gui]
      lappend auto_path [file join $rootdirS tcl flow]
      lappend auto_path [file join $rootdirS tcl tablelist]
      lappend auto_path [file join $rootdirS tcl tcllib lib]
      lappend auto_path [file join $rootdirS tcl EZ tcl]
    }
    # puts stderr "::utdtools::init auto_path: $auto_path"
    # Set history to something more reasonable.
  }

  proc rootdir { } {
    variable rootdirS
    return $rootdirS
  }
}

::utdtools::init

# eof
#
