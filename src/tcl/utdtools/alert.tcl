# This implement a popup dialog.
# $Id: alert.tcl,v 1.13 2019/11/27 23:32:41 bills Exp $
# $Log: alert.tcl,v $
# Revision 1.13  2019/11/27 23:32:41  bills
# Rewrote that it now uses a namespace for most of the code.
#
# Revision 1.12  2018/11/12 14:45:56  bills
# Updated for RCS fiasco.
#
# Revision 1.12  2015/06/25 16:33:21  bills
# Now we override graphics initialization with the new twgraphics::suppres
# mechanism.
#
# Revision 1.11  2014/11/25 13:24:15  bills
# Added icalert_check_graphics so alert -graphics will properly deiconify.
#
# Revision 1.10  2014/07/23  20:05:24  bills
# Now the alert box uses a TixScrolledText widget for more functionality.
# Also added the ability to search the text.
#
# Revision 1.9  2008/01/11  18:38:54  bills
# Now we allow the icalert_user command start the graphics system.
#
# Revision 1.8  2005/01/20  23:51:13  bills
# Now we test to make sure that we are in graphics mode before launching
# an alert box.
#
# Revision 1.7  2004/06/24  16:32:41  bills
# Now we allow selection of msg function from the command line.
#
# Revision 1.6  2004/03/17  00:21:31  bills
# Rewrote the alert_user command so it works with the new ez_message
# command which is now similiar to icmessage.
#
# Revision 1.5  2004/03/15  17:05:18  bills
# Added icalert_yesno and separated message func types.  We will combine
# then in another edit.
#
# Revision 1.4  2003/09/10  12:24:03  bills
# Now determine the message command in icalert_user so we can use
# it in both EZ and other programs.
#
# Revision 1.3  2003/03/26  19:12:12  bills
# Added the icalert_user user common command.
#
# Revision 1.2  1999/11/02  13:57:59  bills
# Made the default alert box larger.
#
# Revision 1.1  1995/08/25  19:21:02  bills
# Initial revision
#
#
#
namespace eval utdtools {
  variable alertBoxS
  variable initS 0

  proc alert_init { } {
    variable initS
    variable alertBoxS
    if {!($initS)} {
      set alertBoxS(activeBackground) ""
      set alertBoxS(activeForeground) ""
      set alertBoxS(after) 0
      set alertBoxS(anchor) nw
      set alertBoxS(background) ""
      set alertBoxS(font) ""
      set alertBoxS(foreground) ""
      set alertBoxS(justify) center
      set alertBoxS(toplevelName) .alertBox
      set alertBoxS(button) 0
      set alertBoxS(search_flag) false
      set initS true
    }
  }

  proc AlertBox {{alertBoxMessage {Alert message}} {alertBoxCommand ""} {alertBoxGeometry 350x250+50+50} {alertBoxTitle "Alert box"} args} {# xf ignore me 5
    ##########
    # Procedure: AlertBox
    # Description: show alert box
    # Arguments: {alertBoxMessage} - the text to display
    #            {alertBoxCommand} - the command to call after ok
    #            {alertBoxGeometry} - the geometry for the window
    #            {alertBoxTitle} - the title for the window
    #            {args} - labels of buttons
    # Returns: The number of the selected button, ot nothing
    # Sideeffects: none
    # Notes: there exist also functions called:
    #          AlertBoxFile - to open and read a file automatically
    #          AlertBoxFd - to read from an already opened filedescriptor
    ##########
    #
    # global alertBox(activeBackground) - active background color
    # global alertBox(activeForeground) - active foreground color
    # global alertBox(after) - destroy alert box after n seconds
    # global alertBox(anchor) - anchor for message box
    # global alertBox(background) - background color
    # global alertBox(font) - message font
    # global alertBox(foreground) - foreground color
    # global alertBox(justify) - justify for message box
    # global alertBox(toplevelName) - the toplevel name

    variable alertBoxS
    alert_init

    if {[catch {set graphics_open [utdgraphics ready]} msg]} {
      return
    }
    if {!([utdgraphics ready])} {
      return ; # make sure graphics is open for business.
    }

    # show alert box
    if {[llength $args] > 0} {
      eval AlertBoxInternal "\{$alertBoxMessage\}" "\{$alertBoxCommand\}" "\{$alertBoxGeometry\}" "\{$alertBoxTitle\}" $args
    } else {
      AlertBoxInternal $alertBoxMessage $alertBoxCommand $alertBoxGeometry $alertBoxTitle
    }

    if {[llength $args] > 0} {
      # wait for the box to be destroyed
      update idletask
      grab $alertBoxS(toplevelName)
      tkwait window $alertBoxS(toplevelName)

      return $alertBoxS(button)
    }
  }

