global env

if {!([info exists env(UTDTOOLS)])} {
  return ; # Can't do anything
}

if {!([info exists env(UTDTOOLSVERSION)])} {
  return ; # Can't do anything
}

set rootdir [file join $env(UTDTOOLS) $env(UTDTOOLSVERSION)]

package ifneeded utd_table 1.0 [list load [file join $rootdir lib \
  $env(UTDTOOLSOS) libutdtools_prtable[info sharedlibextension]] utd_table]

package ifneeded utdpython 1.0 [list load [file join $rootdir lib \
  $env(UTDTOOLSOS) libutdtools_tclpython[info sharedlibextension]] utdpython]

package ifneeded Expect 5.45.4 [list load [file join $rootdir lib \
  $env(UTDTOOLSOS) libutdtools_expect[info sharedlibextension]] expect]

package ifneeded udp 1.0.11 [list load [file join $rootdir lib \
  $env(UTDTOOLSOS) udp1.0.11 libudp1.0.11[info sharedlibextension]] udp]

package ifneeded sqlite3 3.25.3 [list load [file join $rootdir lib \
  $env(UTDTOOLSOS) sqlite3.25.3 libsqlite3.25.3[info sharedlibextension]] sqlite3]
