/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
 FILE:	    bitset.c                                       
 CONTENTS:   bitset functions.
 DATE:	    Wed Nov 16 20:59:11 CST 2005
 REVISIONS:  
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>
#include <utd/bitset.h>
#include <string.h>

INT utDbitset_count( UNSIGNED_INT value )
{
    INT cnt ;				/* count number of on bits */
    for( cnt = 0 ; value != 0 ; value >>= 1 ){
      if( value & 0x1 ){
	cnt++ ;
      }
    }
    return( cnt ) ;
} /* end utDbitset_count() */

void utDbitset_empty( UNSIGNED_INT *array_p, INT array_size )
{
    INT num_words ;			/* number of words */

    num_words = BITSET_ARRYSIZE( array_size ) ;
    memset( array_p, 0L, num_words * sizeof(UNSIGNED_INT) ) ; 
} /* end utDbitset_empty() */


#ifdef TEST

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */


int main(int argc,char **argv)
{

    unsigned int *array ;
    UNSIGNED_INT array_buf ;
    UNSIGNED_INT *array2 ;
    int i ;
    int max ;

    max = 32 ;
    array = BITSET_ALLOC( max ) ;
    fprintf( stderr, "array size allocated: %d\n", BITSET_ARRYSIZE( max ) ) ;
    fprintf( stderr, "size of unsigned int is %ld\n", sizeof(UNSIGNED_INT) ) ;

    for( i = 0 ; i <= max ; i++ ){
	if( i == 0 || i == 2 || i == 5 || i == 11 || i == 13 || i == 69 ){
	    BITSET_SET( array, i ) ;
	} else {
	    BITSET_RESET( array, i ) ;
	}
    }

    for( i = 0 ; i <= max ; i++ ){
	if( BITSET_GET( array, i ) ){
	    fprintf( stderr, "i:%d T", i ) ;
	} else {
	    fprintf( stderr, "i:%d F", i ) ;
	}
	if( (i % 10) == 0 ){
	    fprintf( stderr, "\n" ) ;
	} else {
	    fprintf( stderr, " " ) ;
	}
    }

    fprintf( stderr, "now resize the array to twice the size and set top bit:\n" ) ;
    array = BITSET_REALLOC( array, 2 * max ) ;
    BITSET_SET( array, 2 * max ) ;
    for( i = 0 ; i <= 2 * max ; i++ ){
      if( BITSET_GET( array, i ) ){
	  fprintf( stderr, "i:%d T", i ) ;
      } else {
	  fprintf( stderr, "i:%d F", i ) ;
      }
      if( (i % 10) == 0 ){
	  fprintf( stderr, "\n" ) ;
      } else {
	  fprintf( stderr, " " ) ;
      }
    }
    fprintf( stderr, "\n\n" ) ;
    BITSET_EMPTY( array, 2 * max ) ; 
    fprintf( stderr, "Now it should be empty: \n" ) ;
    for( i = 0 ; i <= 2 * max ; i++ ){
      if( BITSET_GET( array, i ) ){
	  fprintf( stderr, "i:%d T", i ) ;
      } else {
	  fprintf( stderr, "i:%d F", i ) ;
      }
      if( (i % 10) == 0 ){
	  fprintf( stderr, "\n" ) ;
      } else {
	  fprintf( stderr, " " ) ;
      }
    }
    fprintf( stderr, "\n\n" ) ;

    fprintf( stderr, "test of single array:\n" ) ;
    fprintf( stderr, "Should see 1 3 13 23 as true\n" ) ;
    max = BITSET_MAX(1) ;
    fprintf( stderr, "array size : %d\n", max ) ;
    array_buf = 0 ;
    array2 = &array_buf ;
    BITSET_SET( array2, 1 ) ;
    BITSET_SET( array2, 3 ) ;
    BITSET_SET( array2, 13 ) ;
    BITSET_SET( array2, 23 ) ;
    for( i = 0 ; i <= max ; i++ ){
	if( BITSET_GET( array2, i ) ){
	    fprintf( stderr, "i:%d T\n", i ) ;
	} else {
	    fprintf( stderr, "i:%d F\n", i ) ;
	}
    }





    exit(0) ;
    return 0 ;
} /* end main() */

#endif /* TEST */
