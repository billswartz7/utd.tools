/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019-2021 William Swartz.  UTD.  All rights reserved.
FILE:	    log.c 
DESCRIPTION:This file contains routines for logging the
	    execution times of the program.
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>
#include <utd/msg.h>
#include <utd/file.h>
#include <utd/dstring.h>
#include <utd/string.h>
#include <utd/system.h>
#include <utd/time.h>
#include <utd/log.h>
#include <utd/version.h>

/* ********************** TYPE DEFINITIONS ************************* */

#define LMODE( m)      ( log_optS & (m) )
#define LMODE_SET( m)  ( log_optS |= (m) )
#define LMODE_RESET(m) ( log_optS &= ~(m) )

typedef enum {
  LOG_OPT_NONE = 		(0),
  LOG_OPT_REENTRANT = 		(1),
  LOG_OPT_ADJUST_PLACE = 	UTDLOG_ADJUST_PLACE,
  LOG_OPT_ADJUST_ROUTE = 	UTDLOG_ADJUST_ROUTE,
  LOG_OPT_ADJUST_FLOORPLAN = 	UTDLOG_ADJUST_FLOORPLAN
} LOG_OPT_T ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static UTDDSTRINGPTR cktNameS ;		/* dynamic circuit name */
static UTDDSTRINGPTR log_pathS ;		/* dynamic log path */
static void log_msg_func( const char *message, INT type, void *clientData ) ;
static LOG_OPT_T log_optS ; 	/* save state */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */

/* put a message in the log file */
void utDlog_msg(const char *message,BOOL time_flag)
{
    LONG timestamp ;		/* seconds since Jan 1, 1970 */
    const char *time ; 		/* UTDtime_get returns ASCII time string */
    char *log_pathname ;	/* log pathname */
    FILE *fp ;	                /* logfile */

    if( LMODE(LOG_OPT_REENTRANT) || !(cktNameS) || !(log_pathS) ){
      return ;
    }
    LMODE_SET( LOG_OPT_REENTRANT ) ;

    log_pathname = utDdstring_value( log_pathS ) ;
    fp = UTDOPEN( log_pathname, "a", FILE_ABORT ) ;
    if( time_flag ){
      time = utDtime_get( &timestamp ) ;
      fprintf( fp, "time %10ld %s:%s\n", timestamp, time, message ) ;
    } else {
      fprintf( fp, "%s", message ) ;
    }
    fflush( fp ) ;
    UTDCLOSE( fp ) ;
    LMODE_RESET( LOG_OPT_REENTRANT ) ;
} /* end log */

