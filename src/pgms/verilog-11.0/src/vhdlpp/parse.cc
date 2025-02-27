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
#define YYPURE 1

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 7 "parse.y" /* yacc.c:339  */

/*
 * Copyright (c) 2011-2013 Stephen Williams (steve@icarus.com)
 * Copyright CERN 2012-2016 / Stephen Williams (steve@icarus.com),
 * @author Maciej Suminski (maciej.suminski@cern.ch)
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
# include "vhdlpp_config.h"
# include "vhdlint.h"
# include "vhdlreal.h"
# include "compiler.h"
# include "parse_api.h"
# include "parse_misc.h"
# include "architec.h"
# include "expression.h"
# include "sequential.h"
# include "subprogram.h"
# include "package.h"
# include "vsignal.h"
# include "vtype.h"
# include "std_funcs.h"
# include "std_types.h"
# include  <cstdarg>
# include  <cstring>
# include  <list>
# include  <stack>
# include  <map>
# include  <vector>
# include  "parse_types.h"
# include  <ivl_assert.h>
# include  <assert.h>

inline void FILE_NAME(LineInfo*tmp, const struct yyltype&where)
{
      tmp->set_lineno(where.first_line);
      tmp->set_file(filename_strings.make(where.text));
}


/* Recent version of bison expect that the user supply a
   YYLLOC_DEFAULT macro that makes up a yylloc value from existing
   values. I need to supply an explicit version to account for the
   text field, that otherwise won't be copied. */
# define YYLLOC_DEFAULT(Current, Rhs, N)  do {       \
  (Current).first_line   = (Rhs)[1].first_line;      \
  (Current).text         = file_path; /*(Rhs)[1].text;*/   } while (0)

static void yyerror(YYLTYPE*yyllocp,yyscan_t yyscanner,const char*file_path,bool, const char*msg);

int parse_errors = 0;
int parse_sorrys = 0;

/*
 * The parser calls yylex to get the next lexical token. It is only
 * called by the bison-generated parser.
 */
extern int yylex(union YYSTYPE*yylvalp,YYLTYPE*yyllocp,yyscan_t yyscanner);


/*
 * Create an initial scope that collects all the global
 * declarations. Also save a stack of previous scopes, as a way to
 * manage lexical scopes.
 */
static ActiveScope*active_scope = new ActiveScope;
static stack<ActiveScope*> scope_stack;
static SubprogramHeader*active_sub = NULL;
static ActiveScope*arc_scope = NULL;

/*
 * When a scope boundary starts, call the push_scope function to push
 * a scope context. Preload this scope context with the contents of
 * the parent scope, then make this the current scope. When the scope
 * is done, the pop_scope function pops the scope off the stack and
 * resumes the scope that was the parent.
 */
static void push_scope(void)
{
      assert(active_scope);
      scope_stack.push(active_scope);
      active_scope = new ActiveScope (active_scope);
}

static void pop_scope(void)
{
      delete active_scope;
      assert(! scope_stack.empty());
      active_scope = scope_stack.top();
      scope_stack.pop();
}

static bool is_subprogram_param(perm_string name)
{
    if(!active_sub)
        return false;

    return (active_sub->find_param(name) != NULL);
}

void preload_global_types(void)
{
      generate_global_types(active_scope);
}

//Remove the scope created at the beginning of parser's work.
//After the parsing active_scope should keep it's address

static void delete_global_scope(void)
{
    active_scope->destroy_global_scope();
    delete active_scope;
}

//delete global entities that were gathered over the parsing process
static void delete_design_entities(void)
{
      for(map<perm_string,Entity*>::iterator cur = design_entities.begin()
      ; cur != design_entities.end(); ++cur)
        delete cur->second;
}

//clean the mess caused by the parser
void parser_cleanup(void)
{
    delete_design_entities();
    delete_global_scope();
    delete_std_funcs();
    lex_strings.cleanup();
}

const VType*parse_type_by_name(perm_string name)
{
      return active_scope->find_type(name);
}

// This function is called when an aggregate expression is detected by
// the parser. It makes the ExpAggregate. It also tries to detect the
// special case that the aggregate is really a primary. The problem is
// that this:
//   ( <expression> )
// also matches the pattern:
//   ( [ choices => ] <expression> ... )
// so try to assume that a single expression in parentheses is a
// primary and fix the parse by returning an Expression instead of an
// ExpAggregate.
static Expression*aggregate_or_primary(const YYLTYPE&loc, std::list<ExpAggregate::element_t*>*el)
{
      if (el->size() != 1) {
	    ExpAggregate*tmp = new ExpAggregate(el);
	    FILE_NAME(tmp,loc);
	    return tmp;
      }

      ExpAggregate::element_t*el1 = el->front();
      if (el1->count_choices() > 0) {
	    ExpAggregate*tmp = new ExpAggregate(el);
	    FILE_NAME(tmp,loc);
	    return tmp;
      }

      return el1->extract_expression();
}

static list<VTypeRecord::element_t*>* record_elements(list<perm_string>*names,
						      const VType*type)
{
      list<VTypeRecord::element_t*>*res = new list<VTypeRecord::element_t*>;

      for (list<perm_string>::iterator cur = names->begin()
		 ; cur != names->end() ; ++cur) {
	    res->push_back(new VTypeRecord::element_t(*cur, type));
      }

      return res;
}

static void touchup_interface_for_functions(std::list<InterfacePort*>*ports)
{
      for (list<InterfacePort*>::iterator cur = ports->begin()
		 ; cur != ports->end() ; ++cur) {
	    InterfacePort*curp = *cur;
	    if (curp->mode == PORT_NONE)
		  curp->mode = PORT_IN;
      }
}


#line 270 "../parse.cc" /* yacc.c:339  */

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
   by #include "parse.h".  */
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
    K_abs = 258,
    K_access = 259,
    K_after = 260,
    K_alias = 261,
    K_all = 262,
    K_and = 263,
    K_architecture = 264,
    K_array = 265,
    K_assert = 266,
    K_assume = 267,
    K_assume_guarantee = 268,
    K_attribute = 269,
    K_begin = 270,
    K_block = 271,
    K_body = 272,
    K_buffer = 273,
    K_bus = 274,
    K_case = 275,
    K_component = 276,
    K_configuration = 277,
    K_constant = 278,
    K_context = 279,
    K_cover = 280,
    K_default = 281,
    K_disconnect = 282,
    K_downto = 283,
    K_else = 284,
    K_elsif = 285,
    K_end = 286,
    K_entity = 287,
    K_exit = 288,
    K_fairness = 289,
    K_file = 290,
    K_for = 291,
    K_force = 292,
    K_function = 293,
    K_generate = 294,
    K_generic = 295,
    K_group = 296,
    K_guarded = 297,
    K_if = 298,
    K_impure = 299,
    K_in = 300,
    K_inertial = 301,
    K_inout = 302,
    K_is = 303,
    K_label = 304,
    K_library = 305,
    K_linkage = 306,
    K_literal = 307,
    K_loop = 308,
    K_map = 309,
    K_mod = 310,
    K_nand = 311,
    K_new = 312,
    K_next = 313,
    K_nor = 314,
    K_not = 315,
    K_null = 316,
    K_of = 317,
    K_on = 318,
    K_open = 319,
    K_or = 320,
    K_others = 321,
    K_out = 322,
    K_package = 323,
    K_parameter = 324,
    K_port = 325,
    K_postponed = 326,
    K_procedure = 327,
    K_process = 328,
    K_property = 329,
    K_protected = 330,
    K_pure = 331,
    K_range = 332,
    K_record = 333,
    K_register = 334,
    K_reject = 335,
    K_release = 336,
    K_rem = 337,
    K_report = 338,
    K_restrict = 339,
    K_restrict_guarantee = 340,
    K_return = 341,
    K_reverse_range = 342,
    K_rol = 343,
    K_ror = 344,
    K_select = 345,
    K_sequence = 346,
    K_severity = 347,
    K_signal = 348,
    K_shared = 349,
    K_sla = 350,
    K_sll = 351,
    K_sra = 352,
    K_srl = 353,
    K_strong = 354,
    K_subtype = 355,
    K_then = 356,
    K_to = 357,
    K_transport = 358,
    K_type = 359,
    K_unaffected = 360,
    K_units = 361,
    K_until = 362,
    K_use = 363,
    K_variable = 364,
    K_vmode = 365,
    K_vprop = 366,
    K_vunit = 367,
    K_wait = 368,
    K_when = 369,
    K_while = 370,
    K_with = 371,
    K_xnor = 372,
    K_xor = 373,
    IDENTIFIER = 374,
    INT_LITERAL = 375,
    REAL_LITERAL = 376,
    STRING_LITERAL = 377,
    CHARACTER_LITERAL = 378,
    BITSTRING_LITERAL = 379,
    LEQ = 380,
    GEQ = 381,
    VASSIGN = 382,
    NE = 383,
    BOX = 384,
    EXP = 385,
    ARROW = 386,
    DLT = 387,
    DGT = 388,
    CC = 389,
    M_EQ = 390,
    M_NE = 391,
    M_LT = 392,
    M_LEQ = 393,
    M_GT = 394,
    M_GEQ = 395
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 212 "parse.y" /* yacc.c:355  */

      port_mode_t port_mode;

      char*text;

      std::list<perm_string>* name_list;

      bool flag;
      int64_t uni_integer;
      double  uni_real;

      Expression*expr;
      std::list<Expression*>* expr_list;

      SequentialStmt* sequ;
      std::list<SequentialStmt*>*sequ_list;

      IfSequential::Elsif*elsif;
      std::list<IfSequential::Elsif*>*elsif_list;

      ExpConditional::case_t*exp_options;
      std::list<ExpConditional::case_t*>*exp_options_list;

      CaseSeqStmt::CaseStmtAlternative* case_alt;
      std::list<CaseSeqStmt::CaseStmtAlternative*>* case_alt_list;

      named_expr_t*named_expr;
      std::list<named_expr_t*>*named_expr_list;
      entity_aspect_t* entity_aspect;
      instant_list_t* instantiation_list;
      std::pair<instant_list_t*, ExpName*>* component_specification;

      const VType* vtype;

      ExpRange*range;
      std::list<ExpRange*>*range_list;
      ExpRange::range_dir_t range_dir;

      ExpArithmetic::fun_t arithmetic_op;
      std::list<struct adding_term>*adding_terms;

      ExpAggregate::choice_t*choice;
      std::list<ExpAggregate::choice_t*>*choice_list;
      ExpAggregate::element_t*element;
      std::list<ExpAggregate::element_t*>*element_list;

      std::list<VTypeRecord::element_t*>*record_elements;

      std::list<InterfacePort*>* interface_list;

      Architecture::Statement* arch_statement;
      std::list<Architecture::Statement*>* arch_statement_list;

      ReportStmt::severity_t severity;

      SubprogramHeader*subprogram;

      file_open_info_t*file_info;

#line 511 "../parse.cc" /* yacc.c:355  */
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



int yyparse (yyscan_t yyscanner, const char*file_path, perm_string parse_library_name);

#endif /* !YY_YY_PARSE_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 541 "../parse.cc" /* yacc.c:358  */

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
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1347

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  157
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  197
/* YYNRULES -- Number of rules.  */
#define YYNRULES  449
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  884

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   395

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   143,   150,
     145,   146,   155,   141,   147,   142,   154,   156,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   148,   144,
     152,   151,   153,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,   149,     2,     2,     2,     2,     2,
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
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   127,   128,   129,   130,   131,   132,   133,   134,
     135,   136,   137,   138,   139,   140
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   393,   393,   393,   396,   397,   398,   404,   402,   424,
     436,   441,   447,   454,   457,   458,   462,   470,   478,   483,
     488,   496,   501,   509,   519,   520,   524,   532,   533,   537,
     549,   551,   553,   555,   557,   559,   561,   565,   567,   578,
     579,   583,   584,   588,   599,   604,   619,   657,   659,   661,
     666,   671,   679,   688,   696,   715,   724,   725,   729,   740,
     749,   759,   766,   776,   781,   801,   817,   833,   844,   849,
     857,   858,   863,   868,   876,   878,   883,   885,   890,   892,
     894,   900,   909,   910,   911,   912,   913,   917,   927,   935,
     939,   940,   944,   945,   949,   950,   954,   955,   959,   960,
     964,   972,   979,   989,   994,  1001,  1001,  1004,  1005,  1009,
    1010,  1015,  1016,  1020,  1021,  1025,  1026,  1030,  1035,  1042,
    1047,  1055,  1062,  1067,  1073,  1079,  1085,  1093,  1094,  1098,
    1115,  1123,  1132,  1141,  1148,  1153,  1161,  1163,  1191,  1192,
    1197,  1202,  1207,  1212,  1217,  1225,  1227,  1235,  1237,  1245,
    1247,  1255,  1257,  1265,  1267,  1272,  1277,  1285,  1322,  1329,
    1336,  1342,  1343,  1347,  1368,  1382,  1383,  1387,  1391,  1394,
    1398,  1400,  1408,  1409,  1413,  1415,  1423,  1429,  1437,  1437,
    1439,  1439,  1446,  1465,  1476,  1485,  1491,  1499,  1500,  1504,
    1509,  1517,  1523,  1531,  1533,  1539,  1543,  1545,  1554,  1558,
    1559,  1563,  1568,  1573,  1582,  1600,  1601,  1605,  1611,  1618,
    1622,  1629,  1630,  1633,  1636,  1642,  1651,  1669,  1688,  1706,
    1707,  1708,  1711,  1711,  1714,  1731,  1734,  1737,  1751,  1762,
    1772,  1777,  1785,  1803,  1811,  1820,  1821,  1825,  1826,  1829,
    1830,  1834,  1835,  1836,  1837,  1838,  1839,  1840,  1847,  1848,
    1852,  1853,  1857,  1868,  1880,  1894,  1898,  1899,  1903,  1905,
    1912,  1912,  1915,  1917,  1924,  1925,  1930,  1935,  1937,  1953,
    1959,  1964,  1969,  1975,  1981,  2016,  2024,  2031,  2032,  2033,
    2037,  2044,  2051,  2059,  2068,  2072,  2076,  2087,  2088,  2092,
    2093,  2097,  2098,  2102,  2109,  2134,  2150,  2152,  2158,  2162,
    2169,  2174,  2179,  2191,  2206,  2211,  2219,  2226,  2228,  2233,
    2238,  2243,  2248,  2253,  2261,  2268,  2273,  2278,  2288,  2289,
    2293,  2302,  2312,  2317,  2328,  2332,  2337,  2346,  2347,  2351,
    2367,  2372,  2380,  2385,  2393,  2399,  2408,  2409,  2413,  2414,
    2415,  2416,  2417,  2418,  2419,  2420,  2421,  2422,  2423,  2424,
    2432,  2449,  2450,  2453,  2454,  2459,  2464,  2469,  2474,  2480,
    2489,  2490,  2513,  2515,  2517,  2522,  2524,  2542,  2550,  2561,
    2567,  2576,  2577,  2583,  2593,  2612,  2625,  2630,  2631,  2635,
    2636,  2640,  2641,  2645,  2646,  2649,  2649,  2652,  2653,  2661,
    2665,  2686,  2695,  2704,  2715,  2717,  2719,  2726,  2728,  2733,
    2738,  2743,  2751,  2769,  2776,  2781,  2788,  2794,  2800,  2802,
    2807,  2808,  2813,  2814,  2818,  2819,  2823,  2824,  2830,  2835,
    2841,  2850,  2861,  2868,  2869,  2873,  2878,  2883,  2888,  2896,
    2898,  2903,  2908,  2916,  2918,  2922,  2928,  2928,  2929,  2929,
    2930,  2930,  2931,  2931,  2932,  2932,  2933,  2933,  2934,  2934
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "K_abs", "K_access", "K_after",
  "K_alias", "K_all", "K_and", "K_architecture", "K_array", "K_assert",
  "K_assume", "K_assume_guarantee", "K_attribute", "K_begin", "K_block",
  "K_body", "K_buffer", "K_bus", "K_case", "K_component",
  "K_configuration", "K_constant", "K_context", "K_cover", "K_default",
  "K_disconnect", "K_downto", "K_else", "K_elsif", "K_end", "K_entity",
  "K_exit", "K_fairness", "K_file", "K_for", "K_force", "K_function",
  "K_generate", "K_generic", "K_group", "K_guarded", "K_if", "K_impure",
  "K_in", "K_inertial", "K_inout", "K_is", "K_label", "K_library",
  "K_linkage", "K_literal", "K_loop", "K_map", "K_mod", "K_nand", "K_new",
  "K_next", "K_nor", "K_not", "K_null", "K_of", "K_on", "K_open", "K_or",
  "K_others", "K_out", "K_package", "K_parameter", "K_port", "K_postponed",
  "K_procedure", "K_process", "K_property", "K_protected", "K_pure",
  "K_range", "K_record", "K_register", "K_reject", "K_release", "K_rem",
  "K_report", "K_restrict", "K_restrict_guarantee", "K_return",
  "K_reverse_range", "K_rol", "K_ror", "K_select", "K_sequence",
  "K_severity", "K_signal", "K_shared", "K_sla", "K_sll", "K_sra", "K_srl",
  "K_strong", "K_subtype", "K_then", "K_to", "K_transport", "K_type",
  "K_unaffected", "K_units", "K_until", "K_use", "K_variable", "K_vmode",
  "K_vprop", "K_vunit", "K_wait", "K_when", "K_while", "K_with", "K_xnor",
  "K_xor", "IDENTIFIER", "INT_LITERAL", "REAL_LITERAL", "STRING_LITERAL",
  "CHARACTER_LITERAL", "BITSTRING_LITERAL", "LEQ", "GEQ", "VASSIGN", "NE",
  "BOX", "EXP", "ARROW", "DLT", "DGT", "CC", "M_EQ", "M_NE", "M_LT",
  "M_LEQ", "M_GT", "M_GEQ", "'+'", "'-'", "'&'", "';'", "'('", "')'",
  "','", "':'", "'|'", "'\\''", "'='", "'<'", "'>'", "'.'", "'*'", "'/'",
  "$accept", "design_file", "$@1", "adding_operator", "architecture_body",
  "$@2", "architecture_body_start", "architecture_statement_part",
  "argument_list", "argument_list_opt", "assertion_statement",
  "association_element", "association_list", "binding_indication",
  "binding_indication_semicolon_opt", "block_configuration",
  "block_configuration_opt", "block_declarative_item",
  "block_declarative_items", "block_declarative_items_opt",
  "case_statement", "case_statement_alternative_list",
  "case_statement_alternative", "choice", "choices",
  "component_configuration", "component_declaration", "instantiated_unit",
  "component_instantiation_statement", "component_specification",
  "composite_type_definition", "concurrent_assertion_statement",
  "concurrent_conditional_signal_assignment",
  "concurrent_simple_signal_assignment", "else_when_waveforms",
  "else_when_waveforms_opt", "else_when_waveform",
  "concurrent_signal_assignment_statement", "concurrent_statement",
  "configuration_declaration", "configuration_declarative_item",
  "configuration_declarative_items", "configuration_declarative_part",
  "configuration_item", "configuration_items", "configuration_items_opt",
  "constant_declaration", "context_clause", "context_item",
  "context_items", "design_unit", "design_units", "direction",
  "element_association", "element_association_list", "element_declaration",
  "element_declaration_list", "entity_aspect", "entity_aspect_opt",
  "entity_declaration", "enumeration_literal", "enumeration_literal_list",
  "expression_list", "expression", "expression_logical",
  "expression_logical_and", "expression_logical_or",
  "expression_logical_xnor", "expression_logical_xor", "factor",
  "file_declaration", "file_open_information", "file_open_information_opt",
  "for_generate_statement", "function_specification", "generate_statement",
  "generate_statement_body", "generic_clause_opt", "generic_clause",
  "generic_map_aspect_opt", "generic_map_aspect", "identifier_list",
  "identifier_opt", "identifier_colon_opt", "if_generate_statement",
  "if_statement", "if_statement_elsif_list_opt", "if_statement_elsif_list",
  "if_statement_elsif", "if_statement_else", "index_constraint",
  "index_subtype_definition", "index_subtype_definition_list",
  "instantiation_list", "interface_element",
  "interface_element_expression", "interface_list", "library_clause",
  "library_unit", "logical_name", "logical_name_list", "loop_statement",
  "mode", "mode_opt", "name", "indexed_name", "name_list",
  "package_declaration", "package_declaration_start",
  "package_body_declarative_item", "package_body_declarative_items",
  "package_body_declarative_part_opt", "package_declarative_item",
  "package_declarative_items", "package_declarative_part_opt",
  "package_body", "package_body_start", "parameter_list",
  "parameter_list_opt", "port_clause", "port_clause_opt",
  "port_map_aspect", "port_map_aspect_opt", "prefix", "primary",
  "primary_unit", "procedure_call", "procedure_call_statement",
  "procedure_specification", "process_declarative_item",
  "process_declarative_part", "process_declarative_part_opt",
  "process_start", "process_statement", "process_sensitivity_list_opt",
  "process_sensitivity_list", "range", "range_list",
  "record_type_definition", "relation", "report_statement",
  "return_statement", "secondary_unit", "selected_name", "selected_names",
  "selected_name_lib", "selected_names_lib", "selected_signal_assignment",
  "selected_waveform", "selected_waveform_list", "list_of_statements",
  "sequence_of_statements", "sequential_statement", "severity",
  "severity_opt", "shift_expression", "signal_declaration_assign_opt",
  "simple_expression", "simple_expression_2", "simple_expression_terms",
  "signal_assignment", "signal_assignment_statement",
  "subprogram_body_start", "subprogram_body", "subprogram_declaration",
  "subprogram_declarative_item", "subprogram_declarative_item_list",
  "subprogram_declarative_part", "subprogram_kind", "subprogram_kind_opt",
  "subprogram_specification", "subprogram_statement_part",
  "subtype_declaration", "subtype_indication", "suffix", "term",
  "type_declaration", "type_definition", "use_clause", "use_clause_lib",
  "use_clauses_lib", "use_clauses_opt", "variable_assignment_statement",
  "variable_assignment", "variable_declaration",
  "variable_declaration_assign_opt", "wait_statement", "waveform",
  "waveform_elements", "waveform_element", "K_architecture_opt",
  "K_configuration_opt", "K_entity_opt", "K_is_opt", "K_package_opt",
  "K_postponed_opt", "K_shared_opt", YY_NULLPTR
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
     335,   336,   337,   338,   339,   340,   341,   342,   343,   344,
     345,   346,   347,   348,   349,   350,   351,   352,   353,   354,
     355,   356,   357,   358,   359,   360,   361,   362,   363,   364,
     365,   366,   367,   368,   369,   370,   371,   372,   373,   374,
     375,   376,   377,   378,   379,   380,   381,   382,   383,   384,
     385,   386,   387,   388,   389,   390,   391,   392,   393,   394,
     395,    43,    45,    38,    59,    40,    41,    44,    58,   124,
      39,    61,    60,    62,    46,    42,    47
};
# endif

#define YYPACT_NINF -629

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-629)))

