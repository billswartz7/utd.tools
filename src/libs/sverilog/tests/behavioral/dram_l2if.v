// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_l2if.v
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

module dram_l2if (/*AUTOARG*/
   // Outputs
   dram_ucb_ack_vld, dram_ucb_nack_vld, dram_ucb_data, 
   l2if_que_rd_req_vld, l2if_que_wr_req_vld, l2if_que_addr, 
   l2if_que_data, dram_sctag_chunk_id, dram_sctag_data_vld, 
   dram_sctag_rd_req_id, dram_sctag_data, dram_sctag_mecc_err, 
   dram_sctag_pa_err, dram_sctag_secc_err, dram_sctag_ecc, 
   dram_sctag_rd_ack, dram_sctag_wr_ack, l2if_data_mecc0, 
   l2if_data_mecc1, l2if_data_mecc2, l2if_data_mecc3, 
   l2if_data_mecc4, l2if_data_mecc5, l2if_data_mecc6, 
   l2if_data_mecc7, l2if_data_wr_addr, dram_cpu_wr_addr, 
   dram_cpu_wr_en, dram_cpu_wr_data, l2if_wr_req, l2if_rd_req, 
   l2if_rd_addr, l2if_wr_addr, l2if_rd_id, l2if_scrb_data_en, 
   l2if_scrb_data, l2if_scrb_ecc, l2if_err_loc, l2if_err_cnt, 
   l2if_dbg_trig_en, l2if_err_intr, dram_sctag_scb_mecc_err, 
   dram_sctag_scb_secc_err, l2if_err_addr_reg, l2if_err_sts_reg, 
   dram_data_val_other_ch, dp_data_valid_d1, l2if_channel_disabled, 
   err_loc, err_syn, l2if_ucb_trig, l2if_que_selfrsh, 
   // Inputs
   clk, rst_l, arst_l, ucb_l2if_selfrsh, que_wr_req,
   sctag_dram_rd_req, sctag_dram_rd_dummy_req, sctag_dram_rd_req_id, 
   sctag_dram_addr, sctag_dram_wr_req, sctag_dram_data_vld, 
   sctag_dram_wr_data, sctag_dram_data_mecc, readqbank0vld0, 
   readqbank0vld1, readqbank0vld2, readqbank0vld3, writeqbank0vld0, 
   writeqbank0vld1, writeqbank0vld2, writeqbank0vld3, readqbank0vld4, 
   readqbank0vld5, readqbank0vld6, readqbank0vld7, writeqbank0vld4, 
   writeqbank0vld5, writeqbank0vld6, writeqbank0vld7, que_scrb_addr, 
   dram_fail_over_mode, que_wr_entry_free, config_reg, 
   que_rank1_present, ucb_dram_rd_req_vld, ucb_dram_wr_req_vld, 
   ucb_dram_addr, ucb_dram_data, que_eight_bank_mode, 
   que_l2if_ack_vld, que_l2if_nack_vld, que_l2if_data, 
   que_dram_clk_toggle, dp_data_valid, que_l2if_send_info, 
   dp_data_in, dp_ecc_in, dram_dram_rx_sync, dram_dram_tx_sync, 
   dram_jbus_rx_sync, dram_jbus_tx_sync, que_addr_bank_low_sel, 
   que_channel_disabled, other_channel_disabled, ch0_err_loc, 
   ch0_err_syn, ch0_dp_data_valid_d1, ch0_dram_data_val_other_ch, 
   ch0_dram_sctag_chunk_id, ch0_dram_sctag_rd_req_id, 
   ch0_dram_sctag_data, ch0_dram_sctag_ecc, ch0_dram_sctag_mecc_err, 
   ch0_dram_sctag_pa_err, ch0_dram_sctag_secc_err
   );

   // DRAM controller  interface
input 		clk;
input 		rst_l;
input 		arst_l;

input		ucb_l2if_selfrsh;

// rd interface
input        	sctag_dram_rd_req;
input        	sctag_dram_rd_dummy_req;
input [2:0]     sctag_dram_rd_req_id;
input [39:5]    sctag_dram_addr;

// wr interface
input        	sctag_dram_wr_req;
input		sctag_dram_data_vld;
input [63:0] 	sctag_dram_wr_data;
input		sctag_dram_data_mecc;

input          	readqbank0vld0;
input          	readqbank0vld1;
input          	readqbank0vld2;
input          	readqbank0vld3;
input          	writeqbank0vld0;
input          	writeqbank0vld1;
input          	writeqbank0vld2;
input          	writeqbank0vld3;
input          	readqbank0vld4;
input          	readqbank0vld5;
input          	readqbank0vld6;
input          	readqbank0vld7;
input          	writeqbank0vld4;
input          	writeqbank0vld5;
input          	writeqbank0vld6;
input          	writeqbank0vld7;
input          	que_wr_req;

input [32:0]	que_scrb_addr;
input		dram_fail_over_mode;
input [3:0]	que_wr_entry_free;
input [8:0]	config_reg;
input		que_rank1_present;

// FROM UCB
input           ucb_dram_rd_req_vld;
input           ucb_dram_wr_req_vld;
input [31:0]    ucb_dram_addr;
input [63:0]    ucb_dram_data;

// TO UCB
output          dram_ucb_ack_vld;
output          dram_ucb_nack_vld;
output [63:0]   dram_ucb_data;

// TO QUE
output          l2if_que_rd_req_vld;
output          l2if_que_wr_req_vld;
output [31:0]   l2if_que_addr;
output [63:0]   l2if_que_data;

// FROM QUE
input		que_eight_bank_mode;
input          	que_l2if_ack_vld;
input          	que_l2if_nack_vld;
input [63:0]   	que_l2if_data;

// cas related info
input		que_dram_clk_toggle;
input		dp_data_valid;
input [9:0]    	que_l2if_send_info;

// read data 
input [255:0]	dp_data_in;
input [31:0]	dp_ecc_in;

// rd interface
output [1:0]  	dram_sctag_chunk_id;
output        	dram_sctag_data_vld;
output [2:0]  	dram_sctag_rd_req_id;
output [127:0] 	dram_sctag_data;
output		dram_sctag_mecc_err;
output		dram_sctag_pa_err;
output		dram_sctag_secc_err;
output [27:0] 	dram_sctag_ecc;
output        	dram_sctag_rd_ack;

// wr interface
output        	dram_sctag_wr_ack;

// To DP for poisoning data
output [3:0]	l2if_data_mecc0;
output [3:0]	l2if_data_mecc1;
output [3:0]	l2if_data_mecc2;
output [3:0]	l2if_data_mecc3;
output [3:0]	l2if_data_mecc4;
output [3:0]	l2if_data_mecc5;
output [3:0]	l2if_data_mecc6;
output [3:0]	l2if_data_mecc7;

// write address
output [2:0]	l2if_data_wr_addr;
output [3:0]	dram_cpu_wr_addr;
output [3:0]	dram_cpu_wr_en;
output [63:0]	dram_cpu_wr_data;

// Going to dram clk domain
output		l2if_wr_req;
output		l2if_rd_req;
output [35:0]	l2if_rd_addr;
output [35:0]	l2if_wr_addr;
output [2:0]	l2if_rd_id;

output		l2if_scrb_data_en;
output [255:0]	l2if_scrb_data;
output [33:0]	l2if_scrb_ecc;
output [35:0]	l2if_err_loc;
output [17:0]	l2if_err_cnt;
output		l2if_dbg_trig_en;

// Going to jbus clk domain
output		l2if_err_intr;

// Async scrub error signals
output		dram_sctag_scb_mecc_err;
output		dram_sctag_scb_secc_err;

// FROM QUE
output [35:0]	l2if_err_addr_reg;
output [22:0]	l2if_err_sts_reg;

// SYNC Pulse
input           dram_dram_rx_sync;
input           dram_dram_tx_sync;
input           dram_jbus_rx_sync;
input           dram_jbus_tx_sync;

input		que_addr_bank_low_sel;

// NEW DUE TO TWO CHANNEL MODE
input		que_channel_disabled;
input		other_channel_disabled;
output		dram_data_val_other_ch;
output		dp_data_valid_d1;

input [35:0]	ch0_err_loc;
input [15:0]	ch0_err_syn;
input		ch0_dp_data_valid_d1;
input		ch0_dram_data_val_other_ch;
input [1:0]  	ch0_dram_sctag_chunk_id;
input [2:0]  	ch0_dram_sctag_rd_req_id;
input [127:0] 	ch0_dram_sctag_data;
input [27:0] 	ch0_dram_sctag_ecc;
input		ch0_dram_sctag_mecc_err;
input		ch0_dram_sctag_pa_err;
input		ch0_dram_sctag_secc_err;
output		l2if_channel_disabled;
output [35:0]	err_loc;
output [15:0]	err_syn;

output		l2if_ucb_trig;
output		l2if_que_selfrsh;

//////////////////////////////////////////////////////////////////
// Wires
//////////////////////////////////////////////////////////////////
wire [35:0]	ch0_err_loc_d1;
wire [15:0]	ch0_err_syn_d1;
wire		l2if_scrb_data_val;
wire		l2if_trig;
wire		l2if_dummy_data_cnt_val;
wire		l2if_ucb_ack_vld_cpu;
wire		l2if_ucb_nack_vld_cpu;
wire [31:0]	l2if_ucb_addr_cpu;
wire [63:0]	l2if_ucb_que_data_cpu;
wire [63:0]	l2if_ucb_data_cpu;
wire [63:0]	l2if_ucb_que_data;
wire		l2if_addr_bank_low_sel;
wire [1:0]	l2if_data_cnt_d1;
wire [1:0]	l2if_data_cnt_d2;
wire [1:0]	l2if_data_cnt_d3;
wire		l2if_secc_err;
wire		ecc_multi_lo_err; 
wire		ecc_multi_hi_err; 
wire		l2if_mecc_err_partial;
wire		ecc_single_lo_err; 
wire		ecc_single_hi_err; 
wire [127:0]	ecc_cor_lo_data;
wire [127:0]	ecc_cor_hi_data;

wire [27:0]	l2if_rd_ecc_lo_d1;
wire [27:0]	l2if_l2_ecc_lo;
wire [27:0]	l2if_l2_ecc_hi;
wire		l2if_wr_ack;
wire		l2if_rd_ack;
wire [3:0]	l2if_b0_wr_val;
wire [3:0]	l2if_b1_wr_val;
wire [3:0]	l2if_b0_rd_val;
wire [3:0]	l2if_b1_rd_val;
wire [255:0]	l2if_rd_data_p1;
wire [127:0]	l2if_rd_data_d1;
wire [1:0]	l2if_data_offset;
wire		l2if_data_first_chunk_in;
wire		l2if_data_mux_sel_en;
wire		l2if_data_first_chunk;
wire		l2if_l2_val;
wire [5:0]	l2if_wr_b0_data_addr_in;
wire [5:0]	l2if_wr_b0_data_addr;
wire [31:0]	l2if_rd_ecc_p1;
wire [1:0]	l2if_data_cnt_in;
wire [1:0]	l2if_data_cnt;
wire		l2if_data_cnt_en;
wire		l2if_add_fifo_valid;
wire [9:0]	l2if_fifo_ent0;
wire [9:0]	l2if_fifo_ent1;
wire [9:0]	l2if_fifo_ent2;
wire [9:0]	l2if_fifo_ent3;
wire [9:0]	l2if_fifo_ent4;
wire [9:0]	l2if_fifo_ent5;
wire [9:0]	l2if_fifo_ent6;
wire [9:0]	l2if_fifo_ent7;
wire		l2if_data_valid_reset;
wire		l2if_data_valid_d1;
wire [9:0]	l2if_send_info;
wire		l2if_data_cnt_val;
wire		l2if_add_scrb_valid;
wire [127:0]	ecc_cor_hi_data_d1;
wire [127:0]	ecc_cor_lo_data_d1;
wire [127:0]	ecc_cor_mux_hi_data;
wire [127:0]	ecc_cor_mux_lo_data;
wire		l2if_fifo_reset;
wire [127:0]	l2if_ecc_cor_data;
wire [27:0]	l2if_gen_ecc;
wire [3:0]	l2if_mecc0_en;
wire [3:0]	l2if_mecc1_en;
wire [3:0]	l2if_mecc2_en;
wire [3:0]	l2if_mecc3_en;
wire [3:0]	l2if_mecc4_en;
wire [3:0]	l2if_mecc5_en;
wire [3:0]	l2if_mecc6_en;
wire [3:0]	l2if_mecc7_en;
wire [3:0]	l2if_data_mecc0_in;
wire [3:0]	l2if_data_mecc1_in;
wire [3:0]	l2if_data_mecc2_in;
wire [3:0]	l2if_data_mecc3_in;
wire [3:0]	l2if_data_mecc4_in;
wire [3:0]	l2if_data_mecc5_in;
wire [3:0]	l2if_data_mecc6_in;
wire [3:0]	l2if_data_mecc7_in;
wire [3:0]	data_mecc0;
wire [3:0]	data_mecc1;
wire [3:0]	data_mecc2;
wire [3:0]	data_mecc3;
wire [3:0]	data_mecc4;
wire [3:0]	data_mecc5;
wire [3:0]	data_mecc6;
wire [3:0]	data_mecc7;
wire [32:0]	l2if_scrb_addr;
wire [31:0]	l2if_rd_ecc_d1;
wire [31:0]	l2if_rd_ecc_d2;
wire [31:0]	l2if_rd_ecc_d3;
wire [31:0]	l2if_ucb_addr;
wire [63:0]	l2if_ucb_data;
wire		l2if_dram_clk_toggle_d1;
wire [35:0]	err_addr_reg;
wire [22:0]	err_sts_reg;
wire [39:4]	l2if_rd_addr_p1;
wire [2:0]	l2if_rd_id_p1;
wire [39:6]	l2if_wr_addr_p1;
wire		l2if_scrb_val_d1;
wire		l2if_scrb_val_d2;
wire		l2if_scrb_val_d3;
wire		l2if_wr_entry0;
wire		l2if_wr_entry1;
wire		l2if_wr_entry2;
wire		l2if_wr_entry3;
wire		l2if_wr_entry4;
wire		l2if_wr_entry5;
wire		l2if_wr_entry6;
wire		l2if_wr_entry7;
wire [3:0]	l2if_wr_entry_free;
wire [35:0]	ecc_loc_lo_d1;
wire [35:0]	ecc_loc_hi_d1;
wire [35:0]	l2if_secc_loc;
wire [15:0]	l2if_secc_cnt;
wire [35:0]	ecc_loc_lo;
wire [35:0]	ecc_loc_hi;
wire [35:0]	l2if_split_rd_addr;
wire [35:0]	l2if_split_rd_addr_lo;
wire [35:0]	l2if_split_rd_addr_hi;
wire [35:0]	l2if_split_wr_addr;
wire [35:0]	l2if_split_wr_addr_lo;
wire [35:0]	l2if_split_wr_addr_hi;
wire [8:0]	l2if_config_reg;
wire		l2if_offset_inc;
wire [3:0]	l2if_wr_val_cnt;
wire		l2if_rd_dummy_req_p1;

