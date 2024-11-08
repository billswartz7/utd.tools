/* ----------------------------------------------------------------- 
     Copyright (c) 2019 William Swartz.  All rights reserved.
FILE:	    utils.c                                       
DESCRIPTION:Common GUI utility commands.
REVISIONS: 
----------------------------------------------------------------- */
#ifndef lint
static char SccsId[] = 
"$RCSfile$ $Revision$ $Date$" ;
#endif

#include "config.h"
#include <utd/base.h>
#include <utd/string.h>
#include <utd/dstring.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/program.h>
#include <utd/tcllog.h>
#include <tcl/tcl.h>
#include <blt/blt.h>
#define UTDGUI_NOGRAPHICS
#include <gui/interactive.h>
#include <gui/open_gui.extra.h>
#include <gui/utils.h>

/* ********************** TYPE DEFINITIONS ************************* */


/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static void tcl_prompt( Tcl_Interp *interp, InteractiveState *isPtr) ;
static void tcl_stdinProc( ClientData clientData, int mask) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static BOOL tcl_wait_loopS ;


void utDGUIcheck_tcl_code(Tcl_Interp *interp, INT code, const char *label,const char *routine) {

  char command[LRECL] ;
  const char *result_p ;

  if (code != TCL_OK) {
    result_p = Tcl_GetStringResult(interp) ;
    if( result_p ){
      utDmsgf( ERRMSG, label, routine, "%s\n", result_p ) ;
    }
    sprintf( command, "set errorInfo\n" ) ;
    code = Tcl_GlobalEval( interp, command ) ;
    if( code == TCL_OK ){
      utDmsgf( ERRMSG, label, routine, "stack trace:%s\n", Tcl_GetStringResult(interp)) ;
    }
  }
} /* end utDGUIcheck_tcl_code() */

/* -----------------------------------------------------------------
 * This is what we call from user program when no graphics are specified.
 * ----------------------------------------------------------------- */
BOOL utDGUI_Tcl_init( int argc,char *argv[],Tcl_Interp *interp, FILE *did_file)
{

  InteractiveState *is_p ;		/* client data for Tcl interpreter */
  Tcl_Channel chan ;			/* Tcl channel for interpreter */
  Tcl_Obj *argvPtr ;			/* Tcl arg vector object */
  Tcl_Obj *appName ;			/* Applicate name object */
  int code ;				/* return code */
  char **pargv ;			/* copy of pargv */
  int pargc ;				/* copy of argc */
  FUNC_NAME("utDGUI_Tcl_init") ;

  Tcl_InitMemory(interp);

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

  /*
   * Establish a channel handler for stdin.
   */

  is_p->input = Tcl_GetStdChannel(TCL_STDIN);
  if (is_p->input) {
      Tcl_CreateChannelHandler(is_p->input, TCL_READABLE, tcl_stdinProc, is_p) ;
  }
  if (is_p->tty) {
      tcl_prompt(interp, is_p) ;
  }

  chan = Tcl_GetStdChannel(TCL_STDOUT);
  if (chan) {
      Tcl_Flush(chan);
  }
  Tcl_DStringInit( &(is_p->command) );
  Tcl_DStringInit( &(is_p->line) );
  Tcl_ResetResult(interp);

} /* end utDGUI_Tcl_init() */

/* -----------------------------------------------------------------
 * These are replacement routines for the graphical counterparts
 * ----------------------------------------------------------------- */
void utDGUI_Tcl_run( Tcl_Interp *interp )
{
    if( interp ) {
      tcl_wait_loopS = TRUE ;
      while( tcl_wait_loopS ){
	Tcl_DoOneEvent(TCL_ALL_EVENTS | TCL_SERVICED_EVENT ) ;
      }
      tcl_wait_loopS = TRUE ; /* retrigger */
    }
} /* end utDGUI_Tcl_run() */

INT utDGUI_Tcl_continue_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[])
{
    const char *at ;			/* label position */
    FUNC_NAME("utdcontinue") ;

    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n" );
      utDmsgf(ERRMSG,at,NULL, "utdcontinue : exit a Tcl wait loop and \
continue program execution.\n");
      return(TCL_OK) ;
    }
    tcl_wait_loopS = FALSE ;
    return(TCL_OK) ;
} /* end continue_objfunc() */


INT utDGUI_Tcl_wait_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[])
{
    const char *at ;			/* label position */
    FUNC_NAME("utdwait") ;

    if( utDhelp_requested(objc,objv) ){
      at = MSG_AT ;
      utDmsgf(ERRMSG,at,routine, "Help:\n" );
      utDmsgf(ERRMSG,at,NULL, "utdwait : enter a Tcl wait loop for processing \
commands.\n" ) ;
      return(TCL_OK) ;
    }

    utDGUI_Tcl_run( i_p ) ;

    return(TCL_OK) ;
} /* end utDGUI_Tcl_wait_objfunc() */


INT utDGUI_Tcl_msg_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[])
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
  }
  return(TCL_OK) ;

} /* end utDGUI_Tcl_msg_objfunc() */


/*
 *----------------------------------------------------------------------
 *
 * tcl_stdinProc --
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
void tcl_stdinProc(
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
	    Tcl_DeleteChannelHandler(chan, tcl_stdinProc, isPtr);
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

    Tcl_CreateChannelHandler(chan, 0, tcl_stdinProc, isPtr);
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
	Tcl_CreateChannelHandler(isPtr->input, TCL_READABLE, tcl_stdinProc, isPtr);
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
	tcl_prompt(interp, isPtr);
    }
    Tcl_ResetResult(interp);
}

/*
 *----------------------------------------------------------------------
 *
 * tcl_prompt --
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
tcl_prompt(
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
} /* end tcl_prompt() */
