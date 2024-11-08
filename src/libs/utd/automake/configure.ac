AC_PREREQ([2.69])
AC_INIT([utdlib],[0.9],[bill-swartz@utdallas.edu])
AC_CONFIG_HEADERS([src/utdconfig.h])
AC_CONFIG_MACRO_DIRS([m4])
AM_INIT_AUTOMAKE([foreign subdir-objects])


# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
LT_INIT

UTD_ROOT_ENV
UTD_BUILD_ENV
UTD_CHECK_ENVIRONMENT
UTD_INCPATH
AC_PREFIX_DEFAULT($UTDTOOLS/libutd)

UTD_ENABLE_THREADS
UTD_ENABLE_SHARED
UTD_ENABLE_DEBUG
UTD_ENABLE_MEMDEBUG

AC_CHECK_PROG(MCC,imcc,imcc,"$CC")
UTD_ENABLE_AUTOTOOLS

# Checks for functions, typedefs, structures, and compiler characteristics.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_DIAGNOSE([obsolete],[your code may safely assume C89 semantics that RETSIGTYPE is void.
Remove this warning and the `AC_CACHE_CHECK' when you adjust the code.])dnl
AC_CACHE_CHECK([return type of signal handlers],[ac_cv_type_signal],[AC_COMPILE_IFELSE(
[AC_LANG_PROGRAM([#include <sys/types.h>
#include <signal.h>
],
		 [return *(signal (0, 0)) (0) == 1;])],
		   [ac_cv_type_signal=int],
		   [ac_cv_type_signal=void])])
AC_DEFINE_UNQUOTED([RETSIGTYPE],[$ac_cv_type_signal],[Define as the return type of signal handlers
		    (`int' or `void').])

AC_HEADER_STDC
AC_FUNC_MEMCMP
AC_FUNC_SETPGRP
AC_CHECK_HEADERS(errno.h stdarg.h ctype.h netdb.h unistd.h signal.h \
		 execinfo.h sys/time.h malloc.h malloc/malloc.h socket/socket.h \
		 sys/socket.h fcntl.h sys/ioctl.h sys/select.h net/nh.h \
                 sys/stream.h netinet/in.h vfork.h sys/termios.h time.h \
		 sys/resource.h sys/rusage.h sys/wait.h sys/mman.h wchar.h)


# Checks for library functions.
AC_CHECK_FUNCS([memset memmove strsignal backtrace setitimer malloc_size malloc_usable_size \
		getdtablesize setenv ftime times gettimeofday mmap])

# Check for addr2line for backtrace pretty print.
AC_ARG_VAR(ADDR_TO_LINE, [[The addr2line program.]])
AC_CHECK_PROG(ADDR_TO_LINE, addr2line, addr2line)
if test "x$ADDR_TO_LINE" = x; then
  AC_CHECK_PROG(ATOS, atos, atos)
  if test "x$ATOS" != x; then
    AC_DEFINE(HAVE_ATOS,1,[we need to use atos])
  fi
else 
  AC_DEFINE(HAVE_ADDR2LINE,1,[we need to use addr2line])
fi
AM_CONDITIONAL([UTDTOOLS_MEMDEBUG_BUILD], [test x$utdtoolsmemdebug_ok = xyes])


AC_CONFIG_FILES([Makefile])
AC_OUTPUT

UTD_CONFIG_COPY
