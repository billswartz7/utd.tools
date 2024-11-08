/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    hash.h
DESCRIPTION:Hash routines based on Tcl hash routines.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_HASH_H
#define INCLUDED_UTD_HASH_H

#include <utd/base.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */


typedef struct utd_hash_entry_rec  {
    VOIDPTR data ;
    struct utd_hash_entry_rec *next ;		/* collision list */
    struct utd_hash_entry_rec *thread_next ;    /* thread thru entire table */
    struct utd_hash_entry_rec *thread_prev ;    /* thread thru entire table */
    union {			/* Key has one of these forms: */
        void *generic ;		/* generic key item */
	char *simple_string ;	/* One-word value for key. */
    } key ;			
} UTDHASH_ENTRY, *UTDHASH_ENTRYPTR ;


typedef struct utd_hash_rec {
    UTDHASH_ENTRYPTR *hash_table ;	/* array of hash entries */
    UTDHASH_ENTRYPTR thread ;	/* thread of hash table */
    UTDHASH_ENTRYPTR last_entry ;	/* last entry into hash table */
    utDcompareClientData compare_func ;	/* the comparison function */
    void *clientData ;		/* client data that can be used in comparison func */
    UINT32 (*hash_func)(struct utd_hash_rec *,void *,void *) ; /* the hash function */
    INT p_tablesize ;		/* the size of the table */
    INT p_max_density ;		/* maximum number of entries before growth */
    INT p_num_entries ;		/* current number of entries in table */
    INT p_need_resize ;		/* amount before we need a resize */
    FLOAT p_growth_factor ;	/* how much to grow table by */
    INT pool_id ;		/* memory pool id */
    UNSIGNED_INT power_of_two : 8 ; /* build table as a power of two */
    UNSIGNED_INT call_from_free : 8 ;/* true if in a free calling sequence */
    UNSIGNED_INT unique : 8 ;	/* true if only one unique item in col. list */
    UNSIGNED_INT caller_alloced_keys : 8 ;/* true if the user allocated the keys */
    LONG p_access ;		/* number of accesses */
    LONG p_collisions ;		/* number of collisions */
} UTDHASHBOX, *UTDHASHPTR ;

typedef UINT32 (*utDhash_func)(UTDHASHPTR,void *,void *) ;

typedef struct utd_hash_iter_rec {
  struct utd_hash_entry_rec *position ;
} UTDHASHITER, *UTDHASHITERPTR ;


typedef enum {
  UTD_HASH_FUNC_NUM		= -2L,
  UTD_HASH_FUNC_PTR		= -1L,
  UTD_HASH_FUNC_STR 		=  0L,
  UTD_HASH_UNIQUE 		= (1L),
  UTD_HASH_POWER_OF_TWO 	= (1L<<1),
  UTD_HASH_CALLER_ALLOCS_KEY	= (1L<<2)
} UTDHASHFLAGS_T ;


#define UTD_HASH_NONUNIQUE	UTD_HASH_FUNC_STR	/* just 0 */

/* -----------------------------------------------------------------
 * macro definition for enumeration.  Strange looking but compiler
 * will optimize.  x_yz->position = 0 and x_yz will be returned.
----------------------------------------------------------------- */
#define UTDHASH_FIRST(x_yz)	( ((x_yz)->position = NULL) ? (x_yz) : (x_yz) )
#define UTDHASH_ITER_EQUAL(x_yz,y_yz)	( (x_yz)->position == (y_yz)->position )

#define UTD_HASH_DEF_HASH_STR	((utDhash_func) VOIDPTR_TYPE(UTD_HASH_FUNC_STR))
#define UTD_HASH_DEF_HASH_PTR	((utDhash_func) VOIDPTR_TYPE(UTD_HASH_FUNC_PTR))
#define UTD_HASH_DEF_HASH_NUM	((utDhash_func) VOIDPTR_TYPE(UTD_HASH_FUNC_NUM))

/* the default comparison functions */
#define UTD_HASH_DEF_CMP_STR	((utDcompareClientData) VOIDPTR_TYPE(UTD_HASH_FUNC_STR))
#define UTD_HASH_DEF_CMP_PTR	((utDcompareClientData) VOIDPTR_TYPE(UTD_HASH_FUNC_PTR))
#define UTD_HASH_DEF_CMP_NUM	((utDcompareClientData) VOIDPTR_TYPE(UTD_HASH_FUNC_PTR))

/* defines for unique flag */

/* misc definitions */
#define UTD_HASH_DEF_GROW_FACTOR	2.0
#define UTD_HASH_DEF_MAX_DENSITY	4
#define UTD_HASH_MIN_SIZE		4

