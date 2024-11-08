// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: srffrl_ns.v
// Copyright (c) 2006 Sun Microsystems, Inc.  All Rights Reserved.
// DO NOT ALTER OR REMOVE COPYRIGHT NOTICES.
// 
// The above named program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
// 
// The above named program is distributed in the hope that it will be 
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
// 
// You should have received a copy of the GNU General Public
// License along with this work; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
// 
// ========== Copyright Header End ============================================
// _____________________________________________________________________________
//
// srffrl_ns -- A Set/Clr Flip-flop.
// _____________________________________________________________________________
//
// Description:
//   Wrapper around a 'dffrle_ns' flip-flop to create a synchronous Set/Clr Flop-flop.
//   Conflicts of both 'set' and 'clr' being asserted, are resolved in favor of 'set'.
// _____________________________________________________________________________


module srffrl_ns (/*AUTOARG*/
  // Outputs
  q, 
  // Inputs
  set, clr, rst_l, clk
  );

  input  set;		// Set flop.
  input  clr;		// Clear flop.
  input  rst_l;		// Synchronous reset.
  input  clk;		// Clock.
  output q;		// Output.


  // 'srff' set/clear flop state table.
  //
  // set     clr    rst_l |   out
  // ---------------------+------
  //  0       0      1    |    hold      Flop's value does not change.
  //  0       1      1    |    0
  //  1       x      1    |    1
  //  x       x      0    |    0         'rst_l' dominates.

  wire next_dff = set;
  wire dff_en = ( set | clr );

  dffrle_ns dff_reg (.din(next_dff), .en(dff_en), .q(dff), .rst_l(rst_l), .clk(clk));

  assign q = dff;


  endmodule


// Local Variables:
// verilog-library-directories:()
// verilog-library-files:("../../../common/rtl/swrvr_clib.v")
// verilog-module-parents:("jbi_aok_dok_tracking")
// End:
