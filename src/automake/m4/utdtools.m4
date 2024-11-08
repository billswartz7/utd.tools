#------------------------------------------------------------------------
# UTDTOOLS_CHECK_ENVIRONMENT --
#
#	Makes sure UTDTOOLS is defined.
#
# Arguments:
#	none
#
# Results:
#
#
#	Sets the following vars:
#		UTDTOOLS_DEBUG_BUILD : "CFLAGS=-g CXXFLAGS=-g"
#		                     : ""
#------------------------------------------------------------------------
AC_DEFUN([UTDTOOLS_CHECK_ENVIRONMENT], [
    AC_MSG_CHECKING([whether to see if UTDTOOLS is set])

    if test "${UTDTOOLS+set}" = set; then
	utdtools_ok=yes
    else
	utdtools_ok=no
    fi

    if test "$utdtools_ok" = "yes" ; then
	AC_MSG_RESULT([good: ${UTDTOOLS}])
    else
	AC_MSG_RESULT([no])
	echo " "
	echo "ERROR: UTDTOOLS environment variable not defined."
	echo "Can not continue.  Please set it to UTDTOOLS root pathname."
	echo "Please go to the UTDTOOLS source directory and source either"
	echo "buildenv.sh or buildenv.csh depending on your shell."
	echo " "
	exit 1
    fi

    if test "${UTDTOOLS+set}" = set; then
	utdtools_ok=yes
    else
	utdtools_ok=no
    fi

    if test "$utdtools_ok" = "no" ; then
	echo " "
	echo "ERROR: UTDTOOLS environment variable not defined."
	echo "Cannot continue.  This is a necessary auxiliary variable."
	echo "Please go to the UTDTOOLS source directory and source either"
	echo "buildenv.sh or buildenv.csh depending on your shell to set it."
	echo " "
	exit 1
    fi

    AC_MSG_CHECKING([whether to see if UTDTOOLSINSTALL is set])
    if test "${UTDTOOLSINSTALLDIR+set}" = set; then
	utdtoolsinstalldir_ok=yes
    else
	utdtoolsinstalldir_ok=no
    fi

    if test "$utdtoolsinstalldir_ok" = "yes" ; then
	AC_MSG_RESULT([good: ${UTDTOOLSINSTALLDIR}])
    else
	AC_MSG_RESULT([no])
	echo " "
	echo "ERROR: UTDTOOLSINSTALLDIR environment variable not defined."
	echo "Cannot continue.  Please set it to UTDTOOLSINSTALLDIR root pathname."
	echo "Please go to the UTDTOOLS source directory and source either"
	echo "buildenv.sh or buildenv.csh depending on your shell."
	echo " "
	exit 1
    fi

    if test "${UTDTOOLSINSTALLDIR+set}" = set; then
	utdtoolsinstalldir_ok=yes
    else
	utdtoolsinstalldir_ok=no
    fi

    if test "$utdtools_ok" = "no" ; then
	echo " "
	echo "ERROR: UTDTOOLS environment variable not defined."
	echo "Cannot continue.  This is a necessary auxiliary variable."
	echo "Please go to the UTDTOOLS source directory and source either"
	echo "buildenv.sh or buildenv.csh depending on your shell to set it."
	echo " "
	exit 1
    fi

    if test -z "${CXX}"; then
	utdtools_ok=no
    else
	utdtools_ok=yes
    fi

    if test "$utdtools_ok" = "no" ; then
	echo " "
	echo "ERROR: Required C++ Compiler not found."
	echo "Can not continue.  Please install a C++ compiler."
	echo " "
	exit 1
    fi

    if test "${libdir+set}" = set; then
	if test "$libdir" = '${exec_prefix}/lib' ; then
	  UTDTOOLS_LIB_DIR="\${exec_prefix}/lib/${UTDTOOLSOS}"
	else
	  UTDTOOLS_LIB_DIR="$libdir"
	fi
	AC_SUBST(UTDTOOLS_LIB_DIR)
    fi

    if test "${bindir+set}" = set; then
	if test "$bindir" = '${exec_prefix}/bin' ; then
	  UTDTOOLS_BIN_DIR="\${exec_prefix}/bin/${UTDTOOLSOS}"
	else
	  UTDTOOLS_BIN_DIR="$bindir"
	fi
	AC_SUBST(UTDTOOLS_BIN_DIR)
    fi

])
#------------------------------------------------------------------------
# UTDTOOLS_ENABLE_THREADS --
#
#	Allows the building of threaded libraries
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-threads=yes|no
#
#	Sets the following vars:
#		UTDTOOLS_THREAD_BUILD	Value of 1 or 0
#------------------------------------------------------------------------

