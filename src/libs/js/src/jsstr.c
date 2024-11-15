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
 * JS string type implementation.
 *
 * In order to avoid unnecessary js_LockGCThing/js_UnlockGCThing calls, these
 * native methods store strings (possibly newborn) converted from their 'this'
 * parameter and arguments on the stack: 'this' conversions at argv[-1], arg
 * conversions at their index (argv[0], argv[1]).  This is a legitimate method
 * of rooting things that might lose their newborn root due to subsequent GC
 * allocations in the same native method.
 */
#include <stdlib.h>
#include <string.h>
#include "prtypes.h"
#include "prassert.h"
#include "prhash.h"
#include "prprintf.h"
#include "jsapi.h"
#include "jsarray.h"
#include "jsatom.h"
#include "jsbool.h"
#include "jscntxt.h"
#include "jsconfig.h"
#include "jsgc.h"
#include "jslock.h"
#include "jsnum.h"
#include "jsobj.h"
#include "jsopcode.h"
#include "jsregexp.h"
#include "jsstr.h"
#include "jsmalloc.h"

#if JS_HAS_REPLACE_LAMBDA
#include "jsinterp.h"
#endif

jschar      js_empty_ucstr[]  = {0};
JSSubString js_EmptySubString = {0, js_empty_ucstr};

enum string_tinyid {
    STRING_LENGTH = -1
};

static JSPropertySpec string_props[] = {
    {js_length_str,     STRING_LENGTH,  JSPROP_READONLY},
    {0}
};

static JSBool
str_delProperty(JSContext *cx, JSObject *obj, jsval id, jsval *vp)
{
    /* Make delete s.length fail even though length is in s.__proto__. */
    if (id == ATOM_KEY(cx->runtime->atomState.lengthAtom))
	*vp = JSVAL_FALSE;
    return JS_TRUE;
}

static JSBool
str_getProperty(JSContext *cx, JSObject *obj, jsval id, jsval *vp)
{
    JSString *str;

    if (!JSVAL_IS_INT(id))
	return JS_TRUE;
    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    if (JSVAL_TO_INT(id) == STRING_LENGTH)
	*vp = INT_TO_JSVAL((jsint)str->length);
    return JS_TRUE;
}

static JSBool
str_resolve1(JSContext *cx, JSObject *obj, JSString *str, jsint slot)
{
    jschar buf[2];
    JSString *str1;

    buf[0] = str->chars[slot];
    buf[1] = 0;
    str1 = js_NewStringCopyN(cx, buf, 1, 0);
    if (!str1)
	return JS_FALSE;
    return JS_DefineElement(cx, obj, slot, STRING_TO_JSVAL(str1),
			    JS_PropertyStub, JS_PropertyStub,
			    JSPROP_ENUMERATE|JSPROP_READONLY|JSPROP_PERMANENT);
}

static JSBool
str_enumerate(JSContext *cx, JSObject *obj)
{
    JSString *str;
    JSBool ok;
    jsint i;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    ok = JS_TRUE;
    js_LockGCThing(cx, str);
    for (i = 0; i < (jsint)str->length; i++) {
	ok = str_resolve1(cx, obj, str, i);
	if (!ok)
	    break;
    }
    js_UnlockGCThing(cx, str);
    return ok;
}

static JSBool
str_resolve(JSContext *cx, JSObject *obj, jsval id)
{
    JSString *str;
    jsint slot;

    if (!JSVAL_IS_INT(id))
	return JS_TRUE;
    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    slot = JSVAL_TO_INT(id);
    if ((size_t)slot >= str->length)
	return JS_TRUE;
    return str_resolve1(cx, obj, str, slot);
}

static JSClass string_class = {
    "String",
    JSCLASS_HAS_PRIVATE,
    JS_PropertyStub,  str_delProperty,  str_getProperty,  JS_PropertyStub,
    str_enumerate,    str_resolve,      JS_ConvertStub,   JS_FinalizeStub
};

#if JS_HAS_TOSOURCE

/*
 * String.prototype.quote is generic (as are most string methods), unlike
 * toSource, toString, and valueOf.
 */
static JSBool
str_quote(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSString *str;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    str = js_QuoteString(cx, str, '"');
    if (!str)
    	return JS_FALSE;
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
}

static JSBool
str_toSource(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    jsval v;
    JSString *str;
    size_t i, j, k, n;
    char buf[16];
    jschar *s, *t;

    if (!JS_InstanceOf(cx, obj, &string_class, argv))
	return JS_FALSE;
    v = OBJ_GET_SLOT(cx, obj, JSSLOT_PRIVATE);
    if (!JSVAL_IS_STRING(v))
	return js_obj_toSource(cx, obj, argc, argv, rval);
    str = js_QuoteString(cx, JSVAL_TO_STRING(v), '"');
    if (!str)
    	return JS_FALSE;
    j = PR_snprintf(buf, sizeof buf, "(new %s(", string_class.name);
    s = str->chars;
    k = str->length;
    n = j + k + 2;
    t = JS_malloc(cx, (n + 1) * sizeof(jschar));
    if (!t)
    	return JS_FALSE;
    for (i = 0; i < j; i++)
    	t[i] = buf[i];
    for (j = 0; j < k; i++, j++)
    	t[i] = s[j];
    t[i++] = ')';
    t[i++] = ')';
    t[i] = 0;
    str = js_NewString(cx, t, n, 0);
    if (!str) {
    	JS_free(cx, t);
    	return JS_FALSE;
    }
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
}

#endif /* JS_HAS_TOSOURCE */

static JSBool
str_toString(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    jsval v;

    if (!JS_InstanceOf(cx, obj, &string_class, argv))
	return JS_FALSE;
    v = OBJ_GET_SLOT(cx, obj, JSSLOT_PRIVATE);
    if (!JSVAL_IS_STRING(v))
	return js_obj_toString(cx, obj, argc, argv, rval);
    *rval = v;
    return JS_TRUE;
}

static JSBool
str_valueOf(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    if (!JS_InstanceOf(cx, obj, &string_class, argv))
	return JS_FALSE;
    *rval = OBJ_GET_SLOT(cx, obj, JSSLOT_PRIVATE);
    return JS_TRUE;
}

/*
 * Java-like string native methods.
 */
static JSBool
str_substring(JSContext *cx, JSObject *obj, uintN argc, jsval *argv,
	      jsval *rval)
{
    JSString *str;
    jsdouble d;
    jsdouble length, begin, end;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);

    if (argc != 0) {
	if (!js_ValueToNumber(cx, argv[0], &d))
	    return JS_FALSE;
	length = str->length;
	begin = js_DoubleToInteger(d);
	if (begin < 0)
	    begin = 0;
	else if (begin > length)
	    begin = length;

	if (argc == 1) {
	    end = length;
	} else {
	    if (!js_ValueToNumber(cx, argv[1], &d))
		return JS_FALSE;
	    end = js_DoubleToInteger(d);
	    if (end < 0)
		end = 0;
	    else if (end > length)
		end = length;
	    if (end < begin) {
		if (cx->version != JSVERSION_1_2) {
		    /* XXX emulate old JDK1.0 java.lang.String.substring. */
		    jsdouble tmp = begin;
		    begin = end;
		    end = tmp;
		} else {
		    end = begin;
		}
	    }
	}

	str = js_NewStringCopyN(cx, str->chars + (size_t)begin,
                                (size_t)(end - begin), 0);
	if (!str)
	    return JS_FALSE;
    }
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
}

static JSBool
str_toLowerCase(JSContext *cx, JSObject *obj, uintN argc, jsval *argv,
		jsval *rval)
{
    JSString *str;
    size_t i, n;
    jschar *s, *news;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    n = str->length;
    news = JS_malloc(cx, (n + 1) * sizeof(jschar));
    if (!news)
	return JS_FALSE;
    s = str->chars;
    for (i = 0; i < n; i++)
	news[i] = JS_TOLOWER(s[i]);
    news[n] = 0;
    str = js_NewString(cx, news, n, 0);
    if (!str) {
	JS_free(cx, news);
	return JS_FALSE;
    }
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
}

static JSBool
str_toUpperCase(JSContext *cx, JSObject *obj, uintN argc, jsval *argv,
		jsval *rval)
{
    JSString *str;
    size_t i, n;
    jschar *s, *news;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    n = str->length;
    news = JS_malloc(cx, (n + 1) * sizeof(jschar));
    if (!news)
	return JS_FALSE;
    s = str->chars;
    for (i = 0; i < n; i++)
	news[i] = JS_TOUPPER(s[i]);
    news[n] = 0;
    str = js_NewString(cx, news, n, 0);
    if (!str) {
	JS_free(cx, news);
	return JS_FALSE;
    }
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
}

static JSBool
str_charAt(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSString *str;
    jsdouble d;
    size_t index;
    jschar buf[2];

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);

    if (!js_ValueToNumber(cx, argv[0], &d))
	return JS_FALSE;
    d = js_DoubleToInteger(d);
    if (d < 0 || str->length <= d) {
	*rval = JS_GetEmptyStringValue(cx);
    } else {
        index = (size_t)d;
	buf[0] = str->chars[index];
	buf[1] = 0;
	str = js_NewStringCopyN(cx, buf, 1, 0);
	if (!str)
	    return JS_FALSE;
	*rval = STRING_TO_JSVAL(str);
    }
    return JS_TRUE;
}

static JSBool
str_charCodeAt(JSContext *cx, JSObject *obj, uintN argc, jsval *argv,
	       jsval *rval)
{
    JSString *str;
    jsdouble d;
    size_t index;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);

    if (!js_ValueToNumber(cx, argv[0], &d))
	return JS_FALSE;
    d = js_DoubleToInteger(d);
    if (d < 0 || str->length <= d) {
        *rval = JS_GetNaNValue(cx);
    } else {
        index = (size_t)d;
        *rval = INT_TO_JSVAL((jsint)str->chars[index]);
    }
    return JS_TRUE;
}

jsint
js_BoyerMooreHorspool(const jschar *text, jsint textlen,
		      const jschar *pat, jsint patlen,
		      jsint start)
{
    jsint i, j, k, m;
    uint8 skip[BMH_CHARSET_SIZE];
    jschar c;

    PR_ASSERT(0 < patlen && patlen <= BMH_PATLEN_MAX);
    for (i = 0; i < BMH_CHARSET_SIZE; i++)
	skip[i] = (uint8)patlen;
    m = patlen - 1;
    for (i = 0; i < m; i++) {
	c = pat[i];
	if (c >= BMH_CHARSET_SIZE)
	    return BMH_BAD_PATTERN;
	skip[c] = (uint8)(m - i);
    }
    for (k = start + m;
	 k < textlen;
	 k += ((c = text[k]) >= BMH_CHARSET_SIZE) ? patlen : skip[c]) {
	for (i = k, j = m; ; i--, j--) {
	    if (j < 0)
		return i + 1;
	    if (text[i] != pat[j])
		break;
	}
    }
    return -1;
}

static JSBool
str_indexOf(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSString *str, *str2;
    jsint i, j, index, textlen, patlen;
    const jschar *text, *pat;
    jsdouble d;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);
    text = str->chars;
    textlen = (jsint)str->length;

    str2 = js_ValueToString(cx, argv[0]);
    if (!str2)
	return JS_FALSE;
    argv[0] = STRING_TO_JSVAL(str2);
    pat = str2->chars;
    patlen = (jsint)str2->length;

    if (argc > 1) {
	if (!js_ValueToNumber(cx, argv[1], &d))
	    return JS_FALSE;
        d = js_DoubleToInteger(d);
	if (d < 0)
	    i = 0;
	else if (d > textlen)
	    i = textlen;
        else
            i = (jsint)d;
    } else {
	i = 0;
    }
    if (patlen == 0) {
	*rval = INT_TO_JSVAL(i);
	return JS_TRUE;
    }

    /* XXX tune the BMH threshold (512) */
    if ((jsuint)(patlen - 2) <= BMH_PATLEN_MAX - 2 && textlen >= 512) {
	index = js_BoyerMooreHorspool(text, textlen, pat, patlen, i);
	if (index != BMH_BAD_PATTERN)
	    goto out;
    }

    index = -1;
    j = 0;
    while (i + j < textlen) {
	if (text[i + j] == pat[j]) {
	    if (++j == patlen) {
		index = i;
		break;
	    }
	} else {
	    i++;
	    j = 0;
	}
    }

out:
    *rval = INT_TO_JSVAL(index);
    return JS_TRUE;
}

static JSBool
str_lastIndexOf(JSContext *cx, JSObject *obj, uintN argc, jsval *argv,
		  jsval *rval)
{
    JSString *str, *str2;
    const jschar *text, *pat;
    jsint i, j, textlen, patlen;
    jsdouble d;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);
    text = str->chars;
    textlen = (jsint)str->length;

    str2 = js_ValueToString(cx, argv[0]);
    if (!str2)
	return JS_FALSE;
    argv[0] = STRING_TO_JSVAL(str2);
    pat = str2->chars;
    patlen = (jsint)str2->length;

    if (argc > 1) {
	if (!js_ValueToNumber(cx, argv[1], &d))
	    return JS_FALSE;
        if (JSDOUBLE_IS_NaN(d)) {
            i = textlen;
        } else {
            d = js_DoubleToInteger(d);
            if (d < 0)
                i = 0;
            else if (d > textlen - patlen)
                i = textlen - patlen;
            else
                i = (jsint)d;
        }
    } else {
        i = textlen;
    }

    if (patlen == 0) {
	*rval = INT_TO_JSVAL(i);
	return JS_TRUE;
    }

    j = 0;
    while (i >= 0) {
	if (text[i + j] == pat[j]) {
	    if (++j == patlen)
		break;
	} else {
	    i--;
	    j = 0;
	}
    }
    *rval = INT_TO_JSVAL(i);
    return JS_TRUE;
}

/*
 * Perl-inspired string functions.
 */
#if !JS_HAS_MORE_PERL_FUN || !JS_HAS_REGEXPS
static JSBool
str_nyi(JSContext *cx, const char *what)
{
    JS_ReportError(cx, "sorry, String.prototype.%s is not yet implemented",
		   what);
    return JS_FALSE;
}
#endif

#if JS_HAS_REGEXPS
typedef enum GlobMode {
    GLOB_MATCH,
    GLOB_REPLACE,
    GLOB_SEARCH
} GlobMode;

typedef struct GlobData {
    uintN    optarg;    /* input: index of optional flags argument */
    GlobMode mode;      /* input: return index, match object, or void */
    JSBool   global;    /* output: whether regexp was global */
    JSString *str;      /* output: 'this' parameter object as string */
    JSRegExp *regexp;   /* output: regexp parameter object private data */
} GlobData;

