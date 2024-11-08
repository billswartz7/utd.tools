/* ----------------------------------------------------------------- 
     Copyright (c) 2019 TWS.  All rights reserved.
FILE:	    py.h
DESCRIPTION:Include file for Python interpreter functions.
DATE:	    Sun Aug 11 23:19:23 CDT 2019
REVISIONS:  
 * $Log: py.c,v $
 * Revision 1.9  2019/09/16 19:27:57  bills
 * Got rid of a branch that wasn't fruitful.
 *
 * Revision 1.8  2019/09/11 20:27:59  bills
 * Moved function around and streamlined calls by getting rid of unnecessary
 * conditional compiles.
 *
 * Revision 1.7  2019/08/26 14:03:48  bills
 * Added control of interpreter mode and added reissue of command so that it
 * can call twtcl.trans function.   Added our own error check as python does
 * not allow redirection of output.
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
#include <utd/string.h>
#include <utd/dstring.h>
#include <utd/msg.h>
#include <utd/system.h>

#ifdef _POSIX_C_SOURCE
#undef _POSIX_C_SOURCE
#endif /* _POSIX_C_SOURCE */
#define PY_SSIZE_T_CLEAN  /* Make "s#" use Py_ssize_t rather than int. */
#include <python/Python.h>
#include "py.h"

/* ********************** TYPE DEFINITIONS ************************* */
struct py_interp_s {
    PyThreadState *thread_state;
    PyObject *globals;
    BOOL pure_python ;
};

typedef struct module_state {
  PyObject *error;
} MODULE_STATE, *MODULE_STATEPTR ;

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static PyObject *pythonTclEvaluate(PyObject *self, PyObject *args) ;
static PyObject *pythonTclTrans(PyObject *self, PyObject *args) ;
static PyObject *pythonTclMode(PyObject *self, PyObject *args) ;
static void print_python_error_code(PyObject *exception,PyObject *v, PyObject *tb) ;
static char *python_reissue_cmd( const char *str, UTDDSTRINGPTR cmd_p ) ;
static char *python_tcl_namespace_cmds( const char *str, UTDDSTRINGPTR new_cmd_p ) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static unsigned InterpCountS = 0;
static PyThreadState *GlobalThreadS = NULL;

static PyMethodDef tclMethodS[] = {
    {"eval", pythonTclEvaluate, METH_VARARGS, "Evaluate a Tcl script."},
    {"trans", pythonTclTrans, METH_VARARGS, "Translate and evaluate a Python script."},
    {"mode", pythonTclMode, METH_VARARGS, "Change translator mode."},
    {0, 0, 0, 0}                                                                                                      /* sentinel */
} ;

static struct PyModuleDef TclModuleDefS = {
  PyModuleDef_HEAD_INIT,
  "utdtcl",
  NULL,
  sizeof(MODULE_STATE),
  tclMethodS,
  NULL,
  NULL,
  NULL,
  NULL
} ;

/* -----------------------------------------------------------------
 * Initialize the utdtcl module.
----------------------------------------------------------------- */
PyMODINIT_FUNC PyInit_utdtcl(void)
{
    PyObject *tclmod_p ;		/* tcl module object */

    tclmod_p = PyModule_Create(&TclModuleDefS) ;
    if (!(tclmod_p)){
      return(NULL) ;
    }
    Py_INCREF(tclmod_p) ;
    return( tclmod_p ) ;
} /* end PyInit_utdtcl() */

