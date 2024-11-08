/*-----------------------------------------------------------------
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
  FILE:		tile.h       
  DESCRIPTION:	Corner stitching routines
  		This file is based on geometry.h, magic.h
                and tile.h included in version MAGIC 4.4 (Berkeley) 10/18/85
  CONTENTS:	This module contains the basic definitions for tile
 		elements:  points, rectangles.
  DATE:		October 1989  Adapted from Magic, misc bug fixes
  REVISIONS:	August  1992  Turn into Library routines
  -----------------------------------------------------------------*/
#ifndef INCLUDED_UTD_UTDTILE_H
#define INCLUDED_UTD_UTDTILE_H


#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/*--------
  Includes
  --------*/
#include <stdio.h>
#include <utd/base.h>
#include <utd/baseobj.h>

/*-------
  Defines
  -------*/
#define UTDTILE_NORTH		8
#define UTDTILE_SOUTH		4
#define UTDTILE_WEST		2
#define UTDTILE_EAST		1
#define UTDTILE_NORTHSOUTH 	( UTDTILE_NORTH | UTDTILE_SOUTH )
#define UTDTILE_EASTWEST 	( UTDTILE_EAST | UTDTILE_WEST )
#define UTDTILE_NORTHWEST   	( UTDTILE_NORTH | UTDTILE_WEST )
#define UTDTILE_NORTHEAST   	( UTDTILE_NORTH | UTDTILE_EAST )
#define UTDTILE_SOUTHWEST   	( UTDTILE_SOUTH | UTDTILE_WEST )
#define UTDTILE_SOUTHEAST   	( UTDTILE_SOUTH | UTDTILE_EAST )
#define UTDTILE_NSEW	 	( UTDTILE_NORTH | UTDTILE_SOUTH | UTDTILE_EAST | UTDTILE_WEST )
#define UTDTILE_LEFTORRIGHT 	( UTDTILE_EAST | UTDTILE_WEST )
#define UTDTILE_UP		16
#define UTDTILE_DOWN	 	32
#define UTDTILE_UPORDOWN 	( UTDTILE_UP | UTDTILE_DOWN )
#define UTDTILE_NSEWUD 	 	( UTDTILE_NORTH|UTDTILE_SOUTH|UTDTILE_EAST|UTDTILE_WEST|UP|DOWN )
#define UTDTILE_HORZEDGE 	( UTDTILE_EAST | UTDTILE_WEST )
#define UTDTILE_VERTEDGE 	( UTDTILE_NORTH | UTDTILE_SOUTH )
#define UTDTILE_VIAEDGE	 	( UTDTILE_UP | UTDTILE_DOWN )

typedef enum {
  UTDTILE_MRG_TOP=	1,
  UTDTILE_MRG_LEFT =	2,
  UTDTILE_MRG_RIGHT =	4,
  UTDTILE_MRG_BOTTOM =	8
} UTDTILE_MRG ;

/*---------------
  Data Structures
  ---------------*/
/*
 * Definitions of the basic tile structures
 * The definitions in this file are all that is visible to
 * the Ti (tile) modules.
 *
 */

#define r_xbot r_ll.p_x
#define r_ybot r_ll.p_y
#define r_xtop r_ur.p_x
#define r_ytop r_ur.p_y

/*
 * A tile is the basic unit used for representing both space and
 * solid area in a plane.  It has the following structure:
 *
 *				       RT
 *					^
 *					|
 *		-------------------------
 *		|			| ---> TR
 *		|			|
 *		|			|
 *		| (lower left)		|
 *	BL <--- -------------------------
 *		|
 *		v
 *		LB
 *
 * The (x, y) coordinates of the lower left corner of the tile are stored,
 * along with four "corner stitches": RT, TR, BL, LB.
 *
 * Space tiles are distinguished at a higher level by having a distinguished
 * tile body.
 */

