namespace eval utdcache {

  proc delete_selected { w } {
    foreach id [ $w find withtag selected ] {
	    set boxid [ get_postfix_tag $w box $id ]
	    if {$boxid} {
		    delete_box $w $boxid
	    }
	    set nodeid [ get_postfix_tag $w node $id ]
	    if {$nodeid} {
		    delete_node $w $nodeid
	    }
    }
    clear_all_selection $w
    draw_selection $w
  }

  proc select_none { w } {
    clear_all_selection $w
    draw_selection $w
  }

  proc select_all { w } {
    foreach id [ $w find withtag boxlike ] {
      set objid [ get_postfix_tag $w obj $id ]
      if {$objid} {
	add_selection $w $objid
      }
    }
    draw_selection $w
  }

  proc select_only {w num} {
    clear_all_selection $w
    add_selection $w $num
    draw_selection $w
  }

  proc add_select {w num} {
    add_selection $w $num
    draw_selection $w
  }

  proc del_select {w num} {
    del_selection $w $num
    draw_selection $w
  }

  proc start_drag { w x y } {
    variable optionS
    set optionS(move,x) $x
    set optionS(move,y) $y 
  }

  proc move { w x y } {
    variable optionS
    set dx [ expr $x - $optionS(move,x) ]
    set dy [ expr $y - $optionS(move,y) ]
    $w move selected $dx $dy
    $w move highlight $dx $dy
    # adjusting the lines, which are connected to the moving objects
    start_drag $w $x $y
  }

  # Low level selection functions
  proc clear_all_selection { w } {
    foreach id [ $w find withtag selected ] {
	    set post [ get_postfix_tag $w s $id ]
	    if $post {
		    $w dtag   s_$post $id
		    $w addtag n_$post withtag $id
	    }
    }
    $w addtag notsel withtag selected
    $w dtag all selected 
  }

  proc add_selection { w id } {
    $w addtag s_$id    withtag n_$id
    $w addtag selected withtag n_$id
    $w dtag  s_$id notsel
    $w dtag  s_$id n_$id
  }

  proc del_selection { w id } {
    $w addtag notsel withtag s_$id
    $w addtag n_$id  withtag s_$id
    $w dtag   n_$id selected
    $w dtag   n_$id s_$id
  }

  proc draw_selection {w} {
    variable canobjS
    variable optionS

    set c [$canobjS subwidget canvas]
    set h $optionS(highlightsize)
    $w delete highlight
    set x1 0; set y1 0; set x3 0; set y3 0;
    foreach {x1 y1 x3 y3} [$c bbox selected] { }
    if ($x3) {
      incr x1 -$optionS(highlightsize)
      incr x3  $optionS(highlightsize)
      incr y1 -$optionS(highlightsize)
      incr y3  $optionS(highlightsize)
      set x2 [ expr ($x1+$x3)/2 ]
      set y2 [ expr ($y1+$y3)/2 ]
      foreach {x y} { $x1 $y1 $x2 $y1 $x3 $y1 $x3 $y2 \
	      $x3 $y3 $x2 $y3 $x1 $y3 $x1 $y2} {
	      $w create rectangle [expr $x-$h] [expr $y-$h] \
		[expr $x+$h] [expr $y+$h] -fill black -tag highlight
      }
    }
  }


  proc get_postfix_tag { w prefix id} {
    set nprefix 0
    foreach tag [ $w gettags $id ] {
	    if [regexp ^$prefix\_\(.*\) $tag whole tagnum] {
		    set nprefix $tagnum
		    break;
	    }
    }
    return $nprefix;
  }

  proc n_button1 { w x y num } {
    variable optionS
    switch $optionS(mode) {
      edit {
	select_only $w $num
	start_drag $w $x $y
      }
      normal {
	::utdcache::pick_inst $w $x $y
      }
    }
  }

  proc s_button1 { w x y num } { 
    variable optionS
    switch $optionS(mode) \
    edit {
      start_drag $w $x $y
    }
  }

  proc selected_b1_motion { w x y } {
    variable optionS
    switch $optionS(mode) \
    edit {
      move $w $x $y
    }
  }

}
