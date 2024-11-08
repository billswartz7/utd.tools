#
#  Copyright (c) 1999 by TimberWolf Systems, Inc.
# 
#
#

namespace eval twez {
  variable configS
  variable EZiconS

  proc create_notebook {w args} {
      variable configS
      variable loadedS


      set delay_flag false
      set num_args [llength $args]
      for {set i 0} {$i < $num_args} {incr i} {
	set arg_el [lindex $args $i]
	if {$arg_el == "-delay" } {
	  set delay_flag true
	} else {
	  utdcalert_user errmsg EZ "Unknown arguments: $args\n"
	}
      }

      set rootdir $configS(E_rootdir)
      set ezdir [file join $rootdir tcl EZ html]

      set q $w
      set w [frame $w.f -background blue]

      # We use these options to set the sizes of the subwidgets inside the
      # notebook, so that they are well-aligned on the screen.
      #
      set name [tixOptionName $w]
      option add *$name*TixControl*entry.width 10
      option add *$name*TixControl*label.width 18
      option add *$name*TixControl*label.anchor e
      option add *$name*TixNoteBook*tagPadX 8

      # Save the root of the notebook
      EZset_state -notebook $w.nb

      # Create the notebook widget and set its backpagecolor to gray.
      # Note that the -backpagecolor option belongs to the "nbframe"
      # subwidget.
      tixNoteBook $w.nb -ipadx 6 -ipady 6 -height 1024 -width 1280
      $w config -bg gray
      $w.nb subwidget nbframe config -backpagecolor gray -activetabcolor blue

      # Create the tabs on the notebook. The -underline option
      # puts a underline on the first character of the labels of the tabs.
      # Keyboard accelerators will be defined automatically according
      # to the underlined character.	
      #
      #----------------------------------------
      # Create the welcome page
      #----------------------------------------
      set raisecmd "::twez::ez_hypertext $w.nb welcome $ezdir/welcome/welcome.html"
      set configS(E_rcmd,welcome) $raisecmd
      $w.nb add welcome -label "Welcome" -underline 0 \
	-createcmd "::twez::ez_page_init $w.nb welcome" \
	-raisecmd $raisecmd

      #----------------------------------------
      # Create the start page	
      #----------------------------------------
      set raisecmd "::twez::ez_hypertext $w.nb start $ezdir/starting/starting.html"
      set configS(E_rcmd,start) $raisecmd
      $w.nb add start   -label "Getting Started"   -underline 0 \
	-createcmd "::twez::ez_page_init $w.nb start" \
	-raisecmd $raisecmd

      #----------------------------------------
      # Create the lesson page	
      #----------------------------------------
      create_ez_page lesson

      #----------------------------------------
      # Create the problems page	
      #----------------------------------------
      create_ez_page problems

      #----------------------------------------
      # Create the solutions page	
      #----------------------------------------
      create_ez_page solutions

      #----------------------------------------
      # Create the resources page	
      #----------------------------------------
      set raisecmd "::twez::ez_hypertext $w.nb resources $ezdir/resources/resources.html"
      set configS(E_rcmd,resources) $raisecmd
      $w.nb add resources  -label "Resources"   -underline 0 \
	-createcmd "::twez::ez_page_init $w.nb resources" \
	-raisecmd $raisecmd

      #----------------------------------------
      # Create the customization page
      #----------------------------------------
      set raisecmd "::twez::ez_hypertext $w.nb custom $ezdir/EZ/html/custom/custom.html"
      set configS(E_rcmd,custom) $raisecmd
      $w.nb add custom -label "Customizing"   -underline 0 \
	-createcmd "::twez::ez_page_init $w.nb custom"  \
	-raisecmd $raisecmd

      pack $w.nb -expand true -fill both -padx 5 -pady 5 -side top -anchor w
      pack $w -expand true -fill both 

puts stderr "create_notebook: flag:$delay_flag"
      # If the delay flag is enabled, don't load the page just yet.
      if {$delay_flag} {
	return ;
      }
      # 
      # Now it is safe to load in the autosaved variables since the GUI is up.
      #
      # This file is automatically written by the Dynamic Documentation
      set ezdir [file nativename ~/.utdtools]
      set ezinit_file [file join $ezdir ez.ini]
      if {[file exists $ezinit_file]} {
puts stderr "sourcing ezinit file :$ezinit_file"
	source $ezinit_file
	if {[catch {::twez::page $::twez::configS(S_page) $::twez::configS(S_url)} msg]} {
	  utdalert_user warnmsg EZ "can't get page.  Probably ~/.utdtools/ez/ez.ini \
  is corrupt.  This is not fatal and probably due to an unsucessful exit from \
  a previous execution of EZ.  Unfortunately, all state info is lost."
	}
      } else {
	# See if we have any ez.ini of the form ez.ini.* 
	append ezinit_file *
	if {!([catch {set files [glob $ezinit_file]} msg])} {
	  if {$files != ""} {
	    utdalert_user errmsg EZ "No ~/.utdtools/ez/ez.ini \
    was present yet EZ initialization files were found ($files).  If you wish to \
    recover the state of one these files, rename it to $ezinit_file. If you wish to \
    remove this message delete these files."
	  } 
	}
	# Now raise the first page.
	$w.nb raise welcome
      }
      # Now it is safe to turn on autosave
puts stderr "setting autosave to 1"
      ::twez::EZset_state -autosave 1
      set loadedS 1
      # Now always perform an autosave on exit.
      rename exit exit.builtin

  }

