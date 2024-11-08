/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    exec.c                                       
DESCRIPTION:Exec a job in the background using a pipe.
REVISIONS: 
----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/base.h>
#include <stdio.h>

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif /* HAVE_SYS_SOCKET_H */

#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif /* HAVE_NETINET_IN_H */

#ifdef HAVE_NETDB_H
#include <netdb.h>
#endif  /* HAVE_NETDB_H */

#ifdef HAVE_STDLIB_H
#include 	<stdlib.h>
#endif /* HAVE_STDLIB_H */

#ifdef HAVE_UNISTD_H 
#include	<unistd.h>
#endif /* HAVE_UNISTD_H */

#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif /* HAVE_FCNTL_H */

#ifdef HAVE_SYS_IOCTL_H
#include <sys/ioctl.h>
#endif /* HAVE_SYS_IOCTL_H */

#ifdef HAVE_SYS_SELECT_H
#include <sys/select.h>
#endif /* HAVE_SYS_SELECT_H */

#ifdef HAVE_NET_NH_H
#include <net/nh.h>
#endif /* HAVE_NET_NH_H */

#ifdef HAVE_SYS_STREAM_H
#include <sys/stream.h>
#endif /* HAVE_SYS_STREAM_H */

#ifdef HAVE_SYS_WAIT_H
#include <sys/wait.h>
#endif /* HAVE_SYS_WAIT_H */

#include <utd/msg.h>
#include <utd/debug.h>
#include <utd/file.h>
#include <utd/string.h>
#include <utd/system.h>
#include <utd/exec.h>

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif /* HAVE_SYS_TYPES_H */

#ifdef HAVE_SYS_WAIT_H
#include <sys/wait.h>
#endif /* HAVE_SYS_WAIT_H */

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif /* HAVE_SYS_STAT */

#ifdef HAVE_VFORK_H
#include <vfork.h>
#endif /* HAVE_VFORK_H */

#ifdef HAVE_SYS_TERMIOS_H
#include <sys/termios.h>
#endif /* HAVE_SYS_TERMIOS_H */

#define ERROR    (-1)
#define STDOUT   1
#define STDERR   2
#define READ     0
#define WRITE    1

/* -----------------------------------------------------------------
 * We use vfork here instead of fork because many systems do not
 * implement fork properly and copy over the entire memory space.
 * Vfork avoids this problem.
----------------------------------------------------------------- */
#if defined(__sgi) || defined(sco)
#define FORK()	fork()
#else
#define FORK()	fork()
#endif /* __sgi */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */


FILE *utDexec_pipe( char *command, UTDEXEC_T options,INT *child_pid )
{
    INT i ;
    char cmd[LRECL] ;
    char **argv ;
    FILE *fp ;

    /* first build arg vector */
    strcpy( cmd, command ) ;
    argv = utDexec_build_arg_vector( cmd ) ;
    fp = _utDexec_pipe( argv, options, child_pid, NULL ) ;
    for( i = 0 ; argv[i] ; i++ ){
      UTDFREE(argv[i]) ;
    }
    UTDVECTOR_FREE( argv, 0 ) ;
    return(fp) ;
} /* end utDexec_pipe() */

