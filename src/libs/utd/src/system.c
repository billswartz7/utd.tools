/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	     system.c 
DESCRIPTION: Basic C interface to system calls.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <sys/wait.h>
#include <sys/utsname.h>
#include <signal.h>

#ifdef HAVE_STDLIB_H
#include 	<stdlib.h>
#endif /* HAVE_STDLIB_H */

#ifdef HAVE_UNISTD_H 
#include	<unistd.h>
#endif /* HAVE_UNISTD_H */

#ifdef HAVE_NETDB_H 
#include	<netdb.h>
#endif /* HAVE_NETDB_H */

#include <utd/base.h>
#include <utd/debug.h>
#include <utd/exec.h>
#include <utd/file.h>
#include <utd/msg.h>
#include <utd/dstring.h>
#include <utd/string.h>
#include <utd/program.h>
#include <utd/system.h>

#ifdef HAVE_EXECINFO_H
#include <execinfo.h>
#endif /* HAVE_EXECINFO_H */

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif /* HAVE_SYS_STAT_H */

#ifdef HAVE_SETITIMER
#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#endif /* HAVE_SYS_TIME_H */
#endif /* HAVE_SETITIMER */


#define HOSTNAMELEN	255		/* should be long enough */

INT utDsystem(char *program, BOOL abortFlag, char *exec_statement, 
  INT (*abort_func) (INT status), BOOL *abnormal_exit)
{
    INT status ;		/* terminate status */

    INT exit_status = 0 ;	/* exit status */
    INT abnormal = TRUE ;	/* abnormal termination flag */

    if( abnormal_exit ){
      *abnormal_exit = TRUE ;
    }
    status = system(exec_statement) ;
    if( WIFEXITED(status) ) {
      /* normal termination */
      exit_status = WEXITSTATUS(status);
//      D( "system",
 //      utDmsgf( DBGMSG, "utd/utDsystem:1", NULL, "Program %s terminated normally with exit code:%d\n",
//	 program, exit_status );
 //     );
      abnormal = FALSE ;
      if( abnormal_exit ){
	*abnormal_exit = abnormal ;
      }
    } else if ( WIFSIGNALED(status) ) {
      exit_status = WTERMSIG(status);
      utDmsgf( ERRMSG, "utd/utDsystem:2", NULL, "Program %s is terminated by signal %d%s\n",
	      program, status, 
#ifdef WCOREDUMP
	      WCOREDUMP(status) ? "(core file generated)" : " "
#else
	      " "
#endif      
	      );
    } else if ( WIFSTOPPED(status) ) {
      exit_status = WSTOPSIG(status);
      utDmsgf( ERRMSG,"utd/utDsystem:3", NULL, "Program %s is stopped by signal %d\n",
	      program, status );
    }
    
    if( abnormal ) {
      if( abort_func ){
	(*abort_func)(exit_status) ;
      }
      if( abortFlag ){
	utDprogram_exit( PGMFAIL ) ; /* exit the program */
      }
      return( exit_status == 0 ? -1 : exit_status );
    } else {
      return( exit_status ) ;
    }
    return(FALSE) ;
} /* end utDsystem() */

INT utDcopyFile(char *sourcefile, char *destfile)
{
    INT status ;		/* return status */
    char *cmd ;			/* formatted command */
    UTDDSTRING dstring ;	/* dynamic string */

    utDdstring_init( &dstring ) ;
    cmd = utDdstring_printf( &dstring, "/bin/cp %s %s", sourcefile, destfile ) ;
    status = utDsystem( "utDlib/utDcopyFile", FILE_ABORT, cmd, NULL,NULL ) ;
    utDdstring_free( &dstring ) ;
    return(status) ;
} /* end utDcopyfile() */

INT utDmoveFile(char *sourcefile, char *destfile)
{
    INT status ;		/* return status */

    status = rename( sourcefile, destfile ) ;
    if( status ){
      if( sourcefile && destfile ){
	utDmsg_syserr( FALSE, "utDmoveFile", "Problem moving file:%s -> %s",
	  sourcefile, destfile ) ;
      } else {
	utDmsg_syserr( FALSE, "utDmoveFile", "Problem moving file" ) ;
      }
    }
    return(status) ;
} /* end utDmoveFile() */

