#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include "config.h"
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */


/*  machine-dependent definitions			*/
/*  the following definitions are for the Tahoe		*/
/*  they might have to be changed for other machines	*/

/*  MAXCHAR is the largest unsigned character value	*/
/*  MAXSHORT is the largest value of a C short		*/
/*  MINSHORT is the most negative value of a C short	*/
/*  MAXTABLE is the maximum table size			*/
/*  BITS_PER_WORD is the number of bits in a C unsigned	*/
/*  WORDSIZE computes the number of words needed to	*/
/*	store n bits					*/
/*  BIT returns the value of the n-th bit starting	*/
/*	from r (0-indexed)				*/
/*  SETBIT sets the n-th bit starting from r		*/

#define	MAXCHAR		255
#define	MAXSHORT	32767
#define MINSHORT	-32768
#define MAXTABLE	32500
#define BITS_PER_WORD	32
#define	WORDSIZE(n)	(((n)+(BITS_PER_WORD-1))/BITS_PER_WORD)
#define	BIT(r, n)	((((r)[(n)>>5])>>((n)&31))&1)
#define	SETBIT(r, n)	((r)[(n)>>5]|=((unsigned)1<<((n)&31)))


/*  character names  */

#define	NUL		'\0'    /*  the null character  */
#define	NEWLINE		'\n'    /*  line feed  */
#define	SP		' '     /*  space  */
#define	BS		'\b'    /*  backspace  */
#define	HT		'\t'    /*  horizontal tab  */
#define	VT		'\013'  /*  vertical tab  */
#define	CR		'\r'    /*  carriage return  */
#define	FF		'\f'    /*  form feed  */
#define	QUOTE		'\''    /*  single quote  */
#define	DOUBLE_QUOTE	'\"'    /*  double quote  */
#define	BACKSLASH	'\\'    /*  backslash  */


/* defines for constructing filenames */

#define CODE_SUFFIX	".code.c"
#define	DEFINES_SUFFIX	".tab.h"
#define	OUTPUT_SUFFIX	".tab.c"
#define	VERBOSE_SUFFIX	".output"


/* keyword codes */

typedef enum {
  TOKEN 	= 0,
  LEFT 		= 1,
  RIGHT 	= 2,
  NONASSOC 	= 3,
  MARK 		= 4,
  TEXT 		= 5,
  TYPE 		= 6,
  START 	= 7,
  UNION 	= 8,
  IDENT 	= 9,
  YPARSE_PARAM 	= 10,
  LEX_PARAM 	= 11,
  GLR_PARSER 	= 12,	
  EXPECT 	= 13,
  EXPECT_RR	= 14
} KEYWORD_CODES_T ;

/*  symbol classes  */

#define UNKNOWN 0
#define TERM 1
#define NONTERM 2


/*  the undefined value  */

#define UNDEFINED (-1)


/*  action codes  */

#define SHIFT 1
#define REDUCE 2


/*  character macros  */

#define IS_IDENT(c)	(isalnum(c) || (c) == '_' || (c) == '.' || (c) == '$')
#define	IS_OCTAL(c)	((c) >= '0' && (c) <= '7')
#define	NUMERIC_VALUE(c)	((c) - '0')


/*  symbol macros  */

#define ISTOKEN(s)	((s) < start_symbol)
#define ISVAR(s)	((s) >= start_symbol)


/*  storage allocation macros  */

#define CALLOC(k,n)	(calloc((unsigned)(k),(unsigned)(n)))
#define	FREE(x)		(free((char*)(x)))
#define MALLOC(n)	(malloc((unsigned)(n)))
#define	NEW(t)		((t*)allocate(sizeof(t)))
#define	NEW2(n,t)	((t*)allocate((unsigned)((n)*sizeof(t))))
#define REALLOC(p,n)	(realloc((char*)(p),(unsigned)(n)))


/*  the structure of a symbol table entry  */

typedef struct bucket bucket;
struct bucket
{
    struct bucket *link;
    struct bucket *next;
    char *name;
    char *tag;
    short value;
    short index;
    short prec;
    char class;
    char assoc;
};


