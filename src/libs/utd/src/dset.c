/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
DESCRIPTION:disjoint set utility functions 
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#define  UTDDSET_DEFS
#include <utd/base.h>
#include <utd/debug.h>
#include <utd/msg.h>
#include <utd/rbtree.h>
#include <utd/dset.h>


/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
#define EXPECTED_DSET_SIZE	101


/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static INT compare_parents( UTDDSELPTR p1, UTDDSELPTR p2,VOIDPTR clientData) ;

/*-------------------------------------------------------------------------
  This comparision function is used to eliminate the extra level of
  indirection in the users comparison function but utilizing clientData.
  --------------------------------------------------------------------------*/
static INT compare_dset( UTDDSELPTR data1_p, UTDDSELPTR data2_p, VOIDPTR clientData )
{
    UTDDSETPTR dset_p ;			/* dset pointer */

    dset_p = (UTDDSETPTR) clientData ;
   
   return (*dset_p->compare_func)( data1_p->data, data2_p->data, dset_p->clientData ) ;
} /* end compare_dset_clientData() */

/* -----------------------------------------------------------------
 * This version of the free avoids the set free because that will
 * waste time when we have a memory pool.
----------------------------------------------------------------- */
static void dset_free_pool( UTDDSELPTR ptr, UTDDSETPTR dset )
{
  /* first free the users data */
  if( dset->user_delete) {
    (*dset->user_delete)(ptr->data);
  }
} /* end dset_free_pool() */

static void dset_free_element( UTDDSELPTR ptr, UTDDSETPTR dset )
{
  /* first free the users data */
  if( dset->user_delete) {
    (*dset->user_delete)(ptr->data);
  }
  /* then free the set element */
  UTDPOOL_FREE_ITEM( dset->pool_id, ptr) ;
} /* end dset_free_element() */

/* delete all the trees associated with set */
static void dset_free_trees( UTDDSETPTR dset )
{
  if ( dset->superset_tree ) {
    utDrbtree_free(dset->superset_tree,NULL);
    dset->superset_tree = NULL ;
  }
  if ( dset->subset_tree ) {
    utDrbtree_free(dset->subset_tree,NULL);
    dset->subset_tree = NULL ;
  }
  if ( dset->parent_tree ) {
    utDrbtree_free(dset->parent_tree,NULL);
    dset->parent_tree = NULL ;
  }
} /* end dset_free_trees() */

/*---------------------------------------------------
  compare parents
  ----------------------------------------------------*/
static INT compare_parents( UTDDSELPTR p1, UTDDSELPTR p2, VOIDPTR clientData)
{
  return ( p1->parent - p2->parent );
}  /* end compare_parents() */

/*-----------------------
  -----------------------*/
static UTDDSELPTR path_compression( UTDDSELPTR ptr )
{
  if( ptr != ptr->parent ){
    ptr->parent = path_compression( ptr->parent ) ;
  }
  return( ptr->parent ) ;
} /* end path_compression */

/*-----------------------
  -----------------------*/
static UTDDSELPTR link( UTDDSELPTR x, UTDDSELPTR y)
{
  if( x->rank > y->rank ){
    y->parent = x ;
    x->op.size += y->op.size;
  } else {
    x->parent = y ;
    if( x->rank == y->rank ){
      if (x!=y) {
	y->op.size += x->op.size;
      }
      y->rank++ ;
    } else {
      y->op.size += x->op.size;
    }
  }
  return(x->parent);
} /* end link */

/*-----------------------
  -----------------------*/
UTDDSELPTR _utDdset_find( UTDDSETPTR dset, VOIDPTR data)
{
  UTDHASH_ENTRYPTR entry_p ;		/* hash entry */
  UTDDSELPTR ptr ; 			/* the found/new node */
  
  /* 
    This section finds the dset data structure
    for the given data.  If it doesn't exist it
    creates a new dset record.
    */
  entry_p = utDhash_find( dset->dhash, data ) ;
  if(!(entry_p)){
    /* create a new element */
    ptr = UTDPOOL_MALLOC( dset->pool_id, UTDDSELBOX ) ;
    ptr->data = data ;
    ptr->parent = ptr ;  /* self index initially */
    ptr->rank = 0 ;
    ptr->op.size = 1 ;
    if(!(dset->no_user_tree)){
      utDrbtree_insert( dset->dtree, ptr ) ;
    }
    utDhash_insert( dset->dhash, data, ptr ) ;
    return( ptr ) ;
  } else {
    ptr = UTDHASH_GETDATA( entry_p, UTDDSELPTR ) ;
  }
  
  /* 
    Now that we have the dset data structure,
    compress the path
    */
  ptr = path_compression( ptr ) ;
  
  return( ptr ) ;
} /* end _utDdset_find() */

/*----------------------------------------------
  _utDdset_find_set
  Same as dset_find except avoid call to make set
  ----------------------------------------------*/
UTDDSELPTR _utDdset_find_set( UTDDSETPTR dset, VOIDPTR data)
{
  UTDDSELPTR ptr ;			/* data info */
  UTDHASH_ENTRYPTR entry_p ;		/* hash entry */
  
  entry_p = utDhash_find(dset->dhash, data) ;
  if( entry_p ){
    ptr = UTDHASH_GETDATA( entry_p, UTDDSELPTR ) ;
    ptr = path_compression(ptr);
  }
  return( ptr ) ;
} /* _utDdset_find_set() */

