#
# $Id: report.tcl,v 1.2 2020/12/13 14:01:03 bill Exp $
# $Log: report.tcl,v $
# Revision 1.2  2020/12/13 14:01:03  bill
# Working version to generate personalized PDF reports.
#
# Revision 1.1  2020/11/30 15:23:23  bill
# Initial revision
#
#

namespace eval utdtools {

  namespace eval report {
    variable dataS 
    variable fieldS 
    variable lookupS 
    variable num_dataS 

    proc report_header {fout title} {
      puts -nonewline $fout "<html>\n"
      puts -nonewline $fout "<head>\n"
      puts -nonewline $fout "<title>$title</title>\n"
      puts -nonewline $fout "</head>\n"
      puts -nonewline $fout "<body bgcolor=\"#FFFFFF\">\n"
      puts -nonewline $fout "<h3>$title</h3>\n"
      puts -nonewline $fout "<HR>\n"

    }


    proc report_section {fout html} {
      puts $fout "<PRE>\n"
      puts $fout "$html"
      puts $fout "</PRE>\n"
    }
    proc report_trailer {fout} {
      puts $fout "</body>"
      puts $fout "</html>"
    }


    proc report_create_html {basename title html} {
      set routine report_create_html
      set count 1
      while {1} {
	set fname "${basename}.report.${count}.html"
	if {!([file exists $fname])} {
	  break ;
	}
	incr count
      }
      icmessage imsg $routine "Creating file:$fname\n"
      set fout [open $fname "w"]
      if {$fout == ""} {
	icmessage errmsg $routine "Could not open file:$fname\n"
	return ;
      }
      report_header $fout $title
      report_section $fout $html
      report_trailer $fout
      close $fout
      return $fname
    }

    proc report_convert_to_pdf {filename} {
      global env
      global argv
      set routine "::utd::report_convert_to_pdf"
      if {[info exists env(ICDIR)]} {
	set icdir $env(ICDIR)
      } else {
	puts stderr "ERROR:cannot get iTools environment variable:ICDIR"
	exit 1
      }
      set program htmldoc
      set icos ${icdir}/bin/icos
      set pgm [exec $icos -noexec $program]
      set datadir [file join $icdir $program]

      set basename [file rootname $filename]
      set outname "${basename}.pdf"

      set cmd "$pgm --no-title --datadir $datadir --webpage $filename -f $outname"

      if {[catch {eval exec $cmd} result_msg]} {
	icmessage imsg $routine ": $result_msg\n"
      }
    }

  }

}
