
###################################################################
# Set up environment variables for various options.
###################################################################

# These two are initialized for you!
set routine grand.do

# Read in the user's design settings
source grand.init

# This is to make the operation OS independent.
set oros [file join $::openroad::rootdirS bin oros]
set rootdir $::openroad::rootdirS
set dsn $::openroad::designNameS

ormsg imsg $routine "openroad is $rootdir\n"
ormsg imsg $routine "design is $dsn\n"
set opts "-v"


# For now use the half flow.   When we put in YoSys it goes to FULL 
# get rid of -nologicsynth option.
set newdir [::openroad::flow::init $dsn $::openroad::numPartitionS default]


# The residence of the flow file. 
set flowfile [file join $rootdir tcl flow flow.do]

# Build the necessary do files.   Note we are going to override the defaults
# LEF file name to osu035.lef and library file to osu035.lib

set scriptdir [file join $rootdir scripts flow]

# ####################   LOGIC PROGRAM ############################
::openroad::flow::set_program_path logic [file join $scriptdir logic]

# ####################   CUT PROGRAM ############################
::openroad::flow::set_program_path cut [file join $scriptdir twcut]

# ####################   FLOORPLAN PROGRAM ############################
::openroad::flow::set_program_path floorplan [file join $scriptdir twfloorplan]

# ####################   PLACE PROGRAM ############################
::openroad::flow::set_program_path place [file join $scriptdir twplace]

# ####################   CTS PROGRAM ############################
::openroad::flow::set_program_path cts [file join $scriptdir twcts]

# ####################   GLOBAL ROUTING PROGRAM ############################
::openroad::flow::set_program_path groute [file join $scriptdir twgrouter]

# ####################   DETAILED ROUTING PROGRAM ############################
::openroad::flow::set_program_path droute [file join $scriptdir twdrouter]

# ####################   ASSEMBLY PROGRAM ############################
::openroad::flow::set_program_path assembly [file join $scriptdir twassemble]

# ####################   METAL FILL PROGRAM ############################
::openroad::flow::set_program_path metalfill [file join $scriptdir twmetalfill]

# ####################   FINAL TRANSLATE OUTPUT PROGRAM ############################
::openroad::flow::set_program_path final [file join $scriptdir twfinal]

cd openroad

# Just run in the current shell
::openroad::flow::run $::openroad::flow::flowgraphS $dsn


exit 0
