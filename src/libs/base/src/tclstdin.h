/* ----------------------------------------------------------------- 
FILE:	    tclstding.h                                       
DESCRIPTION:This file contains include definitions for the Tcl stdin channel.
CONTENTS:   MACRO DEFINITIONS
DATE:	    Sat Mar 19 02:16:48 CST 2005
REVISIONS:  
 * $Log: tclstdin.h,v $
 * Revision 1.7  2019/09/16 16:53:07  bills
 * Added STDIN_OPT_LINE_INPUT for detailed router.
 *
 * Revision 1.6  2019/09/11 20:09:54  bills
 * Added STDIN_OPT_MMAP_INPUT and added the input argument to TWtcl_stdin as
 * well as added the TWtcl_stdin_get_input prototype.
 *
 * Revision 1.5  2019/09/02 13:39:47  bills
 * Added STDIN_OPT_STDOUT_RESULT option.
 *
 * Revision 1.4  2019/08/26 13:41:58  bills
 * Fixed log.
 *
 * Revision 1.3  2019/08/26 13:39:32  bills
 * Modified so we can support new TWtcl_stdin_data and TWtcl_stdin_line command.
 * Renamed from ICtclxxx to TWtclxxx.   Added STDIP_NO_CHANNEL for pure
 * interpreters.
 * 
 * Revision 1.2  2006/05/06 22:06:12  bills
 * Added STDIN_OPT_T definition and added various ICtcl_stdin prototypes
 * for the new ability to add and delete a stdin function.
 * 
 * Revision 1.1  2005/11/20  06:23:01  bills
 * Initial revision
 *
----------------------------------------------------------------- */
#ifndef UTDTCL_STDIN_H
#define UTDTCL_STDIN_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef enum {
  UTDSTDIN_OPT_NONE_T =			0, 
  UTDSTDIN_OPT_ECHO_CMDS_T = 		1,
  UTDSTDIN_OPT_EXIT_ON_CLOSE_T = 	(1 << 1),
  UTDSTDIN_OPT_STDOUT_ONLY_T = 		(1 << 2),
  UTDSTDIN_OPT_STDOUT_RESULT_T =  	(1 << 3),
  UTDSTDIN_OPT_MMAP_INPUT_T =  		(1 << 4),
  UTDSTDIN_OPT_LINE_INPUT_T =  		(1 << 5),
  UTDSTDIN_OPT_NO_CHANNEL_T = 		(1 << 6)
} UTDSTDIN_OPT_T ;


#define UTDTCL_INPUT_MASK  	(UTDSTDIN_OPT_MMAP_INPUT_T | UTDSTDIN_OPT_LINE_INPUT_T)
/* -----------------------------------------------------------------
 * This definition helps us handle scripts which are arrays of lines.
 * ----------------------------------------------------------------- */
typedef struct utdtcl_script_rec {
  char *script ;			/* complete script */
  char **line_data ;			/* data for the line */
  INT *line_addr ;			/* address of current line */
  INT num_lines ;			/* number of lines */
} UTDSCRIPT_REC, *UTDSCRIPT_RECPTR ;

typedef void (*UTDtcl_stdinProc)( Tcl_Interp *inter_p, BOOL partial ) ;
#ifdef FULL_UTDSTDIN_DEF
#include "tclstdin_int.h"
#else 
typedef struct utdstdin_rec *UTDSTDIN_DATAPTR ;
#endif /* FULL_UTDSTIN_DEF */
/* -----------------------------------------------------------------
 * Tcl stdin function.
----------------------------------------------------------------- */
extern UTDSTDIN_DATAPTR utDtcl_stdin(Tcl_Interp *inter_p,VOIDPTR input_p,FILE *did_file,char *do_file_name,UTDSTDIN_OPT_T opts ) ;
extern void utDtcl_stdinDelete(Tcl_Interp *interp) ;
extern void utDtcl_stdinPromptFunc( UTDtcl_stdinProc func ) ;
extern void utDtcl_stdinPrompt( Tcl_Interp *inter_p, BOOL partial ) ;
extern BOOL utDtcl_stdinExists(void) ;
extern INT utDtcl_stdin_data( Tcl_Interp *i_p, UTDSTDIN_DATAPTR stdin_p, char *line ) ;
extern INT utDtcl_stdin_line( UTDSTDIN_DATAPTR stdin_p, INT line_num ) ;
extern void utDtcl_stdin_strip_line_feeds( char *bufferptr ) ;
extern char *utDtcl_stdin_get_input( UTDSTDIN_DATAPTR stdin_p ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* UTDTCL_STDIN_H */
