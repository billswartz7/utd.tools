/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    tclcmds.c                                       
DESCRIPTION:Tcl commands for the graphics user interface
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef lint
static char SccsId[] = 
"$RCSfile$ $Revision$ $Date$" ;
#endif

#include "config.h"
#include <utd/base.h>
#include <utd/string.h>
#include <utd/dstring.h>
#include <utd/msg.h>
#include <utd/program.h>
#include <utd/stats.h>
#include <utd/tcllog.h>
#include <tcl/tcl.h>
#include <tk/tk.h>
#include "gc.h"
#include "open_gui_int.h"
#include <gui/gui.h>
#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif /* HAVE_STDARG_H */

/* ********************** TYPE DEFINITIONS ************************* */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static int continue_objfunc(ClientData d_p,Tcl_Interp *i_p, int objc,Tcl_Obj * const objv[]) ;
static int exit_objfunc(ClientData d_p,Tcl_Interp *i_p, int objc,Tcl_Obj * const objv[]) ;
static int fullframe_objfunc(ClientData d_p,Tcl_Interp *i_p, int objc,Tcl_Obj * const objv[]) ;
static int msg_objfunc(ClientData d_p,Tcl_Interp *i_p, int objc,Tcl_Obj * const objv[]) ;
extern int position_objfunc(ClientData d_p,Tcl_Interp *i_p, int objc,Tcl_Obj * const objv[]) ;
static int redraw_objfunc(ClientData d_p,Tcl_Interp *i_p, int objc,Tcl_Obj * const objv[]) ;
static int scrollbar_objfunc(ClientData d_p,Tcl_Interp *i_p, int objc,Tcl_Obj * const objv[]) ;
static int translate_objfunc(ClientData d_p,Tcl_Interp *i_p, int objc,Tcl_Obj * const objv[]) ;
static int wait_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[]) ;
static int zoom_objfunc(ClientData d_p,Tcl_Interp *i_p, int objc,Tcl_Obj * const objv[]) ;
static void utDGUITk_transcript( char *format, ... ) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */

void add_gui_tcl_commands(Tcl_Interp *i_p, GraphicsContextPtr gc_p )
{
  TclRenameCommand( i_p, "exit", "exit.tcl" ) ;
  Tcl_CreateObjCommand( i_p, "utdcolors",colors_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdcontinue",continue_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdexit",exit_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "exit",exit_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdfullframe",fullframe_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdmsg",msg_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdredraw",redraw_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdscrollbar",scrollbar_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdposition",position_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdtranslate",translate_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdwait",wait_objfunc, gc_p, NULL ) ;
  Tcl_CreateObjCommand( i_p, "utdzoom",zoom_objfunc, gc_p, NULL ) ;
}



static INT redraw_objfunc(ClientData d_p,Tcl_Interp *i_p,
                            int objc,Tcl_Obj * const objv[])
{
    // void (*refresh_func)(utDTILERECTPR,void *) ;/* refresh function */
    char *argv_1 ;			/* first argument */
    const char *at ;			/* label position */
    GraphicsContextPtr gc_p ;		/* graphics context info */
    FUNC_NAME("utdredraw") ;

    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n\n" );
      utDmsgf(ERRMSG,at,NULL,"%s : redraws the graphics window.\n", routine );
      utDmsgf(ERRMSG,at,NULL,"%s -force : forces redraw of the graphics window.\n", routine );
      utDmsgf(ERRMSG,at,NULL,"%s -delay : delay redraw.\n", routine );
      utDmsgf(ERRMSG,at,NULL,"%s event : schedule a redraw event.\n\n", routine );
      return(TCL_OK) ;
    }

    gc_p = (GraphicsContextPtr) d_p ;
    if(!(gc_p)){
      return(TCL_ERROR) ; /* now open for business */
    }
    if( objc >= 2 ){
      argv_1 = Tcl_GetString( objv[1] ) ;
      if( strcmp( argv_1, "-force" ) == STRINGEQ ){
	gc_p->delay_redraw = FALSE ;
	// fprintf( stderr, "utdredraw -force\n" ) ;
      } else if( strcmp( argv_1, "-delay" ) == STRINGEQ ){
	// fprintf( stderr, "utdredraw -delay\n" ) ;
	gc_p->delay_redraw = TRUE ;
      } else if( strcmp( argv_1, "event" ) == STRINGEQ ){
	// fprintf( stderr, "utdredraw event\n" ) ;
	utDGUIforceRedraw() ;
	return(TCL_OK) ;
      }
    }
    // refresh_func = gc_p->refresh_func ;
    if( gc_p->refresh_func ){
      if( gc_p->fullView ){
	gc_p->refresh_func( &gc_p->fullArea, gc_p->clientData ) ;
      } else {
	gc_p->refresh_func( &gc_p->zoomArea, gc_p->clientData ) ;
      }
    }
    return(TCL_OK) ;
} /* end redraw_objfunc() */

