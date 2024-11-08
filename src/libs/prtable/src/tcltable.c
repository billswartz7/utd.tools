/* ----------------------------------------------------------------- 
FILE:	    tcltable.c
DESCRIPTION:This file contains Tcl commands related to printing tables
CONTENTS:   
DATE:	    Wed Jun  2 22:46:20 CDT 2021
REVISIONS:  
 * $Log: tcltable.c,v $
----------------------------------------------------------------- */
#include <cometconfig.h>

#include <tcl/tcl.h>
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */
#include <utd/base.h>
#include <utd/baseobj.h>
#include <utd/msg.h>
#include <utd/dstring.h>
#include <utd/string.h>
#include <base/utd.h>
#include <utd/prtable.h>

/* ********************** TYPE DEFINITIONS ************************* */
typedef struct {
  UTDPRINT_TABLEPTR prtable ;		/* print table */
  UTDDSTRING mbuf ;			/* message buffer */
} TABLE_INFO, *TABLE_INFOPTR ;

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static BOOL table_help( INT objc, Tcl_Obj * CONST objv[] ) ;
static INT table_objfunc(ClientData dp,Tcl_Interp *i_p,INT objc,
                          Tcl_Obj * CONST objv[]) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */

INT Utd_table_Init( Tcl_Interp *i_p )
{
    INT code ;			/* return code */

    code = Tcl_PkgProvide(i_p, "utd_table", "1.0" ) ;
    if( code != TCL_OK ){
      return(code) ;
    }
    Tcl_CreateObjCommand(i_p,"utdtable", table_objfunc, NULL, NULL ) ;
    return(TCL_OK) ;

} /* end Itools_table_Init() */

