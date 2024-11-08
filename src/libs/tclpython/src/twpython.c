/* ----------------------------------------------------------------- 
     Copyright (c) 2019 TWS.  All rights reserved.
FILE:	    twpython.c
DESCRIPTION:Include file for Python interpreter functions.
DATE:	    Sun Aug 11 23:19:23 CDT 2019
REVISIONS:  
 * $Log: twpython.c,v $
 * Revision 1.15  2020/02/21 19:28:05  bills
 * Now we use Tcl_GetXXXType commands to check Tcl representation.
 *
 * Revision 1.14  2019/11/14 14:35:21  bills
 * Updated for new list data object representation which is a list.
 *
 * Revision 1.13  2019/09/23 15:08:16  bills
 * This version can tranfer interger objects from Tcl back to Python without
 * losing information.    This version only works on a flat script.
 *
 * Revision 1.12  2019/09/21 04:33:02  bills
 * Added lookup of variables in Python to populate the command passed to Tcl.  In
 * addition, coded one Tcl Object to Python Object return value, that is, the
 * assignment from a long value in Tcl is properly populated as an object in
 * Python.   More types need to be added.
 *
 * Revision 1.11  2019/09/17 01:24:30  bills
 * Added some debug info for argument vector setup messages.
 *
 * Revision 1.10  2019/09/16 19:28:26  bills
 * Now we build the command line arguments for the interpreter.
 *
 * Revision 1.9  2019/09/11 20:26:07  bills
 * Started work on adding program command line options.   Incomplete and
 * hardcoded.
 *
 * Revision 1.8  2019/09/02 13:36:09  bills
 * Added python_process_string to handle double quotes properly.
 *
 * Revision 1.7  2019/08/26 14:03:13  bills
 * Removed single quotes around strings so it is correct Python.
 *
 * Revision 1.6  2019/08/20 13:47:23  bills
 * Added TWpython_test_command and TWpython_tclTranslate code.
 *
 * Revision 1.5  2019/08/14 14:13:51  bills
 * Added initialization of PYTHONHOME and fixed typo to allow compilation on Mac.
 *
 * Revision 1.4  2019/08/13 19:23:25  bills
 * Changes made so that it compiles on t3.
 *
 * Revision 1.3  2019/08/13 18:29:13  bills
 * Working version of basic Tcl->Python->Tcl code.   Working on trans of Python
 * to TCL.
 *
 * Revision 1.2  2019/08/12 04:23:45  bills
 * Updated by adding log and comments.
 *
----------------------------------------------------------------- */
#include <cometconfig.h>
#include <utd/base.h>
#include <stdlib.h>
#include <stdint.h>
#include <utd/string.h>
#define CLEANUP_C
#include <utd/cleanup.h>
#include <utd/dstring.h>
#include <utd/exec.h>
#include <utd/msg.h>

#ifdef _POSIX_C_SOURCE
#undef _POSIX_C_SOURCE
#endif /* _POSIX_C_SOURCE */
#define PY_SSIZE_T_CLEAN  /* Make "s#" use Py_ssize_t rather than int. */
#include <Python.h>
#include <tcl/tcl.h>
#include "py.h"
#include <tcl/tclInt.h>
#include <base/interp.h>

/* ********************** TYPE DEFINITIONS ************************* */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static char *python_process_string( PyObject *globals_p, char *str, BOOL *dquotes,UTDDSTRINGPTR buf_p ) ;
static void python_process_tcl_error( Tcl_Interp *i_p, Tcl_Obj *resultObj ) ;
static void utDpython_process_assignment( PyObject *module_p, const char *variable, Tcl_Obj *resultObj ) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static struct Tcl_HashTable interp_info_tableS ;
static int newIdentifierS ;
static int transparentS ;

