/*-----------------------------------------------------------------
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
 FILE:         tile.c
 DESCRIPTION:  Corner stitching routines
               This file is based on tile.c and tile2.c
               included in version MAGIC 4.4 (Berkeley) 10/18/85
 CONTENTS:     This module contains the routines to manipulate tiles
 DATE:         October 1989  Adapted from Magic, misc bug fixes
 REVISIONS:    August  1992  Turn into Library routines
  -----------------------------------------------------------------*/
#include <utdconfig.h>
#include <utd/base.h>
#include <utd/debug.h>
#include <utd/mempools.h>
#include <utd/rint.h>
#include <utd/tile.h>

#ifndef TEST
/* ********************** TYPE DEFINITIONS ************************* */
#define TILE_THRESHOLD 		10000
#define TILE_FREE_MARKER 	DINT_MIN

/* define macros for easier reading of the code */
#define comp_f( a, b )  ( (*comp_func)(a,b) )
#define ROUND_TO_INT(x) ((x) > 0.0 ? (INT)((x)+0.009999) :(INT) ((x)-0.009999) )

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static void free_tile(UTDTILEPTR tile_p) ;
static INT tile_default_compare(VOIDPTR d1, VOIDPTR d2) ;
static void _utDtile_free_tile( UTDPLANEPTR plane_p, UTDTILEPTR tp ) ;
static UTDTILEPTR _utDtile_alloc_tile( UTDPLANEPTR plane_p ) ;
#ifdef DEBUG
#endif /* DEBUG */

/*
 * Rectangle that defines the maximum extent of any plane.
 * No tile created by the user should ever extend outside of
 * this area.
 *
 * TileRect TiPlaneRect = { MINFINITY+2, MINFINITY+2, INFINITY-2, INFINITY-2 };
 *
 * NOTE: the _utDtilexxx routines are primitives and do not change the
 *       orientation of the tile plane (for example to vertical).
 *       Without the leading _ the routines check for orientation.
 *
 */

/*
 * --------------------------------------------------------------------
 *
 * _utDtile_init
 *
 * Allocate and initialize a new tile plane.
 *
 * Results:
 *	A newly allocated Plane with all corner stitches set
 *	appropriately.
 *
 * Side effects:
 *	Adjusts the corner stitches of the Tile supplied to
 *	point to the appropriate bounding tile in the newly
 *	created Plane.
 *
 * Replaces utDtile_init function in order to support efficient memory
 * allocation.
 *
 * --------------------------------------------------------------------
 */

UTDPLANEPTR _utDtile_init(INT (*compare_func)(void *,void *),VOIDPTR data,
                            INT expected_size, UTDPLANE_ORIENT_T orientation)
{
  UTDPLANEPTR newplane;		/* newly created plane */
  UTDTILEPTR newTile;   		/* initial tile */
  UTDTILEPTR infinityTile ; 	/* dummy space holder tile */

  /* create a new plane */  
  newplane = UTDMALLOC ( 1, UTDPLANE ) ;
  if( expected_size >= 0 ){
    newplane->pool_id = UTDPOOL_INIT(expected_size, UTDTILE) ;
  } else {
    newplane->pool_id = -1 ;
  }
  newplane->pool_size = expected_size ;
  if(!(compare_func)){
    compare_func = tile_default_compare ;
  }
  newplane->compare_func = compare_func ;
  newplane->data_check = TRUE ;
  newplane->max_vertical = orientation ;

  /* create plane border tiles */
  newplane->pl_top =    _utDtile_alloc_tile( newplane ) ;
  newplane->pl_right =  _utDtile_alloc_tile( newplane ) ;
  newplane->pl_bottom = _utDtile_alloc_tile( newplane ) ;
  newplane->pl_left =   _utDtile_alloc_tile( newplane ) ;

  /* set border tile data */
  newplane->pl_top->data = data ;
  newplane->pl_right->data = data ; 
  newplane->pl_bottom->data = data ;
  newplane->pl_left->data = data ;
  
  /*
   * Since the lower left coordinates of the UTDTILE_TR and UTDTILE_RT
   * stitches of a tile are used to determine its upper right,
   * we must give the boundary tiles a meaningful UTDTILE_TR and UTDTILE_RT.
   * To make certain that these tiles don't have zero width
   * or height, we use a dummy tile at (INFINITY+1,INFINITY+1).
   */
  
  /* create dummy infinity + 1 tile */    
  infinityTile = _utDtile_alloc_tile( newplane ) ;
  UTDTILE_LEFT(infinityTile) = UTDTILE_INFINITY + 1 ;
  UTDTILE_BOTTOM(infinityTile) = UTDTILE_INFINITY + 1 ;
  
  /* create initial user tile */    
  newTile = _utDtile_alloc_tile( newplane ) ;
  newTile->data = data ;
  UTDTILE_LEFT ( newTile ) = UTDTILE_MINFINITY ;
  UTDTILE_BOTTOM ( newTile ) = UTDTILE_MINFINITY ;

  /* stitch new tile into the center of the border tiles */
  UTDTILE_RT ( newTile ) = newplane->pl_top ;
  UTDTILE_TR ( newTile ) = newplane->pl_right ;
  UTDTILE_LB ( newTile ) = newplane->pl_bottom ;
  UTDTILE_BL ( newTile ) = newplane->pl_left ;
  
  /* create bottom edge of plane */
  UTDTILE_LEFT(newplane->pl_bottom) = UTDTILE_MINFINITY - 1 ;
  UTDTILE_BOTTOM(newplane->pl_bottom) = UTDTILE_MINFINITY - 1 ;
  UTDTILE_RT(newplane->pl_bottom) = newTile ;
  UTDTILE_TR(newplane->pl_bottom) = newplane->pl_right ;
  UTDTILE_LB(newplane->pl_bottom) = UTDTILE_BAD ;
  UTDTILE_BL(newplane->pl_bottom) = newplane->pl_left ;
  
  /* create top edge of plane */
  UTDTILE_LEFT(newplane->pl_top) = UTDTILE_MINFINITY - 1 ;
  UTDTILE_BOTTOM(newplane->pl_top) = UTDTILE_INFINITY ;
  UTDTILE_RT(newplane->pl_top) = infinityTile ;
  UTDTILE_TR(newplane->pl_top) = newplane->pl_right ;
  UTDTILE_LB(newplane->pl_top) = newTile ;
  UTDTILE_BL(newplane->pl_top) = newplane->pl_left ;
  
  UTDTILE_LEFT(newplane->pl_left) = UTDTILE_MINFINITY - 1 ;
  UTDTILE_BOTTOM(newplane->pl_left) = UTDTILE_MINFINITY - 1 ;
  UTDTILE_RT(newplane->pl_left) = newplane->pl_top ;
  UTDTILE_TR(newplane->pl_left) = newTile ;
  UTDTILE_LB(newplane->pl_left) = newplane->pl_bottom ;
  UTDTILE_BL(newplane->pl_left) = UTDTILE_BAD ;
  
  UTDTILE_LEFT(newplane->pl_right) = UTDTILE_INFINITY;
  UTDTILE_BOTTOM(newplane->pl_right) = UTDTILE_MINFINITY - 1 ;
  UTDTILE_RT(newplane->pl_right) = newplane->pl_top ;
  UTDTILE_TR(newplane->pl_right) = infinityTile ;
  UTDTILE_LB(newplane->pl_right) = newplane->pl_bottom ;
  UTDTILE_BL(newplane->pl_right) = newTile ;
  
  newplane->pl_hint = newTile;
  return (newplane);
} /* end _utDtile_init() */

static UTDTILEPTR _utDtile_alloc_tile( UTDPLANEPTR plane_p )
{
  UTDTILEPTR tp ;				/* tile without time stamp */

  tp = UTDPOOL_CALLOC( plane_p->pool_id, UTDTILE ) ;
  return( tp ) ;
} /* end _utDtile_alloc_tile() */

static void _utDtile_free_tile( UTDPLANEPTR plane_p, UTDTILEPTR tp )
{

    UTDPOOL_FREE_ITEM(plane_p->pool_id,tp) ;
} /* end _utDtile_free_tile() */


static void free_tile(UTDTILEPTR tile_p)
{
   UTDFREE(tile_p) ;
} /* end free_tile() */


/*
 * --------------------------------------------------------------------
 *
 * utDtile_empty
 *
 * Free the storage associated with a tile plane.
 * It is easier to free current structure and create a new one.
 * 
 *
 * --------------------------------------------------------------------
 */

void utDtile_empty (UTDPLANEPTR plane)
{
  UTDTILERECT r ;				/* search for tiles */
  INT (*compare_func)(void *,void *) ;	/* compare function variable */
  VOIDPTR data ;			/* default data */
  UTDPLANEPTR new_plane ;			/* newly created plane */

  compare_func = plane->compare_func ;
  data = plane->pl_top->data ;


  if( plane->pool_id < 0 ){
#ifdef LATER
    /* -----------------------------------------------------------------
     * Now create a new plane.
    ----------------------------------------------------------------- */
    new_plane = _utDtile_init( compare_func, data, plane->pool_size, plane->max_vertical ) ;

    /* -----------------------------------------------------------------
     * Free old structure.
    ----------------------------------------------------------------- */
    freeDeck = Ydeck_init () ;
   
    /* get all tiles in the plane */
    r.LLX = r.LLY = UTDTILE_MINFINITY ;
    r.URX = r.URY = UTDTILE_INFINITY ;
    utDtile_areaFunction ( plane, &r, build_free_deck, NULL, freeDeck ) ;

    /* free the deck and all tiles it contains */
    Ydeck_free ( freeDeck, (Ydelete)free_tile ) ;
#endif /* LATER */

    /* free dummy infinity + 1 tile */
    UTDFREE ( plane->pl_top->ti_rt ) ;
    
    /* free border tiles */
    UTDFREE ( plane->pl_left ) ;
    UTDFREE ( plane->pl_right ) ;
    UTDFREE ( plane->pl_top ) ;
    UTDFREE ( plane->pl_bottom ) ;
  } else {
    UTDPOOL_FREE_POOL( plane->pool_id ) ;
    plane->pool_id = -1 ;
    new_plane = _utDtile_init( compare_func, data, plane->pool_size, plane->max_vertical ) ;
  }

  /* -----------------------------------------------------------------
   * Copy all of the new plane data over.
  ----------------------------------------------------------------- */
  new_plane->data_check = plane->data_check ;
  TWtile_userdata(new_plane) = TWtile_userdata( plane ) ;
  *plane = *new_plane ;
  
  /* free the plane */
  UTDFREE ( new_plane ) ;

} /* end utDtile_empty() */

/*
 * --------------------------------------------------------------------
 *
 * utDtile_free
 *
 * Free the storage associated with a tile plane.
 * Only the plane itself and its four border tiles are deallocated.
 *
 * --------------------------------------------------------------------
 */

void utDtile_free(UTDPLANEPTR plane)
{
  UTDTILERECT r ;

  if( plane->pool_id < 0 ){
#ifdef LATER
    freeDeck = Ydeck_init() ;
   
    /* get all tiles in the plane */
    r.LLX = r.LLY = UTDTILE_MINFINITY ;
    r.URX = r.URY = UTDTILE_INFINITY ;
    _utDtile_areaFunction ( plane, &r, build_free_deck, NULL, freeDeck ) ;

    /* free the deck and all tiles it contains */
    Ydeck_free ( freeDeck, (Ydelete)free_tile ) ;
#endif /* LATER */

    /* free dummy infinity + 1 tile */
    UTDFREE ( plane->pl_top->ti_rt ) ;
    
    /* free border tiles */
    UTDFREE ( plane->pl_left ) ;
    UTDFREE ( plane->pl_right ) ;
    UTDFREE ( plane->pl_top ) ;
    UTDFREE ( plane->pl_bottom ) ;
  } else {
    UTDPOOL_FREE_POOL( plane->pool_id ) ;
    plane->pool_id = -1 ;
  }
  
  /* free plane */
  UTDFREE ( plane ) ;
} /* end utDtile_free() */

/*
 * --------------------------------------------------------------------
 *
 * utDtile_rect
 *
 * Convert a tile to a rectangle.
 *
 * --------------------------------------------------------------------
 */

void utDtile_rect(UTDTILEPTR tile, UTDTILERECTPTR rect)
                   	/* Tile whose bounding box is to be stored in *rect */
                       	/* Pointer to rect to be set to bounding box */
{
  rect->r_xbot = UTDTILE_LEFT(tile);
  rect->r_xtop = UTDTILE_RIGHT(tile);
  rect->r_ybot = UTDTILE_BOTTOM(tile);
  rect->r_ytop = UTDTILE_TOP(tile);
} /* end utDtile_rect() */

