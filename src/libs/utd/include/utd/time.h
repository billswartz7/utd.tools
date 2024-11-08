/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	     time.h 
DESCRIPTION:This file contains the include file for the time utility 
	    routine which returns an ASCII string with time and date.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_TIME_H
#define INCLUDED_UTD_TIME_H

#include <utd/base.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef struct {
    INT year ;
    INT month ;
    INT day ;
    INT hour ;
    INT minute ;
    INT second ;
    char *tm_zone ;
    LONG gm_offset ;
} UTDTIMEINFO, *UTDTIMEINFOPTR ;


extern const char *utDtime_get( LONG *time_in_sec ) ;
extern const char *utDtime_human_date( LONG time,BOOL second_flag ) ;
extern BOOL utDtime_info( LONG user_time, UTDTIMEINFOPTR time_info_p ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /*  INCLUDED_UTD_TIME_H */