//////////////////////////////////////////////////////////////////
// Flop L2 input requests
//////////////////////////////////////////////////////////////////

//dram_dram_rx_sync (enable for signals comming from dram clk to fast clk)
//dram_dram_tx_sync (enable for signals going from fast clk to dram clk)
//dram_jbus_rx_sync (enable for signals comming from jbus clk to fast clk)
//dram_jbus_tx_sync (enable for signals going from fast clk to jbus clk)

dff_ns #(2) ff_dram_sync_pulses (
        .din ({dram_dram_rx_sync, dram_dram_tx_sync}),
        .q   ({l2if_dram_rx_sync, l2if_dram_tx_sync}),
        .clk (clk));

dff_ns #(2) ff_jbus_sync_pulses (
        .din ({dram_jbus_rx_sync, dram_jbus_tx_sync}),
        .q   ({l2if_jbus_rx_sync, l2if_jbus_tx_sync}),
        .clk (clk));

dff_ns #(2) ff_dram_sync_pulses_d1 (
        .din ({l2if_dram_rx_sync, l2if_jbus_rx_sync}),
        .q   ({l2if_dram_rx_sync_d1, l2if_jbus_rx_sync_d1}),
        .clk (clk));

// Delay the err_syn and err_loc by 1 cycle to match with data val for 2 channel mode
dffrl_ns #(52)   ff_ch0_syn_loc(
                .din({ch0_err_loc[35:0], ch0_err_syn[15:0]}),
                .q({ch0_err_loc_d1[35:0], ch0_err_syn_d1[15:0]}),
		.rst_l(rst_l),
                .clk(clk));

// This staged signal is needed in 2 channel mode for muxing the data
dff_ns #(2) ff_ch0_dp_data_valid (
        .din ({ch0_dp_data_valid_d1, other_ch_dp_data_valid_d1}),
        .q   ({other_ch_dp_data_valid_d1, other_ch_dp_data_valid_d2}),
        .clk (clk));

wire l2if_wr_req_flop_reset = rst_l & ~l2if_wr_ack;

dffrle_ns #(1) l2wrreqflop_cpu (
        .din (sctag_dram_wr_req),
        .q   (l2if_wr_req_cpu),
	.en  (sctag_dram_wr_req),
	.rst_l (l2if_wr_req_flop_reset),
        .clk (clk));

wire l2if_rd_req_flop_reset = rst_l & ~l2if_rd_ack;

dffrle_ns #(1) l2rdreqflop_cpu (
        .din (sctag_dram_rd_req),
        .q   (l2if_dram_rd_req),
	.en  (sctag_dram_rd_req),
	.rst_l (l2if_rd_req_flop_reset),
        .clk (clk));

wire l2if_rd_dummy_req_flop_reset = rst_l & ~((l2if_data_cnt == 2'h3) & 
			l2if_rd_dummy_req_p1 & ~l2if_data_valid_d1 & ~sctag_dram_rd_dummy_req);

dffrle_ns #(1) l2id_rd_dummy_req (
        .din    (sctag_dram_rd_dummy_req),
        .q      (l2if_rd_dummy_req_p1),
        .en     (sctag_dram_rd_req),
	.rst_l	(l2if_rd_dummy_req_flop_reset),
        .clk    (clk));

wire l2if_rd_req_cpu = l2if_dram_rd_req & ~l2if_rd_dummy_req_p1;

// Flop rd address input
dffe_ns #(36) l2addr_rdflop0 (
        .din    ({sctag_dram_addr[39:5], 1'b0}),
        .q      (l2if_rd_addr_p1[39:4]),
        .en     (sctag_dram_rd_req),
        .clk    (clk));

// generating two channel mode bit

dff_ns #(1) flop_other_channel_disabled (
        .din (other_channel_disabled),
        .q   (l2if_other_channel_disabled),
        .clk (clk));

wire l2if_two_channel_mode = l2if_channel_disabled | l2if_other_channel_disabled;

dff_ns #(1) flop_two_channel_mode (
        .din (l2if_two_channel_mode),
        .q   (two_channel_mode),
        .clk (clk));

// Generate bank, ras, cas and addr error signals for read addr.
/*dram_addr_gen	AUTO_TEMPLATE( .addr_err(l2if_split_rd_addr_hi[32]),
			      .addr_parity(l2if_split_rd_addr_hi[34]),
			      .stack_adr(l2if_split_rd_addr_hi[33]),
			      .rank_adr	(l2if_split_rd_addr_hi[35]),
			      .ras_adr	(l2if_split_rd_addr_hi[31:17]),
			      .cas_adr	(l2if_split_rd_addr_hi[16:3]),
			      .bank_adr	(l2if_split_rd_addr_hi[2:0]),
			      // Inputs
			      .addr_in	(l2if_rd_addr_p1[39:4]),
			      .eight_bank_mode(l2if_eight_bank_mode),
			      .rank1_present(rank1_present),
			      .two_channel_mode(two_channel_mode),
			      .config_reg(l2if_config_reg[8:0])); */

/*dram_addr_gen_lo AUTO_TEMPLATE( .addr_err(l2if_split_rd_addr_lo[32]),
			      .addr_parity(l2if_split_rd_addr_lo[34]),
			      .stack_adr(l2if_split_rd_addr_lo[33]),
                              .rank_adr (l2if_split_rd_addr_lo[35]),
                              .ras_adr  (l2if_split_rd_addr_lo[31:17]),
                              .cas_adr  (l2if_split_rd_addr_lo[16:3]),
                              .bank_adr (l2if_split_rd_addr_lo[2:0]),
                              // Inputs
                              .addr_in  (l2if_rd_addr_p1[39:4]),
			      .eight_bank_mode(l2if_eight_bank_mode),
                              .rank1_present(rank1_present),
                              .two_channel_mode(two_channel_mode),
                              .config_reg(l2if_config_reg[8:0])); */

dram_addr_gen	dram_rd_addr_gen_hi(/*AUTOINST*/
				    // Outputs
				    .addr_parity(l2if_split_rd_addr_hi[34]), // Templated
				    .addr_err(l2if_split_rd_addr_hi[32]), // Templated
				    .rank_adr(l2if_split_rd_addr_hi[35]), // Templated
				    .stack_adr(l2if_split_rd_addr_hi[33]), // Templated
				    .bank_adr(l2if_split_rd_addr_hi[2:0]), // Templated
				    .ras_adr(l2if_split_rd_addr_hi[31:17]), // Templated
				    .cas_adr(l2if_split_rd_addr_hi[16:3]), // Templated
				    // Inputs
				    .addr_in(l2if_rd_addr_p1[39:4]), // Templated
				    .config_reg(l2if_config_reg[8:0]), // Templated
				    .rank1_present(rank1_present), // Templated
				    .eight_bank_mode(l2if_eight_bank_mode), // Templated
				    .two_channel_mode(two_channel_mode)); // Templated
dram_addr_gen_lo  dram_rd_addr_gen_lo(/*AUTOINST*/
				      // Outputs
				      .addr_parity(l2if_split_rd_addr_lo[34]), // Templated
				      .addr_err(l2if_split_rd_addr_lo[32]), // Templated
				      .rank_adr(l2if_split_rd_addr_lo[35]), // Templated
				      .stack_adr(l2if_split_rd_addr_lo[33]), // Templated
				      .bank_adr(l2if_split_rd_addr_lo[2:0]), // Templated
				      .ras_adr(l2if_split_rd_addr_lo[31:17]), // Templated
				      .cas_adr(l2if_split_rd_addr_lo[16:3]), // Templated
				      // Inputs
				      .addr_in(l2if_rd_addr_p1[39:4]), // Templated
				      .config_reg(l2if_config_reg[8:0]), // Templated
				      .rank1_present(rank1_present), // Templated
				      .eight_bank_mode(l2if_eight_bank_mode), // Templated
				      .two_channel_mode(two_channel_mode)); // Templated
assign l2if_split_rd_addr[35:0] = l2if_addr_bank_low_sel ? l2if_split_rd_addr_lo[35:0] : 
					l2if_split_rd_addr_hi[35:0];

dffe_ns #(3) l2id_rdflop0 (
        .din    (sctag_dram_rd_req_id[2:0]),
        .q      (l2if_rd_id_p1[2:0]),
        .en     (sctag_dram_rd_req),
        .clk    (clk));

// Flop wr address input
dffe_ns #(34) l2addr_wrflop0 (
        .din    (sctag_dram_addr[39:6]),
        .q      (l2if_wr_addr_p1[39:6]),
        .en     (sctag_dram_wr_req),
        .clk    (clk));

// Generate bank, ras, cas and addr error signals for wr addr.
/*dram_addr_gen AUTO_TEMPLATE( .addr_err(l2if_split_wr_addr_hi[32]),
			      .addr_parity(l2if_split_wr_addr_hi[34]),
			      .stack_adr(l2if_split_wr_addr_hi[33]),
                              .rank_adr (l2if_split_wr_addr_hi[35]),
                              .ras_adr  (l2if_split_wr_addr_hi[31:17]),
                              .cas_adr  (l2if_split_wr_addr_hi[16:3]),
                              .bank_adr (l2if_split_wr_addr_hi[2:0]),
                              // Inputs
                              .addr_in  ({l2if_wr_addr_p1[39:6], 2'h0}),
			      .rank1_present(rank1_present),
			      .eight_bank_mode(l2if_eight_bank_mode),
                              .config_reg(l2if_config_reg[8:0])); */

/*dram_addr_gen_lo AUTO_TEMPLATE( .addr_err(l2if_split_wr_addr_lo[32]),
			      .addr_parity(l2if_split_wr_addr_lo[34]),
			      .stack_adr(l2if_split_wr_addr_lo[33]),
                              .rank_adr (l2if_split_wr_addr_lo[35]),
                              .ras_adr  (l2if_split_wr_addr_lo[31:17]),
                              .cas_adr  (l2if_split_wr_addr_lo[16:3]),
                              .bank_adr (l2if_split_wr_addr_lo[2:0]),
                              // Inputs
                              .addr_in  ({l2if_wr_addr_p1[39:6], 2'h0}),
			      .eight_bank_mode(l2if_eight_bank_mode),
                              .rank1_present(rank1_present),
                              .config_reg(l2if_config_reg[8:0])); */