//------------------------------------------------------------------------------
UTDTCL_PYPTR utDpython_new_interpreter(INT argc,char *argv[] )
{
    PyObject *tclmod_p ;		/* tcl module object */
    PyThreadState *thread_state ;	/* create a new thread state */
    char *utddir ;			/* UTD tools top directory */
    char *utdversion ;			/* UTD tools version */
    char *python_path ;			/* path to the python root */
    char *sys_path ;			/* create the system current working dir */
    const wchar_t *rootdir ;		/* the python root directory */
    size_t len ;			/* length of root directory */
    char  pwd_buf[LRECL] ;		/* space for woriking directory */
    UTDDSTRING path_buf ;			/* path buffer */
    INT i ;				/* arguement counter */
    FUNC_NAME("utDpython_new_interpreter") ;
    
    if( InterpCountS == 0 ){
	// First time initializing Python
	Py_NoSiteFlag = 1 ;
	/* Add a built-in module, before Py_Initialize */
	PyImport_AppendInittab("utdtcl", PyInit_utdtcl) ;
	/* Now set the Python home root directory which is OS dependent */
	utddir = utDgetenv("UTDTOOLS") ;
	utdversion = utDgetenv("UTDTOOLSVERSION") ;
	if( utddir && utdversion ){
	  utDdstring_init(&path_buf) ;
	  python_path = utDdstring_printf( &path_buf, "%s/%s", utddir, utdversion) ;
	  rootdir = Py_DecodeLocale(python_path, &len) ;
	  if( rootdir ){
	    Py_SetPythonHome(rootdir) ;
	  }
	  wchar_t *cur_path_p = Py_GetPath() ;
	  if( cur_path_p ){
	    utDmsgf(IMSG, MSG_AT, routine, "UTDPYTHONPATH=%ls\n", cur_path_p ) ;
	  }
	  utDdstring_free(&path_buf) ;
	}
	utDpython_install_pure() ;
	Py_Initialize() ;
	PyEval_InitThreads() ;
	GlobalThreadS = PyEval_SaveThread() ;
    }
    
    PyEval_RestoreThread(GlobalThreadS) ;
    thread_state = Py_NewInterpreter() ;

    /* tclmod_p = PyInit_utdtcl() ;  Not needed as it is called by import */
    
    UTDTCL_PYPTR interp ;
    interp = UTDMALLOC( 1, UTDTCL_PY ) ;
    interp->thread_state = thread_state ;
    interp->globals = PyModule_GetDict(PyImport_AddModule("__main__")) ;
    interp->pure_python = FALSE ;
    tclmod_p = PyImport_ImportModuleLevel("utdtcl", interp->globals, NULL, NULL,  0 ) ;


    /* -----------------------------------------------------------------2
     * Setup working directory, and sys argv for program
     ----------------------------------------------------------------- */
    PyRun_SimpleString( "import sys" ) ;
    utDdstring_init(& path_buf ) ;
    utDdstring_append( &path_buf, "sys.path.append('", -1 ) ;
    utDdstring_append( &path_buf,  utDgetwd( pwd_buf, LRECL ),  -1 ) ;
    sys_path = utDdstring_append( &path_buf,  "')",  -1 ) ;
    PyRun_SimpleString( sys_path ) ;

    utDdstring_reinit( &path_buf ) ;
    utDdstring_append( &path_buf,  "sys.argv = [", -1 ) ;
    for( i = 0 ; i < argc ; i++ ){
      if( i ){
	utDdstring_append( &path_buf,  ",", -1 ) ;
      }
      utDdstring_printf( &path_buf,  "%c%s%c", DQUOTE, argv[i], DQUOTE ) ;
    }
    sys_path = utDdstring_append( &path_buf,  "]", -1 ) ;
    PyRun_SimpleString( sys_path ) ;

    utDdstring_free(&path_buf) ;

    PyEval_SaveThread() ;
    
    InterpCountS++ ;
    return(interp) ;
} /* end utDpython_new_interpreter() */


//------------------------------------------------------------------------------
void utDpython_delete_interpreter(UTDTCL_PYPTR interp )
{
    PyEval_RestoreThread(interp->thread_state);
    Py_EndInterpreter(interp->thread_state);
    PyEval_ReleaseLock();
    
    UTDFREE(interp) ;
    InterpCountS-- ;
    
    if(InterpCountS == 0){
        // no remaining sub-interpreters
        // Clean up Python's interpreter
	PyEval_RestoreThread(GlobalThreadS) ;
        Py_Finalize();
	GlobalThreadS = NULL ;
    }
} /* end utDpython_delete_interpreter() */

