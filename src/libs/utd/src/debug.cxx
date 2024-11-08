/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	     okmalloc.c 
DESCRIPTION: Memory management routines for C programs.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef lint
static char SccsId[] = 
"@(#)$RCSfile: ydebug.c,v $ TWS $Revision: 3.29 $ $Date: 1998/03/20 07:28:08 $" ;
#endif

#include <utd/base.h>
#include <utd/string.h>
#include <algorithm>
#include <set>
#include <string>

#define DBGFILE "dbg"

using namespace std ;

namespace UTD {

  class Routine {
    public:
      std::string routine ;
      bool debugOn ;

      Routine( char *func_name, bool state ) :
	routine(func_name), debugOn(state) 
      {}

      bool operator< (const Routine &routine_obj) const {
	return(routine_obj.routine < this->routine) ;
      }
  } ;

  class Debug {
    public:
      Debug() ;
      ~Debug() ;
      void Init( bool on_flag ) ;

    private:
      bool read_init_file ;
      bool debug_flag ;
      multiset <Routine> labels ;

  } ;

  Debug::Debug() : debug_flag(false), read_init_file(false) {
  }

  Debug::~Debug() {
  }
  
  void Debug::Init( bool flag )
  {

#ifdef LATER
      char buffer[LRECL], *bufferptr ;
      char **tokens ;         /* for parsing menu file */
      INT  numtokens ;        /* number of tokens on the line */
      INT  line ;             /* count lines in input file */
      FILE *fp ;              /* open file pointer */
      ROUTINEPTR data ;       /* new data to be stored */

      if( flag ){
	  /* initialize tree of routine name */
	  debug_treeS = Yrbtree_init( (Ycompare) compare_routine );
	  line = 0 ;
	  if( (fp = TWOPEN( DBGFILE, "r", FILE_NOABORT ) ) ){
	      while( (bufferptr=fgets(buffer,LRECL,fp ))){
		  /* parse file */
		  line ++ ; /* increment line number */
		  tokens = Ystrparser( bufferptr, " \t\n", &numtokens );

		  if( numtokens == 2 ){
		      data = make_data_debug( tokens[0], atoi(tokens[1]) ) ;
		      Yrbtree_insert( debug_treeS, (char *) data ) ;
		  } else {
		      sprintf( YlibmsgG, "Syntax error on line:%d\n", line ) ;
		      M(ERRMSG, "YsetDebug", YlibmsgG ) ;
		  } 
	      }
	      TWCLOSE( fp ) ;
	  } else {
	      firstTimeS = TRUE ;
	  }
      }
      debugFlagS = flag ;
#endif /* LATER */
  } /* end Ydebug_init() */

#ifdef LATER
  static BOOL debugFlagS = FALSE ;
  static BOOL firstTimeS = FALSE ;      /* first time we ran program */
  static YTREEPTR debug_treeS ;

  /* ********* STATIC DEFINITIONS ************ */
  static INT compare_routine( P2(ROUTINEPTR key1, ROUTINEPTR key2 ) ) ;
  static ROUTINEPTR make_data_debug( P2(char *string, BOOL debugOn ) ) ;

  BOOL UTDdebug(char *routine)
  {   
      ROUTINEPTR data ;                 /* the matched data record */
      ROUTINE routine_key ;             /* used to test key */
      BOOL return_code ;		      /* return code so we can set in debugger */

      if( debugFlagS ){
	  return_code = FALSE ;
	  if( routine ){
	      routine_key.routine = routine ;
	      if( (data = (ROUTINEPTR) 
		  Yrbtree_search( debug_treeS, (char *) &(routine_key) ) ) ){
		  if( data->debugOn ){
		      return_code = TRUE ;
		  }
	      } else { /* add it to the tree */
		  if( firstTimeS ){
		      /* the default is for it to be off */
		      data = make_data_debug( routine, FALSE ) ;
		      Yrbtree_insert( debug_treeS, (char *) data ) ;
		  } else {
		      /* when adding new routines to an existing file */
		      /* the default is for it to be off */
		      data = make_data_debug( routine, FALSE ) ;
		      Yrbtree_insert( debug_treeS, (char *) data ) ;
		  }
	      }
	  } else {
	      fprintf( stderr, "No debug routine name specified here\n" ) ;
	  }
      } else {
	  return_code = FALSE ;
      }

      return( return_code ) ;

  } /* end Ydebug */

  /* ASSERTIONS are always on */
  BOOL UTDdebugAssert(void)
  {   
      return( debugFlagS ) ;
  } /* end YdebugAssert */

  void UTDdebugWrite(void)
  {
      ROUTINEPTR data ;              /* the data in the tree */
      FILE *fp ;                   /* write to the debug file */

      if( debugFlagS ){
	  
	  if( YfileExists( DBGFILE ) ){
	      /* move to .bak to save a copy of the file */
	      sprintf( YlibmsgG, "/bin/cp %s %s.bak", DBGFILE,DBGFILE ) ;
	      system( YlibmsgG ) ;
	  }
	  /* now write a debug file */
	  fp = TWOPEN( DBGFILE, "w", FILE_ABORT ) ;
	  for( data = (ROUTINEPTR) Yrbtree_enumerate(debug_treeS,TRUE);data; 
	      data = (ROUTINEPTR) Yrbtree_enumerate(debug_treeS,FALSE)){

	      fprintf( fp, "%s %d\n", data->routine, data->debugOn ) ;
	  }
	  TWCLOSE( fp ) ;
      }
  } /* end YdebugWrite() */


  static INT compare_routine(ROUTINEPTR key1, ROUTINEPTR key2)
  {
      return( strcmp( key1->routine, key2->routine ) ) ;
  } /* end compare */

  static ROUTINEPTR make_data_debug(char *string, BOOL debugOn)
  {
      ROUTINEPTR data ;

      data = YMALLOC( 1, ROUTINE ) ;
      data->routine = Ystrclone( string ) ;
      data->debugOn = debugOn ;
      return( data ) ;
  } /* end make_data_debug */
#endif /* LATER */

} ;

extern "C" {
  BOOL UTDdebug(char *routine) {
    return(FALSE) ;
  }
} ;
