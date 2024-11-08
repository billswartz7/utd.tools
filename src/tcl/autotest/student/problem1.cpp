
#include <stdio.h>

#define NUM_ITEMS 6

int main(int argc,char *argv[])
{

  double arr[NUM_ITEMS] = {2.0, 39.0, 6.0, 7.0, 4.2, 1.0} ; 

  double sum ;
  int i ;

  fprintf( stderr, "PROGRAMID: 1\n" ) ;
  sum = 0.0 ;
  for( i = 0 ; i < NUM_ITEMS ; i++ ){
    sum += arr[i] ;
  }
  sum = sum * sum * sum ;
  fprintf( stderr, "ANSWER:%.2lf\n", sum ) ;


} /* end main */

