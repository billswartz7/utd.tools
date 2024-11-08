/*!
@file preprocessor.h
@brief Contains function and data structures to support source code
       preprocessing.
*/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef VERILOG_PREPROCESSOR_H
#define VERILOG_PREPROCESSOR_H

#include <sverilog_config.h>
#include <utd/base.h>
#include <utd/deck.h>
#include <utd/dstring.h>
#include <utd/hash.h>
#include <utd/stringhash.h>

#ifdef DEBUG
#define YYDEBUG 1
#endif /* DEBUG */

#define LAST_FILE_LEN	80

// ----------------------- Timescale Directives -------------------------

//! Describes a simulation timescale directive.
typedef struct verilog_timescale_directive_t {
    char * scale ;       //!< The timescale to simulate on.
    char * precision ;   //!< Precision of each timestep.
} VERILOG_TIMESCALE_DIRECTIVE ;


/*!
@brief Stores information regarding a particular level of conditional
compilation.
@brief A stack of these is maintained, each one relating to a different
level of nested `ifdef or `ifndef statements.
*/
typedef struct verilog_preprocessor_conditional_context_t {
    char * condition;          //!< The definition to check for.
    int  line_number;         //!< Where the `ifdef came from.
    BOOL condition_passed;    //!< Did the condition pass?
    BOOL is_ndef ;            //!< True if directive was `ifndef
    BOOL wait_for_endif ;     //!< Emit nothing more until `endif
} VERILOG_PREPROC_COND_CONTEXT, *VERILOG_PREPROC_COND_CONTEXTPTR ;

//! Creates and returns a new conditional context.
extern VERILOG_PREPROC_COND_CONTEXTPTR
    verilog_preprocessor_new_conditional_context(
    char * condition,         //!< The definition to check for.
    int  line_number          //!< Where the `ifdef came from.
) ;

// ----------------------- Preprocessor Context -------------------------

/*
@brief Stores all of the contextual information used by the pre-processor.
@details Stores things like:
- Macro names and evaluations.
- Default net types.
- In Cell Defines.
- IF/ELSE pre-processor directives.
- Timescale directives
*/

#include <sverilog/callbacks.h>

/*
@brief Numbers have two representation - string and float/integer 
*/
typedef struct sver_number_rec {
  LONG int_rep ;
  DOUBLE float_rep ;
  char *string_rep ;
} SVER_NUMBER, *SVER_NUMBERPTR ;

typedef struct sverilog_parse_context_rec {
    BOOL emit ;           		//!< Only emit tokens iff true.
    BOOL allow_sv_keys ;       		//!< Allow system verilog keywords
    BOOL check_for_expression ; 	//!< Check for complex expression
    FILE *preproc_out ;			//!< Preprocessor output file
    UNSIGNED_INT token_count ;    	//!< Keeps count of tokens processed.
    BOOL in_cell_define ; 		//!< TRUE iff we are in a cell define.
    UTDDECKPTR file_stack ;		//!< Stack of files to process. 
    UTDDECKPTR net_types ;      	//!< Storage for default nettype directives
    UTDHASHPTR search_dirs ;    	//!< Where to look for include files.
    UTDHASHPTR macrodefines ;   	//!< `define kvp matching.
    UTDHASHPTR includes ;		//!< Include directives.
    UTDDSTRING temp_buf ;		//!< Used for expression manipulation
    UTDSTR_HASHPTR strings ;		//!< Strings table
    VERILOG_TIMESCALE_DIRECTIVE timescale ; //!< Timescale information
    SVERILOG_PRIMITIVE_STRENGTH_T unconnected_drive_pull; //!< nounconnectedrive
    char *scratch ;			//!< used internally
    UTDDECKPTR ifdefs ;         	//!< Storage for conditional compile stack.
    int expr_pool ;			//!< pool id for expressions
    int expr_type_pool ;		//!< pool id for expression types
    int errors ;			//!< Errors encountered.
    int *line_num ;			//!< low level line number variable 
    char **scanner_text ;		//!< low level scanner text
    char *file_name ;			//!< current open filename
    char last_file_name[LAST_FILE_LEN] ;//! < remember last file name
    char number_buf[80] ;		//! < used for building string rep from numbers
    char number_base[80] ;		//! < used for building string rep from numbers
    SVER_CALLBACK callbacks[SVER_CALLBACK_NUM_FUNCS] ;//! < callback functions 
    void *user_data ;			//! < callback user data
} SVERILOG_PARSE, *SVERILOG_PARSEPTR ;


