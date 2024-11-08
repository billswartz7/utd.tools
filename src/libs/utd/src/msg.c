/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    msg.c 
DESCRIPTION: message and logging functions                                     
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <stdio.h>

#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif /* HAVE_STDARG_H */

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif /* UNISTD_H */

#include <utd/base.h>
#include <utd/bitset.h>
#include <utd/debug.h>
#include <utd/msg.h>
#include <utd/file.h>
#include <utd/dstring.h>
// #include <utd/log.h>
#include <utd/system.h>
#include <utd/string.h>

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif /* HAVE_ERRNO_H */

/* ********************** TYPE DEFINITIONS ************************* */
#define MSG_BUF_OVERHEAD 20
#define HOSTNAMELEN	255

typedef struct message_func_rec {
    struct message_func_rec *next_msg ;
    struct message_func_rec *prev_msg ;
    void (*message_func)(const char *msg,INT t,void *d); /* user output function */
    void *message_data ;			   /* opaque data pointer */
    MESSAGE_T message_type ;			   /* type of function */
    UNSIGNED_INT close : 8 ;			   /* close file on command */
    UNSIGNED_INT flush : 8 ;			   /* message must be flushed */
    UNSIGNED_INT restricted_msg : 16 ;		   /* this msg is restricted */
} MESSAGEBOX, *MESSAGEPTR ;

typedef struct msg_var_rec {
  INT errorCount ;		/* error count */
  INT ignoredErrorCount ;	/* ignored error count */
  INT warningCount ;		/* warning count */
  INT ignoredWarningCount ;	/* warning count */
  INT queued_mtype ;		/* queued message */
  INT mode ;			/* the mode - verbose, silent, etc. */
  char type[10] ;		/* type of message */
  char *hostname ;		/* name of host */
  char *hostnameSuffix ;	/* index name of host */
  char *queued_message ;	/* queued message */
  char *queued_routine ;	/* queued routine */
  MESSAGEPTR msg_func ;		/* list of message functions */
  UTDDSTRING dbuf ;		/* dynamic string buffer */
  UTDDSTRINGPTR dstring ;	/* dynamic string pointer */
  UTDDSTRING rdbuf ;		/* restricted dynamic string buffer */
  UTDDSTRINGPTR rdstring ;	/* restricted dynamic string pointer */
  UTDDSTRING m2buf ;		/* dynamic string buffer */
  UTDDSTRINGPTR m2dstring ;	/* dynamic string pointer */
} MSG_DATA, *MSG_DATAPTR ;


/* ***************** STATIC FUNCTION DEFINITIONS ******************* */

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static MSG_DATA msgS ;

/* global variable definition */
#ifdef WINDOZE
#define EXPORT_VAR	_export
#else
#define EXPORT_VAR
#endif

