// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_dqs_edgelogic.v
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
module dram_dqs_edgelogic(/*AUTOARG*/
   // Outputs
   clk_sel, dqs_pad_clk_so, to_pad, oe, 
   // Inputs
   clk, dqs_pad_clk_se, dqs_pad_clk_si, 
   dram_io_drive_enable, dram_io_drive_data, 
   dram_io_channel_disabled, to_core, testmode_l
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
input			clk;
input			testmode_l;
input			dqs_pad_clk_se;
input			dqs_pad_clk_si;
input			dram_io_drive_enable;
input			dram_io_drive_data;
input			dram_io_channel_disabled;
input			to_core;

//////////////////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////////////////
output			clk_sel;
output			dqs_pad_clk_so;
output			to_pad;
output			oe;

//////////////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////////////

// CREATING MUX FOR TEST CLOCK
wire tclk = testmode_l ? ~clk : clk;

// INSTANTIATING PAD LOGIC

dff_s #(1)	flop_enable(
		.din(dram_io_drive_enable),
		.q(enable_q),
		.clk(clk), .si(dqs_pad_clk_si), .so(dqs_pad_clk_si1), .se(dqs_pad_clk_se));

dff_s #(1)	flop_ch_enable(
		.din(dram_io_channel_disabled),
		.q(ch_disabled),
		.clk(clk), .si(dqs_pad_clk_si1), .so(dqs_pad_clk_si2), .se(dqs_pad_clk_se));

assign clk_sel = (enable_q | ~testmode_l) ? clk : to_core;

assign oe = enable_q;

dff_s #(1)	flop_drive_dqs(
		.din(dram_io_drive_data),
		.q(drive_dqs_q),
		.clk(tclk), .si(dqs_pad_clk_si2), .so(dqs_pad_clk_so), .se(dqs_pad_clk_se));

assign to_pad = clk & drive_dqs_q & ~ch_disabled;

endmodule
