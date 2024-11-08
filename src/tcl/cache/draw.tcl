#!/usr/local/bin/wish -f
#

namespace eval utdcache {


  proc splash { correct_flag } {
    variable libpathS

    if {[winfo exists .splash]} {
      wm withdraw .splash
      wm deiconify .splash
      return ;
    }
    # wm withdraw .
    #
    wm deiconify .
    toplevel .splash -bd 3 -relief raised
    set sw [winfo screenwidth .]
    set sh [winfo screenheight .]
    set libpath ./
    if {$correct_flag} {
      image create photo splash \
	      -file [ file join $libpathS good.gif ]
    } else {
      image create photo splash \
	      -file [ file join $libpathS incorrect.gif ]
    }
    label .splash.im -image splash -bd 1 -relief sunken
    set ih [image height splash]
    set iw [image width splash]
    set x [expr {($sw - $iw) /2}]
    set y [expr {($sh - $ih) /2}]
    wm geometry .splash +$x+$y
    if {$correct_flag} {
      wm title .splash "Congratulations!  Good work!"
    } else {
      wm title .splash "Sorry, try again!"
    }
    # Can't use overrideredict because of a bug with raise.
    # wm overrideredirect .splash 1
    pack  .splash.im -side top -expand true -fill both
    raise .splash .
    wm withdraw .
    update idletasks
    after 2000 { catch { destroy .splash } }
  }

  proc update_processor_state { } {
    variable canobjS
    variable dwayS
    variable iwayS
    variable optionS

    if {($optionS(test) == "")} {
      update_message "Updating graphics... Please wait..."
      update
      after 100
      update
      set c [$canobjS subwidget canvas]

      $c bind selected <B1-Motion> "::utdcache::selected_b1_motion %W %x %y"

      set winheight [winfo height $c]
      set winheight 0
      # puts stderr "c:$c"
      add_fig_to_canvas 86.0625 49.815 0.14175 $winheight 1 processor.gif true ""
      set idx 1
      for {set i 1} {$i <= $iwayS} {incr i} {
	set x [expr {16.2 - 180 * ($i-1)}]
	incr idx
	add_fig_to_canvas $x 133.245 0.0354375 $winheight $idx down.gif true ""
	update_message "updating."
	update
	incr idx
	add_fig_to_canvas $x 225.18 0.0354375 $winheight $idx down.gif true ""
	update_message "updating.."
	update
	incr idx
	set wnum [expr $i - 1]
	add_fig_to_canvas $x 179.415 0.070875 $winheight $idx cache.gif true icache_${wnum}
	incr idx
	update_message "updating..."
	update
      }
      for {set i 1} {$i <= $dwayS} {incr i} {
	set x [expr {141.75 + 180 * ($i-1)}]
	incr idx
	add_fig_to_canvas $x 133.245 0.0354375 $winheight $idx downA.gif true ""
	update_message "updating."
	update
	incr idx
	add_fig_to_canvas $x 225.18 0.0354375 $winheight $idx downA.gif true ""
	update_message "updating.."
	update
	incr idx
	set wnum [expr $i - 1]
	add_fig_to_canvas $x 179.415 0.070875 $winheight $idx cache.gif true dcache_${wnum}
	update_message "updating..."
	update
	incr idx
      }
      update_message "update completed."
      update
      after 500 {::utdcache::update_message "Question: Click the New Question button to start the program asking questions!"}

      $canobjS adjustscrollregion
    }
  }

  proc resize { } {
    variable canobjS
    $canobjS adjustscrollregion
  }

  proc config_ways {num_ways} {
    clear_canvas
    after 10 {update}
    after 20 {::utdcache::update_processor_state}
  }

  proc clear_canvas { } {
    # Clear the canvas of data.
    variable canobjS
    set c [$canobjS subwidget canvas]
    set items [$c find all]
    eval $c delete $items
  }

