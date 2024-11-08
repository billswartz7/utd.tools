/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    msg.h
DESCRIPTION:Definitions for message and logging.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_BITSET_H
#define INCLUDED_UTD_BITSET_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* The bitset macros are zero based */
#define BITSET_GET( array, index )  (array[(index)>>5] & (1 <<((index) & 0x1F)))
#define BITSET_SET( array, index )  (array[(index)>>5] |= (1 <<((index)& 0x1F)))
#define BITSET_RESET( array, i )    (array[(i)>>5] &= (~(1 << ((i) & 0x1F))) )
#define BITSET_TOGGLE( array, i )   (array[(i)>>5] ^= (1 <<((index)& 0x1F)))
#define BITSET_ALLOC( num )         ( UTDCALLOC( ((num)>>5) + 1, UNSIGNED_INT) )
#define BITSET_REALLOC( arr_xz,num )( UTDREALLOC( arr_xz, ((num)>>5) + 1, UNSIGNED_INT) )
#define BITSET_ARRYSIZE( num )      ( ((num)>>5) + 1 )
#define BITSET_MAX( array_size_xz ) ( ((array_size_xz)<<5) - 1 )
#define BITSET_EMPTY(arr_xz,num_xz) utDbitset_empty( arr_xz, num_xz )
#define BITSET_FREE(arr_xz) 	    (UTDFREE( arr_xz ) )

#define BITSET(bstr,mask)	    ( ((bstr) & (mask)) != 0 )
#define BTEST(bstr,mask)	    ( ((bstr) & (mask)) != 0 )
#define BTESTNOT(bstr,mask)	    ( ((bstr) & (mask)) == 0 )
/* denigrated */
#define BSET(bstr,mask)     	    (bstr) |= (mask)
#define BCLEAR(bstr,mask)   	    (bstr) &= ~(mask)

#define BITMODE( var_xz, m_xz )	    	    ( (var_xz) & (m_xz) )
#define BITMODE_SET( var_xz, m_xz )	    ( (var_xz) |= (m_xz) )
#define BITMODE_RESET( var_xz, m_xz )	    ( (var_xz) &= ~(m_xz) )

extern INT utDbitset_count( UNSIGNED_INT value ) ;
extern void utDbitset_empty( UNSIGNED_INT *array_p, INT array_size ) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_BITSET_H */