AC_DEFUN([UTDTOOLS_ENABLE_THREADS], [
    AC_MSG_CHECKING([whether to build libraries with thread support])
    AC_ARG_ENABLE(threads,
	AC_HELP_STRING([--enable-threads],
	    [build libraries with threads (default: off)]),
	[utdtoolslib_ok=$enableval], [utdtoolslib_ok=no])

    if test "${enable_threads+set}" = set; then
	enableval="$enable_threads"
	utdtoolslib_ok=$enableval
    else
	utdtoolslib_ok=no
    fi

    if test "$utdtoolslib_ok" = "yes" ; then
	AC_MSG_RESULT([threads enabled])
	UTDTOOLS_THREAD_BUILD="--enable-threads"
    else
	AC_MSG_RESULT([threads disabled])
	UTDTOOLS_THREAD_BUILD="--disable-threads"
    fi
    AC_SUBST(UTDTOOLS_THREAD_BUILD)
])


AC_DEFUN([UTDTOOLS_ENABLE_SHARED], [
    AC_MSG_CHECKING([how to build libraries])
    AC_ARG_ENABLE(shared,
	AC_HELP_STRING([--enable-shared],
	    [build and link with shared libraries (default: on)]),
	[utdtoolslib_ok=$enableval], [utdtoolslib_ok=yes])

    if test "${enable_shared+set}" = set; then
	enableval="$enable_shared"
	utdtoolslib_ok=$enableval
    else
	utdtoolslib_ok=no
    fi

    if test "$utdtoolslib_ok" = "yes" ; then
	AC_MSG_RESULT([shared])
	UTDTOOLS_SHARED_BUILD="--enable-shared"
	UTDTOOLS_TCL_LIB="-L\$(UTDTOOLS)/lib/`utduname` -lopen_tcl8.6"
    else
	AC_MSG_RESULT([static])
	UTDTOOLS_SHARED_BUILD="--disable-shared"
	UTDTOOLS_TCL_LIB="\$(UTDTOOLS)/lib/`utduname`/libopen_tcl8.6.a"
    fi
    AC_SUBST(UTDTOOLS_SHARED_BUILD)
])

#------------------------------------------------------------------------
# UTDTOOLS_ENABLE_DEBUG --
#
#	Allows us to build debug version of the system
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-debug=yes|no
#
#	Sets the following vars:
#		UTDTOOLS_DEBUG_BUILD : "CFLAGS=-g CXXFLAGS=-g"
#		                     : ""
#	We need to create both --enable-debug and --enable-symbols	                     
#------------------------------------------------------------------------
AC_DEFUN([UTDTOOLS_ENABLE_DEBUG], [
    AC_MSG_CHECKING([whether to force CFLAGS and CXXFLAGS to -g])
    AC_ARG_ENABLE(debug,
	AC_HELP_STRING([--enable-debug],
	    [enable debug (default: off)]),
	[utdtoolslib_ok=$enableval], [utdtoolslib_ok=no])

    if test "${enable_debug+set}" = set; then
	enableval="$enable_debug"
	utdtoolslib_ok=$enableval
    else
	utdtoolslib_ok=no
    fi

    if test "$utdtoolslib_ok" = "yes" ; then
	AC_MSG_RESULT([debug enabled])
	UTDTOOLS_DEBUG_BUILD="CFLAGS=-g CXXFLAGS=-g"
	UTDTOOLS_DEBUG_OPTS="--enable-debug"
	UTDTOOLS_DEBUG_OPTS2="--enable-symbols"
    else
	AC_MSG_RESULT([debug disabled])
	UTDTOOLS_DEBUG_BUILD=""
	UTDTOOLS_DEBUG_OPTS=""
	UTDTOOLS_DEBUG_OPTS2=""
    fi
    AC_SUBST(UTDTOOLS_DEBUG_BUILD)
    AC_SUBST(UTDTOOLS_DEBUG_OPTS)
    AC_SUBST(UTDTOOLS_DEBUG_OPTS2)
])


#------------------------------------------------------------------------
# UTDTOOLS_MESSAGES
#
#	Give the user some directions
#
# Arguments:
#	none
#
# Results:
#
#	Outputs some directions
#------------------------------------------------------------------------
AC_DEFUN([UTDTOOLS_MESSAGES], [

      echo " "
      echo "Now enter:"
      echo " "
      echo "   make "
      echo " "
      echo "to configure, build, and install the UTDTOOLS libraries,"
      echo "and suite of programs and tools."
      echo " "
      echo " "
])


#------------------------------------------------------------------------
# UTDTOOLS_BUILD_ENV --
#
#	Allows the setting of a build environment variable from the
#	command line so UTDTOOLS can be called recursively from other
#	repositories
#
# Arguments:
#	The name of the environment variable
#
# Results:
#
#	Adds the following arguments to configure:
#		--with-buildenv=value
#
#	If not set, given sets it to UTDTOOLS
#------------------------------------------------------------------------

