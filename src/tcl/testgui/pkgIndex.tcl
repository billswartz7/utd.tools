global env

if {!([info exists ::openroad::rootdirS])} {
  return ; # Can't do anything
}

# Now Tcllib which is useful
source [file join $::openroad::rootdirS tcl tcllib lib tcllib pkgIndex.tcl]
