/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
     Copyright (c) 1993-2018 TimberWolf Systems, Inc. All rights reserved.
FILE:	     log.h 
DESCRIPTION: prototypes for the UTD logging functions.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_LOG_H
#define INCLUDED_UTD_LOG_H

#include <utd/base.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef enum {
  UTDLOG_START_NONE =   	(0),
  UTDLOG_START_DIVIDER = 	(1),
  UTDLOG_START_UTDHOME_DIR = 	(1 << 1)
} UTDLOG_START_T ;

typedef enum {
  UTDLOG_NONE =     		(0),
  UTDLOG_OUTPUT =   		(1),
  UTDLOG_SHORT_INTRO = 		(1 << 1),
  UTDLOG_FULL_INTRO = 		(1 << 2),
  UTDLOG_ADJUST_PLACE =		(1 << 3),
  UTDLOG_ADJUST_ROUTE =		(1 << 4),
  UTDLOG_ADJUST_FLOORPLAN =	(1 << 5)
} UTDLOG_OPT_T ;

/* put a message in the log file with a time stamp */
extern void utDlog_msg( const char *message,BOOL time_flag ) ;

/* -----------------------------------------------------------------
 * Initialize the log file.  Must be called before utDlog_msg can be
 * used.  Divider_flag determines whether a divider bar is put in
 * the log file.  Now pass the argument vector.  Also use can override 
 * the default path name of log file.
----------------------------------------------------------------- */
extern void utDlog_start( const char *dsn,const char *msg,UTDLOG_START_T opts,
                          INT argc,char *argv[], const char *log_path_name) ;

/* -----------------------------------------------------------------
 * Build an intro.  See UTDLOG_OPT_T options for different options.
----------------------------------------------------------------- */
extern void utDlog_intro( const char *intro, char *full_msg, UTDLOG_OPT_T options ) ;

/* -----------------------------------------------------------------
 * Stop logging messages to log file.  Must use log_start to restart
 * sending messages.
----------------------------------------------------------------- */
extern void utDlog_end( void ) ;

/* -----------------------------------------------------------------
 * Add a completion log to the log file. 
----------------------------------------------------------------- */
void utDlog_exit(char *programName, INT errors, INT warnings ) ;

/* -----------------------------------------------------------------
 * Adjust the log path.  Given /xx/y/z/hierarchy/p1/stage1 returns
 * /xx/y/z.  If hierarchy does not exist in the path, returns NULL.
----------------------------------------------------------------- */
extern char *utDlog_adjust_full_path( char *pathbuf ) ;

/* -----------------------------------------------------------------
 * Change the log pathname.  If NULL is passed, pick the current
 * directory; otherwise use the name found.
----------------------------------------------------------------- */
extern char *utDlog_new_pathname(char *new_pathname) ;

/* -----------------------------------------------------------------
 * Returns the current log pathname.
----------------------------------------------------------------- */
extern char *utDlog_pathname(void) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_LOG_H */
