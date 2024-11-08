/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    cleanup.h
DESCRIPTION:Generalized and common base definitions.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_CLEANUP_H
#define INCLUDED_UTD_CLEANUP_H

#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif /* HAVE_SIGNAL_H */
#include <utd/base.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef void utDsigfunc( INT ) ;
typedef void utDuser_sigfunc( void * ) ;

/*---------------------------------------------------------
   utDcleanup_init - sets static variables for cleanup handler.
  --------------------------------------------------------*/
extern void utDcleanup_init( utDuser_sigfunc function, void *cdata ) ;

/*---------------------------------------------------------
   utDcleanup_graphics - sets the callback to graphics close function.
  --------------------------------------------------------*/
extern void utDcleanup_graphics( INT (*function)(INT status) ) ;

/*---------------------------------------------------------
   utDsignal - a replacement for signal.  This insures reliable
   signals.
  --------------------------------------------------------*/
extern utDsigfunc *utDsignal( INT signo, utDsigfunc *func ) ;

/*---------------------------------------------------------
   utDcleanup - this is the installed cleanup handler.
  --------------------------------------------------------*/
extern void utDcleanup( INT sigNum ) ;

/*---------------------------------------------------------
   utDcleanupHandler - after system work process user information.
  --------------------------------------------------------*/
extern void utDcleanupHandler(INT status) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* CLEANUP_H */
