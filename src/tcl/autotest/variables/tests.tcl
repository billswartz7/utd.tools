
proc build_address {args} {
  global wide
  set addresses ""
  set used(-1) -1
  set max_count 1000000
  for {set a 1} {$a <= 5} {incr a} {
    for {set count 1} {$count <= $max_count} {incr count} {
      set addr_idx [::utd::rand_range 0 10]
      if {!([info exists used($addr_idx)])} {
	set used($addr_idx) $addr_idx
	break ;
      }
    }
    set addr [expr $addr_idx * $wide]
    lappend addresses $addr
  }
  return $addresses
}


proc output_lib_name {args} {

  # return $libname
  return "libfib"
}
