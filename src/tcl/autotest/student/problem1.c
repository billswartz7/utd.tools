
#include <stdio.h>

#define NUM_ITEMS 6

int main(int argc,char *argv[])
{

  double arr[NUM_ITEMS] = { 3.14, 4.5, 4.2, 31.0, 7.0, 4.5 };

  double sum ;
  int i ;

  fprintf( stderr, "PROGRAMID: 7\n" ) ;
  sum = 0.0 ;
  for( i = 0 ; i < NUM_ITEMS ; i++ ){
    sum += arr[i] ;
  }
  sum = sum * sum * sum ;
  fprintf( stderr, "ANSWER:%.2lf\n", sum ) ;


} /* end main */

