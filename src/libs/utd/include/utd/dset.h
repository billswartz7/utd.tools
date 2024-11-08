/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    dset.h
DESCRIPTION:include file for disjoint set utility functions 
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_DSET_H
#define INCLUDED_UTD_DSET_H

#include <utd/base.h>
#include <utd/rbtree.h>
#include <utd/hash.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


typedef enum {
  UTDDSET_OPTION_NONE 	= 0,
  UTDDSET_OPTION_NOTREE 	= 1
} UTDDSET_OPTION_T ;

typedef struct utddset_el {
    VOIDPTR data ;
    INT rank ;
    union {
	INT size ;		/* size valid for TREE operations */
	INT member ;		/* member valid for EL operations */
    } op ;
    struct utddset_el *parent ;
    struct utddset_el *next_member ;/* replaces dparent hash table to save space */
} UTDDSELBOX, *UTDDSELPTR ;

typedef INT (*utDdset_pcompare)(UTDDSELPTR,UTDDSELPTR,VOIDPTR) ;

typedef struct utddsetrec {
    UTDTREEPTR dtree ;          /* rbtree holding sets */
    UTDHASHPTR dhash ;          /* hash table holding sets */
    INT (*compare_func)(void *,void *,void *) ; /* how to compare in rbtree */
    utDdset_pcompare parent_compare ; /* how to compare the parent tree */
    utDdset_pcompare subset_compare ; /* how to compare the subset tree */
    void (*user_delete)(void *);/* how to delete functions in rbtree */
    VOIDPTR clientData ;	/* client data */
    UTDTREEPTR superset_tree ;	/* tree to store the superset */
    UTDTREEPTR subset_tree ;	/* tree to store the subsets */
    UTDTREEPTR parent_tree ;	/* tree to store the parents */
    INT	     init_count ;	/* used to speed initialization */
    INT	     pool_id ;		/* memory pool */
    SHORT    parents_valid ;	/* parent hash valid */
    SHORT    no_user_tree ;	/* don't build the dtree - only hash */
} UTDDSETBOX, *UTDDSETPTR ;

typedef UTDTREEITER UTDDSETITER ;
typedef UTDTREEITERPTR UTDDSETITERPTR ;
/* -----------------------------------------------------------------
 * macro definition for enumeration.  Strange looking but compiler
 * will optimize.  x_yz->position = 0 and x_yz will be returned.
----------------------------------------------------------------- */
#define UTDDSET_FIRST(x_yz)	( ((x_yz)->position = NULL) ? (x_yz) : (x_yz) )
#define UTDDSET_ITER_EQUAL(x_yz,y_yz)	( (x_yz)->position == (y_yz)->position )


/*---------------------------------------
  utDdset_init()
  NOTE that the users comparison function will be similar to 
  comparison function used in the rbtree package.
  ---------------------------------------*/
extern UTDDSETPTR utDdset_init( INT (*compare_func)(void *,void *,void *),
			        VOIDPTR clientData ) ;
/*
Function:
    Initialize the union/find routines.  Returns back a set.
    A set of sets is implemented.  Therefore, many union find
    data structures may be used at once.  A comparison function
    must be supplied to sort the data.  The comparison function is passed
    with the last argument being the client data.
    See rbtree.h for more details about comparison functions.
*/

/*---------------------------------------
  utDdset_option()
  Set a dset option.
  ---------------------------------------*/
extern INT utDdset_option( UTDDSETPTR dset, INT option, INT value ) ;
/*
Function:
    Sets a dset set option.  Currently, we use this to set the no_user_tree
    option.
*/

/*---------------------------------------
  utDdset_empty
  Free all elements in the set but leaves the set intact
  This may be used recursively.
  ---------------------------------------*/
extern void utDdset_empty( UTDDSETPTR set,void (*userDelete)(void *) ) ;
/*
  free all elements of a superset.  Function userDelete is applied to user data.
*/

extern VOIDPTR utDdset_enumerate( UTDDSETPTR set, UTDDSETITERPTR iter_p ) ;
/*
Function:
    Enumerate all of the elements of the super set.  This is reentrant.
*/
     
/*---------------------------------------
  ---------------------------------------*/
extern VOIDPTR utDdset_enumerate_superset( UTDDSETPTR set, UTDDSETITERPTR iter_p ) ;
/*
Function:
    Enumerate all of the elements of the super set
*/

extern VOIDPTR utDdset_enumerate_parents( UTDDSETPTR dset, UTDDSETITERPTR piter_p ) ;
/*
Function:
    Enumerate the parents of the super set
*/
     
