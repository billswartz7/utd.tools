/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    timer.c                                       
DESCRIPTION:create a timer for a process.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif /* HAVE_SYS_TYPES_H */
#include <utd/timer.h>

/* alpha is bsd compatible, link -lbsd */

/* -----------------------------------------------------------------
 * The priority: gettimeofday, ftime, and then times.
----------------------------------------------------------------- */
#ifdef HAVE_GETTIMEOFDAY
#undef HAVE_FTIME
#undef HAVE_TIMES
#endif

#ifdef HAVE_FTIME
#undef HAVE_TIMES
#endif

#ifdef HAVE_TIMES
#include <sys/times.h>
#endif /* HAVE_TIMES */

#ifdef HAVE_FTIME
#include <sys/timeb.h>
#endif /* HAVE_FTIME */

#ifdef HAVE_GETTIMEOFDAY
#include <sys/time.h>
#endif /* HAVE_GETTIMEOFDAY */

#ifdef HAVE_TIMES
void utDtimer_start(UTDTIMERPTR timer_p)
{
    struct tms tp ;
    times(&tp);
    /* -----------------------------------------------------------------
     * times() is returning CPU time, not the elapsed time! 
     * There seems no corresponding ftime() in SYS5 
     * Should be process itself, not the children 
    ----------------------------------------------------------------- */
    timer_p->base_time = (LONG) tp.tms_utime + (LONG) tp.tms_stime;
    timer_p->milli_time = 0 ;
} /* end utDtimer_start() */
#endif /* HAVE_TIMES */


#ifdef HAVE_FTIME
void utDtimer_start(UTDTIMERPTR timer_p)
{
    struct timeb tp ;
#if defined(ultrix)
    void ftime(struct timeb *) ;
#endif /* ultrix */
    ftime(&tp) ;
    timer_p->base_time = (LONG) tp.time ;
    timer_p->milli_time = (LONG) tp.millitm ;
} /* end utDtimer_start() */
#endif /* HAVE_FTIME */

#ifdef HAVE_GETTIMEOFDAY
void utDtimer_start(UTDTIMERPTR timer_p)
{
    struct timeval tp ;
    gettimeofday(&tp,NULL) ;
    timer_p->base_time = (INT) tp.tv_sec ;
    timer_p->milli_time = (INT) (tp.tv_usec/1000) ;
} /* end utDtimer_start() */
#endif /* HAVE_GETTIMEOFDAY */



#ifdef HAVE_TIMES
/* this is the time elapsed since the timer start in milliseconds */
INT utDtimer_elapsed(UTDTIMERPTR timer_p)
{
  struct tms tp;
  INT time_elapsed ;
  INT time_offset ;
  if( timer_p->base_time == 0 ){
    /* start was not called */
    return(0) ;
  }
  times(&tp);
  time_offset = (INT) tp.tms_utime + (INT) tp.tms_stime;
  time_offset -= timer_p->base_time ;
  time_elapsed = (DOUBLE)time_offset * ((DOUBLE)1000/60);
  /* 1/60 sec to milisec */
  return(time_elapsed) ;
} /* end utDtimer_elapsed */
#endif /* HAVE_TIMES */


#ifdef HAVE_FTIME
/* this is the time elapsed since the timer start in milliseconds */
INT utDtimer_elapsed(UTDTIMERPTR timer_p)
{
  struct timeb tp;
#if defined(ultrix)
  void ftime(struct timeb *) ;
#endif /* ultrix */
  INT time_elapsed ;
  INT time_offset ;
  if( timer_p->base_time == 0 ){
    /* start was not called */
    return(0) ;
  }
  ftime(&tp) ;
  /* now add the current time */
  time_offset = (INT) tp.time ;
  /* now subtract the start time */
  time_offset -= timer_p->base_time ;
  /* now multiply by 1000 to change to milliseconds */
  time_offset *= 1000 ;
  /* now add the current millisecond time */
  time_offset += (INT) tp.millitm ;
  /* now subtract the start millisecond time */
  time_offset -= timer_p->milli_time ;
  /* return the answer */
  time_elapsed = time_offset ;
  return(time_elapsed) ;
} /* end utDtimer_elapsed */
#endif /* HAVE_FTIME */


#ifdef HAVE_GETTIMEOFDAY
/* this is the time elapsed since the timer start in milliseconds */
INT utDtimer_elapsed(UTDTIMERPTR timer_p)
{
  struct timeval tp ;
  INT time_elapsed ;
  INT time_offset ;
  if( timer_p->base_time == 0 ){
    /* start was not called */
    return(0) ;
  }
  gettimeofday(&tp,NULL) ;
  /* now add the current time */
  time_offset = (INT) tp.tv_sec ;
  /* now subtract the start time */
  time_offset -= timer_p->base_time ;
  /* now multiply by 1000 to change to milliseconds */
  time_offset *= 1000 ;
  /* now add the current millisecond time */
  time_offset += (INT) (tp.tv_usec / 1000) ;
  /* now subtract the start millisecond time */
  time_offset -= timer_p->milli_time ;
  /* return the answer */
  time_elapsed = time_offset ;
  return(time_elapsed) ;
} /* end utDtimer_elapsed */
#endif /* HAVE_GETTIMEOFDAY */

#ifdef TEST

#ifdef HAVE_STDLIB_H
#include  <stdlib.h>
#endif /* HAVE_STDLIB_H */

#include <utd/debug.h>

int main(int argc, char **argv)
{
    INT i ;				/* counter */
    INT count ;				/* counter */
    UTDTIMER timer ;			/* timer info */

    utDdebug_init(TRUE);
    utDtimer_start(&timer) ;
    count = 0 ;
    for( i = 1 ; i <= 1000000 ; i++ ){
      count++ ;
    }
#ifdef HAVE_GETTIMEOFDAY
    fprintf( stderr, "It took %d to count using gettimeofday...\n", 
      utDtimer_elapsed(&timer) ) ;
#endif

#ifdef HAVE_FTIME
    fprintf( stderr, "It took %d to count using ftime...\n", utDtimer_elapsed(&timer) ) ;
#endif

#ifdef HAVE_TIMES
    fprintf( stderr, "It took %d to count using times...\n", utDtimer_elapsed(&timer) ) ;
#endif /* HAVE_TIMES */


    exit(0) ;
    return(0) ;

} /* end main() */

#endif /* TEST */
