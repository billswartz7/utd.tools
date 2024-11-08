// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_dctl.v
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

module dram_dctl (/*AUTOARG*/
   // Outputs
   que_margin_reg, readqbank0vld0, readqbank0vld1, readqbank0vld2, 
   readqbank0vld3, writeqbank0vld0, writeqbank0vld1, writeqbank0vld2, 
   writeqbank0vld3, readqbank0vld4, readqbank0vld5, readqbank0vld6, 
   readqbank0vld7, writeqbank0vld4, writeqbank0vld5, writeqbank0vld6, 
   writeqbank0vld7, que_wr_req, dp_data_in, dp_ecc_in, que_scrb_addr, 
   dram_fail_over_mode, que_wr_entry_free, config_reg, 
   que_rank1_present, que_addr_bank_low_sel, que_eight_bank_mode, 
   que_mem_addr, dram_io_data_out, dram_io_addr, dram_io_bank, 
   dram_io_cas_l, dram_io_cke, dram_io_cs_l, dram_io_drive_data, 
   dram_io_drive_enable, dram_io_ras_l, dram_io_write_en_l, 
   dram_io_pad_enable, dram_io_clk_enable, dram_io_pad_clk_inv, 
   dram_io_ptr_clk_inv, dram_io_channel_disabled, que_l2if_ack_vld, 
   que_l2if_nack_vld, que_l2if_data, que_dram_clk_toggle, 
   dp_data_valid, que_l2if_send_info, dram_local_pt_opened_bank, 
   que_max_banks_open_valid, que_max_banks_open, que_max_time_valid, 
   que_int_wr_que_inv_info, que_ras_int_picked, que_b0_data_addr, 
   que_l2req_valids, que_b0_addr_picked, que_b0_id_picked, 
   que_b0_index_picked, que_b0_cmd_picked, que_channel_picked, 
   que_int_pos, que_channel_disabled, dp_data_mecc0, dp_data_mecc1, 
   dp_data_mecc2, dp_data_mecc3, dp_data_mecc4, dp_data_mecc5, 
   dp_data_mecc6, dp_data_mecc7, que_cas_int_picked, 
   que_wr_cas_ch01_picked, que_mux_write_en, 
   // Inputs
   clk, rst_l, arst_l, sehold, l2if_que_selfrsh, dram_dbginit_l, 
   l2if_data_mecc0, l2if_data_mecc1, l2if_data_mecc2, 
   l2if_data_mecc3, l2if_data_mecc4, l2if_data_mecc5, 
   l2if_data_mecc6, l2if_data_mecc7, l2if_rd_id, l2if_rd_addr, 
   l2if_wr_addr, l2if_wr_req, l2if_rd_req, l2if_dbg_trig_en, 
   l2if_data_wr_addr, l2if_err_addr_reg, l2if_err_sts_reg, 
   l2if_err_loc, l2if_err_cnt, que_mem_data, io_dram_data_valid, 
   io_dram_data_in, io_dram_ecc_in, l2if_que_rd_req_vld, 
   l2if_que_wr_req_vld, l2if_que_addr, l2if_que_data, 
   l2if_scrb_data_en, l2if_scrb_data, l2if_scrb_ecc, 
   pt_ch_blk_new_openbank, pt_max_banks_open, pt_max_time, 
   ch0_que_ras_int_picked, ch0_que_b0_data_addr, 
   ch0_que_channel_picked, ch1_que_l2req_valids, 
   ch1_que_b0_addr_picked, ch1_que_b0_id_picked, 
   ch1_que_b0_index_picked, ch1_que_b0_cmd_picked, 
   other_que_channel_disabled, ch1_que_int_wr_que_inv_info, 
   other_que_pos, ch1_que_mem_data, ch1_dp_data_mecc0, 
   ch1_dp_data_mecc1, ch1_dp_data_mecc2, ch1_dp_data_mecc3, 
   ch1_dp_data_mecc4, ch1_dp_data_mecc5, ch1_dp_data_mecc6, 
   ch1_dp_data_mecc7, ch0_que_cas_int_picked, 
   ch0_que_wr_cas_ch01_picked, ch0_que_mux_write_en
   );

