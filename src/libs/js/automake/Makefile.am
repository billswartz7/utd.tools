## Process this file with automake to produce Makefile.in


lib_LTLIBRARIES = lib@UTDTOOLS_BUILD_ENV_SUFFIX@js.la 
lib@UTDTOOLS_BUILD_ENV_SUFFIX@js_la_SOURCES = \
	src/prarena.c \
	src/prassert.c \
	src/prdtoa.c \
	src/prhash.c \
	src/prlog2.c \
	src/prlong.c \
	src/prprintf.c \
	src/prtime.c \
	src/jsapi.c \
	src/jsarray.c \
	src/jsatom.c \
	src/jsbool.c \
	src/jscntxt.c \
	src/jsdate.c \
	src/jsdbgapi.c \
	src/jsemit.c \
	src/jsfun.c \
	src/jsgc.c \
	src/js.c \
	src/jsinterp.c \
	src/jslock.c \
	src/jsmath.c \
	src/jsnum.c \
	src/jsobj.c \
	src/jsopcode.c \
	src/jsparse.c \
	src/jsregexp.c \
	src/jsscan.c \
	src/jsscope.c \
	src/jsscript.c \
	src/jsstr.c \
	src/jsxdrapi.c

lib@UTDTOOLS_BUILD_ENV_SUFFIX@js_la_LDFLAGS = -version-info 1:0:0

ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.\
	-I@abs_builddir@/src \
        -I@abs_top_builddir@/../../utd/automake/src \
	-I@abs_srcdir@/src \
	-I@UTDTOOLS_ROOT_ENV_VARIABLE@/include

# Need to store off config data for other programs
# Now done in top level configure.

AM_CFLAGS = -g $(X_CFLAGS) -DDEBUG -D@CPU_OS@ -DXP_UNIX -DSVR4 -DSYSV -D_BSD_SOURCE -DPOSIX_SOURCE -DJSFILE

AM_CXXFLAGS = -g $(X_CFLAGS)

CC=@MCC@

clean-local:
	-rm -rf *~ autom4* *.dSYM

distclean-local:
	-rm -rf .deps