/*
 * --------------------------------------------------------------------
 *
 * utDtile_rect_orient
 *
 * Convert a tile to a rectangle based on plane orientation.
 *
 * --------------------------------------------------------------------
 */

void utDtile_rect_orient(UTDPLANEPTR plane_p, UTDTILEPTR tile, UTDTILERECTPTR rect)
                   	/* Tile whose bounding box is to be stored in *rect */
                       	/* Pointer to rect to be set to bounding box */
{
  if( plane_p->max_vertical ){
    rect->r_xbot = UTDTILE_BOTTOM(tile);
    rect->r_xtop = UTDTILE_TOP(tile);
    rect->r_ybot = UTDTILE_LEFT(tile);
    rect->r_ytop = UTDTILE_RIGHT(tile);
  } else {
    rect->r_xbot = UTDTILE_LEFT(tile);
    rect->r_xtop = UTDTILE_RIGHT(tile);
    rect->r_ybot = UTDTILE_BOTTOM(tile);
    rect->r_ytop = UTDTILE_TOP(tile);
  }
} /* end utDtile_rect_orient() */

/* -----------------------------------------------------------------
 * Find the maximum of the geometries.  Setting first_flag to true
 * performs initialization.
----------------------------------------------------------------- */
void utDtile_rect_bbox(UTDTILERECTPTR bbox_p, UTDTILERECTPTR geom_p, BOOL first_flag)
{
    if( first_flag ){
      *bbox_p = *geom_p ;
    } else {
      if( geom_p->UTDLLX < bbox_p->UTDLLX ){
	bbox_p->UTDLLX = geom_p->UTDLLX ;
      }
      if( geom_p->UTDLLY < bbox_p->UTDLLY ){
	bbox_p->UTDLLY = geom_p->UTDLLY ;
      }
      if( geom_p->UTDURX > bbox_p->UTDURX ){
	bbox_p->UTDURX = geom_p->UTDURX ;
      }
      if( geom_p->UTDURY > bbox_p->UTDURY ){
	bbox_p->UTDURY = geom_p->UTDURY ;
      }
    }
} /* end utDtile_rect_bbox() */

/* -----------------------------------------------------------------
 * Returns TRUE if the two rectangles overlap.
----------------------------------------------------------------- */
BOOL utDtile_rect_overlaps(UTDTILERECTPTR rect1_p, UTDTILERECTPTR rect2_p)
{
  DOUBLE top, bottom, left, right ;
  
  top = MIN( rect1_p->UTDURY, rect2_p->UTDURY ) ;
  bottom = MAX( rect1_p->UTDLLY, rect2_p->UTDLLY ) ;
  if (top <= bottom){
    return(FALSE) ;
  }
  
  right = MIN( rect1_p->UTDURX, rect2_p->UTDURX ) ;
  left = MAX( rect1_p->UTDLLX, rect2_p->UTDLLX ) ;
  
  if (left >= right){
    return(FALSE) ;
  }
  return(TRUE) ;

} /* end utDtile_rect_overlaps() */


/* -----------------------------------------------------------------
 * Returns TRUE if the tile rectangle is invalid.
----------------------------------------------------------------- */
BOOL utDtile_rect_invalid(UTDTILERECTPTR rect_p)
{
    if( (rect_p->UTDLLX < UTDTILE_MIN) || (rect_p->UTDLLX > UTDTILE_MAX) ){
      return(TRUE) ;
    }
    if( (rect_p->UTDLLY < UTDTILE_MIN) || (rect_p->UTDLLY > UTDTILE_MAX) ){
      return(TRUE) ;
    }
    if( (rect_p->UTDURX < UTDTILE_MIN) || (rect_p->UTDURX > UTDTILE_MAX) ){
      return(TRUE) ;
    }
    if( (rect_p->UTDURY < UTDTILE_MIN) || (rect_p->UTDURY > UTDTILE_MAX) ){
      return(TRUE) ;
    }
    return(FALSE) ;
} /* end utDtile_rect_invalid() */


/* -----------------------------------------------------------------
 * Returns TRUE if the rectangle 2 is contained in rectangle 1.
----------------------------------------------------------------- */
BOOL utDtile_rect_contains(UTDTILERECTPTR rect1_p, UTDTILERECTPTR rect2_p)
{
  if (rect2_p->UTDURY > rect1_p->UTDURY){
    return(FALSE) ;
  }
  
  if (rect2_p->UTDLLY < rect1_p->UTDLLY){
    return(FALSE) ;
  }
  
  if (rect2_p->UTDLLX < rect1_p->UTDLLX){
    return(FALSE) ;
  }
  
  if (rect2_p->UTDURX > rect1_p->UTDURX){
    return(FALSE) ;
  }
  return(TRUE) ;
} /* utDtile_rect_contains() */

/* -----------------------------------------------------------------
 * Returns the intersection of two rectangles.  If newrect is NULL,
 * then memory is created.
----------------------------------------------------------------- */
UTDTILERECTPTR _utDtile_rect_intersection(UTDTILERECTPTR rect1_p, UTDTILERECTPTR rect2_p,UTDTILERECTPTR newrect_p)
{
  DOUBLE top, bottom, left, right ;
  
  top = MIN( rect1_p->UTDURY, rect2_p->UTDURY ) ;
  bottom = MAX( rect1_p->UTDLLY, rect2_p->UTDLLY ) ;
  if (top <= bottom ){
    return( NULL) ;
  }
  
  right = MIN( rect1_p->UTDURX, rect2_p->UTDURX) ;
  left = MAX( rect1_p->UTDLLX, rect2_p->UTDLLX ) ;
  
  if (left >= right){
    return(NULL) ;
  }
  
  if(!(newrect_p)){
    newrect_p = UTDMALLOC(1, UTDTILERECT) ;
  }
  newrect_p->UTDLLX = left ;
  newrect_p->UTDURX = right ;
  newrect_p->UTDLLY = bottom ;
  newrect_p->UTDURY = top ;
  return( newrect_p) ;
} /* end _utDtile_rect_intersection() */

/* -----------------------------------------------------------------
 * Wrapper function for _utDtile_rect_intersection.   Forces creation of
 * new memory.
----------------------------------------------------------------- */
UTDTILERECTPTR utDtile_rect_intersection(UTDTILERECTPTR rect1_p, UTDTILERECTPTR rect2_p)
{
  UTDTILERECTPTR newrect_p ;

  newrect_p = _utDtile_rect_intersection(rect1_p,rect2_p,NULL) ;
  return( newrect_p) ;
} /* end utDtile_rect_intersection() */


/* -----------------------------------------------------------------
 * Returns true if point is inside or on the rectangle.
----------------------------------------------------------------- */
BOOL utDtile_rect_point_in_rect(UTDTILERECTPTR rect_p, DOUBLE x, DOUBLE y)
{ 
  if ((x < rect_p->UTDLLX) || (x > rect_p->UTDURX) || 
      (y < rect_p->UTDLLY) || (y > rect_p->UTDURY)){
    return( FALSE ) ;
  }
  return(TRUE) ;
} /* end utDtile_rect_point_in_rect() */

/* -----------------------------------------------------------------
 * Given a point and a plane find the tile.
----------------------------------------------------------------- */
UTDTILEPTR utDtile_find(UTDPLANEPTR plane_p, UTDTILEBYTES x, UTDTILEBYTES y)
{
  UTDTILEPTR tp ;
  UTDTILEPOINT start;

  if( plane_p->max_vertical ){
    start.p_x = y ;
    start.p_y = x ;
  } else {
    start.p_x = x ;
    start.p_y = y ;
  }
  tp = plane_p->pl_hint ;
  UTDTILE_GOTOPOINT(tp, &start);
  return(tp) ;
} /* end utDtile_find() */

/*-----------------------------
  -----------------------------*/
UTDTILEPTR utDtile_gotoPoint(UTDTILEPTR tp, UTDTILEPOINTPTR point)
{
  UTDTILE_GOTOPOINT(tp,point);
  return(tp);
} /* end utDtile_gotoPoint() */

/*
 * --------------------------------------------------------------------
 *
 * _utDtile_splitX
 *
 * Given a tile and an X coordinate, split the tile into two
 * along a line running vertically through the given coordinate.
 *
 * Results:
 *	Returns the new tile resulting from the splitting, which
 *	is the tile occupying the right-hand half of the original
 *	tile.
 *
 * Side effects:
 *	Modifies the corner stitches in the database to reflect
 *	the presence of two tiles in place of the original one.
 *
 * --------------------------------------------------------------------
 */

UTDTILEPTR _utDtile_splitX(UTDPLANEPTR plane, UTDTILEPTR tile, UTDTILEBYTES x)
                   	/* Tile to be split */
           		/* X coordinate of split */
{
  UTDTILEPTR newtile;
  UTDTILEPTR tp;
  
  ASSERTNFAULT(x > UTDTILE_LEFT(tile) && x < UTDTILE_RIGHT(tile),"TiSplitX","bogus split");
  
  D("TiSplitX",
    fprintf(stderr,"TiSplitX at %d\n",(INT)x);
    );
  
  newtile = _utDtile_alloc_tile( plane ) ;

  UTDTILE_LEFT(newtile) = x;
  UTDTILE_BOTTOM(newtile) = UTDTILE_BOTTOM(tile);
  UTDTILE_BL(newtile) = tile;
  UTDTILE_TR(newtile) = UTDTILE_TR(tile);
  UTDTILE_RT(newtile) = UTDTILE_RT(tile);
  newtile->data = tile->data ;
  
  /*
   * Adjust corner stitches along the right edge
   */
  
  for (tp = UTDTILE_TR(tile); UTDTILE_BL(tp) == tile; tp = UTDTILE_LB(tp))
    UTDTILE_BL(tp) = newtile;
  UTDTILE_TR(tile) = newtile;
  
  /*
   * Adjust corner stitches along the top edge
   */
  
  for (tp = UTDTILE_RT(tile); UTDTILE_LEFT(tp) >= x; tp = UTDTILE_BL(tp))
    UTDTILE_LB(tp) = newtile;
  UTDTILE_RT(tile) = tp;
  
  /*
   * Adjust corner stitches along the bottom edge
   */
  
  for (tp = UTDTILE_LB(tile); UTDTILE_RIGHT(tp) <= x; tp = UTDTILE_TR(tp))
    /* nothing */;
  UTDTILE_LB(newtile) = tp;
  while (UTDTILE_RT(tp) == tile)
    {
      UTDTILE_RT(tp) = newtile;
      tp = UTDTILE_TR(tp);
    }
  
  D("TiSplitX",
    fprintf(stderr,"TiSplitX newtiles\n");
    );
  
  return (newtile);
} /* end _utDtile_splitX() */

/*
 * --------------------------------------------------------------------
 *
 * _utDtile_splitY --
 *
 * Given a tile and a Y coordinate, split the tile into two
 * along a horizontal line running through the given coordinate.
 *
 * Results:
 *	Returns the new tile resulting from the splitting, which
 *	is the tile occupying the top half of the original
 *	tile.
 *
 * Side effects:
 *	Modifies the corner stitches in the database to reflect
 *	the presence of two tiles in place of the original one.
 *
 * --------------------------------------------------------------------
 */

UTDTILEPTR _utDtile_splitY (UTDPLANEPTR plane,UTDTILEPTR tile, UTDTILEBYTES y)
                   	/* Tile to be split */
           		/* Y coordinate of split */
{
  UTDTILEPTR newtile;
  UTDTILEPTR tp;
  
  ASSERTNFAULT(y > UTDTILE_BOTTOM(tile) && y < UTDTILE_TOP(tile), "TiSplitY","bogus split");
  
  D("TiSplitY",
    fprintf(stderr,"TiSplitY at %d \n",(INT)y);
    );
  
  newtile = _utDtile_alloc_tile( plane ) ;
  
  UTDTILE_LEFT(newtile) = UTDTILE_LEFT(tile);
  UTDTILE_BOTTOM(newtile) = y;
  UTDTILE_LB(newtile) = tile;
  UTDTILE_RT(newtile) = UTDTILE_RT(tile);
  UTDTILE_TR(newtile) = UTDTILE_TR(tile);
  newtile->data = tile->data ;
  
  /*
   * Adjust corner stitches along top edge
   */
  
  for (tp = UTDTILE_RT(tile); UTDTILE_LB(tp) == tile; tp = UTDTILE_BL(tp))
    UTDTILE_LB(tp) = newtile;
  UTDTILE_RT(tile) = newtile;
  
  /*
   * Adjust corner stitches along right edge
   */
  
  for (tp = UTDTILE_TR(tile); UTDTILE_BOTTOM(tp) >= y; tp = UTDTILE_LB(tp))
    UTDTILE_BL(tp) = newtile;
  UTDTILE_TR(tile) = tp;
  
  /*
   * Adjust corner stitches along left edge
   */
  
  for (tp = UTDTILE_BL(tile); UTDTILE_TOP(tp) <= y; tp = UTDTILE_RT(tp))
    /* nothing */;
  UTDTILE_BL(newtile) = tp;
  while (UTDTILE_TR(tp) == tile)
    {
      UTDTILE_TR(tp) = newtile;
      tp = UTDTILE_RT(tp);
    }
  
  D("TiSplitY",
    fprintf(stderr,"TiSplitY newtiles\n");
    );
  
  return (newtile);
} /* end _utDtile_splitY() */

