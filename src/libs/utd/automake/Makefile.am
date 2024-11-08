## Process this file with automake to produce Makefile.in


lib_LTLIBRARIES = libutd.la 
libutd_la_SOURCES = \
		    src/bitset.c \
		    src/debug.c \
		    src/deck.c \
		    src/dset.c \
		    src/cleanup.c \
		    src/dstring.c \
		    src/exec.c \
		    src/file.c \
		    src/grid.c \
		    src/hash.c \
		    src/log.c \
		    src/mempools.c \
		    src/mmap.c \
		    src/msg.c \
		    src/okmalloc.c \
		    src/path.c \
		    src/program.c \
		    src/prtable.c \
		    src/rand.c \
		    src/rbtree.c \
		    src/rint.c \
		    src/stats.c \
		    src/string.c \
		    src/stringhash.c \
		    src/system.c \
		    src/tcllog.c \
		    src/tile.c \
		    src/time.c \
		    src/timer.c 

# if UTDTOOLS_MEMDEBUG_BUILD
# libutd_la_SOURCES += src/memtrack.cxx
# endif


libutd_la_LDFLAGS = -version-info 1:0:0

ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I@abs_builddir@/src \
	-I@UTDTOOLS_INCLUDE_PATH@

# Need to store off config data for other programs
# Now done in top level configure.

AM_CFLAGS = -g $(X_CFLAGS) -DDEBUG

AM_CXXFLAGS = -g $(X_CFLAGS)

CC=@MCC@

distclean-local:
	-rm -rf .deps test.* mem.out
	
install-data-hook:
	cd ${abs_top_srcdir}; \
	tar chvf - include | (cd ${prefix}; tar xvf - ) ;
	(cd ${abs_builddir}/src;cp -f utdconfig.h ${prefix}/include/utd)

clean-local:
	-rm -rf *~ autom4* *.dSYM

distclean-local:
	-rm -rf config.recursive src/config.h include/utd/config.h libutd
