/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    tcllog.c
DESCRIPTION:This file controls the creation of a Tcl log file.
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>
#include <utd/string.h>
#include <utd/msg.h>
#include <utd/debug.h>
#include <utd/program.h>
#include <utd/file.h>
#include <utd/time.h>
#include <utd/tcllog.h>
#include <utd/version.h>

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static FILE *did_fileS ;		/* file of executed commands */
static INT log_commandS ;		/* output to stdout */

FILE *utDtcllog_init(char *filename, UTDTCLMSGFUNC func, void *clientData)
{
  char *pname ;				/* name of program */

  did_fileS = UTDOPEN( filename, "a", FILE_ABORT ) ;
  fprintf(did_fileS,"\n" );
  fprintf(did_fileS,"# #################################################\n" );
  pname = utDprogram_getName() ;
  if(!(pname)){
    pname = "Unknown program" ;
  }
  fprintf( did_fileS, "# %s %s executed on %s\n", pname, UTD_VERSION, utDtime_get(NULL) ) ;
  if( func ){
    utDmsg_func( func, MESSAGE_UNKNOWN_T, clientData, MSGFUNC_OPT_FLUSH ) ;
  } else {
    utDmsg_func( utDtcllog_message_func, MESSAGE_DIDFILE_T, did_fileS, MSGFUNC_OPT_FLUSH ) ;
  }
  return( did_fileS ) ;

} /* end utDtcllog_init() */

void utDtcllog_exit(void)
{
  INT errors ;				/* # of errors */
  INT warnings ;			/* # of warnings */
  char *pname ;				/* name of program */

  if( did_fileS ){
    pname = utDprogram_getName() ;
    if(!(pname)){
      pname = "Unknown program" ;
    }
    warnings = utDmsg_get_warncount() ;
    errors = utDmsg_get_errorcount() ;
    if( errors ){
      fprintf(did_fileS,
	"\n# %s terminated abnormally at %s\n", pname, utDtime_get(NULL) ) ;
      fprintf(did_fileS, "# with %d error[s] and %d warning[s]\n\n",
	  errors,warnings) ;
    } else {
      fprintf(did_fileS,
	"\n# %s terminated normally at %s\n", pname, utDtime_get(NULL) ) ;
      fprintf(did_fileS, "# with no errors and %d warning[s]\n\n", warnings) ;
    }
    UTDCLOSE(did_fileS) ;
    did_fileS = NULL ;
    utDmsg_func_delete( utDtcllog_message_func ) ;
  }
} /* end utDtcllog_exit() */


void utDtcllog_message_func( const char *message, INT message_type, void *clientData)
{
    INT len ;				/* length of message string */
    char *ptr ;				/* pointer to beginning of string */
    char *end ;				/* end of string */
    static BOOL partialLineL = FALSE ;	/* keep track of newlines */
    static char *mbufL ;		/* message buffer */
    static INT msizeL ;			/* size of message buffer */

    if(!(did_fileS)){
      return ; /* eat message not output file available */
    }
    /* -----------------------------------------------------------------
     * We need to strip out the new lines and put them in ourselves 
     * prepended with a #. We must copy the message because we cannot
     * assume that we have write permissions to it.  If log_commandS is
     * greater than zero, suspress the leading #. 
    ----------------------------------------------------------------- */
    if( !(mbufL)){
      msizeL = BUFSIZ ;
      mbufL = UTDMALLOC( msizeL, char ) ;
    }
    len = strlen(message) + 1 ;
    if( len > msizeL ){
      msizeL = len + 1 ;
      mbufL = UTDREALLOC( mbufL, msizeL, char ) ;
    }
    /* now safe to copy */
    strcpy( mbufL, message ) ;

    for( ptr = mbufL ; ptr && *ptr ; ){
      end = strchr( ptr, '\n' ) ;
      if( end ){
	*end = EOS ;
	if( partialLineL ){
	  /* finish the current line */
	  fprintf( did_fileS, "%s\n", ptr ) ;
	} else if( --log_commandS >= 0 ){
	  fprintf( did_fileS, "%s\n", ptr ) ;
	} else {
	  fprintf( did_fileS, "# %s\n", ptr ) ;
	}
	partialLineL = FALSE ;
	ptr = end + 1 ;
      } else {
	if( partialLineL ){
	  fprintf( did_fileS, "%s", ptr ) ;
	} else if( --log_commandS >= 0 ){
	  fprintf( did_fileS, "%s", ptr ) ;
	} else {
	  fprintf( did_fileS, "# %s", ptr ) ;
	}
	partialLineL = TRUE ;
	break ;
      }
    }
} /* end utDtcllog_message_func() */

/* -----------------------------------------------------------------
 * Set the log_commandS which is a one-shot which eliminates the
 * leading #.
----------------------------------------------------------------- */
void utDtcllog_command(void)
{
    log_commandS = 1 ;
} /* end utDtcllog_command() */

void utDtcllog_flush(void)
{
    if( did_fileS ){
      fflush( did_fileS ) ;
    }
} /* end utDtcllog_flush() */