/*-----------------------------------
  utDdset_interval
  enumerate all elements in the superset within an interval.
  -----------------------------------*/
extern VOIDPTR utDdset_interval( UTDDSETPTR dset, VOIDPTR low_key,
				 VOIDPTR high_key, BOOL startFlag ) ;

/*---------------------------------------
  ---------------------------------------*/
extern VOIDPTR utDdset_enumerate_subset( UTDDSETPTR set,VOIDPTR subsetData,
				         UTDDSETITERPTR sub_iter_p) ;
/*
Function:
  Find the set which subsetData is an element of.  Enumerate all
  the elements of that set.
*/

/*---------------------------------------
utDdset_find():
Function:
    Returns subset name for the given data of the given set.  If
    data does not exist, it is created and put in set.
  ---------------------------------------*/
extern VOIDPTR utDdset_find( UTDDSETPTR dset, VOIDPTR data ) ;

/*---------------------------------------
_utDdset_find():
Function:
    Returns subset data structure for the given data of
    the given set.  If data does not exist, it is created
    and put in set.
  ---------------------------------------*/
extern UTDDSELPTR _utDdset_find( UTDDSETPTR dset, VOIDPTR data ) ;

/*-------------------------------------------------
  _utDdset_find_set()
  Searches for the set an item belongs to.
  This routine avoids makeset of the item
  which utDdset_find does by default.  Returns internal
  data structure.  This allows us to make equivalent
  tests simpler.
  -------------------------------------------------*/
extern UTDDSELPTR _utDdset_find_set( UTDDSETPTR dset, VOIDPTR data) ;

/*-------------------------------------------------
  utDdset_find_set()
  Searches for the set an item belongs to.
  This routine avoids makeset of the item
  which utDdset_find does by default
  -------------------------------------------------*/
VOIDPTR utDdset_find_set( UTDDSETPTR dset, VOIDPTR data ) ;

/*---------------------------------------
utDdset_make_parent():
Function:
    Make the data item given by the user the parent of the set in which
    it resides.
    Returns subset data structure for the given data of
    the given set.  If data does not exist, NULL is returned.
  ---------------------------------------*/
extern UTDDSELPTR utDdset_make_parent( UTDDSETPTR dset, VOIDPTR data ) ;

/*---------------------------------------
  utDdset_free
  Free all elements in the set and the set.
  This can be used recursively.
  ---------------------------------------*/
extern void utDdset_free( UTDDSETPTR set,void (*userDelete)(void *) ) ;
/*
  free the entire superset.  Function userDelete is applied to user data.
*/

/*---------------------------------------
  ---------------------------------------*/
extern VOIDPTR utDdset_union( UTDDSETPTR set, VOIDPTR x, VOIDPTR y ) ;
/*
Function:
    Perform union operation on two data items for the given set.
    If either data item does not exist, the item is created 
    and put in set.
    Returns the subset name.
*/

/*---------------------------------------
  ---------------------------------------*/
extern VOIDPTR utDdset_search( UTDDSETPTR set,VOIDPTR data ) ;
/*
    Search for an elment in the super set
*/

/*---------------------------------------
  ---------------------------------------*/
INT utDdset_subset_size( UTDDSETPTR set, VOIDPTR data ) ;
/*
    returns the size of the subset data is an element of.
*/

/*---------------------------------------
  ---------------------------------------*/
extern INT utDdset_superset_size( UTDDSETPTR set ) ;
/*
  returns the size of the entire superset
*/

/*---------------------------------------
  ---------------------------------------*/
extern INT utDdset_parent_size( UTDDSETPTR set ) ;
/*
  returns the size of the parents of a set.  This must be called
  after utDdset_enumerate_parents for it to be valid.
*/

/*
  If installed use a user function to compare the parent.  This makes
  the enumeration deterministic.  Returns the old compare function.
*/
extern utDdset_pcompare utDdset_compare_parent_func(UTDDSETPTR set,utDdset_pcompare func) ;

/*
  If installed use a user function to compare the subset.  This makes
  the enumeration deterministic.  Returns the old compare function.
*/
extern utDdset_pcompare utDdset_compare_subset_func(UTDDSETPTR set,utDdset_pcompare func) ;

/*-----------------------
  utDdset_verify
  -----------------------*/
extern INT utDdset_verify( UTDDSETPTR set ) ;

/*------------------------
  utDdset_dump
  ------------------------*/
extern void utDdset_dump( UTDDSETPTR set, FILE *fp,void (*printFunc)(FILE *,void *) ) ;
extern void utDdset_dump_tree( UTDDSETPTR dset,FILE *fp,void (*print_key)(FILE *,void *) ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_DSET_H */
