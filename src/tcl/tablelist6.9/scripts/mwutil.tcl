#==============================================================================
# Contains utility procedures for mega-widgets.
#
# Structure of the module:
#   - Namespace initialization
#   - Public utility procedures
#
# Copyright (c) 2000-2020  Csaba Nemethi (E-mail: csaba.nemethi@t-online.de)
#==============================================================================

package require Tk 8

#
# Namespace initialization
# ========================
#

namespace eval mwutil {
    #
    # Public variables:
    #
    variable version	2.16
    variable library
    if {$::tcl_version >= 8.4} {
	set library	[file dirname [file normalize [info script]]]
    } else {
	set library	[file dirname [info script]] ;# no "file normalize" yet
    }

    #
    # Public procedures:
    #
    namespace export	wrongNumArgs getAncestorByClass convEventFields \
			defineKeyNav processTraversal focusNext focusPrev \
			configureWidget fullConfigOpt fullOpt enumOpts \
			configureSubCmd attribSubCmd hasattribSubCmd \
			unsetattribSubCmd getScrollInfo getScrollInfo2 \
			isScrollable hasFocus genMouseWheelEvent \
			windowingSystem currentTheme scalingPercentage

    #
    # Make modified versions of the procedures tk_focusNext and
    # tk_focusPrev, to be invoked in the processTraversal command
    #
    proc makeFocusProcs {} {
	#
	# Enforce the evaluation of the Tk library file "focus.tcl"
	#
	tk_focusNext .

	#
	# Build the procedures focusNext and focusPrev
	#
	foreach dir {Next Prev} {
	    set procBody [info body tk_focus$dir]
	    regsub -all {winfo children} $procBody {getChildren $class} procBody
	    proc focus$dir {w class} $procBody
	}
    }
    makeFocusProcs 

    #
    # Invoked in the procedures focusNext and focusPrev defined above:
    #
    proc getChildren {class w} {
	if {[string compare [winfo class $w] $class] == 0} {
	    return {}
	} else {
	    return [winfo children $w]
	}
    }
}

#
# Public utility procedures
# =========================
#

#------------------------------------------------------------------------------
# mwutil::wrongNumArgs
#
# Generates a "wrong # args" error message.
#------------------------------------------------------------------------------
proc mwutil::wrongNumArgs args {
    set optList {}
    foreach arg $args {
	lappend optList \"$arg\"
    }
    return -code error "wrong # args: should be [enumOpts $optList]"
}

#------------------------------------------------------------------------------
# mwutil::getAncestorByClass
#
# Gets the path name of the widget of the specified class from the path name w
# of one of its descendants.  It is assumed that all of the ancestors of w
# exist (but w itself needn't exist).
#------------------------------------------------------------------------------
proc mwutil::getAncestorByClass {w class} {
    regexp {^(\..+)\..+$} $w dummy win
    while {[string compare [winfo class $win] $class] != 0} {
	set win [winfo parent $win]
    }

    return $win
}

#------------------------------------------------------------------------------
# mwutil::convEventFields
#
# Gets the path name of the widget of the specified class and the x and y
# coordinates relative to the latter from the path name w of one of its
# descendants and from the x and y coordinates relative to the latter.
#------------------------------------------------------------------------------
proc mwutil::convEventFields {w x y class} {
    set win [getAncestorByClass $w $class]
    set _x  [expr {$x + [winfo rootx $w] - [winfo rootx $win]}]
    set _y  [expr {$y + [winfo rooty $w] - [winfo rooty $win]}]

    return [list $win $_x $_y]
}

#------------------------------------------------------------------------------
# mwutil::defineKeyNav
#
# For a given mega-widget class, the procedure defines the binding tag
# ${class}KeyNav as a partial replacement for "all", by substituting the
# scripts bound to the events <Tab>, <Shift-Tab>, and <<PrevWindow>> with new
# ones which propagate these events to the mega-widget of the given class
# containing the widget to which the event was reported.  (The event
# <Shift-Tab> was replaced with <<PrevWindow>> in Tk 8.3.0.)  This tag is
# designed to be inserted before "all" in the list of binding tags of a
# descendant of a mega-widget of the specified class.
#------------------------------------------------------------------------------
proc mwutil::defineKeyNav class {
    foreach event {<Tab> <Shift-Tab> <<PrevWindow>>} {
	bind ${class}KeyNav $event \
	     [list mwutil::processTraversal %W $class $event]
    }

    bind Entry   <<TraverseIn>> { %W selection range 0 end; %W icursor end }
    bind Spinbox <<TraverseIn>> { %W selection range 0 end; %W icursor end }
}

