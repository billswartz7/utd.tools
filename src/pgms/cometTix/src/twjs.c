/* -*- Mode: C; tab-width: 8; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 *
 * The contents of this file are subject to the Netscape Public License
 * Version 1.0 (the "NPL"); you may not use this file except in
 * compliance with the NPL.  You may obtain a copy of the NPL at
 * http://www.mozilla.org/NPL/
 *
 * Software distributed under the NPL is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the NPL
 * for the specific language governing rights and limitations under the
 * NPL.
 *
 * The Initial Developer of this code under the NPL is Netscape
 * Communications Corporation.  Portions created by Netscape are
 * Copyright (C) 1998 Netscape Communications Corporation.  All Rights
 * Reserved.
 */

/*
 * JS shell.
 */
#include <cometconfig.h>
#define JSFILE
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <js/prtypes.h>
#include <js/prarena.h>
#include <js/prassert.h>
#include <js/prprintf.h>
#include <js/jsapi.h>
#include <js/jsatom.h>
#include <js/jscntxt.h>
#include <js/jsdbgapi.h>
#include <js/jsemit.h>
#include <js/jsfun.h>
#include <js/jsgc.h>
#include <js/jslock.h>
#include <js/jsobj.h>
#include <js/jsparse.h>
#include <js/jsscan.h>
#include <js/jsscope.h>
#include <js/jsscript.h>
#include <js/jsmalloc.h>

#define TWJS_INTERNAL
#include <utd/base.h>
#include <utd/string.h>
#include <utd/msg.h>
#include <utd/debug.h>
#include <js/twjs.h>
#include <tcl/tcl.h>
#include "html.h"

#ifdef XP_UNIX
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#endif

/* ********************** TYPE DEFINITIONS ************************* */
#define APPEND_STRING	-1

/* ***************** STATIC VARIABLE DEFINITIONS ******************* */
static Tcl_Interp *tcl_interpS ;
static Tcl_DString jstcl_cmdS ;

/* ***************** STATIC FUNCTION DEFINITIONS ******************* */
static char *exec_js( JSContext *cx, JSObject *obj, char *variable ) ;
static char *lookup_var( JSContext *cx, JSObject *obj, char *variable ) ;
static void reset_all_variables(JSContext *cx, JSObject *obj);

static JSBool 
js_eval_tcl(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i, n;
    JSString *str;			/* unicoded argument */
    JSString *answer;			/* unicode Tcl answer */
    INT code ;				/* return code from Tcl */
    char *command ;			/* Tcl command */
    char *result ;			/* result from Tcl */

    if(!(tcl_interpS)){
      return(JS_FALSE) ;
    }

    D( "js_eval_tcl", 
      fprintf(stderr, "We are in js_eval_tcl\n" ) ;
      for (i = n = 0; i < argc; i++) {
	  str = JS_ValueToString(cx, argv[i]);
	  if (!str)
	      return JS_FALSE;
	  fprintf(stderr,"argv[%d]:%s\n", i, JS_GetStringBytes(str));
	  n++;
      }
    ) ;
    if( argc >= 1 ){
      str = JS_ValueToString(cx, argv[0]);
      if(!(str)){
	return(JS_FALSE) ;
      }
      command = JS_GetStringBytes(str) ;
      if(!(command)){
	return(JS_FALSE) ;
      }
      code = Tcl_Eval( tcl_interpS, command ) ;
      fprintf( stderr, "command:%s\n", command ) ;
      result = (char *) Tcl_GetStringResult(tcl_interpS) ;
      if( result && *result ){
	answer = JS_NewString(cx, result, strlen(result));
	if( answer ){
	  *rval = STRING_TO_JSVAL(answer) ;
	}
      }
    }
    return(JS_TRUE) ;

} /* end js_eval_tcl() */


/* -----------------------------------------------------------------
 * The format of the JS_TCL command is very specific. 
 * JS_TCL(PROCEDURE="...").  The function is Tcl executed and output
 * is rendered as text.
----------------------------------------------------------------- */
static JSBool 
js_eval_tcl_html(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i ;
    JSString *str;			/* unicoded argument */
    JSString *answer;			/* unicode Tcl answer */
    INT code ;				/* return code from Tcl */
    char *tkwindow ;			/* tk window */
    char *render_proc ;			/* Tcl render procedure */
    char result_buf[BUFSIZ] ;		/* build the reply */
    char reset_vars[BUFSIZ] ;		/* reset the variables */
    char *result ;			/* result from Tcl */
    char *procedure ;			/* procedure name */

    if(!(tcl_interpS)){
      return(JS_FALSE) ;
    }

    D( "js_eval_tcl_html", 
      fprintf(stderr, "We are in js_eval_tcl_html\n" ) ;
      for( i = 0; i < argc; i++) {
	  str = JS_ValueToString(cx, argv[i]);
	  if (!str){
	    return JS_FALSE;
	  }
	  fprintf(stderr,"argv[%d]:%s\n", i, JS_GetStringBytes(str));
      }
    ) ;

    /* -----------------------------------------------------------------
     * Absolutely need procedure.  By naming a variable, we
     * cause javascript to look up its values.  For example, 'procedure'
     * is equivalent to * 'set procedure' in Tcl.
    ----------------------------------------------------------------- */
    procedure = lookup_var( cx, obj, "procedure" ) ;
    if(!(procedure) || !(*procedure) ){
      reset_all_variables( cx, obj ) ; /* for safety */
      sprintf( result_buf, "ERROR[js_eval_tcl_html]: missing procedure.\n" ) ;
      answer = JS_NewString(cx, result_buf, strlen(result_buf));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
      return(FALSE) ;
    }
    tkwindow = lookup_var( cx, obj, "tkwindow_fake" ) ;
    if(!(tkwindow) || !(*tkwindow) ){
      reset_all_variables( cx, obj ) ; /* for safety */
      sprintf( result_buf, 
	"ERROR[js_eval_tcl_html]: missing tkwindow.\n") ;
      answer = JS_NewString(cx, result_buf, strlen(result_buf));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
      return(FALSE) ;
    }

    /* -----------------------------------------------------------------
     * Build the command. ezeval_tk win param
     * param = procedure="..." args="..."
     * At the same time build the reset script to reset JS variables.
    ----------------------------------------------------------------- */
    reset_vars[0] = EOS ;
    strcat( reset_vars, "procedure=\"\";PROCEDURE=\"\";" ) ;
    /* -----------------------------------------------------------------
     * Now set all the variables back to null.  We do this before evaluating
     * the Tcl so that the return codes will be correct.
    ----------------------------------------------------------------- */
    exec_js( cx, obj, reset_vars ) ;

    /* -----------------------------------------------------------------
     * Now it is safe to execute the Tk command to build the widget.
     * Set up the return codes.
    ----------------------------------------------------------------- */
    code = Tcl_Eval( tcl_interpS, procedure ) ;
    result = (char *) Tcl_GetStringResult(tcl_interpS) ;
    if( result && *result ){
      render_proc = html_render_proc( NULL ) ;
      html_render(NULL,tcl_interpS,tkwindow,render_proc,result,strlen(result), FALSE ) ;
      answer = JS_NewString(cx, result, strlen(result));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
    }
    return(JS_TRUE) ;

} /* end js_eval_tcl_html() */

