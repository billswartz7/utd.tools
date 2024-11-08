/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    msg.h
DESCRIPTION:Definitions for message and logging.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_MSG_H
#define INCLUDED_UTD_MSG_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* normal messages */
typedef enum {
  MSG =       		0,	/* 0000  */
  IMSG =       		1,	/* 0001  */
  ERRMSG =    		2,	/* 0010  */
  WARNMSG =     	3,	/* 0011  */
  DBGMSG =     		4,	/* 0100  */

  /* restricted messages cannot go to the message function if defined */
  MSG_RESTRICTED =	(1 << 3),

  MSG_GRAPHICS = 	(1 << 4), /* generated and limited to graphics system. */

  MSG_OUTPUT_MTYPE = 	(1 << 5), /* force output message type when routine=0 */

  /* -----------------------------------------------------------------
   * Request a new line before printing the message.  This option only 
   * appies to a MSG, IMSG, ... with a routine name. Message types without
   * a routine name can put the \n in the user string without any problems.
  ----------------------------------------------------------------- */
  MSG_PRELINE = 	(1 << 6), /*     10000  */
  MSG_IGNORE_INCR = 	(1 << 7), /*    100000  */
  MSG_CONTROL = 	(1 << 8), /*   1000000  */
  MSG_RETURN_STRING =  	(1 << 9), /*1000000000  */
  MSG_ROUTINE_NEWLINE = (1 <<10), 
  MSG_AVOID_STDOUT = 	(1 <<11),
  MSG_AVOID_GRAPHICS = 	(1 <<12),
  MSG_AVOID_FILE = 	(1 <<13),
  MSG_AVOID_LOG = 	(1 <<14), 
  MSG_AVOID_DIDFILE = 	(1 <<15),
  MSG_AVOID_ERRORFILE = (1 <<16),
  MSG_AVOID_WARNFILE = 	(1 <<17),
  MSG_CNTRL_ROUTINE =	(1 <<18),
  MSG_KILL_T =		(1 <<19),
  MSG_TCL_INTERP =	(1 <<20), /* add to Tcl interpreter as well */
  MSG_AVOID_STATS =	(1 <<21)  /* don't output stats */
} MSG_TYPE_T ;

/* how to get the message type strip off the bits except last three */
#define GET_MESSAGE_TYPE(msg)	(msg & 0x7)
#define GET_SIMPLE_MESSAGE_TYPE(msg)	(msg & 0x3F)

typedef enum {
  M_NONE =     (0),
  M_NORMAL =   (1),
  M_VERBOSE =  (1 << 1),
  M_SILENT =   (1 << 2),
  M_MUTE =     (1 << 3),
  M_HOSTNAME = (1 << 4),    /* will print host name with routine name */
  M_STDERR =   (1 << 5)     /* This redirects stderr to stdout */
} MSG_OPT_T ;

/* -----------------------------------------------------------------
 * Message type for message function.
----------------------------------------------------------------- */
typedef enum {
  MESSAGE_UNKNOWN_T = 0,
  MESSAGE_STDOUT_T = 1,
  MESSAGE_GRAPHICS_T = 2,
  MESSAGE_FILE_T = 3,
  MESSAGE_LOG_T = 4,
  MESSAGE_DIDFILE_T = 5,
  MESSAGE_ERRORFILE_T = 6,
  MESSAGE_WARNFILE_T = 7
} MESSAGE_T ;

/* -----------------------------------------------------------------
 * Message function options types.
----------------------------------------------------------------- */
typedef enum {
  MSGFUNC_OPT_NONE = 		0,
  MSGFUNC_OPT_RESTRICTED = 	1,
  MSGFUNC_OPT_FLUSH = 		(1 << 1),
  MSGFUNC_OPT_CLOSE = 		(1 << 2)
} MSGFUNC_OPTS_T ;


/* -----------------------------------------------------------------
 * Macros to locate the current position in the source file.
----------------------------------------------------------------- */
#define MSG_STRINGIFY(x) #x
#define MSG_TOSTRING(x) MSG_STRINGIFY(x)
#define MSG_AT __FILE__ ":" MSG_TOSTRING(__LINE__)

/* -----------------------------------------------------------------
 * The length of the longest message.
----------------------------------------------------------------- */
#define MESSAGE_BUF_LEN		4*LRECL

/* type of system error messages */
#define MSE_NOABORT  (0)
#define MSE_ABORT    (1)
#define MSE_NOERROR  (1 << 1)
#define MSE_EXIT     (MSE_ABORT|MSE_NOERROR)
/* -----------------------------------------------------------------
 * Four cases:
 * check_errno      noabort     0   FALSE  * using true and false.
 * check_errno      abort       1   TRUE   *
 * dont_check_errno noabort     2   
 * dont_check_errno abort       3  
----------------------------------------------------------------- */

