/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    mempools.c                                       
DESCRIPTION:Code to build and maintain memory pools.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
/* The order is important */
#include <utdconfig.h>

#ifdef HAVE_MEMORY_H
#include <memory.h>
#endif /* end HAVE_MEMORY_H */

#ifdef HAVE_EXECINFO_H
#include <execinfo.h>
#endif /* HAVE_EXECINFO_H */

#ifdef HAVE_UNISTD_H 
#include <unistd.h>
#endif /* HAVE_UNISTD_H */

#ifdef HAVE_MALLOC_MALLOC_H
#include <malloc/malloc.h>
#endif /* HAVE_MALLOC_MALLOC_H */


#include <utd/base.h>
#include <utd/debug.h>
#include <utd/exec.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/string.h>
#include <utd/system.h>

#ifdef HAVE_POOL_OPT
#include <std/hash.h>
#endif /* HAVE_POOL_OPT */

/********************************************************************
 * declaration
 ********************************************************************/
#define ERROR 		  (-1)
#define READ 	  	  (0)
#define WRITE 		  (1)
#define MININUM_INCR       8
#define HEAD_INCR          4000
#define POOL_HASH_THRESHOLD 100
#define DSIZE_MALLOC_FAIL	(1L << 31) - 1 

#ifdef DEBUG
#define DF( name_xz)  { name_xz } 
#define FIXMEM_DEBUG1	,phead_p
#define FIXMEM_DEBUG2	,POOLHEADPTR phead_p
#else 
#define DF( name_xz)  
#define FIXMEM_DEBUG1
#define FIXMEM_DEBUG2
#endif

#define POOL_OVERHEAD ((INT) ((char *)&((struct poolrec *)0)->storage - (char *)0))

typedef union {                       /* alignment purpose */
  LONG l ;
  DOUBLE d ;
  INT i ;
  VOIDPTR p ;
} ALIGNMENT_TAG ;

typedef struct poolrec {
  struct poolrec *next_pool ;
  INT index;
  INT limit;
#ifdef DEBUG
  INT tag;
#endif /* DEBUG */
  ALIGNMENT_TAG storage;
} POOL, *POOLPTR; 

typedef struct reservoir {
  VOIDPTR dptr;
  struct reservoir *next_res;
} *RESERVOIRPTR, RESERVOIR;

typedef struct poolhead {
  POOLPTR dpool;
  POOLPTR fpool;
  RESERVOIRPTR free_res;
  RESERVOIRPTR unused_res;
  INT next_id;
  UNSIGNED_INT dsize : 31 ;	/* dsize can only be positive so use top bit */
  UNSIGNED_INT reset_incr : 1 ;	/* if true reset increment after pool alloc */
  INT incr ;
  INT num_alloc ;
  INT num_now ;
  INT num_res_alloc ;
  INT num_used ;
#ifdef DEBUG
#ifdef HAVE_BACKTRACE
  char *traceback ;
#endif /* HAVE_BACKTRACE */
#endif /* DEBUG */
} POOLHEAD, *POOLHEADPTR ;

#ifdef HAVE_POOL_OPT
typedef struct compact_rec {
  POOLHEADPTR phead ;
  YHASHPTR free_spaces ;
  YHASHPTR relocated ;
} COMPACTBOX, *COMPACTPTR ;
#endif /* HAVE_POOL_OPT */

/********************************************************************
 * static variables
 ********************************************************************/
static POOLHEADPTR poolheadS;
static INT free_headS = MALLOC_BLK_FAIL ;
static INT max_headS = 0 ;
static BOOL enable_blkS = FALSE;
DBGDEFINE(BOOL backtrace_debugS ;)

/********************************************************************
 * static function declaration
 ********************************************************************/
static void head_reset( POOLHEADPTR phead) ;
static INT free_pool(POOLPTR p FIXMEM_DEBUG2) ;

static POOLPTR alloc_pool( INT incr, INT size ) ;
static void free_blk( INT id, VOIDPTR ptr ) ;
static void alloc_head( INT more ) ;
static VOIDPTR calloc_blk( INT id ) ;
static VOIDPTR malloc_blk( INT id ) ;
DBGDEFINE(static char *addr2line(char *,char *,FILE *,FILE *) ; )
#ifdef HAVE_POOL_OPT
static INT blk_find_free( POOLPTR pool_p, INT start_idx, COMPACTPTR cdata_p) ;
static INT blk_find_used( POOLPTR pool_p, INT start_idx, COMPACTPTR cdata_p ) ;
static void blk_remove_all_free_pools(POOLHEADPTR phead_p) ; 
static void blk_set_index( POOLPTR pool_p, COMPACTPTR cdata_p ) ;
static void blk_rebuild_free_list(POOLHEADPTR phead,YHASHPTR free_spaces) ;
static void blk_free_pool_spaces( POOLPTR pool_p, COMPACTPTR cdata_p ) ;
static void blk_move( POOLPTR fp,INT f,POOLPTR up,INT u,COMPACTPTR cdata_p ) ;
static YHASHPTR blk_compact_pools(POOLHEADPTR phead_p) ;
static YHASHPTR blk_compact( POOLPTR *carray, INT numpools, COMPACTPTR cdata_p) ;
#endif /* HAVE_POOL_OPT */


BOOL utDmempool_enabled(void)
{
  return( enable_blkS ) ;
} /* end utDmempool_enabled() */

void utDmempool_enable(BOOL install)
{
  if( enable_blkS ) {
    utDmsg(DBGMSG,MSG_AT,"utDmempool_enable", "already installed\n");
    return;
  }

  if( install ) {
    enable_blkS = TRUE;
    max_headS = 1 ;
    utDmsg(DBGMSG,MSG_AT,"utDmempool_enable", "enabled now\n");
  }
} /* end utDmempool_enable() */

void utDmempool_free_all(void)
{
    if( poolheadS ){
      UTDVECTOR_FREE( poolheadS, 1 ) ;
      /* restore static variables */
      poolheadS = NULL ;
      free_headS = MALLOC_BLK_FAIL ;
      max_headS = 0 ;
      enable_blkS = FALSE ;
    }
} /* end utDmempool_free_all() */

static void head_reset(POOLHEADPTR phead)
{
  phead->dpool = NULL ;
  phead->fpool = NULL ;
  phead->free_res = NULL ;
  phead->unused_res = NULL ;
  phead->incr = 0 ;
  phead->reset_incr = 1 ;
  phead->dsize = 0 ;
  DF( phead->num_alloc     = 0 ; );
  DF( phead->num_now       = 0 ; );
  DF( phead->num_res_alloc = 0 ; );

} /* end head_reset() */

static void alloc_head(INT more)
{
  INT i;
  if( free_headS > 0 ) {
    utDmsg(ERRMSG, MSG_AT, "alloc_head", "free id wrong\n");
  }

  poolheadS = UTDVECTOR_REALLOC( poolheadS, 1, max_headS+more,POOLHEAD ) ;

  for( i = max_headS ; i < max_headS + more ; i++ ) {
    POOLHEADPTR phead = poolheadS + i;
    head_reset(phead);
    DF( phead->num_used = 0 ; ) ;
    phead->next_id = i+1 ;
  }
  free_headS = max_headS;
  max_headS += more;
  poolheadS[max_headS-1].next_id = MALLOC_BLK_FAIL ;
} /* end alloc_head() */



/* -----------------------------------------------------------------
 * Pool increment routines.
----------------------------------------------------------------- */
void utDmempool_pool_incr(INT id, INT incr)
{
  if( id > 0 ) {
    POOLHEADPTR phead;
    phead = poolheadS + id ;
    phead->incr += incr;
  }
} /* end utDmempool_pool_incr() */

void utDmempool_pool_incr_max(INT id, INT incr)
{
  if( id > 0 ) {
    POOLHEADPTR phead;
    phead = poolheadS + id ;
    phead->incr = incr;
  }
} /* end utDmempool_pool_incr_max() */

INT utDmempool_pool_incr_reset(INT id, UTD_BLK_STATUS_T status)
{
    if( id > 0 ){
      POOLHEADPTR phead;
      phead = poolheadS + id ;
      if( status == UTD_BLK_STATUS_SET ){
	phead->reset_incr = 1 ;
      } else if( status == UTD_BLK_STATUS_RESET ){
	phead->reset_incr = 0 ;
      }
      return( phead->reset_incr ) ;	/* reset increment flag */
    }
    return( -1 ) ;
} /* end utDmempool_pool_incr_reset() */

INT utDmempool_init(INT init_incr, INT bytes)
{
  INT id;
#ifdef HAVE_BACKTRACE
  DBGDEFINE(INT c ;)
  DBGDEFINE(int num_on_stack ;)
  DBGDEFINE(char num_buf[40] ;)
  DBGDEFINE(char stack_buffer[LRECL] ;)
  DBGDEFINE(void *stack_array[MAX_BACKTRACE] ;)
#endif /* HAVE_BACKTRACE */

  if( ! enable_blkS ) return( MALLOC_BLK_FAIL);
  if( bytes <= 0 ) return( MALLOC_BLK_FAIL);
  if( free_headS < 0 ) {
    alloc_head( HEAD_INCR ) ;
  }

  id = free_headS;
  poolheadS[id].incr = MAX(0, init_incr);
  poolheadS[id].dsize = bytes;

#if defined(HAVE_BACKTRACE) && defined(DEBUG)
  if( backtrace_debugS ){
    num_on_stack = backtrace( stack_array, MAX_BACKTRACE ) ;
    stack_buffer[0] = EOS ;
    for( c = 0 ; c < num_on_stack ; c++ ){
      if( c == 0 ){
	sprintf( num_buf, "%#llx", (UINT64) stack_array[c]);
      } else {
	sprintf( num_buf, " %#llx", (UINT64) stack_array[c]);
      }
      strcat( stack_buffer, num_buf ) ;
    }
    poolheadS[id].traceback = utDstrclone( stack_buffer ) ;

  } else {
    poolheadS[id].traceback = NULL ;
  }
#endif /* HAVE_BACKTRACE */

  DF( poolheadS[id].num_used++ ; );


  free_headS = poolheadS[id].next_id;
  poolheadS[id].next_id = MALLOC_BLK_FAIL ;  /* not necessary, for clarity */
#ifdef DEBUG
  if( free_headS == id ){
    utDmsg(ERRMSG,MSG_AT,"utDmempool_pool_init", "Logic error here.\n" ) ;
  }
#endif /* DEBUG */

  return(id) ;

} /* end utDmempool_init() */


VOIDPTR utDmempool_malloc(INT id, INT size)
{
  if( id > 0 ) {
    return( malloc_blk(id) );
  } else {
    return( utDmalloc(size) ) ;
  }
}

VOIDPTR utDmempool_calloc(INT id, INT size)
{
  if( id > 0 ) {
    return( calloc_blk(id) );
  } else {
    return( utDcalloc(1, size));
  }
}

void utDmempool_free_item(INT id, VOIDPTR ptr)
{
  if( id > 0 ) {
    free_blk(id, ptr);
  } else {
    utDfree(ptr);
  }
}

static void free_blk(INT id, VOIDPTR ptr)
{
  POOLHEADPTR phead;
  INT i;
  RESERVOIRPTR res;
  POOLPTR fnew;

  phead = poolheadS + id ;
  DF( phead->num_now -- ; );
  if( ! phead->unused_res ) {
    fnew = alloc_pool( 0, sizeof(RESERVOIR));
    DF( phead->num_res_alloc += fnew->limit; );
    for( res = (RESERVOIRPTR)(&fnew->storage.l), i=0 ; i < fnew->limit -1; i++) {
      res[i].next_res = res + i + 1;
    }
    res[fnew->limit-1].next_res = NULL;
    phead->unused_res = res;
    fnew->next_pool = phead->fpool ;
    phead->fpool = fnew;
  }
  res = phead->unused_res;
  phead->unused_res = phead->unused_res->next_res;
  res->dptr = ptr;
  res->next_res = phead->free_res;
  phead->free_res = res;

} /* end free_blk() */



static INT free_pool(POOLPTR p FIXMEM_DEBUG2)
{
  POOLPTR next_p ;
  INT freed = 0 ;
  for( ; p ; p = next_p ) {
    next_p = p->next_pool ;
    DF( freed += phead_p->dsize * p->index; ) ;
    DF( freed += sizeof( *p ) ; ) ;
    utDfree( p);
  }
  return(freed) ;
} /* end free_pool() */

INT utDmempool_free_pool(INT id)
{
  POOLHEADPTR phead_p ;
  INT freed = 0 ;

  if( id > 0 ) {
    phead_p  = poolheadS + id;
#if defined(HAVE_BACKTRACE) && defined(DEBUG)
    if( backtrace_debugS ){
      if( phead_p ->traceback ){
	UTDFREE( phead_p ->traceback ) ;
	phead_p ->traceback = NULL ;
      }
    }
#endif /* HAVE_BACKTRACE */
    freed += free_pool( phead_p->dpool FIXMEM_DEBUG1) ;
    freed += free_pool( phead_p ->fpool FIXMEM_DEBUG1) ;
    head_reset( phead_p ) ;
    phead_p->next_id = free_headS;
    free_headS = id;
#ifdef DEBUG
    if( phead_p->next_id == free_headS ){
      utDmsg(ERRMSG, MSG_AT, "utDmempool_free", "Logic error here.\n" ) ;
    }
#endif /* DEBUG */
  }
  return(freed) ;

} /* end utDmempool_free_pool() */

#ifdef HAVE_POOL_OPT

/* -----------------------------------------------------------------
 * We build this wrapper around the hash table because we want to 
 * insure that the hash table itself doesn't use memory blocks which
 * could ruin our effort.
----------------------------------------------------------------- */
static YHASHPTR blk_hash_init_pointer( INT size )
{
  BOOL save_enable_blk ;		/* save block state */
  YHASHPTR htable_p ;			/* hash table created */

  save_enable_blk = enable_blkS ;
  enable_blkS = FALSE ;
  htable_p = Yhash_init_pointer( size ) ;
  enable_blkS = save_enable_blk ;
  return( htable_p ) ;
} /* end blk_hash_init_pointer() */


YHASHPTR Ymalloc_blk_optimize(INT id,BOOL compact)
{
  POOLHEADPTR phead_p ;			/* used in free */
  YHASHPTR crossref_p ;			/* cross ref hash table */

  if(!(enable_blkS) || (id < 0) ){
    return(NULL) ;
  }
  /* -----------------------------------------------------------------
   * First look thru free lists.  If something is free, make a hash
   * table of all of the free items.
   * ----------------------------------------------------------------- */
  phead_p = poolheadS + id ;
  if(!(phead_p)){
    return(NULL) ;
  }
  if(!(phead_p->free_res)){
    return(NULL) ;
  }
  if( compact ){
    crossref_p = blk_compact_pools(phead_p) ;
  } else {
    blk_remove_all_free_pools(phead_p) ;
    crossref_p = NULL ;
  }
  return(crossref_p) ;

} /* end Ymalloc_blk_optimize() */