#------------------------------------------------------------------------------
# mwutil::processTraversal
#
# Processes the given traversal event for the mega-widget of the specified
# class containing the widget w if that mega-widget is not the only widget
# receiving the focus during keyboard traversal within its toplevel widget.
#------------------------------------------------------------------------------
proc mwutil::processTraversal {w class event} {
    set win [getAncestorByClass $w $class]

    if {[string compare $event "<Tab>"] == 0} {
	set target [focusNext $win $class]
    } else {
	set target [focusPrev $win $class]
    }

    if {[string compare $target $win] != 0} {
	set focusWin [focus -displayof $win]
	if {[string length $focusWin] != 0} {
	    event generate $focusWin <<TraverseOut>>
	}

	focus $target
	event generate $target <<TraverseIn>>
    }

    return -code break ""
}

#------------------------------------------------------------------------------
# mwutil::configureWidget
#
# Configures the widget win by processing the command-line arguments specified
# in optValPairs and, if the value of initialize is true, also those database
# options that don't match any command-line arguments.
#------------------------------------------------------------------------------
proc mwutil::configureWidget {win configSpecsName configCmd cgetCmd \
			      optValPairs initialize} {
    upvar $configSpecsName configSpecs

    #
    # Process the command-line arguments
    #
    set cmdLineOpts {}
    set savedOptValPairs {}
    set failed 0
    set count [llength $optValPairs]
    foreach {opt val} $optValPairs {
	if {[catch {fullConfigOpt $opt configSpecs} result] != 0} {
	    set failed 1
	    break
	}
	if {$count == 1} {
	    set result "value for \"$opt\" missing"
	    set failed 1
	    break
	}
	set opt $result
	lappend cmdLineOpts $opt
	lappend savedOptValPairs $opt [eval $cgetCmd [list $win $opt]]
	if {[catch {eval $configCmd [list $win $opt $val]} result] != 0} {
	    set failed 1
	    break
	}
	incr count -2
    }

    if {$failed} {
	#
	# Restore the saved values
	#
	foreach {opt val} $savedOptValPairs {
	    eval $configCmd [list $win $opt $val]
	}

	return -code error $result
    }

    if {$initialize} {
	#
	# Process those configuration options that were not
	# given as command-line arguments; use the corresponding
	# values from the option database if available
	#
	foreach opt [lsort [array names configSpecs]] {
	    if {[llength $configSpecs($opt)] == 1 ||
		[lsearch -exact $cmdLineOpts $opt] >= 0} {
		continue
	    }
	    set dbName [lindex $configSpecs($opt) 0]
	    set dbClass [lindex $configSpecs($opt) 1]
	    set dbValue [option get $win $dbName $dbClass]
	    if {[string length $dbValue] == 0} {
		set default [lindex $configSpecs($opt) 3]
		eval $configCmd [list $win $opt $default]
	    } else {
		if {[catch {
		    eval $configCmd [list $win $opt $dbValue]
		} result] != 0} {
		    return -code error $result
		}
	    }
	}
    }

    return ""
}

#------------------------------------------------------------------------------
# mwutil::fullConfigOpt
#
# Returns the full configuration option corresponding to the possibly
# abbreviated option opt.
#------------------------------------------------------------------------------
proc mwutil::fullConfigOpt {opt configSpecsName} {
    upvar $configSpecsName configSpecs

    if {[info exists configSpecs($opt)]} {
	if {[llength $configSpecs($opt)] == 1} {
	    return $configSpecs($opt)
	} else {
	    return $opt
	}
    }

    set optList [lsort [array names configSpecs]]
    set count 0
    foreach elem $optList {
	if {[string first $opt $elem] == 0} {
	    incr count
	    if {$count == 1} {
		set option $elem
	    } else {
		break
	    }
	}
    }

    if {$count == 1} {
	if {[llength $configSpecs($option)] == 1} {
	    return $configSpecs($option)
	} else {
	    return $option
	}
    } elseif {$count == 0} {
	### return -code error "unknown option \"$opt\""
	return -code error \
	       "bad option \"$opt\": must be [enumOpts $optList]"
    } else {
	### return -code error "unknown option \"$opt\""
	return -code error \
	       "ambiguous option \"$opt\": must be [enumOpts $optList]"
    }
}