void utDlog_start(const char *design, const char *message, UTDLOG_START_T opts,INT argc,char *argv[],
                  const char *alternate_log_path )
{
    INT i ;			/* arg counter */
    BOOL divider ;		/* need a divider */
    BOOL utdhome_dir ;		/* utd home directory flag */
    LONG timestamp ;          	/* seconds since Jan 1, 1970 */
    const char *time ; 		/* utDtime_get returns ASCII time string */
    char *user_p ;		/* current user */
    char *homedir ;		/* home directory */
    char *fullpath ;		/* full pathname adjusted for hierarchy */
    char pathname[BUFSIZ] ;	/* buffer for full pathname */
    FILE *fp ;                	/* logfile */

    if( LMODE(LOG_OPT_REENTRANT) ){
      return ;
    }
    LMODE_SET( LOG_OPT_REENTRANT ) ;

    divider = opts & UTDLOG_START_DIVIDER ;
    utdhome_dir = opts & UTDLOG_START_UTDHOME_DIR ;
    /* allocate memory for dynamics strings if necessary */
    if(!(cktNameS)){
      cktNameS = UTDMALLOC( 1, UTDDSTRING ) ;
      utDdstring_init( cktNameS ) ;
    }
    if(!(log_pathS)){
      log_pathS = UTDMALLOC( 1, UTDDSTRING ) ;
      utDdstring_init( log_pathS ) ;
    }

    fullpath = NULL ;
    pathname[0] = EOS ;
    utDdstring_append( cktNameS, design, -1 ) ;
    if( utdhome_dir ){
      user_p = utDgetlogin() ;
      if( user_p ){
	homedir = utDgethomedir(user_p) ;
	if( homedir ){
	  sprintf( pathname, "%s/.utd", homedir ) ;
	  fullpath = pathname ;
	}
      }
    }
    if(!(fullpath)){
      fullpath = utDlog_adjust_full_path(pathname) ;
      if(!(fullpath)){
	fullpath = utDgetwd( pathname, BUFSIZ ) ;
      }
    }
    if( alternate_log_path ){
      utDdstring_append( log_pathS, alternate_log_path, -1 ) ;
      if( design ){
	utDdstring_append( log_pathS, "/", -1 ) ;
	utDdstring_append( log_pathS, utDdstring_value(cktNameS), -1 ) ;    
	utDdstring_append( log_pathS, ".log", -1 ) ;
      }
    } else {
      utDdstring_append( log_pathS, fullpath, -1 ) ;
      utDdstring_append( log_pathS, "/", -1 ) ;
      utDdstring_append( log_pathS, utDdstring_value(cktNameS), -1 ) ;    
      utDdstring_append( log_pathS, ".log", -1 ) ;
    }
    fp = UTDOPEN( utDdstring_value(log_pathS), "a", FILE_ABORT ) ;
    time = utDtime_get( &timestamp ) ;
    if( divider ){
      fprintf( fp,"####################################################\n");
    }
    fprintf( fp, "time %10ld %s:%s\n@ ", timestamp, time, message ) ;
    for( i = 0 ; i < argc ; i++ ){
      fprintf( fp, "%s ", argv[i] ) ;
    }
    fprintf( fp, "\n" ) ;
    fullpath = utDgetwd( pathname, BUFSIZ ) ;
    fullpath[BUFSIZ-1] = EOS ; /* guarantee string termination */
    fprintf( fp, "@ %s HOST %s PID %d PVERSION %s\n", fullpath, utDhostname(), utDgetpid(), UTD_VERSION ) ;
    UTDCLOSE( fp ) ;
    /* -----------------------------------------------------------------
     * Now register message function.
    ----------------------------------------------------------------- */
    utDmsg_func( log_msg_func, MESSAGE_LOG_T, NULL, MSGFUNC_OPT_NONE ) ;
    LMODE_RESET( LOG_OPT_REENTRANT ) ;
} /* end log */

void utDlog_intro(const char *intro, char *full_msg,UTDLOG_OPT_T options)
{
    INT len ;				/* length of string */
    char *ptr ;				/* see if eol exists */
    const char *start_msg = full_msg ;	/* beginning of message */

    if( full_msg[0] ){
      /* preloaded case */
      full_msg += strlen( full_msg ) ;
    }
    if( options & UTDLOG_FULL_INTRO ){
      sprintf( full_msg,"\n%s\n",intro) ;
    } else if( options & UTDLOG_SHORT_INTRO ){
      ptr = strchr( intro, '\n' ) ;
      if( ptr ){
	len = ptr - intro ;
	strncpy( full_msg, intro, len ) ;
	full_msg[len] = ' ' ;
	full_msg[len+1] = EOS ;
      } else {
	/* fallback position */
	sprintf( full_msg,"\n%s\n",intro) ;
      }
    }
    if( options & UTDLOG_ADJUST_PLACE ){
      LMODE_SET( LOG_OPT_ADJUST_PLACE ) ;
    }
    if( options & UTDLOG_ADJUST_ROUTE ){
      LMODE_SET( LOG_OPT_ADJUST_ROUTE ) ;
    }
    if( options & UTDLOG_ADJUST_FLOORPLAN ){
      LMODE_SET( LOG_OPT_ADJUST_FLOORPLAN ) ;
    }
    strcat( full_msg, "Copyright (c) 2018-2021 University of Texas at Dallas, Inc. All rights reserved.\n\n" ) ;
    if( options & UTDLOG_OUTPUT ){
      utDmsg(MSG,MSG_AT,NULL,start_msg) ;
    }

} /* end utDmsg_intro() */

static void log_msg_func( const char *message, INT type, void *clientData ) 
{
    utDlog_msg( message, FALSE ) ;
} /* end log_msg_func() */

