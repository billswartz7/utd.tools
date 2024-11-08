/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    file.c                                       
DESCRIPTION:File manipulation routines.
REVISIONS: 
----------------------------------------------------------------- */
/* The order is important */
#include <utdconfig.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <utd/base.h>
#include <fcntl.h>

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif /* HAVE_ERRNO_H */

#ifdef HAVE_UNISTD_H 
#include <unistd.h>
#endif /* HAVE_UNISTD_H */

#include <dirent.h>
#include <utd/file.h>
#include <utd/dstring.h>
#include <utd/msg.h>
#include <utd/system.h>
#include <utd/path.h>
#include <utd/exec.h>
#include <utd/program.h>
#include <utd/string.h>

#ifdef HAVE_SYS_RESOURCE_H
#include <sys/resource.h>
#endif /* HAVE_SYS_RESOURCE_H */

#ifdef HAVE_VFORK_H
#include <vfork.h>
#endif /* HAVE_VFORK */


#define STD_ERROR  0
#define STD_INPUT  0
#define STD_OUTPUT 1

static const char *compress_suffixS[5] = {
  ".gz", ".bz2", ".Z", ".xz", NULL
} ;

#ifndef TEST

/* ********************** TYPE DEFINITIONS ************************* */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static const char *check_filename(const char *filename) ;

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static UTD_FILE_COMPRESS_TYPE compress_typeS ;	/* compress option default gzip */

