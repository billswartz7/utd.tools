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
#define yyparse         sdfparse
#define yylex           sdflex
#define yyerror         sdferror
#define yydebug         sdfdebug
#define yynerrs         sdfnerrs

#define yylval          sdflval
#define yychar          sdfchar
#define yylloc          sdflloc

/* Copy the first part of user declarations.  */
#line 2 "sdf_parse.y" /* yacc.c:339  */

/*
 * Copyright (c) 1998-2019 Stephen Williams (steve@icarus.com)
 *
 *    This source code is free software; you can redistribute it
 *    and/or modify it in source code form under the terms of the GNU
 *    General Public License as published by the Free Software
 *    Foundation; either version 2 of the License, or (at your option)
 *    any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */


#define YYERROR_VERBOSE
extern int sdflex(void);
static void yyerror(const char*msg);
# include  "vpi_user.h"
# include  "sdf_parse_priv.h"
# include  "sdf_priv.h"
# include  <stdio.h>
# include  <string.h>
# include  <stdlib.h>
# include  "ivl_alloc.h"

/* This is the hierarchy separator to use. */
char sdf_use_hchar = '.';


#line 112 "../sdf_parse.c" /* yacc.c:339  */

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
   by #include "sdf_parse.h".  */
#ifndef YY_SDF_SDF_PARSE_H_INCLUDED
# define YY_SDF_SDF_PARSE_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int sdfdebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    K_ABSOLUTE = 258,
    K_CELL = 259,
    K_CELLTYPE = 260,
    K_COND = 261,
    K_CONDELSE = 262,
    K_DATE = 263,
    K_DELAYFILE = 264,
    K_DELAY = 265,
    K_DESIGN = 266,
    K_DIVIDER = 267,
    K_HOLD = 268,
    K_INCREMENT = 269,
    K_INSTANCE = 270,
    K_INTERCONNECT = 271,
    K_IOPATH = 272,
    K_NEGEDGE = 273,
    K_PATHPULSE = 274,
    K_PATHPULSEPERCENT = 275,
    K_PERIOD = 276,
    K_POSEDGE = 277,
    K_PROCESS = 278,
    K_PROGRAM = 279,
    K_RECREM = 280,
    K_RECOVERY = 281,
    K_REMOVAL = 282,
    K_SDFVERSION = 283,
    K_SETUP = 284,
    K_SETUPHOLD = 285,
    K_TEMPERATURE = 286,
    K_TIMESCALE = 287,
    K_TIMINGCHECK = 288,
    K_VENDOR = 289,
    K_VERSION = 290,
    K_VOLTAGE = 291,
    K_WIDTH = 292,
    K_01 = 293,
    K_10 = 294,
    K_0Z = 295,
    K_Z1 = 296,
    K_1Z = 297,
    K_Z0 = 298,
    K_EQ = 299,
    K_NE = 300,
    K_CEQ = 301,
    K_CNE = 302,
    K_LOGICAL_ONE = 303,
    K_LOGICAL_ZERO = 304,
    K_LAND = 305,
    K_LOR = 306,
    HCHAR = 307,
    QSTRING = 308,
    IDENTIFIER = 309,
    REAL_NUMBER = 310,
    INTEGER = 311
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 39 "sdf_parse.y" /* yacc.c:355  */

      unsigned long int_val;
      double real_val;
      char*  string_val;

      struct sdf_delay_s delay;
      struct port_with_edge_s port_with_edge;
      struct sdf_delval_list_s delval_list;

#line 219 "../sdf_parse.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE sdflval;
extern YYLTYPE sdflloc;
int sdfparse (void);

