# $Id: iconbar.tcl,v 1.1 2016/12/10 20:18:49 bill Exp bill $
# $Log: iconbar.tcl,v $
# Revision 1.1  2016/12/10 20:18:49  bill
# Initial revision
#
# Revision 1.17  2005/08/04  18:37:14  bills
# Redesigned the top level window structure so that it is now more
# consistent and that the main window is all encapsulated in the .itools
# window.
#
# Revision 1.16  2005/04/14  06:35:55  bills
# Updated for global variable name changes made to make global variables
# readily apparent from their name.
#
# Revision 1.15  2004/03/18  03:35:48  bills
# Moved iconbar iconglobal file path to common directory.
#
# Revision 1.14  2000/02/08  07:48:21  bills
# Reduced iconWidth and iconHeight to 26 (from 32).
#
# Revision 1.13  2000/02/05  07:16:30  bills
# Added the Apply button and scrollBarImplict icon control.
#
# Revision 1.12  2000/02/04  15:16:54  bills
# Major rewrite of iconbar.  Now the icons are pixmap images so
# we can have color.
#
# Revision 1.11  1999/08/06  18:37:25  bills
# Changes made to Tcl to make it compatible with second generation
# P&R tools and the name change to itools.
#
# Revision 1.10  1997/03/03  04:06:40  bills
# Now the user's icons are stored in ~/.timberwolf/twicons.
#
# Revision 1.9  1996/03/29  23:56:30  bills
# Now added TIX balloon help.
#
# Revision 1.8  1996/03/29  22:51:11  bills
# Got the statusbar of balloon help to work.
#
# Revision 1.7  1995/09/02  08:20:41  bills
# Added the Bubble Help field to the iconbar configure dialog
# box.  Now the user can customize the dialog help.
#
# Revision 1.6  1995/09/02  04:05:32  bills
# Added a third field to an iconBar which is the bubble help.
#
# Revision 1.5  1995/08/28  15:44:43  bills
# Now changes made to the iconbar will be displayed whenever the
# save button is pressed.
#
# Revision 1.4  1995/08/25  19:22:16  bills
# Changes made to tcl to upgrade to Tk 4.0.  Now iconbar works
# properly and added alert and input boxes.
#

