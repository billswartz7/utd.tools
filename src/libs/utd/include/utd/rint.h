/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    rint.c                                       
DESCRIPTION:This is include file for rint.  We use our own rint because
            IEEE rint round to the nearest even integer in some modes
	    which doesn't help us make a consistent grid.  This way
	    we don't have to worry about rounding modes which can be
	    machine specific.
DATE:	    Mon Sep 13 16:23:08 CDT 2004
REVISIONS:  
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_UTDRINT_H
#define INCLUDED_UTD_UTDRINT_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

extern DOUBLE utDrint(DOUBLE num) ;
extern INT utDrint_sign(DOUBLE num) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_UTDRINT_H */