/* -----------------------------------------------------------------
 *                    File routines
----------------------------------------------------------------- */
static FILE *Zotopen(const char *filename, const char *readwrite, FILE_T abort)
{
  static FILE *fpL ;		/* static to work properly across fork */
  int fd[2];
  INT ret_code, code, status;
  INT fdtmp;
  FUNC_NAME("Zotopen") ;

  switch( readwrite[0] ) {
  case 'r':  break;
  case 'w':  break;
  default: 
    utDmsgf(ERRMSG, "utd/Ztotopen:1", routine, "%s not implemented\n", readwrite );
    return( NULL);
    break;
  }

  if( pipe(fd) ) {
    utDmsg_syserr(abort, routine, "pipe failure" ) ;
    return( NULL);
  }

  if( (ret_code = fork() ) ) {
    /* parent */
    if( ret_code <= -1 ) {
      utDmsg_syserr( abort, routine, "fork fail" ) ;
      return(NULL);
    }

    switch( readwrite[0] ) {
    case 'r':  
      /* no more for write from the pipe */
      close( fd[1] ) ;
      fpL = (FILE *) fdopen( fd[0], "r") ;
      if( ! fpL ) {
	utDmsg_syserr( abort, routine, "fdopen r fail");
      }
      break ;
    case 'w':  
      /* no more for read from the pipe */
      close( fd[0] ) ;
      fpL = (FILE *) fdopen( fd[1], "w") ;
      if( ! fpL ) {
	utDmsg( ERRMSG, "utd/Zotopen:2", routine, "fdopen w fail\n");
	if( abort ) {
	  utDprogram_exit( PGMFAIL);
	}
      }
      break ;
    }
    utDwaitpid(ret_code, &status, 0);
    return(fpL);
  } else {

    /* child */
    switch( readwrite[0] ) {
    case 'r':  
      close( fd[0] ) ;
      close( STD_OUTPUT );
      ret_code = dup( fd[1] );
      if( ret_code == -1 ) {
	utDmsg_syserr( abort, routine, "dup failure" ) ;
	_exit(-1);
      }
      close( fd[1] );

      close(STD_INPUT);
      fdtmp = open( filename, O_RDONLY, STD_INPUT ); 
      if( fdtmp != STD_INPUT ) {
	utDmsgf( ERRMSG, "utd/Zotopen:3", routine, 
	    "could not open:%s for reading. Check permissions.\n", check_filename(filename) ) ;
	/* important, dont call exit(), will destroy parent file */
	_exit(-2);
      }

      /* use some tricks here to avoid a zombie process */
      if( (code = fork()) ) {	/* first child */
	if( code < 0 ) {
	  utDmsg_syserr( abort, "Zotopen", "2nd fork fail" ) ;
	  return(NULL);
	}
	_exit(0);
      } else {			/* second child */
	switch( compress_typeS ){
	  case FILE_COMPRESS_XZ_T:
	    execlp( "xz", "xz", "-d", "-c", NULL ) ;
	    break ;
	  case FILE_COMPRESS_UNIX_T:
	    execlp( "zcat", "zcat", NULL ) ;
	    break ;
	  case FILE_COMPRESS_BZIP2_T:
	    execlp( "bzip2", "bzip2", "-d", "-c", NULL ) ;
	    break ;
	  case FILE_COMPRESS_GZIP_T:
	  default:
	    execlp( "gzip", "gzip", "-d", "-c", NULL ) ;
	}
      }

      utDmsgf(ERRMSG, "utd/Zotopen:4", routine,  
	  "can not execlp decompression tool, pid=%d, errno=%d, %s", 
	      utDgetpid(), errno, strerror(errno) );
      _exit(-3);
      break;
    case 'w':  
      close( fd[1] ) ;
      close( STD_INPUT );
      ret_code = dup( fd[0] );
      if( ret_code <= -1 ) {
	utDmsg_syserr( abort, routine, "dup failure" ) ;
	_exit(-4);
      }
      close( fd[0] );

      close( STD_OUTPUT );
      fdtmp= open( filename, O_CREAT | O_TRUNC | O_WRONLY, 0666 ); /* oct */ 
      if( fdtmp != STD_OUTPUT ) {
	utDmsgf( ERRMSG, "utd/Zotopen:5", routine, 
	  "could not open:%s for writing. Check permissions.\n", 
	  check_filename(filename) ) ;
	/* important, dont call exit(), will destroy parent file */
	_exit(-5);
      }

      /* use some tricks here to avoid a zombie process */
      if( (code = fork()) ) {	/* first child */
	if( code < 0 ) {
	  utDmsg_syserr( abort, routine, "2nd fork fail" ) ;
	  return(NULL);
	}
	_exit(0);
      } else {			/* second child */
	switch( compress_typeS ){
	  case FILE_COMPRESS_XZ_T:
	    execlp( "xz", "xz", "-9", "-c", NULL ) ;
	    break ;
	  case FILE_COMPRESS_UNIX_T:
	    execlp( "compress", "compress", NULL ) ;
	    break ;
	  case FILE_COMPRESS_BZIP2_T:
	    execlp( "bzip2", "bzip2", "-9", "-c", NULL ) ;
	    break ;
	  case FILE_COMPRESS_GZIP_T:
	  default:
	    execlp( "gzip", "gzip", "-9", "-c", NULL ) ;
	}
      }

      utDmsgf(ERRMSG, "utd/Zotopen:6", routine, 
	  "can not execlp, pid=%d, errno=%d, %s",
	      utDgetpid(), errno, strerror(errno) );
      _exit(-6);
      break;
    }
  }
  /* never come here */
  utDmsgf(ERRMSG, "utd/Zotopen:7", routine, "error, can't (v)fork or exec, pid = %d", utDgetpid() );
  return( NULL);

} /* end Zotopen() */


UTD_FILE_COMPRESS_TYPE utDfile_compress_type( UTD_FILE_COMPRESS_TYPE type )
{
    if( type != FILE_COMPRESS_CURRENT_T ){
      compress_typeS = type ;
    }
    return( compress_typeS ) ;
}

