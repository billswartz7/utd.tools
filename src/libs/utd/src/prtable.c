/*-----------------------------------------------------------------
       Copyright (c) 2007 TWS.  All rights reserved.
  FILE:         prtable.c
  DESCRIPTION:  Print table routine.
  CONTENTS:     This module contains the routines to manipulate a table 
                print object.
  DATE:         Mon Dec 24 09:58:13 CST 2007
  REVISIONS:`	
 * $Log: prtable.c,v $
 * Revision 1.13  2018/07/24 14:55:18  bills
 * Moved dynamic strings from message.c to dstring.c and renamed them.
 *
 * Revision 1.12  2016/11/05 04:03:27  bills
 * Made -Wall clean.
 *
 * Revision 1.11  2015/12/22 18:22:13  bills
 * Now table has unlimited size.
 *
 * Revision 1.10  2015/07/21 23:29:22  bills
 * Now we made prtable work so it uses dynamic strings.
 *
 * Revision 1.9  2015/07/16 19:38:49  bills
 * Added justication support for prtable columns.
 *
 * Revision 1.8  2009/11/24 16:18:55  bills
 * Added ability to change floating point precision in tables.
 *
 * Revision 1.7  2009/04/30  16:27:41  bills
 * Fixed typo in custom string entry.   Updated test program for extra custom
 * argument to utDprint_table_add_field.
 *
 * Revision 1.6  2008/05/28  14:27:55  bills
 * Improved the speed of appending lines to the print table.
 *
 * Revision 1.5  2008/05/12  13:09:46  bills
 * Added custom field formats to support building readable STA tables.
 *
 * Revision 1.4  2008/04/29  15:31:22  bills
 * Added hidden attribute for hiding columen heading.   Added left_margin
 * capability.   Added ability to print single table item.  Added the
 * ability to override the format characters of a field.
 *
 * Revision 1.3  2008/03/24  14:21:23  bills
 * Added utDprint_table_msg so we could write table to a dynamic string.
 * We also added utDprint_table_field_index and utDprint_table_field_type
 * to help maintain the table properly.
 *
 * Revision 1.2  2007/12/30  06:00:46  bills
 * Added missing <std/program.h> include file.
 *
 * Revision 1.1  2007/12/24  23:03:55  bills
 * Initial revision
 *
  -----------------------------------------------------------------*/
#include <utdconfig.h>

#include <stdio.h>

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */

#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif /* HAVE_STDARG_H */

#include <utd/base.h>
#include <utd/bitset.h>
#include <utd/debug.h>
#include <utd/deck.h>
#include <utd/msg.h>
#include <utd/hash.h>
#include <utd/program.h>
#include <utd/rint.h>
#include <utd/tile.h>
#include <utd/okmalloc.h>
#include <utd/dstring.h>
#include <utd/file.h>
#include <utd/rbtree.h>
#include <utd/string.h>
#include <utd/prtable.h>



/* ********************** TYPE DEFINITIONS ************************* */
#define STR_POOL_ALLOC_SIZE (4*4096-16)
#define STR_POOL_SIZE (STR_POOL_ALLOC_SIZE - sizeof(struct str_pool_rec *))

typedef struct prtable_pool_rec {
  struct prtable_pool_rec *next_string_pool ;
  char string_data[STR_POOL_SIZE] ;
} STR_POOL, *STR_POOLPTR ;

typedef struct prtable_data_rec {
  char **data ;
  struct prtable_data_rec *next_data ;
} UTDPRINT_DATA, *UTDPRINT_DATAPTR ;

#ifndef TEST
/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static void prtable_free_strings(UTDPRINT_TABLEPTR table_p) ;
static char *prtable_alloc_string(UTDPRINT_TABLEPTR table_p, const char *str) ;
static void prtable_column_space( UTDPRINT_TABLEPTR table_p, FILE *fp ) ;
static void prtable_column_space_msg(UTDPRINT_TABLEPTR t_p,UTDDSTRINGPTR msg_p) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static UTDDSTRINGPTR table_dyna_bufS ;	/* common dynamics string buffer */
#ifdef DEBUG

#endif /* DEBUG */


