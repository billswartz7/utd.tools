/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    dstring.h
DESCRIPTION:Definitions for dynamic strings.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_DSTRING_H
#define INCLUDED_UTD_DSTRING_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif /* HAVE_STDARG_H */

/* -----------------------------------------------------------------
 * This structure is stolen from Tcl.  It allows use of dynamics string
 * without requiring the Tcl libary.
----------------------------------------------------------------- */
#define UTD_DSTRING_STATIC_SIZE 200
typedef struct utd_dstring {
  char *string ;               /* Points to beginning of string:  either
			        * staticSpace below or a malloced array. */
  INT length ;                 /* Number of non-NULL characters in the
				* string. */
  INT spaceAvl ;               /* Total number of bytes available for the
			        * string and its terminating NULL char. */
  char staticSpace[UTD_DSTRING_STATIC_SIZE] ;
			       /* Space to use in common case where string
				* is small. */
} UTDDSTRING, *UTDDSTRINGPTR ;

/* -----------------------------------------------------------------
 * utDdstring_xxxx routines.  Used to manipulate dynamic strings.
----------------------------------------------------------------- */
extern void utDdstring_init(UTDDSTRINGPTR dsPtr) ;
extern char *utDdstring_append(UTDDSTRINGPTR dsPtr,const char *string,INT length) ;
extern char *utDdstring_append_char(UTDDSTRINGPTR dsPtr, char ch, BOOL end_flag ) ;
extern char *utDdstring_printf(UTDDSTRINGPTR dsPtr,const char *format, ... ) ;
extern char *utDdstring_setlength(UTDDSTRINGPTR dsPtr,INT length) ;
extern void utDdstring_free(UTDDSTRINGPTR dsPtr) ;
extern INT utDdstring_format_length( va_list args, const char *fmt ) ;
#define utDdstring_reinit(x_xz) utDdstring_setlength(x_xz,0) ;
#define utDdstring_value(x_xz) ((x_xz)->string)
#define utDdstring_space(x_xz) ((x_xz)->spaceAvl)
#define utDdstring_length(x_xz) ((x_xz)->length)

#ifdef DEBUG
extern void ebreak(void) ;
extern void wbreak(void) ;
extern void print_bitset(INT value) ;
extern void print_bitset64(INT64 value) ;
/* 
Function:
    Allows a stop in the debugger on errors/warnings.
*/
#endif /* DEBUG */

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_MSG_H */
