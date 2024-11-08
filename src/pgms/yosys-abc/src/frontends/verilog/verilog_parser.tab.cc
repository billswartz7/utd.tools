/* A Bison parser, made by GNU Bison 3.0.5.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.5"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1


/* Substitute the variable and function names.  */
#define yyparse         frontend_verilog_yyparse
#define yylex           frontend_verilog_yylex
#define yyerror         frontend_verilog_yyerror
#define yydebug         frontend_verilog_yydebug
#define yynerrs         frontend_verilog_yynerrs

#define yylval          frontend_verilog_yylval
#define yychar          frontend_verilog_yychar

/* Copy the first part of user declarations.  */
#line 36 "verilog_parser.y" /* yacc.c:339  */

#include <list>
#include <string.h>
#include "frontends/verilog/verilog_frontend.h"
#include "kernel/log.h"

USING_YOSYS_NAMESPACE
using namespace AST;
using namespace VERILOG_FRONTEND;

YOSYS_NAMESPACE_BEGIN
namespace VERILOG_FRONTEND {
	int port_counter;
	std::map<std::string, int> port_stubs;
	std::map<std::string, AstNode*> attr_list, default_attr_list;
	std::map<std::string, AstNode*> *albuf;
	std::vector<AstNode*> ast_stack;
	struct AstNode *astbuf1, *astbuf2, *astbuf3;
	struct AstNode *current_function_or_task;
	struct AstNode *current_ast, *current_ast_mod;
	int current_function_or_task_port_id;
	std::vector<char> case_type_stack;
	bool do_not_require_port_stubs;
	bool default_nettype_wire;
	bool sv_mode, formal_mode, lib_mode;
	bool norestrict_mode, assume_asserts_mode;
	bool current_wire_rand, current_wire_const;
	std::istream *lexin;
}
YOSYS_NAMESPACE_END

static void append_attr(AstNode *ast, std::map<std::string, AstNode*> *al)
{
	for (auto &it : *al) {
		if (ast->attributes.count(it.first) > 0)
			delete ast->attributes[it.first];
		ast->attributes[it.first] = it.second;
	}
	delete al;
}

static void append_attr_clone(AstNode *ast, std::map<std::string, AstNode*> *al)
{
	for (auto &it : *al) {
		if (ast->attributes.count(it.first) > 0)
			delete ast->attributes[it.first];
		ast->attributes[it.first] = it.second->clone();
	}
}

static void free_attr(std::map<std::string, AstNode*> *al)
{
	for (auto &it : *al)
		delete it.second;
	delete al;
}


#line 133 "../verilog_parser.tab.cc" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 1
#endif

/* In a future release of Bison, this section will be replaced
   by #include "verilog_parser.tab.hh".  */
#ifndef YY_FRONTEND_VERILOG_YY_VERILOG_PARSER_TAB_HH_INCLUDED
# define YY_FRONTEND_VERILOG_YY_VERILOG_PARSER_TAB_HH_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int frontend_verilog_yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_STRING = 258,
    TOK_ID = 259,
    TOK_CONSTVAL = 260,
    TOK_REALVAL = 261,
    TOK_PRIMITIVE = 262,
    ATTR_BEGIN = 263,
    ATTR_END = 264,
    DEFATTR_BEGIN = 265,
    DEFATTR_END = 266,
    TOK_MODULE = 267,
    TOK_ENDMODULE = 268,
    TOK_PARAMETER = 269,
    TOK_LOCALPARAM = 270,
    TOK_DEFPARAM = 271,
    TOK_PACKAGE = 272,
    TOK_ENDPACKAGE = 273,
    TOK_PACKAGESEP = 274,
    TOK_INPUT = 275,
    TOK_OUTPUT = 276,
    TOK_INOUT = 277,
    TOK_WIRE = 278,
    TOK_REG = 279,
    TOK_LOGIC = 280,
    TOK_INTEGER = 281,
    TOK_SIGNED = 282,
    TOK_ASSIGN = 283,
    TOK_ALWAYS = 284,
    TOK_INITIAL = 285,
    TOK_BEGIN = 286,
    TOK_END = 287,
    TOK_IF = 288,
    TOK_ELSE = 289,
    TOK_FOR = 290,
    TOK_WHILE = 291,
    TOK_REPEAT = 292,
    TOK_DPI_FUNCTION = 293,
    TOK_POSEDGE = 294,
    TOK_NEGEDGE = 295,
    TOK_OR = 296,
    TOK_AUTOMATIC = 297,
    TOK_CASE = 298,
    TOK_CASEX = 299,
    TOK_CASEZ = 300,
    TOK_ENDCASE = 301,
    TOK_DEFAULT = 302,
    TOK_FUNCTION = 303,
    TOK_ENDFUNCTION = 304,
    TOK_TASK = 305,
    TOK_ENDTASK = 306,
    TOK_SPECIFY = 307,
    TOK_ENDSPECIFY = 308,
    TOK_SPECPARAM = 309,
    TOK_GENERATE = 310,
    TOK_ENDGENERATE = 311,
    TOK_GENVAR = 312,
    TOK_REAL = 313,
    TOK_SYNOPSYS_FULL_CASE = 314,
    TOK_SYNOPSYS_PARALLEL_CASE = 315,
    TOK_SUPPLY0 = 316,
    TOK_SUPPLY1 = 317,
    TOK_TO_SIGNED = 318,
    TOK_TO_UNSIGNED = 319,
    TOK_POS_INDEXED = 320,
    TOK_NEG_INDEXED = 321,
    TOK_ASSERT = 322,
    TOK_ASSUME = 323,
    TOK_RESTRICT = 324,
    TOK_COVER = 325,
    TOK_PROPERTY = 326,
    TOK_ENUM = 327,
    TOK_TYPEDEF = 328,
    TOK_RAND = 329,
    TOK_CONST = 330,
    TOK_CHECKER = 331,
    TOK_ENDCHECKER = 332,
    TOK_EVENTUALLY = 333,
    TOK_INCREMENT = 334,
    TOK_DECREMENT = 335,
    TOK_UNIQUE = 336,
    TOK_PRIORITY = 337,
    OP_LOR = 338,
    OP_LAND = 339,
    OP_NOR = 340,
    OP_XNOR = 341,
    OP_NAND = 342,
    OP_EQ = 343,
    OP_NE = 344,
    OP_EQX = 345,
    OP_NEX = 346,
    OP_LE = 347,
    OP_GE = 348,
    OP_SHL = 349,
    OP_SHR = 350,
    OP_SSHL = 351,
    OP_SSHR = 352,
    OP_POW = 353,
    UNARY_OPS = 354,
    FAKE_THEN = 355
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 97 "verilog_parser.y" /* yacc.c:355  */

	std::string *string;
	struct YOSYS_NAMESPACE_PREFIX AST::AstNode *ast;
	std::map<std::string, YOSYS_NAMESPACE_PREFIX AST::AstNode*> *al;
	bool boolean;

#line 281 "../verilog_parser.tab.cc" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE frontend_verilog_yylval;

int frontend_verilog_yyparse (void);

#endif /* !YY_FRONTEND_VERILOG_YY_VERILOG_PARSER_TAB_HH_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 298 "../verilog_parser.tab.cc" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if 1

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
# define YYCOPY_NEEDED 1
#endif


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1788

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  127
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  198
/* YYNRULES -- Number of rules.  */
#define YYNRULES  445
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  909

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   355

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   126,     2,   115,     2,   107,    89,     2,
     116,   117,   105,   103,   111,   104,   113,   106,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   118,   114,
      95,   112,    98,   124,   121,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,   119,     2,   120,    87,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   122,    85,   123,   125,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      86,    88,    90,    91,    92,    93,    94,    96,    97,    99,
     100,   101,   102,   108,   109,   110
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   152,   152,   152,   164,   165,   166,   167,   168,   169,
     169,   173,   173,   186,   186,   190,   197,   190,   203,   203,
     206,   207,   210,   216,   224,   227,   235,   245,   245,   266,
     266,   266,   266,   269,   269,   271,   273,   273,   278,   278,
     283,   286,   286,   286,   289,   289,   292,   292,   295,   305,
     309,   309,   322,   322,   336,   341,   341,   354,   354,   357,
     360,   361,   362,   363,   364,   367,   367,   370,   370,   379,
     379,   380,   383,   386,   389,   395,   397,   400,   403,   409,
     415,   418,   421,   426,   431,   436,   441,   447,   450,   456,
     459,   464,   465,   468,   471,   479,   481,   481,   485,   485,
     485,   485,   485,   485,   485,   485,   485,   486,   486,   486,
     486,   486,   489,   489,   500,   500,   510,   510,   521,   521,
     533,   533,   545,   545,   569,   574,   580,   580,   584,   585,
     586,   586,   590,   590,   594,   597,   602,   602,   602,   606,
     602,   614,   614,   617,   617,   638,   641,   641,   645,   646,
     649,   650,   653,   656,   657,   661,   662,   668,   671,   671,
     674,   685,   691,   692,   696,   697,   698,   713,   714,   715,
     717,   724,   727,   731,   732,   735,   736,   739,   740,   743,
     744,   745,   749,   753,   756,   759,   760,   761,   764,   765,
     818,   821,   822,   830,   833,   835,   838,   845,   848,   852,
     855,   864,   864,   872,   872,   880,   880,   883,   895,   898,
     898,   901,   911,   926,   911,   932,   932,   940,   940,   949,
     951,   962,   962,   965,  1007,  1017,  1062,  1065,  1065,  1068,
    1073,  1073,  1082,  1082,  1092,  1095,  1100,  1101,  1104,  1104,
    1111,  1111,  1120,  1121,  1124,  1125,  1125,  1131,  1131,  1134,
    1134,  1136,  1138,  1143,  1152,  1179,  1179,  1182,  1186,  1191,
    1198,  1206,  1211,  1206,  1219,  1219,  1233,  1234,  1235,  1236,
    1237,  1237,  1241,  1242,  1243,  1246,  1251,  1256,  1263,  1266,
    1271,  1271,  1274,  1274,  1277,  1280,  1283,  1286,  1289,  1292,
    1295,  1298,  1304,  1312,  1315,  1318,  1321,  1324,  1327,  1333,
    1341,  1345,  1349,  1353,  1360,  1360,  1360,  1360,  1360,  1361,
    1362,  1362,  1363,  1363,  1373,  1373,  1389,  1394,  1396,  1389,
    1404,  1404,  1417,  1417,  1430,  1430,  1444,  1444,  1455,  1458,
    1461,  1466,  1472,  1475,  1478,  1483,  1487,  1490,  1494,  1494,
    1498,  1498,  1505,  1508,  1508,  1512,  1518,  1512,  1530,  1530,
    1534,  1540,  1534,  1548,  1549,  1552,  1555,  1558,  1563,  1568,
    1577,  1584,  1587,  1592,  1596,  1602,  1602,  1606,  1606,  1610,
    1611,  1614,  1619,  1619,  1623,  1623,  1627,  1631,  1627,  1636,
    1636,  1644,  1644,  1652,  1652,  1666,  1666,  1675,  1675,  1678,
    1678,  1681,  1684,  1693,  1696,  1706,  1718,  1725,  1731,  1742,
    1746,  1746,  1756,  1760,  1764,  1767,  1772,  1775,  1778,  1782,
    1786,  1790,  1794,  1798,  1802,  1806,  1810,  1815,  1819,  1824,
    1828,  1832,  1836,  1840,  1844,  1848,  1852,  1856,  1860,  1864,
    1868,  1872,  1876,  1880,  1884,  1888,  1892,  1896,  1900,  1904,
    1908,  1912,  1916,  1920,  1926,  1929
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TOK_STRING", "TOK_ID", "TOK_CONSTVAL",
  "TOK_REALVAL", "TOK_PRIMITIVE", "ATTR_BEGIN", "ATTR_END",
  "DEFATTR_BEGIN", "DEFATTR_END", "TOK_MODULE", "TOK_ENDMODULE",
  "TOK_PARAMETER", "TOK_LOCALPARAM", "TOK_DEFPARAM", "TOK_PACKAGE",
  "TOK_ENDPACKAGE", "TOK_PACKAGESEP", "TOK_INPUT", "TOK_OUTPUT",
  "TOK_INOUT", "TOK_WIRE", "TOK_REG", "TOK_LOGIC", "TOK_INTEGER",
  "TOK_SIGNED", "TOK_ASSIGN", "TOK_ALWAYS", "TOK_INITIAL", "TOK_BEGIN",
  "TOK_END", "TOK_IF", "TOK_ELSE", "TOK_FOR", "TOK_WHILE", "TOK_REPEAT",
  "TOK_DPI_FUNCTION", "TOK_POSEDGE", "TOK_NEGEDGE", "TOK_OR",
  "TOK_AUTOMATIC", "TOK_CASE", "TOK_CASEX", "TOK_CASEZ", "TOK_ENDCASE",
  "TOK_DEFAULT", "TOK_FUNCTION", "TOK_ENDFUNCTION", "TOK_TASK",
  "TOK_ENDTASK", "TOK_SPECIFY", "TOK_ENDSPECIFY", "TOK_SPECPARAM",
  "TOK_GENERATE", "TOK_ENDGENERATE", "TOK_GENVAR", "TOK_REAL",
  "TOK_SYNOPSYS_FULL_CASE", "TOK_SYNOPSYS_PARALLEL_CASE", "TOK_SUPPLY0",
  "TOK_SUPPLY1", "TOK_TO_SIGNED", "TOK_TO_UNSIGNED", "TOK_POS_INDEXED",
  "TOK_NEG_INDEXED", "TOK_ASSERT", "TOK_ASSUME", "TOK_RESTRICT",
  "TOK_COVER", "TOK_PROPERTY", "TOK_ENUM", "TOK_TYPEDEF", "TOK_RAND",
  "TOK_CONST", "TOK_CHECKER", "TOK_ENDCHECKER", "TOK_EVENTUALLY",
  "TOK_INCREMENT", "TOK_DECREMENT", "TOK_UNIQUE", "TOK_PRIORITY", "OP_LOR",
  "OP_LAND", "'|'", "OP_NOR", "'^'", "OP_XNOR", "'&'", "OP_NAND", "OP_EQ",
  "OP_NE", "OP_EQX", "OP_NEX", "'<'", "OP_LE", "OP_GE", "'>'", "OP_SHL",
  "OP_SHR", "OP_SSHL", "OP_SSHR", "'+'", "'-'", "'*'", "'/'", "'%'",
  "OP_POW", "UNARY_OPS", "FAKE_THEN", "','", "'='", "'.'", "';'", "'#'",
  "'('", "')'", "':'", "'['", "']'", "'@'", "'{'", "'}'", "'?'", "'~'",
  "'!'", "$accept", "input", "$@1", "design", "attr", "$@2", "attr_opt",
  "defattr", "$@3", "$@4", "opt_attr_list", "attr_list", "attr_assign",
  "hierarchical_id", "module", "$@5", "module_para_opt", "$@6", "$@7",
  "module_para_list", "single_module_para", "$@8", "$@9",
  "module_args_opt", "module_args", "optional_comma",
  "module_arg_opt_assignment", "module_arg", "$@10", "$@11", "package",
  "$@12", "package_body", "package_body_stmt", "non_opt_delay", "delay",
  "wire_type", "$@13", "wire_type_token_list", "wire_type_token_io",
  "wire_type_token", "non_opt_range", "non_opt_multirange", "range",
  "range_or_multirange", "range_or_signed_int", "module_body",
  "module_body_stmt", "checker_decl", "$@14", "task_func_decl", "$@15",
  "$@16", "$@17", "$@18", "$@19", "dpi_function_arg",
  "opt_dpi_function_args", "dpi_function_args", "opt_automatic",
  "opt_signed", "task_func_args_opt", "$@20", "$@21", "task_func_args",
  "task_func_port", "$@22", "task_func_body", "specify_block",
  "specify_item_opt", "specify_item", "specparam_declaration",
  "specparam_range", "list_of_specparam_assignments",
  "specparam_assignment", "path_declaration", "simple_path_declaration",
  "path_delay_value", "list_of_path_delay_extra_expressions",
  "parallel_path_description", "full_path_description",
  "list_of_path_inputs", "more_path_inputs", "list_of_path_outputs",
  "opt_polarity_operator", "specify_input_terminal_descriptor",
  "specify_output_terminal_descriptor", "system_timing_declaration",
  "system_timing_arg", "system_timing_args", "path_delay_expression",
  "constant_mintypmax_expression", "constant_expression", "param_signed",
  "param_integer", "param_real", "param_range", "param_decl", "$@23",
  "localparam_decl", "$@24", "param_decl_list", "single_param_decl",
  "defparam_decl", "defparam_decl_list", "single_defparam_decl",
  "wire_decl", "$@25", "$@26", "$@27", "$@28", "opt_supply_wires",
  "wire_name_list", "wire_name_and_opt_assign", "wire_name", "assign_stmt",
  "assign_expr_list", "assign_expr", "cell_stmt", "$@29", "$@30",
  "tok_prim_wrapper", "cell_list", "single_cell", "$@31", "$@32",
  "prim_list", "single_prim", "$@33", "cell_parameter_list_opt",
  "cell_parameter_list", "cell_parameter", "cell_port_list",
  "cell_port_list_rules", "cell_port", "always_stmt", "$@34", "$@35",
  "$@36", "always_cond", "always_events", "always_event", "opt_label",
  "opt_property", "opt_stmt_label", "assert", "assert_property",
  "simple_behavioral_stmt", "behavioral_stmt", "$@37", "$@38", "$@39",
  "$@40", "$@41", "$@42", "$@43", "$@44", "$@45", "unique_case_attr",
  "case_attr", "case_type", "opt_synopsys_attr", "behavioral_stmt_list",
  "optional_else", "$@46", "case_body", "case_item", "$@47", "$@48",
  "gen_case_body", "gen_case_item", "$@49", "$@50", "case_select",
  "case_expr_list", "rvalue", "lvalue", "lvalue_concat_list",
  "opt_arg_list", "arg_list", "arg_list2", "single_arg", "module_gen_body",
  "gen_stmt_or_module_body_stmt", "gen_stmt", "$@51", "$@52", "$@53",
  "$@54", "$@55", "gen_stmt_block", "$@56", "gen_stmt_or_null",
  "opt_gen_else", "expr", "basic_expr", "$@57", "concat_list", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,   124,   340,    94,   341,    38,
     342,   343,   344,   345,   346,    60,   347,   348,    62,   349,
     350,   351,   352,    43,    45,    42,    47,    37,   353,   354,
     355,    44,    61,    46,    59,    35,    40,    41,    58,    91,
      93,    64,   123,   125,    63,   126,    33
};
# endif

