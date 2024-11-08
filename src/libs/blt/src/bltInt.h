
/*
 * bltInt.h --
 *
 * Copyright 1993-1998 Lucent Technologies, Inc.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose and without fee is hereby
 * granted, provided that the above copyright notice appear in all
 * copies and that both that the copyright notice and warranty
 * disclaimer appear in supporting documentation, and that the names
 * of Lucent Technologies any of their entities not be used in
 * advertising or publicity pertaining to distribution of the software
 * without specific, written prior permission.
 *
 * Lucent Technologies disclaims all warranties with regard to this
 * software, including all implied warranties of merchantability and
 * fitness.  In no event shall Lucent Technologies be liable for any
 * special, indirect or consequential damages or any damages
 * whatsoever resulting from loss of use, data or profits, whether in
 * an action of contract, negligence or other tortuous action, arising
 * out of or in connection with the use or performance of this
 * software.
 */

#ifndef _BLT_INT_H
#define _BLT_INT_H

#include <tcl/tcl.h>
#define USE_COMPOSITELESS_PHOTO_PUT_BLOCK 

#define _VERSION(a,b,c)	    (((a) << 16) + ((b) << 8) + (c))
#define TCL_VERSION_NUMBER _VERSION(TCL_MAJOR_VERSION, TCL_MINOR_VERSION, TCL_RELEASE_SERIAL)


#include <stdio.h>
#include <assert.h>

#include "config.h"

#if defined(WIN32) && !defined(__GNUC__)
#include "bltWinConfig.h"
#else 
/* #include "bltConfig.h" */
#endif

#ifdef WIN32 
#ifndef EXPORT
#if defined(_MSC_VER) || defined(__BORLANDC__)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif /* _MSC_VER || __BORLANDC__ */
#endif /* EXPORT */

/* Misc. definitions */
#define	NO_CUTBUFFER	1
#define NO_TILESCROLLBAR	1
#define NO_DND		1

#ifndef __GNUC__
#ifdef O_NONBLOCK
#define O_NONBLOCK	1
#endif
#endif /* __GNUC__ */
#endif /* WIN32 */

#include "blt.h"
/* #include "bltNsUtil.h" */

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif /* HAVE_STDLIB_H */

#ifdef HAVE_STRING_H
#include <string.h>
#endif /* HAVE_STRING_H */

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif /* HAVE_ERRNO_H */

#ifdef HAVE_CTYPE_H
#include <ctype.h>
#endif /* HAVE_CTYPE_H */

#ifdef HAVE_MEMORY_H
#include <memory.h>
#endif /* HAVE_MEMORY_H */

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif /* HAVE_UNISTD_H */

#ifdef HAVE_LIMITS_H
#include <limits.h>
#endif

/* #include "bltMath.h" */

#undef INLINE
#ifdef __GNUC__
#define INLINE inline
#else
#define INLINE
#endif
#undef EXPORT
#define EXPORT

#undef VARARGS
#ifdef __cplusplus
#define ANYARGS (...)
#define VARARGS(first)  (first, ...)
#define VARARGS2(first, second)  (first, second, ...)
#else
#define ANYARGS ()
#define VARARGS(first) ()
#define VARARGS2(first, second) ()
#endif /* __cplusplus */

#undef MIN
#define MIN(a,b)	(((a)<(b))?(a):(b))

#undef MAX
#define MAX(a,b)	(((a)>(b))?(a):(b))

#undef MIN3
#define MIN3(a,b,c)	(((a)<(b))?(((a)<(c))?(a):(c)):(((b)<(c))?(b):(c)))

#undef MAX3
#define MAX3(a,b,c)	(((a)>(b))?(((a)>(c))?(a):(c)):(((b)>(c))?(b):(c)))

#define TRUE 	1
#define FALSE 	0

/*
 * The macro below is used to modify a "char" value (e.g. by casting
 * it to an unsigned character) so that it can be used safely with
 * macros such as isspace.
 */
#define UCHAR(c) ((unsigned char) (c))

#undef panic
#define panic(mesg)	Blt_Panic("%s:%d %s", __FILE__, __LINE__, (mesg))

/*
 * Since the Tcl/Tk distribution doesn't perform any asserts, dynamic
 * loading can fail to find the __assert function.  As a workaround,
 * we'll include our own.
 */
#undef	assert
#ifdef	NDEBUG
#define	assert(EX) ((void)0)
#else
extern void Blt_Assert _ANSI_ARGS_((char *expr, char *file, int line));
#ifdef __STDC__
#define	assert(EX) (void)((EX) || (Blt_Assert(#EX, __FILE__, __LINE__), 0))
#else
#define	assert(EX) (void)((EX) || (Blt_Assert("EX", __FILE__, __LINE__), 0))
#endif /* __STDC__ */

#endif /* NDEBUG */

