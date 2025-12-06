#--------------------------------------------------------------------
# SC_CONFIG_CFLAGS
#
#	Try to determine the proper flags to pass to the compiler
#	for building shared libraries and other such nonsense.
#
# Arguments:
#	none
#
# Results:
#
#	Defines and substitutes the following vars:
#
#       DL_OBJS -       Name of the object file that implements dynamic
#                       loading for Tcl on this system.
#       DL_LIBS -       Library file(s) to include in tclsh and other base
#                       applications in order for the "load" command to work.
#       LDFLAGS -      Flags to pass to the compiler when linking object
#                       files into an executable application binary such
#                       as tclsh.
#       LD_SEARCH_FLAGS-Flags to pass to ld, such as "-R /usr/local/tcl/lib",
#                       that tell the run-time dynamic linker where to look
#                       for shared libraries such as libtcl.so.  Depends on
#                       the variable LIB_RUNTIME_DIR in the Makefile. Could
#                       be the same as CC_SEARCH_FLAGS if ${CC} is used to link.
#       CC_SEARCH_FLAGS-Flags to pass to ${CC}, such as "-Wl,-rpath,/usr/local/tcl/lib",
#                       that tell the run-time dynamic linker where to look
#                       for shared libraries such as libtcl.so.  Depends on
#                       the variable LIB_RUNTIME_DIR in the Makefile.
#       MAKE_LIB -      Command to execute to build the a library;
#                       differs when building shared or static.
#       MAKE_STUB_LIB -
#                       Command to execute to build a stub library.
#       INSTALL_LIB -   Command to execute to install a library;
#                       differs when building shared or static.
#       INSTALL_STUB_LIB -
#                       Command to execute to install a stub library.
#       STLIB_LD -      Base command to use for combining object files
#                       into a static library.
#       SHLIB_CFLAGS -  Flags to pass to cc when compiling the components
#                       of a shared library (may request position-independent
#                       code, among other things).
#       SHLIB_LD -      Base command to use for combining object files
#                       into a shared library.
#       SHLIB_LD_LIBS - Dependent libraries for the linker to scan when
#                       creating shared libraries.  This symbol typically
#                       goes at the end of the "ld" commands that build
#                       shared libraries. The value of the symbol defaults to
#                       "${LIBS}" if all of the dependent libraries should
#                       be specified when creating a shared library.  If
#                       dependent libraries should not be specified (as on
#                       SunOS 4.x, where they cause the link to fail, or in
#                       general if Tcl and Tk aren't themselves shared
#                       libraries), then this symbol has an empty string
#                       as its value.
#       SHLIB_SUFFIX -  Suffix to use for the names of dynamically loadable
#                       extensions.  An empty string means we don't know how
#                       to use shared libraries on this platform.
# TCL_SHLIB_LD_EXTRAS - Additional element which are added to SHLIB_LD_LIBS
#  TK_SHLIB_LD_EXTRAS   for the build of Tcl and Tk, but not recorded in the
#                       tclConfig.sh, since they are only used for the build
#                       of Tcl and Tk.
#                       Examples: MacOS X records the library version and
#                       compatibility version in the shared library.  But
#                       of course the Tcl version of this is only used for Tcl.
#       LIB_SUFFIX -    Specifies everything that comes after the "libfoo"
#                       in a static or shared library name, using the $VERSION variable
#                       to put the version in the right place.  This is used
#                       by platforms that need non-standard library names.
#                       Examples:  ${VERSION}.so.1.1 on NetBSD, since it needs
#                       to have a version after the .so, and ${VERSION}.a
#                       on AIX, since a shared library needs to have
#                       a .a extension whereas shared objects for loadable
#                       extensions have a .so extension.  Defaults to
#                       ${VERSION}${SHLIB_SUFFIX}.
#       TCL_LIBS -
#                       Libs to use when linking Tcl shell or some other
#                       shell that includes Tcl libs.
#	CFLAGS_DEBUG -
#			Flags used when running the compiler in debug mode
#	CFLAGS_OPTIMIZE -
#			Flags used when running the compiler in optimize mode
#	CFLAGS -	Additional CFLAGS added as necessary (usually 64-bit)
#
#--------------------------------------------------------------------

