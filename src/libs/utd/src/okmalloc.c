/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	     okmalloc.c 
DESCRIPTION: Memory management routines for C programs.
REVISIONS: 
----------------------------------------------------------------- */
#include 	<utdconfig.h>
#include	<stdio.h>
#include	<signal.h>

#ifdef HAVE_STDLIB_H
#include 	<stdlib.h>
#endif /* HAVE_STDLIB_H */

#ifdef HAVE_ERRNO_H
#include	<errno.h>
#endif /* HAVE_ERRNO_H */

#ifdef HAVE_UNISTD_H 
#include	<unistd.h>
#endif /* HAVE_UNISTD_H */

#ifdef HAVE_MALLOC_H 
#include	<malloc.h>
#endif /* HAVE_MALLOC_H */

#ifdef HAVE_MALLOC_MALLOC_H 
#include	<malloc/malloc.h>
#endif /* HAVE_MALLOC_MALLOC_H */

#include 	<utd/base.h>
#include 	<utd/msg.h>
#include 	<utd/debug.h>
#include 	<utd/file.h>
#include 	<utd/system.h>

#ifdef HAVE_MEMORY_H
#include 	<memory.h>
#endif /* end HAVE_MEMORY_H */

#ifdef HAVE_EXECINFO_H
#include 	<execinfo.h> /* alas only available on Linux */
#endif /* HAVE_EXECINFO_H */

#define KILL_FUNC()	kill(utDgetpid(),SIGUSR1)

/* memory errors */
#define  HEAP_ERROR_BASE   0x40060000
#define  HEAP_NO_MEM       (HEAP_ERROR_BASE + 1)

/* debug masks */
#define DEBUGMASK  1
#define DUMPMASK   2

static void debugpoint(void)
{
} /* end debugpoint() */

#ifdef UTDMEM_DEBUG
typedef struct mem_debug_rec {
  INT traceback_length ;	/* how long to traceback */
  UINT64 memory_alloc ;		/* current allocation */
  UINT64 last_update ;		/* last time we output info */
  UINT64 memory_interval ;	/* memory increase to output */
  UINT64 memory_malloc ;	/* number of allocs */
  UINT64 memory_free ;		/* number of frees */
  FILE *memory_fout ;		/* the output stream */
} MEM_DEBUG, *MEM_DEBUGPTR ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static MEM_DEBUGPTR mem_infoS ;

#endif /* UTDMEM_DEBUG */

#ifndef TEST

#ifdef UTDMEM_DEBUG 
static void memory_release( MEM_DEBUGPTR debug_p, VOIDPTR obj_p )
{
#ifdef HAVE_MALLOC_USABLE_SIZE
      size_t old_size ;
      old_size = malloc_usable_size( obj_p ) ;
      if( debug_p ){
	debug_p->memory_alloc -= old_size ;
	debug_p->memory_free++ ;
      }
#else
#ifdef HAVE_MALLOC_SIZE
      size_t old_size ;
      old_size = malloc_size( obj_p ) ;
      if( debug_p ){
	debug_p->memory_alloc -= old_size ;
	debug_p->memory_free++ ;
      }
#endif /* HAVE_MALLOC_SIZE */
#endif /* HAVE_MALLOC_USABLE_SIZE */
} /* end memory_release() */

static void memory_dump_use( MEM_DEBUGPTR debug_p, FILE *fout, UINT64 size )
{
  if( debug_p ){
    if(!(fout)){
      fout = debug_p->memory_fout ;
    }
    if( size > 0 ){
      fprintf( fout, 
	"Memory allocated size:%lld, requested:%lld num_allocs:%lld num_frees:%lld last display size:%lld\n", 
	 debug_p->memory_alloc, size, debug_p->memory_malloc, debug_p->memory_free, 
	 debug_p->last_update ) ;
    } else {
      fprintf( fout, 
	"Current memory size:%lld, num_allocs:%lld num_frees:%lld last display size:%lld\n", 
	 debug_p->memory_alloc, debug_p->memory_malloc, debug_p->memory_free, 
	 debug_p->last_update ) ;
    }
    if( debug_p->traceback_length > 0 ){
      utDbacktrace( "backtrace:", fout, debug_p->traceback_length ) ;
      fprintf( fout, "\n" ) ;
    }
    if( fout != stderr ){
      fflush( fout ) ;
    }
  }
} /* end memory_dump_use() */