# Procedure: IconBarConf
proc IconBarConf { iconBarName {iconBarPath ""} {iconBarProcs ""}} {
# xf ignore me 5
##########
# Procedure: IconBarConf
# Description: configure the menubutton and menus of
#              the given pathnames
# Arguments: iconBarName - the icon bar we configure
#            {iconBarPath} - the instertation pathname
#            {iconBarProcs} - the procedures to handle
# Returns: none
# Sideeffects: none
##########
# 
# global iconBar(activeBackground) - active background color
# global iconBar(activeForeground) - active foreground color
# global iconBar(background) - background color
# global iconBar(barBorder) - the width of the icon bar frame
# global iconBar(barRelief) - the relief of the icon bar frame
# global iconBar(font) - text font
# global iconBar(foreground) - foreground color
# global iconBar(iconBorder) - the border of the icons
# global iconBar(iconHeight) - the height of the icons
# global iconBar(iconOffset) - the offset between the icons
# global iconBar(iconRelief) - the relief of the buttons
# global iconBar(iconWidth) - the width of the icons
# global iconBar(scrollActiveForeground) - scrollbar active background color
# global iconBar(scrollBackground) - scrollbar background color
# global iconBar(scrollForeground) - scrollbar foreground color

  global iconBar

  if {![info exists iconBar(initialized)]} {
    return
  }
  set tmpButtonOpt ""
  set tmpFrameOpt ""
  set tmpMessageOpt ""
  set tmpScaleOpt ""
  set tmpScrollOpt ""
  if {"$iconBar(activeBackground)" != ""} {
    append tmpButtonOpt "-activebackground \"$iconBar(activeBackground)\" "
  }
  if {"$iconBar(activeForeground)" != ""} {
    append tmpButtonOpt "-activeforeground \"$iconBar(activeForeground)\" "
  }
  if {"$iconBar(background)" != ""} {
    append tmpButtonOpt "-background \"$iconBar(background)\" "
    append tmpFrameOpt "-background \"$iconBar(background)\" "
    append tmpMessageOpt "-background \"$iconBar(background)\" "
    append tmpScaleOpt "-background \"$iconBar(background)\" "
  }
  if {"$iconBar(font)" != ""} {
    append tmpButtonOpt "-font \"$iconBar(font)\" "
    append tmpMessageOpt "-font \"$iconBar(font)\" "
  }
  if {"$iconBar(foreground)" != ""} {
    append tmpButtonOpt "-foreground \"$iconBar(foreground)\" "
    append tmpMessageOpt "-foreground \"$iconBar(foreground)\" "
    append tmpScaleOpt "-foreground \"$iconBar(foreground)\" "
  }
  if {"$iconBar(scrollActiveForeground)" != ""} {
    append tmpScaleOpt "-activeforeground \"$iconBar(scrollActiveForeground)\" "
    append tmpScrollOpt "-activeforeground \"$iconBar(scrollActiveForeground)\" "
  }
  if {"$iconBar(scrollBackground)" != ""} {
    append tmpScrollOpt "-background \"$iconBar(scrollBackground)\" "
  }
  if {"$iconBar(scrollForeground)" != ""} {
    append tmpScrollOpt "-foreground \"$iconBar(scrollForeground)\" "
  }

  set iconBar(curIcon) 0
  # start build of toplevel
  if {"[info commands XFDestroy]" != ""} {
    catch {XFDestroy .iconBarEdit}
  } {
    catch {destroy .iconBarEdit}
  }
  toplevel .iconBarEdit  -borderwidth 0
  catch ".iconBarEdit config $tmpFrameOpt"
  wm geometry .iconBarEdit 520x400
  wm title .iconBarEdit {Menu configuration}
  wm maxsize .iconBarEdit 1000 1000
  wm minsize .iconBarEdit 100 100
  # end build of toplevel

  frame .iconBarEdit.frame1  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1 config $tmpFrameOpt"
 
  frame .iconBarEdit.frame1.frame2  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame2 config $tmpFrameOpt"
 
  frame .iconBarEdit.frame1.frame2.frame4  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame2.frame4 config $tmpFrameOpt"
 
  frame .iconBarEdit.frame1.frame2.frame5  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame2.frame5 config $tmpFrameOpt"
 
  frame .iconBarEdit.frame1.frame2.frame6  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame2.frame6 config $tmpFrameOpt"
 
  frame .iconBarEdit.frame1.frame7  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame7 config $tmpFrameOpt"
 
  frame .iconBarEdit.frame1.frame3  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame3 config $tmpFrameOpt"
 
  frame .iconBarEdit.frame1.frame4  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame4 config $tmpFrameOpt"

  frame .iconBarEdit.frame1.frame8  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame8 config $tmpFrameOpt"

  frame .iconBarEdit.frame1.frame9  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame9 config $tmpFrameOpt"

  frame .iconBarEdit.frame1.frame10  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame10 config $tmpFrameOpt"
 
  label .iconBarEdit.frame1.frame2.frame4.message1  -anchor c  -relief raised  -text "Available Icons:"
  catch ".iconBarEdit.frame1.frame2.frame4.message1 config $tmpMessageOpt"
  
  scrollbar .iconBarEdit.frame1.frame2.frame4.vscroll  -relief raised  -command ".iconBarEdit.frame1.frame2.frame4.icons yview"
  catch ".iconBarEdit.frame1.frame2.frame4.vscroll config $tmpScrollOpt"

  scrollbar .iconBarEdit.frame1.frame2.frame4.hscroll  -orient horiz  -relief raised  -command ".iconBarEdit.frame1.frame2.frame4.icons xview"
  catch ".iconBarEdit.frame1.frame2.frame4.hscroll config $tmpScrollOpt"

  listbox .iconBarEdit.frame1.frame2.frame4.icons  -exportselection false  -relief raised  -xscrollcommand ".iconBarEdit.frame1.frame2.frame4.hscroll set"  -yscrollcommand ".iconBarEdit.frame1.frame2.frame4.vscroll set"
  catch ".iconBarEdit.frame1.frame2.frame4.icons config $tmpMessageOpt"

  label .iconBarEdit.frame1.frame2.frame5.message1  -anchor c  -relief raised  -text "Procedures:"
  catch ".iconBarEdit.frame1.frame2.frame5.message1 config $tmpMessageOpt"
  
  scrollbar .iconBarEdit.frame1.frame2.frame5.vscroll  -relief raised  -command ".iconBarEdit.frame1.frame2.frame5.procs yview"
  catch ".iconBarEdit.frame1.frame2.frame5.vscroll config $tmpScrollOpt"

  scrollbar .iconBarEdit.frame1.frame2.frame5.hscroll  -orient horiz  -relief raised  -command ".iconBarEdit.frame1.frame2.frame.procs xview"
  catch ".iconBarEdit.frame1.frame2.frame5.hscroll config $tmpScrollOpt"

  listbox .iconBarEdit.frame1.frame2.frame5.procs  -exportselection false  -relief raised  -xscrollcommand ".iconBarEdit.frame1.frame2.frame5.hscroll set"  -yscrollcommand ".iconBarEdit.frame1.frame2.frame5.vscroll set"
  catch ".iconBarEdit.frame1.frame2.frame5.procs config $tmpMessageOpt"

  label .iconBarEdit.frame1.frame2.frame6.message1  -anchor c  -relief raised  -text "Current Iconbar:"
  catch ".iconBarEdit.frame1.frame2.frame6.message1 config $tmpMessageOpt"
  
  scrollbar .iconBarEdit.frame1.frame2.frame6.vscroll  -relief raised  -command ".iconBarEdit.frame1.frame2.frame6.bar yview"
  catch ".iconBarEdit.frame1.frame2.frame6.vscroll config $tmpScrollOpt"

  scrollbar .iconBarEdit.frame1.frame2.frame6.hscroll  -orient horiz  -relief raised  -command ".iconBarEdit.frame1.frame2.frame6.bar xview"
  catch ".iconBarEdit.frame1.frame2.frame6.hscroll config $tmpScrollOpt"

  listbox .iconBarEdit.frame1.frame2.frame6.bar  -exportselection false  -relief raised  -xscrollcommand ".iconBarEdit.frame1.frame2.frame6.hscroll set"  -yscrollcommand ".iconBarEdit.frame1.frame2.frame6.vscroll set"
  catch ".iconBarEdit.frame1.frame2.frame6.bar config $tmpMessageOpt"

  scale .iconBarEdit.frame1.frame2.frame6.mover  -orient vertical  -width 8  -relief raised  -sliderlength 15  -from 0  -command "IconBarReposition \"$iconBarName\""
  catch ".iconBarEdit.frame1.frame2.frame6.mover config $tmpScaleOpt"

  frame .iconBarEdit.frame1.frame4.bitmap  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame4.bitmap config $tmpFrameOpt"
 
  label .iconBarEdit.frame1.frame4.bitmap.message1  -anchor c  -relief raised  -text "Current bitmap:"
  catch ".iconBarEdit.frame1.frame4.bitmap.message1 config $tmpMessageOpt"
  
  label .iconBarEdit.frame1.frame4.bitmap.bitmap  -image $iconBar(defaultBitmap) -anchor c  -relief raised
  catch ".iconBarEdit.frame1.frame4.bitmap.bitmap config $tmpMessageOpt"
  
  label .iconBarEdit.frame1.frame4.message1  -anchor c  -relief raised  -text "Command:"
  catch ".iconBarEdit.frame1.frame4.message1 config $tmpMessageOpt"
  
  frame .iconBarEdit.frame1.frame4.command  -borderwidth 0  -relief raised
  catch ".iconBarEdit.frame1.frame4.command config $tmpFrameOpt"

  text .iconBarEdit.frame1.frame4.command.command  -height 7  -relief raised  -wrap none  -borderwidth 2  -yscrollcommand ".iconBarEdit.frame1.frame4.command.vscroll set"
  catch ".iconBarEdit.frame1.frame4.command.command config $tmpMessageOpt"

  scrollbar .iconBarEdit.frame1.frame4.command.vscroll  -relief raised  -command ".iconBarEdit.frame1.frame4.command.command yview"
  catch ".iconBarEdit.frame1.frame4.command.vscroll config $tmpScrollOpt"

# This is for bubble help.
  text .iconBarEdit.frame1.frame8.command -height 3  -relief raised  -wrap none  -borderwidth 2 -yscrollcommand ".iconBarEdit.frame1.frame8.vscroll set"
#  catch ".iconBarEdit.frame1.frame4.command.command config $tmpMessageOpt"

  scrollbar .iconBarEdit.frame1.frame8.vscroll  -relief raised  -command ".iconBarEdit.frame1.frame8.command yview"
  catch ".iconBarEdit.frame1.frame8.vscroll config $tmpScrollOpt"

  label .iconBarEdit.frame1.frame8.message1  -anchor c  -relief raised  -text "Balloon\nHelp:"
  catch ".iconBarEdit.frame1.frame8.message1 config $tmpMessageOpt"

# This for second part of Bubble Help.
  text .iconBarEdit.frame1.frame9.command -height 3  -relief raised  -wrap none  -borderwidth 2 -yscrollcommand ".iconBarEdit.frame1.frame9.vscroll set"
#  catch ".iconBarEdit.frame1.frame4.command.command config $tmpMessageOpt"

  scrollbar .iconBarEdit.frame1.frame9.vscroll  -relief raised  -command ".iconBarEdit.frame1.frame9.command yview"
  catch ".iconBarEdit.frame1.frame9.vscroll config $tmpScrollOpt"

  label .iconBarEdit.frame1.frame9.message1  -anchor c  -relief raised  -text "Status\nHelp:"
  catch ".iconBarEdit.frame1.frame9.message1 config $tmpMessageOpt"

  label .iconBarEdit.frame1.frame10.message1  -anchor c  -relief raised  -text "Implicit Scroll Icon:"
  catch ".iconBarEdit.frame1.frame10.message1 config $tmpMessageOpt"

  radiobutton .iconBarEdit.frame1.frame10.none -relief flat -text "none" \
    -variable iconBar(scrollBarImplicit) -value 0
  radiobutton .iconBarEdit.frame1.frame10.first -relief flat -text "first" \
    -variable iconBar(scrollBarImplicit) -value 1
  radiobutton .iconBarEdit.frame1.frame10.last -relief flat -text "last" \
    -variable iconBar(scrollBarImplicit) -value -1



# On to add comand.
  button .iconBarEdit.frame1.frame7.insert  -text "Add"  -command "IconBarInsert \"$iconBarName\""
  catch ".iconBarEdit.frame1.frame7.insert config $tmpButtonOpt"

  button .iconBarEdit.frame1.frame7.insertsep  -text "Add separator"  -command "IconBarInsert \"$iconBarName\" sep"
  catch ".iconBarEdit.frame1.frame7.insertsep config $tmpButtonOpt"

  button .iconBarEdit.frame1.frame7.insertspace  -text "Add space"  -command "IconBarInsert \"$iconBarName\" space"
  catch ".iconBarEdit.frame1.frame7.insertspace config $tmpButtonOpt"

  button .iconBarEdit.frame1.frame7.modify  -text "Edit"  -command "IconBarModify \"$iconBarName\""
  catch ".iconBarEdit.frame1.frame7.modify config $tmpButtonOpt"

  button .iconBarEdit.frame1.frame7.delete  -text "Remove"  -command "
      if {\[.iconBarEdit.frame1.frame2.frame6.bar size\] > 0} {
        IconBarDelete \"$iconBarName\"
      }"
  catch ".iconBarEdit.frame1.frame7.delete config $tmpButtonOpt"

  button .iconBarEdit.frame1.frame3.ok  -text "OK"  -command "
      if {\"$iconBarPath\" != \"\"} {
        IconBarShow $iconBarName $iconBarPath
      }
      if {\"\[info commands XFDestroy\]\" != \"\"} {
        catch {XFDestroy .iconBarEdit}
      } {
        catch {destroy .iconBarEdit}
      }"
  catch ".iconBarEdit.frame1.frame3.ok config $tmpButtonOpt"

  button .iconBarEdit.frame1.frame3.apply  -text "Apply" \
    -command "IconBarSaveUpdate $iconBarName .itools.fdraw.frame4"
  catch ".iconBarEdit.frame1.frame3.apply config $tmpButtonOpt"

  button .iconBarEdit.frame1.frame3.save  -text "Save" \
    -command "IconBarSave ; IconBarSaveUpdate $iconBarName .itools.fdraw.frame4"
  catch ".iconBarEdit.frame1.frame3.save config $tmpButtonOpt"

  # bindings
  bind .iconBarEdit.frame1.frame2.frame4.icons <ButtonPress-1> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame4.icons <Button1-Motion> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame4.icons <Shift-ButtonPress-1> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame4.icons <Shift-Button1-Motion> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame5.procs <ButtonPress-1> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame5.procs <Button1-Motion> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame5.procs <Shift-ButtonPress-1> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame5.procs <Shift-Button1-Motion> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame6.bar <ButtonPress-1> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame6.bar <Button1-Motion> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame6.bar <Shift-ButtonPress-1> "
   IconBarSelect %W \"$iconBarName\" %y"
  bind .iconBarEdit.frame1.frame2.frame6.bar <Shift-Button1-Motion> "
   IconBarSelect %W \"$iconBarName\" %y"
  IconBarReadIcons
  IconBarReadProcs $iconBarProcs
  IconBarReadIconBar $iconBarName

  # packing
  pack append .iconBarEdit.frame1.frame7  .iconBarEdit.frame1.frame7.insert {left fill expand}  .iconBarEdit.frame1.frame7.insertsep {left fill expand}  .iconBarEdit.frame1.frame7.insertspace {left fill expand}  .iconBarEdit.frame1.frame7.modify {left fill expand}  .iconBarEdit.frame1.frame7.delete {left fill expand}
  pack append .iconBarEdit.frame1.frame3  .iconBarEdit.frame1.frame3.ok {left fill expand}  .iconBarEdit.frame1.frame3.apply {left fill expand} .iconBarEdit.frame1.frame3.save {left fill expand}
  pack append .iconBarEdit.frame1.frame2.frame4  .iconBarEdit.frame1.frame2.frame4.message1 {top fill}  .iconBarEdit.frame1.frame2.frame4.vscroll "$iconBar(scrollSide) filly"  .iconBarEdit.frame1.frame2.frame4.hscroll {bottom fillx}  .iconBarEdit.frame1.frame2.frame4.icons {left fill expand}
  pack append .iconBarEdit.frame1.frame2.frame5  .iconBarEdit.frame1.frame2.frame5.message1 {top fill}  .iconBarEdit.frame1.frame2.frame5.vscroll "$iconBar(scrollSide) filly"  .iconBarEdit.frame1.frame2.frame5.hscroll {bottom fillx}  .iconBarEdit.frame1.frame2.frame5.procs {left fill expand}
  pack append .iconBarEdit.frame1.frame2.frame6  .iconBarEdit.frame1.frame2.frame6.message1 {top fill}  .iconBarEdit.frame1.frame2.frame6.mover {right filly}  .iconBarEdit.frame1.frame2.frame6.vscroll "$iconBar(scrollSide) filly"  .iconBarEdit.frame1.frame2.frame6.hscroll {bottom fillx}  .iconBarEdit.frame1.frame2.frame6.bar {left fill expand}
  pack append .iconBarEdit.frame1.frame2  .iconBarEdit.frame1.frame2.frame4 {left fill expand}  .iconBarEdit.frame1.frame2.frame5 {left fill expand}  .iconBarEdit.frame1.frame2.frame6 {left fill expand}
  pack append .iconBarEdit.frame1.frame4.bitmap  .iconBarEdit.frame1.frame4.bitmap.message1 {top fill}  .iconBarEdit.frame1.frame4.bitmap.bitmap {top fill expand}
  pack append .iconBarEdit.frame1.frame4.command  .iconBarEdit.frame1.frame4.command.vscroll "$iconBar(scrollSide) filly"  .iconBarEdit.frame1.frame4.command.command {left fill expand}
  pack append .iconBarEdit.frame1.frame4  .iconBarEdit.frame1.frame4.bitmap {left fill}  .iconBarEdit.frame1.frame4.message1 {top fill}  .iconBarEdit.frame1.frame4.command {top fill expand}
  pack append .iconBarEdit.frame1.frame8 .iconBarEdit.frame1.frame8.message1  {left fill} .iconBarEdit.frame1.frame8.vscroll  {left fill} .iconBarEdit.frame1.frame8.command {left fill}
  pack append .iconBarEdit.frame1.frame9 .iconBarEdit.frame1.frame9.message1  {left fill} .iconBarEdit.frame1.frame9.vscroll  {left fill} .iconBarEdit.frame1.frame9.command {left fill}
  pack append .iconBarEdit.frame1.frame10 .iconBarEdit.frame1.frame10.message1  {left fill}
  pack .iconBarEdit.frame1.frame10.none -side left -padx 10
  pack .iconBarEdit.frame1.frame10.first -side left -padx 10
  pack .iconBarEdit.frame1.frame10.last -side left -padx 10
  pack append .iconBarEdit.frame1 \
    .iconBarEdit.frame1.frame3 {bottom fill} \
    .iconBarEdit.frame1.frame7 {bottom fill} \
    .iconBarEdit.frame1.frame10 {bottom fill} \
    .iconBarEdit.frame1.frame8 {bottom fill} \
    .iconBarEdit.frame1.frame9 {bottom fill} \
    .iconBarEdit.frame1.frame4 {bottom fill} \
    .iconBarEdit.frame1.frame2 {top fill expand}
  pack append .iconBarEdit  .iconBarEdit.frame1 {top fill expand}

  update idletask
}


