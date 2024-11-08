/* ----------------------------------------------------------------- 
     Copyright (c) 2018 TimberWolf Systems, Inc. All rights reserved.
FILE:	    dstring.h
DESCRIPTION:Definitions for dynamic strings.
REVISIONS: 
 * $Log: dstring.h,v $
 * Revision 1.1  2019/01/25 13:52:02  bills
 * Initial revision
 *
 * Revision 1.1  2019/01/24 20:13:27  bill
 * Initial revision
 *
 * Revision 1.1  2018/07/24 14:50:55  bills
 * Initial revision
 *
----------------------------------------------------------------- */
#ifndef INCLUDED_DSTRING_H
#define INCLUDED_DSTRING_H

#include <stdarg.h>

typedef int INT ;
typedef int BOOL ;
typedef double DOUBLE ;
#define EOS 0
#define TRUE 1
#define FALSE 0

/* -----------------------------------------------------------------
 * This structure is stolen from Tcl.  It allows use of dynamics string
 * without requiring the Tcl libary.
----------------------------------------------------------------- */
#define YDSTRING_STATIC_SIZE 200
typedef struct ydstring_rec {
  char *string ;               /* Points to beginning of string:  either
			        * staticSpace below or a malloced array. */
  INT length ;                 /* Number of non-NULL characters in the
				* string. */
  INT spaceAvl ;               /* Total number of bytes available for the
			        * string and its terminating NULL char. */
  char staticSpace[YDSTRING_STATIC_SIZE] ;
			       /* Space to use in common case where string
				* is small. */
} YDSTRING, *YDSTRINGPTR ;

/* -----------------------------------------------------------------
 * Ydstring_xxxx routines.  Used to manipulate dynamic strings.
----------------------------------------------------------------- */
extern void Ydstring_init(YDSTRINGPTR dsPtr) ;
extern char *Ydstring_append(YDSTRINGPTR dsPtr,char *string,INT length) ;
extern char *Ydstring_printf(YDSTRINGPTR dsPtr,char *format, ... ) ;
extern char *Ydstring_setlength(YDSTRINGPTR dsPtr,INT length) ;
extern void Ydstring_free(YDSTRINGPTR dsPtr) ;
extern INT Ydstring_format_length( va_list args, char *fmt ) ;
#define Ydstring_reinit(x_xz) Ydstring_setlength(x_xz,0) ;
#define Ydstring_value(x_xz) ((x_xz)->string)
#define Ydstring_space(x_xz) ((x_xz)->spaceAvl)
#define Ydstring_length(x_xz) ((x_xz)->length)


#endif /* INCLUDED_YDSTRING_H */
