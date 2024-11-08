/*!
@file verilog_preprocessor.c
@brief Contains function implementations to support source code preprocessing.
*/

#define SVERILOG_INTERNAL_DEFS
#include <sverilog_config.h>
#include <utd/file.h>
#include <utd/hash.h>
#include <utd/string.h>
#include <sverilog/sverilog.h>
#include "preprocessor.h"
#include <sverilog/expr.h>
#include "sverilog_scanner.h"
#include <sverilog/parse.h>

SVERILOG_PARSEPTR sverilog_parser_init( SVERILOG_OPTIONS_T options )
{
    SVERILOG_PARSEPTR parse_p ;		// info record 
    parse_p = UTDCALLOC( 1, SVERILOG_PARSE ) ;
    parse_p->token_count    = 0 ;
    parse_p->in_cell_define = SVERILOG_FALSE ;
    parse_p->emit           = SVERILOG_TRUE ;

    parse_p->file_stack     = utDdeck_init() ;
    parse_p->net_types 	    = utDdeck_init() ;
    parse_p->includes        = utDhash_init(UTD_HASH_MIN_SIZE) ;
    parse_p->unconnected_drive_pull = STRENGTH_NONE;
    parse_p->macrodefines    = utDhash_init(UTD_HASH_MIN_SIZE) ;
    parse_p->ifdefs          = utDdeck_init() ;
    parse_p->search_dirs     = utDhash_init(UTD_HASH_MIN_SIZE) ;
    parse_p->last_file_name[LAST_FILE_LEN-1] = EOS ;

    // By default, search CWD for include files.
    utDhash_insert( parse_p->search_dirs,"./", utDstrclone("./") ) ;

    sverilog_lowlevel_init(parse_p) ;

    return( parse_p ) ;
} /* end sverilog_parser_init() ; */

void sverilog_parser_add_search_path( SVERILOG_PARSEPTR parse_p,
                                      const char *path )
{
    if(!(parse_p)){
      return ;
    }
    utDhash_insert( parse_p->search_dirs, (char *) path, utDstrclone(path) ) ;

} /* end sverilog_parser_add_search_path() */


/* The top level file parsing call */
int sverilog_parse_file( SVERILOG_PARSEPTR parse_p, char *filename )
{
    VERILOG_FILEPTR file_p ;		/* file information */
    YY_BUFFER_STATE new_buffer ;	/* create a new buffer */

    int result = 1 ;			// assume failure
    file_p = verilog_preprocessor_include( parse_p, filename, 0 ) ;
    if( file_p ){
      if( !(file_p->file_exists) ){
	fprintf( stderr, "file:%s does not exist.\n", file_p->filename ) ;
	return( 1 ) ;
      }
      file_p->fp = UTDOPEN( file_p->filename,"r",FILE_NOABORT|FILE_VERBOSE ) ;

      if( file_p->fp ){
	parse_p->file_name = file_p->filename ;
	strncpy( parse_p->last_file_name, file_p->filename, LAST_FILE_LEN-1) ;
	sverilog_set_in( file_p->fp ) ;
	int status = ferror( file_p->fp ) ;
	fprintf( stderr, "status:%d\n", status ) ;
	new_buffer = sverilog__create_buffer( file_p->fp, YY_BUF_SIZE ) ;
	sverilog__switch_to_buffer(new_buffer);
	// Reset the global line counter, we are in a new file!
	// Was: sverilog_lineno = 0 ;  No globals needed here
	*(parse_p->line_num) = 1 ;
	sver_expr_init( parse_p ) ;
	result = sverilog_parse( parse_p ) ;
	sver_expr_free( parse_p ) ;
      }
    }

    return(result) ;
} /* end sverilog_parse_file() */

//! Get the current line number.
int sverilog_parse_lineno( SVERILOG_PARSEPTR parse_p )
{
    if( parse_p && parse_p->line_num ){
      return( *(parse_p->line_num) ) ;
    }
    return(0) ;
} /* end sverilog_parse_lineno() */

//! Get the current file name
const char * sverilog_parse_filename( SVERILOG_PARSEPTR parse_p )
{ 
    if( parse_p && parse_p->file_name ){
      return( parse_p->file_name ) ;
    }
    return("") ;
} /* end sverilog_parse_filename() */

void sverilog_parser_set_preprocess_output( SVERILOG_PARSEPTR parse_p,
                                            FILE *fout )
{
    parse_p->preproc_out = fout ;
} /* end sverilog_parser_set_preprocess_output() */