const char *utDmsg(INT messageType, const char *label, const char *routine, const char *messageString)
{
    INT buf_len ;		/* buffer length */
    INT msg_len ;		/* length of message */
    INT msg_type ;		/* basic type */
    FILE *out ; 		/* where to output result if verbose */
    char *buffer ;		/* output buffer */
    char *queued ;		/* queued message */
    BOOL new_line;		/* new line was requested */
    BOOL suppressed ;		/* suppressed message */
    BOOL output_msg ;		/* output message */
    BOOL ignore_increment ;	/* ignore incrmenting error or warning count */
    BOOL restricted_msg ;	/* message is restricted */
    BOOL msg_control ;		/* message control */
    BOOL message_kill ;		/* message needs to be killed */
    BOOL message_ret_str ;	/* just return the string */
    BOOL need_increment_flag ;	/* need to increment warn/error counter */
    BOOL override_suppressed ;	/* over ride suppressed message arg because of errfile */
    MESSAGE_T msg_func_type ;	/* message function type */
    MESSAGEPTR msg ;		/* enumerate message functions */
    UTDDSTRINGPTR dstring_p ;  /* current dynamic string */

    if( msgS.queued_message ){
      queued = msgS.queued_message ;
      msgS.queued_message = NULL ;
      utDmsg( msgS.queued_mtype, label, msgS.queued_routine, queued ) ;
    }
    /* -----------------------------------------------------------------
     * See if we have an ignore_count option so we don't increment the 
     * error or warning counts on a program.
    ----------------------------------------------------------------- */
    msg_control = messageType & MSG_CONTROL ;
    ignore_increment = messageType & MSG_IGNORE_INCR ;
    new_line = messageType & MSG_PRELINE ;
    restricted_msg = messageType & MSG_RESTRICTED ;
    message_ret_str = messageType & MSG_RETURN_STRING ;
    message_kill = messageType & MSG_KILL_T ;
    if( message_kill ){
      return(NULL) ;
    }

    /* -----------------------------------------------------------------
     * See if we have a suppressed message.
     * ----------------------------------------------------------------- */
    suppressed = FALSE ;
    override_suppressed = FALSE ;
#ifdef LATER
    if( msg_control && routine ){
      if(!(Ywarnctrl(routine))){
	suppressed = TRUE ;
	ignore_increment = TRUE ;
      }
    }
#endif /* LATER */
    if( messageType & MSG_CNTRL_ROUTINE ){
      routine = NULL ; /* called from utDmsgf */
      need_increment_flag = TRUE ;
    } else {
      need_increment_flag = FALSE ;
    }

    /* determine message type */
    msg_type = GET_MESSAGE_TYPE(messageType) ;
    switch( msg_type ){
	case MSG:msgS.type[0] = EOS;  /* no need for an explanation */
		out = stdout ;
		break ;
	case IMSG:msgS.type[0] = EOS;  /* no need for an explanation */
		out = stdout ;
		break ;
	case ERRMSG:sprintf(msgS.type,"ERROR");
		DS(ebreak() ;)	/* offer a break in the debugger */
		out = stderr ;
		fflush( stdout ) ;
		if( routine ){
		  if( ignore_increment ){
		    strcat( msgS.type, "_" ) ;
		    if(!(message_ret_str)){
		      msgS.ignoredErrorCount++ ;
		    }
		  } else {
		    /* error message should always have routine */
		    /* continuation of a message doesn't count */
		    if(!(message_ret_str)){
		      msgS.errorCount++;
		    }
		  }
		} else if( need_increment_flag ){
		  if( ignore_increment ){
		    if(!(message_ret_str)){
		      msgS.ignoredErrorCount++ ;
		    }
		  } else {
		    /* error message should always have routine */
		    /* continuation of a message doesn't count */
		    if(!(message_ret_str)){
		      msgS.errorCount++;
		    }
		  }
		}
		break ;
	case WARNMSG:strcpy(msgS.type,"WARNING");
		DS(wbreak() ;)	/* offer a break in the debugger */
		out = stderr ;
		fflush( stdout ) ;
		if( routine ){
		  if( ignore_increment ){
		    strcpy( msgS.type, "URGENT" ) ;
		    if(!(message_ret_str)){
		      msgS.ignoredWarningCount++ ;
		    }
		  } else {
		    /* warning message should always have routine */
		    /* continuation of a message doesn't count as new */
		    /* warning message */
		    if(!(message_ret_str)){
		      msgS.warningCount++;
		    }
		  }
		} else if( need_increment_flag ){
		  if( ignore_increment ){
		    if(!(message_ret_str)){
		      msgS.ignoredWarningCount++ ;
		    }
		  } else {
		    /* error message should always have routine */
		    /* continuation of a message doesn't count */
		    if(!(message_ret_str)){
		      msgS.ignoredWarningCount++ ;
		    }
		  }
		}
		break ;
	case DBGMSG:sprintf(msgS.type,"DEBUG");
#ifdef DEBUGLATER
		if( utDdebugAssert() ){
		  out = stdout ;
		} else {
		  return(NULL) ;
		}
		break ;
#else /* NO DEBUG */
		return(NULL) ; /* no output message */
#endif /* DEBUG */
	default :msgS.type[0] = EOS;  /* no need for an explanation */
		out = stdout ;
    }


    /* -----------------------------------------------------------------
     * Now we need to setup the dynamic string buffer.
    ----------------------------------------------------------------- */
    if( restricted_msg ){
      if(!(msgS.rdstring)){
	msgS.rdstring = &msgS.rdbuf ;
	utDdstring_init(msgS.rdstring) ;
      }
      dstring_p = msgS.rdstring ;
    } else {
      if(!(msgS.dstring)){
	msgS.dstring = &msgS.dbuf ;
	utDdstring_init(msgS.dstring) ;
      }
      dstring_p = msgS.dstring ;
    }
    utDdstring_reinit(dstring_p) ;

    /* -----------------------------------------------------------------
     * Now build the output string.
    ----------------------------------------------------------------- */
    if( routine ){
      if( messageString ){
	msg_len = strlen(messageString) ;
      } else {
	msg_len = 0 ;
      }
      buf_len = strlen( msgS.type ) + strlen( routine ) + msg_len +
		MSG_BUF_OVERHEAD ;
      if( msgS.hostname ){
	buf_len += strlen(msgS.hostname) ;
	if( msgS.hostnameSuffix ){
	  buf_len += strlen(msgS.hostnameSuffix) ;
	}
      }
      buffer = utDdstring_setlength(dstring_p,buf_len) ;

      if( new_line ){
	sprintf( buffer,"\n%s[%s", msgS.type, routine ) ;
      } else {
	sprintf( buffer,"%s[%s", msgS.type, routine ) ;
      }
      if( msgS.hostname ){
	strcat( buffer, "@" ) ;
	strcat( buffer, msgS.hostname ) ;
	if( msgS.hostnameSuffix ){
	  strcat( buffer, msgS.hostnameSuffix ) ;
	}
      }
      strcat( buffer, "]:" ) ;
      if( messageString ){
	strcat( buffer, messageString ) ;
      }
      messageString = buffer ;

    } else if( messageType & MSG_OUTPUT_MTYPE ){
      if( messageString ){
	msg_len = strlen(messageString) ;
      } else {
	msg_len = 0 ;
      }
      buf_len = strlen( msgS.type ) + msg_len + MSG_BUF_OVERHEAD ;
      buffer = utDdstring_setlength(dstring_p,buf_len) ;

      if( new_line ){
	sprintf( buffer,"\n%s:", msgS.type ) ;
      } else {
	sprintf( buffer,"%s:", msgS.type ) ;
      }
      if( messageString ){
	strcat( buffer, messageString ) ;
      }
      messageString = buffer ;
    }

    /* -----------------------------------------------------------------
     * We need to really see if we can suppress early or continue on
     * because of error and warn files.
     * ----------------------------------------------------------------- */
    if( suppressed && msgS.msg_func ){
      if( (msg_type == ERRMSG) || (msg_type == WARNMSG) ){
	/* look to see if we have a matching msg function */
	for( msg = msgS.msg_func ; msg ; msg = msg->next_msg ){
	  msg_func_type = msg->message_type ;
	  if( (msg_func_type == MESSAGE_ERRORFILE_T) && (msg_type == ERRMSG) ){
	    override_suppressed = TRUE ;
	    break ;
	  } else if( (msg_func_type == MESSAGE_WARNFILE_T) && (msg_type == WARNMSG) ){
	    override_suppressed = TRUE ;
	    break ;
	  }
	}
      }
    }
    if( message_ret_str || (suppressed && !(override_suppressed)) ){
      return( messageString ) ;
    }


    if( msgS.mode & M_STDERR ){
      out = stdout ;
    }
    if( msgS.msg_func ){
      for( msg = msgS.msg_func ; msg ; msg = msg->next_msg ){
	if (restricted_msg && !(msg->restricted_msg) ){
	  continue ;
	}
	msg_func_type = msg->message_type ;
	if( msg_func_type == MESSAGE_STDOUT_T ){
	  if( messageType & MSG_AVOID_STDOUT ){
	    continue ;
	  }
	  if( override_suppressed ){
	    continue ;
	  }
	} else if( msg_func_type == MESSAGE_GRAPHICS_T ){
	  if( messageType & MSG_AVOID_GRAPHICS ){
	    continue ;
	  }
	  if( override_suppressed ){
	    continue ;
	  }
	} else if( msg_func_type == MESSAGE_FILE_T ){
	  if( messageType & MSG_AVOID_FILE ){
	    continue ;
	  }
	  if( override_suppressed ){
	    continue ;
	  }
	} else if( msg_func_type == MESSAGE_LOG_T ){
	  if( messageType & MSG_AVOID_LOG ){
	    continue ;
	  }
	  if( override_suppressed ){
	    continue ;
	  }
	} else if( msg_func_type == MESSAGE_DIDFILE_T ){
	  if( messageType & MSG_AVOID_DIDFILE ){
	    continue ;
	  }
	  if( override_suppressed ){
	    continue ;
	  }
	} else if( msg_func_type == MESSAGE_ERRORFILE_T ){
	  if( msg_type != ERRMSG ){
	    continue ;
	  }
	  if( messageType & MSG_AVOID_ERRORFILE ){
	    continue ;
	  }
	} else if( msg_func_type == MESSAGE_WARNFILE_T ){
	  if( msg_type != WARNMSG ){
	    continue ;
	  }
	  if( messageType & MSG_AVOID_WARNFILE ){
	    continue ;
	  }
	} 

	output_msg = FALSE ;
	if( msg_type == ERRMSG ){
	  output_msg = TRUE ;
	} else if( msg_type == WARNMSG ){
	  if( BITMODE(msgS.mode,M_MUTE) &&
	    (msg_func_type != MESSAGE_WARNFILE_T) ){
	    output_msg = FALSE ;
	  } else {
	    output_msg = TRUE ;
	  }
	} else {
	  if( BITMODE(msgS.mode,M_VERBOSE) ){
	    output_msg = TRUE ;
	  } else {
	    if( BITMODE(msgS.mode,M_MUTE) ){
	      switch( msg_func_type ){
		case MESSAGE_LOG_T:
		  output_msg = TRUE ;
		  break ;
		case MESSAGE_FILE_T:
		case MESSAGE_DIDFILE_T:
		  output_msg = FALSE ;
		  break ;
		case MESSAGE_GRAPHICS_T:
		  output_msg = FALSE ;
		  break ;
		case MESSAGE_STDOUT_T:
		default:
		  output_msg = FALSE ;
	      }
	    } else if( BITMODE(msgS.mode,M_SILENT) ){
	      switch( msg_func_type ){
		case MESSAGE_LOG_T:
		  output_msg = TRUE ;
		  break ;
		case MESSAGE_FILE_T:
		case MESSAGE_DIDFILE_T:
		  output_msg = TRUE ;
		  break ;
		case MESSAGE_GRAPHICS_T:
		  output_msg = FALSE ;
		  break ;
		case MESSAGE_STDOUT_T:
		default:
		  output_msg = FALSE ;
	      }
	    } else {
	      /* Normal type */
	      switch( msg_func_type ){
		case MESSAGE_LOG_T:
		  output_msg = TRUE ;
		  break ;
		case MESSAGE_FILE_T:
		case MESSAGE_DIDFILE_T:
		  output_msg = TRUE ;
		  break ;
		case MESSAGE_GRAPHICS_T:
		  if( messageType & MSG_GRAPHICS ){
		    output_msg = TRUE ;
		  } else {
		    output_msg = FALSE ;
		  }
		  break ;
		case MESSAGE_STDOUT_T:
		default:
		  if( msg_type == IMSG ){
		    output_msg = TRUE ;
		  } else {
		    output_msg = FALSE ;
		  }
		  break ;
	      }
	    }
	  }
	}
	if(!(output_msg)){
	  continue ;
	}
	(*msg->message_func)( messageString, messageType,msg->message_data ) ;
      }
    } else {
      if( messageString ){
	fprintf( out,"%s", messageString ) ;
      }
      if( msgS.mode & M_STDERR ){
	fflush(out) ;
      }
    }
    if( msg_type == IMSG ){
      utDmsg_flush() ;
    }
    return( NULL ) ;

} /* end utDmsg() */


