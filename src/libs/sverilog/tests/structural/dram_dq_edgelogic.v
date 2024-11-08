// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_dq_edgelogic.v
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
module dram_dq_edgelogic(/*AUTOARG*/
   // Outputs
   io_dram_data_in_hi, io_dram_data_in, dq_pad_clk_so, 
   to_pad, oe, afi, 
   // Inputs
   clk, rst_l, arst_l, dq_pad_clk_se, dq_pad_clk_si, dqs_read, data_pos, 
   data_neg, pad_pos_cnt, pad_neg_cnt, dram_io_drive_enable, 
   dram_io_pad_enable, dram_io_ptr_clk_inv, 
   burst_length_four, to_core, testmode_l, test_mode, tp_out_type, afo
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
input			clk;
input			rst_l;
input			arst_l;
input			dq_pad_clk_se;
input			dq_pad_clk_si;
input			dqs_read;
input			data_pos;
input			data_neg;
input [1:0]		pad_pos_cnt;
input [1:0]		pad_neg_cnt;
input			dram_io_drive_enable;
input			dram_io_pad_enable;
input 			dram_io_ptr_clk_inv;
input			burst_length_four;
input			to_core;
input			testmode_l;
input			test_mode;
input			tp_out_type;
input			afo;

//////////////////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////////////////
output			io_dram_data_in_hi;
output			io_dram_data_in;
output			dq_pad_clk_so;
output			to_pad;
output			oe;
output			afi;

// WIRES
wire [0:0]		pad_ptr0_pos;
wire [0:0]		pad_ptr1_pos;
wire [0:0]		pad_ptr2_pos;
wire [0:0]		pad_ptr3_pos;
wire			pad_pos_data;
wire			pad_neg_data;
wire			pad_data_clk_flip_out;
wire			pad_data_cap_clk;
wire			dq_pad_enable;
wire [1:0]		pad_ptr_pos0_in;
wire [1:0]		pad_ptr_pos0;
wire 			dram_io_ptr_clk_d1;

//////////////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////////////

// CREATING MUX FOR TEST CLOCK                                            
wire tclk = testmode_l ? ~clk : clk;

// GENERATING PAD ENABLE FOR NOISE PROTECTION

dff_s #(1)	flop_io_pad_clk_bit1(
		.din(dram_io_ptr_clk_inv),
		.q(dram_io_ptr_clk_d1),
		.clk(clk), 
		.si(dq_pad_clk_si), .so(dq_pad_clk_si0), .se(dq_pad_clk_se));

dff_s #(1)	flop_io_pad_enable_p(
		.din(dram_io_pad_enable),
		.q(dram_io_pad_enable_p_d1),
		.clk(clk), 
		.si(dq_pad_clk_si13), .so(dq_pad_clk_si1), .se(dq_pad_clk_se));

dff_s #(1)	flop_io_pad_enable_pn(
		.din(dram_io_pad_enable_p_d1),
		.q(dram_io_pad_enable_pn_d1),
		.clk(tclk), 
		.si(dq_pad_clk_si0), .so(dq_pad_clk_si13), .se(dq_pad_clk_se));

dff_s #(1)	flop_io_pad_enable_n(
		.din(dram_io_pad_enable),
		.q(dram_io_pad_enable_n_d1),
		.clk(tclk), 
		.si(dq_pad_clk_si14), .so(dq_pad_clk_si2), .se(dq_pad_clk_se));

dff_s #(1)	flop_io_pad_enable_np(
		.din(dram_io_pad_enable_n_d1),
		.q(dram_io_pad_enable_np_d1),
		.clk(clk), 
		.si(dq_pad_clk_si1), .so(dq_pad_clk_si14), .se(dq_pad_clk_se));

// OR of neg-pos or pos-neg to generate 1.5 cycle width of read enable 
wire dq_pad_pos_neg_rd_en = dram_io_pad_enable_p_d1 | dram_io_pad_enable_pn_d1;
wire dq_pad_neg_pos_rd_en = dram_io_pad_enable_n_d1 | dram_io_pad_enable_np_d1;