dram_addr_gen	dram_wr_addr_gen_hi(/*AUTOINST*/
				    // Outputs
				    .addr_parity(l2if_split_wr_addr_hi[34]), // Templated
				    .addr_err(l2if_split_wr_addr_hi[32]), // Templated
				    .rank_adr(l2if_split_wr_addr_hi[35]), // Templated
				    .stack_adr(l2if_split_wr_addr_hi[33]), // Templated
				    .bank_adr(l2if_split_wr_addr_hi[2:0]), // Templated
				    .ras_adr(l2if_split_wr_addr_hi[31:17]), // Templated
				    .cas_adr(l2if_split_wr_addr_hi[16:3]), // Templated
				    // Inputs
				    .addr_in({l2if_wr_addr_p1[39:6], 2'h0}), // Templated
				    .config_reg(l2if_config_reg[8:0]), // Templated
				    .rank1_present(rank1_present), // Templated
				    .eight_bank_mode(l2if_eight_bank_mode), // Templated
				    .two_channel_mode(two_channel_mode));

dram_addr_gen_lo   dram_wr_addr_gen_lo(/*AUTOINST*/
				       // Outputs
				       .addr_parity(l2if_split_wr_addr_lo[34]), // Templated
				       .addr_err(l2if_split_wr_addr_lo[32]), // Templated
				       .rank_adr(l2if_split_wr_addr_lo[35]), // Templated
				       .stack_adr(l2if_split_wr_addr_lo[33]), // Templated
				       .bank_adr(l2if_split_wr_addr_lo[2:0]), // Templated
				       .ras_adr(l2if_split_wr_addr_lo[31:17]), // Templated
				       .cas_adr(l2if_split_wr_addr_lo[16:3]), // Templated
				       // Inputs
				       .addr_in({l2if_wr_addr_p1[39:6], 2'h0}), // Templated
				       .config_reg(l2if_config_reg[8:0]), // Templated
				       .rank1_present(rank1_present), // Templated
				       .eight_bank_mode(l2if_eight_bank_mode), // Templated
				       .two_channel_mode(two_channel_mode));

assign l2if_split_wr_addr[35:0] = l2if_addr_bank_low_sel ? l2if_split_wr_addr_lo[35:0] : 
					l2if_split_wr_addr_hi[35:0];

// Flop wr address out of range bit
dffrl_ns #(1) l2addr_wr_en_d1 (
        .din    (sctag_dram_wr_req),
        .q      (l2if_wr_en0_d1),
        .rst_l  (rst_l),
        .clk    (clk));

wire l2if_wr_addr_err_in = l2if_split_wr_addr[32];

dffrle_ns #(1) l2addr_wr_pa_err (
        .din    (l2if_wr_addr_err_in),
        .q      (l2if_wr_addr_err),
        .en     (l2if_wr_en0_d1),
        .rst_l  (rst_l),
        .clk    (clk));

/////////////////////////////////////////////////
// SIGNALS FROM CPU CLK TO DRAM CLK
/////////////////////////////////////////////////

// write and read req valids
dffe_ns #(2) l2wrreqflop_dram (
        .din    ({l2if_wr_ack, l2if_rd_req_cpu}),
        .q      ({l2if_wr_req,l2if_rd_req}),
	.en	(l2if_dram_tx_sync),
        .clk    (clk));

// Error status register 
dffe_ns #(23)   ff_err_sts_reg(
        .din	(err_sts_reg[22:0]),
        .q	(l2if_err_sts_reg[22:0]),
	.en	(l2if_dram_tx_sync),
        .clk	(clk));

// Error address register
dffe_ns #(36)   err_addr(
        .din	(err_addr_reg[35:0]),
        .q	(l2if_err_addr_reg[35:0]),
	.en	(l2if_dram_tx_sync),
        .clk	(clk));

// scrb data for dram clk domain
dffe_ns #(256) scrb_data(
        .din	({ecc_cor_hi_data_d1[127:0], ecc_cor_lo_data_d1[127:0]}),
        .q	(l2if_scrb_data[255:0]),
	.en	(l2if_dram_tx_sync),
        .clk	(clk));

dffe_ns #(34) scrb_ecc(
        .din	({ecc_multi_hi_err_d1, ecc_multi_lo_err_d1, l2if_rd_ecc_d3[31:16], 
			l2if_rd_ecc_d3[15:0]}),
        .q	(l2if_scrb_ecc[33:0]),
	.en	(l2if_dram_tx_sync),
        .clk	(clk));

// scrub valid signal for dram side
dffe_ns #(2) scrb_val(
        .din	({l2if_dbg_trig, l2if_scrb_val_d3}),
        .q	({l2if_dbg_trig_en, l2if_scrb_data_en}),
	.en	(l2if_dram_tx_sync),
        .clk	(clk));

// rd address input
dffe_ns #(36) rd_addr (
        .din    (l2if_split_rd_addr[35:0]),
        .q      (l2if_rd_addr[35:0]),
	.en	(l2if_dram_tx_sync),
        .clk    (clk));

// rd req id
dffe_ns #(3) rd_id (
        .din    (l2if_rd_id_p1[2:0]),
        .q      (l2if_rd_id[2:0]),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

// wr address input
dffe_ns #(36) wr_addr (
        .din    (l2if_split_wr_addr[35:0]),
        .q      (l2if_wr_addr[35:0]),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

// data write address into mem
dffe_ns #(3) ff_wr_addr(
        .din    (l2if_wr_b0_data_addr[5:3]),
        .q    	(l2if_data_wr_addr[2:0]),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

// l2 poison on mecc err bits
dffe_ns #(16) ff_l2_poison0_3(
        .din    ({data_mecc0[3:0], data_mecc1[3:0], data_mecc2[3:0], data_mecc3[3:0]}),
        .q    	({l2if_data_mecc0[3:0], l2if_data_mecc1[3:0], l2if_data_mecc2[3:0], 
				l2if_data_mecc3[3:0]}),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

dffe_ns #(16) ff_l2_poison4_7(
        .din    ({data_mecc4[3:0], data_mecc5[3:0], data_mecc6[3:0], data_mecc7[3:0]}),
        .q    	({l2if_data_mecc4[3:0], l2if_data_mecc5[3:0], l2if_data_mecc6[3:0], 
				l2if_data_mecc7[3:0]}),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

// ecc loc reg
dffe_ns #(36) ff_ecc_loc_reg(
        .din    (l2if_secc_loc[35:0]),
        .q    	(l2if_err_loc[35:0]),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

// err counter reg
dffe_ns #(18) ff_err_cnt_reg(
        .din    ({l2if_secc_int_enabled, l2if_secc_vld, l2if_secc_cnt[15:0]}),
        .q    	(l2if_err_cnt[17:0]),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

// flop write and read valid
dffe_ns #(2)    l2if_ucb_rd_wr_vld(
        .din    ({l2if_ucb_rd_req_vld_cpu, l2if_ucb_wr_req_vld_cpu}),
        .q      ({l2if_que_rd_req_vld, l2if_que_wr_req_vld}),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

// flop addr in
dffe_ns #(32)    l2if_ucb_addr_in(
        .din    (l2if_ucb_addr_cpu[31:0]),
        .q      (l2if_que_addr[31:0]),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

// flop data in
dffe_ns #(64)   l2if_ucb_data_in(
        .din    (l2if_ucb_data_cpu[63:0]),
        .q      (l2if_que_data[63:0]),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

// Freq 200 sel 
dffe_ns #(1)    ff_test_signals(
        .din    ({l2if_selfrsh}),
        .q      ({l2if_que_selfrsh}),
        .en     (l2if_dram_tx_sync),
        .clk    (clk));

//////////////////////////////////////////////////////////////////
// SIGNALS FROM JBUS TO CPU CLK
//////////////////////////////////////////////////////////////////

// Test signals
dffe_ns #(1) 	ff_ucb_test_signals(
        .din	({ucb_l2if_selfrsh}),
        .q	({l2if_selfrsh}),
	.en	(l2if_jbus_rx_sync),
        .clk	(clk));

// flop write and read valid
dffe_ns #(2) 	ucb_rd_wr_vld(
        .din	({ucb_dram_rd_req_vld, ucb_dram_wr_req_vld}),
        .q	({l2if_ucb_rd_req_vld, l2if_ucb_wr_req_vld}),
	.en	(l2if_jbus_rx_sync),
        .clk	(clk));

// flop addr in
dffe_ns #(32) 	ucb_addr_in(
        .din	(ucb_dram_addr[31:0]),
        .q	(l2if_ucb_addr[31:0]),
	.en	(l2if_jbus_rx_sync),
        .clk	(clk));

// flop data in
dffe_ns #(64) 	ucb_data_in(
        .din	(ucb_dram_data[63:0]),
        .q	(l2if_ucb_data[63:0]),
	.en	(l2if_jbus_rx_sync),
        .clk	(clk));

////////////////////////
// Flop enable so that its reset on dram sync pulse
////////////////////////

wire l2if_ucb_wr_req_vld_en = l2if_jbus_rx_sync_d1 & l2if_ucb_wr_req_vld;
wire l2if_ucb_rd_req_vld_en = l2if_jbus_rx_sync_d1 & l2if_ucb_rd_req_vld;
wire l2if_ucb_wr_req_rst_l = rst_l & ~(l2if_dram_tx_sync & l2if_ucb_wr_req_vld_cpu);
wire l2if_ucb_rd_req_rst_l = rst_l & ~(l2if_dram_tx_sync & l2if_ucb_rd_req_vld_cpu);

// flop write valid
dffrle_ns #(1)    l2if_wr_vld(
        .din    (l2if_ucb_wr_req_vld),
        .q      (l2if_ucb_wr_req_vld_cpu),
        .en     (l2if_ucb_wr_req_vld_en),
	.rst_l	(l2if_ucb_wr_req_rst_l),
        .clk    (clk));

// flop read valid
dffrle_ns #(1)    l2if_rd_vld(
        .din    (l2if_ucb_rd_req_vld),
        .q      (l2if_ucb_rd_req_vld_cpu),
        .en     (l2if_ucb_rd_req_vld_en),
	.rst_l	(l2if_ucb_rd_req_rst_l),
        .clk    (clk));

wire l2if_ucb_addr_en = l2if_ucb_wr_req_vld_en | l2if_ucb_rd_req_vld_en;

// flop addr in
dffe_ns #(32)  ff_l2if_ucb_addr_cpu(
        .din    (l2if_ucb_addr[31:0]),
        .q      (l2if_ucb_addr_cpu[31:0]),
        .en     (l2if_ucb_addr_en),
        .clk    (clk));

// flop data in
dffe_ns #(64)   ff_l2if_ucb_data_cpu(
        .din    (l2if_ucb_data[63:0]),
        .q      (l2if_ucb_data_cpu[63:0]),
        .en     (l2if_ucb_wr_req_vld),
        .clk    (clk));

/////////////////////////////////////////////////
// SIGNALS FROM DRAM CLK TO CPU CLK
/////////////////////////////////////////////////

// Select bank bits
dffe_ns #(1) bank_bits_sel (
        .din(que_addr_bank_low_sel),
        .q(l2if_addr_bank_low_sel),
	.en(l2if_dram_rx_sync),
        .clk(clk));

// channel disable bit
dffe_ns #(1) ch_disabled (
        .din(que_channel_disabled),
        .q(l2if_channel_disabled),
	.en(l2if_dram_rx_sync),
        .clk(clk));

// 8 bank mode bit
dffe_ns #(1) eight_bank_mode (
        .din(que_eight_bank_mode),
        .q(l2if_eight_bank_mode),
	.en(l2if_dram_rx_sync),
        .clk(clk));

// fail over bit
dffe_ns #(1) fail_over_mode (
        .din(dram_fail_over_mode),
        .q(l2if_dram_fail_over_mode),
	.en(l2if_dram_rx_sync),
        .clk(clk));

// Flop scrb address input
dffe_ns #(33) scrb_addr (
        .din(que_scrb_addr[32:0]),
        .q(l2if_scrb_addr[32:0]),
	.en(l2if_dram_rx_sync),
        .clk(clk));

// dram to cpu clk domain of the buffer valids
dffe_ns #(17) ff_que_val(
        .din    ({que_wr_req, readqbank0vld0, readqbank0vld1, readqbank0vld2, readqbank0vld3, 
		writeqbank0vld0, writeqbank0vld1, writeqbank0vld2, writeqbank0vld3,
		readqbank0vld4, readqbank0vld5, readqbank0vld6, readqbank0vld7, 
		writeqbank0vld4, writeqbank0vld5, writeqbank0vld6, writeqbank0vld7 }),
        .q      ({l2if_new_wr_req_ret, l2if_b0_rd_val[3:0],l2if_b0_wr_val[3:0],
			l2if_b1_rd_val[3:0],l2if_b1_wr_val[3:0]}),
	.en(l2if_dram_rx_sync),
        .clk    (clk));

dffrle_ns #(12) l2_read_info(
        .din	({que_dram_clk_toggle, dp_data_valid, que_l2if_send_info[9:0]}),
        .q	({l2if_dram_clk_toggle, dp_data_valid_d1, l2if_send_info[9:0]}),
	.rst_l	(rst_l),
	.en 	(l2if_dram_rx_sync),
        .clk	(clk));

// flop dp data to send to l2
dffe_ns #(288) l2_read_data(
        .din	({dp_ecc_in[31:0], dp_data_in[255:0]}),
        .q	({l2if_rd_ecc_p1[31:0], l2if_rd_data_p1[255:0]}),
	.en	(l2if_dram_rx_sync),
        .clk	(clk));

// flop write data entry free
dffe_ns #(4) 	wr_entry_free(
        .din	(que_wr_entry_free[3:0]),
        .q	(l2if_wr_entry_free[3:0]),
	.en	(l2if_dram_rx_sync),
        .clk	(clk));

// flop chip config for ras cas width and stack dimm 
dffe_ns #(10) 	ff_config(
        .din	({que_rank1_present, config_reg[8:0]}),
        .q	({rank1_present, l2if_config_reg[8:0]}),
	.en	(l2if_dram_rx_sync),
        .clk	(clk));

// flop ack and nack
dffe_ns #(2)    l2if_ucb_ack_nack(
        .din    ({que_l2if_ack_vld, que_l2if_nack_vld}),
        .q      ({l2if_ucb_ack_vld, l2if_ucb_nack_vld}),
        .en     (l2if_dram_rx_sync),
        .clk    (clk));

