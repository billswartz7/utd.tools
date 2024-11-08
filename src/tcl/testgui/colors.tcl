#!/usr/local/bin/wish -f
# Program: colors
# Tcl version: 7.5 (Tcl/Tk/XF)
# Tk version: 4.1
# XF version: 4.0
# $Log$
#
#

namespace eval utdgui {

  variable colorS ;

  proc color_display {args} {

    # see if we are already open for business.
    if {[winfo exists .utdcolors]} {
      wm withdraw .utdcolors
      wm deiconify .utdcolors
      return ;
    }
    init

    # build widget .utdcolors
    toplevel .utdcolors

    # Window manager configurations
    wm positionfrom .utdcolors ""
    wm sizefrom .utdcolors ""
    wm maxsize .utdcolors 800 800
    wm minsize .utdcolors 10 10
    wm title .utdcolors {Display Colors}

    # build widget .utdcolors.frame0
    frame .utdcolors.frame0 \
      -borderwidth {2} \
      -relief {raised}
      
    # build widget .utdcolors.frame3
    frame .utdcolors.frame3 \
      -borderwidth {2} \
      -height {30} \
      -relief {raised} \
      -width {30}

    # build widget .utdcolors.frame3.label1
    label .utdcolors.frame3.label1 \
      -text {Colors}

    
    # build widget .utdcolors.frame1.button3
    button .utdcolors.frame0.button0 \
      -activebackground {White} \
      -activeforeground {Green} \
      -background {Green} \
      -foreground {White} \
      -padx {9} \
      -pady {3} \
      -command {destroy .utdcolors} \
      -text {ACCEPT}

    # build widget .utdcolors.frame1.button3
    button .utdcolors.frame0.button1 \
      -activebackground {White} \
      -activeforeground {Red} \
      -background {Red} \
      -foreground {White} \
      -padx {9} \
      -pady {3} \
      -command {destroy .utdcolors; ::utdgui::restore} \
      -text {CANCEL}

    # pack master .utdcolors.frame0
    pack configure .utdcolors.frame0.button0 \
      -padx 40 \
      -side left
    pack configure .utdcolors.frame0.button1 \
      -padx 40 \
      -side right

    # build widget .utdcolors.frame1
    frame .utdcolors.frame1 \
      -borderwidth {2} \
      -relief {raised}

    tixScrolledWindow .utdcolors.frame1.scroll_window
    pack .utdcolors.frame1.scroll_window -expand yes -fill both \
      -padx 10 -pady 10 -side left
    set a [.utdcolors.frame1.scroll_window subwidget window]

    #these guys now grid themselves in frame1
    utdcolors_build_ids $a 0
    utdcolors_build_names $a 1
    utdcolors_build_stipple $a 2
    utdcolors_build_display $a 3

    # build widget .utdcolors.frame0
    frame .utdcolors.frame2 \
      -borderwidth {2} \
      -relief {raised}

    set greset [frame .utdcolors.frame2.global_resetf -borderwidth {2} -relief ridge]
    label $greset.info -borderwidth {0} -pady {0} -text {Global Colors Reset}
    button $greset.reset_on -borderwidth {1} -pady {0} -text {all colors on} \
	-command "::utdgui::global_reset $a true ;utdredraw"
    button $greset.reset_off -borderwidth {1} -pady {0} -text {all colors off} \
	-command "::utdgui::global_reset $a false ; utdredraw"
    pack configure $greset.info -side left -fill x -expand true -padx 10
    pack configure $greset.reset_off -side right
    pack configure $greset.reset_on -side right
    pack configure $greset -fill x -expand true -pady {0} -side left -anchor c
    
    pack configure .utdcolors.frame3.label1
    
    # pack master .utdcolors
    pack configure .utdcolors.frame3 \
      -fill x \
      -expand false
      
    pack configure .utdcolors.frame0 \
      -fill x
   
    pack configure .utdcolors.frame2

    pack configure .utdcolors.frame1 \
      -fill x \
      -expand yes

  }

