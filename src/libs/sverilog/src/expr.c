#include <sverilog_config.h>
#include <sverilog/sverilog.h>
#include "preprocessor.h"
#include <utd/debug.h>
#include <utd/file.h>
#include <utd/hash.h>
#include <utd/dstring.h>
#include <utd/string.h>
#include <utd/stringhash.h>
#include <sverilog/expr.h>

#ifdef DEBUG
extern void ebreak(void) ;
#endif /* DEBUG */

void sver_expr_init( SVERILOG_PARSEPTR parse_p ) 
{
    parse_p->expr_pool = UTDPOOL_INIT( 0, SVER_EXPR ) ;
    parse_p->expr_type_pool = UTDPOOL_INIT( 0, SVER_EXPR_TYPE ) ;
    parse_p->strings = utDstringhash_init(UTDSTR_HASH_TABLE_ALLOCS_KEYS,
				          UTDSTR_HASH_USE_CASE, FALSE ) ;
    utDdstring_init( &parse_p->temp_buf ) ;
} /* end sver_expr_init() */

void sver_expr_free( SVERILOG_PARSEPTR parse_p )
{
    UTDPOOL_FREE_POOL( parse_p->expr_pool ) ;
    UTDPOOL_FREE_POOL( parse_p->expr_type_pool ) ;
    utDstringhash_free( parse_p->strings, NULL ) ;
    utDdstring_free( &parse_p->temp_buf ) ;
} /* end sver_expr_free() */

SVER_EXPRPTR sver_expr_start_int_expr( SVERILOG_PARSEPTR parse_p, LONG data, char *string_rep, INT type )
{
    SVER_EXPRPTR expr_p ;			/* start an expression */
    SVER_EXPR_TYPEPTR expr_type_p ;		/* the type of an expression */
    char *string_equiv ;			/* equivalent string */
    char *string_added ;			/* this is the stored string */

    expr_p = UTDPOOL_CALLOC( parse_p->expr_pool, SVER_EXPR ) ;
    utDdstring_reinit( &parse_p->temp_buf ) ;
    expr_type_p = UTDPOOL_CALLOC( parse_p->expr_type_pool, SVER_EXPR_TYPE ) ;
    expr_type_p->token_type = type ;
    expr_type_p->data.int_value = data ;
    string_equiv = utDdstring_append( &parse_p->temp_buf, string_rep, -1 ) ;
    string_added = utDstringhash_add( parse_p->strings, string_equiv, NULL ) ;
    expr_p->string_equiv = string_added ;
    expr_p->num_vals = 1 ;
    expr_p->tokens = UTDVECTOR_MALLOC( 1, 1, SVER_EXPR_TYPEPTR ) ;
    expr_p->tokens[1] = expr_type_p ;
    return(expr_p) ;
} /* end sver_expr_start_int_expr() */

SVER_EXPRPTR sver_expr_start_float_expr( SVERILOG_PARSEPTR parse_p, DOUBLE data, char *string_rep, INT type )
{
    SVER_EXPRPTR expr_p ;			/* start an expression */
    SVER_EXPR_TYPEPTR expr_type_p ;		/* the type of an expression */
    char *string_equiv ;			/* equivalent string */
    char *string_added ;			/* this is the stored string */

    expr_p = UTDPOOL_CALLOC( parse_p->expr_pool, SVER_EXPR ) ;
    utDdstring_reinit( &parse_p->temp_buf ) ;
    expr_type_p = UTDPOOL_CALLOC( parse_p->expr_type_pool, SVER_EXPR_TYPE ) ;
    expr_type_p->token_type = type ;
    expr_type_p->data.double_value = data ;
    string_equiv = utDdstring_append( &parse_p->temp_buf, string_rep, -1 ) ;
    string_added = utDstringhash_add( parse_p->strings, string_equiv, NULL ) ;
    expr_p->string_equiv = string_added ;
    expr_p->num_vals = 1 ;
    expr_p->tokens = UTDVECTOR_MALLOC( 1, 1, SVER_EXPR_TYPEPTR ) ;
    expr_p->tokens[1] = expr_type_p ;
    return(expr_p) ;
} /* end sver_expr_start_float_expr() */

SVER_EXPRPTR sver_expr_start_string_expr( SVERILOG_PARSEPTR parse_p, char *data, INT type )
{
    SVER_EXPRPTR expr_p ;			/* start an expression */
    SVER_EXPR_TYPEPTR expr_type_p ;		/* the type of an expression */
    char *string_added ;			/* this is the stored string */

    expr_p = UTDPOOL_CALLOC( parse_p->expr_pool, SVER_EXPR ) ;
    expr_type_p = UTDPOOL_CALLOC( parse_p->expr_type_pool, SVER_EXPR_TYPE ) ;
    expr_type_p->token_type = type ;
    string_added = utDstringhash_add( parse_p->strings, data, NULL ) ;
    expr_p->string_equiv = string_added ;
    expr_type_p->data.string = string_added ;/* same as equivalent string */
    expr_p->num_vals = 1 ;
    expr_p->tokens = UTDVECTOR_MALLOC( 1, 1, SVER_EXPR_TYPEPTR ) ;
    expr_p->tokens[1] = expr_type_p ;
    return(expr_p) ;
} /* end sver_expr_start_string_expr() */

