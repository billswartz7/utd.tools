// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_ctl_edgelogic.v
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
module dram_ctl_edgelogic(/*AUTOARG*/
   // Outputs
   ctl_pad_clk_so, to_pad, 
   // Inputs
   clk, rst_l, ctl_pad_clk_se, ctl_pad_clk_si, data, testmode_l
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
input			clk;
input			rst_l;
input			testmode_l;
input			ctl_pad_clk_se;
input			ctl_pad_clk_si;
input			data;

//////////////////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////////////////
output			ctl_pad_clk_so;
output			to_pad;

//////////////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////////////

// CREATING MUX FOR TEST CLOCK
wire tclk = testmode_l ? ~clk : clk;

// INSTANTIATING PAD LOGIC

dffrl_s #(1) flop_data(
		.din(data),
		.q(to_pad),
		.rst_l(rst_l),
		.clk(tclk), .si(ctl_pad_clk_si), .so(ctl_pad_clk_so), .se(ctl_pad_clk_se));

endmodule
