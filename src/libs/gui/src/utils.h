/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    utils.h
DESCRIPTION:Various GUI utilities
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_GUI_UTILS_H
#define INCLUDED_GUI_UTILS_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#include <tcl/tcl.h>

/* ********************** TYPE DEFINITIONS ************************* */
#ifndef Tcl_DStringReinit
#define Tcl_DStringReinit(x_xz) Tcl_DStringSetLength(x_xz,0)
#endif /* Tcl_DStringReinit */

/* -----------------------------------------------------------------
 * Convenience function to check if the result of a Tcl command execution.
 * ----------------------------------------------------------------- */
extern void utDGUIcheck_tcl_code(Tcl_Interp *interp, INT code, 
                                 const char *label,const char *routine) ;

/* -----------------------------------------------------------------
 * Look at args in Tcl command and see if help was requested.  Returns
 * TRUE if requested, false otherwise.
 * ----------------------------------------------------------------- */
extern BOOL utDhelp_requested( INT objc, Tcl_Obj * const objv[] ) ;

/* -----------------------------------------------------------------
 * This is the command that we call from a user program if compiled without
 * graphics.
 * ----------------------------------------------------------------- */
extern BOOL utDGUI_Tcl_init( int argc,char *argv[],Tcl_Interp *interp,
                             FILE *did_file ) ;

/* -----------------------------------------------------------------
 * These four routines are replacement routines for the user program
 * when graphics are disabled.  They have graphical counterparts.
 * ----------------------------------------------------------------- */
extern void utDGUI_Tcl_run( Tcl_Interp *interp ) ;

extern INT utDGUI_Tcl_continue_objfunc(ClientData d_p,Tcl_Interp *i_p,
                                       INT objc,Tcl_Obj * const objv[]) ;

extern INT utDGUI_Tcl_wait_objfunc(ClientData d_p,Tcl_Interp *i_p,
                                   INT objc,Tcl_Obj * const objv[]) ;

extern INT utDGUI_Tcl_msg_objfunc(ClientData d_p,Tcl_Interp *i_p,
                                  INT objc,Tcl_Obj * const objv[]) ;


#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_GUI_UTILS_H */
