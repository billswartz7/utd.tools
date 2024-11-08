/* ----------------------------------------------------------------- 
     Copyright (c) 2019 William Swartz.  All rights reserved.
FILE:	    utd.h
DESCRIPTION:UTD common functions.
REVISIONS: 
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_UTD_H
#define INCLUDED_UTD_UTD_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#include <tcl/tcl.h>

/* ********************** TYPE DEFINITIONS ************************* */
#ifndef Tcl_DStringReinit
#define Tcl_DStringReinit(x_xz) Tcl_DStringSetLength(x_xz,0)
#endif /* Tcl_DStringReinit */

/* ********************** Function Prototypes ********************** */

/* -----------------------------------------------------------------
 * Initialization routines called at the very beginning of the program.
 ----------------------------------------------------------------- */
extern const char *utDInit( int argc, char *argv[], const char *cktName,
                          const char *pgm_version, const char *compile_date, 
			  const char *program_description,
			  const char *alternate_path ) ;

/* -----------------------------------------------------------------
 * Remove braces around Tcl name
 * ----------------------------------------------------------------- */
extern char *utD_adjust_tcl_name( char *name, char *buffer ) ;

/* -----------------------------------------------------------------
 * Checks to see if we need to remove {} around string
 * ----------------------------------------------------------------- */
extern char *utD_check_tcl_name( char *name, char *buffer ) ;

/* -----------------------------------------------------------------
 * Read in a Tcl script into memory and return back a block of memory
 * containing the contents.
 * ----------------------------------------------------------------- */
extern const char *utD_process_script( char *script_file_name ) ;

/* Some wrapper script for possible future abstraction */
extern void utDbase_create_objcmd(Tcl_Interp *interp,char *cmdName,Tcl_ObjCmdProc *proc,
	                          ClientData clientData,Tcl_CmdDeleteProc *deleteProc) ;

extern void utDbase_delete_command(Tcl_Interp *interp,char *cmdName) ;

extern char *utDbase_cmdname(Tcl_Obj * CONST obj_p ) ;

/* -----------------------------------------------------------------
 * User has requested help.
 * ----------------------------------------------------------------- */
extern BOOL utDhelp_requested( INT objc, Tcl_Obj * const objv[] ) ;


#ifdef __cplusplus
} ;
#endif /* __cplusplus */


#endif /* INCLUDED_UTD_UTD_H */
