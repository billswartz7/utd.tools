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
#define yyparse         rtlil_frontend_ilang_yyparse
#define yylex           rtlil_frontend_ilang_yylex
#define yyerror         rtlil_frontend_ilang_yyerror
#define yydebug         rtlil_frontend_ilang_yydebug
#define yynerrs         rtlil_frontend_ilang_yynerrs

#define yylval          rtlil_frontend_ilang_yylval
#define yychar          rtlil_frontend_ilang_yychar

/* Copy the first part of user declarations.  */
#line 25 "ilang_parser.y" /* yacc.c:339  */

#include <list>
#include "frontends/ilang/ilang_frontend.h"
YOSYS_NAMESPACE_BEGIN
namespace ILANG_FRONTEND {
	std::istream *lexin;
	RTLIL::Design *current_design;
	RTLIL::Module *current_module;
	RTLIL::Wire *current_wire;
	RTLIL::Memory *current_memory;
	RTLIL::Cell *current_cell;
	RTLIL::Process *current_process;
	std::vector<std::vector<RTLIL::SwitchRule*>*> switch_stack;
	std::vector<RTLIL::CaseRule*> case_stack;
	dict<RTLIL::IdString, RTLIL::Const> attrbuf;
}
using namespace ILANG_FRONTEND;
YOSYS_NAMESPACE_END
USING_YOSYS_NAMESPACE

#line 95 "../ilang_parser.tab.cc" /* yacc.c:339  */

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
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "ilang_parser.tab.hh".  */
#ifndef YY_RTLIL_FRONTEND_ILANG_YY_ILANG_PARSER_TAB_HH_INCLUDED
# define YY_RTLIL_FRONTEND_ILANG_YY_ILANG_PARSER_TAB_HH_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int rtlil_frontend_ilang_yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_ID = 258,
    TOK_VALUE = 259,
    TOK_STRING = 260,
    TOK_INT = 261,
    TOK_AUTOIDX = 262,
    TOK_MODULE = 263,
    TOK_WIRE = 264,
    TOK_WIDTH = 265,
    TOK_INPUT = 266,
    TOK_OUTPUT = 267,
    TOK_INOUT = 268,
    TOK_CELL = 269,
    TOK_CONNECT = 270,
    TOK_SWITCH = 271,
    TOK_CASE = 272,
    TOK_ASSIGN = 273,
    TOK_SYNC = 274,
    TOK_LOW = 275,
    TOK_HIGH = 276,
    TOK_POSEDGE = 277,
    TOK_NEGEDGE = 278,
    TOK_EDGE = 279,
    TOK_ALWAYS = 280,
    TOK_GLOBAL = 281,
    TOK_INIT = 282,
    TOK_UPDATE = 283,
    TOK_PROCESS = 284,
    TOK_END = 285,
    TOK_INVALID = 286,
    TOK_EOL = 287,
    TOK_OFFSET = 288,
    TOK_PARAMETER = 289,
    TOK_ATTRIBUTE = 290,
    TOK_MEMORY = 291,
    TOK_SIZE = 292,
    TOK_SIGNED = 293,
    TOK_UPTO = 294
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 48 "ilang_parser.y" /* yacc.c:355  */

	char *string;
	int integer;
	YOSYS_NAMESPACE_PREFIX RTLIL::Const *data;
	YOSYS_NAMESPACE_PREFIX RTLIL::SigSpec *sigspec;
	std::vector<YOSYS_NAMESPACE_PREFIX RTLIL::SigSpec> *rsigspec;

#line 183 "../ilang_parser.tab.cc" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE rtlil_frontend_ilang_yylval;

int rtlil_frontend_ilang_yyparse (void);

