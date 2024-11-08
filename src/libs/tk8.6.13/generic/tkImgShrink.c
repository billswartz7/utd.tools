
#include "tkInt.h"
#include "tkPort.h"

/* ****************************************** */
typedef unsigned char byte ;

typedef struct pixel {
    int r ;
    int g ;
    int b ;
    struct pixel *next ;
} Pixel ;

typedef struct image {
    int width ;
    int height ;
    Pixel *pixels ;
} Image ;

static Image *quantize_img(Image *an_image) ;
static Image *read_image( char *data ) ;
static char *write_image( Image *an_image, int pixel_block_list ) ;
static int squeeze(Image *an_image, int new_width) ;

/* ****************************************** */

/* Function: squeeze
 *
 * Takes an image, stored as Image type defined above,
 * and shrinks it along the x dimension, then flips it
 * about its leading diagonal.
 * Applying this operation twice, will therefore shrink
 * the image along each dimension and return it the
 * right way round.
 *
 */ 

static int squeeze(Image *an_image, int new_width) {
    int x, first, last, i, j ;
    double p, prop_first, prop_last, r, g, b ;
    Pixel **rail ; /* to store start of each row as new image is built */
    Pixel **hooks ; /* to store end pixel in each row as new image is built */
    Pixel *old_pixel ; /* to hold pixels from old image */
    Pixel *new_pixel ; /* to hold pixels for new image */
    Pixel *temp_pixel ; /* to hold a pointer to the old_pixel for deletion. */


    /* Create an array of pixel pointers to hold the heads of new rows
     * NB. Image is flipped on leading diagonal so coumns become rows. 
     */
    rail= (Pixel **)ckalloc( sizeof( Pixel * ) * new_width) ;
    if (rail == NULL)
    {
	printf("Out of memory!\n") ;
	return 1 ;
    }
    /* Create an array of pixel pointers to hold the tails of new rows
     * NB. Image is flipped on leading diagonal so coumns become rows. 
     */
    hooks= (Pixel **)ckalloc( sizeof( Pixel * ) * new_width) ;
    if (hooks == NULL)
    {
	printf("Out of memory!\n") ;
	return 1 ;
    }

    /* calculate size of old pixels relative to new pixels */
    p= (double)an_image->width / (double)new_width ;

    /* Get the first pixel in the image */
    old_pixel= (an_image->pixels)->next ;
    /* Initialise the index to the last pixel to 0 */ 
    last= 0 ;

    /* For each row in the old image */
    for (i= 0 ; i < an_image->height ; i++) {
	
        /* For each pixel in the new image's rows (before flipping) */
	for (x= 0 ; x < new_width ; x++) {

    	    /* create new pixel */
	    new_pixel= (Pixel *)ckalloc( sizeof(Pixel) ) ;
	    if (new_pixel == NULL) {
		printf("Out of memory!\n") ;
		return 0 ;
	    }
 
	    /* calculate index of first pixel covered...
	     * N.B. int cast will truncate.
    	     */
	    first= (int)(x * p) ;
	    /* ...and proportion of it covered.
	     * N.B. (first + 1) == ceil(x*p)
	     */
	    prop_first= (first+1) - (x * p) ;
	    if (prop_first == 0) prop_first= 1 ;

    	    /* if this pixel isn't the last one covered by the previous
	     * new pixel, move the old_pixel pointer to the next pixel,
	     * and free the memory used by the previous pixel, which is
	     * no longer required.
	     */
	    if (first > last) {
		temp_pixel= old_pixel ;
		old_pixel= old_pixel->next ;
		ckfree((char *)temp_pixel) ;
	    }
	    /* get the proportion of the old pixel's values to be added
	     * to the new pixel.
	     */
	    r= old_pixel->r * prop_first ;
	    g= old_pixel->g * prop_first ;
	    b= old_pixel->b * prop_first ;

	    /* calculate the index of the last pixel covered...
	     * N.B. first term truncated by int cast,
	     *      second term adds one if nothing is truncated.
	     */
	    last= (int)(((x+1) * p) - 0.0001) ;
	    /* ...and the proportion of it covered. */
    	    prop_last= ((x + 1) * p) - last ;
	    if (prop_last == 0) prop_last= 1 ;
	    /* for each pixel between first and last covered... */
	    for (j= last - first ; j > 1 ; j--) {
		/* get the next old pixel (deleting previous one) and... */
		temp_pixel= old_pixel ;
		old_pixel= old_pixel->next ;
		ckfree((char *)temp_pixel) ;
		/* ...add its content to the amounts to be added
		 * to the new pixel
		 */
		r+= old_pixel->r  ;
		g+= old_pixel->g  ;
		b+= old_pixel->b  ;
	    }

	    /* if the last pixel covered is not the first pixel covered... */
	    if (last > first) {
		/* get the last old pixel (deleting the previous one) and... */
		temp_pixel= old_pixel ;
		old_pixel= old_pixel->next ;
		ckfree((char *)temp_pixel) ;
		/* add the proportion of the old pixel's values to be added
		 * to the new pixel to the current total to be added
		 */
		r+= old_pixel->r * prop_last ;
		g+= old_pixel->g * prop_last ;
		b+= old_pixel->b * prop_last ;
	    }
	    /* Set the new pixel's colour values to the nearest integer
	     * NB. int casting truncates floats, so adding 0.5 makes this
	     * round to the nearest int.
	     */
	    new_pixel->r= (int)((r/p)+0.5) ;
	    new_pixel->g= (int)((g/p)+0.5) ;
	    new_pixel->b= (int)((b/p)+0.5) ;

	    /* If it's the first pixel in a new row (i.e. from the old image's
	     * top row), set the appropriate row of the rail to point to it.
	     */
	    if (i == 0) {
		rail[x]= new_pixel ;
	    }
	    /* otherwise, set the end pixel in the new row to point to it. */
	    else {
		temp_pixel= hooks[x] ;
		temp_pixel->next= new_pixel ;
	    }
	    /* Update the array of hooks to point to the new row end. */
	    hooks[x]= new_pixel ;
	}
	/* Set the index of the last pixel fetched to -1, so the next
	 * loop knows it needs to start with a fresh pixel.
	 */
	last= -1 ;
    }
    /* Delete the last pixel from the old image */
    ckfree((char *)old_pixel) ;
    /* Knit the rows together to for one big linked list. */
    for (x= 0 ; x < (new_width - 1) ; x++) {
	hooks[x]->next= rail[x+1] ;
    }
    hooks[new_width-1]->next= NULL ;
    /* Attach the new linked list to the image */
    (an_image->pixels)->next= rail[0] ;
    /* Update the image's width and height */
    an_image->width= an_image->height ;
    an_image->height= new_width ;
    
    /* Free the memory used to store the rail and hooks */
    ckfree((char *)rail) ;
    ckfree((char *)hooks) ;
    
    return 0 ;
}