  proc add_fig_to_canvas {x y scale winheight num fig add_bindings cname} {
    # Adds a new picture to the canvas
    variable canobjS
    variable optionS
    variable libpathS
    set c [$canobjS subwidget canvas]
    set x1 $x
    set y1 $y
    set boximg [image create photo]
    set bfilename [file join $libpathS $fig]
    $boximg read $bfilename -format gif
    set iwidth [image width $boximg]
    set iheight [image height $boximg]
    set hw [expr {int($iwidth / 2)}]
    set hh [expr {int($iheight / 2)}]
    set x2 [expr {$x1 + $iwidth}]
    set y2 [expr {$y1 + $iheight}]
    if {$scale < 1.0} {
      set swidth [expr {$scale * $iwidth}]
      set sheight [expr {$scale * $iheight}]
      set x2 [expr {$x1 + $swidth}]
      set y2 [expr {$y1 + $sheight}]
      set hw [expr {$scale * $hw}]
      set hh [expr {$scale * $hh}]
      set new_data [$boximg scale [$boximg data] -scale $scale]
      image delete $boximg
      set boximg [image create photo]
      $boximg put $new_data
      set idx_text_offset [expr {$scale * $optionS(idx_text_offset)}]
    } else {
      set idx_text_offset $optionS(idx_text_offset)
    }
    if {$winheight > 0} {
      set ycanvas [expr {$winheight - $y}]
      set ynum [expr {$winheight - ($y1 - $idx_text_offset + $hh)}]
    } else {
      set ycanvas $y2
      set ynum [expr {($y1 + $idx_text_offset + $hh)}]
    }
    set name "name_${fig}"
    set scale_tag "figscale_${scale}"
    # puts stderr "cmd: $c create image $x $y -image $boximg -tags \
	    [list box_$num n_$num rect_$num obj_$num notsel boxlike rect $name $scale_tag]"
    $c create image $x $y -image $boximg -tags \
	    [list box_$num n_$num rect_$num obj_$num notsel boxlike rect $name $scale_tag]

    if {$add_bindings} {
#      $c bind box_$num <Button-1> "::icflow::box_button1 %W %x %y $num"
#      $c bind box_$num <Button-3> "::icflow::box_button3 %W %x %y $num %X %Y"
#      $c bind box_$num <Enter> "::icflow::box_enter %W %x %y $num"
#      $c bind box_$num <Leave> "::icflow::box_leave %W %x %y $num"
#      $c bind box_$num <Control-Button-1> "::icflow::box_ctrl_button1 %W %x %y $num"
#      $c bind box_$num <Double-Button-1> "::icflow::box_double_button1 %W %x %y $num"
       boxlike_bindings $c $num
    }
    if {$cname != ""} {
      incr num
      set wayname [get_way_name $cname]
      set way_tag [get_way_tag $cname]
      $c create text $x $y -text $wayname -fill red -font {Courier -28 bold} -tags [list n_$num obj_$num notsel $cname $scale_tag $way_tag]
      boxlike_bindings $c $num
    }
  }

  proc get_way_num {cache_name type} {
    upvar $type fchar
    set fchar [string index $cache_name 0]
    set underidx [string last _ $cache_name]
    incr underidx
    set num [string range $cache_name $underidx end]
    return $num
  }

  proc get_way_name {cache_name} {
    set num [get_way_num $cache_name type]
    if {$type == "d"} {
      set name "D Way $num" 
    } else {
      set name "I Way $num" 
    }
    return $name
  }

  proc get_way_tag {cache_name} {
    set num [get_way_num $cache_name type]
    if {$type == "d"} {
      set name "name_d_${num}" 
    } else {
      set name "name_i_${num}" 
    }
    return $name
  }


  proc calc_font_half_height {fname} {
    set fm [font metrics $fname]
    set theight 0
    foreach {opt val} $fm {
      if {$opt == "-ascent"} {
	set theight [expr {$theight + $val}]
      } elseif {$opt == "-descent"} {
	set theight [expr {$theight + $val}]
      }
    }
    return [expr {int($theight / 2)}]
  }

  proc boxlike_bindings {w num} {
    $w bind n_$num <Button-1> "::utdcache::n_button1 %W %x %y $num"
    $w bind s_$num <Button-1> "::utdcache::s_button1 %W %x %y $num"
    # $w bind n_$num <Shift-Button-1> "::icflow::n_shift_button1 %W %x %y $num"
    # $w bind s_$num <Shift-Button-1> "::icflow::s_shift_button1 %W %x %y $num"
  }


  proc pick_inst {w x y} {
    set xc [$w canvasx $x]
    set yc [$w canvasy $y]
    # puts stderr "w:$w x:$x y:$y xc:$xc yc:$yc"
    set closestid [$w find closest $xc $yc]
    if {$closestid != ""} {
      # puts stderr "closest: $closestid tags:[$w gettags $closestid]"
      set name [ get_postfix_tag $w name $closestid ]
      set prefix [string range $name 0 1]
      if {$name == "processor.gif"} {
	display_regfile
      } elseif {$prefix == "d_"} {
	set way [get_way_num $name type]
	display_way $way $type
      } elseif {$prefix == "i_"} {
	set way [get_way_num $name type]
	display_way $way $type
      }
    }
  }


}