# Procedure: IconBarDelete
proc IconBarDelete { iconBarName} {
# xf ignore me 6
  global iconBar

  if {[.iconBarEdit.frame1.frame2.frame6.bar size] > 0} {
    .iconBarEdit.frame1.frame2.frame6.bar delete $iconBar(curIcon)
    if {[info exists iconBar(bar,$iconBarName)]} {
      set iconBar(bar,$iconBarName)  [lreplace $iconBar(bar,$iconBarName) $iconBar(curIcon) $iconBar(curIcon)]
    }
    .iconBarEdit.frame1.frame2.frame6.bar select set $iconBar(curIcon)
    .iconBarEdit.frame1.frame2.frame6.bar select anchor $iconBar(curIcon)
    set iconBar(curIcon) [.iconBarEdit.frame1.frame2.frame6.bar curselection]
    .iconBarEdit.frame1.frame2.frame6.mover config  -to [llength $iconBar(bar,$iconBarName)]
  } {
    .iconBarEdit.frame1.frame2.frame6.mover config  -to 0
  }
}


# Procedure: IconBarInit
proc IconBarInit { iconBarUserFile iconBarFile iconBarIcons} {
# xf ignore me 5
##########
# Procedure: IconBarInit
# Description: initialize the configuration of menubuttons and
#              menus of specified pathnames
# Arguments: iconBarUserFile - the user specific loadfile
#            iconBarFile - the default loadfile
#            iconBarIcons - the default icon pathname
# Returns: none
# Sideeffects: none
##########

  global iconBar

  set iconBar(initialized) 1
  set iconBar(file) $iconBarFile
  set iconBar(userFile) $iconBarUserFile
  set iconBar(icons) $iconBarIcons
  if {[file exists $iconBar(userFile)]} {
    if {[catch "source \"$iconBar(userFile)\"" iconBarResult]} {
      puts stderr $iconBarResult
    }
  } {
    if {[file exists $iconBar(file)]} {
      if {[catch "source \"$iconBar(file)\"" iconBarResult]} {
        puts stderr $iconBarResult
      }
    }
  }

  set tmpIcon iconBarSw
  set tmpIconName gray50
  foreach tmpIconPath [split $iconBar(icons) :] {
    if {[file exists $tmpIconPath/$tmpIcon]} {
      set tmpIconName $tmpIconPath/$tmpIcon
      break
    }
  }
  set iconBar(switchBitmap) $tmpIconName

  set tmpIcon iconBarSc
  set tmpIconName gray50
  foreach tmpIconPath [split $iconBar(icons) :] {
    if {[file exists $tmpIconPath/$tmpIcon]} {
      set tmpIconName $tmpIconPath/$tmpIcon
      break
    }
  }
  set iconBar(scrollBitmap) $tmpIconName
}