/* ****************************************** */

/* Function: read_image
 * 
 * Takes a string of image data (as returned by the
 * Tk photo function [imageName data]) and stores it
 * in memory as type Image (defined above).
 */

static Image *read_image( char *data ) {
    int in_data_row, end_of_data ;
    int width, column_count ;
    int height, row_count ;
    int i ;
    char rrggbb[6] ;
    int values[6] ;
    Image *an_image ;
    Pixel *header ;
    Pixel *new_pixel ;
    Pixel *last_pixel ;

    /* Assign memory for the Image */
    an_image= (Image *)ckalloc( sizeof( Image ) );
    if (an_image == NULL)
    {
	printf("Out of memory!\n") ;
	return NULL ;
    }
    /* Assign memory for the 'header' pixel in the image 
     * struct which points to the linked list of pixels
     */
    header= (Pixel *)ckalloc( sizeof( Pixel ) );
    if (header == NULL)
    {
	printf("Out of memory!\n") ;
	return NULL ;
    }
    /* Put the header in the image struct */
    an_image->pixels= header ;
    /* Initialise the header to be empty */
    header->next= NULL ;
    /* Set the pointer to the last pixel in the image
     * to point at the header (as there are no pixels
     * in the image yet).
     */
    last_pixel= an_image->pixels ;

    in_data_row= 0 ;
    end_of_data= 0 ;
    width= 0 ;
    column_count= 0 ;
    height= 0 ;
    row_count= 0 ;

    /* Loop through the input string... */
    while (*data != '\0') {
	/* Skip white space */
	if (*data == ' ') {
	    data++ ;
	    continue ;
	}
	/* Check for the start of new rows */
	if (*data == '{') {
	    if (in_data_row == 0) {
		in_data_row= 1 ;
		data++ ;
		continue ;
	    }
	    else {
		printf("Image data is incorrectly formatted.\n") ;
		return NULL ;
	    }
	}
	/* Check for the end of rows */
	if (*data == '}') {
	    if (in_data_row == 1) {
		in_data_row= 0 ;
		/* If the width hasn't been calculated yet... */
		if (width == 0) {
		    /* ... set it to the current column count. */
		    width= column_count ;
		}
		/* Otherwise check each row has same number of pixels. */
		else if (width != column_count) {
		    printf("Image data is incorrectly formatted.\n") ;
		    return NULL ;
		}
		/* Reset the column count */
		column_count= 0 ;
		/* Increment the row count */
		row_count++ ;
		/* Go to the next char in the input data */
		data++ ;
		continue ;
	    }
	    else {
		printf("Image data is incorrectly formatted.\n") ;
	        return NULL ;
	    }
	}
	/* Look for #'s which indicate the start of each pixel's
	 * rgb data.
	 */
	if (*data == '#') {
	    if (in_data_row != 1) {
		printf("a) Image data is incorrectly formatted.\n") ;
	        return NULL ;
	    }
	    /* Assign memory for a new pixel */
	    new_pixel= (Pixel *)ckalloc( sizeof ( Pixel ) ) ;
	    if (new_pixel == NULL) {
	        printf("Out of memory!\n") ;
	        return NULL ;
	    }
	    /* Initialise the new pixel's 'next' pointer to NULL */
	    new_pixel->next= NULL ;
	    /* Get the next 6 chars, which must be rgb data */
	    for (i= 0 ; i < 6 ; i++) {
		data++ ;
		if (*data == '\0') {
		    printf("b) Image data is incorrectly formatted.\n") ;
		    return NULL ;
		}
		rrggbb[i]= *data ;
	    }
	    /* Convert the hex char rgb data into base 10 integers */
	    for (i= 0 ; i < 6 ; i++) {
		if (rrggbb[i] > 0x29 && rrggbb[i] < 0x40 ) /* if 0 to 9 */
		    values[i]= rrggbb[i] & 0x0f ;
		else /* assume is a-fA-F */
		    values[i]= (rrggbb[i] & 0x0f) + 9 ;
	    }
	    /* Set the new pixel's r, g & b values */
	    new_pixel->r= (values[0] * 16) + values[1] ;
	    new_pixel->g= (values[2] * 16) + values[3] ;
	    new_pixel->b= (values[4] * 16) + values[5] ;
	    /* Connect the new pixel into the Image's pixel list */
	    last_pixel->next= new_pixel ;
	    /* Move the pointer to the last pixel to the end of the list */
	    last_pixel= new_pixel ;
	    /* increment the column count */
	    column_count++ ;
	    /* Move to the next char of input data */
	    data++ ;
	    continue ;
	}
    }
    /* store the image's height and width */
    an_image->width= width ;
    an_image->height= row_count ;
    /* return a pointer to the image created */
    return an_image ;
}

