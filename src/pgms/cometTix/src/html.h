/* ----------------------------------------------------------------- 
FILE:	    html.h
DESCRIPTION:This file contains declarations for the html parser.
CONTENTS:   
DATE:	    Thu Jul  9 10:41:13 CDT 1998
----------------------------------------------------------------- */
#ifndef HTML_H
#define HTML_H


/* ***************** PROTOTYPES ******************** */
/* ----------------------------------------------------------------- 
FILE:	    EZ/tcl/                                       
----------------------------------------------------------------- */
extern INT EZeval_html(Tcl_Interp *interp) ;
extern INT EZeval_html_library(Tcl_Interp *interp) ;
/* ----------------------------------------------------------------- 
FILE:	    html_parse.c                                       
----------------------------------------------------------------- */
extern void html_parse_init(void) ;
extern INT html_render(ClientData,Tcl_Interp *,char *,char *,char *,LONG,BOOL) ;
extern char *html_render_proc( char *render_proc ) ;
extern char *html_cond(ClientData d_p,Tcl_Interp *inter,INT argc,char *argv[],
                       BOOL *state,BOOL *needs_html_output,char **render) ;
extern INT html_tokenize_tag(char *str) ;

extern INT parse_func(ClientData d_p,Tcl_Interp *i_p,INT objc,
                      Tcl_Obj * CONST objv[]) ;
extern INT html_xfont(ClientData d_p,Tcl_Interp *inter,INT argc,CONST char *argv[]) ;

#endif /* GLOBALS_H */
