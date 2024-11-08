/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    drawing.c                                       
DESCRIPTION:Low level routines for drawing.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef lint
static char SccsId[] = 
"$RCSfile$ $Revision$ $Date$" ;
#endif

#include "config.h"
#include <utd/base.h>
#include <utd/cleanup.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/string.h>
#include <utd/system.h>
#include <tcl/tcl.h>
#include <tk/tk.h>
#include <tix/tix.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <gui/gc.h>
#include "open_gui_int.h"
#include <gui/gui.h>


/* ********************** TYPE DEFINITIONS ************************* */
#define DRAW_RUBBER_LINE( gc_xz, color_xz, l_xz, b_xz, r_xz, t_xz ) \
  XDrawLine(gc_xz->dpy,gc_xz->blit_pixmap,gc_xz->graphicContext[color_xz],(l_xz),(b_xz),(r_xz),(t_xz));

#define DRAW_RUBBER_BAND( gc_xz, color_xz, l_xz, b_xz, r_xz, t_xz ) \
  XDrawLine(gc_xz->dpy,gc_xz->blit_pixmap,gc_xz->graphicContext[color_xz],(l_xz),(b_xz),(l_xz),(t_xz));\
  XDrawLine(gc_xz->dpy,gc_xz->blit_pixmap,gc_xz->graphicContext[color_xz],(l_xz),(t_xz),(r_xz),(t_xz));\
  XDrawLine(gc_xz->dpy,gc_xz->blit_pixmap,gc_xz->graphicContext[color_xz],(r_xz),(t_xz),(r_xz),(b_xz));\
  XDrawLine(gc_xz->dpy,gc_xz->blit_pixmap,gc_xz->graphicContext[color_xz],(l_xz),(b_xz),(r_xz),(b_xz));

typedef struct {
  DOUBLE x ;
  DOUBLE y ;
} UTD_GET_PT ;

typedef struct {
    INT color ;
    UTD_GET_PT user_pt ;
    UTD_GET_PT anchor_pt ;
} UTD_RUBBER_RECT_PT ;

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static void frame_update(INT code) ;
static void blit_tk_native_init( GraphicsContextPtr gc_p ) ;
static void blit_init( GraphicsContextPtr gc_p ) ;
static void blit_update_screen( GraphicsContextPtr gc_p ) ;
static void rubberband_the_rect( ClientData clientData, XEvent *event_p) ;

/* ***************** GLOBAL VARIABLE DEFINITIONS ******************* */
extern void _utDGUIcheckMouse( void *, BOOL wait) ;

void utDGUIdraw_frame_update(void)
{
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }
#ifndef DIRECT_DRAW
    XCopyArea( gc_p->dpy, gc_p->pixmap, gc_p->draw, gc_p->background,
	0L, 0L, gc_p->winwidth, gc_p->winheight, 0L, 0L) ;
#endif /* DIRECT_DRAW */
    XFlush( gc_p->dpy ) ;
    gc_p->alarm_draw = FALSE ;
} /* end utDGUIdraw_frame_update() */

static void frame_update(INT code)
{
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }
    gc_p->alarm_draw = TRUE ;
    utDalarm(FRAME_UPDATE) ;
} /* end frame_update() */


/* start a new slate */
void utDGUIstartFrame(void)
{
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    utDGUIcheckMouse(IC_NOWAIT) ;
    XDefineCursor( gc_p->dpy, gc_p->draw, gc_p->watch_cursor ) ;
    utDsignal(SIGALRM,(utDsigfunc *) frame_update) ;
    utDalarm(FRAME_UPDATE) ;
    gc_p->alarm_draw = FALSE ;
    XFillRectangle(gc_p->dpy,DRAWABLE,gc_p->background,0,0,gc_p->winwidth,gc_p->winheight);
    XFlush( gc_p->dpy ) ;
} /* end utDGUIstartFrame() */

