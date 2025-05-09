AC_PREREQ([2.69])
AC_INIT([tix], [8.4.3])
AM_INIT_AUTOMAKE([foreign])
AC_CONFIG_MACRO_DIR([m4])

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_LIBTOOL

#--------------------------------------------------------------------
# Call TEA_INIT as the first TEA_ macro to set up initial vars.
# This will define a ${TEA_PLATFORM} variable == "unix" or "windows"
# as well as PKG_LIB_FILE and PKG_STUB_LIB_FILE.
#--------------------------------------------------------------------

TEA_INIT([3.6])


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

#-----------------------------------------------------------------------
# Standard compiler checks.
# This sets up CC by using the CC env var, or looks for gcc otherwise.
# This also calls AC_PROG_CC, AC_PROG_INSTALL and a few others to create
# the basic setup necessary to compile executables.
#-----------------------------------------------------------------------

TEA_SETUP_COMPILER

# Checks for X libraries.
AC_PATH_XTRA

#--------------------------------------------------------------------
# Determine the build environment.
#--------------------------------------------------------------------
UTD_ROOT_ENV
UTD_BUILD_ENV
UTD_ENABLE_THREADS
UTD_ENABLE_SHARED
UTD_INCPATH

#-----------------------------------------------------------------------
# __CHANGE__
# Specify the C source files to compile in TEA_ADD_SOURCES,
# public headers that need to be installed in TEA_ADD_HEADERS,
# stub library C source files to compile in TEA_ADD_STUB_SOURCES,
# and runtime Tcl library files in TEA_ADD_TCL_SOURCES.
# This defines PKG(_STUB)_SOURCES, PKG(_STUB)_OBJECTS, PKG_HEADERS
# and PKG_TCL_SOURCES.
#-----------------------------------------------------------------------

# core sources
TEA_ADD_SOURCES([tixClass.c tixCmds.c tixCompat.c tixError.c tixGeometry.c
		 tixInit.c tixList.c tixMethod.c tixOption.c tixScroll.c
		 tixSmpLs.c tixUtils.c tixWidget.c])
# ditem sources
TEA_ADD_SOURCES([tixDItem.c tixDiITxt.c tixDiImg.c tixDiStyle.c tixDiText.c
		 tixDiWin.c])
# manager sources
TEA_ADD_SOURCES([tixForm.c tixFormMisc.c])
# widget sources
TEA_ADD_SOURCES([tixGrid.c tixGrData.c tixGrFmt.c tixGrRC.c tixGrSel.c
		 tixGrSort.c tixGrUtl.c tixHList.c tixHLCol.c tixHLInd.c
		 tixHLHdr.c tixNBFrame.c tixTList.c])
# misc sources
TEA_ADD_SOURCES([tixImgCmp.c tixImgXpm.c])

