/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    file.h
DESCRIPTION:Generalized file interface for C.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_FILE_H
#define INCLUDED_UTD_FILE_H

#include <utd/base.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef enum { 
  FILE_COMPRESS_CURRENT_T = -1, 
  FILE_COMPRESS_GZIP_T = 0,
  FILE_COMPRESS_BZIP2_T = 1,
  FILE_COMPRESS_UNIX_T = 2,
  FILE_COMPRESS_XZ_T = 3
} UTD_FILE_COMPRESS_TYPE ;

/* This must match the largest in the set */
#define UTD_MAX_COMPRESS_TYPE_T FILE_COMPRESS_XZ_T

/* I/O MACRO DEFINITIONS */
typedef enum { 
  FILE_ABORT = 1, 
  FILE_NOABORT = 0,
  FILE_VERBOSE = (1L<<1) 
} FILE_T ;

typedef enum {
  UTDFILE_NONE = 	0,
  UTDFILE_READ =	1,
  UTDFILE_WRITE = 	(1 << 1),
  UTDFILE_EXECUTE = 	(1 << 2),
  UTDFILE_FILE_EXISTS =	(1 << 3),
  UTDFILE_USER_T = 	(1 << 4),
  UTDFILE_GROUP_T = 	(1 << 5),
  UTDFILE_WORLD_T = 	(1 << 6)
} FILE_ACCESS_T ;

/* -----------------------------------------------------------------
 * utDfile_enumerate_dir callback function.
----------------------------------------------------------------- */
typedef void  (*utDfile_enum_func)(char *dirname,char *filename ,void *udata) ;

extern FILE *utDfile_open( const char *filename,const char *readwrite, INT abort ) ;
/*
Function:
    Open the given file name for reading and/or writing.  Readwrite is
    the standard C lib control string. It may be "w", "r", "a", "w+",
    etc.  If abort is set to TRUE, the program will exit if the file
    cannot be found and an appropriate error message will be output.
    If abort is set to FALSE, the routine will return a NULL pointer
    if the file could not be opened.
    New feature: If the first character of the readwrite string is 'Z',
    utDfile_open will attempt to open a pipe to the unix compress tools,
    compress, and zcat.  This is useful to save filespace. This means
    the files will be read and written in compressed format.
    If string is 'Zr', and the a .Z file with the specified name does
    not exist, utDfile_open will attempt to open the filename without the
    .Z suffix.
*/

extern BOOL utDfileExists( const char *pathname ) ;
/*
Function:
    Returns TRUE if the given file exists.  It returns FALSE otherwise.
*/

extern BOOL utDlinkExists( const char *pathname ) ;
/*
Function:
    Returns TRUE if the given file has been linked.  It returns FALSE otherwise.
*/

extern BOOL utDfile_Z_exists( const char *pathname ) ;
/*
Function:
    Returns TRUE if either the given file exists or it exists in its 
    compressed form.  It returns FALSE otherwise.
*/

extern UTD_FILE_COMPRESS_TYPE utDfile_compress_type( UTD_FILE_COMPRESS_TYPE type ) ;
/*
Function:
    Set the file compression algorithm.
    Returns the current compression algorithm.
*/

extern BOOL utDdirectoryExists( const char *pathname ) ;
/*
Function:
    Returns TRUE if the given pathname is a directory and it exists.
    It returns FALSE otherwise.
*/

extern void utDfile_echo( FILE *fin, FILE *fout ) ;
/*
Function:
    Reads from file in and write to file out.  Read starts at position
    of input file pointer.  Write starts at beginning of output file pointer.
    There is no check on whether files have been opened properly for read
    and write.
*/

extern FILE *utDfile_create_lock( char *filename, BOOL readNotWrite ) ;
/*
Function:
    Creates a lock file ready for read or write 
*/

extern BOOL utDfile_test_lock( char *filename ) ; 
/*
Function:
    See if a file is locked.
*/

extern char *utDfile_slink( const char *pathname ) ; 
/*
Function:
    Return symbolic link of a file.
*/

extern void utDfile_symlink( char *resides, char *filename ) ; 
/*
Function:
    Creates a symbolic link for a file.  Resides tells where file
    actually resides.
*/

extern BOOL utDfile_is_slink(const char *pathname) ;
/*
Function:
    Returns TRUE if file is a symbolic link.
*/

extern LONG utDfile_size( const char *filename ) ; 
/*
Function:
    Returns the size of a file in bytes.
*/

extern INT utDfile_delete(char *pathname) ;
/*
Function:
    Delete a given file.  Returns status code -1 is an error.
*/

extern char *utDfile_backup( char *pathname, char *buffer, INT len ) ;
/*
Function:
    To save a given file if it exists.  To save the file, move the
    file to pathname.# where number is the first # which doesn't exist.
    Returns the old path if a backup was made and a buffer was specified.
    If buffer was not specified and a backup was made, returns pathname.
    Otherwise, it returns NULL.
*/

extern char *utDdirectory_backup( char *pathname, char *buffer, INT len ) ;
/*
Function:
    To save a given directory if it exists.  To save the directory, move the
    directory to pathname.# where number is the first # which doesn't exist.
    Returns the old path if a backup was made and a buffer was specified.
    If buffer was not specified and a backup was made, returns pathname.
    Otherwise, it returns NULL.
*/

extern INT utDfile_enumerate_dir( char *dirname, utDfile_enum_func cb_func, 
                                 VOIDPTR user_data) ;
/*
Function:
    This function enumerates the given directory calling the supplied 
    callback on each file.  You may pass user data to this function.
    You should be aware that both . and ../ are enumerated in this
    function.  You might need to ignore them depending on your use.
    Returns 1 if directory could not be opened; 0 otherwise. 
*/

extern INT utDfile_max_open_files(INT *limit,BOOL max_limit) ;
/*
Function:
    Returns the soft limit of max # of open files allowed.  Argument if 
    non null returns the hard limit.  If max_limit is set, try to set
    the max limit.
*/

extern INT utDfile_access(char *pathname,FILE_ACCESS_T modes) ;
/*
Function:
    Returns whether a file can be accessed in a given mode.  The modes may
    be exclusively or'd together. Returns 0 if file can be accessed.
*/

extern INT utDfile_fchmod(FILE *fp,FILE_ACCESS_T modes) ;
/*
Function:
    Set the access modes of a file.  Unlike fchmod we do each group,
    world and user seperately.  Returns non zero if a failure occured.
*/

extern INT utDfile_chmod( char *pathname,FILE_ACCESS_T modes) ;
/*
Function:
    Set the access modes of a file.  Unlike fchmod we do each group,
    world and user seperately.  Returns non zero if a failure occured.
*/

#define UTDOPEN( a_z, b_z, c_z )  utDfile_open( a_z, b_z, c_z )
#define UTDCLOSE( a_z )           fclose( a_z )

#ifdef __cplusplus
} ;
#endif /* __cplusplus */


#endif /* FILE_H */