/* -----------------------------------------------------------------
 * The format of the JS_TK command is very specific. 
 * JS_TK(PROCEDURE="...", TKWINDOW="...", [ARGS="...",] [WIDTH="...",]
 * [HEIGHT="...",] [ALIGN="..."] [PADX="...",] [PADY="..."] [ALT="..."])
 * In order to make this code work for both the Netscape plugin and
 * our native browser, we must perform a kludge.  We will use the
 * javascript variable to tkwindow_fake instead of window to pass the
 * tk window path id to the native browser because Tk supplies the
 * name of the window unlike the netscape browser.  We accumulate the
 * window and the params into a ezeval_tk call which has the following
 * parameters  ezeval_tk $win $param. 
----------------------------------------------------------------- */
static JSBool 
js_eval_tk(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i ;
    JSString *str;			/* unicoded argument */
    JSString *answer;			/* unicode Tcl answer */
    INT code ;				/* return code from Tcl */
    char *tcl_cmd ;			/* Tcl command */
    char result_buf[BUFSIZ] ;		/* build the reply */
    char params[LRECL] ;		/* build the parmeters to tk command */
    char option[BUFSIZ] ;		/* options */
    char reset_vars[BUFSIZ] ;		/* reset the variables */
    char *result ;			/* result from Tcl */
    char *procedure ;			/* procedure name */
    char *tkwindow ;			/* tk window */
    char *tkargs ;			/* tk arguments */
    char *tkwidth ;			/* tk width */
    char *tkheight ;			/* tk height */
    char *tkaltwidth ;			/* tk alternative width */
    char *tkaltheight ;			/* tk alternative height */
    char *tkalign ;			/* tk alignment */
    char *tkpadx ;			/* tk pad x */
    char *tkpady ;			/* tk pad y */
    char *tkalt ;			/* tk alt */

    if(!(tcl_interpS)){
      return(JS_FALSE) ;
    }

    D( "js_eval_tk", 
      fprintf(stderr, "We are in js_eval_tk\n" ) ;
      for( i = 0; i < argc; i++) {
	  str = JS_ValueToString(cx, argv[i]);
	  if (!str){
	    return JS_FALSE;
	  }
	  fprintf(stderr,"argv[%d]:%s\n", i, JS_GetStringBytes(str));
      }
    ) ;

    /* -----------------------------------------------------------------
     * Absolutely need procedure and window.  By naming a variable, we
     * cause javascript to look up its values.  For example, 'procedure'
     * is equivalent to * 'set procedure' in Tcl.
    ----------------------------------------------------------------- */
    procedure = lookup_var( cx, obj, "procedure" ) ;
    if(!(procedure) || !(*procedure) ){
      reset_all_variables( cx, obj ) ; /* for safety */
      sprintf( result_buf, "ERROR[js_eval_tk]: missing procedure.\n" ) ;
      answer = JS_NewString(cx, result_buf, strlen(result_buf));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
      return(FALSE) ;
    }

    tkwindow = lookup_var( cx, obj, "tkwindow_fake" ) ;
    if(!(tkwindow) || !(*tkwindow) ){
      reset_all_variables( cx, obj ) ; /* for safety */
      sprintf( result_buf, "ERROR[js_eval_tk]: missing tkwindow. proc=%s\n",
	procedure) ;
      answer = JS_NewString(cx, result_buf, strlen(result_buf));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
      return(FALSE) ;
    }
    /* -----------------------------------------------------------------
     * Next look for the options.
    ----------------------------------------------------------------- */
    tkargs = lookup_var( cx, obj, "args" ) ;
    tkwidth = lookup_var( cx, obj, "width" ) ;
    tkheight = lookup_var( cx, obj, "height" ) ;
    tkaltwidth = lookup_var( cx, obj, "altw" ) ;
    tkaltheight = lookup_var( cx, obj, "alth" ) ;
    tkalign = lookup_var( cx, obj, "align" ) ;
    tkpadx = lookup_var( cx, obj, "padx" ) ;
    tkpady = lookup_var( cx, obj, "pady" ) ;
    tkalt = lookup_var( cx, obj, "alt" ) ;

    /* -----------------------------------------------------------------
     * Build the command. ezeval_tk win param
     * param = procedure="..." args="..."
     * At the same time build the reset script to reset JS variables.
    ----------------------------------------------------------------- */
    reset_vars[0] = EOS ;
    strcat( reset_vars, "procedure=\"\";PROCEDURE=\"\";" ) ;
    sprintf( params, "procedure=\"%s\"", procedure ) ;
    if( tkargs && *tkargs ){
      sprintf( option, " args=\"%s\"", tkargs ) ;
      strcat( params, option ) ;
      strcat( reset_vars, "args=\"\";ARGS=\"\";" ) ;
    }
    if( tkwidth && *tkwidth ){
      sprintf( option, " width=\"%s\"", tkwidth ) ;
      strcat( params, option ) ;
      strcat( reset_vars, "width=\"\";WIDTH=\"\";" ) ;
    }
    if( tkheight && *tkheight ){
      sprintf( option, " height=\"%s\"", tkheight ) ;
      strcat( params, option ) ;
      strcat( reset_vars, "height=\"\";HEIGHT=\"\";" ) ;
    }
    if( tkaltwidth && *tkaltwidth ){
      sprintf( option, " altw=\"%s\"", tkaltwidth ) ;
      strcat( params, option ) ;
      strcat( reset_vars, "altw=\"\";ALTW=\"\";" ) ;
    }
    if( tkaltheight && *tkaltheight ){
      sprintf( option, " alth=\"%s\"", tkaltheight ) ;
      strcat( params, option ) ;
      strcat( reset_vars, "alth=\"\";ALTH=\"\";" ) ;
    }
    if( tkalign && *tkalign ){
      sprintf( option, " align=\"%s\"", tkalign ) ;
      strcat( params, option ) ;
      strcat( reset_vars, "align=\"\";ALIGN=\"\";" ) ;
    }
    if( tkpadx && *tkpadx ){
      sprintf( option, " padx=\"%s\"", tkpadx ) ;
      strcat( params, option ) ;
      strcat( reset_vars, "padx=\"\";PADX=\"\";" ) ;
    }
    if( tkpady && *tkpady ){
      sprintf( option, " pady=\"%s\"", tkpady ) ;
      strcat( params, option ) ;
      strcat( reset_vars, "pady=\"\";PADY=\"\";" ) ;
    }
    if( tkalt && *tkalt ){
      sprintf( option, " alt=\"%s\"", tkalt ) ;
      strcat( params, option ) ;
      strcat( reset_vars, "alt=\"\";ALT=\"\";" ) ;
    }
    /* Was ...
       sprintf( cmd, "ezeval_tk %s {%s}\n", tkwindow, params ) ;
    */
    Tcl_DStringReinit(&jstcl_cmdS) ;
    Tcl_DStringAppend(&jstcl_cmdS, "ezeval_tk ", APPEND_STRING) ;
    Tcl_DStringAppend(&jstcl_cmdS, tkwindow, APPEND_STRING) ;
    Tcl_DStringStartSublist(&jstcl_cmdS) ;
    Tcl_DStringAppend(&jstcl_cmdS, params, APPEND_STRING) ;
    Tcl_DStringEndSublist(&jstcl_cmdS) ;
    Tcl_DStringAppend(&jstcl_cmdS, "\n", APPEND_STRING) ;
    tcl_cmd = Tcl_DStringValue(&jstcl_cmdS) ;

    /* -----------------------------------------------------------------
     * Now set all the variables back to null.  We do this before evaluating
     * the Tcl so that the return codes will be correct.
    ----------------------------------------------------------------- */
    exec_js( cx, obj, reset_vars ) ;

    /* -----------------------------------------------------------------
     * Now it is safe to execute the Tk command to build the widget.
     * Set up the return codes.
    ----------------------------------------------------------------- */
    code = Tcl_Eval( tcl_interpS, tcl_cmd ) ;
    result = (char *) Tcl_GetStringResult(tcl_interpS) ;
    if( code != TCL_OK ){
      utDmsgf( WARNMSG,MSG_AT,"js_eval_tk", "%s\n", result ) ;
    }
    if( result && *result ){
      answer = JS_NewString(cx, result, strlen(result));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
    }
    return(JS_TRUE) ;

} /* end js_eval_tk() */

