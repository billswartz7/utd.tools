# This is the guts of the display.
# $Id$
# $Log$
#

namespace eval utdtoolsgui {
  variable rootdirS
  variable redraw_idG

  proc init { } {
    variable rootdirS
    global env
    global auto_path
    if {[info exists env(UTDTOOLS)]} {
      set rootdirS $env(UTDTOOLS)
    } {
      puts stderr "ERROR:cannot get UTD Tools environment variable:UTDTOOLS"
    }

    if {[info exists rootdirS]} {
      lappend auto_path [file join $rootdirS tcl utdtools]
      lappend auto_path [file join $rootdirS tcl gui]
    }
    # Set history to something more reasonable.
    history keep 1000
  }

  proc main {args} {
    global utdtoolsdirG

    set debug_flag false
    set num_args [llength $args]
    for {set i 0} {$i < $args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-debug"} {
	set debug_flag true
      }
    }

    # build widget .utdtools.fdraw
    frame .utdtools.fdraw \
      -relief {raised}

    # build widget .utdtools.fdraw.frame7
    frame .utdtools.fdraw.frame7 \
      -borderwidth {2} \
      -relief {raised}

    # build widget .utdtools.fdraw.frame7.frame1
    frame .utdtools.fdraw.frame7.frame1 \
      -relief {raised}

    # build widget .utdtools.fdraw.frame7.frame1.scrollbar3
    scrollbar .utdtools.fdraw.frame7.frame1.scrollbar3 \
      -command {utdscrollbar xview} \
      -orient {horizontal} \
      -relief {raised}

    # build widget .utdtools.fdraw.frame7.frame1.scrollbar1
    scrollbar .utdtools.fdraw.frame7.frame1.scrollbar1 \
      -command {utdscrollbar yview} \
      -relief {raised}

    # build widget .utdtools.fdraw.frame7.frame1.canvas2
    canvas .utdtools.fdraw.frame7.frame1.canvas2 \
      -background {#ffffff} \
      -height {207} \
      -insertofftime {600} \
      -relief {raised} \
      -scrollregion {0c 0c 20c 20c} \
      -width {295} \
      -xscrollcommand {.utdtools.fdraw.frame7.frame1.scrollbar3 set} \
      -yscrollcommand {.utdtools.fdraw.frame7.frame1.scrollbar1 set}

    # bindings for the canvas.
    set canwin .utdtools.fdraw.frame7.frame1.canvas2
    # bind $canwin <Motion> {otposition %x %y}
    bind $canwin <Key-f> {orfullview}
    bind $canwin <Key-z> {orzoom}
    bind $canwin <Shift-Z> {orzoom out}
    bind $canwin <Control-z> {orzoom in}
    bind $canwin <Enter> {focus %W}
    bind $canwin <Up> {orscrollbar yview scroll -1 units}
    bind $canwin <Down> {orscrollbar yview scroll 1 units}
    bind $canwin <Left> {orscrollbar xview scroll -1 units}
    bind $canwin <Right> {orscrollbar xview scroll 1 units}
    bind $canwin <Key-Return> {orkey $icinputG}
    bind $canwin <Button> {focus %W}
    bind $canwin <Configure> { ::utdtoolsgui::queue_redraw }
    bind $canwin <Expose> {utdredraw -force}

    # pack widget .utdtools.fdraw.frame7.frame1
    pack append .utdtools.fdraw.frame7.frame1 \
      .utdtools.fdraw.frame7.frame1.scrollbar1 {right frame center filly} \
      .utdtools.fdraw.frame7.frame1.canvas2 {top frame center expand fill} \
      .utdtools.fdraw.frame7.frame1.scrollbar3 {top frame center fillx}

    # pack widget .utdtools.fdraw.frame7
    pack append .utdtools.fdraw.frame7 \
      .utdtools.fdraw.frame7.frame1 {top frame center expand fill} \

    # pack widget .utdtools.fdraw
    pack append .utdtools.fdraw \
      .utdtools.fdraw.frame7 {top frame center expand fill}


    # build the help widget which is common
    menubutton .utdtools.fmenu.help -menu .utdtools.fmenu.help.m -text Help -underline 0 \
      -takefocus 0
    menu .utdtools.fmenu.help.m
    .utdtools.fmenu.help.m add command -label "Version" -command \
      {AlertBox "UTD Tools version:\n[utdtools_version]"}

    pack append .utdtools.fmenu \
      .utdtools.fmenu.help {right frame ne padx 10}

    # pack widget .
    pack .utdtools.fmenu -side top -fill x
    pack .utdtools.fdraw -side top -fill both -expand true
    pack .utdtools -side top -fill both -expand true

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
