#------------------------------------------------------------------------
# UTD_CHECK_ENVIRONMENT --
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
	echo "Now run : "
	echo "   make config"
	echo " "
    fi

])
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
    AC_MSG_CHECKING([how to build our libraries])
    AC_ARG_ENABLE(shared,
	AC_HELP_STRING([--enable-shared],
	    [build and link with shared libraries (default: on)]),
	[utdtools_shared_ok=$enableval], [utdtools_shared_ok=yes])

    if test "$utdtools_shared_ok" = "yes" ; then
	AC_MSG_RESULT([shared])
	UTDTOOLS_SHARED_BUILD="--enable-shared"
	UTDTOOLS_TCL_LIB="-L\$(LIBDIR) -lutdtools_tcl8.6"
    else
	AC_MSG_RESULT([static])
	UTDTOOLS_SHARED_BUILD="--disable-shared"
	UTDTOOLS_TCL_LIB="\$(LIBDIR)/libutdtools_tcl8.6.a"
    fi
    AC_SUBST(UTDTOOLS_SHARED_BUILD)
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
	UTDLIB_AUTOTOOLS="--enable-autotools"
    else
	AC_MSG_RESULT([autotools disabled])
	ACLOCAL="echo no aclocal mode"
	AUTOCONF="echo no autoconf mode"
	AUTOHEADER="echo no autoheader mode"
	AUTOMAKE="echo no automake mode"
	MAKEINFO="echo no makeinfo mode"
	UTDLIB_AUTOTOOLS="--disable-autotools"
    fi
    AC_SUBST(ACLOCAL)
    AC_SUBST(AUTOCONF)
    AC_SUBST(AUTOHEADER)
    AC_SUBST(AUTOMAKE)
    AC_SUBST(MAKEINFO)
    AC_SUBST(UTDLIB_AUTOTOOLS)
])
