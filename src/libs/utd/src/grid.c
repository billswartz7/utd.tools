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
#include <utdconfig.h>
#include <utd/base.h>
#include <utd/grid.h>

/* ***************************************************************** */
/* force coordinate to closest xy grid position */
void utDgrid_force(UTDGRIDPTR grid_p, DOUBLE *x, DOUBLE *y)
{
    *x = utDgridx( grid_p, *x ) ;
    *y = utDgridy( grid_p, *y ) ;
} /* end utDgrid_force() */

/* force coordinate to closest x grid position */
DOUBLE utDgridx(UTDGRIDPTR grid_p,DOUBLE x)
{

    DOUBLE newx ;			/* x on the grid */
    DOUBLE numgrids ;			/* number of grids from origin */

    if( FLOAT_EQ(grid_p->xgrid,0.0) ){
      return( x ) ;
    }
    numgrids = floor( (x - grid_p->offsetx) / grid_p->xgrid ) ;
    newx = numgrids * grid_p->xgrid + grid_p->offsetx ;

    if( ABS(newx + grid_p->xgrid - x) < ABS(newx - x) ) {
	newx += grid_p->xgrid ;
    }
    /* now return values */
    return(newx) ;
} /* end utDgridx() */


/* force coordinate to closest y grid position */
DOUBLE utDgridy(UTDGRIDPTR grid_p,DOUBLE y)
{
    DOUBLE newy ;			/* y on the grid */
    DOUBLE numgrids ;			/* number of grids from origin */

    if( FLOAT_EQ(grid_p->ygrid,0.0) ){
      return( y ) ;
    }
    numgrids = floor( (y - grid_p->offsety) / grid_p->ygrid ) ;
    newy = numgrids * grid_p->ygrid + grid_p->offsety ;

    if( ABS(newy + grid_p->ygrid - y) < ABS(newy - y) ) {
	newy += grid_p->ygrid ;
    }
    /* now return values */
    return(newy) ;
} /* end utDgridy() */

/* force coordinate to smallest x grid position */
DOUBLE utDgridx_down(UTDGRIDPTR grid_p, DOUBLE x)
{
    DOUBLE newx ;			/* x on the grid */
    DOUBLE numgrids ;			/* number of grids from origin */

    if( FLOAT_EQ(grid_p->xgrid,0.0) ){
      return( x ) ;
    }
    numgrids = floor( (x - grid_p->offsetx) / grid_p->xgrid ) ;
    newx = numgrids * grid_p->xgrid + grid_p->offsetx ;

    if( newx > x ){
	newx -= grid_p->xgrid ;
    }
    /* now return values */
    return(newx) ;
} /* end utDgridx_down() */

/* force coordinate to smallest y grid position */
DOUBLE utDgridy_down(UTDGRIDPTR grid_p, DOUBLE y)
{
    DOUBLE newy ;			/* y on the grid */
    DOUBLE numgrids ;			/* number of grids from origin */

    if( FLOAT_EQ(grid_p->ygrid,0.0) ){
      return( y ) ;
    }
    numgrids = floor( (y - grid_p->offsety) / grid_p->ygrid ) ;
    newy = numgrids * grid_p->ygrid + grid_p->offsety ;
    if( newy > y ){
	newy -= grid_p->ygrid ;
    }

    /* now return values */
    return(newy) ;

} /* end utDgridy_down() */

/* round coordinate to larger x grid position */
DOUBLE utDgridx_up(UTDGRIDPTR grid_p, DOUBLE x)
{
    DOUBLE newx ;			/* x on the grid */
    DOUBLE numgrids ;			/* number of grids from origin */

    if( FLOAT_EQ(grid_p->xgrid,0.0) ){
      return( x ) ;
    }
    numgrids = floor( (x - grid_p->offsetx) / grid_p->xgrid ) ;
    newx = numgrids * grid_p->xgrid + grid_p->offsetx ;
    if( newx < x ) {
	newx += grid_p->xgrid ;
    }
    /* now return values */
    return(newx) ;
} /* end utDgridx_up() */

