/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    open_gui_int.h                                       
DESCRIPTION:Private include file for compilation.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDE_OPEN_GUI_INT_H
#define INCLUDE_OPEN_GUI_INT_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* ********************** TYPE DEFINITIONS ************************* */
#define GRAPHICS "utdtools"

#define OBSCURED	(1)
#define UNOBSCURED	(0)

#define INT_WIDTH	(500)
#define INT_HEIGHT	(500)
#define INT_X		(1)
#define INT_Y		(1)

#ifndef DIRECT_DRAW
#define DRAWABLE	(gc_p->pixmap)
#else 
#define DRAWABLE	(gc_p->draw)
#endif /* DIRECT_DRAW */
#define ALARM_REDRAW() if( gc_p->alarm_draw ) utDGUIdraw_frame_update()
#define FRAME_UPDATE	(unsigned) 1

/* the place where these graphic contexts are stored */ 
#define DEFAULT_HIGHLIGHT_COLOR  "yellow"
#define HIGHLITE   	(0)
#define WHITE    	(1)
#define BLACK   	(2)

#define DEF_LINE_WIDTH	(1)
#define GRAPHICS_TIMEOUT 120

#ifndef SHORT_MAX
#define SHORT_MAX	32767
#endif /* SHORT_MAX */

#ifndef SHORT_MIN
#define SHORT_MIN	(-SHORT_MAX -  1)
#endif /* SHORT_MIN */

#define IC_WAIT		1
#define IC_NOWAIT	0

#define UTDTRANS_MSG_C	"[TRANSLATE]:Pick or enter center of view:"
#define UTDTRANS_MSG_LB	"[TRANSLATE]:Pick or enter lower left origin of view:"


extern void utDGUIinitcolors( GraphicsContextPtr gcon_p ) ;
extern INT colors_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[]) ;

/* just temporary - we need to patch Tcl and Tk sources for include paths */
#ifdef LATER
extern int Tk_UpdateObjCmd(
    ClientData clientData,	/* Main window associated with interpreter. */
    Tcl_Interp *interp,		/* Current interpreter. */
    int objc,			/* Number of arguments. */
    Tcl_Obj *const objv[]) ;	/* Argument objects. */
#endif /* LATER */

extern int TclRenameCommand(
    Tcl_Interp *interp,		/* Current interpreter. */
    const char *oldName,	/* Existing command name. */
    const char *newName) ;	/* New command name. */

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDE_OPEN_GUI_INT_H */
