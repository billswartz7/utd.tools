/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	     string.c 
DESCRIPTION: Basic C string manipulation routines.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>
#include <utd/string.h>

#ifdef HAVE_CTYPE_H
#include <ctype.h>
#endif /* HAVE_CTYPE_H */

/* ********************** TYPE DEFINITIONS ************************* */
#define TOUPPER(c)  ( islower(c) ) ? toupper(c) : (c)
#define TOLOWER(c)  ( isupper(c) ) ? tolower(c) : (c)

 
/* -----------------------------------------------------------------
 * String Routines
 * ----------------------------------------------------------------- */
/* utDstrclone - clone a string - user must free memory when done */
char *utDstrclone(const char *str)
{
    if( str ){  /* first check for null pointer */
	if( *str ){  /* first check allow dereference */
	    return( (char *) strcpy( UTDMALLOC(strlen(str)+1, char), str ) ) ;
	}
    }
    return(NULL) ;

} /* end strclone */

char **utDstrparser2(char *str, char *dels,char **buf,INT *numtokens)
{
    INT  index = 0 ;
    static char *tokenBufL[LRECL] ; 	/* impossible to have more tokens */
					/* than the input */

    if(!(buf)){				/* use builtin if not supplied */
      buf = tokenBufL ;
    }

    /* use strtok to strip away delimiters */
    /* first call to strtok requires the string reference */
    buf[index] = utDstrtok(str,dels) ;
    while( buf[index] ){
	/* subsequent calls to strtok doesn't requires the string ref */
	/* strtok remembers place in string */
	buf[++index] = utDstrtok(NULL,dels) ;
    }
    /* return number of tokens and token buffer */
    *numtokens = index ;
    return(buf) ;
} /* end utDstrparser2() */


/* -----------------------------------------------------------------
 * Removes only the outside level of double quotes.  Destructive.
----------------------------------------------------------------- */
char *utDstr_remove_dquotes( char *string )
{
    INT len ;				/* len of string */

    if( string[0] == DQUOTE ){
      string++ ;
      len = strlen( string ) ;
      string[--len] = EOS ;
    }
    return( string ) ;
} /* end utDstr_remote_dquotes() */

/* -----------------------------------------------------------------
 * Removes only the outside level of single quotes.  Destructive.
----------------------------------------------------------------- */
char *utDstr_remove_squotes( char *string )
{
    INT len ;				/* len of string */

    if( string[0] == SQUOTE ){
      string++ ;
      len = strlen( string ) ;
      string[--len] = EOS ;
    }
    return( string ) ;
} /* end utDstr_remote_squotes() */

/* -----------------------------------------------------------------
 * Removes only the outside level of single character.  Destructive.
----------------------------------------------------------------- */
char *utDstr_remove_char( char *string, INT ch )
{
    INT len ;				/* len of string */

    if( string[0] == ch ){
      string++ ;
      len = strlen( string ) ;
      string[--len] = EOS ;
    }
    return( string ) ;
} /* end utDstr_remote_char() */

/* -----------------------------------------------------------------
 * Returns the last character in a string.
----------------------------------------------------------------- */
char utDstr_last_char( const char *string )
{
    INT len ;				/* len of string */

    len = strlen( string ) ;
    if( len > 0 ){
      return( string[len-1] ) ;
    }
    return ( EOS ) ;
} /* end utDstr_last_char() */

/* -----------------------------------------------------------------
 * Returns a point to the last character in a string.
----------------------------------------------------------------- */
char *utDstr_last_char_ptr( const char *string )
{
    INT len ;				/* len of string */

    len = strlen( string ) ;
    if( len > 0 ){
      return( (char *) string + len - 1 ) ;
    }
    return ( NULL ) ;
} /* end utDstr_last_char_ptr() */


/* SYS5 string command strtok - a string tokenizer */
char *utDstrtok(char *str, char *dels)
/* input string */
/* delimiters of string */
{

    static char *pL,        /* current place in string */
		*tokenL ;   /* substring */

    if( str ){	  	    /* check if new string */
	pL = str ;
    }
    /* remove leading delimiters */
    while( *pL && strchr(dels,*pL) ){
	++pL ;
    }

    /* test for EOS */
    if( *pL ){
	tokenL = pL++ ;    /* mark beginning of token */
	/* find end of token */
	while( *pL ){
	    if( strchr(dels,*pL) ){
		break ;
	    } else {
		++pL ;
	    }
	}
	/* mark end of string */
	if( *pL ){
	    *pL++ = EOS ;
	}
	return(tokenL) ;
    }
    /* no valid delimiters found */
    return(NULL) ;
}
/* end utDstrtok */

/* Yremove_lblanks - remove leading blanks from a string */
/* including tabs */
char *utDremove_lblanks(char *bufferptr)
{
    
    for( ;bufferptr && *bufferptr;bufferptr++){
	if( *bufferptr != ' ' && *bufferptr != '\t' ){
	    break ;
	}
    }
    return(bufferptr);
}
/* ---------------end string ------------------------------------- */
static CONST char WhiteSpace[] = " \t\n\r\v\f";

#define c_ARG_SEP '='
#if ( defined(UNIX)  ||  defined(ibm_style) )
# define  FORCE_KWDCASE(s)       utDstrlwr(s)
# define  TO_KWDCASE(c)          TOLOWER(c)
# define  KWDCASECOPY(dest,src)  utDstrlcpy(dest,src)
#else
# define  FORCE_KWDCASE(s)       utDstrupr(s)
# define  TO_KWDCASE(c)          TOUPPER(c)
# define  KWDCASECOPY(dest,src)  utDstrucpy(dest,src)
#endif