# Procedure: IconBarInsert
proc IconBarInsert { iconBarName {iconBarType ""}} {
# xf ignore me 6
  global iconBar

  if {"$iconBarType" == "sep"} {
    set tmpValue "Iconbar-separator"
    .iconBarEdit.frame1.frame2.frame6.bar insert $iconBar(curIcon) $tmpValue
    lappend tmpValue { }
    if {[info exists iconBar(bar,$iconBarName)]} {
      set iconBar(bar,$iconBarName)  [linsert $iconBar(bar,$iconBarName) $iconBar(curIcon) $tmpValue]
    } {
      set iconBar(bar,$iconBarName) ""
      lappend iconBar(bar,$iconBarName) $tmpValue
    }
  } {
    if {"$iconBarType" == "space"} {
      set tmpValue "Iconbar-space"
      .iconBarEdit.frame1.frame2.frame6.bar insert $iconBar(curIcon) $tmpValue
      lappend tmpValue { }
      if {[info exists iconBar(bar,$iconBarName)]} {
        set iconBar(bar,$iconBarName)  [linsert $iconBar(bar,$iconBarName) $iconBar(curIcon) $tmpValue]
      } {
        set iconBar(bar,$iconBarName) ""
        lappend iconBar(bar,$iconBarName) $tmpValue
      }
    } {
      set tmpValue [file tail [lindex [.iconBarEdit.frame1.frame4.bitmap.bitmap config -image] 4]]
      foreach tmpImage [array names iconBar image,*] {
	if {"$iconBar($tmpImage)" == "$tmpValue"} {
	  set tmpValue [string range $tmpImage 6 end]
	  break
	}
      }
      .iconBarEdit.frame1.frame2.frame6.bar insert $iconBar(curIcon) $tmpValue
      lappend tmpValue [.iconBarEdit.frame1.frame4.command.command get 1.0 end]
      if {[info exists iconBar(bar,$iconBarName)]} {
        set iconBar(bar,$iconBarName)  [linsert $iconBar(bar,$iconBarName) $iconBar(curIcon) $tmpValue]
      } {
        set iconBar(bar,$iconBarName) ""
        lappend iconBar(bar,$iconBarName) $tmpValue
      }
    }
  }
  .iconBarEdit.frame1.frame2.frame6.mover config  -to [llength $iconBar(bar,$iconBarName)]
  incr iconBar(curIcon)
}