/* ****************************************** */

/* Function: write_image
 *
 * Converts an image stored as the Image type defined above
 * to a list of lists of #rrggbb ascii hex data
 */

static char *write_image(Image *an_image, int pixel_block_list) {
    int string_size, count, i ;
    char *output ;
    char hex[17] ;
    Pixel *a_pixel ;
    Pixel *temp_pixel ;

    strcpy(hex,"0123456789abcdef") ;

    /* Calculate how much memory is required for the output string... */
    string_size= (an_image->width * an_image->height * 8) + (an_image->height * 3) + 1 ;
    /* ...and assign it all at once */
    output= (char *)ckalloc( sizeof(char) * string_size ) ;

    /* initialise the output char array to NULLs */
    for (i= 0 ; i < string_size ; i ++) {
	output[i]= '\0' ;
    }

    /* Get the first pixel in the image */
    if( pixel_block_list ){
      a_pixel= an_image->pixels ;
    } else {
      a_pixel= (an_image->pixels)->next ;
    }

    /* Loop until the end of the pixel list ... */
    count= 0 ;
    i= 0 ;
    while (a_pixel != NULL) {
	/* If the number of pixels done so far make a whole 
	 * number of rows, the a new one must be started,
	 * so write out a '{'.
	 */
	if ((count % an_image->width) == 0) {
	    output[i++]= '{' ;
	}
	/* Write out the #rrggbb hex char data */
 	output[i++]= '#' ;
	output[i++]= hex[a_pixel->r/16] ;
	output[i++]= hex[a_pixel->r%16] ;
	output[i++]= hex[a_pixel->g/16] ;
	output[i++]= hex[a_pixel->g%16] ;
	output[i++]= hex[a_pixel->b/16] ;
	output[i++]= hex[a_pixel->b%16] ;
	output[i++]= ' ' ;
	/* If this pixel comletes a row, write out a '}' */
	if ((count % an_image->width) == (an_image->width - 1)) {
	    output[i++]= '}' ;
	    output[i++]= ' ' ;
	}
	temp_pixel = a_pixel ;
	a_pixel= a_pixel->next ;
	if(!(pixel_block_list)){
	  ckfree((char *)temp_pixel) ;
	}
	count++ ;
    }
    /* Now free either the header or the block of pixels. */
    ckfree( (char *) an_image->pixels ) ;
    ckfree( (char *) an_image ) ;

    /* Null terminate the output string (redundant). */
    output[i]= '\0' ;
    return( output ) ;
}

