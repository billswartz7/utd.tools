## Process this file with automake to produce Makefile.in

bin_PROGRAMS = cometFlow

cometFlow_SOURCES = src/timestamp.c src/main.c

UTDTOOLSLIB = @prefix@/lib/${UTDTOOLSOS}

ALL_TK_LIBS = $(TCL_LIB_SPEC) @LIBS@ $(X11_LIB_SWITCHES) @TCL_LIBS@

if UTDTOOLS_STATIC_BUILD

if UTDTOOLS_GRAPHICS
GRAPHICS_LIBS = \
		$(UTDTOOLSLIB)/libutdtools_gui.a \
		$(UTDTOOLSLIB)/libutdtools_tix-static.a \
		$(UTDTOOLSLIB)/libutdtools_tkstub8.6.a \
		$(UTDTOOLSLIB)/libutdtools_tk8.6.a \
		@TK_LIBS@
else
GRAPHICS_LIBS =
endif

cometFlow_LDADD = \
		$(GRAPHICS_LIBS) \
		$(UTDTOOLSLIB)/libutdtools_blt.a \
		$(UTDTOOLSLIB)/libutdtools_tclstub8.6.a \
		$(UTDTOOLSLIB)/libutdtools_tcl8.6.a \
		$(UTDTOOLSLIB)/libutdtools_base.a \
		$(UTDTOOLSLIB)/libutd.a \
		@TCL_LIBS@
else

if UTDTOOLS_GRAPHICS
GRAPHICS_LIBS = \
		-lutdtools_gui \
		-lutdtools_tix \
		-lutdtools_tk8.6 \
		@TK_LIBS@
else
GRAPHICS_LIBS =
endif
cometFlow_LDADD = \
		-L$(UTDTOOLSLIB) \
		$(GRAPHICS_LIBS) \
		-lutdtools_blt \
		-lutdtools_tcl8.6 \
		-lutdtools_base \
		-lutd \
		@TCL_LIBS@
endif

ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.\
        -I@abs_top_builddir@/../../../libs/utd/automake/src \
	-I@abs_top_srcdir@/src \
	-I$(UTDTOOLS)/include
		

AM_CFLAGS = -g $(X_CFLAGS)

AM_CXXFLAGS = -g $(X_CFLAGS) -DNDEBUG

CC=@MCC@

timestamp.o : timestamp.c

timestamp.c : $(abs_builddir)/src/timestamp.h
	(cd $(abs_builddir)/src; $(UTDTOOLS)/bin/make_timestamp)

distclean-local:
	        -rm -rf .deps

clean-local:
	        -rm -rf *~ autom4* *.dSYM

install-data-hook:
	  (cd $(abs_srcdir)/.. ; tar cvf - scripts tcl | gzip -9 -c >${prefix}/pkg.tgz ) ; \
	  cd ${prefix}; \
	  test -f pkg.tgz && tar -xvzf pkg.tgz ; \
	  rm -f pkg.tgz ;