/*
 * --------------------------------------------------------------------
 *
 * _utDtile_splitX_left
 *
 * Given a tile and an X coordinate, split the tile into two
 * along a line running vertically through the given coordinate.
 * Intended for use when plowing to the left.
 *
 * Results:
 *	Returns the new tile resulting from the splitting, which
 *	is the tile occupying the left-hand half of the original
 *	tile.
 *
 * Side effects:
 *	Modifies the corner stitches in the database to reflect
 *	the presence of two tiles in place of the original one.
 *
 * --------------------------------------------------------------------
 */

UTDTILEPTR _utDtile_splitX_left (UTDPLANEPTR plane,UTDTILEPTR tile, UTDTILEBYTES x)
                   	/* Tile to be split */
           		/* X coordinate of split */
{
  UTDTILEPTR newtile;
  UTDTILEPTR tp;
  
  ASSERTNFAULT(x > UTDTILE_LEFT(tile) && x < UTDTILE_RIGHT(tile), "TiSplitX","bogus split");
  
  D("TiSplitX_Left",
    fprintf(stderr,"TiSplitX_Left at %d\n",(INT)x);
    );
  
  newtile = _utDtile_alloc_tile( plane ) ;
  
  UTDTILE_LEFT(newtile) = UTDTILE_LEFT(tile);
  UTDTILE_LEFT(tile) = x;
  UTDTILE_BOTTOM(newtile) = UTDTILE_BOTTOM(tile);
  
  UTDTILE_BL(newtile) = UTDTILE_BL(tile);
  UTDTILE_LB(newtile) = UTDTILE_LB(tile);
  UTDTILE_TR(newtile) = tile;
  UTDTILE_BL(tile) = newtile;
  newtile->data = tile->data ;
  
  /* Adjust corner stitches along the left edge */
  for (tp = UTDTILE_BL(newtile); UTDTILE_TR(tp) == tile; tp = UTDTILE_RT(tp))
    UTDTILE_TR(tp) = newtile;
  
  /* Adjust corner stitches along the top edge */
  for (tp = UTDTILE_RT(tile); UTDTILE_LEFT(tp) >= x; tp = UTDTILE_BL(tp))
    /* nothing */;
  UTDTILE_RT(newtile) = tp;
  for ( ; UTDTILE_LB(tp) == tile; tp = UTDTILE_BL(tp))
    UTDTILE_LB(tp) = newtile;
  
  /* Adjust corner stitches along the bottom edge */
  for (tp = UTDTILE_LB(tile); UTDTILE_RIGHT(tp) <= x; tp = UTDTILE_TR(tp))
    UTDTILE_RT(tp) = newtile;
  UTDTILE_LB(tile) = tp;
  
  D("TiSplitX_Left",
    fprintf(stderr,"TiSplitX_Left newtile\n");
    );
  
  return (newtile);
} /* end _utDtile_splitX_left () */

/*
 * --------------------------------------------------------------------
 *
 * _utDtile_splitY_bottom --
 *
 * Given a tile and a Y coordinate, split the tile into two
 * along a horizontal line running through the given coordinate.
 * Used when plowing down.
 *
 * Results:
 *	Returns the new tile resulting from the splitting, which
 *	is the tile occupying the bottom half of the original
 *	tile.
 *
 * Side effects:
 *	Modifies the corner stitches in the database to reflect
 *	the presence of two tiles in place of the original one.
 *
 * --------------------------------------------------------------------
 */

UTDTILEPTR _utDtile_splitY_bottom (UTDPLANEPTR plane, UTDTILEPTR tile, UTDTILEBYTES y)
                   	/* Tile to be split */
           		/* Y coordinate of split */
{
  UTDTILEPTR newtile;
  UTDTILEPTR tp;
  
  ASSERTNFAULT(y > UTDTILE_BOTTOM(tile) && y < UTDTILE_TOP(tile), "TiSplitY","bogus split");
  
  D("TiSplitY_Bottom",
    fprintf(stderr,"TiSplitY_Bottom at %d\n",(INT)y);
    );
  
  newtile = _utDtile_alloc_tile( plane ) ;
  
  UTDTILE_LEFT(newtile) = UTDTILE_LEFT(tile);
  UTDTILE_BOTTOM(newtile) = UTDTILE_BOTTOM(tile);
  UTDTILE_BOTTOM(tile) = y;
  
  UTDTILE_RT(newtile) = tile;
  UTDTILE_LB(newtile) = UTDTILE_LB(tile);
  UTDTILE_BL(newtile) = UTDTILE_BL(tile);
  UTDTILE_LB(tile) = newtile;
  newtile->data = tile->data ;
  
  /* Adjust corner stitches along bottom edge */
  for (tp = UTDTILE_LB(newtile); UTDTILE_RT(tp) == tile; tp = UTDTILE_TR(tp))
    UTDTILE_RT(tp) = newtile;
  
  /* Adjust corner stitches along right edge */
  for (tp = UTDTILE_TR(tile); UTDTILE_BOTTOM(tp) >= y; tp = UTDTILE_LB(tp))
    /* nothing */;
  UTDTILE_TR(newtile) = tp;
  for ( ; UTDTILE_BL(tp) == tile; tp = UTDTILE_LB(tp))
    UTDTILE_BL(tp) = newtile;
  
  /* Adjust corner stitches along left edge */
  for (tp = UTDTILE_BL(tile); UTDTILE_TOP(tp) <= y; tp = UTDTILE_RT(tp))
    UTDTILE_TR(tp) = newtile;
  UTDTILE_BL(tile) = tp;
  
  D("TiSplitY_Bottom",
    fprintf(stderr,"TiSplitY_Bottom newtile\n");
    );
  
  return (newtile);
} /* end _utDtile_splitY_bottom() */

/*
 * --------------------------------------------------------------------
 *
 * _utDtile_joinX --
 *
 * Given two tiles sharing an entire common vertical edge, replace
 * them with a single tile occupying the union of their areas.
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	The first tile is simply relinked to reflect its new size.
 *	The second tile is deallocated.	 Corner stitches in the
 *	neighboring tiles are updated to reflect the new structure.
 *	If the hint tile pointer in the supplied plane pointed to
 *	the second tile, it is adjusted to point instead to the
 *	first.
 *
 * --------------------------------------------------------------------
 */

void _utDtile_joinX (UTDPLANEPTR plane, UTDTILEPTR tile1, UTDTILEPTR tile2)
                     	/* Plane in which hint tile is updated */
                    	/* First tile, remains allocated after call */
                    	/* Second tile, deallocated by call */
{
  UTDTILEPTR tp;
  
  /*
   * Basic algorithm:
   *
   *	Update all the corner stitches in the neighbors of tile2
   *	to point to tile1.
   *	Update the corner stitches of tile1 along the shared edge
   *	to be those of tile2.
   *	Change the bottom or left coordinate of tile1 if appropriate.
   *	Deallocate tile2.
   */
  
  ASSERTNFAULT(UTDTILE_BOTTOM(tile1)==UTDTILE_BOTTOM(tile2) && UTDTILE_TOP(tile1)==UTDTILE_TOP(tile2),
	       "_utDtile_joinX","bogus join");
  ASSERTNFAULT(UTDTILE_LEFT(tile1)==UTDTILE_RIGHT(tile2) || UTDTILE_RIGHT(tile1)==UTDTILE_LEFT(tile2),
	       "_utDtile_joinX","bogus join");
  
  D("_utDtile_joinX",
    fprintf(stderr,"_utDtile_joinX\n");
    );
  
  /*
   * Update stitches along top of tile
   */
  
  for (tp = UTDTILE_RT(tile2); UTDTILE_LB(tp) == tile2; tp = UTDTILE_BL(tp))
    UTDTILE_LB(tp) = tile1;
  
  /*
   * Update stitches along bottom of tile
   */
  
  for (tp = UTDTILE_LB(tile2); UTDTILE_RT(tp) == tile2; tp = UTDTILE_TR(tp))
    UTDTILE_RT(tp) = tile1;
  
  /*
   * Update stitches along either left or right, depending
   * on relative position of the two tiles.
   */
  
  ASSERTNFAULT(UTDTILE_LEFT(tile1) != UTDTILE_LEFT(tile2), "_utDtile_joinX", "bogus join");
  if (UTDTILE_LEFT(tile1) < UTDTILE_LEFT(tile2))
    {
      for (tp = UTDTILE_TR(tile2); UTDTILE_BL(tp) == tile2; tp = UTDTILE_LB(tp))
	UTDTILE_BL(tp) = tile1;
      UTDTILE_TR(tile1) = UTDTILE_TR(tile2);
      UTDTILE_RT(tile1) = UTDTILE_RT(tile2);
    }
  else
    {
      for (tp = UTDTILE_BL(tile2); UTDTILE_TR(tp) == tile2; tp = UTDTILE_RT(tp))
	UTDTILE_TR(tp) = tile1;
      UTDTILE_BL(tile1) = UTDTILE_BL(tile2);
      UTDTILE_LB(tile1) = UTDTILE_LB(tile2);
      UTDTILE_LEFT(tile1) = UTDTILE_LEFT(tile2);
    }
  
  D("_utDtile_joinX",
    fprintf(stderr,"JoinX save and scrap tiles\n");
    );
  
  if (plane->pl_hint == tile2)
    plane->pl_hint = tile1;
  UTDTILE_LEFT(tile2) = TILE_FREE_MARKER ;
  UTDTILE_BOTTOM(tile2) = TILE_FREE_MARKER ;
  _utDtile_free_tile( plane, tile2 ) ;

} /* end _utDtile_joinX() */

/*
 * --------------------------------------------------------------------
 *
 * _utDtile_joinY --
 *
 * Given two tiles sharing an entire common horizontal edge, replace
 * them with a single tile occupying the union of their areas.
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	The first tile is simply relinked to reflect its new size.
 *	The second tile is deallocated.	 Corner stitches in the
 *	neighboring tiles are updated to reflect the new structure.
 *	If the hint tile pointer in the supplied plane pointed to
 *	the second tile, it is adjusted to point instead to the
 *	first.
 *
 * --------------------------------------------------------------------
 */

void _utDtile_joinY (UTDPLANEPTR plane, UTDTILEPTR tile1, UTDTILEPTR tile2)
                     	/* Plane in which hint tile is updated */
                    	/* First tile, remains allocated after call */
                    	/* Second tile, deallocated by call */
{
  UTDTILEPTR tp;
  
  /*
   * Basic algorithm:
   *
   *	Update all the corner stitches in the neighbors of tile2
   *	to point to tile1.
   *	Update the corner stitches of tile1 along the shared edge
   *	to be those of tile2.
   *	Change the bottom or left coordinate of tile1 if appropriate.
   *	Deallocate tile2.
   */
  
  ASSERTNFAULT(UTDTILE_LEFT(tile1)==UTDTILE_LEFT(tile2) && UTDTILE_RIGHT(tile1)==UTDTILE_RIGHT(tile2),
	       "TiJoinY","bogus join");
  ASSERTNFAULT(UTDTILE_TOP(tile1)==UTDTILE_BOTTOM(tile2) || UTDTILE_BOTTOM(tile1)==UTDTILE_TOP(tile2),
	       "TiJoinY","bogus join");
  
  D("TiJoinY",
    fprintf(stderr,"TiJoinY\n");
    );
  
  /*
   * Update stitches along right of tile.
   */
  
  for (tp = UTDTILE_TR(tile2); UTDTILE_BL(tp) == tile2; tp = UTDTILE_LB(tp))
    UTDTILE_BL(tp) = tile1;
  
  /*
   * Update stitches along left of tile.
   */
  
  for (tp = UTDTILE_BL(tile2); UTDTILE_TR(tp) == tile2; tp = UTDTILE_RT(tp))
    UTDTILE_TR(tp) = tile1;
  
  /*
   * Update stitches along either top or bottom, depending
   * on relative position of the two tiles.
   */
  
  ASSERTNFAULT(UTDTILE_BOTTOM(tile1) != UTDTILE_BOTTOM(tile2), "TiJoinY", "bogus join");
  if (UTDTILE_BOTTOM(tile1) < UTDTILE_BOTTOM(tile2))
    {
      for (tp = UTDTILE_RT(tile2); UTDTILE_LB(tp) == tile2; tp = UTDTILE_BL(tp))
	UTDTILE_LB(tp) = tile1;
      UTDTILE_RT(tile1) = UTDTILE_RT(tile2);
      UTDTILE_TR(tile1) = UTDTILE_TR(tile2);
    }
  else
    {
      for (tp = UTDTILE_LB(tile2); UTDTILE_RT(tp) == tile2; tp = UTDTILE_TR(tp))
	UTDTILE_RT(tp) = tile1;
      UTDTILE_LB(tile1) = UTDTILE_LB(tile2);
      UTDTILE_BL(tile1) = UTDTILE_BL(tile2);
      UTDTILE_BOTTOM(tile1) = UTDTILE_BOTTOM(tile2);
    }
  
  D("TiJoinY",
    fprintf(stderr,"JoinY save and scrap tiles\n");
    );
  
  if (plane->pl_hint == tile2)
    plane->pl_hint = tile1;
  UTDTILE_LEFT(tile2) = TILE_FREE_MARKER ;
  UTDTILE_BOTTOM(tile2) = TILE_FREE_MARKER ;
  _utDtile_free_tile( plane, tile2 ) ;

} /* end _utDtile_joinY() */