/* -----------------------------------------------------------------
 * Setup the queue one shot.  Useful for program introduction in the
 * presence of errors.
----------------------------------------------------------------- */
void utDmessage_queued(INT messageType, char *routine, char *messageString)
{
    msgS.queued_message = messageString ;
    msgS.queued_mtype = messageType ;
    msgS.queued_routine = routine ;
} /* end Ymessage_queued() */

/* -----------------------------------------------------------------
 * Install a message function.
----------------------------------------------------------------- */
VOIDPTR utDmsg_func( void (*func)(const char *message,INT message_type,void *cdata), 
                       MESSAGE_T type, void *client_data, INT options )
{
    MESSAGEPTR msg ;		/* enumerate message functions */

    if(!(func)){
      utDmsg(ERRMSG,"utd/utDmsg_func:1", "utDmsg_func", "Message function is NULL\n") ;
      return(NULL) ;
    }

    /* install at the beginning of the doubly-linked list */
    msg = msgS.msg_func ;
    msgS.msg_func = UTDCALLOC(1, MESSAGEBOX) ; /* implicity terminate the lists */
    if( options & MSGFUNC_OPT_RESTRICTED ){
      msgS.msg_func->restricted_msg = TRUE ;
    }
    if( options & MSGFUNC_OPT_FLUSH ){
      msgS.msg_func->flush = TRUE ;
    }
    if( options & MSGFUNC_OPT_CLOSE ){
      msgS.msg_func->close = TRUE ;
    }
    msgS.msg_func->message_func = func ;
    msgS.msg_func->message_type = type ;
    msgS.msg_func->message_data = client_data ;
    msgS.msg_func->next_msg = msg ;
    if( msg ){
      msg->prev_msg = msgS.msg_func ;
    }
    return( msgS.msg_func ) ;
} /* end utDmsg_func() */

