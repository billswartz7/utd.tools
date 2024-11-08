/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    rbtree.h                                       
DESCRIPTION:Tree include file for binary and red-black trees.
    The same functionality as binary trees but better performance
    for trees > 100 elements.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_RBTREE_H
#define INCLUDED_UTD_RBTREE_H

#include <utd/base.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef UTDTREE_H_DEFS
typedef struct utdtree UTDTREEBOX ;
typedef struct utdtree *UTDTREEPTR ;
#endif

typedef struct utdtree_iter_rec {
  struct utd_bin_tree *position ;
} UTDTREEITER, *UTDTREEITERPTR ;


/* -----------------------------------------------------------------
 * macro definition for enumeration.  Strange looking but compiler
 * will optimize.  x_yz->position = 0 and x_yz will be returned.
----------------------------------------------------------------- */
#define UTDRBTREE_FIRST(x_yz)	( ((x_yz)->position = NULL) ? (x_yz) : (x_yz) )
#define UTDRBTREE_IS_FIRST(x_yz)	( ((x_yz)->position == NULL) ? TRUE : FALSE )
#define UTDRBTREE_ITER_EQUAL(x_yz,y_yz)	( (x_yz)->position == (y_yz)->position )

typedef DOUBLE (*UTDDISTFUNC) (VOIDPTR data1_p, VOIDPTR data2_p, VOIDPTR data_p) ;

/* THE DEFINITIONS FOR SEARCH CLOSEST FUNCTIONALITY */
typedef enum {
  UTD_SEARCH_CLOSEST_NOP =	0,
  UTD_SEARCH_CLOSEST_BELOW =	1,
  UTD_SEARCH_CLOSEST_ABOVE =	2,
  UTD_SEARCH_CLOSEST =		3,
  UTD_SEARCH_EXACT =		4
} UTD_SEARCH_T ;

/* ******************* BINARY TREE INCLUDE FILES ****************** */
extern UTDTREEPTR utDrbtree_init(INT (*cmpFunc)(void *,void *,void *),
				      VOIDPTR clientData ) ;
/* 
Arguments:
    INT compare_func() ;
Function:
    Initializes a binary tree.  The user should supply a compare
    comparison function similar to the one used by the UNIX 
    quicksort routine.  The function compare_func is assumed to have
    three arguments which are pointers to the arguments being compared.
    The third argument is the client data which is passed to the comparison
    function.  The function should return an integer less than, equal to, or
    greater than 0 according as the first argument is to be considered
    less than, equal to , or greater than the second.  
    The function returns a pointer to the tree data structure. Use 
    the tree pointer returned by utDrbtree_init for all routines to
    work on this tree.  The comparison function no longer needs to be unique.  
*/


extern utDcompareClientData utDrbtree_get_compare_func(UTDTREEPTR tree_p) ;
/* 
Arguments:
    UTDTREEPTR tree_p - tree to act upon.
    BOOL *valid_clientData - returns info about record having valid client
                             client data.  May pass in NULL if you dont want
			     to know.
Function:
    Returns the tree's comparison function.  If you supply a valid client
    data field, the function will return true if the comparison function 
    is really a YcompareClientData function and should be cast as such.
*/

extern VOIDPTR utDrbtree_get_clientData(UTDTREEPTR tree_p) ;
/* 
Arguments:
    UTDTREEPTR tree_p - tree to act upon.
Function:
    Returns the tree's client Data.  It may be inactive at the current time.
    You need to check valid_clientData for its status.
*/

extern void utDrbtree_set_clientData(UTDTREEPTR tree_p,VOIDPTR clientData) ;
/* 
Arguments:
    UTDTREEPTR tree_p - tree to act upon.
Function:
    Sets tree's client Data. 
*/

extern void utDrbtree_set_compare_func(UTDTREEPTR tree_p,utDcompareClientData compare_func,
                                       VOIDPTR clientData ) ;
/*
Arguments:
    UTDTREEPTR tree_p - tree to act upon.
    utDcompare compare_func - new comparison function.
    VOIDPTR clientData - user clientData.
Function:
   Sets the tree's comparision function.  This does not resort the tree.
   Use rbtree_resort if data is in the tree.
*/

extern VOIDPTR utDrbtree_search( UTDTREEPTR tr, VOIDPTR key ) ;
/* 
Arguments:
    UTDTREEPTR tree ;
    VOIDPTR key ;
Function:
    Given a binary tree data structure, it return the a pointer
    to the stored data object that matches the given key. It 
    returns NULL if no match is found.  Sets the search marker
    for subsequent search_suc and search_pred calls.
*/

extern VOIDPTR utDrbtree_min( UTDTREEPTR tr ) ;
/* 
Arguments:
    UTDTREEPTR tree ;
Function:
    Given a binary tree data structure, it return the a pointer
    to the minimum data object stored in the tree.  It returns 
    NULL if nothing is in the tree. Sets the search marker for
    subsequent search_suc and search_pred calls.
*/