AC_DEFUN([SC_CONFIG_CFLAGS], [

    # Step 0.a: Enable 64 bit support?

    AC_MSG_CHECKING([if 64bit support is requested])
    AC_ARG_ENABLE(64bit,
	AS_HELP_STRING([--enable-64bit],
	    [enable 64bit support (default: off)]),
	[do64bit=$enableval], [do64bit=no])
    AC_MSG_RESULT([$do64bit])

    # Step 0.b: Enable Solaris 64 bit VIS support?

    AC_MSG_CHECKING([if 64bit Sparc VIS support is requested])
    AC_ARG_ENABLE(64bit-vis,
	AS_HELP_STRING([--enable-64bit-vis],
	    [enable 64bit Sparc VIS support (default: off)]),
	[do64bitVIS=$enableval], [do64bitVIS=no])
    AC_MSG_RESULT([$do64bitVIS])
    # Force 64bit on with VIS
    AS_IF([test "$do64bitVIS" = "yes"], [do64bit=yes])

    # Step 0.c: Check if visibility support is available. Do this here so
    # that platform specific alternatives can be used below if this fails.

    AC_CACHE_CHECK([if compiler supports visibility "hidden"],
	tcl_cv_cc_visibility_hidden, [
	hold_cflags=$CFLAGS; CFLAGS="$CFLAGS -Werror"
	AC_LINK_IFELSE([AC_LANG_PROGRAM([[
	    extern __attribute__((__visibility__("hidden"))) void f(void);
	    void f(void) {}]], [[f();]])],
	    [tcl_cv_cc_visibility_hidden=yes],
	    [tcl_cv_cc_visibility_hidden=no])
	CFLAGS=$hold_cflags])
    AS_IF([test $tcl_cv_cc_visibility_hidden = yes], [
	AC_DEFINE(MODULE_SCOPE,
	    [extern __attribute__((__visibility__("hidden")))],
	    [Compiler support for module scope symbols])
	AC_DEFINE(HAVE_HIDDEN, [1], [Compiler support for module scope symbols])
    ])

    # Step 0.d: Disable -rpath support?

    AC_MSG_CHECKING([if rpath support is requested])
    AC_ARG_ENABLE(rpath,
	AS_HELP_STRING([--disable-rpath],
	    [disable rpath support (default: on)]),
	[doRpath=$enableval], [doRpath=yes])
    AC_MSG_RESULT([$doRpath])

    # Step 1: set the variable "system" to hold the name and version number
    # for the system.

    SC_CONFIG_SYSTEM

    # Step 2: check for existence of -ldl library.  This is needed because
    # Linux can use either -ldl or -ldld for dynamic loading.

    AC_CHECK_LIB(dl, dlopen, have_dl=yes, have_dl=no)

    # Require ranlib early so we can override it in special cases below.

    AC_REQUIRE([AC_PROG_RANLIB])

    # Step 3: set configuration options based on system name and version.

    do64bit_ok=no
    # default to '{$LIBS}' and set to "" on per-platform necessary basis
    SHLIB_LD_LIBS='${LIBS}'
    LDFLAGS_ORIG="$LDFLAGS"
    # When ld needs options to work in 64-bit mode, put them in
    # LDFLAGS_ARCH so they eventually end up in LDFLAGS even if [load]
    # is disabled by the user. [Bug 1016796]
    LDFLAGS_ARCH=""
    UNSHARED_LIB_SUFFIX=""
    TCL_TRIM_DOTS='`echo ${VERSION} | tr -d .`'
    ECHO_VERSION='`echo ${VERSION}`'
    TCL_LIB_VERSIONS_OK=ok
    CFLAGS_DEBUG=-g
    AS_IF([test "$GCC" = yes], [
	CFLAGS_OPTIMIZE=-O2
	CFLAGS_WARNING="-Wall -Wpointer-arith"
    ], [
	CFLAGS_OPTIMIZE=-O
	CFLAGS_WARNING=""
    ])
    AC_CHECK_TOOL(AR, ar)
    STLIB_LD='${AR} cr'
    LD_LIBRARY_PATH_VAR="LD_LIBRARY_PATH"
    PLAT_OBJS=""
    PLAT_SRCS=""
    LDAIX_SRC=""
    AS_IF([test "x${SHLIB_VERSION}" = x],[SHLIB_VERSION=".1.0"],[SHLIB_VERSION=".${SHLIB_VERSION}"])
    case $system in
	AIX-*)
	    AS_IF([test "${TCL_THREADS}" = "1" -a "$GCC" != "yes"], [
		# AIX requires the _r compiler when gcc isn't being used
		case "${CC}" in
		    *_r|*_r\ *)
			# ok ...
			;;
		    *)
			# Make sure only first arg gets _r
		    	CC=`echo "$CC" | sed -e 's/^\([[^ ]]*\)/\1_r/'`
			;;
		esac
		AC_MSG_RESULT([Using $CC for compiling with threads])
	    ])
	    LIBS="$LIBS -lc"
	    SHLIB_CFLAGS=""
	    SHLIB_SUFFIX=".so"

	    DL_OBJS="tclLoadDl.o"
	    LD_LIBRARY_PATH_VAR="LIBPATH"

	    # ldAix No longer needed with use of -bexpall/-brtl
	    # but some extensions may still reference it
	    LDAIX_SRC='$(UNIX_DIR)/ldAix'

	    # Check to enable 64-bit flags for compiler/linker
	    AS_IF([test "$do64bit" = yes], [
		AS_IF([test "$GCC" = yes], [
		    AC_MSG_WARN([64bit mode not supported with GCC on $system])
		], [
		    do64bit_ok=yes
		    CFLAGS="$CFLAGS -q64"
		    LDFLAGS_ARCH="-q64"
		    RANLIB="${RANLIB} -X64"
		    AR="${AR} -X64"
		    SHLIB_LD_FLAGS="-b64"
		])
	    ])

	    AS_IF([test "`uname -m`" = ia64], [
		# AIX-5 uses ELF style dynamic libraries on IA-64, but not PPC
		SHLIB_LD="/usr/ccs/bin/ld -G -z text"
		# AIX-5 has dl* in libc.so
		DL_LIBS=""
		AS_IF([test "$GCC" = yes], [
		    CC_SEARCH_FLAGS='-Wl,-R,${LIB_RUNTIME_DIR}'
		], [
		    CC_SEARCH_FLAGS='-R${LIB_RUNTIME_DIR}'
		])
		LD_SEARCH_FLAGS='-R ${LIB_RUNTIME_DIR}'
	    ], [
		AS_IF([test "$GCC" = yes], [
		    SHLIB_LD='${CC} -shared -Wl,-bexpall'
		], [
		    SHLIB_LD="/bin/ld -bhalt:4 -bM:SRE -bexpall -H512 -T512 -bnoentry"
		    LDFLAGS="$LDFLAGS -brtl"
		])
		SHLIB_LD="${SHLIB_LD} ${SHLIB_LD_FLAGS}"
		DL_LIBS="-ldl"
		CC_SEARCH_FLAGS='-L${LIB_RUNTIME_DIR}'
		LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}
	    ])
	    ;;
	BeOS*)
	    SHLIB_CFLAGS="-fPIC"
	    SHLIB_LD='${CC} -nostart'
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"

	    #-----------------------------------------------------------
	    # Check for inet_ntoa in -lbind, for BeOS (which also needs
	    # -lsocket, even if the network functions are in -lnet which
	    # is always linked to, for compatibility.
	    #-----------------------------------------------------------
	    AC_CHECK_LIB(bind, inet_ntoa, [LIBS="$LIBS -lbind -lsocket"])
	    ;;
	BSD/OS-2.1*|BSD/OS-3*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD="shlicc -r"
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	BSD/OS-4.*)
	    SHLIB_CFLAGS="-export-dynamic -fPIC"
	    SHLIB_LD='${CC} -shared'
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    LDFLAGS="$LDFLAGS -export-dynamic"
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	CYGWIN_*|MINGW32_*|MSYS_*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD='${CC} -shared'
	    SHLIB_SUFFIX=".dll"
	    DL_OBJS="tclLoadDl.o"
	    PLAT_OBJS='${CYGWIN_OBJS}'
	    PLAT_SRCS='${CYGWIN_SRCS}'
	    DL_LIBS="-ldl"
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    TCL_NEEDS_EXP_FILE=1
	    TCL_EXPORT_FILE_SUFFIX='${VERSION}.dll.a'
	    SHLIB_LD_LIBS="${SHLIB_LD_LIBS} -Wl,--out-implib,\$[@].a"
	    AC_CACHE_CHECK(for Cygwin version of gcc,
		ac_cv_cygwin,
		AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
		#ifdef __CYGWIN__
		    #error cygwin
		#endif
		]], [[]])],
		[ac_cv_cygwin=no],
		[ac_cv_cygwin=yes])
	    )
	    if test "$ac_cv_cygwin" = "no"; then
		AC_MSG_ERROR([${CC} is not a cygwin compiler.])
	    fi
	    if test "x${TCL_THREADS}" = "x0"; then
		AC_MSG_ERROR([CYGWIN compile is only supported with --enable-threads])
	    fi
	    do64bit_ok=yes
	    if test "x${SHARED_BUILD}" = "x1"; then
		echo "running cd ../win; ${CONFIG_SHELL-/bin/sh} ./configure $ac_configure_args"
		# The eval makes quoting arguments work.
		if cd ../win; eval ${CONFIG_SHELL-/bin/sh} ./configure $ac_configure_args; cd ../unix
		then :
		else
		    { echo "configure: error: configure failed for ../win" 1>&2; exit 1; }
		fi
	    fi
	    ;;
	dgux*)
	    SHLIB_CFLAGS="-K PIC"
	    SHLIB_LD='${CC} -G'
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	Haiku*)
	    LDFLAGS="$LDFLAGS -Wl,--export-dynamic"
	    SHLIB_CFLAGS="-fPIC"
	    SHLIB_SUFFIX=".so"
	    SHLIB_LD='${CC} ${CFLAGS} ${LDFLAGS} -shared'
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-lroot"
	    AC_CHECK_LIB(network, inet_ntoa, [LIBS="$LIBS -lnetwork"])
	    ;;
	HP-UX-*.11.*)
	    # Use updated header definitions where possible
	    AC_DEFINE(_XOPEN_SOURCE_EXTENDED, 1, [Do we want to use the XOPEN network library?])
	    AC_DEFINE(_XOPEN_SOURCE, 1, [Do we want to use the XOPEN network library?])
	    LIBS="$LIBS -lxnet"               # Use the XOPEN network library

	    AS_IF([test "`uname -m`" = ia64], [
		SHLIB_SUFFIX=".so"
	    ], [
		SHLIB_SUFFIX=".sl"
	    ])
	    AC_CHECK_LIB(dld, shl_load, tcl_ok=yes, tcl_ok=no)
	    AS_IF([test "$tcl_ok" = yes], [
		SHLIB_CFLAGS="+z"
		SHLIB_LD="ld -b"
		DL_OBJS="tclLoadShl.o"
		DL_LIBS="-ldld"
		LDFLAGS="$LDFLAGS -Wl,-E"
		CC_SEARCH_FLAGS='-Wl,+s,+b,${LIB_RUNTIME_DIR}:.'
		LD_SEARCH_FLAGS='+s +b ${LIB_RUNTIME_DIR}:.'
		LD_LIBRARY_PATH_VAR="SHLIB_PATH"
	    ])
	    AS_IF([test "$GCC" = yes], [
		SHLIB_LD='${CC} -shared'
		LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}
	    ], [
		CFLAGS="$CFLAGS -z"
	    ])

	    # Users may want PA-RISC 1.1/2.0 portable code - needs HP cc
	    #CFLAGS="$CFLAGS +DAportable"

	    # Check to enable 64-bit flags for compiler/linker
	    AS_IF([test "$do64bit" = "yes"], [
		AS_IF([test "$GCC" = yes], [
		    case `${CC} -dumpmachine` in
			hppa64*)
			    # 64-bit gcc in use.  Fix flags for GNU ld.
			    do64bit_ok=yes
			    SHLIB_LD='${CC} -shared'
			    AS_IF([test $doRpath = yes], [
				CC_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'])
			    LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}
			    ;;
			*)
			    AC_MSG_WARN([64bit mode not supported with GCC on $system])
			    ;;
		    esac
		], [
		    do64bit_ok=yes
		    CFLAGS="$CFLAGS +DD64"
		    LDFLAGS_ARCH="+DD64"
		])
	    ]) ;;
	HP-UX-*.08.*|HP-UX-*.09.*|HP-UX-*.10.*)
	    SHLIB_SUFFIX=".sl"
	    AC_CHECK_LIB(dld, shl_load, tcl_ok=yes, tcl_ok=no)
	    AS_IF([test "$tcl_ok" = yes], [
		SHLIB_CFLAGS="+z"
		SHLIB_LD="ld -b"
		SHLIB_LD_LIBS=""
		DL_OBJS="tclLoadShl.o"
		DL_LIBS="-ldld"
		LDFLAGS="$LDFLAGS -Wl,-E"
		CC_SEARCH_FLAGS='-Wl,+s,+b,${LIB_RUNTIME_DIR}:.'
		LD_SEARCH_FLAGS='+s +b ${LIB_RUNTIME_DIR}:.'
		LD_LIBRARY_PATH_VAR="SHLIB_PATH"
	    ]) ;;
	IRIX-5.*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD="ld -shared -rdata_shared"
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    AC_LIBOBJ(mkstemp)
	    AS_IF([test $doRpath = yes], [
		CC_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'
		LD_SEARCH_FLAGS='-rpath ${LIB_RUNTIME_DIR}'])
	    ;;
	IRIX-6.*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD="ld -n32 -shared -rdata_shared"
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    AC_LIBOBJ(mkstemp)
	    AS_IF([test $doRpath = yes], [
		CC_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'
		LD_SEARCH_FLAGS='-rpath ${LIB_RUNTIME_DIR}'])
	    AS_IF([test "$GCC" = yes], [
		CFLAGS="$CFLAGS -mabi=n32"
		LDFLAGS="$LDFLAGS -mabi=n32"
	    ], [
		case $system in
		    IRIX-6.3)
			# Use to build 6.2 compatible binaries on 6.3.
			CFLAGS="$CFLAGS -n32 -D_OLD_TERMIOS"
			;;
		    *)
			CFLAGS="$CFLAGS -n32"
			;;
		esac
		LDFLAGS="$LDFLAGS -n32"
	    ])
	    ;;
	IRIX64-6.*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD="ld -n32 -shared -rdata_shared"
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    AC_LIBOBJ(mkstemp)
	    AS_IF([test $doRpath = yes], [
		CC_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'
		LD_SEARCH_FLAGS='-rpath ${LIB_RUNTIME_DIR}'])

	    # Check to enable 64-bit flags for compiler/linker

	    AS_IF([test "$do64bit" = yes], [
	        AS_IF([test "$GCC" = yes], [
	            AC_MSG_WARN([64bit mode not supported by gcc])
	        ], [
	            do64bit_ok=yes
	            SHLIB_LD="ld -64 -shared -rdata_shared"
	            CFLAGS="$CFLAGS -64"
	            LDFLAGS_ARCH="-64"
	        ])
	    ])
	    ;;
	Linux*|GNU*|NetBSD-Debian|DragonFly-*|FreeBSD-*)
	    SHLIB_CFLAGS="-fPIC"
	    SHLIB_SUFFIX=".so"

	    CFLAGS_OPTIMIZE="-O2"
	    # egcs-2.91.66 on Redhat Linux 6.0 generates lots of warnings
	    # when you inline the string and math operations.  Turn this off to
	    # get rid of the warnings.
	    #CFLAGS_OPTIMIZE="${CFLAGS_OPTIMIZE} -D__NO_STRING_INLINES -D__NO_MATH_INLINES"

	    SHLIB_LD='${CC} ${CFLAGS} ${LDFLAGS} -shared'
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    LDFLAGS="$LDFLAGS -Wl,--export-dynamic"

	    case $system in
	    DragonFly-*|FreeBSD-*)
		AS_IF([test "${TCL_THREADS}" = "1"], [
		    # The -pthread needs to go in the LDFLAGS, not LIBS
		    LIBS=`echo $LIBS | sed s/-pthread//`
		    CFLAGS="$CFLAGS $PTHREAD_CFLAGS"
		    LDFLAGS="$LDFLAGS $PTHREAD_LIBS"])
	    ;;
            esac

	    AS_IF([test $doRpath = yes], [
		CC_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'])
	    LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}
	    AS_IF([test "`uname -m`" = "alpha"], [CFLAGS="$CFLAGS -mieee"])
	    AS_IF([test $do64bit = yes], [
		AC_CACHE_CHECK([if compiler accepts -m64 flag], tcl_cv_cc_m64, [
		    hold_cflags=$CFLAGS
		    CFLAGS="$CFLAGS -m64"
		    AC_LINK_IFELSE([AC_LANG_PROGRAM([[]], [[]])],
			    [tcl_cv_cc_m64=yes],[tcl_cv_cc_m64=no])
		    CFLAGS=$hold_cflags])
		AS_IF([test $tcl_cv_cc_m64 = yes], [
		    CFLAGS="$CFLAGS -m64"
		    do64bit_ok=yes
		])
	   ])

	    # The combo of gcc + glibc has a bug related to inlining of
	    # functions like strtod(). The -fno-builtin flag should address
	    # this problem but it does not work. The -fno-inline flag is kind
	    # of overkill but it works. Disable inlining only when one of the
	    # files in compat/*.c is being linked in.

	    AS_IF([test x"${USE_COMPAT}" != x],[CFLAGS="$CFLAGS -fno-inline"])
	    ;;
	Lynx*)
	    SHLIB_CFLAGS="-fPIC"
	    SHLIB_SUFFIX=".so"
	    CFLAGS_OPTIMIZE=-02
	    SHLIB_LD='${CC} -shared'
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-mshared -ldl"
	    LD_FLAGS="-Wl,--export-dynamic"
	    AS_IF([test $doRpath = yes], [
		CC_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'
		LD_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'])
	    ;;
	MP-RAS-02*)
	    SHLIB_CFLAGS="-K PIC"
	    SHLIB_LD='${CC} -G'
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	MP-RAS-*)
	    SHLIB_CFLAGS="-K PIC"
	    SHLIB_LD='${CC} -G'
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    LDFLAGS="$LDFLAGS -Wl,-Bexport"
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	OpenBSD-*)
	    arch=`arch -s`
	    case "$arch" in
	    alpha|sparc64)
		SHLIB_CFLAGS="-fPIC"
		;;
	    *)
		SHLIB_CFLAGS="-fpic"
		;;
	    esac
	    SHLIB_LD='${CC} ${SHLIB_CFLAGS} -shared'
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    AS_IF([test $doRpath = yes], [
		CC_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'])
	    LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}
	    SHARED_LIB_SUFFIX='${TCL_TRIM_DOTS}.so${SHLIB_VERSION}'
	    LDFLAGS="-Wl,-export-dynamic"
	    CFLAGS_OPTIMIZE="-O2"
	    AS_IF([test "${TCL_THREADS}" = "1"], [
		# On OpenBSD:	Compile with -pthread
		#		Don't link with -lpthread
		LIBS=`echo $LIBS | sed s/-lpthread//`
		CFLAGS="$CFLAGS -pthread"
	    ])
	    # OpenBSD doesn't do version numbers with dots.
	    UNSHARED_LIB_SUFFIX='${TCL_TRIM_DOTS}.a'
	    TCL_LIB_VERSIONS_OK=nodots
	    ;;
	NetBSD-*)
	    # NetBSD has ELF and can use 'cc -shared' to build shared libs
	    SHLIB_CFLAGS="-fPIC"
	    SHLIB_LD='${CC} ${SHLIB_CFLAGS} -shared'
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    LDFLAGS="$LDFLAGS -export-dynamic"
	    AS_IF([test $doRpath = yes], [
		CC_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'])
	    LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}
	    AS_IF([test "${TCL_THREADS}" = "1"], [
		# The -pthread needs to go in the CFLAGS, not LIBS
		LIBS=`echo $LIBS | sed s/-pthread//`
		CFLAGS="$CFLAGS -pthread"
	    	LDFLAGS="$LDFLAGS -pthread"
	    ])
	    ;;
	Darwin-*)
	    CFLAGS_OPTIMIZE="-O2"
	    SHLIB_CFLAGS="-fno-common"
	    # To avoid discrepancies between what headers configure sees during
	    # preprocessing tests and compiling tests, move any -isysroot and
	    # -mmacosx-version-min flags from CFLAGS to CPPFLAGS:
	    CPPFLAGS="${CPPFLAGS} `echo " ${CFLAGS}" | \
		awk 'BEGIN {FS=" +-";ORS=" "}; {for (i=2;i<=NF;i++) \
		if ([$]i~/^(isysroot|mmacosx-version-min)/) print "-"[$]i}'`"
	    CFLAGS="`echo " ${CFLAGS}" | \
		awk 'BEGIN {FS=" +-";ORS=" "}; {for (i=2;i<=NF;i++) \
		if (!([$]i~/^(isysroot|mmacosx-version-min)/)) print "-"[$]i}'`"
	    AS_IF([test $do64bit = yes], [
		case `arch` in
		    ppc)
			AC_CACHE_CHECK([if compiler accepts -arch ppc64 flag],
				tcl_cv_cc_arch_ppc64, [
			    hold_cflags=$CFLAGS
			    CFLAGS="$CFLAGS -arch ppc64 -mpowerpc64 -mcpu=G5"
			    AC_LINK_IFELSE([AC_LANG_PROGRAM([[]], [[]])],
				    [tcl_cv_cc_arch_ppc64=yes],[tcl_cv_cc_arch_ppc64=no])
			    CFLAGS=$hold_cflags])
			AS_IF([test $tcl_cv_cc_arch_ppc64 = yes], [
			    CFLAGS="$CFLAGS -arch ppc64 -mpowerpc64 -mcpu=G5"
			    do64bit_ok=yes
			]);;
		    i386|x86_64)
			AC_CACHE_CHECK([if compiler accepts -arch x86_64 flag],
				tcl_cv_cc_arch_x86_64, [
			    hold_cflags=$CFLAGS
			    CFLAGS="$CFLAGS -arch x86_64"
			    AC_LINK_IFELSE([AC_LANG_PROGRAM([[]], [[]])],
				    [tcl_cv_cc_arch_x86_64=yes],[tcl_cv_cc_arch_x86_64=no])
			    CFLAGS=$hold_cflags])
			AS_IF([test $tcl_cv_cc_arch_x86_64 = yes], [
			    CFLAGS="$CFLAGS -arch x86_64"
			    do64bit_ok=yes
			]);;
		    arm64|arm64e)
			AC_CACHE_CHECK([if compiler accepts -arch arm64e flag],
				tcl_cv_cc_arch_arm64e, [
			    hold_cflags=$CFLAGS
			    CFLAGS="$CFLAGS -arch arm64e"
			    AC_LINK_IFELSE([AC_LANG_PROGRAM([[]], [[]])],
				    [tcl_cv_cc_arch_arm64e=yes],[tcl_cv_cc_arch_arm64e=no])
			    CFLAGS=$hold_cflags])
			AS_IF([test $tcl_cv_cc_arch_arm64e = yes], [
			    CFLAGS="$CFLAGS -arch arm64e"
			    do64bit_ok=yes
			]);;
		    *)
			AC_MSG_WARN([Don't know how enable 64-bit on architecture `arch`]);;
		esac
	    ], [
		# Check for combined 32-bit and 64-bit fat build
		AS_IF([echo "$CFLAGS " |grep -E -q -- '-arch (ppc64|x86_64|arm64e) ' \
		    && echo "$CFLAGS " |grep -E -q -- '-arch (ppc|i386) '], [
		    fat_32_64=yes])
	    ])
	    SHLIB_LD='${CC} -dynamiclib ${CFLAGS} ${LDFLAGS}'
	    AC_CACHE_CHECK([if ld accepts -single_module flag], tcl_cv_ld_single_module, [
		hold_ldflags=$LDFLAGS
		LDFLAGS="$LDFLAGS -dynamiclib -Wl,-single_module"
		AC_LINK_IFELSE([AC_LANG_PROGRAM([[]], [[int i;]])],[tcl_cv_ld_single_module=yes],
		    [tcl_cv_ld_single_module=no])
		LDFLAGS=$hold_ldflags])
	    AS_IF([test $tcl_cv_ld_single_module = yes], [
		SHLIB_LD="${SHLIB_LD} -Wl,-single_module"
	    ])
	    SHLIB_SUFFIX=".dylib"
	    DL_OBJS="tclLoadDyld.o"
	    DL_LIBS=""
	    LDFLAGS="$LDFLAGS -headerpad_max_install_names"
	    AC_CACHE_CHECK([if ld accepts -search_paths_first flag],
		    tcl_cv_ld_search_paths_first, [
		hold_ldflags=$LDFLAGS
		LDFLAGS="$LDFLAGS -Wl,-search_paths_first"
		AC_LINK_IFELSE([AC_LANG_PROGRAM([[]], [[int i;]])],
			[tcl_cv_ld_search_paths_first=yes],
		    [tcl_cv_ld_search_paths_first=no])
		LDFLAGS=$hold_ldflags])
	    AS_IF([test $tcl_cv_ld_search_paths_first = yes], [
		LDFLAGS="$LDFLAGS -Wl,-search_paths_first"
	    ])
	    AS_IF([test "$tcl_cv_cc_visibility_hidden" != yes], [
		AC_DEFINE(MODULE_SCOPE, [__private_extern__],
		    [Compiler support for module scope symbols])
		tcl_cv_cc_visibility_hidden=yes
	    ])
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    LD_LIBRARY_PATH_VAR="DYLD_LIBRARY_PATH"
	    AC_DEFINE(MAC_OSX_TCL, 1, [Is this a Mac I see before me?])
	    PLAT_OBJS='${MAC_OSX_OBJS}'
	    PLAT_SRCS='${MAC_OSX_SRCS}'
	    AC_MSG_CHECKING([whether to use CoreFoundation])
	    AC_ARG_ENABLE(corefoundation,
		AS_HELP_STRING([--enable-corefoundation],
		    [use CoreFoundation API on MacOSX (default: on)]),
		[tcl_corefoundation=$enableval], [tcl_corefoundation=yes])
	    AC_MSG_RESULT([$tcl_corefoundation])
	    AS_IF([test $tcl_corefoundation = yes], [
		AC_CACHE_CHECK([for CoreFoundation.framework],
			tcl_cv_lib_corefoundation, [
		    hold_libs=$LIBS
		    AS_IF([test "$fat_32_64" = yes], [
			for v in CFLAGS CPPFLAGS LDFLAGS; do
			    # On Tiger there is no 64-bit CF, so remove 64-bit
			    # archs from CFLAGS et al. while testing for
			    # presence of CF. 64-bit CF is disabled in
			    # tclUnixPort.h if necessary.
			    eval 'hold_'$v'="$'$v'";'$v'="`echo "$'$v' "|sed -e "s/-arch ppc64 / /g" -e "s/-arch x86_64 / /g"`"'
			done])
		    LIBS="$LIBS -framework CoreFoundation"
		    AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <CoreFoundation/CoreFoundation.h>]],
			[[CFBundleRef b = CFBundleGetMainBundle();]])],
			[tcl_cv_lib_corefoundation=yes],
			[tcl_cv_lib_corefoundation=no])
		    AS_IF([test "$fat_32_64" = yes], [
			for v in CFLAGS CPPFLAGS LDFLAGS; do
			    eval $v'="$hold_'$v'"'
		        done])
		    LIBS=$hold_libs])
		AS_IF([test $tcl_cv_lib_corefoundation = yes], [
		    LIBS="$LIBS -framework CoreFoundation"
		    AC_DEFINE(HAVE_COREFOUNDATION, 1,
			[Do we have access to Darwin CoreFoundation.framework?])
		], [tcl_corefoundation=no])
		AS_IF([test "$fat_32_64" = yes -a $tcl_corefoundation = yes],[
		    AC_CACHE_CHECK([for 64-bit CoreFoundation],
			    tcl_cv_lib_corefoundation_64, [
			for v in CFLAGS CPPFLAGS LDFLAGS; do
			    eval 'hold_'$v'="$'$v'";'$v'="`echo "$'$v' "|sed -e "s/-arch ppc / /g" -e "s/-arch i386 / /g"`"'
			done
			AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <CoreFoundation/CoreFoundation.h>]],
			    [[CFBundleRef b = CFBundleGetMainBundle();]])],
			    [tcl_cv_lib_corefoundation_64=yes],
			    [tcl_cv_lib_corefoundation_64=no])
			for v in CFLAGS CPPFLAGS LDFLAGS; do
			    eval $v'="$hold_'$v'"'
			done])
		    AS_IF([test $tcl_cv_lib_corefoundation_64 = no], [
			AC_DEFINE(NO_COREFOUNDATION_64, 1,
			    [Is Darwin CoreFoundation unavailable for 64-bit?])
                        LDFLAGS="$LDFLAGS -Wl,-no_arch_warnings"
		    ])
		])
	    ])
	    ;;
	NEXTSTEP-*)
	    SHLIB_CFLAGS=""
	    SHLIB_LD='${CC} -nostdlib -r'
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadNext.o"
	    DL_LIBS=""
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	OS/390-*)
	    SHLIB_LD_LIBS=""
	    CFLAGS_OPTIMIZE=""		# Optimizer is buggy
	    AC_DEFINE(_OE_SOCKETS, 1,	# needed in sys/socket.h
		[Should OS/390 do the right thing with sockets?])
	    ;;
	OSF1-1.0|OSF1-1.1|OSF1-1.2)
	    # OSF/1 1.[012] from OSF, and derivatives, including Paragon OSF/1
	    SHLIB_CFLAGS=""
	    # Hack: make package name same as library name
	    SHLIB_LD='ld -R -export $@:'
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadOSF.o"
	    DL_LIBS=""
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	OSF1-1.*)
	    # OSF/1 1.3 from OSF using ELF, and derivatives, including AD2
	    SHLIB_CFLAGS="-fPIC"
	    AS_IF([test "$SHARED_BUILD" = 1], [SHLIB_LD="ld -shared"], [
	        SHLIB_LD="ld -non_shared"
	    ])
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	OSF1-V*)
	    # Digital OSF/1
	    SHLIB_CFLAGS=""
	    AS_IF([test "$SHARED_BUILD" = 1], [
	        SHLIB_LD='${CC} -shared'
	    ], [
	        SHLIB_LD='${CC} -non_shared'
	    ])
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    AS_IF([test $doRpath = yes], [
		CC_SEARCH_FLAGS='"-Wl,-rpath,${LIB_RUNTIME_DIR}"'
		LD_SEARCH_FLAGS='-rpath ${LIB_RUNTIME_DIR}'])
	    AS_IF([test "$GCC" = yes], [CFLAGS="$CFLAGS -mieee"], [
		CFLAGS="$CFLAGS -DHAVE_TZSET -std1 -ieee"])
	    # see pthread_intro(3) for pthread support on osf1, k.furukawa
	    AS_IF([test "${TCL_THREADS}" = 1], [
		CFLAGS="$CFLAGS -DHAVE_PTHREAD_ATTR_SETSTACKSIZE"
		CFLAGS="$CFLAGS -DTCL_THREAD_STACK_MIN=PTHREAD_STACK_MIN*64"
		LIBS=`echo $LIBS | sed s/-lpthreads//`
		AS_IF([test "$GCC" = yes], [
		    LIBS="$LIBS -lpthread -lmach -lexc"
		], [
		    CFLAGS="$CFLAGS -pthread"
		    LDFLAGS="$LDFLAGS -pthread"
		])
	    ])
	    ;;
	QNX-6*)
	    # QNX RTP
	    # This may work for all QNX, but it was only reported for v6.
	    SHLIB_CFLAGS="-fPIC"
	    SHLIB_LD="ld -Bshareable -x"
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    # dlopen is in -lc on QNX
	    DL_LIBS=""
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	SCO_SV-3.2*)
	    # Note, dlopen is available only on SCO 3.2.5 and greater. However,
	    # this test works, since "uname -s" was non-standard in 3.2.4 and
	    # below.
	    AS_IF([test "$GCC" = yes], [
	    	SHLIB_CFLAGS="-fPIC -melf"
	    	LDFLAGS="$LDFLAGS -melf -Wl,-Bexport"
	    ], [
	    	SHLIB_CFLAGS="-Kpic -belf"
	    	LDFLAGS="$LDFLAGS -belf -Wl,-Bexport"
	    ])
	    SHLIB_LD="ld -G"
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS=""
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	SINIX*5.4*)
	    SHLIB_CFLAGS="-K PIC"
	    SHLIB_LD='${CC} -G'
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
	SunOS-4*)
	    SHLIB_CFLAGS="-PIC"
	    SHLIB_LD="ld"
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    CC_SEARCH_FLAGS='-L${LIB_RUNTIME_DIR}'
	    LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}

	    # SunOS can't handle version numbers with dots in them in library
	    # specs, like -ltcl7.5, so use -ltcl75 instead.  Also, it
	    # requires an extra version number at the end of .so file names.
	    # So, the library has to have a name like libtcl75.so.1.0

	    SHARED_LIB_SUFFIX='${TCL_TRIM_DOTS}.so${SHLIB_VERSION}'
	    UNSHARED_LIB_SUFFIX='${TCL_TRIM_DOTS}.a'
	    TCL_LIB_VERSIONS_OK=nodots
	    ;;
	SunOS-5.[[0-6]])
	    # Careful to not let 5.10+ fall into this case

	    # Note: If _REENTRANT isn't defined, then Solaris
	    # won't define thread-safe library routines.

	    AC_DEFINE(_REENTRANT, 1, [Do we want the reentrant OS API?])
	    AC_DEFINE(_POSIX_PTHREAD_SEMANTICS, 1,
		[Do we really want to follow the standard? Yes we do!])

	    SHLIB_CFLAGS="-KPIC"
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    AS_IF([test "$GCC" = yes], [
		SHLIB_LD='${CC} -shared'
		CC_SEARCH_FLAGS='-Wl,-R,${LIB_RUNTIME_DIR}'
		LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}
	    ], [
		SHLIB_LD="/usr/ccs/bin/ld -G -z text"
		CC_SEARCH_FLAGS='-R ${LIB_RUNTIME_DIR}'
		LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}
	    ])
	    ;;
	SunOS-5*)
	    # Note: If _REENTRANT isn't defined, then Solaris
	    # won't define thread-safe library routines.

	    AC_DEFINE(_REENTRANT, 1, [Do we want the reentrant OS API?])
	    AC_DEFINE(_POSIX_PTHREAD_SEMANTICS, 1,
		[Do we really want to follow the standard? Yes we do!])

	    SHLIB_CFLAGS="-KPIC"

	    # Check to enable 64-bit flags for compiler/linker
	    AS_IF([test "$do64bit" = yes], [
		arch=`isainfo`
		AS_IF([test "$arch" = "sparcv9 sparc"], [
		    AS_IF([test "$GCC" = yes], [
			AS_IF([test "`${CC} -dumpversion | awk -F. '{print [$]1}'`" -lt 3], [
			    AC_MSG_WARN([64bit mode not supported with GCC < 3.2 on $system])
			], [
			    do64bit_ok=yes
			    CFLAGS="$CFLAGS -m64 -mcpu=v9"
			    LDFLAGS="$LDFLAGS -m64 -mcpu=v9"
			    SHLIB_CFLAGS="-fPIC"
			])
		    ], [
			do64bit_ok=yes
			AS_IF([test "$do64bitVIS" = yes], [
			    CFLAGS="$CFLAGS -xarch=v9a"
			    LDFLAGS_ARCH="-xarch=v9a"
			], [
			    CFLAGS="$CFLAGS -xarch=v9"
			    LDFLAGS_ARCH="-xarch=v9"
			])
			# Solaris 64 uses this as well
			#LD_LIBRARY_PATH_VAR="LD_LIBRARY_PATH_64"
		    ])
		], [AS_IF([test "$arch" = "amd64 i386"], [
		    AS_IF([test "$GCC" = yes], [
			case $system in
			    SunOS-5.1[[1-9]]*|SunOS-5.[[2-9]][[0-9]]*)
				do64bit_ok=yes
				CFLAGS="$CFLAGS -m64"
				LDFLAGS="$LDFLAGS -m64";;
			    *)
				AC_MSG_WARN([64bit mode not supported with GCC on $system]);;
			esac
		    ], [
			do64bit_ok=yes
			case $system in
			    SunOS-5.1[[1-9]]*|SunOS-5.[[2-9]][[0-9]]*)
				CFLAGS="$CFLAGS -m64"
				LDFLAGS="$LDFLAGS -m64";;
			    *)
				CFLAGS="$CFLAGS -xarch=amd64"
				LDFLAGS="$LDFLAGS -xarch=amd64";;
			esac
		    ])
		], [AC_MSG_WARN([64bit mode not supported for $arch])])])
	    ])

	    #--------------------------------------------------------------------
	    # On Solaris 5.x i386 with the sunpro compiler we need to link
	    # with sunmath to get floating point rounding control
	    #--------------------------------------------------------------------
	    AS_IF([test "$GCC" = yes],[use_sunmath=no],[
		arch=`isainfo`
		AC_MSG_CHECKING([whether to use -lsunmath for fp rounding control])
		AS_IF([test "$arch" = "amd64 i386" -o "$arch" = "i386"], [
			AC_MSG_RESULT([yes])
			MATH_LIBS="-lsunmath $MATH_LIBS"
			AC_CHECK_HEADER(sunmath.h)
			use_sunmath=yes
			], [
			AC_MSG_RESULT([no])
			use_sunmath=no
		])
	    ])
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    AS_IF([test "$GCC" = yes], [
		SHLIB_LD='${CC} -shared'
		CC_SEARCH_FLAGS='-Wl,-R,${LIB_RUNTIME_DIR}'
		LD_SEARCH_FLAGS=${CC_SEARCH_FLAGS}
		AS_IF([test "$do64bit_ok" = yes], [
		    AS_IF([test "$arch" = "sparcv9 sparc"], [
			# We need to specify -static-libgcc or we need to
			# add the path to the sparv9 libgcc.
			SHLIB_LD="$SHLIB_LD -m64 -mcpu=v9 -static-libgcc"
			# for finding sparcv9 libgcc, get the regular libgcc
			# path, remove so name and append 'sparcv9'
			#v9gcclibdir="`gcc -print-file-name=libgcc_s.so` | ..."
			#CC_SEARCH_FLAGS="${CC_SEARCH_FLAGS},-R,$v9gcclibdir"
		    ], [AS_IF([test "$arch" = "amd64 i386"], [
			SHLIB_LD="$SHLIB_LD -m64 -static-libgcc"
		    ])])
		])
	    ], [
		AS_IF([test "$use_sunmath" = yes], [textmode=textoff],[textmode=text])
		case $system in
		    SunOS-5.[[1-9]][[0-9]]*|SunOS-5.[[7-9]])
			SHLIB_LD="\${CC} -G -z $textmode \${LDFLAGS}";;
		    *)
			SHLIB_LD="/usr/ccs/bin/ld -G -z $textmode";;
		esac
		CC_SEARCH_FLAGS='-Wl,-R,${LIB_RUNTIME_DIR}'
		LD_SEARCH_FLAGS='-R ${LIB_RUNTIME_DIR}'
	    ])
	    ;;
	UNIX_SV* | UnixWare-5*)
	    SHLIB_CFLAGS="-KPIC"
	    SHLIB_LD='${CC} -G'
	    SHLIB_LD_LIBS=""
	    SHLIB_SUFFIX=".so"
	    DL_OBJS="tclLoadDl.o"
	    DL_LIBS="-ldl"
	    # Some UNIX_SV* systems (unixware 1.1.2 for example) have linkers
	    # that don't grok the -Bexport option.  Test that it does.
	    AC_CACHE_CHECK([for ld accepts -Bexport flag], tcl_cv_ld_Bexport, [
		hold_ldflags=$LDFLAGS
		LDFLAGS="$LDFLAGS -Wl,-Bexport"
		AC_LINK_IFELSE([AC_LANG_PROGRAM([[]], [[int i;]])],[tcl_cv_ld_Bexport=yes],[tcl_cv_ld_Bexport=no])
	        LDFLAGS=$hold_ldflags])
	    AS_IF([test $tcl_cv_ld_Bexport = yes], [
		LDFLAGS="$LDFLAGS -Wl,-Bexport"
	    ])
	    CC_SEARCH_FLAGS=""
	    LD_SEARCH_FLAGS=""
	    ;;
    esac

    AS_IF([test "$do64bit" = yes -a "$do64bit_ok" = no], [
	AC_MSG_WARN([64bit support being disabled -- don't know magic for this platform])
    ])

    AS_IF([test "$do64bit" = yes -a "$do64bit_ok" = yes], [
	AC_DEFINE(TCL_CFG_DO64BIT, 1, [Is this a 64-bit build?])
    ])

dnl # Add any CPPFLAGS set in the environment to our CFLAGS, but delay doing so
dnl # until the end of configure, as configure's compile and link tests use
dnl # both CPPFLAGS and CFLAGS (unlike our compile and link) but configure's
dnl # preprocessing tests use only CPPFLAGS.
    AC_CONFIG_COMMANDS_PRE([CFLAGS="${CFLAGS} ${CPPFLAGS}"; CPPFLAGS=""])

    # Step 4: disable dynamic loading if requested via a command-line switch.

    AC_ARG_ENABLE(load,
	AS_HELP_STRING([--enable-load],
	    [allow dynamic loading and "load" command (default: on)]),
	[tcl_ok=$enableval], [tcl_ok=yes])
    AS_IF([test "$tcl_ok" = no], [DL_OBJS=""])

    AS_IF([test "x$DL_OBJS" != x], [BUILD_DLTEST="\$(DLTEST_TARGETS)"], [
	AC_MSG_WARN([Can't figure out how to do dynamic loading or shared libraries on this system.])
	SHLIB_CFLAGS=""
	SHLIB_LD=""
	SHLIB_SUFFIX=""
	DL_OBJS="tclLoadNone.o"
	DL_LIBS=""
	LDFLAGS="$LDFLAGS_ORIG"
	CC_SEARCH_FLAGS=""
	LD_SEARCH_FLAGS=""
	BUILD_DLTEST=""
    ])
    LDFLAGS="$LDFLAGS $LDFLAGS_ARCH"

    # If we're running gcc, then change the C flags for compiling shared
    # libraries to the right flags for gcc, instead of those for the
    # standard manufacturer compiler.

    AS_IF([test "$DL_OBJS" != "tclLoadNone.o" -a "$GCC" = yes], [
	case $system in
	    AIX-*) ;;
	    BSD/OS*) ;;
	    CYGWIN_*|MINGW32_*|MSYS_*) ;;
	    HP-UX*) ;;
	    Darwin-*) ;;
	    IRIX*) ;;
	    NetBSD-*|OpenBSD-*) ;;
	    OSF1-*) ;;
	    SCO_SV-3.2*) ;;
	    *) SHLIB_CFLAGS="-fPIC" ;;
	esac])

    AS_IF([test "$tcl_cv_cc_visibility_hidden" != yes], [
	AC_DEFINE(MODULE_SCOPE, [extern],
	    [No Compiler support for module scope symbols])
    ])

    AS_IF([test "$SHARED_LIB_SUFFIX" = ""], [
	SHARED_LIB_SUFFIX='${VERSION}${SHLIB_SUFFIX}'])
    AS_IF([test "$UNSHARED_LIB_SUFFIX" = ""], [
	UNSHARED_LIB_SUFFIX='${VERSION}.a'])
    DLL_INSTALL_DIR="\$(LIB_INSTALL_DIR)"

    AS_IF([test "${SHARED_BUILD}" = 1 -a "${SHLIB_SUFFIX}" != ""], [
        LIB_SUFFIX=${SHARED_LIB_SUFFIX}
        MAKE_LIB='${SHLIB_LD} -o [$]@ ${OBJS} ${LDFLAGS} ${SHLIB_LD_LIBS} ${TCL_SHLIB_LD_EXTRAS} ${TK_SHLIB_LD_EXTRAS} ${LD_SEARCH_FLAGS}'
        AS_IF([test "${SHLIB_SUFFIX}" = ".dll"], [
            INSTALL_LIB='$(INSTALL_LIBRARY) $(LIB_FILE) "$(BIN_INSTALL_DIR)/$(LIB_FILE)";if test -f $(LIB_FILE).a; then $(INSTALL_DATA) $(LIB_FILE).a "$(LIB_INSTALL_DIR)"; fi;'
            DLL_INSTALL_DIR="\$(BIN_INSTALL_DIR)"
        ], [
            INSTALL_LIB='$(INSTALL_LIBRARY) $(LIB_FILE) "$(LIB_INSTALL_DIR)/$(LIB_FILE)"'
        ])
    ], [
        LIB_SUFFIX=${UNSHARED_LIB_SUFFIX}

        AS_IF([test "$RANLIB" = ""], [
            MAKE_LIB='$(STLIB_LD) [$]@ ${OBJS}'
        ], [
            MAKE_LIB='${STLIB_LD} [$]@ ${OBJS} ; ${RANLIB} [$]@'
        ])
        INSTALL_LIB='$(INSTALL_LIBRARY) $(LIB_FILE) "$(LIB_INSTALL_DIR)/$(LIB_FILE)"'
    ])

    # Stub lib does not depend on shared/static configuration
    AS_IF([test "$RANLIB" = ""], [
        MAKE_STUB_LIB='${STLIB_LD} [$]@ ${STUB_LIB_OBJS}'
    ], [
        MAKE_STUB_LIB='${STLIB_LD} [$]@ ${STUB_LIB_OBJS} ; ${RANLIB} [$]@'
    ])
    INSTALL_STUB_LIB='$(INSTALL_LIBRARY) $(STUB_LIB_FILE) "$(LIB_INSTALL_DIR)/$(STUB_LIB_FILE)"'

    # Define TCL_LIBS now that we know what DL_LIBS is.
    # The trick here is that we don't want to change the value of TCL_LIBS if
    # it is already set when tclConfig.sh had been loaded by Tk.
    AS_IF([test "x${TCL_LIBS}" = x], [
        TCL_LIBS="${DL_LIBS} ${LIBS} ${MATH_LIBS}"])
    AC_SUBST(TCL_LIBS)

	# See if the compiler supports casting to a union type.
	# This is used to stop gcc from printing a compiler
	# warning when initializing a union member.

	AC_CACHE_CHECK(for cast to union support,
	    tcl_cv_cast_to_union,
	    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[]], [[
		  union foo { int i; double d; };
		  union foo f = (union foo) (int) 0;
	    ]])],
	    [tcl_cv_cast_to_union=yes],
	    [tcl_cv_cast_to_union=no])
	)
	if test "$tcl_cv_cast_to_union" = "yes"; then
	    AC_DEFINE(HAVE_CAST_TO_UNION, 1,
		    [Defined when compiler supports casting to union type.])
	fi
	hold_cflags=$CFLAGS; CFLAGS="$CFLAGS -fno-lto"
	AC_CACHE_CHECK(for working -fno-lto,
	    ac_cv_nolto,
	AC_COMPILE_IFELSE([AC_LANG_PROGRAM([])],
	    [ac_cv_nolto=yes],
	    [ac_cv_nolto=no])
	)
	CFLAGS=$hold_cflags
	if test "$ac_cv_nolto" = "yes" ; then
	    CFLAGS_NOLTO="-fno-lto"
	else
	    CFLAGS_NOLTO=""
	fi

    # FIXME: This subst was left in only because the TCL_DL_LIBS
    # entry in tclConfig.sh uses it. It is not clear why someone
    # would use TCL_DL_LIBS instead of TCL_LIBS.
    AC_SUBST(DL_LIBS)

    AC_SUBST(DL_OBJS)
    AC_SUBST(PLAT_OBJS)
    AC_SUBST(PLAT_SRCS)
    AC_SUBST(LDAIX_SRC)
    AC_SUBST(CFLAGS)
    AC_SUBST(CFLAGS_DEBUG)
    AC_SUBST(CFLAGS_OPTIMIZE)
    AC_SUBST(CFLAGS_WARNING)
    AC_SUBST(CFLAGS_NOLTO)

    AC_SUBST(LDFLAGS)
    AC_SUBST(LDFLAGS_DEBUG)
    AC_SUBST(LDFLAGS_OPTIMIZE)
    AC_SUBST(CC_SEARCH_FLAGS)
    AC_SUBST(LD_SEARCH_FLAGS)

    AC_SUBST(STLIB_LD)
    AC_SUBST(SHLIB_LD)
    AC_SUBST(TCL_SHLIB_LD_EXTRAS)
    AC_SUBST(TK_SHLIB_LD_EXTRAS)
    AC_SUBST(SHLIB_LD_LIBS)
    AC_SUBST(SHLIB_CFLAGS)
    AC_SUBST(SHLIB_SUFFIX)
    AC_DEFINE_UNQUOTED(TCL_SHLIB_EXT,"${SHLIB_SUFFIX}",
	[What is the default extension for shared libraries?])

    AC_SUBST(MAKE_LIB)
    AC_SUBST(MAKE_STUB_LIB)
    AC_SUBST(INSTALL_LIB)
    AC_SUBST(DLL_INSTALL_DIR)
    AC_SUBST(INSTALL_STUB_LIB)
    AC_SUBST(RANLIB)
])