wire dram_io_pad_enable_d1 = dram_io_ptr_clk_d1 ? dq_pad_neg_pos_rd_en : dq_pad_pos_neg_rd_en;
assign dq_pad_enable = dram_io_pad_enable_d1 | (pad_ptr_pos0[0] == 1'b1); 	// ptr == 1 or 3.

// INSTANTIATING PAD LOGIC FOR WRITE

dff_s #(1)	flop_data_pos(
		.din(data_pos),
		.q(data_pos_d1),
		.clk(tclk), .si(dq_pad_clk_si2), .so(dq_pad_clk_si3), .se(dq_pad_clk_se));

dff_s #(1)	flop_data_neg(
		.din(data_neg),
		.q(data_neg_d1),
		.clk(clk), .si(dq_pad_clk_si4), .so(dq_pad_clk_si5), .se(dq_pad_clk_se)); 

wire data_out = dqs_read ? data_neg_d1 : data_pos_d1;

// ENABLE

dff_s #(1)        flop_drive_dqs(
                .din(dram_io_drive_enable),
                .q(enable_q),
                .clk(clk), .si(dq_pad_clk_si5), .so(dq_pad_clk_so_clk), .se(dq_pad_clk_se)); 

dff_s #(1)        flop_drive_data(
                .din(enable_q),
                .q(enable_data),
                .clk(tclk), .si(dq_pad_clk_si3), .so(dq_pad_clk_si4), .se(dq_pad_clk_se));

wire output_enable = (enable_data & enable_q);

// READ LOGIC
// POINTER FLOP

assign pad_ptr_pos0_in[1:0] = burst_length_four ? (
				dq_pad_enable ? pad_ptr_pos0 + 1'b1 : pad_ptr_pos0[1:0]) :
                             	(dram_io_pad_enable_d1 | ~(pad_ptr_pos0[1:0] == 2'b00)) ?
				pad_ptr_pos0 + 1'b1 : pad_ptr_pos0;

// Bug 6666: REOPEN Changed arst_l & rst_l to arst_l & (rst_l | ~testmode_l) in ff_ptr_pos0, ff_ptr_pos1 to fix ATPG bug ---YC 11/03/04
// Bug 6666: Changed ff_ptr_pos* flops to reset on either of rst_l or arst_l ---YC 09/02/04
dffrl_async #(1) ff_ptr_pos0(
                .din(pad_ptr_pos0_in[0]),
                .q(pad_ptr_pos0[0]),
                .rst_l(arst_l & (rst_l | ~testmode_l)),
                .clk(~dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clk_si15), .so(dq_pad_clkn_si0));

dffrl_async #(1) ff_ptr_pos1(
                .din(pad_ptr_pos0_in[1]),
                .q(pad_ptr_pos0[1]),
                .rst_l(arst_l & (rst_l | ~testmode_l)),
                .clk(~dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clkn_si0), .so(dq_pad_clkn_si1));

assign pad_ptr0_pos[0] = pad_ptr_pos0 == 0;
assign pad_ptr1_pos[0] = pad_ptr_pos0 == 1;
assign pad_ptr2_pos[0] = pad_ptr_pos0 == 2;
assign pad_ptr3_pos[0] = pad_ptr_pos0 == 3;

// Flopping the incomming data with quarter cycle delayed DQS
dffe_s #(1)        ff_data_pos0_in0(
                .din(to_core),
                .q(dram_pad_data0),
		.en(pad_ptr0_pos[0]),
                .clk(dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clk_si6), .so(dq_pad_clk_si7));
                
dffe_s #(1)        ff_data_pos1_in0(
                .din(to_core),
                .q(dram_pad_data1),
		.en(pad_ptr1_pos[0]),
                .clk(dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clk_si7), .so(dq_pad_clk_si8));
                
