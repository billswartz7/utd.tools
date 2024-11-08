#!/usr/local/bin/wish -f
# Program: itools common
# $Id: hotkeys.tcl,v 1.5 2005/11/30 00:51:03 bills Exp $
# $Log: hotkeys.tcl,v $
# Revision 1.5  2005/11/30 00:51:03  bills
# Now we added the Select Key option so we automatically fill out
# the key in question.
#
# Revision 1.4  2005/11/15  15:06:13  bills
# Fixed problems with updating hot keys when editing commands with
# more than one word.
#
# Revision 1.3  2005/02/26  21:07:53  bills
# Updated for variable change from icdir => icdirG and symbolicName
# to icsymbolicNameG.
#
# Revision 1.2  2002/09/07  19:48:07  bills
# Added all optional argument to clean_bindings to insure that we clean
# the focus bindings.
#
# Revision 1.1  2002/09/07  19:38:28  bills
# Initial revision
#
#
#

namespace eval utdhotkeys {
  # array of bit masks to recognize the modifers:
  # - shift - mod5 masks taken from .../tcl/include/X11/X.h
  # - alt mask defined by analysing the status field of Alt-KeyPress
  #   (analysed on MS Windows)
  #
  array set masks [list \
  shift   [list [expr {1 <<  0}] "Shift"] \
  lock    [list [expr {1 <<  1}] "Lock"] \
  control [list [expr {1 <<  2}] "Control"] \
  mod1    [list [expr {1 <<  3}] "Mod1"] \
  mod2    [list [expr {1 <<  4}] "Mod2"] \
  mod3    [list [expr {1 <<  5}] "Mod3"] \
  mod4    [list [expr {1 <<  6}] "Mod4"] \
  mod5    [list [expr {1 <<  7}] "Mod5"] \
  alt     [list [expr {1 << 17}] "Alt"] \
  ];

  # MS Windows modifier name map:
  # - Mod1 is identical to "Num"-lock key
  # - Mod3 is identical to "Scroll"-lock key
  #
  set maps [list \
  "Mod1" "Num" \
  "Mod3" "Scroll" \
  ];

  variable inputS
  variable afteridS
  variable selectStateS 0

  proc editor { } {
    set w .utdhotkeys
    if {[winfo exists $w]} {
      wm withdraw $w
      wm deiconify $w
      return ;
    }
    toplevel $w

    # Window manager configurations
    wm positionfrom $w ""
    wm sizefrom $w ""
    # wm maxsize $w 1025 800
    wm minsize $w 10 10
    wm title $w {Hotkey Editor}

    ::utdhotkeys::display $w

  }