/* draw a one pixel tall line segment from x1,y1 to x2,y2 */
void utDGUIdrawLine(DOUBLE x1,DOUBLE y1,DOUBLE x2,DOUBLE y2,INT color,const char *label)
{	
    INT x1_int, x2_int, y1_int, y2_int ;
    DOUBLE lo, hi, overlap ;
    DOUBLE winwidth, winheight ;
    GraphicsContextPtr gc_p ;		/* graphics context pointer */
    FUNC_NAME("utDGUIdrawLine") ;

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    ALARM_REDRAW() ;

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }
    /* check to make sure color is valid */
    if( color <= 0 || color > gc_p->numColor ){
	if( gc_p->init ){ /* graphics are available */
	  utDmsgf( ERRMSG, "OTCGUIdrawLine:1", routine, "Color number:%d is out of range", color ) ;
	} else {
	  fprintf( stderr,"Color number:%d is out of range", color ) ;
	}
	return ;
    } else if(!(gc_p->colorOn[color])){
	return ;
    }
    if(!(gc_p->color )){
	/* set all lines to black in B&W mode */
	color = BLACK ;
    }
    if(!(gc_p->fullView)){
	if( x1 <= x2 ){
	  lo = MAX( x1, gc_p->zoomArea.UTDLLX ) ;
	  hi = MIN( x2, gc_p->zoomArea.UTDURX ) ;
	} else {
	  lo = MAX( x2, gc_p->zoomArea.UTDLLX ) ;
	  hi = MIN( x1, gc_p->zoomArea.UTDURX ) ;
	}
	overlap = hi - lo ;
	if( overlap < 0 ){
	  return ; /* outside window */
	}
	if( y1 <= y2 ){
	  lo = MAX( y1, gc_p->zoomArea.UTDLLY ) ;
	  hi = MIN( y2, gc_p->zoomArea.UTDURY ) ;
	} else {
	  lo = MAX( y2, gc_p->zoomArea.UTDLLY ) ;
	  hi = MIN( y1, gc_p->zoomArea.UTDURY ) ;
	}
	overlap = hi - lo ;
	if( overlap < 0 ){
	  return ; /* outside window */
	}
    }

    /* first add data offset to move to relative to 0,0 */
    x1 = x1 + gc_p->xoffset ;
    x2 = x2 + gc_p->xoffset ;
    y1 = y1 + gc_p->yoffset ;
    y2 = y2 + gc_p->yoffset ;
    /* next scale coordinates to window */
    x1 = x1 * gc_p->scaleFactor ;
    x2 = x2 * gc_p->scaleFactor ;
    y1 = y1 * gc_p->scaleFactor ;
    y2 = y2 * gc_p->scaleFactor ;

    /* -----------------------------------------------------------------
     * Now make sure we are in the picture.  See if we need to clip line. 
     * We used to let Xserver do this but we can avoid an interprocess
     * communication if we do it ourself.
    ----------------------------------------------------------------- */
    winwidth  = (DOUBLE) gc_p->winwidth ;
    winheight = (DOUBLE) gc_p->winheight ;
    if( x1 <= x2 ){
      lo = MAX( x1, 0 ) ;
      hi = MIN( x2, winwidth ) ;
      overlap = hi - lo ;
      if( overlap < 0 ){
	return ; /* outside window */
      }
      if( x1 < 0 ){
	x1_int = -1 ;
      } else {
	x1_int = x1 ;
      }
      if( x2 > winwidth ){
	x2_int = winwidth ;
      } else {
	x2_int = x2 ;
      }
    } else {
      lo = MAX( x2, 0 ) ;
      hi = MIN( x1, winwidth ) ;
      overlap = hi - lo ;
      if( overlap < 0 ){
	return ; /* outside window */
      }
      if( x2 < 0 ){
	x2_int = -1 ;
      } else {
	x2_int = x2 ;
      }
      if( x1 > winwidth ){
	x1_int = winwidth ;
      } else {
	x1_int = x1 ;
      }
    }
    if( y1 <= y2 ){
      lo = MAX( y1, 0 ) ;
      hi = MIN( y2, winheight ) ;
      overlap = hi - lo ;
      if( overlap < 0 ){
	return ; /* outside window */
      }
      if( y1 < 0 ){
	y1_int = -1 ;
      } else {
	y1_int = y1 ;
      }
      if( y2 > winheight ){
	y2_int = winheight ;
      } else {
	y2_int = y2 ;
      }
    } else {
      lo = MAX( y2, 0 ) ;
      hi = MIN( y1, winheight ) ;
      overlap = hi - lo ;
      if( overlap < 0 ){
	return ; /* outside window */
      }
      if( y2 < 0 ){
	y2_int = -1 ;
      } else {
	y2_int = y2 ;
      }
      if( y1 > winheight ){
	y1_int = winheight ;
      } else {
	y1_int = y1 ;
      }
    }

    /* account for inversion of y axis */
    y1_int = gc_p->winheight - y1_int ;
    y2_int = gc_p->winheight - y2_int ;
    /* now draw line */
    XDrawLine( gc_p->dpy,DRAWABLE,gc_p->graphicContext[color], x1_int, y1_int,
	       x2_int, y2_int ) ;
    if( label ){
      if( *label != EOS ){
	  XDrawImageString( gc_p->dpy, DRAWABLE, gc_p->graphicContext[color], 
	      (x1+x2)/2, (y1_int+y2_int)/2, label, strlen(label) ) ;
      }
    }
} /* end OTCdrawLine() */



