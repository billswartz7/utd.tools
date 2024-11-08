

namespace eval utdtools {
  namespace eval flow {
    variable flowS
    variable designNameS
    variable numPartitionS 1
    variable start_pgmS start
    variable end_pgmS ""
    variable flowgraphS ""
    variable full_flowS true
    variable initializedS false

    proc init {dsn num_cuts flow args} {
      variable flowS
      variable designNameS
      variable numPartitionS
      variable flowgraphS
      variable initializedS
      variable full_flowS

      ###################################################################
      # Set up environment variables to enable execution.
      ###################################################################
      global env
      set utdtools $env(UTDTOOLS)
      set routine "::utdtools::init"

      package require struct::graph 2.4
      set flowgraphS [::struct::graph flowgraph]

      # Save the static variables
      set flowgraph $flowgraphS
      set flowS $flow
      set designNameS $dsn
      set numPartitionS $num_cuts

      set num_args [llength $args]
      for {set i 0} {$i < $num_args} {incr i} {
	set arg_el [lindex $args $i]
	if {$arg_el == "-nologicsynth" } {
	  set full_flowS false
	} else {
	  utdmsg errmsg $routine "Unknown argument:$arg_el\n"
	  return ;
	}
      }

      # How we pass user data to execute_pgm
      $flowgraph set utdtools $utdtools
      $flowgraph set xterm_args "-sb -sl 5000 -geometry 140x70+80+40"

      if {$flow != "default"} {
	utdmsg errmsg $routine "user defined flows not implemented yet\n"
	return ;
      }

      if {$num_cuts == 1} {
	simple_sequential_flow $flowgraph $dsn
      } else {
	simple_partitioned_flow $flowgraph $dsn $num_cuts
      }

      # Now build the open road directory
      ::utdtools::backup_directory utdtools

      # Go to new directory and remember its path
      cd utdtools
      set cdir [pwd]
      cd ..

      set initializedS true
      return $cdir

    }

    proc initialized { } {
      variable initializedS
      return $initializedS
    }

    proc run {flowgraph dsn args} {

      variable start_pgmS
      variable end_pgmS

      $flowgraph walk $start_pgmS -type dfs -command [list exec_pgm $dsn $end_pgmS]

    }

    proc exec_pgm {dsn end_pgm mode graph node args} {
      variable full_flowS

      set utdtools [$graph get utdtools]
      set xterm_args [$graph get xterm_args]
      # puts stderr "mode:$mode graph:$graph node:$node dsn:$dsn utdtools:$utdtools"

      if {$node == "start"} {
	if {$full_flowS} {
	  ::utdtools::create_softlink ${dsn}.c ../
	} else {
	  ::utdtools::create_softlink ${dsn}.v ../
	}
	return ;
      }
      set directory [$graph node get $node directory]

      set program [$graph node get $node program]
      set pargs [$graph node get $node program_args]

      if {([$graph node keyexists $node program_path])} {
	set pgm_path [$graph node get $node program_path]
      } else {
	set pgm_path [file join $utdtools scripts flow $program]
      }
      puts stderr "node:$node directory: $directory exec: $pgm_path $pargs $"
      global statusG
      if {[catch {set run_in_xterm $::utdtools::run_in_xtermS} msg]} {
	set run_in_xterm false
      }

      if {$run_in_xterm} {
	if {[catch {eval bgexec statusG -output outputG xterm $xterm_args -e \
	   $pgm_path $pargs $dsn} msg]} {
	  utdmsg errmsg exec_pgm "we got the following msg running $pgm_path $pargs $dsn:\n$msg\n"
	}
      } else {
	if {[catch {eval bgexec statusG -output outputG $pgm_path $pargs $dsn} msg]} {
	  utdmsg errmsg exec_pgm "we got the following msg running $pgm_path $pargs $dsn:$msg\n"
	}
      }
      utdmsg imsg exec_pgm "Our status after running $node was $statusG\n\n"
    }

