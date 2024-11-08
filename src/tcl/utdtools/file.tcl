
namespace eval utdtools {

  proc create_link {directory userid file_name match_exactly} {
    # puts stderr "looking for $userid in ../$directory"
    set problems 0
    set link_src ${userid}_${file_name}
    if {[file exists $link_src]} {
      return ; # No work to do.
    }
    set problems 1
    set name_len [string length $file_name]
    foreach fname [glob -nocomplain -directory ../$directory *${userid}*] {
      if {$match_exactly} {
	set fname_len [string length $fname]
	set idx [expr $fname_len - $name_len]
	set short_name [string range $fname $idx end]
	if {$short_name != $file_name} {
	  puts stderr "did not match short_name:$short_name fname:$file_name"
	  continue
	}
      }
      puts stderr "file link -symbolic $link_src $fname"
      if {[catch {file link -symbolic $link_src $fname} result_msg]} {
	puts stderr "ERROR: $result_msg\n"
	incr problems
      } else {
	return 0
      }
    }
    return $problems
  }


  proc file_exists {file_name} {
    if {[file exists $file_name]} {
      return 0
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

}