/* ****************************************** */

/* Function: shrink
 * 
 * Takes a string of image Tk photo image data,
 * format it as type Image (defined above), call
 * the function 'squeeze' twice to shrink it along
 * each dimension, then return the image, written
 * back into Tk photo image format.
 */

char *TkImgShrink(char *input, int width, int height) {
    Image *an_image ;
    char *output ;

    an_image= read_image(input) ;
    squeeze(an_image,width) ;
    squeeze(an_image,height) ;
    output = write_image(an_image,0) ;

    return(output) ;
} /* end TkImgShrink() */

char *TkImgQuantize(char *input) 
{
    Image *an_image ;
    Image *reduced_image ;
    char *output ;

    an_image= read_image(input) ;
    reduced_image = quantize_img(an_image) ;
    output = write_image(reduced_image,1) ;
    return(output) ;

} /* end TkImgQuantize() */


/***************************************************************/
/* The following code based on code from the 'pbmplus' package */
/* written by Jef Poskanzer                                    */
/***************************************************************/


/* ppmquant.c - quantize the colors in a pixmap down to a specified number
**
** Copyright (C) 1989, 1991 by Jef Poskanzer.
**
** Permission to use, copy, modify, and distribute this software and its
** documentation for any purpose and without fee is hereby granted, provided
** that the above copyright notice appear in all copies and that both that
** copyright notice and this permission notice appear in supporting
** documentation.  This software is provided "as is" without express or
** implied warranty.
*/


#define PPM_MAXMAXVAL 255

#define PPM_GETR(p) ((p).r)
#define PPM_GETG(p) ((p).g)
#define PPM_GETB(p) ((p).b)

#define PPM_ASSIGN(p,red,grn,blu) \
  { (p).r = (red); (p).g = (grn); (p).b = (blu); }

#define PPM_EQUAL(p,q) ( (p).r == (q).r && (p).g == (q).g && (p).b == (q).b )


/* Color scaling macro -- to make writing ppmtowhatever easier. */

#define PPM_DEPTH(newp,p,oldmaxval,newmaxval) \
    PPM_ASSIGN( (newp), \
	        ((int) PPM_GETR(p)) * ((int)newmaxval) / ((int)oldmaxval), \
	        ((int) PPM_GETG(p)) * ((int)newmaxval) / ((int)oldmaxval), \
	        ((int) PPM_GETB(p)) * ((int)newmaxval) / ((int)oldmaxval) )


/* Luminance macro. */

/* 
 * #define PPM_LUMIN(p) \
 *   ( 0.299 * PPM_GETR(p) + 0.587 * PPM_GETG(p) + 0.114 * PPM_GETB(p) )
 */

/* Luminance macro, using only integer ops.  Returns an int (*256)  JHB */
#define PPM_LUMIN(p) \
  ( 77 * PPM_GETR(p) + 150 * PPM_GETG(p) + 29 * PPM_GETB(p) )

/* Color histogram stuff. */

typedef struct chist_item* chist_vec;
struct chist_item { Pixel color;
			int value;
		      };

typedef struct chist_list_item* chist_list;
struct chist_list_item { struct chist_item ch;
			     chist_list next;
			   };

typedef chist_list* chash_table;

typedef struct box* box_vector;
struct box {
  int index;
  int colors;
  int sum;
};


#define MAXCOLORS 32767
#define CLUSTER_MAXVAL 63

#define LARGE_LUM
#define REP_AVERAGE_PIXELS

#define FS_SCALE 1024

#define HASH_SIZE 6553

#define ppm_hashpixel(p) ((((int) PPM_GETR(p) * 33023 +    \
			    (int) PPM_GETG(p) * 30013 +    \
			    (int) PPM_GETB(p) * 27011) & 0x7fffffff)   \
			  % HASH_SIZE)