#endif /* !YY_RTLIL_FRONTEND_ILANG_YY_ILANG_PARSER_TAB_HH_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 200 "../ilang_parser.tab.cc" /* yacc.c:358  */

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


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

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
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


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
#define YYLAST   143

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  46
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  45
/* YYNRULES -- Number of rules.  */
#define YYNRULES  90
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  163

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   294

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    40,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    43,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    41,     2,    42,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    44,     2,    45,     2,     2,     2,     2,
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
      35,    36,    37,    38,    39
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    75,    75,    75,    83,    86,    86,    89,    90,    91,
      91,    95,   104,    95,   111,   111,   115,   115,   115,   115,
     115,   115,   115,   118,   124,   131,   136,   136,   148,   151,
     154,   157,   162,   167,   171,   175,   175,   188,   191,   194,
     196,   200,   200,   211,   216,   222,   228,   232,   232,   248,
     248,   257,   259,   262,   262,   270,   274,   278,   281,   285,
     286,   286,   290,   297,   297,   304,   304,   310,   310,   316,
     316,   321,   325,   326,   327,   328,   329,   332,   336,   340,
     371,   374,   380,   384,   390,   396,   402,   407,   411,   415,
     423
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "TOK_ID", "TOK_VALUE", "TOK_STRING",
  "TOK_INT", "TOK_AUTOIDX", "TOK_MODULE", "TOK_WIRE", "TOK_WIDTH",
  "TOK_INPUT", "TOK_OUTPUT", "TOK_INOUT", "TOK_CELL", "TOK_CONNECT",
  "TOK_SWITCH", "TOK_CASE", "TOK_ASSIGN", "TOK_SYNC", "TOK_LOW",
  "TOK_HIGH", "TOK_POSEDGE", "TOK_NEGEDGE", "TOK_EDGE", "TOK_ALWAYS",
  "TOK_GLOBAL", "TOK_INIT", "TOK_UPDATE", "TOK_PROCESS", "TOK_END",
  "TOK_INVALID", "TOK_EOL", "TOK_OFFSET", "TOK_PARAMETER", "TOK_ATTRIBUTE",
  "TOK_MEMORY", "TOK_SIZE", "TOK_SIGNED", "TOK_UPTO", "','", "'['", "']'",
  "':'", "'{'", "'}'", "$accept", "input", "$@1", "EOL", "optional_eol",
  "design", "module", "$@2", "$@3", "module_body", "module_stmt",
  "param_stmt", "attr_stmt", "autoidx_stmt", "wire_stmt", "$@4",
  "wire_options", "memory_stmt", "$@5", "memory_options", "cell_stmt",
  "$@6", "cell_body", "proc_stmt", "$@7", "switch_stmt", "$@8",
  "attr_list", "switch_body", "$@9", "compare_list", "case_body",
  "assign_stmt", "sync_list", "$@10", "$@11", "$@12", "$@13", "sync_type",
  "update_list", "constant", "sigspec", "sigspec_list_reversed",
  "sigspec_list", "conn_stmt", YY_NULLPTR
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
      44,    91,    93,    58,   123,   125
};
# endif

#define YYPACT_NINF -60

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-60)))

