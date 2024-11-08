# The initialization of the UTDTOOLS variables

set dir_flag = 0
if $1 != "" then
    if( $1 == "help" || $1 == "-help" || $1 == "--help" ) then
      echo ""
      echo "UTDtools environment setup help (CShells)"
      echo ""
      echo "source setenv.csh : sets the UTD tools environment variables"
      echo "                    based on current working directory."
      echo "source setenv.csh <directory> : sets the UTD tools environment"
      echo "                    variables based on the specified directory."
      echo ""
      exit 0
    else
      set new_directory = $1
      echo ""
      set old_directory = `pwd`
      cd $new_directory
      set dir_flag = 1
      echo "Changing directory to `pwd` before assigning variables"
      echo ""
    endif
endif
# "$RCSfile: setenv.csh,v $ $Revision: 1.1 $ $Date: 2018/06/30 02:10:49 $"

echo " "
echo "Initializing the UTD Tools environment variables..."

# set UTD Tools environment variable.  This is a must.
# it must be the pathname of the root directory.
setenv cur_wd `pwd`
setenv UTDTOOLS `dirname $cur_wd`
setenv UTDTOOLSVERSION `basename $cur_wd`
unsetenv cur_wd

setenv PYTHON_NUM_RELEASE 3.8

# delete out any reference to ./utd.tools/bin in path.
set newpath = `echo $path | sed -e 's/[^ ]*utd.tools[^ ]*//g' `

# temporarily add UTDTOOLS directory to search path to find
# a user-supplied uname function residing in that directory.
set path = ( $UTDTOOLS/$UTDTOOLSVERSION/bin $newpath )
rehash

# determine the operating system name
# first see if uname command exists
uname >& /dev/null

if( $status != 0 ) then
    echo " "
    echo "WARNING: 'uname' system command does not exist in search path."
    echo "If multiple operating systems are desired,"
    echo "please edit the '.../bin/utduname' shell script."
    echo "Defaulting to unix..."
    echo " "
endif

setenv UTDTOOLSOS `$UTDTOOLS/$UTDTOOLSVERSION/bin/utduname`
setenv UTDPYTHONHOME $UTDTOOLS/$UTDTOOLSVERSION
setenv UTDPYTHONPATH ~/.local/lib/python${PYTHON_NUM_RELEASE}/site-packages:${UTDPYTHONHOME}/lib/python${PYTHON_NUM_RELEASE}/site-packages:${UTDPYTHONHOME}/lib/${UTDTOOLSOS}/python${PYTHON_NUM_RELEASE}/lib-dynload

# add utd tools binary to search path
# allows user to type in utd.tools command without full pathname.
# this is really an optional convenience.
set path = ( $UTDTOOLS/$UTDTOOLSVERSION/bin/$UTDTOOLSOS $path )

if( $UTDTOOLSOS == "HP-UX" ) then
  # Now we can set the LD_LIBRARY_PATH.
  set test = ${?SHLIB_PATH}
  if $test != 1 then

    setenv SHLIB_PATH ${UTDTOOLS}/${UTDTOOLSVERSION}/lib/${UTDTOOLSOS}

  else

    # delete out any reference to ./utd.tools/ in LD_LIBRARY_PATH.
    set newld = `echo $SHLIB_PATH | awk -F: 'BEGIN { first = 1 } { for( i = 1 ; i <= NF ; i++ ){ if( $i !~ /utd.tools/ ){ if( first ){ first = 0 ; } else { printf( ":" ) ; } printf( "%s", $i ) ; } } printf( "\n" ) ; }'`
    setenv SHLIB_PATH "${UTDTOOLS}/${UTDTOOLSVERSION}/lib/${UTDTOOLSOS}:$newld"
    unset newld
  endif
