#!/usr/local/bin/wish -f
# Program: gui common
# $Id$
# $Log$
#
#

namespace eval utdfonts {
  variable sizeS 0

  proc extract_size {fontset} {
    set flag [string is integer -failindex idx $fontset]
    if {$flag} {
      set point $fontset
    } else {
      set point [string range $fontset 0 $idx-1]
    }
    return $point
  }

  proc update_command_font { } {
    global {utdsymbolicNameG}
    if {[info exists utdsymbolicNameG(utdcommand)]} {
      set w $utdsymbolicNameG(utdcommand)
      set val [tix configure -fontset]
      set current [lindex $val 4]
      set point [extract_size $current]
      if {$point != ""} {
	$w configure -font [list Courier $point bold]
      }
    }
  }

  proc display { } {
    set w .utdfonts
    if [winfo exists $w] {
	wm deiconify $w
	raise $w
	return
    }
    set w [toplevel $w -bd 3 -relief raised]

    tixLabelFrame $w.label -label "UTD tools Font Control" -options {
      label.padX 5
    }
    pack $w.label -side left -expand yes -fill both
    set f [$w.label subwidget frame]

    tixComboBox $f.fonts -label "Font Size Select: " \
      -variable ::utdfonts::sizeS \
      -command "::utdfonts::update_fontset" \
      -dropdown true \
      -editable false \
      -options {
	   listbox.height 15
      }

    if {[info exists ::utdtools::rootdirS]} {
      set fontdir [file join $::utdtools::rootdirS lib tix8.4.3 pref]
      foreach font_file [glob -directory $fontdir -tails -nocomplain *.fsc] {
	# set point [extract_size $font_file]
	if {$font_file != ""} {
	  set point [file root $font_file]
	  $f.fonts insert end $point
	}
      }
      set val [tix configure -fontset]
      set current [lindex $val 4]
      set point [file root $current]
      tixSetSilent $f.fonts $point
    }


    tixButtonBox $f.box -orientation horizontal
    $f.box add done -text {Done} -underline 0 \
      -command "destroy $w" -width 8

    grid $f.fonts -sticky news
    grid $f.box -sticky news
    grid propagate $f true
    grid rowconfigure $f 0 -weight 1
    grid rowconfigure $f 0 -weight 2
    grid columnconfigure $f 0 -weight 1
  }

  proc update_fontset {args} {
    set fontset $args
    # puts stderr "Fontset changed to $fontset"
    if {$fontset != 0} {
      tix configure -fontset $fontset
      update_all
    }
  }

  proc recursive_window_update { win font } {
    set children [winfo children $win]
    if {$children != ""} {
      foreach w $children {
	catch {$w configure -font $font}
	recursive_window_update $w $font
      }
    }
  }

  proc update_all { } {
    global tixOption
    global utdsymbolicNameG
    update_command_font
    # Update the standard symbols if they exist
    if {[info exists utdsymbolicNameG]} {
      if {[info exists tixOption(font)]} {
	set font $tixOption(font)
	recursive_window_update . $font
	catch {$utdsymbolicNameG(utdbuttonl) configure -font $font}
	catch {$utdsymbolicNameG(utdbuttonc) configure -font $font}
	catch {$utdsymbolicNameG(utdbuttonr) configure -font $font}
	catch {$utdsymbolicNameG(utdmemory) configure -font $font}
	catch {$utdsymbolicNameG(utdpause) configure -font $font}
	catch {$utdsymbolicNameG(utdcmdlabel) configure -font $font}
	catch {$utdsymbolicNameG(utdposition) configure -font $font}
	catch {$utdsymbolicNameG(utdcontext) configure -font $font}
	catch {$utdsymbolicNameG(utdstatus) configure -font $font}
	catch {$utdsymbolicNameG(utdmessage) configure -font $font}
	catch {$utdsymbolicNameG(utdtranscript) configure -font $font}
	if {!([catch {set menus [winfo children $utdsymbolicNameG(utdmenu)]} msg])} {
	  foreach m $menus {
	    $m configure -font $font
	  }
	}
      }
    }
  }

}