int sverilog_parser_get_errors( SVERILOG_PARSEPTR parse_p )
{
    return( parse_p->errors ) ;
} /* end sverilog_parser_get_errors() */

void sverilog_preproc( SVERILOG_PARSEPTR parse_p, INT token, char *value, INT length )
{
    char *string_data ;			/* get low level string */

    parse_p->token_count++ ; 
    if( parse_p->emit ) {  
      if( parse_p->preproc_out ){
	if( value ){
	  fprintf( parse_p->preproc_out, "%.*s", length, value);

	} else {
	  if( parse_p->scanner_text ){
	    string_data = *(parse_p->scanner_text) ;
	    if( string_data ){
	      fprintf( parse_p->preproc_out, "%.*s", length, string_data ) ;
	    }
	  }
	}
      }
    }
} /* end sverilog_preproc() */

/*! 
@brief Handles the encounter of an include directive.
@returns A pointer to the newly created directive reference.
*/
VERILOG_FILEPTR verilog_preprocessor_include( SVERILOG_PARSEPTR parse_p,
                                              char * filename,
                                              unsigned int lineNumber )
{
    VERILOG_FILEPTR file_info_p ;	/* file information */
    UTDHASH_ENTRYPTR ent_p ;		/* hash entry */
    UTDHASHITER hiter ;			/* hash iterator */
    char file_buffer[LRECL] ;		/* scratch buffer */
    char full_pathname[LRECL] ;		/* scratch buffer */

    file_info_p = UTDCALLOC( 1, VERILOG_FILE ) ;
    if(!(file_info_p)){
      return(NULL) ;
    }
    // File names can only be so long
    strncpy( file_buffer, filename, LRECL - 1 ) ;

    // Remove any single or double quotes
    char *adj_dquote_name = utDstr_remove_dquotes( file_buffer ) ;

    char *adj_file_name = utDstr_remove_squotes( adj_dquote_name ) ;

    file_info_p->lineNumber = lineNumber ;

    // Search the possible include paths to find a match.
    // Note the utDhash enumerate function maintains proper list
    for( ent_p = utDhash_enumerate(parse_p->search_dirs,UTDHASH_FIRST(&hiter)) ;
	 ent_p ;
         ent_p = utDhash_enumerate(parse_p->search_dirs,&hiter ) ){
      char *directory_p = UTDHASH_GETDATA( ent_p, char * ) ;
      if( directory_p ){
	char last_char = utDstr_last_char( directory_p ) ;
	if( last_char == '/' ){
	  sprintf( full_pathname, "%s%s", directory_p, adj_file_name ) ;
	} else {
	  sprintf( full_pathname, "%s/%s", directory_p, adj_file_name ) ;
	}
	if( utDfile_Z_exists( full_pathname ) ){
	  file_info_p->filename = utDstrclone( full_pathname ) ;
	  file_info_p->file_exists = TRUE ;
	  utDdeck_push( parse_p->file_stack, file_info_p ) ;
	  break ;
	} 
      }
    }

    // Tell the user the original bogus file name 
    if (!(file_info_p->file_exists) ){
      file_info_p->filename = utDstrclone( filename ) ;
    }
    return( file_info_p ) ;

} /* end verilog_preprocessor_include() */

/*!
@brief Handles the encounter of a `resetall directive as described in annex
19.6 of the spec.
*/
void verilog_preprocessor_resetall( SVERILOG_PARSEPTR parse_p )
{
    return;
} /* end verilog_preprocessor_resetall() */


void verilog_preproc_enter_cell_define( SVERILOG_PARSEPTR parse_p )
{
    parse_p->in_cell_define = TRUE ;
} /* end verilog_preproc_enter_cell_define() */


void verilog_preproc_exit_cell_define( SVERILOG_PARSEPTR parse_p )
{
    parse_p->in_cell_define = FALSE ;
} /* end verilog_preproc_exit_cell_define() */

/*!
@brief Handles the entering of a no-unconnected drive directive.
*/
void verilog_preprocessor_nounconnected_drive( SVERILOG_PARSEPTR parse_p,
                                               SVERILOG_PRIMITIVE_STRENGTH_T direction )
{
    assert(direction == STRENGTH_PULL1 || direction == STRENGTH_PULL0 ||
           direction == STRENGTH_NONE) ;

    parse_p->unconnected_drive_pull = direction;
} /* end verilog_preprocessor_nounconnected_drive() */