INT __utDexec_pipe( char **argv, UTDEXEC_T options,INT *child_pid,
		   FILE **fin )
{
    INT pid ;
    INT pfd[2] ;
    INT tofd[2] ;
    BOOL fail ;
    BOOL open_stdin ;
    BOOL open_stderr ;
    BOOL open_stdout ;
    BOOL abort_flag ;
    char *routine ;

    routine = "utDexec_pipe" ;

    abort_flag = options & UTDEXEC_OPT_ABORT ;
    if( fin ){
      if( pipe( tofd ) == ERROR ){
	utDmsg_syserr(abort_flag,routine,"input pipe error" ) ;
	return(-1) ;
      }
    }

    if( pipe( pfd ) == ERROR ){
      utDmsg_syserr(abort_flag,routine,"pipe error" ) ;
      return(-1) ;
    }
    if( (pid = FORK()) == ERROR ){
      utDmsg_syserr(abort_flag,routine, "fork error" ) ;
      if( close( pfd[WRITE]) == ERROR ){
	  utDmsg_syserr(abort_flag,routine, "close error" ) ;
      }
      return(-1) ;
    } else if( pid == 0 ) {
      /* this is the child process */
      D( "utDexec_pipe",
	{ 
	  INT i ;
	  fprintf( stderr,"Try to exec program:%s\n",argv[0] ) ;
	  for( i = 0 ; argv[i] ; i++ ){
	    fprintf( stderr, "argv[%d]:%s\n", i, argv[i] ) ;
	  }
	}
      ) ;

      open_stdout = options & UTDEXEC_OPT_STDOUT ;
      open_stderr = options & UTDEXEC_OPT_STDERR ;
      open_stdin = options & UTDEXEC_OPT_STDIN ;

      fail = FALSE ;
      if( open_stdin ){
	if( dup2( tofd[READ], STDIN ) == ERROR ){
	  fail = TRUE ;
	}
	close( tofd[READ] ) ;
      }
      if( open_stderr ){
	if( dup2( pfd[WRITE], STDERR ) == ERROR ){
	  fail = TRUE ;
	}
      }
      if( open_stdout ){
	if( dup2( pfd[WRITE],STDOUT ) == ERROR ){
	  fail = TRUE ;
	}
      }
      if( fin ){
	close( tofd[WRITE] ) ;
      }

      if( fail || close( pfd[WRITE] ) == ERROR || close( pfd[READ] ) == ERROR ||
	  execvp( argv[0], argv ) == ERROR ){

	  /* we don't reach this point unless an error occurs */
	  utDmsg_syserr(abort_flag,routine, argv[0] ) ;
	  D( "utDexec_pipe",
	      fprintf( stderr, "Reached an error in pipe\n" ) ;
	  ) ;
	  close( pfd[WRITE]) ;
	  if( fin ){
	    close( tofd[READ]) ;
	  }
	  _exit(1) ;
      }
    } else { 
      D( "utDexec_pipe",
	fprintf( stderr, "Forked a process :%d\n", pid ) ;
      ) ;
      if( close( pfd[WRITE] ) == ERROR ){
	utDmsg_syserr(abort_flag,routine, "close error" ) ;
      }
      if( fin ){
	*fin = (FILE *) fdopen(tofd[WRITE],"w") ;
	if( close( tofd[READ] ) == ERROR ){
	  utDmsg_syserr(abort_flag,routine, "close error" ) ;
	}
      }
      *child_pid = pid ;
      return pfd[READ] ;
    }

    return(-1) ;

} /* end __utDexec_pipe() */

FILE *_utDexec_pipe( char **argv, UTDEXEC_T options,INT *child_pid,
		   FILE **fin )
{
    INT out_desc ;			/* output descriptor */
    FILE *fp ;				/* output file descriptor */

    out_desc = __utDexec_pipe( argv, options,child_pid,fin ) ;
    if( out_desc < 0 ){
      return(NULL) ;
    }
    fp = (FILE *) fdopen( out_desc, "r" ) ;
    return( fp ) ;

} /* end __utDexec_pipe() */


INT utDexec( char *command, UTDEXEC_T options )
{
    INT i ;
    INT pid ;
    char cmd[LRECL] ;
    char **argv ;

    /* first build arg vector */
    strcpy( cmd, command ) ;
    argv = utDexec_build_arg_vector( cmd ) ;

    pid = _utDexec( argv, options ) ;
    for( i = 0 ; argv[i] ; i++ ){
      UTDFREE(argv[i]) ;
    }
    UTDVECTOR_FREE( argv, 0 ) ;
    return( pid ) ;
} /* end  utDexec() */

INT _utDexec( char **argv, UTDEXEC_T options )
{
    INT pid ;
    BOOL abort_flag ;

    abort_flag = options & UTDEXEC_OPT_ABORT ;
    if( (pid = FORK()) == ERROR ){
	utDmsg_syserr(abort_flag,"utDexec_pipe", "fork error" ) ;
    } else if( pid == 0 ) {
      /* this is the child process */
      D( "utDexec",
	{ 
	  INT i ;
	  fprintf( stderr,"Try to exec program:%s\n",argv[0] ) ;
	  for( i = 0 ; argv[i] ; i++ ){
	    fprintf( stderr, "argv[%d]:%s\n", i, argv[i] ) ;
	  }
	}
      ) ;

      if( options & UTDEXEC_OPT_DETACH ){
	utDexec_detach( options ) ;
      }

      if( execvp( argv[0], argv ) == ERROR ){
	/* we don't reach this point unless an error occurs */
	utDmsg_syserr(abort_flag,"utDexec", argv[0] ) ;
      }
      _exit(1) ;
    } else { 
      D( "utDexec",
	fprintf( stderr, "Forked a process :%d\n", pid ) ;
      ) ;
    }
    return( pid ) ;
} /* end  _utDexec() */

