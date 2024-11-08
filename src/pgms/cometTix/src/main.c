/* ----------------------------------------------------------------- 
FILE:	    main.c
DESCRIPTION:This file contains main control routine for Tix/Tk shell
            program, that is, a improved tixwish.
CONTENTS:   main( argc , argv )
		INT argc ;
		char *argv[] ;
DATE:	    Wed Jun  2 21:18:46 CDT 2021
REVISIONS:  
 * $Log$
---------------------------------------------------------------- */
#include <cometconfig.h>
#include <tcl/tcl.h>
#ifdef UTDTOOLS_GRAPHICS
#include <tk/tk.h>
#include <tix/tix.h>
#endif /* UTDTOOLS_GRAPHICS */
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */
#include <utd/base.h>
#include <utd/baseobj.h>
#include <utd/cleanup.h>
#include <utd/debug.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/log.h>
#include <utd/dstring.h>
#include <utd/string.h>
#include <utd/program.h>
#include <utd/system.h>
#include <utd/tcllog.h>
#ifdef UTDTOOLS_GRAPHICS
#include <gui/gui.h>
#endif /* UTDTOOLS_GRAPHICS */
#include <gui/utils.h>
#include <base/utd.h>
#include <base/interp.h>
#include <base/tclstdin.h>
#include <js/twjs.h>
#include "html.h"
#include "html_library.h"
#include "timestamp.h"

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static void ez_init( void *inter_data ) ;
static void utdtools_tcl_init( Tcl_Interp *inter_p, const char *tcl_dir ) ;
static void process_do_file(Tcl_Interp *i_p,char *do_file,FILE *did_file) ;
static INT closegraphics(INT status) ;
static INT args_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc, Tcl_Obj * CONST objv[]) ;
static INT js_func(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * CONST objv[]) ;
UTD_G( static void calc_full_screen_coordinate( void ) ) ;
UTD_G( static void draw_the_data( UTDTILERECTPTR area, void *clientData ) ) ;
/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static TWJS_PTR jsenvS ;                 /* Javascript environment */



