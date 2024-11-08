/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    program.c                                       
DESCRIPTION:Routines to manipulate program start and exit
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */

#include <utd/msg.h>
#include <utd/program.h>
// #include <utd/timer.h>
#include <utd/debug.h>
#include <utd/log.h>
#include <utd/string.h>
#include <utd/timer.h>

#define PGM_NAME_LEN	40
#define PGM_VERSION_LEN	40
#define PGM_DATE_LEN	200
 
static char programNameS[PGM_NAME_LEN+1] ;
static char progVersionS[PGM_VERSION_LEN+1] ;
static char progDateS[PGM_DATE_LEN+1] ;
static char progMessageS[LRECL] ;
static BOOL exitingS ;
static BOOL log_at_exitS ;
static UTDTIMER progTimerS ;
static INT (*exit_functionS)(INT status) = NULL ;

/* ----------------------------------------------------------------- 
   Program control routines                    
   
   utDprogram_init sets the date of compile of program.  It starts
   a timer and now returns a pointer to a static array holding
   info concerning the name, version and compile date.  
   ----------------------------------------------------------------- */
char *utDprogram_init(const char *name,const char *version,const char *date,BOOL log_at_exit)
{
  utDtimer_start(&progTimerS) ;
  strncpy( programNameS,name, PGM_NAME_LEN) ;
  strncpy( progVersionS, version, PGM_VERSION_LEN) ;
  strncpy( progDateS, date, PGM_DATE_LEN) ;
  sprintf( progMessageS, "%s version:%s\nUTDtools compilation date:%s",
	  programNameS,progVersionS,progDateS) ;
  log_at_exitS = log_at_exit ;
  
  return( progMessageS ) ;
  
} /* end utDprogram_init() */

/* exit program gracefully */
void utDprogram_exit(PGM_STATUS_T status_orig)
{

    INT     errorCount, 
	    warningCount,
	    ignoredWarningCount,
	    ignoredErrorCount,
	    mode ;
    BOOL    status_given ;
    PGM_STATUS_T status ;
    char    message[LRECL],
	    supress_warns[80],
	    supress_errors[80],
	    *name ;

    if( exitingS ){
      /* -----------------------------------------------------------------
       * We detect a failure in exiting. With some file problems, we can
       * get in an infinite loop till we lock the machine.
      ----------------------------------------------------------------- */
      exit(status_orig) ;
    }

    exitingS = TRUE ;
    status_given = status_orig & PGMSTATUSGIVEN ;
    status = status_orig & ~(PGMSTATUSGIVEN) ;
    warningCount = utDmsg_get_warncount() ;
    errorCount = utDmsg_get_errorcount() ;
    ignoredWarningCount = utDmsg_get_ignored_warncount() ;
    ignoredErrorCount = utDmsg_get_ignored_errorcount() ;
    if( status != 0 && errorCount == 0 ){
	/* if we have an error status but no recorded error record error*/
	errorCount++ ;
    }
    if( errorCount != 0 && (status == 0) && !(status_given) ){
	status = PGMFAIL ;
    }
    mode = utDmsg_get_mode() ;
    if( (errorCount != 0) || (mode == M_NORMAL) || (mode == M_VERBOSE) ){
	/* make sure we see errors */
	utDmsg_mode( M_VERBOSE ) ;
    }

    /* this must come next to disable message functions if required */
    if( exit_functionS ){
	(*exit_functionS)(status) ;
    }

    if( ignoredErrorCount > 0 ){
      sprintf( supress_errors, " (%d suppressed errors)", ignoredErrorCount ) ;
    } else {
      supress_errors[0] = EOS ;
    }
    if( ignoredWarningCount > 0 ){
      sprintf( supress_warns, " (%d suppressed warnings)", ignoredWarningCount ) ;
    } else {
      supress_warns[0] = EOS ;
    }
#ifdef DEBUG
    {
      char debug_msg[LRECL] ;
      sprintf( debug_msg, " (status arg:%d status:%d status given:%d) ",
	  status_orig, status, status_given ) ;
      strcat( supress_warns, debug_msg ) ;
    } 
#endif /* DEBUG */

    name = utDprogram_getName() ;
    if( name ){
	if( errorCount ){
	    sprintf(message,
	    "\n%s terminated abnormally with %d error[s]%s and %d warning[s]%s\n\n",
		name,errorCount,supress_errors, warningCount,supress_warns) ;
	} else {
	    sprintf(message,
	    "\n%s terminated normally with no errors%s and %d warning[s]%s\n\n",
		name,supress_errors,warningCount,supress_warns) ;
	}
    } else {
	utDmsg(WARNMSG,"utd/utDprogram_exit:1", "utDprogram_exit",
	"Unable to get program name.  Probably initProgram not used.\n") ;
	sprintf(message,
	"Program terminated abnormally with %d error[s]%s and %d warning[s]%s\n\n",
		errorCount,supress_errors,++warningCount,supress_warns) ;
    }
    utDmsg(MSG,"utd/utDprogram_exit:2", NULL,message) ;
    utDmsg_close() ;	/* close down message facility */

    /* -----------------------------------------------------------------
     * Log program's exit if requested.
    ----------------------------------------------------------------- */
    if( log_at_exitS ){
      utDlog_exit( name, errorCount, warningCount ) ;
    }

    /* now write out message control file */
    // utDmsg_control_dump(name) ;

    /* now write debug file if desired */
    DBG( utDdebugWrite() ) ;
    exit(status) ;

} /* end utDprogram_exit() */

LONG utDprogram_elapsed_time(void)
{
    LONG elapsed_time ;			/* program elapsed time */

    elapsed_time = utDtimer_elapsed(&progTimerS) ;

    return( elapsed_time ) ;

} /* end utDprogram_elapsed_time() */


void utDprogram_exitFunction(INT (*function)(INT status) )
{
    exit_functionS = function ;
} /* end utDprogram_exitFunction() */
 
    
char *utDprogram_getName(void)
{
    if( programNameS[0] ){
	return(programNameS);
    } else {
	return( NULL ) ;
    }
} /* end utDprogram_getName() */

char *utDprogram_setName(char *name)
{
    strncpy( programNameS,name, PGM_NAME_LEN) ;
    return( programNameS ) ;
} /* end utDprogram_setName() */

char *utDprogram_simplify_name( char *fullname, char *buffer )
{
    strcpy( buffer, fullname ) ;
    return( utDstr_basename(buffer) ) ;

} /* end utDprogram_simplify_name() */
/*---------------end program control routines --------------------- */

#ifdef TEST

int main(int argc,char *argv[] )
{
    char *intro ;		/* program intro */
    char *cmdName ;		/* command name */
    char *pgmName ;		/* name of program */
    char buffer[LRECL] ;	/* buffer */
    FUNC_NAME("main") ;

    cmdName = utDprogram_simplify_name( argv[0], buffer ) ;
    intro = utDprogram_init( cmdName,"0.0", "no date", TRUE ) ;
    pgmName = utDprogram_getName() ;
    utDmsgf( IMSG, MSG_AT, routine, "program name:%s\n", pgmName ) ;
    utDprogram_setName("AnotherBogusPgm") ;

    utDprogram_exit(PGMOK) ;

} /* end main() */

#endif /* TEST */

