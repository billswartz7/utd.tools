/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019-2022 William Swartz.  UTD.  All rights reserved.
FILE:	    log.c 
DESCRIPTION:Wrapper for memory mapping of files.
----------------------------------------------------------------- */
#include <utdconfig.h>

#include <utd/base.h>

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif /* HAVE_SYS_TYPES_H */

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif /* HAVE_SYS_STAT_H */

#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif /* HAVE_FCNTL_H */

#ifdef HAVE_SYS_MMAN_H
#include <sys/mman.h>
#endif /* HAVE_SYS_MMAN_H */

#include <utd/file.h>
#include <utd/dstring.h>
#include <utd/msg.h>
#include <utd/program.h>
#include <utd/path.h>
#include <utd/string.h>
#include <utd/mmap.h>

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif /* HAVE_UNISTD_H */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static const char *check_filename(char *filename) ;

UTDMAPFILEPTR utDmmap_open( char *filename, char *readwrite, INT abort_flags)
{
    INT fd ;				/* file descriptor */
    LONG fsize ;			/* file size */
    BOOL read_not_write ;		/* read if true */
    BOOL verbose ;			/* tell user what is going on */
    BOOL abort ;			/* abort operation */
    caddr_t map_file ;			/* map file data */
    UTDMAPFILEPTR mmap_p ;		/* map file record pointer */

    switch( readwrite[0] ){
      case 'a':
	fd = open( filename, O_CREAT | O_RDWR, 0666 ); /* oct */ 
	read_not_write = FALSE ;
	break ;
      case 'w':
	fd = open( filename, O_CREAT | O_TRUNC | O_WRONLY, 0666 ); /* oct */ 
	read_not_write = FALSE ;
	break ;
      case 'r':
      default:
	fd = open( filename, O_RDONLY, 0666 ); 
	read_not_write = TRUE ;
	break ;
    }

    if( abort_flags & FILE_VERBOSE ){
      verbose = TRUE ;
    } else {
      verbose = FALSE ;
    }
    if( abort_flags & FILE_ABORT ){
      abort = TRUE ;
    } else {
      abort = FALSE ;
    }

    if( fd < 0 ){
      if( abort || verbose ){
	utDmsgf(ERRMSG,MSG_AT,"utDmmap", "could not open file for mapping:%s.\n",
	  check_filename(filename) ) ;
	if( abort ){
	  utDprogram_exit(PGMFAIL) ;
	}
      }
      return(NULL) ;
    }

    fsize = utDfile_size(filename);
    if( fsize < 0 ){
      utDmsgf(ERRMSG,MSG_AT,"utDmmap", "Could not get file size for file:%s\n",
	check_filename(filename) ) ;
    }

    if( read_not_write ){
      /* -----------------------------------------------------------------
       * Why should we share a read-only copy - we are only going to read it.
       * Well, it is more efficient.  We don't need a private copy.
       * map_file = mmap(0, fsize, PROT_READ, MAP_PRIVATE, fd, 0) ;
      ----------------------------------------------------------------- */
      map_file = mmap(0, fsize, PROT_READ, MAP_SHARED, fd, 0) ; 
    } else {
      map_file = mmap(0, fsize, PROT_READ | PROT_WRITE, 
                      MAP_SHARED, fd, 0) ;
    }
    if( map_file == (caddr_t) -1 ){
      utDmsg_syserr( FALSE, "utDmmap", "Failed to map file:%s for %s\n",
	check_filename(filename), readwrite ) ;
      return(NULL) ;
    }
    mmap_p = UTDMALLOC( 1, UTDMAPFILE ) ;
    mmap_p->data = map_file ;
    mmap_p->size = fsize ;
    if( read_not_write ){
      close(fd) ; /* save resources - mapped region is still open */
      mmap_p->fileid = -1 ;
    } else {
      mmap_p->fileid = fd ;
    }
    return( mmap_p ) ;

    
} /* end utDmmap_open() */

void utDmmap_close( UTDMAPFILEPTR mmap_p ) 
{
    INT fd ;				/* file descriptor */

    if( mmap_p ){
      munmap( mmap_p->data, mmap_p->size ) ;
      fd = mmap_p->fileid ;
      if( fd >= 0 ){
	close(fd) ;
      }
      UTDFREE( mmap_p ) ;
    }

} /* end utDmmap_close() */

static const char *check_filename(char *filename)
{
    if( utDfileExists(filename) ){
      return(utDpath_abs(filename,TRUE)) ;
    }
    return(filename) ;
}

