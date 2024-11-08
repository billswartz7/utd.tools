// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: efc_saed.v
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
//
//    Cluster Name:  Efuse Cluster
//    Unit Name:  efc_saed (synchronizer and edge detector)
//    Files that must be included:  none
//
//
//-----------------------------------------------------------------------------
`include "sys.h"
`include "iop.h"

module efc_saed (/*AUTOARG*/
   // Outputs
   rise_det, fall_det, 
   // Inputs
   async_in, clk
   );
//-----------------------------------------------------------------------------
//  I/O declarations
//-----------------------------------------------------------------------------
// Chip Primary Inputs/Globals

output   rise_det;
output   fall_det;
input   async_in;
input   clk;

//-----------------------------------------------------------------------------
//  Wire/reg declarations
//-----------------------------------------------------------------------------
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
// End of automatics
wire		snc1_ff;
wire		snc2_ff;
wire		hist_ff;

//-----------------------------------------------------------------------------
// Module Body
//-----------------------------------------------------------------------------
bw_u1_syncff_4x snc1_reg(
					.so(),
					.q (snc1_ff),
					.ck (clk),
					.d (async_in),
					.sd(),
					.se(1'b0));
dff_ns #(1) snc2_reg (.din(snc1_ff), .q(snc2_ff), .clk(clk));

dff_ns #(1) hist_reg (.din(snc2_ff), .q(hist_ff), .clk(clk));

assign rise_det = !hist_ff && snc2_ff;
assign fall_det = hist_ff && !snc2_ff;

endmodule
// Local Variables:
// verilog-library-directories:("." "../../common/rtl")
// verilog-library-files:      ("../../common/rtl/swrvr_clib.v")
// verilog-auto-sense-defines-constant:t
// End:
