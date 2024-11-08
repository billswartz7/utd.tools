/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    open_gui.c                                       
DESCRIPTION:Top level graphical user interface calling Tix/Tk/Tcl
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_OPEN_GUI_H
#define INCLUDED_OPEN_GUI_H

////////////////////////////////////////////////////////////////////////////////
// Includes.
////////////////////////////////////////////////////////////////////////////////
#include <vector>
#include <algorithm>
#include <tcl/tcl.h>
#include <tk/tk.h>
#include <tix/tix.h>
#include <utd/base.h>
#include <utd/baseobj.h>
#include <gui/gui.h>
#include <gui/colors.h>
////////////////////////////////////////////////////////////////////////////////
// Defines.
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Forward declarations.
////////////////////////////////////////////////////////////////////////////////

using namespace std;


namespace UTDGui {
  class Gui {
    protected:
	    
    public:
	Gui();
	~Gui();
	bool Init( int argc,char *argv[],const char *script,
	           Tcl_Interp *interp, 
		   UTDGUI_OPTS_T options,
		   void (*refresh_func)(UTDTILERECTPTR,void *), 
		   void *clientData,
		   FILE *did_file,
		   int parasite_windowId ) ;
	void Run( void ) ;

	/* Set the default drawing frame to the given coordinates.  Scale and
	 * precision is provide to make database units easier to manipulate.
	 */
	void setFrame( DOUBLE left,DOUBLE bottom,DOUBLE right,DOUBLE top,
		       DOUBLE scale, INT precision ) ;

	/* start a new slate */
	void startFrame(void) ;

	/* flush the current frame to the display */
	void flushFrame(void) ;

	/* draw a one pixel tall line segment from x1,y1 to x2,y2 */
	void drawLine(DOUBLE x1,DOUBLE y1,DOUBLE x2,DOUBLE y2,INT color,const char *label) ;

	/* -----------------------------------------------------------------
	 * Draw a rectangle whose diagonals are (x1,y1) and (x2,y2)
	*  if the specified color is default or invalid, use default color.
	 * A border will be draw around the cell if specified black (default).
	----------------------------------------------------------------- */
	void drawRect(DOUBLE x1,DOUBLE y1,DOUBLE x2,DOUBLE y2,INT color,const char *label) ;

	const char * _ExecTcl( const char *command, INT *status, MSG_TYPE_T mtype ) ;
	const char * ExecTcl( const char *command, INT *status ) ;

	void CheckTclCode(Tcl_Interp *interp, INT code, const char *label,const char *routine) ;

    private:
      struct graphics_context *gc ;

  } ;

} ;



#endif //INCLUDED_OPEN_GUI_H 
