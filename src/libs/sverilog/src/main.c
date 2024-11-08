/*!
@file main.c
@brief A simple test program for the C library code.
*/

#include <sverilog_config.h>
#include "stdio.h"
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */
#include <sverilog/sverilog.h>
#include <sverilog/callbacks.h>
#include <sverilog/parse.h>
#include <utd/base.h>
#include <utd/file.h>

int main(int argc, char ** argv)
{
    int fcount ;		/* file counter */
    int result ;		/* last result */
    SVERILOG_OPTIONS_T options ;/* options to the parser */
    FILE *pre_output_p ;	/* preprocessor output file */
    char preproc_file[LRECL] ;	/* build a file name */

    if(argc < 2) {
        printf("ERROR. Please supply at least one file path argument.\n");
        return 1;
    } else {

      result = 0 ;

      // Initialise the parser.
      options = SVERILOG_OPTION_NONE_T ;
      SVERILOG_PARSEPTR parse_p = sverilog_parser_init( options ) ;

      // Setup the order to search for Verilog include files
      sverilog_parser_add_search_path( parse_p, "./tests/" ) ;
      sverilog_parser_add_search_path( parse_p, "../tests/" ) ;
      sverilog_parser_add_search_path( parse_p, "./" ) ;

      sverilog_parser_add_default_callbacks( parse_p, NULL ) ;

      // Install your personalized callbacks here.
      //

      for( fcount = 1 ; fcount < argc; fcount++ ) {
	char *filename = argv[fcount] ;
	printf("%s ", filename ) ;
	fflush(stdout) ;

	/* output the result of the preprocessor */
	sprintf( preproc_file, "%s.preproc", filename ) ; 
	pre_output_p = UTDOPEN( preproc_file, "w", FILE_VERBOSE | FILE_NOABORT ) ;
	sverilog_parser_set_preprocess_output( parse_p, pre_output_p ) ;

	// Parse the file and store the result.
	result = sverilog_parse_file( parse_p, filename ) ;

	if( pre_output_p ){
	  UTDCLOSE( pre_output_p ) ;
	  sverilog_parser_set_preprocess_output( parse_p, NULL ) ;
	}

	if ( result == 0 ) {
	  int num_errors = sverilog_parser_get_errors( parse_p ) ;
	  if( num_errors ){
	    printf(" - Errors detected but parse successful\n");
	  } else {
	    printf(" - Parse successful\n");
	  }
	} else {
	  printf(" - Parse failed\n");
        }
      }
    }
    exit( result ) ;
    return (0) ;
}