#define UTDHASH_GETDATA(x_xz,t_xz) 	((t_xz) (x_xz)->data)
#define UTDHASH_GETSTRING_KEY(x_xz) 	((x_xz)->key.simple_string)
#define UTDHASH_GETKEY(x_xz,t_xz) 	((t_xz) (x_xz)->key.generic)

/* -----------------------------------------------------------------
 * Here are three hash functions in order of increasingly better
 * behaviour. Remember hsum must be UNSIGNED_INT.  The best one
 * is taken from tcl.
----------------------------------------------------------------- */

#define UTDHASH_STR_TO_HASH( str, hsum, size ) \
    do { 	\
	char *name ; \
	INT shift ;	\
	for( name=str,shift=1,hsum=0 ;*name; name++){  \
	    hsum = hsum + ((*name)<<shift);                \
	    shift = (shift + 1) & 0x0007;              \
	}  \
	hsum %= (size) ; \
    } while(0);

#undef UTDHASH_STR_TO_HASH
#define UTDHASH_STR_TO_HASH( str, hsum, size ) \
    do { 	\
      char *name ; \
      UNSIGNED_LONG g ; \
      for( name=str,hsum=0 ;*name; name++){  \
	hsum = (hsum << 4) + (*name); \
	g = hsum & 0xF0000000 ; \
	if (g) { \
	  hsum = hsum^(g >> 24); \
	  hsum = hsum^g; \
	} \
      } \
      hsum = hsum & (size-1); \
    } while(0);

#undef UTDHASH_STR_TO_HASH
#define UTDHASH_STR_TO_HASH( str, hsum, size ) \
    do { 	\
	INT c ; \
	char *string ; \
	hsum = 0 ; \
	string = (char *) str ; \
	while(1) { \
	  c = *string ; \
	  string++ ; \
	  if( c == 0) { \
	    break ; \
	  } \
	  hsum += (hsum<<3) + c; \
	}  \
	hsum %= (size) ; \
    } while(0);

#define UTDHASH_NUM_TO_HASH( num, hsum, size ) \
    do { 	\
	INT c, len ; \
	UNSIGNED_LONG temp; \
	char cptr[80] ; \
	sprintf( cptr, "%lx", (UNSIGNED_LONG) num) ; \
	len = strlen(cptr) ; \
	temp = (UNSIGNED_LONG) cptr[0] ; \
	for( c = 1 ; c < len ; c++ ){ \
	  temp += (temp<<3) + (UNSIGNED_LONG) cptr[c] ; \
	} \
	temp %= (size) ; \
	hsum = temp ; \
    } while(0);

#undef UTDHASH_NUM_TO_HASH

/* -----------------------------------------------------------------
 * Replace the old num to hash with a new algorithm which is simple
 * and is 5 times faster.  Variance was even less on generated data.
 * To use this hash table power of 2 table size must be enforced.
----------------------------------------------------------------- */
#define UTDHASH_NUM_TO_HASH( ptr, hsum, size ) \
    do { 	\
      UNSIGNED_INT temp ; \
      LONG value = (LONG) ptr ; \
      temp = value ; \
      hsum = temp & (size - 1) ; \
    } while(0);


#define UTDHASH_PTR_TO_HASH( ptr, hsum, size ) \
    do { 	\
	UNSIGNED_LONG temp; \
	temp = (UNSIGNED_LONG) (ptr); \
	temp %= (size) ; \
	hsum = temp ; \
    } while(0);

#undef UTDHASH_PTR_TO_HASH
/* -----------------------------------------------------------------
 * We use strlen instead of looking at the return value of sprintf
 * because it is not standard. Actually no machine have 80 byte pointers
 * but just being cautious.
----------------------------------------------------------------- */

#define UTDHASH_PTR_TO_HASH( ptr, hsum, size ) \
    do { 	\
	INT c, len ; \
	UNSIGNED_LONG temp; \
	char cptr[80] ; \
	sprintf( cptr, "%lx", (UNSIGNED_LONG) ptr) ; \
	len = strlen(cptr) ; \
	temp = (UNSIGNED_LONG) cptr[0] ; \
	for( c = 1 ; c < len ; c++ ){ \
	  temp += (temp<<3) + (UNSIGNED_LONG) cptr[c] ; \
	} \
	temp %= (size) ; \
	hsum = temp ; \
    } while(0);

#undef UTDHASH_PTR_TO_HASH
/* -----------------------------------------------------------------
 * Replace the old ptr to hash with a new algorithm which is simple
 * and is 5 times faster.  Variance was even less on generated data.
 * To use this hash table power of 2 table size must be enforced.
----------------------------------------------------------------- */
#define UTDHASH_PTR_TO_HASH( ptr, hsum, size ) \
    do { 	\
      UNSIGNED_INT temp ; \
      LONG value = (LONG) ptr ; \
      temp = value >> 4 ; \
      hsum = temp & (size - 1) ; \
    } while(0);