#define YYPACT_NINF -722

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-722)))

#define YYTABLE_NINF -356

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -722,    83,   311,  -722,  -722,  -722,  -722,  -722,   223,  -722,
     311,   311,   311,   311,   311,   311,    84,    75,    75,   115,
     117,   142,   136,   136,   184,  -722,  -722,  -722,  -722,  -722,
    -722,  -722,  -722,    95,  -722,    92,  -722,   168,   168,  -722,
    -722,    71,  -722,   183,   210,    84,   212,    84,   230,  1207,
     238,  -722,   169,   169,   152,   143,  -722,   275,   279,  -722,
      63,  -722,   284,  -722,  -722,  -722,  -722,   301,  -722,  -722,
    -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  1207,
    1207,  -722,  -722,   112,  -722,  -722,  1575,  -722,  -722,   189,
     189,   197,   199,  -722,   206,   325,   234,  -722,  1207,  -722,
    -722,   346,   236,  -722,  -722,   240,   244,  1207,  1207,  1207,
    1207,  1207,  1207,  1207,  1207,   172,   -32,   254,  1207,  1207,
    -722,  1207,  -722,   189,   189,  -722,  -722,  -722,  -722,  -722,
    -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,
    -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,
    -722,  -722,  -722,  -722,   369,   369,  -722,    21,   270,    56,
     394,   291,  -722,   412,   146,  -722,   315,   314,  1207,  1207,
    -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,   431,  1207,
    1207,  1207,  -722,  -722,  -722,   150,   328,  -722,  -722,  1207,
    1207,  1207,  1207,  1207,  1207,  1207,  1207,  1207,  1207,  1207,
    1207,  1207,  1207,  1207,  1207,  1207,  1207,  1207,  1207,  1207,
    1207,  1207,  1207,  1207,  1207,  1207,   354,    33,  -722,   149,
     222,  -722,   355,  -722,  -722,   356,  -722,  -722,  -722,  -722,
    -722,   465,  -722,    -5,  -722,   206,   466,  1207,  1207,  1207,
    -722,   236,  -722,   468,  -722,   357,   358,  -722,   359,   362,
    -722,   373,   379,  1207,  1616,  1640,  1662,  1662,  1129,  1129,
    1680,  1680,  1589,  1589,  1589,  1589,   381,   381,   381,   381,
     233,   233,   233,   233,   262,   262,   397,   397,   397,  -722,
     376,  1207,   369,  -722,  -722,  -722,  -722,   391,  -722,  -722,
     396,   399,   189,   386,    74,   398,  1348,  -722,   394,  -722,
     400,  -722,   393,   404,   405,   403,   189,  -722,   408,  -722,
    -722,   389,  -722,  -722,  1207,   406,    84,   415,  -722,  -722,
    -722,  1207,  -722,  -722,    75,    75,   222,   410,  1207,  -722,
    -722,   526,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,
    -722,  -722,  -722,   229,  -722,  -722,  -722,  -722,  -722,   189,
     416,   417,   420,   423,  -722,  -722,  -722,   176,    65,  -722,
     469,   470,   472,   479,   547,  1569,  -722,  -722,  -722,  -722,
    -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,
     437,  -722,  -722,  -722,   206,  -722,  -722,  -722,  -722,   189,
    -722,  -722,   189,    73,  -722,   434,  -722,  -722,    80,  1207,
    1444,  -722,   214,   829,  -722,  -722,  -722,   353,  -722,   440,
    -722,   336,  -722,   179,   438,  -722,    88,  -722,  1207,   439,
    -722,   168,   168,  -722,  -722,  -722,  -722,  -722,  -722,  -722,
      84,   166,  -722,    55,   554,  -722,  1207,  -722,   443,  -722,
     556,   196,  -722,  -722,  -722,   447,   453,   454,  -722,   456,
    1207,   566,   173,  -722,  1488,   457,   458,   461,   464,   474,
    -722,  -722,  -722,  -722,  -722,   568,   578,   189,   416,  1207,
     475,   629,  -722,  -722,   473,  -722,  -722,  -722,  -722,  1207,
     463,   480,   417,   476,   484,   485,   486,  -722,  -722,  -722,
    -722,  -722,   524,   524,   524,     2,  -722,   487,  -722,  -722,
     416,   416,  -722,  -722,  -722,   189,   189,   396,   492,   189,
    -722,   187,  -722,   494,  -722,  -722,   490,    55,   778,  -722,
     503,    11,  -722,  -722,  -722,  1249,  1249,  1207,   491,  -722,
     188,   566,  -722,  -722,  -722,  -722,  -722,   459,   843,   886,
    1207,  -722,   496,   493,   829,  -722,  -722,  -722,  -722,   495,
    -722,  -722,   468,  -722,   274,  -722,  1207,  -722,  1207,  -722,
    1207,  1207,   320,  -722,  -722,   500,  -722,   502,   504,   505,
    -722,   506,  1207,  1207,  1207,   369,   369,  -722,  1207,  -722,
      55,  -722,  1207,  1535,  -722,   510,   621,   622,  -722,    91,
    -722,   531,  -722,  -722,   556,   135,   518,  1207,  -722,   520,
    -722,  -722,  -722,   514,  1207,  -722,  -722,  1207,   519,  1207,
     521,  1207,   525,   530,  -722,   532,   633,    19,  -722,  -722,
    -722,  -722,   468,   633,  -722,  -722,  -722,  1207,  -722,  -722,
     533,    55,   534,   535,  1207,   527,   931,   951,  1000,  1020,
     536,  -722,  -722,  -722,  -722,  -722,  -722,  -722,   417,  -722,
    1207,  -722,  -722,   778,   540,   645,  -722,   556,  -722,   561,
     520,   172,  1207,  -722,  1207,   543,   549,   553,   551,   555,
     557,   558,   562,  1441,  1065,   189,   203,  -722,   569,  -722,
     652,   829,   243,   250,   559,  -722,   563,  -722,   260,  -722,
     571,  -722,   570,   613,  -722,   565,  -722,  -722,   415,  -722,
    1207,   572,  1207,   573,  1207,   576,   580,   583,  -722,  -722,
     637,  1581,  -722,  -722,  -722,  -722,   134,  -722,  -722,   645,
     584,   594,   589,  -722,   596,  -722,   598,  -722,   599,  -722,
    -722,  -722,   704,   161,  -722,  -722,  -722,   602,   633,  -722,
    -722,  -722,  1207,  1207,   603,    16,  -722,  -722,  -722,   717,
    -722,  -722,   468,   608,  1207,   633,  -722,  1076,   678,  1207,
     417,  -722,   829,  1207,   829,   829,   609,   612,   616,   614,
     618,   617,   631,  -722,   638,  -722,   640,  -722,  -722,   646,
     645,  -722,   619,  -722,  1207,  1207,  -722,  -722,  -722,   648,
    1065,  -722,   649,  1076,  -722,  -722,  -722,  -722,   798,   798,
    -722,  -722,  -722,  -722,  -722,  -722,   757,   650,   651,  -722,
    -722,  -722,  -722,  1153,   653,  -722,   732,  -722,  -722,  -722,
    -722,   655,  -722,   657,  -722,   658,  -722,  -722,   371,  -722,
    -722,  -722,    55,  -722,  -722,   664,  -722,  1207,  -722,  1076,
     659,  -722,  -722,   663,  -722,  1076,   -31,  -722,   -10,  -722,
    -722,  -722,  -722,   666,  -722,  -722,  -722,  -722,  -722,   739,
     669,  1207,   670,   671,  -722,  1200,  -722,   640,  1207,  -722,
     829,    55,  -722,  -722,  1153,  -722,   679,  -722,  -722,  -722,
     672,  -722,  -722,  -722,   674,  -722,  -722,  1207,  -722,  -722,
     829,   681,   829,  -722,  1207,  -722,   682,  1207,   683,  1207,
     684,  1207,   685,  1207,   687,  1207,   689,  1207,  -722
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       2,     0,    11,     1,    15,   201,   203,     3,     0,    14,
      11,    11,    11,    11,    11,    11,    19,   195,   195,     0,
       0,     0,   133,   133,    12,     5,     4,     9,     6,     7,
       8,    24,    16,    18,    20,    22,   194,   197,   197,    27,
      55,     0,   132,   135,     0,    19,     0,     0,     0,     0,
       0,   196,   199,   199,    32,     0,   114,     0,     0,   134,
      90,   120,     0,    17,    21,    25,   399,   397,   398,    11,
      11,    11,    11,    11,    11,    11,    11,    11,    11,     0,
       0,    11,    11,    90,   393,    23,   391,    26,   198,    90,
      90,     0,    42,    58,   127,     0,     0,    94,     0,    89,
      93,     0,   137,    13,   396,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   444,     0,     0,     0,
     395,     0,   400,    89,   360,   359,    11,    11,    11,    11,
      11,    11,    11,    11,    11,    11,    11,    11,    11,    11,
      11,    11,    11,    11,    11,    11,    11,    11,    11,    11,
      11,    11,    11,   200,     0,     0,    29,    11,     0,     0,
     131,     0,   116,     0,     0,   122,   138,     0,     0,     0,
     417,   418,   419,   420,   415,   416,   439,   440,   404,     0,
       0,     0,   406,   408,   443,     0,     0,    87,    88,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   205,     0,
      35,    50,     0,    41,    67,    47,    44,    97,    56,    57,
      59,   125,   130,     0,   115,   127,     0,     0,     0,     0,
      86,   137,   136,    11,   147,     0,     0,   394,     0,   444,
     445,     0,    86,   368,   442,   441,   411,   412,   413,   414,
     409,   410,   427,   428,   429,   430,   425,   426,   431,   432,
     421,   422,   423,   424,   433,   434,   435,   436,   437,   438,
       0,     0,     0,   202,   204,    36,    38,    30,    33,    40,
      49,     0,    90,     0,    11,     0,    11,   124,   129,   126,
       0,   118,     0,     0,     0,     0,    90,    67,    47,   141,
     145,    11,   402,   403,     0,     0,     0,    47,   367,   369,
     371,     0,   207,   206,   195,   195,    35,     0,     0,    51,
      54,     0,    72,    73,    74,    75,    76,    77,    78,    80,
      79,    81,    82,    66,    71,    69,    45,    43,    28,    90,
      66,   279,     0,     0,   332,   333,   334,     0,     0,   373,
       0,     0,     0,     0,     0,    67,   109,    95,   111,    98,
      99,   103,   100,   101,   102,   104,   105,   106,   107,   110,
       0,    96,   128,   117,   127,    84,    85,    83,   147,    92,
      91,   225,    90,    11,   139,    24,   121,   311,     0,     0,
      67,   304,    90,    11,   307,   308,   306,     0,   305,     0,
     146,     0,   361,     0,     0,   407,    90,   358,    46,     0,
     392,   197,   197,    34,    31,    48,    52,    65,    68,    70,
       0,     0,   209,     0,     0,   383,     0,   376,     0,   149,
       0,     0,   151,   152,   153,     0,     0,     0,   154,     0,
       0,     0,     0,   158,    11,     0,     0,     0,     0,     0,
     230,   234,   261,   264,   235,     0,     0,    90,    66,     0,
       0,    11,   143,   142,     0,   282,    60,    61,    62,     0,
       0,   363,   279,     0,     0,     0,     0,    11,    11,   331,
     312,   309,   281,   281,   281,   281,   310,     0,   301,   302,
      66,    66,   405,   370,   401,    90,    90,    49,     0,    90,
     208,     0,   227,     0,   278,   373,     0,     0,     0,   182,
       0,   181,   148,   150,   161,     0,     0,     0,     0,   193,
       0,     0,   155,   108,   375,   372,   374,     0,     0,     0,
       0,   112,   248,   271,    11,   215,   217,   212,   232,     0,
     119,   123,     0,   140,     0,   362,     0,   314,     0,   316,
       0,     0,   328,   330,   329,   366,   280,     0,     0,     0,
     290,     0,     0,     0,     0,     0,     0,    53,     0,   210,
       0,   226,     0,    11,   379,     0,     0,     0,   188,     0,
     187,     0,   179,   180,     0,   181,   173,     0,   162,   165,
     190,   163,   160,   191,     0,   156,   159,     0,     0,     0,
       0,     0,     0,     0,    97,     0,     0,     0,   262,   265,
     219,   219,     0,   245,   381,   144,    63,     0,   364,   339,
       0,     0,     0,     0,   368,     0,     0,     0,     0,     0,
       0,   303,   300,    37,    39,   211,   228,   229,   279,   385,
       0,   185,   186,     0,     0,     0,   175,     0,   174,     0,
       0,   193,     0,   166,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    11,   251,   238,     0,   236,     0,   270,
       0,    11,     0,     0,   213,   221,   223,   244,     0,   242,
       0,   349,     0,    11,   324,     0,   320,   322,    47,   313,
       0,     0,     0,     0,     0,     0,     0,     0,   326,   384,
     390,    11,   377,   189,   184,   183,     0,   177,   176,     0,
       0,   167,     0,   157,     0,   293,     0,   294,     0,   298,
     297,   113,     0,     0,   249,   252,   240,     0,     0,   231,
     268,   269,     0,     0,     0,     0,   272,   277,   263,     0,
     216,   218,     0,     0,     0,   245,   233,   257,   350,     0,
     279,   338,    11,     0,    11,    11,     0,     0,     0,     0,
       0,     0,     0,   289,     0,   337,   385,   380,   386,     0,
       0,   172,     0,   164,     0,     0,   295,   296,   299,     0,
     251,   247,     0,   257,   237,   275,   276,   267,     0,     0,
     266,   220,   222,   214,   224,   243,     0,     0,   254,   255,
     258,   382,   348,     0,     0,   315,   342,   317,   321,   323,
     365,     0,   284,     0,   285,     0,   291,   288,   344,   388,
     387,   389,     0,   178,   171,   168,   192,     0,   250,   257,
       0,   273,   274,     0,   246,   257,   354,   351,     0,   356,
      64,   340,   325,     0,   286,   287,   292,   335,   336,   345,
       0,     0,     0,     0,   239,     0,   256,   385,     0,   353,
      11,     0,   327,   343,     0,   385,     0,   253,   241,   260,
       0,   352,   357,   341,     0,   346,   378,     0,   259,   318,
      11,     0,    11,   347,     0,   319,   169,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   170
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -722,  -722,  -722,   436,    22,  -722,  -722,     0,  -722,  -722,
     761,  -722,   760,   -16,  -722,  -722,  -722,  -722,  -722,  -722,
     482,  -722,  -722,  -722,  -722,  -301,   302,   516,  -722,  -722,
    -722,  -722,  -722,  -722,  -282,  -280,  -198,  -722,  -722,  -722,
     471,   -82,   507,   -30,  -722,  -722,   198,  -290,  -722,  -722,
    -278,  -722,  -722,  -722,  -722,  -722,   513,  -191,  -722,   792,
    -722,   579,  -722,  -722,  -722,   426,  -722,   433,  -722,  -722,
     382,  -305,  -722,   375,   293,  -722,  -722,   296,   167,  -722,
    -722,  -722,  -722,  -722,   235,  -534,  -643,  -722,   178,  -722,
    -552,  -722,  -395,    -1,   -33,   776,   -87,    52,  -722,    36,
    -722,   677,  -200,  -722,  -722,   326,  -273,  -722,  -722,  -722,
    -722,   215,  -722,    93,  -509,  -722,  -722,   271,  -722,  -722,
    -722,  -722,  -722,  -595,  -722,  -722,  -722,    85,  -722,  -722,
    -722,    60,  -721,  -722,     7,  -722,  -722,  -722,  -722,  -722,
    -722,  -364,  -463,   -68,  -722,  -722,  -722,  -489,  -399,  -722,
    -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,   -46,
     442,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,  -722,
    -722,  -722,  -722,   -18,  -722,  -186,  -377,   303,  -722,   224,
    -722,   451,   342,   159,  -288,  -722,  -722,  -722,  -722,  -722,
    -627,  -722,    -7,  -722,   -40,  1236,  -722,   272
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     7,   400,     9,    24,   401,    16,    46,
      32,    33,    34,    83,    11,    54,    92,   220,   327,   287,
     288,   324,   325,   158,   225,   295,   329,   226,   290,   507,
      12,    55,   159,   229,   403,   428,   467,   293,   343,   344,
     345,    99,   124,   153,   391,   101,   296,   534,   368,   614,
      13,    94,   235,   384,   102,   241,   232,   161,   233,    43,
      60,   167,   243,   474,   308,   309,   552,   311,   370,   441,
     442,   371,   451,   452,   453,   444,   445,   598,   663,   446,
     447,   520,   595,   716,   596,   521,   717,   448,   588,   589,
     599,   602,   600,    37,    52,    89,   154,   404,    17,   405,
      18,   217,   218,   374,   431,   432,   406,   622,   753,   620,
     621,   682,   684,   685,   310,   376,   511,   512,   377,   542,
     623,   468,   676,   687,   737,   792,   688,   689,   690,   616,
     733,   734,   807,   808,   809,   378,   543,   681,   544,   618,
     745,   746,   435,   567,   407,   408,   379,   409,   410,   565,
     629,   631,   853,   892,   764,   765,   762,   775,   489,   411,
     380,   828,   693,   852,   870,   859,   873,   874,   890,   758,
     812,   813,   867,   847,   848,    84,   413,   480,   635,   317,
     318,   319,   454,   535,   536,   517,   779,   649,   691,   515,
     830,   711,   831,   777,   529,    86,   186,   117
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      35,   123,    10,   155,   491,    53,   367,   394,   381,    85,
      10,    10,    10,    10,    10,    10,   419,    38,   369,   557,
     289,   677,   710,   375,     8,   221,   292,   678,   585,    35,
     100,    35,     8,     8,     8,     8,     8,     8,    15,   115,
     116,   187,   188,   625,   300,   660,    15,    15,    15,    15,
      15,    15,   443,   125,    14,   528,   513,   798,   164,    31,
     656,   427,    14,    14,    14,    14,    14,    14,   427,   449,
     433,     6,   840,   566,   228,    56,   782,   306,   221,   180,
    -355,   185,   323,     3,   476,   477,   478,  -355,    31,    97,
     181,   105,   106,   107,   108,   109,   110,   111,   112,   113,
     114,   868,    36,   118,   119,   122,   298,    48,   869,   392,
     721,    48,   299,   686,   592,   593,   570,   120,   863,    39,
     -11,    40,   594,   718,   679,   412,   289,   799,   245,   246,
     417,    48,   603,   800,   222,   680,   443,   833,   223,   248,
     249,   249,   695,   794,   282,   619,    41,   283,   189,   190,
     191,   192,   193,   194,   195,   196,   197,   198,   199,   200,
     201,   202,   203,   204,   205,   206,   207,   208,   209,   210,
     211,   212,   213,   214,   215,   280,   369,   399,    42,   224,
     438,   375,    98,    57,   450,   709,   427,   222,   548,    58,
     -46,   -46,    45,   470,    51,   230,   479,   302,   303,   304,
     438,    50,   653,   513,    49,    50,    47,   121,   654,   665,
      59,   237,   238,   320,    61,   237,   238,   412,   427,   427,
     573,   574,   -11,    63,   123,    50,   216,    88,   -11,   439,
     358,   121,   835,    48,    65,    19,   285,   286,   592,   593,
      20,   322,    87,   686,   508,   780,   657,   412,   886,   522,
     358,   781,   335,   336,   337,   338,   339,    93,   498,   499,
     282,    21,   331,   284,   239,   307,   240,    91,   239,   722,
     252,    22,   790,    23,   414,   500,   390,   509,   791,    95,
     510,   420,   748,    96,   531,   412,   340,   532,   425,   178,
     179,   501,   440,   103,   761,   402,   366,   815,   580,   531,
     416,   581,   605,   341,   342,   369,   104,   188,    98,   876,
     375,   -10,   440,   156,   738,   157,   224,   739,   365,   430,
     123,     4,   160,   421,   422,     5,     6,    50,   -11,   162,
     -11,   412,   373,   121,   123,   891,   146,   147,   148,   149,
     150,   151,   896,   860,   398,   898,   163,   900,   372,   902,
     165,   904,   166,   906,   749,   908,   168,   750,   412,   481,
     169,   749,   472,   816,   751,   818,   819,   148,   149,   150,
     151,   755,   125,   216,   756,   643,   644,   182,   320,   354,
     355,   356,   884,   367,   227,   381,   125,   402,   505,   506,
     836,   626,   627,   395,   412,   369,   516,   766,   231,     4,
     375,   487,   488,     5,     6,   234,   332,   333,   334,   335,
     336,   337,   338,   339,   416,   307,   236,   416,   575,   576,
     492,   493,   494,   495,   490,   568,   569,   571,   244,   549,
     857,   858,   242,   369,   841,   842,   247,   547,   375,   554,
     396,   563,   564,   340,   253,   412,    25,    26,    27,    28,
      29,    30,   250,   251,   366,   402,  -283,  -283,  -283,  -283,
     341,   342,    66,    31,    67,    68,   281,   294,   291,   297,
     301,   883,   306,   180,   312,   313,   365,   314,   590,   430,
     142,   143,   144,   145,   146,   147,   148,   149,   150,   151,
     373,   893,   316,   895,   321,   412,   315,   608,   610,   612,
     613,   416,   326,   397,   398,   151,   372,   412,   328,   562,
     562,   399,   330,   385,   383,   347,   481,   388,   630,   393,
     632,   633,    69,    70,   386,   387,   418,   424,   402,   415,
     426,   398,   640,   641,   642,   434,   436,   607,   645,   437,
     455,   456,   647,   457,    71,    72,    73,    74,    75,    76,
     458,   459,   475,   469,   496,   502,   504,   661,   514,   518,
     519,   524,    77,    78,   416,   525,   526,   666,   527,   668,
     449,   670,   545,   537,   538,    79,   412,   539,   412,   412,
     540,    80,   546,   366,    81,    82,   555,   692,   541,   550,
     553,   556,   558,   736,   320,   566,   701,   703,   705,   707,
     559,   560,   561,   572,   578,   365,   582,   584,   591,   604,
     712,   615,   624,   590,   617,   416,   634,   395,   636,   373,
     637,   638,   639,     4,   650,   651,   652,     5,     6,   655,
     659,   662,   664,   395,   735,   372,   667,   675,   669,     4,
     747,   699,   671,     5,     6,   760,   412,   672,   674,   715,
     694,   696,   697,   708,   714,    66,    31,    67,    68,   719,
     767,   741,   769,   723,   771,   402,   724,   725,   726,   727,
     752,   776,   729,   366,   728,   754,   730,   402,   551,   763,
    -283,  -283,  -283,  -283,   412,   412,   740,   757,   759,   768,
     770,   742,   743,   772,   773,   365,  -283,  -283,  -283,  -283,
     774,   783,   795,   796,   412,   784,   412,   785,   789,   373,
     786,   366,   787,   788,   804,    69,    70,   810,   793,   814,
     797,   801,   803,   817,   811,   372,   820,   397,   398,   821,
     822,   823,   824,   365,   825,   399,   834,    71,    72,    73,
      74,    75,    76,   397,   398,   826,   402,   373,   402,   402,
     735,   399,   827,   810,   829,    77,    78,   744,   747,   747,
     832,   843,   845,   372,   837,   839,   851,   844,    79,   854,
     850,   855,   856,   849,    80,   861,   864,    81,    82,   865,
     871,    66,    31,    67,    68,   872,   875,   877,   878,   888,
     887,   889,   894,   897,   899,   901,   903,   862,   905,   810,
     907,    66,    31,    67,    68,   810,    62,    64,   423,   577,
     346,   382,   673,   389,   429,    44,   416,   586,   587,   473,
     305,   471,   601,   523,   606,   880,   530,   720,   882,    90,
     658,   713,   219,   395,   849,   579,   683,   742,   743,     4,
     805,    69,    70,     5,     6,   802,    66,    31,    67,    68,
     838,   646,   866,   497,   402,   416,   885,   583,   698,   628,
     881,    69,    70,    71,    72,    73,    74,    75,    76,   503,
     778,     0,     0,     0,   402,     0,   402,     0,     0,     0,
       0,    77,    78,    71,    72,    73,    74,    75,    76,    66,
      31,    67,    68,     0,    79,     0,  -283,  -283,  -283,  -283,
      80,    77,    78,    81,    82,     0,    69,    70,     0,     0,
       0,     0,     0,     0,    79,     0,     0,     0,     0,     0,
      80,   609,     0,    81,    82,     0,     0,     0,    71,    72,
      73,    74,    75,    76,    66,    31,    67,    68,     0,     0,
       0,     0,     0,   397,   398,     0,    77,    78,     0,    69,
      70,   399,     0,     0,    66,    31,    67,    68,     0,    79,
       0,     0,     0,     0,   611,    80,     0,     0,    81,    82,
       0,    71,    72,    73,    74,    75,    76,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    77,
      78,     0,     0,     0,    69,    70,     0,     0,     0,     0,
       0,     0,    79,    66,    31,    67,    68,     0,    80,   700,
       0,    81,    82,     0,    69,    70,    71,    72,    73,    74,
      75,    76,     0,    66,    31,    67,    68,     0,     0,   702,
       0,     0,     0,     0,    77,    78,    71,    72,    73,    74,
      75,    76,     0,     0,     0,     0,     0,    79,     0,     0,
       0,     0,     0,    80,    77,    78,    81,    82,     0,     0,
       0,     0,     0,    69,    70,     0,     0,    79,    66,    31,
      67,    68,     0,    80,     0,     0,    81,    82,   704,    66,
      31,    67,    68,    69,    70,    71,    72,    73,    74,    75,
      76,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    77,    78,    71,    72,    73,    74,    75,
      76,     0,     0,     0,     0,     0,    79,     0,     0,     0,
       0,     0,    80,    77,    78,    81,    82,     0,    69,    70,
       0,     0,     0,     0,     0,     0,    79,   706,     0,    69,
      70,     0,    80,     0,     0,    81,    82,     0,     0,     0,
      71,    72,    73,    74,    75,    76,    66,    31,    67,    68,
       0,    71,    72,    73,    74,    75,    76,     0,    77,    78,
       0,     0,     0,     0,     0,     0,     0,     0,   732,    77,
      78,    79,     0,     0,     0,     0,     0,    80,     0,   806,
      81,    82,    79,     0,     0,     0,     0,     0,    80,     0,
     846,    81,    82,    66,    31,    67,    68,     0,     0,     0,
      66,    31,    67,    68,     0,     0,    69,    70,   132,   133,
     134,   135,   136,   137,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   147,   148,   149,   150,   151,    71,    72,
      73,    74,    75,    76,     0,     0,     0,     0,     0,     0,
       0,     0,    66,    31,    67,    68,    77,    78,     0,     0,
       0,     0,     0,    69,    70,     0,     0,     0,     0,    79,
      69,    70,     0,     0,     0,    80,     0,     0,    81,    82,
       0,     0,     0,     0,     0,    71,    72,    73,    74,    75,
      76,     0,    71,    72,    73,    74,    75,    76,     0,     0,
       0,     0,     0,    77,    78,     0,     0,     0,     0,     0,
      77,    78,    69,    70,     0,     0,    79,   879,     0,     0,
       0,     0,    80,    79,     0,    81,    82,     0,     0,    80,
       0,     0,    81,    82,    71,    72,    73,    74,    75,    76,
       0,     0,     0,   170,   171,   172,   173,   174,   175,   176,
     177,     0,    77,    78,   183,   184,     0,     0,     4,     0,
       0,   348,     5,     6,   349,   597,     0,     0,     0,     0,
       0,    80,     0,     0,    81,    82,   350,     0,     0,   351,
       0,   352,     0,   353,     0,     0,     0,     0,     0,     0,
       0,   354,   355,   356,     0,     0,     0,     0,     0,     0,
     357,     0,   358,   359,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   360,   361,   362,   363,     0,
       0,     0,     0,     0,   364,   254,   255,   256,   257,   258,
     259,   260,   261,   262,   263,   264,   265,   266,   267,   268,
     269,   270,   271,   272,   273,   274,   275,   276,   277,   278,
     279,     4,     0,     0,     0,     5,     6,   349,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   350,
       0,     0,   351,     0,   352,   482,   353,   483,     0,   484,
     485,   486,     0,     0,   354,   355,   356,  -328,  -328,  -328,
       0,     0,     0,   357,     0,   358,   359,     0,     4,     0,
       0,     0,     5,     6,   349,   465,   466,     0,   360,   361,
     362,   363,     0,     0,     0,     0,   350,   364,   731,   351,
       0,   352,     0,   353,     0,   487,   488,     0,     0,     0,
       0,   354,   355,   356,     0,     0,     0,     0,     0,     0,
     357,     0,   358,   359,   533,     4,     0,     0,     0,     5,
       6,   349,     0,     0,     0,   360,   361,   362,   363,     0,
       0,     0,     0,   350,   364,     0,   351,   648,   352,     0,
     353,     0,     0,   460,     0,     0,   461,     0,   354,   355,
     356,     0,     0,     0,     0,     0,     0,   357,     0,   358,
     359,     4,     0,     0,     0,     5,     6,   349,   462,   463,
       0,     0,   360,   361,   362,   363,     0,    21,     0,   350,
     464,   364,   351,     0,   352,     0,   353,    22,     0,    23,
       0,     0,     0,     0,   354,   355,   356,     0,     0,     0,
     465,   466,     0,   357,     0,   358,   359,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   360,   361,
     362,   363,     0,     0,     0,     0,     0,   364,   126,   127,
     128,   129,   130,   131,   132,   133,   134,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146,   147,
     148,   149,   150,   151,   138,   139,   140,   141,   142,   143,
     144,   145,   146,   147,   148,   149,   150,   151,     0,   152,
     127,   128,   129,   130,   131,   132,   133,   134,   135,   136,
     137,   138,   139,   140,   141,   142,   143,   144,   145,   146,
     147,   148,   149,   150,   151,   128,   129,   130,   131,   132,
     133,   134,   135,   136,   137,   138,   139,   140,   141,   142,
     143,   144,   145,   146,   147,   148,   149,   150,   151,   130,
     131,   132,   133,   134,   135,   136,   137,   138,   139,   140,
     141,   142,   143,   144,   145,   146,   147,   148,   149,   150,
     151,   134,   135,   136,   137,   138,   139,   140,   141,   142,
     143,   144,   145,   146,   147,   148,   149,   150,   151
};

