/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    rbtree.c                                       
DESCRIPTION:Red-black Binary tree routines.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>
#include <utd/debug.h>
#include <utd/msg.h>

/* define macros for easier reading of the code */
#define  COMP_F( tr, a, b ) \
  (*(tr->compare_func))( a,b,tr->clientData)

#define SIGN(x) (((x) < 0) ? -1 : (((x) > 0) ? 1 : 0))

#define BLACK        0
#define RED          1

typedef struct utd_bin_tree {
    struct utd_bin_tree *left ;
    struct utd_bin_tree *right ;
    struct utd_bin_tree *parent ;
    VOIDPTR data ;
    BOOL color ;
} BINTREE, *BINTREEPTR ;

typedef struct utdtree {
    BINTREEPTR root ;			/* the root of the tree */
    INT (*compare_func)(void *,void *,void *) ;
    INT        size ;			/* current size of tree */
    INT        pool_id ;		/* memory pool id */		
    BOOL       unique ;			/* set search to be unique */
    VOIDPTR    clientData ;		/* user client data */
} UTDTREEBOX, *UTDTREEPTR ;

#define UTDTREE_H_DEFS
#include <utd/rbtree.h>

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static BINTREE      sentinelS ;        /* build a sentinel */
static BINTREEPTR   nilS ;             /* pointer to sentinel */
static BINTREE      recalc_sentinelS ; /* build a recalculate flag */
static BINTREEPTR   recalcS ;          /* pointer to recalc flag */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static INT tree_default_compare( VOIDPTR d1, VOIDPTR d2, VOIDPTR clientData ) ;
static BINTREEPTR tree_search( UTDTREEPTR tree, char *key ) ;
static BINTREEPTR tree_suc( BINTREEPTR ptr ) ;
static BINTREEPTR tree_pred( BINTREEPTR ptr ) ;
static void left_rotate( UTDTREEPTR tree, BINTREEPTR x ) ;
static void right_rotate( UTDTREEPTR tree, BINTREEPTR x ) ;
static void tree_free( UTDTREEPTR tree_p, BINTREEPTR ptr ) ;
static void tree_free_data(BINTREEPTR ptr, utDdeleteClientData userDelete,VOIDPTR clientData ) ;
static void tree_free_and_data( UTDTREEPTR tred_p,BINTREEPTR ptr,utDdeleteClientData userDelete) ;
static void tree_delete( UTDTREEPTR tree,BINTREEPTR z,utDdeleteClientData userDelete ) ;
static void tree_dump( UTDTREEPTR tree,BINTREEPTR ptr,FILE *fp,
    		    void (*print_key)(FILE *,void *),INT printTab ) ;

UTDTREEPTR utDrbtree_init(INT (*compare_func) (void *,void *,void *),
			  VOIDPTR clientData )
{
    INT pool_id ;		/* pool id */	
    UTDTREEPTR tree_p ;      	/* the current tree being built */
    FUNC_NAME("utDrbtree_init") ;
	
    if(!(compare_func)){
      utDmsgf(ERRMSG,MSG_AT,routine,
	"Routine may not be called without a comparison function.\n" ) ;
      return(NULL) ;
    }

    pool_id = UTDPOOL_INIT( 0, BINTREE ) ;

    /* initialize nilS */
    nilS = &sentinelS ;
    nilS->parent = NULL ;
    nilS->right = NULL ;
    nilS->left = NULL ;
    nilS->data = NULL ;
    nilS->color = BLACK ;
    recalcS = &recalc_sentinelS ;

    tree_p = UTDMALLOC( 1, UTDTREEBOX ) ;
    tree_p->root = nilS ;
    if( compare_func ){
      tree_p->compare_func = compare_func ;
    } else {
      tree_p->compare_func = tree_default_compare ;
    }
    tree_p->clientData = clientData ;
    tree_p->size = 0;
    tree_p->unique = FALSE;
    tree_p->pool_id = pool_id ;
    return( tree_p ) ;

} /* end utDrbtree_init() */

utDcompareClientData utDrbtree_get_compare_func(UTDTREEPTR tree_p)
{
    return( tree_p->compare_func ) ;
} /* end utDrbtree_get_compare_func() */

VOIDPTR utDrbtree_get_clientData(UTDTREEPTR tree_p)
{
    return( tree_p->clientData ) ;
} /* end utDrbtree_get_clientData() */

void utDrbtree_set_clientData(UTDTREEPTR tree_p,VOIDPTR clientData)
{
    tree_p->clientData = clientData ;
} /* end utDrbtree_set_clientData() */

/* -----------------------------------------------------------------
 * This function sets the comparison function but does not resort
 * the tree.  Tree may be out of order.  However, this saves time
 * if the tree has just been emptied.
----------------------------------------------------------------- */
void utDrbtree_set_compare_func(UTDTREEPTR tree_p,utDcompareClientData compare_func,
                                VOIDPTR clientData )
{
    tree_p->compare_func = compare_func ;
    tree_p->clientData = clientData ;
} /* end utDrbtree_set_compare_func() */


INT utDrbtree_poolid(UTDTREEPTR tree)
{
  return( tree->pool_id );
}

static INT tree_default_compare(VOIDPTR d1, VOIDPTR d2,VOIDPTR clientData)
{
    if( d1 < d2 ){
      return(-1) ;
    } else if( d1 > d2 ){
      return(1) ;
    } else {
      return(0) ;
    }
} /* end tree_default_compare() */

/* used internally in this routine */
static BINTREEPTR tree_search(UTDTREEPTR tree, char *key)
{
    BINTREEPTR ptr ;            	/* current node in the tree */
    INT k ;                   		/* test condition [-1,0,1] */

    ptr = tree->root ;

    while( ptr != nilS && (k = COMP_F( tree, ptr->data, key )) ){
	if( k > 0 ){
	    ptr = ptr->left ;
	} else {
	    ptr = ptr->right ;
	}
    }
    return( ptr ) ;
    
} /* end tree_search */


/* the global version */
VOIDPTR utDrbtree_search(UTDTREEPTR tree, VOIDPTR key)
{
    BINTREEPTR ptr ;          		/* current node in the tree */
    INT k ;

    ptr = tree->root ;
    while( ptr != nilS && (k = COMP_F( tree, ptr->data, key )) ){
	if( k > 0 ){
	    ptr = ptr->left ;
	} else {
	    ptr = ptr->right ;
	}
    }
    if( ptr != nilS ){
	return( ptr->data ) ;
    }

    return( NULL ) ;
    
} /* end utDrbtree_search */