#------------------------------------------------------------------------------
# mwutil::fullOpt
#
# Returns the full option corresponding to the possibly abbreviated option opt.
#------------------------------------------------------------------------------
proc mwutil::fullOpt {kind opt optList} {
    if {[lsearch -exact $optList $opt] >= 0} {
	return $opt
    }

    set count 0
    foreach elem $optList {
	if {[string first $opt $elem] == 0} {
	    incr count
	    if {$count == 1} {
		set option $elem
	    } else {
		break
	    }
	}
    }

    if {$count == 1} {
	return $option
    } elseif {$count == 0} {
	return -code error \
	       "bad $kind \"$opt\": must be [enumOpts $optList]"
    } else {
	return -code error \
	       "ambiguous $kind \"$opt\": must be [enumOpts $optList]"
    }
}

#------------------------------------------------------------------------------
# mwutil::enumOpts
#
# Returns a string consisting of the elements of the given list, separated by
# commas and spaces.
#------------------------------------------------------------------------------
proc mwutil::enumOpts optList {
    set optCount [llength $optList]
    set n 1
    foreach opt $optList {
	if {$n == 1} {
	    set str $opt
	} elseif {$n < $optCount} {
	    append str ", $opt"
	} else {
	    if {$optCount > 2} {
		append str ","
	    }
	    append str " or $opt"
	}

	incr n
    }

    return $str
}

#------------------------------------------------------------------------------
# mwutil::configureSubCmd
#
# This procedure is invoked to process configuration subcommands.
#------------------------------------------------------------------------------
proc mwutil::configureSubCmd {win configSpecsName configCmd cgetCmd argList} {
    upvar $configSpecsName configSpecs

    set argCount [llength $argList]
    if {$argCount > 1} {
	#
	# Set the specified configuration options to the given values
	#
	return [configureWidget $win configSpecs $configCmd $cgetCmd $argList 0]
    } elseif {$argCount == 1} {
	#
	# Return the description of the specified configuration option
	#
	set opt [fullConfigOpt [lindex $argList 0] configSpecs]
	set dbName [lindex $configSpecs($opt) 0]
	set dbClass [lindex $configSpecs($opt) 1]
	set default [lindex $configSpecs($opt) 3]
	return [list $opt $dbName $dbClass $default \
		[eval $cgetCmd [list $win $opt]]]
    } else {
	#
	# Return a list describing all available configuration options
	#
	foreach opt [lsort [array names configSpecs]] {
	    if {[llength $configSpecs($opt)] == 1} {
		set alias $configSpecs($opt)
		if {$::tk_version >= 8.1} {
		    lappend result [list $opt $alias]
		} else {
		    set dbName [lindex $configSpecs($alias) 0]
		    lappend result [list $opt $dbName]
		}
	    } else {
		set dbName [lindex $configSpecs($opt) 0]
		set dbClass [lindex $configSpecs($opt) 1]
		set default [lindex $configSpecs($opt) 3]
		lappend result [list $opt $dbName $dbClass $default \
				[eval $cgetCmd [list $win $opt]]]
	    }
	}
	return $result
    }
}

#------------------------------------------------------------------------------
# mwutil::attribSubCmd
#
# This procedure is invoked to process *attrib subcommands.
#------------------------------------------------------------------------------
proc mwutil::attribSubCmd {win prefix argList} {
    set classNs [string tolower [winfo class $win]]
    upvar ::${classNs}::ns${win}::attribs attribs

    set argCount [llength $argList]
    if {$argCount > 1} {
	#
	# Set the specified attributes to the given values
	#
	if {$argCount % 2 != 0} {
	    return -code error "value for \"[lindex $argList end]\" missing"
	}
	foreach {attr val} $argList {
	    set attribs($prefix-$attr) $val
	}
	return ""
    } elseif {$argCount == 1} {
	#
	# Return the value of the specified attribute
	#
	set attr [lindex $argList 0]
	set name $prefix-$attr
	if {[info exists attribs($name)]} {
	    return $attribs($name)
	} else {
	    return ""
	}
    } else {
	#
	# Return the current list of attribute names and values
	#
	set len [string length "$prefix-"]
	set result {}
	foreach name [lsort [array names attribs "$prefix-*"]] {
	    set attr [string range $name $len end]
	    lappend result [list $attr $attribs($name)]
	}
	return $result
    }
}