/* -----------------------------------------------------------------
 * Draw a rectangle whose diagonals are (x1,y1) and (x2,y2)
*  if the specified color is default or invalid, use default color.
 * A border will be draw around the cell if specified black (default).
----------------------------------------------------------------- */
void utDGUIdrawRect(DOUBLE x1,DOUBLE y1,DOUBLE x2,DOUBLE y2,INT color,const char *label)
{	
    UNSIGNED_INT width, height ;
    INT len ;
    INT x1_int, x2_int, y1_int, y2_int ;
    DOUBLE lo, hi, overlap ;
    DOUBLE winwidth, winheight ;
    GraphicsContextPtr gc_p ;		/* graphics context pointer */
    FUNC_NAME("utDGUIdrawRect") ;

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    ALARM_REDRAW() ;

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }
    /* check to make sure color is valid */
    if( color <= 0 || color > gc_p->numColor ){
	if( gc_p->init ){ /* graphics are available */
	  utDmsgf( ERRMSG, "OTCGUIdrawRect:1", routine, "Color number:%d is out of range", color ) ;
	} else {
	  fprintf( stderr,"Color number:%d is out of range", color ) ;
	}
	return ;
    } else if(!(gc_p->colorOn[color])){
	return ;
    }
    if( !(gc_p->color) && gc_p->reverse ){
	/* set all lines to black in B&W mode */
	color = UTDBLACK ;
    }

    /* first add data offset to move to relative to 0,0 */
    x1 = x1 + gc_p->xoffset ;
    x2 = x2 + gc_p->xoffset ;
    y1 = y1 + gc_p->yoffset ;
    y2 = y2 + gc_p->yoffset ;
    /* next scale coordinates to window */
    x1 = x1 * gc_p->scaleFactor ;
    x2 = x2 * gc_p->scaleFactor ;
    y1 = y1 * gc_p->scaleFactor ;
    y2 = y2 * gc_p->scaleFactor ;

    /* -----------------------------------------------------------------
     * Now make sure we are in the picture.
    ----------------------------------------------------------------- */
    winwidth  = (DOUBLE) gc_p->winwidth ;
    winheight = (DOUBLE) gc_p->winheight ;
    lo = MAX( x1, 0 ) ;
    hi = MIN( x2, winwidth ) ;
    overlap = hi - lo ;
    if( overlap < 0 ){
      return ; /* outside window */
    }
    if( x1 > (DOUBLE) SHORT_MAX ){
      x1_int = SHORT_MAX ;
    } else if( x1 < (DOUBLE) SHORT_MIN ){
      x1_int = SHORT_MIN ;
    } else {
      x1_int = (SHORT) x1 ;
    }
    if( x2 > (DOUBLE) SHORT_MAX ){
      x2_int = SHORT_MAX ;
    } else if( x2 < (DOUBLE) SHORT_MIN ){
      x2_int = SHORT_MIN ;
    } else {
      x2_int = (SHORT) x2 ;
    }
    lo = MAX( y1, 0 ) ;
    hi = MIN( y2, winheight ) ;
    overlap = hi - lo ;
    if( overlap < 0 ){
      return ; /* outside window */
    }
    y1 = winheight - y1 ; /* account for inversion of y axis */
    if( y1 > (DOUBLE) SHORT_MAX ){
      y2_int = SHORT_MAX ;
    } else if( y1 < (DOUBLE) SHORT_MIN ){
      y2_int = SHORT_MIN ;
    } else {
      y2_int = (SHORT) y1 ;
    }
    y2 = winheight - y2 ; /* account for inversion of y axis */
    if( y2 > (DOUBLE) SHORT_MAX ){
      y1_int = SHORT_MAX ;
    } else if( y2 < (DOUBLE) SHORT_MIN ){
      y1_int = SHORT_MIN ;
    } else {
      y1_int = (SHORT) y2 ;
    }
    width = x2_int - x1_int ;
    height = y2_int - y1_int ;
    /* -----------------------------------------------------------------
     * Now guarantee the drawing of the figure by making it at least a 1x1
    ----------------------------------------------------------------- */
    width = MAX( width, 1 ) ;
    height = MAX( height, 1 ) ;

    if( gc_p->rect_fill ){
	XFillRectangle( gc_p->dpy,DRAWABLE,gc_p->graphicContext[color],
	    x1_int,y1_int,width,height ) ;
	if( gc_p->borderColor ){
	    XDrawRectangle( gc_p->dpy,DRAWABLE,gc_p->graphicContext[gc_p->borderColor],
		x1_int,y1_int,width,height ) ;
	} else {
	    XDrawRectangle( gc_p->dpy,DRAWABLE,gc_p->graphicContext[color],
		x1_int,y1_int,width,height ) ;
	}
    } else {
	XDrawRectangle( gc_p->dpy,DRAWABLE,gc_p->graphicContext[color],
	    x1_int,y1_int,width,height ) ;
    }
    if( label ){
      if( *label != EOS ){
	len = strlen(label) ;
	/* now find width of string as offset */
	width = XTextWidth( gc_p->fontinfo, label, len ) ;
	/* need image string so you can write on top of fill */
	XDrawImageString( gc_p->dpy, DRAWABLE, gc_p->graphicContext[color], 
	    (x1_int+x2_int-width)/2, (y1_int+y2_int)/2,label,strlen(label) ) ;
      }
    }
} /* end utDGUIdrawRect() */

INT utDGUIget_border_color(void)
{
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(0) ;
    }
    return( gc_p->borderColor ) ;
} /* end utDGUIget_border_color() */

void utDGUIborder_color(INT color)
{
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }
    gc_p->borderColor = color ;
} /* end utDGUIborder_color() */

INT utDGUIdefault_border_color(void)
{
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(0) ;
    }
    return(gc_p->defaultBorderColor) ;
} /* end utDGUIdefault_border_color() */

