/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    hash.c                                       
DESCRIPTION:This file contains the routines for building and 
	    maintaining a hash table.
	    Abstract : Contains routines for managing hash tables.  Tables
	    may be given their own hash and compare functions.  If your keys
	    are pointers, numbers or strings, it is recommended that you
	    use the functions
	    * HASH_DEF_HASH_PTR and HASH_DEF_CMP_PTR for pointers,
	    * HASH_DEF_HASH_NUM and HASH_DEF_CMP_NUM for numbers, and
	    * HASH_DEF_HASH_STR and HASH_DEF_CMP_STR for strings.
	    The hash package will recognize these and run faster as
	    a result.

	    You may use your own hash and compare functions provided they
	    look like
	    * INT hash(VOIDPTR key) and
	    * INT compare(VOIDPTR key1, VOIDPTR key2).
	    The hash function's return value should be in the interval
	    [0, UINT_MAX].  The compare should return zero if the two
	    keys are equal and a non-zero value otherwise.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
/* The order is important */
#include <utdconfig.h>

#include <stdio.h>
#include <utd/base.h>
#include <utd/hash.h>
#include <utd/debug.h>
#include <utd/string.h>
#include <utd/mempools.h>

/* definitions local to this file only */

/* ********************** TYPE DEFINITIONS ************************* */
#define  PRIMECOUNT   200
#define  MINPRIMESIZE 7

/* ********************** STATIC DEFINITIONS ************************* */


UTDHASHPTR utDhash_init_with_parms(utDcompareClientData comp_func, utDhash_func hash_func, 
				   void *clientData, INT num,
                                   INT max, DOUBLE growth,UTDHASHFLAGS_T flags)
{
    BOOL unique ;			/* entries are to be unique */
    BOOL power_of_two ;			/* want hash table power of 2 */
    BOOL caller_alloced_keys ;		/* caller has allocated key memory */
    UTDHASHPTR  hashtable ;

    unique = flags & UTD_HASH_UNIQUE ;
    power_of_two = flags & UTD_HASH_POWER_OF_TWO ;
    caller_alloced_keys = flags & UTD_HASH_CALLER_ALLOCS_KEY ;

    hashtable = UTDMALLOC( 1, UTDHASHBOX ) ;
    if( power_of_two ){
      hashtable->p_tablesize = utDhash_table_bestsize2( num ) ;
    } else {
      /* prime size */
      hashtable->p_tablesize = utDhash_table_bestsize( num ) ;
    }
    hashtable->compare_func = comp_func ;
    hashtable->hash_func = hash_func ;
    hashtable->clientData = clientData ;

    hashtable->hash_table = UTDCALLOC( hashtable->p_tablesize, UTDHASH_ENTRYPTR ) ;
    hashtable->p_max_density = max ;
    hashtable->p_need_resize = hashtable->p_tablesize * hashtable->p_max_density ;
    hashtable->p_growth_factor = growth ;
    hashtable->unique = unique ;
    hashtable->power_of_two = power_of_two ;
    hashtable->caller_alloced_keys = caller_alloced_keys ;
    hashtable->thread = NULL ; /* initialize list */
    hashtable->last_entry = NULL ; /* end of list */
    hashtable->p_num_entries = 0 ;
    hashtable->call_from_free = FALSE ;
    hashtable->pool_id = UTDPOOL_INIT( num / 2, UTDHASH_ENTRY) ;
    hashtable->p_access = 0;
    hashtable->p_collisions = 0;
    return(hashtable) ;
} /* end utDhash_init_with_parms() */


void utDhash_resize(UTDHASHPTR hashtable, INT num)
{
  UTDHASH_ENTRYPTR *oldtable, hptr, zapptr ;
  UTDHASH_ENTRYPTR new_hptr ;				/* new hash table entry */
  INT i, oldsize, oldpool ;

  oldsize = hashtable->p_tablesize ;
  oldtable = hashtable->hash_table;
  oldpool = hashtable->pool_id;

  hashtable->pool_id = UTDPOOL_INIT( num / 2, UTDHASH_ENTRY) ;
  if( hashtable->power_of_two ){
    hashtable->p_tablesize = utDhash_table_bestsize2( num - 1 ) ;
  } else {
    hashtable->p_tablesize = utDhash_table_bestsize( num ) ;
  }
  hashtable->p_num_entries = 0 ;
  hashtable->thread = NULL ;
  hashtable->last_entry = NULL ; /* end of list */
  hashtable->p_need_resize = hashtable->p_tablesize * hashtable->p_max_density ;

  hashtable->hash_table = UTDCALLOC( hashtable->p_tablesize, UTDHASH_ENTRYPTR);
  for( i = 0 ; i < oldsize ; i++ ) {
    for( hptr = oldtable[i]; hptr; ) {
      zapptr = hptr ;
      utDhash_insert( hashtable, hptr->key.generic, hptr->data ) ;
      /* Now safe to free */
      if( (hashtable->hash_func == UTD_HASH_DEF_HASH_STR) &&
	  !(hashtable->caller_alloced_keys) ){
	UTDFREE( hptr->key.simple_string) ;
      } 
      hptr = hptr->next ;
      if( oldpool < 0 || ! hashtable->call_from_free ) {
	UTDPOOL_FREE_ITEM( oldpool, zapptr ) ;
      }
    }
  }

  UTDPOOL_FREE_POOL(oldpool);
  UTDFREE( oldtable );
} /* end utDhash_resize() */


void utDhash_reset_stat(UTDHASHPTR hashtable)
{
  hashtable->p_collisions = 0 ;
  hashtable->p_access = 0 ;
} /* end utDhash_reset_stat() */



UTDHASHPTR utDhash_init_pointer(INT num_entries)
{
    return( utDhash_init_with_parms( UTD_HASH_DEF_CMP_PTR, UTD_HASH_DEF_HASH_PTR,NULL,
				     num_entries, UTD_HASH_DEF_MAX_DENSITY,
				     UTD_HASH_DEF_GROW_FACTOR, 
				     UTD_HASH_UNIQUE|UTD_HASH_POWER_OF_TWO) ) ;
} /* end utDhash_init_pointer() */

UTDHASHPTR utDhash_init_integer(INT num_entries)
{
    return( utDhash_init_with_parms( UTD_HASH_DEF_CMP_NUM, UTD_HASH_DEF_HASH_NUM,NULL,
				   num_entries, UTD_HASH_DEF_MAX_DENSITY,
				   UTD_HASH_DEF_GROW_FACTOR,
				   UTD_HASH_UNIQUE|UTD_HASH_POWER_OF_TWO) ) ;
} /* end utDhash_init_integer() */

UTDHASHPTR utDhash_init(INT num_entries)
{
    return( utDhash_init_with_parms( UTD_HASH_DEF_CMP_STR, 
	                             UTD_HASH_DEF_HASH_STR,
				     NULL,
				     num_entries, 
				     UTD_HASH_DEF_MAX_DENSITY,
				     UTD_HASH_DEF_GROW_FACTOR, 
				     UTD_HASH_UNIQUE) ) ;
} /* end utDhash_init() */


INT utDhash_tablesize(UTDHASHPTR hashtable)
{
    if( hashtable ){
      return(hashtable->p_tablesize) ;
    } else {
      return(0) ;
    }
} /* end utDhash_tablesize() */

INT utDhash_size(UTDHASHPTR hashtable)
{
    if( hashtable ){
      return(hashtable->p_num_entries) ;
    } else {
      return(0) ;
    }
} /* end utDhash_size() */


INT utDhash_max_density(UTDHASHPTR hashtable,INT max_density)
{
    if( max_density > 0 ){
      hashtable->p_max_density = max_density ;
      hashtable->p_need_resize = hashtable->p_tablesize * hashtable->p_max_density ;
    }
    return(hashtable->p_max_density) ;
}

