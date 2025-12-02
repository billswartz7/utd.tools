
namespace eval twez {
  variable linkS
  variable dump_fpS
  variable in_dirS
  variable out_dirS
  variable cstateS
  variable figureS
  variable figure_cntS
  variable extra_fileS
  variable recurseS 0
  variable figure_availableS
  variable extra_text_fileS {icdaemon.txt example.host}
  variable alldocS {welcome start lessons problems solutions resources custom}

  proc dump {file out_file text_flag} {
    variable dump_fpS
    variable figure_cntS

    rename ::twez::ezeval_tk ::twez::ezeval_tk_native
    rename ::twez::eval_tk_dump ::twez::ezeval_tk
    if {($out_file == "stderr") || ($out_file == "stdout")} {
      set dump_fpS $out_file
    } else {
      set dump_fpS [open $out_file "w"]
    }

    if {$text_flag} {
      # Not html.
      puts $dump_fpS "<HTML>"
      puts $dump_fpS "<HEAD>"
      puts $dump_fpS "<TITLE> [file tail $out_file] </TITLE>"
      puts $dump_fpS "</HEAD> <BODY> <PRE>"
    }

    twparse_html $file . ::twez::dump_fragment

    if {$text_flag} {
      # Not html - so add ending.
      puts $dump_fpS "</PRE>"
      puts $dump_fpS "</BODY>"
      puts $dump_fpS "</HTML>"
    }

    if {($out_file != "stderr") && ($out_file != "stdout")} {
      close $dump_fpS
    }
    rename ::twez::ezeval_tk ::twez::eval_tk_dump 
    rename ::twez::ezeval_tk_native ::twez::ezeval_tk 
  }

  proc dump_fragment {win tag_orig not param text} {
    variable dump_fpS
    variable in_dirS
    variable out_dirS
    variable figureS
    variable recurseS
    variable extra_fileS
    variable extra_text_fileS
    variable figure_availableS
    # render gets called for every html tag
    #   win:   The name of the text widget to render into
    #   tag:   The html tag (in arbitrary case)
    #   not:   a "/" or the empty string
    #   param: The un-interpreted parameter list
    #   text:  The plain text until the next html tag

    # puts stderr "render: \{$win\} \{$tag_orig\} \{$not\} \{$param\} \{$text\}"
    if {$tag_orig == "hmstart"} {
      return ; 		/* dummy tag */
    }
    if {[string equal -nocase $tag_orig SCRIPT]} {
      # puts stderr "render: \{$win\} \{$tag_orig\} \{$not\} \{$param\} \{$text\}"
      if {$not == ""} {
	set figure_availableS 0
	tag_script . $param $text
	if {$figure_availableS} {
	  # Try putting below so we get alignment right.
	#  puts $dump_fpS "<IMG SRC=${figureS} ALIGN=\"BOTTOM\">"
	}
      } else {
	if {$text != ""} {
	  puts -nonewline $dump_fpS "$text"
	}
      }
      return ;
    } elseif {[string equal -nocase $tag_orig IMG]} {
      if {[catch {extract_param $param src} result_msg]} {
	puts stderr "Problem:$result_msg"
      } else {
	# puts stderr "create a link here SRC: $src"
	set base_src [file tail $src]
	set link_src [file join $out_dirS $src]
	set link_target [file join $in_dirS $src]
	if {!([file exists $link_src])} {
	  if {[catch {file link -symbolic $link_src $link_target} result_msg]} {
	    puts stderr "Problem:$result_msg"
	  }
	}
      }
      # puts stderr "render: \{$win\} \{$tag_orig\} \{$not\} \{$param\} \{$text\}"
    } elseif {[string equal -nocase $tag_orig A]} {
      if {[extract_param $param href]} {
	set fext [file extension $href]
	if {$fext == {.tcl}} {
	  lappend extra_fileS $href
	} elseif {$recurseS} {
	  if {$fext != ""} {
	    lappend extra_fileS $href
	  }
	}
	set basename [file tail $href]
	set idx [lsearch -exact $extra_text_fileS $basename]
	if {$idx >= 0} {
	  # puts stderr "adding $href to extra list"
	  lappend extra_fileS $href
	}
      }
    }
    if {$not != ""} {
      set tag "$not$tag_orig"
    } else {
      set tag "$tag_orig"
    }
    if {$param != ""} {
      puts -nonewline $dump_fpS "<$tag $param>$text"
    } else {
      puts -nonewline $dump_fpS "<$tag>$text"
    }
  }


