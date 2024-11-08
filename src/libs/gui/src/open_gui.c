/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    open_gui.c                                       
DESCRIPTION:Top level graphical user interface calling Tix/Tk/Tcl
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#include "config.h"
#include <tcl/tcl.h>
#include <tk/tk.h>
#include <tk/tknew.h>
#include <tix/tix.h>
#include <blt/blt.h>
#include "open_gui.extra.h"
#include <utd/base.h>
#include <utd/debug.h>
#include <utd/dstring.h>
#include <utd/string.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/program.h>
#include <utd/system.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <X11/cursorfont.h>
#include <gui/colors.h>
#include <gui/gui.h>
#include "gc.h"
#include "open_gui_int.h"

/* ********************** TYPE DEFINITIONS ************************* */
#define GUI_GRAPHICS_ENVIRONMENT        "utdtools"
#define GUI_GRAPPHICS_INIT_DIR          "utdtools"


/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static void utd_refresh_func(VOIDPTR data) ;
static void stdinProc( ClientData clientData, int mask) ;
static void prompt( Tcl_Interp *interp,InteractiveState *isPtr) ;
static int my_x_error( Display *display, XErrorEvent *event) ;
static void check_reconfig( ClientData clientData, XEvent *xevent ) ;
static void check_main_reconfig( ClientData clientData, XEvent *xevent ) ;
static void graphics_exit_func(void) ;
static void update_events(INT flags) ;
static void graphics_exit(ClientData data) ;
static void scrollbar_update( struct TkCanvas *canvasData ) ;
static void init_parasite( GraphicsContextPtr gc_p ) ;
static void wait_for_main( GraphicsContextPtr gc_p ) ;
static void free_gc( GraphicsContextPtr gc_p ) ;
static void setup_X( Tcl_Interp *interp, GraphicsContextPtr gc_p ) ;
static void cleanup_x( GraphicsContextPtr gc_p, 
                       void (*refresh_func)(UTDTILERECTPTR,void *) ) ;
static void gsetfont( GraphicsContextPtr gc_p, const char *fname ) ;
static void _gfont_bound( GraphicsContextPtr gc_p, INT *width_ret, INT *height_ret )  ;
static XFontStruct *_gsetFont( GraphicsContextPtr gc_p, const char *fname,Font *font ) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static Tk_ArgvInfo argTableS[] = {
    {"-geometry", TK_ARGV_STRING, (char *) NULL, (char *) NULL,
	"Initial geometry for window"},
    {"-display", TK_ARGV_STRING, (char *) NULL, (char *) NULL,
	"Display to use"},
    {"-sync", TK_ARGV_CONSTANT, (char *) 1, (char *) NULL,
	"Use synchronous mode for display server"},
    {(char *) NULL, TK_ARGV_END, (char *) NULL, (char *) NULL,
	(char *) NULL}
};
static GraphicsContextPtr gcstatic_pS ;		/* persistent data */



BOOL utDGUI_init( int argc,char *argv[],const char *script_file,Tcl_Interp *interp,
		UTDGUI_OPTS_T options,
		void (*refresh_func)(UTDTILERECTPTR,void *),
		void *clientData,
		FILE *did_file,
		void (*user_init_func)(void *),
		INT parasite_windowId )
{

  Tcl_Obj *argvPtr, *appName;
  const char *encodingName;
  const char *error_p ;
  const char *init_path ;
  char *fullName ;
  char **pargv ;			/* copy of pargv */
  int code, nullStdin = 0;
  int status ;
  int pargc ;				/* copy of argc */
  BOOL graphics_flag ;			/* graphics requested */
  BOOL avoid_stdin_handler ;		/* avoid adding a stdin handler */
  Tcl_Channel chan;
  Tcl_DString buffer;
  UTDDSTRING dstring ;			/* dynamic string */
  InteractiveState *is_p ;		/* client data for Tcl interpreter */
  GraphicsContextPtr gc_p ;		/* local copy of graphics context */
  FUNC_NAME("utDGUI_init") ;

  DBG( fprintf( stderr, "entered utDGUI_init\n" ) ; ) ;
  Tcl_InitMemory(interp);

  graphics_flag = options & UTDGUI_OPT_GRAPHICS_T ;
  avoid_stdin_handler = options & UTDGUI_OPT_NO_STDIN_HANDLER_T ;

  is_p = UTDCALLOC( 1, InteractiveState ) ;
  is_p->interp = interp ;
  is_p->did_file = did_file ;
  Tcl_Preserve(interp);
  appName = NewNativeObj(argv[0], -1);

  /* Don't wipe out argc and argv */
  pargc = argc ;
  pargv = argv ;

  /*
   * Set the "tcl_interactive" variable.
   */

  is_p->tty = isatty(0);
#if defined(MAC_OSX_TK)
  /*
   * On TkAqua, if we don't have a TTY and stdin is a special character file
   * of length 0, (e.g. /dev/null, which is what Finder sets when double
   * clicking Wish) then use the GUI console.
   */

  if (!is.tty) {
      struct stat st;

      nullStdin = fstat(0, &st) || (S_ISCHR(st.st_mode) && !st.st_blocks);
  }
#endif
  Tcl_SetVar2Ex(interp, "tcl_interactive", NULL, Tcl_NewIntObj(is_p->tty), TCL_GLOBAL_ONLY);

  /*
   * Invoke application-specific initialization.
   */
  code = Tcl_Init(interp) ;
  if( code == TCL_ERROR) {
      utDGUIcheck_tcl_code(interp, code, "utDGUIinit:0", routine ) ;
      return( TRUE ) ;
  }
  code = Blt_BgExecInit(interp) ;
  if( code == TCL_ERROR) {
    utDGUIcheck_tcl_code(interp, code, "utDGUIinit:0b", routine ) ;
    return( TRUE ) ;
  }

  gcstatic_pS = UTDCALLOC(1, GraphicsContext ) ;
  gc_p = gcstatic_pS ;
  gc_p->borderColor = BLACK ; 	/* the default border color */
  gc_p->fillArb = TRUE ;   		/* whether to fill arbitrary figures */
  gc_p->rect_fill = TRUE ; 		/* whether to fill rectangle */
  gc_p->scaleFactor = 1.0 ;		/* scale data to screen dim.*/
  gc_p->scale = 1.0 ;			/* how the position counter is scaled */
  gc_p->timeout = GRAPHICS_TIMEOUT ;	/* default timeout */
  gc_p->delay_redraw = FALSE ;	/* whether to force a redraw delay */
  gc_p->wait_loop = TRUE ;		/* original start off in a wait */
  gc_p->graphics_enabled = graphics_flag ;
  /* 
   * At this point get the utdgui directory 
   */
  gc_p->utdgui = utDgetenv("UTDTOOLS") ;
  if(!(gc_p->utdgui)){
    utDmsg_syserr(MSE_EXIT,routine, "Can not get %s evironment variable.\n",
	"UTDTOOLS" ) ;
  }
  gc_p->utdversion = utDgetenv("UTDTOOLSVERSION") ;
  if(!(gc_p->utdversion)){
    utDmsg_syserr(MSE_EXIT,routine, "Can not get %s evironment variable.\n",
	"UTDTOOLSVERSION" ) ;
  }
  utDdstring_init( &dstring ) ;
  init_path = utDdstring_printf( &dstring, "%s/%s/tcl/%s/init.tcl", 
	     gc_p->utdgui, gc_p->utdversion, GUI_GRAPPHICS_INIT_DIR ) ;
  code = Tcl_EvalFile(interp, init_path);
  utDGUIcheck_tcl_code(interp, code, "utDGUIinit:1", routine ) ;
  utDdstring_free( &dstring ) ;

  gc_p->interp = interp ;
  gc_p->clientData = clientData ;
  gc_p->did_file = did_file ;
  gc_p->is_p = is_p ;

  DBG( fprintf( stderr, "utDGUI_init.  init.tcl evaluated.\n" ) ; ) ;

  /* -----------------------------------------------------------------
   * See if we need to process any data here.
   * ----------------------------------------------------------------- */
  if( argc > 0 && !(gc_p->read_args) ){
    /* Set up the variables to use C++ references */
    argTableS[0].dst = (char *) & gc_p->geometry_override ;
    argTableS[1].dst = (char *) & gc_p->display_override ;
/*
    argTableS[2].dst = this->sync ;
    */
    status = Tk_ParseArgv(interp,NULL, &argc, (const char **) argv, 
			  argTableS, 
			  TK_ARGV_NO_DEFAULTS|TK_ARGV_NO_ABBREV) ;
    if( status != TCL_OK ){
      utDmsgf(ERRMSG,"ginit:2", routine, Tcl_GetStringResult(interp)) ;
      utDprogram_exit(PGMFAIL) ;
    }
    gc_p->read_args = TRUE ;
  }
  add_gui_tcl_commands( gc_p->interp, gc_p ) ;
  if( user_init_func ){
    user_init_func( gc_p->interp ) ;
  }

  DBG( fprintf( stderr, "utDGUI_init. pw:%d graphics_flag:%d\n", parasite_windowId, graphics_flag ) ; ) ;
  if( graphics_flag ){

    if( parasite_windowId ){
      gc_p->parasite = TRUE ;
      Tk_ParasiteWindow( (Window) parasite_windowId ) ;
    } else {
      gc_p->parasite = FALSE ;
    }

    XSetErrorHandler( my_x_error ) ;

    code = Tk_Init(interp) ;
    if( code == TCL_ERROR) {
      utDGUIcheck_tcl_code(interp, code, "utDGUIinit:3", routine ) ;
      return(TRUE) ;
    }
    Tcl_StaticPackage(interp, "Tk",  Tk_Init,  (Tcl_PackageInitProc *) NULL);
    code = Tix_Init(interp) ;
    if( code == TCL_ERROR ) {
      utDGUIcheck_tcl_code(interp, code, "utDGUIinit:4", routine ) ;
      return( TRUE ) ;
    }
    Tcl_StaticPackage(interp, "Tix", Tix_Init, (Tcl_PackageInitProc *) NULL);

    if( !(utDfileExists(script_file)) ){
      utDmsgf(ERRMSG,"ginit:5",routine, "Could not open script file:%s\n", script_file ) ;
      utDprogram_exit(PGMFAIL) ;
    }

    /* Setup the X defaults */
    setup_X(interp,gc_p) ;

    /*
     * Invoke the script specified on the command line, if any. Must fetch it
     * again, as the appInitProc might have reset it.
     */

    fullName = Tcl_TranslateFileName(interp, script_file, &buffer);
    if ( fullName ) {
      code = Tcl_EvalFile(interp, fullName);
      utDGUIcheck_tcl_code(interp, code, "utDGUIinit:6", routine ) ;
    }
    DBG( fprintf( stderr, "utDGUI_init initial setup competed\n") ; ) ;
  }

  /* -----------------------------------------------------------------
   * Now safe to set the argument vector.
   * ----------------------------------------------------------------- */
  Tcl_SetVar2Ex(interp, "argv0", NULL, appName, TCL_GLOBAL_ONLY);
  pargc--;
  pargv++;

  Tcl_SetVar2Ex(interp, "argc", NULL, Tcl_NewIntObj(argc), TCL_GLOBAL_ONLY);

  argvPtr = Tcl_NewListObj(0, NULL);
  while (pargc--) {
      Tcl_ListObjAppendElement(NULL, argvPtr, NewNativeObj(*pargv++, -1));
  }
  Tcl_SetVar2Ex(interp, "argv", NULL, argvPtr, TCL_GLOBAL_ONLY);

  if(!(avoid_stdin_handler)){
    /*
     * Establish a channel handler for stdin.
     */

    is_p->input = Tcl_GetStdChannel(TCL_STDIN);
    if (is_p->input) {
	Tcl_CreateChannelHandler(is_p->input, TCL_READABLE, stdinProc, is_p) ;
    }
    if (is_p->tty) {
	prompt(interp, is_p) ;
    }

    chan = Tcl_GetStdChannel(TCL_STDOUT);
    if (chan) {
	Tcl_Flush(chan);
    }
    Tcl_DStringInit( &(is_p->command) );
    Tcl_DStringInit( &(is_p->line) );
    Tcl_ResetResult(interp);
  }

  if( graphics_flag ){
    wait_for_main(gc_p) ;

    if( gc_p->parasite ){
      init_parasite( gc_p ) ;
    }

    /* initialize colors and/or stipple patterns */
    utDGUIinitcolors( gc_p ) ;

    /* Now finish up initialization */
    cleanup_x( gc_p, refresh_func ) ;

  }

  return( FALSE ) ;

} /* end utDGUI_init() */