AC_DEFUN([UTDTOOLS_BUILD_ENV], [
    AC_MSG_CHECKING([whether to override UTDTOOLS environment variable])
    AC_ARG_WITH(buildenv,
	AC_HELP_STRING([--with-buildenv],
	    [override the build environment variable (default: UTDTOOLS)]),
	with_buildenv="${withval}")

    if test x"${with_buildenv}" != x ; then
	UTDTOOLS_BUILD_ENV_VARIABLE="${with_buildenv}"
    else
	UTDTOOLS_BUILD_ENV_VARIABLE="UTDTOOLS"
    fi
    AC_MSG_RESULT([now: ${UTDTOOLS_BUILD_ENV_VARIABLE}])
    AC_SUBST(UTDTOOLS_BUILD_ENV_VARIABLE)
])


#------------------------------------------------------------------------
# UTDTOOLS_ENABLE_AUTOTOOLS --
#
#	Allows the enabling and disabling of autotools
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-autotools=yes|no
#
#	Sets the following vars:
#		ACLOCAL
#		AUTOCONF
#		AUTOHEADER
#		AUTOMAKE
#		MAKEINFO
#------------------------------------------------------------------------

AC_DEFUN([UTDTOOLS_ENABLE_AUTOTOOLS], [
    AC_MSG_CHECKING([whether to use autotools to regenerate Makefiles])
    AC_ARG_ENABLE(autotools,
	AC_HELP_STRING([--enable-autotools],
	    [rebuild Makefiles with autotools (default: off)]),
	[utdautotools_ok=$enableval], [utdautotools_ok=no])

    if test "${enable_autotools+set}" = set; then
	enableval="$enable_autotools"
	utdautotools_ok=$enableval
    else
	utdautotools_ok=no
    fi

    if test "$utdautotools_ok" = "yes" ; then
	AC_MSG_RESULT([autotools enabled])
	UTDTOOLS_AUTOTOOLS="--enable-autotools"
    else
	AC_MSG_RESULT([autotools disabled])
	ACLOCAL="echo no aclocal mode"
	AUTOCONF="echo no autoconf mode"
	AUTOHEADER="echo no autoheader mode"
	AUTOMAKE="echo no automake mode"
	MAKEINFO="echo no makeinfo mode"
	UTDTOOLS_AUTOTOOLS="--disable-autotools"
    fi
    AC_SUBST(ACLOCAL)
    AC_SUBST(AUTOCONF)
    AC_SUBST(AUTOHEADER)
    AC_SUBST(AUTOMAKE)
    AC_SUBST(MAKEINFO)
    AC_SUBST(UTDTOOLS_AUTOTOOLS)
])

AC_DEFUN([UTDTOOLS_ENABLE_GRAPHICS], [
    AC_MSG_CHECKING([for graphical interface])
    AC_ARG_ENABLE(graphics,
	AC_HELP_STRING([--enable-graphics],
	    [build and link with UTD graphics libraries (default: on)]),
	[utdgraphics_ok=$enableval], [utdgraphics_ok=yes])

    if test "${enable_graphics+set}" = set; then
	enableval="$enable_graphics"
	utdgraphics_ok=$enableval
    else
	utdgraphics_ok=yes
    fi

    if test "$utdgraphics_ok" = "yes" ; then
	AC_MSG_RESULT([yes])
	UTDTOOLS_GRAPHICS_BUILD="--enable-graphics"
    else
	AC_MSG_RESULT([no])
	UTDTOOLS_GRAPHICS_BUILD="--disable-graphics"
    fi
    AC_SUBST(UTDTOOLS_GRAPHICS_BUILD)
])

#------------------------------------------------------------------------
# UTDTOOLS_ENABLE_MEMDEBUG --
#
#	Allows us to conditionally build the memory debug version of the library
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-memdebug=yes|no
#
#	Sets the following vars:
#		UTDTOOLS_MEM_DEBUG
#------------------------------------------------------------------------
AC_DEFUN([UTDTOOLS_ENABLE_MEMDEBUG], [
    AC_MSG_CHECKING([whether to enable memory debug code])
    AC_ARG_ENABLE(memdebug,
	AC_HELP_STRING([--enable-memdebug],
	    [enable memory debug code (default: off)]),
	[utdlibmemdebug_ok=$enableval], [utdlibmemdebug_ok=no])

    if test "${enable_memdebug+set}" = set; then
	enableval="$enable_memdebug"
	utdlibmemdebug_ok=$enableval
    else
	utdlibmemdebug_ok=no
    fi

    if test "$utdlibmemdebug_ok" = "yes" ; then
	UTDTOOLS_MEM_DEBUG="--enable-memdebug"
	AC_MSG_RESULT([memory debug enabled])
    else
	UTDTOOLS_MEM_DEBUG=
	AC_MSG_RESULT([memory debug disabled])
    fi
    AC_SUBST(UTDTOOLS_MEM_DEBUG)
])