input 	 		clk;
input 	 		rst_l;
input 	 		arst_l;
input 	 		sehold;
input			l2if_que_selfrsh;
input			dram_dbginit_l;
output [4:0]		que_margin_reg;

// CPU CLK DOMAIN INTERFACE
input [3:0]     	l2if_data_mecc0;
input [3:0]     	l2if_data_mecc1;
input [3:0]     	l2if_data_mecc2;
input [3:0]     	l2if_data_mecc3;
input [3:0]     	l2if_data_mecc4;
input [3:0]     	l2if_data_mecc5;
input [3:0]     	l2if_data_mecc6;
input [3:0]     	l2if_data_mecc7;

input [2:0]		l2if_rd_id;
input [35:0]		l2if_rd_addr;
input [35:0]		l2if_wr_addr;
input			l2if_wr_req;
input			l2if_rd_req;
input			l2if_dbg_trig_en;

output                  readqbank0vld0;
output                  readqbank0vld1;
output                  readqbank0vld2;
output                  readqbank0vld3;
output                  writeqbank0vld0;
output                  writeqbank0vld1;
output                  writeqbank0vld2;
output                  writeqbank0vld3;
output                  readqbank0vld4;
output                  readqbank0vld5;
output                  readqbank0vld6;
output                  readqbank0vld7;
output                  writeqbank0vld4;
output                  writeqbank0vld5;
output                  writeqbank0vld6;
output                  writeqbank0vld7;
output                  que_wr_req;
output [255:0]          dp_data_in;
output [31:0]           dp_ecc_in;
input [2:0]            	l2if_data_wr_addr;
output [32:0]		que_scrb_addr;

input [35:0]   		l2if_err_addr_reg;
input [22:0]   		l2if_err_sts_reg;
output                  dram_fail_over_mode;
output [3:0]		que_wr_entry_free;
input [35:0]    	l2if_err_loc;
input [17:0]    	l2if_err_cnt;
output [8:0]		config_reg;
output			que_rank1_present;
output			que_addr_bank_low_sel;
output			que_eight_bank_mode;

// MEMORY INTERFACE 
input [255:0]         	que_mem_data;
output [4:0]            que_mem_addr;

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
output          	dram_io_pad_clk_inv;
output [4:0]         	dram_io_ptr_clk_inv;
output          	dram_io_channel_disabled;

// FROM L2if UCB
input           	l2if_que_rd_req_vld;
input           	l2if_que_wr_req_vld;
input [31:0]    	l2if_que_addr;
input [63:0]    	l2if_que_data;

// TO l2if UCB
output          	que_l2if_ack_vld;
output          	que_l2if_nack_vld;
output [63:0]   	que_l2if_data;

input			l2if_scrb_data_en;
input [255:0]		l2if_scrb_data;
input [33:0]		l2if_scrb_ecc;
output			que_dram_clk_toggle;	
output			dp_data_valid;	
output [9:0]		que_l2if_send_info;		

// FROM POWER THROTTLE
output          	dram_local_pt_opened_bank;
output          	que_max_banks_open_valid;
output [16:0]    	que_max_banks_open;
output          	que_max_time_valid;

input          		pt_ch_blk_new_openbank;
input [16:0]     	pt_max_banks_open;
input [15:0]     	pt_max_time;

// NEW ADDITION DUE TO 2 CHANNEL MODE
input [7:0]     	ch0_que_ras_int_picked;
input [5:0]     	ch0_que_b0_data_addr;
input           	ch0_que_channel_picked;
input [7:0]     	ch1_que_l2req_valids;
input [35:0]    	ch1_que_b0_addr_picked;
input [2:0]     	ch1_que_b0_id_picked;
input [2:0]     	ch1_que_b0_index_picked;
input           	ch1_que_b0_cmd_picked;
input          		other_que_channel_disabled;
input [6:0]		ch1_que_int_wr_que_inv_info;
input [4:0]     	other_que_pos;