void utDGUI_run( void ) 
{

  GraphicsContextPtr gc_p = gcstatic_pS ;
  if(!(gc_p)){
    return ;
  }

  if( gc_p->interp ) {
    // gc_p->wait_loop = gcheck_wait_state(i_p) ; // need to implement.
    gc_p->wait_loop = TRUE ;
    while( gc_p->wait_loop ){
      Tcl_DoOneEvent(TCL_ALL_EVENTS | TCL_SERVICED_EVENT ) ;
    }
    gc_p->wait_loop = TRUE ;	// guarantee a wait for any related call
  }
} /* end utDGUI_run() */

void utDGUIcloseGraphics(void)
{
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p->init )){
	DBG( fprintf(stderr,"ERROR[closeGraphics]:initialization was not" ) ; )
	DBG( fprintf(stderr,"performed\n  before calling closeGraphics\n" ) ; )
	return ;
    }

    /* check to see if other files are open */
    if( gc_p->displayOpen ){
	DBG( fprintf( stderr, "before pending\n" ) ; ) ;
	DBG( fprintf( stderr, "%d X events pending\n", XPending(gc_p->dpy) ) ; ) ;
	DBG( fprintf( stderr, "before sync\n" ) ; ) ;
	XSynchronize(gc_p->dpy,True) ;
	XSync(gc_p->dpy,True) ;
	DBG( fprintf( stderr, "after sync\n" ) ; ) ;
	utDGUIsaveState() ;
	DBG( fprintf( stderr, "after save\n" ) ; ) ;
	update_events(TK_DONT_WAIT) ;
	DBG( fprintf( stderr, "after update\n" ) ; ) ;
	if( gc_p->fontinfo ){
	  XFreeFont( gc_p->dpy, gc_p->fontinfo ) ;
	}
	XCloseDisplay( gc_p->dpy ) ;
	DBG( fprintf( stderr, "display closed\n" ) ; ) ;
	gc_p->displayOpen = FALSE ;
	gc_p->dpy = NULL ;
    }
    free_gc(gc_p) ;
    gcstatic_pS = NULL ;

} /* end utDGUIcloseGraphics() */

INT utDGUIabort_graphics(INT status)
{
    INT code ;					/* return status */
    INT exit_status ;				/* return exit status */
    Tcl_Interp *interp ;			/* tcl interpreter */
    const char *result_p ;			/* result from command */
    char *utdtoolsdir ;				/* UTDTOOLS root directory */
    char *utdversion ;				/* UTDTOOLS version */
    char filename[LRECL] ;			/* file for exit func */
    GraphicsContextPtr gc_p ;			/* graphics information */

    DBG( fprintf(stderr,"entered utDGUIabort_graphics. status:%d\n", status ) ; ) ;

    exit_status = PGMOK ;
    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(exit_status) ;
    }
    if( status == PGMGABORT ){
      if( gc_p->waiting_for_parasite ){
	return(PGMGCANCEL) ; /* only allow the parasite or top level to answer */
      }
      if(!(Tk_XBusy(TK_BUSY_GET))){
	utdtoolsdir = utDgetenv("UTDTOOLS") ;
	utdversion = utDgetenv("UTDTOOLSVERSION") ;
	sprintf( filename, "%s/%s/tcl/gui/exit.tcl", utdtoolsdir, utdversion ) ;
	interp = gc_p->interp ;
	if( interp ){
	  DBG( fprintf(stderr,"utDGUIabort_graphics:%s\n", utDprogram_getName() ) ; ) ;
	  code = Tcl_EvalFile(interp, filename );
	  result_p = Tcl_GetStringResult( interp ) ;
	  if (code == TCL_OK) {
	    if( *result_p ){
	      DBG( fprintf( stderr, "utDabort_graphics return code:%s\n", 
		result_p ) ; ) ;
	      if( strcmp( result_p, "Continue" ) == STRINGEQ ){
		update_events(TK_DONT_WAIT) ;
		return(PGMGCANCEL) ;
	      } else if( strcmp( result_p, "ExitAll" ) == STRINGEQ ){
		exit_status = PGMGABORTALL ;
	      }
	    }
	  }
	}
      } else { /* Tk_XBusy()... */
	DBG( fprintf( stderr, "scheduling idle task\n" ) ; ) ;
	Tk_DoWhenIdle( graphics_exit, NULL ) ;
	return(PGMGCANCEL) ;
      }
    }
    utDmsg_func_delete_type(MESSAGE_GRAPHICS_T) ;
    utDGUIcloseGraphics() ;
    return(exit_status) ;
} /* end utDGUIabort_graphics() */


