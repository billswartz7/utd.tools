/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    debug.h
DESCRIPTION:Conditionally compile in debug statements.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_DEBUG_H
#define INCLUDED_UTD_DEBUG_H

#ifdef DEBUG

#include <utd/msg.h>

/* ---------------------------------------------------------------
   The assertions differ from the D macro in that the test is
   always executed in an assertion whereas the function part of
   the D macro is executed depending whether the given routine name
   has been turned on in the dbg file.
   NOTE NOW test_xc ***** MUST BE ON THE SAME LINE ******* or a
   compile error occurs.  A alternate solution to allow multiple
   lines is the explicit enumeration of \ as a continuation character.
----------------------------------------------------------------- */

#define D(name_xz, func_xz) if(utDdebug(name_xz)) { func_xz ; }
#define DS(name_xz)  { name_xz }
#define DBG(func_xz)  if(utDdebugAssert()) { func_xz ; }
#define DBGDEFINE(func_xz)  func_xz
#define DBGSTRING(x_xz) #x_xz

/* ***************** ASSERT MACROS ********************************/
/* NORMAL ASSERT - if not true, output message */
#define ASSERT(test_xz,routine_xz,userMsg_xz) \
do {if (utDdebugAssert()) {\
  if (!(test_xz)) {\
    utDmsgf(ERRMSG,MSG_AT,routine_xz,\
	"Assertion ( %s ) failed in file %s, line %d:\n\t",\
	DBGSTRING(test_xz), __FILE__, __LINE__ ) ;\
    if( userMsg_xz ){ \
      utDmsgf(ERRMSG,MSG_AT,NULL,userMsg_xz) ;\
    }\
  }\
}} while(0);

/* ASSERT and if not true break */
#define ASSERTNBREAK(test_xz,routine_xz,userMsg_xz) \
do {if (utDdebugAssert()) {\
  if (!(test_xz)) {\
    utDmsgf(ERRMSG,MSG_AT,routine_xz,\
	"Assertion ( %s ) failed in file %s, line %d:\n\t",\
	DBGSTRING(test_xz), __FILE__, __LINE__ ) ;\
    if( userMsg_xz ){ \
      utDmsgf(ERRMSG,MSG_AT,NULL,userMsg_xz) ;\
    }\
    break ;\
  }\
}} while(0) ;

/* ASSERT and if not true continue */
#define ASSERTNCONT(test_xz,routine_xz,userMsg_xz) \
do {if (utDdebugAssert()) {\
  if (!(test_xz)) {\
    utDmsgf(ERRMSG,MSG_AT,routine_xz,\
	"Assertion ( %s ) failed in file %s, line %d:\n\t",\
	DBGSTRING(test_xz), __FILE__, __LINE__ ) ;\
    if( userMsg_xz ){ \
      utDmsgf(ERRMSG,MSG_AT,NULL,userMsg_xz) ;\
    }\
    continue ;\
  }\
}} while(0) ;


/* ASSERT and if not true return */
#define ASSERTNRETURN(test_xz,routine_xz,userMsg_xz) \
do {if (utDdebugAssert()) {\
  if (!(test_xz)) {\
    utDmsgf(ERRMSG,MSG_AT,routine_xz,\
	"Assertion ( %s ) failed in file %s, line %d:\n\t",\
	DBGSTRING(test_xz), __FILE__, __LINE__ ) ;\
    if( userMsg_xz ){ \
      utDmsgf(ERRMSG,MSG_AT,NULL,userMsg_xz) ;\
    }\
    return ;\
  }\
}} while(0) ;

#define ASSERTNRETURN2(test_xz,routine_xz,userMsg_xz,retValue) \
do {if (utDdebugAssert()) {\
  if (!(test_xz)) {\
    utDmsgf(ERRMSG,MSG_AT,routine_xz,\
	"Assertion ( %s ) failed in file %s, line %d:\n\t",\
	DBGSTRING(test_xz), __FILE__, __LINE__ ) ;\
    if( userMsg_xz ){ \
      utDmsgf(ERRMSG,MSG_AT,NULL,userMsg_xz) ;\
    }\
    return((retValue)0) ;\
  }\
}} while(0) ;

/* ASSERT and if not true exit program thru cleanup handler */
#define ASSERTNFAULT(test_xz,routine_xz,userMsg_xz) \
do {if (utDdebugAssert()) {\
  if (!(test_xz)) {\
    utDmsgf(ERRMSG,MSG_AT,routine_xz,\
	"Assertion ( %s ) failed in file %s, line %d:\n\t",\
	DBGSTRING(test_xz), __FILE__, __LINE__ ) ;\
    if( userMsg_xz ){ \
      utDmsgf(ERRMSG,MSG_AT,NULL,userMsg_xz) ;\
    }\
    utDcleanupHandler( -1 ) ; \
  }\
}} while(0) ;