/* -----------------------------------------------------------------
 * The format of the JS_COND command is very specific. 
 * JS_COND(EXPR="...", HTML="..." [LOGIC="negative"]) In order to make
 * this code work for both the Netscape plugin and our native browser, 
 * we must perform a kludge. 
 * We will use the javascript variable to TKWINDOW_FAKE instead of 
 * TKWINDOW to pass the tk window path id to the native browser because 
 * Tk supplies the name of the window unlike the netscape browser.  
 * In addition the JS_COND takes inherits all of the properties of the
 * JS_TK function.
----------------------------------------------------------------- */
static JSBool 
js_cond(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i ;
    JSString *str;			/* unicoded argument */
    JSString *answer;			/* unicode Tcl answer */
    char result_buf[BUFSIZ] ;		/* build the reply */
    char reset_vars[BUFSIZ] ;		/* reset the variables */
    char *result ;			/* result from Tcl */
    char *procedure ;			/* procedure name */
    char *expr ;			/* Tcl expression to be evaluated */
    char *text ;			/* HTML to be passed as Text. */
    char *tkwindow ;			/* tk window */
    char *tklogic ;			/* logic associated with variable */
    char *tkplacement ;			/* tk placement before/after html */
    char *render_proc ;			/* Tcl render procedure */
    char *tclargv[10] ;			/* build a argument vector */
    BOOL out_state ;			/* output state */
    BOOL needs_html_output ;		/* need html output */
    JSBool rcode ;			/* return code from Tk code eval */

    if(!(tcl_interpS)){
      return(JS_FALSE) ;
    }

    D( "js_cond", 
      fprintf(stderr, "We are in js_cond\n" ) ;
      for( i = 0; i < argc; i++) {
	  str = JS_ValueToString(cx, argv[i]);
	  if (!str){
	    return JS_FALSE;
	  }
	  fprintf(stderr,"argv[%d]:-> %s\n", i, JS_GetStringBytes(str));
      }
    ) ;

    /* -----------------------------------------------------------------
     * Absolutely need expr, html, and window. By naming a variable,
     * we cause javascript to look up its values.  For example, 'html'
     * is equivalent to * 'set html' in Tcl.
    ----------------------------------------------------------------- */
    expr = lookup_var( cx, obj, "expr" ) ;
    if(!(expr) || !(*expr) ){
      reset_all_variables( cx, obj ) ; /* for safety */
      sprintf( result_buf, "ERROR[js_cond]: missing expression.\n" ) ;
      answer = JS_NewString(cx, result_buf, strlen(result_buf));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
      return(FALSE) ;
    }

    text = lookup_var( cx, obj, "html" ) ;
    if(!(text) || !(*text) ){
      reset_all_variables( cx, obj ) ; /* for safety */
      sprintf( result_buf, "ERROR[js_cond]: missing html. expr=%s\n", text ) ;
      answer = JS_NewString(cx, result_buf, strlen(result_buf));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
      return(FALSE) ;
    }

    tkwindow = lookup_var( cx, obj, "tkwindow_fake" ) ;
    if(!(tkwindow) || !(*tkwindow) ){
      reset_all_variables( cx, obj ) ; /* for safety */
      sprintf( result_buf, 
	"ERROR[js_eval_tk]: missing tkwindow. expr=%s html=%s\n",
	expr, text) ;
      answer = JS_NewString(cx, result_buf, strlen(result_buf));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
      return(FALSE) ;
    }
    /* -----------------------------------------------------------------
     * Next look for the options.
    ----------------------------------------------------------------- */
    tklogic = lookup_var( cx, obj, "logic" ) ;
    tkplacement = lookup_var( cx, obj, "tkplacement" ) ;
   
    /* -----------------------------------------------------------------
     * Set unused options to NULL. Also set reset variables.
    ----------------------------------------------------------------- */
    reset_vars[0] = EOS ;
    strcat( reset_vars, "expr=\"\";EXPR=\"\";" ) ;
    strcat( reset_vars, "html=\"\";HTML=\"\";" ) ;
    if( !(tklogic) || !(*tklogic) ){
      tklogic = NULL ;
    } else {
      strcat( reset_vars, "logic=\"\";LOGIC=\"\";" ) ;
    }
    if( !(tkplacement) || !(*tkplacement) ){
      tkplacement = NULL ;
    } else {
      strcat( reset_vars, "tkplacement=\"\";TKPLACEMENT=\"\";" ) ;
    }

    /* -----------------------------------------------------------------
     * Now call the ichtml_cond function with all of the parsed parameters.
     * This will call Tcl functions.
    ----------------------------------------------------------------- */
    tclargv[1] = tkwindow ;
    tclargv[2] = expr ;
    tclargv[3] = text ;
    tclargv[4] = tklogic ;
    tclargv[5] = tkplacement ;
    result = html_cond(NULL, tcl_interpS, 6, tclargv, &out_state, 
                       &needs_html_output,&render_proc) ;

    /* -----------------------------------------------------------------
     * Now see if we need to execute a Tk widget.
    ----------------------------------------------------------------- */
    procedure = lookup_var( cx, obj, "procedure" ) ;
    if( out_state ){
      if( procedure && (*procedure) ){
	/* call the JS_Tk function */
	rcode = js_eval_tk(cx, obj, argc, argv, rval) ;
      }
      if( needs_html_output ){
	html_render(NULL,tcl_interpS,tkwindow,render_proc,text,strlen(text), FALSE ) ;
      }
    } else {
      if( procedure && (*procedure) ){
	/* need to reset state variables for Tk widget */
	strcat( reset_vars, "procedure=\"\";PROCEDURE=\"\";" ) ;
	strcat( reset_vars, "args=\"\";ARGS=\"\";" ) ;
	strcat( reset_vars, "width=\"\";WIDTH=\"\";" ) ;
	strcat( reset_vars, "height=\"\";HEIGHT=\"\";" ) ;
	strcat( reset_vars, "altw=\"\";ALTW=\"\";" ) ;
	strcat( reset_vars, "alth=\"\";ALTH=\"\";" ) ;
	strcat( reset_vars, "align=\"\";ALIGN=\"\";" ) ;
	strcat( reset_vars, "padx=\"\";PADX=\"\";" ) ;
	strcat( reset_vars, "pady=\"\";PADY=\"\";" ) ;
	strcat( reset_vars, "alt=\"\";ALT=\"\";" ) ;
	strcat( reset_vars, "placement=\"\";PLACEMENT=\"\";" ) ;
      }
    }

    /* -----------------------------------------------------------------
     * Now set all the variables back to null.  We do this before evaluating
     * the Tcl so that the return codes will be correct.
    ----------------------------------------------------------------- */
    exec_js( cx, obj, reset_vars ) ;

    /* -----------------------------------------------------------------
     * Now set up the return codes.
    ----------------------------------------------------------------- */
    if( result && *result ){
      answer = JS_NewString(cx, result, strlen(result));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
    }
    return(JS_TRUE) ;

} /* end js_cond() */


