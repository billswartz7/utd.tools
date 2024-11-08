AC_PREREQ([2.69])
AC_INIT([cometflow], [1.0])
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
UTD_ENABLE_THREADS
UTD_ENABLE_SHARED
UTD_ENABLE_GRAPHICS

AM_CONDITIONAL([UTDTOOLS_STATIC_BUILD], [test x$utdtools_ok != xyes])
AM_CONDITIONAL([UTDTOOLS_GRAPHICS], [test x$utdgraphics_ok = xyes])

# Checks for header files.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_TYPE_SIGNAL
AC_HEADER_STDC

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADERS(stdarg.h)

# Checks for library functions.
AC_CHECK_FUNCS([memset])

AC_CHECK_PROG(MCC,imcc,imcc,"$CC")

UTD_ENABLE_AUTOTOOLS

AC_SUBST(CC)
AC_CONFIG_FILES([
 	Makefile
])
AC_OUTPUT
UTD_MAKE_TIMESTAMP
