/*!
@file expr.h
@brief Contains function and data structures to support expressions
*/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef VERILOG_EXPR_H
#define VERILOG_EXPR_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* -----------------------------------------------------------------
 * These definitions are such that they will never conflict with
 * YACC/Bison definitions which start above 255.  This allows us
 * to detect that the token was not created by the LEXer.
 * ----------------------------------------------------------------- */
typedef enum {
  SVER_TOKEN_UNKNOWN_T 	= 0,
  SVER_TOKEN_STRING_T 	= 1,
  SVER_TOKEN_INTEGER_T 	= 2,
  SVER_TOKEN_REAL_T 	= 3,
  SVER_TOKEN_INDEX_T 	= 4,
  SVER_TOKEN_RANGE_T 	= 5,
  SVER_TOKEN_OPERATOR_T = 6,
  SVER_TOKEN_EXPR_T 	= 7
} SVER_EXPR_TOKEN_TYPE_T ;

extern void sver_expr_init( SVERILOG_PARSEPTR parse_p ) ;

extern void sver_expr_free( SVERILOG_PARSEPTR parse_p ) ;

extern SVER_EXPRPTR sver_expr_start_int_expr( SVERILOG_PARSEPTR parse_p, LONG data, char *str, INT type ) ;

extern SVER_EXPRPTR sver_expr_start_float_expr( SVERILOG_PARSEPTR parse_p, DOUBLE data, char *str, INT type ) ;

extern SVER_EXPRPTR sver_expr_start_string_expr( SVERILOG_PARSEPTR parse_p, char *data, INT type ) ;

extern SVER_EXPR_TYPEPTR sver_expr_get_token( SVER_EXPRPTR expr_p, INT token_id ) ;

extern SVER_EXPRPTR sver_expr_add_index( SVERILOG_PARSEPTR parse_p, SVER_EXPRPTR expr_p,char *index_string ) ;

extern SVER_EXPRPTR sver_expr_add_range( SVERILOG_PARSEPTR parse_p, SVER_EXPRPTR expr_p,char *rangei_string ) ;

extern SVER_EXPRPTR sver_expr_merge_expressions( SVERILOG_PARSEPTR parse_p,void *user_data, 
					         SVER_EXPRPTR e1_p, SVER_EXPRPTR e2_p, 
				                 SVERILOG_OPERATOR_T op ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* VERILOG_EXPR_H */