static const yytype_int16 yycheck[] =
{
      16,    83,     2,    90,   403,    38,   296,   308,   296,    49,
      10,    11,    12,    13,    14,    15,   317,    18,   296,   482,
     220,   616,   649,   296,     2,     4,   224,     8,   517,    45,
      60,    47,    10,    11,    12,    13,    14,    15,     2,    79,
      80,   123,   124,   552,   235,   597,    10,    11,    12,    13,
      14,    15,   357,    83,     2,   450,   433,    41,    98,     4,
     594,   343,    10,    11,    12,    13,    14,    15,   350,     4,
     350,    15,   793,    71,    18,     4,   719,     4,     4,   111,
     111,   121,   282,     0,     4,     5,     6,   118,     4,    26,
     122,    69,    70,    71,    72,    73,    74,    75,    76,    77,
      78,   111,    27,    81,    82,    83,   111,    19,   118,   307,
     662,    19,   117,   622,   103,   104,   114,     5,   839,     4,
       8,     4,   111,   657,   105,   311,   326,   111,   168,   169,
     316,    19,   527,   117,   113,   116,   441,   780,   117,   179,
     180,   181,   631,   738,   111,   544,     4,   114,   126,   127,
     128,   129,   130,   131,   132,   133,   134,   135,   136,   137,
     138,   139,   140,   141,   142,   143,   144,   145,   146,   147,
     148,   149,   150,   151,   152,   215,   454,   122,    42,   157,
       4,   454,   119,   112,   119,   648,   468,   113,   468,   118,
     117,   117,     8,   384,    26,   159,   116,   237,   238,   239,
       4,   113,   111,   580,   112,   113,   111,   119,   117,   604,
      27,    65,    66,   253,     4,    65,    66,   403,   500,   501,
     500,   501,     8,    11,   306,   113,     4,    58,   116,    53,
      54,   119,   784,    19,     4,    12,    14,    15,   103,   104,
      17,   281,     4,   752,   430,   111,   111,   433,   875,    53,
      54,   117,    23,    24,    25,    26,    27,   114,    79,    80,
     111,    38,   292,   114,   118,   243,   120,   115,   118,   664,
     120,    48,   111,    50,   314,    96,   306,   111,   117,     4,
     114,   321,   681,     4,   111,   471,    57,   114,   328,   117,
     118,   112,   116,     9,   693,   311,   296,   760,   111,   111,
     316,   114,   114,    74,    75,   583,     5,   389,   119,   861,
     583,     0,   116,   116,   111,   116,   294,   114,   296,   349,
     402,    10,   116,   324,   325,    14,    15,   113,   114,     4,
     116,   517,   296,   119,   416,   887,   103,   104,   105,   106,
     107,   108,   894,   832,   115,   897,   112,   899,   296,   901,
       4,   903,   116,   905,   111,   907,   116,   114,   544,   399,
     116,   111,   392,   762,   114,   764,   765,   105,   106,   107,
     108,   111,   402,     4,   114,   575,   576,   123,   418,    43,
      44,    45,   871,   673,   114,   673,   416,   403,   421,   422,
     785,   117,   118,     4,   580,   673,   436,   698,     4,    10,
     673,    81,    82,    14,    15,   114,    20,    21,    22,    23,
      24,    25,    26,    27,   430,   393,     4,   433,   505,   506,
      67,    68,    69,    70,   402,   493,   494,   495,   114,   469,
      59,    60,   117,   711,   798,   799,     5,   467,   711,   479,
      51,   487,   488,    57,   116,   631,    10,    11,    12,    13,
      14,    15,   180,   181,   454,   471,    67,    68,    69,    70,
      74,    75,     3,     4,     5,     6,   112,   111,   113,     4,
       4,   870,     4,   111,   117,   117,   454,   118,   518,   509,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     454,   890,   113,   892,   118,   681,   123,   537,   538,   539,
     540,   517,   111,   114,   115,   108,   454,   693,   112,   487,
     488,   122,   113,   120,   114,   117,   556,   114,   558,   111,
     560,   561,    63,    64,   120,   120,   111,   117,   544,   123,
       4,   115,   572,   573,   574,   118,   116,    78,   578,   116,
      71,    71,   582,    71,    85,    86,    87,    88,    89,    90,
      71,     4,   118,   116,   114,   117,   117,   597,     4,   116,
       4,   114,   103,   104,   580,   112,   112,   607,   112,   609,
       4,   611,     4,   116,   116,   116,   762,   116,   764,   765,
     116,   122,     4,   583,   125,   126,   123,   627,   114,   114,
     117,   111,   116,   675,   634,    71,   636,   637,   638,   639,
     116,   116,   116,   116,   112,   583,   112,   117,   105,   118,
     650,   115,   117,   653,   121,   631,   116,     4,   116,   583,
     116,   116,   116,    10,   114,     4,     4,    14,    15,    98,
     112,   111,   118,     4,   674,   583,   117,     4,   117,    10,
     680,   114,   117,    14,    15,    32,   832,   117,   116,     4,
     117,   117,   117,   117,   114,     3,     4,     5,     6,    98,
     700,     9,   702,   120,   704,   681,   117,   114,   117,   114,
     111,    34,   114,   673,   117,   112,   114,   693,    49,   114,
      67,    68,    69,    70,   870,   871,   117,   116,   118,   117,
     117,    39,    40,   117,   114,   673,    67,    68,    69,    70,
     117,   117,   742,   743,   890,   111,   892,   118,     4,   673,
     114,   711,   114,   114,   754,    63,    64,   757,   116,   759,
     117,     4,   114,   763,    46,   673,   117,   114,   115,   117,
     114,   117,   114,   711,   117,   122,   117,    85,    86,    87,
      88,    89,    90,   114,   115,   114,   762,   711,   764,   765,
     790,   122,   114,   793,   114,   103,   104,   105,   798,   799,
     114,     4,   111,   711,   116,   116,    34,   117,   116,   114,
     117,   114,   114,   813,   122,   111,   117,   125,   126,   116,
     114,     3,     4,     5,     6,    46,   117,   117,   117,   117,
     111,   117,   111,   111,   111,   111,   111,   837,   111,   839,
     111,     3,     4,     5,     6,   845,    45,    47,   326,   507,
     294,   298,   614,   306,   343,    23,   832,    39,    40,   393,
     241,   388,   526,   441,   531,   865,   451,   660,   868,    53,
     595,   653,   155,     4,   874,   509,   621,    39,    40,    10,
     755,    63,    64,    14,    15,   752,     3,     4,     5,     6,
     790,   580,   845,   411,   870,   871,   874,   515,   634,   556,
     867,    63,    64,    85,    86,    87,    88,    89,    90,   418,
     711,    -1,    -1,    -1,   890,    -1,   892,    -1,    -1,    -1,
      -1,   103,   104,    85,    86,    87,    88,    89,    90,     3,
       4,     5,     6,    -1,   116,    -1,    67,    68,    69,    70,
     122,   103,   104,   125,   126,    -1,    63,    64,    -1,    -1,
      -1,    -1,    -1,    -1,   116,    -1,    -1,    -1,    -1,    -1,
     122,    78,    -1,   125,   126,    -1,    -1,    -1,    85,    86,
      87,    88,    89,    90,     3,     4,     5,     6,    -1,    -1,
      -1,    -1,    -1,   114,   115,    -1,   103,   104,    -1,    63,
      64,   122,    -1,    -1,     3,     4,     5,     6,    -1,   116,
      -1,    -1,    -1,    -1,    78,   122,    -1,    -1,   125,   126,
      -1,    85,    86,    87,    88,    89,    90,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   103,
     104,    -1,    -1,    -1,    63,    64,    -1,    -1,    -1,    -1,
      -1,    -1,   116,     3,     4,     5,     6,    -1,   122,    78,
      -1,   125,   126,    -1,    63,    64,    85,    86,    87,    88,
      89,    90,    -1,     3,     4,     5,     6,    -1,    -1,    78,
      -1,    -1,    -1,    -1,   103,   104,    85,    86,    87,    88,
      89,    90,    -1,    -1,    -1,    -1,    -1,   116,    -1,    -1,
      -1,    -1,    -1,   122,   103,   104,   125,   126,    -1,    -1,
      -1,    -1,    -1,    63,    64,    -1,    -1,   116,     3,     4,
       5,     6,    -1,   122,    -1,    -1,   125,   126,    78,     3,
       4,     5,     6,    63,    64,    85,    86,    87,    88,    89,
      90,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   103,   104,    85,    86,    87,    88,    89,
      90,    -1,    -1,    -1,    -1,    -1,   116,    -1,    -1,    -1,
      -1,    -1,   122,   103,   104,   125,   126,    -1,    63,    64,
      -1,    -1,    -1,    -1,    -1,    -1,   116,   117,    -1,    63,
      64,    -1,   122,    -1,    -1,   125,   126,    -1,    -1,    -1,
      85,    86,    87,    88,    89,    90,     3,     4,     5,     6,
      -1,    85,    86,    87,    88,    89,    90,    -1,   103,   104,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   113,   103,
     104,   116,    -1,    -1,    -1,    -1,    -1,   122,    -1,   113,
     125,   126,   116,    -1,    -1,    -1,    -1,    -1,   122,    -1,
      47,   125,   126,     3,     4,     5,     6,    -1,    -1,    -1,
       3,     4,     5,     6,    -1,    -1,    63,    64,    89,    90,
      91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,    85,    86,
      87,    88,    89,    90,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,     3,     4,     5,     6,   103,   104,    -1,    -1,
      -1,    -1,    -1,    63,    64,    -1,    -1,    -1,    -1,   116,
      63,    64,    -1,    -1,    -1,   122,    -1,    -1,   125,   126,
      -1,    -1,    -1,    -1,    -1,    85,    86,    87,    88,    89,
      90,    -1,    85,    86,    87,    88,    89,    90,    -1,    -1,
      -1,    -1,    -1,   103,   104,    -1,    -1,    -1,    -1,    -1,
     103,   104,    63,    64,    -1,    -1,   116,   117,    -1,    -1,
      -1,    -1,   122,   116,    -1,   125,   126,    -1,    -1,   122,
      -1,    -1,   125,   126,    85,    86,    87,    88,    89,    90,
      -1,    -1,    -1,   107,   108,   109,   110,   111,   112,   113,
     114,    -1,   103,   104,   118,   119,    -1,    -1,    10,    -1,
      -1,    13,    14,    15,    16,   116,    -1,    -1,    -1,    -1,
      -1,   122,    -1,    -1,   125,   126,    28,    -1,    -1,    31,
      -1,    33,    -1,    35,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    43,    44,    45,    -1,    -1,    -1,    -1,    -1,    -1,
      52,    -1,    54,    55,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    67,    68,    69,    70,    -1,
      -1,    -1,    -1,    -1,    76,   189,   190,   191,   192,   193,
     194,   195,   196,   197,   198,   199,   200,   201,   202,   203,
     204,   205,   206,   207,   208,   209,   210,   211,   212,   213,
     214,    10,    -1,    -1,    -1,    14,    15,    16,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    28,
      -1,    -1,    31,    -1,    33,    31,    35,    33,    -1,    35,
      36,    37,    -1,    -1,    43,    44,    45,    43,    44,    45,
      -1,    -1,    -1,    52,    -1,    54,    55,    -1,    10,    -1,
      -1,    -1,    14,    15,    16,    61,    62,    -1,    67,    68,
      69,    70,    -1,    -1,    -1,    -1,    28,    76,    77,    31,
      -1,    33,    -1,    35,    -1,    81,    82,    -1,    -1,    -1,
      -1,    43,    44,    45,    -1,    -1,    -1,    -1,    -1,    -1,
      52,    -1,    54,    55,    56,    10,    -1,    -1,    -1,    14,
      15,    16,    -1,    -1,    -1,    67,    68,    69,    70,    -1,
      -1,    -1,    -1,    28,    76,    -1,    31,    32,    33,    -1,
      35,    -1,    -1,     4,    -1,    -1,     7,    -1,    43,    44,
      45,    -1,    -1,    -1,    -1,    -1,    -1,    52,    -1,    54,
      55,    10,    -1,    -1,    -1,    14,    15,    16,    29,    30,
      -1,    -1,    67,    68,    69,    70,    -1,    38,    -1,    28,
      41,    76,    31,    -1,    33,    -1,    35,    48,    -1,    50,
      -1,    -1,    -1,    -1,    43,    44,    45,    -1,    -1,    -1,
      61,    62,    -1,    52,    -1,    54,    55,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,    68,
      69,    70,    -1,    -1,    -1,    -1,    -1,    76,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,    95,    96,    97,    98,    99,   100,
     101,   102,   103,   104,   105,   106,   107,   108,    -1,   124,
      84,    85,    86,    87,    88,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    99,   100,   101,   102,   103,
     104,   105,   106,   107,   108,    85,    86,    87,    88,    89,
      90,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100,   101,   102,   103,   104,   105,   106,   107,   108,    87,
      88,    89,    90,    91,    92,    93,    94,    95,    96,    97,
      98,    99,   100,   101,   102,   103,   104,   105,   106,   107,
     108,    91,    92,    93,    94,    95,    96,    97,    98,    99,
     100,   101,   102,   103,   104,   105,   106,   107,   108
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint16 yystos[] =
{
       0,   128,   129,     0,    10,    14,    15,   130,   131,   132,
     134,   141,   157,   177,   224,   226,   135,   225,   227,    12,
      17,    38,    48,    50,   133,   130,   130,   130,   130,   130,
     130,     4,   137,   138,   139,   140,    27,   220,   220,     4,
       4,     4,    42,   186,   186,     8,   136,   111,    19,   112,
     113,    26,   221,   221,   142,   158,     4,   112,   118,    27,
     187,     4,   137,    11,   139,     4,     3,     5,     6,    63,
      64,    85,    86,    87,    88,    89,    90,   103,   104,   116,
     122,   125,   126,   140,   302,   321,   322,     4,    58,   222,
     222,   115,   143,   114,   178,     4,     4,    26,   119,   168,
     170,   172,   181,     9,     5,   131,   131,   131,   131,   131,
     131,   131,   131,   131,   131,   321,   321,   324,   131,   131,
       5,   119,   131,   168,   169,   170,    83,    84,    85,    86,
      87,    88,    89,    90,    91,    92,    93,    94,    95,    96,
      97,    98,    99,   100,   101,   102,   103,   104,   105,   106,
     107,   108,   124,   170,   223,   223,   116,   116,   150,   159,
     116,   184,     4,   112,   321,     4,   116,   188,   116,   116,
     322,   322,   322,   322,   322,   322,   322,   322,   117,   118,
     111,   122,   123,   322,   322,   321,   323,   168,   168,   131,
     131,   131,   131,   131,   131,   131,   131,   131,   131,   131,
     131,   131,   131,   131,   131,   131,   131,   131,   131,   131,
     131,   131,   131,   131,   131,   131,     4,   228,   229,   228,
     144,     4,   113,   117,   131,   151,   154,   114,    18,   160,
     226,     4,   183,   185,   114,   179,     4,    65,    66,   118,
     120,   182,   117,   189,   114,   321,   321,     5,   321,   321,
     324,   324,   120,   116,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     321,   112,   111,   114,   114,    14,    15,   146,   147,   229,
     155,   113,   163,   164,   111,   152,   173,     4,   111,   117,
     184,     4,   321,   321,   321,   188,     4,   131,   191,   192,
     241,   194,   117,   117,   118,   123,   113,   306,   307,   308,
     321,   118,   321,   229,   148,   149,   111,   145,   112,   153,
     113,   170,    20,    21,    22,    23,    24,    25,    26,    27,
      57,    74,    75,   165,   166,   167,   154,   117,    13,    16,
      28,    31,    33,    35,    43,    44,    45,    52,    54,    55,
      67,    68,    69,    70,    76,   131,   134,   174,   175,   177,
     195,   198,   224,   226,   230,   233,   242,   245,   262,   273,
     287,   311,   183,   114,   180,   120,   120,   120,   114,   169,
     170,   171,   163,   111,   152,     4,    51,   114,   115,   122,
     131,   134,   140,   161,   224,   226,   233,   271,   272,   274,
     275,   286,   302,   303,   321,   123,   140,   302,   111,   152,
     321,   220,   220,   147,   117,   321,     4,   161,   162,   167,
     170,   231,   232,   162,   118,   269,   116,   116,     4,    53,
     116,   196,   197,   198,   202,   203,   206,   207,   214,     4,
     119,   199,   200,   201,   309,    71,    71,    71,    71,     4,
       4,     7,    29,    30,    41,    61,    62,   163,   248,   116,
     184,   194,   170,   192,   190,   118,     4,     5,     6,   116,
     304,   321,    31,    33,    35,    36,    37,    81,    82,   285,
     131,   275,    67,    68,    69,    70,   114,   287,    79,    80,
      96,   112,   117,   308,   117,   221,   221,   156,   302,   111,
     114,   243,   244,   303,     4,   316,   321,   312,   116,     4,
     208,   212,    53,   197,   114,   112,   112,   112,   219,   321,
     200,   111,   114,    56,   174,   310,   311,   116,   116,   116,
     116,   114,   246,   263,   265,     4,     4,   170,   162,   321,
     114,    49,   193,   117,   321,   123,   111,   269,   116,   116,
     116,   116,   131,   286,   286,   276,    71,   270,   270,   270,
     114,   270,   116,   162,   162,   223,   223,   153,   112,   232,
     111,   114,   112,   309,   117,   274,    39,    40,   215,   216,
     321,   105,   103,   104,   111,   209,   211,   116,   204,   217,
     219,   204,   218,   219,   118,   114,   201,    78,   321,    78,
     321,    78,   321,   321,   176,   115,   256,   121,   266,   275,
     236,   237,   234,   247,   117,   241,   117,   118,   304,   277,
     321,   278,   321,   321,   116,   305,   116,   116,   116,   116,
     321,   321,   321,   229,   229,   321,   244,   321,    32,   314,
     114,     4,     4,   111,   117,    98,   212,   111,   211,   112,
     217,   321,   111,   205,   118,   219,   321,   117,   321,   117,
     321,   117,   117,   173,   116,     4,   249,   250,     8,   105,
     116,   264,   238,   238,   239,   240,   241,   250,   253,   254,
     255,   315,   321,   289,   117,   274,   117,   117,   306,   114,
      78,   321,    78,   321,    78,   321,   117,   321,   117,   269,
     317,   318,   321,   215,   114,     4,   210,   213,   212,    98,
     205,   217,   219,   120,   117,   114,   117,   114,   117,   114,
     114,    77,   113,   257,   258,   321,   168,   251,   111,   114,
     117,     9,    39,    40,   105,   267,   268,   321,   275,   111,
     114,   114,   111,   235,   112,   111,   114,   116,   296,   118,
      32,   275,   283,   114,   281,   282,   152,   321,   117,   321,
     117,   321,   117,   114,   117,   284,    34,   320,   310,   313,
     111,   117,   213,   117,   111,   118,   114,   114,   114,     4,
     111,   117,   252,   116,   250,   321,   321,   117,    41,   111,
     117,     4,   240,   114,   321,   254,   113,   259,   260,   261,
     321,    46,   297,   298,   321,   269,   275,   321,   275,   275,
     117,   117,   114,   117,   114,   117,   114,   114,   288,   114,
     317,   319,   114,   213,   117,   217,   219,   116,   258,   116,
     259,   268,   268,     4,   117,   111,    47,   300,   301,   321,
     117,    34,   290,   279,   114,   114,   114,    59,    60,   292,
     274,   111,   321,   259,   117,   116,   261,   299,   111,   118,
     291,   114,    46,   293,   294,   117,   217,   117,   117,   117,
     321,   319,   321,   275,   274,   300,   317,   111,   117,   117,
     295,   217,   280,   275,   111,   275,   217,   111,   217,   111,
     217,   111,   217,   111,   217,   111,   217,   111,   217
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint16 yyr1[] =
{
       0,   127,   129,   128,   130,   130,   130,   130,   130,   130,
     130,   132,   131,   133,   133,   135,   136,   134,   137,   137,
     138,   138,   139,   139,   140,   140,   140,   142,   141,   144,
     145,   143,   143,   146,   146,   147,   148,   147,   149,   147,
     147,   150,   150,   150,   151,   151,   152,   152,   153,   153,
     155,   154,   156,   154,   154,   158,   157,   159,   159,   160,
     161,   161,   161,   161,   161,   162,   162,   164,   163,   165,
     165,   165,   166,   166,   166,   167,   167,   167,   167,   167,
     167,   167,   167,   168,   168,   168,   168,   169,   169,   170,
     170,   171,   171,   172,   172,   173,   173,   173,   174,   174,
     174,   174,   174,   174,   174,   174,   174,   174,   174,   174,
     174,   174,   176,   175,   178,   177,   179,   177,   180,   177,
     181,   177,   182,   177,   183,   183,   184,   184,   185,   185,
     185,   185,   186,   186,   187,   187,   188,   188,   189,   190,
     188,   191,   191,   193,   192,   192,   194,   194,   195,   195,
     196,   196,   197,   197,   197,   198,   198,   199,   200,   200,
     201,   202,   203,   203,   204,   204,   204,   205,   205,   205,
     205,   206,   207,   208,   208,   209,   209,   210,   210,   211,
     211,   211,   212,   213,   214,   215,   215,   215,   216,   216,
     217,   218,   218,   219,   220,   220,   221,   221,   222,   222,
     223,   225,   224,   227,   226,   228,   228,   229,   230,   231,
     231,   232,   234,   235,   233,   236,   233,   237,   233,   238,
     238,   239,   239,   240,   240,   241,   242,   243,   243,   244,
     246,   245,   247,   245,   248,   248,   249,   249,   251,   250,
     252,   250,   253,   253,   254,   255,   254,   256,   256,   257,
     257,   258,   258,   258,   259,   260,   260,   261,   261,   261,
     261,   263,   264,   262,   265,   262,   266,   266,   266,   266,
     266,   266,   267,   267,   267,   268,   268,   268,   269,   269,
     270,   270,   271,   271,   272,   272,   272,   272,   272,   272,
     272,   272,   272,   273,   273,   273,   273,   273,   273,   273,
     274,   274,   274,   274,   275,   275,   275,   275,   275,   275,
     275,   275,   276,   275,   277,   275,   278,   279,   280,   275,
     281,   275,   282,   275,   283,   275,   284,   275,   285,   285,
     285,   286,   287,   287,   287,   288,   288,   288,   289,   289,
     291,   290,   290,   292,   292,   294,   295,   293,   296,   296,
     298,   299,   297,   300,   300,   301,   301,   301,   302,   302,
     302,   303,   303,   304,   304,   305,   305,   306,   306,   307,
     307,   308,   309,   309,   310,   310,   312,   313,   311,   314,
     311,   315,   311,   316,   311,   318,   317,   319,   319,   320,
     320,   321,   321,   322,   322,   322,   322,   322,   322,   322,
     323,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   322,   322,   322,   322,   322,   322,
     322,   322,   322,   322,   324,   324
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     2,     2,     2,     2,     2,     2,
       0,     0,     2,     4,     0,     0,     0,     5,     1,     0,
       1,     3,     1,     3,     1,     3,     3,     0,     9,     0,
       0,     6,     0,     1,     3,     0,     0,     6,     0,     6,
       1,     2,     0,     4,     1,     3,     1,     0,     2,     0,
       0,     3,     0,     6,     3,     0,     7,     2,     0,     1,
       2,     2,     2,     4,     8,     1,     0,     0,     3,     1,
       2,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     5,     5,     5,     3,     2,     2,     1,
       0,     1,     1,     1,     1,     2,     2,     0,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     3,     1,
       1,     1,     0,     6,     0,     7,     0,     9,     0,    11,
       0,     9,     0,    11,     2,     1,     3,     0,     3,     2,
       1,     0,     1,     0,     1,     0,     2,     0,     0,     0,
       6,     1,     3,     0,     5,     1,     2,     0,     3,     2,
       2,     1,     1,     1,     1,     3,     4,     5,     1,     3,
       3,     2,     3,     3,     4,     1,     2,     2,     4,    10,
      22,     7,     6,     2,     3,     2,     3,     1,     3,     1,
       1,     0,     1,     1,     5,     2,     2,     1,     1,     3,
       1,     1,     5,     1,     1,     0,     1,     0,     1,     0,
       1,     0,     8,     0,     8,     1,     3,     3,     3,     1,
       3,     4,     0,     0,     7,     0,     6,     0,     6,     0,
       3,     1,     3,     1,     3,     2,     4,     1,     3,     3,
       0,     6,     0,     6,     1,     1,     1,     3,     0,     5,
       0,     6,     1,     3,     1,     0,     4,     4,     0,     1,
       3,     0,     1,     5,     1,     1,     3,     0,     1,     5,
       4,     0,     0,     6,     0,     4,     4,     4,     3,     3,
       2,     0,     1,     3,     3,     2,     2,     1,     2,     0,
       1,     0,     2,     0,     7,     7,     8,     8,     7,     6,
       3,     7,     8,     6,     6,     7,     7,     6,     6,     7,
       4,     2,     2,     4,     1,     1,     1,     1,     1,     2,
       2,     1,     0,     5,     0,     7,     0,     0,     0,    13,
       0,     7,     0,     7,     0,     8,     0,     9,     0,     2,
       2,     2,     1,     1,     1,     2,     2,     0,     2,     0,
       0,     3,     0,     2,     0,     0,     0,     4,     2,     0,
       0,     0,     4,     2,     1,     1,     1,     3,     6,     2,
       2,     1,     3,     1,     3,     4,     0,     1,     0,     1,
       3,     1,     2,     0,     1,     1,     0,     0,    11,     0,
       7,     0,     7,     0,     6,     0,     2,     1,     1,     2,
       0,     1,     6,     1,     4,     2,     2,     1,     1,     1,
       0,     7,     5,     5,     3,     7,     3,     6,     3,     4,
       4,     4,     4,     4,     4,     3,     3,     3,     3,     3,
       3,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     4,     3,
       3,     4,     4,     3,     1,     3
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      YY_LAC_DISCARD ("YYBACKUP");                              \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif

/* Given a state stack such that *YYBOTTOM is its bottom, such that
   *YYTOP is either its top or is YYTOP_EMPTY to indicate an empty
   stack, and such that *YYCAPACITY is the maximum number of elements it
   can hold without a reallocation, make sure there is enough room to
   store YYADD more elements.  If not, allocate a new stack using
   YYSTACK_ALLOC, copy the existing elements, and adjust *YYBOTTOM,
   *YYTOP, and *YYCAPACITY to reflect the new capacity and memory
   location.  If *YYBOTTOM != YYBOTTOM_NO_FREE, then free the old stack
   using YYSTACK_FREE.  Return 0 if successful or if no reallocation is
   required.  Return 1 if memory is exhausted.  */
static int
yy_lac_stack_realloc (YYSIZE_T *yycapacity, YYSIZE_T yyadd,
#if YYDEBUG
                      char const *yydebug_prefix,
                      char const *yydebug_suffix,
#endif
                      yytype_int16 **yybottom,
                      yytype_int16 *yybottom_no_free,
                      yytype_int16 **yytop, yytype_int16 *yytop_empty)
{
  YYSIZE_T yysize_old =
    *yytop == yytop_empty ? 0 : *yytop - *yybottom + 1;
  YYSIZE_T yysize_new = yysize_old + yyadd;
  if (*yycapacity < yysize_new)
    {
      YYSIZE_T yyalloc = 2 * yysize_new;
      yytype_int16 *yybottom_new;
      /* Use YYMAXDEPTH for maximum stack size given that the stack
         should never need to grow larger than the main state stack
         needs to grow without LAC.  */
      if (YYMAXDEPTH < yysize_new)
        {
          YYDPRINTF ((stderr, "%smax size exceeded%s", yydebug_prefix,
                      yydebug_suffix));
          return 1;
        }
      if (YYMAXDEPTH < yyalloc)
        yyalloc = YYMAXDEPTH;
      yybottom_new =
        (yytype_int16*) YYSTACK_ALLOC (yyalloc * sizeof *yybottom_new);
      if (!yybottom_new)
        {
          YYDPRINTF ((stderr, "%srealloc failed%s", yydebug_prefix,
                      yydebug_suffix));
          return 1;
        }
      if (*yytop != yytop_empty)
        {
          YYCOPY (yybottom_new, *yybottom, yysize_old);
          *yytop = yybottom_new + (yysize_old - 1);
        }
      if (*yybottom != yybottom_no_free)
        YYSTACK_FREE (*yybottom);
      *yybottom = yybottom_new;
      *yycapacity = yyalloc;
    }
  return 0;
}

/* Establish the initial context for the current lookahead if no initial
   context is currently established.

   We define a context as a snapshot of the parser stacks.  We define
   the initial context for a lookahead as the context in which the
   parser initially examines that lookahead in order to select a
   syntactic action.  Thus, if the lookahead eventually proves
   syntactically unacceptable (possibly in a later context reached via a
   series of reductions), the initial context can be used to determine
   the exact set of tokens that would be syntactically acceptable in the
   lookahead's place.  Moreover, it is the context after which any
   further semantic actions would be erroneous because they would be
   determined by a syntactically unacceptable token.

   YY_LAC_ESTABLISH should be invoked when a reduction is about to be
   performed in an inconsistent state (which, for the purposes of LAC,
   includes consistent states that don't know they're consistent because
   their default reductions have been disabled).  Iff there is a
   lookahead token, it should also be invoked before reporting a syntax
   error.  This latter case is for the sake of the debugging output.

   For parse.lac=full, the implementation of YY_LAC_ESTABLISH is as
   follows.  If no initial context is currently established for the
   current lookahead, then check if that lookahead can eventually be
   shifted if syntactic actions continue from the current context.
   Report a syntax error if it cannot.  */
#define YY_LAC_ESTABLISH                                         \
do {                                                             \
  if (!yy_lac_established)                                       \
    {                                                            \
      YYDPRINTF ((stderr,                                        \
                  "LAC: initial context established for %s\n",   \
                  yytname[yytoken]));                            \
      yy_lac_established = 1;                                    \
      {                                                          \
        int yy_lac_status =                                      \
          yy_lac (yyesa, &yyes, &yyes_capacity, yyssp, yytoken); \
        if (yy_lac_status == 2)                                  \
          goto yyexhaustedlab;                                   \
        if (yy_lac_status == 1)                                  \
          goto yyerrlab;                                         \
      }                                                          \
    }                                                            \
} while (0)

/* Discard any previous initial lookahead context because of Event,
   which may be a lookahead change or an invalidation of the currently
   established initial context for the current lookahead.

   The most common example of a lookahead change is a shift.  An example
   of both cases is syntax error recovery.  That is, a syntax error
   occurs when the lookahead is syntactically erroneous for the
   currently established initial context, so error recovery manipulates
   the parser stacks to try to find a new initial context in which the
   current lookahead is syntactically acceptable.  If it fails to find
   such a context, it discards the lookahead.  */
#if YYDEBUG
# define YY_LAC_DISCARD(Event)                                           \
do {                                                                     \
  if (yy_lac_established)                                                \
    {                                                                    \
      if (yydebug)                                                       \
        YYFPRINTF (stderr, "LAC: initial context discarded due to "      \
                   Event "\n");                                          \
      yy_lac_established = 0;                                            \
    }                                                                    \
} while (0)
#else
# define YY_LAC_DISCARD(Event) yy_lac_established = 0
#endif

/* Given the stack whose top is *YYSSP, return 0 iff YYTOKEN can
   eventually (after perhaps some reductions) be shifted, return 1 if
   not, or return 2 if memory is exhausted.  As preconditions and
   postconditions: *YYES_CAPACITY is the allocated size of the array to
   which *YYES points, and either *YYES = YYESA or *YYES points to an
   array allocated with YYSTACK_ALLOC.  yy_lac may overwrite the
   contents of either array, alter *YYES and *YYES_CAPACITY, and free
   any old *YYES other than YYESA.  */
static int
yy_lac (yytype_int16 *yyesa, yytype_int16 **yyes,
        YYSIZE_T *yyes_capacity, yytype_int16 *yyssp, int yytoken)
{
  yytype_int16 *yyes_prev = yyssp;
  yytype_int16 *yyesp = yyes_prev;
  YYDPRINTF ((stderr, "LAC: checking lookahead %s:", yytname[yytoken]));
  if (yytoken == YYUNDEFTOK)
    {
      YYDPRINTF ((stderr, " Always Err\n"));
      return 1;
    }
  while (1)
    {
      int yyrule = yypact[*yyesp];
      if (yypact_value_is_default (yyrule)
          || (yyrule += yytoken) < 0 || YYLAST < yyrule
          || yycheck[yyrule] != yytoken)
        {
          yyrule = yydefact[*yyesp];
          if (yyrule == 0)
            {
              YYDPRINTF ((stderr, " Err\n"));
              return 1;
            }
        }
      else
        {
          yyrule = yytable[yyrule];
          if (yytable_value_is_error (yyrule))
            {
              YYDPRINTF ((stderr, " Err\n"));
              return 1;
            }
          if (0 < yyrule)
            {
              YYDPRINTF ((stderr, " S%d\n", yyrule));
              return 0;
            }
          yyrule = -yyrule;
        }
      {
        YYSIZE_T yylen = yyr2[yyrule];
        YYDPRINTF ((stderr, " R%d", yyrule - 1));
        if (yyesp != yyes_prev)
          {
            YYSIZE_T yysize = yyesp - *yyes + 1;
            if (yylen < yysize)
              {
                yyesp -= yylen;
                yylen = 0;
              }
            else
              {
                yylen -= yysize;
                yyesp = yyes_prev;
              }
          }
        if (yylen)
          yyesp = yyes_prev -= yylen;
      }
      {
        int yystate;
        {
          int yylhs = yyr1[yyrule] - YYNTOKENS;
          yystate = yypgoto[yylhs] + *yyesp;
          if (yystate < 0 || YYLAST < yystate
              || yycheck[yystate] != *yyesp)
            yystate = yydefgoto[yylhs];
          else
            yystate = yytable[yystate];
        }
        if (yyesp == yyes_prev)
          {
            yyesp = *yyes;
            *yyesp = yystate;
          }
        else
          {
            if (yy_lac_stack_realloc (yyes_capacity, 1,
#if YYDEBUG
                                      " (", ")",
#endif
                                      yyes, yyesa, &yyesp, yyes_prev))
              {
                YYDPRINTF ((stderr, "\n"));
                return 2;
              }
            *++yyesp = yystate;
          }
        YYDPRINTF ((stderr, " G%d", yystate));
      }
    }
}


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.  In order to see if a particular token T is a
   valid looakhead, invoke yy_lac (YYESA, YYES, YYES_CAPACITY, YYSSP, T).

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store or if
   yy_lac returned 2.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyesa, yytype_int16 **yyes,
                YYSIZE_T *yyes_capacity, yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
       In the first two cases, it might appear that the current syntax
       error should have been detected in the previous state when yy_lac
       was invoked.  However, at that time, there might have been a
       different syntax error that discarded a different initial context
       during error recovery, leaving behind the current lookahead.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      YYDPRINTF ((stderr, "Constructing syntax error message\n"));
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          int yyx;

          for (yyx = 0; yyx < YYNTOKENS; ++yyx)
            if (yyx != YYTERROR && yyx != YYUNDEFTOK)
              {
                {
                  int yy_lac_status = yy_lac (yyesa, yyes, yyes_capacity,
                                              yyssp, yyx);
                  if (yy_lac_status == 2)
                    return 2;
                  if (yy_lac_status == 1)
                    continue;
                }
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
# if YYDEBUG
      else if (yydebug)
        YYFPRINTF (stderr, "No expected tokens.\n");
# endif
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

    yytype_int16 yyesa[20];
    yytype_int16 *yyes;
    YYSIZE_T yyes_capacity;

  int yy_lac_established = 0;
  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  yyes = yyesa;
  yyes_capacity = sizeof yyesa / sizeof *yyes;
  if (YYMAXDEPTH < yyes_capacity)
    yyes_capacity = YYMAXDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    {
      YY_LAC_ESTABLISH;
      goto yydefault;
    }
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      YY_LAC_ESTABLISH;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  YY_LAC_DISCARD ("shift");

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  {
    int yychar_backup = yychar;
    switch (yyn)
      {
          case 2:
#line 152 "verilog_parser.y" /* yacc.c:1663  */
    {
	ast_stack.clear();
	ast_stack.push_back(current_ast);
}
#line 2487 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 3:
#line 155 "verilog_parser.y" /* yacc.c:1663  */
    {
	ast_stack.pop_back();
	log_assert(GetSize(ast_stack) == 0);
	for (auto &it : default_attr_list)
		delete it.second;
	default_attr_list.clear();
}
#line 2499 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 11:
#line 173 "verilog_parser.y" /* yacc.c:1663  */
    {
		for (auto &it : attr_list)
			delete it.second;
		attr_list.clear();
		for (auto &it : default_attr_list)
			attr_list[it.first] = it.second->clone();
	}
#line 2511 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 12:
#line 179 "verilog_parser.y" /* yacc.c:1663  */
    {
		std::map<std::string, AstNode*> *al = new std::map<std::string, AstNode*>;
		al->swap(attr_list);
		(yyval.al) = al;
	}
#line 2521 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 15:
#line 190 "verilog_parser.y" /* yacc.c:1663  */
    {
		for (auto &it : default_attr_list)
			delete it.second;
		default_attr_list.clear();
		for (auto &it : attr_list)
			delete it.second;
		attr_list.clear();
	}
#line 2534 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 16:
#line 197 "verilog_parser.y" /* yacc.c:1663  */
    {
		default_attr_list = attr_list;
		attr_list.clear();
	}
#line 2543 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 22:
#line 210 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (attr_list.count(*(yyvsp[0].string)) != 0)
			delete attr_list[*(yyvsp[0].string)];
		attr_list[*(yyvsp[0].string)] = AstNode::mkconst_int(1, false);
		delete (yyvsp[0].string);
	}
#line 2554 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 23:
#line 216 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (attr_list.count(*(yyvsp[-2].string)) != 0)
			delete attr_list[*(yyvsp[-2].string)];
		attr_list[*(yyvsp[-2].string)] = (yyvsp[0].ast);
		delete (yyvsp[-2].string);
	}
#line 2565 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 24:
#line 224 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.string) = (yyvsp[0].string);
	}
#line 2573 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 25:
#line 227 "verilog_parser.y" /* yacc.c:1663  */
    {
		if ((yyvsp[0].string)->substr(0, 1) == "\\")
			*(yyvsp[-2].string) += "::" + (yyvsp[0].string)->substr(1);
		else
			*(yyvsp[-2].string) += "::" + *(yyvsp[0].string);
		delete (yyvsp[0].string);
		(yyval.string) = (yyvsp[-2].string);
	}
#line 2586 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 26:
#line 235 "verilog_parser.y" /* yacc.c:1663  */
    {
		if ((yyvsp[0].string)->substr(0, 1) == "\\")
			*(yyvsp[-2].string) += "." + (yyvsp[0].string)->substr(1);
		else
			*(yyvsp[-2].string) += "." + *(yyvsp[0].string);
		delete (yyvsp[0].string);
		(yyval.string) = (yyvsp[-2].string);
	}
#line 2599 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 27:
#line 245 "verilog_parser.y" /* yacc.c:1663  */
    {
		do_not_require_port_stubs = false;
		AstNode *mod = new AstNode(AST_MODULE);
		ast_stack.back()->children.push_back(mod);
		ast_stack.push_back(mod);
		current_ast_mod = mod;
		port_stubs.clear();
		port_counter = 0;
		mod->str = *(yyvsp[0].string);
		append_attr(mod, (yyvsp[-2].al));
		delete (yyvsp[0].string);
	}
#line 2616 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 28:
#line 256 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (port_stubs.size() != 0)
			frontend_verilog_yyerror("Missing details for module port `%s'.",
					port_stubs.begin()->first.c_str());
		ast_stack.pop_back();
		log_assert(ast_stack.size() == 1);
		current_ast_mod = NULL;
	}
#line 2629 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 29:
#line 266 "verilog_parser.y" /* yacc.c:1663  */
    { astbuf1 = nullptr; }
#line 2635 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 30:
#line 266 "verilog_parser.y" /* yacc.c:1663  */
    { if (astbuf1) delete astbuf1; }
#line 2641 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 36:
#line 273 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (astbuf1) delete astbuf1;
		astbuf1 = new AstNode(AST_PARAMETER);
		astbuf1->children.push_back(AstNode::mkconst_int(0, true));
	}
#line 2651 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 38:
#line 278 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (astbuf1) delete astbuf1;
		astbuf1 = new AstNode(AST_LOCALPARAM);
		astbuf1->children.push_back(AstNode::mkconst_int(0, true));
	}
