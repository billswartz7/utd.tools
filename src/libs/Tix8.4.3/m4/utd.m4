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
	[utdlib_ok=$enableval], [utdlib_ok=no])

    if test "${enable_threads+set}" = set; then
	enableval="$enable_threads"
	utdlib_ok=$enableval
    else
	utdlib_ok=no
    fi

    if test "$utdlib_ok" = "yes" ; then
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
	[utdlib_ok=$enableval], [utdlib_ok=yes])

    if test "${enable_shared+set}" = set; then
	enableval="$enable_shared"
	utdlib_ok=$enableval
    else
	utdlib_ok=yes
    fi

    if test "$utdlib_ok" = "yes" ; then
	AC_MSG_RESULT([shared])
    else
	AC_MSG_RESULT([static])
	AC_DEFINE(UTDTOOLS_STATIC_BUILD, 1, [Is this a static build?])
    fi
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
	    [override the build environment variable (default: UTDTOOLS)]),
	with_buildenv="${withval}")

    if test x"${with_buildenv}" != x ; then
	UTD_BUILD_ENV_VARIABLE="${with_buildenv}"
	UTD_BUILD_LC_ENV_VARIABLE=`echo ${UTD_BUILD_ENV_VARIABLE} | tr A-Z a-z`
    else
	UTD_BUILD_ENV_VARIABLE="UTDTOOLS"
	UTD_BUILD_LC_ENV_VARIABLE="common"
    fi
    export UTD_BUILD_ENV_VARIABLE
    UTD_BUILD_ENV_SUFFIX=`echo ${UTD_BUILD_ENV_VARIABLE}_ | tr A-Z a-z`
    export UTD_BUILD_ENV_SUFFIX
    export UTD_BUILD_LC_ENV_VARIABLE
    AC_MSG_RESULT([now: ${UTD_BUILD_ENV_VARIABLE}])
    AC_SUBST(UTD_BUILD_ENV_VARIABLE)
    AC_SUBST(UTD_BUILD_LC_ENV_VARIABLE)
    AC_SUBST(UTD_BUILD_ENV_SUFFIX)
])
#------------------------------------------------------------------------
# UTD_ROOT_ENV --
#
#	Allows the setting of a root build environment variable from the
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
#	If not set, given sets it to value of UTDTOOLS
#------------------------------------------------------------------------

AC_DEFUN([UTD_ROOT_ENV], [
    AC_MSG_CHECKING([whether to override root environment variable])
    AC_ARG_WITH(buildroot,
	AC_HELP_STRING([--with-buildroot],
	    [override the build root variable (default: UTDTOOLS)]),
	with_buildroot="${withval}")

    if test x"${with_buildroot}" != x ; then
	UTDTOOLS_ROOT_ENV_VARIABLE="${with_buildroot}"
    else
	UTDTOOLS_ROOT_ENV_VARIABLE=${UTDTOOLS}
    fi
    export UTDTOOLS_ROOT_ENV_VARIABLE
    AC_MSG_RESULT([now: ${UTDTOOLS_ROOT_ENV_VARIABLE}])
    AC_SUBST(UTDTOOLS_ROOT_ENV_VARIABLE)
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
