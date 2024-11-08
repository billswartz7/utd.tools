/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    stats.c                                       
DESCRIPTION:Get runtime statistics in UNIX.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif /* HAVE_SYS_TYPES_H */

#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#endif /* HAVE_SYS_TIME_H */

#ifdef HAVE_SYS_RESOURCE_H
#include <sys/resource.h>
#endif /* HAVE_SYS_RESOURCE_H */

#include	<utd/base.h>
#include	<utd/msg.h>
#include	<utd/dstring.h>
#include	<utd/time.h>
#include	<utd/program.h>
#include	<utd/system.h>
#include	<utd/string.h>
#include	<utd/stats.h>

#ifdef HAVE_SYS_RUSAGE_H
#include <sys/rusage.h>
#endif /* HAVE_SYS_RUSAGE_H */

#define MDS utDdstring_printf

typedef enum {
  KILOSIZE = (10 * 1024),
  MEGSIZE =  (KILOSIZE * 1024LL),
  GIGSIZE =  (MEGSIZE * 1024LL),
  TERASIZE = (GIGSIZE * 1024LL),
  PETASIZE = (TERASIZE * 1024LL),
  EXASIZE = (PETASIZE * 128LL)
} MEGPRINT_T ;

#define MEGPRINT(use_xz) \
  megprint_size(use_xz), megprint_units(use_xz)

static INT64 megprint_size( INT64 val )
{
    INT64 new_val ;		/* adjusted size */
    if( val < KILOSIZE ){
      new_val = val ;
    } else if( val < MEGSIZE ){
      new_val = val >> 10 ;
    } else if ( val < GIGSIZE ){
      new_val = val >> 20 ;
    } else if ( val < TERASIZE ){
      new_val = val >> 30 ;
    } else if ( val < PETASIZE ){
      new_val = val >> 40 ;
    } else if ( val < EXASIZE ){
      new_val = val >> 50 ;
    } else {
      new_val = val >> 60 ;
    }
    return(new_val ) ;
} /* end megprint_size() */

static char megprint_units( INT64 val )
{
    char units ;		/* unit amount */
    if( val < KILOSIZE ){
      units = ' ' ;
    } else if( val < MEGSIZE ){
      units = 'K' ;
    } else if ( val < GIGSIZE ){
      units = 'M' ;
    } else if ( val < TERASIZE ){
      units = 'G' ;
    } else if ( val < PETASIZE ){
      units = 'T' ;
    } else if ( val < EXASIZE ){
      units = 'P' ;
    } else {
      units = 'E' ;
    }
    return(units ) ;
} /* end megprint_units() */

