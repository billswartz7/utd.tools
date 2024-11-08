/* ----------------------------------------------------------------- 
     Copyright (c) 2005 InternetCad.com.  All rights reserved.
FILE:	    tclstdin.c
DESCRIPTION:This file contains a basic stdin channel reader for itools.
DATE:	    Sat Mar 19 01:42:17 CST 2005
REVISIONS:  
 * $Log: tclstdin.c,v $
 * Revision 1.1  2021/06/20 15:36:57  bill
 * Initial revision
 *
 * Revision 1.14  2020/07/06 14:56:34  bills
 * Now we check for the end of input so we give a proper error message when
 * Tcl runs on to the next line.
 *
 * Revision 1.13  2019/11/14 00:02:04  bills
 * Replaced inter_p->result with Tcl_GetStringResult.
 *
 * Revision 1.12  2019/09/21 04:29:22  bills
 * Fixed for off by one error.
 *
 * Revision 1.11  2019/09/17 00:46:23  bills
 * Now we don't add twpython::mode to tcommand buffer twice.  A simple constant
 * string suffices.
 *
 * Revision 1.10  2019/09/16 17:26:04  bills
 * Added line input processing for TimberWolfDR.
 *
 * Revision 1.9  2019/09/12 12:50:24  bills
 * Now properly handle a TCL_CONTINUE in a channel.   In addition, we properly
 * reset input on a successful parse.
 *
 * Revision 1.8  2019/09/11 20:12:46  bills
 * Added MMAP capability and changed from IC_xxx to TW_xxx names.   Also
 * added TWtcl_stdin_get_input function in order to handle mmap and fgets
 * data transparently.
 *
 * Revision 1.7  2019/09/02 13:42:35  bills
 * Added TWtcl_stdin_string_line_feeds and support for stdout result option.
 *
 * Revision 1.6  2019/08/26 13:54:08  bills
 * Changed from ICtclxxx to TWtclxxx and added support for integrated Python
 * interpreter.
 *
 * Revision 1.5  2019/08/20 13:39:07  bills
 * Added missing include files <unistd.h>.
 *
 * Revision 1.4  2013/02/15 20:31:43  bills
 * Updated so that exit on close works properly.
 * 
 * Revision 1.3  2013/02/14  15:40:11  bills
 * Fixed problem crashing when stdin end-of-file was detected.
 *
 * Revision 1.2  2006/05/06  22:13:22  bills
 * Major rewrite of this code in order to consolidate the stdin readers.
 * In addition, we fixed a long standing problem with the stdin reader
 * waiting for data when there is no stdin or it has been closed in
 * the parent.
 *
 * Revision 1.1  2005/11/20  06:18:17  bills
 * Initial revision
 *
----------------------------------------------------------------- */
#include <cometconfig.h>


#define FULL_UTDSTDIN_DEF

#include <utd/base.h>
#include <utd/msg.h>
#include <utd/file.h>
#include <utd/debug.h>
#include <utd/rbtree.h>
/* #include <utd/mmap.h> */
#include <utd/program.h>
/* #include <utd/set.h> */
#include <utd/string.h>
#include <utd/dstring.h>
#include <utd/tcllog.h>
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif /* HAVE_UNISTD_H */
#define VOID void
#include <tcl/tcl.h>
#include <base/tclstdin.h>
#include <base/interp.h>


/* ********************** TYPE DEFINITIONS ************************* */

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static UTDSTDIN_DATAPTR stdinS ;

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static char *utdtcl_get_script_data( UTDSCRIPT_RECPTR script_p ) ;
static void UTDtcl_stdin_proc(ClientData clientData,int mask) ;


