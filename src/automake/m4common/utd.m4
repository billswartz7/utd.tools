#------------------------------------------------------------------------
# UTD_ENABLE_THREADS --
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

AC_DEFUN([UTD_ENABLE_THREADS], [
    AC_MSG_CHECKING([whether to build libraries with thread support])
    AC_ARG_ENABLE(threads,
	AC_HELP_STRING([--enable-threads],
	    [build libraries with threads (default: off)]),
	[utdtools_ok=$enableval], [utdtools_ok=no])

    if test "${enable_threads+set}" = set; then
	enableval="$enable_threads"
	utdtools_ok=$enableval
    else
	utdtools_ok=no
    fi

    if test "$utdtools_ok" = "yes" ; then
	AC_MSG_RESULT([threads enabled])
	UTDTOOLS_THREAD_BUILD="--enable-threads"
    else
	AC_MSG_RESULT([threads disabled])
	UTDTOOLS_THREAD_BUILD="--disable-threads"
    fi
    AC_SUBST(UTDTOOLS_THREAD_BUILD)
])


AC_DEFUN([UTD_ENABLE_SHARED], [
    AC_MSG_CHECKING([how to build libraries])
    AC_ARG_ENABLE(shared,
	AC_HELP_STRING([--enable-shared],
	    [build and link with shared libraries (default: on)]),
	[utdtools_ok=$enableval], [utdtools_ok=yes])

    if test "${enable_shared+set}" = set; then
	enableval="$enable_shared"
	utdtools_ok=$enableval
    else
	utdtools_ok=yes
    fi

    if test "$utdtools_ok" = "yes" ; then
	AC_MSG_RESULT([shared])
    else
	AC_MSG_RESULT([static])
	AC_DEFINE(UTDTOOLS_STATIC_BUILD, 1, [Is this a static build?])
    fi
])

#------------------------------------------------------------------------
# UTD_ENABLE_AUTOTOOLS --
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

