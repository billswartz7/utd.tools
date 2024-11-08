/* ----------------------------------------------------------------- 
     Copyright (c) 2005 TimberWolf Systems, Inc.  All rights reserved.
FILE:	    interp.c
DESCRIPTION:This file contains the common interpreter infrastructure.
DATE:	    Sat Mar 19 01:42:17 CST 2005
REVISIONS:  
 * $Log $
----------------------------------------------------------------- */
#include <cometconfig.h>

#include <utd/base.h>
#include <utd/msg.h>
#include <utd/file.h>
#include <utd/debug.h>
#include <utd/rbtree.h>
/* #include <utd/mmap.h> */
#include <utd/program.h>
/* #include <utd/set.h> */
#include <utd/string.h>
#include <utd/dstring.h>
#include <utd/tcllog.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif /* HAVE_UNISTD_H */
#define VOID void
#include <tcl/tcl.h>
#include <base/utd.h>
#include <base/interp.h>


/* ********************** TYPE DEFINITIONS ************************* */

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
/* -----------------------------------------------------------------
 * Pure Python interpreter callback.   Null if not installed.
 ----------------------------------------------------------------- */
static UTDPYTHON_CALLBACK python_callbackS ;
static UTDPYTHON_CALLBACK python_interpreterS ;
static UTDINTERPRET_MODE_T interpreter_modeS = UTDINTERPRET_TCL_T ;
static Tcl_Interp *current_interpreterS ;
static INT python_indent_levelS = 0 ;

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */

static INT find_python_indent( const char *line )
{
    INT indent ;			/* indentation amount */
    INT spaces ;			/* number of spaces found - round up */
    INT tabs ;				/* number of tabs found */
    const char *ptr ;			/* pointer position */

    if( *line == EOS ){
      return(INT_MAX) ;
    }
    indent = 0 ;
    spaces = 0 ;
    tabs = 0 ;
    for( ptr = line ; ptr && *ptr ; ptr++ ){
      if( *ptr == ' ' ){
	spaces++ ;
      } else if ( *ptr == '\t' ){
	indent++ ;
      } else {
	break ;
      }
    }
    indent = ((spaces+3) / 4) + tabs ;
    return( indent ) ;
} /* end find_python_indent() */

char *utD_PythonCommandComplete( UTDDSTRINGPTR command_p, char *line, BOOL partial_state,INT *error_ret )
{
    INT indent_level ;			/* amount of indentation */
    INT errors ;			/* errors occurred */
    char *cmd ;				/* command information */
    char *test_line ;			/* test the line */
    UTDINTERPRET_MODE_T mode ;		/* interpreter mode */

    mode = utDinterpreter_mode( UTDINTERPRET_GET_T ) ;
    if( partial_state ){
      indent_level = find_python_indent( line ) ;
      if( indent_level <= python_indent_levelS ){
	cmd = utDdstring_value( command_p ) ;
	if( python_callbackS ){
	  errors = (*python_callbackS)( cmd, 0, mode | UTDINTERPRET_TEST_FLAG_T ) ;
	  if( error_ret ){
	    *error_ret = errors ;
	  }
	}
	return ( cmd ) ;
      }
      utDdstring_printf( command_p, "%s\n", line ) ;
      return( NULL ) ;
    } else {
      test_line = utDdstring_printf( command_p, "%s\n", line )  ;
      if( python_callbackS ){
	errors = (*python_callbackS)( test_line, 0,  mode | UTDINTERPRET_TEST_FLAG_T ) ;
	if( error_ret ){
	  *error_ret = errors ;
	}
	if( errors ){
	  python_indent_levelS = find_python_indent( line ) ;
	  return(NULL) ;
	}
      }
    }
    return (utDdstring_value( command_p) ) ;
} /* end utD_PythonCommandComplete() */

UTDINTERPRET_MODE_T utDinterpreter_mode( UTDINTERPRET_MODE_T mode )
{
    if( mode != UTDINTERPRET_GET_T ){
      interpreter_modeS = mode ;
    }
    return( interpreter_modeS ) ;
} /* end utDinterpreter_mode() */

void utDinterpreter_set_callback( UTDPYTHON_CALLBACK func )
{
    python_callbackS = func ;
} /* end utDinterpreter_set_callback() */