// flop data
dffe_ns #(64)   l2if_ucb_data_out(
        .din    (que_l2if_data[63:0]),
        .q      (l2if_ucb_que_data[63:0]),
        .en     (l2if_dram_rx_sync),
        .clk    (clk));

////////////////////////////////////////
// Flop enable so that its reset on jbus sync pulse
////////////////////////////////////////

wire l2if_ucb_ack_en = l2if_dram_rx_sync_d1 & l2if_ucb_ack_vld;
wire l2if_ucb_nack_en = l2if_dram_rx_sync_d1 & l2if_ucb_nack_vld;
wire l2if_ucb_ack_rst_l = rst_l & ~(l2if_jbus_tx_sync & l2if_ucb_ack_vld_cpu);
wire l2if_ucb_nack_rst_l = rst_l & ~(l2if_jbus_tx_sync & l2if_ucb_nack_vld_cpu);
wire l2if_secc_trig_rst_l = rst_l & ~(l2if_jbus_tx_sync & l2if_trig);

// flop ack 
dffrle_ns #(1)  ucb_ack(
        .din    (l2if_ucb_ack_vld),
        .q      (l2if_ucb_ack_vld_cpu),
        .en     (l2if_ucb_ack_en),
	.rst_l	(l2if_ucb_ack_rst_l),
        .clk    (clk));

// flop nack 
dffrle_ns #(1)  ucb_nack(
        .din    (l2if_ucb_nack_vld),
        .q      (l2if_ucb_nack_vld_cpu),
        .en     (l2if_ucb_nack_en),
	.rst_l	(l2if_ucb_nack_rst_l),
        .clk    (clk));

// flop data
dffe_ns #(64)   ucb_data_cpu(
        .din    (l2if_ucb_que_data[63:0]),
        .q      (l2if_ucb_que_data_cpu[63:0]),
        .en     (l2if_ucb_ack_en),
        .clk    (clk));

// flop dbg_trig 
dffrle_ns #(1)  ff_dgb_trig(
        .din    (l2if_secc_trig),
        .q      (l2if_trig),
        .en     (l2if_secc_trig),
	.rst_l	(l2if_secc_trig_rst_l),
        .clk    (clk));

//////////////////////////////////////////////////////////////////
// SIGNALS FROM CPU TO JBUS CLK
//////////////////////////////////////////////////////////////////

// flop ack and nack 
dffe_ns #(2) 	ucb_ack_nack(
        .din	({l2if_ucb_ack_vld_cpu, l2if_ucb_nack_vld_cpu}),
        .q	({dram_ucb_ack_vld, dram_ucb_nack_vld}),
	.en	(l2if_jbus_tx_sync),
        .clk	(clk));

// flop data
dffe_ns #(64) 	ucb_data_out(
        .din	(l2if_ucb_que_data_cpu[63:0]),
        .q	(dram_ucb_data[63:0]),
	.en	(l2if_jbus_tx_sync),
        .clk	(clk));

// err interrupt
dffe_ns #(1) 	ff_err_intr(
        .din    (l2if_secc_cnt_intr),
        .q    	(l2if_err_intr),
        .en     (l2if_jbus_tx_sync),
        .clk    (clk));

// flop debug trigger
dffe_ns #(1) 	dbg_trig(
        .din	(l2if_trig),
        .q	(l2if_ucb_trig),
	.en	(l2if_jbus_tx_sync),
        .clk	(clk));

//////////////////////////////////////////////////////////////////
// Generate the ack for L2
//////////////////////////////////////////////////////////////////

// There could be corner case in writes due to more than 8 requests
// being asserted unlike in reads due to no id numbers. 

// Need to count only for write not for read because L2 does have id for read
// and does not have more than 8 id's but no id for writes.

assign l2if_wr_val_cnt[3:0] = {3'h0, l2if_b0_wr_val[3]} + {3'h0, l2if_b0_wr_val[2]} + 
				{3'h0, l2if_b0_wr_val[1]} + {3'h0, l2if_b0_wr_val[0]} + 
				{3'h0, l2if_b1_wr_val[3]} + {3'h0, l2if_b1_wr_val[2]} +
				{3'h0, l2if_b1_wr_val[1]}+ {3'h0, l2if_b1_wr_val[0]};

// Send ack only if cnt is - (below 7 | if 7 then no ack in prev cycle) & new req in tx cycle
// Because the turn around is 2 dram cycles min. we have to look at the req signal after a cycle

assign l2if_wr_ack = ( (~l2if_wr_val_cnt[3] & ~(&l2if_wr_val_cnt[2:0])) | 
			(&l2if_wr_val_cnt[2:0] & ~(l2if_wr_req | l2if_new_wr_req_ret)) ) & 
				l2if_wr_req_cpu & l2if_dram_tx_sync; 

assign l2if_rd_ack = ~(&{l2if_b0_rd_val[3:0],l2if_b1_rd_val[3:0]}) & 
				l2if_rd_req_cpu & l2if_dram_tx_sync |
		~l2if_channel_disabled & ~dp_data_valid_d1 & l2if_dram_rx_sync_d1 & 
				l2if_dram_rd_req & l2if_rd_dummy_req_p1 |
		l2if_channel_disabled & ~ch0_dp_data_valid_d1 & l2if_dram_rx_sync_d1 & 
				l2if_dram_rd_req & l2if_rd_dummy_req_p1; 

// Read Ack 
dffrl_ns 	ff_rd_ack0(
        .din    (l2if_rd_ack),
        .q      (dram_sctag_rd_ack),
	.rst_l  (rst_l),
        .clk    (clk));

// Write Ack logic
dffrl_ns 	ff_wr_ack(
        .din    (l2if_wr_ack),
        .q      (dram_sctag_wr_ack),
	.rst_l  (rst_l),
        .clk    (clk));

//////////////////////////////////////////////////////////////////
//// L2 Interface DP Portion (Possibly to Synthesize)
//////////////////////////////////////////////////////////////////

// Flop all data input
dff_ns #(64) l2dataflop0 (
        .din    (sctag_dram_wr_data[63:0]),
        .q      (dram_cpu_wr_data[63:0]),
        .clk    (clk));

dffrl_ns #(2) l2datavldflop (
        .din    ({sctag_dram_data_vld, sctag_dram_data_mecc}),
        .q      ({l2if_b0_data_vld, l2if_dram_data_mecc}),
	.rst_l	(rst_l),
        .clk    (clk));

// stage data valid 
dffrl_ns #(1) ff_data_vld (
        .din    (l2if_b0_data_vld),
        .q    	(l2if_b0_data_vld_d1),
	.rst_l	(rst_l),
        .clk    (clk));

//////////////////////////////////////////////////////////////////
// Generate address and enable for writing data into arrays.
//////////////////////////////////////////////////////////////////

// generate enable for write
assign dram_cpu_wr_en[3:0] = ~({4{l2if_b0_data_vld}} & 
		({ l2if_wr_b0_data_addr[1] & l2if_wr_b0_data_addr[0],
		   l2if_wr_b0_data_addr[1] & ~l2if_wr_b0_data_addr[0],
		   ~l2if_wr_b0_data_addr[1] & l2if_wr_b0_data_addr[0],
		   ~l2if_wr_b0_data_addr[1] & ~l2if_wr_b0_data_addr[0] }));

// generate the index into the array
// When data valid is high just increment the address to write into that location.
// When its low, eval only when the data valid is just gone low and there is no pending req at that time
// and also tha there is some entry empty. If all entries are occupied, then check for entry that's
// getting free and make that as free entry. By default it will keep its old value.
assign l2if_wr_b0_data_addr_in[5:0] = (~l2if_b0_data_vld) ?  ( 
			~l2if_wr_entry0 & ~l2if_wr_req_cpu & l2if_b0_data_vld_d1 ? 6'h0 :
			~l2if_wr_entry1 & ~l2if_wr_req_cpu & l2if_b0_data_vld_d1 ? 6'h8 :
			~l2if_wr_entry2 & ~l2if_wr_req_cpu & l2if_b0_data_vld_d1 ? 6'h10 :
			~l2if_wr_entry3 & ~l2if_wr_req_cpu & l2if_b0_data_vld_d1 ? 6'h18 :
			~l2if_wr_entry4 & ~l2if_wr_req_cpu & l2if_b0_data_vld_d1 ? 6'h20 :
			~l2if_wr_entry5 & ~l2if_wr_req_cpu & l2if_b0_data_vld_d1 ? 6'h28 :
			~l2if_wr_entry6 & ~l2if_wr_req_cpu & l2if_b0_data_vld_d1 ? 6'h30 : 
			~l2if_wr_entry7 & ~l2if_wr_req_cpu & l2if_b0_data_vld_d1 ? 6'h38 : 
		l2if_wr_entry0 & l2if_wr_entry1 & l2if_wr_entry2 & l2if_wr_entry3 & 
		l2if_wr_entry4 & l2if_wr_entry5 & l2if_wr_entry6 & l2if_wr_entry7 & 
		l2if_wr_entry_free[3] ? {l2if_wr_entry_free[2:0],3'h0} : 
			l2if_wr_b0_data_addr[5:0]) : l2if_wr_b0_data_addr[5:0] + 6'h1;

dffrl_ns #(6) ff_b0_data_addr (
        .din(l2if_wr_b0_data_addr_in[5:0]),
        .q(l2if_wr_b0_data_addr[5:0]),
	.rst_l(rst_l),
        .clk(clk));

assign dram_cpu_wr_addr = l2if_wr_b0_data_addr[5:2];

// Keep track of in use entries. A 1 means its in use or else free.
// Keep it free if there was address error in write address. The write is silently dropped.
wire l2if_wr_entry0_en = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h0) |
	 		~l2if_wr_addr_err & l2if_b0_data_vld & ~l2if_b0_data_vld_d1 & 
				(l2if_wr_b0_data_addr[5:3] == 3'h0);
wire l2if_wr_entry0_in = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h0) ? 1'b0 : 1'b1;

dffrle_ns #(1) ff_wr_ent0(
        .din(l2if_wr_entry0_in),
        .q(l2if_wr_entry0),
	.rst_l(rst_l),
	.en(l2if_wr_entry0_en),
        .clk(clk));

wire l2if_wr_entry1_en = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h1) |
         		~l2if_wr_addr_err & l2if_b0_data_vld & ~l2if_b0_data_vld_d1 & 
			(l2if_wr_b0_data_addr[5:3] == 3'h1);
wire l2if_wr_entry1_in = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h1) ? 1'b0 : 1'b1;

dffrle_ns #(1) ff_wr_ent1(
        .din(l2if_wr_entry1_in),
        .q(l2if_wr_entry1),
        .rst_l(rst_l),
        .en(l2if_wr_entry1_en),
        .clk(clk));

wire l2if_wr_entry2_en = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h2) |
         		~l2if_wr_addr_err & l2if_b0_data_vld & ~l2if_b0_data_vld_d1 & 
			(l2if_wr_b0_data_addr[5:3] == 3'h2);
wire l2if_wr_entry2_in = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h2) ? 1'b0 : 1'b1;

dffrle_ns #(1) ff_wr_ent2(
        .din(l2if_wr_entry2_in),
        .q(l2if_wr_entry2),
        .rst_l(rst_l),
        .en(l2if_wr_entry2_en),
        .clk(clk));

wire l2if_wr_entry3_en = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h3) |
	  		~l2if_wr_addr_err & l2if_b0_data_vld & ~l2if_b0_data_vld_d1 & 
			(l2if_wr_b0_data_addr[5:3] == 3'h3);
wire l2if_wr_entry3_in = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h3) ? 1'b0 : 1'b1;

dffrle_ns #(1) ff_wr_ent3(
        .din(l2if_wr_entry3_in),
        .q(l2if_wr_entry3),
        .rst_l(rst_l),
        .en(l2if_wr_entry3_en),
        .clk(clk));

wire l2if_wr_entry4_en = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h4) |
         		~l2if_wr_addr_err & l2if_b0_data_vld & ~l2if_b0_data_vld_d1 & 
			(l2if_wr_b0_data_addr[5:3] == 3'h4);
wire l2if_wr_entry4_in = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h4) ? 1'b0 : 1'b1;

dffrle_ns #(1) ff_wr_ent4(
        .din(l2if_wr_entry4_in),
        .q(l2if_wr_entry4),
        .rst_l(rst_l),
        .en(l2if_wr_entry4_en),
        .clk(clk));

wire l2if_wr_entry5_en = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h5) |
         		~l2if_wr_addr_err & l2if_b0_data_vld & ~l2if_b0_data_vld_d1 & 
			(l2if_wr_b0_data_addr[5:3] == 3'h5);
wire l2if_wr_entry5_in = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h5) ? 1'b0 : 1'b1;

dffrle_ns #(1) ff_wr_ent5(
        .din(l2if_wr_entry5_in),
        .q(l2if_wr_entry5),
        .rst_l(rst_l),
        .en(l2if_wr_entry5_en),
        .clk(clk));