AC_DEFUN([UTD_ENABLE_AUTOTOOLS], [
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

AC_DEFUN([UTD_ENABLE_GRAPHICS], [
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
	AC_DEFINE(UTDTOOLS_GRAPHICS, 1, [Is this a graphics build?])
	AC_MSG_RESULT([yes])
	TEA_PATH_TKCONFIG
	TEA_LOAD_TKCONFIG
	AC_PATH_XTRA
    else
	AC_MSG_RESULT([no])
	UTDTOOLSGUI_DISABLE="1"
    fi
    AC_SUBST(UTDTOOLSGUI_DISABLE)
])

AC_DEFUN([UTD_MAKE_TIMESTAMP], [
    AC_MSG_CHECKING([for timestamp])
    AC_ARG_ENABLE(graphics,
	AC_HELP_STRING([--enable-timestamp],
	    [create a timestamp file to tell user build data (default: on)]),
	[utd_make_timestamp_ok=$enableval], [utd_make_timestamp_ok=yes])

    if test "${enable_utd_make_timestamp+set}" = set; then
	enableval="$enable_utd_make_timestamp"
	utd_make_timestamp_ok=$enableval
    else
	utd_make_timestamp_ok=yes
    fi

    if test "$utd_make_timestamp_ok" = "yes" ; then
	AC_MSG_RESULT([yes])
	${UTDTOOLS}/bin/make_timestamp
    else
	AC_MSG_RESULT([no])
    fi
])


#------------------------------------------------------------------------
# UTD_CHECK_ENVIRONMENT --
#
#	Makes sure UTDTOOLS is defined.
#
# Arguments:
#	none
#
# Results: exit if variable tests fail.
#
#------------------------------------------------------------------------
AC_DEFUN([UTD_CHECK_ENVIRONMENT], [
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
	echo "Please go to the UTD Tools root directory and source either"
	echo "setenv.sh or setenv.csh depending on your shell."
	echo " "
	exit 1
    fi

    if test "${UTDTOOLSOS+set}" = set; then
	utdtools_ok=yes
    else
	utdtools_ok=no
    fi

    if test "$utdtools_ok" = "no" ; then
	echo " "
	echo "ERROR: UTDTOOLSOS environment variable not defined."
	echo "Can not continue.  This is a necessary auxiliary variable."
	echo "Please go to the UTD Tools root directory and source either"
	echo "setenv.sh or setenv.csh depending on your shell to set it."
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
    else
	echo " "
    fi

])


#------------------------------------------------------------------------
# UTD_ENABLE_DEBUG --
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
#------------------------------------------------------------------------
AC_DEFUN([UTD_ENABLE_DEBUG], [
    AC_MSG_CHECKING([whether to force CFLAGS and CXXFLAGS to -g])
    AC_ARG_ENABLE(debug,
	AC_HELP_STRING([--enable-debug],
	    [enable debug (default: off)]),
	[utdtools_ok=$enableval], [utdtools_ok=no])

    if test "$utdtools_ok" = "yes" ; then
	AC_MSG_RESULT([debug enabled])
	UTDTOOLS_DEBUG_BUILD="CFLAGS=-g CXXFLAGS=-g"
    else
	AC_MSG_RESULT([threads disabled])
	UTDTOOLS_DEBUG_BUILD=""
    fi
    AC_SUBST(UTDTOOLS_DEBUG_BUILD)
])

#------------------------------------------------------------------------
# UTD_ROOT_ENV --
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
#		--with-buildroot=value
#
#	If not set, given sets it to UTDTOOLS
#------------------------------------------------------------------------

AC_DEFUN([UTD_ROOT_ENV], [
    AC_MSG_CHECKING([whether to override UTDTOOLS root environment variable])
    AC_ARG_WITH(buildroot,
	AC_HELP_STRING([--with-buildroot],
	    [override the build root environment variable (default: none)]),
	with_buildroot="${withval}")

    if test x"${with_buildroot}" != x ; then
	UTDTOOLS_ROOT_ENV_VARIABLE="${with_buildroot}"
    else
	UTDTOOLS_ROOT_ENV_VARIABLE="UTDTOOLS"
    fi
    export UTDTOOLS_ROOT_ENV_VARIABLE
    AC_MSG_RESULT([now : ${UTDTOOLS_ROOT_ENV_VARIABLE}])
    AC_SUBST(UTDTOOLS_ROOT_ENV_VARIABLE)
])

#------------------------------------------------------------------------
# UTD_BUILD_ENV --
#
#	Allows the setting of a build environment variable from the
#	command line so Tcl can be called recursively from other
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
#	If not set, given sets it to TCL
#------------------------------------------------------------------------

AC_DEFUN([UTD_BUILD_ENV], [
    AC_MSG_CHECKING([whether to override TCL_LIBRARY environment variable])
    AC_ARG_WITH(buildenv,
	AC_HELP_STRING([--with-buildenv],
	    [override the build environment variable (default: UTDTOOLSGUI)]),
	with_buildenv="${withval}")

    if test x"${with_buildenv}" != x ; then
	UTDTOOLS_BUILD_ENV_VARIABLE="${with_buildenv}"
	UTDTOOLS_BUILD_LC_ENV_VARIABLE=`echo ${UTDTOOLS_BUILD_ENV_VARIABLE} | tr A-Z a-z`
    else
	UTDTOOLS_BUILD_ENV_VARIABLE="UTDTOOLSGUI"
	UTDTOOLS_BUILD_LC_ENV_VARIABLE="common"
    fi
    export UTDTOOLS_BUILD_ENV_VARIABLE
    UTDTOOLS_BUILD_ENV_SUFFIX=`echo ${UTDTOOLS_BUILD_ENV_VARIABLE}_ | tr A-Z a-z`
    export UTDTOOLS_BUILD_ENV_SUFFIX
    export UTDTOOLS_BUILD_LC_ENV_VARIABLE
    AC_MSG_RESULT([now: ${UTDTOOLS_BUILD_ENV_VARIABLE}])
    AC_SUBST(UTDTOOLS_BUILD_ENV_VARIABLE)
    AC_SUBST(UTDTOOLS_BUILD_LC_ENV_VARIABLE)
    AC_SUBST(UTDTOOLS_BUILD_ENV_SUFFIX)
])


#------------------------------------------------------------------------
# UTD_INCPATH
#
#	Set the UTDTOOLS include path.
#
# Arguments:
#	none
#
# Results:
#
#	Outputs some directions
#------------------------------------------------------------------------
AC_DEFUN([UTD_INCPATH], [

      echo "Calculating UTD_INCLUDE_PATH..."
      if test "x${UTDTOOLS_ROOT_ENV_VARIABLE}" = "xUTDTOOLS" ; then
	UTDTOOLS_INCLUDE_PATH="${UTDTOOLS}/include"
      else
	UTDTOOLS_INCLUDE_PATH="${UTDTOOLS_ROOT_ENV_VARIABLE}/include"
      fi
      echo "Path is set to $UTDTOOLS_INCLUDE_PATH"
      AC_SUBST(UTDTOOLS_INCLUDE_PATH)
])

#------------------------------------------------------------------------
# UTD_ENABLE_MEMDEBUG --
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
#		UTDTOOLS_MEMDEBUG_BUILD
#		MEMDEBUG
#------------------------------------------------------------------------
AC_DEFUN([UTD_ENABLE_MEMDEBUG], [
    AC_MSG_CHECKING([whether to enable memory debug code])
    AC_ARG_ENABLE(memdebug,
	AC_HELP_STRING([--enable-memdebug],
	    [enable memory debug code (default: off)]),
	[utdtoolsmemdebug_ok=$enableval], [utdtoolsmemdebug_ok=no])

    if test "${enable_memdebug+set}" = set; then
	enableval="$enable_memdebug"
	utdtoolsmemdebug_ok=$enableval
    else
	utdtoolsmemdebug_ok=no
    fi

    if test "$utdtoolsmemdebug_ok" = "yes" ; then
	UTDTOOLS_MEM_DEBUG="--enable-memdebug"
	UTDMEM_DEBUG="1"
	AC_DEFINE(UTDMEM_DEBUG, 1, [memory debug] )
	AC_MSG_RESULT([memory debug enabled])
    else
	UTDTOOLS_MEM_DEBUG=
	UTDMEM_DEBUG=
	AC_MSG_RESULT([memory debug disabled])
    fi
    AC_SUBST(UTDTOOLS_MEM_DEBUG)
    AC_SUBST(UTDMEM_DEBUG)
])

AC_DEFUN([UTD_CONFIG_COPY], [

      cp src/utdconfig.h ${UTDTOOLS_INCLUDE_PATH}/utd
])