void utDGUIflushFrame(void)
{
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    if(!(gc_p->init)){
	return ;
    }
#ifndef DIRECT_DRAW
    XCopyArea( gc_p->dpy, gc_p->pixmap, gc_p->draw, gc_p->background,
      0L, 0L, gc_p->winwidth, gc_p->winheight, 0L, 0L) ;
#endif /* DIRECT_DRAW */
    Tk_CanvasDispUpdate() ;
    XDefineCursor( gc_p->dpy, gc_p->draw, gc_p->xterm_cursor ) ;
    utDGUIcheckMouse(IC_NOWAIT) ;
// UTDsignal(SIGALRM,SIG_DFL) ;
// UTDalarm(0) ;
    gc_p->alarm_draw = FALSE ; 
    gc_p->ref_width = gc_p->winwidth ;
    gc_p->ref_height = gc_p->winheight ;
    utDGUIcheckMouse(IC_NOWAIT) ;

} /* end utDGUIflushFrame */

/* -----------------------------------------------------------------
 * check to see mouse button was click.  If true put up appropriate 
 * menu and return value to user.  If wait is true, check mouse sits
 * in a select and waits to avoid chewing up execution time.
----------------------------------------------------------------- */

/* perform a zoom in main graphics window */
void utDGUIzoom(DOUBLE x1, DOUBLE y1, DOUBLE x2, DOUBLE y2 )
{
    DOUBLE left, right, bottom, top ; 	/* for calculating window */
    DOUBLE span ;   			/* span of design */
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }
    if( gc_p->fullView ){
	/* only save full view window size */
	gc_p->oldxoffset = gc_p->xoffset ;
	gc_p->oldyoffset = gc_p->yoffset ;
	gc_p->oldscaleFactor = gc_p->scaleFactor ;
	gc_p->fullView = FALSE ;
    }

    if( x1 >= x2 && y1 >= y2 ){
	/* zoom out */
	span = gc_p->fullArea.UTDURX - gc_p->fullArea.UTDLLX ;
	span *= 2 ;
	left = gc_p->fullArea.UTDLLX = ( (x1 + x2 ) / 2 ) - span / 2 ;
	right = gc_p->fullArea.UTDURX = ( (x1 + x2 ) / 2 ) + span / 2 ;
	span = gc_p->fullArea.UTDURY - gc_p->fullArea.UTDLLY ;
	span *= 2 ;
	bottom = gc_p->fullArea.UTDLLY = ( (y1 + y2 ) / 2 ) - span / 2 ;
	top = gc_p->fullArea.UTDURY = ( (y1 + y2 ) / 2 ) + span / 2 ;

    } else {
	/* zoom in */
	left = MIN( x1, x2 ) ;
	right = MAX( x1, x2 ) ;
	bottom = MIN( y1, y2 ) ;
	top = MAX( y1, y2 ) ;
    }

    /* set new window */
    utDGUIsetFrame( left, bottom, right, top, gc_p->scale, gc_p->precision ) ;
    /* important that we reset full view to FALSE at this point */
    /* since ICsetwindow always sets it to TRUE */
    gc_p->fullView = FALSE ;
    utDGUIforceRedraw() ;
} /* end utDGUIzoom() */


void utDGUIzoom_factor(DOUBLE factor)
{
    DOUBLE l, b, r, t ;
    DOUBLE xspan, yspan ;
    DOUBLE xhalf_span, yhalf_span ;
    DOUBLE xcenter, ycenter ;
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    if( gc_p->fullView ){
      /* only save full view window size */
      gc_p->oldxoffset = gc_p->xoffset ;
      gc_p->oldyoffset = gc_p->yoffset ;
      gc_p->oldscaleFactor = gc_p->scaleFactor ;
      gc_p->fullView = FALSE ;
    }

    xspan = factor * (DOUBLE) (gc_p->zoomArea.UTDURX - gc_p->zoomArea.UTDLLX) ;
    xcenter = (gc_p->zoomArea.UTDURX + gc_p->zoomArea.UTDLLX) / 2.0 ;
    yspan = factor * (DOUBLE) (gc_p->zoomArea.UTDURY - gc_p->zoomArea.UTDLLY) ;
    ycenter = (gc_p->zoomArea.UTDURY + gc_p->zoomArea.UTDLLY) / 2.0 ;
    xhalf_span = xspan / 2.0 ;
    yhalf_span = yspan / 2.0 ;
    l = xcenter - xhalf_span ;
    r = l + xspan ;
    b = ycenter - yhalf_span ;
    t = b + yspan ;

    utDGUIsetFrame( l, b, r, t, gc_p->scale, gc_p->precision ) ;
    /* important that we reset full view to FALSE at this point */
    /* since ICsetwindow always sets it to TRUE */
    gc_p->fullView = FALSE ;
    utDGUIforceRedraw() ;
} /* end utDGUIzoom_factor() */