#------------------------------------------------------------------------
# SC_PROG_TCLSH
#	Locate a tclsh shell installed on the system path. This macro
#	will only find a Tcl shell that already exists on the system.
#	It will not find a Tcl shell in the Tcl build directory or
#	a Tcl shell that has been installed from the Tcl build directory.
#	If a Tcl shell can't be located on the PATH, then TCLSH_PROG will
#	be set to "". Extensions should take care not to create Makefile
#	rules that are run by default and depend on TCLSH_PROG. An
#	extension can't assume that an executable Tcl shell exists at
#	build time.
#
# Arguments:
#	none
#
# Results:
#	Substitutes the following vars:
#		TCLSH_PROG
#------------------------------------------------------------------------

AC_DEFUN([SC_PROG_TCLSH], [
    AC_MSG_CHECKING([for tclsh])
    AC_CACHE_VAL(ac_cv_path_tclsh, [
	search_path=`echo ${PATH} | sed -e 's/:/ /g'`
	for dir in $search_path ; do
	    for j in `ls -r $dir/tclsh[[8-9]]* 2> /dev/null` \
		    `ls -r $dir/tclsh* 2> /dev/null` ; do
		if test x"$ac_cv_path_tclsh" = x ; then
		    if test -f "$j" ; then
			ac_cv_path_tclsh=$j
			break
		    fi
		fi
	    done
	done
    ])

    if test -f "$ac_cv_path_tclsh" ; then
	TCLSH_PROG="$ac_cv_path_tclsh"
	AC_MSG_RESULT([$TCLSH_PROG])
    else
	# It is not an error if an installed version of Tcl can't be located.
	TCLSH_PROG=""
	AC_MSG_RESULT([No tclsh found on PATH])
    fi
    AC_SUBST(TCLSH_PROG)
])

