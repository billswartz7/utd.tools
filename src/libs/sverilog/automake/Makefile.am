## Process this file with automake to produce Makefile.in

lib_LTLIBRARIES = libutdtools_sverilog.la 
libutdtools_sverilog_la_SOURCES = \
	src/expr.c \
	src/preprocessor.c \
	src/sverilog_parser.c \
	src/sverilog_scanner.c

UTDTOOLSLIB = @prefix@/lib/${UTDTOOLSOS}

PRIVATE_HDRS = \
	preprocessor.h

PUBLIC_HDRS = \
	callbacks.h \
	expr.h \
	parse.h \
	sverilog.h

libutdtools_sverilog_la_LDFLAGS = -version-info 1:0:0

## EXTRA_PROGRAMS = utdtestparser

bin_PROGRAMS = utdtestparser

utdtestparser_SOURCES = src/main.c


if UTDTOOLS_STATIC_BUILD

utdtestparser_LDADD = \
		libutdtools_sverilog.la \
		$(UTDTOOLSLIB)/libutd.a \
		-lm

else

utdtestparser_LDADD = \
		libutdtools_sverilog.la \
		-L$(UTDTOOLSLIB) \
		-lutd \
		-lm

endif


ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.\
	-I@abs_top_srcdir@/src \
        -I@abs_top_builddir@/../../utd/automake/src \
        -I$(UTDTOOLS)/include


AM_CFLAGS = -g 

AM_CXXFLAGS = -g

CC=@MCC@

clean-local:
	-rm -rf *~ autom4* *.dSYM

install-data-hook:
	  mkdir -p ${prefix}/include/sverilog ; \
	  cd $(srcdir)/../include; tar cvf - $(PUBLIC_HDRS) | (cd ${prefix}/include/sverilog; tar xvf - ) ;

testpgms: $(EXTRA_PROGRAMS)