/* -----------------------------------------------------------------
 * The format of the JS_HTML command is very specific. 
 * JS_HTML(html).  This is only used for the native browser.
----------------------------------------------------------------- */
static JSBool 
js_html(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i ;
    JSString *str;			/* unicoded argument */
    JSString *answer;			/* unicode Tcl answer */
    INT len ;				/* length of string */
    char result_buf[BUFSIZ] ;		/* build the reply */
    char *html ;			/* HTML to be passed as Text. */
    char *render_proc ;			/* Tcl render proc */
    char *tkwindow ;			/* tk window */

    if(!(tcl_interpS)){
      return(JS_FALSE) ;
    }

    /* -----------------------------------------------------------------
     * Make sure we get just one argument.
    ----------------------------------------------------------------- */
    D( "js_html", 
      fprintf(stderr, "We are in js_html\n" ) ;
      for( i = 0; i < argc; i++) {
	  str = JS_ValueToString(cx, argv[i]);
	  if (!str){
	    return JS_FALSE;
	  }
	  fprintf(stderr,"argv[%d]:%s\n", i, JS_GetStringBytes(str));
      }
    ) ;

    if( argc >= 1 ){
      str = JS_ValueToString(cx, argv[0]);
      html = JS_GetStringBytes(str) ;
    } else {
      sprintf( result_buf, 
	"ERROR[js_html]: wrong number of arguments to JS_HTML.\n") ;
      answer = JS_NewString(cx, result_buf, strlen(result_buf));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
      return(FALSE) ;
      
    }

    tkwindow = lookup_var( cx, obj, "tkwindow_fake" ) ;
    if(!(tkwindow) || !(*tkwindow) ){
      reset_all_variables( cx, obj ) ; /* for safety */
      sprintf( result_buf, 
	"ERROR[js_html]: missing tkwindow.\n") ;
      answer = JS_NewString(cx, result_buf, strlen(result_buf));
      if( answer ){
	*rval = STRING_TO_JSVAL(answer) ;
      }
      return(FALSE) ;
    }

    /* -----------------------------------------------------------------
     * Now build up the arguments to html render.
    ----------------------------------------------------------------- */
    if( html ){
      len = strlen(html) ;
      if( len > 0 ){
	render_proc = html_render_proc(NULL) ;
	html_render(NULL,tcl_interpS,tkwindow,render_proc,html,len,FALSE) ;
      }
    }
    return(JS_TRUE) ;

} /* end js_html() */


static JSBool
Load(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i;
    JSString *str;
    const char *filename;
    JSScript *script;
    JSBool ok;
    jsval result;

    for (i = 0; i < argc; i++) {
	str = JS_ValueToString(cx, argv[i]);
	if (!str)
	    return JS_FALSE;
	argv[i] = STRING_TO_JSVAL(str);
	filename = JS_GetStringBytes(str);
	errno = 0;
	script = JS_CompileFile(cx, obj, filename);
	if (!script) {
	    fprintf(stderr, "js: cannot load %s", filename);
	    if (errno)
		fprintf(stderr, ": %s", strerror(errno));
	    putc('\n', stderr);
	    continue;
	}
	ok = JS_ExecuteScript(cx, obj, script, &result);
	JS_DestroyScript(cx, script);
	if (!ok)
	    return JS_FALSE;
    }
    return JS_TRUE;
}

static JSBool
Print(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i, n;
    JSString *str;

    for (i = n = 0; i < argc; i++) {
	str = JS_ValueToString(cx, argv[i]);
	if (!str)
	    return JS_FALSE;
	printf("%s%s", i ? " " : "", JS_GetStringBytes(str));
	n++;
    }
    if (n)
	putchar('\n');
    return JS_TRUE;
}

static JSBool
Help(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval);

#ifdef GC_MARK_DEBUG
extern JS_FRIEND_DATA(FILE *) js_DumpGCHeap;
#endif

static JSBool
GC(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSRuntime *rt;
    uint32 preBytes;

    rt = cx->runtime;
    preBytes = rt->gcBytes;
#ifdef GC_MARK_DEBUG
    if (argc && JSVAL_IS_STRING(argv[0])) {
    	char *name = JS_GetStringBytes(JSVAL_TO_STRING(argv[0]));
    	FILE *file = fopen(name, "w");
    	if (!file) {
	    fprintf(stderr, "gc: can't open %s: %s\n", strerror(errno));
	    return JS_FALSE;
    	}
    	js_DumpGCHeap = file;
    } else {
	js_DumpGCHeap = stdout;
    }
#endif
    js_ForceGC(cx);
#ifdef GC_MARK_DEBUG
    if (js_DumpGCHeap != stdout)
    	fclose(js_DumpGCHeap);
    js_DumpGCHeap = NULL;
#endif
    printf("before %lu, after %lu, break %08lx\n",
	   (unsigned long)preBytes, (unsigned long)rt->gcBytes,
#ifdef XP_UNIX
	   (unsigned long)sbrk(0)
#else
	   0L
#endif
	   );
#ifdef JS_GCMETER
    js_DumpGCStats(rt, stdout);
#endif
    return JS_TRUE;
}

static JSBool
GetTrapArgs(JSContext *cx, uintN argc, jsval *argv, JSScript **scriptp,
	    int32 *ip)
{
    uintN intarg;
    JSFunction *fun;

    *scriptp = cx->fp->down->script;
    *ip = 0;
    if (argc != 0) {
	intarg = 0;
	if (JS_TypeOfValue(cx, argv[0]) == JSTYPE_FUNCTION) {
	    fun = JS_ValueToFunction(cx, argv[0]);
	    if (!fun)
		return JS_FALSE;
	    *scriptp = fun->script;
	    intarg++;
	}
	if (argc > intarg) {
	    if (!JS_ValueToInt32(cx, argv[intarg], ip))
		return JS_FALSE;
	}
    }
    return JS_TRUE;
}

static JSTrapStatus
TrapHandler(JSContext *cx, JSScript *script, jsbytecode *pc, jsval *rval,
	    void *closure)
{
    JSString *str;
    JSStackFrame *caller;

    str = closure;
    caller = cx->fp->down;
    if (!JS_EvaluateScript(cx, caller->scopeChain,
			   JS_GetStringBytes(str), JS_GetStringLength(str),
			   caller->script->filename, caller->script->lineno,
			   rval)) {
	return JSTRAP_ERROR;
    }
    if (*rval != JSVAL_VOID)
	return JSTRAP_RETURN;
    return JSTRAP_CONTINUE;
}

static JSBool
Trap(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSString *str;
    JSScript *script;
    int32 i;

    if (argc == 0) {
	JS_ReportError(cx, "usage: trap [fun] [pc] expr");
	return JS_FALSE;
    }
    argc--;
    str = JS_ValueToString(cx, argv[argc]);
    if (!str)
	return JS_FALSE;
    argv[argc] = STRING_TO_JSVAL(str);
    if (!GetTrapArgs(cx, argc, argv, &script, &i))
	return JS_FALSE;
    return JS_SetTrap(cx, script, script->code + i, TrapHandler, str);
}

static JSBool
Untrap(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSScript *script;
    int32 i;

    if (!GetTrapArgs(cx, argc, argv, &script, &i))
	return JS_FALSE;
    JS_ClearTrap(cx, script, script->code + i, NULL, NULL);
    return JS_TRUE;
}

static JSBool
LineToPC(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSScript *script;
    int32 i;
    uintN lineno;
    jsbytecode *pc;

    if (argc == 0) {
	JS_ReportError(cx, "usage: line2pc [fun] line");
	return JS_FALSE;
    }
    script = cx->fp->down->script;
    if (!GetTrapArgs(cx, argc, argv, &script, &i))
	return JS_FALSE;
    lineno = (i == 0) ? script->lineno : (uintN)i;
    pc = JS_LineNumberToPC(cx, script, lineno);
    if (!pc)
	return JS_FALSE;
    *rval = INT_TO_JSVAL(pc - script->code);
    return JS_TRUE;
}

static JSBool
PCToLine(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSScript *script;
    int32 i;
    uintN lineno;

    if (!GetTrapArgs(cx, argc, argv, &script, &i))
	return JS_FALSE;
    lineno = JS_PCToLineNumber(cx, script, script->code + i);
    if (!lineno)
	return JS_FALSE;
    *rval = INT_TO_JSVAL(lineno);
    return JS_TRUE;
}

#ifdef DEBUG

