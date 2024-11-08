
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double my_x2(double sum)
{
  return( sum * sum ) ;
}

double my_ceil(double sum)
{
  return( ceil(sum) ) ;
}

double my_sqrt(double sum)
{
  return( sqrt(sum) ) ;
}

double my_x3(double sum)
{
  return( sum * sum * sum ) ;
}

double my_floor(double sum)
{
  return( floor(sum) ) ;
}

int main(int argc,char *argv[]) 
{

  int i ;
  int fib ;
  double out ;
  double sum = 0.0 ;

  fprintf( stderr, "PROGRAMID: 2\n" ) ;
  fib = 10 ;

  for ( i = 0 ; i <= fib ; i++ ){
    sum += i ;
  }
  fprintf( stderr, "fib:%d\n", sum ) ;
  
  out = my_x3(sum) ;

  fprintf( stderr, "ANSWER: %.2lf\n", out ) ;
  exit(0) ;

}

