// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dramctl.v
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

module dramctl (/*AUTOARG*/
   // Outputs
   l2if_ucb_trig, dram_sctag_chunk_id, dram_sctag_data_vld, 
   dram_sctag_rd_req_id, dram_sctag_data, dram_sctag_mecc_err, 
   dram_sctag_pa_err, dram_sctag_secc_err, dram_sctag_ecc, 
   dram_sctag_rd_ack, dram_sctag_wr_ack, dram_io_data_out, 
   dram_io_addr, dram_io_bank, dram_io_cas_l, dram_io_cke, 
   dram_io_cs_l, dram_io_drive_data, dram_io_drive_enable, 
   dram_io_ras_l, dram_io_write_en_l, dram_io_pad_enable, 
   dram_io_clk_enable, dram_io_ptr_clk_inv, dram_io_pad_clk_inv, 
   dram_io_channel_disabled, dram_ucb_ack_vld, dram_ucb_nack_vld, 
   dram_ucb_data, l2if_err_intr, dram_local_pt_opened_bank, 
   que_max_banks_open_valid, que_max_banks_open, que_max_time_valid, 
   dram_sctag_scb_mecc_err, 
   dram_sctag_scb_secc_err, que_int_pos, que_int_wr_que_inv_info, 
   que_ras_int_picked, que_b0_data_addr, que_l2req_valids, 
   que_b0_addr_picked, que_b0_id_picked, que_b0_index_picked, 
   que_b0_cmd_picked, que_channel_picked, dp_data_valid_d1, 
   dram_data_val_other_ch, que_mem_data, dp_data_mecc0, 
   dp_data_mecc1, dp_data_mecc2, dp_data_mecc3, dp_data_mecc4, 
   dp_data_mecc5, dp_data_mecc6, dp_data_mecc7, err_syn, err_loc, 
   que_channel_disabled, l2if_channel_disabled, listen_out, 
   que_cas_int_picked, que_wr_cas_ch01_picked, que_mux_write_en, 
   // Inputs
   ucb_l2if_selfrsh, dram_dbginit_l, sctag_dram_rd_req, 
   sctag_dram_rd_dummy_req, sctag_dram_data_vld, 
   sctag_dram_rd_req_id, sctag_dram_addr, sctag_dram_wr_req, 
   sctag_dram_wr_data, sctag_dram_data_mecc, cmp_clk, dram_clk, 
   cmp_rst_l, dram_rst_l, dram_arst_l, io_dram_data_valid, io_dram_data_in, 
   io_dram_ecc_in, ucb_dram_rd_req_vld, ucb_dram_wr_req_vld, 
   ucb_dram_addr, ucb_dram_data, pt_ch_blk_new_openbank, 
   pt_max_banks_open, pt_max_time, dram_dram_rx_sync, 
   dram_dram_tx_sync, dram_jbus_rx_sync, dram_jbus_tx_sync, 
   ch0_que_ras_int_picked, ch0_que_b0_data_addr, 
   ch0_que_channel_picked, ch1_que_l2req_valids, 
   ch1_que_b0_addr_picked, ch1_que_b0_id_picked, 
   ch1_que_b0_index_picked, ch1_que_b0_cmd_picked, 
   ch1_que_int_wr_que_inv_info, other_que_pos, 
   ch0_dram_data_val_other_ch, ch0_dram_sctag_chunk_id, 
   ch0_dram_sctag_rd_req_id, ch0_dram_sctag_data, ch0_dram_sctag_ecc, 
   ch0_dram_sctag_mecc_err, ch0_dram_sctag_pa_err, 
   ch0_dram_sctag_secc_err, ch0_dp_data_valid_d1, ch0_err_syn, 
   ch0_err_loc, ch1_que_mem_data, ch1_dp_data_mecc0, 
   ch1_dp_data_mecc1, ch1_dp_data_mecc2, ch1_dp_data_mecc3, 
   ch1_dp_data_mecc4, ch1_dp_data_mecc5, ch1_dp_data_mecc6, 
   ch1_dp_data_mecc7, other_channel_disabled, 
   other_que_channel_disabled, sehold, mem_bypass, 
   ch0_que_cas_int_picked, ch0_que_wr_cas_ch01_picked, 
   ch0_que_mux_write_en
   );

// DRAM controller  interface
input			ucb_l2if_selfrsh;
input			dram_dbginit_l;
output			l2if_ucb_trig;

