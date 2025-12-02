
namespace eval utdtools {

  proc create_link {directory depth userid file_name match_exactly lower_case check_makefiles linked_filename args} {
    upvar $linked_filename linked
    set debug_flag false
    set num_args [llength $args]
    for {set i 0} {$i < $num_args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-debug" } {
	set debug_flag true
      }
    }
    # puts stderr "looking for $userid in ../$directory"
    if {$debug_flag} {
      puts stderr "match:$match_exactly lower_case:$lower_case check:$check_makefiles"
    }
    set problems 0
    if {($check_makefiles)} {
      set link_src ${userid}_${file_name}
    } else {
      set link_src ${file_name}
    }
    if {[file exists $link_src]} {
      return 0 ; # No work to do.
    }
    set problems 1
    set name_len [string length $file_name]
    foreach fname [glob -nocomplain -directory ${depth}$directory *${userid}*] {
      if {$debug_flag} {
	puts stderr "looking for $userid in ../../$directory fname:$fname"
      }
      if {$match_exactly} {
	if {$lower_case} {
	  set fname [string tolower $fname]
	}
	set fname_len [string length $fname]
	set idx [expr $fname_len - $name_len]
	set short_name [string range $fname $idx end]
	if {$short_name != $file_name} {
	  puts stderr "did not match short_name:$short_name fname:$file_name"
	  continue
	}
      }
      if {$debug_flag} {
	puts stderr "file link -symbolic $link_src $fname"
      }
      if {[catch {file link -symbolic $link_src $fname} result_msg]} {
	puts stderr "ERROR: $result_msg\n"
	incr problems
      } else {
	set linked $fname
	return 0
      }
    }
    return $problems
  }


  proc file_exists {file_name args} {
    set debug_flag false
    set num_args [llength $args]
    for {set i 0} {$i < $num_args} {incr i} {
      set arg_el [lindex $args $i]
      if {$arg_el == "-debug" } {
	set debug_flag true
      }
    }
    if {$debug_flag} {
      puts -nonewline stderr "check existance of [pwd] / $file_name ... "
    }
    if {[file exists $file_name]} {
      if {$debug_flag} {
	puts stderr "found."
      }
      return 0
    }
    if {$debug_flag} {
      puts stderr "does not exist."
    }
    return 1
  }

  proc file_executable {file_name} {
    if {[file exists $file_name]} {
      set permissions [file attributes $file_name -permissions]
      set permissions [string range $permissions 0 2]
      if {$permissions == "007"} {
	return 0
      }
    }
    return 1
  }

  proc delete_wildcards {directory pattern} {
    foreach fname [glob -nocomplain -directory $directory ${pattern}] {
      file delete -force $fname
    }
  }

}