  proc AlertBoxFd {{alertBoxInFile ""} {alertBoxCommand ""} {alertBoxGeometry 350x150} {alertBoxTitle "Alert box"} args} {# xf ignore me 5
    ##########
    # Procedure: AlertBoxFd
    # Description: show alert box containing a filedescriptor
    # Arguments: {alertBoxInFile} - a filedescriptor to read. The descriptor
    #                               is closed after reading
    #            {alertBoxCommand} - the command to call after ok
    #            {alertBoxGeometry} - the geometry for the window
    #            {alertBoxTitle} - the title for the window
    #            {args} - labels of buttons
    # Returns: The number of the selected button, ot nothing
    # Sideeffects: none
    # Notes: there exist also functions called:
    #          AlertBox - to display a passed string
    #          AlertBoxFile - to open and read a file automatically
    ##########
    #
    # global alertBox(activeBackground) - active background color
    # global alertBox(activeForeground) - active foreground color
    # global alertBox(after) - destroy alert box after n seconds
    # global alertBox(anchor) - anchor for message box
    # global alertBox(background) - background color
    # global alertBox(font) - message font
    # global alertBox(foreground) - foreground color
    # global alertBox(justify) - justify for message box
    # global alertBox(toplevelName) - the toplevel name

    variable alertBoxS
    alert_init

    # check file existance
    if {"$alertBoxInFile" == ""} {
      puts stderr "No filedescriptor specified"
      return
    }

    set alertBoxMessage [read $alertBoxInFile]
    close $alertBoxInFile

    # show alert box
    if {[llength $args] > 0} {
      eval AlertBoxInternal "\{$alertBoxMessage\}" "\{$alertBoxCommand\}" "\{$alertBoxGeometry\}" "\{$alertBoxTitle\}" $args
    } else {
      AlertBoxInternal $alertBoxMessage $alertBoxCommand $alertBoxGeometry $alertBoxTitle
    }

    if {[llength $args] > 0} {
      # wait for the box to be destroyed
      update idletask
      grab $alertBoxS(toplevelName)
      tkwait window $alertBoxS(toplevelName)

      return $alertBoxS(button)
    }
  }

  proc AlertBoxFile {{alertBoxFile ""} {alertBoxCommand ""} {alertBoxGeometry 350x150} {alertBoxTitle "Alert box"} args} {# xf ignore me 5
    ##########
    # Procedure: AlertBoxFile
    # Description: show alert box containing a file
    # Arguments: {alertBoxFile} - filename to read
    #            {alertBoxCommand} - the command to call after ok
    #            {alertBoxGeometry} - the geometry for the window
    #            {alertBoxTitle} - the title for the window
    #            {args} - labels of buttons
    # Returns: The number of the selected button, ot nothing
    # Sideeffects: none
    # Notes: there exist also functions called:
    #          AlertBox - to display a passed string
    #          AlertBoxFd - to read from an already opened filedescriptor
    ##########
    #
    # global alertBox(activeBackground) - active background color
    # global alertBox(activeForeground) - active foreground color
    # global alertBox(after) - destroy alert box after n seconds
    # global alertBox(anchor) - anchor for message box
    # global alertBox(background) - background color
    # global alertBox(font) - message font
    # global alertBox(foreground) - foreground color
    # global alertBox(justify) - justify for message box
    # global alertBox(toplevelName) - the toplevel name

    variable alertBoxS
    alert_init

    # check file existance
    if {"$alertBoxFile" == ""} {
      puts stderr "No filename specified"
      return
    }

    if {[catch "open $alertBoxFile r" alertBoxInFile]} {
      puts stderr "$alertBoxInFile"
      return
    }

    set alertBoxMessage [read $alertBoxInFile]
    close $alertBoxInFile

    # show alert box
    if {[llength $args] > 0} {
      eval AlertBoxInternal "\{$alertBoxMessage\}" "\{$alertBoxCommand\}" "\{$alertBoxGeometry\}" "\{$alertBoxTitle\}" $args
    } else {
      AlertBoxInternal $alertBoxMessage $alertBoxCommand $alertBoxGeometry $alertBoxTitle
    }

    if {[llength $args] > 0} {
      # wait for the box to be destroyed
      update idletask
      grab $alertBoxS(toplevelName)
      tkwait window $alertBoxS(toplevelName)

      return $alertBoxS(button)
    }
  }

