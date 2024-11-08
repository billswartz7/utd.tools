/* ----------------------------------------------------------------- 
FILE:	    html_parse.c 
DESCRIPTION:This file contains routines for parsing HTML files.
CONTENTS:   
DATE:	    Wed Jul  8 10:50:18 CDT 1998
REVISIONS:  
 * $Log: html_parse.c,v $
 * Revision 1.20  2019/11/14 06:29:36  bills
 * Updated for the new Tcl which got rid of interp->result field.
 *
 * Revision 1.19  2018/11/13 15:26:48  bills
 * Updated for RCS fiasco.
 *
 * Revision 1.19  2017/04/11 17:38:59  bills
 * Added EZUSER and EZLESSON definitions for ease of use.
 *
 * Revision 1.18  2007/07/18 16:55:34  bills
 * Now we properly handle text files regardless of their content.
 * 
 * Revision 1.17  2005/06/20  05:08:37  bills
 * Updated for new Yexec_xxx arguments.
 *
 * Revision 1.16  2005/03/05  17:54:13  bills
 * Rewrote parse_func as an object function for more speed.
 *
 * Revision 1.15  2005/02/05  20:00:44  bills
 * Added support for arbitrary render function.  This allows us to
 * support rendering into a PDF conversion engine.
 *
 * Revision 1.14  2004/07/13  01:43:02  bills
 * Added the TKPLACEMENT="before" option to the JS_COND script command
 * in EZ to make life easier to write HTML.
 *
 * Revision 1.13  2003/02/20  02:48:49  bills
 * Added ICFOUNDARY definition.
 *
 * Revision 1.12  2000/05/25  17:55:11  bills
 * Fixed problems with html_cond and very complicated expressions.  Now
 * we look to find closing parens of strings.
 *
 * Revision 1.11  1999/06/17  10:45:49  bills
 * Updated for iTools name change.
 *
 * Revision 1.10  1998/10/22  04:54:07  bills
 * Added the auto detection of text files so that they appear correctly
 * on the screen.
 *
 * Revision 1.9  1998/07/23  04:44:48  bills
 * Added html_xfont which finds the closest font to the requested font.
 * This is so we don't get awful results when we don't have the font.
 *
 * Revision 1.8  1998/07/13  19:48:19  bills
 * Added the return variable *state to html_cond so we could generalize
 * JS_COND.
 *
 * Revision 1.7  1998/07/13  06:26:08  bills
 * Fixed html_cond so that it can evaluate Tcl functions as well.
 *
 * Revision 1.6  1998/07/10  22:49:25  bills
 * Got rid of a memory leak by implementing a new function called
 * Tcl_DStringReinit which does not create a leak.
 *
 * Revision 1.5  1998/07/10  07:23:15  bills
 * Got rid of the procedure and args options to the JS_COND function.  Not
 * needed and confusing.  This cases Netscape 4.0 to die.
 *
 * Revision 1.4  1998/07/10  06:40:41  bills
 * Fixed problem with initialization of cnt variable in find_HTML_tag.
 *
 * Revision 1.3  1998/07/10  02:03:00  bills
 * Fixed problem in find_HTML_tags when we are not given the start of a
 * text but are given just text.  Added better messages when files are
 * not present and added autocreate feature.
 *
 * Revision 1.2  1998/07/09  17:35:30  bills
 * Broken rendering into a unique function for reuse.  This is the first
 * version where conditional HTML works properly.
 *
 * Revision 1.1  1998/07/09  15:31:51  bills
 * Initial revision
 *
----------------------------------------------------------------- */
#ifndef lint
static char SccsId[] = 
"$RCSfile: html_parse.c,v $ $Revision: 1.20 $ $Date: 2019/11/14 06:29:36 $" ;
#endif

#include <cometconfig.h>
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */
#include <utd/base.h>
#include <ctype.h>
#include <utd/msg.h>
#include <utd/debug.h>
#include <utd/system.h>
#include <utd/file.h>
#include <utd/string.h>
#include <utd/mmap.h>
#include <utd/exec.h>
#include <utd/rbtree.h>
#include <tcl/tcl.h>
/* #include <tk/tkinterp.h> */
#include "pa_tags.h"
#include "html.h"

extern char *token_name_lookup(INT token) ;
/* ********************** TYPE DEFINITIONS ************************* */
#define APPEND_STRING	-1
#define IS_SPACE(val_xz)                \
    (((((INT)(val_xz)) & 0x7f) == ((INT)(val_xz))) && isspace((INT)(val_xz)) )

typedef struct html_info_rec {
    INT tagtype ;			/* tag id - non-zero if known */
    INT tag_len ;			/* length of tag string */
    INT param_len ;			/* length of param string */
    INT text_len ;			/* length of text string */
    BOOL end ;				/* this is an ending tag */
    char *tag_string ;			/* non-null terminated tag string */
    char *param_string ;		/* non-null terminated param string */
    char *text_string ;			/* non-null terminated text string */
} HTML_INFO, *HTML_INFOPTR ;