  proc display {w} {
    global utdsymbolicNameG
    global utdhotkeys_stateG
    variable select_stateS

    if {[info exists utdsymbolicNameG(utdcanvas)]} {
      set canvasw $utdsymbolicNameG(utdcanvas)
    } else {
      set canvasw UTDNONE
    }
    set f [frame $w.f1]
    pack $f -side left -expand yes -fill both -padx 4

    set l [label $f.l -text "Defined Hotkeys: "]

    set c $f.c
    tixCheckList $c -scrollbar auto -browsecmd "::utdhotkeys::select $f $c" \
	-radio true -options {
	hlist.columns 2
	hlist.header true
	hlist.indicator 1
	hlist.indent    20
    }
    set hl [$c subwidget hlist]

    # First some styles for the headers
    set utdhotkeys_stateG(style_header) [tixDisplayStyle text  -refwindow $hl \
      -fg black -anchor c \
      -padx 8 -pady 2\
      -font [tix option get bold_font ]]

    set utdhotkeys_stateG(style_hotkey) [tixDisplayStyle text  -refwindow $hl \
      -fg #602020 -padx 8 \
      -selectforeground  #602020 \
      -font [tix option get bold_font ]]

    set utdhotkeys_stateG(style_function) [tixDisplayStyle text  -refwindow $hl \
      -fg #202060 -padx 8 \
      -selectforeground  #202060 \
      -font [tix option get bold_font ]]

    $hl header create 0 -itemtype text -text {Hot key} -style $utdhotkeys_stateG(style_header)
    $hl header create 1 -itemtype text -text {Function} -style $utdhotkeys_stateG(style_header)

    if {$canvasw != "UTDNONE"} {
      set keys [lsort [bind $canvasw]]
      set focus_state "enter"
      foreach key $keys {
	set cmd [bind $canvasw $key]
	if {$key == "<Enter>"} {
	  set focus_state enter
	  continue
	} elseif {$key == "<Button>"} {
	  set focus_state button
	  continue
	} elseif {$key == "<Motion>"} {
	  continue
	}
	set row [$hl add $key -itemtype text -text $key -style $utdhotkeys_stateG(style_hotkey)]
	$hl item create $row 1 -itemtype text -text $cmd -style $utdhotkeys_stateG(style_function)
      }
    } else {
      set focus_state "none"
    }

    set ffocus [frame $f.focus -borderwidth {0} -relief flat]
    label $ffocus.info -borderwidth {0} -padx {8} -pady {0} -text {Focus:} \
      -width 9
    radiobutton $ffocus.enter -borderwidth {1} -pady {0} -text {on entry} \
	-value {0} -command "::utdhotkeys::set_focus $canvasw 0" -width 15 \
	-variable utdhotkeys_stateG(focus)
    radiobutton $ffocus.click -borderwidth {1} -pady {0} -text {on click} \
	-value {1} -command "::utdhotkeys::set_focus $canvasw 1" -width 15 \
	-variable utdhotkeys_stateG(focus)
    pack configure $ffocus.info -side left
    pack configure $ffocus.enter -side right -expand true
    pack configure $ffocus.click -side right -expand true

    set fhkey [frame $f.hkey]

    tixLabelEntry $fhkey.key -label "Hot Key:  " \
      -options {
	entry.width 10
	label.width 9
	label.anchor e
	entry.textVariable utdhotkeys_stateG(hotkey)
    }

    $fhkey.key configure -disabledforeground gray
    button $fhkey.chose_key -text "Select Key" -state disabled \
      -command  "::utdhotkeys::select_key $f"

    tixLabelEntry $f.func -label "Function:" \
      -options {
	disabledforeground gray
	entry.width 10
	label.width 9
	label.anchor e
	entry.textVariable utdhotkeys_stateG(func)
    }
    $f.func configure -disabledforeground gray

    # Now add the first row of buttons
    set fb [frame $f.buttons1 -borderwidth 0 -relief raised]
    button $fb.new -text "New" -command "::utdhotkeys::new $f $hl"
    button $fb.add -text "Add" -command "::utdhotkeys::add $f $hl"
    button $fb.edit -text "Edit" -command "::utdhotkeys::edit $f $hl"
    button $fb.update -text "Update" -command "::utdhotkeys::update $f $hl"
    button $fb.remove -text "Remove" -command "::utdhotkeys::remove $hl"
    pack configure $fb.new -side left -fill x -expand true
    pack configure $fb.add -side left -fill x -expand true
    pack configure $fb.edit -side left -fill x -expand true
    pack configure $fb.update -side left -fill x -expand true
    pack configure $fb.remove -side left -fill x -expand true

    # Now add the second row buttons
    set fb2 [frame $f.buttons2 -borderwidth 0 -relief raised]
    button $fb2.ok -text "Done" -command "::utdhotkeys::done $w"
    button $fb2.apply -text "Apply" -command "::utdhotkeys::apply $hl $canvasw"
    button $fb2.save -text "Save" -command "::utdhotkeys::save $hl $canvasw"
    pack configure $fb2.ok -side left -fill x -expand true
    pack configure $fb2.apply -side left -fill x -expand true
    pack configure $fb2.save -side left -fill x -expand true


    pack $l -side top -fill x -padx 4 -pady 4
    pack $c -expand yes -fill both -padx 4 -pady 4 -expand true
    pack configure $ffocus -fill x -pady {3} -side top -anchor c
    pack configure $fhkey -fill x -pady {3} -side top -anchor c
    pack configure $f.func -fill x -pady {3} -side top -anchor c
    pack configure $fb -fill x -pady {0} -side top
    pack configure $fb2 -fill x -pady {0} -side top

    pack configure $fhkey.key -side left -fill x -expand true
    pack configure $fhkey.chose_key -side left

    set select_stateS 0
    set_select_state $fhkey.chose_key false

    if {$focus_state == "enter"} {
      set_focus $canvasw 0
    } elseif {$focus_state == "button"} {
      set_focus $canvasw 1
    }
    $hl selection clear
    reset $f $hl

  }

  proc select_key {topw} {
    variable inputS
    set w [$topw.hkey.key subwidget entry]
    set state [set_select_state $topw.hkey.chose_key true]
    if {$state} {
      bind $w <KeyPress> {::utdhotkeys::keystate %K %s}
      icmessage imsg null "Key lookup mode on:\n"
    } else {
      bind $w <KeyPress> {}
      icmessage imsg null "Type mode on:\n"
    }
    focus $w
    set inputS ""
  }

  proc set_select_state {w update} {
    variable select_stateS
    if {$update} {
      if {$select_stateS} {
	set select_stateS 0
      } else {
	set select_stateS 1
      }
    }
    if {$select_stateS} {
      $w configure -background green
      $w configure -activebackground lightgreen
    } else {
      $w configure -background lightgray
      $w configure -activebackground gray86
    }
    return $select_stateS
  }

  proc keystate {K s} {
    variable inputS
    variable afteridS
    global utdhotkeys_stateG

    set bits [::utdhotkeys::keyModifiers $s 1]
    if {$bits != ""} {
      set value "<$bits-Key-$K>"
    } else {
      set value "<Key-$K>"
    }
    # puts "value: $value"
    set inputS $value
    if {[info exists afteridS]} {
       after cancel afteridS
    }
    set afteridS [after 1000 "::utdhotkeys::update_entry"]
  }

  proc update_entry {args} {
    variable inputS
    variable afteridS
    global utdhotkeys_stateG

    if {[info exists afteridS]} {
      after cancel afteridS
    }
    set utdhotkeys_stateG(hotkey) $inputS
  }

