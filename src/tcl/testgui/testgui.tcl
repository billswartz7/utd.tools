# This is the guts of the display.
# $Id$
# $Log$
#
#!/usr/local/bin/wish -f
# Program: simple
# $Log: simple.tcl,v $
# Revision 1.5  2006/11/05  22:17:12  bills
# Updated so that hostname works when it isn't in the user's path.
#
# Revision 1.4  2006/10/04  23:29:26  bills
# Updated for the new .itools window structure.
#
# Revision 1.3  2005/04/14  06:35:55  bills
# Updated for global variable name changes made to make global variables
# readily apparent from their name.
#
# Revision 1.2  2004/08/08  02:34:48  bills
# Updated printing menu option to use the ::icprint namespace functions.
#
# Revision 1.1  2003/07/30  03:02:49  bills
# Initial revision
#
#


namespace eval utdgui {
  # procedure to show window .
  proc show_window {args} {

    # Window manager configurations
    global tkVersion
    wm sizefrom . ""
    wm maxsize . 1280 1024
    if {[catch {set hname [exec hostname]} msg]} {
      set hname "unknown"
    }
    set ictitle [format "simple@%s" $hname]
    wm title . $ictitle

    # bindings
    frame .utd -relief flat

    # build widget .frame0
    frame .utd.fmenu \
      -borderwidth {2} \
      -relief {raised}

    # build widget .frame0.menubutton4
    menubutton .utd.fmenu.menubutton4 \
      -menu {.utd.fmenu.menubutton4.m} \
      -text {Control}

    # build widget .frame0.menubutton4.m
    menu .utd.fmenu.menubutton4.m
    .utd.fmenu.menubutton4.m add command \
      -command "::utdgui::color_display" \
      -label {Colors}
    .utd.fmenu.menubutton4.m add command \
      -command {utdfullframe} \
      -label {Full Frame}
    .utd.fmenu.menubutton4.m add command \
      -command {utdredraw} \
      -label {Redraw}
    .utd.fmenu.menubutton4.m add command \
      -command {utdtranslate} \
      -label {Translate}
    .utd.fmenu.menubutton4.m add command \
      -command {utdzoom} \
      -label {Zoom}


    # pack widget .frame0
    pack append .utd.fmenu \
      .utd.fmenu.menubutton4 {left frame nw padx 10}

    ::utdgui::main

  }
}


::utdgui::show_window