/* returns to full screen after zoom */
void utDGUIfullFrame(void)
{
    TkCanvas *canvas_p ;	/* current canvas */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    if( gc_p->fullView ){
	return ;
    }
    utDmsg(IMSG,MSG_AT, NULL, "[fullframe]: Returning to original size\n" ) ;
    gc_p->fullView = TRUE ;
    gc_p->xoffset = gc_p->oldxoffset ;
    gc_p->yoffset = gc_p->oldyoffset ; 
    gc_p->scaleFactor = gc_p->oldscaleFactor ; 
    gc_p->zoomArea = gc_p->fullArea ;
    /* -----------------------------------------------------------------
     * Set the scrollbars for update.
     * ----------------------------------------------------------------- */
    canvas_p = gc_p->canvas ;
    if( canvas_p ){
      gc_p->lbX = 0.0 ;
      gc_p->lbY = 0.0 ;
      gc_p->ubX = 1.0 ;
      gc_p->ubY = 1.0 ;
      canvas_p->flags |= UPDATE_SCROLLBARS ;
      Tk_CanvasDispUpdate() ;
    }
    utDGUIforceRedraw() ;

} /* end utDGUIfullFrame */

static void draw_to_user( GraphicsContextPtr gc_p, UTD_GET_PT *pt_p )
{
    DOUBLE xtemp, ytemp ;	/* the event position data */

    /* determine which menu entry has been selected */
    xtemp = pt_p->x ;
    ytemp = pt_p->y ;
    /* account for inversion of y axis */
    ytemp = gc_p->winheight - ytemp ;
    /* now reverse scale of coordinates */
    xtemp = xtemp / gc_p->scaleFactor ;
    ytemp = ytemp / gc_p->scaleFactor ;
    /* now apply data offset */
    pt_p->x = xtemp - gc_p->xoffset ;
    pt_p->y = ytemp - gc_p->yoffset ;
} /* end draw_to_user() */

static void user_to_draw( GraphicsContextPtr gc_p, UTD_GET_PT *pt_p )
{
    SHORT anchorx, anchory ;	/* integer representation */
    DOUBLE xtemp, ytemp ;	/* the event position data */

    /* determine which menu entry has been selected */
    xtemp = pt_p->x ;
    ytemp = pt_p->y ;

    /* now apply data offset */
    xtemp += gc_p->xoffset ;
    ytemp += gc_p->yoffset ;

    /* now scale of coordinates */
    xtemp = xtemp * gc_p->scaleFactor ;
    ytemp = ytemp * gc_p->scaleFactor ;

    /* account for inversion of y axis */
    ytemp = gc_p->winheight - ytemp ;

    /* Now convert to integer */
    anchorx = (INT) xtemp ;
    anchory = (INT) ytemp ;

    pt_p->x = anchorx ;
    pt_p->y = anchory ;

} /* end user_to_draw() */

static void get_the_pt( ClientData clientData, XEvent *event_p)
{
    UTD_GET_PT *ret_data_p ;	/* where to return the data */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    /* setup data */
    ret_data_p = (UTD_GET_PT *) clientData ;
    ret_data_p->x = event_p->xbutton.x ;
    ret_data_p->y = event_p->xbutton.y ;
    gc_p->last_click = event_p->xbutton.time ;
    draw_to_user( gc_p, ret_data_p ) ;
    gc_p->point_not_picked = FALSE ;
} /* end get_the_pt() */

BOOL utDGUIgetPt( DOUBLE *x, DOUBLE *y )
{
    INT numtokens ;			/* number of tokens */
    UTD_GET_PT pt_data ;			/* point data */
    char reply[LRECL] ;			/* reply command */
    const char *canvas_win ;		/* canvas window id */
    char **tokens ;			/* tokens parsed */
    Tk_Window drawWindow ;		/* drawing window */
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(TRUE) ;
    }

    canvas_win = Tcl_GetVar2( gc_p->interp, "utdsymbolicNameG", "utdcanvas",
			      TCL_GLOBAL_ONLY | TCL_LEAVE_ERR_MSG ) ;
    if( !(canvas_win)){
      return(TRUE) ;
    }
    drawWindow = Tk_NameToWindow( gc_p->interp, canvas_win, gc_p->mainWindow ) ;
    Tk_CreateEventHandler(drawWindow,ButtonPressMask,get_the_pt,(ClientData)&pt_data);

    /* install the new key function */
//    Tcl_DeleteCommand(gc_p->interp, "otkey" ) ;
//    Tcl_CreateCommand(gc_p->interp, "otkey", key2_func, reply, NULL);

    // menu_input( FALSE ) ;

    pt_data.x = DINT_MIN ;
    pt_data.y = DINT_MIN ;
    while(TRUE) {
      gc_p->point_not_picked = TRUE ;
      gc_p->abort_op = FALSE ;
      while( gc_p->point_not_picked && !(gc_p->abort_op) ){
	utDGUIcheckMouse(IC_WAIT) ;
      }
      if( gc_p->abort_op ){
	break ; /* data from the pointer break */
      } else {
	/* Now that we are out of the loop see if the data is valid */
	if( pt_data.x == DINT_MIN && pt_data.y == DINT_MIN ){
	  /* data from the command line */
	  tokens = utDstrparser( reply, ", \t\n", &numtokens );
	  if( numtokens == 2 ){
	    pt_data.x = gc_p->scale * atof( tokens[0]) ;
	    pt_data.y = gc_p->scale * atof( tokens[1]) ;
	    break ;
	  } else {
	    utDmsgf( IMSG,MSG_AT,NULL,"Invalid input - please enter again! eg. 10, 20<cr>\n");
	  }
	} else {
	  break ; /* data from the pointer break */
	}
      }
    } /* end while(TRUE)... */

    /* delete the handler */
    Tk_DeleteEventHandler(drawWindow,ButtonPressMask,get_the_pt,(ClientData)&pt_data);
    /* restore the input */
    // menu_input( TRUE ) ;

    /* restore the old key function */
 //   Tcl_DeleteCommand(gc_p->interp, "otkey" ) ;
    // Tcl_CreateCommand(gc_p->interp, "otkey", otkey_func, NULL, NULL);

    *x = pt_data.x ;
    *y = pt_data.y ;

    return( gc_p->abort_op ) ;
    
} /* end utDGUIgetPt */