  proc init {args} {
      variable configS
      array set configS {
	E_autosave 0
	E_rootdir ""
	E_project_menu ""
	E_message ""
	E_editing 0
	E_developer 0
	P_verilog 0
	S_fontsize medium
	S_indent 0.6
	S_autorender true
	S_user Novice
	S_project ""
	S_lesson ""
	S_study ""
	E_study_default {Embedded Systems}
      }
      global env
      if {[info exists env(EZDEVELOPER)]} {
	set configS(E_developer) 1
	puts stderr "Developer mode enabled."
      } else {
	set configS(E_developer) 0
      }
  }

  array set EZparam_map {
      -autosave E_autosave
      -project_menu E_project_menu
      -rootdir E_rootdir
      -toplevel E_toplevel
      -program S_program
      -project S_project
      -sleep S_sleeptime
      -design_win P_design_win
      -user S_user
      -lesson S_lesson
      -mode S_mode
      -locator P_locator
      -notebook E_notebook
      -page P_page
      -area S_study
      -fontsize S_fontsize
      -wpipe S_wpipe
      -editing E_editing
      -open_file S_open_file
      -program S_program
      -verilog P_verilog
      -display_mode S_display_mode
  }

  proc EZset_state {args} {
      variable configS
      set bad 0
      if {[catch {array set params $args}]} {
	return 0
      }
      foreach i [array names params] {
	incr bad [catch {set ::twez::configS($::twez::EZparam_map($i)) $params($i)}]
      }
      return [expr {$bad == 0}]
  }

  proc set_page_html {page html} {
      variable configS
puts stderr "entered set_page_html p:$page h:$html"
      if {[info exists configS(E_notebook)]} {
	set w $configS(E_notebook)
	if {$page == "lesson"} {
	  if {$html == ""} {
	    $w delete lesson
	    return
	  }
	  create_ez_page lesson
	  set current [$w pageconfigure lesson -raisecmd]
	  set cmd [lindex $current 4]
	  set newcmd [lreplace $cmd 3 3 $html]
	  $w pageconfigure lesson -raisecmd $newcmd
	} elseif {$page == "problems"} {
	  if {$html == ""} {
	    $w delete problems
	    return
	  }
	  create_ez_page problems
	  set current [$w pageconfigure problems -raisecmd]
	  set cmd [lindex $current 4]
	  set newcmd [lreplace $cmd 3 3 $html]
	  $w pageconfigure problems -raisecmd $newcmd
	} elseif {$page == "solutions"} {
	  if {$html == ""} {
	    $w delete solutions
	    return
	  }
	  create_ez_page solutions
	  set current [$w pageconfigure solutions -raisecmd]
	  set cmd [lindex $current 4]
	  set newcmd [lreplace $cmd 3 3 $html]
	  $w pageconfigure solutions -raisecmd $newcmd
	} elseif {$page == "resources"} {
	  set current [$w pageconfigure resources -raisecmd]
	  set cmd [lindex $current 4]
	  set newcmd [lreplace $cmd 3 3 $html]
	  $w pageconfigure resources -raisecmd $newcmd
	} elseif {$page == "custom"} {
	  utdmsg errmsg $routine "page:$page is not configurable.\n"
	} elseif {$page == "starting"} {
	  utdmsg errmsg $routine "page:$page is not configurable.\n"
	} elseif {$page == "welcome"} {
	  utdmsg errmsg $routine "page:$page is not configurable.\n"
	} else {
	  utdmsg errmsg $routine "unknown page:$page\n"
	  return ;
	}
      }
  }