static BINTREEPTR _utdrbtree_search_closest(UTDTREEPTR tree, VOIDPTR key, UTD_SEARCH_T func)
{
    BINTREEPTR ptr ;          /* current node in the tree */
    BINTREEPTR closest_ptr ;  /* current closest match in the tree */
    BINTREEPTR suc, pred ;    /* successor and predecessor for closest_ptr */
    INT dist1, dist2 ;	      /* distance using predecessor functions */
    INT k ;

    ptr = tree->root ;
    closest_ptr = NULL ;

    k = 1 ;
    while( ptr != nilS && (k = COMP_F( tree, key, ptr->data )) ){
	closest_ptr = ptr ; /* save the closest match so far */
	if( k <= 0 ){
	    ptr = ptr->left ;
	} else {
	    ptr = ptr->right ;
	}

    }
    if( ptr != nilS && k == 0 ){
      closest_ptr = ptr ; /* an match by comparison function */
    }
    if( ptr == nilS || func == UTD_SEARCH_EXACT ){
	/* in the case of no exact match return closest */
	if( closest_ptr ){
	    switch( func ){
	    case UTD_SEARCH_CLOSEST_NOP:
		break ;
	    case UTD_SEARCH_CLOSEST_BELOW:
		dist1 = COMP_F( tree, closest_ptr->data, key ) ;
		if( dist1 > 0 ){
		    pred = tree_pred( closest_ptr ) ;
		    if( pred != nilS ){
			/* take predecessor */
			closest_ptr = pred ;
		    } else {
 	              return( NULL ) ;
		    }
		}
		break ;
	    case UTD_SEARCH_CLOSEST_ABOVE:
		dist1 = COMP_F( tree, closest_ptr->data, key ) ;
		if( dist1 < 0 ){
		    suc = tree_suc( closest_ptr ) ;
		    if( suc != nilS ){
			/* take successor */
			closest_ptr = suc ;
		    } else {
 	              return( NULL ) ;
		    }
		}
		break ;
	    case UTD_SEARCH_CLOSEST:
		/* ----------------------------------------------------------
		*  See which one is closer - current pointer, predecessor
		*  or sucessor.
		---------------------------------------------------------- */
		dist1 = COMP_F( tree, closest_ptr->data, key ) ;
		pred = tree_pred( closest_ptr ) ;
		if( pred != nilS ){
		    dist2 = COMP_F( tree, pred->data, key ) ;
		    if( ABS(dist2) < ABS(dist1) ){
			/* predecessor is closer */
			closest_ptr = pred ;
			dist1 = dist2 ;
		    } 
		}
		suc = tree_suc( closest_ptr ) ;
		if( suc != nilS ){
		    dist2 = COMP_F( tree, suc->data, key ) ;
		    if( ABS(dist2) < ABS(dist1) ){
			/* take sucessor only if it is better */
			closest_ptr = suc ;
		    } 
		}
		break ;
	    case UTD_SEARCH_EXACT:
		if( k == 0 ){
		  /* find start of equal keys. If we find match we are done */
		  closest_ptr = ptr ;
		  do {
		    if( ptr->data == key ){
		      return( ptr->data ) ;
		    }
		    ptr = tree_pred( ptr ) ;
		  } while( ptr && ptr != nilS && (COMP_F(tree,key,ptr->data)==0));
		  /* If we get here restore our previous place */
		  ptr = closest_ptr ;

		} else { /* ptr is nilS */
		  ptr = closest_ptr ;
		  closest_ptr = NULL ;
		}
		do {
		  if( ptr->data == key ){
		    closest_ptr = ptr ;
		    break ;
		  }
		  ptr = tree_suc( ptr ) ;
		} while( ptr && ptr != nilS && (COMP_F(tree,key,ptr->data) == 0));

		if(!(closest_ptr)){
		  return(NULL) ; /* no exact match */
		}
		break ;

	    } /* end switch( func )...  */
	    ptr = closest_ptr ;

	} else {
	    /* there is nothing in the tree */
	    return( NULL ) ;
	}
    }

    return( ptr ) ;
    
} /* end _utdrbtree_search_closest */


VOIDPTR utDrbtree_search_closest(UTDTREEPTR tree, VOIDPTR key, UTD_SEARCH_T func)
{
    BINTREEPTR ptr ;          /* current node in the tree */

    ptr = _utdrbtree_search_closest( tree, key, func) ;
    if( ptr && (ptr != nilS) ){
      return( ptr->data ) ;
    }
    return(NULL) ; 
    
} /* end utDrbtree_search_closest() */


VOIDPTR utDrbtree_search_closestRE(UTDTREEPTR tree, VOIDPTR key,UTD_SEARCH_T func,UTDTREEITERPTR iter_p)
{
    BINTREEPTR ptr ;          /* current node in the tree */

    if(!(iter_p)){
      utDmsgf(ERRMSG,MSG_AT,"utDrbtree_search_closestRE", "NULL iteration pointer.\n" ) ;
      return(NULL) ;
    }

    ptr = _utdrbtree_search_closest( tree, key, func) ;
    iter_p->position = ptr ; 	/* save new current position */
    if( ptr && (ptr != nilS) ){
      return( ptr->data ) ;
    }
    return(NULL) ; 
    
} /* end utDrbtree_search_closestRE() */


static BINTREEPTR _utdrbtree_search_closest_dist(UTDTREEPTR tree,VOIDPTR key,
                                               UTDDISTFUNC dist_func, 
					       UTD_SEARCH_T search_op, VOIDPTR data_p)
{
    BINTREEPTR ptr ;          /* current node in the tree */
    BINTREEPTR closest_ptr ;  /* current closest match in the tree */
    BINTREEPTR pred ;         /* predecessor for closest_ptr */
    BINTREEPTR suc ;          /* successor for closest_ptr */
    DOUBLE dist1 ;     	      /* distance using predecessor functions */
    DOUBLE dist2 ;     	      /* distance using successor functions */
    DOUBLE k ;

    ptr = tree->root ;
    closest_ptr = NULL ;

    k = 1.0;
    while( ptr != nilS && (k = dist_func(key, ptr->data, data_p)) ){
      closest_ptr = ptr ; /* save the closest match so far */
      if( k <= 0.0 ){
	ptr = ptr->left ;
      } else {
	ptr = ptr->right ;
      }
    }

    if( ptr != nilS && k == 0.0 ){
      closest_ptr = ptr ; /* an match by comparison function */
    }

    if( ptr == nilS ){
      /* in the case of no exact match return closest */
      if( closest_ptr ){
	switch( search_op ){
	  case UTD_SEARCH_CLOSEST_NOP:
	    break ;
	  case UTD_SEARCH_CLOSEST_BELOW:
	    dist1 = dist_func(closest_ptr->data, key, data_p) ;
	    if( dist1 > 0 ){
	      pred = tree_pred( closest_ptr ) ;
	      if( pred != nilS ){
		/* take predecessor */
		closest_ptr = pred ;
	      } else {
		return( NULL ) ;
	      }
	    }
	    break ;
	  case UTD_SEARCH_CLOSEST_ABOVE:
	    dist1 = dist_func(closest_ptr->data, key, data_p) ;
	    if( dist1 < 0 ){
	      suc = tree_suc( closest_ptr ) ;
	      if( suc != nilS ){
		/* take successor */
		closest_ptr = suc ;
	      } else {
		return( NULL ) ;
	      }
	    }
	    break ;
	  case UTD_SEARCH_CLOSEST:
	    /* ----------------------------------------------------------
	    *  See which one is closer - current pointer, predecessor
	    *  or sucessor.
	    ---------------------------------------------------------- */
	    dist1 = dist_func(closest_ptr->data, key, data_p) ;
	    pred = tree_pred( closest_ptr ) ;
	    if( pred != nilS ){
		dist2 = dist_func( pred->data, key, data_p) ;
		if( ABS(dist2) < ABS(dist1) ){
		    /* predecessor is closer */
		    closest_ptr = pred ;
		    dist1 = dist2 ;
		} 
	    }
	    suc = tree_suc( closest_ptr ) ;
	    if( suc != nilS ){
		dist2 = dist_func( suc->data, key, data_p) ;
		if( ABS(dist2) < ABS(dist1) ){
		    /* take sucessor only if it is better */
		    closest_ptr = suc ;
		} 
	    }
	    break ;

	  case UTD_SEARCH_EXACT:
	    break ;

	} /* end switch( search_op... */

	ptr = closest_ptr ;
      } else {
	/* there is nothing in the tree */
	return( NULL ) ;
      }
    }
    return( ptr ) ;
    
} /* end _utdrbtree_search_closest_dist() */