#line 2661 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 48:
#line 295 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (ast_stack.back()->children.size() > 0 && ast_stack.back()->children.back()->type == AST_WIRE) {
			AstNode *wire = new AstNode(AST_IDENTIFIER);
			wire->str = ast_stack.back()->children.back()->str;
			if (ast_stack.back()->children.back()->is_reg)
				ast_stack.back()->children.push_back(new AstNode(AST_INITIAL, new AstNode(AST_BLOCK, new AstNode(AST_ASSIGN_LE, wire, (yyvsp[0].ast)))));
			else
				ast_stack.back()->children.push_back(new AstNode(AST_ASSIGN, wire, (yyvsp[0].ast)));
		} else
			frontend_verilog_yyerror("Syntax error.");
	}
#line 2677 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 50:
#line 309 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (ast_stack.back()->children.size() > 0 && ast_stack.back()->children.back()->type == AST_WIRE) {
			AstNode *node = ast_stack.back()->children.back()->clone();
			node->str = *(yyvsp[0].string);
			node->port_id = ++port_counter;
			ast_stack.back()->children.push_back(node);
		} else {
			if (port_stubs.count(*(yyvsp[0].string)) != 0)
				frontend_verilog_yyerror("Duplicate module port `%s'.", (yyvsp[0].string)->c_str());
			port_stubs[*(yyvsp[0].string)] = ++port_counter;
		}
		delete (yyvsp[0].string);
	}