/*
@brief Instructs the preprocessor to register a new macro definition.
*/
void verilog_preprocessor_macro_define(

    SVERILOG_PARSEPTR parse_p, //!< The instance of the parser
    unsigned int line,  //!< The line the defininition comes from.
    char * macro_name,  //!< The macro identifier.
    char * macro_text,  //!< The value the macro expands to.
    size_t text_len     //!< Length in bytes of macro_text.
)
{

    int i ;				   // counter
    VERILOG_MACRO_DIRECTIVEPTR macro_p ;   // macro directive

    macro_p = UTDCALLOC( 1, VERILOG_MACRO_DIRECTIVE) ;
    macro_p->line = line ;

    // Make space for, and duplicate, the macro text, into the thing
    // we will put into the hashtable.
    macro_p->macro_id = utDstrclone(macro_name) ;

    if( text_len > 0 ){
      // Make sure we exclude all comments from the macro text.
      macro_p->macro_value = utDstrclone(macro_text) ;
      macro_p->macro_value[text_len] = 0 ;
      for ( i = 0 ; i < text_len-1 ; i++ ){
	if ( (macro_text[i] == '/') && (macro_text[i+1] == '/') ) {
	  macro_p->macro_value[i] = EOS ; 
	  break ;
	}
      }
    } else {
      macro_p->macro_value = NULL ;
    }

    utDhash_insert( parse_p->macrodefines, macro_p->macro_id, macro_p ) ;
    return;
} /* end void verilog_preprocessor_macro_define() */

/*!
@brief Removes a macro definition from the preprocessors lookup table.
*/
void verilog_preprocessor_macro_undefine(
    SVERILOG_PARSEPTR parse_p,  //!< The instance of the parser
    char * macro_name 		//!< The name of the macro to remove.
){
    UTDHASH_ENTRYPTR entry_p ;		   // hash entry exists 
    VERILOG_MACRO_DIRECTIVEPTR macro_p ;   // macro directive

    entry_p = utDhash_find( parse_p->macrodefines, macro_name ) ;
    if( entry_p ){
      macro_p = UTDHASH_GETDATA( entry_p, VERILOG_MACRO_DIRECTIVEPTR ) ;
      if( macro_p ){
	if( macro_p->macro_value ){
	  UTDFREE( macro_p->macro_value ) ;
	}
	UTDFREE( macro_p->macro_id ) ;
	UTDFREE( macro_p ) ;
	BOOL found = utDhash_delete( parse_p->macrodefines, macro_name ) ;
	if(!(found)){
	  fprintf( stderr, "problem deleting %s from macro define tables\n",
	      macro_name ) ;
	}
      }
    } else {
      fprintf( stdout, "could not find macro %s in macro defined tables\n",
	  macro_name ) ;
    } 
    return;
} /* end verilog_preprocessor_macro_undefine() */

//! Creates and returns a new conditional context.
VERILOG_PREPROC_COND_CONTEXTPTR verilog_preprocessor_new_conditional_context(
    char        * condition,          //!< The definition to check for.
    int           line_number         //!< Where the `ifdef came from.
)
{
    VERILOG_PREPROC_COND_CONTEXTPTR context_p ;  // new created context
    
    context_p = UTDCALLOC( 1, VERILOG_PREPROC_COND_CONTEXT ) ;
    context_p ->line_number = line_number ;
    context_p ->condition   = condition ;

    return( context_p ) ;
} /* end verilog_preprocessor_new_conditional_context() */


