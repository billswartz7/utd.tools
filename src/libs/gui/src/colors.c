/* ----------------------------------------------------------------- 
     Copyright (c) 2018 William Swartz.  All rights reserved.
FILE:	    colors.c                                       
DESCRIPTION:Manipulate colors of the display
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef lint
static char SccsId[] = 
"$RCSfile$ $Revision$ $Date$" ;
#endif

#include "config.h"
#include <utd/base.h>
#include <utd/file.h>
#include <utd/dstring.h>
#include <utd/msg.h>
#include <utd/string.h>
#include <tcl/tcl.h>
#include <tk/tk.h>
#include <tix/tix.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <gui/gc.h>
#include "open_gui_int.h"
#include <gui/gui.h>

/* ********************** TYPE DEFINITIONS ************************* */
typedef struct file_match_rec {
  Tcl_Interp *i_p ;
  const char *match ;
  const char *alt_match ;
  BOOL found ;
  BOOL prefix ;
} FILE_MATCH, *FILE_MATCHPTR ;

extern Tcl_HashTable * TkGetBitmapPredefTable(void) ;
/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static INT check_verbose_flag( INT objc, Tcl_Obj * const objv[] ) ;
static INT otguicolor_index( char *colorname, char *stipple, INT unique_id ) ;
static INT get_color_index_obj( Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[],INT *id_ret ) ;
static BOOL stipple_is_built_in( const char *stipple_name ) ;
static void load_default_gc_values( GraphicsContextPtr gcon_p,GC gc_p, 
                                    unsigned long *masks,XGCValues *gcValues) ;
static void output_color_value( Tcl_Interp *i_p,GraphicsContextPtr gc_p,unsigned long pixel_val ) ;
static void color_error_obj( Tcl_Interp *i_p, INT objc, Tcl_Obj * const objv[] ) ;
static void list_file( char *directory, char *filename, VOIDPTR user_data ) ;
static void list_stipple( Tcl_Interp *i_p, GraphicsContextPtr gc_p, FILE_MATCHPTR info_p ) ;
static void list_builtin( Tcl_Interp *i_p ) ;

/* ***************** GLOBAL VARIABLE DEFINITIONS ******************* */
extern long utDGUIcolor_table_find( void *pointer_p, const char *key ) ;
extern void utDGUIcolor_table_insert( void *pointer_p, const char *key, long value ) ;


void utDGUIinitcolors( GraphicsContextPtr gcon_p ) {
    INT i ;			/* color counter */
    BOOL default_hcolor ;	/* using default highlite color */
    const char *color ;		/* color index */
    const char *hcolor ;	/* highlight color */
    const char **stdcolor ;	/* pointer to stdcolor array */
    unsigned long whitepix ;	/* white pixel */
    unsigned long blackpix ;	/* black pixel */
    unsigned long backgrd ;	/* background pixel */
    unsigned long luminosity ;	/* total luminosity */
    long masks ;		/* mask for routines */
    Colormap colormap ;		/* color map for window */
    GC gc_p ;			/* graphics context pointer */
    XColor *ecolor ;  		/* exact color - do need to use it */
    XGCValues gcValues ;	/* GC values */
    Screen *screen ;		/* screen value */
    BOOL fatal ;		/* if true abort */
    Tk_Uid color_uid ;		/* unique id */
    FUNC_NAME("initcolors") ;

    if(!(gcon_p->drawWindow)){
      return ; /* we can't do anything */
    }
    /* allocate array for whether color is turned on or off */
    /* allocate initial size of graphic context one for each color */
    fatal = FALSE ;
    gcon_p->color_alloc = 1 ;
    gcon_p->numColor = 0 ;
    gcon_p->colorOn = UTDMALLOC( 1, BOOL ) ;
    gcon_p->graphicContext = UTDMALLOC( 1, GC ) ;
    gcon_p->ecolor = UTDMALLOC( 1, XColor * ) ;
    gcon_p->stipple_name = UTDCALLOC( 1, char * ) ;
    colormap = Tk_Colormap(gcon_p->drawWindow);
    screen = ScreenOfDisplay( gcon_p->dpy, gcon_p->screen ) ;
    whitepix = WhitePixelOfScreen( screen ) ;
    blackpix = BlackPixelOfScreen( screen ) ;

    /* -----------------------------------------------------------------
     * Set the background color.
    ----------------------------------------------------------------- */
    if(!(gcon_p->background_color_name)){
      gcon_p->background_color_name = "black" ;
    }
    color_uid = Tk_GetUid((char *) gcon_p->background_color_name) ;
    ecolor = Tk_GetColor(gcon_p->interp, gcon_p->drawWindow, color_uid ) ;
    if(!(ecolor)){
      utDmsgf(ERRMSG,"initcolors:1", routine, "%s for background is not a valid color\n", 
	gcon_p->background_color_name ) ;
      return ;
    }
    luminosity = ecolor->red + ecolor->green + ecolor->blue ;
    /* 89599 is 45.57 % of white */
    if( luminosity < 89599 ){
      gcon_p->defaultBorderColor = UTDWHITE ;
    } else {
      gcon_p->defaultBorderColor = UTDBLACK ;
    }
    gcon_p->borderColor = gcon_p->defaultBorderColor ;
    masks = GCForeground | GCBackground ;
    gcValues.foreground = ecolor->pixel ;
    gcValues.background = ecolor->pixel ;
    gcon_p->background = Tk_GetGC(gcon_p->drawWindow,masks,&gcValues) ;
    gcon_p->backgrd = backgrd = ecolor->pixel ;	/* background pixel */

    /* -----------------------------------------------------------------
     * Make highlite color based on user input if given.  If user screws
     * up just use default.
     * ----------------------------------------------------------------- */
    default_hcolor = FALSE ;
    hcolor = XGetDefault( gcon_p->dpy, GRAPHICS, "highlight_color" ) ;
    if(!(hcolor)){
      hcolor = DEFAULT_HIGHLIGHT_COLOR ;
      default_hcolor = TRUE ;
    }
    color_uid = Tk_GetUid( (char *)hcolor) ;
    ecolor = Tk_GetColor(gcon_p->interp,gcon_p->drawWindow, color_uid ) ;
    if(!(ecolor)){
      utDmsgf(ERRMSG,"OTinitcolors:2", routine, 
	"could not allocate highlight color:%s\n", hcolor ) ;
      if( default_hcolor ){
	return ;
      }
      color_uid = Tk_GetUid(DEFAULT_HIGHLIGHT_COLOR) ;
      ecolor = Tk_GetColor(gcon_p->interp,gcon_p->drawWindow, color_uid ) ;
      if(!(ecolor)){
	utDmsgf(ERRMSG,"OTinitcolors:3", routine, 
	  "major problem: could not allocate highlight color:%s\n",
	  DEFAULT_HIGHLIGHT_COLOR ) ;
	return ;
      }
    }


    masks = GCForeground | GCBackground | GCLineWidth | GCFont | GCLineStyle ;
    gcValues.foreground = ecolor->pixel ;
    gcValues.background = backgrd ;
    gcValues.function = GXcopy ;
    gcValues.line_style = LineDoubleDash ;
    masks |= GCFunction ;
    gcValues.line_width = 2 ;
    gcValues.font = gcon_p->font ;
    gc_p = gcon_p->graphicContext[0] = Tk_GetGC(gcon_p->drawWindow,masks,&gcValues) ;
    gcon_p->colorOn[0] = TRUE ;
    gcon_p->ecolor[0] = ecolor ;

    /* -----------------------------------------------------------------
     * Now allocate our standard minimum colors.
     * ----------------------------------------------------------------- */
    stdcolor = gcon_p->stdcolorArray ;
    stdcolor[0]	= "white" ;
    stdcolor[UTDWHITE] = "white" ;
    stdcolor[UTDBLACK] = "black" ;
    stdcolor[UTDGRAY] = "gray" ;
    stdcolor[UTDRED] = "red" ;
    stdcolor[UTDBLUE] = "blue" ;
    stdcolor[UTDYELLOW] = "yellow" ;
    stdcolor[UTDGREEN] = "green" ;
    stdcolor[UTDMAGENTA] = "magenta" ;
    stdcolor[UTDCYAN] = "cyan" ;
    stdcolor[UTDORANGE] = "orange" ;
    stdcolor[UTDPURPLE] = "purple" ;
    stdcolor[UTDMEDAQUA] = "MediumAquamarine" ;
    stdcolor[UTDBROWN] = "firebrick" ;
    stdcolor[UTDLIGHTGREEN] = "SpringGreen" ;
    stdcolor[UTDLIGHTBLUE] = "SteelBlue" ;
    stdcolor[UTDLIGHTBROWN] = "gold" ;
    stdcolor[UTDNAVY] = "navy" ;
    stdcolor[UTDLIGHTVIOLET] = "thistle" ;
    stdcolor[UTDKHAKI] = "khaki" ;
    stdcolor[UTDMOTIF] = "DodgerBlue" ;
    for( i = 1 ; i <= UTDNUMCOLORS ; i++ ){
      utDGUIcolor_add( stdcolor[i], NULL, 0, TRUE ) ;
    }
    
} /* end utDGUIinitcolor() */