FILE *utDfile_open(const char *filename, const char *readwrite, INT abort_flags)
{

    FILE *fileptr ;
    char zfilename[LRECL] ;
    char buffer[LRECL] ;
    BOOL abort ;
    BOOL verbose ;
    BOOL found_alt ;
    UTD_FILE_COMPRESS_TYPE types ;
    UTD_FILE_COMPRESS_TYPE tried_type ;
    FUNC_NAME("utDfile_open") ;

    /* determine the flags */
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

    if( readwrite[0] == 'Z' ){
	readwrite++ ; /* skip to next character */
	if( !(readwrite) || !(*readwrite) ){
	    utDmsg(ERRMSG,"utd/utDfile_open:1", routine, "bogus readwrite string.\n" ) ;
	    utDprogram_exit(PGMFAIL) ;
	}

	switch( compress_typeS ){
	  case FILE_COMPRESS_XZ_T:
	    sprintf( zfilename, "%s.xz", filename ) ;
	    break ;
	  case FILE_COMPRESS_UNIX_T:
	    sprintf( zfilename, "%s.Z", filename ) ;
	    break ;
	  case FILE_COMPRESS_BZIP2_T:
	    sprintf( zfilename, "%s.bz2", filename ) ;
	    break ;
	  case FILE_COMPRESS_GZIP_T:
	  default:
	    sprintf( zfilename, "%s.gz", filename ) ;
	}
	tried_type = compress_typeS ;
	switch( *readwrite ){
	case 'r':
	    /* -----------------------------------------------------------------
	    * If default compress file type doesn't exist, try the alternate
	    * compress file type.  If that fails, try to read original filename
	    * by calling Yfile open recursively.
	    ----------------------------------------------------------------- */
	    if(!(utDfileExists(zfilename))){
	      found_alt = FALSE ;
	      for( types = 0 ; types <= UTD_MAX_COMPRESS_TYPE_T ; types++ ){
		if( types != tried_type ){
		  sprintf( zfilename, "%s.%s", filename, compress_suffixS[types] ) ;
		  if( utDfileExists(zfilename) ){
		    found_alt = TRUE ;
		    break ;
		  }
		}
	      }
	      if(!(found_alt) && !(utDfileExists(zfilename))){
		return( utDfile_open(filename, readwrite, abort_flags) ) ;
	      }
	    }
	    break ;
	case 'w':
	    break ;
	case 'a':
	case 'A':
	case 'R':
	default:
	    utDmsgf(ERRMSG,"utd/utDfile_open:2",routine, "unsupported readwrite option:%c\n", 
	      *readwrite ) ;
	    if( abort ){
		utDprogram_exit(PGMFAIL) ;
	    }
	    return( NULL ) ;
	} /* end switch( *readwrite... */

	fileptr = Zotopen( zfilename, readwrite, abort);

	if( !(fileptr) ){
	  if( abort || verbose ){
	    sprintf( buffer,"could not open pipe for file %s.\n",
	    check_filename(filename) ) ;
	    utDmsg(ERRMSG,"utd/utDfile_open:3", routine, buffer ) ;
	    if( abort ){
	      utDprogram_exit(PGMFAIL) ;
	    }
	  } else {
	    return( utDfile_open(filename, readwrite, abort) ) ;
	  }
	}
     } else {
      if( readwrite[0] == 'Z' ) readwrite++ ; /* skip over Z when no compress */

      fileptr = fopen( filename, readwrite );

      if( !(fileptr) ){
	if( abort || verbose ){
	  utDmsg_syserr(FALSE,"utDfile_open",
	    "could not open file %s for %s.\n",
	  check_filename(filename), (readwrite[0]=='r'?"reading":"writing") ) ;
	}
	if( abort ){
	  utDprogram_exit(PGMFAIL) ;
	}
      }
    }
    return( fileptr ) ;

} /* end utDfile_open() */


void utDfile_echo(FILE *fin, FILE *fout)
{
    char buffer[LRECL] ;
    char *bufferptr ;

    /* just echo the file */
    while( (bufferptr = fgets( buffer, LRECL, fin) ) ){
	fprintf( fout, "%s", bufferptr ) ;
    }

} /* end utDfile_echo() */

/* check if a file exists */
BOOL utDfileExists(const char *pathname)
{
    struct stat buf;

    if( pathname ){
	if( stat(pathname, &buf) == 0 ){
	    return(TRUE) ;
	}
    }
    return(FALSE) ;
} /* end utDfileExists() */

BOOL utDlinkExists(const char *pathname)
{
    struct stat buf;

    if( pathname ){
	if( lstat(pathname, &buf) == 0 ){
	    return(TRUE) ;
	}
    }
    return(FALSE) ;
} /* end YlinkExists() */

static const char *check_filename(const char *filename)
{
    if( utDfileExists(filename) ){
      return(utDpath_abs(filename,TRUE)) ;
    }
    return(filename) ;
}