#define YYTABLE_NINF -72

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int8 yypact[] =
{
     -60,     9,    -7,   -60,   -60,   -60,     5,    21,    26,    30,
     -60,   -60,   -60,   -60,   -60,    65,   -60,    20,   -60,   -60,
     -60,   -60,   -60,    24,   -60,   -60,    48,   -60,    38,     1,
      56,   -60,    57,   -60,   -60,   -60,   -60,   -60,   -60,   -60,
     -60,   -60,   -60,    61,    32,   -60,   -60,     1,   -60,   -60,
     -60,   -60,    11,   -60,    59,     1,    31,   -60,   -60,   -60,
     -60,    16,   -60,    69,    73,    79,    83,    84,   -60,   -60,
      -5,   -60,   -60,   -60,   -60,   -60,    85,    86,    87,   -60,
     -60,   -60,   -60,   -60,   -60,   -60,   -60,    89,    36,   -60,
     -60,   -60,   -60,    17,    54,     1,   -60,   -15,   -60,    12,
      94,   -60,     8,   -60,     1,     1,   -60,   103,   -60,     1,
     -60,    65,    98,   -60,   -60,   -60,   -60,   -60,   -60,   -60,
     -60,   -60,   -60,     1,   -60,   -60,   -60,    65,   -60,   -60,
     -60,   -60,   -60,   -60,   -60,   -60,   -60,   -60,   -60,   -60,
     -60,   -60,   -60,     0,    74,    74,    74,   -60,   -60,   -60,
       1,    74,     1,   -60,     1,    63,   -60,   -60,     1,   -60,
     -60,   -60,    -2
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       6,     0,     2,     1,     5,    10,     3,     0,     0,     0,
       7,     8,     9,     6,     6,     0,    25,     0,    11,    79,
      81,    80,     6,     4,    15,    24,     0,    26,     0,     0,
       0,    12,     0,    35,    14,    16,    17,    18,    19,    20,
      21,    22,    34,     0,    83,    88,    82,     0,     6,     6,
       6,    40,     0,     6,     0,    89,     0,     6,    47,    13,
      23,     0,     6,     0,     0,     0,     0,     0,    29,    41,
       0,    87,    86,    90,    61,     6,     0,     0,     0,    27,
      28,    31,    32,    33,    30,    46,    84,     0,    51,    36,
      37,    39,    38,     0,     0,     0,    59,     0,    60,     0,
       0,     6,     0,    85,     0,     0,    52,     0,     6,     0,
      42,     0,     0,     6,     6,    72,    73,    74,    75,    76,
       6,     6,     6,     0,    48,     6,     6,     0,    62,    49,
      65,    67,    69,     6,    45,    43,     6,    55,    78,    78,
      78,    63,    44,     0,    66,    68,    70,    78,    53,     6,
       0,    64,    58,    50,     0,     6,    56,     6,     0,    61,
      77,    57,    51
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -60,   -60,   -60,   -14,   104,   -60,   -60,   -60,   -60,   -60,
     -60,   -60,   -23,   -60,   -60,   -60,   -60,   -60,   -60,   -60,
     -60,   -60,   -60,   -60,   -60,   -60,   -60,   -60,   -60,   -60,
     -60,   -54,   -60,   -60,   -60,   -60,   -60,   -60,   -60,   -59,
     -13,   -37,   -60,   -60,   -60
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     5,    16,    17,     6,    10,    24,    49,    26,
      34,    35,    11,    12,    37,    42,    52,    38,    51,    61,
      39,    85,    93,    40,    74,    96,   137,    97,   143,   152,
     155,    88,    98,    99,   147,   138,   139,   140,   123,   144,
      46,    47,    55,    56,    41
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      18,   105,    22,    36,    44,    19,    20,    21,    25,     3,
      57,   111,     7,     8,    62,   -54,    95,   148,    71,    75,
       9,    63,    64,    65,    66,     4,    76,    13,   -54,    14,
     149,   107,   100,    15,    58,    59,    60,    86,    87,    69,
       9,    43,   108,    73,    67,    45,   112,   101,    79,    77,
      68,   102,    23,    78,    95,   -71,    -5,    27,   104,    48,
      50,    89,    28,    29,    53,    70,   -71,   113,   114,    19,
      20,    21,   125,    54,   106,    80,    72,    30,    31,    81,
     145,   146,    32,     9,    33,    82,   133,   110,   151,    83,
      84,    90,    91,    92,   124,    94,   103,   109,   126,   128,
     129,   127,   150,   158,     2,   162,   130,   131,   132,     0,
       0,   134,   135,   154,   136,   156,     0,   157,     0,   141,
       0,   161,   142,   115,   116,   117,   118,   119,   120,   121,
     122,     0,     0,     0,     0,   153,     0,     0,     0,     0,
       0,   159,     0,   160
};