extern VOIDPTR utDrbtree_max( UTDTREEPTR tr ) ;
/* 
Arguments:
    UTDTREEPTR tree ;
Function:
    Given a binary tree data structure, it return the a pointer
    to the maximum data object stored in the tree.  It returns 
    NULL if nothing is in the tree.  Sets the search marker for
    subsequent search_suc and search_pred calls.
*/

extern VOIDPTR utDrbtree_pred( UTDTREEPTR tr, VOIDPTR key ) ;
/* 
Arguments:
    UTDTREEPTR tree ;
    VOIDPTR key ;
Function:
    Given a binary tree data structure, it return the a pointer
    to the predecessor to the given key stored in the tree.  It returns 
    NULL if nothing is in the tree or if no match to the key is found.
*/

extern VOIDPTR utDrbtree_suc( UTDTREEPTR tr, VOIDPTR key ) ;
/* 
Arguments:
    UTDTREEPTR tree ;
    VOIDPTR key ;
Function:
    Given a binary tree data structure, it return the a pointer
    to the successor to the given key stored in the tree.  It returns 
    NULL if nothing is in the tree or if no match to the key is found.
*/

extern BOOL utDrbtree_insert( UTDTREEPTR tr, VOIDPTR data ) ;
/* 
Arguments:
    UTDTREEPTR tree ;
    VOIDPTR data ;
Function:
    Insert an element into the tree.  Data is a pointer to the users
    record to be store in the tree.  Each record must contain a key
    to sort upon. Returns true if inserted - FALSE otherwise.
*/

extern void utDrbtree_unique( UTDTREEPTR tr, BOOL flag ) ;
/* 
Arguments:
    UTDTREEPTR tree ;
    BOOL flag ;
Function:
    Set the unique option for a tree.  If true all future insertions
    will check to make sure item inserted is unique with respect to
    the comparison function.  If false, all future insertions may
    include duplicate items with respect to the comparison function.
*/

extern VOIDPTR utDrbtree_enumerate(UTDTREEPTR tr, UTDTREEITERPTR pos) ;
/* 
Arguments:
    UTDTREEPTR tree ;
    UTDTREEITERPTR pos ;
Function:
    Enumerate all the data in a tree.  First time call with pos->position
    = NULL.  For all subsequent calls, pass the pos record pointer.
    Returns a pointer to the user record.  Returns NULL when all elements 
    have been requested or when no match can be found.
*/


extern VOIDPTR utDrbtree_interval( UTDTREEPTR tr, VOIDPTR low_key,
				   VOIDPTR high_key, UTDTREEITERPTR pos) ;
/* 
Arguments:
    UTDTREEPTR tree ;
    VOIDPTR low_key, *high_key ;
    UTDTREEITERPTR pos ;
Function:
    Enumerate all the data in a tree between low_key and high_key. 
    First time call with pos->position=NULL to get first element in 
    tree >= the low_key.  For all subsequent calls, pass
    pos record pointer to get all the remaining members of the tree. 
    Returns NULL when element > high_key or no match can be found.
*/


extern BOOL utDrbtree_delete( UTDTREEPTR tr, VOIDPTR key, void (*userDelete)(void *,void *) ) ;
/* 
Arguments:
    UTDTREEPTR tree ;
    VOIDPTR key ;
Function:
    Delete a node in the tree by using the key. If userDelete !=0,
    the user delete function supplied is executed with the pointer of 
    the data stored at the tree node as its argument.  For example,
    when we need to delete the tree node we also need to free a field
    of the data stored in addition to the data.  If no user delete
    function is supplied, only memory corresponding to the tree structure
    is freed.   .
		.
		.
	    utDrbtree_delete( my_tree, key, my_data_delete ) ;
		.
		.
		.
	    VOID my_data_delete( data )
	    MY_DATA_TYPE *data ;
	    {
		Ysafe_free( data->my_allocated_field ) ;
		Ysafe_free( data ) ;
	    } 

    Returns 1 if successful, 0 otherwise.
*/

extern BOOL utDrbtree_deleteItem(UTDTREEPTR tree,VOIDPTR key,void (*userDelete) (void *,void *)) ;
/*
Function:
   In the special cast that the search key is the user data pointer which
   is stored in the tree, it is possible to find the data by its pointer
   value for an exact match.
*/

extern BOOL utDrbtree_deleteCurrentIterator(UTDTREEPTR tr,UTDTREEITERPTR iter_p,
					    void (*userDel)(void *,void *) ) ;
/*
Function:
   This version is a reentrant.  this routine is a valid call from any
   iteration function. It will delete the current element and yet
   allow the user to continue enumeration.  This allows one to delete
   individual items that are not distinct with respect to the comparison
   function.  See the rbtree test program to see how it is used.
*/


extern void utDrbtree_empty( UTDTREEPTR tr, utDdeleteClientData user_delete ) ;
/*
Arguments:
   UTDTREEPTR tree;
   utDdeleteClientData userDelete;
Function:
   Removes all nodes in the tree.  Uses a client data free function
   for convenience.
*/