/* -----------------------------------------------------------------
 * Remove message function from the message list.  Returns TRUE if
 * message function was found.
----------------------------------------------------------------- */
BOOL utDmsg_func_delete( void (*func)(const char *message,INT message_type,void *da) )
{
    MESSAGEPTR msg ;		/* enumerate message functions */

    if(!(func)){
      utDmsg(ERRMSG,"utd/utDmsg_func_delete:1", "utDms_func_delete", "Message function is NULL\n") ;
      return(FALSE) ;
    }

    for( msg = msgS.msg_func ; msg ; msg = msg->next_msg ){
      if( msg->message_func == func ){
	/* delete this message function */
	/* fix the previous message's next field */
	if( msg->prev_msg ){
	  msg->prev_msg->next_msg = msg->next_msg ; 
	} else {
	  /* message to delete was the head of the list */
	  msgS.msg_func = msg->next_msg ;
	}
	/* fix the next message's prev field */
	if( msg->next_msg ){
	  msg->next_msg->prev_msg = msg->prev_msg ; 
	} else {
	  /* message to delete was the end of the list - nothing to do */
	}
	/* now that links are ok, delete message memory */
	UTDFREE( msg ) ;
	return(TRUE) ;
      }
    }
    return(FALSE) ;
} /* end utDmsg_func_delete() */