#endif /* !YY_SDF_SDF_PARSE_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 250 "../sdf_parse.c" /* yacc.c:358  */

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
         || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
             && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE) + sizeof (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

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
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   374

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  69
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  54
/* YYNRULES -- Number of rules.  */
#define YYNRULES  151
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  329

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   311

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    63,     2,     2,     2,     2,     2,     2,
      57,    58,    61,    67,     2,    68,    59,    60,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    66,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    64,     2,    65,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,    62,     2,     2,     2,
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
      55,    56
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    85,    85,    86,    93,    94,    98,    99,   100,   101,
     102,   103,   104,   105,   106,   107,   108,   112,   118,   126,
     134,   142,   150,   158,   159,   160,   164,   165,   169,   177,
     178,   182,   187,   195,   196,   201,   200,   207,   213,   218,
     220,   222,   224,   230,   232,   236,   237,   240,   241,   247,
     248,   252,   253,   254,   255,   256,   262,   263,   267,   272,
     275,   283,   292,   295,   302,   306,   313,   319,   320,   325,
     326,   327,   328,   329,   330,   331,   332,   336,   339,   342,
     344,   351,   351,   355,   356,   357,   358,   359,   360,   361,
     362,   363,   367,   369,   371,   373,   379,   381,   382,   383,
     384,   385,   386,   387,   388,   392,   393,   394,   395,   399,
     400,   404,   405,   409,   413,   414,   418,   422,   429,   431,
     436,   436,   436,   441,   442,   443,   444,   445,   446,   447,
     448,   452,   463,   470,   472,   477,   486,   489,   493,   496,
     498,   504,   506,   517,   539,   542,   549,   550,   551,   552,
     553,   554
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "K_ABSOLUTE", "K_CELL", "K_CELLTYPE",
  "K_COND", "K_CONDELSE", "K_DATE", "K_DELAYFILE", "K_DELAY", "K_DESIGN",
  "K_DIVIDER", "K_HOLD", "K_INCREMENT", "K_INSTANCE", "K_INTERCONNECT",
  "K_IOPATH", "K_NEGEDGE", "K_PATHPULSE", "K_PATHPULSEPERCENT", "K_PERIOD",
  "K_POSEDGE", "K_PROCESS", "K_PROGRAM", "K_RECREM", "K_RECOVERY",
  "K_REMOVAL", "K_SDFVERSION", "K_SETUP", "K_SETUPHOLD", "K_TEMPERATURE",
  "K_TIMESCALE", "K_TIMINGCHECK", "K_VENDOR", "K_VERSION", "K_VOLTAGE",
  "K_WIDTH", "K_01", "K_10", "K_0Z", "K_Z1", "K_1Z", "K_Z0", "K_EQ",
  "K_NE", "K_CEQ", "K_CNE", "K_LOGICAL_ONE", "K_LOGICAL_ZERO", "K_LAND",
  "K_LOR", "HCHAR", "QSTRING", "IDENTIFIER", "REAL_NUMBER", "INTEGER",
  "'('", "')'", "'.'", "'/'", "'*'", "'~'", "'!'", "'['", "']'", "':'",
  "'+'", "'-'", "$accept", "source_file", "sdf_header_list",
  "sdf_header_item", "sdfversion", "design_name", "date", "vendor",
  "program_name", "program_version", "hierarchy_divider", "voltage",
  "process", "temperature", "time_scale", "cell_list", "cell", "$@1",
  "celltype", "cell_instance", "timing_spec_list_opt", "timing_spec",
  "deltype_list", "deltype", "del_def_list", "del_def", "tchk_def_list",
  "tchk_def", "port_tchk", "cond_edge_start", "$@2",
  "cond_edge_identifier", "timing_check_condition",
  "conditional_port_expr", "equality_operator", "scalar_constant",
  "input_output_path_opt", "input_output_path", "port_spec",
  "port_instance", "port", "port_interconnect", "port_edge", "$@3", "$@4",
  "edge_identifier", "delval_list", "delval", "rvalue_opt", "rvalue",
  "hierarchical_identifier", "rtriple", "signed_real_number_opt",
  "signed_real_number", YY_NULLPTR
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
     305,   306,   307,   308,   309,   310,   311,    40,    41,    46,
      47,    42,   126,    33,    91,    93,    58,    43,    45
};
# endif

#define YYPACT_NINF -255

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-255)))

#define YYTABLE_NINF -118

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     -30,    35,    52,     9,  -255,    -1,   193,    44,  -255,  -255,
    -255,  -255,  -255,  -255,  -255,  -255,  -255,  -255,  -255,  -255,
    -255,     6,    26,    31,    54,    58,    79,   164,    29,    85,
     103,   164,   137,  -255,    48,  -255,   101,   106,   108,   112,
     116,   118,   142,   148,  -255,  -255,    99,   124,   165,   129,
     168,   181,   183,   172,   189,   201,   215,    16,   247,  -255,
    -255,  -255,  -255,  -255,  -255,  -255,  -255,  -255,  -255,  -255,
    -255,  -255,  -255,  -255,   164,  -255,   260,   261,  -255,  -255,
    -255,  -255,   263,   276,   265,   254,  -255,  -255,  -255,  -255,
     270,   309,  -255,   164,   267,     2,  -255,  -255,  -255,   268,
    -255,  -255,   269,   -32,   151,  -255,  -255,   274,  -255,    22,
    -255,  -255,  -255,    18,    21,   271,   123,   176,  -255,   272,
     223,   199,  -255,  -255,   273,   275,   275,   279,   279,  -255,
    -255,  -255,    82,    82,    82,    82,    82,    82,    82,    82,
    -255,  -255,  -255,   146,   208,  -255,   226,   277,  -255,   279,
    -255,   283,   277,  -255,    82,   192,  -255,   277,    82,    82,
      82,    82,    82,   277,    60,    24,    10,    20,  -255,  -255,
    -255,   126,   277,  -255,   277,    80,   277,    71,   279,   279,
      93,   278,   258,   -22,   280,   277,   277,   277,   277,   277,
     281,   282,  -255,  -255,   237,   237,   217,  -255,  -255,   284,
     320,   285,   279,   -36,   286,  -255,   279,  -255,  -255,  -255,
     287,   288,   289,  -255,   290,  -255,  -255,  -255,  -255,  -255,
    -255,  -255,  -255,  -255,  -255,   291,    93,  -255,  -255,   292,
    -255,  -255,  -255,  -255,  -255,   239,   295,  -255,   277,   294,
     296,   297,   277,  -255,  -255,   225,   152,   237,   237,   237,
     237,   237,   237,   324,  -255,    93,  -255,   299,  -255,   200,
     299,  -255,  -255,  -255,  -255,  -255,   300,  -255,  -255,   298,
     301,  -255,  -255,  -255,   302,   336,  -255,  -255,  -255,  -255,
    -255,   262,   251,    93,   279,   222,   235,  -255,  -255,  -255,
    -255,  -255,  -255,  -255,  -255,  -255,  -255,  -255,   242,  -255,
    -255,  -255,  -255,    93,   279,   299,   277,  -255,  -255,   279,
    -255,   279,   299,   253,   255,   303,   299,   257,   304,  -255,
     306,  -255,   259,   307,  -255,  -255,   308,  -255,  -255
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     1,     0,     0,     0,     5,     6,
       7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
       3,     0,     0,     0,     0,     0,     0,   144,     0,     0,
       0,   144,     0,     4,     0,    34,     0,     0,     0,     0,
       0,     0,     0,     0,   146,   149,     0,     0,     0,     0,
     145,     0,     0,     0,     0,     0,   145,     0,     0,     2,
      33,    19,    18,    25,    23,    24,    28,    21,    17,   147,
     150,   148,   151,    29,   144,    30,     0,     0,    20,    22,
      26,    27,     0,     0,     0,     0,   145,    31,    32,    37,
       0,     0,    35,   144,     0,     0,    43,   143,    38,     0,
     141,    40,     0,     0,     0,    42,    41,     0,    39,     0,
      36,    44,   142,     0,     0,     0,     0,     0,    50,     0,
       0,     0,    68,    46,     0,     0,     0,   112,   112,    45,
      49,    48,     0,     0,     0,     0,     0,     0,     0,     0,
      47,    67,    55,     0,     0,    57,     0,     0,   111,     0,
     116,   117,     0,    81,     0,     0,    77,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    53,    56,
      54,   144,   136,   113,   136,     0,     0,     0,     0,     0,
       0,     0,    92,   118,     0,     0,     0,     0,     0,     0,
       0,     0,   109,   110,     0,     0,     0,    97,    96,     0,
       0,     0,     0,   118,     0,   120,     0,   114,   115,   140,
       0,   145,     0,   137,     0,    91,    84,    83,    85,    86,
      87,    88,    89,    90,    82,     0,     0,    93,    94,     0,
      78,   105,   106,   107,   108,     0,     0,    76,     0,     0,
       0,     0,     0,    75,    62,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    64,     0,    66,     0,    59,     0,
       0,   139,   138,    51,    52,    70,     0,    79,    95,     0,
       0,    72,    74,    69,     0,     0,    98,   101,   102,   103,
     104,    99,   100,     0,     0,   144,     0,   132,   133,   124,
     123,   125,   126,   127,   128,   129,   130,   121,     0,    80,
     119,    73,    71,     0,     0,     0,     0,    65,   131,     0,
      58,     0,     0,     0,     0,     0,     0,     0,     0,   134,
       0,   122,     0,     0,    63,   135,     0,    60,    61
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -255,  -255,  -255,   350,  -255,  -255,  -255,  -255,  -255,  -255,
    -255,  -255,  -255,  -255,  -255,  -255,   333,  -255,  -255,  -255,
    -255,  -255,  -255,   252,   244,  -101,  -255,   250,    53,  -255,
    -255,  -255,   191,  -180,  -255,   138,   246,  -255,  -173,  -126,
    -155,   -51,  -255,  -255,  -255,  -255,  -254,  -182,   198,  -139,
     -90,     7,   -62,   -27
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     2,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    34,    35,    96,    84,    92,
     104,   111,   117,   118,   144,   145,   121,   122,   154,   155,
     175,   224,   180,   196,   235,   197,   147,   148,   206,   156,
     150,   182,   208,   259,   309,   297,   286,   287,   212,   288,
     151,   210,    49,    86
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      50,   149,   149,    99,    56,   103,   298,   229,   172,   198,
       5,   201,    85,   174,   245,   246,   107,    82,   184,   115,
     107,   204,   119,   173,   190,   199,   108,     1,   236,   181,
     107,    97,   113,   213,    48,   213,  -117,   225,    55,   198,
     198,   207,   236,   169,     3,   169,   238,   239,   240,   241,
     242,   313,     4,   266,   207,   114,   100,    20,   317,    36,
     101,   191,   322,   102,   100,   183,     6,   277,   278,   279,
     280,   281,   282,    83,   100,   116,   203,   205,   120,    37,
     260,   200,   284,    38,    51,    52,   215,   203,   203,   203,
      39,    40,   198,   198,   198,   198,   198,   198,   216,   270,
     207,    32,   217,   274,   308,    58,    59,    41,   192,   193,
     304,    42,   203,   194,   100,   202,   308,   195,   218,   219,
     220,   221,   222,   223,   124,   100,   125,   227,   228,   207,
     311,   308,    43,   178,   179,   308,   100,   126,    53,   153,
     308,    57,   127,   128,   211,    21,   306,   100,    22,    23,
     205,   257,   164,   165,    69,    70,    54,   207,   305,    61,
      24,    25,   166,   167,    62,    26,    63,   314,    27,    28,
      64,    29,    30,    31,    65,   320,    66,   207,   312,    71,
      72,    44,    45,   315,   209,   316,   157,   158,   159,   160,
     161,   162,   163,    46,    47,    74,   247,   248,   249,   250,
      67,    21,   251,   252,    22,    23,    68,   176,   109,   110,
     276,   185,   186,   187,   188,   189,    24,    25,   289,    44,
      45,    26,   290,    73,    27,    28,    75,    29,    30,    31,
      78,    46,    47,   116,   129,    76,   132,    77,   291,   292,
     293,   294,   295,   296,   133,   177,   100,    79,   134,   135,
     136,    57,   137,   138,   178,   179,   120,   140,   211,    80,
     139,   247,   248,   249,   250,   143,   168,   251,   252,   247,
     248,   249,   250,    81,   253,   251,   252,    44,    45,   171,
     209,    90,   275,   143,   170,   192,   193,   192,   193,    46,
      47,   100,   285,   307,   195,   247,   248,   249,   250,   285,
     310,   251,   231,   232,   233,   234,   247,   248,   249,   250,
     285,   318,   171,   319,   285,   323,   285,   326,    87,    88,
      93,    89,    91,    94,    95,    98,   105,   106,   112,   123,
     131,   142,   143,   100,   171,   107,   230,   255,   237,   243,
     244,   283,   254,   256,   258,   261,   262,   263,   264,   265,
     267,   269,   271,   303,   272,   273,   285,    33,   299,   301,
     302,   321,   324,   300,   325,   327,   328,    60,   226,   130,
     146,   141,   214,   268,   152
};

