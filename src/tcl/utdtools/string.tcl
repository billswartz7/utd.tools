#!/usr/local/bin/wish -f
# Program: common
# $Id: string.tcl,v 1.6 2019/12/19 18:39:44 bills Exp $
# $Log: string.tcl,v $
# Revision 1.6  2019/12/19 18:39:44  bills
# Changed namespace from icstring to twstring.   Added compare_dictionary.
#
# Revision 1.5  2014/03/25 21:04:16  bills
# Added the icstring::remove_dquotes and icstring::remove_squotes functions.
#
# Revision 1.4  2014/03/25  21:03:25  bills
# Added the icstring::remove_whitespace_function.
#
# Revision 1.3  2009/11/24  17:09:49  bills
# Added the strip_suffix command for utility and completeness.
#
# Revision 1.2  2009/06/25  22:22:42  bills
# Added icstring::strip_prefix and icstring::replace_prefix.
#
# Revision 1.1  2009/06/09  19:28:43  bills
# Initial revision
#
#
#


namespace eval utdstring {

  proc strparser {line delimiters} {
    # This routine makes split work like strtok.
    set parsed_line [split $line $delimiters]
    set out_line ""
    foreach item $parsed_line {
      if {$item != ""} {
	lappend out_line $item
      }
    }
    return $out_line
  }

  proc strip_prefix {name prefix} {
    set len [string length $prefix]
    if {[string equal -length $len $name $prefix]} {
      set name [string range $name $len end]
    }
    return $name
  }


  proc compare_dictionary {s1 s2} {
    if {$s1 eq $s2} {
      return 0
    } else {
      set il [lsort -dictionary -indices [list $s1 $s2]]
      return [expr {[lindex $il 0] ? 1 : -1}]
    }
  }

  proc replace_prefix {name prefix new_prefix} {
    set len [string length $prefix]
    if {[string equal -length $len $name $prefix]} {
      set name [string range $name $len end]
      return ${new_prefix}${name}
    }
    return ${name}
  }

  proc strip_suffix {str suffix} {
    set string_len [string length $str]
    set suffix_len [string length $suffix]
    set suf_start [expr $string_len - $suffix_len]
    if {$suf_start < 0} {
      return ""
    }
    set ending [string range $str $suf_start end]
    if {$ending == $suffix} {
      incr suf_start -1
      set stripped [string range $str 0 $suf_start]
      return $stripped
    }
    return ""
  }

  proc remove_whitespace {str} {
    set new_string [string map {{ } {} \t {} \{ {} \} {}} $str]
    return $new_string
  }

  proc remove_dquotes {str} {
    set fchar [string index $str 0]
    if {$fchar != "\""} {
      return $str
    }
    set lchar [string index $str end]
    if {$lchar != "\""} {
      return $str
    }
    set str [string range $str 1 end-1]
    return $str
  }

  proc remove_squotes {str} {
    set fchar [string index $str 0]
    if {$fchar != {'}} {
      return $str
    }
    set lchar [string index $str end]
    if {$lchar != {'}} {
      return $str
    }
    set str [string range $str 1 end-1]
    return $str
  }

}
