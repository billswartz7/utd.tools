// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_dp.v
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

module dram_dp(/*AUTOARG*/
   // Outputs
   dp_data_mecc0, dp_data_mecc1, dp_data_mecc2, dp_data_mecc3, 
   dp_data_mecc4, dp_data_mecc5, dp_data_mecc6, dp_data_mecc7, 
   dram_io_data_out, dp_data_in, dp_ecc_in, dp_data_valid, 
   // Inputs
   clk, rst_l, l2if_data_mecc0, l2if_data_mecc1, l2if_data_mecc2, 
   l2if_data_mecc3, l2if_data_mecc4, l2if_data_mecc5, 
   l2if_data_mecc6, l2if_data_mecc7, io_dram_data_in, io_dram_ecc_in, 
   io_dram_data_valid, que_bypass_scrb_data, que_mem_addr, que_mem_data, 
   dram_fail_over_mask, l2if_scrb_data_en, l2if_scrb_data, 
   l2if_scrb_ecc, err_inj_reg, err_mask_reg, que_wr_channel_mux, 
   ch1_que_mem_data, ch1_dp_data_mecc0, ch1_dp_data_mecc1, 
   ch1_dp_data_mecc2, ch1_dp_data_mecc3, ch1_dp_data_mecc4, 
   ch1_dp_data_mecc5, ch1_dp_data_mecc6, ch1_dp_data_mecc7,
   que_st_cmd_addr_parity, que_channel_disabled, sshot_err_reg
   );

//////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////

input		clk;
input		rst_l;

input [3:0]	l2if_data_mecc0;
input [3:0]	l2if_data_mecc1;
input [3:0]	l2if_data_mecc2;
input [3:0]	l2if_data_mecc3;
input [3:0]	l2if_data_mecc4;
input [3:0]	l2if_data_mecc5;
input [3:0]	l2if_data_mecc6;
input [3:0]	l2if_data_mecc7;

input [255:0]   io_dram_data_in;		// from pad
input [31:0]    io_dram_ecc_in;			// from pad
input		io_dram_data_valid;		// from pad

input		que_bypass_scrb_data;
input [4:0]	que_mem_addr;
input [255:0]   que_mem_data;
input		que_st_cmd_addr_parity;
input		que_channel_disabled;

input [34:0]	dram_fail_over_mask;

input		l2if_scrb_data_en;
input [255:0] 	l2if_scrb_data;
input [33:0] 	l2if_scrb_ecc;

input		err_inj_reg;
input [15:0]    err_mask_reg;

// DUE TO 2 CHANNEL MODE
input		que_wr_channel_mux;
input [255:0]   ch1_que_mem_data;

input [3:0]	ch1_dp_data_mecc0;
input [3:0]	ch1_dp_data_mecc1;
input [3:0]	ch1_dp_data_mecc2;
input [3:0]	ch1_dp_data_mecc3;
input [3:0]	ch1_dp_data_mecc4;
input [3:0]	ch1_dp_data_mecc5;
input [3:0]	ch1_dp_data_mecc6;
input [3:0]	ch1_dp_data_mecc7;

output [3:0]	dp_data_mecc0;
output [3:0]	dp_data_mecc1;
output [3:0]	dp_data_mecc2;
output [3:0]	dp_data_mecc3;
output [3:0]	dp_data_mecc4;
output [3:0]	dp_data_mecc5;
output [3:0]	dp_data_mecc6;
output [3:0]	dp_data_mecc7;

//////////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////////

output [287:0]  dram_io_data_out;

output [255:0] 	dp_data_in;
output [31:0] 	dp_ecc_in;
output		dp_data_valid;


input sshot_err_reg;

//////////////////////////////////////////////////////////////////
// WIRES
//////////////////////////////////////////////////////////////////

wire [15:0]	ecch;
wire [15:0]	eccl;
wire [15:0]	dp_mux_ecc_hi;
wire [15:0]	dp_mux_ecc_pre_xor_hi;
wire [15:0]	dp_mux_ecc_lo;
wire [15:0]	dp_mux_ecc_pre_xor_lo;
wire [287:0]	dp_pad_data;
wire [287:0]	dp_wr_data_muxed_nibbles;
wire [255:0]	dp_mux_data;
wire [33:0]	dp_scrb_ecc0;
wire [33:0]	dp_scrb_ecc1;
wire 		dp_scrb_data_en_cnt_in;
wire 		dp_scrb_data_en_cnt;
wire		dp_scrb_wr_en;
wire		dp_scrb_data0_en;
wire		dp_scrb_data1_en;
wire		dp_scrb_data_en;
wire [255:0]	dp_scrb_cor_data;
wire [255:0]	dp_scrb_data0;
wire [255:0]	dp_scrb_data1;
wire [33:0]	dp_scrb_cor_ecc;
wire [3:0]	dp_data_mecc0_int;
wire [3:0]	dp_data_mecc1_int;
wire [3:0]	dp_data_mecc2_int;
wire [3:0]	dp_data_mecc3_int;
wire [3:0]	dp_data_mecc4_int;
wire [3:0]	dp_data_mecc5_int;
wire [3:0]	dp_data_mecc6_int;
wire [3:0]	dp_data_mecc7_int;
wire 		dp_scrb_wr_data_en_cnt_in;
wire 		dp_scrb_wr_data_en_cnt;

//////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////

////////////////////////////////////////////////
// Scrub and Initial data
////////////////////////////////////////////////

// Flop the scrb enable and data from cpu clk to dramclk
dffrl_ns #(1)   ff_data_en(
                .din(l2if_scrb_data_en),
                .q(dp_scrb_data_en),
		.rst_l(rst_l),
                .clk(clk));