void utDhash_empty(UTDHASHPTR hashtable, void (*delete_data) (void *), 
  void (*delete_key) (void *))
{
    LONG old_size ;			/* old size of hash table */
    LONG new_size ;			/* new size of hash table */
    UTDHASH_ENTRYPTR *table, hptr , zapptr ;

    utDhash_reset_stat(hashtable);

    old_size = MAX( UTD_HASH_MIN_SIZE, hashtable->p_num_entries ) ;
    if( hashtable->power_of_two ){
      new_size = utDhash_table_bestsize2( old_size ) ;
    } else {
      /* prime size */
      new_size = utDhash_table_bestsize( old_size ) ;
    }

    table = hashtable->hash_table ;
    if( table ){
      if( (hashtable->pool_id < 0) || (delete_data) || 
          (hashtable->hash_func == UTD_HASH_DEF_HASH_STR) ||
	  (delete_key) ){
	for( hptr = hashtable->thread ; hptr ; ){
	  zapptr = hptr ;
	  hptr = hptr->thread_next ;

	  /* execute user define delete function if requested */
	  if( delete_data ){
	      (*delete_data)(zapptr->data) ;
	  }
	  if( hashtable->hash_func == UTD_HASH_DEF_HASH_STR ) {
	    if(!(hashtable->caller_alloced_keys)){
	      /* we allocated this ourselves we can delete it */
	      UTDFREE( zapptr->key.simple_string ) ;
	    }
	  } else if( delete_key ){
	      (*delete_key)(zapptr->key.generic) ;
	  }
	  if( hashtable->pool_id < 0 ) {
	    UTDPOOL_FREE_ITEM( hashtable->pool_id, zapptr ) ;
	  }
	}
	if( hashtable->pool_id > 0 && !(hashtable->call_from_free)){
	  UTDPOOL_FREE_POOL(hashtable->pool_id);
	  hashtable->pool_id = UTDPOOL_INIT(new_size,UTDHASH_ENTRY) ;
	}
	memset( (char *)table, 0, (size_t) hashtable->p_tablesize*sizeof(UTDHASH_ENTRYPTR)) ;
      } else {
	memset( (char *)table, 0, (size_t) hashtable->p_tablesize*sizeof(UTDHASH_ENTRYPTR)) ;
	if(!(hashtable->call_from_free)){
	  UTDPOOL_FREE_POOL(hashtable->pool_id);
	  hashtable->pool_id = UTDPOOL_INIT(new_size,UTDHASH_ENTRY) ;
	}
      }
    }
    /* free decks associated with tree if they exist */
    hashtable->thread = NULL ; /* initialize list */
    hashtable->last_entry = NULL ; /* initialize list */
    hashtable->p_num_entries = 0 ;
} /* end utDhash_empty() */


void utDhash_free(UTDHASHPTR hashtable, void (*delete_data) (void *), 
  void (*delete_key) (void *))
{
    hashtable->call_from_free = TRUE;
    utDhash_empty(hashtable, delete_data, delete_key ) ;
    hashtable->call_from_free = FALSE ;
    UTDPOOL_FREE_POOL(hashtable->pool_id);
    UTDFREE( hashtable->hash_table ) ;
    UTDFREE( hashtable ) ;
} /* end utDhash_free() */

void utDhash_free_string_func( char *str )
{
    UTDFREE( str ) ;
} /* end utDhash_free_string_func() */

void utDhash_free_string_hashtable(UTDHASHPTR hashtable)
{
    hashtable->call_from_free = TRUE;
    utDhash_empty(hashtable, (utDdelete) utDhash_free_string_func, NULL ) ;
    hashtable->call_from_free = FALSE ;
    UTDPOOL_FREE_POOL(hashtable->pool_id);
    UTDFREE( hashtable->hash_table ) ;
    UTDFREE( hashtable ) ;
} /* end utDhash_free_string_hashtable() */

/* -----------------------------------------------------------------
 * Calculate the hash variable.  It is 0...tablesize-1.
 * ----------------------------------------------------------------- */
static UNSIGNED_INT hash_exec_hash_func(UTDHASHPTR hashtable, VOIDPTR user_key, 
                                        utDhash_func hash_func )
{
  UNSIGNED_INT hsum ;		/* hash index into the hash table */
  LONG hfunc ;			/* cast it to a number */
  /* -----------------------------------------------------------------
   * Process the hash function.
  ----------------------------------------------------------------- */
  hfunc = (LONG) hash_func ;
  switch( hfunc ){
    case UTD_HASH_FUNC_STR:
      UTDHASH_STR_TO_HASH( user_key, hsum, hashtable->p_tablesize);
      break ;
    case UTD_HASH_FUNC_PTR:
      UTDHASH_PTR_TO_HASH( user_key, hsum, hashtable->p_tablesize);
      break ;
    case UTD_HASH_FUNC_NUM:
      UTDHASH_NUM_TO_HASH( user_key, hsum, hashtable->p_tablesize);
      break ;
    default:
      hsum = (*hashtable->hash_func)(hashtable,user_key,hashtable->clientData) ;
  }
  return( hsum ) ;
} /* end hash_exec_hash_func() */

/* -----------------------------------------------------------------
 * Now utDhash_search is broken into four routines: utDhash_find,
 * utDhash_find_again, utDhash_delete, and utDhash_insert.
----------------------------------------------------------------- */
UTDHASH_ENTRYPTR utDhash_find(UTDHASHPTR hashtable, VOIDPTR user_key)
{
    INT  ret_code ;
    LONG hfunc ;
    UNSIGNED_INT hsum ;
    utDcompareClientData compare_func ;
    UTDHASH_ENTRYPTR curPtr ;
    UTDHASH_ENTRYPTR *table ;

    /* initialization */
    table = hashtable->hash_table ;
    DS(hashtable->p_access++;) ;

    /* -----------------------------------------------------------------
     * Process the hash function.
    ----------------------------------------------------------------- */
    hsum = hash_exec_hash_func( hashtable, user_key, hashtable->hash_func ) ;

    curPtr = table[hsum] ;
    if( curPtr ){
      /* list started at this hash */
      for( ; curPtr ; curPtr=curPtr->next ) {
	if( hashtable->compare_func == UTD_HASH_DEF_CMP_STR ) {
	  ret_code = strcmp(curPtr->key.simple_string, user_key ) ;
	} else if ( hashtable->compare_func == UTD_HASH_DEF_CMP_PTR||
		   hashtable->compare_func == UTD_HASH_DEF_CMP_NUM ){
	  ret_code = UTDHASH_PTR_COMPARE_FUNC( curPtr->key.generic, user_key );
	} else {
	  compare_func = hashtable->compare_func ;
	  ret_code = (*compare_func)(curPtr->key.generic, user_key, hashtable->clientData ) ;
	}
	if( ret_code == STRINGEQ ){
	  /* ----------------------------------------------------
	   * Operation find or enter with unique items, we
	   * return item.  On a nonunique enter, add item below.
	  ------------------------------------------------------- */
	  return( curPtr ) ;
	}
      }
    }
    /* cant find anything on a find operation */
    return( NULL ) ;

} /* end utDhash_find() */


UTDHASH_ENTRYPTR utDhash_find_again(UTDHASHPTR hashtable, UTDHASH_ENTRYPTR search_p )
{
    INT  ret_code ;		/* comparison return code */
    UTDHASH_ENTRYPTR curPtr ;	/* current hashtable entry */
    utDcompareClientData compare_func ;	/* user defined comparison function */

    /* initialization */
    DS(hashtable->p_access++;) ;

    if( search_p ){
      for(curPtr = search_p->next; curPtr ; curPtr = curPtr->next ) {
	if( hashtable->compare_func == UTD_HASH_DEF_CMP_STR ) {
	  ret_code = strcmp(curPtr->key.simple_string, search_p->key.simple_string ) ;
	} else if ( hashtable->compare_func == UTD_HASH_DEF_CMP_PTR||
		     hashtable->compare_func == UTD_HASH_DEF_CMP_NUM ){
	  ret_code = UTDHASH_PTR_COMPARE_FUNC( curPtr->key.generic, search_p->key.generic );
	} else {
	  compare_func = hashtable->compare_func ;
	  ret_code = (*compare_func)(curPtr->key.generic, search_p->key.generic, hashtable->clientData ) ;
	}
	if( ret_code == STRINGEQ ){
	  return( curPtr ) ;
	}
      }
    }
    return(NULL) ;
} /* end utDhash_find_again() */



