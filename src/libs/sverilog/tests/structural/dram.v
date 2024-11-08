// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram.v
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

`include "sys.h"

module dram (/*AUTOARG*/
   // Outputs
   dram_io_addr0, dram_io_addr1, dram_io_bank0, dram_io_bank1, 
   dram_io_cas0_l, dram_io_cas1_l, dram_io_channel_disabled0, 
   dram_io_channel_disabled1, dram_io_cke0, dram_io_cke1, 
   dram_io_clk_enable0, dram_io_clk_enable1, dram_io_cs0_l, 
   dram_io_cs1_l, dram_io_data0_out, dram_io_data1_out, 
   dram_io_drive_data0, dram_io_drive_data1, dram_io_drive_enable0, 
   dram_io_drive_enable1, dram_io_pad_clk_inv0, dram_io_pad_clk_inv1, 
   dram_io_pad_enable0, dram_io_pad_enable1, dram_io_ptr_clk_inv0, 
   dram_io_ptr_clk_inv1, dram_io_ras0_l, dram_io_ras1_l, 
   dram_io_write_en0_l, dram_io_write_en1_l, dram_sctag0_data_vld_r0, 
   dram_sctag0_rd_ack, dram_sctag0_scb_mecc_err, 
   dram_sctag0_scb_secc_err, dram_sctag0_wr_ack, 
   dram_sctag1_data_vld_r0, dram_sctag1_rd_ack, 
   dram_sctag1_scb_mecc_err, dram_sctag1_scb_secc_err, 
   dram_sctag1_wr_ack, ucb_iob_data, ucb_iob_stall, ucb_iob_vld, 
   dram_sctag0_chunk_id_r0, dram_sctag0_mecc_err_r2, 
   dram_sctag0_rd_req_id_r0, dram_sctag0_secc_err_r2, 
   dram_sctag1_chunk_id_r0, dram_sctag1_mecc_err_r2, 
   dram_sctag1_rd_req_id_r0, dram_sctag1_secc_err_r2, 
   dram_scbuf0_data_r2, dram_scbuf0_ecc_r2, dram_scbuf1_data_r2, 
   dram_scbuf1_ecc_r2, dram_local_pt0_opened_bank, 
   dram_local_pt1_opened_bank, dram_pt_max_banks_open_valid, 
   dram_pt_max_time_valid, dram_pt_ucb_data, dram_clk_tr, dram_so, 
   // Inputs
   dram_other_pt_max_banks_open_valid, dram_other_pt_max_time_valid, 
   dram_other_pt_ucb_data, dram_other_pt0_opened_bank, 
   dram_other_pt1_opened_bank, io_dram0_data_in, io_dram0_data_valid, 
   io_dram0_ecc_in, io_dram1_data_in, io_dram1_data_valid, 
   io_dram1_ecc_in, iob_ucb_data, iob_ucb_stall, iob_ucb_vld, 
   scbuf0_dram_data_mecc_r5, scbuf0_dram_data_vld_r5, 
   scbuf0_dram_wr_data_r5, scbuf1_dram_data_mecc_r5, 
   scbuf1_dram_data_vld_r5, scbuf1_dram_wr_data_r5, sctag0_dram_addr, 
   sctag0_dram_rd_dummy_req, sctag0_dram_rd_req, 
   sctag0_dram_rd_req_id, sctag0_dram_wr_req, sctag1_dram_addr, 
   sctag1_dram_rd_dummy_req, sctag1_dram_rd_req, 
   sctag1_dram_rd_req_id, sctag1_dram_wr_req, clspine_dram_rx_sync, 
   clspine_dram_tx_sync, clspine_jbus_rx_sync, clspine_jbus_tx_sync, 
   dram_gdbginit_l, clk_dram_jbus_cken, clk_dram_dram_cken, 
   clk_dram_cmp_cken, clspine_dram_selfrsh, global_shift_enable, 
   dram_si, jbus_gclk, dram_gclk, cmp_gclk, dram_adbginit_l, 
   dram_arst_l, jbus_grst_l, dram_grst_l, cmp_grst_l, 
   ctu_tst_scanmode, ctu_tst_pre_grst_l, ctu_tst_scan_disable, 
   ctu_tst_macrotest, ctu_tst_short_chain
   );

//////////////////////////////
// OUTPUTS
//////////////////////////////
/*UTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output [14:0]		dram_io_addr0;		// From dramctl0 of dramctl.v
output [14:0]		dram_io_addr1;		// From dramctl1 of dramctl.v
output [2:0]		dram_io_bank0;		// From dramctl0 of dramctl.v
output [2:0]		dram_io_bank1;		// From dramctl1 of dramctl.v
output			dram_io_cas0_l;		// From dramctl0 of dramctl.v
output			dram_io_cas1_l;		// From dramctl1 of dramctl.v
output			dram_io_channel_disabled0;// From dramctl0 of dramctl.v
output			dram_io_channel_disabled1;// From dramctl1 of dramctl.v
output			dram_io_cke0;		// From dramctl0 of dramctl.v
output			dram_io_cke1;		// From dramctl1 of dramctl.v
output			dram_io_clk_enable0;	// From dramctl0 of dramctl.v
output			dram_io_clk_enable1;	// From dramctl1 of dramctl.v
output [3:0]		dram_io_cs0_l;		// From dramctl0 of dramctl.v
output [3:0]		dram_io_cs1_l;		// From dramctl1 of dramctl.v
output [287:0]		dram_io_data0_out;	// From dramctl0 of dramctl.v
output [287:0]		dram_io_data1_out;	// From dramctl1 of dramctl.v
output			dram_io_drive_data0;	// From dramctl0 of dramctl.v
output			dram_io_drive_data1;	// From dramctl1 of dramctl.v
output			dram_io_drive_enable0;	// From dramctl0 of dramctl.v
output			dram_io_drive_enable1;	// From dramctl1 of dramctl.v
output 			dram_io_pad_clk_inv0;	// From dramctl0 of dramctl.v
output 			dram_io_pad_clk_inv1;	// From dramctl1 of dramctl.v
output			dram_io_pad_enable0;	// From dramctl0 of dramctl.v
output			dram_io_pad_enable1;	// From dramctl1 of dramctl.v
output [4:0]		dram_io_ptr_clk_inv0;	// From dramctl0 of dramctl.v
output [4:0]		dram_io_ptr_clk_inv1;	// From dramctl1 of dramctl.v
output			dram_io_ras0_l;		// From dramctl0 of dramctl.v
output			dram_io_ras1_l;		// From dramctl1 of dramctl.v
output			dram_io_write_en0_l;	// From dramctl0 of dramctl.v
output			dram_io_write_en1_l;	// From dramctl1 of dramctl.v
output			dram_sctag0_data_vld_r0;// From dramctl0 of dramctl.v
output			dram_sctag0_rd_ack;	// From dramctl0 of dramctl.v
output			dram_sctag0_scb_mecc_err;// From dramctl0 of dramctl.v
output			dram_sctag0_scb_secc_err;// From dramctl0 of dramctl.v
output			dram_sctag0_wr_ack;	// From dramctl0 of dramctl.v
output			dram_sctag1_data_vld_r0;// From dramctl1 of dramctl.v
output			dram_sctag1_rd_ack;	// From dramctl1 of dramctl.v
output			dram_sctag1_scb_mecc_err;// From dramctl1 of dramctl.v
output			dram_sctag1_scb_secc_err;// From dramctl1 of dramctl.v
output			dram_sctag1_wr_ack;	// From dramctl1 of dramctl.v
output [3:0]		ucb_iob_data;		// From dram_ucb of dram_ucb.v
output			ucb_iob_stall;		// From dram_ucb of dram_ucb.v
output			ucb_iob_vld;		// From dram_ucb of dram_ucb.v
output [1:0]		dram_sctag0_chunk_id_r0;// From dramctl0 of dramctl.v
output			dram_sctag0_mecc_err_r2;// From dramctl0 of dramctl.v
output [2:0]		dram_sctag0_rd_req_id_r0;// From dramctl0 of dramctl.v
output			dram_sctag0_secc_err_r2;// From dramctl0 of dramctl.v
output [1:0]		dram_sctag1_chunk_id_r0;// From dramctl1 of dramctl.v
output			dram_sctag1_mecc_err_r2;// From dramctl1 of dramctl.v
output [2:0]		dram_sctag1_rd_req_id_r0;// From dramctl1 of dramctl.v
output			dram_sctag1_secc_err_r2;// From dramctl1 of dramctl.v
output [127:0]		dram_scbuf0_data_r2;	// From dramctl0 of dramctl.v
output [27:0]		dram_scbuf0_ecc_r2;	// From dramctl0 of dramctl.v
output [127:0]		dram_scbuf1_data_r2;	// From dramctl1 of dramctl.v
output [27:0]		dram_scbuf1_ecc_r2;	// From dramctl1 of dramctl.v
output			dram_local_pt0_opened_bank;// From dramctl0 of dramctl.v
output			dram_local_pt1_opened_bank;// From dramctl1 of dramctl.v
output          	dram_pt_max_banks_open_valid;
output          	dram_pt_max_time_valid;
output [16:0]   	dram_pt_ucb_data;

// End of automatics

//////////////////////////////
// INPUTS
//////////////////////////////
/*UTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input          		dram_other_pt_max_banks_open_valid;
input          		dram_other_pt_max_time_valid;
input [16:0]   		dram_other_pt_ucb_data;
input			dram_other_pt0_opened_bank;// To dram_common_ctl of dram_common_ctl.v
input			dram_other_pt1_opened_bank;// To dram_common_ctl of dram_common_ctl.v
input [255:0]		io_dram0_data_in;	// To dramctl0 of dramctl.v
input			io_dram0_data_valid;	// To dramctl0 of dramctl.v
input [31:0]		io_dram0_ecc_in;	// To dramctl0 of dramctl.v
input [255:0]		io_dram1_data_in;	// To dramctl1 of dramctl.v
input			io_dram1_data_valid;	// To dramctl1 of dramctl.v
input [31:0]		io_dram1_ecc_in;	// To dramctl1 of dramctl.v
input [3:0]		iob_ucb_data;		// To dram_ucb of dram_ucb.v
input			iob_ucb_stall;		// To dram_ucb of dram_ucb.v
input			iob_ucb_vld;		// To dram_ucb of dram_ucb.v
input			scbuf0_dram_data_mecc_r5;// To dramctl0 of dramctl.v
input			scbuf0_dram_data_vld_r5;// To dramctl0 of dramctl.v
input [63:0]		scbuf0_dram_wr_data_r5;	// To dramctl0 of dramctl.v
input			scbuf1_dram_data_mecc_r5;// To dramctl1 of dramctl.v
input			scbuf1_dram_data_vld_r5;// To dramctl1 of dramctl.v
input [63:0]		scbuf1_dram_wr_data_r5;	// To dramctl1 of dramctl.v
input [39:5]		sctag0_dram_addr;	// To dramctl0 of dramctl.v
input			sctag0_dram_rd_dummy_req;// To dramctl0 of dramctl.v
input			sctag0_dram_rd_req;	// To dramctl0 of dramctl.v
input [2:0]		sctag0_dram_rd_req_id;	// To dramctl0 of dramctl.v
input			sctag0_dram_wr_req;	// To dramctl0 of dramctl.v
input [39:5]		sctag1_dram_addr;	// To dramctl1 of dramctl.v
input			sctag1_dram_rd_dummy_req;// To dramctl1 of dramctl.v
input			sctag1_dram_rd_req;	// To dramctl1 of dramctl.v
input [2:0]		sctag1_dram_rd_req_id;	// To dramctl1 of dramctl.v
input			sctag1_dram_wr_req;	// To dramctl1 of dramctl.v
// End of automatics

//////////////////////////////
//ddr test/clk signals
//////////////////////////////
input			clspine_dram_rx_sync;	// To dramctl0 of dramctl.v, ...
input			clspine_dram_tx_sync;	// To dramctl0 of dramctl.v, ...
input			clspine_jbus_rx_sync;	// To dramctl0 of dramctl.v, ...
input			clspine_jbus_tx_sync;	// To dramctl0 of dramctl.v, ...
input			dram_gdbginit_l;	// Debug init for repeatability @jubs freq
input           	clk_dram_jbus_cken;     // jbus clock enable 
input           	clk_dram_dram_cken; 	// ddr clock enable 
input           	clk_dram_cmp_cken;      // cmp clock enable 
input           	clspine_dram_selfrsh;   // signal from clk to put in self refresh @jbus freq
input           	global_shift_enable;    // scan shift enable signal
output          	dram_clk_tr;             // debug trigger @ jbus freq

input			dram_si;
output			dram_so;

input           	jbus_gclk;              // jbus clock
input           	dram_gclk;              // ddr clock
input           	cmp_gclk;               // cmp clock

input			dram_adbginit_l;	// active low async reset of dbginit_l
input			dram_arst_l;		// active low async reset of rst_l
input           	jbus_grst_l;            // active low reset signal
input           	dram_grst_l;            // active low reset signal
input           	cmp_grst_l;             // active low reset signal
                                        	
input			ctu_tst_scanmode;	
input			ctu_tst_pre_grst_l;	
input			ctu_tst_scan_disable;
input			ctu_tst_macrotest;
input			ctu_tst_short_chain;

//////////////////////////////////////////////////////////////////
// Wires
//////////////////////////////////////////////////////////////////
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [3:0]		ch0_dp_data_mecc0;	// From dramctl0 of dramctl.v
wire [3:0]		ch0_dp_data_mecc1;	// From dramctl0 of dramctl.v
wire [3:0]		ch0_dp_data_mecc2;	// From dramctl0 of dramctl.v
wire [3:0]		ch0_dp_data_mecc3;	// From dramctl0 of dramctl.v
wire [3:0]		ch0_dp_data_mecc4;	// From dramctl0 of dramctl.v
wire [3:0]		ch0_dp_data_mecc5;	// From dramctl0 of dramctl.v
wire [3:0]		ch0_dp_data_mecc6;	// From dramctl0 of dramctl.v
wire [3:0]		ch0_dp_data_mecc7;	// From dramctl0 of dramctl.v
wire			ch0_dp_data_valid_d1;	// From dramctl0 of dramctl.v
wire			ch0_dram_data_val_other_ch;// From dramctl0 of dramctl.v
wire [35:0]		ch0_err_loc;		// From dramctl0 of dramctl.v
wire [15:0]		ch0_err_syn;		// From dramctl0 of dramctl.v
wire [35:0]		ch0_que_b0_addr_picked;	// From dramctl0 of dramctl.v
wire			ch0_que_b0_cmd_picked;	// From dramctl0 of dramctl.v
wire [5:0]		ch0_que_b0_data_addr;	// From dramctl0 of dramctl.v
wire [2:0]		ch0_que_b0_id_picked;	// From dramctl0 of dramctl.v
wire [2:0]		ch0_que_b0_index_picked;// From dramctl0 of dramctl.v
wire [7:0]		ch0_que_cas_int_picked;	// From dramctl0 of dramctl.v
wire			ch0_que_channel_picked;	// From dramctl0 of dramctl.v
wire [6:0]		ch0_que_int_wr_que_inv_info;// From dramctl0 of dramctl.v
wire [7:0]		ch0_que_l2req_valids;	// From dramctl0 of dramctl.v
wire [255:0]		ch0_que_mem_data;	// From dramctl0 of dramctl.v
wire			ch0_que_mux_write_en;	// From dramctl0 of dramctl.v
wire [4:0]		ch0_que_pos;		// From dramctl0 of dramctl.v
wire [7:0]		ch0_que_ras_int_picked;	// From dramctl0 of dramctl.v
wire			ch0_que_wr_cas_ch01_picked;// From dramctl0 of dramctl.v
wire [3:0]		ch1_dp_data_mecc0;	// From dramctl1 of dramctl.v
wire [3:0]		ch1_dp_data_mecc1;	// From dramctl1 of dramctl.v
wire [3:0]		ch1_dp_data_mecc2;	// From dramctl1 of dramctl.v
wire [3:0]		ch1_dp_data_mecc3;	// From dramctl1 of dramctl.v
wire [3:0]		ch1_dp_data_mecc4;	// From dramctl1 of dramctl.v
wire [3:0]		ch1_dp_data_mecc5;	// From dramctl1 of dramctl.v
wire [3:0]		ch1_dp_data_mecc6;	// From dramctl1 of dramctl.v
wire [3:0]		ch1_dp_data_mecc7;	// From dramctl1 of dramctl.v
wire			ch1_dp_data_valid_d1;	// From dramctl1 of dramctl.v
wire			ch1_dram_data_val_other_ch;// From dramctl1 of dramctl.v
wire [35:0]		ch1_err_loc;		// From dramctl1 of dramctl.v
wire [15:0]		ch1_err_syn;		// From dramctl1 of dramctl.v
wire [35:0]		ch1_que_b0_addr_picked;	// From dramctl1 of dramctl.v
wire			ch1_que_b0_cmd_picked;	// From dramctl1 of dramctl.v
wire [5:0]		ch1_que_b0_data_addr;	// From dramctl1 of dramctl.v
wire [2:0]		ch1_que_b0_id_picked;	// From dramctl1 of dramctl.v
wire [2:0]		ch1_que_b0_index_picked;// From dramctl1 of dramctl.v
wire [7:0]		ch1_que_cas_int_picked;	// From dramctl1 of dramctl.v
wire			ch1_que_channel_picked;	// From dramctl1 of dramctl.v
wire [6:0]		ch1_que_int_wr_que_inv_info;// From dramctl1 of dramctl.v
wire [7:0]		ch1_que_l2req_valids;	// From dramctl1 of dramctl.v
wire [255:0]		ch1_que_mem_data;	// From dramctl1 of dramctl.v
wire			ch1_que_mux_write_en;	// From dramctl1 of dramctl.v
wire [4:0]		ch1_que_pos;		// From dramctl1 of dramctl.v
wire [7:0]		ch1_que_ras_int_picked;	// From dramctl1 of dramctl.v
wire			ch1_que_wr_cas_ch01_picked;// From dramctl1 of dramctl.v
wire			cmp_after_clk_rst_l;	// From cpu_cluster_header of bw_clk_cl_dram_cmp.v
wire			cmp_rclk;		// From cpu_cluster_header of bw_clk_cl_dram_cmp.v
wire			cpu_cluster_so;		// From cpu_cluster_header of bw_clk_cl_dram_cmp.v
wire			dbginit_l;		// From dram_cluster_header of bw_clk_cl_dram_ddr.v
wire			dram_cluster_so;	// From dram_cluster_header of bw_clk_cl_dram_ddr.v
wire			dram_dram_rx_sync;	// From jbus_cluster_header_sync of cluster_header_sync.v
wire			dram_dram_tx_sync;	// From jbus_cluster_header_sync of cluster_header_sync.v
wire			dram_jbus_rx_sync;	// From jbus_cluster_header_sync of cluster_header_sync.v
wire			dram_jbus_tx_sync;	// From jbus_cluster_header_sync of cluster_header_sync.v
wire			dram_rclk;		// From dram_cluster_header of bw_clk_cl_dram_ddr.v
wire			dram_rst_l;		// From dram_cluster_header of bw_clk_cl_dram_ddr.v
wire			dram_sctag0_pa_err_r2;	// From dramctl0 of dramctl.v
wire			dram_sctag1_pa_err_r2;	// From dramctl1 of dramctl.v
wire			dram_ucb_ack_vld0;	// From dramctl0 of dramctl.v
wire			dram_ucb_ack_vld1;	// From dramctl1 of dramctl.v
wire [63:0]		dram_ucb_data0;		// From dramctl0 of dramctl.v
wire [63:0]		dram_ucb_data1;		// From dramctl1 of dramctl.v
wire			dram_ucb_nack_vld0;	// From dramctl0 of dramctl.v
wire			dram_ucb_nack_vld1;	// From dramctl1 of dramctl.v
wire			jbus_cluster_so;	// From jbus_cluster_header of bw_clk_cl_dram_jbus.v
wire			jbus_rclk;		// From jbus_cluster_header of bw_clk_cl_dram_jbus.v
wire			jbus_rst_l;		// From jbus_cluster_header of bw_clk_cl_dram_jbus.v
wire			l2if0_channel_disabled;	// From dramctl0 of dramctl.v
wire			l2if1_channel_disabled;	// From dramctl1 of dramctl.v
wire			l2if_err_intr0;		// From dramctl0 of dramctl.v
wire			l2if_err_intr1;		// From dramctl1 of dramctl.v
wire			l2if_ucb_trig0;		// From dramctl0 of dramctl.v
wire			l2if_ucb_trig1;		// From dramctl1 of dramctl.v
wire [64:0]		listen_out0;		// From dramctl0 of dramctl.v
wire [64:0]		listen_out1;		// From dramctl1 of dramctl.v
wire			mem_bypass;		// From test_stub_scan of test_stub_scan.v
wire			pt_ch0_blk_new_openbank;// From dram_pt of dram_pt.v
wire			pt_ch1_blk_new_openbank;// From dram_pt of dram_pt.v
wire [16:0]		pt_max_banks_open;	// From dram_pt of dram_pt.v
wire [15:0]		pt_max_time;		// From dram_pt of dram_pt.v
wire			que0_channel_disabled;	// From dramctl0 of dramctl.v
wire			que1_channel_disabled;	// From dramctl1 of dramctl.v
wire [16:0]		que_max_banks_open0;	// From dramctl0 of dramctl.v
wire [16:0]		que_max_banks_open1;	// From dramctl1 of dramctl.v
wire			que_max_banks_open_valid0;// From dramctl0 of dramctl.v
wire			que_max_banks_open_valid1;// From dramctl1 of dramctl.v
wire			que_max_time_valid0;	// From dramctl0 of dramctl.v
wire			que_max_time_valid1;	// From dramctl1 of dramctl.v
wire			se;			// From test_stub_scan of test_stub_scan.v
wire			sehold;			// From test_stub_scan of test_stub_scan.v
wire			so_0;			// From test_stub_scan of test_stub_scan.v
wire			testmode_l;		// From test_stub_scan of test_stub_scan.v
wire [31:0]		ucb_dram_addr;		// From dram_ucb of dram_ucb.v
wire [63:0]		ucb_dram_data;		// From dram_ucb of dram_ucb.v
wire			ucb_dram_rd_req_vld0;	// From dram_ucb of dram_ucb.v
wire			ucb_dram_rd_req_vld1;	// From dram_ucb of dram_ucb.v
wire			ucb_dram_wr_req_vld0;	// From dram_ucb of dram_ucb.v
wire			ucb_dram_wr_req_vld1;	// From dram_ucb of dram_ucb.v
wire			ucb_l2if_selfrsh;	// From dram_ucb of dram_ucb.v
// End of automatics

wire			cpu_cluster_si;
wire			dram_cluster_si;
wire			jbus_cluster_si;
wire			long_chain_so_0;
wire			short_chain_so_0;

/*****************************************************************
* Cluster Header
****************************************************************/

/*bw_clk_cl_dram_ddr AUTO_TEMPLATE(.rclk(dram_rclk),
				.cluster_grst_l(dram_rst_l),
				.gclk(dram_gclk),
                                .grst_l(dram_grst_l),
				.so(dram_cluster_so),
				.si(dram_cluster_si),
				.se(se),
				.arst_l(dram_arst_l),
				.gdbginit_l(dram_gdbginit_l),
				.adbginit_l(dram_adbginit_l),
                                .cluster_cken(clk_dram_dram_cken));
*/

bw_clk_cl_dram_ddr dram_cluster_header(/*AUTOINST*/
				       // Outputs
				       .cluster_grst_l(dram_rst_l), // Templated
				       .dbginit_l(dbginit_l),
				       .rclk(dram_rclk),	 // Templated
				       .so(dram_cluster_so),	 // Templated
				       // Inputs
				       .adbginit_l(dram_adbginit_l), // Templated
				       .arst_l(dram_arst_l),	 // Templated
				       .cluster_cken(clk_dram_dram_cken), // Templated
				       .gclk(dram_gclk),	 // Templated
				       .gdbginit_l(dram_gdbginit_l), // Templated
				       .grst_l(dram_grst_l),	 // Templated
				       .se(se),			 // Templated
				       .si(dram_cluster_si));	 // Templated
/*bw_clk_cl_dram_cmp AUTO_TEMPLATE(.rclk(cmp_rclk),
				.dbginit_l(),
                                .cluster_grst_l(cmp_after_clk_rst_l),
                                .gclk(cmp_gclk),
                                .grst_l(cmp_grst_l),
				.so(cpu_cluster_so),
				.si(cpu_cluster_si),
				.se(se),
				.arst_l(dram_arst_l),
				.adbginit_l(1'b1),
				.gdbginit_l(1'b1),
                                .cluster_cken(clk_dram_cmp_cken));
*/

bw_clk_cl_dram_cmp cpu_cluster_header(/*AUTOINST*/
				      // Outputs
				      .cluster_grst_l(cmp_after_clk_rst_l), // Templated
				      .dbginit_l(),		 // Templated
				      .rclk(cmp_rclk),		 // Templated
				      .so(cpu_cluster_so),	 // Templated
				      // Inputs
				      .adbginit_l(1'b1),	 // Templated
				      .arst_l(dram_arst_l),	 // Templated
				      .cluster_cken(clk_dram_cmp_cken), // Templated
				      .gclk(cmp_gclk),		 // Templated
				      .gdbginit_l(1'b1),	 // Templated
				      .grst_l(cmp_grst_l),	 // Templated
				      .se(se),			 // Templated
				      .si(cpu_cluster_si));	 // Templated
dffrl_async_ns #(1) async_rst_flop(
                .din(cmp_after_clk_rst_l),
                .q(cmp_rst_l),
                .rst_l(dram_arst_l),
                .clk(cmp_rclk));

/*bw_clk_cl_dram_jbus AUTO_TEMPLATE(.rclk(jbus_rclk),
				.dbginit_l(),
				.cluster_grst_l(jbus_rst_l),
				.gclk(jbus_gclk),
                                .grst_l(jbus_grst_l),
				.so(jbus_cluster_so),
				.si(jbus_cluster_si),
				.se(se),
				.arst_l(dram_arst_l),
				.adbginit_l(1'b1),
				.gdbginit_l(1'b1),
                                .cluster_cken(clk_dram_jbus_cken));
*/

bw_clk_cl_dram_jbus jbus_cluster_header(/*AUTOINST*/
					// Outputs
					.cluster_grst_l(jbus_rst_l), // Templated
					.dbginit_l(),		 // Templated
					.rclk(jbus_rclk),	 // Templated
					.so(jbus_cluster_so),	 // Templated
					// Inputs
					.adbginit_l(1'b1),	 // Templated
					.arst_l(dram_arst_l),	 // Templated
					.cluster_cken(clk_dram_jbus_cken), // Templated
					.gclk(jbus_gclk),	 // Templated
					.gdbginit_l(1'b1),	 // Templated
					.grst_l(jbus_grst_l),	 // Templated
					.se(se),		 // Templated
					.si(jbus_cluster_si));	 // Templated
/*****************************************************************
* Test Stub
****************************************************************/

/*test_stub_scan AUTO_TEMPLATE(.rclk(dram_rclk),
				.arst_l(dram_arst_l),
				.mux_drive_disable(),
				.mem_write_disable(),
				.long_chain_so_1(),
				.long_chain_so_2(),
				.short_chain_so_1(),
				.short_chain_so_2(),
				.so_1(),
				.so_2());
*/

test_stub_scan       test_stub_scan(/*AUTOINST*/
				    // Outputs
				    .mux_drive_disable(),	 // Templated
				    .mem_write_disable(),	 // Templated
				    .sehold(sehold),
				    .se	(se),
				    .testmode_l(testmode_l),
				    .mem_bypass(mem_bypass),
				    .so_0(so_0),
				    .so_1(),			 // Templated
				    .so_2(),			 // Templated
				    // Inputs
				    .ctu_tst_pre_grst_l(ctu_tst_pre_grst_l),
				    .arst_l(dram_arst_l),	 // Templated
				    .global_shift_enable(global_shift_enable),
				    .ctu_tst_scan_disable(ctu_tst_scan_disable),
				    .ctu_tst_scanmode(ctu_tst_scanmode),
				    .ctu_tst_macrotest(ctu_tst_macrotest),
				    .ctu_tst_short_chain(ctu_tst_short_chain),
				    .long_chain_so_0(long_chain_so_0),
				    .short_chain_so_0(short_chain_so_0),
				    .long_chain_so_1(),		 // Templated
				    .short_chain_so_1(),	 // Templated
				    .long_chain_so_2(),		 // Templated
				    .short_chain_so_2());	 // Templated
/*****************************************************************
* cluster header synchronizers 
****************************************************************/

/* cluster_header_sync AUTO_TEMPLATE(
                                .dram_rx_sync_local(dram_dram_rx_sync),
                                .dram_tx_sync_local(dram_dram_tx_sync),
    				.jbus_rx_sync_local(dram_jbus_rx_sync),
    				.jbus_tx_sync_local(dram_jbus_tx_sync),
    				.so(),                       
                                .dram_rx_sync_global(clspine_dram_rx_sync),
                                .dram_tx_sync_global(clspine_dram_tx_sync),
    				.jbus_rx_sync_global(clspine_jbus_rx_sync),
    				.jbus_tx_sync_global(clspine_jbus_tx_sync),
    				.cmp_rclk(cmp_rclk),                       
    				.si());
*/

cluster_header_sync jbus_cluster_header_sync(/*AUTOINST*/
					     // Outputs
					     .dram_rx_sync_local(dram_dram_rx_sync), // Templated
					     .dram_tx_sync_local(dram_dram_tx_sync), // Templated
					     .jbus_rx_sync_local(dram_jbus_rx_sync), // Templated
					     .jbus_tx_sync_local(dram_jbus_tx_sync), // Templated
					     .so(),		 // Templated
					     // Inputs
					     .dram_rx_sync_global(clspine_dram_rx_sync), // Templated
					     .dram_tx_sync_global(clspine_dram_tx_sync), // Templated
					     .jbus_rx_sync_global(clspine_jbus_rx_sync), // Templated
					     .jbus_tx_sync_global(clspine_jbus_tx_sync), // Templated
					     .cmp_gclk(cmp_gclk),
					     .cmp_rclk(cmp_rclk), // Templated
					     .si(),		 // Templated
					     .se(se));

/*****************************************************************
* DRAM controller design 
****************************************************************/

/* dramctl AUTO_TEMPLATE(
		// Outputs
		.que_cas_int_picked 	(ch@_que_cas_int_picked[7:0]), 
		.que_wr_cas_ch01_picked (ch@_que_wr_cas_ch01_picked),
		.que_mux_write_en 	(ch@_que_mux_write_en),     
		.err_loc		(ch@_err_loc[35:0]),
		.err_syn		(ch@_err_syn[15:0]),
		.listen_out		(listen_out@[64:0]),
		.que_channel_disabled	(que@_channel_disabled),
		.dram_io_channel_disabled(dram_io_channel_disabled@),
		.l2if_channel_disabled	(l2if@_channel_disabled),
		.que_int_pos		(ch@_que_pos[4:0]),
		.que_mem_data		(ch@_que_mem_data[255:0]),
		.dp_data_mecc0		(ch@_dp_data_mecc0[3:0]),
		.dp_data_mecc1		(ch@_dp_data_mecc1[3:0]),
		.dp_data_mecc2		(ch@_dp_data_mecc2[3:0]),
		.dp_data_mecc3		(ch@_dp_data_mecc3[3:0]),
		.dp_data_mecc4		(ch@_dp_data_mecc4[3:0]),
		.dp_data_mecc5		(ch@_dp_data_mecc5[3:0]),
		.dp_data_mecc6		(ch@_dp_data_mecc6[3:0]),
		.dp_data_mecc7		(ch@_dp_data_mecc7[3:0]),
		.que_int_wr_que_inv_info(ch@_que_int_wr_que_inv_info[6:0]),
		.dp_data_valid_d1	(ch@_dp_data_valid_d1),
		.que_ras_int_picked	(ch@_que_ras_int_picked[7:0]),
		.que_b0_data_addr	(ch@_que_b0_data_addr[5:0]),
		.que_l2req_valids	(ch@_que_l2req_valids[7:0]),
		.que_b0_addr_picked	(ch@_que_b0_addr_picked[35:0]),
		.que_b0_id_picked	(ch@_que_b0_id_picked[2:0]),
		.que_b0_index_picked	(ch@_que_b0_index_picked[2:0]),
		.que_b0_cmd_picked	(ch@_que_b0_cmd_picked),
		.que_channel_picked	(ch@_que_channel_picked),
		.dram_data_val_other_ch	(ch@_dram_data_val_other_ch),
		.dram_sctag_scb_mecc_err(dram_sctag@_scb_mecc_err),
		.dram_sctag_scb_secc_err(dram_sctag@_scb_secc_err),
		.dram_io_clk_enable	(dram_io_clk_enable@),
		.dram_io_pad_clk_inv	(dram_io_pad_clk_inv@),
		.dram_io_ptr_clk_inv	(dram_io_ptr_clk_inv@),
		.dram_io_pad_enable	(dram_io_pad_enable@),
		.dram_local_pt_opened_bank(dram_local_pt@_opened_bank),
		.que_max_banks_open_valid(que_max_banks_open_valid@),
		.que_max_banks_open	(que_max_banks_open@[16:0]),
		.que_max_time_valid	(que_max_time_valid@),
		.dram_sctag_chunk_id	(dram_sctag@_chunk_id_r0[1:0]),
		.dram_sctag_data_vld	(dram_sctag@_data_vld_r0),
		.dram_sctag_rd_req_id	(dram_sctag@_rd_req_id_r0[2:0]),
		.dram_sctag_data	(dram_scbuf@_data_r2[127:0]),
		.dram_sctag_mecc_err	(dram_sctag@_mecc_err_r2),
		.dram_sctag_pa_err	(dram_sctag@_pa_err_r2),
		.dram_sctag_secc_err	(dram_sctag@_secc_err_r2),
		.dram_sctag_ecc		(dram_scbuf@_ecc_r2[27:0]),
		.dram_sctag_rd_ack	(dram_sctag@_rd_ack),
		.dram_sctag_wr_ack	(dram_sctag@_wr_ack),
		.dram_io_data_out	(dram_io_data@_out[287:0]),
		.dram_io_addr		(dram_io_addr@[14:0]),
		.dram_io_bank		(dram_io_bank@[2:0]),
		.dram_io_cas_l		(dram_io_cas@_l),
		.dram_io_cke		(dram_io_cke@),
		.dram_io_cs_l		(dram_io_cs@_l[3:0]),
		.dram_io_drive_data	(dram_io_drive_data@),
		.dram_io_drive_enable	(dram_io_drive_enable@),
		.dram_io_ras_l		(dram_io_ras@_l),
		.dram_io_write_en_l	(dram_io_write_en@_l),
                .l2if_err_intr 		(l2if_err_intr@),
                .dram_ucb_ack_vld 	(dram_ucb_ack_vld@),
                .dram_ucb_nack_vld 	(dram_ucb_nack_vld@),
                .dram_ucb_data    	(dram_ucb_data@[63:0]),
		.l2if_ucb_trig		(l2if_ucb_trig@),
		// Inputs
		.other_que_pos		(ch@"(% (+ @ 1) 2)"_que_pos[4:0]),
		.dram_dbginit_l		(dbginit_l),
		.margin			(8'h55),
		.mem_bypass		(mem_bypass),
		.sehold			(sehold),
		.ch0_que_cas_int_picked	(ch@"(% (+ @ 1) 2)"_que_cas_int_picked[7:0]),
		.ch0_que_wr_cas_ch01_picked(ch@"(% (+ @ 1) 2)"_que_wr_cas_ch01_picked),
		.ch0_que_mux_write_en	(ch@"(% (+ @ 1) 2)"_que_mux_write_en),
		.other_que_channel_disabled(que@"(% (+ @ 1) 2)"_channel_disabled),
		.other_channel_disabled	(l2if@"(% (+ @ 1) 2)"_channel_disabled),
		.ch1_que_mem_data	(ch@"(% (+ @ 1) 2)"_que_mem_data[255:0]),
		.ch1_dp_data_mecc0	(ch@"(% (+ @ 1) 2)"_dp_data_mecc0[3:0]),
		.ch1_dp_data_mecc1	(ch@"(% (+ @ 1) 2)"_dp_data_mecc1[3:0]),
		.ch1_dp_data_mecc2	(ch@"(% (+ @ 1) 2)"_dp_data_mecc2[3:0]),
		.ch1_dp_data_mecc3	(ch@"(% (+ @ 1) 2)"_dp_data_mecc3[3:0]),
		.ch1_dp_data_mecc4	(ch@"(% (+ @ 1) 2)"_dp_data_mecc4[3:0]),
		.ch1_dp_data_mecc5	(ch@"(% (+ @ 1) 2)"_dp_data_mecc5[3:0]),
		.ch1_dp_data_mecc6	(ch@"(% (+ @ 1) 2)"_dp_data_mecc6[3:0]),
		.ch1_dp_data_mecc7	(ch@"(% (+ @ 1) 2)"_dp_data_mecc7[3:0]),
		.ch1_que_int_wr_que_inv_info	(ch@"(% (+ @ 1) 2)"_que_int_wr_que_inv_info[6:0]),
		.ch1_que_l2req_valids	(ch@"(% (+ @ 1) 2)"_que_l2req_valids[7:0]),
		.ch1_que_b0_addr_picked	(ch@"(% (+ @ 1) 2)"_que_b0_addr_picked[35:0]),
		.ch1_que_b0_id_picked	(ch@"(% (+ @ 1) 2)"_que_b0_id_picked[2:0]),
		.ch1_que_b0_index_picked(ch@"(% (+ @ 1) 2)"_que_b0_index_picked[2:0]),
		.ch1_que_b0_cmd_picked	(ch@"(% (+ @ 1) 2)"_que_b0_cmd_picked),
		.ch0_que_ras_int_picked	(ch@"(% (+ @ 1) 2)"_que_ras_int_picked[7:0]),
		.ch0_que_b0_data_addr	(ch@"(% (+ @ 1) 2)"_que_b0_data_addr[5:0]),
		.ch0_que_channel_picked	(ch@"(% (+ @ 1) 2)"_que_channel_picked),
		.ch0_dram_data_val_other_ch(ch@"(% (+ @ 1) 2)"_dram_data_val_other_ch),
		.ch0_dram_sctag_chunk_id(dram_sctag@"(% (+ @ 1) 2)"_chunk_id_r0[1:0]),
		.ch0_dram_sctag_rd_req_id	(dram_sctag@"(% (+ @ 1) 2)"_rd_req_id_r0[2:0]),
		.ch0_dram_sctag_data	(dram_scbuf@"(% (+ @ 1) 2)"_data_r2[127:0]),
		.ch0_dram_sctag_ecc	(dram_scbuf@"(% (+ @ 1) 2)"_ecc_r2[27:0]),
		.ch0_dram_sctag_mecc_err(dram_sctag@"(% (+ @ 1) 2)"_mecc_err_r2),
		.ch0_dram_sctag_pa_err(dram_sctag@"(% (+ @ 1) 2)"_pa_err_r2),
		.ch0_dram_sctag_secc_err(dram_sctag@"(% (+ @ 1) 2)"_secc_err_r2),
		.ch0_dp_data_valid_d1	(ch@"(% (+ @ 1) 2)"_dp_data_valid_d1),
		.ch0_err_loc		(ch@"(% (+ @ 1) 2)"_err_loc[35:0]),
		.ch0_err_syn		(ch@"(% (+ @ 1) 2)"_err_syn[15:0]),
		.dram_dram_rx_sync	(dram_dram_rx_sync),
		.dram_dram_tx_sync	(dram_dram_tx_sync),
		.dram_jbus_rx_sync	(dram_jbus_rx_sync),
		.dram_jbus_tx_sync	(dram_jbus_tx_sync),
		.ucb_l2if_slfrsh	(ucb_l2if_selfrsh),
		.pt_ch_blk_new_openbank	(pt_ch@_blk_new_openbank),
		.pt_max_banks_open	(pt_max_banks_open[16:0]),
		.pt_max_time		(pt_max_time[15:0]),
		.ucb_dram_rd_req_vld	(ucb_dram_rd_req_vld@),
                .ucb_dram_wr_req_vld	(ucb_dram_wr_req_vld@),
                .ucb_dram_addr    	(ucb_dram_addr[31:0]),
                .ucb_dram_data    	(ucb_dram_data[63:0]),
		.sctag_dram_rd_req	(sctag@_dram_rd_req),
		.sctag_dram_rd_dummy_req(sctag@_dram_rd_dummy_req),
		.sctag_dram_data_vld	(scbuf@_dram_data_vld_r5),
		.sctag_dram_rd_req_id	(sctag@_dram_rd_req_id[2:0]),
		.sctag_dram_addr	(sctag@_dram_addr[39:5]),
		.sctag_dram_wr_req	(sctag@_dram_wr_req),
		.sctag_dram_wr_data	(scbuf@_dram_wr_data_r5[63:0]),
		.sctag_dram_data_mecc	(scbuf@_dram_data_mecc_r5),
		.cmp_clk		(cmp_rclk),
		.cmp_rst_l		(cmp_rst_l),
		.dram_clk		(dram_rclk),
		.dram_rst_l		(dram_rst_l),
		.dram_arst_l		(dram_arst_l),
		.io_dram_data_valid	(io_dram@_data_valid),
		.io_dram_data_in	(io_dram@_data_in[255:0]),
		.io_dram_ecc_in		(io_dram@_ecc_in[31:0]));
*/

/*****************************************************************
* Channel 0 or 1 in four Channel mode
****************************************************************/

dramctl	dramctl0(/*AUTOINST*/
		 // Outputs
		 .l2if_ucb_trig		(l2if_ucb_trig0),	 // Templated
		 .dram_sctag_chunk_id	(dram_sctag0_chunk_id_r0[1:0]), // Templated
		 .dram_sctag_data_vld	(dram_sctag0_data_vld_r0), // Templated
		 .dram_sctag_rd_req_id	(dram_sctag0_rd_req_id_r0[2:0]), // Templated
		 .dram_sctag_data	(dram_scbuf0_data_r2[127:0]), // Templated
		 .dram_sctag_mecc_err	(dram_sctag0_mecc_err_r2), // Templated
		 .dram_sctag_pa_err	(dram_sctag0_pa_err_r2), // Templated
		 .dram_sctag_secc_err	(dram_sctag0_secc_err_r2), // Templated
		 .dram_sctag_ecc	(dram_scbuf0_ecc_r2[27:0]), // Templated
		 .dram_sctag_rd_ack	(dram_sctag0_rd_ack),	 // Templated
		 .dram_sctag_wr_ack	(dram_sctag0_wr_ack),	 // Templated
		 .dram_io_data_out	(dram_io_data0_out[287:0]), // Templated
		 .dram_io_addr		(dram_io_addr0[14:0]),	 // Templated
		 .dram_io_bank		(dram_io_bank0[2:0]),	 // Templated
		 .dram_io_cas_l		(dram_io_cas0_l),	 // Templated
		 .dram_io_cke		(dram_io_cke0),		 // Templated
		 .dram_io_cs_l		(dram_io_cs0_l[3:0]),	 // Templated
		 .dram_io_drive_data	(dram_io_drive_data0),	 // Templated
		 .dram_io_drive_enable	(dram_io_drive_enable0), // Templated
		 .dram_io_ras_l		(dram_io_ras0_l),	 // Templated
		 .dram_io_write_en_l	(dram_io_write_en0_l),	 // Templated
		 .dram_io_pad_enable	(dram_io_pad_enable0),	 // Templated
		 .dram_io_clk_enable	(dram_io_clk_enable0),	 // Templated
		 .dram_io_ptr_clk_inv	(dram_io_ptr_clk_inv0),	 // Templated
		 .dram_io_pad_clk_inv	(dram_io_pad_clk_inv0),	 // Templated
		 .dram_io_channel_disabled(dram_io_channel_disabled0), // Templated
		 .dram_ucb_ack_vld	(dram_ucb_ack_vld0),	 // Templated
		 .dram_ucb_nack_vld	(dram_ucb_nack_vld0),	 // Templated
		 .dram_ucb_data		(dram_ucb_data0[63:0]),	 // Templated
		 .l2if_err_intr		(l2if_err_intr0),	 // Templated
		 .dram_local_pt_opened_bank(dram_local_pt0_opened_bank), // Templated
		 .que_max_banks_open_valid(que_max_banks_open_valid0), // Templated
		 .que_max_banks_open	(que_max_banks_open0[16:0]), // Templated
		 .que_max_time_valid	(que_max_time_valid0),	 // Templated
		 .dram_sctag_scb_mecc_err(dram_sctag0_scb_mecc_err), // Templated
		 .dram_sctag_scb_secc_err(dram_sctag0_scb_secc_err), // Templated
		 .que_int_pos		(ch0_que_pos[4:0]),	 // Templated
		 .que_int_wr_que_inv_info(ch0_que_int_wr_que_inv_info[6:0]), // Templated
		 .que_ras_int_picked	(ch0_que_ras_int_picked[7:0]), // Templated
		 .que_b0_data_addr	(ch0_que_b0_data_addr[5:0]), // Templated
		 .que_l2req_valids	(ch0_que_l2req_valids[7:0]), // Templated
		 .que_b0_addr_picked	(ch0_que_b0_addr_picked[35:0]), // Templated
		 .que_b0_id_picked	(ch0_que_b0_id_picked[2:0]), // Templated
		 .que_b0_index_picked	(ch0_que_b0_index_picked[2:0]), // Templated
		 .que_b0_cmd_picked	(ch0_que_b0_cmd_picked), // Templated
		 .que_channel_picked	(ch0_que_channel_picked), // Templated
		 .dp_data_valid_d1	(ch0_dp_data_valid_d1),	 // Templated
		 .dram_data_val_other_ch(ch0_dram_data_val_other_ch), // Templated
		 .que_mem_data		(ch0_que_mem_data[255:0]), // Templated
		 .dp_data_mecc0		(ch0_dp_data_mecc0[3:0]), // Templated
		 .dp_data_mecc1		(ch0_dp_data_mecc1[3:0]), // Templated
		 .dp_data_mecc2		(ch0_dp_data_mecc2[3:0]), // Templated
		 .dp_data_mecc3		(ch0_dp_data_mecc3[3:0]), // Templated
		 .dp_data_mecc4		(ch0_dp_data_mecc4[3:0]), // Templated
		 .dp_data_mecc5		(ch0_dp_data_mecc5[3:0]), // Templated
		 .dp_data_mecc6		(ch0_dp_data_mecc6[3:0]), // Templated
		 .dp_data_mecc7		(ch0_dp_data_mecc7[3:0]), // Templated
		 .err_syn		(ch0_err_syn[15:0]),	 // Templated
		 .err_loc		(ch0_err_loc[35:0]),	 // Templated
		 .que_channel_disabled	(que0_channel_disabled), // Templated
		 .l2if_channel_disabled	(l2if0_channel_disabled), // Templated
		 .listen_out		(listen_out0[64:0]),	 // Templated
		 .que_cas_int_picked	(ch0_que_cas_int_picked[7:0]), // Templated
		 .que_wr_cas_ch01_picked(ch0_que_wr_cas_ch01_picked), // Templated
		 .que_mux_write_en	(ch0_que_mux_write_en),	 // Templated
		 // Inputs
		 .ucb_l2if_selfrsh	(ucb_l2if_selfrsh),
		 .dram_dbginit_l	(dbginit_l),		 // Templated
		 .sctag_dram_rd_req	(sctag0_dram_rd_req),	 // Templated
		 .sctag_dram_rd_dummy_req(sctag0_dram_rd_dummy_req), // Templated
		 .sctag_dram_data_vld	(scbuf0_dram_data_vld_r5), // Templated
		 .sctag_dram_rd_req_id	(sctag0_dram_rd_req_id[2:0]), // Templated
		 .sctag_dram_addr	(sctag0_dram_addr[39:5]), // Templated
		 .sctag_dram_wr_req	(sctag0_dram_wr_req),	 // Templated
		 .sctag_dram_wr_data	(scbuf0_dram_wr_data_r5[63:0]), // Templated
		 .sctag_dram_data_mecc	(scbuf0_dram_data_mecc_r5), // Templated
		 .cmp_clk		(cmp_rclk),		 // Templated
		 .dram_clk		(dram_rclk),		 // Templated
		 .cmp_rst_l		(cmp_rst_l),		 // Templated
		 .dram_rst_l		(dram_rst_l),		 // Templated
		 .dram_arst_l		(dram_arst_l),		 // Templated
		 .io_dram_data_valid	(io_dram0_data_valid),	 // Templated
		 .io_dram_data_in	(io_dram0_data_in[255:0]), // Templated
		 .io_dram_ecc_in	(io_dram0_ecc_in[31:0]), // Templated
		 .ucb_dram_rd_req_vld	(ucb_dram_rd_req_vld0),	 // Templated
		 .ucb_dram_wr_req_vld	(ucb_dram_wr_req_vld0),	 // Templated
		 .ucb_dram_addr		(ucb_dram_addr[31:0]),	 // Templated
		 .ucb_dram_data		(ucb_dram_data[63:0]),	 // Templated
		 .pt_ch_blk_new_openbank(pt_ch0_blk_new_openbank), // Templated
		 .pt_max_banks_open	(pt_max_banks_open[16:0]), // Templated
		 .pt_max_time		(pt_max_time[15:0]),	 // Templated
		 .dram_dram_rx_sync	(dram_dram_rx_sync),	 // Templated
		 .dram_dram_tx_sync	(dram_dram_tx_sync),	 // Templated
		 .dram_jbus_rx_sync	(dram_jbus_rx_sync),	 // Templated
		 .dram_jbus_tx_sync	(dram_jbus_tx_sync),	 // Templated
		 .ch0_que_ras_int_picked(ch1_que_ras_int_picked[7:0]), // Templated
		 .ch0_que_b0_data_addr	(ch1_que_b0_data_addr[5:0]), // Templated
		 .ch0_que_channel_picked(ch1_que_channel_picked), // Templated
		 .ch1_que_l2req_valids	(ch1_que_l2req_valids[7:0]), // Templated
		 .ch1_que_b0_addr_picked(ch1_que_b0_addr_picked[35:0]), // Templated
		 .ch1_que_b0_id_picked	(ch1_que_b0_id_picked[2:0]), // Templated
		 .ch1_que_b0_index_picked(ch1_que_b0_index_picked[2:0]), // Templated
		 .ch1_que_b0_cmd_picked	(ch1_que_b0_cmd_picked), // Templated
		 .ch1_que_int_wr_que_inv_info(ch1_que_int_wr_que_inv_info[6:0]), // Templated
		 .other_que_pos		(ch1_que_pos[4:0]),	 // Templated
		 .ch0_dram_data_val_other_ch(ch1_dram_data_val_other_ch), // Templated
		 .ch0_dram_sctag_chunk_id(dram_sctag1_chunk_id_r0[1:0]), // Templated
		 .ch0_dram_sctag_rd_req_id(dram_sctag1_rd_req_id_r0[2:0]), // Templated
		 .ch0_dram_sctag_data	(dram_scbuf1_data_r2[127:0]), // Templated
		 .ch0_dram_sctag_ecc	(dram_scbuf1_ecc_r2[27:0]), // Templated
		 .ch0_dram_sctag_mecc_err(dram_sctag1_mecc_err_r2), // Templated
		 .ch0_dram_sctag_pa_err	(dram_sctag1_pa_err_r2), // Templated
		 .ch0_dram_sctag_secc_err(dram_sctag1_secc_err_r2), // Templated
		 .ch0_dp_data_valid_d1	(ch1_dp_data_valid_d1),	 // Templated
		 .ch0_err_syn		(ch1_err_syn[15:0]),	 // Templated
		 .ch0_err_loc		(ch1_err_loc[35:0]),	 // Templated
		 .ch1_que_mem_data	(ch1_que_mem_data[255:0]), // Templated
		 .ch1_dp_data_mecc0	(ch1_dp_data_mecc0[3:0]), // Templated
		 .ch1_dp_data_mecc1	(ch1_dp_data_mecc1[3:0]), // Templated
		 .ch1_dp_data_mecc2	(ch1_dp_data_mecc2[3:0]), // Templated
		 .ch1_dp_data_mecc3	(ch1_dp_data_mecc3[3:0]), // Templated
		 .ch1_dp_data_mecc4	(ch1_dp_data_mecc4[3:0]), // Templated
		 .ch1_dp_data_mecc5	(ch1_dp_data_mecc5[3:0]), // Templated
		 .ch1_dp_data_mecc6	(ch1_dp_data_mecc6[3:0]), // Templated
		 .ch1_dp_data_mecc7	(ch1_dp_data_mecc7[3:0]), // Templated
		 .other_channel_disabled(l2if1_channel_disabled), // Templated
		 .other_que_channel_disabled(que1_channel_disabled), // Templated
		 .sehold		(sehold),		 // Templated
		 .mem_bypass		(mem_bypass),		 // Templated
		 .ch0_que_cas_int_picked(ch1_que_cas_int_picked[7:0]), // Templated
		 .ch0_que_wr_cas_ch01_picked(ch1_que_wr_cas_ch01_picked), // Templated
		 .ch0_que_mux_write_en	(ch1_que_mux_write_en));	 // Templated
/*****************************************************************
* Channel 2 or 3 in four Channel mode
****************************************************************/

dramctl	dramctl1(/*AUTOINST*/
		 // Outputs
		 .l2if_ucb_trig		(l2if_ucb_trig1),	 // Templated
		 .dram_sctag_chunk_id	(dram_sctag1_chunk_id_r0[1:0]), // Templated
		 .dram_sctag_data_vld	(dram_sctag1_data_vld_r0), // Templated
		 .dram_sctag_rd_req_id	(dram_sctag1_rd_req_id_r0[2:0]), // Templated
		 .dram_sctag_data	(dram_scbuf1_data_r2[127:0]), // Templated
		 .dram_sctag_mecc_err	(dram_sctag1_mecc_err_r2), // Templated
		 .dram_sctag_pa_err	(dram_sctag1_pa_err_r2), // Templated
		 .dram_sctag_secc_err	(dram_sctag1_secc_err_r2), // Templated
		 .dram_sctag_ecc	(dram_scbuf1_ecc_r2[27:0]), // Templated
		 .dram_sctag_rd_ack	(dram_sctag1_rd_ack),	 // Templated
		 .dram_sctag_wr_ack	(dram_sctag1_wr_ack),	 // Templated
		 .dram_io_data_out	(dram_io_data1_out[287:0]), // Templated
		 .dram_io_addr		(dram_io_addr1[14:0]),	 // Templated
		 .dram_io_bank		(dram_io_bank1[2:0]),	 // Templated
		 .dram_io_cas_l		(dram_io_cas1_l),	 // Templated
		 .dram_io_cke		(dram_io_cke1),		 // Templated
		 .dram_io_cs_l		(dram_io_cs1_l[3:0]),	 // Templated
		 .dram_io_drive_data	(dram_io_drive_data1),	 // Templated
		 .dram_io_drive_enable	(dram_io_drive_enable1), // Templated
		 .dram_io_ras_l		(dram_io_ras1_l),	 // Templated
		 .dram_io_write_en_l	(dram_io_write_en1_l),	 // Templated
		 .dram_io_pad_enable	(dram_io_pad_enable1),	 // Templated
		 .dram_io_clk_enable	(dram_io_clk_enable1),	 // Templated
		 .dram_io_ptr_clk_inv	(dram_io_ptr_clk_inv1),	 // Templated
		 .dram_io_pad_clk_inv	(dram_io_pad_clk_inv1),	 // Templated
		 .dram_io_channel_disabled(dram_io_channel_disabled1), // Templated
		 .dram_ucb_ack_vld	(dram_ucb_ack_vld1),	 // Templated
		 .dram_ucb_nack_vld	(dram_ucb_nack_vld1),	 // Templated
		 .dram_ucb_data		(dram_ucb_data1[63:0]),	 // Templated
		 .l2if_err_intr		(l2if_err_intr1),	 // Templated
		 .dram_local_pt_opened_bank(dram_local_pt1_opened_bank), // Templated
		 .que_max_banks_open_valid(que_max_banks_open_valid1), // Templated
		 .que_max_banks_open	(que_max_banks_open1[16:0]), // Templated
		 .que_max_time_valid	(que_max_time_valid1),	 // Templated
		 .dram_sctag_scb_mecc_err(dram_sctag1_scb_mecc_err), // Templated
		 .dram_sctag_scb_secc_err(dram_sctag1_scb_secc_err), // Templated
		 .que_int_pos		(ch1_que_pos[4:0]),	 // Templated
		 .que_int_wr_que_inv_info(ch1_que_int_wr_que_inv_info[6:0]), // Templated
		 .que_ras_int_picked	(ch1_que_ras_int_picked[7:0]), // Templated
		 .que_b0_data_addr	(ch1_que_b0_data_addr[5:0]), // Templated
		 .que_l2req_valids	(ch1_que_l2req_valids[7:0]), // Templated
		 .que_b0_addr_picked	(ch1_que_b0_addr_picked[35:0]), // Templated
		 .que_b0_id_picked	(ch1_que_b0_id_picked[2:0]), // Templated
		 .que_b0_index_picked	(ch1_que_b0_index_picked[2:0]), // Templated
		 .que_b0_cmd_picked	(ch1_que_b0_cmd_picked), // Templated
		 .que_channel_picked	(ch1_que_channel_picked), // Templated
		 .dp_data_valid_d1	(ch1_dp_data_valid_d1),	 // Templated
		 .dram_data_val_other_ch(ch1_dram_data_val_other_ch), // Templated
		 .que_mem_data		(ch1_que_mem_data[255:0]), // Templated
		 .dp_data_mecc0		(ch1_dp_data_mecc0[3:0]), // Templated
		 .dp_data_mecc1		(ch1_dp_data_mecc1[3:0]), // Templated
		 .dp_data_mecc2		(ch1_dp_data_mecc2[3:0]), // Templated
		 .dp_data_mecc3		(ch1_dp_data_mecc3[3:0]), // Templated
		 .dp_data_mecc4		(ch1_dp_data_mecc4[3:0]), // Templated
		 .dp_data_mecc5		(ch1_dp_data_mecc5[3:0]), // Templated
		 .dp_data_mecc6		(ch1_dp_data_mecc6[3:0]), // Templated
		 .dp_data_mecc7		(ch1_dp_data_mecc7[3:0]), // Templated
		 .err_syn		(ch1_err_syn[15:0]),	 // Templated
		 .err_loc		(ch1_err_loc[35:0]),	 // Templated
		 .que_channel_disabled	(que1_channel_disabled), // Templated
		 .l2if_channel_disabled	(l2if1_channel_disabled), // Templated
		 .listen_out		(listen_out1[64:0]),	 // Templated
		 .que_cas_int_picked	(ch1_que_cas_int_picked[7:0]), // Templated
		 .que_wr_cas_ch01_picked(ch1_que_wr_cas_ch01_picked), // Templated
		 .que_mux_write_en	(ch1_que_mux_write_en),	 // Templated
		 // Inputs
		 .ucb_l2if_selfrsh	(ucb_l2if_selfrsh),
		 .dram_dbginit_l	(dbginit_l),		 // Templated
		 .sctag_dram_rd_req	(sctag1_dram_rd_req),	 // Templated
		 .sctag_dram_rd_dummy_req(sctag1_dram_rd_dummy_req), // Templated
		 .sctag_dram_data_vld	(scbuf1_dram_data_vld_r5), // Templated
		 .sctag_dram_rd_req_id	(sctag1_dram_rd_req_id[2:0]), // Templated
		 .sctag_dram_addr	(sctag1_dram_addr[39:5]), // Templated
		 .sctag_dram_wr_req	(sctag1_dram_wr_req),	 // Templated
		 .sctag_dram_wr_data	(scbuf1_dram_wr_data_r5[63:0]), // Templated
		 .sctag_dram_data_mecc	(scbuf1_dram_data_mecc_r5), // Templated
		 .cmp_clk		(cmp_rclk),		 // Templated
		 .dram_clk		(dram_rclk),		 // Templated
		 .cmp_rst_l		(cmp_rst_l),		 // Templated
		 .dram_rst_l		(dram_rst_l),		 // Templated
		 .dram_arst_l		(dram_arst_l),		 // Templated
		 .io_dram_data_valid	(io_dram1_data_valid),	 // Templated
		 .io_dram_data_in	(io_dram1_data_in[255:0]), // Templated
		 .io_dram_ecc_in	(io_dram1_ecc_in[31:0]), // Templated
		 .ucb_dram_rd_req_vld	(ucb_dram_rd_req_vld1),	 // Templated
		 .ucb_dram_wr_req_vld	(ucb_dram_wr_req_vld1),	 // Templated
		 .ucb_dram_addr		(ucb_dram_addr[31:0]),	 // Templated
		 .ucb_dram_data		(ucb_dram_data[63:0]),	 // Templated
		 .pt_ch_blk_new_openbank(pt_ch1_blk_new_openbank), // Templated
		 .pt_max_banks_open	(pt_max_banks_open[16:0]), // Templated
		 .pt_max_time		(pt_max_time[15:0]),	 // Templated
		 .dram_dram_rx_sync	(dram_dram_rx_sync),	 // Templated
		 .dram_dram_tx_sync	(dram_dram_tx_sync),	 // Templated
		 .dram_jbus_rx_sync	(dram_jbus_rx_sync),	 // Templated
		 .dram_jbus_tx_sync	(dram_jbus_tx_sync),	 // Templated
		 .ch0_que_ras_int_picked(ch0_que_ras_int_picked[7:0]), // Templated
		 .ch0_que_b0_data_addr	(ch0_que_b0_data_addr[5:0]), // Templated
		 .ch0_que_channel_picked(ch0_que_channel_picked), // Templated
		 .ch1_que_l2req_valids	(ch0_que_l2req_valids[7:0]), // Templated
		 .ch1_que_b0_addr_picked(ch0_que_b0_addr_picked[35:0]), // Templated
		 .ch1_que_b0_id_picked	(ch0_que_b0_id_picked[2:0]), // Templated
		 .ch1_que_b0_index_picked(ch0_que_b0_index_picked[2:0]), // Templated
		 .ch1_que_b0_cmd_picked	(ch0_que_b0_cmd_picked), // Templated
		 .ch1_que_int_wr_que_inv_info(ch0_que_int_wr_que_inv_info[6:0]), // Templated
		 .other_que_pos		(ch0_que_pos[4:0]),	 // Templated
		 .ch0_dram_data_val_other_ch(ch0_dram_data_val_other_ch), // Templated
		 .ch0_dram_sctag_chunk_id(dram_sctag0_chunk_id_r0[1:0]), // Templated
		 .ch0_dram_sctag_rd_req_id(dram_sctag0_rd_req_id_r0[2:0]), // Templated
		 .ch0_dram_sctag_data	(dram_scbuf0_data_r2[127:0]), // Templated
		 .ch0_dram_sctag_ecc	(dram_scbuf0_ecc_r2[27:0]), // Templated
		 .ch0_dram_sctag_mecc_err(dram_sctag0_mecc_err_r2), // Templated
		 .ch0_dram_sctag_pa_err	(dram_sctag0_pa_err_r2), // Templated
		 .ch0_dram_sctag_secc_err(dram_sctag0_secc_err_r2), // Templated
		 .ch0_dp_data_valid_d1	(ch0_dp_data_valid_d1),	 // Templated
		 .ch0_err_syn		(ch0_err_syn[15:0]),	 // Templated
		 .ch0_err_loc		(ch0_err_loc[35:0]),	 // Templated
		 .ch1_que_mem_data	(ch0_que_mem_data[255:0]), // Templated
		 .ch1_dp_data_mecc0	(ch0_dp_data_mecc0[3:0]), // Templated
		 .ch1_dp_data_mecc1	(ch0_dp_data_mecc1[3:0]), // Templated
		 .ch1_dp_data_mecc2	(ch0_dp_data_mecc2[3:0]), // Templated
		 .ch1_dp_data_mecc3	(ch0_dp_data_mecc3[3:0]), // Templated
		 .ch1_dp_data_mecc4	(ch0_dp_data_mecc4[3:0]), // Templated
		 .ch1_dp_data_mecc5	(ch0_dp_data_mecc5[3:0]), // Templated
		 .ch1_dp_data_mecc6	(ch0_dp_data_mecc6[3:0]), // Templated
		 .ch1_dp_data_mecc7	(ch0_dp_data_mecc7[3:0]), // Templated
		 .other_channel_disabled(l2if0_channel_disabled), // Templated
		 .other_que_channel_disabled(que0_channel_disabled), // Templated
		 .sehold		(sehold),		 // Templated
		 .mem_bypass		(mem_bypass),		 // Templated
		 .ch0_que_cas_int_picked(ch0_que_cas_int_picked[7:0]), // Templated
		 .ch0_que_wr_cas_ch01_picked(ch0_que_wr_cas_ch01_picked), // Templated
		 .ch0_que_mux_write_en	(ch0_que_mux_write_en));	 // Templated
/*****************************************************************
* Power throttle logic block 
****************************************************************/

/*dram_pt       AUTO_TEMPLATE( .clk(dram_rclk),
                                .rst_l(dram_rst_l)); */

dram_pt dram_pt(/*AUTOINST*/
		// Outputs
		.pt_ch0_blk_new_openbank(pt_ch0_blk_new_openbank),
		.pt_ch1_blk_new_openbank(pt_ch1_blk_new_openbank),
		.pt_max_banks_open	(pt_max_banks_open[16:0]),
		.pt_max_time		(pt_max_time[15:0]),
		.dram_pt_max_banks_open_valid(dram_pt_max_banks_open_valid),
		.dram_pt_max_time_valid	(dram_pt_max_time_valid),
		.dram_pt_ucb_data	(dram_pt_ucb_data[16:0]),
		// Inputs
		.clk			(dram_rclk),		 // Templated
		.rst_l			(dram_rst_l),		 // Templated
		.arst_l			(dram_arst_l),		 // Templated
		.dram_local_pt0_opened_bank(dram_local_pt0_opened_bank),
		.dram_local_pt1_opened_bank(dram_local_pt1_opened_bank),
		.dram_other_pt0_opened_bank(dram_other_pt0_opened_bank),
		.dram_other_pt1_opened_bank(dram_other_pt1_opened_bank),
		.que_max_banks_open_valid0(que_max_banks_open_valid0),
		.que_max_banks_open_valid1(que_max_banks_open_valid1),
		.que_max_banks_open0	(que_max_banks_open0[16:0]),
		.que_max_banks_open1	(que_max_banks_open1[16:0]),
		.que_max_time_valid0	(que_max_time_valid0),
		.que_max_time_valid1	(que_max_time_valid1),
		.dram_other_pt_max_banks_open_valid(dram_other_pt_max_banks_open_valid),
		.dram_other_pt_max_time_valid(dram_other_pt_max_time_valid),
		.dram_other_pt_ucb_data	(dram_other_pt_ucb_data[16:0])); 

/*****************************************************************
* UCB logic block for I/O Reads and Writes
****************************************************************/

/*dram_ucb       AUTO_TEMPLATE( .clk(jbus_rclk),
		  		.ddr_clk_tr(dram_clk_tr),
                                .rst_l(jbus_rst_l)); */

dram_ucb dram_ucb(/*AUTOINST*/
		  // Outputs
		  .ucb_dram_rd_req_vld0	(ucb_dram_rd_req_vld0),
		  .ucb_dram_rd_req_vld1	(ucb_dram_rd_req_vld1),
		  .ucb_dram_wr_req_vld0	(ucb_dram_wr_req_vld0),
		  .ucb_dram_wr_req_vld1	(ucb_dram_wr_req_vld1),
		  .ucb_dram_addr	(ucb_dram_addr[31:0]),
		  .ucb_dram_data	(ucb_dram_data[63:0]),
		  .ucb_iob_data		(ucb_iob_data[3:0]),
		  .ucb_iob_stall	(ucb_iob_stall),
		  .ucb_iob_vld		(ucb_iob_vld),
		  .ddr_clk_tr		(dram_clk_tr),		 // Templated
		  .ucb_l2if_selfrsh	(ucb_l2if_selfrsh),
		  // Inputs
		  .clk			(jbus_rclk),		 // Templated
		  .rst_l		(jbus_rst_l),		 // Templated
		  .clspine_dram_selfrsh	(clspine_dram_selfrsh),
		  .iob_ucb_data		(iob_ucb_data[3:0]),
		  .iob_ucb_stall	(iob_ucb_stall),
		  .iob_ucb_vld		(iob_ucb_vld),
		  .dram_ucb_ack_vld0	(dram_ucb_ack_vld0),
		  .dram_ucb_ack_vld1	(dram_ucb_ack_vld1),
		  .dram_ucb_nack_vld0	(dram_ucb_nack_vld0),
		  .dram_ucb_nack_vld1	(dram_ucb_nack_vld1),
		  .dram_ucb_data0	(dram_ucb_data0[63:0]),
		  .dram_ucb_data1	(dram_ucb_data1[63:0]),
		  .l2if_err_intr0	(l2if_err_intr0),
		  .l2if_err_intr1	(l2if_err_intr1),
		  .l2if_ucb_trig0	(l2if_ucb_trig0),
		  .l2if_ucb_trig1	(l2if_ucb_trig1));

endmodule // dram 

// Local Variables:
// verilog-library-directories:("." "../../common/rtl")
// End:

