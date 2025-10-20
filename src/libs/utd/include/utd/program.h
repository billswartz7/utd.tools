/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    program.h
DESCRIPTION:Generalized program interface for C.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_PROGRAM_H
#define INCLUDED_UTD_PROGRAM_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* -----------------------------------------------------------------
 * The program exit codes.  Both PGMGABORT and PGMGCANCEL need to be
 * above the last signal number in the system. PGMGABORT and PGMGCANCEL
 * are used to signal a user sponsered termination.
----------------------------------------------------------------- */
typedef enum {
  PGMOK = 		0,
  PGMFAIL = 		1,
  PGMGABORT =		75, 	
  PGMGCANCEL =		76,
  PGMGABORTALL =	77,
  PGMSTATUSGIVEN  =	(1<<10)	/* don't change to exit failure */
} PGM_STATUS_T ;


#define PGM_LOG		1
#define PGM_NOLOG	0

extern char *utDdate_compiled(void) ;

extern char *utDprogram_init( const char *name, const char *version, const char *date, BOOL log ) ;
/*
Function:
    Returns string with program name, version, and compile date.
    This strings remains for life of program.  This routine also
    starts the elapsed timer.  We no longer support an initialization
    function. If log is true, then program is logged in .log file at exit.
*/

extern void utDprogram_exit( PGM_STATUS_T status ) ;
/* 
Function:
    Exit a program gracefully.  It always outputs a message with
    the number of errors and warnings during the execution.  A
    nonzero status means the execution failed.  Status follows the
    normal UNIX rules.  Exit program also calls the debug write
    function to create a dbg file if debug has been set.
*/

extern LONG utDprogram_elapsed_time( void ) ;
/* 
Function:
    Returns the time from start of program.
*/

extern void utDprogram_exitFunction( INT (*function)(INT status) ) ;
/* 
Function:
    Install a user exit function to be execute before the program exits.
*/

extern char *utDprogram_getName( void ) ;
/* 
Function:
    Returns the program name given in YinitProgram.
*/

extern char *utDprogram_setName( char *name ) ;
/* 
Function:
    Set the name of the program.
*/

extern char *utDprogram_getVersion(void) ;
/* 
Function:
    Returns the program version given in YinitProgram.
*/

extern char *utDprogram_getDate(void) ;
/* 
Function:
    Returns the program date given in YinitProgram.
*/

extern char *utDprogram_simplify_name( char *fullname, char *buffer ) ;
/* 
Function:
    Remove the slashes from name of the program to return the basename.
*/

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_PROGRAM_H */