#define YYTABLE_NINF -450

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -629,    29,   476,  -629,  -629,    17,    36,   381,  -629,   262,
    -629,   374,  -629,  -629,   -95,  -629,  -629,   388,   -80,   -71,
    -629,   404,    90,    67,    80,     6,  -629,   184,  -629,  -629,
    -629,  -629,   209,  -629,   263,  -629,  -629,  -629,  -629,  -629,
    -629,   225,  -629,    51,  -629,   285,  -629,   409,   254,   417,
     383,   360,  -629,   364,  1227,   271,  -629,  -629,   333,  -629,
     474,   386,   502,   514,  -629,  -629,    14,   452,    84,   468,
     472,   490,    85,    86,  -629,  -629,  -629,  -629,  1239,   595,
    -629,  -629,   484,  -629,  -629,  -629,   613,  -629,    12,   627,
     288,  -629,   612,  -629,    66,  -629,   543,   616,  -629,   543,
     525,   603,  -629,   629,   621,  -629,   643,   549,  -629,   104,
     550,   550,   654,   560,   -18,   178,   562,  -629,   564,   557,
     -94,   441,   602,  -629,   621,  -629,   621,  -629,   621,    87,
    -629,  -629,  -629,   288,   716,  -629,   639,  -629,  -629,  -629,
    -629,   606,   644,   622,    95,   624,   626,  -629,   738,   941,
    -629,   543,  -629,   387,  -629,   660,    96,   661,   687,  -629,
    -629,   668,  -629,    11,  -629,  -629,   106,   689,   689,   106,
     689,  -629,    97,   543,   543,   543,   646,   327,  -629,  1077,
      98,  -629,  -629,   644,   752,  -629,  -629,   645,   376,  -629,
     371,  -629,    99,   648,   502,   649,   100,  -629,  1180,   785,
    -629,  -629,  -629,  -629,    79,  -629,  -629,  -629,   657,   774,
     603,  -629,   670,   117,   105,   696,   674,   683,   691,   661,
     700,  -629,  -629,   684,  -629,  -629,  -629,  -629,   652,    27,
      27,   692,   719,  -629,  -629,  -629,  -629,    19,    19,   501,
     400,  -629,  -629,   171,   218,   715,  -629,   321,   701,   455,
     296,  -629,   423,   471,  -629,   485,   -94,   711,   713,   714,
    -629,   740,    38,   689,   689,   702,   724,   689,   530,   197,
     377,  -629,  -629,   159,  -629,  -629,   520,  -629,  -629,  -629,
    -629,   917,  -629,  -629,  -629,  -629,   829,  -629,  -629,  -629,
     728,   488,  -629,   754,   850,   741,   469,   661,  -629,   736,
    -629,   543,  -629,   756,   493,  -629,   118,  -629,   865,   870,
    -629,   689,   729,  -629,   742,  -629,  -629,  -629,  -629,   769,
     840,  -629,     4,   508,  -629,  -629,   535,  -629,   293,  -629,
    -629,   775,  -629,  -629,  -629,  -629,  -629,    82,  -629,   538,
    -629,   540,   461,  -629,   689,    19,    19,    19,    19,   334,
      27,   689,   689,   689,   689,   689,   689,   689,   689,   689,
     689,   689,   689,  -629,   689,   689,   689,   689,   689,   689,
    -629,   689,  -629,  -629,  -629,    19,   423,  -629,  -629,  -629,
    -629,  -629,    -9,   172,   689,  -629,   236,   855,    34,   803,
    -629,   813,   276,  -629,   762,   689,   689,   689,  -629,  -629,
     853,   206,   763,   789,  1130,   689,    56,   866,   101,  -629,
     172,  -629,   668,   801,   474,  -629,  -629,  -629,  -629,  -629,
     668,  -629,   768,   771,  -629,   668,   365,   689,   454,   628,
    -629,  -629,  -629,  -629,  -629,  -629,  -629,  -629,  -629,   848,
    -629,   796,   777,  -629,  -629,   543,   902,    26,  -110,  -629,
     551,    26,   356,   780,   119,  -629,   567,   668,   847,  -629,
     668,  -629,   700,   808,   264,  -629,   578,   689,   501,  -629,
     501,  -629,  -629,  -629,  -629,  -629,  -629,  -629,   784,  -629,
     922,  -629,   744,  -629,  -629,   867,  -629,   814,  -629,   815,
    -629,  -629,  -629,  -629,  -629,  -629,  -629,  -629,  -629,  -629,
    -629,  -629,  -629,  -629,  -629,    19,   812,   816,  -629,   792,
    -629,  -629,  -629,   543,   794,   820,  -629,  -629,   797,   826,
     900,   990,  1024,   800,  -629,  -629,   805,   806,   807,   269,
     582,   587,   191,   522,  -629,  -629,  -629,  -629,   907,   914,
     901,  -629,  -629,   950,   186,   810,  -629,   357,   817,   543,
     831,  -629,   801,   923,   543,   836,  -629,  -629,   838,    56,
    -629,   876,   470,   -92,   958,  -629,  -629,   895,   339,    65,
     643,   825,   543,   689,  -629,  -629,   689,  -629,  -629,   842,
     918,   862,  -629,  -629,   839,  -629,   597,  -629,   863,  -629,
    -629,  -629,    26,  -629,   689,  -629,  -629,   689,   689,   689,
     689,  -629,  -629,   936,  -629,   849,  -629,  -629,  -629,   501,
     140,  -629,   852,   962,    39,   962,  -629,  -629,  -629,  -629,
     858,   860,   861,   689,   944,  1130,   689,   689,  -629,   662,
    -629,  -629,   868,   689,   871,  -629,   201,  -629,  -629,  -629,
     923,   968,   872,   689,  -629,   689,   873,   874,    97,   887,
     890,   689,   311,     8,  -629,  -629,   889,  -629,  -629,   543,
    -629,   353,   275,   280,  -629,   869,   875,   878,   288,  -629,
     883,  -629,  -629,  -629,   668,   951,  -629,  -629,   652,  -629,
    -629,   898,  -629,   590,  -629,  -629,  -629,  -629,   915,  -629,
     279,  1018,  -629,  -629,   689,  1010,   962,  -629,   999,  1010,
    -629,  -629,   993,   543,  1016,  -629,  1019,  -629,  -629,  -629,
    -629,  -629,  -629,    10,    25,   905,   908,  -629,  1021,  -629,
    -629,  -629,  -629,  -629,   933,  -629,  1017,  1022,   919,  1011,
     996,  -629,   492,   927,   689,  -629,   689,  -629,  -629,    97,
    -629,  -629,  -629,   288,  1057,  -629,  -629,  -629,  -629,  -629,
    1063,   935,   979,  1144,  1050,  -629,   940,  1055,  1130,   943,
    1036,    56,  1059,   390,   947,   752,    97,   949,    56,   689,
     118,  -629,   953,  1041,  -629,   952,   179,  -629,  1072,  1072,
     869,  -629,  1168,  -629,  -629,  1039,   101,  -629,  1061,  -629,
    1068,  1071,  -629,   543,   970,  1076,    97,    97,  -629,  -629,
     996,  -629,  -629,  1084,   869,  -629,  -629,   483,  1003,  1079,
     637,  1088,   102,   976,  -629,    56,   -10,  -629,  1072,   982,
      46,  1092,   101,  -629,   983,   984,  1080,   985,  -629,  -629,
     869,   869,  1094,  1096,  -629,    56,   675,   118,  1097,   989,
     608,   103,  1026,  -629,  -629,  -629,   848,   848,  -629,  -629,
     543,  -629,  -629,   998,  -629,  -629,  -629,  1113,   543,  -629,
    -629,  1001,   611,   689,  1075,  1078,  1009,  -629,  1117,  1013,
    -629,  -629,  -629,   543,   543,  -629,   543,  -629,  1015,  1023,
    1027,  -629,  -629,  -629
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       2,     0,     0,     1,   112,     0,     0,     0,   110,   105,
     114,     0,   107,   108,     0,   213,   215,     0,     0,     0,
     328,     0,     0,     0,     0,     0,   318,     0,   278,   277,
     111,   279,     0,   319,     0,   211,   212,   109,   113,   210,
     209,     0,   411,     0,   410,     0,     9,     0,     0,     0,
       0,     0,   234,     0,     0,     0,   214,   324,     0,   327,
     439,     0,   441,   169,   254,     7,     0,     0,     0,     0,
       0,     0,     0,     0,   241,   242,   387,   249,     0,     0,
     388,   243,     0,   244,   245,   246,     0,   238,   239,     0,
     382,   236,     0,   235,     0,   438,   179,     0,   440,   179,
       0,   261,   168,     0,   445,   247,   443,     0,   177,     0,
       0,   257,     0,     0,     0,     0,   224,   266,   226,     0,
     323,     0,     0,   248,   445,   376,   445,   237,   445,     0,
     448,   378,   380,   381,     0,   377,     0,   373,   325,   326,
     178,     0,    93,     0,     0,     0,     0,   260,     0,     0,
     444,   179,   442,     0,   104,     0,     0,     0,     0,   256,
     286,     0,   405,     0,   403,   409,     0,     0,     0,     0,
       0,   408,     0,   179,   179,   179,     0,     0,   379,     0,
       0,    88,    91,    92,     0,    89,   130,     0,     0,   208,
       0,   170,     0,     0,   441,     0,     0,    40,     0,     0,
      30,    31,    33,    32,     0,    34,    35,    36,     0,     0,
     261,   176,     0,   391,     0,     0,     0,     0,     0,     0,
       0,   407,    63,     0,   396,   394,   395,   321,     0,     0,
       0,   224,   270,   271,   272,   269,   273,     0,     0,     0,
       0,   135,   136,   397,   267,   153,   137,   138,   225,   307,
     353,   364,   365,     0,   320,     0,   322,     0,     0,     0,
     158,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     224,   346,   341,     0,   338,   343,   266,   285,   342,   345,
     344,     0,   389,   335,   371,   339,     0,   340,   416,   347,
       0,     0,    90,     0,     0,     0,   223,     0,   255,     0,
     258,   179,    38,     0,     0,    39,     0,   233,     0,     0,
     103,     0,     0,   392,     0,   101,   164,   390,   404,     0,
       0,   123,     0,     0,   131,   133,     0,   402,   267,   155,
     156,     0,   274,   363,   362,    48,    51,     0,   120,     0,
     118,    49,   353,   228,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   116,     0,     0,     0,     0,     0,     0,
     115,     0,     4,     5,     6,     0,   366,   229,   227,   232,
     253,   252,   162,   386,     0,   349,   352,     0,     0,     0,
     348,   352,     0,   316,     0,     0,     0,     0,   428,   280,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   334,
     386,   422,     0,   415,   439,   171,   219,   221,   220,   222,
       0,   207,     0,     0,    37,     0,     0,     0,   224,     0,
      64,    82,    84,    76,    74,    83,    11,   166,    85,   447,
     165,   266,   298,    86,    78,   179,     0,     0,     0,   304,
       0,     0,     0,     0,   224,   200,     0,     0,     0,   122,
       0,   406,     0,     0,   224,    22,     0,     0,     0,   276,
       0,   134,   400,   401,   398,   399,   302,   303,    15,   154,
     139,   145,   353,   142,   143,   140,   147,   144,   149,   141,
     151,   311,   312,   313,   308,   309,   310,   359,   358,   357,
     355,   356,   354,   301,   367,     0,     0,     0,   161,     0,
     383,   384,   385,   179,     0,     0,    16,   351,     0,     0,
       0,     0,     0,     0,   317,   315,     0,     0,     0,     0,
       0,     0,     0,   224,   284,   372,   417,   282,     0,     0,
       0,   435,   430,   433,     0,   429,   432,     0,     0,   179,
     424,   413,   414,    99,   179,   206,   259,   129,   361,     0,
      12,     0,     0,     0,   437,    10,   446,     0,     0,     0,
     443,     0,   179,     0,   197,   196,     0,   102,   100,     0,
       0,     0,    61,   306,     0,   132,     0,   275,     0,   117,
      50,    49,    47,   119,     0,    14,   268,     0,     0,     0,
       0,   368,   160,     0,   157,     0,   420,   350,    17,     0,
       0,    45,     0,   188,     0,   188,   314,   425,   426,   427,
       0,     0,   228,     0,     0,     0,     0,     0,   369,     0,
     419,   418,     0,     0,     0,   412,     0,    94,    95,    97,
      98,     0,     0,     0,   204,     0,     0,     0,     0,     0,
       0,     0,    56,     0,    77,    75,   266,    79,   436,   179,
     293,     0,     0,     0,   299,   231,   300,     0,   292,    55,
       0,   393,   305,   198,     0,     0,   199,   121,    20,    19,
      18,     0,    21,     0,   146,   148,   150,   152,     0,   375,
       0,     0,    44,   186,     0,   195,   187,   190,     0,   195,
     283,   281,     0,   179,     0,   434,     0,   431,   374,   423,
     421,   203,   202,   177,     0,   201,     0,    96,     0,    87,
     205,   360,    29,    81,   266,    57,     0,     0,     0,     0,
     265,   172,     0,     0,     0,    80,     0,    67,   297,     0,
     296,   288,   290,   291,     0,   287,    54,    62,    13,   159,
       0,     0,     0,     0,     0,   189,     0,     0,     0,     0,
       0,     0,     0,   128,     0,    28,     0,     0,     0,     0,
       0,    59,     0,     0,   264,     0,     0,     8,     0,    71,
     230,   289,     0,    46,    43,     0,   194,   193,     0,   185,
       0,     0,   218,   179,     0,     0,     0,     0,   126,   127,
     265,    24,    27,     0,    60,    26,   333,     0,     0,     0,
       0,     0,     0,     0,    58,     0,     0,    69,    70,     0,
       0,     0,   192,   191,     0,     0,     0,     0,   370,    53,
     125,   124,   173,     0,   329,     0,     0,     0,     0,     0,
       0,     0,    73,    66,    68,    65,   447,   447,   184,   183,
     179,   216,    23,     0,   332,   331,   330,     0,   179,   175,
     174,     0,     0,     0,     0,     0,     0,    52,     0,     0,
     263,   262,    72,   179,   179,   217,   179,   182,     0,     0,
       0,   295,   294,   163
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -629,  -629,  -629,   786,  -629,  -629,  -629,   859,   690,  -629,
    -298,   584,  -395,  -629,  -629,  -183,  -629,   972,  -629,  -629,
    -629,  -629,   574,   706,   576,  -629,  -118,  -629,  -629,  -629,
    -629,  -629,   631,   632,   407,  -629,  -215,  -629,  -423,  -629,
    1006,  -629,  -629,   558,  -629,  -629,    71,  -629,  1191,  -629,
    1195,  -629,   755,   737,  -629,   886,  -629,  -629,  -629,  -629,
     747,  -629,  -153,  -157,   809,  -629,  -629,  -629,  -629,   228,
    -628,  -629,  -629,  -629,  -629,  -629,   373,  1062,  -629,   380,
    -629,   -66,   -99,  -292,  -629,  -629,   604,  -629,   521,   524,
    1002,   641,  -629,  -629,   928,  -629,  -629,  -629,  -629,  1183,
    -629,  -629,  -629,  -629,   -70,  -629,  -629,  -629,  -629,  1138,
    -629,  -629,  1153,  -629,  -629,  -629,  -629,   322,  -629,  -629,
    1025,  -629,   432,  -629,  -187,  -629,   832,  -629,  -629,   491,
    -629,  -629,  -629,  -629,  -629,  -629,  -207,  -629,  -629,  -261,
     851,  -629,  -629,   -48,  -629,  1193,  -629,   677,   401,  -629,
    -629,  -377,   960,  -629,   856,   518,  -629,    -4,   523,  -629,
     841,  -629,  -629,    75,    81,  1111,  -629,  -629,  -629,   843,
     -17,  -629,   116,  -154,  1086,  -351,   168,  -629,   -21,  -145,
    -629,  -629,  -629,   845,  -621,  -629,  -629,  -390,  -629,   635,
    -629,   854,  1067,   686,   414,   -83,  -629
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,   375,    26,   103,    27,   810,   402,   596,
     271,   465,   466,   764,   765,   637,   803,   197,   198,   199,
     272,   610,   611,   336,   337,   638,    74,   653,   431,   714,
     221,   432,   433,   434,   816,   819,   817,   435,   436,    28,
     182,   183,   184,   639,   640,   641,    75,     7,     8,     9,
      10,    11,   371,   338,   339,   321,   322,   799,   800,    29,
     325,   326,   240,   543,   242,   480,   485,   487,   489,   243,
     131,   508,   509,   437,    76,   438,   811,   101,   102,   730,
     731,   188,   141,   273,   440,   274,   695,   696,   697,   754,
     313,   455,   456,   716,   189,   644,   190,    12,    30,    16,
      17,   275,   419,   420,   244,   118,   666,    31,    32,    87,
      88,    89,    77,    78,    79,    33,    34,   145,   160,   147,
     148,   774,   775,   119,   245,    35,   277,   278,    80,   742,
     743,   744,   442,   443,   570,   667,   246,   450,   222,   247,
     279,   280,    36,   248,   121,    20,    21,   444,   806,   807,
     281,   282,   283,   517,   518,   249,   646,   250,   251,   376,
     284,   285,    90,    91,    81,   132,   133,   134,   512,   513,
      82,   286,    83,   214,   227,   252,    84,   223,    85,    13,
     552,   553,   287,   288,   135,   634,   289,   662,   545,   546,
     659,    96,    99,   153,   151,   567,   136
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
     143,   294,   109,   117,   207,   530,   565,   216,   430,   728,
     241,   241,   217,   241,   439,   253,   544,   255,    14,   815,
     228,   218,   229,    51,   504,   120,   762,   539,   228,     3,
     163,   200,   341,   559,    93,   458,   574,    18,    92,   506,
     741,  -415,   329,   330,   166,   104,  -415,   745,   729,    39,
      69,   170,   208,   207,   363,   507,   -25,   228,    57,   229,
    -225,   -25,   166,   177,    42,   520,   663,    93,    47,   383,
     698,    92,   664,   138,   257,   258,   259,   846,  -173,   230,
     200,    49,   340,    43,    70,   107,   113,   115,   176,   219,
     481,   483,   484,   486,   488,   490,   187,   212,   228,   290,
     299,   303,   117,   839,   861,   449,   386,   387,   389,   276,
     391,   394,   449,   224,   291,   741,   230,   541,     6,   426,
      73,   185,   745,   108,   256,    52,   164,   137,   370,   263,
     304,   430,   204,   763,   843,   521,    15,   439,   231,   232,
     233,   234,   235,   236,   613,   615,   231,   232,   233,   234,
     235,   236,  -173,   323,   601,    19,   220,   453,   105,   328,
     328,   542,   185,   479,   239,   384,   384,   328,   328,   647,
      58,   691,   239,   384,   241,   231,   232,   233,   234,   235,
     236,   204,   385,   385,   116,   139,    48,   471,   166,  -181,
     385,  -181,   166,   166,   311,   403,   579,   237,   238,    50,
     166,   239,   423,   108,   114,   116,   108,   532,   711,    46,
     510,   276,   404,   467,   108,   213,   116,   108,   108,   108,
     201,   681,   681,   125,   202,   225,   345,   514,   384,   226,
     203,   468,   314,   395,   427,   342,   441,   428,   526,   527,
     528,   328,  -180,   241,   511,   385,    53,   531,   704,   315,
     548,   155,   156,   346,   609,   166,   323,    54,   550,  -180,
     396,   591,   312,   341,   331,   205,   555,   712,   551,   201,
     561,   558,    86,   202,   405,   328,   328,   328,   328,   203,
     328,   328,   328,   328,   328,   328,   328,   328,   328,   328,
     328,   328,   328,   734,   328,   328,   328,   328,   328,   328,
     627,   328,  -240,   582,   397,   328,   584,   447,   451,    69,
     589,    55,     5,   340,   205,   451,    61,   206,   384,   267,
     713,  -180,   165,   129,   363,   533,   347,   348,   515,   351,
     628,   276,   166,   166,   276,   328,   684,   685,   686,   687,
     661,   398,   229,    70,    15,   166,   571,   482,   482,   482,
     482,   482,   482,   482,   482,   482,   482,   482,   482,   441,
     497,   498,   499,   500,   501,   502,   206,   503,   349,   672,
       6,   794,  -266,   783,    -3,     4,   787,   352,   808,    73,
     353,   791,   130,  -106,   364,   365,   354,   565,   209,   736,
      22,   366,   367,   368,   369,   586,  -106,  -449,   370,   230,
     541,   482,   591,    23,    19,   821,  -106,   635,   823,   331,
     750,   476,   796,    24,   605,   620,   702,   840,  -169,   737,
     524,   477,   797,   166,     5,   842,   738,   100,   468,   680,
     166,    63,   158,   159,   166,   328,  -224,   241,   355,   356,
      60,   683,  -106,   463,   542,   808,   862,  -266,    62,    25,
     632,   276,   276,   478,   798,   642,   167,  -169,   231,   232,
     233,   234,   235,   236,   592,  -224,   342,   734,   193,   705,
     706,   228,   430,   670,   155,   261,   709,     4,   439,    64,
     237,   238,     6,    65,   239,  -106,   720,    94,   721,   363,
     559,   649,   656,   776,   727,   229,    95,   735,  -106,   665,
     577,   630,   228,   328,   229,    97,   650,   166,  -106,   560,
     166,   166,   430,   651,   416,   297,   417,   298,   439,   166,
     747,   399,   400,   155,   296,   401,     5,   328,   328,   328,
     328,   392,    40,   229,    98,    41,   418,   752,   173,   430,
     174,  -180,   175,  -180,  -106,   439,   343,   344,    44,   364,
     365,    45,   230,   541,   100,   276,   366,   367,   368,   369,
     733,   230,   809,   370,   372,   373,   374,   335,   551,   671,
     715,   106,   451,   472,   473,   474,   475,   778,   724,   779,
     357,   358,   802,   359,     6,   171,   427,   110,   172,   652,
     230,   111,   -47,   482,   482,   482,   482,   542,   678,   167,
     229,   844,   562,   844,   759,   592,   360,   361,   362,   112,
     -47,   231,   232,   233,   234,   235,   236,   377,   344,   451,
     231,   232,   233,   234,   235,   236,   124,   834,   125,   563,
     835,   378,   344,   237,   238,   155,   412,   239,   563,   263,
     155,   425,   237,   238,   126,   406,   239,   407,   263,   231,
     232,   233,   234,   235,   236,   155,   460,   230,   128,   564,
     137,   679,   140,   228,   142,   229,   399,   400,  -167,   780,
     144,   237,   238,   146,   393,   239,   228,   149,   229,   856,
     276,   461,   462,   276,   469,   470,  -137,  -137,   276,   150,
     228,   152,   229,   154,   827,   157,   804,   575,   576,  -181,
     441,  -181,   161,   388,   162,   229,   872,   167,  -181,   168,
    -181,   169,   276,   580,   581,   276,   231,   232,   233,   234,
     235,   236,   230,   541,   587,   588,   830,   831,   621,   588,
     448,   179,   229,   622,   344,   230,   748,   344,   237,   238,
     441,   855,   239,   452,   427,   229,   105,   428,   180,   230,
     181,   866,    73,   427,   860,   588,   428,   871,   588,   869,
     333,   334,   230,   864,   865,   451,   186,   441,   191,   194,
     448,   192,   229,   215,   878,   879,   228,   880,   229,   211,
     108,   231,   232,   233,   234,   235,   236,   213,   293,   230,
     260,   295,   300,   302,   231,   232,   233,   234,   235,   236,
     306,   307,   230,   237,   238,   308,   166,   239,   231,   232,
     233,   234,   235,   236,   310,   316,   237,   238,   317,   324,
     239,   231,   232,   233,   234,   235,   236,   318,   327,   230,
     237,   238,   364,   365,   239,   230,   319,   331,   332,   366,
     367,   368,   369,   237,   238,   350,   170,   239,   231,   232,
     233,   234,   235,   236,   529,   379,   229,   380,   381,   382,
     410,   231,   232,   233,   234,   235,   236,   547,   390,   229,
     237,   238,   411,   413,   239,   491,   492,   493,   494,   495,
     496,   414,   422,   237,   238,   415,   445,   239,   454,   232,
     233,   234,   235,   236,   464,   232,   233,   234,   235,   236,
     424,   446,   457,   519,   522,   515,   525,   537,   538,     6,
     237,   238,   556,   230,   239,   557,   237,   238,   408,   566,
     239,   568,   569,   572,   578,   583,   230,   478,   263,   594,
     597,   599,   598,   600,   602,   603,   604,   264,   606,   607,
     609,   608,   195,   612,   616,   624,  -336,  -336,  -336,   617,
     618,   619,   623,  -181,   625,   626,   -42,   629,   633,   636,
     265,   631,    67,   643,    68,   645,   648,   658,   660,   669,
    -181,   673,   464,   232,   233,   234,   235,   236,   266,    69,
     674,   675,   681,   677,   688,   231,   232,   233,   234,   235,
     236,   408,   694,   689,   237,   238,   693,   703,   239,   718,
     267,   263,   700,   268,   701,   -13,   725,   237,   238,   726,
     264,   239,   708,    70,   732,   710,   719,   722,   723,  -337,
    -337,  -337,   739,  -266,   740,   614,  -181,   746,   579,   586,
     269,  -336,  -181,   265,   196,   263,   270,   749,   751,   753,
     822,    71,   756,  -181,   264,    72,   758,   760,   761,     6,
     263,   266,   155,  -337,  -337,  -337,   766,   767,   768,   264,
    -181,   770,   769,   771,   408,   772,   773,   265,  -337,  -337,
    -337,   777,   782,   267,   263,  -181,   268,  -181,   262,   784,
     785,   788,   265,   264,   789,   266,   790,   792,   263,   793,
     795,   801,  -181,   805,  -337,   813,   814,   264,   812,  -181,
     266,   815,   826,   269,   824,  -181,   265,   267,  -337,   270,
     268,   825,   829,  -181,   828,   833,  -181,   836,   837,   838,
     265,   841,   267,   847,   266,   268,   845,   848,   849,   851,
    -181,   408,   853,   850,   729,   859,   858,   269,   266,  -181,
     863,   263,   867,   270,   868,   786,   267,   870,   873,   268,
     264,   874,   269,   875,  -181,   263,   876,   877,   270,   881,
     267,  -337,   505,   268,   264,   429,  -181,   882,   595,   820,
     305,   883,   682,   265,   590,  -337,   269,  -337,  -181,   263,
    -181,   195,   270,  -181,   692,   690,   818,   265,   264,   292,
     269,   266,  -181,   654,   655,   -41,   270,  -181,   717,  -337,
      37,    67,   573,    68,  -181,   266,    38,   593,   459,   585,
     857,   265,   852,   267,   540,   210,   268,   755,    69,   699,
     320,  -181,   676,   757,    56,   421,   127,   267,    66,   266,
     268,   123,   832,   534,   781,   309,   854,   516,    59,   657,
     122,   409,   535,   269,   178,  -181,   536,   523,    67,   270,
      68,   267,    70,   549,   268,   254,   668,   269,  -251,  -181,
      67,   301,    68,   270,   707,    69,     0,     0,   554,     0,
    -250,     0,     0,   196,     0,     0,     0,    69,     0,     0,
      71,   269,     0,  -181,    72,     0,     0,   270,     6,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    70,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    70,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    71,     0,     0,
       0,    72,     0,     0,     0,    73,     0,     0,     0,    71,
       0,     0,     0,    72,     0,     0,     0,    73
};