else if( $UTDTOOLSOS == "AIX" ) then
  # Now we can set the LIBPATH.
  set test = ${?LIBPATH}
  if $test != 1 then

    setenv LIBPATH ${UTDTOOLS}/${UTDTOOLSVERSION}/lib/${UTDTOOLSOS}

  else

    # delete out any reference to ./utd.tools/ in LIBPATH.
    set newld = `echo $LIBPATH | awk -F: 'BEGIN { first = 1 } { for( i = 1 ; i <= NF ; i++ ){ if( $i !~ /utd.tools/ ){ if( first ){ first = 0 ; } else { printf( ":" ) ; } printf( "%s", $i ) ; } } printf( "\n" ) ; }'`
    setenv LIBPATH "${UTDTOOLS}/${UTDTOOLSVERSION}/lib/${UTDTOOLSOS}:$newld"
    unset newld
  endif

else if( $UTDTOOLSOS == "Darwin" ) then
  # Now we can set the DYLD_LIBRARY_PATH.
  set test = ${?DYLD_LIBRARY_PATH}
  if $test != 1 then

    setenv DYLD_LIBRARY_PATH ${UTDTOOLS}/${UTDTOOLSVERSION}/lib/${UTDTOOLSOS}

  else

    # delete out any reference to ./utd.tools/ in LIBPATH.
    set newld = `echo $DYLD_LIBRARY_PATH | awk -F: 'BEGIN { first = 1 } { for( i = 1 ; i <= NF ; i++ ){ if( $i !~ /utd.tools/ ){ if( first ){ first = 0 ; } else { printf( ":" ) ; } printf( "%s", $i ) ; } } printf( "\n" ) ; }'`
    setenv DYLD_LIBRARY_PATH "${UTDTOOLS}/${UTDTOOLSVERSION}/lib/${UTDTOOLSOS}:$newld"
    unset newld
  endif

else 
  # Now we can set the LD_LIBRARY_PATH.
  set test = ${?LD_LIBRARY_PATH}
  if $test != 1 then

    setenv LD_LIBRARY_PATH ${UTDTOOLS}/${UTDTOOLSVERSION}/lib/${UTDTOOLSOS}

  else

  # delete out any reference to ./utd.tools/ in LD_LIBRARY_PATH.
    set newld = `echo $LD_LIBRARY_PATH | awk -F: 'BEGIN { first = 1 } { for( i = 1 ; i <= NF ; i++ ){ if( $i !~ /utd.tools/ ){ if( first ){ first = 0 ; } else { printf( ":" ) ; } printf( "%s", $i ) ; } } printf( "\n" ) ; }'`
    setenv LD_LIBRARY_PATH "${UTDTOOLS}/${UTDTOOLSVERSION}/lib/${UTDTOOLSOS}:$newld"
    unset newld

  endif
endif

set test = ${?DISPLAY}
if $test != 1 then

# this is the default for the Xserver on local node.
# user should change as appropriate.
    setenv DISPLAY :0
endif

echo "UTDTOOLS has been set to $UTDTOOLS"
echo "UTDTOOLSOS has been set to $UTDTOOLSOS"
echo "UTDTOOLSVERSION has been set to $UTDTOOLSVERSION"
echo "UTDPYTHONHOME has been set to $UTDPYTHONHOME"
echo "UTDPYTHONPATH has been set to $UTDPYTHONPATH"
echo "DISPLAY has been set to $DISPLAY"
if( $UTDTOOLSOS == "HP-UX" ) then
  echo "SHLIB_PATH has been set to:"
  echo "    $SHLIB_PATH"
else if( $UTDTOOLSOS == "AIX" ) then
  echo "LIBPATH has been set to:"
  echo "    $LIBPATH"
else if( $UTDTOOLSOS == "Darwin" ) then
  echo "DYLD_LIBRARY_PATH has been set to:"
  echo "    $DYLD_LIBRARY_PATH"
else
  echo "LD_LIBRARY_PATH has been set to:"
  echo "    $LD_LIBRARY_PATH"
endif
echo "The search path now includes:"
echo " "
echo "    $UTDTOOLS/$UTDTOOLSVERSION/bin"
echo "and"
echo "    $UTDTOOLS/$UTDTOOLSVERSION/bin/$UTDTOOLSOS"
echo " "

unsetenv UTDTOOLSINSTALLDIR

if $dir_flag == "1" then
  echo "setting directory back to $old_directory"
  cd $old_directory
  echo ""
endif