UTDPRINT_TABLEPTR utDprint_table_init(void)
{
    UTDPRINT_TABLEPTR table_p ;		/* create a table */

    table_p = UTDCALLOC( 1, UTDPRINT_TABLE ) ;
    table_p->data_pool = UTDPOOL_INIT( 0, UTDPRINT_DATA ) ;
    table_p->column_space = 1 ;
    table_p->floating_pt_precision = UTDPRINT_TABLE_FLOAT_PRECISION ;
    return(table_p) ;
} /* end utDprint_table_init() */

void utDprint_table_free( UTDPRINT_TABLEPTR table_p )
{
    if( table_p->pool_base ){
      prtable_free_strings(table_p) ;
    }
    if( table_p->data_pool > 0 ){
      UTDPOOL_FREE_POOL( table_p->data_pool ) ;
    }
    UTDFREE( table_p ) ;
} /* end utDprint_table_free() */

void utDprint_table_column_space( UTDPRINT_TABLEPTR table_p, INT space )
{
    if( space <= 0 ){
      space = 1 ;
    }
    table_p->column_space = space ;
} /* end utDprint_table_column_space() */

void utDprint_table_margin( UTDPRINT_TABLEPTR table_p, char *margin )
{
    if( table_p->left_margin ){
      UTDFREE(table_p->left_margin) ;
    }
    if( margin ){
      table_p->left_margin = utDstrclone(margin) ;
    } else {
      table_p->left_margin = NULL ;
    }
} /* end utDprint_table_margin() */

void utDprint_table_add_field( UTDPRINT_TABLEPTR table_p, char *header,
                             PRTABLE_FIELD_TYPE_T field_type, char *alias,
			     char *custom_format )
{
    INT num ;				/* number of fields */
    /* -----------------------------------------------------------------
     * Number of fields is small so realloc method is fine and we don't
     * need power of 2 growth.
     * ----------------------------------------------------------------- */
    num = ++(table_p->num_fields) ;
    table_p->field_names = UTDVECTOR_REALLOC( table_p->field_names, 1, num, char *) ;
    table_p->field_aliases = UTDVECTOR_REALLOC( table_p->field_aliases, 1, num, char *) ;
    table_p->field_type = UTDVECTOR_REALLOC( table_p->field_type, 1, num, PRTABLE_FIELD_TYPE_T) ;
    table_p->field_names[num] = prtable_alloc_string(table_p, header) ;
    table_p->field_type[num] = field_type ;
    table_p->justification = UTDVECTOR_REALLOC( table_p->justification, 1, num, PRTABLE_JUSTIFY_T) ;
    if( alias ){
      table_p->field_aliases[num] = prtable_alloc_string(table_p, alias) ;
    } else {
      table_p->field_aliases[num] = NULL ;
    }
    if( custom_format ){
      table_p->custom_fields = UTDVECTOR_REALLOC( table_p->custom_fields, 1, num, char *) ;
      table_p->custom_fields[num] = prtable_alloc_string(table_p, custom_format) ;
    } else {
      if( table_p->custom_fields ){
	table_p->custom_fields = UTDVECTOR_REALLOC( table_p->custom_fields, 1, num, char *) ;
	table_p->custom_fields[num] = NULL ;
      }
    }
    table_p->justification[num] = PRTABLE_JUSTIFY_RIGHT_T ;
} /* end utDprint_table_add_field() */

void utDprint_new_record( UTDPRINT_TABLEPTR table_p )
{
    UTDPRINT_DATAPTR new_p ;			/* new data record */
    UTDPRINT_DATAPTR last_p ;			/* last data record added */

    if( table_p->array_pool == 0 ){
      table_p->array_pool = UTDPOOL_MALLOC_MULTI_BLK_INIT( 0, table_p->num_fields, char *) ;
    }
    new_p = UTDPOOL_CALLOC( table_p->data_pool, UTDPRINT_DATA ) ;
    new_p->data = UTDPOOL_CALLOC_MULTI_BLK( table_p->array_pool, table_p->num_fields, char * ) ;
    last_p = table_p->last_rec ;
    if( last_p ){
      last_p->next_data = new_p ;
    } else {
      table_p->first_rec = new_p ;
    }
    table_p->last_rec = new_p ;

} /* utDprint_new_record() */