BOOL utDhash_delete(UTDHASHPTR hashtable, VOIDPTR user_key)
{
    INT  ret_code ;
    LONG hfunc ;
    UNSIGNED_INT hsum ;
    VOIDPTR user_data_p ;
    utDcompareClientData compare_func ;
    UTDHASH_ENTRYPTR curPtr, *prevPtr ;
    UTDHASH_ENTRYPTR *table ;

    /* initialization */
    table = hashtable->hash_table ;
    DS(hashtable->p_access++;) ;

    /* -----------------------------------------------------------------
     * Process the hash function.
    ----------------------------------------------------------------- */
    hsum = hash_exec_hash_func( hashtable, user_key, hashtable->hash_func ) ;

    /* insert into table only if distinct number */
    curPtr = table[hsum] ;
    if( curPtr ){
      /* list started at this hash */
      prevPtr = table + hsum ;
      for( ; curPtr ; prevPtr = &(curPtr->next), curPtr=curPtr->next ) {
	if( hashtable->compare_func == UTD_HASH_DEF_CMP_STR ) {
	  ret_code = strcmp(curPtr->key.simple_string, (char *) user_key ) ;
	} else if ( hashtable->compare_func == UTD_HASH_DEF_CMP_PTR ||
		   hashtable->compare_func == UTD_HASH_DEF_CMP_NUM ){
	  ret_code = UTDHASH_PTR_COMPARE_FUNC( curPtr->key.generic, user_key );
	} else {
	  compare_func = hashtable->compare_func ;
	  ret_code = (*compare_func)(curPtr->key.generic, user_key, hashtable->clientData ) ;
	}
	if( ret_code == STRINGEQ ){
	  if( curPtr->thread_prev ){ /* no sentinel */
	    curPtr->thread_prev->thread_next = curPtr->thread_next;
	  } else {
	    hashtable->thread = curPtr->thread_next ;
	  }
	  if( curPtr->thread_next ){ /* no sentinel */
	    curPtr->thread_next->thread_prev = curPtr->thread_prev ;
	  } else {
	    hashtable->last_entry = curPtr->thread_prev ;
	  }
	  *prevPtr = curPtr->next ;
	  if( hashtable->hash_func == UTD_HASH_DEF_HASH_STR ) {
	    if(!(hashtable->caller_alloced_keys)){
	      /* we allocated this ourselves we can delete it */
	      UTDFREE( curPtr->key.simple_string ) ;
	    }
	  }		  
	  user_data_p = curPtr->data ;
	  UTDPOOL_FREE_ITEM(hashtable->pool_id, curPtr);
	  hashtable->p_num_entries-- ;
	  return( TRUE ) ;
	}
      }
    }
    return( FALSE ) ; /* didn't find anything to delete */

} /* end utDhash_delete() */

UTDHASH_ENTRYPTR utDhash_insert(UTDHASHPTR hashtable, VOIDPTR user_key, VOIDPTR data)
{
    INT  ret_code ;
    LONG hfunc ;
    UNSIGNED_INT hsum ;
    utDcompareClientData compare_func ;
    UTDHASH_ENTRYPTR curPtr, temptr, curTable ;
    UTDHASH_ENTRYPTR *table ;

    /* initialization */
    table = hashtable->hash_table ;
    DS(hashtable->p_access++;)

    /* -----------------------------------------------------------------
     * Process the hash function.
    ----------------------------------------------------------------- */
    hsum = hash_exec_hash_func( hashtable, user_key, hashtable->hash_func ) ;

    /* insert into table only if distinct number */
    temptr = table[hsum] ;
    if( temptr ){
      /* list started at this hash */
      for( curPtr = temptr ; curPtr ; curPtr=curPtr->next ) {
	DS(hashtable->p_collisions++;) ;
	if( hashtable->compare_func == UTD_HASH_DEF_CMP_STR ) {
	  ret_code = strcmp(curPtr->key.simple_string, (char *)user_key ) ;
	} else if ( hashtable->compare_func == UTD_HASH_DEF_CMP_PTR ||
		   hashtable->compare_func == UTD_HASH_DEF_CMP_NUM ){
	  ret_code = UTDHASH_PTR_COMPARE_FUNC( curPtr->key.generic, user_key );
	} else {
	    compare_func = hashtable->compare_func ;
	    ret_code = (*compare_func)(curPtr->key.generic, user_key, hashtable->clientData ) ;
	}
	if( ret_code == STRINGEQ ){
	  if( hashtable->unique ){
	    /* ----------------------------------------------------
	     * Operation enter with unique items, we
	     * return item.  On a nonunique enter, add item below.
	    ------------------------------------------------------- */
	    return( curPtr ) ;
	  } else {
	    break ; /* avoid some work for nonunique hash_enter */
	  }
	}
      }
    }

    /* now save data */
    hashtable->p_num_entries++ ;
    table[hsum] = curTable = UTDPOOL_MALLOC(hashtable->pool_id,UTDHASH_ENTRY) ;
    curTable->data = data ;
    if( (hashtable->hash_func == UTD_HASH_DEF_HASH_STR) &&
	!(hashtable->caller_alloced_keys) ){
	curTable->key.simple_string = utDstrclone( user_key ) ;
    } else {
	curTable->key.generic = user_key ;
    }
    curTable->next = temptr ;
    /* now fix thread which goes through hash table */
    if( hashtable->last_entry ){
      hashtable->last_entry->thread_next = curTable ;
      curTable->thread_prev = hashtable->last_entry ;
      hashtable->last_entry = curTable ;
    } else {
      hashtable->thread = hashtable->last_entry = curTable ;
      curTable->thread_prev = NULL ;
    }
    curTable->thread_next = NULL ;

    if( hashtable->p_num_entries >= hashtable->p_need_resize ){
      INT newsize ;		/* new size of table */
      newsize = hashtable->p_tablesize * hashtable->p_growth_factor ;
      utDhash_resize(hashtable, newsize ) ;
    }

    return( NULL ) ; /* no conflict on a enter */

} /* end utDhash_insert() */

/* returns the pointer with the item */
UTDHASH_ENTRYPTR _utDhash_find_item(UTDHASHPTR htable,VOIDPTR user_key,VOIDPTR data)
{
    INT  ret_code ;
    LONG hfunc ;
    UNSIGNED_INT hsum ;
    utDcompareClientData compare_func ;
    UTDHASH_ENTRYPTR curPtr, temptr ;
    UTDHASH_ENTRYPTR *table ;

    /* initialization */
    table = htable->hash_table ;

    /* -----------------------------------------------------------------
     * Process the hash function.
    ----------------------------------------------------------------- */
    hsum = hash_exec_hash_func( htable, user_key, htable->hash_func ) ;

    /* insert into table only if distinct number */
    if( (temptr = table[hsum]) ){
      /* list started at this hash */
      for(curPtr=temptr ; curPtr ; curPtr=curPtr->next ) {
	if( htable->compare_func == UTD_HASH_DEF_CMP_STR ) {
	  ret_code = strcmp(curPtr->key.simple_string, (char *) user_key ) ;
	} else if ( htable->compare_func == UTD_HASH_DEF_CMP_PTR||
		   htable->compare_func == UTD_HASH_DEF_CMP_NUM ){
	  ret_code = UTDHASH_PTR_COMPARE_FUNC( curPtr->key.generic, user_key );
	} else {
	    compare_func = htable->compare_func ;
	    ret_code = (*compare_func)(curPtr->key.generic, user_key, htable->clientData ) ;
	}
	if( ret_code == STRINGEQ ){
	  if( data ){
	    if( curPtr->data == data ){
	      return( curPtr ) ;
	    }
	  } else {
	    return( curPtr ) ;
	  }
	}
      }
    }
    return( NULL ) ; /* no matching item */

} /* end utDhash_find_item() */


