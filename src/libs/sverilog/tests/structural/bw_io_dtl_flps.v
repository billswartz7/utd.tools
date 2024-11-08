// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_flps.v
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
// bw_io_dtl_flps 
// _____________________________________________________________________________
//


module bw_io_dtl_flps (/*AUTOARG*/
  // Outputs
  q, so, 
  // Inputs
  d, clk, si, se
  );

  output [2:0]	q;
  input  [2:0]	d;
  output	so;
  input		clk;
  input		si;
  input		se;


  //wire		so_0, net51;
 
 
  bw_u1_soff_2x bsff_0 (
    .q               (q[0]),
    .so              (so_0),
    .ck              (clk),
    .d               (d[0]),
    .se              (se),
    .sd              (si)
    );

  bw_u1_soff_2x bsff_1 (
    .q               (q[1]),
    .so              (net51),
    .ck              (clk),
    .d               (d[1]),
    .se              (se),
    .sd              (so_0)
    );

  bw_u1_soff_2x I28 (
    .q               (q[2]),
    .so              (so),
    .ck              (clk),
    .d               (d[2]),
    .se              (se),
    .sd              (net51)
    );


  endmodule


// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
