/* ----------------------------------------------------------------- 
     Copyright (c) 2021 William Swartz.  All rights reserved.
     Copyright (c) 1993-2021 TimberWolf Systems, Inc. All rights reserved.
FILE:	     prtable.h 
DESCRIPTION: prototypes for the utD table print functions.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_utD_LOG_H
#define INCLUDED_utD_LOG_H

/* -----------------------------------------------------------------
 * Define the types of fields.
 * ----------------------------------------------------------------- */
typedef enum {
    PRTABLE_UNKNOWN_T 	= -1,
    PRTABLE_INTEGER_T 	= 0,
    PRTABLE_FLOAT_T 	= 1,
    PRTABLE_STRING_T 	= (1L << 1 ),
    PRTABLE_CUSTOM_T 	= (1L << 2 ),
    PRTABLE_HIDDEN_T 	= (1L << 3 )
} PRTABLE_FIELD_TYPE_T ;

typedef enum {
    PRTABLE_JUSTIFY_RIGHT_T 	= 0,
    PRTABLE_JUSTIFY_LEFT_T 	= 1,
    PRTABLE_JUSTIFY_CENTER_T 	= 2
} PRTABLE_JUSTIFY_T ;

typedef struct print_table_string_overflow_rec {
  char *string ;
  struct print_table_string_overflow_rec *next_string ;
} STR_OVERFLOW, *STR_OVERFLOW_PTR ;

typedef struct print_table_rec {
  INT data_pool ;			/* data pool id for print data */
  INT array_pool ;			/* array pool id for print data */
  INT num_left ;			/* number of bytes left in pool */
  INT num_fields ;			/* number of columns in table */
  INT num_records ;			/* number of rows/records in table */
  INT column_space ;			/* space between columns */
  INT floating_pt_precision ;		/* floating point precision */
  char *pool ;				/* points to a block of usable mem */
  struct prtable_pool_rec *pool_base ; 	/* memory pool of string */
  struct prtable_data_rec *first_rec ; 	/* first record to print */
  struct prtable_data_rec *last_rec ; 	/* current end of records */
  char **field_names ;			/* names of fields */
  char **custom_fields ;		/* custom field configuration */
  char **field_aliases ;		/* short name for field */
  PRTABLE_JUSTIFY_T *justification ;	/* field justification */
  char *left_margin ;			/* left margin string */
  PRTABLE_FIELD_TYPE_T *field_type ;	/* field types */
  STR_OVERFLOW_PTR string_overflow ;	/* very large strings */
} UTDPRINT_TABLE, *UTDPRINT_TABLEPTR ;

#define utDprint_table_column_space_get( t_xz )	( (t_xz)->column_space )
#define utDprint_table_margin_get( t_xz )		( (t_xz)->left_margin )
#define utDprint_table_simple_field_type( t_xz )	( (t_xz) & 0x7 )
#define utDprint_table_hidden_field_type( t_xz )	( (t_xz) & PRTABLE_HIDDEN_T )
#define utDprint_table_justification_type( t_xz, field_xz )	(t_xz)->justification[(field_xz)]

#define UTDPRINT_TABLE_FLOAT_PRECISION 	6

extern UTDPRINT_TABLEPTR utDprint_table_init(void) ;
/*
Function:
    Create a new table print structure and return a pointer the object.
*/

extern void utDprint_table_free( UTDPRINT_TABLEPTR table_p ) ;
/*
Function:
    Free a table print structure.
*/

extern void utDprint_table_add_field( UTDPRINT_TABLEPTR table_p, char *header,
                              PRTABLE_FIELD_TYPE_T field_type, char *alias,
			      char *custom_field ) ;
/*
Function:
    Define a tables fields.  Alias may be null.  Custom field may be defined
    as NULL.
*/


extern void utDprint_table_justification( UTDPRINT_TABLEPTR table_p, char *field_name, 
                                        PRTABLE_JUSTIFY_T justification ) ;
/*
Function:
    Allows user to set the justification of a field: left, center or right.
*/

extern INT utDprint_table_field_index( UTDPRINT_TABLEPTR table_p, char *field_name ) ;
/*
Function:
    Returns field index.
*/

extern PRTABLE_FIELD_TYPE_T utDprint_table_field_type( UTDPRINT_TABLEPTR table_p, char *field_name ) ;
/*
Function:
    Returns field type.
*/

extern PRTABLE_FIELD_TYPE_T utDprint_table_custom_type( UTDPRINT_TABLEPTR table_p, char *field_name ) ;
/*
Function:
    Returns field type based on custom format.
*/

extern void utDprint_table_field_hidden_type( UTDPRINT_TABLEPTR table_p, char *field_name, BOOL hidden ) ;
/*
Function:
    Sets the hidden field attribute.
*/

extern void utDprint_table_column_space( UTDPRINT_TABLEPTR table_p, INT space ) ;
/*
Function:
    Set space between columns.
*/

extern void utDprint_table_margin( UTDPRINT_TABLEPTR table_p, char *margin_string) ;
/*
Function:
    Set left margin string.
*/

extern void utDprint_new_record( UTDPRINT_TABLEPTR table_p ) ;
/*
Function:
    Start a new record.
*/

extern void utDprint_table_data( UTDPRINT_TABLEPTR table_p, char *field, ... ) ;
/*
Function:
    Added data to a field.
*/

extern void utDprint_table_string_data( UTDPRINT_TABLEPTR table_p, char *field, 
                                      char *data ) ;
/*
Function:
    Added string data to a field.
*/

extern char *utDprint_table_item( UTDPRINT_TABLEPTR table_p, INT row, char *field ) ;
/*
Function:
    Returns string from table.  Returns NULL if outside table.
*/

void utDprint_table( UTDPRINT_TABLEPTR table_p, FILE *fp ) ;
/*
Function:
    Print table to a stream.
*/

char *utDprint_table_msg( UTDPRINT_TABLEPTR table_p, UTDDSTRINGPTR msg_p ) ;
/*
Function:
    Print table to a message dynamic string.
*/

INT utDprint_table_floating_precision( UTDPRINT_TABLEPTR table_p, INT precision ) ;
/*
Function:
    Set the floating point precision value.
*/

#endif /* YPTRABLE_H */