void utDexecp( char *command, UTDEXEC_T options )
{
    char cmd[LRECL] ;
    char **argv ;

    /* first build arg vector */
    strcpy( cmd, command ) ;
    argv = utDexec_build_arg_vector( cmd ) ;

    _utDexecp( argv, options ) ;

} /* end utDexecp() */

void _utDexecp( char **argv, UTDEXEC_T options )
{
    BOOL abort_flag ;	/* abort flag */

    if( execvp( argv[0], argv ) == ERROR ){
      /* we don't reach this point unless an error occurs */
      abort_flag = options & UTDEXEC_OPT_ABORT ;
      utDmsg_syserr(abort_flag,"utDexec", argv[0] ) ;
    }
} /* end _utDexecp() */


INT utDexec_pipe_func( utDkey func, VOIDPTR clientData, UTDEXEC_T options,INT *child_pid,
		     FILE **fin )
{
    INT pid ;
    INT pfd[2] ;
    INT tofd[2] ;
    BOOL fail ;
    BOOL status ;
    BOOL abort_flag ;
    BOOL open_stdin ;
    BOOL open_stderr ;
    BOOL open_stdout ;
    char *routine ;

    routine = "utDexec_pipe_func" ;

    abort_flag = options & UTDEXEC_OPT_ABORT ;
    if( fin ){
      if( pipe( tofd ) == ERROR ){
	utDmsg_syserr(abort_flag,routine,"input pipe error" ) ;
	return(-1) ;
      }
    }

    if( pipe( pfd ) == ERROR ){
      utDmsg_syserr(abort_flag,routine,"pipe error" ) ;
      return(-1) ;
    }
    if( (pid = FORK()) == ERROR ){
      utDmsg_syserr(abort_flag,routine, "fork error" ) ;
      if( close( pfd[WRITE]) == ERROR ){
	  utDmsg_syserr(abort_flag,routine, "close error" ) ;
      }
      return(-1) ;
    } else if( pid == 0 ) {
      /* this is the child process */
      open_stdout = options & UTDEXEC_OPT_STDOUT ;
      open_stderr = options & UTDEXEC_OPT_STDERR ;
      open_stdin = options & UTDEXEC_OPT_STDIN ;

      fail = FALSE ;
      if( open_stdin && fin ){
	if( dup2( tofd[READ], STDIN ) == ERROR ){
	  fail = 1 ;
	}
	close( tofd[READ] ) ;
      }
      if( open_stderr ){
	if( dup2( pfd[WRITE], STDERR ) == ERROR ){
	  fail |= 2 ;
	}
      }
      if( open_stdout ){
	if( dup2( pfd[WRITE],STDOUT ) == ERROR ){
	  fail |= 4 ;
	}
      }
      if( fin ){
	close( tofd[WRITE] ) ;
      }

      if( close( pfd[WRITE] ) == ERROR || close( pfd[READ] ) == ERROR ){
	fail |= 8 ;
      }

      status = (*func)( clientData )  ;

      if( fail || status ){
	  /* we don't reach this point unless an error occurs */
	  utDmsg_syserr(abort_flag,routine, "problem with function" ) ;
	  D( "utDexec_pipe_func",
	      fprintf( stderr, "Reached an error in pipe\n" ) ;
	  ) ;
	  close( pfd[WRITE]) ;
	  if( fin ){
	    close( tofd[READ]) ;
	  }
	  _exit(1) ;
      }
      exit(0) ;
    } else { 
      D( "utDexec_pipe_func",
	fprintf( stderr, "Forked a process :%d\n", pid ) ;
      ) ;
      if( close( pfd[WRITE] ) == ERROR ){
	utDmsg_syserr(abort_flag,routine, "close error" ) ;
      }
      if( fin ){
	*fin = (FILE *) fdopen(tofd[WRITE],"w") ;
	if( close( tofd[READ] ) == ERROR ){
	  utDmsg_syserr(abort_flag,routine, "close error" ) ;
	}
      }
      *child_pid = pid ;
      return pfd[READ] ;
    }

    return(-1) ;

} /* end utDexec_pipe_func() */


