#!/usr/local/bin/wish -f
#
# $Log$
 
package require udp

namespace eval utdtestcenter {
  variable broadcast_sockS
  variable broadcast_addressS

  proc test_defaults { } {
    variable optionS
    set optionS(debug) false
    expr {srand(3)}
  }

  proc get_broadcast_ip { address } { 
    set idx [string last . $address]
    if {$idx >= 0} {
      set prefix [string range $address 0 $idx]
      append prefix 255
      return $prefix
    }
    return ""
  }

  proc get_ip {args} { 
    set address_list [udp_info]
    foreach address $address_list {
      puts stderr "address: $address"
      if {$address == "127.0.0.1"} {
	continue 
      }
      return $address

    }
    return ""
  }

  proc broadcast_init { broadcast_ip  port_num } {
    puts stderr "broadcast:$broadcast_ip port_num:$port_num"
    set udp_server [udp_open $port_num]
    puts stderr "upd_server:$udp_server"
    udp_conf $udp_server $broadcast_ip $port_num
    fconfigure $udp_server -broadcast 1 -buffering none
    return $udp_server
  }

  proc broadcast_udp { address count } {
    variable broadcast_sockS
    puts $broadcast_sockS "utdtestcenter $address $count"
    incr count
    after 2000 "::utdtestcenter::broadcast_udp $address $count"
  }

  proc start_udp { } {
    variable broadcast_sockS
    puts stderr "we get here\n"
    set hostname [exec hostname]
    puts stderr "host name:$hostname:$hostname"
    set my_ip [get_ip]
    puts stderr "my ip:$my_ip"
    set broadcast [get_broadcast_ip $my_ip]
    set broadcast_sockS [broadcast_init $broadcast 9090]
    if {$broadcast_sockS != ""} {
      broadcast_udp $my_ip 0
    } else {
      utdmsg errmsg start_udp "couldn't start broadcast\n"
    }
  }
  
}

set args [utdscript_args]
# puts stderr "raw args: $args"
set args [string trimright $args]
set num_args [llength $args]
set routine "utdtestcenter"
# puts stderr "args: $args num: $num_args"
for {set i 0} {$i < $num_args} {incr i} {
  set arg_el [lindex $args $i]
  if {$arg_el == "-debug" } {
    lappend options "-debug"
    puts stdout "debug mode enabled.\n"
    flush stdout
  } elseif {$arg_el == "test" } {
    incr i
    if {$i < $num_args} {
      lappend options "-test"
      lappend options [lindex $args $i]
    } else {
      utdmsg errmsg $routine "Missing argument to test\n"
      exit 1 ;
    }
  } elseif {$arg_el == "libpath" } {
    incr i
    if {$i < $num_args} {
      lappend options "-libpath"
      lappend options [lindex $args $i]
    } else {
      utdmsg errmsg $routine "Missing argument to -libpath\n"
      exit 1 ;
    }
  } elseif {$arg_el == "help" } {
    utdmsg imsg null "Usage:\n"
    utdmsg imsg null "  utdtestcenter \[libpath <path>]\n\n"
    exit 0
  } else {
    utdmsg errmsg $routine "Unknown option: $arg_el\n"
    exit 1
  }
}

::utdtestcenter::start_udp
utdwait