UTDSTDIN_DATAPTR utDtcl_stdin(Tcl_Interp *inter_p,VOIDPTR input_p,FILE *did_file,char *do_file_name,UTDSTDIN_OPT_T options )
{
    UTDSTDIN_DATAPTR stdin_p ;		/* record of all stdin data */
    char *last_p ;			/* last character pointer */
    /* -----------------------------------------------------------------
     * Setup the input channel.
    ----------------------------------------------------------------- */
    stdin_p = UTDMALLOC( 1, UTDSTDIN_DATA ) ;
    stdin_p->interp = inter_p ;
    stdin_p->echo_cmds = options & UTDSTDIN_OPT_ECHO_CMDS_T ;
    stdin_p->exit_on_close = options & UTDSTDIN_OPT_EXIT_ON_CLOSE_T ;
    stdin_p->stdout_only = options & UTDSTDIN_OPT_STDOUT_ONLY_T ;
    stdin_p->stdout_result = options & UTDSTDIN_OPT_STDOUT_RESULT_T ;
    stdin_p->did_file = did_file ;
    stdin_p->do_file_name = do_file_name ;
    stdin_p->need_python_init = FALSE ;
    if( do_file_name ){
      last_p = utDstr_last_char_ptr( do_file_name ) ;
      if( last_p ){
	last_p -= 2 ; /* look for .py */
	if( strcmp( last_p, ".py") == STRINGEQ ){
	  stdin_p->need_python_init = TRUE ;
	}
      }

    }
    stdin_p->gotPartial = FALSE ;
    stdin_p->end_of_input = FALSE ;
    stdin_p->in_close_process = FALSE ;
    stdin_p->inChannel = Tcl_GetStdChannel(TCL_STDIN) ;
    stdin_p->prompt_func = utDtcl_stdinPrompt ;
    stdin_p->input_type = options & UTDTCL_INPUT_MASK ;
    if( options & UTDSTDIN_OPT_MMAP_INPUT_T ){
      /*
      stdin_p->d.mgets_p = (YMAPGETSPTR) input_p ;
      */
      stdin_p->input_buffer = NULL ;
      stdin_p->input_buffer_size = 0 ;
    } else if( options & UTDSTDIN_OPT_LINE_INPUT_T ){
      stdin_p->d.script_lines = (UTDSCRIPT_RECPTR) input_p ;
      stdin_p->input_buffer = NULL ;
      stdin_p->input_buffer_size = 0 ;
    } else {
      stdin_p->d.input_file = (FILE *) input_p ;
      stdin_p->input_buffer = UTDMALLOC( LRECL+1, char ) ;
      stdin_p->input_buffer_size = LRECL ;
    }
    stdinS = stdin_p ;
    Tcl_DStringInit(&stdin_p->line) ;
    utDdstring_init(&stdin_p->tcommand) ;
    if( options & UTDSTDIN_OPT_NO_CHANNEL_T ){
      stdin_p->use_channel = FALSE ;
    } else {
      Tcl_CreateChannelHandler(stdin_p->inChannel, TCL_READABLE, UTDtcl_stdin_proc, 
			      (ClientData) stdin_p) ;
      stdin_p->use_channel = TRUE ;
    }
    return( stdin_p ) ;
} /* end utDtcl_stdin() */


/* -----------------------------------------------------------------
 * Returns true if a Tcl stdin interpreter exists.
 * ----------------------------------------------------------------- */
BOOL utDtcl_stdinExists(void)
{
    Tcl_Channel stdin_chan ;		/* stdin channel */
    BOOL exists ;			/* if true stdin proc exists */

    stdin_chan = Tcl_GetStdChannel(TCL_STDIN) ;
    exists = Tcl_ChannelHandlerExists( stdin_chan, UTDtcl_stdin_proc, NULL, 0 ) ;
    return( exists ) ;
} /* utDtcl_stdinExists() */

