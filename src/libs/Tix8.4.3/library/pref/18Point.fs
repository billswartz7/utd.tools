#
# $Id: 18Point.fs,v 1.2 2001/12/09 05:03:09 idiscovery Exp $
#
proc tixSetFontset {} {
    global tixOption tcl_platform

    switch -- $tcl_platform(platform) "windows" {
	# This should be Tahoma for Win2000/XP
	set font "MS Sans Serif"
	set fixedfont "Courier New"
    } unix {
	set font "helvetica"
	set fixedfont "courier"
    }

    set tixOption(font)         [list $font -18]
    set tixOption(bold_font)    [list $font -18 bold]
    set tixOption(menu_font)    [list $font -18]
    set tixOption(italic_font)  [list $font -18 bold italic]
    set tixOption(fixed_font)   [list $fixedfont -18]
    set tixOption(border1)      1
}