extern void utDrbtree_free( UTDTREEPTR tr, utDdeleteClientData userDelete) ;
/*
Arguments:
   UTDTREEPTR tree;
   YdeleteClientData userDelete;
Function:
   Removes tree and all nodes in the tree.  Uses a client data free function
   for convenience.
*/

extern INT utDrbtree_size( UTDTREEPTR tr ) ;
/*
Function:
   Find the total elements in the tree.
*/

extern INT utDrbtree_verify( UTDTREEPTR tr ) ;
/*
Function:
   Exercise tree pointers by walking through the tree.
   Useful for dubugging.
   The routine will fault or return a 0 if verification fails.
   The routine will return a 1 if verification is successful.
*/


extern VOIDPTR utDrbtree_search_closest( UTDTREEPTR tr,VOIDPTR key,UTD_SEARCH_T func ) ;
/*
Function:
   Finds the closest match for a given key.  Will return the exact
   match if it exists.  Returns NULL if no items exist in tree.
   Sets the search marker for subsequent search_suc and search_pred
   calls.  Func is used to control the meaning of closest relative
   to the comparison function.  Ithas four values:
	SEARCH_CLOSEST_NOP
	SEARCH_CLOSEST
	SEARCH_CLOSEST_BELOW
	SEARCH_CLOSEST_ABOVE
   SEARCH_CLOSEST_NOP should be specified when the comparison function
   does not give an integer measure of the distance from a perfect match.
   SEARCH_CLOSEST is the normal mode. It returns the closest element
   to the key value based on the comparison functions return value.
   SEARCH_CLOSEST_BELOW returns the element closest to the key which is 
   less than or equal to the given key.
   SEARCH_CLOSEST_ABOVE returns the element closest to the key which is 
   greater than or equal to the given key.
*/



extern VOIDPTR utDrbtree_search_closest_dist( UTDTREEPTR tree,VOIDPTR key,
                                            UTDDISTFUNC dist_func,UTD_SEARCH_T op,
					    VOIDPTR data_p ) ;
/*
Function:
   Similar to utDrbtree_search_closest except that we use a distance function.
   Returns NULL if no items exist in tree.
*/


extern VOIDPTR utDrbtree_search_closestRE( UTDTREEPTR tr,VOIDPTR key,UTD_SEARCH_T func,
                                           UTDTREEITERPTR iter_p ) ;
/*
Function:
   Reentrant version of utDrbtree_search_closest - use is something similar to
   utDrbtree_search_closestRE( tree_p, key, SEARCH_XXXX,RBTREE_FIRST(&iter) ) ;
*/

extern VOIDPTR utDrbtree_search_closest_distRE( UTDTREEPTR tree,VOIDPTR key,
                                              UTDDISTFUNC dist_func, 
					      UTD_SEARCH_T search_op,
					      VOIDPTR clientData_p,
					      UTDTREEITERPTR iter_p ) ;

extern VOIDPTR utDrbtree_search_sucRE( UTDTREEPTR tr, UTDTREEITERPTR iter_p ) ;
/*
Function:
   Reentrant version of utDrbtree_search_suc.  This routine 
   should only be called after the search marker has been set
   by one of: utDrbtree_search_closestRE, utDrbtree_minRE, utDrbtree_maxRE, or
   utDrbtree_searchRE.
*/

extern VOIDPTR utDrbtree_search_predRE( UTDTREEPTR tr, UTDTREEITERPTR iter_p ) ;
/*
Function:
   Reentrant version of utDrbtree_search_pred.
*/

extern void utDrbtree_dump( UTDTREEPTR tr, FILE *fp, void (*print_key)(FILE *,void *) ) ;
/*
Function:
   Dump the contents of a tree.  Print keys takes two arguments,
   an output file and a key.
*/

extern void utDrbtree_resort( UTDTREEPTR tr,INT (*compare_func)(void *,void *,void *),
			      void (*userDelete)(void *,void *) ) ;
/*
Function:
   Takes a tree and resorts the tree with a new comparison function.
   All search markers are reset to NIL.  In addition, we now take a
   userDelete function in the case when the tree is unique and the data
   is not by the new comparison function and we need to free the data.
*/

extern UTDTREEPTR utDrbtree_copy( UTDTREEPTR tr,INT (*compare_func)(void *,void *,void * ) );
/*
Function:
   Make a copy of a tree sorted with the given comparison function.
   Old tree remains allocated and all markers remain undisturbed.
*/

extern BOOL utDrbtree_insertIfUnique( UTDTREEPTR tr,VOIDPTR data ) ;
/*
Function:
   Only inserts data item into the tree if unique with respect to
   the comparison function.
*/

extern INT utDrbtree_poolid( UTDTREEPTR tr ) ;
/*
Function:
   Return the block memory pool id 
*/

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* RBTREE_H */