dff_ns #(256)   ff_l2_scrb_data(
                .din(l2if_scrb_data[255:0]),
                .q(dp_scrb_cor_data[255:0]),
                .clk(clk));

dff_ns #(34)    ff_l2_scrb_ecc(
                .din(l2if_scrb_ecc[33:0]),
                .q(dp_scrb_cor_ecc[33:0]),
                .clk(clk));

// counter to keep track of data enable for capturing scrb data

assign dp_scrb_wr_en = dp_scrb_data_en | (|(dp_scrb_data_en_cnt));
assign dp_scrb_data_en_cnt_in = dp_scrb_data_en_cnt + 1'b1;

dffrle_ns #(1)  ff_wr_en(
                .din(dp_scrb_data_en_cnt_in),
                .q(dp_scrb_data_en_cnt),
		.rst_l(rst_l),
		.en(dp_scrb_wr_en),
                .clk(clk));

assign dp_scrb_data0_en = dp_scrb_data_en & (dp_scrb_data_en_cnt == 1'h0);
assign dp_scrb_data1_en = dp_scrb_data_en & (dp_scrb_data_en_cnt == 1'h1);

// scrub and initial data holders waiting to be written to dram

dffrle_ns #(256) ff_scrb_wr_data0(
                .din({dp_scrb_cor_data[63:0],dp_scrb_cor_data[127:64], dp_scrb_cor_data[191:128], 
				dp_scrb_cor_data[255:192]}),
                .q(dp_scrb_data0[255:0]),
		.rst_l(rst_l),
		.en(dp_scrb_data0_en),
                .clk(clk));

dffrle_ns #(34) ff_scrb_wr_ecc0(
                .din(dp_scrb_cor_ecc[33:0]),
                .q(dp_scrb_ecc0[33:0]),
		.rst_l(rst_l),
		.en(dp_scrb_data0_en),
                .clk(clk));

dffrle_ns #(256)    ff_scrb_wr_data1(
                .din({dp_scrb_cor_data[63:0],dp_scrb_cor_data[127:64], dp_scrb_cor_data[191:128], 
				dp_scrb_cor_data[255:192]}),
                .q(dp_scrb_data1[255:0]),
		.rst_l(rst_l),
		.en(dp_scrb_data1_en),
                .clk(clk));

dffrle_ns #(34) ff_scrb_wr_ecc1(
                .din(dp_scrb_cor_ecc[33:0]),
                .q(dp_scrb_ecc1[33:0]),
		.rst_l(rst_l),
		.en(dp_scrb_data1_en),
                .clk(clk));

/////////////////////////////////////////
// Check if l2 data needs to be piosoned
/////////////////////////////////////////

wire [3:0]	dp_pioson_l2_data;
wire [1:0]	dp_pioson_l2_chunk;
wire [3:0]	que_mem_addr_d1;
wire		que_dp_wr_data_vld;

dffrl_ns #(32) ff_data_mecc(
	.din({l2if_data_mecc0[3:0],l2if_data_mecc1[3:0],l2if_data_mecc2[3:0],l2if_data_mecc3[3:0],
	    l2if_data_mecc4[3:0],l2if_data_mecc5[3:0],l2if_data_mecc6[3:0],l2if_data_mecc7[3:0]}),
        .q({dp_data_mecc0[3:0],dp_data_mecc1[3:0],dp_data_mecc2[3:0],dp_data_mecc3[3:0],
		dp_data_mecc4[3:0],dp_data_mecc5[3:0],dp_data_mecc6[3:0],dp_data_mecc7[3:0]}),
	.rst_l(rst_l),
        .clk(clk));

assign dp_data_mecc0_int = que_wr_channel_mux ? ch1_dp_data_mecc0 : dp_data_mecc0;
assign dp_data_mecc1_int = que_wr_channel_mux ? ch1_dp_data_mecc1 : dp_data_mecc1;
assign dp_data_mecc2_int = que_wr_channel_mux ? ch1_dp_data_mecc2 : dp_data_mecc2;
assign dp_data_mecc3_int = que_wr_channel_mux ? ch1_dp_data_mecc3 : dp_data_mecc3;
assign dp_data_mecc4_int = que_wr_channel_mux ? ch1_dp_data_mecc4 : dp_data_mecc4;
assign dp_data_mecc5_int = que_wr_channel_mux ? ch1_dp_data_mecc5 : dp_data_mecc5;
assign dp_data_mecc6_int = que_wr_channel_mux ? ch1_dp_data_mecc6 : dp_data_mecc6;
assign dp_data_mecc7_int = que_wr_channel_mux ? ch1_dp_data_mecc7 : dp_data_mecc7;