#define UTDHASH_PTR_COMPARE_FUNC( p1 , p2 ) ( (p1) != (p2) )


#define utDhash_unique( htable_xz, flag_xz )	((htable_xz)->unique = flag_xz)
#define utDhash_caller_allocs_keys( htable_xz, flag_xz )	((htable_xz)->caller_alloced_keys = flag_xz)

extern UTDHASHPTR utDhash_init( INT numentries ) ;
/*
Function:
    Returns a hash table with the given number of entries.
    More that one hash table can coexist at the same time.
    The default key type is string. The default comparison function
    is strcmp.
*/

extern UTDHASHPTR utDhash_init_integer( INT numentries ) ;
/*
Function:
    Returns a hash table with the given number of entries.
    More that one hash table can coexist at the same time.
    The default key type is an integer. The default comparison function
    is integer comparison.
*/

extern UTDHASHPTR utDhash_init_pointer( INT numentries ) ;
/*
Function:
    Returns a hash table with the given number of entries.
    More that one hash table can coexist at the same time.
    The default key type is a pointer. The default comparison function
    is pointer comparison.
*/

extern UTDHASHPTR utDhash_init_with_parms( utDcompareClientData compare_func,
    utDhash_func hash_func, void *clientData, INT numentries, INT max_density, 
    DOUBLE growth, UTDHASHFLAGS_T flags ) ;
/*
Function:
    Returns a hash table with the given number of entries.
    More that one hash table can coexist at the same time.
    Tables may be given their own hash and compare functions.  If your keys
    are pointers, numbers or strings, it is recommended that you use the
    functions:
	* HASH_DEF_HASH_PTR and HASH_DEF_CMP_PTR for pointers,
	* HASH_DEF_HASH_NUM and HASH_DEF_CMP_NUM for numbers, and
	* HASH_DEF_HASH_STR and HASH_DEF_CMP_STR for strings.
    The hash package will recognize these and run faster as a result.

    You may use your own hash and compare functions provided they look like
    * INT hash(UTD_HASHPTR table,VOIDPTR key,VOIDPTR clientData) and
    * UNSIGNED_INT compare(VOIDPTR key1, VOIDPTR key2,VOIDPTR clientData). 
    The hash function's return value should be in the interval [0, UINT_MAX].
    The compare should return zero if the two keys are equal and a non-zero
    value otherwise.  The clientData is present for both the hash and
    comparison functions.

    Whenever
	number of entries in hash table >= size of table * max_density,
    the table is grown at a the specified by growth.  Unique if TRUE only allows
    one entry which matches comparison function.  Otherwise, multiple items
    which are not unique relative to the comparison function can exist in
    collision list.
*/

extern INT utDhash_max_density(UTDHASHPTR hashtable,INT max_density) ;
/*
Function:
    Changes the max_density limit in the hash table if max_density > 1.  
    This function returns the current value of max_density. 
*/

extern INT utDhash_tablesize( UTDHASHPTR  hashtable ) ;
/*
Function:
    Returns the current table size of hash table set by utDhash_table_create 
*/

extern INT utDhash_size( UTDHASHPTR  hashtable ) ;
/*
Function:
    Returns the current number of entries in the hash table 
*/

extern INT utDhash_table_bestsize( INT num ) ;
/*
Function:
    Returns the closest prime number to given size.
*/

extern INT utDhash_table_bestsize2( INT num ) ;
/*
Function:
    Returns the table size to the closest power of 2.
*/

extern UTDHASH_ENTRYPTR utDhash_find(UTDHASHPTR hashtable, VOIDPTR user_key) ;
extern UTDHASH_ENTRYPTR utDhash_find_again(UTDHASHPTR hashtable,UTDHASH_ENTRYPTR search_p) ;
extern UTDHASH_ENTRYPTR utDhash_insert(UTDHASHPTR hashtable, VOIDPTR user_key, VOIDPTR data) ;

extern UTDHASH_ENTRYPTR utDhash_find_item(UTDHASHPTR hashtable, VOIDPTR user_key,
                                          VOIDPTR data ) ;
/*
The four functions above replace the old utDhash_search function.  The same
functionality but now four functions.
Function:
    Hash table search routine.  Given a hashtable and a key, perform
    the following operations:
	HASH_ENTER:if key is in table it, returns a pointer to the item.
	      if key is not in table, add it to the table. returns NULL.
	HASH_FIND:if key is in table, it returns data pointer.
	      if key is not in the table, it returns NULL.
	HASH_FIND_AGAIN:if additional keys are in table, returns data pointer.
	      if no more keys are in the table, it returns NULL.
	HASH_DELETE:if key is in table, it returns -1
	       if key is not in table, it return NULL.
	Memory is not freed in the delete case, but marked dirty.
    Data is a pointer to the information to be store with the given key.
    A new operation is available for using pointers are arguments.
    Just pass the pointer in as a key.  Make sure to call the
    utDhash_init_pointer function first.
*/

