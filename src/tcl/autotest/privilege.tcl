

namespace eval utdtools {
  proc privilege { } {
    set userid [exec whoami]
    if {($userid != "bill") && ($userid != "billswartz7") && ($userid != "wps100020")} {
      utdmsg errmsg utd::privilege "This is a privileged command.\n"
      exit 1
    }
  }

}