/* -----------------------------------------------------------------
 * Remove message function from the message list.  Returns TRUE if
 * message function was found.
----------------------------------------------------------------- */
BOOL utDmsg_func_objDelete( VOIDPTR obj_p )
{
    MESSAGEPTR msg ;		/* enumerate message functions */

    if(!(obj_p)){
      utDmsg(ERRMSG, "utd/utDmsg_func_objDelete:1", "utDmsg_func_objDelete", "Message object function is NULL\n") ;
      return(FALSE) ;
    }

    for( msg = msgS.msg_func ; msg ; msg = msg->next_msg ){
      if( msg == obj_p ){
	/* delete this message function */
	/* fix the previous message's next field */
	if( msg->prev_msg ){
	  msg->prev_msg->next_msg = msg->next_msg ; 
	} else {
	  /* message to delete was the head of the list */
	  msgS.msg_func = msg->next_msg ;
	}
	/* fix the next message's prev field */
	if( msg->next_msg ){
	  msg->next_msg->prev_msg = msg->prev_msg ; 
	} else {
	  /* message to delete was the end of the list - nothing to do */
	}
	/* now that links are ok, delete message memory */
	UTDFREE( msg ) ;
	return(TRUE) ;
      }
    }
    return(FALSE) ;
} /* end Ymessage_func_objDelete() */

/* -----------------------------------------------------------------
 * Remove message function from the message list by type.  Returns TRUE if
 * message function was found.
----------------------------------------------------------------- */
BOOL utDmsg_func_delete_type( MESSAGE_T type )
{
    MESSAGEPTR msg ;		/* enumerate message functions */
    MESSAGEPTR prev ;		/* previous message function */
    BOOL deleted ;		/* true if delete a message handler */

    deleted = FALSE ;
    for( msg = msgS.msg_func ; msg ; msg = msg->next_msg ){
      if( msg->message_type == type ){
	/* delete this message function */
	/* fix the previous message's next field */
	if( msg->prev_msg ){
	  prev = msg->prev_msg ;
	  prev->next_msg = msg->next_msg ; 
	} else {
	  /* message to delete was the head of the list */
	  prev = msgS.msg_func = msg->next_msg ;
	}
	/* fix the next message's prev field */
	if( msg->next_msg ){
	  msg->next_msg->prev_msg = msg->prev_msg ; 
	} else {
	  /* message to delete was the end of the list - nothing to do */
	}
	/* now that links are ok, delete message memory */
	UTDFREE( msg ) ;
	msg = prev ;
	if(!(msg)){
	  break ;
	}
      }
    }
    return(deleted) ;
} /* end utDmsg_func_delete_type() */

/* -----------------------------------------------------------------
 * Remove message function from the message list by clientData.  Returns TRUE if
 * message function was found.
----------------------------------------------------------------- */
BOOL utDmsg_func_delete_clientData( VOIDPTR clientData )
{
    MESSAGEPTR msg ;		/* enumerate message functions */
    MESSAGEPTR prev ;		/* previous message function */
    BOOL deleted ;		/* true if delete a message handler */

    deleted = FALSE ;
    for( msg = msgS.msg_func ; msg ; msg = msg->next_msg ){
      if( msg->message_data == clientData ){
	/* delete this message function */
	/* fix the previous message's next field */
	if( msg->prev_msg ){
	  prev = msg->prev_msg ;
	  prev->next_msg = msg->next_msg ; 
	} else {
	  /* message to delete was the head of the list */
	  prev = msgS.msg_func = msg->next_msg ;
	}
	/* fix the next message's prev field */
	if( msg->next_msg ){
	  msg->next_msg->prev_msg = msg->prev_msg ; 
	} else {
	  /* message to delete was the end of the list - nothing to do */
	}
	/* now that links are ok, delete message memory */
	UTDFREE( msg ) ;
	msg = prev ;
	if(!(msg)){
	  break ;
	}
      }
    }
    return(deleted) ;
} /* end utDmsg_func_delete_clientData() */

void utDmsg_file_msg( const char *message, INT type, void *clientData ) 
{
    FILE *fp ;				/* file pointer */
    fp = (FILE *) clientData ;
    if( fp ){
      fprintf( fp, "%s", message ) ;
    }
} /* end utDmsg_file_msg() */

void utDmsg_stream_msg( const char *message, INT type, void *clientData ) 
{
    INT len ;				/* length of string */
    LONG fd ;				/* file descriptor */
    LONG num_written ;			/* number of messages written */

    if( message ){
      fd = (LONG) clientData ;
      len = strlen( message ) ;
      num_written = write( fd, message, len ) ;
    }
} /* end utDmsg_stream_msg() */

void utDmsg_stdout_msg( const char *message, INT type, void *clientData ) 
{
    INT msg_type ;		/* basic type */

    msg_type = GET_MESSAGE_TYPE(type) ;
    if( msg_type == WARNMSG || msg_type == ERRMSG ){
      fprintf( stderr, "%s", message ) ;
    } else {
      fprintf( stdout, "%s", message ) ;
    }
} /* end utDmsg_stdout_msg() */

/* increment the static variable */
void utDmsg_warn_count(void)
{
    msgS.warningCount++ ;
} /* end utDmsg_warn_count */

/* increment the static variable */
void utDmsg_error_count(void)
{
    msgS.errorCount++ ;
}/* end utDmsg_error_count() */

/* reset the message error count */
void utDmsg_error_reset(void)
{
    msgS.errorCount = 0 ;
}/* end utDmsg_error_reset() */

INT utDmsg_get_warncount(void)
{
    return( msgS.warningCount) ;
} /*end utDmsg_get_warncount() */

INT utDmsg_get_errorcount(void)
{
    return( msgS.errorCount) ;
} /*end utDmsg_get_errorcount() */

INT utDmsg_get_ignored_warncount(void)
{
    return( msgS.ignoredWarningCount) ;
} /*end utDmsg_get_ignored_warncount() */

INT utDmsg_get_ignored_errorcount(void)
{
    return( msgS.ignoredErrorCount) ;
} /*end utDmsg_get_ignored_errorcount() */

void utDmsg_mode(INT mode)
{
    if( mode & M_VERBOSE ){
	msgS.mode = M_VERBOSE ;
    } else if( mode & M_NORMAL ){
	msgS.mode = M_NORMAL ;
    } else if( mode & M_SILENT ){
	msgS.mode = M_SILENT ;
    } else if( mode & M_MUTE ){
	msgS.mode = M_MUTE ;
    }

    if( mode & M_HOSTNAME ) {
	msgS.hostname = utDhostname() ;
	BITMODE_SET( msgS.mode, M_HOSTNAME );
    } else {
	msgS.hostname = NULL ;
	BITMODE_RESET( msgS.mode, M_HOSTNAME );
    }
    if( mode & M_STDERR ) {
	BITMODE_SET( msgS.mode, M_STDERR ) ;
    } else {
	BITMODE_RESET( msgS.mode, M_STDERR ) ;
    }
    if( mode & MSG_AVOID_STATS ){
	BITMODE_SET( msgS.mode, MSG_AVOID_STATS ) ;
    } else {
	BITMODE_RESET( msgS.mode, MSG_AVOID_STATS ) ;
    }

} /* end utDmsg_mode() */


