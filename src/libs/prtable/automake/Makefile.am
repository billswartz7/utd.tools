## Process this file with automake to produce Makefile.in



lib_LTLIBRARIES = lib@UTDTOOLS_BUILD_ENV_SUFFIX@prtable.la 
lib@UTDTOOLS_BUILD_ENV_SUFFIX@prtable_la_SOURCES = src/tcltable.c

lib@UTDTOOLS_BUILD_ENV_SUFFIX@prtable_la_LDFLAGS = -version-info 1:0:0

UTDTOOLSLIB = @prefix@/lib/${UTDTOOLSOS}

lib@UTDTOOLS_BUILD_ENV_SUFFIX@prtable_la_LIBADD = \
  -L$(UTDTOOLSLIB) \
  -lutd 


ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.\
	-I@abs_srcdir@/src \
        -I@abs_top_builddir@/../../utd/automake/src \
	-I@UTDTOOLS_ROOT_ENV_VARIABLE@/include

# Need to store off config data for other programs
# Now done in top level configure.

AM_CFLAGS = -g $(X_CFLAGS) -DDEBUG

AM_CXXFLAGS = -g $(X_CFLAGS)

CC=@MCC@

clean-local:
	-rm -rf *~ autom4* *.dSYM

distclean-local:
	-rm -rf .deps