static const yytype_int16 yycheck[] =
{
      99,   184,    68,    73,   149,   400,   429,   161,   306,     1,
     167,   168,     1,   170,   306,   168,   406,   170,     1,    29,
       1,    10,     3,    17,   375,    73,     1,   404,     1,     0,
      48,   149,   239,   125,    55,    31,   146,     1,    55,    48,
     668,    31,   229,   230,   154,    31,    36,   668,    40,   144,
      38,   145,   151,   198,    28,    64,    31,     1,     7,     3,
     154,    36,   154,   129,   144,    31,     1,    88,     1,    31,
      31,    88,     7,     7,   173,   174,   175,    31,    70,    60,
     198,     1,   239,   154,    72,     1,     1,     1,     1,    78,
     351,   352,   353,   354,   355,   356,     1,     1,     1,     1,
       1,     1,   172,     1,     1,   312,   263,   264,   265,   179,
     267,   268,   319,     7,   180,   743,    60,    61,   108,     1,
     108,   142,   743,   119,   172,   119,   144,    48,   102,    11,
     196,   429,   149,   108,   144,   101,   119,   429,   119,   120,
     121,   122,   123,   124,   521,   522,   119,   120,   121,   122,
     123,   124,   144,   219,   505,   119,   145,   314,   144,   229,
     230,   105,   183,   350,   145,   127,   127,   237,   238,   559,
     119,    31,   145,   127,   331,   119,   120,   121,   122,   123,
     124,   198,   144,   144,   119,   119,   119,   344,   154,    71,
     144,    73,   154,   154,    77,    36,    77,   141,   142,   119,
     154,   145,   301,   119,   119,   119,   119,     1,     7,   119,
      38,   281,    53,   131,   119,   119,   119,   119,   119,   119,
     149,   119,   119,   144,   149,   119,    55,   384,   127,   123,
     149,   149,   127,    36,   116,   239,   306,   119,   395,   396,
     397,   311,    36,   400,    72,   144,    62,   400,   625,   144,
     407,   147,   148,    82,   114,   154,   322,    48,   412,    53,
      63,   468,   145,   470,   145,   149,   420,    66,   413,   198,
     427,   425,     1,   198,   115,   345,   346,   347,   348,   198,
     350,   351,   352,   353,   354,   355,   356,   357,   358,   359,
     360,   361,   362,   114,   364,   365,   366,   367,   368,   369,
     114,   371,    31,   457,   107,   375,   460,   311,   312,    38,
     467,    48,    50,   470,   198,   319,    62,   149,   127,    83,
     119,   115,   144,    35,    28,   119,   155,   156,    92,     8,
     144,   401,   154,   154,   404,   405,   597,   598,   599,   600,
       1,   144,     3,    72,   119,   154,   445,   351,   352,   353,
     354,   355,   356,   357,   358,   359,   360,   361,   362,   429,
     364,   365,   366,   367,   368,   369,   198,   371,   150,   576,
     108,   761,   154,   750,     0,     1,   753,    56,   768,   108,
      59,   758,    94,     9,    88,    89,    65,   810,     1,   114,
       9,    95,    96,    97,    98,   131,    22,   109,   102,    60,
      61,   405,   609,    22,   119,   782,    32,   552,   785,   145,
     131,    77,    22,    32,   513,   146,   623,   812,    31,   144,
     144,    87,    32,   154,    50,   815,   146,    40,   149,   586,
     154,    48,   110,   111,   154,   505,   125,   594,   117,   118,
      31,   594,    68,   150,   105,   835,   841,   154,    31,    68,
     549,   521,   522,   119,    64,   554,   145,    70,   119,   120,
     121,   122,   123,   124,   468,   154,   470,   114,   146,   626,
     627,     1,   770,   572,   147,   148,   633,     1,   770,   119,
     141,   142,   108,   119,   145,     9,   643,   154,   645,    28,
     125,    21,   562,     1,   651,     3,    22,   144,    22,   569,
     144,   144,     1,   573,     3,   119,    36,   154,    32,   144,
     154,   154,   810,    43,    45,   144,    47,   146,   810,   154,
     674,   144,   145,   147,   148,   148,    50,   597,   598,   599,
     600,     1,   144,     3,    32,   147,    67,   694,   124,   837,
     126,    71,   128,    73,    68,   837,   146,   147,   144,    88,
      89,   147,    60,    61,    40,   625,    95,    96,    97,    98,
     659,    60,   769,   102,   141,   142,   143,    66,   713,   573,
     636,   119,   576,   345,   346,   347,   348,   734,   648,   736,
     125,   126,   765,   128,   108,   144,   116,   119,   147,   119,
      60,   119,   131,   597,   598,   599,   600,   105,     1,   145,
       3,   816,   148,   818,   703,   609,   151,   152,   153,   119,
     149,   119,   120,   121,   122,   123,   124,   146,   147,   623,
     119,   120,   121,   122,   123,   124,    31,   144,   144,     1,
     147,   146,   147,   141,   142,   147,   148,   145,     1,    11,
     147,   148,   141,   142,    31,   125,   145,   127,    11,   119,
     120,   121,   122,   123,   124,   147,   148,    60,    31,    31,
      48,    64,   119,     1,    48,     3,   144,   145,    31,   739,
     145,   141,   142,    70,   144,   145,     1,    48,     3,   836,
     750,   146,   147,   753,   146,   147,   146,   147,   758,    68,
       1,    48,     3,   144,   793,   145,   766,   146,   147,    71,
     770,    73,    48,     1,   144,     3,   863,   145,    71,   145,
      73,   154,   782,   146,   147,   785,   119,   120,   121,   122,
     123,   124,    60,    61,   146,   147,   796,   797,   146,   147,
       1,    15,     3,   146,   147,    60,   146,   147,   141,   142,
     810,    66,   145,     1,   116,     3,   144,   119,   109,    60,
     144,   850,   108,   116,   146,   147,   119,   146,   147,   858,
     237,   238,    60,   846,   847,   769,   144,   837,   144,    31,
       1,   145,     3,    86,   873,   874,     1,   876,     3,   119,
     119,   119,   120,   121,   122,   123,   124,   119,    36,    60,
     144,   146,   144,   144,   119,   120,   121,   122,   123,   124,
      15,   144,    60,   141,   142,    31,   154,   145,   119,   120,
     121,   122,   123,   124,   144,   119,   141,   142,   144,   119,
     145,   119,   120,   121,   122,   123,   124,   144,   144,    60,
     141,   142,    88,    89,   145,    60,   145,   145,   119,    95,
      96,    97,    98,   141,   142,   130,   145,   145,   119,   120,
     121,   122,   123,   124,     1,   144,     3,   144,   144,   119,
      31,   119,   120,   121,   122,   123,   124,     1,   144,     3,
     141,   142,   144,   119,   145,   357,   358,   359,   360,   361,
     362,    31,   146,   141,   142,   144,    21,   145,   119,   120,
     121,   122,   123,   124,   119,   120,   121,   122,   123,   124,
     144,    31,    62,    48,   101,    92,   144,   144,   119,   108,
     141,   142,   144,    60,   145,   144,   141,   142,     1,    71,
     145,   125,   145,    21,   144,    78,    60,   119,    11,   145,
       8,   117,    65,   118,   122,   119,   144,    20,   144,   119,
     114,   144,     1,    43,   144,    31,    29,    30,    31,   144,
     144,   144,    45,    36,    53,     5,    15,   147,   127,    36,
      43,   144,    21,   127,    23,   127,    90,     9,    73,   144,
      53,   129,   119,   120,   121,   122,   123,   124,    61,    38,
      62,   119,   119,   144,    48,   119,   120,   121,   122,   123,
     124,     1,    30,   144,   141,   142,   144,    53,   145,    31,
      83,    11,   144,    86,   144,   144,   119,   141,   142,   119,
      20,   145,   144,    72,   125,   144,   144,   144,   144,    29,
      30,    31,   147,   154,   146,     1,    36,   144,    77,   131,
     113,   114,   115,    43,    93,    11,   119,   122,    20,    29,
       1,   100,    43,    53,    20,   104,    53,    31,    29,   108,
      11,    61,   147,    29,    30,    31,   148,    36,   125,    20,
      36,    39,    45,   144,     1,    54,    70,    43,    29,    30,
      31,   144,    15,    83,    11,    36,    86,    53,     1,   144,
     101,    31,    43,    20,   144,    61,    31,   144,    11,    53,
      31,   144,    53,   144,    31,    54,   144,    20,   145,    36,
      61,    29,    31,   113,    43,   115,    43,    83,    31,   119,
      86,    43,    36,    36,   144,    31,    53,   114,    39,    31,
      43,   145,    83,    31,    61,    86,   144,   144,   144,   144,
      53,     1,    36,    53,    40,   146,    39,   113,    61,   115,
     114,    11,   144,   119,    31,     1,    83,   146,    73,    86,
      20,    73,   113,   144,   115,    11,    39,   144,   119,   144,
      83,    31,   376,    86,    20,   306,    36,   144,   478,     1,
     198,   144,   588,    43,   468,    31,   113,   114,   115,    11,
      36,     1,   119,    53,   610,   609,   779,    43,    20,   183,
     113,    61,   115,   562,   562,    15,   119,    53,   640,    31,
       9,    21,   447,    23,    36,    61,    11,   470,   322,   462,
     837,    43,   832,    83,   405,   153,    86,   696,    38,   615,
     218,    53,   581,   699,    41,   297,    88,    83,     1,    61,
      86,    78,   800,   401,   743,   210,   835,   386,    45,   562,
       1,   281,   401,   113,   133,   115,   401,   391,    21,   119,
      23,    83,    72,   410,    86,   169,   570,   113,    31,   115,
      21,   194,    23,   119,   629,    38,    -1,    -1,   414,    -1,
      31,    -1,    -1,    93,    -1,    -1,    -1,    38,    -1,    -1,
     100,   113,    -1,   115,   104,    -1,    -1,   119,   108,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    72,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    72,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   100,    -1,    -1,
      -1,   104,    -1,    -1,    -1,   108,    -1,    -1,    -1,   100,
      -1,    -1,    -1,   104,    -1,    -1,    -1,   108
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint16 yystos[] =
{
       0,   158,   159,     0,     1,    50,   108,   204,   205,   206,
     207,   208,   254,   336,     1,   119,   256,   257,     1,   119,
     302,   303,     9,    22,    32,    68,   161,   163,   196,   216,
     255,   264,   265,   272,   273,   282,   299,   205,   207,   144,
     144,   147,   144,   154,   144,   147,   119,     1,   119,     1,
     119,    17,   119,    62,    48,    48,   256,     7,   119,   302,
      31,    62,    31,    48,   119,   119,     1,    21,    23,    38,
      72,   100,   104,   108,   183,   203,   231,   269,   270,   271,
     285,   321,   327,   329,   333,   335,     1,   266,   267,   268,
     319,   320,   327,   335,   154,    22,   348,   119,    32,   349,
      40,   234,   235,   162,    31,   144,   119,     1,   119,   238,
     119,   119,   119,     1,   119,     1,   119,   261,   262,   280,
     300,   301,     1,   269,    31,   144,    31,   266,    31,    35,
      94,   227,   322,   323,   324,   341,   353,    48,     7,   119,
     119,   239,    48,   239,   145,   274,    70,   276,   277,    48,
      68,   351,    48,   350,   144,   147,   148,   145,   274,   274,
     275,    48,   144,    48,   144,   144,   154,   145,   145,   154,
     145,   144,   147,   351,   351,   351,     1,   238,   322,    15,
     109,   144,   197,   198,   199,   335,   144,     1,   238,   251,
     253,   144,   145,   274,    31,     1,    93,   174,   175,   176,
     183,   203,   320,   321,   327,   329,   333,   336,   239,     1,
     234,   119,     1,   119,   330,    86,   330,     1,    10,    78,
     145,   187,   295,   334,     7,   119,   123,   331,     1,     3,
      60,   119,   120,   121,   122,   123,   124,   141,   142,   145,
     219,   220,   221,   226,   261,   281,   293,   296,   300,   312,
     314,   315,   332,   219,   331,   219,   300,   239,   239,   239,
     144,   148,     1,    11,    20,    43,    61,    83,    86,   113,
     119,   167,   177,   240,   242,   258,   261,   283,   284,   297,
     298,   307,   308,   309,   317,   318,   328,   339,   340,   343,
       1,   238,   197,    36,   172,   146,   148,   144,   146,     1,
     144,   349,   144,     1,   238,   174,    15,   144,    31,   277,
     144,    77,   145,   247,   127,   144,   119,   144,   144,   145,
     247,   212,   213,   238,   119,   217,   218,   144,   261,   281,
     281,   145,   119,   315,   315,    66,   180,   181,   210,   211,
     220,   293,   314,   146,   147,    55,    82,   155,   156,   150,
     130,     8,    56,    59,    65,   117,   118,   125,   126,   128,
     151,   152,   153,    28,    88,    89,    95,    96,    97,    98,
     102,   209,   141,   142,   143,   160,   316,   146,   146,   144,
     144,   144,   119,    31,   127,   144,   220,   220,     1,   220,
     144,   220,     1,   144,   220,    36,    63,   107,   144,   144,
     145,   148,   165,    36,    53,   115,   125,   127,     1,   309,
      31,   144,   148,   119,    31,   144,    45,    47,    67,   259,
     260,   251,   146,   239,   144,   148,     1,   116,   119,   164,
     167,   185,   188,   189,   190,   194,   195,   230,   232,   240,
     241,   261,   289,   290,   304,    21,    31,   314,     1,   293,
     294,   314,     1,   220,   119,   248,   249,    62,    31,   212,
     148,   146,   147,   150,   119,   168,   169,   131,   149,   146,
     147,   220,   226,   226,   226,   226,    77,    87,   119,   281,
     222,   296,   314,   296,   296,   223,   296,   224,   296,   225,
     296,   312,   312,   312,   312,   312,   312,   314,   314,   314,
     314,   314,   314,   314,   332,   160,    48,    64,   228,   229,
      38,    72,   325,   326,   220,    92,   297,   310,   311,    48,
      31,   101,   101,   311,   144,   144,   220,   220,   220,     1,
     169,   219,     1,   119,   283,   317,   340,   144,   119,   308,
     221,    61,   105,   220,   344,   345,   346,     1,   220,   326,
     330,   336,   337,   338,   348,   330,   144,   144,   330,   125,
     144,   220,   148,     1,    31,   195,    71,   352,   125,   145,
     291,   239,    21,   209,   146,   146,   147,   144,   144,    77,
     146,   147,   330,    78,   330,   217,   131,   146,   147,   220,
     180,   293,   314,   210,   145,   165,   166,     8,    65,   117,
     118,   332,   122,   119,   144,   239,   144,   119,   144,   114,
     178,   179,    43,   308,     1,   308,   144,   144,   144,   144,
     146,   146,   146,    45,    31,    53,     5,   114,   144,   147,
     144,   144,   239,   127,   342,   336,    36,   172,   182,   200,
     201,   202,   239,   127,   252,   127,   313,   344,    90,    21,
      36,    43,   119,   184,   189,   190,   261,   304,     9,   347,
      73,     1,   344,     1,     7,   261,   263,   292,   350,   144,
     239,   314,   293,   129,    62,   119,   248,   144,     1,    64,
     220,   119,   168,   219,   296,   296,   296,   296,    48,   144,
     181,    31,   179,   144,    30,   243,   244,   245,    31,   243,
     144,   144,   293,    53,   308,   220,   220,   346,   144,   220,
     144,     7,    66,   119,   186,   238,   250,   200,    31,   144,
     220,   220,   144,   144,   261,   119,   119,   220,     1,    40,
     236,   237,   125,   239,   114,   144,   114,   144,   146,   147,
     146,   227,   286,   287,   288,   341,   144,   330,   146,   122,
     131,    20,   220,    29,   246,   245,    43,   246,    53,   239,
      31,    29,     1,   108,   170,   171,   148,    36,   125,    45,
      39,   144,    54,    70,   278,   279,     1,   144,   220,   220,
     261,   286,    15,   308,   144,   101,     1,   308,    31,   144,
      31,   308,   144,    53,   344,    31,    22,    32,    64,   214,
     215,   144,   172,   173,   261,   144,   305,   306,   344,   293,
     164,   233,   145,    54,   144,    29,   191,   193,   191,   192,
       1,   308,     1,   308,    43,    43,    31,   239,   144,    36,
     261,   261,   279,    31,   144,   147,   114,    39,    31,     1,
     169,   145,   344,   144,   193,   144,    31,    31,   144,   144,
      53,   144,   236,    36,   305,    66,   220,   233,    39,   146,
     146,     1,   169,   114,   352,   352,   239,   144,    31,   239,
     146,   146,   220,    73,    73,   144,    39,   144,   239,   239,
     239,   144,   144,   144
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint16 yyr1[] =
{
       0,   157,   159,   158,   160,   160,   160,   162,   161,   163,
     164,   164,   164,   165,   166,   166,   167,   167,   168,   168,
     168,   169,   169,   170,   171,   171,   172,   173,   173,   174,
     174,   174,   174,   174,   174,   174,   174,   174,   174,   175,
     175,   176,   176,   177,   178,   178,   179,   180,   180,   180,
     181,   181,   182,   182,   183,   183,   184,   184,   185,   185,
     186,   187,   187,   187,   188,   189,   189,   190,   191,   191,
     192,   192,   193,   193,   194,   194,   194,   194,   194,   194,
     194,   194,   195,   195,   195,   195,   195,   196,   196,   197,
     198,   198,   199,   199,   200,   200,   201,   201,   202,   202,
     203,   203,   203,   203,   203,   204,   204,   205,   205,   206,
     206,   207,   207,   208,   208,   209,   209,   210,   210,   211,
     211,   212,   213,   213,   214,   214,   214,   215,   215,   216,
     216,   217,   218,   218,   219,   219,   220,   220,   221,   221,
     221,   221,   221,   221,   221,   222,   222,   223,   223,   224,
     224,   225,   225,   226,   226,   226,   226,   227,   227,   228,
     228,   229,   229,   230,   231,   232,   232,   233,   234,   234,
     235,   235,   236,   236,   237,   237,   238,   238,   239,   239,
     240,   240,   241,   242,   242,   242,   242,   243,   243,   244,
     244,   245,   245,   246,   246,   246,   247,   247,   248,   249,
     249,   250,   250,   250,   251,   252,   252,   253,   253,   254,
     254,   255,   255,   256,   257,   257,   258,   258,   258,   259,
     259,   259,   260,   260,   261,   261,   261,   261,   262,   262,
     263,   263,   264,   264,   265,   266,   266,   267,   267,   268,
     268,   269,   269,   269,   269,   269,   269,   269,   270,   270,
     271,   271,   272,   272,   273,   274,   275,   275,   276,   276,
     277,   277,   278,   278,   279,   279,   280,   281,   281,   281,
     281,   281,   281,   281,   281,   281,   281,   282,   282,   282,
     283,   283,   283,   283,   284,   284,   285,   286,   286,   287,
     287,   288,   288,   289,   290,   290,   291,   291,   291,   292,
     292,   293,   293,   293,   294,   294,   295,   296,   296,   296,
     296,   296,   296,   296,   297,   298,   298,   298,   299,   299,
     300,   300,   301,   301,   302,   302,   302,   303,   303,   304,
     305,   305,   306,   306,   307,   307,   308,   308,   309,   309,
     309,   309,   309,   309,   309,   309,   309,   309,   309,   309,
     310,   311,   311,   312,   312,   312,   312,   312,   312,   312,
     313,   313,   314,   314,   314,   315,   315,   316,   316,   317,
     317,   318,   318,   319,   320,   320,   321,   322,   322,   323,
     323,   324,   324,   325,   325,   326,   326,   327,   327,   328,
     329,   330,   330,   330,   331,   331,   331,   332,   332,   332,
     332,   332,   333,   333,   333,   333,   334,   334,   335,   335,
     336,   336,   337,   337,   338,   338,   339,   339,   340,   340,
     340,   341,   341,   342,   342,   343,   343,   343,   343,   344,
     344,   345,   345,   346,   346,   346,   347,   347,   348,   348,
     349,   349,   350,   350,   351,   351,   352,   352,   353,   353
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     2,     1,     1,     1,     0,    12,     2,
       2,     1,     2,     3,     1,     0,     3,     4,     3,     3,
       3,     3,     1,     4,     2,     0,     7,     1,     0,     6,
       1,     1,     1,     1,     1,     1,     1,     3,     2,     2,
       1,     1,     0,     7,     2,     1,     4,     1,     1,     1,
       3,     1,     7,     5,     9,     8,     1,     2,     6,     5,
       3,     4,     6,     1,     1,     7,     7,     4,     2,     1,
       1,     0,     4,     2,     1,     3,     1,     3,     1,     3,
       4,     4,     1,     1,     1,     1,     1,    11,     6,     1,
       2,     1,     1,     0,     1,     1,     2,     1,     1,     0,
       7,     5,     7,     5,     3,     1,     0,     1,     1,     2,
       1,     2,     1,     2,     1,     1,     1,     3,     1,     3,
       1,     4,     2,     1,     2,     2,     1,     1,     0,     9,
       6,     1,     3,     1,     3,     1,     1,     1,     1,     3,
       3,     3,     3,     3,     3,     1,     3,     1,     3,     1,
       3,     1,     3,     1,     3,     2,     2,     6,     3,     4,
       2,     1,     0,    12,     5,     1,     1,     1,     1,     0,
       3,     5,     1,     0,     5,     5,     3,     1,     1,     0,
       2,     0,    10,     9,     9,     7,     5,     1,     0,     2,
       1,     4,     4,     2,     2,     0,     3,     3,     3,     3,
       1,     1,     1,     1,     5,     2,     0,     3,     1,     3,
       3,     1,     1,     1,     3,     1,     9,    11,     7,     1,
       1,     1,     1,     0,     1,     1,     1,     4,     4,     4,
       3,     1,     7,     7,     2,     1,     1,     2,     1,     1,
       0,     1,     1,     1,     1,     1,     1,     2,     2,     1,
       1,     0,     7,     7,     3,     3,     1,     0,     3,     5,
       1,     0,     5,     5,     1,     0,     1,     1,     4,     1,
       1,     1,     1,     1,     2,     4,     3,     1,     1,     1,
       2,     5,     3,     5,     3,     1,     3,     1,     1,     2,
       1,     1,     0,     3,    11,    11,     3,     3,     0,     1,
       1,     3,     3,     3,     1,     3,     4,     1,     3,     3,
       3,     3,     3,     3,     4,     3,     2,     3,     1,     1,
       3,     3,     3,     1,     3,     5,     5,     3,     1,     7,
       3,     3,     3,     1,     2,     1,     1,     0,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     2,     2,
       2,     1,     0,     1,     3,     3,     3,     3,     3,     3,
       2,     0,     2,     2,     1,     1,     2,     2,     3,     4,
       8,     1,     3,     2,     8,     8,     2,     1,     1,     2,
       1,     1,     0,     1,     1,     1,     0,     1,     1,     1,
       5,     1,     2,     5,     1,     1,     1,     1,     3,     3,
       3,     3,     5,     3,     5,     3,     3,     1,     3,     3,
       3,     3,     2,     1,     1,     0,     1,     3,     4,     4,
       4,     7,     4,     2,     0,     4,     4,     4,     2,     1,
       1,     3,     1,     1,     3,     1,     1,     0,     1,     0,
       1,     0,     1,     0,     1,     0,     1,     0,     1,     0
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
      yyerror (&yylloc, yyscanner, file_path, parse_library_name, YY_("syntax error: cannot back up")); \
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
                  Type, Value, Location, yyscanner, file_path, parse_library_name); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp, yyscan_t yyscanner, const char*file_path, perm_string parse_library_name)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  YYUSE (yylocationp);
  YYUSE (yyscanner);
  YYUSE (file_path);
  YYUSE (parse_library_name);
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
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp, yyscan_t yyscanner, const char*file_path, perm_string parse_library_name)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  YY_LOCATION_PRINT (yyoutput, *yylocationp);
  YYFPRINTF (yyoutput, ": ");
  yy_symbol_value_print (yyoutput, yytype, yyvaluep, yylocationp, yyscanner, file_path, parse_library_name);
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
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, YYLTYPE *yylsp, int yyrule, yyscan_t yyscanner, const char*file_path, perm_string parse_library_name)
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
                       , &(yylsp[(yyi + 1) - (yynrhs)])                       , yyscanner, file_path, parse_library_name);
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, yylsp, Rule, yyscanner, file_path, parse_library_name); \
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
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep, YYLTYPE *yylocationp, yyscan_t yyscanner, const char*file_path, perm_string parse_library_name)
{
  YYUSE (yyvaluep);
  YYUSE (yylocationp);
  YYUSE (yyscanner);
  YYUSE (file_path);
  YYUSE (parse_library_name);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/*----------.
| yyparse.  |
`----------*/

int
yyparse (yyscan_t yyscanner, const char*file_path, perm_string parse_library_name)
{
/* The lookahead symbol.  */
int yychar;


/* The semantic value of the lookahead symbol.  */
/* Default value used for initialization, for pacifying older GCCs
   or non-GCC compilers.  */
YY_INITIAL_VALUE (static YYSTYPE yyval_default;)
YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);

/* Location data for the lookahead symbol.  */
static YYLTYPE yyloc_default
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
  = { 1, 1, 1, 1 }
# endif
;
YYLTYPE yylloc = yyloc_default;

    /* Number of syntax errors so far.  */
    int yynerrs;

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
      yychar = yylex (&yylval, &yylloc, yyscanner);
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
        case 2:
#line 393 "parse.y" /* yacc.c:1663  */
    { yylloc.text = file_path; }
#line 2540 "../parse.cc" /* yacc.c:1663  */
    break;

  case 4:
#line 396 "parse.y" /* yacc.c:1663  */
    { (yyval.arithmetic_op) = ExpArithmetic::PLUS; }
#line 2546 "../parse.cc" /* yacc.c:1663  */
    break;

  case 5:
#line 397 "parse.y" /* yacc.c:1663  */
    { (yyval.arithmetic_op) = ExpArithmetic::MINUS; }
#line 2552 "../parse.cc" /* yacc.c:1663  */
    break;

  case 6:
#line 398 "parse.y" /* yacc.c:1663  */
    { (yyval.arithmetic_op) = ExpArithmetic::xCONCAT; }
#line 2558 "../parse.cc" /* yacc.c:1663  */
    break;

  case 7:
#line 404 "parse.y" /* yacc.c:1663  */
    { bind_entity_to_active_scope((yyvsp[0].text), active_scope); }
#line 2564 "../parse.cc" /* yacc.c:1663  */
    break;

  case 8:
#line 407 "parse.y" /* yacc.c:1663  */
    { Architecture*tmp = new Architecture(lex_strings.make((yyvsp[-11].text)),
					    *active_scope, *(yyvsp[-4].arch_statement_list));
	FILE_NAME(tmp, (yylsp[-11]));
	bind_architecture_to_entity((yyvsp[-9].text), tmp);
	if ((yyvsp[-1].text) && tmp->get_name() != (yyvsp[-1].text))
	      errormsg((yylsp[-11]), "Architecture name doesn't match closing name.\n");
	delete[](yyvsp[-11].text);
	delete[](yyvsp[-9].text);
	delete (yyvsp[-4].arch_statement_list);
	pop_scope();
	assert(arc_scope);
	arc_scope = NULL;
	if ((yyvsp[-1].text)) delete[](yyvsp[-1].text);
      }
#line 2583 "../parse.cc" /* yacc.c:1663  */
    break;

  case 9:
#line 425 "parse.y" /* yacc.c:1663  */
    { (yyval.text) = (yyvsp[0].text);
	push_scope();
	assert(!arc_scope);
	arc_scope = active_scope;
      }
#line 2593 "../parse.cc" /* yacc.c:1663  */
    break;

  case 10:
#line 437 "parse.y" /* yacc.c:1663  */
    { std::list<Architecture::Statement*>*tmp = (yyvsp[-1].arch_statement_list);
	if ((yyvsp[0].arch_statement)) tmp->push_back((yyvsp[0].arch_statement));
	(yyval.arch_statement_list) = tmp;
      }
#line 2602 "../parse.cc" /* yacc.c:1663  */
    break;

  case 11:
#line 442 "parse.y" /* yacc.c:1663  */
    { std::list<Architecture::Statement*>*tmp = new std::list<Architecture::Statement*>;
	if ((yyvsp[0].arch_statement)) tmp->push_back((yyvsp[0].arch_statement));
	(yyval.arch_statement_list) = tmp;
      }
#line 2611 "../parse.cc" /* yacc.c:1663  */
    break;

  case 12:
#line 448 "parse.y" /* yacc.c:1663  */
    { (yyval.arch_statement_list) = 0;
	errormsg((yylsp[-1]), "Syntax error in architecture statement.\n");
	yyerrok;
      }
#line 2620 "../parse.cc" /* yacc.c:1663  */
    break;

  case 13:
#line 454 "parse.y" /* yacc.c:1663  */
    { (yyval.expr_list) = (yyvsp[-1].expr_list); }
#line 2626 "../parse.cc" /* yacc.c:1663  */
    break;

  case 14:
#line 457 "parse.y" /* yacc.c:1663  */
    { (yyval.expr_list) = (yyvsp[0].expr_list); }
#line 2632 "../parse.cc" /* yacc.c:1663  */
    break;

  case 15:
#line 458 "parse.y" /* yacc.c:1663  */
    { (yyval.expr_list) = 0; }
#line 2638 "../parse.cc" /* yacc.c:1663  */
    break;

  case 16:
#line 463 "parse.y" /* yacc.c:1663  */
    { ReportStmt*report = dynamic_cast<ReportStmt*>((yyvsp[0].sequ));
        assert(report);
	AssertStmt*tmp = new AssertStmt((yyvsp[-1].expr), report->message(), report->severity());
        delete report;
	FILE_NAME(tmp,(yylsp[-1]));
	(yyval.sequ) = tmp;
      }
#line 2650 "../parse.cc" /* yacc.c:1663  */
    break;

  case 17:
#line 471 "parse.y" /* yacc.c:1663  */
    { AssertStmt*tmp = new AssertStmt((yyvsp[-2].expr), NULL, (yyvsp[-1].severity));
	FILE_NAME(tmp,(yylsp[-2]));
	(yyval.sequ) = tmp;
      }
#line 2659 "../parse.cc" /* yacc.c:1663  */
    break;

  case 18:
#line 479 "parse.y" /* yacc.c:1663  */
    { named_expr_t*tmp = new named_expr_t(lex_strings.make((yyvsp[-2].text)), (yyvsp[0].expr));
	delete[](yyvsp[-2].text);
	(yyval.named_expr) = tmp;
	}
#line 2668 "../parse.cc" /* yacc.c:1663  */
    break;

  case 19:
#line 484 "parse.y" /* yacc.c:1663  */
    { named_expr_t*tmp = new named_expr_t(lex_strings.make((yyvsp[-2].text)), 0);
	delete[](yyvsp[-2].text);
	(yyval.named_expr) = tmp;
      }
#line 2677 "../parse.cc" /* yacc.c:1663  */
    break;

  case 20:
#line 489 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[0]), "Invalid target for port map association.\n");
	yyerrok;
	(yyval.named_expr) = 0;
      }