/* This macro seems to buy us about 15% in speed */
#define	TISPLITX(plane, res, otile, xcoord) \
{ \
  UTDTILEPTR xtile = otile, xxnew, xp; \
  UTDTILEBYTES x = xcoord; \
\
  xxnew = _utDtile_alloc_tile( plane ) ; \
\
  UTDTILE_LEFT(xxnew) = x, UTDTILE_BOTTOM(xxnew) = UTDTILE_BOTTOM(xtile); \
  UTDTILE_BL(xxnew) = xtile, UTDTILE_TR(xxnew) = UTDTILE_TR(xtile), UTDTILE_RT(xxnew) = UTDTILE_RT(xtile); \
  xxnew->data = xtile->data ; \
\
  /* Left edge */ \
  for (xp = UTDTILE_TR(xtile); UTDTILE_BL(xp) == xtile; xp = UTDTILE_LB(xp)) UTDTILE_BL(xp) = xxnew; \
	UTDTILE_TR(xtile) = xxnew; \
\
  /* Top edge */ \
  for (xp = UTDTILE_RT(xtile); UTDTILE_LEFT(xp) >= x; xp = UTDTILE_BL(xp)) UTDTILE_LB(xp) = xxnew; \
	UTDTILE_RT(xtile) = xp; \
\
  /* Bottom edge */ \
  for (xp = UTDTILE_LB(xtile); UTDTILE_RIGHT(xp) <= x; xp = UTDTILE_TR(xp)); /* nothing */ \
  for (UTDTILE_LB(xxnew) = xp; UTDTILE_RT(xp) == xtile; UTDTILE_RT(xp) = xxnew, xp = UTDTILE_TR(xp)); \
	  res = xxnew; \
  }

/*
 * ----------------------------------------------------------------------
 *
 * utDtile_add
 *
 * Checks plane orientation before adding.
 * -----------------------------------------------------------------------
 */
BOOL utDtile_add( UTDPLANEPTR plane_p, UTDTILERECTPTR area, VOIDPTR data)
{
  UTDTILERECT swap_buf ;			/* swap plane orientation */
  /* -----------------------------------------------------------------
   * At list time we must swap directions if plane is max vertical.
   * ----------------------------------------------------------------- */
  if( plane_p->max_vertical ){
    swap_buf.UTDLLX = area->UTDLLY ;
    swap_buf.UTDLLY = area->UTDLLX ;
    swap_buf.UTDURX = area->UTDURY ;
    swap_buf.UTDURY = area->UTDURX ;
    area = &swap_buf ;
  }
  return(_utDtile_add( plane_p, area, data) ) ;

} /* end utDtile_add() */

/*
 * ----------------------------------------------------------------------
 *
 * _utDtile_add
 *
 * Paint a rectangular area ('area') on a single tile plane ('plane').
 * Returns true if an error occurs.
 * -----------------------------------------------------------------------
 */