# Procedure: IconBarModify
proc IconBarModify { iconBarName} {
# xf ignore me 6
  global iconBar

  set tmpValue [file tail [lindex [.iconBarEdit.frame1.frame4.bitmap.bitmap config -image] 4]]
  foreach tmpImage [array names iconBar image,*] {
    if {"$iconBar($tmpImage)" == "$tmpValue"} {
      set tmpValue [string range $tmpImage 6 end]
      break
    }
  }

  if {"[lindex [lindex $iconBar(bar,$iconBarName) $iconBar(curIcon)] 0]" != "Iconbar-separator" &&
      "[lindex [lindex $iconBar(bar,$iconBarName) $iconBar(curIcon)] 0]" != "Iconbar-space"} {
    .iconBarEdit.frame1.frame2.frame6.bar delete $iconBar(curIcon)
    .iconBarEdit.frame1.frame2.frame6.bar insert $iconBar(curIcon) $tmpValue
    lappend tmpValue \
      [.iconBarEdit.frame1.frame4.command.command get 1.0 end-1char] \
      [.iconBarEdit.frame1.frame9.command get 1.0 end-1char] \
      [.iconBarEdit.frame1.frame8.command get 1.0 end-1char]
    if {[info exists iconBar(bar,$iconBarName)]} {
      set iconBar(bar,$iconBarName)  [lreplace $iconBar(bar,$iconBarName) $iconBar(curIcon) $iconBar(curIcon) $tmpValue]
    } {
      set iconBar(bar,$iconBarName) $tmpValue
    }
  }
}


# Procedure: IconBarReadIconBar
proc IconBarReadIconBar { iconBarName} {
# xf ignore me 6
  global iconBar

  if {[info exists iconBar(bar,$iconBarName)]} {
    foreach tmpIcon $iconBar(bar,$iconBarName) {
      .iconBarEdit.frame1.frame2.frame6.bar insert end [lindex $tmpIcon 0]
    }
  }
  if {[.iconBarEdit.frame1.frame2.frame6.bar size] > 0} {
    .iconBarEdit.frame1.frame2.frame6.mover config  -to [llength $iconBar(bar,$iconBarName)]
  }
}



# Procedure: IconBarReadIcons
proc IconBarReadIcons {} {
# xf ignore me 6
  global iconBar

  set tmpIconList [array names iconBar image,*]

  if {[info exists tmpIconList]} {
    foreach tmpIcon [lsort $tmpIconList] {
      set shortname [string range $tmpIcon 6 end]
      .iconBarEdit.frame1.frame2.frame4.icons insert end $shortname
    }
  }
}


# Procedure: IconBarReadProcs
proc IconBarReadProcs { iconBarProcs} {
# xf ignore me 6

  foreach tmpProcs [lsort $iconBarProcs] {
    .iconBarEdit.frame1.frame2.frame5.procs insert end $tmpProcs
  }
}


# Procedure: IconBarRemove
proc IconBarRemove { iconBarName {iconBarPath ""}} {
# xf ignore me 5
##########
# Procedure: IconBarRemove
# Description: remove the icon bar
# Arguments: iconBarName - the icon bar name
#            {iconBarPath} - the instertation pathname
# Returns: none
# Sideeffects: none
##########

  set tmpPath .iconBar$iconBarName
  if {"[info commands $tmpPath]" != ""} {
      catch "destroy $tmpPath"
  }
  if {"[info commands $iconBarPath]" != ""} {
    foreach counter [winfo children $iconBarPath] {
      if {"[info commands XFDestroy]" != ""} {
        catch "XFDestroy $counter"
      } {
        catch "destroy $counter"
      }
    }
    pack unpack $iconBarPath
  }
}


# Procedure: IconBarReposition
proc IconBarReposition { iconBarName iconBarPos} {
# xf ignore me 6
  global iconBar

  if {[.iconBarEdit.frame1.frame2.frame6.bar size] > 0} {
    if {$iconBarPos < [llength $iconBar(bar,$iconBarName)]} {
      .iconBarEdit.frame1.frame2.frame6.bar delete $iconBar(curIcon)
      if {[info exists iconBar(bar,$iconBarName)]} {
       set tmpSaveValue [lindex $iconBar(bar,$iconBarName) $iconBar(curIcon)]
         set iconBar(bar,$iconBarName)  [lreplace $iconBar(bar,$iconBarName) $iconBar(curIcon) $iconBar(curIcon)]
      }
      set iconBar(curIcon) $iconBarPos
      .iconBarEdit.frame1.frame2.frame6.bar insert $iconBar(curIcon)  [file tail [lindex $tmpSaveValue 0]]
      if {[info exists iconBar(bar,$iconBarName)]} {
        set iconBar(bar,$iconBarName)  [linsert $iconBar(bar,$iconBarName) $iconBar(curIcon)  $tmpSaveValue]
      } {
        set iconBar(bar,$iconBarName) ""
        lappend iconBar(bar,$iconBarName) $tmpSaveValue
      }
    }
    .iconBarEdit.frame1.frame2.frame6.bar select anchor $iconBar(curIcon)
    .iconBarEdit.frame1.frame2.frame6.bar select set $iconBar(curIcon)
  }
}


# Procedure: IconBarSave
proc IconBarSave {} {
# xf ignore me 6
  global iconBar

  set dirname [file dirname $iconBar(userFile)]
  if {![file exists $dirname]} {
    if {[catch "exec mkdir -p $dirname" outFile]} {
      puts stderr $outFile
    }
  }
  if {![catch "open $iconBar(userFile) w" outFile]} {
    puts $outFile "# icon bar configuration"
    puts $outFile "global iconBar"
    foreach counter [lsort [array names iconBar]]) {
      if {[string match "bar,*" $counter]} {
        puts $outFile "# icon bar: [string range $counter 4 end]"
        puts $outFile "set iconBar($counter) \{[set iconBar($counter)]\}"
      }
    }
    puts $outFile "# eof"
    close $outFile
  } {
    puts stderr $outFile
  }
}