/* -----------------------------------------------------------------
 * In the Tcl interpreter, handle a python command.
----------------------------------------------------------------- */
static int pythonInterpreter(ClientData clientData, Tcl_Interp *interpreter, int objc, Tcl_Obj *const objv[]) 
{
    intptr_t identifier;
    Tcl_Obj *object;
    int result;
        
    struct Tcl_HashEntry *I_entry;
    UTDTCL_PYPTR py_interp ;		/* python interpreter */

    if (objc != 3) {
        Tcl_WrongNumArgs(interpreter, 1, objv, "eval|exec script");
        return(TCL_ERROR);
    }
    
    /* interpreter name is "pythonN" */
    I_entry = NULL ;
    if(sscanf(Tcl_GetString(objv[0]), "utdpython%lu", &identifier) == 1) {
        I_entry = Tcl_FindHashEntry(&interp_info_tableS, (ClientData)identifier);
    }
    
    if(!I_entry) {
        object = Tcl_NewObj();
        Tcl_AppendStringsToObj(
            object, "invalid interpreter \"", Tcl_GetString(objv[0]), "\": internal error, please report to tclpython author",
            0
        );
        Tcl_SetObjResult(interpreter, object);
        return(TCL_ERROR);
    }
    py_interp = Tcl_GetHashValue(I_entry);
    
    // choose start token depending on whether this is an evaluation or an execution
    char *subcommand;
    subcommand = Tcl_GetString(objv[1]);
    if(!(strcmp(subcommand, "exec"))){
        if(utDpython_exec(py_interp, Tcl_GetString(objv[2]))) {
            result = TCL_ERROR;
        } else {
            result = TCL_OK;
        }
        // always return an empty result or an error
        object = Tcl_NewObj();
    } else if(!(strcmp(subcommand, "eval"))){
        char *result_str;
        result_str = utDpython_eval(py_interp, Tcl_GetString(objv[2]));
        if(result_str) {
            object = Tcl_NewStringObj(result_str, -1);
            free(result_str);
            result = TCL_OK;
        } else {
            /* an error occurred */
            object = Tcl_NewObj();
            result = TCL_ERROR;
        }
    } else {
        object = Tcl_NewObj();
        Tcl_AppendStringsToObj(object, "bad option \"", subcommand, "\": must be eval or exec", 0);
        result = TCL_ERROR;
    }
    
    Tcl_SetObjResult(interpreter, object);
    return(result);
} /* end pythonInterpreter() */


/* -----------------------------------------------------------------
 * Create a new python interpreter.
----------------------------------------------------------------- */
static int create_python_interpreter(Tcl_Interp *inter_p)
{
    
    Tcl_Obj *new_cmd ;			/* create a new interpreter command */
    UTDTCL_PYPTR py_interp ;		/* python interpreter */
    int created ;			/* hash entry was created */
    intptr_t identifier ;		/* new hash identifer */
    char **argv ;			/* build an argument vector */
    const char *argv_p ;		/* argument vector */
    const char *argv0_p ;		/* 0th argument  */
    const char *argc_p ;		/* argument count */
    INT argc ;				/* number of arguments */
    UTDDSTRING argv_buf ;			/* used to copy arg vector buffer */
    char *btoks[LRECL] ;		/* blank token array */



    utDdstring_init( &argv_buf ) ;			/* used to copy arg vector buffer */
    argc_p = Tcl_GetVar2( inter_p, "argc", NULL, TCL_GLOBAL_ONLY ) ;
    argv_p = Tcl_GetVar2( inter_p, "argv", NULL, TCL_GLOBAL_ONLY ) ;
    argv0_p = Tcl_GetVar2( inter_p, "argv0", NULL, TCL_GLOBAL_ONLY ) ;
    utDdstring_append( &argv_buf, "utdpython ", -1 ) ;
    if( argc_p ){
      argc = atoi( argc_p ) ;
      utDdstring_append( &argv_buf, argv_p, -1 ) ;
      utDmsgf( MSG | MSG_AVOID_STDOUT | MSG_AVOID_GRAPHICS | MSG_AVOID_FILE |
	  MSG_AVOID_LOG | MESSAGE_ERRORFILE_T | MESSAGE_WARNFILE_T | MSG_AVOID_WARNFILE,
	  MSG_AT, "create_python_interpreter", "argv @%d:%s %s\n", argc, argv0_p, utDdstring_value(&argv_buf) ) ;
    }
    argv = utDstrparser2( utDdstring_value(&argv_buf), " ", btoks, &argc ) ;
#ifdef DEBUG
    int c ;
    for( c = 0 ; c <= argc ; c++ ){
      fprintf( stderr, "argv[%d]: %s\n", c, argv[c] ) ;
    }
#endif /* DEBUG */
/*
    Ysignal( SIGINT, Ycleanup ) ;
    */
    py_interp = utDpython_new_interpreter( argc, argv ) ;
    utDdstring_free( &argv_buf ) ;
    if(!(py_interp)){
        Tcl_SetResult( inter_p,
            "cannot create several concurrent Python interpreters\n(Python library was compiled without thread support)",
            TCL_STATIC
        ) ;
        return(TCL_ERROR) ;
    }
    
    // Save python interpreter info
    identifier = newIdentifierS ;
    Tcl_SetHashValue(Tcl_CreateHashEntry(&interp_info_tableS, (ClientData)identifier, &created), py_interp);
    
    // Return "utdpythonN" and register it as a new command keyword
    new_cmd = Tcl_NewStringObj("utdpython", -1) ;
    Tcl_AppendObjToObj(new_cmd, Tcl_NewIntObj(identifier)) ;
    Tcl_SetObjResult(inter_p, new_cmd) ;
    Tcl_CreateObjCommand(inter_p, Tcl_GetString(new_cmd), pythonInterpreter, NULL, NULL) ;
    
    newIdentifierS++ ;
    return(TCL_OK) ;
} /* end create_python_interpreter() */