INT utDrm_files(char *files)
{
    char *cmd ;			/* formatted command */
    INT status ;		/* return status */
    UTDDSTRING dstring ;	/* dynamic string */

    utDdstring_init( &dstring ) ;
    cmd = utDdstring_printf( &dstring, "/bin/rm -rf %s", files ) ;
    status = utDsystem( "UTDlib/UTDrm_files", FILE_NOABORT, cmd, NULL, NULL ) ;
    utDdstring_free( &dstring ) ;
    return(status) ;
} /* end utDrm_files() */

INT utDmkdir_backup( char *new_dirname, BOOL save_flag )
{
    INT i ;				/* name counter */
    INT status ;			/* return status */
    char *backup_char ;			/* backup character */
    char dir_name[LRECL] ;		/* directory name */

    /* -----------------------------------------------------------------
     * Find the backup character.
     * ----------------------------------------------------------------- */
    backup_char = utDgetenv("UTDTOOLS_VERSION_CHAR") ;
    if(!(backup_char)){
      backup_char = ":" ;
    }
    /* -----------------------------------------------------------------
     * If the place directory exists, move old copy to place.# .
    ----------------------------------------------------------------- */
    if( utDdirectoryExists( new_dirname ) ){
      /* find the first missing number */
      if( save_flag ){
	/* find the first missing number */
	for( i = 1;  ; i++ ){
	  sprintf( dir_name, "%s%s%d", new_dirname, backup_char, i ) ;
	  if(!(utDdirectoryExists(dir_name))){
	    status = utDmoveFile( new_dirname, dir_name ) ;
	    break ;
	  }
	}
      } else {
	return( 0 ) ; /* directory exists and no save flag */
      }
    }
    status = utDmkdir( new_dirname ) ;
    return( status ) ;

} /* end utDmkdir_backup() */

INT utDmkdir_num_backups( char *new_dirname )
{
    INT i ;				/* name counter */
    INT status ;			/* return status */
    INT last_backup ;			/* last backup found */
    char *backup_char ;			/* backup character */
    char dir_name[LRECL] ;		/* directory name */

    /* -----------------------------------------------------------------
     * Find the backup character.
     * ----------------------------------------------------------------- */
    backup_char = utDgetenv("UTDTOOLS_VERSION_CHAR") ;
    if(!(backup_char)){
      backup_char = ":" ;
    }
    /* -----------------------------------------------------------------
     * If the place directory exists, move old copy to place.# .
    ----------------------------------------------------------------- */
    last_backup = 0 ;
    for( i = 1;  ; i++ ){
      sprintf( dir_name, "%s%s%d", new_dirname, backup_char, i ) ;
      if(!(utDdirectoryExists(dir_name))){
	break ;
      } else {
	last_backup = i ;
      }
    }
    return( last_backup ) ;

} /* end utDmkdir_num_backups() */


char *utDgetenv(const char *env_var)
{
    char *getenv(const char *) ;

    return( (char *) getenv( env_var ) ) ;

} /* end utDgetenv */

INT utDsetenv(const char *env_var,const char *value,BOOL overwrite)
{
#ifdef HAVE_SETENV
    return( setenv(utDstrclone(env_var),utDstrclone(value),overwrite) ) ;
#else
    char buffer[LRECL] ;
    sprintf( buffer, "%s=%s", env_var, value ) ;
    return( putenv( utDstrclone(buffer) ) ) ;
#endif /* HAVE_WORKING_SETENV */

} /* end utDsetenv */

INT utDgetpid(void)
{
  /* 
    extern getpid(void) ;
   */
    return( (INT) getpid() ) ;
} /* end utDgetpid() */

INT utDgetppid(void)
{
  /* 
    extern getpid(void) ;
   */
#ifdef HAVE_GETPPID
    return( (INT) getppid() ) ;
#else
    return( 0 ) ;
#endif /* HAVE_GETPPID */
} /* end utDgetppid() */

INT utDmkdir(char *path)
{
    INT status ;			/* return status */
    status = mkdir( path, 0777 ) ;
    return( status ) ;
} /* end utDmkdir() */