int main(int argc, char *argv[] ) {
    Tcl_Interp *inter_p ;		// Tcl Interpreter
    char *cmd ;				/* command to execute */
    char *did_p ;			/* Did pathname */
    char **copy_argv ;			/* copy of argv */
    char *do_filename ;			// name of do file
    char *directory ;			/* directory name */
    char *script_cmds ;			/* script commands */
    char *full_script_name ;		/* full path of script */
    char *fullName ;			/* full name of path */
    char **line_buffer ;		/* for parsing */
    char **line_data ;			/* returned parsed data */
    char *result ;			/* result of command */
    char *pgm_name ;			/* program name */
    char *utdtools ;			/* utd tools root directory */
    char *utdversion ;			/* utd tools version */
    const char *rootdir ;		/* open directory */
    const char *script ;		/* script name */
    const char *log_path ;		/* path for log */
    const char *tcl_dir_name ;		/* Tcl directory for all programs */
    char working_dir[LRECL] ;		/* buffer for directory path */
    FILE *did_file ;			/* did file pointer */
    BOOL tty_mode ;			/* exit on a close */
    BOOL ez_editor ;			/* EZ editor mode on */
    BOOL echo_mode ;			/* echo commands */
    BOOL help_flag ;			/* output some help messages */
    BOOL log_local ;			/* use local directory for logs */
    BOOL debug_flag ;			/* turn on debug of script */
    BOOL quiet_flag ;			/* quiet the output */
    BOOL prompt_flag ;			/* output an initial prompt */
    BOOL verbose_flag ;			/* verbose output */
    BOOL graphics_flag ;		/* graphics are requested */
    BOOL top_level_flag ;		/* top level window present */
    BOOL suppress_stats ;		/* suppress output of stats */
    INT i ;				/* counter */
    INT len ;				/* length of commands */
    INT line ;				/* line counter */
    INT numlines ;			/* number of lines in script file */
    INT code ;				/* Tcl return code */
    INT status ;			/* return status */
    INT copy_argc ;			/* copy of argc */
    INT parasite_win ;			/* parasite window id */
    UTDDSTRING script_buf ;		/* build a script name overkill */
    UTDDSTRING command_buf ;		/* build a command */
    UTDDSTRING did_filename ;		/* did filename */
    UTDDSTRING tcl_dir_buf ;		/* Tcl directory buffer */
    Tcl_DString tcommand;		/* Tcl command buffer */
    Tcl_DString buffer;			/* Tcl buffer */
    MSG_TYPE_T msg_opts ;		/* suppress stats option */
    void (*gui_init_func)(void *) ;	/* optional function to call */
    FUNC_NAME("main") ;

    copy_argc = argc ; // don't destroy original.
    copy_argv = argv ;
    pgm_name = argv[0] ;
    utDmsg_mode( M_VERBOSE ) ;

    copy_argv++ ;
    copy_argc-- ;
    directory = NULL ;
    do_filename = NULL ;
    log_local = FALSE ;
    tty_mode = FALSE ;
    echo_mode = FALSE ;
    ez_editor = FALSE ;
    gui_init_func = NULL ;
    help_flag = FALSE ;
    quiet_flag = 0 ;
    prompt_flag = TRUE ;
    verbose_flag = FALSE ;
    debug_flag = FALSE ;
    suppress_stats = FALSE ;
    graphics_flag = TRUE ;
    top_level_flag = TRUE ;
    parasite_win = 0 ;
    while(copy_argc--){
      if( strcmp( *copy_argv, "-do") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	do_filename = *copy_argv ;
      } else if (strcmp(*copy_argv, "-e") == STRINGEQ ){
	echo_mode = TRUE ;
      } else if (strcmp(*copy_argv, "-E") == STRINGEQ ){
 	ez_editor = TRUE ;
	gui_init_func = ez_init ;
      } else if (strcmp(*copy_argv, "-i") == STRINGEQ ){
	tty_mode = TRUE ;
      } else if (strcmp(*copy_argv, "-n") == STRINGEQ ){
	graphics_flag = FALSE ;
      } else if (strcmp(*copy_argv, "-N") == STRINGEQ ){
	top_level_flag = FALSE ;
      } else if (strcmp(*copy_argv, "-v") == STRINGEQ ){
	verbose_flag = TRUE ;
      } else if (strncmp(*copy_argv, "-h",2) == STRINGEQ ){
	help_flag = TRUE ;
      } else if (strcmp(*copy_argv, "-d") == STRINGEQ ){
	debug_flag = TRUE ;
      } else if (strcmp(*copy_argv, "-p") == STRINGEQ ){
	prompt_flag = FALSE ;
      } else if (strcmp(*copy_argv, "-q") == STRINGEQ ){
	quiet_flag++ ;
      } else if (strcmp(*copy_argv, "-s") == STRINGEQ ){
	suppress_stats = TRUE ;
      } else if (strcmp(*copy_argv, "-l") == STRINGEQ ){
	log_local = TRUE ;
      } else if (strcmp(*copy_argv, "-dir") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	directory = *copy_argv ;
      } else if (strcmp(*copy_argv, "-w") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	parasite_win = atoi(*copy_argv) ;
      } else if (strcmp(*copy_argv, "--") == STRINGEQ ){
	break ;
      } else {
	if(!(do_filename)){
	  do_filename = *copy_argv ;
	}
      }
      copy_argv++;
    }
    if( debug_flag ){
      for( i = 0 ; i < argc ; i++ ){
	utDmsgf( IMSG,MSG_AT,NULL, "argv[%d]: %s\n", i, argv[i] ) ;
      }
      utDdebug_init( debug_flag ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "Debug enabled.\n\n" ) ;
    }
    if( help_flag ){
      utDmsgf( IMSG,MSG_AT,NULL, "\nThe cometTix program supports Tcl/Tk/Tix and Python.\n" );
      utDmsgf( IMSG,MSG_AT,NULL, "\nsyntax:\n" );
      utDmsgf( IMSG,MSG_AT,NULL, "         cometTix [-do <scriptFile>] [-d] [-e] [-i] [-l] [-n] [-q] [-s] [-v]\n" );
      utDmsgf( IMSG,MSG_AT,NULL, "Options:\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -d : turn on debug mode\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -do <scriptFile> : execute the given file\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -e : echo command mode on\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -E : EZ editor mode on\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -h[elp] : help command\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -i : interactive tty mode on\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -l : turn on local logging\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -n : turn off graphics\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -N : graphics but withdrawn toplevel window\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -p : turn off initial prompt\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -q : enable quiet output modes\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -s : suppress output of runtime stats\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -v : verbose output mode\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "        -w <windowId> : parasite window mode X window id\n" ) ;
      utDmsgf( IMSG,MSG_AT,NULL, "\n\n" ) ;
      exit(0) ;
    }
    if( suppress_stats ){
      msg_opts = MSG_AVOID_STATS ;
    } else {
      msg_opts = MSG ;
    }
    if( verbose_flag ){
      utDmsg_mode( M_VERBOSE | msg_opts ) ;
    } else if( quiet_flag == 0 ){
      utDmsg_mode( M_NORMAL | msg_opts ) ;
    } else if( quiet_flag == 1 ){
      utDmsg_mode( M_SILENT | msg_opts ) ;
    } else {
      utDmsg_mode( M_MUTE | msg_opts ) ;
    }
    if( log_local ){
      log_path = utDgetwd(working_dir,LRECL) ;
    } else {
      log_path = NULL ;
    }

    rootdir = utDInit( argc, argv, NULL, "1.0", UTD_COMPILE_DATE, 
	       "\nWelcome to the cometTix program which supports Tix/Tk/Tcl and Python.\n", log_path );
    if( verbose_flag ){
      utDmsgf( IMSG,MSG_AT,NULL, "UTDTOOLS=%s\n", rootdir ) ;
    }

    inter_p = Tcl_CreateInterp() ;
    utDsetInterpreter(inter_p) ;

    // Start up the Tcl log system.
    if( log_path ){
      utDdstring_init( &did_filename ) ;
      did_p = utDdstring_printf( &did_filename, "%s.did", pgm_name ) ;
      did_file = utDtcllog_init( did_p, NULL, NULL ) ;
      utDdstring_free( &did_filename ) ;
    } else {
      did_file = NULL ;
    }

    // Build the Tcl directory path.
    utDdstring_init( &tcl_dir_buf ) ;
    utdtools = utDgetenv("UTDTOOLS") ;
    if(!(utdtools)){
      utDmsgf(ERRMSG, MSG_AT, routine, 
	  "UTDTOOLS environment variable not defined.\n" ) ;
      utDprogram_exit(PGMFAIL) ;
    }
    utdversion = utDgetenv("UTDTOOLSVERSION") ;
    if(!(utdversion)){
      utDmsgf(ERRMSG, MSG_AT, routine, 
	  "UTDTOOLSVERSION environment variable not defined.\n" ) ;
      utDprogram_exit(PGMFAIL) ;
    }

    tcl_dir_name = utDdstring_printf( &tcl_dir_buf, "%s/%s/tcl", 
	utdtools, utdversion ) ;


    if(!(utDdirectoryExists( tcl_dir_name))){
      utDmsgf(ERRMSG,MSG_AT, routine, 
	  "could not file Tcl directory:%s.  Fatal.\n", tcl_dir_name ) ;
      utDprogram_exit(PGMFAIL) ;
    }
    utdtools_tcl_init( inter_p, tcl_dir_name ) ;

    // Add common Tcl commands here.
    Tcl_CreateObjCommand( inter_p, "utdscript_args",args_objfunc, argv, NULL ) ;
    Tcl_CreateObjCommand( inter_p, "utdinterpreter_mode",utDinterpreter_mode_objfunc, NULL, NULL);

    /* -----------------------------------------------------------------
     * Setup the input channel.
    ----------------------------------------------------------------- */
    UTDSTDIN_OPT_T opts = (UTDSTDIN_OPT_T) ((echo_mode ? UTDSTDIN_OPT_ECHO_CMDS_T : UTDSTDIN_OPT_NONE_T) |
                          (tty_mode ? UTDSTDIN_OPT_EXIT_ON_CLOSE_T : UTDSTDIN_OPT_NONE_T)) ;
    utDtcl_stdin(inter_p,NULL,did_file,NULL,opts ) ;
    if( prompt_flag ){
      utDtcl_stdinPrompt( inter_p, 0) ;
    }

#ifdef UTDTOOLS_STATIC_BUILD
    /* Static compile debug 
     *
     * */
    if( Utdpython_Init(inter_p) == TCL_ERROR ){
      utDmsgf(ERRMSG,MSG_AT,routine, "Couldn't start utdpython package.\n" ) ;
    }
#endif /* UTDTOOLS_STATIC_BUILD */

    // Show how a dstring works
    utDdstring_init( &script_buf ) ;
    if( top_level_flag ){
      script = "tix.tcl" ;
    } else {
      script = "null_window.tcl" ;
    }
    full_script_name = utDdstring_printf( &script_buf, "%s/gui/%s", tcl_dir_name, script ) ;

#ifdef UTDTOOLS_GRAPHICS

    if( graphics_flag ){
      // A Tix/Tk/Tcl Gui
      UTDGUI_OPTS_T gui_opts = (UTDGUI_OPTS_T) (UTDGUI_OPT_GRAPHICS_T|UTDGUI_OPT_NO_STDIN_HANDLER_T) ;
      UTD_G( utDGUI_init( argc, argv, full_script_name, inter_p, gui_opts, 
	        draw_the_data, NULL, did_file, gui_init_func, parasite_win ) ) ;
      UTD_G( calc_full_screen_coordinate() ) ;

      utDcleanup_graphics( closegraphics ) ;
      utDprogram_exitFunction( closegraphics ) ;

    } else {
      // A Tcl only Gui
      utDGUI_init( argc, argv, full_script_name, inter_p, UTDGUI_OPT_NO_STDIN_HANDLER_T, 
	           NULL, NULL, did_file, NULL, 0 ) ;
    }
#else 
    utDGUI_Tcl_init( argc, argv, inter_p, did_file) ;
    Tcl_CreateObjCommand( inter_p, "utdcontinue",utDGUI_Tcl_continue_objfunc, NULL, NULL ) ;
    Tcl_CreateObjCommand( inter_p, "utdwait",utDGUI_Tcl_wait_objfunc, NULL, NULL ) ;
    Tcl_CreateObjCommand( inter_p, "utdmsg",utDGUI_Tcl_msg_objfunc, NULL, NULL ) ;
#endif /* UTDTOOLS_GRAPHICS */

    if( do_filename ){
      process_do_file(inter_p,do_filename, did_file ) ;
    }

    /* -----------------------------------------------------------------
     * Output the first prompt.
    ----------------------------------------------------------------- */
    utDtcl_stdinPrompt( inter_p, 0) ;
    Tcl_ResetResult(inter_p);

#ifdef UTDTOOLS_GRAPHICS
    utDGUI_run() ;
#else
    utDGUI_Tcl_run( inter_p ) ;
#endif

    utDprogram_exit(PGMOK) ;

    exit(0) ;
} /* end main() */

static void utdtools_tcl_init( Tcl_Interp *inter_p,const char *tcl_dir_name )
{
    INT status ;			/* return status */
    char *result ;			/* result for the command */
    const char *error_p ;		/* error message */
    const char *tcl_autopath_name ;	/* Tcl directory for the program */
    BOOL verbose_flag ;			/* verbose flag */
    Tcl_Obj *tmp_objv[10] ;		/* argument buffer */
    FUNC_NAME("utdtools_tcl_init") ;

    UTDDSTRING tcl_autopath_buf ;	/* Tcl groute directory */
    // Now set the groute path for useful Tcl related to global router
    utDdstring_init( &tcl_autopath_buf ) ;
    tcl_autopath_name = utDdstring_printf( &tcl_autopath_buf, "%s/utdtools", tcl_dir_name ) ;
    if(!(utDdirectoryExists( tcl_autopath_name))){
      utDmsgf(ERRMSG,MSG_AT, routine, 
	  "could not find Tcl utdtools directory:%s.  Fatal.\n", tcl_autopath_name ) ;
      utDprogram_exit(PGMFAIL) ;
    }

    if( utDmsg_get_mode() & M_VERBOSE ){
      verbose_flag = TRUE ;
    } else {
      verbose_flag = FALSE ;
    }

    // Set the autopath
    tmp_objv[0] = Tcl_NewStringObj( "lappend", -1 ) ;
    tmp_objv[1] = Tcl_NewStringObj( "auto_path", -1 ) ;
    tmp_objv[2] = Tcl_NewStringObj( tcl_dir_name, -1 ) ;
    tmp_objv[3] = Tcl_NewStringObj( tcl_autopath_name, -1 ) ;
    tmp_objv[4] = NULL ;
    status = Tcl_EvalObjv( inter_p, 4, tmp_objv, TCL_EVAL_GLOBAL | TCL_EVAL_INVOKE ) ;
    if( verbose_flag ){
      result = Tcl_GetString(Tcl_GetObjResult(inter_p)) ;
      if (result[0] != '\0') {
	utDmsgf( IMSG,MSG_AT,NULL, "TCL auto_path=%s\n", result ) ;
      }
    }

    tmp_objv[0] = Tcl_NewStringObj( "::utdtools::init", -1 ) ;
    tmp_objv[1] = NULL ;
    status = Tcl_EvalObjv( inter_p, 1, tmp_objv, TCL_EVAL_GLOBAL | TCL_EVAL_INVOKE ) ;
    if( status ){
      error_p = Tcl_GetVar2( inter_p, "errorInfo", NULL, TCL_GLOBAL_ONLY ) ;
      if( error_p ){
	utDmsgf( ERRMSG, MSG_AT, routine, "%s\n", error_p ) ;
      }
    }
} /* end utdtools_tcl_init() */


#ifdef UTDTOOLS_GRAPHICS

static void calc_full_screen_coordinate( void )
{
    // Here is where we calculate the size of the full
    // screen draw.  Normally, we would traverse the
    // data in our program to calculate it's extent and
    // then add 10% to make a nice picture.  Scale is
    // used to make database units easier to manipulate
    
    // Just make up something here.
    utDGUIsetFrame( -10, -10, 110, 110, 1, 1 ) ;
} /* end calc_full_screen_coordinates() */

static void draw_the_data( UTDTILERECTPTR area, void *clientData ) 
{
  utDGUIstartFrame() ;

  const char *label = "hello world!" ;
  utDGUIdrawRect( 50.0, 50.0, 75.0, 74.0, UTDRED, label ) ;
  utDGUIdrawLine( 10.0, 10.0, 75.0, 74.0, UTDBLUE, NULL ) ;

  utDGUIflushFrame() ;
} /* end draw_the_data() */


static INT closegraphics(INT status)
{
    DBG( fprintf( stderr, "closegraphics called with %d status.\n", status ) ; ) ;
    if( utDGUIstate() ){ 
      DBG( fprintf(stderr,"calling utDGUIabort_graphics...\n" ) ; )
      status = utDGUIabort_graphics(status) ;
      if( status == PGMGCANCEL ){
	return(PGMGCANCEL) ;
      }
      if( status == PGMGABORTALL ){
	return(PGMGABORTALL) ;
      }
    } 
    return(PGMOK) ;
} /* end closegraphics() */


#endif /* UTDTOOLS_GRAPHICS */


static INT args_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,
                    Tcl_Obj * CONST objv[])
{
    INT i ;			/* counter */
    char *argv_i ;		/* the ith argument */
    char **argv ;		/* arg vector */
    Tcl_Obj *strObj ;		/* new string object */
    Tcl_Obj *resultPtr ;	/* the output result */
    FUNC_NAME( "utdscript_args" ) ;

    if( utDhelp_requested( objc, objv ) ){
      utDmsgf( IMSG, MSG_AT, NULL, "%s : returns arguments which follow the double hyphen on command line", routine ) ;
      return(TCL_OK) ;
    }

    argv = (char **) d_p ;

    for( i = 0 ; i < LRECL ; i++ ){
      argv_i = argv[i] ;
      if(!(argv_i)){
	break ;
      }
      if( strcmp( argv_i, "--" ) == STRINGEQ ){
	resultPtr = Tcl_GetObjResult(i_p) ;
	for( i++ ; i < LRECL ; i++ ){
	  argv_i = argv[i] ;
	  if(!(argv_i)){
	    break ;
	  }
	  strObj = Tcl_NewStringObj( argv_i, -1 ) ;
	  Tcl_ListObjAppendElement(NULL,resultPtr, strObj) ;
	}
	return(TCL_OK) ;
      }

    }
    return(TCL_OK) ;

} /* end args_objfunc() */


