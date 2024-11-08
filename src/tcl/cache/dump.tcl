
namespace eval utdcache {
  proc dump_file { } {
    variable optionS
    variable canobjS

    set w [$canobjS subwidget canvas]
    if {$optionS(filename)==""} {
      set f [::icselect_file::display .icsave {Save Flow File} {Flow Filename:} \
	     save_file flow {Flow Files} -noblank]
      if {$f} {
	set filename [::icselect_file::selected_file save_file]
	if {$filename == ""} {
	  icalert_user errmsg save_file "no file specified.\n"
	  return ;
	}

	if {[file exists $filename]} {
	  set reply [tk_messageBox -icon warning -type yesno\
	      -parent $w -message \
		"[::tk::mc "File \"%1\$s\" already exists.\nDo you want to overwrite it?" $filename]"]
	  if {[string equal $reply "no"]} {
	    return
	  }
	}
	set optionS(filename) $filename
      } else {
	return ;
      }
    }

    set width [$w configure -width]
    set optionS(xsize) [lindex $width 4]
    set height [$w configure -height]
    set optionS(ysize) [lindex $height 4]

    # First find id and make them unique.
    foreach box [ $w find withtag rect ] {
      set id [ get_postfix_tag $w obj $box ]
      set ids($id) $id
    }
    if {!([info exists ids])} {
      icalert_user errmsg save_file "No data to save.\n"
      return ;
    }
    set of [ open $optionS(filename) "w" ]

    # Now put the ids in order.
    set id_list [array names ids]
    set id_list [lsort -integer -increasing $id_list]

    # Need flow type here --- 
    set numobjects [llength $id_list]
    puts $of "numobjects $numobjects"

    calc_drawing_bounds $id_list xmin ymin xmax ymax 
    set xoffset [expr {$xmin - $optionS(idx_text_offset)}]
    set yoffset [expr {- $ymin}] 
    set height $optionS(ysize)

    foreach id $id_list {
      puts -nonewline $of "id $id :"
      set rect_id [$w find withtag rect_$id]
      if {[llength $rect_id] == 1} {
	set bbox [$w bbox $rect_id]
	set x1 [lindex $bbox 0]
	set y1 [lindex $bbox 1]
	set x2 [lindex $bbox 2]
	set y2 [lindex $bbox 3]
	# set x1 [expr {int($x1 - $xoffset)}] 
	# set y1 [expr {int($height - ($y1 + $yoffset))}] 
	# set x2 [expr {int($x2 - $xoffset)}] 
	# set y2 [expr {int($height - ($y2 + $yoffset))}] 
	puts -nonewline $of " drawn : $x1 $y1 $x2 $y2"
	puts -nonewline $of " coords : [$w coords $id]"
	puts $of " tags : [$w gettags $id]"
      }
    }
    close $of
  }

  proc calc_drawing_bounds { id_list xmin ymin xmax ymax } {
    variable canobjS

    upvar $xmin minx
    upvar $ymin miny
    upvar $xmax maxx
    upvar $ymax maxy

    set first_object true
    set w [$canobjS subwidget canvas]
    foreach id $id_list {
      set rect_id [$w find withtag rect_$id]
      if {[llength $rect_id] == 1} {
	set draw [$w bbox $rect_id]
	calc_bbox $draw first_object minx miny maxx maxy
      }
    }
  }

  proc calc_bbox { dobj first xmin ymin xmax ymax } {
    if {$dobj == ""} {
      return ;
    }
    upvar $xmin minx
    upvar $ymin miny
    upvar $xmax maxx
    upvar $ymax maxy
    upvar $first first_object

    set x1 [lindex $dobj 0]
    set y1 [lindex $dobj 1]
    set x2 [lindex $dobj 2]
    set y2 [lindex $dobj 3]
    if {$first_object} {
      set minx $x1
      set miny $y1
      set maxx $x2
      set maxy $y2
      set first_object false
    } else {
      if {$x1 < $minx} {
	set minx $x1
      }
      if {$y1 < $miny} {
	set miny $y1
      }
      if {$x2 > $maxx} {
	set maxx $x2
      }
      if {$y2 > $maxy} {
	set maxy $y2
      }
    }
  }

  proc scale_objs { amt } {
    variable canobjS
    variable libpathS

    set w [$canobjS subwidget canvas]
    set allids [$w find all]
    foreach id $allids {
      set type [$w type $id]
      if {$type == "image"} {
	set fname [get_postfix_tag $w name $id]
	if {$fname != ""} {
	  set ifilename [file join $libpathS $fname]
	  set figscale [get_postfix_tag $w figscale $id]
	  if {$figscale != ""} {
	    set nscale [expr $figscale * $amt]
	    set boximg [image create photo]
	    $boximg read $ifilename -format gif
	    set new_data [$boximg scale [$boximg data] -scale $nscale]
	    set nboximg [image create photo]
	    $nboximg put $new_data
	    image delete $boximg
	    set oldimage [$w itemconfigure $id -image]
	    set oldimage [lindex $oldimage 4]
	    $w itemconfigure $id -image $nboximg
	    $w dtag $id figscale_${figscale}
	    $w addtag figscale_${nscale} withtag ${id}
	    if {$oldimage != ""} {
	      image delete $oldimage
	    }
	  }
	}
      }
    }
    $w scale all 0 0 $amt $amt
    $canobjS adjustscrollregion

  }

  proc zoom_out { } {
    scale_objs 0.7
    update
    resize
  }

  proc zoom_in { } {
    catch {scale_objs 1.4}
    update
    resize
  }
}