/* -----------------------------------------------------------------
 * Delete an instance of a Python interpreter and its Tcl handle.
----------------------------------------------------------------- */
static int deleteInterpreter(Tcl_Interp *interpreter, char *name) 
{
    intptr_t identifier ;
    struct Tcl_HashEntry *I_entry ;
    Tcl_Obj *object ;

    UTDTCL_PYPTR py_interp ;		/* python interpreter */
    /* interpreter name is "utdpythonN" */
    I_entry = NULL;
    if(sscanf(name, "utdpython%lu", &identifier) == 1) {
        I_entry = Tcl_FindHashEntry(&interp_info_tableS, (ClientData)identifier);
    }
    
    if(!I_entry) {
        object = Tcl_NewObj();
        Tcl_AppendStringsToObj(object, "invalid interpreter \"", name, 0);
        Tcl_SetObjResult(interpreter, object);
        return(TCL_ERROR) ;
    }
    
    py_interp = Tcl_GetHashValue(I_entry) ;
    utDpython_delete_interpreter(py_interp) ;
    Tcl_DeleteHashEntry(I_entry) ;
    
    return(TCL_OK) ;

} /* end deleteInterpreter() */

/* -----------------------------------------------------------------
 * Handle the created and freeing of Python interpreters.
----------------------------------------------------------------- */
static int cmd_interp(ClientData clientData, Tcl_Interp *inter_p, int objc, Tcl_Obj *const objv[]) 
{
    char *subcommand ;
    Tcl_Obj *object ;
    INT i ;					/* counter */

    if(objc < 2){
        Tcl_WrongNumArgs(inter_p, 1, objv, "create | free ?interp interp ...? | mode [on|off]");
        return(TCL_ERROR);
    }
    subcommand = Tcl_GetString(objv[1]);
    
    if(!(strcmp(subcommand, "create"))){
        if(objc != 2) {
            Tcl_WrongNumArgs(inter_p, 1, objv, "create");
            return(TCL_ERROR);
        } else {
            return( create_python_interpreter(inter_p));
        }
    } else if(!(strcmp(subcommand, "free"))){
        if(objc < 3) {
            Tcl_WrongNumArgs(inter_p, 1, objv, "free ?interp interp ...?");
            return(TCL_ERROR);
        } else {
            for( i = 2; i < objc; i++){
                char *name;
                name = Tcl_GetString(objv[i]);
                if(deleteInterpreter(inter_p, name) != TCL_OK) return(TCL_ERROR);
            }
            return(TCL_OK);
        }
    } else if(!(strcmp(subcommand, "mode"))){
        if( objc >= 3 ) {
	  if (Tcl_GetBooleanFromObj(inter_p, objv[2], &transparentS) != TCL_OK) {
	    return(TCL_ERROR) ;
	  }
	}
	Tcl_SetObjResult(inter_p, Tcl_NewBooleanObj(transparentS) ) ;
	return(TCL_OK);
        
    } else {
        object = Tcl_NewObj();
        Tcl_AppendStringsToObj(object, "bad option \"", subcommand, "\": must be create or free", 0);
        Tcl_SetObjResult(inter_p, object);
        return(TCL_ERROR);
    }
    /* We should never get here */
    return (TCL_ERROR ) ;

} /* end cmd_interp() */