static void memory_update_size( MEM_DEBUGPTR debug_p, UINT64 size )
{
    UINT64 new_update ;		/* new incremental memory size */

    if(!(debug_p)){
      return ;
    }
    if( debug_p->memory_alloc == 0 ){
      fprintf( debug_p->memory_fout, "Memory debug enabled.\n" ) ;
    }
    debug_p->memory_alloc += size ;		/* current allocation */
    debug_p->memory_malloc++ ;
    new_update = debug_p->memory_alloc - debug_p->last_update ; /* are we ready to output? */
    if( new_update >= debug_p->memory_interval ){
      memory_dump_use( debug_p, NULL, size ) ;
      debug_p->last_update = debug_p->memory_alloc ;
    }
} /* end memory_update_size() */

#endif /* UTDMEM_DEBUG */


/*
  *--------------------------------------------------------------
  * BEGIN NORMAL C MEMORY MANAGEMENT SYSTEM
  *--------------------------------------------------------------
*/
void *utDmalloc(INT size )
{
    char *p;

    p = (char *) malloc(size) ;
    if(!(p)){
      errno = HEAP_NO_MEM ;
      DS( debugpoint(); );
      KILL_FUNC() ;
    }
#ifdef UTDMEM_DEBUG
    (void) memset( (char *)p, -1, (size_t) size);
    memory_update_size( mem_infoS, size ) ;
#endif /* UTDMEM_DEBUG */
    return(p) ;
} /* end utDmalloc() */


void *utDrealloc(VOIDPTR obj,INT size )
{
    char *p;

    if(!(obj) ){
      p = (char *) malloc(size) ;
      if ( !(p) ) {
        errno = HEAP_NO_MEM ;
	DS( debugpoint(); );
	KILL_FUNC() ;
      }
#ifdef UTDMEM_DEBUG
      (void) memset( (char *)p, -1, (size_t) size);
      memory_update_size( mem_infoS, size ) ;
#endif /* UTDMEM_DEBUG */
      return(p) ;
    } else {
#ifdef UTDMEM_DEBUG
      memory_release( mem_infoS, obj ) ;
#endif /* UTDMEM_DEBUG */
    }

    p = (char *) realloc(obj, size) ;
    if (!(p)){
        errno = HEAP_NO_MEM ;
	DS( debugpoint(); );
	KILL_FUNC() ;
    }
#ifdef UTDMEM_DEBUG
    memory_update_size( mem_infoS, size ) ;
#endif /* UTDMEM_DEBUG */
    return(p) ;
} /* end utDrealloc() */


void *utDcalloc(INT num, INT size )
{
    char *p;

    p = (char *) calloc(num,size) ;
    if (!(p)) {
        errno = HEAP_NO_MEM ;
	DS( debugpoint(); );
	KILL_FUNC() ;
    }
#ifdef UTDMEM_DEBUG
    memory_update_size( mem_infoS, size ) ;
#endif /* UTDMEM_DEBUG */
    return(p) ;
}

/* when not testing memory just call system free */
void utDfree(VOIDPTR ptr)
{
#ifdef UTDMEM_DEBUG
    memory_release( mem_infoS, ptr ) ;
#endif /* UTDMEM_DEBUG */
    free(ptr) ;
    return;
} /* end utDfree() */


LONG utDmalloc_align_size( INT incr, INT obj_size, INT overhead )
{
    INT size ;			/* requested allocation */

    /* Can only calculate user required size */
    size = (UNSIGNED_LONG)incr * (UNSIGNED_LONG)obj_size + overhead ;
    return( size ) ;
} /* end utDmalloc_align_size() */

/* -----------------------------------------------------------------
 * The memory debug functions.
 * ----------------------------------------------------------------- */

UINT64 utDmalloc_use(void)
{
#ifdef UTDMEM_DEBUG
    if( mem_infoS ){
      return( mem_infoS->memory_alloc ) ;
    }
#endif /* UTDMEM_DEBUG */
    return(0) ;
} /* end utDmalloc_use() */

void utDmalloc_dump_use( FILE *fout )
{
#ifdef UTDMEM_DEBUG
    memory_dump_use( mem_infoS, fout, 0 ) ;
#endif /* UTDMEM_DEBUG */
} /* end utDmalloc_dump_use() */

void utDmalloc_set_use(UNSIGNED_LONG new_size, BOOL free_flag )
{
#ifdef UTDMEM_DEBUG
    memory_update_size( mem_infoS, new_size ) ;
#endif /* UTDMEM_DEBUG */
} /* end utDmalloc_set_use() */

void utDmalloc_debug_memory( FILE *fp, UINT64 interval_update, INT tb_len )
{
#ifdef UTDMEM_DEBUG
    if(!(mem_infoS)){
      mem_infoS = UTDCALLOC( 1, MEM_DEBUG ) ;
    }
    mem_infoS->memory_interval = interval_update ;
    mem_infoS->memory_fout = fp ;	
    mem_infoS->traceback_length = tb_len ;
#else 
    utDmsg(IMSG,MSG_AT,"utDmalloc_debug_memory", "debug not compiled in.\n" ) ;
#endif /* UTDMEM_DEBUG */
} /* end utDmalloc_debug_memory() */