/* hash add adds to table if it doesn't already exist - new flag
   will be set to true.  If key already exists in table then
   hash add will not add it to the hash table but will notify the
   user by setting new flag to false.
*/
UTDHASH_ENTRYPTR utDhash_add(UTDHASHPTR hashtable, VOIDPTR user_key, 
  VOIDPTR (*add_function) (VOIDPTR), VOIDPTR add_arg, BOOL *new_flag)
{
    INT  ret_code ;
    LONG hfunc ;
    UNSIGNED_INT hsum ;
    utDcompareClientData compare_func ;
    UTDHASH_ENTRYPTR *table ;
    UTDHASH_ENTRYPTR curPtr, temptr, curTable ;

    /* initialization */
    table = hashtable->hash_table ;
    hashtable->p_access++;

    /* -----------------------------------------------------------------
     * Process the hash function.
    ----------------------------------------------------------------- */
    hsum = hash_exec_hash_func( hashtable, user_key, hashtable->hash_func ) ;

    /* insert into table only if distinct number */
    if( (temptr = table[hsum]) ){
	/* list started at this hash */
	for(curPtr=temptr;curPtr;curPtr=curPtr->next ) {
	  hashtable->p_collisions++;
	  if( hashtable->compare_func == UTD_HASH_DEF_CMP_STR ) {
	    ret_code = strcmp(curPtr->key.simple_string, user_key ) ;
	  } else if ( hashtable->compare_func == UTD_HASH_DEF_CMP_PTR||
		     hashtable->compare_func == UTD_HASH_DEF_CMP_NUM ){
	    ret_code = UTDHASH_PTR_COMPARE_FUNC( curPtr->key.generic, user_key );
	  } else {
	    compare_func = hashtable->compare_func ;
	    ret_code = (*compare_func)(curPtr->key.generic, user_key, hashtable->clientData ) ;
	  }
	  if( ret_code == STRINGEQ ){
	      /* item is currently in the table set */
	      /* new flag to false */
	      *new_flag = FALSE ;
	      return( curPtr ) ;
	  }
	}
	/* otherwise add to the table */
	/* now save data */
	hashtable->p_num_entries++;
	table[hsum] = curTable = UTDPOOL_MALLOC( hashtable->pool_id, UTDHASH_ENTRY ) ;
	curTable->data = (*add_function)( add_arg ) ;
	if( (hashtable->hash_func == UTD_HASH_DEF_HASH_STR) &&
	    !(hashtable->caller_alloced_keys) ){
	  curTable->key.simple_string = utDstrclone( user_key ) ;
	} else {
	  curTable->key.generic = user_key ;
	}
	curTable->next = temptr ;
	/* now fix thread which goes through hash table */
	if( hashtable->last_entry ){
	  hashtable->last_entry->thread_next = curTable ;
	  curTable->thread_prev = hashtable->last_entry ;
	  hashtable->last_entry = curTable ;
	} else {
	  hashtable->thread = hashtable->last_entry = curTable ;
	  curTable->thread_prev = NULL ;
	}
	curTable->thread_next = NULL ;

    } else {
	/* no list started at this hash */
	/* enter into the table on an enter command */
	hashtable->p_num_entries++ ;
	curTable = table[hsum] = UTDPOOL_MALLOC( hashtable->pool_id, UTDHASH_ENTRY ) ;
	curTable->data = (*add_function)( add_arg ) ;

	if( (hashtable->hash_func == UTD_HASH_DEF_HASH_STR) &&
	    !(hashtable->caller_alloced_keys) ){
	    curTable->key.simple_string = utDstrclone( user_key ) ;
	} else {
	    curTable->key.generic = user_key ;
	}
	curTable->next = NULL ;
	/* now fix thread which goes through hash table */
	if( hashtable->last_entry ){
	  hashtable->last_entry->thread_next = curTable ;
	  curTable->thread_prev = hashtable->last_entry ;
	  hashtable->last_entry = curTable ;
	} else {
	  hashtable->thread = hashtable->last_entry = curTable ;
	  curTable->thread_prev = NULL ;
	}
	curTable->thread_next = NULL ;
    }
    *new_flag = TRUE ;
    return( curTable ) ; /* no conflict on a enter */

} /* end hash_add */


/* -----------------------------------------------------------------
 * This is the reentrant version which uses an iterator.
 * ----------------------------------------------------------------- */
UTDHASH_ENTRYPTR utDhash_enumerate(UTDHASHPTR htable, UTDHASHITERPTR iter_p)
{
    UTDHASH_ENTRYPTR current_spot ;	/* current place in threaded list */
    FUNC_NAME("utDhash_enumeratekRE") ;

    if(!(iter_p)){
      utDmsg(ERRMSG,MSG_AT,routine, "Null iterator pointer.\n" ) ;
      return(NULL) ;
    }
    if(!(iter_p->position)){
      if( (iter_p->position = htable->thread) ){
	current_spot = iter_p->position ;
	return( current_spot ) ;
      }
    } else {
      if( iter_p->position && 
	(iter_p->position = iter_p->position->thread_next) ){
	current_spot = iter_p->position ;
	return( current_spot ) ;
      }
    }
    return( NULL ) ;
    
} /* end utDhash_enumerate() */

/* -----------------------------------------------------------------
 * Merge items in merge_htable into master_htable.  Create master_htable
 * if master_htable is NULL.  Returns the merged hash table.
 * ----------------------------------------------------------------- */
UTDHASHPTR utDhash_merge( UTDHASHPTR master_htable, UTDHASHPTR merge_htable )
{
    UTDHASH_ENTRYPTR ptr ;			/* traverse hash table */

    if(!(master_htable)){
      master_htable = UTDMALLOC( 1, UTDHASHBOX ) ;
      *master_htable = *merge_htable ;
      master_htable->hash_table = UTDCALLOC( master_htable->p_tablesize, UTDHASH_ENTRYPTR ) ;
      master_htable->pool_id = UTDPOOL_INIT(master_htable->p_num_entries,UTDHASH_ENTRY) ;
      master_htable->thread = NULL ;
      master_htable->last_entry = NULL ;
      master_htable->p_num_entries = 0 ;
      master_htable->p_access = 0 ;
      master_htable->p_collisions = 0 ;
    }
    for( ptr = merge_htable->thread ; ptr ; ptr = ptr->thread_next ){
      utDhash_insert( master_htable, ptr->key.generic, ptr->data ) ;
    }
    return( master_htable ) ;
} /* end utDhash_merge() */


void utDhash_dump(UTDHASHPTR htable, void (*print_key) (void *))
{
    INT i ;			/* counter */
    INT count ;			/* counter */
    UTDHASH_ENTRYPTR *table ;		/* hash table */
    UTDHASH_ENTRYPTR hptr ;		/* hash table element */

    table = htable->hash_table ;
    fprintf( stderr, "Dump of hashtable containing %d entries...\n", 
	htable->p_num_entries ) ;
    fprintf( stderr, "Table is %4.2f%% full\n", 
	100.0 * (DOUBLE) htable->p_num_entries / (DOUBLE) htable->p_tablesize ) ;
    for( i = 0 ; i < htable->p_tablesize ; i++ ) {
	if( (hptr = table[i]) ){
	    fprintf( stderr, " [%5d]:", i ) ;
	    count = 0 ;
	    for( ; hptr ; hptr=hptr->next ){
		if( ++count == 3 ){
		    fprintf( stderr, "\n\t" ) ;
		    count = 0 ;
		}
		if( htable->hash_func == UTD_HASH_DEF_HASH_STR ){
		    fprintf( stderr, " key:%s ", (char *) hptr->key.simple_string ) ;
		} else {
		    fprintf( stderr, " key:%0lx ", (UNSIGNED_LONG) hptr->key.generic ) ;
		}
		if( print_key) {
		    (*print_key)(hptr->data) ;
		} else {
		    fprintf( stderr, " data:%0lx ", (UNSIGNED_LONG) hptr->data ) ;
		}
	    }
	    fprintf( stderr, "\n" ) ;
	}
    } /* end for( i = 0... */
    
} /* end utDhash_enumerate() */

/* -----------------------------------------------------------------
 * utDhash_deleteItem - deletes a specified item out of the hash table.
 * To be useful, unique flag should be off.  Otherwise just use utDhash_delete.
 * Returns true if item was deleted.
----------------------------------------------------------------- */
BOOL utDhash_deleteItem(UTDHASHPTR hashtable, VOIDPTR user_key, VOIDPTR data)
{
    INT  ret_code ;
    LONG hfunc ;
    UNSIGNED_INT hsum ;
    utDcompareClientData compare_func ;
    UTDHASH_ENTRYPTR curPtr, temptr, *prevPtr ;
    UTDHASH_ENTRYPTR *table ;

    /* initialization */
    table = hashtable->hash_table ;

    /* -----------------------------------------------------------------
     * Process the hash function.
    ----------------------------------------------------------------- */
    hsum = hash_exec_hash_func( hashtable, user_key, hashtable->hash_func ) ;

    /* insert into table only if distinct number */
    temptr = table[hsum] ;
    if( temptr ){
      /* list started at this hash */
      prevPtr = table + hsum ;
      for(curPtr=temptr;curPtr;prevPtr = &(curPtr->next), curPtr=curPtr->next ) {
	/* ----------------------------------------------------------------- 
	 * Look for match.
	----------------------------------------------------------------- */
	if( hashtable->compare_func == UTD_HASH_DEF_CMP_STR ) {
	  ret_code = strcmp(curPtr->key.simple_string, (char *)user_key ) ;
	} else if ( hashtable->compare_func == UTD_HASH_DEF_CMP_PTR||
		    hashtable->compare_func == UTD_HASH_DEF_CMP_NUM ){
	  ret_code = UTDHASH_PTR_COMPARE_FUNC( curPtr->key.generic, user_key );
	} else {
	  compare_func = hashtable->compare_func ;
	  ret_code = (*(compare_func))(curPtr->key.generic, user_key, hashtable->clientData ) ;
	}
	if( ret_code == STRINGEQ ){
	  if( curPtr->data == data ){
	    if( curPtr->thread_prev ){ /* no sentinel */
	      curPtr->thread_prev->thread_next = curPtr->thread_next;
	    } else {
	      hashtable->thread = curPtr->thread_next ;
	    }
	    if( curPtr->thread_next ){ /* no sentinel */
	      curPtr->thread_next->thread_prev = curPtr->thread_prev ;
	    } else {
	      hashtable->last_entry = curPtr->thread_prev ;
	    }
	    *prevPtr = curPtr->next;
	    if( hashtable->hash_func == UTD_HASH_DEF_HASH_STR ) {
	      if(!(hashtable->caller_alloced_keys)){
		/* we allocated this ourselves we can delete it */
		UTDFREE( curPtr->key.simple_string ) ;
	      }
	    }		  
	    UTDPOOL_FREE_ITEM(hashtable->pool_id, curPtr);
	    hashtable->p_num_entries-- ;
	    return( TRUE ) ;
	  }
	}
      } /* end for(curPtr=temptr... */
    } /* end if( temptr... */

    return( FALSE ) ; /* could not find item */

} /* end utDhash_deleteItem() */

