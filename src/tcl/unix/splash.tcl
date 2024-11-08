namespace eval icflow {
  proc splash {} {
    variable appS
    variable canS
    wm withdraw .
    wm deiconify .
    toplevel .splash -bd 3 -relief raised
    set sw [winfo screenwidth .]
    set sh [winfo screenheight .]
    image create photo splash \
	    -file [ file join $appS(libpath) splash.gif ]
    label .splash.im -image splash -bd 1 -relief sunken
    set ih [image height splash]
    set iw [image width splash]
    set x [expr {($sw - $iw) /2}]
    set y [expr {($sh - $ih) /2}]
    wm geometry .splash +$x+$y
    wm title .splash "Welcome to the flow editor"
    # Can't use overrideredict because of a bug with raise.
    # wm overrideredirect .splash 1
    pack  .splash.im -side top -expand true -fill both
    raise .splash .
    update idletasks
    after 3500 { catch { destroy .splash } }
  }
}
