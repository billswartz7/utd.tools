## Process this file with automake to produce Makefile.in


lib_LTLIBRARIES = lib@UTDTOOLS_BUILD_ENV_SUFFIX@gui.la
lib@UTDTOOLS_BUILD_ENV_SUFFIX@gui_la_SOURCES = src/tclcmds.c src/colors.c src/drawing.c \
                        src/open_gui.c src/open_cplus_gui.cxx src/utils.c
lib@UTDTOOLS_BUILD_ENV_SUFFIX@gui_la_LDFLAGS = -version-info 1:0:0

EXTRA_PROGRAMS = testgui testcplusgui

testgui_SOURCES = src/timestamp.c src/testgui.c

testcplusgui_SOURCES = src/timestamp.c src/testcplusgui.cxx

@UTDTOOLS_BUILD_ENV_VARIABLE@LIB = $(abs_top_builddir)/../../lib/$(@UTDTOOLS_BUILD_ENV_VARIABLE@OS)

ALL_TK_LIBS = $(TCL_LIB_SPEC) @LIBS@ $(X11_LIB_SWITCHES) @TCL_LIBS@

if UTDTOOLS_STATIC_BUILD
testgui_LDADD = \
		lib@UTDTOOLS_BUILD_ENV_SUFFIX@gui.la \
		../tix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix-static.la \
		../blt/lib@UTDTOOLS_BUILD_ENV_SUFFIX@blt.la \
		../tk/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tkstub8.6.a \
		../tcl/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tclstub8.6.a \
		../tk/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tk8.6.a \
		../tcl/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tcl8.6.a \
		../utd/.libs/libutd.a \
		@TK_LIBS@ \
		@TCL_LIBS@
else
testgui_LDADD = \
		-L@abs_builddir@/.libs -l@UTDTOOLS_BUILD_ENV_SUFFIX@gui \
		-L@abs_builddir@/../../tix/.libs -l@UTDTOOLS_BUILD_ENV_SUFFIX@tix \
		-L@abs_builddir@/../../blt/automake/.libs -l@UTDTOOLS_BUILD_ENV_SUFFIX@blt \
		-L@abs_builddir@/../../tk/unix -l@UTDTOOLS_BUILD_ENV_SUFFIX@tk8.6 \
		-L@abs_builddir@/../../tcl/unix -l@UTDTOOLS_BUILD_ENV_SUFFIX@tcl8.6 \
		-L@abs_builddir@/../../utd/automake/.libs -lutd \
		@TK_LIBS@ \
		@TCL_LIBS@
endif

if UTDTOOLS_STATIC_BUILD
testcplusgui_LDADD = \
		lib@UTDTOOLS_BUILD_ENV_SUFFIX@gui.la \
		../tix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tix-static.la \
		../blt/lib@UTDTOOLS_BUILD_ENV_SUFFIX@blt.la \
		../tk/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tkstub8.6.a \
		../tcl/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tclstub8.6.a \
		../tk/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tk8.6.a \
		../tcl/unix/lib@UTDTOOLS_BUILD_ENV_SUFFIX@tcl8.6.a \
		../utd/.libs/libutd.a \
		@TK_LIBS@ \
		@TCL_LIBS@
else
testcplusgui_LDADD = \
		-L$(@UTDTOOLS_BUILD_ENV_VARIABLE@LIB) \
		-l@UTDTOOLS_BUILD_ENV_SUFFIX@gui \
		-l@UTDTOOLS_BUILD_ENV_SUFFIX@tix \
		-l@UTDTOOLS_BUILD_ENV_SUFFIX@blt \
		-l@UTDTOOLS_BUILD_ENV_SUFFIX@tk8.6 \
		-l@UTDTOOLS_BUILD_ENV_SUFFIX@tcl8.6 \
		-lutd \
		@TK_LIBS@ \
		@TCL_LIBS@
endif

ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.\
	-I@abs_top_builddir@/src \
	-I@UTDTOOLSGUI_ROOT_ENV_VARIABLE@/include \
	-I@UTDTOOLSGUI_ROOT_ENV_VARIABLE@/include/tcl \
	-I@UTDTOOLSGUI_ROOT_ENV_VARIABLE@/include/tk
		

AM_CFLAGS = -g $(X_CFLAGS)

AM_CXXFLAGS = -g $(X_CFLAGS)

CC=@MCC@

clean-local:
	-rm -rf *~ autom4* *.dSYM timestamp.* ${srcdir}/timestamp.c

distclean-local:
	-rm -rf $(EXTRA_PROGRAMS)

${srcdir}/timestamp.c: make-time-stamp

make-time-stamp:
	make_timestamp
	test -f timestamp.c || cp timestamp.c ${srcdir}
	$(COMPILE) -c timestamp.c

testpgms: $(EXTRA_PROGRAMS)
