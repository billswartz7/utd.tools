/* Copyright (C) 2009-2019 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.
   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.
   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>. 

Modified as appropriate to supply the function in older Unix distributions 
  - WPS July 20, 2010
   
*/

#include <sys/types.h>
#include <assert.h>
#include <errno.h>
#ifndef __set_errno
# define __set_errno(Val) errno = (Val)
#endif
#include <stdio.h>
#ifndef P_tmpdir
# define P_tmpdir "/tmp"
#endif
#ifndef TMP_MAX
# define TMP_MAX 238328
#endif
#ifndef __GT_FILE
# define __GT_FILE        0
# define __GT_DIR        1
# define __GT_NOCREATE        2
#endif
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/time.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/stat.h>
#if _LIBC
# define struct_stat64 struct stat64
# define __secure_getenv __libc_secure_getenv
#else
# define struct_stat64 struct stat
# define __gen_tempname gen_tempname
# define __getpid getpid
# define __gettimeofday gettimeofday
# define __mkdir mkdir
# define __open open
# define __lxstat64(version, file, buf) lstat (file, buf)
# define __secure_getenv secure_getenv
#endif

#ifdef _LIBC
# include <random-bits.h>
# define RANDOM_BITS(Var) ((Var) = random_bits ())
# else
# define RANDOM_BITS(Var) \
      {                                                                         \
	      struct timeval tv;                                                      \
	      __gettimeofday (&tv, NULL);                                             \
	      (Var) = ((uint64_t) tv.tv_usec << 16) ^ tv.tv_sec;                      \
	    }
#endif

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#ifndef __GT_FILE
# define __GT_FILE 0
#endif

/* These are the characters used in temporary file names.  */
static const char letters[] =
"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
/* Generate a temporary file name based on TMPL.  TMPL must match the
   rules for mk[s]temp (i.e. end in "XXXXXX", possibly with a suffix).
   The name constructed does not exist at the time of the call to
   __gen_tempname.  TMPL is overwritten with the result.
   KIND may be one of:
   __GT_NOCREATE:        simply verify that the name does not exist
                        at the time of the call.
   __GT_FILE:                create the file using open(O_CREAT|O_EXCL)
                        and return a read-write fd.  The file is mode 0600.
   __GT_DIR:                create a directory, which will be mode 0700.
   We use a clever algorithm to get hard-to-predict names. */

static int
__gen_tempname2 (char *tmpl, int suffixlen, int flags, int kind)
{
  int len;
  char *XXXXXX;
  uint64_t value;
  unsigned int count;
  int fd = -1;
  int save_errno = errno;
  struct_stat64 st;
  /* A lower bound on the number of temporary files to attempt to
     generate.  The maximum total number of temporary file names that
     can exist for a given template is 62**6.  It should never be
     necessary to try all of these combinations.  Instead if a reasonable
     number of names is tried (we define reasonable as 62**3) fail to
     give the system administrator the chance to remove the problems.  */
#define ATTEMPTS_MIN (62 * 62 * 62)
  /* The number of times to attempt to generate a temporary file.  To
     conform to POSIX, this must be no smaller than TMP_MAX.  */
#if ATTEMPTS_MIN < TMP_MAX
  unsigned int attempts = TMP_MAX;
#else
  unsigned int attempts = ATTEMPTS_MIN;
#endif
  len = strlen (tmpl);
  if (len < 6 + suffixlen || memcmp (&tmpl[len - 6 - suffixlen], "XXXXXX", 6))
    {
      __set_errno (EINVAL);
      return -1;
    }
  /* This is where the Xs start.  */
  XXXXXX = &tmpl[len - 6 - suffixlen];
  /* Get some more or less random data.  */
  RANDOM_BITS (value);
  value ^= (uint64_t)__getpid () << 32;
  for (count = 0; count < attempts; value += 7777, ++count)
    {
      uint64_t v = value;
      /* Fill in the random bits.  */
      XXXXXX[0] = letters[v % 62];
      v /= 62;
      XXXXXX[1] = letters[v % 62];
      v /= 62;
      XXXXXX[2] = letters[v % 62];
      v /= 62;
      XXXXXX[3] = letters[v % 62];
      v /= 62;
      XXXXXX[4] = letters[v % 62];
      v /= 62;
      XXXXXX[5] = letters[v % 62];




    switch (kind)
        {
        case __GT_FILE:
          fd = __open (tmpl,
                       (flags & ~O_ACCMODE)
                       | O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
          break;
        case __GT_DIR:
          fd = __mkdir (tmpl, S_IRUSR | S_IWUSR | S_IXUSR);
          break;
        case __GT_NOCREATE:
          /* This case is backward from the other three.  __gen_tempname
             succeeds if __xstat fails because the name does not exist.
             Note the continue to bypass the common logic at the bottom
             of the loop.  */
          if (__lxstat64 (_STAT_VER, tmpl, &st) < 0)
            {
              if (errno == ENOENT)
                {
                  __set_errno (save_errno);
                  return 0;
                }
              else
                /* Give up now. */
                return -1;
            }
          continue;
        default:
          assert (! "invalid KIND in __gen_tempname");
          abort ();
        }
      if (fd >= 0)
        {
          __set_errno (save_errno);
          return fd;
        }
      else if (errno != EEXIST)
        return -1;
    }
  /* We got out of the loop because we ran out of combinations to try.  */
  __set_errno (EEXIST);
  return -1;
}
/* Generate a unique temporary file name from TEMPLATE.  The last six
   characters before a suffix of length SUFFIXLEN of TEMPLATE must be
   "XXXXXX"; they are replaced with a string that makes the filename
   unique.  Then open the file and return a fd. */
int
mkstemps (char *template, int suffixlen)
{
  if (suffixlen < 0)
    {
      __set_errno (EINVAL);
      return -1;
    }
  return __gen_tempname2 (template, suffixlen, 0, __GT_FILE);
}