INT utDprint_table_field_index( UTDPRINT_TABLEPTR table_p, char *field_name )
{
    INT i ;				/* counter */
    char *alias ;			/* field alias */
    INT field ;				/* field index */

    /* -----------------------------------------------------------------
     * First try full name.
     * ----------------------------------------------------------------- */
    field = 0 ;
    for( i = 1 ; i <= table_p->num_fields ; i++ ){
      if( strcmp( field_name, table_p->field_names[i] ) == STRINGEQ ){
	return(i) ;
      }
    }
    if(!(field)){
      /* -----------------------------------------------------------------
       * Next try aliases.
       * ----------------------------------------------------------------- */
      for( i = 1 ; i <= table_p->num_fields ; i++ ){
	alias = table_p->field_aliases[i] ;
	if(!(alias)){
	  continue ;
	}
	if( strcmp( field_name, alias ) == STRINGEQ ){
	  return( i ) ;
	  break ;
	}
      }
    }
    return(0) ;
} /* end utDprint_table_field_index() */

PRTABLE_FIELD_TYPE_T utDprint_table_field_type( UTDPRINT_TABLEPTR table_p, char *field_name )
{
    INT field ;				/* field index */
    PRTABLE_FIELD_TYPE_T field_type ;	/* type of field */

    field = utDprint_table_field_index( table_p, field_name ) ;
    if(!(field)){
      return(PRTABLE_UNKNOWN_T) ;
    }
    field_type = table_p->field_type[field] ;
    return( field_type ) ;
} /* end utDprint_table_field_type() */


PRTABLE_FIELD_TYPE_T utDprint_table_custom_type( UTDPRINT_TABLEPTR table_p, char *field_name )
{
    INT field ;				/* field index */
    char *ptr ;				/* traverse custom format */
    char *cformat ;			/* custom format */
    char **custom_fields ;		/* custom fields are present */

    field = utDprint_table_field_index( table_p, field_name ) ;
    if(!(field)){
      return(PRTABLE_UNKNOWN_T) ;
    }
    custom_fields = table_p->custom_fields ;
    if(!(custom_fields)){
      return(PRTABLE_UNKNOWN_T) ;
    }
    cformat = custom_fields[field] ;
    if(!(cformat)){
      return(PRTABLE_UNKNOWN_T) ;
    }
    for( ptr = cformat ; ptr && *ptr ; ptr++ ){
      switch( *ptr ){
	case 'd':
	case 'i':
	case 'o':
	case 'p':
	case 'x':
	case 'X':
	  return (PRTABLE_INTEGER_T) ;
	case 'e':
	case 'E':
	case 'f':
	case 'F':
	case 'g':
	case 'G':
	  return(PRTABLE_FLOAT_T) ;
	case 's':
	  return(PRTABLE_STRING_T) ;
	default: ;
      }
    }
    return(PRTABLE_UNKNOWN_T) ;
} /* end utDprint_table_field_type() */

void utDprint_table_field_hidden_type( UTDPRINT_TABLEPTR table_p, char *field_name, BOOL hidden )
{
    INT field ;				/* field index */

    field = utDprint_table_field_index( table_p, field_name ) ;
    if(!(field)){
      return ;
    }
    if( hidden ){
      BITMODE_SET( table_p->field_type[field], PRTABLE_HIDDEN_T ) ;
    } else {
      BITMODE_RESET( table_p->field_type[field], PRTABLE_HIDDEN_T ) ;
    }
} /* end utDprint_table_hidden_field_type() */


void utDprint_table_justification( UTDPRINT_TABLEPTR table_p, char *field_name, 
                                 PRTABLE_JUSTIFY_T justification )
{
    INT field ;				/* field index */

    field = utDprint_table_field_index( table_p, field_name ) ;
    if(!(field)){
      return ;
    }
    table_p->justification[field] = justification ;
} /* end utDprint_table_justification() */


