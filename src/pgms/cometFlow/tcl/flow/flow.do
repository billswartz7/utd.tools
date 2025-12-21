# This is the default flow.do file

puts stderr "at the flow file we have $::utdtools::numPartitionS"

if {!([::utdtools::flow::initialized])} {
  ::utdtools::flow::init $::utdtools::designNameS \
  $::utdtools::numPartitionS $::utdtools::flowS
}

::utdtools::flow::run $::utdtools::flow::flowgraphS \
                      $::utdtools::flow::designS 

utdexit
