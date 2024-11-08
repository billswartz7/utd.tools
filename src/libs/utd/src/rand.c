/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    rand.c                                       
DESCRIPTION:mimimum standard random number generator function.  This
	    random generator replaces the poor Berkeley 4.2 random
	    generator using generators discussed in the Communications
	    of the ACM.  See articles by L'Ecuyer and Park/Miller in
	    June 1988 and October 1988 resp.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>

#include <utd/base.h>
#include <utd/debug.h>

static INT randVarS = 1 ;                 /* random number */

#define A_RAND 16807                /* good generator multiplier */
#define M_RAND 2147483647                 /* 2 ** 31 - 1 */
#define Q_RAND 127773                     /* m / a */
#define R_RAND 2836                       /* m mod a */

#if defined(linux) || defined(__alpha) || defined(ultrix)
#define RAND_INTEGER_DIV 1
#endif /* if defined(linux... */

/* returns a random number in [0..2**31 - 1] */
INT utDrandom_acm(void)
{
    register INT k_rand ;

#ifdef RAND_INTEGER_DIV
    k_rand = randVarS / Q_RAND ;
#else
    k_rand = randVarS * (1.0 / Q_RAND) ;
#endif /* RAND_INTEGER_DIV */
    randVarS = A_RAND * (randVarS - k_rand * Q_RAND) - (k_rand * R_RAND) ;
    if( randVarS < 0 ){
	randVarS += M_RAND ;
    } 
    return( randVarS ) ;

} /* end utDrandom_acm() */

void utDrandom_set_seed(UNSIGNED_INT seed)
{
    if( seed == 0 ){
	seed++ ;
    }
    randVarS = seed ;
} /* end utDrandom_set_seed() */

INT utDrandom_get_var(void)
{
    return( randVarS ) ;
} /* end utDrandom_get_var */


#ifdef TEST

/* test whether generator works correctly. */
#include <utd/stats.h>

int main(void)
{
    INT n, randnum ;
    utDrandom_set_seed( 1 ) ;
    for( n = 1; n <= 10000; n++ ){
	randnum = utDrandom_acm() ;
    }
    printf( "The final value is randnum:%d\n", randnum ) ;
    printf( "It should be 1043618065 if everything is correct.\n" ) ;
    printf( "See article.\n\n" ) ;

#ifdef RAND_INTEGER_DIV
    fprintf( stderr, "Timing for integer divide.\n" ) ;
#else
    fprintf( stderr, "Timing for floating point divide.\n" ) ;
#endif /* RAND_INTEGER_DIV */
    for( n = 1; n <= 100000000; n++ ){
	randnum = utDrandom_acm() ;
    }
    utDstats_print(stderr) ;
}

#endif /* TEST */
