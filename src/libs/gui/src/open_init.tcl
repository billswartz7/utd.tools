
"proc utdtools_init_paths{ } { \
  global env \
  global utdtoolsG \
  if {[info exists env(UTDTOOLS)]} { \
    set openroadG $env(UTDTOOLS) \
  } { \
    puts stderr "ERROR:cannot get UTDTOOLS environment variable:UTDTOOLS" \
    exit \
  } \
  set env(TCL_LIBRARY) [file join $utdtoolsG lib $env(UTDTOOLS)] \
} \
utdtools_init_paths"
