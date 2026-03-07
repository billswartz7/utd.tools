
# This function replaces the builtin toplevel which was
# renamed from toplevel to builtin_toplevel in the core
# code.  This allows us to register all toplevel windows
# so we can automatically generate the proper exposure
# commands.  Apple should really fix their bugs.  This
# code is only needed for broken Apple Xquartz.

proc toplevel {w args} {
  # puts stderr "got toplevel $w '$args'..."
  set results [eval builtin_toplevel $w $args]
  # puts stderr "results: $results"
  utdwin register $w
  return $results
}