/***************************************************************************
** ^FUNCTION: utDstrucpy, utDstrlcpy - copy dest to src, mapping to upper/lower case
**
** ^SYNOPSIS:
**
**    char *utDstrucpy( dest, src )
**    char *utDstrlcpy( dest, src )
**
** ^PARAMETERS:
**    char *dest;
**    -- the address to start copying to
**
**    char *src;
**    -- the address to start copying from
**
** ^DESCRIPTION:
**    utDstrlcpy (utDstrucpy) copies src into dest (upto and including the
**    terminating NUL byte) and all uppercase (lowercase) characters in
**    src are mapped to lowercase (uppercase) before being copied into dest.
**
** ^REQUIREMENTS:
**    Dest must be non-null, and large enough to hold the copied result.
**
** ^SIDE-EFFECTS:
**    Dest is (re)written
**
** ^RETURN-VALUE:
**    Address of dest.
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
char *utDstrucpy(char *dest, char *src)
{
   char  *s1 = dest;
   CONST char  *s2 = src;

   if ( !s2 )  return(NULL);

   for ( ; *s2 ; s1++, s2++ ) {
      *s1 = TOUPPER( *s2 );
   }
   *s1 = '\0';

   return( dest ) ;
} /* utDstrucpy() */


char *utDstrlcpy(char *dest, char *src)
{
   register char  *s1 = dest;
   register CONST char  *s2 = src;

   if ( !s2 )  return(NULL) ;

   for ( ; *s2 ; s1++, s2++ ) {
      *s1 = TOLOWER( *s2 );
   }
   *s1 = '\0';

   return(dest) ;
} /* end utDstrlcpy() */


/***************************************************************************
** ^FUNCTION: utDstrupr, utDstrlwr - convert a string to all upper/lower case
**
** ^SYNOPSIS:
**    char *utDstrupr( str )
**    char *utDstrlwr( str )
**
** ^PARAMETERS:
**    char *str;
**    -- the string to be converted
**
** ^DESCRIPTION:
**    Strupr (utDstrlwr) converts all lowercase (uppercase) characters in <str>
**    to uppercase (lowercase) and returns the address of <str>.
**
** ^REQUIREMENTS:
**    str should be non-null and non-empty.
**
** ^SIDE-EFFECTS:
**    str is overwritten with the uppercase (lowercase) result.
**
** ^RETURN-VALUE:
**    Address of str.
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
char *utDstrupr(char *str)
{
   char *p = str;

   for ( ; p && *p ; p++ ) {
      if ( islower(*p) )  *p = toupper(*p);
   }

   return(str);
} /* end utDstrupr() */


char *utDstrlwr(char *str)
{
   char *p = str;

   for ( ; p && *p ; p++ ) {
      if ( isupper(*p) )  *p = tolower(*p);
   }

   return(str);
} /* end utDstrlwr() */


/***************************************************************************
** ^FUNCTION: utDstricmp, utDstrnicmp - case insensitive string comparison
**
** ^SYNOPSIS:
**    int utDstricmp( s1, s2 )
**    int utDstrnicmp( s1, s2, n )
**
** ^PARAMETERS:
**    char *s1;
**    -- first string to compare
**
**    char *s2;
**    -- second string to compare
**
**    size_t  n;
**    -- The number of characters to compare
**
** ^DESCRIPTION:
**    utDstricmp (utDstrnicmp) is identical to strcmp (utDstrncmp) except that it
**    it performs a case-insensitive comparison of characters.
**
** ^REQUIREMENTS:
**    Both s1 and s2 should be non-null and non-empty
**
** ^SIDE-EFFECTS:
**    None.
**
** ^RETURN-VALUE:
**    < 0    if s1 < s2
**    = 0    if s1 matches s2
**    > 0    if s1 > s2
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
INT utDstricmp(const char *str1, const char *str2)
{
   const char *s1 = str1, *s2 = str2;
   char  c1, c2;

   if ( s1 == s2 )  return   0;
   if ( !s1 )       return  -1;
   if ( !s2 )       return   1;

   for ( ; *s1 && *s2 ; s1++ , s2++ ) {
      c1 = TOLOWER( *s1 );
      c2 = TOLOWER( *s2 );

      if (c1 != c2)  return  (int)(c1 -c2);
   }
   return   (*s1 == *s2) ? 0 : (int)(*s1 - *s2);
} /* end utDstricmp() */


INT utDstrnicmp(const char *str1, const char *str2, INT len)
{
   const char *s1 = str1, *s2 = str2;
   char  c1, c2;

   if ( s1 == s2 )  return   0;
   if ( !s1 )       return  -1;
   if ( !s2 )       return   1;

   for ( ; *s1 && *s2 && len ; s1++ , s2++ , len-- ) {
      c1 = TOLOWER( *s1 );
      c2 = TOLOWER( *s2 );

      if (c1 != c2)  return  (int)(c1 -c2);
   }
   return   (!len  ||  (*s1 == *s2)) ? 0 : (int)(*s1 - *s2);
} /* end utDstrnicmp() */


/***************************************************************************
** ^FUNCTION: utDstrndup - copy a prefix of a string
**
** ^SYNOPSIS:
*/

/* ^DESCRIPTION:
**    Strndup allocates storrage and copies the the first "len" characters
**    of the given string into the newly acquired space (returning its
**    address). The returned result should be deallocated using free().
**
** ^REQUIREMENTS:
**    str should be non-null
**
** ^SIDE-EFFECTS:
**    None.
**
** ^RETURN-VALUE:
**    Address of the newly allocated string.
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
char *utDstrndup(char *str, INT len)
            /* the string to replicate */
        
{
  char *p ;

  p = UTDMALLOC( len + 1, char );
  strncpy(p, str, len);

  return p;
} /* end utDstrndup() */


/***************************************************************************
** ^FUNCTION: utDstrpbrk - return the first occurrence of characters in a string
**
** ^SYNOPSIS:
*/
/* ^DESCRIPTION:
**    Strpbrk will attempt to locate the first occurence in str1 of any 
**    character from str2 and return the address of the first such
**    occurrence. If str1 contains NO characters from str2, then NULL
**    is returned.
**
** ^REQUIREMENTS:
**    Both str1 and str2 should be non-null and non-empty
**
** ^SIDE-EFFECTS:
**    None.
**
** ^RETURN-VALUE:
**    A pointer to the first occurence in str1 of any char from str2.
**
** ^ALGORITHM:
**    - foreach char in str1
**       - if char is in str2, return the address of char
**      end-for
**    - if we have reached the end of str1, return NULL
*************************************************************************/
char *utDstrpbrk(char *str1, char *str2)
            /* the string to be searched */
            /* the set of characters to be located */
{
   register CONST char *s1 =  str1, *s2 = str2;

   if ( !s1 || !*s1 || !s2 || !*s2 )  return  NULL;

   for ( ; *s1 ; s1++ )  {
      if ( strchr(s2, *s1) )  return (char *)s1;
   }

   return(NULL);
} /* end utDstrpbrk() */