static JSBool
match_or_replace(JSContext *cx, JSObject *obj, uintN argc, jsval *argv,
		 JSBool (*glob)(JSContext *cx, jsint count, GlobData *data),
		 GlobData *data, jsval *rval)
{
    JSString *str, *src, *opt;
    JSObject *reobj;
    JSRegExp *re;
    size_t index;
    JSBool ok;
    jsint count;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);
    data->str = str;

    if (JSVAL_IS_REGEXP(cx, argv[0])) {
	reobj = JSVAL_TO_OBJECT(argv[0]);
	re = JS_GetPrivate(cx, reobj);
    } else {
    	src = js_ValueToString(cx, argv[0]);
	if (!src)
	    return JS_FALSE;
	if (data->optarg < argc) {
	    argv[0] = STRING_TO_JSVAL(src);
	    opt = js_ValueToString(cx, argv[data->optarg]);
	    if (!opt)
		return JS_FALSE;
	} else {
	    opt = NULL;
	}
	re = js_NewRegExpOpt(cx, src, opt);
	if (!re)
	    return JS_FALSE;
	reobj = NULL;
    }
    data->regexp = re;

    if (reobj)
	JS_LOCK_OBJ(cx, reobj);

    data->global = (re->flags & JSREG_GLOB) != 0;
    index = 0;
    if (data->mode == GLOB_SEARCH) {
	ok = js_ExecuteRegExp(cx, re, str, &index, JS_TRUE, rval);
	if (ok) {
	    *rval = (*rval == JSVAL_TRUE)
		    ? INT_TO_JSVAL(cx->regExpStatics.leftContext.length)
		    : INT_TO_JSVAL(-1);
	}
    } else if (data->global) {
	ok = JS_TRUE;
	re->lastIndex = 0;
	for (count = 0; index <= str->length; count++) {
	    ok = js_ExecuteRegExp(cx, re, str, &index, JS_TRUE, rval);
	    if (!ok || *rval != JSVAL_TRUE)
		break;
	    ok = glob(cx, count, data);
	    if (!ok)
		break;
	    if (cx->regExpStatics.lastMatch.length == 0) {
	        if (index == str->length)
		    break;
		index++;
	    }
	}
    } else {
	ok = js_ExecuteRegExp(cx, re, str, &index, data->mode == GLOB_REPLACE,
			      rval);
    }

    if (reobj) {
	JS_UNLOCK_OBJ(cx, reobj);
    } else {
	js_DestroyRegExp(cx, re);
    }
    return ok;
}

typedef struct MatchData {
    GlobData base;
    JSObject *arrayobj;
} MatchData;

static JSBool
match_glob(JSContext *cx, jsint count, GlobData *data)
{
    MatchData *mdata;
    JSObject *arrayobj;
    JSSubString *matchsub;
    JSString *matchstr;
    jsval v;

    mdata = (MatchData *)data;
    arrayobj = mdata->arrayobj;
    if (!arrayobj) {
        arrayobj = js_ConstructObject(cx, &js_ArrayClass, NULL, NULL);
	if (!arrayobj)
	    return JS_FALSE;
	mdata->arrayobj = arrayobj;
    }
    matchsub = &cx->regExpStatics.lastMatch;
    matchstr = js_NewStringCopyN(cx, matchsub->chars, matchsub->length, 0);
    if (!matchstr)
	return JS_FALSE;
    v = STRING_TO_JSVAL(matchstr);
    return js_SetProperty(cx, arrayobj, INT_TO_JSVAL(count), &v);
}
#endif /* JS_HAS_REGEXPS */

static JSBool
str_match(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
#if JS_HAS_REGEXPS
    MatchData mdata;
    JSBool ok;

    mdata.base.optarg = 1;
    mdata.base.mode = GLOB_MATCH;
    mdata.arrayobj = NULL;
    if (!js_AddRoot(cx, &mdata.arrayobj, "mdata.arrayobj"))
	return JS_FALSE;
    ok = match_or_replace(cx, obj, argc, argv, match_glob, &mdata.base, rval);
    if (ok && mdata.arrayobj)
	*rval = OBJECT_TO_JSVAL(mdata.arrayobj);
    js_RemoveRoot(cx, &mdata.arrayobj);
    return ok;
#else
    return str_nyi(cx, "match");
#endif
}

static JSBool
str_search(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
#if JS_HAS_REGEXPS
    MatchData mdata;

    mdata.base.optarg = 1;
    mdata.base.mode = GLOB_SEARCH;
    return match_or_replace(cx, obj, argc, argv, match_glob, &mdata.base, rval);
#else
    return str_nyi(cx, "search");
#endif
}

#if JS_HAS_REGEXPS
typedef struct ReplaceData {
    GlobData    base;           /* base struct state */
    JSObject    *lambda;        /* replacement function object or null */
    JSString    *repstr;        /* replacement string */
    jschar      *dollar;        /* null or pointer to first $ in repstr */
    jschar      *chars;         /* result chars, null initially */
    size_t      length;         /* result length, 0 initially */
    jsint       index;          /* index in result of next replacement */
    jsint       leftIndex;      /* left context index in base.str->chars */
} ReplaceData;

static JSSubString *
interpret_dollar(JSContext *cx, jschar *dp, ReplaceData *rdata, size_t *skip)
{
    JSRegExpStatics *res;
    jschar dc, *cp;
    uintN num, tmp;
    JSString *str;

    /* Allow a real backslash (literal "\\") to escape "$1" etc. */
    PR_ASSERT(*dp == '$');
    if (dp > rdata->repstr->chars && dp[-1] == '\\')
	return NULL;

    /* Interpret all Perl match-induced dollar variables. */
    res = &cx->regExpStatics;
    dc = dp[1];
    if (JS7_ISDEC(dc)) {
	if (dc == '0')
	    return NULL;

	/* Check for overflow to avoid gobbling arbitrary decimal digits. */
	num = 0;
	cp = dp;
	while ((dc = *++cp) != 0 && JS7_ISDEC(dc)) {
	    tmp = 10 * num + JS7_UNDEC(dc);
	    if (tmp < num)
		break;
	    num = tmp;
	}

	/* Adjust num from 1 $n-origin to 0 array-index-origin. */
	num--;
	*skip = cp - dp;
	return REGEXP_PAREN_SUBSTRING(res, num);
    }

    *skip = 2;
    switch (dc) {
      case '&':
	return &res->lastMatch;
      case '+':
	return &res->lastParen;
      case '`':
	if (cx->version == JSVERSION_1_2) {
	    /*
	     * JS1.2 imitated the Perl4 bug where left context at each step
	     * in an iterative use of a global regexp started from last match,
	     * not from the start of the target string.  But Perl4 does start
	     * $` at the beginning of the target string when it is used in a
	     * substitution, so we emulate that special case here.
	     */
	    str = rdata->base.str;
	    res->leftContext.chars = str->chars;
	    res->leftContext.length = res->lastMatch.chars - str->chars;
	}
	return &res->leftContext;
      case '\'':
	return &res->rightContext;
    }
    return NULL;
}

static JSBool
find_replen(JSContext *cx, ReplaceData *rdata, size_t *sizep)
{
    JSString *repstr;
    size_t replen, skip;
    jschar *dp;
    JSSubString *sub;
#if JS_HAS_REPLACE_LAMBDA
    JSObject *lambda;

    lambda = rdata->lambda;
    if (lambda) {
    	uintN argc, i, j, m, n, p;
    	jsval *sp, *oldsp, rval;
    	void *mark;
	JSStackFrame *fp;
    	JSBool ok;

	/*
	 * In the lambda case, not only do we find the replacement string's
	 * length, we compute repstr and return it via rdata for use within
	 * do_replace.  The lambda is called with arguments ($&, $1, $2, ...,
	 * index, input), i.e., all the properties of a regexp match array.
	 * For $&, etc., we must create string jsvals from cx->regExpStatics.
	 * We grab up stack space to keep the newborn strings GC-rooted.
	 */
    	p = rdata->base.regexp->parenCount;
    	argc = 1 + p + 2;
	sp = js_AllocStack(cx, 2 + argc, &mark);
	if (!sp)
	    return JS_FALSE;

	/* Push lambda and its 'this' parameter. */
	*sp++ = OBJECT_TO_JSVAL(lambda);
	*sp++ = OBJECT_TO_JSVAL(OBJ_GET_PARENT(cx, lambda));

#define PUSH_REGEXP_STATIC(sub)                                               \
    PR_BEGIN_MACRO                                                            \
	JSString *str = js_NewStringCopyN(cx,                                 \
					  cx->regExpStatics.sub.chars,        \
					  cx->regExpStatics.sub.length,       \
					  0);                                 \
	if (!str) {                                                           \
	    ok = JS_FALSE;                                                    \
	    goto lambda_out;                                                  \
	}                                                                     \
	*sp++ = STRING_TO_JSVAL(str);                                         \
    PR_END_MACRO

    	/* Push $&, $1, $2, ... */
	PUSH_REGEXP_STATIC(lastMatch);
	i = 0;
    	m = cx->regExpStatics.parenCount;
    	n = PR_MIN(m, 9);
    	for (j = 0; i < n; i++, j++)
	    PUSH_REGEXP_STATIC(parens[j]);
    	for (j = 0; i < m; i++, j++)
	    PUSH_REGEXP_STATIC(moreParens[j]);

#undef PUSH_REGEXP_STATIC

	/* Make sure to push undefined for any unmatched parens. */
	for (; i < p; i++)
	    *sp++ = JSVAL_VOID;

	/* Push match index and input string. */
	*sp++ = INT_TO_JSVAL((jsint)cx->regExpStatics.leftContext.length);
	*sp++ = STRING_TO_JSVAL(rdata->base.str);

	/* Lift current frame to include the args and do the call. */
	fp = cx->fp;
	oldsp = fp->sp;
	fp->sp = sp;
    	ok = js_Invoke(cx, argc, JS_FALSE);
	rval = fp->sp[-1];
	fp->sp = oldsp;

	if (ok) {
	    /*
	     * NB: we count on the newborn string root to hold any string
	     * created by this js_ValueToString that would otherwise be GC-
	     * able, until we use rdata->repstr in do_replace.
	     */
	    repstr = js_ValueToString(cx, rval);
	    if (!repstr) {
	    	ok = JS_FALSE;
	    } else {
		rdata->repstr = repstr;
		*sizep = repstr->length;
	    }
	}

      lambda_out:
	js_FreeStack(cx, mark);
    	return ok;
    }
#endif /* JS_HAS_REPLACE_LAMBDA */

    repstr = rdata->repstr;
    replen = repstr->length;
    for (dp = rdata->dollar; dp; dp = js_strchr(dp + 1, '$')) {
	sub = interpret_dollar(cx, dp, rdata, &skip);
	if (sub)
	    replen += sub->length - skip;
    }
    *sizep = replen;
    return JS_TRUE;
}

static void
do_replace(JSContext *cx, ReplaceData *rdata, jschar *chars)
{
    JSString *repstr;
    jschar *cp, *dp;
    size_t len, skip;
    JSSubString *sub;

    repstr = rdata->repstr;
    cp = repstr->chars;
    dp = rdata->dollar;
    while (dp) {
	len = dp - cp;
	js_strncpy(chars, cp, len);
	chars += len;
	cp = dp;
	sub = interpret_dollar(cx, dp, rdata, &skip);
	if (sub) {
	    len = sub->length;
	    js_strncpy(chars, sub->chars, len);
	    chars += len;
	    cp += skip;
	}
	dp = js_strchr(dp + 1, '$');
    }
    js_strncpy(chars, cp, repstr->length - (cp - repstr->chars));
}

static JSBool
replace_glob(JSContext *cx, jsint count, GlobData *data)
{
    ReplaceData *rdata;
    JSString *str;
    size_t leftoff, leftlen, replen, growth;
    const jschar *left;
    jschar *chars;

    rdata = (ReplaceData *)data;
    str = data->str;
    leftoff = rdata->leftIndex;
    left = str->chars + leftoff;
    leftlen = cx->regExpStatics.lastMatch.chars - left;
    rdata->leftIndex = cx->regExpStatics.lastMatch.chars - str->chars;
    rdata->leftIndex += cx->regExpStatics.lastMatch.length;
    if (!find_replen(cx, rdata, &replen))
    	return JS_FALSE;
    growth = leftlen + replen;
    chars = rdata->chars
	    ? JS_realloc(cx, rdata->chars, (rdata->length + growth + 1)
					   * sizeof(jschar))
	    : JS_malloc(cx, (growth + 1) * sizeof(jschar));
    if (!chars) {
	JS_free(cx, rdata->chars);
	rdata->chars = NULL;
	return JS_FALSE;
    }
    rdata->chars = chars;
    rdata->length += growth;
    chars += rdata->index;
    rdata->index += growth;
    js_strncpy(chars, left, leftlen);
    chars += leftlen;
    do_replace(cx, rdata, chars);
    return JS_TRUE;
}
#endif /* JS_HAS_REGEXPS */

static JSBool
str_replace(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
#if JS_HAS_REGEXPS
    JSObject *lambda;
    JSString *repstr, *str;
    ReplaceData rdata;
    jschar *chars;
    size_t leftlen, rightlen, length;

#if JS_HAS_REPLACE_LAMBDA
    if (JS_TypeOfValue(cx, argv[1]) == JSTYPE_FUNCTION) {
    	lambda = JSVAL_TO_OBJECT(argv[1]);
    	repstr = NULL;
    } else
#endif
    {
	if (!JS_ConvertValue(cx, argv[1], JSTYPE_STRING, &argv[1]))
	    return JS_FALSE;
	repstr = JSVAL_TO_STRING(argv[1]);
	lambda = NULL;
    }

    rdata.base.optarg = 2;
    rdata.base.mode = GLOB_REPLACE;
    rdata.lambda = lambda;
    rdata.repstr = repstr;
    rdata.dollar = repstr ? js_strchr(repstr->chars, '$') : NULL;
    rdata.chars = NULL;
    rdata.length = 0;
    rdata.index = 0;
    rdata.leftIndex = 0;
    if (!match_or_replace(cx, obj, argc, argv, replace_glob, &rdata.base, rval))
	return JS_FALSE;

    if (!rdata.chars) {
	if (rdata.base.global || *rval != JSVAL_TRUE) {
	    /* Didn't match even once. */
	    *rval = STRING_TO_JSVAL(rdata.base.str);
	    return JS_TRUE;
	}
	leftlen = cx->regExpStatics.leftContext.length;
	if (!find_replen(cx, &rdata, &length))
	    return JS_FALSE;
	length += leftlen;
	chars = JS_malloc(cx, (length + 1) * sizeof(jschar));
	if (!chars)
	    return JS_FALSE;
	js_strncpy(chars, cx->regExpStatics.leftContext.chars, leftlen);
	do_replace(cx, &rdata, chars + leftlen);
	rdata.chars = chars;
	rdata.length = length;
    }

    rightlen = cx->regExpStatics.rightContext.length;
    length = rdata.length + rightlen;
    chars = JS_realloc(cx, rdata.chars, (length + 1) * sizeof(jschar));
    if (!chars) {
	JS_free(cx, rdata.chars);
	return JS_FALSE;
    }
    js_strncpy(chars + rdata.length, cx->regExpStatics.rightContext.chars,
	       rightlen);
    chars[length] = 0;

    str = js_NewString(cx, chars, length, 0);
    if (!str) {
	JS_free(cx, chars);
	return JS_FALSE;
    }
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
#else
    return str_nyi(cx, "replace");
#endif
}