static void graphics_exit_func(void)
{
    GraphicsContextPtr gc_p ;			/* graphics information */

    update_events(TK_DONT_WAIT) ;
    utDmsg_func_delete_type(MESSAGE_GRAPHICS_T) ;
    gc_p = utDGUI_get_gc() ;
    if( gc_p ){
      Tix_ExitCleanup( gc_p->interp ) ;
      free_gc(gc_p) ;
      gcstatic_pS = NULL ;
    }
} /* end graphics_exit_func() */

/* -----------------------------------------------------------------
 * The problem with closing graphics is that you may interupt an X routine.
 * When you return things may be a mess and the program does not continue.
 * You need to check whether X is busy to make sure you don't have a conflict.
 * This routine is an idle callback to avoid problems.
----------------------------------------------------------------- */
static void graphics_exit(ClientData data)
{
    INT code ;					/* return status */
    BOOL exit_pgm ;				/* true if we need to exit */
    Tcl_Interp *interp ;			/* tcl interpreter */
    const char *result_p ;			/* result from command */
    char *utdtoolsdir ;				/* UTDTOOLS root directory */
    char *utdversion ;				/* UTDTOOLS version */
    char filename[LRECL] ;			/* file for exit func */
    GraphicsContextPtr gc_p ;			/* graphics information */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }
    utdtoolsdir = utDgetenv("UTDTOOLS") ;
    utdversion = utDgetenv("UTDTOOLSVERSION") ;
    sprintf( filename, "%s/%s/tcl/gui/exit.tcl", utdtoolsdir, utdversion ) ;
    interp = gc_p->interp ;
    exit_pgm = TRUE ;
    if( interp ){
      DBG( fprintf( stderr, "graphics exit\n" ) ; ) ;
      code = Tcl_EvalFile(interp, filename );
      if (code == TCL_OK) {
	result_p = Tcl_GetStringResult( interp ) ;
	if( *result_p ){
	  DBG( fprintf( stderr, "graphics exit return code:%s\n", 
	    result_p ) ; ) ;
	  if( strcmp( result_p, "Continue" ) == STRINGEQ ){
	    exit_pgm = FALSE ;
	  }
	}
      }
    }
    update_events(TK_DONT_WAIT) ;
    if( exit_pgm ){
      utDmsg_func_delete_type(MESSAGE_GRAPHICS_T) ;
      utDGUIcloseGraphics() ;
      utDprogram_exit(PGMOK) ;
    }
    Tk_CancelIdleCall( graphics_exit, NULL ) ;
} /* end graphics_exit() */

static void setup_X( Tcl_Interp *interp, GraphicsContextPtr gc_p ) {
  INT m ;			/* mask for determining window position*/
  INT code ;			/* status code */
  INT depth;			/* depth of display */
  char *font ;			/* user font request */
  char *reply ;			/* get xdefaults */
  char *geometry ; 		/* position of Xdefault window */
  FUNC_NAME("setup_X") ;

  gc_p->mainWindow = Tk_MainWindow(interp) ;
  if (!(gc_p->mainWindow)){
    utDmsg_syserr(MSE_EXIT,routine, "Can not create main window.\n" ) ;
  }
  gc_p->dpy = Tk_Display(gc_p->mainWindow) ;

  /* get various information about display */
  gc_p->screen = DefaultScreen(gc_p->dpy);
  depth = DefaultDepth(gc_p->dpy,gc_p->screen);

  /* -----------------------------------------------------------------
   * Parse the geometry structure and set initial position.
   * Highest priority is the geometry gc_p->override.
   * Next highest priority is the geometry given on the command line.
   * Finally look for the .Xdefaults resource.
  ----------------------------------------------------------------- */
  geometry = NULL ;
  if( gc_p->geometry_override ){
    geometry = gc_p->geometry_override ;
  } else {
    geometry = XGetDefault( gc_p->dpy, GRAPHICS, "geometry" ) ;
  }
  if( geometry && !(gc_p->parasite) ){
    m = XParseGeometry( geometry,&gc_p->winx,&gc_p->winy,&gc_p->winwidth,&gc_p->winheight);
    if( m & XNegative ){
      gc_p->winx = XDisplayWidth( gc_p->dpy, gc_p->screen ) + gc_p->winx ;
    }
    if( m & YNegative ){
      gc_p->winy = XDisplayHeight( gc_p->dpy, gc_p->screen ) + gc_p->winy ;
    }
    /* these two lines insure that uses doesn't have to press */
    /* button using twm window manager */
    if( gc_p->winx == 0 ) gc_p->winx++ ;
    if( gc_p->winy == 0 ) gc_p->winy++ ;
    if ( geometry ) {
      Tcl_SetVar(interp, "geometry", geometry, TCL_GLOBAL_ONLY) ;
    }
  } else {
    gc_p->winwidth = INT_WIDTH;
    gc_p->winheight = INT_HEIGHT;
    gc_p->winx = INT_X;
    gc_p->winy = INT_Y;
  }
  /* end initializing position of window */

  /* -----------------------------------------------------------------
   * Enable synchronization if requested.
  ----------------------------------------------------------------- */
  if((reply = XGetDefault( gc_p->dpy, GRAPHICS, "sync" ))){
    if( strcmp( reply, "on" ) == STRINGEQ ){
      XSynchronize( gc_p->dpy,True) ;
    } 
  }
  if( gc_p->sync ){
    XSynchronize( gc_p->dpy,True) ;
  }

  /* -----------------------------------------------------------------
   Now set earlier in the flow.
  XSetErrorHandler( my_x_error ) ;
  ----------------------------------------------------------------- */

  /* check whether machine is color or not */
  gc_p->color = XDisplayCells( gc_p->dpy, gc_p->screen ) ;
  if( gc_p->color  > 2 ){ 
    /* if color number of display cells > 0 */
    gc_p->color = TRUE ;
    reply = XGetDefault( gc_p->dpy, GRAPHICS, "bw") ;
    if( reply ){
      if( strcmp( reply, "on" ) == STRINGEQ ){
	gc_p->color = FALSE ;
      }
    }
  } else {
    gc_p->color = FALSE ;
  }

  /* set font and get font info */
  font = XGetDefault( gc_p->dpy, GRAPHICS, "font" ) ;
  if( font ){
    gc_p->fontinfo = _gsetFont( gc_p, font, &gc_p->font ) ;
  } else {
    /* we perfer our default to be 9x15 */
    gc_p->fontinfo = _gsetFont( gc_p, "9x15", &gc_p->font ) ;
    if(!(gc_p->fontinfo )){
      gc_p->fontinfo = _gsetFont( gc_p, "fixed", &gc_p->font ) ;
    }
  }
  /* see if we should turn on/off the rectangular fill */
  reply = XGetDefault( gc_p->dpy, GRAPHICS, "rectangle_fill" ) ;
  if( reply ){
    if( strcmp( reply, "off" ) == STRINGEQ ){
      gc_p->rect_fill = FALSE ; /* dont fill rectangles - default on */
    } 
  }
  /* see if we should turn on/off the arbitrary fill */
  reply = XGetDefault( gc_p->dpy, GRAPHICS, "arbitrary_fill") ;
  if( reply ){
    if( strcmp( reply, "off" ) == STRINGEQ ){
      gc_p->fillArb = FALSE ; /* dont fill arbs - default on */
    } 
  }
  /* see if we should turn off the reverse video */
  reply = XGetDefault( gc_p->dpy, GRAPHICS, "reverse" ) ;
  if( reply ){
    if( strcmp( reply, "on" ) == STRINGEQ ){
      gc_p->reverse = TRUE ;
    }
  }

  /* see if we should turn off the reverse video */
  reply = XGetDefault( gc_p->dpy, GRAPHICS, "background" ) ;
  if( reply ){
    gc_p->background_color_name = utDstrclone(reply) ;
  }


  reply = XGetDefault( gc_p->dpy, GRAPHICS, "timeout" ) ;
  if( reply ){
    gc_p->timeout = atoi( reply ) ;
    if( gc_p->timeout <= 0 ){
      gc_p->timeout = 5 ; /* minimum timeout */
    }
  }

  /*
   * Set the geometry of the main window, if requested.
   */
  if( geometry && !(gc_p->parasite) ){
    code = Tcl_VarEval(interp, "wm geometry .\n", geometry, NULL) ;
    utDGUIcheck_tcl_code(interp, code, "Gui::setup_X:1",routine) ;
  }

} /* end Gui::setup_X() */

