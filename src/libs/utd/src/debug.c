/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    dstring.c 
DESCRIPTION:Dynamic message and string functions                                     
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/rbtree.h>
#include <utd/string.h>
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */

#define DBGFILE "dbg"

typedef struct {
    char *routine ;
    BOOL debugOn ;
} ROUTINE, *ROUTINEPTR ;

static BOOL debugFlagS = FALSE ;
static BOOL firstTimeS = FALSE ;      /* first time we ran program */
static UTDTREEPTR debug_treeS ;

/* ********* STATIC DEFINITIONS ************ */
static INT compare_routine( ROUTINEPTR key1, ROUTINEPTR key2, VOIDPTR cdata ) ;
static ROUTINEPTR make_data_debug( char *string, BOOL debugOn ) ;

BOOL utDdebug(char *routine)
{   
    BOOL return_code ;		      /* return code so we can set in debugger */
    ROUTINEPTR data ;                 /* the matched data record */
    ROUTINE routine_key ;             /* used to test key */

    if( debugFlagS ){
      if( routine ){
	routine_key.routine = routine ;
	data = (ROUTINEPTR) utDrbtree_search( debug_treeS, &(routine_key) ) ;
	if( data ){
	  if( data->debugOn ){
	    return_code = TRUE ;
	  }
	} else { /* add it to the tree */
	  if( firstTimeS ){
	      /* the default is for it to be off */
	      data = make_data_debug( routine, FALSE ) ;
	      utDrbtree_insert( debug_treeS, data ) ;
	  } else {
	      /* when adding new routines to an existing file */
	      /* the default is for it to be off */
	      data = make_data_debug( routine, FALSE ) ;
	      utDrbtree_insert( debug_treeS, data ) ;
	  }
	}
      } else {
	fprintf( stderr, "No debug routine name specified here\n" ) ;
      }
    } else {
      return_code = FALSE ;
    }
    return( return_code ) ;

} /* end utDdebug() */

/* ASSERTIONS are always on */
BOOL utDdebugAssert(void)
{   
    return( debugFlagS ) ;
} /* end utDdebugAssert */

void utDdebugWrite(void)
{
    ROUTINEPTR data ;           /* the data in the tree */
    UTDTREEITER iter ;		/* tree iterator */
    FILE *fp ;                  /* write to the debug file */

    if( debugFlagS ){
	
      if( utDfileExists( DBGFILE ) ){
	/* move to .bak to save a copy of the file */
	utDfile_backup( DBGFILE, NULL, 0 ) ;
      }
      /* now write a debug file */
      fp = UTDOPEN( DBGFILE, "w", FILE_ABORT ) ;
      for( data = (ROUTINEPTR) utDrbtree_enumerate(debug_treeS,UTDRBTREE_FIRST(&iter));
	   data; 
	   data = (ROUTINEPTR) utDrbtree_enumerate(debug_treeS,&iter)){

	  fprintf( fp, "%s %d\n", data->routine, data->debugOn ) ;
      }
      UTDCLOSE( fp ) ;
    }
} /* end utDdebugWrite() */

void utDdebug_init(BOOL flag)
{

    char buffer[LRECL], *bufferptr ;
    char **tokens ;         /* for parsing menu file */
    INT  numtokens ;        /* number of tokens on the line */
    INT  line ;             /* count lines in input file */
    FILE *fp ;              /* open file pointer */
    ROUTINEPTR data ;       /* new data to be stored */

    if( flag ){
	/* initialize tree of routine name */
	debug_treeS = utDrbtree_init( (utDcompareClientData)compare_routine, NULL );
	line = 0 ;
	fp = UTDOPEN( DBGFILE, "r", FILE_NOABORT ) ;
	if( fp ){
	    while( (bufferptr=fgets(buffer,LRECL,fp ))){
	      /* parse file */
	      line ++ ; /* increment line number */
	      tokens = utDstrparser( bufferptr, " \t\n", &numtokens );

	      if( numtokens == 2 ){
		data = make_data_debug( tokens[0], atoi(tokens[1]) ) ;
		utDrbtree_insert( debug_treeS, data ) ;
	      } else {
		utDmsgf( ERRMSG,MSG_AT,"utDdebug_init", "Syntax error on line:%d\n", line ) ;
	      } 
	    }
	    UTDCLOSE( fp ) ;
	} else {
	    firstTimeS = TRUE ;
	}
    }
    debugFlagS = flag ;

} /* end utDdebug_init() */

static INT compare_routine(ROUTINEPTR key1, ROUTINEPTR key2,VOIDPTR clientData)
{
    return( strcmp( key1->routine, key2->routine ) ) ;
} /* end compare */

static ROUTINEPTR make_data_debug(char *string, BOOL debugOn)
{
    ROUTINEPTR data ;

    data = UTDMALLOC( 1, ROUTINE ) ;
    data->routine = utDstrclone( string ) ;
    data->debugOn = debugOn ;
    return( data ) ;
} /* end make_data_debug */