VOIDPTR utDrbtree_search_closest_dist(UTDTREEPTR tree, VOIDPTR key, UTDDISTFUNC dist_func, 
                                    UTD_SEARCH_T search_op, VOIDPTR data_p)
{
    BINTREEPTR ptr ;          /* current node in the tree */

    ptr = _utdrbtree_search_closest_dist( tree, key, dist_func, search_op, data_p ) ;
    if( ptr && (ptr != nilS) ){
      return( ptr->data ) ;
    }
    return(NULL) ;
    
} /* end utDrbtree_search_closest_dist() */

VOIDPTR utDrbtree_search_closest_distRE(UTDTREEPTR tree, VOIDPTR key, UTDDISTFUNC dist_func, 
                                      UTD_SEARCH_T search_op, VOIDPTR data_p, 
				      UTDTREEITERPTR iter_p)
{
    BINTREEPTR ptr ;          /* current node in the tree */

    if(!(iter_p)){
      utDmsgf(ERRMSG,MSG_AT,"utDrbtree_search_closest_distRE", "NULL iteration pointer.\n" ) ;
      return(NULL) ;
    }
    ptr = _utdrbtree_search_closest_dist( tree, key, dist_func, search_op, data_p ) ;
    iter_p->position = ptr ; 	/* save new current position */
    if( ptr && (ptr != nilS) ){
      return( ptr->data ) ;
    }
    return(NULL) ; 
    
} /* end utDrbtree_search_closest_distRE() */


VOIDPTR utDrbtree_min(UTDTREEPTR tree)
{
    BINTREEPTR ptr ;          /* current node in the tree */
    
    if ( tree->root == nilS ) {
      return( NULL );    
    }

    for( ptr = tree->root; ptr->left != nilS ; ptr = ptr->left ) ;
    if( ptr != nilS ){
	return( ptr->data ) ;
    }
    return( NULL ) ;
} /* end utDrbtree_min */

VOIDPTR utDrbtree_max(UTDTREEPTR tree)
{
    BINTREEPTR ptr ;          /* current node in the tree */

    if ( tree->root == nilS ) {
      return( NULL );    
    }

    for( ptr = tree->root; ptr->right != nilS ; ptr = ptr->right ) ;
    if( ptr != nilS ){
	return( ptr->data ) ;
    }
    return( NULL ) ;
} /* end utDrbtree_min */

static BINTREEPTR tree_suc(BINTREEPTR ptr)
{
    BINTREEPTR y ;          /* a temporary pointer */

    if( ptr == nilS ){
	return( nilS ) ;
    }
    if( ptr->right != nilS ){
	for( ptr = ptr->right; ptr->left != nilS ; ptr = ptr->left ) ;
	return( ptr ) ;
    }
    for( y = ptr->parent; y != nilS && ptr == y->right; y = y->parent ){
	ptr = y ;
    }
    return( y ) ;
} /* end tree_suc */

static BINTREEPTR tree_pred(BINTREEPTR ptr)
{
    BINTREEPTR y ;          /* a temporary pointer */

    if( ptr == nilS ){
	return( nilS ) ;
    }
    if( ptr->left != nilS ){
	/* find the rightmost of the left pointer */
	for( ptr = ptr->left; ptr->right != nilS ; ptr = ptr->right ) ;
	return( ptr ) ;
    }
    /* otherwise we have to back up to the parent */
    for( y = ptr->parent; y != nilS && ptr == y->left; y = y->parent ){
	ptr = y ;
    }
    return( y ) ;
} /* end tree_pred */


VOIDPTR utDrbtree_suc(UTDTREEPTR tree, VOIDPTR data)
{
    BINTREEPTR ptr ;          /* a temporary pointer */
    BINTREEPTR suc ;          /* a temporary pointer */

    ptr = tree_search( tree, data ) ;
    suc = tree_suc( ptr ) ;
    if( suc != nilS ){
	return( suc->data ) ;
    }
    return( NULL ) ;
} /* end utDrbtree_suc */


VOIDPTR utDrbtree_pred(UTDTREEPTR tree, VOIDPTR data)
{
    BINTREEPTR ptr ;		/* current node in the tree */

    /* 
	Find predecessor to current position in tree set by utDrbtree_search
    */
    ptr = tree_search( tree, data ) ;
    ptr = tree_pred( ptr ) ;

    if( ptr != nilS ){
	return( ptr->data ) ;
    }
    return( NULL ) ;
    
} /* end utDrbtree_pred */


VOIDPTR utDrbtree_search_sucRE(UTDTREEPTR tree, UTDTREEITERPTR iter_p)
{
    BINTREEPTR ptr ;		/* current node in the tree */

    if(!(iter_p)){
      utDmsgf(ERRMSG,MSG_AT,"utDrbtree_search_sucRE", "NULL iteration pointer.\n" ) ;
      return(NULL) ;
    }
    /* find successor to current position in tree set by utDrbtree_searchRE routines */
    ptr = iter_p->position ; 	/* get old current position */
    ptr = tree_suc( ptr ) ;
    iter_p->position = ptr ; 	/* save new current position */

    if( ptr && (ptr != nilS) ){
	return( ptr->data ) ;
    }
    return( NULL ) ;
    
} /* end utDrbtree_search_sucRE() */

VOIDPTR utDrbtree_search_predRE(UTDTREEPTR tree, UTDTREEITERPTR iter_p)
{
    BINTREEPTR ptr ;		/* current node in the tree */

    if(!(iter_p)){
      utDmsgf(ERRMSG,MSG_AT,"utDrbtree_search_predRE", "NULL iteration pointer.\n" ) ;
      return(NULL) ;
    }
    /* 
	Find predecessor to current position in tree set by utDrbtree_search
    */
    ptr = iter_p->position ; 	/* get old current position */
    ptr = tree_pred( ptr ) ;
    iter_p->position = ptr ; 	/* save new current position */

    if( ptr && (ptr != nilS) ){
	return( ptr->data ) ;
    }
    return( NULL ) ;
    
} /* end utDrbtree_search_predRE() */

static void left_rotate(UTDTREEPTR tree, BINTREEPTR x)
{
    BINTREEPTR y ;          /* a temporary pointer */

    y = x->right ;             /* set y */
    x->right = y->left ;       /* Turn y's left subtreee in x's right */
    if( y->left != nilS ){
	y->left->parent = x ;
    }
    y->parent = x->parent ;   /* link x's parent to y */
    if( x->parent == nilS ){
	tree->root = y ;
    } else if( x == x->parent->left ){
	x->parent->left = y ;
    } else {
	x->parent->right = y ;
    }
    y->left = x ;             /* put x on y's left */
    x->parent = y ;       
} /* left_rotate */

