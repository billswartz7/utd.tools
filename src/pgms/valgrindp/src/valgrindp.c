/************************************************************
 *
 *  Program: valgrindp
 *  By:      Bill Swartz.
 *  Date:    Thu Feb  2 17:01:15 CST 2023
 *
 *  Function:Reads the output of valgrind and separates the problems
 *           into separate files so we can just look at things that
 *           are definitely lost.
 * REVISONS:
 * $Log: main.c,v $
 * Revision 1.2  2023/02/02 23:50:47  bills
 * Added missing std/message.h include file.
 *
 * Revision 1.1  2023/02/02 23:49:40  bills
 * Initial revision
 *
 ************************************************************
 */

/* #define DEBUG */

#include "config.h"

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */
#include <utd/base.h>
#include <utd/debug.h>
#include <utd/msg.h>
#include <utd/system.h>
#include <utd/string.h>
#include <utd/program.h>
#include <utd/file.h>


/* ********************** TYPE DEFINITIONS ************************* */


/* ***************** STATIC FUNCTION DEFINITIONS ******************* */

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static BOOL debugS ;


int main(int argc, char *argv[])
{
    char *byte_keyword ;		/* byte keyword */
    char *type_lost ;			/* type lost */
    char *valgrind_filename ;		/* name of valgrind output file */
    char *definitely_filename ;		/* name of definitely lost data */
    char *bufferptr ;			/* start of buffer */
    char input[LRECL] ;			/* read a line */
    char copy_buf[LRECL] ;		/* copy buffer */
    char **line_argv ;			/* line parsed argument vector */
    FILE *fin ;				/* input file */
    FILE *fdef ;			/* definitely lost output file */
    BOOL output_state ;			/* whether to output the code */
    INT pid ;				/* process id */
    INT line ;				/* line counter */
    INT line_argc ;			/* number of arguments on line */
    INT running_pid ;			/* pid of interest */
    FUNC_NAME("main") ;

    valgrind_filename = "val.out" ;
    definitely_filename = "val.def" ;

    if(!(utDfileExists(valgrind_filename))){
      utDmsgf(ERRMSG,MSG_AT,routine,"file:%s does not exist\n", valgrind_filename ) ;
      utDprogram_exit(PGMFAIL) ;
    }
    fin = UTDOPEN( valgrind_filename, "r", FILE_VERBOSE | FILE_ABORT ) ;
    fdef = UTDOPEN( definitely_filename, "w", FILE_VERBOSE | FILE_ABORT ) ;

    line = 0 ;
    output_state = FALSE ;
    while( (bufferptr = fgets(input,LRECL,fin) ) ){
      line++ ;
      strncpy( copy_buf, bufferptr, LRECL ) ; 
      line_argv = utDstrparser( bufferptr, " =\r\t\n", &line_argc ) ;
      if( line == 1 ){
	running_pid = atoi( line_argv[0] ) ;
	utDmsgf(IMSG,MSG_AT,routine,"process id:%d\n", running_pid ) ;
	continue ;
      } 
      if( line_argc <= 1 ){
	continue ;
      }
      pid = atoi( line_argv[0]) ;
      if( pid != running_pid ){
	continue ;
      }
      if( line_argc > 8 ){
	byte_keyword = line_argv[2] ;
	if( strcmp( byte_keyword, "bytes" ) == STRINGEQ ){
	  type_lost = line_argv[7] ;
	  if( strcmp( type_lost, "definitely" ) == STRINGEQ ){
	    fprintf( fdef, "\n" ) ;
	    output_state = TRUE ;
	  } else {
	    output_state = FALSE ;
	  }
	}
      }
      if( output_state ){
	fprintf( fdef, "%s", copy_buf ) ;
      }
    }
    utDmsgf(IMSG, MSG_AT, routine, "read %d lines.\n", line ) ;
    UTDCLOSE(fin) ;
    UTDCLOSE(fdef) ;

    utDprogram_exit( PGMOK ) ;
} /* end main() */