wire l2if_wr_entry6_en = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h6) |
         		~l2if_wr_addr_err & l2if_b0_data_vld & ~l2if_b0_data_vld_d1 & 
			(l2if_wr_b0_data_addr[5:3] == 3'h6);
wire l2if_wr_entry6_in = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h6) ? 1'b0 : 1'b1;

dffrle_ns #(1) ff_wr_ent6(
        .din(l2if_wr_entry6_in),
        .q(l2if_wr_entry6),
        .rst_l(rst_l),
        .en(l2if_wr_entry6_en),
        .clk(clk));

wire l2if_wr_entry7_en = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h7) |
         		~l2if_wr_addr_err & l2if_b0_data_vld & ~l2if_b0_data_vld_d1 & 
			(l2if_wr_b0_data_addr[5:3] == 3'h7);
wire l2if_wr_entry7_in = l2if_wr_entry_free[3] & (l2if_wr_entry_free[2:0] == 3'h7) ? 1'b0 : 1'b1;

dffrle_ns #(1) ff_wr_ent7(
        .din(l2if_wr_entry7_in),
        .q(l2if_wr_entry7),
        .rst_l(rst_l),
        .en(l2if_wr_entry7_en),
        .clk(clk));

//////////////////////////////////////////////////////////////////
// Generate L2 response for read requests
//////////////////////////////////////////////////////////////////

///////
// Generate chunk offset
///////

assign l2if_data_cnt_in = l2if_data_cnt + 2'h1;
assign l2if_data_cnt_en = l2if_data_cnt_val | l2if_dummy_data_cnt_val;

dffrle_ns #(2) ff_data8_cnt(
        .din(l2if_data_cnt_in[1:0]),
        .q(l2if_data_cnt[1:0]),
	.rst_l(rst_l),
	.en(l2if_data_cnt_en),
        .clk(clk));

// Stage data valid 
// Data correction and detection is for two cycles.

dff_ns #(1) ff_data_vld_d1(
        .din(dp_data_valid_d1),
        .q(l2if_data_valid_d1),
        .clk(clk));

// This signal aligns with the data out of ecc_corection module
dff_ns #(1) ff_data_vld_d2(
        .din(l2if_data_valid_d1),
        .q(l2if_data_valid_d2),
        .clk(clk));

// This signal aligns with the flopped data out of ecc_corection module
dff_ns #(1) ff_data_vld_d3(
        .din(l2if_data_valid_d2),
        .q(l2if_data_valid_d3),
        .clk(clk));

// Because the valid signal in cpu clk domain is valid for multiple cycles, we
// have reset the valid after one cpu cycle. Also note that valid would not
// asserted back to back cycles as CAS is not picked back to back cycles.

assign l2if_add_fifo_valid = ~(l2if_dram_clk_toggle_d1 == l2if_dram_clk_toggle) & l2if_send_info[6];
assign l2if_add_scrb_valid = ~(l2if_dram_clk_toggle_d1 == l2if_dram_clk_toggle) & l2if_send_info[5];

// This part of code is keeping the 8 deep FIFO that expects the first data to come back
reg	l2if_fifo_ent0_en;
reg	l2if_fifo_ent1_en;
reg	l2if_fifo_ent2_en;
reg	l2if_fifo_ent3_en;
reg	l2if_fifo_ent4_en;
reg	l2if_fifo_ent5_en;
reg	l2if_fifo_ent6_en;
reg	l2if_fifo_ent7_en;

always @(l2if_add_fifo_valid or l2if_fifo_ent0 or l2if_fifo_ent1 or l2if_fifo_ent2 or
	l2if_fifo_ent3 or l2if_fifo_ent4 or l2if_fifo_ent5 or l2if_fifo_ent6 or l2if_fifo_ent7)
begin
	l2if_fifo_ent7_en = 1'b0;
	l2if_fifo_ent6_en = 1'b0;
	l2if_fifo_ent5_en = 1'b0;
	l2if_fifo_ent4_en = 1'b0;
	l2if_fifo_ent3_en = 1'b0;
	l2if_fifo_ent2_en = 1'b0;
	l2if_fifo_ent1_en = 1'b0;
	l2if_fifo_ent0_en = 1'b0;
	if(~l2if_fifo_ent7[6] & ~l2if_fifo_ent7[5]) begin
		l2if_fifo_ent7_en = 1'b1;
		l2if_fifo_ent6_en = 1'b1;
		l2if_fifo_ent5_en = 1'b1;
		l2if_fifo_ent4_en = 1'b1;
		l2if_fifo_ent3_en = 1'b1;
		l2if_fifo_ent2_en = 1'b1;
		l2if_fifo_ent1_en = 1'b1;
		l2if_fifo_ent0_en = 1'b1;
	end
	else if(~l2if_fifo_ent6[6] & ~l2if_fifo_ent6[5]) begin
		l2if_fifo_ent6_en = 1'b1;
		l2if_fifo_ent5_en = 1'b1;
		l2if_fifo_ent4_en = 1'b1;
		l2if_fifo_ent3_en = 1'b1;
		l2if_fifo_ent2_en = 1'b1;
		l2if_fifo_ent1_en = 1'b1;
		l2if_fifo_ent0_en = 1'b1;
	end
	else if(~l2if_fifo_ent5[6] & ~l2if_fifo_ent5[5]) begin
		l2if_fifo_ent5_en = 1'b1;
		l2if_fifo_ent4_en = 1'b1;
		l2if_fifo_ent3_en = 1'b1;
		l2if_fifo_ent2_en = 1'b1;
		l2if_fifo_ent1_en = 1'b1;
		l2if_fifo_ent0_en = 1'b1;
	end
	else if(~l2if_fifo_ent4[6] & ~l2if_fifo_ent4[5]) begin
		l2if_fifo_ent4_en = 1'b1;
		l2if_fifo_ent3_en = 1'b1;
		l2if_fifo_ent2_en = 1'b1;
		l2if_fifo_ent1_en = 1'b1;
		l2if_fifo_ent0_en = 1'b1;
	end
	else if(~l2if_fifo_ent3[6] & ~l2if_fifo_ent3[5]) begin
		l2if_fifo_ent3_en = 1'b1;
		l2if_fifo_ent2_en = 1'b1;
		l2if_fifo_ent1_en = 1'b1;
		l2if_fifo_ent0_en = 1'b1;
	end
	else if(~l2if_fifo_ent2[6] & ~l2if_fifo_ent2[5]) begin
		l2if_fifo_ent2_en = 1'b1;
		l2if_fifo_ent1_en = 1'b1;
		l2if_fifo_ent0_en = 1'b1;
	end
	else if(~l2if_fifo_ent1[6] & ~l2if_fifo_ent1[5]) begin
		l2if_fifo_ent1_en = 1'b1;
		l2if_fifo_ent0_en = 1'b1;
	end
	else if(l2if_add_fifo_valid) begin
		l2if_fifo_ent0_en = 1'b1;
	end

end

dffrle_ns #(10) l2_fifo_ent0(
        .din({l2if_send_info[9:7], l2if_add_fifo_valid, l2if_add_scrb_valid, l2if_send_info[4:0]}),
        .q(l2if_fifo_ent0[9:0]),
	.rst_l(rst_l),
	.en(l2if_fifo_ent0_en),
        .clk(clk));

dffrle_ns #(10) l2_fifo_ent1(
        .din(l2if_fifo_ent0[9:0]),
        .q(l2if_fifo_ent1[9:0]),
	.rst_l(rst_l),
	.en(l2if_fifo_ent1_en),
        .clk(clk));

dffrle_ns #(10) l2_fifo_ent2(
        .din(l2if_fifo_ent1[9:0]),
        .q(l2if_fifo_ent2[9:0]),
	.rst_l(rst_l),
	.en(l2if_fifo_ent2_en),
        .clk(clk));

dffrle_ns #(10) l2_fifo_ent3(
        .din(l2if_fifo_ent2[9:0]),
        .q(l2if_fifo_ent3[9:0]),
	.rst_l(rst_l),
	.en(l2if_fifo_ent3_en),
        .clk(clk));

dffrle_ns #(10) l2_fifo_ent4(
        .din(l2if_fifo_ent3[9:0]),
        .q(l2if_fifo_ent4[9:0]),
	.rst_l(rst_l),
	.en(l2if_fifo_ent4_en),
        .clk(clk));

dffrle_ns #(10) l2_fifo_ent5(
        .din(l2if_fifo_ent4[9:0]),
        .q(l2if_fifo_ent5[9:0]),
	.rst_l(rst_l),
	.en(l2if_fifo_ent5_en),
        .clk(clk));

dffrle_ns #(10) l2_fifo_ent6(
        .din(l2if_fifo_ent5[9:0]),
        .q(l2if_fifo_ent6[9:0]),
	.rst_l(rst_l),
	.en(l2if_fifo_ent6_en),
        .clk(clk));

assign l2if_data_valid_reset = l2if_fifo_reset | ~rst_l;

dffrle_ns #(10) l2_fifo_ent7(
        .din(l2if_fifo_ent6[9:0]),
        .q(l2if_fifo_ent7[9:0]),
	.rst_l(~l2if_data_valid_reset),
	.en(l2if_fifo_ent7_en),
        .clk(clk));

///////
// Stage the toggle to detect the dram clk transition 
// Three stages due to 2 for valids in one dram clk and one becuase 
// data_valid is also delayed for one cycle due to data delay of 1 cycle to valid.
///////

dff_ns #(1) l2_data_valid(
        .din(l2if_dram_clk_toggle),
        .q(l2if_dram_clk_toggle_d1),
        .clk(clk));

dff_ns #(1) l2_data_valid_d1(
        .din(l2if_dram_clk_toggle_d1),
        .q(l2if_dram_clk_toggle_d2),
        .clk(clk));

//////////////////////////////////////
// VALID and OFFSET generation 
//////////////////////////////////////

// To have 2 consecutive cycles of valid, got to use d1 and d3.
assign l2if_data_cnt_val = dp_data_valid_d1 & 
				~(l2if_dram_clk_toggle_d2 == l2if_dram_clk_toggle);
 
// Assert valid only when there is no data valid from dp and start of new cycle or data.
assign l2if_dummy_data_cnt_val = (~l2if_channel_disabled & ~dp_data_valid_d1 |
				l2if_channel_disabled & ~ch0_dp_data_valid_d1) & 
				(l2if_dram_rx_sync_d1 & l2if_dram_rd_req & 
				l2if_rd_dummy_req_p1 | (|l2if_data_cnt) );

assign l2if_data_offset[1:0] = l2if_channel_disabled & ch0_dp_data_valid_d1 ? 
				ch0_dram_sctag_chunk_id : 
			(l2if_data_cnt[1:0] == 2'h0) & l2if_data_cnt_val ? 
		l2if_fifo_ent7[1:0] : (l2if_data_cnt[1:0] == 2'h0) & 
			~l2if_data_cnt_val & l2if_dummy_data_cnt_val ? l2if_rd_addr_p1[5:4] :
			dram_sctag_chunk_id[1:0] + {1'b0,l2if_offset_inc};

assign l2if_data_mux_sel_en = l2if_data_cnt_val & (l2if_fifo_ent7[6] | l2if_fifo_ent7[5]) | // loads | scrub
				l2if_dummy_data_cnt_val;
wire l2if_offset_inc_in = l2if_data_cnt_val & l2if_fifo_ent7[6] |
				l2if_dummy_data_cnt_val;

assign l2if_l2_val = l2if_channel_disabled & ch0_dp_data_valid_d1 ? 
				ch0_dram_data_val_other_ch : 
				l2if_data_cnt_val & l2if_fifo_ent7[6] & 
				(l2if_channel_disabled == l2if_fifo_ent7[8]) |
				l2if_dummy_data_cnt_val;

wire l2if_l2_val_other_ch = l2if_data_cnt_val & l2if_fifo_ent7[6] & 
				~(l2if_channel_disabled == l2if_fifo_ent7[8]);
wire [2:0] l2if_rd_req_id = l2if_channel_disabled & ch0_dp_data_valid_d1 ? 
				ch0_dram_sctag_rd_req_id[2:0] : 
				l2if_data_cnt_val ? l2if_fifo_ent7[4:2] :
				l2if_rd_id_p1[2:0];
wire l2if_pa_err_val = l2if_data_cnt_val & l2if_fifo_ent7[7] | 
				l2if_dummy_data_cnt_val & l2if_split_rd_addr[32];

dffrl_ns #(9) l2_read_response(
        .din({l2if_offset_inc_in, l2if_l2_val_other_ch, l2if_data_offset[1:0], l2if_l2_val, 
			l2if_pa_err_val, l2if_rd_req_id[2:0]}),
        .q({l2if_offset_inc, dram_data_val_other_ch, dram_sctag_chunk_id[1:0], dram_sctag_data_vld, 
			l2if_addr_err, dram_sctag_rd_req_id[2:0]}),
	.rst_l(rst_l),
        .clk(clk));

// Generate l2if_data_cnt_val for dequeing the 8 deep fifo
assign l2if_fifo_reset = (l2if_data_cnt == 2'h3) & l2if_data_cnt_val;

// Generate scrb_val for dram clk domain to flop data
// Needed to stage for 3 cycles to aligning with data and error signals

wire l2if_scrb_val = l2if_data_cnt_val & l2if_fifo_ent7[5];

dff_ns #(1) ff_scrb_val(
        .din(l2if_scrb_val),
        .q(l2if_scrb_val_d1),
        .clk(clk));

dff_ns #(1) ff_scrb_val_d1(
        .din(l2if_scrb_val_d1),
        .q(l2if_scrb_val_d2),
        .clk(clk));

wire l2if_scrb_val_d3_in = l2if_scrb_val_d2 & ~(l2if_dram_tx_sync & l2if_scrb_val_d3) ;
wire l2if_scrb_val_en = l2if_scrb_val_d3_in | l2if_dram_tx_sync & l2if_scrb_val_d3;

dffrle_ns #(1) ff_scrb_val_d2(
        .din(l2if_scrb_val_d3_in),
        .q(l2if_scrb_val_d3),
	.en(l2if_scrb_val_en),
	.rst_l(rst_l),
        .clk(clk));