  proc create_ez_page { page_name } {
      variable configS

      set rootdir $configS(E_rootdir)
      set ezdir [file join $rootdir tcl EZ html]

      if {[info exists configS(E_notebook)]} {
	set w $configS(E_notebook)
	set pages [$w pages]
	# See if page exists
	set exist_idx [lsearch $pages $page_name]
	if {$exist_idx >= 0} {
	  # No work to be done
	  return
	}
	if {$page_name == "lesson"} {
	  #----------------------------------------
	  # Create the lesson page	
	  #----------------------------------------
	  if {[info exists configS(S_lesson_html)]} {
	    set lesson_html $configS(S_lesson_html)
	  } else {
	    set lesson_html $ezdir/lesson/lesson.html
	  }
	  set raisecmd "::twez::ez_hypertext $w lesson $lesson_html"
	  set configS(E_rcmd,lesson) $raisecmd
	  $w add lesson -label "Lesson"   -underline 0 \
	    -createcmd "::twez::ez_page_init $w lesson" \
	    -raisecmd $raisecmd

	} elseif {$page_name == "problems"} {
	  #----------------------------------------
	  # Create the problems page	
	  #----------------------------------------
	  if {[info exists configS(S_problem_html)]} {
	    set problem_html $configS(S_problem_html)
	  } else {
	    set problem_html $ezdir/problems/problems.html
	  }
	  set raisecmd "::twez::ez_hypertext $w problems $problem_html"
	  set configS(E_rcmd,problems) $raisecmd
	  $w add problems -label "Problems"   -underline 0 \
	    -createcmd "::twez::ez_page_init $w problems" \
	    -raisecmd $raisecmd

	} elseif {$page_name == "solutions"} {
	  #----------------------------------------
	  # Create the solutions page	
	  #----------------------------------------
	  set raisecmd "::twez::ez_hypertext $w solutions $ezdir/solutions/solutions.html"
	  set configS(E_rcmd,solutions) $raisecmd
	  $w add solutions -label "Solutions"   -underline 0 \
	    -createcmd "::twez::ez_page_init $w solutions" \
	    -raisecmd $raisecmd
	}
      }
  }

  proc EZ {args} {
    ::utdtools::init
    wm withdraw .
    set w .ez
    toplevel $w
    wm protocol $w WM_DELETE_WINDOW ez_exit
    ::twez::init
    ::twez::EZset_state -rootdir [::utdtools::rootdir]
    ::twez::EZset_state -toplevel $w
    ::twez::HTML_stack_init
    set ::twez::loadedS 0

    # Initialize editing
    ::twez::edit_init

    wm title $w "EZlearn"
    tk appname ezlearn 

    # Now look to see if we have an .Xdefault file to read
    set Xfilename [file native ~/.Xdefaults]
    if {[file exists $Xfilename]} {
      if {[catch {option readfile $Xfilename} msg]} {
	puts stderr "ERROR:$msg"
      }
    }

    # Now determine the geometry.  See if the user has set it.  If not
    # use most of the screen.
    set geom [option get . geometry ezlearn]
    if {$geom == ""} {
      set wid [winfo screenwidth .ez]
      set hei [winfo screenheight .ez]
      set wid [expr {$wid - 80}]
      set hei [expr {$hei - 80}]
      set geom "${wid}x${hei}+10+20"
      puts stderr "Calculating geometry : $geom"
    } else {
      puts stderr "Using Xdefault geometry : $geom"
    }
    wm geometry $w $geom

    twez::ez_build_gui $w
    ::twez::create_notebook $w
  }
}