#if (TCL_MAJOR_VERSION >= 8)
extern Tcl_Obj *bltEmptyStringObjPtr;
#endif /* TCL_MAJOR_VERSION >= 8 */

/*
 * ----------------------------------------------------------------------
 *
 * Blt_CmdSpec --
 *
 * ----------------------------------------------------------------------
 */
typedef struct {
    char *name;			/* Name of command */
    Tcl_CmdProc *cmdProc;
    Tcl_CmdDeleteProc *cmdDeleteProc;
    ClientData clientData;
} Blt_CmdSpec;

#if (TCL_MAJOR_VERSION >= 8)
/*
 * ----------------------------------------------------------------------
 *
 * Blt_CmdSpec --
 *
 * ----------------------------------------------------------------------
 */
typedef struct {
    char *name;			/* Name of command */
    Tcl_ObjCmdProc *cmdProc;
    Tcl_CmdDeleteProc *cmdDeleteProc;
    ClientData clientData;
} Blt_ObjCmdSpec;

#endif /* TCL_MAJOR_VERSION >= 8 */

/*
 * ----------------------------------------------------------------------
 *
 * Blt_Op --
 *
 * 	Generic function prototype of CmdOptions.
 *
 * ----------------------------------------------------------------------
 */
typedef int (*Blt_Op)(void) ;

/*
 * ----------------------------------------------------------------------
 *
 * Blt_OpSpec --
 *
 * 	Structure to specify a set of operations for a Tcl command.
 *      This is passed to the Blt_GetOp procedure to look
 *      for a function pointer associated with the operation name.
 *
 * ----------------------------------------------------------------------
 */
typedef struct {
    char *name;			/* Name of operation */
    int minChars;		/* Minimum # characters to disambiguate */
    Blt_Op proc;
    int minArgs;		/* Minimum # args required */
    int maxArgs;		/* Maximum # args required */
    char *usage;		/* Usage message */

} Blt_OpSpec;

typedef enum {
    BLT_OP_ARG0,		/* Op is the first argument. */
    BLT_OP_ARG1,		/* Op is the second argument. */
    BLT_OP_ARG2,		/* Op is the third argument. */
    BLT_OP_ARG3,		/* Op is the fourth argument. */
    BLT_OP_ARG4			/* Op is the fifth argument. */

} Blt_OpIndex;

#define BLT_OP_LINEAR_SEARCH	1
#define BLT_OP_BINARY_SEARCH	0

extern Blt_Op Blt_GetOp _ANSI_ARGS_((Tcl_Interp *interp, int nSpecs, 
	Blt_OpSpec *specArr, int operPos, int argc, char **argv, int flags));

#if (TCL_VERSION_NUMBER >= _VERSION(8,0,0)) 
extern Blt_Op Blt_GetOpFromObj _ANSI_ARGS_((Tcl_Interp *interp,
	int nSpecs, Blt_OpSpec *specArr, int operPos, int objc, 
	Tcl_Obj *CONST *objv, int flags));
#endif

/*
 * ----------------------------------------------------------------------
 *
 *	Assume we need to declare free if there's no stdlib.h or malloc.h
 *
 * ----------------------------------------------------------------------
 */
#if !defined(HAVE_STDLIB_H) && !defined(HAVE_MALLOC_H)
extern void free _ANSI_ARGS_((void *));
#endif

#define free(x)		abc123(x)

EXTERN void Blt_Panic _ANSI_ARGS_(TCL_VARARGS(char *, args));


/* ---------------------------------------------------------------- */
#define STD_ACTIVE_BG_MONO	RGB_BLACK
#define STD_ACTIVE_FOREGROUND	RGB_BLACK
#define STD_ACTIVE_FG_MONO	RGB_WHITE
#define STD_BORDERWIDTH 	"2"
#define STD_FONT		"*-Helvetica-Medium-R-Normal-*-12-120-*"
#define STD_FONT_HUGE		"*-Helvetica-Medium-R-Normal-*-18-180-*"
#define STD_FONT_LARGE		"*-Helvetica-Medium-R-Normal-*-14-140-*"
#define STD_FONT_SMALL		"*-Helvetica-Medium-R-Normal-*-10-100-*"
#define STD_INDICATOR_COLOR	RGB_MAROON
#define STD_NORMAL_BG_MONO	RGB_WHITE
#define STD_NORMAL_FOREGROUND	RGB_BLACK
#define STD_NORMAL_FG_MONO	RGB_BLACK
#define STD_SELECT_BG_MONO	RGB_BLACK
#define STD_SELECT_BORDERWIDTH	"2"
#define STD_SELECT_FOREGROUND	RGB_BLACK
#define STD_SELECT_FG_MONO	RGB_WHITE
#define STD_SHADOW_COLOR	RGB_GREY64
#define STD_SHADOW_MONO		RGB_BLACK

