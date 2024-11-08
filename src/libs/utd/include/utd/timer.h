/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	     timer.h 
DESCRIPTION:create a timer for a process.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_TIMER_H
#define INCLUDED_UTD_TIMER_H

#include <utd/base.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef struct utdtimer_rec {
  LONG base_time ;			/* the time in seconds at the start */
  LONG milli_time ;			/* the millisecond part of the start */
} UTDTIMER, *UTDTIMERPTR ;

extern void utDtimer_start( UTDTIMERPTR timer_p ) ;
extern INT utDtimer_elapsed( UTDTIMERPTR timer_p ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /*  INCLUDED_UTD_TIMER_H */
