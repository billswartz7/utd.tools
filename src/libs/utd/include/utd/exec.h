/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    exec.h
DESCRIPTION:Generalized and common base definitions.
REVISIONS: Exec a job in the background using a pipes, etc.
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_EXEC_H
#define INCLUDED_UTD_EXEC_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef enum {
  UTDEXEC_OPT_NONE =		0,
  UTDEXEC_OPT_ABORT =		1,
  UTDEXEC_OPT_STDOUT =		(1L<<1),
  UTDEXEC_OPT_STDERR =		(1L<<2),
  UTDEXEC_OPT_STDIN =		(1L<<3),
  UTDEXEC_OPT_DETACH =		(1L<<4),
  UTDEXEC_OPT_FDS_OPEN =	(1L<<5),
  UTDEXEC_OPT_DEBUG =		(1L<<6)
} UTDEXEC_T ;

extern FILE *utDexec_pipe( char *command, UTDEXEC_T options, INT *pid ) ;
/* 
Function:
    Start a child process with a pipe to look at the output of
    the process.  Internally, a copy of the command is made.
    Abort flag will exit the program on an error. The pid is the
    child pid.
*/
extern FILE *_utDexec_pipe( char **argv, UTDEXEC_T options, INT *pid,
			    FILE ** fin) ;
/* 
Function:
    Primitive which uses argv instead of command.
*/

extern INT __utDexec_pipe( char **argv, UTDEXEC_T options, INT *pid,
		           FILE ** fin) ;
/* 
Function:
    Like _utDexec_pipe above but returns file descriptor instead of file pointer.
*/


extern INT utDexec_pipe_func( utDkey func,VOIDPTR clientData,UTDEXEC_T options,INT *child_pid,
		            FILE **fin ) ;
/* 
Function:
    Like __utDexec_pipe above but it executes a function in the child and then exits.
    The function returns an int which denotes error code.  The function takes clientData
    as a single argument.
*/

extern INT utDexec( char *command, UTDEXEC_T options ) ;
/* 
Function:
    Start a child process and return the processid.
    Abort flag will exit the program on an error. 
*/

extern INT _utDexec( char **argv, UTDEXEC_T options ) ;
/* 
Function:
    Argv version of the above command.
*/

extern char **utDexec_build_arg_vector( char *command ) ;
/* 
Function:
    Converts a string into an argument vector.
*/

extern void _utDexecp( char **argv, UTDEXEC_T options ) ;
/* 
Function:
    In the current process, exec a program using argument vector.
    Abort flag will exit the program on an error. 
*/

extern void utDexecp( char *command, UTDEXEC_T options ) ;
/* 
Function:
    In the current process, exec a program.
    Abort flag will exit the program on an error. 
*/


extern void utDexec_detach( UTDEXEC_T options ) ;
/* 
Function:
    Close off all connections to the controlling terminal.
*/

extern INT utDwait( INT *status ) ;
/* 
Function:
    System replacement for the wait statement.
*/

extern INT utDwaitpid( INT pid, INT *status, INT options ) ;
/* 
Function:
    System replacement for the waitpid function.
*/
#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_EXEC_H */