void utDprint_table_data( UTDPRINT_TABLEPTR table_p, char *format, ... )
{
    va_list args ;			/* variable args */
    INT field ;				/* field index */
    INT format_len ;			/* format length */
    PRTABLE_FIELD_TYPE_T field_type ;	/* type of field */
    char *buffer_p ;			/* beginning of dynamic buffer */
    char *field_name ;			/* file name */
    char format_buf[40] ;		/* format buffer */
    char **custom_fields ;		/* custom fields info */
    UTDPRINT_DATAPTR data_p ;		/* new data record */

    /* -----------------------------------------------------------------
     * First get field index.
     * ----------------------------------------------------------------- */
    /* looks strange but we want to quiet a bogus compiler warning */
    field_name = format ; 
    field = utDprint_table_field_index( table_p, field_name ) ;
    if(!(field)){
      return ;
    }
    field_type = table_p->field_type[field] ;
    field_type = utDprint_table_simple_field_type( field_type ) ;
    switch ( field_type ){
      case PRTABLE_INTEGER_T:
	format = "%d" ;
	break ;
      case PRTABLE_FLOAT_T:
	sprintf( format_buf, "%%.%df", table_p->floating_pt_precision ) ;
	format = format_buf ;
	break ;
      case PRTABLE_STRING_T:
	format = "%s" ;
	break ;
      case PRTABLE_CUSTOM_T:
	custom_fields = table_p->custom_fields ;
	if(!(custom_fields)){
	  utDmsg(ERRMSG,MSG_AT,"utDprint_table_data", "No custom data defined.\n" ) ;
	  return ;
	}
	format = custom_fields[field] ;
	if(!(format)){
	  utDmsgf(ERRMSG,MSG_AT,"utDprint_table_data", "No custom format defined for field:%s.\n",
	      field_name ) ;
	  return ;
	}
	break ;
      case PRTABLE_UNKNOWN_T:
      default:
	return ;
    }

    /* -----------------------------------------------------------------
     * First get the length of the buffer needed.
    ----------------------------------------------------------------- */
    va_start( args, format ) ;
    format_len = utDdstring_format_length(args,format) ;

    /* -----------------------------------------------------------------
     * Now allocate the size of the dynamic buffer to hold the format.
    ----------------------------------------------------------------- */
    if( table_dyna_bufS ){
      utDdstring_reinit( table_dyna_bufS ) ;
    } else {
      table_dyna_bufS = UTDMALLOC( 1, UTDDSTRING ) ;
      utDdstring_init( table_dyna_bufS ) ;
    }		
    buffer_p = utDdstring_setlength( table_dyna_bufS,format_len + 1) ;

    /* -----------------------------------------------------------------
     * Now that length is set, we can convert the format without problems.
    ----------------------------------------------------------------- */
    va_start( args, format ) ;
    vsprintf( buffer_p, format, args ) ;
    va_end(args) ;

    data_p = table_p->last_rec ;
    if(!(data_p)){
      return ;
    }
    data_p->data[field-1] = prtable_alloc_string(table_p, buffer_p) ;
} /* utDprint_table_data() */



INT utDprint_table_floating_precision( UTDPRINT_TABLEPTR table_p, INT precision )
{
    if( table_p ){
      if( precision == -1 ){
	table_p->floating_pt_precision = UTDPRINT_TABLE_FLOAT_PRECISION ;
      } else if( precision >= 0 ){
	table_p->floating_pt_precision = precision ;
      }
      return( table_p->floating_pt_precision ) ;
    }
    return( 0 ) ;
} /* end utDprint_table_floating_precision() */

void utDprint_table_string_data( UTDPRINT_TABLEPTR table_p, char *field_name, char *string )
{
    INT field ;				/* field index */
    UTDPRINT_DATAPTR data_p ;		/* new data record */

    /* -----------------------------------------------------------------
     * First get field index.
     * ----------------------------------------------------------------- */
    field = utDprint_table_field_index( table_p, field_name ) ;
    if(!(field)){
      return ;
    }
    data_p = table_p->last_rec ;
    if(!(data_p)){
      return ;
    }
    data_p->data[field-1] = prtable_alloc_string(table_p, string) ;
} /* utDprint_table_string_data() */