/* round coordinate to larger y grid position */
DOUBLE utDgridy_up(UTDGRIDPTR grid_p, DOUBLE y)
{
    DOUBLE newy ;			/* y on the grid */
    DOUBLE numgrids ;			/* number of grids from origin */

    if( FLOAT_EQ(grid_p->ygrid,0.0) ){
      return( y ) ;
    }
    numgrids = floor( (y - grid_p->offsety) / grid_p->ygrid ) ;
    newy = numgrids * grid_p->ygrid + grid_p->offsety ;
    if( newy < y ) {
      newy += grid_p->ygrid ;
    }
    /* now return values */
    return(newy) ;

} /* end utDgridy_up() */

/* Set an X grid coordinate system */
void utDgrid_setx(UTDGRIDPTR grid_p,DOUBLE x, DOUBLE offset)
{
    grid_p->xgrid = x ;
    grid_p->offsetx = offset ;
} /* end utDgrid_setx() */

/* Set an Y grid coordinate system */
void utDgrid_sety(UTDGRIDPTR grid_p, DOUBLE y, DOUBLE offset)
{
    grid_p->ygrid = y ;
    grid_p->offsety = offset ;
} /* end utDgrid_sety() */

/* Get the grid and offset of an X grid coordinate system */
void utDgrid_getx(UTDGRIDPTR grid_p, DOUBLE *x, DOUBLE *offset)
{
    *x = grid_p->xgrid ;
    *offset = grid_p->offsetx ;
} /* end utDgrid_getx() */

/* Get the grid and offset of an Y grid coordinate system */
void utDgrid_gety(UTDGRIDPTR grid_p, DOUBLE *y, DOUBLE *offset)
{
    *y = grid_p->ygrid ;
    *offset = grid_p->offsety ;
} /* end utDgrid_gety() */

/* return the grid index from origin for X coordinates - always rounded to int */
DOUBLE utDgrid_xindex(UTDGRIDPTR grid_p,DOUBLE x)
{
    DOUBLE numgrids ;			/* number of grids from origin */

    numgrids = floor( (x - grid_p->offsetx) / grid_p->xgrid ) ;
    return( numgrids ) ;
} /* end utDgrid_xindex() */

/* return the grid index from origin for Y coordinates - always rounded to int */
DOUBLE utDgrid_yindex(UTDGRIDPTR grid_p,DOUBLE y)
{
    DOUBLE numgrids ;			/* number of grids from origin */

    numgrids = floor( (y - grid_p->offsety) / grid_p->ygrid ) ;
    return( numgrids ) ;
} /* end utDgrid_yindex() */

/* Returns the real position of grid given an x index */
DOUBLE utDgrid_xpos(UTDGRIDPTR grid_p,INT xindex)
{
    DOUBLE pos ;			/* position */

    pos = grid_p->xgrid * xindex + grid_p->offsetx ;
    return(pos) ;
} /* end utDgridx_xpos() */

/* Returns the real position of grid given a y index */
DOUBLE utDgrid_ypos(UTDGRIDPTR grid_p,INT yindex)
{
    DOUBLE pos ;			/* position */

    pos = grid_p->ygrid * yindex + grid_p->offsety ;
    return(pos) ;
} /* end utDgrid_ypos() */


#ifdef TEST

#include <stdlib.h>