BOOL utDGUIpickRect( INT color, DOUBLE ptx, DOUBLE pty, DOUBLE *x2, DOUBLE *y2 )
/* x1, y1, x2, y2 are all user data absolute coordinates */
/* ptx and pty are the value of the pointer from ICGetPt */
{
    INT newx, newy ;          	/* rect pos rel to pointer in pixels */
    INT anchorx, anchory ;    	/* anchor rect pos rel to pointer in pixels */
    INT numtokens ;		/* number of tokens */
    INT width ; 		/* width of rectangle pixel coordinates */
    INT height; 		/* height of rectangle pixel coordinates */
    UNSIGNED_INT width_pix ; 	/* width of rectangle pixel coordinates */
    UNSIGNED_INT height_pix; 	/* height of rectangle pixel coordinates */
    UTD_GET_PT pt ;		/* convert point */
    UTD_RUBBER_RECT_PT rect_data ;/* rectangle info */
    char reply[LRECL] ;		/* reply command */
    const char *canvas_win ;	/* canvas window id */
    char **tokens ;		/* tokens parsed */
    Tk_Window drawWindow ;	/* drawing window */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(TRUE) ;
    }

    /* Now convert to an integer for drawing */
    rect_data.anchor_pt.x = pt.x = ptx ;
    rect_data.anchor_pt.y = pt.y = pty ;
    user_to_draw( gc_p, &pt ) ;
    anchorx = (INT) pt.x ;
    anchory = (INT) pt.y ;

    newx = anchorx + 1 ;
    newy = anchory + 1 ;
    if(!(gc_p->canvas)){
      blit_tk_native_init(gc_p) ;
    }
    blit_init(gc_p) ;
    DRAW_RUBBER_BAND( gc_p, color, anchorx, anchory, newx, newy ) ;
    blit_update_screen(gc_p) ;

    /* now look for either event - button press or keyboard */
    canvas_win = Tcl_GetVar2( gc_p->interp, "utdsymbolicNameG", "utdcanvas",
			      TCL_GLOBAL_ONLY | TCL_LEAVE_ERR_MSG ) ;
    if( !(canvas_win)){
      return(TRUE) ;
    }
    drawWindow = Tk_NameToWindow( gc_p->interp, canvas_win, gc_p->mainWindow ) ;
    Tk_CreateEventHandler(drawWindow,ButtonPressMask|PointerMotionMask,
	                  rubberband_the_rect, (ClientData)&rect_data) ;

    /* install the new key function */
//    Tcl_DeleteCommand(gcS->interp, "ickey" ) ;
//    Tcl_CreateCommand(gcS->interp, "ickey", ickey2_func, reply, NULL);

//    menu_input( FALSE ) ;

    rect_data.user_pt.x = DINT_MIN ;
    rect_data.user_pt.y = DINT_MIN ;
    rect_data.color = color ;

    blit_init(gc_p) ;
    /* draw rectangle at absolute coordinates */
    width = ptx - newx ;
    if( width < 0 ){
      width = - width ;
    }
    width_pix = width ;
    height = pty - newy ;
    if( height < 0 ){
      height = - height ;
    }
    height_pix = height ;
    XDrawRectangle( gc_p->dpy,gc_p->blit_pixmap,gc_p->graphicContext[HIGHLITE],
	ptx,pty,width_pix,height_pix ) ;
    blit_update_screen(gc_p) ;

    /* now look for either event - button press or keyboard */
    while(TRUE) {
      gc_p->point_not_picked = TRUE ;
      gc_p->abort_op = FALSE ;
      while( gc_p->point_not_picked && !(gc_p->abort_op) ){
	utDGUIcheckMouse(IC_WAIT) ;
      }
      if( gc_p->abort_op ){
	break ; /* data from the pointer break */
      } else {
	/* Now that we are out of the loop see if the data is valid */
	if( rect_data.user_pt.x == DINT_MIN && rect_data.user_pt.y == DINT_MIN ){
	  /* data from the command line */
	  tokens = utDstrparser( reply, ", \t\n", &numtokens );
	  if( numtokens == 2 ){
	    rect_data.user_pt.x = gc_p->scale * atof( tokens[0]) ;
	    rect_data.user_pt.y = gc_p->scale * atof( tokens[1]) ;
	    break ;
	  } else {
	    utDmsgf( IMSG,MSG_AT,NULL,"Invalid input - please enter again! eg. 10, 20<cr>\n");
	  }
	} else {
	  break ; /* data from the pointer break */
	}
      }
    } /* end while(TRUE)... */

    /* delete the handler */
    Tk_DeleteEventHandler(drawWindow,ButtonPressMask|PointerMotionMask,
	                  rubberband_the_rect, (ClientData)&rect_data) ;
    /* restore the input */
    // menu_input( TRUE ) ;

    /* restore the old key function */
    // Tcl_DeleteCommand(gcS->interp, "ickey" ) ;
    // Tcl_CreateCommand(gcS->interp, "ickey", ickey_func, NULL, NULL);

    *x2 = rect_data.user_pt.x ;
    *y2 = rect_data.user_pt.y ;

    return( gc_p->abort_op ) ;
	
} /* end utDGUIpickRect() */