#------------------------------------------------------------------------------
# mwutil::hasattribSubCmd
#
# This procedure is invoked to process has*attrib subcommands.
#------------------------------------------------------------------------------
proc mwutil::hasattribSubCmd {win prefix attr} {
    set classNs [string tolower [winfo class $win]]
    upvar ::${classNs}::ns${win}::attribs attribs

    return [info exists attribs($prefix-$attr)]
}

#------------------------------------------------------------------------------
# mwutil::unsetattribSubCmd
#
# This procedure is invoked to process unset*attrib subcommands.
#------------------------------------------------------------------------------
proc mwutil::unsetattribSubCmd {win prefix attr} {
    set classNs [string tolower [winfo class $win]]
    upvar ::${classNs}::ns${win}::attribs attribs

    set name $prefix-$attr
    if {[info exists attribs($name)]} {
	unset attribs($name)
    }

    return ""
}

#------------------------------------------------------------------------------
# mwutil::getScrollInfo
#
# Parses a list of arguments of the form "moveto <fraction>" or "scroll
# <number> units|pages" and returns the corresponding list consisting of two or
# three properly formatted elements.
#------------------------------------------------------------------------------
proc mwutil::getScrollInfo argList {
    set argCount [llength $argList]
    set opt [lindex $argList 0]

    if {[string first $opt "moveto"] == 0} {
	if {$argCount != 2} {
	    wrongNumArgs "moveto fraction"
	}

	set fraction [lindex $argList 1]
	format "%f" $fraction ;# floating-point number check with error message
	return [list moveto $fraction]
    } elseif {[string first $opt "scroll"] == 0} {
	if {$argCount != 3} {
	    wrongNumArgs "scroll number units|pages"
	}

	set number [format "%d" [lindex $argList 1]]
	set what [lindex $argList 2]
	if {[string first $what "units"] == 0} {
	    return [list scroll $number units]
	} elseif {[string first $what "pages"] == 0} {
	    return [list scroll $number pages]
	} else {
	    return -code error "bad argument \"$what\": must be units or pages"
	}
    } else {
	return -code error "unknown option \"$opt\": must be moveto or scroll"
    }
}

#------------------------------------------------------------------------------
# mwutil::getScrollInfo2
#
# Parses a list of arguments of the form "moveto <fraction>" or "scroll
# <number> units|pages" and returns the corresponding list consisting of two or
# three properly formatted elements.
#------------------------------------------------------------------------------
proc mwutil::getScrollInfo2 {cmd argList} {
    set argCount [llength $argList]
    set opt [lindex $argList 0]

    if {[string first $opt "moveto"] == 0} {
	if {$argCount != 2} {
	    wrongNumArgs "$cmd moveto fraction"
	}

	set fraction [lindex $argList 1]
	format "%f" $fraction ;# floating-point number check with error message
	return [list moveto $fraction]
    } elseif {[string first $opt "scroll"] == 0} {
	if {$argCount != 3} {
	    wrongNumArgs "$cmd scroll number units|pages"
	}

	set number [format "%d" [lindex $argList 1]]
	set what [lindex $argList 2]
	if {[string first $what "units"] == 0} {
	    return [list scroll $number units]
	} elseif {[string first $what "pages"] == 0} {
	    return [list scroll $number pages]
	} else {
	    return -code error "bad argument \"$what\": must be units or pages"
	}
    } else {
	return -code error "unknown option \"$opt\": must be moveto or scroll"
    }
}

#------------------------------------------------------------------------------
# mwutil::isScrollable
#
# Returns a boolean value indicating whether the widget w is scrollable along a
# given axis (x or y).
#------------------------------------------------------------------------------
proc mwutil::isScrollable {w axis} {
    set viewCmd ${axis}view
    return [expr {
	[catch {$w cget -${axis}scrollcommand}] == 0 &&
	[catch {$w $viewCmd} view] == 0 &&
	[catch {$w $viewCmd moveto [lindex $view 0]}] == 0 &&
	[catch {$w $viewCmd scroll 0 units}] == 0 &&
	[catch {$w $viewCmd scroll 0 pages}] == 0
    }]
}