static const yytype_int16 yycheck[] =
{
      14,    16,    15,    26,     3,     4,     5,     6,    22,     0,
      47,     3,     7,     8,     3,    17,    18,    17,    55,     3,
      35,    10,    11,    12,    13,    32,    10,     6,    30,     3,
      30,    19,    15,     3,    48,    49,    50,    42,    43,    53,
      35,     3,    30,    57,    33,    44,    38,    30,    62,    33,
      39,    34,    32,    37,    18,    19,    32,     9,    95,     3,
       3,    75,    14,    15,     3,     6,    30,   104,   105,     4,
       5,     6,   109,    41,    97,     6,    45,    29,    30,     6,
     139,   140,    34,    35,    36,     6,   123,   101,   147,     6,
       6,     6,     6,     6,   108,     6,    42,     3,   111,   113,
     114,     3,    28,    40,     0,   159,   120,   121,   122,    -1,
      -1,   125,   126,   150,   127,   152,    -1,   154,    -1,   133,
      -1,   158,   136,    20,    21,    22,    23,    24,    25,    26,
      27,    -1,    -1,    -1,    -1,   149,    -1,    -1,    -1,    -1,
      -1,   155,    -1,   157
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    47,    50,     0,    32,    48,    51,     7,     8,    35,
      52,    58,    59,     6,     3,     3,    49,    50,    49,     4,
       5,     6,    86,    32,    53,    49,    55,     9,    14,    15,
      29,    30,    34,    36,    56,    57,    58,    60,    63,    66,
      69,    90,    61,     3,     3,    44,    86,    87,     3,    54,
       3,    64,    62,     3,    41,    88,    89,    87,    49,    49,
      49,    65,     3,    10,    11,    12,    13,    33,    39,    49,
       6,    87,    45,    49,    70,     3,    10,    33,    37,    49,
       6,     6,     6,     6,     6,    67,    42,    43,    77,    49,
       6,     6,     6,    68,     6,    18,    71,    73,    78,    79,
      15,    30,    34,    42,    87,    16,    58,    19,    30,     3,
      49,     3,    38,    87,    87,    20,    21,    22,    23,    24,
      25,    26,    27,    84,    49,    87,    86,     3,    49,    49,
      49,    49,    49,    87,    49,    49,    86,    72,    81,    82,
      83,    49,    49,    74,    85,    85,    85,    80,    17,    30,
      28,    85,    75,    49,    87,    76,    87,    87,    40,    49,
      49,    87,    77
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    46,    48,    47,    49,    50,    50,    51,    51,    51,
      51,    53,    54,    52,    55,    55,    56,    56,    56,    56,
      56,    56,    56,    57,    58,    59,    61,    60,    62,    62,
      62,    62,    62,    62,    62,    64,    63,    65,    65,    65,
      65,    67,    66,    68,    68,    68,    68,    70,    69,    72,
      71,    73,    73,    75,    74,    74,    76,    76,    76,    77,
      77,    77,    78,    80,    79,    81,    79,    82,    79,    83,
      79,    79,    84,    84,    84,    84,    84,    85,    85,    86,
      86,    86,    87,    87,    87,    87,    87,    88,    88,    89,
      90
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     3,     2,     2,     0,     2,     2,     2,
       0,     0,     0,     8,     2,     0,     1,     1,     1,     1,
       1,     1,     1,     3,     4,     3,     0,     5,     3,     2,
       3,     3,     3,     3,     0,     0,     5,     3,     3,     3,
       0,     0,     8,     5,     6,     5,     0,     0,     8,     0,
       8,     0,     2,     0,     6,     0,     1,     3,     0,     2,
       2,     0,     4,     0,     7,     0,     6,     0,     6,     0,
       6,     0,     1,     1,     1,     1,     1,     5,     0,     1,
       1,     1,     1,     1,     4,     6,     3,     2,     0,     1,
       4
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
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
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
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
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
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
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
  switch (yyn)
    {
        case 2:
#line 75 "ilang_parser.y" /* yacc.c:1663  */
    {
		attrbuf.clear();
	}
#line 1402 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 3:
#line 77 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (attrbuf.size() != 0)
			rtlil_frontend_ilang_yyerror("dangling attribute");
	}
#line 1411 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 11:
#line 95 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (current_design->has((yyvsp[-1].string)))
			rtlil_frontend_ilang_yyerror(stringf("ilang error: redefinition of module %s.", (yyvsp[-1].string)).c_str());
		current_module = new RTLIL::Module;
		current_module->name = (yyvsp[-1].string);
		current_module->attributes = attrbuf;
		current_design->add(current_module);
		attrbuf.clear();
		free((yyvsp[-1].string));
	}
#line 1426 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 12:
#line 104 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (attrbuf.size() != 0)
			rtlil_frontend_ilang_yyerror("dangling attribute");
		current_module->fixup_ports();
	}
#line 1436 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 23:
#line 118 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_module->avail_parameters.insert((yyvsp[-1].string));
		free((yyvsp[-1].string));
	}
#line 1445 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 24:
#line 124 "ilang_parser.y" /* yacc.c:1663  */
    {
		attrbuf[(yyvsp[-2].string)] = *(yyvsp[-1].data);
		delete (yyvsp[-1].data);
		free((yyvsp[-2].string));
	}
#line 1455 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 25:
#line 131 "ilang_parser.y" /* yacc.c:1663  */
    {
		autoidx = max(autoidx, (yyvsp[-1].integer));
	}
#line 1463 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 26:
#line 136 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_wire = current_module->addWire("$__ilang_frontend_tmp__");
		current_wire->attributes = attrbuf;
		attrbuf.clear();
	}
#line 1473 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 27:
#line 140 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (current_module->wires_.count((yyvsp[-1].string)) != 0)
			rtlil_frontend_ilang_yyerror(stringf("ilang error: redefinition of wire %s.", (yyvsp[-1].string)).c_str());
		current_module->rename(current_wire, (yyvsp[-1].string));
		free((yyvsp[-1].string));
	}
