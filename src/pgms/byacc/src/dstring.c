/* ----------------------------------------------------------------- 
     Copyright (c) 2018 TWS.  All rights reserved.
FILE:	    dstring.c                                       
DESCRIPTION:Dynamic string processing routines
CONTENTS:   
DATE:	    Mon Jul 23 13:57:10 CDT 2018
REVISIONS:  
 * $Log: dstring.c,v $
 * Revision 1.1  2019/01/25 13:51:28  bills
 * Initial revision
 *
----------------------------------------------------------------- */
#include "defs.h"
#include "dstring.h"

/* ********************** TYPE DEFINITIONS ************************* */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */

/*
 *----------------------------------------------------------------------
 *
 * Ydstring_init --
 *
 *	Initializes a dynamic string, discarding any previous contents
 *	of the string (Ymessage_dstring_free should have been called already
 *	if the dynamic string was previously in use).
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	The dynamic string is initialized to be empty.
 *
 *----------------------------------------------------------------------
 */

void Ydstring_init(YDSTRINGPTR dsPtr)
{
    dsPtr->string = dsPtr->staticSpace ;
    dsPtr->length = 0 ;
    dsPtr->spaceAvl = YDSTRING_STATIC_SIZE ;
    dsPtr->staticSpace[0] = EOS;
} /* end Ydstring_init() */

/*
 *----------------------------------------------------------------------
 *
 * Ydstring_append --
 *
 *	Append more characters to the current value of a dynamic string.
 *
 * Results:
 *	The return value is a pointer to the dynamic string's new value.
 *
 * Side effects:
 *	Length bytes from string (or all of string if length is less
 *	than zero) are added to the current value of the string. Memory
 *	gets reallocated if needed to accomodate the string's new size.
 *  
 * Notes: char *string;    String to append.  If length is -1 then
 *                         this must be null-terminated.
 *        INT length;	   Number of characters from string to append.  
 *                         If < 0, then append all of string, up to null at end.
 *
 *----------------------------------------------------------------------
 */
char *Ydstring_append(YDSTRINGPTR dsPtr,char *string,INT length)
{
    INT newSize ;			/* needed size */
    char *newString ;			/* newly allocated string buffer */
    char *dst ;				/* destination */
    char *end ;				/* end of string */

    if( length < 0){
	length = strlen(string) ;
    }
    newSize = length + dsPtr->length ;

    /* -----------------------------------------------------------------
     * Allocate a larger buffer for the string if the current one isn't
     * large enough. Allocate extra space in the new buffer so that there
     * will be room to grow before we have to allocate again.
     ----------------------------------------------------------------- */
    if (newSize >= dsPtr->spaceAvl) {
	dsPtr->spaceAvl = 2 * newSize ;
	newString = MALLOC( dsPtr->spaceAvl * sizeof(char) ) ;
	memcpy((void *) newString, (void *) dsPtr->string, (size_t) dsPtr->length) ;
	if (dsPtr->string != dsPtr->staticSpace) {
	    FREE(dsPtr->string) ;
	}
	dsPtr->string = newString;
    }

    /* -----------------------------------------------------------------
     * Copy the new string into the buffer at the end of the old
     * one.
     ----------------------------------------------------------------- */
    for( dst = dsPtr->string + dsPtr->length, end = string+length;
	    string < end; string++, dst++) {
	*dst = *string ;
    }
    *dst = EOS ;
    dsPtr->length += length ;

    return(dsPtr->string) ;

} /* end Ydstring_append() */


char *Ydstring_printf( YDSTRINGPTR dsPtr,char *format, ... )
{
    va_list args ;
    INT format_len ;				/* length of format */
    INT length ;				/* new length */
    INT orig_length ;				/* original length of buffer */
    char *buffer ;				/* proper length of buffer */

    /* -----------------------------------------------------------------
     * First get the length of the buffer needed.
    ----------------------------------------------------------------- */
    va_start( args, format ) ;
    format_len = Ydstring_format_length(args,format) ;

    /* -----------------------------------------------------------------
     * Next allocate the proper buffer size.
    ----------------------------------------------------------------- */
    orig_length = dsPtr->length ;
    length = orig_length + format_len + 1 ;
    buffer = Ydstring_setlength( dsPtr, length) ;

    /* -----------------------------------------------------------------
     * Convert the format.
    ----------------------------------------------------------------- */
    va_start( args, format ) ;
    if( format ){
      vsprintf( buffer + orig_length, format, args ) ;
      dsPtr->length = strlen( buffer ) ;
    } else {
      buffer = NULL ;
    }
    va_end(args) ;
    return( buffer ) ;

} /* end Ydstring_printf() */

/*
 *----------------------------------------------------------------------
 *
 * Ydstring_setlength --
 *
 *	Change the length of a dynamic string.  This can cause the
 *	string to either grow or shrink, depending on the value of
 *	length.
 *
 * Results:
 *	Returns the current string buffer.
 *
 * Side effects:
 *	The length of dsPtr is changed to length and a null byte is
 *	stored at that position in the string.  If length is larger
 *	than the space allocated for dsPtr, then a panic occurs.
 *
 *----------------------------------------------------------------------
 */

