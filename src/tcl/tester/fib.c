#include <stdio.h>

int fib(int n)
{
  int f1 = 1, f2 = -1 ;


  for( ; n > 0 ; n-- ){
    f1 = f1 + f2 ;
    f2 = f1 - f2 ;
  }
  return ( f1 ) ;
}


main (int argc, char **argv)
{
   int answer ;
   answer = fib(8) ;
   printf( "The answer is %d\n", answer ) ;
}