#------------------------------------------------------------------------
# SC_BUILD_TCLSH
#	Determine the fully qualified path name of the tclsh executable
#	in the Tcl build directory. This macro will correctly determine
#	the name of the tclsh executable even if tclsh has not yet
#	been built in the build directory. The build tclsh must be used
#	when running tests from an extension build directory. It is not
#	correct to use the TCLSH_PROG in cases like this.
#
# Arguments:
#	none
#
# Results:
#	Substitutes the following values:
#		BUILD_TCLSH
#------------------------------------------------------------------------

AC_DEFUN([SC_BUILD_TCLSH], [
    AC_MSG_CHECKING([for tclsh in Tcl build directory])
    BUILD_TCLSH="${TCL_BIN_DIR}"/tclsh
    AC_MSG_RESULT([$BUILD_TCLSH])
    AC_SUBST(BUILD_TCLSH)
])

#--------------------------------------------------------------------
# SC_CONFIG_MANPAGES
#
#	Decide whether to use symlinks for linking the manpages,
#	whether to compress the manpages after installation, and
#	whether to add a package name suffix to the installed
#	manpages to avoidfile name clashes.
#	If compression is enabled also find out what file name suffix
#	the given compression program is using.
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-man-symlinks
#		--enable-man-compression=PROG
#		--enable-man-suffix[=STRING]
#
#	Defines the following variable:
#
#	MAN_FLAGS -	The apropriate flags for installManPage
#			according to the user's selection.
#
#--------------------------------------------------------------------

