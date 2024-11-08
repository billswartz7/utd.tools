/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    gui.h
DESCRIPTION:C language prototypes for gui
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_GUI_GUI_H
#define INCLUDED_GUI_GUI_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#include <utd/base.h>
#include <utd/baseobj.h>
#include <tcl/tcl.h>
#include <tk/tk.h>
#include <tix/tix.h>

typedef enum {
  UTDGUI_OPT_NONE_T 	= 		0,
  UTDGUI_OPT_GRAPHICS_T = 		1,
  UTDGUI_OPT_NO_STDIN_HANDLER_T =	(1L << 1)
} UTDGUI_OPTS_T ;

typedef enum {
    UTDTRANS_CENTER =	0,
    UTDTRANS_LB =	1,
    UTDTRANS_RT =	2,
    UTDTRANS_ORIGIN =	3,  /* 2 bits */
    UTDTRANS_XVALID =	(1L << 2),
    UTDTRANS_YVALID =	(1L << 3),
    UTDTRANS_XDELTA =	(1L << 4),
    UTDTRANS_YDELTA =	(1L << 5)
} UTDTRANS_T ;

#define utDGUIdrawBox( l_xz, b_xz, r_xz, t_xz, color_xz, label_xz ) \
utDGUIdrawLine( (l_xz), (b_xz), (r_xz), (b_xz), (color_xz), (label_xz) ); \
utDGUIdrawLine( (r_xz), (b_xz), (r_xz), (t_xz), (color_xz), (label_xz) ); \
utDGUIdrawLine( (r_xz), (t_xz), (l_xz), (t_xz), (color_xz), (label_xz) ); \
utDGUIdrawLine( (l_xz), (t_xz), (l_xz), (b_xz), (color_xz), (label_xz) );

/* -----------------------------------------------------------------
 * utDGUI_init is the routine used to initialize a graphics user interface
 * which is based on Tix/Tk/Tcl.  If the the graphics_flag is set to FALSE,
 * only a Tcl interpreter is created on the terminal.  The routine
 * takes argc and argv from main so it can process command line arguments.
 * The user specifies a refresh function which the user supplies.  The
 * refresh function is expected to redraw all of the data found within
 * the rectangular redraw area.  The clientData field allows the user
 * to pass data to the refresh_func call.  An optional did file pointer
 * allows the transcription of all commands entered into the Tcl interpreter.
 * The parasite window id is a future feature.  The user may also optionally
 * pass in an initialization function which passes the Tcl interpreter to
 * it.
 * ----------------------------------------------------------------- */
extern BOOL utDGUI_init( int argc,char *argv[],
                const char *script_file,
		Tcl_Interp *interp,
		UTDGUI_OPTS_T options, 
		void (*refresh_func)(UTDRECTPTR redraw_area,void *clientData),
		void *clientData,
		FILE *did_file,
		void (*init_func)(void *),
		INT parasite_windowId ) ;

/* -----------------------------------------------------------------
 * utDGUI_run invokes a graphics wait loop.  The program will wait
 * in the loop to process graphics or Tcl commands.  Use the command
 * utDGUI_continue or the Tcl command "orcontinue" to exit loop. It
 * does *NOT* exit the program.
 * ----------------------------------------------------------------- */
extern void utDGUI_run( void ) ;

/* -----------------------------------------------------------------
 * Invoke a Tcl command without knowledge of the Tcl interpreter.
 * The first form allows user to specify the message type: ERRMSG, WARNMSG,
 * DBGMSG, IMSG, or MSG.
 * ----------------------------------------------------------------- */
extern const char * _utDGUI_exec_tcl( const char *command, INT *status, MSG_TYPE_T mtype ) ;
extern const char * utDGUI_exec_tcl( const char *command, INT *status ) ;

extern void utDGUIdraw_frame_update(void) ;

/* start a new slate */
extern void utDGUIstartFrame(void) ;

/* flush the current frame to the display */
extern void utDGUIflushFrame(void) ;