/*
 * Subroutine used by str_split to find the next split point in str, starting
 * at offset *ip and looking either for the separator substring given by sep,
 * or for the next re match.  In the re case, return the matched separator in
 * *sep, and the possibly updated offset in *ip.
 *
 * Return -2 on error, -1 on end of string, >= 0 for a valid index of the next
 * separator occurrence if found, or str->length if no separator is found.
 */
static jsint
find_split(JSContext *cx, JSString *str, JSRegExp *re, jsint *ip,
	   JSSubString *sep)
{
    jsint i, j, k;

    /*
     * Stop if past end of string.  If at end of string, we will compare the
     * null char stored there (by js_NewString*) to sep->chars[j] in the while
     * loop at the end of this function, so that
     *
     *  "ab,".split(',') => ["ab", ""]
     *
     * and the resulting array converts back to the string "ab," for symmetry.
     * However, we ape Perl and do this only if there is a sufficiently large
     * limit argument (see str_split).
     */
    i = *ip;
    if ((size_t)i > str->length)
	return -1;

    /*
     * Perl4 special case for str.split(' '), only if the user has selected
     * JavaScript1.2 explicitly.  Split on whitespace, and skip leading w/s.
     * Strange but true, apparently modeled after awk.
     *
     * NB: we set sep->length to the length of the w/s run, so we must test
     * sep->chars[1] == 0 to make sure sep is just one space.
     */
    if (cx->version == JSVERSION_1_2 &&
	!re && *sep->chars == ' ' && sep->chars[1] == 0) {
	/* Skip leading whitespace if at front of str. */
	if (i == 0) {
	    while (JS_ISSPACE(str->chars[i]))
		i++;
	    *ip = i;
	}

	/* Don't delimit whitespace at end of string. */
	if ((size_t)i == str->length)
	    return -1;

	/* Skip over the non-whitespace chars. */
	while ((size_t)i < str->length && !JS_ISSPACE(str->chars[i]))
	    i++;

	/* Now skip the next run of whitespace. */
	j = i;
	while ((size_t)j < str->length && JS_ISSPACE(str->chars[j]))
	    j++;

	/* Update sep->length to count delimiter chars. */
	sep->length = (size_t)(j - i);
	return i;
    }

#if JS_HAS_REGEXPS
    /*
     * Match a regular expression against the separator at or above index i.
     * Call js_ExecuteRegExp with true for the test argument.  On successful
     * match, get the separator from cx->regExpStatics.lastMatch.
     */
    if (re) {
	size_t index;
	jsval rval;

      again:
	/* JS1.2 deviated from Perl by never matching at end of string. */
	if (cx->version == JSVERSION_1_2 && (size_t)i == str->length)
	    return -1;
	index = (size_t)i;
	if (!js_ExecuteRegExp(cx, re, str, &index, JS_TRUE, &rval))
	    return -2;
	if (rval != JSVAL_TRUE) {
	    /* Mismatch: ensure our caller advances i past end of string. */
	    sep->length = 1;
	    return str->length;
	}
	i = (jsint)index;
	*sep = cx->regExpStatics.lastMatch;
	if (sep->length == 0) {
	    /*
	     * Empty string match: never split on an empty match at the start
	     * of a find_split cycle.  Same rule as for an empty global match
	     * in match_or_replace.
	     */
	    if (i == *ip) {
	    	/*
	    	 * "Bump-along" to avoid sticking at an empty match, but don't
	    	 * bump past end of string -- our caller must do that by adding
	    	 * sep->length to our return value.
	    	 */
	    	if ((size_t)i == str->length) {
		    sep->length = 1;
		    return i;
		}
	    	i++;
	    	goto again;
	    }
	}
	PR_ASSERT((size_t)i >= sep->length);
	return i - sep->length;
    }
#endif

    /*
     * Deviate from ECMA by never splitting an empty string by any separator
     * string into a non-empty array (an array of length 1 that contains the
     * empty string).
     */
    if (!JSVERSION_IS_ECMA(cx->version) && str->length == 0)
	return -1;

    /*
     * Special case: if sep is the empty string, split str into one character
     * substrings.  Let our caller worry about whether to split once at end of
     * string into an empty substring.
     */
    if (sep->length == 0)
	return ((size_t)i == str->length) ? -1 : i + 1;

    /*
     * Now that we know sep is non-empty, search starting at i in str for an
     * occurrence of all of sep's chars.  If we find them, return the index of
     * the first separator char.  Otherwise, return str->length.
     */
    j = 0;
    while ((size_t)(k = i + j) < str->length) {
	if (str->chars[k] == sep->chars[j]) {
	    if ((size_t)++j == sep->length)
		return i;
	} else {
	    i++;
	    j = 0;
	}
    }
    return k;
}

static JSBool
str_split(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSString *str, *sub;
    JSObject *arrayobj, *reobj;
    jsval v;
    JSBool ok, limited;
    JSRegExp *re;
    JSSubString *sep, tmp;
    jsdouble d;
    jsint len, limit, i, j, sublen;
    const jschar *substr;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);

    arrayobj = js_ConstructObject(cx, &js_ArrayClass, NULL, NULL);
    if (!arrayobj)
	return JS_FALSE;
    *rval = OBJECT_TO_JSVAL(arrayobj);

    if (argc == 0) {
	v = STRING_TO_JSVAL(str);
	ok = JS_SetElement(cx, arrayobj, 0, &v);
    } else {
#if JS_HAS_REGEXPS
	if (JSVAL_IS_REGEXP(cx, argv[0])) {
	    reobj = JSVAL_TO_OBJECT(argv[0]);
	    re = JS_GetPrivate(cx, reobj);
	    sep = &tmp;

	    /* Set a magic value so we can detect a successful re match. */
	    sep->chars = NULL;
	} else
#endif
	{
	    sep = (JSSubString *)js_ValueToString(cx, argv[0]);
	    if (!sep)
		return JS_FALSE;
	    argv[0] = STRING_TO_JSVAL(sep);
	    reobj = NULL;
	    re = NULL;
	}

        /* Use the second argument as the split limit, if given. */
        /* XXX our v2 ecma spec checks against given, undefined. */
	limited = (argc > 1);
	if (limited) {
	    if (!js_ValueToNumber(cx, argv[1], &d))
		return JS_FALSE;

            /* Clamp limit between 0 and 1 + string length. */
            d = js_DoubleToInteger(d);
            if (d < 0)
                d = 0;
            else if (d > str->length)
                d = 1 + str->length;
	    limit = (jsint)d;
	}

	if (reobj) {
	    /* Lock to protect re just in case it's shared and global. */
	    JS_LOCK_OBJ(cx, reobj);
	}

	len = i = 0;
	while ((j = find_split(cx, str, re, &i, sep)) >= 0) {
	    if (limited && len >= limit)
		break;
	    sublen = j - i;
	    substr = str->chars + i;
	    sub = js_NewStringCopyN(cx, substr, (size_t)sublen, 0);
	    if (!sub) {
		ok = JS_FALSE;
		goto unlock_reobj;
	    }
	    v = STRING_TO_JSVAL(sub);
	    ok = JS_SetElement(cx, arrayobj, len, &v);
	    if (!ok)
		goto unlock_reobj;
	    len++;
#if JS_HAS_REGEXPS
	    /*
	     * Imitate perl's feature of including parenthesized substrings
	     * that matched part of the delimiter in the new array, after the
	     * split substring that was delimited.
	     */
	    if (re && sep->chars) {
		uintN num;
		JSSubString *parsub;

		for (num = 0; num < cx->regExpStatics.parenCount; num++) {
		    if (limited && len >= limit)
			break;
		    parsub = REGEXP_PAREN_SUBSTRING(&cx->regExpStatics, num);
		    sub = js_NewStringCopyN(cx, parsub->chars, parsub->length,
					    0);
		    if (!sub) {
			ok = JS_FALSE;
			goto unlock_reobj;
		    }
		    v = STRING_TO_JSVAL(sub);
		    ok = JS_SetElement(cx, arrayobj, len, &v);
		    if (!ok)
			goto unlock_reobj;
		    len++;
		}
		sep->chars = NULL;
	    }
#endif
	    i = j + sep->length;
	    if (!JSVERSION_IS_ECMA(cx->version)) {
		/*
		 * Deviate from ECMA to imitate Perl, which omits a final
		 * split unless a limit argument is given and big enough.
		 */
		if (!limited && (size_t)i == str->length)
		    break;
	    }
	}
	ok = (j != -2);
      unlock_reobj:
	if (reobj)
	    JS_UNLOCK_OBJ(cx, reobj);
    }
    return ok;
}

static JSBool
str_substr(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
#if JS_HAS_MORE_PERL_FUN
    JSString *str;
    jsdouble d;
    jsdouble length, begin, end;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;

    if (argc != 0) {
	if (!js_ValueToNumber(cx, argv[0], &d))
	    return JS_FALSE;
	length = str->length;
	begin = js_DoubleToInteger(d);
	if (begin < 0) {
	    begin += length;
	    if (begin < 0)
		begin = 0;
	} else if (begin > length) {
	    begin = length;
	}

	if (argc == 1) {
	    end = length;
	} else {
	    if (!js_ValueToNumber(cx, argv[1], &d))
		return JS_FALSE;
	    end = js_DoubleToInteger(d);
	    if (end < 0)
		end = 0;
	    end += begin;
	    if (end > length)
		end = length;
	}

	str = js_NewStringCopyN(cx, str->chars + (size_t)begin,
                                (size_t)(end - begin), 0);
	if (!str)
	    return JS_FALSE;
    }
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
#else
    return str_nyi(cx, "substr");
#endif
}

#ifdef NOTYET
/*
 * From "Programming perl", Larry Wall and Randall L. Schwartz, Copyright XXX
 * O'Reilly & Associates, Inc., but with Java primitive type sizes for i, l,
 * and so on:
 *
 *  a   An ASCII string, unstripped.
 *  A   An ASCII string, trailing nulls and spaces will be stripped.
 *  b   A bit string, low-to-high order.
 *  B   A bit string, high-to-low order.
 *  h   A hexadecimal string, low nybble first.
 *  H   A hexadecimal string, high nybble first.
 *  c   A signed char value.
 *  C   An unsigned char value.
 *  s   A signed short (16-bit) value.
 *  S   An unsigned short (16-bit) value.
 *  i   A signed integer (32-bit) value.
 *  I   An unsigned integer (32-bit) value.
 *  l   A signed long (64-bit) value.
 *  L   An unsigned long (64-bit) value.
 *  n   A short in "network" byte order.
 *  N   An integer in "network" byte order.
 *  f   A single-precision float in IEEE format.
 *  d   A double-precision float in IEEE format.
 *  p   A pointer to a string.
 *  x   Skip forward a byte.
 *  X   Back up one byte.
 *  @   Go to absolute position in string for next field.
 *  u   Uudecode a string.
 *
 * Each letter may be followed by a number giving the repeat count.  Together
 * the letter and repeat count make a field specifier.  Field specifiers may
 * be separated by whitespace, which will be ignored.
 */
static JSBool
str_unpack(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
#if JS_HAS_MORE_PERL_FUN
#else
    return str_nyi(cx, "unpack");
#endif
}
#endif /* NOTYET */

#if JS_HAS_SEQUENCE_OPS
/*
 * Python-esque sequence operations.
 */
static JSBool
str_concat(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSString *str, *str2;
    JSBool ok;
    size_t length, length2, newlength;
    jschar *chars, *newchars;
    uintN i;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);

    length = str->length;
    chars = JS_malloc(cx, (length + 1) * sizeof(jschar));
    if (!chars)
	return JS_FALSE;
    js_strncpy(chars, str->chars, length);

    ok = JS_TRUE;
    for (i = 0; i < argc; i++) {
	str2 = js_ValueToString(cx, argv[i]);
	if (!str2) {
	    ok = JS_FALSE;
	    goto out;
	}
	length2 = str2->length;
	newlength = length + length2;
	newchars = JS_realloc(cx, chars, (newlength + 1) * sizeof(jschar));
	if (!newchars) {
	    ok = JS_FALSE;
	    goto out;
	}
	chars = newchars;
	js_strncpy(chars + length, str2->chars, length2);
	length = newlength;
    }

    chars[length] = 0;
    str = js_NewString(cx, chars, length, 0);
    if (!str)
	ok = JS_FALSE;
out:
    if (ok)
	*rval = STRING_TO_JSVAL(str);
    else
	JS_free(cx, chars);
    return ok;
}

static JSBool
str_slice(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSString *str;
    jsdouble d;
    jsdouble length, begin, end;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);

    if (argc != 0) {
	if (!js_ValueToNumber(cx, argv[0], &d))
	    return JS_FALSE;
	length = str->length;
	begin = js_DoubleToInteger(d);
	if (begin < 0) {
	    begin += length;
	    if (begin < 0)
		begin = 0;
	} else if (begin > length) {
	    begin = length;
	}

	if (argc == 1) {
	    end = length;
	} else {
	    if (!js_ValueToNumber(cx, argv[1], &d))
		return JS_FALSE;
	    end = js_DoubleToInteger(d);
	    if (end < 0) {
		end += length;
		if (end < 0)
		    end = 0;
	    } else if (end > length) {
		end = length;
	    }
	    if (end < begin)
		end = begin;
	}

	str = js_NewStringCopyN(cx, str->chars + (size_t)begin,
                                (size_t)(end - begin), 0);
	if (!str)
	    return JS_FALSE;
    }
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
}
#endif /* JS_HAS_SEQUENCE_OPS */

/*
 * HTML composition aids.
 */
static JSBool
tagify(JSContext *cx, JSObject *obj, jsval *argv,
       const char *begin, const jschar *param, const char *end,
       jsval *rval)
{
    JSString *str;
    jschar *tagbuf;
    size_t beglen, endlen, parlen, taglen;
    size_t i, j;

    str = js_ValueToString(cx, OBJECT_TO_JSVAL(obj));
    if (!str)
	return JS_FALSE;
    argv[-1] = STRING_TO_JSVAL(str);

    if (!end)
	end = begin;

    beglen = strlen(begin);
    taglen = 1 + beglen + 1;			/* '<begin' + '>' */
    if (param) {
	parlen = js_strlen(param);
	taglen += 2 + parlen + 1;		/* '="param"' */
    }
    endlen = strlen(end);
    taglen += str->length + 2 + endlen + 1;	/* 'str</end>' */

    tagbuf = JS_malloc(cx, (taglen + 1) * sizeof(jschar));
    if (!tagbuf)
	return JS_FALSE;

    j = 0;
    tagbuf[j++] = '<';
    for (i = 0; i < beglen; i++)
	tagbuf[j++] = (jschar)begin[i];
    if (param) {
	tagbuf[j++] = '=';
	tagbuf[j++] = '"';
	js_strncpy(&tagbuf[j], param, parlen);
	j += parlen;
	tagbuf[j++] = '"';
    }
    tagbuf[j++] = '>';
    js_strncpy(&tagbuf[j], str->chars, str->length);
    j += str->length;
    tagbuf[j++] = '<';
    tagbuf[j++] = '/';
    for (i = 0; i < endlen; i++)
	tagbuf[j++] = (jschar)end[i];
    tagbuf[j++] = '>';
    PR_ASSERT(j == taglen);

    str = js_NewString(cx, tagbuf, taglen, 0);
    if (!str) {
	JSFREE((char *)tagbuf);
	return JS_FALSE;
    }
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
}