output [6:0]		que_int_wr_que_inv_info;
output [7:0]    	que_ras_int_picked;
output [5:0]    	que_b0_data_addr;
output [7:0]    	que_l2req_valids;
output [35:0]   	que_b0_addr_picked;
output [2:0]    	que_b0_id_picked;
output [2:0]    	que_b0_index_picked;
output          	que_b0_cmd_picked;
output          	que_channel_picked;

output [4:0]     	que_int_pos;
output          	que_channel_disabled;

input [255:0]   	ch1_que_mem_data;
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

// FOR PERF
input [7:0]   		ch0_que_cas_int_picked;
input         		ch0_que_wr_cas_ch01_picked;
input         		ch0_que_mux_write_en;
output [7:0]  		que_cas_int_picked;
output                	que_wr_cas_ch01_picked;
output                	que_mux_write_en;

//////////////////////////////////////////////////////////////////
// Wires
//////////////////////////////////////////////////////////////////
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [34:0]		dram_fail_over_mask;	// From dram_que of dram_que.v
wire			err_inj_reg;		// From dram_que of dram_que.v
wire [15:0]		err_mask_reg;		// From dram_que of dram_que.v
wire			que_bypass_scrb_data;	// From dram_que of dram_que.v
wire			que_st_cmd_addr_parity;	// From dram_que of dram_que.v
wire			que_wr_channel_mux;	// From dram_que of dram_que.v
// End of automatics