static void
SingleNote(JSContext *cx, JSFunction *fun )
{
    uintN offset, delta;
    jssrcnote *notes, *sn;
    JSSrcNoteType type;
    jsatomid atomIndex;
    JSAtom *atom;

    notes = fun->script->notes;
    if (notes) {
	printf("\nSource notes:\n");
	offset = 0;
	for (sn = notes; !SN_IS_TERMINATOR(sn); sn = SN_NEXT(sn)) {
	    delta = SN_DELTA(sn);
	    offset += delta;
	    printf("%3u: %5u [%4u] %-8s",
		   sn - notes, offset, delta, js_SrcNoteName[SN_TYPE(sn)]);
	    type = SN_TYPE(sn);
	    switch (type) {
	      case SRC_SETLINE:
		printf(" lineno %u", (uintN) js_GetSrcNoteOffset(sn, 0));
		break;
	      case SRC_FOR:
		printf(" cond %u update %u tail %u",
		       (uintN) js_GetSrcNoteOffset(sn, 0),
		       (uintN) js_GetSrcNoteOffset(sn, 1),
		       (uintN) js_GetSrcNoteOffset(sn, 2));
		break;
	      case SRC_COMMA:
	      case SRC_PCBASE:
		printf(" offset %u", (uintN) js_GetSrcNoteOffset(sn, 0));
		break;
	      case SRC_LABEL:
	      case SRC_LABELBRACE:
	      case SRC_BREAK2LABEL:
	      case SRC_CONT2LABEL:
	      case SRC_FUNCDEF:
		atomIndex = (jsatomid) js_GetSrcNoteOffset(sn, 0);
		atom = js_GetAtom(cx, &fun->script->atomMap, atomIndex);
		printf(" atom %u (%s)", (uintN)atomIndex, ATOM_BYTES(atom));
		break;
	      default:;
	    }
	    putchar('\n');
	}
    }
}

static JSBool
Notes(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i;
    JSFunction *fun;

    for (i = 0; i < argc; i++) {
	fun = JS_ValueToFunction(cx, argv[i]);
	if (!fun)
	    return JS_FALSE;

	SingleNote(cx, fun);
    }
    return JS_TRUE;
}

static JSBool
ExceptionTable(JSContext *cx, JSFunction *fun)
{
    JSTryNote *iter = fun->script->trynotes;

    if (!iter)
	return JS_TRUE;
    printf("\nException table:\nstart\tend\tcatch\tfinally\n");
    while (iter->start && iter->end) {
	printf("  %d\t%d\t%d\t%d\n",
	       iter->start, iter->end, iter->catch, iter->finally);
	iter++;
    }
    return JS_TRUE;
}

static JSBool
Disassemble(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSBool lines;
    uintN i;
    JSFunction *fun;

    if (argc > 0 &&
	JSVAL_IS_STRING(argv[0]) &&
	!strcmp(JS_GetStringBytes(JSVAL_TO_STRING(argv[0])), "-l")) {
	lines = JS_TRUE;
	argv++, argc--;
    } else {
	lines = JS_FALSE;
    }
    for (i = 0; i < argc; i++) {
	fun = JS_ValueToFunction(cx, argv[i]);
	if (!fun)
	    return JS_FALSE;

	js_Disassemble(cx, fun->script, lines, stdout);
	SingleNote(cx, fun);
	ExceptionTable(cx, fun);
    }
    return JS_TRUE;
}

static JSBool
DisassWithSrc(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
#define LINE_BUF_LEN 512
    uintN i, len, line1, line2, bupline;
    JSFunction *fun;
    FILE *file;
    char linebuf[LINE_BUF_LEN];
    jsbytecode *pc, *end;
    static char sep[] = ";-------------------------";

    for (i = 0; i < argc; i++) {
	fun = JS_ValueToFunction(cx, argv[i]);
	if (!fun)
	    return JS_FALSE;

	if (!fun->script || !fun->script->filename) {
	    JS_ReportError(cx, "only works on JS scripts read from files");
	    return JS_FALSE;
	}

	file = fopen(fun->script->filename, "r");
	if (!file) {
	    JS_ReportError(cx, "can't open %s: %s", fun->script->filename, strerror(errno));
	    return JS_FALSE;
	}

	pc = fun->script->code;
	end = pc + fun->script->length;

	/* burn the leading lines */
	line2 = JS_PCToLineNumber(cx, fun->script, pc);
	for (line1 = 0; line1 < line2 - 1; line1++)
	    fgets(linebuf, LINE_BUF_LEN, file);

	bupline = 0;
	while (pc < end) {
	    line2 = JS_PCToLineNumber(cx, fun->script, pc);

	    if (line2 < line1) {
		if (bupline != line2) {
		    bupline = line2;
		    printf("%s %3u: BACKUP\n", sep, line2);
		}
	    } else {
		if (bupline && line1 == line2)
		    printf("%s %3u: RESTORE\n", sep, line2);
		bupline = 0;
		while (line1 < line2) {
		    if (!fgets(linebuf, LINE_BUF_LEN, file)) {
			JS_ReportError(cx, "unexpected EOF in %s",
				       fun->script->filename);
		    	goto bail;
		    }
		    line1++;
		    printf("%s %3u: %s", sep, line1, linebuf);
		}
	    }

	    len = js_Disassemble1(cx, fun->script, pc, pc - fun->script->code,
				  JS_TRUE, stdout);
	    if (!len)
		return JS_FALSE;
	    pc += len;
	}

      bail:
	fclose(file);
    }
    return JS_TRUE;
}

static JSBool
Tracing(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSBool bval;
    JSString *str;

    if (argc == 0) {
	*rval = BOOLEAN_TO_JSVAL(cx->tracefp != 0);
	return JS_TRUE;
    }

    switch (JS_TypeOfValue(cx, argv[0])) {
      case JSTYPE_NUMBER:
	bval = JSVAL_IS_INT(argv[0])
	       ? JSVAL_TO_INT(argv[0])
	       : (jsint) *JSVAL_TO_DOUBLE(argv[0]);
	break;
      case JSTYPE_BOOLEAN:
	bval = JSVAL_TO_BOOLEAN(argv[0]);
	break;
      default:
	str = JS_ValueToString(cx, argv[0]);
	if (!str)
	    return JS_FALSE;
	fprintf(stderr, "tracing: illegal argument %s\n",
		JS_GetStringBytes(str));
	return JS_TRUE;
    }
    cx->tracefp = bval ? stdout : NULL;
    return JS_TRUE;
}

int
DumpAtom(PRHashEntry *he, int i, void *arg)
{
    FILE *fp = arg;
    JSAtom *atom = (JSAtom *)he;

    fprintf(fp, "%3d %08x %5lu ",
	    i, (uintN)he->keyHash, (unsigned long)atom->number);
    if (ATOM_IS_STRING(atom))
	fprintf(fp, "\"%s\"\n", ATOM_BYTES(atom));
    else if (ATOM_IS_INT(atom))
	fprintf(fp, "%ld\n", (long)ATOM_TO_INT(atom));
    else
	fprintf(fp, "%.16g\n", *ATOM_TO_DOUBLE(atom));
    return HT_ENUMERATE_NEXT;
}

int
DumpSymbol(PRHashEntry *he, int i, void *arg)
{
    FILE *fp = arg;
    JSSymbol *sym = (JSSymbol *)he;

    fprintf(fp, "%3d %08x", i, (uintN)he->keyHash);
    if (JSVAL_IS_INT(sym_id(sym)))
	fprintf(fp, " [%ld]\n", (long)JSVAL_TO_INT(sym_id(sym)));
    else
	fprintf(fp, " \"%s\"\n", ATOM_BYTES(sym_atom(sym)));
    return HT_ENUMERATE_NEXT;
}

extern JS_FRIEND_DATA(JSScopeOps) js_list_scope_ops;

void
DumpScope(JSContext *cx, JSObject *obj, PRHashEnumerator dump, FILE *fp)
{
    JSScope *scope;
    JSSymbol *sym;
    int i;

    fprintf(fp, "\n%s scope contents:\n", OBJ_GET_CLASS(cx, obj)->name);
    scope = (JSScope *)obj->map;
    if (!MAP_IS_NATIVE(&scope->map))
    	return;
    if (scope->ops == &js_list_scope_ops) {
	for (sym = (JSSymbol *)scope->data, i = 0; sym;
	     sym = (JSSymbol *)sym->entry.next, i++) {
	    DumpSymbol(&sym->entry, i, fp);
	}
    } else {
	PR_HashTableDump(scope->data, dump, fp);
    }
}