static JSBool
tagify_value(JSContext *cx, JSObject *obj, jsval *argv,
	     const char *begin, const char *end,
	     jsval *rval)
{
    JSString *param;

    param = js_ValueToString(cx, argv[0]);
    if (!param)
	return JS_FALSE;
    argv[0] = STRING_TO_JSVAL(param);
    return tagify(cx, obj, argv, begin, param->chars, end, rval);
}

static JSBool
str_bold(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify(cx, obj, argv, "B", NULL, NULL, rval);
}

static JSBool
str_italics(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify(cx, obj, argv, "I", NULL, NULL, rval);
}

static JSBool
str_fixed(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify(cx, obj, argv, "TT", NULL, NULL, rval);
}

static JSBool
str_fontsize(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify_value(cx, obj, argv, "FONT SIZE", "FONT", rval);
}

static JSBool
str_fontcolor(JSContext *cx, JSObject *obj, uintN argc, jsval *argv,
	      jsval *rval)
{
    return tagify_value(cx, obj, argv, "FONT COLOR", "FONT", rval);
}

static JSBool
str_link(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify_value(cx, obj, argv, "A HREF", "A", rval);
}

static JSBool
str_anchor(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify_value(cx, obj, argv, "A NAME", "A", rval);
}

static JSBool
str_strike(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify(cx, obj, argv, "STRIKE", NULL, NULL, rval);
}

static JSBool
str_small(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify(cx, obj, argv, "SMALL", NULL, NULL, rval);
}

static JSBool
str_big(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify(cx, obj, argv, "BIG", NULL, NULL, rval);
}

static JSBool
str_blink(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify(cx, obj, argv, "BLINK", NULL, NULL, rval);
}

static JSBool
str_sup(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify(cx, obj, argv, "SUP", NULL, NULL, rval);
}

static JSBool
str_sub(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    return tagify(cx, obj, argv, "SUB", NULL, NULL, rval);
}

static JSFunctionSpec string_methods[] = {
#if JS_HAS_TOSOURCE
    {"quote",           str_quote,              0},
    {js_toSource_str,   str_toSource,           0},
#endif

    /* Java-like methods. */
    {js_toString_str,   str_toString,           0},
    {js_valueOf_str,    str_valueOf,            0},
    {"substring",       str_substring,          2},
    {"toLowerCase",     str_toLowerCase,        0},
    {"toUpperCase",     str_toUpperCase,        0},
    {"charAt",          str_charAt,             1},
    {"charCodeAt",      str_charCodeAt,         1},
    {"indexOf",         str_indexOf,            2},
    {"lastIndexOf",     str_lastIndexOf,        2},

    /* Perl-ish methods (search is actually Python-esque). */
    {"match",           str_match,              1},
    {"search",          str_search,             1},
    {"replace",         str_replace,            2},
    {"split",           str_split,              1},
    {"substr",          str_substr,             2},
#ifdef NOTYET
    {"unpack",          str_unpack,             1},
#endif

    /* Python-esque sequence methods. */
#if JS_HAS_SEQUENCE_OPS
    {"concat",          str_concat,             0},
    {"slice",           str_slice,              0},
#endif

    /* HTML string methods. */
    {"bold",            str_bold,               0},
    {"italics",         str_italics,            0},
    {"fixed",           str_fixed,              0},
    {"fontsize",        str_fontsize,           1},
    {"fontcolor",       str_fontcolor,          1},
    {"link",            str_link,               1},
    {"anchor",          str_anchor,             1},
    {"strike",          str_strike,             0},
    {"small",           str_small,              0},
    {"big",             str_big,                0},
    {"blink",           str_blink,              0},
    {"sup",             str_sup,                0},
    {"sub",             str_sub,                0},
    {0}
};

static JSBool
String(JSContext *cx, JSObject *obj, uintN argc, jsval *argv, jsval *rval)
{
    JSString *str;

    if (argc > 0) {
	str = js_ValueToString(cx, argv[0]);
	if (!str)
	    return JS_FALSE;
    } else {
	str = cx->runtime->emptyString;
    }
    if (!cx->fp->constructing) {
	*rval = STRING_TO_JSVAL(str);
	return JS_TRUE;
    }
    OBJ_SET_SLOT(cx, obj, JSSLOT_PRIVATE, STRING_TO_JSVAL(str));
    return JS_TRUE;
}

static JSBool
str_fromCharCode(JSContext *cx, JSObject *obj, uintN argc, jsval *argv,
		 jsval *rval)
{
    jschar *chars;
    uintN i;
    uint16 code;
    JSString *str;

    chars = JS_malloc(cx, (argc + 1) * sizeof(jschar));
    if (!chars)
	return JS_FALSE;
    for (i = 0; i < argc; i++) {
	if (!js_ValueToUint16(cx, argv[i], &code)) {
	    JS_free(cx, chars);
	    return JS_FALSE;
	}
	chars[i] = (jschar)code;
    }
    chars[i] = 0;
    str = js_NewString(cx, chars, argc, 0);
    if (!str) {
	JS_free(cx, chars);
	return JS_FALSE;
    }
    *rval = STRING_TO_JSVAL(str);
    return JS_TRUE;
}

static JSFunctionSpec string_static_methods[] = {
    {"fromCharCode",    str_fromCharCode,       1},
    {0}
};

static PRHashTable *deflated_string_cache;
static uint32 deflated_string_cache_bytes;
#ifdef JS_THREADSAFE
static JSLock *deflated_string_cache_lock;
#endif

JSBool
js_InitStringGlobals(void)
{
#ifdef JS_THREADSAFE
    /* Must come through here once in primordial thread to init safely! */
    if (!deflated_string_cache_lock) {
	deflated_string_cache_lock = JS_NEW_LOCK();
	if (!deflated_string_cache_lock)
	    return JS_FALSE;
    }
#endif
    return JS_TRUE;
}

void
js_FreeStringGlobals()
{
    if (deflated_string_cache) {
	PR_HashTableDestroy(deflated_string_cache);
	deflated_string_cache = NULL;
    }
#ifdef JS_THREADSAFE
    if (deflated_string_cache_lock) {
	JS_DESTROY_LOCK(deflated_string_cache_lock);
	deflated_string_cache_lock = NULL;
    }
#endif
}

JSObject *
js_InitStringClass(JSContext *cx, JSObject *obj)
{
    JSRuntime *rt;
    JSString *empty;
    JSObject *proto;

    rt = cx->runtime;
    empty = rt->emptyString;
    if (!empty) {
	/* Make a permanently locked empty string. */
	empty = js_NewStringCopyN(cx, js_empty_ucstr, 0, GCF_LOCK);
	if (!empty)
	    return NULL;
	rt->emptyString = empty;
    }
    proto = JS_InitClass(cx, obj, NULL, &string_class, String, 1,
			 string_props, string_methods,
			 NULL, string_static_methods);
    if (!proto)
	return NULL;
    OBJ_SET_SLOT(cx, proto, JSSLOT_PRIVATE, STRING_TO_JSVAL(empty));
    return proto;
}

JSString *
js_NewString(JSContext *cx, jschar *chars, size_t length, uintN gcflag)
{
    JSString *str;

    str = js_AllocGCThing(cx, gcflag | GCX_STRING);
    if (!str)
	return NULL;
    str->length = length;
    str->chars = chars;
    return str;
}

JSString *
js_NewStringCopyN(JSContext *cx, const jschar *s, size_t n, uintN gcflag)
{
    jschar *news;
    JSString *str;

    news = (jschar *)JS_malloc(cx, (n + 1) * sizeof(jschar));
    if (!news)
	return NULL;
    js_strncpy(news, s, n);
    news[n] = 0;
    str = js_NewString(cx, news, n, gcflag);
    if (!str)
	JS_free(cx, news);
    return str;
}

JSString *
js_NewStringCopyZ(JSContext *cx, const jschar *s, uintN gcflag)
{
    size_t n, m;
    jschar *news;
    JSString *str;

    n = js_strlen(s);
    m = (n + 1) * sizeof(jschar);
    news = JS_malloc(cx, m);
    if (!news)
	return NULL;
    memcpy(news, s, m);
    str = js_NewString(cx, news, js_strlen(news), gcflag);
    if (!str)
	JS_free(cx, news);
    return str;
}

PR_STATIC_CALLBACK(prhashcode)
js_hash_string_pointer(const void *key)
{
    return (prhashcode)key >> JSVAL_TAGBITS;
}

void
js_FinalizeString(JSContext *cx, JSString *str)
{
    prhashcode hash;
    PRHashEntry *he, **hep;

    if (str->chars) {
	JS_free(cx, str->chars);
	str->chars = NULL;
	if (deflated_string_cache) {
	    hash = js_hash_string_pointer(str);
	    JS_ACQUIRE_LOCK(deflated_string_cache_lock);
	    hep = PR_HashTableRawLookup(deflated_string_cache, hash, str);
	    he = *hep;
	    if (he) {
		JS_free(cx, he->value);
		PR_HashTableRawRemove(deflated_string_cache, hep, he);
		deflated_string_cache_bytes -= str->length;
	    }
	    JS_RELEASE_LOCK(deflated_string_cache_lock);
	}
    }
    str->length = 0;
}

JSObject *
js_StringToObject(JSContext *cx, JSString *str)
{
    JSObject *obj;

    obj = js_NewObject(cx, &string_class, NULL, NULL);
    if (!obj)
	return NULL;
    OBJ_SET_SLOT(cx, obj, JSSLOT_PRIVATE, STRING_TO_JSVAL(str));
    return obj;
}

JSString *
js_ValueToString(JSContext *cx, jsval v)
{
    JSObject *obj;
    JSString *str;

    if (JSVAL_IS_OBJECT(v)) {
	obj = JSVAL_TO_OBJECT(v);
	if (!obj)
	    return ATOM_TO_STRING(cx->runtime->atomState.nullAtom);
	if (!OBJ_DEFAULT_VALUE(cx, obj, JSTYPE_STRING, &v))
	    return NULL;
    }
    if (JSVAL_IS_STRING(v)) {
	str = JSVAL_TO_STRING(v);
    } else if (JSVAL_IS_INT(v)) {
	str = js_NumberToString(cx, JSVAL_TO_INT(v));
    } else if (JSVAL_IS_DOUBLE(v)) {
	str = js_NumberToString(cx, *JSVAL_TO_DOUBLE(v));
    } else if (JSVAL_IS_BOOLEAN(v)) {
	str = js_BooleanToString(cx, JSVAL_TO_BOOLEAN(v));
    } else {
	str = ATOM_TO_STRING(cx->runtime->atomState.typeAtoms[JSTYPE_VOID]);
    }
    return str;
}

JSString *
js_ValueToSource(JSContext *cx, jsval v)
{
    if (JSVAL_IS_STRING(v))
	return js_QuoteString(cx, JSVAL_TO_STRING(v), '"');
    if (!JSVAL_IS_PRIMITIVE(v)) {
	js_TryMethod(cx, JSVAL_TO_OBJECT(v),
		     cx->runtime->atomState.toSourceAtom,
		     0, NULL, &v);
    }
    return js_ValueToString(cx, v);
}

prhashcode
js_HashString(const JSString *str)
{
    prhashcode h;
    size_t n, m;
    const jschar *s;

    h = 0;
    n = str->length;
    s = str->chars;
    if (n < 16) {
	/* Hash every char in a short string. */
	for (; n; s++, n--)
	    h = (h >> 28) ^ (h << 4) ^ *s;
    } else {
	/* Sample a la java.lang.String.hash(). */
	for (m = n / 8; n >= m; s += m, n -= m)
	    h = (h >> 28) ^ (h << 4) ^ *s;
    }
    return h;
}

intN
js_CompareStrings(const JSString *str1, const JSString *str2)
{
    size_t l1, l2, n, i;
    const jschar *s1, *s2;
    intN cmp;

    l1 = str1->length, l2 = str2->length;
    s1 = str1->chars,  s2 = str2->chars;
    n = PR_MIN(l1, l2);
    for (i = 0; i < n; i++) {
	cmp = s1[i] - s2[i];
	if (cmp != 0)
	    return cmp;
    }
    return (intN)(l1 - l2);
}

size_t
js_strlen(const jschar *s)
{
    const jschar *t;

    for (t = s; *t != 0; t++)
	;
    return (size_t)(t - s);
}

jschar *
js_strchr(const jschar *s, jschar c)
{
    while (*s != 0) {
	if (*s == c)
	    return (jschar *)s;
	s++;
    }
    return NULL;
}

jschar *
js_strncpy(jschar *t, const jschar *s, size_t n)
{
    size_t i;

    for (i = 0; i < n; i++)
	t[i] = s[i];
    return t;
}

jschar *
js_InflateString(JSContext *cx, const char *bytes, size_t length)
{
    jschar *chars;
    size_t i;

    chars = JS_malloc(cx, (length + 1) * sizeof(jschar));
    if (!chars)
	return NULL;
    for (i = 0; i < length; i++)
	chars[i] = (jschar) bytes[i];
    chars[i] = 0;
    return chars;
}

/*
 * May be called with null cx by js_GetStringBytes, see below.
 */
char *
js_DeflateString(JSContext *cx, const jschar *chars, size_t length)
{
    size_t i, size;
    char *bytes;

    size = (length + 1) * sizeof(char);
    bytes = cx ? JS_malloc(cx, size) : JSMALLOC(size,char);
    if (!bytes)
	return NULL;
    for (i = 0; i < length; i++)
	bytes[i] = (char) chars[i];
    bytes[i] = 0;
    return bytes;
}

static PRHashTable *
GetDeflatedStringCache(void)
{
    PRHashTable *cache;

    cache = deflated_string_cache;
    if (!cache) {
	cache = PR_NewHashTable(8, js_hash_string_pointer,
				PR_CompareValues, PR_CompareValues,
				NULL, NULL);
	deflated_string_cache = cache;
    }
    return cache;
}

JSBool
js_SetStringBytes(JSString *str, char *bytes, size_t length)
{
    PRHashTable *cache;
    JSBool ok;
    prhashcode hash;
    PRHashEntry **hep;

    JS_ACQUIRE_LOCK(deflated_string_cache_lock);

    cache = GetDeflatedStringCache();
    if (!cache) {
	ok = JS_FALSE;
    } else {
	hash = js_hash_string_pointer(str);
	hep = PR_HashTableRawLookup(cache, hash, str);
	PR_ASSERT(*hep == NULL);
	ok = PR_HashTableRawAdd(cache, hep, hash, str, bytes) != NULL;
	if (ok)
	    deflated_string_cache_bytes += length;
    }

    JS_RELEASE_LOCK(deflated_string_cache_lock);
    return ok;
}