void utDprint_table( UTDPRINT_TABLEPTR table_p, FILE *fp )
{
    INT f ;				/* field counter */
    INT k ;				/* counter */
    INT len ;				/* length of current string */
    INT slen ;				/* length of current string data */
    INT *lengths ;			/* record the lengths of the fields */
    INT offset ;			/* offset to start of string */
    INT remainder ;			/* remainder of blanks */
    BOOL fhidden ;			/* hidden column header */
    char *str ;				/* current string */
    UTDPRINT_DATAPTR data_p ;		/* new data record */
    PRTABLE_JUSTIFY_T justify ;		/* justification */

    /* -----------------------------------------------------------------
     * First calculate lengths of strings in each column.
      ----------------------------------------------------------------- */
    lengths = UTDVECTOR_CALLOC( 1, table_p->num_fields, INT ) ;
    for( f = 1 ; f <= table_p->num_fields ; f++ ){
      str = table_p->field_names[f] ;
      if( str ){
	len = strlen( str ) ;
	if( len > lengths[f] ){
	  lengths[f] = len ;
	}
      }
    }
    for( data_p = table_p->first_rec ; data_p ; data_p = data_p->next_data ){
      for( f = 1 ; f <= table_p->num_fields ; f++ ){
	str = data_p->data[f-1] ;
	if( str ){
	  len = strlen( str ) ;
	  if( len > lengths[f] ){
	    lengths[f] = len ;
	  }
	}
      }
    }

    /* -----------------------------------------------------------------
     * Next print the table.  First the header.
      ----------------------------------------------------------------- */
    for( f = 1 ; f <= table_p->num_fields ; f++ ){
      if( table_p->left_margin ){
	fprintf( fp, "%s", table_p->left_margin ) ;
      }
      str = table_p->field_names[f] ;
      len = lengths[f] ;
      justify = table_p->justification[f] ;
      if( f > 1 ){
	prtable_column_space( table_p, fp ) ;
      }
      fhidden = utDprint_table_hidden_field_type( table_p->field_type[f] ) ;
      if( fhidden ){
	fprintf( fp, "%*s", len, " " ) ;
      } else {
	switch( justify ){
	  case PRTABLE_JUSTIFY_CENTER_T:
	    slen = strlen( str ) ;
	    if( slen < len ){
	      offset = (len - slen) / 2 ;
	      fprintf( fp, "%-*s", offset, " " ) ;
	      remainder = len - offset ;
	      fprintf( fp, "%-*s", remainder, str ) ;
	    } else {
	      fprintf( fp, "%*s", len, str ) ;
	    }
	    break ;

	  case PRTABLE_JUSTIFY_LEFT_T:
	    fprintf( fp, "%-*s", len, str ) ;
	    break ;
	  case PRTABLE_JUSTIFY_RIGHT_T:
	    fprintf( fp, "%*s", len, str ) ;
	    break ;

	}
      }
    }
    fprintf( fp, "\n" ) ;

    /* -----------------------------------------------------------------
     * Next underline the header.
      ----------------------------------------------------------------- */
    for( f = 1 ; f <= table_p->num_fields ; f++ ){
      if( table_p->left_margin ){
	fprintf( fp, "%s", table_p->left_margin ) ;
      }
      len = lengths[f] ;
      if( f > 1 ){
	prtable_column_space( table_p, fp ) ;
      }
      for( k = 1 ; k <= len ; k++ ){
	fprintf( fp, "-" ) ;
      }
    }
    fprintf( fp, "\n" ) ;

    /* -----------------------------------------------------------------
     * Finally, the data.
      ----------------------------------------------------------------- */
    for( data_p = table_p->first_rec ; data_p ; data_p = data_p->next_data ){
      for( f = 1 ; f <= table_p->num_fields ; f++ ){
	if( table_p->left_margin ){
	  fprintf( fp, "%s", table_p->left_margin ) ;
	}
	str = data_p->data[f-1] ;
	len = lengths[f] ;
	justify = table_p->justification[f] ;
	if( f > 1 ){
	  prtable_column_space( table_p, fp ) ;
	}
	if( str ){
	  switch( justify ){
	    case PRTABLE_JUSTIFY_CENTER_T:
	      slen = strlen( str ) ;
	      if( slen < len ){
		offset = (len - slen) / 2 ;
		fprintf( fp, "%-*s", offset, " " ) ;
		remainder = len - offset ;
		fprintf( fp, "%-*s", remainder, str ) ;
	      } else {
		fprintf( fp, "%*s", len, str ) ;
	      }
	      break ;

	    case PRTABLE_JUSTIFY_LEFT_T:
	      fprintf( fp, "%-*s", len, str ) ;
	      break ;
	    case PRTABLE_JUSTIFY_RIGHT_T:
	      fprintf( fp, "%*s", len, str ) ;
	      break ;

	  }
	} else {
	  fprintf( fp, "%*s", len, " " ) ;
	}
      }
      fprintf( fp, "\n" ) ;
    }

    UTDVECTOR_FREE( lengths, 1 ) ;

} /* end utDprint_table() */