static void wait_for_main( GraphicsContextPtr gc_p ) 
{
  INT trys ;			/* number of trys */
  INT code ;			/* return code */
  INT timeout ;			/* time for waiting */
  Tk_Window drawWindow ;	/* draw window */
  const char *canvas_widget ; 	/* canvas widget name */
  Tcl_Interp *interp ;		/* Tcl Interpreter */
  FUNC_NAME("Gui::wait_for_main" ) ;
  /* -------------------------------------------------------------
     Now wait to window to become visible.  Call update to execute
     all of the X code.
  -------------------------------------------------------------- */
  trys = 0 ;
  timeout = gc_p->timeout ;
  interp = gc_p->interp ;
  do {

    update_events(TK_DONT_WAIT) ;
    XSync( gc_p->dpy, False ) ;

    /* -------------------------------------------------------------
       Find the drawing window.
    -------------------------------------------------------------- */
    code = Tcl_GlobalEval( interp, "set utdsymbolicNameG(utdcanvas)\n") ;
    canvas_widget = Tcl_GetStringResult(interp) ;
    if( !(canvas_widget)){
      DBG( fprintf( stderr, "no canvas widget defined\n" ) ; ) ;
      return ;
    }
    utDGUIcheck_tcl_code(interp, code, "Gui::wait_for_main:1",routine) ;
    if (code != TCL_OK) {
      DBG( fprintf( stderr, "code failed\n" ) ; ) ;
      return ;
    } else if( utDstricmp( canvas_widget, "UTDNONE" ) == STRINGEQ ){
      DBG( fprintf( stderr, "canvas widget = UTDNONE\n" ) ; ) ;
      gc_p->displayOpen = TRUE; /* display is open for business */
      gc_p->init = TRUE ;
      return ; /* Nothing more to do with a null window */
    }
    drawWindow = Tk_NameToWindow( interp, canvas_widget, gc_p->mainWindow ) ;
    if( drawWindow ){
      gc_p->draw = Tk_WindowId(drawWindow) ;
      gc_p->drawWindow = drawWindow ;
    } 
    if( ++trys >= gc_p->timeout ){
      utDmsgf( ERRMSG, "Gui::wait_for_main:2", routine, "Cannot find window for symbolic name:%s\n",
	canvas_widget ) ;
      return ;
    } else if( gc_p->draw == 0 && trys > 10 ){
      utDmsgf(IMSG,"Gui::wait_for_main:3",routine,
	"waiting for graphics until timeout=%d seconds...\n", timeout-- ) ;
      utDsleep(1) ;
    }
  } while( gc_p->draw == 0 ) ;

  gc_p->main = Tk_WindowId(gc_p->mainWindow) ;
  // menu_input( FALSE ) ;
} /* end wait_for_main() */

static void cleanup_x( GraphicsContextPtr gc_p, void (*refresh_func)(UTDTILERECTPTR,void *) ) {

  void *canvas_p ;			/* canvas info */
  XWindowAttributes wattr;  		/* get window attributes */
  const char *position_widget ;		/* name of position widget */
  INT code ;				/* return code from Tcl */
  FUNC_NAME("cleanup_x") ;

  DBG( fprintf( stderr, "utDGUI_init entered cleanup_x\n") ; ) ;
  if(!(gc_p->drawWindow)){
    if( gc_p->mainWindow ){
      gc_p->displayOpen = TRUE; /* display is open for business */
      gc_p->init = TRUE ;
      gc_p->ready = TRUE ;
    }
    return ; /* can't do anything */
  }
  /* if the window manager added border around window we */
  /* need to save new origin of window */
  /* also if user changed size we need to get it */
  XGetWindowAttributes( gc_p->dpy, gc_p->draw, &wattr ) ;
  gc_p->winx = wattr.x ;
  gc_p->winy = wattr.y ;
  gc_p->winwidth = wattr.width ;
  gc_p->winheight = wattr.height ;
  /* default user data boarder to size of window */
  gc_p->fullArea.UTDLLX = 0 ;
  gc_p->fullArea.UTDLLY = 0 ;
  gc_p->fullArea.UTDURX = gc_p->winwidth ;
  gc_p->fullArea.UTDURY = gc_p->winheight ;
  gc_p->fullView = TRUE ; 

  gc_p->pixmap = XCreatePixmap( gc_p->dpy, gc_p->draw, gc_p->winwidth, gc_p->winheight, 
      Tk_Depth( gc_p->drawWindow) ) ;
  gc_p->blit_pixmap = XCreatePixmap( gc_p->dpy, gc_p->draw, gc_p->winwidth, gc_p->winheight, 
      Tk_Depth( gc_p->drawWindow) ) ;
  // Tk_CreateForcedEventHandler( gc_p->drawWindow, 
  //  StructureNotifyMask | SubstructureNotifyMask, check_reconfig, gc_p ) ;
  Tk_CreateEventHandler( gc_p->drawWindow, 
                         StructureNotifyMask | SubstructureNotifyMask, check_reconfig, gc_p ) ;
  /* initialize the pixmap */
  XFillRectangle(gc_p->dpy,DRAWABLE,gc_p->graphicContext[UTDWHITE],0,0,gc_p->winwidth,gc_p->winheight);

  /* create the cursors */
  gc_p->xterm_cursor = XCreateFontCursor( gc_p->dpy, XC_left_ptr ) ;
  gc_p->watch_cursor = XCreateFontCursor( gc_p->dpy, XC_watch ) ;

  XFlush( gc_p->dpy ) ;

  /* -------------------------------------------------------------
   * Find the position widget if it exists.
  -------------------------------------------------------------- */
  code = Tcl_GlobalEval( gc_p->interp, "set utdsymbolicNameG(utdposition)\n") ;
  position_widget = Tcl_GetStringResult(gc_p->interp) ;
  if( position_widget ){
    utDGUIcheck_tcl_code(gc_p->interp, code, "Gui::cleanup_x:1",routine) ;
    if (code == TCL_OK) {
      gc_p->utdposition = utDstrclone( position_widget ) ;
    }
  }

  /* initialization has been done sucessfully */
  gc_p->displayOpen = TRUE; /* display is open for business */
  gc_p->init = TRUE ;
  gc_p->ready = TRUE ;
  DBG( fprintf( stderr, "display is open for business\n" ) ; ) ;

  /* save the refresh function */
  if( refresh_func ){
    gc_p->refresh_func = refresh_func ;
    canvas_p = Tk_CanvasDispFunc( utd_refresh_func ) ;
    gc_p->canvas = (TkCanvas *) canvas_p ;
    Tk_CanvasScrollbarFunc( scrollbar_update ) ;
  }
  TkinstallUserExit( graphics_exit_func ) ;

  /* -----------------------------------------------------------------
   * Now source any user initialization file.
  ----------------------------------------------------------------- */
  //if( user_initialization(gc_p->interp) ){
//	update_events(TK_DONT_WAIT) ;
//     }

} /* end cleanup_x() */

BOOL utDGUIready_func(INT flag)
{
    GraphicsContextPtr gc_p ;			/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if( gc_p ){
      if( flag >= 0 ){
	gc_p->ready = flag ;    
      }
      return(gc_p->ready) ;    
    }
    return(FALSE) ;
} /* end utDGUIready_func() */




static XFontStruct *_gsetFont( GraphicsContextPtr gc_p, const char *fname, Font *font )
{
    XFontStruct *fontinfo ;
    FUNC_NAME("_gsetFont") ;

    /* set font and get font info */
    /* this is a safe test to see if font exists */
    fontinfo = XLoadQueryFont( gc_p->dpy, fname ) ;

    if(!(fontinfo)){
      utDmsgf( WARNMSG|MSG_GRAPHICS,"_ORsetFont:1", routine, 
	  "font:%s not available - using default:fixed\n", fname ) ;
      fontinfo = XLoadQueryFont( gc_p->dpy, "fixed" ) ;
    }
    *font = fontinfo->fid ;
    return( fontinfo ) ;
} /* end _ORsetFont() */

