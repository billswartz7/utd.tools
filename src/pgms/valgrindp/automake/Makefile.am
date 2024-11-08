## Process this file with automake to produce Makefile.in

bin_PROGRAMS = utdvalgrindp

utdvalgrindp_SOURCES = \
	src/valgrindp.c


ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.
		

AM_CFLAGS = -g $(X_CFLAGS) -I. -I$(UTDTOOLS)/include

AM_CXXFLAGS = -g $(X_CFLAGS) -DNDEBUG

UTDTOOLSLIB = @prefix@/lib/${UTDTOOLSOS}

if UTDTOOLS_STATIC_BUILD

utdvalgrindp_LDADD = \
		$(UTDTOOLSLIB)/libutd.a -lm
else

utdvalgrindp_LDADD = \
		-L$(UTDTOOLSLIB) \
		-lutd -lm
endif

distclean-local:
	        -rm -rf .deps

clean-local:
	        -rm -rf *~ autom4* *.dSYM


