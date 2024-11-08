# This is the guts of the display.
# $Id$
# $Log$
#
#


# procedure to show window .
proc utdshow_window {program_name args} {

  # Window manager configurations
  global tkVersion
  wm sizefrom . ""
  wm maxsize . 1280 1024
  if {[catch {set hname [exec hostname]} msg]} {
    # Try a more specific command.
    if {[catch {set hname [exec /bin/hostname]} msg]} {
      ormessage errmsg $program_name "$msg\n"
      set hname "unknown"
    }
  }
  set ortitle [format "${program_name}@%s" $hname]
  wm title . $ortitle

  # bindings
  frame .utdtools -relief flat

  # build widget .frame0
  frame .utdtools.fmenu \
    -borderwidth {2} \
    -relief {raised}

  # build widget .frame0.menubutton4
  menubutton .utdtools.fmenu.menubutton4 \
    -menu {.utdtools.fmenu.menubutton4.m} \
    -text {Control}

  # build widget .frame0.menubutton4.m
  menu .utdtools.fmenu.menubutton4.m
  .utdtools.fmenu.menubutton4.m add command \
    -command "::utdtoolsgui::color_display" \
    -label {Colors}
  .utdtools.fmenu.menubutton4.m add command \
    -command {orfullframe} \
    -label {Full Frame}
  .utdtools.fmenu.menubutton4.m add command \
    -command {orredraw} \
    -label {Redraw}
  .utdtools.fmenu.menubutton4.m add command \
    -command {ortranslate} \
    -label {Translate}
  .utdtools.fmenu.menubutton4.m add command \
    -command {orzoom} \
    -label {Zoom}


  # pack widget .frame0
  pack append .utdtools.fmenu \
    .utdtools.fmenu.menubutton4 {left frame nw padx 10}

  ::utdtoolsgui::main -tkcanvas

}

utdshow_window flow