/***************************************************************************
** ^FUNCTION: utDstrspn, utDstrcspn - identify leading runs of characters
**
** ^SYNOPSIS:
**    char *utDstrspn( str1, str2 )
**    char *utDstrcspn( str1, str2 )
**
** ^PARAMETERS:
**    char *str1;
**    -- the string to be searched
**
**    char *str2;
**    -- the string to be searched
**
** ^DESCRIPTION:
**    Strspn (utDstrcspn) attempts to determine the length of the longest
**    leading prefix of str1 that consists entirely of character from
**    (not from) str2.
**
** ^REQUIREMENTS:
**    Both str1 and str2 should be non-null and non-empty.
**
** ^SIDE-EFFECTS:
**    None.
**
** ^RETURN-VALUE:
**    The length of the initial prefix in str1 consisting entirely
**    of characters from (not from) str2.
**
** ^ALGORITHM:
**    - length = 0
**    - for each char in str1
**       - if char is in str2 (for Ystrcspn) or not in str2 (for Ystrcspn)
**            then return length
**       - else
**            add 1 to length
**         end-if
**      end-for
**    - if end-of-string then return length
**
***^^**********************************************************************/
INT utDstrspn(char *str1, char *str2)
{
   register CONST char  *s1 = str1, *s2 = str2;
   INT len = 0;

   if ( !s1 || !*s1 || !s2 || !*s2 )  
      return(0) ;
   while ( *s1  &&  strchr(s2, *s1++) )  ++len;
   return(len);
} /* end utDstrspn() */


INT utDstrcspn(char *str1, char *str2)
{
   register CONST char  *s1 = str1, *s2 = str2;
   INT len = 0;

   if ( !s1 || !*s1 || !s2 || !*s2 )  
      return(0) ;
   while ( *s1  &&  !strchr(s2, *s1++) )  ++len;
   return(len) ;
} /* end utDstrcspn() */

/***************************************************************************
** ^FUNCTION: utDstrsub - find a substring in the string.
**
** ^SYNOPSIS:
**    char *utDstrsub( str, substring )
**
** ^PARAMETERS:
**    char *str;
**    -- the string to be analyzed
**
**    char *substring;
**    -- look for this set of characters.
**
** ^DESCRIPTION:
**
** ^REQUIREMENTS:
**    str should be non-null and non-empty.
**
** ^SIDE-EFFECTS:
**    None. 
**
** ^RETURN-VALUE:
**    Address of the substring.
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
char *utDstrsub(char *str, char *substring)
{
    INT len ;
    register CONST char  *s1 = str, *s2 = substring ;

    if ( !s1 || !*s1 || !s2 || !*s2 )  
      return(NULL) ;
    len = strlen( s2 ) ;
    while( s1 && *s1 ){
      s1 = strchr( s1, *s2 ) ;
      if(!(s1)){
	return(NULL) ;
      }
      /* look to see if we have a match */
      if( strncmp( s1, s2, len ) == STRINGEQ ){
	return( s1 ) ;
      }
      s1++ ;
    }
    return(NULL) ;
} /* end utDstrsub() */

/***************************************************************************
** ^FUNCTION: utDstrlsub - find the last substring in the string.
**
** ^SYNOPSIS:
**    char *utDstrlsub( str, substring )
**
** ^PARAMETERS:
**    char *str;
**    -- the string to be analyzed
**
**    char *substring;
**    -- look for this set of characters.
**
** ^DESCRIPTION:
**
** ^REQUIREMENTS:
**    str should be non-null and non-empty.
**
** ^SIDE-EFFECTS:
**    None. 
**
** ^RETURN-VALUE:
**    Address of the last substring.
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
char *utDstrlsub(char *str, char *substring)
{
    char *ptr ;				/* current substring found */
    char *last_sub_p ;			/* last substring found */

    ptr = str ;
    last_sub_p = NULL ;
    do {
      ptr = utDstrsub( ptr, substring ) ;
      if( ptr ){
	last_sub_p = ptr ;
	ptr++ ;
      }
    } while(ptr) ;

    return( last_sub_p ) ;

} /* end utDstrlsub() */

