/* ----------------------------------------------------------------- 
FILE:	    interp.h                                       
DESCRIPTION:include file for tcl/python interpreter.
CONTENTS:   typedefs, and external routines for twpython facility
DATE:	    Wed Apr  5 14:29:15 CDT 1995
REVISIONS:  
 * $Log: tkinterp.h,v $
 * Revision 1.10  2019/09/11 19:58:47  bills
 * Changed IC_RecordAndEval to TW_RecordAndEval and added TW_PythonCommandComplete.
 *
 * Revision 1.9  2019/08/20 13:42:35  bills
 * Added TWINTERPRET_MODE_T and TWinterpreter_xxx calls in interface with Python.
 *
 * Revision 1.8  2018/11/12 04:16:47  bills
 * Updated to handle RCS fiasco.
 *
 * Revision 1.8  2016/05/25 14:56:39  bills
 * Added Tk_UpdateObjCmd to quiet warnings in tkdraw.c.
 *
 * Revision 1.7  2006/05/06 21:52:57  bills
 * Added ICargs_vargs prototype.h
 * 
 * Revision 1.6  2004/01/28  20:31:33  bills
 * Added IC_RecordAndEval command for graphics.
 *
 * Revision 1.5  2003/11/08  17:55:52  bills
 * Added icmenu_func so user can augment the features.
 *
 * Revision 1.4  2003/04/28  17:44:20  bills
 * Added ICsetInterpreter needed for the floorplanner.
 *
 * Revision 1.3  2002/12/17  19:49:43  bills
 * Adde prototype for Blt_BgExecInit.
 *
 * Revision 1.2  2000/05/29  03:57:17  bills
 * Changed the name from TWinterpreter to ICinterpreter.
 *
 * Revision 1.1  2000/05/26  14:02:23  bills
 * Initial revision
 *
----------------------------------------------------------------- */
#ifndef UTDINTERP_H
#define UTDINTERP_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef enum {
  UTDINTERPRET_GET_T		= 0,
  UTDINTERPRET_TCL_T 		= 1,
  UTDINTERPRET_PYTHON_T 		= 2,
  UTDINTERPRET_TCL_PYTHON_T 	= 3,
  UTDINTERPRET_TEST_FLAG_T 	= 4
} UTDINTERPRET_MODE_T ;

#define UTDINTERPRET_SIMPLE_MODE( mode_xz ) 	( (mode_xz) & 0x3 )

typedef INT  (*UTDPYTHON_CALLBACK)( char *cmd, LONG interpreter_number, UTDINTERPRET_MODE_T mode ) ;

extern Tcl_Interp *utDinterpreter(void) ;

/* -----------------------------------------------------------------
 * Tcl routines which manipulate the interpreter.   Set the interpreter
 * mode unless the mode is UTDINTERPRETER_GET_T which just returns the
 * current interpreter mode.
 * ----------------------------------------------------------------- */
extern UTDINTERPRET_MODE_T utDinterpreter_mode( UTDINTERPRET_MODE_T mode ) ;
extern void utDinterpreter_set_callback( UTDPYTHON_CALLBACK func ) ;
extern void utDpython_load_interpreter( UTDPYTHON_CALLBACK func ) ;

/* -----------------------------------------------------------------
 * Routines which may be called from Tcl programs.
 * ----------------------------------------------------------------- */
extern char *utD_PythonCommandComplete( UTDDSTRINGPTR, char *, BOOL, INT *errors_ret ) ;

/* -----------------------------------------------------------------
 * Tcl routine which sets/controls the interpreter mode.
 * ----------------------------------------------------------------- */
extern INT utDinterpreter_mode_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * CONST objv[]) ;

/* -----------------------------------------------------------------
 * Internal Tk definitions that some functions need to see.
 * ----------------------------------------------------------------- */
extern int Tk_UpdateObjCmd(ClientData clientData, Tcl_Interp *interp, int objc,
			   Tcl_Obj *CONST objv[]) ;

extern int utD_RecordAndEval(Tcl_Interp *interp, char *cmd, int flags) ;

/* -----------------------------------------------------------------
 * How to set and get the Tcl interpreter.
 * ----------------------------------------------------------------- */
extern Tcl_Interp *utDinterpreter(void) ;
extern void utDsetInterpreter(Tcl_Interp *interpreter) ;

extern int Utdpython_Init(Tcl_Interp *interpreter) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* UTDINTERP_H */