static void gsetfont( GraphicsContextPtr gc_p, const char *fname )
{
    INT i ;			/* color counter */

    gc_p->fontinfo = _gsetFont( gc_p, fname, &(gc_p->font) ) ;
    for( i = 0; i <= gc_p->numColor; i++ ){
	XSetFont( gc_p->dpy, gc_p->graphicContext[i], gc_p->font ) ;
    }
} /* end ORsetfont() */

static void _gfont_bound( GraphicsContextPtr gc_p, INT *width_ret, INT *height_ret ) 
{
    *width_ret = gc_p->fontinfo->max_bounds.rbearing - gc_p->fontinfo->min_bounds.lbearing ;
    *height_ret = gc_p->fontinfo->ascent + gc_p->fontinfo->descent ;
} /* end _gfont_bound() */

static void init_parasite( GraphicsContextPtr gc_p )
{
    Tk_UpdateObjCmd(gc_p->mainWindow,gc_p->interp,1,NULL) ;
    TkWmParasiteConfigNotify(gc_p->mainWindow) ;
    Tk_UpdateObjCmd(gc_p->mainWindow,gc_p->interp,1,NULL) ;
    Tk_CreateEventHandler( gc_p->mainWindow, 
      StructureNotifyMask | SubstructureNotifyMask, check_main_reconfig, gc_p ) ;
} /* end init_parasite() */

static void check_main_reconfig( ClientData clientData, XEvent *xevent )
{
    GraphicsContextPtr gc_p ;		/* graphics context info */

    gc_p = (GraphicsContextPtr) clientData ;
    if( xevent->type != ConfigureNotify ){
      return ; /* ignore this event */
    } else {
      if( xevent->xany.send_event == 1 && gc_p ){
	/*
	fprintf( stderr,"main configure notify win:%d.\n",
	    xevent->xconfigure.window) ;
	fprintf( stderr, "got window - calling ConfigNotify\n") ;
	*/
	Tk_ParasiteRestore(gc_p->mainWindow) ;
	TkWmParasiteConfigNotify(gc_p->mainWindow) ;
	Tk_UpdateObjCmd(gc_p->mainWindow,gc_p->interp,1,NULL) ;
	gc_p->delay_redraw = TRUE ;
      }
    }
} /* end check_main_reconfig() */


/*
 *----------------------------------------------------------------------
 *
 * stdinProc --
 *
 *	This function is invoked by the event dispatcher whenever standard
 *	input becomes readable. It grabs the next line of input characters,
 *	adds them to a command being assembled, and executes the command if
 *	it's complete.
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	Could be almost arbitrary, depending on the command that's typed.
 *
 *----------------------------------------------------------------------
 */

    /* ARGSUSED */
static 
void stdinProc(
    ClientData clientData,	/* The state of interactive cmd line */
    int mask)			/* Not used. */
{
    char *cmd;
    char *result;
    int code, count;
    InteractiveState *isPtr = (InteractiveState *) clientData;
    Tcl_Channel chan = isPtr->input;
    Tcl_Interp *interp = isPtr->interp;

    count = Tcl_Gets(chan, &isPtr->line);

    if (count < 0 && !isPtr->gotPartial) {
	if (isPtr->tty) {
	    Tcl_Exit(0);
	} else {
	    Tcl_DeleteChannelHandler(chan, stdinProc, isPtr);
	}
	return;
    }

    Tcl_DStringAppend(&isPtr->command, Tcl_DStringValue(&isPtr->line), -1);
    cmd = Tcl_DStringAppend(&isPtr->command, "\n", -1);
    Tcl_DStringFree(&isPtr->line);
    if (!Tcl_CommandComplete(cmd)) {
	isPtr->gotPartial = 1;
	goto prompt;
    }
    isPtr->gotPartial = 0;

    /*
     * Disable the stdin channel handler while evaluating the command;
     * otherwise if the command re-enters the event loop we might process
     * commands from stdin before the current command is finished. Among other
     * things, this will trash the text of the command being evaluated.
     */

    Tcl_CreateChannelHandler(chan, 0, stdinProc, isPtr);
    if( isPtr->did_file ){
      fprintf( isPtr->did_file, "%s\n", cmd ) ;
      fflush( isPtr->did_file ) ;
    }
    if( isPtr->echo_cmds ){
      fprintf( stdout, "%s\n", cmd ) ;
      fflush( stdout ) ;
    }
    code = Tcl_RecordAndEval(interp, cmd, TCL_EVAL_GLOBAL);

    isPtr->input = Tcl_GetStdChannel(TCL_STDIN);
    if (isPtr->input) {
	Tcl_CreateChannelHandler(isPtr->input, TCL_READABLE, stdinProc, isPtr);
    }
    Tcl_DStringFree(&isPtr->command);
    result = Tcl_GetString(Tcl_GetObjResult(interp)) ;
    if (result[0] != '\0') {
	if( isPtr->did_file ){
	  fprintf( isPtr->did_file, "# %s\n", result ) ;
	  fflush( isPtr->did_file ) ;
	}
	if( isPtr->stdout_only ){
	  if( isPtr->tty ){
	    chan = Tcl_GetStdChannel((code != TCL_OK) ? TCL_STDERR : TCL_STDOUT);
	    if (chan) {
		Tcl_WriteObj(chan, Tcl_GetObjResult(interp));
		Tcl_WriteChars(chan, "\n", 1);
	    }
	  } else {
	    fprintf( stdout, "%s\n", result) ;
	  }
	} else {
	  utDmsgf( MSG | MSG_AVOID_DIDFILE, MSG_AT, NULL, "%s\n", result) ;
	}
    }

    /*
     * If a tty stdin is still around, output a prompt.
     */

  prompt:
    if (isPtr->tty && (isPtr->input != NULL)) {
	prompt(interp, isPtr);
    }
    Tcl_ResetResult(interp);
}

/*
 *----------------------------------------------------------------------
 *
 * prompt --
 *
 *	Issue a prompt on standard output, or invoke a script to issue the
 *	prompt.
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	A prompt gets output, and a Tcl script may be evaluated in interp.
 *
 *----------------------------------------------------------------------
 */

static void
prompt(
    Tcl_Interp *interp,		/* Interpreter to use for prompting. */
    InteractiveState *isPtr) /* InteractiveState. */
{
    Tcl_Obj *promptCmdPtr;
    int code;
    Tcl_Channel chan;

    promptCmdPtr = Tcl_GetVar2Ex(interp,
	isPtr->gotPartial ? "tcl_prompt2" : "tcl_prompt1", NULL, TCL_GLOBAL_ONLY);
    if (promptCmdPtr == NULL) {
    defaultPrompt:
	if (!isPtr->gotPartial) {
	    chan = Tcl_GetStdChannel(TCL_STDOUT);
	    if (chan != NULL) {
		Tcl_WriteChars(chan, DEFAULT_PRIMARY_PROMPT,
			strlen(DEFAULT_PRIMARY_PROMPT));
	    }
	}
    } else {
	code = Tcl_EvalObjEx(interp, promptCmdPtr, TCL_EVAL_GLOBAL);
	if (code != TCL_OK) {
	    Tcl_AddErrorInfo(interp,
		    "\n    (script that generates prompt)");
	    if (Tcl_GetString(Tcl_GetObjResult(interp))[0] != '\0') {
		chan = Tcl_GetStdChannel(TCL_STDERR);
		if (chan != NULL) {
		    Tcl_WriteObj(chan, Tcl_GetObjResult(interp));
		    Tcl_WriteChars(chan, "\n", 1);
		}
	    }
	    goto defaultPrompt;
	}
    }

    chan = Tcl_GetStdChannel(TCL_STDOUT);
    if (chan != NULL) {
	Tcl_Flush(chan);
    }
}

static int my_x_error( Display *display, XErrorEvent *event) {
  char *pgmName ;
  char buffer[LRECL] ;

  pgmName = utDprogram_getName() ;
  if( pgmName ){
    fprintf( stderr, "Detected an X Error in program %s:\n", pgmName ) ;
  } else {
    fprintf( stderr, "Detected an X Error:\n" ) ;
  }
  XGetErrorText( display, event->error_code, buffer, LRECL ) ; 
  fprintf( stderr, "  resource:%ld request:%d %s\n", event->resourceid, 
    event->request_code, buffer ) ;

  return(0) ;
} /* end my_x_error() */