/*---------------------------- hash_table_size -------------------------*/
INT utDhash_table_bestsize(INT minEntries)
{
  INT   i;
  BOOL  isPrime;
  INT   prime;
  INT   testPrime;
  static INT   primes[PRIMECOUNT] =
              {  3,   5,   7,  11,  13,  17,  19,  23,  29,  31,
                37,  41,  43,  47,  53,  59,  61,  67,  71,  73,
                79,  83,  89,  97, 101, 103, 107, 109, 113, 127,
                131, 137, 139, 149, 151, 157, 163, 167, 173, 179,
                181, 191, 193, 197, 199, 211, 223, 227, 229, 233,
                239, 241, 251, 257, 263, 269, 271, 277, 281, 283,
                293, 307, 311, 313, 317, 331, 337, 347, 349, 353,
                359, 367, 373, 379, 383, 389, 397, 401, 409, 419,
                421, 431, 433, 439, 443, 449, 457, 461, 463, 467,
                479, 487, 491, 499, 503, 509, 521, 523, 541, 547,
                557, 563, 569, 571, 577, 587, 593, 599, 601, 607,
                613, 617, 619, 631, 641, 643, 647, 653, 659, 661,
                673, 677, 683, 691, 701, 709, 719, 727, 733, 739,
                743, 751, 757, 761, 769, 773, 787, 797, 809, 811,
                821, 823, 827, 829, 839, 853, 857, 859, 863, 877,
                881, 883, 887, 907, 991, 919, 929, 937, 941, 947,
                953, 967, 971, 977, 983, 991, 997,1009,1013,1019,
               1021,1031,1033,1039,1049,1051,1061,1063,1069,1087,
               1091,1093,1097,1103,1109,1117,1123,1129,1151,1153,
               1163,1171,1181,1187,1193,1201,1213,1217,1223,1229 };

    if (minEntries <= MINPRIMESIZE){
	return(MINPRIMESIZE);
    } else {
	testPrime = minEntries;
	/* test to see if even */
	if ((testPrime % 2) == 0){
	    testPrime = testPrime + 1;
	}
	do {
	    testPrime = testPrime + 2;
	    isPrime = TRUE;
	    for (i=0;i < PRIMECOUNT;i++){
		prime = primes[i];
		if (testPrime < prime*prime){
		    break;
		}
		if ((testPrime % prime) == 0){
		    isPrime = FALSE;
		    break;
		}
	    }
	} while (!(isPrime));

	return(testPrime);
    }

}  /*  FUNCTION utDhash_table_bestsize */

INT utDhash_table_bestsize2(INT minEntries)
{
    INT power ;
    INT table_size ;
    power = 0 ;
    while( minEntries > 0 ){
      minEntries = minEntries >> 1 ;
      power++ ;
    }
    power = MIN( power, 32 ) ;
    table_size = 1 << power ;
    table_size = MAX( UTD_HASH_MIN_SIZE, table_size ) ;
    return( table_size ) ;

} /* end utDhash_table_bestsize2() */


void utDhash_distribution(UTDHASHPTR hashtable)
{
  INT i ;				/* counter */
  LONG min ;				/* min count */
  LONG max ;				/* max count */
  LONG nzero_cnt ;			/* non zero count */
  LONG this_count ;			/* count items at this list */
  LONG tablesize ;			/* table size */
  DOUBLE avg ;				/* average */
  DOUBLE sum2 ;				/* squared sum */
  DOUBLE diff ;				/* difference */	
  DOUBLE diff2 ;			/* difference squared */	
  DOUBLE nzavg ;			/* non zero average */
  DOUBLE variance ;			/* variance of table */
  UTDHASH_ENTRYPTR *table ;			/* hash table */
  UTDHASH_ENTRYPTR hptr ;			/* hash table pointer */
  FUNC_NAME("utDhash_distribution" ) ;

  tablesize = utDhash_tablesize(hashtable) ;
  table = hashtable->hash_table ;
  avg = hashtable->p_num_entries / (DOUBLE) tablesize ;
  sum2 = 0.0 ;
  min = max = 0 ;
  nzero_cnt = 0 ;
  for( i = 0 ; i < tablesize ; i++ ) {
    this_count = 0 ;
    for( hptr = table[i]; hptr; hptr = hptr->next ) {
      this_count++ ;
    }
    if( i == 0 ){
      min = max = this_count ;
    } else {
      if( this_count < min ){
	min = this_count ;
      }
      if( this_count > max ){
	max = this_count ;
      }
    }
    if( this_count > 0 ){
      nzero_cnt++ ;
    }
    diff = this_count - avg ;
    diff2 = diff * diff ;
    sum2 += diff2 ;
  }
  variance = sum2 / hashtable->p_num_entries ; 
  nzavg = hashtable->p_num_entries / (DOUBLE) nzero_cnt ;
  utDmsgf(IMSG,MSG_AT,routine, "min:%ld max:%ld nonzero avg:%f\n", min, max, nzavg ) ;
  utDmsgf(IMSG,MSG_AT,NULL, "  variance:%f std dev:%f target:%f nonzero entries:%d / %d\n",
      variance, sqrt(variance), avg, nzero_cnt, tablesize ) ;
} /* end utDhash_distribution() */

INT utDhash_access( UTDHASHPTR hashtable )
{
    if( hashtable ){
      return( hashtable->p_access ) ;
    } else {
      return( 0 ) ;
    }
} /* end utDhash_access() */

INT utDhash_collisions( UTDHASHPTR hashtable )
{
    if( hashtable ){
      return( hashtable->p_collisions ) ;
    } else {
      return( 0 ) ;
    }
} /* end utDhash_collisions() */


#ifdef TEST

#define NUMENTRIES   6

struct rec_test {
    char *name ;
    INT value ;
} a[NUMENTRIES] = {
    {"left",  101},
    {"hixx",  54},
    {"jinx",  13},
    {"jinx",  15},
    {"happy",  7},
    {"rich",  23}
} ;

struct rec_test otherS[] = {
    { "a",  101}, 
    { "b",  54}, 
    { "c",  13}, 
    { "d",  15}, 
    { "e",  7}, 
    { "f",  23}, 
    { "g",  9},
    { "h",  8}, 
    { "i",  48}, 
    { "j",  48}, 
    { "k",  31}, 
    { "l",  12}, 
    { "m",  12},
    { "n",  12},
    { "o",  12}, 
    { "p",  12}, 
    { "q",  12}, 
    { "r",  12}, 
    { "s",  12}, 
    { "t",  12}, 
    { "u",  12},
    { "v",  12}, 
    { "x",  12}, 
    { "y",  12}, 
    { "z",  12}, 
    { "-",  12}, 
    { "0",  12}, 
    { "1", 2} 
} ;

static UNSIGNED_INT my_hash(UTDHASHPTR htable,void *data_p,void *clientData)
{
    char buf[LRECL] ;
    UNSIGNED_INT hashnum ;

    struct rec_test *data = (struct rec_test *) data_p ;
    sprintf( buf, "%s%0x", data->name, data->value ) ;
    /* use the convenience hash function */
    UTDHASH_STR_TO_HASH( buf, hashnum ,NUMENTRIES ) ;
    return( hashnum ) ;
} /* end my_hash() */

static INT my_compare(void *d1, void *d2, void *clientData )
{
    INT ret_code ;
    struct rec_test *data1 = (struct rec_test *) d1 ;
    struct rec_test *data2 = (struct rec_test *) d2 ;

    ret_code = strcmp( data1->name, data2->name ) ;
    if( ret_code == STRINGEQ ){
	return( data1->value - data2->value ) ;
    } else {
	return( ret_code ) ;
    }
} /* end my_hash() */