dram_que	dram_que(/*AUTOINST*/
			 // Outputs
			.sshot_err_reg(sshot_err_reg),
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
			 .que_scrb_addr	(que_scrb_addr[32:0]),
			 .dram_fail_over_mode(dram_fail_over_mode),
			 .que_wr_entry_free(que_wr_entry_free[3:0]),
			 .config_reg	(config_reg[8:0]),
			 .que_rank1_present(que_rank1_present),
			 .que_addr_bank_low_sel(que_addr_bank_low_sel),
			 .dram_io_pad_enable(dram_io_pad_enable),
			 .dram_io_addr	(dram_io_addr[14:0]),
			 .dram_io_bank	(dram_io_bank[2:0]),
			 .dram_io_cs_l	(dram_io_cs_l[3:0]),
			 .dram_io_ras_l	(dram_io_ras_l),
			 .dram_io_cas_l	(dram_io_cas_l),
			 .dram_io_cke	(dram_io_cke),
			 .dram_io_write_en_l(dram_io_write_en_l),
			 .dram_io_drive_enable(dram_io_drive_enable),
			 .dram_io_drive_data(dram_io_drive_data),
			 .dram_io_clk_enable(dram_io_clk_enable),
			 .dram_io_pad_clk_inv(dram_io_pad_clk_inv),
			 .dram_io_ptr_clk_inv(dram_io_ptr_clk_inv[4:0]),
			 .dram_io_channel_disabled(dram_io_channel_disabled),
			 .dram_fail_over_mask(dram_fail_over_mask[34:0]),
			 .que_mem_addr	(que_mem_addr[4:0]),
			 .que_bypass_scrb_data(que_bypass_scrb_data),
			 .que_l2if_ack_vld(que_l2if_ack_vld),
			 .que_l2if_nack_vld(que_l2if_nack_vld),
			 .que_l2if_data	(que_l2if_data[63:0]),
			 .que_dram_clk_toggle(que_dram_clk_toggle),
			 .dram_local_pt_opened_bank(dram_local_pt_opened_bank),
			 .que_max_banks_open_valid(que_max_banks_open_valid),
			 .que_max_banks_open(que_max_banks_open[16:0]),
			 .que_max_time_valid(que_max_time_valid),
			 .err_inj_reg	(err_inj_reg),
			 .err_mask_reg	(err_mask_reg[15:0]),
			 .que_st_cmd_addr_parity(que_st_cmd_addr_parity),
			 .que_cas_int_picked(que_cas_int_picked[7:0]),
			 .que_wr_cas_ch01_picked(que_wr_cas_ch01_picked),
			 .que_mux_write_en(que_mux_write_en),
			 .que_l2if_send_info(que_l2if_send_info[9:0]),
			 .que_ras_int_picked(que_ras_int_picked[7:0]),
			 .que_b0_data_addr(que_b0_data_addr[5:0]),
			 .que_l2req_valids(que_l2req_valids[7:0]),
			 .que_b0_addr_picked(que_b0_addr_picked[35:0]),
			 .que_b0_id_picked(que_b0_id_picked[2:0]),
			 .que_b0_index_picked(que_b0_index_picked[2:0]),
			 .que_b0_cmd_picked(que_b0_cmd_picked),
			 .que_channel_picked(que_channel_picked),
			 .que_int_wr_que_inv_info(que_int_wr_que_inv_info[6:0]),
			 .que_int_pos	(que_int_pos[4:0]),
			 .que_channel_disabled(que_channel_disabled),
			 .que_wr_channel_mux(que_wr_channel_mux),
			 .que_eight_bank_mode(que_eight_bank_mode),
			 // Inputs
			 .clk		(clk),
			 .rst_l		(rst_l),
			 .arst_l	(arst_l),
			 .sehold	(sehold),
			 .l2if_que_selfrsh(l2if_que_selfrsh),
			 .dram_dbginit_l(dram_dbginit_l),
			 .l2if_rd_id	(l2if_rd_id[2:0]),
			 .l2if_rd_addr	(l2if_rd_addr[35:0]),
			 .l2if_wr_addr	(l2if_wr_addr[35:0]),
			 .l2if_wr_req	(l2if_wr_req),
			 .l2if_rd_req	(l2if_rd_req),
			 .l2if_que_rd_req_vld(l2if_que_rd_req_vld),
			 .l2if_que_wr_req_vld(l2if_que_wr_req_vld),
			 .l2if_que_addr	(l2if_que_addr[31:0]),
			 .l2if_que_data	(l2if_que_data[63:0]),
			 .pt_ch_blk_new_openbank(pt_ch_blk_new_openbank),
			 .pt_max_banks_open(pt_max_banks_open[16:0]),
			 .pt_max_time	(pt_max_time[15:0]),
			 .l2if_data_wr_addr(l2if_data_wr_addr[2:0]),
			 .l2if_err_addr_reg(l2if_err_addr_reg[35:0]),
			 .l2if_err_sts_reg(l2if_err_sts_reg[22:0]),
			 .l2if_err_loc	(l2if_err_loc[35:0]),
			 .l2if_err_cnt	(l2if_err_cnt[17:0]),
			 .l2if_dbg_trig_en(l2if_dbg_trig_en),
			 .ch0_que_cas_int_picked(ch0_que_cas_int_picked[7:0]),
			 .ch0_que_wr_cas_ch01_picked(ch0_que_wr_cas_ch01_picked),
			 .ch0_que_mux_write_en(ch0_que_mux_write_en),
			 .ch0_que_ras_int_picked(ch0_que_ras_int_picked[7:0]),
			 .ch0_que_b0_data_addr(ch0_que_b0_data_addr[5:0]),
			 .ch0_que_channel_picked(ch0_que_channel_picked),
			 .ch1_que_l2req_valids(ch1_que_l2req_valids[7:0]),
			 .ch1_que_b0_addr_picked(ch1_que_b0_addr_picked[35:0]),
			 .ch1_que_b0_id_picked(ch1_que_b0_id_picked[2:0]),
			 .ch1_que_b0_index_picked(ch1_que_b0_index_picked[2:0]),
			 .ch1_que_b0_cmd_picked(ch1_que_b0_cmd_picked),
			 .other_que_channel_disabled(other_que_channel_disabled),
			 .other_que_pos	(other_que_pos[4:0]),
			 .ch1_que_int_wr_que_inv_info(ch1_que_int_wr_que_inv_info[6:0]));