/* The user may force a redraw using current frame dimensions */
extern void utDGUIforceRedraw(void) ;

/* Set the default drawing frame to the given coordinates.  Scale and
 * precision is provide to make database units easier to manipulate.
 */
extern void utDGUIsetFrame( DOUBLE left,DOUBLE bottom,DOUBLE right,DOUBLE top,
		      DOUBLE scale, INT precision ) ;

/* draw a one pixel tall line segment from x1,y1 to x2,y2 */
extern void utDGUIdrawLine(DOUBLE x1,DOUBLE y1,DOUBLE x2,DOUBLE y2,INT color,const char *label) ;

/* -----------------------------------------------------------------
 * Draw a rectangle whose diagonals are (x1,y1) and (x2,y2)
*  if the specified color is default or invalid, use default color.
 * A border will be draw around the cell if specified black (default).
----------------------------------------------------------------- */
extern void utDGUIdrawRect(DOUBLE x1,DOUBLE y1,DOUBLE x2,DOUBLE y2,INT color,const char *label) ;

extern INT utDGUIget_border_color(void) ;

extern void utDGUIborder_color(INT color) ;

extern INT utDGUIdefault_border_color(void) ;

extern void utDGUIcheckMouse(BOOL wait_flag) ;

extern void utDGUIzoom(DOUBLE x1, DOUBLE y1, DOUBLE x2, DOUBLE y2 ) ;

extern void utDGUItranslate( const char *msg,DOUBLE x1,DOUBLE y1,UTDTRANS_T options) ;

extern void utDGUIzoom_factor(DOUBLE factor) ;

/* -----------------------------------------------------------------
 * Restore to a full frame configured by utDGUIsetFrame.
 * ----------------------------------------------------------------- */
extern void utDGUIfullFrame(void) ;

/* -----------------------------------------------------------------
 * Get a coordinate from the user.
 * ----------------------------------------------------------------- */
extern BOOL utDGUIgetPt( DOUBLE *x, DOUBLE *y ) ;

/* -----------------------------------------------------------------
 * Perform a rubber band from the given starting point.
 * ----------------------------------------------------------------- */
extern BOOL utDGUIpickRect( INT color, DOUBLE ptx, DOUBLE pty, DOUBLE *x2, DOUBLE *y2 ) ;

/* -----------------------------------------------------------------
 * Check the error code of an executed Tcl command.  Pass in static code
 * an use label and routine like UTDmsg.
 * ----------------------------------------------------------------- */
extern void utDGUIcheck_tcl_code(Tcl_Interp *i_p,INT code,const char *label,const char *routine) ;

/* -----------------------------------------------------------------
 * Returns the state of the GUI.  Returns true if graphics have been
 * initialized, false otherwise.
 * ----------------------------------------------------------------- */
extern BOOL utDGUIstate( void ) ;

/* -----------------------------------------------------------------
    Arguments:None 
    Function:
    Save the graphics state before calling a graphics parasite.  Returns
    the window ID which is needed in the utDinitParasite argument list.
 * ----------------------------------------------------------------- */
extern INT utDGUIsaveState( void ) ;

/* -----------------------------------------------------------------
    Arguments:None 
    Function:
    Return the graphics state to the state before the graphics parasite
    was called.
 * ----------------------------------------------------------------- */
extern void utDGUIrestoreState( void ) ;

/* -----------------------------------------------------------------
    Used in controlling window state.
 * ----------------------------------------------------------------- */
extern void utDGUIwindowState( Display *display, Window window, BOOL on_state ) ;

/* -----------------------------------------------------------------
    Used in shutting down graphics.
 * ----------------------------------------------------------------- */
extern BOOL utDGUIready_func(INT flag) ;
extern void utDGUIcloseGraphics(void) ;
extern INT utDGUIabort_graphics(INT status) ;


#include <gui/colors.h>

#include <gui/utils.h>

#ifdef __cplusplus
} ;
#endif /* __cplusplus */


#endif /* INCLUDED_GUI_GUI_H */