static const yytype_uint16 yycheck[] =
{
      27,   127,   128,     1,    31,    95,   260,   180,   147,   164,
       1,     1,    74,   152,   194,   195,    52,     1,   157,     1,
      52,     1,     1,   149,   163,     1,    58,    57,    64,   155,
      52,    93,    10,   172,    27,   174,    58,   176,    31,   194,
     195,   167,    64,   144,     9,   146,   185,   186,   187,   188,
     189,   305,     0,   226,   180,    33,    54,    58,   312,    53,
      58,     1,   316,    61,    54,   155,    57,   247,   248,   249,
     250,   251,   252,    57,    54,    57,   166,    57,    57,    53,
     206,    57,   255,    52,    55,    56,     6,   177,   178,   179,
      59,    60,   247,   248,   249,   250,   251,   252,    18,   238,
     226,    57,    22,   242,   286,    57,    58,    53,    48,    49,
     283,    53,   202,    53,    54,   166,   298,    57,    38,    39,
      40,    41,    42,    43,     1,    54,     3,   178,   179,   255,
     303,   313,    53,    62,    63,   317,    54,    14,    53,    57,
     322,     4,    19,    20,   171,     8,   285,    54,    11,    12,
      57,   202,     6,     7,    55,    56,    53,   283,   284,    58,
      23,    24,    16,    17,    58,    28,    58,   306,    31,    32,
      58,    34,    35,    36,    58,   314,    58,   303,   304,    55,
      56,    55,    56,   309,    58,   311,   133,   134,   135,   136,
     137,   138,   139,    67,    68,    66,    44,    45,    46,    47,
      58,     8,    50,    51,    11,    12,    58,   154,    57,    58,
      58,   158,   159,   160,   161,   162,    23,    24,    18,    55,
      56,    28,    22,    58,    31,    32,    58,    34,    35,    36,
      58,    67,    68,    57,    58,    54,    13,    54,    38,    39,
      40,    41,    42,    43,    21,    53,    54,    58,    25,    26,
      27,     4,    29,    30,    62,    63,    57,    58,   285,    58,
      37,    44,    45,    46,    47,    57,    58,    50,    51,    44,
      45,    46,    47,    58,    57,    50,    51,    55,    56,    57,
      58,     5,    57,    57,    58,    48,    49,    48,    49,    67,
      68,    54,    57,    58,    57,    44,    45,    46,    47,    57,
      58,    50,    44,    45,    46,    47,    44,    45,    46,    47,
      57,    58,    57,    58,    57,    58,    57,    58,    58,    58,
      66,    58,    57,    53,    15,    58,    58,    58,    54,    58,
      58,    58,    57,    54,    57,    52,    58,    17,    58,    58,
      58,    17,    58,    58,    58,    58,    58,    58,    58,    58,
      58,    56,    58,    17,    58,    58,    57,     7,    58,    58,
      58,    58,    58,    65,    58,    58,    58,    34,   177,   117,
     126,   121,   174,   235,   128
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    57,    70,     9,     0,     1,    57,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      58,     8,    11,    12,    23,    24,    28,    31,    32,    34,
      35,    36,    57,    72,    84,    85,    53,    53,    52,    59,
      60,    53,    53,    53,    55,    56,    67,    68,   120,   121,
     122,    55,    56,    53,    53,   120,   122,     4,    57,    58,
      85,    58,    58,    58,    58,    58,    58,    58,    58,    55,
      56,    55,    56,    58,    66,    58,    54,    54,    58,    58,
      58,    58,     1,    57,    87,   121,   122,    58,    58,    58,
       5,    57,    88,    66,    53,    15,    86,   121,    58,     1,
      54,    58,    61,   119,    89,    58,    58,    52,    58,    57,
      58,    90,    54,    10,    33,     1,    57,    91,    92,     1,
      57,    95,    96,    58,     1,     3,    14,    19,    20,    58,
      92,    58,    13,    21,    25,    26,    27,    29,    30,    37,
      58,    96,    58,    57,    93,    94,    93,   105,   106,   108,
     109,   119,   105,    57,    97,    98,   108,    97,    97,    97,
      97,    97,    97,    97,     6,     7,    16,    17,    58,    94,
      58,    57,   118,   108,   118,    99,    97,    53,    62,    63,
     101,   108,   110,   119,   118,    97,    97,    97,    97,    97,
     118,     1,    48,    49,    53,    57,   102,   104,   109,     1,
      57,     1,   110,   119,     1,    57,   107,   108,   111,    58,
     120,   122,   117,   118,   117,     6,    18,    22,    38,    39,
      40,    41,    42,    43,   100,   118,   101,   110,   110,   107,
      58,    44,    45,    46,    47,   103,    64,    58,   118,   118,
     118,   118,   118,    58,    58,   102,   102,    44,    45,    46,
      47,    50,    51,    57,    58,    17,    58,   110,    58,   112,
     108,    58,    58,    58,    58,    58,   107,    58,   104,    56,
     118,    58,    58,    58,   118,    57,    58,   102,   102,   102,
     102,   102,   102,    17,   107,    57,   115,   116,   118,    18,
      22,    38,    39,    40,    41,    42,    43,   114,   115,    58,
      65,    58,    58,    17,   107,   108,   118,    58,   116,   113,
      58,   107,   108,   115,   118,   108,   108,   115,    58,    58,
     118,    58,   115,    58,    58,    58,    58,    58,    58
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    69,    70,    70,    71,    71,    72,    72,    72,    72,
      72,    72,    72,    72,    72,    72,    72,    73,    74,    75,
      76,    77,    78,    79,    79,    79,    80,    80,    81,    82,
      82,    83,    83,    84,    84,    86,    85,    85,    87,    88,
      88,    88,    88,    89,    89,    90,    90,    90,    90,    91,
      91,    92,    92,    92,    92,    92,    93,    93,    94,    94,
      94,    94,    94,    94,    94,    94,    94,    95,    95,    96,
      96,    96,    96,    96,    96,    96,    96,    97,    97,    97,
      97,    99,    98,   100,   100,   100,   100,   100,   100,   100,
     100,   100,   101,   101,   101,   101,   102,   102,   102,   102,
     102,   102,   102,   102,   102,   103,   103,   103,   103,   104,
     104,   105,   105,   106,   107,   107,   108,   109,   110,   110,
     112,   113,   111,   114,   114,   114,   114,   114,   114,   114,
     114,   115,   115,   116,   116,   116,   117,   117,   118,   118,
     118,   119,   119,   120,   121,   121,   122,   122,   122,   122,
     122,   122
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     5,     4,     2,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     5,     5,     2,     1,     0,     7,     4,     4,     4,
       3,     4,     4,     0,     2,     4,     4,     4,     4,     2,
       1,     6,     6,     4,     4,     3,     2,     1,     6,     4,
      10,    11,     4,     9,     4,     6,     4,     2,     1,     6,
       6,     7,     6,     7,     6,     5,     5,     1,     3,     4,
       5,     0,     3,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     2,     2,     3,     1,     1,     3,     3,
       3,     3,     3,     3,     3,     1,     1,     1,     1,     1,
       1,     1,     0,     2,     1,     1,     1,     1,     1,     4,
       0,     0,     6,     1,     1,     1,     1,     1,     1,     1,
       1,     2,     1,     1,     4,     5,     0,     1,     3,     3,
       2,     1,     3,     5,     0,     1,     1,     2,     2,     1,
       2,     2
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


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)                                \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;        \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;      \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;         \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;       \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).first_line   = (Current).last_line   =              \
            YYRHSLOC (Rhs, 0).last_line;                                \
          (Current).first_column = (Current).last_column =              \
            YYRHSLOC (Rhs, 0).last_column;                              \
        }                                                               \
    while (0)
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K])


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


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL

/* Print *YYLOCP on YYO.  Private, do not rely on its existence. */

YY_ATTRIBUTE_UNUSED
static unsigned
yy_location_print_ (FILE *yyo, YYLTYPE const * const yylocp)
{
  unsigned res = 0;
  int end_col = 0 != yylocp->last_column ? yylocp->last_column - 1 : 0;
  if (0 <= yylocp->first_line)
    {
      res += YYFPRINTF (yyo, "%d", yylocp->first_line);
      if (0 <= yylocp->first_column)
        res += YYFPRINTF (yyo, ".%d", yylocp->first_column);
    }
  if (0 <= yylocp->last_line)
    {
      if (yylocp->first_line < yylocp->last_line)
        {
          res += YYFPRINTF (yyo, "-%d", yylocp->last_line);
          if (0 <= end_col)
            res += YYFPRINTF (yyo, ".%d", end_col);
        }
      else if (0 <= end_col && yylocp->first_column < end_col)
        res += YYFPRINTF (yyo, "-%d", end_col);
    }
  return res;
 }

#  define YY_LOCATION_PRINT(File, Loc)          \
  yy_location_print_ (File, &(Loc))

# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value, Location); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  YYUSE (yylocationp);
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
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp);
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
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule)
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
                       , &(yylsp[(yyi + 1) - (yynrhs)])                       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, yylsp, Rule); \
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
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);
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
/* Location data for the lookahead symbol.  */
YYLTYPE yylloc
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
  = { 1, 1, 1, 1 }