#line 2695 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 52:
#line 322 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = (yyvsp[-2].ast);
		node->str = *(yyvsp[0].string);
		node->port_id = ++port_counter;
		if ((yyvsp[-1].ast) != NULL)
			node->children.push_back((yyvsp[-1].ast));
		if (!node->is_input && !node->is_output)
			frontend_verilog_yyerror("Module port `%s' is neither input nor output.", (yyvsp[0].string)->c_str());
		if (node->is_reg && node->is_input && !node->is_output && !sv_mode)
			frontend_verilog_yyerror("Input port `%s' is declared as register.", (yyvsp[0].string)->c_str());
		ast_stack.back()->children.push_back(node);
		append_attr(node, (yyvsp[-3].al));
		delete (yyvsp[0].string);
	}
#line 2714 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 54:
#line 336 "verilog_parser.y" /* yacc.c:1663  */
    {
		do_not_require_port_stubs = true;
	}
#line 2722 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 55:
#line 341 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *mod = new AstNode(AST_PACKAGE);
		ast_stack.back()->children.push_back(mod);
		ast_stack.push_back(mod);
		current_ast_mod = mod;
		mod->str = *(yyvsp[0].string);
		append_attr(mod, (yyvsp[-2].al));
	}
#line 2735 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 56:
#line 348 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
		current_ast_mod = NULL;
	}
