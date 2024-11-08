AC_PREREQ([2.69])
AC_INIT([sverilog], [1.0])
AC_CONFIG_HEADERS([src/config.h])
AM_INIT_AUTOMAKE([foreign subdir-objects])

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_LIBTOOL

# See if threads are enabled
UTD_ENABLE_THREADS
UTD_ENABLE_SHARED

# Checks for header files.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_TYPE_SIGNAL
AC_HEADER_STDC

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADERS(stdarg.h)

# Checks for library functions.
AC_CHECK_FUNCS([memset])

UTD_ENABLE_AUTOTOOLS

AM_CONDITIONAL([UTDTOOLS_STATIC_BUILD], [test x$utdtools_ok != xyes])

AC_CHECK_PROG(MCC,imcc,imcc,"$CC")

AC_SUBST(CC)
AC_CONFIG_FILES([
 	Makefile
])
AC_OUTPUT