/* -----------------------------------------------------------------
 * Call back into Tcl so we can evaluate a utd command.
 * Returns true if an error occurred.
----------------------------------------------------------------- */
int utDpython_tclEvaluate(const char *script, char **string, int *length)  
{
    Tcl_Interp *inter_p ;
    int result;
    Tcl_Obj *object;

    inter_p = utDinterpreter() ;
    if (!(inter_p)) {
      object = Tcl_NewObj();
      Tcl_AppendStringsToObj(object, "no Tcl interpreter created", 0);
      *string = Tcl_GetStringFromObj(object, length);
      return( TCL_ERROR ) ;
    } else {
      Tcl_Preserve(inter_p);
      result = Tcl_EvalEx( inter_p, script, -1, TCL_EVAL_DIRECT | TCL_EVAL_GLOBAL) ;
      *string = Tcl_GetStringFromObj(Tcl_GetObjResult(inter_p), length ) ;
      Tcl_Release(inter_p) ;
      return (result) ;
    }
} /* end utDpython_tclEvaluate() */


/* -----------------------------------------------------------------
 * Call back into Tcl so we can evaluate a utd command after converting
   Python to Tcl.  Returns true if an error occurred.
----------------------------------------------------------------- */
int utDpython_tclTranslate(const char *script, char **string, int *length)  
{
    Tcl_Interp *inter_p ;
    INT p ;
    INT pargc ;
    INT status ;			/* return status */
    INT result;
    Tcl_Obj *object;
    Tcl_Obj *resultObj ;
    UTDDSTRING tcl_buf ;
    UTDDSTRING script_buf ;
    UTDDSTRING string_buf ;		/* buffer to manipulate string args */
    BOOL double_quotes ;		/* double quotes are required */
    char *adj_p ;
    char *adj_str_p ;
    char *function ;
    char *assignment ;
    char *python_raw ;
    char *python_trimmed ;
    char *left_paren ;
    char right_paren ;
    char *function_args ;
    char *new_script ;
    char **pargv ;
    char *btoks[LRECL] ;
    PyObject *main_name ;		/* should be current module */
    PyObject *module_p ;		/* current module */
    PyObject *globals_p ;		/* globals of main module */
    FUNC_NAME("utDpython_tclTranslate") ;

    inter_p = utDinterpreter() ;
    if (!(inter_p)) {
      object = Tcl_NewObj();
      Tcl_AppendStringsToObj(object, "no Tcl interpreter created", 0);
      *string = Tcl_GetStringFromObj(object, length);
      return( TCL_ERROR ) ;
    } else {
      module_p = PyImport_AddModule("__main__") ;
      globals_p = PyModule_GetDict( module_p ) ;
      Tcl_Preserve(inter_p);
      utDdstring_init(&script_buf) ;
      python_raw = utDdstring_append(&script_buf,(char *)script,-1) ;
      /* Remove all white space */
      python_trimmed = utDstrtrim( python_raw, NULL ) ;
      /* Look for outermost parens */
      left_paren = strchr( python_trimmed, '(' ) ;
      if( left_paren ){
        right_paren = utDstr_last_char( python_trimmed ) ;
	if( right_paren == ')' ){
	  function_args = utDstrrtrim( left_paren+1, ")" ) ;
	  *left_paren = EOS ;
	  function = python_trimmed ;
	  utDdstring_init( &tcl_buf ) ;
	  assignment = strchr( function, '=' ) ;
	  if( assignment ){
	    *assignment = EOS ;
	    function = utDstrltrim( assignment + 1, NULL ) ;
	    python_trimmed = utDstrtrim( python_trimmed, NULL ) ;
	    utDdstring_printf( &tcl_buf, "set %s [", python_trimmed ) ;
	  }
	  utDdstring_append( &tcl_buf, function, -1 ) ;
	  pargv = utDstrparser2( function_args, ",", btoks, &pargc ) ;
	  utDdstring_init( &string_buf ) ;
	  for( p = 0 ; p < pargc ; p++ ){
	    adj_p = utDremove_lblanks( pargv[p] ) ;
	    adj_str_p = python_process_string( globals_p, adj_p, &double_quotes, &string_buf ) ;
	    if( double_quotes ){
	      utDdstring_printf( &tcl_buf, " %c%s%c", DQUOTE, adj_str_p, DQUOTE ) ;
	    } else {
	      utDdstring_printf( &tcl_buf, " %s", adj_str_p ) ;
	    }
	  }
	  utDdstring_free( &string_buf ) ;
	  if( assignment ){
	    utDdstring_append( &tcl_buf, "]", -1 ) ;
	  }
	  new_script = utDdstring_value( &tcl_buf ) ;
	  utDmsgf( MSG | MSG_AVOID_STDOUT | MSG_AVOID_GRAPHICS | MSG_AVOID_FILE |
	      MSG_AVOID_LOG | MESSAGE_ERRORFILE_T | MESSAGE_WARNFILE_T | MSG_AVOID_WARNFILE,
	      MSG_AT, NULL, " :=> %s\n", new_script ) ;
	  result = Tcl_EvalEx( inter_p, new_script, -1, TCL_EVAL_DIRECT | TCL_EVAL_GLOBAL) ;
	  resultObj = Tcl_GetObjResult(inter_p) ;
	  if( result != TCL_OK ){
	    python_process_tcl_error( inter_p, resultObj ) ;
	  }
	  if( assignment ){
	    utDpython_process_assignment( module_p, python_trimmed, resultObj ) ;
	  }
	  *string = Tcl_GetStringFromObj( resultObj, length ) ;
	  utDdstring_free(&script_buf) ;
	  utDdstring_free( &tcl_buf ) ;
	  Tcl_Release(inter_p) ;
	  return (result) ;
	}
      } /* if( left_paren... This means we have a function somewhere in the command */
      
      result = Tcl_EvalEx( inter_p, script, -1, TCL_EVAL_DIRECT | TCL_EVAL_GLOBAL) ;
      resultObj = Tcl_GetObjResult(inter_p) ;
      if( result != TCL_OK ){
	python_process_tcl_error( inter_p, resultObj ) ;
      }
      *string = Tcl_GetStringFromObj( resultObj, length ) ;
      utDdstring_free(&script_buf) ;
      Tcl_Release(inter_p) ;
      return (result) ;
    }
} /* end utDpython_tclTranslate() */