#define LineWidth(w)	(((w) > 1) ? (w) : 0)

#ifdef TCL_UTF_MAX
#define HAVE_UTF	1
extern FILE *Blt_OpenUtfFile _ANSI_ARGS_((char *fileName, char *mode));
#define fopen(f,m)	Blt_OpenUtfFile((f),(m));
#else
#define HAVE_UTF	0
#endif /* TCL_UTF_MAX */

typedef char *DestroyData;


#ifndef TK_RELIEF_SOLID
#define TK_RELIEF_SOLID		TK_RELIEF_FLAT
#endif

/*
 * Tcl/Tk Backward compatibility section.
 */
#if (TCL_MAJOR_VERSION > 7)

#define NO_FLAGS			0
#define Blt_FindPhoto(interp, name)	Tk_FindPhoto(interp, name)

#else

#define Tcl_GetStringResult(interp)	((interp)->result)
#define Blt_FindPhoto(interp, name)	Tk_FindPhoto(name)

#define Tcl_DeleteCommandFromToken(interp, token) \
	Tcl_DeleteCommand(interp, Tcl_GetCommandName(interp, token))

/*
 *--------------------------------------------------------------
 *
 * The definitions below provide foreward compatibility for
 * functions and types related to event handling that used to
 * be in Tk but have moved to Tcl.
 *
 *--------------------------------------------------------------
 */

#define Tcl_IdleProc		Tk_IdleProc
#define Tcl_FileProc		Tk_FileProc
#define Tcl_TimerProc		Tk_TimerProc
#define Tcl_TimerToken		Tk_TimerToken

#define Tcl_BackgroundError	Tk_BackgroundError
#define Tcl_CancelIdleCall	Tk_CancelIdleCall

#define Tcl_CreateTimerHandler	Tk_CreateTimerHandler
#define Tcl_DeleteTimerHandler	Tk_DeleteTimerHandler
#define Tcl_DoOneEvent		Tk_DoOneEvent
#define Tcl_DoWhenIdle		Tk_DoWhenIdle
#define Tcl_Sleep		Tk_Sleep

/* Additional stuff that has moved to Tcl: */

#define Tcl_AfterCmd		Tk_AfterCmd
#define Tcl_EventuallyFree	Tk_EventuallyFree
#define Tcl_FreeProc		Tk_FreeProc
#define Tcl_Preserve		Tk_Preserve
#define Tcl_Release		Tk_Release

#endif /* TCL_MAJOR_VERSION > 7 */

typedef int (QSortCompareProc) _ANSI_ARGS_((const void *, const void *));



extern char *Blt_Itoa(INT value,char *buffer) ;
extern char *Blt_Utoa _ANSI_ARGS_((unsigned int value));
extern char *Blt_Dtoa _ANSI_ARGS_((Tcl_Interp *interp, double value));

#if (TCL_VERSION_NUMBER >= _VERSION(8,0,0)) 
extern Tcl_Command Blt_InitObjCmd _ANSI_ARGS_((Tcl_Interp *interp,
	char *namespace, Blt_ObjCmdSpec *specPtr));
#if (TCL_VERSION_NUMBER < _VERSION(8,1,0))
extern char *Tcl_GetString _ANSI_ARGS_((Tcl_Obj *objPtr));
extern int Tcl_EvalObjv _ANSI_ARGS_((Tcl_Interp *interp, int objc, 
	Tcl_Obj **objv, int flags));
extern int Tcl_WriteObj _ANSI_ARGS_((Tcl_Channel channel, Tcl_Obj *objPtr));
extern char *Tcl_SetVar2Ex _ANSI_ARGS_((Tcl_Interp *interp, char *part1, 
	char *part2, Tcl_Obj *objPtr, int flags));
extern Tcl_Obj *Tcl_GetVar2Ex _ANSI_ARGS_((Tcl_Interp *interp, char *part1, 
	char *part2, int flags));
#endif /* TCL_VERSION_NUMBER < 8.2.0 */
#endif /* TCL_VERSION_NUMBER >= 8.0.0 */


extern int Blt_InitCmds _ANSI_ARGS_((Tcl_Interp *interp, char *namespace,
	Blt_CmdSpec *specPtr, int nCmds));

#define Blt_SetBooleanResult(i, b) \
	Tcl_SetResult((i), (b) ? "1" : "0", TCL_STATIC)

/*
 * Define this if you want to be able to tile to the main window "."
 * This will cause a conflict with Tk if you try to compile and link
 * statically.
 */
#undef TILE_MAINWINDOW

#ifdef WIN32
#if (TCL_MAJOR_VERSION == 8)  && (TCL_MINOR_VERSION == 0)
#else
#define NO_DDE		1
#endif
#else 
#define NO_DDE		1
#define NO_PRINTER	1
#endif /* WIN32 */