/***************************************************************************
** ^FUNCTION: utDstrisub - find a case insensitive substring in the string.
**
** ^SYNOPSIS:
**    char *utDstrisub( str, substring )
**
** ^PARAMETERS:
**    char *str;
**    -- the string to be analyzed
**
**    char *substring;
**    -- look for this set of characters.
**
** ^DESCRIPTION: we go to great pains to find the first occurance of the
**               case insensitive string.
**
** ^REQUIREMENTS:
**    str should be non-null and non-empty.
**
** ^SIDE-EFFECTS:
**    None. 
**
** ^RETURN-VALUE:
**    Address of the substring.
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
char *utDstrisub(char *str, char *substring)
{
    INT lc ;				/* lower case first character */
    INT uc ;				/* upper case first character */
    INT len ;				/* length of string */
    char *suc ;				/* match of upper case substring fc */
    char *slc ;				/* match of upper case substring fc */
    char *suc_match ;			/* match of upper case substring */
    char *slc_match ;			/* match of upper case substring */
    register CONST char  *s1 = str, *s2 = substring ;

    if ( !s1 || !*s1 || !s2 || !*s2 )  
      return(NULL) ;
    len = strlen( s2 ) ;
    lc = TOLOWER( *s2 ) ;
    uc = TOUPPER( *s2 ) ;
    while( s1 && *s1 ){
      suc = strchr( s1, uc ) ;
      slc = strchr( s1, lc ) ;
      if( !(suc) && !(slc) ){
	/* can't find either upper or lower case */
	return(NULL) ;
      }
      /* -----------------------------------------------------------------
       * At least character of the string matches case ins at the current spot.
       * See if the whole substring matches.
      ----------------------------------------------------------------- */
      slc_match = NULL ;
      suc_match = NULL ;
      if( suc ){
	if( utDstrnicmp( suc, s2, len ) == STRINGEQ ){
	  suc_match = suc ;
	}
      }
      if( slc ){
	if( utDstrnicmp( slc, s2, len ) == STRINGEQ ){
	  slc_match = slc ;
	}
      }
      if( slc_match || suc_match ){
	if( slc_match && suc_match ){
	  /* return the first occurance */
	  if( slc_match < suc_match ){
	    return(slc_match) ;
	  } else {
	    return(suc_match) ;
	  }
	} else if( slc_match ){
	  return(slc_match) ;
	} else {
	  return(suc_match) ;
	}
      } 
      /* -----------------------------------------------------------------
       * We didn't get a complete match. Go on look to see if we have another
       * match of first character. We must move to the first character after 
       * the first match.  Use the shorter string.
      ----------------------------------------------------------------- */
      if( suc && slc ){
	if( slc < suc ){
	  s1 = slc ;
	} else {
	  s1 = suc ;
	}
      } else if( slc ){
	s1 = slc ;
      } else {
	s1 = suc ;
      }
      s1++ ;
    }
    return(NULL) ;
} /* end utDstrisub() */


/***************************************************************************
** ^FUNCTION: utDstrltrim, utDstrrtrim, utDstrtrim - trim leading/trailing characters
**
** ^SYNOPSIS:
**    char *utDstrltrim( str, charset )
**    char *utDstrrtrim( str, charset )
**    char *utDstrtrim( str, charset )
**
** ^PARAMETERS:
**    char *str;
**    -- the string to be trimmed
**
**    char *charset;
**    -- the set of characters to be trimmed
**
** ^DESCRIPTION:
**    Strltrim removes from str, all leftmost (leading) characters occurring
**    in charset.
**
**    Strrtrim removes from str, all rightmost (trailing) characters occurring
**    in charset.
**
**    Strtrim removes from str, all leading and trailing characters occurring
**    in charset.
**
**    For each of these functions, if charset is NULL or empty, then the set
**    of whitespace characters (space, tab, newline, carriage-return, form-feed
**    and vertical-tab) is assumed.
**
** ^REQUIREMENTS:
**    str should be non-null and non-empty.
**
** ^SIDE-EFFECTS:
**    characters may be removed from the beginning and/or end of str.
**
** ^RETURN-VALUE:
**    Address of str.
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
char *utDstrltrim(char *str, char *charset)
{
   register   INT i;

   if ( !(str)  ||  !(*str) )   
      return(str);
      /* if delim-string is NULL, whitespace is used */
   if ( !charset )   charset = WhiteSpace;

   i = utDstrspn( str, charset );
   if ( i > 0 ){
#ifdef HAVE_MEMMOVE
     {
       INT len ;
       len = strlen( str+i ) ;
       memmove( str, str+i,len ) ;
       str[len] = EOS ;
     }
#else 
     strcpy( str, &(str[i]) );
#endif /* HAVE_MEMMOVE */ 
   }

   return(str);
} /* end utDstrltrim() */


char *utDstrrtrim(char *str, char *charset)
{
   register   INT   i;

   if ( !str  ||  !*str )   return(str) ;
   if ( !charset )   charset = WhiteSpace;
   for ( i = strlen(str) - 1 ;
            ( i >= 0 ) && (strchr( charset, str[i] )) ;
            i--
         ) ;

   str[i+1] = EOS ;
   return(str) ;
} /* end utDstrrtrim() */


char *utDstrtrim(char *str, char *charset)
{
   register   INT i ;

   if ( !(str)  ||  !(*str) )   
      return(str) ;
   if ( !charset )   charset = WhiteSpace;
   i = utDstrspn( str, charset );
   if ( i > 0 ){
#ifdef HAVE_MEMMOVE
     {
       INT len ;
       len = strlen( str+i ) ;
       memmove( str, str+i,len ) ;
       str[len] = EOS ;
     }
#else 
     strcpy( str, &(str[i]) );
#endif /* HAVE_MEMMOVE */ 
   }

   for ( i = strlen(str) - 1 ;
            ( i >= 0 ) && (strchr( charset, str[i] )) ;
            i--
         ) ;

   str[i+1] = EOS ;
   return(str) ;
} /* end utDstrtrim() */


/***************************************************************************
** ^FUNCTION: utDstrjoin - join a vector of tokens together
**
** ^SYNOPSIS:
*/

/* ^DESCRIPTION:
**    Strjoin will make a single string out of the given vector by copying
**    all the tokens from the given vector (in order) to a newly allocated
**    string. Tokens will be separated by a single occurence of <separator>.
**
**    If <separator> is NULL then a single space is used as the separator.
**    If <separator> is empty, then no separator is used and the tokens are
**    simply concatenated together.
**
** ^REQUIREMENTS:
**    argv must be non-NULL (it must be a valid address), and must be
**    terminated by a pointer to NULL (argv[last+1] == NULL).
**
** ^SIDE-EFFECTS:
**    Storage is allocated.
**
** ^RETURN-VALUE:
**    The address of the newly-joined result (which should be deallocated
**    using free()). Returns NULL if nothing was joined.
**
** ^ALGORITHM:
**    - count the number of characters to place in the joined-result.
**    - allocate a string large-enough to copy the joined-result into.
**    - copy each string into the string (with <separator> between tokens).
**    - 0 return the result.
***^^**********************************************************************/
char *utDstrjoin(char **argv, char *separator)
              /* pointer to the string vector to join together */
                  