typedef struct font_info {
  char *foundary ;		/* foundary: Adobe, bitstream, etc.     */
  char *family ;		/* family: time, courier                */
  char *weight ;		/* weight: bold, medium                 */
  char *slant ;			/* slant: r, i, o                       */
  char *sWidth ;		/* slantWidth: normal, semicondensed    */
  char *style ;			/* adstyle: sans                        */
  char *pixelSize ;		/* pixel size: 0, 2, 6, 7, 8, 9, 10...  */
  char *pointSize ;		/* poin size:0, 20, 60, 70, 80, 90...   */
  char *resX ;			/* x resolution: 0, 72, 75, 100...      */
  char *resY ;			/* y resolution: 0, 72, 75, 100...      */
  char *spacing ;		/* spacing: c, m, p                     */
  char *avgWidth ;		/* average width: 0, 10, 42, 50,        */
  char *registry ;		/* registry: isoxxx                     */
  char *encoding ;		/* encoding : 1, 8...                   */
  char *buffer ;		/* hold the memory of string            */
} FONT, *FONTPTR ;

/* ***************** STATIC VARIABLES DEFINITIONS ******************* */
static Tcl_DString tag_stringS ;
static Tcl_DString text_stringS ;
static Tcl_DString param_stringS ;
static Tcl_DString sub_stringS ;
static Tcl_DString quoted_stringS ;
static Tcl_DString tcl_commandS ;
static UTDTREEPTR font_treeS ;
static char *render_funcS ;

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static INT compare_fonts(FONTPTR font1,FONTPTR font2,void *clientData) ;
static INT font_dist(FONTPTR font1_p, FONTPTR font2_p) ;
static BOOL font_match(FONTPTR font1_p, FONTPTR font2_p ) ;
static void initialize_xfonts(void) ;
static void add_font( UTDTREEPTR font_tree, char *font) ;
static void decode_font(FONTPTR font_p, char *font ) ;
static char *font_end_field(char *font) ;
static char *find_HTML_tag(char *buffer,INT buflen,HTML_INFOPTR html_info,BOOL txt) ;

/* -----------------------------------------------------------------
 * Now this is done is the native language rather than Tcl.
 * Format of the command:
 * icparse_html $file $window $render_func
----------------------------------------------------------------- */
INT parse_func(ClientData d_p,Tcl_Interp *i_p,INT objc,Tcl_Obj * CONST objv[])
{
  char *filename ;			/* name of html file */
  char *win ;				/* tk window */
  char *render ;			/* render command */
  char *data ;				/* memory mapped data */
  char *info ; 				/* info about a file */
  char *file_access ;			/* file access to map file */
  char data_buf[BUFSIZ] ;		/* error message buffer */
  BOOL autocreate ;			/* autocreate a file */
  LONG fsize ;				/* size of file */
  UTDMAPFILEPTR mmap_p ;		/* memory mapped file */

  if( objc != 4 && objc != 5 ){
    Tcl_AppendResult(i_p,"ERROR[icparse_html]:syntax:\n", NULL ) ;
    Tcl_AppendResult(i_p,
      "  icparse_html filename window render_func [autocreate]\n",NULL ) ;
    return(TCL_ERROR) ;
  }
  filename = Tcl_GetString(objv[1]) ;
  win = Tcl_GetString(objv[2]) ;
  /* install render functions */
  render = html_render_proc(Tcl_GetString(objv[3]) ) ;
  if( objc == 5 ){
    if( Tcl_GetBooleanFromObj(i_p,objv[4],&autocreate) != TCL_OK ){
      return(TCL_ERROR) ;
    }
    if( autocreate ){
      file_access = "a" ;
    } else {
      file_access = "r" ;
    }
  } else {
    autocreate = FALSE ;
    file_access = "r" ;
  }

  if( autocreate || utDfileExists(filename) ){
    mmap_p = utDmmap_open( filename, file_access, FILE_NOABORT|FILE_VERBOSE ) ;
    if(!(mmap_p)){
      info = "Cannot map file.  Check permissions." ;
    }
  } else {
    mmap_p = NULL ;
    info = "File does not exist." ;
  }
  if( mmap_p ){
    fsize = utDmmap_size(mmap_p) ;
    data = utDmmap_data(mmap_p) ;
  } else {
    sprintf( data_buf, 
      "<title>Bad file %s</title><h1>Error reading %s</h1><p>%s<p>",
      filename, filename, info ) ;
    data = data_buf ;
    fsize = strlen(data) ;
  }
  html_render( d_p, i_p, win, render, data, fsize, TRUE ) ;

  utDmmap_close(mmap_p) ;

  return(TCL_OK) ;


} /* parse_func() */