void utDsleep(INT sleep_amount)
{
  /*
    extern sleep(unsigned int) ;
   */
    sleep( (UNSIGNED_INT) sleep_amount ) ;
} /* end utDsleep() */

INT utDchdir(char *path)
{
    extern int chdir(const char *) ;
    return( chdir(path) ) ;
} /* end utDchdir() */

char *utDgetwd(char *path,INT len)
{
    return( (char *) getcwd(path,len) ) ;
} /* end utDgetwd() */

char *utDhostname(void)
{
  static char nameL[HOSTNAMELEN] = "" ;

  if( !(nameL[0]) ) {
    gethostname( nameL, HOSTNAMELEN);
  }
  return( nameL ) ;
} /* end utDhostname() */


#include <grp.h>
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif /* HAVE_SYS_TYPES_H */
#include <pwd.h>

char *utDgetgroup(void)
{
    gid_t egid ;		/* group id */
    struct group *grp ;		/* group information */
    extern gid_t getegid(void) ;
    extern struct group *getgrid() ;

    egid = getegid() ;
    if( (grp = getgrgid(egid)) ){
      return( grp->gr_name ) ;
    }
    return( utDstrclone("unknown") ) ;

} /* end Ygetgroup() */

/* -----------------------------------------------------------------
 * If REAL_LOGIN is defined, then we get the real not effective
 * user name.  Otherwise, we get the effective login name.  The
 * effective name allows use to use su to change the login name.
----------------------------------------------------------------- */
char *utDgetlogin(void)
{
    struct passwd *pw ;		/* password information */
    extern struct passwd *getpwuid(uid_t) ;
    extern uid_t geteuid(void) ;
    char *name ;		/* login name */

    pw = getpwuid( geteuid() ) ;
    if( pw ){
      return( pw->pw_name ) ;
    }
    name = (char *) getlogin() ;
    if( name ){
      return( name ) ;
    }
    return( utDstrclone("unknown") ) ;

} /* end utDgetlogin() */


char *utDgethomedir(char *who)
{
    struct passwd *pass;

    pass = getpwnam( who ) ;
    if( pass ){
      return( pass->pw_dir ) ;
    }
    return( NULL ) ;
  
} /* end utDgethomedir() */


char *utDuname(void)
{
  INT stat ;			/* return code */
  struct utsname id ;		/* id */
  static char nameL[65] ;	/* return os name */

  if( !(nameL[0]) ) {
#ifdef sco 
   sprintf( nameL, "SCO"  ) ;
#endif /* end sco */
#ifdef ncr
   sprintf( nameL, "NCR"  ) ;
#endif /* end ncr */
#ifdef sun
    sprintf( nameL, "SunOS4"  ) ;
#endif
#ifdef solaris2
#ifdef SPARC64BITS
    sprintf( nameL, "SunOS5-m64"  ) ;
#else 
    sprintf( nameL, "SunOS5"  ) ;
#endif /* __i386 */
#endif /* solaris */
#if !defined(sco) && !defined(ncr) && !defined(solaris2) && !defined(sun)
    stat = uname(&id) ;
    if( stat >= 0 ){ 
      sprintf( nameL, "%s", id.sysname ) ;
#ifdef linux
      /* Make sure we don't have ix86 */
      {
	INT len = strlen( id.machine ) ;
	if( len >= 4 && (id.machine[0] == 'i') && (id.machine[2] == '8') &&
	    (id.machine[3] == '6') ){
	  /* ok */
	} else {
	  strcat( nameL, "-" ) ;
	  strcat( nameL, id.machine ) ;
	}
      }
#endif /* linux */
    }
#endif /* ! defined sco... */
  }
  return( nameL ) ;
} /* end utDuname() */

char *utDmachine_type(void)
{
  INT stat ;			/* return code */
  static char machineL[32] ;	/* return machine type */
  struct utsname id ;		/* id */

  stat = uname(&id) ;
  if( stat >= 0 ){
    strncpy( machineL, id.machine, 31 ) ;
    machineL[31] = EOS ;
    return( machineL ) ;
  } else {
    return( "unknown" ) ;
  }
} /* end utDuname() */