  ##########
  # Procedure: AlertBoxInternal
  # Description: show alert box internal
  # Arguments: alertBoxMessage - the text to display
  #            alertBoxCommand - the command to call after ok
  #            alertBoxGeometry - the geometry for the window
  #            alertBoxTitle - the title for the window
  #            args - labels of buttons
  # Returns: none
  # Sideeffects: none
  ##########
  proc AlertBoxInternal {alertBoxMessage alertBoxCommand alertBoxGeometry alertBoxTitle args} {# xf ignore me 6
    variable alertBoxS

    alert_init
    set tmpButtonOpt ""
    set tmpFrameOpt ""
    set tmpMessageOpt ""
    if {"$alertBoxS(activeBackground)" != ""} {
      append tmpButtonOpt "-activebackground \"$alertBoxS(activeBackground)\" "
    }
    if {"$alertBoxS(activeForeground)" != ""} {
      append tmpButtonOpt "-activeforeground \"$alertBoxS(activeForeground)\" "
    }
    if {"$alertBoxS(background)" != ""} {
      append tmpButtonOpt "-background \"$alertBoxS(background)\" "
      append tmpFrameOpt "-background \"$alertBoxS(background)\" "
      append tmpMessageOpt "-background \"$alertBoxS(background)\" "
    }
    if {"$alertBoxS(font)" != ""} {
      append tmpButtonOpt "-font \"$alertBoxS(font)\" "
      append tmpMessageOpt "-font \"$alertBoxS(font)\" "
    }
    if {"$alertBoxS(foreground)" != ""} {
      append tmpButtonOpt "-foreground \"$alertBoxS(foreground)\" "
      append tmpMessageOpt "-foreground \"$alertBoxS(foreground)\" "
    }

    # start build of toplevel
    catch {destroy $alertBoxS(toplevelName)}
    toplevel $alertBoxS(toplevelName) \
      -borderwidth 0
    catch "$alertBoxS(toplevelName) config $tmpFrameOpt"
    if {[catch "wm geometry $alertBoxS(toplevelName) $alertBoxGeometry"]} {
      wm geometry $alertBoxS(toplevelName) 350x150
    }
    wm title $alertBoxS(toplevelName) $alertBoxTitle
    # wm maxsize $alertBoxS(toplevelName) 1000 1000
    wm minsize $alertBoxS(toplevelName) 100 100
    # end build of toplevel

    set t [tixScrolledText $alertBoxS(toplevelName).message1 -scrollbar y]
    set text_widget [$t subwidget text]
    $text_widget insert end "$alertBoxMessage"
    # $text_widget configure -justify "$alertBoxS(justify)"
    $text_widget configure -state disabled
    $text_widget configure -wrap word

    # -anchor "$alertBoxS(anchor)" \
    # catch "$alertBoxS(toplevelName).message1 config $tmpMessageOpt"

    set xfTmpWidth \
      [string range $alertBoxGeometry 0 [expr {[string first x $alertBoxGeometry]-1}]]
    if {"$xfTmpWidth" != ""} {
      # set message size
      catch "$alertBoxS(toplevelName).message1 configure \
	-width [expr {$xfTmpWidth-10}]"
    }

    set fw [frame $alertBoxS(toplevelName).frame1 \
      -borderwidth 0 \
      -relief raised]
    catch "$alertBoxS(toplevelName).frame1 config $tmpFrameOpt"

    if {$alertBoxS(search_flag)} {
      set search_w [::icsearch::create $fw $text_widget]
      pack $search_w -side top -fill x -expand yes
    }

    set alertBoxCounter 0
    set buttonNum [llength $args]
    if {$buttonNum > 0} {
      while {$alertBoxCounter < $buttonNum} {
	button $alertBoxS(toplevelName).frame1.button$alertBoxCounter \
	  -text "[lindex $args $alertBoxCounter]" \
	  -command "
	    variable ::utdtools::alertBoxS
	    set ::utdtools::alertBoxS(button) $alertBoxCounter
	    if {\"\[info commands XFDestroy\]\" != \"\"} {
	      catch {XFDestroy $::utdtools::alertBoxS(toplevelName)}
	    } {
	      catch {destroy $::utdtools::alertBoxS(toplevelName)}
	    }"
	catch "$alertBoxS(toplevelName).frame1.button$alertBoxCounter config $tmpButtonOpt"

	pack $alertBoxS(toplevelName).frame1.button$alertBoxCounter -side left \
	  -fill x -expand yes

	incr alertBoxCounter
      }
    } else {
      button $alertBoxS(toplevelName).frame1.button0 \
	-text "OK" \
	-command "
	  variable ::utdtools::alertBoxS
	  set ::utdtools::alertBoxS(button) 0
	  if {\"\[info commands XFDestroy\]\" != \"\"} {
	    catch {XFDestroy $::utdtools::alertBoxS(toplevelName)}
	  } {
	    catch {destroy $::utdtools::alertBoxS(toplevelName)}
	  }
	  $alertBoxCommand"
      catch "$alertBoxS(toplevelName).frame1.button0 config $tmpButtonOpt"

      pack $alertBoxS(toplevelName).frame1.button0 -side left -fill x -expand 1
    }

    # packing
    pack $alertBoxS(toplevelName).frame1 -side bottom -fill both
    pack $alertBoxS(toplevelName).message1 -side top -fill both -expand yes

    if {$alertBoxS(after) != 0} {
      after [expr {$alertBoxS(after)*1000}] \
	"catch \"$alertBoxS(toplevelName).frame1.button0 invoke\""
    }
  }