static YHASHPTR blk_compact_pools(POOLHEADPTR phead_p) 
{
  INT i ;				/* pool item index */
  INT alloc ;				/* current allocation */
  INT num_partially_empty ;		/* number of half-filled pools */
  YHASHPTR free_spaces ;		/* free spaces */
  RESVOIRPTR res_p ;			/* list of free objects */
  POOLPTR pool_p ;			/* traverse pools */
  POOLPTR *compact_array ;		/* array for compaction */
  POOLPTR first_pool_p ;		/* first pool found */
  VOIDPTR data ;			/* data stored in pool */
  COMPACTBOX cdata ;			/* common compact data */
  YHASHPTR relocated ;			/* relocated info */

  free_spaces = blk_hash_init_pointer(HASH_MIN_SIZE) ;
  for( res_p = phead_p->free_res ; res_p ; res_p = res_p->next_res ){
    Yhash_insert( free_spaces, res_p->dptr, res_p->dptr ) ;
  }
  compact_array = NULL ;
  first_pool_p = NULL ;
  alloc = 0 ;
  num_partially_empty = 0 ;
  /* -----------------------------------------------------------------
   * Now we need to see if we need to move data to empty slots.  We will
   * always have one pool possibly empty so we only create array when we
   * get two pools that are problematic.
   * ----------------------------------------------------------------- */
  for( pool_p = phead_p->dpool ; pool_p ; pool_p = pool_p->next_pool ){
    if( pool_p->index == pool_p->limit ){
      for( i = 0 ; i < pool_p->index ; i++ ){
	data = (VOIDPTR) (((UNSIGNED_LONG )( &pool_p->storage.l ) + 
	                    phead_p->dsize * i ) ) ;
	if( Yhash_find( free_spaces, data) ){
	  /* this is an used space add to array */
	  if( first_pool_p ){
	    if( compact_array ){
	      if( ++num_partially_empty > alloc ){
		alloc *= 2 ;
		compact_array = UTDVECTOR_REALLOC( compact_array,1,alloc,POOLPTR ) ;
	      }
	      compact_array[num_partially_empty] = pool_p ;

	    } else {
	      alloc = 100 ;
	      compact_array = UTDVECTOR_MALLOC( 1, alloc, POOLPTR ) ;
	      compact_array[1] = first_pool_p ;
	      compact_array[2] = pool_p ;
	      num_partially_empty++ ;
	    }
	  } else {
	    first_pool_p = pool_p ;
	    num_partially_empty++ ;
	  }
	  break ;
	}
      }
    } else {
      if( first_pool_p ){
	if( compact_array ){
	  if( ++num_partially_empty > alloc ){
	    alloc *= 2 ;
	    compact_array = UTDVECTOR_REALLOC( compact_array,1,alloc,POOLPTR ) ;
	  }
	  compact_array[num_partially_empty] = pool_p ;

	} else {
	  alloc = 100 ;
	  compact_array = UTDVECTOR_MALLOC( 1, alloc, POOLPTR ) ;
	  compact_array[1] = first_pool_p ;
	  compact_array[2] = pool_p ;
	  num_partially_empty++ ;
	}
      } else {
	first_pool_p = pool_p ;
	num_partially_empty++ ;
      }
    }
  }

  /* -----------------------------------------------------------------
   * At this time we can see if we are actually going to perform compaction;
   * we just need to look to see if compact_array was created.  If not
   * we can free the hash table and return ;
   * ----------------------------------------------------------------- */
  if(!(compact_array)){
    Yhash_free( free_spaces, NULL, NULL ) ;
    return(NULL) ; 
  }

  /* -----------------------------------------------------------------
   * We know we are going to compact so free the free pools to save some
   * space.
   * ----------------------------------------------------------------- */
  free_pool( phead_p->fpool FIXMEM_DEBUG1) ;
  phead_p->fpool = NULL ;

  /* -----------------------------------------------------------------
   * Now perform the compaction algorithm.  We move data from the low end
   * to the high end of the array.
   * ----------------------------------------------------------------- */
  cdata.phead = phead_p ;
  cdata.free_spaces = free_spaces ;
  cdata.relocated = NULL ;
  relocated = blk_compact( compact_array, num_partially_empty, &cdata ) ;

  /* -----------------------------------------------------------------
   * Now cleanup the memory and rebuild the free pools from the hash table.
   * ----------------------------------------------------------------- */
  blk_rebuild_free_list( phead_p, free_spaces) ;
  Yhash_free( free_spaces, NULL, NULL ) ;
  UTDVECTOR_FREE( compact_array, 1 ) ;

  return( relocated ) ;

} /* end blk_compact_pools() */

static YHASHPTR blk_compact( POOLPTR *carray, INT numpools, COMPACTPTR cdata_p )
{
    INT i ;				/* counter */
    INT s ;				/* counter */
    INT pool ;				/* pool counter */
    INT free_pool ;			/* current free pool index in array */
    INT used_pool ;			/* current used pool index in array */
    INT free_idx ;			/* current free item in free pool */
    INT used_idx ;			/* current used item in used pool */
    INT all_pool_cnt ;			/* count all pools */
    BOOL need_link ;			/* need to relink */
    POOLPTR upool_p ;			/* used pool to reindex */
    POOLPTR fpool_p ;			/* pool to free */
    POOLPTR opool_p ;			/* old pools */
    POOLPTR rpool_p ;			/* relinked pools */
    POOLPTR last_pool ;			/* last pool */
    POOLPTR next_pool ;			/* next pool to traverse */
    YHASHPTR array_hash ;		/* for quick lookup */

    /* -----------------------------------------------------------------
     * This algorithm tries to compact blocks by moving used blocks to
     * holes in the lower area.  The array is in order of memory creation
     * time so the idea is to move data back to fillin stuff created earlier.
     * But we could resort the arrays on other criteria such as utilization.
     * The idea is that we divide the array into two pieces the low end is
     * the pools that we will fill up with used data and keep.  The upper
     * pools will be emptied into the lower pools.  So the idea is to
     * find free blocks (open spaces) in the used blocks and fill them
     * with the used blocks (data) of the upper blocks.
    ----------------------------------------------------------------- */
    used_pool = 1 ;
    used_idx = blk_find_free( carray[used_pool], -1, cdata_p ) ;
    free_pool = numpools ;
    free_idx = blk_find_used( carray[free_pool], -1, cdata_p ) ;
    do {
      /* perform swap */
      blk_move( carray[used_pool],used_idx,carray[free_pool],free_idx,cdata_p) ;

      /* get next values */
      do {
	free_idx = blk_find_used(carray[free_pool], free_idx, cdata_p ) ;
	if( free_idx < 0 ){
	  if( used_pool == free_pool ){
	    break ;
	  }
	  if( --free_pool <= 0 ){
	    break ;
	  }
	  free_idx = blk_find_used(carray[free_pool], -1, cdata_p ) ;
	  if( free_idx < 0 ){
	    break ; /* no more free */
	  }
	}
      } while( free_idx < 0 ) ;
      if( free_idx < 0 ){
	break ;
      }

      do {
	used_idx = blk_find_free(carray[used_pool], used_idx, cdata_p) ;
	if( used_idx < 0 ){
	  if( ++used_pool >= numpools ){
	    break ;
	  }
	  used_idx = blk_find_free(carray[used_pool], -1, cdata_p) ;
	  if( used_idx < 0 ){
	    break ; /* no more used */
	  }
	}
      } while( used_idx < 0 ) ;
      if( used_idx < 0 ){
	break ;
      }

    } while( free_pool > used_pool ||
             (free_pool == used_pool && free_idx > used_idx) ) ;

    /* Now free the empty pools */

    /* -----------------------------------------------------------------
     * Now relink the pools and free the used ones.  We need to relink
     * even the ones that were not in the array.  See if we left any
     * out.
    ----------------------------------------------------------------- */
    last_pool = NULL ;
    all_pool_cnt = 0 ;
    for( opool_p = cdata_p->phead->dpool ; opool_p ; opool_p = opool_p->next_pool ){
      all_pool_cnt++ ;
    }
    if( all_pool_cnt != numpools ){
      if( numpools > POOL_HASH_THRESHOLD ){
	/* make a hash table for quicker lookup */
	array_hash = blk_hash_init_pointer(numpools) ;
	for( i = 1 ; i <= numpools ; i++ ){
	  Yhash_insert( array_hash, carray[i], carray[i] ) ;
	}
      } else {
	array_hash = NULL ;
      }
      for( rpool_p = cdata_p->phead->dpool ; rpool_p ; rpool_p = next_pool ){
	need_link = TRUE ;
	next_pool = rpool_p->next_pool ; /* we are going to blast this link */
	if( array_hash ){
	  if( Yhash_find( array_hash, rpool_p) ){
	    need_link = FALSE ;
	  }
	} else {
	  for( s = 1 ; s <= numpools ; s++ ){
	    if( carray[s] == rpool_p ){
	      need_link = FALSE ;
	      break ;
	    }
	  }
	}
	/* If we get here we need to make a link */
	if( need_link ){
	  rpool_p->next_pool = last_pool ;
	  last_pool = rpool_p ;
	}
      }
      if( array_hash ){
	Yhash_free( array_hash, NULL, NULL ) ;
      }
    }

    /* -----------------------------------------------------------------
     * Now we can link in the modified pools.
    ----------------------------------------------------------------- */
    for( pool = free_pool ; pool >= 1 ; pool-- ){
      upool_p = carray[pool] ;
      blk_set_index( upool_p, cdata_p ) ;
      upool_p->next_pool = last_pool ;
      last_pool = upool_p ;
    }
    cdata_p->phead->dpool = last_pool ;
    for( pool = free_pool + 1 ; pool <= numpools ; pool++ ){
      fpool_p = carray[pool] ;
      blk_free_pool_spaces( fpool_p, cdata_p ) ;
      YFREE( fpool_p ) ;
    }
    return( cdata_p->relocated ) ;

} /* end blk_compact() */