/* These are callable from gdb. */
void Dsym(JSSymbol *sym) { if (sym) DumpSymbol(&sym->entry, 0, stderr); }
void Datom(JSAtom *atom) { if (atom) DumpAtom(&atom->entry, 0, stderr); }

static JSBool
DumpStats(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i;
    JSString *str;
    const char *bytes;
    JSAtom *atom;
    JSObject *obj2;
    JSProperty *prop;
    jsval value;

    for (i = 0; i < argc; i++) {
	str = JS_ValueToString(cx, argv[i]);
	if (!str)
	    return JS_FALSE;
	bytes = JS_GetStringBytes(str);
	if (strcmp(bytes, "arena") == 0) {
#ifdef ARENAMETER
	    PR_DumpArenaStats(stdout);
#endif
	} else if (strcmp(bytes, "atom") == 0) {
	    printf("\natom table contents:\n");
	    PR_HashTableDump(cx->runtime->atomState.table, DumpAtom, stdout);
	} else if (strcmp(bytes, "global") == 0) {
	    DumpScope(cx, cx->globalObject, DumpSymbol, stdout);
	} else {
	    atom = js_Atomize(cx, bytes, JS_GetStringLength(str), 0);
	    if (!atom)
		return JS_FALSE;
	    if (!js_FindProperty(cx, (jsid)atom, &obj, &obj2, &prop))
		return JS_FALSE;
	    if (prop) {
		OBJ_DROP_PROPERTY(cx, obj2, prop);
		if (!OBJ_GET_PROPERTY(cx, obj, (jsid)atom, &value))
		    return JS_FALSE;
	    }
	    if (!prop || !JSVAL_IS_OBJECT(value)) {
		fprintf(stderr, "js: invalid stats argument %s\n",
			bytes);
	    	continue;
	    }
	    obj = JSVAL_TO_OBJECT(value);
	    if (obj)
		DumpScope(cx, obj, DumpSymbol, stdout);
	}
    }
    return JS_TRUE;
}

#endif /* DEBUG */

#ifdef TEST_EXPORT
static JSBool
DoExport(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSAtom *atom;
    JSObject *obj2;
    JSProperty *prop;
    JSBool ok;
    uintN attrs;

    if (argc != 2) {
	JS_ReportError(cx, "usage: doexp obj id");
	return JS_FALSE;
    }
    if (!JS_ValueToObject(cx, argv[0], &obj))
	return JS_FALSE;
    argv[0] = OBJECT_TO_JSVAL(obj);
    atom = js_ValueToStringAtom(cx, argv[1]);
    if (!atom)
	return JS_FALSE;
    if (!OBJ_LOOKUP_PROPERTY(cx, obj, (jsid)atom, &obj2, &prop))
	return JS_FALSE;
    if (!prop) {
	ok = OBJ_DEFINE_PROPERTY(cx, obj, id, JSVAL_VOID, NULL, NULL,
				 JSPROP_EXPORTED, NULL);
    } else {
	ok = OBJ_GET_ATTRIBUTES(cx, obj, (jsid)atom, prop, &attrs);
	if (ok) {
	    attrs |= JSPROP_EXPORTED;
	    ok = OBJ_SET_ATTRIBUTES(cx, obj, (jsid)atom, prop, &attrs);
	}
	OBJ_DROP_PROPERTY(cx, obj2, prop);
    }
    return ok;
}
#endif

#ifdef TEST_CVTARGS
static JSBool
ConvertArgs(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSBool b;
    jschar c;
    int32 i, j;
    uint32 u;
    jsdouble d, I;
    char *s;
    JSString *str;
    JSObject *obj;
    JSFunction *fun;
    jsval v;

    if (!JS_ConvertArguments(cx, argc, argv, "b/ciujdIsSofv*",
			     &b, &c, &i, &u, &j, &d, &I, &s, &str, &obj, &fun,
			     &v)) {
	return JS_FALSE;
    }
    printf("b %u, c %x (%c), i %ld, u %lu, j %ld\n", b, c, (char)c, i, u, j);
    printf("d %g, I %g, s %s, S %s, obj %s, fun %s, v %s\n",
    	   d, I, s, JS_GetStringBytes(str),
    	   JS_GetStringBytes(JS_ValueToString(cx, OBJECT_TO_JSVAL(obj))),
    	   JS_GetStringBytes(JS_DecompileFunction(cx, fun, 4)),
    	   JS_GetStringBytes(JS_ValueToString(cx, v)));
    return JS_TRUE;
}
#endif

static JSFunctionSpec shell_functions[] = {
    {"JSevalTcl",       js_eval_tcl,    2},
    {"JS_TCL",          js_eval_tcl_html, 2},
    {"JS_TK",           js_eval_tk,     9},
    {"JS_COND",         js_cond,        4},
    {"JS_HTML",         js_html,        2},
    {"load",            Load,           1},
    {"print",           Print,          0},
    {"help",            Help,           0},
    {"gc",              GC,             0},
    {"trap",            Trap,           3},
    {"untrap",          Untrap,         2},
    {"line2pc",         LineToPC,       0},
    {"pc2line",         PCToLine,       0},
#ifdef DEBUG
    {"dis",             Disassemble,    1},
    {"dissrc",          DisassWithSrc,  1},
    {"notes",           Notes,          1},
    {"tracing",         Tracing,        0},
    {"stats",           DumpStats,      1},
#endif
#ifdef TEST_EXPORT
    {"doexp",           DoExport,       2},
#endif
#ifdef TEST_CVTARGS
    {"cvtargs",         ConvertArgs,    0, 0, 12},
#endif
    {0}
};

/* NOTE: These must be kept in sync with the above. */

static char *shell_help_messages[] = {
    "load ['foo.js' ...]    Load files named by string arguments",
    "print [expr ...]       Evaluate and print expressions",
    "help [name ...]        Display usage and help messages",
    "gc                     Run the garbage collector",
    "trap [fun] [pc] expr   Trap bytecode execution",
    "untrap [fun] [pc]      Remove a trap",
    "line2pc [fun] line     Map line number to PC",
    "pc2line [fun] [pc]     Map PC to line number",
#ifdef DEBUG
    "dis [fun]              Disassemble functions into bytecodes",
    "dissrc [fun]           Disassemble functions with source lines",
    "notes [fun]            Show source notes for functions",
    "tracing [toggle]       Turn tracing on or off",
    "stats [string ...]     Dump 'arena', 'atom', 'global' stats",
#endif
#ifdef TEST_EXPORT
    "doexp obj id           Export identified property from object",
#endif
#ifdef TEST_CVTARGS
    "cvtargs b c ...        Test JS_ConvertArguments",
#endif
    0
};

static void
ShowHelpHeader(void)
{
    printf("%-9s %-22s %s\n", "Command", "Usage", "Description");
    printf("%-9s %-22s %s\n", "=======", "=====", "===========");
}

static void
ShowHelpForCommand(uintN n)
{
    printf("%-9.9s %s\n", shell_functions[n].name, shell_help_messages[n]);
}

static JSBool
Help(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    uintN i, j;
    int did_header, did_something;
    JSType type;
    JSFunction *fun;
    JSString *str;
    const char *bytes;

    if (argc == 0) {
	ShowHelpHeader();
	for (i = 0; shell_functions[i].name; i++)
	    ShowHelpForCommand(i);
    } else {
	did_header = 0;
	for (i = 0; i < argc; i++) {
	    did_something = 0;
	    type = JS_TypeOfValue(cx, argv[i]);
	    if (type == JSTYPE_FUNCTION) {
		fun = JS_ValueToFunction(cx, argv[i]);
		str = fun->atom ? ATOM_TO_STRING(fun->atom) : NULL;
	    } else if (type == JSTYPE_STRING) {
		str = JSVAL_TO_STRING(argv[i]);
	    } else {
		str = NULL;
	    }
	    if (str) {
		bytes = JS_GetStringBytes(str);
		for (j = 0; shell_functions[j].name; j++) {
		    if (!strcmp(bytes, shell_functions[j].name)) {
			if (!did_header) {
			    did_header = 1;
			    ShowHelpHeader();
			}
			did_something = 1;
			ShowHelpForCommand(j);
			break;
		    }
		}
	    }
	    if (!did_something) {
		str = JS_ValueToString(cx, argv[i]);
		if (!str)
		    return JS_FALSE;
		fprintf(stderr, "Sorry, no help for %s\n",
			JS_GetStringBytes(str));
	    }
	}
    }
    return JS_TRUE;
}

