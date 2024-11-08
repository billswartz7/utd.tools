# These variables must reflect the frame names
# $Id: symbolic.tcl,v 1.1 2018/10/10 21:11:08 bill Exp bill $
# $Log: symbolic.tcl,v $
# Revision 1.1  2018/10/10 21:11:08  bill
# Initial revision
#

namespace eval utdtoolsgui {
  proc init_symbolic { } {
    global utdsymbolicNameG
    set {utdsymbolicNameG(utdroot)} {.}
    set {utdsymbolicNameG(utdcanvas)} {.utdtools.fdraw.frame7.frame1.canvas2}
    set {utdsymbolicNameG(utdtranscript)} {UTDNONE}
    set {utdsymbolicNameG(utdposition)} {UTDNONE}
  }
}

# eof
#