/* -----------------------------------------------------------------
 * We do this so data travels one way.  utdpython -> utdgui
 * If loaded, the utdpython module will call back utDpython_load_interpreter
 * which will enable us to change to a pure Python interpreter.  This
 * is a one shot.
 ----------------------------------------------------------------- */
void utDpython_load_interpreter( UTDPYTHON_CALLBACK func )
{
    python_interpreterS = func ;
} /* end utDpython_load_interpreter() */


INT utDinterpreter_mode_objfunc(ClientData d_p,Tcl_Interp *i_p,
                            INT objc,Tcl_Obj * CONST objv[])
{
    char *argv_1 ;			/* first argument */
    Tcl_Obj *strObj ;			/* new string object */
    Tcl_Obj *resultPtr ;		/* result info */
    UTDINTERPRET_MODE_T mode ;		/* interpreter mode */
    FUNC_NAME("utdinterpreter_mode") ;

    if( utDhelp_requested( objc, objv ) ){
      utDmsgf(IMSG, MSG_AT, NULL, "%s : returns the current interpreter mode.\n", routine );
      utDmsgf(IMSG, MSG_AT, NULL, "%s [tcl | python | tcl_python] : set the interpreter mode.\n" );
      return(TCL_OK) ;
    }
    if( objc >= 2 ){
      argv_1 = Tcl_GetString( objv[1] ) ;
      if( strcmp( argv_1, "tcl" ) == STRINGEQ ){
	utDinterpreter_mode( UTDINTERPRET_TCL_T ) ;
	utDinterpreter_set_callback( NULL ) ;
      } else if( strcmp( argv_1, "python" ) == STRINGEQ ){
	utDinterpreter_mode( UTDINTERPRET_PYTHON_T ) ;
	utDinterpreter_set_callback( python_interpreterS ) ;
      } else if( strcmp( argv_1, "tcl_python" ) == STRINGEQ ){
	utDinterpreter_mode( UTDINTERPRET_TCL_PYTHON_T ) ;
	utDinterpreter_set_callback( python_interpreterS ) ;
      } else {
	utDmsgf(ERRMSG, MSG_AT, routine, "unknown interpreter mode:%s\n", argv_1 ) ;
	return( TCL_ERROR ) ;
      }
      return(TCL_OK) ;
    }
    Tcl_ResetResult(i_p) ;
    resultPtr = Tcl_GetObjResult(i_p) ;
    mode = utDinterpreter_mode( UTDINTERPRET_GET_T ) ;
    switch( mode ){
      case UTDINTERPRET_TCL_PYTHON_T:
	strObj = Tcl_NewStringObj("tcl_python", -1 ) ;
	break ;
      case UTDINTERPRET_PYTHON_T:
	strObj = Tcl_NewStringObj("python", -1 ) ;
	break ;
      case UTDINTERPRET_TCL_T:
	strObj = Tcl_NewStringObj("tcl", -1 ) ;
	break ;
      case UTDINTERPRET_GET_T:
      default:
	strObj = Tcl_NewStringObj("unknown", -1 ) ;
    }
    Tcl_ListObjAppendElement(NULL,resultPtr, strObj) ;
    return(TCL_OK) ;
} /* end utDinterpreter_mode_objfunc() */


int utD_RecordAndEval(Tcl_Interp *interp, char *cmd, int flags)
{
  INT code ;				/* return code from Tcl command */
  BOOL python_mode ;			/* one of the Python modes */
  UTDINTERPRET_MODE_T mode ;		/* interpreter mode */

  /* -----------------------------------------------------------------
   * First check the mode.
  ----------------------------------------------------------------- */
  mode = utDinterpreter_mode( UTDINTERPRET_GET_T ) ;

  if( (mode == UTDINTERPRET_PYTHON_T) || (mode == UTDINTERPRET_TCL_PYTHON_T) ){
    python_mode = TRUE ;
  } else {
    python_mode = FALSE ;
  }
      
  if( python_mode && python_callbackS ){
    code = (*python_callbackS)( cmd, 0, mode ) ;
  } else {
    code = Tcl_RecordAndEval(interp, cmd, flags) ;

  }
  return( code ) ;

} /* end utD_RecordAndEval() */

Tcl_Interp *utDinterpreter(void)
{
    return( current_interpreterS ) ;
} /* end utDinterpreter() */

void utDsetInterpreter(Tcl_Interp *interpreter)
{
    current_interpreterS = interpreter ;
} /* end utDsetInterpreter() */
