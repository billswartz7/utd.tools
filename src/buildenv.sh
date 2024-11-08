#!/bin/sh -xv
# The initialization of the utdtools variables
# "$RCSfile: setenv.sh,v $ $Revision: 1.1 $ $Date: 2018/06/30 02:10:53 $"

# This code below shouldn't work but seems to work on all Bourne and
# Bash shells tests.  If you don't give any arguments other than this
# shell script, then $# is set to 1 and you get garbage arguments from
# possible previous invocation of some other script. However, if
# the user did pass extra arguments, then they are correctly passwd to
# the script.  So to make things work, we specifically look for keywords
# to enable the code which is why we look for help and utdcd which we
# hope is distinct enough from previous invocations of the shell so 
# we don't have conflicts. - WPS.
# 
dir_flag=0
if [ $# -ge 1 ] ; then
    if [ $1 = "help" -o $1 = "-help" -o $1 = "--help" ] ; then
      echo ""
      echo "UTD tools build environment setup help (Bourne/Bash Shells)"
      echo ""
      echo "source buildenv.sh : sets the UTD tools build environment variables"
      echo "                   based on current working directory."
      echo "source buildenv.sh utdcd <directory> : sets the UTD tools build environment"
      echo "                   variables based on the specified directory."
      echo ""
      return 0
    elif [ $1 = "utdcd" -a $# -ge 2 ] ; then
      new_directory=$2
      new_directory=$1
      echo ""
      old_directory=`pwd`
      cd $new_directory
      dir_flag=1
      echo "Changing directory to `pwd` before assigning variables"
      echo ""
    fi
fi

echo " "
echo "Initializing the UTD tools environment variables..."

# set utdtools environment variable.  This is a must.
# it must be the pathname of the root directory.
UTDTOOLS=`pwd`
PYTHON_NUM_RELEASE=3.8
UTDTOOLSVERSION=v1.0.0

# delete out any reference to ./utdtools/bin in path.
NEWPATH=`echo $PATH | awk -F: 'BEGIN { first = 1 } { for( i = 1 ; i <= NF ; i++ ){ if( $i !~ /utdtools/ ){ if( first ){ first = 0 ; } else { printf( ":" ) ; } printf( "%s", $i ) ; } } printf( "\n" ) ; }'`

# temporarily add UTDTOOLS/bin directory to search path to find
# a user-supplied uname function residing in that directory.
PATH=$UTDTOOLS/bin:$NEWPATH
unset NEWPATH

# determine the operating system name
# first see if uname command exists
# uname >& /dev/null || {
uname > /dev/null || {
  echo " " ;
  echo "WARNING: 'uname' system command does not exist in search path." ;
  echo "If multiple operating systems are desired," ;
  echo "please edit the './tools/bin/utduname' shell script." ;
  echo "Defaulting to unix..." ;
  echo " " ;
}

UTDTOOLSOS=`$UTDTOOLS/bin/utduname`
UTDTOOLSINSTALLDIR=`dirname $UTDTOOLS`
UTDPYTHONHOME=$UTDTOOLSINSTALLDIR/$UTDTOOLSVERSION
UTDPYTHONPATH=~/.local/lib/python${PYTHON_NUM_RELEASE}/site-packages:${UTDPYTHONHOME}/lib/python${PYTHON_NUM_RELEASE}/site-packages:${UTDPYTHONHOME}/lib/${UTDTOOLSOS}/python${PYTHON_NUM_RELEASE}/lib-dynload

# add utdtools binary to search path
# allows user to type in utdtools without full pathname.
# this is really an optional convenience.
PATH=$UTDTOOLS/bin/$UTDTOOLSOS:$PATH

DISPLAY=${DISPLAY=:0}

if [ $UTDTOOLSOS = "HP-UX" ] ; then
  NEWLD=`echo $SHLIB_PATH | awk -F: 'BEGIN { first = 1 } { for( i = 1 ; i <= NF ; i++ ){ if( $i !~ /utdtools/ ){ if( first ){ first = 0 ; } else { printf( ":" ) ; } printf( "%s", $i ) ; } } printf( "\n" ) ; }'`
  SHLIB_PATH="${UTDTOOLS}/libs:${UTDPYTHONHOME}/lib/${UTDTOOLSOS}:$NEWLD"
  unset NEWLD
elif [ $UTDTOOLSOS = "AIX" ] ; then
  NEWLD=`echo $LIBPATH | awk -F: 'BEGIN { first = 1 } { for( i = 1 ; i <= NF ; i++ ){ if( $i !~ /utdtools/ ){ if( first ){ first = 0 ; } else { printf( ":" ) ; } printf( "%s", $i ) ; } } printf( "\n" ) ; }'`
  LIBPATH="${UTDTOOLS}/libs:${UTDPYTHONHOME}/lib/${UTDTOOLSOS}:$NEWLD"
  unset NEWLD
elif [ $UTDTOOLSOS = "Darwin" ] ; then
  NEWLD=`echo $DYLD_LIBRARY_PATH | awk -F: 'BEGIN { first = 1 } { for( i = 1 ; i <= NF ; i++ ){ if( $i !~ /utdtools/ ){ if( first ){ first = 0 ; } else { printf( ":" ) ; } printf( "%s", $i ) ; } } printf( "\n" ) ; }'`
  DYLD_LIBRARY_PATH="${UTDTOOLS}/libs:${UTDPYTHONHOME}/lib/${UTDTOOLSOS}:$NEWLD"
  unset NEWLD
else
  NEWLD=`echo $LD_LIBRARY_PATH | awk -F: 'BEGIN { first = 1 } { for( i = 1 ; i <= NF ; i++ ){ if( $i !~ /utdtools/ ){ if( first ){ first = 0 ; } else { printf( ":" ) ; } printf( "%s", $i ) ; } } printf( "\n" ) ; }'`
  LD_LIBRARY_PATH="${UTDTOOLS}/libs:${UTDPYTHONHOME}/lib/${UTDTOOLSOS}:$NEWLD"
  unset NEWLD
fi

echo "UTDTOOLS has been set to $UTDTOOLS"
echo "UTDTOOLSOS has been set to $UTDTOOLSOS"
echo "UTDTOOLSINSTALLDIR has been set to $UTDTOOLSINSTALLDIR"
echo "UTDPYTHONHOME has been set to $UTDPYTHONHOME"
echo "UTDPYTHONPATH has been set to $UTDPYTHONPATH"
echo "DISPLAY has been set to $DISPLAY"
export PATH UTDTOOLS UTDTOOLSVERSION UTDTOOLSOS DISPLAY UTDTOOLSINSTALLDIR
export UTDPYTHONHOME UTDPYTHONPATH 
if [ $UTDTOOLSOS = "HP-UX" ] ; then
  echo "SHLIB_PATH has been set to:"
  echo "    $SHLIB_PATH"
  export SHLIB_PATH
elif [ $UTDTOOLSOS = "AIX" ] ; then
  echo "LIBPATH has been set to:"
  echo "    $LIBPATH"
  export LIBPATH
elif [ $UTDTOOLSOS = "Darwin" ] ; then
  echo "DYLD_LIBRARY_PATH has been set to:"
  echo "    $DYLD_LIBRARY_PATH"
  export DYLD_LIBRARY_PATH
else
  echo "LD_LIBRARY_PATH has been set to:"
  echo "    $LD_LIBRARY_PATH"
  export LD_LIBRARY_PATH
fi
echo "The search path now includes:"
echo " "
echo "    $UTDTOOLS/bin"
echo "and"
echo "    $UTDTOOLS/bin/$UTDTOOLSOS"
echo " "

if [ $dir_flag = "1" ] ; then
  echo "setting directory back to $old_directory"
  cd $old_directory
  echo ""
fi

if [ $UTDTOOLSOS = "Darwin" ] ; then
  echo "You might want to source the maczlib.sh file in the bin directory"
  echo "to setup proper variables on Mac." 
  echo ""
fi
