/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    mempools.h
DESCRIPTION:Include file for memory pools.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_MEMPOOLS_H
#define INCLUDED_UTD_MEMPOOLS_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
/* -----------------------------------------------------------------

  Standard programming model

  INT pool_id;
  
   * globally enable fixmem functionality, if not called, 
   * everything should have exactly the same behavior as before
   * 
  utDmempool_enable( TRUE);

   * get a pool id, type int, unix convention *
  pool_id = UTD_MEMPOOL_INIT( 0, TWINSTBOX);

   * optional, used when user knows how many elements there will be  *
   * This function add to the size that will be allocated so the     *
   * next allocation will be at least 150000                         *
  UTDPOOL_BLK_INCR( poold_id, 150000 );
   * use this version when we want to set the increment directly.    *
   * No summing is performed. The next allocation will be 150000     *
  UTDPOOL_BLK_INCR_MAX( poold_id, 150000 );

   * now the block allocator * 
  inst_p = UTDPOOL_MALLOC( pool_id, YINSTBOX);
  inst_p = UTDPOOL_CALLOC( pool_id, YINSTBOX);

   * free one element. Remember, when free one element in 
     block memory, actually two more pointer are allocated to maintain
     the free list.
     * 
  UTDPOOL_FREE_ITEM( poold_id, inst_p);

   * This really freees all memory, it free all the memory associated with
     pool_id.
     * 
  UTDPOOL_FREE_POOL( pool_id );

   * You can disable block functionality anytime you want, once disabled,
     Any macros, function used in block memory package should behave 
     as before.  Therefore, no need to modify source code.
     * 
  UTDPOOL_ENABLE( FALSE);
----------------------------------------------------------------- */


  
/********************************************************************
 * const
 ********************************************************************/
#define MALLOC_BLK_FAIL    -1

/********************************************************************
 * macro
 ********************************************************************/
#define UTDPOOL_INIT( n,els)   		utDmempool_init(n, sizeof(els))
#define UTDPOOL_MALLOC( id, els)     ((els *)utDmempool_malloc(id, sizeof(els)))
#define UTDPOOL_CALLOC( id, els)     ((els *)utDmempool_calloc(id, sizeof(els)))
#define UTDPOOL_ENUM_FIRST(x_yz)     ( ((x_yz)->position = NULL) ? (x_yz) : (x_yz) )
#define UTDPOOL_FREE_ITEM( id, els_p)   utDmempool_free_item(id, els_p)
#define UTDPOOL_FREE_POOL( id )      utDmempool_free_pool(id )
#define UTDPOOL_FREE_ALL()           utDmempool_free_all()
#define UTDPOOL_ENABLE( b_xz )       utDmempool_enable( b_xz )
#define UTDPOOL_INFO( b_xz, p_xz )   utDmempool_info( b_xz, p_xz )

#define UTDPOOL_POOL_INCR( id, incr) 	utDmempool_pool_incr(id, incr)
#define UTDPOOL_POOL_INCR_MAX( id, incr) utDmempool_pool_incr_max(id, incr)
#define UTDPOOL_MALLOC_MULTI_BLK_INIT( n, m, els)   utDmempool_init(n, m * sizeof(els))
#define UTDPOOL_MALLOC_MULTI_BLK( id, m, els)  ((els *)utDmempool_malloc(id, m * sizeof(els)))
#define UTDPOOL_CALLOC_MULTI_BLK( id, m, els)  ((els *)utDmempool_calloc(id, m * sizeof(els)))


/* ********************** TYPE DEFINITIONS ************************* */
typedef struct utd_pool_enum {
  VOIDPTR position ;
  INT index ;
} UTDPOOLITER, *UTDPOOLITERPTR ;

/* -----------------------------------------------------------------
 * Status definitions.
----------------------------------------------------------------- */
typedef enum { 
  UTD_BLK_STATUS_GET =	-1, 
  UTD_BLK_STATUS_RESET = 0,
  UTD_BLK_STATUS_SET =   1
} UTD_BLK_STATUS_T ;

/*****************************************************************
 *  if enable == TRUE,  globally enable block memory.
 *  if enable == FALSE, globally disable block memory thereafter.
 *
 *  However, you can still call Yfree_blk_fin() to free all memory.
 *  even at this time, block memory is globally disabled.
 *****************************************************************/
extern void utDmempool_enable( BOOL enable ) ;

/****************************************************************
 *  return whether block memory currently enabled or not
 *****************************************************************/
extern BOOL utDmempool_enabled( void ) ;

/****************************************************************
 * the memory pool replacement for malloc and calloc.  All memory
 * within the pool has locality.
 *****************************************************************/
extern VOIDPTR utDmempool_malloc( INT id, INT size ) ;
extern VOIDPTR utDmempool_calloc( INT id, INT size ) ;

/****************************************************************
 * Free a single item in the memory pool.  Pool id and pointer must
 * be supplied.
 *****************************************************************/
extern void utDmempool_free_item( INT id, VOIDPTR p ) ;

/****************************************************************
 * Free all of the elements and the pool data structure for one memory
 * pool whose id is specified.
 *****************************************************************/
extern INT utDmempool_free_pool( INT id ) ;

/*****************************************************************
 *  Initialize a memory pool, return the pool id 
 *****************************************************************/
extern INT utDmempool_init( INT n, INT bytes ) ; 


/*****************************************************************
 *  Set the next pool call increment to be at least value incr.
 *****************************************************************/
extern void utDmempool_pool_incr( INT id, INT incr ) ;
extern void utDmempool_pool_incr_max(INT id, INT incr) ;
extern INT utDmempool_pool_incr_reset( INT id, UTD_BLK_STATUS_T ) ; 

/*****************************************************************
 *  Set the next pool call increment to be at exactly the value incr.
 *****************************************************************/
extern void Ymalloc_blk_incr_max( INT id, INT incr ) ;

/****************************************************************
 *  Return number of resvoirs used to maintained free list
 *****************************************************************/
extern INT utDmempool_reservoir_size( INT id ) ;

/****************************************************************
 *  Return number of data allocated
 *  To calculate total memory consumption = 
 *  ( number of data    allocated ) * sizeof(DATABOX) ) +
 *  ( number of resvoir allocated ) * sizeof(RESVOIR)
 *****************************************************************/
extern INT utDmempool_alloc( INT id ) ;

/****************************************************************
 *  Return number of data currently used.
 *****************************************************************/
extern INT utDmempool_size( INT id ) ;

/****************************************************************
 *  Free memory associated with all pool overhead.  Good only for testing
 *  stub memory freeing.
 *****************************************************************/
extern void utDmempool_free_all( void ) ;

/****************************************************************
 *  Dump information about memory pools. If pool id <= 0 all pools
 *  will be output.  If file_output is true, dump to file memblk.info
 *****************************************************************/
extern void utDmempool_info( BOOL file_output, INT pool_id ) ;

/****************************************************************
 *  Dump information about memory pools to memory interpreter in
 *  okmalloc.
 *****************************************************************/
extern void utDmempool_dump( FILE *fp ) ;

/*****************************************************************
 * Enumerate the items in a pool.  These may or may not be freed.
 *****************************************************************/
extern VOIDPTR utDmempoolEnumerate( INT id, UTDPOOLITERPTR enum_pos) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_MEMPOOLS_H */