/////////////////////////////////////////////////
// ECC Detect and Correct data
/////////////////////////////////////////////////

// Save addr parity for full dram cycle.
dffe_ns #(1) ff_addr_parity(
        .din(l2if_fifo_ent7[9]),
        .q(l2if_addr_parity),
	.en(l2if_dram_rx_sync),
        .clk(clk));

// XOR ecc with addr parity and make data to 0's on dummy loads
wire [31:0]     l2if_addr_par_xor_ecc = ~dp_data_valid_d1 ? 32'h0 :
                                        l2if_rd_ecc_p1[31:0] ^ {32{l2if_addr_parity}};
wire [255:0]    l2if_data = ~dp_data_valid_d1 ? 256'h0 : l2if_rd_data_p1[255:0];

// Second chunk to L2
dram_ecc_cor	dram_ecc_cor_lo(
                      	// Outputs
                        .ecc_multi_err(ecc_multi_lo_err),     
			.ecc_single_err(ecc_single_lo_err),
                        .cor_data (ecc_cor_lo_data[127:0]),
			.ecc_loc(ecc_loc_lo[35:0]),
			.syndrome (l2if_rd_ecc_d1[15:0]),
			// Inputs
                        .clk           (clk),                   
			.l2if_dram_fail_over_mode(l2if_dram_fail_over_mode),
                        .raw_data(l2if_data[127:0]),
                        .raw_ecc (l2if_addr_par_xor_ecc[15:0]));

// First chunk to L2
dram_ecc_cor    dram_ecc_cor_hi(
                        // Outputs
                        .ecc_multi_err(ecc_multi_hi_err),
			.ecc_single_err(ecc_single_hi_err),
                        .cor_data (ecc_cor_hi_data[127:0]),
			.ecc_loc(ecc_loc_hi[35:0]),
			.syndrome (l2if_rd_ecc_d1[31:16]),
                        // Inputs
                        .clk           (clk),
			.l2if_dram_fail_over_mode(l2if_dram_fail_over_mode),
                        .raw_data(l2if_data[255:128]),
                        .raw_ecc (l2if_addr_par_xor_ecc[31:16]));

// Qualify the ecc signals with the valid and also if there is dummy req we have to send 0.
// In normal read followed by dummy read the dummy read val is asserted 1 cycle earlier 
// than normal read so need to do this by pass.

wire ecc_multi_hi_err_qual = l2if_data_valid_d2 ? ecc_multi_hi_err : 1'b0;
wire ecc_single_hi_err_qual = l2if_data_valid_d2 ? ecc_single_hi_err : 1'b0;
wire ecc_multi_lo_err_qual = l2if_data_valid_d2 ? ecc_multi_lo_err : 1'b0;
wire ecc_single_lo_err_qual = l2if_data_valid_d2 ? ecc_single_lo_err : 1'b0;

dff_ns #(4) ff_ecc_signals(
        .din({ecc_multi_hi_err_qual, ecc_single_hi_err_qual, ecc_multi_lo_err_qual, ecc_single_lo_err_qual}),
        .q({ecc_multi_hi_err_d1, ecc_single_hi_err_d1, ecc_multi_lo_err_d1, ecc_single_lo_err_d1}),
        .clk(clk));

dff_ns #(256) ff_ecc_cor_data(
        .din({ecc_cor_hi_data[127:0], ecc_cor_lo_data[127:0]}),
        .q({ecc_cor_mux_hi_data[127:0], ecc_cor_mux_lo_data[127:0]}),
        .clk(clk));

// Moved from before the flop to after flop instance ff_ecc_cor_data for timing.
assign ecc_cor_hi_data_d1 = l2if_data_valid_d3 ? ecc_cor_mux_hi_data : 128'h0;
assign ecc_cor_lo_data_d1 = l2if_data_valid_d3 ? ecc_cor_mux_lo_data : 128'h0;

dff_ns #(72) l2_ecc_err_loc(
        .din({ecc_loc_hi[35:0], ecc_loc_lo[35:0]}),
        .q({ecc_loc_hi_d1[35:0], ecc_loc_lo_d1[35:0]}),
        .clk(clk));

// Generate L2 parity

assign l2if_l2_ecc_lo[6:0] = l2_ecc(ecc_cor_lo_data_d1[31:0]);
assign l2if_l2_ecc_lo[13:7] = l2_ecc(ecc_cor_lo_data_d1[63:32]);
assign l2if_l2_ecc_lo[20:14] = l2_ecc(ecc_cor_lo_data_d1[95:64]);
assign l2if_l2_ecc_lo[27:21] = l2_ecc(ecc_cor_lo_data_d1[127:96]);

assign l2if_l2_ecc_hi[6:0] = l2_ecc(ecc_cor_hi_data_d1[31:0]);
assign l2if_l2_ecc_hi[13:7] = l2_ecc(ecc_cor_hi_data_d1[63:32]);
assign l2if_l2_ecc_hi[20:14] = l2_ecc(ecc_cor_hi_data_d1[95:64]);
assign l2if_l2_ecc_hi[27:21] = l2_ecc(ecc_cor_hi_data_d1[127:96]);

////////////////////////////////////////////////
// MUX THE DATA to SEND 128bits at a time.
////////////////////////////////////////////////

dff_ns #(156) l2_read_data_d1(
        .din({l2if_l2_ecc_lo[27:0], ecc_cor_lo_data_d1[127:0]}),
        .q({l2if_rd_ecc_lo_d1[27:0], l2if_rd_data_d1[127:0]}),
        .clk(clk));

// Because the data is 2 cycles after the valid, staging is needed for l2if_data_mux_sel_en
dff_ns #(2) ff_l2if_data_mux_sel_en(
        .din({l2if_data_mux_sel_en, l2if_data_mux_sel_en_d1}),
        .q({l2if_data_mux_sel_en_d1, l2if_data_mux_sel_en_d2}),
        .clk(clk));

assign l2if_data_first_chunk_in = ~l2if_data_first_chunk;

dffrle_ns #(1) l2_data_mux_sel(
        .din(l2if_data_first_chunk_in),
        .q(l2if_data_first_chunk),
	.rst_l(rst_l),
	.en(l2if_data_mux_sel_en_d2),
        .clk(clk));

assign l2if_ecc_cor_data = l2if_channel_disabled & other_ch_dp_data_valid_d2 ? 
				ch0_dram_sctag_data : l2if_data_first_chunk ? 
				ecc_cor_hi_data_d1[127:0] : l2if_rd_data_d1[127:0]; 
assign l2if_gen_ecc = l2if_channel_disabled & other_ch_dp_data_valid_d2 ? ch0_dram_sctag_ecc : 
			l2if_data_first_chunk ? 
		{l2if_l2_ecc_hi[27:23], {2{l2if_mecc_err_partial}} ^ l2if_l2_ecc_hi[22:21],
                l2if_l2_ecc_hi[20:16], {2{l2if_mecc_err_partial}} ^ l2if_l2_ecc_hi[15:14],
                l2if_l2_ecc_hi[13:9], {2{l2if_mecc_err_partial}} ^ l2if_l2_ecc_hi[8:7],
                l2if_l2_ecc_hi[6:2], {2{l2if_mecc_err_partial}} ^ l2if_l2_ecc_hi[1:0]} :
                {l2if_rd_ecc_lo_d1[27:23], {2{l2if_mecc_err_partial}} ^ l2if_rd_ecc_lo_d1[22:21],
                l2if_rd_ecc_lo_d1[20:16], {2{l2if_mecc_err_partial}} ^ l2if_rd_ecc_lo_d1[15:14],
                l2if_rd_ecc_lo_d1[13:9], {2{l2if_mecc_err_partial}} ^ l2if_rd_ecc_lo_d1[8:7],
                l2if_rd_ecc_lo_d1[6:2], {2{l2if_mecc_err_partial}} ^ l2if_rd_ecc_lo_d1[1:0]};

dff_ns #(128) l2_read_data_p3(
        .din(l2if_ecc_cor_data[127:0]),
        .q(dram_sctag_data[127:0]),
        .clk(clk));

dff_ns #(28) l2_read_ecc_p3(
        .din(l2if_gen_ecc[27:0]),
        .q(dram_sctag_ecc[27:0]),
        .clk(clk));

// staging OUT OF BOUND error information 
dff_ns #(1) addr_out_of_bound_err(
        .din(l2if_addr_err),
        .q(l2if_addr_err_d1),
        .clk(clk));

dff_ns #(1) addr_out_of_bound_err_d1(
        .din(l2if_addr_err_d1),
        .q(l2if_addr_err_d2),
        .clk(clk));

wire l2if_pa_err = l2if_channel_disabled & other_ch_dp_data_valid_d2 ? 
			ch0_dram_sctag_pa_err : l2if_addr_err_d2;
wire l2if_int_mecc_err_partial = l2if_data_first_chunk ? ecc_multi_hi_err_d1 | l2if_pa_err : 
					ecc_multi_lo_err_d1 | l2if_pa_err;
assign l2if_mecc_err_partial = l2if_channel_disabled & other_ch_dp_data_valid_d2 ? 
				ch0_dram_sctag_mecc_err : l2if_int_mecc_err_partial;
assign l2if_secc_err = ~(l2if_mecc_err_partial | l2if_pa_err) & 
				(l2if_channel_disabled & other_ch_dp_data_valid_d2 ? 
				ch0_dram_sctag_secc_err : l2if_data_first_chunk ? 
				ecc_single_hi_err_d1 : ecc_single_lo_err_d1);

dff_ns #(3) l2_mecc_secc(
        .din({l2if_pa_err, l2if_mecc_err_partial, l2if_secc_err}),
        .q({dram_sctag_pa_err, dram_sctag_mecc_err, dram_sctag_secc_err}),
        .clk(clk));

////////////////////////////////////////////////
// Function to generate L2 ecc
////////////////////////////////////////////////

function [6:0]	l2_ecc;
input [31:0] data;

begin
// l2 ecc generation
l2_ecc[0] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6] ^ data[8] ^ 
		data[10] ^ data[11] ^ data[13] ^ data[15] ^ data[17] ^ data[19] ^ 
		data[21] ^ data[23] ^ data[25] ^ data[26] ^ data[28] ^ data[30];

l2_ecc[1] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[9] ^ 
		data[10] ^ data[12] ^ data[13] ^ data[16] ^ data[17] ^ data[20] ^ 
		data[21] ^ data[24] ^ data[25] ^ data[27] ^ data[28] ^ data[31];

l2_ecc[2] = data[1] ^ data[2] ^ data[3] ^ data[7] ^ data[8] ^ data[9] ^ 
		data[10] ^ data[14] ^ data[15] ^ data[16] ^ data[17] ^ data[22] ^ 
		data[23] ^ data[24] ^ data[25] ^ data[29] ^ data[30] ^ data[31];

l2_ecc[3] = data[4] ^ data[5] ^data[6] ^data[7] ^data[8] ^data[9] ^data[10] ^ 
		data[18] ^data[19] ^data[20] ^data[21] ^data[22] ^data[23] ^data[24] ^
		data[25];

l2_ecc[4] = data[11] ^ data[12] ^ data[13] ^ data[14] ^ data[15] ^ data[16] ^ 
		data[17] ^ data[18] ^ data[19] ^ data[20] ^ data[21] ^ data[22] ^ 
		data[23] ^ data[24] ^ data[25];

l2_ecc[5] = data[26] ^ data[27] ^ data[28] ^ data[29] ^ data[30] ^ data[31];

//l2_ecc[6] = ^{l2_ecc[5:0],data[31:0]};
// Below is the same as above optimized.
l2_ecc[6] = data[0] ^ data[1]  ^ data[2]  ^ data[4]  ^ data[5] ^ data[7] ^ 
		data[10] ^ data[11] ^ data[12] ^ data[14] ^ data[17] ^ data[18] ^ 
		data[21] ^ data[23] ^ data[24] ^ data[26] ^ data[27] ^ data[29];

end
endfunction

//////////////////////////////////////////////////////////////////
// Store the l2 poison bits which could be used later in dp for
// corrupting the data or ecc
//////////////////////////////////////////////////////////////////

// ent0
assign l2if_mecc0_en[0] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h0);
assign l2if_data_mecc0_in[0] = ~dram_cpu_wr_en[1] & data_mecc0[0] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc00 (
        .din    (l2if_data_mecc0_in[0]),
        .q      (data_mecc0[0]),
	.rst_l	(rst_l),
	.en	(l2if_mecc0_en[0]),
        .clk(clk));