# endif
;
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
       'yyls': related to locations.

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

    /* The location stack.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls;
    YYLTYPE *yylsp;

    /* The locations where the error started and ended.  */
    YYLTYPE yyerror_range[3];

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yylsp = yyls = yylsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  yylsp[0] = yylloc;
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
        YYLTYPE *yyls1 = yyls;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yyls1, yysize * sizeof (*yylsp),
                    &yystacksize);

        yyls = yyls1;
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
        YYSTACK_RELOCATE (yyls_alloc, yyls);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

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
  *++yylsp = yylloc;
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

  /* Default location. */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  yyerror_range[1] = yyloc;
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 3:
#line 87 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d:SDF ERROR: Invalid DELAYFILE format\n",
		   sdf_parse_path, (yylsp[-2]).first_line);
      }
#line 1674 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 17:
#line 113 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[-1].string_val));
    }
#line 1681 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 18:
#line 119 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_inform) vpi_printf("%s:%d:SDF INFO: Design: %s\n",
					sdf_parse_path, (yylsp[-2]).first_line, (yyvsp[-1].string_val));
        free((yyvsp[-1].string_val));
      }
#line 1690 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 19:
#line 127 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_inform) vpi_printf("%s:%d:SDF INFO: Date: %s\n",
					sdf_parse_path, (yylsp[-2]).first_line, (yyvsp[-1].string_val));
        free((yyvsp[-1].string_val));
      }
#line 1699 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 20:
#line 135 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_inform) vpi_printf("%s:%d:SDF INFO: Vendor: %s\n",
					sdf_parse_path, (yylsp[-2]).first_line, (yyvsp[-1].string_val));
        free((yyvsp[-1].string_val));
      }
#line 1708 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 21:
#line 143 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_inform) vpi_printf("%s:%d:SDF INFO: Program: %s\n",
					sdf_parse_path, (yylsp[-2]).first_line, (yyvsp[-1].string_val));
        free((yyvsp[-1].string_val));
      }
#line 1717 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 22:
#line 151 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_inform) vpi_printf("%s:%d:SDF INFO: Program Version: %s\n",
					sdf_parse_path, (yylsp[-2]).first_line, (yyvsp[-1].string_val));
	free((yyvsp[-1].string_val));
      }
#line 1726 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 23:
#line 158 "sdf_parse.y" /* yacc.c:1663  */
    { sdf_use_hchar = '.'; }
#line 1732 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 24:
#line 159 "sdf_parse.y" /* yacc.c:1663  */
    { sdf_use_hchar = '/'; }
#line 1738 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 25:
#line 160 "sdf_parse.y" /* yacc.c:1663  */
    { /* sdf_use_hchar no-change */; }
#line 1744 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 28:
#line 170 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_inform) vpi_printf("%s:%d:SDF INFO: Process: %s\n",
					sdf_parse_path, (yylsp[-2]).first_line, (yyvsp[-1].string_val));
	free((yyvsp[-1].string_val));
      }
#line 1753 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 31:
#line 183 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_inform) vpi_printf("%s:%d:SDF INFO: TIMESCALE : %f%s\n",
					sdf_parse_path, (yylsp[-3]).first_line, (yyvsp[-2].real_val), (yyvsp[-1].string_val));
	free((yyvsp[-1].string_val));
      }
#line 1762 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 32:
#line 188 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_inform) vpi_printf("%s:%d:SDF INFO: TIMESCALE : %lu%s\n",
					sdf_parse_path, (yylsp[-3]).first_line, (yyvsp[-2].int_val), (yyvsp[-1].string_val));
	free((yyvsp[-1].string_val));
      }
#line 1771 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 35:
#line 201 "sdf_parse.y" /* yacc.c:1663  */
    { sdf_select_instance((yyvsp[-1].string_val), (yyvsp[0].string_val)); /* find the instance in the design */}
#line 1777 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 36:
#line 204 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[-4].string_val));
	if ((yyvsp[-3].string_val)) free((yyvsp[-3].string_val));
      }
#line 1785 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 37:
#line 208 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d: Syntax error in CELL\n",
		   sdf_parse_path, (yylsp[-2]).first_line); }
#line 1792 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 38:
#line 214 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.string_val) = (yyvsp[-1].string_val); }
#line 1798 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 39:
#line 219 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.string_val) = (yyvsp[-1].string_val); }
#line 1804 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 40:
#line 221 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.string_val) = strdup(""); }
#line 1810 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 41:
#line 223 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.string_val) = 0; }
#line 1816 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 42:
#line 225 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d:SDF ERROR: Invalid/malformed INSTANCE argument\n",
		   sdf_parse_path, (yylsp[-2]).first_line);
	    (yyval.string_val) = strdup(""); }
#line 1824 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 46:
#line 238 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d: Syntax error in CELL DELAY SPEC\n",
		   sdf_parse_path, (yylsp[-2]).first_line); }
#line 1831 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 48:
#line 242 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d: Syntax error in TIMINGCHECK SPEC\n",
		   sdf_parse_path, (yylsp[-2]).first_line); }
#line 1838 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 55:
#line 257 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d: SDF ERROR: Invalid/malformed delay type\n",
		 sdf_parse_path, (yylsp[-2]).first_line); }