/*----------------------------------------------
  utDdset_make_parent
  Make data the parent of the set.
  ----------------------------------------------*/
UTDDSELPTR utDdset_make_parent( UTDDSETPTR dset, VOIDPTR data)
{
  UTDDSELPTR data_ptr ;			/* data pointer */
  UTDDSELPTR master_ptr ;			/* master pointer */
  UTDHASH_ENTRYPTR entry_p ;		/* hash entry */
  
  entry_p = utDhash_find(dset->dhash, data) ;
  if( entry_p ){
    data_ptr = UTDHASH_GETDATA( entry_p, UTDDSELPTR ) ;
    master_ptr = path_compression(data_ptr);
    if( master_ptr != data_ptr ){
      if( dset->dtree ){
	utDrbtree_deleteItem( dset->dtree, master_ptr, NULL) ;
	utDrbtree_deleteItem( dset->dtree, data_ptr, NULL) ;
      }
      /* Perform a swap on the data */
      SWAP( master_ptr->data, data_ptr->data, VOIDPTR ) ;
      if( dset->dtree ){
	utDrbtree_insert( dset->dtree, master_ptr ) ;
	utDrbtree_insert( dset->dtree, data_ptr ) ;
      }
    }
  } else {
    master_ptr = NULL ;
  }
  return( master_ptr ) ;
} /* utDdset_make_parent() */


/* ***************** end STATIC functions ******************* */

/* ***************** USER functions ******************* */

/*---------------------------------------------------------------------
  utDdset_init()
  NOTE that the users comparison function will be passed handles rather
  then pointers.  Thus, the user comparison function must do an 
  added level of indirection.  If compare_function is NULL, then the
  dtree is not created.
  ---------------------------------------------------------------------*/
UTDDSETPTR utDdset_init( INT (*compare_func)(void *, void *,void *), 
			 VOIDPTR clientData )
{
  UTDDSETPTR dset ; /* in reality this is a YTREEPTR not anymore! */
  
  dset = UTDMALLOC( 1, UTDDSETBOX ) ;
  if( compare_func ){
      dset->dtree = 
	utDrbtree_init( (utDcompareClientData) compare_dset, dset );
      dset->compare_func = compare_func ;
      dset->dhash = utDhash_init_pointer(EXPECTED_DSET_SIZE) ;
  } else {
      dset->dtree = NULL ;
      dset->compare_func = NULL ;
      dset->dhash = NULL ;
  }
  dset->init_count = 0 ;
  dset->superset_tree = NULL ;
  dset->subset_tree = NULL ;
  dset->parent_tree = NULL ;
  dset->parents_valid = FALSE ;
  dset->no_user_tree = FALSE ;
  dset->parent_compare = compare_parents ;
  dset->subset_compare = NULL ;
  dset->clientData = clientData ;
  dset->pool_id = UTDPOOL_INIT( 0, UTDDSELBOX ) ;
  return( dset ) ;
} /* end utDdset_init */

INT utDdset_option( UTDDSETPTR dset_p, INT option, INT value )
{
    if( option & UTDDSET_OPTION_NOTREE ){
      if( value >= 0 ){
	dset_p->no_user_tree = value ;
      }
      return( dset_p->no_user_tree ) ;
    }
    return( 0 ) ;
} /* end utDdset_option() */


utDdset_pcompare utDdset_compare_parent_func(UTDDSETPTR set,utDdset_pcompare func)
{
    utDdset_pcompare old_func ;		/* old comparision function */

    old_func = set->parent_compare ;
    set->parent_compare = func ;
    return(old_func) ;
} /* end utDdset_compare_parent_func() */

utDdset_pcompare utDdset_compare_subset_func(UTDDSETPTR set,utDdset_pcompare func)
{
    utDdset_pcompare old_func ;		/* old comparision function */

    old_func = set->subset_compare ;
    set->subset_compare = func ;
    return(old_func) ;
} /* end utDdset_compare_subset_func() */


/*-----------------------------------
  utDdset_enumerate
  enumerate all elements in all sets
  -----------------------------------*/
VOIDPTR utDdset_enumerate( UTDDSETPTR dset, UTDDSETITERPTR iter_p)
{

  UTDDSELPTR ptr ;			/* dset node info */
  UTDHASH_ENTRYPTR entry_p ;		/* hash entry */
  FUNC_NAME("utDdset_enumerate") ;

  D("utDdset_enumerate",
    fprintf(stderr,"start utDdset_enumerate\n");
  );
  
  if( dset->no_user_tree ){
    entry_p = utDhash_enumerate( dset->dhash, (UTDHASHITERPTR) iter_p ) ;
    if( entry_p ){
      ptr = UTDHASH_GETDATA( entry_p, UTDDSELPTR ) ;
    } else {
      ptr = NULL ;
    }
  } else {
    ptr = utDrbtree_enumerate( dset->dtree, (UTDTREEITERPTR) iter_p ) ;
  }

  D("utDdset_enumerateRE",
    fprintf(stderr,"end utDdset_enumerateRE\n");
  );

  if( ptr ) {
    return( ptr->data ) ;
  } else {
    return ( NULL ) ;
  }

} /* end utDdset_enumerateRE() */

/*-----------------------
  utDdset_enumerate_superset
  Enumerates all the elements of all subsets .
  Items are sorted by set, so all elements of each set
  will be returned together.
  -----------------------*/