static INT utDpython_pure_evaluate( char *cmd, LONG interpreter_no, UTDINTERPRET_MODE_T mode )
{
    INT result ;			/* result */
    struct Tcl_HashEntry *I_entry;
    UTDTCL_PYPTR py_interp ;		/* python interpreter */
    PyObject *co ;			/* compiled object */
    BOOL test_if_complete ;		/* test string first */
    FUNC_NAME("utDpython_pure_evaluate") ;

    test_if_complete = mode & UTDINTERPRET_TEST_FLAG_T ;
    I_entry = Tcl_FindHashEntry(&interp_info_tableS, (ClientData)interpreter_no);
    if(!(I_entry)) {
      utDmsgf(ERRMSG,MSG_AT,routine,"No python interpreter named utdypthon%d\n", interpreter_no ) ;
      return( TCL_ERROR ) ;
    }
    py_interp = Tcl_GetHashValue(I_entry);
    if(!(test_if_complete)){
      mode = UTDINTERPRET_SIMPLE_MODE( mode ) ;
      if( mode == UTDINTERPRET_PYTHON_T ){
	if(!(strncmp( cmd, "exit(", 5 ))){
	  /* -----------------------------------------------------------------
	   * This is a convience function as we don't want to force users to
	   * import os and use os._exit or from sys import exit.  Just switch
	   * to Tcl and let the Tcl interpreter cleanup.
	   * ----------------------------------------------------------------- */
	  utDpython_set_pure_python_mode( py_interp, FALSE ) ;
	} else {
	  utDpython_set_pure_python_mode( py_interp, TRUE ) ;
	}
      } else {
	utDpython_set_pure_python_mode( py_interp, FALSE ) ;
      }
      if( utDpython_exec(py_interp, cmd) ) {
	result = TCL_ERROR ;
      } else {
	result = TCL_OK ;
      }
    } else {
      if( utDpython_test_command( py_interp, cmd ) ){
	result = TCL_ERROR ;
      } else {
	result = TCL_OK ;
      }
    }
    return( result ) ;

} /* end utDpython_pure_evaluate() */

