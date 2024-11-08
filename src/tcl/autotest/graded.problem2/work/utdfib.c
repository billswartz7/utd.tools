
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "utdfib.h"

double UTDfibronacci( int fib )
{
  int i ;
  double out ;
  double sum = 0.0 ;

  for ( i = 0 ; i <= fib ; i++ ){
    sum += i ;
  }
  fprintf( stderr, "fib:%.lf\n", sum ) ;
  
  out = sum * sum * sum ;

  return( out ) ;

}