static INT zoom_objfunc(ClientData d_p,Tcl_Interp *i_p,
                            int objc,Tcl_Obj * const objv[])
{
    typedef enum options {
      ZOOM_FIT_T,
      ZOOM_IN_T,
      ZOOM_OUT_T
    } ZOOM_OPTS_T ;

    BOOL abort_zoom ;			/* user abortted zoom */ 
    DOUBLE x, y ;			/* point chosen by user */
    DOUBLE x1, y1, x2, y2 ;		/* zoom box */
    DOUBLE zoom_factor ;		/* amount to zoom */
    GraphicsContextPtr gc_p ;		/* graphics context info */
    INT idx ;				/* selected option */
    INT status ;			/* return status */
    const char *at ;			/* label position */
    FUNC_NAME("utdzoom") ;

    static char *optionStringsL[] = {
      "fit",
      "in",
      "out",
      NULL
    } ;


    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n\n" );
      utDmsgf(ERRMSG,at,NULL,"%s : redraws the graphics window.\n", routine );
      utDmsgf(ERRMSG,at,NULL,"%s fit [x1 y1 x2 y2] : set graphics viewing frame to fit a bounding box.\n", routine ) ;
      utDmsgf(ERRMSG,at,NULL,"   if bounding box is now specified, user is asked to give rectangle with\n" ) ;
      utDmsgf(ERRMSG,at,NULL,"   mouse or keyboard.\n" ) ;
      utDmsgf(ERRMSG,at,NULL,"%s in [factor] : zoom in by given factor.  Default factor 0.5\n", routine ) ;
      utDmsgf(ERRMSG,at,NULL,"%s out [factor] : zoom out by given factor.  Default factor 2.0\n", routine ) ;
      return(TCL_OK) ;
    }

    gc_p = (GraphicsContextPtr) d_p ;
    if(!(gc_p)){
      return(TCL_ERROR) ; /* now open for business */
    }

    if( objc == 1 ){
      idx = ZOOM_FIT_T ;

    } else {
      status = Tcl_GetIndexFromObj(i_p,objv[1],optionStringsL,"option", 0, &idx ) ;
      if( status != TCL_OK ){
	return(TCL_ERROR) ;
      }
    }

    switch ( idx ) {
      case ZOOM_FIT_T:
	/* two cases: utdzoom fit */
	/*            utdzoom fit x1 y1 x2 y2 */
	if( objc == 6 ){
	  if( Tcl_GetDoubleFromObj(i_p,objv[2],&x1) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	  if( Tcl_GetDoubleFromObj(i_p,objv[3],&y1) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	  if( Tcl_GetDoubleFromObj(i_p,objv[4],&x2) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	  if( Tcl_GetDoubleFromObj(i_p,objv[5],&y2) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	  utDGUIzoom(x1, y1, x2, y2 ) ;
	} else {
	  utDmsg(IMSG,"utd/zoom:1", routine, "Pick or enter first point of bounding box:\n" ) ;
	  abort_zoom = utDGUIgetPt( &x1, &y1 ) ;
	  if( abort_zoom ){
	    utDmsgf( IMSG, MSG_AT, NULL, "[zoom]:Aborting zoom\n" ) ;
	    return(TCL_OK) ;
	  }
	  utDmsg(IMSG,"utd/zoom:2",routine, "Pick or enter second point of bounding box:\n" ) ;
	  abort_zoom = utDGUIpickRect( HIGHLITE, x1, y1, &x2, &y2 ) ;
	  if( abort_zoom ){
	    utDmsgf( IMSG, MSG_AT, NULL, "[zoom]:Aborting zoom\n" ) ;
	    return(TCL_OK) ;
	  }
	  utDmsgf( IMSG, MSG_AT, routine, "Frame now set to (%lf %lf) (%lf %lf)\n",
	      x1 / gc_p->scale, y1 / gc_p->scale, 
	      x2 / gc_p->scale, y2 / gc_p->scale ) ;
	  utDGUIzoom(x1, y1, x2, y2 ) ;
	}
	return(TCL_OK) ;

      case ZOOM_IN_T:
	if( objc < 3 ){
	  zoom_factor = 0.5 ;
	} else {
	  if( Tcl_GetDoubleFromObj(i_p,objv[2],&zoom_factor) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	}
	utDGUIzoom_factor( zoom_factor ) ;
	return(TCL_OK) ;

      case ZOOM_OUT_T:
	if( objc < 3 ){
	  zoom_factor = 2.0 ;
	} else {
	  if( Tcl_GetDoubleFromObj(i_p,objv[2],&zoom_factor) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	}
	utDGUIzoom_factor( zoom_factor ) ;
	return(TCL_OK) ;
    }
    return(TCL_OK) ;
} /* end zoom_objfunc() */

static INT scrollbar_objfunc(ClientData d_p,Tcl_Interp *i_p,
                             INT objc,Tcl_Obj * const objv[])
{
    INT idx ;				/* option index */
    DOUBLE x, y ;			/* scroll to this position */
    DOUBLE width ;			/* width of canvas */
    DOUBLE height ;			/* height of canvas */
    DOUBLE delta_x ;			/* delta x amount */
    DOUBLE delta_y ;			/* delta y amount */
    DOUBLE temp ;			/* temp value */
    DOUBLE fraction ;			/* current fraction */
    char *argv_i ;			/* current argument */
    Tcl_Obj *resultPtr ;		/* result info */
    GraphicsContextPtr gc_p ;		/* graphics context info */
    static DOUBLE xfractionL = 0.5 ;	/* x fraction */
    static DOUBLE yfractionL = 0.5 ;	/* y fraction */
    FUNC_NAME("utdscrollbar" ) ;

    static char *optionStringsL[] = {
      "xfraction",
      "yfraction",
      "xview",
      "yview",
      NULL
    } ;

    enum options {
      utDSCROLL_XFRACTION,
      utDSCROLL_YFRACTION,
      utDSCROLL_XVIEW,
      utDSCROLL_YVIEW
    } ;

    if( utDhelp_requested(objc,objv) ){
      utDmsgf(ERRMSG,MSG_AT, routine, "Internal command. Implements Tk scrollbar function for graphics window.\n" );
      return(TCL_ERROR) ;
    }

    Tcl_ResetResult(i_p) ;


    if( Tcl_GetIndexFromObj(i_p,objv[1],optionStringsL,"option", 0, &idx ) != TCL_OK ){
      return(TCL_ERROR) ;
    }

    resultPtr = Tcl_GetObjResult(i_p) ;

    gc_p = (GraphicsContextPtr) d_p ;
    if(!(gc_p)){
      return(TCL_ERROR) ; /* now open for business */
    }

    if( objc >= 2 ){
      switch ( (enum options) idx) {
	case utDSCROLL_XFRACTION :
	  /* utdscrollbar xfraction [value] */
	  if( objc >= 3 ){
	    if( Tcl_GetDoubleFromObj(i_p,objv[2],&temp) != TCL_OK ){
	      return(TCL_ERROR) ;
	    }
	    if( temp < 0.0 || temp > 1.0 ){
	      utDmsgf(ERRMSG,MSG_AT, routine,"xfraction must be between 0 and 1.0\n" ) ;
	      return(TCL_ERROR) ;
	    }
	    xfractionL = temp ;
	  }
	  Tcl_SetDoubleObj( resultPtr, xfractionL ) ;
	  break ;
	case utDSCROLL_YFRACTION :
	  /* utdscrollbar Yfraction [value] */
	  if( objc >= 3 ){
	    if( Tcl_GetDoubleFromObj(i_p,objv[2],&temp) != TCL_OK ){
	      return(TCL_ERROR) ;
	    }
	    if( temp < 0.0 || temp > 1.0 ){
	      utDmsgf(ERRMSG,MSG_AT,routine,"Yfraction must be between 0 and 1.0\n" ) ;
	      return(TCL_ERROR) ;
	    }
	    yfractionL = temp ;
	  }
	  Tcl_SetDoubleObj( resultPtr, yfractionL ) ;
	  break ;
	case utDSCROLL_XVIEW :
	  if( objc == 4 ){
	    if( gc_p && !(gc_p->fullView)){
	      if( Tcl_GetDoubleFromObj(i_p,objv[3],&fraction) != TCL_OK ){
		return(TCL_ERROR) ;
	      }
	      width = gc_p->fullArea.UTDURX - gc_p->fullArea.UTDLLX ;
	      if( width > 0 ){
		x = gc_p->fullArea.UTDLLX + fraction * width ;
		utDGUItranslate(NULL,x,0.0,UTDTRANS_LB|UTDTRANS_XVALID) ;
		/* update scrollbar settings */
		gc_p->lbX = (gc_p->zoomArea.UTDLLX - gc_p->fullArea.UTDLLX) / width ;
		gc_p->ubX = (gc_p->zoomArea.UTDURX - gc_p->fullArea.UTDLLX) / width ;
		if( gc_p->lbX < 0 ){
		  gc_p->lbX = 0.0 ;
		}
		if( gc_p->ubX > 1.0 ){
		  gc_p->ubX = 1.0 ;
		}
	      }
	    }
	  } else if( objc == 5 ){
	    argv_i = Tcl_GetString( objv[4] ) ;
	    if( argv_i && strcmp( argv_i, "units" ) == STRINGEQ ){
	      if( gc_p && !(gc_p->fullView)){
		if( Tcl_GetDoubleFromObj(i_p,objv[3],&fraction) != TCL_OK ){
		  return(TCL_ERROR) ;
		}
		fraction *= xfractionL ;
		width = gc_p->zoomArea.UTDURX - gc_p->zoomArea.UTDLLX ;
		if( width > 0 ){
		  delta_x = fraction * width ;
		  utDGUItranslate(NULL,delta_x,0.0,UTDTRANS_LB|UTDTRANS_XDELTA) ;
		  /* update scrollbar settings */
		  gc_p->lbX = (gc_p->zoomArea.UTDLLX - gc_p->fullArea.UTDLLX) / width ;
		  gc_p->ubX = (gc_p->zoomArea.UTDURX - gc_p->fullArea.UTDLLX) / width ;
		  if( gc_p->lbX < 0 ){
		    gc_p->lbX = 0.0 ;
		  }
		  if( gc_p->ubX > 1.0 ){
		    gc_p->ubX = 1.0 ;
		  }
		}
	      }
	    }
	  }
	  break ;

	case utDSCROLL_YVIEW :
	  if( objc == 4 ){
	    if( gc_p && !(gc_p->fullView)){
	      if( Tcl_GetDoubleFromObj(i_p,objv[3],&fraction) != TCL_OK ){
		return(TCL_ERROR) ;
	      }
	      height = gc_p->fullArea.UTDURY - gc_p->fullArea.UTDLLY ;
	      if( height > 0 ){
		y = gc_p->fullArea.UTDURY - fraction * height ;
		utDGUItranslate(NULL,0.0,y,UTDTRANS_RT|UTDTRANS_YVALID) ;
		/* update scrollbar settings */
		gc_p->lbY = (gc_p->fullArea.UTDURY - gc_p->zoomArea.UTDURY) / height ;
		gc_p->ubY = (gc_p->fullArea.UTDURY - gc_p->zoomArea.UTDLLY) / height ;
		if( gc_p->lbY < 0.0 ){
		  gc_p->lbY = 0.0 ;
		}
		if( gc_p->ubY > 1.0 ){
		  gc_p->ubY = 1.0 ;
		}
	      }
	    }
	  } else if( objc == 5 ){
	    argv_i = Tcl_GetString( objv[4] ) ;
	    if( argv_i && strcmp( argv_i, "units" ) == STRINGEQ ){
	      if( gc_p && !(gc_p->fullView)){
		if( Tcl_GetDoubleFromObj(i_p,objv[3],&fraction) != TCL_OK ){
		  return(TCL_ERROR) ;
		}
		fraction *= yfractionL ;
		height = gc_p->zoomArea.UTDURY - gc_p->zoomArea.UTDLLY ;
		if( height > 0 ){
		  delta_y = fraction * height ;
		  utDGUItranslate(NULL,0.0,delta_y,UTDTRANS_LB|UTDTRANS_YDELTA) ;
		  /* update scrollbar settings */
		  gc_p->lbY = (gc_p->fullArea.UTDURY - gc_p->zoomArea.UTDURY) / height ;
		  gc_p->ubY = (gc_p->fullArea.UTDURY - gc_p->zoomArea.UTDLLY) / height ;
		  if( gc_p->lbY < 0.0 ){
		    gc_p->lbY = 0.0 ;
		  }
		  if( gc_p->ubY > 1.0 ){
		    gc_p->ubY = 1.0 ;
		  }
		}
	      }
	    }
	  }
	  break ;
	}
    }
    return(TCL_OK) ;
} /* end scrollbar_objfunc() */

static INT fullframe_objfunc(ClientData d_p,Tcl_Interp *i_p,
                            int objc,Tcl_Obj * const objv[])
{
    char *argv_1 ;			/* first argument */
    const char *at ;			/* label position */
    Tcl_Obj *x1Obj ;			/* x1 result */
    Tcl_Obj *y1Obj ;			/* y1 result */
    Tcl_Obj *x2Obj ;			/* x2 result */
    Tcl_Obj *y2Obj ;			/* y2 result */
    Tcl_Obj *resultPtr ;		/* result info */
    GraphicsContextPtr gc_p ;		/* graphics context info */
    FUNC_NAME("utdfullframe") ;

    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n\n" );
      utDmsgf(ERRMSG,at,NULL,"%s : returns the graphics frame to full view.\n", routine );
      utDmsgf(ERRMSG,at,NULL,"%s -current : returns current coordinates of window frame.\n", routine );
      return(TCL_OK) ;
    }

    gc_p = (GraphicsContextPtr) d_p ;
    if(!(gc_p)){
      return(TCL_ERROR) ; /* now open for business */
    }
    if( objc >= 2 ){
      if( gc_p->fullView ){
	x1Obj = Tcl_NewDoubleObj(gc_p->fullArea.UTDLLX/gc_p->scale) ;
	y1Obj = Tcl_NewDoubleObj(gc_p->fullArea.UTDLLY/gc_p->scale) ;
	x2Obj = Tcl_NewDoubleObj(gc_p->fullArea.UTDURX/gc_p->scale) ;
	y2Obj = Tcl_NewDoubleObj(gc_p->fullArea.UTDURY/gc_p->scale) ;
      } else {
	x1Obj = Tcl_NewDoubleObj(gc_p->zoomArea.UTDLLX/gc_p->scale) ;
	y1Obj = Tcl_NewDoubleObj(gc_p->zoomArea.UTDLLY/gc_p->scale) ;
	x2Obj = Tcl_NewDoubleObj(gc_p->zoomArea.UTDURX/gc_p->scale) ;
	y2Obj = Tcl_NewDoubleObj(gc_p->zoomArea.UTDURY/gc_p->scale) ;
      }
      resultPtr = Tcl_GetObjResult(i_p) ;
      Tcl_ListObjAppendElement( NULL,resultPtr,x1Obj ) ;
      Tcl_ListObjAppendElement( NULL,resultPtr,y1Obj ) ;
      Tcl_ListObjAppendElement( NULL,resultPtr,x2Obj ) ;
      Tcl_ListObjAppendElement( NULL,resultPtr,y2Obj ) ;
    } else {
      utDGUIfullFrame() ;
    }
    return(TCL_OK) ;
} /* end fullframe_objfunc() */

static INT translate_objfunc(ClientData d_p,Tcl_Interp *i_p,
                            int objc,Tcl_Obj * const objv[])
{
    INT i ;				/* arg counter */
    char *msg ;				/* message to user */
    const char *at ;			/* message position */
    const char *argv_i ;		/* ith argument */
    DOUBLE x, y ;			/* translation origin */
    DOUBLE x1, y1 ;			/* position given */
    UTDTRANS_T trans_type ;		/* type of translation */
    UTDTRANS_T xvalid ;			/* x coordinate valid */
    UTDTRANS_T yvalid ;			/* y coordinate valid */
    GraphicsContextPtr gc_p ;		/* graphics context info */
    FUNC_NAME("utdtranslate") ;


    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n\n" );
      utDmsgf(ERRMSG,at,NULL, "utdtranslate : translate to the center of the screen.\n" ) ;
      utDmsgf(ERRMSG,at,NULL, "utdtranslate <x> <y> : translate center to specified points.\n" ) ;
      utDmsgf(ERRMSG,at,NULL, "utdtranslate [-origin] x y - translate lower left to specified points.\n" ) ;
      utDmsgf(ERRMSG,at,NULL, "utdtranslate [-center] x y - translate center left to specified points.\n" ) ;
      return(TCL_OK) ;
    }

    gc_p = (GraphicsContextPtr) d_p ;
    if(!(gc_p)){
      return(TCL_ERROR) ; /* now open for business */
    }
    x = 0.0 ;
    y = 0.0 ;
    trans_type = UTDTRANS_CENTER ;
    msg = UTDTRANS_MSG_C ;
    xvalid = 0 ;
    yvalid = 0 ;
    for( i = 1 ; i < objc ; i++ ){
      argv_i = Tcl_GetString( objv[i] ) ;
      if( strcmp( argv_i, "-origin" ) == STRINGEQ ){
	trans_type = UTDTRANS_LB ;
	msg = UTDTRANS_MSG_LB ;
      } else if( strcmp( argv_i, "-center" ) == STRINGEQ ){
	trans_type = UTDTRANS_CENTER ;
	msg = UTDTRANS_MSG_C ;
      } else {
	if( (i+1) >= objc ){
	  utDmsgf(ERRMSG,"utDGUItranslate:1", routine, "Not enough argument to %s command.\n", routine);
	  return(TCL_ERROR) ;
	}
	if( gc_p ){
	  if( Tcl_GetDoubleFromObj(i_p,objv[i],&x1) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	  if( Tcl_GetDoubleFromObj(i_p,objv[i],&y1) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	  x = rint(gc_p->scale * x1) ;
	  y = rint(gc_p->scale * y1) ;
	  xvalid = UTDTRANS_XVALID ;
	  yvalid = UTDTRANS_YVALID ;
	  msg = NULL ;
	}
      }
    }
    utDGUItranslate(msg,x,y,trans_type|xvalid|yvalid) ;

    return(TCL_OK) ;
} /* end translate_objfunc() */

static void run_stats(void)
{
    UTDDSTRING mbuf ;			/* message buffer */
    char *msg_str ;			/* message string */

    utDdstring_init(&mbuf) ;
    msg_str = _utDstats_print(&mbuf) ;
    if( msg_str ){
      utDmsgf(IMSG,MSG_AT,NULL,"%s\n", msg_str ) ;
    }
    utDdstring_free( &mbuf ) ;
} /* run_stats() */

static INT exit_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[])
{
    INT out_status ;			/* output status */
    INT status ;			/* extract status */
    const char *at ;			/* label position */
    FUNC_NAME("utdexit") ;

    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n" );
      utDmsgf(ERRMSG,at,NULL, "utdexit : This routine exits the program gracefully.\n" ) ;
      return(TCL_OK) ;
    }
    out_status = PGMOK ;
    if( objc >= 2 ){
      if( Tcl_GetIntFromObj(i_p,objv[1],&status) != TCL_OK ){
	out_status = PGMFAIL ;
      } else if( status ){
	out_status = PGMFAIL ;
      }
    }
    run_stats() ;
    utDtcllog_exit() ;
    utDprogram_exitFunction(NULL) ;  // We will do these functions only
    utDprogram_exit(out_status) ;

  return(TCL_OK) ;
} /* end exit_objfunc() */

static INT continue_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[])
{
    const char *at ;			/* label position */
    GraphicsContextPtr gc_p ;		/* graphics context info */
    FUNC_NAME("utdcontinue") ;

    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n" );
      utDmsgf(ERRMSG,at,NULL, "utdcontinue : exit a Tcl wait loop and \
continue program execution.\n");
      return(TCL_OK) ;
    }

    gc_p = (GraphicsContextPtr) d_p ;
    if(!(gc_p)){
      return(TCL_ERROR) ; /* now open for business */
    }
    gc_p->wait_loop = FALSE ;

  return(TCL_OK) ;
} /* end continue_objfunc() */


static INT wait_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[])
{
    const char *at ;			/* label position */
    GraphicsContextPtr gc_p ;		/* graphics context info */
    FUNC_NAME("utdwait") ;

    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n" );
      utDmsgf(ERRMSG,at,NULL, "utdwait : enter a Tcl wait loop for processing \
commands.\n" ) ;
      return(TCL_OK) ;
    }

    utDGUI_run() ; 

    return(TCL_OK) ;
} /* end wait_objfunc() */


