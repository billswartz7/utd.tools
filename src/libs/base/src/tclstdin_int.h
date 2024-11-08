/* ----------------------------------------------------------------- 
     Copyright (c) 2005 InternetCad.com.  All rights reserved.
FILE:	    tclstdin_int.c
DESCRIPTION:This file contains a basic stdin channel reader for itools.
DATE:	    Sat Mar 19 01:42:17 CST 2005
REVISIONS:  
 * $Log: tclstdin.c,v $
 * Revision 1.1  2021/07/01 00:50:19  bills
 * Initial revision
 *
 * Revision 1.1  2021/06/20 15:36:57  bill
 * Initial revision
 *
 * Revision 1.14  2020/07/06 14:56:34  bills
 * Now we check for the end of input so we give a proper error message when
 * Tcl runs on to the next line.
 *
 * Revision 1.13  2019/11/14 00:02:04  bills
 * Replaced inter_p->result with Tcl_GetStringResult.
 *
 * Revision 1.12  2019/09/21 04:29:22  bills
 * Fixed for off by one error.
 *
 * Revision 1.11  2019/09/17 00:46:23  bills
 * Now we don't add twpython::mode to tcommand buffer twice.  A simple constant
 * string suffices.
 *
 * Revision 1.10  2019/09/16 17:26:04  bills
 * Added line input processing for TimberWolfDR.
 *
 * Revision 1.9  2019/09/12 12:50:24  bills
 * Now properly handle a TCL_CONTINUE in a channel.   In addition, we properly
 * reset input on a successful parse.
 *
 * Revision 1.8  2019/09/11 20:12:46  bills
 * Added MMAP capability and changed from IC_xxx to TW_xxx names.   Also
 * added TWtcl_stdin_get_input function in order to handle mmap and fgets
 * data transparently.
 *
 * Revision 1.7  2019/09/02 13:42:35  bills
 * Added TWtcl_stdin_string_line_feeds and support for stdout result option.
 *
 * Revision 1.6  2019/08/26 13:54:08  bills
 * Changed from ICtclxxx to TWtclxxx and added support for integrated Python
 * interpreter.
 *
 * Revision 1.5  2019/08/20 13:39:07  bills
 * Added missing include files <unistd.h>.
 *
 * Revision 1.4  2013/02/15 20:31:43  bills
 * Updated so that exit on close works properly.
 * 
 * Revision 1.3  2013/02/14  15:40:11  bills
 * Fixed problem crashing when stdin end-of-file was detected.
 *
 * Revision 1.2  2006/05/06  22:13:22  bills
 * Major rewrite of this code in order to consolidate the stdin readers.
 * In addition, we fixed a long standing problem with the stdin reader
 * waiting for data when there is no stdin or it has been closed in
 * the parent.
 *
 * Revision 1.1  2005/11/20  06:18:17  bills
 * Initial revision
 *
----------------------------------------------------------------- */
#ifndef UTDTCL_STDIN_INT_H
#define UTDTCL_STDIN_INT_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* ********************** TYPE DEFINITIONS ************************* */
typedef struct utdstdin_rec {
  Tcl_DString line ;			/* read a line */
  UTDDSTRING tcommand ;			/* build a Tcl command */
  Tcl_Channel inChannel ;		/* channel */
  Tcl_Interp *interp ;			/* interpreter */
  BOOL gotPartial ;			/* command complete */
  BOOL echo_cmds ;			/* echo commands */
  BOOL stdout_only ;			/* output only to stdout */
  BOOL stdout_result ;			/* output result to stdout */
  BOOL exit_on_close ;			/* exit on channel close */
  BOOL end_of_input ;			/* no more input present */
  BOOL use_channel ;			/* create a channel handler */
  BOOL need_python_init ;		/* call the Python initialization */
  BOOL in_close_process ;		/* in process of closing */
  FILE *did_file ;			/* output to did file */
  union {
    FILE *input_file ;			/* input file */
    /* YMAPGETSPTR mgets_p ;	*/	/* read a memory mapped file */
    UTDSCRIPT_RECPTR script_lines ;	/* read script lines */
  } d ;
  UTDSTDIN_OPT_T input_type ;		/* input type */
  char *do_file_name ;			/* name of do file if it exists */
  char *input_buffer ;			/* input buffer */
  INT do_file_line ;			/* do file line number */
  INT input_buffer_size ;		/* input buffer size allocation */
  UTDtcl_stdinProc prompt_func ;		/* prompt function */
} UTDSTDIN_DATA, *UTDSTDIN_DATAPTR ;

#define Tcl_DStringReinit(x_xz) Tcl_DStringSetLength(x_xz,0)

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* UTDTCL_STDIN_INT_H */