/* the the string to use to separate tokens  (if NULL, " " is used) */
{
   size_t  sz = 0;
   register char *p;
   register CONST char *a, **av;
   register INT  seplen;
   char *result;

  /* if argv is NULL, nothing to do */
   if ( !argv )  return(NULL);
   if ( !separator )  separator = " ";
   seplen = strlen( separator );

      /* figure out how much space we need */
   for ( av = argv ; *av ; av++ ) {
      if ( !**av )  continue;
      sz += strlen( *av );
      if ( seplen  &&  *(av + 1) )  sz += seplen;
   }

      /* allocate space */
   result = UTDMALLOC( sz + 1, char );

      /* join the strings together */
   *result = EOS ;
   for ( av = argv, p = result ; (a = *av) ; av++ ) {
      if ( !*a )  continue;
      while ( (*p = *a++) ) ++p;  /* copy token */
      if ( seplen  &&  *(av + 1) ) {
         a = separator;
         while ( (*p = *a++) ) ++p;  /* copy separator */
      }/*end-if*/
   }/*end-for*/

   return(result) ;
} /* end utDstrjoin() */


/***************************************************************************
** ^FUNCTION: get_argpfx - get the prefix portion of a string
**
** ^SYNOPSIS:
*/
/* ^DESCRIPTION:
**    Get_argdesc returns the length of the first portion of the string.
**
**    Two "portions" must be either separated by whitespace or the second
**    portion may be within "(),{},[], or <>" delimiters. The second
**    portion is assumed to begin with the first alphabetic following
**    separator.
**
** ^REQUIREMENTS:
**    str should be non-null and non-empty
**
** ^SIDE-EFFECTS:
**    None.
**
** ^RETURN-VALUE:
**    The length of the first portion.
**
** ^ALGORITHM:
**    - locate the end of the first portion by scanning for whitespace or
**      balanced delimiters.
***^^**********************************************************************/
INT utDstr_get_argpfx(char *str)
           /* the string to parse for a description */
{
   register char  *description;
   static CONST char  whitespace[]  = " \t\n\r\f\v";
   static CONST char  beg_portion[] = "(<{[";

   description = utDstrpbrk( str, whitespace );
   if ( !description ) {
       description = utDstrpbrk( str, beg_portion );
   }

   return( description ? description - str : strlen(str) ) ;
} /* end Ystr_get_argpfx() */


/***************************************************************************
** ^FUNCTION: get_argdesc - get the description portion of a string
**
** ^SYNOPSIS:
*/
/* ^DESCRIPTION:
**    Get_argdesc returns a pointer to the second portion of the string
**    and also indicates how long it is.
**
**    Two "portions" must be either separated by whitespace or the second
**    portion may be within "(),{},[], or <>" delimiters. The second
**    portion is assumed to begin with the first alphabetic following
**    separator.
**
** ^REQUIREMENTS:
**    str should be non-null and non-empty
**
** ^SIDE-EFFECTS:
**    The length of the description is written to *len.
**
** ^RETURN-VALUE:
**    Address of the description (or NULL if the string has no description).
**
** ^ALGORITHM:
**    - locate the end of the first portion by scanning for whitespace or
**      balanced delimiters.
**    - locate the beginning of the second portion by scanning for the first
**      alpha-numeric following the end of the first portion.
**    - return the address of the description.
***^^**********************************************************************/
char *utDstr_get_argdesc(char *str, INT *len)
           /* the string to parse for a description */
          /* the pointer to the length */
{
   register char  *description = NULL;
   BOOL  is_end = FALSE, is_balanced = FALSE;
   char  *p;
   static CONST char  whitespace[]  = " \t\n\r\f\v";
   static CONST char  beg_portion[] = "(<{[";
   static CONST char  end_portion[] = ")>}]";

   description = utDstrpbrk( str, whitespace );
   if ( description ) {
      is_end = TRUE;
      while ( isspace(*++description) )  continue;  /* trim leading ' ' */
      if ( strchr(beg_portion, *description) ) {
            is_balanced = TRUE;
            ++description;
      }
   } else {
       description = utDstrpbrk( str, beg_portion );
       if ( description ) {  /* skip leading '(' */
          is_end = is_balanced = TRUE;
          ++description;
       }
   }

   if ( !(description) ) {
      *len = 0;
   } else {
      if ( is_balanced ) {  /* remove trailing ')' */
         p = description + (strlen( description ) - 1);
         if ( !strchr(end_portion, *p) )  ++p;
         *len = p - description;
      }
      else {
         while ( !isalnum(*description) )  ++description;
         *len = strlen( description );
      }
   }
   return(description) ;
} /* end utDstr_get_argdesc() */


/***************************************************************************
** ^FUNCTION: get_argname - return the aname (argument-name) of an argument
**
** ^SYNOPSIS:
*/
/* ^DESCRIPTION:
**    Get_argname will get the full argument name of the given argument
**    (not just the keyword name) and copy it to buf.
**
** ^REQUIREMENTS:
**    Both s and buf must be non-null and non-empty.
**    buf must be large enough to hold the result.
**
** ^SIDE-EFFECTS:
**    buf is overwritten.
**
** ^RETURN-VALUE:
**    Address of the buffer containing the name.
**
** ^ALGORITHM:
**    determine the name of an argument from its prompt
**    and copy the result in the given buffer
***^^**********************************************************************/
char  *utDstr_get_argname(char *s, char *buf)
           /* the ad_prompt field of an ARGDESC struct */
           /* address to which the aname should be copied */
{
   register CONST char *p2;
   INT len;

      /* see if sname and aname are separated by c_ARG_SEP
      ** <buf> must be large enough to hold the result!
      */
   len = utDstr_get_argpfx(s);
   p2 = strchr( s, c_ARG_SEP );
   if ( p2 && p2 < &s[len]) {
      ++p2;
      strncpy( buf, p2, len-(p2-s) );
      buf[len-(p2-s)] = 0;
      utDstrlwr(buf);
   } else {
      strncpy( buf, s, len );
      buf[len] = 0;
      utDstrlwr(buf);
   }
   return(buf);
} /* end utDstr_get_argname() */