/* -----------------------------------------------------------------
 * Get the next line from a mapped file.
----------------------------------------------------------------- */
char *utDmmap_next_line( char *ptr, char *data, INT fsize, INT *line_len )
{
    char *cptr ;			/* current character pointer */
    char *eol_ptr ;			/* end of line pointer */
    char *nptr ;			/* start of new line */
    char *last_ptr ;			/* last valid pointer */

    /* -----------------------------------------------------------------
      Was eol_ptr = strchr( ptr, '\n' ) ;
      But strchr must see and EOS and it might not occur and strchr will
      cause an access violation.
    ----------------------------------------------------------------- */
    eol_ptr = NULL ;
    for( cptr = ptr, last_ptr = data + fsize; cptr < last_ptr ; cptr++ ){
      if( *cptr == '\n' ){
	eol_ptr = cptr ;
	break ;
      }
    }

    if( eol_ptr ){
      *line_len = eol_ptr - ptr ;
      eol_ptr++ ;
      if( eol_ptr - data < fsize ){
	nptr = eol_ptr ;
      } else {
	nptr = NULL ;
      }
    } else {
      nptr = NULL ;
      *line_len = 0 ;
    }
    return(nptr) ;

} /* end utDmmap_next_line() */

/* -----------------------------------------------------------------
 * Initialize the map gets structure.
----------------------------------------------------------------- */
UTDMAPGETSPTR utDmmap_gets_init( UTDMAPFILEPTR mmap_p ) 
{
    UTDMAPGETSPTR mgets_p ;		/* gets structure */ 

    if( mmap_p ){
      mgets_p = UTDMALLOC( 1, UTDMAPGETS ) ;
      mgets_p->ptr = utDmmap_data( mmap_p ) ;
      mgets_p->mapfile = mmap_p ;
      utDdstring_init(&(mgets_p->line_buf)) ;
      return( mgets_p ) ;
    }
    return(NULL) ;
} /* end utDmmap_gets_init() */

void utDmmap_gets_free( UTDMAPGETSPTR mgets_p ) 
{

    utDdstring_free(&(mgets_p->line_buf)) ;
    UTDFREE( mgets_p ) ;

} /* end utDmmap_gets_free() */

char *utDmmap_gets( UTDMAPGETSPTR mgets_p ) 

{
    INT fsize ;					/* file size */
    INT line_len ;				/* line length */
    char *ptr ;					/* beginning of line */
    char *text ;				/* return text line */
    char *data ;				/* data of mapped file */

    text = NULL ;
    if( mgets_p && mgets_p->ptr ){
      data = utDmmap_data(mgets_p->mapfile) ;
      fsize = utDmmap_size(mgets_p->mapfile) ;
      ptr = mgets_p->ptr ;
      mgets_p->ptr = utDmmap_next_line( ptr, data, fsize, &line_len ) ;
      if( line_len > 0 || mgets_p->ptr ){
	utDdstring_reinit(&(mgets_p->line_buf)) ;
	text = utDdstring_append(&(mgets_p->line_buf),ptr,line_len) ;
      }
    }
    return(text) ;

} /* end utDlex_get_next_map_line() */


#ifdef TEST

#include <stdio.h>

int main(void)
{
    INT i ;				/* counter */
    LONG fsize ;			/* file size */
    char *data ;			/* data of file */
    char *bufferptr ;			/* pointer to start of line */
    UTDMAPFILEPTR mmap_p ;		/* map file record pointer */
    UTDMAPGETSPTR mgets_p ;		/* mapped gets functionality */

    /* Print myself */
    mmap_p = utDmmap_open( "mmap.c", "r", FILE_ABORT ) ;
    fsize = utDmmap_size( mmap_p ) ;
    data = utDmmap_data( mmap_p ) ;
    fprintf( stderr, "Printing by characters...\n" ) ;
    fprintf( stderr, "##########################\n" ) ;
    for( i = 0 ; i < fsize ; i++ ){
      fputc(data[i], stderr ) ;
    }
    utDmmap_close( mmap_p ) ;

    /* Print myself */
    fprintf( stderr, "Print only a portion by characters...\n" ) ;
    fprintf( stderr, "##########################\n" ) ;
    mmap_p = utDmmap_open( "mmap.c", "r", FILE_ABORT ) ;
    fsize = utDmmap_size( mmap_p ) ;
    data = utDmmap_data( mmap_p ) ;
    for( i = 0 ; i < fsize && i < 80; i++ ){
      fputc(data[i], stderr ) ;
    }
    utDmmap_close( mmap_p ) ;

    /* -----------------------------------------------------------------
     * Now read outself using mapped gets mechanism.
    ----------------------------------------------------------------- */
    fprintf( stderr, "Now read using mapped gets...\n" ) ;
    fprintf( stderr, "##########################\n" ) ;
    mmap_p = utDmmap_open( "mmap.c", "r", FILE_ABORT ) ;
    mgets_p = utDmmap_gets_init( mmap_p ) ;
    while( (bufferptr = utDmmap_gets( mgets_p ) ) ){
      fprintf( stderr, "%s\n", bufferptr ) ;
    }
    utDmmap_gets_free( mgets_p ) ;
    utDmmap_close( mmap_p ) ;
    fprintf( stderr, "Tests concluded.\n" ) ;
     
} /* end main() */

#endif /* TEST */