#if (TCL_MAJOR_VERSION == 7) 
#define NO_TREE		1
#define NO_ARRAY	1
#define NO_TREEVIEW	1
#endif

/* #define NO_TED */

#ifndef NO_BEEP
extern Tcl_AppInitProc Blt_BeepInit;
#endif
#ifndef NO_BGEXEC
extern Tcl_AppInitProc Blt_BgexecInit;
#endif
#ifndef NO_BITMAP
extern Tcl_AppInitProc Blt_BitmapInit;
#endif
#ifndef NO_BUSY
extern Tcl_AppInitProc Blt_BusyInit;
#endif
#ifndef NO_CONTAINER
extern Tcl_AppInitProc Blt_ContainerInit;
#endif
#ifndef NO_CRC32
extern Tcl_AppInitProc Blt_Crc32Init;
#endif
#ifndef NO_CUTBUFFER
extern Tcl_AppInitProc Blt_CutbufferInit;
#endif
#ifndef NO_DEBUG
extern Tcl_AppInitProc Blt_DebugInit;
#endif
#ifndef NO_DRAGDROP
extern Tcl_AppInitProc Blt_DragDropInit;
#endif
#ifndef NO_DND
extern Tcl_AppInitProc Blt_DndInit;
#endif
#ifndef NO_GRAPH
extern Tcl_AppInitProc Blt_GraphInit;
#endif
#ifndef NO_HIERBOX
extern Tcl_AppInitProc Blt_HierboxInit;
#endif
#ifndef NO_HIERTABLE
extern Tcl_AppInitProc Blt_HiertableInit;
#endif
#ifndef NO_HTEXT
extern Tcl_AppInitProc Blt_HtextInit;
#endif
#ifdef WIN32
#ifndef NO_PRINTER
extern Tcl_AppInitProc Blt_PrinterInit;
#endif
#endif
#ifndef NO_TABLE
extern Tcl_AppInitProc Blt_TableInit;
#endif
#ifndef NO_VECTOR
extern Tcl_AppInitProc Blt_VectorInit;
#endif
#ifndef NO_WINOP
extern Tcl_AppInitProc Blt_WinopInit;
#endif
#ifndef NO_WATCH
extern Tcl_AppInitProc Blt_WatchInit;
#endif
#ifndef NO_SPLINE
extern Tcl_AppInitProc Blt_SplineInit;
#endif
#ifndef NO_TABSET
extern Tcl_AppInitProc Blt_TabsetInit;
#endif
#ifndef NO_TABNOTEBOOK
extern Tcl_AppInitProc Blt_TabnotebookInit;
#endif
#ifndef NO_TREE
extern Tcl_AppInitProc Blt_TreeInit;
#endif
#ifndef NO_TREEVIEW
extern Tcl_AppInitProc Blt_TreeViewInit;
#endif
#ifndef NO_TILEFRAME
extern Tcl_AppInitProc Blt_FrameInit;
#endif
#ifndef NO_TILEBUTTON
extern Tcl_AppInitProc Blt_ButtonInit;
#endif
#ifndef NO_TILESCROLLBAR
extern Tcl_AppInitProc Blt_ScrollbarInit;
#endif

#if (BLT_MAJOR_VERSION == 3)
#ifndef NO_MOUNTAIN
extern Tcl_AppInitProc Blt_MountainInit;
#endif
#endif
#ifndef NO_TED
extern Tcl_AppInitProc Blt_TedInit;
#endif

#ifndef NO_DDE
extern Tcl_AppInitProc Blt_DdeInit;
#endif

typedef void *(Blt_MallocProc) _ANSI_ARGS_((size_t size));
typedef void *(Blt_CallocProc) _ANSI_ARGS_((int nElem, size_t size));
typedef void *(Blt_ReallocProc) _ANSI_ARGS_((void *ptr, size_t size));
typedef void (Blt_FreeProc) _ANSI_ARGS_((void *ptr));

EXTERN Blt_MallocProc *Blt_MallocProcPtr;
EXTERN Blt_FreeProc *Blt_FreeProcPtr;
EXTERN Blt_ReallocProc *Blt_ReallocProcPtr;

#define Blt_Malloc(size)	(*Blt_MallocProcPtr)(size)
#define Blt_Free		(*Blt_FreeProcPtr)
#define Blt_Realloc(ptr, size)  (*Blt_ReallocProcPtr)(ptr, size)

EXTERN char *Blt_Strdup _ANSI_ARGS_((CONST char *ptr));
EXTERN void *Blt_Calloc _ANSI_ARGS_((unsigned int nElem, size_t size));

#ifdef WIN32
#include "bltWin.h"
#endif

#ifndef WIN32
#define PurifyPrintf  printf
#endif /* WIN32 */
#endif /*_BLT_INT_H*/
