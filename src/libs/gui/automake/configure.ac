AC_PREREQ([2.69])
AC_INIT([utdgui], [1.0])
AC_CONFIG_HEADERS([config.h])
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

#--------------------------------------------------------------------
# Load the tkConfig.sh file if necessary (Tk extension)
#--------------------------------------------------------------------

TEA_PATH_TKCONFIG
TEA_LOAD_TKCONFIG

#-----------------------------------------------------------------------
# Handle the --prefix=... option by defaulting to what Tcl gave.
# Must be called after TEA_LOAD_TCLCONFIG and before TEA_SETUP_COMPILER.
#-----------------------------------------------------------------------
TEA_PREFIX

# Checks for libraries.
UTD_AC_PATH_XTRA

# See if threads are enabled
UTD_ROOT_ENV
UTD_BUILD_ENV
UTD_ENABLE_THREADS
UTD_ENABLE_SHARED
UTD_ENABLE_AUTOTOOLS

AM_CONDITIONAL([UTDTOOLS_STATIC_BUILD], [test x$utdlib_ok != xyes])

# Checks for header files.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_TYPE_SIGNAL
AC_HEADER_STDC

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADERS(stdarg.h signal.h)

# Checks for library functions.
AC_CHECK_FUNCS([memset])

AC_CHECK_PROG(MCC,imcc,imcc,"$CC")


AC_MSG_CHECKING([whether to use xft])
AC_ARG_ENABLE(xft,
    AC_HELP_STRING([--enable-xft],
	[use freetype/fontconfig/xft (default: on)]),
    [enable_xft=$enableval], [enable_xft="default"])
XFT_CFLAGS=""
XFT_LIBS=""
if test "$enable_xft" = "no" ; then
    AC_MSG_RESULT([$enable_xft])
else
    found_xft="yes"
    dnl make sure package configurator (xft-config or pkg-config
    dnl says that xft is present.
    XFT_CFLAGS=`xft-config --cflags 2>/dev/null` || found_xft="no"
    XFT_LIBS=`xft-config --libs 2>/dev/null` || found_xft="no"
    if test "$found_xft" = "no" ; then
	found_xft=yes
	XFT_CFLAGS=`pkg-config --cflags xft 2>/dev/null` || found_xft="no"
	XFT_LIBS=`pkg-config --libs xft 2>/dev/null` || found_xft="no"
    fi
    AC_MSG_RESULT([$found_xft])
    dnl make sure that compiling against Xft header file doesn't bomb
    if test "$found_xft" = "yes" ; then
	tk_oldCFlags=$CFLAGS
	CFLAGS="$CFLAGS $XINCLUDES $XFT_CFLAGS"
	tk_oldLibs=$LIBS
	LIBS="$tk_oldLIBS $XFT_LIBS $XLIBSW"
	AC_CHECK_HEADER(X11/Xft/Xft.h, [], [
	    found_xft=no
	],[#include <X11/Xlib.h>])
	CFLAGS=$tk_oldCFlags
	LIBS=$tk_oldLibs
    fi
    dnl make sure that linking against Xft libraries finds freetype
    if test "$found_xft" = "yes" ; then
	tk_oldCFlags=$CFLAGS
	CFLAGS="$CFLAGS $XINCLUDES $XFT_CFLAGS"
	tk_oldLibs=$LIBS
	LIBS="$tk_oldLIBS $XFT_LIBS $XLIBSW"
	AC_CHECK_LIB(Xft, XftFontOpen, [], [
	    found_xft=no
	])
	CFLAGS=$tk_oldCFlags
	LIBS=$tk_oldLibs
    fi
    dnl make sure that linking against fontconfig libraries finds Fc* symbols
    if test "$found_xft" = "yes" ; then
	tk_oldCFlags=$CFLAGS
	CFLAGS="$CFLAGS $XINCLUDES $XFT_CFLAGS"
	tk_oldLibs=$LIBS
	LIBS="$tk_oldLIBS $XFT_LIBS $XLIBSW -lfontconfig"
	AC_CHECK_LIB(fontconfig, FcFontSort, [
	    XFT_LIBS="$XFT_LIBS -lfontconfig"
	], [])
	CFLAGS=$tk_oldCFlags
	LIBS=$tk_oldLibs
    fi
    dnl print a warning if xft is unusable and was specifically requested
    if test "$found_xft" = "no" ; then
	if test "$enable_xft" = "yes" ; then
	    AC_MSG_WARN([Can't find xft configuration, or xft is unusable])
	fi
	enable_xft=no
	XFT_CFLAGS=""
	XFT_LIBS=""
    else
	enable_xft=yes
    fi
fi

# Check for libXss
save_libs=$LIBS
export LIBS="-L$x_libraries $LIBS"
AC_CHECK_LIB([Xss], [XScreenSaverQueryInfo],
  [HAS_LIBXSS=1
  LIBS="-L$x_libraries -lXss $LIBS"
  AC_DEFINE([HAVE_LIBXSS], 1, [Define to 1 if you have the 'Xss' library (-L$x_libraries -lXss)])])
AM_CONDITIONAL([USE_LIBXSS],[grep HAVE_LIBXSS confdefs.h > /dev/null])
export LIBS=$save_libs

AC_SUBST(CC)
AC_SUBST(XFT_CFLAGS)
AC_SUBST(XFT_LIBS)
AC_CONFIG_FILES([
	src/runenv.h:src/runenv.h.in
 	Makefile
])
AC_OUTPUT