/*!
@brief Handles an ifdef statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
*/
void verilog_preprocessor_ifdef (
    SVERILOG_PARSEPTR parse_p, //!< The instance of the parser
    char * macro_name,
    unsigned int lineno,
    BOOL is_ndef
)
{
    // Create a new ifdef context.
    VERILOG_PREPROC_COND_CONTEXTPTR topush_p ;  // new context
    VERILOG_MACRO_DIRECTIVEPTR cond_p ;		// context directive
    UTDHASH_ENTRYPTR entry_p ;			// hash entry 

    topush_p = verilog_preprocessor_new_conditional_context(macro_name,lineno) ;
    topush_p->is_ndef = is_ndef ;

    entry_p = utDhash_find( parse_p->macrodefines, macro_name ) ;
    if( entry_p ){
      cond_p = UTDHASH_GETDATA( entry_p, VERILOG_MACRO_DIRECTIVEPTR ) ;
    } else {
      cond_p = NULL ;
    }
    /* was if(((r == HASH_SUCCESS        && is_ndef == AST_FALSE) ||
          (r == HASH_KEY_NOT_FOUND  && is_ndef == AST_TRUE )) &&
          yy_preproc -> emit == AST_FALSE)
     */
    
    if( ((cond_p && !(is_ndef)) || (!(cond_p) && is_ndef)) &&        
	!(parse_p->emit) ){ 
      // Push the context, with the condition true.
      topush_p->condition_passed = TRUE ;
      topush_p->wait_for_endif = TRUE ;
      parse_p->emit = TRUE ;
      utDdeck_push( parse_p->ifdefs, topush_p ) ;

    } else {
      // Push the context, with the condition false.
      topush_p->condition_passed = FALSE ;
      if( !(parse_p->emit) ){
	topush_p->wait_for_endif = TRUE ;
      } else {
	topush_p->wait_for_endif = FALSE ;
      }
      parse_p->emit = FALSE ;
      utDdeck_push( parse_p->ifdefs, topush_p ) ;
    }
} /* end void verilog_preprocessor_ifdef */

/*!
@brief Handles an elseif statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
*/
void verilog_preprocessor_elseif(
    SVERILOG_PARSEPTR parse_p, //!< The instance of the parser
    char * macro_name, 
    unsigned int lineno 
)
{
    UTDHASH_ENTRYPTR entry_p ;			// hash entry 
    VERILOG_MACRO_DIRECTIVEPTR cond_p ;		// context directive
    VERILOG_PREPROC_COND_CONTEXTPTR tocheck_p ; // context to check

    tocheck_p = utDdeck_peek( parse_p->ifdefs, VERILOG_PREPROC_COND_CONTEXTPTR) ;
    if(!(tocheck_p)){
      fprintf( stderr, "ERROR - `elseif without preceding `ifdef or `ifndef on line \
	  %d\n\tExpect it all to go wrong from here.\n", lineno);
      return ;
    }

    entry_p = utDhash_find( parse_p->macrodefines, macro_name ) ;
    if( entry_p ){
      cond_p = UTDHASH_GETDATA( entry_p, VERILOG_MACRO_DIRECTIVEPTR ) ;
    } else {
      cond_p = NULL ;
    }
    /* was if( tocheck_p-> wait_for_endif == AST_FALSE &&
       yy_preproc -> emit        == AST_TRUE)
        if((tocheck -> is_ndef == AST_TRUE  && r == HASH_KEY_NOT_FOUND) ||
           (tocheck -> is_ndef == AST_FALSE && r == HASH_SUCCESS      ))
    */

    if( !(tocheck_p->wait_for_endif) && parse_p->emit ){
      if( (tocheck_p->is_ndef && !(cond_p)) ||
          (!(tocheck_p->is_ndef) && cond_p) ){
	tocheck_p->condition_passed = TRUE ;
	tocheck_p->wait_for_endif = TRUE ;
	parse_p->emit = TRUE ;
      } else {
	parse_p->emit = FALSE ;
	tocheck_p->condition_passed = FALSE ;
      }
    } else {
        parse_p->emit = FALSE ;
        tocheck_p->condition_passed = FALSE ;
    }
} /* end verilog_preprocessor_elseif() */

/*!
@brief Handles an else statement being encountered.
*/
void verilog_preprocessor_else  (
    SVERILOG_PARSEPTR parse_p, //!< The instance of the parser
    unsigned int lineno
)
{
    UTDCARDPTR top_p ;				// top of stack
    UTDCARDPTR parent_card_p ;			// parent of top of deck
    VERILOG_PREPROC_COND_CONTEXTPTR tocheck_p ; // context to check
    VERILOG_PREPROC_COND_CONTEXTPTR parent_p ;  // parent context 

    top_p = utDdeck_top( parse_p->ifdefs ) ;
    if(!(top_p)){
      fprintf( stderr, "ERROR - `else without preceding `ifdef or `ifndef on line \
            %d\n\tExpect it all to go wrong from here.\n", lineno);
      return ;
    }
    tocheck_p = utDdeck_getTop( parse_p->ifdefs, VERILOG_PREPROC_COND_CONTEXTPTR ) ;

    parent_card_p = utDdeck_parent( top_p ) ;
    if( parent_card_p ){
      parent_p = utDdeck_getCardData( parent_card_p, VERILOG_PREPROC_COND_CONTEXTPTR ) ;
    } else {
      parent_p = NULL ;
    }
    
    if ( parse_p->emit && !(tocheck_p->wait_for_endif) ){
      parse_p->emit = FALSE ;
      tocheck_p-> condition_passed = FALSE ;

    } else {
      if( parent_p ){
	if( parent_p->condition_passed ){
	  parse_p->emit = TRUE ;
	  tocheck_p->condition_passed = TRUE ;
	} else {
	  parse_p->emit = FALSE ;
	  tocheck_p->condition_passed = FALSE ;
	}
      } else {
	parse_p->emit = TRUE ;
	tocheck_p->condition_passed = TRUE ;
      }
    }
    tocheck_p->wait_for_endif = TRUE ;;
} /* end verilog_preprocessor_else() */