#------------------------------------------------------------------------------
# mwutil::hasFocus
#
# Returns a boolean value indicating whether the focus window is (a descendant
# of) the widget w and has the same toplevel.
#------------------------------------------------------------------------------
proc mwutil::hasFocus w {
    set focusWin [focus -displayof $w]
    return [expr {
	[string first $w. $focusWin.] == 0 &&
	[string compare [winfo toplevel $w] [winfo toplevel $focusWin]] == 0
    }]
}

#------------------------------------------------------------------------------
# mwutil::genMouseWheelEvent
#
# Generates a mouse wheel event with the given root coordinates and delta on
# the widget w.
#------------------------------------------------------------------------------
proc mwutil::genMouseWheelEvent {w event rootX rootY delta} {
    set needsFocus [expr {[package vcompare $::tk_patchLevel "8.6b2"] < 0 &&
	[string compare $::tcl_platform(platform) "windows"] == 0}]

    if {$needsFocus} {
	set focusWin [focus -displayof $w]
	focus $w
    }

    event generate $w $event -rootx $rootX -rooty $rootY -delta $delta

    if {$needsFocus} {
	focus $focusWin
    }
}

#------------------------------------------------------------------------------
# mwutil::windowingSystem
#
# Returns the windowing system ("x11", "win32", "classic", or "aqua").
#------------------------------------------------------------------------------
proc mwutil::windowingSystem {} {
    if {[catch {tk windowingsystem} winSys] != 0} {
	switch $::tcl_platform(platform) {
	    unix	{ set winSys x11 }
	    windows	{ set winSys win32 }
	    macintosh	{ set winSys classic }
	}
    }

    return $winSys
}

#------------------------------------------------------------------------------
# mwutil::currentTheme
#
# Returns the current tile theme.
#------------------------------------------------------------------------------
proc mwutil::currentTheme {} {
    if {[info exists ::ttk::currentTheme]} {
	return $::ttk::currentTheme
    } elseif {[info exists ::tile::currentTheme]} {
	return $::tile::currentTheme
    } else {
	return ""
    }
}