/* check if a file or its compressed version exists */
BOOL utDfile_Z_exists(const char *pathname)
{
    struct stat buf;
    char *cname ;
    UTD_FILE_COMPRESS_TYPE types ;

    if( pathname ){
      if( stat(pathname, &buf) == 0 ){
	  return(TRUE) ;
      } else {
	UTDDSTRING buffer ;
	utDdstring_init(&buffer) ;
	for( types = 0 ; types <= UTD_MAX_COMPRESS_TYPE_T ; types++ ){
	  utDdstring_reinit(&buffer) ;
	  cname = utDdstring_printf( &buffer, "%s.%s", pathname, compress_suffixS[types] ) ;
	  if( stat( cname, &buf) == 0 ){
	      return(TRUE) ;
	  }
	}
      }
    }
    return(FALSE) ;
} /* end utDfile_Z_exists() */

/* check if a directory exists */
BOOL utDdirectoryExists(const char *pathname)
{
    DIR *dp ;

    if( pathname ){
	if( (dp = (DIR *) opendir(pathname) ) ){
	    closedir(dp) ;
	    return(TRUE) ;
	}
    }
    return(FALSE) ;
}

/* -----------------------------------------------------------------
 * Returns NULL if file does not exist.  Returns the old path and moves file
 * to first available number if file exists.  If we are not given an
 * old buffer path and we do backup the file, we just return the pathname
 * as an indication that we made a backup.
----------------------------------------------------------------- */
char *utDfile_backup(char *pathname, char *old_path, INT len )
{
    INT i ;				/* file counter */
    char name[LRECL] ;			/* file name buffer */
    char *filename ;			/* filename to delete/move */
    char *cname ;			/* compress name */
    char *backup_char ;			/* backup character */
    struct stat buf ;			/* buffer for file info */
    UTD_FILE_COMPRESS_TYPE types ;	/* compression types */

    if(!(pathname)){
      return(NULL) ;
    }
    filename = NULL ;
    if( stat(pathname, &buf) == 0 ){
      filename = pathname ;
    } else {
      UTDDSTRING buffer ;
      utDdstring_init(&buffer) ;
      for( types = 0 ; types <= UTD_MAX_COMPRESS_TYPE_T ; types++ ){
	utDdstring_reinit(&buffer) ;
	cname = utDdstring_printf( &buffer, "%s.%s", pathname, compress_suffixS[types] ) ;
	if( stat( cname, &buf) == 0 ){
	  filename = cname ;
	  break ;
	}
      }
    }
    if(!(filename)){
      return(NULL) ;
    }
    /* -----------------------------------------------------------------
     * Find the backup character.
     * ----------------------------------------------------------------- */
    backup_char = utDgetenv("UTDTOOLS_VERSION_CHAR") ;
    if(!(backup_char)){
      backup_char = ":" ;
    }
    /* find the first missing number */
    for( i = 1;  ; i++ ){
      sprintf( name, "%s%s%d", filename, backup_char, i ) ;
      if(!(utDfileExists(name))){
	utDmoveFile( filename, name ) ;
	if( old_path ){
	  strncpy( old_path, name, len ) ;
	  return( old_path ) ;
	}
	return( pathname ) ;
      }
    }
    return(NULL) ;
} /* end utDfile_backup() */

/* -----------------------------------------------------------------
 * Returns NULL if directory does not exist.  Returns the old path and 
 * moves the directory to first available number if the directory exists.
 * If we are not given an old buffer path and we do backup the file, 
 * we just return the pathname as an indication that we made a backup.
----------------------------------------------------------------- */
char *utDdirectory_backup(char *pathname, char *old_path, INT len )
{
    INT i ;				/* file counter */
    char name[LRECL] ;			/* file name buffer */
    char buffer[LRECL] ;		/* file buffer */
    char *dirname ;			/* filename to delete/move */
    char *backup_char ;			/* backup character */
    struct stat buf ;			/* buffer for file info */

    if(!(pathname)){
      return(NULL) ;
    }
    if( utDdirectoryExists(pathname) ){
      dirname = pathname ;
    } else {
      return(NULL) ;
    }
    /* -----------------------------------------------------------------
     * Find the backup character.
     * ----------------------------------------------------------------- */
    backup_char = utDgetenv("UTDTOOLS_VERSION_CHAR") ;
    if(!(backup_char)){
      backup_char = ":" ;
    }
    /* find the first missing number */
    for( i = 1;  ; i++ ){
      sprintf( name, "%s%s%d", dirname, backup_char, i ) ;
      if(!(utDdirectoryExists(name))){
	utDmoveFile( dirname, name ) ;
	if( old_path ){
	  strncpy( old_path, name, len ) ;
	  return( old_path ) ;
	}
	return( pathname ) ;
      }
    }
    return(NULL) ;
} /* end utDdirectory_backup() */