#line 1484 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 28:
#line 148 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_wire->width = (yyvsp[0].integer);
	}
#line 1492 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 29:
#line 151 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_wire->upto = true;
	}
#line 1500 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 30:
#line 154 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_wire->start_offset = (yyvsp[0].integer);
	}
#line 1508 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 31:
#line 157 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_wire->port_id = (yyvsp[0].integer);
		current_wire->port_input = true;
		current_wire->port_output = false;
	}
#line 1518 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 32:
#line 162 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_wire->port_id = (yyvsp[0].integer);
		current_wire->port_input = false;
		current_wire->port_output = true;
	}
#line 1528 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 33:
#line 167 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_wire->port_id = (yyvsp[0].integer);
		current_wire->port_input = true;
		current_wire->port_output = true;
	}
#line 1538 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 35:
#line 175 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_memory = new RTLIL::Memory;
		current_memory->attributes = attrbuf;
		attrbuf.clear();
	}
#line 1548 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 36:
#line 179 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (current_module->memories.count((yyvsp[-1].string)) != 0)
			rtlil_frontend_ilang_yyerror(stringf("ilang error: redefinition of memory %s.", (yyvsp[-1].string)).c_str());
		current_memory->name = (yyvsp[-1].string);
		current_module->memories[(yyvsp[-1].string)] = current_memory;
		free((yyvsp[-1].string));
	}
#line 1560 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 37:
#line 188 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_memory->width = (yyvsp[0].integer);
	}
#line 1568 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 38:
#line 191 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_memory->size = (yyvsp[0].integer);
	}
#line 1576 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 39:
#line 194 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_memory->start_offset = (yyvsp[0].integer);
	}
#line 1584 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 41:
#line 200 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (current_module->cells_.count((yyvsp[-1].string)) != 0)
			rtlil_frontend_ilang_yyerror(stringf("ilang error: redefinition of cell %s.", (yyvsp[-1].string)).c_str());
		current_cell = current_module->addCell((yyvsp[-1].string), (yyvsp[-2].string));
		current_cell->attributes = attrbuf;
		attrbuf.clear();
		free((yyvsp[-2].string));
		free((yyvsp[-1].string));
	}
#line 1598 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 43:
#line 211 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_cell->parameters[(yyvsp[-2].string)] = *(yyvsp[-1].data);
		free((yyvsp[-2].string));
		delete (yyvsp[-1].data);
	}
#line 1608 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 44:
#line 216 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_cell->parameters[(yyvsp[-2].string)] = *(yyvsp[-1].data);
		current_cell->parameters[(yyvsp[-2].string)].flags |= RTLIL::CONST_FLAG_SIGNED;
		free((yyvsp[-2].string));
		delete (yyvsp[-1].data);
	}
#line 1619 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 45:
#line 222 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (current_cell->hasPort((yyvsp[-2].string)))
			rtlil_frontend_ilang_yyerror(stringf("ilang error: redefinition of cell port %s.", (yyvsp[-2].string)).c_str());
		current_cell->setPort((yyvsp[-2].string), *(yyvsp[-1].sigspec));
		delete (yyvsp[-1].sigspec);
		free((yyvsp[-2].string));
	}
#line 1631 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 47:
#line 232 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (current_module->processes.count((yyvsp[-1].string)) != 0)
			rtlil_frontend_ilang_yyerror(stringf("ilang error: redefinition of process %s.", (yyvsp[-1].string)).c_str());
		current_process = new RTLIL::Process;
		current_process->name = (yyvsp[-1].string);
		current_process->attributes = attrbuf;
		current_module->processes[(yyvsp[-1].string)] = current_process;
		switch_stack.clear();
		switch_stack.push_back(&current_process->root_case.switches);
		case_stack.clear();
		case_stack.push_back(&current_process->root_case);
		attrbuf.clear();
		free((yyvsp[-1].string));
	}
#line 1650 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 49:
#line 248 "ilang_parser.y" /* yacc.c:1663  */
    {
		RTLIL::SwitchRule *rule = new RTLIL::SwitchRule;
		rule->signal = *(yyvsp[-1].sigspec);
		rule->attributes = attrbuf;
		switch_stack.back()->push_back(rule);
		attrbuf.clear();
		delete (yyvsp[-1].sigspec);
	}