static void process_do_file(Tcl_Interp *i_p,char *do_file,FILE *did_file)
{
    INT line ;				/* line counter */
    INT status ;			/* command status */
    char *bufferptr ;			/* beginning of line */
    BOOL incomplete ;			/* script did not complete */
    FILE *fp ;				/* the do file */
    UTDSTDIN_DATAPTR std_data_p ;	/* process line using various interpreters */
    FUNC_NAME("process_do_file") ;

    Tcl_ResetResult(i_p) ;
    /* -----------------------------------------------------------------
     * Now open a .did file to tell use the commands that were executed.
    ----------------------------------------------------------------- */

    if( do_file ){
      fp = UTDOPEN( do_file, "r", FILE_NOABORT | FILE_VERBOSE ) ;
      if(!(fp)){
	utDmsgf( ERRMSG, MSG_AT, routine, "problem reading do file:%s\n", do_file ) ;
	return ;
      }

      std_data_p = utDtcl_stdin( i_p, fp, did_file, do_file, UTDSTDIN_OPT_NO_CHANNEL_T ) ;

      line = 0 ;
      incomplete = FALSE ;
      while( (bufferptr = utDtcl_stdin_get_input( std_data_p ) ) ){
	utDtcl_stdin_line( std_data_p, ++line ) ;
	utDtcl_stdin_strip_line_feeds( bufferptr ) ;
	status = utDtcl_stdin_data( i_p, std_data_p, bufferptr ) ;
	if( status == TCL_ERROR ){
	  incomplete = TRUE ;
	  break ;
	}

      } /* end  while( (bufferptr = fgets(input,LRECL,fp)... */
      UTDCLOSE( fp ) ;

      if( incomplete ){
	utDmsgf( ERRMSG, MSG_AT, routine, "script:%s terminated due to errors.\n", do_file ) ;
      }

    }
} /* end process_do_file() */