/* -----------------------------------------------------------------
 * Convenience functions.
----------------------------------------------------------------- */
typedef VOIDPTR (*utDhash)(void *) ;

extern UTDHASH_ENTRYPTR utDhash_add( UTDHASHPTR  hashtable, VOIDPTR key,
	utDhash add_function, VOIDPTR add_arg, BOOL *new_flag ) ;
/*
Function:
    Hash table search convenience routine. It avoids two calls to hash_search
    in the case of always adding to the table if the item does not exist.
    Hash_add adds to table if it doesn't already exist - new flag
    will be set to true.  If key already exists in table then
    hash add will not add it to the hash table but will notify the
    user by setting new flag to false.  The add_function is used
    to associate the information with the key. The add_function is always
    called with the argument add_arg. It should return a
    pointer to the memory where the information is stored.  This 
    function always returns a pointer to the data.  The key may be
    a pointer if utDhash_pointer was called previously.
*/

extern void utDhash_free(UTDHASHPTR htabl,void (*del_data)(void *),void (*del_key)(void *) ) ;
/*
Function:
    Frees the memory associated with a hash table. The user make supply a
    function which deletes the memory associated with the data field. 
    In addition, the user may free the memory stored at the key.
    This function must have the data pointer supplied by the hash add routines
    as an argument,ie.
    utDhash_table_delete( my_hash_table, my_free_func, my_key_free ) ;
    my_free_func( data )
    VOIDPTR data ;
    {
    }
    my_key_free( key )
    VOIDPTR key ;
    {
    }
    Note: for the default hash types: STR, PTR, and NUM, the free key
    operation is ignored.
*/

extern void utDhash_free_string_func(char *str) ;
/*
Function:
    Just a wrapper for UTDFREE(string)
*/

extern void utDhash_free_string_hashtable(UTDHASHPTR htable) ;
/*
Function:
    Frees the memory associated with a hash table. This version is
    a convenience function as it is equivalent to the function:
    utDhash_free( htable, (Ydelete) utDhash_free_string_func, NULL ) ;
*/

extern void utDhash_empty(UTDHASHPTR htabl,void (*del_data)(void *),void (*del_key)(void *) ) ;
/*
Function:
    Similar to utDhash_free except table structure is not delete. However,
    all entries have been deleted.
*/

extern UTDHASHPTR utDhash_merge( UTDHASHPTR master_htable, UTDHASHPTR merge_htable ) ;
/*
Function:
    Merge items in merge_htable into master_htable.  Create master_htable
    if master_htable is NULL.  Returns the merged hash table.
*/


extern UTDHASH_ENTRYPTR utDhash_enumerate(UTDHASHPTR hashtable,UTDHASHITERPTR iter_p) ;
/*
Function:

    Since this is a threaded hash table, we can enumerate the elements of
    the hash table in O(n) time where n is the number of valid entries. 
    Returns the data and key associated with each entry. 
    utDhash_enumerate is a reentrant version.   Use as
    for( i_p = utDhash_enumerate(htable_p,UTDHASH_FIRST(&iter) ) ; i_p ;
         i_p= utDhash_enumerate(htable_p,&iter) ) ){
      data_p = UTDHASH_GETDATA(i_p) ;
   }
*/

extern BOOL utDhash_delete(UTDHASHPTR hashtable, VOIDPTR user_key) ;
/*
Function:
    Delete a specific item in the hash table matching the key.  
    Returns true if an item was found and deleted.  Deletes first key that
    matches.  
*/

extern BOOL utDhash_deleteItem( UTDHASHPTR  hashtable, VOIDPTR key, VOIDPTR data ) ;
/*
Function:
    Delete a specific item in the hash table.  Key and data must match.
    Returns true if the item was found and deleted.
*/

extern void utDhash_dump( UTDHASHPTR hashtable,void (*print_func)(void *) ) ;
/*
Function:
    Prints the contents of the hash table.
*/

extern void utDhash_reset_stat( UTDHASHPTR hashtable ) ;
extern void utDhash_resize( UTDHASHPTR hashtable, INT num ) ;

extern void utDhash_distribution( UTDHASHPTR hashtable ) ;
/*
Function:
    Returns information about hash table distribution to message system.
*/

extern INT utDhash_access( UTDHASHPTR hashtable ) ;
/*
Function:
    Returns information about number of times hash table was accessed.
*/

extern INT utDhash_collisions( UTDHASHPTR hashtable ) ;
/*
Function:
    Returns information about number of times a collision happened in the
    hash table.
*/

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_HASH_H */