typedef struct UTDTILE {
  struct UTDTILE	*ti_lb;	      /* Left bottom corner stitch */
  struct UTDTILE	*ti_bl;	      /* Bottom left corner stitch */
  struct UTDTILE	*ti_tr;	      /* Top right corner stitch */
  struct UTDTILE	*ti_rt;	      /* Right top corner stitch */
  UTDTILEPOINT	 	ti_ll;	      /* Lower left coordinate */
  void			*data;        /* user data associated with tile */
} UTDTILE, *UTDTILEPTR ;

/*
 * The following macros make it appear as though both
 * the lower left and upper right coordinates of a tile
 * are stored inside it.
 */

#define	UTDTILE_BOTTOM(tp)		((tp)->ti_ll.p_y)
#define	UTDTILE_LEFT(tp)		((tp)->ti_ll.p_x)
#define	UTDTILE_TOP(tp)			(UTDTILE_BOTTOM(UTDTILE_RT(tp)))
#define	UTDTILE_RIGHT(tp)		(UTDTILE_LEFT(UTDTILE_TR(tp)))

#define	UTDTILE_LB(tp)		((tp)->ti_lb)
#define	UTDTILE_BL(tp)		((tp)->ti_bl)
#define	UTDTILE_TR(tp)		((tp)->ti_tr)
#define	UTDTILE_RT(tp)		((tp)->ti_rt)

/* ----------------------- Tile planes -------------------------------- */

/*
 * A plane of tiles consists of the four special tiles needed to
 * surround all internal tiles on all sides.  Logically, these
 * tiles appear as below, except for the fact that all are located
 * off at infinity.
 *
 *	 --------------------------------------
 *	 |\				     /|
 *	 | \				    / |
 *	 |  \		   TOP		   /  |
 *	 |   \				  /   |
 *	 |    \				 /    |
 *	 |     --------------------------     |
 *	 |     |			|     |
 *	 |LEFT |			|RIGHT|
 *	 |     |			|     |
 *	 |     --------------------------     |
 *	 |    /				 \    |
 *	 |   /				  \   |
 *	 |  /		 BOTTOM		   \  |
 *	 | /				    \ |
 *	 |/				     \|
 *	 --------------------------------------
 */

typedef enum {
  UTDPLANE_MAX_HORZ = 0,
  UTDPLANE_MAX_VERT = 1,
} UTDPLANE_ORIENT_T ;

typedef struct utdtile_plane_rec {
    UTDTILERECT area ;			/* bounding box of area */
    void     	*user_data ;		/* user data */
    INT         (*compare_func)(void *,void *) ; /* how to compare two keys */
    INT		pool_id ;		/* pool identification */
    INT		pool_size ;		/* size of pool */
    INT		lookup_x_cnt ;		/* # of x going operation */
    INT		lookup_y_cnt ;		/* # of y going operation */
    INT		tile_cnt ;		/* count # of tiles */
    INT		tile_added ;		/* count # of tiles */
    UTDTILE	*pl_left;		/* Left pseudo-tile */
    UTDTILE	*pl_top;		/* Top pseudo-tile */
    UTDTILE	*pl_right;		/* Right pseudo-tile */
    UTDTILE	*pl_bottom;		/* Bottom pseudo-tile */
    UTDTILE	*pl_hint;		/* Pointer to a "hint" at which to */
    UNSIGNED_INT count_tiles : 8 ;	/* count the tiles */
    UNSIGNED_INT data_check : 8 ;	/* turn on and off data checking */
    UNSIGNED_INT max_vertical : 8 ;	/* tiles are maximally vertical */
    UNSIGNED_INT area_initialized : 8 ; /* area was initialized */
} UTDPLANE, *UTDPLANEPTR ;

/*
 * The following coordinate, UTDTILE_INFINITY, is used to represent a
 * tile location outside of the tile plane.
 *
 * It must be possible to represent UTDTILE_INFINITY+1 as well as
 * UTDTILE_INFINITY.
 *
 * Also, because locations involving UTDTILE_INFINITY may be transformed,
 * it is desirable that additions and subtractions of small integers
 * from either UTDTILE_INFINITY or MUTDTILE_INFINITY not cause overflow.
 *
 * Consequently, we define UTDTILE_INFINITY to be the largest integer
 * representable in wordsize - 5 bits.
 *
 * For large tiles using the 52 bit mantissa of IEEE standard, we
 * subtract off 7 (6 + 1 for sign bit) to get 2^45.  We pick 2^44
 * to be conservative.
 */

#ifdef LARGE_TILES
#define	UTDTILE_INFINITY	( (DOUBLE) 17592186044416.0)
#else
#define	UTDTILE_INFINITY	( (INT)1 << ( (8 * sizeof(INT)) - 6) )
#endif /* LARGE_TILES */
#define	UTDTILE_MINFINITY	(-UTDTILE_INFINITY)

/* -----------------------------------------------------------------
 * Define the maximum and minimum area of the tile database.
 ----------------------------------------------------------------- */
#define UTDTILE_MAX        (UTDTILE_INFINITY/2.0)
#define UTDTILE_MIN        (-(UTDTILE_MAX))


/* ------------------------ Flags, etc -------------------------------- */

#define	UTDTILE_BAD	( (UTDTILEPTR) -1)	/* Invalid tile pointer */

/* ============== Function headers and external interface ============= */

/*
 * The following macros and procedures should be all that are
 * ever needed by modules other than the tile module.
 */

#define	UTDTILE_TiBottom(tp)		(UTDTILE_BOTTOM(tp))
#define	UTDTILE_TiLeft(tp)		(UTDTILE_LEFT(tp))
#define	UTDTILE_TiTop(tp)		(UTDTILE_TOP(tp))
#define	UTDTILE_TiRight(tp)		(UTDTILE_RIGHT(tp))

/*
 * GOTOPOINT is used whenever a macroized version of TiSrPoint is
 * needed.
 */

#define	UTDTILE_GOTOPOINT(tp, p) \
{ \
	if ((p)->p_y < UTDTILE_BOTTOM(tp)) \
	    do tp = UTDTILE_LB(tp); while ((p)->p_y < UTDTILE_BOTTOM(tp)); \
	else \
	    while ((p)->p_y >= UTDTILE_TOP(tp)) tp = UTDTILE_RT(tp); \
	if ((p)->p_x < UTDTILE_LEFT(tp)) \
	    do	\
	    { \
		do tp = UTDTILE_BL(tp); while ((p)->p_x < UTDTILE_LEFT(tp)); \
		if ((p)->p_y < UTDTILE_TOP(tp)) break; \
		do tp = UTDTILE_RT(tp); while ((p)->p_y >= UTDTILE_TOP(tp)); \
	    } \
	    while ((p)->p_x < UTDTILE_LEFT(tp)); \
	else \
	    while ((p)->p_x >= UTDTILE_RIGHT(tp)) \
	    { \
		do tp = UTDTILE_TR(tp); while ((p)->p_x >= UTDTILE_RIGHT(tp)); \
		if ((p)->p_y >= UTDTILE_BOTTOM(tp)) break; \
		do tp = UTDTILE_LB(tp); while ((p)->p_y < UTDTILE_BOTTOM(tp)); \
	    } \
    }

/* Fill in the bounding rectangle for a tile */
#define	UTDTILE_TITORECT(tp, rp) \
	((rp)->r_xbot = UTDTILE_LEFT(tp), (rp)->r_ybot = UTDTILE_BOTTOM(tp), \
	 (rp)->r_xtop = UTDTILE_RIGHT(tp), (rp)->r_ytop = UTDTILE_TOP(tp))

/* ----------- Macro to see if vertical merging is possible ----------- */

#ifdef LARGE_TILES
#define	UTDTILE_CANMERGE_Y(t1, t2)	(FLOAT_EQ(UTDTILE_LEFT(t1),UTDTILE_LEFT(t2)) \
				 &&     ( ! comp_f ( t1->data, t2->data ) ) \
				 &&	FLOAT_EQ(UTDTILE_RIGHT(t1),UTDTILE_RIGHT(t2)) )

#else /* NOT large tiles */
#define	UTDTILE_CANMERGE_Y(t1, t2)	(	LEFT(t1) == LEFT(t2) \
				 &&     ( ! comp_f ( t1->data, t2->data ) ) \
				 &&	RIGHT(t1) == RIGHT(t2) )