INT html_render(ClientData d_p,Tcl_Interp *inter,char *win,char *render_proc,
                char *data,LONG fsize, BOOL dummy_html)
{
  INT p ;				/* char pointer */
  INT code ;				/* return code */
  char *ptr ;				/* current placement in buffer */
  char *end_data ;			/* last character of memory */
  char *optr ;				/* old pointer */
  char *cmd ;				/* Tcl command */
  char cmd_buf[BUFSIZ] ;		/* build a simple command buffer */
  BOOL text_flag ;			/* TRUE if file is text only */
  LONG len ;				/* length of buffer buffer */
  HTML_INFO html_tag ;			/* a single html tag */

  code = TCL_OK ;
  end_data = data + fsize - 1 ;

  if( dummy_html ){
    /* -----------------------------------------------------------------
     * See if we have real html or just a text file.  If we have real
     * html we must have a < to start with.
    ----------------------------------------------------------------- */
    text_flag = TRUE ;
    for( ptr = data,len = fsize ; ptr && ptr <= end_data ; ){
      if( isspace(*ptr) ){
	ptr++ ;
      } else {
	if( *ptr == '<' ){
	  text_flag = FALSE ;
	}
	break ;
      }
    }
    if( text_flag ){
      /* dummy start & end */
      sprintf( cmd_buf, "%s {%s} {hmstart} {} {} {}", render_proc, win ) ;
      code = Tcl_Eval(inter,cmd_buf) ;
      sprintf( cmd_buf, "%s {%s} {hmstart} {/} {} {}", render_proc, win ) ;
      code = Tcl_Eval(inter,cmd_buf) ;
      dummy_html = FALSE ;
    } else {
      /* dummy start */
      sprintf( cmd_buf, "%s {%s} {hmstart} {} {} { }", render_proc, win ) ;
      code = Tcl_Eval(inter,cmd_buf) ;
    }
  } else {
    text_flag = FALSE ;
  }

  for( ptr = data,len = fsize ; ptr && ptr <= end_data ; ){
    ptr = find_HTML_tag(ptr,len,&html_tag,text_flag) ;
    /* -----------------------------------------------------------------
     * Format of the HTML render command.
     * HMrender {win tag not parm text}
     * Calculate the approximate space to build this command.  We can
     * be off somewhat because we need to substitute for {} characters.
    ----------------------------------------------------------------- */
    Tcl_DStringReinit(&text_stringS) ;

    /* Build window */
    Tcl_DStringAppend(&text_stringS, render_proc, APPEND_STRING) ;
    Tcl_DStringStartSublist(&text_stringS) ;
    Tcl_DStringAppend(&text_stringS, win, APPEND_STRING) ;
    Tcl_DStringEndSublist(&text_stringS) ;

    /* Build tag */
    Tcl_DStringStartSublist(&text_stringS) ;
    Tcl_DStringAppend(&text_stringS, html_tag.tag_string,html_tag.tag_len);
    Tcl_DStringEndSublist(&text_stringS) ;

    /* Build end of tag marker */
    Tcl_DStringStartSublist(&text_stringS) ;
    if( html_tag.end ){
      Tcl_DStringAppend(&text_stringS, "/", APPEND_STRING) ;
    }
    Tcl_DStringEndSublist(&text_stringS) ;

    /* Build param */
    Tcl_DStringStartSublist(&text_stringS) ;
    if( html_tag.param_len > 0 ){
      Tcl_DStringAppend(&text_stringS,html_tag.param_string, html_tag.param_len) ;
    }
    Tcl_DStringEndSublist(&text_stringS) ;


    /* Build text */
    Tcl_DStringStartSublist(&text_stringS) ;
    optr = html_tag.text_string ;
    for( p = 0 ; p < html_tag.text_len ; p++,optr++ ){
      if( *optr == '{' ){
	Tcl_DStringAppend(&text_stringS, "&#123;", APPEND_STRING) ;
      } else if( *optr == '}' ){
	Tcl_DStringAppend(&text_stringS, "&#125;", APPEND_STRING) ;
      } else {
	Tcl_DStringAppend(&text_stringS, optr, 1) ;
      }
    }
    Tcl_DStringEndSublist(&text_stringS) ;
    cmd = Tcl_DStringValue(&text_stringS) ;
    code = Tcl_Eval(inter,cmd) ;

    if( ptr ){
      len = end_data - ptr ;
    }
  }

  if( dummy_html ){
    /* dummy end */
    sprintf( cmd_buf, "%s {%s} {hmstart} {/} {} {}", render_proc, win ) ;
    code = Tcl_Eval(inter,cmd_buf) ;
  }

  return(code) ;

} /* end html_render() */

