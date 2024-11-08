/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    base.h
DESCRIPTION:Generalized and common base definitions.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_BASE_H
#define INCLUDED_UTD_BASE_H


/* ************************* TRY TO MAKE PORTABLE ************************** */
#ifndef FILE
# include <stdio.h>
#endif

#ifndef STDIN
# define STDIN   0
# define STDOUT  1
# define STDERR  2
#endif

#ifndef CONST
#  ifdef __ANSI_C__
#    define CONST		const
#  else
#    define CONST
#  endif
#endif

#ifndef NULL
#  define NULL		0
#endif

#ifndef MATH_H
#define MATH_H
#include <math.h> 
#endif

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* -------------------------------------------------------
 Use typedefs to make the code more portable.  User 
 just changes size here and all of the code will be 
 modified.  To avoid complaints in lint use defines 
 instead of typedefs. Typedefs are better for 
 errorchecking by the compiler.
---------------------------------------------------------- */
#if !(defined(lint)) || defined(WINDOZE)

typedef char  TBOOL ;
typedef int  BOOL ;
typedef int INT ;
typedef unsigned int UNSIGNED_INT ;
typedef unsigned long UNSIGNED_LONG ;
typedef short SHORT ;
typedef long LONG ;
typedef float FLOAT ;
/* INT32 guarantees 32 bits */
#if defined(__alpha) || defined(__arch64__) || defined(__x86_64__)
typedef unsigned short UINT16 ;
typedef short INT16 ;
typedef int INT32 ;
typedef unsigned int UINT32 ;
typedef long long int INT64 ;
typedef long long int INT_VOIDPTR ;		/* int same size as voidptr */
typedef unsigned long long int UINT64 ;
#define OPENTOOLS_64BITS
#else
typedef unsigned short UINT16 ;
typedef short INT16 ;
typedef long INT32 ;
typedef long INT_VOIDPTR ; 			/* int same size as voidptr */
typedef unsigned long UINT32 ;
typedef long long int INT64 ;
typedef unsigned long long int UINT64 ;
#endif /* __alpha */

/* typedef DOUBLE to have ability to change to float */
/* some machines float will be natural size.            */
typedef double DOUBLE ;

typedef void *VOIDPTR ;

/* -----------------------------------------------------------------
 * Could potentially change to FLOAT, but due to crippled cc/gcc on 
 RS/6000, no can do
 ----------------------------------------------------------------- */
typedef FLOAT FTYPE ;

#else  /* the lint case */

#define TBOOL char
#define BOOL  int
#define INT   int
#define LONG  long
#define UNSIGNED_INT unsigned int
#define UNSIGNED_LONG unsigned long
#define INT32 int
#define UINT32 unsigned int
#define SHORT short
#define FLOAT float
#define DOUBLE double
#define SHORT_LONG short
#define SHORT_INT short
typedef void *VOIDPTR  ;
#define VOID void
#define FTYPE float
#define UINT16 unsigned short
#define INT16 short
#define UINT32 unsigned int
#define INT32 int
#define UINT64 unsigned long long int 
#define INT64 long long int
typedef long long int INT_VOIDPTR ;	

#endif /* lint */

#define VOIDPTR_TYPE(x_xz)	( (VOIDPTR) (LONG) (x_xz) )

/* -----------------------------------------------------------------
    Typedef to make comparison functions and user-delete functions
    easier to use in debugger.
----------------------------------------------------------------- */
typedef INT  (*utDcompare)(void *,void *) ;
typedef INT  (*utDcompareClientData)(void *,void *,void *) ;
typedef INT  (*utDkey)(void *) ;
typedef INT  (*utDvoid)(void) ;
typedef void (*utDdelete)(void *) ;
typedef void (*utDdeleteClientData)(void *,void *) ;
typedef void (*utDdump)(void *) ;
typedef void (*utDdumpFile)(FILE *,void *) ;
typedef void (*utDdumpClientData)(void *,void *) ;
typedef void (*utDdumpFileClientData)(FILE *,void *,void *) ;

/* used to find when we didn't use the PORTABLE version */
#ifdef FIND_GARBAGE
#define int garbage
#define short garbage
#define long garbage
#define float garbage
#define double garbage
#endif /* FIND_GARBAGE */

/* -----------------------------------------------------------------
    If limits.h or float.h does not work, define NO_LIMITS_H and hack
    the definitions below.
----------------------------------------------------------------- */
#ifdef NO_LIMITS_H
#undef INT_MIN
#undef INT_MAX
#undef DBL_MAX

#define INT_MIN (-INT_MAX - 1)
#define INT_MAX  2147483647
#define DBL_MAX  1.0E38

#else  /* limits.h defined */

#include <limits.h>
/* see if we need to include float.h or its sun equivalent */
#ifndef DBL_MAX
#ifdef sun
#ifdef __STDC__
#include <float.h>
#else /*  normal case */
#include <floatingpoint.h>
#endif /* __STDC__ */
#else /* not a sun */
#include <float.h>
#endif /* sun */

#endif /* DBL_MAX */

#ifndef DBL_MAX
#define DBL_MAX		1.0E38
#endif /* DBL_MAX */

#endif /* NO_LIMITS_H */

/* -----------------------------------------------------------------
 * This is a definition for looking a DOUBLE's as integers.
 * This is 2^51 (mantissa is 52 in IEEE) take 51 to be conservative
----------------------------------------------------------------- */
#define DINT_MAX			( (DOUBLE) 2251799813685248.0 )
#define DINT_MIN			(-DINT_MAX)

#define	 ARGS(x)			()
#define  NOARGS				()

/* BASIC MACRO DEFINITIONS  */
#undef  TRUE
#undef  FALSE

#define YES   1
#define NO    0
#define TRUE  1
#define FALSE 0
#ifdef BUFSIZE
#define LRECL BUFSIZE
#else
#define LRECL 1023 /* set larger */  /* length of screen buffer */
#endif
#define STRINGEQ 0
#define EOS  '\0'
#define ZERO     0
#define SLASH		'\057'
#define BACKSLASH	'\134'
#define ASTERISK	'\052'
#define DQUOTE		'\042'
#define SQUOTE		'\047'

#define FUNC_NAME(x_xz)	const char *routine = x_xz

/* ************* USEFUL MACRO DEFINITIONS **************** */
#ifndef ABS
#define ABS(value)      ( (value)>=0 ? (value) : -(value) ) 
#endif  /* ABS */

#ifndef MAX
#define MAX(a,b) (((a)>(b))?(a):(b))
#endif  /* MAX */
#ifndef MIN
#define MIN(a,b) (((a)<(b))?(a):(b))
#endif  /* MIN */
#define SWAP(a,b,type_t)  { type_t temp ; temp = a ; a = b ; b = temp ; } 
#define FLOAT_EQ(x,y) (fabs(x-y) < 0.00001)



#ifdef __cplusplus
} ;
#endif /* __cplusplus */

/* Always include memory defintions */
#include <utd/okmalloc.h>
#include <utd/mempools.h>

#endif /* INCLUDED_UTD_BASE_H */