INT utDGUIcolor_numstd(void)
{
    return( UTDNUMCOLORS ) ;
} /* utDGUIcolor_numstd() */

INT utDGUIcolor_number(void)
{
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(0) ;
    }
    return( gc_p->numColor ) ;

} /* utDGUIcolor_number() */

const char *utDGUIcolor_std(INT idx)
{
    const char *color ;		/* standard color */
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(NULL) ;
    }

    if( idx >= 0 && idx <= UTDNUMCOLORS ){
      color = gc_p->stdcolorArray[idx] ;
      return(color) ;
    }
    return(NULL) ;
} /* end utDGUIcolor_std() */

const char *utDGUIcolor_name(INT color_idx)
{
    const char *color ;	/* color stipple */
    XColor *this_ecolor ;	/* exact X color */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(NULL) ;
    }
    if( color_idx >= 0 && color_idx <= gc_p->numColor ){
      this_ecolor = gc_p->ecolor[color_idx] ;
      if( this_ecolor ){
	color = Tk_NameOfColor(this_ecolor) ;
	return(color) ;
      }
    }
    return(NULL) ;
} /* end utDGUIcolor_name() */

const char *utDGUIcolor_stipple(INT color_idx)
{
    char *stipple ;		/* color stipple */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(NULL) ;
    }

    if( color_idx >= 0 && color_idx <= gc_p->numColor ){
      stipple = gc_p->stipple_name[color_idx] ;
      return(stipple) ;
    }
    return(NULL) ;
} /* end utDGUIcolor_stipple() */

INT utDGUIcolor_unique(INT color_idx)
{
    INT unique ;		/* unique id */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(0) ;
    }
    if( color_idx >= 0 && color_idx <= gc_p->numColor ){
      unique = gc_p->unique_name[color_idx] ;
      return(unique) ;
    }
    return(0) ;
} /* end utDGUIcolor_unique() */

/* -----------------------------------------------------------------
 * Add stipple to an existing color and create a new GC if necessary.
----------------------------------------------------------------- */
INT utDGUIcolor_add_stipple(INT color_idx,const char *stipple)
{
    INT color ;		/* color id */
    INT unique_id ;		/* unique id */
    const char *colorname ;	/* text name of color */
    XColor *this_ecolor ;	/* exact X color */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(0) ;
    }
    if( color_idx >= 0 && color_idx <= gc_p->numColor ){
      this_ecolor = gc_p->ecolor[color_idx] ;
      if( this_ecolor ){
	colorname = Tk_NameOfColor(this_ecolor) ;
	unique_id = gc_p->unique_name[color_idx] ;
	color = utDGUIcolor_add( colorname, stipple, unique_id, TRUE ) ;
	return(color) ;
      }
    }
    return(0) ;
} /* end utDGUIcolor_add_stipple() */