BOOL _utDtile_add (UTDPLANEPTR plane, UTDTILERECTPTR area, VOIDPTR data)
/* Plane whose paint is to be modified */
/* Area to be changed */
{
  INT (*comp_func)(void *,void *) ;    /* how to compare two keys */
  UTDTILEPOINT start;
  INT mergeFlags;
  VOIDPTR oldData ;
  UTDTILEPTR tile, tpnew;	/* Used for area search */
  UTDTILEPTR newtile, tp;	/* Used for paint */
  UTDTILEBYTES clipTop;
  UTDTILERECT tile_area ;	/* tile area */
  
  if( area->r_xtop < area->r_xbot || area->r_ytop < area->r_ybot ){
      utDmsg( ERRMSG, MSG_AT, "utDtile_add","invalid tile dimensions given to utDtile_add().\n");
      return(TRUE) ;
  }
  if( FLOAT_EQ( area->r_xtop,area->r_xbot) ){
      utDmsgf( ERRMSG, MSG_AT, "utDtile_add","vertical line given to utDtile_add()\n");
      return(TRUE) ;
  }
  if( FLOAT_EQ( area->r_ytop,area->r_ybot) ){
      utDmsgf( ERRMSG, MSG_AT, "utDtile_add","horizontal line given to utDtile_add()\n");
      return(TRUE) ;
  }
  if( plane->data_check && !(data)){
    utDmsgf( WARNMSG,MSG_AT, "utDtile_add", "Data is NULL.\n" ) ;
  }
  DS( utDtile_check_int( area->r_xbot, TRUE ) ; ) 
  DS( utDtile_check_int( area->r_xtop, TRUE ) ; ) 
  DS( utDtile_check_int( area->r_ybot, TRUE ) ; ) 
  DS( utDtile_check_int( area->r_ytop, TRUE ) ; ) 

  comp_func = plane->compare_func ;
  
  /*
   * The following is a modified version of the area enumeration
   * algorithm.	 It expects the in-line paint code below to leave
   * 'tile' pointing to the tile from which we should continue the
   * search.
   */
  
  start.p_x = area->r_xbot;
  start.p_y = area->r_ytop - 1;
  tile = plane->pl_hint ;
  UTDTILE_GOTOPOINT(tile, &start);
  plane->tile_added++ ;
  
  /* Each iteration visits another tile on the LHS of the search area */
  while (UTDTILE_TOP(tile) > area->r_ybot)
    {
      /***
       *** AREA SEARCH.
       *** Each iteration enumerates another tile.
       ***/
    enumerate:
      
      clipTop = UTDTILE_TOP(tile);
      if (clipTop > area->r_ytop) clipTop = area->r_ytop;
      oldData = tile->data ;
      
      /***
       *** ---------- THE FOLLOWING IS IN-LINE PAINT CODE ----------
       ***/
      
      /*
       * Set up the directions in which we will have to
       * merge initially.  Clipping can cause some of these
       * to be turned off.
       */
      mergeFlags = UTDTILE_MRG_TOP | UTDTILE_MRG_LEFT;
      if (UTDTILE_RIGHT(tile) >= area->r_xtop) mergeFlags |= UTDTILE_MRG_RIGHT;
      if (UTDTILE_BOTTOM(tile) <= area->r_ybot) mergeFlags |= UTDTILE_MRG_BOTTOM;
      
      /*
       * Determine new type of this tile.
       * Change the type if necessary.
       */
      if ( comp_f ( oldData, data ) )
	{
	  /*
	   * Clip the tile against the clipping rectangle.
	   * Merging is only necessary if we clip to the left or to
	   * the right, and then only to the top or the bottom.
	   * We do the merge in-line for efficiency.
	   */
	  
	  /* Clip up */
	  if (UTDTILE_TOP(tile) > area->r_ytop)
	    {
	      newtile = _utDtile_splitY(plane,tile, area->r_ytop);
	      newtile->data = tile->data ;
	      mergeFlags &= ~UTDTILE_MRG_TOP;
	    }
	  
	  /* Clip down */
	  if (UTDTILE_BOTTOM(tile) < area->r_ybot)
	    {
	      newtile = tile;
	      tile = _utDtile_splitY(plane,tile, area->r_ybot);
	      tile->data = newtile->data ;
	      mergeFlags &= ~UTDTILE_MRG_BOTTOM;
	    }
	  
	  /* Clip right */
	  if (UTDTILE_RIGHT(tile) > area->r_xtop)
	    {
	      TISPLITX(plane, newtile, tile, area->r_xtop);
	      newtile->data = tile->data ;
	      mergeFlags &= ~UTDTILE_MRG_RIGHT;
	      
	      /* Merge the outside tile to its top */
	      tp = UTDTILE_RT(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	      
	      /* Merge the outside tile to its bottom */
	      tp = UTDTILE_LB(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	    }
	  
	  /* Clip left */
	  if (UTDTILE_LEFT(tile) < area->r_xbot)
	    {
	      newtile = tile;
	      TISPLITX(plane, tile, tile, area->r_xbot);
	      tile->data = newtile->data ;
	      
	      mergeFlags &= ~UTDTILE_MRG_LEFT;
	      
	      /* Merge the outside tile to its top */
	      tp = UTDTILE_RT(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp);
	      
	      /* Merge the outside tile to its bottom */
	      tp = UTDTILE_LB(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY(plane, newtile, tp ) ;
	    }
	  
	}
      
      /*
       * Merge the tile back into the parts of the plane that have
       * already been visited.	Note that if we clipped in a particular
       * direction we avoid merging in that direction.
       *
       * We avoid calling dbPaintMerge if at all possible.
       */
      if (mergeFlags & UTDTILE_MRG_LEFT) {
	for (tp = UTDTILE_BL(tile); UTDTILE_BOTTOM(tp) < UTDTILE_TOP(tile); tp = UTDTILE_RT(tp)){
	  if( tp != plane->pl_left && !(comp_f(tp->data, data)) ) {
	    tile = _utDtile_merge ( plane, tile, data, mergeFlags);
	    goto paintdone;
	  }
	}
	mergeFlags &= ~UTDTILE_MRG_LEFT;
      }
      if (mergeFlags & UTDTILE_MRG_RIGHT) {
	for (tp = UTDTILE_TR(tile); UTDTILE_TOP(tp) > UTDTILE_BOTTOM(tile); tp = UTDTILE_LB(tp)){
	  if( tp != plane->pl_right && !(comp_f(tp->data, data)) ){
	    tile = _utDtile_merge ( plane, tile, data, mergeFlags ) ;
	    goto paintdone;
	  }
	}
	mergeFlags &= ~UTDTILE_MRG_RIGHT;
      }
      
      /*
       * Cheap and dirty merge -- we don't have to merge to the
       * left or right, so the top/bottom merge is very fast.
       */
      
      /* Now it's safe to change the type of this tile */
      tile->data = data ; 
      
      if (mergeFlags & UTDTILE_MRG_TOP)
	{
	  tp = UTDTILE_RT(tile);
	  if (UTDTILE_CANMERGE_Y(tile, tp)) _utDtile_joinY ( plane, tile, tp ) ;
	  
	}
      if (mergeFlags & UTDTILE_MRG_BOTTOM)
	{
	  tp = UTDTILE_LB(tile);
	  if (UTDTILE_CANMERGE_Y(tile, tp)) _utDtile_joinY ( plane, tile, tp ) ;
	  
	}
      
      
      /***
       ***		END OF PAINT CODE
       *** ---------- BACK TO AREA SEARCH ----------
       ***/
    paintdone:
      /* Move right if possible */
      tpnew = UTDTILE_TR(tile);
      if (UTDTILE_LEFT(tpnew) < area->r_xtop)
	{
	  /* Move back down into clipping area if necessary */
	  while (UTDTILE_BOTTOM(tpnew) >= clipTop) tpnew = UTDTILE_LB(tpnew);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tile) || UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    {
	      tile = tpnew;
	      goto enumerate;
	    }
	}
      
      /* Each iteration returns one tile further to the left */
      while (UTDTILE_LEFT(tile) > area->r_xbot)
	{
	  /* Move left if necessary */
	  if (UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    goto done;
	  
	  /* Move down if possible; left otherwise */
	  tpnew = UTDTILE_LB(tile); tile = UTDTILE_BL(tile);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tile) || UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    {
	      tile = tpnew;
	      goto enumerate;
	    }
	}
      /* At left edge -- walk down to next tile along the left edge */
      for (tile = UTDTILE_LB(tile); UTDTILE_RIGHT(tile) <= area->r_xbot; tile = UTDTILE_TR(tile))
	/* Nothing */;
    }
  
 done:
  plane->pl_hint = tile;
  return(FALSE) ;
} /* end _utDtile_add() */

/*
 * ----------------------------------------------------------------------
 *
 * utDtile_add_no_merge
 *
 * Paint a rectangular area ('area') on a single tile plane ('plane').
 * Returns true if an error occurs.   Similar to utDtile_add except that
 * tiles are not maximally horizontal.
 * -----------------------------------------------------------------------
 */
BOOL utDtile_add_no_merge(UTDPLANEPTR plane, UTDTILERECTPTR area, VOIDPTR data)
/* Plane whose paint is to be modified */
/* Area to be changed */
{
  INT (*comp_func)(void *,void *) ;    /* how to compare two keys */
  UTDTILEPOINT start;
  VOIDPTR oldData ;
  UTDTILERECT swap_buf ;			/* used to swap orientation */
  UTDTILEPTR tile, tpnew;			/* Used for area search */
  UTDTILEPTR newtile, tp;			/* Used for paint */
  UTDTILEBYTES clipTop;
  FUNC_NAME("utDtile_add_no_merge") ;

  if( area->r_xtop < area->r_xbot || area->r_ytop < area->r_ybot ){
      utDmsg( ERRMSG, MSG_AT, routine,"invalid tile dimensions given.\n") ;
      return(TRUE) ;
  }
  if( FLOAT_EQ( area->r_xtop,area->r_xbot) ){
      utDmsgf( ERRMSG, MSG_AT, routine, "vertical line given.\n");
      return(TRUE) ;
  }
  if( FLOAT_EQ( area->r_ytop,area->r_ybot) ){
      utDmsgf( ERRMSG, MSG_AT, routine, "horizontal line given.\n");
      return(TRUE) ;
  }
  if( plane->data_check && !(data)){
    utDmsgf( WARNMSG, MSG_AT, routine, "Data is NULL.\n" ) ;
  }
  DS( utDtile_check_int( area->r_xbot, TRUE ) ; ) 
  DS( utDtile_check_int( area->r_xtop, TRUE ) ; ) 
  DS( utDtile_check_int( area->r_ybot, TRUE ) ; ) 
  DS( utDtile_check_int( area->r_ytop, TRUE ) ; ) 

  /* -----------------------------------------------------------------
   * At list time we must swap directions if plane is max vertical.
   * ----------------------------------------------------------------- */
  if( plane->max_vertical ){
    swap_buf.UTDLLX = area->UTDLLY ;
    swap_buf.UTDLLY = area->UTDLLX ;
    swap_buf.UTDURX = area->UTDURY ;
    swap_buf.UTDURY = area->UTDURX ;
    area = &swap_buf ;
  }

  comp_func = plane->compare_func ;
  
  /*
   * The following is a modified version of the area enumeration
   * algorithm.	 It expects the in-line paint code below to leave
   * 'tile' pointing to the tile from which we should continue the
   * search.
   */
  
  start.p_x = area->r_xbot;
  start.p_y = area->r_ytop - 1;
  tile = plane->pl_hint ;
  UTDTILE_GOTOPOINT(tile, &start);
  
  /* Each iteration visits another tile on the LHS of the search area */
  while (UTDTILE_TOP(tile) > area->r_ybot)
    {
      /***
       *** AREA SEARCH.
       *** Each iteration enumerates another tile.
       ***/
    enumerate2:
      
      clipTop = UTDTILE_TOP(tile);
      if (clipTop > area->r_ytop) clipTop = area->r_ytop;
      oldData = tile->data ;
      
      /***
       *** ---------- THE FOLLOWING IS IN-LINE PAINT CODE ----------
       ***/
      
      /*
       * Determine new type of this tile.
       * Change the type if necessary.
       */
      if ( comp_f ( oldData, data ) )
	{
	  /*
	   * Clip the tile against the clipping rectangle.
	   * Merging of the outside tiles is only necessary if we clip
	   * to the left or to the right, and then only to the top or
	   * the bottom.  We do the merge in-line for efficiency.
	   */
	  
	  /* Clip up */
	  if (UTDTILE_TOP(tile) > area->r_ytop)
	    {
	      newtile = _utDtile_splitY(plane,tile, area->r_ytop);
	      newtile->data = tile->data ;
	    }
	  
	  /* Clip down */
	  if (UTDTILE_BOTTOM(tile) < area->r_ybot)
	    {
	      newtile = tile, tile = _utDtile_splitY(plane,tile, area->r_ybot);
	      tile->data = newtile->data ;
	    }
	  
	  /* Clip right */
	  if (UTDTILE_RIGHT(tile) > area->r_xtop)
	    {
	      TISPLITX(plane,newtile, tile, area->r_xtop);
	      newtile->data = tile->data ;
	      
	      /* Merge the outside tile to its top */
	      tp = UTDTILE_RT(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	      
	      /* Merge the outside tile to its bottom */
	      tp = UTDTILE_LB(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	    }
	  
	  /* Clip left */
	  if (UTDTILE_LEFT(tile) < area->r_xbot)
	    {
	      newtile = tile;
	      TISPLITX(plane,tile, tile, area->r_xbot);
	      tile->data = newtile->data ;
	      
	      /* Merge the outside tile to its top */
	      tp = UTDTILE_RT(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	      
	      /* Merge the outside tile to its bottom */
	      tp = UTDTILE_LB(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	    }
	  
	  /* Record the type of the new tile */
	  tile->data = data ;
	}
      
      /***
       ***		END OF PAINT CODE
       *** ---------- BACK TO AREA SEARCH ----------
       ***/
      /* Move right if possible */
      tpnew = UTDTILE_TR(tile);
      if (UTDTILE_LEFT(tpnew) < area->r_xtop)
	{
	  /* Move back down into clipping area if necessary */
	  while (UTDTILE_BOTTOM(tpnew) >= clipTop) tpnew = UTDTILE_LB(tpnew);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tile) || UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    {
	      tile = tpnew;
	      goto enumerate2;
	    }
	}
      
      /* Each iteration returns one tile further to the left */
      while (UTDTILE_LEFT(tile) > area->r_xbot)
	{
	  /* Move left if necessary */
	  if (UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    goto changedone;
	  
	  /* Move down if possible; left otherwise */
	  tpnew = UTDTILE_LB(tile); tile = UTDTILE_BL(tile);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tile) || UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    {
	      tile = tpnew;
	      goto enumerate2;
	    }
	}
      /* At left edge -- walk down to next tile along the left edge */
      for (tile = UTDTILE_LB(tile); UTDTILE_RIGHT(tile) <= area->r_xbot; tile = UTDTILE_TR(tile))
	/* Nothing */;
    }
  
 changedone:
  plane->pl_hint = tile;
    return(FALSE) ;

} /* end utDtile_add_no_merge() */
  
void utDtile_mergeOnce (UTDPLANEPTR plane, UTDTILERECTPTR area, VOIDPTR data)
{
    UTDTILERECT swap_buf ;			/* swap plane orientation */
    /* -----------------------------------------------------------------
     * At list time we must swap directions if plane is max vertical.
     * ----------------------------------------------------------------- */
    if( plane->max_vertical ){
      swap_buf.UTDLLX = area->UTDLLY ;
      swap_buf.UTDLLY = area->UTDLLX ;
      swap_buf.UTDURX = area->UTDURY ;
      swap_buf.UTDURY = area->UTDURX ;
      area = &swap_buf ;
    }
    _utDtile_mergeOnce ( plane, area, data) ;
} /* end utDtile_mergeOnce() */

/*
 * ----------------------------------------------------------------------------
 *
 * _utDtile_mergeOnce ()
 *
 * Paint a rectangular area ('area') on a single tile plane ('plane').
 * This is identical to DBPaintPlane(), except that we work in two
 * passes:
 *
 *	Pass 1: clip all tiles to lie inside the area to be painted,
 *		merging all outside tiles as required.	Change the
 *		types of each of these internal tiles.
 *
 *	Pass 2:	re split and merge to insure that the database is
 *		once again in maximal horizontal strips.
 *
 * See DBPaintPlane for other comments.
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	Modifies the database plane that contains the given tile.
 *
 * ----------------------------------------------------------------------------
 */

void _utDtile_mergeOnce (UTDPLANEPTR plane, UTDTILERECTPTR area, VOIDPTR data)
/* Plane whose paint is to be modified */
/* Area to be changed */
{
  UTDTILEPOINT start;
  INT mergeFlags;
  VOIDPTR oldData ;
  VOIDPTR newData ;
  UTDTILEPTR tile, tpnew;	/* Used for area search */
  UTDTILEPTR newtile, tp;	/* Used for paint */
  UTDTILEBYTES clipTop;
  INT (*comp_func)(void *,void *) ;    /* how to compare two keys */
  
  comp_func = plane->compare_func ;
  newData = data ;
  
  if (area->r_xtop <= area->r_xbot || area->r_ytop <= area->r_ybot)
    return;
  
  /*
   * The following is a modified version of the area enumeration
   * algorithm.	 It expects the in-line paint code below to leave
   * 'tile' pointing to the tile from which we should continue the
   * search.
   */
  
  start.p_x = area->r_xbot;
  start.p_y = area->r_ytop - 1;
  tile = plane->pl_hint ;
  UTDTILE_GOTOPOINT(tile, &start);
  
  /* Each iteration visits another tile on the LHS of the search area */
  while (UTDTILE_TOP(tile) > area->r_ybot)
    {
      /***
       *** AREA SEARCH.
       *** Each iteration enumerates another tile.
       ***/
    enumerate2:
      
      clipTop = UTDTILE_TOP(tile);
      if (clipTop > area->r_ytop) clipTop = area->r_ytop;
      oldData = tile->data ;
      
      /***
       *** ---------- THE FOLLOWING IS IN-LINE PAINT CODE ----------
       ***/
      
      /*
       * Determine new type of this tile.
       * Change the type if necessary.
       */
      if ( comp_f ( oldData, newData ) )
	{
	  /*
	   * Clip the tile against the clipping rectangle.
	   * Merging of the outside tiles is only necessary if we clip
	   * to the left or to the right, and then only to the top or
	   * the bottom.  We do the merge in-line for efficiency.
	   */
	  
	  /* Clip up */
	  if (UTDTILE_TOP(tile) > area->r_ytop)
	    {
	      newtile = _utDtile_splitY(plane,tile, area->r_ytop);
	      newtile->data = tile->data ;
	    }
	  
	  /* Clip down */
	  if (UTDTILE_BOTTOM(tile) < area->r_ybot)
	    {
	      newtile = tile, tile = _utDtile_splitY(plane,tile, area->r_ybot);
	      tile->data = newtile->data ;
	    }
	  
	  /* Clip right */
	  if (UTDTILE_RIGHT(tile) > area->r_xtop)
	    {
	      TISPLITX(plane,newtile, tile, area->r_xtop);
	      newtile->data = tile->data ;
	      
	      /* Merge the outside tile to its top */
	      tp = UTDTILE_RT(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	      
	      /* Merge the outside tile to its bottom */
	      tp = UTDTILE_LB(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	    }
	  
	  /* Clip left */
	  if (UTDTILE_LEFT(tile) < area->r_xbot)
	    {
	      newtile = tile;
	      TISPLITX(plane,tile, tile, area->r_xbot);
	      tile->data = newtile->data ;
	      
	      /* Merge the outside tile to its top */
	      tp = UTDTILE_RT(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	      
	      /* Merge the outside tile to its bottom */
	      tp = UTDTILE_LB(newtile);
	      if (UTDTILE_CANMERGE_Y(newtile, tp)) _utDtile_joinY ( plane, newtile, tp ) ;
	    }
	  
	  /* Record the type of the new tile */
	  tile->data = data ;
	}
      
      /***
       ***		END OF PAINT CODE
       *** ---------- BACK TO AREA SEARCH ----------
       ***/
      /* Move right if possible */
      tpnew = UTDTILE_TR(tile);
      if (UTDTILE_LEFT(tpnew) < area->r_xtop)
	{
	  /* Move back down into clipping area if necessary */
	  while (UTDTILE_BOTTOM(tpnew) >= clipTop) tpnew = UTDTILE_LB(tpnew);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tile) || UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    {
	      tile = tpnew;
	      goto enumerate2;
	    }
	}
      
      /* Each iteration returns one tile further to the left */
      while (UTDTILE_LEFT(tile) > area->r_xbot)
	{
	  /* Move left if necessary */
	  if (UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    goto changedone;
	  
	  /* Move down if possible; left otherwise */
	  tpnew = UTDTILE_LB(tile); tile = UTDTILE_BL(tile);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tile) || UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    {
	      tile = tpnew;
	      goto enumerate2;
	    }
	}
      /* At left edge -- walk down to next tile along the left edge */
      for (tile = UTDTILE_LB(tile); UTDTILE_RIGHT(tile) <= area->r_xbot; tile = UTDTILE_TR(tile))
	/* Nothing */;
    }
  
 changedone:
  /*
   * Done with the area enumeration to change the types of all tiles
   * in this area.  Now go back and re-merge everything to form
   * maximal horizontal strips.	 The following is another in-line
   * version of area enumeration, but is non-interruptible.
   */
  UTDTILE_GOTOPOINT(tile, &start);
  
  /* Each iteration visits another tile on the LHS of the search area */
  while (UTDTILE_TOP(tile) > area->r_ybot)
    {
      /***
       *** AREA SEARCH.
       *** Each iteration enumerates another tile.
       ***/
    mergenum:
      clipTop = UTDTILE_TOP(tile);
      if (clipTop > area->r_ytop) clipTop = area->r_ytop;
      oldData = tile->data ;
      
      /***
       *** ---------- THE FOLLOWING IS IN-LINE MERGE CODE ----------
       ***/
      
      /* Set up initial merge directions */
      mergeFlags = UTDTILE_MRG_TOP | UTDTILE_MRG_LEFT;
      if (UTDTILE_RIGHT(tile) >= area->r_xtop) mergeFlags |= UTDTILE_MRG_RIGHT;
      if (UTDTILE_BOTTOM(tile) <= area->r_ybot) mergeFlags |= UTDTILE_MRG_BOTTOM;
      
      /*
       * Merge the tile back into the parts of the plane that have
       * already been visited.	Note that if we clipped in a particular
       * direction we avoid merging in that direction.
       * We avoid calling dbPaintMerge if at all possible.
       */
      newData = tile->data;
      if (mergeFlags & UTDTILE_MRG_LEFT) {
	for (tp = UTDTILE_BL(tile); UTDTILE_BOTTOM(tp) < UTDTILE_TOP(tile); tp = UTDTILE_RT(tp)){
	  if( (tp != plane->pl_left) && !(comp_f(tp->data,newData)) ) {
	    tile = _utDtile_merge ( plane, tile, newData, mergeFlags ) ;
	    goto mergedone;
	  }
	}
	mergeFlags &= ~UTDTILE_MRG_LEFT;
      }
      if (mergeFlags & UTDTILE_MRG_RIGHT) {
	for (tp = UTDTILE_TR(tile); UTDTILE_TOP(tp) > UTDTILE_BOTTOM(tile); tp = UTDTILE_LB(tp)){
	  if( (tp != plane->pl_right) && !(comp_f(tp->data,newData)) ) {
	    tile = _utDtile_merge ( plane, tile, newData, mergeFlags ) ;
	    goto mergedone;
	  }
	}
	mergeFlags &= ~UTDTILE_MRG_RIGHT;
      }
      
      /*
       * Cheap and dirty merge -- we don't have to merge to the
       * left or right, so the top/bottom merge is very fast.
       */
      
      if (mergeFlags & UTDTILE_MRG_TOP)
	{
	  tp = UTDTILE_RT(tile);
	  if (UTDTILE_CANMERGE_Y(tile, tp)) _utDtile_joinY ( plane, tile, tp ) ;
	  
	}
      if (mergeFlags & UTDTILE_MRG_BOTTOM)
	{
	  tp = UTDTILE_LB(tile);
	  if (UTDTILE_CANMERGE_Y(tile, tp)) _utDtile_joinY ( plane, tile, tp ) ;
	  
	}
      
      
      /***
       ***		END OF MERGE CODE
       *** ---------- BACK TO AREA SEARCH ----------
       ***/
    mergedone:
      /* Move right if possible */
      tpnew = UTDTILE_TR(tile);
      if (UTDTILE_LEFT(tpnew) < area->r_xtop)
	{
	  /* Move back down into clipping area if necessary */
	  while (UTDTILE_BOTTOM(tpnew) >= clipTop) tpnew = UTDTILE_LB(tpnew);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tile) || UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    {
	      tile = tpnew;
	      goto mergenum;
	    }
	}
      
      /* Each iteration returns one tile further to the left */
      while (UTDTILE_LEFT(tile) > area->r_xbot)
	{
	  /* Move left if necessary */
	  if (UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    goto done;
	  
	  /* Move down if possible; left otherwise */
	  tpnew = UTDTILE_LB(tile); tile = UTDTILE_BL(tile);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tile) || UTDTILE_BOTTOM(tile) <= area->r_ybot)
	    {
	      tile = tpnew;
	      goto mergenum;
	    }
	}
      /* At left edge -- walk down to next tile along the left edge */
      for (tile = UTDTILE_LB(tile); UTDTILE_RIGHT(tile) <= area->r_xbot; tile = UTDTILE_TR(tile))
	/* Nothing */;
    }
  
 done:
  plane->pl_hint = tile;
} /* end void _utDtile_mergeOnce() */

/* -----------------------------------------------------------------
 * Delete a tile.  Restore to default data configuration.
----------------------------------------------------------------- */
void utDtile_delete(UTDPLANEPTR plane_p,UTDTILEPTR tp)
{
  VOIDPTR default_data ;		/* default data */
  UTDTILERECT area ;			/* area to fixup */

  default_data = plane_p->pl_top->data ;
  utDtile_rect_orient( plane_p, tp, &area ) ;
  if( plane_p->max_vertical ){
    SWAP( area.UTDLLX, area.UTDLLY, UTDTILEBYTES ) ;
    SWAP( area.UTDURX, area.UTDURY, UTDTILEBYTES ) ;
  }
  _utDtile_mergeOnce( plane_p, &area, default_data ) ;

} /* utDtile_delete() */

/* -----------------------------------------------------------------
 * Delete the tiles in an area.  Restore to default data configuration.
----------------------------------------------------------------- */
void utDtile_delete_area(UTDPLANEPTR plane,UTDTILERECTPTR area)
{
  UTDTILERECT swap_buf ;			/* swap tile orientation */
  VOIDPTR default_data ;		/* default data */

  default_data = plane->pl_top->data ;
  /* -----------------------------------------------------------------
   * At list time we must swap directions if plane is max vertical.
   * ----------------------------------------------------------------- */
  if( plane->max_vertical ){
    swap_buf.UTDLLX = area->UTDLLY ;
    swap_buf.UTDLLY = area->UTDLLX ;
    swap_buf.UTDURX = area->UTDURY ;
    swap_buf.UTDURY = area->UTDURX ;
    area = &swap_buf ;
  }
  _utDtile_mergeOnce( plane, area, default_data ) ;

} /* utDtile_delete_area() */

/*
 * ----------------------------------------------------------------------------
 *
 * _utDtile_merge -- 
 *
 * The tile 'tp' is to be changed to type 'newtype'.  To maintain
 * maximal horizontal strips, it may be necessary to merge the new
 * 'tp' with its neighbors.
 *
 * This procedure splits off the biggest segment along the top of the
 * tile 'tp' that can be merged with its neighbors to the left and right
 * (depending on which of UTDTILE_MRG_LEFT and UTDTILE_MRG_RIGHT are set in the merge flags),
 * then changes the type of 'tp' to 'newtype' and merges to the left, right,
 * top, and bottom (in that order).
 *
 * Results:
 *	Returns a pointer to the topmost tile resulting from any splits
 *	and merges of the original tile 'tp'.  By the maximal horizontal
 *	strip property and the fact that the original tile 'tp' gets
 *	painted a single color, we know that this topmost resulting tile
 *	extends across the entire top of the area occupied by 'tp'.
 *
 *	NOTE: the only tile whose type is changed is 'tp'.  Any tiles
 *	resulting from splits below this tile will not have had their
 *	types changed.
 *
 * Side effects:
 *	Modifies the database plane that contains the given tile.
 *
 * THIS IS SLOW, SO SHOULD BE AVOIDED IF AT ALL POSSIBLE.
 * THE CODE ABOVE GOES TO GREAT LENGTHS TO DO SO.
 *
 * ----------------------------------------------------------------------------
 */

UTDTILEPTR  _utDtile_merge(UTDPLANEPTR plane,UTDTILEPTR tile,VOIDPTR data,INT mergeFlags)
/* Plane on which this resides */
/* Tile to be merged with its neighbors */
/* Specify which directions to merge */
{
  INT (*comp_func)(void *,void *) ;    /* how to compare two keys */
  UTDTILEPTR tp, tpLast;
  UTDTILEBYTES ysplit ;
  
  comp_func = plane->compare_func ;
  
  ysplit = UTDTILE_BOTTOM(tile);
  if (mergeFlags & UTDTILE_MRG_LEFT)
    {
      /*
       * Find the split point along the LHS of tile.
       * If the topmost tile 'tp' along the LHS is of type 'newType'
       * the split point will be no lower than the bottom of 'tp'.
       * If the topmost tile is NOT of type 'newType', then the split
       * point will be no lower than the top of the first tile along
       * the LHS that is of type 'newType'.
       */
      for (tpLast = NULL, tp = UTDTILE_BL(tile); UTDTILE_BOTTOM(tp) < UTDTILE_TOP(tile); tp = UTDTILE_RT(tp))
        if ( (tp != plane->pl_left) && !(comp_f(tp->data,data)) ){
	  tpLast = tp;
	}
      
      /* If the topmost LHS tile is not of type 'newType', we don't merge */
      if (tpLast == NULL || UTDTILE_TOP(tpLast) < UTDTILE_TOP(tile))
	{
	  mergeFlags &= ~UTDTILE_MRG_LEFT;
	  if (UTDTILE_TOP(tpLast) > ysplit) ysplit = UTDTILE_TOP(tpLast);
	}
      else if (UTDTILE_BOTTOM(tpLast) > ysplit) ysplit = UTDTILE_BOTTOM(tpLast);
    }
  
  if (mergeFlags & UTDTILE_MRG_RIGHT)
    {
      /*
       * Find the split point along the RHS of 'tile'.
       * If the topmost tile 'tp' along the RHS is of type 'newType'
       * the split point will be no lower than the bottom of 'tp'.
       * If the topmost tile is NOT of type 'newType', then the split
       * point will be no lower than the top of the first tile along
       * the RHS that is of type 'newType'.
       */
      tp = UTDTILE_TR(tile);
      if( (tp != plane->pl_right) && !(comp_f(tp->data, data)) ) {
	if (UTDTILE_BOTTOM(tp) > ysplit) ysplit = UTDTILE_BOTTOM(tp);
      } else {
	/* Topmost RHS tile is not of type 'newType', so don't merge */
	for ( tp = UTDTILE_LB(tp);  UTDTILE_TOP(tp) > ysplit; tp = UTDTILE_LB(tp) ) {
	  if( (tp != plane->pl_right) && !(comp_f(tp->data,data)) ){
	    ysplit = UTDTILE_TOP(tp);
	    break;
	  }
	}
	mergeFlags &= ~UTDTILE_MRG_RIGHT;
      }
    }
  
  /*
   * If 'tile' must be split horizontally, do so.
   * Any merging to the bottom will be delayed until the split-off
   * bottom tile is processed on a subsequent iteration of the area
   * enumeration loop in DBPaintPlane().
   */
  if (ysplit > UTDTILE_BOTTOM(tile))
    {
      mergeFlags &= ~UTDTILE_MRG_BOTTOM;
      tp = _utDtile_splitY(plane,tile, ysplit);
      tp->data = tile->data ;
      tile = tp;
      
    }
  
  /*
   * Set the type of the new tile.
   * Record any undo information.
   */
  tile->data = data ;
  
  /*
   * Do the merging.
   * We are guaranteed that at most one tile abuts 'tile' on
   * any side that we will merge to, and that this tile is
   * of type 'newType'.
   */
  if (mergeFlags & UTDTILE_MRG_LEFT)
    {
      tp = UTDTILE_BL(tile);
      if (UTDTILE_TOP(tp) > UTDTILE_TOP(tile)) {
	tpLast = _utDtile_splitY(plane,tp, UTDTILE_TOP(tile));
	tpLast->data = data ;
      }
      if (UTDTILE_BOTTOM(tp) < UTDTILE_BOTTOM(tile)) tp = _utDtile_splitY(plane,tp, UTDTILE_BOTTOM(tile));
      _utDtile_joinX ( plane, tile, tp ) ;
      
    }
  if (mergeFlags & UTDTILE_MRG_RIGHT)
    {
      tp = UTDTILE_TR(tile);
      if (UTDTILE_TOP(tp) > UTDTILE_TOP(tile)) {
	tpLast = _utDtile_splitY(plane,tp, UTDTILE_TOP(tile));
	tpLast->data = data ;
      }
      if (UTDTILE_BOTTOM(tp) < UTDTILE_BOTTOM(tile)) tp = _utDtile_splitY(plane,tp, UTDTILE_BOTTOM(tile));
      _utDtile_joinX ( plane, tile, tp ) ;
      
    }
  if (mergeFlags&UTDTILE_MRG_TOP)
    {
      tp = UTDTILE_RT(tile);
      if (UTDTILE_CANMERGE_Y(tp, tile)) _utDtile_joinY ( plane, tile, tp ) ;
      
    }
  if (mergeFlags&UTDTILE_MRG_BOTTOM)
    {
      tp = UTDTILE_LB(tile);
      if (UTDTILE_CANMERGE_Y(tp, tile)) _utDtile_joinY ( plane, tile, tp ) ;
      
    }
  
  return (tile);
} /* end _utDtile_merge() */

/* -----------------------------------------------------------------
 * The user interfact to utDtile_enumerate.  Notice that it swap direction
 * automatically.
 * ----------------------------------------------------------------- */
UTDTILEPTR utDtile_enumerate(UTDPLANEPTR plane_p,UTDTILERECTPTR rect_p,UTDTILEPTR tp )
{
    UTDTILERECT swap_buf ;			/* swap plane orientation */
    /* -----------------------------------------------------------------
     * At list time we must swap directions if plane is max vertical.
     * ----------------------------------------------------------------- */
    if( plane_p->max_vertical ){
      swap_buf.UTDLLX = rect_p->UTDLLY ;
      swap_buf.UTDLLY = rect_p->UTDLLX ;
      swap_buf.UTDURX = rect_p->UTDURY ;
      swap_buf.UTDURY = rect_p->UTDURX ;
      rect_p = &swap_buf ;
    }
    return( _utDtile_enumerate( plane_p, rect_p, tp ) ) ;
} /* end utDtile_enumerate() */


/* -----------------------------------------------------------------
 * Reentrant version of utDtile enumerate.  This traverse the database.
 * ----------------------------------------------------------------- */
UTDTILEPTR _utDtile_enumerate(UTDPLANEPTR plane, UTDTILERECTPTR rect,UTDTILEPTR tp )
                	/* Plane in which tiles lie.  This is used to
			 * provide a hint tile in case hintTile == NULL.
			 * The hint tile in the plane is updated to be
			 * the last tile visited in the area
			 * enumeration.
			 */
                  	/* Area to search.  This area should not be
			 * degenerate.	Tiles must OVERLAP the area.
			 */

                 	/* TRUE if the start of an enumeration, FALSE otw */
{
  UTDTILEPOINT start;	/* start tile */
  UTDTILEPTR tpnew;	/* temporary tile */
  
  if( tp ){
    goto restart4 ;
  } else {
    start.p_x = rect->r_xbot;
    start.p_y = rect->r_ytop - 1;
    tp = plane->pl_hint ;
    UTDTILE_GOTOPOINT(tp, &start);
  }
  
  /* Each iteration visits another tile on the LHS of the search area */
  while (UTDTILE_TOP(tp) > rect->r_ybot) {
    /* Each iteration enumerates another */
    enumerate4:
      plane->pl_hint = tp ;
      
      return(tp) ;

    restart4:
      /* restart the iteration here */
      
      tpnew = UTDTILE_TR(tp);
      if (UTDTILE_LEFT(tpnew) < rect->r_xtop) {
	  while (UTDTILE_BOTTOM(tpnew) >= rect->r_ytop) tpnew = UTDTILE_LB(tpnew);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tp) || UTDTILE_BOTTOM(tp) <= rect->r_ybot) {
	      tp = tpnew;
	      goto enumerate4;
	  }
      }
      
      /* Each iteration returns one tile further to the left */
      while (UTDTILE_LEFT(tp) > rect->r_xbot) {
	  if (UTDTILE_BOTTOM(tp) <= rect->r_ybot){
	    return(NULL) ;
	  }
	  tpnew = UTDTILE_LB(tp);
	  tp = UTDTILE_BL(tp);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tp) || UTDTILE_BOTTOM(tp) <= rect->r_ybot) {
	      tp = tpnew;
	      goto enumerate4;
	  }
      }
      
      /* At left edge -- walk down to next tile along the left edge */
      for (tp = UTDTILE_LB(tp); UTDTILE_RIGHT(tp) <= rect->r_xbot; tp = UTDTILE_TR(tp))
	/* Nothing */;

  } /* end while (UTDTILE_TOP(tp) > rect->r_ybot... */

  return (NULL);
} /* end _utDtile_enumerate() */


/* -----------------------------------------------------------------
 * The user interfact to utDtile_enumerate_all.  
 * ----------------------------------------------------------------- */
UTDTILEPTR utDtile_enumerate_all(UTDPLANEPTR plane, UTDTILEPTR tp )
                	/* Plane in which tiles lie.  This is used to
			 * provide a hint tile in case hintTile == NULL.
			 * The hint tile in the plane is updated to be
			 * the last tile visited in the area
			 * enumeration. */
                 	/* NULL if the start of an enumeration;tile pointer otw */
{
  UTDTILEPOINT start;	/* start tile */
  UTDTILEPTR tpnew;	/* temporary tile */
  
  if( tp ){
    goto restart5 ;
  } else {
    start.p_x = UTDTILE_MIN ;
    start.p_y = UTDTILE_MAX - 1 ;
    tp = plane->pl_hint ;
    UTDTILE_GOTOPOINT(tp, &start);
  }
  
  /* Each iteration visits another tile on the LHS of the search area */
  while (UTDTILE_TOP(tp) > UTDTILE_MIN) {
    /* Each iteration enumerates another */
    enumerate5:
      plane->pl_hint = tp ;
      
      return(tp) ;

    restart5:
      /* restart the iteration here */
      
      tpnew = UTDTILE_TR(tp);
      if (UTDTILE_LEFT(tpnew) < UTDTILE_MAX) {
	  while (UTDTILE_BOTTOM(tpnew) >= UTDTILE_MAX) tpnew = UTDTILE_LB(tpnew);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tp) || UTDTILE_BOTTOM(tp) <= UTDTILE_MIN) {
	      tp = tpnew;
	      goto enumerate5;
	  }
      }
      
      /* Each iteration returns one tile further to the left */
      while (UTDTILE_LEFT(tp) > UTDTILE_MIN) {
	  if (UTDTILE_BOTTOM(tp) <= UTDTILE_MIN){
	    return(NULL) ;
	  }
	  tpnew = UTDTILE_LB(tp);
	  tp = UTDTILE_BL(tp);
	  if (UTDTILE_BOTTOM(tpnew) >= UTDTILE_BOTTOM(tp) || UTDTILE_BOTTOM(tp) <= UTDTILE_MIN) {
	      tp = tpnew;
	      goto enumerate5;
	  }
      }
      
      /* At left edge -- walk down to next tile along the left edge */
      for (tp = UTDTILE_LB(tp); UTDTILE_RIGHT(tp) <= UTDTILE_MIN; tp = UTDTILE_TR(tp))
	/* Nothing */;

  } /* end while (UTDTILE_TOP(tp) > rect->r_ybot... */

  return (NULL);
} /* end utDtile_enumerate_all() */