AC_DEFUN([SC_CONFIG_MANPAGES], [
    AC_MSG_CHECKING([whether to use symlinks for manpages])
    AC_ARG_ENABLE(man-symlinks,
	AS_HELP_STRING([--enable-man-symlinks],
	    [use symlinks for the manpages (default: off)]),
	[test "$enableval" != "no" && MAN_FLAGS="$MAN_FLAGS --symlinks"],
	[enableval="no"])
    AC_MSG_RESULT([$enableval])

    AC_MSG_CHECKING([whether to compress the manpages])
    AC_ARG_ENABLE(man-compression,
	AS_HELP_STRING([--enable-man-compression=PROG],
	    [compress the manpages with PROG (default: off)]),
	[case $enableval in
	    yes) AC_MSG_ERROR([missing argument to --enable-man-compression]);;
	    no)  ;;
	    *)   MAN_FLAGS="$MAN_FLAGS --compress $enableval";;
	esac],
	[enableval="no"])
    AC_MSG_RESULT([$enableval])
    if test "$enableval" != "no"; then
	AC_MSG_CHECKING([for compressed file suffix])
	touch TeST
	$enableval TeST
	Z=`ls TeST* | sed 's/^....//'`
	rm -f TeST*
	MAN_FLAGS="$MAN_FLAGS --extension $Z"
	AC_MSG_RESULT([$Z])
    fi

    AC_MSG_CHECKING([whether to add a package name suffix for the manpages])
    AC_ARG_ENABLE(man-suffix,
	AS_HELP_STRING([--enable-man-suffix=STRING],
	    [use STRING as a suffix to manpage file names (default: no, AC_PACKAGE_NAME if enabled without specifying STRING)]),
	[case $enableval in
	    yes) enableval="AC_PACKAGE_NAME" MAN_FLAGS="$MAN_FLAGS --suffix $enableval";;
	    no)  ;;
	    *)   MAN_FLAGS="$MAN_FLAGS --suffix $enableval";;
	esac],
	[enableval="no"])
    AC_MSG_RESULT([$enableval])

    AC_SUBST(MAN_FLAGS)
])

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
		if test "`uname -s`" = "NetBSD" -a -f /etc/debian_version ; then
		    tcl_cv_sys_version=NetBSD-Debian
		fi
	    fi
	fi
    ])
    system=$tcl_cv_sys_version
])

