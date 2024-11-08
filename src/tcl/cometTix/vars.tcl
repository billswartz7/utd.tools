namespace eval utdcomet {
  variable designNameS

  proc name_set {value} {
    variable designNameS
    set designNameS $value
    return $designNameS
  }
}