/* -----------------------------------------------------------------
 * This stops messages going to the log file.
----------------------------------------------------------------- */
void utDlog_end(void)
{
    if( cktNameS ){
      utDdstring_free( cktNameS ) ;
      cktNameS = NULL ;
    }
    if( log_pathS ){
      utDdstring_free( log_pathS ) ;
      log_pathS = NULL ;
    }
} /* end utDlog_end() */

char *utDlog_pathname(void)
{
    char *pathname ;		/* log pathname */

    if( log_pathS ){
      pathname = utDdstring_value( log_pathS ) ;
    } else {
      pathname = " " ;
    }
    return( pathname ) ;
} /* utDlog_pathname() */

char *utDlog_new_pathname(char *new_pathname)
{
    char *fullpath ;		/* full pathname adjusted for hierarchy */
    char *log_path ;		/* the new log path */
    char pathname[BUFSIZ] ;	/* buffer for full pathname */

    if( !(cktNameS) || !(log_pathS) ){
      new_pathname[0] = EOS ;
      return(new_pathname) ;
    }

    utDdstring_reinit( log_pathS ) ;
    if(!(new_pathname)){
      fullpath = utDlog_adjust_full_path(pathname) ;
      if( fullpath ){
	utDdstring_append( log_pathS, fullpath, -1 ) ;
	utDdstring_append( log_pathS, "/", -1 ) ;
      }
      utDdstring_append( log_pathS, utDdstring_value(cktNameS), -1 ) ;
      utDdstring_append( log_pathS, ".log", -1 ) ;
    } else {
      utDdstring_append( log_pathS, new_pathname, -1 ) ;
    }
    log_path = utDdstring_value( log_pathS ) ;
    return( log_path ) ;

} /* end utDlog_new_pathname() */

void utDlog_exit(char *programName, INT errors, INT warnings )
{
    char *fullpath ;		/* full pathname adjusted for hierarchy */
    char pathname[BUFSIZ] ;	/* buffer for full pathname */
    UTDDSTRING msg_buf ;	/* build a message buffer */

    fullpath = utDgetwd( pathname, BUFSIZ ) ;
    if( fullpath ){
      fullpath[BUFSIZ-1] = EOS ; /* guarantee string termination */
    } else {
      strcpy( pathname, "unknown path" ) ;
      fullpath = pathname ;
    }
    utDdstring_init( &msg_buf ) ;
    utDdstring_printf( &msg_buf, "%s exits %d errors %d warnings\n@ %s HOST %s PID %d\n",
       programName, errors, warnings, fullpath, utDhostname(), utDgetpid() ) ;
    utDlog_msg( utDdstring_value(&msg_buf), TRUE ) ;
    utDdstring_free( &msg_buf ) ;

    return ;


} /* end utDlog_exit() */