#endif /* LARGE_TILES */

#define utDtile_init( comp_xz, data_xz)	\
		      _utDtile_init( comp_xz, data_xz, 0, UTDPLANE_MAX_HORZ )
#define utDtile_init_vert( comp_xz, data_xz) \
			      _utDtile_init( comp_xz, data_xz, 0, UTDPLANE_MAX_VERT )

/*---------------------------------------------------------
   The following macros are used in for loops to find all 
   tiles (tp2) along a given edge of a tile (tp). Rectangle r
   is needed to control search.
   eg)        for ( WALKTOPSIDE(tp,tp2,r) ) {   actions   }
  ---------------------------------------------------------*/
#define UTDTILE_WALKRIGHTSIDE(tp,tp2,r)  \
      tp2=UTDTILE_TR(tp),utDtile_rect(tp,&r);UTDTILE_TOP(tp2)   > r.UTDLLY;tp2=UTDTILE_LB(tp2)
#define UTDTILE_WALKLEFTSIDE(tp,tp2,r)   \
      tp2=UTDTILE_BL(tp),utDtile_rect(tp,&r);UTDTILE_BOTTOM(tp2)< r.UTDURY;tp2=UTDTILE_RT(tp2)
#define UTDTILE_WALKTOPSIDE(tp,tp2,r)    \
      tp2=UTDTILE_RT(tp),utDtile_rect(tp,&r);UTDTILE_RIGHT(tp2) > r.UTDLLX;tp2=UTDTILE_BL(tp2)
#define UTDTILE_WALKBOTTOMSIDE(tp,tp2,r) \
      tp2=UTDTILE_LB(tp),utDtile_rect(tp,&r);UTDTILE_LEFT(tp2)  < r.UTDURX;tp2=UTDTILE_TR(tp2)

#define utDtile_plane_orientation(pl_xz)	\
    ( (pl_xz)->max_vertical ? UTDPLANE_MAX_VERT : UTDPLANE_MAX_HORZ )

#define utDtile_set_hint( pl_xz, tp_xz )  (pl_xz)->pl_hint = (tp_xz)

#define utDtile_pool_id( pl_xz ) 	((pl_xz)->pool_id)

#define TWtile_userdata( pl_xz ) ((pl_xz)->user_data)
#define TWtile_data_check( pl_xz, val_xz ) ((pl_xz)->data_check = (val_xz))

extern BOOL utDtile_add ( UTDPLANEPTR plane, UTDTILERECTPTR area, VOIDPTR data ) ;
extern BOOL _utDtile_add ( UTDPLANEPTR plane, UTDTILERECTPTR area, VOIDPTR data ) ;

extern void utDtile_free ( UTDPLANEPTR plane ) ;

extern UTDTILEPTR utDtile_gotoPoint ( UTDTILEPTR tp, UTDTILEPOINTPTR point ) ;

extern UTDPLANEPTR _utDtile_init(INT (*compare_func)(void *,void *),VOIDPTR data,
                             INT expected_size,UTDPLANE_ORIENT_T orientation) ;

extern void _utDtile_joinX ( UTDPLANEPTR plane, UTDTILEPTR tile1, UTDTILEPTR tile2 ) ;

extern void _utDtile_joinY( UTDPLANEPTR plane, UTDTILEPTR tile1, UTDTILEPTR tile2 ) ;

extern UTDTILEPTR _utDtile_merge ( UTDPLANEPTR plane, UTDTILEPTR tile,
			       VOIDPTR data, int mergeFlags ) ;

extern void utDtile_mergeOnce ( UTDPLANEPTR plane, UTDTILERECTPTR area, VOIDPTR data ) ;
extern void _utDtile_mergeOnce ( UTDPLANEPTR plane, UTDTILERECTPTR area, VOIDPTR data ) ;

extern void utDtile_empty( UTDPLANEPTR plane ) ;

extern void utDtile_rect ( UTDTILEPTR tile, UTDTILERECTPTR rect ) ;
extern void utDtile_rect_orient ( UTDPLANEPTR pl_p,UTDTILEPTR tile,UTDTILERECTPTR rect ) ;