/* -----------------------------------------------------------------
 * Given a buffer and calculates the HTML tag, HTML end
 * flag, the start of the text buffer and the index to the start of
 * the next tag.  This routine does nothing destructive to the buffer.
 * It returns start of the next tag.
----------------------------------------------------------------- */
static char *find_HTML_tag(char *buffer,INT buflen,HTML_INFOPTR html_info,
                           BOOL text_flag)
{
    char *start ;		/* start of the tag text string */
    char *tptr ;		/* current place */
    char save_char ;		/* save character */
    char *tag_string ;		/* the accummulated tag string */
    INT cnt ;			/* keep track of where we are */

    /* -----------------------------------------------------------------
     * Initialize html info lengths to zero.  Tag may be persistent to
     * handle bogus data but params and text may not be.
    ----------------------------------------------------------------- */
    html_info->param_len = 0 ;
    html_info->text_len = 0 ;

    /* -----------------------------------------------------------------
     * Now test to make sure that we really are starting on a '<' character.
     * We may be starting in the middle of text if we were called from
     * a Javascript function.  We need to default to the most harmless
     * tag - the end of paragraph tag.
    ----------------------------------------------------------------- */
    tptr = buffer ;
    cnt = 0 ;
    if( *tptr == '<' ){
      /* -----------------------------------------------------------------
       * The normal case.
       * Find the start of the tag element text
      ----------------------------------------------------------------- */
      tptr++;		/* skip the '<' */
      cnt++ ;

      /* -----------------------------------------------------------------
       * Check if this is an end tag
      ----------------------------------------------------------------- */
      if (*tptr == '/') {
	html_info->end = TRUE ;
	tptr++;
	cnt++;
      } else {
	html_info->end = FALSE ;
      }

      /* -----------------------------------------------------------------
       * Start building the tag string to give to the tokenizer.
      ----------------------------------------------------------------- */
      Tcl_DStringReinit(&tag_stringS) ;
      Tcl_DStringAppend(&tag_stringS, tptr, 1) ;
      start = tptr ;

      /* -----------------------------------------------------------------
       * Find the end of the tag element text
      ----------------------------------------------------------------- */
      while ((*tptr != '>')&&(!IS_SPACE(*tptr))) {
	tptr++;
	cnt++;
	Tcl_DStringAppend(&tag_stringS, tptr, 1) ;
	/* -----------------------------------------------------------------
	 * Reach the end of the tag but find no end
	----------------------------------------------------------------- */
	if( cnt == buflen ){
	  return(NULL);
	}
      }

      /* -----------------------------------------------------------------
       * Now terminate the string so we can do string comparisons.  We
       * will restore it afer the operation.
      ----------------------------------------------------------------- */
      save_char = *tptr ;
      tag_string = Tcl_DStringValue(&tag_stringS) ;
      tag_string[strlen(tag_string)-1] = EOS ; /* remove last character */
      html_info->tagtype = html_tokenize_tag(tag_string) ;
      if( html_info->tagtype >= 0 ){
	html_info->tag_string = token_name_lookup(html_info->tagtype) ;
	html_info->tag_len = strlen(html_info->tag_string) ;
      } else {
	html_info->tag_string = start ;
	html_info->tag_len = tptr - start ;
	DS( 
	  {
	    char unknown_buff[BUFSIZ] ;
	    INT len ;
	    strncpy( unknown_buff, html_info->tag_string, html_info->tag_len ) ;
	    unknown_buff[html_info->tag_len] = EOS ;
	    if( unknown_buff[0] != '!' ){ /* avoid comments */
	      utDmsgf(WARNMSG,MSG_AT,"find_HTML_tag", "Unknown tag:%s", unknown_buff ) ;
	      if( buflen - cnt < 80 ){
		len = buflen - cnt - html_info->tag_len - 3 ;
	      } else {
		len = 80 ;
	      }
	      if( len > 0 ){
		strncpy( unknown_buff, start, len ) ;
		unknown_buff[len] = EOS ;
		utDmsgf(WARNMSG, MSG_AT, NULL, " @ %s\n", unknown_buff ) ;
	      } else {
		utDmsgf(WARNMSG, MSG_AT, NULL, "\n" ) ;
	      }
	    }
	  }
	) ;
      }

      /* -----------------------------------------------------------------
       * Now look for the end of the tag and process and parameters.
      ----------------------------------------------------------------- */
      if( save_char == '>' ){
	/* No parameters - easy case */
	html_info->param_string = NULL ;
      } else {
	/* -----------------------------------------------------------------
	 * Find start of params.
	----------------------------------------------------------------- */
	while( IS_SPACE(*tptr) ){
	  tptr++;
	  cnt++;
	  if( cnt == buflen ){
	    return(NULL);
	  }
	}
	html_info->param_string = tptr ;
	/* -----------------------------------------------------------------
	 * Now fine the end params.
	----------------------------------------------------------------- */
	while( (*tptr != '>') ) {
	  html_info->param_len++ ;
	  tptr++;
	  cnt++;
	  if( cnt == buflen ){
	    return(NULL);
	  }
	}
      }

      /* -----------------------------------------------------------------
       * Now skip over the end of tag marker.  
      ----------------------------------------------------------------- */
      tptr++ ;		/* skip the '>' */
      cnt++ ;
    } else {
      /* -----------------------------------------------------------------
       * Special case.  We are in the middle of text.  We output a harmless
       * end of paragraph flag.
      ----------------------------------------------------------------- */
      html_info->tagtype = P_PARAGRAPH ;
      html_info->tag_string = token_name_lookup(html_info->tagtype) ;
      html_info->tag_len = strlen(html_info->tag_string) ;
      html_info->end = TRUE ;
    }

    /* -----------------------------------------------------------------
     * Look for the start of the next tag.
    ----------------------------------------------------------------- */
    if( cnt == buflen ){
      return(NULL);
    }

    /* -----------------------------------------------------------------
     * Now return the start of the next '>' tag and find any text in 
     * between.
    ----------------------------------------------------------------- */
    if( *tptr == '<' ){
      /* No text - easy case */
      html_info->text_string = NULL ;
    } else {
      /* -----------------------------------------------------------------
       * Mark start of the text.
      ----------------------------------------------------------------- */
      html_info->text_string = tptr ;
      /* -----------------------------------------------------------------
       * Now find the end of the text.  We need to do special work for
       * a SCRIPT tag ; we need to find the </SCRIPT>tag.
      ----------------------------------------------------------------- */
      if( html_info->tagtype == P_SCRIPT && !(html_info->end) ){
	do {
	  while( (*tptr != '<') ) {
	    html_info->text_len++ ;
	    tptr++;
	    cnt++;
	    if( cnt == buflen ){
	      return(NULL);
	    }
	  }
	  /* Now peek to see if we have an ending script */
	  if( utDstrnicmp( tptr, "</script", 8 ) == STRINGEQ ){
	    break ;
	  } else {
	    /* skip over '<' in Javascript */
	    html_info->text_len++ ;
	    tptr++;
	    cnt++;
	    if( cnt == buflen ){
	      return(NULL);
	    }
	  }
	} while( TRUE ) ;
      } else {
	if( text_flag ){
	  while( cnt < buflen ){
	    html_info->text_len++ ;
	    tptr++;
	    cnt++;
	  }
	} else {
	  while( (*tptr != '<') ) {
	    html_info->text_len++ ;
	    tptr++;
	    cnt++;
	    if( cnt == buflen ){
	      return(NULL);
	    }
	  }
	}
      }
    }

    return(tptr) ;
} /* end find_HTML_tag() */

void html_parse_init(void)
{
    Tcl_DStringInit(&tag_stringS) ;
    Tcl_DStringInit(&text_stringS );
    Tcl_DStringInit(&param_stringS) ;
    Tcl_DStringInit(&sub_stringS) ;
    Tcl_DStringInit(&quoted_stringS) ;
    Tcl_DStringInit(&tcl_commandS) ;
    initialize_xfonts() ;
} /* end html_parse_init() */

char *html_cond(ClientData d_p,Tcl_Interp *inter,INT argc,char *argv[],
                BOOL *state, BOOL *needs_html_output,char **render_proc)
{
    INT code ;				/* Tcl result code */
    INT paren_depth ;			/* depth of parentheses */
    char *ptr ;				/* position in expression */
    char *tkwindow ;			/* tk window to redraw */
    char *expr ;			/* Tcl expression to evaluate */
    char *text ;			/* The hypertext to render */
    char *logic ;			/* expression logic */
    char *result ;			/* result from conditional */
    char *tkplacement ;			/* placement of Tk before/after */
    char *quoted_expr ;			/* expression double quoted */
    char *tcl_cmd ;			/* tcl command */
    char *result_p ;			/* result of command */
    char cmd[BUFSIZ] ;			/* build a tcl command */
    BOOL output_state ;			/* output state */


    tkwindow = argv[1] ;
    expr = argv[2] ;
    text = argv[3] ;
    logic = argv[4] ;
    tkplacement = argv[5] ;
    *needs_html_output = FALSE ;
    *render_proc = html_render_proc(NULL) ;

    Tcl_DStringReinit(&sub_stringS) ;
    /* First substitute for the expression */
    for( ptr = expr ; ptr && *ptr ; ){
      if( *ptr == '$' ){
	Tcl_DStringAppend(&sub_stringS, ptr, 1) ;
	ptr++ ;
	if( strncmp( ptr, "EZUSER", 6) == STRINGEQ ){
	  Tcl_DStringAppend(&sub_stringS, "::twez::configS(S_user)", APPEND_STRING) ;
	  ptr += 6 ;
	} else if( strncmp( ptr, "EZMODE", 6) == STRINGEQ ){
	  Tcl_DStringAppend(&sub_stringS, "::twez::configS(S_mode)", APPEND_STRING) ;
	  ptr += 6 ;
	} else if( strncmp( ptr, "EZDESIGN", 8) == STRINGEQ ){
	  Tcl_DStringAppend(&sub_stringS, "::twez::configS(S_design)", APPEND_STRING) ;
	  ptr += 8 ;
	} else if( strncmp( ptr, "EZLESSON", 9) == STRINGEQ ){
	  Tcl_DStringAppend(&sub_stringS, "::twez::configS(S_lesson)", APPEND_STRING) ;
	  ptr += 8 ;
	}
      } else {
	Tcl_DStringAppend(&sub_stringS, ptr, 1) ;
	ptr++ ;
      }
    }
    ptr = Tcl_DStringValue(&sub_stringS) ;

    /* -----------------------------------------------------------------
     * Now add the proper double quotes.  Double quotes go around variables
     * and string literals.
    ----------------------------------------------------------------- */
    Tcl_DStringReinit(&quoted_stringS) ;
    for( ; ptr && *ptr ; ){
      if( *ptr == '!' ){
	Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	ptr++ ;
      } else if( *ptr == '&' ){
	Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	ptr++ ;
      } else if( *ptr == '|' ){
	Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	ptr++ ;
      } else if( *ptr == '=' ){
	Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	ptr++ ;
      } else if( *ptr == '(' ){
	Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	ptr++ ;
      } else if( *ptr == ')' ){
	Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	ptr++ ;
      } else if( *ptr == ']' ){
	Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	ptr++ ;
      } else if( *ptr == '[' ){
	/* -----------------------------------------------------------------
	 * Special case of a command.  We don't double quote but take all
	 * characters till we see a special character. Could look for leading
	 * escape character but it is a bad idea for a name anyway.
	----------------------------------------------------------------- */
	for( ; ptr && *ptr ; ){
	  if( (*ptr == '!') || (*ptr == '&') || (*ptr == '|') || (*ptr == '=') ){
	    break ;
	  } else {
	    Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	    ptr++ ;
	  }
	}
      } else {
	/* a string double quote it */
	Tcl_DStringAppend(&quoted_stringS, "\"", 1) ;
	/* take everything up to the next !&|=)] */
	paren_depth = 0 ;
	for( ; ptr && *ptr ; ){
	  if( (*ptr == '!') || (*ptr == '&') || (*ptr == '|') || (*ptr == '=') ){
	    break ;
	  } else if( *ptr == '(' ){
	    paren_depth++ ;
	    Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	    ptr++ ;
	  } else if( *ptr == ')' ){
	    if( paren_depth == 0 ){
	      break ; /* no paren is waiting in string */
	    }
	    Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	    ptr++ ;
	    if( --paren_depth == 0 ){
	      break ;
	    }
	  } else {
	    Tcl_DStringAppend(&quoted_stringS, ptr, 1) ;
	    ptr++ ;
	  }
	}
	/* end double quote it */
	Tcl_DStringAppend(&quoted_stringS, "\"", 1) ;
      }
    }
    quoted_expr = Tcl_DStringValue(&quoted_stringS) ;

    /* -----------------------------------------------------------------
     * At this point we can evaluate the expression.  Call the native
     * ezeval_expr.
     * Format of the call is:
     *     procedure expr
    ----------------------------------------------------------------- */
    Tcl_DStringReinit(&tcl_commandS) ;
    Tcl_DStringAppend(&tcl_commandS, "ezeval_expr", APPEND_STRING) ;
    Tcl_DStringStartSublist(&tcl_commandS) ;
    Tcl_DStringAppend(&tcl_commandS, quoted_expr, APPEND_STRING) ;
    Tcl_DStringEndSublist(&tcl_commandS) ;
    tcl_cmd = Tcl_DStringValue(&tcl_commandS) ;

    code = Tcl_Eval(inter,tcl_cmd) ;
    result_p = (char *) Tcl_GetStringResult(inter) ;
    if( code != TCL_OK ){
      return( result_p ) ;
    }
    if( utDstricmp( result_p, "true" ) == STRINGEQ){
      output_state = TRUE ;
    } else if( utDstricmp( result_p, "false" ) == STRINGEQ){
      output_state = FALSE ;
    } else {
      utDmsgf(ERRMSG,MSG_AT,"html_cond", "Unknown result from evaluation function:%s\n",
	result_p ) ;
      return(NULL) ;
    }

    if( logic && utDstrnicmp(logic,"neg", 3) == STRINGEQ ){
      output_state = (output_state ? FALSE : TRUE) ;
    }
    if( output_state ){
      sprintf( cmd, "set_state %s -ignore 0", tkwindow ) ;
    } else {
      sprintf( cmd, "set_state %s -ignore 1", tkwindow ) ;
    }
    *state = output_state ;
    code = Tcl_Eval(inter,cmd) ;
    if( code != TCL_OK ){
      result = (char *) Tcl_GetStringResult(inter) ;
      return( result ) ;
    }

    if( output_state ){
      if( tkplacement && utDstrnicmp(tkplacement,"bef", 3) == STRINGEQ ){
	*needs_html_output = TRUE ;
      } else {
	html_render(NULL,inter,tkwindow,*render_proc,text,strlen(text), FALSE ) ;
      }
    }
    result = (char *) Tcl_GetStringResult(inter) ;
    return( result ) ;

} /* end html_cond() */ 

