/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    stats.h                                       
DESCRIPTION:Include files for stat.c
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_STATS_H
#define INCLUDED_UTD_STATS_H

#include <utd/base.h>
#include <utd/dstring.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

extern char * _utDstats_print( UTDDSTRINGPTR mbuf_p ) ;
extern void utDstats_print( FILE *fout ) ;
extern DOUBLE utDstats_cpu_time( void ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_STATS_H */
