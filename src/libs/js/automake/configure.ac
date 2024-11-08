#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([js], [1.0])
AC_CONFIG_HEADERS([src/config.h])
AM_INIT_AUTOMAKE([foreign subdir-objects])
TEA_INIT([3.6])

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_LIBTOOL

#--------------------------------------------------------------------
# Load the tclConfig.sh file
#--------------------------------------------------------------------

TEA_PATH_TCLCONFIG
TEA_LOAD_TCLCONFIG

# See if threads are enabled
UTD_ROOT_ENV
UTD_BUILD_ENV
UTD_ENABLE_THREADS
UTD_ENABLE_SHARED
UTD_ENABLE_AUTOTOOLS

AM_CONDITIONAL([UTDTOOLS_STATIC_BUILD], [test x$utdlib_ok != xyes])

# Checks for header files.
AC_HEADER_STDC
AC_HEADER_SYS_WAIT
AC_CHECK_HEADERS([fcntl.h limits.h sys/time.h unistd.h])
AC_HEADER_TIME
AC_STRUCT_TM
AC_STRUCT_TIMEZONE

# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_PID_T
AC_TYPE_SIZE_T

# Checks for library functions.
AC_FUNC_FORK
AC_CHECK_FUNCS(localtime)

#--------------------------------------------------------------------
# SC_CONFIG_SYSTEM
#
#	Determine what the system is (some things cannot be easily checked
#	on a feature-driven basis, alas). This can usually be done via the
#	"uname" command, but there are a few systems, like Next, where
#	this doesn't work.
#
# Arguments:
#	none
#
# Results:
#	Defines the following var:
#
#	system -	System/platform/version identification code.
#
#--------------------------------------------------------------------

AC_DEFUN([SC_CONFIG_SYSTEM], [
    AC_CACHE_CHECK([system version], tcl_cv_sys_version, [
	if test -f /usr/lib/NextStep/software_version; then
	    tcl_cv_sys_version=NEXTSTEP-`awk '/3/,/3/' /usr/lib/NextStep/software_version`
	else
	    tcl_cv_sys_version=`uname -s`-`uname -r`
	    if test "$?" -ne 0 ; then
		AC_MSG_WARN([can't find uname command])
		tcl_cv_sys_version=unknown
	    else
		# Special check for weird MP-RAS system (uname returns weird
		# results, and the version is kept in special file).

		if test -r /etc/.relid -a "X`uname -n`" = "X`uname -s`" ; then
		    tcl_cv_sys_version=MP-RAS-`awk '{print $[3]}' /etc/.relid`
		fi
		if test "`uname -s`" = "AIX" ; then
		    tcl_cv_sys_version=AIX-`uname -v`.`uname -r`
		fi
	    fi
	fi
    ])
    system=$tcl_cv_sys_version
])

AC_MSG_CHECKING([system version (for cpu config)])

# Step 1: set the variable "system" to hold the name and version number
# for the system.  This can usually be done via the "uname" command, but
# there are a few systems, like Next, where this doesn't work.
SC_CONFIG_SYSTEM

# Step 2: set configuration options based on system name and version.

case $system in
    AIX-*)
	CPU_OS="AIXV3"
	;;
    Darwin-*)
	CPU_OS="Darwin"
	;;
    HP-UX-*.08.*|HP-UX-*.09.*|HP-UX-*.10.*)
	CPU_OS="HPUX"
	;;
    IRIX-4.*)
	CPU_OS="IRIX"
	;;
    IRIX-5.*)
	CPU_OS="IRIX"
	;;
    Linux*)
	CPU_OS="LINUX"
	;;
    MP-RAS-02*)
	CPU_OS="Unknown"
	;;
    MP-RAS-*)
	CPU_OS="Unknown"
	;;
    NetBSD-*|FreeBSD-*)
	# Not available on all versions:  check for include file.
	CPU_OS="Unknown"
	;;
    NEXTSTEP-*)
	CPU_OS="Unknown"
	;;
    OSF1-1.[012])
	# OSF/1 1.[012] from OSF, and derivatives, including Paragon OSF/1
	CPU_OS="OSF1"
	;;
    OSF1-1.*)
	# OSF/1 1.3 from OSF using ELF, and derivatives, including AD2
	CPU_OS="OSF1"
	;;
    OSF1-V*)
        # Digital OSF/1
	CPU_OS="OSF1"
	;;
    RISCos-*)
	CPU_OS="Unknown"
	;;
    SCO_SV-3.2*)
        # Note, dlopen is available only on SCO 3.2.5 and greater.  However,
        # this test works, since "uname -s" was non-standard in 3.2.4 and
        # below.
	CPU_OS="Unknown"
	;;
     SINIX*5.4*)
	CPU_OS="Unknown"
	;;
    SunOS-4*)
	CPU_OS="SUNOS4"
	;;
    SunOS-5*)
	CPU_OS="SOLARIS"
	;;
    ULTRIX-4.*)
	CPU_OS="ULTRIX"
	;;
    UNIX_SV*)
	CPU_OS="Unknown"
	;;
esac
echo "CPU_OS=$CPU_OS"

AC_CHECK_PROG(MCC,imcc,imcc,"$CC")
AC_SUBST(CC)
AC_SUBST(CPU_OS)
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