static char *_utDlog_adjust_full_path( char *pathbuf )
{
    BOOL under_openroad ;		/* under openroad or similar */
    char *fullpath ;			/* full path of current cwd */
    char *ptr ;				/* look for hierarchy */
    char *lastp ;			/* last character examined */
    char *root_path ;			/* root path */
    char *startpath ;			/* ignore leading itoolsdata dir */

    fullpath = utDgetwd( pathbuf, BUFSIZ ) ;
    if(!(fullpath)){
      utDmsg_syserr( TRUE, "utDlog_adjust_full_path","can't get current working directory.") ;
      return(NULL) ; // Never get here though */
    }

    utDmsgf(DBGMSG,MSG_AT, "log_adjust", "original wd:%s\n", fullpath ) ;
    /* -----------------------------------------------------------------
     * Make sure we are under openroad if it exist in path.
     * ----------------------------------------------------------------- */
    startpath = utDstrlsub( fullpath, "openr") ;
    if(!(startpath)){
      startpath = fullpath ;
      under_openroad = FALSE ;
    } else {
      under_openroad = TRUE ;
    }
    utDmsgf(DBGMSG,MSG_AT, "log_adjust", "under:%d start path:%s\n", under_openroad,
    startpath ) ;

    /* look for special case of /xxx/y/z/place/p1/preroute */
    ptr = strrchr( startpath, '/' ) ;
    if( ptr ){
      if( strncmp( startpath, "utdtools/", 9 ) == STRINGEQ ){
        /* we have ...//xxx/y/utdtools/place/x/y type */
	lastp = startpath + 8 ;
	*lastp = EOS ; /* left with /xxx/y/z */
	/* -----------------------------------------------------------------
	 * We might have a special case where we are under the open road 
	 * root directory.  In that case, we abort.
	 * ----------------------------------------------------------------- */
	root_path = utDgetenv( "UTDTOOLS" ) ;
	if( strcmp( fullpath, root_path ) == STRINGEQ ){
	  return(NULL) ;
	}
	return( fullpath ) ;
      }
    } else if( under_openroad ){
      /* we have no slashes after openr so we are in the proper directory */
      return(fullpath) ;
    }

    /* given /xxx/y/z/place/p1/stage1 */
    for( ptr = lastp = startpath ; ptr && *ptr ; ptr++ ){
      if( *lastp != '/' ){
	lastp = ptr ;
	continue ;
      }
      if( (*ptr == 'p') && ((strcmp( ptr, "place") == STRINGEQ) ||
			    (strncmp( ptr, "place/", 6) == STRINGEQ)) ){
	if( LMODE(LOG_OPT_ADJUST_PLACE) && (fullpath < ptr) ){
	  *lastp = EOS ; /* left with /xxx/y/z */
	  return( fullpath ) ;
	}
      } else if( (*ptr == 'r') && ((strcmp( ptr,"route") == STRINGEQ) ||
      				   (strncmp( ptr,"route/",6) == STRINGEQ)) ){
	if( LMODE(LOG_OPT_ADJUST_ROUTE) && (fullpath < ptr) ){
	  *lastp = EOS ; /* left with /xxx/y/z */
	  return( fullpath ) ;
	}
      } else if( (*ptr == 'f') && ((strcmp( ptr, "floorplan") == STRINGEQ) ||
				   (strncmp( ptr, "floorplan/",10) == STRINGEQ))){
	if( LMODE(LOG_OPT_ADJUST_FLOORPLAN) && (fullpath < ptr) ){
	  *lastp = EOS ; /* left with /xxx/y/z */
	  return( fullpath ) ;
	}
      }
      lastp = ptr ;
    }
    return(NULL) ;
} /* end utDlog_adjust_full_path() */

char *utDlog_adjust_full_path( char *pathbuf )
{
    char *result ;

    result = _utDlog_adjust_full_path( pathbuf ) ;
    if ( result ){
      utDmsgf(DBGMSG,MSG_AT, "log_adjust", "adjust path:%s\n", result ) ;
    }

    return(result) ;
} /* end utDlog_adjust_full_path() */


#ifdef TEST

#include <utd/program.h>

int main(int argc,char *argv[] )
{
    INT status ;		/* status */
    char *intro ;		/* program intro */
    char *cmdName ;		/* name of command */
    char *pgmName ;		/* name of program */
    char buffer[LRECL] ;	/* buffer */
    char path_buf[LRECL] ;	/* path buffer */
    char full_msg[LRECL] ;	/* needs to be a buffer */
    FUNC_NAME("main") ;

    cmdName = utDprogram_simplify_name( argv[0], buffer ) ;
    intro = utDprogram_init( cmdName,"0.0", "no date", TRUE ) ;

    sprintf( full_msg, "%s", "another msg" ) ;
    utDlog_intro( intro, full_msg, UTDLOG_FULL_INTRO | UTDLOG_ADJUST_PLACE |
	                           UTDLOG_OUTPUT ) ;

    utDlog_start( "cktName", "program started...", TRUE, argc, argv, NULL ) ;
    utDlog_msg( full_msg, FALSE ) ;

    pgmName = utDprogram_getName() ;
    utDmsgf( IMSG, MSG_AT, routine, "program name:%s\n", pgmName ) ;

    char *testpath = "/Users/bill/version1/openroad/openroad/pgms/flow/mydesign/openroad/highlevel" ;
    status = utDchdir(testpath) ;
    if( status ){
      utDmsg_syserr(FALSE,"test.log", "couldn't chdir..\n" ) ;
    }

    char *result = utDlog_adjust_full_path( path_buf ) ;

    utDprogram_exit(PGMOK) ;

} /* end main() */

#endif /* TEST */