static void initialize_xfonts(void)
{
    INT pid ;			/* process id */
    INT status ;		/* program return status */
    char *bufferptr ;		/* beginning of buffer */
    char command[LRECL] ;	/* build a command */
    char buffer[LRECL] ;	/* read a line */
    FILE *child_fp ;		/* create a pipe from child */

    font_treeS = utDrbtree_init((utDcompareClientData) compare_fonts, NULL ) ;
    strcpy( command, "xlsfonts '*times*' '*courier*'" ) ;
    child_fp = utDexec_pipe( command, UTDEXEC_OPT_STDOUT|UTDEXEC_OPT_STDERR, &pid) ;
    if( child_fp ){
      while( (bufferptr = fgets( buffer, LRECL, child_fp) ) ){
	add_font( font_treeS, bufferptr) ;
      }
      UTDCLOSE( child_fp ) ;
      utDwait( &status ) ;
    }
} /* end initialize_xfonts() */

static void add_font( UTDTREEPTR font_tree, char *font)
{
    INT dash_count ;			/* count number of - */
    char *ptr ;				/* current place in string */
    FONTPTR font_p ;			/* current font record */
    /* -----------------------------------------------------------------
     * First count the number of -in font.  If 14 we have a full x font.
    ----------------------------------------------------------------- */
    for( dash_count = 0,ptr = font ; *ptr ; ptr++ ){
      if( *ptr == '-' ){
	dash_count++ ;
      }
    }
    if( dash_count != 14 ){
      return ; /* we can't do anything with this font */
    }
    /* -----------------------------------------------------------------
     * First count the number of -in font.  If 14 we have a full x font.
    ----------------------------------------------------------------- */
    font_p = UTDMALLOC( 1, FONT ) ;
    font = font_p->buffer = utDstrclone(font) ;
    decode_font( font_p, font ) ;
    utDrbtree_insert( font_tree, font_p ) ;

} /* end add_font() */

