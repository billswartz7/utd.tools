/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    tcllog.h
DESCRIPTION:This file contains include file for tcl log module.
CONTENTS:   Tcl log file include.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_TCLLOG_H
#define INCLUDED_UTD_TCLLOG_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef void UTDTCLMSGFUNC( const char *message, INT type, void *clientData ) ;

/* -----------------------------------------------------------------
   utDtcllog_init - create the .xdid file. Returns pointer to
   the file. Takes arguments: filename - name of tcl log file,
   func - users own message func. If null, uses the default.
   ----------------------------------------------------------------- */
extern FILE *utDtcllog_init(char *filename,UTDTCLMSGFUNC func,void *clientData);

/* -----------------------------------------------------------------
   utDtcllog_exit - closes the .xdid file.  One important side effect-
   it set utDmsg_func to NULL.
   ----------------------------------------------------------------- */
extern void utDtcllog_exit(void) ;

/* -----------------------------------------------------------------
   utDtcllog_message_func - the default message function.  This allows
   user to call this function in another message func call.
   ----------------------------------------------------------------- */
extern void utDtcllog_message_func( const char *message, INT message_type, void *client) ;

/* -----------------------------------------------------------------
   utDtcllog_command - tells the log function that the next message
   is a Tcl command and to leave off the prepended #.  Immediately
   afterward it is reset to normal mode.
   ----------------------------------------------------------------- */
extern void utDtcllog_command(void) ;

/* -----------------------------------------------------------------
   utDtcllog_flush - tells the log function to flush the current data.
   ----------------------------------------------------------------- */
extern void utDtcllog_flush(void) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_TCLLOG_H */