char *utDos_version(void)
{
  INT stat ;			/* return code */
  struct utsname id ;		/* id */

  stat = uname(&id) ;
  if( stat >= 0 ){
    return( utDstrclone(id.version) ) ;
  } else {
    return( "unknown" ) ;
  }
} /* end utDos_version() */

char *utDgethostbyname(char *hostname)
{
    struct hostent *hostinfo ;

    hostinfo = (struct hostent *) gethostbyname(hostname) ;
    if(!(hostinfo)){
      return(NULL) ;
    }
    return( (char *) hostinfo->h_name ) ;

} /* end utDgethostbyname() */

char *utDgethostbynames(char *hostname, char ***aliases_ret )
{
    struct hostent *hostinfo ;
    char **aliases ;
    char **alias_array ;	
    INT acnt ;
    INT num_aliases ;

    if( aliases_ret ){
      *aliases_ret = NULL ;
    }
    hostinfo = (struct hostent *) gethostbyname(hostname) ;
    if(!(hostinfo)){
      return(NULL) ;
    }
    aliases = hostinfo->h_aliases ;
    if( aliases ){
      for( acnt = 0, num_aliases = 0 ; aliases[acnt] && acnt < 100 ; acnt++ ){
	num_aliases++ ;
      }
      if( num_aliases > 0 ){
	alias_array = UTDCALLOC( num_aliases+1, char * ) ;
	for( acnt = 0; aliases[acnt] && acnt < 100 ; acnt++ ){
	  alias_array[acnt] = aliases[acnt] ;
	}
	*aliases_ret = alias_array ;
      }
    }
    return( (char *) hostinfo->h_name ) ;

} /* end utDgethostbyname2() */

#ifdef HAVE_SYS_RESOURCE_H
#include <sys/time.h>
#include <sys/resource.h>
#endif /* HAVE_SYS_RESOURCE_H */

INT utDgetrlimit(INT resource, LONG *resource_current, LONG *resource_max )
{
    INT status ;			/* return status */
    struct rlimit resources ;

    status = getrlimit( resource, &resources ) ;
    *resource_current = resources.rlim_cur ;
    *resource_max = resources.rlim_max ;

    return(status) ;

} /* end utDgetrlimit() */

INT utDsetrlimit(INT resource, LONG resource_current, LONG resource_max )
{
    INT status ;			/* return status */
    struct rlimit resources ;

    resources.rlim_cur = resource_current ;
    resources.rlim_max = resource_max ;
    status = setrlimit( resource, &resources ) ;
    return(status) ;

} /* end utDsetrlimit() */

BOOL utDprocessExists(LONG pid)
{
    INT status ;			/* return status */

    status = kill(pid, 0) ;
    if( status == 0 ){
      return(TRUE) ;
    }
    return(FALSE) ;

} /* end utDprocessExists() */

BOOL utDprocessKill(LONG pid)
{
    INT status ;			/* return status */

    status = kill(pid, SIGKILL) ;
    if( status == 0 ){
      return(TRUE) ;
    }
    return(FALSE) ;

} /* end utDprocessKill() */