static void right_rotate(UTDTREEPTR tree, BINTREEPTR x)
{
    BINTREEPTR y ;          /* a temporary pointer */

    y = x->left ;             /* set y */
    x->left = y->right ;      /* Turn y's right subtreee in x's left */
    if( y->right != nilS ){
	y->right->parent = x ;
    }
    y->parent = x->parent ;   /* link x's parent to y */
    if( x->parent == nilS ){
	tree->root = y ;
    } else if( x == x->parent->right ){
	x->parent->right = y ;
    } else {
	x->parent->left = y ;
    }
    y->right = x ;            /* put x on y's right */
    x->parent = y ;       
} /* right_rotate */

/* -----------------------------------------------------------------
* Delete a node in the tree by using actual pointer.  Also frees
* user data if necessary.
----------------------------------------------------------------- */
static void tree_delete(UTDTREEPTR tree, BINTREEPTR z, void (*userDelete) (void *,void *))
{
    BINTREEPTR w ;            /* a temporary pointer */
    BINTREEPTR x ;            /* a temporary pointer */
    BINTREEPTR y ;            /* a temporary pointer */

    /* we must delete the user data first so to avoid copy problem later */
    if (userDelete) {
      (*userDelete)( z->data, tree->clientData ) ;
    }
    /* now begin deletion process */
    /* determine which node to splice out */
    if( z->left == nilS || z->right == nilS ){
	y = z ;
    } else {
	y = tree_suc( z ) ;
    }
    /* let x be the non-nil child of y or nil if y has no children */
    if( y->left != nilS ){
	x = y->left ;
    } else {
	x = y->right ;
    }
    /* splice out y */
    x->parent = y->parent ;
    if( y->parent == nilS ){
	/* y is the root - x becomes new root */
	tree->root = x ;
    } else if( y == y->parent->left ){
	y->parent->left = x ;
    } else {
	y->parent->right = x ;
    }
    /* if the successor of z was spliced out copy content */
    if( y != z ){
	z->data = y->data ;
    }

    /* now take care of the red black attributes */
    if( y->color == BLACK ){
	while( x != tree->root && x->color == BLACK ){
	    if( x == x->parent->left ){
		w = x->parent->right ;
		if( w->color == RED ){
		    w->color = BLACK ;
		    x->parent->color = RED ;
		    left_rotate( tree, x->parent ) ;
		    w = x->parent->right ;
		}
		if( w->left->color == BLACK && w->right->color == BLACK ){
		    w->color = RED ;
		    x = x->parent ;
		} else {
		    if( w->right->color == BLACK ){
			w->left->color = BLACK ;
			w->color = RED ;
			right_rotate( tree, w ) ;
			w = x->parent->right ;
		    }
		    w->color = x->parent->color ;
		    x->parent->color = BLACK ;
		    w->right->color = BLACK ;
		    left_rotate( tree, x->parent ) ;
		    x = tree->root ;
		}
	    } else { /* right side case */
		w = x->parent->left ;
		if( w->color == RED ){
		    w->color = BLACK ;
		    x->parent->color = RED ;
		    right_rotate( tree, x->parent ) ;
		    w = x->parent->left ;
		}
		if( w->right->color == BLACK && w->left->color == BLACK ){
		    w->color = RED ;
		    x = x->parent ;
		} else {
		    if( w->left->color == BLACK ){
			w->right->color = BLACK ;
			w->color = RED ;
			left_rotate( tree, w ) ;
			w = x->parent->left ;
		    }
		    w->color = x->parent->color ;
		    x->parent->color = BLACK ;
		    w->left->color = BLACK ;
		    right_rotate( tree, x->parent ) ;
		    x = tree->root ;
		}
	    } /* end right side case */
	} /* end while loop */
	x->color = BLACK ;
    } /* end test on y's color */

    /* now safe to free y */
    UTDPOOL_FREE_ITEM(tree->pool_id, y);
    tree->size --;

} /* end tree_delete */

/* returns true if added(unique) otherwise returns FALSE */
BOOL utDrbtree_insertIfUnique(UTDTREEPTR tree, VOIDPTR data)
{
    BOOL save_flag ;		/* save unique state */
    BOOL ret_code ;		/* return from rbtree_insert */

    if(!(data)){
	utDmsgf( ERRMSG, MSG_AT, "utDrbtree_insertIfUnique","No data given\n" ) ;
	return(FALSE) ;
    }
    save_flag = tree->unique ;
    tree->unique = TRUE ;
    ret_code = utDrbtree_insert( tree, data ) ;
    tree->unique = save_flag ;
    return( ret_code ) ;
} /* end utDrbtree_insertIfUnique() */

void utDrbtree_unique(UTDTREEPTR tree, BOOL flag)
{
    if( tree ){
      tree->unique = flag ;
    }
} /* end utDrbtree_unique() */



BOOL utDrbtree_insert(UTDTREEPTR tree, VOIDPTR data)
{
    BINTREEPTR x ;      	/* a temporary pointer */
    BINTREEPTR y ;      	/* a temporary pointer */
    BINTREEPTR ptr ;     	/* a temporary pointer */
    INT k ;			/* result of comparison */

    if(!(data)){
	utDmsgf( ERRMSG, MSG_AT, "utDrbtree_insert","No data given\n" ) ;
	return(FALSE) ;
        /*-------------------------------------------------
           Are you using integers? You may want to consider
           a different data structure. 0 has a special meaning
           in some of the rbtree.c routines.  For example,
           utDrbtree_enumerate() returns 0 to signal the last
           element in an enumeration. If you have a 0 in the
           tree, you will need to call utDrbtree_enumerate()
           more than once to guarantee that enumeration is
           finished.
         ---------------------------------------------------*/
    }

    /* first perform an normal insertion into the binary tree */
    y = nilS ;
    /* find the place where we want to deposit the data */
    for( ptr = tree->root; ptr != nilS ; ){
	y = ptr ;  /* save the place for the insert */
	k = COMP_F( tree, data, ptr->data ) ;
	k = SIGN( k ) ;
	switch( k ){
	case -1 :
	    ptr = ptr->left ;
	    break ;
	case 0:
	    if( tree->unique ){
		/* item is a duplicate */
		return( FALSE ) ;
	    }
	case 1:
	    ptr = ptr->right ;
	    break ;
	} /* end switch() */
    }

    x = UTDPOOL_MALLOC( tree->pool_id, BINTREE ) ;
    x->data = data ;
    x->left = nilS ;
    x->right = nilS ;

    /* now set the parent field of x */
    x->parent = y ;
    if( y == nilS ){
	tree->root = x ;
    } else if( COMP_F( tree, data, y->data ) < 0 ){
	y->left = x ;
    } else {
	y->right = x ;
    }

    /* now fix up the tree so it is a red black tree */
    x->color = RED ;
    while( x != tree->root && x->parent->color == RED ){
	if( x->parent == x->parent->parent->left ){
	    y = x->parent->parent->right ;
	    if( y->color == RED ){
		x->parent->color = BLACK ;
		y->color = BLACK ;
		x->parent->parent->color = RED ;
		x = x->parent->parent ;
	    } else {
		if( x == x->parent->right ){
		    x = x->parent ;
		    left_rotate( tree, x ) ;
		}
		x->parent->color = BLACK ;
		x->parent->parent->color = RED ;
		right_rotate( tree, x->parent->parent ) ;
	    }
	} else {
	    y = x->parent->parent->left ;
	    if( y->color == RED ){
		x->parent->color = BLACK ;
		y->color = BLACK ;
		x->parent->parent->color = RED ;
		x = x->parent->parent ;
	    } else {
		if( x == x->parent->left ){
		    x = x->parent ;
		    right_rotate( tree, x ) ;
		}
		x->parent->color = BLACK ;
		x->parent->parent->color = RED ;
		left_rotate( tree, x->parent->parent ) ;
	    }
	}
    }
    tree->root->color = BLACK ;
    tree->size ++;
    return( TRUE ) ;
} /* utDrbtree_insert */