/* -----------------------------------------------------------------
 * This find the first block which is free.
----------------------------------------------------------------- */
static INT blk_find_free( POOLPTR pool_p, INT start_idx, COMPACTPTR cdata_p)
{
  INT i ;			/* pool item index */
  VOIDPTR data ;		/* data store at index */

  if( start_idx < 0 ){
    i = 0 ;
  } else {
    i = start_idx + 1 ;
  }
  for( ; i < pool_p->index ; i++ ){
    data = (VOIDPTR) (((UNSIGNED_LONG )( &pool_p->storage.l ) + 
			cdata_p->phead->dsize * i ) ) ;
    if( Yhash_find( cdata_p->free_spaces, data) ){
      return( i ) ;
    }
  }
  return(-1) ;
} /* end blk_find_free() */

/* -----------------------------------------------------------------
 * This find a used block from the last entry.
----------------------------------------------------------------- */
static INT blk_find_used( POOLPTR pool_p, INT start_idx, COMPACTPTR cdata_p )
{
  INT i ;			/* pool item index */
  VOIDPTR data ;		/* data store at index */

  if( start_idx < 0 ){
    i = pool_p->index - 1 ;
  } else {
    i = start_idx - 1 ;
  }
  for( ; i >= 0 ; i-- ){
    data = (VOIDPTR) (((UNSIGNED_LONG )( &pool_p->storage.l ) + 
			cdata_p->phead->dsize * i ) ) ;
    if(!(Yhash_find( cdata_p->free_spaces, data)) ){
      return( i ) ;
    }
  }
  return(-1) ;
} /* end blk_find_used() */

/* -----------------------------------------------------------------
 * Move a blk.  This looks backwards but the calling function really
 * is moving a free block from the used pool to a used block in the
 * free pool.
----------------------------------------------------------------- */
static void blk_move( POOLPTR fpool_p, INT free_idx,
                      POOLPTR upool_p, INT used_idx, COMPACTPTR cdata_p )
{
    INT status ;			/* return status */
    VOIDPTR fdata_p ;			/* free data */
    VOIDPTR udata_p ;			/* used data */

    fdata_p = (VOIDPTR) (((UNSIGNED_LONG )( &fpool_p->storage.l ) + 
			cdata_p->phead->dsize * free_idx ) ) ;
    udata_p = (VOIDPTR) (((UNSIGNED_LONG )( &upool_p->storage.l ) + 
			cdata_p->phead->dsize * used_idx ) ) ;
    /* now copy data */
    /* memcpy( void *dest, void *src, size_t n) */
    memcpy( fdata_p, udata_p, cdata_p->phead->dsize ) ;

    if(!(cdata_p->relocated)){
      cdata_p->relocated = blk_hash_init_pointer(HASH_MIN_SIZE) ;
    }
    Yhash_insert( cdata_p->relocated, udata_p, fdata_p ) ;
    status = Yhash_deleteItem( cdata_p->free_spaces, fdata_p, fdata_p ) ;
    if(!(status)){
      M2(ERRMSG,"blk_move", "Logic error.  Please report\n" ) ;
    }

} /* blk_move() */

static void blk_free_pool_spaces( POOLPTR pool_p, COMPACTPTR cdata_p )
{
  INT i ;				/* counter */
  INT status ;				/* return status */
  VOIDPTR data_p ;			/* free data */

  for( i = 0 ; i < pool_p->limit ; i++ ){
    data_p = (VOIDPTR) (((UNSIGNED_LONG )( &pool_p->storage.l ) + 
			cdata_p->phead->dsize * i ) ) ;
    if( Yhash_find( cdata_p->free_spaces, data_p) ){
      status = Yhash_deleteItem( cdata_p->free_spaces, data_p, data_p ) ;
      if(!(status)){
	M2(ERRMSG,"blk_free_pool_spaces", "Logic error.  Please report\n" ) ;
      }
    }
  }
} /* end blk_free_pool_spaces() */

static void blk_set_index( POOLPTR pool_p, COMPACTPTR cdata_p )
{
  INT i ;				/* counter */
  INT status ;				/* return status */
  INT last_used_idx ;			/* last used index */
  BOOL used_flag ;			/* store is used */
  VOIDPTR data_p ;			/* free data */

  last_used_idx = -1 ;
  /* -----------------------------------------------------------------
   * First go thru and find the last used index.  A storage item is
   * unused if it relocated or in the free list.
  ----------------------------------------------------------------- */
  for( i = 0 ; i < pool_p->index ; i++ ){
    data_p = (VOIDPTR) (((UNSIGNED_LONG )( &pool_p->storage.l ) + 
			cdata_p->phead->dsize * i ) ) ;
    used_flag = TRUE ;  /* assert true and test otherwise */
    if( Yhash_find( cdata_p->free_spaces, data_p) ){
      used_flag = FALSE ;
    } else if( cdata_p->relocated && (Yhash_find( cdata_p->relocated, data_p) ) ){
      used_flag = FALSE ;
    }
    if( used_flag ){
      last_used_idx = i ;
    }
  }
  pool_p->index = last_used_idx + 1 ;

  for( i = last_used_idx ; i < pool_p->limit ; i++ ){
    data_p = (VOIDPTR) (((UNSIGNED_LONG )( &pool_p->storage.l ) + 
			cdata_p->phead->dsize * i ) ) ;
    if( Yhash_find( cdata_p->free_spaces, data_p) ){
      status = Yhash_deleteItem( cdata_p->free_spaces, data_p, data_p ) ;
      if(!(status)){
	M2(ERRMSG,"blk_set_index", "Logic error.  Please report\n" ) ;
      }
    }
  }

} /* end_blk_set_index() */