BOOL utDfile_is_slink(const char *pathname)
{
    struct stat buf;

    if( pathname ){
	if( stat(pathname, &buf) == 0 ){
	  if( S_ISLNK(buf.st_mode) ){
	    return(TRUE) ;
	  }
	}
    }
    return(FALSE) ;

} /* end utDfile_is_slink() */

char *utDfile_slink(const char *pathname)
{
    INT len ;
    static char buf[BUFSIZ] ;

    len = readlink( pathname, buf, BUFSIZ ) ;
    if( len <= 0 ){
	utDmsg_syserr( FALSE, "utDfile_slink", "readlink failure:%s", pathname ) ;
	return(NULL) ;
    } else {
	/* null terminate string */
	buf[len] = EOS ;
	return( buf ) ;
    }

} /* end utDfile_slink */

void utDfile_symlink(char *resides, char *filename)
{
    INT status ;

    status = symlink( resides, filename ) ;
    if( status ){
      utDmsg_syserr( FALSE, "utDfile_symlink", "symlink failure:%s", filename ) ;
    }

} /* end utDfile_slink */

LONG utDfile_size(const char *filename)
{
    struct stat buf;

    if( filename ){
	if( stat(filename, &buf) == 0 ){
	  return((LONG) buf.st_size ) ;
	}
    }
    return(-1) ;
} /* end utDfile_size() */

#include <sys/file.h>
FILE *utDfile_create_lock(char *filename, BOOL readNotWrite)
{
    INT fd ;             /* file descriptor */
    INT status ;         /* return status */
    struct flock lock ;	 /* file locking structure */
    FILE *fp ;           /* file stream descriptor */

    if(!(utDfileExists(filename))){ 
	/* short cut to avoid having to chmod file */
	fp = utDfile_open( filename, "w", FILE_ABORT ) ;
	fclose( fp ) ;
    }

    if( readNotWrite ){
	fd = creat( filename, O_RDONLY ) ;
	lock.l_type = F_RDLCK ;
    } else {
	fd = creat( filename, O_WRONLY ) ;
	lock.l_type = F_WRLCK ;
    }
    if( fd <= 0 ){
	utDmsg_syserr( FALSE, "utDfile_create_lock","creat failure" ) ;
	utDmsgf( ERRMSG, "utd/utDfile_create_lock:1", NULL,"could not open file %s\n",check_filename(filename) ) ;
	utDprogram_exit(PGMFAIL) ;
    }

    lock.l_start = 0 ;
    lock.l_whence = SEEK_SET ;
    lock.l_len = 0 ; /* lock the whole file */

    status = fcntl( fd, F_SETLK, &lock ) ;
    if( status != 0 ){
	utDmsg_syserr( FALSE, "utDfile_create_lock","flock failure" ) ;
	utDmsgf( ERRMSG, "utd/utDfile_create_lock:2", NULL,"could not lock file %s\n",check_filename(filename) ) ;
	utDprogram_exit(PGMFAIL) ;
    }
    /* now if we get this far find file descriptor */
    if( readNotWrite ){
	fp = (FILE *) fdopen( fd, "r" ) ;
    } else {
	fp = (FILE *) fdopen( fd, "w" ) ;
    }
    if(!(fp)){
      utDmsg_syserr( FALSE, "utDfile_create_lock","fdopen problem" ) ;
      utDmsgf( ERRMSG,"utd/utDfile_create_lock:3", NULL,"could not get file descriptor %s\n",
	  check_filename(filename)) ;
      utDprogram_exit(PGMFAIL) ;
    }
    return( fp ) ;
} /* end utDfile_create_lock */