INT utDmsg_tcl_options( INT type, char *str )
{
    char *ptr ;				/* return ptr */

    do {
      ptr = strchr( str, '|') ;
      if( ptr ){
	if( utDstrnicmp( ptr, "|ignore_incr", 6 ) == STRINGEQ ){
	  type |= MSG_IGNORE_INCR ;
	  str = ptr + 6 ;
	} else if( utDstrnicmp( ptr, "|preline", 6 ) == STRINGEQ ){
	  type |= MSG_PRELINE ;
	  str = ptr + 6 ;
	} else if( utDstrnicmp( ptr, "|control", 6 ) == STRINGEQ ){
	  type |= MSG_CONTROL ;
	  str = ptr + 6 ;
	} else if( utDstrnicmp( ptr, "|tcl", 3 ) == STRINGEQ ){
	  type |= MSG_TCL_INTERP|MSG_RETURN_STRING ;
	  str = ptr + 3 ;
	} else {
	  str = ptr + 1 ;
	}
      }
    } while( ptr ) ;

    return( type ) ;
} /* end utDmsg_tcl_options() */

/* -----------------------------------------------------------------
 * This routine adds a hostname suffix to message output so we can debug
 * parallel modes more easily when it is the same host.
----------------------------------------------------------------- */
void utDmsg_hostnameSuffix(INT host_suffix)
{
    char newHostSuffix[LRECL] ;		/* make new hostname */

    if( msgS.hostnameSuffix ){
      UTDFREE( msgS.hostnameSuffix ) ;
    }
    sprintf( newHostSuffix, "#%d", host_suffix  ) ;
    msgS.hostnameSuffix = utDstrclone( newHostSuffix ) ;

} /* end utDmsg_hostnameSuffix() */

INT utDmsg_get_mode(void)
{
    return( msgS.mode ) ;
} /* end utDmsg_get_mode */

void utDmsg_flush(void)
{
    FILE *fp ;			/* file pointer */
    MESSAGEPTR msg_p ;		/* enumerate message functions */

    for( msg_p = msgS.msg_func ; msg_p ; msg_p = msg_p->next_msg ){
      if ( msg_p->flush ){
	fp = (FILE *) msg_p->message_data ;
	if( fp ){
	  fflush( fp ) ;
	}
      }
    }
    fflush( stdout ) ;
} /* end utDmsg_flush */

void utDmsg_close(void)
{
    FILE *fp ;			/* file pointer */
    MESSAGEPTR msg_p ;		/* enumerate message functions */

    for( msg_p = msgS.msg_func ; msg_p ; msg_p = msg_p->next_msg ){
      if ( msg_p->close ){
	fp = (FILE *) msg_p->message_data ;
	if( fp ){
	  UTDCLOSE( fp ) ;
	}
      }
    }
} /* end utDmsg_close() */


void utDmsg_syserr(INT abort,const char *routine,const char *format, ... )
{
    va_list args ;
    char prebuffer[LRECL] ; 	/* prebuffer for new message */
    char buffer[LRECL] ; 	/* buffer for new message */
    INT errno_save ;	 	/* save the error number in case of reset */

    errno_save = errno ;
    va_start( args, format ) ;
    vsprintf( prebuffer, format, args ) ;
    if( errno_save && !(abort&MSE_NOERROR) ){
      sprintf( buffer, "%s:\n\t%s\n\n", prebuffer, strerror(errno_save)) ;
    } else {
      sprintf( buffer, "%s\n\n", prebuffer) ;
    }
    utDmsg( ERRMSG, "utd/Umsg_syserr:1", routine, buffer ) ;
    if( (abort&MSE_ABORT) ){
      // program_exit(PGMFAIL) ;
    }
    /* reset errno */
    errno = 0 ;
} /* end utDmsg_syserr() */