static void blit_tk_native_init( GraphicsContextPtr gc_p )
{
  /* -----------------------------------------------------------------
   * First copy over pixmap info.
  ----------------------------------------------------------------- */
  XCopyArea( gc_p->dpy, gc_p->draw, gc_p->pixmap, gc_p->graphicContext[UTDWHITE], 
      0L, 0L, gc_p->winwidth, gc_p->winheight, 0L, 0L) ;

} /* end blit_tk_native_init() */


static void blit_init( GraphicsContextPtr gc_p )
{
  /* -----------------------------------------------------------------
   * First copy over pixmap info.
  ----------------------------------------------------------------- */
  XCopyArea( gc_p->dpy, gc_p->pixmap, gc_p->blit_pixmap, gc_p->graphicContext[UTDWHITE], 
      0L, 0L, gc_p->winwidth, gc_p->winheight, 0L, 0L) ;

} /* end blit_init() */

static void blit_update_screen( GraphicsContextPtr gc_p )
{
  XCopyArea( gc_p->dpy, gc_p->blit_pixmap, gc_p->draw, gc_p->graphicContext[UTDWHITE], 
      0L, 0L, gc_p->winwidth, gc_p->winheight, 0L, 0L) ;
} /* end blit_update_screen() */


static void rubberband_the_rect( ClientData clientData, XEvent *event_p)
{
    INT x, y ;				/* updated point */
    INT anchorx, anchory ;    		/* anchor rect pos rel to pointer in pixels */
    UTD_GET_PT pt ;			/* convert point */
    UTD_RUBBER_RECT_PT *rect_p ;	/* where to return the data */
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    /* setup data */
    rect_p = (UTD_RUBBER_RECT_PT *) clientData ;
    if( event_p->type == ButtonPress ){
      rect_p->user_pt.x = event_p->xbutton.x ;
      rect_p->user_pt.y = event_p->xbutton.y ;
      gc_p->last_click = event_p->xbutton.time ;
      draw_to_user( gc_p, &(rect_p->user_pt) ) ;
      // D( "rubberband_the_rect", fprintf( stderr, "pt = (%.1f,%.1f)\n", 
      // 	    rect_p->user_pt.x, rect_p->user_pt.y) ) ;
      gc_p->point_not_picked = FALSE ;
    } else if ( event_p->type == MotionNotify ){
      blit_init(gc_p) ;
      x = event_p->xmotion.x ;
      y = event_p->xmotion.y ;
      pt = rect_p->anchor_pt ;
      user_to_draw( gc_p, &pt ) ;
      anchorx = (INT) pt.x ;
      anchory = (INT) pt.y ;
      /* calculate anchor because it may have moved */
      DRAW_RUBBER_BAND( gc_p, rect_p->color, anchorx, anchory, x, y ) ;
      blit_update_screen(gc_p) ;
    }
} /* end move_the_rect() */

static void format_position( GraphicsContextPtr gc_p, char *pos_buffer, INT x, INT y )
{
    sprintf( pos_buffer, "X:%-8.*f Y:%-8.*f", gc_p->precision, (DOUBLE)x/gc_p->scale,
		                              gc_p->precision, (DOUBLE)y/gc_p->scale) ;
} /* end format_position() */

