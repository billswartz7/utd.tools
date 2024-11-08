/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    base.h
DESCRIPTION:Common objects that crop up everywhere
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_BASEOBJ_H
#define INCLUDED_UTD_BASEOBJ_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/*-------
  Defines
  -------*/
#define LARGE_TILES

/*-------------------------------------------------------------------
 * Structure definition for TILEPOINT (an x,y pair).
 *-------------------------------------------------------------------
 */
#ifdef LARGE_TILES
  typedef DOUBLE UTDTILEBYTES ;
#else 
  typedef INT UTDTILEBYTES ;
#endif /* LARGE_TILES */

typedef struct {
  UTDTILEBYTES p_x ;
  UTDTILEBYTES p_y ;
} UTDTILEPOINT, *UTDTILEPOINTPTR ;

/*-------------------------------------------------------------------
 * Structure definition for rectangles.	 A rectangle is defined
 * by the coordinates of its lower-left and upper-right corners.
 * Most routines that manipulate rectangles require the first
 * point to really be the lower-left one, so be careful about this.
 * A null rectangle is indicated by making both x-coordinates the
 * same.
 *-------------------------------------------------------------------*/

typedef struct utdtile_rec {
  UTDTILEPOINT r_ll ;		/* Lower-left corner of rectangle. */
  UTDTILEPOINT r_ur ;		/* Upper-right corner of rectangle. */
} UTDTILERECT, *UTDTILERECTPTR ;

typedef UTDTILERECT UTDRECT ;
typedef UTDTILERECTPTR UTDRECTPTR ;

#define UTDLLX r_ll.p_x
#define UTDLLY r_ll.p_y
#define UTDURX r_ur.p_x
#define UTDURY r_ur.p_y

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_BASEOBJ_H */