char *utDprint_table_item( UTDPRINT_TABLEPTR table_p, INT row, char *field_name )
{
    INT cnt ;				/* count rows */
    INT field ;				/* field index */
    char *str ;				/* return string */
    UTDPRINT_DATAPTR data_p ;		/* new data record */

    cnt = 0 ;
    field = utDprint_table_field_index( table_p, field_name ) ;
    if(!(field)){
      return(NULL) ;
    }
    for( data_p = table_p->first_rec ; data_p ; data_p = data_p->next_data ){
      if( ++cnt == row ){
	if( field > 0 && field <= table_p->num_fields ){
	  str = data_p->data[field-1] ;
	  return( str ) ;
	}
	break ;
      }
    }
    return(NULL) ;
} /* end utDprint_table_item() */

char *utDprint_table_msg( UTDPRINT_TABLEPTR table_p, UTDDSTRINGPTR msg_p )
{
    INT f ;				/* field counter */
    INT k ;				/* counter */
    INT len ;				/* length of current string */
    INT slen ;				/* length of current string data */
    INT *lengths ;			/* record the lengths of the fields */
    INT offset ;			/* offset to start of string */
    INT remainder ;			/* remainder of blanks */
    char *str ;				/* current string */
    char fmt[80] ;			/* build format string */
    BOOL fhidden ;			/* hidden attribute */
    PRTABLE_JUSTIFY_T justify ;		/* justification */
    UTDPRINT_DATAPTR data_p ;		/* new data record */
    UTDDSTRING tmp_msg ;		/* temporary message */

    /* -----------------------------------------------------------------
     * First calculate lengths of strings in each column.
      ----------------------------------------------------------------- */
    lengths = UTDVECTOR_CALLOC( 1, table_p->num_fields, INT ) ;
    for( f = 1 ; f <= table_p->num_fields ; f++ ){
      str = table_p->field_names[f] ;
      if( str ){
	len = strlen( str ) ;
	if( len > lengths[f] ){
	  lengths[f] = len ;
	}
      }
    }
    for( data_p = table_p->first_rec ; data_p ; data_p = data_p->next_data ){
      for( f = 1 ; f <= table_p->num_fields ; f++ ){
	str = data_p->data[f-1] ;
	if( str ){
	  len = strlen( str ) ;
	  if( len > lengths[f] ){
	    lengths[f] = len ;
	  }
	}
      }
    }

    /* -----------------------------------------------------------------
     * Next print the table.  First the header.
      ----------------------------------------------------------------- */
    for( f = 1 ; f <= table_p->num_fields ; f++ ){
      if( table_p->left_margin ){
	utDdstring_append( msg_p, table_p->left_margin, -1 ) ;
      }
      str = table_p->field_names[f] ;
      len = lengths[f] ;
      justify = table_p->justification[f] ;
      if( f > 1 ){
	prtable_column_space_msg( table_p, msg_p ) ;
      }
      fhidden = utDprint_table_hidden_field_type( table_p->field_type[f] ) ;
      if( fhidden ){
	sprintf( fmt, "%%%ds", len ) ;
	utDdstring_printf( msg_p, fmt, " " ) ;
      } else {
	switch( justify ){
	  case PRTABLE_JUSTIFY_CENTER_T:
	    slen = strlen( str ) ;
	    if( slen < len ){
	      offset = (len - slen) / 2 ;
	      sprintf( fmt, "%%-%ds", offset ) ;
	      utDdstring_printf( msg_p, fmt, " " ) ;
	      remainder = len - offset ;
	      sprintf( fmt, "%%-%ds", remainder ) ;
	      utDdstring_printf( msg_p, fmt, str ) ;
	    } else {
	      sprintf( fmt, "%%%ds", len ) ;
	      utDdstring_printf( msg_p, fmt, str ) ;
	    }
	    break ;
	  case PRTABLE_JUSTIFY_LEFT_T:
	    sprintf( fmt, "%%-%ds", len ) ;
	    utDdstring_printf( msg_p, fmt, str ) ;
	    break ;
	  case PRTABLE_JUSTIFY_RIGHT_T:
	    sprintf( fmt, "%%%ds", len ) ;
	    utDdstring_printf( msg_p, fmt, str ) ;
	    break ;
	}
      }
    }
    utDdstring_append( msg_p, "\n", -1 ) ;

    /* -----------------------------------------------------------------
     * Next underline the header.
      ----------------------------------------------------------------- */
    for( f = 1 ; f <= table_p->num_fields ; f++ ){
      if( table_p->left_margin ){
	utDdstring_append( msg_p, table_p->left_margin, -1 ) ;
      }
      len = lengths[f] ;
      if( f > 1 ){
	prtable_column_space_msg( table_p, msg_p ) ;
      }
      for( k = 1 ; k <= len ; k++ ){
	utDdstring_append( msg_p, "-", -1 ) ;
      }
    }
    utDdstring_append( msg_p, "\n", -1 ) ;

    /* -----------------------------------------------------------------
     * Finally, the data.
      ----------------------------------------------------------------- */
    utDdstring_init( &tmp_msg ) ;
    for( data_p = table_p->first_rec ; data_p ; data_p = data_p->next_data ){
      utDdstring_reinit(&tmp_msg) ;
      for( f = 1 ; f <= table_p->num_fields ; f++ ){
	if( table_p->left_margin ){
	  utDdstring_append( &tmp_msg, table_p->left_margin, -1 ) ;
	}
	str = data_p->data[f-1] ;
	len = lengths[f] ;
	justify = table_p->justification[f] ;
	if( f > 1 ){
	  prtable_column_space_msg( table_p, &tmp_msg ) ;
	}
	if( str ){
	  switch( justify ){
	    case PRTABLE_JUSTIFY_CENTER_T:
	      slen = strlen( str ) ;
	      if( slen < len ){
		offset = (len - slen) / 2 ;
		sprintf( fmt, "%%-%ds", offset ) ;
		utDdstring_printf( &tmp_msg, fmt, " " ) ;
		remainder = len - offset ;
		sprintf( fmt, "%%-%ds", remainder ) ;
		utDdstring_printf( &tmp_msg, fmt, str ) ;
	      } else {
		sprintf( fmt, "%%%ds", len ) ;
		utDdstring_printf( &tmp_msg, fmt, str ) ;
	      }
	      break ;
	    case PRTABLE_JUSTIFY_LEFT_T:
	      sprintf( fmt, "%%-%ds", len ) ;
	      utDdstring_printf( &tmp_msg, fmt, str ) ;
	      break ;
	    case PRTABLE_JUSTIFY_RIGHT_T:
	      sprintf( fmt, "%%%ds", len ) ;
	      utDdstring_printf( &tmp_msg, fmt, str ) ;
	      break ;
	  }

	} else {
	  sprintf( fmt, "%%%ds", len ) ;
	  utDdstring_printf( &tmp_msg, fmt, " " ) ;
	}
      }
      utDdstring_append( &tmp_msg, "\n", -1 ) ;
      utDdstring_append( msg_p, utDdstring_value(&tmp_msg), -1 ) ;
    }

    UTDVECTOR_FREE( lengths, 1 ) ;
    utDdstring_free(&tmp_msg) ;

    return( utDdstring_value(msg_p) ) ;

} /* end utDprint_table_msg() */