assign l2if_mecc0_en[1] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h0);
assign l2if_data_mecc0_in[1] = ~dram_cpu_wr_en[3] & data_mecc0[1] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc01 (
        .din    (l2if_data_mecc0_in[1]),
        .q      (data_mecc0[1]),
	.rst_l	(rst_l),
	.en	(l2if_mecc0_en[1]),
        .clk(clk));

assign l2if_mecc0_en[2] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h1);
assign l2if_data_mecc0_in[2] = ~dram_cpu_wr_en[1] & data_mecc0[2] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc02 (
        .din    (l2if_data_mecc0_in[2]),
        .q      (data_mecc0[2]),
	.rst_l	(rst_l),
	.en	(l2if_mecc0_en[2]),
        .clk(clk));

assign l2if_mecc0_en[3] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h1);
assign l2if_data_mecc0_in[3] = ~dram_cpu_wr_en[3] & data_mecc0[3] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc03 (
        .din    (l2if_data_mecc0_in[3]),
        .q      (data_mecc0[3]),
	.rst_l	(rst_l),
	.en	(l2if_mecc0_en[3]),
        .clk(clk));

// ent1
assign l2if_mecc1_en[0] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h2);
assign l2if_data_mecc1_in[0] = ~dram_cpu_wr_en[1] & data_mecc1[0] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc10 (
        .din    (l2if_data_mecc1_in[0]),
        .q      (data_mecc1[0]),
	.rst_l	(rst_l),
	.en	(l2if_mecc1_en[0]),
        .clk(clk));

assign l2if_mecc1_en[1] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h2);
assign l2if_data_mecc1_in[1] = ~dram_cpu_wr_en[3] & data_mecc1[1] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc11 (
        .din    (l2if_data_mecc1_in[1]),
        .q      (data_mecc1[1]),
	.rst_l	(rst_l),
	.en	(l2if_mecc1_en[1]),
        .clk(clk));

assign l2if_mecc1_en[2] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h3);
assign l2if_data_mecc1_in[2] = ~dram_cpu_wr_en[1] & data_mecc1[2] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc12 (
        .din    (l2if_data_mecc1_in[2]),
        .q      (data_mecc1[2]),
	.rst_l	(rst_l),
	.en	(l2if_mecc1_en[2]),
        .clk(clk));

assign l2if_mecc1_en[3] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h3);
assign l2if_data_mecc1_in[3] = ~dram_cpu_wr_en[3] & data_mecc1[3] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc13 (
        .din    (l2if_data_mecc1_in[3]),
        .q      (data_mecc1[3]),
	.rst_l	(rst_l),
	.en	(l2if_mecc1_en[3]),
        .clk(clk));

// ent2
assign l2if_mecc2_en[0] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h4);
assign l2if_data_mecc2_in[0] = ~dram_cpu_wr_en[1] & data_mecc2[0] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc20 (
        .din    (l2if_data_mecc2_in[0]),
        .q      (data_mecc2[0]),
	.rst_l	(rst_l),
	.en	(l2if_mecc2_en[0]),
        .clk(clk));

assign l2if_mecc2_en[1] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h4);
assign l2if_data_mecc2_in[1] = ~dram_cpu_wr_en[3] & data_mecc2[1] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc21 (
        .din    (l2if_data_mecc2_in[1]),
        .q      (data_mecc2[1]),
	.rst_l	(rst_l),
	.en	(l2if_mecc2_en[1]),
        .clk(clk));

assign l2if_mecc2_en[2] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h5);
assign l2if_data_mecc2_in[2] = ~dram_cpu_wr_en[1] & data_mecc2[2] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc22 (
        .din    (l2if_data_mecc2_in[2]),
        .q      (data_mecc2[2]),
	.rst_l	(rst_l),
	.en	(l2if_mecc2_en[2]),
        .clk(clk));

assign l2if_mecc2_en[3] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h5);
assign l2if_data_mecc2_in[3] = ~dram_cpu_wr_en[3] & data_mecc2[3] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc23 (
        .din    (l2if_data_mecc2_in[3]),
        .q      (data_mecc2[3]),
	.rst_l	(rst_l),
	.en	(l2if_mecc2_en[3]),
        .clk(clk));

// ent3
assign l2if_mecc3_en[0] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h6);
assign l2if_data_mecc3_in[0] = ~dram_cpu_wr_en[1] & data_mecc3[0] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc30 (
        .din    (l2if_data_mecc3_in[0]),
        .q      (data_mecc3[0]),
	.rst_l	(rst_l),
	.en	(l2if_mecc3_en[0]),
        .clk(clk));

assign l2if_mecc3_en[1] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h6);
assign l2if_data_mecc3_in[1] = ~dram_cpu_wr_en[3] & data_mecc3[1] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc31 (
        .din    (l2if_data_mecc3_in[1]),
        .q      (data_mecc3[1]),
	.rst_l	(rst_l),
	.en	(l2if_mecc3_en[1]),
        .clk(clk));

assign l2if_mecc3_en[2] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h7);
assign l2if_data_mecc3_in[2] = ~dram_cpu_wr_en[1] & data_mecc3[2] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc32 (
        .din    (l2if_data_mecc3_in[2]),
        .q      (data_mecc3[2]),
	.rst_l	(rst_l),
	.en	(l2if_mecc3_en[2]),
        .clk(clk));

assign l2if_mecc3_en[3] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h7);
assign l2if_data_mecc3_in[3] = ~dram_cpu_wr_en[3] & data_mecc3[3] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc33 (
        .din    (l2if_data_mecc3_in[3]),
        .q      (data_mecc3[3]),
	.rst_l	(rst_l),
	.en	(l2if_mecc3_en[3]),
        .clk(clk));

// ent4
assign l2if_mecc4_en[0] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h8);
assign l2if_data_mecc4_in[0] = ~dram_cpu_wr_en[1] & data_mecc4[0] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc40 (
        .din    (l2if_data_mecc4_in[0]),
        .q      (data_mecc4[0]),
	.rst_l	(rst_l),
	.en	(l2if_mecc4_en[0]),
        .clk(clk));

assign l2if_mecc4_en[1] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h8);
assign l2if_data_mecc4_in[1] = ~dram_cpu_wr_en[3] & data_mecc4[1] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc41 (
        .din    (l2if_data_mecc4_in[1]),
        .q      (data_mecc4[1]),
	.rst_l	(rst_l),
	.en	(l2if_mecc4_en[1]),
        .clk(clk));

assign l2if_mecc4_en[2] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'h9);
assign l2if_data_mecc4_in[2] = ~dram_cpu_wr_en[1] & data_mecc4[2] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc42 (
        .din    (l2if_data_mecc4_in[2]),
        .q      (data_mecc4[2]),
	.rst_l	(rst_l),
	.en	(l2if_mecc4_en[2]),
        .clk(clk));

assign l2if_mecc4_en[3] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'h9);
assign l2if_data_mecc4_in[3] = ~dram_cpu_wr_en[3] & data_mecc4[3] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc43 (
        .din    (l2if_data_mecc4_in[3]),
        .q      (data_mecc4[3]),
	.rst_l	(rst_l),
	.en	(l2if_mecc4_en[3]),
        .clk(clk));

// ent5
assign l2if_mecc5_en[0] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'ha);
assign l2if_data_mecc5_in[0] = ~dram_cpu_wr_en[1] & data_mecc5[0] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc50 (
        .din    (l2if_data_mecc5_in[0]),
        .q      (data_mecc5[0]),
	.rst_l	(rst_l),
	.en	(l2if_mecc5_en[0]),
        .clk(clk));

assign l2if_mecc5_en[1] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'ha);
assign l2if_data_mecc5_in[1] = ~dram_cpu_wr_en[3] & data_mecc5[1] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc51 (
        .din    (l2if_data_mecc5_in[1]),
        .q      (data_mecc5[1]),
	.rst_l	(rst_l),
	.en	(l2if_mecc5_en[1]),
        .clk(clk));

assign l2if_mecc5_en[2] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'hb);
assign l2if_data_mecc5_in[2] = ~dram_cpu_wr_en[1] & data_mecc5[2] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc52 (
        .din    (l2if_data_mecc5_in[2]),
        .q      (data_mecc5[2]),
	.rst_l	(rst_l),
	.en	(l2if_mecc5_en[2]),
        .clk(clk));

assign l2if_mecc5_en[3] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'hb);
assign l2if_data_mecc5_in[3] = ~dram_cpu_wr_en[3] & data_mecc5[3] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc53 (
        .din    (l2if_data_mecc5_in[3]),
        .q      (data_mecc5[3]),
	.rst_l	(rst_l),
	.en	(l2if_mecc5_en[3]),
        .clk(clk));

// ent6
assign l2if_mecc6_en[0] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'hc);
assign l2if_data_mecc6_in[0] = ~dram_cpu_wr_en[1] & data_mecc6[0] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc60 (
        .din    (l2if_data_mecc6_in[0]),
        .q      (data_mecc6[0]),
	.rst_l	(rst_l),
	.en	(l2if_mecc6_en[0]),
        .clk(clk));

assign l2if_mecc6_en[1] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'hc);
assign l2if_data_mecc6_in[1] = ~dram_cpu_wr_en[3] & data_mecc6[1] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc61 (
        .din    (l2if_data_mecc6_in[1]),
        .q      (data_mecc6[1]),
	.rst_l	(rst_l),
	.en	(l2if_mecc6_en[1]),
        .clk(clk));

assign l2if_mecc6_en[2] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'hd);
assign l2if_data_mecc6_in[2] = ~dram_cpu_wr_en[1] & data_mecc6[2] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc62 (
        .din    (l2if_data_mecc6_in[2]),
        .q      (data_mecc6[2]),
	.rst_l	(rst_l),
	.en	(l2if_mecc6_en[2]),
        .clk(clk));

assign l2if_mecc6_en[3] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'hd);
assign l2if_data_mecc6_in[3] = ~dram_cpu_wr_en[3] & data_mecc6[3] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc63 (
        .din    (l2if_data_mecc6_in[3]),
        .q      (data_mecc6[3]),
	.rst_l	(rst_l),
	.en	(l2if_mecc6_en[3]),
        .clk(clk));

// ent7
assign l2if_mecc7_en[0] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'he);
assign l2if_data_mecc7_in[0] = ~dram_cpu_wr_en[1] & data_mecc7[0] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc70 (
        .din    (l2if_data_mecc7_in[0]),
        .q      (data_mecc7[0]),
	.rst_l	(rst_l),
	.en	(l2if_mecc7_en[0]),
        .clk(clk));

assign l2if_mecc7_en[1] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'he);
assign l2if_data_mecc7_in[1] = ~dram_cpu_wr_en[3] & data_mecc7[1] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc71 (
        .din    (l2if_data_mecc7_in[1]),
        .q      (data_mecc7[1]),
	.rst_l	(rst_l),
	.en	(l2if_mecc7_en[1]),
        .clk(clk));

assign l2if_mecc7_en[2] = |(~dram_cpu_wr_en[1:0]) & (l2if_wr_b0_data_addr[5:2] == 4'hf);
assign l2if_data_mecc7_in[2] = ~dram_cpu_wr_en[1] & data_mecc7[2] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc72 (
        .din    (l2if_data_mecc7_in[2]),
        .q      (data_mecc7[2]),
	.rst_l	(rst_l),
	.en	(l2if_mecc7_en[2]),
        .clk(clk));

assign l2if_mecc7_en[3] = |(~dram_cpu_wr_en[3:2]) & (l2if_wr_b0_data_addr[5:2] == 4'hf);
assign l2if_data_mecc7_in[3] = ~dram_cpu_wr_en[3] & data_mecc7[3] | l2if_dram_data_mecc;

dffrle_ns #(1) l2_mecc73 (
        .din    (l2if_data_mecc7_in[3]),
        .q      (data_mecc7[3]),
	.rst_l	(rst_l),
	.en	(l2if_mecc7_en[3]),
        .clk(clk));

//////////////////////////////////////
// DRAM ERROR STATUS REGISTER WRITE
//////////////////////////////////////

wire		l2if_err_sts_reg_en6;
wire		l2if_err_sts_reg_en5;
wire		l2if_err_sts_reg_en4;
wire		l2if_err_sts_reg_en3;
wire		l2if_err_sts_reg_en2;
wire		l2if_err_sts_reg_en1;
wire		l2if_err_sts_reg_en0;
wire		l2if_err_sts_reg_en;
wire [22:0]	l2if_err_sts_reg_in;

// Because the data valid is three cycles ahead of data the valid is 
// needed to be staged two more cyle.

dff_ns #(1) ff_sctag_data_vld_d1(
        	.din(dram_sctag_data_vld),
        	.q(dram_sctag_data_vld_d1),
        	.clk(clk));

dff_ns #(1) ff_sctag_data_vld_d2(
        	.din(dram_sctag_data_vld_d1),
        	.q(dram_sctag_data_vld_d2),
        	.clk(clk));

dff_ns #(6) ff_data_cnt_d1(
        .din({l2if_data_cnt[1:0], l2if_data_cnt_d1[1:0], l2if_data_cnt_d2[1:0]}),
        .q({l2if_data_cnt_d1[1:0], l2if_data_cnt_d2[1:0], l2if_data_cnt_d3[1:0]}),
        .clk(clk));