/* print out the statistics of the program to the given file */
char * _utDstats_print(UTDDSTRINGPTR dsPtr)
{
    char	*hostname;
    INT	text		;
    INT	data		;
    INT64 use           ;
    INT64 max_use       ;
    INT64 vm_used	;
    INT64 vm_used_raw	;
    INT64 vm_limit	;
    INT64 vm_limit_eng	;
    INT64 vm_soft_limit	;
    INT64 vm_soft_limit_eng ;
    INT elapsed_time    ;
    MEGPRINT_T val ;
    DOUBLE	user		;
    DOUBLE	systemTime	;
    DOUBLE	scale		;
    DOUBLE	run_time	;
    struct rusage	rusage	;
    struct rlimit 	rlp	;
    caddr_t		p	;
    caddr_t		sbrk(int)	;

    /***********************************************************
    * Get the hostname
    ***********************************************************/
    hostname = utDhostname() ;

    /***********************************************************
    * Get the brk() value
    ***********************************************************/
    p = sbrk(0) ;
    vm_used_raw = (INT64) p ;
    vm_used = (INT64) ((DOUBLE) vm_used_raw / 1024.0 + 0.5) ;
    val = MEGSIZE ;

    /***********************************************************
    * Get virtual memory limits
    ***********************************************************/
    getrlimit(RLIMIT_DATA, &rlp) ;
    vm_limit = rlp.rlim_max ;
    vm_limit_eng = rlp.rlim_max / 1024.0 + 0.5 ;
    vm_soft_limit = rlp.rlim_cur ;
    vm_soft_limit_eng = rlp.rlim_cur / 1024.0 + 0.5 ;

    /***********************************************************
    * get usage stats
    ***********************************************************/
    getrusage(RUSAGE_SELF, &rusage) ;
    user = rusage.ru_utime.tv_sec + rusage.ru_utime.tv_usec / 1.0e6 ;
    systemTime = rusage.ru_stime.tv_sec + rusage.ru_stime.tv_usec/1.0e6 ;
    scale = (user + systemTime) * 100.0 ;
    if (scale == 0.0)
    {
	scale = 0.001 ;
    }
    /* now get elapsed time */
    elapsed_time = utDprogram_elapsed_time() ;
    /* time is in milliseconds */
    run_time = ( (DOUBLE) elapsed_time) / 1000.0 ;

    MDS(dsPtr, "\n\n") ;
    MDS(dsPtr, "Runtime Statistics\n") ;
    MDS(dsPtr, "-------------------------\n") ;
    MDS(dsPtr, "Machine name: %s\n", hostname) ;
    MDS(dsPtr, "Machine type: %s\n", utDuname()) ;
    MDS(dsPtr, "Date        : %s\n\n", utDtime_get(0)) ;

    MDS(dsPtr, "User    time:%6.1f seconds\n", user) ;
    MDS(dsPtr, "System  time:%6.1f seconds\n", systemTime) ;
    MDS(dsPtr, "Elapsed time:%6.1f seconds\n\n", run_time) ;

    text = rusage.ru_ixrss / scale + 0.5 ;
    data = (rusage.ru_idrss + rusage.ru_isrss) / scale + 0.5 ;
    MDS(dsPtr, "Average resident text size       = %10dK\n", text) ;
    MDS(dsPtr, "Average resident data+stack size = %10dK\n", data) ;
    MDS(dsPtr, "Maximum resident size            = %10ldB (%ld%cB)\n", 
	rusage.ru_maxrss/2, MEGPRINT(rusage.ru_maxrss/2) ) ;
    MDS(dsPtr, "Virtual memory size              = %10ldK (%ld%cB)\n", 
	vm_used, MEGPRINT(vm_used_raw) ) ;
    MDS(dsPtr, "Virtual memory limit soft        = %10ldK (%ld%cB)\n", 
	vm_soft_limit_eng, MEGPRINT(vm_soft_limit) ) ;
    MDS(dsPtr, "Virtual memory limit max         = %10ldK (%ld%cB)\n", 
	vm_limit_eng, MEGPRINT(vm_limit) ) ;

    MDS(dsPtr, "\nMajor page faults = %ld\n", rusage.ru_majflt) ;
    MDS(dsPtr, "Minor page faults = %ld\n", rusage.ru_minflt) ;
    MDS(dsPtr, "Swaps = %ld\n\n", rusage.ru_nswap) ;

    MDS(dsPtr, "Input blocks = %ld\n", rusage.ru_inblock) ;
    MDS(dsPtr, "Output blocks = %ld\n\n", rusage.ru_oublock) ;

    MDS(dsPtr, "Context switch (voluntary) = %ld\n", rusage.ru_nvcsw) ;
    MDS(dsPtr, "Context switch (involuntary) = %ld\n", rusage.ru_nivcsw) ;

    return( utDdstring_value(dsPtr) ) ;

} /* end _utDstats_print */


/* print out the statistics of the program to the given file */
void utDstats_print(FILE *fout)
{
    UTDDSTRING mbuf ;			/* message buffer */

    utDdstring_init( &mbuf ) ;
    fprintf(fout, "%s\n", _utDstats_print(&mbuf) ) ;
    utDdstring_free( &mbuf ) ;

} /* end utDstats_print */
/* ==================================================================== */

DOUBLE utDstats_cpu_time(void)
{
    INT getrusage(int, struct rusage *) ;
    struct rusage rusage;
    double user, systemTime;

    getrusage(RUSAGE_SELF, &rusage);
    user = rusage.ru_utime.tv_sec + rusage.ru_utime.tv_usec/1.0e6;
    systemTime = rusage.ru_stime.tv_sec + rusage.ru_stime.tv_usec/1.0e6;
    return( user+systemTime ) ;
} /* end utDstats_cpu_time */

/* ==================================================================== */

/* #define TEST */
#ifdef TEST

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */

/* test whether code works correctly. */

int main(void)
{
    char *foo ;

    utDstats_print( stdout ) ;
    foo = UTDMALLOC( 1000, char) ;
    utDstats_print( stdout ) ;
    exit(0) ;
}

void megprint( INT64 val )
{
    fprintf( stderr, "(%lld %cb)\n", megprint_size(val), megprint_units(val) ) ;
}

#endif