#line 1663 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 53:
#line 262 "ilang_parser.y" /* yacc.c:1663  */
    {
		RTLIL::CaseRule *rule = new RTLIL::CaseRule;
		switch_stack.back()->back()->cases.push_back(rule);
		switch_stack.push_back(&rule->switches);
		case_stack.push_back(rule);
	}
#line 1674 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 54:
#line 267 "ilang_parser.y" /* yacc.c:1663  */
    {
		switch_stack.pop_back();
		case_stack.pop_back();
	}
#line 1683 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 56:
#line 274 "ilang_parser.y" /* yacc.c:1663  */
    {
		case_stack.back()->compare.push_back(*(yyvsp[0].sigspec));
		delete (yyvsp[0].sigspec);
	}
#line 1692 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 57:
#line 278 "ilang_parser.y" /* yacc.c:1663  */
    {
		case_stack.back()->compare.push_back(*(yyvsp[0].sigspec));
		delete (yyvsp[0].sigspec);
	}
#line 1701 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 62:
#line 290 "ilang_parser.y" /* yacc.c:1663  */
    {
		case_stack.back()->actions.push_back(RTLIL::SigSig(*(yyvsp[-2].sigspec), *(yyvsp[-1].sigspec)));
		delete (yyvsp[-2].sigspec);
		delete (yyvsp[-1].sigspec);
	}
#line 1711 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 63:
#line 297 "ilang_parser.y" /* yacc.c:1663  */
    {
		RTLIL::SyncRule *rule = new RTLIL::SyncRule;
		rule->type = RTLIL::SyncType((yyvsp[-2].integer));
		rule->signal = *(yyvsp[-1].sigspec);
		current_process->syncs.push_back(rule);
		delete (yyvsp[-1].sigspec);
	}
#line 1723 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 65:
#line 304 "ilang_parser.y" /* yacc.c:1663  */
    {
		RTLIL::SyncRule *rule = new RTLIL::SyncRule;
		rule->type = RTLIL::SyncType::STa;
		rule->signal = RTLIL::SigSpec();
		current_process->syncs.push_back(rule);
	}
#line 1734 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 67:
#line 310 "ilang_parser.y" /* yacc.c:1663  */
    {
		RTLIL::SyncRule *rule = new RTLIL::SyncRule;
		rule->type = RTLIL::SyncType::STg;
		rule->signal = RTLIL::SigSpec();
		current_process->syncs.push_back(rule);
	}
#line 1745 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 69:
#line 316 "ilang_parser.y" /* yacc.c:1663  */
    {
		RTLIL::SyncRule *rule = new RTLIL::SyncRule;
		rule->type = RTLIL::SyncType::STi;
		rule->signal = RTLIL::SigSpec();
		current_process->syncs.push_back(rule);
	}
#line 1756 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 72:
#line 325 "ilang_parser.y" /* yacc.c:1663  */
    { (yyval.integer) = RTLIL::ST0; }
#line 1762 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 73:
#line 326 "ilang_parser.y" /* yacc.c:1663  */
    { (yyval.integer) = RTLIL::ST1; }
#line 1768 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 74:
#line 327 "ilang_parser.y" /* yacc.c:1663  */
    { (yyval.integer) = RTLIL::STp; }
#line 1774 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 75:
#line 328 "ilang_parser.y" /* yacc.c:1663  */
    { (yyval.integer) = RTLIL::STn; }
#line 1780 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 76:
#line 329 "ilang_parser.y" /* yacc.c:1663  */
    { (yyval.integer) = RTLIL::STe; }
#line 1786 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 77:
#line 332 "ilang_parser.y" /* yacc.c:1663  */
    {
		current_process->syncs.back()->actions.push_back(RTLIL::SigSig(*(yyvsp[-2].sigspec), *(yyvsp[-1].sigspec)));
		delete (yyvsp[-2].sigspec);
		delete (yyvsp[-1].sigspec);
	}