static void utd_refresh_func(VOIDPTR data) {
  INT status ;			/* return status */
  TkCanvas *canvas_p ;		/* canvas info */
  char command[40] ;			/* build a a command */
  GraphicsContextPtr gc_p ;		/* graphics context pointer */

  canvas_p = (TkCanvas *) data ;
  gc_p = gcstatic_pS ;
  if(!(gc_p)){
    return ;
  }
  /*
  static INT countL ;
  fprintf( stderr, "count:%d\n", ++countL ) ;
  fprintf( stderr, "window (%d %d) (%d %d) force_flag:%d\n",
      canvas_p->redrawX1, canvas_p->redrawY1, 
      canvas_p->redrawX2, canvas_p->redrawY2, gc_p->force_redraw ) ;
  fprintf( stderr, "scroll (%d %d) (%d %d)\n",
      canvas_p->scrollX1, canvas_p->scrollY1, 
      canvas_p->scrollX2, canvas_p->scrollY2 ) ;
  */
  if( gc_p->ref_width == gc_p->winwidth && gc_p->ref_height==gc_p->winheight && !(gc_p->force_redraw) ){
#ifndef DIRECT_DRAW
    XCopyArea( gc_p->dpy, DRAWABLE, gc_p->draw, gc_p->background,
      0L, 0L, gc_p->winwidth, gc_p->winheight, 0L, 0L) ;
#endif /* DIRECT_DRAW */
    Tk_CanvasDispUpdate() ;
    return ;
  }
  /* -----------------------------------------------------------------
   * We are going to call the following to actually redraw the code.
   * proc queue_redraw { } 
   * variable redraw_idS
   * if {[info exists redraw_idS]} {
   *   after cancel $redraw_idS
   * }
   * set redraw_idS [after 1500 {otredraw} -force]
   * ----------------------------------------------------------------- */
  if( gc_p->delay_redraw ){
    strcpy( command, "::utdgui::queue_redraw" ) ;
    utDGUI_exec_tcl( command, &status ) ;
  } else {
    if( gc_p->fullView ){
      (*gc_p->refresh_func)( &gc_p->fullArea, gc_p->clientData ) ;
    } else {
      (*gc_p->refresh_func)( &gc_p->zoomArea, gc_p->clientData ) ;
    }
  }
  gc_p->force_redraw = FALSE ;

} /* end utd_refresh_func() */

static void scrollbar_update( struct TkCanvas *canvasData )
{
    int result;
    char buffer[200];
    Tcl_Interp *interp;
    char *xScrollCmd, *yScrollCmd;
    GraphicsContextPtr gc_p ;		/* graphics context pointer */
    TkCanvas *canvasPtr ;

    gc_p = gcstatic_pS ;
    if(!(gc_p)){
      return ;
    }
    canvasPtr = (TkCanvas *) canvasData ;
    /*
     * Save all the relevant values from the canvasPtr, because it might be
     * deleted as part of either of the two calls to Tcl_VarEval below.
     */
    
    interp = canvasPtr->interp;
    Tcl_Preserve((ClientData) interp);
    xScrollCmd = canvasPtr->xScrollCmd;
    if (xScrollCmd != (char *) NULL) {
	Tcl_Preserve((ClientData) xScrollCmd);
    }
    yScrollCmd = canvasPtr->yScrollCmd;
    if (yScrollCmd != (char *) NULL) {
	Tcl_Preserve((ClientData) yScrollCmd);
    }
    if (canvasPtr->xScrollCmd != NULL) {
      sprintf( buffer, "%g %g", gc_p->lbX, gc_p->ubX ) ;
      result = Tcl_VarEval(interp, xScrollCmd, " ", buffer, (char *) NULL);
      if (result != TCL_OK) {
	Tcl_BackgroundError(interp);
      }
      Tcl_ResetResult(interp);
      Tcl_Release((ClientData) xScrollCmd);
    }

    if (yScrollCmd != NULL) {
      sprintf( buffer, "%g %g", gc_p->lbY, gc_p->ubY ) ;
      result = Tcl_VarEval(interp, yScrollCmd, " ", buffer, (char *) NULL);
      if (result != TCL_OK) {
	  Tcl_BackgroundError(interp);
      }
      Tcl_ResetResult(interp);
      Tcl_Release((ClientData) yScrollCmd);
    }
    Tcl_Release((ClientData) interp);

} /* end scrollbar_update() */

/* -----------------------------------------------------------------
 * Exec Tcl with error checking.
 * ----------------------------------------------------------------- */
const char *utDGUI_exec_tcl( const char *command, INT *status )
{
    const char *ret_val ;

    ret_val = _utDGUI_exec_tcl( command, status, ERRMSG ) ;
    return( ret_val ) ;
} /* end g_exec_tcl() */

/* -----------------------------------------------------------------
 * Exec Tcl with error checking.
 * ----------------------------------------------------------------- */
const char *_utDGUI_exec_tcl( const char *command, INT *status, MSG_TYPE_T mtype )
{
    const char *result ;			/* result of command */
    const char *error_p ;		/* error message */
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = gcstatic_pS ;
    if(!(gc_p)){
      return(NULL) ;
    }
    *status = Tcl_Eval( gc_p->interp, command ) ;
    result = Tcl_GetStringResult(gc_p->interp) ;
    if( *status != TCL_OK ){
      error_p = Tcl_GetVar2( gc_p->interp, "errorInfo", NULL, TCL_GLOBAL_ONLY ) ;
      if( error_p ){
	utDmsgf( mtype, "_utDGUI_exec_tcl:1", NULL, "%s\n", error_p ) ;
      }
    }
    return( result ) ;
} /* end g_exec_tcl() */

/* update windows if configuration changes */
static void check_reconfig( ClientData clientData, XEvent *xevent )
{
  GraphicsContextPtr gc_p ;		/* graphics context pointer */

  if( xevent->type != ConfigureNotify ){
    return ; /* ignore this event */
  }

  gc_p = (GraphicsContextPtr) clientData ;
  if(!(gc_p)){
    return ;
  }
  if( xevent->xconfigure.window == gc_p->draw ){
    if( xevent->xconfigure.override_redirect ||
	xevent->xconfigure.type == MapNotify ||
	xevent->xconfigure.type == UnmapNotify ){
      /* window manager is telling us to leave it alone */
      return ;
    }
    if(gc_p->winheight != xevent->xconfigure.height || gc_p->winwidth != xevent->xconfigure.width){
      gc_p->winheight = xevent->xconfigure.height ;
      gc_p->winwidth = xevent->xconfigure.width ;
      XFreePixmap( gc_p->dpy, gc_p->pixmap ) ;
      XFreePixmap( gc_p->dpy, gc_p->blit_pixmap ) ;
      gc_p->pixmap = XCreatePixmap( gc_p->dpy, gc_p->draw, gc_p->winwidth, gc_p->winheight,
	XDefaultDepth(gc_p->dpy,gc_p->screen) ) ;
      gc_p->blit_pixmap = XCreatePixmap( gc_p->dpy, gc_p->draw, gc_p->winwidth, gc_p->winheight,
	XDefaultDepth(gc_p->dpy,gc_p->screen) ) ;
      XSync( gc_p->dpy, FALSE ) ; 
      gc_p->fullView = TRUE ;
      gc_p->delay_redraw = TRUE ;
      utDGUIsetFrame( gc_p->fullArea.UTDLLX, gc_p->fullArea.UTDLLY, 
		     gc_p->fullArea.UTDURX, gc_p->fullArea.UTDURY, 
		     gc_p->scale, gc_p->precision ) ;
    }
  }
} /* end check_reconfig() */

GraphicsContextPtr utDGUI_get_gc(void) {
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    return(gcstatic_pS) ;
} /* end utDGUI_get_gc() */

static void update_events(INT flags) {
    INT code ;			/* return code */
    GraphicsContextPtr gc_p ;	/* graphics context info */

    /* -----------------------------------------------------------------
     * Handle all pending events, and repeat over
     * and over again until all pending events have been handled.
     * This version is different than update command in that it does not
     * use XSync.
    ----------------------------------------------------------------- */
    gc_p = gcstatic_pS ;
    if(!(gc_p)){
      return ;
    }
    flags |= TCL_SERVICED_EVENT ;
    while(TRUE){
      do {
	code = Tcl_DoOneEvent(flags) ;
	if( code < 0 ){
	  flags = TK_DONT_WAIT ;
	}
      } while( code > 0 ) ;

      if( gc_p ){
	XSync( gc_p->dpy, False);
      }
      if( Tcl_DoOneEvent(TK_DONT_WAIT) == 0) {
	break ;
      }
    }
    /* -----------------------------------------------------------------
     * Must clear the interpreter's result because event handlers could
     * have executed commands.
    ----------------------------------------------------------------- */
    if( gc_p ){
      Tcl_ResetResult(gc_p->interp) ;
    }
} /* end update_events() */

