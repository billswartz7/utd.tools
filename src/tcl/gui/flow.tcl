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
      utdmessage errmsg $program_name "$msg\n"
      set hname "unknown"
    }
  }
  set utdtitle [format "${program_name}@%s" $hname]
  wm title . $utdtitle

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
    -command {utdfullframe} \
    -label {Full Frame}
  .utdtools.fmenu.menubutton4.m add command \
    -command {utdredraw} \
    -label {Redraw}
  .utdtools.fmenu.menubutton4.m add command \
    -command {utdtranslate} \
    -label {Translate}
  .utdtools.fmenu.menubutton4.m add command \
    -command {utdzoom} \
    -label {Zoom}
  .utdtools.fmenu.menubutton4.m add separator
  .utdtools.fmenu.menubutton4.m add command \
    -command {utdcontinue} \
    -label {Continue}


  # pack widget .frame0
  pack append .utdtools.fmenu \
    .utdtools.fmenu.menubutton4 {left frame nw padx 10}

  ::utdtoolsgui::main -tkcanvas

}

utdshow_window flow
