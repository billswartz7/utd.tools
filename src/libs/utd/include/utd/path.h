/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    path.h
DESCRIPTION:File path file interface for C.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_PATH_H
#define INCLUDED_UTD_PATH_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */
/*
utDpath_abs -
Function:
    Returns the absolute pathname on a filesystem.
    It returns a pointer to static memory.
	
*/
extern const char *utDpath_abs( const char *given_path, BOOL fileNotDir ) ;

/*
utDpath_rel -
Function:
    Returns the absolute pathname on a filesystem given a rel_path.
    It returns a pointer to static memory.
       if known path is   :/twolf6/bills/tw/pgms/test 
       and rel_path       :./src
       result should be:/twolf6/bills/tw/pgms/test/src
*/
extern char *utDpath_rel( char *known_path, char *rel_path ) ;

/*
utDpath_fully_qualified -
Function:
    Returns the fully qualified path given a path.  If a path_buf is furnished
    the fully qualified path is loaded into the buffer; otherwise if NULL,
    the returned path is cloned and the given string is freed.
*/
extern char *utDpath_fully_qualified( char *path, char *path_buf ) ;

/*
utDpath_adjust_file_name -
Function:
    Traverse upward by a maximum number of directories specified by max_up.
    Returns cloned pathname.  User responsible for free.
*/
extern char *utDpath_adjust_file_name( char *fname, INT max_up ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_PATH_H */