void utDbacktrace( char *msg, FILE *fp, INT max_backtrace )
{
  FUNC_NAME("utDbacktrace") ;
#if defined(HAVE_BACKTRACE)
  INT c ;				/* stack counter */
  INT len ;				/* length of string */
  int num_on_stack ;			/* number on the stack */
  char **strings ;			/* address to name */
  void *stack_array[MAX_BACKTRACE] ;	/* raw stack addresses */
  char *traceback_string ;		/* where we are in stack */
  char backtrace_buffer[LRECL] ;	/* make a buffer */
  static FILE *lookup_pgmL ;		/* talk to the addr2line pipe */
  static FILE *lookup_finL ;		/* output of addr2line */

  if( max_backtrace > MAX_BACKTRACE ){
    utDmsgf( ERRMSG, "utDbacktrace:1", routine, "max backtrace requested:%d exceeds alloc:%d\n",
	max_backtrace, MAX_BACKTRACE ) ;
    max_backtrace = MAX_BACKTRACE ;
  }

  num_on_stack = backtrace( stack_array, max_backtrace ) ;
  if( msg ){
      fprintf( fp, "%s\n", msg ) ;
  } else {
    utDmsg( ERRMSG, "utDbacktrace:2", routine, "backtrace:\n" ) ;
  }
  if(!(lookup_pgmL)){
    lookup_pgmL = utDbacktrace_start_addr2line( &lookup_finL ) ;
  }
  strings = backtrace_symbols( stack_array, num_on_stack ) ;
  if( strings ){
    for( c = 0 ; c < num_on_stack ; c++ ){
      traceback_string = strings[c] ;
      if( lookup_pgmL ){
#ifdef HAVE_ADDR2LINE
	INT string_argc ;		/* argument counter */
	char buffer[LRECL] ;		/* build a buffer */
	char read_buffer[LRECL] ;	/* read into this buffer */
	char *reply ;			/* reply from child */
	char *address ;			/* address to lookup */
	char *function_string ;		/* corresponding function */
	char *line_string ;		/* corresponding line number */
	char **string_argv ;		/* string argument vector */
	char *token_buf[LRECL] ; 	/* impossible to have more tokens */

	strcpy( buffer, strings[c] ) ;
	string_argv = utDstrparser2( buffer, " ()[]\t\n", token_buf, &string_argc ) ;
	if( string_argc >= 2 ){
	  address = string_argv[1] ;
	  if( address && *address == '+' ){
	    address++ ;
	  }
	  /*
	  fprintf( stderr, "string: %s\n", strings[c] ) ;
	  fprintf( stderr, "lookup up address:%s\n", address ) ;
	  */
	  fprintf( lookup_finL, "%s\n", address ) ;
	  fflush( lookup_finL ) ;
	  function_string = fgets( read_buffer, LRECL, lookup_pgmL ) ;
	  if( function_string ){
	    line_string = fgets( buffer, LRECL, lookup_pgmL ) ;
	    if( line_string ){
	      len = strlen( function_string ) ;
	      if( len > 0 ){
		/* get rid of \n */
		function_string[len-1] = EOS ;
	      }
	      len = strlen( line_string ) ;
	      if( len > 0 ){
		/* get rid of \n */
		line_string[len-1] = EOS ;
	      }
	      sprintf( backtrace_buffer, "%s @ %s", function_string, line_string ) ;
	      traceback_string = backtrace_buffer ;
	    }
	  }
	}
#else  /* ! HAVE_ADDR2LINE */

#ifdef HAVE_ATOS
	INT string_argc ;		/* argument counter */
	INT status ;			/* return status */
	char buffer[LRECL] ;		/* make a copy */
	char read_buffer[LRECL] ;	/* read the data */
	char command[LRECL] ;		/* build a command */
	char *address ;			/* address to lookup */
	char **string_argv ;		/* string argument vector */
	char *token_buf[LRECL] ; 	/* impossible to have more tokens */
	FILE *fread ;			/* read output */

	/* Wanted to open up a pipe but atos is very flakey. Slow but sure */
	strcpy( buffer, strings[c] ) ;
	string_argv = utDstrparser2( buffer, " \t\n", token_buf, &string_argc ) ;
	if( string_argc >= 3 ){
	  address = string_argv[2] ;
	  /*
	  fprintf( stderr, "   string: %s\n", strings[c] ) ;
	  fprintf( stderr, "   lookup up address:%s\n", address ) ;
	  */
	  sprintf( command, "atos -p %d %s > atos.out", utDgetpid(), address ) ;
	  status = utDsystem( "atos", FILE_NOABORT, command, NULL,NULL ) ;
	  fread = UTDOPEN( "atos.out", "r", FILE_NOABORT ) ;
	  if( fread ){
	    traceback_string = fgets( read_buffer, LRECL, fread ) ;
	    len = strlen( traceback_string ) ;
	    if( len > 0 ){
	      /* get rid of \n */
	      traceback_string[len-1] = EOS ;
	    }
	    UTDCLOSE( fread ) ;
	  }
	}
#endif /* HAVE_ATOS */
#endif /* HAVE_ADDR2LINE */
      }
      fprintf( fp, "%s\n", traceback_string ) ;
    }
    free(strings) ;
  }
#else /* HAVE_BACKTRACE */
  utDmsg( ERRMSG, "utDbacktrace:3", routine, "backtrace not available on this architecture.\n" ) ;
#endif /* HAVE_BACKTRACE */
} /* end utDbacktrace() */