/*!
@brief Handles an else statement being encountered.
*/
void verilog_preprocessor_endif (
    SVERILOG_PARSEPTR parse_p, //!< The instance of the parser
    unsigned int lineno
)
{
    VERILOG_PREPROC_COND_CONTEXTPTR tocheck_p ; // context to check
    VERILOG_PREPROC_COND_CONTEXTPTR top_p ;     // new top to deck

    tocheck_p = utDdeck_pop( parse_p->ifdefs ) ;
    if (!(tocheck_p)){
      fprintf(stderr,"ERROR - `endif without preceding `ifdef or `ifndef on line \
            %d\n\tExpect it all to go wrong from here.\n", lineno);
      return ;
    }
    UTDFREE( tocheck_p ) ;

    top_p = utDdeck_peek( parse_p->ifdefs, VERILOG_PREPROC_COND_CONTEXTPTR ) ;

    if( !(top_p)){
      parse_p->emit = TRUE ;
    } else {
      parse_p->emit = top_p->condition_passed ;
    }
} /* end verilog_preprocessor_endif() */

char *sverilog_new_identifier( SVERILOG_PARSEPTR parse_p,
                               char *string, unsigned int line_no)
{
    char *identifier_p ;			// The identifier

    // We could do more with this and save identifier type.  Not sure
    // it is necessary.  For now just clone.  FIXME: put in string hash table.
    identifier_p = utDstrclone( string ) ;
    return( identifier_p ) ;
} /* end sverilog_new_identifier() */

/*!
@brief Set the expected expression identifier
@details When activated this allows us to enable the more extensive
lex tokenize state searching for expressions.   We do this to avoid
having complex rules in the YACC grammar at the cost of possibly
having a hierarchical grammar engine.
*/
void sverilog_expect_expression( SVERILOG_PARSEPTR parse_p, BOOL state )
{
    if( parse_p ){
      parse_p->check_for_expression = state ;
    }
} /* end sverilog_expect_expression() */

/*!
@brief Registers a new default net type directive.
@details Adds a record of the directive to the end of the linked list
"net_types" in the global yy_preproc.
*/
void verilog_preproc_default_net(
    SVERILOG_PARSEPTR parse_p, //!< The instance of the parser
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    SVERILOG_NET_TYPE_T type    //!< The net type.
)
{
    VERILOG_DEFAULT_NET_TYPEPTR net_type_p ;
    net_type_p = verilog_new_default_net_type( parse_p, token_number,
	                                       line_number, type ) ;
    utDdeck_enqueue( parse_p->net_types, net_type_p ) ;

} /* end verilog_preproc_default_net() */

//! Creates and returns a new default net type directive.
VERILOG_DEFAULT_NET_TYPEPTR verilog_new_default_net_type(
    SVERILOG_PARSEPTR parse_p, //!< The instance of the parser
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    SVERILOG_NET_TYPE_T type    //!< The net type.
){
    VERILOG_DEFAULT_NET_TYPEPTR net_type_p ;
    net_type_p = UTDCALLOC(1,VERILOG_DEFAULT_NET_TYPE) ;

    net_type_p->token_number = token_number ;
    net_type_p->line_number  = line_number ;
    net_type_p->type         = type ;

    return (net_type_p) ;

} /* end verilog_default_net_type() */

/*!
@brief Cleanup file stack as we are done with the current file.
*/
void verilog_pop_file_stack( SVERILOG_PARSEPTR parse_p )
{
    VERILOG_FILEPTR top_p ;		/* current file being processed */

    if( parse_p->file_stack ){
      top_p = utDdeck_pop( parse_p->file_stack ) ;
      if( top_p ){
	if( top_p->fp ){
	  UTDCLOSE( top_p->fp ) ;
	  top_p->fp = NULL ;
	}
	if( top_p->filename ){
	  UTDFREE( top_p->filename ) ;
	}
	UTDFREE( top_p ) ;
      }
    }
    parse_p->file_name = NULL ;
} /* end verilog_pop_file_stack() */