/*** function defs ***/

static chist_vec   mediancut        (chist_vec, int, int, int, int);
static int         redcompare       (const void *, const void *);
static int         greencompare     (const void *, const void *);
static int         bluecompare      (const void *, const void *);
static int         sumcompare       (const void *, const void *);
static chist_vec   ppm_computechist (Pixel **, int,int,int,int *);
static chash_table ppm_computechash (Pixel **, int,int,int,int *);
static chist_vec   ppm_chashtochist (chash_table, int);
static chash_table ppm_allocchash   (void);
static void        ppm_freechist    (chist_vec);
static void        ppm_freechash    (chash_table);

/*
static char *quantize_img(byte *pic24, int cols, int rows, byte *pic8, 
                     byte *rmap, byte *gmap, byte *bmap, int newcolors)
		    */

/****************************************************************************/
static Image *quantize_img(Image *an_image)
{
  Pixel**          pixels;
  Pixel*           pic8;
  Pixel*	   pixel_list ;
  Pixel*	   last_link ;
  Pixel*	   picptr;
  Pixel* 	   reduced_pix ;
  Pixel* 	   free_pixel ;
  register Pixel*  pP;
  register int     col, limitcol;
  byte             maxval, newmaxval;
  register int     index;
  chist_vec chv, colormap;
  chash_table  cht;
  int              i;
  int              b;
  int              rows;
  int              cols;
  int              newcolors;
  int              row;
  int              num_bits;
  int              colors;
  int		   debug;
  Image            *reduced_image ;
  static char      *fn = "quantize_img()";

  index = 0;
  maxval = 255;
  newcolors = 255;
  debug = 0;

  /* -----------------------------------------------------------------
   * First build an array structure of all the pixels.
  ----------------------------------------------------------------- */
  cols = an_image->width ;
  rows = an_image->height ;
  pixels = (Pixel **) ckalloc(rows * sizeof(Pixel *));
  if (!pixels) Tcl_Panic("couldn't allocate 'pixels' array");
  pixel_list = an_image->pixels->next ;
  for (row=0; row<rows; row++) {
    pixels[row] = (Pixel *) ckalloc(cols * sizeof(Pixel));
    if (!pixels[row]) Tcl_Panic("couldn't allocate a row of pixels array");

    for (col=0, pP=pixels[row]; col<cols; col++, pP++) {
      if( pixel_list ){
	pP->r = pixel_list->r ;
	pP->g = pixel_list->g ;
	pP->b = pixel_list->b ;
	free_pixel = pixel_list ;
	pixel_list = pixel_list->next ;
	ckfree((char *) free_pixel ) ;
      } else {
	Tcl_Panic("mismatch of pixel list") ;
	return(NULL) ;
      }
    }
  }
  ckfree( (char *) an_image->pixels ) ; /* free so-called header */
  ckfree( (char *) an_image ) ;

  /*
   *  attempt to make a histogram of the colors, unclustered.
   *  If at first we don't succeed, lower maxval to increase color
   *  coherence and try again.  This will eventually terminate, with
   *  maxval at worst 15, since 32^3 is approximately MAXCOLORS.
   */

  for ( ; ; ) {
    if (debug) fprintf(stderr, "%s:  making histogram\n", fn);

    chv = ppm_computechist(pixels, cols, rows, MAXCOLORS, &colors);
    if (chv != (chist_vec) 0) break;
    
    if (debug) fprintf(stderr, "%s: too many colors!\n", fn);
    newmaxval = maxval / 2;
    if (debug) fprintf(stderr, "%s: rescaling colors (maxval=%d) %s\n",
		       fn, newmaxval, "to improve clustering");

    for (row=0; row<rows; ++row)
      for (col=0, pP=pixels[row]; col<cols; ++col, ++pP)
	PPM_DEPTH( *pP, *pP, maxval, newmaxval );
    maxval = newmaxval;
  }

  if (debug) fprintf(stderr,"%s: %d colors found\n", fn, colors);



  /*
   * Step 3: apply median-cut to histogram, making the new colormap.
   */

  if (debug) fprintf(stderr, "%s: choosing %d colors\n", fn, newcolors);
  colormap = mediancut(chv, colors, rows * cols, maxval, newcolors);
  ppm_freechist(chv);



  /*
   *  Step 4: map the colors in the image to their closest match in the
   *  new colormap, and write 'em out.
   */

  if (debug) fprintf(stderr,"%s: mapping image to new colors\n", fn);
  cht = ppm_allocchash();

  num_bits = rows * cols ;
  pic8 = (Pixel *) ckalloc( num_bits * sizeof(Pixel) );
  if(!pic8){
    Tcl_Panic("failed to allocate reduced pixmap") ;
    return(NULL ) ;
  }
  /* Assign memory for the Image */
  reduced_image = (Image *) ckalloc( sizeof( Image ) );
  if (!(reduced_image)) {
    printf("Out of memory!\n") ;
    return NULL ;
  }
  reduced_image->width = cols ;
  reduced_image->height = rows ;
  /* Now link the output */
  last_link = NULL ;
  for ( b = 0 ; b < num_bits ; b++) {
    reduced_pix = &(pic8[b]) ; 
    if( last_link ){
      last_link->next = reduced_pix ;
    } else {
      reduced_image->pixels = reduced_pix ;
    }
    last_link = reduced_pix ;
  }
  if( last_link ){
    last_link->next = NULL ;
  }

  picptr = pic8;
  for (row = 0;  row < rows;  ++row) {
    col = 0;  limitcol = cols;  pP = pixels[row];

    do {
      int hash;
      chist_list chl;

      /* Check hash table to see if we have already matched this color. */

      hash = ppm_hashpixel(*pP);
      for (chl = cht[hash];  chl;  chl = chl->next)
	if (PPM_EQUAL(chl->ch.color, *pP)) {index = chl->ch.value; break;}

      if (!chl /*index = -1*/) {/* No; search colormap for closest match. */
	register int i, r1, g1, b1, r2, g2, b2;
	register long dist, newdist;

	r1 = PPM_GETR( *pP );
	g1 = PPM_GETG( *pP );
	b1 = PPM_GETB( *pP );
	dist = 2000000000;

	for (i=0; i<newcolors; i++) {
	  r2 = PPM_GETR( colormap[i].color );
	  g2 = PPM_GETG( colormap[i].color );
	  b2 = PPM_GETB( colormap[i].color );

	  newdist = ( r1 - r2 ) * ( r1 - r2 ) +
	            ( g1 - g2 ) * ( g1 - g2 ) +
	            ( b1 - b2 ) * ( b1 - b2 );

	  if (newdist<dist) { index = i;  dist = newdist; }
	}

	hash = ppm_hashpixel(*pP);
	chl = (chist_list) ckalloc(sizeof(struct chist_list_item));
	if (!chl) Tcl_Panic("ran out of memory adding to hash table");

	chl->ch.color = *pP;
	chl->ch.value = index;
	chl->next = cht[hash];
	cht[hash] = chl;
      }

      if( picptr ){
	picptr->r = PPM_GETR( colormap[index].color ) ;
	picptr->g = PPM_GETG( colormap[index].color ) ;
	picptr->b = PPM_GETB( colormap[index].color ) ;
	picptr = picptr->next ;
      }

      ++col;
      ++pP;
    }
    while (col != limitcol);
  }

  /* free the pixels array */
  for (i=0; i<rows; i++) ckfree((char*)pixels[i]);
  ckfree((char *)pixels);

  /* free cht and colormap */
  ppm_freechist(colormap);
  ppm_freechash(cht);

  return( reduced_image) ;
}



