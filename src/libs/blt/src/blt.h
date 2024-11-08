/* ----------------------------------------------------------------- 
     Copyright (c) 1997 TWS.  All rights reserved.
FILE:	    blt.h                                       
DESCRIPTION:Include file for blt functions.
DATE:	    Sat May 10 10:18:06 CDT 1997
REVISIONS: $Log$
----------------------------------------------------------------- */
#ifndef _BLT_H
#define _BLT_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
/*
 *----------------------------------------------------------------------
 *
 * Blt_AppendInt --
 *
 *      Convenience routine to append an integer value to interp->result
 *	as a separate list element.
 *
 * Results:
 *      None.
 *
 * Side effects:
 *      List representation of integer is appended to interp->result.
 *
 *----------------------------------------------------------------------
 */

/*
 *----------------------------------------------------------------------
 *
 * Blt_BgExecInit --
 *
 *	This procedure is invoked to initialize the "bgexec" Tcl
 *	command.  See the user documentation for details on what it
 *	does.
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	See the user documentation.
 *
 *---------------------------------------------------------------------- */
extern int Blt_BgExecInit(Tcl_Interp *interp) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */


#endif /* _BLT_H */