/* -----------------------------------------------------------------
 * A new way of doing enumeration which is reentrant.  A big win
 * over previous methods.  First time call with UTDRBTREE_FIRST
----------------------------------------------------------------- */
VOIDPTR utDrbtree_enumerate(UTDTREEPTR tree, UTDTREEITERPTR iter_p)
{
  BINTREEPTR ptr ;          /* remember where we are */

  if(!(iter_p)){
    utDmsgf(ERRMSG,MSG_AT,"utDrbtree_enumerateRE", "Null iteration pointer.\n" ) ;
    return(NULL) ;
  }
  if(!(iter_p->position)){
    for( ptr = tree->root; ptr != nilS && ptr->left != nilS;
	ptr = ptr->left ) ;
  } else {
    /* find successor to current ptr */
    ptr = iter_p->position ;
    if( ptr == recalcS ){
      /* calculate from the beginning */
      iter_p->position = NULL ;
      return( utDrbtree_enumerate( tree, iter_p )) ;
    } else {
      ptr = tree_suc( ptr ) ;
    }
  }
  iter_p->position = ptr ;
  if( ptr != nilS ){
    return( ptr->data ) ;
  }
  return( NULL ) ;
} /* end utDrbtree_enumerate() */


/* delete a node in the tree by using the key */
BOOL utDrbtree_delete(UTDTREEPTR tree, VOIDPTR key, void (*userDelete) (void *,void *))
{
    BINTREEPTR z ;            /* a temporary pointer */

    z = tree_search( tree, key ) ;
    if( z == nilS ){
	/* didn't find data in the tree */
	return( FALSE ) ;
    }
    tree_delete( tree, z, userDelete ) ;
    return( TRUE ) ;

} /* end utDrbtree_delete() */

BOOL utDrbtree_deleteItem(UTDTREEPTR tree, VOIDPTR key, void (*userDelete) (void *,void *))
{
    INT c ;		      /* comparison result */
    BINTREEPTR z ;            /* a temporary pointer */
    BINTREEPTR ptr ;          /* a temporary pointer */

    /* find where we would put the key if we were to put */
    /* it in the tree */
    z = nilS ;
    for( ptr = tree->root; ptr != nilS; ){
      z = ptr ;  /* save the place for the proposed insert */
      if( COMP_F( tree, key, ptr->data ) <= 0 ){
	ptr = ptr->left ;
      } else {
	ptr = ptr->right ;
      }
    }
    /* now see if we need to find successor */
    if( z != nilS ){
      c = COMP_F( tree, key, z->data ) ;
      if( c > 0 ){
	/* find successor to current ptr */
	z = tree_suc( z ) ;
	if( z != nilS ){
	  c = COMP_F( tree, key, z->data ) ;
	}
      }
      if( c ){
	/* not a exact match */
	z = nilS ;
      }
    }
    if( z && z != nilS ){
      do {
	if( z->data == key ){
	  tree_delete( tree, z, userDelete ) ;
	  return( TRUE ) ;
	}
	z = tree_suc( z ) ;
      } while( z && z != nilS && (COMP_F(tree, key, z->data) == 0) ) ;
    }
    return( FALSE ) ;
} /* end utDrbtree_deleteItem() */


BOOL utDrbtree_deleteCurrentIterator(UTDTREEPTR tree, UTDTREEITERPTR iter_p,
				     void (*userDelete) (void *,void *))
{
    BINTREEPTR z ;            /* a temporary pointer */
    BINTREEPTR w ;            /* a temporary pointer */

    z = iter_p->position ;
    if( z != nilS ){
	/* -----------------------------------------------------------------
	*  Perform operations to insure that interval enumerate works 
	*  after delete.  Lucky since predecessor does not get mangled
	*  in a tree delete operation.
	----------------------------------------------------------------- */
	w = tree_pred( z ) ;
	if( w != nilS ){
	    iter_p->position = w ; /* ok to use predecessor */
	} else {
	    /* this is the case where we delete min in tree */
	    /* need to recalculate */
	    iter_p->position = recalcS ; 
	}
	/* -----------------------------------------------------------------
	*  Now we can delete the rbtree pointer.
	----------------------------------------------------------------- */
	tree_delete( tree, z, userDelete ) ;
	return( TRUE ) ;
    } else {
	return( FALSE ) ;
    }
} /* end utDrbtree_deleteCurrentEnumerateRE() */


static void tree_dump(UTDTREEPTR tree, BINTREEPTR ptr, FILE *fp, void (*print_key) (FILE *,void *), 
  INT printTab)
{
    INT  i ;

    if( ptr != nilS ){
	printTab+=4;

	tree_dump( tree, ptr->right, fp, print_key, printTab ) ;

	/* print level */
	fprintf( fp, " " ) ;
	for( i = 1; i < printTab; i++ ){
	    fprintf( fp, " " ) ;
	}
	if( print_key ){
	  (*print_key)( fp, ptr->data ) ;
	} else {
	  fprintf( fp, "data:%0lx", (LONG) ptr->data ) ;
	}
	if( ptr->color == BLACK ){
	    fprintf( fp, ":black\n" ) ;
	} else {
	    fprintf( fp, ":red\n" ) ;
	}

	tree_dump( tree, ptr->left, fp, print_key, printTab ) ;

    }
} /* end Ytree_dump */

void utDrbtree_dump(UTDTREEPTR tree, FILE *fp, void (*print_key) (FILE *,void *))
{
    if( tree ){
        utDrbtree_verify(tree);
	if(!(fp)){
	  fp = stderr ;
	}
	tree_dump( tree, tree->root, fp, print_key, 1 ) ;
    }
} /* end Ytree_dump */


VOIDPTR utDrbtree_interval( UTDTREEPTR tree, VOIDPTR low_key, VOIDPTR high_key, 
			    UTDTREEITERPTR iter_p )
{
    BINTREEPTR ptr ;                  /* remember where we are */
    BINTREEPTR y ;                    /* remember where we are */

    if(!(iter_p)){
      utDmsgf(ERRMSG,MSG_AT,"utDrbtree_intervalRE", "Null iteration pointer.\n" ) ;
      return(NULL) ;
    }
    if(!(iter_p->position)){
	/* find where we would put low_key if we were to put */
	/* it in the tree */
	y = nilS ;
	for( ptr = tree->root; ptr != nilS; ){
	    y = ptr ;  /* save the place for the proposed insert */
	    if( COMP_F( tree, low_key, ptr->data ) <= 0 ){
		ptr = ptr->left ;
	    } else {
		ptr = ptr->right ;
	    }
	}
	/* now see if we need to find successor */
	if( y != nilS ){
	    ptr = y ;
	    if( COMP_F( tree, low_key, ptr->data ) > 0 ){
		/* find successor to current ptr */
		ptr = tree_suc( ptr ) ;
	    }
	}

    } else {
      /* find successor to current ptr */
      ptr = iter_p->position ;
      if( ptr == recalcS ){
	/* calculate from the beginning */
	return( utDrbtree_interval( tree, low_key, high_key, UTDRBTREE_FIRST(iter_p))) ;
      } else {
	ptr = tree_suc( ptr ) ;
      }
    }
    /* is pointer in interval? */
    if( ptr != nilS &&
       COMP_F( tree, ptr->data, high_key ) > 0 ){
      ptr = nilS ;
    }
    iter_p->position = ptr ;
    /* save new current position */
    if( ptr != nilS ){
	return( ptr->data ) ;
    }
    return( NULL ) ;
} /* end Ytree_intervalRE() */