// rd interface
input 			sctag_dram_rd_req;
input 			sctag_dram_rd_dummy_req;
input			sctag_dram_data_vld;
input [2:0]  		sctag_dram_rd_req_id;
input [39:5] 		sctag_dram_addr;
// wr interface
input  			sctag_dram_wr_req;
input [63:0] 		sctag_dram_wr_data;
input			sctag_dram_data_mecc;

// rd interface
output [1:0] 		dram_sctag_chunk_id;
output 	 		dram_sctag_data_vld;
output [2:0] 		dram_sctag_rd_req_id;
output [127:0]  	dram_sctag_data;
output			dram_sctag_mecc_err;
output			dram_sctag_pa_err;
output			dram_sctag_secc_err;
output [27:0]  		dram_sctag_ecc;
output 	 		dram_sctag_rd_ack;

// wr interface
output 	 		dram_sctag_wr_ack;

input 	 		cmp_clk;
input 	 		dram_clk;
input 	 		cmp_rst_l;
input 	 		dram_rst_l;
input 	 		dram_arst_l;
  
// FROM THE PADS
input			io_dram_data_valid;
input [255:0]		io_dram_data_in;	
input [31:0]		io_dram_ecc_in;		

// TO THE PADS
output [287:0]		dram_io_data_out;	
output [14:0]		dram_io_addr;	
output [2:0]		dram_io_bank;		
output			dram_io_cas_l;	
output 			dram_io_cke;		
output [3:0]		dram_io_cs_l;		
output			dram_io_drive_data;
output			dram_io_drive_enable;	
output			dram_io_ras_l;		
output			dram_io_write_en_l;
output          	dram_io_pad_enable;
output          	dram_io_clk_enable;
output [4:0]         	dram_io_ptr_clk_inv;
output          	dram_io_pad_clk_inv;
output          	dram_io_channel_disabled;

// FROM UCB
input                  	ucb_dram_rd_req_vld;
input                  	ucb_dram_wr_req_vld;
input [31:0]           	ucb_dram_addr;
input [63:0]           	ucb_dram_data;

// TO UCB
output                  dram_ucb_ack_vld;
output                  dram_ucb_nack_vld;
output [63:0]           dram_ucb_data;
output			l2if_err_intr;

// FROM POWER THROTTLE
output          	dram_local_pt_opened_bank;
output          	que_max_banks_open_valid;
output [16:0]    	que_max_banks_open;
output          	que_max_time_valid;

input          		pt_ch_blk_new_openbank;
input [16:0]     	pt_max_banks_open;
input [15:0]     	pt_max_time;

// Async scrub error signals
output          	dram_sctag_scb_mecc_err;
output          	dram_sctag_scb_secc_err;

// SYNC Pulse
input                   dram_dram_rx_sync;
input                   dram_dram_tx_sync;
input                   dram_jbus_rx_sync;
input                   dram_jbus_tx_sync;

// NEW ADDITION DUE TO 2 CHANNEL MODE
input [7:0]     	ch0_que_ras_int_picked;
input [5:0]     	ch0_que_b0_data_addr;
input           	ch0_que_channel_picked;
input [7:0]     	ch1_que_l2req_valids;
input [35:0]    	ch1_que_b0_addr_picked;
input [2:0]     	ch1_que_b0_id_picked;
input [2:0]     	ch1_que_b0_index_picked;
input           	ch1_que_b0_cmd_picked;
input [6:0]             ch1_que_int_wr_que_inv_info;
input [4:0]     	other_que_pos;
                                                   
output [4:0]     	que_int_pos;
output [6:0]            que_int_wr_que_inv_info;
output [7:0]    	que_ras_int_picked;
output [5:0]    	que_b0_data_addr;
output [7:0]    	que_l2req_valids;
output [35:0]   	que_b0_addr_picked;
output [2:0]    	que_b0_id_picked;
output [2:0]    	que_b0_index_picked;
output          	que_b0_cmd_picked;
output          	que_channel_picked;
output			dp_data_valid_d1;

// NEW ADDITION DUE TO 2 CHANNEL MODE
output          	dram_data_val_other_ch;

input           	ch0_dram_data_val_other_ch;
input [1:0]     	ch0_dram_sctag_chunk_id;
input [2:0]     	ch0_dram_sctag_rd_req_id;
input [127:0]   	ch0_dram_sctag_data;
input [27:0]    	ch0_dram_sctag_ecc;
input           	ch0_dram_sctag_mecc_err;
input           	ch0_dram_sctag_pa_err;
input           	ch0_dram_sctag_secc_err;
input			ch0_dp_data_valid_d1;
input [15:0]    	ch0_err_syn;
input [35:0]    	ch0_err_loc;