char *
js_GetStringBytes(JSString *str)
{
    PRHashTable *cache;
    char *bytes;
    prhashcode hash;
    PRHashEntry *he, **hep;

    JS_ACQUIRE_LOCK(deflated_string_cache_lock);

    cache = GetDeflatedStringCache();
    if (!cache) {
	bytes = NULL;
    } else {
	hash = js_hash_string_pointer(str);
	hep = PR_HashTableRawLookup(cache, hash, str);
	he = *hep;
	if (he) {
	    bytes = he->value;
	} else {
	    bytes = js_DeflateString(NULL, str->chars, str->length);
	    if (bytes) {
		if (PR_HashTableRawAdd(cache, hep, hash, str, bytes)) {
		    deflated_string_cache_bytes += str->length;
		} else {
		    JSFREE(bytes);
		    bytes = NULL;
		}
	    }
	}
    }

    JS_RELEASE_LOCK(deflated_string_cache_lock);
    return bytes;
}

/*
 * From java.lang.Character.java:
 *
 * The character properties are currently encoded into 32 bits in the
 * following manner:
 *
 * 10 bits      signed offset used for converting case
 *  1 bit       if 1, adding the signed offset converts the character to
 *              lowercase
 *  1 bit       if 1, subtracting the signed offset converts the character to
 *              uppercase
 *  1 bit       if 1, character has a titlecase equivalent (possibly itself)
 *  3 bits      0  may not be part of an identifier
 *              1  ignorable control; may continue a Unicode identifier or JS
 *                 identifier
 *              2  may continue a JS identifier but not a Unicode identifier
 *                 (unused)
 *              3  may continue a Unicode identifier or JS identifier
 *              4  is a JS whitespace character
 *              5  may start or continue a JS identifier;
 *                 may continue but not start a Unicode identifier (_)
 *              6  may start or continue a JS identifier but not a Unicode
 *                 identifier ($)
 *              7  may start or continue a Unicode identifier or JS identifier
 *              Thus:
 *                 5, 6, 7 may start a JS identifier
 *                 1, 2, 3, 5, 6, 7 may continue a JS identifier
 *                 7 may start a Unicode identifier
 *                 1, 3, 5, 7 may continue a Unicode identifier
 *                 1 is ignorable within an identifier
 *                 4 is JS whitespace
 *  2 bits      0  this character has no numeric property
 *              1  adding the digit offset to the character code and then
 *                 masking with 0x1F will produce the desired numeric value
 *              2  this character has a "strange" numeric value
 *              3  a JS supradecimal digit: adding the digit offset to the
 *                 character code, then masking with 0x1F, then adding 10
 *                 will produce the desired numeric value
 *  5 bits      digit offset
 *  4 bits      reserved for future use
 *  5 bits      character type
 */

/* The X table has 1024 entries for a total of 1024 bytes. */

const uint8 js_X[] = {
  0,   1,   2,   3,   4,   5,   6,   7,  /*  0x0000 */
  8,   9,  10,  11,  12,  13,  14,  15,  /*  0x0200 */
 16,  17,  18,  19,  20,  21,  22,  23,  /*  0x0400 */
 24,  25,  26,  27,  28,  28,  28,  28,  /*  0x0600 */
 28,  28,  28,  28,  29,  30,  31,  32,  /*  0x0800 */
 33,  34,  35,  36,  37,  38,  39,  40,  /*  0x0A00 */
 41,  42,  43,  44,  45,  46,  28,  28,  /*  0x0C00 */
 47,  48,  49,  50,  51,  52,  53,  28,  /*  0x0E00 */
 28,  28,  54,  55,  56,  57,  58,  59,  /*  0x1000 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x1200 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x1400 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x1600 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x1800 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x1A00 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x1C00 */
 60,  60,  61,  62,  63,  64,  65,  66,  /*  0x1E00 */
 67,  68,  69,  70,  71,  72,  73,  74,  /*  0x2000 */
 75,  75,  75,  76,  77,  78,  28,  28,  /*  0x2200 */
 79,  80,  81,  82,  83,  83,  84,  85,  /*  0x2400 */
 86,  85,  28,  28,  87,  88,  89,  28,  /*  0x2600 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x2800 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x2A00 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x2C00 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x2E00 */
 90,  91,  92,  93,  94,  56,  95,  28,  /*  0x3000 */
 96,  97,  98,  99,  83, 100,  83, 101,  /*  0x3200 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x3400 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x3600 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x3800 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x3A00 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x3C00 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x3E00 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x4000 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x4200 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x4400 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x4600 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x4800 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x4A00 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0x4C00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x4E00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x5000 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x5200 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x5400 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x5600 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x5800 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x5A00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x5C00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x5E00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x6000 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x6200 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x6400 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x6600 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x6800 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x6A00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x6C00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x6E00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x7000 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x7200 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x7400 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x7600 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x7800 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x7A00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x7C00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x7E00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x8000 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x8200 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x8400 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x8600 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x8800 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x8A00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x8C00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x8E00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x9000 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x9200 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x9400 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x9600 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x9800 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x9A00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0x9C00 */
 56,  56,  56,  56,  56,  56, 102,  28,  /*  0x9E00 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0xA000 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0xA200 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0xA400 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0xA600 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0xA800 */
 28,  28,  28,  28,  28,  28,  28,  28,  /*  0xAA00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xAC00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xAE00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xB000 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xB200 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xB400 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xB600 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xB800 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xBA00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xBC00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xBE00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xC000 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xC200 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xC400 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xC600 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xC800 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xCA00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xCC00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xCE00 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xD000 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xD200 */
 56,  56,  56,  56,  56,  56,  56,  56,  /*  0xD400 */
 56,  56,  56,  56,  56,  56, 103,  28,  /*  0xD600 */
104, 104, 104, 104, 104, 104, 104, 104,  /*  0xD800 */
104, 104, 104, 104, 104, 104, 104, 104,  /*  0xDA00 */
104, 104, 104, 104, 104, 104, 104, 104,  /*  0xDC00 */
104, 104, 104, 104, 104, 104, 104, 104,  /*  0xDE00 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xE000 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xE200 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xE400 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xE600 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xE800 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xEA00 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xEC00 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xEE00 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xF000 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xF200 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xF400 */
105, 105, 105, 105, 105, 105, 105, 105,  /*  0xF600 */
105, 105, 105, 105,  56,  56,  56,  56,  /*  0xF800 */
106,  28,  28,  28, 107, 108, 109, 110,  /*  0xFA00 */
 56,  56,  56,  56, 111, 112, 113, 114,  /*  0xFC00 */
115, 116,  56, 117, 118, 119, 120, 121   /*  0xFE00 */
};

/* The Y table has 7808 entries for a total of 7808 bytes. */