void utDpython_install_pure(void)
{
    utDpython_load_interpreter( utDpython_pure_evaluate ) ;
}  /* end TWpython_install_pure() */

static int pythonMode(ClientData clientData, Tcl_Interp *inter_p, int objc, Tcl_Obj *const objv[]) 
{
    if (objc == 1 ){
      return(TCL_OK) ;
    } else if( objc >= 1 ){
    }
    return(TCL_OK) ;
} /* end pythonMode() */
//------------------------------------------------------------------------------
#define STR(s) #s
#define XSTR(s) STR(s)

/* -----------------------------------------------------------------
 * The name here must follow Tcl loadable module name convention.
 * ----------------------------------------------------------------- */
EXTERN int Utdpython_Init(Tcl_Interp *interpreter)
{
    #ifdef USE_TCL_STUBS
    if(!(Tcl_InitStubs(interpreter, "8.1", 0))) {
        return(TCL_ERROR);
    }
    #endif
    
    Tcl_InitHashTable(&interp_info_tableS, TCL_ONE_WORD_KEYS);
    newIdentifierS = 0;
    
    Tcl_CreateObjCommand(interpreter, "utdpython", cmd_interp, NULL, NULL);
    return(Tcl_PkgProvide(interpreter, "utdpython", XSTR(TCLPYTHON_VERSION)));
} /* end Utdpython_Init() */

static char *python_process_string( PyObject *globals_p, char *str, BOOL *dquotes_required, UTDDSTRINGPTR buf_p )
{
    char *space ;		/* position of space */
    char *adj_p ;		/* adjusted position */
    char *str_copy ;		/* copy of the string */
    INT len ;			/* length of string */
    BOOL string_value ;		/* found a string value */
    PyObject *variable_p ;	/* lookup a variable */
    PyObject* unicode_p ;	/* unicode encoded */
    PyObject* bytes_p ;		/* encode stirng */

    space = strchr( str, ' ' ) ;
    if( space ){
      *dquotes_required = TRUE ;
    } else {
      *dquotes_required = FALSE ;
    }
    /* See if we have single quotes and remove them if present */
    string_value = FALSE ;
    adj_p = str ;
    if( str[0] == SQUOTE ){
      len = strlen( str ) ;
      if( *(str+len-1) == SQUOTE ){
	adj_p = str + 1 ;
	adj_p[len-2] = EOS ;
	string_value = TRUE ;
      }
    }
    if(!(string_value)){
      /* See if we can look up the variable */
      variable_p = PyDict_GetItemString( globals_p, str) ;
      if( variable_p ){
	unicode_p = PyObject_Repr( variable_p ) ;
	bytes_p = PyUnicode_AsEncodedString( unicode_p, "utf-8", "~E~");
	adj_p = PyBytes_AS_STRING( bytes_p ) ;
	if( adj_p[0] == SQUOTE ){
	  utDdstring_reinit( buf_p ) ;
	  str_copy = utDdstring_append( buf_p, adj_p, -1 ) ;
	  adj_p = utDstr_remove_squotes( str_copy ) ;
	}
      }
    }
    return( adj_p ) ;
} /* end python_process_string() */

