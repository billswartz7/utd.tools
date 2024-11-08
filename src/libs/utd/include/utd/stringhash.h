/* ----------------------------------------------------------------- 
FILE:	    stringhash.h                                       
DESCRIPTION:This file contains include definitions for the string hash
            utility.  Create a memory pool for strings.
CONTENTS:   MACRO DEFINITIONS
DATE:	    Fri Mar 15 16:39:23 CDT 2019
REVISIONS:  
 * $Log$
----------------------------------------------------------------- */
#ifndef UTDSTRINGHASH_H
#define UTDSTRINGHASH_H

#include <utd/hash.h>

#define UTDSTR_POOL_ALLOC_SIZE (4*4096-16)
#define UTDSTR_POOL_SIZE (UTDSTR_POOL_ALLOC_SIZE - sizeof(struct utdstr_pool_rec *))

typedef enum {
  UTDSTR_HASH_CALLER_ALLOCS 		= 0,
  UTDSTR_HASH_TABLE_ALLOCS_KEYS		= 1,
  UTDSTR_HASH_VALUE_EQUALS_KEYS		= 2,
  UTDSTR_HASH_CASE_SENSITIVE		= 4,
  UTDSTR_HASH_UNIQUE_STRINGS		= 8
} UTDSTR_HASH_ALLOC_T ;

typedef enum {
  UTDSTR_HASH_IGNORE_CASE = 0,
  UTDSTR_HASH_USE_CASE = 1
} UTDSTR_HASH_CASE_T ;

typedef struct utdstr_pool_rec {
  struct utdstr_pool_rec *next ;
  char data[UTDSTR_POOL_SIZE] ;
} UTDSTR_POOL, *UTDSTR_POOLPTR ;

typedef struct utdstr_htable {
   INT nleft ;			/* bytes left in the pool. */
   char *pool ;			/* points to a block of usable memory */
   UTDSTR_POOLPTR pool_base ;	/* memory pool of string */
   UTDSTR_HASH_ALLOC_T options ;	/* who allocates memory, etc */
   UTDHASHPTR table ;		/* table of data */
#ifdef DEBUG
   BOOL inuse_tree_print ;	/* used to print members of the tree */
#endif /* DEBUG */
} UTDSTR_HASH, *UTDSTR_HASHPTR ;


/* -----------------------------------------------------------------
 * Make a string hash table.  User may alloc string but usually we
 * want to create a pool.  The user may make the sring case insensitive.
 * The user may also allow the string table to store the key as its
 * value. In addition, the user may optionally allow unique strings
 * option which would allow multiple values for a string.
 * ----------------------------------------------------------------- */
extern UTDSTR_HASHPTR utDstringhash_init(UTDSTR_HASH_ALLOC_T who_allocs,
				         UTDSTR_HASH_CASE_T case_type, 
				         BOOL unique_strings) ;

extern BOOL utDstringhash_find(UTDSTR_HASHPTR hdl, char *str,VOIDPTR *ret_p) ;
extern char *utDstringhash_find_key(UTDSTR_HASHPTR htab, char *str) ;
extern char *utDstringhash_add(UTDSTR_HASHPTR htable, char *str,VOIDPTR val_p) ;
extern void utDstringhash_delete(UTDSTR_HASHPTR hdl, char *str,utDdelete delete_func) ;
extern void utDstringhash_release( UTDSTR_HASHPTR htable, char *string ) ;
extern char *utDstringhash_create( UTDSTR_HASHPTR htable, char *string ) ;
extern void utDstringhash_free_string( UTDSTR_HASHPTR htable, char *string ) ;
extern void utDstringhash_free(UTDSTR_HASHPTR htable, utDdelete delete_func ) ;
extern void utDstringhash_empty(UTDSTR_HASHPTR htable, utDdelete delete_func ) ;

#endif /* UTDSTRINGHASH_H */