#define YY_DECL int sverilog_lex ( SVERILOG_PARSEPTR parse_p )
extern int sverilog_lex ( SVERILOG_PARSEPTR parse_p ) ;
extern void sverilog_error(SVERILOG_PARSEPTR parse_p,const char *msg) ;
extern void sverilog_preproc( SVERILOG_PARSEPTR parse_p, INT token, char *value,INT len ) ;
extern void sverilog_lowlevel_init(SVERILOG_PARSEPTR parse_p) ;
extern void verilog_flex_set_info( SVERILOG_PARSEPTR parse_p ) ;

#define EMIT_TOKEN(parse_xz,xz_z,val_xz,len_xz)   sverilog_preproc(parse_xz,xz_z,val_xz,len_xz);\
						    if( parse_xz->emit ) {     \
						      return( xz_z ) ;         \
						    }

// For now - eventually we want to turn this off restriction these
// keywords when in verilog mode.
#define EMIT_SVTOKEN(parse_xz,xz_z,val_xz,len_xz) sverilog_preproc(parse_xz,xz_z,val_xz,len_xz);\
						    if( parse_xz->emit && parse_xz->allow_sv_keys ) { \
						      return( xz_z ) ;         \
						    } else if( parse_xz->emit ){ \
						      REJECT ; \
						    }

// ----------------------- Include/File Directives ----------------------

//! Stores information on an include or top level file info
typedef struct verilog_file_rec {
    char         *filename ;     //!< The file to include.
    FILE	 *fp ;		 //! <The file pointer if opened
    unsigned int lineNumber ;    //!< The line number of the directive.
    BOOL 	 file_exists ;   //!< Can we find the file?
} VERILOG_FILE, *VERILOG_FILEPTR ;

/*! 
@brief Handles the encounter of an include directive.
@returns A pointer to the newly created directive reference.
*/
extern VERILOG_FILEPTR verilog_preprocessor_include(
    SVERILOG_PARSEPTR parse_p,	//!< The parsing object
    char * filename,        //<! The file to include.
    unsigned int lineNumber //!< The line number of the directive.
) ;

// ----------------------- resetall directives --------------------------

/*!
@brief Handles the encounter of a `resetall directive as described in annex
19.6 of the spec.
*/
extern void verilog_preprocessor_resetall( SVERILOG_PARSEPTR parse_p ) ;

/*!
@brief Tells the preprocessor we are now defining PLI modules and to tag
       them as such.
*/
extern void verilog_preproc_enter_cell_define( SVERILOG_PARSEPTR parse_p ) ;


/*!
@brief Tells the preprocessor we are no longer defining PLI modules.
*/
extern void verilog_preproc_exit_cell_define( SVERILOG_PARSEPTR parse_p ) ;

// ----------------------- Connected Drive Directives -------------------

/*!
@brief Handles the entering of a no-unconnected drive directive.
@param [in] direction -  Where should an unconnected line be pulled?
*/
extern void verilog_preprocessor_nounconnected_drive(
    SVERILOG_PARSEPTR parse_p,
    SVERILOG_PRIMITIVE_STRENGTH_T direction
);


// ----------------------- `define Directives ---------------------------

/*!
@brief A simple container for macro directives
*/
typedef struct verilog_macro_directive_t {
    unsigned int line;      //!< Line number of the directive.
    char * macro_id;        //!< The name of the macro.
    char * macro_value;     //!< The value it expands to.
} VERILOG_MACRO_DIRECTIVE, *VERILOG_MACRO_DIRECTIVEPTR ;

/*!
@brief Instructs the preprocessor to register a new macro definition.
*/
extern void verilog_preprocessor_macro_define(
    SVERILOG_PARSEPTR parse_p,	//!< The parsing object
    unsigned int line,  	//!< The line the defininition comes from.
    char * macro_name,  	//!< The macro identifier.
    char * macro_text,  	//!< The value the macro expands to.
    size_t text_len     	//!< Length in bytes of macro_text.
) ;
    
/*!
@brief Removes a macro definition from the preprocessors lookup table.
*/
extern void verilog_preprocessor_macro_undefine(
    SVERILOG_PARSEPTR parse_p,	//!< The parsing object
    char * macro_name 		//!< The name of the macro to remove.
);