/*** Enumerates all the elements of the whole superset ***/
VOIDPTR utDdset_enumerate_superset( UTDDSETPTR dset, UTDDSETITERPTR iter_p)
{
  UTDDSELPTR ptr ;
  UTDTREEPTR dtree ;
  UTDHASHPTR dhash ;
  UTDHASHITER hiter ;			/* hash iterator */
  UTDTREEITER tree_iter ;		/* rb tree iterator */
  UTDHASH_ENTRYPTR entry_p ;		/* hash entry */
  FUNC_NAME("utDdset_enumerate_superset") ;
  
  D( (char *)routine,
    fprintf(stderr,"start utDdset_enumerate_superset\n");
  );

  if(!(iter_p)){
    utDmsgf(ERRMSG,MSG_AT,routine, "Null iteration pointer.\n" ) ;
    return(NULL) ;
  }

  if (!(iter_p->position) ){
    if ( dset->superset_tree ) {
      utDrbtree_free(dset->superset_tree,NULL);
    }
    dset->superset_tree = 
      utDrbtree_init((utDcompareClientData) dset->parent_compare,
						    dset->clientData) ;
      
    if( dset->no_user_tree ){
      /* just use the hash table whatever order it is in */
      dhash = dset->dhash ;
      for ( entry_p = utDhash_enumerate( dhash,UTDHASH_FIRST(&hiter)); entry_p ;
	   entry_p = utDhash_enumerate( dhash, &hiter) ) {
	/* compress path so everyone will point to same parent */
	ptr = UTDHASH_GETDATA( entry_p, UTDDSELPTR ) ;
	path_compression( ptr ) ; /* compress the path */
	utDrbtree_insert(dset->superset_tree,ptr) ;
      }
    } else {
      /* sort elements by set */
      dtree = dset->dtree ;
      for ( ptr = utDrbtree_enumerate( dtree, UTDRBTREE_FIRST(&tree_iter)); ptr;
	   ptr = utDrbtree_enumerate( dtree, &tree_iter) ) {
	/* compress path so everyone will point to same parent */
	path_compression( ptr ) ; /* compress the path */
	utDrbtree_insert(dset->superset_tree,ptr);
      }
      ASSERTNFAULT(utDrbtree_size(dset->superset_tree) == utDrbtree_size(dtree),
	 routine,"bogus superset sizes");
    }

    
  }   /* end if start flag */
  
  ptr = utDrbtree_enumerate( dset->superset_tree, iter_p );
  
  D( (char *) routine,
    fprintf(stderr,"end utDdset_enumerate_superset\n");
  );

  if (ptr) {
    return ( ptr->data );
  }
  
  return ( NULL ) ;
} /* end utDdset_enumerate_superset() */

/*----------------------------------
  Returns the parents of each subset
  ----------------------------------*/