static void blk_remove_all_free_pools(POOLHEADPTR phead_p) 
{
  INT i ;				/* counter */
  INT status ;				/* delete status */
  BOOL all_free ;			/* all of block is free */
  BOOL freed_block ;			/* a dpool block was freed */
  POOLPTR pool_p ;			/* memory pool */
  POOLPTR last_pool_p ;			/* last pool encountered */
  POOLPTR next_pool_p ;			/* next pool in list */
  YHASHPTR free_spaces ;		/* free spaces */
  VOIDPTR data ;			/* data in question */
  RESVOIRPTR res_p ;			/* list of free objects */

  free_spaces = blk_hash_init_pointer(HASH_MIN_SIZE) ;
  for( res_p = phead_p->free_res ; res_p ; res_p = res_p->next_res ){
    Yhash_insert( free_spaces, res_p->dptr, res_p->dptr ) ;
  }
  /* -----------------------------------------------------------------
   * Now go thru and mark the individual pools as used or not.
   * ----------------------------------------------------------------- */
  last_pool_p = NULL ;
  freed_block = FALSE ;
  for( pool_p = phead_p->dpool ; pool_p ; pool_p = next_pool_p ){
    next_pool_p = pool_p->next_pool ; /* so we can free pool */
    if( pool_p->index == pool_p->limit ){
      /* possible candidate for being completely empty */
      all_free = TRUE ;
      for( i = 0 ; i < pool_p->index ; i++ ){
	data = (VOIDPTR) (((UNSIGNED_LONG )( &pool_p->storage.l ) + 
	                    phead_p->dsize * i ) ) ;
	if(!(Yhash_find( free_spaces, data)) ){
	  all_free = FALSE ;
	  break ;
	}
      }
      if( all_free ){
	/* -----------------------------------------------------------------
	 * First remove this item from free resvoir.
	 * ----------------------------------------------------------------- */
	for( i = 0 ; i < pool_p->index ; i++ ){
	  data = (VOIDPTR) (((UNSIGNED_LONG )( &pool_p->storage.l ) + 
		              phead_p->dsize * i ) ) ;
	  status = Yhash_deleteItem( free_spaces, data, data ) ;
	}
	/* -----------------------------------------------------------------
	 * We continue so we don't rebuild this pool.
	 * ----------------------------------------------------------------- */
	Ymalloc_free( pool_p ) ;
	freed_block = TRUE ;
	continue ;
      } 
    }
    if( last_pool_p ){
      last_pool_p->next_pool = pool_p ;
    } else {
      phead_p->dpool = pool_p ;
    }
    last_pool_p = pool_p ;
  }

  /* -----------------------------------------------------------------
   * Now properly terminate the list.
   * ----------------------------------------------------------------- */
  if( last_pool_p ){
    last_pool_p->next_pool = NULL ;
  } else {
    phead_p->dpool = NULL ;
  }

  /* -----------------------------------------------------------------
   * If we freed a block we can redo the free resvoir.
   * ----------------------------------------------------------------- */
  if( freed_block ){
    blk_rebuild_free_list( phead_p, free_spaces ) ;
  }

  Yhash_free( free_spaces, NULL, NULL ) ;

} /* end blk_remove_all_free_pools() */

static void blk_rebuild_free_list(POOLHEADPTR phead_p,YHASHPTR free_spaces)
{
    INT i ;				/* counter */
    INT num_free ;			/* number of free blocks */
    POOLPTR fnew_p ;			/* new pool of free blocks */
    VOIDPTR data_p ;			/* data in question */
    RESVOIRPTR nres ;			/* new free resvoir */
    RESVOIRPTR res_p ;			/* list of free objects */

    num_free = Yhash_get_size(free_spaces) ;
    if( num_free <= 0 ){
      DF( phead_p->num_res_alloc = 0; ) ;
      phead_p->unused_res = NULL ;
      phead_p->free_res = NULL ;
      phead_p->fpool = NULL ;
      return ;
    }
    fnew_p = alloc_pool( num_free, sizeof(RESVOIR));
    fnew_p->next_pool = NULL ;
    DF( fnew_p->tag = 0 ; ) ;
    DF( phead_p->num_res_alloc = fnew_p->limit; ) ;
    for( nres = (RESVOIRPTR)(&fnew_p->storage.l), i=0 ; i < fnew_p->limit -1; i++) {
      nres[i].next_res = nres + i + 1 ;
    }
    nres[fnew_p->limit-1].next_res = NULL ;
    phead_p->unused_res = nres ;
    phead_p->free_res = NULL ;
    /* -----------------------------------------------------------------
     * Now load up a new free list.
     * ----------------------------------------------------------------- */
    for( data_p = Yhash_enumerate( free_spaces, TRUE) ; data_p ; 
         data_p = Yhash_enumerate( free_spaces, FALSE) ){
      res_p = phead_p->unused_res ;
      phead_p->unused_res = phead_p->unused_res->next_res ;
      res_p->dptr = data_p ;
      res_p->next_res = phead_p->free_res ;
      phead_p->free_res = res_p ;
    }

    /* -----------------------------------------------------------------
     * Free old free pools and add in new pool.
     * ----------------------------------------------------------------- */
    if( phead_p->fpool ){
      free_pool( phead_p->fpool FIXMEM_DEBUG1) ;
    }
    phead_p->fpool = fnew_p ;
} /* end blk_rebuild_free_list() */

#endif /* HAVE_POOL_OPT */

static VOIDPTR calloc_blk(INT id)
{
  VOIDPTR data;

  data = malloc_blk(id) ;
  (void) memset( (char *) data, 0, (size_t) poolheadS[id].dsize );
  return(data);
}

static VOIDPTR malloc_blk(INT id)
{
  POOLHEADPTR phead ;
  POOLPTR p ;
  VOIDPTR data ;

  phead = poolheadS + id ;

  if( phead->free_res ) {
    RESERVOIRPTR res;
    DF( phead->num_now++ ; );
    res = phead->free_res ;
    phead->free_res = phead->free_res->next_res;
    res->next_res = phead->unused_res;
    phead->unused_res = res;
    data = res->dptr ;
  } else {
    p = phead->dpool;
    if( p && p->index < p->limit ) {
      DF( phead->num_now++ ; );
      data =  (VOIDPTR)
	     ((UNSIGNED_LONG)(&p->storage.l) + phead->dsize * (p->index) ) ;
      p->index ++ ;
    } else {
      p = alloc_pool( phead->incr, phead->dsize) ;
      DF( phead->num_alloc += p->limit ; );
      p->next_pool = phead->dpool ;
      phead->dpool = p ;
      /* reset if requested */
      if( phead->reset_incr ){
	phead->incr = 0 ;
      }

      data = malloc_blk(id) ;
    }
  }
  /* for debugging */
//  D( "pool_debug",
//      (void) memset( (char *)data, -1, (size_t) phead->dsize );
//  ) ;
  return( data );
}

static POOLPTR alloc_pool(INT incr, INT size)
{
  POOLPTR p;
  LONG req_size;

  incr = MAX(MININUM_INCR, incr );
  req_size = utDmalloc_align_size( incr, size, POOL_OVERHEAD ) ;
  p = UTDMALLOC( req_size, POOL ) ;
  p->index = 0 ;
  p->limit = (req_size - ((UNSIGNED_LONG)(&p->storage.l) - (UNSIGNED_LONG)p) )
    /size;
  return(p);
}


VOIDPTR utDmempoolEnumerate( INT id, UTDPOOLITERPTR enum_pos)
{
  INT i ;			/* current index */
  POOLPTR p ;			/* current memory pool */
  POOLHEADPTR phead ;		/* pool info */
  VOIDPTR data ;		/* pool data */

  phead = poolheadS + id ;
  if( !(enum_pos->position) ){
    /* start enumeration */
    p = phead->dpool ;
    if(!(p)){
      return(NULL) ;
    }
    i = 0 ;
    if( i >= p->index ){
      return(NULL) ;
    }
  } else {
    p = (POOLPTR) enum_pos->position ;
    i = enum_pos->index ;
    if( ++i >= p->index ){
      /* go onto next pool storage element */
      p = p->next_pool ;
      if(!(p)){
	return(NULL) ;
      }
      i = 0 ;
      if( i >= p->index ){
	return(NULL) ;
      }
    }
  }
  /* -----------------------------------------------------------------
   * At this point we have a valid p,i tupple.  Now return data and
   * update position.
  ----------------------------------------------------------------- */
  enum_pos->position = p ;
  enum_pos->index = i ;
  data = (VOIDPTR) (((UNSIGNED_LONG )( &p->storage.l ) + phead->dsize * i ) ) ;
  return(data) ;

} /* end utDmempoolEnumerate() */
/**********************************************************************/

INT utDmempool_alloc( INT id )
{
  if( id > 0 ) {
    return( poolheadS[id].num_alloc );
  } else {
    return(0);
  }
} /* end utDmempool_alloc() */

INT utDmempool_size( INT id )
{
  if( id > 0 ) {
    return( poolheadS[id].num_now );
  } else {
    return(0);
  }
} /* end utDmempool_size() */

INT utDmempool_reservoir_size( INT id )
{
  if( id > 0 ) {
    return( poolheadS[id].num_res_alloc );
  } else {
    return(0);
  }
} /* end utDmempool_reservoir_size() */