static void python_process_tcl_error( Tcl_Interp *i_p, Tcl_Obj *resultObj )
{
    char *errors ;			/* errors found in script */
    const char *error_p ;		/* error info */
    const char *result_string ;		/* result string */
    Tcl_DString error_info ;		/* save off error information */
    FUNC_NAME("python_process_tcl_error") ;

    /* -----------------------------------------------------------------
     * Now we save info because utDmsgf might call interpreter and hose the
     * result.
    ----------------------------------------------------------------- */
    Tcl_DStringInit(&error_info) ;
    error_p = Tcl_GetVar2( i_p, "errorInfo", NULL, TCL_GLOBAL_ONLY ) ;
    result_string = Tcl_GetString( resultObj ) ;
    if ( result_string ) {
      Tcl_DStringAppend(&error_info, result_string, -1 ) ;
      Tcl_DStringAppend(&error_info, "\nstack trace:", -1 ) ;
    } else {
      Tcl_DStringAppend(&error_info, "stack trace:", -1 ) ;
    }
    if( error_p ){
      Tcl_DStringAppend(&error_info, error_p, -1 ) ;
    } else {
      Tcl_DStringAppend(&error_info, "none available", -1 ) ;
    }


    /* Now safe to output the errors */
    errors = Tcl_DStringValue(&error_info) ;
    if( errors ){
      utDmsgf(ERRMSG,MSG_AT,routine, "%s\n", errors ) ;
    } else {
      utDmsgf(ERRMSG,MSG_AT,routine, "\n" ) ;
    }
    Tcl_DStringFree(&error_info) ;
} /* end python_process_tcl_error() */


static void utDpython_process_assignment( PyObject *module_p, const char *variable, Tcl_Obj *resultObj )
{
    LONG long_val ;			/* Tcl long value */
    List *list_rep_p ;			/* Tcl list */
    Tcl_Obj *tcl_dataObj_p ;		/* Tcl object */
    PyObject *long_python ;		/* newly create python long object */
    PyObject *string_python ;		/* newly created python string object */
    const Tcl_ObjType *tcl_int_type ;	/* Tcl integer rep */
    const Tcl_ObjType *tcl_list_type ;	/* Tcl list rep */
    FUNC_NAME("utDpython_process_assignment") ;

    tcl_list_type = Tcl_GetTclListType() ;
    tcl_int_type = Tcl_GetTclIntType() ;
    if(!(resultObj->typePtr)){
      string_python = PyBytes_FromStringAndSize( resultObj->bytes, resultObj->length ) ;
      Py_INCREF(string_python) ;
      if ( PyModule_AddObject(module_p, variable, string_python) < 0) {
	Py_DECREF(module_p) ;
	Py_DECREF(string_python) ;
      }
    } else if( resultObj->typePtr == tcl_list_type ){
      list_rep_p = (List *) resultObj->internalRep.twoPtrValue.ptr1 ;
      if( list_rep_p->elemCount == 1 ){
	tcl_dataObj_p = & list_rep_p->elements[0] ;
	if(!(tcl_dataObj_p->typePtr)){
	  string_python = PyBytes_FromStringAndSize( tcl_dataObj_p->bytes, tcl_dataObj_p->length ) ;
	  Py_INCREF(string_python) ;
	  if ( PyModule_AddObject(module_p, variable, string_python) < 0) {
	    Py_DECREF(module_p) ;
	    Py_DECREF(string_python) ;
	  }
	} else if( tcl_dataObj_p->typePtr == tcl_int_type ){
	  long_val = tcl_dataObj_p->internalRep.longValue ;
	  long_python = PyLong_FromLong( long_val ) ;
	  Py_INCREF(long_python) ;
	  if ( PyModule_AddObject(module_p, variable, long_python) < 0) {
	    Py_DECREF(module_p) ;
	    Py_DECREF(long_python) ;
	  }
	} else {
	  utDmsgf(WARNMSG,MSG_AT,routine, "need to support single element type:%0lx.\n", tcl_dataObj_p->typePtr ) ;
	}
      } else {
	utDmsgf(WARNMSG,MSG_AT,routine, "result list has multiple elements.  Need to fix\n" ) ;
      }
    } else if( resultObj->typePtr == tcl_int_type ){
      long_val = resultObj->internalRep.longValue ;
      long_python = PyLong_FromLong( long_val ) ;
      Py_INCREF(long_python) ;
      if ( PyModule_AddObject(module_p, variable, long_python) < 0) {
	Py_DECREF(module_p) ;
	Py_DECREF(long_python) ;
      }
    } else {
      utDmsgf(WARNMSG,MSG_AT,routine, "need to implement this single return type:%0lx.\n", resultObj->typePtr ) ;
    }
} /* end utDpython_process_assignment() */
