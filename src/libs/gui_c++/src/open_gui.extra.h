
#ifndef INCLUDE_OPEN_GUI_EXTRA_H
#define INCLUDE_OPEN_GUI_EXTRA_H
/**
 * On Windows, this file needs to be compiled twice, once with
 * TK_ASCII_MAIN defined. This way both Tk_MainEx and Tk_MainExW
 * can be implemented, sharing the same source code.
 */
#if defined(TK_ASCII_MAIN)
#   ifdef UNICODE
#	undef UNICODE
#	undef _UNICODE
#   else
#	define UNICODE
#	define _UNICODE
#   endif
#endif

// #include <tk/tkInt.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#ifdef NO_STDLIB_H
#   include "../compat/stdlib.h"
#else
#   include <stdlib.h>
#endif

extern int TkCygwinMainEx(int, char **, Tcl_AppInitProc *, Tcl_Interp *);

/*
 * The default prompt used when the user has not overridden it.
 */

#define DEFAULT_PRIMARY_PROMPT	"% "

/*
 * This file can be compiled on Windows in UNICODE mode, as well as
 * on all other platforms using the native encoding. This is done
 * by using the normal Windows functions like _tcscmp, but on
 * platforms which don't have <tchar.h> we have to translate that
 * to strcmp here.
 */
#ifdef _WIN32
/*  Little hack to eliminate the need for "tclInt.h" here:
    Just copy a small portion of TclIntPlatStubs, just
    enough to make it work. See [600b72bfbc] */
typedef struct {
    int magic;
    void *hooks;
    void (*dummy[16]) (void); /* dummy entries 0-15, not used */
    int (*tclpIsAtty) (int fd); /* 16 */
} TclIntPlatStubs;
extern const TclIntPlatStubs *tclIntPlatStubsPtr;
#   include "tkWinInt.h"
#else
#   define TCHAR char
#   define TEXT(arg) arg
#   define _tcscmp strcmp
#   define _tcslen strlen
#   define _tcsncmp strncmp
#endif

#ifndef UTDGUI_NOGRAPHICS
#ifdef MAC_OSX_TK
#include "tkMacOSXInt.h"
#endif
#endif /* UTDGUI_GRAPHICS */

/*
 * Further on, in UNICODE mode, we need to use Tcl_NewUnicodeObj,
 * while otherwise NewNativeObj is needed (which provides proper
 * conversion from native encoding to UTF-8).
 */
#ifdef UNICODE
#   define NewNativeObj Tcl_NewUnicodeObj
#else /* !UNICODE */
    static Tcl_Obj *NewNativeObj(char *string, int length) {
	Tcl_Obj *obj;
	Tcl_DString ds;
	Tcl_ExternalToUtfDString(NULL, string, length, &ds);
	obj = Tcl_NewStringObj(Tcl_DStringValue(&ds), Tcl_DStringLength(&ds));
	Tcl_DStringFree(&ds);
	return obj;
}
#endif /* !UNICODE */

/*
 * Declarations for various library functions and variables (don't want to
 * include tkInt.h or tkPort.h here, because people might copy this file out
 * of the Tk source directory to make their own modified versions). Note: do
 * not declare "exit" here even though a declaration is really needed, because
 * it will conflict with a declaration elsewhere on some systems.
 */

#if defined(_WIN32)
#define isatty WinIsTty
static int WinIsTty(int fd) {
    HANDLE handle;

    /*
     * For now, under Windows, we assume we are not running as a console mode
     * app, so we need to use the GUI console. In order to enable this, we
     * always claim to be running on a tty. This probably isn't the right way
     * to do it.
     */

#if !defined(STATIC_BUILD)
	if (tclStubsPtr->reserved9 && tclIntPlatStubsPtr->tclpIsAtty) {
	    /* We are running on Cygwin */
	    return tclIntPlatStubsPtr->tclpIsAtty(fd);
	}
#endif
    handle = GetStdHandle(STD_INPUT_HANDLE + fd);
	/*
	 * If it's a bad or closed handle, then it's been connected to a wish
	 * console window. A character file handle is a tty by definition.
	 */
    return (handle == INVALID_HANDLE_VALUE) || (handle == 0)
	     || (GetFileType(handle) == FILE_TYPE_UNKNOWN)
	     || (GetFileType(handle) == FILE_TYPE_CHAR);
}
#else
extern int		isatty(int fd);
#endif

#endif /* INCLUDE_OPEN_GUI_EXTRA_H */
