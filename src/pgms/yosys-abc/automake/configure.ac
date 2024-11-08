AC_PREREQ([2.69])
AC_INIT([yosys], [1.0])

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_AWK

AC_CONFIG_SRCDIR(src/CodingReadme)
AC_CONFIG_HEADERS(src/kernel/config.h)

# Check for shared option
UTD_ENABLE_SHARED
UTD_ENABLE_DEBUG
UTD_ENABLE_THREADS

#------------------------------------------------------------------------
#	Add stuff for zlib
#------------------------------------------------------------------------

zlib_ok=yes
AC_CHECK_HEADER([zlib.h],[
  AC_CHECK_TYPE([gz_header],[],[zlib_ok=no],[#include <zlib.h>])],[
  zlib_ok=no])
AS_IF([test $zlib_ok = yes], [
  AC_SEARCH_LIBS([deflateSetHeader],[z],[],[
    zlib_ok=no
  ])])
AS_IF([test $zlib_ok = no], [
  AC_SUBST(ZLIB_OBJS,[\${ZLIB_OBJS}])
  AC_SUBST(ZLIB_SRCS,[\${ZLIB_SRCS}])
  AC_SUBST(ZLIB_INCLUDE,[-I\${ZLIB_DIR}])
])
AC_DEFINE(HAVE_ZLIB, 1, [Is there an installed zlib?])

AC_CHECK_FUNCS(mkstemps)

SC_CONFIG_CFLAGS
UTD_ENABLE_AUTOTOOLS

# Checks for header files.
AC_SUBST(AWK)
AC_SUBST(UTDTOOLS_TCL_LIB)
AC_SUBST(TCL_LIBS)
AC_CONFIG_FILES([
 	Makefile
	src/abc/Makefile:src/abc/Makefile.in
])
AC_OUTPUT