assign dp_pioson_l2_data[3:0] = (que_mem_addr_d1[3:1] == 3'h0) ? dp_data_mecc0_int[3:0] :
				(que_mem_addr_d1[3:1] == 3'h1) ? dp_data_mecc1_int[3:0] :
				(que_mem_addr_d1[3:1] == 3'h2) ? dp_data_mecc2_int[3:0] :
				(que_mem_addr_d1[3:1] == 3'h3) ? dp_data_mecc3_int[3:0] :
				(que_mem_addr_d1[3:1] == 3'h4) ? dp_data_mecc4_int[3:0] :
				(que_mem_addr_d1[3:1] == 3'h5) ? dp_data_mecc5_int[3:0] :
				(que_mem_addr_d1[3:1] == 3'h6) ? dp_data_mecc6_int[3:0] :
				(que_mem_addr_d1[3:1] == 3'h7) ? dp_data_mecc7_int[3:0] : 4'h0;

dff_ns #(5)	ff_mem_addr(
		.din(que_mem_addr[4:0]),
		.q({que_dp_wr_data_vld, que_mem_addr_d1[3:0]}),
		.clk(clk));

assign dp_pioson_l2_chunk = ( (que_bypass_scrb_data & dp_scrb_wr_data_en_cnt == 1'b0) |
				(~dp_scrb_data1_en & dp_scrb_wr_data_en_cnt == 1'b1) ) ? 2'h0 :
				(que_mem_addr_d1[0] == 1'b0) ? dp_pioson_l2_data[1:0] :
								dp_pioson_l2_data[3:2]; 

// counter to keep track of scrb write back data bypass enable

wire dp_scrb_wr_data_en = que_bypass_scrb_data | dp_scrb_wr_data_en_cnt;
assign dp_scrb_wr_data_en_cnt_in = dp_scrb_wr_data_en_cnt + 1'b1;

dffrle_ns #(1)  ff_wr_data_en(
                .din(dp_scrb_wr_data_en_cnt_in),
                .q(dp_scrb_wr_data_en_cnt),
                .rst_l(rst_l),
                .en(dp_scrb_wr_data_en),
                .clk(clk));

assign dp_mux_data[255:0] = 
		~que_channel_disabled & (que_bypass_scrb_data & dp_scrb_wr_data_en_cnt == 1'b0) ? 
				dp_scrb_data0[255:0] :
		~que_channel_disabled & (~dp_scrb_data1_en & dp_scrb_wr_data_en_cnt == 1'b1) ? 
				dp_scrb_data1[255:0] :
		~que_channel_disabled & ~que_dp_wr_data_vld ? que_mem_data[255:0] : 
			que_wr_channel_mux ? ch1_que_mem_data : 256'h0;

dram_ecc_gen	ecc_gen_h(
   			// Outputs
   			.ecc(dp_mux_ecc_pre_xor_hi),
   			// Intputs
			.data({dp_mux_data[191:128], dp_mux_data[255:192]}));

dram_ecc_gen	ecc_gen_l(
   			// Outputs
   			.ecc(dp_mux_ecc_pre_xor_lo),
   			// Intputs
			.data({dp_mux_data[63:0], dp_mux_data[127:64]}));

// Need to XOR ecc generated with address parity
// Save the parity till the memory addr is not changed or a new store happens
// que_st_cmd_addr_parity is one cycle ahead of data for stores

dffe_ns #(1)  	ff_st_addr_parity(
                .din(que_st_cmd_addr_parity),
                .q(dp_mem_st_cmd_addr_parity),
		.en(~que_mem_addr[0]),
                .clk(clk));

// Save the parity till two cycles for scrub as the data is written back to back to memory

dff_ns #(1)  	ff_st_addr_parity_d1(
                .din(que_st_cmd_addr_parity),
                .q(que_scrb_cmd_addr_parity_d1),
                .clk(clk));

dff_ns #(1)  	ff_st_addr_parity_d2(
                .din(que_scrb_cmd_addr_parity_d1),
                .q(que_scrb_cmd_addr_parity_d2),
                .clk(clk));

wire dp_st_cmd_addr_parity = que_bypass_scrb_data ? que_scrb_cmd_addr_parity_d1 : 
				(~dp_scrb_data1_en & dp_scrb_wr_data_en_cnt == 1'b1) ? que_scrb_cmd_addr_parity_d2 :
				dp_mem_st_cmd_addr_parity;
assign dp_mux_ecc_hi = dp_mux_ecc_pre_xor_hi ^ {16{dp_st_cmd_addr_parity}};
assign dp_mux_ecc_lo = dp_mux_ecc_pre_xor_lo ^ {16{dp_st_cmd_addr_parity}};

assign ecch[15:0] = (que_bypass_scrb_data & dp_scrb_wr_data_en_cnt == 1'b0 & dp_scrb_ecc0[32]) ? 
				dp_scrb_ecc0[15:0] :
		(~dp_scrb_data1_en & dp_scrb_wr_data_en_cnt == 1'b1 & dp_scrb_ecc1[32]) ? 
				dp_scrb_ecc1[15:0] : dp_mux_ecc_hi[15:0]; 

assign eccl[15:0] = (que_bypass_scrb_data & dp_scrb_wr_data_en_cnt == 1'b0 & dp_scrb_ecc0[33]) ? 
				dp_scrb_ecc0[31:16] :
		(~dp_scrb_data1_en & dp_scrb_wr_data_en_cnt == 1'b1 & dp_scrb_ecc1[33]) ? 
				dp_scrb_ecc1[31:16] : dp_mux_ecc_lo[15:0]; 

// Generate 16 bit vector that injects error
wire [15:0]	dp_err_inj_vec;

assign dp_err_inj_vec = {16{err_inj_reg}} & err_mask_reg[15:0];

assign dp_pad_data[287:0] = {dp_pioson_l2_chunk[1] ^ ecch[15] ^ (dp_err_inj_vec[15] & ~sshot_err_reg), 
				ecch[14:9] ^ (dp_err_inj_vec[14:9] & {6{~sshot_err_reg}}), 
			dp_pioson_l2_chunk[1] ^ ecch[8] ^ (dp_err_inj_vec[8] & ~sshot_err_reg), 
				ecch[7:5] ^ (dp_err_inj_vec[7:5] & {3{~sshot_err_reg}}), 
			dp_pioson_l2_chunk[1] ^ ecch[4] ^ (dp_err_inj_vec[4] & ~sshot_err_reg), 
				ecch[3:1] ^ (dp_err_inj_vec[3:1] & {3{~sshot_err_reg}}), 
			dp_pioson_l2_chunk[1] ^ ecch[0] ^ (dp_err_inj_vec[0] & ~sshot_err_reg), 
			dp_mux_data[191:128], dp_mux_data[255:192],
			dp_pioson_l2_chunk[0] ^ eccl[15] ^ dp_err_inj_vec[15], 
				eccl[14:9] ^ dp_err_inj_vec[14:9], 
			dp_pioson_l2_chunk[0] ^ eccl[8] ^ dp_err_inj_vec[8], 
				eccl[7:5] ^ dp_err_inj_vec[7:5], 
			dp_pioson_l2_chunk[0] ^ eccl[4] ^ dp_err_inj_vec[4], 
				eccl[3:1] ^ dp_err_inj_vec[3:1], 
			dp_pioson_l2_chunk[0] ^ eccl[0] ^ dp_err_inj_vec[0], 
				dp_mux_data[63:0], dp_mux_data[127:64]}; 

dff_ns #(288)   ff_wr_pad_data(
                .din(dp_pad_data[287:0]),
                .q(dp_wr_data_muxed_nibbles[287:0]),
                .clk(clk));

// ecc[287:272]
assign dram_io_data_out[287:284] = dram_fail_over_mask[31] ? dp_wr_data_muxed_nibbles[271:268] : dp_wr_data_muxed_nibbles[287:284];
assign dram_io_data_out[283:280] = dram_fail_over_mask[32] ? dp_wr_data_muxed_nibbles[287:284] : dp_wr_data_muxed_nibbles[283:280];
assign dram_io_data_out[279:276] = dram_fail_over_mask[33] ? dp_wr_data_muxed_nibbles[283:280] : dp_wr_data_muxed_nibbles[279:276];
assign dram_io_data_out[275:272] = dram_fail_over_mask[34] ? dp_wr_data_muxed_nibbles[279:276] : dp_wr_data_muxed_nibbles[275:272];

// data[271:144]
assign dram_io_data_out[271:268] = dram_fail_over_mask[30] ? dp_wr_data_muxed_nibbles[267:264] : dp_wr_data_muxed_nibbles[271:268];
assign dram_io_data_out[267:264] = dram_fail_over_mask[29] ? dp_wr_data_muxed_nibbles[263:260] : dp_wr_data_muxed_nibbles[267:264]; 
assign dram_io_data_out[263:260] = dram_fail_over_mask[28] ? dp_wr_data_muxed_nibbles[259:256] : dp_wr_data_muxed_nibbles[263:260]; 
assign dram_io_data_out[259:256] = dram_fail_over_mask[27] ? dp_wr_data_muxed_nibbles[255:252] : dp_wr_data_muxed_nibbles[259:256]; 
assign dram_io_data_out[255:252] = dram_fail_over_mask[26] ? dp_wr_data_muxed_nibbles[251:248] : dp_wr_data_muxed_nibbles[255:252]; 
assign dram_io_data_out[251:248] = dram_fail_over_mask[25] ? dp_wr_data_muxed_nibbles[247:244] : dp_wr_data_muxed_nibbles[251:248]; 
assign dram_io_data_out[247:244] = dram_fail_over_mask[24] ? dp_wr_data_muxed_nibbles[243:240] : dp_wr_data_muxed_nibbles[247:244]; 
assign dram_io_data_out[243:240] = dram_fail_over_mask[23] ? dp_wr_data_muxed_nibbles[239:236] : dp_wr_data_muxed_nibbles[243:240]; 
assign dram_io_data_out[239:236] = dram_fail_over_mask[22] ? dp_wr_data_muxed_nibbles[235:232] : dp_wr_data_muxed_nibbles[239:236]; 
assign dram_io_data_out[235:232] = dram_fail_over_mask[21] ? dp_wr_data_muxed_nibbles[231:228] : dp_wr_data_muxed_nibbles[235:232]; 
assign dram_io_data_out[231:228] = dram_fail_over_mask[20] ? dp_wr_data_muxed_nibbles[227:224] : dp_wr_data_muxed_nibbles[231:228]; 
assign dram_io_data_out[227:224] = dram_fail_over_mask[19] ? dp_wr_data_muxed_nibbles[223:220] : dp_wr_data_muxed_nibbles[227:224]; 
assign dram_io_data_out[223:220] = dram_fail_over_mask[18] ? dp_wr_data_muxed_nibbles[219:216] : dp_wr_data_muxed_nibbles[223:220]; 
assign dram_io_data_out[219:216] = dram_fail_over_mask[17] ? dp_wr_data_muxed_nibbles[215:212] : dp_wr_data_muxed_nibbles[219:216]; 
assign dram_io_data_out[215:212] = dram_fail_over_mask[16] ? dp_wr_data_muxed_nibbles[211:208] : dp_wr_data_muxed_nibbles[215:212]; 
assign dram_io_data_out[211:208] = dram_fail_over_mask[15] ? dp_wr_data_muxed_nibbles[207:204] : dp_wr_data_muxed_nibbles[211:208]; 
assign dram_io_data_out[207:204] = dram_fail_over_mask[14] ? dp_wr_data_muxed_nibbles[203:200] : dp_wr_data_muxed_nibbles[207:204]; 
assign dram_io_data_out[203:200] = dram_fail_over_mask[13] ? dp_wr_data_muxed_nibbles[199:196] : dp_wr_data_muxed_nibbles[203:200]; 
assign dram_io_data_out[199:196] = dram_fail_over_mask[12] ? dp_wr_data_muxed_nibbles[195:192] : dp_wr_data_muxed_nibbles[199:196]; 
assign dram_io_data_out[195:192] = dram_fail_over_mask[11] ? dp_wr_data_muxed_nibbles[191:188] : dp_wr_data_muxed_nibbles[195:192]; 
assign dram_io_data_out[191:188] = dram_fail_over_mask[10] ? dp_wr_data_muxed_nibbles[187:184] : dp_wr_data_muxed_nibbles[191:188]; 
assign dram_io_data_out[187:184] = dram_fail_over_mask[9] ? dp_wr_data_muxed_nibbles[183:180] : dp_wr_data_muxed_nibbles[187:184]; 
assign dram_io_data_out[183:180] = dram_fail_over_mask[8] ? dp_wr_data_muxed_nibbles[179:176] : dp_wr_data_muxed_nibbles[183:180]; 
assign dram_io_data_out[179:176] = dram_fail_over_mask[7] ? dp_wr_data_muxed_nibbles[175:172] : dp_wr_data_muxed_nibbles[179:176]; 
assign dram_io_data_out[175:172] = dram_fail_over_mask[6] ? dp_wr_data_muxed_nibbles[171:168] : dp_wr_data_muxed_nibbles[175:172]; 
assign dram_io_data_out[171:168] = dram_fail_over_mask[5] ? dp_wr_data_muxed_nibbles[167:164] : dp_wr_data_muxed_nibbles[171:168]; 
assign dram_io_data_out[167:164] = dram_fail_over_mask[4] ? dp_wr_data_muxed_nibbles[163:160] : dp_wr_data_muxed_nibbles[167:164]; 
assign dram_io_data_out[163:160] = dram_fail_over_mask[3] ? dp_wr_data_muxed_nibbles[159:156] : dp_wr_data_muxed_nibbles[163:160]; 
assign dram_io_data_out[159:156] = dram_fail_over_mask[2] ? dp_wr_data_muxed_nibbles[155:152] : dp_wr_data_muxed_nibbles[159:156]; 
assign dram_io_data_out[155:152] = dram_fail_over_mask[1] ? dp_wr_data_muxed_nibbles[151:148] : dp_wr_data_muxed_nibbles[155:152]; 
assign dram_io_data_out[151:148] = dram_fail_over_mask[0] ? dp_wr_data_muxed_nibbles[147:144] : dp_wr_data_muxed_nibbles[151:148]; 
assign dram_io_data_out[147:144] = dp_wr_data_muxed_nibbles[147:144]; 

// ecc[143:128]
assign dram_io_data_out[143:140] = dram_fail_over_mask[31] ? dp_wr_data_muxed_nibbles[127:124] : dp_wr_data_muxed_nibbles[143:140];
assign dram_io_data_out[139:136] = dram_fail_over_mask[32] ? dp_wr_data_muxed_nibbles[143:140] : dp_wr_data_muxed_nibbles[139:136];
assign dram_io_data_out[135:132] = dram_fail_over_mask[33] ? dp_wr_data_muxed_nibbles[139:136] : dp_wr_data_muxed_nibbles[135:132];
assign dram_io_data_out[131:128] = dram_fail_over_mask[34] ? dp_wr_data_muxed_nibbles[135:132] : dp_wr_data_muxed_nibbles[131:128];

// data[127:0]
assign dram_io_data_out[127:124] = dram_fail_over_mask[30] ? dp_wr_data_muxed_nibbles[123:120] : dp_wr_data_muxed_nibbles[127:124];
assign dram_io_data_out[123:120] = dram_fail_over_mask[29] ? dp_wr_data_muxed_nibbles[119:116] : dp_wr_data_muxed_nibbles[123:120]; 
assign dram_io_data_out[119:116] = dram_fail_over_mask[28] ? dp_wr_data_muxed_nibbles[115:112] : dp_wr_data_muxed_nibbles[119:116]; 
assign dram_io_data_out[115:112] = dram_fail_over_mask[27] ? dp_wr_data_muxed_nibbles[111:108] : dp_wr_data_muxed_nibbles[115:112]; 
assign dram_io_data_out[111:108] = dram_fail_over_mask[26] ? dp_wr_data_muxed_nibbles[107:104] : dp_wr_data_muxed_nibbles[111:108]; 
assign dram_io_data_out[107:104] = dram_fail_over_mask[25] ? dp_wr_data_muxed_nibbles[103:100] : dp_wr_data_muxed_nibbles[107:104]; 
assign dram_io_data_out[103:100] = dram_fail_over_mask[24] ? dp_wr_data_muxed_nibbles[99:96] : dp_wr_data_muxed_nibbles[103:100]; 
assign dram_io_data_out[99:96] = dram_fail_over_mask[23] ? dp_wr_data_muxed_nibbles[95:92] : dp_wr_data_muxed_nibbles[99:96]; 
assign dram_io_data_out[95:92] = dram_fail_over_mask[22] ? dp_wr_data_muxed_nibbles[91:88] : dp_wr_data_muxed_nibbles[95:92]; 
assign dram_io_data_out[91:88] = dram_fail_over_mask[21] ? dp_wr_data_muxed_nibbles[87:84] : dp_wr_data_muxed_nibbles[91:88]; 
assign dram_io_data_out[87:84] = dram_fail_over_mask[20] ? dp_wr_data_muxed_nibbles[83:80] : dp_wr_data_muxed_nibbles[87:84]; 
assign dram_io_data_out[83:80] = dram_fail_over_mask[19] ? dp_wr_data_muxed_nibbles[79:76] : dp_wr_data_muxed_nibbles[83:80]; 
assign dram_io_data_out[79:76] = dram_fail_over_mask[18] ? dp_wr_data_muxed_nibbles[75:72] : dp_wr_data_muxed_nibbles[79:76]; 
assign dram_io_data_out[75:72] = dram_fail_over_mask[17] ? dp_wr_data_muxed_nibbles[71:68] : dp_wr_data_muxed_nibbles[75:72]; 
assign dram_io_data_out[71:68] = dram_fail_over_mask[16] ? dp_wr_data_muxed_nibbles[67:64] : dp_wr_data_muxed_nibbles[71:68]; 
assign dram_io_data_out[67:64] = dram_fail_over_mask[15] ? dp_wr_data_muxed_nibbles[63:60] : dp_wr_data_muxed_nibbles[67:64]; 
assign dram_io_data_out[63:60] = dram_fail_over_mask[14] ? dp_wr_data_muxed_nibbles[59:56] : dp_wr_data_muxed_nibbles[63:60]; 
assign dram_io_data_out[59:56] = dram_fail_over_mask[13] ? dp_wr_data_muxed_nibbles[55:52] : dp_wr_data_muxed_nibbles[59:56]; 
assign dram_io_data_out[55:52] = dram_fail_over_mask[12] ? dp_wr_data_muxed_nibbles[51:48] : dp_wr_data_muxed_nibbles[55:52]; 
assign dram_io_data_out[51:48] = dram_fail_over_mask[11] ? dp_wr_data_muxed_nibbles[47:44] : dp_wr_data_muxed_nibbles[51:48]; 
assign dram_io_data_out[47:44] = dram_fail_over_mask[10] ? dp_wr_data_muxed_nibbles[43:40] : dp_wr_data_muxed_nibbles[47:44]; 
assign dram_io_data_out[43:40] = dram_fail_over_mask[9] ? dp_wr_data_muxed_nibbles[39:36] : dp_wr_data_muxed_nibbles[43:40]; 
assign dram_io_data_out[39:36] = dram_fail_over_mask[8] ? dp_wr_data_muxed_nibbles[35:32] : dp_wr_data_muxed_nibbles[39:36]; 
assign dram_io_data_out[35:32] = dram_fail_over_mask[7] ? dp_wr_data_muxed_nibbles[31:28] : dp_wr_data_muxed_nibbles[35:32]; 
assign dram_io_data_out[31:28] = dram_fail_over_mask[6] ? dp_wr_data_muxed_nibbles[27:24] : dp_wr_data_muxed_nibbles[31:28]; 
assign dram_io_data_out[27:24] = dram_fail_over_mask[5] ? dp_wr_data_muxed_nibbles[23:20] : dp_wr_data_muxed_nibbles[27:24]; 
assign dram_io_data_out[23:20] = dram_fail_over_mask[4] ? dp_wr_data_muxed_nibbles[19:16] : dp_wr_data_muxed_nibbles[23:20]; 
assign dram_io_data_out[19:16] = dram_fail_over_mask[3] ? dp_wr_data_muxed_nibbles[15:12] : dp_wr_data_muxed_nibbles[19:16]; 
assign dram_io_data_out[15:12] = dram_fail_over_mask[2] ? dp_wr_data_muxed_nibbles[11:8] : dp_wr_data_muxed_nibbles[15:12]; 
assign dram_io_data_out[11:8] = dram_fail_over_mask[1] ? dp_wr_data_muxed_nibbles[7:4] : dp_wr_data_muxed_nibbles[11:8]; 
assign dram_io_data_out[7:4] = dram_fail_over_mask[0] ? dp_wr_data_muxed_nibbles[3:0] : dp_wr_data_muxed_nibbles[7:4]; 
assign dram_io_data_out[3:0] = dp_wr_data_muxed_nibbles[3:0]; 

// Counter to generate data valid for 2 consecutive cycles from one cycle pulse.
wire 		dp_data_vld_cnt_in;
wire 		dp_data_vld_cnt;
wire		dp_data_valid_in;

assign dp_data_vld_cnt_in = dp_data_vld_cnt + 1'b1;
assign dp_data_valid_in =  io_dram_data_valid | (|dp_data_vld_cnt);

dffrle_ns #(1)   ff_data_valid_cnt(
                .din(dp_data_vld_cnt_in),
                .q(dp_data_vld_cnt),
		.rst_l(rst_l),
		.en(dp_data_valid_in),
                .clk(clk));

dffrl_ns #(1)    ff_l2_data_valid(
                .din(dp_data_valid_in),
                .q(dp_data_valid),
		.rst_l(rst_l),
                .clk(clk));

// Forwarding data from pad to L2 cpu clk domain
// Before that we have implement the reverse of fail over mode mux we introduced.
wire [255:0]	dp_rd_data_muxed_nibbles;
wire [31:0]	dp_rd_ecc_muxed_nibbles;

// ecc[31:16]
assign dp_rd_ecc_muxed_nibbles[31:28] = dram_fail_over_mask[32] ? io_dram_ecc_in[27:24] : io_dram_ecc_in[31:28]; 
assign dp_rd_ecc_muxed_nibbles[27:24] = dram_fail_over_mask[33] ? io_dram_ecc_in[23:20] : io_dram_ecc_in[27:24]; 
assign dp_rd_ecc_muxed_nibbles[23:20] = dram_fail_over_mask[34] ? io_dram_ecc_in[19:16] : io_dram_ecc_in[23:20]; 
assign dp_rd_ecc_muxed_nibbles[19:16] = io_dram_ecc_in[19:16]; 

// data[255:128]
assign dp_rd_data_muxed_nibbles[255:252] = dram_fail_over_mask[31] ? io_dram_ecc_in[31:28] : io_dram_data_in[255:252];
assign dp_rd_data_muxed_nibbles[251:248] = dram_fail_over_mask[30] ? io_dram_data_in[255:252] : io_dram_data_in[251:248];
assign dp_rd_data_muxed_nibbles[247:244] = dram_fail_over_mask[29] ? io_dram_data_in[251:248] : io_dram_data_in[247:244]; 
assign dp_rd_data_muxed_nibbles[243:240] = dram_fail_over_mask[28] ? io_dram_data_in[247:244] : io_dram_data_in[243:240]; 
assign dp_rd_data_muxed_nibbles[239:236] = dram_fail_over_mask[27] ? io_dram_data_in[243:240] : io_dram_data_in[239:236]; 
assign dp_rd_data_muxed_nibbles[235:232] = dram_fail_over_mask[26] ? io_dram_data_in[239:236] : io_dram_data_in[235:232]; 
assign dp_rd_data_muxed_nibbles[231:228] = dram_fail_over_mask[25] ? io_dram_data_in[235:232] : io_dram_data_in[231:228]; 
assign dp_rd_data_muxed_nibbles[227:224] = dram_fail_over_mask[24] ? io_dram_data_in[231:228] : io_dram_data_in[227:224]; 
assign dp_rd_data_muxed_nibbles[223:220] = dram_fail_over_mask[23] ? io_dram_data_in[227:224] : io_dram_data_in[223:220]; 
assign dp_rd_data_muxed_nibbles[219:216] = dram_fail_over_mask[22] ? io_dram_data_in[223:220] : io_dram_data_in[219:216]; 
assign dp_rd_data_muxed_nibbles[215:212] = dram_fail_over_mask[21] ? io_dram_data_in[219:216] : io_dram_data_in[215:212]; 
assign dp_rd_data_muxed_nibbles[211:208] = dram_fail_over_mask[20] ? io_dram_data_in[215:212] : io_dram_data_in[211:208]; 
assign dp_rd_data_muxed_nibbles[207:204] = dram_fail_over_mask[19] ? io_dram_data_in[211:208] : io_dram_data_in[207:204]; 
assign dp_rd_data_muxed_nibbles[203:200] = dram_fail_over_mask[18] ? io_dram_data_in[207:204] : io_dram_data_in[203:200]; 
assign dp_rd_data_muxed_nibbles[199:196] = dram_fail_over_mask[17] ? io_dram_data_in[203:200] : io_dram_data_in[199:196]; 
assign dp_rd_data_muxed_nibbles[195:192] = dram_fail_over_mask[16] ? io_dram_data_in[199:196] : io_dram_data_in[195:192]; 
assign dp_rd_data_muxed_nibbles[191:188] = dram_fail_over_mask[15] ? io_dram_data_in[195:192] : io_dram_data_in[191:188]; 
assign dp_rd_data_muxed_nibbles[187:184] = dram_fail_over_mask[14] ? io_dram_data_in[191:188] : io_dram_data_in[187:184]; 
assign dp_rd_data_muxed_nibbles[183:180] = dram_fail_over_mask[13] ? io_dram_data_in[187:184] : io_dram_data_in[183:180]; 
assign dp_rd_data_muxed_nibbles[179:176] = dram_fail_over_mask[12] ? io_dram_data_in[183:180] : io_dram_data_in[179:176]; 
assign dp_rd_data_muxed_nibbles[175:172] = dram_fail_over_mask[11] ? io_dram_data_in[179:176] : io_dram_data_in[175:172]; 
assign dp_rd_data_muxed_nibbles[171:168] = dram_fail_over_mask[10] ? io_dram_data_in[175:172] : io_dram_data_in[171:168]; 
assign dp_rd_data_muxed_nibbles[167:164] = dram_fail_over_mask[9] ? io_dram_data_in[171:168] : io_dram_data_in[167:164]; 
assign dp_rd_data_muxed_nibbles[163:160] = dram_fail_over_mask[8] ? io_dram_data_in[167:164] : io_dram_data_in[163:160]; 
assign dp_rd_data_muxed_nibbles[159:156] = dram_fail_over_mask[7] ? io_dram_data_in[163:160] : io_dram_data_in[159:156]; 
assign dp_rd_data_muxed_nibbles[155:152] = dram_fail_over_mask[6] ? io_dram_data_in[159:156] : io_dram_data_in[155:152]; 
assign dp_rd_data_muxed_nibbles[151:148] = dram_fail_over_mask[5] ? io_dram_data_in[155:152] : io_dram_data_in[151:148]; 
assign dp_rd_data_muxed_nibbles[147:144] = dram_fail_over_mask[4] ? io_dram_data_in[151:148] : io_dram_data_in[147:144]; 
assign dp_rd_data_muxed_nibbles[143:140] = dram_fail_over_mask[3] ? io_dram_data_in[147:144] : io_dram_data_in[143:140]; 
assign dp_rd_data_muxed_nibbles[139:136] = dram_fail_over_mask[2] ? io_dram_data_in[143:140] : io_dram_data_in[139:136]; 
assign dp_rd_data_muxed_nibbles[135:132] = dram_fail_over_mask[1] ? io_dram_data_in[139:136] : io_dram_data_in[135:132]; 
assign dp_rd_data_muxed_nibbles[131:128] = dram_fail_over_mask[0] ? io_dram_data_in[135:132] : io_dram_data_in[131:128]; 

// ecc[15:0]
assign dp_rd_ecc_muxed_nibbles[15:12] = dram_fail_over_mask[32] ? io_dram_ecc_in[11:8] : io_dram_ecc_in[15:12]; 
assign dp_rd_ecc_muxed_nibbles[11:8] = dram_fail_over_mask[33] ? io_dram_ecc_in[7:4] : io_dram_ecc_in[11:8]; 
assign dp_rd_ecc_muxed_nibbles[7:4] = dram_fail_over_mask[34] ? io_dram_ecc_in[3:0] : io_dram_ecc_in[7:4]; 
assign dp_rd_ecc_muxed_nibbles[3:0] = io_dram_ecc_in[3:0]; 

// data[127:0]
assign dp_rd_data_muxed_nibbles[127:124] = dram_fail_over_mask[31] ? io_dram_ecc_in[15:12] : io_dram_data_in[127:124]; 
assign dp_rd_data_muxed_nibbles[123:120] = dram_fail_over_mask[30] ? io_dram_data_in[127:124] : io_dram_data_in[123:120]; 
assign dp_rd_data_muxed_nibbles[119:116] = dram_fail_over_mask[29] ? io_dram_data_in[123:120] : io_dram_data_in[119:116]; 
assign dp_rd_data_muxed_nibbles[115:112] = dram_fail_over_mask[28] ? io_dram_data_in[119:116] : io_dram_data_in[115:112]; 
assign dp_rd_data_muxed_nibbles[111:108] = dram_fail_over_mask[27] ? io_dram_data_in[115:112] : io_dram_data_in[111:108]; 
assign dp_rd_data_muxed_nibbles[107:104] = dram_fail_over_mask[26] ? io_dram_data_in[111:108] : io_dram_data_in[107:104]; 
assign dp_rd_data_muxed_nibbles[103:100] = dram_fail_over_mask[25] ? io_dram_data_in[107:104] : io_dram_data_in[103:100]; 
assign dp_rd_data_muxed_nibbles[99:96] = dram_fail_over_mask[24] ? io_dram_data_in[103:100] : io_dram_data_in[99:96]; 
assign dp_rd_data_muxed_nibbles[95:92] = dram_fail_over_mask[23] ? io_dram_data_in[99:96] : io_dram_data_in[95:92]; 
assign dp_rd_data_muxed_nibbles[91:88] = dram_fail_over_mask[22] ? io_dram_data_in[95:92] : io_dram_data_in[91:88]; 
assign dp_rd_data_muxed_nibbles[87:84] = dram_fail_over_mask[21] ? io_dram_data_in[91:88] : io_dram_data_in[87:84]; 
assign dp_rd_data_muxed_nibbles[83:80] = dram_fail_over_mask[20] ? io_dram_data_in[87:84] : io_dram_data_in[83:80]; 
assign dp_rd_data_muxed_nibbles[79:76] = dram_fail_over_mask[19] ? io_dram_data_in[83:80] : io_dram_data_in[79:76]; 
assign dp_rd_data_muxed_nibbles[75:72] = dram_fail_over_mask[18] ? io_dram_data_in[79:76] : io_dram_data_in[75:72]; 
assign dp_rd_data_muxed_nibbles[71:68] = dram_fail_over_mask[17] ? io_dram_data_in[75:72] : io_dram_data_in[71:68]; 
assign dp_rd_data_muxed_nibbles[67:64] = dram_fail_over_mask[16] ? io_dram_data_in[71:68] : io_dram_data_in[67:64]; 
assign dp_rd_data_muxed_nibbles[63:60] = dram_fail_over_mask[15] ? io_dram_data_in[67:64] : io_dram_data_in[63:60]; 
assign dp_rd_data_muxed_nibbles[59:56] = dram_fail_over_mask[14] ? io_dram_data_in[63:60] : io_dram_data_in[59:56]; 
assign dp_rd_data_muxed_nibbles[55:52] = dram_fail_over_mask[13] ? io_dram_data_in[59:56] : io_dram_data_in[55:52]; 
assign dp_rd_data_muxed_nibbles[51:48] = dram_fail_over_mask[12] ? io_dram_data_in[55:52] : io_dram_data_in[51:48]; 
assign dp_rd_data_muxed_nibbles[47:44] = dram_fail_over_mask[11] ? io_dram_data_in[51:48] : io_dram_data_in[47:44]; 
assign dp_rd_data_muxed_nibbles[43:40] = dram_fail_over_mask[10] ? io_dram_data_in[47:44] : io_dram_data_in[43:40]; 
assign dp_rd_data_muxed_nibbles[39:36] = dram_fail_over_mask[9] ? io_dram_data_in[43:40] : io_dram_data_in[39:36]; 
assign dp_rd_data_muxed_nibbles[35:32] = dram_fail_over_mask[8] ? io_dram_data_in[39:36] : io_dram_data_in[35:32]; 
assign dp_rd_data_muxed_nibbles[31:28] = dram_fail_over_mask[7] ? io_dram_data_in[35:32] : io_dram_data_in[31:28]; 
assign dp_rd_data_muxed_nibbles[27:24] = dram_fail_over_mask[6] ? io_dram_data_in[31:28] : io_dram_data_in[27:24]; 
assign dp_rd_data_muxed_nibbles[23:20] = dram_fail_over_mask[5] ? io_dram_data_in[27:24] : io_dram_data_in[23:20]; 
assign dp_rd_data_muxed_nibbles[19:16] = dram_fail_over_mask[4] ? io_dram_data_in[23:20] : io_dram_data_in[19:16]; 
assign dp_rd_data_muxed_nibbles[15:12] = dram_fail_over_mask[3] ? io_dram_data_in[19:16] : io_dram_data_in[15:12]; 
assign dp_rd_data_muxed_nibbles[11:8] = dram_fail_over_mask[2] ? io_dram_data_in[15:12] : io_dram_data_in[11:8]; 
assign dp_rd_data_muxed_nibbles[7:4] = dram_fail_over_mask[1] ? io_dram_data_in[11:8] : io_dram_data_in[7:4]; 
assign dp_rd_data_muxed_nibbles[3:0] = dram_fail_over_mask[0] ? io_dram_data_in[7:4] : io_dram_data_in[3:0]; 

dff_ns #(288)      ff_l2_data(
                .din({dp_rd_ecc_muxed_nibbles[31:0], dp_rd_data_muxed_nibbles[255:0]}),
                .q({dp_ecc_in[31:0], dp_data_in[255:0]}),
                .clk(clk));

endmodule