static void ez_init(void *inter_ptr)
{
    INT code ;                 	/* return code from TCL */
    Tcl_Interp *interp ;	/* tcl interpreter */
    char *command ;		/* resulting command */
    char *script_cmds ;		/* resulting script command */
    UTDDSTRING command_buf ;	/* dynamic string processor */
    FUNC_NAME("ez_init" ) ;

    /* -----------------------------------------------------------------
     * Now create the Javascript environment.  Initialize a few variables
     * to their NULL defaults.
    ----------------------------------------------------------------- */
    interp = (Tcl_Interp *) inter_ptr ;
    if( interp ){
      /* add_tcl_commands(interp,do_argS) ; */
      jsenvS = TWJS_Init(interp) ;		
      if( jsenvS ){
	Tcl_CreateObjCommand(interp, "twjavascript", js_func, jsenvS, NULL);
	Tcl_CreateCommand(interp, "twhtml_xfont", html_xfont, NULL, NULL);
	/* Initialize variables - both lower and upper case */
	utDdstring_init( &command_buf ) ;
	utDdstring_printf( &command_buf, "procedure=\"\";PROCEDURE=\"\";" ) ;
	utDdstring_printf( &command_buf, "tkwindow_fake=\"\";TKWINDOW_FAKE=\"\";" ) ;
	utDdstring_printf( &command_buf, "args=\"\";ARGS=\"\";" ) ;
	utDdstring_printf( &command_buf, "width=\"\";WIDTH=\"\";" ) ;
	utDdstring_printf( &command_buf, "height=\"\";HEIGHT=\"\";" ) ;
	utDdstring_printf( &command_buf, "align=\"\";ALIGN=\"\";" ) ;
	utDdstring_printf( &command_buf, "padx=\"\";PADX=\"\";" ) ;
	utDdstring_printf( &command_buf, "pady=\"\";PADY=\"\";" ) ;
	utDdstring_printf( &command_buf, "alt=\"\";ALT=\"\";" ) ;
	utDdstring_printf( &command_buf, "altw=\"\";ALTW=\"\";" ) ;
	utDdstring_printf( &command_buf, "alth=\"\";ALTH=\"\";" ) ;
	utDdstring_printf( &command_buf, "expr=\"\";EXPR=\"\";" ) ;
	utDdstring_printf( &command_buf, "logic=\"\";LOGIC=\"\";" ) ;
	utDdstring_printf( &command_buf, "html=\"\";HTML=\"\";" ) ;
	command = utDdstring_printf( &command_buf, "tkplacement=\"\";TKPLACEMENT=\"\";" ) ;
	TWJS_process_script(jsenvS, command ) ;
	Tcl_CreateObjCommand(interp, "twparse_html", parse_func, NULL, NULL);
	html_parse_init() ;
	utDdstring_free( &command_buf ) ;
      }
    }
    EZeval_html(interp) ;
    EZeval_html_library(interp) ;
} /* end ez_init() */


/* -----------------------------------------------------------------
 * Normal format of this command:
 * twjavascript <command string> <Tkwindow path>
----------------------------------------------------------------- */
static INT js_func(ClientData d_p,Tcl_Interp *i_p,INT objc,
                     Tcl_Obj * CONST objv[])
{
  INT i ;
  char *result ;		/* result of javascript */
  char command[BUFSIZ] ;	/* command buffer for window */
  TWJS_PTR js_ptr ;		/* Javascript environment */

  js_ptr = (TWJS_PTR) d_p ;
  /* -----------------------------------------------------------------
   * This is how we pass the tk window to javascript.  We just instantiate
   * the tkwindow_fake variable in the JS environment and read it on the other
   * side.  Note: we avoid use of tkwindow since that is a Netscape only
   * variable.
  ----------------------------------------------------------------- */
  if( objc >= 3 ){
    sprintf( command, "TKWINDOW_FAKE=\"%s\";", Tcl_GetString(objv[2]) ) ;
    result = TWJS_process_script(js_ptr, command ) ;
  }

  result = TWJS_process_script(js_ptr, Tcl_GetString(objv[1]) ) ;
  return(TCL_OK) ;
} /* end js_func() */
