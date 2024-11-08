/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    main.cxx                                      
DESCRIPTION:The main routine of the general purpose translator
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#include <cometconfig.h>
#include <tcl/tcl.h>
#ifdef UTDGUI_GRAPHICS
#include <tk/tk.h>
#include <tix/tix.h>
#endif /* UTDGUI_GRAPHICS */
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */
#include <utd/base.h>
#include <utd/baseobj.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/log.h>
#include <utd/dstring.h>
#include <utd/string.h>
#include <utd/program.h>
#include <utd/system.h>
#include <utd/tcllog.h>
#ifdef UTDGUI_GRAPHICS
#include <gui/gui.h>
#endif /* UTDGUI_GRAPHICS */
#include <gui/utils.h>
#include <base/utd.h>
#include "timestamp.h"


/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static void utdtools_tcl_init( Tcl_Interp *inter_p, const char *tcl_dir ) ;
UTD_G( static void calc_full_screen_coordinate( void ) ) ;
UTD_G( static void draw_the_data( UTDTILERECTPTR area, void *clientData ) ) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */

int main(int argc, char *argv[] ) {
    Tcl_Interp *inter_p ;		// Tcl Interpreter
    char *cmd ;				/* command to execute */
    char *did_p ;			/* Did pathname */
    char *dsn ;				/* Design name */
    char *dsn_cmd ;			/* Command to set design name */
    char *begin_pgm ;			/* begin program */
    char *end_pgm ;			/* end program */
    char **copy_argv ;			/* copy of argv */
    char *do_filename ;			// name of do file
    char *suffix ;			/* get the suffix from user */
    char *directory ;			/* directory name */
    char *script_cmds ;			/* script commands */
    char *full_script_name ;		/* full path of script */
    char *fullName ;			/* full name of path */
    char **line_buffer ;		/* for parsing */
    char **line_data ;			/* returned parsed data */
    const char *rootdir ;		/* open directory */
    const char *script ;		/* script name */
    const char *log_path ;		/* path for log */
    const char *tcl_dir_name ;		/* Tcl directory for all programs */
    char working_dir[LRECL] ;		/* buffer for directory path */
    FILE *did_file ;			/* did file pointer */
    BOOL log_local ;			/* use local directory for logs */
    BOOL flow_flag ;			/* flow program behaviour invoked */
    BOOL verbose_flag ;			/* verbose output */
    BOOL graphics_flag ;		/* graphics are requested */
    INT i ;				/* counter */
    INT len ;				/* length of commands */
    INT line ;				/* line counter */
    INT numlines ;			/* number of lines in script file */
    INT code ;				/* Tcl return code */
    INT status ;			/* return status */
    INT num_cuts ;			/* number of cuts */
    INT copy_argc ;			/* copy of argc */
    UTDDSTRING script_buf ;		/* build a script name overkill */
    UTDDSTRING command_buf ;		/* build a command */
    UTDDSTRING did_filename ;		/* did filename */
    UTDDSTRING tcl_dir_buf ;		/* Tcl directory buffer */
    Tcl_DString tcommand;		/* Tcl command buffer */
    Tcl_DString buffer;			/* Tcl buffer */
    FUNC_NAME("main") ;

    copy_argc = argc ; // don't destroy original.
    copy_argv = argv ;

    utDmsg_mode( M_VERBOSE ) ;

    for( i = 0 ; i < argc ; i++ ){
      // utDmsgf( WARNMSG,MSG_AT,NULL, "argv[%d]: %s\n", i, argv[i] ) ;
      fprintf( stderr, "argv[%d]: %s\n", i, argv[i] ) ;
    }
    copy_argv++ ;
    copy_argc-- ;
    dsn = NULL ;
    suffix = NULL ;
    num_cuts = 1 ;
    directory = NULL ;
    begin_pgm = NULL ;
    end_pgm = NULL ;
    do_filename = NULL ;
    log_local = FALSE ;
    flow_flag = FALSE ;
    verbose_flag = FALSE ;
    graphics_flag = TRUE ;
    while(copy_argc--){
      if( strcmp( *copy_argv, "-do") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	do_filename = *copy_argv ;
      } else if (strcmp(*copy_argv, "-n") == STRINGEQ ){
	graphics_flag = FALSE ;
      } else if (strcmp(*copy_argv, "-v") == STRINGEQ ){
	verbose_flag = TRUE ;
      } else if (strcmp(*copy_argv, "-f") == STRINGEQ ){
	flow_flag = TRUE ;
      } else if (strcmp(*copy_argv, "-l") == STRINGEQ ){
	log_local = TRUE ;
      } else if (strcmp(*copy_argv, "-s") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	suffix = *copy_argv ;
      } else if (strcmp(*copy_argv, "-b") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	begin_pgm = *copy_argv ;
      } else if (strcmp(*copy_argv, "-e") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	end_pgm = *copy_argv ;
      } else if (strcmp(*copy_argv, "-cuts") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	num_cuts = atoi(*copy_argv) ;
      } else if (strcmp(*copy_argv, "-dsn") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	dsn = *copy_argv ;
      } else if (strcmp(*copy_argv, "-dir") == STRINGEQ ){
	copy_argv++;
	copy_argc--;
	directory = *copy_argv ;
      } else {
	dsn = *copy_argv ;
      }
      copy_argv++;
    }
    if( verbose_flag ){
      utDmsg_mode( M_VERBOSE ) ;
    } else {
      utDmsg_mode( M_NORMAL ) ;
    }
    if( log_local ){
      log_path = utDgetwd(working_dir,LRECL) ;
    } else {
      log_path = NULL ;
    }
    rootdir = utDInit( argc, argv, dsn, "1.0", UTD_COMPILE_DATE, 
	         "\nWelcome to the CometFlow program\n", log_path );
    utDmsgf( IMSG,MSG_AT,NULL, "UTDTOOLS=%s\n", rootdir ) ;

    if(!(dsn)){
      utDmsgf(ERRMSG,"flow/main:3", routine, "design name must be supplied.\n" ) ;
      utDprogram_exit(PGMFAIL) ;
    }
    /* -----------------------------------------------------------------
     * A directory creation and change was requested.
     ----------------------------------------------------------------- */
    if( directory ){
      utDmkdir_backup(directory,TRUE) ;

      if(!(utDdirectoryExists(directory))){
	utDmsgf(ERRMSG,MSG_AT,routine, "Could not create %s.\n", directory ) ;
	utDmsgf(ERRMSG,MSG_AT,NULL, "Must abort.  Please check permissions in %s.\n",
	  utDgetwd(working_dir,LRECL) ) ;
	utDprogram_exit(PGMFAIL) ;
      }
      /* Now attempt to go to the directory directory */
      status = utDchdir(directory) ;
      if( status ){
	utDmsgf(ERRMSG,MSG_AT,routine,"Could not enter directory:%s.\n", directory ) ;
	utDprogram_exit(PGMFAIL) ;
      }
    }


    utDlog_start( dsn, "program started...", UTDLOG_START_DIVIDER, 
	          argc, argv, log_path ) ;


    inter_p = Tcl_CreateInterp() ;


    // Start up the Tcl log system.
    utDdstring_init( &did_filename ) ;
    if (suffix ){
      did_p = utDdstring_printf( &did_filename, "%s.%sdid", dsn, suffix ) ;
    } else {
      did_p = utDdstring_printf( &did_filename, "%s.did", dsn ) ;
    }
    did_file = utDtcllog_init( did_p, NULL, NULL ) ;
    utDdstring_free( &did_filename ) ;

    // Build the Tcl directory path.
    utDdstring_init( &tcl_dir_buf ) ;
#ifdef DEBUG
    tcl_dir_name = utDdstring_append( &tcl_dir_buf, "../../tcl", -1 ) ;
#else 
    tcl_dir_name = utDdstring_printf( &tcl_dir_buf, "%s/tcl", rootdir ) ;
#endif /* DEBUG */
    if(!(utDdirectoryExists( tcl_dir_name))){
      utDmsgf(ERRMSG,"cometFlow/main:5", routine, 
	  "could not file Tcl directory:%s.  Fatal.\n", tcl_dir_name ) ;
      utDprogram_exit(PGMFAIL) ;
    }


    // Show how a dstring works
    utDdstring_init( &script_buf ) ;
    if( flow_flag ){
      script = "null_window.tcl" ;
    } else {
      script = "flow.tcl" ;
    }
    full_script_name = utDdstring_printf( &script_buf, "%s/gui/%s", tcl_dir_name, script ) ;

#ifdef UTDGUI_GRAPHICS
    if( graphics_flag ){
      UTDGUI_OPTS_T gui_opts = (UTDGUI_OPTS_T) (UTDGUI_OPT_GRAPHICS_T|UTDGUI_OPT_NO_STDIN_HANDLER_T) ;
      UTD_G( utDGUI_init( argc, argv, full_script_name, inter_p, gui_opts, 
	        draw_the_data, NULL, did_file, 0 ) ) ;
      UTD_G( calc_full_screen_coordinate() ) ;

    } else {
      // A Tcl only Gui
      utDGUI_init( argc, argv, full_script_name, inter_p, UTDGUI_OPT_NO_STDIN_HANDLER_T, 
	           NULL, NULL, did_file, 0 ) ;
    }
#else 
    utDGUI_Tcl_init( argc, argv, inter_p, did_file) ;
    utdtools_tcl_init( inter_p, tcl_dir_name ) ;
    Tcl_CreateObjCommand( inter_p, "utdcontinue",utDGUI_Tcl_continue_objfunc, NULL, NULL ) ;
    Tcl_CreateObjCommand( inter_p, "utdwait",utDGUI_Tcl_wait_objfunc, NULL, NULL ) ;
    Tcl_CreateObjCommand( inter_p, "utdmsg",utDGUI_Tcl_msg_objfunc, NULL, NULL ) ;
#endif /* UTDGUI_GRAPHICS */

    // Put the dsn name in the name space.
    if (dsn) {
      utDdstring_init( &command_buf ) ;
      dsn_cmd = utDdstring_printf( &command_buf, 
	  "set ::utdtools::designNameS %s;\n", dsn ) ;
      status = Tcl_RecordAndEval(inter_p, dsn_cmd, TCL_EVAL_GLOBAL) ;
      if( status != TCL_OK ){
	utDGUIcheck_tcl_code( inter_p, status, MSG_AT, routine) ;
      }
      utDdstring_free( &command_buf ) ;
    }
    if( begin_pgm ){
      utDdstring_init( &command_buf ) ;
      dsn_cmd = utDdstring_printf( &command_buf, 
	  "set ::utdtools::begin_pgmS %s;\n", begin_pgm ) ;
      status = Tcl_RecordAndEval(inter_p, dsn_cmd, TCL_EVAL_GLOBAL) ;
      if( status != TCL_OK ){
	utDGUIcheck_tcl_code( inter_p, status, MSG_AT, routine) ;
      }
      utDdstring_free( &command_buf ) ;
    }
    if( end_pgm ){
      utDdstring_init( &command_buf ) ;
      dsn_cmd = utDdstring_printf( &command_buf, 
	  "set ::utdtools::end_pgmS %s;\n", end_pgm ) ;
      status = Tcl_RecordAndEval(inter_p, dsn_cmd, TCL_EVAL_GLOBAL) ;
      if( status != TCL_OK ){
	utDGUIcheck_tcl_code( inter_p, status, MSG_AT, routine) ;
      }
      utDdstring_free( &command_buf ) ;
    }

    // Put the number of cuts in the name space.
    utDdstring_init( &command_buf ) ;
    dsn_cmd = utDdstring_printf( &command_buf, 
	"set ::utdtools::numPartitionS %d;\n", num_cuts ) ;
    status = Tcl_RecordAndEval(inter_p, dsn_cmd, TCL_EVAL_GLOBAL) ;
    if( status != TCL_OK ){
      utDGUIcheck_tcl_code( inter_p, status, MSG_AT, routine) ;
    }
    utDdstring_free( &command_buf ) ;


    if( do_filename ){
      script_cmds = (char *) utD_process_script( do_filename ) ;
    } else {
      script_cmds = NULL ;
    }
    if( script_cmds ){
      len = strlen( script_cmds ) ;
      line_buffer = UTDMALLOC( len + 10, char *) ;
      line_data = utDstrparser2(script_cmds,(char *)"\r\n", line_buffer, &numlines ) ; 
      Tcl_DStringInit(&tcommand) ;
      for( line = 0 ; line < numlines ; line++ ){
	fprintf( did_file, "%s\n", line_data[line] ) ;
	fflush( did_file ) ;
	Tcl_DStringAppend(&tcommand, line_data[line], strlen(line_data[line]));
	Tcl_DStringAppend(&tcommand, "\n", -1);
	cmd = Tcl_DStringValue(&tcommand) ;
	if( line_data[line][0] && !(Tcl_CommandComplete(cmd)) ){
	  continue;
	}
	status = Tcl_RecordAndEval(inter_p, cmd, TCL_EVAL_GLOBAL) ;
	if( status != TCL_OK ){
	  utDGUIcheck_tcl_code( inter_p, status, MSG_AT, routine) ;
	}
	Tcl_DStringReinit(&tcommand) ;
      }
    }

#ifdef UTDGUI_GRAPHICS
    utDGUI_run() ;
#else
    utDGUI_Tcl_run( inter_p ) ;
#endif

    utDprogram_exit(PGMOK) ;

    exit(0) ;

}


static void utdtools_tcl_init( Tcl_Interp *inter_p,const char *tcl_dir_name )
{
    INT status ;			/* return status */
    const char *error_p ;		/* error message */
    const char *tcl_autopath_name ;	/* Tcl directory for the program */
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

    // Set the autopath
    tmp_objv[0] = Tcl_NewStringObj( "lappend", -1 ) ;
    tmp_objv[1] = Tcl_NewStringObj( "auto_path", -1 ) ;
    tmp_objv[2] = Tcl_NewStringObj( tcl_autopath_name, -1 ) ;
    tmp_objv[3] = NULL ;
    status = Tcl_EvalObjv( inter_p, 3, tmp_objv, TCL_EVAL_GLOBAL | TCL_EVAL_INVOKE ) ;
    utDmsgf( IMSG,MSG_AT,NULL, "TCL Directory=%s\n", tcl_autopath_name ) ;

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

#ifdef UTDGUI_GRAPHICS

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

#endif /* UTDGUI_GRAPHICS */