static void my_print(struct rec_test *data)
{
    fprintf( stderr, " n:%s v:%d ", data->name, data->value ) ;
} /* end my_print() */

static void my_print_num(void *data)
{
    fprintf( stderr, " v:%ld ", (LONG) data ) ;
} /* end my_print_num() */

static void one_round(void)
{
    INT i ;
    INT size ;
    char nbuf[80] ;
    UTDHASHPTR htable ;
    UTDHASHPTR numtable ;
    UTDHASHITER iter ;
    UTDHASH_ENTRYPTR entry_p ;
    struct rec_test *ptr ;
    struct rec_test key_box ;

    size = 20 ;
    htable = utDhash_init( size ) ;
    for( i = 0 ; i < NUMENTRIES; i++ ){
	utDhash_insert( htable, a[i].name, &(a[i]) ) ;
    }
    fprintf( stderr, "Enumerating hash table...\n" ) ;
    for( entry_p = utDhash_enumerate( htable, UTDHASH_FIRST(&iter) ) ; entry_p ; 
	 entry_p = utDhash_enumerate( htable, &iter ) ){
      ptr = UTDHASH_GETDATA(entry_p,struct rec_test *) ;
      fprintf( stderr, "  %s:%d\n", ptr->name, ptr->value ) ;
    }
    fprintf( stderr, "Looking for %s:\n", a[0].name ) ;
    entry_p = utDhash_find(htable, a[0].name) ;
    if( entry_p ){
	ptr = UTDHASH_GETDATA(entry_p,struct rec_test *) ;
	fprintf( stderr, "Found entry %s:%d\n", ptr->name, ptr->value ) ;
    } else {
	fprintf( stderr, "ERROR: no entry found\n" ) ;
    }
    utDhash_dump( htable, (utDdump)my_print ) ;
    utDhash_free(htable, NULL, NULL ) ;
    fprintf( stderr, "Memory use:%ld\n", utDmalloc_use() ) ;

    fprintf( stderr, "\nNow try same as nonunique\n" ) ;
    htable = utDhash_init( size ) ;
    utDhash_unique( htable, FALSE ) ;
    for( i = 0 ; i < NUMENTRIES; i++ ){
	utDhash_insert( htable, a[i].name, &(a[i]) ) ;
    }
    for( entry_p = utDhash_find(htable, a[2].name) ; entry_p ; 
	 entry_p = utDhash_find_again(htable, entry_p ) ){
	ptr = UTDHASH_GETDATA(entry_p,struct rec_test *) ;
	fprintf( stderr, "Found entry %s:%d\n", ptr->name, ptr->value ) ;
    }
    utDhash_dump( htable, (utDdump)my_print ) ;
    utDhash_free(htable, NULL, NULL ) ;
    fprintf( stderr, "Memory use:%ld\n\n", utDmalloc_use() ) ;

    /* now try pointer function */
    htable = utDhash_init_pointer( size ) ;
    for( i = 0 ; i < NUMENTRIES; i++ ){
	utDhash_insert( htable, &(a[i].value), &(a[i]) ) ;
    }
    fprintf( stderr, "Looking for %llx...\n", (UINT64) &(a[4].value) ) ;
    entry_p = utDhash_find(htable,&(a[4].value)) ;
    if( entry_p ){
	ptr = UTDHASH_GETDATA(entry_p,struct rec_test *) ;
	fprintf( stderr, "Found entry %s:%d\n", ptr->name, ptr->value ) ;
    } else {
	fprintf( stderr, "ERROR: no entry found\n" ) ;
    }
    utDhash_dump( htable, (utDdump)my_print ) ;

    fprintf( stderr, "Enumerating hash table before deletion test...\n" ) ;
    for( entry_p = utDhash_enumerate( htable, UTDHASH_FIRST(&iter) ) ; entry_p ; 
	 entry_p = utDhash_enumerate( htable, &iter ) ){
      ptr = UTDHASH_GETDATA(entry_p,struct rec_test *) ;
      fprintf( stderr, "  %s:%d\n", ptr->name, ptr->value ) ;
    }

    fprintf( stderr, "Enumerating hash table after last entry...\n" ) ;
    utDhash_delete(htable, &(a[NUMENTRIES-1].value) ) ;
    for( entry_p = utDhash_enumerate( htable, UTDHASH_FIRST(&iter) ) ; entry_p ; 
	 entry_p = utDhash_enumerate( htable, &iter ) ){
      ptr = UTDHASH_GETDATA(entry_p,struct rec_test *) ;
      fprintf( stderr, "  %s:%d\n", ptr->name, ptr->value ) ;
    }

    fprintf( stderr, "Enumerating hash table after deleting first...\n" ) ;
    utDhash_deleteItem(htable, &(a[0].value), &(a[0]) ) ;
    for( entry_p = utDhash_enumerate( htable, UTDHASH_FIRST(&iter) ) ; entry_p ; 
	 entry_p = utDhash_enumerate( htable, &iter ) ){
      ptr = UTDHASH_GETDATA(entry_p,struct rec_test *) ;
      fprintf( stderr, "  %s:%d\n", ptr->name, ptr->value ) ;
    }

    fprintf( stderr, "Enumerating hash table after middle entry...\n" ) ;
    utDhash_deleteItem(htable, &(a[2].value), &(a[2]) ) ;
    for( entry_p = utDhash_enumerate( htable, UTDHASH_FIRST(&iter) ) ; entry_p ; 
	 entry_p = utDhash_enumerate( htable, &iter ) ){
      ptr = UTDHASH_GETDATA(entry_p,struct rec_test *) ;
      fprintf( stderr, "  %s:%d\n", ptr->name, ptr->value ) ;
    }

    utDhash_free(htable, NULL, NULL ) ;

    fprintf( stderr, "Now try a user comparison function\n" ) ;
    htable = utDhash_init_with_parms( my_compare, my_hash,NULL,20,UTD_HASH_DEF_MAX_DENSITY,
	UTD_HASH_DEF_GROW_FACTOR, UTD_HASH_UNIQUE ) ;
    for( i = 0 ; i < NUMENTRIES; i++ ){
	ptr = &(a[i]) ;
	utDhash_insert( htable, ptr, ptr ) ;
    }
    /* now look for data */
    fprintf( stderr, "Looking for jinx\n" ) ;
    key_box.name = "jinx" ;
    key_box.value = 15 ;
    entry_p = utDhash_find(htable, &key_box ) ;
    if( entry_p ){
	ptr = UTDHASH_GETDATA(entry_p,struct rec_test *) ;
	fprintf( stderr, "Found entry %s:%d\n", ptr->name, ptr->value ) ;
    } else {
	fprintf( stderr, "ERROR: no entry found\n" ) ;
    }

    utDhash_dump( htable, (utDdump)my_print ) ;
    fprintf( stderr, "Now try to overstuff the original hash table...\n" ) ;
    utDhash_max_density(htable,1) ;
    for( i = 0 ; i < 28 ; i++ ){
	ptr = &(otherS[i]) ;
	utDhash_insert( htable, ptr, ptr ) ;
    }
    DS( UTDPOOL_INFO(FALSE,htable->pool_id) ; )

    utDhash_dump( htable, (utDdump)my_print ) ;
    utDhash_empty( htable, NULL, NULL ) ;
    utDhash_free( htable, NULL, NULL ) ;

    fprintf( stderr, "Now try using hash table with numbers.\n" ) ;
    numtable = utDhash_init_integer(5) ;
    utDhash_max_density(numtable,2) ;
    for( i = 1 ; i <= 50 ; i++ ){
      sprintf( nbuf, "%d", i ) ;
      utDhash_insert( numtable, VOIDPTR_TYPE(i), VOIDPTR_TYPE(i) ) ;
    }
    utDhash_dump( numtable, my_print_num ) ;
    utDhash_distribution( numtable ) ;
    utDhash_free( numtable, NULL, NULL ) ;

    /*
UTDmalloc_blk_free() ;
*/
    fprintf( stderr, "Memory use:%ld\n", utDmalloc_use() ) ;
} /* end one_round() */

#include <stdlib.h>
#include <utd/rand.h>

typedef struct tile_data_rec {
    INT net ;
    INT type ;
    INT layer ;
} TILEDATA, *TILE_DATAPTR ;