/*
** Here is the fun part, the median-cut colormap generator.  This is based
** on Paul Heckbert's paper "Color Image Quantization for Frame Buffer
** Display", SIGGRAPH '82 Proceedings, page 297.
*/



/****************************************************************************/
static chist_vec mediancut( chv, colors, sum, maxval, newcolors )
     chist_vec chv;
     int colors, sum, newcolors;
     int maxval;
{
  chist_vec colormap;
  box_vector bv;
  register int bi, i;
  int boxes;

  bv = (box_vector) ckalloc(sizeof(struct box) * newcolors);
  colormap = (chist_vec) 
             ckalloc(sizeof(struct chist_item) * newcolors );

  if (!bv || !colormap) Tcl_Panic("unable to ckalloc in mediancut()");

  for (i=0; i<newcolors; i++)
    PPM_ASSIGN(colormap[i].color, 0, 0, 0);

  /*
   *  Set up the initial box.
   */
  bv[0].index = 0;
  bv[0].colors = colors;
  bv[0].sum = sum;
  boxes = 1;


  /*
   ** Main loop: split boxes until we have enough.
   */

  while ( boxes < newcolors ) {
    register int indx, clrs;
    int sm;
    register int minr, maxr, ming, maxg, minb, maxb, v;
    int halfsum, lowersum;

    /*
     ** Find the first splittable box.
     */
    for (bi=0; bv[bi].colors<2 && bi<boxes; bi++) ;
    if (bi == boxes) break;	/* ran out of colors! */

    indx = bv[bi].index;
    clrs = bv[bi].colors;
    sm = bv[bi].sum;

    /*
     ** Go through the box finding the minimum and maximum of each
     ** component - the boundaries of the box.
     */
    minr = maxr = PPM_GETR( chv[indx].color );
    ming = maxg = PPM_GETG( chv[indx].color );
    minb = maxb = PPM_GETB( chv[indx].color );

    for (i=1; i<clrs; i++) {
      v = PPM_GETR( chv[indx + i].color );
      if (v < minr) minr = v;
      if (v > maxr) maxr = v;

      v = PPM_GETG( chv[indx + i].color );
      if (v < ming) ming = v;
      if (v > maxg) maxg = v;

      v = PPM_GETB( chv[indx + i].color );
      if (v < minb) minb = v;
      if (v > maxb) maxb = v;
    }

    /*
     ** Find the largest dimension, and sort by that component.  I have
     ** included two methods for determining the "largest" dimension;
     ** first by simply comparing the range in RGB space, and second
     ** by transforming into luminosities before the comparison.  You
     ** can switch which method is used by switching the commenting on
     ** the LARGE_ defines at the beginning of this source file.
     */
    {
      /* LARGE_LUM version */

      Pixel p;
      int rl, gl, bl;

      PPM_ASSIGN(p, maxr - minr, 0, 0);
      rl = PPM_LUMIN(p);

      PPM_ASSIGN(p, 0, maxg - ming, 0);
      gl = PPM_LUMIN(p);

      PPM_ASSIGN(p, 0, 0, maxb - minb);
      bl = PPM_LUMIN(p);

      if (rl >= gl && rl >= bl)
	qsort((char*) &(chv[indx]), (size_t) clrs, sizeof(struct chist_item),
	      redcompare );
      else if (gl >= bl)
	qsort((char*) &(chv[indx]), (size_t) clrs, sizeof(struct chist_item),
	      greencompare );
      else 
	qsort((char*) &(chv[indx]), (size_t) clrs, sizeof(struct chist_item),
	      bluecompare );
    }

    /*
     ** Now find the median based on the counts, so that about half the
     ** pixels (not colors, pixels) are in each subdivision.
     */
    lowersum = chv[indx].value;
    halfsum = sm / 2;
    for (i=1; i<clrs-1; i++) {
      if (lowersum >= halfsum) break;
      lowersum += chv[indx + i].value;
    }

    /*
     ** Split the box, and sort to bring the biggest boxes to the top.
     */
    bv[bi].colors = i;
    bv[bi].sum = lowersum;
    bv[boxes].index = indx + i;
    bv[boxes].colors = clrs - i;
    bv[boxes].sum = sm - lowersum;
    ++boxes;
    qsort((char*) bv, (size_t) boxes, sizeof(struct box), sumcompare);
  }  /* while (boxes ... */
  
  /*
   ** Ok, we've got enough boxes.  Now choose a representative color for
   ** each box.  There are a number of possible ways to make this choice.
   ** One would be to choose the center of the box; this ignores any structure
   ** within the boxes.  Another method would be to average all the colors in
   ** the box - this is the method specified in Heckbert's paper.  A third
   ** method is to average all the pixels in the box.  You can switch which
   ** method is used by switching the commenting on the REP_ defines at
   ** the beginning of this source file.
   */
  
  for (bi=0; bi<boxes; bi++) {
    /* REP_AVERAGE_PIXELS version */
    register int indx = bv[bi].index;
    register int clrs = bv[bi].colors;
    register long r = 0, g = 0, b = 0, sum = 0;

    for (i=0; i<clrs; i++) {
      r += PPM_GETR( chv[indx + i].color ) * chv[indx + i].value;
      g += PPM_GETG( chv[indx + i].color ) * chv[indx + i].value;
      b += PPM_GETB( chv[indx + i].color ) * chv[indx + i].value;
      sum += chv[indx + i].value;
    }

    r = r / sum;  if (r>maxval) r = maxval;	/* avoid math errors */
    g = g / sum;  if (g>maxval) g = maxval;
    b = b / sum;  if (b>maxval) b = maxval;

    PPM_ASSIGN( colormap[bi].color, r, g, b );
  }

  ckfree((char *)bv);
  return colormap;
}


