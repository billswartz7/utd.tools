/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    rand.h
DESCRIPTION:include file for acm random functions.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_RAND_H
#define INCLUDED_UTD_RAND_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define ACM_RAND_MAX 2147483647                 /* 2 ** 31 - 1 */
/* random number [0...INT_MAX] */
#define UTD_RAND            (utDrandom_acm() )
/* random number [0...limit] */
#define UTD_RANDOM(limit)   (utDrandom_acm() % (limit))
#define UTD_ROLL_THE_DICE() ((DOUBLE) UTD_RAND / (DOUBLE)ACM_RAND_MAX ) 
#define UTD_ROUND(value)  ( (INT)(value + 0.5)) 
#define UTD_ROUND_UP(num) ( (num) > 0 ? (INT)((num)+0.9999) :-((INT)(0.9999-(num))))
#define UTD_PICK_INT(l,u) (((l)<(u)) ? ((UTD_RAND % ((u)-(l)+1))+(l)) : (l))

/* -----------------------------------------------------------------
 * Compute a new random number and return it as a number [0..INT_MAX]
 * ----------------------------------------------------------------- */
extern INT utDrandom_acm( void ) ;

/* -----------------------------------------------------------------
 * Set the seed for the psuedo random generator.
 * ----------------------------------------------------------------- */
extern void utDrandom_set_seed( UNSIGNED_INT seed ) ;

/* -----------------------------------------------------------------
 * Get the current random number.
 * ----------------------------------------------------------------- */
extern INT utDrandom_get_var( void ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_RAND_H */