/* -----------------------------------------------------------------
 * Dump information about memory pools.   If pool_id <= 0, all pools
 * will be output.
----------------------------------------------------------------- */
void utDmempool_info(BOOL file_output,INT pool_id)
{
  INT i ;			/* id counter */
  INT freed ;			/* number of freed blks */
  INT first_pool ;		/* first pool to output */	
  INT max_pool ;		/* max pool to output */	
  INT search_limit ;		/* search for matching limit */
  INT search_index ;		/* search for matching index */
  INT no_alloc_count ;		/* look for 10 no allocs to stop printing table */
  BOOL output_flag ;		/* turn off 0 allocations */
  LONG excess ;			/* excess amount */
  LONG dpool_size ;		/* size of dpool */
  LONG dpool_use ;		/* usage of dpool */
  LONG fpool_size ;		/* size of fpool */
  LONG fpool_use ;		/* usage of fpool */
  LONG total_dpool_use ;	/* total dpool use */
  LONG total_fpool_use ;	/* total fpool use */
  LONG total_excess ;		/* total excess fpool use */
  RESERVOIRPTR res ;		/* freed resvoir */
  POOLPTR pool ;		/* memory pool */
  POOLPTR spool ;		/* search memory pool */
  POOLHEADPTR phead ;		/* pool info */
  FILE *fp ;			/* file output */
#ifdef HAVE_BACKTRACE
  char addr_buf[4096] ;		/* build a result */
  FILE *fwrite_p ;		/* write file for addr2line */
  FILE *fread_p ;		/* read file for addr2line */
  INT pid ;			/* process id */
  INT status ;			/* wait status */
  INT tochild[2] ;	 	/* pipe to child */
  INT fromchild[2] ;	 	/* pipe from child */
  char *cmdvec[6] ;	 	/* command vector */
  char *traceback ;		/* traceback string */
  char executable[40] ; 	/* executable path */
  static INT mem_parentL; 	/* make this static so we can pass it to child */
  FUNC_NAME("utDmempool_info") ;
#endif /* HAVE_BACKTRACE */

  if(!(enable_blkS)){
    fprintf( stderr, "ERROR: Block memory is not enabled.\n" ) ;
    return ;
  }

  if( file_output ){
    fp = UTDOPEN( "memblk.info", "w", FILE_NOABORT|FILE_VERBOSE) ;
    if(!(fp)){
      return ;
    }
  } else {
    fp = stderr ;
  }
  if( pool_id > 0 ){
    if( pool_id > max_headS ){
      utDmsgf(ERRMSG,MSG_AT,"utDmempool_info", "Pool id is not registed:%d max pool:%d\n",
	pool_id, max_headS ) ;
      return ;
    }
    max_pool = pool_id ;
    first_pool = pool_id ;
  } else {
    first_pool = 1 ;
    max_pool = max_headS -1 ;
  }

#ifdef HAVE_BACKTRACE
  fwrite_p = NULL ;
  fread_p = NULL ;

  if( backtrace_debugS ){
    mem_parentL = utDgetpid() ;
    /* -----------------------------------------------------------------
     * Here we are opening up a subprocess to talk to addr2line program.
     * ----------------------------------------------------------------- */
    if( pipe(tochild) == ERROR || pipe(fromchild) == ERROR ){
      utDmsg_syserr(TRUE,routine,"pipe_error") ;
    }
    if( (pid = fork()) == 0 ){
      /* we are in the child */
      close( tochild[WRITE] ) ; 
      close( fromchild[READ] ) ; 
      if ( tochild[READ] != STDIN_FILENO ){
	if( dup2( tochild[READ], STDIN_FILENO) != STDIN_FILENO ){
	  utDmsg_syserr(FALSE,routine, "dup error to stdin") ;
	}
	close( tochild[READ]) ; /* don't need this after dup2 */
      }
      if ( fromchild[WRITE] != STDOUT_FILENO ){
	if( dup2( fromchild[WRITE], STDOUT_FILENO) != STDOUT_FILENO ){
	  utDmsg_syserr(FALSE,routine, "dup error to stdout") ;
	}
	close( fromchild[WRITE]) ; /* don't need this after dup2 */
      }

      cmdvec[0] = "addr2line" ;
      cmdvec[1] = "-f" ;
      cmdvec[2] = "-s" ;
      cmdvec[3] = "-e" ;
      sprintf( executable, "/proc/%d/exe", mem_parentL ) ;
      cmdvec[4] = executable ;
      cmdvec[5] = NULL ;
      {
	INT d ;
	for( d = 0 ; d < 5; d++ ){
	  fprintf( stderr, "%d:%s\n", d, cmdvec[d] ) ;
	}
      }
      if( execvp( cmdvec[0], cmdvec ) == ERROR ){
	  /* we don't reach this point unless an error occurs */
	  utDmsg_syserr(FALSE,routine, cmdvec[0] ) ;
      }
      _exit(1) ;

    } else if( pid <= 0 ) {
      if( pid < 0 ){
	utDmsg_syserr(FALSE,routine, "fork error" ) ;
      }
      if( close( tochild[READ] ) == ERROR ){
	utDmsg_syserr(FALSE,routine, "close error" ) ;
      }
      if( close( fromchild[WRITE] ) == ERROR ){
	utDmsg_syserr(FALSE,routine, "close error" ) ;
      }
    }
    fwrite_p = (FILE *) fdopen( tochild[WRITE], "w" ) ;
    fread_p = (FILE *) fdopen( fromchild[READ], "r" ) ;
  }
#endif /* HAVE_BACKTRACE */

  fprintf( fp, "max pool id:%d first free id:%d\n", max_headS, free_headS ) ;
  fprintf( fp, "   Id      alloc     now    res_alloc  incr    dsize  nextid  numused   freed\n" ) ;
  no_alloc_count = 0 ;
  total_dpool_use = 0 ;
  total_fpool_use = 0 ;
  total_excess = 0 ;
  output_flag = TRUE ;
  for( i = first_pool ; i <= max_pool ; i++ ){
    phead = poolheadS + i ;
    freed = 0 ; 
    for( res = phead->free_res ; res ; res = res->next_res ){
      freed++ ;
    }
    if(!(output_flag) && phead->num_alloc == 0 ){
      continue ;
    }
#ifdef HAVE_BACKTRACE
    /* Now convert trace back if we have debug on */
    if( fwrite_p && fread_p && phead->traceback ){
      traceback = addr2line( phead->traceback, addr_buf, fwrite_p, fread_p ) ;
    } else {
      traceback = NULL ;
    }

    fprintf( fp, "%5d %8d %8d %8d %8d %8d %8d %8d %8d %s\n",
      i, phead->num_alloc, phead->num_now, phead->num_res_alloc,
      phead->incr, phead->dsize, phead->next_id, phead->num_used, freed,
      (traceback ? traceback : "unavailable") ) ;
#else
    fprintf( fp, "%5d %8d %8d %8d %8d %8d %8d %8d %8d\n",
      i, phead->num_alloc, phead->num_now, phead->num_res_alloc,
      phead->incr, phead->dsize, phead->next_id, phead->num_used, freed ) ;
#endif /* HAVE_BACKTRACE */
    /* -----------------------------------------------------------------
     * Simple algorithm to find the number of pools that are the same size
     * and limit.  Inefficient but ok because we don't want to use any
     * more memory.
    ----------------------------------------------------------------- */
    dpool_use = 0 ;
    for( pool = phead->dpool ; pool ; pool = pool->next_pool ){
      pool->tag = 0 ;
#ifdef HAVE_MALLOC_SIZE
      dpool_size = malloc_size( pool ) ;
#else
      dpool_size = 0 ;
#endif /* HAVE_MALLOC_SIZE */
      dpool_use += dpool_size ;
    }
    total_dpool_use += dpool_use ;
    for( pool = phead->dpool ; pool ; pool = pool->next_pool ){
      if( pool->tag == 0 ){
	search_limit = pool->limit ;
	search_index = pool->index ;
	for( spool = phead->dpool ; spool ; spool = spool->next_pool ){
	  if( spool->limit == search_limit && spool->index == search_index ){
	    spool->tag = pool->tag = pool->tag + 1 ;
	  }
	}
	fprintf( fp, "     dpool index:%8d limit:%8d #:%d\n",
	  pool->index, pool->limit, pool->tag ) ;
      }
    }
    if( dpool_use > 0 ){
      fprintf( fp, "     dpool use:%10ld %ldM\n", dpool_use, dpool_use /1024/1024) ;
    }
    fpool_use = 0 ;
    for( pool = phead->fpool ; pool ; pool = pool->next_pool ){
      pool->tag = 0 ;
#ifdef HAVE_MALLOC_SIZE
      fpool_size = malloc_size( pool ) ;
#else
      fpool_size = 0 ;
#endif /* HAVE_MALLOC_SIZE */
      fpool_use += fpool_size ;
    }
    total_fpool_use += fpool_use ;
    for( pool = phead->fpool ; pool ; pool = pool->next_pool ){
      if( pool->tag == 0 ){
	search_limit = pool->limit ;
	search_index = pool->index ;
	for( spool = phead->fpool ; spool ; spool = spool->next_pool ){
	  if( spool->limit == search_limit && spool->index == search_index ){
	    spool->tag = pool->tag = pool->tag + 1 ;
	  }
	}
	fprintf( fp, "     fpool index:%8d limit:%8d #:%d\n",
	  pool->index, pool->limit, pool->tag ) ;
      }
    }
    if( fpool_use > 0 ){
      fprintf( fp, "     fpool use:%10ld %ldM\n", fpool_use, fpool_use /1024/1024) ;
    }
    excess = (phead->num_res_alloc - freed) * sizeof(RESERVOIR) ;
    if( excess > 0 ){
      fprintf( fp, "     excess free:%10ld %ldM\n", excess, excess /1024/1024) ;
    }
    total_excess += excess ;
    if( phead->num_alloc == 0 ){
      if( ++no_alloc_count == 10 ){
	output_flag = FALSE ;
      }
    } else {
      no_alloc_count = 0 ;
      output_flag = TRUE ;
    }
  } /* end for( i = first_pool ; i <= max_pool... */

  fprintf( fp, "\n\ntotal dpool use:%10ld %ldM\n", total_dpool_use, 
						   total_dpool_use /1024/1024) ;
  fprintf( fp, "total fpool use:%10ld %ldM\n", total_fpool_use, 
						   total_fpool_use /1024/1024) ;
  fprintf( fp, "total excess fpool use:%10ld %ldM\n", total_excess, 
						   total_excess / 1024 / 1024) ;

  if( file_output ){
    UTDCLOSE( fp ) ;
  }
#ifdef HAVE_BACKTRACE
  if( backtrace_debugS ){
    /* Now shutdown slave */
    if( fwrite_p ){
      UTDCLOSE( fwrite_p ) ;
    }
    if( fread_p ){
      UTDCLOSE( fread_p ) ;
    }
    // utDwait( &status ) ;  /* no zombies */
  }
#endif /* HAVE_BACKTRACE */
} /* end void utDmempool_info() */

