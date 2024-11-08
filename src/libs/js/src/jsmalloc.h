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

#ifndef jsmalloc_h___
#define jsmalloc_h___
/*
 * JS malloc functions.
 */

#define JSMALLOC(n, els)              UTDMALLOC(n, els)
#define JSCALLOC(n, els)              UTDCALLOC(n, els)
#define JSREALLOC(ar,n,els)           UTDREALLOC(ar,n,els)
#define JSFREE(els)                   UTDFREE(els)

#include <utd/utdconfig.h>
#include <utd/base.h>
#include <utd/okmalloc.h>

#endif /* jsmalloc_h___ */