INT utDGUIcolor_add( const char *color, const char *stipple, INT unique, BOOL create )
{
    INT new_flag ;		/* true if new entry */
    long color_index ;		/* color index into context array */
    const char *key ;		/* key for search */
    char *homedir ;		/* home directory */
    char keybuf[LRECL] ;	/* buffer for search key */
    char stipple_path[LRECL] ;	/* pathname for stipple pattern */
    long masks ;		/* mask for routines */
    XColor *ecolor ;  		/* exact color - do need to use it */
    XGCValues gcValues ;	/* GC values */
    Pixmap pixmap ;		/* stipple pixmap */
    Tcl_DString tilde_buf ;	/* used for graphics initialization */
    Tk_Uid bitmap_uid ;		/* unique id */
    Tk_Uid color_uid ;		/* unique id */
    Tcl_HashEntry *entry_p ;	/* curent entry */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */
    FUNC_NAME("OTcolor_add") ;

    if(!(color)){
      return(-1) ;
    }
    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(-1) ;
    }

    if( unique ){
      if( stipple && (utDstricmp( stipple, "none") != STRINGEQ) ){
	sprintf( keybuf, "%s:%s:%d", color, stipple, unique ) ;
      } else {
	sprintf( keybuf, "%s:%d", color, unique ) ;
      }
      key = keybuf ;
    } else {
      if( stipple && (utDstricmp( stipple, "none") != STRINGEQ) ){
	sprintf( keybuf, "%s:%s", color, stipple ) ;
	key = keybuf ;
      } else {
	key = color ;
      }
    }
    if(!(gc_p->color_htable)){
      gc_p->color_htable = UTDCALLOC( 1, Tcl_HashTable ) ;
      Tcl_InitHashTable(gc_p->color_htable, TCL_STRING_KEYS);
    }
    entry_p = Tcl_FindHashEntry( gc_p->color_htable, key ) ;
    if(!(entry_p)){
      if( create ){
	color_uid = Tk_GetUid((char *)color) ;
	ecolor = Tk_GetColor(gc_p->interp, gc_p->drawWindow, color_uid ) ;
	if(!(ecolor)){
	  utDmsgf(ERRMSG,"OTcolor_add:1", routine, "%s is not a valid color\n", color ) ;
	  return(0) ;
	}
	masks = GCForeground | GCBackground | GCLineWidth | GCFont ;
	gcValues.foreground = ecolor->pixel ;
	gcValues.background = gc_p->backgrd ;
	gcValues.line_width = DEF_LINE_WIDTH ;
	gcValues.font = gc_p->font ;
	if( stipple ){
	  /* This is a full pathname */
	  bitmap_uid = Tk_GetUid( (char *)stipple ) ;
	  pixmap = Tk_GetBitmap(gc_p->interp, gc_p->drawWindow, (char *)bitmap_uid ) ;
	  if( pixmap == None ){
	    /* look for shorted names in user directory */
	    homedir = Tcl_TildeSubst(gc_p->interp, UTD_HOMEDIR, &tilde_buf) ;
	    sprintf( stipple_path, "@%s/stipple/%s.bmp", homedir, stipple ) ;
	    bitmap_uid = Tk_GetUid( (char *) stipple_path ) ;
	    Tcl_ResetResult(gc_p->interp);
	    pixmap = Tk_GetBitmap(gc_p->interp, gc_p->drawWindow, (char *)bitmap_uid ) ;
	    if( pixmap == None ){
	      /* Now look for the name to contain .bmp explicitly */
	      sprintf( stipple_path, "@%s/stipple/%s", homedir, stipple ) ;
	      bitmap_uid = Tk_GetUid( stipple_path ) ;
	      Tcl_ResetResult(gc_p->interp);
	      pixmap = Tk_GetBitmap(gc_p->interp, gc_p->drawWindow, (char *)bitmap_uid ) ;
	    }
	  }
	  if( pixmap == None ){
	    /* look for shorted names in icdir/tcl/stipple dir */
	    sprintf( stipple_path, "@%s/tcl/stipple/%s.bmp", gc_p->utdgui, stipple ) ;
	    bitmap_uid = Tk_GetUid( stipple_path ) ;
	    Tcl_ResetResult(gc_p->interp);
	    pixmap = Tk_GetBitmap(gc_p->interp, gc_p->drawWindow, (char *)bitmap_uid ) ;
	    if( pixmap == None ){
	      /* Now look for the name to contain .bmp explicitly */
	      sprintf( stipple_path, "@%s/tcl/stipple/%s", gc_p->utdgui, stipple ) ;
	      bitmap_uid = Tk_GetUid( stipple_path ) ;
	      Tcl_ResetResult(gc_p->interp);
	      pixmap = Tk_GetBitmap(gc_p->interp, gc_p->drawWindow, (char *)bitmap_uid ) ;
	    }
	  }
	  if( pixmap != None ){
	    gcValues.stipple = pixmap ;
	    gcValues.fill_style = FillStippled ;
	    masks |= GCStipple | GCFillStyle ;
	  }
	}

	/* -----------------------------------------------------------------
	 * We haven't seen this color combo before add to graphics context 
	 * and colorOn arrays.
	 * ----------------------------------------------------------------- */
	color_index = ++gc_p->numColor ;
	if( color_index >= gc_p->color_alloc ){
	  gc_p->color_alloc *= 2 ;
	  gc_p->graphicContext = UTDVECTOR_REALLOC( gc_p->graphicContext, 0,
						  gc_p->color_alloc, GC ) ;
	  gc_p->colorOn = UTDVECTOR_REALLOC( gc_p->colorOn, 0,
						  gc_p->color_alloc, BOOL ) ;
	  gc_p->ecolor = UTDVECTOR_REALLOC( gc_p->ecolor, 0,
						  gc_p->color_alloc, XColor * ) ;
	  gc_p->stipple_name = UTDVECTOR_REALLOC( gc_p->stipple_name, 0,
						  gc_p->color_alloc, char * ) ;
	  gc_p->unique_name = UTDVECTOR_REALLOC( gc_p->unique_name, 0,
						  gc_p->color_alloc, INT ) ;
	}
	entry_p = Tcl_CreateHashEntry( gc_p->color_htable, key, &new_flag ) ;
	if( entry_p ){
	  Tcl_SetHashValue( entry_p, color_index ) ;
	}
	gc_p->graphicContext[color_index] = Tk_GetGC(gc_p->drawWindow,masks,&gcValues) ;
	gc_p->colorOn[color_index] = TRUE ;
	gc_p->ecolor[color_index] = ecolor ;
	gc_p->unique_name[color_index] = unique ;
	if( stipple ){
	  gc_p->stipple_name[color_index] = utDstrclone(stipple) ;
	} else {
	  gc_p->stipple_name[color_index] = NULL ;
	}
      } else {
	return(-1) ;
      }
    } else {
      color_index = (long) Tcl_GetHashValue(entry_p) ;
    }
    return( color_index ) ;

} /* end utDGUIcolor_add() */

char *utDGUIstipple_path( char *shortname, char *buffer )
{
    char *homedir ;		/* home directory */
    Tcl_DString tilde_buf ;	/* used for graphics initialization */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    /* already in cannonical form */
    if( shortname[0] == '@' ){
      strcpy( buffer, shortname ) ;
      return( buffer ) ;
    } else if ( shortname[0] == '/' ){
      buffer[0] = '@' ;
      strcpy( buffer+1, shortname ) ;
      return( buffer ) ;
    }
    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(NULL) ;
    }
    /* We look for stipple patterns in the following order */
    /* Short names in user directory */
    homedir = Tcl_TildeSubst(gc_p->interp,UTD_HOMEDIR, &tilde_buf) ;
    sprintf( buffer, "@%s/stipple/%s.bmp", homedir, shortname ) ;
    if( utDfileExists( buffer+1 ) ){ /* skip over @ */
      return( buffer ) ;
    }
    /* Explicit short names in user directory */
    sprintf( buffer, "@%s/stipple/%s", homedir, shortname ) ;
    if( utDfileExists( buffer+1 ) ){ /* skip over @ */
      return( buffer ) ;
    }
    /* Short names in utdgui/tcl/stipple */
    sprintf( buffer, "@%s/tcl/stipple/%s.bmp", gc_p->utdgui, shortname ) ;
    if( utDfileExists( buffer+1 ) ){ /* skip over @ */
      return( buffer ) ;
    }
    /* Explicit short names in utdgui/tcl/stipple */
    sprintf( buffer, "@%s/tcl/stipple/%s", gc_p->utdgui, shortname ) ;
    if( utDfileExists( buffer+1 ) ){ /* skip over @ */
      return( buffer ) ;
    }
    /* Tcl default */
    strcpy( buffer, shortname ) ;
    return( buffer ) ;
} /* end utDGUIstipple_path() */


void utDGUIcolorXOR( INT color,BOOL exorFlag )
{
    GraphicsContextPtr gc_p ;	/* graphics context pointer */
    FUNC_NAME("OTcolorXOR") ;

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }
    /* check to make sure color is valid */
    if( color <= 0 || color > gc_p->numColor ){
	if( gc_p->init ){ /* graphics are available */
	  utDmsgf( ERRMSG, "OTcolorXOR:1", routine, "Color number:%d is out of range", color ) ;
	} else {
	  fprintf( stderr,"Color number:%d is out of range", color ) ;
	}
	return ;
    }
    if( exorFlag ){
	XSetFunction( gc_p->dpy, gc_p->graphicContext[color], GXxor ) ;
    } else {
	XSetFunction( gc_p->dpy, gc_p->graphicContext[color], GXcopy ) ;
    }
} /* end utDGUIcolorXOR */

INT utDGUIcolor_line_width(INT gc,INT width)
{
    INT num_colors ;			/* number of colors */
    INT old_width ;			/* current width */
    XGCValues gcValues ;		/* GC values */
    unsigned long masks ;		/* request */
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(-1) ;
    }
    num_colors = gc_p->numColor ;
    if( gc < 0 || gc > num_colors ){
      return(-1) ;
    }
    load_default_gc_values( gc_p, gc_p->graphicContext[gc], &masks, &gcValues) ;
    old_width = gcValues.line_width ;
    if( width >= 0 ){
      gcValues.line_width = width ;
      gc_p->graphicContext[gc] = Tk_GetGC(gc_p->drawWindow,masks,&gcValues) ;
    }
    return( old_width ) ;
} /* end utDGUIcolor_line_width() */