  proc eval_tk_dump {win param} {
      global ICvarsG

      # get alignment
      set align bottom
      extract_param $param align
      catch {set align [string toupper $align]}


      # get alternate text to through it away.
      set alt "<image>"
      extract_param $param alt


      # need to get procedure
      set num [extract_param $param procedure]
      if {$num < 1} {
	 return ;
      }

      # now get any arguments
      set argc [extract_param $param args]

      # get the border width
      set border 0
      extract_param $param border

      # the default padding
      set padx 20
      set pady  2
      extract_param $param padx
      extract_param $param pady

      set w .twdumphtml
      if {[winfo exists $w]} {
	destroy $w
      }
      toplevel $w
      if {$ICvarsG(geom_x) < 0} {
	set geom_string "${ICvarsG(geom_x)}"
      } else {
	set geom_string "+${ICvarsG(geom_x)}"
      }
      if {$ICvarsG(geom_y) < 0} {
	append geom_string "${ICvarsG(geom_y)}"
      } else {
	append geom_string "+${ICvarsG(geom_y)}"
      }
      # puts stderr "geom: wm geometry $w $geom_string"
      wm geometry $w $geom_string
      wm overrideredirect $w 1
      set item $w.frame

      # see if we have an image size hint
      # If so, make a frame the "hint" size to put the label in
      # otherwise just make the label
      if {[extract_param $param width] && [extract_param $param height]} {
	  frame $item -width $width -height $height -bd $border
	  pack propagate $item 0
      } else {
	  frame $item -bd $border
      }

      if {$argc > 0} {
	set args [map_esc $args]
 	if {[catch {$procedure $item $args} result_msg]} {
 	  puts stderr "ERROR\[$procedure]:$result_msg args:$args"
 	}
      } else {
 	if {[catch {$procedure $item} result_msg]} {
 	  puts stderr "ERROR\[$procedure]:$result_msg"
	}
      }

      pack $item -side top -expand true -fill both
      update
      tkwait mapped $w
      update

      incr ::twez::figure_cntS
      set gname "fig${::twez::figure_cntS}.gif"
      set pictname [file join ${::twez::out_dirS} $gname]
#      puts stderr "::twcapture::capture $w $pictname"
      set tries 2
      if {[catch {set img [::twcapture::window $w $tries problem_flag]} result_msg]} {
	puts stderr "ERROR1:$result_msg"
      }
      if {$problem_flag} {
	twmessage errmsg eval_tk_dump "while processing $param\n"
      }
      set img_width [image width $img]
      if {$img_width > 650} {
	# puts stderr "image greater than 650: $pictname"
	ez_message imsg "Large image $pictname.  Shrinking image..."
	update idletasks
	set scale_data [expr {649.0 / $img_width}]
	set new_data [$img scale [$img data] -scale $scale_data]
	image delete $img
	set new_img [image create photo]
	$new_img put $new_data
	::twez::output_image $new_img $pictname
	image delete $new_img
	ez_message imsg "Done shrink..."
	update idletasks
      } else {
	::twez::output_image $img $pictname
	image delete $img
      }
      set ::twez::figure_availableS true
      set ::twez::figureS $gname
      puts ${::twez::dump_fpS} "<IMG SRC=${gname} ALIGN=\"${align}\">"
      # If any text links need to created add them.
      if {[info exists ::twez::linkS]} {
	puts ${::twez::dump_fpS} ${::twez::linkS}
	unset ::twez::linkS
      }

      destroy $w
      update

#       $win window create $var(S_insert) -align $align -window $item \
#	-padx $padx -pady $pady 

       return $item	;# used by the forms package for input_image types
  }

