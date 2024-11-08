/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    testgui.cxx                                      
DESCRIPTION:Test the gui
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#include "config.h"
#include "runenv.h"
#include "timestamp.h"
#include <utd/base.h>
#include <utd/msg.h>
#include <utd/dstring.h>
#include <utd/program.h>
#include <utd/system.h>
#include <utd/rand.h>
#include <utd/string.h>
#include <utd/tile.h>
#include <gui/gui.h>
#include <stdlib.h>

/* ********************** TYPE DEFINITIONS ************************* */
#define MINXY 0
#define MAXXY 10000

typedef struct my_data {
  INT color ;
  char *idx ;
} MY_DATA, *MY_DATAPTR ;

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static void draw_the_data(UTDTILERECTPTR area, void *clientData ) ;
static void calc_full_screen_coordinate( UTDPLANEPTR plane_p) ;
static UTDPLANEPTR create_some_data(void) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */

int main(int argc, char *argv[] ) {
    Tcl_Interp *inter_p ;		// Tcl Interpreter
    char *cmdName ;			/* simple name of program */
    char *utddirG ;			// root directory */
    char *utdversionG ;			// root directory */
    char *script_name ;			/* script name */
    char name_buffer[LRECL] ;		/* for now */
    UTDPLANEPTR plane_p ;		/* create a tile plane */
    UTDDSTRING script_buf ;		/* build a script name overkill */
    FUNC_NAME("main") ;


    cmdName = utDprogram_simplify_name( argv[0], name_buffer ) ;
    utDprogram_init( cmdName, "0.0", UTD_COMPILE_DATE, TRUE ) ;
    utddirG = utDgetenv("UTDTOOLS") ;
    if(!(utddirG)){
      utDmsgf(ERRMSG,"main:1", routine, "Could not find %s env variable\n",
	      "UTDTOOLS") ;
      utDprogram_exit(PGMFAIL) ;
    }

    utdversionG = utDgetenv("UTDTOOLSVERSION") ;
    if(!(utdversionG)){
      utDmsgf(ERRMSG,"main:1", routine, "Could not find %s env variable\n",
	      "UTDTOOLSVERSION") ;
      utDprogram_exit(PGMFAIL) ;
    }

    inter_p = Tcl_CreateInterp() ;

    utDmsg_mode(M_NORMAL) ;

    // Show how a dstring works
    utDdstring_init( &script_buf ) ;
    script_name = utDdstring_printf( &script_buf, "%s/tcl/%s/%s", 
	utddirG, "utdgui", "testgui.tcl" ) ;

    // A Tcl only Gui
    // utDGUI_init( argc, argv, script_name, inter_p, FALSE, NULL, NULL, NULL,0 ) ;

    plane_p = create_some_data() ;

    // A Tix/Tk/Tcl Gui
    utDGUI_init( argc, argv, script_name, inter_p, TRUE, draw_the_data, 
	         plane_p, NULL, 0 ) ;


    calc_full_screen_coordinate( plane_p ) ;

    utDGUI_run() ;

    utDmsg( IMSG, MSG_AT, "main", "yes we get here\n" ) ;

    exit(0) ;

}

static void calc_full_screen_coordinate( UTDPLANEPTR plane_p ) 
{
    BOOL first ;		/* first geometry */
    UTDTILEPTR tp ;		/* tile pointer */
    UTDTILERECT bbox ;		/* bounding box rectangle */
    UTDTILERECT geom ;		/* geometry */

    // Calculate the size of the full screen draw.  
    
    first = TRUE ;
    for( tp = utDtile_enumerate_all( plane_p, NULL ) ; tp ;
         tp = utDtile_enumerate_all( plane_p, tp ) ){
      if( tp->data ){
	utDtile_rect_orient( plane_p, tp, &geom ) ;
	utDtile_rect_bbox( &bbox, &geom, first ) ;
	first = FALSE ;
      }
    }
    // Just make up something here.
    utDGUIsetFrame( bbox.UTDLLX, bbox.UTDLLY, bbox.UTDURX, bbox.UTDURY, 1, 1 ) ;
}

static void draw_the_data( UTDTILERECTPTR area, void *clientData ) 
{
  UTDTILEPTR tp ;		/* tile pointer */
  UTDPLANEPTR plane_p ;		/* tile plane to draw */
  UTDTILERECT geom ;		/* geometry */
  MY_DATAPTR my_data_p ;	/* some data to process */

  utDGUIstartFrame() ;

  plane_p = (UTDPLANEPTR) clientData ;
  if(!(plane_p)){
    return ;
  }
  for( tp = utDtile_enumerate( plane_p, area, NULL ) ; tp ;
       tp = utDtile_enumerate( plane_p, area, tp ) ){
    my_data_p = (MY_DATAPTR) tp->data ;
    if( my_data_p ){
      utDtile_rect_orient( plane_p, tp, &geom ) ;
      utDGUIdrawRect( geom.UTDLLX, geom.UTDLLY, 
	              geom.UTDURX, geom.UTDURY, my_data_p->color, 
		                                my_data_p->idx ) ;
    }
  }
  utDGUIflushFrame() ;
}


static UTDPLANEPTR create_some_data(void)
{
    INT c ;				/* color counter */
    INT i ;				/* tile counter */
    UTDPLANEPTR plane_p ;		/* create a tile plane */
    UTDTILERECT r ;			/* make a rectangle */
    MY_DATAPTR my_data_p ;		/* some data to process */
    char idx_buf[80] ;			/* temp buf for index */


    plane_p = utDtile_init_vert( NULL, NULL ) ;
    utDrandom_set_seed(1) ;
    /* add a load of tiles */
    for ( i = 1; i <= 100 ; i++ ) {
      /* make a random rect */
      r.UTDLLX = UTD_PICK_INT ( MINXY, MAXXY - 1 ) ;
      r.UTDURX = UTD_PICK_INT ( (INT)r.UTDLLX + 1, (INT)MAXXY  ) ;
      r.UTDLLY = UTD_PICK_INT ( MINXY, MAXXY - 1 ) ;
      r.UTDURY = UTD_PICK_INT ( (INT)r.UTDLLY + 1, (INT)MAXXY  ) ;

      /* pick a random color */
      c = UTD_PICK_INT ( UTDRED, utDGUIcolor_numstd() ) ;

      /* Allocate some unique data */
      my_data_p = UTDMALLOC( 1, MY_DATA ) ;
      my_data_p->color = c ;
      sprintf( idx_buf, "%d", i ) ;
      my_data_p->idx = utDstrclone(idx_buf) ;

      /* add the random tile */
      utDtile_add ( plane_p, &r, my_data_p ) ;

    }
    return( plane_p ) ;
} /* end create_some_data() */