dffe_s #(1)        ff_data_pos2_in0(
                .din(to_core),
                .q(dram_pad_data2),
                .en(pad_ptr2_pos[0]),
                .clk(dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clk_si8), .so(dq_pad_clk_si9));
                
dffe_s #(1)        ff_data_pos3_in0(
                .din(to_core),
                .q(dram_pad_data3),
                .en(pad_ptr3_pos[0]),
                .clk(dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clk_si9), .so(dq_pad_clk_si10));

// NEG EDGE RELATED LOGIC

dffe_s #(1)        ff_data_neg0_in0(
                .din(to_core),
                .q(dram_neg_pad_data0),
		.en(pad_ptr0_pos[0]),
                .clk(~dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clkn_si1), .so(dq_pad_clkn_si2));

dffe_s #(1)        ff_data_neg1_in0(
                .din(to_core),
                .q(dram_neg_pad_data1),
		.en(pad_ptr1_pos[0]),
                .clk(~dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clkn_si2), .so(dq_pad_clkn_si3));

dffe_s #(1)        ff_data_neg2_in0(
                .din(to_core),
                .q(dram_neg_pad_data2),
		.en(pad_ptr2_pos[0]),
                .clk(~dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clkn_si3), .so(dq_pad_clkn_si4));

dffe_s #(1)        ff_data_neg3_in0(
                .din(to_core),
                .q(dram_neg_pad_data3),
		.en(pad_ptr3_pos[0]),
                .clk(~dqs_read), .se(dq_pad_clk_se), .si(dq_pad_clkn_si4), .so(dq_pad_clkn_so));

assign pad_pos_data = pad_pos_cnt[1:0] == 3 ? dram_pad_data2 : 
				 pad_pos_cnt[1:0] == 2 ? dram_pad_data1 :
				 pad_pos_cnt[1:0] == 1 ?  dram_pad_data0 : dram_pad_data3;
assign pad_neg_data = pad_neg_cnt[1:0] == 3 ?  dram_neg_pad_data2 : 
                                 pad_neg_cnt[1:0] == 2 ? dram_neg_pad_data1 :
                                 pad_neg_cnt[1:0] == 1 ?  dram_neg_pad_data0 : dram_neg_pad_data3;

// FLOP DATA TO DRAM CLK

dff_s #(1)      ff_data_pos_dqs(
                .din(pad_pos_data),
                .q(io_dram_data_in_hi),
                .clk(clk), .se(dq_pad_clk_se), .si(dq_pad_clk_so_clk), .so(dq_pad_clk_si11));

dff_s #(1)      ff_data_neg_dqs(
                .din(pad_neg_data),
                .q(io_dram_data_in),
                .clk(tclk), 
		.se(dq_pad_clk_se), .si(dq_pad_clk_si11), .so(dq_pad_clk_si12));

// ADDED FOR TEST PURPOSE

assign oe = test_mode ? tp_out_type : output_enable;
assign to_pad = test_mode ? afo : data_out;
assign afi = test_mode & to_core;

// ADDING SCAN LOCKUP LATCH GOING FROM CLK TO ~CLK 
// The way scan is stiched, si -> ff(clk) -> l.latch(tclk) -> ff(dqs) -> l.latch(dqs) -> ff(~dqs) -> dummy_ff -> so

bw_u1_scanlg_2x lockup_latch_clk_dqs(
		.so(dq_pad_clk_si6), 
		.sd(dq_pad_clk_si12), 
		.ck(tclk), 
		.se(dq_pad_clk_se));

bw_u1_scanlg_2x lockup_latch_dqs_inv_dqs(
		.so(dq_pad_clk_si15), 
		.sd(dq_pad_clk_si10), 
		.ck(dqs_read), 
		.se(dq_pad_clk_se));

// ADDING DUMMY FLOP FOR GOING FROM ~CLK TO CLK 

dff_ns #(1)      ff_dummy_scan(
                .din(dq_pad_clkn_so),
                .q(dq_pad_clk_so),
                .clk(clk)); 

endmodule