INT utDalarm(UINT64 seconds)
{
  INT status ;			/* return status */
#ifdef HAVE_SETITIMER
  struct itimerval it_val;  /* for setting itimer */

  it_val.it_value.tv_sec = seconds ;
  it_val.it_value.tv_usec = 0 ;
  it_val.it_interval = it_val.it_value;
  status = setitimer(ITIMER_REAL, &it_val, NULL) ;
#else 
  status = alarm(seconds) ;
#endif
  return( status ) ;
} /* end utDalarm() */


INT utDnum_fds( void )
{
    static INT num_fdsL ;

    if( num_fdsL == 0 ){
#ifdef HAVE_GETDTABLESIZE
      num_fdsL = getdtablesize() ;
#else 
      num_fdsL = FD_SETSIZE ;
#endif /* HAVE_GETDTABLESIZE */
    }
    return( num_fdsL ) ;

} /* end utDnum_fds() */


FILE *utDbacktrace_start_addr2line( FILE **fin )
{
    char *cmdvec[6] ;	 	/* command vector */
    char program_name[LRECL] ; 	/* convert to string */
    INT pid ;			/* program id */
    INT addr_pid ;       	/* pid of new program */
    FILE *fout ;	 	/* output file */
#ifdef HAVE_ADDR2LINE
    char addr_pgm[80] ;	 /* name of program */

    pid = utDgetpid() ;
#ifdef HAVE_PROC_PIDPATH
    ret_status = proc_pidpath ( pid, program_name, LRECL ) ;
#else  /* ! HAVE_LIBPROC_H */
    sprintf( program_name, "/proc/%d/exe", pid ) ;
#endif /* HAVE_PROC_PIDPATH() */
    sprintf( addr_pgm, "%s", "addr2line" ) ;
    cmdvec[0] = addr_pgm ;
    cmdvec[1] = "-f" ;  /* include function names */
    cmdvec[2] = "-s" ;  /* display only the basename of file */
    cmdvec[3] = "-e" ;  /* the name of the executable */
    cmdvec[4] = program_name ;
    cmdvec[5] = NULL ;
    fout = _utDexec_pipe( cmdvec, UTDEXEC_OPT_STDIN|UTDEXEC_OPT_STDOUT|UTDEXEC_OPT_STDERR,
			&addr_pid, fin ) ;
    return( fout ) ;
#else
#ifdef       HAVE_ATOS
    /* No pipe - just fake things out */
    return( (FILE *) 1 ) ;
#else /* end HAVE_ATOS */
    return( NULL ) ;
#endif
#endif /* HAVE_ADDR2LINE */
} /* end utDbackup_start_addr2line() */

#ifdef TEST


#include <utd/program.h>
#include <utd/cleanup.h>
#include <utd/system.h>

#define DELAY     4
static BOOL wait_for_alarmS ;

static void alarm_func(INT code) {
  utDmsgf( IMSG, "alarm_func:1", "alarm_func", "signal:%d\n", code ) ;
  wait_for_alarmS = FALSE ;
}

static void backtrace_test(void)
{
    utDbacktrace( "backtrace_test", stderr, 6 ) ;
} /* end backtrace_test() */

