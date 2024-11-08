#ifndef VERILOG_CALLBACKS_H
#define VERILOG_CALLBACKS_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
 
typedef struct sverilog_parse_context_rec *SVERILOG_PARSE_DUMMYPTR ;

typedef int SVER_CALLBACK_arg0( struct sverilog_parse_context_rec *s_p, void *ud ) ;
typedef int SVER_CALLBACK_arg1s( struct sverilog_parse_context_rec *s_p,void *ud, char *string1 ) ;
typedef int SVER_CALLBACK_arg2s( struct sverilog_parse_context_rec *s_p,void *ud, char *string1, char *string2 ) ;
typedef int SVER_CALLBACK_net_type( struct sverilog_parse_context_rec *s_p,void *ud, SVERILOG_NET_TYPE_T type ) ;
typedef int SVER_CALLBACK_port_dir( struct sverilog_parse_context_rec *s_p,void *ud, SVERILOG_PORT_DIR_T direction ) ;
typedef SVER_EXPRPTR SVER_CALLBACK_expr( struct sverilog_parse_context_rec *s_p,void *ud, SVER_EXPRPTR expr_p ) ;
typedef SVER_EXPRPTR SVER_CALLBACK_str1_expr( struct sverilog_parse_context_rec *s_p,void *ud, char *string,SVER_EXPRPTR expr_p ) ;
typedef SVER_EXPRPTR SVER_CALLBACK_expr_op( struct sverilog_parse_context_rec *s_p,void *ud, SVER_EXPRPTR expr1_p, SVER_EXPRPTR expr2_p, 
                                            SVERILOG_OPERATOR_T op) ;
typedef SVER_EXPRPTR SVER_CALLBACK_expr3( struct sverilog_parse_context_rec *s_p,void *ud, SVER_EXPRPTR expr1_p, SVER_EXPRPTR expr2_p, 
                                          SVER_EXPRPTR expr3 ) ;

/* -----------------------------------------------------------------
 * Define the callback functions.
----------------------------------------------------------------- */
typedef struct sverilog_callback_rec {
  union {
    SVER_CALLBACK_arg0 		*void_func ;
    SVER_CALLBACK_arg1s		*str1_func ;
    SVER_CALLBACK_arg2s		*str2_func ;
    SVER_CALLBACK_expr		*expr_func ;
    SVER_CALLBACK_expr_op	*expr_op_func ;
    SVER_CALLBACK_expr3		*expr3_func ;
    SVER_CALLBACK_str1_expr	*str1_expr_func ;
    SVER_CALLBACK_net_type	*net_type_func ;
    SVER_CALLBACK_port_dir	*port_dir_func ;
  } f ;
} SVER_CALLBACK, *SVER_CALLBACKPTR ;


/* -----------------------------------------------------------------
 * Define the types of functions.
----------------------------------------------------------------- */
typedef enum {
  SVERCB_STRING_MOD_F =			0,	/* type SVER_CALLBACK_arg2s */
  SVERCB_EXPR_F = 			1,	/* type SVER_CALLBACK_expr_op */
  SVERCB_EXPR_OP_F = 			2,	/* type SVER_CALLBACK_expr_op */
  SVERCB_EXPR_ADD_CONCAT_F =		3,	/* type SVER_CALLBACK_expr_op */
  SVERCB_MODULE_NAME_F = 		4,	/* type SVER_CALLBACK_arg1s */
  SVERCB_MODULE_IOPORT_F = 		5,	/* type SVER_CALLBACK_arg1s */
  SVERCB_PORT_CONCAT_START_F = 		6,	/* type SVER_CALLBACK_void */
  SVERCB_PORT_CONCAT_END_F = 		7,	/* type SVER_CALLBACK_void */
  SVERCB_PORT_RANGE_F = 		8,	/* type SVER_CALLBACK_expr */
  SVERCB_PORT_DIR_F = 			9,	/* type SVER_CALLBACK_port_dir */
  SVERCB_ANSI_PORT_DIR_F = 		10,	/* type SVER_CALLBACK_port_dir */
  SVERCB_MODNETS_END_F =		11,	/* type SVER_CALLBACK_void */
  SVERCB_MODINST_MODNAME_F =		12,	/* type SVER_CALLBACK_arg1s */
  SVERCB_MODINST_INSTNAME_F =		13,	/* type SVER_CALLBACK_arg1s */
  SVERCB_MODINST_MNET_F =		14,	/* type SVER_CALLBACK_expr */
  SVERCB_MODINST_MNET_BIND_F =		15,	/* type SVER_CALLBACK_str1_expr */
  SVERCB_MODINST_END_CONNECTS_F =	16,	/* type SVER_CALLBACK_arg1s */
  SVERCB_NET_TYPE_F = 			17,	/* type SVER_CALLBACK_net_type */
  SVERCB_NET_ASSIGN_F = 		18,	/* type SVER_CALLBACK_expr_op */
  SVERCB_NET_DECL_F = 			19,	/* type SVER_CALLBACK_expr3 */
  SVERCB_MODULE_END_F = 		20	/* type SVER_CALLBACK_arg1s */
} SVER_CALLBACK_T ;

#define SVER_CALLBACK_LAST_FUNC	     	20
#define SVER_CALLBACK_NUM_FUNCS	       (SVER_CALLBACK_LAST_FUNC+1)


#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* VERILOG_CALLBACKS_H */