static INT tile_default_compare(VOIDPTR d1, VOIDPTR d2)
{
    if( d1 < d2 ){
      return(-1) ;
    } else if( d1 > d2 ){
      return(1) ;
    } else {
      return(0) ;
    }
} /* end tile_default_compare() */


/* -----------------------------------------------------------------
 * Returns true if floating point number can not be represented as
 * an integer. False otherwise.
----------------------------------------------------------------- */
BOOL utDtile_check_int( DOUBLE float_number, BOOL verbose )
{
    DOUBLE remainder ;			/* diff between float and rounded */
    DOUBLE rounded_float ;		/* rounded float */

#ifdef HAVE_ISNAN
    if( isnan(float_number) ){
      if( verbose ){
	utDmsgf(ERRMSG, MSG_AT, "utDtile_check_int","Number is not a number.\n");
      }
      return(TRUE) ;
    }
#endif /* HAVE_ISNAN */
    rounded_float = utDrint(float_number) ;
    remainder = rounded_float - float_number ;
    if( fabs(remainder) > 1.1E-16 ){
      if( verbose ){
	utDmsgf(ERRMSG, MSG_AT, "utDtile_check_int","Tile is not represented as an integer.\n");
      }
      return(TRUE) ;
    }
    return(FALSE) ;
} /* end utDtile_check_int() */