typedef enum {
  RTE_WILDCARD          =-1,
  RTE_SPACE             =0,
  RTE_METAL             =(1L<<2),
  RTE_METAL1            =(1L<<2)+1,
  RTE_VIA               =(1L<<3),
  RTE_ALTVIA1           =(1L<<3)+1,
  RTE_ALTVIA2           =(1L<<3)+2,
  RTE_ALTVIA3           =(1L<<3)+3,
  RTE_ALTVIA4           =(1L<<3)+4,
  RTE_ALTVIA5           =(1L<<3)+5,
  RTE_ALTVIA6           =(1L<<3)+6,
  RTE_ALTVIA7           =(1L<<3)+7,
  RTE_OBS               =(1L<<4),
  RTE_FORBIDDEN         =(1L<<5),
  RTE_PIN               =(1L<<6),
  RTE_RIPUPH            =(1L<<7),
  RTE_RIPUPV            =(1L<<7)+1
} TILE_TYPE ;

static INT tile_choiceS[17] = {
  RTE_WILDCARD,
  RTE_SPACE,
  RTE_METAL,
  RTE_METAL1,
  RTE_VIA,
  RTE_ALTVIA1,
  RTE_ALTVIA2,
  RTE_ALTVIA3,
  RTE_ALTVIA4,
  RTE_ALTVIA5,
  RTE_ALTVIA6,
  RTE_ALTVIA7,
  RTE_OBS,
  RTE_FORBIDDEN,
  RTE_PIN,
  RTE_RIPUPH,
  RTE_RIPUPV
} ;

typedef struct {
  DOUBLE epsilon ;  /* epsilon routing constant usually 1 */
  INT n_layers ;    /* number of routing layers */
  INT n_vlayers ;   /* number of vertical routing layers */
  INT n_hlayers ;   /* number of horizontal routing layers */
  INT ic_nlayers;   /* total # of mask layers in TW. */
  INT num_vias ;    /* total number of vias */
  INT *restricted_h;
} TECHBOX, *TECHPTR ;

typedef struct my_client_data_rec {
  TECHPTR tech ;
  INT tile_pool ;
  UTDHASHPTR tile_hash_p ;
} MY_CLIENT_DATA, *MY_CLIENT_DATAPTR ;


/* #define TILE_TEST_ORIG 1 */

#ifdef TILE_TEST_ORIG
static TILE_DATAPTR tiledata(MY_CLIENT_DATAPTR cdata_p,INT type,INT layer,INT net)
{
  char buffer[100] ;                  /* build a key */
  TILE_DATAPTR tile_p ;               /* tile information */
  UTDHASH_ENTRYPTR entry_p ;	      /* entry information */

  if( net == 0 ){
    sprintf( buffer, "%d.%d", type, layer ) ;
  } else {
    sprintf( buffer, "%d.%d.%d", type, layer, net ) ;
  }
  entry_p = utDhash_find( cdata_p->tile_hash_p, buffer ) ;
  if( entry_p ){
    tile_p = UTDHASH_GETDATA( entry_p, TILE_DATAPTR ) ;
    return(tile_p) ;
  }
  tile_p = UTDPOOL_MALLOC( cdata_p->tile_pool, TILEDATA ) ;
  tile_p->layer = layer ;
  tile_p->type = type ;
  tile_p->net = net ;
  utDhash_insert( cdata_p->tile_hash_p, buffer, tile_p ) ;
  return(tile_p) ;

} /* end tiledata() */

#else 

static UNSIGNED_INT tile_hash_func( UTDHASHPTR htable, VOIDPTR data_p, VOIDPTR clientData )
{
    UNSIGNED_INT sum ;			/* make a hash sum */
    char *net_p ;			/* net pointer */
    char *type_p ;			/* type pointer */
    char *layer_p ;			/* layer pointer */
    TILE_DATAPTR tile_p = (TILE_DATAPTR) data_p ; 
    MY_CLIENT_DATAPTR c_p = (MY_CLIENT_DATAPTR) clientData ;

    sum = c_p->tech->ic_nlayers * 131 * tile_p->net + 131 * tile_p->layer + tile_p->type ;

/*
    for( r = 1 ; r <= 500000 ; r++ ){

      net = UTD_PICK_INT( 0, 200 ) ;
      type = UTD_PICK_INT( 1, 8 ) ;
      layer = UTD_PICK_INT( 1, 4 ) ;
      data_p = tiledata( type, layer, net ) ;
    }
*/

/*
    net_p = (char *) &(tile_p->net) ;
    sum = (((unsigned char)net_p[0] << 17)
	  + ((unsigned char)net_p[1] << 9)
	  + ((unsigned char)net_p[2] << 19)
	  + ((unsigned char)net_p[3] << 28)) ;
    type_p = (char *) &(tile_p->type) ;
    sum += (((unsigned char)net_p[0] << 1)
	  + ((unsigned char)net_p[1] << 8)
	  + ((unsigned char)net_p[2] << 21)
	  + ((unsigned char)net_p[3] << 7)) ;
    layer_p = (char *) &(tile_p->layer) ;
    sum += (((unsigned char)layer_p[0] << 13)
	  + ((unsigned char)layer_p[1] << 27)
	  + ((unsigned char)layer_p[2] << 5)
	  + ((unsigned char)layer_p[3] << 1)) ;
*/
/*
    net_p = (char *) &(tile_p->net) ;
    sum = ( ((unsigned char)net_p[0] << 3)
          + ((unsigned char)net_p[0])
	  + ((unsigned char)net_p[1] << 3)
	  + ((unsigned char)net_p[1])
	  + ((unsigned char)net_p[2] << 3)
	  + ((unsigned char)net_p[2])
	  + ((unsigned char)net_p[3] << 3)
	  + ((unsigned char)net_p[3]) ) ;
    type_p = (char *) &(tile_p->type) ;
    sum += (((unsigned char)net_p[0] << 3)
	  + ((unsigned char)net_p[0])
	  + ((unsigned char)net_p[1] << 3)
	  + ((unsigned char)net_p[1])
	  + ((unsigned char)net_p[2] << 3)
	  + ((unsigned char)net_p[2])
	  + ((unsigned char)net_p[3] << 3)
	  + ((unsigned char)net_p[3]) ) ;
    layer_p = (char *) &(tile_p->layer) ;
    sum += (((unsigned char)layer_p[0] << 3)
	  + ((unsigned char)layer_p[0])
	  + ((unsigned char)layer_p[1] << 3)
	  + ((unsigned char)layer_p[1])
	  + ((unsigned char)layer_p[2] << 3)
	  + ((unsigned char)layer_p[2])
	  + ((unsigned char)layer_p[3] << 3)
	  + ((unsigned char)layer_p[3]) ) ;
*/
    sum = sum % utDhash_tablesize(htable) ;
    return( sum ) ;

} /* end tile_hash_func() */

static INT tile_comp_func( void *tdata1, void *tdata2, void *clientData )
{
    TILE_DATAPTR t1 = (TILE_DATAPTR) tdata1 ;
    TILE_DATAPTR t2 = (TILE_DATAPTR) tdata2 ;

    if( t1->net == t2->net && t1->type == t2->type && t1->layer == t2->layer ){
      return(0) ;
    } else {
      return(1) ;
    }
/*
    if( t1->net < t2->net ){
      return( -1 ) ;
    } else if( t1->net > t2->net ){
      return( 1 ) ;
    } else {
      if( t1->type < t2->type ){
	return(-1) ;
      } else if( t1->type > t2->type ){
	return(1) ;
      } else {
	if( t1->layer < t2->layer ){
	  return(-1) ;
	} else if( t1->layer > t2->layer ){
	  return(1) ;
	} else {
	  return(0) ;
	}
      }
    }
*/
} /* end tile_comp_func() */

static TILE_DATAPTR tiledata(MY_CLIENT_DATAPTR cdata_p,INT type,INT layer,INT net)
{
  TILEDATA key ;		      /* tile key */
  TILE_DATAPTR tile_p ;               /* tile information */
  UTDHASH_ENTRYPTR entry_p ;	      /* from hash search */

  key.net = net ;
  key.layer = layer ;
  key.type = type ;
  entry_p = utDhash_find(cdata_p->tile_hash_p, &key ) ;
  if( entry_p ){
    tile_p = UTDHASH_GETDATA( entry_p, TILE_DATAPTR ) ;
    return(tile_p) ;
  }
  tile_p = UTDPOOL_MALLOC( cdata_p->tile_pool, TILEDATA ) ;
  tile_p->layer = layer ;
  tile_p->type = type ;
  tile_p->net = net ;
  utDhash_insert( cdata_p->tile_hash_p, tile_p, tile_p ) ;
  return(tile_p) ;

} /* end tiledata() */

