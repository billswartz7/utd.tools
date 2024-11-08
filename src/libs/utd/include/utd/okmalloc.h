/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    okmalloc.h
DESCRIPTION:Definitions for dynamic memory creation and deletion.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_OKMALLOC_H
#define INCLUDED_UTD_OKMALLOC_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* memory definitions - for portability and ease of use */
#define UTDMALLOC(n, els)              (els *) utDmalloc((n)*sizeof(els))
#define UTDCALLOC(n, els)              (els *) utDcalloc(n, sizeof(els))
#define UTDREALLOC(ar,n,els)           (els *) utDrealloc(ar,(n)*sizeof(els))
#define UTDFREE(els)                   utDfree(els)
#define UTDMALLOC_USE() 	       utDmalloc_use()

#define UTDVECTOR_MALLOC(lo, hi, els)   (els *) utDvector_alloc(lo,hi,sizeof(els))
#define UTDVECTOR_CALLOC(lo, hi, els)   (els *) utDvector_calloc(lo,hi,sizeof(els))
#define UTDVECTOR_FREE(ar,lo)           utDvector_free( ar,lo,sizeof(* ar))
#define UTDVECTOR_REALLOC(ar,lo,hi,els) (els *) utDvector_realloc( ar,lo,hi,sizeof(els))
#define UTDVECTOR_OFFSET(ar_xz,lo_xz,els_xz) (els_xz *) ( ((char *)(ar_xz)) - lo_xz * sizeof(els_xz))

/* -----------------------------------------------------------------
 * Now the xxx_WITH_SIZE macros which set the allocation size.
----------------------------------------------------------------- */
#define UTDMALLOC_WITH_SIZE(n, els, sz_xz)      (els *) utDmalloc((n)*(sz_xz))
#define UTDCALLOC_WITH_SIZE(n, els, sz_xz)      (els *) utDcalloc(n, (sz_xz))
#define UTDREALLOC_WITH_SIZE(ar,n,els, sz_xz)   (els *) utDrealloc(ar,(n)*(sz_xz))
#define UTDVECTOR_MALLOC_WITH_SIZE(lo, hi, els, sz_xz)  \
				      (els *) utDvector_alloc(lo,hi,(sz_xz))
#define UTDVECTOR_CALLOC_WITH_SIZE(lo, hi, els, sz_xz)  \
				      (els *) utDvector_calloc(lo,hi,(sz_xz))
#define UTDVECTOR_REALLOC_WITH_SIZE(ar,lo,hi,els, sz_xz) \
				      (els *) utDvector_realloc( ar,lo,hi,(sz_xz))

/* memory manager definitions - safety net between memory manager */
extern void utDfree( VOIDPTR ptr ) ;
extern void *utDmalloc( INT bytes ) ;
extern void *utDcalloc( INT num_entries, INT bytes ) ;
extern void *utDrealloc( VOIDPTR ptr, INT bytes ) ;
extern void *utDvector_alloc( INT lo, INT hi, INT size ) ;
extern void *utDvector_calloc( INT lo, INT hi, INT size ) ;
extern void *utDvector_realloc( VOIDPTR array,INT lo,INT hi,INT size ) ;
extern void utDvector_free( VOIDPTR array, INT lo, INT size ) ;
extern LONG utDmalloc_align_size( INT incr, INT obj_size, INT overhead ) ;

/* -----------------------------------------------------------------
 * The memory debug functions.
----------------------------------------------------------------- */
/* How much memory are we using */
extern UINT64 utDmalloc_use(void) ;

/* Dump memory details to a file */
extern void utDmalloc_dump_use( FILE *fout ) ;

/* Turn on the debugging of memory.  User supplies file, how often to
 * update and traceback length */
extern void utDmalloc_debug_memory( FILE *fp, UINT64 int_update, INT tb_len ) ;

/* Change how often to perform a memory dump */
extern void utDmalloc_debug_memory_interval( UINT64 interval_update ) ;

/* Free any debug memory and stop dumping of memory */
extern void utDmalloc_debug_memory_free( void ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

/* Memory checking for C++ */
#ifdef __cplusplus
#ifdef UTDMEM_DEBUG

#include <algorithm>
#include <vector>
#include <utd/memtrack.h>

#endif /* UTDMEM_DEBUG */
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_OKMALLOC_H */
