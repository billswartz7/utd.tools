/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    grid.c                                       
DESCRIPTION:These routines grid data to the specified grid.
DATE:	    Oct 27, 1989 
REVISIONS:  Thu Apr 18 00:39:45 EDT 1991 - renamed functions so
		that names were consistent.
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_UTDGRID_H
#define INCLUDED_UTD_UTDGRID_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef struct {
  DOUBLE offsetx ;  /* initially set offset to zero */      
  DOUBLE offsety ;      
  DOUBLE xgrid ;    /* default grid is one */               
  DOUBLE ygrid ;        
} UTDGRIDBOX, *UTDGRIDPTR ;     

/* force coordinate to closest xy grid position */
extern void utDgrid_force(UTDGRIDPTR grid_p, DOUBLE *x, DOUBLE *y) ;

/* force coordinate to closest x grid position */
extern DOUBLE utDgridx(UTDGRIDPTR grid_p,DOUBLE x) ;

/* force coordinate to closest y grid position */
extern DOUBLE utDgridy(UTDGRIDPTR grid_p,DOUBLE y) ;

/* force coordinate to smallest x grid position */
extern DOUBLE utDgridx_down(UTDGRIDPTR grid_p, DOUBLE x) ;

/* force coordinate to smallest y grid position */
extern DOUBLE utDgridy_down(UTDGRIDPTR grid_p, DOUBLE y) ;

/* round coordinate to larger x grid position */
extern DOUBLE utDgridx_up(UTDGRIDPTR grid_p, DOUBLE x) ;

/* round coordinate to larger y grid position */
extern DOUBLE utDgridy_up(UTDGRIDPTR grid_p, DOUBLE y) ;

/* Set an X grid coordinate system */
extern void utDgrid_setx(UTDGRIDPTR grid_p,DOUBLE x, DOUBLE offset) ;

/* Set an Y grid coordinate system */
extern void utDgrid_sety(UTDGRIDPTR grid_p, DOUBLE y, DOUBLE offset) ;

/* Get the grid and offset of an X grid coordinate system */
extern void utDgrid_getx(UTDGRIDPTR grid_p, DOUBLE *x, DOUBLE *offset) ;

/* Get the grid and offset of an Y grid coordinate system */
extern void utDgrid_gety(UTDGRIDPTR grid_p, DOUBLE *y, DOUBLE *offset) ;

/* -----------------------------------------------------------------
 * Handy definitions.  To convert between grid index and real space.
----------------------------------------------------------------- */
/* return the grid index from origin for X coordinates - always rounded to int */
extern DOUBLE utDgrid_xindex(UTDGRIDPTR grid_p,DOUBLE x) ;

/* return the grid index from origin for Y coordinates - always rounded to int */
extern DOUBLE utDgrid_yindex(UTDGRIDPTR grid_p,DOUBLE y) ;

/* Returns the real position of grid given an x index */
extern DOUBLE utDgrid_xpos(UTDGRIDPTR grid_p,INT xindex) ;

/* Returns the real position of grid given a y index */
extern DOUBLE utDgrid_ypos(UTDGRIDPTR grid_p,INT yindex) ;


#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* INCLUDED_UTD_UTDGRID_H */