// ----------------------- Conditional Compilation Directives -----------


/*!
@brief Handles an ifdef statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
@param [in] lineno - The line the directive occurs on.
@param [in] is_ndef - TRUE IFF the directive is `ifndef. Else the directive
is `ifdef and this should be FALSE.
*/
extern void verilog_preprocessor_ifdef (
    SVERILOG_PARSEPTR parse_p,	//!< The parsing object
    char * macro_name,		//!< Name of the macro to test
    unsigned int lineno,    	//!< line number of the directive.
    BOOL is_ndef     		//!< Is this an ifndef or ifdef directive.
);

/*!
@brief Handles an elseif statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
@param [in] lineno - The line the directive occurs on.
*/
extern void verilog_preprocessor_elseif(
    SVERILOG_PARSEPTR parse_p,
    char * macro_name, unsigned int lineno) ;

/*!
@brief Handles an else statement being encountered.
@param [in] lineno - The line the directive occurs on.
*/
extern void verilog_preprocessor_else  (
    SVERILOG_PARSEPTR parse_p,
    unsigned int lineno);

/*!
@brief Handles an else statement being encountered.
@param [in] lineno - The line the directive occurs on.
*/
extern void verilog_preprocessor_endif (SVERILOG_PARSEPTR parse_p,
                                        unsigned int lineno ) ;

// ----------------------- Default Net Type Directives ------------------

/*!
@brief Keeps track of the points at which default net type directives are
encountered.
*/
typedef struct verilog_default_net_type_t {
    unsigned int token_number ;  //!< Token number of the directive.
    unsigned int line_number ;   //!< Line number of the directive.
    SVERILOG_NET_TYPE_T type ;   //!< The net type.
} VERILOG_DEFAULT_NET_TYPE, *VERILOG_DEFAULT_NET_TYPEPTR ;

//! Creates and returns a new default net type directive.
extern VERILOG_DEFAULT_NET_TYPEPTR verilog_new_default_net_type(
    SVERILOG_PARSEPTR parse_p,	//!< Top level parsing object
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    SVERILOG_NET_TYPE_T type    //!< The net type.
);

/*!
@brief Registers a new default net type directive.
*/
extern void verilog_preproc_default_net (
    SVERILOG_PARSEPTR parse_p,	//!< Top level parsing object
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    SVERILOG_NET_TYPE_T type    //!< The net type.
);


extern char *sverilog_new_identifier( SVERILOG_PARSEPTR parse_p,
                                      char *string, unsigned int line_no) ; 

extern void sverilog_expect_expression( SVERILOG_PARSEPTR parse_p, 
                                        BOOL state ) ;

/*!
@brief Cleanup file stack as we are done with the current file.
*/
extern void verilog_pop_file_stack( SVERILOG_PARSEPTR parse_p ) ;


/*!
@brief The call to the yacc parser
*/
extern int sverilog_parse( SVERILOG_PARSEPTR parse_p ) ;

/* -----------------------------------------------------------------
 * First the start of flex line.
 * ----------------------------------------------------------------- */
extern const char *sverilog_line_start( const char *string ) ;
extern int sverilog_show_position( const char *start, const char *msg ) ;

/* -----------------------------------------------------------------
 * These are created by flex
 * ----------------------------------------------------------------- */
extern FILE *sverilog_get_in (void ) ;
extern void sverilog_set_in  (FILE * in_str  ) ;
extern FILE *sverilog_get_out (void ) ;
extern void sverilog_set_out  (FILE * out_str  ) ;


/* -----------------------------------------------------------------
 * Function which returns back the callback functions defined above.
 * Takes an argument initialize which sets all of the argument functions NULL.
----------------------------------------------------------------- */
extern SVER_CALLBACK *sverilog_callback_funcs(SVERILOG_PARSEPTR parse_p, 
                                              BOOL initialize) ;

/* -----------------------------------------------------------------
 * Converts a string to the proper string and integer representation.
 * ----------------------------------------------------------------- */
extern char * sver_convert_integer( SVERILOG_PARSEPTR parse_p, INT base, char *unterminated_string, LONG *int_rep ) ;

/* -----------------------------------------------------------------
 * Converts a string to the proper string and floating point representation.
 * ----------------------------------------------------------------- */
extern char * sver_convert_real( SVERILOG_PARSEPTR parse_p, char *unterminated_string, DOUBLE *float_rep ) ;

/*! @} */

#endif

