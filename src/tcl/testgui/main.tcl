# This is the guts of the display.
# $Id$
# $Log$
#

namespace eval utdgui {
  variable rootdirS
  variable redraw_idG

  proc init { } {
    variable rootdirS
    global env
    global auto_path
    if {[info exists env(UTDGUI)]} {
      set rootdirS $env(UTDGUI)
    } {
      puts stderr "ERROR:cannot get UTDGUI environment variable:UTDGUI"
    }

    if {[info exists rootdirS]} {
      lappend auto_path [file join $rootdirS tcl utdgui]
    }
  }

  proc main {args} {
    set debug_flag false
    set num_args [llength $args]
    for {set i 0} {$i < $args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-debug"} {
	set debug_flag true
      }
    }

    # build widget .utd.fdraw
    frame .utd.fdraw \
      -relief {raised}

    # build widget .utd.fdraw.frame7
    frame .utd.fdraw.frame7 \
      -borderwidth {2} \
      -relief {raised}

    # build widget .utd.fdraw.frame7.frame1
    frame .utd.fdraw.frame7.frame1 \
      -relief {raised}

    # build widget .utd.fdraw.frame7.frame1.scrollbar3
    scrollbar .utd.fdraw.frame7.frame1.scrollbar3 \
      -command {utdscrollbar xview} \
      -orient {horizontal} \
      -relief {raised}

    # build widget .utd.fdraw.frame7.frame1.scrollbar1
    scrollbar .utd.fdraw.frame7.frame1.scrollbar1 \
      -command {utdscrollbar yview} \
      -relief {raised}

    # build widget .utd.fdraw.frame7.frame1.canvas2
    canvas .utd.fdraw.frame7.frame1.canvas2 \
      -background {#ffffff} \
      -height {207} \
      -insertofftime {600} \
      -relief {raised} \
      -scrollregion {0c 0c 20c 20c} \
      -width {295} \
      -xscrollcommand {.utd.fdraw.frame7.frame1.scrollbar3 set} \
      -yscrollcommand {.utd.fdraw.frame7.frame1.scrollbar1 set}

    # bindings for the canvas.
    set canwin .utd.fdraw.frame7.frame1.canvas2
    # bind $canwin <Motion> {otposition %x %y}
    bind $canwin <Key-f> {utdfullview}
    bind $canwin <Key-z> {utdzoom}
    bind $canwin <Shift-Z> {utdzoom out}
    bind $canwin <Control-z> {utdzoom in}
    bind $canwin <Enter> {focus %W}
    bind $canwin <Up> {utdscrollbar yview scroll -1 units}
    bind $canwin <Down> {utdscrollbar yview scroll 1 units}
    bind $canwin <Left> {utdscrollbar xview scroll -1 units}
    bind $canwin <Right> {utdscrollbar xview scroll 1 units}
    bind $canwin <Key-Return> {utdkey $icinputG}
    bind $canwin <Button> {focus %W}
    bind $canwin <Configure> { ::utdgui::queue_redraw }
    bind $canwin <Expose> {utdredraw -force}

    # pack widget .utd.fdraw.frame7.frame1
    pack append .utd.fdraw.frame7.frame1 \
      .utd.fdraw.frame7.frame1.scrollbar1 {right frame center filly} \
      .utd.fdraw.frame7.frame1.canvas2 {top frame center expand fill} \
      .utd.fdraw.frame7.frame1.scrollbar3 {top frame center fillx}

    # pack widget .utd.fdraw.frame7
    pack append .utd.fdraw.frame7 \
      .utd.fdraw.frame7.frame1 {top frame center expand fill} \

    # pack widget .utd.fdraw
    pack append .utd.fdraw \
      .utd.fdraw.frame7 {top frame center expand fill}


    # build the help widget which is common
    menubutton .utd.fmenu.help -menu .utd.fmenu.help.m -text Help -underline 0 \
      -takefocus 0
    menu .utd.fmenu.help.m
    .utd.fmenu.help.m add command -label "Version" -command \
      {AlertBox "UTD version:\n[utdtools_version]"}

    pack append .utd.fmenu \
      .utd.fmenu.help {right frame ne padx 10}

    # pack widget .
    pack .utd.fmenu -side top -fill x
    pack .utd.fdraw -side top -fill both -expand true
    pack .utd -side top -fill both -expand true

    init_symbolic

  }

  proc queue_redraw { } {
    variable redraw_idG
    if {[info exists redraw_idG]} {
      after cancel $redraw_idG
    }
    set redraw_idG [after 1500 {utdredraw -force}]
  }

}

# eof
#