dram_dp		dram_dp(/*AUTOINST*/
			// Outputs
			.dp_data_mecc0	(dp_data_mecc0[3:0]),
			.dp_data_mecc1	(dp_data_mecc1[3:0]),
			.dp_data_mecc2	(dp_data_mecc2[3:0]),
			.dp_data_mecc3	(dp_data_mecc3[3:0]),
			.dp_data_mecc4	(dp_data_mecc4[3:0]),
			.dp_data_mecc5	(dp_data_mecc5[3:0]),
			.dp_data_mecc6	(dp_data_mecc6[3:0]),
			.dp_data_mecc7	(dp_data_mecc7[3:0]),
			.dram_io_data_out(dram_io_data_out[287:0]),
			.dp_data_in	(dp_data_in[255:0]),
			.dp_ecc_in	(dp_ecc_in[31:0]),
			.dp_data_valid	(dp_data_valid),
			// Inputs
			.clk		(clk),
			.rst_l		(rst_l),
			.l2if_data_mecc0(l2if_data_mecc0[3:0]),
			.l2if_data_mecc1(l2if_data_mecc1[3:0]),
			.l2if_data_mecc2(l2if_data_mecc2[3:0]),
			.l2if_data_mecc3(l2if_data_mecc3[3:0]),
			.l2if_data_mecc4(l2if_data_mecc4[3:0]),
			.l2if_data_mecc5(l2if_data_mecc5[3:0]),
			.l2if_data_mecc6(l2if_data_mecc6[3:0]),
			.l2if_data_mecc7(l2if_data_mecc7[3:0]),
			.io_dram_data_in(io_dram_data_in[255:0]),
			.io_dram_ecc_in	(io_dram_ecc_in[31:0]),
			.io_dram_data_valid(io_dram_data_valid),
			.que_bypass_scrb_data(que_bypass_scrb_data),
			.que_mem_addr	(que_mem_addr[4:0]),
			.que_mem_data	(que_mem_data[255:0]),
			.que_st_cmd_addr_parity(que_st_cmd_addr_parity),
			.que_channel_disabled(que_channel_disabled),
			.dram_fail_over_mask(dram_fail_over_mask[34:0]),
			.l2if_scrb_data_en(l2if_scrb_data_en),
			.l2if_scrb_data	(l2if_scrb_data[255:0]),
			.l2if_scrb_ecc	(l2if_scrb_ecc[33:0]),
			.err_inj_reg	(err_inj_reg),
			.err_mask_reg	(err_mask_reg[15:0]),
			.que_wr_channel_mux(que_wr_channel_mux),
			.ch1_que_mem_data(ch1_que_mem_data[255:0]),
			.ch1_dp_data_mecc0(ch1_dp_data_mecc0[3:0]),
			.ch1_dp_data_mecc1(ch1_dp_data_mecc1[3:0]),
			.ch1_dp_data_mecc2(ch1_dp_data_mecc2[3:0]),
			.ch1_dp_data_mecc3(ch1_dp_data_mecc3[3:0]),
			.ch1_dp_data_mecc4(ch1_dp_data_mecc4[3:0]),
			.ch1_dp_data_mecc5(ch1_dp_data_mecc5[3:0]),
			.ch1_dp_data_mecc6(ch1_dp_data_mecc6[3:0]),
			.ch1_dp_data_mecc7(ch1_dp_data_mecc7[3:0]),
			.sshot_err_reg(sshot_err_reg));

endmodule // dram_dctl 