/*** Enumerates the parents of each subset ***/
VOIDPTR utDdset_enumerate_parents( UTDDSETPTR dset, UTDDSETITERPTR parent_iter_p)
{
  INT psize ;
  UTDDSELPTR ptr ;
  UTDDSELPTR tmp ;
  UTDDSELPTR pptr ;
  UTDDSELPTR item_p ;
  UTDDSELPTR member_p ;
  UTDTREEPTR dtree ;
  UTDHASHITER iter ;
  UTDHASHITER hiter ;
  UTDHASHPTR dhash ;
  UTDTREEITER tree_iter ;
  UTDHASHPTR parent_hash ;
  UTDHASH_ENTRYPTR entry_p ;		/* hash entry */
  UTDHASH_ENTRYPTR entry2_p ;		/* hash entry */
  FUNC_NAME("utDdset_enumerate_parents") ;
  
  D( (char *) routine,
    fprintf(stderr,"start utDdset_enumerate_parents\n");
  );

  if(!(parent_iter_p)){
    utDmsgf(ERRMSG,MSG_AT,routine, "Null iteration pointer.\n" ) ;
    return(NULL) ;
  }

  if ( !(parent_iter_p->position) && !(dset->parents_valid) ) {
    if ( dset->parent_tree ) {
      utDrbtree_free(dset->parent_tree,NULL);
    }
    dset->parent_tree = utDrbtree_init((utDcompareClientData) dset->parent_compare,
				   dset->clientData ) ;
    if( dset->no_user_tree ){
      psize = utDhash_size(dset->dhash) ;
    } else {
      psize = utDrbtree_size(dset->dtree) ;
    }
    /* -----------------------------------------------------------------
     * We use a hash table called parent_hash in the hash and tree enumerate
     * loop so that the operation is O(n) rather than O(nlogn).  It
     * can make a big difference removing it from the loop.  Below
     * we add all of the parents to a tree outside the loop.
    ----------------------------------------------------------------- */
    parent_hash = utDhash_init_pointer(MAX(psize/10,UTD_HASH_MIN_SIZE)) ;
      
    if( dset->no_user_tree ){
      dhash = dset->dhash ;
      /* initialize member lists to NULL */
      for ( entry_p = utDhash_enumerate( dhash, UTDHASH_FIRST(&iter)); entry_p ;
	    entry_p = utDhash_enumerate( dhash, &iter) ) {
	item_p = UTDHASH_GETDATA( entry_p, UTDDSELPTR ) ;
	item_p->next_member = NULL ; 
      }
      for ( entry_p = utDhash_enumerate( dhash, UTDHASH_FIRST(&iter)); entry_p ;
	    entry_p = utDhash_enumerate( dhash, &iter) ) {
	member_p = UTDHASH_GETDATA( entry_p, UTDDSELPTR ) ;
	/* compress path so everyone will point to same parent */
	ptr = path_compression( member_p ) ; /* compress the path */

	/* always add it to the hash table so we can look up the members fast */
	tmp = ptr->next_member ;
	ptr->next_member = member_p ; 
	member_p->next_member = tmp ;

	/* only add to parent tree/hash if it is a unique parent */
	if(!(utDhash_find(parent_hash,ptr))){
	  utDhash_insert(parent_hash,ptr,ptr) ;
	}
      }
    } else {
      dtree = dset->dtree ;
      /* sort elements by set */
      /* -----------------------------------------------------------------
       * This looks strange but we must reverse list the dtree in order
       * for the subset hash to be in the correct order because the hash
       * routines build a reverse list.  If we change hash routines, we
       * must change this routine as well.
      ----------------------------------------------------------------- */
      /* initialize member lists to NULL */
      for ( item_p = utDrbtree_enumerate( dtree, UTDRBTREE_FIRST(&tree_iter)); 
	    item_p ;
	    item_p = utDrbtree_enumerate( dtree, &tree_iter) ) {
	item_p->next_member = NULL ; 
      }
      for ( member_p = utDrbtree_enumerate( dtree, UTDRBTREE_FIRST(&tree_iter)); 
	    member_p ;
	    member_p = utDrbtree_enumerate( dtree, &tree_iter) ) {
	/* compress path so everyone will point to same parent */
	ptr = path_compression( member_p ) ; /* compress the path */

	/* always add it to the hash table so we can look up the members fast */
	tmp = ptr->next_member ;
	ptr->next_member = member_p ; 
	member_p->next_member = tmp ;

	/* only add to tree if it is a unique parent */
	if(!(utDhash_find(parent_hash,ptr))){
	  utDhash_insert(parent_hash,ptr,ptr) ;
	}
      }
    }

    /* Now build the parent tree from the hash table.  Outside the loop */
    for( entry2_p = utDhash_enumerate( parent_hash, UTDHASH_FIRST(&hiter)) ; entry2_p ; 
         entry2_p = utDhash_enumerate( parent_hash, &hiter )  ){
	pptr = UTDHASH_GETDATA( entry2_p, UTDDSELPTR ) ;
	utDrbtree_insert(dset->parent_tree, pptr) ;
    }
    utDhash_free( parent_hash, NULL, NULL ) ;

    dset->parents_valid = TRUE ;

    
  }   /* end if start flag */
  
  ptr = utDrbtree_enumerate( dset->parent_tree, parent_iter_p) ;
  
  D("utDdset_enumerate_parents",
    fprintf(stderr,"end utDdset_enumerate_parents\n");
  );

  if (ptr) {
    return ( ptr->data );
  }
  
  return ( NULL ) ;
  
} /* end utDdset_enumerate_parents() */

/*-----------------------------------------------------
  utDdset_enumerate_subset
  Enumerates all the elements of a subset.
  Items are sorted by set, so all elements of each set
  will be returned together.
  ------------------------------------------------------*/
VOIDPTR utDdset_enumerate_subset( UTDDSETPTR dset,VOIDPTR subsetData,UTDDSETITERPTR subset_iter_p)
{
  UTDDSELPTR parent ;
  UTDDSELPTR ptr ;
  UTDTREEPTR dtree ;
  UTDHASHPTR dhash ;
  UTDHASHITER iter ;
  UTDTREEITER tree_iter ;
  UTDHASH_ENTRYPTR entry_p ;		/* hash entry */
  FUNC_NAME("utDdset_enumerate_subset") ;
  
  D( (char *)routine,
    fprintf(stderr,"start utDdset_enumerate_subset\n");
  );

  if(!(subset_iter_p)){
    utDmsgf(ERRMSG,MSG_AT,routine, "Null iteration pointer.\n" ) ;
    return(NULL) ;
  }

  if ( !(subset_iter_p->position)) {
    if ( dset->subset_tree ) {
      utDrbtree_free(dset->subset_tree,NULL);
    }
    if( dset->subset_compare ){
      dset->subset_tree = 
	utDrbtree_init((utDcompareClientData) dset->subset_compare,
				     dset->clientData );
    } else {
      dset->subset_tree = 
	utDrbtree_init((utDcompareClientData) dset->parent_compare,
				     dset->clientData ) ;
    }
      
    utDdset_find(dset,subsetData);  /* compress the path */
    parent = _utDdset_find_set(dset,subsetData);  /* find parent of subset */

    /* build a tree of all elements in the same set as subsetData */
    /* this means they have the same parent */
    if( dset->parents_valid ){
      /* We can save some time if this data is available */
      if( parent ){
	utDrbtree_insert(dset->subset_tree,parent) ;
	for( ptr = parent->next_member ; ptr ; ptr = ptr->next_member ){
	  /* We need to add to subset tree because this might perform sorting */
	  utDrbtree_insert(dset->subset_tree,ptr);
	}
      }
    } else {
      if( dset->no_user_tree ){
	dhash = dset->dhash ;
	for ( entry_p = utDhash_enumerate( dhash, UTDHASH_FIRST(&iter)); entry_p;
	     entry_p = utDhash_enumerate( dhash, &iter) ) {
	  ptr = UTDHASH_GETDATA( entry_p, UTDDSELPTR ) ;
	  path_compression( ptr ) ; /* compress the path */
	  if ( ptr->parent == parent ) {
	    utDrbtree_insert(dset->subset_tree,ptr);
	  }
	}
      } else {
	dtree = dset->dtree ;
	for ( ptr = utDrbtree_enumerate( dtree, UTDRBTREE_FIRST(&tree_iter)); ptr;
	     ptr = utDrbtree_enumerate( dtree, &tree_iter) ) {
	  path_compression( ptr ) ; /* compress the path */
	  if ( ptr->parent == parent ) {
	    utDrbtree_insert(dset->subset_tree,ptr);
	  }
	}
      }
    }
    
  }   /* end if start flag */
  
  ptr = utDrbtree_enumerate( dset->subset_tree, subset_iter_p ) ;
  
  D( (char *) routine,
    fprintf(stderr,"end utDdset_enumerate_subset\n");
  );

  if (ptr) {
    return ( ptr->data );
  }
  
  return ( NULL ) ;
  
} /* end utDdset_enumerate_subset() */