int main(void)
{
    DOUBLE x, y ;			/* original position */
    DOUBLE xgrid, ygrid ;		/* value of x and y grid */
    DOUBLE xoffset, yoffset ;		/* value of x and y offset */
    DOUBLE xnew, ynew ;			/* gridded position */
    DOUBLE xindex, yindex ;		/* x and y index */
    UTDGRIDBOX grid_info ;		/* grid information */

    /* test of the gridding routines */
    fprintf( stderr, "Set grid...\n" ) ;
    xgrid = 48 ; xoffset = 0 ;
    ygrid = 48 ; yoffset = 24 ;
    fprintf( stderr, " xgrid %.0f xoffset %.0f\n", xgrid, xoffset ) ;
    fprintf( stderr, " ygrid %.0f yoffset %.0f\n", ygrid, yoffset ) ;

    fprintf( stderr, "first test positive numbers...\n" ) ;
    utDgrid_setx( &grid_info, xgrid, xoffset) ;
    utDgrid_sety( &grid_info, ygrid, yoffset) ;
    x = 25 ; y = 25 ;
    utDgrid_force( &grid_info, &x, &y);
    fprintf( stderr, "x:25 -> %.0f y: 25 -> %.0f\n", x, y ) ;
    x = 25 ; y = 25 ;
    xnew = utDgridx( &grid_info, x ) ;
    fprintf( stderr, "utDgridx: %.0f\n", xnew ) ;
    xnew = utDgridx_down( &grid_info, x ) ;
    fprintf( stderr, "utDgridx_down: %.0f\n", xnew ) ;
    xnew = utDgridx_up( &grid_info, x ) ;
    fprintf( stderr, "utDgridx_up: %.0f\n", xnew ) ;

    ynew = utDgridy( &grid_info, y ) ;
    fprintf( stderr, "utDgridy: %.0f\n", ynew ) ;
    ynew = utDgridy_down( &grid_info, y ) ;
    fprintf( stderr, "utDgridy_down: %.0f\n", ynew ) ;
    ynew = utDgridy_up( &grid_info, y ) ;
    fprintf( stderr, "utDgridy_up: %.0f\n", ynew ) ;

    xindex = utDgrid_xindex( &grid_info, xnew) ;
    yindex = utDgrid_yindex( &grid_info, ynew) ;
    fprintf( stderr, "(%.0f,%.0f) index : %.2f %.2f\n", 
	xnew, ynew, xindex, yindex ) ;


    /* now try negative numbers */
    x = xnew = -40 ; y = ynew = -25 ;
    utDgrid_force( &grid_info, &xnew, &ynew);
    fprintf( stderr, "x:%.0f -> %.0f y: %.0f -> %.0f\n", x, xnew, y, ynew ) ;
    xnew = utDgridx( &grid_info, x ) ;
    fprintf( stderr, "utDgridx: %.0f\n", xnew ) ;
    xnew = utDgridx_down( &grid_info, x ) ;
    fprintf( stderr, "utDgridx_down: %.0f\n", xnew ) ;
    xnew = utDgridx_up( &grid_info, x ) ;
    fprintf( stderr, "utDgridx_up: %.0f\n", xnew ) ;

    ynew = utDgridy( &grid_info, y ) ;
    fprintf( stderr, "utDgridy: %.0f\n", ynew ) ;
    ynew = utDgridy_down( &grid_info, y ) ;
    fprintf( stderr, "utDgridy_down: %.0f\n", ynew ) ;
    ynew = utDgridy_up( &grid_info, y ) ;
    fprintf( stderr, "utDgridy_up: %.0f\n", ynew ) ;

    xindex = utDgrid_xindex( &grid_info, xnew) ;
    yindex = utDgrid_yindex( &grid_info, ynew) ;
    fprintf( stderr, "(%.0f,%.0f) index : %.2f %.2f\n", 
	xnew, ynew, xindex, yindex ) ;

    fprintf( stderr, "test of grid to position:\n" ) ;
    fprintf( stderr, "(0,0) = %.2f, %.2f\n", 
      utDgrid_xpos( &grid_info, 0 ),
      utDgrid_xpos( &grid_info, 0 ) ) ;

    fprintf( stderr, "(1,1) = %.2f, %.2f\n", 
      utDgrid_xpos( &grid_info, 1 ),
      utDgrid_xpos( &grid_info, 1 ) ) ;
    fprintf( stderr, "(-1,-1) = %.2f, %.2f\n", 
      utDgrid_xpos( &grid_info, -1 ),
      utDgrid_xpos( &grid_info, -1 ) ) ;
    fprintf( stderr, "(3,-4) = %.2f, %.2f\n", 
      utDgrid_xpos( &grid_info, 3 ),
      utDgrid_xpos( &grid_info, -4 ) ) ;


    exit(0) ;

    
} /* end main() */

#endif /* TEST */

