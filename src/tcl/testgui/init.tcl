namespace eval utdgui {
  variable rootdirS

  proc init { } {
    global env
    global auto_path
    variable rootdirS
    if {[info exists env(UTDGUI)]} {
      set rootdirS $env(UTDGUI)
    } {
      puts stderr "ERROR:cannot get graphics interface environment variable:UTDGUI"
      exit
    }
    if {[info exists rootdirS]} {
      lappend auto_path [file join $rootdirS tcl utdgui]
    }
  }
}

::utdgui::init

# eof
#
