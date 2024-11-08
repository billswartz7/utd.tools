/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    system.h
DESCRIPTION:definitions for system functions.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef YSYSTEM_H
#define YSYSTEM_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define UTDCLOSESOCKET(s_xz)		close(s_xz)

/*
Ysystem -
Function:
    An abstract interface to the system call.  The first argument is
    the name of the program to be executed.  It is used in the error
    message when the system call fails for some reason.  The second
    argument is whether to abort the program or not.  The third argument
    is the actual command that is to be processed.  The fourth argument
    is the function to call upon failure.  It has one argument- status.
    Ysystem return the system error code if failure; 0 otherwise.
    In addition, if abnormal_exit is supplied, then if the program exited
    to completion with a signal then we set abnormal_exit to false.
*/
extern INT utDsystem( char *program,BOOL abortFlag,char *exec_statement,
		      INT (*abort_func)(INT status), BOOL *abnormal_exit ) ;

/*
utDcopyFile -
Function:
    Copy a file from the source to the destination name.
    Aborts pgm if a failure. Returns status.
*/
extern INT utDcopyFile( char *sourcefile, char *destfile ) ;

/*
utDmoveFile -
Function:
    Move a file from the source to the destination name.
    Aborts pgm if a failure.  Returns status.
*/
extern INT utDmoveFile( char *sourcefile, char *destfile ) ;

/*
utDrm_files -
Function:
    Remove files from system.  Wildcards are available.  May be system
    dependent however.
    Never aborts pgm if a failure.  Returns status.
*/
extern INT utDrm_files( char *files ) ;

/*
utDgetenv -
Function:
    Interface to getenv system function.
*/
extern char *utDgetenv( const char *env_var ) ;

/*
utDsetenv -
Function:
    Interface to setenv system function.
*/
extern INT utDsetenv( const char *env_var, const char *value, BOOL overwrite ) ;

/*
utDgetpid -
Function:
    Finds the process id for current process.
*/
extern INT utDgetpid( void ) ;

/*
utDgetppid -
Function:
    Finds the parent process id for current process.
*/
extern INT utDgetppid( void ) ;

/*
utDhostname -
Function:
    Return a pointer to the current host name.
*/
extern char *utDhostname( void ) ;

/*
utDgethostbyname -
Function:
    Given a fully qualified hostname, return the official name of the host.
*/
extern char *utDgethostbyname( char *hostname ) ;

/*
utDgethostbynames -
Function:
    Given a fully qualified hostname, return the official name of the host plus aliases.
*/
extern char *utDgethostbynames( char *hostname, char ***aliases ) ;

/*
utDsleep -
Function:
    Sleep for the amount in seconds.
*/
extern void utDsleep( INT amount ) ;

/*
utDchdir -
Function:
    Change to working directory.
*/
extern INT utDchdir( char *path ) ;

/*
utDgetwd -
Function:
    Get current working directory.  Pass it the buffer.
*/
extern char *utDgetwd( char *buffer,INT len ) ;

/*
utDgetgroup -
Function:
    Get group name of current user.
*/
extern char *utDgetgroup( void ) ;

/*
utDgetlogin -
Function:
    Get login name of user.
*/
extern char *utDgetlogin( void ) ;

/*
utDgethomedir -
Function:
    Get home directory of the user.
*/
extern char *utDgethomedir( char *who ) ;

/*
utDuname -
Function:
    Get operating system name.  Returns pointer to static buffer.
*/
extern char *utDuname( void ) ;

/*
utDmkdir -
Function:
    Make a directory.  Given a pathname.
*/
extern INT utDmkdir( char *pathname ) ;

/*
utDmkdir_backup -
Function:
    Make a directory with a backup if necessary.  Given a pathname.
*/
extern INT utDmkdir_backup( char *pathname, BOOL save_flag ) ;

/*
utDmkdir_num_backups -
Function:
    Returns the number of backup versions for a given pathname 
*/
extern INT utDmkdir_num_backups( char *pathname ) ;

/*
utDmachine_type -
Function:
    Return the machine type.
*/
extern char *utDmachine_type( void ) ;

/*
utDos_version -
Function:
    Return the operating system version.
*/
extern char *utDos_version( void ) ;

/*
utDgetrlimit -
Function:
    Returns the system resource limits per process.
*/
extern INT utDgetrlimit(INT resource, LONG *resource_current, LONG *resource_max ) ;

/*
utDsetrlimit -
Function:
    Set the system resource limits per process.
*/
extern INT utDsetrlimit(INT resource, LONG resource_current, LONG resource_max ) ;

/*
utDprocessExists -
Function:
    See if a process exists.
*/
extern BOOL utDprocessExists(LONG pid) ;

/*
utDprocessKill -
Function:
    Kill a process.  Use 0 for all processes, or -1 for all but top process.
*/
extern BOOL utDprocessKill(LONG pid) ;

/*
utDbacktrace -
Function:
    Perform a backtrace on systems supporting this function.  Now we pass
    the output file and the maximum number to backtrace.  User may pass a
    message or NULL.  Backtrace will attempt to lookup
    the file and line number using addr2line or equivalent.
*/

#define MAX_BACKTRACE 128
extern void utDbacktrace( char *msg, FILE *fp, INT max_backtrace ) ;

/*
utDbacktrace_start_addr2tline
Function:
    If supported, backtrace will try to lookup line numbers.   Creates a pipe.
    Returns output file pointer, and argument is the input file pointer.
*/
extern FILE *utDbacktrace_start_addr2line( FILE **fin ) ;


/*
utDalarm -
Function:
    Injects a SIGALARM signal after a given number of seconds
*/
extern INT utDalarm(UINT64 seconds) ;

/*
utDnum_fds -
Function:
    Returns back the number of file descriptors in the system descriptor table
    which is useful for a unix select call.
*/
extern INT utDnum_fds( void ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* YSYSTEM_H */
