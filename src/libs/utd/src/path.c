/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	     path.c 
DESCRIPTION: File path manipulation routines.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <stdio.h>
#include <utd/base.h>
#include <utd/string.h>
#include <utd/file.h>
#include <utd/system.h>
#include <utd/path.h>

#undef  LRECL
#define LRECL	BUFSIZ

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static char *getpath( char *user ) ;

/* it is up to user to free memory */
const char *utDpath_abs(const char *given_path, BOOL fileNotDir) /* fix a path to get rid of .. */
                 
                 /* tells whether path is file or directory */
{

    INT  i ;                  /* token counter */
    INT  numtokens ;          /* number of tokens on line */
    char pathname[LRECL] ;    /* copy of given_path */
    char cur_dir[LRECL] ;     /* current working directory */
    char temp[LRECL] ;        /* temporary buffer */
    char *usrpath ;           /* the users environment path */
    char *rest ;              /* the rest of the string */
    char *user ;              /* the user */
    char **tokens ;           /* tokenizer */
    static char resultL[LRECL];/* the final result */

    /* get the current working directory */
    utDgetwd( cur_dir, LRECL ) ;
    /* make a copy for strtok is destructive */
    strcpy( pathname, given_path ) ;

    switch( pathname[0] ){
    case '~':
	/* look for ~/ construct */
	if( pathname[1] == '/' ){
	    /* use login as user */
	    user = NULL ;
	    /* skip over ~/ */
	    rest = pathname + 2 ;
	} else {
	    /* get user from string */
	    user = strtok( pathname," ~//,\n" ) ;
	    /* skip over ~ */
	    rest = strtok( NULL," ~\n" ) ;
	}
	/* call get path to get user path */
	strcpy( temp, getpath(user) );
	/* copy the rest of the string to result */
	strcat( temp, "/" ) ;
	strcat( temp, rest ) ;
	strcpy( resultL, temp ) ;
	break ;
    case '.':
	strcpy( resultL, utDpath_rel(cur_dir, pathname) ) ;
	break ;
    case SLASH:
	/* no work to be done */
	strcpy( resultL, pathname ) ;
	break ;
    default:
	/* find full name */
	sprintf( resultL, "%s%c%s", cur_dir, SLASH, pathname ) ;
	break ;
    } /* end switch */

    if( fileNotDir ){
	if( utDfileExists( resultL ) ){
	    /* we are done */
	    return(resultL);
	} /* otherwise continue below */
    } else { /* a directory */
	if( utDdirectoryExists( resultL ) ){
	    /* we are done */
	    return(resultL);
	} /* otherwise continue below */
    }
    /* now that that has failed try looking in user's path */
    /* take last part of file name to search */
    tokens = utDstrparser( pathname, " //,\t\n", &numtokens );

    /* temp is the name to search for in user path */
    strcpy( temp, tokens[numtokens-1] ) ;

    usrpath = utDgetenv( "PATH" ) ;
    /* make copy for destructive Ystrparser */
    strcpy( pathname, usrpath ) ; 

    tokens = utDstrparser( pathname, ":\t\n", &numtokens );
    for( i = 0; i < numtokens; i++ ){
	/* use directory to look for file */
	strcpy( cur_dir, tokens[i] ) ;
	strcat( cur_dir, "/" ) ;
	strcat( cur_dir, temp ) ;

	/* check to see if file exist with this pathname */
	if( utDfileExists( cur_dir ) ){
	    strcpy( resultL, cur_dir ) ;
	    return( resultL ) ;
	}
    }

    /* at this point we didn't find anything in user's path */
    /* return the last thing we tried above */
    return( resultL ) ;

} /* end utDpath_abs() */


static char *getpath(char *user)     /* get path of home directory */
           
{
    char *who, *homedir ;

    if( !(user) || *(user) == '/'){
	who = utDgetlogin();
    } else {
	who = user;
    }
    if( (homedir = utDgethomedir(who)) ){
	return(homedir);
    } else {
	return(user);
    }
}