#------------------------------------------------------------------------
# SC_ENABLE_SYMBOLS --
#
#	Specify if debugging symbols should be used.
#	Memory (TCL_MEM_DEBUG) and compile (TCL_COMPILE_DEBUG) debugging
#	can also be enabled.
#
# Arguments:
#	none
#
#	Requires the following vars to be set in the Makefile:
#		CFLAGS_DEBUG
#		CFLAGS_OPTIMIZE
#		LDFLAGS_DEBUG
#		LDFLAGS_OPTIMIZE
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-symbols
#
#	Defines the following vars:
#		CFLAGS_DEFAULT	Sets to $(CFLAGS_DEBUG) if true
#				Sets to $(CFLAGS_OPTIMIZE) if false
#		LDFLAGS_DEFAULT	Sets to $(LDFLAGS_DEBUG) if true
#				Sets to $(LDFLAGS_OPTIMIZE) if false
#------------------------------------------------------------------------

AC_DEFUN([SC_ENABLE_SYMBOLS], [
    AC_MSG_CHECKING([for build with symbols])
    AC_ARG_ENABLE(symbols,
	AS_HELP_STRING([--enable-symbols],
	    [build with debugging symbols (default: off)]),
	[tcl_ok=$enableval], [tcl_ok=no])
# FIXME: Currently, LDFLAGS_DEFAULT is not used, it should work like CFLAGS_DEFAULT.
    if test "$tcl_ok" = "no"; then
	CFLAGS_DEFAULT='$(CFLAGS_OPTIMIZE)'
	LDFLAGS_DEFAULT='$(LDFLAGS_OPTIMIZE)'
	AC_DEFINE(NDEBUG, 1, [Is no debugging enabled?])
	AC_MSG_RESULT([no])
	AC_DEFINE(TCL_CFG_OPTIMIZED, 1, [Is this an optimized build?])
    else
	CFLAGS_DEFAULT='$(CFLAGS_DEBUG)'
	LDFLAGS_DEFAULT='$(LDFLAGS_DEBUG)'
	if test "$tcl_ok" = "yes"; then
	    AC_MSG_RESULT([yes (standard debugging)])
	fi
    fi
    AC_SUBST(CFLAGS_DEFAULT)
    AC_SUBST(LDFLAGS_DEFAULT)

    if test "$tcl_ok" = "mem" -o "$tcl_ok" = "all"; then
	AC_DEFINE(TCL_MEM_DEBUG, 1, [Is memory debugging enabled?])
    fi

    ifelse($1,bccdebug,dnl Only enable 'compile' for the Tcl core itself
	if test "$tcl_ok" = "compile" -o "$tcl_ok" = "all"; then
	    AC_DEFINE(TCL_COMPILE_DEBUG, 1, [Is bytecode debugging enabled?])
	    AC_DEFINE(TCL_COMPILE_STATS, 1, [Are bytecode statistics enabled?])
	fi)

    if test "$tcl_ok" != "yes" -a "$tcl_ok" != "no"; then
	if test "$tcl_ok" = "all"; then
	    AC_MSG_RESULT([enabled symbols mem ]ifelse($1,bccdebug,[compile ])[debugging])
	else
	    AC_MSG_RESULT([enabled $tcl_ok debugging])
	fi
    fi
])