INT utDrbtree_interval_size(UTDTREEPTR tree, VOIDPTR low_key, VOIDPTR high_key)
{
    INT size ;			      /* number of element in interval */
    BINTREEPTR ptr ;                  /* remember where we are */
    BINTREEPTR y ;                    /* remember where we are */

    size = 0 ;
    /* -----------------------------------------------------------------
    *  Find where we would put low_key if we were to put it in the tree.
    ----------------------------------------------------------------- */
    for( y = nilS, ptr = tree->root; ptr != nilS; ){
	y = ptr ;  /* save the place for the proposed insert */
	if( COMP_F( tree, low_key, ptr->data ) <= 0 ){
	    ptr = ptr->left ;
	} else {
	    ptr = ptr->right ;
	}
    }
    /* now see if we need to find successor */
    if( y != nilS ){
	ptr = y ;
	if( COMP_F( tree, low_key, ptr->data ) > 0 ){
	    /* find successor to current ptr */
	    ptr = tree_suc( ptr ) ;
	}
    }
    /* is pointer in interval? */
    if( ptr != nilS && COMP_F( tree, ptr->data, high_key ) > 0 ){
	ptr = nilS ;
    }
    while( ptr && ptr != nilS ){
	size++ ;
	ptr = tree_suc( ptr ) ;
	/* is pointer in interval? */
	if( ptr != nilS && COMP_F( tree, ptr->data, high_key ) > 0 ){
	    ptr = nilS ;
	}
    }
    return( size ) ;
} /* end utDrbtree_interval_size() */



static void tree_free( UTDTREEPTR tree_p, BINTREEPTR ptr)
{
    if( ptr->left != nilS ){
	tree_free( tree_p, ptr->left ) ;
    } 
    if( ptr->right != nilS ){
	tree_free( tree_p, ptr->right ) ;
    } 
    if( ptr != nilS ){
      UTDPOOL_FREE_ITEM( tree_p->pool_id, ptr ) ;
    }
} /* end tree_free */

static void tree_free_data(BINTREEPTR ptr, utDdeleteClientData userDelete,
                           VOIDPTR clientData )
{
    if( ptr->left != nilS ){
        tree_free_data( ptr->left,userDelete, clientData ) ;
    } 
    if( ptr->right != nilS ){
	tree_free_data( ptr->right,userDelete, clientData ) ;
    } 
    if( ptr != nilS ){
        (*userDelete)( ptr->data, clientData );  
    }
} /* end tree_free_data */

static void tree_free_and_data(UTDTREEPTR tree_p, BINTREEPTR ptr, utDdeleteClientData userDelete)
{
    if( ptr->left != nilS ){
	tree_free_and_data( tree_p, ptr->left, userDelete ) ;
    } 
    if( ptr->right != nilS ){
	tree_free_and_data( tree_p, ptr->right, userDelete ) ;
    } 
    if( ptr != nilS ){
	if( userDelete ){
	  (*userDelete)( ptr->data, tree_p->clientData );  /* free tree nodes and data */
	}
	UTDPOOL_FREE_ITEM( tree_p->pool_id, ptr ) ;
    }
} /* end tree_free_and_data */


void utDrbtree_free(UTDTREEPTR tree, void (*userDelete) (void *,void *) )
{
    if( tree ){
      if (tree->root != nilS) {             /* does tree need to be emptied? */
	/* for block mem, it can be free at once */
	/* therefore, only ordinary memory and data */
	/* need to go thru each node */
	if (userDelete) {
	  if( tree->pool_id < 0 ) {  
	    tree_free_and_data( tree, tree->root, userDelete); 
	  } else {
	    tree_free_data( tree->root, userDelete, tree->clientData ) ; 
	  }
	} else {
	  if( tree->pool_id < 0 ) { 
	    tree_free(tree, tree->root);     
	  }
	}
	tree->root = nilS ;                 /* tree is now empty */
      }                       /* end if tree->root */
      tree->size = 0;
      /* free decks associated with tree if they exist */
      UTDPOOL_FREE_POOL( tree->pool_id );
      UTDFREE( tree );                           
    }
} /* end utDrbtree_free */

void utDrbtree_empty(UTDTREEPTR tree, void (*userDelete) (void *,void *))
{
  if( tree ){
    if (tree->root != nilS) {             /* does tree need to be emptied? */
      if (userDelete) {
	tree_free_and_data(tree,tree->root,userDelete);   /* free tree and data */
      } else {
	tree_free(tree,tree->root);            /* free tree nodes only */
      }
      tree->root = nilS ;                 /* tree is now empty */
    }                       /* end if tree->root */
    tree->size = 0;
  }                         /* end if tree       */
} /* end utDrbtree_empty() */


INT utDrbtree_size(UTDTREEPTR tree)
{
    if( tree ){
      if ( tree->size >= 0 ) {
	return( tree->size ) ;
      }
      utDmsg(ERRMSG,MSG_AT,"utDrbtree_size","Bogus rbTree size\n");
    } else {
      utDmsg(ERRMSG,MSG_AT,"utDrbtree_size","NULL rbTree pointer\n");
    }
    return (-1);
} /* end utDrbtree_size */


INT utDrbtree_verify(UTDTREEPTR tree)
{
  INT count;
  count = 0;
 
  return ( count ) ;
}


void utDrbtree_resort(UTDTREEPTR tree, INT (*compare_func) (void *, void *,void *),
		      void (*userDelete)(void *, void *) )
{
    BOOL added ;	      /* item was added to new tree */
    BINTREEPTR ptr ;          /* remember where we are */
    UTDTREEPTR new_tree ;       /* the new tree being built */

    if( compare_func ){
      new_tree = utDrbtree_init( compare_func, tree->clientData ) ;
    } else {
      new_tree = utDrbtree_init( tree->compare_func, tree->clientData ) ;
    }
    new_tree->clientData = tree->clientData ;
    new_tree->unique = tree->unique ;
    UTDPOOL_POOL_INCR( utDrbtree_poolid(new_tree), utDrbtree_size(tree) );

    /* first find the leftmost pointer */
    for( ptr=tree->root;ptr!=nilS && ptr->left != nilS; ptr=ptr->left ) ;

    /* now enumerate all the members of the tree in order */
    for( ; ptr && ptr != nilS ; ptr = tree_suc( ptr ) ) {
	if( ptr != nilS ){
	    /* build new tree */
	    added = utDrbtree_insert( new_tree, ptr->data ) ;
	    if(!(added) && userDelete ){
		(*userDelete)( ptr->data, tree->clientData ) ;
	    }
	}
    }

    /* free the data in the old tree */
    utDrbtree_empty( tree, NULL ) ;
    if( tree->pool_id > 0 ){
      UTDPOOL_FREE_POOL( tree->pool_id );
    }

    /* now copy over tree data */
    tree->root = new_tree->root ;
    tree->size = new_tree->size ;
    tree->pool_id = new_tree->pool_id ;
    if( compare_func ){
      tree->compare_func = compare_func ;
    }
    /* now free new tree */
    UTDFREE( new_tree ) ;

} /* end utDrbtree_resort */