  proc init {} {
    variable colorS

    set num_colors [utdcolors number]
    # build the number widgets.
    for {set i 1} {$i <= $num_colors} {incr i 1} {
      set colorS($i) [utdcolors state $i]
      set colorS(save,$i) $colorS($i)
    }
  }

  proc utdcolors_build_ids {w col} {
    # build widget $w.ids
    label $w.idlabel \
      -relief {groove} \
      -text {Index}

    grid $w.idlabel -column $col -row 0

    set num_colors [utdcolors number]

    for {set i 1} {$i <= $num_colors} {incr i 1} {
      label $w.id$i \
	 -relief {flat} \
	 -text "$i" \
	 -fg black

      grid $w.id$i -row $i -column $col
    }

  }

  proc utdcolors_build_names {w col} {
    # build widget $w.name
    label $w.namelabel \
      -relief {groove} \
      -text {Name}

    grid $w.namelabel -column $col -row 0

    set num_colors [utdcolors number]

    for {set i 1} {$i <= $num_colors} {incr i 1} {
      label $w.name$i \
	 -relief {flat} \
	 -text "[utdcolors name $i]" \
	 -fg [utdcolors name $i]

      grid $w.name$i -row $i -column $col
    }

  }

  proc utdcolors_build_stipple {w col} {
    # build widget $w.name
    label $w.stipplelabel \
      -relief {groove} \
      -text {Stipple}

    grid $w.stipplelabel -column $col -row 0

    set num_colors [utdcolors number]

    for {set i 1} {$i <= $num_colors} {incr i 1} {
      set stip [utdcolors stipple $i]
      if {($stip != "") && ($stip != "none")} {
	if {[catch {label $w.stipple$i -relief {groove} -bitmap $stip \
		    -fg [utdcolors name $i]} msg]} {
	  utdmessage warnmsg utdcolors_build_stipple "$msg for color index:$i\n"
	  label $w.stipple$i \
	     -relief {flat} \
	     -text "none" \
	     -fg [utdcolors name $i]
	}
      } else {
	label $w.stipple$i \
	   -relief {flat} \
	   -text "none" \
	   -fg [utdcolors name $i]
      }

      grid $w.stipple$i -row $i -column $col -padx 30
    }

  }


  proc utdcolors_build_display {w col} {
    variable colorS

    # build widget $w.display
    label $w.display \
      -relief {groove} \
      -text {Display}

    #pack configure $w.display
    grid $w.display -row 0 -column $col

    set num_colors [utdcolors number]

    # build the number widgets.
    for {set i 1} {$i <= $num_colors} {incr i 1} {
      frame $w.display$i \
	  -height {28} \
	  -width {30} \
	  -borderwidth {3} \
	  -relief flat
      radiobutton $w.display$i.radio_on \
	  -borderwidth {1} \
	  -pady {0} \
	  -text {on} \
	  -value {1} \
	  -variable ::utdgui::colorS($i) \
	  -command "utdcolors draw $i ; utdredraw"
      radiobutton $w.display$i.radio_off \
	  -borderwidth {1} \
	  -pady {0} \
	  -text {off} \
	  -value {0} \
	  -variable ::utdgui::colorS($i) \
	  -command "utdcolors ignore $i ; utdredraw"
      
      grid $w.display$i.radio_on $w.display$i.radio_off  
      grid $w.display$i -row $i -column $col
   
    }

  }

  proc restore {} {
    variable colorS

    set num_colors [utdcolors number]
    # build the number widgets.
    for {set i 1} {$i <= $num_colors} {incr i 1} {
      if {$colorS(save,$i)} {
	utdcolors draw $i
      } else {
	utdcolors ignore $i
      }
    }
    utdredraw
  }

  proc global_reset {w flag} {
    set num_colors [utdcolors number]
    if {$flag} {
      for {set i 1} {$i <= $num_colors} {incr i 1} {
	utdcolors draw $i
	$w.display$i.radio_on select
      }
    } else {
      for {set i 1} {$i <= $num_colors} {incr i 1} {
	utdcolors ignore $i
	$w.display$i.radio_off select
      }
    }
  }