/*-----------------------
  utDdset_search
  -----------------------*/
/*
  Searches for an item in the set basically like 
  rbtree_search works ; avoids makeset of the item
  which utDdset_find does by default.  Does not do
  path compression.  Good if no unions have been
  performed (during initialization) and interested
  in making all elements of the set unique.
  */
VOIDPTR utDdset_search( UTDDSETPTR dset, VOIDPTR data )
{
  UTDDSELBOX dummy ;
  UTDDSELPTR ptr ;
  
  if( dset->no_user_tree ){
    utDmsgf(ERRMSG,MSG_AT,"utDdset_search", "can't use this function without a tree.\n") ;
    return(NULL) ;
  }
  dummy.data = data ;
  ptr = utDrbtree_search( dset->dtree, &dummy ) ;
  if( ptr ){
    return( ptr->data ) ;
  }
  return( NULL ) ;
} /* utDdset_search */

/*-------------------------------------------------------------
  utDdset_free
  Free all elements in the set and the set.
  This can now be used recursively.
  --------------------------------------------------------------*/
void utDdset_free( UTDDSETPTR dset, void (*userDelete)(void *) )
{
  VOIDPTR client_data_save ;		/* save the client data */

  dset->user_delete = userDelete ;
  if( dset->dtree ){
    utDrbtree_set_clientData( dset->dtree, dset ) ;
    if( dset->pool_id > 0 ){
      utDrbtree_free(dset->dtree,(utDdeleteClientData) dset_free_pool ) ;
    } else {
      utDrbtree_free(dset->dtree,(utDdeleteClientData) dset_free_element ) ;
    }
  }
  if( dset->dhash ){
    utDhash_free(dset->dhash, NULL, NULL) ;
  }
  dset_free_trees( dset ) ;
  UTDPOOL_FREE_POOL( dset->pool_id ) ;
  UTDFREE( dset ) ;
} /* end utDdset_free */

/*------------------------------------------------------------
  utDdset_empty
  Free all elements in the set but leaves the set intact
  -------------------------------------------------------------*/
void utDdset_empty( UTDDSETPTR dset, void (*userDelete)(void *) )
{
  INT incr_size ;		/* future increment size */
  /* -----------------------------------------------------------------
   * Before we delete set we get the current size of the tree so
   * we can set the blk incrementer to this size.
  ----------------------------------------------------------------- */
  incr_size = utDrbtree_size(dset->dtree) ;
  dset->user_delete = userDelete ;
  if( dset->dtree ){
    utDrbtree_set_clientData( dset->dtree, dset ) ;
    if( dset->pool_id > 0 ){
      utDrbtree_empty(dset->dtree,(utDdeleteClientData) dset_free_pool ) ;
    } else {
      utDrbtree_empty(dset->dtree,(utDdeleteClientData) dset_free_element ) ;
    }
  }
  utDhash_empty(dset->dhash, NULL, NULL) ;
  dset_free_trees( dset ) ;
  UTDPOOL_FREE_POOL( dset->pool_id ) ;
  dset->pool_id = UTDPOOL_INIT( incr_size, UTDDSELBOX ) ;
  if ( dset->superset_tree ) {
    utDrbtree_free(dset->superset_tree,NULL) ;
    dset->superset_tree = NULL ;
  }
  if ( dset->subset_tree ) {
    utDrbtree_free(dset->subset_tree,NULL) ;
    dset->subset_tree = NULL ;
  }
  if ( dset->parent_tree ) {
    utDrbtree_free(dset->parent_tree,NULL) ;
    dset->parent_tree = NULL ;
  }
  dset->parents_valid = FALSE ;
} /* end utDdset_empty() */

/*-----------------------
  -----------------------*/
VOIDPTR utDdset_union( UTDDSETPTR dset, VOIDPTR x, VOIDPTR y )
{
  UTDDSELPTR p1, p2, p3 ;
  
  D("utDdset_union",
    fprintf(stderr,"start utDdset_union size = %d\n",utDrbtree_size(dset->dtree));
  );

  p1 = _utDdset_find( dset, x ) ;
  ASSERT( p1, "utDdset_union", "Problem with finding x\n" ) ;
  p2 = _utDdset_find( dset, y ) ;
  ASSERT( p2, "utDdset_union", "Problem with finding y\n" ) ;

  /* if p1 == p2 then we are already done */
  if ( p1 != p2 ) {
    p3 = link( p1, p2 );
  } else {
    p3 = p1;
  }
  
  D("utDdset_union",
    fprintf(stderr,"end utDdset_union size = %d\n",utDrbtree_size(dset->dtree));
  );
  dset->parents_valid = FALSE ; /* invalidate dparents data structure */

  return( p3->data );
} /* end utDdset_union */