void utDtcl_stdinDelete(Tcl_Interp *inter_p)
{
    Tcl_Channel stdin_chan ;		/* stdin channel */

    stdin_chan = Tcl_GetStdChannel(TCL_STDIN) ;
    Tcl_DeleteChannelHandler( stdin_chan, UTDtcl_stdin_proc, (ClientData) stdinS ) ;
    if( stdinS ){
      UTDFREE( stdinS ) ;
      stdinS = NULL ;
    }
} /* end utDtcl_stdinDelete() */

char *utDtcl_stdin_get_input( UTDSTDIN_DATAPTR stdin_p )
{
    char *data_p ;			/* data to return */
    char *cmd ;				/* command in the buffer */

    if(!(stdin_p)){
      return(NULL) ;
    }
    if( stdin_p->need_python_init ){
      stdin_p->need_python_init = FALSE ;
      utDdstring_reinit( &(stdin_p->tcommand) ) ;
      return( "utdpython::mode python" ) ;
    }

    if( stdin_p->input_type == UTDSTDIN_OPT_MMAP_INPUT_T ){
      /*
      data_p = Ymmap_gets( stdin_p->d.mgets_p ) ;
      */
    } else if( stdin_p->input_type == UTDSTDIN_OPT_LINE_INPUT_T ){
      data_p = utdtcl_get_script_data( stdin_p->d.script_lines ) ;
    } else {
      data_p = fgets( stdin_p->input_buffer, stdin_p->input_buffer_size, 
                      stdin_p->d.input_file ) ; 
    }
    if( data_p ){
      return( data_p ) ;
    } else if( stdin_p->gotPartial ){
      stdin_p->end_of_input = TRUE ;
      cmd = utDdstring_value( &(stdin_p->tcommand) ) ;
      stdin_p->gotPartial = FALSE ;
      return( cmd ) ;
    }
    return(NULL) ;
} /* end utDtcl_stdin_get_input() */

static char *utdtcl_get_script_data( UTDSCRIPT_RECPTR script_p )
{
    INT line ;				/* current line */
    char *line_p ;			/* line string */

    if( script_p ){
      line = *(script_p->line_addr) ;
      if( line >= 1 && line <= script_p->num_lines ){
	line_p = script_p->line_data[line - 1] ;
	return( line_p ) ;
      }
    }
    return(NULL) ;
} /* end utdtcl_get_script_data() */