/* ASSERT and ask user if he wishes to continue otherwise abort */
#define ASSERTNQUERY(test_xz,routine_xz,userMsg_xz) \
do {if (utDdebugAssert()) {\
  if (!(test_xz)) {\
    char assertMsg_xz[LRECL] ; \
    utDmsgf(ERRMSG,MSG_AT,routine_xz,\
	"Assertion ( %s ) failed in file %s, line %d:\n\t",\
	DBGSTRING(test_xz), __FILE__, __LINE__ ) ;\
    if( userMsg_xz ){ \
      utDmsgf(ERRMSG,MSG_AT,NULL,userMsg_xz) ;\
    }\
    utDmsg(MSG,MSG_AT,NULL,"Do you wish to continue?") ;\
    scanf( "%s", assertMsg_xz );\
    if( assertMsg_xz[0] != 'Y' && assertMsg_xz[0] != 'y' ){\
      Yprogram_exit( PGMFAIL ) ; \
    }\
  }\
}} while(0) ;


/* ASSERT and if not true execute the function */
#define ASSERTNFUNC(test_xz,routine_xz,function_xz) \
do {if (utDdebugAssert()) {\
	if (!(test_xz)) {\
	    { function_xz \
}}}} while(0) ;

#define ASSERTALWAYS(test_xz,routine_xz,userMsg_xz) \
do {if (!(test_xz)) {\
    utDmsgf(ERRMSG,MSG_AT,routine_xz,\
	"Assertion ( %s ) failed in file %s, line %d:\n\t",\
	DBGSTRING(test_xz), __FILE__, __LINE__ ) ;\
    if( userMsg_xz ){ \
      utDmsgf(ERRMSG,MSG_AT,NULL,userMsg_xz) ;\
    }\
}} while(0);

/* -----------------------------------------------------------------
 * Definitions for debug assertions.
 * ----------------------------------------------------------------- */
#define PRECONDITION( cond_xz )\
  ASSERTALWAYS( (cond_xz), routine, "Precondition failed.\n" )

#define POSTCONDITION( cond_xz )\
  ASSERTALWAYS( (cond_xz), routine, "Post condition failed.\n" )


#else  /* remove debug code from source */

#define ASSERT(a_xz,b_xz,c_xz) 
#define ASSERTNBREAK(a_xz,b_xz,c_xz) 
#define ASSERTNCONT(a_xz,b_xz,c_xz) 
#define ASSERTNRETURN(a_xz,b_xz,c_xz) 
#define ASSERTNRETURN2(a_xz,b_xz,c_xz,d_xz) 
#define ASSERTNFAULT(a_xz,b_xz,c_xz) 
#define ASSERTNQUERY(a_xz,b_xz,c_xz) 
#define ASSERTNFUNC(a_xz,b_xz,c_xz) 
#define ASSERTALWAYS(a_xz,b_xz,c_xz)
#define PRECONDITION( cond_xz )
#define POSTCONDITION( cond_xz )
#define D(x_xz,func_xz)      
#define DS(name_xz)
#define DBG(func_xz)
#define DBGDEFINE(func_xz)

#endif  /* DEBUG */

/* now selectively delete either ASSERTIONS or PRINT */
#ifdef TURNOFFPRINTD

#undef  D      
#define D(x_xz,func_xz)      
#undef  DS      
#define DS(name_xz)
#undef  DBG      
#define DBG(func_xz)
#undef  DBGDEFINE      
#define DBGDEFINE(func_xz)

#endif  /* end TURNOFFPTRINTD */

#ifdef TURNOFFASSERT

#undef ASSERT
#undef ASSERTNBREAK
#undef ASSERTNCONT
#undef ASSERTNRETURN
#undef ASSERTNRETURN2
#undef ASSERTNFAULT
#undef ASSERTNQUERY
#undef ASSERTNFUNC
#undef ASSERTALWAYS(a_xz,b_xz,c_xz)

#define ASSERT(a_xz,b_xz,c_xz) 
#define ASSERTNBREAK(a_xz,b_xz,c_xz) 
#define ASSERTNCONT(a_xz,b_xz,c_xz) 
#define ASSERTNRETURN(a_xz,b_xz,c_xz) 
#define ASSERTNRETURN2(a_xz,b_xz,c_xz,d_xz) 
#define ASSERTNFAULT(a_xz,b_xz,c_xz) 
#define ASSERTNQUERY(a_xz,b_xz,c_xz) 
#define ASSERTNFUNC(a_xz,b_xz,c_xz) 
#define ASSERTALWAYS(a_xz,b_xz,c_xz)

#endif /* end TURNOFFASSERT */

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* ************** function prototypes ************** */
extern BOOL utDdebug( char *routine ) ;
/* 
Function:
    Return TRUE if the given routine has been turned on for debug.
    It returns FALSE otherwise.
*/

/* ASSERTIONS are always on */
extern BOOL utDdebugAssert( void ) ;
/* 
Function:
    Returns TRUE if debug is on.  It returns FALSE otherwise.
*/

extern void utDdebugWrite( void ) ;
/* 
Function:
    Write the debug data structure to a file.
*/

extern void utDdebug_init( BOOL flag ) ;
/* 
Function:
    Turn the debug functions on or off.  It will cause the evaluation
    of the dbg file in the current working directory.
*/
extern void utDcleanupHandler( INT status ) ;

#ifdef DEBUG
extern void ebreak(void) ;
extern void wbreak(void) ;
/* 
Function:
    Allows a stop in the debugger on errors/warnings.
*/

#endif /* DEBUG */

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* end INCLUDE_UTD_DEBUG_H */