/*
 * Define a JS object called "it".  Give it class operations that printf why
 * they're being called for tutorial purposes.
 */
enum its_tinyid {
    ITS_COLOR, ITS_HEIGHT, ITS_WIDTH, ITS_FUNNY, ITS_ARRAY, ITS_RDONLY
};

static JSPropertySpec its_props[] = {
    {"color",           ITS_COLOR,	JSPROP_ENUMERATE},
    {"height",          ITS_HEIGHT,	JSPROP_ENUMERATE},
    {"width",           ITS_WIDTH,	JSPROP_ENUMERATE},
    {"funny",           ITS_FUNNY,	JSPROP_ENUMERATE},
    {"array",           ITS_ARRAY,	JSPROP_ENUMERATE},
    {"rdonly",		ITS_RDONLY,	JSPROP_READONLY},
    {0}
};

static JSBool its_noisy;    /* whether to be noisy when finalizing it */

static JSBool
its_addProperty(JSContext *cx, JSObject *obj, jsval id, jsval *vp)
{
    if (its_noisy) {
	printf("adding its property %s,",
	       JS_GetStringBytes(JS_ValueToString(cx, id)));
	printf(" initial value %s\n",
	       JS_GetStringBytes(JS_ValueToString(cx, *vp)));
    }
    return JS_TRUE;
}

static JSBool
its_delProperty(JSContext *cx, JSObject *obj, jsval id, jsval *vp)
{
    if (its_noisy) {
	printf("deleting its property %s,",
	       JS_GetStringBytes(JS_ValueToString(cx, id)));
	printf(" current value %s\n",
	       JS_GetStringBytes(JS_ValueToString(cx, *vp)));
    }
    return JS_TRUE;
}

static JSBool
its_getProperty(JSContext *cx, JSObject *obj, jsval id, jsval *vp)
{
    if (its_noisy) {
	printf("getting its property %s,",
	       JS_GetStringBytes(JS_ValueToString(cx, id)));
	printf(" current value %s\n",
	       JS_GetStringBytes(JS_ValueToString(cx, *vp)));
    }
    return JS_TRUE;
}

static JSBool
its_setProperty(JSContext *cx, JSObject *obj, jsval id, jsval *vp)
{
    if (its_noisy) {
	printf("setting its property %s,",
	       JS_GetStringBytes(JS_ValueToString(cx, id)));
	printf(" new value %s\n",
	       JS_GetStringBytes(JS_ValueToString(cx, *vp)));
    }
    if (JSVAL_IS_STRING(id) &&
	!strcmp(JS_GetStringBytes(JSVAL_TO_STRING(id)), "noisy")) {
	return JS_ValueToBoolean(cx, *vp, &its_noisy);
    }
    return JS_TRUE;
}

static JSBool
its_enumerate(JSContext *cx, JSObject *obj)
{
    if (its_noisy)
	printf("enumerate its properties\n");
    return JS_TRUE;
}

static JSBool
its_resolve(JSContext *cx, JSObject *obj, jsval id)
{
    if (its_noisy) {
	printf("resolving its property %s\n",
	       JS_GetStringBytes(JS_ValueToString(cx, id)));
    }
    return JS_TRUE;
}

static JSBool
its_convert(JSContext *cx, JSObject *obj, JSType type, jsval *vp)
{
    if (its_noisy)
	printf("converting it to %s type\n", JS_GetTypeName(cx, type));
    return JS_TRUE;
}

static void
its_finalize(JSContext *cx, JSObject *obj)
{
    if (its_noisy)
	printf("finalizing it\n");
}

static JSClass its_class = {
    "It", 0,
    its_addProperty,  its_delProperty,  its_getProperty,  its_setProperty,
    its_enumerate,    its_resolve,      its_convert,      its_finalize
};

static void
my_ErrorReporter(JSContext *cx, const char *message, JSErrorReport *report)
{
    int i, j, k, n;

    fputs("js: ", stderr);
    if (!report) {
	fprintf(stderr, "%s\n", message);
	return;
    }

    if (report->filename)
	fprintf(stderr, "%s, ", report->filename);
    if (report->lineno)
	fprintf(stderr, "line %u: ", report->lineno);
    fputs(message, stderr);
    if (!report->linebuf) {
	putc('\n', stderr);
	return;
    }

    fprintf(stderr, ":\n%s\n", report->linebuf);
    n = report->tokenptr - report->linebuf;
    for (i = j = 0; i < n; i++) {
	if (report->linebuf[i] == '\t') {
	    for (k = (j + 8) & ~7; j < k; j++)
		putc('.', stderr);
	    continue;
	}
	putc('.', stderr);
	j++;
    }
    fputs("^\n", stderr);
}

#if defined DEBUG && defined XP_UNIX
static JSBool
Exec(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSFunction *fun;
    const char *name, **nargv;
    uintN i, nargc;
    JSString *str;
    pid_t pid;
    int status;

    fun = JS_ValueToFunction(cx, argv[-2]);
    if (!fun)
	return JS_FALSE;
    if (!fun->atom)
	return JS_TRUE;
    name = ATOM_BYTES(fun->atom);
    nargc = 1 + argc;
    nargv = JS_malloc(cx, (nargc + 1) * sizeof(char *));
    if (!nargv)
	return JS_FALSE;
    nargv[0] = name;
    for (i = 1; i < nargc; i++) {
	str = JS_ValueToString(cx, argv[i-1]);
	if (!str) {
	    JS_free(cx, nargv);
	    return JS_FALSE;
	}
	nargv[i] = JS_GetStringBytes(str);
    }
    nargv[nargc] = 0;
    pid = fork();
    switch (pid) {
      case -1:
	perror("js");
	break;
      case 0:
	(void) execvp(name, (char **)nargv);
	perror("js");
	exit(127);
      default:
	while (waitpid(pid, &status, 0) < 0 && errno == EINTR)
	    ;
	break;
    }
    JS_free(cx, nargv);
    return JS_TRUE;
}
#endif

static JSBool
global_resolve(JSContext *cx, JSObject *obj, jsval id)
{
#if defined DEBUG && defined XP_UNIX
    /*
     * Do this expensive hack only for unoptimized Unix builds, which are not
     * used for benchmarking.
     */
    char *path, *comp, *full;
    const char *name;
    JSBool ok, found;
    JSFunction *fun;

    if (!JSVAL_IS_STRING(id))
	return JS_TRUE;
    path = getenv("PATH");
    if (!path)
	return JS_TRUE;
    path = JS_strdup(cx, path);
    if (!path)
	return JS_FALSE;
    name = JS_GetStringBytes(JSVAL_TO_STRING(id));
    ok = JS_TRUE;
    for (comp = strtok(path, ":"); comp; comp = strtok(NULL, ":")) {
	if (*comp != '\0') {
	    full = PR_smprintf("%s/%s", comp, name);
	    if (!full) {
		JS_ReportOutOfMemory(cx);
		ok = JS_FALSE;
		break;
	    }
	} else {
	    full = (char *)name;
	}
	found = (access(full, X_OK) == 0);
	if (*comp != '\0')
	    JSFREE(full);
	if (found) {
	    fun = JS_DefineFunction(cx, obj, name, Exec, 0, JSPROP_ENUMERATE);
	    ok = (fun != NULL);
	    break;
	}
    }
    JS_free(cx, path);
    return ok;
#else
    return JS_TRUE;
#endif
}