/* see a file is locked */
INT utDfile_test_lock(char *filename)
{
    INT fd ;             /* file descriptor */
    INT status ;         /* return status */
    struct flock lock ;	 /* file locking structure */

    if(!(utDfileExists(filename))){ 
	/* file does not exist */
	return( FALSE ) ;
    }

    fd = open( filename, O_RDONLY, 0 ) ;
    if( fd <= 0 ){
      utDmsg_syserr( FALSE, "utDfile_test_lock","open failure" ) ;
      utDmsgf( ERRMSG, "utd/utDfile_test_lock:1", NULL, "could not open file %s\n",check_filename(filename) ) ;
      utDprogram_exit(PGMFAIL) ;
    }
    lock.l_type = F_RDLCK ;
    lock.l_start = 0 ;
    lock.l_whence = SEEK_SET ;
    lock.l_len = 0 ; /* lock the whole file */
    status = fcntl( fd, F_GETLK, &lock ) ;
    if( status ){
      utDmsg_syserr( FALSE, "utDfile_test_lock","fcntl failure" ) ;
      utDprogram_exit(PGMFAIL) ;
    }
    if( lock.l_type == F_UNLCK ){
      return(FALSE) ;
    } else {
      return(lock.l_pid) ;
    }
} /* end utDfile_test_lock() */

INT utDfile_delete(char *pathname)
{
    INT status ;

    status = unlink( pathname ) ;
    if( status ){
      utDmsg_syserr( FALSE, "utDfile_delete", "Problem deleting file" ) ;
    }
    return(status) ;
  
} /* end utDfile_delete() */

INT utDfile_max_open_files(INT *limit,BOOL max_limit)
{
#ifdef HAVE_RLIMIT_NOFILE
    LONG cur_size, max_files ;

    utDgetrlimit(RLIMIT_NOFILE, &cur_size, &max_files) ;
    if( max_limit ){
      if( cur_size < max_files ){
	utDsetrlimit(RLIMIT_NOFILE, max_files, max_files) ;
	utDgetrlimit(RLIMIT_NOFILE, &cur_size, &max_files) ;
      }
    }
    if( limit ){
      *limit = max_files ;
    }
    return( cur_size ) ;
#else 
    return( 10 ) ;
#endif
} /* end utDfile_max_open_files() */