static void prtable_column_space( UTDPRINT_TABLEPTR table_p, FILE *fp )
{
    INT c ;				/* counter */ 
    for( c = 1 ; c <= table_p->column_space ; c++ ){
      fprintf( fp, " " ) ;
    }
} /* end prtable_column_space() */


static void prtable_column_space_msg( UTDPRINT_TABLEPTR table_p,UTDDSTRINGPTR msg_p)
{
    INT c ;				/* counter */ 
    for( c = 1 ; c <= table_p->column_space ; c++ ){
      utDdstring_append( msg_p, " ", -1 ) ;
    }
} /* end prtable_column_space_msg() */

/* -----------------------------------------------------------------
 * Allocate a string from the pool.  Grab another block if needed.
----------------------------------------------------------------- */
static char *prtable_alloc_string(UTDPRINT_TABLEPTR table_p, const char *str)
{
  INT space ;				/* amount of space needed */
  STR_POOLPTR p ;			/* string pool */
  char *mem_addr ;			/* return address of string */
  STR_OVERFLOW_PTR large_string_p ;	/* large string record */
  STR_OVERFLOW_PTR next_large_string ;	/* enumerate large strings */

  space = strlen(str) + 1 ;

  if( space > STR_POOL_SIZE ) {
    next_large_string = table_p->string_overflow ;
    large_string_p = table_p->string_overflow = UTDMALLOC( 1, STR_OVERFLOW ) ;
    large_string_p->next_string = next_large_string ;
    large_string_p->string = utDstrclone( (char *) str ) ;
    return( large_string_p->string ) ;
    /* 
    M2(ERRMSG,"str_alloc", 
      "Internal error: String too long! Over %;d characters! Please report.\n",
      STR_POOL_SIZE ) ;
    M2(ERRMSG,NULL, "string (truncated to 100 chars): %100s\n\n", str ) ;
    Yprogram_exit(PGMFAIL) ;
    */
  }
  if( space > table_p->num_left ) {
    p = UTDMALLOC( 1, STR_POOL ) ;
    /* -----------------------------------------------------------------
     * chain these together so STR_destroy_stringtab can free all blocks.
    ----------------------------------------------------------------- */
    p->next_string_pool = table_p->pool_base ;
    table_p->pool_base = p ;
    table_p->pool = &(p->string_data[0]) ;
    table_p->num_left = STR_POOL_SIZE ;
  }
  mem_addr = table_p->pool ;
  table_p->pool += space ;
  table_p->num_left -= space ;
  strcpy(mem_addr, str) ;
  return(mem_addr) ;
} /* end prtable_alloc_string() */