input [255:0]   	ch1_que_mem_data;
output [255:0]  	que_mem_data;

input [3:0]     	ch1_dp_data_mecc0;
input [3:0]     	ch1_dp_data_mecc1;
input [3:0]     	ch1_dp_data_mecc2;
input [3:0]     	ch1_dp_data_mecc3;
input [3:0]     	ch1_dp_data_mecc4;
input [3:0]     	ch1_dp_data_mecc5;
input [3:0]     	ch1_dp_data_mecc6;
input [3:0]     	ch1_dp_data_mecc7;

output [3:0]    	dp_data_mecc0;
output [3:0]    	dp_data_mecc1;
output [3:0]    	dp_data_mecc2;
output [3:0]    	dp_data_mecc3;
output [3:0]    	dp_data_mecc4;
output [3:0]    	dp_data_mecc5;
output [3:0]    	dp_data_mecc6;
output [3:0]    	dp_data_mecc7;
output [15:0]    	err_syn;
output [35:0]    	err_loc;

input         		other_channel_disabled;
input			other_que_channel_disabled;
output			que_channel_disabled;
output         		l2if_channel_disabled;

// MEM RELATED
output [64:0]		listen_out;		
input			sehold;
input			mem_bypass;

// FOR PERF
input [7:0]             ch0_que_cas_int_picked;
input                   ch0_que_wr_cas_ch01_picked;
input                   ch0_que_mux_write_en;
output [7:0]            que_cas_int_picked;
output                  que_wr_cas_ch01_picked;
output                  que_mux_write_en;

//////////////////////////////////////////////////////////////////
// Wires
//////////////////////////////////////////////////////////////////
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [8:0]		config_reg;		// From dram_dctl of dram_dctl.v
wire [255:0]		dp_data_in;		// From dram_dctl of dram_dctl.v
wire			dp_data_valid;		// From dram_dctl of dram_dctl.v
wire [31:0]		dp_ecc_in;		// From dram_dctl of dram_dctl.v
wire [3:0]		dram_cpu_wr_addr;	// From dram_l2if of dram_l2if.v
wire [63:0]		dram_cpu_wr_data;	// From dram_l2if of dram_l2if.v
wire [3:0]		dram_cpu_wr_en;		// From dram_l2if of dram_l2if.v
wire			dram_fail_over_mode;	// From dram_dctl of dram_dctl.v
wire [3:0]		l2if_data_mecc0;	// From dram_l2if of dram_l2if.v
wire [3:0]		l2if_data_mecc1;	// From dram_l2if of dram_l2if.v
wire [3:0]		l2if_data_mecc2;	// From dram_l2if of dram_l2if.v
wire [3:0]		l2if_data_mecc3;	// From dram_l2if of dram_l2if.v
wire [3:0]		l2if_data_mecc4;	// From dram_l2if of dram_l2if.v
wire [3:0]		l2if_data_mecc5;	// From dram_l2if of dram_l2if.v
wire [3:0]		l2if_data_mecc6;	// From dram_l2if of dram_l2if.v
wire [3:0]		l2if_data_mecc7;	// From dram_l2if of dram_l2if.v
wire [2:0]		l2if_data_wr_addr;	// From dram_l2if of dram_l2if.v
wire			l2if_dbg_trig_en;	// From dram_l2if of dram_l2if.v
wire [35:0]		l2if_err_addr_reg;	// From dram_l2if of dram_l2if.v
wire [17:0]		l2if_err_cnt;		// From dram_l2if of dram_l2if.v
wire [35:0]		l2if_err_loc;		// From dram_l2if of dram_l2if.v
wire [22:0]		l2if_err_sts_reg;	// From dram_l2if of dram_l2if.v
wire [31:0]		l2if_que_addr;		// From dram_l2if of dram_l2if.v
wire [63:0]		l2if_que_data;		// From dram_l2if of dram_l2if.v
wire			l2if_que_rd_req_vld;	// From dram_l2if of dram_l2if.v
wire			l2if_que_wr_req_vld;	// From dram_l2if of dram_l2if.v
wire [35:0]		l2if_rd_addr;		// From dram_l2if of dram_l2if.v
wire [2:0]		l2if_rd_id;		// From dram_l2if of dram_l2if.v
wire			l2if_rd_req;		// From dram_l2if of dram_l2if.v
wire [255:0]		l2if_scrb_data;		// From dram_l2if of dram_l2if.v
wire			l2if_scrb_data_en;	// From dram_l2if of dram_l2if.v
wire [33:0]		l2if_scrb_ecc;		// From dram_l2if of dram_l2if.v
wire [35:0]		l2if_wr_addr;		// From dram_l2if of dram_l2if.v
wire			l2if_wr_req;		// From dram_l2if of dram_l2if.v
wire			que_addr_bank_low_sel;	// From dram_dctl of dram_dctl.v
wire			que_dram_clk_toggle;	// From dram_dctl of dram_dctl.v
wire			que_eight_bank_mode;	// From dram_dctl of dram_dctl.v
wire			que_l2if_ack_vld;	// From dram_dctl of dram_dctl.v
wire [63:0]		que_l2if_data;		// From dram_dctl of dram_dctl.v
wire			que_l2if_nack_vld;	// From dram_dctl of dram_dctl.v
wire [9:0]		que_l2if_send_info;	// From dram_dctl of dram_dctl.v
wire [4:0]		que_margin_reg;		// From dram_dctl of dram_dctl.v
wire [4:0]		que_mem_addr;		// From dram_dctl of dram_dctl.v
wire			que_rank1_present;	// From dram_dctl of dram_dctl.v
wire [32:0]		que_scrb_addr;		// From dram_dctl of dram_dctl.v
wire [3:0]		que_wr_entry_free;	// From dram_dctl of dram_dctl.v
wire			que_wr_req;		// From dram_dctl of dram_dctl.v
wire			readqbank0vld0;		// From dram_dctl of dram_dctl.v
wire			readqbank0vld1;		// From dram_dctl of dram_dctl.v
wire			readqbank0vld2;		// From dram_dctl of dram_dctl.v
wire			readqbank0vld3;		// From dram_dctl of dram_dctl.v
wire			readqbank0vld4;		// From dram_dctl of dram_dctl.v
wire			readqbank0vld5;		// From dram_dctl of dram_dctl.v
wire			readqbank0vld6;		// From dram_dctl of dram_dctl.v
wire			readqbank0vld7;		// From dram_dctl of dram_dctl.v
wire			writeqbank0vld0;	// From dram_dctl of dram_dctl.v
wire			writeqbank0vld1;	// From dram_dctl of dram_dctl.v
wire			writeqbank0vld2;	// From dram_dctl of dram_dctl.v
wire			writeqbank0vld3;	// From dram_dctl of dram_dctl.v
wire			writeqbank0vld4;	// From dram_dctl of dram_dctl.v
wire			writeqbank0vld5;	// From dram_dctl of dram_dctl.v
wire			writeqbank0vld6;	// From dram_dctl of dram_dctl.v
wire			writeqbank0vld7;	// From dram_dctl of dram_dctl.v
// End of automatics