#line 2686 "../parse.cc" /* yacc.c:1663  */
    break;

  case 21:
#line 497 "parse.y" /* yacc.c:1663  */
    { std::list<named_expr_t*>*tmp = (yyvsp[-2].named_expr_list);
	tmp->push_back((yyvsp[0].named_expr));
	(yyval.named_expr_list) = tmp;
      }
#line 2695 "../parse.cc" /* yacc.c:1663  */
    break;

  case 22:
#line 502 "parse.y" /* yacc.c:1663  */
    { std::list<named_expr_t*>*tmp = new std::list<named_expr_t*>;
	tmp->push_back((yyvsp[0].named_expr));
	(yyval.named_expr_list) = tmp;
      }
#line 2704 "../parse.cc" /* yacc.c:1663  */
    break;

  case 23:
#line 510 "parse.y" /* yacc.c:1663  */
    { (yyval.entity_aspect) = (yyvsp[-2].entity_aspect);
	if ((yyvsp[-1].named_expr_list)) sorrymsg((yylsp[-1]), "Port map aspect not supported here. (binding_indication)\n");
	if ((yyvsp[0].named_expr_list)) sorrymsg((yylsp[0]), "Generic map aspect not supported here. (binding_indication)\n");
	delete (yyvsp[-1].named_expr_list);
	delete (yyvsp[0].named_expr_list);
      }
#line 2715 "../parse.cc" /* yacc.c:1663  */
    break;

  case 24:
#line 519 "parse.y" /* yacc.c:1663  */
    { (yyval.entity_aspect) = (yyvsp[-1].entity_aspect); }
#line 2721 "../parse.cc" /* yacc.c:1663  */
    break;

  case 25:
#line 520 "parse.y" /* yacc.c:1663  */
    { (yyval.entity_aspect) = 0; }
#line 2727 "../parse.cc" /* yacc.c:1663  */
    break;

  case 26:
#line 528 "parse.y" /* yacc.c:1663  */
    { delete[] (yyvsp[-5].text); }
#line 2733 "../parse.cc" /* yacc.c:1663  */
    break;

  case 29:
#line 539 "parse.y" /* yacc.c:1663  */
    { /* Save the signal declaration in the block_signals map. */
	for (std::list<perm_string>::iterator cur = (yyvsp[-4].name_list)->begin()
		   ; cur != (yyvsp[-4].name_list)->end() ; ++cur) {
	      Signal*sig = new Signal(*cur, (yyvsp[-2].vtype), (yyvsp[-1].expr) ? (yyvsp[-1].expr)->clone() : 0);
	      FILE_NAME(sig, (yylsp[-5]));
	      active_scope->bind_name(*cur, sig);
	}
	delete (yyvsp[-4].name_list);
      }
#line 2747 "../parse.cc" /* yacc.c:1663  */
    break;

  case 37:
#line 566 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Syntax error declaring signals.\n"); yyerrok; }
#line 2753 "../parse.cc" /* yacc.c:1663  */
    break;

  case 38:
#line 568 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Syntax error in block declarations.\n"); yyerrok; }
#line 2759 "../parse.cc" /* yacc.c:1663  */
    break;

  case 43:
#line 591 "parse.y" /* yacc.c:1663  */
    { CaseSeqStmt* tmp = new CaseSeqStmt((yyvsp[-5].expr), (yyvsp[-3].case_alt_list));
	FILE_NAME(tmp, (yylsp[-6]));
	delete (yyvsp[-3].case_alt_list);
	(yyval.sequ) = tmp;
      }
#line 2769 "../parse.cc" /* yacc.c:1663  */
    break;

  case 44:
#line 600 "parse.y" /* yacc.c:1663  */
    { std::list<CaseSeqStmt::CaseStmtAlternative*>* tmp = (yyvsp[-1].case_alt_list);
	tmp->push_back((yyvsp[0].case_alt));
	(yyval.case_alt_list) = tmp;
      }
#line 2778 "../parse.cc" /* yacc.c:1663  */
    break;

  case 45:
#line 605 "parse.y" /* yacc.c:1663  */
    { std::list<CaseSeqStmt::CaseStmtAlternative*>*tmp
		  = new std::list<CaseSeqStmt::CaseStmtAlternative*>();
	tmp->push_back((yyvsp[0].case_alt));
	(yyval.case_alt_list) = tmp;
      }
#line 2788 "../parse.cc" /* yacc.c:1663  */
    break;

  case 46:
#line 620 "parse.y" /* yacc.c:1663  */
    { CaseSeqStmt::CaseStmtAlternative* tmp;
        std::list<ExpAggregate::choice_t*>*choices = (yyvsp[-2].choice_list);
        std::list<Expression*>*exp_list = new std::list<Expression*>;
        bool others = false;

        for(std::list<ExpAggregate::choice_t*>::iterator it = choices->begin();
                it != choices->end(); ++it) {
            if((*it)->others() || others)
                // If there is one "others", then it also covers all other alternatives
                // Continue the loop to delete every choice_t, but do not
                // bother to add the expressions to the exp_list (we are going to
                // delete them very soon)
                others = true;
            else
                exp_list->push_back((*it)->simple_expression());

            delete (*it);
        }

        if(others) {
            tmp = new CaseSeqStmt::CaseStmtAlternative(0, (yyvsp[0].sequ_list));
            for(std::list<Expression*>::iterator it = exp_list->begin();
                    it != exp_list->end(); ++it) {
                delete (*it);
            }
        } else {
            tmp = new CaseSeqStmt::CaseStmtAlternative(exp_list, (yyvsp[0].sequ_list));
        }
        if (tmp) FILE_NAME(tmp, (yylsp[-3]));

        delete choices;
        delete (yyvsp[0].sequ_list);
        (yyval.case_alt) = tmp;
      }
#line 2827 "../parse.cc" /* yacc.c:1663  */
    break;

  case 47:
#line 658 "parse.y" /* yacc.c:1663  */
    { (yyval.choice) = new ExpAggregate::choice_t((yyvsp[0].expr));}
#line 2833 "../parse.cc" /* yacc.c:1663  */
    break;

  case 48:
#line 660 "parse.y" /* yacc.c:1663  */
    { (yyval.choice) = new ExpAggregate::choice_t; }
#line 2839 "../parse.cc" /* yacc.c:1663  */
    break;

  case 49:
#line 662 "parse.y" /* yacc.c:1663  */
    { (yyval.choice) = new ExpAggregate::choice_t((yyvsp[0].range)); }
#line 2845 "../parse.cc" /* yacc.c:1663  */
    break;

  case 50:
#line 667 "parse.y" /* yacc.c:1663  */
    { std::list<ExpAggregate::choice_t*>*tmp = (yyvsp[-2].choice_list);
	tmp->push_back((yyvsp[0].choice));
	(yyval.choice_list) = tmp;
      }
#line 2854 "../parse.cc" /* yacc.c:1663  */
    break;

  case 51:
#line 672 "parse.y" /* yacc.c:1663  */
    { std::list<ExpAggregate::choice_t*>*tmp = new std::list<ExpAggregate::choice_t*>;
	tmp->push_back((yyvsp[0].choice));
	(yyval.choice_list) = tmp;
      }
#line 2863 "../parse.cc" /* yacc.c:1663  */
    break;

  case 52:
#line 683 "parse.y" /* yacc.c:1663  */
    {
    sorrymsg((yylsp[-6]), "Component configuration in not yet supported\n");
    if((yyvsp[-4].entity_aspect)) delete (yyvsp[-4].entity_aspect);
    delete (yyvsp[-5].component_specification);
      }
#line 2873 "../parse.cc" /* yacc.c:1663  */
    break;

  case 53:
#line 689 "parse.y" /* yacc.c:1663  */
    {
    errormsg((yylsp[-4]), "Error in component configuration statement.\n");
    delete (yyvsp[-3].component_specification);
      }
#line 2882 "../parse.cc" /* yacc.c:1663  */
    break;

  case 54:
#line 699 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[-7].text));
	if((yyvsp[-1].text) && name != (yyvsp[-1].text)) {
	      errormsg((yylsp[-1]), "Identifier %s doesn't match component name %s.\n",
		       (yyvsp[-1].text), name.str());
	}

	ComponentBase*comp = new ComponentBase(name);
	comp->set_interface((yyvsp[-5].interface_list), (yyvsp[-4].interface_list));
	if ((yyvsp[-5].interface_list)) delete (yyvsp[-5].interface_list);
	if ((yyvsp[-4].interface_list)) delete (yyvsp[-4].interface_list);

	active_scope->bind_name(name, comp);
	delete[](yyvsp[-7].text);
	if ((yyvsp[-1].text)) delete[] (yyvsp[-1].text);
      }
#line 2902 "../parse.cc" /* yacc.c:1663  */
    break;

  case 55:
#line 716 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-4]), "Syntax error in component declaration.\n");
	delete[] (yyvsp[-6].text);
	if((yyvsp[-1].text)) delete[] (yyvsp[-1].text);
	yyerrok;
      }
#line 2912 "../parse.cc" /* yacc.c:1663  */
    break;

  case 57:
#line 725 "parse.y" /* yacc.c:1663  */
    { (yyval.text) = (yyvsp[0].text); }
#line 2918 "../parse.cc" /* yacc.c:1663  */
    break;

  case 58:
#line 730 "parse.y" /* yacc.c:1663  */
    { perm_string iname = lex_strings.make((yyvsp[-5].text));
	perm_string cname = lex_strings.make((yyvsp[-3].text));
	ComponentInstantiation*tmp = new ComponentInstantiation(iname, cname, (yyvsp[-2].named_expr_list), (yyvsp[-1].named_expr_list));
	delete (yyvsp[-2].named_expr_list);
	delete (yyvsp[-1].named_expr_list);
	FILE_NAME(tmp, (yylsp[-5]));
	delete[](yyvsp[-5].text);
	delete[](yyvsp[-3].text);
	(yyval.arch_statement) = tmp;
      }
#line 2933 "../parse.cc" /* yacc.c:1663  */
    break;

  case 59:
#line 741 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Errors in component instantiation.\n");
	delete[](yyvsp[-4].text);
	delete[](yyvsp[-2].text);
	(yyval.arch_statement) = 0;
      }
#line 2943 "../parse.cc" /* yacc.c:1663  */
    break;

  case 60:
#line 750 "parse.y" /* yacc.c:1663  */
    {
    ExpName* name = dynamic_cast<ExpName*>((yyvsp[0].expr));
    std::pair<instant_list_t*, ExpName*>* tmp = new std::pair<instant_list_t*, ExpName*>((yyvsp[-2].instantiation_list), name);
    (yyval.component_specification) = tmp;
      }
#line 2953 "../parse.cc" /* yacc.c:1663  */
    break;

  case 61:
#line 760 "parse.y" /* yacc.c:1663  */
    { VTypeArray*tmp = new VTypeArray((yyvsp[0].vtype), (yyvsp[-2].range_list));
	delete (yyvsp[-2].range_list);
	(yyval.vtype) = tmp;
      }
#line 2962 "../parse.cc" /* yacc.c:1663  */
    break;

  case 62:
#line 767 "parse.y" /* yacc.c:1663  */
    { std::list<ExpRange*> r;
	// NULL boundaries indicate unbounded array type
	ExpRange*tmp = new ExpRange(NULL, NULL, ExpRange::DOWNTO);
	r.push_back(tmp);
	FILE_NAME(tmp, (yylsp[-5]));
	VTypeArray*arr = new VTypeArray((yyvsp[0].vtype), &r);
	(yyval.vtype) = arr;
      }
#line 2975 "../parse.cc" /* yacc.c:1663  */
    break;

  case 63:
#line 777 "parse.y" /* yacc.c:1663  */
    { (yyval.vtype) = (yyvsp[0].vtype); }
#line 2981 "../parse.cc" /* yacc.c:1663  */
    break;

  case 64:
#line 782 "parse.y" /* yacc.c:1663  */
    {
        /* See more explanations at IEEE 1076-2008 P11.5 */
        std::list<SequentialStmt*> stmts;
        stmts.push_back((yyvsp[0].sequ));
        stmts.push_back(new WaitStmt(WaitStmt::FINAL, NULL));
        push_scope();
        ProcessStatement*tmp = new ProcessStatement(empty_perm_string, *active_scope,
                                                    NULL, &stmts);
        pop_scope();
        FILE_NAME(tmp, (yylsp[0]));
        (yyval.arch_statement) = tmp;
      }