#endif /* TILE_TEST_ORIG */

static void tile_data_test(void)
{
    INT r ;				/* counter */
    INT net ;				/* net counter */
    INT type ;				/* type counter */
    INT layer ;				/* layer counter */
    DOUBLE load ;			/* hash load */
    TILE_DATAPTR data_p ;		/* data info */
    UTDHASHPTR tiledata_hash ;		/* tile hash pointer */
    MY_CLIENT_DATA data ;		/* client data */

    utDrandom_set_seed( 1 ) ;
    data.tile_pool = UTDPOOL_INIT( 1200, TILEDATA ) ;
    data.tech = UTDMALLOC( 1, TECHBOX ) ;
    data.tech->ic_nlayers = 4 ;
#ifdef TILE_TEST_ORIG
    fprintf( stderr, "Running original hash routine...\n" ) ;
    tiledata_hashS = utDhash_init( 1200 ) ;
#else
    fprintf( stderr, "Running new hash routine...\n" ) ;
    tiledata_hash = utDhash_init_with_parms( tile_comp_func, tile_hash_func, &data, 1200,
      UTD_HASH_DEF_MAX_DENSITY, UTD_HASH_DEF_GROW_FACTOR, UTD_HASH_UNIQUE ) ;
    /* We can update the client data to populate with the hash function info */
    data.tile_hash_p = tiledata_hash ;
#endif
    for( r = 1 ; r <= 500000 ; r++ ){
      net = UTD_PICK_INT( 0, 200 ) ;
      type = UTD_PICK_INT( 1, 16 ) ;
      type = tile_choiceS[type] ;
      layer = UTD_PICK_INT( 1, 4 ) ;
      data_p = tiledata( &data, type, layer, net ) ;
    }
    load = utDhash_size(tiledata_hash) / utDhash_tablesize(tiledata_hash) ;
    fprintf( stderr, "collision =%10d, access=%10d, load=%4.2f\n",
      utDhash_collisions(tiledata_hash), utDhash_access(tiledata_hash), load ) ;
    DS( UTDPOOL_INFO(FALSE,tiledata_hash->pool_id) ; )
      /*
    utDhash_dump( tiledata_hash, NULL ) ;
    */
} /* end tile_data_test() */

#define FUNC_TEST
#ifdef FUNC_TEST
int main(int argc, char **argv)
{
    BOOL memory_pools ;

    // utDmalloc_debug(TRUE);
    memory_pools = TRUE ;
    /*
    utDdebug_init(TRUE);

    UTDPOOL_ENABLE(memory_pools) ;

    one_round();
    */

    fprintf( stderr, "################################################\n\n" ) ;
    UTDPOOL_ENABLE(memory_pools);
    
    one_round();
    one_round();
    tile_data_test() ;
    if( memory_pools ){
      UTDPOOL_FREE_ALL() ;
    }
    fprintf( stderr, "Final memory:%ld\n", utDmalloc_use() ) ;
    // utDmalloc_dump() ;
    
    exit(0) ;
    return 0 ;
} /* end main() */
#else /* TIME_TEST */

static UNSIGNED_INT pointer_hash_func1( UTDHASHPTR htable_p, VOIDPTR ptr )
{
  INT c, len ;
  UNSIGNED_LONG temp ;
  char cptr[80] ;
  sprintf( cptr, "%lx", (UNSIGNED_LONG) ptr) ;
  len = strlen(cptr) ;
  temp = (UNSIGNED_LONG) cptr[0] ;
  for( c = 1 ; c < len ; c++ ){
    temp += (temp<<3) + (UNSIGNED_LONG) cptr[c] ;
  }
  temp = temp % utDhash_tablesize(htable_p) ;
  return( temp ) ;
} /* end pointer_hash_func1() */ 

static UNSIGNED_INT pointer_hash_func2( UTDHASHPTR htable_p, VOIDPTR ptr )
{
  LONG value ;
  UNSIGNED_INT temp ;
  UNSIGNED_INT hsum ;

  value = (LONG) ptr ;
  temp = value >> 2 ;
  hsum = temp & (utDhash_tablesize(htable_p) - 1) ;
  return( hsum ) ;
} /* end pointer_hash_func2() */ 

static UNSIGNED_INT pointer_hash_func3( UTDHASHPTR htable_p, VOIDPTR ptr )
{
  LONG value ;
  UNSIGNED_INT temp ;
  UNSIGNED_INT hsum ;

  value = (LONG) ptr ;
  temp = value >> 4 ;
  hsum = temp & (utDhash_tablesize(htable_p) - 1) ;
  return( hsum ) ;
} /* end pointer_hash_func3() */ 

static UNSIGNED_INT pointer_hash_func4( UTDHASHPTR htable_p, VOIDPTR ptr )
{
  LONG value ;
  UNSIGNED_INT temp ;
  UNSIGNED_INT hsum ;

  value = (LONG) ptr ;
  temp = value >> 2 ;
  hsum = temp % utDhash_tablesize(htable_p) ;
  return( hsum ) ;
} /* end pointer_hash_func4() */ 

static UNSIGNED_INT pointer_hash_func5( UTDHASHPTR htable_p, VOIDPTR ptr )
{
  LONG value ;
  UNSIGNED_INT temp ;
  UNSIGNED_INT hsum ;

  value = (LONG) ptr ;
  temp = value >> 4 ;
  hsum = temp % utDhash_tablesize(htable_p) ;
  return( hsum ) ;
} /* end pointer_hash_func4() */ 

#include <std/file.h>

int main(int argc, char **argv)
{
    INT test ;				/* test to run */
    INT num_entries ;			/* number of entries */
    INT memory_pools ;			/* memory pools in use */
    LONG number ;			/* number */
    FILE *fp ;				/* file info */
    char buffer[LRECL] ;		/* read into buffer */
    UTDHASHPTR htable ;			/* hash table */

    if( argc != 3 ){
      fprintf( stderr, "hashtest file option\n" ) ;
      exit(0) ;
    }

    fprintf( stderr, "################################################\n\n" ) ;
    memory_pools = TRUE ;
    utDmalloc_blk_enable(memory_pools) ;
    fp = TWOPEN( argv[1], "r", FILE_ABORT ) ;
    test = atoi( argv[2] ) ;
    if( test <= 0 || test > 6 ){
      test = 1 ;
    }
    num_entries = 100 ;
    switch( test ){
      case 1:
	htable = utDhash_init_with_parms(HASH_DEF_CMP_PTR, pointer_hash_func1,
	    num_entries, HASH_DEF_MAX_DENSITY, HASH_DEF_GROW_FACTOR,
	    HASH_UNIQUE ) ;
	break ;
      case 2:
	htable = utDhash_init_with_parms(HASH_DEF_CMP_PTR, pointer_hash_func2,
	    num_entries, HASH_DEF_MAX_DENSITY, HASH_DEF_GROW_FACTOR,
	    HASH_UNIQUE|HASH_POWER_OF_TWO ) ;
	break ;
      case 3:
	htable = utDhash_init_with_parms(HASH_DEF_CMP_PTR, pointer_hash_func3,
	    num_entries, HASH_DEF_MAX_DENSITY, HASH_DEF_GROW_FACTOR,
	    HASH_UNIQUE|HASH_POWER_OF_TWO ) ;
	break ;
      case 4:
	htable = utDhash_init_with_parms(HASH_DEF_CMP_PTR, pointer_hash_func4,
	    num_entries, HASH_DEF_MAX_DENSITY, HASH_DEF_GROW_FACTOR,
	    HASH_UNIQUE ) ;
	break ;
      case 5:
	htable = utDhash_init_with_parms(HASH_DEF_CMP_PTR, pointer_hash_func5,
	    num_entries, HASH_DEF_MAX_DENSITY, HASH_DEF_GROW_FACTOR,
	    HASH_UNIQUE ) ;
	break ;
      case 6:
	htable = utDhash_init_pointer( num_entries ) ;
	break ;
    }

    while( fgets( buffer, LRECL, fp ) ){
      number = atol( buffer ) ;
      utDhash_insert( htable, (VOIDPTR)number, (VOIDPTR)number ) ;
    }
    utDhash_distribution(htable) ;
    fprintf( stderr, "done\n" ) ;

    if( memory_pools ){
      utDmalloc_blk_free() ;
    }
    fprintf( stderr, "Final memory:%ld\n", utDmalloc_use() ) ;
    utDmalloc_dump() ;
    

    exit(0) ;
    return 0 ;
} /* end main() */
#endif /* TIME_TEST */

#endif /* TEST */