const char *utDmsgf( INT messageType, const char *label, const char *routine, const char *format, ... )
{
    va_list args ;
    INT format_len ;				/* length of format */
    const char *msg ;				/* formed message */
    char *buffer ;				/* proper length of buffer */

    /* -----------------------------------------------------------------
     * First get the length of the buffer needed.
    ----------------------------------------------------------------- */
    va_start( args, format ) ;
    format_len = utDdstring_format_length(args,format) ;

    /* -----------------------------------------------------------------
     * Next allocate the proper buffer size.
    ----------------------------------------------------------------- */
    if(!(msgS.m2dstring)){
      msgS.m2dstring = &msgS.m2buf ;
      utDdstring_init(msgS.m2dstring) ;
    }
    utDdstring_reinit(msgS.m2dstring) ;
    buffer = utDdstring_setlength(msgS.m2dstring,format_len + 1) ;

    /* -----------------------------------------------------------------
     * Convert the format.
    ----------------------------------------------------------------- */
    va_start( args, format ) ;
    if( format ){
      vsprintf( buffer, format, args ) ;
    } else {
      buffer = NULL ;
    }
    va_end(args) ;

    msg = utDmsg( messageType, label, routine, buffer ) ;
    return( msg ) ;
} /* end utDmsgf() */


#ifdef DEBUG
void ebreak(void)
{
    /* NULL body */
} /* end ebreak() */

void wbreak(void)
{
    /* NULL body */
} /* end wbreak() */


void print_bitset(INT value)
{
  INT i ;				/* counter */
  INT bitvalue ;			/* bit value */

  utDmsg(IMSG,"print_bitset:1", NULL, "Set bits:" ) ;
  for( i = 0 ; i < 32 ; i++ ){
    bitvalue = value & 0x1 ;
    if( bitvalue ){
      utDmsgf(IMSG,"print_bitset:2", NULL, " %d", i ) ;
    }
    value = value >> 1 ;
  }
  utDmsg(IMSG,"print_bitset:3", NULL, "\n" ) ;
} /* end print_bitset() */

void print_bitset64(INT64 value)
{
  INT i ;				/* counter */
  INT64 bitvalue ;			/* bit value */

  utDmsg(IMSG,"print_bitset64:1", NULL, "Set bits:" ) ;
  for( i = 0 ; i < 64 ; i++ ){
    bitvalue = value & 0x1 ;
    if( bitvalue ){
      utDmsgf(IMSG,"print_bitset64:2", NULL, " %d", i ) ;
    }
    value = value >> 1 ;
  }
  utDmsg(IMSG,"print_bitset64:3", NULL, "\n" ) ;
} /* end print_bitset64() */

#endif /* DEBUG */

#ifdef TEST
/* ##################################################################
                       TEST OF MESSAGE ROUTINES 
   ################################################################## */
#include <utd/program.h>


int main(int argc, char *argv[])
{
    const char *msg ;			/* message info */
    const char *pos ;			/* file line position */
    char *routine ;			/* name of routine */
    UTDDSTRING mbuf ;			/* message buffer */

    routine = "message_test" ;
    utDmsg(ERRMSG,"a", routine, "Test of stuff.\n" ) ;
    utDmsgf(ERRMSG,"b", routine, "My string:%s\n", "Bill" ) ;
    utDmsgf(ERRMSG,"c", routine, "My string:%10s\n", "Bill" ) ;
    utDmsgf(ERRMSG,"d", routine, "My char is:%c%s%c\n",DQUOTE,"fine",DQUOTE) ;
    msg = utDmsgf(ERRMSG|MSG_RETURN_STRING,"e", routine, "My double:%4.3f Not to be printed\n", 10.0 ) ;
    if( msg ){
      fprintf( stderr, "my message was: %s", msg ) ;
    }
    utDmsgf(ERRMSG|MSG_ROUTINE_NEWLINE|MSG_PRELINE,"f", routine, "My double:%4.3f should have a blank line before.\n", 12.0 ) ;
    utDmsg(ERRMSG,"g", routine, NULL ) ;
    pos = MSG_AT ;
    utDmsgf(IMSG,"h", NULL, "Pos here:%s\n", pos ) ;
    pos = MSG_AT ;
    utDmsgf(IMSG,"h", NULL, "Pos here:%s\n", pos ) ;

    utDmsg(ERRMSG,MSG_AT, NULL, "End of message.\n" ) ;


    utDprogram_exit(PGMOK) ;
    return(0) ;
}
#endif /* TEST */