#------------------------------------------------------------------------------
# mwutil::scalingPercentage
#
# Returns the display's current scaling percentage (100, 125, 150, 175, or 200).
#------------------------------------------------------------------------------
proc mwutil::scalingPercentage {} {
    set pct [expr {[tk scaling] * 75}]

    if {[string compare [windowingSystem] "x11"] == 0} {
	set factor 1
	if {[catch {exec ps -e | grep xfce}] == 0} {			;# Xfce
	    if {[catch {exec xfconf-query -c xsettings \
		 -p /Gdk/WindowScalingFactor} result] == 0} {
		set factor $result
		set pct [expr {100 * $factor}]
	    }
	} elseif {[catch {exec ps -e | grep mate}] == 0} {		;# MATE
	    if {[catch {exec gsettings get org.mate.interface \
		 window-scaling-factor} result] == 0} {
		if {$result == 0} {			;# means: "Auto-detect"
		    #
		    # Try to get the scaling factor from the cursor size
		    #
		    if {[catch {exec xrdb -query | grep Xcursor.size} \
			 result] == 0 &&
			[catch {exec gsettings get org.mate.peripherals-mouse \
			 cursor-size} defCursorSize] == 0} {
			scan $result "%*s %d" cursorSize
			set factor [expr {($cursorSize + $defCursorSize - 1) /
					  $defCursorSize}]
			set pct [expr {100 * $factor}]
		    }
		} else {
		    set factor $result
		    set pct [expr {100 * $factor}]
		}
	    }
	} elseif {[catch {exec gsettings get \
		   org.gnome.settings-daemon.plugins.xsettings overrides} \
		   result] == 0 &&
		  [set idx \
		   [string first "'Gdk/WindowScalingFactor'" $result]] >= 0} {
	    scan [string range $result $idx end] "%*s <%d>" factor
	    set pct [expr {100 * $factor}]
	} elseif {[catch {exec xrdb -query | grep Xft.dpi} result] == 0} {
	    scan $result "%*s %f" dpi
	    set pct [expr {100 * $dpi / 96}]
	} elseif {$::tk_version >= 8.3 &&
		  [catch {exec ps -e | grep gnome}] == 0 &&
		  ![info exists ::env(WAYLAND_DISPLAY)] &&
		  [catch {exec xrandr | grep " connected"} result] == 0 &&
		  [catch {open $::env(HOME)/.config/monitors.xml} chan] == 0} {
	    #
	    # Get the list of connected outputs reported by xrandr
	    #
	    set outputList {}
	    foreach line [split $result "\n"] {
		set idx [string first " " $line]
		set output [string range $line 0 [incr idx -1]]
		lappend outputList $output
	    }
	    set outputList [lsort $outputList]

	    #
	    # Get the content of the file ~/.config/monitors.xml
	    #
	    set str [read $chan]
	    close $chan

	    #
	    # Run over the file's "configuration" sections
	    #
	    set idx 0
	    while {[set idx2 [string first "<configuration>" $str $idx]] >= 0} {
		set idx2 [string first ">" $str $idx2]
		set idx [string first "</configuration>" $str $idx2]
		set config [string range $str [incr idx2] [incr idx -1]]

		#
		# Get the list of connectors within this configuration
		#
		set connectorList {}
		foreach {dummy connector} [regexp -all -inline \
			{<connector>([^<]+)</connector>} $config] {
		    lappend connectorList $connector
		}
		set connectorList [lsort $connectorList]

		#
		# If $outputList and $connectorList are identical then set the
		# variable pct to 100 or 200, depending on the max. scaling
		# within this configuration, and exit the loop.  (Due to the
		# way fractional scaling is implemented in GNOME, we have to
		# set the variable pct to 200 rather than 125, 150, or 175.)
		#
		if {[string compare $outputList $connectorList] == 0} {
		    set maxScaling 0.0
		    foreach {dummy scaling} [regexp -all -inline \
			    {<scale>([^<]+)</scale>} $config] {
			if {$scaling > $maxScaling} {
			    set maxScaling $scaling
			}
		    }
		    set pct [expr {$maxScaling > 1.0 ? 200 : 100}]
		    break
		}
	    }
	}

	#
	# Correct the sizes of the standard fonts by replacing the sizes
	# in pixels contained in the file $::tk_library/ttk/fonts.tcl
	# with sizes in points, and then multiply them with $factor
	#
	if {$::tk_version >= 8.5} {
	    if {$factor > 2} {
		set factor 2
	    }

	    set chan [open $::tk_library/ttk/fonts.tcl]
	    set str [read $chan]
	    close $chan

	    set idx [string first "courier" $str]
	    set str [string range $str $idx end]

	    set idx [string first "F(size)" $str]
	    scan [string range $str $idx end] "%*s %d" size
	    if {$size < 0} { set size 9 }	;# -12 -> 9, for compatibility
	    foreach font {TkDefaultFont TkTextFont TkHeadingFont
			  TkIconFont TkMenuFont} {
		font configure $font -size [expr {$factor * $size}]
	    }

	    set idx [string first "F(ttsize)" $str]
	    scan [string range $str $idx end] "%*s %d" size
	    if {$size < 0} { set size 8 }	;# -10 > 8, for compatibility
	    foreach font {TkTooltipFont TkSmallCaptionFont} {
		font configure $font -size [expr {$factor * $size}]
	    }

	    set idx [string first "F(capsize)" $str]
	    scan [string range $str $idx end] "%*s %d" size
	    if {$size < 0} { set size 11 }	;# -14 -> 11, for compatibility
	    font configure TkCaptionFont -size [expr {$factor * $size}]

	    set idx [string first "F(fixedsize)" $str]
	    scan [string range $str $idx end] "%*s %d" size
	    if {$size < 0} { set size 9 }	;# -12 -> 9, for compatibility
	    font configure TkFixedFont -size [expr {$factor * $size}]
	}
    }

    if {$pct < 100 + 12.5} {
	return 100
    } elseif {$pct < 125 + 12.5} {
	return 125 
    } elseif {$pct < 150 + 12.5} {
	return 150 
    } elseif {$pct < 175 + 12.5} {
	return 175 
    } else {
	return 200
    }
}