/*dram_l2if 	AUTO_TEMPLATE( .clk(cmp_clk),
				.arst_l(dram_arst_l),
				.rst_l(cmp_rst_l)); */

dram_l2if dram_l2if(/*AUTOINST*/
		    // Outputs
		    .dram_ucb_ack_vld	(dram_ucb_ack_vld),
		    .dram_ucb_nack_vld	(dram_ucb_nack_vld),
		    .dram_ucb_data	(dram_ucb_data[63:0]),
		    .l2if_que_rd_req_vld(l2if_que_rd_req_vld),
		    .l2if_que_wr_req_vld(l2if_que_wr_req_vld),
		    .l2if_que_addr	(l2if_que_addr[31:0]),
		    .l2if_que_data	(l2if_que_data[63:0]),
		    .dram_sctag_chunk_id(dram_sctag_chunk_id[1:0]),
		    .dram_sctag_data_vld(dram_sctag_data_vld),
		    .dram_sctag_rd_req_id(dram_sctag_rd_req_id[2:0]),
		    .dram_sctag_data	(dram_sctag_data[127:0]),
		    .dram_sctag_mecc_err(dram_sctag_mecc_err),
		    .dram_sctag_pa_err	(dram_sctag_pa_err),
		    .dram_sctag_secc_err(dram_sctag_secc_err),
		    .dram_sctag_ecc	(dram_sctag_ecc[27:0]),
		    .dram_sctag_rd_ack	(dram_sctag_rd_ack),
		    .dram_sctag_wr_ack	(dram_sctag_wr_ack),
		    .l2if_data_mecc0	(l2if_data_mecc0[3:0]),
		    .l2if_data_mecc1	(l2if_data_mecc1[3:0]),
		    .l2if_data_mecc2	(l2if_data_mecc2[3:0]),
		    .l2if_data_mecc3	(l2if_data_mecc3[3:0]),
		    .l2if_data_mecc4	(l2if_data_mecc4[3:0]),
		    .l2if_data_mecc5	(l2if_data_mecc5[3:0]),
		    .l2if_data_mecc6	(l2if_data_mecc6[3:0]),
		    .l2if_data_mecc7	(l2if_data_mecc7[3:0]),
		    .l2if_data_wr_addr	(l2if_data_wr_addr[2:0]),
		    .dram_cpu_wr_addr	(dram_cpu_wr_addr[3:0]),
		    .dram_cpu_wr_en	(dram_cpu_wr_en[3:0]),
		    .dram_cpu_wr_data	(dram_cpu_wr_data[63:0]),
		    .l2if_wr_req	(l2if_wr_req),
		    .l2if_rd_req	(l2if_rd_req),
		    .l2if_rd_addr	(l2if_rd_addr[35:0]),
		    .l2if_wr_addr	(l2if_wr_addr[35:0]),
		    .l2if_rd_id		(l2if_rd_id[2:0]),
		    .l2if_scrb_data_en	(l2if_scrb_data_en),
		    .l2if_scrb_data	(l2if_scrb_data[255:0]),
		    .l2if_scrb_ecc	(l2if_scrb_ecc[33:0]),
		    .l2if_err_loc	(l2if_err_loc[35:0]),
		    .l2if_err_cnt	(l2if_err_cnt[17:0]),
		    .l2if_dbg_trig_en	(l2if_dbg_trig_en),
		    .l2if_err_intr	(l2if_err_intr),
		    .dram_sctag_scb_mecc_err(dram_sctag_scb_mecc_err),
		    .dram_sctag_scb_secc_err(dram_sctag_scb_secc_err),
		    .l2if_err_addr_reg	(l2if_err_addr_reg[35:0]),
		    .l2if_err_sts_reg	(l2if_err_sts_reg[22:0]),
		    .dram_data_val_other_ch(dram_data_val_other_ch),
		    .dp_data_valid_d1	(dp_data_valid_d1),
		    .l2if_channel_disabled(l2if_channel_disabled),
		    .err_loc		(err_loc[35:0]),
		    .err_syn		(err_syn[15:0]),
		    .l2if_ucb_trig	(l2if_ucb_trig),
		    .l2if_que_selfrsh	(l2if_que_selfrsh),
		    // Inputs
		    .clk		(cmp_clk),		 // Templated
		    .rst_l		(cmp_rst_l),		 // Templated
		    .arst_l		(dram_arst_l),		 // Templated
		    .ucb_l2if_selfrsh	(ucb_l2if_selfrsh),
		    .sctag_dram_rd_req	(sctag_dram_rd_req),
		    .sctag_dram_rd_dummy_req(sctag_dram_rd_dummy_req),
		    .sctag_dram_rd_req_id(sctag_dram_rd_req_id[2:0]),
		    .sctag_dram_addr	(sctag_dram_addr[39:5]),
		    .sctag_dram_wr_req	(sctag_dram_wr_req),
		    .sctag_dram_data_vld(sctag_dram_data_vld),
		    .sctag_dram_wr_data	(sctag_dram_wr_data[63:0]),
		    .sctag_dram_data_mecc(sctag_dram_data_mecc),
		    .readqbank0vld0	(readqbank0vld0),
		    .readqbank0vld1	(readqbank0vld1),
		    .readqbank0vld2	(readqbank0vld2),
		    .readqbank0vld3	(readqbank0vld3),
		    .writeqbank0vld0	(writeqbank0vld0),
		    .writeqbank0vld1	(writeqbank0vld1),
		    .writeqbank0vld2	(writeqbank0vld2),
		    .writeqbank0vld3	(writeqbank0vld3),
		    .readqbank0vld4	(readqbank0vld4),
		    .readqbank0vld5	(readqbank0vld5),
		    .readqbank0vld6	(readqbank0vld6),
		    .readqbank0vld7	(readqbank0vld7),
		    .writeqbank0vld4	(writeqbank0vld4),
		    .writeqbank0vld5	(writeqbank0vld5),
		    .writeqbank0vld6	(writeqbank0vld6),
		    .writeqbank0vld7	(writeqbank0vld7),
		    .que_wr_req		(que_wr_req),
		    .que_scrb_addr	(que_scrb_addr[32:0]),
		    .dram_fail_over_mode(dram_fail_over_mode),
		    .que_wr_entry_free	(que_wr_entry_free[3:0]),
		    .config_reg		(config_reg[8:0]),
		    .que_rank1_present	(que_rank1_present),
		    .ucb_dram_rd_req_vld(ucb_dram_rd_req_vld),
		    .ucb_dram_wr_req_vld(ucb_dram_wr_req_vld),
		    .ucb_dram_addr	(ucb_dram_addr[31:0]),
		    .ucb_dram_data	(ucb_dram_data[63:0]),
		    .que_eight_bank_mode(que_eight_bank_mode),
		    .que_l2if_ack_vld	(que_l2if_ack_vld),
		    .que_l2if_nack_vld	(que_l2if_nack_vld),
		    .que_l2if_data	(que_l2if_data[63:0]),
		    .que_dram_clk_toggle(que_dram_clk_toggle),
		    .dp_data_valid	(dp_data_valid),
		    .que_l2if_send_info	(que_l2if_send_info[9:0]),
		    .dp_data_in		(dp_data_in[255:0]),
		    .dp_ecc_in		(dp_ecc_in[31:0]),
		    .dram_dram_rx_sync	(dram_dram_rx_sync),
		    .dram_dram_tx_sync	(dram_dram_tx_sync),
		    .dram_jbus_rx_sync	(dram_jbus_rx_sync),
		    .dram_jbus_tx_sync	(dram_jbus_tx_sync),
		    .que_addr_bank_low_sel(que_addr_bank_low_sel),
		    .que_channel_disabled(que_channel_disabled),
		    .other_channel_disabled(other_channel_disabled),
		    .ch0_err_loc	(ch0_err_loc[35:0]),
		    .ch0_err_syn	(ch0_err_syn[15:0]),
		    .ch0_dp_data_valid_d1(ch0_dp_data_valid_d1),
		    .ch0_dram_data_val_other_ch(ch0_dram_data_val_other_ch),
		    .ch0_dram_sctag_chunk_id(ch0_dram_sctag_chunk_id[1:0]),
		    .ch0_dram_sctag_rd_req_id(ch0_dram_sctag_rd_req_id[2:0]),
		    .ch0_dram_sctag_data(ch0_dram_sctag_data[127:0]),
		    .ch0_dram_sctag_ecc	(ch0_dram_sctag_ecc[27:0]),
		    .ch0_dram_sctag_mecc_err(ch0_dram_sctag_mecc_err),
		    .ch0_dram_sctag_pa_err(ch0_dram_sctag_pa_err),
		    .ch0_dram_sctag_secc_err(ch0_dram_sctag_secc_err));