///////
// Multiple uncorrected errors 
// If s/w write and error occurs in same cycle h/w update has priority.
///////

assign l2if_err_sts_reg_en6 = (err_sts_reg[19] | err_sts_reg[17]) & 
				(l2if_scrb_data_val | dram_sctag_data_vld_d2) &
				(l2if_mecc_err_partial & ~l2if_pa_err) | 
				l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h280);
assign l2if_err_sts_reg_in[22] = (err_sts_reg[19] | err_sts_reg[17]) & 
					(l2if_mecc_err_partial & ~l2if_pa_err) ? 
					1'b1 : ~l2if_ucb_data[63] & err_sts_reg[22];
			
dffe_ns #(1)      ff_err_sts_bit40(
                .din(l2if_err_sts_reg_in[22]),
                .q(err_sts_reg[22]),
                .en(l2if_err_sts_reg_en6),
                .clk(clk));

///////
// Multiple corrected errors 
///////

assign l2if_err_sts_reg_en5 = (err_sts_reg[20] | err_sts_reg[18]) &
				(l2if_scrb_data_val | dram_sctag_data_vld_d2) &	 
				(l2if_secc_err) | 
				l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h280);
assign l2if_err_sts_reg_in[21] = (err_sts_reg[20] | err_sts_reg[18]) & (l2if_secc_err) ? 
					1'b1 : ~l2if_ucb_data[62] & err_sts_reg[21];

dffe_ns #(1)      ff_err_sts_bit39(
                .din(l2if_err_sts_reg_in[21]),
                .q(err_sts_reg[21]),
                .en(l2if_err_sts_reg_en5),
                .clk(clk));

// DRAM access correctable error
assign l2if_err_sts_reg_en4 = dram_sctag_data_vld_d2 & ~err_sts_reg[20] & (l2if_secc_err) |
				l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h280);
assign l2if_err_sts_reg_in[20] = dram_sctag_data_vld_d2 & ~err_sts_reg[20] & (l2if_secc_err) ? 
					1'b1 : ~l2if_ucb_data[61] & err_sts_reg[20];

dffe_ns #(1)      ff_err_sts_bit37(
                .din(l2if_err_sts_reg_in[20]),
                .q(err_sts_reg[20]),
                .en(l2if_err_sts_reg_en4),
                .clk(clk));

///////
// DRAM access uncorrectable error
///////

assign l2if_err_sts_reg_en3 = dram_sctag_data_vld_d2 & ~err_sts_reg[19] & 
				(l2if_mecc_err_partial & ~l2if_pa_err) |
				l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h280);
assign l2if_err_sts_reg_in[19] = dram_sctag_data_vld_d2 & ~err_sts_reg[19] & 
					(l2if_mecc_err_partial & ~l2if_pa_err) ? 1'b1 : 
					~l2if_ucb_data[60] & err_sts_reg[19];

dffe_ns #(1)      ff_err_sts_bit36(
                .din(l2if_err_sts_reg_in[19]),
                .q(err_sts_reg[19]),
                .en(l2if_err_sts_reg_en3),
                .clk(clk));

// Scrub access correctable error
assign l2if_err_sts_reg_en2 = l2if_scrb_data_val & ~err_sts_reg[18] & (l2if_secc_err) |
				l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h280);
assign l2if_err_sts_reg_in[18] = l2if_scrb_data_val & ~err_sts_reg[18] & (l2if_secc_err) ?
					1'b1 : ~l2if_ucb_data[59] & err_sts_reg[18];

dffe_ns #(1)      ff_err_sts_bit33(
                .din(l2if_err_sts_reg_in[18]),
                .q(err_sts_reg[18]),
                .en(l2if_err_sts_reg_en2),
                .clk(clk));

///////
// Scrub access uncorrectable error
///////

assign l2if_err_sts_reg_en1 = l2if_scrb_data_val & ~err_sts_reg[17] & (l2if_mecc_err_partial & ~l2if_pa_err) |
				l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h280);
assign l2if_err_sts_reg_in[17] = l2if_scrb_data_val & ~err_sts_reg[17] & (l2if_mecc_err_partial & ~l2if_pa_err) ?
				1'b1 : ~l2if_ucb_data[58] & err_sts_reg[17];

dffe_ns #(1)      ff_err_sts_bit32(
                .din(l2if_err_sts_reg_in[17]),
                .q(err_sts_reg[17]),
                .en(l2if_err_sts_reg_en1),
                .clk(clk));

///////
// OUT of BOUND PA error
///////

assign l2if_err_sts_reg_en = dram_sctag_data_vld_d2 & l2if_pa_err | l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h280);
assign l2if_err_sts_reg_in[16] = dram_sctag_data_vld_d2 & l2if_pa_err ? 1'b1 : ~l2if_ucb_data[57] & err_sts_reg[16];

dffe_ns #(1)      ff_err_sts_bit31(
                .din(l2if_err_sts_reg_in[16]),
                .q(err_sts_reg[16]),
                .en(l2if_err_sts_reg_en),
                .clk(clk));

// stage ecc with error signals to capture

dff_ns #(32)      ff_ecc_d2(
                .din(l2if_rd_ecc_d1[31:0]),
                .q(l2if_rd_ecc_d2[31:0]),
                .clk(clk));

dff_ns #(32)    ff_ecc_d3(
                .din(l2if_rd_ecc_d2[31:0]),
                .q(l2if_rd_ecc_d3[31:0]),
                .clk(clk));

// set it only if there is no prior uncorrectable error and a new uncorrectable one happens
// OR no prior uncorrectable and no prior correctable and new correctable happens

assign l2if_err_sts_reg_en0 = ((~(err_sts_reg[17] | err_sts_reg[19]) & l2if_mecc_err_partial & ~l2if_pa_err &
				(l2if_scrb_data_val | dram_sctag_data_vld_d2)) |
			(~(err_sts_reg[17] | err_sts_reg[18] | err_sts_reg[19] | err_sts_reg[20]) & 
			l2if_secc_err & (l2if_scrb_data_val | dram_sctag_data_vld_d2))) | 
			l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h280);
assign l2if_err_sts_reg_in[15:0] = l2if_channel_disabled & other_ch_dp_data_valid_d2 ?
                        ch0_err_syn_d1 : ( (~(err_sts_reg[17] | err_sts_reg[19]) & 
			(l2if_mecc_err_partial & ~l2if_pa_err)) | (~(err_sts_reg[17] | err_sts_reg[18] | 
			err_sts_reg[19] | err_sts_reg[20]) & l2if_secc_err)) ?
			(l2if_data_first_chunk ? l2if_rd_ecc_d3[31:16] : l2if_rd_ecc_d3[15:0]) : 
				l2if_ucb_data[15:0];
assign err_syn = l2if_data_first_chunk ? l2if_rd_ecc_d3[31:16] : l2if_rd_ecc_d3[15:0];

dffe_ns #(16)   ff_err_syn(
                .din(l2if_err_sts_reg_in[15:0]),
                .q(err_sts_reg[15:0]),
                .en(l2if_err_sts_reg_en0),
                .clk(clk));

//////////////////////////////////////
// DRAM ERROR ADDRESS REGISTER WRITE
//////////////////////////////////////
wire [35:0]	l2if_err_addr_reg_in;

// This address reg can only have scrub address as load address is not kept.
wire l2if_err_addr_reg_en = l2if_scrb_data_val & (l2if_mecc_err_partial & ~l2if_pa_err | l2if_secc_err) & 
				~(err_sts_reg[18] | err_sts_reg[17]) |
				l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h288);
assign l2if_err_addr_reg_in = l2if_scrb_data_val & (l2if_mecc_err_partial & ~l2if_pa_err | l2if_secc_err) ? 
		{3'h0, l2if_scrb_addr[32:2], l2if_data_cnt_d3[1:0]} : l2if_ucb_data[39:4];

dffe_ns #(36)   ff_err_addr_reg(
                .din(l2if_err_addr_reg_in[35:0]),
                .q(err_addr_reg[35:0]),
                .en(l2if_err_addr_reg_en),
                .clk(clk));

////////////////////////////////////////
// SECC ERROR COUNTER
////////////////////////////////////////
wire [15:0]	l2if_secc_cnt_in;

// interrupt enable bit - cleared @ reset and also at every error. S/W has to enable.
wire l2if_secc_int_en = l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h298);
wire l2if_secc_int_in = l2if_ucb_data[17];

dffrle_ns #(1)  ff_secc_int_en(
                .din(l2if_secc_int_in),
                .q(l2if_secc_int_enabled),
                .en(l2if_secc_int_en),
                .rst_l(rst_l),
                .clk(clk));

// counter valid
wire l2if_secc_vld_en = l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h298);
wire l2if_secc_vld_in = l2if_ucb_data[16];
wire l2if_secc_vld_rst_l = rst_l & ~(l2if_secc_vld & l2if_jbus_tx_sync & ~(|l2if_secc_cnt[15:0]));

dffrle_ns #(1)    ff_secc_vld(
                .din(l2if_secc_vld_in),
                .q(l2if_secc_vld),
                .en(l2if_secc_vld_en),
                .rst_l(l2if_secc_vld_rst_l),
                .clk(clk));

// counter value
assign l2if_secc_cnt_in = l2if_secc_err ? ((l2if_secc_cnt != 16'h0) ? (l2if_secc_cnt - 16'h1) : 
				l2if_secc_cnt) : l2if_ucb_data[15:0];
wire l2if_secc_cnt_en = l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h298) | (l2if_secc_err &
				(l2if_scrb_data_val | dram_sctag_data_vld_d2) & l2if_secc_vld);

dffe_ns #(16)   ff_secc_cnt(
                .din(l2if_secc_cnt_in),
                .q(l2if_secc_cnt),
                .en(l2if_secc_cnt_en),
                .clk(clk));

assign l2if_secc_cnt_intr = l2if_secc_int_enabled & l2if_secc_vld & ~(|l2if_secc_cnt[15:0]);

////////////////////////////////////////
// SECC DEBUG TRIGGER ENABLE REGISTER
////////////////////////////////////////

wire l2if_dbg_trig_in = ~rst_l ? l2if_dbg_trig :
			l2if_secc_trig ? 1'b0 :
			l2if_ucb_wr_req_vld & (l2if_ucb_addr == 32'h230) ? l2if_ucb_data[2] :
			l2if_dbg_trig;

dffrl_async_ns #(1)  ff_dbg_trig(
                .din(l2if_dbg_trig_in),
                .q(l2if_dbg_trig),
                .rst_l(arst_l),
                .clk(clk));

assign l2if_secc_trig = l2if_dbg_trig & ~(|l2if_secc_cnt[15:0]);

////////////////////////////////////////
// SECC ERROR LOCATION
// The interpretation of the parity is as following ecc[15:0] = {p0,p1,p2,p3} where p3 is not used
// failover mode.
// The error location is as = {err_in_p3, err_in_p2, ... err_in_d2, err_in_d1, err_in_d0}
// If the error location bit is 1, and to create mask in failover mode set all the bits left of 1 to 1 
// (including the bit 1 set in err location) upto bit location 34.
// Also this error location once logged will not be over written when another error occurs till S/W
// resets.
////////////////////////////////////////

wire [35:0]	l2if_secc_loc_in;

wire l2if_secc_loc_en = l2if_err_sts_reg_en2 & ~err_sts_reg[20] | l2if_err_sts_reg_en4 & ~err_sts_reg[18];
assign l2if_secc_loc_in = l2if_channel_disabled & other_ch_dp_data_valid_d2 ?
                        ch0_err_loc_d1 : l2if_data_first_chunk ? ecc_loc_hi_d1[35:0] : ecc_loc_lo_d1[35:0];
assign err_loc = l2if_data_first_chunk ? ecc_loc_hi_d1[35:0] : ecc_loc_lo_d1[35:0];

dffe_ns #(36)   ff_secc_loc(
                .din(l2if_secc_loc_in),
                .q(l2if_secc_loc),
                .en(l2if_secc_loc_en),
                .clk(clk));

////////////////////////////////////////
// Asserting scrub ecc error to L2 cache
////////////////////////////////////////

// use aligned scrub data valid with mecc error as l2if_srb_val three cycle off with ecc.
// Could have used l2if_scrb_val_d3 but its longer than 2 cycles till sync pulse is asserted.

dffrl_ns #(1) ff_scrb_data_en(
         .din(l2if_scrb_val_d2),
         .q(l2if_scrb_data_val),
         .rst_l(rst_l),
         .clk(clk));

wire l2if_scb_mecc_err = l2if_scrb_data_val & l2if_mecc_err_partial & ~l2if_pa_err;
wire l2if_scb_secc_err = l2if_scrb_data_val & l2if_secc_err;

dffrl_ns #(1)   ff_l2if_scrb_mecc_err(
                .din(l2if_scb_mecc_err),
                .q(dram_sctag_scb_mecc_err),
		.rst_l(rst_l),
                .clk(clk));

dffrl_ns #(1)   ff_l2if_scrb_secc_err(
                .din(l2if_scb_secc_err),
                .q(dram_sctag_scb_secc_err),
		.rst_l(rst_l),
                .clk(clk));

endmodule // dram_l2if 