INT utDtcl_stdin_data( Tcl_Interp *i_p, UTDSTDIN_DATAPTR stdin_p, char *line )
{
    UTDINTERPRET_MODE_T mode ;		/* interpreter mode */
    UTDDSTRINGPTR cmd_p ;		/* command to be processed */
    Tcl_Channel chan ;			/* Tcl channel */
    INT result ;			/* command result */
    INT parsing_errors ;		/* number of Python parsing errors */
    BOOL python_modes ;			/* one of the Python modes */
    char *cmd ;				/* raw command string form */
    char *errors ;			/* errors found in script */
    const char *error_p ;		/* error info */
    const char *last_p ;		/* last character of string */
    const char *result_p ;		/* result of interpreter */
    UTDDSTRING error_info ;		/* save off error information */
    FUNC_NAME("utDtcl_stdin_line") ;

    if(!(stdin_p)){
      utDmsgf(ERRMSG,MSG_AT,routine,"stdin object information not furnish\n" ) ;
      return( TCL_ERROR ) ;
    }
    mode = utDinterpreter_mode( UTDINTERPRET_GET_T ) ;
    chan = stdin_p->inChannel ;
    cmd_p = &(stdin_p->tcommand) ;

    if( (mode == UTDINTERPRET_PYTHON_T) || (mode == UTDINTERPRET_TCL_PYTHON_T) ){
      python_modes = TRUE ;
    } else {
      python_modes = FALSE ;
    }
    if( python_modes ){
       cmd = utD_PythonCommandComplete( cmd_p, line, stdin_p->gotPartial,&parsing_errors) ;
      if( !(cmd) ){
	if( stdin_p->end_of_input ){
	  utDmsgf(ERRMSG,MSG_AT,routine,"incomplete command at end-of-input:\n\t%s\n\n", utDdstring_value(cmd_p) ) ;
	  return( TCL_ERROR ) ;
	} else {
	  stdin_p->gotPartial = TRUE ;
	  return( TCL_CONTINUE ) ;
	}
      }
    } else {
      parsing_errors = 0 ;
      utDdstring_append( cmd_p, line, strlen(line) ) ;
      utDdstring_append( cmd_p, "\n", -1);
      cmd = utDdstring_value(cmd_p) ;
      if( cmd[0] && !(Tcl_CommandComplete(cmd)) ){
	if( stdin_p->end_of_input ){
	  utDmsgf(ERRMSG,MSG_AT,routine,"incomplete command at end-of-input:\n\t%s\n\n", cmd ) ;
	  return( TCL_ERROR ) ;
	} else {
	  stdin_p->gotPartial = TRUE ;
	  return( TCL_CONTINUE ) ;
	}
      }
      stdin_p->gotPartial = FALSE ;
    }

    if( stdin_p->echo_cmds ){
      fprintf( stdout, "%s\n", cmd ) ;
      fflush( stdout ) ;
    }
    if( stdin_p->did_file ){
      last_p = utDstr_last_char_ptr( cmd ) ;
      if( last_p && *last_p == '\n' ){
	fprintf( stdin_p->did_file, "%s", cmd ) ;
      } else {
	fprintf( stdin_p->did_file, "%s\n", cmd ) ;
      }
    }
    /*
     * Disable the stdin channel handler while evaluating the command;
     * otherwise if the command re-enters the event loop we might
     * process commands from stdin before the current command is
     * finished.  Among other things, this will trash the text of the
     * command being evaluated.
    */
    if( stdin_p->use_channel ){
      Tcl_CreateChannelHandler(chan, 0, UTDtcl_stdin_proc, (ClientData) stdin_p);
    }
    result = utD_RecordAndEval( i_p, cmd, TCL_EVAL_GLOBAL ) ;
    if( (result == TCL_ERROR) && (parsing_errors > 0) ){
      utDmsgf(ERRMSG,MSG_AT,routine, "you might want to enter 'utdreset()' to reset the parser.\n" ) ;
    }
    if( stdin_p->use_channel ){
      Tcl_CreateChannelHandler(chan, TCL_READABLE, UTDtcl_stdin_proc,(ClientData) stdin_p);
    }
    utDdstring_free( cmd_p ) ;
    if (result == TCL_OK) {
      result_p = Tcl_GetStringResult( i_p ) ;
      if ( result_p ) {
	if( stdin_p->stdout_only ){
	  printf("%s\n", result_p);
	} else if( stdin_p->stdout_result || stdin_p->use_channel ){
	  utDmsgf( IMSG | MSG_AVOID_DIDFILE,MSG_AT,NULL, "%s\n", result_p);
	}
	if( stdin_p->did_file ){
	  /* we write to did file directly because result may exceed buffer */
	  fprintf( stdin_p->did_file, "# %s\n", result_p) ;
	}
      }
    } else {
      utDdstring_init(&error_info) ;

      if(!(python_modes)){
	/* -----------------------------------------------------------------
	 * Now we save info because M2 might call interpreter and hose the
	 * result.
	----------------------------------------------------------------- */
	error_p = Tcl_GetVar2( i_p, "errorInfo", NULL, TCL_GLOBAL_ONLY ) ;
	if( stdin_p->do_file_name ){
	  utDdstring_append(&error_info, 
	    utDmsgf(ERRMSG|MSG_RETURN_STRING,MSG_AT,routine, "do file:%s [line:%d]\n", 
	      stdin_p->do_file_name, stdin_p->do_file_line), -1 ) ;
	}
	
	result_p = Tcl_GetStringResult( i_p ) ;
	if (result_p) {
	  utDdstring_append(&error_info, " :\n", -1 ) ;
	  utDdstring_append(&error_info, result_p, -1 ) ;
	  utDdstring_append(&error_info, "\nstack trace:", -1 ) ;
	} else {
	  utDdstring_append(&error_info, "stack trace:", -1 ) ;
	}
	if( error_p ){
	  utDdstring_append(&error_info, error_p, -1 ) ;
	} else {
	  utDdstring_append(&error_info, "none available", -1 ) ;
	}


	/* Now safe to output the errors */
	errors = utDdstring_value(&error_info) ;
	if( errors ){
	  utDmsgf(ERRMSG,MSG_AT,NULL, "%s\n", errors ) ;
	} else {
	  utDmsgf(ERRMSG,MSG_AT,NULL, "\n" ) ;
	}
      }

/*
      if( graphics_display_msg ){
	(*graphics_display_msg)( i_p, errors ) ;
      }
      */

      utDdstring_free(&error_info) ;

    }
    Tcl_ResetResult(i_p) ;
    if( stdin_p->gotPartial ){
      stdin_p->gotPartial = FALSE ;
      result = utDtcl_stdin_data( i_p, stdin_p, line ) ;
    }
    if(!(stdin_p->gotPartial)){
      utDdstring_reinit( cmd_p ) ;
    }
    return( result ) ;

} /* end utDtcl_stdin_data() */