const char *sverilog_line_start( const char *string )
{
  const char *start ;		/* start of line  */
  for( start = string ; *start && *start != '\n' ; start-- ){
    /* empty */
  }
  start++ ;
  return( start ) ;
} /* end sverilog_line_start() */

int sverilog_show_position( const char *start, const char *msg )
{
   int pos ;
   if( start && msg ){
     pos = msg - start ;
   } else {
     pos = 0 ;
   }
   return( pos ) ;
} /* end line_position() */


SVER_CALLBACK *sverilog_callback_funcs( SVERILOG_PARSEPTR parse_p, BOOL initialize)
{
    INT func ;			/* count functions */
    if( initialize ){
      for( func = 0 ; func <= SVER_CALLBACK_LAST_FUNC ; func++ ){
	parse_p->callbacks[func].f.void_func = NULL ;
      }
    }
    return( parse_p->callbacks ) ;
} /* end sverilog_callback_funcs() */

static int sver_echo_string( SVERILOG_PARSEPTR parse_p, void *user_data, char *string )
{
    fprintf( stderr, " %s", string ) ;
    return(0) ;
} /* end sver_echo_string() */


SVER_CALLBACKPTR sverilog_parser_add_default_callbacks( SVERILOG_PARSEPTR parse_p,
                                                        void *user_data )
{
    SVER_CALLBACKPTR callbacks ;	/* array of callbacks */

    if( parse_p ){
      callbacks = sverilog_callback_funcs(parse_p,TRUE) ;
      if( callbacks ){
	callbacks[SVERCB_EXPR_OP_F].f.expr_op_func = (SVER_CALLBACK_expr_op *) sver_expr_merge_expressions ;
	callbacks[SVERCB_EXPR_ADD_CONCAT_F].f.expr_op_func = (SVER_CALLBACK_expr_op *) sver_expr_merge_expressions ;
	callbacks[SVERCB_MODULE_NAME_F].f.str1_func = sver_echo_string ;
	callbacks[SVERCB_MODULE_END_F].f.str1_func = sver_echo_string ;
	parse_p->user_data = user_data ;
      }
      return(callbacks) ;
    }
    return(NULL) ;

} /* end sverilog_parser_add_default_callbacks() */


/* -----------------------------------------------------------------
 * The input string is a possibly unterminated string which has as
 * the prefix an integer representation.  We need to find the end.
 * ----------------------------------------------------------------- */
char * sver_convert_integer( SVERILOG_PARSEPTR parse_p, INT base, char *unterminated_string, LONG *int_rep )
{
    char *end_ptr ;		/* find end of the integer */
    INT len ;			/* length of string */

    if( int_rep ){
      *int_rep = strtol( unterminated_string, &end_ptr, base ) ;
      if( *end_ptr == EOS ){
	/* The full string */
	strcpy( parse_p->number_base, unterminated_string ) ;
      } else {
	len = end_ptr - unterminated_string ;
	strncpy( parse_p->number_base, unterminated_string, len ) ;
	parse_p->number_base[len] = EOS ;
      }
      return( parse_p->number_base ) ;
    }
    return(NULL) ;
} /* end sver_convert_integer() */

/* -----------------------------------------------------------------
 * The input string is a possibly unterminated string which has as
 * the prefix a floating point representation.  We need to find the end.
 * ----------------------------------------------------------------- */
char * sver_convert_real( SVERILOG_PARSEPTR parse_p, char *unterminated_string, DOUBLE *float_rep )
{
    char *end_ptr ;		/* find end of the integer */
    INT len ;			/* length of string */

    if( float_rep ){
      *float_rep = strtod( unterminated_string, &end_ptr ) ;
      if( *end_ptr == EOS ){
	/* The full string */
	strcpy( parse_p->number_base, unterminated_string ) ;
      } else {
	len = end_ptr - unterminated_string ;
	strncpy( parse_p->number_base, unterminated_string, len ) ;
	parse_p->number_base[len] = EOS ;
      }
      return( parse_p->number_base ) ;
    }
    return(NULL) ;
} /* end sver_convert_real() */