/***************************************************************************
** ^FUNCTION: get_kwdname - get the sname (keyword name) of an argument
**
** ^SYNOPSIS:
*/
/* ^DESCRIPTION:
**    Get_kwdname will get the keyword name of the given argument
**    (not the entire argument name) and copy it to buf.
**
**    The sname (keyword-name) consists only of all uppercase characters
**    from the ad_prompt field (in the order they occur). If the ad_prompt
**    field contains NO uppercase characters, than the aname and the sname
**    are equivalent (the entire string).
**
** ^REQUIREMENTS:
**    Both s and buf must be non-null and non-empty.
**    buf must be large enough to hold the result.
**
** ^SIDE-EFFECTS:
**    buf is overwritten.
*
** ^RETURN-VALUE:
**    Address of the buffer containing the keyword.
**
** ^ALGORITHM:
**    determine the keyword of an argument from its prompt
**    and copy the result in the given buffer
***^^**********************************************************************/
char  *utDstr_get_kwdname(char *s, char *buf)
           /* the ad_prompt field of an ARGDESC struct */
           /* address to which the sname should be copied */
{
   register char *p1 = (char *)s, *p2;
   INT len;
   BOOL caps = FALSE;

   if ( !(p1) )  return  NULL;

   /* see if sname and aname are separated by c_ARG_SEP */
   len = utDstr_get_argpfx( p1 );
   p2 = strchr( p1, c_ARG_SEP );
   if ( p2 && p2 < &p1[len]) {
      strncpy( buf, p1, p2-p1);
      buf[p2-p1] = EOS ;
      FORCE_KWDCASE(buf);
      return(buf) ;
   }

   /* copy string into buffer and convert it to desired case */
   /* <buf> must be large enough to hold the result! */
   for ( p2 = buf; *p1 && len != 0; p1++, len-- ) {
      if ( isupper(*p1) ) {
         if ( !caps ) {
            caps = TRUE;
            p2 = buf;
         }
         *p2++ = TO_KWDCASE(*p1);
      }
      else if ( !caps ) {
         *p2++ = TO_KWDCASE(*p1);
      }
   }
   *p2 = EOS ;

   return(buf) ;   /* return buffer address */
} /* end utDstr_get_kwdname() */

/***************************************************************************
** ^FUNCTION: match - match a keyword against a prospective argument
**
** ^SYNOPSIS:
*/
/* ^DESCRIPTION:
**    Match will attempt to see if the candidate string matches the
**    target string (case insensitive). First a match is tried on the
**    sname of the keyword, then on the aname.  Candidate may be only
**    a partial leading portion of the target as long as it is at least
**    two characters long (unless the keyword is 1 character long).
**
**    No "partial" matching is accepted for AmigaDOS command-lines.
**
** ^REQUIREMENTS:
**    Both candidate and target should be non-null and non-empty.
**    target should be the ad_prompt field of an ARGDESC structure.
**
** ^SIDE-EFFECTS:
**    None.
**
** ^RETURN-VALUE:
*     < 0  if candidate < target
**    = 0  if candidate matches target
**    > 0  if candidate > target
**
** ^ALGORITHM:
**    - attempt a partial match against the sname and return 0 if we succeed
**    - attempt a partial match against the aname and return 0 if we succeed
**    - if both the above fail return non-zero (no match).
**    
***^^**********************************************************************/
INT utDstr_match(char *candidate, char *target)
                 /* the possible keyword argument */
                 /* the keyword to be matched */
{

/* rewritten 8/20/90 --BDA */
#define MINLEN  2     /* minimum # of characters to match */

   INT  i, clen, tlen, too_short=0;
   char arg_targ[LRECL], kwd_targ[LRECL] ;


   /* make kwd_targ the keyword portion of target */
   (void) utDstr_get_kwdname( target, kwd_targ );

      /* match at least MINLEN characters if possible */
   tlen = strlen( kwd_targ );
   clen = strlen( candidate );
   if ( (tlen >= MINLEN)   &&   (clen < MINLEN) ) {
      ++too_short;      /* not long enough -- no match */
   }

      /* first try to match prefix of the keyword portion */
   i = (too_short) ? -1 : utDstrnicmp(kwd_targ, candidate, clen);

      /* did we match? */
   if ( !i )  return(0) ;   /* yes! */

   /* no! : compare the argument portion
   **       match at least MINLEN characters if possible
   */
   /* make arg_targ the argument portion of target */
   (void) utDstr_get_argname( target, arg_targ );

   tlen = strlen(arg_targ);
   if ( (tlen >= MINLEN)   &&   (clen < MINLEN) ) {
      return(-1) ;      /* not long enough -- no match */
   }

   return(utDstrnicmp(arg_targ, candidate,clen) ) ;
} /* end utDstr_match() */

/***************************************************************************
** ^FUNCTION: basename - return the last component of a pathname
**
** ^SYNOPSIS:
**    char *basename( path )
**
** ^PARAMETERS:
**    path;
**    -- the pathname to be truncated.
**
** ^DESCRIPTION:
**    Basename takes a pathname and strips of all leading components
**    (except for the very last one) which refer to directories or
**    disk-drives.
**
** ^REQUIREMENTS:
**    path should be non-null, non-empty, and should correspond to a valid
**    pathname (absolute or relative).
**
** ^SIDE-EFFECTS:
**    None under Unix and AmigaDOS.
**
**    Under VMS, the file version is removed and any .COM or .EXE extension
**    is also removed.
**
**    Under MS-DOS, any .EXE, .COM, or .BAT extension is removed.
**
**    Under OS/2, any .EXE, .COM, or .CMD extension is removed.
**    
** ^RETURN-VALUE:
**    The address of the basename of the path.
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
#define PATH_SEP  '/'     /* default path-separator character */
char *utDstr_basename(char *path)
{
    char *base = strrchr( path, PATH_SEP );

    if ( !(base) ) {
	return(path) ;
    } else {
	return(base + 1);
    }
} /* end utDstr_basename() */

