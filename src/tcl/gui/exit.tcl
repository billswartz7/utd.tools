# Script to allow custom user abort
# $Id: exit.tcl,v 1.2 2019/12/19 18:38:49 bills Exp $
# $Log: exit.tcl,v $
# Revision 1.2  2019/12/19 18:38:49  bills
# Updated for new namespace for the AlertBox widget.
#

# Call a dialog to get user response.
set result [utdtools::AlertBox "Do you wish to exit?" {} 300x150+100+100 \
  "UTDtools Exit" Yes No ExitAll]

# Now sent the program a "Continue" if No, otherwise exit
if {"$result" == "1"} {
  set result "Continue"
} elseif {"$result" == "2"} {
  set result "ExitAll"
}