SVER_EXPR_TYPEPTR sver_expr_get_token( SVER_EXPRPTR expr_p, INT token_id )
{
    if( expr_p && (token_id > 0) && (token_id <= expr_p->num_vals) ){
      return( expr_p->tokens[token_id] ) ;
    }
    return(NULL) ;
} /* end sver_expr_get_token() */

SVER_EXPRPTR sver_expr_add_index( SVERILOG_PARSEPTR parse_p, SVER_EXPRPTR expr_p,char *index_string ) 
{
    INT index_argc ;			/* index argument */
    char *input_string ;		/* input string */
    char **index_argv ;			/* parse input vector */
    char *string_added ;		/* this is the stored string */
    SVER_EXPRPTR index_expr_p ;		/* new expression */
    SVER_EXPR_TYPEPTR index_expr_type_p;/* new token identifier */

    FUNC_NAME("sver_expr_add_index") ;
    if(!(parse_p)){
      utDmsgf(ERRMSG,routine,MSG_AT,"Improper use of %s\n", routine ) ;
      return(NULL) ; /* we can't do anything */
    }
    if(!(expr_p)){
      utDmsgf(ERRMSG,routine,MSG_AT,"Unexpected NULL expression.\n", routine ) ;
      return(NULL) ; /* we can't do anything */
    }
    utDdstring_reinit( &parse_p->temp_buf ) ;
    input_string = utDdstring_append( &parse_p->temp_buf, index_string, -1 ) ;
    index_argv = utDstrparser2( input_string, "[] \t\r", NULL, &index_argc ) ;
    index_expr_p = UTDPOOL_CALLOC( parse_p->expr_pool, SVER_EXPR ) ;
    index_expr_type_p = UTDPOOL_CALLOC( parse_p->expr_type_pool, SVER_EXPR_TYPE ) ;
    if( index_argc == 1 ){
      index_expr_type_p->data.start_index = atoi( index_argv[0] ) ;
      index_expr_type_p->token_type = SVER_TOKEN_INDEX_T ;
      utDdstring_reinit( &parse_p->temp_buf ) ;
      utDdstring_printf( &parse_p->temp_buf, "%s[%d]", expr_p->string_equiv, 
	                                               index_expr_type_p->data.start_index ) ;
    } else {
      utDmsgf(ERRMSG,routine,MSG_AT,"Unexpected index string:%s\n", index_string ) ;
      return(NULL) ; /* we can't do anything */
    }
    string_added = utDstringhash_add( parse_p->strings, utDdstring_value(&parse_p->temp_buf), NULL ) ;
    index_expr_p->string_equiv = string_added ;
    index_expr_p->num_vals = 1 ;
    index_expr_p->tokens = UTDVECTOR_MALLOC( 1, index_expr_p->num_vals, SVER_EXPR_TYPEPTR ) ;
    index_expr_p->tokens[1] = index_expr_type_p ;

    return(index_expr_p) ;

} /* end sver_expr_add_index() */