/* given a string return a argument vector */
char **utDexec_build_arg_vector( char *buffer )
{
    INT arg_count ;	/* argument counter */
    char *ptr ;		/* current place in string */
    char *cptr ;	/* current copy pointer in string */
    char **argv ;      	/* the tokenized string */
    char buf[LRECL] ;	/* buffer */

    ptr = utDremove_lblanks(buffer) ;
    argv = UTDVECTOR_CALLOC( 0, 1, char * ) ;
    arg_count = 0 ;
    for( cptr = buf ; ptr && *ptr ; ){
      if( *ptr == '\n' ){
	utDmsg(ERRMSG,MSG_AT, "build_arg_vector","newlines should not occur in commands.\n");
	ptr++ ;
	continue ;
      } else if( *ptr == '\t' ){
	utDmsg(ERRMSG,MSG_AT, "build_arg_vector","tabs should not occur in commands.\n" ) ;
	ptr++ ;
	continue ;
      } else if( *ptr == SQUOTE ){
	cptr = buf ;
	/* start of a new quoted string */
	for( ptr++ ; *ptr && *ptr != SQUOTE; ){
	  if( *ptr == '\t' || *ptr == '\n' ){
	    ptr++ ;
	    continue ;
	  }
	  *cptr++ = *ptr++ ;  
	}
	if( *ptr == SQUOTE ){
	  ptr++ ;  
	}
      } else if( *ptr != ' ' ){
	cptr = buf ;
	/* start of a new quoted string */
	for( *cptr++ = *ptr++ ; *ptr && *ptr != ' '; ){
	  if( *ptr == '\t' || *ptr == '\n' ){
	    ptr++ ;
	    continue ;
	  }
	  *cptr++ = *ptr++ ;  
	}
      }
      *cptr = EOS ;
      /* now allocate a new string and expand array */
      argv = UTDVECTOR_REALLOC( argv, 0, ++arg_count, char * ) ;
      argv[arg_count-1] = utDstrclone(buf) ;

      if( *ptr ){
	/* now remove any white space */
	for( ptr++ ; *ptr && *ptr == ' ' ; ptr++ ) ;
      }
    } /* end for( ; ptr && *ptr... */

    argv[arg_count] = NULL ;

    D( "build_arg_vector",
      {
	INT i ;
	for( i = 0 ; argv[i]; i++ ){
	  fprintf( stderr, "%s \n", argv[i] ) ;
	}
      }
    ) ;

    return( argv ) ;

} /* end utDexec_build_arg_vector() */

INT utDwait( INT *status )
{
  INT ret_code ;		/* return code from wait */
  INT exit_status ;		/* exit status */

  ret_code = wait(&exit_status) ;
  if( WIFEXITED(exit_status) ) {
      *status = WEXITSTATUS(exit_status);
  } else if ( WIFSIGNALED(exit_status) ) {
    *status = WTERMSIG(exit_status);
  } else if ( WIFSTOPPED(exit_status) ) {
    *status = WSTOPSIG(exit_status);
  } else {
    *status = exit_status ;
  }
  return(ret_code) ;
} /* end utDwait() */

INT utDwaitpid( INT pid, INT *status, INT options )
{
  INT code ;			/* return code */

  if( options ){
    code = (INT) waitpid(pid,status,WNOHANG|WUNTRACED) ;
  } else {
    code = (INT) waitpid(pid,status,0) ;
  }
  if( status ){
    if( WIFEXITED(*status) ) {
	*status = WEXITSTATUS(*status);
    } else if ( WIFSIGNALED(*status) ) {
      *status = WTERMSIG(*status);
    } else if ( WIFSTOPPED(*status) ) {
      *status = WSTOPSIG(*status);
    }
  }
  return(code) ;
} /* end utDwaitpid() */

void utDexec_detach( UTDEXEC_T options )
{
    INT fd ;				/* file descriptor */
    INT num_descriptors ;		/* number of file descriptors */
    BOOL leave_fds_open ;		/* leave file descripts as they are */
    BOOL debug ;			/* debug data */
    pid_t pid ;				/* process identifier */

    debug = options & UTDEXEC_OPT_DEBUG ;
    leave_fds_open = options & UTDEXEC_OPT_FDS_OPEN ;

    if(!(leave_fds_open)){
      /* first close all open file descriptors */
      num_descriptors = utDnum_fds() ;
      for( fd = num_descriptors - 1 ; fd >= 0 ; fd-- ){
	if( !(debug) || (fd != STDERR) ){
	  UTDCLOSESOCKET(fd);
	}
      }
    } else if( !(debug) ){
      UTDCLOSESOCKET(STDOUT);
      UTDCLOSESOCKET(STDERR);
    }

    if(!(debug)){
      /* detach terminal */
      fd = open( "/dev/tty", O_RDWR ) ;
      if( fd >= 0 ){
#if !defined(HPUX) && !defined(sco)
	  ioctl( fd, TIOCNOTTY,0) ;
#endif /* HPUX */
	  UTDCLOSESOCKET(fd);
      }
    }

    /* set umask */
    umask(027) ;

    /* find program id */
    pid = utDgetpid() ;

    /* isolate process group */
#if defined(SETPGRP_VOID)
    setpgrp( ) ;
#else
    setpgrp( 0, pid ) ;
#endif

    /* redirect standard I/O descriptors */
    open( "/dev/null", O_RDONLY ) ; /* stdin */
    dup2(0,1) ; /* stdout */
    if(!(debug)){
      dup2(0,2) ; /* stderr */
    }
} /* end utDexec_detach() */


