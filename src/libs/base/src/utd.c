/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    utd.c                                       
DESCRIPTION:Common UTD commands sequences
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef lint
static char SccsId[] = 
"$RCSfile$ $Revision$ $Date$" ;
#endif

#include <cometconfig.h>
#include <utd/base.h>
#include <utd/string.h>
#include <utd/dstring.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/program.h>
#include <utd/log.h>
#include <utd/stats.h>
#include <utd/system.h>
#include <utd/tcllog.h>
#include <tcl/tcl.h>
#include <gui/interactive.h>
#include <base/utd.h>
#include <blt/blt.h>

/* ********************** TYPE DEFINITIONS ************************* */


/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static INT utDExitFunc( INT status ) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */

const char *utDInit( int argc, char *argv[], const char *cktName,
                     const char *pgm_version, const char *compile_date, 
		     const char *program_description,
		     const char *alternate_path )
{
    char *intro ;			/* program intro */
    char *cmdName ;			/* simple name of program */
    char name_buffer[LRECL] ;		/* for now */
    const char *utdroot ;		/* root directory */
    INT opts ;				/* options */
    MSG_OPT_T mode ;			/* message mode */
    UTDDSTRING msg_buf ;		/* message buffer */
    FUNC_NAME("utDInit" ) ;


    /* Turn on memory pools */
    UTDPOOL_ENABLE(TRUE) ;

    cmdName = utDprogram_simplify_name( argv[0], name_buffer ) ;
    intro = utDprogram_init( cmdName, pgm_version, compile_date, TRUE ) ;

    mode = utDmsg_get_mode() ;
    if( (mode == M_VERBOSE) || (mode == M_NORMAL) ){
      opts = UTDLOG_FULL_INTRO | UTDLOG_ADJUST_PLACE | UTDLOG_OUTPUT ;
    } else {
      opts = UTDLOG_FULL_INTRO | UTDLOG_ADJUST_PLACE ;
    }
    utDdstring_init( &msg_buf ) ;
    if( program_description ){
      utDdstring_append( &msg_buf, program_description, -1 ) ;
    }
    utDlog_intro( intro, utDdstring_value(&msg_buf), (UTDLOG_OPT_T) opts ) ;

    utDmsg_func( utDmsg_stdout_msg, MESSAGE_STDOUT_T, stdout, 
		 MSGFUNC_OPT_FLUSH ) ;

    utdroot = utDgetenv("UTDTOOLS") ;
    if(!(utdroot)){
      utDmsg(ERRMSG,"flow/main:1", routine, "Could not find UTDTOOLS env variable\n") ;
      utDprogram_exit(PGMFAIL) ;
    }
    utDdstring_free( &msg_buf ) ;

    /* Now install exit handler */
    utDprogram_exitFunction( utDExitFunc ) ;

    return(utdroot) ;

} /* end utDInit() */


static INT utDExitFunc( INT status )
{
    UTDDSTRING mbuf ;			/* message buffer */
    char *msg_str ;			/* message string */
    INT mode ;				/* total message type */
    MSG_OPT_T simple_mode ;		/* message mode */

    utDdstring_init(&mbuf) ;
    msg_str = _utDstats_print(&mbuf) ;
    if( msg_str ){
      mode = utDmsg_get_mode() ;
      if(!(mode & MSG_AVOID_STATS)){
	simple_mode = GET_SIMPLE_MESSAGE_TYPE(mode) ;
	if( simple_mode == M_VERBOSE ){
	  utDmsgf(IMSG,MSG_AT,NULL,"%s\n", msg_str ) ;
	} else {
	  utDmsgf(MSG,MSG_AT,NULL,"%s\n", msg_str ) ;
	}
      }
    }
    utDdstring_free( &mbuf ) ;
    utDtcllog_exit() ;

} /* end utDExitFunc() */


/* -----------------------------------------------------------------
 * Remove braces around Tcl name
 * ----------------------------------------------------------------- */
char *utD_adjust_tcl_name( char *name, char *buffer )
{
  INT copy_amt ;			/* # of char to copy */
  copy_amt = strlen( name ) - 2 ;
  strncpy( buffer, name + 1, copy_amt ) ;
  buffer[copy_amt] = EOS ;
  return( buffer ) ;
} /* end utD_adjust_tcl_name() */

/* -----------------------------------------------------------------
 * Checks to see if we need to remove {} around string
 * ----------------------------------------------------------------- */
char *utD_check_tcl_name( char *name, char *buffer )
{
  INT len ;				/* length of string */
  if ( *name == '{' ){
    len = strlen( name ) ;
    if ( name[len-1] == '}' ){
      return( utD_adjust_tcl_name( name, buffer ) ) ;
    }
  }
  return( name ) ;
} /* end utD_check_tcl_name() */

const char *utD_process_script( char *script_file_name )
{
  INT size ;			/* size of file */
  INT read_items ;		/* number of bytes read */
  char *script_buffer ;		/* read into buffer */
  FILE *fp ;			/* script file pointer */
  FUNC_NAME("utD_process_script") ;

  fp = UTDOPEN( script_file_name, "r", FILE_NOABORT | FILE_VERBOSE ) ;
  if( fp ){
    size = utDfile_size( script_file_name ) ;
    script_buffer = UTDMALLOC( size +1, char ) ;
    read_items = fread( script_buffer, sizeof(char), size, fp ) ;
    UTDCLOSE(fp) ;
    if( read_items != size ){
      utDmsgf(ERRMSG,MSG_AT,routine,"Trouble reading script file:%s\n",script_file_name) ;
      return(NULL) ;
    }
    script_buffer[size] = EOS ;
    return(script_buffer) ;
  }
  return(NULL) ;

} /* end utD_process_script() */

