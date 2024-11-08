/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    string.h
DESCRIPTION:Definitions for string manipulation.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_STRING_H
#define INCLUDED_UTD_STRING_H

#include <utd/base.h>
#include <sys/types.h>
#include <ctype.h>

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#define utDstrdup( a_string )  utDstrclone( a_string )
extern char *utDstrclone( const char *str ) ;
/* 
Function:
    Clone a string by allocating memory.  User must free memory when done.
*/

#define utDstrparser( str, delim, argc )  utDstrparser2(str,delim,NULL,argc)
extern char **utDstrparser2( char *str,char *delimiters,char **buf,INT *argc ) ;
/*
Function:
    This string parsing function uses strtok to break up the string
    into tokens delimited by the set of characters given in the delimiter
    string.  Argc is set to the number of parsed tokens.  The function
    returns a pointer to an array of all the tokens each of which has
    been terminated with EOS.  This function destroys the given string
    so remember to copy the string if you need the original string for
    future use.  Buf is the storage for the array of tokens.  If buf is
    null, uses built in buffer.
*/

extern char *utDremove_lblanks( char *bufferptr ) ;
/* 
Function:
    Remove leading blanks and tabs from a string.
*/

/* 
Function:
    Very often used string functions that are defined by system.
    See man pages for details.
*/

extern char *utDstrtok(char *str, char *dels) ;
extern char *utDstrucpy( char *dest,char *src ) ;
extern char *utDstrlcpy( char *dest,char *src ) ;
extern char *utDstrupr( char *str ) ;
extern char *utDstrlwr( char *str ) ;
extern INT utDstricmp(  const char *str1, const char *str2 ) ; 
extern INT utDstrnicmp(  const char *str1, const char *str2, INT n ) ; 
extern char *utDstrndup( char *str,INT len) ;
extern char *utDstrpbrk( char *str1,char *str2 ) ;
extern INT utDstrspn( char *str1,char *str2 ) ;
extern INT utDstrcspn( char *str1,char *str2 ) ;
extern char *utDstrltrim( char *str,char *charset ) ;
extern char *utDstrrtrim( char *str,char *charset ) ;
extern char *utDstrtrim( char *str,char *charset ) ;
extern char *utDstrjoin( char *argv[],char separator[] ) ;
extern char *utDstrsub( char *string,char *substring ) ;
extern char *utDstrlsub( char *string,char *substring ) ;
extern char *utDstrisub( char *string,char *substring ) ;
extern INT utDstr_get_argpfx( char *str ) ;
extern char *utDstr_get_argdesc( char *str,INT *len ) ;
extern char *utDstr_get_argname( char *s,char *buf ) ;
extern char *utDstr_get_kwdname( char *s,char *buf ) ;
extern INT utDstr_match( char *candidate, char *target ) ;
extern char *utDstr_basename( char path[] ) ;
extern char *utDstr_dirname( char path[], char *buffer, INT len ) ;
extern char *utDstr_remove_dquotes( char *string ) ;
extern char *utDstr_remove_squotes( char *string ) ;
extern char *utDstr_remove_char( char *string, INT ch ) ;
extern char utDstr_last_char( const char *string ) ;
extern char *utDstr_last_char_ptr( const char *string ) ;
extern void utDstr_indent_para( FILE *fp,INT,INT,char *ti,INT,char *text,INT ) ;
extern BOOL utDstr_isa_integer( char *string ) ;
extern BOOL utDstr_isa_dquoted_string(char *string) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#ifdef HAVE_STRING_H
#include <string.h>
#endif /* HAVE_STRING_H */

#endif  /* INCLUDED_UTD_STRING_H */