/*-------------------------------------------------
  utDdset_find_set()
  Searches for the set an item belongs to.
  This routine avoids makeset of the item
  which utDdset_find does by default
  -------------------------------------------------*/
VOIDPTR utDdset_find_set( UTDDSETPTR dset,VOIDPTR data)
{
  UTDDSELPTR ptr ;
  
  if( (ptr = _utDdset_find_set(dset, data)) ) {
    return( ptr->data ) ;
  }
  return( NULL ) ;
} /* utDdset_find */

/*-------------------------------------------------
  utDdset_find
  Returns the set to which data is an element
  If the element is NOT in any set, a set is created
  --------------------------------------------------*/
VOIDPTR utDdset_find( UTDDSETPTR dset, VOIDPTR data)
{
  UTDDSELPTR ptr ;
  
  if( (ptr = _utDdset_find( dset, data) )){
    return( ptr->data ) ;
  }
  return( NULL ) ;
} /* end utDdset_find */

/*-----------------------
  -----------------------*/
INT utDdset_superset_size(UTDDSETPTR dset)
{
  if( dset->no_user_tree ){
    return(utDhash_size(dset->dhash));
  } else {
    return(utDrbtree_size(dset->dtree));
  }
} /* end utDdset_superset_size */

/*-----------------------
  utDdset_parent_size must be call after utDdset_enumerate_parents is called.
  -----------------------*/
INT utDdset_parent_size(UTDDSETPTR dset)
{
  if ( dset->parent_tree ) {
    return(utDrbtree_size(dset->parent_tree));
  }
  return(0) ;
} /* end utDdset_parent_size */

/*-----------------------
  -----------------------*/
INT utDdset_subset_size( UTDDSETPTR dset, VOIDPTR data )
{
  UTDDSELPTR ptr ;
  
  if (dset){
    if( (ptr = _utDdset_find_set( dset, data ) )){
      return( ptr->op.size ) ;
    } else {
      utDmsgf(ERRMSG,MSG_AT,"utDdset_subset_size","Problem with finding data set\n");
    }
  } else {
    utDmsgf(ERRMSG,MSG_AT,"utDdset_subset_size","NULL dset pointer (super set)\n");
  }
  return (-1);
} /* end utDdset_subset_size */


/*-----------------------
  utDdset_verify
  -----------------------*/
INT utDdset_verify( UTDDSETPTR dset )
{
  UTDDSELPTR ptr ;
  INT sizeIn;
  INT sizeOut;  
  INT rc = TRUE;
  UTDTREEPTR dtree ;
  UTDTREEITER tree_iter ;
  
  dtree = dset->dtree ;
  sizeIn = utDdset_superset_size(dset);

  /* exercise the dset tree */
  if ( !utDrbtree_verify(dtree) ) {
    utDmsgf(ERRMSG,MSG_AT,"utDdset_verify","dset tree verify failed\n");
    rc = FALSE;
  }

  /* walk through all elements user find routines to recover itself */
  for ( ptr = utDrbtree_enumerate( dtree, UTDRBTREE_FIRST(&tree_iter)); ptr;
       ptr = utDrbtree_enumerate( dtree, &tree_iter) ) {
  }
  
  sizeOut = utDdset_superset_size(dset);

  /* make sure the size has not changed, this tell us if makeset is called */
  if ( sizeIn != sizeOut ) {
    fprintf(stderr,"sizeIn:%d sizeOut:%d\n",sizeIn,sizeOut);
    utDmsgf(ERRMSG,MSG_AT,"utDdset_verify","dset size changed during verification\n");
    rc = FALSE;
  }

  return( rc );
} /* end utDdset_verify() */

/*------------------------
  utDdset_dump
  ------------------------*/
void utDdset_dump( UTDDSETPTR dset,FILE *fp, void (*printFunc)(FILE *fp,void *) )
{
  VOIDPTR ptr ;
  INT count = 1;
  UTDDSELPTR lastParent;
  UTDDSELPTR parent;
  UTDDSELBOX dummy;
  UTDDSETITER iter ;
  
  D("utDdset_dump",
    fprintf(stderr,"start utDdset_dump\n");
    );

  if (!(printFunc)) {
    utDmsgf(WARNMSG,MSG_AT,"utDdset_dump","NULL print function\n");
  }
  if(!(fp)){
    fp = stderr ;
  }

  lastParent = &dummy;

  /* dump elements by set */
  if( dset->no_user_tree ){
    fprintf(fp,"set contains %d items\n",utDhash_size(dset->dhash));
  } else {
    fprintf(fp,"set contains %d items\n",utDrbtree_size(dset->dtree));
  }
  for ( ptr = utDdset_enumerate_superset( dset, UTDDSET_FIRST(&iter)); ptr;
       ptr = utDdset_enumerate_superset( dset, &iter) ) {
    
    parent = _utDdset_find_set( dset, ptr );
    if ( parent != lastParent ) {
      fprintf(fp,"\n%d items in set #%d [parent ",parent->op.size,count++);
      if ( printFunc ) {
	(*printFunc)( fp, parent->data);
      } else {
	fprintf(fp,"%ld ", (UNSIGNED_LONG)parent);
      }
      fprintf(fp,"]:\n" ) ;
    }
    if ( printFunc ) {
      (*printFunc)(fp,ptr);
    } else {
      fprintf(fp,"%ld ",(UNSIGNED_LONG) ptr);
    }
    lastParent = parent;
  }

  fprintf(fp,"\n");

  D("utDdset_dump",
    fprintf(fp,"end utDdset_dump\n");
    );
} /* end utDdset_dump() */


