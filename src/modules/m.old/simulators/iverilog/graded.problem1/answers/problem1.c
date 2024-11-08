
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

static double dataS[6] = { 2.0,  
                           39.0, 
			   6.0, 
			   7.0, 
			   4.2, 
			   1.0 } ;

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
  double out ;
  double sum = 0.0 ;

  fprintf( stderr, "PROGRAMID: 1\n" ) ;
  for ( i = 0 ; i < 6 ; i++ ){
    sum += dataS[i] ;
  }
  
  out = my_x3(sum) ;

  fprintf( stderr, "ANSWER: %.2lf\n", out ) ;
  exit(0) ;

}

