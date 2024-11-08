/*!
@file parse.h
@brief Contains all the functions that users need to use the Verilog parser
*/

#ifndef VERILOG_PARSE_H
#define VERILOG_PARSE_H


#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef SVERILOG_INTERNAL_DEFS
typedef struct sverilog_parse_context_rec *SVERILOG_PARSEPTR ;
#endif /* SVERILOG_INTERNAL_DEFS */

/* -----------------------------------------------------------------
 * These are options to the parser.  Strict verilog option ignores
 * System Verilog tokens.  The debug option allows you to turn on
 * state debugging if the code was compiled with the DEBUG compile
 * switch
 * ----------------------------------------------------------------- */
typedef enum {
  SVERILOG_OPTION_NONE_T 	 	= 0,
  SVERILOG_OPTION_STRICT_VERILOG_T 	= 1,
  SVERILOG_OPTION_DEBUG_T 		= (1L < 1)
} SVERILOG_OPTIONS_T ;

//! Parser initialize code, returns a parsing object.
extern SVERILOG_PARSEPTR sverilog_parser_init( SVERILOG_OPTIONS_T option ) ;

//! Parser adds to the directory search paths
extern void sverilog_parser_add_search_path( SVERILOG_PARSEPTR parse_p,
                                             const char *path ) ;
// The top level parsing interface
extern int sverilog_parse_file( SVERILOG_PARSEPTR parse_p, char *filename ) ;

//! Ask for the output of the preprocessor.  Output is sent to the specified
// open file descriptor.
extern void sverilog_parser_set_preprocess_output( SVERILOG_PARSEPTR parse_p,
                                                   FILE *pre_output_p ) ;

//! Get the number of errors found.
extern int sverilog_parser_get_errors( SVERILOG_PARSEPTR parse_p ) ;

//! Get the current line number.
extern int sverilog_parse_lineno( SVERILOG_PARSEPTR parse_p ) ;

//! Get the current file name
extern const char * sverilog_parse_filename( SVERILOG_PARSEPTR parse_p ) ;

//! Add the default callbacks.  User may added use data.
extern SVER_CALLBACKPTR sverilog_parser_add_default_callbacks( SVERILOG_PARSEPTR parse_p,
                                                               void *user_data ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif

