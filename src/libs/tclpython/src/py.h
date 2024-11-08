/* ----------------------------------------------------------------- 
     Copyright (c) 2019 TWS.  All rights reserved.
FILE:	    py.h
DESCRIPTION:Include file for Python interpreter functions.
DATE:	    Sun Aug 11 23:19:23 CDT 2019
REVISIONS:  
 * $Log: py.h,v $
 * Revision 1.5  2020/07/27 13:09:57  bills
 * Added missing TCLPYTHON_VERSION number.
 *
 * Revision 1.4  2019/09/11 20:26:40  bills
 * Added program command line arguments to the new interpreter prototype.
 *
 * Revision 1.3  2019/08/20 13:47:23  bills
 * Added TWpython_test_command and TWpython_tclTranslate code.
 *
 * Revision 1.2  2019/08/13 18:29:13  bills
 * Working version of basic Tcl->Python->Tcl code.   Working on trans of Python
 * to TCL.
 *
 * Revision 1.1  2019/08/12 04:23:24  bills
 * Initial revision
 *
----------------------------------------------------------------- */
#ifndef PY_H
#define PY_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define TCLPYTHON_VERSION	1.0


typedef struct py_interp_s UTDTCL_PY ;
typedef struct py_interp_s *UTDTCL_PYPTR ;

extern UTDTCL_PYPTR utDpython_new_interpreter( INT argc, char *argv[] ) ;
extern void utDpython_delete_interpreter(UTDTCL_PYPTR interp) ;


/* -----------------------------------------------------------------
 * Install a pure Python interpreter.
 ----------------------------------------------------------------- */
extern void utDpython_install_pure(void) ;

/**
* Call Python interpreter via exec() function
* returns 0 if OK. Nonzero if an exception occurred
**/
extern int utDpython_exec(UTDTCL_PYPTR interp, const char *str) ;

/* 
 * Call Python to test is a string is complete and ready to run.
 */
extern int utDpython_test_command(UTDTCL_PYPTR interp, const char *str) ;

/**
* Call Python interpreter via eval() function
* returns Pointer to result string. NULL if an exception occurred.
* Pointer should be deallocated with free() after done using
**/
extern char* utDpython_eval(UTDTCL_PYPTR interp, const char *str) ;

extern int utDpython_tclEvaluate(const char *script, char **string, int *length) ; 

extern int utDpython_tclTranslate(const char *script, char **string, int *length) ; 

extern BOOL utDpython_set_pure_python_mode( UTDTCL_PYPTR interp, INT flag ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */


#endif