UTDTREEPTR utDrbtree_copy(UTDTREEPTR tree, INT (*compare_func) (void *,void *,void *))
               
                         /* user specifies key function */
{
    BINTREEPTR ptr ;          /* remember where we are */
    UTDTREEPTR new_tree ;       /* the new tree being built */

    if( compare_func ){
      new_tree = utDrbtree_init( compare_func, tree->clientData ) ;
    } else {
      new_tree = utDrbtree_init( tree->compare_func, tree->clientData ) ;
    }
    new_tree->clientData = tree->clientData ;
    UTDPOOL_POOL_INCR( utDrbtree_poolid(new_tree), utDrbtree_size(tree) );
  
    /* first find the leftmost pointer */
    for( ptr=tree->root;ptr!=nilS && ptr->left != nilS; ptr=ptr->left ) ;

    /* now enumerate all the members of the tree in order */
    for( ; ptr && ptr != nilS ; ptr = tree_suc( ptr ) ) {
	/* build new tree */
	utDrbtree_insert( new_tree, ptr->data ) ;
    }
    return( new_tree ) ;

} /* end utDrbtree_resort */


#ifdef TEST

#include <utd/string.h>
#include <stdlib.h>

/* ##################################################################
                       TEST OF TREE ROUTINES 
   ################################################################## */
typedef struct {
    INT  str_len ;
    char *name ;
} DATA, *DATAPTR ;

static INT compare_string(DATAPTR key1, DATAPTR key2,VOIDPTR clientData)
{
    return( strcmp( key1->name, key2->name ) ) ;
} /* end compare */

static INT compare_string2(DATAPTR key1, DATAPTR key2,char *user_data)
{
    INT result ;			/* result from comparison */

    result = strcmp( key1->name, key2->name ) ;
    if( result ){
      if( strcmp( key1->name, user_data ) == STRINGEQ ){
	return(-1) ;
      }
      if( strcmp( key2->name, user_data ) == STRINGEQ ){
	return(1) ;
      }
    }
    return( result ) ;
} /* end compare_string2() */

static INT compare_len(DATAPTR key1, DATAPTR key2,VOIDPTR clientData)
{
    return( key1->str_len - key2->str_len ) ;
} /* end compare_len */

static void print_data(FILE *fp,DATAPTR data)
{
    fprintf( fp, "%s:%d ", data->name, data->str_len ) ;
} /* end print_data() */

static void free_data(DATAPTR data,VOIDPTR clientData)
{
    UTDFREE( data->name ) ;
    UTDFREE( data ) ;
} /* end print_data() */

static DATAPTR make_data(char *string)
{
    DATAPTR data ;

    data = UTDMALLOC( 1, DATA ) ;
    data->str_len = strlen(string) + 1 ;
    data->name = UTDMALLOC( data->str_len, char ) ;
    strcpy( data->name, string ) ;
    return( data ) ;
} /* end make_data */