  proc alert_yesno {msg} {
    # First determine message command
    if {[info commands ez_message] != ""} {
      set msg_func ez_message
    } else {
      set msg_func utdmsg
    }
    set ret_button [AlertBox $msg "" "350x250+50+50" "Query Box" yes no]
    if {$ret_button} {
      return 0
    } else {
      return 1
    }
  }
}

  # Forms of command :
  # icalert_user [-msg_func <function>|-graphics] message
  # icalert_user [-msg_func <function>|-graphics] type message
  # icalert_user [-msg_func <function>|-graphics] type routine message
proc utdalert_user {args} {

  # First determine message command
  if {[info commands ez_message] != ""} {
    set msg_func ez_message
  } else {
    set msg_func utdmsg
  }
  puts stderr "msg_func: $msg_func"
  set num [llength $args]
  if {$num > 2} {
    set graphics_flag false
    set skip_args 0
    for {set i 0} {$i < $num} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-msg_func"} {
	incr i
	if {$i < $num} {
	  set msg_func [lindex $args $i]
	  incr skip_args 2
	} else {
	  utdmsg errmsg $routine "Missing function argument to -msg_func option\n"
	  return ;
	}
      } elseif {$arg_el == "-graphics"} {
	set graphics_flag true
	incr skip_args
      }
    }
    set num [expr {$num - $skip_args}]
    set args [lrange $args $skip_args end]
    if {$graphics_flag} {
      set suppress_graphics [twgraphics::suppress]
      if {($suppress_graphics)} {
	set graphics_flag false
      }
    }
    if {$graphics_flag} {
      catch {utdalert_check_graphics}
      if {[catch {set graphics_open [utdready]} msg]} {
	set graphics_open false
      }
      if {!($graphics_open)} {
	# This needs to be run in global scope for it to work properly.
	uplevel #0 utdgraphics on
      }
    }
  }
  if {$num == 1} {
    set msg [lindex $args 0]
    set fullmsg "ERROR:$msg"
    if {$msg_func != ""} {
      $msg_func errmsg "Unknown message args : $args"
    }
    ::utdtools::AlertBox $fullmsg
  } elseif {$num == 2} {
    set type [lindex $args 0]
    set msg [lindex $args 1]
    set mtype [utdalert_error_type $type]
    if {$mtype != ""} {
      set fullmsg "$mtype:$msg"
      if {$msg_func != ""} {
	$msg_func $type null $msg
      }
      ::utdtools::AlertBox $fullmsg
    } else {
      if {$msg_func != ""} {
	$msg_func $type null $msg
      }
      ::utdtools::AlertBox $msg
    }
  } elseif {$num == 3} {
    set type [lindex $args 0]
    set routine [lindex $args 1]
    set msg [lindex $args 2]
    set mtype [utdalert_error_type $type]
    if {$routine == "null"} {
      set fullmsg "$msg"
    } else {
      set fullmsg "$mtype\[$routine\]:$msg"
    }
    if {$msg_func != ""} {
      $msg_func $type $routine $msg
    }
    ::utdtools::AlertBox $fullmsg
  } else {
    if {$msg_func != ""} {
      $msg_func error null "Unknown message args : $args"
    }
  }
}

proc utdalert_error_type {type} {
    switch -exact $type {
      errmsg {return "ERROR"}
      error {return "ERROR"}
      warn {return "WARNING"}
      warnmsg {return "WARNING"}
      msg {return ""}
      default {return ""}
    }
}

proc utdalert_check_graphics {} {
  if {[winfo exists .]} {
    wm withdraw .
    wm deiconify .
  }
}
# eof