void utDtile_rect_truncate_max( UTDTILERECTPTR area_p )
{
  if( area_p->UTDLLX < UTDTILE_MIN ){
    area_p->UTDLLX = UTDTILE_MIN ;
  }
  if( area_p->UTDLLY < UTDTILE_MIN ){
    area_p->UTDLLY = UTDTILE_MIN ;
  }
  if( area_p->UTDURX > UTDTILE_MAX ){
    area_p->UTDURX = UTDTILE_MAX ;
  }
  if( area_p->UTDURY > UTDTILE_MAX ){
    area_p->UTDURY = UTDTILE_MAX ;
  }
} /* end utDtile_rect_truncate_max() */

#ifdef DEBUG

static BOOL rect_verify(UTDTILERECTPTR r)
{
    if( r->UTDLLX < r->UTDURX && r->UTDLLY < r->UTDURY ){
      return(TRUE) ;
    } else {
      return(FALSE) ;
    }
} /* end rect_verify() */

INT utDtile_verify_tile( UTDPLANEPTR plane, UTDTILEPTR tp )
{

  INT fail ;				/* number of failures */
  DOUBLE large ;			/* span of area */
  UTDTILEPTR p1 ;				/* traverse tiles */
  UTDTILEPTR p2 ;				/* traverse tiles */
  UTDTILERECT r1 ;			/* geometry for tile 1 */
  UTDTILERECT r2 ;			/* geometry for tile 1 */
  UTDTILERECT area ;			/* area to search */
  UTDTILEPTR search_p ;			/* search plane for tile */

  /* -----------------------------------------------------------------
   * Make sure tile belongs to plane.
  ----------------------------------------------------------------- */
  large = UTDTILE_INFINITY / 2.0 ;
  area.UTDLLX = -large ;
  area.UTDLLY = -large ;
  area.UTDURX =  large ;
  area.UTDURY =  large ;
  fail = 0 ;
  for( search_p = _utDtile_enumerate( plane, &area, NULL ) ; search_p ;
       search_p = _utDtile_enumerate( plane, &area, search_p ) ){
    if( search_p == tp ){
      break ;
    }
  }
  if(!(search_p)){
    /* no sense doing any more it will crash */
    utDmsgf(ERRMSG,MSG_AT, "utDtile_verify_tile", "Tile not found in plane.\n" ) ;
    return(1) ;
  }

  
  /* -----------------------------------------------------------------
   * Verify database: exercise pointers in all directions.
   * First - go UTDTILE_LEFT.
  ----------------------------------------------------------------- */
  for( p1 = tp ; p1 != plane->pl_left ; p1 = p2 ) {
    p2 = UTDTILE_BL(p1) ;
    utDtile_rect( p1, &r1 ) ;
    utDtile_rect( p2, &r2 ) ;
    if( !(rect_verify(&r1)) || !(rect_verify(&r2)) ) {
      fail++ ;
    }
    if( r1.UTDLLX != r2.UTDURX || r1.UTDLLX <= r2.UTDLLX || r1.UTDURX <= r2.UTDURX ) {
      fail++ ;
    }
  } /* end for( p1  = tp... */

  /* -----------------------------------------------------------------
   * Go UTDTILE_RIGHT.
  ----------------------------------------------------------------- */
  for( p1 = tp ; p1 != plane->pl_right ; p1 = p2 ) {
    p2 = UTDTILE_TR(p1) ;
    utDtile_rect( p1, &r1 ) ;
    utDtile_rect( p2, &r2 ) ;
    if( !(rect_verify(&r1)) || !(rect_verify(&r2)) ) {
      fail++ ;
    }
    if ( r1.UTDURX != r2.UTDLLX || r1.UTDLLX >= r2.UTDLLX || r1.UTDURX >= r2.UTDURX) {
      fail++ ;
    }
  } /* end for( p1  = tp... */
  
  /* -----------------------------------------------------------------
   * Go UP.
  ----------------------------------------------------------------- */
  for( p1 = tp ; p1 != plane->pl_top ; p1 = p2 ) {
    p2= UTDTILE_RT(p1) ;
    utDtile_rect( p1, &r1 ) ;
    utDtile_rect( p2, &r2 ) ;
    if( !(rect_verify(&r1)) || !(rect_verify(&r2)) ) {
      fail++ ;
    }
    if ( r1.UTDURY != r2.UTDLLY || r1.UTDLLY >= r2.UTDLLY || r1.UTDURY >= r2.UTDURY) {
      fail++ ;
    }
  } /* end for( p1  = tp... */

  /* -----------------------------------------------------------------
   * Go DOWN.
  ----------------------------------------------------------------- */
  for( p1 = tp ; p1 != plane->pl_bottom ; p1 = p2 ) {
    p2=UTDTILE_LB(p1) ;
    utDtile_rect( p1, &r1 ) ;
    utDtile_rect( p2, &r2 ) ;
    if( !(rect_verify(&r1)) || !(rect_verify(&r2)) ) {
      fail++ ;
    }
    if ( r1.UTDLLY != r2.UTDURY || r1.UTDLLY <= r2.UTDLLY || r1.UTDURY <= r2.UTDURY) {
      fail++ ;
    }
  } /* end for( p1  = tp... */

  return(fail) ;

} /* end utDtile_verify_tile() */