/***************************************************************************
** ^FUNCTION: dirname: - return the directory of the file name
**
** ^SYNOPSIS:
**    char *utDstr_dirname( path, char *buffer, INT buffer_len )
**
** ^PARAMETERS:
**    path;
**    -- the pathname to be truncated.
**
** ^DESCRIPTION:
**    Dirname takes a pathname and returns the directory associated with a
**    path.  If the path separator does not exist, it returns NULL.
**
** ^REQUIREMENTS:
**    path should be non-null, non-empty, and should correspond to a valid
**    pathname (absolute or relative).
**
** ^SIDE-EFFECTS:
**    None under Unix and AmigaDOS.
**
**    Under VMS, the file version is removed and any .COM or .EXE extension
**    is also removed.
**
**    Under MS-DOS, any .EXE, .COM, or .BAT extension is removed.
**
**    Under OS/2, any .EXE, .COM, or .CMD extension is removed.
**    
** ^RETURN-VALUE:
**    The address of the basename of the path.
**
** ^ALGORITHM:
**    Trivial.
***^^**********************************************************************/
#define PATH_SEP  '/'     /* default path-separator character */
char *utDstr_dirname(char *path, char *buffer, INT len)
{
    char *last_p ;		/* last path separator */
    char *base = strrchr( path, PATH_SEP );

    if ( !(base) ) {
      return(NULL) ;
    }
    strncpy( buffer, path, len - 1 ) ;
    buffer[len-1] = EOS ;
    last_p = strrchr( buffer, PATH_SEP ) ;
    if( last_p ){
      *last_p = EOS ;
    }
    return( buffer ) ;

} /* end utDstr_dirname() */


/***************************************************************************
** ^FUNCTION: indent_para - print a hanging indented paragraph
**
** ^SYNOPSIS:
*/
/* ^DESCRIPTION:
**    Indent_para will print on fp, a titled, indented paragraph as follows:
**
**    <----------------------- maxcols --------------------------->
**    <--- margin -->     <-- indent -->
**                   title              This is the first sentence
**                                      of the paragraph. Etc ...
**
** ^REQUIREMENTS:
**    maxcols and indent must be positive numbers with maxcols > indent
**
** ^SIDE-EFFECTS:
**    Output is printed to fp.
**
** ^RETURN-VALUE:
**    None.
**
** ^ALGORITHM:
**    Print the paragraph title and then print the text.
**    Lines are automatically adjusted so that each one starts in the
**    appropriate column.
***^^**********************************************************************/
void utDstr_indent_para(FILE *fp, INT maxcols, INT margin, char *title, INT indent, char *text, INT textlen)
             /* the stream to which output is sent */
             /* the maximum width (in characters) of the output */
             /* the number of spaces to use as the left margin */
             /* the paragraph title */
             /* the distance between the title and the paragraph body */
             /* the body of the paragraph */
             /* the length of the body of the paragraph */
{
   register INT idx = 0;
   BOOL first_line = TRUE;

   if ( ! textlen )  textlen = strlen( text );

   /* print the title */
   fprintf( fp, "%*s%-*s", margin, "", indent, title );

   idx = maxcols - margin - indent;

   if ( textlen <= idx )
      fprintf(fp, "%.*s\n", textlen, text);
   else
      do {
               /* backup to end of previous word */
         while (idx  &&  !isspace(text[idx]))  --idx;
         while (idx  &&  isspace(text[idx]))   --idx;
         idx++;

            /* print leading whitespace */
         if (!first_line)
            fprintf(fp, "%*s%-*s", margin, "", indent, "");

         fprintf(fp, "%.*s\n", idx, text);

         first_line = FALSE;
         text = &(text[idx+1]);
         textlen -= (idx+1);

         while (isspace(*text)) {  /* goto next word */
            ++text;
            --textlen;
         }

         idx = maxcols - margin - indent;

         if ( textlen <= idx )  /* print-last line */
            fprintf(fp, "%*s%-*s%.*s\n", margin, "", indent, "", textlen, text);
      } while ( textlen > idx );
} /* end Ystr_indent_para() */

/***************************************************************************
** ^FUNCTION: utDstr_isa_integer - returns TRUE if every digit of string is an
**                               integer.
**
** ^SYNOPSIS:
*/
/* ^DESCRIPTION:
**
** ^REQUIREMENTS:
**    input string must be terminated.
**
** ^SIDE-EFFECTS:
**    None
**
** ^RETURN-VALUE:
**    BOOL.
**
** ^ALGORITHM:
*     Trivial

***^^**********************************************************************/
BOOL utDstr_isa_integer(char *string)
{
    INT i ;				/* counter */
    INT len ;				/* length of string */

    if(!(string)){
      return(FALSE) ;
    }
    len = strlen( string ) ;
    if( len <= 0 ){
	return( FALSE ) ;
    }
    for( i = 0 ; i < len ; i++ ){
      if(!(isdigit(string[i]))){
	  return(FALSE) ;
      }
    }
    return(TRUE) ;

} /* end utDstr_isa_integer() */

/***************************************************************************
** ^FUNCTION: utDstr_isa_dquoted_string - returns TRUE if the string is a 
**                                      double quoted string.
** ^SYNOPSIS:
*/
/* ^DESCRIPTION:
**
** ^REQUIREMENTS:
**    input string must be terminated.
**
** ^SIDE-EFFECTS:
**    None
**
** ^RETURN-VALUE:
**    BOOL.
**
** ^ALGORITHM:
*     Trivial

***^^**********************************************************************/
BOOL utDstr_isa_dquoted_string(char *string)
{
    INT len ;				/* length of string */

    if(!(string)){
      return(FALSE) ;
    }
    len = strlen( string ) ;
    if( len <= 0 ){
	return( FALSE ) ;
    }
    if( (string[0] == DQUOTE) && (string[len-1] == DQUOTE) ){
      return(TRUE) ;
    } 
    return(FALSE) ;

} /* end utDstr_isa_dquoted_string() */

#if defined(SUN) 
#define NEED_STRERROR
#endif 
#ifdef NEED_STRERROR