static void prtable_free_strings(UTDPRINT_TABLEPTR table_p)
{
    STR_POOLPTR next ;			/* next pool to free */
    STR_OVERFLOW_PTR next_large_string ;/* next large string to free */

    /* free all the string blocks, if allocated  */
    for( ; table_p->pool_base ; ) {
      next = table_p->pool_base->next_string_pool ;
      UTDFREE(table_p->pool_base) ;
      table_p->pool_base = next ;
    }

    for( ; table_p->string_overflow ; ) {
      next_large_string = table_p->string_overflow->next_string ;
      if( table_p->string_overflow->string ){
	UTDFREE(table_p->string_overflow->string) ;
      }
      UTDFREE(table_p->string_overflow) ;
      table_p->string_overflow = next_large_string ;
    }
} /* end prtable_free_strings() */


#else /* TEST */

int main(int argc,char **argv)
{
    BOOL mem_test ;			/* test memory dumper */
    UTDPRINT_TABLEPTR table_p ;		/* make a table */
    UTDDSTRING mbuf ;			/* dynamic string for storage */ 
    char *msg_p ;			/* value of the string */

    /* -----------------------------------------------------------------
     * If mem_test is on we will determine the memory leak from the debug
     * code and the creation of a string.
    ----------------------------------------------------------------- */
    mem_test = FALSE ;

    if( mem_test ){
      Ymalloc_debug(MALLOC_DEBUG|MALLOC_DUMP);
    }
    utDdebug_init(mem_test);

    table_p = utDprint_table_init() ;
    utDprint_table_add_field(table_p, "Node", PRTABLE_INTEGER_T, "Node", NULL ) ;
    utDprint_table_add_field(table_p, "Inst", PRTABLE_STRING_T, "I1", NULL ) ;
    utDprint_table_add_field(table_p, "Model", PRTABLE_CUSTOM_T, "model", "%-s" ) ;
    utDprint_table_add_field(table_p, "Arrival Time", PRTABLE_FLOAT_T, "Ar", NULL ) ;
    utDprint_table_justification(table_p, "model", PRTABLE_JUSTIFY_LEFT_T ) ;
    utDprint_table_justification(table_p, "model", PRTABLE_JUSTIFY_RIGHT_T ) ;
    utDprint_table_justification(table_p, "model", PRTABLE_JUSTIFY_CENTER_T ) ;
    utDprint_new_record( table_p ) ;
    utDprint_table_data( table_p, "Node", 5 ) ;
    utDprint_table_data( table_p, "Inst", "master_out" ) ;
    utDprint_table_data( table_p, "model", "myvery_long_model_name" ) ;
    utDprint_table_data( table_p, "Ar", 2.21e-8 ) ;

    utDprint_new_record( table_p ) ;
    utDprint_table_data( table_p, "Node", 6 ) ;
    utDprint_table_data( table_p, "I1", "i10" ) ;
    utDprint_table_data( table_p, "model", "mo" ) ;
    utDprint_table_data( table_p, "Ar", 1.50 ) ;

    utDprint_table( table_p, stderr ) ;

    fprintf( stderr, "\n\nNow print using the dynamic string mechanism\n" ) ;
    utDstring_init( &mbuf ) ;
    msg_p = utDprint_table_msg( table_p, &mbuf ) ;
    fprintf( stderr, "%s\n\n", msg_p ) ;

    utDstring_free( &mbuf ) ;
    utDprint_table_free( table_p ) ;

    exit(0) ;
    return(0) ;
}
#endif /* TEST */