void utDmempool_dump(FILE *fp)
{
    INT i ;				/* traverse pools */
    INT start ;				/* first empty pool */
    INT end ;				/* last empty pool */
    UINT32 dsize ;			/* data size */
    UINT32 dsize_malloc_fail ;		/* DSIZE_MALLOC_FAIL */
    POOLPTR pool ;			/* memory pool */
    RESERVOIRPTR res ;			/* freed resvoir */
    POOLHEADPTR phead ;			/* pool info */
    POOLHEADPTR start_p ;		/* start of pool info */

    if(!(poolheadS)){
      return ;
    }
    /* -----------------------------------------------------------------
     * Output the total collector area.
     * ----------------------------------------------------------------- */
    fprintf( fp, "P %lx %ld\n", (UNSIGNED_LONG) poolheadS, 
	     (LONG) max_headS * sizeof(POOLHEAD) ) ;
    /* -----------------------------------------------------------------
     * Output the empty collector areas.
     * ----------------------------------------------------------------- */
    start = end = 0 ;
    start_p = NULL ;
    dsize_malloc_fail = DSIZE_MALLOC_FAIL ;
    for( i = 1 ; i < max_headS ; i++ ){
      phead = poolheadS + i ;
      dsize = phead->dsize ;
      if( (dsize == dsize_malloc_fail) && phead->num_alloc == 0 ){
	start = end = i ;
	start_p = phead ;
	for( i = i + 1 ;  i < max_headS ; i++ ){
	  if( dsize != dsize_malloc_fail || phead->num_alloc ){
	    fprintf( fp, "E %lx %ld\n", (UNSIGNED_LONG) phead, 
		     (LONG) ((end-start+1) * sizeof(POOLHEAD)) ) ;
	    break ;
	  } else {
	    end = i ;
	  }
	}
      }
    }
    if( start_p && end ){
      fprintf( fp, "E %lx %ld\n", (UNSIGNED_LONG) start_p, 
	       (LONG) (end-start+1) * sizeof(POOLHEAD) ) ;
    }

    /* -----------------------------------------------------------------
     * Dump the defined individual pools.
     * ----------------------------------------------------------------- */
    for( i = 1 ; i < max_headS ; i++ ){
      phead = poolheadS + i ;
      dsize = phead->dsize ;
      if( (dsize != dsize_malloc_fail) || phead->num_alloc ){
	fprintf( fp, "I %d\n", i ) ;
      }
      for( pool = phead->dpool ; pool ; pool = pool->next_pool ){
	fprintf( fp, "p %#lx %d\n", (UNSIGNED_LONG) pool, 
		 phead->dsize * (pool->index+1) ) ;
      }
      for( pool = phead->fpool ; pool ; pool = pool->next_pool ){
	fprintf( fp, "F %#lx %d\n", (UNSIGNED_LONG) pool, 
		 phead->dsize * (pool->index+1) ) ;
      }
      for( res = phead->free_res ; res ; res = res->next_res ){
	fprintf( fp, "R %#lx %d\n", (UNSIGNED_LONG) res->dptr, phead->dsize ) ;
      }
    }
} /* Ymalloc_blk_dump() */


#ifdef HAVE_BACKTRACE
/* -----------------------------------------------------------------
 * Read the result from addr2line.
 * ----------------------------------------------------------------- */
static char *addr2line( char *addr_string,char *addr_buf,FILE *fwrite_p,FILE *fread_p )
{
    INT i ;				/* counter */
    INT argc ;				/* # of arguments */
    char *ptr ;				/* find newline */
    char **argv ;			/* argument vector */
    char *bufferptr ;			/* buffer pointer */
    char buffer[LRECL] ;		/* read response */
    char *bufvec[LRECL] ;		/* impossible to have more tokens */

    addr_buf[0] = EOS ;
    argv = utDstrparser2( addr_string, " \t\n", bufvec, &argc ) ;
    for( i = 0 ; i < argc ; i++ ){
      fprintf( fwrite_p,"%s\n", argv[i] ) ; 
      fflush(fwrite_p) ;
      bufferptr=fgets(buffer,LRECL,fread_p) ;
      if( bufferptr ){
	ptr = strrchr( bufferptr, '\n' ) ;
	if( ptr ){
	  *ptr = '|' ;
	}
	strcat( addr_buf, bufferptr ) ;
      }
      bufferptr=fgets(buffer,LRECL,fread_p) ;
      if( bufferptr ){ 
	ptr = strrchr( bufferptr, '\n' ) ;
	if( ptr ){
	  *ptr = ' ' ;
	}
	strcat( addr_buf, bufferptr ) ;
      }
    }
    return( addr_buf ) ;
} /* end addr2line() */


#endif /* HAVE_BACKTRACE */


#ifdef TEST

#include <stdlib.h>

typedef struct my_rec {
  INT index ;
  DOUBLE squared ;
} MYREC, *MYRECPTR ;

#define MAX_MYBLKS	10

