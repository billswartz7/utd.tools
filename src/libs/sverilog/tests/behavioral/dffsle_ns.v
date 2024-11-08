// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dffsle_ns.v
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
// dffrle_ns -- Positive-edge triggered flop with set_l, enable, without scan.
// _____________________________________________________________________________
//
// Description:
//   Wrapper around a 'dffe_ns' flip-flop to create a Positive-edge triggered flop
//   with set_l, enable, without scan.
// _____________________________________________________________________________


module dffsle_ns (/*AUTOARG*/
  // Outputs
  q, 
  // Inputs
  din, en, set_l, clk
  );
  // synopsys template

  parameter SIZE = 1;

  input  [SIZE-1:0] din;	// data in
  input 	    en;		// functional enable
  input 	    set_l;	// set
  input 	    clk;	// clk

  output [SIZE-1:0] q;		// output

  wire              en_wire;
  wire 	 [SIZE-1:0] din_wire, q_wire;

  // Enable Interpretation. Ultimate interpretation depends on design
  //
  // set_l   en      out
  //---------------------
  // 0       x       1   ; set dominates
  // 1       1       din
  // 1       0       q
  //

  //// synopsys sync_set_reset "set_l"
  //always @ (posedge clk)
  //  if (!set_l)
  //    q[SIZE-1:0] <= {SIZE{1'b1}};
  //  else if (en)
  //    q[SIZE-1:0] <= din[SIZE-1:0];

  // When 'set_l' is asserted, the value of '1' is forced onto the .din flop input and the .en pin
  // is forced on to load the '1' into the flop on the next clock.
  assign din_wire[SIZE-1:0] =  ((en)? din[SIZE-1:0]: q_wire[SIZE-1:0]) | {SIZE{(~set_l)}};
  assign en_wire = en || (~set_l);

  dffe_ns #(SIZE) dff_reg (.din(din_wire[SIZE-1:0]), .en(en_wire), .q(q_wire[SIZE-1:0]), .clk(clk));

  assign q = q_wire;

  endmodule


// Local Variables:
// verilog-library-directories:()
// verilog-library-files:("../../../common/rtl/swrvr_clib.v")
// verilog-module-parents:("jbi_int_arb")
// End:
