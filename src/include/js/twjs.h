/* ----------------------------------------------------------------- 
FILE:	    twjs.h                                       
DESCRIPTION:Top level javascript interface.  This is a wrapper to the
            low-level javascript interpreter.
CONTENTS:   
DATE:	    Fri Jul  3 14:38:40 CDT 1998
REVISIONS:  $Log$
----------------------------------------------------------------- */
#ifndef TWJS_H
#define TWJS_H

#ifdef TWJS_INTERNAL

typedef struct js_ptr {
  JSRuntime *runtime ;			/* Javascript Runtime Environment */
  JSContext *context ;			/* Javascript Context */
  JSObject *object ;			/* Javascript Global Object */
} TWJS_BOX, *TWJS_PTR ;

#else 
typedef void * TWJS_PTR ;

#endif /* TWJS_INTERNAL */

/* ******************* JAVASCRIPT INCLUDE FILES ****************** */
extern TWJS_PTR TWJS_Init(void *tcl_interp) ;
/* 
Arguments:
    LONG initial_size ;
Function:
    This routine creates an encapsulated Javascript environment for evaluating
    Javascript.  If tcl_interp is non-NULL, the JSevalTcl function is enabled
    for evaluation of tcl.  Due to shortcomings in the javascript, we can
    only use one Tcl Interprter.  If tcl_interp is NULL, Tcl interpreter is
    not enabled.
    
    This function returns a javascript opaque object for use in all subsequent
    calls.  Multiple JS environments are possible but only one Tcl Interpreter.
*/


extern char *TWJS_process_script(TWJS_PTR js_ptr, char *script) ;
/* 
Arguments:
    TWJS_PTR js_ptr ;
    char *script ;
Function:
    Process a JS script.  Script must be a string that is NULL terminated.
    Returns any text result of the script.
*/

extern char *TWJS_process_scriptFile(TWJS_PTR js_ptr, char *filename) ;
/* 
Arguments:
    TWJS_PTR js_ptr ;
    char *filename ;
Function:
    Process a JS script residing in a file.  
    Returns any text result of the script.
*/

extern void TWJS_destroy(TWJS_PTR js_ptr) ;
/* 
Arguments:
    TWJS_PTR js_ptr ;
Function:
    End a Javascript interpreter.
*/

#endif /* TWJS_H */
