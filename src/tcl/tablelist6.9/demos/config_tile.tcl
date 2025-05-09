#==============================================================================
# Demonstrates how to use a tablelist widget for displaying and editing the
# configuration options of an arbitrary widget.
#
# Copyright (c) 2000-2020  Csaba Nemethi (E-mail: csaba.nemethi@t-online.de)
#==============================================================================

package require tablelist_tile 6.9

namespace eval demo {
    #
    # Get the current windowing system ("x11", "win32", or "aqua")
    # and add some entries to the Tk option database for the following
    # widget hierarchy within a toplevel widget of the class DemoTop:
    #
    # Name		Class
    # -----------------------------
    # tf		TFrame
    #   tbl		  Tabellist
    #   vsb, hsb	  TScrollbar
    # bf		TFrame
    #   b1, b2, b3	  TButton
    #
    if {[tk windowingsystem] eq "x11"} {
	option add *DemoTop*Font			TkDefaultFont
    }
    tablelist::setThemeDefaults
    set foreground [winfo rgb . $tablelist::themeDefaults(-foreground)]
    set selectFg   [winfo rgb . $tablelist::themeDefaults(-selectforeground)]
    set selectFgEqForeground [expr {$selectFg eq $foreground}]
    variable currentTheme [tablelist::getCurrentTheme]
    if {$currentTheme ne "aqua"} {
	option add *DemoTop*selectBackground \
		   $tablelist::themeDefaults(-selectbackground)
	option add *DemoTop*selectForeground \
		   $tablelist::themeDefaults(-selectforeground)
	option add *DemoTop*selectBorderWidth \
		   $tablelist::themeDefaults(-selectborderwidth)
    }
    option add *DemoTop.tf.borderWidth			1
    option add *DemoTop.tf.relief			sunken
    option add *DemoTop.tf.tbl.borderWidth		0
    option add *DemoTop.tf.tbl.background		white
    option add *DemoTop.tf.tbl.stripeBackground		#f0f0f0
    option add *DemoTop.tf.tbl.setGrid			yes
    option add *DemoTop.tf.tbl*Entry.background		white
    option add *DemoTop.bf.TButton.width		10
}

#
# Work around the improper appearance of the tile scrollbars in the aqua theme
#
if {$demo::currentTheme eq "aqua" &&
    [package vcompare $::tk_patchLevel "8.6.10"] < 0} {
    interp alias {} ttk::scrollbar {} ::scrollbar
}

#------------------------------------------------------------------------------
# demo::displayConfig
#
# Displays the configuration options of the widget w in a tablelist widget
# contained in a newly created toplevel widget.  Returns the name of the
# tablelist widget.
#------------------------------------------------------------------------------
proc demo::displayConfig w {
    if {![winfo exists $w]} {
	bell
	tk_messageBox -title "Error" -icon error -message \
	    "Bad window path name \"$w\""
	return ""
    }

    #
    # Create a toplevel widget of the class DemoTop
    #
    set top .configTop
    for {set n 2} {[winfo exists $top]} {incr n} {
	set top .configTop$n
    }
    toplevel $top -class DemoTop
    wm title $top "Configuration Options of the [winfo class $w] Widget \"$w\""

    #
    # Create a scrolled tablelist widget with 5 dynamic-width
    # columns and interactive sort capability within the toplevel
    #
    set tf $top.tf
    ttk::frame $tf
    set tbl $tf.tbl
    set vsb $tf.vsb
    set hsb $tf.hsb
    tablelist::tablelist $tbl \
	-columns {0 "Command-Line Name"
		  0 "Database/Alias Name"
		  0 "Database Class"
		  0 "Default Value"
		  0 "Current Value"} \
	-labelcommand tablelist::sortByColumn -sortcommand demo::compareAsSet \
	-editendcommand demo::applyValue -height 15 -width 100 -stretch all \
	-xscrollcommand [list $hsb set] -yscrollcommand [list $vsb set]
    if {[$tbl cget -selectborderwidth] == 0} {
	$tbl configure -spacing 1
    }
    $tbl columnconfigure 3 -maxwidth 30
    $tbl columnconfigure 4 -maxwidth 30 -editable yes
    ttk::scrollbar $vsb -orient vertical   -command [list $tbl yview]
    ttk::scrollbar $hsb -orient horizontal -command [list $tbl xview]

    #
    # Create three buttons within a tile frame child of the toplevel widget
    #
    set bf $top.bf
    ttk::frame $bf
    set b1 $bf.b1
    set b2 $bf.b2
    set b3 $bf.b3
    ttk::button $b1 -text "Refresh"     -command [list demo::putConfig $w $tbl]
    ttk::button $b2 -text "Sort as Set" -command [list $tbl sort]
    ttk::button $b3 -text "Close"       -command [list destroy $top]

    #
    # Manage the widgets
    #
    grid $tbl -row 0 -rowspan 2 -column 0 -sticky news
    if {[tk windowingsystem] eq "win32"} {
	grid $vsb -row 0 -rowspan 2 -column 1 -sticky ns
    } else {
	grid [$tbl cornerpath] -row 0 -column 1 -sticky ew
	grid $vsb	       -row 1 -column 1 -sticky ns
    }
    grid $hsb -row 2 -column 0 -sticky ew
    grid rowconfigure    $tf 1 -weight 1
    grid columnconfigure $tf 0 -weight 1
    pack $b1 $b2 $b3 -side left -expand yes -pady 10
    pack $bf -side bottom -fill x
    pack $tf -side top -expand yes -fill both

    #
    # Populate the tablelist with the configuration options of the given widget
    #
    putConfig $w $tbl
    return $tbl
}

