/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    colors.h
DESCRIPTION:Color name definitions.
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_GUI_COLORS_H
#define INCLUDED_GUI_COLORS_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef enum {
  LINESOLID_T =         0,
  LINEONOFFDASH_T =     1,
  LINEDOUBLEDASH_T =    2,
} LINE_STYLE_T ;


typedef enum {
  UTDWHITE =		1,
  UTDBLACK =		2,
  UTDGRAY =		3,
  UTDRED =		4,
  UTDBLUE =		5,
  UTDYELLOW =		6,
  UTDGREEN =		7,
  UTDMAGENTA =		8,
  UTDCYAN =		9,
  UTDORANGE =		10,
  UTDPURPLE =		11,
  UTDMEDAQUA =     	12,
  UTDBROWN =       	13,
  UTDLIGHTGREEN =  	14,
  UTDLIGHTBLUE =   	15,
  UTDLIGHTBROWN =  	16,
  UTDNAVY =        	17,
  UTDLIGHTVIOLET = 	18,
  UTDKHAKI =       	19,
  UTDMOTIF =       	20
} UTDCOLOR_T ;

#define UTDNUMCOLORS	20
#define UTDSTIPPLE0	"gray75"
#define UTDSTIPPLE1	"gray50"
#define UTDSTIPPLE2	"gray25"
#define UtDSTIPPLE3	"gray12"
#define UTDSTIPPLE_DEFAULT	UTDSTIPPLE1

/* -----------------------------------------------------------------
 * Add a new color with given color and stipple if create is TRUE.
 * Returns colors index to be used with drawing calls.  If create is
 * false just look to see if color has been added.
 * ----------------------------------------------------------------- */
extern INT utDGUIcolor_add( const char *color, const char *stipple,INT unique,BOOL create ) ;

/* -----------------------------------------------------------------
 * Given a color graphics context index return name of color.
 * ----------------------------------------------------------------- */
extern const char *utDGUIcolor_name(INT color_idx) ;

/* -----------------------------------------------------------------
 * Given a color graphics context index return name of stipple.
 * ----------------------------------------------------------------- */
extern const char *utDGUIcolor_stipple(INT color_idx) ;

/* -----------------------------------------------------------------
 * Given a color graphics context index return the unique name identifier.
 * ----------------------------------------------------------------- */
extern INT utDGUIcolor_unique(INT color_idx) ;

/* -----------------------------------------------------------------
 * Given a standard color name index return the color name string
 * ----------------------------------------------------------------- */
extern const char *utDGUIcolor_std(INT id) ;

/* -----------------------------------------------------------------
 * Return the number of standard colors.
 * ----------------------------------------------------------------- */
extern INT utDGUIcolor_numstd(void) ;

/* -----------------------------------------------------------------
 * Return the current number of colors.
 * ----------------------------------------------------------------- */
extern INT utDGUIcolor_number(void) ;

/* -----------------------------------------------------------------
 * Add stipple to an existing color and create a new GC if necessary.
 ----------------------------------------------------------------- */
extern INT utDGUIcolor_add_stipple(INT color_idx,const char *stipple) ;

/* -----------------------------------------------------------------
 * Return the path to stipple.
 ----------------------------------------------------------------- */
extern char *utDGUIstipple_path( char *shortname, char *buffer ) ;

/* -----------------------------------------------------------------
 * Chooses either Xor of Copy mode.
 ----------------------------------------------------------------- */
extern void utDGUIcolorXutD( INT color,BOOL exorFlag ) ;

/* -----------------------------------------------------------------
 * Set line width to be drawn.  Returns old line size.
 ----------------------------------------------------------------- */
extern INT utDGUIcolor_line_width(INT gc,INT width) ;

/* -----------------------------------------------------------------
 * Set line style to be drawn.  Returns old line style.
 ----------------------------------------------------------------- */
extern INT utDGUIcolor_line_style(INT gc,INT line_style) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */


#endif /* INCLUDED_GUI_COLORS_H */