INT main( INT argc, char *argv[] )
{
    INT pid ;			/* process id */
    INT ppid ;			/* parent process id */
    INT hcnt ;			/* host counter */
    INT status ;		/* return status */
    char *val ;			/* environment var */
    char *hname ;		/* host name */
    char *uname ;		/* machine name */
    char **aliases ;		/* array of aliases */
    FUNC_NAME("system_test") ;

    utDprogram_init( routine, "version1", "Today", FALSE );
    /* Routines to test 
      INT Ysystem(char *program, BOOL abortFlag, char *exec_statement, 
	INT (*abort_func) (INT status))
      INT YcopyFile(char *sourcefile, char *destfile)
      INT YmoveFile(char *sourcefile, char *destfile)
      INT Yrm_files(char *files)
      INT Ymkdir_backup( char *new_dirname, BOOL save_flag )
      INT Ymkdir(char *path)
      VOID Ysleep(INT sleep_amount)
      INT Ychdir(char *path)
      char *Ygetwd(char *path,INT len)
      char *Yhostname(void)
      char *Ygetgroup(void)
      char *Ygetlogin(void)
      char *Yuname(void)
      char *Ymachine_type(void)
      char *Ygethostbyname(char *hostname)
      INT Ygetrlimit(INT resource, LONG *resource_current, LONG *resource_max )
      INT Ysetrlimit(INT resource, LONG resource_current, LONG resource_max )
      BOOL YprocessExists(LONG pid)
    */
    /* check the sizes of things */
    fprintf( stderr, "size of SHORT:%ld\n", sizeof(SHORT) ) ;
    fprintf( stderr, "size of INT:%ld\n", sizeof(INT) ) ;
    fprintf( stderr, "size of LONG:%ld\n", sizeof(LONG) ) ;
    fprintf( stderr, "size of UNSIGNED_INT:%ld\n", sizeof(UNSIGNED_INT) ) ;
    fprintf( stderr, "size of FLOAT:%ld\n", sizeof(FLOAT) ) ;
    fprintf( stderr, "size of DOUBLE:%ld\n", sizeof(DOUBLE) ) ;
    fprintf( stderr, "size of UINT16:%ld\n", sizeof(UINT16) ) ;
    fprintf( stderr, "size of UINT32:%ld\n", sizeof(UINT32) ) ;
    fprintf( stderr, "size of UINT64:%ld\n", sizeof(UINT64) ) ;

    uname = utDuname() ;
    fprintf( stderr, "uname: %s\n", uname ) ;
    pid = utDgetpid() ;
    fprintf( stderr, "getpid: %d\n", pid ) ;
    ppid = utDgetppid() ;
    fprintf( stderr, "getppid: %d\n", ppid ) ;

    fprintf( stderr, "testing backtrace:\n" ) ;
    backtrace_test() ;
    fprintf( stderr, "\n" ) ;

    hname = utDgethostbynames("mac4", &aliases ) ;
    if( hname ){
      fprintf( stderr, "hostname: %s\n", hname ) ;
      fprintf( stderr, "aliases:" ) ;
      if( aliases ){
	for( hcnt = 0 ; aliases[hcnt] ; hcnt++ ){
	  fprintf( stderr, " %s", aliases[hcnt] ) ;
	}
	UTDFREE( aliases ) ;
      }
      fprintf( stderr, "\n" ) ;
    }

    /* Try to set an environment variable */
    status = utDsetenv( "MYCRAZY_VAR", "damn_good", TRUE ) ;
    if( status ){
      utDmsg_syserr( ERRMSG, NULL, "unexpected error\n" ) ;
    }
    val = utDgetenv( "MYCRAZY_VAR" ) ;
    utDmsgf( MSG, "a:1", routine, "my crazy var env is:%s\n", val ) ; 

    status = utDsetenv( "MYCRAZY_VAR", "Now stupid", TRUE ) ;
    if( status ){
      utDmsg_syserr( ERRMSG, NULL, "unexpected error\n" ) ;
    }
    val = utDgetenv( "MYCRAZY_VAR" ) ;
    utDmsgf( MSG, "a:2", routine, "my crazy var env is now:%s\n", val ) ; 

    status = utDsetenv( "MYCRAZY_VAR", "Now beautify", FALSE ) ;
    if( status ){
      utDmsg_syserr( ERRMSG, NULL, "unexpected error\n" ) ;
    }
    val = utDgetenv( "MYCRAZY_VAR" ) ;
    utDmsgf( MSG, "a:3", routine, "my crazy var env is still:%s\n", val ) ; 

    utDmsgf( IMSG, "a:4", routine, "Now test the alarm for %d seconds\n", DELAY ) ;
    wait_for_alarmS = TRUE ;
    utDsignal(SIGALRM, alarm_func ) ; 
    status = utDalarm(DELAY) ;
    while( wait_for_alarmS ) ;

    utDprogram_exit(PGMOK) ;

    return(0) ;

} /* end main() */
#endif /* TEST */
