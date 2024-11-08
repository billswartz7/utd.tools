/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	     cleanup.c 
DESCRIPTION: Basic C interface to signal handlers.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <stdio.h>
#include <utd/base.h>
#include <utd/debug.h>
#include <utd/cleanup.h>
#include <utd/program.h>
#include <utd/msg.h>
#include <utd/string.h>
#include <utd/system.h>
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static utDuser_sigfunc *user_cleanupS ;
static VOIDPTR user_clientDataS ;
static INT (*graphicsFunctionS)(INT status) ;

/* ***************************************************************** 
   cleanup - the installed cleanup handler.
*/
void utDcleanup(INT sigNum)
{
    char *pgm ;
    FUNC_NAME("utDcleanup") ;

    DBG( fprintf( stderr, "signal received:%d\n", sigNum ); ) ;
    if( sigNum != SIGINT && sigNum != SIGQUIT && sigNum != SIGKILL ){
      pgm = utDprogram_getName() ;
      utDmsgf( ERRMSG, "utDcleanup:1", routine, 
	  "System has detected an error in program:%s!\n", 
	  (pgm ? pgm : "unknown program") ) ;
      utDmsgf( ERRMSG, "utDcleanup:2", NULL, "The program's process id=%d.\n",utDgetpid() );
      utDmsg( ERRMSG,"utDcleanup:3", NULL,"Please contact user support.\n\n") ;
    }
    utDcleanupHandler(sigNum) ;

} /* end utDcleanup() */

/* ***************************************************************** 
   utDcleanup_init - sets static variables for cleanup handler.
*/
void utDcleanup_init( utDuser_sigfunc *function, void *clientData )
{
    /* install the standard signals */
    utDsignal(SIGHUP,utDcleanup);
    utDsignal(SIGILL,utDcleanup);
    utDsignal(SIGFPE,utDcleanup);
    utDsignal(SIGSEGV,utDcleanup);
    utDsignal(SIGBUS,utDcleanup);
    utDsignal(SIGSYS,utDcleanup);
    utDsignal(SIGTERM,utDcleanup);
    utDsignal(SIGUSR1,utDcleanup);

    user_cleanupS = function ;
    user_clientDataS = clientData ;

} /* end utDcleanup_init() */

/* ***************************************************************** 
   utDcleanup_graphics - sets the callback to graphics close function.
*/
void utDcleanup_graphics( INT (*function)(INT status) )
{
    /* install the graphics cleanup function on a quit. */
    graphicsFunctionS = function ;
    utDsignal(SIGQUIT,utDcleanup);
    utDsignal(SIGKILL,utDcleanup);
    utDsignal(SIGINT,utDcleanup);
} /* end utDcleanup_init() */


/* ***************************************************************** 
   cleanupHandler - after system work process user information.
*/
void utDcleanupHandler( INT status)
{

    FUNC_NAME("utDcleanupHandler") ;
    INT exit_status ;
    char *pgm ;

    exit_status = 1 ;
    if( status == SIGINT || status == SIGQUIT || status == SIGKILL ){
      if( graphicsFunctionS ){
	status = (*graphicsFunctionS)(PGMGABORT) ;
	if( status == PGMGCANCEL ){
	  return ;
	} else if( status == PGMGABORTALL ){
	  exit_status = PGMGABORTALL ; /* exit all graphics programs */
	}
      }
      pgm = utDprogram_getName() ;
      utDmsgf( ERRMSG, "utDcleanupHandler:1", routine, 
	  "\nProgram %s has been terminated by the user.\n\n",
	  (pgm ? pgm : "unknown") ) ;
	exit(exit_status) ;
    } else {
#ifdef HAVE_STRSIGNAL
      utDmsgf( ERRMSG, "utDcleanupHandler:2", routine, "%s\n", strsignal(status) ) ;
#endif /* HAVE_STRSIGNAL */
    }

    if( user_cleanupS ){
	(*user_cleanupS)( user_clientDataS ) ;
    }
    utDbacktrace( NULL, stderr, MAX_BACKTRACE ) ;
    exit(exit_status) ;

} /* end void utDcleanupHandler() */

utDsigfunc *utDsignal( INT signo, utDsigfunc *func )
{
    struct sigaction act, oact ;

    act.sa_handler = func ;
    sigemptyset( &act.sa_mask ) ;
    act.sa_flags = 0 ;
    if( signo == SIGALRM ){
#ifdef SA_INTERRUPT
      act.sa_flags |= SA_INTERRUPT ; /* SunOS */
#endif /* SA_INTERRUPT */
    } else {
#ifdef SA_RESTART
      act.sa_flags |= SA_RESTART ;   /* SVR4, 4.3BSD */
#endif /* SA_RESTART */
    }
    if( sigaction( signo, &act, &oact ) < 0 ){
      return(SIG_ERR) ;
    }
    return(oact.sa_handler) ;

} /* end utDsignal() */


#ifdef TEST

void my_cleanup_function( void *clientData )
{
    char *s = (char *) clientData ;
    fprintf( stderr, "entered my cleanup handler:%s\n", s ) ;
}

INT main( INT argc, char *argv[] )
{

    utDmsgf( IMSG, "main:1", "main", "pid is %d\n", utDgetpid() ) ;
    utDmsgf( IMSG, "main:1", NULL, "Enter 'kill -1 %d' in another shell to invoke handler\n", utDgetpid() ) ;
    utDcleanup_init( my_cleanup_function, "magic cookie" ) ;

    while(1) ;
} /* end main() */

#endif /* TEST */