#line 1845 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 58:
#line 268 "sdf_parse.y" /* yacc.c:1663  */
    { sdf_iopath_delays((yyvsp[-3].port_with_edge).vpi_edge, (yyvsp[-3].port_with_edge).string_val, (yyvsp[-2].string_val), &(yyvsp[-1].delval_list));
	free((yyvsp[-3].port_with_edge).string_val);
	free((yyvsp[-2].string_val));
      }
#line 1854 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 59:
#line 273 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d: SDF ERROR: Invalid/malformed IOPATH\n",
		   sdf_parse_path, (yylsp[-2]).first_line); }
#line 1861 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 60:
#line 277 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_warning) vpi_printf("%s:%d: SDF WARNING: "
					 "COND not supported.\n",
					 sdf_parse_path, (yylsp[-8]).first_line);
	free((yyvsp[-4].port_with_edge).string_val);
	free((yyvsp[-3].string_val));
      }
#line 1872 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 61:
#line 285 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_warning) vpi_printf("%s:%d: SDF WARNING: "
					 "COND not supported.\n",
					 sdf_parse_path, (yylsp[-9]).first_line);
	free((yyvsp[-8].string_val));
	free((yyvsp[-4].port_with_edge).string_val);
	free((yyvsp[-3].string_val));
      }
#line 1884 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 62:
#line 293 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d: SDF ERROR: Invalid/malformed COND\n",
		   sdf_parse_path, (yylsp[-2]).first_line); }
#line 1891 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 63:
#line 296 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_warning) vpi_printf("%s:%d: SDF WARNING: "
					 "CONDELSE not supported.\n",
					 sdf_parse_path, (yylsp[-7]).first_line);
	free((yyvsp[-4].port_with_edge).string_val);
	free((yyvsp[-3].string_val));
      }
#line 1902 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 64:
#line 303 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d: SDF ERROR: Invalid/malformed CONDELSE\n",
		   sdf_parse_path, (yylsp[-2]).first_line); }
#line 1909 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 65:
#line 307 "sdf_parse.y" /* yacc.c:1663  */
    { if (sdf_flag_warning) vpi_printf("%s:%d: SDF WARNING: "
					 "INTERCONNECT not supported.\n",
					 sdf_parse_path, (yylsp[-4]).first_line);
	free((yyvsp[-3].string_val));
	free((yyvsp[-2].string_val));
      }
#line 1920 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 66:
#line 314 "sdf_parse.y" /* yacc.c:1663  */
    { vpi_printf("%s:%d: SDF ERROR: Invalid/malformed INTERCONNECT\n",
		   sdf_parse_path, (yylsp[-2]).first_line); }
#line 1927 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 77:
#line 337 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[0].string_val)); }
#line 1933 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 78:
#line 340 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[-1].string_val)); }
#line 1939 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 79:
#line 343 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[-1].port_with_edge).string_val); }
#line 1945 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 80:
#line 345 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[-3].string_val));
	free((yyvsp[-1].port_with_edge).string_val);
      }
#line 1953 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 81:
#line 351 "sdf_parse.y" /* yacc.c:1663  */
    { start_edge_id(1); }
#line 1959 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 82:
#line 351 "sdf_parse.y" /* yacc.c:1663  */
    { stop_edge_id(); }
#line 1965 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 92:
#line 368 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[0].string_val)); }
#line 1971 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 93:
#line 370 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[0].string_val)); }
#line 1977 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 94:
#line 372 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[0].string_val)); }
#line 1983 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 95:
#line 374 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[-2].string_val)); }
#line 1989 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 96:
#line 380 "sdf_parse.y" /* yacc.c:1663  */
    { free((yyvsp[0].string_val)); }
#line 1995 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 114:
#line 413 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.port_with_edge).vpi_edge = vpiNoEdge; (yyval.port_with_edge).string_val = (yyvsp[0].string_val); }
#line 2001 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 115:
#line 414 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.port_with_edge) = (yyvsp[0].port_with_edge); }
#line 2007 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 116:
#line 418 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.string_val) = (yyvsp[0].string_val); }
#line 2013 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 117:
#line 423 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.string_val) = (yyvsp[0].string_val); }
#line 2019 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 118:
#line 430 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.string_val) = (yyvsp[0].string_val); }
#line 2025 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 119:
#line 432 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.string_val) = (yyvsp[-3].string_val);}
#line 2031 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 120:
#line 436 "sdf_parse.y" /* yacc.c:1663  */
    {start_edge_id(0);}
#line 2037 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 121:
#line 436 "sdf_parse.y" /* yacc.c:1663  */
    {stop_edge_id();}