#--------------------------------------------------------------------
# SC_TCL_EARLY_FLAGS
#
#	Check for what flags are needed to be passed so the correct OS
#	features are available.
#
# Arguments:
#	None
#
# Results:
#
#	Might define the following vars:
#		_ISOC99_SOURCE
#		_LARGEFILE64_SOURCE
#		_LARGEFILE_SOURCE64
#
#--------------------------------------------------------------------

AC_DEFUN([SC_TCL_EARLY_FLAG],[
    AC_CACHE_VAL([tcl_cv_flag_]translit($1,[A-Z],[a-z]),
	AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[$2]], [[$3]])],
	    [tcl_cv_flag_]translit($1,[A-Z],[a-z])=no,[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[[#define ]$1[ 1
]$2]], [[$3]])],
	[tcl_cv_flag_]translit($1,[A-Z],[a-z])=yes,
	[tcl_cv_flag_]translit($1,[A-Z],[a-z])=no)]))
    if test ["x${tcl_cv_flag_]translit($1,[A-Z],[a-z])[}" = "xyes"] ; then
	AC_DEFINE($1, 1, [Add the ]$1[ flag when building])
	tcl_flags="$tcl_flags $1"
    fi
])

AC_DEFUN([SC_TCL_EARLY_FLAGS],[
    AC_MSG_CHECKING([for required early compiler flags])
    tcl_flags=""
    SC_TCL_EARLY_FLAG(_ISOC99_SOURCE,[#include <stdlib.h>],
	[char *p = (char *)strtoll; char *q = (char *)strtoull;])
    SC_TCL_EARLY_FLAG(_LARGEFILE64_SOURCE,[#include <sys/stat.h>],
	[struct stat64 buf; int i = stat64("/", &buf);])
    SC_TCL_EARLY_FLAG(_LARGEFILE_SOURCE64,[#include <sys/stat.h>],
	[char *p = (char *)open64;])
    if test "x${tcl_flags}" = "x" ; then
	AC_MSG_RESULT([none])
    else
	AC_MSG_RESULT([${tcl_flags}])
    fi
])

#--------------------------------------------------------------------
# SC_TCL_64BIT_FLAGS
#
#	Check for what is defined in the way of 64-bit features.
#
# Arguments:
#	None
#
# Results:
#
#	Might define the following vars:
#		TCL_WIDE_INT_IS_LONG
#		TCL_WIDE_INT_TYPE
#		HAVE_STRUCT_DIRENT64, HAVE_DIR64
#		HAVE_STRUCT_STAT64
#		HAVE_TYPE_OFF64_T
#
#--------------------------------------------------------------------

AC_DEFUN([SC_TCL_64BIT_FLAGS], [
    AC_MSG_CHECKING([for 64-bit integer type])
    AC_CACHE_VAL(tcl_cv_type_64bit,[
	tcl_cv_type_64bit=none
	# See if the compiler knows natively about __int64
	AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[]], [[__int64 value = (__int64) 0;]])],
	    [tcl_type_64bit=__int64], [tcl_type_64bit="long long"])
	# See if we should use long anyway  Note that we substitute in the
	# type that is our current guess for a 64-bit type inside this check
	# program, so it should be modified only carefully...
        AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[]], [[switch (0) {
            case 1: case (sizeof(${tcl_type_64bit})==sizeof(long)): ;
        }]])],[tcl_cv_type_64bit=${tcl_type_64bit}],[])])
    if test "${tcl_cv_type_64bit}" = none ; then
	AC_DEFINE(TCL_WIDE_INT_IS_LONG, 1, [Are wide integers to be implemented with C 'long's?])
	AC_MSG_RESULT([using long])
    else
	AC_DEFINE_UNQUOTED(TCL_WIDE_INT_TYPE,${tcl_cv_type_64bit},
	    [What type should be used to define wide integers?])
	AC_MSG_RESULT([${tcl_cv_type_64bit}])

	# Now check for auxiliary declarations
	AC_CACHE_CHECK([for struct dirent64], tcl_cv_struct_dirent64,[
	    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>
#include <dirent.h>]], [[struct dirent64 p;]])],
		[tcl_cv_struct_dirent64=yes],[tcl_cv_struct_dirent64=no])])
	if test "x${tcl_cv_struct_dirent64}" = "xyes" ; then
	    AC_DEFINE(HAVE_STRUCT_DIRENT64, 1, [Is 'struct dirent64' in <sys/types.h>?])
	fi

	AC_CACHE_CHECK([for DIR64], tcl_cv_DIR64,[
	    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>
#include <dirent.h>]], [[struct dirent64 *p; DIR64 d = opendir64(".");
            p = readdir64(d); rewinddir64(d); closedir64(d);]])],
		[tcl_cv_DIR64=yes], [tcl_cv_DIR64=no])])
	if test "x${tcl_cv_DIR64}" = "xyes" ; then
	    AC_DEFINE(HAVE_DIR64, 1, [Is 'DIR64' in <sys/types.h>?])
	fi

	AC_CACHE_CHECK([for struct stat64], tcl_cv_struct_stat64,[
	    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/stat.h>]], [[struct stat64 p;
]])],
		[tcl_cv_struct_stat64=yes], [tcl_cv_struct_stat64=no])])
	if test "x${tcl_cv_struct_stat64}" = "xyes" ; then
	    AC_DEFINE(HAVE_STRUCT_STAT64, 1, [Is 'struct stat64' in <sys/stat.h>?])
	fi

	AC_CHECK_FUNCS(open64 lseek64)
	AC_MSG_CHECKING([for off64_t])
	AC_CACHE_VAL(tcl_cv_type_off64_t,[
	    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>]], [[off64_t offset;
]])],
		[tcl_cv_type_off64_t=yes], [tcl_cv_type_off64_t=no])])
	dnl Define HAVE_TYPE_OFF64_T only when the off64_t type and the
	dnl functions lseek64 and open64 are defined.
	if test "x${tcl_cv_type_off64_t}" = "xyes" && \
	        test "x${ac_cv_func_lseek64}" = "xyes" && \
	        test "x${ac_cv_func_open64}" = "xyes" ; then
	    AC_DEFINE(HAVE_TYPE_OFF64_T, 1, [Is off64_t in <sys/types.h>?])
	    AC_MSG_RESULT([yes])
	else
	    AC_MSG_RESULT([no])
	fi
    fi
])

