// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_clk_edgelogic.v
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
module dram_clk_edgelogic(/*AUTOARG*/
   // Outputs
   clk_pad_clk_so, to_pad, 
   // Inputs
   clk, clk_pad_clk_si, clk_pad_clk_se, clk_value, 
   dram_io_clk_enable, testmode_l
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
input			clk;
input			testmode_l;
input			clk_pad_clk_si;
input			clk_pad_clk_se;
input			clk_value;
input			dram_io_clk_enable;

//////////////////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////////////////
output			clk_pad_clk_so;
output			to_pad;

//////////////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////////////

// CREATING MUX FOR TEST CLOCK                                            
wire tclk = testmode_l ? ~clk : clk;

// INSTANTIATING PAD LOGIC

dff_s #(1)        flop_io_pad_flip_clk(
                .din(dram_io_clk_enable),
                .q(dram_io_clk_enable_d1),
                .clk(tclk),
                .si(clk_pad_clk_si), .so(clk_pad_clk_so), .se(clk_pad_clk_se));

wire clk_out = clk_value & dram_io_clk_enable_d1;

wire enable_mux_val = dram_io_clk_enable_d1 ? ~clk_out : clk_out;

assign to_pad = clk ? clk_out : enable_mux_val;

endmodule