//------------------------------------------------------------------------------
int utDpython_exec(UTDTCL_PYPTR interp, const char *str)
{
    int res ;					/* result of command */
    char *already_translated ;			/* already been translated */
    const char *reissue_str ;			/* reissue command string */
    const char *className ;			/* error class name */
    UTDDSTRING new_command_buf ;		/* new command buffer */
    PyObject *py_result ;			/* result from Python */
    PyObject *eType, *eValue, *eTraceBack ;	/* traceback variables */

    PyEval_RestoreThread(interp->thread_state) ;
    if(!(interp->pure_python)){
      utDdstring_init(&new_command_buf) ;
      already_translated = utDstrsub( (char *) str, "utdtcl" ) ;
      if(!(already_translated)){
	str = python_tcl_namespace_cmds( str, &new_command_buf ) ;
      }
      py_result = PyRun_String(str, Py_file_input, interp->globals, interp->globals) ;
      utDdstring_free(&new_command_buf) ;
    } else {
      py_result = PyRun_String(str, Py_file_input, interp->globals, interp->globals) ;
    }
    if(!(py_result)) {
      PyErr_Fetch(&eType,&eValue,&eTraceBack) ;
      if( eType ){
	className = (char *) PyExceptionClass_Name(eType) ;
 	if( !(interp->pure_python) && !(strcmp( className, "NameError" ))){
	  already_translated = utDstrsub( (char *) str, "utdtcl" ) ;
	  if(!(already_translated)){
	    utDdstring_init(&new_command_buf) ;
	    reissue_str = python_reissue_cmd( str, &new_command_buf ) ;
	    if( reissue_str ){
	      py_result = PyRun_String(reissue_str, Py_file_input, interp->globals, interp->globals) ;
	      utDdstring_free(&new_command_buf) ;
	      if( py_result ) {
		Py_DECREF(py_result) ;
		PyEval_SaveThread();
		res = 0 ;
		return(res) ;
	      }
	    }
	    utDdstring_free(&new_command_buf) ;
	  }
	  print_python_error_code( eType, eValue, eTraceBack ) ;
	} else {
	  print_python_error_code( eType, eValue, eTraceBack ) ;
	}
      }
      res = -1 ;
    } else {
      Py_DECREF(py_result) ;
      res = 0 ;
    }
    PyEval_SaveThread() ;
    return(res) ;
} /* end utDpython_exec() */

/* -----------------------------------------------------------------
 * Open an new interpreter in a new thread so we don't corrupt the
 * old one and test to see if the command is good.  This really
 * took some doing to figure out how to make this work properly.
 * Not sure how this will change for future versions of Python. WPS
 ----------------------------------------------------------------- */
int utDpython_test_command(UTDTCL_PYPTR interp, const char *str) 
{
    int res ;				/* return state */
    PyObject *co ;			/* compile object */
    PyThreadState *tmp_thread_state ;	/* create a new threaded interpreter */
    PyCompilerFlags comp_flags ; 	/* compiler flags */

    PyEval_RestoreThread(GlobalThreadS) ;
    tmp_thread_state = Py_NewInterpreter() ;

    PyEval_SaveThread() ;

    /* Now jump to new thread state */
    PyEval_RestoreThread(tmp_thread_state) ;

    (void) memset( (char *)&comp_flags, 0L, sizeof(comp_flags));
    comp_flags.cf_flags = PyCF_ONLY_AST ;
    comp_flags.cf_feature_version = PY_MINOR_VERSION ;
    co = Py_CompileStringExFlags( str, "<string>", Py_file_input, &comp_flags, 0 ) ;
    if( co ){
      Py_DECREF( co ) ;
      res = 0 ;
    } else {
      res = -1 ;
    }
    PyThreadState_Clear(tmp_thread_state) ;
    Py_EndInterpreter(tmp_thread_state) ;
    PyEval_ReleaseLock() ;
    return(res);

} /* end utDpython_test_command() */

//------------------------------------------------------------------------------
char* utDpython_eval(UTDTCL_PYPTR interp, const char *str)
{
    PyObject *py_result ;
    char *result_str ;
    PyEval_RestoreThread(interp->thread_state);
    
    py_result = PyRun_String(str, Py_eval_input, interp->globals, interp->globals);
    if(!py_result) {
        // an error occurred
        PyErr_PrintEx(1);
        result_str = NULL;
    } else {
        PyObject *py_result_str;
        const char *tmp_str;
        
        // Get string representation of result
        py_result_str = PyObject_Str(py_result);
        tmp_str = PyUnicode_AsUTF8(py_result_str);
        
        /* Copy string */
        result_str = utDstrclone( (char *) tmp_str ) ;
        
        // Free python result objects
        Py_DECREF(py_result_str) ;
        Py_DECREF(py_result) ;
    }
    PyEval_SaveThread();
        
    return(result_str);
} /* end utDpython_eval() */

/* -----------------------------------------------------------------
 * Command to set and retrieve opaque pure_python item in TWTCL_PY structure.
----------------------------------------------------------------- */
BOOL utDpython_set_pure_python_mode( UTDTCL_PYPTR interp, INT flag )
{
    if( interp ){
      if( flag >= 0 ){
	interp->pure_python = flag ;
      }
      return( interp->pure_python ) ;
    } else {
      return(TRUE) ;
    }
} /* end utDpython_set_pure_python_mode() */

/* -----------------------------------------------------------------
 * Called from Python, parse the Python and then call utDpython_tclEvaluate
----------------------------------------------------------------- */
static PyObject *pythonTclEvaluate(PyObject *self, PyObject *args)
{
    CONST char *script ;
    char *result ;
    int length ;

    if (!(PyArg_ParseTuple(args, "s", &script))){
      return( 0 ) ;
    }
    length = strlen(script) ;
    if ( utDpython_tclEvaluate( script, &result, &length) ) {
      PyErr_SetString(PyExc_RuntimeError, result) ;
    }
    return( Py_BuildValue("s", result) ) ;
} /* end pythonTclEvaluate() */

/* -----------------------------------------------------------------
 * Called from Python, parse the Python, convert it Tcl and then call 
 * utDpython_tclEvaluate
----------------------------------------------------------------- */
static PyObject *pythonTclTrans(PyObject *self, PyObject *args)
{
    CONST char *script ;
    char *result ;
    int length ;

    Py_ssize_t num_args = PyTuple_Size(args) ;
    if (!(PyArg_ParseTuple(args, "s", &script))){
      return( 0 ) ;
    }
    length = strlen(script) ;
    if ( utDpython_tclTranslate( script, &result, &length) ) {
      PyErr_SetString(PyExc_RuntimeError, result) ;
    }
    return( Py_BuildValue("s", result) ) ;
} /* end pythonTclTrans() */

/* -----------------------------------------------------------------
 * Called from Python, parse the Python, convert it Tcl and then call 
 * utDpython_tclEvaluate
----------------------------------------------------------------- */
static PyObject *pythonTclMode(PyObject *self, PyObject *args)
{
    CONST char *script ;
    char *result ;
    char mode_cmd[80] ;
    int length ;

    Py_ssize_t num_args = PyTuple_Size(args) ;
    if( num_args == 0 ){
      script = "utdpython::mode" ;
      if ( utDpython_tclEvaluate( script, &result, &length) ) {
	PyErr_SetString(PyExc_RuntimeError, result) ;
      }
      return( Py_BuildValue("s", result) ) ;
    } else if (!(PyArg_ParseTuple(args, "s", &script))){
      return(0) ;
    }
    length = strlen(script) ;
    if( length > 40 ){
      return(0) ;
    }
    sprintf( mode_cmd, "utdpython::mode %s", script ) ;
    if ( utDpython_tclEvaluate( mode_cmd, &result, &length) ) {
      PyErr_SetString(PyExc_RuntimeError, result) ;
    }
    return( Py_BuildValue("s", result) ) ;
} /* end pythonTclMode() */

