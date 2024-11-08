## Process this file with automake to produce Makefile.in

bin_PROGRAMS = utdbyacc

utdbyacc_SOURCES = \
	src/closure.c \
	src/dstring.c \
	src/error.c \
	src/lalr.c \
	src/lr0.c \
	src/main.c \
	src/mkpar.c \
	src/output.c \
	src/reader.c \
	src/skeleton.c \
	src/symtab.c \
	src/verbose.c \
	src/warshall.c 


ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.
		

AM_CFLAGS = -g $(X_CFLAGS)

AM_CXXFLAGS = -g $(X_CFLAGS) -DNDEBUG

distclean-local:
	        -rm -rf .deps

clean-local:
	        -rm -rf *~ autom4* *.dSYM