  proc keyModifiers {state {mapToRealName 0}} {
    variable masks ;
    variable maps ;

    set modifiers [list] ;

    foreach mask [array names masks] {
      lassign $masks($mask) bits label;

      if {$state & $bits} {
	lappend modifiers $label;
      }
    }

    set modifiers [join $modifiers "-"];

    if {$mapToRealName == 1} {
      set modifiers [string map $maps $modifiers];
    }
    return $modifiers;
  }


  proc set_focus {w focus_state} {
    global utdhotkeys_stateG

    bind $w <Enter> {}
    bind $w <Button> {}
    if {$focus_state} {
      bind $w <Button> "focus %W"
      set utdhotkeys_stateG(focus) 1
    } else {
      bind $w <Enter> "focus %W"
      set utdhotkeys_stateG(focus) 0
    }
  }

  proc select {topw w item} {
    set etype [tixEvent type]
    if {$etype == "<ButtonPress-1>"} {
      return ; # Don't want this event.
    }
    global utdhotkeys_stateG
    set hl [$w subwidget hlist]
    set utdhotkeys_stateG(item) $item
    set utdhotkeys_stateG(hotkey) $item
    set utdhotkeys_stateG(func) [$hl item cget $item 1 -text]
    $topw.hkey.key configure -state disabled
    $topw.hkey.chose_key configure -state disabled
    $topw.func configure -state disabled
  }

  proc new { topw hl } {
    global utdhotkeys_stateG

    set utdhotkeys_stateG(item) ""
    set utdhotkeys_stateG(hotkey) ""
    set utdhotkeys_stateG(func) ""
    $topw.hkey.key configure -state normal
    $topw.hkey.chose_key configure -state normal
    $topw.func configure -state normal
    $hl selection clear

  }

  proc add { topw hl } {
    global utdhotkeys_stateG

    if {$utdhotkeys_stateG(hotkey) != ""} {
      set row [$hl add $utdhotkeys_stateG(hotkey) -itemtype text \
	  -text $utdhotkeys_stateG(hotkey) -style $utdhotkeys_stateG(style_hotkey)]
      $hl item create $row 1 -itemtype text -text $utdhotkeys_stateG(func) \
	  -style $utdhotkeys_stateG(style_function)
    }
    reset $topw $hl
  }

  proc edit { topw hl } {
    global utdhotkeys_stateG

    if {$utdhotkeys_stateG(hotkey) != ""} {
      $topw.func configure -state normal
    }
  }

  proc remove { hl } {
    global utdhotkeys_stateG

    if {[info exists utdhotkeys_stateG(item)]} {
      set item $utdhotkeys_stateG(item)
      if {$item != ""} {
	$hl delete entry $item
      }
    }
  }

  proc clean_bindings { w args } {
    # first cleanup the bindings
    if {$args == "all"} {
      set keep_focus 0
    } else {
      set keep_focus 1
    }
    set keys [bind $w]
    foreach key $keys {
      if {($key == "<Enter>") && ($keep_focus)} {
	continue
      } elseif {($key == "<Button>") && ($keep_focus)} {
	continue
      } elseif {$key == "<Motion>"} {
	continue
      }
      bind $w $key {}
    }
  }

  proc apply { hl w } {
    # first cleanup the bindings
    clean_bindings $w

    # now the new bindings
    set newkeys [$hl info children]
    foreach key $newkeys {
      set func [$hl item cget $key 1 -text]
      bind $w $key $func
    }
  }

  proc reset { topw hl } {
    new $topw $hl
    $topw.hkey.key configure -state disabled
    $topw.hkey.chose_key configure -state disabled
    $topw.func configure -state disabled
  }

  proc update { topw hl } {
    global utdhotkeys_stateG

    if {$utdhotkeys_stateG(hotkey) != ""} {
      catch "$hl item configure $utdhotkeys_stateG(hotkey) 1 \
	    -text [list $utdhotkeys_stateG(func)]"
    }
    reset $topw $hl
  }

  proc save { hl w } {
    global icdirG 
    global utdhotkeys_stateG

    set filename "~/.itools/hotkeys.ini"
    set f [open $filename w]

    icmessage "Saving hotkeys to $filename..."

    # Get the date.
    set secs [clock seconds]
    set todays_date [clock format $secs]

    puts $f "# Hot keys saved from itools on $todays_date"

    puts $f "::utdhotkeys::clean_bindings $w all"
    set newkeys [lsort [$hl info children]]
    foreach key $newkeys {
      set func [$hl item cget $key 1 -text]
      puts $f "bind $w $key [list $func]"
    }

    if {$utdhotkeys_stateG(focus) == "1"} {
      puts $f "bind $w <Button> {focus %W}"
    } else {
      puts $f "bind $w <Enter> {focus %W}"
    }
    close $f
  }

  proc done { w } {
    destroy $w
  }

}

if {[info procs lassign] eq ""} {
  proc lassign {values args} {
    uplevel 1 [list foreach $args $values break]
    lrange $values [llength $args] end
  }
}