# Procedure: IconBarSelect
proc IconBarSelect { iconBarW iconBarName iconBarY} {
# xf ignore me 6
  global iconBar

  .iconBarEdit.frame1.frame2.frame4.icons select clear 0 end
  .iconBarEdit.frame1.frame2.frame5.procs select clear 0 end
  .iconBarEdit.frame1.frame2.frame6.bar select clear 0 end

  set iconBarNearest [$iconBarW nearest $iconBarY]
  if {$iconBarNearest >= 0} {
    $iconBarW select anchor $iconBarNearest
    $iconBarW select set $iconBarNearest
    set selectedValue [$iconBarW get $iconBarNearest]
    if {"$iconBarW" == ".iconBarEdit.frame1.frame2.frame4.icons"} {
      if {"$selectedValue" != "Iconbar-separator" &&
          "$selectedValue" != "Iconbar-space"} {
        foreach tmpIconPath [split $iconBar(icons) :] {
          if {[file exists $tmpIconPath] && [file readable $tmpIconPath] &&
              [file isdirectory $tmpIconPath] &&
              [file exists $tmpIconPath/$selectedValue]} {
            .iconBarEdit.frame1.frame4.bitmap.bitmap config -image $iconBar(image,$selectedValue)
            break
          }
        }
      } {
        .iconBarEdit.frame1.frame4.bitmap.bitmap config  -image $iconBar(defaultBitmap)
      }
    } {
      if {"$iconBarW" == ".iconBarEdit.frame1.frame2.frame5.procs"} {
        .iconBarEdit.frame1.frame4.command.command delete 1.0 end
        .iconBarEdit.frame1.frame4.command.command insert 1.0 $selectedValue
      } {
        set iconBar(curIcon) $iconBarNearest
        if {"$selectedValue" != "Iconbar-separator" &&
            "$selectedValue" != "Iconbar-space"} {
          foreach tmpIconPath [split $iconBar(icons) :] {
            if {[file exists $tmpIconPath] && [file readable $tmpIconPath] &&
                [file isdirectory $tmpIconPath] &&
                [file exists $tmpIconPath/$selectedValue]} {
              .iconBarEdit.frame1.frame4.bitmap.bitmap config -image $iconBar(image,$selectedValue)
              break
            }
          }
        } {
          .iconBarEdit.frame1.frame4.bitmap.bitmap config -image $iconBar(defaultBitmap)
        }
        .iconBarEdit.frame1.frame4.command.command delete 1.0 end
        .iconBarEdit.frame1.frame4.command.command insert 1.0 [lindex [lindex $iconBar(bar,$iconBarName) $iconBarNearest] 1]
        .iconBarEdit.frame1.frame9.command delete 1.0 end
        .iconBarEdit.frame1.frame9.command insert 1.0 [lindex [lindex $iconBar(bar,$iconBarName) $iconBarNearest] 2]
        .iconBarEdit.frame1.frame8.command delete 1.0 end
        .iconBarEdit.frame1.frame8.command insert 1.0 [lindex [lindex $iconBar(bar,$iconBarName) $iconBarNearest] 3]
      }
    }
  }
}