const uint8 js_Y[] = {
  0,   0,   0,   0,   0,   0,   0,   0,  /*    0 */
  0,   1,   1,   1,   1,   1,   0,   0,  /*    0 */
  0,   0,   0,   0,   0,   0,   0,   0,  /*    0 */
  0,   0,   0,   0,   1,   1,   1,   1,  /*    0 */
  2,   3,   3,   3,   4,   3,   3,   3,  /*    0 */
  5,   6,   3,   7,   3,   8,   3,   3,  /*    0 */
  9,   9,   9,   9,   9,   9,   9,   9,  /*    0 */
  9,   9,   3,   3,   7,   7,   7,   3,  /*    0 */
  3,  10,  10,  10,  10,  10,  10,  10,  /*    1 */
 10,  10,  10,  10,  10,  10,  10,  10,  /*    1 */
 10,  10,  10,  10,  10,  10,  10,  10,  /*    1 */
 10,  10,  10,   5,   3,   6,  11,  12,  /*    1 */
 11,  13,  13,  13,  13,  13,  13,  13,  /*    1 */
 13,  13,  13,  13,  13,  13,  13,  13,  /*    1 */
 13,  13,  13,  13,  13,  13,  13,  13,  /*    1 */
 13,  13,  13,   5,   7,   6,   7,   0,  /*    1 */
  0,   0,   0,   0,   0,   0,   0,   0,  /*    2 */
  0,   0,   0,   0,   0,   0,   0,   0,  /*    2 */
  0,   0,   0,   0,   0,   0,   0,   0,  /*    2 */
  0,   0,   0,   0,   0,   0,   0,   0,  /*    2 */
 14,   3,   4,   4,   4,   4,  15,  15,  /*    2 */
 11,  15,  16,   5,   7,   8,  15,  11,  /*    2 */
 15,   7,  17,  17,  11,  16,  15,   3,  /*    2 */
 11,  18,  16,   6,  19,  19,  19,   3,  /*    2 */
 20,  20,  20,  20,  20,  20,  20,  20,  /*    3 */
 20,  20,  20,  20,  20,  20,  20,  20,  /*    3 */
 20,  20,  20,  20,  20,  20,  20,   7,  /*    3 */
 20,  20,  20,  20,  20,  20,  20,  16,  /*    3 */
 21,  21,  21,  21,  21,  21,  21,  21,  /*    3 */
 21,  21,  21,  21,  21,  21,  21,  21,  /*    3 */
 21,  21,  21,  21,  21,  21,  21,   7,  /*    3 */
 21,  21,  21,  21,  21,  21,  21,  22,  /*    3 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    4 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    4 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    4 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    4 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    4 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    4 */
 25,  26,  23,  24,  23,  24,  23,  24,  /*    4 */
 16,  23,  24,  23,  24,  23,  24,  23,  /*    4 */
 24,  23,  24,  23,  24,  23,  24,  23,  /*    5 */
 24,  16,  23,  24,  23,  24,  23,  24,  /*    5 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    5 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    5 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    5 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    5 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    5 */
 27,  23,  24,  23,  24,  23,  24,  28,  /*    5 */
 16,  29,  23,  24,  23,  24,  30,  23,  /*    6 */
 24,  31,  31,  23,  24,  16,  32,  32,  /*    6 */
 33,  23,  24,  31,  34,  16,  35,  36,  /*    6 */
 23,  24,  16,  16,  35,  37,  16,  38,  /*    6 */
 23,  24,  23,  24,  23,  24,  38,  23,  /*    6 */
 24,  39,  40,  16,  23,  24,  39,  23,  /*    6 */
 24,  41,  41,  23,  24,  23,  24,  42,  /*    6 */
 23,  24,  16,  40,  23,  24,  40,  40,  /*    6 */
 40,  40,  40,  40,  43,  44,  45,  43,  /*    7 */
 44,  45,  43,  44,  45,  23,  24,  23,  /*    7 */
 24,  23,  24,  23,  24,  23,  24,  23,  /*    7 */
 24,  23,  24,  23,  24,  16,  23,  24,  /*    7 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    7 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    7 */
 16,  43,  44,  45,  23,  24,  46,  46,  /*    7 */
 46,  46,  23,  24,  23,  24,  23,  24,  /*    7 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    8 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    8 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*    8 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*    8 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*    8 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*    8 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*    8 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*    8 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*    9 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*    9 */
 16,  16,  16,  47,  48,  16,  49,  49,  /*    9 */
 50,  50,  16,  51,  16,  16,  16,  16,  /*    9 */
 49,  16,  16,  52,  16,  16,  16,  16,  /*    9 */
 53,  54,  16,  16,  16,  16,  16,  54,  /*    9 */
 16,  16,  55,  16,  16,  16,  16,  16,  /*    9 */
 16,  16,  16,  16,  16,  16,  16,  16,  /*    9 */
 16,  16,  16,  56,  16,  16,  16,  16,  /*   10 */
 56,  16,  57,  57,  16,  16,  16,  16,  /*   10 */
 16,  16,  58,  16,  16,  16,  16,  16,  /*   10 */
 16,  16,  16,  16,  16,  16,  16,  16,  /*   10 */
 16,  16,  16,  16,  16,  16,  16,  16,  /*   10 */
 16,  46,  46,  46,  46,  46,  46,  46,  /*   10 */
 59,  59,  59,  59,  59,  59,  59,  59,  /*   10 */
 59,  11,  11,  59,  59,  59,  59,  59,  /*   10 */
 59,  59,  11,  11,  11,  11,  11,  11,  /*   11 */
 11,  11,  11,  11,  11,  11,  11,  11,  /*   11 */
 59,  59,  11,  11,  11,  11,  11,  11,  /*   11 */
 11,  11,  11,  11,  11,  11,  11,  46,  /*   11 */
 59,  59,  59,  59,  59,  11,  11,  11,  /*   11 */
 11,  11,  46,  46,  46,  46,  46,  46,  /*   11 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   11 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   11 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   12 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   12 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   12 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   12 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   12 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   12 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   12 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   12 */
 60,  60,  60,  60,  60,  60,  46,  46,  /*   13 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   13 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   13 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   13 */
 60,  60,  46,  46,  46,  46,  46,  46,  /*   13 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   13 */
 46,  46,  46,  46,   3,   3,  46,  46,  /*   13 */
 46,  46,  59,  46,  46,  46,   3,  46,  /*   13 */
 46,  46,  46,  46,  11,  11,  61,   3,  /*   14 */
 62,  62,  62,  46,  63,  46,  64,  64,  /*   14 */
 16,  20,  20,  20,  20,  20,  20,  20,  /*   14 */
 20,  20,  20,  20,  20,  20,  20,  20,  /*   14 */
 20,  20,  46,  20,  20,  20,  20,  20,  /*   14 */
 20,  20,  20,  20,  65,  66,  66,  66,  /*   14 */
 16,  21,  21,  21,  21,  21,  21,  21,  /*   14 */
 21,  21,  21,  21,  21,  21,  21,  21,  /*   14 */
 21,  21,  16,  21,  21,  21,  21,  21,  /*   15 */
 21,  21,  21,  21,  67,  68,  68,  46,  /*   15 */
 69,  70,  38,  38,  38,  71,  72,  46,  /*   15 */
 46,  46,  38,  46,  38,  46,  38,  46,  /*   15 */
 38,  46,  23,  24,  23,  24,  23,  24,  /*   15 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   15 */
 73,  74,  16,  40,  46,  46,  46,  46,  /*   15 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   15 */
 46,  75,  75,  75,  75,  75,  75,  75,  /*   16 */
 75,  75,  75,  75,  75,  46,  75,  75,  /*   16 */
 20,  20,  20,  20,  20,  20,  20,  20,  /*   16 */
 20,  20,  20,  20,  20,  20,  20,  20,  /*   16 */
 20,  20,  20,  20,  20,  20,  20,  20,  /*   16 */
 20,  20,  20,  20,  20,  20,  20,  20,  /*   16 */
 21,  21,  21,  21,  21,  21,  21,  21,  /*   16 */
 21,  21,  21,  21,  21,  21,  21,  21,  /*   16 */
 21,  21,  21,  21,  21,  21,  21,  21,  /*   17 */
 21,  21,  21,  21,  21,  21,  21,  21,  /*   17 */
 46,  74,  74,  74,  74,  74,  74,  74,  /*   17 */
 74,  74,  74,  74,  74,  46,  74,  74,  /*   17 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   17 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   17 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   17 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   17 */
 23,  24,  15,  60,  60,  60,  60,  46,  /*   18 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   18 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   18 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   18 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   18 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   18 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   18 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   18 */
 40,  23,  24,  23,  24,  46,  46,  23,  /*   19 */
 24,  46,  46,  23,  24,  46,  46,  46,  /*   19 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   19 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   19 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   19 */
 23,  24,  23,  24,  46,  46,  23,  24,  /*   19 */
 23,  24,  23,  24,  23,  24,  46,  46,  /*   19 */
 23,  24,  46,  46,  46,  46,  46,  46,  /*   19 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   20 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   20 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   20 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   20 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   20 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   20 */
 46,  76,  76,  76,  76,  76,  76,  76,  /*   20 */
 76,  76,  76,  76,  76,  76,  76,  76,  /*   20 */
 76,  76,  76,  76,  76,  76,  76,  76,  /*   21 */
 76,  76,  76,  76,  76,  76,  76,  76,  /*   21 */
 76,  76,  76,  76,  76,  76,  76,  46,  /*   21 */
 46,  59,   3,   3,   3,   3,   3,   3,  /*   21 */
 46,  77,  77,  77,  77,  77,  77,  77,  /*   21 */
 77,  77,  77,  77,  77,  77,  77,  77,  /*   21 */
 77,  77,  77,  77,  77,  77,  77,  77,  /*   21 */
 77,  77,  77,  77,  77,  77,  77,  77,  /*   21 */
 77,  77,  77,  77,  77,  77,  77,  16,  /*   22 */
 46,   3,  46,  46,  46,  46,  46,  46,  /*   22 */
 46,  60,  60,  60,  60,  60,  60,  60,  /*   22 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   22 */
 60,  60,  46,  60,  60,  60,  60,  60,  /*   22 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   22 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   22 */
 60,  60,  46,  60,  60,  60,   3,  60,  /*   22 */
  3,  60,  60,   3,  60,  46,  46,  46,  /*   23 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   23 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   23 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   23 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   23 */
 40,  40,  40,  46,  46,  46,  46,  46,  /*   23 */
 40,  40,  40,   3,   3,  46,  46,  46,  /*   23 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   23 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   24 */
 46,  46,  46,  46,   3,  46,  46,  46,  /*   24 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   24 */
 46,  46,  46,   3,  46,  46,  46,   3,  /*   24 */
 46,  40,  40,  40,  40,  40,  40,  40,  /*   24 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   24 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   24 */
 40,  40,  40,  46,  46,  46,  46,  46,  /*   24 */
 59,  40,  40,  40,  40,  40,  40,  40,  /*   25 */
 40,  40,  40,  60,  60,  60,  60,  60,  /*   25 */
 60,  60,  60,  46,  46,  46,  46,  46,  /*   25 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   25 */
 78,  78,  78,  78,  78,  78,  78,  78,  /*   25 */
 78,  78,   3,   3,   3,   3,  46,  46,  /*   25 */
 60,  40,  40,  40,  40,  40,  40,  40,  /*   25 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   25 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   26 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   26 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   26 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   26 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   26 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   26 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   26 */
 46,  46,  40,  40,  40,  40,  40,  46,  /*   26 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   27 */
 40,  40,  40,  40,  40,  40,  40,  46,  /*   27 */
 40,  40,  40,  40,   3,  40,  60,  60,  /*   27 */
 60,  60,  60,  60,  60,  79,  79,  60,  /*   27 */
 60,  60,  60,  60,  60,  59,  59,  60,  /*   27 */
 60,  15,  60,  60,  60,  60,  46,  46,  /*   27 */
  9,   9,   9,   9,   9,   9,   9,   9,  /*   27 */
  9,   9,  46,  46,  46,  46,  46,  46,  /*   27 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   28 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   28 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   28 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   28 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   28 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   28 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   28 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   28 */
 46,  60,  60,  80,  46,  40,  40,  40,  /*   29 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   29 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   29 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   29 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   29 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   29 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   29 */
 40,  40,  46,  46,  60,  40,  80,  80,  /*   29 */
 80,  60,  60,  60,  60,  60,  60,  60,  /*   30 */
 60,  80,  80,  80,  80,  60,  46,  46,  /*   30 */
 15,  60,  60,  60,  60,  46,  46,  46,  /*   30 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   30 */
 40,  40,  60,  60,   3,   3,  81,  81,  /*   30 */
 81,  81,  81,  81,  81,  81,  81,  81,  /*   30 */
  3,  46,  46,  46,  46,  46,  46,  46,  /*   30 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   30 */
 46,  60,  80,  80,  46,  40,  40,  40,  /*   31 */
 40,  40,  40,  40,  40,  46,  46,  40,  /*   31 */
 40,  46,  46,  40,  40,  40,  40,  40,  /*   31 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   31 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   31 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   31 */
 40,  46,  40,  46,  46,  46,  40,  40,  /*   31 */
 40,  40,  46,  46,  60,  46,  80,  80,  /*   31 */
 80,  60,  60,  60,  60,  46,  46,  80,  /*   32 */
 80,  46,  46,  80,  80,  60,  46,  46,  /*   32 */
 46,  46,  46,  46,  46,  46,  46,  80,  /*   32 */
 46,  46,  46,  46,  40,  40,  46,  40,  /*   32 */
 40,  40,  60,  60,  46,  46,  81,  81,  /*   32 */
 81,  81,  81,  81,  81,  81,  81,  81,  /*   32 */
 40,  40,   4,   4,  82,  82,  82,  82,  /*   32 */
 19,  83,  15,  46,  46,  46,  46,  46,  /*   32 */
 46,  46,  60,  46,  46,  40,  40,  40,  /*   33 */
 40,  40,  40,  46,  46,  46,  46,  40,  /*   33 */
 40,  46,  46,  40,  40,  40,  40,  40,  /*   33 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   33 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   33 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   33 */
 40,  46,  40,  40,  46,  40,  40,  46,  /*   33 */
 40,  40,  46,  46,  60,  46,  80,  80,  /*   33 */
 80,  60,  60,  46,  46,  46,  46,  60,  /*   34 */
 60,  46,  46,  60,  60,  60,  46,  46,  /*   34 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   34 */
 46,  40,  40,  40,  40,  46,  40,  46,  /*   34 */
 46,  46,  46,  46,  46,  46,  81,  81,  /*   34 */
 81,  81,  81,  81,  81,  81,  81,  81,  /*   34 */
 60,  60,  40,  40,  40,  46,  46,  46,  /*   34 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   34 */
 46,  60,  60,  80,  46,  40,  40,  40,  /*   35 */
 40,  40,  40,  40,  46,  40,  46,  40,  /*   35 */
 40,  40,  46,  40,  40,  40,  40,  40,  /*   35 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   35 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   35 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   35 */
 40,  46,  40,  40,  46,  40,  40,  40,  /*   35 */
 40,  40,  46,  46,  60,  40,  80,  80,  /*   35 */
 80,  60,  60,  60,  60,  60,  46,  60,  /*   36 */
 60,  80,  46,  80,  80,  60,  46,  46,  /*   36 */
 15,  46,  46,  46,  46,  46,  46,  46,  /*   36 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   36 */
 40,  46,  46,  46,  46,  46,  81,  81,  /*   36 */
 81,  81,  81,  81,  81,  81,  81,  81,  /*   36 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   36 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   36 */
 46,  60,  80,  80,  46,  40,  40,  40,  /*   37 */
 40,  40,  40,  40,  40,  46,  46,  40,  /*   37 */
 40,  46,  46,  40,  40,  40,  40,  40,  /*   37 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   37 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   37 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   37 */
 40,  46,  40,  40,  46,  46,  40,  40,  /*   37 */
 40,  40,  46,  46,  60,  40,  80,  60,  /*   37 */
 80,  60,  60,  60,  46,  46,  46,  80,  /*   38 */
 80,  46,  46,  80,  80,  60,  46,  46,  /*   38 */
 46,  46,  46,  46,  46,  46,  60,  80,  /*   38 */
 46,  46,  46,  46,  40,  40,  46,  40,  /*   38 */
 40,  40,  46,  46,  46,  46,  81,  81,  /*   38 */
 81,  81,  81,  81,  81,  81,  81,  81,  /*   38 */
 15,  46,  46,  46,  46,  46,  46,  46,  /*   38 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   38 */
 46,  46,  60,  80,  46,  40,  40,  40,  /*   39 */
 40,  40,  40,  46,  46,  46,  40,  40,  /*   39 */
 40,  46,  40,  40,  40,  40,  46,  46,  /*   39 */
 46,  40,  40,  46,  40,  46,  40,  40,  /*   39 */
 46,  46,  46,  40,  40,  46,  46,  46,  /*   39 */
 40,  40,  40,  46,  46,  46,  40,  40,  /*   39 */
 40,  40,  40,  40,  40,  40,  46,  40,  /*   39 */
 40,  40,  46,  46,  46,  46,  80,  80,  /*   39 */
 60,  80,  80,  46,  46,  46,  80,  80,  /*   40 */
 80,  46,  80,  80,  80,  60,  46,  46,  /*   40 */
 46,  46,  46,  46,  46,  46,  46,  80,  /*   40 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   40 */
 46,  46,  46,  46,  46,  46,  46,  81,  /*   40 */
 81,  81,  81,  81,  81,  81,  81,  81,  /*   40 */
 84,  19,  19,  46,  46,  46,  46,  46,  /*   40 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   40 */
 46,  80,  80,  80,  46,  40,  40,  40,  /*   41 */
 40,  40,  40,  40,  40,  46,  40,  40,  /*   41 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   41 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   41 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   41 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   41 */
 40,  40,  40,  40,  46,  40,  40,  40,  /*   41 */
 40,  40,  46,  46,  46,  46,  60,  60,  /*   41 */
 60,  80,  80,  80,  80,  46,  60,  60,  /*   42 */
 60,  46,  60,  60,  60,  60,  46,  46,  /*   42 */
 46,  46,  46,  46,  46,  60,  60,  46,  /*   42 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   42 */
 40,  40,  46,  46,  46,  46,  81,  81,  /*   42 */
 81,  81,  81,  81,  81,  81,  81,  81,  /*   42 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   42 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   42 */
 46,  46,  80,  80,  46,  40,  40,  40,  /*   43 */
 40,  40,  40,  40,  40,  46,  40,  40,  /*   43 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   43 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   43 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   43 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   43 */
 40,  40,  40,  40,  46,  40,  40,  40,  /*   43 */
 40,  40,  46,  46,  46,  46,  80,  60,  /*   43 */
 80,  80,  80,  80,  80,  46,  60,  80,  /*   44 */
 80,  46,  80,  80,  60,  60,  46,  46,  /*   44 */
 46,  46,  46,  46,  46,  80,  80,  46,  /*   44 */
 46,  46,  46,  46,  46,  46,  40,  46,  /*   44 */
 40,  40,  46,  46,  46,  46,  81,  81,  /*   44 */
 81,  81,  81,  81,  81,  81,  81,  81,  /*   44 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   44 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   44 */
 46,  46,  80,  80,  46,  40,  40,  40,  /*   45 */
 40,  40,  40,  40,  40,  46,  40,  40,  /*   45 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   45 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   45 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   45 */
 40,  46,  40,  40,  40,  40,  40,  40,  /*   45 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   45 */
 40,  40,  46,  46,  46,  46,  80,  80,  /*   45 */
 80,  60,  60,  60,  46,  46,  80,  80,  /*   46 */
 80,  46,  80,  80,  80,  60,  46,  46,  /*   46 */
 46,  46,  46,  46,  46,  46,  46,  80,  /*   46 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   46 */
 40,  40,  46,  46,  46,  46,  81,  81,  /*   46 */
 81,  81,  81,  81,  81,  81,  81,  81,  /*   46 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   46 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   46 */
 46,  40,  40,  40,  40,  40,  40,  40,  /*   47 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   47 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   47 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   47 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   47 */
 40,  40,  40,  40,  40,  40,  40,   3,  /*   47 */
 40,  60,  40,  40,  60,  60,  60,  60,  /*   47 */
 60,  60,  60,  46,  46,  46,  46,   4,  /*   47 */
 40,  40,  40,  40,  40,  40,  59,  60,  /*   48 */
 60,  60,  60,  60,  60,  60,  60,  15,  /*   48 */
  9,   9,   9,   9,   9,   9,   9,   9,  /*   48 */
  9,   9,   3,   3,  46,  46,  46,  46,  /*   48 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   48 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   48 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   48 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   48 */
 46,  40,  40,  46,  40,  46,  46,  40,  /*   49 */
 40,  46,  40,  46,  46,  40,  46,  46,  /*   49 */
 46,  46,  46,  46,  40,  40,  40,  40,  /*   49 */
 46,  40,  40,  40,  40,  40,  40,  40,  /*   49 */
 46,  40,  40,  40,  46,  40,  46,  40,  /*   49 */
 46,  46,  40,  40,  46,  40,  40,   3,  /*   49 */
 40,  60,  40,  40,  60,  60,  60,  60,  /*   49 */
 60,  60,  46,  60,  60,  40,  46,  46,  /*   49 */
 40,  40,  40,  40,  40,  46,  59,  46,  /*   50 */
 60,  60,  60,  60,  60,  60,  46,  46,  /*   50 */
  9,   9,   9,   9,   9,   9,   9,   9,  /*   50 */
  9,   9,  46,  46,  40,  40,  46,  46,  /*   50 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   50 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   50 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   50 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   50 */
 15,  15,  15,  15,   3,   3,   3,   3,  /*   51 */
  3,   3,   3,   3,   3,   3,   3,   3,  /*   51 */
  3,   3,   3,  15,  15,  15,  15,  15,  /*   51 */
 60,  60,  15,  15,  15,  15,  15,  15,  /*   51 */
 78,  78,  78,  78,  78,  78,  78,  78,  /*   51 */
 78,  78,  85,  85,  85,  85,  85,  85,  /*   51 */
 85,  85,  85,  85,  15,  60,  15,  60,  /*   51 */
 15,  60,   5,   6,   5,   6,  80,  80,  /*   51 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   52 */
 46,  40,  40,  40,  40,  40,  40,  40,  /*   52 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   52 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   52 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   52 */
 40,  40,  46,  46,  46,  46,  46,  46,  /*   52 */
 46,  60,  60,  60,  60,  60,  60,  60,  /*   52 */
 60,  60,  60,  60,  60,  60,  60,  80,  /*   52 */
 60,  60,  60,  60,  60,   3,  60,  60,  /*   53 */
 60,  60,  60,  60,  46,  46,  46,  46,  /*   53 */
 60,  60,  60,  60,  60,  60,  46,  60,  /*   53 */
 46,  60,  60,  60,  60,  60,  60,  60,  /*   53 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   53 */
 60,  60,  60,  60,  60,  60,  46,  46,  /*   53 */
 46,  60,  60,  60,  60,  60,  60,  60,  /*   53 */
 46,  60,  46,  46,  46,  46,  46,  46,  /*   53 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   54 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   54 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   54 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   54 */
 76,  76,  76,  76,  76,  76,  76,  76,  /*   54 */
 76,  76,  76,  76,  76,  76,  76,  76,  /*   54 */
 76,  76,  76,  76,  76,  76,  76,  76,  /*   54 */
 76,  76,  76,  76,  76,  76,  76,  76,  /*   54 */
 76,  76,  76,  76,  76,  76,  46,  46,  /*   55 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   55 */
 16,  16,  16,  16,  16,  16,  16,  16,  /*   55 */
 16,  16,  16,  16,  16,  16,  16,  16,  /*   55 */
 16,  16,  16,  16,  16,  16,  16,  16,  /*   55 */
 16,  16,  16,  16,  16,  16,  16,  16,  /*   55 */
 16,  16,  16,  16,  16,  16,  16,  46,  /*   55 */
 46,  46,  46,   3,  46,  46,  46,  46,  /*   55 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   56 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   56 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   56 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   56 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   56 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   56 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   56 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   56 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   57 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   57 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   57 */
 40,  40,  46,  46,  46,  46,  46,  40,  /*   57 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   57 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   57 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   57 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   57 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   58 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   58 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   58 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   58 */
 40,  40,  40,  46,  46,  46,  46,  46,  /*   58 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   58 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   58 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   58 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   59 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   59 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   59 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   59 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   59 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   59 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   59 */
 40,  40,  46,  46,  46,  46,  46,  46,  /*   59 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   60 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   60 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   60 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   60 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   60 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   60 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   60 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   60 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   61 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   61 */
 23,  24,  23,  24,  23,  24,  16,  16,  /*   61 */
 16,  16,  16,  16,  46,  46,  46,  46,  /*   61 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   61 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   61 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   61 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   61 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   62 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   62 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   62 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   62 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   62 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   62 */
 23,  24,  23,  24,  23,  24,  23,  24,  /*   62 */
 23,  24,  46,  46,  46,  46,  46,  46,  /*   62 */
 86,  86,  86,  86,  86,  86,  86,  86,  /*   63 */
 87,  87,  87,  87,  87,  87,  87,  87,  /*   63 */
 86,  86,  86,  86,  86,  86,  46,  46,  /*   63 */
 87,  87,  87,  87,  87,  87,  46,  46,  /*   63 */
 86,  86,  86,  86,  86,  86,  86,  86,  /*   63 */
 87,  87,  87,  87,  87,  87,  87,  87,  /*   63 */
 86,  86,  86,  86,  86,  86,  86,  86,  /*   63 */
 87,  87,  87,  87,  87,  87,  87,  87,  /*   63 */
 86,  86,  86,  86,  86,  86,  46,  46,  /*   64 */
 87,  87,  87,  87,  87,  87,  46,  46,  /*   64 */
 16,  86,  16,  86,  16,  86,  16,  86,  /*   64 */
 46,  87,  46,  87,  46,  87,  46,  87,  /*   64 */
 86,  86,  86,  86,  86,  86,  86,  86,  /*   64 */
 87,  87,  87,  87,  87,  87,  87,  87,  /*   64 */
 88,  88,  89,  89,  89,  89,  90,  90,  /*   64 */
 91,  91,  92,  92,  93,  93,  46,  46,  /*   64 */
 86,  86,  86,  86,  86,  86,  86,  86,  /*   65 */
 87,  87,  87,  87,  87,  87,  87,  87,  /*   65 */
 86,  86,  86,  86,  86,  86,  86,  86,  /*   65 */
 87,  87,  87,  87,  87,  87,  87,  87,  /*   65 */
 86,  86,  86,  86,  86,  86,  86,  86,  /*   65 */
 87,  87,  87,  87,  87,  87,  87,  87,  /*   65 */
 86,  86,  16,  94,  16,  46,  16,  16,  /*   65 */
 87,  87,  95,  95,  96,  11,  38,  11,  /*   65 */
 11,  11,  16,  94,  16,  46,  16,  16,  /*   66 */
 97,  97,  97,  97,  96,  11,  11,  11,  /*   66 */
 86,  86,  16,  16,  46,  46,  16,  16,  /*   66 */
 87,  87,  98,  98,  46,  11,  11,  11,  /*   66 */
 86,  86,  16,  16,  16,  99,  16,  16,  /*   66 */
 87,  87, 100, 100, 101,  11,  11,  11,  /*   66 */
 46,  46,  16,  94,  16,  46,  16,  16,  /*   66 */
102, 102, 103, 103,  96,  11,  11,  46,  /*   66 */
  2,   2,   2,   2,   2,   2,   2,   2,  /*   67 */
  2,   2,   2,   2, 104, 104, 104, 104,  /*   67 */
  8,   8,   8,   8,   8,   8,   3,   3,  /*   67 */
  5,   6,   5,   5,   5,   6,   5,   5,  /*   67 */
  3,   3,   3,   3,   3,   3,   3,   3,  /*   67 */
105, 106, 104, 104, 104, 104, 104,  46,  /*   67 */
  3,   3,   3,   3,   3,   3,   3,   3,  /*   67 */
  3,   5,   6,   3,   3,   3,   3,  12,  /*   67 */
 12,   3,   3,   3,   7,   5,   6,  46,  /*   68 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   68 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   68 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   68 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   68 */
 46,  46, 104, 104, 104, 104, 104, 104,  /*   68 */
 17,  46,  46,  46,  17,  17,  17,  17,  /*   68 */
 17,  17,   7,   7,   7,   5,   6,  16,  /*   68 */
107, 107, 107, 107, 107, 107, 107, 107,  /*   69 */
107, 107,   7,   7,   7,   5,   6,  46,  /*   69 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   69 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   69 */
  4,   4,   4,   4,   4,   4,   4,   4,  /*   69 */
  4,   4,   4,   4,  46,  46,  46,  46,  /*   69 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   69 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   69 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   70 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   70 */
 60,  60,  60,  60,  60,  60,  60,  60,  /*   70 */
 60,  60,  60,  60,  60,  79,  79,  79,  /*   70 */
 79,  60,  46,  46,  46,  46,  46,  46,  /*   70 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   70 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   70 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   70 */
 15,  15,  38,  15,  15,  15,  15,  38,  /*   71 */
 15,  15,  16,  38,  38,  38,  16,  16,  /*   71 */
 38,  38,  38,  16,  15,  38,  15,  15,  /*   71 */
 38,  38,  38,  38,  38,  38,  15,  15,  /*   71 */
 15,  15,  15,  15,  38,  15,  38,  15,  /*   71 */
 38,  15,  38,  38,  38,  38,  16,  16,  /*   71 */
 38,  38,  15,  38,  16,  40,  40,  40,  /*   71 */
 40,  46,  46,  46,  46,  46,  46,  46,  /*   71 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   72 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   72 */
 46,  46,  46,  19,  19,  19,  19,  19,  /*   72 */
 19,  19,  19,  19,  19,  19,  19, 108,  /*   72 */
109, 109, 109, 109, 109, 109, 109, 109,  /*   72 */
109, 109, 109, 109, 110, 110, 110, 110,  /*   72 */
111, 111, 111, 111, 111, 111, 111, 111,  /*   72 */
111, 111, 111, 111, 112, 112, 112, 112,  /*   72 */
113, 113, 113,  46,  46,  46,  46,  46,  /*   73 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   73 */
  7,   7,   7,   7,   7,  15,  15,  15,  /*   73 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   73 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   73 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   73 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   73 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   73 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   74 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   74 */
 15,  15,   7,  15,   7,  15,  15,  15,  /*   74 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   74 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   74 */
 15,  15,  15,  46,  46,  46,  46,  46,  /*   74 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   74 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   74 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   75 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   75 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   75 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   75 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   75 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   75 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   75 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   75 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   76 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   76 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   76 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   76 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   76 */
  7,   7,   7,   7,   7,   7,   7,   7,  /*   76 */
  7,   7,  46,  46,  46,  46,  46,  46,  /*   76 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   76 */
 15,  46,  15,  15,  15,  15,  15,  15,  /*   77 */
  7,   7,   7,   7,  15,  15,  15,  15,  /*   77 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   77 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   77 */
  7,   7,  15,  15,  15,  15,  15,  15,  /*   77 */
 15,   5,   6,  15,  15,  15,  15,  15,  /*   77 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   77 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   77 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   78 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   78 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   78 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   78 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   78 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   78 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   78 */
 15,  15,  15,  46,  46,  46,  46,  46,  /*   78 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   79 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   79 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   79 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   79 */
 15,  15,  15,  15,  15,  46,  46,  46,  /*   79 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   79 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   79 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   79 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   80 */
 15,  15,  15,  46,  46,  46,  46,  46,  /*   80 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   80 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   80 */
114, 114, 114, 114, 114, 114, 114, 114,  /*   80 */
114, 114, 114, 114, 114, 114, 114, 114,  /*   80 */
114, 114, 114, 114,  82,  82,  82,  82,  /*   80 */
 82,  82,  82,  82,  82,  82,  82,  82,  /*   80 */
 82,  82,  82,  82,  82,  82,  82,  82,  /*   81 */
115, 115, 115, 115, 115, 115, 115, 115,  /*   81 */
115, 115, 115, 115, 115, 115, 115, 115,  /*   81 */
115, 115, 115, 115,  15,  15,  15,  15,  /*   81 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   81 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   81 */
 15,  15,  15,  15,  15,  15, 116, 116,  /*   81 */
116, 116, 116, 116, 116, 116, 116, 116,  /*   81 */
116, 116, 116, 116, 116, 116, 116, 116,  /*   82 */
116, 116, 116, 116, 116, 116, 116, 116,  /*   82 */
117, 117, 117, 117, 117, 117, 117, 117,  /*   82 */
117, 117, 117, 117, 117, 117, 117, 117,  /*   82 */
117, 117, 117, 117, 117, 117, 117, 117,  /*   82 */
117, 117, 118,  46,  46,  46,  46,  46,  /*   82 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   82 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   82 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   83 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   83 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   83 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   83 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   83 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   83 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   83 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   83 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   84 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   84 */
 15,  15,  15,  15,  15,  15,  46,  46,  /*   84 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   84 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   84 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   84 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   84 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   84 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   85 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   85 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   85 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   85 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   85 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   85 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   85 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   85 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   86 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   86 */
 15,  15,  15,  15,  46,  46,  46,  46,  /*   86 */
 46,  46,  15,  15,  15,  15,  15,  15,  /*   86 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   86 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   86 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   86 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   86 */
 46,  15,  15,  15,  15,  46,  15,  15,  /*   87 */
 15,  15,  46,  46,  15,  15,  15,  15,  /*   87 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   87 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   87 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   87 */
 46,  15,  15,  15,  15,  15,  15,  15,  /*   87 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   87 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   87 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   88 */
 15,  15,  15,  15,  46,  15,  46,  15,  /*   88 */
 15,  15,  15,  46,  46,  46,  15,  46,  /*   88 */
 15,  15,  15,  15,  15,  15,  15,  46,  /*   88 */
 46,  15,  15,  15,  15,  15,  15,  15,  /*   88 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   88 */
 46,  46,  46,  46,  46,  46, 119, 119,  /*   88 */
119, 119, 119, 119, 119, 119, 119, 119,  /*   88 */
114, 114, 114, 114, 114, 114, 114, 114,  /*   89 */
114, 114,  83,  83,  83,  83,  83,  83,  /*   89 */
 83,  83,  83,  83,  15,  46,  46,  46,  /*   89 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   89 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   89 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   89 */
 46,  15,  15,  15,  15,  15,  15,  15,  /*   89 */
 15,  15,  15,  15,  15,  15,  15,  46,  /*   89 */
  2,   3,   3,   3,  15,  59,   3, 120,  /*   90 */
  5,   6,   5,   6,   5,   6,   5,   6,  /*   90 */
  5,   6,  15,  15,   5,   6,   5,   6,  /*   90 */
  5,   6,   5,   6,   8,   5,   6,   5,  /*   90 */
 15, 121, 121, 121, 121, 121, 121, 121,  /*   90 */
121, 121,  60,  60,  60,  60,  60,  60,  /*   90 */
  8,  59,  59,  59,  59,  59,  15,  15,  /*   90 */
 46,  46,  46,  46,  46,  46,  46,  15,  /*   90 */
 46,  40,  40,  40,  40,  40,  40,  40,  /*   91 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   91 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   91 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   91 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   91 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   91 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   91 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   91 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   92 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   92 */
 40,  40,  40,  40,  40,  46,  46,  46,  /*   92 */
 46,  60,  60,  59,  59,  59,  59,  46,  /*   92 */
 46,  40,  40,  40,  40,  40,  40,  40,  /*   92 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   92 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   92 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   92 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   93 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   93 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   93 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   93 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   93 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   93 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   93 */
 40,  40,  40,   3,  59,  59,  59,  46,  /*   93 */
 46,  46,  46,  46,  46,  40,  40,  40,  /*   94 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   94 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   94 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   94 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   94 */
 40,  40,  40,  40,  40,  46,  46,  46,  /*   94 */
 46,  40,  40,  40,  40,  40,  40,  40,  /*   94 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   94 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*   95 */
 40,  40,  40,  40,  40,  40,  40,  46,  /*   95 */
 15,  15,  85,  85,  85,  85,  15,  15,  /*   95 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   95 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   95 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   95 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   95 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   95 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   96 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   96 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   96 */
 15,  15,  15,  15,  15,  46,  46,  46,  /*   96 */
 85,  85,  85,  85,  85,  85,  85,  85,  /*   96 */
 85,  85,  15,  15,  15,  15,  15,  15,  /*   96 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   96 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   96 */
 15,  15,  15,  15,  46,  46,  46,  46,  /*   97 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   97 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   97 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   97 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   97 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   97 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   97 */
 15,  15,  15,  15,  46,  46,  46,  15,  /*   97 */
114, 114, 114, 114, 114, 114, 114, 114,  /*   98 */
114, 114,  15,  15,  15,  15,  15,  15,  /*   98 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   98 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   98 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   98 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   98 */
 15,  46,  46,  46,  46,  46,  46,  46,  /*   98 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*   98 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   99 */
 15,  15,  15,  15,  46,  46,  46,  46,  /*   99 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   99 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   99 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   99 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   99 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*   99 */
 15,  15,  15,  15,  15,  15,  15,  46,  /*   99 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  100 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  100 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  100 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  100 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  100 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  100 */
 15,  15,  15,  15,  15,  15,  15,  46,  /*  100 */
 46,  46,  46,  15,  15,  15,  15,  15,  /*  100 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  101 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  101 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  101 */
 15,  15,  15,  15,  15,  15,  46,  46,  /*  101 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  101 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  101 */
 15,  15,  15,  15,  15,  15,  15,  15,  /*  101 */
 15,  15,  15,  15,  15,  15,  15,  46,  /*  101 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  102 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  102 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  102 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  102 */
 40,  40,  40,  40,  40,  40,  46,  46,  /*  102 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  102 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  102 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  102 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  103 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  103 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  103 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  103 */
 40,  40,  40,  40,  46,  46,  46,  46,  /*  103 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  103 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  103 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  103 */
122, 122, 122, 122, 122, 122, 122, 122,  /*  104 */
122, 122, 122, 122, 122, 122, 122, 122,  /*  104 */
122, 122, 122, 122, 122, 122, 122, 122,  /*  104 */
122, 122, 122, 122, 122, 122, 122, 122,  /*  104 */
122, 122, 122, 122, 122, 122, 122, 122,  /*  104 */
122, 122, 122, 122, 122, 122, 122, 122,  /*  104 */
122, 122, 122, 122, 122, 122, 122, 122,  /*  104 */
122, 122, 122, 122, 122, 122, 122, 122,  /*  104 */
123, 123, 123, 123, 123, 123, 123, 123,  /*  105 */
123, 123, 123, 123, 123, 123, 123, 123,  /*  105 */
123, 123, 123, 123, 123, 123, 123, 123,  /*  105 */
123, 123, 123, 123, 123, 123, 123, 123,  /*  105 */
123, 123, 123, 123, 123, 123, 123, 123,  /*  105 */
123, 123, 123, 123, 123, 123, 123, 123,  /*  105 */
123, 123, 123, 123, 123, 123, 123, 123,  /*  105 */
123, 123, 123, 123, 123, 123, 123, 123,  /*  105 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  106 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  106 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  106 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  106 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  106 */
 40,  40,  40,  40,  40,  40,  46,  46,  /*  106 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  106 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  106 */
 16,  16,  16,  16,  16,  16,  16,  46,  /*  107 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  107 */
 46,  46,  46,  16,  16,  16,  16,  16,  /*  107 */
 46,  46,  46,  46,  46,  46,  60,  40,  /*  107 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  107 */
 40,   7,  40,  40,  40,  40,  40,  40,  /*  107 */
 40,  40,  40,  40,  40,  40,  40,  46,  /*  107 */
 40,  40,  40,  40,  40,  46,  40,  46,  /*  107 */
 40,  40,  46,  40,  40,  46,  40,  40,  /*  108 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  108 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  108 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  108 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  108 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  108 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  108 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  108 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  109 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  109 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  109 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  109 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  109 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  109 */
 40,  40,  46,  46,  46,  46,  46,  46,  /*  109 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  109 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  110 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  110 */
 46,  46,  46,  40,  40,  40,  40,  40,  /*  110 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  110 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  110 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  110 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  110 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  110 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  111 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  111 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  111 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  111 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  111 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  111 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  111 */
 40,  40,  40,  40,  40,  40,   5,   6,  /*  111 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  112 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  112 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  112 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  112 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  112 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  112 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  112 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  112 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  113 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  113 */
 46,  46,  40,  40,  40,  40,  40,  40,  /*  113 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  113 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  113 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  113 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  113 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  113 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  114 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  114 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  114 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  114 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  114 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  114 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  114 */
 40,  40,  40,  40,  46,  46,  46,  46,  /*  114 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  115 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  115 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  115 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  115 */
 60,  60,  60,  60,  46,  46,  46,  46,  /*  115 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  115 */
  3,   8,   8,  12,  12,   5,   6,   5,  /*  115 */
  6,   5,   6,   5,   6,   5,   6,   5,  /*  115 */
  6,   5,   6,   5,   6,  46,  46,  46,  /*  116 */
 46,   3,   3,   3,   3,  12,  12,  12,  /*  116 */
  3,   3,   3,  46,   3,   3,   3,   3,  /*  116 */
  8,   5,   6,   5,   6,   5,   6,   3,  /*  116 */
  3,   3,   7,   8,   7,   7,   7,  46,  /*  116 */
  3,   4,   3,   3,  46,  46,  46,  46,  /*  116 */
 40,  40,  40,  46,  40,  46,  40,  40,  /*  116 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  116 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  117 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  117 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  117 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  117 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  117 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  117 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  117 */
 40,  40,  40,  40,  40,  46,  46, 104,  /*  117 */
 46,   3,   3,   3,   4,   3,   3,   3,  /*  118 */
  5,   6,   3,   7,   3,   8,   3,   3,  /*  118 */
  9,   9,   9,   9,   9,   9,   9,   9,  /*  118 */
  9,   9,   3,   3,   7,   7,   7,   3,  /*  118 */
  3,  10,  10,  10,  10,  10,  10,  10,  /*  118 */
 10,  10,  10,  10,  10,  10,  10,  10,  /*  118 */
 10,  10,  10,  10,  10,  10,  10,  10,  /*  118 */
 10,  10,  10,   5,   3,   6,  11,  12,  /*  118 */
 11,  13,  13,  13,  13,  13,  13,  13,  /*  119 */
 13,  13,  13,  13,  13,  13,  13,  13,  /*  119 */
 13,  13,  13,  13,  13,  13,  13,  13,  /*  119 */
 13,  13,  13,   5,   7,   6,   7,  46,  /*  119 */
 46,   3,   5,   6,   3,   3,  40,  40,  /*  119 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  119 */
 59,  40,  40,  40,  40,  40,  40,  40,  /*  119 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  119 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  120 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  120 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  120 */
 40,  40,  40,  40,  40,  40,  59,  59,  /*  120 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  120 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  120 */
 40,  40,  40,  40,  40,  40,  40,  40,  /*  120 */
 40,  40,  40,  40,  40,  40,  40,  46,  /*  120 */
 46,  46,  40,  40,  40,  40,  40,  40,  /*  121 */
 46,  46,  40,  40,  40,  40,  40,  40,  /*  121 */
 46,  46,  40,  40,  40,  40,  40,  40,  /*  121 */
 46,  46,  40,  40,  40,  46,  46,  46,  /*  121 */
  4,   4,   7,  11,  15,   4,   4,  46,  /*  121 */
  7,   7,   7,   7,   7,  15,  15,  46,  /*  121 */
 46,  46,  46,  46,  46,  46,  46,  46,  /*  121 */
 46,  46,  46,  46,  46,  15,  46,  46   /*  121 */
};

