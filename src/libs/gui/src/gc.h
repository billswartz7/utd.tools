/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    gc.h
DESCRIPTION:Graphics Context used by C and C++
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_GC_H
#define INCLUDED_GC_H

#include <utd/base.h>
#include <utd/baseobj.h>

#ifndef MODULE_SCOPE
#   ifdef __cplusplus
#       define MODULE_SCOPE extern "C"
#   else
#       define MODULE_SCOPE extern
#   endif
#endif

#include <tk/tkCanvas.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#include <gui/colors.h>

  #define UTD_HOMEDIR 	"~/.utd"
  #define DEF_LINE_WIDTH	(1)

#include <gui/interactive.h>

  typedef struct graphics_context {
    int tty ;			/* !0 standard input is a term. 0==file */
    int mode ;			/* determines which mode we are in */
    int screen ;		/* the current screen */
    int numColor ;		/* max color id */
    int color_alloc ;		/* color_alloc */
    int borderColor ; 		/* the current border color */
    int defaultBorderColor ;	/* the default border color */
    int point_not_picked ;	/* point was not chosen */
    int timeout ;		/* timeout for graphics open */
    int *unique_name ;		/* unique color names */
    long main_event ;		/* save the events for a parasite */
    long main_wrapper_event ;	/* save the events for a parasite */
    long last_click ;		/* last click made */
    int init ;     		/* whether initialization performed */
    int color ;			/* color display ??? */
    int pause ;			/* whether pause has been enabled */
    int ready ;			/* whether user programm has added Tcl cmds */
    int tk_mode ;		/* strictly tk mode */
    int fillArb ;		/* whether to fill arbitrary figures */
    int reverse ;		/* reverse video */
    int fullView ;		/* used for zoom window */
    int parasite ;		/* this process is a parasite? */
    int *colorOn ;		/* is color turned on ??? */
    int rect_fill ; 		/* whether to fill rectangle */
    int abort_op ;		/* abort operation */
    int alarm_draw ;		/* true if is time to redraw */
    int displayOpen ;		/* display has been opened ??? */
    int force_redraw ;		/* whether to force a redraw */
    int delay_redraw ;		/* whether to force a redraw delay */
    int previous_status ;    	/* keep track of status */
    int called_from_ickey ;	/* true if call from ickey_func */
    int waiting_for_parasite ;	/* true if waiting for parasite to end */
    int draw_print_area ;	/* draw print area */
    BOOL graphics_enabled ;	/* called but not enabled */
    BOOL sync ;			/* if true use X synchronize */
    BOOL read_args ;		/* if true we already read the arguments */
    BOOL wait_loop ;		/* if true we iterate around the loop */
    FILE *did_file ;		/* did file for interpreter */
    void  (*refresh_func)(UTDTILERECTPTR,void *);/* refresh function */
    void *clientData ;		/* client data for draw back */
    char **stipple_name ;	/* stipple names */
    Tk_Window mainWindow ;	/* The main window for the application. */
    Tk_Window drawWindow ;	/* draw window */
    Tcl_Interp *interp ;	/* Interpreter for this application. */
    Display *dpy ;             	/* the display connection */
    GC *graphicContext ;  	/* array of color contexts */
    GC background ;		/* background context */
    Window main ;		/* the main window */
    Window main_wrapper ;	/* the main window */
    Window draw ;		/* the drawing window */
    XColor **ecolor ;		/* exact X color */
    TkCanvas *canvas ;		/* canvas info */
    Pixmap pixmap ;		/* offscreen copy of data */
    Pixmap blit_pixmap ;	/* offscreen copy of data for blitting */
    const char *utdgui ;	/* utD GUI root path */
    const char *utdversion ;	/* utD version */
    const char *utdposition ;	/* path of position widget if it exists */
    char *display_override ;	/* display override */
    char *geometry_override ;	/* geometry override */
    char *transcript_widget ;	/* transcript widget may not exist */
    const char *background_color_name ;	/* background color */
    const char *stdcolorArray[UTDNUMCOLORS+1] ;
    Tcl_HashTable *color_htable ;/* hash table of colors */
    Font font ;			/* selected font */
    XFontStruct *fontinfo ;	/* font information */
    InteractiveStatePtr is_p ;  /* save interactive state to free when done */
    /* Initial Window Postion & Dimensions for half screen.  */
    INT winx ;			/* window origin x from ul */
    INT winy ;			/* window origin y from ul */
    UTDRECT zoomArea ;		/* current user redraw area zoom */
    UTDRECT fullArea ;		/* current user full redraw area */
    UTDRECT arbBox ;		/* current arb user data */
    DOUBLE xoffset ;          	/* data offset to x screen dim.*/
    DOUBLE yoffset ;		/* data offset to y screen dim.*/
    DOUBLE oldxoffset ;		/* remember x for zoom return */
    DOUBLE oldyoffset ;		/* remember y for zoom return */
    DOUBLE scale ;		/* how the position counter is scaled */
    DOUBLE scaleFactor ;		/* scale data to screen dim.*/
    DOUBLE oldscaleFactor ;	/* remember old for zoom */
    DOUBLE lbX, ubX ;		/* scroll fraction X */
    DOUBLE lbY, ubY ;		/* scroll fraction Y */
    INT precision ;    		/* how the position counter is scaled */
    INT ref_width, ref_height ;   /* dimensions of last redraw */
    unsigned int winwidth ;	/* draw window width in pixels */
    unsigned int winheight ;	/* draw window height in pixels */
    unsigned long backgrd ;	/* background pixel */

    /* the cursors */
    Cursor xterm_cursor ;		/* xterm cursor */
    Cursor watch_cursor ;		/* busy cursor */

#ifdef LATER
    /* used to draw arbitrary rectilinear shapes */
    INT numpt ;			/* current number of points */
    INT ptAlloc ;    		/* size of point array */
    INT polyAlloc ;    		/* size of polygon array */
    XPoint *pt ; 			/* array of pts for arb figure */
    // YPOINT *poly_pts ;		/* polygon points */
    // MSG_DSTRINGPTR twstring_p ; 	/* tells if TWgetString buffer is in use */
    // MSG_DSTRING string_buf ;  	/* buffer for TWgetString */
#endif /* LATER */
  } GraphicsContext, *GraphicsContextPtr ;

  extern void add_gui_tcl_commands(Tcl_Interp *i_p, GraphicsContext* gc_p ) ;
  extern GraphicsContextPtr utDGUI_get_gc(void) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif //INCLUDED_OPEN_GUI_H 
