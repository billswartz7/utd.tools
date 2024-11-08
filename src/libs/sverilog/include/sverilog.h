#ifndef VERILOG_SVERILOG_H
#define VERILOG_SVERILOG_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef enum  sverilog_boolean_e {
    SVERILOG_TRUE = 1,
    SVERILOG_FALSE = 0
} SVERILOG_BOOLEAN_T ;

//! Stores different Operators.
typedef enum sverilog_operator_e {
    OPERATOR_STAR    , //!<
    OPERATOR_PLUS    , //!<
    OPERATOR_MINUS   , //!<
    OPERATOR_ASL     , //!< Arithmetic shift left
    OPERATOR_ASR     , //!< Arithmetic shift right
    OPERATOR_LSL     , //!< logical shift left
    OPERATOR_LSR     , //!< logical shift right
    OPERATOR_DIV     , //!< divide
    OPERATOR_POW     , //!< pow
    OPERATOR_MOD     , //!< mod
    OPERATOR_GTE     , //!< greater than or equal to
    OPERATOR_LTE     , //!<
    OPERATOR_GT      , //!<
    OPERATOR_LT      , //!<
    OPERATOR_L_NEG   , //!<
    OPERATOR_L_AND   , //!<
    OPERATOR_L_OR    , //!<
    OPERATOR_C_EQ    , //!<
    OPERATOR_L_EQ    , //!<
    OPERATOR_C_NEQ   , //!<
    OPERATOR_L_NEQ   , //!<
    OPERATOR_B_NEG   , //!<
    OPERATOR_B_AND   , //!<
    OPERATOR_B_OR    , //!<
    OPERATOR_B_XOR   , //!<
    OPERATOR_B_EQU   , //!<
    OPERATOR_B_NAND  , //!<
    OPERATOR_B_NOR   , //!<
    OPERATOR_TERNARY , //!<
    OPERATOR_DOT     , //!< Add hierarchy
    OPERATOR_INDEX   , //!< Build a vector index
    OPERATOR_RANGE   , //!< Create lo,hi range constraint
    OPERATOR_INDEXED_PLUS_RANGE   , //!< Create incremented range constraint
    OPERATOR_INDEXED_MINUS_RANGE  , //!< Create decremented range constraint
    OPERATOR_CONCAT  , //!< Create a concatenated expression
    OPERATOR_ASSIGN  , //!< Create an assignment
    OPERATOR_NONE = 0
} SVERILOG_OPERATOR_T ;

//! Describes the type of a net in Verilog.
typedef enum sverilog_net_type_e {
    NET_TYPE_SUPPLY0,   //!< Logic 0 supply rail
    NET_TYPE_SUPPLY1,   //!< Logic 1 supply rail.
    NET_TYPE_TRI,       //!< Tri-state
    NET_TYPE_TRIAND,    //!< Tri-state AND
    NET_TYPE_TRIOR,     //!< Tri-state OR
    NET_TYPE_TRI0,      //!< Tri-state no driver pulled to 0
    NET_TYPE_TRI1,      //!< Tri-state no driver pulled to 1
    NET_TYPE_TRIREG,    //!< Tri-state reg wire
    NET_TYPE_WIRE,      //!< Wire
    NET_TYPE_UWIRE,     //!< Unresolved wire - only one driver allowed!
    NET_TYPE_WAND,      //!< ?
    NET_TYPE_WOR,       //!< ?
    NET_TYPE_IO,        //!< ?
    NET_TYPE_NONE       //!< Use only when not specified!
} SVERILOG_NET_TYPE_T ;

//! Describes the direction of a port in Verilog.
typedef enum sverilog_port_dir_e {
    PORT_DIR_INPUT_T,    //!< input
    PORT_DIR_OUTPUT_T,   //!< output
    PORT_DIR_INOUT_T,    //!< bidirectional
    PORT_DIR_REF_T	 //!< System Verilog reference
} SVERILOG_PORT_DIR_T ;

//! Describes the drive strength of a single primitive.
typedef enum sverilog_primitive_strength_e {
    STRENGTH_HIGHZ0,
    STRENGTH_HIGHZ1,
    STRENGTH_SUPPLY0,
    STRENGTH_STRONG0,
    STRENGTH_PULL0,
    STRENGTH_WEAK0,
    STRENGTH_SUPPLY1,
    STRENGTH_STRONG1,
    STRENGTH_PULL1,
    STRENGTH_WEAK1,
    STRENGTH_NONE
} SVERILOG_PRIMITIVE_STRENGTH_T ;

typedef struct sverilog_expr_type_rec {
  union {
    char *string ;
    int int_value ;
    int start_index ;
    double double_value ;
  } data ;
  int end_index ;
  int token_type ;
} SVER_EXPR_TYPE, *SVER_EXPR_TYPEPTR ;

typedef struct sverilog_expr_rec {
  int num_vals ;
  char *string_equiv ;
  SVER_EXPR_TYPEPTR *tokens ;
} SVER_EXPR, *SVER_EXPRPTR ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* VERILOG_SVERILOG_H */