/* -----------------------------------------------------------------
 * check to see mouse button was click.  If true put up appropriate 
 * menu and return value to user.  If wait is true, check mouse sits
 * in a select and waits to avoid chewing up execution time.
----------------------------------------------------------------- */
void utDGUIcheckMouse( BOOL wait)
{
    if( wait ){
      update_events(TK_ALL_EVENTS) ;
    } else {
      update_events(TK_DONT_WAIT) ;
    }
} /* end utDGUIcheckMouse() */

static void set_clip_window( GraphicsContextPtr gc_p,
    DOUBLE left, DOUBLE bottom, DOUBLE scaleFactor ) 
{
    DOUBLE new_width ;
    DOUBLE new_height ;

    gc_p->zoomArea.UTDLLX = left ; 
    gc_p->zoomArea.UTDLLY = bottom ;

    /* need to adjust right and top to the new scale */
    new_width = (DOUBLE) gc_p->winwidth / scaleFactor ;
    new_height =  (DOUBLE) gc_p->winheight / scaleFactor ;
    gc_p->zoomArea.UTDURX = left + floor(new_width) ; 
    gc_p->zoomArea.UTDURY = bottom + floor(new_height) ;
    /* fprintf( stderr, "clip mod (%d,%d) (%d,%d)\n", 
     * gc_p->l, gc_p->b, gc_p->r, gc_p->t ) ; */
} /* end set_clip_window() */ 