#------------------------------------------------------------------------------
# demo::putConfig
#
# Outputs the configuration options of the widget w into the tablelist widget
# tbl.
#------------------------------------------------------------------------------
proc demo::putConfig {w tbl} {
    if {![winfo exists $w]} {
	bell
	tk_messageBox -title "Error" -icon error -message \
	    "Bad window path name \"$w\"" -parent [winfo toplevel $tbl]
	return ""
    }

    #
    # Display the configuration options of w in the tablelist widget tbl
    #
    $tbl delete 0 end
    foreach configSet [$w configure] {
	#
	# Insert the list configSet into the tablelist widget
	#
	$tbl insert end $configSet

	if {[llength $configSet] == 2} {
	    $tbl rowconfigure end -foreground gray50 -selectforeground gray75
	    $tbl cellconfigure end -editable no
	} else {
	    #
	    # Change the colors of the first and last cell of the row
	    # if the current value is different from the default one
	    #
	    set default [lindex $configSet 3]
	    set current [lindex $configSet 4]
	    if {[string compare $default $current] != 0} {
		foreach col {0 4} {
		    $tbl cellconfigure end,$col -foreground red
		    if {$demo::selectFgEqForeground} {
			$tbl cellconfigure end,$col -selectforeground red
		    } else {
			$tbl cellconfigure end,$col -selectforeground yellow
		    }
		}
	    }
	}
    }

    $tbl sortbycolumn 0
    $tbl activate 0
    $tbl attrib widget $w
}

#------------------------------------------------------------------------------
# demo::compareAsSet
#
# Compares two items of a tablelist widget used to display the configuration
# options of an arbitrary widget.  The item in which the current value is
# different from the default one is considered to be less than the other; if
# both items fulfil this condition or its negation then string comparison is
# applied to the two option names.
#------------------------------------------------------------------------------
proc demo::compareAsSet {item1 item2} {
    foreach {opt1 dbName1 dbClass1 default1 current1} $item1 \
	    {opt2 dbName2 dbClass2 default2 current2} $item2 {
	set changed1 [expr {[string compare $default1 $current1] != 0}]
	set changed2 [expr {[string compare $default2 $current2] != 0}]
	if {$changed1 == $changed2} {
	    return [string compare $opt1 $opt2]
	} elseif {$changed1} {
	    return -1
	} else {
	    return 1
	}
    }
}

#------------------------------------------------------------------------------
# demo::applyValue
#
# Applies the new value of the configuraton option contained in the given row
# of the tablelist widget tbl to the widget whose options are displayed in it,
# and updates the colors of the first and last cell of the row.
#------------------------------------------------------------------------------
proc demo::applyValue {tbl row col text} {
    #
    # Try to apply the new value of the option contained in
    # the given row to the widget whose options are displayed
    # in the tablelist; reject the value if the attempt fails
    #
    set w [$tbl attrib widget]
    set opt [$tbl cellcget $row,0 -text]
    if {[catch {$w configure $opt $text} result] != 0} {
	bell
	tk_messageBox -title "Error" -icon error -message $result \
	    -parent [winfo toplevel $tbl]
	$tbl rejectinput
	return ""
    }

    #
    # Replace the new option value with its canonical form and
    # update the colors of the first and last cell of the row
    #
    set text [$w cget $opt]
    set default [$tbl cellcget $row,3 -text]
    if {[string compare $default $text] == 0} {
	foreach col {0 4} {
	    $tbl cellconfigure $row,$col \
		 -foreground "" -selectforeground ""
	}
    } else {
	foreach col {0 4} {
	    $tbl cellconfigure $row,$col -foreground red
	    if {$demo::selectFgEqForeground} {
		$tbl cellconfigure $row,$col -selectforeground red
	    } else {
		$tbl cellconfigure $row,$col -selectforeground yellow
	    }
	}
    }

    return $text
}

#------------------------------------------------------------------------------

if {$tcl_interactive} {
    return "\nTo display the configuration options of an arbitrary\
	    widget, enter\n\n\tdemo::displayConfig <widgetName>\n"
} else {
    wm withdraw .
    tk_messageBox -title $argv0 -icon warning -message \
	"Please source this script into\nan interactive wish session"
    exit 1
}