/* -----------------------------------------------------------------
 * You may only use Ymessage_print2 when you are sure you are under the
 * MESSAGE_BUF_LEN limit.  Ymessage_print is dynamic now and has no limit.
 * Now returns the message string if MSG_RETURN_STRING option is set; otherwise
 * returns NULL.
----------------------------------------------------------------- */
extern const char *utDmsg(INT messageType, const char *label,const char *routine,const char *message ) ;
extern const char *utDmsgf(INT messageType,const char *label,const char *routine,const char *messageString,...) ;
/* 
Function:
    Print a message to screen and/or to a file.  There are the following
    types of messages:
    TYPE  MODE                      ACTION
    ----  ----                      ------
    MSG   Normal                    Written to stdout.
	  File Redirect             Written to file.
          File Redirect & verbose   Written to stdout and to given file.
          Silent                    Ignored.
          Silent && File Redirect   Written to file.
 ERRMSG   Normal                    Written to stderr. Error count incremented.
	  File Redirect             Written to file & stderr. Error count inc.
          File Redirect & verbose   Written to file & stderr. Error count inc.
          Silent                    Written to stderr. Error count incremented.
          Silent && File Redirect   Written to file & stderr. Error count inc.
 DBGMSG   Normal                    Written to stdout.
	  File Redirect             Written to file.
          File Redirect & verbose   Written to stdout and to given file.
          Silent                    Ignored.
          Silent && File Redirect   Written to file.
WARNMSG   Normal                    Written to stderr.  Warning count inc.
	  File Redirect             Written to file.    Warning count inc.
          File Redirect & verbose   Written to stderr and to given file. WC inc.
          Silent                    Written to stderr. WC incremented.
          Silent && File Redirect   Written to file & stderr. WC inc.
*/


extern VOIDPTR utDmsg_func(void (*func)(const char *message,INT type,void *client_data),
			  MESSAGE_T type, void *client_data, 
			  INT options) ;
/*
Function:
    Install a message function.  If a message function is supplied,
    all messages will be redirected to this function.  Multiple message
    functions are possible.  If all message functions are deleted, 
    then all messages will go to stdout.  The default is no message functions.
    Type describes the type of message function so we can delete by function
    type rather than an instance basis.  The client_data field is used by
    the user to pass stream pointer, graphics pointer, etc.  Returns an
    opaque object which allows user to delete installed object.
*/
extern BOOL utDmsg_func_delete( void (*func)(const char *message,INT message_type,
                                void *client_data) );
/*
Function:
    Delete a message function.  Returns true if successful.
*/

extern BOOL utDmsg_func_objDelete( VOIDPTR msg_obj_p ) ;
/*
Function:
    Delete a message function given a message object.  Returns true if successful.
*/

extern BOOL utDmsg_func_delete_type(MESSAGE_T type) ;
/*
Function:
    Delete a message function of a given type type. Returns true if at least
    one message handler was deleted.
*/

extern BOOL utDmsg_func_delete_clientData(VOIDPTR clientData) ;
/*
Function:
    Delete a message function of a given client data. Returns true if at least
    one message handler was deleted.
*/

extern void utDmsg_file_msg( const char *message, INT type, void *clientData ) ;
/*
Function:
    Useful as a general purpose file message function.  Just performs
    fprintf( fp, "%s", message ) ;
*/

extern void utDmsg_stream_msg( const char *message, INT type, void *clientData ) ;
/*
Function:
    Useful as a general purpose stream message function.  Just performs
    write( fd, message, strlen(message) ) ;
*/

extern void utDmsg_stdout_msg( const char *message, INT type, void *clientData ) ;
/*
Function:
    Properly redirects errors and warnings to stderr.  Otherwise sends output
    to stdout.
*/

extern INT utDmsg_tcl_options( INT type, char *str ) ;
/*
Function:
    Process any Tcl options to the message function.   Functionally, equivalent
    to the | options given in the C version.  Returns type modified with the
    control options.
*/

extern void utDmsg_warn_count( void ) ;
/*
Function:
    Increment the warning count.
*/

extern void utDmsg_error_count( void ) ;
/*
Function:
    Increment the error count.
*/

extern INT utDmsg_get_warncount( void ) ;
/*
Function:
    Returns the warning count.
*/

extern INT utDmsg_get_errorcount( void ) ;
/*
Function:
    Returns the error count.
*/

extern INT utDmsg_get_ignored_warncount( void ) ;
/*
Function:
    Returns the ignored warning count.
*/

extern INT utDmsg_get_ignored_errorcount( void ) ;
/*
Function:
    Returns the ignored error count.
*/

extern void utDmsg_error_reset( void ) ;
/*
Function:
    Resets the error count.
*/


extern void utDmsg_queued( INT mtype, char *routine, char *message ) ;
/*
Function:
    Put a message in the queue only to be output if flushed.
*/


extern void utDmsg_mode( INT mode ) ;
/* 
Function:
    Set the message mode. It may be
	( one of M_VERBOSE, M_NORMAL, or M_SILENT) | M_HOSTNAME
*/

extern INT utDmsg_get_mode( void ) ;
/* 
Function:
    Returns the state of the message mode switch.
*/

extern void utDmsg_flush( void ) ;
/* 
Function:
    Flush the buffered output.
*/

extern void utDmsg_close( void ) ;
/* 
Function:
    Close the output streams.
*/

extern void utDmsg_syserr(INT abort,const char *routine,const char *format, ... ) ;
/* 
Function:
    Outputs a system error. This function outputs the system error
    string. messageString should not have a new line character.
    It is furnished automatically at the end of the system message.
    If abort is 1, the program will exit.  See above section for other
    codes.
*/

extern void utDmsg_hostnameSuffix(INT host_suffix) ;
/* 
Function:
    Used in parallel output.  Distinguish processor number.
*/

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_MSG_H */