static void one_round(BOOL memory_pools)
{
    UTDTREEPTR tree1 ;
    UTDTREEPTR tree2 ;
    UTDTREEPTR tree3 ;
    UTDTREEPTR tree4 ;
    DATAPTR data ;
    UTDTREEITER iter ;
    char *mydata ;
    static char buffer1[LRECL] ;
    static char buffer2[LRECL] ;
    INT count ;
    BOOL ok ;
    DATA key1, key2 ;

    key1.name = buffer1 ;
    key2.name = buffer2 ;

    fprintf( stderr, "Initial memory:%ld\n", utDmalloc_use() ) ;

    tree1 = utDrbtree_init( (utDcompareClientData)compare_string, NULL ) ;
    utDrbtree_insert( tree1, make_data("the" ) ) ;
    utDrbtree_insert( tree1, make_data("silver" ) ) ;
    utDrbtree_insert( tree1, make_data("fox" ) ) ;
    utDrbtree_insert( tree1, make_data("jumped" ) ) ;
    utDrbtree_insert( tree1, make_data("over" ) ) ;
    utDrbtree_insert( tree1, make_data("the" ) ) ;
    utDrbtree_insert( tree1, make_data("moon" ) ) ;
    utDrbtree_verify(tree1) ;
    fprintf( stderr, "Output the initial tree\n" ) ;
    for( data =(DATAPTR)utDrbtree_enumerate(tree1,UTDRBTREE_FIRST(&iter)); data ;
	 data =(DATAPTR)utDrbtree_enumerate(tree1,&iter)){
	fprintf( stderr, "key:%s\n", data->name ) ;
    }
    fprintf( stderr, "\nLook for jumped...\n" ) ;
    strcpy( key1.name, "jumped" ) ;
    data = (DATAPTR) utDrbtree_search( tree1, &key1 ) ;
    utDrbtree_verify(tree1) ;
    if( data ){
	fprintf( stderr, "key:%s\n", data->name ) ;
    }
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;
    fprintf( stderr, "\nDelete jumped...\n" ) ;
    strcpy( key2.name, "jumped" ) ;
    utDrbtree_delete( tree1, &key2, (utDdeleteClientData)free_data ) ;
    utDrbtree_verify(tree1) ;
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;

    for( data =(DATAPTR)utDrbtree_enumerate(tree1,UTDRBTREE_FIRST(&iter)); data ;
	 data =(DATAPTR)utDrbtree_enumerate(tree1,&iter)){
	fprintf( stderr, "key:%s\n", data->name ) ;
    }
    fprintf( stderr, "\nInsert takeover and try to delete history...\n" );
    utDrbtree_insert( tree1, make_data("takeover" ) ) ;
    strcpy( key1.name, "history" ) ;
    if( utDrbtree_delete( tree1, &key1, (utDdeleteClientData)free_data ) ){
	fprintf( stderr, "found history\n" ) ;
    } else {
	fprintf( stderr, "didn't find history\n" ) ;
    }
    strcpy( key1.name, "fox" ) ;
    utDrbtree_delete( tree1, &key1, (utDdeleteClientData)free_data ) ;
    fprintf( stderr, "\nNow show result...\n" );
    for( data =(DATAPTR)utDrbtree_enumerate(tree1,UTDRBTREE_FIRST(&iter)); data ;
	 data =(DATAPTR)utDrbtree_enumerate(tree1,&iter)){
	fprintf( stderr, "key:%s\n", data->name ) ;
    }

    fprintf( stderr, "\nNow find interval 'over' to 'the'\n" );
    strcpy( key1.name, "over" ) ;
    strcpy( key2.name, "the" ) ;
    for( data=(DATAPTR)utDrbtree_interval(tree1,&key1,&key2,UTDRBTREE_FIRST(&iter)); data; 
	data=(DATAPTR)utDrbtree_interval(tree1,&key1,&key2,&iter)){
	fprintf( stderr, "key:%s\n", data->name ) ;
    }
    fprintf( stderr, "The interval size is:%d\n",
	utDrbtree_interval_size( tree1, &key1, &key2 ) ) ;


    fprintf( stderr, "\nInsert zoo and delete the two the's...\n" );
    utDrbtree_insert( tree1, make_data("zoo" ) ) ;
    strcpy( key1.name, "the" ) ;
    strcpy( key2.name, "the" ) ;
    for( data=(DATAPTR)utDrbtree_interval(tree1,&key1,&key2,UTDRBTREE_FIRST(&iter)); data; 
	data=(DATAPTR)utDrbtree_interval(tree1,&key1,&key2,&iter)){
	fprintf( stderr, "key:%s\n", data->name ) ;
	utDrbtree_deleteCurrentIterator( tree1, &iter, (utDdeleteClientData)free_data ) ;
    }

    fprintf( stderr, "\nNow dump the tree\n" );
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;

    fprintf( stderr, "\nInsert two airplanes and then delete...\n" );
    utDrbtree_insert( tree1, make_data("airplane" ) ) ;
    utDrbtree_insert( tree1, make_data("airplane" ) ) ;
    fprintf( stderr, "\nLook for airplanes\n" );
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;

    /* now delete them */
    strcpy( key1.name, "airplane" ) ;
    strcpy( key2.name, "airplane" ) ;
    for( data=(DATAPTR)utDrbtree_interval(tree1,&key1,&key2,UTDRBTREE_FIRST(&iter)); data; 
	data=(DATAPTR)utDrbtree_interval(tree1,&key1,&key2,&iter)){
	fprintf( stderr, "key:%s\n", data->name ) ;
	utDrbtree_deleteCurrentIterator( tree1, &iter, (utDdeleteClientData)free_data ) ;
    }
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;
    fprintf( stderr, "The interval size is:%d\n",
	utDrbtree_interval_size( tree1, &key1, &key2 ) ) ;

    fprintf( stderr, "Now delete the maximum element in the tree.\n" ) ;
    data = (DATAPTR) utDrbtree_max(tree1) ;
    fprintf( stderr, "The maximum element is %s\n", data->name ) ;
    utDrbtree_deleteItem(tree1, data, (utDdeleteClientData) free_data) ;
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;

    fprintf( stderr, "\nDelete third sorted element in the tree\n" );
    for( count = 0, data=(DATAPTR)utDrbtree_enumerate(tree1,UTDRBTREE_FIRST(&iter)); data; 
	data=(DATAPTR)utDrbtree_enumerate(tree1,&iter)){
	if( ++count == 3 ){
	    utDrbtree_deleteCurrentIterator( tree1, &iter, (utDdeleteClientData)free_data ) ;
	}
    }
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;

    if( utDrbtree_insertIfUnique( tree1, (data=make_data("zoo")) )){
	fprintf( stderr, "data is unique\n" ) ;
    } else {
	fprintf( stderr, "data is not unique\n" ) ;
	free_data(data,NULL) ;
    }

    if( utDrbtree_insertIfUnique( tree1, make_data("monster") )){
	fprintf( stderr, "data is unique\n" ) ;
    } else {
	fprintf( stderr, "data is not unique\n" ) ;
    }

    fprintf( stderr, "\nUse a new comparison function sort by length\n" );
    utDrbtree_resort( tree1, (utDcompareClientData)compare_len, NULL ) ;

    fprintf( stderr, "\nDump after resort to length\n" );
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;

    fprintf( stderr, "\nUse a old comparison function sort by string\n" );
    utDrbtree_resort( tree1, (utDcompareClientData)compare_string, NULL ) ;

    fprintf( stderr, "\nDump after resort to string\n" );
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;

    tree2 = utDrbtree_copy( tree1, (utDcompareClientData)compare_string ) ;
    strcpy( key1.name, "takeover" ) ;
    if( utDrbtree_delete( tree2, &key1, NULL ) ){
	fprintf( stderr, "deleted takeover from tree 2\n" ) ;
    }

    fprintf( stderr, "\nAgain dump the tree\n" );
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;

    fprintf( stderr, "Now check reentrant deletion routine...\n" ) ;
    count = 0 ;
    for( data=(DATAPTR)utDrbtree_enumerate(tree1,UTDRBTREE_FIRST(&iter));
	data;
	data=(DATAPTR)utDrbtree_enumerate(tree1,&iter)){
	if( ++count % 2 ){
	  fprintf( stderr, "deleting key:%s...", data->name ) ;
	  ok = utDrbtree_deleteCurrentIterator(tree1,&iter,(utDdeleteClientData)free_data) ;
	  if( ok ){
	    fprintf( stderr, "ok\n" ) ;
	  } else {
	    fprintf( stderr, "failed\n" ) ;
	  }
	}
    }
    fprintf( stderr, "Results of the deletion routine...\n" ) ;
    utDrbtree_dump( tree1, NULL, (utDdumpFile)print_data ) ;


    mydata = "the" ;
    tree4 = utDrbtree_init((utDcompareClientData)compare_string2,mydata) ;
    utDrbtree_insert( tree4, make_data("the" ) ) ;
    utDrbtree_insert( tree4, make_data("silver" ) ) ;
    utDrbtree_insert( tree4, make_data("fox" ) ) ;
    utDrbtree_insert( tree4, make_data("jumped" ) ) ;
    utDrbtree_insert( tree4, make_data("over" ) ) ;
    utDrbtree_insert( tree4, make_data("the" ) ) ;
    utDrbtree_insert( tree4, make_data("moon" ) ) ;
    for( data=(DATAPTR)utDrbtree_enumerate(tree4,UTDRBTREE_FIRST(&iter));
	data;
	data=(DATAPTR)utDrbtree_enumerate(tree4,&iter)){
	fprintf( stderr, "key:%s\n", data->name ) ;
    }

    fprintf( stderr, "\nNow free tree\n" );
    utDrbtree_free( tree1, (utDdeleteClientData)free_data ) ;
    utDrbtree_free( tree2, NULL ) ;
    utDrbtree_free( tree4, (utDdeleteClientData)free_data ) ;
    if( memory_pools ){
      UTDPOOL_FREE_ALL() ;
    }
    fprintf( stderr, "Final memory:%ld\n", utDmalloc_use() ) ;
    // utDmalloc_dump() ;
}

int main(int argc,char **argv)
{
    char *a ;				/* test string */
    BOOL mem_test ;			/* test memory dumper */
    /* -----------------------------------------------------------------
     * If mem_test is on we will determine the memory leak from the debug
     * code and the creation of a string.
    ----------------------------------------------------------------- */
    mem_test = FALSE ;

    // utDmalloc_debug(MALLOC_DEBUG|MALLOC_DUMP);
    utDdebug_init(mem_test);

    if( mem_test ){
      a = UTDCALLOC( 1, char ) ;
      // utDmalloc_dump() ;
      UTDFREE(a) ;
    }


    UTDPOOL_ENABLE(TRUE);

    one_round(TRUE);

    UTDPOOL_ENABLE(FALSE);
    
    one_round(FALSE);

    exit(0) ;
    return(0) ;
}

#endif /* TEST */