/*------------------------
  utDdset_dump_tree
  ------------------------*/
void utDdset_dump_tree( UTDDSETPTR dset, FILE *fp, void (*print_key)(FILE *,void *) )
{
  
  D("utDdset_dump_tree",
    fprintf(stderr,"start utDdset_dump_tree\n");
  );

  if ( !print_key ) {
    utDmsgf(WARNMSG,MSG_AT,"utDdset_dump_tree","NULL print function\n");
  }

  utDrbtree_dump( dset->dtree, fp, print_key ) ;

  D("utDdset_dump_tree",
    fprintf(stderr,"end utDdset_dump_tree\n");
  );
} /* end utDdset_dump_tree() */

/* *********************  TEST PROGRAM ************************ */
#ifdef TEST

#include <stdlib.h>

static INT compare_set(INT num1, INT num2, VOIDPTR cdata)
{
    if( num1 == num2 ){
	return( 0 ) ;
    } else if( num1 < num2 ){
	return( -1 ) ;
    } else {
	return( 1 ) ;
    }
} /* end compare_set */

static INT compare_subset(UTDDSELPTR p1,UTDDSELPTR p2,VOIDPTR user_data)
{
    INT num1, num2 ;			/* two numbers to compare */

    num1 = (LONG) p1->data ;
    num2 = (LONG) p2->data ;
    return( compare_set(num1,num2,user_data) ) ;
} /* end compare_subset() */

static void print_data(FILE *fp,INT num)
{
    fprintf( fp, "  %d", num ) ;
} /* end print_data() */

static void my_delete(INT num)
{
    fprintf( stderr, "deleting %d\n", num ) ;
} /* my_delete() */

