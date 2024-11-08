/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	     time.c 
DESCRIPTION:This file contains a time utility routine which returns
	    an ASCII string with time and date.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#ifdef HAVE_TIME_H
#include <time.h>
#endif /* HAVE_TIME_H */
#include <utd/base.h>
#include <utd/time.h>
#include <utd/string.h>

typedef time_t TIME_T ;

const char *utDtime_get(LONG *time_in_sec)
{
    /* get current time - return ASCII string with time and date */
    TIME_T t ;
    char *ptr ;
    char *nptr ;
    t = time((TIME_T *) 0) ;
    /* return time in seconds since Jan 1, 1970 if requested */
    if( time_in_sec ){
	*time_in_sec = t ;
    }
    /* get time and remove newline char */
    for( nptr = ptr = ctime(&t) ;*nptr;nptr++ ){
	if( *nptr == '\n' ){
	    *nptr = EOS ;
	}
    }
    return( ptr ) ;
} /* end utDtime_get() */

const char *utDtime_human_date( LONG user_time, BOOL second_flag )
{
    TIME_T time ;			/* convert to correct system size */
    char *conv_time ;			/* pointer to convert string */
    static char return_bufL[27] ;

    time = user_time ;

    if( time == 0 ){
      strcpy( return_bufL, "never" ) ;
    } else {
      conv_time = ctime( &time ) ;
      /* -----------------------------------------------------------------
       * format of return:
       * Sun Sep 16 01:03:52 1985\n\0
       * 0123456789012345678901234567
      ----------------------------------------------------------------- */
      if( second_flag ){
	strcpy( return_bufL, conv_time ) ;
	return_bufL[24] = EOS ;
      } else {
	return_bufL[0] = conv_time[8] ;
	return_bufL[1] = conv_time[9] ;
	return_bufL[2] = '-' ;
	return_bufL[3] = conv_time[4] ;
	return_bufL[4] = conv_time[5] ;
	return_bufL[5] = conv_time[6] ;
	return_bufL[6] = '-' ;
	return_bufL[7] = conv_time[20] ;
	return_bufL[8] = conv_time[21] ;
	return_bufL[9] = conv_time[22] ;
	return_bufL[10] = conv_time[23] ;
	return_bufL[11] = EOS ;
      }
    }
    return( return_bufL ) ;
} /* end utDtime_human_date() */

#ifdef solaris2
extern long timezone ;
#endif /* solaris2 */

BOOL utDtime_info( LONG user_time, UTDTIMEINFOPTR time_info_p )
{
    struct tm *date_p ;
    TIME_T t ;

    t = (TIME_T) user_time ;
    date_p = localtime(&t);
    if( date_p && time_info_p ){
      time_info_p->year = date_p->tm_year + 1900 ;
      time_info_p->month = date_p->tm_mon + 1 ;
      time_info_p->day = date_p->tm_mday ;
      time_info_p->hour = date_p->tm_hour ;
      time_info_p->minute = date_p->tm_min ;
      time_info_p->second = date_p->tm_sec ;
#if defined(sparc) || defined(sun)
      time_info_p->tm_zone = utDstrclone("unknown") ;
      time_info_p->gm_offset = timezone ;
#else
      time_info_p->tm_zone = utDstrclone(date_p->tm_zone) ;
      time_info_p->gm_offset = date_p->tm_gmtoff ;
#endif /* solaris2 */
      return(FALSE) ;
    }
    return(TRUE) ;

} /* end utDtime_info() */


#ifdef TEST

#ifdef HAVE_STDLIB_H
#include  <stdlib.h>
#endif /* HAVE_STDLIB_H */

int main( INT argc, char *argv[] )
{
    const char *time_str ;
    char input[LRECL] ;
    LONG time ;
    UTDTIMEINFO timeinfo_rec ;
    UTDTIMEINFOPTR time_p = &timeinfo_rec ;

    time_str = utDtime_get( &time ) ;
    fprintf( stderr, "The current time is :%ld\n", time ) ;
    fprintf( stderr, "The date:%s\n", time_str ) ;
    fprintf( stderr, "Human date:%s\n", utDtime_human_date(time,TRUE) ) ;
    fprintf( stderr, "Time info:\n" ) ;
    if( utDtime_info( time, time_p ) ){
      fprintf( stderr, "Error with time function.\n" ) ;
    }
    fprintf( stderr, "   year:%d\n", time_p->year ) ;
    fprintf( stderr, "   month:%d\n", time_p->month ) ;
    fprintf( stderr, "   day:%d\n", time_p->day ) ;
    fprintf( stderr, "   hour:%d\n", time_p->hour ) ;
    fprintf( stderr, "   min:%d\n", time_p->minute ) ;
    fprintf( stderr, "   sec:%d\n", time_p->second ) ;
    fprintf( stderr, "   gm:%ld\n", time_p->gm_offset ) ;
    fprintf( stderr, "   tz:%s\n", time_p->tm_zone ) ;

    while(TRUE){
      fprintf( stderr, "Enter time to convert:" ) ;
      scanf( "%s", input ) ;
      time = atol( input ) ;
      fprintf( stderr, "date:%s\n", utDtime_human_date(time,TRUE) ) ;
    }
    exit(0) ;
    return(0) ;
} /* end main() */
#endif /* TEST */