  # Output a proper GIF image reducing colors if necessary.
  proc output_image {img pictname} {
    if {[catch {$img write -format gif $pictname} result_msg]} {
      if {$result_msg == "too many colors"} {
	set new_data [$img reduce [$img data]]
	image delete $img
	set newimg [image create photo]
	$newimg put $new_data

	# Create destination image
	if {[catch {$newimg write -format gif $pictname} result_msg]} {
	  twalert_user -msg_func "" errmsg dump_doc "Problem:$result_msg"
	}
	image delete $newimg
      }
    }
  }

  proc create_href {linkname href} {
    set ::twez::linkS "<A HREF=$href>$linkname</A>"
  }

  proc dump_chapter { chapter } {
    upvar #0 ICvarsG tw
    variable in_dirS
    variable out_dirS
    variable figure_cntS
    variable extra_fileS

    set icdir $tw(E_icdir)
    set tw(chapter) $chapter

    set user_itools [file nativename ~/.itools]
    if {[file isdirectory $user_itools] == 0} {
      file mkdir $user_itools
    }
    set dumpdir [file join $user_itools htmldump]
    if {[file isdirectory $dumpdir] == 0} {
      file mkdir $dumpdir
    }
    set out_dirS [file join $dumpdir $chapter]
    if {[file isdirectory $out_dirS] == 0} {
      file mkdir $out_dirS
    }
    set extra_fileS ""
    set figure_cntS 0
    set in_dirS "${icdir}/EZ/html/${chapter}"
    set files [glob -tails -directory $in_dirS *.html]
    foreach f $files {
      set in_name [file join $in_dirS $f]
      set ftype [file type $in_name]
      if {$ftype == "link"} {
	continue ; # Don't output html linked files.
      }
      set out_name [file join $out_dirS $f]
      dump $in_name $out_name false
    }
    # Now dee if there are extra files to dump
    foreach f $extra_fileS {
      set in_name [file join $in_dirS $f]
      set fext [file extension $f]
      set ftype [file type $in_name]
      if {($ftype == "link") && ($fext == {.html})} {
	continue ; # Don't output html linked files.
      }
      if {$fext != {.html}} {
	set f [file tail $f] ; # short so we put tcl under directory.
      }
      set out_name [file join $out_dirS $f]
      dump $in_name $out_name true
    }
  }

  proc dump_single_page { } {
    upvar #0 ICvarsG ic
    variable in_dirS
    variable out_dirS
    variable recurseS
    variable figure_cntS
    variable extra_fileS

    set icdir $ic(E_icdir)

    set user_itools [file nativename ~/.itools]
    if {[file isdirectory $user_itools] == 0} {
      file mkdir $user_itools
    }
    set dumpdir [file join $user_itools htmldump]
    if {[file isdirectory $dumpdir] == 0} {
      file mkdir $dumpdir
    }
    set full_fname $ic(S_url)
    set fname [file tail $full_fname]
    set dname [file dirname $full_fname]
    set chapter [file tail $dname]

    set out_dirS [file join $dumpdir $chapter]
    if {[file isdirectory $out_dirS] == 0} {
      file mkdir $out_dirS
    }
    set extra_fileS ""
    set figure_cntS 0
    set in_dirS "${icdir}/EZ/html/${chapter}"
    set in_name $full_fname
    set out_name [file join $out_dirS $fname]
    dump $in_name $out_name false
    set single_page [file join $chapter $fname]

    if {$recurseS} {
      # Now see if there are extra files to dump
      # reset extra files.
      set extra_files $extra_fileS 
      set extra_fileS ""
      foreach f $extra_files {
	set in_name [file join $dname $f]
	set fext [file extension $f]
	set ftype [file type $in_name]
	if {$fext != {.html}} {
	  set f [file tail $f] ; # short so we put tcl under directory.
	}
	set out_name [file join $out_dirS $f]
	dump $in_name $out_name true
	set add_name [file join $chapter $f]
	lappend single_page $add_name
      }
    }
    return $single_page
  }