INT utDtcl_stdin_line( UTDSTDIN_DATAPTR stdin_p, INT line_num )
{
    if(!(stdin_p)){
      return(-1) ;
    }
    if( line_num >= 0 ){
      stdin_p->do_file_line = line_num ;
    }
    return( stdin_p->do_file_line ) ;
} /* end utDtcl_stdin_line() */

void utDtcl_stdin_strip_line_feeds( char *bufferptr )
{
    char *last_p ;	/* last character of string */
    while( TRUE ){
      last_p = utDstr_last_char_ptr( bufferptr ) ;
      if( last_p ){
	if( *last_p == '\n' || *last_p == '\r' ){
	  *last_p = EOS ;
	} else {
	  break ;
	}
      } else {
	break ;
      }
    }
} /* end utDtcl_stdin_strip_line_feeds() */

/*----------------------------------------------------------------------
 *
 * UTDtcl_stdin_proc --
 *
 *	This procedure is invoked by the event dispatcher whenever
 *	standard input becomes readable.  It grabs the next line of
 *	input characters, adds them to a command being assembled, and
 *	executes the command if it's complete.
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	Could be almost arbitrary, depending on the command that's
 *	typed.
 *
 *----------------------------------------------------------------------
 */
static void UTDtcl_stdin_proc(ClientData clientData,int mask)
{
    INT len ;				/* length of buffer */
    char *cmd ;				/* the Tcl command */
    char *line ;			/* current line */
    INT count ;				/* number of characters in command */
    INT status ;			/* return status */
    INT result ;			/* result code */
    INT line_len ;			/* line length */
    BOOL eof ;				/* eof is found */
    BOOL isa_tty ;			/* is a tty */
    BOOL blocked ;			/* channel is blocked */
    BOOL exit_on_close ;		/* exit on close */
    Tcl_Channel chan ;			/* Tcl channel */
    Tcl_Interp *i_p ;			/* current Tcl interpreter */
    Tcl_DString *line_p ;		/* line info */
    const char *error_p ;		/* error message */
    UTDSTDIN_DATAPTR stdin_p ;		/* record of all stdin data */
    UTDINTERPRET_MODE_T mode ;		/* interpreter mode */
    
    stdin_p = (UTDSTDIN_DATAPTR) clientData ;
    /* Problem with Tcl */
    if( !(stdin_p) || !(stdinS) ){
      return ; 
    }
    chan = stdin_p->inChannel ;
    i_p = stdin_p->interp ;
    line_p = &(stdin_p->line) ;

    do {
      count = Tcl_Gets(chan, line_p) ;
      if (count < 0 && !(stdin_p->gotPartial) ) {
	blocked = Tcl_InputBlocked( chan ) ;
	eof = Tcl_Eof( chan ) ;
	if ( blocked ){
	  return ;
	}
	isa_tty = isatty(0) ;
	exit_on_close = stdin_p->exit_on_close  ; /* copy value */
	if( eof ){
	  if( !(stdin_p->in_close_process) ){
	    stdin_p->in_close_process = TRUE ;
	    if( isa_tty ){
	      utDmsgf(WARNMSG,MSG_AT,"stdin", "stdin end-of-file detected.  Channel is closed.\n" ) ;
	    } else {
	      utDmsgf(IMSG,MSG_AT,"stdin", "stdin end-of-file detected.  Channel is closed.\n" ) ;
	    }
	  }
	  utDtcl_stdinDelete( i_p ) ;
	}
	if( isa_tty || exit_on_close ){
	  utDtcllog_exit() ;
	  utDprogram_exit(PGMOK) ;
	}
	return ;
      }

      line = Tcl_DStringValue(line_p) ;
      line_len = strlen(line) ;
      /* Look to see if we have a reset */
      if( line_len >= 10 ){
	if( utDstricmp( line + (line_len - 10), "utdreset()") == STRINGEQ ){
	  Tcl_DStringReinit( line_p ) ;
	  Tcl_DStringAppend( line_p, "print('resetting Python interpreter.  You should be OK now.')", -1 ) ;
	}
      }
      status = utDtcl_stdin_data( i_p, stdin_p, line ) ;

    } while( status == TCL_CONTINUE ) ;

    Tcl_DStringReinit(line_p) ;

    /*
     * Output a prompt.
     */

    prompt:
      if ( stdin_p->prompt_func ){
	(*stdin_p->prompt_func)( stdin_p->interp, stdin_p->gotPartial ) ;
      } else {
	mode = utDinterpreter_mode( UTDINTERPRET_GET_T ) ;
	if( (mode == UTDINTERPRET_PYTHON_T) || (mode == UTDINTERPRET_TCL_PYTHON_T) ){
	  fprintf( stdout, ">>> ");
	} else {
	  fprintf( stdout, "%% ");
	}
	fflush(stdout);
      }
      Tcl_ResetResult(i_p) ;

} /* end utDtcl_stdin_proc() */