# Procedure: IconBarShow
proc IconBarShow { iconBarName {iconBarPath ""} {iconBarStatus ""}} {
# xf ignore me 5
##########
# Procedure: IconBarShow
# Description: show the icon bar
# Arguments: iconBarName - the icon bar name
#            {iconBarPath} - the instertation pathname
#            {iconBarStatus} - create "toplevel" or "child"
# Returns: none
# Sideeffects: none
##########
# 
# global iconBar(activeBackground) - active background color
# global iconBar(activeForeground) - active foreground color
# global iconBar(background) - background color
# global iconBar(barBorder) - the width of the icon bar frame
# global iconBar(barIgnoreSep) - ignore separators in toplevel mode
# global iconBar(barRelief) - the relief of the icon bar frame
# global iconBar(font) - text font
# global iconBar(foreground) - foreground color
# global iconBar(iconBorder) - the border of the icons
# global iconBar(iconHeight) - the height of the icons
# global iconBar(iconOffset) - the offset between the icons
# global iconBar(iconRelief) - the relief of the buttons
# global iconBar(iconWidth) - the width of the icons
# global iconBar(scrollActiveForeground) - scrollbar active background color
# global iconBar(scrollBackground) - scrollbar background color
# global iconBar(scrollForeground) - scrollbar foreground color
# global iconBar(scrollSide) - side where scrollbar is located

  global iconBar

  if {![info exists iconBar(initialized)]} {
    return
  }
  set tmpButtonOpt ""
  set tmpFrameOpt ""
  set tmpMessageOpt ""
  if {"$iconBar(activeBackground)" != ""} {
    append tmpButtonOpt "-activebackground \"$iconBar(activeBackground)\" "
  }
  if {"$iconBar(activeForeground)" != ""} {
    append tmpButtonOpt "-activeforeground \"$iconBar(activeForeground)\" "
  }
  if {"$iconBar(background)" != ""} {
    append tmpButtonOpt "-background \"$iconBar(background)\" "
    append tmpFrameOpt "-background \"$iconBar(background)\" "
    append tmpMessageOpt "-background \"$iconBar(background)\" "
  }
  if {"$iconBar(font)" != ""} {
    append tmpButtonOpt "-font \"$iconBar(font)\" "
    append tmpMessageOpt "-font \"$iconBar(font)\" "
  }
  if {"$iconBar(foreground)" != ""} {
    append tmpButtonOpt "-foreground \"$iconBar(foreground)\" "
    append tmpMessageOpt "-foreground \"$iconBar(foreground)\" "
  }

  if {"[info commands $iconBarPath]" == ""} {
    set iconBarStatus "toplevel"
  } {
    foreach counter [winfo children $iconBarPath] {
      if {"[info commands XFDestroy]" != ""} {
        catch "XFDestroy $counter"
      } {
        catch "destroy $counter"
      }
    }
 }

  set iconBar(bar_status) $iconBarStatus
  if {"$iconBarStatus" == "toplevel"} {
    set tmpPath .iconBar$iconBarName
    if {"[info commands $tmpPath]" == ""} {
      if {"$iconBar(packing)" == "" &&  "[info commands $iconBarPath]" != ""} {
        set iconBar(packing) [pack info [winfo parent $iconBarPath]]
        pack unpack $iconBarPath
      }
      # start build of iconbar toplevel
      toplevel $tmpPath  -borderwidth 0
      catch "$tmpPath config $tmpFrameOpt"
      wm title $tmpPath "Icon bar: $iconBarName"
      # end build of iconbar toplevel
    } {
      foreach counter [winfo children $tmpPath] {
        if {"[info commands XFDestroy]" != ""} {
          catch "XFDestroy $counter"
        } {
          catch "destroy $counter"
        }
      }
    }
        
    if {$iconBar(barIgnoreSep)} {
      frame $tmpPath.iconBar  -borderwidth $iconBar(barBorder)  -relief $iconBar(barRelief)
      catch "$tmpPath.iconBar config $tmpFrameOpt"

      if {[info exists iconBar(bar,$iconBarName)]} {
        set tmpCounter 0
        foreach counter $iconBar(bar,$iconBarName) {
          if {"[lindex $counter 0]" == "Iconbar-space"} {
            frame $tmpPath.iconBar.space$tmpCounter  -borderwidth 0  -height 2  -relief flat  -width 6
            catch "$tmpPath.iconBar.space$tmpCounter config $tmpFrameOpt"

            pack append $tmpPath.iconBar  $tmpPath.iconBar.space$tmpCounter "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
            incr tmpCounter
          } {
            if {"[lindex $counter 0]" != "Iconbar-separator"} {
              set tmpIcon [lindex $counter 0]
	      if {[catch {set tmpIconImage $iconBar(image,$tmpIcon)} msg]} {
		puts stderr "ERROR\[IconBarShow]: $msg for icon:$tmpIcon"
		continue ;
	      }
              button $tmpPath.iconBar.button$tmpCounter  -image $tmpIconImage -relief $iconBar(iconRelief)  -height $iconBar(iconHeight)  -width $iconBar(iconWidth)  -command [lindex $counter 1]
              catch "$tmpPath.iconBar.button$tmpCounter config $tmpButtonOpt"

              pack append $tmpPath.iconBar  $tmpPath.iconBar.button$tmpCounter "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
              incr tmpCounter
            }
          }
        }
      }

      if {"[info commands $iconBarPath]" != ""} {
        button $tmpPath.iconBar.buttonswitch  -image $iconBar(switchBitmap)  -borderwidth $iconBar(iconBorder)  -relief $iconBar(iconRelief)  -height $iconBar(iconHeight)  -width $iconBar(iconWidth)  -command "IconBarSwitch $iconBarName $iconBarPath"
        catch "$tmpPath.iconBar.buttonswitch config $tmpButtonOpt"
         pack append $tmpPath.iconBar  $tmpPath.iconBar.buttonswitch "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
      }
      pack append $tmpPath  $tmpPath.iconBar {top fill expand}
    } {
      frame $tmpPath.iconBar  -borderwidth 0
      catch "$tmpPath.iconBar config $tmpFrameOpt"

      set sepCounter 0
      set tmpCounter 0
      frame $tmpPath.iconBar.row$sepCounter  -borderwidth $iconBar(barBorder)  -relief $iconBar(barRelief)
      catch "$tmpPath.iconBar.row$sepCounter config $tmpFrameOpt"

      if {[info exists iconBar(bar,$iconBarName)]} {
        foreach counter $iconBar(bar,$iconBarName) {
          if {"[lindex $counter 0]" == "Iconbar-separator"} {
            pack append $tmpPath.iconBar $tmpPath.iconBar.row$sepCounter {top fill}
            incr sepCounter
            frame $tmpPath.iconBar.row$sepCounter -borderwidth $iconBar(barBorder)  -relief $iconBar(barRelief)
            catch "$tmpPath.iconBar.row$sepCounter config $tmpFrameOpt"
          }
          if {"[lindex $counter 0]" == "Iconbar-space"} {
            frame $tmpPath.iconBar.row$sepCounter.space$tmpCounter  -borderwidth 0  -height 2  -relief flat  -width 6
            catch "$tmpPath.iconBar.row$sepCounter.space$tmpCounter config $tmpFrameOpt"

            pack append $tmpPath.iconBar.row$sepCounter  $tmpPath.iconBar.row$sepCounter.space$tmpCounter "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
            incr tmpCounter
          } {
	    set icon_name [lindex $counter 0]
            if {"$icon_name" != "Iconbar-separator" && "$icon_name" != "iconBarSc"} {
              set tmpIcon [lindex $counter 0]
	      if {[catch {set tmpIconImage $iconBar(image,$tmpIcon)} msg]} {
		puts stderr "ERROR\[IconBarShow]: $msg for icon:$tmpIcon"
		continue ;
	      }
              button $tmpPath.iconBar.row$sepCounter.button$tmpCounter -image $tmpIconImage -borderwidth $iconBar(iconBorder)  -relief $iconBar(iconRelief)  -height $iconBar(iconHeight)  -width $iconBar(iconWidth)  -command [lindex $counter 1] -text [list [lindex $counter 2] [lindex $counter 3]]
	      IconBalloonHelp $tmpPath.iconBar.row$sepCounter.button$tmpCounter 
              catch "$tmpPath.iconBar.row$sepCounter.button$tmpCounter config $tmpButtonOpt"

              pack append $tmpPath.iconBar.row$sepCounter  $tmpPath.iconBar.row$sepCounter.button$tmpCounter "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
              incr tmpCounter
            }
          }
        }
      }

      if {"[info commands $iconBarPath]" != ""} {
        button $tmpPath.iconBar.row$sepCounter.buttonswitch  -image $iconBar(switchBitmap)  -borderwidth $iconBar(iconBorder)  -relief $iconBar(iconRelief)  -height $iconBar(iconHeight)  -width $iconBar(iconWidth)  -command "IconBarSwitch $iconBarName $iconBarPath"
        catch "$tmpPath.iconBar.row$sepCounter.buttonswitch config $tmpButtonOpt"
         pack append $tmpPath.iconBar.row$sepCounter  $tmpPath.iconBar.row$sepCounter.buttonswitch "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
      }
      pack append $tmpPath.iconBar  $tmpPath.iconBar.row$sepCounter {top fill}
      pack append $tmpPath  $tmpPath.iconBar {top fill expand}
    }
  } {
    set tmpPath .iconBar$iconBarName
    if {"$iconBar(packing)" != ""} {
      catch "pack append [winfo parent $iconBarPath] $iconBar(packing)"
      set iconBar(packing) ""
    }
    if {"[info commands $tmpPath]" != ""} {
      catch "destroy $tmpPath"
    }
    set tmpPath $iconBarPath
      
    frame $tmpPath.iconBar  -borderwidth $iconBar(barBorder)  -relief $iconBar(barRelief)
    catch "$tmpPath.iconBar config $tmpFrameOpt"

    if {[info exists iconBar(bar,$iconBarName)]} {
      set tmpCounter 0
      set sepCounter 0
      foreach counter $iconBar(bar,$iconBarName) {
        if {"[lindex $counter 0]" == "Iconbar-separator"} {
          incr sepCounter
        }
      }

      if {$sepCounter < $iconBar(curBar)} {
        set iconBar(curBar) 0
      }
      set sepCounter 0
      foreach counter $iconBar(bar,$iconBarName) {
        if {"[lindex $counter 0]" == "Iconbar-separator"} {
          incr sepCounter
        }
        if {$sepCounter == $iconBar(curBar)} {
	  # We can add implicit scrolling here.  This is the start case.
	  if {"$iconBar(scrollBarImplicit)" == "1" && "$tmpCounter" == "0"} {
	    button $tmpPath.iconBar.button$tmpCounter -image \
	      $iconBar(image,iconBarSc) -borderwidth $iconBar(iconBorder)  \
	      -height $iconBar(iconHeight)  -relief $iconBar(iconRelief) \
	      -width $iconBar(iconWidth) -command "IconBarScroll"
	    pack append $tmpPath.iconBar  $tmpPath.iconBar.button$tmpCounter \
	    "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
            incr tmpCounter
	  }
          if {"[lindex $counter 0]" == "Iconbar-space"} {
            frame $tmpPath.iconBar.space$tmpCounter  -borderwidth 0  -height 2  -relief flat  -width 6
            catch "$tmpPath.iconBar.space$tmpCounter config $tmpFrameOpt"

            pack append $tmpPath.iconBar  $tmpPath.iconBar.space$tmpCounter "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
            incr tmpCounter
          } {
            if {"[lindex $counter 0]" != "Iconbar-separator"} {
              set tmpIcon [lindex $counter 0]
	      if {[catch {set tmpIconImage $iconBar(image,$tmpIcon)} msg]} {
		puts stderr "ERROR\[IconBarShow]: $msg for icon:$tmpIcon"
		continue ;
	      }
              button $tmpPath.iconBar.button$tmpCounter  -image $tmpIconImage -borderwidth $iconBar(iconBorder)  -height $iconBar(iconHeight)  -relief $iconBar(iconRelief)  -width $iconBar(iconWidth)  -command [lindex $counter 1] -text [list [lindex $counter 2] [lindex $counter 3]] 
              catch "$tmpPath.iconBar.button$tmpCounter config $tmpButtonOpt"

              pack append $tmpPath.iconBar  $tmpPath.iconBar.button$tmpCounter "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
	      IconBalloonHelp $tmpPath.iconBar.button$tmpCounter
              incr tmpCounter
            }
          }
        }
      }
    }

    # We can add implicit scrolling here.
    if {"$iconBar(scrollBarImplicit)" == "-1"} {
      button $tmpPath.iconBar.button$tmpCounter -image $iconBar(image,iconBarSc) -borderwidth $iconBar(iconBorder)  -height $iconBar(iconHeight)  -relief $iconBar(iconRelief)  -width $iconBar(iconWidth) -command "IconBarScroll"
      pack append $tmpPath.iconBar  $tmpPath.iconBar.button$tmpCounter "top padx $iconBar(iconOffset) pady $iconBar(iconOffset)"
    }

    pack append $tmpPath  $tmpPath.iconBar {top fill expand}
  }
}

