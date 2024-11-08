
###################################################################
# Set up environment variables for various options.
###################################################################

# These two are initialized for you!
set routine grand.do

# Read in the user's design settings
if {[file exists grand.init]} {
  utdmsg imsg $routine "sourcing grand.init...\n"
  source grand.init
} else {
  puts stderr "wd: [pwd]"
  utdmsg errmsg $routine "grand.init file not found.  Fatal!\n"
  exit 1
}

# This is to make the operation OS independent.
set utdos [file join $::utdtools::rootdirS bin utdos]
set rootdir $::utdtools::rootdirS
set dsn $::utdtools::designNameS

utdmsg imsg $routine "utdtools is $rootdir\n"
utdmsg imsg $routine "design is $dsn\n"
set opts "-v"


set newdir [::utdtools::flow::init $dsn $::utdtools::numPartitionS default]

# The residence of the flow file. 
set flowfile [file join $rootdir tcl flow flow.do]

# Build the necessary do files.   Note we are going to override the defaults

set scriptdir [file join $rootdir scripts flow]

# ####################   LOGIC PROGRAM ############################
::utdtools::flow::set_program_path logic [file join $scriptdir logic]

# ####################   CUT PROGRAM ############################
::utdtools::flow::set_program_path cut [file join $scriptdir twcut]

# ####################   FLOORPLAN PROGRAM ############################
::utdtools::flow::set_program_path floorplan [file join $scriptdir twfloorplan]

# ####################   PLACE PROGRAM ############################
::utdtools::flow::set_program_path place [file join $scriptdir twplace]

# ####################   CTS PROGRAM ############################
::utdtools::flow::set_program_path cts [file join $scriptdir twcts]

# ####################   GLOBAL ROUTING PROGRAM ############################
::utdtools::flow::set_program_path groute [file join $scriptdir twgrouter]

# ####################   DETAILED ROUTING PROGRAM ############################
::utdtools::flow::set_program_path droute [file join $scriptdir twdrouter]

# ####################   ASSEMBLY PROGRAM ############################
::utdtools::flow::set_program_path assembly [file join $scriptdir twassemble]

# ####################   METAL FILL PROGRAM ############################
::utdtools::flow::set_program_path metalfill [file join $scriptdir twmetalfill]

# ####################   FINAL TRANSLATE OUTPUT PROGRAM ############################
::utdtools::flow::set_program_path final [file join $scriptdir twfinal]

cd utdtools

# Just run in the current shell
::utdtools::flow::run $::utdtools::flow::flowgraphS $dsn


exit 0