TEA_ADD_HEADERS([])
TEA_ADD_INCLUDES([-I. -I\"`${CYGPATH} ${srcdir}/generic`\"])
TEA_ADD_CFLAGS([])
TEA_ADD_STUB_SOURCES([])
TEA_ADD_TCL_SOURCES([])

#--------------------------------------------------------------------
# __CHANGE__
# Choose which headers you need.  Extension authors should try very
# hard to only rely on the Tcl public header files.  Internal headers
# contain private data structures and are subject to change without
# notice.
# This MUST be called after TEA_PATH_TCLCONFIG/TEA_LOAD_TCLCONFIG
#--------------------------------------------------------------------

# needed for tclPort.h and such ... can be corrected
TEA_PRIVATE_TCL_HEADERS
TEA_PRIVATE_TK_HEADERS

#--------------------------------------------------------------------
# For Unix/Tk builds, make sure that the X libraries/headers are found.
#--------------------------------------------------------------------

TEA_PATH_X

#--------------------------------------------------------------------
# __CHANGE__
# A few miscellaneous platform-specific items:
#
# Define a special symbol for Windows (BUILD_tix in this case) so
# that we create the export library with the dll.
#
# Windows creates a few extra files that need to be cleaned up.
# You can add more files to clean if your extension creates any extra
# files.
#
# TEA_ADD any extra compiler/build info here.
#--------------------------------------------------------------------

if test "${TEA_PLATFORM}" = "windows" ; then
    AC_DEFINE_UNQUOTED(BUILD_tix)
    CLEANFILES="pkgIndex.tcl *.lib *.dll *.exp *.ilk *.pdb *.pch"
    TEA_ADD_LIBS([gdi32.lib user32.lib advapi32.lib comdlg32.lib])
    TEA_ADD_SOURCES([tixWCmpt.c tixWinWm.c tixWinXpm.c tixWinDraw.c])
    TEA_ADD_INCLUDES([-I. -I\"`${CYGPATH} ${srcdir}/win`\"])
else
    CLEANFILES="pkgIndex.tcl"
    TEA_ADD_SOURCES([tixInputO.c tixUnixMwm.c])
    TEA_ADD_SOURCES([tixUnixDraw.c tixUnixXpm.c tixUnixWm.c])
    TEA_ADD_INCLUDES([-I. -I\"`${CYGPATH} ${srcdir}/unix`\"])
fi
if test "${TEA_WINDOWINGSYSTEM}" = "aqua"; then
    TEA_ADD_INCLUDES([-I${TK_TOP_DIR_NATIVE}/macosx])
fi
AC_SUBST(CLEANFILES)

#--------------------------------------------------------------------
# Check whether --enable-threads or --disable-threads was given.
# So far only Tcl responds to this one.
#--------------------------------------------------------------------

TEA_ENABLE_THREADS

#--------------------------------------------------------------------
# The statement below defines a collection of symbols related to
# building as a shared library instead of a static library.
#--------------------------------------------------------------------

TEA_ENABLE_SHARED

#--------------------------------------------------------------------
# This macro figures out what flags to use with the compiler/linker
# when building shared/static debug/optimized objects.  This information
# can be taken from the tclConfig.sh file, but this figures it all out.
#--------------------------------------------------------------------

TEA_CONFIG_CFLAGS

#--------------------------------------------------------------------
# Set the default compiler switches based on the --enable-symbols 
# option.
#--------------------------------------------------------------------

TEA_ENABLE_SYMBOLS

#--------------------------------------------------------------------
# Everyone should be linking against the Tcl stub library.  If you
# can't for some reason, remove this definition.  If you aren't using
# stubs, you also need to modify the SHLIB_LD_LIBS setting below to
# link against the non-stubbed Tcl library.
#--------------------------------------------------------------------

AC_DEFINE(USE_TCL_STUBS)
AC_DEFINE(USE_TK_STUBS)

#--------------------------------------------------------------------
# This macro generates a line to use when building a library.  It
# depends on values set by the TEA_ENABLE_SHARED, TEA_ENABLE_SYMBOLS,
# and TEA_LOAD_TCLCONFIG macros above.
#--------------------------------------------------------------------

TEA_MAKE_LIB

#--------------------------------------------------------------------
# Find tclsh so that we can run pkg_mkIndex to generate the pkgIndex.tcl
# file during the install process.  Don't run the TCLSH_PROG through
# ${CYGPATH} because it's being used directly by make.
# Require that we use a tclsh shell version 8.2 or later since earlier
# versions have bugs in the pkg_mkIndex routine.
#--------------------------------------------------------------------

TEA_PROG_TCLSH
TEA_PROG_WISH


AC_CHECK_PROG(MCC,imcc,imcc,"$CC")

UTD_ENABLE_AUTOTOOLS
#--------------------------------------------------------------------
# Finally, substitute all of the various values into the Makefile.
#--------------------------------------------------------------------
AC_CONFIG_FILES([
     Makefile:Makefile.in
])

AC_OUTPUT
