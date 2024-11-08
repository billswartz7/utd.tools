/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2022 William Swartz.  UTD.  All rights reserved.
FILE:	    mmap.h
DESCRIPTION:Include file for memory mapping of files.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_MMAP_H
#define INCLUDED_UTD_MMAP_H

#include <utd/msg.h>
#include <utd/dstring.h>

/* ********************** TYPE DEFINITIONS ************************* */
typedef struct utdmap_file_rec {
  char *data ;
  LONG size ;
  INT fileid ;
} UTDMAPFILE, *UTDMAPFILEPTR ;

typedef struct utdmap_gets_rec {
  char *ptr ;
  UTDDSTRING line_buf ;
  UTDMAPFILEPTR mapfile ;
} UTDMAPGETS, *UTDMAPGETSPTR ;

#define utDmmap_size(map_xz)	((map_xz)->size)
#define utDmmap_data(map_xz)	((map_xz)->data)

/* -----------------------------------------------------------------
 * Similar to utDfile_open except that the file is memory mapped for speed.
 * Returns a UTDMAPFILEPTR which is used in utDmmap_size and utDmmap_data
 * functions.
----------------------------------------------------------------- */
extern UTDMAPFILEPTR utDmmap_open(char *filename, char *readwrite, INT abort_flags) ;

/* -----------------------------------------------------------------
 * Close a memory mapped file.
----------------------------------------------------------------- */
extern void utDmmap_close( UTDMAPFILEPTR mmap_p ) ;

/* -----------------------------------------------------------------
 * Routines to read a mapped file using functions like fgets.
----------------------------------------------------------------- */
extern UTDMAPGETSPTR utDmmap_gets_init( UTDMAPFILEPTR mmap_p ) ;
extern void utDmmap_gets_free( UTDMAPGETSPTR mgets_p ) ;

/* -----------------------------------------------------------------
 * Read the file use mapped gets.
----------------------------------------------------------------- */
extern char *utDmmap_gets( UTDMAPGETSPTR mgets_p ) ;

/* -----------------------------------------------------------------
 * Get the next line from a mapped file lower level.
 ----------------------------------------------------------------- */
extern char *utDmmap_next_line( char *ptr, char *data, INT fsize, INT *line_len ) ;

#endif /* INCLUDED_UTD_MMAP_H */