/* set the window area for bar */
void utDGUIsetFrame( DOUBLE left,DOUBLE bottom,DOUBLE right,DOUBLE top,
		    DOUBLE scale, INT precision ) 
{
    DOUBLE xspan, yspan ; 	/* span of data */
    DOUBLE xscaleF, yscaleF ;	/* scale data to window span */
    DOUBLE width ;		/* width of canvas */
    DOUBLE height ;		/* height of canvas */
    TkCanvas *canvas_p ;	/* current canvas */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */
    FUNC_NAME("utDUIsetFrame") ;

    gc_p = gcstatic_pS ;
    if(!(gc_p)){
      return ;
    }
    gc_p->scale = scale ;
    gc_p->precision = precision ;
    /* save what the user gave us in case we need to use it */
    /* for a reconfiguration request - ie, resize window */
    if( gc_p->fullView ){
	gc_p->fullArea.UTDLLX = gc_p->zoomArea.UTDLLX = left ; 
	gc_p->fullArea.UTDURX = gc_p->zoomArea.UTDURX = right ; 
	gc_p->fullArea.UTDLLY = gc_p->zoomArea.UTDLLY = bottom ; 
	gc_p->fullArea.UTDURY = gc_p->zoomArea.UTDURY = top ;
    }

    xspan = fabs( right - left ) ;
    if( FLOAT_EQ( xspan, 0.0 ) ){
      utDmsg(ERRMSG,"utdGsetFrame:1", routine, "xspan is zero\n" ) ;
      return ;
    }
    yspan = fabs( top - bottom ) ;
    if( FLOAT_EQ( yspan, 0.0 ) ){
      utDmsg(ERRMSG,"utDGsetFrame:1", routine, "yspan is zero\n" ) ;
    }
    /* scale data to fit to window */
    xscaleF = (DOUBLE) gc_p->winwidth / xspan ;
    yscaleF = (DOUBLE) gc_p->winheight / yspan ;
    /* pick smallest of factors for scale factor */
    gc_p->scaleFactor = MIN( xscaleF, yscaleF) ;

    /* offset from beginning of data */
    gc_p->xoffset = - left ;
    gc_p->yoffset = - bottom ;

    gc_p->lbX = 0.0 ;
    gc_p->lbY = 0.0 ;
    gc_p->ubX = 1.0 ;
    gc_p->ubY = 1.0 ;
    if(!(gc_p->fullView)){
      set_clip_window( gc_p, left, bottom, gc_p->scaleFactor ) ;
      if(!(gc_p->fullView)){
	width = gc_p->fullArea.UTDURX - gc_p->fullArea.UTDLLX ;
	if( width > 0 ){
	  gc_p->lbX = (gc_p->zoomArea.UTDLLX - gc_p->fullArea.UTDLLX) / width ;
	  gc_p->ubX = (gc_p->zoomArea.UTDURX - gc_p->fullArea.UTDLLX) / width ;
	  if( gc_p->lbX < 0 ){
	    gc_p->lbX = 0.0 ;
	  }
	  if( gc_p->ubX > 1.0 ){
	    gc_p->ubX = 1.0 ;
	  }
	}
	if(!(gc_p->fullView)){
	  height = gc_p->fullArea.UTDURY - gc_p->fullArea.UTDLLY ;
	  if( height > 0 ){
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

    /* -----------------------------------------------------------------
     * Set the scrollbars for update.
     * ----------------------------------------------------------------- */
    canvas_p = gc_p->canvas ;
    if( canvas_p ){
      canvas_p->flags |= UPDATE_SCROLLBARS ;
      Tk_CanvasDispUpdate() ;
    }

    gc_p->fullView = TRUE ;

} /* end gsetwindow */

void utDGUIforceRedraw(void)
{
    XEvent event ;          /* describes configuration event */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = gcstatic_pS ;
    if(!(gc_p)){
      return ;
    }
    /* set a redraw command for a zoom */
    event.xexpose.type = Expose ;
    event.xexpose.display = gc_p->dpy ;
    event.xexpose.window = gc_p->draw ;
    event.xexpose.x = 0 ;
    event.xexpose.y = 0 ;
    event.xexpose.width = gc_p->winwidth - 1 ;
    event.xexpose.height = gc_p->winheight - 1 ;
    event.xexpose.count = 0 ;
    /*
    fprintf( stderr, "sending x event\n" ) ;
    */
    XSendEvent( gc_p->dpy, gc_p->draw, TRUE, ExposureMask, &event ) ;
    gc_p->force_redraw = TRUE ;
    ALARM_REDRAW() ;
} /* end utDGUIforceRedraw */


void utDGUItranslate( const char *msg,DOUBLE x1,DOUBLE y1,UTDTRANS_T options)
{
    BOOL abort_trans ;
    DOUBLE last_xoff, last_yoff ;
    DOUBLE xdelta, ydelta ;
    INT xvalid ;
    INT yvalid ;
    INT trans_type ;
    GraphicsContextPtr gc_p ;	/* graphics context pointer */
    FUNC_NAME("utDGUItranslate") ;

    gc_p = gcstatic_pS ;
    if(!(gc_p)){
      return ;
    }

    /* -----------------------------------------------------------------
     * First find options.
     * ----------------------------------------------------------------- */
    trans_type = options & UTDTRANS_ORIGIN ;
    xvalid = options & UTDTRANS_XVALID ;
    yvalid = options & UTDTRANS_YVALID ;
    xdelta = options & UTDTRANS_XDELTA ;
    ydelta = options & UTDTRANS_YDELTA ;

    if( gc_p->fullView ){
	/* only save full view window size */
	gc_p->oldxoffset = gc_p->xoffset ;
	gc_p->oldyoffset = gc_p->yoffset ;
	gc_p->oldscaleFactor = gc_p->scaleFactor ;
	gc_p->fullView = FALSE ;
	set_clip_window( gc_p, gc_p->fullArea.UTDLLX, gc_p->fullArea.UTDLLY, gc_p->scaleFactor ) ;
    }
    last_xoff = gc_p->xoffset ; last_yoff = gc_p->yoffset ;
    if( msg ){
      utDmsgf(IMSG,MSG_AT,NULL,msg) ;
      abort_trans = utDGUIgetPt( &x1, &y1 ) ;
      if( abort_trans ){
	// ICmessage( "[TRANSLATE]:aborting translate" ) ;
	return ;
      }
      utDmsgf( IMSG, MSG_AT, routine, "new center is (%.*f %.*f)\n",
	  gc_p->precision,x1/gc_p->scale,gc_p->precision, y1/gc_p->scale ) ;
      xvalid = TRUE ;
      yvalid = TRUE ;
    }
    /* translate to origin first */
    if( xvalid ){
      gc_p->xoffset = - x1 ;
    }
    if( xdelta ){
      gc_p->xoffset -= x1 ;
    }
    if( yvalid ){
      gc_p->yoffset = - y1 ;
    }
    if( ydelta ){
      gc_p->yoffset += y1 ;
    }
    if( trans_type == UTDTRANS_CENTER ){
      /* now center in screen - half of xspan */
      if( xvalid ){
	gc_p->xoffset += (INT)( (DOUBLE) gc_p->winwidth / gc_p->scaleFactor / 2.0 ) ;
      }
      if( yvalid ){
	gc_p->yoffset += (INT)( (DOUBLE) gc_p->winheight / gc_p->scaleFactor / 2.0 );
      }
    } else if( trans_type == UTDTRANS_RT ){
      if( xvalid ){
	gc_p->xoffset += (INT)( (DOUBLE) gc_p->winwidth / gc_p->scaleFactor) ;
      }
      if( yvalid ){
	gc_p->yoffset += (INT)( (DOUBLE) gc_p->winheight / gc_p->scaleFactor) ;
      }
    }
    utDGUIforceRedraw() ;
    /* update clipping window */
    gc_p->zoomArea.UTDLLX -= (gc_p->xoffset - last_xoff) ;
    gc_p->zoomArea.UTDURX -= (gc_p->xoffset - last_xoff) ;
    gc_p->zoomArea.UTDLLY -= (gc_p->yoffset - last_yoff) ;
    gc_p->zoomArea.UTDURY -= (gc_p->yoffset - last_yoff) ;

} /* end gtranslate */


BOOL utDGUIstate(void) 
{
    if( gcstatic_pS ){
      return( gcstatic_pS->graphics_enabled ) ;
    } else {
      return(FALSE) ;
    }

} /* end utDGUIstate() */

void utDGUIwindowState( Display *display, Window window, BOOL on_state )
{
    Window    *chW ;		/* children windows */
    Window    rootW;		/* X root window ID */
    Window    main_wrapper;	/* X wrapper window ID */
    XWindowAttributes wattr;	/* save window attributes */
    unsigned int numch ;	/* number of children windows */
    static int eventsL ;	/* save the events */
    static int main_wrapper_eventsL ;	/* save the wrapper events */

    if( on_state ){
      DBG( fprintf( stderr, "window events on restore or turnon: %d\n", eventsL ) ; ) ;
      XSelectInput(display, window,eventsL);
      if (XQueryTree(display,window,&rootW,&main_wrapper, &chW, &numch) != 0) {
	XSelectInput(display,main_wrapper,main_wrapper_eventsL) ;
	XFree((char *) chW) ;
      }
    } else {
      XGetWindowAttributes( display, window, &wattr ) ;
      eventsL = wattr.all_event_masks ;
      DBG( fprintf( stderr, "window events on save or turnoff: %d\n", eventsL ) ; ) ;
      XSelectInput(display,window,NoEventMask) ;
      /* -----------------------------------------------------------------
       * New in Tk8.0 - we need to deal with wrapper window.
      ----------------------------------------------------------------- */
      if (XQueryTree(display,window,&rootW,&main_wrapper, &chW, &numch) != 0) {
	XGetWindowAttributes( display, main_wrapper, &wattr ) ;
	main_wrapper_eventsL = wattr.all_event_masks ;
	XSelectInput(display,main_wrapper,NoEventMask) ;
	XFree((char *) chW) ;
      }
    }
} /* end utDGUIwindowState() */


void utDGUIrestoreState(void)
{
    Tk_Window *children ;
    int i ;
    INT trys ;			/* look for window */
    INT timeout ;		/* graphics timeout */
    int num_children ;		/* number of children */
    char *canvas_widget_p ;	/* return name of widget */
    char cmd[LRECL] ;		/* tcl command name */
    char canvas_widget[LRECL] ;	/* copy of name */
    Tk_Window drawWindow ;	/* draw window */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    XSelectInput(gc_p->dpy,gc_p->main,gc_p->main_event);
    /* We need this to work on Redhat 6.0 and Enlightenment WM */
    gc_p->main_wrapper_event = gc_p->main_wrapper_event & ~(ResizeRedirectMask) ;
    XSelectInput(gc_p->dpy,gc_p->main_wrapper,gc_p->main_wrapper_event);
    Tk_UpdateObjCmd(gc_p->mainWindow,gc_p->interp,1,NULL) ;
    Tk_ParasiteRestore(gc_p->mainWindow) ;
    children = Tk_WindowChildren(gc_p->mainWindow,&num_children) ;
    for( i = num_children-1 ; i >= 0; i-- ){
      Tk_MapWindow( children[i] ) ;
    }
    if( children ){
      ckfree((char *)children) ;
    }

    TkWmParasiteConfigNotify(gc_p->mainWindow) ;
    sprintf( cmd, "wm title . %s;", utDprogram_getName() ) ;
    Tcl_GlobalEval( gc_p->interp, cmd ) ;
    Tk_UpdateObjCmd(gc_p->mainWindow,gc_p->interp,1,NULL) ;
    gc_p->waiting_for_parasite = FALSE ;

    /* -----------------------------------------------------------------
     * Now wait for the screen to be visible again.
     * ----------------------------------------------------------------- */
    wait_for_main( gc_p ) ; 

} /* end utDGUIrestoreState */

INT utDGUIsaveState(void)
{
    XWindowAttributes wattr;/* save window attributes */
    Tk_Window *children ;
    int i ;
    int num_children ;
    unsigned int numch ;	/* number of children */
    Window *chW ;		/* children windows */
    Window rootW ;		/* root window */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(0) ;
    }
    DBG( fprintf( stderr, "in save state\n" ) ; ) ;

    /* save the state */
    if(!(gc_p->main)){
      if(!(gc_p->mainWindow)){
	return(0) ;
      }
      gc_p->main = Tk_WindowId(gc_p->mainWindow) ;
    }
    XGetWindowAttributes( gc_p->dpy, gc_p->main, &wattr ) ;
    gc_p->main_event = wattr.all_event_masks ;
    XSelectInput(gc_p->dpy,gc_p->main,NoEventMask) ;
    children = Tk_WindowChildren(gc_p->mainWindow,&num_children) ;
    for( i = 0 ; i < num_children ; i++ ){
      Tk_UnmapParasite( children[i] ) ;
    }
    if( children ){
      ckfree((char *)children) ;
    }
    /* -----------------------------------------------------------------
     * New in Tk8.0 - we need to deal with wrapper window.
    ----------------------------------------------------------------- */
    if (XQueryTree(gc_p->dpy, gc_p->main, &rootW, &gc_p->main_wrapper, &chW, &numch) != 0) {
      XGetWindowAttributes( gc_p->dpy, gc_p->main_wrapper, &wattr ) ;
      gc_p->main_wrapper_event = wattr.all_event_masks ;
      XSelectInput(gc_p->dpy,gc_p->main_wrapper,NoEventMask) ;
      if( chW ){
	XFree((char *) chW) ;
      }
    }
    XSync(gc_p->dpy,True) ;
    gc_p->waiting_for_parasite = TRUE ;
    return( (INT) gc_p->main ) ;
} /* end utDGUIsaveState() */


static void free_gc( GraphicsContextPtr gc_p )
{
    INT c ;				/* color counter */

    if( gc_p ){
      if( gc_p->colorOn ){
	UTDFREE( gc_p->colorOn ) ;
      }
      if( gc_p->graphicContext ){
	UTDFREE( gc_p->graphicContext ) ;
      }
      if( gc_p->transcript_widget ){
	UTDFREE( gc_p->transcript_widget ) ;
      }
      if( gc_p->color_htable ){
	Tcl_DeleteHashTable( gc_p->color_htable ) ;
      }
      if( gc_p->stipple_name ){
	for( c = 0 ;  c <= gc_p->numColor ; c++ ){
	  if( gc_p->stipple_name[c] ){
	    UTDFREE( gc_p->stipple_name[c] ) ;
	  }
	}
	UTDVECTOR_FREE( gc_p->stipple_name, 0 ) ;
      }
      if( gc_p->ecolor ){
	UTDVECTOR_FREE( gc_p->ecolor, 0 ) ;
      }
      UTDFREE( gc_p ) ;
    }
} /* end free_gc() */

