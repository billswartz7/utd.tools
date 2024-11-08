# $Id: backup.tcl,v 1.1 2018/09/02 15:37:04 bill Exp bill $
# $Log: backup.tcl,v $
# Revision 1.1  2018/09/02 15:37:04  bill
# Initial revision
#
# Revision 1.1  2018/06/25 14:41:55  bill
# Initial revision
#
#

namespace eval utdgui {
  variable compression_typeS "gzip"

  proc backup_file {basename {ddir .}} {
    set routine ::utdgui::backup_file
    if {$basename == "-help"} {
      utdmsg imsg $routine "help command:\n"
      utdmsg imsg null "  $routine <filename> \[<directoryName>]\n"
      utdmsg imsg null "If the optional <directoryName> isn't specified,\n"
      utdmsg imsg null "the directory is set to the current working directory.\n"
      return ;
    }
    set backup_char ":"
    set filename [file join $ddir $basename]
    if {[file exists $filename]} {
      for {set i 1} {1} {incr i} {
	set bfname "${basename}${backup_char}${i}"
	set bfilename [file join $ddir $bfname]
	if {!([file exists $bfilename])} {
	  file rename -force -- $filename $bfilename
	  return "$bfilename"
	}
      }
    } 
    return ""
  }

  proc backup_directory {ddir args} {
    set routine ::utdgui::backup_directory
    set backup_char ":"
    set create_flag true
    if {$ddir == "-help"} {
      utdmsg imsg icbackup_directory "help command:\n"
      utdmsg imsg null "  $routine \[-nocreate]\n"
      return ;
    }
    set num_args [llength $args]
    for {set i 0} {$i < $num_args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-nocreate" } {
	set create_flag false
      } elseif {$arg_el == "-help" } {
	utdmsg imsg icbackup_directory "help command:\n"
	utdmsg imsg null "  $routine \[-nocreate]\n"
	return ;
      } else {
	utdmsg errmsg $routine "Unknown argument:$arg_el\n"
	return ;
      }
    }
    if {[catch {exec sync} msg]} {
      utdmsg errmsg $routine "Could not exec sync\n"
    }
    if {[file exists $ddir]} {
      if {[catch {exec sync} msg]} {
	$utdmsg errmsg $routine "Could not exec sync\n"
      }
      for {set i 1} {1} {incr i} {
	set backup_dir "${ddir}${backup_char}${i}"
	if {!([file exists $backup_dir])} {
	  file rename -force -- $ddir $backup_dir
	  if {$create_flag} {
	    file mkdir $ddir
	  }
	  return "$backup_dir"
	}
      }
    } 
    if {$create_flag} {
      file mkdir $ddir
    }
    return ""
  }

  proc create_softlink {input_name relative_path} {
    # Create a soft link using relative path
    # If file exist already or link can't be created, return null
    # Else return the link target.
    if {[file exists $input_name]} {
      return ""
    }
    set link_src $input_name
    set link_target [file join $relative_path $input_name]
    if {[file exists $link_target]} {
      if {[catch {file link -symbolic $link_src $link_target} result_msg]} {
	utdmsg errmsg ::utdgui::create_softllink "Problem:$result_msg"
	return ""
      } else {
	return $link_target
      }
    } else {
      return ""
    }
  } 

  proc set_compression_type {ctype} {
    variable compression_typeS
    if {$ctype != ""} {
      set types [list gzip bzip2 compress xz]
      set idx [lsearch -exact $types $types]
      if {$idx < 0} {
	utdmsg errmsg "set_compresison_type" "unsupported compression type:${ctype}\n"
	return ;
      }
    }
    set compression_typeS $ctype
  }

  proc get_compression_type {} {
    variable compression_typeS

    return $compression_typeS
  }


  proc file_exists {file_name} {
    # See if file exists, it it does return path
    # Else return ""
    set routine ::utdgui::file_exists
    # First see if the uncompressed file exists - highest priority
    if {[file exist $file_name]} {
      return $file_name
    }
    # Else go thru all of the supported compressed types.
    set compressed_types [list .gz .bz2 .Z .xz]
    foreach compressed_type $compressed_types {
      set new_file_name "${file_name}$compressed_type"
      # utdmsg imsg $routine "testing $new_file_name ...\n"
      if {[file exist $new_file_name]} {
        # utdmsg imsg $routine "found $new_file_name ...\n"
	return $new_file_name
      }
    }
    return ""
  }

}