/*  the structure of the LR(0) state machine  */

typedef struct core core;
struct core
{
    struct core *next;
    struct core *link;
    short number;
    short accessing_symbol;
    short nitems;
    short items[1];
};


/*  the structure used to record shifts  */

typedef struct shifts shifts;
struct shifts
{
    struct shifts *next;
    short number;
    short nshifts;
    short shift[1];
};


/*  the structure used to store reductions  */

typedef struct reductions reductions;
struct reductions
{
    struct reductions *next;
    short number;
    short nreds;
    short rules[1];
};


/*  the structure used to represent parser actions  */

typedef struct action action;
struct action
{
    struct action *next;
    short symbol;
    short number;
    short prec;
    char action_code;
    char assoc;
    char suppressed;
};

typedef struct param_rec {
    char *arg_type ;
    char *arg_name ;
    struct param_rec *next_param ;
} PARAMBOX, *PARAMPTR ; 


/* global variables */

extern char cflagG;
extern char dflag;
extern char lflag;
extern char rflag;
extern char tflag;
extern char vflag;

extern char *myname;
extern char *cptr;
extern char *line;
extern int lineno;
extern int outline;

extern char *bannerG[];
extern char *global_varsG[];
extern char *tablesG[];
extern char *header1G[];
extern char *header2G[];
extern char *header2_altG;
extern char *header2b_altG;
extern char *body1G[];
extern char *body2G[];
extern char *body3G[];
extern char *body4G[];
extern char *body5G[];
extern char *body6G[];
extern char *body7G[];
extern char *body2_altG;
extern char *body4_altG;
extern char *body6_altG;
extern char *trailer1G[];
extern char *trailer2G[];
extern char *trailer3G[];
extern char *trailer4G[];
extern char *trailer5G[];
extern char *trailer2_altG ;
extern char *trailer4_altG ;

extern char *name_prefixG;
extern char *action_file_name;
extern char *code_file_name;
extern char *defines_file_name;
extern char *input_file_name;
extern char *output_file_name;
extern char *text_file_name;
extern char *union_file_name;
extern char *verbose_file_name;
extern PARAMPTR yparse_paramsG;
extern PARAMPTR lex_paramsG;

extern FILE *action_file;
extern FILE *code_file;
extern FILE *defines_file;
extern FILE *input_file;
extern FILE *output_file;
extern FILE *text_file;
extern FILE *union_file;
extern FILE *verbose_file;

extern int nitems;
extern int nrules;
extern int nsyms;
extern int ntokens;
extern int nvars;
extern int ntags;

extern char unionized;
extern char line_format[];

extern int   start_symbol;
extern char  **symbol_name;
extern short *symbol_value;
extern short *symbol_prec;
extern char  *symbol_assoc;

extern short *ritem;
extern short *rlhs;
extern short *rrhs;
extern short *rprec;
extern char  *rassoc;

extern short **derives;
extern char *nullable;

extern bucket *first_symbol;
extern bucket *last_symbol;

extern int nstates;
extern core *first_state;
extern shifts *first_shift;
extern reductions *first_reduction;
extern short *accessing_symbol;
extern core **state_table;
extern shifts **shift_table;
extern reductions **reduction_table;
extern unsigned *LA;
extern short *LAruleno;
extern short *lookaheads;
extern short *goto_map;
extern short *from_state;
extern short *to_state;

extern action **parser;
extern int SRtotal;
extern int RRtotal;
extern short *SRconflicts;
extern short *RRconflicts;
extern short *defred;
extern short *rules_used;
extern short nunused;
extern short final_state;

/* global functions */


/* system variables */

extern int errno;


/* system functions */
#ifndef HAVE_STDLIB_H
extern void free();
extern char *calloc();
extern char *malloc();
extern char *realloc();
#endif /* HAVE_STDLIB_H */

#ifdef HAVE_STRING_H
#include <string.h>
#else
extern char *strcpy();
#endif /* STRING_H */