/**********************************/
static int redcompare(p1, p2)
     const void *p1, *p2;
{
  return (int) PPM_GETR( ((chist_vec)p1)->color ) - 
         (int) PPM_GETR( ((chist_vec)p2)->color );
}

/**********************************/
static int greencompare(p1, p2)
     const void *p1, *p2;
{
  return (int) PPM_GETG( ((chist_vec)p1)->color ) - 
         (int) PPM_GETG( ((chist_vec)p2)->color );
}

/**********************************/
static int bluecompare(p1, p2)
     const void *p1, *p2;
{
  return (int) PPM_GETB( ((chist_vec)p1)->color ) - 
         (int) PPM_GETB( ((chist_vec)p2)->color );
}

/**********************************/
static int sumcompare(p1, p2)
     const void *p1, *p2;
{
  return ((box_vector) p2)->sum - ((box_vector) p1)->sum;
}



/****************************************************************************/
static chist_vec 
  ppm_computechist(pixels, cols, rows, maxcolors, colorsP)
     Pixel** pixels;
     int cols, rows, maxcolors;
     int* colorsP;
{
  chash_table cht;
  chist_vec chv;

  cht = ppm_computechash(pixels, cols, rows, maxcolors, colorsP);
  if (!cht) return (chist_vec) 0;

  chv = ppm_chashtochist(cht, maxcolors);
  ppm_freechash(cht);
  return chv;
}


