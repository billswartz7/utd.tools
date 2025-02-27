/* A Bison parser, made by GNU Bison 3.0.5.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_PARSE_H_INCLUDED
# define YY_YY_PARSE_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    K_A = 258,
    K_APV = 259,
    K_ARITH_ABS = 260,
    K_ARITH_DIV = 261,
    K_ARITH_DIV_R = 262,
    K_ARITH_DIV_S = 263,
    K_ARITH_MOD = 264,
    K_ARITH_MOD_R = 265,
    K_ARITH_MOD_S = 266,
    K_ARITH_MULT = 267,
    K_ARITH_MULT_R = 268,
    K_ARITH_SUB = 269,
    K_ARITH_SUB_R = 270,
    K_ARITH_SUM = 271,
    K_ARITH_SUM_R = 272,
    K_ARITH_POW = 273,
    K_ARITH_POW_R = 274,
    K_ARITH_POW_S = 275,
    K_ARRAY = 276,
    K_ARRAY_2U = 277,
    K_ARRAY_2S = 278,
    K_ARRAY_I = 279,
    K_ARRAY_OBJ = 280,
    K_ARRAY_R = 281,
    K_ARRAY_S = 282,
    K_ARRAY_STR = 283,
    K_ARRAY_PORT = 284,
    K_CAST_INT = 285,
    K_CAST_REAL = 286,
    K_CAST_REAL_S = 287,
    K_CAST_2 = 288,
    K_CLASS = 289,
    K_CMP_EEQ = 290,
    K_CMP_EQ = 291,
    K_CMP_EQX = 292,
    K_CMP_EQZ = 293,
    K_CMP_WEQ = 294,
    K_CMP_WNE = 295,
    K_CMP_EQ_R = 296,
    K_CMP_NEE = 297,
    K_CMP_NE = 298,
    K_CMP_NE_R = 299,
    K_CMP_GE = 300,
    K_CMP_GE_R = 301,
    K_CMP_GE_S = 302,
    K_CMP_GT = 303,
    K_CMP_GT_R = 304,
    K_CMP_GT_S = 305,
    K_CONCAT = 306,
    K_CONCAT8 = 307,
    K_DEBUG = 308,
    K_DELAY = 309,
    K_DFF_N = 310,
    K_DFF_N_ACLR = 311,
    K_DFF_N_ASET = 312,
    K_DFF_P = 313,
    K_DFF_P_ACLR = 314,
    K_DFF_P_ASET = 315,
    K_ENUM2 = 316,
    K_ENUM2_S = 317,
    K_ENUM4 = 318,
    K_ENUM4_S = 319,
    K_EVENT = 320,
    K_EVENT_OR = 321,
    K_EXPORT = 322,
    K_EXTEND_S = 323,
    K_FUNCTOR = 324,
    K_IMPORT = 325,
    K_ISLAND = 326,
    K_LATCH = 327,
    K_MODPATH = 328,
    K_NET = 329,
    K_NET_S = 330,
    K_NET_R = 331,
    K_NET_2S = 332,
    K_NET_2U = 333,
    K_NET8 = 334,
    K_NET8_2S = 335,
    K_NET8_2U = 336,
    K_NET8_S = 337,
    K_PARAM_STR = 338,
    K_PARAM_L = 339,
    K_PARAM_REAL = 340,
    K_PART = 341,
    K_PART_PV = 342,
    K_PART_V = 343,
    K_PART_V_S = 344,
    K_PORT = 345,
    K_PORT_INFO = 346,
    K_PV = 347,
    K_REDUCE_AND = 348,
    K_REDUCE_OR = 349,
    K_REDUCE_XOR = 350,
    K_REDUCE_NAND = 351,
    K_REDUCE_NOR = 352,
    K_REDUCE_XNOR = 353,
    K_REPEAT = 354,
    K_RESOLV = 355,
    K_RTRAN = 356,
    K_RTRANIF0 = 357,
    K_RTRANIF1 = 358,
    K_SCOPE = 359,
    K_SFUNC = 360,
    K_SFUNC_E = 361,
    K_SHIFTL = 362,
    K_SHIFTR = 363,
    K_SHIFTRS = 364,
    K_SUBSTITUTE = 365,
    K_THREAD = 366,
    K_TIMESCALE = 367,
    K_TRAN = 368,
    K_TRANIF0 = 369,
    K_TRANIF1 = 370,
    K_TRANVP = 371,
    K_UFUNC_REAL = 372,
    K_UFUNC_VEC4 = 373,
    K_UFUNC_E = 374,
    K_UDP = 375,
    K_UDP_C = 376,
    K_UDP_S = 377,
    K_VAR = 378,
    K_VAR_COBJECT = 379,
    K_VAR_DARRAY = 380,
    K_VAR_QUEUE = 381,
    K_VAR_S = 382,
    K_VAR_STR = 383,
    K_VAR_I = 384,
    K_VAR_R = 385,
    K_VAR_2S = 386,
    K_VAR_2U = 387,
    K_vpi_call = 388,
    K_vpi_call_w = 389,
    K_vpi_call_i = 390,
    K_vpi_func = 391,
    K_vpi_func_r = 392,
    K_vpi_func_s = 393,
    K_ivl_version = 394,
    K_ivl_delay_selection = 395,
    K_vpi_module = 396,
    K_vpi_time_precision = 397,
    K_file_names = 398,
    K_file_line = 399,
    K_PORT_INPUT = 400,
    K_PORT_OUTPUT = 401,
    K_PORT_INOUT = 402,
    K_PORT_MIXED = 403,
    K_PORT_NODIR = 404,
    T_INSTR = 405,
    T_LABEL = 406,
    T_NUMBER = 407,
    T_STRING = 408,
    T_SYMBOL = 409,
    T_VECTOR = 410
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 51 "parse.y" /* yacc.c:1916  */

      char*text;
      char **table;
      uint64_t numb;
      bool flag;

      comp_operands_t opa;

      struct symb_s  symb;
      struct symbv_s symbv;

      struct numbv_s numbv;

      struct enum_name_s enum_name;
      std::list<struct enum_name_s>*enum_namev;

      struct symb_s vect;

      struct argv_s argv;
      vpiHandle vpi;

      vvp_delay_t*cdelay;

      int      vpi_enum;

#line 236 "parse.h" /* yacc.c:1916  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSE_H_INCLUDED  */