#line 2998 "../parse.cc" /* yacc.c:1663  */
    break;

  case 65:
#line 802 "parse.y" /* yacc.c:1663  */
    { std::list<ExpConditional::case_t*>*options;
        options = (yyvsp[-1].exp_options_list) ? (yyvsp[-1].exp_options_list) : new std::list<ExpConditional::case_t*>;
        options->push_front(new ExpConditional::case_t((yyvsp[-2].expr), (yyvsp[-4].expr_list)));

        ExpName*name = dynamic_cast<ExpName*>((yyvsp[-6].expr));
        assert(name);
        CondSignalAssignment*tmp = new CondSignalAssignment(name, *options);

        FILE_NAME(tmp, (yylsp[-6]));
        delete options;
        (yyval.arch_statement) = tmp;
      }
#line 3015 "../parse.cc" /* yacc.c:1663  */
    break;

  case 66:
#line 818 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-4]), "Syntax error in waveform of conditional signal assignment.\n");
	ExpConditional*tmp = new ExpConditional((yyvsp[-2].expr), 0, (yyvsp[-1].exp_options_list));
	FILE_NAME(tmp, (yylsp[-4]));
	delete (yyvsp[-1].exp_options_list);

        ExpName*name = dynamic_cast<ExpName*> ((yyvsp[-6].expr));
	assert(name);
	SignalAssignment*tmpa = new SignalAssignment(name, tmp);
	FILE_NAME(tmpa, (yylsp[-6]));

	(yyval.arch_statement) = tmpa;
      }
#line 3032 "../parse.cc" /* yacc.c:1663  */
    break;

  case 67:
#line 834 "parse.y" /* yacc.c:1663  */
    { ExpName*name = dynamic_cast<ExpName*> ((yyvsp[-3].expr));
	assert(name);
	SignalAssignment*tmp = new SignalAssignment(name, *(yyvsp[-1].expr_list));
	FILE_NAME(tmp, (yylsp[-3]));

	(yyval.arch_statement) = tmp;
	delete (yyvsp[-1].expr_list);
      }
#line 3045 "../parse.cc" /* yacc.c:1663  */
    break;

  case 68:
#line 845 "parse.y" /* yacc.c:1663  */
    { list<ExpConditional::case_t*>*tmp = (yyvsp[-1].exp_options_list);
	tmp ->push_back((yyvsp[0].exp_options));
	(yyval.exp_options_list) = tmp;
      }
#line 3054 "../parse.cc" /* yacc.c:1663  */
    break;

  case 69:
#line 850 "parse.y" /* yacc.c:1663  */
    { list<ExpConditional::case_t*>*tmp = new list<ExpConditional::case_t*>;
	tmp->push_back((yyvsp[0].exp_options));
	(yyval.exp_options_list) = tmp;
      }
#line 3063 "../parse.cc" /* yacc.c:1663  */
    break;

  case 70:
#line 857 "parse.y" /* yacc.c:1663  */
    { (yyval.exp_options_list) = (yyvsp[0].exp_options_list); }
#line 3069 "../parse.cc" /* yacc.c:1663  */
    break;

  case 71:
#line 858 "parse.y" /* yacc.c:1663  */
    { (yyval.exp_options_list) = 0; }
#line 3075 "../parse.cc" /* yacc.c:1663  */
    break;

  case 72:
#line 864 "parse.y" /* yacc.c:1663  */
    { ExpConditional::case_t*tmp = new ExpConditional::case_t((yyvsp[0].expr), (yyvsp[-2].expr_list));
	FILE_NAME(tmp, (yylsp[-3]));
	(yyval.exp_options) = tmp;
      }
#line 3084 "../parse.cc" /* yacc.c:1663  */
    break;

  case 73:
#line 869 "parse.y" /* yacc.c:1663  */
    { ExpConditional::case_t*tmp = new ExpConditional::case_t(0,  (yyvsp[0].expr_list));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.exp_options) = tmp;
      }
#line 3093 "../parse.cc" /* yacc.c:1663  */
    break;

  case 75:
#line 879 "parse.y" /* yacc.c:1663  */
    { delete[] (yyvsp[-2].text);
	(yyval.arch_statement) = (yyvsp[0].arch_statement);
      }
#line 3101 "../parse.cc" /* yacc.c:1663  */
    break;

  case 77:
#line 886 "parse.y" /* yacc.c:1663  */
    { delete[] (yyvsp[-2].text);
	(yyval.arch_statement) = (yyvsp[0].arch_statement);
      }
#line 3109 "../parse.cc" /* yacc.c:1663  */
    break;

  case 79:
#line 892 "parse.y" /* yacc.c:1663  */
    { (yyval.arch_statement) = (yyvsp[0].arch_statement); }
#line 3115 "../parse.cc" /* yacc.c:1663  */
    break;

  case 80:
#line 895 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-2]), "Syntax error in signal assignment waveform.\n");
	delete (yyvsp[-3].expr);
	(yyval.arch_statement) = 0;
	yyerrok;
      }
#line 3125 "../parse.cc" /* yacc.c:1663  */
    break;

  case 81:
#line 901 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-3]), "Syntax error in l-value of signal assignment.\n");
	yyerrok;
	delete (yyvsp[-1].expr_list);
	(yyval.arch_statement) = 0;
      }
#line 3135 "../parse.cc" /* yacc.c:1663  */
    break;

  case 87:
#line 921 "parse.y" /* yacc.c:1663  */
    {
  if(design_entities.find(lex_strings.make((yyvsp[-7].text))) == design_entities.end())
      errormsg((yylsp[-7]), "Couldn't find entity %s used in configuration declaration\n", (yyvsp[-7].text));
  //choose_architecture_for_entity();
  sorrymsg((yylsp[-10]), "Configuration declaration is not yet supported.\n");
     }
#line 3146 "../parse.cc" /* yacc.c:1663  */
    break;

  case 88:
#line 928 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-4]), "Too many errors, giving up on configuration declaration.\n");
    if((yyvsp[-1].text)) delete (yyvsp[-1].text);
    yyerrok;
      }
#line 3155 "../parse.cc" /* yacc.c:1663  */
    break;

  case 100:
#line 965 "parse.y" /* yacc.c:1663  */
    { // The syntax allows multiple names to have the same type/value.
	for (std::list<perm_string>::iterator cur = (yyvsp[-5].name_list)->begin()
		   ; cur != (yyvsp[-5].name_list)->end() ; ++cur) {
	      active_scope->bind_name(*cur, (yyvsp[-3].vtype), (yyvsp[-1].expr));
	}
	delete (yyvsp[-5].name_list);
      }
#line 3167 "../parse.cc" /* yacc.c:1663  */
    break;

  case 101:
#line 973 "parse.y" /* yacc.c:1663  */
    { sorrymsg((yylsp[-4]), "Deferred constant declarations not supported\n");
	delete (yyvsp[-3].name_list);
      }
#line 3175 "../parse.cc" /* yacc.c:1663  */
    break;

  case 102:
#line 980 "parse.y" /* yacc.c:1663  */
    { // The syntax allows multiple names to have the same type/value.
	errormsg((yylsp[-1]), "Error in value expression for constants.\n");
	yyerrok;
	for (std::list<perm_string>::iterator cur = (yyvsp[-5].name_list)->begin()
		   ; cur != (yyvsp[-5].name_list)->end() ; ++cur) {
	      active_scope->bind_name(*cur, (yyvsp[-3].vtype), 0);
	}
	delete (yyvsp[-5].name_list);
      }
#line 3189 "../parse.cc" /* yacc.c:1663  */
    break;

  case 103:
#line 990 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Syntax error in constant declaration type.\n");
	yyerrok;
	delete (yyvsp[-3].name_list);
      }
#line 3198 "../parse.cc" /* yacc.c:1663  */
    break;

  case 104:
#line 995 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Syntax error in constant declaration.\n");
	yyerrok;
      }
#line 3206 "../parse.cc" /* yacc.c:1663  */
    break;

  case 112:
#line 1016 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[0]), "Invalid design_unit\n"); }
#line 3212 "../parse.cc" /* yacc.c:1663  */
    break;

  case 115:
#line 1025 "parse.y" /* yacc.c:1663  */
    { (yyval.range_dir) = ExpRange::TO; }
#line 3218 "../parse.cc" /* yacc.c:1663  */
    break;

  case 116:
#line 1026 "parse.y" /* yacc.c:1663  */
    { (yyval.range_dir) = ExpRange::DOWNTO; }
#line 3224 "../parse.cc" /* yacc.c:1663  */
    break;

  case 117:
#line 1031 "parse.y" /* yacc.c:1663  */
    { ExpAggregate::element_t*tmp = new ExpAggregate::element_t((yyvsp[-2].choice_list), (yyvsp[0].expr));
	delete (yyvsp[-2].choice_list);
	(yyval.element) = tmp;
      }
#line 3233 "../parse.cc" /* yacc.c:1663  */
    break;

  case 118:
#line 1036 "parse.y" /* yacc.c:1663  */
    { ExpAggregate::element_t*tmp = new ExpAggregate::element_t(0, (yyvsp[0].expr));
	(yyval.element) = tmp;
      }
#line 3241 "../parse.cc" /* yacc.c:1663  */
    break;

  case 119:
#line 1043 "parse.y" /* yacc.c:1663  */
    { std::list<ExpAggregate::element_t*>*tmp = (yyvsp[-2].element_list);
	tmp->push_back((yyvsp[0].element));
	(yyval.element_list) = tmp;
      }
#line 3250 "../parse.cc" /* yacc.c:1663  */
    break;

  case 120:
#line 1048 "parse.y" /* yacc.c:1663  */
    { std::list<ExpAggregate::element_t*>*tmp = new std::list<ExpAggregate::element_t*>;
	tmp->push_back((yyvsp[0].element));
	(yyval.element_list) = tmp;
      }
#line 3259 "../parse.cc" /* yacc.c:1663  */
    break;

  case 121:
#line 1056 "parse.y" /* yacc.c:1663  */
    { (yyval.record_elements) = record_elements((yyvsp[-3].name_list), (yyvsp[-1].vtype));
        delete (yyvsp[-3].name_list);
      }
#line 3267 "../parse.cc" /* yacc.c:1663  */
    break;

  case 122:
#line 1063 "parse.y" /* yacc.c:1663  */
    { (yyval.record_elements) = (yyvsp[-1].record_elements);
	(yyval.record_elements)->splice((yyval.record_elements)->end(), *(yyvsp[0].record_elements));
	delete (yyvsp[0].record_elements);
      }
#line 3276 "../parse.cc" /* yacc.c:1663  */
    break;

  case 123:
#line 1068 "parse.y" /* yacc.c:1663  */
    { (yyval.record_elements) = (yyvsp[0].record_elements); }
#line 3282 "../parse.cc" /* yacc.c:1663  */
    break;

  case 124:
#line 1074 "parse.y" /* yacc.c:1663  */
    {
    ExpName* name = dynamic_cast<ExpName*>((yyvsp[0].expr));
    entity_aspect_t* tmp = new entity_aspect_t(entity_aspect_t::ENTITY, name);
    (yyval.entity_aspect) = tmp;
      }
#line 3292 "../parse.cc" /* yacc.c:1663  */
    break;

  case 125:
#line 1080 "parse.y" /* yacc.c:1663  */
    {
    ExpName* name = dynamic_cast<ExpName*>((yyvsp[0].expr));
    entity_aspect_t* tmp = new entity_aspect_t(entity_aspect_t::CONFIGURATION, name);
    (yyval.entity_aspect) = tmp;
      }
#line 3302 "../parse.cc" /* yacc.c:1663  */
    break;

  case 126:
#line 1086 "parse.y" /* yacc.c:1663  */
    {
    entity_aspect_t* tmp = new entity_aspect_t(entity_aspect_t::OPEN, 0);
    (yyval.entity_aspect) = tmp;
      }
#line 3311 "../parse.cc" /* yacc.c:1663  */
    break;

  case 127:
#line 1093 "parse.y" /* yacc.c:1663  */
    { (yyval.entity_aspect) = (yyvsp[0].entity_aspect); }
#line 3317 "../parse.cc" /* yacc.c:1663  */
    break;

  case 128:
#line 1094 "parse.y" /* yacc.c:1663  */
    { (yyval.entity_aspect) = 0; }
#line 3323 "../parse.cc" /* yacc.c:1663  */
    break;

  case 129:
#line 1101 "parse.y" /* yacc.c:1663  */
    { Entity*tmp = new Entity(lex_strings.make((yyvsp[-7].text)));
	FILE_NAME(tmp, (yylsp[-8]));
	  // Transfer the ports
	tmp->set_interface((yyvsp[-5].interface_list), (yyvsp[-4].interface_list));
	delete (yyvsp[-5].interface_list);
	delete (yyvsp[-4].interface_list);
	  // Save the entity in the entity map.
	design_entities[tmp->get_name()] = tmp;
	delete[](yyvsp[-7].text);
	if((yyvsp[-1].text) && tmp->get_name() != (yyvsp[-1].text)) {
	      errormsg((yylsp[-8]), "Syntax error in entity clause. Closing name doesn't match.\n");
        }
        delete[](yyvsp[-1].text);
      }
#line 3342 "../parse.cc" /* yacc.c:1663  */
    break;

  case 130:
#line 1116 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-5]), "Too many errors, giving up on entity declaration.\n");
	yyerrok;
	if ((yyvsp[-1].text)) delete[](yyvsp[-1].text);
      }
#line 3351 "../parse.cc" /* yacc.c:1663  */
    break;

  case 131:
#line 1124 "parse.y" /* yacc.c:1663  */
    { list<perm_string>*tmp = new list<perm_string>;
	tmp->push_back(lex_strings.make((yyvsp[0].text)));
	delete[](yyvsp[0].text);
	(yyval.name_list) = tmp;
      }
#line 3361 "../parse.cc" /* yacc.c:1663  */
    break;

  case 132:
#line 1133 "parse.y" /* yacc.c:1663  */
    { list<perm_string>*tmp = (yyvsp[-2].name_list);
	list<perm_string>*tmp3 = (yyvsp[0].name_list);
	if (tmp3) {
	      tmp->splice(tmp->end(), *tmp3);
	      delete tmp3;
	}
	(yyval.name_list) = tmp;
      }
#line 3374 "../parse.cc" /* yacc.c:1663  */
    break;

  case 133:
#line 1142 "parse.y" /* yacc.c:1663  */
    { list<perm_string>*tmp = (yyvsp[0].name_list);
	(yyval.name_list) = tmp;
      }
#line 3382 "../parse.cc" /* yacc.c:1663  */
    break;

  case 134:
#line 1149 "parse.y" /* yacc.c:1663  */
    { list<Expression*>*tmp = (yyvsp[-2].expr_list);
	tmp->push_back((yyvsp[0].expr));
	(yyval.expr_list) = tmp;
      }
#line 3391 "../parse.cc" /* yacc.c:1663  */
    break;

  case 135:
#line 1154 "parse.y" /* yacc.c:1663  */
    { list<Expression*>*tmp = new list<Expression*>;
	tmp->push_back((yyvsp[0].expr));
	(yyval.expr_list) = tmp;
      }
#line 3400 "../parse.cc" /* yacc.c:1663  */
    break;

  case 136:
#line 1162 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 3406 "../parse.cc" /* yacc.c:1663  */
    break;

  case 137:
#line 1164 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].range); }
#line 3412 "../parse.cc" /* yacc.c:1663  */
    break;

  case 138:
#line 1191 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 3418 "../parse.cc" /* yacc.c:1663  */
    break;

  case 139:
#line 1193 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::AND, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3427 "../parse.cc" /* yacc.c:1663  */
    break;

  case 140:
#line 1198 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::OR, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3436 "../parse.cc" /* yacc.c:1663  */
    break;

  case 141:
#line 1203 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::XOR, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3445 "../parse.cc" /* yacc.c:1663  */
    break;

  case 142:
#line 1208 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::NAND, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3454 "../parse.cc" /* yacc.c:1663  */
    break;

  case 143:
#line 1213 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::NOR, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3463 "../parse.cc" /* yacc.c:1663  */
    break;

  case 144:
#line 1218 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::XNOR, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3472 "../parse.cc" /* yacc.c:1663  */
    break;

  case 145:
#line 1226 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 3478 "../parse.cc" /* yacc.c:1663  */
    break;

  case 146:
#line 1228 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::AND, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3487 "../parse.cc" /* yacc.c:1663  */
    break;

  case 147:
#line 1236 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 3493 "../parse.cc" /* yacc.c:1663  */
    break;

  case 148:
#line 1238 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::OR, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3502 "../parse.cc" /* yacc.c:1663  */
    break;

  case 149:
#line 1246 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 3508 "../parse.cc" /* yacc.c:1663  */
    break;

  case 150:
#line 1248 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::XNOR, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3517 "../parse.cc" /* yacc.c:1663  */
    break;

  case 151:
#line 1256 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 3523 "../parse.cc" /* yacc.c:1663  */
    break;

  case 152:
