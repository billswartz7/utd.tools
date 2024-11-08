/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    rint.c                                       
DESCRIPTION:Replacement routine for system rint
DATE:	    Mon Jul  6 21:44:51 CDT 1998
REVISIONS:  
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>
#include <utd/rint.h>
#include <math.h>

/* -----------------------------------------------------------------
 * We need to make our own rint function because IEEE rint rounds to
 * the nearest even integer in some modes which destroys our grid 
 * operations.  This function needs to be optimized at level -O2 or 
 * better to be fast.
----------------------------------------------------------------- */

DOUBLE utDrint( DOUBLE num )
{
    num = num + 0.5 ;
    return( floor(num) ) ;
} /* end utDrint() */

/* Look for exact zero - not a machine epsilon or fraction */
INT utDrint_sign( DOUBLE num )
{
    if( num == 0.0 ){
      return( 0 ) ;
    } else if( num < 0.0 ){
      return( -1 ) ;
    } else {
      return( 1 ) ;
    }
} /* end utDrint_sign() */

#ifdef TEST

#define NUM_TESTS 10000000
#include <stdio.h>
#include <utd/timer.h>

extern double rint(double) ;

static void test_rint(DOUBLE num)
{
    DOUBLE rint_num ;

    rint_num = utDrint( num ) ;
    fprintf( stderr, "number:%.17f utDrint(number):%.17f rint:%.17f \n", 
             num, rint_num, rint(num) ) ;
} /* end test_rint() */

int main(void)
{
    INT i ;
    DOUBLE val ;
    DOUBLE my_val ;
    UTDTIMER timer ;

    test_rint( 0.1 ) ;
    test_rint( 0.3 ) ;
    test_rint( 0.4 ) ;
    test_rint( 0.5 ) ;
    test_rint( 0.7 ) ;
    test_rint( 0.9 ) ;
    test_rint( 1.1 ) ;
    test_rint( 1.499999999999 ) ;
    test_rint( 1.5 ) ;
    test_rint( 1.6 ) ;
    test_rint( 1.9 ) ;
    test_rint( 2.5 ) ;
    test_rint( 99.9 ) ;
    test_rint( 100.9 ) ;
    test_rint( 17592186044416.0 ) ;
    test_rint( 17592186044416.5 ) ;
    test_rint( 17592186044416.499999999 ) ;

    test_rint( -0.1 ) ;
    test_rint( -0.3 ) ;
    test_rint( -0.4 ) ;
    test_rint( -0.5 ) ;
    test_rint( -0.7 ) ;
    test_rint( -0.9 ) ;
    test_rint( -1.1 ) ;
    test_rint( -1.5 ) ;
    test_rint( -1.6 ) ;
    test_rint( -1.9 ) ;
    test_rint( -2.5 ) ;
    test_rint( -99.9 ) ;
    test_rint( -100.9 ) ;

    val = 0.0 ;
    utDtimer_start(&timer) ;
    for( i = 1 ; i <= NUM_TESTS ; i++ ){
      my_val = utDrint( 0.5 ) ;
      val += my_val ;
      my_val = utDrint( 1.5 ) ;
      val += my_val ;
      my_val = utDrint( 2.5 ) ;
      val += my_val ;
    }
    fprintf( stderr, "It took %d milliseconds using utDrint val:%lf...\n",
	      utDtimer_elapsed(&timer), val ) ;

    val = 0.0 ;
    utDtimer_start(&timer) ;
    for( i = 1 ; i <= NUM_TESTS ; i++ ){
      my_val = rint( 0.5 ) ;
      val += my_val ;
      my_val = rint( 1.5 ) ;
      val += my_val ;
      my_val = rint( 2.5 ) ;
      val += my_val ;
    }
    fprintf( stderr, "It took %d milliseconds using rint val:%lf...\n",
	      utDtimer_elapsed(&timer), val ) ;
}

#endif /* TEST */