/****************************************************************************/
static chash_table ppm_computechash(pixels, cols, rows, 
					    maxcolors, colorsP )
     Pixel** pixels;
     int cols, rows, maxcolors;
     int* colorsP;
{
  chash_table cht;
  register Pixel* pP;
  chist_list chl;
  int col, row, hash;

  cht = ppm_allocchash( );
  *colorsP = 0;

  /* Go through the entire image, building a hash table of colors. */
  for (row=0; row<rows; row++)
    for (col=0, pP=pixels[row];  col<cols;  col++, pP++) {
      hash = ppm_hashpixel(*pP);

      for (chl = cht[hash]; chl != (chist_list) 0; chl = chl->next)
	if (PPM_EQUAL(chl->ch.color, *pP)) break;
      
      if (chl != (chist_list) 0) ++(chl->ch.value);
      else {
	if ((*colorsP)++ > maxcolors) {
	  ppm_freechash(cht);
	  return (chash_table) 0;
	}
	
	chl = (chist_list) ckalloc(sizeof(struct chist_list_item));
	if (!chl) Tcl_Panic("ran out of memory computing hash table");

	chl->ch.color = *pP;
	chl->ch.value = 1;
	chl->next = cht[hash];
	cht[hash] = chl;
      }
    }
  
  return cht;
}


/****************************************************************************/
static chash_table ppm_allocchash()
{
  chash_table cht;
  int i;

  cht = (chash_table) ckalloc( HASH_SIZE * sizeof(chist_list) );
  if (!cht) Tcl_Panic("ran out of memory allocating hash table");

  for (i=0; i<HASH_SIZE; i++ )
    cht[i] = (chist_list) 0;

  return cht;
}


/****************************************************************************/
static chist_vec ppm_chashtochist( cht, maxcolors )
     chash_table cht;
     int maxcolors;
{
  chist_vec chv;
  chist_list chl;
  int i, j;

  /* Now collate the hash table into a simple chist array. */
  chv = (chist_vec) ckalloc( maxcolors * sizeof(struct chist_item) );

  /* (Leave room for expansion by caller.) */
  if (!chv) Tcl_Panic("ran out of memory generating histogram");

  /* Loop through the hash table. */
  j = 0;
  for (i=0; i<HASH_SIZE; i++)
    for (chl = cht[i];  chl != (chist_list) 0;  chl = chl->next) {
      /* Add the new entry. */
      chv[j] = chl->ch;
      ++j;
    }

  return chv;
}


/****************************************************************************/
static void ppm_freechist( chv )
     chist_vec chv;
{
  ckfree( (char*) chv );
}


/****************************************************************************/
static void ppm_freechash( cht )
     chash_table cht;
{
  int i;
  chist_list chl, chlnext;

  for (i=0; i<HASH_SIZE; i++)
    for (chl = cht[i];  chl != (chist_list) 0; chl = chlnext) {
      chlnext = chl->next;
      ckfree( (char*) chl );
    }

  ckfree( (char*) cht );
}