static char *font_end_field(char *font)
{
    for( ; *font ; font++ ){
      if( *font == '-' || *font == '\n' ){
	*font = EOS ;
	break ;
      }
    }
    return(font) ;
}

static void decode_font(FONTPTR font_p, char *font )
{
    /* foundary */
    font_p->foundary = ++font ; /* skip over leading - */
    font = font_end_field(font) ;
    /* family */
    font_p->family = ++font ;
    font = font_end_field(font) ;
    /* weight */
    font_p->weight = ++font ;
    font = font_end_field(font) ;
    /* slant */
    font_p->slant = ++font ; 
    font = font_end_field(font) ;
    /* sWidth */
    font_p->sWidth = ++font ; 
    font = font_end_field(font) ;
    /* style */
    font_p->style = ++font ; 
    font = font_end_field(font) ;
    /* pixelSize */
    font_p->pixelSize = ++font ; 
    font = font_end_field(font) ;
    /* pointSize */
    font_p->pointSize = ++font ; 
    font = font_end_field(font) ;
    /* resX */
    font_p->resX = ++font ; 
    font = font_end_field(font) ;
    /* resY */
    font_p->resY = ++font ; 
    font = font_end_field(font) ;
    /* spacing */
    font_p->spacing = ++font ; 
    font = font_end_field(font) ;
    /* avgWidth */
    font_p->avgWidth = ++font ; 
    font = font_end_field(font) ;
    /* registry */
    font_p->registry = ++font ; 
    font = font_end_field(font) ;
    /* encoding */
    font_p->encoding = ++font ; 
    font = font_end_field(font) ;
} /* end decode_font() */

static INT compare_fonts(FONTPTR font1,FONTPTR font2,void *clientData)
{
    return(strcmp(font1->family,font2->family) ) ;
} /* end compare_fonts() */

INT html_xfont(ClientData d_p,Tcl_Interp *inter,INT argc,CONST char *argv[])
{
  INT dist ;				/* current pointsize difference */
  INT best_dist ;			/* best pointsize difference */
  char font_buffer[LRECL] ;		/* copy the name of the font string */
  char new_font[LRECL] ;		/* build the name of new font */
  FONT fontrec ;			/* font recorded decoded */
  FONTPTR best_font ;			/* best font available */
  FONTPTR font_p ;			/* enumerate the fonts */
  UTDTREEITER iter ;			/* tree iterator */

  if( argc != 2 ){
    Tcl_AppendResult(inter, 
      "ERROR[twhtml_xfont]: syntax - twhtml_xfont <fontstring>\n", NULL ) ;
    return(TCL_ERROR) ;
  }
  strcpy( font_buffer, argv[1]) ;
  fontrec.buffer = font_buffer ;
  decode_font( &fontrec, font_buffer ) ;

  /* -----------------------------------------------------------------
   * Now look for the closest match greater or equal to the requested size
  ----------------------------------------------------------------- */
  best_dist = INT_MAX ;
  best_font = NULL ;
  for( font_p = utDrbtree_interval( font_treeS, &fontrec,&fontrec,UTDRBTREE_FIRST(&iter)) ; font_p;
       font_p = utDrbtree_interval( font_treeS, &fontrec,&fontrec,&iter) ){
    if( font_match( font_p, &fontrec ) ){
      dist = font_dist( font_p, &fontrec) ;
      if( dist >= 0 && dist <= best_dist ){
	best_font = font_p ;
	best_dist = dist ;
      }
    }
  }
  if( best_font ){
    sprintf( new_font, "-*-%s-%s-%s-%s-*-*-%s-*-*-*-*-*-*", best_font->family,
      best_font->weight, best_font->slant, best_font->sWidth, 
      best_font->pointSize ) ;
    Tcl_AppendResult( inter, new_font, NULL ) ;
    return(TCL_OK) ;
  }
  Tcl_AppendResult( inter, argv[1], NULL ) ;
  return(TCL_OK) ;
} /* end html_xfont() */