int main(void)
{
    UTDDSETPTR set ;
    UTDDSELPTR *element_array ;
    UTDDSELPTR parent_p ;
    UTDDSETITER iter ;
    UTDDSETITER super_iter ;
    UTDDSETITER sub_iter ;
    UTDDSETITER parent_iter ;
    INT i, j, q ;

    /*
    Ymalloc_debug(TRUE);
    Ydebug_init(TRUE);
    */
    utDmempool_enable(TRUE) ;
    /* initialize master set */
    set = utDdset_init( (utDcompareClientData) compare_set, NULL ) ;
    utDdset_compare_subset_func( set, compare_subset ) ;
/*
  utDdset_option( set, UTDDSET_OPTION_NOTREE, TRUE ) ;
*/
    fprintf( stderr, "Memory use:%ld\n", utDmalloc_use() ) ;
    /* first make 10 nodes */
    for( i = 1; i <= 10; i++ ){
	q = (LONG) utDdset_find( set, VOIDPTR_TYPE(i) ) ;
	fprintf( stderr, "find:%d = %d ...\n", i, q ) ;
    } 
    utDdset_union( set, (VOIDPTR) 1, (VOIDPTR) 2 ) ;
    fprintf( stderr, "1 belongs to %d\n", (int) (long) utDdset_find( set, (VOIDPTR) 1 )) ;
    fprintf( stderr, "Parent set is now:\n" ) ;
    for ( q = (LONG) utDdset_enumerate_parents( set, UTDDSET_FIRST(&parent_iter) ) ; q ;
          q = (LONG) utDdset_enumerate_parents( set, &parent_iter )){
	fprintf( stderr, "%d ", q ) ;
    }
    fprintf( stderr, "\n" ) ;
    printf("%d\n",utDdset_superset_size( set ));
    utDdset_union( set, (VOIDPTR) 3, (VOIDPTR) 1 ) ;
    utDdset_union( set, (VOIDPTR) 2, (VOIDPTR) 3 ) ;
    utDdset_union( set, (VOIDPTR) 5, (VOIDPTR) 6 ) ;
    utDdset_union( set, (VOIDPTR) 7, (VOIDPTR) 6 ) ;
    printf("%d\n",utDdset_superset_size( set ));
    q = (LONG) utDdset_find( set, VOIDPTR_TYPE(6) ) ;

    /* lets look at everyone in 6's set */
    fprintf( stderr, "\nThe members in 6's set are:\n" ) ;
    for( q = (LONG) utDdset_enumerate_subset( set, (VOIDPTR) 6, UTDDSET_FIRST(&sub_iter) ) ;
	q ;
	q = (LONG) utDdset_enumerate_subset( set, (VOIDPTR) 6, &sub_iter ) ){
	fprintf( stderr, "%d ", q ) ;
    } /* end */
    fprintf( stderr, "\n" ) ;

    fprintf( stderr, "Six's parent is:%ld\n", 
	(LONG) utDdset_find_set( set, (VOIDPTR) 6 ) ) ;

    fprintf( stderr, "The size of the set 6 is in is:%d\n",
	utDdset_subset_size( set, (VOIDPTR) 6 ) ) ;

    fprintf(stderr, "The superset size is %d\n",utDdset_superset_size( set ));
    fprintf(stderr, "The parent size is %d which is wrong.\n",utDdset_parent_size( set ));
    fprintf(stderr, "We need to call utDdset_enumerate_parents.  Now the correct:\n");
    utDdset_enumerate_parents( set, UTDDSET_FIRST(&parent_iter) ) ;
    fprintf(stderr, "The parent size is %d\n",utDdset_parent_size( set ));
    printf("%d\n", (int) (long) utDdset_enumerate( set , UTDDSET_FIRST(&iter)));
    printf("%d\n", (int) (long) utDdset_enumerate( set , &iter));
    printf("%d\n", (int) (long) utDdset_enumerate( set , &iter));
    printf("%d\n", (int) (long) utDdset_enumerate( set , &iter));
    printf("%d\n", (int) (long) utDdset_enumerate( set , &iter));
    printf("%d\n", (int) (long) utDdset_enumerate( set , &iter));
    i = 1 ;
    q = (LONG) utDdset_find( set, VOIDPTR_TYPE(i) ) ;
    fprintf( stderr, "find_after union:%d = %d ...\n", i, q ) ;
    i = 2 ;
    q = (LONG) utDdset_find( set, VOIDPTR_TYPE(i) ) ;
    fprintf( stderr, "find_after union:%d = %d ...\n", i, q ) ;
    i = 3 ;
    q = (LONG) utDdset_find( set, VOIDPTR_TYPE(i) ) ;
    fprintf( stderr, "find_after union:%d = %d ...\n", i, q ) ;

    i = 11 ;
    utDdset_union( set, (VOIDPTR) 11, VOIDPTR_TYPE(1) ) ;
    q = (LONG) utDdset_find( set, VOIDPTR_TYPE(i) ) ;
    fprintf( stderr, "find_after union:%d = %d ...\n", i, q ) ;

    /* now lets look at the parents of all the sets */
    fprintf( stderr, "\nThe parents of the sets are:\n" ) ;
    for( q = (LONG) utDdset_enumerate_parents( set, UTDDSET_FIRST(&parent_iter) ) ;
	q ;
	q = (LONG) utDdset_enumerate_parents( set, &parent_iter ) ){
	fprintf( stderr, "%d ", q ) ;
    } /* end */
    fprintf( stderr, "\n" ) ;

    fprintf( stderr, "\nThe enumeration using superset:\n" ) ;
    for( q = (LONG) utDdset_enumerate_superset( set, UTDDSET_FIRST(&super_iter) ) ;
	q ;
	q = (LONG) utDdset_enumerate_superset( set, &super_iter ) ){
	fprintf( stderr, "%d ", q ) ;
    } /* end */
    fprintf( stderr, "\n" ) ;


    fprintf( stderr, "\nUse enumerate parents and subset to mimic a dump\n" ) ;
    for( q = (LONG) utDdset_enumerate_parents( set, UTDDSET_FIRST(&parent_iter) ) ;
	q ;
	q = (LONG) utDdset_enumerate_parents( set, &parent_iter ) ){
	for( j = (LONG) utDdset_enumerate_subset( set, VOIDPTR_TYPE(q), UTDDSET_FIRST(&sub_iter) ) ;
	    j ;
	    j = (LONG) utDdset_enumerate_subset( set, VOIDPTR_TYPE(q), &sub_iter ) ){
	    fprintf( stderr, "%d ", j ) ;
	} /* end */
	fprintf( stderr, "\n" ) ;
    } /* end */

    fprintf( stderr, "Memory use:%ld\n", utDmalloc_use() ) ;

    utDdset_dump(set,NULL,(utDdumpFile)print_data) ;
    fprintf( stderr, "Now test making parent operation\n" ) ;
    utDdset_make_parent( set, VOIDPTR_TYPE(8) ) ;
    utDdset_make_parent( set, VOIDPTR_TYPE(11) ) ;
    parent_p = utDdset_make_parent( set, VOIDPTR_TYPE(12) ) ;
    if(!(parent_p)){
      fprintf( stderr, "no parent as it should be.\n" ) ;
    }
    utDdset_dump(set,NULL,(utDdumpFile)print_data) ;

    fprintf( stderr, "\nUse enumerate parents and subset to mimic a dump\n" ) ;
    for( q = (LONG) utDdset_enumerate_parents( set, UTDDSET_FIRST(&parent_iter) ) ;
	q ;
	q = (LONG) utDdset_enumerate_parents( set, &parent_iter ) ){
	for( j = (LONG) utDdset_enumerate_subset( set, VOIDPTR_TYPE(q), UTDDSET_FIRST(&sub_iter) ) ;
	    j ;
	    j = (LONG) utDdset_enumerate_subset( set, VOIDPTR_TYPE(q), &sub_iter ) ){
	    fprintf( stderr, "%d ", j ) ;
	} /* end */
	fprintf( stderr, "\n" ) ;
    } /* end */
    fprintf( stderr, "Now delete the data\n" ) ;

    utDdset_empty( set, (utDdelete)my_delete ) ;
    fprintf( stderr, "Memory use:%ld\n", utDmalloc_use() ) ;
    utDdset_dump(set,NULL,(utDdumpFile)print_data) ;
    utDdset_free( set, (utDdelete)my_delete ) ;
    fprintf( stderr, "Memory use:%ld\n", utDmalloc_use() ) ;

    utDmempool_free_all() ;
    fprintf( stderr, "Memory use:%ld\n", utDmalloc_use() ) ;
    exit(0) ;
    return(0) ;

}

#endif /* TEST */
/* ******************** END TEST PROGRAM ************************ */