char *utDpath_rel(char *known_path, char *rel_path)
                              /* known path and relative path to it */
{

    char known_fpath[LRECL] ; /* full path of known obj */
    char *ptr ;               /* used to replace obj with relative path */
    char *result ;            /* resulting path */
    INT  up ;              /* keeps count of backtracking up dir tree */

    /* make a copy of path */
    strcpy( known_fpath, known_path ) ;

    /* look for ./ constructs */
    up = 0 ;
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
       First look for ./  or directory local files.  That is if 
       known path is   :/twolf6/bills/tw/pgms/test 
       and rel_path    :./src
       result should be:/twolf6/bills/tw/pgms/test/src
    - - -- - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    if( strncmp( rel_path,"./", 2 ) == STRINGEQ ){
	/* back up the directory tree */
	/* update rel_path by skipping over ./ */
	rel_path += 2 ;
    }
    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
       Next look for ../ or higher directory files.  That is if 
       known path is   :/twolf6/bills/tw/pgms/test 
       and rel_path    :../src
       result should be:/twolf6/bills/tw/pgms/src
    - - -- - - - - - - - - - - - - - - - - - - - - - - - - - - - */
    /* now look for multiple ../../ skip over leading .  */
    while( strncmp( rel_path,"../", 3 ) == STRINGEQ ){
	up++ ; /* back up the directory tree */
	/* update rel_path by skipping over ../ */
	rel_path += 3 ;
    }
    /* now find matching slashes in known path */
    /* find last backslash */
    for(  ; up > 0 ; up-- ){ 
	if( (ptr = strrchr( known_fpath, '/' ))){
	    *ptr = EOS ;
	} else {
	    return( NULL ) ; /* problem */
	}
    }
    if( known_fpath[0] ){
	strcat( known_fpath, "/" ) ;
	result = (char *) utDstrclone( strcat( known_fpath, rel_path ) ) ;
	return( result ) ;
    }
    return( NULL ) ;

} /* end utDpath_rel() */


char *utDpath_fully_qualified( char *path, char *path_buf )
{
    char curwd[BUFSIZ] ;		/* current working directory */
    char fully_qualified[LRECL] ;	/* full pathname */
    char *new_path ;			/* newly created pathname given */

    if( path[0] != SLASH ){
      utDgetwd( curwd, BUFSIZ ) ;
      if( path_buf ){
	sprintf( path_buf, "%s/%s", curwd, path ) ;
	new_path = path_buf ;
      } else {
	sprintf( fully_qualified, "%s/%s", curwd, path ) ;
	UTDFREE( path ) ;
        new_path = utDstrclone( fully_qualified ) ;
      }
    } else {
      new_path = path ;
    }
    return( new_path ) ;
} /* end utDpath_fully_qualified() */


char *utDpath_adjust_file_name( char *fname, INT max_up ) 
{
    INT try ;				/* try counter */
    char cur_dir[LRECL] ;		/* current working directory */
    char rel_name[LRECL] ;		/* relative filename */
    char prefix[LRECL] ;		/* relative prefix */
    char *adjusted_fname ;		/* adjusted filename */

    if( *fname == '/' || *fname == '~' ){
      adjusted_fname = utDstrclone( fname ) ;
    } else {
      prefix[0] = EOS ;
      adjusted_fname = NULL ;
      for( try = 0 ; try <= max_up ; try++ ){
	sprintf( rel_name, "%s%s", prefix, fname ) ;
	adjusted_fname = utDpath_rel( utDgetwd( cur_dir, LRECL), rel_name ) ;
	if( adjusted_fname ){
	  if( utDfile_Z_exists( adjusted_fname ) ){
	    break ;
	  } else {
	    UTDFREE( adjusted_fname ) ;
	    adjusted_fname = NULL ;
	  }
	} else {
	  break ;
	}
	strcat( prefix, "../" ) ;
      }
    }
    return(adjusted_fname) ;
} /* end utDpath_adjust_filename() */

#ifdef TEST 

#include <utd/program.h>

/* include date.o object for link */
int main(INT argc, char **argv)
{
    if( argc == 2 ){
	fprintf( stderr, "given file:%s\n", argv[1] ) ;
	fprintf( stderr, "resolved pathname:%s\n", 
	    utDpath_abs(argv[1],TRUE) ) ;
    } else {
	fprintf( stderr, "Error[syntax]: a.out pathName\n" ) ;
	utDprogram_exit(PGMFAIL) ;
    }
    utDprogram_exit(PGMOK) ;
    return(0) ;
}
#endif /* TEST */