/* -----------------------------------------------------------------
 * See if font 1 matches font w.  Font 2 may have wildcards in it.
----------------------------------------------------------------- */
static BOOL font_match(FONTPTR font1_p, FONTPTR font2_p )
{
    if( *font1_p->foundary && *font1_p->foundary != '*' &&
        *font2_p->foundary && *font2_p->foundary != '*' ){
      if( strcmp( font1_p->foundary, font2_p->foundary) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->family && *font1_p->family != '*' &&
        *font2_p->family && *font2_p->family != '*' ){
      if( strcmp( font1_p->family, font2_p->family) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->weight && *font1_p->weight != '*' &&
        *font2_p->weight && *font2_p->weight != '*' ){
      if( strcmp( font1_p->weight, font2_p->weight) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->slant && *font1_p->slant != '*' &&
        *font2_p->slant && *font2_p->slant != '*' ){
      if( strcmp( font1_p->slant, font2_p->slant) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->sWidth && *font1_p->sWidth != '*' &&
        *font2_p->sWidth && *font2_p->sWidth != '*' ){
      if( strcmp( font1_p->sWidth, font2_p->sWidth) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->style && *font1_p->style != '*' &&
        *font2_p->style && *font2_p->style != '*' ){
      if( strcmp( font1_p->style, font2_p->style) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->pixelSize && *font1_p->pixelSize != '*' &&
        *font2_p->pixelSize && *font2_p->pixelSize != '*' ){
      if( strcmp( font1_p->pixelSize, font2_p->pixelSize) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
#ifdef NEVER
    /* we are looking for all matches regardless of pointSize */
    if( *font1_p->pointSize && *font1_p->pointSize != '*' &&
        *font2_p->pointSize && *font2_p->pointSize != '*' ){
      if( strcmp( font1_p->pointSize, font2_p->pointSize) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
#endif /* NEVER */
    if( *font1_p->resX && *font1_p->resX != '*' &&
        *font2_p->resX && *font2_p->resX != '*' ){
      if( strcmp( font1_p->resX, font2_p->resX) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->resY && *font1_p->resY != '*' &&
        *font2_p->resY && *font2_p->resY != '*' ){
      if( strcmp( font1_p->resY, font2_p->resY) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->spacing && *font1_p->spacing != '*' &&
        *font2_p->spacing && *font2_p->spacing != '*' ){
      if( strcmp( font1_p->spacing, font2_p->spacing) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->avgWidth && *font1_p->avgWidth != '*' &&
        *font2_p->avgWidth && *font2_p->avgWidth != '*' ){
      if( strcmp( font1_p->avgWidth, font2_p->avgWidth) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->registry && *font1_p->registry != '*' &&
        *font2_p->registry && *font2_p->registry != '*' ){
      if( strcmp( font1_p->registry, font2_p->registry) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    if( *font1_p->encoding && *font1_p->encoding != '*' &&
        *font2_p->encoding && *font2_p->encoding != '*' ){
      if( strcmp( font1_p->encoding, font2_p->encoding) != STRINGEQ ){
	return(FALSE) ;
      }
    } 
    return(TRUE) ;
} /* end font_match() */

/* -----------------------------------------------------------------
 * Calculates font1->pointSize- font2->pointSize ;
----------------------------------------------------------------- */
static INT font_dist(FONTPTR font1_p, FONTPTR font2_p)
{
    INT dist ;			/* dist in point size */
    INT size1 ;			/* size of font 1 in points */
    INT size2 ;			/* size of font 2 in points */

    size1 = atoi(font1_p->pointSize) ;
    size2 = atoi(font2_p->pointSize) ;
    dist = size1 - size2 ;
    return( dist ) ;
} /* end font_dist() */

char *html_render_proc( char *render_proc )
{
    if( render_proc ){
      if( render_funcS ){
	/* Don't do more work than we have to do */
	if( strcmp( render_funcS, render_proc ) != STRINGEQ ){
	  UTDFREE( render_funcS ) ;
	  render_funcS = utDstrclone(render_proc) ;
	}
      } else {
	/* nothing installed */
	render_funcS = utDstrclone(render_proc) ;
      }
    }
    return(render_funcS) ;
} /* end html_render_proc() */