void utDbase_create_objcmd(Tcl_Interp *interp,char *cmdName,Tcl_ObjCmdProc *proc,
	                          ClientData clientData,Tcl_CmdDeleteProc *deleteProc)
{
    Tcl_CreateObjCommand(interp,cmdName,proc,clientData,deleteProc) ;

} /* end utDbase_create_objcmd() */

void utDbase_delete_command(Tcl_Interp *interp,char *cmdName)
{
    Tcl_DeleteCommand(interp,cmdName) ;

} /* end utDbase_delete_command() */


char *utDbase_cmdname(Tcl_Obj * CONST obj_p )
{
    char *func_objname ;		/* function object name */

    func_objname = Tcl_GetString(obj_p) ;
    return( func_objname ) ;
} /* end utDbase_cmdname() */

BOOL utDhelp_requested( INT objc, Tcl_Obj * const objv[] )
{
    INT i ;				/* argc counter */
    char *str ;				/* current string */

    for( i = 1 ; i < objc ; i++ ){
      str = Tcl_GetString(objv[i]) ;
      if( *str == '-' ){
	if( (strcmp( str, "-help" ) == STRINGEQ) ||
	    (strcmp( str, "--help" ) == STRINGEQ) ){
	  return(TRUE) ;
	}
      }
    }
    return(FALSE) ;
} /* end utDhelp_requested() */

INT utDversion_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc, Tcl_Obj * CONST objv[])
{
    INT c, j ;				/* character counters */
    INT dotcount ;			/* count dots */
    char *argv_1 ;			/* current argument vector 1 */
    char *uname ;			/* machine uname */
    char *version ;			/* version name */
    char buffer[LRECL] ;		/* temp buffer */
    char buffer2[LRECL] ;		/* temp buffer */
    char name_buffer[256] ;		/* buffer for output */
    Tcl_Obj *strObj ;			/* string Tcl object */
    Tcl_Obj *resultPtr ;		/* result information */
    FUNC_NAME("utdversion") ;

    if( utDhelp_requested( objc,objv ) ){
      utDmsgf(IMSG,MSG_AT,routine,"%s : returns the current version of the program.\n" );
      utDmsgf(IMSG,MSG_AT,routine,"%s major : returns the current major version of the program.\n" );
      utDmsgf(IMSG,MSG_AT,routine,"%s minor : returns the current minor version of the program.\n" );
      utDmsgf(IMSG,MSG_AT,routine,"%s uname : returns the OS system name.\n" );
      return( TCL_OK ) ;
    }
    resultPtr = Tcl_GetObjResult(i_p) ;

    version = utDprogram_getVersion() ;
    if( objc >= 2 ){
      argv_1 = Tcl_GetString(objv[1]) ;
      if( utDstricmp( argv_1, "major" ) == STRINGEQ ){
	strcpy( buffer, version ) ;
	dotcount = 0 ;
	for( c = 0 ; c < LRECL && buffer[c] ; c++ ){
	  if( buffer[c] == '.' ){
	    if( ++dotcount > 1 ){
	      buffer[c] = EOS ;
	      break ;
	    }
	  }
	}
	strObj = Tcl_NewStringObj( buffer, -1 ) ;
	Tcl_ListObjAppendElement(NULL,resultPtr, strObj ) ;
	return(TCL_OK) ;
      } else if( utDstricmp( argv_1, "minor" ) == STRINGEQ ){
	strcpy( buffer, version ) ;
	dotcount = 0 ;
	for( c = 0 ; c < LRECL && buffer[c] ; c++ ){
	  if( buffer[c] == '.' ){
	    if( ++dotcount > 1 ){
	      for( j = 0, c++ ; c < LRECL && buffer[c] ; c++,j++ ){
		buffer2[j] = buffer[c] ;
	      }
	      strObj = Tcl_NewStringObj( buffer2, -1 ) ;
	      Tcl_ListObjAppendElement(NULL,resultPtr, strObj ) ;
	      return(TCL_OK) ;
	    }
	  }
	}
      } else if( utDstricmp( argv_1, "uname" ) == STRINGEQ ){
	uname = utDuname() ;
	if( uname ){
	  strObj = Tcl_NewStringObj( uname, -1 ) ;
	  Tcl_ListObjAppendElement(NULL,resultPtr, strObj ) ;
	  return( TCL_OK ) ;
	}
	strObj = Tcl_NewStringObj( "failed to get uname", -1 ) ;
	Tcl_ListObjAppendElement(NULL,resultPtr, strObj ) ;
	return( TCL_ERROR ) ;
      }
    }
    strObj = Tcl_NewStringObj( version, -1 ) ;
    Tcl_ListObjAppendElement(NULL,resultPtr, strObj ) ;
    return(TCL_OK) ;

} /* end utDversion_objfunc() */
