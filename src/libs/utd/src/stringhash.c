/* ----------------------------------------------------------------- 
FILE:	    stringhash.c
DESCRIPTION:This file contains parser string hash tables.
DATE:	    Fri Mar 15 16:42:50 CDT 2019
REVISIONS:  
 * $Log$
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <stdio.h>
#include <stdlib.h>
#include <utd/base.h>
#include <utd/debug.h>
#include <utd/string.h>
#include <utd/system.h>
#include <utd/msg.h>
#include <utd/program.h>
#include <utd/stringhash.h>

/* ********************** TYPE DEFINITIONS ************************* */
#define INIT_TABLE_SIZE 32

/******* STATIC FUNCTION DECLARE *********/
static void free_hstring(char *string) ;
static INT STR_ignore_case( void *str1, void *str2, void *clientData ) ;
static char *stringtab_alloc_string(UTDSTR_HASHPTR htab, const char *str) ;


/* ***************** STATIC VARIABLE DEFINITIONS ******************* */

/* -----------------------------------------------------------------
 * Make a string hash table.  User may alloc string but usually we
 * want to create a pool.  The user may make the sring case insensitive.
 * The user may also allow the string table to store the key as its
 * value. In addition, the user may optionally allow the creation of a free
 * tree which will store any strings to be freed.
 * ----------------------------------------------------------------- */
UTDSTR_HASHPTR utDstringhash_init(UTDSTR_HASH_ALLOC_T who_allocs,
			      UTDSTR_HASH_CASE_T case_type,BOOL unique_strings)
{
    UTDSTR_HASHPTR htab ;			/* new hash table */

    htab = UTDMALLOC( 1, UTDSTR_HASH ) ;
    htab->pool = NULL ;
    htab->pool_base = NULL ;
    htab->nleft = 0 ;
    htab->options = who_allocs ;
    DS(htab->inuse_tree_print = FALSE ; )
    /* -----------------------------------------------------------------
     * The string hash table itself never allocs the strings.  It is
     * either allocated by the user *OR* it is a pool entry.
     * ----------------------------------------------------------------- */
    if( case_type == UTDSTR_HASH_IGNORE_CASE ){
      htab->table = utDhash_init_with_parms( STR_ignore_case, UTD_HASH_DEF_HASH_STR, NULL,
                                           UTD_HASH_MIN_SIZE, UTD_HASH_DEF_MAX_DENSITY,
					   UTD_HASH_DEF_GROW_FACTOR, 
					   UTD_HASH_NONUNIQUE | UTD_HASH_CALLER_ALLOCS_KEY ) ;
    } else {
      htab->table = utDhash_init( UTD_HASH_MIN_SIZE ) ;
      utDhash_caller_allocs_keys( htab->table, TRUE ) ;
      htab->options |= UTDSTR_HASH_USE_CASE ;
    }
    if( unique_strings ){
      htab->options |= UTDSTR_HASH_UNIQUE_STRINGS ;
      utDhash_unique( htab->table, TRUE ) ;
    } else {
      utDhash_unique( htab->table, FALSE ) ;
    }
    return( htab ) ;
} /* end utDstringhash_init() */

/* -----------------------------------------------------------------
 * Find a string in the table.  This will work even if value is NULL.
 * ----------------------------------------------------------------- */
BOOL utDstringhash_find(UTDSTR_HASHPTR htab, char *str, VOIDPTR *ret_p)
{
    UTDHASH_ENTRYPTR entry_p ;			/* hash entry */

    entry_p = utDhash_find( htab->table, str ) ;
    if( entry_p ){
      *ret_p = UTDHASH_GETDATA( entry_p, VOIDPTR ) ;
      return(TRUE) ;
    }
    return( FALSE ) ;
} /* end utDstringhash_find() */

/* -----------------------------------------------------------------
 * Find a string key in the table.  Key may not be the same string 
 * although many times it is.
 * ----------------------------------------------------------------- */
char *utDstringhash_find_key(UTDSTR_HASHPTR htab, char *str)
{
    char *str_ret_p ;			/* string return */
    UTDHASH_ENTRYPTR entry_p ;			/* hash entry */

    entry_p = utDhash_find( htab->table, str ) ;
    if( entry_p ){
      str_ret_p = UTDHASH_GETKEY( entry_p, char *) ;
      return( str_ret_p ) ;
    }
    return( NULL ) ;
} /* end utDstringhash_find() */

char *utDstringhash_add(UTDSTR_HASHPTR htab, char *str, VOIDPTR val_p)
{

    if (htab->options & UTDSTR_HASH_TABLE_ALLOCS_KEYS ){	
      str = stringtab_alloc_string(htab, str) ;
    }
    if( htab->options & UTDSTR_HASH_VALUE_EQUALS_KEYS ){
      val_p = str ;
    }
    utDhash_insert( htab->table, str, val_p ) ;
    return( str ) ;

} /* end utDstringhash_add() */

void *utDstringhash_add_unique(UTDSTR_HASHPTR htab, char *str, VOIDPTR val_p)
{
    VOIDPTR ret_val ;			/* return value */

    if( utDstringhash_find( htab, str, &ret_val ) ){
      return( ret_val ) ;
    }
    utDstringhash_add( htab, str, val_p) ;
    if( utDstringhash_find( htab, str, &ret_val ) ){
      return( ret_val ) ;
    }
    return(NULL) ;

} /* end utDstringhash_add_unique() */



static INT STR_ignore_case( void *data1, void *data2, void *clientData )
{
    char *str1, *str2 ;			/* strings to compare */
    INT ret_code ;			/* return code */
    str1 = (char *) data1 ;
    str2 = (char *) data2 ;
    ret_code = utDstricmp( str1, str2 ) ;
    return( ret_code ) ;
} /* end STR_ignore_case() */


/* -----------------------------------------------------------------
 * Allocate a string from the pool.  Grab another block if needed.
----------------------------------------------------------------- */
static char *stringtab_alloc_string(UTDSTR_HASHPTR htab, const char *str)
{
  LONG need ;				/* amount of space needed */
  LONG nleft ;				/* number left */
  UTDSTR_POOLPTR p ;			/* string pool */
  char *addr ;				/* return address of string */

  need = strlen(str) + 1 ;

  if( need > htab->nleft ) {
    if( need > UTDSTR_POOL_SIZE ) {
      /* this should almost never happen in normal use but program defensively */
      p = (UTDSTR_POOLPTR) UTDMALLOC( need + sizeof(struct ystr_pool_rec *) + 1, char ) ;
      nleft = need ;
    } else {
      p = UTDMALLOC( 1, UTDSTR_POOL ) ;
      nleft = UTDSTR_POOL_SIZE ;
    }
    /* -----------------------------------------------------------------
     * chain these together so STR_destroy_stringtab can free all blocks.
    ----------------------------------------------------------------- */
    p->next = htab->pool_base ;
    htab->pool_base = p ;
    htab->pool = &(p->data[0]) ;
    htab->nleft = nleft ;
  }
  addr = htab->pool ;
  htab->pool += need ;
  htab->nleft -= need ;
  strcpy(addr, str) ;
  return(addr) ;
} /* end stringtab_alloc_string() */

/* -----------------------------------------------------------------
 * Free the stringhash and all string data.  The delete function
 * is used to delete the string data of the string table if present. 
 * ----------------------------------------------------------------- */
void utDstringhash_free(UTDSTR_HASHPTR htab, utDdelete delete_func )
{
    UTDSTR_POOLPTR next ;			/* next pool to free */

#ifdef DEBUG
    /* A useful debugging option */
    if( htab->inuse_tree_print ){
      UTDHASH_ENTRYPTR entry_p ;
      char *ptr ;
      UTDHASHITER iter ;
      utDmsgf(MSG,MSG_AT,NULL,"Contents of the string table:\n" ) ;
      for( entry_p = utDhash_enumerate( htab->table, UTDHASH_FIRST(&iter)); entry_p ;
	   entry_p = utDhash_enumerate( htab->table, &iter ) ){
	ptr = UTDHASH_GETDATA( entry_p, char *) ;
	utDmsgf(MSG,NULL,"%s\n", ptr ) ;
      }
    }
#endif /* DEBUG */
    utDhash_free( htab->table, delete_func, NULL ) ;
    /* free all the string blocks, if allocated  */
    for( ; htab->pool_base ; ) {
      next = htab->pool_base->next ;
      UTDFREE(htab->pool_base) ;
      htab->pool_base = next ;
    }
    UTDFREE(htab) ;
} /* end utDstringhash_free() */

/* -----------------------------------------------------------------
 * Empty the string table.  You should not allow the string table to
 * grow large but free it occasionally.  Again the delete function
 * is used to process the free tree if present.
----------------------------------------------------------------- */
void utDstringhash_empty(UTDSTR_HASHPTR htab, utDdelete delete_func )
{
    UTDSTR_POOLPTR next ;			/* next pool to free */

    utDhash_empty( htab->table, delete_func, NULL ) ;
    /* free all the string blocks, if allocated  */
    for( ; htab->pool_base ; ) {
      next = htab->pool_base->next ;
      UTDFREE(htab->pool_base) ;
      htab->pool_base = next ;
    }
    htab->pool = NULL ;
    htab->pool_base = NULL ;
    htab->nleft = 0 ;

} /* end STR_empty_stringtable() */

/* -----------------------------------------------------------------
 * The following three functions are similar but handle the free of
 * the table entry value field diffently.   utDstringhash_delete allows
 * the user to delete entry from string table and free the value field
 * with a user supplied delete function.
 * ----------------------------------------------------------------- */