extern UTDTILEPTR _utDtile_splitX ( UTDPLANEPTR plane, UTDTILEPTR tile, UTDTILEBYTES x ) ;

extern UTDTILEPTR _utDtile_splitX_left ( UTDPLANEPTR plane,UTDTILEPTR tile,UTDTILEBYTES x ) ;

extern UTDTILEPTR _utDtile_splitY ( UTDPLANEPTR plane,UTDTILEPTR tile, UTDTILEBYTES x ) ;

extern UTDTILEPTR _utDtile_splitY_bottom ( UTDPLANEPTR plane,UTDTILEPTR tile,UTDTILEBYTES y) ;

/* This version checks for tile orientation */
extern UTDTILEPTR utDtile_enumerate(UTDPLANEPTR plane,UTDTILERECTPTR rect,UTDTILEPTR tp) ;
extern UTDTILEPTR utDtile_enumerate_all(UTDPLANEPTR plane,UTDTILEPTR tp) ;

/* This version only does max horizontal enumeration */
extern UTDTILEPTR _utDtile_enumerate(UTDPLANEPTR plane,UTDTILERECTPTR rect,UTDTILEPTR tp) ;

extern UTDTILEPTR utDtile_find(UTDPLANEPTR plane, UTDTILEBYTES x, UTDTILEBYTES y) ;

extern void utDtile_delete(UTDPLANEPTR plane,UTDTILEPTR tp) ;

extern void utDtile_delete_area(UTDPLANEPTR plane,UTDTILERECTPTR area) ;

extern BOOL utDtile_check_int( DOUBLE float_number, BOOL verbose ) ;

extern void utDtile_rect_truncate_max(UTDTILERECTPTR area_p) ;

/* -----------------------------------------------------------------
 * Find the maximum of the geometries.  Setting first_flag to true
 * performs initialization.
----------------------------------------------------------------- */
extern void utDtile_rect_bbox(UTDTILERECTPTR bbox_p, UTDTILERECTPTR geom_p, 
                              BOOL first_flag) ;

/* -----------------------------------------------------------------
 * Returns TRUE if the two rectangles overlap.
----------------------------------------------------------------- */
extern BOOL utDtile_rect_overlaps(UTDTILERECTPTR rect1_p,UTDTILERECTPTR rect2_p) ;

/* -----------------------------------------------------------------
 * Returns TRUE if the tile rectangle is invalid.
----------------------------------------------------------------- */
extern BOOL utDtile_rect_invalid(UTDTILERECTPTR rect_p) ;

/* -----------------------------------------------------------------
 * Returns TRUE if the rectangle 2 is contained in rectangle 1.
----------------------------------------------------------------- */
extern BOOL utDtile_rect_contains(UTDTILERECTPTR rect1_p, UTDTILERECTPTR rect2_p) ;

/* -----------------------------------------------------------------
 * Returns the intersection of two rectangles.  If newrect is NULL,
 * then memory is created.
----------------------------------------------------------------- */
extern UTDTILERECTPTR _utDtile_rect_intersection(UTDTILERECTPTR rect1_p, 
                            UTDTILERECTPTR rect2_p,UTDTILERECTPTR newrect_p) ;

/* -----------------------------------------------------------------
 * Wrapper function for _utDtile_rect_intersection.   Forces creation of
 * new memory.
----------------------------------------------------------------- */
extern UTDTILERECTPTR utDtile_rect_intersection(UTDTILERECTPTR rect1_p, 
                                                UTDTILERECTPTR rect2_p) ;

/* -----------------------------------------------------------------
 * Returns true if point is inside or on the rectangle.
----------------------------------------------------------------- */
extern BOOL utDtile_rect_point_in_rect(UTDTILERECTPTR rect_p,DOUBLE x,DOUBLE y) ;
 
#ifdef DEBUG

extern INT utDtile_verify_tile( UTDPLANEPTR plane, UTDTILEPTR tp ) ;
extern INT utDtile_verify_plane(UTDPLANEPTR plane) ;
#endif /* DEBUG */

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* UTDTILE_H */