INT utDfile_enumerate_dir( char *dirname, utDfile_enum_func cb_func, VOIDPTR user_data)
{
    DIR *dp ;				/* current directory */
    struct dirent *dirlist_p ;		/* current listing */

    dp = (DIR *) opendir(dirname) ;
    if( dp ){
#ifdef solaris2
      int status ;			/* return status from directory search */
      struct dirent *dirbuf_p ;		/* allocate memory */
      dirbuf_p = (struct dirent *) 
	UTDMALLOC( sizeof(struct dirent) + _POSIX_PATH_MAX, char) ; 
      for( status = readdir_r(dp,dirbuf_p,&dirlist_p) ; !(status) && dirlist_p ; 
	   status = readdir_r(dp,dirbuf_p,&dirlist_p) ){
#else
      for( dirlist_p = readdir(dp) ; dirlist_p ; dirlist_p = readdir(dp) ){
#endif /* solaris */
	(*cb_func)( dirname, dirlist_p->d_name, user_data ) ;
      }
      closedir(dp) ;
#ifdef solaris2
      UTDFREE(dirbuf_p) ;
#endif /* solaris */
      return(0) ;
    }
    return(1) ; /* nothing read */
} /* end utDfile_enumerate_dir() */


INT utDfile_access(char *pathname, FILE_ACCESS_T modes)
{
    INT result ;			/* result from system function */
    INT access_modes ;			/* exclusive or access modes */

    access_modes = 0 ;
    if( modes & UTDFILE_READ ){
      access_modes |= R_OK ;
    }
    if( modes & UTDFILE_WRITE ){
      access_modes |= W_OK ;
    }
    if( modes & UTDFILE_EXECUTE ){
      access_modes |= X_OK ;
    }
    if( modes & UTDFILE_FILE_EXISTS ){
      access_modes |= F_OK ;
    }
#ifdef HAVE_ACCESS
    result = access( pathname, access_modes ) ;
#else
    result = 0 ;
#endif /* HAVE_ACCESS */
    return( result ) ;
} /* end Yfile_access() */

static INT file_calc_access_modes( FILE_ACCESS_T modes )
{
    INT access_modes ;

    access_modes = 0 ;
    if( modes & UTDFILE_USER_T ){
      if( modes & UTDFILE_READ ){
	access_modes |= S_IRUSR ;
      }
      if( modes & UTDFILE_WRITE ){
	access_modes |= S_IWUSR ;
      }
      if( modes & UTDFILE_EXECUTE ){
	access_modes |= S_IXUSR ;
      }
    }
    if( modes & UTDFILE_GROUP_T ){
      if( modes & UTDFILE_READ ){
	access_modes |= S_IRGRP ;
      }
      if( modes & UTDFILE_WRITE ){
	access_modes |= S_IWGRP ;
      }
      if( modes & UTDFILE_EXECUTE ){
	access_modes |= S_IXGRP ;
      }
    }
    if( modes & UTDFILE_WORLD_T ){
      if( modes & UTDFILE_READ ){
	access_modes |= S_IROTH ;
      }
      if( modes & UTDFILE_WRITE ){
	access_modes |= S_IWOTH ;
      }
      if( modes & UTDFILE_EXECUTE ){
	access_modes |= S_IXOTH ;
      }
    }
    return(access_modes) ;
} /* end file_calc_access_modes() */

INT utDfile_chmod( char *pathname, FILE_ACCESS_T modes)
{
    INT result ;			/* result from system function */
    INT access_modes ;			/* exclusive or access modes */

#ifdef HAVE_CHMOD
    access_modes = file_calc_access_modes( modes ) ;
    result = chmod( pathname, access_modes ) ;
#else
    result = 0 ;
#endif /* HAVE_CHMOD */
    return( result ) ;
} /* end utDfile_chmod() */

INT utDfile_fchmod(FILE *fp, FILE_ACCESS_T modes)
{
    INT fd ;				/* file descriptor */
    INT result ;			/* result from system function */
    INT access_modes ;			/* exclusive or access modes */

    access_modes = file_calc_access_modes( modes ) ;
    fd = fileno( fp ) ;
#ifdef HAVE_FCHMOD
    result = fchmod( fd, access_modes ) ;
#else
    result = 0 ;
#endif /* HAVE_FCHMOD */
    return( result ) ;
} /* end utDfile_fchmod() */

#ifdef DEBUG
void utDfile_close(FILE *fp)
{
  UTDCLOSE(fp) ;
}
#endif /* DEBUG */

/* --------------end file routines ------------------------------- */
#else /* TEST */

#define FNAME "/tmp/file_test_lock_file"

static void list_file( char *directory, char *filename, VOIDPTR user_data )
{
    fprintf( stderr, "dir:%s file:%s user_data:%s\n", directory, filename,
      (char *) user_data ) ;
} /* end list_file() */

int main(int argc,char *argv[])
{
    INT status ;			/* status of lock */
    INT flimit ;			/* soft file limit */
    INT max_limit ;			/* hard file limit */
    char *user_data ;			/* user data */
    BOOL parent ;			/* true if in parent */
    FILE *fp ;				/* file pointer */
    UTD_FILE_COMPRESS_TYPE types ;	/* compression types */

    /* Check the ability to read and write compressed files */
    for( types = 0 ; types <= UTD_MAX_COMPRESS_TYPE_T ; types++ ){
      utDfile_compress_type( types ) ;
      utDmsgf(IMSG,MSG_AT,"main","Trying to compress with type:%s\n", 
	  compress_suffixS[types] ) ;
      fp = UTDOPEN( "junk", "Zw", FILE_NOABORT|FILE_VERBOSE ) ;
      fprintf( fp, "This is my junk\n" ) ;
      UTDCLOSE(fp) ;
    }
    /* Now read them */
    for( types = 0 ; types <= UTD_MAX_COMPRESS_TYPE_T ; types++ ){
      utDfile_compress_type( types ) ;
      utDmsgf(IMSG,MSG_AT,"main","Trying to read the compress file:%s%s\n", 
	  "junk", compress_suffixS[types] ) ;
      fp = UTDOPEN( "junk", "Zr", FILE_NOABORT|FILE_VERBOSE ) ;
      utDfile_echo( fp, stderr ) ;
      UTDCLOSE(fp) ;
    }

    fprintf( stderr, "Test of enumeration of directory.\n" ) ;
    user_data = "ok" ;
    utDfile_enumerate_dir( ".", list_file, user_data ) ;

    fprintf( stderr, "Test of access of directory.\n" ) ;
    status = utDfile_access("/var/tmp", UTDFILE_READ|UTDFILE_WRITE) ;
    if( status ){
      utDmsg_syserr(FALSE,"main", "access problems" ) ;
    }
    fprintf( stderr, "access : %s\n", (status ? "denied" : "ok" ) ) ;

    fprintf( stderr, "Test of fchmod of file.\n" ) ;
    fp = UTDOPEN( "user_file_test", "w", FILE_ABORT ) ;
    status = utDfile_fchmod( fp, UTDFILE_USER_T|UTDFILE_WORLD_T|UTDFILE_GROUP_T|UTDFILE_READ|UTDFILE_WRITE|UTDFILE_EXECUTE) ;
    if( status ){
      utDmsg_syserr(FALSE,"main", "fchmod problems" ) ;
    }
    fprintf( stderr, "fchmod : %s\n", (status ? "denied" : "ok" ) ) ;
    UTDCLOSE(fp) ;

    status = utDdirectoryExists("./mydir") ;
    if( status ){
      fprintf( stderr, "Directory ./mydir exists.\n" ) ;
    } else {
      fprintf( stderr, "Directory ./mydir does not exist.\n" ) ;
    }

    fprintf( stderr, "Test of chmod of directory.\n" ) ;
    status = utDfile_chmod( "./mydir", UTDFILE_USER_T|UTDFILE_WORLD_T|UTDFILE_GROUP_T|UTDFILE_READ|UTDFILE_WRITE|UTDFILE_EXECUTE) ;
    if( status ){
      utDmsg_syserr(FALSE,"main", "chmod problems" ) ;
    }
    fprintf( stderr, "chmod : %s\n", (status ? "denied" : "ok" ) ) ;
    UTDCLOSE(fp) ;

    flimit = utDfile_max_open_files(&max_limit,FALSE) ;
    fprintf( stderr, "Maximum number of open files:%d limit:%d.\n",
      flimit, max_limit ) ;
    flimit = utDfile_max_open_files(&max_limit,TRUE) ;
    fprintf( stderr, "Adjusted maximum number of open files:%d limit:%d.\n",
      flimit, max_limit ) ;

    /* now first test the lock file */
    fprintf( stderr, "Testing lock.  File may/may not be locked\n" ) ;
    status = utDfile_test_lock( FNAME ) ;
    if( status ){
      fprintf( stderr, "%s is locked by process:%d\n", FNAME, status ) ;
    } else {
      fprintf( stderr, "There is no lock on file:%s\n", FNAME ) ;
    }

    fprintf( stderr, "creating lock.  Now file should be locked\n" ) ;
    fp = utDfile_create_lock( FNAME, FALSE ) ;
    fprintf( fp, "Stuff\n" ) ;

    /* Now fork to test the lock */
    status = fork() ;
    switch( status ){
    case -1 : fprintf( stderr, "Fork failed.n" ) ;
	      exit(1) ;
	      break ;
    case 0 : parent = FALSE ;
	     break ;
    default : parent = TRUE ;
    }


    status = utDfile_test_lock( FNAME ) ;
    if( status ){
      fprintf( stderr, "%s is locked by process:%d (%s)\n", FNAME, status,
	(parent ? "parent" : "child" ) ) ;
    } else {
      fprintf( stderr, "There is no lock on file:%s (%s)\n", FNAME,
	(parent ? "parent" : "child" ) ) ;
    }
    if( parent ){
      fprintf( stdout, "Parent enters loop.\n" ) ;
      fflush( stdout ) ;
      while(1) ;
    }
    utDsleep(10) ;
    _exit(0) ;
    
} /* end main() */

#endif /* TEST */