#line 2744 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 60:
#line 360 "verilog_parser.y" /* yacc.c:1663  */
    { delete (yyvsp[0].string); }
#line 2750 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 61:
#line 361 "verilog_parser.y" /* yacc.c:1663  */
    { delete (yyvsp[0].string); }
#line 2756 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 62:
#line 362 "verilog_parser.y" /* yacc.c:1663  */
    { delete (yyvsp[0].string); }
#line 2762 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 63:
#line 363 "verilog_parser.y" /* yacc.c:1663  */
    { delete (yyvsp[-1].ast); }
#line 2768 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 64:
#line 364 "verilog_parser.y" /* yacc.c:1663  */
    { delete (yyvsp[-5].ast); delete (yyvsp[-3].ast); delete (yyvsp[-1].ast); }
#line 2774 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 67:
#line 370 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf3 = new AstNode(AST_WIRE);
		current_wire_rand = false;
		current_wire_const = false;
	}
#line 2784 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 68:
#line 374 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = astbuf3;
	}
#line 2792 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 72:
#line 383 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf3->is_input = true;
	}
#line 2800 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 73:
#line 386 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf3->is_output = true;
	}
#line 2808 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 74:
#line 389 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf3->is_input = true;
		astbuf3->is_output = true;
	}
#line 2817 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 75:
#line 395 "verilog_parser.y" /* yacc.c:1663  */
    {
	}
#line 2824 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 76:
#line 397 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf3->is_reg = true;
	}
#line 2832 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 77:
#line 400 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf3->is_logic = true;
	}
#line 2840 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 78:
#line 403 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf3->is_reg = true;
		astbuf3->range_left = 31;
		astbuf3->range_right = 0;
		astbuf3->is_signed = true;
	}
#line 2851 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 79:
#line 409 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf3->type = AST_GENVAR;
		astbuf3->is_reg = true;
		astbuf3->range_left = 31;
		astbuf3->range_right = 0;
	}
#line 2862 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 80:
#line 415 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf3->is_signed = true;
	}
#line 2870 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 81:
#line 418 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_wire_rand = true;
	}
#line 2878 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 82:
#line 421 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_wire_const = true;
	}
#line 2886 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 83:
#line 426 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_RANGE);
		(yyval.ast)->children.push_back((yyvsp[-3].ast));
		(yyval.ast)->children.push_back((yyvsp[-1].ast));
	}
#line 2896 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 84:
#line 431 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_RANGE);
		(yyval.ast)->children.push_back(new AstNode(AST_SUB, new AstNode(AST_ADD, (yyvsp[-3].ast)->clone(), (yyvsp[-1].ast)), AstNode::mkconst_int(1, true)));
		(yyval.ast)->children.push_back(new AstNode(AST_ADD, (yyvsp[-3].ast), AstNode::mkconst_int(0, true)));
	}
#line 2906 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 85:
#line 436 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_RANGE);
		(yyval.ast)->children.push_back(new AstNode(AST_ADD, (yyvsp[-3].ast), AstNode::mkconst_int(0, true)));
		(yyval.ast)->children.push_back(new AstNode(AST_SUB, new AstNode(AST_ADD, (yyvsp[-3].ast)->clone(), AstNode::mkconst_int(1, true)), (yyvsp[-1].ast)));
	}
#line 2916 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 86:
#line 441 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_RANGE);
		(yyval.ast)->children.push_back((yyvsp[-1].ast));
	}
#line 2925 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 87:
#line 447 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_MULTIRANGE, (yyvsp[-1].ast), (yyvsp[0].ast));
	}
#line 2933 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 88:
#line 450 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[-1].ast);
		(yyval.ast)->children.push_back((yyvsp[0].ast));
	}
#line 2942 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 89:
#line 456 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[0].ast);
	}
#line 2950 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 90:
#line 459 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = NULL;
	}
#line 2958 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 91:
#line 464 "verilog_parser.y" /* yacc.c:1663  */
    { (yyval.ast) = (yyvsp[0].ast); }
#line 2964 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 92:
#line 465 "verilog_parser.y" /* yacc.c:1663  */
    { (yyval.ast) = (yyvsp[0].ast); }
#line 2970 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 93:
#line 468 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[0].ast);
	}
#line 2978 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 94:
#line 471 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_RANGE);
		(yyval.ast)->children.push_back(AstNode::mkconst_int(31, true));
		(yyval.ast)->children.push_back(AstNode::mkconst_int(0, true));
		(yyval.ast)->is_signed = true;
	}
#line 2989 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 112:
#line 489 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_GENBLOCK);
		node->str = *(yyvsp[-1].string);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
	}
#line 3000 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 113:
#line 494 "verilog_parser.y" /* yacc.c:1663  */
    {
		delete (yyvsp[-4].string);
		ast_stack.pop_back();
	}
#line 3009 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 114:
#line 500 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = new AstNode(AST_DPI_FUNCTION, AstNode::mkconst_str(*(yyvsp[-1].string)), AstNode::mkconst_str(*(yyvsp[0].string)));
		current_function_or_task->str = *(yyvsp[0].string);
		append_attr(current_function_or_task, (yyvsp[-3].al));
		ast_stack.back()->children.push_back(current_function_or_task);
		delete (yyvsp[-1].string);
		delete (yyvsp[0].string);
	}
#line 3022 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 115:
#line 507 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = NULL;
	}
#line 3030 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 116:
#line 510 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = new AstNode(AST_DPI_FUNCTION, AstNode::mkconst_str(*(yyvsp[-1].string)), AstNode::mkconst_str(*(yyvsp[-3].string)));
		current_function_or_task->str = *(yyvsp[0].string);
		append_attr(current_function_or_task, (yyvsp[-5].al));
		ast_stack.back()->children.push_back(current_function_or_task);
		delete (yyvsp[-3].string);
		delete (yyvsp[-1].string);
		delete (yyvsp[0].string);
	}
#line 3044 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 117:
#line 518 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = NULL;
	}
#line 3052 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 118:
#line 521 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = new AstNode(AST_DPI_FUNCTION, AstNode::mkconst_str(*(yyvsp[-1].string)), AstNode::mkconst_str(*(yyvsp[-5].string) + ":" + RTLIL::unescape_id(*(yyvsp[-3].string))));
		current_function_or_task->str = *(yyvsp[0].string);
		append_attr(current_function_or_task, (yyvsp[-7].al));
		ast_stack.back()->children.push_back(current_function_or_task);
		delete (yyvsp[-5].string);
		delete (yyvsp[-3].string);
		delete (yyvsp[-1].string);
		delete (yyvsp[0].string);
	}
#line 3067 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 119:
#line 530 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = NULL;
	}
#line 3075 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 120:
#line 533 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = new AstNode(AST_TASK);
		current_function_or_task->str = *(yyvsp[0].string);
		append_attr(current_function_or_task, (yyvsp[-3].al));
		ast_stack.back()->children.push_back(current_function_or_task);
		ast_stack.push_back(current_function_or_task);
		current_function_or_task_port_id = 1;
		delete (yyvsp[0].string);
	}
#line 3089 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 121:
#line 541 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = NULL;
		ast_stack.pop_back();
	}
#line 3098 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 122:
#line 545 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = new AstNode(AST_FUNCTION);
		current_function_or_task->str = *(yyvsp[0].string);
		append_attr(current_function_or_task, (yyvsp[-5].al));
		ast_stack.back()->children.push_back(current_function_or_task);
		ast_stack.push_back(current_function_or_task);
		AstNode *outreg = new AstNode(AST_WIRE);
		outreg->str = *(yyvsp[0].string);
		outreg->is_signed = (yyvsp[-2].boolean);
		outreg->is_reg = true;
		if ((yyvsp[-1].ast) != NULL) {
			outreg->children.push_back((yyvsp[-1].ast));
			outreg->is_signed = (yyvsp[-2].boolean) || (yyvsp[-1].ast)->is_signed;
			(yyvsp[-1].ast)->is_signed = false;
		}
		current_function_or_task->children.push_back(outreg);
		current_function_or_task_port_id = 1;
		delete (yyvsp[0].string);
	}
#line 3122 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 123:
#line 563 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task = NULL;
		ast_stack.pop_back();
	}
#line 3131 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 124:
#line 569 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task->children.push_back(AstNode::mkconst_str(*(yyvsp[-1].string)));
		delete (yyvsp[-1].string);
		delete (yyvsp[0].string);
	}
#line 3141 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 125:
#line 574 "verilog_parser.y" /* yacc.c:1663  */
    {
		current_function_or_task->children.push_back(AstNode::mkconst_str(*(yyvsp[0].string)));
		delete (yyvsp[0].string);
	}
#line 3150 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 134:
#line 594 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.boolean) = true;
	}
#line 3158 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 135:
#line 597 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.boolean) = false;
	}
#line 3166 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 138:
#line 602 "verilog_parser.y" /* yacc.c:1663  */
    {
		albuf = nullptr;
		astbuf1 = nullptr;
		astbuf2 = nullptr;
	}
#line 3176 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 139:
#line 606 "verilog_parser.y" /* yacc.c:1663  */
    {
		delete astbuf1;
		if (astbuf2 != NULL)
			delete astbuf2;
		free_attr(albuf);
	}
#line 3187 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 143:
#line 617 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (albuf) {
			delete astbuf1;
			if (astbuf2 != NULL)
				delete astbuf2;
			free_attr(albuf);
		}
		albuf = (yyvsp[-2].al);
		astbuf1 = (yyvsp[-1].ast);
		astbuf2 = (yyvsp[0].ast);
		if (astbuf1->range_left >= 0 && astbuf1->range_right >= 0) {
			if (astbuf2) {
				frontend_verilog_yyerror("Syntax error.");
			} else {
				astbuf2 = new AstNode(AST_RANGE);
				astbuf2->children.push_back(AstNode::mkconst_int(astbuf1->range_left, true));
				astbuf2->children.push_back(AstNode::mkconst_int(astbuf1->range_right, true));
			}
		}
		if (astbuf2 && astbuf2->children.size() != 2)
			frontend_verilog_yyerror("Syntax error.");
	}
#line 3214 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 194:
#line 833 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf1->is_signed = true;
	}
#line 3222 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 196:
#line 838 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (astbuf1->children.size() != 1)
			frontend_verilog_yyerror("Syntax error.");
		astbuf1->children.push_back(new AstNode(AST_RANGE));
		astbuf1->children.back()->children.push_back(AstNode::mkconst_int(31, true));
		astbuf1->children.back()->children.push_back(AstNode::mkconst_int(0, true));
		astbuf1->is_signed = true;
	}
#line 3235 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 198:
#line 848 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (astbuf1->children.size() != 1)
			frontend_verilog_yyerror("Syntax error.");
		astbuf1->children.push_back(new AstNode(AST_REALVALUE));
	}
#line 3245 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 200:
#line 855 "verilog_parser.y" /* yacc.c:1663  */
    {
		if ((yyvsp[0].ast) != NULL) {
			if (astbuf1->children.size() != 1)
				frontend_verilog_yyerror("Syntax error.");
			astbuf1->children.push_back((yyvsp[0].ast));
		}
	}
#line 3257 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 201:
#line 864 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf1 = new AstNode(AST_PARAMETER);
		astbuf1->children.push_back(AstNode::mkconst_int(0, true));
	}
#line 3266 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 202:
#line 867 "verilog_parser.y" /* yacc.c:1663  */
    {
		delete astbuf1;
	}
#line 3274 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 203:
#line 872 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf1 = new AstNode(AST_LOCALPARAM);
		astbuf1->children.push_back(AstNode::mkconst_int(0, true));
	}
#line 3283 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 204:
#line 875 "verilog_parser.y" /* yacc.c:1663  */
    {
		delete astbuf1;
	}