char *strerror(int errnum)
{
    extern char *sys_errlist[] ;
    return(sys_errlist[errnum]) ;
} /* end strerror() */

#endif /* NEED_STRERROR */

#ifdef TEST

#define WS " \t\n\v\r\f\"'"

static char string2[] =  "	  oh what  	a beautiful -	morning!    	";

static char string[] =  "\n\
\t' ',  ARGREQ,          argStr,   Name,     'Name',\n\
\t'n',  ARGOPT|ARGLIST,  listStr,  Groups,   'newsGROUP (newsgroups test)',\n\
\t'c',  ARGOPT,          argInt,   RepCount, 'REPcount (number of reps)',\n\
\t'd',  ARGOPT,          argStr,   DirName,  'DIRname',\n\
\t'x',  ARGOPT,          argBool,  XFlag,    'Xflag (expand in X direction)',\n\
\t' ',  ARGOPT|ARGLIST,  listStr,  Argv,     'File',\n\
\tENDOFARGS\n\
";


int main(int argc,char *argv[])
{
    char *str ;
    char *sub ;
    char **vector;
    char last_ch ;
    unsigned i ;
    INT numtoks;

    fprintf( stderr, "test of utDstrtrim() and utDstrsplit():\n\n" );

    fprintf( stderr, "unparsed string='%s'\n", string2 );
    fprintf( stderr, "ltrimmed string='%s'\n", utDstrltrim( string2, WS ) );
    fprintf( stderr, "rtrimmed string='%s'\n", utDstrrtrim( string2, WS ) );

    vector = utDstrparser2( string, ",", NULL, &numtoks ) ;
    fprintf( stderr, "number of tokens=%d\n", numtoks );
    for ( i = 0 ; i < numtoks ; i++ ) {
      fprintf(stderr,"trimmed token[%d] = '%s'\n", i, utDstrtrim( vector[i], WS ) );
    }
    fprintf( stderr, "test of utDstrisub:\n\n" );
    str = "Is it in this string? " ;
    fprintf( stderr, "Is ALIAS in %c%s%c...", DQUOTE,str,DQUOTE ) ;
    sub = utDstrisub( str, "ALIAS" ) ;
    if( sub ){
      fprintf( stderr, "yes...%s...ERROR.\n", sub ) ;
    } else {
      fprintf( stderr, "no...ok.\n" ) ;
    }
    str = "Is &ALIA in this string? " ;
    fprintf( stderr, "Is ALIAS in %c%s%c...", DQUOTE,str,DQUOTE ) ;
    sub = utDstrisub( str, "ALIAS" ) ;
    if( sub ){
      fprintf( stderr, "yes...%s...ERROR.\n", sub ) ;
    } else {
      fprintf( stderr, "no...ok.\n" ) ;
    }

    str = "Is &ALIAS in this string? " ;
    fprintf( stderr, "Is ALIAS in %c%s%c...", DQUOTE,str,DQUOTE ) ;
    sub = utDstrisub( str, "ALIAS" ) ;
    if( sub ){
      fprintf( stderr, "yes...%s...ok.\n", sub ) ;
    } else {
      fprintf( stderr, "no...ERROR.\n" ) ;
    }

    str = "Is &alias in this string? " ;
    fprintf( stderr, "Is ALIAS in %c%s%c...", DQUOTE,str,DQUOTE ) ;
    sub = utDstrisub( str, "ALIAS" ) ;
    if( sub ){
      fprintf( stderr, "yes...%s...ok.\n", sub ) ;
    } else {
      fprintf( stderr, "no...ERROR.\n" ) ;
    }

    str = "Is &AlIaS in this string? " ;
    fprintf( stderr, "Is ALIAS in %c%s%c...", DQUOTE,str,DQUOTE ) ;
    sub = utDstrisub( str, "ALIAS" ) ;
    if( sub ){
      fprintf( stderr, "yes...%s...ok.\n", sub ) ;
    } else {
      fprintf( stderr, "no...ERROR.\n" ) ;
    }

    str = "Is &alIaS in this string? " ;
    fprintf( stderr, "Is ALIAS in %c%s%c...", DQUOTE,str,DQUOTE ) ;
    sub = utDstrisub( str, "ALIAS" ) ;
    if( sub ){
      fprintf( stderr, "yes...%s...ok.\n", sub ) ;
    } else {
      fprintf( stderr, "no...ERROR.\n" ) ;
    }

    str = "Is &alIaS Alias in this string? " ;
    fprintf( stderr, "Is ALIAS in %c%s%c...", DQUOTE,str,DQUOTE ) ;
    sub = utDstrisub( str, "ALIAS" ) ;
    if( sub ){
      fprintf( stderr, "yes...%s...ok.\n", sub ) ;
    } else {
      fprintf( stderr, "no...ERROR.\n" ) ;
    }

    str = "xfer" ;
    fprintf( stderr, "Is r=' in %c%s%c...", DQUOTE,str,DQUOTE ) ;
    sub = utDstrisub( str, "r='" ) ;
    if( sub ){
      fprintf( stderr, "yes...%s...ERROR.\n", sub ) ;
    } else {
      fprintf( stderr, "no...ok.\n" ) ;
    }

    fprintf( stderr, "\nTesting isa integer function\n" ) ;
    fprintf( stderr, "Non integer: bill_boy: isa_integer:%d\n",
                 utDstr_isa_integer( "bill_boy") ) ;
    fprintf( stderr, "Integer: 17: isa_integer:%d\n",
                 utDstr_isa_integer( "17") ) ;
    fprintf( stderr, "Null test: isa_integer:%d\n",
                 utDstr_isa_integer(NULL) ) ;
    fprintf( stderr, "Empty test: isa_integer:%d\n\n",
                 utDstr_isa_integer("") ) ;

    str = "This should be a ?" ;
    last_ch = utDstr_last_char( str ) ;
    fprintf( stderr, "string:%s last_char:%c\n", str, last_ch ) ;

    return(0) ;

} /* end main() */

#endif
