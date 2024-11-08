// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_bs_fsdq_2x.v
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
// bw_io_bs_fsdq_2x 
// _____________________________________________________________________________
//

module bw_io_bs_fsdq_2x (/*AUTOARG*/
  // Outputs
  q, 
  // Inputs
  d, up_dr
  );

  output [2:0]	q;
  input  [2:0]	d;
  input		up_dr;


  supply1	vdd;


  bw_u1_scanlg_2x Iq0 (
    .so              (q[0]),
    .sd              (d[0]),
    .ck              (up_dr),
    .se              (vdd)
    );

  bw_u1_scanlg_2x Iq1 (
    .so              (q[1]),
    .sd              (d[1]),
    .ck              (up_dr),
    .se              (vdd)
    );

  bw_u1_scanlg_2x Iq2 (
    .so              (q[2]),
    .sd              (d[2]),
    .ck              (up_dr),
    .se              (vdd)
    );

  endmodule


// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