#line 3291 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 207:
#line 883 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (astbuf1 == nullptr)
			frontend_verilog_yyerror("syntax error");
		AstNode *node = astbuf1->clone();
		node->str = *(yyvsp[-2].string);
		delete node->children[0];
		node->children[0] = (yyvsp[0].ast);
		ast_stack.back()->children.push_back(node);
		delete (yyvsp[-2].string);
	}
#line 3306 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 211:
#line 901 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_DEFPARAM);
		node->children.push_back((yyvsp[-2].ast));
		node->children.push_back((yyvsp[0].ast));
		if ((yyvsp[-3].ast) != NULL)
			node->children.push_back((yyvsp[-3].ast));
		ast_stack.back()->children.push_back(node);
	}
#line 3319 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 212:
#line 911 "verilog_parser.y" /* yacc.c:1663  */
    {
		albuf = (yyvsp[-2].al);
		astbuf1 = (yyvsp[-1].ast);
		astbuf2 = (yyvsp[0].ast);
		if (astbuf1->range_left >= 0 && astbuf1->range_right >= 0) {
			if (astbuf2) {
				frontend_verilog_yyerror("Syntax error.");
			} else {
				astbuf2 = new AstNode(AST_RANGE);
				astbuf2->children.push_back(AstNode::mkconst_int(astbuf1->range_left, true));
				astbuf2->children.push_back(AstNode::mkconst_int(astbuf1->range_right, true));
			}
		}
		if (astbuf2 && astbuf2->children.size() != 2)
			frontend_verilog_yyerror("Syntax error.");
	}
#line 3340 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 213:
#line 926 "verilog_parser.y" /* yacc.c:1663  */
    {
		delete astbuf1;
		if (astbuf2 != NULL)
			delete astbuf2;
		free_attr(albuf);
	}
#line 3351 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 215:
#line 932 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_WIRE));
		ast_stack.back()->children.back()->str = *(yyvsp[0].string);
		append_attr(ast_stack.back()->children.back(), (yyvsp[-2].al));
		ast_stack.back()->children.push_back(new AstNode(AST_ASSIGN, new AstNode(AST_IDENTIFIER), AstNode::mkconst_int(0, false, 1)));
		ast_stack.back()->children.back()->children[0]->str = *(yyvsp[0].string);
		delete (yyvsp[0].string);
	}
#line 3364 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 217:
#line 940 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_WIRE));
		ast_stack.back()->children.back()->str = *(yyvsp[0].string);
		append_attr(ast_stack.back()->children.back(), (yyvsp[-2].al));
		ast_stack.back()->children.push_back(new AstNode(AST_ASSIGN, new AstNode(AST_IDENTIFIER), AstNode::mkconst_int(1, false, 1)));
		ast_stack.back()->children.back()->children[0]->str = *(yyvsp[0].string);
		delete (yyvsp[0].string);
	}
#line 3377 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 220:
#line 951 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *wire_node = ast_stack.back()->children.at(GetSize(ast_stack.back()->children)-2)->clone();
		AstNode *assign_node = ast_stack.back()->children.at(GetSize(ast_stack.back()->children)-1)->clone();
		wire_node->str = *(yyvsp[0].string);
		assign_node->children[0]->str = *(yyvsp[0].string);
		ast_stack.back()->children.push_back(wire_node);
		ast_stack.back()->children.push_back(assign_node);
		delete (yyvsp[0].string);
	}
#line 3391 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 223:
#line 965 "verilog_parser.y" /* yacc.c:1663  */
    {
		bool attr_anyconst = false;
		bool attr_anyseq = false;
		bool attr_allconst = false;
		bool attr_allseq = false;
		if (ast_stack.back()->children.back()->get_bool_attribute("\\anyconst")) {
			delete ast_stack.back()->children.back()->attributes.at("\\anyconst");
			ast_stack.back()->children.back()->attributes.erase("\\anyconst");
			attr_anyconst = true;
		}
		if (ast_stack.back()->children.back()->get_bool_attribute("\\anyseq")) {
			delete ast_stack.back()->children.back()->attributes.at("\\anyseq");
			ast_stack.back()->children.back()->attributes.erase("\\anyseq");
			attr_anyseq = true;
		}
		if (ast_stack.back()->children.back()->get_bool_attribute("\\allconst")) {
			delete ast_stack.back()->children.back()->attributes.at("\\allconst");
			ast_stack.back()->children.back()->attributes.erase("\\allconst");
			attr_allconst = true;
		}
		if (ast_stack.back()->children.back()->get_bool_attribute("\\allseq")) {
			delete ast_stack.back()->children.back()->attributes.at("\\allseq");
			ast_stack.back()->children.back()->attributes.erase("\\allseq");
			attr_allseq = true;
		}
		if (current_wire_rand || attr_anyconst || attr_anyseq || attr_allconst || attr_allseq) {
			AstNode *wire = new AstNode(AST_IDENTIFIER);
			AstNode *fcall = new AstNode(AST_FCALL);
			wire->str = ast_stack.back()->children.back()->str;
			fcall->str = current_wire_const ? "\\$anyconst" : "\\$anyseq";
			if (attr_anyconst)
				fcall->str = "\\$anyconst";
			if (attr_anyseq)
				fcall->str = "\\$anyseq";
			if (attr_allconst)
				fcall->str = "\\$allconst";
			if (attr_allseq)
				fcall->str = "\\$allseq";
			fcall->attributes["\\reg"] = AstNode::mkconst_str(RTLIL::unescape_id(wire->str));
			ast_stack.back()->children.push_back(new AstNode(AST_ASSIGN, wire, fcall));
		}
	}
#line 3438 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 224:
#line 1007 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *wire = new AstNode(AST_IDENTIFIER);
		wire->str = ast_stack.back()->children.back()->str;
		if (astbuf1->is_reg)
			ast_stack.back()->children.push_back(new AstNode(AST_INITIAL, new AstNode(AST_BLOCK, new AstNode(AST_ASSIGN_LE, wire, (yyvsp[0].ast)))));
		else
			ast_stack.back()->children.push_back(new AstNode(AST_ASSIGN, wire, (yyvsp[0].ast)));
	}
#line 3451 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 225:
#line 1017 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (astbuf1 == nullptr)
			frontend_verilog_yyerror("Syntax error.");
		AstNode *node = astbuf1->clone();
		node->str = *(yyvsp[-1].string);
		append_attr_clone(node, albuf);
		if (astbuf2 != NULL)
			node->children.push_back(astbuf2->clone());
		if ((yyvsp[0].ast) != NULL) {
			if (node->is_input || node->is_output)
				frontend_verilog_yyerror("Syntax error.");
			if (!astbuf2) {
				AstNode *rng = new AstNode(AST_RANGE);
				rng->children.push_back(AstNode::mkconst_int(0, true));
				rng->children.push_back(AstNode::mkconst_int(0, true));
				node->children.push_back(rng);
			}
			node->type = AST_MEMORY;
			node->children.push_back((yyvsp[0].ast));
		}
		if (current_function_or_task == NULL) {
			if (do_not_require_port_stubs && (node->is_input || node->is_output) && port_stubs.count(*(yyvsp[-1].string)) == 0) {
				port_stubs[*(yyvsp[-1].string)] = ++port_counter;
			}
			if (port_stubs.count(*(yyvsp[-1].string)) != 0) {
				if (!node->is_input && !node->is_output)
					frontend_verilog_yyerror("Module port `%s' is neither input nor output.", (yyvsp[-1].string)->c_str());
				if (node->is_reg && node->is_input && !node->is_output && !sv_mode)
					frontend_verilog_yyerror("Input port `%s' is declared as register.", (yyvsp[-1].string)->c_str());
				node->port_id = port_stubs[*(yyvsp[-1].string)];
				port_stubs.erase(*(yyvsp[-1].string));
			} else {
				if (node->is_input || node->is_output)
					frontend_verilog_yyerror("Module port `%s' is not declared in module header.", (yyvsp[-1].string)->c_str());
			}
		} else {
			if (node->is_input || node->is_output)
				node->port_id = current_function_or_task_port_id++;
		}
		ast_stack.back()->children.push_back(node);

		delete (yyvsp[-1].string);
	}
#line 3499 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 229:
#line 1068 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_ASSIGN, (yyvsp[-2].ast), (yyvsp[0].ast)));
	}
#line 3507 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 230:
#line 1073 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf1 = new AstNode(AST_CELL);
		append_attr(astbuf1, (yyvsp[-1].al));
		astbuf1->children.push_back(new AstNode(AST_CELLTYPE));
		astbuf1->children[0]->str = *(yyvsp[0].string);
		delete (yyvsp[0].string);
	}
#line 3519 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 231:
#line 1079 "verilog_parser.y" /* yacc.c:1663  */
    {
		delete astbuf1;
	}
#line 3527 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 232:
#line 1082 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf1 = new AstNode(AST_PRIMITIVE);
		astbuf1->str = *(yyvsp[-1].string);
		append_attr(astbuf1, (yyvsp[-2].al));
		delete (yyvsp[-1].string);
	}
#line 3538 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 233:
#line 1087 "verilog_parser.y" /* yacc.c:1663  */
    {
		delete astbuf1;
	}
#line 3546 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 234:
#line 1092 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.string) = (yyvsp[0].string);
	}
#line 3554 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 235:
#line 1095 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.string) = new std::string("or");
	}
#line 3562 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 238:
#line 1104 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf2 = astbuf1->clone();
		if (astbuf2->type != AST_PRIMITIVE)
			astbuf2->str = *(yyvsp[0].string);
		delete (yyvsp[0].string);
		ast_stack.back()->children.push_back(astbuf2);
	}
#line 3574 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 240:
#line 1111 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf2 = astbuf1->clone();
		if (astbuf2->type != AST_PRIMITIVE)
			astbuf2->str = *(yyvsp[-1].string);
		delete (yyvsp[-1].string);
		ast_stack.back()->children.push_back(new AstNode(AST_CELLARRAY, (yyvsp[0].ast), astbuf2));
	}
#line 3586 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 245:
#line 1125 "verilog_parser.y" /* yacc.c:1663  */
    {
		astbuf2 = astbuf1->clone();
		ast_stack.back()->children.push_back(astbuf2);
	}
#line 3595 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 252:
#line 1138 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_PARASET);
		astbuf1->children.push_back(node);
		node->children.push_back((yyvsp[0].ast));
	}
#line 3605 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 253:
#line 1143 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_PARASET);
		node->str = *(yyvsp[-3].string);
		astbuf1->children.push_back(node);
		node->children.push_back((yyvsp[-1].ast));
		delete (yyvsp[-3].string);
	}
#line 3617 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 254:
#line 1152 "verilog_parser.y" /* yacc.c:1663  */
    {
		// remove empty args from end of list
		while (!astbuf2->children.empty()) {
			AstNode *node = astbuf2->children.back();
			if (node->type != AST_ARGUMENT) break;
			if (!node->children.empty()) break;
			if (!node->str.empty()) break;
			astbuf2->children.pop_back();
			delete node;
		}

		// check port types
		bool has_positional_args = false;
		bool has_named_args = false;
		for (auto node : astbuf2->children) {
			if (node->type != AST_ARGUMENT) continue;
			if (node->str.empty())
				has_positional_args = true;
			else
				has_named_args = true;
		}

		if (has_positional_args && has_named_args)
			frontend_verilog_yyerror("Mix of positional and named cell ports.");
	}
#line 3647 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 257:
#line 1182 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_ARGUMENT);
		astbuf2->children.push_back(node);
	}
#line 3656 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 258:
#line 1186 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_ARGUMENT);
		astbuf2->children.push_back(node);
		node->children.push_back((yyvsp[0].ast));
	}
#line 3666 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 259:
#line 1191 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_ARGUMENT);
		node->str = *(yyvsp[-3].string);
		astbuf2->children.push_back(node);
		node->children.push_back((yyvsp[-1].ast));
		delete (yyvsp[-3].string);
	}
#line 3678 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 260:
#line 1198 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_ARGUMENT);
		node->str = *(yyvsp[-2].string);
		astbuf2->children.push_back(node);
		delete (yyvsp[-2].string);
	}
#line 3689 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 261:
#line 1206 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_ALWAYS);
		append_attr(node, (yyvsp[-1].al));
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
	}
#line 3700 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 262:
#line 1211 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *block = new AstNode(AST_BLOCK);
		ast_stack.back()->children.push_back(block);
		ast_stack.push_back(block);
	}
#line 3710 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 263:
#line 1215 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
		ast_stack.pop_back();
	}
#line 3719 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 264:
#line 1219 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_INITIAL);
		append_attr(node, (yyvsp[-1].al));
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
		AstNode *block = new AstNode(AST_BLOCK);
		ast_stack.back()->children.push_back(block);
		ast_stack.push_back(block);
	}
#line 3733 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 265:
#line 1227 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
		ast_stack.pop_back();
	}
#line 3742 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 275:
#line 1246 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_POSEDGE);
		ast_stack.back()->children.push_back(node);
		node->children.push_back((yyvsp[0].ast));
	}
#line 3752 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 276:
#line 1251 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_NEGEDGE);
		ast_stack.back()->children.push_back(node);
		node->children.push_back((yyvsp[0].ast));
	}
#line 3762 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 277:
#line 1256 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_EDGE);
		ast_stack.back()->children.push_back(node);
		node->children.push_back((yyvsp[0].ast));
	}
#line 3772 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 278:
#line 1263 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.string) = (yyvsp[0].string);
	}
#line 3780 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 279:
#line 1266 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.string) = NULL;
	}
#line 3788 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 284:
#line 1277 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(assume_asserts_mode ? AST_ASSUME : AST_ASSERT, (yyvsp[-2].ast)));
	}
#line 3796 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 285:
#line 1280 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_ASSUME, (yyvsp[-2].ast)));
	}
#line 3804 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 286:
#line 1283 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(assume_asserts_mode ? AST_FAIR : AST_LIVE, (yyvsp[-2].ast)));
	}
#line 3812 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 287:
#line 1286 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_FAIR, (yyvsp[-2].ast)));
	}
#line 3820 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 288:
#line 1289 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_COVER, (yyvsp[-2].ast)));
	}
#line 3828 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 289:
#line 1292 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_COVER, AstNode::mkconst_int(1, false)));
	}
#line 3836 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 290:
#line 1295 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_COVER, AstNode::mkconst_int(1, false)));
	}
#line 3844 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 291:
#line 1298 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (norestrict_mode)
			delete (yyvsp[-2].ast);
		else
			ast_stack.back()->children.push_back(new AstNode(AST_ASSUME, (yyvsp[-2].ast)));
	}
#line 3855 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 292:
#line 1304 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (norestrict_mode)
			delete (yyvsp[-2].ast);
		else
			ast_stack.back()->children.push_back(new AstNode(AST_FAIR, (yyvsp[-2].ast)));
	}
#line 3866 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 293:
#line 1312 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(assume_asserts_mode ? AST_ASSUME : AST_ASSERT, (yyvsp[-2].ast)));
	}
#line 3874 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 294:
#line 1315 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_ASSUME, (yyvsp[-2].ast)));
	}
#line 3882 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 295:
#line 1318 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(assume_asserts_mode ? AST_FAIR : AST_LIVE, (yyvsp[-2].ast)));
	}
#line 3890 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 296:
#line 1321 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_FAIR, (yyvsp[-2].ast)));
	}
#line 3898 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 297:
#line 1324 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_COVER, (yyvsp[-2].ast)));
	}
#line 3906 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 298:
#line 1327 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (norestrict_mode)
			delete (yyvsp[-2].ast);
		else
			ast_stack.back()->children.push_back(new AstNode(AST_ASSUME, (yyvsp[-2].ast)));
	}
#line 3917 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 299:
#line 1333 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (norestrict_mode)
			delete (yyvsp[-2].ast);
		else
			ast_stack.back()->children.push_back(new AstNode(AST_FAIR, (yyvsp[-2].ast)));
	}
#line 3928 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 300:
#line 1341 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_ASSIGN_EQ, (yyvsp[-3].ast), (yyvsp[0].ast));
		ast_stack.back()->children.push_back(node);
	}
#line 3937 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 301:
#line 1345 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_ASSIGN_EQ, (yyvsp[-1].ast), new AstNode(AST_ADD, (yyvsp[-1].ast)->clone(), AstNode::mkconst_int(1, true)));
		ast_stack.back()->children.push_back(node);
	}
#line 3946 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 302:
#line 1349 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_ASSIGN_EQ, (yyvsp[-1].ast), new AstNode(AST_SUB, (yyvsp[-1].ast)->clone(), AstNode::mkconst_int(1, true)));
		ast_stack.back()->children.push_back(node);
	}
#line 3955 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 303:
#line 1353 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_ASSIGN_LE, (yyvsp[-3].ast), (yyvsp[0].ast));
		ast_stack.back()->children.push_back(node);
	}
#line 3964 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 312:
#line 1363 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_TCALL);
		node->str = *(yyvsp[-1].string);
		delete (yyvsp[-1].string);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
		append_attr(node, (yyvsp[0].al));
	}
#line 3977 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 313:
#line 1370 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
	}
#line 3985 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 314:
#line 1373 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_BLOCK);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
		append_attr(node, (yyvsp[-2].al));
		if ((yyvsp[0].string) != NULL)
			node->str = *(yyvsp[0].string);
	}