void utDmalloc_debug_memory_free( void )
{
#ifdef UTDMEM_DEBUG
    if( mem_infoS ){
      if( mem_infoS->memory_fout ){
	UTDCLOSE( mem_infoS->memory_fout ) ;
      }
      UTDFREE( mem_infoS ) ;
      mem_infoS = NULL ;
    }
#endif /* UTDMEM_DEBUG */
} /* end utDmalloc_debug_memory_free() */

void utDmalloc_debug_memory_interval( UINT64 interval_update )
{
#ifdef UTDMEM_DEBUG
    if(!(mem_infoS)){
      return ;
    }
    mem_infoS->memory_interval = interval_update ;
#endif /* UTDMEM_DEBUG */
} /* end utDmalloc_debug_memory_interval() */

#ifndef PURIFY_DEBUG
/* *******  memory convenience functions  ******* */
/* ALLOCATE an array [lo..hi] of the given size not initialized */
void *utDvector_alloc( INT lo, INT hi, INT size )
{
    char *array_return ;

    if( hi < lo ) {
      utDmsg(ERRMSG|MSG_RESTRICTED, "utd/utDvector_alloc:1", "utDvector_alloc", "hi < lo\n") ;
      DS( debugpoint(); );
      return ( NULL );
    }

    array_return = (char *) utDmalloc((unsigned) (hi-lo+1)*size ) ;
    if( array_return ){
	return( array_return - size * lo ) ;
    }
    return( NULL ) ;

} /* end utDvector_alloc() */

/* ALLOCATE an array [lo..hi] of the given size initialized to zero */
void *utDvector_calloc( INT lo, INT hi, INT size )
{
    char *array_return ;

    if( hi < lo ) {
      utDmsg(ERRMSG|MSG_RESTRICTED, "utd/utDvector_calloc:1", "utDvector_calloc", "hi < lo\n");
      DS( debugpoint(); );
      return ( NULL );
    }
    array_return = (char *) utDcalloc((unsigned) (hi-lo+1),size ) ;
    if( array_return ){
	return( array_return - size * lo ) ;
    }
    return( NULL ) ;

} /* end utDvector_calloc() */

/* REALLOCATE an array [lo..hi] of the given size no initialization */
void *utDvector_realloc(VOIDPTR array_orig,INT lo,INT hi,INT size )
{
    char *adj_array ;          /* put back the offset */
    char *array_return ;       /* the new offset */

    if( hi < lo ) {
      utDmsg(ERRMSG|MSG_RESTRICTED, "utd/utDvector_realloc:1", "Yvector_realloc", "hi < lo\n");
      DS( debugpoint(); );
      return ( NULL );
    }
    if(!(array_orig)){
      return( utDvector_alloc( lo, hi, size ) ) ;
    }
    adj_array = ((char *) array_orig) + lo * size ;
    array_return = (char *) 
	utDrealloc( adj_array, (unsigned) (hi-lo+1)*size ) ;
    if( array_return ){
	return( array_return - size * lo ) ;
    }
    return( NULL ) ;

} /* end utDvector_realloc() */

void utDvector_free( VOIDPTR array, INT lo, INT size )
{
  if( array ) {
    utDfree( ((char *)array) + lo * size ) ;
  }
} /* end utDvector_free */



#else  /* purified */

/* To be completed */

#endif /* PURIFY */

/* ************************* TEST ROUTINES ******************************** */
#else /*  TEST */ 

typedef struct foo {
  INT junk1 ;
  DOUBLE junk2 ;  // put in wrong packing order to show problems show problems.
} MY_JUNK, *MY_JUNKPTR ;

INT main( INT argc, char **argv )
{
    MY_JUNKPTR *array ;
    FILE *fout ;
    INT i ;

    fout = UTDOPEN( "mem.out", "w", FILE_ABORT| FILE_VERBOSE) ;

    utDmalloc_debug_memory( fout, 1000, 5 ) ;
    array = UTDVECTOR_MALLOC( 1, 1000, MY_JUNKPTR) ;
    for( i = 1 ; i <= 1000 ; i++ ){
      array[i] = UTDMALLOC( 10, MY_JUNK ) ;
    }
    /* purposefully don't close file descriptor to test flush */
    utDmalloc_dump_use( NULL ) ;
    exit(0) ;
    utDmalloc_debug_memory_free() ;
    
}  /* end main() */

#endif /* TEST */