int main(int argc,char *argv[])
{
    INT i ;				/* counter */
    INT pool_id ;			/* memory pool */
    MYRECPTR old_p ;			/* old position */
    MYRECPTR blk_p ;			/* user memory */
    MYRECPTR ptr ;			/* user memory */
    MYRECPTR *array ;			/* store the block info */
    UTDPOOLITER iter ;			/* pool iterator */
    VOIDPTR rkey ;			/* relocation key */
    // UTDHASHPTR xref_p ;			/* new xref data */


    fprintf( stderr, "Initial memory:%ld\n", UTDMALLOC_USE() ) ;
    UTDPOOL_ENABLE(TRUE) ;

    pool_id = UTDPOOL_INIT( 0, MYREC ) ;

    fprintf( stderr, "We shouldn't get any pool members here:\n" ) ;
    for( ptr = utDmempoolEnumerate( pool_id, UTDPOOL_ENUM_FIRST(&iter) ) ; ptr ;
	 ptr = utDmempoolEnumerate( pool_id, &iter ) ){
      fprintf( stderr, "blk:%d squared:%.0f\n", ptr->index, ptr->squared );
    }
    fprintf( stderr, "End of empty pool check\n" ) ;

    array = UTDVECTOR_MALLOC( 1, MAX_MYBLKS, MYRECPTR ) ;
    for( i = 1; i <= MAX_MYBLKS ; i++ ){
      blk_p = UTDPOOL_MALLOC( pool_id, MYREC ) ;
      blk_p->index = i ;
      blk_p->squared = i * i ;
      array[i] = blk_p ;
    }

    fprintf( stderr, "Members of pool:\n" ) ;
    for( ptr = utDmempoolEnumerate( pool_id, UTDPOOL_ENUM_FIRST(&iter) ) ; ptr ;
	 ptr = utDmempoolEnumerate( pool_id, &iter ) ){
      fprintf( stderr, "blk:%d squared:%.0f\n", ptr->index, ptr->squared );
    }

    /* show the status of the pools */
    UTDPOOL_INFO(FALSE,pool_id) ;

    fprintf( stderr, "\n\nTest of single block delete\n" ) ;
    /* -----------------------------------------------------------------
     * Now free a few elements to show how the free pools show up.
     * We test the value of i just in case we change definition of MAX_MYBLKS.
    ----------------------------------------------------------------- */
    i = 5 ; 
    if( i <= MAX_MYBLKS ){
      UTDPOOL_FREE_ITEM( pool_id, array[i] ) ;
    }
    i = 10 ; 
    if( i <= MAX_MYBLKS ){
      UTDPOOL_FREE_ITEM( pool_id, array[i] ) ;
    }
    i = 15 ; 
    if( i <= MAX_MYBLKS ){
      UTDPOOL_FREE_ITEM( pool_id, array[i] ) ;
    }
    i = 25 ; 
    if( i <= MAX_MYBLKS ){
      UTDPOOL_FREE_ITEM( pool_id, array[i] ) ;
    }
    i = 35 ; 
    if( i <= MAX_MYBLKS ){
      UTDPOOL_FREE_ITEM( pool_id, array[i] ) ;
    }
    i = 45 ; 
    if( i <= MAX_MYBLKS ){
      UTDPOOL_FREE_ITEM( pool_id, array[i] ) ;
    }
    i = 55 ; 
    if( i <= MAX_MYBLKS ){
      UTDPOOL_FREE_ITEM( pool_id, array[i] ) ;
    }
    fprintf( stderr, "Members of pool:\n" ) ;
    for( ptr = utDmempoolEnumerate( pool_id, UTDPOOL_ENUM_FIRST(&iter) ) ; ptr ;
	 ptr = utDmempoolEnumerate( pool_id, &iter ) ){
      fprintf( stderr, "blk:%d squared:%.0f\n", ptr->index, ptr->squared );
    }

    /* show the status of the pools */
    utDmempool_info(FALSE,pool_id) ;

    fprintf( stderr, "\nNow see what happens when we give a bogus pool\n" ) ;
    fprintf( stderr, "Members of bogus pool:\n" ) ;
    for( ptr = utDmempoolEnumerate( pool_id+1, UTDPOOL_ENUM_FIRST(&iter) ) ; ptr ;
	 ptr = utDmempoolEnumerate( pool_id+1, &iter ) ){
      fprintf( stderr, "blk:%d squared:%.0f\n", ptr->index, ptr->squared );
    }

    fprintf( stderr, "Current memory:%ld\n", UTDMALLOC_USE() ) ;

    fprintf( stderr, "free the pool...\n" ) ;
    UTDPOOL_FREE_POOL( pool_id ) ;
    UTDVECTOR_FREE( array, 1 ) ;
    fprintf( stderr, "Current memory:%ld\n", UTDMALLOC_USE() ) ;

    fprintf( stderr, "Now free pool overhead.  Only do at end of program...\n" ) ;
    UTDPOOL_FREE_ALL() ;
    fprintf( stderr, "Final memory:%ld\n", UTDMALLOC_USE() ) ;

    fprintf( stderr, "\nNow start over with test of pool optimize command...\n" ) ;
    UTDPOOL_ENABLE(TRUE) ;
    pool_id = UTDPOOL_INIT( 0, MYREC ) ;
#define MAX_MYBLKS2 100
    array = UTDVECTOR_MALLOC( 1, MAX_MYBLKS2, MYRECPTR ) ;
    for( i = 1; i <= MAX_MYBLKS2 ; i++ ){
      blk_p = UTDPOOL_MALLOC( pool_id, MYREC ) ;
      blk_p->index = i ;
      blk_p->squared = i * i ;
      array[i] = blk_p ;
    }
    UTDPOOL_INFO(FALSE,pool_id) ;
    fprintf( stderr, "memory use:%ld\n", UTDMALLOC_USE() ) ;
    fprintf( stderr, "\nNow start deleting data only leaving a few elements...\n" ) ;
    for( i = 1; i <= MAX_MYBLKS2 ; i++ ){
      if( i <= 13 || i == 70 || i == 89 ){
	continue ;
      }
      blk_p = array[i] ;
      UTDPOOL_FREE_ITEM( pool_id, blk_p ) ;
    }
    utDmempool_info(FALSE,pool_id) ;
    fprintf( stderr, "memory use after deletes:%ld\n", UTDMALLOC_USE() ) ;
    // Ymalloc_blk_optimize(pool_id,FALSE) ;
/*
    fprintf( stderr, "\nNow after optimization...\n" ) ;
    utDmempool_info(FALSE,pool_id) ;
    fprintf( stderr, "memory use after optimization:%ld\n", UTDMALLOC_USE() ) ;
    xref_p = Ymalloc_blk_optimize(pool_id,TRUE) ;
    fprintf( stderr, "\nNow after optimization...\n" ) ;
    utDmempool_info(FALSE,pool_id) ;
*/

    UTDVECTOR_FREE( array, 1 ) ;
#ifdef LATER
    if( xref_p ){
      fprintf( stderr, "The relocated blocks are:\n" ) ;
      for( blk_p = Yhash_enumeratek( xref_p, &rkey, TRUE ) ; blk_p ;
           blk_p = Yhash_enumeratek( xref_p, &rkey, FALSE ) ){
	old_p = (MYRECPTR) rkey ;
	fprintf( stderr, "relocated %0x to %0x data index:%d squared:%.0f\n",
	    old_p, blk_p,
	    blk_p->index, blk_p->squared );
      }
      Yhash_free( xref_p, NULL, NULL ) ;
    }
#endif /* LATER */
    fprintf( stderr, "Members of pool:\n" ) ;
    for( ptr = utDmempoolEnumerate( pool_id, UTDPOOL_ENUM_FIRST(&iter) ) ; ptr ;
	 ptr = utDmempoolEnumerate( pool_id, &iter ) ){
      fprintf( stderr, "blk:%d squared:%.0f\n", ptr->index, ptr->squared );
    }
    UTDPOOL_FREE_POOL( pool_id ) ;
    UTDPOOL_FREE_ALL() ;
    fprintf( stderr, "ending memory. Should be zero:%ld\n", UTDMALLOC_USE() ) ;

    exit(0) ;
} /* end main() */

#endif /* TEST */