char *Ydstring_setlength(YDSTRINGPTR dsPtr,INT length)
{
    char *newString ;

    if (length < 0) {
	length = 0 ;
    }
    if (length >= dsPtr->spaceAvl) {

	dsPtr->spaceAvl = length+1;
	newString = MALLOC( dsPtr->spaceAvl *sizeof(char) ) ;
	/* -----------------------------------------------------------------
	 * SPECIAL NOTE: must use memcpy, not strcpy, to copy the string
	 * to a larger buffer, since there may be embedded NULLs in the
	 * string in some cases.
	----------------------------------------------------------------- */
	memcpy((void *) newString, (void *) dsPtr->string, (size_t) dsPtr->length) ;
	if( dsPtr->string != dsPtr->staticSpace ) {
	    FREE(dsPtr->string) ;
	}
	dsPtr->string = newString ;
    }
    dsPtr->length = length ;
    dsPtr->string[length] = EOS ;

    return(dsPtr->string) ;

} /* end Ydstring_setlength() */

/*
 *----------------------------------------------------------------------
 *
 * Ydstring_free --
 *
 *	Frees up any memory allocated for the dynamic string and
 *	reinitializes the string to an empty state.
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	The previous contents of the dynamic string are lost, and
 *	the new value is an empty string.
 *
 *----------------------------------------------------------------------
 */

void Ydstring_free(YDSTRINGPTR dsPtr)
{
    if (dsPtr->string != dsPtr->staticSpace) {
	FREE(dsPtr->string) ;
    }
    dsPtr->string = dsPtr->staticSpace ;
    dsPtr->length = 0 ;
    dsPtr->spaceAvl = YDSTRING_STATIC_SIZE;
    dsPtr->staticSpace[0] = EOS ;

} /* end Ydstring_free() */

INT Ydstring_format_length( va_list args, char *fmt )
{
    INT i ;					/* integer */
    INT len ;					/* length of format */
    INT size_format ;				/* width of field */
    BOOL found_special ;			/* look for special characters */
    char *s ;					/* string */
    char c ;					/* character */

    /* -----------------------------------------------------------------
     * First find length of buffer.
    ----------------------------------------------------------------- */
    len = 0 ;
    while(fmt && *fmt){
      if( *fmt == '%' ){
	fmt++ ;
	if( *fmt == '%' ){
	  len++ ;
	} else {
	  /* -----------------------------------------------------------------
	   * We have a real formatting character, loop until we get a special
	   * character.
	  ----------------------------------------------------------------- */
	  if( *fmt == '.' || *fmt == '-' ){
	    fmt++ ; /* skip over these characters */
	  }
	  size_format = atoi(fmt) ;
	  if( size_format > 0 ){
	    len += size_format ;
	  }
	  found_special = FALSE ;
	  for( ; fmt && *fmt ; fmt++ ){
	    switch( *fmt ){
	      case 's':
		s = va_arg(args, char *) ;
		if( s ){
		  len += strlen(s) ;
		}
		found_special = TRUE ;
		break ;
	      case 'i':
	      case 'd':
	      case 'o':
	      case 'x':
	      case 'X':
	      case 'u':
		i = va_arg(args, INT) ;
		len += 10 ;
		found_special = TRUE ;
		break ;
	      case 'c':
		c = va_arg(args, int) ;
		len++ ;
		found_special = TRUE ;
		break ;
	      case 'f':
	      case 'e':
	      case 'F':
	      case 'g':
	      case 'G':
		c = va_arg(args, DOUBLE) ;
		len += 35 ;
		found_special = TRUE ;
		break ;
	      default:
		;
	    } /* end switch() */

	    if( found_special ){
	      break ;
	    }
	  }
	}
      } else {
	len++ ;
      }
      fmt++ ;
    } /* end while() */
    va_end(args) ;

    return(len) ;

} /* end Ydstring_format_length() */


#ifdef TEST
/* ##################################################################
                       TEST OF MESSAGE ROUTINES 
   ################################################################## */

int main(int argc, char *argv[] )
{
    char *routine ;			/* name of routine */
    YDSTRING mbuf ;			/* message buffer */
    char *my_msg ;			/* output message */
    char *msg =
"-ascii : reads the gds intermediate file instead of the gds2 stream file. \
Just how well does this line wrap work there, Bill.  I don't know but I am \
willing to find out there bud.  Lauren is a bad dog.  Isn't that true there \
doggie?" ;

    routine = "message_test" ;
    fprintf( stderr, "\ntest of dstring functions:\n" ) ;
    Ydstring_init( &mbuf ) ;

    my_msg = Ydstring_printf( &mbuf, "%d %s", 10, msg ) ;
    fprintf( stderr, "%s\n\n", my_msg ) ;
    my_msg = Ydstring_printf( &mbuf, "I can't believe it:%s", "Jack" ) ;
    fprintf( stderr, "%s\n\n", my_msg ) ;
    Ydstring_free( &mbuf ) ;

    exit(0) ;
}
#endif /* TEST */
