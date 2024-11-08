#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([tclpython], [1.0])
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

AM_CONDITIONAL([UTD_STATIC_BUILD], [test x$utdlib_ok != xyes])

# Checks for header files.
AC_CHECK_HEADERS([fcntl.h limits.h memory.h stdlib.h string.h sys/param.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_PID_T
AC_TYPE_SIZE_T

# Checks for library functions.
AC_FUNC_FORK
AC_CHECK_FUNCS([dup2 memset strdup strtol])

AC_CHECK_PROG(MCC,imcc,imcc,"$CC")
AC_SUBST(CC)
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