# initialize global variables
proc InitIconBar {} {
  global {iconBar}
  global env
  set libpath $::utdcache::libpathS
  set {iconBar(activeBackground)} {}
  set {iconBar(activeForeground)} {}
  set {iconBar(background)} {}
  set {iconBar(bar,default)} {{conf {IconBarConf default}}}
  set {iconBar(barBorder)} {2}
  set {iconBar(barIgnoreSep)} {0}
  set {iconBar(barRelief)} {sunken}
  set {iconBar(curBar)} {0}
  set {iconBar(curIcon)} {0}
  set {iconBar(file)} [file join $libpath iconglobal]
  set {iconBar(font)} {}
  set {iconBar(foreground)} {}
  set {iconBar(iconBorder)} {2}
  set {iconBar(iconOffset)} {0}
  set {iconBar(iconRelief)} {raised}
  set {iconBar(iconWidth)} {26}
  set {iconBar(iconHeight)} {26}
  set {iconBar(icons)} [file join $libpath icons]
  set {iconBar(initialized)} {1}
  set {iconBar(packing)} {}
  set {iconBar(scrollActiveForeground)} {}
  set {iconBar(scrollBackground)} {}
  set {iconBar(scrollForeground)} {}
  # scrollBarImplicit can be 0 (none) 1 (first) -1 (last) for scrollbar placement.
  set {iconBar(scrollBarImplicit)} {0}
  set {iconBar(scrollSide)} {left}
  set {iconBar(defaultRoot)} {.utdcache.processor.icons}
  foreach tmpIconPath [split $iconBar(icons) :] {
    foreach tmpIcon [glob ${tmpIconPath}/*] {
      if {[file exists $tmpIcon]} {
	if {[catch {set tmpIconImage [image create pixmap -file $tmpIcon]} msg]} {
	  continue ;
	}
	set short_name [file tail $tmpIcon]
	set iconBar(image,$short_name) $tmpIconImage
      }
    }
  }
  set {iconBar(defaultBitmap)} $iconBar(image,gray50)
  set {iconBar(switchBitmap)} $iconBar(image,iconBarSw)
  set {iconBar(scrollBitmap)} $iconBar(image,iconBarSc)
  set {iconBar(userFile)} [file join $libpath icons iconuser]
  set {iconBar(bar_status)} {child}
  IconBarInit $env(HOME)/.utdcache/icicons $libpath/iconglobal $libpath/icons
  IconBarShow default $iconBar(defaultRoot) child
}


# Update the icon setting when a save is made.
proc IconBarSaveUpdate { iconBarName iconBarWidget } {
  global {iconBar}
  if {"$iconBar(bar_status)" == "child"} {
    IconBarRemove $iconBarName $iconBarWidget
    IconBarShow $iconBarName $iconBarWidget child
#   repack the frame so we can see it.
    pack append .itools.fdraw \
      .itools.fdraw.frame4 {left frame n filly} \
      .itools.fdraw.frame7 {top frame center expand fill}

  } elseif {"$iconBar(bar_status)" == "toplevel"} {
    IconBarRemove $iconBarName
    IconBarShow $iconBarName
  }
}


# swap between a child and toplevel
proc IconBarSwitch { {iconBarName default} {iconBarWidget .itools.fdraw.frame4} } {
  global {iconBar}
  if {"$iconBar(bar_status)" == "toplevel"} {
    IconBarRemove $iconBarName
    IconBarShow $iconBarName $iconBarWidget child
#   repack the frame so we can see it.
    pack append .itools.fdraw \
      .itools.fdraw.frame4 {left frame n filly} \
      .itools.fdraw.frame7 {top frame center expand fill}

  } elseif {"$iconBar(bar_status)" == "child"} {
    IconBarRemove $iconBarName $iconBarWidget
    IconBarShow $iconBarName
  }
}

# scroll to next set of icons.
proc IconBarScroll { {iconBarName default} {iconBarWidget .itools.fdraw.frame4} } {
  global {iconBar}
  incr iconBar(curBar)
  set numSeparations 0
  foreach counter $iconBar(bar,$iconBarName) {
    if {"[lindex $counter 0]" == "Iconbar-separator"} {
      incr numSeparations
    }
  }
  if {$iconBar(curBar) > $numSeparations} {
    set iconBar(curBar) 0
  }
  IconBarRemove $iconBarName
  IconBarShow $iconBarName $iconBarWidget child
}

proc IconBalloonHelp { widget } {
  global icsymbolicNameG
  set info [$widget cget -text]
  set status [lindex $info 0] 
  set balloon [lindex $info 1] 

  set w $::utdcache::balloonS
  $w bind $widget -statusmsg "$status" -balloonmsg "$balloon"
}