static INT msg_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[])
{
  INT i ;				/* arg counter */
  INT mode ;				/* message mode */
  INT type ;				/* type of message */
  char *argv_1 ;			/* argument string */
  char *argv_2 ;			/* argument string */
  char *chan_name ;			/* name of channel */
  char *routine ;			/* routine name */
  const char *at ;			/* message position */
  const char *msg_echo ;		/* echo message */
  ClientData data ;			/* client data */
  BOOL lib_message ;			/* use library message facility */
  Tcl_Channel channel ;			/* tcl channel */
  Tcl_Obj *strObj ;			/* new string object */
  Tcl_Obj *resultPtr ;			/* result information */
  GraphicsContextPtr gc_p ;		/* graphics context info */

  type = 0 ;
  routine = NULL ;
  lib_message = FALSE ;
  if( utDhelp_requested(objc,objv) ){
    at = MSG_AT ;
    utDmsgf(ERRMSG,at,"utdmsg", "Help:\n\n" );
    utDmsgf(ERRMSG,at,NULL, "utdmsg {errmsg|warnmsg|imsg|msg} \
{commandName|null} {message text} :" ) ;
    utDmsgf(ERRMSG,at,NULL,
      "the routine \n\twrites the specified message to the transcript window.\n" ) ;
    utDmsgf(ERRMSG,at,NULL, "\tThere are 4 types of messages: errors, warnings, immediate messages \
and \n\tordinary messages. The command name may be ommitted by specifying \
the string %cnull%c.\n", DQUOTE, DQUOTE ) ;
    utDmsgf(ERRMSG,at,NULL, "utdmsg register <channel> : register channel with \
Tcl interpreter.\n" ) ;
    utDmsgf(ERRMSG,at,NULL, "utdmsg unregister <channel> : unregister channel \
with Tcl interpreter.\n" ) ;
    utDmsgf(ERRMSG,at,NULL, "utdmsg mode : returns the current message mode.\n" ) ;
    utDmsgf(ERRMSG,at,NULL, "utdmsg mode {verbose | normal | silent | mute} : sets \
the current message mode.\n" ) ;
    utDmsgf(ERRMSG,at,NULL, "\nThe simple command: ormsg {message_text} is a \
shortcut for the command:\n\tormsg msg null {message_text}.\n" ) ;
    return(TCL_OK) ;
  }

  gc_p = (GraphicsContextPtr) d_p ;
  if(!(gc_p)){
    return(TCL_ERROR) ; /* nor open for business */
  }
  Tcl_ResetResult(i_p) ;
  resultPtr = Tcl_GetObjResult(i_p) ;
  if( objc >= 2 ){
    argv_1 = Tcl_GetString( objv[1] ) ;
  } else {
    argv_1 = NULL ;
  }
  if( objc >= 3 ){
    if( utDstrnicmp( argv_1, "errmsg", 3) == STRINGEQ ){
      type = utDmsg_tcl_options(ERRMSG, argv_1) ;
      lib_message = TRUE ;
    } else if( utDstrnicmp( argv_1, "warnmsg",4) == STRINGEQ ){
      type = utDmsg_tcl_options(WARNMSG, argv_1) ;
      lib_message = TRUE ;
    } else if( utDstrnicmp( argv_1, "msg", 3) == STRINGEQ ){
      type = utDmsg_tcl_options(MSG, argv_1) ;
      lib_message = TRUE ;
    } else if( utDstrnicmp( argv_1, "imsg", 4) == STRINGEQ ){
      type = utDmsg_tcl_options(IMSG, argv_1) ;
      lib_message = TRUE ;
    } else if( utDstricmp( argv_1, "mode") == STRINGEQ ){
      if( objc >= 3 ){
	argv_2 = Tcl_GetString( objv[2] ) ;
	if( utDstricmp( argv_2, "verbose") == STRINGEQ ){
	  utDmsg_mode( M_VERBOSE ) ;
	} else if( utDstricmp( argv_2, "normal") == STRINGEQ ){
	  utDmsg_mode( M_NORMAL ) ;
	} else if( utDstricmp( argv_2, "silent") == STRINGEQ ){
	  utDmsg_mode( M_SILENT ) ;
	} else if( utDstricmp( argv_2, "mute") == STRINGEQ ){
	  utDmsg_mode( M_MUTE ) ;
	} else {
	  utDmsgf(ERRMSG,MSG_AT,"utdmsg", "unknown mode:%s\n", argv_2 ) ;
	  return( TCL_ERROR ) ;
	}
      }
      mode = utDmsg_get_mode() ;
      if( mode & M_VERBOSE ){
	strObj = Tcl_NewStringObj("verbose", -1 ) ;
      } else if( mode & M_NORMAL ){
	strObj = Tcl_NewStringObj("normal", -1 ) ;
      } else if( mode & M_SILENT ){
	strObj = Tcl_NewStringObj("silent", -1 ) ;
      } else if( mode & M_MUTE ){
	strObj = Tcl_NewStringObj("mute", -1 ) ;
      } else {
	strObj = Tcl_NewStringObj("unknown", -1 ) ;
      }
      Tcl_ListObjAppendElement(NULL,resultPtr, strObj) ;
      return( TCL_OK ) ;

    } else if( utDstrnicmp( argv_1, "register", 3) == STRINGEQ ){
      chan_name = Tcl_GetString( objv[2] ) ;
      channel = Tcl_GetChannel( i_p, chan_name, NULL ) ;
      if(!(channel)){
	utDmsgf(ERRMSG, MSG_AT,"utdmsg", "Could not find channel:%s\n", chan_name ) ;
	return(TCL_ERROR) ;
      }
      if (Tcl_GetChannelHandle(channel,TCL_WRITABLE,(ClientData*) &data) != TCL_OK){
	utDmsgf(ERRMSG, MSG_AT,"utdmsg", "Could not find channel file descriptor:%s\n", chan_name ) ;
	return(TCL_ERROR) ;
      }
      utDmsg_func( utDmsg_stream_msg, MESSAGE_LOG_T, data, MSGFUNC_OPT_NONE ) ;
      return(TCL_OK) ;
    } else if( utDstrnicmp( argv_1, "unregister", 3) == STRINGEQ ){
      chan_name = Tcl_GetString( objv[2] ) ;
      channel = Tcl_GetChannel( i_p, chan_name, NULL ) ;
      if(!(channel)){
	utDmsgf(ERRMSG, MSG_AT,"utdmsg", "Could not find channel:%s\n", chan_name ) ;
	return(TCL_ERROR) ;
      }
      if (Tcl_GetChannelHandle(channel,TCL_WRITABLE,(ClientData*) &data) != TCL_OK){
	utDmsgf(ERRMSG, MSG_AT,"utdmsg", "Could not find channel file descriptor:%s\n", chan_name ) ;
	return(TCL_ERROR) ;
      }
      utDmsg_func_delete_clientData( data ) ;
      return(TCL_OK) ;
    }
    argv_2 = Tcl_GetString( objv[2] ) ;
    if( utDstricmp( argv_2, "null") == STRINGEQ ){
      routine = NULL ;
    } else {
      routine = argv_2 ;
    }
  } else if( (objc == 2) && (utDstricmp( argv_1, "mode") == STRINGEQ) ){
    mode = utDmsg_get_mode() ;
    if( mode & M_VERBOSE ){
      strObj = Tcl_NewStringObj("verbose", -1 ) ;
    } else if( mode & M_NORMAL ){
      strObj = Tcl_NewStringObj("normal", -1 ) ;
    } else if( mode & M_SILENT ){
      strObj = Tcl_NewStringObj("silent", -1 ) ;
    } else if( mode & M_MUTE ){
      strObj = Tcl_NewStringObj("mute", -1 ) ;
    } else {
      strObj = Tcl_NewStringObj("unknown", -1 ) ;
    }
    Tcl_ListObjAppendElement(NULL,resultPtr, strObj) ;
    return( TCL_OK ) ;
  }
  if( lib_message ){
    if( routine ){
      msg_echo = utDmsgf( type|MSG_GRAPHICS, MSG_AT,routine, NULL ) ;
      if( type & MSG_TCL_INTERP ){
	Tcl_AppendResult(i_p, msg_echo, NULL ) ;
      }
    }
    for( i = 3 ; i < objc ; i++ ){
      msg_echo = utDmsgf( type|MSG_GRAPHICS,  MSG_AT,NULL, Tcl_GetString(objv[i]) ) ;
      if( type & MSG_TCL_INTERP ){
	Tcl_AppendResult(i_p, msg_echo,  MSG_AT,NULL ) ;
      }
    }
  } else {
    for( i = 1 ; i < objc ; i++ ){
      utDGUITk_transcript( "%s", Tcl_GetString(objv[i]) ) ;
    }
  }
  return(TCL_OK) ;

} /* end msg_objfunc() */


