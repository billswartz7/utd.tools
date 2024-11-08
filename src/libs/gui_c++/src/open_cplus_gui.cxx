/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    open_gui.cxx                                       
DESCRIPTION:Top level graphical user interface calling Tix/Tk/Tcl C++ bindings
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#include "config.h"
#include <tcl/tcl.h>
#include <tk/tk.h>
#include <tix/tix.h>
#include <iostream>
#include <utd/base.h>
#include <utd/debug.h>
#include <utd/dstring.h>
#include <utd/string.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/program.h>
#include <utd/system.h>
#include <gui/colors.h>
#include <gui/gui.h>
#include "gc.h"
#include "open_gui_int.h"
#include "open_gui.hpp"

/* ********************** TYPE DEFINITIONS ************************* */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */

namespace UTDGui {

  Gui::Gui() {
  }

  Gui::~Gui() {

  }

  bool Gui::Init( int argc,char *argv[],const char *script_file,
                  Tcl_Interp *interp,
		  UTDGUI_OPTS_T options,
		  void (*refresh_func)(UTDRECTPTR,void *),
		  void *clientData,
		  FILE *did_file,
		  int parasite_windowId ){

    bool status = utDGUI_init( argc, argv, script_file, interp,
	                      options, refresh_func,
			      clientData, did_file, parasite_windowId ) ;

    this->gc = utDGUI_get_gc() ;

    return( status ) ;

  }

  void Gui::Run( void ) {
    if(!(gc)){
      return ;
    }

    if( gc->interp ) {
      gc->wait_loop = true ;
      while( gc->wait_loop ){
	Tcl_DoOneEvent(TCL_ALL_EVENTS | TCL_SERVICED_EVENT ) ;
      }
      gc->wait_loop = true ;	// guarantee a wait for any related call
    }
  }

  void Gui::setFrame( DOUBLE left,DOUBLE bottom,DOUBLE right,DOUBLE top,
		      DOUBLE scale, INT precision ) {
    utDGUIsetFrame( left, bottom, right, top, scale, precision ) ;
  }

  void Gui::startFrame(void) {
    utDGUIstartFrame() ;
  }

  void Gui::flushFrame(void) {
    utDGUIflushFrame() ;
  }

  void Gui::drawLine(DOUBLE x1,DOUBLE y1,DOUBLE x2,DOUBLE y2,INT color,
                     const char *label ){
    utDGUIdrawLine( x1, y1, x2, y2, color, label ) ;
  }

  void Gui::drawRect(DOUBLE x1,DOUBLE y1,DOUBLE x2,DOUBLE y2,INT color,
                     const char *label){
    utDGUIdrawRect( x1, y1, x2, y2, color, label) ;
  }

  const char * Gui::_ExecTcl( const char *command, INT *status, 
                              MSG_TYPE_T mtype ){
    const char *result = _utDGUI_exec_tcl( command, status, mtype ) ;
    return(result) ;
  }

  const char * Gui::ExecTcl( const char *command, INT *status ){
    const char *result = utDGUI_exec_tcl( command, status ) ;
    return(result) ;
  }

  void Gui::CheckTclCode(Tcl_Interp *interp, INT code, const char *label,
                         const char *routine) {
    utDGUIcheck_tcl_code( interp, code, label, routine) ;
  }



} ;