INT position_objfunc(ClientData d_p,Tcl_Interp *i_p,int objc,Tcl_Obj * const objv[])
{
    const char *at ;			/* message position */
    const char *argv_1 ;		/* first argument */
    GraphicsContextPtr gc_p ;		/* graphics context info */
    UTD_GET_PT pt ;			/* convert point */
    INT x ;				/* translated x position */
    INT y ;				/* translated y position */
    INT code ;				/* return code from tcl */
    INT xtemp ;				/* X value of position */
    INT ytemp ;				/* Y value of position */
    char command[LRECL] ;		/* build tcl command */
    char pos_buffer[LRECL] ;		/* position buffer */
    FUNC_NAME("utdposition") ;


    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n\n" );
      utDmsgf(ERRMSG,at,NULL, "utdposition <x> <y> : used internally.\n" ) ;
      utDmsgf(ERRMSG,at,NULL, "utdposition screen <x> <y> : returns screen \
coordinate given design coordinates\n" ) ;
      utDmsgf(ERRMSG,at,NULL, "utdposition translate <x> <y> : returns design \
coordinate system give screen coordinate system.\n" ) ;
      return(TCL_OK) ;
    }

    gc_p = (GraphicsContextPtr) d_p ;
    if(!(gc_p)){
      return(TCL_ERROR) ; /* now open for business */
    }

    if( objc != 3 && objc != 4 ){
      return(TCL_ERROR) ;
    }
    if( objc == 3 ){
      if( !(gc_p->utdposition) ) return(TCL_OK) ;
      if( Tcl_GetIntFromObj(i_p,objv[1],&xtemp) != TCL_OK ){
	return(TCL_ERROR) ;
      }
      if( Tcl_GetIntFromObj(i_p,objv[2],&ytemp) != TCL_OK ){
	return(TCL_ERROR) ;
      }
    } else {
      argv_1 = Tcl_GetString(objv[1]) ;
      if( strncmp( argv_1, "screen", 5 ) == STRINGEQ ){
	if( Tcl_GetDoubleFromObj(i_p,objv[2],&pt.x) != TCL_OK ){
	  return(TCL_ERROR) ;
	}
	if( Tcl_GetDoubleFromObj(i_p,objv[3],&pt.y) != TCL_OK ){
	  return(TCL_ERROR) ;
	}
	pt.x *= gc_p->scale ;
	pt.y *= gc_p->scale ;
	user_to_draw( gc_p, &pt ) ;
	sprintf( command, "%ld %ld", (LONG) pt.x, (LONG) pt.y ) ;
	Tcl_AppendResult( i_p, command, NULL ) ;
	return(TCL_OK) ;

      } else if( strncmp( argv_1, "translate", 5 ) != STRINGEQ ){
	utDmsgf(ERRMSG,MSG_AT,routine,"Unknown argument to %s routine:%s\n", 
	        argv_1, routine ) ;
	return(TCL_ERROR) ;
      }
      if( Tcl_GetIntFromObj(i_p,objv[2],&xtemp) != TCL_OK ){
	return(TCL_ERROR) ;
      }
      if( Tcl_GetIntFromObj(i_p,objv[3],&ytemp) != TCL_OK ){
	return(TCL_ERROR) ;
      }
    }
    /* account for inversion of y axis */
    ytemp = gc_p->winheight - ytemp ;
    /* now reverse scale of coordinates */
    xtemp = (INT) ( (DOUBLE) xtemp / gc_p->scaleFactor ) ;
    ytemp = (INT) ( (DOUBLE) ytemp / gc_p->scaleFactor ) ;
    /* now apply data offset */
    x = xtemp - gc_p->xoffset ;
    y = ytemp - gc_p->yoffset ;

    if( objc == 4 ){
      sprintf( command, "%.*f %.*f", gc_p->precision,x/gc_p->scale,
			gc_p->precision, y/gc_p->scale ) ;
      Tcl_AppendElement( i_p, command ) ;
    } else {
      format_position( gc_p, pos_buffer, x, y ) ;
      sprintf( command,"%s configure -text {%s}\n", gc_p->utdposition, pos_buffer) ;
      code = Tcl_GlobalEval( gc_p->interp, command ) ;
      utDGUIcheck_tcl_code( gc_p->interp, code, MSG_AT, routine ) ;
      if( code != TCL_OK ){
	return TCL_ERROR ;
      }
    }
    return TCL_OK ;
} /* end utdposition_func() */


#ifdef LATER
void ICrect_fill( BOOL flag )
{
    gcS->rect_fill = flag ;
} /* end ICrect_fill */

BOOL ICget_rect_fill(void)
{
    return( gcS->rect_fill ) ;
} /* end ICget_rect_fill */


void IChighLightRect( DOUBLE x1,DOUBLE y1,DOUBLE x2,DOUBLE y2 )
/* draw a rectangle whose diagonals are (x1,y1) and (x2,y2) */
{	
    UNSIGNED_INT width, height ;

    /* first add data offset to move to relative to 0,0 */
    x1 += gcS->xoffset ;
    x2 += gcS->xoffset ;
    y1 += gcS->yoffset ;
    y2 += gcS->yoffset ;
    /* next scale coordinates to window */
    x1 = (INT) ( (DOUBLE) x1 * gcS->scaleFactor ) ;
    x2 = (INT) ( (DOUBLE) x2 * gcS->scaleFactor ) ;
    y1 = (INT) ( (DOUBLE) y1 * gcS->scaleFactor ) ;
    y2 = (INT) ( (DOUBLE) y2 * gcS->scaleFactor ) ;
    width = x2 - x1 ;
    height = y2 - y1 ;
    /* account for inversion of y axis */
    y2 = gcS->winheight - y2 ;
    XFillRectangle( gcS->dpy,DRAWABLE,gcS->graphicContext[HIGHLITE],
	x1,y2,width,height ) ;
} /* end IChighLightRect */
#endif /* LATER */