void utDstringhash_delete(UTDSTR_HASHPTR htab, char *str,utDdelete delete_func)
{
    VOIDPTR val_p ;			/* entry value */
    UTDHASH_ENTRYPTR entry_p ;		/* entry in hash table */

    if( delete_func ){
      /* We want to free the value at the table too */
      entry_p = utDhash_find( htab->table, str ) ;
      if( entry_p ){
	val_p = UTDHASH_GETDATA( entry_p, VOIDPTR ) ;
	if( val_p ){
	  (*delete_func)( val_p ) ;
	}
      }
    }
    /* We can delete a string from the table without worry because
     * the hash table understands who created the key string */
    utDhash_delete( htab->table, str ) ;

} /* end utDstringhash_delete() */

/* -----------------------------------------------------------------
 * Release a user string from the list of allocated strings.  The idea
 * is that you never let the free tree grow very large so it is efficient.
 * If the item was not allocated by the table, user must free value
----------------------------------------------------------------- */
void utDstringhash_release(UTDSTR_HASHPTR htab,char *string)
{
    utDhash_deleteItem( htab->table, string, string ) ;
} /* end utDstringhash_release() */

/* -----------------------------------------------------------------
 * Similar to utDstringhash_release but calls a free of the string
 * as a convenience.
----------------------------------------------------------------- */
void utDstringhash_free_string(UTDSTR_HASHPTR htab,char *string)
{
    utDhash_deleteItem( htab->table, string, string ) ;
    if( !(htab->options & UTDSTR_HASH_TABLE_ALLOCS_KEYS) && string ){
      free_hstring( string ) ;
    }
} /* end utDstringhash_free_string() */


/* -----------------------------------------------------------------
 * Convenience function where user does not use the string pool but
 * let the string hash clone the input string.
 * ----------------------------------------------------------------- */
char *utDstringhash_create( UTDSTR_HASHPTR htab, char *string )
{
    char *new_string ;          /* create clone of string */
    FUNC_NAME("utDstringhash_create") ;

    if( !(htab->options & UTDSTR_HASH_TABLE_ALLOCS_KEYS) ){
      new_string = utDstrclone(string) ;
    } else {
      utDmsgf(WARNMSG|MSG_CONTROL,MSG_AT,routine, "You are using this function improperly.\n") ;
      return( string ) ;
    }
    if( !(htab->options & UTDSTR_HASH_VALUE_EQUALS_KEYS) ){
      utDmsgf(WARNMSG|MSG_CONTROL,MSG_AT,routine, "The keys will equals the value. \
Set the HASH_VALUE_EQUALS_KEYS option.\n") ;
    }
    utDhash_insert( htab->table, new_string, new_string ) ;
    return( new_string ) ;
} /* end utDstringhash_create() */


static void free_hstring(char *string)
{
    DS(string[0] = EOS ;)
    UTDFREE(string) ;
} /* end free_hstring() */

#ifdef TEST

int main(int argc,char **argv)
{
    char *a ;				/* test string */
    LONG data ;				/* data as a NULL */
    BOOL mem_test ;			/* test memory dumper */
    BOOL found ;			/* found a member */
    UTDSTR_HASHPTR str_table_p ;		/* string hash table */
    VOIDPTR data_ret ;			/* pointer to data stored */
    /* -----------------------------------------------------------------
     * If mem_test is on we will determine the memory leak from the debug
     * code and the creation of a string.
    ----------------------------------------------------------------- */
    mem_test = TRUE ;

    // utDmalloc_debug(MALLOC_DEBUG|MALLOC_DUMP);
    // Ydebug_init(mem_test);

    str_table_p = utDstringhash_init(UTDSTR_HASH_TABLE_ALLOCS_KEYS,
				   UTDSTR_HASH_USE_CASE, FALSE ) ;
    utDstringhash_add( str_table_p, "for", NULL ) ;
    utDstringhash_add( str_table_p, "if", NULL ) ;
    utDstringhash_add( str_table_p, "then", NULL ) ;
    utDstringhash_add( str_table_p, "while", NULL ) ;

    found = utDstringhash_find( str_table_p, "for", &data_ret ) ;
    if( found ){
      data = (LONG) data_ret ;
      fprintf( stderr, "Search for string worked.  Data:%ld...\n",
	  data ) ;
    } else {
      fprintf( stderr, "Search for string didn't work..\n" ) ;
    }

    a = utDstringhash_create( str_table_p, "junk" ) ;

    fprintf( stderr, "Memory before free:%ld\n", utDmalloc_use() ) ;
    utDstringhash_free( str_table_p, NULL ) ;
    fprintf( stderr, "Memory after free:%ld\n", utDmalloc_use() ) ;

    UTDPOOL_FREE_ALL() ;
    fprintf( stderr, "Final memory:%ld\n", utDmalloc_use() ) ;

    exit(0) ;
} /* end main() */

#endif /* TEST */