static char *python_reissue_cmd( const char *str, UTDDSTRINGPTR new_cmd_p )
{
    char *new_cmd ;			/* new command */
    char *new_line ;			/* new line position */
    INT len ;				/* length of string */

    new_line = strchr( str, '\n' ) ;
    if( new_line ){
      utDdstring_append( new_cmd_p, "utdtcl.trans(\"", -1 ) ;
      len = new_line - str ;
      utDdstring_append( new_cmd_p, (char *) str, len ) ;
      utDdstring_append( new_cmd_p, "\")\n", -1 ) ;
    } else {
      utDdstring_printf( new_cmd_p, "utdtcl.trans(\"%s\")\n", str ) ;
    }
    new_cmd = utDdstring_value( new_cmd_p ) ;
    return( new_cmd ) ;

}  /* end python_reissue_cmd() */

static char *python_tcl_namespace_cmds( const char *str, UTDDSTRINGPTR new_cmd_p )
{
    char *new_cmd ;			/* newly issued command */
    char *namespace_string ;		/* look for Tcl namespace syntax */
    /* Look for illegal :: string in command.  These are never valid in Python */
    namespace_string = utDstrsub( (char *) str, "::" ) ;
    if( namespace_string ){
      new_cmd = python_reissue_cmd( str, new_cmd_p ) ;
      return( new_cmd ) ;
    }
    return( (char *) str ) ;
} /* end python_tcl_namespace_cmds() */

_Py_IDENTIFIER(excepthook);

static void print_python_error_code(PyObject *exception,PyObject *v, PyObject *tb)
{
    PyObject *hook ;

    if (!(exception))
        return;
    PyErr_NormalizeException(&exception, &v, &tb);
    if (!(tb)) {
        tb = Py_None;
        Py_INCREF(tb);
    }
    PyException_SetTraceback(v, tb);
    if (!(exception))
        return;
    hook = _PySys_GetObjectId(&PyId_excepthook);
    if (hook) {
        PyObject* stack[3];
        PyObject *result;

        stack[0] = exception;
        stack[1] = v;
        stack[2] = tb;
        result = _PyObject_FastCall(hook, stack, 3);
        if (!(result)) {
            PyObject *exception2, *v2, *tb2;
            PyErr_Fetch(&exception2, &v2, &tb2);
            PyErr_NormalizeException(&exception2, &v2, &tb2);
            /* It should not be possible for exception2 or v2
               to be NULL. However PyErr_Display() can't
               tolerate NULLs, so just be safe. */
            if (exception2 == NULL) {
                exception2 = Py_None;
                Py_INCREF(exception2);
            }
            if (!(v2)) {
                v2 = Py_None;
                Py_INCREF(v2);
            }
            fflush(stdout);
            PySys_WriteStderr("Error in sys.excepthook:\n");
            PyErr_Display(exception2, v2, tb2);
            PySys_WriteStderr("\nOriginal exception was:\n");
            PyErr_Display(exception, v, tb);
            Py_DECREF(exception2);
            Py_DECREF(v2);
            Py_XDECREF(tb2);
        }
        Py_XDECREF(result);
    } else {
        PySys_WriteStderr("sys.excepthook is missing\n");
        PyErr_Display(exception, v, tb);
    }
    Py_XDECREF(exception);
    Py_XDECREF(v);
    Py_XDECREF(tb);
} /* end my_PrintEx() */