static void utDGUITk_transcript( char *format, ... )
{
    va_list args ;
    INT code ;					/* return code from Tcl_Eval */
    INT len ;					/* length of message */
    const char *trans_p ;			/* transcript string */
    const char *result ;			/* result of command */
    char *trans_string ;			/* transcript string */
    char cmd[LRECL] ;				/* output a command */
    GraphicsContextPtr gc_p ;			/* graphics context pointer */
    static char *bufferL ;			/* output buffer */
    static Tcl_DString *trans_bufL ;		/* output buffer */
    static INT buf_sizL ;			/* output buffer size */


    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ; /* really can't do anything */
    }

    if(!(trans_bufL)){
      buf_sizL = BUFSIZ ;
      bufferL = UTDMALLOC( buf_sizL, char ) ;
      trans_bufL = UTDMALLOC( 1, Tcl_DString ) ;
      Tcl_DStringInit( trans_bufL ) ;
    }

    /* first find length of buffer */
    /* this must be improved.  Could have a problem on %4ld formats. */
    va_start( args, format ) ;
    len = utDdstring_format_length( args, format ) ;

    if( len > buf_sizL ){
      buf_sizL = 2 * len ;
      bufferL = UTDREALLOC( bufferL, buf_sizL, char ) ;
    }

    va_start( args, format ) ;
    vsprintf( bufferL, format, args ) ;
    va_end( args ) ;

    /* find the name of the transcript buffer */
    if( gc_p ){
      if(!(gc_p->transcript_widget)){
	trans_p = Tcl_GetVar2(gc_p->interp,"utdsymbolicNameG", "utdtranscript", 
				     TCL_GLOBAL_ONLY | TCL_LEAVE_ERR_MSG ) ;
	if( trans_p ){
	  gc_p->transcript_widget = utDstrclone(trans_p) ;
	} else {
	  if( gc_p->tk_mode ){
	    return ; /* Don't need to do this */
	  }
	  utDmsg( ERRMSG|MSG_RESTRICTED,MSG_AT,"utDGUITk_transcript","Could not find ictranscript widget.\n");
	  result = Tcl_GetStringResult(gc_p->interp) ;
	  if(result){
	    utDmsgf( ERRMSG|MSG_RESTRICTED,MSG_AT,NULL,"%s\n", result) ;
	    return ;
	  }
	}
      }
      if( utDstricmp( gc_p->transcript_widget, "utDNONE" ) == STRINGEQ ){
	return ; /* turned off */
      }

      Tcl_DStringSetLength( trans_bufL, 0 ) ;
      Tcl_DStringAppend( trans_bufL, gc_p->transcript_widget, -1 ) ;
      Tcl_DStringAppend( trans_bufL, " insert end ", -1 ) ;
      Tcl_DStringAppendElement( trans_bufL, bufferL ) ;
      trans_string = Tcl_DStringAppend( trans_bufL, "\n", -1 ) ;
      code = Tcl_GlobalEval( gc_p->interp, trans_string ) ;
      if (code != TCL_OK) {
	utDmsg( ERRMSG|MSG_RESTRICTED,MSG_AT,"utDGUITk_transcript","Could not set insert in utdtranscript.\n");
	result = Tcl_GetStringResult(gc_p->interp) ;
	if(result){
	  utDmsgf( ERRMSG|MSG_RESTRICTED,MSG_AT,NULL,"%s\n", result) ;
	}
      }
      Tk_UpdateObjCmd(gc_p->mainWindow,gc_p->interp,1,NULL) ;
    }
    /* after an update the interpreter could disappear */
    if( gc_p ){
      sprintf( cmd,"[set utdsymbolicNameG(utdtranscript)] see end");
      code = Tcl_GlobalEval( gc_p->interp, cmd ) ;
      if (code != TCL_OK) {
	utDmsgf( ERRMSG|MSG_RESTRICTED,MSG_AT,"Tk_transcript","Could not see end in ictranscript.\n");
	result = Tcl_GetStringResult(gc_p->interp) ;
	if(result){
	  utDmsgf( ERRMSG|MSG_RESTRICTED,MSG_AT,NULL,"%s\n", result) ;
	}
      }
      Tk_UpdateObjCmd(gc_p->mainWindow,gc_p->interp,1,NULL) ;
    }

} /* end utDGUITk_transcript() */