#------------------------------------------------------------------------
# SC_ENABLE_SHARED --
#
#	Allows the building of shared libraries
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-shared=yes|no
#
#	Defines the following vars:
#		STATIC_BUILD	Used for building import/export libraries
#				on Windows.
#
#	Sets the following vars:
#		SHARED_BUILD	Value of 1 or 0
#------------------------------------------------------------------------

AC_DEFUN([SC_ENABLE_SHARED], [
    AC_MSG_CHECKING([how to build libraries])
    AC_ARG_ENABLE(shared,
	AS_HELP_STRING([--enable-shared],
	    [build and link with shared libraries (default: on)]),
	[tcl_ok=$enableval], [tcl_ok=yes])
    if test "$tcl_ok" = "yes" ; then
	AC_MSG_RESULT([shared])
	SHARED_BUILD=1
    else
	AC_MSG_RESULT([static])
	SHARED_BUILD=0
	AC_DEFINE(STATIC_BUILD, 1, [Is this a static build?])
    fi
    AC_SUBST(SHARED_BUILD)
])

#------------------------------------------------------------------------
# SC_ENABLE_THREADS --
#
#	Specify if thread support should be enabled
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-threads
#
#	Sets the following vars:
#		THREADS_LIBS	Thread library(s)
#
#	Defines the following vars:
#		TCL_THREADS
#		_REENTRANT
#		_THREAD_SAFE
#
#------------------------------------------------------------------------

AC_DEFUN([SC_ENABLE_THREADS], [
    AC_ARG_ENABLE(threads,
	AS_HELP_STRING([--enable-threads],
	    [build with threads (default: on)]),
	[tcl_ok=$enableval], [tcl_ok=yes])

    if test "${TCL_THREADS}" = 1; then
	tcl_threaded_core=1;
    fi

    if test "$tcl_ok" = "yes" -o "${TCL_THREADS}" = 1; then
	TCL_THREADS=1
	# USE_THREAD_ALLOC tells us to try the special thread-based
	# allocator that significantly reduces lock contention
	AC_DEFINE(USE_THREAD_ALLOC, 1,
	    [Do we want to use the threaded memory allocator?])
	AC_DEFINE(_REENTRANT, 1, [Do we want the reentrant OS API?])
	if test "`uname -s`" = "SunOS" ; then
	    AC_DEFINE(_POSIX_PTHREAD_SEMANTICS, 1,
		    [Do we really want to follow the standard? Yes we do!])
	fi
	AC_DEFINE(_THREAD_SAFE, 1, [Do we want the thread-safe OS API?])
	AC_CHECK_LIB(pthread,pthread_mutex_init,tcl_ok=yes,tcl_ok=no)
	if test "$tcl_ok" = "no"; then
	    # Check a little harder for __pthread_mutex_init in the same
	    # library, as some systems hide it there until pthread.h is
	    # defined.  We could alternatively do an AC_TRY_COMPILE with
	    # pthread.h, but that will work with libpthread really doesn't
	    # exist, like AIX 4.2.  [Bug: 4359]
	    AC_CHECK_LIB(pthread, __pthread_mutex_init,
		tcl_ok=yes, tcl_ok=no)
	fi

	if test "$tcl_ok" = "yes"; then
	    # The space is needed
	    THREADS_LIBS=" -lpthread"
	else
	    AC_CHECK_LIB(pthreads, pthread_mutex_init,
		tcl_ok=yes, tcl_ok=no)
	    if test "$tcl_ok" = "yes"; then
		# The space is needed
		THREADS_LIBS=" -lpthreads"
	    else
		AC_CHECK_LIB(c, pthread_mutex_init,
		    tcl_ok=yes, tcl_ok=no)
		if test "$tcl_ok" = "no"; then
		    AC_CHECK_LIB(c_r, pthread_mutex_init,
			tcl_ok=yes, tcl_ok=no)
		    if test "$tcl_ok" = "yes"; then
			# The space is needed
			THREADS_LIBS=" -pthread"
		    else
			TCL_THREADS=0
			AC_MSG_WARN([Don't know how to find pthread lib on your system - you must disable thread support or edit the LIBS in the Makefile...])
		    fi
		fi
	    fi
	fi

	# Does the pthread-implementation provide
	# 'pthread_attr_setstacksize' ?

	ac_saved_libs=$LIBS
	LIBS="$LIBS $THREADS_LIBS"
	AC_CHECK_FUNCS(pthread_attr_setstacksize pthread_atfork)
	LIBS=$ac_saved_libs
    else
	TCL_THREADS=0
    fi
    # Do checking message here to not mess up interleaved configure output
    AC_MSG_CHECKING([for building with threads])
    if test "${TCL_THREADS}" = 1; then
	AC_DEFINE(TCL_THREADS, 1, [Are we building with threads enabled?])
	if test "${tcl_threaded_core}" = 1; then
	    AC_MSG_RESULT([yes (threaded core)])
	else
	    AC_MSG_RESULT([yes])
	fi
    else
	AC_MSG_RESULT([no])
    fi

    AC_SUBST(TCL_THREADS)
])

#------------------------------------------------------------------------
# SC_ENABLE_FRAMEWORK --
#
#	Allows the building of shared libraries into frameworks
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-framework=yes|no
#
#	Sets the following vars:
#		FRAMEWORK_BUILD	Value of 1 or 0
#------------------------------------------------------------------------

AC_DEFUN([SC_ENABLE_FRAMEWORK], [
    if test "`uname -s`" = "Darwin" ; then
	AC_MSG_CHECKING([how to package libraries])
	AC_ARG_ENABLE(framework,
	    AS_HELP_STRING([--enable-framework],
		[package shared libraries in MacOSX frameworks (default: off)]),
	    [enable_framework=$enableval], [enable_framework=no])
	if test $enable_framework = yes; then
	    if test $SHARED_BUILD = 0; then
		AC_MSG_WARN([Frameworks can only be built if --enable-shared is yes])
		enable_framework=no
	    fi
	    if test $tcl_corefoundation = no; then
		AC_MSG_WARN([Frameworks can only be used when CoreFoundation is available])
		enable_framework=no
	    fi
	fi
	if test $enable_framework = yes; then
	    AC_MSG_RESULT([framework])
	    FRAMEWORK_BUILD=1
	else
	    if test $SHARED_BUILD = 1; then
		AC_MSG_RESULT([shared library])
	    else
		AC_MSG_RESULT([static library])
	    fi
	    FRAMEWORK_BUILD=0
	fi
    fi
])

#------------------------------------------------------------------------
# SC_BUILD_ENV --
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

AC_DEFUN([SC_BUILD_ENV], [
    AC_MSG_CHECKING([whether to override TCL_LIBRARY environment variable])
    AC_ARG_WITH(buildenv,
	AC_HELP_STRING([--with-buildenv],
	    [override the build environment variable (default: TCL_LIBRARY)]),
	with_buildenv="${withval}")

    if test x"${with_buildenv}" != x ; then
	SC_BUILD_ENV_VARIABLE="${with_buildenv}"
    else
	SC_BUILD_ENV_VARIABLE="TCL_LIBRARY"
    fi
    export SC_BUILD_ENV_VARIABLE
    SC_BUILD_ENV_SUFFIX=`echo ${SC_BUILD_ENV_VARIABLE}_ | tr A-Z a-z`
    export SC_BUILD_ENV_SUFFIX
    AC_MSG_RESULT([now: ${SC_BUILD_ENV_VARIABLE}])
    AC_SUBST(SC_BUILD_ENV_VARIABLE)
    AC_SUBST(SC_BUILD_ENV_SUFFIX)
])

#------------------------------------------------------------------------
# SC_ROOT_ENV --
#
#	Allows the setting of a root environment variable from the
#	command line so Tcl can be called recursively from other
#	repositories
#
# Arguments:
#	The name of the root environment variable
#
# Results:
#
#	Adds the following arguments to configure:
#		--with-buildroot=value
#
#	If not set, given sets it to value of UTDTOOLS
#------------------------------------------------------------------------
AC_DEFUN([SC_ROOT_ENV], [
    AC_MSG_CHECKING([whether to override Tcl root environment variable])
    AC_ARG_WITH(buildroot,
	AC_HELP_STRING([--with-buildroot],
	    [override the root environment variable (default: UTDTOOLS)]),
	with_buildroot="${withval}")

    if test x"${with_buildroot}" != x ; then
	SC_ROOT_ENV_VARIABLE="${with_buildroot}"
    else
	SC_ROOT_ENV_VARIABLE=${UTDTOOLS}
    fi
    export SC_ROOT_ENV_VARIABLE
    AC_MSG_RESULT([now: ${SC_ROOT_ENV_VARIABLE}])
    AC_SUBST(SC_ROOT_ENV_VARIABLE)
])