/* The A table has 124 entries for a total of 496 bytes. */

const uint32 js_A[] = {
0x0001000F,  /*    0   Cc, ignorable */
0x0004000F,  /*    1   Cc, whitespace */
0x0004000C,  /*    2   Zs, whitespace */
0x00000018,  /*    3   Po */
0x0006001A,  /*    4   Sc, currency */
0x00000015,  /*    5   Ps */
0x00000016,  /*    6   Pe */
0x00000019,  /*    7   Sm */
0x00000014,  /*    8   Pd */
0x00036009,  /*    9   Nd, identifier part, decimal 16 */
0x0827FE01,  /*   10   Lu, hasLower (add 32), identifier start, supradecimal 31 */
0x0000001B,  /*   11   Sk */
0x00050017,  /*   12   Pc, underscore */
0x0817FE02,  /*   13   Ll, hasUpper (subtract 32), identifier start, supradecimal 31 */
0x0000000C,  /*   14   Zs */
0x0000001C,  /*   15   So */
0x00070002,  /*   16   Ll, identifier start */
0x0000600B,  /*   17   No, decimal 16 */
0x0000500B,  /*   18   No, decimal 8 */
0x0000800B,  /*   19   No, strange */
0x08270001,  /*   20   Lu, hasLower (add 32), identifier start */
0x08170002,  /*   21   Ll, hasUpper (subtract 32), identifier start */
0xE1D70002,  /*   22   Ll, hasUpper (subtract -121), identifier start */
0x00670001,  /*   23   Lu, hasLower (add 1), identifier start */
0x00570002,  /*   24   Ll, hasUpper (subtract 1), identifier start */
0xCE670001,  /*   25   Lu, hasLower (add -199), identifier start */
0x3A170002,  /*   26   Ll, hasUpper (subtract 232), identifier start */
0xE1E70001,  /*   27   Lu, hasLower (add -121), identifier start */
0x4B170002,  /*   28   Ll, hasUpper (subtract 300), identifier start */
0x34A70001,  /*   29   Lu, hasLower (add 210), identifier start */
0x33A70001,  /*   30   Lu, hasLower (add 206), identifier start */
0x33670001,  /*   31   Lu, hasLower (add 205), identifier start */
0x32A70001,  /*   32   Lu, hasLower (add 202), identifier start */
0x32E70001,  /*   33   Lu, hasLower (add 203), identifier start */
0x33E70001,  /*   34   Lu, hasLower (add 207), identifier start */
0x34E70001,  /*   35   Lu, hasLower (add 211), identifier start */
0x34670001,  /*   36   Lu, hasLower (add 209), identifier start */
0x35670001,  /*   37   Lu, hasLower (add 213), identifier start */
0x00070001,  /*   38   Lu, identifier start */
0x36A70001,  /*   39   Lu, hasLower (add 218), identifier start */
0x00070005,  /*   40   Lo, identifier start */
0x36670001,  /*   41   Lu, hasLower (add 217), identifier start */
0x36E70001,  /*   42   Lu, hasLower (add 219), identifier start */
0x00AF0001,  /*   43   Lu, hasLower (add 2), hasTitle, identifier start */
0x007F0003,  /*   44   Lt, hasUpper (subtract 1), hasLower (add 1), hasTitle, identifier start */
0x009F0002,  /*   45   Ll, hasUpper (subtract 2), hasTitle, identifier start */
0x00000000,  /*   46   unassigned */
0x34970002,  /*   47   Ll, hasUpper (subtract 210), identifier start */
0x33970002,  /*   48   Ll, hasUpper (subtract 206), identifier start */
0x33570002,  /*   49   Ll, hasUpper (subtract 205), identifier start */
0x32970002,  /*   50   Ll, hasUpper (subtract 202), identifier start */
0x32D70002,  /*   51   Ll, hasUpper (subtract 203), identifier start */
0x33D70002,  /*   52   Ll, hasUpper (subtract 207), identifier start */
0x34570002,  /*   53   Ll, hasUpper (subtract 209), identifier start */
0x34D70002,  /*   54   Ll, hasUpper (subtract 211), identifier start */
0x35570002,  /*   55   Ll, hasUpper (subtract 213), identifier start */
0x36970002,  /*   56   Ll, hasUpper (subtract 218), identifier start */
0x36570002,  /*   57   Ll, hasUpper (subtract 217), identifier start */
0x36D70002,  /*   58   Ll, hasUpper (subtract 219), identifier start */
0x00070004,  /*   59   Lm, identifier start */
0x00030006,  /*   60   Mn, identifier part */
0x09A70001,  /*   61   Lu, hasLower (add 38), identifier start */
0x09670001,  /*   62   Lu, hasLower (add 37), identifier start */
0x10270001,  /*   63   Lu, hasLower (add 64), identifier start */
0x0FE70001,  /*   64   Lu, hasLower (add 63), identifier start */
0x09970002,  /*   65   Ll, hasUpper (subtract 38), identifier start */
0x09570002,  /*   66   Ll, hasUpper (subtract 37), identifier start */
0x10170002,  /*   67   Ll, hasUpper (subtract 64), identifier start */
0x0FD70002,  /*   68   Ll, hasUpper (subtract 63), identifier start */
0x0F970002,  /*   69   Ll, hasUpper (subtract 62), identifier start */
0x0E570002,  /*   70   Ll, hasUpper (subtract 57), identifier start */
0x0BD70002,  /*   71   Ll, hasUpper (subtract 47), identifier start */
0x0D970002,  /*   72   Ll, hasUpper (subtract 54), identifier start */
0x15970002,  /*   73   Ll, hasUpper (subtract 86), identifier start */
0x14170002,  /*   74   Ll, hasUpper (subtract 80), identifier start */
0x14270001,  /*   75   Lu, hasLower (add 80), identifier start */
0x0C270001,  /*   76   Lu, hasLower (add 48), identifier start */
0x0C170002,  /*   77   Ll, hasUpper (subtract 48), identifier start */
0x00034009,  /*   78   Nd, identifier part, decimal 0 */
0x00000007,  /*   79   Me */
0x00030008,  /*   80   Mc, identifier part */
0x00037409,  /*   81   Nd, identifier part, decimal 26 */
0x00005A0B,  /*   82   No, decimal 13 */
0x00006E0B,  /*   83   No, decimal 23 */
0x0000740B,  /*   84   No, decimal 26 */
0x0000000B,  /*   85   No */
0xFE170002,  /*   86   Ll, hasUpper (subtract -8), identifier start */
0xFE270001,  /*   87   Lu, hasLower (add -8), identifier start */
0xED970002,  /*   88   Ll, hasUpper (subtract -74), identifier start */
0xEA970002,  /*   89   Ll, hasUpper (subtract -86), identifier start */
0xE7170002,  /*   90   Ll, hasUpper (subtract -100), identifier start */
0xE0170002,  /*   91   Ll, hasUpper (subtract -128), identifier start */
0xE4170002,  /*   92   Ll, hasUpper (subtract -112), identifier start */
0xE0970002,  /*   93   Ll, hasUpper (subtract -126), identifier start */
0xFDD70002,  /*   94   Ll, hasUpper (subtract -9), identifier start */
0xEDA70001,  /*   95   Lu, hasLower (add -74), identifier start */
0xFDE70001,  /*   96   Lu, hasLower (add -9), identifier start */
0xEAA70001,  /*   97   Lu, hasLower (add -86), identifier start */
0xE7270001,  /*   98   Lu, hasLower (add -100), identifier start */
0xFE570002,  /*   99   Ll, hasUpper (subtract -7), identifier start */
0xE4270001,  /*  100   Lu, hasLower (add -112), identifier start */
0xFE670001,  /*  101   Lu, hasLower (add -7), identifier start */
0xE0270001,  /*  102   Lu, hasLower (add -128), identifier start */
0xE0A70001,  /*  103   Lu, hasLower (add -126), identifier start */
0x00010010,  /*  104   Cf, ignorable */
0x0004000D,  /*  105   Zl, whitespace */
0x0004000E,  /*  106   Zp, whitespace */
0x0000400B,  /*  107   No, decimal 0 */
0x0000440B,  /*  108   No, decimal 2 */
0x0427420A,  /*  109   Nl, hasLower (add 16), identifier start, decimal 1 */
0x0427800A,  /*  110   Nl, hasLower (add 16), identifier start, strange */
0x0417620A,  /*  111   Nl, hasUpper (subtract 16), identifier start, decimal 17 */
0x0417800A,  /*  112   Nl, hasUpper (subtract 16), identifier start, strange */
0x0007800A,  /*  113   Nl, identifier start, strange */
0x0000420B,  /*  114   No, decimal 1 */
0x0000720B,  /*  115   No, decimal 25 */
0x06A0001C,  /*  116   So, hasLower (add 26) */
0x0690001C,  /*  117   So, hasUpper (subtract 26) */
0x00006C0B,  /*  118   No, decimal 22 */
0x0000560B,  /*  119   No, decimal 11 */
0x0007720A,  /*  120   Nl, identifier start, decimal 25 */
0x0007400A,  /*  121   Nl, identifier start, decimal 0 */
0x00000013,  /*  122   Cs */
0x00000012   /*  123   Co */
};

#ifndef __GNUC__
jschar
js_ToUpper(jschar c)
{
    uint32 v = JS_CCODE(c);
    return (v & 0x00100000) ? c - ((int32)v >> 22) : c;
}

jschar
js_ToLower(jschar c)
{
    uint32 v = JS_CCODE(c);
    return (v & 0x00200000) ? c + ((int32)v >> 22) : c;
}
#endif /* !__GNUC__ */
