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
#include <utd/config.h>
#include <utd/base.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/dstring.h>
#include <utd/program.h>
#include <utd/system.h>
#include <gui/gui.hpp>
#include <stdlib.h>

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static void draw_the_data(UTDRECTPTR area, void *clientData ) ;
static void calc_full_screen_coordinate( UTDGui::Gui *gui ) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */

int main(int argc, char *argv[] ) {
    Tcl_Interp *inter_p ;		// Tcl Interpreter
    UTDGui::Gui gui ;			// Instantiate an UTDGui 
    char *cmdName ;			/* simple name of program */
    char *utddirG ;			// root directory */
    char *script_name ;			/* script name */
    char name_buffer[LRECL] ;		/* for now */
    UTD_DSTRING script_buf ;		/* build a script name overkill */
    FUNC_NAME("main") ;

#ifdef UTDMEM_DEBUG
    FILE *fmemdebug = UTDOPEN( "mem.out", "w", FILE_ABORT| FILE_VERBOSE) ;
    UTDmalloc_debug_memory( fmemdebug, 1000, 10 ) ;
#endif /* UTDMEM_DEBUG */

    cmdName = UTDprogram_simplify_name( argv[0], name_buffer ) ;
    UTDprogram_init( cmdName, "0.0", UTDGUI_COMPILE_DATE, TRUE ) ;
    utddirG = UTDgetenv(GUI_GRAPHICS_ENVIRONMENT) ;
    if(!(utddirG)){
      UTDmsgf(ERRMSG,"main:1", routine, "Could not find %s env variable\n",
	      GUI_GRAPHICS_ENVIRONMENT) ;
      UTDprogram_exit(PGMFAIL) ;
    }

    inter_p = Tcl_CreateInterp() ;

    UTDmsg_mode(M_NORMAL) ;

    // Show how a dstring works
    UTDdstring_init( &script_buf ) ;
    script_name = UTDdstring_printf( &script_buf, "%s/tcl/%s/%s", utddirG, 
	    GUI_GRAPPHICS_INIT_DIR, "testgui.tcl" ) ;

    // A Tcl only Gui
    // gui.Init( argc, argv, script_name, inter_p, FALSE, NULL, NULL, NULL, 0 ) ;

    // A Tix/Tk/Tcl Gui
    const char *str = "Hello World" ;
    gui.Init( argc, argv, script_name, inter_p, TRUE, draw_the_data, &gui, NULL, 0 ) ;

    calc_full_screen_coordinate( &gui ) ;

    gui.Run() ;

    UTDmsg( IMSG, MSG_AT, "main", "yes we get here\n" ) ;
#ifdef UTDMEM_DEBUG
    UTDmalloc_dump_use( NULL ) ;
    /* purposefully don't close file descriptor to test flush */
    MemTrack::TrackDumpBlocks() ;
    MemTrack::TrackListMemoryUsage();
#endif /* UTDMEM_DEBUG */


    exit(0) ;

}

static void calc_full_screen_coordinate( UTDGui::Gui *gui ) {
    // Here is where we calculate the size of the full
    // screen draw.  Normally, we would traverse the
    // data in our program to calculate it's extent and
    // then add 10% to make a nice picture.  Scale is
    // used to make database units easier to manipulate
    
    // Just make up something here.
    gui->setFrame( -10, -10, 110, 110, 1, 1 ) ;
}

static void draw_the_data( UTDTILERECTPTR area, void *clientData ) {
  UTDGui::Gui *gui = (UTDGui::Gui *) clientData ;
  gui->startFrame() ;

  const char *label = "hello world!" ;
  gui->drawRect( 50.0, 50.0, 75.0, 74.0, UTDRED, label ) ;
  gui->drawLine( 10.0, 10.0, 75.0, 74.0, UTDBLUE, NULL ) ;

  gui->flushFrame() ;
}