#ifdef TEST

#include <stdlib.h>
#include <utd/system.h>

INT my_print_func( VOIDPTR clientData )
{
    char *data ;
    data = (char *) clientData ;
    fprintf( stdout, "%s", data ) ;
    return(0) ;
} /* end my_print_func() */

int main( int argc, char ** argv )
{
    FILE *fp ;			/* read back thru pipe */
    FILE *fin ;			/* input of pipe */		
    FILE *fout ;		/* output of pipe */		
    INT i ;			/* counter */
    INT out_fd ;		/* file descriptor */
    INT pid ;			/* process pid */
    INT ret_pid ;		/* return code from wait */
    INT status ;		/* return status */
    BOOL abnormal ;		/* return abnormal flag */
    char *cmdvec[10] ;		/* command vector */
    char *bufferptr ;		/* buffer start */
    char buffer[LRECL];		/* read into buffer */
    char command[LRECL];	/* read into buffer */

    fprintf( stderr, "Initial memory:%ld\n", utDmalloc_use() ) ;

    fprintf( stderr, "Our pid is %d\n", utDgetpid() ) ;
    fprintf( stderr, "Test of wait pid...\nEnter pid:" ) ;
    bufferptr = fgets( buffer, LRECL, stdin) ;
    if( bufferptr ){
      pid = atoi(bufferptr) ;
      i = utDwaitpid( pid, &status, TRUE ) ;
      fprintf( stderr, "utDwaitpid code:%d\n", i ) ;
    }

    sprintf( command, "ls -ltr\n" ) ;
    fp = utDexec_pipe( command, UTDEXEC_OPT_STDOUT|UTDEXEC_OPT_STDERR, &pid ) ;
    if( fp ){
      while( (bufferptr = fgets( buffer, LRECL, fp) ) ){
	fprintf( stderr, "cmd:%s", bufferptr ) ;
      }
      fclose( fp ) ;
      utDwait( &status ) ;
    } else {
      fprintf( stderr, "ERROR: could not execute command:%s\n", command ) ;
    }

    fprintf( stderr, "How you do it in foreground.\n" ) ;

    /* this is how you do it in fore ground */
    status = utDsystem( "ls", FALSE, command, NULL, &abnormal ) ;
    fprintf( stderr, "system ls exited with status:%d abnormal:%d\n",
	status, abnormal ) ;


    fprintf( stderr, "Now do a quoted string\n" ) ;
    sprintf( command, "echo 'This is a great command'" ) ;
    fp = utDexec_pipe( command, UTDEXEC_OPT_STDOUT|UTDEXEC_OPT_STDERR, &pid ) ;
    if( fp ){
      while( (bufferptr = fgets( buffer, LRECL, fp) ) ){
	fprintf( stderr, "cmd:%s", bufferptr ) ;
      }
      fclose( fp ) ;
      utDwait( &status ) ;
    } else {
      fprintf( stderr, "ERROR: could not execute command:%s\n", command ) ;
    }

    fprintf( stderr, "Test of stderr mechanism\n" ) ;
    fprintf( stderr, "Test1: We should only get stdout from cmd:\n" ) ;
    sprintf( command, "stderr.test\n" ) ;
    fp = utDexec_pipe( command, UTDEXEC_OPT_STDOUT,&pid ) ;
    if( fp ){
      while( (bufferptr = fgets( buffer, LRECL, fp) ) ){
	fprintf( stderr, "cmd:%s", bufferptr ) ;
      }
      fclose( fp ) ;
      utDwait( &status ) ;
    } else {
      fprintf( stderr, "ERROR: could not execute command:%s\n", command ) ;
    }

    fprintf( stderr, "Test2: We should only get stderr from cmd:\n" ) ;
    sprintf( command, "stderr.test\n" ) ;
    fp = utDexec_pipe( command, UTDEXEC_OPT_STDERR,&pid ) ;
    if( fp ){
      while( (bufferptr = fgets( buffer, LRECL, fp) ) ){
	fprintf( stderr, "cmd:%s", bufferptr ) ;
      }
      fclose( fp ) ;
      utDwait( &status ) ;
    } else {
      fprintf( stderr, "ERROR: could not execute command:%s\n", command ) ;
    }

    fprintf( stderr, "Test3: We should get both stdout && stderr from cmd:\n" ) ;
    sprintf( command, "stderr.test\n" ) ;
    fp = utDexec_pipe( command, UTDEXEC_OPT_STDOUT|UTDEXEC_OPT_STDERR,&pid ) ;
    if( fp ){
      while( (bufferptr = fgets( buffer, LRECL, fp) ) ){
	fprintf( stderr, "from stderr.test cmd:%s", bufferptr ) ;
      }
      fclose( fp ) ;
      utDwait( &status ) ;
    } else {
      fprintf( stderr, "ERROR: could not execute command:%s\n", command ) ;
    }

    fprintf( stderr, "Now test utDwaitpid...\n" ) ;
    fprintf( stderr, "We sleep for 10 seconds in the child.\n" ) ;
    cmdvec[0] = "sleep" ;
    cmdvec[1] = "10" ;
    cmdvec[2] = NULL ;
    pid = _utDexec( cmdvec, FALSE ) ;
    fprintf( stderr, "start child with pid:%d\n", pid ) ;
    for( i = 1 ; i <= 15 ; i++ ){
      ret_pid = utDwaitpid(pid,&status,TRUE) ; 
      fprintf( stderr, "Got return code:%d from waitpid...\n", ret_pid ) ;
      utDsleep(1) ;
    }

    fprintf( stderr, "\nNow a test of _utDexec_pipe using both directions\n" ) ;
    cmdvec[0] = "cat" ;
    cmdvec[1] = "-" ;
    cmdvec[2] = NULL ;

    fout = _utDexec_pipe( cmdvec, UTDEXEC_OPT_STDIN|UTDEXEC_OPT_STDOUT|UTDEXEC_OPT_STDERR,
			&pid, &fin ) ;
    if( fout ){
      fprintf( stderr, "process id of cat:%d\n", pid ) ;
      fprintf( fin, "Cat in the Hat\n" ) ;
      fflush(fin) ;
      while( (bufferptr = fgets( buffer, LRECL, fout) ) ){
	fprintf( stderr, "reading back cmd:%s", bufferptr ) ;
	fclose(fin) ;
      }
      fprintf( stderr, "exiting loop...\n" ) ;
      fclose( fout ) ;
      ret_pid = utDwaitpid(pid,&status,FALSE) ; 
      fprintf( stderr, "Return code:%d\n", ret_pid ) ;
    }


    fprintf( stdout, "\ntest of pipe func:\n" ) ;
    fflush( stdout ) ;
    out_fd = utDexec_pipe_func( my_print_func, "print the data\nbaby\n\nbaby\n", 
	                        UTDEXEC_OPT_STDIN| UTDEXEC_OPT_STDOUT| UTDEXEC_OPT_STDERR,
				&pid, NULL ) ;
    fprintf( stderr, "what is pid:%d\n", pid ) ;
    if( out_fd > 0 ){
      fout = (FILE *) fdopen( out_fd, "r" ) ;
      fprintf( stderr, "in parent trying to read loop...\n" ) ;
      while( (bufferptr = fgets( buffer, LRECL, fout) ) ){
	fprintf( stderr, "data:%s", bufferptr ) ;
      }
      fprintf( stderr, "exiting loop...\n" ) ;
      fclose( fout ) ;
    }
    fprintf( stderr, "waiting for pid:%d...\n", pid ) ;
    ret_pid = utDwaitpid(pid,&status,FALSE) ; 
    if( ret_pid < 0 ){
      utDmsg_syserr(FALSE,"utDexec_pipe_func", "problems with the child\n" ) ;
    }
    fprintf( stderr, "Return code:%d\n", ret_pid ) ;


    fprintf( stderr, "Final memory:%ld\n", utDmalloc_use() ) ;

    exit(0) ;
    return(0) ;
} /* end main() */

#endif /* TEST */
