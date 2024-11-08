/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    interactive.h
DESCRIPTION:Definition for Tcl interactive state
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_GUI_INTERACTIVE_H
#define INCLUDED_GUI_INTERACTIVE_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

  typedef struct {
    Tcl_Channel input ;		/* The standard input channel from which lines
				 * are read. */
    int tty ;			/* Non-zero means standard input is a
				 * terminal-like device. Zero means it's a
				 * file. */
    Tcl_DString command ;	/* Used to assemble lines of terminal input
				 * into Tcl commands. */
    Tcl_DString line ;		/* Used to read the next line from the
				 * terminal input. */
    BOOL gotPartial ;
    BOOL stdout_only ;		/* Standard output only */
    BOOL echo_cmds ;		/* echo the commands back to user */
    Tcl_Interp *interp ;	/* Interpreter that evaluates interactive
				 * commands. */
    FILE *did_file ;		/* Where to send Did commands */
  } InteractiveState, *InteractiveStatePtr ;


#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif //INCLUDED_GUI_INTERACTIVE_H 