  proc gen_cover_pages { } {
    upvar #0 ICvarsG ic
    set icdir $ic(E_icdir)

    set user_itools [file nativename ~/.itools]
    if {[file isdirectory $user_itools] == 0} {
      file mkdir $user_itools
    }
    set dumpdir [file join $user_itools htmldump]
    if {[file isdirectory $dumpdir] == 0} {
      file mkdir $dumpdir
    }
    set out_file [file join $dumpdir cover.html]
    set logo "${icdir}/EZ/tcl/ICAD_LOGOez.jpg"
    set fp [open $out_file w]
    set secs [clock seconds]
    set todays_date [clock format $secs]

    puts $fp "<html>"
    puts $fp "<head>"
    puts $fp "<title>Itools/TimberWolf Documentation</title>"
    puts $fp "</head>"
    puts $fp "<body>"
    puts $fp "<p align=\"center\">"
    puts $fp "<img border=\"0\" src=\"${logo}\" width=\"252\" height=\"250\"></p>"
    puts $fp "<p align=\"center\">&nbsp;</p>"
    puts $fp "<h1 align=\"center\">Itools/TimberWolf $ic(S_user) Documentation</h1>"
    puts $fp "<h2 align=\"center\">Version [ictools_version]</h2>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p align=\"center\">$todays_date</p>"
    puts $fp "<p align=\"center\">"
    puts $fp "<I><FONT face=Verdana size=2><B>&#169;</B></FONT></I>"
    puts $fp "<b>2019-2025 TimberWolf Systems, Inc.&nbsp; All Rights Reserved</b></p>"
    puts $fp "</body>"
    puts $fp "</html>"
    close $fp
    return "$out_file"
  }

  proc gen_toc_pages { } {
    variable cstateS
    upvar #0 ICvarsG ic
    set icdir $ic(E_icdir)

    set user_itools [file nativename ~/.itools]
    if {[file isdirectory $user_itools] == 0} {
      file mkdir $user_itools
    }
    set dumpdir [file join $user_itools htmldump]
    if {[file isdirectory $dumpdir] == 0} {
      file mkdir $dumpdir
    }
    set out_file [file join $dumpdir toc.html]
    set fp [open $out_file w]
    set secs [clock seconds]
    set todays_date [clock format $secs]

    puts $fp "<html>"
    puts $fp "<head>"
    puts $fp "<title>Table of Contents</title>"
    puts $fp "</head>"
    puts $fp "<body>"
    puts $fp "<h1 align=\"center\">Table of Contents</h1>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"

    if {$cstateS(welcome)} {
      set short_href welcome.html 
      set new_href [file join welcome $short_href]
      set link [list welcome $new_href $short_href]
      create_dump_link $link $dumpdir
      puts $fp "<BR>Chapter 1  <A HREF=$short_href> Welcome</A>"
      puts $fp "<p></p>"
    }

    if {$cstateS(start)} {
      set short_href starting.html 
      set new_href [file join start $short_href]
      set link [list start $new_href $short_href]
      create_dump_link $link $dumpdir
      puts $fp "<BR>Chapter 2  <A HREF=$short_href>Getting Started</A>"
      puts $fp "<p></p>"
    }
    if {$cstateS(inputs)} {
      set short_href inputs.html 
      set new_href [file join inputs $short_href]
      set link [list inputs $new_href $short_href]
      create_dump_link $link $dumpdir
      puts $fp "<BR>Chapter 3  <A HREF=$short_href>File Input Description and Translation</A>"
      puts $fp "<p></p>"
    }

    if {$cstateS(syntax)} {
      set short_href syntax.html 
      set new_href [file join syntax $short_href]
      set link [list syntax $new_href $short_href]
      create_dump_link $link $dumpdir
      puts $fp "<BR>Chapter 4  <A HREF=$short_href>Input Data Syntax Checking</A>"
      puts $fp "<p></p>"
    }

    if {$cstateS(place)} {
      set short_href place.html 
      set new_href [file join place $short_href]
      set link [list place $new_href $short_href]
      create_dump_link $link $dumpdir
      puts $fp "<BR>Chapter 5  <A HREF=$short_href>Floorplanning and Placement</A>"
      puts $fp "<p></p>"
    }
    if {$cstateS(route)} {
      set short_href route.html 
      set new_href [file join route $short_href]
      set link [list route $new_href $short_href]
      create_dump_link $link $dumpdir
      puts $fp "<BR>Chapter 6  <A HREF=$short_href>Global and Detailed Routing</A>"
      puts $fp "<p></p>"
    }
    if {$cstateS(verify)} {
      set short_href verify.html 
      set new_href [file join verify $short_href]
      set link [list verify $new_href $short_href]
      create_dump_link $link $dumpdir
      puts $fp "<BR>Chapter 7  <A HREF=$short_href>Post-Routing and Verification</A>"
      puts $fp "<p></p>"
    }

    if {$cstateS(custom)} {
      set short_href custom.html 
      set new_href [file join custom $short_href]
      set link [list custom $new_href $short_href]
      create_dump_link $link $dumpdir
      puts $fp "<BR>Chapter 8  <A HREF=$short_href>Customizing iTools / TimberWolf</A>"
      puts $fp "<p></p>"
    }

    if {$cstateS(suggest)} {
      set short_href suggest.html 
      set new_href [file join suggest $short_href]
      set link [list suggest $new_href $short_href]
      create_dump_link $link $dumpdir
      puts $fp "<BR>Chapter 9  <A HREF=$short_href>Frequently Asked Questions</A>"
      puts $fp "<p></p>"
    }

    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p>&nbsp;</p>"
    puts $fp "<p align=\"center\">$todays_date</p>"
    puts $fp "<p align=\"center\">"
    puts $fp "<I><FONT face=Verdana size=2><B>&#169;</B></FONT></I>"
    puts $fp "<b>2019-2025 TimberWolf Systems, Inc.&nbsp; All Rights Reserved</b></p>"
    puts $fp "</body>"
    puts $fp "</html>"
    close $fp
    return "$out_file"

  }

  proc process_pages {chapter dump_dir predef_pages} {
    set chapter_dir [file join ${dump_dir} ${chapter}]
    set other_files [glob -tails -directory $chapter_dir *]
    # First add the predefined order pages
    set files [list --path $chapter]
    foreach f $predef_pages {
      lappend files [file join ${chapter} ${f}]
    }
    # Now add any remaining pages
    foreach f $other_files {
      set fext [file extension $f]
      if {$fext == {.gif}} {
	continue ;
      }
      set idx [lsearch -exact $predef_pages $f]
      if {$idx < 0} {
	# Not in the list - add
	lappend files [file join ${chapter} ${f}]
      }
    }
    return $files
  }
  
  proc dump_doc { } {
    upvar #0 ICvarsG tw
    variable cstateS
    variable recurseS
    variable alldocS

    ez_message imsg "generating documentation..."
    ez_busy
    update
    set icdir $tw(E_icdir)
    # Let widgets know we are dumping documentation
    set tw(P_dumping_doc) 1
    # First dump each of the chapters.
    set user_itools [file nativename ~/.itools]
    if {[file isdirectory $user_itools] == 0} {
      file mkdir $user_itools
    }
    set dumpdir [file join $user_itools htmldump]
    if {[file isdirectory $dumpdir]} {
      catch {file delete -force $dumpdir}
      if {[catch {file delete -force $dumpdir} result_msg]} {
	twalert_user -msg_func "" errmsg dump_doc "Problem:$result_msg"
      }
    }
    if {[file isdirectory $dumpdir] == 0} {
      file mkdir $dumpdir
    }

    if {!([info exists tw(geom_x)])} {
      set tw(geom_x) 0
    }
    if {!([info exists tw(geom_y)])} {
      set tw(geom_y) 0
    }
    if {$tw(P_doc_select) == "recurse"} {
      set recurseS true
    } else {
      set recurseS false
    }

    # Always make all the chapters because we might need to make a link
    foreach ch $alldocS {
      set out_dir [file join $dumpdir $ch]
      if {[file isdirectory $out_dir] == 0} {
	file mkdir $out_dir
      }
    }

    set chapters ""
    if {$cstateS(welcome)} {
      lappend chapters welcome
    }
    if {$cstateS(start)} {
      lappend chapters start
    }
    if {$cstateS(inputs)} {
      lappend chapters inputs
    }
    if {$cstateS(syntax)} {
      lappend chapters syntax
    }
    if {$cstateS(place)} {
      lappend chapters place
    }
    if {$cstateS(route)} {
      lappend chapters route
    }
    if {$cstateS(verify)} {
      lappend chapters verify
    }
    if {$cstateS(custom)} {
      lappend chapters custom
    }
    if {$cstateS(suggest)} {
      lappend chapters suggest
    }

    # Generate cover page
    ez_message imsg "generating cover page..."
    set cover_pages [gen_cover_pages]

    # Rerender chapter so we can convert.
    foreach chapter $chapters {
      ez_message imsg "rendering $chapter..."
      dump_chapter $chapter
    }

    # Now create any links if they exist
    if {[info exists tw(dump_link_update)]} {
      set links_to_build $tw(dump_link_update)
      foreach link $links_to_build {
	set chpt [lindex $link 0]
	set new_dir [file join $dumpdir $chpt]
	create_dump_link $link $new_dir
      }
      unset tw(dump_link_update)
    }

    # generate the table of contents
    ez_message imsg "generating table of contents..."
    set toc_pages [gen_toc_pages]

    # Now we set some order of the pages
    if {$cstateS(welcome)} {
      set welcome_order {pdfdiff.html welcome.html intro.html ddoc.html reading.html \
			 benchmark.html}
      set welcome_pages [process_pages welcome $dumpdir $welcome_order]
    } else {
      set welcome_pages ""
    }

    if {$cstateS(start)} {
      set start_order {starting.html tutorial.html}
      set start_pages [process_pages start $dumpdir $start_order]
    } else {
      set start_pages ""
    }

    if {$cstateS(inputs)} {
    set inputs_order {inputs.html lib.html ckt.html param.html cons.html \
                      host.html ictrans.html}
    set inputs_pages [process_pages inputs $dumpdir $inputs_order]
    } else {
      set inputs_pages ""
    }

    if {$cstateS(syntax)} {
    set syntax_order {syntax.html designtype.html}
    set syntax_pages [process_pages syntax $dumpdir $syntax_order]
    } else {
      set syntax_pages ""
    }

    if {$cstateS(place)} {
    set place_order {place.html lic_intro.html}
    set place_pages [process_pages place $dumpdir $place_order]
    } else {
      set place_pages ""
    }

    if {$cstateS(route)} {
    set route_order {route.html routeable.html}
    set route_pages [process_pages route $dumpdir $route_order]
    } else {
      set route_pages ""
    }

    if {$cstateS(verify)} {
    set verify_order {verify.html grand.html}
    set verify_pages [process_pages verify $dumpdir $verify_order]
    } else {
      set verify_pages ""
    }

    if {$cstateS(custom)} {
    set custom_order {custom.html graphics.html}
    set custom_pages [process_pages custom $dumpdir $custom_order]
    } else {
      set custom_pages ""
    }

    if {$cstateS(suggest)} {
    set suggest_order {suggest.html dsnlib.html}
    set suggest_pages [process_pages suggest $dumpdir $suggest_order]
    } else {
      set suggest_pages ""
    }

    set ez_pages "$welcome_pages $start_pages $inputs_pages $syntax_pages \
	       $place_pages $route_pages $verify_pages $custom_pages \
	       $suggest_pages"

    # Output only this page.
    if {($cstateS(this_page))} {
      set num_pages [llength $ez_pages]
      if {$num_pages == 0} {
	set ez_pages [dump_single_page]
      }
    }

    # Generate a table of contents from the EZ pages.
    set pages "$cover_pages $toc_pages $ez_pages"

    set cwd [pwd]
    cd $dumpdir
    set program htmldoc
    set icos ${icdir}/bin/icos
    set pgm [exec $icos -noexec $program]
    if {!([info exists tw(P_doc_output)])} {
      twalert_user -msg_func "" errmsg dump_doc "Output format not set."
      return ;
    }
    set htmldocdata [file join $icdir htmldoc]
    if {$tw(P_doc_output)} {
      set fname [file join $user_itools twolfdoc.pdf]
      set pgmopts "--left 36 --no-title --datadir $htmldocdata --webpage --linkcolor blue -f $fname"
      ez_message imsg "convert to PDF.  Please wait..."
      set info "Created PDF file: $fname\n\n"
    } else {
      set fname [file join $user_itools twolfdoc.ps]
      set pgmopts "--left 36 --no-title --datadir $htmldocdata --webpage --linkcolor blue -f $fname"
      ez_message imsg "convert to PostScript.  Please wait..."
      set info "Created PostScript file: $fname\n\n"
    }
    set fcmdname [file join $user_itools twolfdoc.cmd]
    set fcmd [open $fcmdname "w"]
    if {$fcmd != ""} {
      puts $fcmd "#!/bin/sh"
      puts $fcmd "cd [file join $user_itools htmldump]"
      puts $fcmd "$pgm $pgmopts $pages"
      close $fcmd
    }
    puts stderr "$pgm $pgmopts $pages"
    if {[catch {eval exec $pgm $pgmopts $pages} result_msg]} {
      twalert_user -msg_func "" msg dump_doc "${info}$result_msg"
    } else {
      twalert_user -msg_func "" msg dump_doc "${info}"
    }
    unset tw(P_dumping_doc)
    ez_message imsg "generated $fname..."
    ez_ready

    cd $cwd
  }

