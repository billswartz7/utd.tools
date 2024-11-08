# These variables must reflect the frame names
# $Id$
# $Log$

namespace eval utdgui {
  proc init_symbolic { } {
    global utdsymbolicNameG
    set {utdsymbolicNameG(utdroot)} {.}
    set {utdsymbolicNameG(utdcanvas)} {.utd.fdraw.frame7.frame1.canvas2}
    set {utdsymbolicNameG(utdtranscript)} {UTDNONE}
    set {utdsymbolicNameG(utdposition)} {UTDNONE}
  }
}

# eof
#
