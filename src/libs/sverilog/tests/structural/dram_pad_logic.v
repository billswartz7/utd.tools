// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_pad_logic.v
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
module dram_pad_logic(/*AUTOARG*/
   // Outputs
   pad_logic_clk_so, 
   io_dram_data_valid, pad_pos_cnt, 
   pad_neg_cnt, 
   // Inputs
   rst_l, arst_l, clk, pad_logic_clk_si, pad_logic_clk_se, testmode_l,
   dram_io_pad_clk_inv, dram_io_pad_enable, burst_length_four
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
input			rst_l;
input			arst_l;
input			clk;
input			testmode_l;
input			pad_logic_clk_si;
input			pad_logic_clk_se;
input		 	dram_io_pad_clk_inv;
input			dram_io_pad_enable;
input			burst_length_four;

//////////////////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////////////////
output			pad_logic_clk_so;
output			io_dram_data_valid;
output [1:0]		pad_pos_cnt;
output [1:0]		pad_neg_cnt;

// WIRES
wire			cnt_clk;
wire			pad_data_valid_in;
wire			pad_data_valid;
wire [1:0]		pad_pos_cnt_in;

//////////////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////////////

// CREATING MUX FOR TEST CLOCK
wire tclk = testmode_l ? ~clk : clk;

// INSTANTIATING PAD LOGIC

dffrl_s #(1) ff_clk_inv(
        .din(dram_io_pad_clk_inv),
        .q(dram_io_clk_inv_d1),
	.rst_l(rst_l),
        .clk(clk), .se(pad_logic_clk_se), .si(pad_logic_clk_si), .so(pad_logic_clk_si1));

// SOFTWARE CONTROLLED MUX COUNTER INSTEAD OF HARDWARE GENERATED

dffrl_s #(1) ff_cnt_en(
        .din(dram_io_pad_enable),
        .q(dram_io_pad_enable_d1),
	.rst_l(rst_l),
        .clk(clk), .se(pad_logic_clk_se), .si(pad_logic_clk_si1), .so(pad_logic_clk_si2));

wire dram_cnt_enable = rst_l & (dram_io_clk_inv_d1 ? dram_io_pad_enable_d1 : dram_io_pad_enable);

dffrl_async #(1) ff_cnt_en_d2(
        .din(dram_cnt_enable),
        .q(dram_cnt_enable_d1),
	.rst_l(arst_l),
        .clk(tclk), .se(pad_logic_clk_se), .si(pad_logic_clk_si5), .so(pad_logic_clk_si6));

// Signals for pos edge
assign pad_data_valid_in = (pad_pos_cnt[1:0] == 1) | (pad_pos_cnt[1:0] == 3) ;

dff_s #(1) ff_data_vld(
                .din(pad_data_valid_in),
                .q(io_dram_data_valid),
                .clk(clk), .se(pad_logic_clk_se), .si(pad_logic_clk_si2), 
			.so(pad_logic_clk_si3));

// Bug 6667: Changed pad_pos_cnt_in[*] to reset on rst_l ---YC 09/02/04
assign pad_pos_cnt_in[1:0] = {rst_l, rst_l} & (burst_length_four ? (
				dram_cnt_enable_d1 | pad_data_valid_in ? pad_pos_cnt[1:0] + 2'h1 : pad_pos_cnt[1:0]) :
				pad_pos_cnt[1:0] + 1'b1);

dffrl_async #(1)       ff_pos_cnt0(
                .din(pad_pos_cnt_in[0]),
                .q(pad_pos_cnt[0]),
                .rst_l(arst_l),
                .clk(clk), 
		.se(pad_logic_clk_se), .si(pad_logic_clk_si3), 
			.so(pad_logic_clk_si4));

dffrl_async #(1)       ff_pos_cnt1(
                .din(pad_pos_cnt_in[1]),
                .q(pad_pos_cnt[1]),
                .rst_l(arst_l),
                .clk(clk), 
		.se(pad_logic_clk_se), .si(pad_logic_clk_si4), 
			.so(pad_logic_clk_si5));

// Negative clk counter
wire [1:0]      pad_neg_cnt;

dff_s #(1)        ff_neg_cnt0(
                .din(pad_pos_cnt[0]),
                .q(pad_neg_cnt[0]),
                .clk(tclk), 
		.se(pad_logic_clk_se), .si(pad_logic_clk_si6), 
			.so(pad_logic_clk_si7));

dff_s #(1)        ff_neg_cnt1(
                .din(pad_pos_cnt[1]),
                .q(pad_neg_cnt[1]),
                .clk(tclk), 
		.se(pad_logic_clk_se), .si(pad_logic_clk_si7), 
			.so(pad_logic_clk_so));

endmodule