SVER_EXPRPTR sver_expr_add_range( SVERILOG_PARSEPTR parse_p, SVER_EXPRPTR expr_p,char *range_string )
{
    char **index_argv ;			/* parse input vector */
    char *input_string ;		/* input string */
    char *string_added ;		/* this is the stored string */
    INT index_argc ;			/* index argument */
    SVER_EXPRPTR range_expr_p ;		/* new expression */
    SVER_EXPR_TYPEPTR range_expr_type_p;/* new token identifier */

    FUNC_NAME("sver_expr_add_range") ;
    if(!(parse_p)){
      utDmsgf(ERRMSG,routine,MSG_AT,"Improper use of %s\n", routine ) ;
      return(NULL) ; /* we can't do anything */
    }
    if(!(expr_p)){
      utDmsgf(ERRMSG,routine,MSG_AT,"Unexpected NULL expression.\n", routine ) ;
      return(NULL) ; /* we can't do anything */
    }
    if(!(expr_p->string_equiv)){
      utDmsgf(ERRMSG,routine,MSG_AT,"Unexpected NULL string equivalent.\n", routine ) ;
      return(NULL) ; /* we can't do anything */
    }
    utDdstring_reinit( &parse_p->temp_buf ) ;
    input_string = utDdstring_append( &parse_p->temp_buf, range_string, -1 ) ;
    index_argv = utDstrparser2( input_string, "[]: \t\r", NULL, &index_argc ) ;
    range_expr_p = UTDPOOL_CALLOC( parse_p->expr_pool, SVER_EXPR ) ;
    range_expr_type_p = UTDPOOL_CALLOC( parse_p->expr_type_pool, SVER_EXPR_TYPE ) ;
    if( index_argc == 1 ){
      range_expr_type_p->data.start_index = atoi( index_argv[0] ) ;
      range_expr_type_p->end_index = range_expr_type_p->data.start_index ;
      range_expr_type_p->token_type = SVER_TOKEN_INDEX_T ;
      utDdstring_reinit( &parse_p->temp_buf ) ;
      utDdstring_printf( &parse_p->temp_buf, "%s[%d]", expr_p->string_equiv, 
	                                               range_expr_type_p->data.start_index ) ;
    } else if( index_argc == 2 ){
      range_expr_type_p->data.start_index = atoi( index_argv[0] ) ;
      range_expr_type_p->end_index = atoi( index_argv[1] ) ;
      range_expr_type_p->token_type = SVER_TOKEN_RANGE_T ;
      utDdstring_reinit( &parse_p->temp_buf ) ;
      utDdstring_printf( &parse_p->temp_buf, "%s[%d:%d]", expr_p->string_equiv, 
	                                               range_expr_type_p->data.start_index,
						       range_expr_type_p->end_index ) ;
    } else {
      utDmsgf(ERRMSG,routine,MSG_AT,"Unexpected range string:%s\n", range_string ) ;
      return(NULL) ; /* we can't do anything */
    }
    string_added = utDstringhash_add( parse_p->strings, utDdstring_value(&parse_p->temp_buf), NULL ) ;
    range_expr_p->string_equiv = string_added ;
    range_expr_p->num_vals = 1 ;
    range_expr_p->tokens = UTDVECTOR_MALLOC( 1, range_expr_p->num_vals, SVER_EXPR_TYPEPTR ) ;
    range_expr_p->tokens[1] = range_expr_type_p ;

    return(range_expr_p) ;
} /* end sver_expr_add_range() */

SVER_EXPRPTR sver_expr_merge_expressions( SVERILOG_PARSEPTR parse_p,void *user_data,
					  SVER_EXPRPTR e1_p, SVER_EXPRPTR e2_p, 
				          SVERILOG_OPERATOR_T op )
{
    SVER_EXPRPTR merged_p ;			/* the newly merged expression */
    SVER_EXPR_TYPEPTR start_expr_type_p ;	/* the type of start expression */
    SVER_EXPR_TYPEPTR close_expr_type_p ;	/* the type of close expression */
    SVER_EXPR_TYPEPTR merged_token_p ;		/* a merged_token */
    SVER_EXPR_TYPEPTR e1_token_p ;		/* first token of e1_p */
    SVER_EXPR_TYPEPTR e2_token_p ;		/* first token of e2_p */
    char *string_added ;			/* this is the stored string */
    char format_string[2] ;			/* build a temp string */
    INT i ;					/* character counter */
    INT e1cnt ;					/* number of e1 tokens */
    INT e2cnt ;					/* number of e2 tokens */
    FUNC_NAME("sver_expr_merge_expressions") ;

    if(!(parse_p)){
      utDmsgf(ERRMSG,routine,MSG_AT,"Improper use of %s\n", routine ) ;
      return(NULL) ; /* we can't do anything */
    }

    utDdstring_reinit( &parse_p->temp_buf ) ;
    merged_p = UTDPOOL_CALLOC( parse_p->expr_pool, SVER_EXPR ) ;
    if( op == OPERATOR_RANGE ){
      merged_p->num_vals = 1 ;
      merged_p->tokens = UTDVECTOR_MALLOC( 1, merged_p->num_vals, SVER_EXPR_TYPEPTR ) ;
      merged_token_p = UTDPOOL_CALLOC( parse_p->expr_type_pool, SVER_EXPR_TYPE ) ;
      merged_p->tokens[1] = merged_token_p ;
      if( e1_p && e1_p->string_equiv ){
	e1_token_p = sver_expr_get_token( e1_p, 1 ) ;
	if( e1_token_p->token_type != SVER_TOKEN_INTEGER_T ){
	  utDmsgf(ERRMSG,routine,MSG_AT,"expected an integer token\n" ) ;
	}
	merged_token_p->data.start_index = e1_token_p->data.int_value ;
      } else {
	utDmsgf(ERRMSG,routine,MSG_AT,"unexpected NULL for string 1\n" ) ;
      }
      if( e2_p && e2_p->string_equiv ){
	e2_token_p = sver_expr_get_token( e2_p, 1 ) ;
	if( e2_token_p->token_type != SVER_TOKEN_INTEGER_T ){
	  utDmsgf(ERRMSG,routine,MSG_AT,"expected an integer token\n" ) ;
	}
	merged_token_p->end_index = e2_token_p->data.int_value ;
      } else {
	utDmsgf(ERRMSG,routine,MSG_AT,"unexpected NULL for string 1\n" ) ;
      }
      utDdstring_reinit( &parse_p->temp_buf ) ;
      utDdstring_printf( &parse_p->temp_buf, "[%d:%d]", merged_token_p->data.start_index,
						        merged_token_p->end_index ) ;
      string_added = utDstringhash_add( parse_p->strings, utDdstring_value(&parse_p->temp_buf), NULL ) ;
      merged_p->string_equiv = string_added ;
    } else if( op == OPERATOR_CONCAT ){
      merged_p->num_vals = 1 ;
      merged_p->tokens = UTDVECTOR_MALLOC( 1, merged_p->num_vals, SVER_EXPR_TYPEPTR ) ;
      merged_token_p = UTDPOOL_CALLOC( parse_p->expr_type_pool, SVER_EXPR_TYPE ) ;
      merged_p->tokens[1] = merged_token_p ;
      if( e1_p && e1_p->string_equiv ){
	utDdstring_append( &parse_p->temp_buf, e1_p->string_equiv, -1 ) ;
      } else {
	utDmsgf(ERRMSG,routine,MSG_AT,"unexpected NULL for string 1\n" ) ;
      }
      utDdstring_append( &parse_p->temp_buf, ",", -1 ) ;
      if( e2_p && e2_p->string_equiv ){
	utDdstring_append( &parse_p->temp_buf, e2_p->string_equiv, -1 ) ;
      } else {
	utDmsgf(ERRMSG,routine,MSG_AT,"unexpected NULL for string 2\n" ) ;
      }
      string_added = utDstringhash_add( parse_p->strings, utDdstring_value(&parse_p->temp_buf), NULL ) ;
      merged_p->string_equiv = string_added ;
    } else {
      /* -----------------------------------------------------------------
       * Operator in the middle.
       ----------------------------------------------------------------- */
      if( e1_p && e1_p->string_equiv ){
	merged_p->num_vals += e1_p->num_vals ;
	utDdstring_append( &parse_p->temp_buf, e1_p->string_equiv, -1 ) ;
      } else {
	utDmsgf(ERRMSG,routine,MSG_AT,"unexpected NULL for string 1\n" ) ;
	DS( ebreak() ) ;
      }
      if( op ){
#ifdef LATER 
	if( parse_p->options & KICAD_OPTIONS_USE_TOKENS ){
	  merged_p->num_vals++ ;
	  close_expr_type_p = UTDPOOL_CALLOC( parse_p->expr_type_pool, SVER_EXPR_TYPE ) ;
	  close_expr_type_p->token_type = close_expr ;
	  close_expr_type_p->data.int_value = close_expr ;
	}
	format_string[0] = close_expr ;
	Ydstring_append( &parse_p->temp_buf, format_string, 1 ) ;
	Ydstring_append( &parse_p->temp_buf, " ", -1 ) ;
#endif /* LATER */
      }
      if( e2_p && e2_p->string_equiv ){
	merged_p->num_vals += e2_p->num_vals ;
	utDdstring_append( &parse_p->temp_buf, e2_p->string_equiv, -1 ) ;
      } else {
	utDmsgf(ERRMSG,routine,MSG_AT,"unexpected NULL for string 2\n" ) ;
      }
      string_added = utDstringhash_add( parse_p->strings, utDdstring_value(&parse_p->temp_buf), NULL ) ;
      merged_p->string_equiv = string_added ;

      merged_p->tokens = UTDVECTOR_MALLOC( 1, merged_p->num_vals, SVER_EXPR_TYPEPTR ) ;
      i = 0 ;
      if( e1_p ){
	for( e1cnt = 1 ; e1cnt <= e1_p->num_vals ; e1cnt++ ){
	  merged_p->tokens[++i] = e1_p->tokens[e1cnt] ;
	}
	/* Now free e1 tokens array - no longer needed */
	UTDVECTOR_FREE( e1_p->tokens, 1 ) ;
      }
      if( op ){
      }
      if( e2_p ){
	for( e2cnt = 1 ; e2cnt <= e2_p->num_vals ; e2cnt++ ){
	  merged_p->tokens[++i] = e2_p->tokens[e2cnt] ;
	}
	/* Now free e2 tokens array - no longer needed */
	UTDVECTOR_FREE( e2_p->tokens, 1 ) ;
      }
    }
    return( merged_p ) ;

} /* end sver_expr_merge_expressions() */