#line 3998 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 315:
#line 1380 "verilog_parser.y" /* yacc.c:1663  */
    {
		if ((yyvsp[-4].string) != NULL && (yyvsp[0].string) != NULL && *(yyvsp[-4].string) != *(yyvsp[0].string))
			frontend_verilog_yyerror("Syntax error.");
		if ((yyvsp[-4].string) != NULL)
			delete (yyvsp[-4].string);
		if ((yyvsp[0].string) != NULL)
			delete (yyvsp[0].string);
		ast_stack.pop_back();
	}
#line 4012 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 316:
#line 1389 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_FOR);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
		append_attr(node, (yyvsp[-2].al));
	}
#line 4023 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 317:
#line 1394 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back((yyvsp[0].ast));
	}
#line 4031 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 318:
#line 1396 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *block = new AstNode(AST_BLOCK);
		ast_stack.back()->children.push_back(block);
		ast_stack.push_back(block);
	}
#line 4041 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 319:
#line 1400 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
		ast_stack.pop_back();
	}
#line 4050 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 320:
#line 1404 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_WHILE);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
		append_attr(node, (yyvsp[-4].al));
		AstNode *block = new AstNode(AST_BLOCK);
		ast_stack.back()->children.push_back((yyvsp[-1].ast));
		ast_stack.back()->children.push_back(block);
		ast_stack.push_back(block);
	}
#line 4065 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 321:
#line 1413 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
		ast_stack.pop_back();
	}
#line 4074 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 322:
#line 1417 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_REPEAT);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
		append_attr(node, (yyvsp[-4].al));
		AstNode *block = new AstNode(AST_BLOCK);
		ast_stack.back()->children.push_back((yyvsp[-1].ast));
		ast_stack.back()->children.push_back(block);
		ast_stack.push_back(block);
	}
#line 4089 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 323:
#line 1426 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
		ast_stack.pop_back();
	}
#line 4098 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 324:
#line 1430 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_CASE);
		AstNode *block = new AstNode(AST_BLOCK);
		AstNode *cond = new AstNode(AST_COND, AstNode::mkconst_int(1, false, 1), block);
		ast_stack.back()->children.push_back(node);
		node->children.push_back(new AstNode(AST_REDUCE_BOOL, (yyvsp[-1].ast)));
		node->children.push_back(cond);
		ast_stack.push_back(node);
		ast_stack.push_back(block);
		append_attr(node, (yyvsp[-4].al));
	}
#line 4114 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 325:
#line 1440 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
		ast_stack.pop_back();
	}
#line 4123 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 326:
#line 1444 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_CASE, (yyvsp[-1].ast));
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
		append_attr(node, (yyvsp[-4].al));
	}
#line 4134 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 327:
#line 1449 "verilog_parser.y" /* yacc.c:1663  */
    {
		case_type_stack.pop_back();
		ast_stack.pop_back();
	}
#line 4143 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 328:
#line 1455 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.boolean) = false;
	}
#line 4151 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 329:
#line 1458 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.boolean) = (yyvsp[0].al);
	}
#line 4159 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 330:
#line 1461 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.boolean) = true;
	}
#line 4167 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 331:
#line 1466 "verilog_parser.y" /* yacc.c:1663  */
    {
		if ((yyvsp[0].boolean)) (*(yyvsp[-1].al))["\\parallel_case"] = AstNode::mkconst_int(1, false);
		(yyval.al) = (yyvsp[-1].al);
	}
#line 4176 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 332:
#line 1472 "verilog_parser.y" /* yacc.c:1663  */
    {
		case_type_stack.push_back(0);
	}
#line 4184 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 333:
#line 1475 "verilog_parser.y" /* yacc.c:1663  */
    {
		case_type_stack.push_back('x');
	}
#line 4192 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 334:
#line 1478 "verilog_parser.y" /* yacc.c:1663  */
    {
		case_type_stack.push_back('z');
	}
#line 4200 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 335:
#line 1483 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (ast_stack.back()->attributes.count("\\full_case") == 0)
			ast_stack.back()->attributes["\\full_case"] = AstNode::mkconst_int(1, false);
	}
#line 4209 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 336:
#line 1487 "verilog_parser.y" /* yacc.c:1663  */
    {
		if (ast_stack.back()->attributes.count("\\parallel_case") == 0)
			ast_stack.back()->attributes["\\parallel_case"] = AstNode::mkconst_int(1, false);
	}
#line 4218 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 340:
#line 1498 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *block = new AstNode(AST_BLOCK);
		AstNode *cond = new AstNode(AST_COND, new AstNode(AST_DEFAULT), block);
		ast_stack.pop_back();
		ast_stack.back()->children.push_back(cond);
		ast_stack.push_back(block);
	}
#line 4230 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 345:
#line 1512 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(
				case_type_stack.size() && case_type_stack.back() == 'x' ? AST_CONDX :
				case_type_stack.size() && case_type_stack.back() == 'z' ? AST_CONDZ : AST_COND);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
	}
#line 4242 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 346:
#line 1518 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *block = new AstNode(AST_BLOCK);
		ast_stack.back()->children.push_back(block);
		ast_stack.push_back(block);
		case_type_stack.push_back(0);
	}
#line 4253 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 347:
#line 1523 "verilog_parser.y" /* yacc.c:1663  */
    {
		case_type_stack.pop_back();
		ast_stack.pop_back();
		ast_stack.pop_back();
	}
#line 4263 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 350:
#line 1534 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(
				case_type_stack.size() && case_type_stack.back() == 'x' ? AST_CONDX :
				case_type_stack.size() && case_type_stack.back() == 'z' ? AST_CONDZ : AST_COND);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
	}
#line 4275 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 351:
#line 1540 "verilog_parser.y" /* yacc.c:1663  */
    {
		case_type_stack.push_back(0);
	}
#line 4283 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 352:
#line 1542 "verilog_parser.y" /* yacc.c:1663  */
    {
		case_type_stack.pop_back();
		ast_stack.pop_back();
	}
#line 4292 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 355:
#line 1552 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back(new AstNode(AST_DEFAULT));
	}
#line 4300 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 356:
#line 1555 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back((yyvsp[0].ast));
	}
#line 4308 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 357:
#line 1558 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back((yyvsp[0].ast));
	}
#line 4316 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 358:
#line 1563 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_PREFIX, (yyvsp[-3].ast), (yyvsp[0].ast));
		(yyval.ast)->str = *(yyvsp[-5].string);
		delete (yyvsp[-5].string);
	}
#line 4326 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 359:
#line 1568 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_IDENTIFIER, (yyvsp[0].ast));
		(yyval.ast)->str = *(yyvsp[-1].string);
		delete (yyvsp[-1].string);
		if ((yyvsp[0].ast) == nullptr && ((yyval.ast)->str == "\\$initstate" ||
				(yyval.ast)->str == "\\$anyconst" || (yyval.ast)->str == "\\$anyseq" ||
				(yyval.ast)->str == "\\$allconst" || (yyval.ast)->str == "\\$allseq"))
			(yyval.ast)->type = AST_FCALL;
	}
#line 4340 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 360:
#line 1577 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_IDENTIFIER, (yyvsp[0].ast));
		(yyval.ast)->str = *(yyvsp[-1].string);
		delete (yyvsp[-1].string);
	}
#line 4350 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 361:
#line 1584 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[0].ast);
	}
#line 4358 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 362:
#line 1587 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[-1].ast);
	}
#line 4366 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 363:
#line 1592 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_CONCAT);
		(yyval.ast)->children.push_back((yyvsp[0].ast));
	}
#line 4375 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 364:
#line 1596 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[0].ast);
		(yyval.ast)->children.push_back((yyvsp[-2].ast));
	}
#line 4384 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 371:
#line 1614 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back((yyvsp[0].ast));
	}
#line 4392 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 376:
#line 1627 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_GENFOR);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
	}
#line 4402 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 377:
#line 1631 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.back()->children.push_back((yyvsp[0].ast));
	}
#line 4410 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 378:
#line 1633 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
	}
#line 4418 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 379:
#line 1636 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_GENIF);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
		ast_stack.back()->children.push_back((yyvsp[-1].ast));
	}
#line 4429 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 380:
#line 1641 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
	}
#line 4437 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 381:
#line 1644 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_GENCASE, (yyvsp[-1].ast));
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
	}
#line 4447 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 382:
#line 1648 "verilog_parser.y" /* yacc.c:1663  */
    {
		case_type_stack.pop_back();
		ast_stack.pop_back();
	}
#line 4456 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 383:
#line 1652 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_GENBLOCK);
		node->str = (yyvsp[0].string) ? *(yyvsp[0].string) : std::string();
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
	}
#line 4467 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 384:
#line 1657 "verilog_parser.y" /* yacc.c:1663  */
    {
		if ((yyvsp[-4].string) != NULL)
			delete (yyvsp[-4].string);
		if ((yyvsp[0].string) != NULL)
			delete (yyvsp[0].string);
		ast_stack.pop_back();
	}
#line 4479 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 385:
#line 1666 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_GENBLOCK);
		ast_stack.back()->children.push_back(node);
		ast_stack.push_back(node);
	}
#line 4489 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 386:
#line 1670 "verilog_parser.y" /* yacc.c:1663  */
    {
		ast_stack.pop_back();
	}
#line 4497 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 391:
#line 1681 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[0].ast);
	}
#line 4505 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 392:
#line 1684 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_TERNARY);
		(yyval.ast)->children.push_back((yyvsp[-5].ast));
		(yyval.ast)->children.push_back((yyvsp[-2].ast));
		(yyval.ast)->children.push_back((yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-3].al));
	}
#line 4517 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 393:
#line 1693 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[0].ast);
	}
#line 4525 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 394:
#line 1696 "verilog_parser.y" /* yacc.c:1663  */
    {
		if ((yyvsp[0].string)->substr(0, 1) != "'")
			frontend_verilog_yyerror("Syntax error.");
		AstNode *bits = (yyvsp[-2].ast);
		AstNode *val = const2ast(*(yyvsp[0].string), case_type_stack.size() == 0 ? 0 : case_type_stack.back(), !lib_mode);
		if (val == NULL)
			log_error("Value conversion failed: `%s'\n", (yyvsp[0].string)->c_str());
		(yyval.ast) = new AstNode(AST_TO_BITS, bits, val);
		delete (yyvsp[0].string);
	}
#line 4540 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 395:
#line 1706 "verilog_parser.y" /* yacc.c:1663  */
    {
		if ((yyvsp[0].string)->substr(0, 1) != "'")
			frontend_verilog_yyerror("Syntax error.");
		AstNode *bits = new AstNode(AST_IDENTIFIER);
		bits->str = *(yyvsp[-1].string);
		AstNode *val = const2ast(*(yyvsp[0].string), case_type_stack.size() == 0 ? 0 : case_type_stack.back(), !lib_mode);
		if (val == NULL)
			log_error("Value conversion failed: `%s'\n", (yyvsp[0].string)->c_str());
		(yyval.ast) = new AstNode(AST_TO_BITS, bits, val);
		delete (yyvsp[-1].string);
		delete (yyvsp[0].string);
	}
#line 4557 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 396:
#line 1718 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = const2ast(*(yyvsp[-1].string) + *(yyvsp[0].string), case_type_stack.size() == 0 ? 0 : case_type_stack.back(), !lib_mode);
		if ((yyval.ast) == NULL || (*(yyvsp[0].string))[0] != '\'')
			log_error("Value conversion failed: `%s%s'\n", (yyvsp[-1].string)->c_str(), (yyvsp[0].string)->c_str());
		delete (yyvsp[-1].string);
		delete (yyvsp[0].string);
	}
#line 4569 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 397:
#line 1725 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = const2ast(*(yyvsp[0].string), case_type_stack.size() == 0 ? 0 : case_type_stack.back(), !lib_mode);
		if ((yyval.ast) == NULL)
			log_error("Value conversion failed: `%s'\n", (yyvsp[0].string)->c_str());
		delete (yyvsp[0].string);
	}
#line 4580 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 398:
#line 1731 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_REALVALUE);
		char *p = (char*)malloc(GetSize(*(yyvsp[0].string)) + 1), *q;
		for (int i = 0, j = 0; j < GetSize(*(yyvsp[0].string)); j++)
			if ((*(yyvsp[0].string))[j] != '_')
				p[i++] = (*(yyvsp[0].string))[j], p[i] = 0;
		(yyval.ast)->realvalue = strtod(p, &q);
		log_assert(*q == 0);
		delete (yyvsp[0].string);
		free(p);
	}
#line 4596 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 399:
#line 1742 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = AstNode::mkconst_str(*(yyvsp[0].string));
		delete (yyvsp[0].string);
	}
#line 4605 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 400:
#line 1746 "verilog_parser.y" /* yacc.c:1663  */
    {
		AstNode *node = new AstNode(AST_FCALL);
		node->str = *(yyvsp[-1].string);
		delete (yyvsp[-1].string);
		ast_stack.push_back(node);
		append_attr(node, (yyvsp[0].al));
	}
#line 4617 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 401:
#line 1752 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = ast_stack.back();
		ast_stack.pop_back();
	}
#line 4626 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 402:
#line 1756 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_TO_SIGNED, (yyvsp[-1].ast));
		append_attr((yyval.ast), (yyvsp[-3].al));
	}
#line 4635 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 403:
#line 1760 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_TO_UNSIGNED, (yyvsp[-1].ast));
		append_attr((yyval.ast), (yyvsp[-3].al));
	}
#line 4644 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 404:
#line 1764 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[-1].ast);
	}
#line 4652 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 405:
#line 1767 "verilog_parser.y" /* yacc.c:1663  */
    {
		delete (yyvsp[-5].ast);
		(yyval.ast) = (yyvsp[-3].ast);
		delete (yyvsp[-1].ast);
	}
#line 4662 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 406:
#line 1772 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[-1].ast);
	}
#line 4670 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 407:
#line 1775 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_REPLICATE, (yyvsp[-4].ast), (yyvsp[-2].ast));
	}
#line 4678 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 408:
#line 1778 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_BIT_NOT, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4687 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 409:
#line 1782 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_BIT_AND, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4696 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 410:
#line 1786 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_BIT_NOT, new AstNode(AST_BIT_AND, (yyvsp[-3].ast), (yyvsp[0].ast)));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4705 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 411:
#line 1790 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_BIT_OR, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4714 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 412:
#line 1794 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_BIT_NOT, new AstNode(AST_BIT_OR, (yyvsp[-3].ast), (yyvsp[0].ast)));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4723 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 413:
#line 1798 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_BIT_XOR, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4732 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 414:
#line 1802 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_BIT_XNOR, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4741 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 415:
#line 1806 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_REDUCE_AND, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4750 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 416:
#line 1810 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_REDUCE_AND, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
		(yyval.ast) = new AstNode(AST_LOGIC_NOT, (yyval.ast));
	}
#line 4760 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 417:
#line 1815 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_REDUCE_OR, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4769 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 418:
#line 1819 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_REDUCE_OR, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
		(yyval.ast) = new AstNode(AST_LOGIC_NOT, (yyval.ast));
	}
#line 4779 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 419:
#line 1824 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_REDUCE_XOR, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4788 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 420:
#line 1828 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_REDUCE_XNOR, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4797 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 421:
#line 1832 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_SHIFT_LEFT, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4806 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 422:
#line 1836 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_SHIFT_RIGHT, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4815 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 423:
#line 1840 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_SHIFT_SLEFT, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4824 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 424:
#line 1844 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_SHIFT_SRIGHT, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4833 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 425:
#line 1848 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_LT, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4842 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 426:
#line 1852 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_LE, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4851 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 427:
#line 1856 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_EQ, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4860 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 428:
#line 1860 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_NE, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4869 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 429:
#line 1864 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_EQX, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4878 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 430:
#line 1868 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_NEX, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4887 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 431:
#line 1872 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_GE, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4896 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 432:
#line 1876 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_GT, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4905 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 433:
#line 1880 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_ADD, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4914 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 434:
#line 1884 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_SUB, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4923 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 435:
#line 1888 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_MUL, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4932 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 436:
#line 1892 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_DIV, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4941 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 437:
#line 1896 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_MOD, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4950 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 438:
#line 1900 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_POW, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4959 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 439:
#line 1904 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_POS, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4968 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 440:
#line 1908 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_NEG, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4977 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 441:
#line 1912 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_LOGIC_AND, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4986 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 442:
#line 1916 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_LOGIC_OR, (yyvsp[-3].ast), (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 4995 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 443:
#line 1920 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_LOGIC_NOT, (yyvsp[0].ast));
		append_attr((yyval.ast), (yyvsp[-1].al));
	}
#line 5004 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 444:
#line 1926 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = new AstNode(AST_CONCAT, (yyvsp[0].ast));
	}
#line 5012 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 445:
#line 1929 "verilog_parser.y" /* yacc.c:1663  */
    {
		(yyval.ast) = (yyvsp[0].ast);
		(yyval.ast)->children.push_back((yyvsp[-2].ast));
	}
#line 5021 "../verilog_parser.tab.cc" /* yacc.c:1663  */
    break;


#line 5025 "../verilog_parser.tab.cc" /* yacc.c:1663  */
        default: break;
      }
    if (yychar_backup != yychar)
      YY_LAC_DISCARD ("yychar change");
  }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyesa, &yyes, &yyes_capacity, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        if (yychar != YYEMPTY)
          YY_LAC_ESTABLISH;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  /* If the stack popping above didn't lose the initial context for the
     current lookahead token, the shift below will for sure.  */
  YY_LAC_DISCARD ("error recovery");

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if 1
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  if (yyes != yyesa)
    YYSTACK_FREE (yyes);
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