#line 2043 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 122:
#line 437 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.port_with_edge).vpi_edge = (yyvsp[-3].int_val); (yyval.port_with_edge).string_val = (yyvsp[-1].string_val); }
#line 2049 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 123:
#line 441 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.int_val) = vpiPosedge; }
#line 2055 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 124:
#line 442 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.int_val) = vpiNegedge; }
#line 2061 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 125:
#line 443 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.int_val) = vpiEdge01; }
#line 2067 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 126:
#line 444 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.int_val) = vpiEdge10; }
#line 2073 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 127:
#line 445 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.int_val) = vpiEdge0x; }
#line 2079 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 128:
#line 446 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.int_val) = vpiEdgex1; }
#line 2085 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 129:
#line 447 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.int_val) = vpiEdge1x; }
#line 2091 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 130:
#line 448 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.int_val) = vpiEdgex0; }
#line 2097 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 131:
#line 453 "sdf_parse.y" /* yacc.c:1663  */
    { int idx;
	(yyval.delval_list).count = (yyvsp[-1].delval_list).count;
	for (idx = 0 ; idx < (yyval.delval_list).count ; idx += 1)
	      (yyval.delval_list).val[idx] = (yyvsp[-1].delval_list).val[idx];
// Is this correct?
	if ((yyval.delval_list).count < 12) {
	      (yyval.delval_list).val[(yyval.delval_list).count] = (yyvsp[0].delay);
	      (yyval.delval_list).count += 1;
	}
      }
#line 2112 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 132:
#line 464 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delval_list).count = 1;
	(yyval.delval_list).val[0] = (yyvsp[0].delay);
      }
#line 2120 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 133:
#line 471 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delay) = (yyvsp[0].delay); }
#line 2126 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 134:
#line 473 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delay) = (yyvsp[-2].delay);
	vpi_printf("%s:%d: SDF WARNING: Pulse rejection limits ignored\n",
		   sdf_parse_path, (yylsp[-1]).first_line);
      }
#line 2135 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 135:
#line 478 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delay) = (yyvsp[-3].delay);
	vpi_printf("%s:%d: SDF WARNING: Pulse rejection limits ignored\n",
		   sdf_parse_path, (yylsp[-2]).first_line);
      }
#line 2144 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 136:
#line 486 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delay).value = 0.0;
	(yyval.delay).defined = 0;
      }
#line 2152 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 138:
#line 494 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delay).defined = 1;
        (yyval.delay).value = (yyvsp[-1].real_val); }
#line 2159 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 139:
#line 497 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delay) = (yyvsp[-1].delay); }
#line 2165 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 140:
#line 499 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delay).defined = 0;
        (yyval.delay).value = 0.0; }
#line 2172 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 141:
#line 505 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.string_val) = (yyvsp[0].string_val); }
#line 2178 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 142:
#line 507 "sdf_parse.y" /* yacc.c:1663  */
    { int len = strlen((yyvsp[-2].string_val)) + strlen((yyvsp[0].string_val)) + 2;
	char*tmp = realloc((yyvsp[-2].string_val), len);
	strcat(tmp, ".");
	strcat(tmp, (yyvsp[0].string_val));
	free((yyvsp[0].string_val));
	(yyval.string_val) = tmp;
      }
#line 2190 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 143:
#line 518 "sdf_parse.y" /* yacc.c:1663  */
    { switch(sdf_min_typ_max) {
	    case _vpiDelaySelMinimum:
	       (yyval.delay) = (yyvsp[-4].delay);
	       break;
	    case _vpiDelaySelTypical:
	       (yyval.delay) = (yyvsp[-2].delay);
	       break;
	    case _vpiDelaySelMaximum:
	       (yyval.delay) = (yyvsp[0].delay);
	       break;
	}
	  /* At least one of the values must be defined. */
	if (! ((yyvsp[-4].delay).defined || (yyvsp[-2].delay).defined || (yyvsp[0].delay).defined)) {
	      vpi_printf("%s:%d: SDF ERROR: rtriple must have at least one "
	                 "defined value.\n", sdf_parse_path, (yylsp[-4]).first_line);
	}
      }
#line 2212 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 144:
#line 539 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delay).value = 0.0;
	(yyval.delay).defined = 0;
      }
#line 2220 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 145:
#line 543 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.delay).value = (yyvsp[0].real_val);
	(yyval.delay).defined = 1;
      }
#line 2228 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 146:
#line 549 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.real_val) = (yyvsp[0].real_val); }
#line 2234 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 147:
#line 550 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.real_val) = (yyvsp[0].real_val); }
#line 2240 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 148:
#line 551 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.real_val) = -(yyvsp[0].real_val); }
#line 2246 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 149:
#line 552 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.real_val) = (yyvsp[0].int_val); }
#line 2252 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 150:
#line 553 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.real_val) = (yyvsp[0].int_val); }
#line 2258 "../sdf_parse.c" /* yacc.c:1663  */
    break;

  case 151:
#line 554 "sdf_parse.y" /* yacc.c:1663  */
    { (yyval.real_val) = -(yyvsp[0].int_val); }
#line 2264 "../sdf_parse.c" /* yacc.c:1663  */
    break;


#line 2268 "../sdf_parse.c" /* yacc.c:1663  */
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
  *++yylsp = yyloc;

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

  yyerror_range[1] = yylloc;

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
                      yytoken, &yylval, &yylloc);
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

      yyerror_range[1] = *yylsp;
      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  yyerror_range[2] = yylloc;
  /* Using YYLLOC is tempting, but would change the location of
     the lookahead.  YYLOC is available though.  */
  YYLLOC_DEFAULT (yyloc, yyerror_range, 2);
  *++yylsp = yyloc;

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
                  yytoken, &yylval, &yylloc);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp, yylsp);
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
#line 557 "sdf_parse.y" /* yacc.c:1907  */


void yyerror(const char*msg)
{
      vpi_printf("%s:SDF ERROR: Too many errors: %s\n", sdf_parse_path, msg);
}