#line 1258 "parse.y" /* yacc.c:1663  */
    { ExpLogical*tmp = new ExpLogical(ExpLogical::XOR, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3532 "../parse.cc" /* yacc.c:1663  */
    break;

  case 153:
#line 1266 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 3538 "../parse.cc" /* yacc.c:1663  */
    break;

  case 154:
#line 1268 "parse.y" /* yacc.c:1663  */
    { ExpArithmetic*tmp = new ExpArithmetic(ExpArithmetic::POW, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3547 "../parse.cc" /* yacc.c:1663  */
    break;

  case 155:
#line 1273 "parse.y" /* yacc.c:1663  */
    { ExpUAbs*tmp = new ExpUAbs((yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3556 "../parse.cc" /* yacc.c:1663  */
    break;

  case 156:
#line 1278 "parse.y" /* yacc.c:1663  */
    { ExpUNot*tmp = new ExpUNot((yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 3565 "../parse.cc" /* yacc.c:1663  */
    break;

  case 157:
#line 1286 "parse.y" /* yacc.c:1663  */
    {
	if (strcasecmp((yyvsp[-2].text), "TEXT"))
	      sorrymsg((yylsp[-5]), "file declaration currently handles only TEXT type.\n");

	for (std::list<perm_string>::iterator cur = (yyvsp[-4].name_list)->begin()
		   ; cur != (yyvsp[-4].name_list)->end() ; ++cur) {
	      Variable*var = new Variable(*cur, &primitive_INTEGER);
	      FILE_NAME(var, (yylsp[-5]));
	      active_scope->bind_name(*cur, var);

	      // there was a file name specified, so it needs an implicit call
	      // to open it at the beginning of simulation and close it at the end
	      if((yyvsp[-1].file_info)) {
		std::list<Expression*> params;

		// add file_open() call in 'initial' block
		params.push_back(new ExpScopedName(active_scope->peek_name(), new ExpName(*cur)));
		params.push_back((yyvsp[-1].file_info)->filename()->clone());
		params.push_back((yyvsp[-1].file_info)->kind()->clone());
		ProcedureCall*fopen_call = new ProcedureCall(
                                    perm_string::literal("file_open"), &params);
		arc_scope->add_initializer(fopen_call);

		// add file_close() call in 'final' block
		params.clear();
		params.push_back(new ExpScopedName(active_scope->peek_name(), new ExpName(*cur)));
		ProcedureCall*fclose_call = new ProcedureCall(
                                    perm_string::literal("file_close"), &params);
		arc_scope->add_finalizer(fclose_call);

		delete (yyvsp[-1].file_info);
	      }
	}

	delete (yyvsp[-4].name_list);
      }
#line 3606 "../parse.cc" /* yacc.c:1663  */
    break;

  case 158:
#line 1323 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Syntax error in file declaration.\n");
	yyerrok;
      }
#line 3614 "../parse.cc" /* yacc.c:1663  */
    break;

  case 159:
#line 1330 "parse.y" /* yacc.c:1663  */
    {
        ExpName*mode = new ExpName(lex_strings.make((yyvsp[-2].text)));
        delete[](yyvsp[-2].text);
        FILE_NAME(mode, (yylsp[-3]));
        (yyval.file_info) = new file_open_info_t(new ExpString((yyvsp[0].text)), mode);
     }
#line 3625 "../parse.cc" /* yacc.c:1663  */
    break;

  case 160:
#line 1337 "parse.y" /* yacc.c:1663  */
    {
        (yyval.file_info) = new file_open_info_t(new ExpString((yyvsp[0].text)));
     }
#line 3633 "../parse.cc" /* yacc.c:1663  */
    break;

  case 161:
#line 1342 "parse.y" /* yacc.c:1663  */
    { (yyval.file_info) = (yyvsp[0].file_info); }
#line 3639 "../parse.cc" /* yacc.c:1663  */
    break;

  case 162:
#line 1343 "parse.y" /* yacc.c:1663  */
    { (yyval.file_info) = 0; }
#line 3645 "../parse.cc" /* yacc.c:1663  */
    break;

  case 163:
#line 1350 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[-11].text));
	perm_string gvar = lex_strings.make((yyvsp[-8].text));
	ForGenerate*tmp = new ForGenerate(name, gvar, (yyvsp[-6].range), *(yyvsp[-4].arch_statement_list));
	FILE_NAME(tmp, (yylsp[-11]));

	if ((yyvsp[-1].text) && name != (yyvsp[-1].text)) {
	      errormsg((yylsp[-11]), "for-generate name %s does not match closing name %s\n",
		       name.str(), (yyvsp[-1].text));
	}
	delete[](yyvsp[-11].text);
	delete[](yyvsp[-8].text);
	delete (yyvsp[-4].arch_statement_list);
	delete[](yyvsp[-1].text);
	(yyval.arch_statement) = tmp;
      }
#line 3665 "../parse.cc" /* yacc.c:1663  */
    break;

  case 164:
#line 1369 "parse.y" /* yacc.c:1663  */
    { perm_string type_name = lex_strings.make((yyvsp[0].text));
	perm_string name = lex_strings.make((yyvsp[-3].text));
	const VType*type_mark = active_scope->find_type(type_name);
	touchup_interface_for_functions((yyvsp[-2].interface_list));
	SubprogramHeader*tmp = new SubprogramHeader(name, (yyvsp[-2].interface_list), type_mark);
	FILE_NAME(tmp, (yylsp[-4]));
	delete[](yyvsp[-3].text);
	delete[](yyvsp[0].text);
	(yyval.subprogram) = tmp;
      }
#line 3680 "../parse.cc" /* yacc.c:1663  */
    break;

  case 167:
#line 1387 "parse.y" /* yacc.c:1663  */
    { (yyval.arch_statement_list) = (yyvsp[0].arch_statement_list); }
#line 3686 "../parse.cc" /* yacc.c:1663  */
    break;

  case 168:
#line 1392 "parse.y" /* yacc.c:1663  */
    { (yyval.interface_list) = (yyvsp[0].interface_list);}
#line 3692 "../parse.cc" /* yacc.c:1663  */
    break;

  case 169:
#line 1394 "parse.y" /* yacc.c:1663  */
    { (yyval.interface_list) = 0; }
#line 3698 "../parse.cc" /* yacc.c:1663  */
    break;

  case 170:
#line 1399 "parse.y" /* yacc.c:1663  */
    { (yyval.interface_list) = (yyvsp[-1].interface_list); }
#line 3704 "../parse.cc" /* yacc.c:1663  */
    break;

  case 171:
#line 1401 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-2]), "Error in interface list for generic.\n");
	yyerrok;
	(yyval.interface_list) = 0;
      }
#line 3713 "../parse.cc" /* yacc.c:1663  */
    break;

  case 172:
#line 1408 "parse.y" /* yacc.c:1663  */
    { (yyval.named_expr_list) = (yyvsp[0].named_expr_list); }
#line 3719 "../parse.cc" /* yacc.c:1663  */
    break;

  case 173:
#line 1409 "parse.y" /* yacc.c:1663  */
    { (yyval.named_expr_list) = 0; }
#line 3725 "../parse.cc" /* yacc.c:1663  */
    break;

  case 174:
#line 1414 "parse.y" /* yacc.c:1663  */
    { (yyval.named_expr_list) = (yyvsp[-1].named_expr_list); }
#line 3731 "../parse.cc" /* yacc.c:1663  */
    break;

  case 175:
#line 1416 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Error in association list for generic map.\n");
	yyerrok;
	(yyval.named_expr_list) = 0;
      }
#line 3740 "../parse.cc" /* yacc.c:1663  */
    break;

  case 176:
#line 1424 "parse.y" /* yacc.c:1663  */
    { std::list<perm_string>* tmp = (yyvsp[-2].name_list);
	tmp->push_back(lex_strings.make((yyvsp[0].text)));
	delete[](yyvsp[0].text);
	(yyval.name_list) = tmp;
      }
#line 3750 "../parse.cc" /* yacc.c:1663  */
    break;

  case 177:
#line 1430 "parse.y" /* yacc.c:1663  */
    { std::list<perm_string>*tmp = new std::list<perm_string>;
	tmp->push_back(lex_strings.make((yyvsp[0].text)));
	delete[](yyvsp[0].text);
	(yyval.name_list) = tmp;
      }
#line 3760 "../parse.cc" /* yacc.c:1663  */
    break;

  case 178:
#line 1437 "parse.y" /* yacc.c:1663  */
    { (yyval.text) = (yyvsp[0].text); }
#line 3766 "../parse.cc" /* yacc.c:1663  */
    break;

  case 179:
#line 1437 "parse.y" /* yacc.c:1663  */
    { (yyval.text) = 0; }
#line 3772 "../parse.cc" /* yacc.c:1663  */
    break;

  case 180:
#line 1439 "parse.y" /* yacc.c:1663  */
    { (yyval.text) = (yyvsp[-1].text); }
#line 3778 "../parse.cc" /* yacc.c:1663  */
    break;

  case 181:
#line 1439 "parse.y" /* yacc.c:1663  */
    { (yyval.text) = 0; }
#line 3784 "../parse.cc" /* yacc.c:1663  */
    break;

  case 182:
#line 1449 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[-9].text));
	IfGenerate*tmp = new IfGenerate(name, (yyvsp[-6].expr), *(yyvsp[-4].arch_statement_list));
	FILE_NAME(tmp, (yylsp[-7]));

	if ((yyvsp[-1].text) && name != (yyvsp[-1].text)) {
	      errormsg((yylsp[-9]), "if-generate name %s does not match closing name %s\n",
		       name.str(), (yyvsp[-1].text));
	}
	delete[](yyvsp[-9].text);
	delete  (yyvsp[-4].arch_statement_list);
	delete[](yyvsp[-1].text);
	(yyval.arch_statement) = tmp;
      }
#line 3802 "../parse.cc" /* yacc.c:1663  */
    break;

  case 183:
#line 1468 "parse.y" /* yacc.c:1663  */
    { IfSequential*tmp = new IfSequential((yyvsp[-7].expr), (yyvsp[-5].sequ_list), (yyvsp[-4].elsif_list), (yyvsp[-3].sequ_list));
	FILE_NAME(tmp, (yylsp[-8]));
	delete (yyvsp[-5].sequ_list);
	delete (yyvsp[-4].elsif_list);
	delete (yyvsp[-3].sequ_list);
	(yyval.sequ) = tmp;
      }
#line 3814 "../parse.cc" /* yacc.c:1663  */
    break;

  case 184:
#line 1479 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-7]), "Error in if_statement condition expression.\n");
	yyerrok;
	(yyval.sequ) = 0;
	delete (yyvsp[-5].sequ_list);
      }
#line 3824 "../parse.cc" /* yacc.c:1663  */
    break;

  case 185:
#line 1486 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-3]), "Too many errors in sequence within if_statement.\n");
	yyerrok;
	(yyval.sequ) = 0;
      }
#line 3833 "../parse.cc" /* yacc.c:1663  */
    break;

  case 186:
#line 1492 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-3]), "Too many errors in if_statement.\n");
	yyerrok;
	(yyval.sequ) = 0;
      }
#line 3842 "../parse.cc" /* yacc.c:1663  */
    break;

  case 187:
#line 1499 "parse.y" /* yacc.c:1663  */
    { (yyval.elsif_list) = (yyvsp[0].elsif_list); }
#line 3848 "../parse.cc" /* yacc.c:1663  */
    break;

  case 188:
#line 1500 "parse.y" /* yacc.c:1663  */
    { (yyval.elsif_list) = 0;  }
#line 3854 "../parse.cc" /* yacc.c:1663  */
    break;

  case 189:
#line 1505 "parse.y" /* yacc.c:1663  */
    { list<IfSequential::Elsif*>*tmp = (yyvsp[-1].elsif_list);
	tmp->push_back((yyvsp[0].elsif));
	(yyval.elsif_list) = tmp;
      }
#line 3863 "../parse.cc" /* yacc.c:1663  */
    break;

  case 190:
#line 1510 "parse.y" /* yacc.c:1663  */
    { list<IfSequential::Elsif*>*tmp = new list<IfSequential::Elsif*>;
	tmp->push_back((yyvsp[0].elsif));
	(yyval.elsif_list) = tmp;
      }
#line 3872 "../parse.cc" /* yacc.c:1663  */
    break;

  case 191:
#line 1518 "parse.y" /* yacc.c:1663  */
    { IfSequential::Elsif*tmp = new IfSequential::Elsif((yyvsp[-2].expr), (yyvsp[0].sequ_list));
	FILE_NAME(tmp, (yylsp[-3]));
	delete (yyvsp[0].sequ_list);
	(yyval.elsif) = tmp;
      }
#line 3882 "../parse.cc" /* yacc.c:1663  */
    break;

  case 192:
#line 1524 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[0]), "Too many errors in elsif sub-statements.\n");
	yyerrok;
	(yyval.elsif) = 0;
      }
#line 3891 "../parse.cc" /* yacc.c:1663  */
    break;

  case 193:
#line 1532 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ_list) = (yyvsp[0].sequ_list); }
#line 3897 "../parse.cc" /* yacc.c:1663  */
    break;

  case 194:
#line 1534 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[0]), "Too many errors in else sub-statements.\n");
	yyerrok;
	(yyval.sequ_list) = 0;
      }
#line 3906 "../parse.cc" /* yacc.c:1663  */
    break;

  case 195:
#line 1539 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ_list) = 0; }
#line 3912 "../parse.cc" /* yacc.c:1663  */
    break;

  case 196:
#line 1544 "parse.y" /* yacc.c:1663  */
    { (yyval.range_list) = (yyvsp[-1].range_list); }
#line 3918 "../parse.cc" /* yacc.c:1663  */
    break;

  case 197:
#line 1546 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Errors in the index constraint.\n");
	yyerrok;
	(yyval.range_list) = new list<ExpRange*>;
      }
#line 3927 "../parse.cc" /* yacc.c:1663  */
    break;

  case 201:
#line 1564 "parse.y" /* yacc.c:1663  */
    {
  instant_list_t* tmp = new instant_list_t(instant_list_t::NONE, (yyvsp[0].name_list));
  (yyval.instantiation_list) = tmp;
     }
#line 3936 "../parse.cc" /* yacc.c:1663  */
    break;

  case 202:
#line 1569 "parse.y" /* yacc.c:1663  */
    {
  instant_list_t* tmp = new instant_list_t(instant_list_t::OTHERS, 0);
  (yyval.instantiation_list) = tmp;
     }
#line 3945 "../parse.cc" /* yacc.c:1663  */
    break;

  case 203:
#line 1574 "parse.y" /* yacc.c:1663  */
    {
  instant_list_t* tmp = new instant_list_t(instant_list_t::ALL, 0);
  (yyval.instantiation_list) = tmp;
   }
#line 3954 "../parse.cc" /* yacc.c:1663  */
    break;

  case 204:
#line 1583 "parse.y" /* yacc.c:1663  */
    { std::list<InterfacePort*>*tmp = new std::list<InterfacePort*>;
	for (std::list<perm_string>::iterator cur = (yyvsp[-4].name_list)->begin()
		   ; cur != (yyvsp[-4].name_list)->end() ; ++cur) {
	      InterfacePort*port = new InterfacePort;
	      FILE_NAME(port, (yylsp[-4]));
	      port->mode = (yyvsp[-2].port_mode);
	      port->name = *(cur);
	      port->type = (yyvsp[-1].vtype);
	      port->expr = (yyvsp[0].expr);
	      tmp->push_back(port);
	}
	delete (yyvsp[-4].name_list);
	(yyval.interface_list) = tmp;
      }
#line 3973 "../parse.cc" /* yacc.c:1663  */
    break;

  case 205:
#line 1600 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 3979 "../parse.cc" /* yacc.c:1663  */
    break;

  case 206:
#line 1601 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = 0; }
#line 3985 "../parse.cc" /* yacc.c:1663  */
    break;

  case 207:
#line 1606 "parse.y" /* yacc.c:1663  */
    { std::list<InterfacePort*>*tmp = (yyvsp[-2].interface_list);
	tmp->splice(tmp->end(), *(yyvsp[0].interface_list));
	delete (yyvsp[0].interface_list);
	(yyval.interface_list) = tmp;
      }
#line 3995 "../parse.cc" /* yacc.c:1663  */
    break;

  case 208:
#line 1612 "parse.y" /* yacc.c:1663  */
    { std::list<InterfacePort*>*tmp = (yyvsp[0].interface_list);
	(yyval.interface_list) = tmp;
      }
#line 4003 "../parse.cc" /* yacc.c:1663  */
    break;

  case 209:
#line 1619 "parse.y" /* yacc.c:1663  */
    { library_import((yylsp[-2]), (yyvsp[-1].name_list));
	delete (yyvsp[-1].name_list);
      }
#line 4011 "../parse.cc" /* yacc.c:1663  */
    break;

  case 210:
#line 1623 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-2]), "Syntax error in library clause.\n"); yyerrok; }
#line 4017 "../parse.cc" /* yacc.c:1663  */
    break;

  case 213:
#line 1633 "parse.y" /* yacc.c:1663  */
    { (yyval.text) = (yyvsp[0].text); }
#line 4023 "../parse.cc" /* yacc.c:1663  */
    break;

  case 214:
#line 1637 "parse.y" /* yacc.c:1663  */
    { std::list<perm_string>*tmp = (yyvsp[-2].name_list);
	tmp->push_back(lex_strings.make((yyvsp[0].text)));
	delete[](yyvsp[0].text);
	(yyval.name_list) = tmp;
      }
#line 4033 "../parse.cc" /* yacc.c:1663  */
    break;

  case 215:
#line 1643 "parse.y" /* yacc.c:1663  */
    { std::list<perm_string>*tmp = new std::list<perm_string>;
	tmp->push_back(lex_strings.make((yyvsp[0].text)));
	delete[](yyvsp[0].text);
	(yyval.name_list) = tmp;
      }
#line 4043 "../parse.cc" /* yacc.c:1663  */
    break;

  case 216:
#line 1655 "parse.y" /* yacc.c:1663  */
    { perm_string loop_name = (yyvsp[-8].text)? lex_strings.make((yyvsp[-8].text)) : perm_string() ;
	if ((yyvsp[-1].text) && !(yyvsp[-8].text)) {
	      errormsg((yylsp[-1]), "Loop statement closing name %s for un-named statement\n", (yyvsp[-1].text));
	} else if((yyvsp[-1].text) && loop_name != (yyvsp[-1].text)) {
	      errormsg((yylsp[-8]), "Loop statement name %s doesn't match closing name %s.\n", loop_name.str(), (yyvsp[-1].text));
	}
	if((yyvsp[-8].text)) delete[](yyvsp[-8].text);
	if((yyvsp[-1].text)) delete[](yyvsp[-1].text);

	WhileLoopStatement* tmp = new WhileLoopStatement(loop_name, (yyvsp[-6].expr), (yyvsp[-4].sequ_list));
	FILE_NAME(tmp, (yylsp[-8]));
	(yyval.sequ) = tmp;
      }
#line 4061 "../parse.cc" /* yacc.c:1663  */
    break;

  case 217:
#line 1672 "parse.y" /* yacc.c:1663  */
    { perm_string loop_name = (yyvsp[-10].text)? lex_strings.make((yyvsp[-10].text)) : perm_string() ;
	perm_string index_name = lex_strings.make((yyvsp[-8].text));
	if ((yyvsp[-1].text) && !(yyvsp[-10].text)) {
	      errormsg((yylsp[-1]), "Loop statement closing name %s for un-named statement\n", (yyvsp[-1].text));
	} else if((yyvsp[-1].text) && loop_name != (yyvsp[-1].text)) {
	      errormsg((yylsp[-10]), "Loop statement name %s doesn't match closing name %s.\n", loop_name.str(), (yyvsp[-1].text));
	}
	if((yyvsp[-10].text))  delete[] (yyvsp[-10].text);
	delete[] (yyvsp[-8].text);
	if((yyvsp[-1].text)) delete[] (yyvsp[-1].text);

	ForLoopStatement* tmp = new ForLoopStatement(loop_name, index_name, (yyvsp[-6].range), (yyvsp[-4].sequ_list));
	FILE_NAME(tmp, (yylsp[-10]));
	(yyval.sequ) = tmp;
      }
#line 4081 "../parse.cc" /* yacc.c:1663  */
    break;

  case 218:
#line 1690 "parse.y" /* yacc.c:1663  */
    { perm_string loop_name = (yyvsp[-6].text)? lex_strings.make((yyvsp[-6].text)) : perm_string() ;
	if ((yyvsp[-1].text) && !(yyvsp[-6].text)) {
	      errormsg((yylsp[-1]), "Loop statement closing name %s for un-named statement\n", (yyvsp[-1].text));
	} else if((yyvsp[-1].text) && loop_name != (yyvsp[-1].text)) {
	      errormsg((yylsp[-6]), "Loop statement name %s doesn't match closing name %s.\n", loop_name.str(), (yyvsp[-1].text));
	}
	if((yyvsp[-6].text)) delete[](yyvsp[-6].text);
	if((yyvsp[-1].text)) delete[](yyvsp[-1].text);

	BasicLoopStatement* tmp = new BasicLoopStatement(loop_name, (yyvsp[-4].sequ_list));
	FILE_NAME(tmp, (yylsp[-5]));

	(yyval.sequ) = tmp;
      }
#line 4100 "../parse.cc" /* yacc.c:1663  */
    break;

  case 219:
#line 1706 "parse.y" /* yacc.c:1663  */
    { (yyval.port_mode) = PORT_IN; }
#line 4106 "../parse.cc" /* yacc.c:1663  */
    break;

  case 220:
#line 1707 "parse.y" /* yacc.c:1663  */
    { (yyval.port_mode) = PORT_OUT; }
#line 4112 "../parse.cc" /* yacc.c:1663  */
    break;

  case 221:
#line 1708 "parse.y" /* yacc.c:1663  */
    { (yyval.port_mode) = PORT_INOUT; }
#line 4118 "../parse.cc" /* yacc.c:1663  */
    break;

  case 222:
#line 1711 "parse.y" /* yacc.c:1663  */
    {(yyval.port_mode) = (yyvsp[0].port_mode);}
#line 4124 "../parse.cc" /* yacc.c:1663  */
    break;

  case 223:
#line 1711 "parse.y" /* yacc.c:1663  */
    {(yyval.port_mode) = PORT_NONE;}
#line 4130 "../parse.cc" /* yacc.c:1663  */
    break;

  case 224:
#line 1715 "parse.y" /* yacc.c:1663  */
    { Expression*tmp;
        /* Check if the IDENTIFIER is one of CHARACTER enums (LF, CR, etc.) */
        tmp = parse_char_enums((yyvsp[0].text));
        if(!tmp) {
            perm_string name = lex_strings.make((yyvsp[0].text));
            /* There are functions that have the same name types, e.g. integer */
            if(!active_scope->find_subprogram(name).empty() && !parse_type_by_name(name))
                tmp = new ExpFunc(name);
            else
                tmp = new ExpName(name);
        }
        FILE_NAME(tmp, (yylsp[0]));
        delete[](yyvsp[0].text);
        (yyval.expr) = tmp;
      }
#line 4150 "../parse.cc" /* yacc.c:1663  */
    break;

  case 225:
#line 1732 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 4156 "../parse.cc" /* yacc.c:1663  */
    break;

  case 226:
#line 1735 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 4162 "../parse.cc" /* yacc.c:1663  */
    break;

  case 227:
#line 1738 "parse.y" /* yacc.c:1663  */
    {
        ExpName*name = dynamic_cast<ExpName*>((yyvsp[-3].expr));
        assert(name);
        name->add_index((yyvsp[-1].expr_list));
        delete (yyvsp[-1].expr_list);  // contents of the list is moved to the selected_name
    }
#line 4173 "../parse.cc" /* yacc.c:1663  */
    break;

  case 228:
#line 1752 "parse.y" /* yacc.c:1663  */
    { Expression*tmp;
        perm_string name = lex_strings.make((yyvsp[-3].text));
        delete[](yyvsp[-3].text);
        if (active_scope->is_vector_name(name) || is_subprogram_param(name))
            tmp = new ExpName(name, (yyvsp[-1].expr_list));
        else
            tmp = new ExpFunc(name, (yyvsp[-1].expr_list));
        FILE_NAME(tmp, (yylsp[-3]));
        (yyval.expr) = tmp;
      }
#line 4188 "../parse.cc" /* yacc.c:1663  */
    break;

  case 229:
#line 1763 "parse.y" /* yacc.c:1663  */
    { ExpName*name = dynamic_cast<ExpName*>((yyvsp[-3].expr));
        assert(name);
        name->add_index((yyvsp[-1].expr_list));
        (yyval.expr) = (yyvsp[-3].expr);
      }
#line 4198 "../parse.cc" /* yacc.c:1663  */
    break;

  case 230:
#line 1773 "parse.y" /* yacc.c:1663  */
    { std::list<Expression*>*tmp = (yyvsp[-2].expr_list);
	tmp->push_back((yyvsp[0].expr));
	(yyval.expr_list) = tmp;
      }
#line 4207 "../parse.cc" /* yacc.c:1663  */
    break;

  case 231:
#line 1778 "parse.y" /* yacc.c:1663  */
    { std::list<Expression*>*tmp = new std::list<Expression*>;
	tmp->push_back((yyvsp[0].expr));
	(yyval.expr_list) = tmp;
      }
#line 4216 "../parse.cc" /* yacc.c:1663  */
    break;

  case 232:
#line 1788 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[-6].text));
	if((yyvsp[-1].text) && name != (yyvsp[-1].text)) {
	      errormsg((yylsp[-6]), "Identifier %s doesn't match package name %s.\n",
		       (yyvsp[-1].text), name.str());
        }
	Package*tmp = new Package(name, *active_scope);
	FILE_NAME(tmp, (yylsp[-6]));
	delete[](yyvsp[-6].text);
        if ((yyvsp[-1].text)) delete[](yyvsp[-1].text);
	pop_scope();
	  /* Put this package into the work library, or the currently
	     parsed library. Note that parse_library_name is an
	     argument to the parser. */
	library_save_package(parse_library_name, tmp);
      }
#line 4236 "../parse.cc" /* yacc.c:1663  */
    break;

  case 233:
#line 1804 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-4]), "Syntax error in package clause.\n");
      yyerrok;
      pop_scope();
    }
#line 4245 "../parse.cc" /* yacc.c:1663  */
    break;

  case 234:
#line 1812 "parse.y" /* yacc.c:1663  */
    { push_scope();
	(yyval.text) = (yyvsp[0].text);
      }
#line 4253 "../parse.cc" /* yacc.c:1663  */
    break;

  case 247:
#line 1841 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Syntax error in package declarative item.\n");
	yyerrok;
      }
#line 4261 "../parse.cc" /* yacc.c:1663  */
    break;

  case 252:
#line 1860 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[-6].text));
	if ((yyvsp[-1].text) && name != (yyvsp[-1].text))
	      errormsg((yylsp[-1]), "Package name (%s) doesn't match closing name (%s).\n", (yyvsp[-6].text), (yyvsp[-1].text));
	delete[] (yyvsp[-6].text);
	if((yyvsp[-1].text)) delete[](yyvsp[-1].text);
	pop_scope();
      }
#line 4273 "../parse.cc" /* yacc.c:1663  */
    break;

  case 253:
#line 1869 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-6]), "Errors in package %s body.\n", (yyvsp[-6].text));
	yyerrok;
	pop_scope();
      }
#line 4282 "../parse.cc" /* yacc.c:1663  */
    break;

  case 254:
#line 1881 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[0].text));
	push_scope();
	Package*pkg = library_recall_package(parse_library_name, name);
	if (pkg != 0) {
	      active_scope->set_package_header(pkg);
	} else {
	      errormsg((yylsp[-2]), "Package body for %s has no matching header.\n", (yyvsp[0].text));
	}
	(yyval.text) = (yyvsp[0].text);
      }
#line 4297 "../parse.cc" /* yacc.c:1663  */
    break;

  case 255:
#line 1894 "parse.y" /* yacc.c:1663  */
    { (yyval.interface_list) = (yyvsp[-1].interface_list); }
#line 4303 "../parse.cc" /* yacc.c:1663  */
    break;

  case 256:
#line 1898 "parse.y" /* yacc.c:1663  */
    { (yyval.interface_list) = (yyvsp[0].interface_list); }
#line 4309 "../parse.cc" /* yacc.c:1663  */
    break;

  case 257:
#line 1899 "parse.y" /* yacc.c:1663  */
    { (yyval.interface_list) = 0; }
#line 4315 "../parse.cc" /* yacc.c:1663  */
    break;

  case 258:
#line 1904 "parse.y" /* yacc.c:1663  */
    { (yyval.interface_list) = (yyvsp[-1].interface_list); }
#line 4321 "../parse.cc" /* yacc.c:1663  */
    break;

  case 259:
#line 1906 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-4]), "Syntax error in port list.\n");
	yyerrok;
	(yyval.interface_list) = 0;
      }
#line 4330 "../parse.cc" /* yacc.c:1663  */
    break;

  case 260:
#line 1912 "parse.y" /* yacc.c:1663  */
    {(yyval.interface_list) = (yyvsp[0].interface_list);}
#line 4336 "../parse.cc" /* yacc.c:1663  */
    break;

  case 261:
#line 1912 "parse.y" /* yacc.c:1663  */
    {(yyval.interface_list) = 0;}
#line 4342 "../parse.cc" /* yacc.c:1663  */
    break;

  case 262:
#line 1916 "parse.y" /* yacc.c:1663  */
    { (yyval.named_expr_list) = (yyvsp[-1].named_expr_list); }
#line 4348 "../parse.cc" /* yacc.c:1663  */
    break;

  case 263:
#line 1918 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-4]), "Syntax error in port map aspect.\n");
	yyerrok;
      }
#line 4356 "../parse.cc" /* yacc.c:1663  */
    break;

  case 264:
#line 1924 "parse.y" /* yacc.c:1663  */
    { (yyval.named_expr_list) = (yyvsp[0].named_expr_list); }
#line 4362 "../parse.cc" /* yacc.c:1663  */
    break;

  case 265:
#line 1925 "parse.y" /* yacc.c:1663  */
    { (yyval.named_expr_list) = 0; }
#line 4368 "../parse.cc" /* yacc.c:1663  */
    break;

  case 266:
#line 1931 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 4374 "../parse.cc" /* yacc.c:1663  */
    break;

  case 267:
#line 1936 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 4380 "../parse.cc" /* yacc.c:1663  */
    break;

  case 268:
#line 1938 "parse.y" /* yacc.c:1663  */
    { ExpAttribute*tmp = NULL;
	perm_string attr = lex_strings.make((yyvsp[-1].text));
	ExpName*base = dynamic_cast<ExpName*>((yyvsp[-3].expr));
	const VType*type = parse_type_by_name(base->peek_name());

	if(type) {
	    tmp = new ExpTypeAttribute(type, attr, (yyvsp[0].expr_list));
	} else {
	    tmp = new ExpObjAttribute(base, attr, (yyvsp[0].expr_list));
	}

	FILE_NAME(tmp, (yylsp[-3]));
	delete[](yyvsp[-1].text);
	(yyval.expr) = tmp;
      }
#line 4400 "../parse.cc" /* yacc.c:1663  */
    break;

  case 269:
#line 1954 "parse.y" /* yacc.c:1663  */
    { ExpCharacter*tmp = new ExpCharacter((yyvsp[0].text)[0]);
	FILE_NAME(tmp,(yylsp[0]));
	delete[](yyvsp[0].text);
	(yyval.expr) = tmp;
      }
#line 4410 "../parse.cc" /* yacc.c:1663  */
    break;

  case 270:
#line 1960 "parse.y" /* yacc.c:1663  */
    { ExpInteger*tmp = new ExpInteger((yyvsp[0].uni_integer));
	FILE_NAME(tmp, (yylsp[0]));
	(yyval.expr) = tmp;
      }
#line 4419 "../parse.cc" /* yacc.c:1663  */
    break;

  case 271:
#line 1965 "parse.y" /* yacc.c:1663  */
    { ExpReal*tmp = new ExpReal((yyvsp[0].uni_real));
	FILE_NAME(tmp, (yylsp[0]));
	(yyval.expr) = tmp;
      }
#line 4428 "../parse.cc" /* yacc.c:1663  */
    break;

  case 272:
#line 1970 "parse.y" /* yacc.c:1663  */
    { ExpString*tmp = new ExpString((yyvsp[0].text));
	FILE_NAME(tmp,(yylsp[0]));
	delete[](yyvsp[0].text);
	(yyval.expr) = tmp;
      }
#line 4438 "../parse.cc" /* yacc.c:1663  */
    break;

  case 273:
#line 1976 "parse.y" /* yacc.c:1663  */
    { ExpBitstring*tmp = new ExpBitstring((yyvsp[0].text));
	FILE_NAME(tmp, (yylsp[0]));
	delete[](yyvsp[0].text);
	(yyval.expr) = tmp;
      }
#line 4448 "../parse.cc" /* yacc.c:1663  */
    break;

  case 274:
#line 1982 "parse.y" /* yacc.c:1663  */
    { ExpTime::timeunit_t unit = ExpTime::FS;

        if(!strcasecmp((yyvsp[0].text), "us"))
            unit = ExpTime::US;
        else if(!strcasecmp((yyvsp[0].text), "ms"))
            unit = ExpTime::MS;
        else if(!strcasecmp((yyvsp[0].text), "ns"))
            unit = ExpTime::NS;
        else if(!strcasecmp((yyvsp[0].text), "s"))
            unit = ExpTime::S;
        else if(!strcasecmp((yyvsp[0].text), "ps"))
            unit = ExpTime::PS;
        else if(!strcasecmp((yyvsp[0].text), "fs"))
            unit = ExpTime::FS;
        else
            errormsg((yylsp[0]), "Invalid time unit (accepted are fs, ps, ns, us, ms, s).\n");

        if((yyvsp[-1].uni_integer) < 0)
            errormsg((yylsp[-1]), "Time cannot be negative.\n");

        ExpTime*tmp = new ExpTime((yyvsp[-1].uni_integer), unit);
        FILE_NAME(tmp, (yylsp[-1]));
        delete[] (yyvsp[0].text);
        (yyval.expr) = tmp;
      }
#line 4478 "../parse.cc" /* yacc.c:1663  */
    break;

  case 275:
#line 2017 "parse.y" /* yacc.c:1663  */
    { sorrymsg((yylsp[-3]), "Function calls not supported\n");
	delete[] (yyvsp[-3].text);
	(yyval.expr) = 0;
      }
#line 4487 "../parse.cc" /* yacc.c:1663  */
    break;

  case 276:
#line 2025 "parse.y" /* yacc.c:1663  */
    { Expression*tmp = aggregate_or_primary((yylsp[-2]), (yyvsp[-1].element_list));
	(yyval.expr) = tmp;
      }
#line 4495 "../parse.cc" /* yacc.c:1663  */
    break;

  case 280:
#line 2038 "parse.y" /* yacc.c:1663  */
    {
    ProcedureCall* tmp = new ProcedureCall(lex_strings.make((yyvsp[-1].text)));
    FILE_NAME(tmp, (yylsp[-1]));
    delete[] (yyvsp[-1].text);
    (yyval.sequ) = tmp;
      }
#line 4506 "../parse.cc" /* yacc.c:1663  */
    break;

  case 281:
#line 2045 "parse.y" /* yacc.c:1663  */
    {
    ProcedureCall* tmp = new ProcedureCall(lex_strings.make((yyvsp[-4].text)), (yyvsp[-2].named_expr_list));
    FILE_NAME(tmp, (yylsp[-4]));
    delete[] (yyvsp[-4].text);
    (yyval.sequ) = tmp;
      }
#line 4517 "../parse.cc" /* yacc.c:1663  */
    break;

  case 282:
#line 2052 "parse.y" /* yacc.c:1663  */
    {
    ProcedureCall* tmp = new ProcedureCall(lex_strings.make((yyvsp[-2].text)), (yyvsp[-1].expr_list));
    FILE_NAME(tmp, (yylsp[-2]));
    delete[] (yyvsp[-2].text);
    delete (yyvsp[-1].expr_list); // parameters are copied in this variant
    (yyval.sequ) = tmp;
      }
#line 4529 "../parse.cc" /* yacc.c:1663  */
    break;

  case 283:
#line 2060 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-4]), "Errors in procedure call.\n");
	yyerrok;
	delete[](yyvsp[-4].text);
	(yyval.sequ) = 0;
      }
#line 4539 "../parse.cc" /* yacc.c:1663  */
    break;

  case 284:
#line 2069 "parse.y" /* yacc.c:1663  */
    { delete[] (yyvsp[-2].text);
	(yyval.sequ) = (yyvsp[0].sequ);
      }
#line 4547 "../parse.cc" /* yacc.c:1663  */
    break;

  case 285:
#line 2072 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 4553 "../parse.cc" /* yacc.c:1663  */
    break;

  case 286:
#line 2077 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[-1].text));
	touchup_interface_for_functions((yyvsp[0].interface_list));
	SubprogramHeader*tmp = new SubprogramHeader(name, (yyvsp[0].interface_list), NULL);
	FILE_NAME(tmp, (yylsp[-2]));
	delete[](yyvsp[-1].text);
	(yyval.subprogram) = tmp;
      }
#line 4565 "../parse.cc" /* yacc.c:1663  */
    break;

  case 293:
#line 2103 "parse.y" /* yacc.c:1663  */
    { push_scope();
         (yyval.text) = (yyvsp[-2].text);
       }
#line 4573 "../parse.cc" /* yacc.c:1663  */
    break;

  case 294:
#line 2113 "parse.y" /* yacc.c:1663  */
    { perm_string iname = (yyvsp[-10].text)? lex_strings.make((yyvsp[-10].text)) : empty_perm_string;
	if ((yyvsp[-10].text)) delete[](yyvsp[-10].text);
	if ((yyvsp[-1].text)) {
	      if (iname.nil()) {
		    errormsg((yylsp[-1]), "Process end name %s for un-named processes.\n", (yyvsp[-1].text));
	      } else if (iname != (yyvsp[-1].text)) {
		    errormsg((yylsp[-1]), "Process name %s does not match opening name %s.\n",
			     (yyvsp[-1].text), (yyvsp[-10].text));
	      }
	      delete[](yyvsp[-1].text);
	}

	ProcessStatement*tmp = new ProcessStatement(iname, *active_scope, (yyvsp[-9].expr_list), (yyvsp[-5].sequ_list));
        arc_scope->bind_scope(tmp->peek_name(), tmp);
        pop_scope();
	FILE_NAME(tmp, (yylsp[-8]));
	delete (yyvsp[-9].expr_list);
	delete (yyvsp[-5].sequ_list);
	(yyval.arch_statement) = tmp;
      }
#line 4598 "../parse.cc" /* yacc.c:1663  */
    break;

  case 295:
#line 2138 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-4]), "Too many errors in process sequential statements.\n");
	yyerrok;
	(yyval.arch_statement) = 0;
      }
#line 4607 "../parse.cc" /* yacc.c:1663  */
    break;

  case 296:
#line 2151 "parse.y" /* yacc.c:1663  */
    { (yyval.expr_list) = (yyvsp[-1].expr_list); }
#line 4613 "../parse.cc" /* yacc.c:1663  */
    break;

  case 297:
#line 2153 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Error in process sensitivity list\n");
	yyerrok;
	(yyval.expr_list) = 0;
      }
#line 4622 "../parse.cc" /* yacc.c:1663  */
    break;

  case 298:
#line 2158 "parse.y" /* yacc.c:1663  */
    { (yyval.expr_list) = 0; }
#line 4628 "../parse.cc" /* yacc.c:1663  */
    break;

  case 299:
#line 2163 "parse.y" /* yacc.c:1663  */
    { std::list<Expression*>*tmp = new std::list<Expression*>;
	ExpName*all = new ExpNameALL;
	FILE_NAME(all, (yylsp[0]));
	tmp->push_back(all);
	(yyval.expr_list) = tmp;
      }
#line 4639 "../parse.cc" /* yacc.c:1663  */
    break;

  case 300:
#line 2170 "parse.y" /* yacc.c:1663  */
    { (yyval.expr_list) = (yyvsp[0].expr_list); }
#line 4645 "../parse.cc" /* yacc.c:1663  */
    break;

  case 301:
#line 2175 "parse.y" /* yacc.c:1663  */
    { ExpRange* tmp = new ExpRange((yyvsp[-2].expr), (yyvsp[0].expr), (yyvsp[-1].range_dir));
	FILE_NAME(tmp, (yylsp[-2]));
	(yyval.range) = tmp;
      }
#line 4654 "../parse.cc" /* yacc.c:1663  */
    break;

  case 302:
#line 2180 "parse.y" /* yacc.c:1663  */
    {
        ExpRange*tmp = NULL;
        ExpName*name = NULL;
        if((name = dynamic_cast<ExpName*>((yyvsp[-2].expr)))) {
            tmp = new ExpRange(name, false);
            FILE_NAME(tmp, (yylsp[-2]));
        } else {
	    errormsg((yylsp[-2]), "'range attribute can be used with named expressions only");
        }
        (yyval.range) = tmp;
      }
#line 4670 "../parse.cc" /* yacc.c:1663  */
    break;

  case 303:
#line 2192 "parse.y" /* yacc.c:1663  */
    {
        ExpRange*tmp = NULL;
        ExpName*name = NULL;
        if((name = dynamic_cast<ExpName*>((yyvsp[-2].expr)))) {
            tmp = new ExpRange(name, true);
            FILE_NAME(tmp, (yylsp[-2]));
        } else {
	    errormsg((yylsp[-2]), "'reverse_range attribute can be used with named expressions only");
        }
        (yyval.range) = tmp;
      }
#line 4686 "../parse.cc" /* yacc.c:1663  */
    break;

  case 304:
#line 2207 "parse.y" /* yacc.c:1663  */
    { list<ExpRange*>*tmp = new list<ExpRange*>;
	tmp->push_back((yyvsp[0].range));
	(yyval.range_list) = tmp;
      }
#line 4695 "../parse.cc" /* yacc.c:1663  */
    break;

  case 305:
#line 2212 "parse.y" /* yacc.c:1663  */
    { list<ExpRange*>*tmp = (yyvsp[-2].range_list);
	tmp->push_back((yyvsp[0].range));
	(yyval.range_list) = tmp;
      }
#line 4704 "../parse.cc" /* yacc.c:1663  */
    break;

  case 306:
#line 2220 "parse.y" /* yacc.c:1663  */
    { VTypeRecord*tmp = new VTypeRecord((yyvsp[-2].record_elements));
	(yyval.vtype) = tmp;
      }
#line 4712 "../parse.cc" /* yacc.c:1663  */
    break;

  case 307:
#line 2227 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 4718 "../parse.cc" /* yacc.c:1663  */
    break;

  case 308:
#line 2229 "parse.y" /* yacc.c:1663  */
    { ExpRelation*tmp = new ExpRelation(ExpRelation::EQ, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 4727 "../parse.cc" /* yacc.c:1663  */
    break;

  case 309:
#line 2234 "parse.y" /* yacc.c:1663  */
    { ExpRelation*tmp = new ExpRelation(ExpRelation::LT, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 4736 "../parse.cc" /* yacc.c:1663  */
    break;

  case 310:
#line 2239 "parse.y" /* yacc.c:1663  */
    { ExpRelation*tmp = new ExpRelation(ExpRelation::GT, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 4745 "../parse.cc" /* yacc.c:1663  */
    break;

  case 311:
#line 2244 "parse.y" /* yacc.c:1663  */
    { ExpRelation*tmp = new ExpRelation(ExpRelation::LE, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 4754 "../parse.cc" /* yacc.c:1663  */
    break;

  case 312:
#line 2249 "parse.y" /* yacc.c:1663  */
    { ExpRelation*tmp = new ExpRelation(ExpRelation::GE, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 4763 "../parse.cc" /* yacc.c:1663  */
    break;

  case 313:
#line 2254 "parse.y" /* yacc.c:1663  */
    { ExpRelation*tmp = new ExpRelation(ExpRelation::NEQ, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 4772 "../parse.cc" /* yacc.c:1663  */
    break;

  case 314:
#line 2262 "parse.y" /* yacc.c:1663  */
    { ReportStmt*tmp = new ReportStmt((yyvsp[-2].expr), (yyvsp[-1].severity));
	FILE_NAME(tmp,(yylsp[-2]));
	(yyval.sequ) = tmp;
      }
#line 4781 "../parse.cc" /* yacc.c:1663  */
    break;

  case 315:
#line 2269 "parse.y" /* yacc.c:1663  */
    { ReturnStmt*tmp = new ReturnStmt((yyvsp[-1].expr));
	FILE_NAME(tmp, (yylsp[-2]));
	(yyval.sequ) = tmp;
      }
#line 4790 "../parse.cc" /* yacc.c:1663  */
    break;

  case 316:
#line 2274 "parse.y" /* yacc.c:1663  */
    { ReturnStmt*tmp = new ReturnStmt(0);
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.sequ) = tmp;
      }
#line 4799 "../parse.cc" /* yacc.c:1663  */
    break;

  case 317:
#line 2279 "parse.y" /* yacc.c:1663  */
    { ReturnStmt*tmp = new ReturnStmt(0);
	FILE_NAME(tmp, (yylsp[-2]));
	(yyval.sequ) = tmp;
	errormsg((yylsp[-1]), "Error in expression in return statement.\n");
	yyerrok;
      }
#line 4810 "../parse.cc" /* yacc.c:1663  */
    break;

  case 320:
#line 2294 "parse.y" /* yacc.c:1663  */
    { Expression*pfx = (yyvsp[-2].expr);
	ExpName*pfx1 = dynamic_cast<ExpName*>(pfx);
	assert(pfx1);
	perm_string tmp = lex_strings.make((yyvsp[0].text));
	(yyval.expr) = new ExpName(pfx1, tmp);
	FILE_NAME((yyval.expr), (yylsp[0]));
	delete[](yyvsp[0].text);
      }
#line 4823 "../parse.cc" /* yacc.c:1663  */
    break;

  case 321:
#line 2303 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-2]), "Syntax error in prefix in front of \"%s\".\n", (yyvsp[0].text));
        yyerrok;
	(yyval.expr) = new ExpName(lex_strings.make((yyvsp[0].text)));
	FILE_NAME((yyval.expr), (yylsp[0]));
	delete[](yyvsp[0].text);
      }
#line 4834 "../parse.cc" /* yacc.c:1663  */
    break;

  case 322:
#line 2313 "parse.y" /* yacc.c:1663  */
    { std::list<Expression*>* tmp = (yyvsp[-2].expr_list);
	tmp->push_back((yyvsp[0].expr));
	(yyval.expr_list) = tmp;
      }
#line 4843 "../parse.cc" /* yacc.c:1663  */
    break;

  case 323:
#line 2318 "parse.y" /* yacc.c:1663  */
    { std::list<Expression*>* tmp = new std::list<Expression*>();
	tmp->push_back((yyvsp[0].expr));
	(yyval.expr_list) = tmp;
      }
#line 4852 "../parse.cc" /* yacc.c:1663  */
    break;

  case 324:
#line 2329 "parse.y" /* yacc.c:1663  */
    { library_use((yylsp[-2]), active_scope, 0, (yyvsp[-2].text), 0);
	delete[](yyvsp[-2].text);
      }
#line 4860 "../parse.cc" /* yacc.c:1663  */
    break;

  case 325:
#line 2333 "parse.y" /* yacc.c:1663  */
    { library_use((yylsp[-4]), active_scope, (yyvsp[-4].text), (yyvsp[-2].text), 0);
	delete[](yyvsp[-4].text);
	delete[](yyvsp[-2].text);
      }
#line 4869 "../parse.cc" /* yacc.c:1663  */
    break;

  case 326:
#line 2338 "parse.y" /* yacc.c:1663  */
    { library_use((yylsp[-4]), active_scope, (yyvsp[-4].text), (yyvsp[-2].text), (yyvsp[0].text));
	delete[](yyvsp[-4].text);
	delete[](yyvsp[-2].text);
	delete[](yyvsp[0].text);
      }
#line 4879 "../parse.cc" /* yacc.c:1663  */
    break;

  case 329:
#line 2352 "parse.y" /* yacc.c:1663  */
    { ExpSelected*tmp = new ExpSelected((yyvsp[-5].expr), (yyvsp[-1].exp_options_list));
	FILE_NAME(tmp, (yylsp[-4]));
        delete (yyvsp[-5].expr);
	delete (yyvsp[-1].exp_options_list);

	ExpName*name = dynamic_cast<ExpName*>((yyvsp[-3].expr));
	assert(name);
	SignalAssignment*tmpa = new SignalAssignment(name, tmp);
	FILE_NAME(tmpa, (yylsp[-6]));

	(yyval.arch_statement) = tmpa;
      }
#line 4896 "../parse.cc" /* yacc.c:1663  */
    break;

  case 330:
#line 2368 "parse.y" /* yacc.c:1663  */
    { ExpConditional::case_t*tmp = new ExpConditional::case_t((yyvsp[0].expr), (yyvsp[-2].expr_list));
	FILE_NAME(tmp, (yylsp[-2]));
	(yyval.exp_options) = tmp;
      }
#line 4905 "../parse.cc" /* yacc.c:1663  */
    break;

  case 331:
#line 2373 "parse.y" /* yacc.c:1663  */
    { ExpConditional::case_t*tmp = new ExpConditional::case_t(0,  (yyvsp[-2].expr_list));
	FILE_NAME(tmp, (yylsp[-2]));
	(yyval.exp_options) = tmp;
      }
#line 4914 "../parse.cc" /* yacc.c:1663  */
    break;

  case 332:
#line 2381 "parse.y" /* yacc.c:1663  */
    { list<ExpConditional::case_t*>*tmp = (yyvsp[-2].exp_options_list);
	tmp->push_back((yyvsp[0].exp_options));
	(yyval.exp_options_list) = tmp;
      }
#line 4923 "../parse.cc" /* yacc.c:1663  */
    break;

  case 333:
#line 2386 "parse.y" /* yacc.c:1663  */
    { list<ExpConditional::case_t*>*tmp = new list<ExpConditional::case_t*>;
	tmp->push_back((yyvsp[0].exp_options));
	(yyval.exp_options_list) = tmp;
      }
#line 4932 "../parse.cc" /* yacc.c:1663  */
    break;

  case 334:
#line 2394 "parse.y" /* yacc.c:1663  */
    { std::list<SequentialStmt*>*tmp = (yyvsp[-1].sequ_list);
    if((yyvsp[0].sequ))
        tmp->push_back((yyvsp[0].sequ));
	(yyval.sequ_list) = tmp;
      }
#line 4942 "../parse.cc" /* yacc.c:1663  */
    break;

  case 335:
#line 2400 "parse.y" /* yacc.c:1663  */
    { std::list<SequentialStmt*>*tmp = new std::list<SequentialStmt*>;
    if((yyvsp[0].sequ))
        tmp->push_back((yyvsp[0].sequ));
	(yyval.sequ_list) = tmp;
      }
#line 4952 "../parse.cc" /* yacc.c:1663  */
    break;

  case 336:
#line 2408 "parse.y" /* yacc.c:1663  */
    { (yyvsp[0].sequ_list) = (yyval.sequ_list); }
#line 4958 "../parse.cc" /* yacc.c:1663  */
    break;

  case 337:
#line 2409 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ_list) = NULL; }
#line 4964 "../parse.cc" /* yacc.c:1663  */
    break;

  case 338:
#line 2413 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 4970 "../parse.cc" /* yacc.c:1663  */
    break;

  case 339:
#line 2414 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 4976 "../parse.cc" /* yacc.c:1663  */
    break;

  case 340:
#line 2415 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 4982 "../parse.cc" /* yacc.c:1663  */
    break;

  case 341:
#line 2416 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 4988 "../parse.cc" /* yacc.c:1663  */
    break;

  case 342:
#line 2417 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 4994 "../parse.cc" /* yacc.c:1663  */
    break;

  case 343:
#line 2418 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 5000 "../parse.cc" /* yacc.c:1663  */
    break;

  case 344:
#line 2419 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 5006 "../parse.cc" /* yacc.c:1663  */
    break;

  case 345:
#line 2420 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 5012 "../parse.cc" /* yacc.c:1663  */
    break;

  case 346:
#line 2421 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 5018 "../parse.cc" /* yacc.c:1663  */
    break;

  case 347:
#line 2422 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = (yyvsp[0].sequ); }
#line 5024 "../parse.cc" /* yacc.c:1663  */
    break;

  case 348:
#line 2423 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ) = 0; }
#line 5030 "../parse.cc" /* yacc.c:1663  */
    break;

  case 349:
#line 2425 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Syntax error in sequential statement.\n");
	(yyval.sequ) = 0;
	yyerrok;
      }
#line 5039 "../parse.cc" /* yacc.c:1663  */
    break;

  case 350:
#line 2433 "parse.y" /* yacc.c:1663  */
    { if(!strcasecmp((yyvsp[0].text), "NOTE"))
        (yyval.severity) = ReportStmt::NOTE;
    else if(!strcasecmp((yyvsp[0].text), "WARNING"))
        (yyval.severity) = ReportStmt::WARNING;
    else if(!strcasecmp((yyvsp[0].text), "ERROR"))
        (yyval.severity) = ReportStmt::ERROR;
    else if(!strcasecmp((yyvsp[0].text), "FAILURE"))
        (yyval.severity) = ReportStmt::FAILURE;
    else {
        errormsg((yylsp[-1]), "Invalid severity level (possible values: NOTE, WARNING, ERROR, FAILURE).\n");
        (yyval.severity) = ReportStmt::UNSPECIFIED;
    }
    delete[] (yyvsp[0].text);
  }
#line 5058 "../parse.cc" /* yacc.c:1663  */
    break;

  case 351:
#line 2449 "parse.y" /* yacc.c:1663  */
    { (yyval.severity) = (yyvsp[0].severity); }
#line 5064 "../parse.cc" /* yacc.c:1663  */
    break;

  case 352:
#line 2450 "parse.y" /* yacc.c:1663  */
    { (yyval.severity) = ReportStmt::UNSPECIFIED; }
#line 5070 "../parse.cc" /* yacc.c:1663  */
    break;

  case 354:
#line 2455 "parse.y" /* yacc.c:1663  */
    { ExpShift*tmp = new ExpShift(ExpShift::SRL, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
        (yyval.expr) = tmp;
      }
#line 5079 "../parse.cc" /* yacc.c:1663  */
    break;

  case 355:
#line 2460 "parse.y" /* yacc.c:1663  */
    { ExpShift*tmp = new ExpShift(ExpShift::SLL, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
        (yyval.expr) = tmp;
      }
#line 5088 "../parse.cc" /* yacc.c:1663  */
    break;

  case 356:
#line 2465 "parse.y" /* yacc.c:1663  */
    { ExpShift*tmp = new ExpShift(ExpShift::SRA, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
        (yyval.expr) = tmp;
      }
#line 5097 "../parse.cc" /* yacc.c:1663  */
    break;

  case 357:
#line 2470 "parse.y" /* yacc.c:1663  */
    { ExpShift*tmp = new ExpShift(ExpShift::SLA, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
        (yyval.expr) = tmp;
      }
#line 5106 "../parse.cc" /* yacc.c:1663  */
    break;

  case 358:
#line 2475 "parse.y" /* yacc.c:1663  */
    { sorrymsg((yylsp[-1]), "ROR is not supported.\n");
        ExpShift*tmp = new ExpShift(ExpShift::ROR, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
        (yyval.expr) = tmp;
      }
#line 5116 "../parse.cc" /* yacc.c:1663  */
    break;

  case 359:
#line 2481 "parse.y" /* yacc.c:1663  */
    { sorrymsg((yylsp[-1]), "ROL is not supported.\n");
        ExpShift*tmp = new ExpShift(ExpShift::ROL, (yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-1]));
        (yyval.expr) = tmp;
      }
#line 5126 "../parse.cc" /* yacc.c:1663  */
    break;

  case 360:
#line 2489 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 5132 "../parse.cc" /* yacc.c:1663  */
    break;

  case 361:
#line 2490 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = 0;  }
#line 5138 "../parse.cc" /* yacc.c:1663  */
    break;

  case 362:
#line 2514 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = new ExpUMinus((yyvsp[0].expr)); }
#line 5144 "../parse.cc" /* yacc.c:1663  */
    break;

  case 363:
#line 2516 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 5150 "../parse.cc" /* yacc.c:1663  */
    break;

  case 364:
#line 2518 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 5156 "../parse.cc" /* yacc.c:1663  */
    break;

  case 365:
#line 2523 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 5162 "../parse.cc" /* yacc.c:1663  */
    break;

  case 366:
#line 2525 "parse.y" /* yacc.c:1663  */
    { Expression*tmp = (yyvsp[-1].expr);
	list<struct adding_term>*lst = (yyvsp[0].adding_terms);
	while (! lst->empty()) {
	      struct adding_term item = lst->front();
	      lst->pop_front();
	      if (item.op == ExpArithmetic::xCONCAT)
		    tmp = new ExpConcat(tmp, item.term);
	      else
		    tmp = new ExpArithmetic(item.op, tmp, item.term);
	}
	delete lst;
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 5181 "../parse.cc" /* yacc.c:1663  */
    break;

  case 367:
#line 2543 "parse.y" /* yacc.c:1663  */
    { struct adding_term item;
	item.op = (yyvsp[-1].arithmetic_op);
	item.term = (yyvsp[0].expr);
	list<adding_term>*tmp = new list<adding_term>;
	tmp->push_back(item);
	(yyval.adding_terms) = tmp;
      }
#line 5193 "../parse.cc" /* yacc.c:1663  */
    break;

  case 368:
#line 2551 "parse.y" /* yacc.c:1663  */
    { list<adding_term>*tmp = (yyvsp[-2].adding_terms);
	struct adding_term item;
	item.op = (yyvsp[-1].arithmetic_op);
	item.term = (yyvsp[0].expr);
	tmp->push_back(item);
	(yyval.adding_terms) = tmp;
      }
#line 5205 "../parse.cc" /* yacc.c:1663  */
    break;

  case 369:
#line 2562 "parse.y" /* yacc.c:1663  */
    { SignalSeqAssignment*tmp = new SignalSeqAssignment((yyvsp[-3].expr), (yyvsp[-1].expr_list));
	FILE_NAME(tmp, (yylsp[-3]));
	delete (yyvsp[-1].expr_list);
	(yyval.sequ) = tmp;
      }
#line 5215 "../parse.cc" /* yacc.c:1663  */
    break;

  case 370:
#line 2568 "parse.y" /* yacc.c:1663  */
    { SignalSeqAssignment*tmp = new SignalSeqAssignment((yyvsp[-7].expr), (yyvsp[-5].expr_list));
	FILE_NAME(tmp, (yylsp[-7]));
	sorrymsg((yylsp[-4]), "Conditional signal assignment not supported.\n");
	(yyval.sequ) = tmp;
      }
#line 5225 "../parse.cc" /* yacc.c:1663  */
    break;

  case 372:
#line 2578 "parse.y" /* yacc.c:1663  */
    { delete[] (yyvsp[-2].text);
	(yyval.sequ) = (yyvsp[0].sequ);
      }
#line 5233 "../parse.cc" /* yacc.c:1663  */
    break;

  case 373:
#line 2584 "parse.y" /* yacc.c:1663  */
    { assert(!active_sub);
        active_sub = (yyvsp[-1].subprogram);
        (yyval.subprogram) = (yyvsp[-1].subprogram); }
#line 5241 "../parse.cc" /* yacc.c:1663  */
    break;

  case 374:
#line 2596 "parse.y" /* yacc.c:1663  */
    { SubprogramHeader*prog = (yyvsp[-7].subprogram);
	SubprogramHeader*tmp = active_scope->recall_subprogram(prog);
	if (tmp) {
	      delete prog;
	      prog = tmp;
	}

	SubprogramBody*body = new SubprogramBody();
	body->transfer_from(*active_scope, ScopeBase::VARIABLES);
	body->set_statements((yyvsp[-4].sequ_list));

	prog->set_body(body);
	active_scope->bind_subprogram(prog->name(), prog);
	active_sub = NULL;
      }
#line 5261 "../parse.cc" /* yacc.c:1663  */
    break;

  case 375:
#line 2616 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-6]), "Syntax errors in subprogram body.\n");
	yyerrok;
	active_sub = NULL;
	if ((yyvsp[-7].subprogram)) delete (yyvsp[-7].subprogram);
	if ((yyvsp[-1].text)) delete[](yyvsp[-1].text);
      }
#line 5272 "../parse.cc" /* yacc.c:1663  */
    break;

  case 376:
#line 2626 "parse.y" /* yacc.c:1663  */
    { if ((yyvsp[-1].subprogram)) active_scope->bind_subprogram((yyvsp[-1].subprogram)->name(), (yyvsp[-1].subprogram)); }
#line 5278 "../parse.cc" /* yacc.c:1663  */
    break;

  case 387:
#line 2652 "parse.y" /* yacc.c:1663  */
    { (yyval.subprogram) = (yyvsp[0].subprogram); }
#line 5284 "../parse.cc" /* yacc.c:1663  */
    break;

  case 388:
#line 2653 "parse.y" /* yacc.c:1663  */
    { (yyval.subprogram) = (yyvsp[0].subprogram); }
#line 5290 "../parse.cc" /* yacc.c:1663  */
    break;

  case 389:
#line 2661 "parse.y" /* yacc.c:1663  */
    { (yyval.sequ_list) = (yyvsp[0].sequ_list); }
#line 5296 "../parse.cc" /* yacc.c:1663  */
    break;

  case 390:
#line 2666 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[-3].text));
	if ((yyvsp[-1].vtype) == 0) {
	      errormsg((yylsp[-4]), "Failed to declare type name %s.\n", name.str());
	} else {
	      VTypeDef*tmp;
	      map<perm_string,VTypeDef*>::iterator cur = active_scope->incomplete_types.find(name);
	      if (cur == active_scope->incomplete_types.end()) {
		    tmp = new VSubTypeDef(name, (yyvsp[-1].vtype));
		    active_scope->bind_name(name, tmp);
	      } else {
		    tmp = cur->second;
		    tmp->set_definition((yyvsp[-1].vtype));
		    active_scope->incomplete_types.erase(cur);
	      }
	}
	delete[](yyvsp[-3].text);
      }
#line 5318 "../parse.cc" /* yacc.c:1663  */
    break;

  case 391:
#line 2687 "parse.y" /* yacc.c:1663  */
    { const VType*tmp = parse_type_by_name(lex_strings.make((yyvsp[0].text)));
	if (tmp == 0) {
	      errormsg((yylsp[0]), "Can't find type name `%s'\n", (yyvsp[0].text));
	      tmp = new VTypeERROR;
	}
	delete[](yyvsp[0].text);
	(yyval.vtype) = tmp;
      }
#line 5331 "../parse.cc" /* yacc.c:1663  */
    break;

  case 392:
#line 2696 "parse.y" /* yacc.c:1663  */
    { const VType*tmp = calculate_subtype_array((yylsp[-1]), (yyvsp[-1].text), active_scope, (yyvsp[0].range_list));
	if (tmp == 0) {
	      errormsg((yylsp[-1]), "Unable to calculate bounds for array of %s.\n", (yyvsp[-1].text));
	}
	delete[](yyvsp[-1].text);
	delete  (yyvsp[0].range_list);
	(yyval.vtype) = tmp;
      }
#line 5344 "../parse.cc" /* yacc.c:1663  */
    break;

  case 393:
#line 2705 "parse.y" /* yacc.c:1663  */
    { const VType*tmp = calculate_subtype_range((yylsp[-4]), (yyvsp[-4].text), active_scope, (yyvsp[-2].expr), (yyvsp[-1].range_dir), (yyvsp[0].expr));
	if (tmp == 0) {
	      errormsg((yylsp[-4]), "Unable to calculate bounds for range of %s.\n", (yyvsp[-4].text));
	}
	delete[](yyvsp[-4].text);
	(yyval.vtype) = tmp;
      }
#line 5356 "../parse.cc" /* yacc.c:1663  */
    break;

  case 394:
#line 2716 "parse.y" /* yacc.c:1663  */
    { (yyval.text) = (yyvsp[0].text); }
#line 5362 "../parse.cc" /* yacc.c:1663  */
    break;

  case 395:
#line 2718 "parse.y" /* yacc.c:1663  */
    { (yyval.text) = (yyvsp[0].text); }
#line 5368 "../parse.cc" /* yacc.c:1663  */
    break;

  case 396:
#line 2720 "parse.y" /* yacc.c:1663  */
    { //do not have now better idea than using char constant
	(yyval.text) = strdup("all");
      }
#line 5376 "../parse.cc" /* yacc.c:1663  */
    break;

  case 397:
#line 2727 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 5382 "../parse.cc" /* yacc.c:1663  */
    break;

  case 398:
#line 2729 "parse.y" /* yacc.c:1663  */
    { ExpArithmetic*tmp = new ExpArithmetic(ExpArithmetic::MULT, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 5391 "../parse.cc" /* yacc.c:1663  */
    break;

  case 399:
#line 2734 "parse.y" /* yacc.c:1663  */
    { ExpArithmetic*tmp = new ExpArithmetic(ExpArithmetic::DIV, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 5400 "../parse.cc" /* yacc.c:1663  */
    break;

  case 400:
#line 2739 "parse.y" /* yacc.c:1663  */
    { ExpArithmetic*tmp = new ExpArithmetic(ExpArithmetic::MOD, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 5409 "../parse.cc" /* yacc.c:1663  */
    break;

  case 401:
#line 2744 "parse.y" /* yacc.c:1663  */
    { ExpArithmetic*tmp = new ExpArithmetic(ExpArithmetic::REM, (yyvsp[-2].expr), (yyvsp[0].expr));
	FILE_NAME(tmp, (yylsp[-1]));
	(yyval.expr) = tmp;
      }
#line 5418 "../parse.cc" /* yacc.c:1663  */
    break;

  case 402:
#line 2752 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[-3].text));
	if ((yyvsp[-1].vtype) == 0) {
	      errormsg((yylsp[-4]), "Failed to declare type name %s.\n", name.str());
	} else {
	      VTypeDef*tmp;
	      map<perm_string,VTypeDef*>::iterator cur = active_scope->incomplete_types.find(name);
	      if (cur == active_scope->incomplete_types.end()) {
		    tmp = new VTypeDef(name, (yyvsp[-1].vtype));
		    active_scope->bind_name(name, tmp);
	      } else {
		    tmp = cur->second;
		    tmp->set_definition((yyvsp[-1].vtype));
		    active_scope->incomplete_types.erase(cur);
	      }
	}
	delete[](yyvsp[-3].text);
      }
#line 5440 "../parse.cc" /* yacc.c:1663  */
    break;

  case 403:
#line 2770 "parse.y" /* yacc.c:1663  */
    { perm_string name = lex_strings.make((yyvsp[-1].text));
	VTypeDef*tmp = new VTypeDef(name);
	active_scope->incomplete_types[name] = tmp;
	active_scope->bind_name(name, tmp);
	delete[](yyvsp[-1].text);
      }
#line 5451 "../parse.cc" /* yacc.c:1663  */
    break;

  case 404:
#line 2777 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Error in type definition for %s\n", (yyvsp[-3].text));
	yyerrok;
	delete[](yyvsp[-3].text);
      }
#line 5460 "../parse.cc" /* yacc.c:1663  */
    break;

  case 405:
#line 2782 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-2]), "Error in type definition\n");
	yyerrok;
      }
#line 5468 "../parse.cc" /* yacc.c:1663  */
    break;

  case 406:
#line 2789 "parse.y" /* yacc.c:1663  */
    { VTypeEnum*tmp = new VTypeEnum((yyvsp[-1].name_list));
	active_scope->use_enum(tmp);
	delete (yyvsp[-1].name_list);
	(yyval.vtype) = tmp;
      }
#line 5478 "../parse.cc" /* yacc.c:1663  */
    break;

  case 407:
#line 2795 "parse.y" /* yacc.c:1663  */
    { (yyval.vtype) = (yyvsp[0].vtype); }
#line 5484 "../parse.cc" /* yacc.c:1663  */
    break;

  case 408:
#line 2801 "parse.y" /* yacc.c:1663  */
    { (yyval.expr_list) = (yyvsp[-1].expr_list); }
#line 5490 "../parse.cc" /* yacc.c:1663  */
    break;

  case 409:
#line 2803 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-2]), "Syntax error in use clause.\n"); yyerrok; }
#line 5496 "../parse.cc" /* yacc.c:1663  */
    break;

  case 411:
#line 2809 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-2]), "Syntax error in use clause.\n"); yyerrok; }
#line 5502 "../parse.cc" /* yacc.c:1663  */
    break;

  case 417:
#line 2825 "parse.y" /* yacc.c:1663  */
    { delete[] (yyvsp[-2].text);
	(yyval.sequ) = (yyvsp[0].sequ);
      }
#line 5510 "../parse.cc" /* yacc.c:1663  */
    break;

  case 418:
#line 2831 "parse.y" /* yacc.c:1663  */
    { VariableSeqAssignment*tmp = new VariableSeqAssignment((yyvsp[-3].expr), (yyvsp[-1].expr));
	FILE_NAME(tmp, (yylsp[-3]));
	(yyval.sequ) = tmp;
      }
#line 5519 "../parse.cc" /* yacc.c:1663  */
    break;

  case 419:
#line 2836 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-1]), "Syntax error in r-value expression of assignment.\n");
	yyerrok;
	delete (yyvsp[-3].expr);
	(yyval.sequ) = 0;
      }
#line 5529 "../parse.cc" /* yacc.c:1663  */
    break;

  case 420:
#line 2842 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-3]), "Syntax error in l-value expression of assignment.\n");
	yyerrok;
	delete (yyvsp[-1].expr);
	(yyval.sequ) = 0;
      }
#line 5539 "../parse.cc" /* yacc.c:1663  */
    break;

  case 421:
#line 2852 "parse.y" /* yacc.c:1663  */
    { /* Save the signal declaration in the block_signals map. */
	for (std::list<perm_string>::iterator cur = (yyvsp[-4].name_list)->begin()
		   ; cur != (yyvsp[-4].name_list)->end() ; ++cur) {
	      Variable*sig = new Variable(*cur, (yyvsp[-2].vtype), (yyvsp[-1].expr));
	      FILE_NAME(sig, (yylsp[-5]));
	      active_scope->bind_name(*cur, sig);
	}
	delete (yyvsp[-4].name_list);
      }
#line 5553 "../parse.cc" /* yacc.c:1663  */
    break;

  case 422:
#line 2862 "parse.y" /* yacc.c:1663  */
    { errormsg((yylsp[-2]), "Syntax error in variable declaration.\n");
	yyerrok;
      }
#line 5561 "../parse.cc" /* yacc.c:1663  */
    break;

  case 423:
#line 2868 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 5567 "../parse.cc" /* yacc.c:1663  */
    break;

  case 424:
#line 2869 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = 0;  }
#line 5573 "../parse.cc" /* yacc.c:1663  */
    break;

  case 425:
#line 2874 "parse.y" /* yacc.c:1663  */
    { WaitForStmt*tmp = new WaitForStmt((yyvsp[-1].expr));
	FILE_NAME(tmp, (yylsp[-3]));
	(yyval.sequ) = tmp;
      }
#line 5582 "../parse.cc" /* yacc.c:1663  */
    break;

  case 426:
#line 2879 "parse.y" /* yacc.c:1663  */
    { WaitStmt*tmp = new WaitStmt(WaitStmt::ON, (yyvsp[-1].expr));
        FILE_NAME(tmp, (yylsp[-3]));
        (yyval.sequ) = tmp;
      }
#line 5591 "../parse.cc" /* yacc.c:1663  */
    break;

  case 427:
#line 2884 "parse.y" /* yacc.c:1663  */
    { WaitStmt*tmp = new WaitStmt(WaitStmt::UNTIL, (yyvsp[-1].expr));
        FILE_NAME(tmp, (yylsp[-3]));
        (yyval.sequ) = tmp;
      }
#line 5600 "../parse.cc" /* yacc.c:1663  */
    break;

  case 428:
#line 2889 "parse.y" /* yacc.c:1663  */
    { WaitStmt*tmp = new WaitStmt(WaitStmt::FINAL, NULL);
        FILE_NAME(tmp, (yylsp[-1]));
        (yyval.sequ) = tmp;
      }
#line 5609 "../parse.cc" /* yacc.c:1663  */
    break;

  case 429:
#line 2897 "parse.y" /* yacc.c:1663  */
    { (yyval.expr_list) = (yyvsp[0].expr_list); }
#line 5615 "../parse.cc" /* yacc.c:1663  */
    break;

  case 430:
#line 2899 "parse.y" /* yacc.c:1663  */
    { (yyval.expr_list) = 0; }
#line 5621 "../parse.cc" /* yacc.c:1663  */
    break;

  case 431:
#line 2904 "parse.y" /* yacc.c:1663  */
    { std::list<Expression*>*tmp = (yyvsp[-2].expr_list);
	tmp->push_back((yyvsp[0].expr));
	(yyval.expr_list) = tmp;
      }
#line 5630 "../parse.cc" /* yacc.c:1663  */
    break;

  case 432:
#line 2909 "parse.y" /* yacc.c:1663  */
    { std::list<Expression*>*tmp = new std::list<Expression*>;
	tmp->push_back((yyvsp[0].expr));
	(yyval.expr_list) = tmp;
      }
#line 5639 "../parse.cc" /* yacc.c:1663  */
    break;

  case 433:
#line 2917 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = (yyvsp[0].expr); }
#line 5645 "../parse.cc" /* yacc.c:1663  */
    break;

  case 434:
#line 2919 "parse.y" /* yacc.c:1663  */
    { ExpDelay*tmp = new ExpDelay((yyvsp[-2].expr), (yyvsp[0].expr));
        FILE_NAME(tmp, (yylsp[-2]));
        (yyval.expr) = tmp; }
#line 5653 "../parse.cc" /* yacc.c:1663  */
    break;

  case 435:
#line 2923 "parse.y" /* yacc.c:1663  */
    { (yyval.expr) = 0; }
#line 5659 "../parse.cc" /* yacc.c:1663  */
    break;


#line 5663 "../parse.cc" /* yacc.c:1663  */
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
      yyerror (&yylloc, yyscanner, file_path, parse_library_name, YY_("syntax error"));
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
        yyerror (&yylloc, yyscanner, file_path, parse_library_name, yymsgp);
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
                      yytoken, &yylval, &yylloc, yyscanner, file_path, parse_library_name);
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
                  yystos[yystate], yyvsp, yylsp, yyscanner, file_path, parse_library_name);
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
  yyerror (&yylloc, yyscanner, file_path, parse_library_name, YY_("memory exhausted"));
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
                  yytoken, &yylval, &yylloc, yyscanner, file_path, parse_library_name);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp, yylsp, yyscanner, file_path, parse_library_name);
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
#line 2935 "parse.y" /* yacc.c:1907  */


static void yyerror(YYLTYPE*loc, yyscan_t, const char*, bool, const char*msg)
{
      fprintf(stderr, "%s:%u: %s\n", loc->text, loc->first_line, msg);
      parse_errors += 1;
}

void errormsg(const YYLTYPE&loc, const char*fmt, ...)
{
      va_list ap;
      va_start(ap, fmt);

      fprintf(stderr, "%s:%u: error: ", loc.text, loc.first_line);
      vfprintf(stderr, fmt, ap);
      va_end(ap);
      parse_errors += 1;
}

void sorrymsg(const YYLTYPE&loc, const char*fmt, ...)
{
      va_list ap;
      va_start(ap, fmt);

      fprintf(stderr, "%s:%u: sorry: ", loc.text, loc.first_line);
      vfprintf(stderr, fmt, ap);
      va_end(ap);
      parse_sorrys += 1;
}


/*
 * The reset_lexor function takes the fd and makes it the input file
 * for the lexor. The path argument is used in lexor/parser error messages.
 */
extern yyscan_t prepare_lexor(FILE*fd);
extern void destroy_lexor(yyscan_t scanner);

int parse_source_file(const char*file_path, perm_string parse_library_name)
{
      FILE*fd = fopen(file_path, "r");
      if (fd == 0) {
	    perror(file_path);
	    return -1;
      }

      yyscan_t scanner = prepare_lexor(fd);
      int rc = yyparse(scanner, file_path, parse_library_name);
      fclose(fd);
      destroy_lexor(scanner);

      return rc;
}