void utDtcl_stdinPrompt(Tcl_Interp *interp,INT partial)
{
    INT code ;
    const char *promptCmd ;
    const char *result_p ;		/* result of interpreter */
    UTDINTERPRET_MODE_T mode ;		/* interpreter mode */

    promptCmd = Tcl_GetVar(interp,
	partial ? "tcl_prompt2" : "tcl_prompt1", TCL_GLOBAL_ONLY);
    if (promptCmd) {
      code = Tcl_Eval(interp, promptCmd);
      if (code != TCL_OK) {
	Tcl_AddErrorInfo(interp, "\n    (script that generates prompt)" ) ;
	result_p = Tcl_GetStringResult( interp ) ;
	utDmsgf(IMSG,MSG_AT,NULL, "%s\n", result_p);
      } else {
	return ;
      }
    } 
    if ( !(partial) ){
      mode = utDinterpreter_mode( UTDINTERPRET_GET_T ) ;
      if( (mode == UTDINTERPRET_PYTHON_T) || (mode == UTDINTERPRET_TCL_PYTHON_T) ){
	utDmsgf(IMSG | MSG_AVOID_DIDFILE, MSG_AT, NULL, ">>> "  ) ;
      } else {
	utDmsgf(IMSG | MSG_AVOID_DIDFILE, MSG_AT, NULL, "%% "  ) ;
      }
    }
    fflush(stdout);
} /* end utDtcl_stdinPromp() */