#line 1796 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 79:
#line 340 "ilang_parser.y" /* yacc.c:1663  */
    {
		char *ep;
		int width = strtol((yyvsp[0].string), &ep, 10);
		std::list<RTLIL::State> bits;
		while (*(++ep) != 0) {
			RTLIL::State bit = RTLIL::Sx;
			switch (*ep) {
			case '0': bit = RTLIL::S0; break;
			case '1': bit = RTLIL::S1; break;
			case 'x': bit = RTLIL::Sx; break;
			case 'z': bit = RTLIL::Sz; break;
			case '-': bit = RTLIL::Sa; break;
			case 'm': bit = RTLIL::Sm; break;
			}
			bits.push_front(bit);
		}
		if (bits.size() == 0)
			bits.push_back(RTLIL::Sx);
		while ((int)bits.size() < width) {
			RTLIL::State bit = bits.back();
			if (bit == RTLIL::S1)
				bit = RTLIL::S0;
			bits.push_back(bit);
		}
		while ((int)bits.size() > width)
			bits.pop_back();
		(yyval.data) = new RTLIL::Const;
		for (auto it = bits.begin(); it != bits.end(); it++)
			(yyval.data)->bits.push_back(*it);
		free((yyvsp[0].string));
	}
#line 1832 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 80:
#line 371 "ilang_parser.y" /* yacc.c:1663  */
    {
		(yyval.data) = new RTLIL::Const((yyvsp[0].integer), 32);
	}
#line 1840 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 81:
#line 374 "ilang_parser.y" /* yacc.c:1663  */
    {
		(yyval.data) = new RTLIL::Const((yyvsp[0].string));
		free((yyvsp[0].string));
	}
#line 1849 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 82:
#line 380 "ilang_parser.y" /* yacc.c:1663  */
    {
		(yyval.sigspec) = new RTLIL::SigSpec(*(yyvsp[0].data));
		delete (yyvsp[0].data);
	}
#line 1858 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 83:
#line 384 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (current_module->wires_.count((yyvsp[0].string)) == 0)
			rtlil_frontend_ilang_yyerror(stringf("ilang error: wire %s not found", (yyvsp[0].string)).c_str());
		(yyval.sigspec) = new RTLIL::SigSpec(current_module->wires_[(yyvsp[0].string)]);
		free((yyvsp[0].string));
	}
#line 1869 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 84:
#line 390 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (current_module->wires_.count((yyvsp[-3].string)) == 0)
			rtlil_frontend_ilang_yyerror(stringf("ilang error: wire %s not found", (yyvsp[-3].string)).c_str());
		(yyval.sigspec) = new RTLIL::SigSpec(current_module->wires_[(yyvsp[-3].string)], (yyvsp[-1].integer));
		free((yyvsp[-3].string));
	}
#line 1880 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 85:
#line 396 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (current_module->wires_.count((yyvsp[-5].string)) == 0)
			rtlil_frontend_ilang_yyerror(stringf("ilang error: wire %s not found", (yyvsp[-5].string)).c_str());
		(yyval.sigspec) = new RTLIL::SigSpec(current_module->wires_[(yyvsp[-5].string)], (yyvsp[-1].integer), (yyvsp[-3].integer) - (yyvsp[-1].integer) + 1);
		free((yyvsp[-5].string));
	}
#line 1891 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 86:
#line 402 "ilang_parser.y" /* yacc.c:1663  */
    {
		(yyval.sigspec) = (yyvsp[-1].sigspec);
	}
#line 1899 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 87:
#line 407 "ilang_parser.y" /* yacc.c:1663  */
    {
		(yyval.rsigspec)->push_back(*(yyvsp[0].sigspec));
		delete (yyvsp[0].sigspec);
	}
#line 1908 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 88:
#line 411 "ilang_parser.y" /* yacc.c:1663  */
    {
		(yyval.rsigspec) = new std::vector<RTLIL::SigSpec>;
	}
#line 1916 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 89:
#line 415 "ilang_parser.y" /* yacc.c:1663  */
    {
		(yyval.sigspec) = new RTLIL::SigSpec;
		for (auto it = (yyvsp[0].rsigspec)->rbegin(); it != (yyvsp[0].rsigspec)->rend(); it++)
			(yyval.sigspec)->append(*it);
		delete (yyvsp[0].rsigspec);
	}
#line 1927 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;

  case 90:
#line 423 "ilang_parser.y" /* yacc.c:1663  */
    {
		if (attrbuf.size() != 0)
			rtlil_frontend_ilang_yyerror("dangling attribute");
		current_module->connect(*(yyvsp[-2].sigspec), *(yyvsp[-1].sigspec));
		delete (yyvsp[-2].sigspec);
		delete (yyvsp[-1].sigspec);
	}
#line 1939 "../ilang_parser.tab.cc" /* yacc.c:1663  */
    break;


#line 1943 "../ilang_parser.tab.cc" /* yacc.c:1663  */
      default: break;
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
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
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

#if !defined yyoverflow || YYERROR_VERBOSE
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
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