  if {[llength [info commands lassign]] == 0} {
    proc lassign {l args} {uplevel [list foreach $args $l break]}
  }

  # rgb to hsv (swiped from the tk demos)
    # The procedure below converts an RGB value to HSB.  It takes red, green,
    # and blue components (0-65535) as arguments, and returns a list containing
    # HSB components (floating-point, 0-1) as result.  The code here is a copy
    # of the code on page 615 of "Fundamentals of Interactive Computer Graphics"
    # by Foley and Van Dam.
    proc rgbToHsv {red green blue} {
        if {$red > $green} {
            set max [expr {double($red)}]
            set min [expr {double($green)}]
        } else {
            set max [expr {double($green)}]
            set min [expr {double($red)}]
        }
        if {$blue > $max} {
            set max [expr {double($blue)}]
        } elseif {$blue < $min} {
            set min [expr {double($blue)}]
        }
        set range [expr {$max-$min}]
        if {$max == 0} {
            set sat 0
        } else {
            set sat [expr {($max-$min)/$max}]
        }
        if {$sat == 0} {
            set hue 0
        } else {
            set rc [expr {($max - $red)/$range}]
            set gc [expr {($max - $green)/$range}]
            set bc [expr {($max - $blue)/$range}]
            if {$red == $max} {
                set hue [expr {($bc - $gc)/6.0}]
            } elseif {$green == $max} {
                set hue [expr {(2 + $rc - $bc)/6.0}]
            } else {
                set hue [expr {(4 + $gc - $rc)/6.0}]
            }
            if {$hue < 0.0} {
                set hue [expr {$hue + 1.0}]
            }
        }
        return [list $hue $sat [expr {$max/65535}]]
        }

 # hsv to rgb (swiped from the tk demos)
    # The procedure below converts an HSB value to RGB.  It takes hue, saturation,
    # and value components (floating-point, 0-1.0) as arguments, and returns a
    # list containing RGB components (integers, 0-65535) as result.  The code
    # here is a copy of the code on page 616 of "Fundamentals of Interactive
    # Computer Graphics" by Foley and Van Dam.

    proc hsvToRgb {hue sat value} {
        set v [format %.0f [expr {65535.0*$value}]]
        if {$sat == 0} {
            return "$v $v $v"
        } else {
            set hue [expr {$hue*6.0}]
            if {$hue >= 6.0} {
                set hue 0.0
            }
            scan $hue. %d i
            set f [expr {$hue-$i}]
            set p [format %.0f [expr {65535.0*$value*(1 - $sat)}]]
            set q [format %.0f [expr {65535.0*$value*(1 - ($sat*$f))}]]
            set t [format %.0f [expr {65535.0*$value*(1 - ($sat*(1 - $f)))}]]
            switch $i {
                0 {return "$v $t $p"}
                1 {return "$q $v $p"}
                2 {return "$p $v $t"}
                3 {return "$p $q $v"}
                4 {return "$t $p $v"}
                5 {return "$v $p $q"}
                default {error "i value $i is out of range"}
            }
        }
    }

    proc color_gradients {num r g b {limit -1}} {
      lassign [rgbToHsv $r $g $b] h s v
      set added_colors ""
      for {set n 1} {$n <= $num} {incr n} {
	set color_index [utdcolors add #[format %02x%02x%02x $r $g $b]]
	lappend added_colors $color_index
	# The next color in a harmonic color wheel is derived by linearly incrementing the hue
	set h1 [expr $h + (($n + 1.0) / $num)]
	# icmessage "hue:$h1 h:$h n:$n num:$num\n"
	if {($limit >= 0.0) && ($h1 > $limit)} {
	  break ;
	}
	if {$h1 > 1} {
	  set h1 [expr $h1 - 1.0]
	} 
	lassign [hsvToRgb $h1 $s $v] r g b
      }
      return $added_colors
    }

}