static INT table_objfunc(ClientData dp,Tcl_Interp *i_p,INT objc,
                          Tcl_Obj * CONST objv[])
{

  INT idx ;			/* option index */
  INT row ;			/* row index */
  INT hidden ;			/* hidden state */
  INT alias_objc ;		/* alias object max count */
  INT status ;			/* return status */
  INT intval ;			/* integer value */
  INT field_idx ;		/* field index */
  INT precision ;		/* floating point precision */
  INT columnspace ;		/* amount of column space */
  DOUBLE fval ;			/* floating point value */
  char *msg_p ;			/* string */
  char *argv_1 ;		/* first argument */
  char *type_p ;		/* type of field */
  char *alias ;			/* field alias */
  char *margin ;		/* margin string */
  char *header_p ;		/* header or field name */
  char *routine ;		/* name of routine */
  char *cmd_name ;		/* command name */
  char *justify_string ;	/* justify string */
  char *custom_format ;		/* custom format */
  Tcl_Obj *numObj ;		/* number object */
  Tcl_Obj *strObj ;		/* string object */
  Tcl_Obj *resultPtr ;		/* result of command */
  PRTABLE_FIELD_TYPE_T type ;	/* field type */
  TABLE_INFOPTR table_p ;	/* table information */
  PRTABLE_FIELD_TYPE_T ftype ;	/* field type */
  PRTABLE_FIELD_TYPE_T ctype ;	/* custom field type */
  PRTABLE_JUSTIFY_T justify ;	/* field justification */
  char buffer[80] ;		/* command buffer */
  char name_buffer[80] ;	/* command buffer */
  static INT tidL = 0 ;		/* unique table id */

  static char *optionStrings[] = {
    "addfield",	
    "columnspace", 
    "create", 	
    "data",
    "fprecision",
    "free", 	
    "hidden", 	
    "item", 	
    "justify", 	
    "margin",
    "newrecord",
    "print",
    NULL
  } ;

  enum options {
    TABLE_ADDFIELD_T, 
    TABLE_COLUMNSPACE_T, 
    TABLE_CREATE_T,
    TABLE_DATA_T,
    TABLE_FPRECISION_T,
    TABLE_FREE_T,
    TABLE_HIDDEN_T,
    TABLE_ITEM_T,
    TABLE_JUSTIFY_T,
    TABLE_MARGIN_T,
    TABLE_NEWRECORD_T,
    TABLE_PRINT_T
  } ;

  // routine = utDbase_cmdname( objv[0] ) ;
  routine = "foo" ;

  if( (objc < 2) || table_help(objc,objv) ){
    Tcl_SetObjResult( i_p, Tcl_NewStringObj("Incorrect usage",-1) ) ;
    utDmsgf( ERRMSG, MSG_AT, routine, "Usage:") ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# addfield <fieldName> <type> [alias] : define a field \
in the table.  The type of allowed field types are string, float, and integer. \
The header alias is useful for long field names.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# addfield <fieldName> custom <format> [alias] : define \
a field with a custom format.  Format is C printf form.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# columnspace <space> : specify the space between \
columns in table.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s create : creat a print table object.  Returns \
unique object id.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# data <fieldName|alias> <data> : add data to \
the current record under the specified field.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# free : free print table object.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# hidden <fieldName|alias> [0|1] : set/returns whether \
header name is output.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# item <row> <fieldName|alias> : returns item at table specified \
by the row and field.   Returns NULL if outside the current table.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# justify <fieldName|alias> <left | center | right> : sets the \
justification of a field.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# margin [string] : returns/adds a margin string before start of first \
column.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# newrecord : start a new record.", routine ) ;
    utDmsgf( ERRMSG, MSG_AT, NULL, "%s# print : output the formatted table.", routine ) ;
    return( TCL_ERROR ) ;
  }

  resultPtr = Tcl_GetObjResult(i_p) ;

  if( Tcl_GetIndexFromObj(i_p,objv[1],optionStrings,"option", 0, &idx ) != TCL_OK ){
    return(TCL_ERROR) ;
  }
  argv_1 = Tcl_GetString( objv[1] ) ;
  table_p = (TABLE_INFOPTR) dp ;
  switch ( (enum options) idx) {
    case TABLE_ADDFIELD_T:
      /* %s# addfield <fieldName> <type> [custom_format] [alias] */
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      if( objc < 4 ){
	utDmsgf(ERRMSG,MSG_AT,routine,"Not enough arguments to the ictable addfield command.\n" ) ;
	return(TCL_ERROR) ;
      }
      header_p = Tcl_GetString( objv[2] ) ;
      type_p = Tcl_GetString( objv[3] ) ;
      type = PRTABLE_STRING_T ;
      alias_objc = 5 ;
      custom_format = NULL ;
      if( utDstricmp( type_p, "string" ) == STRINGEQ ){
	type = PRTABLE_STRING_T ;
      } else if( utDstricmp( type_p, "integer" ) == STRINGEQ ){
	type = PRTABLE_INTEGER_T ;
      } else if( utDstricmp( type_p, "float" ) == STRINGEQ ){
	type = PRTABLE_FLOAT_T ;
      } else if( utDstricmp( type_p, "custom" ) == STRINGEQ ){
	type = PRTABLE_CUSTOM_T ;
	if( objc < 5 ){
	  utDmsgf(ERRMSG,MSG_AT,routine,"Missing format for custom type field:%s\n", header_p ) ;
	  return(TCL_ERROR) ;
	}
	custom_format = Tcl_GetString( objv[4] ) ;
	alias_objc++ ;
      } else {
	utDmsgf(ERRMSG,MSG_AT,routine,"Unknown field type:%s\n", type_p ) ;
	return(TCL_ERROR) ;
      }
      if( objc == alias_objc ){
	alias = Tcl_GetString( objv[alias_objc-1] ) ;
      } else {
	alias = NULL ;
      }
      utDprint_table_add_field( table_p->prtable, header_p, type, alias, custom_format ) ;
      return(TCL_OK) ;

    case TABLE_COLUMNSPACE_T:
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      if( objc >= 3 ){
	if( Tcl_GetIntFromObj(i_p,objv[2],&columnspace) != TCL_OK ){
	  return(TCL_ERROR) ;
	}
	utDprint_table_column_space( table_p->prtable, columnspace ) ;
      }
      columnspace = utDprint_table_column_space_get( table_p->prtable ) ;
      numObj = Tcl_NewIntObj( columnspace ) ;
      Tcl_ListObjAppendElement(NULL,resultPtr, numObj) ;
      return(TCL_OK) ;
      
    case TABLE_DATA_T:
      /* %s# data <fieldName|alias> <data> */
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      if( objc < 4 ){
	utDmsgf(ERRMSG,MSG_AT,routine,"Not enough arguments to the ictable data command.\n" ) ;
	return(TCL_ERROR) ;
      }
      header_p = Tcl_GetString( objv[2] ) ;
      type = utDprint_table_field_type( table_p->prtable, header_p ) ;
      type = utDprint_table_simple_field_type( type ) ;
      if( objc >= 5 ){
	/* The data is to be interpreted as a string regardless of type */
	msg_p = Tcl_GetString( objv[3] ) ;
	utDprint_table_string_data( table_p->prtable, header_p, msg_p ) ;
	return(TCL_OK) ;
      }
      switch( type ){
	case PRTABLE_STRING_T:
	  msg_p = Tcl_GetString( objv[3] ) ;
	  utDprint_table_data( table_p->prtable, header_p, msg_p ) ;
	  break ;
	case PRTABLE_FLOAT_T:
	  if( Tcl_GetDoubleFromObj(i_p,objv[3],&fval) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	  utDprint_table_data( table_p->prtable, header_p, fval ) ;
	  break ;
	case PRTABLE_INTEGER_T:
	  if( Tcl_GetIntFromObj(i_p,objv[3],&intval) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	  utDprint_table_data( table_p->prtable, header_p, intval ) ;
	  break ;
	case PRTABLE_CUSTOM_T:
	  ctype = utDprint_table_custom_type( table_p->prtable, header_p ) ;
	  if( ctype == PRTABLE_STRING_T ){
	    msg_p = Tcl_GetString( objv[3] ) ;
	    utDprint_table_data( table_p->prtable, header_p, msg_p ) ;
	  } else if( ctype == PRTABLE_FLOAT_T ){
	    if( Tcl_GetDoubleFromObj(i_p,objv[3],&fval) != TCL_OK ){
	      return(TCL_ERROR) ;
	    }
	    utDprint_table_data( table_p->prtable, header_p, fval ) ;
	  } else if( PRTABLE_INTEGER_T ){
	    if( Tcl_GetIntFromObj(i_p,objv[3],&intval) != TCL_OK ){
	      return(TCL_ERROR) ;
	    }
	    utDprint_table_data( table_p->prtable, header_p, intval ) ;
	  } else {
	    utDmsgf(ERRMSG,MSG_AT,routine, "unsupported custom format.\n" ) ;
	    return(TCL_ERROR) ;
	  }
	  break ;
	case PRTABLE_UNKNOWN_T:
	default:
	  utDmsgf(ERRMSG,MSG_AT,routine, "unknown field type for field:%s\n", header_p ) ;
	  return(TCL_ERROR) ;
      }
      return(TCL_OK) ;

    case TABLE_FPRECISION_T:
      /* ictable fprecision <value> */
      /* %s# data <fieldName|alias> <data> */
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      if( objc >= 3 ){
	if( Tcl_GetIntFromObj(i_p,objv[2],&precision) != TCL_OK ){
	  return(TCL_ERROR) ;
	}
	utDprint_table_floating_precision( table_p->prtable, precision ) ;
      }
      precision = utDprint_table_floating_precision( table_p->prtable, -2 ) ;
      numObj = Tcl_NewIntObj( precision ) ;
      Tcl_ListObjAppendElement(NULL,resultPtr, numObj) ;
      return(TCL_OK) ;

    case TABLE_MARGIN_T:
      /* %s# margin [string] */
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      if( objc >= 3 ){
	margin = Tcl_GetString( objv[2] ) ;
	utDprint_table_margin( table_p->prtable, margin ) ;
      }
      margin = utDprint_table_margin_get( table_p->prtable ) ;
      strObj = Tcl_NewStringObj( margin, -1 ) ;
      Tcl_ListObjAppendElement(NULL,resultPtr, strObj) ;
      return(TCL_OK) ;

    case TABLE_NEWRECORD_T:
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      utDprint_new_record( table_p->prtable ) ;
      return( TCL_OK ) ;

    case TABLE_CREATE_T:
      if( table_p ){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("print table already created",-1) ) ;
	return(TCL_ERROR) ;
      }
      table_p = UTDCALLOC( 1, TABLE_INFO) ;
      table_p->prtable = utDprint_table_init() ;
      utDdstring_init( &(table_p->mbuf) ) ;
      sprintf( buffer, "ictable%d", ++tidL ) ;
      Tcl_SetObjResult( i_p, Tcl_NewStringObj(buffer,-1) ) ;
      Tcl_CreateObjCommand( i_p, buffer, table_objfunc, table_p, NULL ) ;
      return( TCL_OK ) ;

    case TABLE_FREE_T:
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      utDprint_table_free( table_p->prtable ) ;
      utDdstring_free( &(table_p->mbuf) ) ;
      UTDFREE( table_p ) ;
      cmd_name = Tcl_GetString( objv[0] ) ;
      status = Tcl_DeleteCommand( i_p, cmd_name ) ;
      return( status ) ;

    case TABLE_HIDDEN_T:
      /* %s# hidden <fieldName|alias> [0|1] */
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      if( objc < 3 ){
	utDmsgf(ERRMSG,MSG_AT,routine,"Not enough arguments to the %s hidden command.\n", routine ) ;
	return(TCL_ERROR) ;
      }
      header_p = Tcl_GetString( objv[2] ) ;
      field_idx = utDprint_table_field_index( table_p->prtable, header_p ) ;
      if(!(field_idx)){
	utDmsgf(ERRMSG,MSG_AT,routine, "could not find table field: %s\n", header_p ) ;
	return(TCL_ERROR) ;
      }
      if( objc >= 4 ){
	if( Tcl_GetBooleanFromObj(i_p,objv[3],&hidden) != TCL_OK ){
	  return(TCL_ERROR) ;
	}
	utDprint_table_field_hidden_type( table_p->prtable, header_p, hidden ) ;
      }
      ftype = utDprint_table_field_type( table_p->prtable, header_p ) ;
      ftype = utDprint_table_hidden_field_type( ftype ) ;
      Tcl_SetObjResult( i_p, Tcl_NewBooleanObj(ftype) ) ;
      return(TCL_OK) ;

    case TABLE_ITEM_T:
      /* %s# item <row> <fieldName|alias> */
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      if( objc < 4 ){
	utDmsgf(ERRMSG,MSG_AT,routine,"Not enough arguments to the %s item command.\n", routine ) ;
	return(TCL_ERROR) ;
      }
      if( Tcl_GetIntFromObj(i_p,objv[2],&row) != TCL_OK ){
	return(TCL_ERROR) ;
      }
      header_p = Tcl_GetString( objv[3] ) ;
      field_idx = utDprint_table_field_index( table_p->prtable, header_p ) ;
      if(!(field_idx)){
	utDmsgf(ERRMSG,MSG_AT,routine, "could not find table field: %s\n", header_p ) ;
	return(TCL_ERROR) ;
      }
      msg_p = utDprint_table_item( table_p->prtable, row, header_p ) ;
      Tcl_SetObjResult( i_p, Tcl_NewStringObj( msg_p,-1) ) ;
      return(TCL_OK) ;

    case TABLE_JUSTIFY_T:
      /* %s# justify <fieldName|alias> <left|center|right> */
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("no table object supplied.",-1) ) ;
	return(TCL_ERROR) ;
      }
      if( objc < 3 ){
	utDmsgf(ERRMSG,MSG_AT,routine,"Not enough arguments to the %s justify command.\n", routine ) ;
	return(TCL_ERROR) ;
      }
      header_p = Tcl_GetString( objv[2] ) ;
      field_idx = utDprint_table_field_index( table_p->prtable, header_p ) ;
      if(!(field_idx)){
	utDmsgf(ERRMSG,MSG_AT,routine, "could not find table field: %s\n", header_p ) ;
	return(TCL_ERROR) ;
      }
      if( objc >= 4 ){
	justify_string = Tcl_GetString(objv[3]) ;
	if( utDstrnicmp( justify_string, "left", 1 ) == STRINGEQ ){
	  justify = PRTABLE_JUSTIFY_LEFT_T ;
	} else if( utDstrnicmp( justify_string, "center", 1 ) == STRINGEQ ){
	  justify = PRTABLE_JUSTIFY_CENTER_T ;
	} else if( utDstrnicmp( justify_string, "right", 1 ) == STRINGEQ ){
	  justify = PRTABLE_JUSTIFY_RIGHT_T ;
	} else {
	  justify = PRTABLE_JUSTIFY_RIGHT_T ;
	  utDmsgf(ERRMSG,MSG_AT,routine, "unknown justification: %s\n", justify_string ) ;
	  return(TCL_ERROR) ;
	}
	utDprint_table_justification( table_p->prtable, header_p, justify ) ;
      }
      justify = utDprint_table_justification_type( table_p->prtable, field_idx ) ;
      switch( justify ){
	case PRTABLE_JUSTIFY_RIGHT_T:
	  Tcl_SetObjResult( i_p, Tcl_NewStringObj("right",-1) ) ;
	  break ;
	case PRTABLE_JUSTIFY_CENTER_T:
	  Tcl_SetObjResult( i_p, Tcl_NewStringObj("center",-1) ) ;
	  break ;
	case PRTABLE_JUSTIFY_LEFT_T:
	  Tcl_SetObjResult( i_p, Tcl_NewStringObj("left",-1) ) ;
	  break ;
	default:
	  Tcl_SetObjResult( i_p, Tcl_NewStringObj("unknown",-1) ) ;
	  break ;
      }
      return(TCL_OK) ;

    case TABLE_PRINT_T:
      if(!(table_p)){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj("print table not specified",-1) ) ;
	return(TCL_ERROR) ;
      }
      utDdstring_reinit( &(table_p->mbuf) ) ;
      msg_p = utDprint_table_msg( table_p->prtable, &(table_p->mbuf) ) ;
      if( msg_p ){
	Tcl_SetObjResult( i_p, Tcl_NewStringObj(msg_p,-1) ) ;
      }
      return(TCL_OK) ;

    default :
      sprintf( buffer, "ERROR\[%s]: unknown option : %s", routine, argv_1 ) ;
      Tcl_SetObjResult( i_p, Tcl_NewStringObj(buffer,-1) ) ;
      return(TCL_ERROR) ;
  } /* end switch ( (enum options) index)... */

  return( TCL_OK ) ;

} /* end table_objfunc() */


static BOOL table_help( INT objc, Tcl_Obj * CONST objv[] )
{
    INT i ;				/* argc counter */
    char *str ;				/* current string */

    for( i = 1 ; i < objc ; i++ ){
      str = Tcl_GetString(objv[i]) ;
      if( *str == '-' ){
	if( (strcmp( str, "-help" ) == STRINGEQ) ||
	    (strcmp( str, "--help" ) == STRINGEQ) ){
	  return(TRUE) ;
	}
      }
    }
    return(FALSE) ;
} /* end table_help() */