static JSClass global_class = {
    "global", 0,
    JS_PropertyStub,  JS_PropertyStub,  JS_PropertyStub,  JS_PropertyStub,
    JS_EnumerateStub, global_resolve,   JS_ConvertStub,   JS_FinalizeStub
};

/* -----------------------------------------------------------------
 * The main entry point to the JavaScript interpreter.  We optionally
 * glue a Tcl Interpreter to this Javascript interpreter thru the
 * JSevalTcl command.
----------------------------------------------------------------- */
TWJS_PTR TWJS_Init(void *tcl_interp)
{
    JSVersion version;
    JSRuntime *rt;
    JSContext *cx;
    JSObject *glob, *it;
    TWJS_PTR js_ptr ;

    version = JSVERSION_DEFAULT;
    rt = JS_NewRuntime(8L * 1024L * 1024L) ;
    if (!rt)
	return NULL;
    cx = JS_NewContext(rt, 8192);
    if (!cx)
	return NULL;
    JS_SetErrorReporter(cx, my_ErrorReporter);

    glob = JS_NewObject(cx, &global_class, NULL, NULL);
    if (!glob)
	return NULL;
    if (!JS_InitStandardClasses(cx, glob))
	return NULL;
    if (!JS_DefineFunctions(cx, glob, shell_functions))
	return NULL;

    /* Set version only after there is a global object. */
    if (version != JSVERSION_DEFAULT)
	JS_SetVersion(cx, version);

    it = JS_DefineObject(cx, glob, "it", &its_class, NULL, 0);
    if (!it)
	return NULL;
    if (!JS_DefineProperties(cx, it, its_props))
	return NULL;
    /* -----------------------------------------------------------------
     * Now it is safe to allocate memory for Javascript Interpreter.
    ----------------------------------------------------------------- */
    js_ptr = JS_malloc(cx, sizeof(TWJS_BOX) ) ;
    js_ptr->runtime = rt ;
    js_ptr->context = cx ;
    js_ptr->object = glob ;
    /* -----------------------------------------------------------------
     * Notice that we have to use a static variable for the interpreter
     * since we can't pass it on to the js_eval_tcl function like we
     * can in Tcl.  Unfortunately, Javascript wasn't thought out as much
     * as Tcl.
    ----------------------------------------------------------------- */
    if( tcl_interp ){
      tcl_interpS = (Tcl_Interp *) tcl_interp ;
    }
    Tcl_DStringInit(&jstcl_cmdS) ;
    return( js_ptr ) ;
} /* end JS_Init() */

/* -----------------------------------------------------------------
 * Convenience function to process a script.  
----------------------------------------------------------------- */
char *TWJS_process_script(TWJS_PTR js_ptr, char *script)
{
    JSContext *cx ;			/* Javascript context */
    JSObject *obj ;			/* Javascript object */
    JSScript *compiled_script;		/* Byte code compiled script */
    jsval result;			/* Result from Javascript */
    JSString *str;			/* Result string */
    char *answer ;			/* answer string */

    answer = NULL ;
    cx = js_ptr->context ;
    obj = js_ptr->object ;
    compiled_script = JS_CompileScript(cx,obj,script,strlen(script),NULL,0) ;
    if (compiled_script) {
      JS_ExecuteScript(cx, obj, compiled_script, &result) ;
      if( result != JSVAL_VOID) {
	str = JS_ValueToString(cx, result);
	if (str){
	  answer = JS_GetStringBytes(str) ;
	}
      }
      JS_DestroyScript(cx, compiled_script);
    }
    return(answer) ;
} /* end TWJS_process_script() */

/* -----------------------------------------------------------------
 * Convenience function to process a file.  
----------------------------------------------------------------- */
char *TWJS_process_scriptFile(TWJS_PTR js_ptr, char *filename)
{
    JSContext *cx ;			/* Javascript context */
    JSObject *obj ;			/* Javascript object */
    JSScript *compiled_script;		/* Byte code compiled script */
    jsval result;			/* Result from Javascript */
    JSString *str;			/* Result string */
    char *answer ;			/* answer string */

    answer = NULL ;
    cx = js_ptr->context ;
    obj = js_ptr->object ;
    compiled_script = JS_CompileFile(cx, obj, filename);
    if (compiled_script) {
      if (JS_ExecuteScript(cx, obj, compiled_script, &result) ){
	if( result != JSVAL_VOID) {
	  str = JS_ValueToString(cx, result);
	  if (str){
	    answer = JS_GetStringBytes(str) ;
	  }
	  JS_DestroyScript(cx, compiled_script);
	}
      }
    }
    return(answer) ;
} /* end TWJS_process_scriptFile() */

void TWJS_destroy(TWJS_PTR js_ptr)
{
    JS_DestroyContext(js_ptr->context) ;
    JS_DestroyRuntime(js_ptr->runtime) ;
    JS_ShutDown();
} /* end JS_destroy() */

static char *exec_js( JSContext *cx, JSObject *obj, char *variable )
{
    JSScript *compiled_script;		/* Byte code compiled script */
    jsval result;			/* Result from Javascript */
    JSString *str;			/* Result string */
    char *answer ;			/* answer string */

    answer = NULL ;
    compiled_script = JS_CompileScript(cx,obj,variable,strlen(variable),NULL,0) ;
    if (compiled_script) {
      if (JS_ExecuteScript(cx, obj, compiled_script, &result) ){
	if( result != JSVAL_VOID) {
	  str = JS_ValueToString(cx, result);
	  if (str){
	    answer = JS_GetStringBytes(str) ;
	  }
	  JS_DestroyScript(cx, compiled_script);
	}
      }
    }
    return(answer) ;
} /* end exec_js() */

static char *lookup_var( JSContext *cx, JSObject *obj, char *variable )
{
    char *answer ;			/* answer string */

    answer = exec_js( cx, obj, variable ) ;
    if( !(answer) || !(*answer) ){
      char upper_buffer[BUFSIZ] ;
      utDstrucpy(upper_buffer, variable) ;
      answer = exec_js( cx, obj, upper_buffer ) ;
    }
    return(answer) ;
} /* end lookup_var() */

static void reset_all_variables(JSContext *cx, JSObject *obj)
{
    char reset_vars[BUFSIZ] ;		/* reset the variables */

    reset_vars[0] = EOS ;
    strcat( reset_vars, "procedure=\"\";PROCEDURE=\"\";" ) ;
    strcat( reset_vars, "args=\"\";ARGS=\"\";" ) ;
    strcat( reset_vars, "width=\"\";WIDTH=\"\";" ) ;
    strcat( reset_vars, "height=\"\";HEIGHT=\"\";" ) ;
    strcat( reset_vars, "align=\"\";ALIGN=\"\";" ) ;
    strcat( reset_vars, "padx=\"\";PADX=\"\";" ) ;
    strcat( reset_vars, "pady=\"\";PADY=\"\";" ) ;
    strcat( reset_vars, "alt=\"\";ALT=\"\";" ) ;
    strcat( reset_vars, "altw=\"\";ALTW=\"\";" ) ;
    strcat( reset_vars, "alth=\"\";ALTH=\"\";" ) ;
    strcat( reset_vars, "expr=\"\";EXPR=\"\";" ) ;
    strcat( reset_vars, "html=\"\";HTML=\"\";" ) ;
    strcat( reset_vars, "logic=\"\";LOGIC=\"\";" ) ;

    /* -----------------------------------------------------------------
     * Now set all the variables back to null.  We do this before evaluating
     * the Tcl so that the return codes will be correct.
    ----------------------------------------------------------------- */
    exec_js( cx, obj, reset_vars ) ;

} /* end reset_all_variables() */
