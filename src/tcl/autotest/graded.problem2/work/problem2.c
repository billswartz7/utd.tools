
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "utdfib.h"

int main(int argc,char *argv[]) 
{

  int fib ;
  double out ;

  fprintf( stderr, "PROGRAMID: 2\n" ) ;
  fib = 10 ;

  out = UTDfibronacci( fib ) ;

  fprintf( stderr, "ANSWER: %.2lf\n", out ) ;
  exit(0) ;

}