/* -----------------------------------------------------------------
 *  closure.c
----------------------------------------------------------------- */
extern void set_first_derives(void) ;
extern void set_first_derives(void) ;
extern void closure(short *nucleus, int n) ;
extern void finalize_closure(void) ;


/* -----------------------------------------------------------------
 *  error.c
----------------------------------------------------------------- */
extern void fatal(char *msg) ;
extern void no_space(void) ;
extern void open_error(char *filename) ;
extern void unexpected_EOF(void) ;
extern void print_pos(char *st_line, char *st_cptr) ;
extern void syntax_error(int st_lineno, char *st_line, char *st_cptr) ;
extern void over_unionized(char *u_cptr) ;
extern void illegal_tag(int t_lineno, char *t_line, char *t_cptr) ;
extern void illegal_character(char *c_cptr) ;
extern void used_reserved(char *s) ;
extern void tokenized_start(char *s) ;
extern void retyped_warning(char *s) ;
extern void reprec_warning(char *s) ;
extern void revalued_warning(char *s) ;
extern void terminal_start(char *s) ;
extern void restarted_warning(void) ;
extern void no_grammar(void) ;
extern void terminal_lhs(int s_lineno) ;
extern void prec_redeclared(void) ;
extern void unterminated_action(int a_lineno, char *a_line, char *a_cptr) ;
extern void unterminated_comment(int c_lineno, char *c_line, char *c_cptr) ;
extern void unterminated_string(int s_lineno, char *s_line, char *s_cptr) ;
extern void unterminated_text(int t_lineno, char *t_line, char *t_cptr) ;
extern void unterminated_union(int u_lineno, char *u_line, char *u_cptr) ;
extern void dollar_warning(int a_lineno,int i) ;
extern void dollar_error(int a_lineno, char *a_line, char *a_cptr) ;
extern void untyped_lhs(void) ;
extern void untyped_rhs(int i, char *s) ;
extern void unknown_rhs(int i) ;
extern void default_action_warning(void) ;
extern void undefined_goal(char *s) ;
extern void undefined_symbol_warning(char *s) ;

/* -----------------------------------------------------------------
 *  lalr.c
----------------------------------------------------------------- */
extern void lalr(void) ;

/* -----------------------------------------------------------------
 *  lr0.c
----------------------------------------------------------------- */
extern void lr0(void) ;

/* -----------------------------------------------------------------
 *  main.c
----------------------------------------------------------------- */
extern void done(int k) ;
extern char *allocate(unsigned n) ;


/* -----------------------------------------------------------------
 *  mkpar.c
----------------------------------------------------------------- */
extern void free_parser(void) ;
extern void make_parser(void) ;
extern action *parse_actions(int stateno) ;
extern action *get_shifts(int stateno) ;
extern action *add_reductions(int stateno, action *actions) ;
extern action *add_reduce(action *actions, int ruleno, int symbol) ;

/* -----------------------------------------------------------------
 *  output.c
----------------------------------------------------------------- */
extern void output(void) ;

/* -----------------------------------------------------------------
 *  reader.c
----------------------------------------------------------------- */
extern char *Ystrtok(char *str, char *dels) ;
extern char **Ystrparser2(char *str, char *dels,char **buf,int *numtokens) ;
extern void reader(void) ;

/* -----------------------------------------------------------------
 *  skeleton.c
----------------------------------------------------------------- */
extern void write_section(char *section[]) ;

/* -----------------------------------------------------------------
 *  symtab.c
----------------------------------------------------------------- */
extern int hash(char *name) ;
extern bucket *make_bucket(char *name) ;
extern bucket *lookup(char *name) ;
extern void create_symbol_table(void) ; 
extern void free_symbol_table(void) ;
extern void free_symbols(void) ;

/* -----------------------------------------------------------------
 *  verbose.c
----------------------------------------------------------------- */
extern void verbose(void) ;

/* -----------------------------------------------------------------
 *  warshall.c
----------------------------------------------------------------- */
extern void transitive_closure(unsigned *R, int n) ;
extern void reflexive_transitive_closure(unsigned *R, int n) ;