INT utDtile_verify_plane(UTDPLANEPTR plane)
{
    INT fail ;					/* number of failures */
    UTDTILERECT area ;				/* area to search */
    UTDTILEPTR tp ;				/* current tile */
    DOUBLE large ;				/* span of area */

    large = UTDTILE_INFINITY / 2.0 ;
    area.UTDLLX = -large ;
    area.UTDLLY = -large ;
    area.UTDURX =  large ;
    area.UTDURY =  large ;
    fail = 0 ;
    for( tp = _utDtile_enumerate( plane, &area, NULL ) ; tp ;
	 tp = _utDtile_enumerate( plane, &area, tp ) ){
      fail += utDtile_verify_tile( plane, tp ) ;
    }
    return(fail) ;
} /* end utDtile_verify() */

#endif /* DEBUG */

#else /* TEST */

#include <stdlib.h>
#include <utd/rand.h>

#define MINXY 0
#define MAXXY 10000

static UTDTILERECT areaS ;   	/* max bounds used. (area to draw) */
static UTDPLANEPTR PlaneS ;  	/* plane of tiles */


/*----------------------------------
  test structure comparison function
  ----------------------------------*/
static INT compare_data (VOIDPTR d1, VOIDPTR d2)
{
  return ( ( LONG ) d1 - (LONG ) d2 ) ;
}

static void print_tile (UTDPLANEPTR plane_p, UTDTILEPTR tp, BOOL all_tiles )
{
  UTDTILERECT r ;
  
  utDtile_rect_orient ( plane_p, tp, &r ) ;
  if(!(all_tiles)){
    if( r.UTDLLX < INT_MIN || r.UTDLLX > INT_MAX ) return;
    if( r.UTDLLY < INT_MIN || r.UTDLLY > INT_MAX ) return;
    if( r.UTDURX < INT_MIN || r.UTDURX > INT_MAX ) return;
    if( r.UTDURY < INT_MIN || r.UTDURY > INT_MAX ) return;
  }
  fprintf ( stderr, " [(%10.2f,%10.2f) (%10.2f %10.2f)] color:%ld\n",
                     r.UTDLLX, r.UTDLLY, r.UTDURX, r.UTDURY, (LONG)tp->data ) ;
} /* end print_tile() */

static void one_round(BOOL wait, INT seed)
{
  int c ;
  int i ;
  DOUBLE x, y ;
  UTDTILERECT r ;
  UTDTILERECT save_rect ;
  UTDTILEPTR tp ;
  UTDTILEPTR save_tile ;
  UTDPLANEPTR plane_p ;  		/* plane of tiles */

  utDrandom_set_seed(seed) ;

  /* set up bounds of test area */
  areaS.UTDLLX = areaS.UTDLLY = MINXY ;
  areaS.UTDURX = areaS.UTDURY = MAXXY ;

  /* create a tile plane. TWGRAY is the data for the initial tile */
  plane_p = PlaneS = utDtile_init_vert ( compare_data, VOIDPTR_TYPE(4) ) ;

  /* add a load of tiles */
  for ( i = 1; i <= 20 ; i++ ) {

     /* make a random rect */
     r.UTDLLX = UTD_PICK_INT ( MINXY, MAXXY - 1 ) ;
     r.UTDURX = UTD_PICK_INT ( (INT)r.UTDLLX + 1, (INT)MAXXY  ) ;
     r.UTDLLY = UTD_PICK_INT ( MINXY, MAXXY - 1 ) ;
     r.UTDURY = UTD_PICK_INT ( (INT)r.UTDLLY + 1, (INT)MAXXY  ) ;

#ifdef TEST_FLOAT
     r.LLX /= 3.0 ;
     r.URX *= 1.04 ;
     r.LLY /= 1.28 ;
     r.URY *= 1.12 ;
#endif /* TEST_FLOAT */
    
     /* pick a random color */
     c = UTD_PICK_INT ( 1, 10 ) ;

     /* add the random tile */
     utDtile_add ( plane_p, &r, VOIDPTR_TYPE(c) ) ;

  }

  if( utDtile_verify_plane(plane_p) ){
    fprintf( stderr, "Error in the tile plane.\n" ) ;
  }

  /* -----------------------------------------------------------------
   * Find a tile greater than 4.
  ----------------------------------------------------------------- */
  save_tile = NULL ;
  for( tp = _utDtile_enumerate( plane_p, &areaS, NULL ) ; tp ;
      tp = _utDtile_enumerate( plane_p, &areaS, tp ) ){
    if( (LONG)(tp->data) > 4 ){
      save_tile = tp ;
      break ;
    }
  }

  /* -----------------------------------------------------------------
   * Now test the delete function.
  ----------------------------------------------------------------- */
  if( save_tile ){
    fprintf( stderr, "Check of delete tile.\n" ) ;
    utDtile_rect( save_tile, &save_rect ) ;
    fprintf( stderr, "Deleted tile: (%.0f %.0f) (%.0f %.0f)\n",
      save_rect.UTDLLX, save_rect.UTDLLY, save_rect.UTDURX, save_rect.UTDURY ) ;
    utDtile_delete( plane_p, save_tile ) ;
    /* now redraw the data */

    for( tp = _utDtile_enumerate( plane_p, &areaS, NULL ) ; tp ;
	tp = _utDtile_enumerate( plane_p, &areaS, tp ) ){
      print_tile (plane_p, tp, FALSE ) ;
    }
  }

  /* now check enumeration of a single point */
  /* -----------------------------------------------------------------
   * To get the tiles touching a single point you must expand the area
   * to be non-null.
  ----------------------------------------------------------------- */
  r.UTDLLX = 745 - 1 ;
  r.UTDURX = 745 + 1 ;
  r.UTDLLY = 674 - 1 ;
  r.UTDURY = 674 + 1 ;

  fprintf( stderr, "Using tile_enumerate...\n" ) ;
  for( tp = _utDtile_enumerate( plane_p, &r, NULL ) ; tp ;
      tp = _utDtile_enumerate( plane_p, &r, tp ) ){
      print_tile( plane_p, tp, TRUE ) ;
  }

  x = 9724.00 ;
  y = 3542.97 ;
  fprintf( stderr, "Looking for tile @ (%.2f %.2f)\n", x, y ) ;

  tp = utDtile_find( plane_p, x, y ) ;
  if( tp ){
    utDtile_rect( tp, &r ) ;
    fprintf( stderr, "Found tile:%.2f %.2f %.2f %.2f\n",
      r.UTDLLX, r.UTDLLY, r.UTDURX, r.UTDURY ) ;
  } else {
    fprintf( stderr, "Could not find a tile at %.0f,%.0f\n", x, y ) ;
  }

  fprintf( stderr, "During tile memory use:%ld\n", utDmalloc_use() ) ;

  utDtile_free ( plane_p ) ;
  PlaneS = NULL ;
} /* end one_round() */

int main(int argc, char **argv)
{
  int i ;
  int init_use ;
  UTDTILERECT r ;
  UTDTILEPTR tp ;
  UTDTILEPTR adj_tp ;
  UTDTILERECT tmp_rect ;
  UTDPLANEPTR plane_p ;

  utDmempool_enable(TRUE) ;
  plane_p = _utDtile_init( NULL, NULL, 1000, UTDPLANE_MAX_VERT ) ;
  utDtile_free( plane_p ) ;

  /* set up bounds of test area */
  areaS.UTDLLX = areaS.UTDLLY = MINXY ;
  areaS.UTDURX = areaS.UTDURY = MAXXY ;

  init_use = utDmalloc_use() ;
  fprintf( stderr, "Before Tile memory use:%d\n", init_use ) ;

  for( i = 1 ; i <= 1 ; i++ ){
    one_round(FALSE,i) ;
  }
  one_round(TRUE,i) ;

  fprintf( stderr, "After     tile memory use:%ld\n", utDmalloc_use() ) ;
  fprintf( stderr, "Beginning tile memory use:%d\n", init_use ) ;

  /* -----------------------------------------------------------------
   * Now test the enumeration macros for each corner.
  ----------------------------------------------------------------- */
  plane_p = PlaneS = _utDtile_init( NULL, NULL, 1000, UTDPLANE_MAX_VERT ) ;
  r.UTDLLX = 3.0 ;
  r.UTDLLY = 5.0 ;
  r.UTDURX = 11.0 ;
  r.UTDURY = 17.0 ;
  utDtile_add ( plane_p, &r, (VOIDPTR) 3 ) ;
  fprintf( stderr, "Left side:\n" ) ;
  areaS.UTDLLX = INT_MIN ;
  areaS.UTDURX = 3.0 ;
  areaS.UTDLLY = INT_MIN ;
  areaS.UTDURY = INT_MAX ;
  for( tp = _utDtile_enumerate( plane_p, &areaS, NULL ) ; tp ; 
       tp = _utDtile_enumerate( plane_p, &areaS, tp ) ){
    print_tile(plane_p,tp,TRUE) ;
  }
  fprintf( stderr, "Right side:\n" ) ;
  areaS.UTDLLX = 11.0 ;
  areaS.UTDURX = INT_MAX ;
  areaS.UTDLLY = INT_MIN ;
  areaS.UTDURY = INT_MAX ;
  for( tp = _utDtile_enumerate( plane_p, &areaS, NULL ) ; tp ; 
       tp = _utDtile_enumerate( plane_p, &areaS, tp ) ){
    print_tile(plane_p,tp,TRUE) ;
  }

  fprintf( stderr, "Bottom side:\n" ) ;
  areaS.UTDLLX = INT_MIN ;
  areaS.UTDURX = INT_MAX ;
  areaS.UTDLLY = INT_MIN ;
  areaS.UTDURY = 5.0 ;
  for( tp = _utDtile_enumerate( plane_p, &areaS, NULL ) ; tp ; 
       tp = _utDtile_enumerate( plane_p, &areaS, tp ) ){
    print_tile(plane_p,tp,TRUE) ;
  }

  fprintf( stderr, "Top side:\n" ) ;
  areaS.UTDLLX = INT_MIN ;
  areaS.UTDURX = INT_MAX ;
  areaS.UTDLLY = 17.0 ;
  areaS.UTDURY = INT_MAX ;
  for( tp = _utDtile_enumerate( plane_p, &areaS, NULL ) ; tp ; 
       tp = _utDtile_enumerate( plane_p, &areaS, tp ) ){
    print_tile(plane_p,tp,TRUE) ;
  }

  for( tp = utDtile_enumerate_all( plane_p, NULL ) ; tp ; 
       tp = utDtile_enumerate_all( plane_p, tp ) ){

      if(!(tp->data)){
	continue ;
      }
      /* -----------------------------------------------------------------
       * Traverse the adjacent tiles and union them together if they
       * are the same net and a valid routing type.
      ----------------------------------------------------------------- */
      fprintf( stderr, "Left side:\n" ) ;
      for( UTDTILE_WALKLEFTSIDE( tp, adj_tp, tmp_rect) ){
	print_tile(plane_p,adj_tp,TRUE) ;
      }
      fprintf( stderr, "Right side:\n" ) ;
      for( UTDTILE_WALKRIGHTSIDE( tp, adj_tp, tmp_rect) ){
	print_tile(plane_p,adj_tp,TRUE) ;
      }
      fprintf( stderr, "Bottom side:\n" ) ;
      for( UTDTILE_WALKBOTTOMSIDE( tp, adj_tp, tmp_rect) ){
	print_tile(plane_p,adj_tp,TRUE) ;
      }
      fprintf( stderr, "Top side:\n" ) ;
      for( UTDTILE_WALKTOPSIDE( tp, adj_tp, tmp_rect) ){
	print_tile(plane_p,adj_tp,TRUE) ;
      }
  }

  exit(0) ;

} /* end main() */

#endif /* TEST */