/*dram_dctl	AUTO_TEMPLATE( 	.clk(dram_clk),
			  	.arst_l(dram_arst_l),
			  	.rst_l(dram_rst_l)); */

dram_dctl	dram_dctl(/*AUTOINST*/
			  // Outputs
			  .que_margin_reg(que_margin_reg[4:0]),
			  .readqbank0vld0(readqbank0vld0),
			  .readqbank0vld1(readqbank0vld1),
			  .readqbank0vld2(readqbank0vld2),
			  .readqbank0vld3(readqbank0vld3),
			  .writeqbank0vld0(writeqbank0vld0),
			  .writeqbank0vld1(writeqbank0vld1),
			  .writeqbank0vld2(writeqbank0vld2),
			  .writeqbank0vld3(writeqbank0vld3),
			  .readqbank0vld4(readqbank0vld4),
			  .readqbank0vld5(readqbank0vld5),
			  .readqbank0vld6(readqbank0vld6),
			  .readqbank0vld7(readqbank0vld7),
			  .writeqbank0vld4(writeqbank0vld4),
			  .writeqbank0vld5(writeqbank0vld5),
			  .writeqbank0vld6(writeqbank0vld6),
			  .writeqbank0vld7(writeqbank0vld7),
			  .que_wr_req	(que_wr_req),
			  .dp_data_in	(dp_data_in[255:0]),
			  .dp_ecc_in	(dp_ecc_in[31:0]),
			  .que_scrb_addr(que_scrb_addr[32:0]),
			  .dram_fail_over_mode(dram_fail_over_mode),
			  .que_wr_entry_free(que_wr_entry_free[3:0]),
			  .config_reg	(config_reg[8:0]),
			  .que_rank1_present(que_rank1_present),
			  .que_addr_bank_low_sel(que_addr_bank_low_sel),
			  .que_eight_bank_mode(que_eight_bank_mode),
			  .que_mem_addr	(que_mem_addr[4:0]),
			  .dram_io_data_out(dram_io_data_out[287:0]),
			  .dram_io_addr	(dram_io_addr[14:0]),
			  .dram_io_bank	(dram_io_bank[2:0]),
			  .dram_io_cas_l(dram_io_cas_l),
			  .dram_io_cke	(dram_io_cke),
			  .dram_io_cs_l	(dram_io_cs_l[3:0]),
			  .dram_io_drive_data(dram_io_drive_data),
			  .dram_io_drive_enable(dram_io_drive_enable),
			  .dram_io_ras_l(dram_io_ras_l),
			  .dram_io_write_en_l(dram_io_write_en_l),
			  .dram_io_pad_enable(dram_io_pad_enable),
			  .dram_io_clk_enable(dram_io_clk_enable),
			  .dram_io_pad_clk_inv(dram_io_pad_clk_inv),
			  .dram_io_ptr_clk_inv(dram_io_ptr_clk_inv[4:0]),
			  .dram_io_channel_disabled(dram_io_channel_disabled),
			  .que_l2if_ack_vld(que_l2if_ack_vld),
			  .que_l2if_nack_vld(que_l2if_nack_vld),
			  .que_l2if_data(que_l2if_data[63:0]),
			  .que_dram_clk_toggle(que_dram_clk_toggle),
			  .dp_data_valid(dp_data_valid),
			  .que_l2if_send_info(que_l2if_send_info[9:0]),
			  .dram_local_pt_opened_bank(dram_local_pt_opened_bank),
			  .que_max_banks_open_valid(que_max_banks_open_valid),
			  .que_max_banks_open(que_max_banks_open[16:0]),
			  .que_max_time_valid(que_max_time_valid),
			  .que_int_wr_que_inv_info(que_int_wr_que_inv_info[6:0]),
			  .que_ras_int_picked(que_ras_int_picked[7:0]),
			  .que_b0_data_addr(que_b0_data_addr[5:0]),
			  .que_l2req_valids(que_l2req_valids[7:0]),
			  .que_b0_addr_picked(que_b0_addr_picked[35:0]),
			  .que_b0_id_picked(que_b0_id_picked[2:0]),
			  .que_b0_index_picked(que_b0_index_picked[2:0]),
			  .que_b0_cmd_picked(que_b0_cmd_picked),
			  .que_channel_picked(que_channel_picked),
			  .que_int_pos	(que_int_pos[4:0]),
			  .que_channel_disabled(que_channel_disabled),
			  .dp_data_mecc0(dp_data_mecc0[3:0]),
			  .dp_data_mecc1(dp_data_mecc1[3:0]),
			  .dp_data_mecc2(dp_data_mecc2[3:0]),
			  .dp_data_mecc3(dp_data_mecc3[3:0]),
			  .dp_data_mecc4(dp_data_mecc4[3:0]),
			  .dp_data_mecc5(dp_data_mecc5[3:0]),
			  .dp_data_mecc6(dp_data_mecc6[3:0]),
			  .dp_data_mecc7(dp_data_mecc7[3:0]),
			  .que_cas_int_picked(que_cas_int_picked[7:0]),
			  .que_wr_cas_ch01_picked(que_wr_cas_ch01_picked),
			  .que_mux_write_en(que_mux_write_en),
			  // Inputs
			  .clk		(dram_clk),		 // Templated
			  .rst_l	(dram_rst_l),		 // Templated
			  .arst_l	(dram_arst_l),		 // Templated
			  .sehold	(sehold),
			  .l2if_que_selfrsh(l2if_que_selfrsh),
			  .dram_dbginit_l(dram_dbginit_l),
			  .l2if_data_mecc0(l2if_data_mecc0[3:0]),
			  .l2if_data_mecc1(l2if_data_mecc1[3:0]),
			  .l2if_data_mecc2(l2if_data_mecc2[3:0]),
			  .l2if_data_mecc3(l2if_data_mecc3[3:0]),
			  .l2if_data_mecc4(l2if_data_mecc4[3:0]),
			  .l2if_data_mecc5(l2if_data_mecc5[3:0]),
			  .l2if_data_mecc6(l2if_data_mecc6[3:0]),
			  .l2if_data_mecc7(l2if_data_mecc7[3:0]),
			  .l2if_rd_id	(l2if_rd_id[2:0]),
			  .l2if_rd_addr	(l2if_rd_addr[35:0]),
			  .l2if_wr_addr	(l2if_wr_addr[35:0]),
			  .l2if_wr_req	(l2if_wr_req),
			  .l2if_rd_req	(l2if_rd_req),
			  .l2if_dbg_trig_en(l2if_dbg_trig_en),
			  .l2if_data_wr_addr(l2if_data_wr_addr[2:0]),
			  .l2if_err_addr_reg(l2if_err_addr_reg[35:0]),
			  .l2if_err_sts_reg(l2if_err_sts_reg[22:0]),
			  .l2if_err_loc	(l2if_err_loc[35:0]),
			  .l2if_err_cnt	(l2if_err_cnt[17:0]),
			  .que_mem_data	(que_mem_data[255:0]),
			  .io_dram_data_valid(io_dram_data_valid),
			  .io_dram_data_in(io_dram_data_in[255:0]),
			  .io_dram_ecc_in(io_dram_ecc_in[31:0]),
			  .l2if_que_rd_req_vld(l2if_que_rd_req_vld),
			  .l2if_que_wr_req_vld(l2if_que_wr_req_vld),
			  .l2if_que_addr(l2if_que_addr[31:0]),
			  .l2if_que_data(l2if_que_data[63:0]),
			  .l2if_scrb_data_en(l2if_scrb_data_en),
			  .l2if_scrb_data(l2if_scrb_data[255:0]),
			  .l2if_scrb_ecc(l2if_scrb_ecc[33:0]),
			  .pt_ch_blk_new_openbank(pt_ch_blk_new_openbank),
			  .pt_max_banks_open(pt_max_banks_open[16:0]),
			  .pt_max_time	(pt_max_time[15:0]),
			  .ch0_que_ras_int_picked(ch0_que_ras_int_picked[7:0]),
			  .ch0_que_b0_data_addr(ch0_que_b0_data_addr[5:0]),
			  .ch0_que_channel_picked(ch0_que_channel_picked),
			  .ch1_que_l2req_valids(ch1_que_l2req_valids[7:0]),
			  .ch1_que_b0_addr_picked(ch1_que_b0_addr_picked[35:0]),
			  .ch1_que_b0_id_picked(ch1_que_b0_id_picked[2:0]),
			  .ch1_que_b0_index_picked(ch1_que_b0_index_picked[2:0]),
			  .ch1_que_b0_cmd_picked(ch1_que_b0_cmd_picked),
			  .other_que_channel_disabled(other_que_channel_disabled),
			  .ch1_que_int_wr_que_inv_info(ch1_que_int_wr_que_inv_info[6:0]),
			  .other_que_pos(other_que_pos[4:0]),
			  .ch1_que_mem_data(ch1_que_mem_data[255:0]),
			  .ch1_dp_data_mecc0(ch1_dp_data_mecc0[3:0]),
			  .ch1_dp_data_mecc1(ch1_dp_data_mecc1[3:0]),
			  .ch1_dp_data_mecc2(ch1_dp_data_mecc2[3:0]),
			  .ch1_dp_data_mecc3(ch1_dp_data_mecc3[3:0]),
			  .ch1_dp_data_mecc4(ch1_dp_data_mecc4[3:0]),
			  .ch1_dp_data_mecc5(ch1_dp_data_mecc5[3:0]),
			  .ch1_dp_data_mecc6(ch1_dp_data_mecc6[3:0]),
			  .ch1_dp_data_mecc7(ch1_dp_data_mecc7[3:0]),
			  .ch0_que_cas_int_picked(ch0_que_cas_int_picked[7:0]),
			  .ch0_que_wr_cas_ch01_picked(ch0_que_wr_cas_ch01_picked),
			  .ch0_que_mux_write_en(ch0_que_mux_write_en));

/*dram_mem	AUTO_TEMPLATE( 	.clk(cmp_clk),
				.margin(que_margin_reg[4:0])); */

dram_mem	dram_mem(/*AUTOINST*/
			 // Outputs
			 .que_mem_data	(que_mem_data[255:0]),
			 .listen_out	(listen_out[64:0]),
			 // Inputs
			 .que_mem_addr	(que_mem_addr[4:0]),
			 .dram_cpu_wr_addr(dram_cpu_wr_addr[3:0]),
			 .dram_cpu_wr_data(dram_cpu_wr_data[63:0]),
			 .dram_clk	(dram_clk),
			 .clk		(cmp_clk),		 // Templated
			 .dram_cpu_wr_en(dram_cpu_wr_en[3:0]),
			 .margin	(que_margin_reg[4:0]),	 // Templated
			 .sehold	(sehold),
			 .mem_bypass	(mem_bypass));

endmodule // dramctl 