  proc create_dump_link { link new_dir } {
    set save_dir [pwd]
    set chpt [lindex $link 0]
    set new_href [lindex $link 1]
    set base_file [lindex $link 2]
    cd $new_dir
    if {[catch {file link -symbolic $base_file $new_href} result_msg]} {
      puts stderr "ERROR: $result_msg pwd:[pwd]\n"
    }
    cd $save_dir
  }

  proc display_pdf { }  {
    global ICvarsG
    variable alldocS
    variable cstateS

    set w .twdumpgui
    if {[winfo exists $w]} {
      wm withdraw $w
      wm deiconify $w
      return ;
    }

    toplevel $w
    
    wm positionfrom $w ""
    wm sizefrom $w ""
    wm maxsize $w 800 800
    wm minsize $w 10 10
    wm title $w {Create PDF / PS Documentation}

    tixLabelFrame $w.output -label {Output Format:} -labelside acrosstop -options {
	label.padX 5
    }
    if {!([info exists ICvarsG(P_doc_output)])} {
      set ICvarsG(P_doc_output) 1
    }
    set fout [$w.output subwidget frame]
    label $fout.lab -text "Format:"
    radiobutton $fout.pdf -variable ICvarsG(P_doc_output) -value 1 -text PDF
    radiobutton $fout.ps -variable ICvarsG(P_doc_output) -value 0 \
      -text PostScript
    grid $fout.lab $fout.pdf $fout.ps

    tixLabelFrame $w.parts -label {Chapter Selection:} -labelside acrosstop -options {
	label.padX 5
    }
    if {!([info exists ICvarsG(P_doc_select)])} {
      set ICvarsG(P_doc_select) all
      set_chapters
    }
    set f [$w.parts subwidget frame]
    label $f.lab -text "Chapters:"
    radiobutton $f.all -variable ICvarsG(P_doc_select) -value all \
      -text {all                 } -command "::twez::set_chapters" 
    radiobutton $f.select -variable ICvarsG(P_doc_select) -value select \
      -text {select              }
    radiobutton $f.page -variable ICvarsG(P_doc_select) -value page \
      -text {this page only      } -command "::twez::unset_chapters" 
    radiobutton $f.recurse -variable ICvarsG(P_doc_select) -value recurse \
      -text {this page+decendents} -command "::twez::unset_chapters" 
    grid $f.lab x $f.all $f.page 
    grid x x $f.select $f.recurse
    grid $f.lab -sticky news
    grid $f.all -sticky wns
    grid $f.select -sticky wns 
    grid $f.page -sticky wns
    grid $f.recurse -sticky wns
    label $f.dummy_lab -text " "
    grid $f.dummy_lab x x x

    checkbutton $f.welcome -text "Welcome" -padx {20} \
      -variable ::twez::cstateS(welcome) -anchor w
    checkbutton $f.start -text "Getting Started" -padx {20} \
      -variable ::twez::cstateS(start) -anchor w
    checkbutton $f.lessons -text "Lessons" -padx {20} \
      -variable ::twez::cstateS(lessons) -anchor w
    checkbutton $f.problems -text "Problems" -padx {20} \
      -variable ::twez::cstateS(problems) -anchor w
    checkbutton $f.solutions -text "Solutions" -padx {20} \
      -variable ::twez::cstateS(solutions) -anchor w
    checkbutton $f.resources -text "Resources" -padx {20} \
      -variable ::twez::cstateS(resources) -anchor w
    checkbutton $f.custom -text "Customizing" -padx {20} \
      -variable ::twez::cstateS(custom) -anchor w

    grid x $f.welcome $f.start $f.lessons
    grid x $f.problems $f.solutions $f.resources
    grid x x $f.custom x
    foreach chapter $alldocS {
      grid $f.${chapter} -sticky ew
    }

    tixLabelFrame $w.user -label {User Mode:} -labelside acrosstop -options {
	label.padX 5
    }
    set fuser [$w.user subwidget frame]
    ez_user $fuser

    tixLabelFrame $w.mode -label {Area of Study:} -labelside acrosstop -options {
	label.padX 5
    }
    set fmode [$w.mode subwidget frame]
    set_area $fmode

    tixLabelFrame $w.offset -label {Capture Geometry Offset:} -labelside acrosstop -options {
	label.padX 5
    }
    set foffset [$w.offset subwidget frame]
    tixControl $foffset.x -label " X Position" -integer true \
       	-variable ICvarsG(geom_x) -min -16000 -max 16000 \
	-selectmode immediate \
	-options {
	  entry.width 4
	  label.width 20
	  label.anchor w
    }
    set uname [utdversion uname]
    if {$uname == "Darwin"} {
      set ICvarsG(geom_x) 100
    }
    tixControl $foffset.y -label " Y Position" -integer true \
       	-variable ICvarsG(geom_y) -min -16000 -max 16000 \
	-selectmode immediate \
	-options {
	  entry.width 4
	  label.width 20
	  label.anchor w
    }
    grid $foffset.x $foffset.y
    tixBalloon $w.offsetbal -initwait 100
    $w.offsetbal bind $w.offset -msg \
      "Use the position controls in order to control where\n\
       on the screen the Tk widgets will popup.  Controlling\n\
       the origin of Tk widget is useful when persistent \n\
       objects exist on the desktop and one needs to avoid\n\
       these objects in order to display the Tk widgets \n\
       properly. The coordinates follow the normal X \n\
       convention."

    tixLabelFrame $w.notes -label {Notes:} -labelside acrosstop -options {
	label.padX 5
    }
    set fnotes [$w.notes subwidget frame]
    label $fnotes.lab -anchor w -justify left -text \
"This operation will pop up Tk widgets in order to capture them.\n\
Please do not move the mouse or move/create any windows as\n\
this will influence the capture.  This window will remain visible\n\
until the entire process is complete.  While it is possible to\n\
generate documentation in design mode, it is recommended to\n\
choose a tutorial mode which corresponds to your design\n\
style so example data is present."
    pack $fnotes.lab -side top -fill both -expand 1

    tixButtonBox $w.box -orientation horizontal
    $w.box add accept   -text {Create Document} \
       -command "::twez::update_button $w ; ::twez::dump_doc; destroy $w"
    $w.box add cancel -text {Cancel} -command "destroy $w"


    pack $w.output -side top -fill x
    pack $w.parts -side top -fill x
    pack $w.user -side top -fill x
    pack $w.mode -side top -fill x
    pack $w.offset -side top -fill x
    pack $w.notes -side top -fill x
    pack $w.box -side top -fill x
  }

  proc set_chapters {args} {
    variable cstateS
    variable alldocS
    foreach c $alldocS {
      set cstateS($c) 1
    }
    set cstateS(this_page) 0
  }

  proc unset_chapters {args} {
    variable cstateS
    variable alldocS
    foreach c $alldocS {
      set cstateS($c) 0
    }
    set cstateS(this_page) 1
  }

  proc update_button { w } {
    set b [$w.box subwidget accept]
    $b configure -state disabled
    update
  }

}