    proc simple_sequential_flow {flowgraph dsn} {
      variable full_flowS 

      set phases "highlevel logic cut floorplan place cts groute \
      	droute assembly metalfill buffer size pdn final"

      foreach phase $phases {
	set nodename [$flowgraph node insert $phase]
	$flowgraph node append $nodename directory $phase
      }

      # Name a special name for the start of the graph
      $flowgraph node insert start

      # Linear flow for now
      if {$full_flowS} {
	$flowgraph arc insert start logic
	$flowgraph arc insert logic cut
      } else {
	$flowgraph arc insert start cut
      }
      $flowgraph arc insert cut floorplan
      $flowgraph arc insert floorplan place
      $flowgraph arc insert place cts
      $flowgraph arc insert cts groute
      $flowgraph arc insert groute droute
      $flowgraph arc insert droute assembly
      $flowgraph arc insert assembly metalfill
      $flowgraph arc insert metalfill final

      # Data for high level
      $flowgraph node append highlevel mandatory_inputs $dsn.c
      $flowgraph node append highlevel optional_inputs $dsn.hdo
      $flowgraph node append highlevel outputs output/$dsn.v
      $flowgraph node append highlevel program simhls
      $flowgraph node append highlevel program_args ""

      # Notice alternative are just listed in a Tcl list.
      $flowgraph node append logic mandatory_inputs \
	[list [list ../highlevel/$dsn.v [list ../highlevel/$dsn.lef $dsn.lef]] \
	{$dsn.v $dsn.lef}]
      $flowgraph node append logic optional_inputs $dsn.ldo
      $flowgraph node append logic outputs output/$dsn.v
      $flowgraph node append logic program simlogic
      $flowgraph node append logic program_args ""

      # Now the cut program
      $flowgraph node append cut program simcut
      $flowgraph node append cut program_args ""
      $flowgraph node append cut optional_inputs $dsn.cdo

      # Now the floorplan program
      $flowgraph node append floorplan program simfloorplan
      $flowgraph node append floorplan program_args ""
      $flowgraph node append floorplan optional_inputs $dsn.fdo

      # Now the place program
      $flowgraph node append place program simplace
      $flowgraph node append place program_args ""
      $flowgraph node append place optional_inputs $dsn.pdo

      # Now the cts program
      $flowgraph node append cts program simcts
      $flowgraph node append cts program_args ""
      $flowgraph node append cts optional_inputs $dsn.tdo

      # Now the groute program
      $flowgraph node append groute program simgroute
      $flowgraph node append groute program_args ""
      $flowgraph node append groute optional_inputs $dsn.gdo

      # Now the droute program
      $flowgraph node append droute program simdroute
      $flowgraph node append droute program_args ""
      $flowgraph node append droute optional_inputs $dsn.ddo

      # Now the assembly program
      $flowgraph node append assembly program simassembly
      $flowgraph node append assembly program_args ""
      $flowgraph node append assembly optional_inputs $dsn.ado

      # Now the metalfill program
      $flowgraph node append metalfill program simfill
      $flowgraph node append metalfill program_args ""
      $flowgraph node append metalfill optional_inputs $dsn.mdo

      # Now the final program
      $flowgraph node append final program simfinal
      $flowgraph node append final program_args ""
      $flowgraph node append final optional_inputs $dsn.odo

    }