INT utDGUIcolor_line_style(INT gc,INT line_style)
{
    INT num_colors ;			/* number of colors */
    INT old_style ;			/* current width */
    XGCValues gcValues ;		/* GC values */
    unsigned long masks ;		/* request */
    GraphicsContextPtr gc_p ;		/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return(-1) ;
    }
    num_colors = gc_p->numColor ;
    if( gc < 0 || gc > num_colors ){
      return(-1) ;
    }
    load_default_gc_values( gc_p, gc_p->graphicContext[gc], &masks, &gcValues) ;
    old_style = gcValues.line_style ;
    if( line_style >= 0 ){
      gcValues.line_style = line_style ;
      gc_p->graphicContext[gc] = Tk_GetGC(gc_p->drawWindow,masks,&gcValues) ;
    }
    return( old_style ) ;
} /* end utDGUIcolor_line_style() */


INT colors_objfunc(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * const objv[])
{
    INT id ;				/* layer id */
    INT idx ;				/* selection id */
    INT new_color ;			/* color id */
    INT eff_objc ;			/* effective objc without -verbose or -quiet */
    INT unique_no ;			/* unique id number */
    INT line_width ;			/* line width */
    INT num_colors ;			/* number of colors */
    unsigned long masks ;		/* request */
    char *val ;				/* user value */
    const char *pos ;			/* position */
    const char *color ;			/* color name */
    const char *color_name ;		/* color name */
    const char *stipple_name ;		/* stipple name */
    GraphicsContextPtr g_p ;		/* graphics context info */
    GC gc_p ;				/* graphics context pointer */
    XColor *ecolor ;  			/* exact color - do need to use it */
    XGCValues gcValues ;		/* GC values */
    XGCValues values ;			/* current GC values */
    Status status ;			/* return status */
    Tk_Uid color_uid ;			/* unique id */
    Tcl_Obj *resultPtr ;		/* result info */
    Tcl_Obj *strObj ;			/* string object */
    Tcl_Obj *boolObj ;			/* boolean object */
    Tcl_Obj *colorObj ;			/* color id object */
    char buffer[80] ;			/* scratch buffer */
    FUNC_NAME("otcolors") ;		/* function name */


    static char *optionStringsL[] = {
      "add",
      "background",
      "bordercolor",
      "capstyle",
      "draw",
      "foreground",
      "function",
      "globalbackground",
      "id",
      "ignore",
      "joinstyle",
      "linestyle",
      "linewidth",
      "liststipple",
      "name",
      "number",
      "path",
      "rgb",
      "rgb8",
      "state",
      "stipple",
      "swapbackground",
      NULL
    } ;

    enum options {
      ICCOLORS_ADD_T,
      ICCOLORS_BACKGROUND_T,
      ICCOLORS_BORDERCOLOR_T,
      ICCOLORS_CAPSTYLE_T,
      ICCOLORS_DRAW_T,
      ICCOLORS_FOREGROUND_T,
      ICCOLORS_FUNCTION_T,
      ICCOLORS_GLOBALBACKGROUND_T,
      ICCOLORS_ID_T,
      ICCOLORS_IGNORE_T,
      ICCOLORS_JOINSTYLE_T,
      ICCOLORS_LINESTYLE_T,
      ICCOLORS_LINEWIDTH_T,
      ICCOLORS_LIST_STIPPLE_T,
      ICCOLORS_NAME_T,
      ICCOLORS_NUMBER_T,
      ICCOLORS_PATH_T,
      ICCOLORS_RGB_T,
      ICCOLORS_RGB8_T,
      ICCOLORS_STATE_T,
      ICCOLORS_STIPPLE_T,
      ICCOLORS_SWAPBACKGROUND_T,
    } ;

    if( (objc < 2) || utDhelp_requested(objc,objv) ){
      pos = MSG_AT ;
      utDmsgf(ERRMSG, pos, routine, "Wrong # of args!\n" ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s add <colorname> [<stipplename>] [unique_id] : \
add a color.\nYou may specify an optional stipplename and may supply a unique \
id to make this color index unique.  A unique id allows you to make a color \
with specialized attributes.\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s bordercolor : returns the color index of the border \
color\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s bordercolor <colorname> [unique_id] : set the border color \
to the supplied color name and optional unique id.\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s bordercolor <color_id> : set the border color \
to the supplied color index (positive integer).\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s draw <colorid> : draw the color given id color or \
color name.\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s globalbackground [color | {0..maxpixel}] : sets the \
global background color of the canvas\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s id <name> : returns color id of a color string.\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s id <name> <stipple> : returns color id of a color and \
stipple.\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s id <name> <stipple> <unique_id> : returns color id \
given color, stipple, and unique id\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s ignore <colorid> : do not draw the color given id color or \
color name.\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s liststipple : lists available stipple patterns.", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s name <colorid> : returns name of a color given color id\n",
routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s number : returns number of colors defined.\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s path <stippleName> [-tk] : returns the full path of a \n\
stipple pattern. If the -tk option is supplied, the path is prefixed so to\n\
be valid for use in Tk widgets.\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s rgb <TkColor> : returns rgb value of Tk color\n", routine) ;
      utDmsgf(ERRMSG, pos, NULL, "%s rgb8 <TkColor> : returns 8 bit rgb value of Tk color\n", routine) ;
      utDmsgf(ERRMSG, pos, NULL, "%s state <colorid> : returns true if color is drawn.\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s stipple <colorid> : returns stipple for color id\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s swapbackground <colorid> : swaps the foreground and \
background colors of a color id\n", routine) ;

      utDmsgf(ERRMSG|MSG_PRELINE, pos, NULL, "The following functions modify the attributes of \
a color.  All of these functions work on the color id property.\n") ;
      utDmsgf(ERRMSG, pos, NULL, "%s background <colorid> [<TkColor>] : returns/sets the background \
color\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s capstyle <colorid> [butt | notlast | projecting | round] : \
sets path cap-style\n", routine) ;
      utDmsgf(ERRMSG, pos, NULL, "%s foreground <colorid> [0..maxpixel] : sets the foreground \
color\n", routine) ;
      utDmsgf(ERRMSG, pos, NULL, "%s function <colorid> [copy | xor | invert] : set the X \
function of a color\n", routine ) ;
      utDmsgf(ERRMSG, pos, NULL, "%s linestyle <colorid> [solid | doubledash | dash] : set \
the line style of a color\n", routine) ;
      utDmsgf(ERRMSG, pos, NULL, "%s linewidth <colorid> [integer] : set/get line width\n", routine) ;
      utDmsgf(ERRMSG, pos, NULL, "%s joinstyle <colorid> [bevel | miter | round] : sets how \
wide lines are drawn\n", routine ) ;
      return(TCL_ERROR) ;
    }

    Tcl_ResetResult(i_p) ;
    g_p = (GraphicsContextPtr) d_p ;
    if(!(g_p)){
      return(TCL_ERROR) ; /* not open for business */
    }

    if( Tcl_GetIndexFromObj(i_p,objv[1],optionStringsL,"option", 0, &idx ) != TCL_OK ){
      return(TCL_ERROR) ;
    }

    resultPtr = Tcl_GetObjResult(i_p) ;

    num_colors = g_p->numColor ;
    eff_objc = check_verbose_flag( objc, objv ) ;

    switch ( (enum options) idx) {
      case ICCOLORS_ADD_T:
	unique_no = 0 ;
	color_name = NULL ;
	stipple_name = NULL ;
	if( eff_objc >= 3 ){
	  color_name = Tcl_GetString(objv[2]) ;
	}
	if( eff_objc >= 4 ){
	  stipple_name = Tcl_GetString(objv[3]) ;
	}
	if( eff_objc >= 5 ){
	  if( Tcl_GetIntFromObj(i_p,objv[4],&unique_no) != TCL_OK ){
	    return(TCL_ERROR) ;
	  }
	}
	new_color = utDGUIcolor_add( color_name, stipple_name, unique_no,TRUE) ;
	colorObj = Tcl_NewIntObj( new_color ) ;
	Tcl_ListObjAppendElement( NULL,resultPtr, colorObj ) ;
	return(TCL_OK) ;

      case ICCOLORS_BACKGROUND_T:
	if( eff_objc < 3 ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( TCL_ERROR ) ;
	}
	/* limit color option to an id */
	status = get_color_index_obj( i_p, 3, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	if( eff_objc >= 4 ){
	  load_default_gc_values( g_p, g_p->graphicContext[id], &masks, &gcValues) ;
	  color = Tcl_GetString( objv[3] ) ;
	  color_uid = Tk_GetUid(color) ;
	  ecolor = Tk_GetColor(g_p->interp, g_p->drawWindow, color_uid ) ;
	  if( ecolor ){
	    gcValues.background = ecolor->pixel ;
	  } else {
	    Tcl_ResetResult(g_p->interp);
	    gcValues.background = atoi( color ) ;
	  }
	  g_p->graphicContext[id] = Tk_GetGC(g_p->drawWindow,masks,&gcValues) ;
	}
	masks = GCBackground ;
	gc_p = g_p->graphicContext[id] ;
	status = XGetGCValues( g_p->dpy, gc_p, masks, &values) ;
	output_color_value( i_p, g_p, values.background ) ;
	return(TCL_OK) ;

      case ICCOLORS_BORDERCOLOR_T:{
	INT bcolor_idx ;            /* border color index */
	if( eff_objc >= 3 ){
	  status = get_color_index_obj( i_p, eff_objc, objv, &id ) ;
	  if( status != TCL_OK ){
	    color_error_obj( i_p, objc, objv ) ;
	    return( status ) ;
	  }
	  utDGUIborder_color( id ) ;
	}
	bcolor_idx = utDGUIget_border_color() ;
	colorObj = Tcl_NewIntObj( bcolor_idx ) ;
	Tcl_ListObjAppendElement( NULL,resultPtr, colorObj ) ;
	return(TCL_OK) ;
      }

      case ICCOLORS_CAPSTYLE_T:
	if( eff_objc < 3 ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( TCL_ERROR ) ;
	}
	/* limit color option to an id */
	status = get_color_index_obj( i_p, 3, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	if( eff_objc >= 4 ){
	  load_default_gc_values( g_p, g_p->graphicContext[id], &masks, &gcValues) ;
	  val = Tcl_GetString( objv[3] ) ;
	  if( strcmp( val, "butt" ) == STRINGEQ ){
	    gcValues.cap_style = CapButt ;
	  } else if( strcmp( val, "notlast" ) == STRINGEQ ){
	    gcValues.cap_style = CapNotLast ;
	  } else if( strncmp( val, "projecting", 4 ) == STRINGEQ ){
	    gcValues.cap_style = CapProjecting ;
	  } else if( strcmp( val, "round" ) == STRINGEQ ){
	    gcValues.cap_style = CapRound ;
	  } else {
	    utDmsgf(ERRMSG,MSG_AT,routine,"Unknown cap style:%s\n", val ) ;
	    return(TCL_ERROR) ;
	  }
	  g_p->graphicContext[id] = Tk_GetGC(g_p->drawWindow,masks,&gcValues) ;
	}
	masks = GCCapStyle ;
	gc_p = g_p->graphicContext[id] ;
	status = XGetGCValues( g_p->dpy, gc_p, masks, &values) ;
	if( values.cap_style == CapButt ){
	  strObj = Tcl_NewStringObj( "butt", -1 ) ;
	} else if( values.cap_style == CapNotLast ){
	  strObj = Tcl_NewStringObj( "notlast", -1 ) ;
	} else if( values.cap_style == CapProjecting ){
	  strObj = Tcl_NewStringObj( "projecting", -1 ) ;
	} else if( values.cap_style == CapRound ){
	  strObj = Tcl_NewStringObj( "round", -1 ) ;
	} else {
	  utDmsgf(ERRMSG,MSG_AT,routine,"Unknown/unsupported cap_style value:%d\n", values.cap_style ) ;
	  return(TCL_ERROR) ;
	}
	Tcl_ListObjAppendElement( NULL,resultPtr,strObj ) ;
	return(TCL_OK) ;

      case ICCOLORS_DRAW_T:
	status = get_color_index_obj( i_p, eff_objc, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	g_p->colorOn[id] = TRUE ;
	return(TCL_OK) ;

      case ICCOLORS_FOREGROUND_T:
	if( eff_objc < 3 ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( TCL_ERROR ) ;
	}
	/* limit color option to an id */
	status = get_color_index_obj( i_p, 3, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	if( eff_objc >= 4 ){
	  load_default_gc_values( g_p, g_p->graphicContext[id], &masks, &gcValues) ;
	  color = Tcl_GetString( objv[3] ) ;
	  color_uid = Tk_GetUid(color) ;
	  ecolor = Tk_GetColor(g_p->interp, g_p->drawWindow, color_uid ) ;
	  if( ecolor ){
	    gcValues.foreground = ecolor->pixel ;
	  } else {
	    Tcl_ResetResult(g_p->interp);
	    gcValues.foreground = atoi( color ) ;
	  }
	  g_p->graphicContext[id] = Tk_GetGC(g_p->drawWindow,masks,&gcValues) ;
	}
	masks = GCForeground ;
	gc_p = g_p->graphicContext[id] ;
	status = XGetGCValues( g_p->dpy, gc_p, masks, &values) ;
	output_color_value( i_p, g_p, values.foreground ) ;
	return(TCL_OK) ;

      case ICCOLORS_FUNCTION_T:
	if( eff_objc < 3 ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( TCL_ERROR ) ;
	}
	/* limit color option to an id */
	status = get_color_index_obj( i_p, 3, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	if( eff_objc >= 4 ){
	  load_default_gc_values( g_p, g_p->graphicContext[id], &masks, &gcValues) ;
	  val = Tcl_GetString( objv[3] ) ;
	  if( strcmp( val, "copy" ) == STRINGEQ ){
	    gcValues.function = GXcopy ;
	  } else if( strcmp( val, "xor" ) == STRINGEQ ){
	    gcValues.function = GXxor ;
	  } else if( strcmp( val, "invert" ) == STRINGEQ ){
	    gcValues.function = GXinvert ;
	  } else {
	    utDmsgf(ERRMSG,MSG_AT,routine,"Unknown function:%s\n", val ) ;
	    return(TCL_ERROR) ;
	  }
	  g_p->graphicContext[id] = Tk_GetGC(g_p->drawWindow,masks,&gcValues) ;
	}
	masks = GCFunction ;
	gc_p = g_p->graphicContext[id] ;
	status = XGetGCValues( g_p->dpy, gc_p, masks, &values) ;
	if( values.function == GXcopy ){
	  strObj = Tcl_NewStringObj( "copy", -1 ) ;
	} else if( values.function == GXxor ){
	  strObj = Tcl_NewStringObj( "xor", -1 ) ;
	} else if( values.function == GXinvert ){
	  strObj = Tcl_NewStringObj( "invert", -1 ) ;
	} else {
	  utDmsgf(ERRMSG,MSG_AT,routine,"Unknown/unsupported function value:%d\n", values.function ) ;
	}
	Tcl_ListObjAppendElement( NULL,resultPtr,strObj ) ;
	return(TCL_OK) ;

      case ICCOLORS_GLOBALBACKGROUND_T:
	if( eff_objc >= 3 ){
	  color = Tcl_GetString( objv[2] ) ;
	  load_default_gc_values( g_p, g_p->background, &masks, &gcValues) ;
	  color_uid = Tk_GetUid(color) ;
	  ecolor = Tk_GetColor(g_p->interp, g_p->drawWindow, color_uid ) ;
	  if( ecolor ){
	    gcValues.background = ecolor->pixel ;
	  } else {
	    Tcl_ResetResult(g_p->interp);
	    gcValues.background = atoi( color ) ;
	  }
	  gcValues.foreground = gcValues.background ;
	  g_p->backgrd = gcValues.background ;
	  g_p->background = Tk_GetGC(g_p->drawWindow,masks,&gcValues) ;
	}
	masks = GCBackground ;
	gc_p = g_p->background ;
	status = XGetGCValues( g_p->dpy, gc_p, masks, &values) ;
	output_color_value( i_p, g_p, values.background ) ;
	return(TCL_OK) ;

      case ICCOLORS_ID_T:
	status = get_color_index_obj( i_p, eff_objc, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	colorObj = Tcl_NewIntObj( id ) ;
	Tcl_ListObjAppendElement( NULL,resultPtr, colorObj ) ;
	return(TCL_OK) ;

      case ICCOLORS_IGNORE_T:
	status = get_color_index_obj( i_p, eff_objc, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	g_p->colorOn[id] = FALSE ;
	return(TCL_OK) ;

      case ICCOLORS_JOINSTYLE_T:
	if( eff_objc < 3 ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( TCL_ERROR ) ;
	}
	/* limit color option to an id */
	status = get_color_index_obj( i_p, 3, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	if( eff_objc >= 4 ){
	  load_default_gc_values( g_p, g_p->graphicContext[id], &masks, &gcValues) ;
	  val = Tcl_GetString( objv[3] ) ;
	  if( strcmp( val, "bevel" ) == STRINGEQ ){
	    gcValues.join_style = JoinBevel ;
	  } else if( strcmp( val, "miter" ) == STRINGEQ ){
	    gcValues.join_style = JoinMiter ;
	  } else if( strcmp( val, "round" ) == STRINGEQ ){
	    gcValues.join_style = JoinRound ;
	  } else {
	    utDmsgf(ERRMSG,MSG_AT,routine,"Unknown join style:%s\n", val ) ;
	    return(TCL_ERROR) ;
	  }
	  g_p->graphicContext[id] = Tk_GetGC(g_p->drawWindow,masks,&gcValues) ;
	}
	masks = GCJoinStyle ;
	gc_p = g_p->graphicContext[id] ;
	status = XGetGCValues( g_p->dpy, gc_p, masks, &values) ;
	if( values.join_style == JoinBevel ){
	  strObj = Tcl_NewStringObj( "bevel", -1 ) ;
	} else if( values.join_style == JoinMiter ){
	  strObj = Tcl_NewStringObj( "miter", -1 ) ;
	} else if( values.join_style == JoinRound ){
	  strObj = Tcl_NewStringObj( "round", -1 ) ;
	} else {
	  utDmsgf(ERRMSG,MSG_AT,routine,"Unknown/unsupported join_style value:%d\n", values.join_style ) ;
	}
	Tcl_ListObjAppendElement( NULL,resultPtr,strObj ) ;
	return(TCL_OK) ;

      case ICCOLORS_LINESTYLE_T:
	if( eff_objc < 3 ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( TCL_ERROR ) ;
	}
	/* limit color option to an id */
	status = get_color_index_obj( i_p, 3, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	if( eff_objc >= 4 ){
	  load_default_gc_values( g_p, g_p->graphicContext[id], &masks, &gcValues) ;
	  val = Tcl_GetString( objv[3] ) ;
	  if( strcmp( val, "solid" ) == STRINGEQ ){
	    gcValues.line_style = LineSolid ;
	  } else if( strcmp( val, "doubledash" ) == STRINGEQ ){
	    gcValues.line_style = LineDoubleDash ;
	  } else if( strcmp( val, "dash" ) == STRINGEQ ){
	    gcValues.line_style = LineOnOffDash ;
	  } else {
	    utDmsgf(ERRMSG,MSG_AT,routine,"Unknown line_style:%s\n", val ) ;
	    return(TCL_ERROR) ;
	  }
	  g_p->graphicContext[id] = Tk_GetGC(g_p->drawWindow,masks,&gcValues) ;
	}
	masks = GCLineStyle ;
	gc_p = g_p->graphicContext[id] ;
	status = XGetGCValues( g_p->dpy, gc_p, masks, &values) ;

	if( values.line_style == LineSolid ){
	  strObj = Tcl_NewStringObj( "solid", -1 ) ;
	} else if( values.line_style == LineDoubleDash ){
	  strObj = Tcl_NewStringObj( "doubledash", -1 ) ;
	} else if( values.line_style == LineOnOffDash ){
	  strObj = Tcl_NewStringObj( "dash", -1 ) ;
	} else {
	  utDmsgf(ERRMSG,MSG_AT,routine,"Unknown/unsupported line_style value:%d\n", values.line_style ) ;
	}
	Tcl_ListObjAppendElement( NULL,resultPtr,strObj ) ;
	return(TCL_OK) ;

      case ICCOLORS_LINEWIDTH_T:
	if( eff_objc < 3 ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( TCL_ERROR ) ;
	}
	/* limit color option to an id */
	status = get_color_index_obj( i_p, 3, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	if( eff_objc >= 4 ){
	  status = Tcl_GetIntFromObj(i_p,objv[3],&line_width) ;
	  if( status != TCL_OK ){
	    return(status) ;
	  }
	  utDGUIcolor_line_width(id, line_width ) ;
	}
	masks = GCLineWidth ;
	gc_p = g_p->graphicContext[id] ;
	status = XGetGCValues( g_p->dpy, gc_p, masks, &values) ;
	colorObj = Tcl_NewIntObj( values.line_width ) ;
	Tcl_ListObjAppendElement( NULL,resultPtr,colorObj ) ;
	return(TCL_OK) ;

      case ICCOLORS_LIST_STIPPLE_T:
	list_builtin( i_p ) ;
	list_stipple( i_p, g_p, NULL ) ;
	return(TCL_OK) ;


      case ICCOLORS_NAME_T:
	status = get_color_index_obj( i_p, eff_objc, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	color = utDGUIcolor_name(id) ;
	if( color ){
	  Tcl_AppendResult(i_p, color, NULL ) ;
	} else {
	  Tcl_AppendResult(i_p, "-", NULL ) ;
	}
	return(TCL_OK) ;

      case ICCOLORS_NUMBER_T:
	colorObj = Tcl_NewIntObj( num_colors ) ;
	Tcl_ListObjAppendElement( NULL,resultPtr,colorObj ) ;
	return(TCL_OK) ;

      case ICCOLORS_PATH_T:{
	FILE_MATCH info ;
	UTDDSTRING new_stipple ;
	BOOL built_in ;	

	if( objc < 3 ){
	  utDmsgf(ERRMSG,MSG_AT,routine,"Not enough argument to %s path command\n", routine ) ;
	  return(TCL_ERROR) ;
	}
	stipple_name = Tcl_GetString( objv[2] ) ;
	built_in = stipple_is_built_in( stipple_name ) ;
	if( built_in ){
	  resultPtr = Tcl_GetObjResult(i_p) ;
	  strObj = Tcl_NewStringObj( stipple_name, -1 ) ;
	  Tcl_ListObjAppendElement( NULL,resultPtr,strObj ) ;
	} else {
	  utDdstring_init( &new_stipple ) ;
	  utDdstring_append( &new_stipple, stipple_name, -1 ) ;
	  utDdstring_append( &new_stipple, ".bmp", -1 ) ;
	  info.i_p = i_p ;
	  info.match = stipple_name ;
	  info.alt_match = utDdstring_value( &new_stipple ) ;
	  info.found = FALSE ;
	  if( objc >= 4 ){
	    info.prefix = TRUE ;
	  } else {
	    info.prefix = FALSE ;
	  }
	  list_stipple( i_p, g_p, &info ) ;
	  utDdstring_free( &new_stipple ) ;
	}
	return(TCL_OK) ;
      }

      case ICCOLORS_RGB_T:
	if( eff_objc < 3 ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( TCL_ERROR ) ;
	}
	color = Tcl_GetString( objv[2] ) ;
	color_uid = Tk_GetUid( color ) ;
	ecolor = Tk_GetColor(g_p->interp, g_p->drawWindow, color_uid ) ;
	if( ecolor ){
	  sprintf( buffer, "#%04x%04x%04x", ecolor->red, ecolor->green, ecolor->blue);
	  Tcl_AppendResult(i_p, buffer, NULL ) ;
	}
	return(TCL_OK) ;

      case ICCOLORS_RGB8_T:
	if( eff_objc < 3 ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( TCL_ERROR ) ;
	}
	color = Tcl_GetString( objv[2] ) ;
	color_uid = Tk_GetUid( color ) ;
	ecolor = Tk_GetColor(g_p->interp, g_p->drawWindow, color_uid ) ;
	if( ecolor ){
	  sprintf( buffer, "#%02x%02x%02x", ecolor->red/256, 
		   ecolor->green/256, ecolor->blue/256);
	  Tcl_AppendResult(i_p, buffer, NULL ) ;
	}
	return(TCL_OK) ;

      case ICCOLORS_STATE_T:
	status = get_color_index_obj( i_p, eff_objc, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	boolObj = Tcl_NewBooleanObj( g_p->colorOn[id] ) ;
	Tcl_ListObjAppendElement( NULL,resultPtr,boolObj ) ;
	return(TCL_OK) ;

      case ICCOLORS_STIPPLE_T:
	status = get_color_index_obj( i_p, eff_objc, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	if( g_p->stipple_name[id] ){
	  strObj = Tcl_NewStringObj( g_p->stipple_name[id], -1 ) ;
	  Tcl_ListObjAppendElement( NULL,resultPtr,strObj ) ;
	}
	return(TCL_OK) ;

      case ICCOLORS_SWAPBACKGROUND_T:
	if(!(g_p->graphicContext)){
	  return(TCL_ERROR) ;
	}
	status = get_color_index_obj( i_p, eff_objc, objv, &id ) ;
	if( status != TCL_OK ){
	  color_error_obj( i_p, objc, objv ) ;
	  return( status ) ;
	}
	gc_p = g_p->graphicContext[id] ;
	masks = GCForeground | GCBackground ;
	status = XGetGCValues( g_p->dpy, gc_p, masks, &values) ;
	SWAP( values.foreground, values.background, unsigned long) ;
	XChangeGC( g_p->dpy, gc_p, masks, &values ) ;
	return(TCL_OK) ;

      default: ;
    }

} /* end iccolors_objfunc() */


static void load_default_gc_values( GraphicsContextPtr gcon_p, GC gc_p, 
				    unsigned long *masks, XGCValues *gcValues)
{
  Status status ;			/* return status */

  *masks = GCCapStyle | GCFunction | GCForeground | GCBackground | GCLineWidth |
           GCLineStyle | GCFont | GCJoinStyle | GCStipple | GCFillStyle ;
  status = XGetGCValues( gcon_p->dpy, gc_p, *masks, gcValues) ;
  if( status ){
    if( gcValues->fill_style != FillStippled ){
      *masks = *masks & ~(GCStipple) ;
    }
  }

} /* end load_default_gc_values() */


static INT check_verbose_flag( INT objc, Tcl_Obj * const objv[] )
{
    char *last_arg ;		/* last argument */

    last_arg = Tcl_GetString( objv[objc-1] ) ;
    if( utDstrnicmp( last_arg, "-verbose", 4 ) == STRINGEQ ){
      return( objc - 1 ) ;
    }
    if( utDstrnicmp( last_arg, "-quiet", 4 ) == STRINGEQ ){
      return( objc - 1 ) ;
    }
    return( objc ) ;
} /* end check_verbose_flag() */

static void color_error_obj( Tcl_Interp *i_p, INT objc, Tcl_Obj * const objv[] )
{
    UTDDSTRING buf ;		/* message buffer */
    INT i ;			/* counter */
    BOOL verbose ;		/* verbose flag */
    char *msg ;			/* resulting message */
    char *last_arg ;		/* last argument */
    Tcl_Obj *strObj ;		/* build an error string */
    GraphicsContextPtr gc_p ;	/* graphics context pointer */

    gc_p = utDGUI_get_gc() ;
    if(!(gc_p)){
      return ;
    }

    utDdstring_init(&buf) ;
    if( objc < 3 ){
      utDdstring_append( &buf, "ERROR: wrong # of arguments:", -1 ) ;
    } else {
      utDdstring_printf(  &buf, "ERROR: color id is out of bounds: #colors:%d", 
	  (gc_p ? gc_p->numColor : 0) ) ;
    }
    utDdstring_append( &buf, " command:", -1 ) ;
    for( i = 0 ; i < objc ; i++ ){
      utDdstring_append( &buf, " ", -1 ) ;
      utDdstring_append( &buf, Tcl_GetString( objv[i]), -1 ) ;
    }
    msg = utDdstring_value( &buf ) ;

    /* Now look for verbose or quiet flag */
    verbose = TRUE ;
    last_arg = Tcl_GetString( objv[objc-1] ) ;
    if( utDstrnicmp( last_arg, "-quiet", 4 ) == STRINGEQ ){
      verbose = FALSE ;
    }
    if( verbose ){
      utDmsgf(IMSG,MSG_AT,"otcolors", "%s\n", msg ) ;
    }
    Tcl_AppendResult(i_p, msg, NULL ) ;

    utDdstring_free(&buf) ;

} /* end color_error_obj() */

static INT get_color_index_obj( Tcl_Interp *i_p,INT objc, Tcl_Obj * const objv[], INT *id_ret )
{
    char *color_name ;			/* color name */
    char *stipple_name ;		/* stipple name */
    INT status ;			/* return status */
    INT unique_no ;			/* unique id number */

    *id_ret = -2 ;
    if( objc < 3 ){
      return(TCL_ERROR) ;
    }
    color_name = Tcl_GetString(objv[2]) ;
    if( objc == 3 ){
      /* two case : color_name
       *            color_idx
       * */
      stipple_name = NULL ;
      unique_no = 0 ;

    } else if ( objc == 4 ){
      /* two cases : color stipple 
       *             color color_unique
       * */
      status = Tcl_GetIntFromObj(i_p,objv[3],&unique_no) ;
      if( status == TCL_OK ){
	stipple_name = NULL ;
      } else {
	stipple_name = Tcl_GetString(objv[3]) ;
	unique_no = 0 ;
      }
    } else if ( objc == 5 ){
      /* single case : color stipple stipple unique
       * */
      color_name = Tcl_GetString(objv[2]) ;
      stipple_name = Tcl_GetString(objv[3]) ;
      if( Tcl_GetIntFromObj(i_p,objv[3],&unique_no) != TCL_OK ){
	return(TCL_ERROR) ;
      }
    }

    *id_ret = otguicolor_index( color_name, stipple_name, unique_no ) ;
    if( *id_ret < 0 || *id_ret > utDGUIcolor_number() ){
      return(TCL_ERROR) ;
    }
    return(TCL_OK) ;
} /* end get_color_index_obj() */


/* -----------------------------------------------------------------
 * This function only looks for defined colors after looking at color ids.
 * Also searches for special highlight color.
----------------------------------------------------------------- */
static INT otguicolor_index( char *colorname, char *stipple, INT unique_id )
{
    INT id ;				/* color id */

    id = atoi( colorname ) ;
    if( id <= 0 ){
      id = utDGUIcolor_add(colorname,stipple,unique_id,FALSE) ;
      if( id <= 0 ){
	if( (*colorname == 'h') && (strcmp(colorname,"highlight") == STRINGEQ)){
	  return(0) ;
	}
	if( id <= 0 ){
	  id = -1 ;
	}
      }
    }
    return( id ) ;
} /* end otguicolor_index() */


static void output_color_value( Tcl_Interp *i_p, GraphicsContextPtr gc_p, 
                                unsigned long pixel_val )
{
    Colormap cmap ;				/* color map */
    XColor ecolors[2] ;				/* array colors */
    XColor *ecolor ;				/* color info */
    Tk_Window tkwin ;				/* Tk window */
    char buffer[80] ;				/* buffer for value */

    if(!(gc_p)){
      Tcl_AppendResult(i_p, "#000000", NULL ) ;
      return ;
    }
    tkwin = gc_p->drawWindow ;
    cmap = Tk_Colormap(tkwin) ;
    ecolors[0].pixel = pixel_val ;
    XQueryColors( Tk_Display(tkwin), cmap, ecolors, 1 ) ;
    ecolor = &(ecolors[0]) ;
    sprintf( buffer, "#%04x%04x%04x", ecolor->red, ecolor->green, ecolor->blue);
    Tcl_AppendResult(i_p, buffer, NULL ) ;
} /* end output_color_value() */


static void list_file( char *directory, char *filename, VOIDPTR user_data )
{
    Tcl_Obj *strObj ;			/* string object */
    Tcl_Obj *resultPtr ;		/* result info */
    Tcl_Interp *i_p ;			/* Tcl Interpreter */
    BOOL output_flag ;			/* need to output match */
    FILE_MATCHPTR file_match_p ;	/* info to match data */

    if( strcmp( filename, "." ) == STRINGEQ ){
      return ;
    }
    if( strcmp( filename, ".." ) == STRINGEQ ){
      return ;
    }
    file_match_p = (FILE_MATCHPTR) user_data ;
    i_p = file_match_p->i_p ;
    if( file_match_p->match ){
      output_flag = FALSE ;
      if( strcmp( filename, file_match_p->match ) == STRINGEQ ){
	output_flag = TRUE ;
	file_match_p->found = TRUE ;
      } else if( file_match_p->alt_match ){
	if( strcmp( filename, file_match_p->alt_match ) == STRINGEQ ){
	  output_flag = TRUE ;
	  file_match_p->found = TRUE ;
	}
      }
    } else {
      output_flag = TRUE ;
    }
    if( output_flag ){
      if( file_match_p->match ){
	resultPtr = Tcl_GetObjResult(i_p) ;
	if( file_match_p->prefix ){
	  /* path we can use in bitmap commands */
	  Tcl_AppendStringsToObj( resultPtr, "@", directory, "/", filename, NULL ) ;
	} else {
	  /* real path */
	  Tcl_AppendStringsToObj( resultPtr, directory, "/", filename, NULL ) ;
	}
      } else {
	strObj = Tcl_NewStringObj( filename, -1 ) ;
	resultPtr = Tcl_GetObjResult(i_p) ;
	Tcl_ListObjAppendElement( NULL,resultPtr,strObj ) ;
      }
    }
} /* end list_file() */

static void list_stipple( Tcl_Interp *i_p, GraphicsContextPtr gc_p, FILE_MATCHPTR info_p )
{
    char *homedir ;		/* home directory */
    char *stipple_path ;	/* full path */
    Tcl_DString tilde_buf ;	/* used for initialization */
    UTDDSTRING path_buf ;	/* build a path */
    FILE_MATCH info ;		/* build a record */

    if(!(info_p)){  	/* normal case no match! */
      info_p = &info ;
      info_p->match = NULL ;
      info_p->i_p = i_p ;
    }

    /* look for shorted names in user directory */
    homedir = Tcl_TildeSubst( i_p, "~/.utd", &tilde_buf) ;
    utDdstring_init( &path_buf ) ;
    stipple_path = utDdstring_printf( &path_buf, "%s/stipple", homedir ) ;
    if ( utDdirectoryExists( stipple_path ) ){
      utDfile_enumerate_dir( stipple_path, list_file, info_p ) ;
    }

    utDdstring_reinit( &path_buf ) ;
    stipple_path = utDdstring_printf( &path_buf, "%s/tcl/stipple", gc_p->utdgui ) ;
    if ( utDdirectoryExists( stipple_path ) ){
      utDfile_enumerate_dir( stipple_path, list_file, info_p ) ;
    }
} /* end list_stipple() */

static BOOL stipple_is_built_in( const char *stipple_name )
{
    Tcl_HashTable *bitmapTable ;	/* predefine bitmaps */

    bitmapTable = TkGetBitmapPredefTable() ;
    if( bitmapTable ){
      if( Tcl_FindHashEntry( bitmapTable, stipple_name ) ){
	return( TRUE ) ;
      }
    }
    return(FALSE) ;
} /* end stipple_ist_built_in() */


static void list_builtin( Tcl_Interp *i_p )
{
    Tcl_HashEntry *h_p ;		/* curent entry */
    Tcl_HashSearch iter ;		/* iterator */
    Tcl_HashTable *bitmapTable ;	/* predefine bitmaps */
    Tcl_Obj *strObj ;			/* string object */
    Tcl_Obj *resultPtr ;		/* result info */
    
    bitmapTable = TkGetBitmapPredefTable() ;
    if( bitmapTable ){
      resultPtr = Tcl_GetObjResult(i_p) ;
      for( h_p = Tcl_FirstHashEntry(bitmapTable, &iter) ; h_p ;
	   h_p = Tcl_NextHashEntry(&iter) ){
	strObj = Tcl_NewStringObj(Tcl_GetHashKey(bitmapTable, h_p), -1); 
	Tcl_ListObjAppendElement(NULL, resultPtr, strObj);
      }
    }
} /* end list_builtin() */
