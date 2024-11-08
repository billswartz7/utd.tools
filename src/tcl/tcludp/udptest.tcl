
package require udp

global fd

proc udpEventHandler { udp_server } {
  puts "event triggered..."
  puts "Data: [read $udp_server]"
  puts "Peer: [udp_conf $udp_server -peer]"
}

set udp_server [udp_open 9090]
fconfigure $udp_server -broadcast 1
fileevent $udp_server readable [list ::udpEventHandler $udp_server]
puts "Listening on udp port: [udp_conf $udp_server -myport]"

vwait __forever__
			