    proc simple_partitioned_flow {flowgraph dsn num_parts} {

      set phases "highlevel logic cut floorplan \
                  assembly metalfill buffer size pdn"

      foreach phase $phases {
	set nodename [$flowgraph node insert $phase]
	$flowgraph node append $nodename directory $phase
      }

      # Name a special name for the start of the graph
      $flowgraph node insert start

      # Linear flow for now
      $flowgraph arc insert start highlevel
      $flowgraph arc insert highlevel logic
      $flowgraph arc insert logic cut
      $flowgraph arc insert cut floorplan
      $flowgraph arc insert floorplan assembly
      $flowgraph arc insert assembly metalfill

      # Data for high level
      $flowgraph node append highlevel mandatory_inputs $dsn.c
      $flowgraph node append highlevel optional_inputs $dsn.hdo
      $flowgraph node append highlevel outputs output/$dsn.v
      $flowgraph node append highlevel program simhls
      $flowgraph node append highlevel program_args ""

      # Notice alternative are just listed in a Tcl list.
      $flowgraph node append logic mandatory_inputs \
	[list [list ../highlevel/$dsn.v [list ../highlevel/$dsn.lef $dsn.lef]] \
	{$dsn.v $dsn.lef}]
      $flowgraph node append logic optional_inputs $dsn.ldo
      $flowgraph node append logic outputs output/$dsn.v
      $flowgraph node append logic program simlogic
      $flowgraph node append logic program_args ""

      # Now the cut program
      $flowgraph node append cut program simcut
      $flowgraph node append cut program_args "-cuts $num_parts"
      $flowgraph node append cut optional_inputs $dsn.cdo

      # Now the floorplan program
      $flowgraph node append floorplan program simfloorplan
      $flowgraph node append floorplan program_args "-cuts $num_parts"
      $flowgraph node append cut optional_inputs $dsn.cdo
      $flowgraph node append floorplan optional_inputs $dsn.fdo

      # Now the assembly program
      $flowgraph node append assembly program simassembly
      $flowgraph node append assembly program_args "-cuts $num_parts"
      $flowgraph node append assembly optional_inputs $dsn.ado

      # Now the metalfill program
      $flowgraph node append metalfill program simfill
      $flowgraph node append metalfill program_args ""
      $flowgraph node append metalfill optional_inputs $dsn.mdo

    }

    proc subflow_init {dsn num_cuts flow} {

      ###################################################################
      # Set up environment variables to enable execution.
      ###################################################################
      global env
      set utdtools $env(UTDTOOLS)
      set routine "::utdtools::subflow_init"

      package require struct::graph 2.4
      set flowgraph [::struct::graph flowgraph]

      # How we pass user data to execute_pgm
      $flowgraph set utdtools $utdtools
      $flowgraph set xterm_args "-sb -sl 5000 -geometry 140x70+80+40"

      if {$flow != "default"} {
	utdmsg errmsg $routine "user defined flows not implemented yet\n"
	return ;
      }

      simple_subflow $flowgraph $dsn

      # A subflow works in a dsn directory
      cd $dsn

      run $flowgraph $dsn

      exit 0

    }

    proc simple_subflow {flowgraph dsn} {

      set phases "place cts groute droute"

      foreach phase $phases {
	set nodename [$flowgraph node insert $phase]
	$flowgraph node append $nodename directory $phase
      }

      # Name a special name for the start of the graph
      $flowgraph node insert start

      # Linear flow for now
      $flowgraph arc insert start place
      $flowgraph arc insert place cts
      $flowgraph arc insert cts groute
      $flowgraph arc insert groute droute

      # Now the place program
      $flowgraph node append place program simplace
      $flowgraph node append place program_args ""
      $flowgraph node append place optional_inputs $dsn.pdo

      # Now the cts program
      $flowgraph node append cts program simcts
      $flowgraph node append cts program_args ""
      $flowgraph node append cts optional_inputs $dsn.tdo

      # Now the groute program
      $flowgraph node append groute program simgroute
      $flowgraph node append groute program_args ""
      $flowgraph node append groute optional_inputs $dsn.gdo

      # Now the droute program
      $flowgraph node append droute program simdroute
      $flowgraph node append droute program_args ""
      $flowgraph node append droute optional_inputs $dsn.ddo

    }

    proc set_program_path {step path} {
      variable flowgraphS
      if {$flowgraphS == ""} {
	return ;
      }
      if {[catch {$flowgraphS node set $step program_path $path} msg]} {
	utdmsg errmsg set_program_path "we got the following msg:$msg\n"
      }
    }


  }
}
