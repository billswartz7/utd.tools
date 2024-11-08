// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_que.v
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

module dram_que (/*AUTOARG*/
   // Outputs
   que_margin_reg, readqbank0vld0, readqbank0vld1, readqbank0vld2, 
   readqbank0vld3, writeqbank0vld0, writeqbank0vld1, writeqbank0vld2, 
   writeqbank0vld3, readqbank0vld4, readqbank0vld5, readqbank0vld6, 
   readqbank0vld7, writeqbank0vld4, writeqbank0vld5, writeqbank0vld6, 
   writeqbank0vld7, que_scrb_addr, dram_fail_over_mode, 
   que_wr_entry_free, config_reg, que_rank1_present, 
   que_addr_bank_low_sel, dram_io_pad_enable, dram_io_addr, 
   dram_io_bank, dram_io_cs_l, dram_io_ras_l, dram_io_cas_l, 
   dram_io_cke, dram_io_write_en_l, dram_io_drive_enable, 
   dram_io_drive_data, dram_io_clk_enable, dram_io_pad_clk_inv, 
   dram_io_ptr_clk_inv, dram_io_channel_disabled, 
   dram_fail_over_mask, que_mem_addr, que_bypass_scrb_data, 
   que_l2if_ack_vld, que_l2if_nack_vld, que_l2if_data, 
   que_dram_clk_toggle, dram_local_pt_opened_bank, 
   que_max_banks_open_valid, que_max_banks_open, que_max_time_valid, 
   err_inj_reg, err_mask_reg, que_st_cmd_addr_parity, 
   que_cas_int_picked, que_wr_cas_ch01_picked, que_mux_write_en, 
   que_l2if_send_info, que_ras_int_picked, que_b0_data_addr, 
   que_l2req_valids, que_b0_addr_picked, que_b0_id_picked, 
   que_b0_index_picked, que_b0_cmd_picked, que_channel_picked, 
   que_int_wr_que_inv_info, que_int_pos, que_channel_disabled, 
   que_wr_channel_mux, que_eight_bank_mode, 
   // Inputs
   clk, rst_l, l2if_que_selfrsh, dram_dbginit_l, l2if_rd_id, l2if_rd_addr, 
   l2if_wr_addr, l2if_wr_req, l2if_rd_req, l2if_que_rd_req_vld, 
   l2if_que_wr_req_vld, l2if_que_addr, l2if_que_data, 
   pt_ch_blk_new_openbank, pt_max_banks_open, pt_max_time, 
   l2if_data_wr_addr, l2if_err_addr_reg, l2if_err_sts_reg, 
   l2if_err_loc, l2if_err_cnt, l2if_dbg_trig_en, sehold,
   ch0_que_cas_int_picked, ch0_que_wr_cas_ch01_picked, 
   ch0_que_mux_write_en, ch0_que_ras_int_picked, arst_l,
   ch0_que_b0_data_addr, ch0_que_channel_picked, 
   ch1_que_l2req_valids, ch1_que_b0_addr_picked, 
   ch1_que_b0_id_picked, ch1_que_b0_index_picked, 
   ch1_que_b0_cmd_picked, other_que_channel_disabled, other_que_pos, 
   ch1_que_int_wr_que_inv_info, que_wr_req, sshot_err_reg
   );

// DRAM controller  interface
input 		clk;
input 		rst_l;
input 		arst_l;
input 		sehold;
input		l2if_que_selfrsh;
input		dram_dbginit_l;
output [4:0]	que_margin_reg;

// rd interface
input [2:0]  	l2if_rd_id;
input [35:0]   	l2if_rd_addr;
input [35:0]   	l2if_wr_addr;

// Valids from cpu to dram clk domain
input          	l2if_wr_req;
input          	l2if_rd_req;

// from dram to cpu clk domain
output		readqbank0vld0;
output		readqbank0vld1;
output		readqbank0vld2;
output		readqbank0vld3;
output		writeqbank0vld0;
output		writeqbank0vld1;
output		writeqbank0vld2;
output		writeqbank0vld3;
output		readqbank0vld4;
output		readqbank0vld5;
output		readqbank0vld6;
output		readqbank0vld7;
output		writeqbank0vld4;
output		writeqbank0vld5;
output		writeqbank0vld6;
output		writeqbank0vld7;
output		que_wr_req;

output [32:0]	que_scrb_addr;
output		dram_fail_over_mode;
output [3:0]	que_wr_entry_free;
output [8:0]	config_reg;
output		que_rank1_present;
output		que_addr_bank_low_sel;

// PAD interface
output		dram_io_pad_enable;
output [14:0]   dram_io_addr;   
output [2:0]    dram_io_bank;
output [3:0]    dram_io_cs_l;
output          dram_io_ras_l;
output          dram_io_cas_l;
output 		dram_io_cke;
output          dram_io_write_en_l;
output          dram_io_drive_enable;
output          dram_io_drive_data;
output		dram_io_clk_enable;
output 		dram_io_pad_clk_inv;
output [4:0]	dram_io_ptr_clk_inv;
output		dram_io_channel_disabled;

// DP interface
output [34:0]	dram_fail_over_mask;

// Store data interface
output [4:0]	que_mem_addr;

// capture scrub data enable
output		que_bypass_scrb_data;

// FROM L2if
input         	l2if_que_rd_req_vld;
input         	l2if_que_wr_req_vld;
input [31:0]  	l2if_que_addr;
input [63:0]    l2if_que_data;

// TO l2if
output          que_l2if_ack_vld;
output          que_l2if_nack_vld;
output [63:0] 	que_l2if_data;

// FROM CAS INFO
output		que_dram_clk_toggle;

// FROM POWER THROTTLE
output          dram_local_pt_opened_bank;
output		que_max_banks_open_valid;
output [16:0]   que_max_banks_open;
output		que_max_time_valid;

input          	pt_ch_blk_new_openbank;
input [16:0]    pt_max_banks_open;
input [15:0]    pt_max_time;

// TO DP
output		err_inj_reg;
output [15:0]	err_mask_reg;
output		que_st_cmd_addr_parity;

// FROM L2IF
input [2:0]	l2if_data_wr_addr;
input [35:0]    l2if_err_addr_reg;
input [22:0]    l2if_err_sts_reg;
input [35:0]	l2if_err_loc;
input [17:0]	l2if_err_cnt;
input 		l2if_dbg_trig_en;

// NEW ADDITION DUE TO 2 CHANNEL MODE
input [7:0]	ch0_que_cas_int_picked;
input		ch0_que_wr_cas_ch01_picked;
input		ch0_que_mux_write_en;
input [7:0]	ch0_que_ras_int_picked;
input [5:0]	ch0_que_b0_data_addr;
input		ch0_que_channel_picked;
input [7:0]    	ch1_que_l2req_valids;
input [35:0]   	ch1_que_b0_addr_picked;
input [2:0]    	ch1_que_b0_id_picked;
input [2:0]    	ch1_que_b0_index_picked;
input          	ch1_que_b0_cmd_picked;
input		other_que_channel_disabled;
input [4:0]	other_que_pos;
input [6:0]	ch1_que_int_wr_que_inv_info;

output [7:0]	que_cas_int_picked;
output		que_wr_cas_ch01_picked;
output		que_mux_write_en;
output [9:0]  	que_l2if_send_info;
output [7:0]	que_ras_int_picked;
output [5:0]	que_b0_data_addr;
output [7:0]	que_l2req_valids;
output [35:0]	que_b0_addr_picked;
output [2:0]	que_b0_id_picked;
output [2:0]	que_b0_index_picked;
output 		que_b0_cmd_picked;
output		que_channel_picked;
output [6:0]	que_int_wr_que_inv_info;

output [4:0]	que_int_pos;
output		que_channel_disabled;
output		que_wr_channel_mux;
output		que_eight_bank_mode;

output sshot_err_reg;

//////////////////////////////////////////////////////////////////
// Wires
//////////////////////////////////////////////////////////////////
wire [11:0]	que_cl2_stg_info;
wire [11:0]	que_cl3_stg_info;
wire [11:0]	que_cl4_stg_info;
wire [11:0]	que_cl5_stg_info;
wire [7:0]	b0_cas_cnt;
wire [7:0]	b1_cas_cnt;
wire [7:0]	b2_cas_cnt;
wire [7:0]	b3_cas_cnt;
wire [7:0]	b4_cas_cnt;
wire [7:0]	b5_cas_cnt;
wire [7:0]	b6_cas_cnt;
wire [7:0]	b7_cas_cnt;
wire [7:0]	b0_cas_cnt_in;
wire [7:0]	b1_cas_cnt_in;
wire [7:0]	b2_cas_cnt_in;
wire [7:0]	b3_cas_cnt_in;
wire [7:0]	b4_cas_cnt_in;
wire [7:0]	b5_cas_cnt_in;
wire [7:0]	b6_cas_cnt_in;
wire [7:0]	b7_cas_cnt_in;
wire [7:0]	que_perf_cntl_reg;
wire [31:0]	que_perf_cnt0_reg;
wire [31:0]	que_perf_cnt1_reg;
wire 		que_rd_xaction_picked;
wire 		que_wr_xaction_picked;
wire 		que_rd_or_wr_xaction_picked_d1;
wire 		que_bank_busy_stall;
wire 		que_writeback_buf_hit;
wire [3:0] 	que_rd_que_latency;
wire [3:0] 	que_wr_que_latency;
wire [3:0] 	que_rd_que_latency_d1;
wire [3:0] 	que_wr_que_latency_d1;
wire [4:0] 	que_rd_or_wr_que_latency_d1;
wire		two_channel_mode;
wire		que_prev_scrb_wr_pending;
wire [3:0]	que_tot_data_del_cnt;
wire [8:0]	que_l2_send_id;
wire		que_init_dram_done;
wire [35:0]	que_split_scrb_addr;
wire [1:0]	que_refresh_rank;
wire [2:0]	que_refresh_rank_cnt;
wire		que_scrb_stack_addr;
wire [9:0]	que_l2if_send_info_in;
wire [1:0]	que_phy_bank_picked;
wire		que_b0_rd_picked;
wire [32:0]	que_scrb_addr_p1;
wire [2:0]	que_b0_wr_data_addr_picked;
wire		que_rank1_present;
wire		que_scrb_rank_addr;
wire		que_mux_rank_adr;
wire		que_phy_bank_wait;
wire		que_rank_picked;
wire		dram_io_pad_enable_in;
wire [2:0]	que_data_del_cnt_in;
wire [2:0]	que_data_del_cnt;
wire		dram_io_sw_mux_cnt_en;
wire [1:0]      dram_io_sw_mux_cnt_in;
wire [1:0]      dram_io_sw_mux_cnt;
wire		que_init_en;
wire		que_init_in;
wire		que_init;
wire		que_ack_vld_in;
wire		que_nack_vld_in;
wire		que_b0_wr_index_pend;
wire [12:0]	que_ref_cnt_166_200;
wire [12:0]	que_ref_cnt_166_200_in;
wire		que_scrb_write_req;
wire		que_scrb_write_valid;
wire		que_scrb_read_valid;
wire [11:0]	que_scrb_cnt_in;
wire [11:0]	que_scrb_cnt;
wire		que_scrb_cnt_reset;
wire		que_scrb_time;
wire		que_scrb_read_en;
wire [8:0]	que_scrb_cas_addr_in;
wire [8:0]	que_scrb_cas_addr;
wire [14:0]	que_scrb_ras_addr_in;
wire [14:0]	que_scrb_ras_addr;
wire [2:0]	que_scrb_bank_in;
wire [2:0]	que_scrb_bank;
wire		que_scrb_picked;
wire		que_scrb_rd_picked;
wire		rp_cnt_is_zero;
wire [4:0]	que_int_pos;
wire [4:0]	que_pos;
wire		que_po_ras_l;
wire		que_po_cas_l;
wire		que_po_write_en_l;
wire [3:0]	que_po_cs_l;
wire [2:0]	que_po_bank;
wire [14:0]	que_po_addr;
wire		que_po_ras_l_p1;
wire		que_po_cas_l_p1;
wire [3:0]	que_po_cs_l_p1;
wire		que_po_write_en_l_p1;
wire [2:0]	que_po_bank_p1;
wire [14:0]	que_po_addr_p1;
wire		dram_io_cke_p1;
wire		que_mux_special_data;
wire		que_refresh_req_picked;
wire		que_dram_clk_toggle_in;
wire [7:0]      que_cas_picked_d1;
wire [7:0]      que_cas_picked_io_d1;
wire 		que_cas_picked;
wire		que_b0_rdq_full;
wire		que_b0_wrq_full;
wire		que_write_en_int;
wire		que_drive_dqs_1f;
wire            sch_mode_reg_en;
wire [20:0]     chip_config_reg_in;
wire		rqb0entry0wren;
wire		rqb0entry1wren;
wire		rqb0entry2wren;
wire		rqb0entry3wren;
wire		rqb0entry4wren;
wire		rqb0entry5wren;
wire		rqb0entry6wren;
wire		rqb0entry7wren;
wire		wqb0entry0wren;
wire		wqb0entry1wren;
wire		wqb0entry2wren;
wire		wqb0entry3wren;
wire		wqb0entry4wren;
wire		wqb0entry5wren;
wire		wqb0entry6wren;
wire		wqb0entry7wren;
wire		readqbank0vld0reset;
wire		readqbank0vld1reset;
wire		readqbank0vld2reset;
wire		readqbank0vld3reset;
wire		readqbank0vld4reset;
wire		readqbank0vld5reset;
wire		readqbank0vld6reset;
wire		readqbank0vld7reset;
wire		writeqbank0vld0reset;
wire		writeqbank0vld1reset;
wire		writeqbank0vld2reset;
wire		writeqbank0vld3reset;
wire		writeqbank0vld4reset;
wire		writeqbank0vld5reset;
wire		writeqbank0vld6reset;
wire		writeqbank0vld7reset;
wire [7:0]	que_b0_rd_index;
wire [7:0]	que_b0_wr_index;
wire		que_b0_index_en;
wire [20:0]	chip_config_reg;
wire [7:0]	que_b0_banksel_addr0_dec;
wire [7:0]	que_b0_banksel_addr1_dec;
wire [7:0]	que_b0_banksel_addr2_dec;
wire [7:0]	que_b0_banksel_addr4_dec;
wire [7:0]	que_b0_banksel_addr3_dec;
wire [7:0]	que_b0_banksel_addr5_dec;
wire [7:0]	que_b0_banksel_addr6_dec;
wire [7:0]	que_b0_banksel_addr7_dec;
wire [7:0]	que_b0_wr_banksel_addr0_dec;
wire [7:0]	que_b0_wr_banksel_addr1_dec;
wire [7:0]	que_b0_wr_banksel_addr2_dec;
wire [7:0]	que_b0_wr_banksel_addr4_dec;
wire [7:0]	que_b0_wr_banksel_addr3_dec;
wire [7:0]	que_b0_wr_banksel_addr5_dec;
wire [7:0]	que_b0_wr_banksel_addr6_dec;
wire [7:0]	que_b0_wr_banksel_addr7_dec;
wire [7:0]	que_b0_indx0_val;
wire [7:0]	que_b0_indx1_val;
wire [7:0]	que_b0_indx2_val;
wire [7:0]	que_b0_indx3_val;
wire [7:0]	que_b0_indx4_val;
wire [7:0]	que_b0_indx5_val;
wire [7:0]	que_b0_indx6_val;
wire [7:0]	que_b0_indx7_val;
wire [7:0]	que_b0_wr_indx0_val;
wire [7:0]	que_b0_wr_indx1_val;
wire [7:0]	que_b0_wr_indx2_val;
wire [7:0]	que_b0_wr_indx3_val;
wire [7:0]	que_b0_wr_indx4_val;
wire [7:0]	que_b0_wr_indx5_val;
wire [7:0]	que_b0_wr_indx6_val;
wire [7:0]	que_b0_wr_indx7_val;
wire [7:0]	que_b0_indx0_val_d1;
wire [7:0]	que_b0_indx1_val_d1;
wire [7:0]	que_b0_indx2_val_d1;
wire [7:0]	que_b0_indx3_val_d1;
wire [7:0]	que_b0_indx4_val_d1;
wire [7:0]	que_b0_indx5_val_d1;
wire [7:0]	que_b0_indx6_val_d1;
wire [7:0]	que_b0_indx7_val_d1;
wire [7:0]	que_b0_wr_indx0_val_d1;
wire [7:0]	que_b0_wr_indx1_val_d1;
wire [7:0]	que_b0_wr_indx2_val_d1;
wire [7:0]	que_b0_wr_indx3_val_d1;
wire [7:0]	que_b0_wr_indx4_val_d1;
wire [7:0]	que_b0_wr_indx5_val_d1;
wire [7:0]	que_b0_wr_indx6_val_d1;
wire [7:0]	que_b0_wr_indx7_val_d1;
wire [7:0]	que_b0_bank_val;
wire [7:0]	que_scrb_bank_valid;
wire [7:0]	que_bank_l2req_valids;
wire [7:0]	que_bank_valids;
wire [3:0]	rrd_cnt_next;
wire [3:0]	rrd_cnt;
wire		rrd_cnt_is_zero;
wire [3:0]	b0_rcd_cnt_next;
wire [3:0]	b0_rcd_cnt;
wire		b0_rcd_cnt_is_zero;
wire [4:0]	b0_rc_cnt_next;
wire [4:0]	b0_rc_cnt;
wire		b0_rc_cnt_is_zero;
wire		b0_ras_pend_req;
wire		b0_ras_picked;
wire		b0_cas_pend_req;
wire		b0_cas_picked;
wire [3:0]	b7_rcd_cnt_next;
wire [3:0]	b7_rcd_cnt;
wire		b7_rcd_cnt_is_zero;
wire [4:0]	b7_rc_cnt_next;
wire [4:0]	b7_rc_cnt;
wire		b7_rc_cnt_is_zero;
wire		b7_ras_pend_req;
wire		b7_ras_picked;
wire		b7_cas_pend_req;
wire		b7_cas_picked;
wire		b1_ras_pend_req;
wire		b2_ras_pend_req;
wire		b3_ras_pend_req;
wire		b4_ras_pend_req;
wire		b5_ras_pend_req;
wire		b6_ras_pend_req;
wire		b1_ras_picked;
wire		b2_ras_picked;
wire		b3_ras_picked;
wire		b4_ras_picked;
wire		b5_ras_picked;
wire		b6_ras_picked;
wire [7:0]	que_cas_valid;
wire [31:0]	b7_cas_info;
wire [31:0]	b6_cas_info;
wire [31:0]	b5_cas_info;
wire [31:0]	b4_cas_info;
wire [31:0]	b3_cas_info;
wire [31:0]	b2_cas_info;
wire [31:0]	b1_cas_info;
wire [31:0]	b0_cas_info;
wire		b1_cas_pend_req;
wire		b2_cas_pend_req;
wire		b3_cas_pend_req;
wire		b4_cas_pend_req;
wire		b5_cas_pend_req;
wire		b6_cas_pend_req;
wire		b1_cas_picked;
wire		b2_cas_picked;
wire		b3_cas_picked;
wire		b4_cas_picked;
wire		b5_cas_picked;
wire		b6_cas_picked;
wire [7:0]	que_ras_picked;
wire [7:0]	que_ras_picked_d1;
wire [7:0]	que_ras_picked_io_d1;
wire		que_b0_index0_picked;
wire		que_b0_index1_picked;
wire		que_b0_index2_picked;
wire		que_b0_index3_picked;
wire		que_b0_index4_picked;
wire		que_b0_index5_picked;
wire		que_b0_index6_picked;
wire		que_b0_index7_picked;
wire		que_b0_wr_index0_picked;
wire		que_b0_wr_index1_picked;
wire		que_b0_wr_index2_picked;
wire		que_b0_wr_index3_picked;
wire		que_b0_wr_index4_picked;
wire		que_b0_wr_index5_picked;
wire		que_b0_wr_index6_picked;
wire		que_b0_wr_index7_picked;
wire [2:0]	que_b0_index_picked;
wire [35:0]	que_b0_addr_picked;
wire [2:0]	que_b0_id_picked;
wire		que_b0_cmd_picked;
wire [2:0]	que_id_picked;
wire		que_cmd_picked;
wire [14:0]	que_ras_adr;
wire [13:0]	que_cas_adr;
wire [2:0]	que_bank_adr;
wire [14:0]	que_mux_cas_adr;
wire [2:0]	que_mux_bank_adr;
wire [6:0]	mode_reg_in;
wire [6:0]	mode_reg;
wire [14:0]	ext_mode_reg1_in;
wire [14:0]	ext_mode_reg1;
wire [14:0]	ext_mode_reg2_in;
wire [14:0]	ext_mode_reg2;
wire [14:0]	ext_mode_reg3_in;
wire [14:0]	ext_mode_reg3;
wire [8:0]	que_b0_index_ent0;
wire [8:0]	que_b0_index_ent1;
wire [8:0]	que_b0_index_ent2;
wire [8:0]	que_b0_index_ent3;
wire [8:0]	que_b0_index_ent4;
wire [8:0]	que_b0_index_ent5;
wire [8:0]	que_b0_index_ent6;
wire [8:0]	que_b0_index_ent7;
wire [35:0]	readqbank0addr0;
wire [35:0]	readqbank0addr1;
wire [35:0]	readqbank0addr2;
wire [35:0]	readqbank0addr3;
wire [35:0]	readqbank0addr4;
wire [35:0]	readqbank0addr5;
wire [35:0]	readqbank0addr6;
wire [35:0]	readqbank0addr7;
wire [35:0]	writeqbank0addr0;
wire [35:0]	writeqbank0addr1;
wire [35:0]	writeqbank0addr2;
wire [35:0]	writeqbank0addr3;
wire [35:0]	writeqbank0addr4;
wire [35:0]	writeqbank0addr5;
wire [35:0]	writeqbank0addr6;
wire [35:0]	writeqbank0addr7;
wire [2:0]	writeqaddr0;
wire [2:0]	writeqaddr1;
wire [2:0]	writeqaddr2;
wire [2:0]	writeqaddr3;
wire [2:0]	writeqaddr4;
wire [2:0]	writeqaddr5;
wire [2:0]	writeqaddr6;
wire [2:0]	writeqaddr7;
wire [2:0]	readqbank0id0;
wire [2:0]	readqbank0id1;
wire [2:0]	readqbank0id2;
wire [2:0]	readqbank0id3;
wire [2:0]	readqbank0id4;
wire [2:0]	readqbank0id5;
wire [2:0]	readqbank0id6;
wire [2:0]	readqbank0id7;
wire		que_bank0_cas_valid;
wire		que_bank1_cas_valid;
wire		que_bank2_cas_valid;
wire		que_bank3_cas_valid;
wire		que_bank4_cas_valid;
wire		que_bank5_cas_valid;
wire		que_bank6_cas_valid;
wire		que_bank7_cas_valid;
wire		que_bank0_cas_en;
wire		que_bank1_cas_en;
wire		que_bank2_cas_en;
wire		que_bank3_cas_en;
wire		que_bank4_cas_en;
wire		que_bank5_cas_en;
wire		que_bank6_cas_en;
wire		que_bank7_cas_en;

wire [3:0]	b1_rcd_cnt_next;
wire [3:0]	b1_rcd_cnt;
wire [4:0]	b1_rc_cnt_next;
wire [4:0]	b1_rc_cnt;
wire		b1_rc_cnt_is_zero;
wire		b1_rcd_cnt_is_zero;

wire [3:0]	b2_rcd_cnt_next;
wire [3:0]	b2_rcd_cnt;
wire [4:0]	b2_rc_cnt_next;
wire [4:0]	b2_rc_cnt;
wire		b2_rc_cnt_is_zero;
wire		b2_rcd_cnt_is_zero;

wire [3:0]	b3_rcd_cnt_next;
wire [3:0]	b3_rcd_cnt;
wire [4:0]	b3_rc_cnt_next;
wire [4:0]	b3_rc_cnt;
wire		b3_rc_cnt_is_zero;
wire		b3_rcd_cnt_is_zero;

wire [3:0]	b4_rcd_cnt_next;
wire [3:0]	b4_rcd_cnt;
wire [4:0]	b4_rc_cnt_next;
wire [4:0]	b4_rc_cnt;
wire		b4_rc_cnt_is_zero;
wire		b4_rcd_cnt_is_zero;

wire [3:0]	b5_rcd_cnt_next;
wire [3:0]	b5_rcd_cnt;
wire [4:0]	b5_rc_cnt_next;
wire [4:0]	b5_rc_cnt;
wire		b5_rc_cnt_is_zero;
wire		b5_rcd_cnt_is_zero;

wire [3:0]	b6_rcd_cnt_next;
wire [3:0]	b6_rcd_cnt;
wire [4:0]	b6_rc_cnt_next;
wire [4:0]	b6_rc_cnt;
wire		b6_rc_cnt_is_zero;
wire		b6_rcd_cnt_is_zero;

wire [3:0]	rrd_reg;
wire [3:0]	rcd_reg;
wire [4:0]	rc_reg;
wire [3:0]	rrd_reg_in;
wire [3:0]	rcd_reg_in;
wire [4:0]	rc_reg_in;

wire [3:0]	que_b0_data_rtn_cnt;
wire [3:0]	que_b1_data_rtn_cnt;
wire [3:0]	que_b2_data_rtn_cnt;
wire [3:0]	que_b3_data_rtn_cnt;
wire [3:0]	que_b4_data_rtn_cnt;
wire [3:0]	que_b5_data_rtn_cnt;
wire [3:0]	que_b6_data_rtn_cnt;
wire [3:0]	que_b7_data_rtn_cnt;

wire 		que_burst_wr_cnt;
wire 		que_burst_wr_cnt_in;
wire		que_burst_write_cnt_en;
wire [2:0]	que_wr_addr_b0;

wire [3:0]	wtr_reg_in;
wire [3:0]	wtr_reg;
wire [3:0]	wtr_dly_reg;
wire [1:0]	iwtr_reg_in;
wire [1:0]	iwtr_reg;

wire [3:0]	wtr_cnt_next;
wire [3:0]	wtr_cnt;
wire		wtr_cnt_is_zero;
wire 		rtr_cnt_next;
wire 		rtr_cnt;
wire		rtr_cnt_is_zero;
wire 		wtw_cnt_next;
wire 		wtw_cnt;
wire		wtw_cnt_is_zero;
wire [6:0]	rfc_cnt_next;
wire [6:0]	rfc_cnt;
wire		rfc_cnt_is_zero;
wire		mrd_cnt_is_zero;

wire [3:0]	rp_reg;
wire [3:0]	wr_reg;
wire [6:0]	rfc_reg;

wire [3:0]	b0_dal_cnt_next;
wire [3:0]	b0_dal_cnt;
wire		b0_dal_cnt_is_zero;
wire [3:0]	b1_dal_cnt_next;
wire [3:0]	b1_dal_cnt;
wire		b1_dal_cnt_is_zero;
wire [3:0]	b2_dal_cnt_next;
wire [3:0]	b2_dal_cnt;
wire		b2_dal_cnt_is_zero;
wire [3:0]	b3_dal_cnt_next;
wire [3:0]	b3_dal_cnt;
wire		b3_dal_cnt_is_zero;
wire [3:0]	b4_dal_cnt_next;
wire [3:0]	b4_dal_cnt;
wire		b4_dal_cnt_is_zero;
wire [3:0]	b5_dal_cnt_next;
wire [3:0]	b5_dal_cnt;
wire		b5_dal_cnt_is_zero;
wire [3:0]	b6_dal_cnt_next;
wire [3:0]	b6_dal_cnt;
wire		b6_dal_cnt_is_zero;
wire [3:0]	b7_dal_cnt_next;
wire [3:0]	b7_dal_cnt;
wire		b7_dal_cnt_is_zero;
wire [3:0]	dal_reg;
wire [3:0]	ral_reg;
wire [2:0]	que_index_picked;
wire		writeqbank0vld0reset_arb;
wire		writeqbank0vld1reset_arb;
wire		writeqbank0vld2reset_arb;
wire		writeqbank0vld3reset_arb;
wire		writeqbank0vld4reset_arb;
wire		writeqbank0vld5reset_arb;
wire		writeqbank0vld6reset_arb;
wire		writeqbank0vld7reset_arb;
wire [63:0]	que_ucb_data;
wire [31:0]	que_ucb_addr;
wire [35:0]	que_err_addr_reg;
wire [22:0]	que_err_sts_reg;
wire [2:0]	que_cpu_wr_addr;
wire [35:0]	que_rd_addr0;
wire [35:0]	que_wr_addr0;
wire [2:0]	que_rd_id0;
wire [35:0]	que_err_loc;
wire [17:0]	que_err_cnt;
wire [2:0]	que_b0_index_picked_d1;
wire		que_channel_picked_internal;

//////////////////////////////////////////////////////////////////
// Flopping the cpu domain signals to dram domain
//////////////////////////////////////////////////////////////////
dff_ns #(2) ff_rd_wr_val(
        .din    ({l2if_wr_req, l2if_rd_req}),
        .q      ({que_wr_req, que_rd_req}),
        .clk    (clk));

dff_ns #(3) ff_rd_id(
        .din    (l2if_rd_id),
        .q      (que_rd_id0),
        .clk    (clk));

dff_ns #(72) ff_rd_wr_addr(
        .din    ({l2if_rd_addr, l2if_wr_addr}),
        .q      ({que_rd_addr0, que_wr_addr0}),
        .clk    (clk));

dff_ns #(98) ff_ucb_req(
        .din    ({l2if_que_rd_req_vld, l2if_que_wr_req_vld, l2if_que_addr[31:0], 
			l2if_que_data[63:0]}),
        .q    ({que_ucb_rd_req_vld, que_ucb_wr_req_vld, que_ucb_addr[31:0], 
			que_ucb_data[63:0]}),
        .clk    (clk));

dff_ns #(60) ff_err1_regs(
        .din    ({l2if_dbg_trig_en, l2if_err_addr_reg[35:0], l2if_err_sts_reg[22:0]}),
        .q      ({que_dbg_trig_en, que_err_addr_reg[35:0], que_err_sts_reg[22:0]}),
        .clk    (clk));

dff_ns #(54) ff_err2_regs(
        .din    ({l2if_err_loc[35:0], l2if_err_cnt[17:0]}),
        .q      ({que_err_loc[35:0], que_err_cnt[17:0]}),
        .clk    (clk));

dff_ns #(3) ff_wr_index0(
        .din    (l2if_data_wr_addr[2:0]),
        .q      (que_cpu_wr_addr[2:0]),
        .clk    (clk));

//////////////////////////////////////////////////////////////////
// write index 
//////////////////////////////////////////////////////////////////
wire [2:0]	que_rd_addr_in;

assign que_wr_addr_b0 = {wqb0entry4wren|wqb0entry5wren|wqb0entry6wren|wqb0entry7wren, 
			wqb0entry7wren|wqb0entry6wren|wqb0entry3wren|wqb0entry2wren, 
			wqb0entry7wren|wqb0entry5wren|wqb0entry3wren|wqb0entry1wren};
assign que_rd_addr_in = {rqb0entry4wren|rqb0entry5wren|rqb0entry6wren|rqb0entry7wren, 
			rqb0entry7wren|rqb0entry6wren|rqb0entry3wren|rqb0entry2wren, 
			rqb0entry7wren|rqb0entry5wren|rqb0entry3wren|rqb0entry1wren};

//////////////////////////////////////////////////////////////////
// Write into the Read Queue's (Pick one empty entry)
//////////////////////////////////////////////////////////////////

assign rqb0entry0wren =  ~readqbank0vld0 & que_rd_req; 
assign rqb0entry1wren =  ~readqbank0vld1 & readqbank0vld0 & 
				que_rd_req;
assign rqb0entry2wren =  ~readqbank0vld2 & readqbank0vld1 & readqbank0vld0 & 
				que_rd_req; 
assign rqb0entry3wren =  ~readqbank0vld3 & readqbank0vld2 & readqbank0vld1 & 
				readqbank0vld0 & que_rd_req; 
assign rqb0entry4wren =  ~readqbank0vld4 & readqbank0vld3 & readqbank0vld2 & readqbank0vld1 &
                        	readqbank0vld0 & que_rd_req;
assign rqb0entry5wren =  ~readqbank0vld5 & readqbank0vld4 & readqbank0vld3 & readqbank0vld2 & 
				readqbank0vld1 & readqbank0vld0 & que_rd_req;
assign rqb0entry6wren =  ~readqbank0vld6 & readqbank0vld5 & readqbank0vld4 & readqbank0vld3 & 
				readqbank0vld2 & readqbank0vld1 & readqbank0vld0 & que_rd_req;
assign rqb0entry7wren =  ~readqbank0vld7 & readqbank0vld6 & readqbank0vld5 & readqbank0vld4 & 
				readqbank0vld3 & readqbank0vld2 & readqbank0vld1 & readqbank0vld0 & 
				que_rd_req;

//////////////////////////////////////////////////////////////////
// Write into the Write Queue's (Pick one valid entry)
//////////////////////////////////////////////////////////////////

// Silently drop req if address is out of range. so AND it with bit 32 of address.

assign wqb0entry0wren =  ~writeqbank0vld0 & que_wr_req & ~que_wr_addr0[32];
assign wqb0entry1wren =  ~writeqbank0vld1 & writeqbank0vld0 & 
				que_wr_req & ~que_wr_addr0[32]; 
assign wqb0entry2wren =  ~writeqbank0vld2 & writeqbank0vld1 & writeqbank0vld0 & 
				que_wr_req & ~que_wr_addr0[32]; 
assign wqb0entry3wren =  ~writeqbank0vld3 & writeqbank0vld2 & writeqbank0vld1 & 
				writeqbank0vld0 & que_wr_req & ~que_wr_addr0[32];
assign wqb0entry4wren =  ~writeqbank0vld4 & writeqbank0vld3 & writeqbank0vld2 & writeqbank0vld1 &
                        	writeqbank0vld0 & que_wr_req & ~que_wr_addr0[32];
assign wqb0entry5wren =  ~writeqbank0vld5 & writeqbank0vld4 & writeqbank0vld3 & writeqbank0vld2 & 
				writeqbank0vld1 & writeqbank0vld0 & que_wr_req & ~que_wr_addr0[32];
assign wqb0entry6wren =  ~writeqbank0vld6 & writeqbank0vld5 & writeqbank0vld4 & writeqbank0vld3 & 
				writeqbank0vld2 & writeqbank0vld1 & writeqbank0vld0 & 
				que_wr_req & ~que_wr_addr0[32];
assign wqb0entry7wren =  ~writeqbank0vld7 & writeqbank0vld6 & writeqbank0vld5 & writeqbank0vld4 & 
				writeqbank0vld3 & writeqbank0vld2 & writeqbank0vld1 & 
				writeqbank0vld0 & que_wr_req & ~que_wr_addr0[32];

//////////////////////////////////////////////////////////////////
//// Read Queues for 1 banks of L2 (1 DRAM channel)
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// Read Request Address bits and ID for bank0 
//////////////////////////////////////////////////////////////////

// Stage these so that reset happens 1 cycle later then the request got picked
dff_ns #(5) ff_cmd_picked(
        .din    ({que_channel_picked_internal, que_b0_cmd_picked, que_b0_index_picked[2:0]}),
        .q      ({que_channel_picked_internal_d1, que_b0_cmd_picked_d1, 
			que_b0_index_picked_d1[2:0]}),
        .clk    (clk));

// Generate read picked - it is ANDed due to rd is not always high priority
wire que_b0_rd_picked_in = que_b0_rd_picked & ~que_b0_cmd_picked & 
					(que_channel_picked_internal == que_channel_disabled);

dff_ns  #(4) ff_index_en (
        .din    ({que_cmd_picked, que_scrb_picked, que_b0_wr_index_pend, que_b0_rd_picked_in}),
        .q    	({que_cmd_picked_d1, que_scrb_picked_d1, que_b0_wr_index_pend_d1, que_b0_rd_picked_d1}),
        .clk    (clk));

assign readqbank0vld0reset = ~rst_l | (({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h0) & 
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign readqbank0vld1reset = ~rst_l | (({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h1) & 
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign readqbank0vld2reset = ~rst_l | (({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h2) & 
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign readqbank0vld3reset = ~rst_l | (({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h3) & 
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign readqbank0vld4reset = ~rst_l | (({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h4) & 
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign readqbank0vld5reset = ~rst_l | (({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h5) & 
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign readqbank0vld6reset = ~rst_l | (({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h6) & 
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign readqbank0vld7reset = ~rst_l | (({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h7) & 
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));

// Valids

dffrle_ns readqbank0vld0flop (
        .din    (1'b1),
        .q      (readqbank0vld0),
        .rst_l  (~readqbank0vld0reset),
        .en     (rqb0entry0wren),
        .clk    (clk));

dffrle_ns readqbank0vld1flop (
        .din    (1'b1),
        .q      (readqbank0vld1),
        .rst_l  (~readqbank0vld1reset),
        .en     (rqb0entry1wren),
        .clk    (clk));

dffrle_ns readqbank0vld2flop (
        .din    (1'b1),
        .q      (readqbank0vld2),
        .rst_l  (~readqbank0vld2reset),
        .en     (rqb0entry2wren),
        .clk    (clk));

dffrle_ns readqbank0vld3flop (
        .din    (1'b1),
        .q      (readqbank0vld3),
        .rst_l  (~readqbank0vld3reset),
        .en     (rqb0entry3wren),
        .clk    (clk));

dffrle_ns readqbank0vld4flop (
        .din    (1'b1),
        .q      (readqbank0vld4),
        .rst_l  (~readqbank0vld4reset),
        .en     (rqb0entry4wren),
        .clk    (clk));

dffrle_ns readqbank0vld5flop (
        .din    (1'b1),
        .q      (readqbank0vld5),
        .rst_l  (~readqbank0vld5reset),
        .en     (rqb0entry5wren),
        .clk    (clk));

dffrle_ns readqbank0vld6flop (
        .din    (1'b1),
        .q      (readqbank0vld6),
        .rst_l  (~readqbank0vld6reset),
        .en     (rqb0entry6wren),
        .clk    (clk));

dffrle_ns readqbank0vld7flop (
        .din    (1'b1),
        .q      (readqbank0vld7),
        .rst_l  (~readqbank0vld7reset),
        .en     (rqb0entry7wren),
        .clk    (clk));

// Address

dffe_ns #(36) 	readqbank0addr0flop (
        .din    (que_rd_addr0[35:0]),
        .q      (readqbank0addr0[35:0]),
        .en     (rqb0entry0wren),
        .clk    (clk));

dffe_ns #(36) 	readqbank0addr1flop (
        .din    (que_rd_addr0[35:0]),
        .q      (readqbank0addr1[35:0]),
        .en     (rqb0entry1wren),
        .clk    (clk));

dffe_ns #(36) 	readqbank0addr2flop (
        .din    (que_rd_addr0[35:0]),
        .q      (readqbank0addr2[35:0]),
        .en     (rqb0entry2wren),
        .clk    (clk));

dffe_ns #(36) 	readqbank0addr3flop (
        .din    (que_rd_addr0[35:0]),
        .q      (readqbank0addr3[35:0]),
        .en     (rqb0entry3wren),
        .clk    (clk));

dffe_ns #(36) readqbank0addr4flop (
        .din    (que_rd_addr0[35:0]),
        .q      (readqbank0addr4[35:0]),
        .en     (rqb0entry4wren),
        .clk    (clk));

dffe_ns #(36) readqbank0addr5flop (
        .din    (que_rd_addr0[35:0]),
        .q      (readqbank0addr5[35:0]),
        .en     (rqb0entry5wren),
        .clk    (clk));

dffe_ns #(36) readqbank0addr6flop (
        .din    (que_rd_addr0[35:0]),
        .q      (readqbank0addr6[35:0]),
        .en     (rqb0entry6wren),
        .clk    (clk));

dffe_ns #(36) readqbank0addr7flop (
        .din    (que_rd_addr0[35:0]),
        .q      (readqbank0addr7[35:0]),
        .en     (rqb0entry7wren),
        .clk    (clk));

// Request ID

dffe_ns  #(3) readqbank0id0flop (
        .din    (que_rd_id0[2:0]),
        .q      (readqbank0id0[2:0]),
        .en     (rqb0entry0wren),
        .clk    (clk));

dffe_ns  #(3) readqbank0id1flop (
        .din    (que_rd_id0[2:0]),
        .q      (readqbank0id1[2:0]),
        .en     (rqb0entry1wren),
        .clk    (clk));

dffe_ns  #(3) readqbank0id2flop (
        .din    (que_rd_id0[2:0]),
        .q      (readqbank0id2[2:0]),
        .en     (rqb0entry2wren),
        .clk    (clk));

dffe_ns  #(3) readqbank0id3flop (
        .din    (que_rd_id0[2:0]),
        .q      (readqbank0id3[2:0]),
        .en     (rqb0entry3wren),
        .clk    (clk));

dffe_ns  #(3) readqbank0id4flop (
        .din    (que_rd_id0[2:0]),
        .q      (readqbank0id4[2:0]),
        .en     (rqb0entry4wren),
        .clk    (clk));

dffe_ns  #(3) readqbank0id5flop (
        .din    (que_rd_id0[2:0]),
        .q      (readqbank0id5[2:0]),
        .en     (rqb0entry5wren),
        .clk    (clk));

dffe_ns  #(3) readqbank0id6flop (
        .din    (que_rd_id0[2:0]),
        .q      (readqbank0id6[2:0]),
        .en     (rqb0entry6wren),
        .clk    (clk));

dffe_ns  #(3) readqbank0id7flop (
        .din    (que_rd_id0[2:0]),
        .q      (readqbank0id7[2:0]),
        .en     (rqb0entry7wren),
        .clk    (clk));

//////////////////////////////////////////////////////////////////
// Writes Requests for bank0 
//////////////////////////////////////////////////////////////////

assign writeqbank0vld0reset_arb = ~rst_l | 
					(({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h8) &  
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign writeqbank0vld1reset_arb = ~rst_l | 
					(({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'h9) &  
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign writeqbank0vld2reset_arb = ~rst_l | 
					(({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'ha) &  
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign writeqbank0vld3reset_arb = ~rst_l | 
					(({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'hb) &  
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign writeqbank0vld4reset_arb = ~rst_l | 
					(({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'hc) &  
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign writeqbank0vld5reset_arb = ~rst_l | 
					(({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'hd) &  
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign writeqbank0vld6reset_arb = ~rst_l | 
					(({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'he) &  
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));
assign writeqbank0vld7reset_arb = ~rst_l | 
					(({que_b0_cmd_picked_d1,que_b0_index_picked_d1} == 4'hf) &  
					~que_scrb_picked_d1 & |que_ras_picked_d1[7:0] &
					(que_channel_picked_internal_d1 == que_channel_disabled));

wire [3:0]	que_int_index01_picked;
wire [3:0]	que_index01_picked;
wire		que_cas_ch01_picked;
wire		que_wr_picked;

assign writeqbank0vld0reset = ~rst_l | ((que_index01_picked == 4'h8) & que_wr_picked &
			~que_bypass_scrb_data & (que_cas_ch01_picked == que_channel_disabled));
assign writeqbank0vld1reset = ~rst_l | ((que_index01_picked == 4'h9) & que_wr_picked &
			~que_bypass_scrb_data & (que_cas_ch01_picked == que_channel_disabled));
assign writeqbank0vld2reset = ~rst_l | ((que_index01_picked == 4'hA) & que_wr_picked &
			~que_bypass_scrb_data & (que_cas_ch01_picked == que_channel_disabled));
assign writeqbank0vld3reset = ~rst_l | ((que_index01_picked == 4'hB) & que_wr_picked &
			~que_bypass_scrb_data & (que_cas_ch01_picked == que_channel_disabled));
assign writeqbank0vld4reset = ~rst_l | ((que_index01_picked == 4'hC) & que_wr_picked &
			~que_bypass_scrb_data & (que_cas_ch01_picked == que_channel_disabled));
assign writeqbank0vld5reset = ~rst_l | ((que_index01_picked == 4'hD) & que_wr_picked &
			~que_bypass_scrb_data & (que_cas_ch01_picked == que_channel_disabled));
assign writeqbank0vld6reset = ~rst_l | ((que_index01_picked == 4'hE) & que_wr_picked &
			~que_bypass_scrb_data & (que_cas_ch01_picked == que_channel_disabled));
assign writeqbank0vld7reset = ~rst_l | ((que_index01_picked == 4'hF) & que_wr_picked &
			~que_bypass_scrb_data & (que_cas_ch01_picked == que_channel_disabled));

// Valids for Arbitration only. There are other valids just for incomming write requests.

dffrle_ns writeqbank0vld0flop_arb (
        .din    (1'b1),
        .q      (writeqbank0vld0_arb),
        .rst_l  (~writeqbank0vld0reset_arb),
        .en     (wqb0entry0wren),
        .clk    (clk));

dffrle_ns writeqbank0vld1flop_arb (
        .din    (1'b1),
        .q      (writeqbank0vld1_arb),
        .rst_l  (~writeqbank0vld1reset_arb),
        .en     (wqb0entry1wren),
        .clk    (clk));

dffrle_ns writeqbank0vld2flop_arb (
        .din    (1'b1),
        .q      (writeqbank0vld2_arb),
        .rst_l  (~writeqbank0vld2reset_arb),
        .en     (wqb0entry2wren),
        .clk    (clk));

dffrle_ns writeqbank0vld3flop_arb (
        .din    (1'b1),
        .q      (writeqbank0vld3_arb),
        .rst_l  (~writeqbank0vld3reset_arb),
        .en     (wqb0entry3wren),
        .clk    (clk));

dffrle_ns writeqbank0vld4flop_arb (
        .din    (1'b1),
        .q      (writeqbank0vld4_arb),
        .rst_l  (~writeqbank0vld4reset_arb),
        .en     (wqb0entry4wren),
        .clk    (clk));

dffrle_ns writeqbank0vld5flop_arb (
        .din    (1'b1),
        .q      (writeqbank0vld5_arb),
        .rst_l  (~writeqbank0vld5reset_arb),
        .en     (wqb0entry5wren),
        .clk    (clk));

dffrle_ns writeqbank0vld6flop_arb (
        .din    (1'b1),
        .q      (writeqbank0vld6_arb),
        .rst_l  (~writeqbank0vld6reset_arb),
        .en     (wqb0entry6wren),
        .clk    (clk));

dffrle_ns writeqbank0vld7flop_arb (
        .din    (1'b1),
        .q      (writeqbank0vld7_arb),
        .rst_l  (~writeqbank0vld7reset_arb),
        .en     (wqb0entry7wren),
        .clk    (clk));

// Valids for new write request allocation only. 

dffrle_ns writeqbank0vld0flop (
        .din    (1'b1),
        .q      (writeqbank0vld0),
        .rst_l  (~writeqbank0vld0reset),
        .en     (wqb0entry0wren),
        .clk    (clk));

dffrle_ns writeqbank0vld1flop (
        .din    (1'b1),
        .q      (writeqbank0vld1),
        .rst_l  (~writeqbank0vld1reset),
        .en     (wqb0entry1wren),
        .clk    (clk));

dffrle_ns writeqbank0vld2flop (
        .din    (1'b1),
        .q      (writeqbank0vld2),
        .rst_l  (~writeqbank0vld2reset),
        .en     (wqb0entry2wren),
        .clk    (clk));

dffrle_ns writeqbank0vld3flop (
        .din    (1'b1),
        .q      (writeqbank0vld3),
        .rst_l  (~writeqbank0vld3reset),
        .en     (wqb0entry3wren),
        .clk    (clk));

dffrle_ns writeqbank0vld4flop (
        .din    (1'b1),
        .q      (writeqbank0vld4),
        .rst_l  (~writeqbank0vld4reset),
        .en     (wqb0entry4wren),
        .clk    (clk));

dffrle_ns writeqbank0vld5flop (
        .din    (1'b1),
        .q      (writeqbank0vld5),
        .rst_l  (~writeqbank0vld5reset),
        .en     (wqb0entry5wren),
        .clk    (clk));

dffrle_ns writeqbank0vld6flop (
        .din    (1'b1),
        .q      (writeqbank0vld6),
        .rst_l  (~writeqbank0vld6reset),
        .en     (wqb0entry6wren),
        .clk    (clk));

dffrle_ns writeqbank0vld7flop (
        .din    (1'b1),
        .q      (writeqbank0vld7),
        .rst_l  (~writeqbank0vld7reset),
        .en     (wqb0entry7wren),
        .clk    (clk));

// Address 

dffe_ns  #(36) writeqbank0entry0flop (
        .din    (que_wr_addr0[35:0]),
        .q      (writeqbank0addr0[35:0]), 
        .en     (wqb0entry0wren),
        .clk    (clk));

dffe_ns  #(36) writeqbank0entry1flop (
        .din    (que_wr_addr0[35:0]),
        .q      (writeqbank0addr1[35:0]),
        .en     (wqb0entry1wren),
        .clk    (clk));

dffe_ns  #(36) writeqbank0entry2flop (
        .din    (que_wr_addr0[35:0]),
        .q      (writeqbank0addr2[35:0]),
        .en     (wqb0entry2wren),
        .clk    (clk));

dffe_ns  #(36) writeqbank0entry3flop (
        .din    (que_wr_addr0[35:0]),
        .q      (writeqbank0addr3[35:0]),
        .en     (wqb0entry3wren),
        .clk    (clk));

dffe_ns  #(36) writeqbank0entry4flop (
        .din    (que_wr_addr0[35:0]),
        .q      (writeqbank0addr4[35:0]),
        .en     (wqb0entry4wren),
        .clk    (clk));

dffe_ns  #(36) writeqbank0entry5flop (
        .din    (que_wr_addr0[35:0]),
        .q      (writeqbank0addr5[35:0]),
        .en     (wqb0entry5wren),
        .clk    (clk));

dffe_ns  #(36) writeqbank0entry6flop (
        .din    (que_wr_addr0[35:0]),
        .q      (writeqbank0addr6[35:0]),
        .en     (wqb0entry6wren),
        .clk    (clk));

dffe_ns  #(36) writeqbank0entry7flop (
        .din    (que_wr_addr0[35:0]),
        .q      (writeqbank0addr7[35:0]),
        .en     (wqb0entry7wren),
        .clk    (clk));

// Data write address
dffe_ns  #(3) writeqentry0flop (
        .din    (que_cpu_wr_addr[2:0]),
        .q      (writeqaddr0[2:0]), 
        .en     (wqb0entry0wren),
        .clk    (clk));

dffe_ns  #(3) writeqentry1flop (
        .din    (que_cpu_wr_addr[2:0]),
        .q      (writeqaddr1[2:0]),
        .en     (wqb0entry1wren),
        .clk    (clk));

dffe_ns  #(3) writeqentry2flop (
        .din    (que_cpu_wr_addr[2:0]),
        .q      (writeqaddr2[2:0]),
        .en     (wqb0entry2wren),
        .clk    (clk));

dffe_ns  #(3) writeqentry3flop (
        .din    (que_cpu_wr_addr[2:0]),
        .q      (writeqaddr3[2:0]),
        .en     (wqb0entry3wren),
        .clk    (clk));

dffe_ns  #(3) writeqentry4flop (
        .din    (que_cpu_wr_addr[2:0]),
        .q      (writeqaddr4[2:0]),
        .en     (wqb0entry4wren),
        .clk    (clk));

dffe_ns  #(3) writeqentry5flop (
        .din    (que_cpu_wr_addr[2:0]),
        .q      (writeqaddr5[2:0]),
        .en     (wqb0entry5wren),
        .clk    (clk));

dffe_ns  #(3) writeqentry6flop (
        .din    (que_cpu_wr_addr[2:0]),
        .q      (writeqaddr6[2:0]),
        .en     (wqb0entry6wren),
        .clk    (clk));

dffe_ns  #(3) writeqentry7flop (
        .din    (que_cpu_wr_addr[2:0]),
        .q      (writeqaddr7[2:0]),
        .en     (wqb0entry7wren),
        .clk    (clk));

//////////////////////////////////////////////////////////////////
// Creating collapsing(??? Do we need it to be) fifo. This contains
// read and write queue id and a valid bit for one bank. This is
// because there could be a reads/write to the diff banks simultaneously.
// Reads are placed into 0-3 of the queue  and writes 4-7.
//////////////////////////////////////////////////////////////////

wire            que_b0_wr_index_en;
wire [8:0]      que_b0_wr_index_ent0;
wire [8:0]	que_b0_wr_index_ent1;
wire [8:0]	que_b0_wr_index_ent2;
wire [8:0]	que_b0_wr_index_ent3;
wire [8:0]      que_b0_wr_index_ent4;
wire [8:0]	que_b0_wr_index_ent5;
wire [8:0]	que_b0_wr_index_ent6;
wire [8:0]	que_b0_wr_index_ent7;
wire		que_ras_bank_picked_en;
wire		que_b0_wr_picked;
wire           	que_b0_index1_en_d1;
wire           	que_b0_index2_en_d1;
wire           	que_b0_index3_en_d1;
wire           	que_b0_index4_en_d1;
wire           	que_b0_index5_en_d1;
wire           	que_b0_index6_en_d1;
wire           	que_b0_index7_en_d1;
wire           	que_b0_wr_index1_en_d1;
wire           	que_b0_wr_index2_en_d1;
wire           	que_b0_wr_index3_en_d1;
wire           	que_b0_wr_index4_en_d1;
wire           	que_b0_wr_index5_en_d1;
wire           	que_b0_wr_index6_en_d1;
wire           	que_b0_wr_index7_en_d1;

reg            	que_b0_index0_en;
reg            	que_b0_index1_en;
reg            	que_b0_index2_en;
reg            	que_b0_index3_en;
reg            	que_b0_index4_en;
reg            	que_b0_index5_en;
reg            	que_b0_index6_en;
reg            	que_b0_index7_en;
reg            	que_b0_wr_index0_en;
reg            	que_b0_wr_index1_en;
reg            	que_b0_wr_index2_en;
reg            	que_b0_wr_index3_en;
reg            	que_b0_wr_index4_en;
reg            	que_b0_wr_index5_en;
reg            	que_b0_wr_index6_en;
reg            	que_b0_wr_index7_en;
reg            	que_b0_index0_val_in;
reg            	que_b0_index1_val_in;
reg            	que_b0_index2_val_in;
reg            	que_b0_index3_val_in;
reg            	que_b0_index4_val_in;
reg            	que_b0_index5_val_in;
reg            	que_b0_index6_val_in;
reg            	que_b0_index7_val_in;
reg            	que_b0_wr_index0_val_in;
reg            	que_b0_wr_index1_val_in;
reg            	que_b0_wr_index2_val_in;
reg            	que_b0_wr_index3_val_in;
reg            	que_b0_wr_index4_val_in;
reg            	que_b0_wr_index5_val_in;
reg            	que_b0_wr_index6_val_in;
reg            	que_b0_wr_index7_val_in;

wire que_this_channel_picked_d1 = (que_channel_picked_internal_d1 == que_channel_disabled);
      
wire que_rd_ras_picked_d1 = ~que_scrb_picked_d1 & (~que_b0_wr_index_pend_d1 & que_b0_rd_picked_d1) &
                        que_this_channel_picked_d1 & (|que_ras_picked_d1[7:0]);

dff_ns  #(2) 	ras_picked_d2 (
        .din    ({que_b0_index_en, que_rd_ras_picked_d1}),
        .q      ({que_b0_index_en_d1, que_rd_ras_picked_d2}),
        .clk    (clk));

// collapsing queue for READS
assign que_b0_rdq_full =  readqbank0vld7 & readqbank0vld6 & readqbank0vld5 & readqbank0vld4 &
			readqbank0vld3 & readqbank0vld2 & readqbank0vld1 & readqbank0vld0;
assign que_b0_rd_index[7:0] = {que_rd_addr0[35], que_rd_addr0[33], que_rd_addr_in[2:0], que_rd_addr0[2:0]};

// set and reset the valids in this queue
assign que_b0_index_en = (que_rd_req & ~que_b0_rdq_full) & ~(que_ras_bank_picked_en & 
			(que_channel_picked_internal == que_channel_disabled) &
			~(que_scrb_picked | que_b0_rd_picked | que_b0_wr_picked) ) ;

always @(/*AUTOSENSE*/que_b0_index1_en_d1 or que_b0_index2_en_d1
	 or que_b0_index3_en_d1 or que_b0_index4_en_d1
	 or que_b0_index5_en_d1 or que_b0_index6_en_d1
	 or que_b0_index7_en_d1 or que_b0_index_en or que_b0_index_en_d1
	 or que_b0_index_ent0 or que_b0_index_ent1
	 or que_b0_index_ent2 or que_b0_index_ent3
	 or que_b0_index_ent4 or que_b0_index_ent5
	 or que_b0_index_ent6 or que_b0_index_ent7
	 or que_b0_indx0_val_d1 or que_b0_indx1_val_d1
	 or que_b0_indx2_val_d1 or que_b0_indx3_val_d1
	 or que_b0_indx4_val_d1 or que_b0_indx5_val_d1
	 or que_b0_indx6_val_d1 or que_b0_indx7_val_d1
	 or que_b0_rd_picked_d1 or que_b0_wr_index_pend_d1
	 or que_ras_picked_d1 or que_scrb_picked_d1
	 or que_this_channel_picked_d1 or que_rd_ras_picked_d2) 
begin
	que_b0_index0_en = 1'h0;
	que_b0_index1_en = 1'h0;
	que_b0_index2_en = 1'h0;
	que_b0_index3_en = 1'h0;
	que_b0_index4_en = 1'h0;
	que_b0_index5_en = 1'h0;
	que_b0_index6_en = 1'h0;
	que_b0_index7_en = 1'h0;
	que_b0_index7_val_in = que_b0_index_ent7[6];
	que_b0_index6_val_in = que_b0_index_ent6[6];
	que_b0_index5_val_in = que_b0_index_ent5[6];
	que_b0_index4_val_in = que_b0_index_ent4[6];
	que_b0_index3_val_in = que_b0_index_ent3[6];
	que_b0_index2_val_in = que_b0_index_ent2[6];
	que_b0_index1_val_in = que_b0_index_ent1[6];
	que_b0_index0_val_in = que_b0_index_ent0[6];

	// If not scrub & its not a write and a read & this channel req
	// got picked in two channel mode & ras_picked is non zero & 
	// (the valids present match to the ras picked or when a new req came in
	//  and pushed the current picked down by one) 

	if(~que_scrb_picked_d1 & (~que_b0_wr_index_pend_d1 & que_b0_rd_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
                        (que_b0_indx7_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_rd_ras_picked_d2 | que_b0_index_en_d1 & que_rd_ras_picked_d2) &
			 que_b0_index7_en_d1 & (que_b0_indx6_val_d1 == que_ras_picked_d1)))
        begin
                que_b0_index7_en = 1'h1;
                que_b0_index7_val_in = 1'h0;
                if(que_b0_index_en) 
                begin
                        que_b0_index7_en = 1'h1;
                        que_b0_index6_en = 1'h1;
                        que_b0_index5_en = 1'h1;
                        que_b0_index4_en = 1'h1;
                        que_b0_index3_en = 1'h1;
                        que_b0_index2_en = 1'h1;
                        que_b0_index1_en = 1'h1;
                        que_b0_index0_en = 1'h1;
                        que_b0_index7_val_in = que_b0_index_ent6[6];
                        que_b0_index6_val_in = que_b0_index_ent5[6];
                        que_b0_index5_val_in = que_b0_index_ent4[6];
                        que_b0_index4_val_in = que_b0_index_ent3[6];
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
                end
        end
	else if(~que_scrb_picked_d1 & (~que_b0_wr_index_pend_d1 & que_b0_rd_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
                        (que_b0_indx6_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_rd_ras_picked_d2 | que_b0_index_en_d1 & que_rd_ras_picked_d2) &
			 que_b0_index6_en_d1 & (que_b0_indx5_val_d1 == que_ras_picked_d1)))
        begin
                que_b0_index6_en = 1'h1;
                que_b0_index6_val_in = 1'h0;
                if(que_b0_index_en) 
                begin
                        que_b0_index6_en = 1'h1;
                        que_b0_index5_en = 1'h1;
                        que_b0_index4_en = 1'h1;
                        que_b0_index3_en = 1'h1;
                        que_b0_index2_en = 1'h1;
                        que_b0_index1_en = 1'h1;
                        que_b0_index0_en = 1'h1;
                        que_b0_index6_val_in = que_b0_index_ent5[6];
                        que_b0_index5_val_in = que_b0_index_ent4[6];
                        que_b0_index4_val_in = que_b0_index_ent3[6];
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
                end     
        end
	else if(~que_scrb_picked_d1 & (~que_b0_wr_index_pend_d1 & que_b0_rd_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
                        (que_b0_indx5_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_rd_ras_picked_d2 | que_b0_index_en_d1 & que_rd_ras_picked_d2) &
			 que_b0_index5_en_d1 & (que_b0_indx4_val_d1 == que_ras_picked_d1)))
        begin
                que_b0_index5_en = 1'h1;
                que_b0_index5_val_in = 1'h0;
                if(que_b0_index_en) 
                begin
                        que_b0_index5_en = 1'h1;
                        que_b0_index4_en = 1'h1;
                        que_b0_index3_en = 1'h1;
                        que_b0_index2_en = 1'h1;
                        que_b0_index1_en = 1'h1;
                        que_b0_index0_en = 1'h1;
                        que_b0_index5_val_in = que_b0_index_ent4[6];
                        que_b0_index4_val_in = que_b0_index_ent3[6];
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
                end     
        end
	else if(~que_scrb_picked_d1 & (~que_b0_wr_index_pend_d1 & que_b0_rd_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
                        (que_b0_indx4_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_rd_ras_picked_d2 | que_b0_index_en_d1 & que_rd_ras_picked_d2) &
			 que_b0_index4_en_d1 & (que_b0_indx3_val_d1 == que_ras_picked_d1)))
        begin
                que_b0_index4_en = 1'h1;
                que_b0_index4_val_in = 1'h0;
                if(que_b0_index_en) 
                begin
                        que_b0_index4_en = 1'h1;
                        que_b0_index3_en = 1'h1;
                        que_b0_index2_en = 1'h1;
                        que_b0_index1_en = 1'h1;
                        que_b0_index0_en = 1'h1;
                        que_b0_index4_val_in = que_b0_index_ent3[6];
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
                end     
        end
	else if(~que_scrb_picked_d1 & (~que_b0_wr_index_pend_d1 & que_b0_rd_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
			(que_b0_indx3_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_rd_ras_picked_d2 | que_b0_index_en_d1 & que_rd_ras_picked_d2) &
			 que_b0_index3_en_d1 & (que_b0_indx2_val_d1 == que_ras_picked_d1)))
	begin
		que_b0_index3_en = 1'h1;
		que_b0_index3_val_in = 1'h0;
		if(que_b0_index_en) 
		begin
			que_b0_index3_en = 1'h1;
			que_b0_index2_en = 1'h1;
			que_b0_index1_en = 1'h1;
			que_b0_index0_en = 1'h1;
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
		end
	end
	else if(~que_scrb_picked_d1 & (~que_b0_wr_index_pend_d1 & que_b0_rd_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
			(que_b0_indx2_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_rd_ras_picked_d2 | que_b0_index_en_d1 & que_rd_ras_picked_d2) &
			 que_b0_index2_en_d1 & (que_b0_indx1_val_d1 == que_ras_picked_d1)))
        begin
		que_b0_index2_en = 1'h1;
		que_b0_index2_val_in = 1'h0;
		if(que_b0_index_en) 
		begin
			que_b0_index2_en = 1'h1;
			que_b0_index1_en = 1'h1;
			que_b0_index0_en = 1'h1;
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
		end
        end
	else if(~que_scrb_picked_d1 & (~que_b0_wr_index_pend_d1 & que_b0_rd_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
			(que_b0_indx1_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_rd_ras_picked_d2 | que_b0_index_en_d1 & que_rd_ras_picked_d2) &
			 que_b0_index1_en_d1 & (que_b0_indx0_val_d1 == que_ras_picked_d1)))
        begin
		que_b0_index1_en = 1'h1;
		que_b0_index1_val_in = 1'h0;
		if(que_b0_index_en) 
		begin
			que_b0_index1_en = 1'h1;
			que_b0_index0_en = 1'h1;
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
		end
        end
	else if(~que_scrb_picked_d1 & (~que_b0_wr_index_pend_d1 & que_b0_rd_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
			(que_b0_indx0_val_d1[7:0] == que_ras_picked_d1[7:0])) 
        begin
		que_b0_index0_en = 1'h1;
		que_b0_index0_val_in = 1'h0;
		if(que_b0_index_en) 
		begin
			que_b0_index0_en = 1'h1;
                        que_b0_index0_val_in = 1'h1;
		end
        end
	else if(que_b0_index_en) 
	begin
		if(~que_b0_index_ent7[6])
                begin
                        que_b0_index7_en = 1'h1;
                        que_b0_index6_en = 1'h1;
                        que_b0_index5_en = 1'h1;
                        que_b0_index4_en = 1'h1;
                        que_b0_index3_en = 1'h1;
                        que_b0_index2_en = 1'h1;
                        que_b0_index1_en = 1'h1;
                        que_b0_index0_en = 1'h1;
                        que_b0_index7_val_in = que_b0_index_ent6[6];
                        que_b0_index6_val_in = que_b0_index_ent5[6];
                        que_b0_index5_val_in = que_b0_index_ent4[6];
                        que_b0_index4_val_in = que_b0_index_ent3[6];
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
                end
		if(~que_b0_index_ent6[6])
                begin
                        que_b0_index6_en = 1'h1;
                        que_b0_index5_en = 1'h1;
                        que_b0_index4_en = 1'h1;
                        que_b0_index3_en = 1'h1;
                        que_b0_index2_en = 1'h1;
                        que_b0_index1_en = 1'h1;
                        que_b0_index0_en = 1'h1;
                        que_b0_index6_val_in = que_b0_index_ent5[6];
                        que_b0_index5_val_in = que_b0_index_ent4[6];
                        que_b0_index4_val_in = que_b0_index_ent3[6];
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
                end
		if(~que_b0_index_ent5[6])
                begin
                        que_b0_index5_en = 1'h1;
                        que_b0_index4_en = 1'h1;
                        que_b0_index3_en = 1'h1;
                        que_b0_index2_en = 1'h1;
                        que_b0_index1_en = 1'h1;
                        que_b0_index0_en = 1'h1;
                        que_b0_index5_val_in = que_b0_index_ent4[6];
                        que_b0_index4_val_in = que_b0_index_ent3[6];
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
                end
		if(~que_b0_index_ent4[6])
                begin
                        que_b0_index4_en = 1'h1;
                        que_b0_index3_en = 1'h1;
                        que_b0_index2_en = 1'h1;
                        que_b0_index1_en = 1'h1;
                        que_b0_index0_en = 1'h1;
                        que_b0_index4_val_in = que_b0_index_ent3[6];
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
                end
		if(~que_b0_index_ent3[6]) 
		begin
			que_b0_index3_en = 1'h1;
			que_b0_index2_en = 1'h1;
			que_b0_index1_en = 1'h1;
			que_b0_index0_en = 1'h1;
                        que_b0_index3_val_in = que_b0_index_ent2[6];
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
		end
		if(~que_b0_index_ent2[6]) 
		begin
			que_b0_index2_en = 1'h1;
			que_b0_index1_en = 1'h1;
			que_b0_index0_en = 1'h1;
                        que_b0_index2_val_in = que_b0_index_ent1[6];
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
		end
		if(~que_b0_index_ent1[6]) 
		begin
			que_b0_index1_en = 1'h1;
			que_b0_index0_en = 1'h1;
                        que_b0_index1_val_in = que_b0_index_ent0[6];
                        que_b0_index0_val_in = 1'h1;
		end
		if(~que_b0_index_ent0[6]) 
		begin
			que_b0_index0_en = 1'h1;
                        que_b0_index0_val_in = 1'h1;
		end
			
	end
end

dffrle_ns #(1) b0_collapse_fifo_ent0_val(
        .din(que_b0_index0_val_in),
        .q(que_b0_index_ent0[6]),
	.rst_l(rst_l),
        .en(que_b0_index0_en),
        .clk(clk));

dffrle_ns #(1) b0_collapse_fifo_ent1_val(
        .din(que_b0_index1_val_in),
        .q(que_b0_index_ent1[6]),
	.rst_l(rst_l),
        .en(que_b0_index1_en),
        .clk(clk));

dffrle_ns #(1) b0_collapse_fifo_ent2_val(
        .din(que_b0_index2_val_in),
        .q(que_b0_index_ent2[6]),
	.rst_l(rst_l),
        .en(que_b0_index2_en),
        .clk(clk));

dffrle_ns #(1) b0_collapse_fifo_ent3_val(
        .din(que_b0_index3_val_in),
        .q(que_b0_index_ent3[6]),
	.rst_l(rst_l),
        .en(que_b0_index3_en),
        .clk(clk));

dffrle_ns #(1) b0_collapse_fifo_ent4_val(
        .din(que_b0_index4_val_in),
        .q(que_b0_index_ent4[6]),
        .rst_l(rst_l),
        .en(que_b0_index4_en),
        .clk(clk));

dffrle_ns #(1) b0_collapse_fifo_ent5_val(
        .din(que_b0_index5_val_in),
        .q(que_b0_index_ent5[6]),
        .rst_l(rst_l),
        .en(que_b0_index5_en),
        .clk(clk));

dffrle_ns #(1) b0_collapse_fifo_ent6_val(
        .din(que_b0_index6_val_in),
        .q(que_b0_index_ent6[6]),
        .rst_l(rst_l),
        .en(que_b0_index6_en),
        .clk(clk));

dffrle_ns #(1) b0_collapse_fifo_ent7_val(
        .din(que_b0_index7_val_in),
        .q(que_b0_index_ent7[6]),
        .rst_l(rst_l),
        .en(que_b0_index7_en),
        .clk(clk));

dffrle_ns #(8) b0_collapse_fifo_ent0(
        .din(que_b0_rd_index[7:0]),
        .q({que_b0_index_ent0[8:7], que_b0_index_ent0[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_index0_en),
        .clk(clk));

dffrle_ns #(8) b0_collapse_fifo_ent1(
        .din({que_b0_index_ent0[8:7], que_b0_index_ent0[5:0]}),
        .q({que_b0_index_ent1[8:7], que_b0_index_ent1[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_index1_en),
        .clk(clk));

dffrle_ns #(8) b0_collapse_fifo_ent2(
        .din({que_b0_index_ent1[8:7], que_b0_index_ent1[5:0]}),
        .q({que_b0_index_ent2[8:7], que_b0_index_ent2[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_index2_en),
        .clk(clk));

dffrle_ns #(8) b0_collapse_fifo_ent3(
        .din({que_b0_index_ent2[8:7], que_b0_index_ent2[5:0]}),
        .q({que_b0_index_ent3[8:7], que_b0_index_ent3[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_index3_en),
        .clk(clk));

dffrle_ns #(8) b0_collapse_fifo_ent4(
        .din({que_b0_index_ent3[8:7], que_b0_index_ent3[5:0]}),
        .q({que_b0_index_ent4[8:7], que_b0_index_ent4[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_index4_en),
        .clk(clk));

dffrle_ns #(8) b0_collapse_fifo_ent5(
        .din({que_b0_index_ent4[8:7], que_b0_index_ent4[5:0]}),
        .q({que_b0_index_ent5[8:7], que_b0_index_ent5[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_index5_en),
        .clk(clk));

dffrle_ns #(8) b0_collapse_fifo_ent6(
        .din({que_b0_index_ent5[8:7], que_b0_index_ent5[5:0]}),
        .q({que_b0_index_ent6[8:7], que_b0_index_ent6[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_index6_en),
        .clk(clk));

dffrle_ns #(8) b0_collapse_fifo_ent7(
        .din({que_b0_index_ent6[8:7], que_b0_index_ent6[5:0]}),
        .q({que_b0_index_ent7[8:7], que_b0_index_ent7[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_index7_en),
        .clk(clk));

dff_ns #(2)     ff_rd_index0_en(
        .din({que_b0_index1_en, que_b0_index2_en}),
        .q({que_b0_index1_en_d1, que_b0_index2_en_d1}),
        .clk(clk));

dff_ns #(3)     ff_rd_index3_en(
        .din({que_b0_index3_en, que_b0_index4_en, que_b0_index5_en}),
        .q({que_b0_index3_en_d1, que_b0_index4_en_d1, que_b0_index5_en_d1}),
        .clk(clk));

dff_ns #(2)     ff_rd_index6_en(
        .din({que_b0_index6_en, que_b0_index7_en}),
        .q({que_b0_index6_en_d1, que_b0_index7_en_d1}),
        .clk(clk));

////////////////
// Collapsing FIFO for WRITES
////////////////

assign que_b0_wrq_full =  writeqbank0vld7 & writeqbank0vld6 & writeqbank0vld5 & writeqbank0vld4 &
			writeqbank0vld3 & writeqbank0vld2 & writeqbank0vld1 & writeqbank0vld0;
assign que_b0_wr_index[7:0] = {que_wr_addr0[35], que_wr_addr0[33], que_wr_addr_b0[2:0], que_wr_addr0[2:0]};

// set and reset the valids in this queue
assign que_b0_wr_index_en = que_wr_req & ~que_wr_addr0[32] & ~que_b0_wrq_full; 

// Stage these so that reset happens 1 cycle later then the request got picked
dff_ns  #(1) ff_wr_index_en (
        .din    (que_b0_wr_picked),
        .q    	(que_b0_wr_picked_d1),
        .clk    (clk));

wire que_wr_ras_picked_d1 = ~que_scrb_picked_d1 &                                                
                        (que_b0_wr_index_pend_d1 | ~que_b0_rd_picked_d1 & que_b0_wr_picked_d1) &
                        que_this_channel_picked_d1 & (|que_ras_picked_d1);

dff_ns  #(2) 	wr_ras_picked_d2 (
        .din    ({que_b0_wr_index_en, que_wr_ras_picked_d1}),
        .q      ({que_b0_wr_index_en_d1, que_wr_ras_picked_d2}),
        .clk    (clk));

always @(/*AUTOSENSE*/que_b0_rd_picked_d1 or que_b0_wr_index1_en_d1
	 or que_b0_wr_index2_en_d1 or que_b0_wr_index3_en_d1
	 or que_b0_wr_index4_en_d1 or que_b0_wr_index5_en_d1
	 or que_b0_wr_index6_en_d1 or que_b0_wr_index7_en_d1
	 or que_b0_wr_index_en or que_b0_wr_index_ent0
	 or que_b0_wr_index_ent1 or que_b0_wr_index_ent2
	 or que_b0_wr_index_ent3 or que_b0_wr_index_ent4
	 or que_b0_wr_index_ent5 or que_b0_wr_index_ent6
	 or que_b0_wr_index_ent7 or que_b0_wr_index_pend_d1
	 or que_b0_wr_indx0_val_d1 or que_b0_wr_indx1_val_d1
	 or que_b0_wr_indx2_val_d1 or que_b0_wr_indx3_val_d1
	 or que_b0_wr_indx4_val_d1 or que_b0_wr_indx5_val_d1
	 or que_b0_wr_indx6_val_d1 or que_b0_wr_indx7_val_d1
	 or que_b0_wr_picked_d1 or que_ras_picked_d1
	 or que_scrb_picked_d1 or que_this_channel_picked_d1
	 or que_b0_wr_index_en_d1 or que_wr_ras_picked_d2) 
begin
	que_b0_wr_index0_en = 1'h0;
	que_b0_wr_index1_en = 1'h0;
	que_b0_wr_index2_en = 1'h0;
	que_b0_wr_index3_en = 1'h0;
	que_b0_wr_index4_en = 1'h0;
	que_b0_wr_index5_en = 1'h0;
	que_b0_wr_index6_en = 1'h0;
	que_b0_wr_index7_en = 1'h0;
	que_b0_wr_index7_val_in = que_b0_wr_index_ent7[6];
	que_b0_wr_index6_val_in = que_b0_wr_index_ent6[6];
	que_b0_wr_index5_val_in = que_b0_wr_index_ent5[6];
	que_b0_wr_index4_val_in = que_b0_wr_index_ent4[6];
	que_b0_wr_index3_val_in = que_b0_wr_index_ent3[6];
	que_b0_wr_index2_val_in = que_b0_wr_index_ent2[6];
	que_b0_wr_index1_val_in = que_b0_wr_index_ent1[6];
	que_b0_wr_index0_val_in = que_b0_wr_index_ent0[6];

	// If not scrub & (load depend st pending or its a write and not read) &
	// this ch req got picked in two channel mode & ras_picked is non zero & 
	// (the valids present match to the ras picked or when a new req came in
	//  and pushed the current picked down by one) 
	if(~que_scrb_picked_d1 &
			(que_b0_wr_index_pend_d1 | ~que_b0_rd_picked_d1 & que_b0_wr_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
                        (que_b0_wr_indx7_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_wr_ras_picked_d2 | que_b0_wr_index_en_d1 & que_wr_ras_picked_d2) &
			que_b0_wr_index7_en_d1 & (que_b0_wr_indx6_val_d1 == que_ras_picked_d1)))
        begin
                que_b0_wr_index7_en = 1'h1;
                que_b0_wr_index7_val_in = 1'h0;
                if(que_b0_wr_index_en) 
                begin
                        que_b0_wr_index7_en = 1'h1;
                        que_b0_wr_index6_en = 1'h1;
                        que_b0_wr_index5_en = 1'h1;
                        que_b0_wr_index4_en = 1'h1;
                        que_b0_wr_index3_en = 1'h1;
                        que_b0_wr_index2_en = 1'h1;
                        que_b0_wr_index1_en = 1'h1;
                        que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index7_val_in = que_b0_wr_index_ent6[6];
                        que_b0_wr_index6_val_in = que_b0_wr_index_ent5[6];
                        que_b0_wr_index5_val_in = que_b0_wr_index_ent4[6];
                        que_b0_wr_index4_val_in = que_b0_wr_index_ent3[6];
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
                end
        end
	else if(~que_scrb_picked_d1 &
			(que_b0_wr_index_pend_d1 | ~que_b0_rd_picked_d1 & que_b0_wr_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
                        (que_b0_wr_indx6_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_wr_ras_picked_d2 | que_b0_wr_index_en_d1 & que_wr_ras_picked_d2) &
			que_b0_wr_index6_en_d1 & (que_b0_wr_indx5_val_d1 == que_ras_picked_d1)))
        begin
                que_b0_wr_index6_en = 1'h1;
                que_b0_wr_index6_val_in = 1'h0;
                if(que_b0_wr_index_en) 
                begin
                        que_b0_wr_index6_en = 1'h1;
                        que_b0_wr_index5_en = 1'h1;
                        que_b0_wr_index4_en = 1'h1;
                        que_b0_wr_index3_en = 1'h1;
                        que_b0_wr_index2_en = 1'h1;
                        que_b0_wr_index1_en = 1'h1;
                        que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index6_val_in = que_b0_wr_index_ent5[6];
                        que_b0_wr_index5_val_in = que_b0_wr_index_ent4[6];
                        que_b0_wr_index4_val_in = que_b0_wr_index_ent3[6];
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
                end     
        end
	else if(~que_scrb_picked_d1 &
			(que_b0_wr_index_pend_d1 | ~que_b0_rd_picked_d1 & que_b0_wr_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
                        (que_b0_wr_indx5_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_wr_ras_picked_d2 | que_b0_wr_index_en_d1 & que_wr_ras_picked_d2) &
			que_b0_wr_index5_en_d1 & (que_b0_wr_indx4_val_d1 == que_ras_picked_d1)))
        begin
                que_b0_wr_index5_en = 1'h1;
                que_b0_wr_index5_val_in = 1'h0;
                if(que_b0_wr_index_en) 
                begin
                        que_b0_wr_index5_en = 1'h1;
                        que_b0_wr_index4_en = 1'h1;
                        que_b0_wr_index3_en = 1'h1;
                        que_b0_wr_index2_en = 1'h1;
                        que_b0_wr_index1_en = 1'h1;
                        que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index5_val_in = que_b0_wr_index_ent4[6];
                        que_b0_wr_index4_val_in = que_b0_wr_index_ent3[6];
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
                end     
        end
	else if(~que_scrb_picked_d1 &
			(que_b0_wr_index_pend_d1 | ~que_b0_rd_picked_d1 & que_b0_wr_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
                        (que_b0_wr_indx4_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_wr_ras_picked_d2 | que_b0_wr_index_en_d1 & que_wr_ras_picked_d2) &
			que_b0_wr_index4_en_d1 & (que_b0_wr_indx3_val_d1 == que_ras_picked_d1)))
        begin
                que_b0_wr_index4_en = 1'h1;
                que_b0_wr_index4_val_in = 1'h0;
                if(que_b0_wr_index_en) 
                begin
                        que_b0_wr_index4_en = 1'h1;
                        que_b0_wr_index3_en = 1'h1;
                        que_b0_wr_index2_en = 1'h1;
                        que_b0_wr_index1_en = 1'h1;
                        que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index4_val_in = que_b0_wr_index_ent3[6];
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
                end     
        end
	else if(~que_scrb_picked_d1 &
			(que_b0_wr_index_pend_d1 | ~que_b0_rd_picked_d1 & que_b0_wr_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
			(que_b0_wr_indx3_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_wr_ras_picked_d2 | que_b0_wr_index_en_d1 & que_wr_ras_picked_d2) &
			que_b0_wr_index3_en_d1 & (que_b0_wr_indx2_val_d1 == que_ras_picked_d1)))
	begin
		que_b0_wr_index3_en = 1'h1;
		que_b0_wr_index3_val_in = 1'h0;
		if(que_b0_wr_index_en) 
		begin
			que_b0_wr_index3_en = 1'h1;
			que_b0_wr_index2_en = 1'h1;
			que_b0_wr_index1_en = 1'h1;
			que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
		end
	end
	else if(~que_scrb_picked_d1 &
			(que_b0_wr_index_pend_d1 | ~que_b0_rd_picked_d1 & que_b0_wr_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
			(que_b0_wr_indx2_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_wr_ras_picked_d2 | que_b0_wr_index_en_d1 & que_wr_ras_picked_d2) &
			que_b0_wr_index2_en_d1 & (que_b0_wr_indx1_val_d1 == que_ras_picked_d1)))
        begin
		que_b0_wr_index2_en = 1'h1;
		que_b0_wr_index2_val_in = 1'h0;
		if(que_b0_wr_index_en) 
		begin
			que_b0_wr_index2_en = 1'h1;
			que_b0_wr_index1_en = 1'h1;
			que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
		end
        end
	else if(~que_scrb_picked_d1 & 
			(que_b0_wr_index_pend_d1 | ~que_b0_rd_picked_d1 & que_b0_wr_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
			(que_b0_wr_indx1_val_d1[7:0] == que_ras_picked_d1[7:0] |
			(~que_wr_ras_picked_d2 | que_b0_wr_index_en_d1 & que_wr_ras_picked_d2) &
			que_b0_wr_index1_en_d1 & (que_b0_wr_indx0_val_d1 == que_ras_picked_d1)))
        begin
		que_b0_wr_index1_en = 1'h1;
		que_b0_wr_index1_val_in = 1'h0;
		if(que_b0_wr_index_en) 
		begin
			que_b0_wr_index1_en = 1'h1;
			que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
		end
        end
	else if(~que_scrb_picked_d1 & 
			(que_b0_wr_index_pend_d1 | ~que_b0_rd_picked_d1 & que_b0_wr_picked_d1) & 
			que_this_channel_picked_d1 & (|que_ras_picked_d1) &
			(que_b0_wr_indx0_val_d1[7:0] == que_ras_picked_d1[7:0])) 
        begin
		que_b0_wr_index0_en = 1'h1;
		que_b0_wr_index0_val_in = 1'h0;
		if(que_b0_wr_index_en) 
		begin
			que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index0_val_in = 1'h1;
		end
        end
	else if(que_b0_wr_index_en) 
	begin
		if(~que_b0_wr_index_ent7[6])
                begin
                        que_b0_wr_index7_en = 1'h1;
                        que_b0_wr_index6_en = 1'h1;
                        que_b0_wr_index5_en = 1'h1;
                        que_b0_wr_index4_en = 1'h1;
                        que_b0_wr_index3_en = 1'h1;
                        que_b0_wr_index2_en = 1'h1;
                        que_b0_wr_index1_en = 1'h1;
                        que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index7_val_in = que_b0_wr_index_ent6[6];
                        que_b0_wr_index6_val_in = que_b0_wr_index_ent5[6];
                        que_b0_wr_index5_val_in = que_b0_wr_index_ent4[6];
                        que_b0_wr_index4_val_in = que_b0_wr_index_ent3[6];
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
                end
		if(~que_b0_wr_index_ent6[6])
                begin
                        que_b0_wr_index6_en = 1'h1;
                        que_b0_wr_index5_en = 1'h1;
                        que_b0_wr_index4_en = 1'h1;
                        que_b0_wr_index3_en = 1'h1;
                        que_b0_wr_index2_en = 1'h1;
                        que_b0_wr_index1_en = 1'h1;
                        que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index6_val_in = que_b0_wr_index_ent5[6];
                        que_b0_wr_index5_val_in = que_b0_wr_index_ent4[6];
                        que_b0_wr_index4_val_in = que_b0_wr_index_ent3[6];
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
                end
		if(~que_b0_wr_index_ent5[6])
                begin
                        que_b0_wr_index5_en = 1'h1;
                        que_b0_wr_index4_en = 1'h1;
                        que_b0_wr_index3_en = 1'h1;
                        que_b0_wr_index2_en = 1'h1;
                        que_b0_wr_index1_en = 1'h1;
                        que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index5_val_in = que_b0_wr_index_ent4[6];
                        que_b0_wr_index4_val_in = que_b0_wr_index_ent3[6];
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
                end
		if(~que_b0_wr_index_ent4[6])
                begin
                        que_b0_wr_index4_en = 1'h1;
                        que_b0_wr_index3_en = 1'h1;
                        que_b0_wr_index2_en = 1'h1;
                        que_b0_wr_index1_en = 1'h1;
                        que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index4_val_in = que_b0_wr_index_ent3[6];
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
                end
		if(~que_b0_wr_index_ent3[6]) 
		begin
			que_b0_wr_index3_en = 1'h1;
			que_b0_wr_index2_en = 1'h1;
			que_b0_wr_index1_en = 1'h1;
			que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index3_val_in = que_b0_wr_index_ent2[6];
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
		end
		if(~que_b0_wr_index_ent2[6]) 
		begin
			que_b0_wr_index2_en = 1'h1;
			que_b0_wr_index1_en = 1'h1;
			que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index2_val_in = que_b0_wr_index_ent1[6];
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
		end
		if(~que_b0_wr_index_ent1[6]) 
		begin
			que_b0_wr_index1_en = 1'h1;
			que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index1_val_in = que_b0_wr_index_ent0[6];
                        que_b0_wr_index0_val_in = 1'h1;
		end
		if(~que_b0_wr_index_ent0[6]) 
		begin
			que_b0_wr_index0_en = 1'h1;
                        que_b0_wr_index0_val_in = 1'h1;
		end
			
	end
end

dffrle_ns #(1) b0_wr_collapse_fifo_ent0_val(
        .din(que_b0_wr_index0_val_in),
        .q(que_b0_wr_index_ent0[6]),
	.rst_l(rst_l),
        .en(que_b0_wr_index0_en),
        .clk(clk));

dffrle_ns #(1) b0_wr_collapse_fifo_ent1_val(
        .din(que_b0_wr_index1_val_in),
        .q(que_b0_wr_index_ent1[6]),
	.rst_l(rst_l),
        .en(que_b0_wr_index1_en),
        .clk(clk));

dffrle_ns #(1) b0_wr_collapse_fifo_ent2_val(
        .din(que_b0_wr_index2_val_in),
        .q(que_b0_wr_index_ent2[6]),
	.rst_l(rst_l),
        .en(que_b0_wr_index2_en),
        .clk(clk));

dffrle_ns #(1) b0_wr_collapse_fifo_ent3_val(
        .din(que_b0_wr_index3_val_in),
        .q(que_b0_wr_index_ent3[6]),
	.rst_l(rst_l),
        .en(que_b0_wr_index3_en),
        .clk(clk));

dffrle_ns #(1) b0_wr_collapse_fifo_ent4_val(
        .din(que_b0_wr_index4_val_in),
        .q(que_b0_wr_index_ent4[6]),
        .rst_l(rst_l),
        .en(que_b0_wr_index4_en),
        .clk(clk));

dffrle_ns #(1) b0_wr_collapse_fifo_ent5_val(
        .din(que_b0_wr_index5_val_in),
        .q(que_b0_wr_index_ent5[6]),
        .rst_l(rst_l),
        .en(que_b0_wr_index5_en),
        .clk(clk));

dffrle_ns #(1) b0_wr_collapse_fifo_ent6_val(
        .din(que_b0_wr_index6_val_in),
        .q(que_b0_wr_index_ent6[6]),
        .rst_l(rst_l),
        .en(que_b0_wr_index6_en),
        .clk(clk));

dffrle_ns #(1) b0_wr_collapse_fifo_ent7_val(
        .din(que_b0_wr_index7_val_in),
        .q(que_b0_wr_index_ent7[6]),
        .rst_l(rst_l),
        .en(que_b0_wr_index7_en),
        .clk(clk));

dffrle_ns #(8) b0_wr_collapse_fifo_ent0(
        .din(que_b0_wr_index[7:0]),
        .q({que_b0_wr_index_ent0[8:7], que_b0_wr_index_ent0[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_wr_index0_en),
        .clk(clk));

dffrle_ns #(8) b0_wr_collapse_fifo_ent1(
        .din({que_b0_wr_index_ent0[8:7], que_b0_wr_index_ent0[5:0]}),
        .q({que_b0_wr_index_ent1[8:7], que_b0_wr_index_ent1[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_wr_index1_en),
        .clk(clk));

dffrle_ns #(8) b0_wr_collapse_fifo_ent2(
        .din({que_b0_wr_index_ent1[8:7], que_b0_wr_index_ent1[5:0]}),
        .q({que_b0_wr_index_ent2[8:7], que_b0_wr_index_ent2[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_wr_index2_en),
        .clk(clk));

dffrle_ns #(8) b0_wr_collapse_fifo_ent3(
        .din({que_b0_wr_index_ent2[8:7], que_b0_wr_index_ent2[5:0]}),
        .q({que_b0_wr_index_ent3[8:7], que_b0_wr_index_ent3[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_wr_index3_en),
        .clk(clk));

dffrle_ns #(8) b0_wr_collapse_fifo_ent4(
        .din({que_b0_wr_index_ent3[8:7], que_b0_wr_index_ent3[5:0]}),
        .q({que_b0_wr_index_ent4[8:7], que_b0_wr_index_ent4[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_wr_index4_en),
        .clk(clk));

dffrle_ns #(8) b0_wr_collapse_fifo_ent5(
        .din({que_b0_wr_index_ent4[8:7], que_b0_wr_index_ent4[5:0]}),
        .q({que_b0_wr_index_ent5[8:7], que_b0_wr_index_ent5[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_wr_index5_en),
        .clk(clk));

dffrle_ns #(8) b0_wr_collapse_fifo_ent6(
        .din({que_b0_wr_index_ent5[8:7], que_b0_wr_index_ent5[5:0]}),
        .q({que_b0_wr_index_ent6[8:7], que_b0_wr_index_ent6[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_wr_index6_en),
        .clk(clk));

dffrle_ns #(8) b0_wr_collapse_fifo_ent7(
        .din({que_b0_wr_index_ent6[8:7], que_b0_wr_index_ent6[5:0]}),
        .q({que_b0_wr_index_ent7[8:7], que_b0_wr_index_ent7[5:0]}),
        .rst_l(rst_l),
        .en(que_b0_wr_index7_en),
        .clk(clk));

dff_ns #(2)	ff_wr_index0_en(
        .din({que_b0_wr_index1_en, que_b0_wr_index2_en}),
        .q({que_b0_wr_index1_en_d1, que_b0_wr_index2_en_d1}),
        .clk(clk));

dff_ns #(3)	ff_wr_index3_en(
        .din({que_b0_wr_index3_en, que_b0_wr_index4_en, que_b0_wr_index5_en}),
        .q({que_b0_wr_index3_en_d1, que_b0_wr_index4_en_d1, que_b0_wr_index5_en_d1}),
        .clk(clk));

dff_ns #(2)	ff_wr_index6_en(
        .din({que_b0_wr_index6_en, que_b0_wr_index7_en}),
        .q({que_b0_wr_index6_en_d1, que_b0_wr_index7_en_d1}),
        .clk(clk));

//////////////////////////////////////////////////////////////////
// Assign bank valids for the scheduler
//////////////////////////////////////////////////////////////////

assign que_b0_banksel_addr0_dec[7:0] = { (que_b0_index_ent0[2:0] == 3'h7), 
                                        	(que_b0_index_ent0[2:0] == 3'h6),
                                        	(que_b0_index_ent0[2:0] == 3'h5),
                                        	(que_b0_index_ent0[2:0] == 3'h4),
                                        	(que_b0_index_ent0[2:0] == 3'h3),
                                        	(que_b0_index_ent0[2:0] == 3'h2),
                                        	(que_b0_index_ent0[2:0] == 3'h1), 
						(que_b0_index_ent0[2:0] == 3'h0) };

assign que_b0_banksel_addr1_dec[7:0] = { (que_b0_index_ent1[2:0] == 3'h7), 
                                        	(que_b0_index_ent1[2:0] == 3'h6),
                                        	(que_b0_index_ent1[2:0] == 3'h5),
                                        	(que_b0_index_ent1[2:0] == 3'h4),
                                        	(que_b0_index_ent1[2:0] == 3'h3),
                                        	(que_b0_index_ent1[2:0] == 3'h2),
                                        	(que_b0_index_ent1[2:0] == 3'h1), 
						(que_b0_index_ent1[2:0] == 3'h0) };

assign que_b0_banksel_addr2_dec[7:0] = { (que_b0_index_ent2[2:0] == 3'h7), 
                                        	(que_b0_index_ent2[2:0] == 3'h6),
                                        	(que_b0_index_ent2[2:0] == 3'h5),
                                        	(que_b0_index_ent2[2:0] == 3'h4),
                                        	(que_b0_index_ent2[2:0] == 3'h3),
                                        	(que_b0_index_ent2[2:0] == 3'h2),
                                        	(que_b0_index_ent2[2:0] == 3'h1), 
						(que_b0_index_ent2[2:0] == 3'h0) };

assign que_b0_banksel_addr3_dec[7:0] = { (que_b0_index_ent3[2:0] == 3'h7), 
                                        	(que_b0_index_ent3[2:0] == 3'h6),
                                        	(que_b0_index_ent3[2:0] == 3'h5),
                                        	(que_b0_index_ent3[2:0] == 3'h4),
                                        	(que_b0_index_ent3[2:0] == 3'h3),
                                        	(que_b0_index_ent3[2:0] == 3'h2),
                                        	(que_b0_index_ent3[2:0] == 3'h1), 
						(que_b0_index_ent3[2:0] == 3'h0) };

assign que_b0_banksel_addr4_dec[7:0] = { (que_b0_index_ent4[2:0] == 3'h7), 
                                        	(que_b0_index_ent4[2:0] == 3'h6),
                                        	(que_b0_index_ent4[2:0] == 3'h5),
                                        	(que_b0_index_ent4[2:0] == 3'h4),
                                        	(que_b0_index_ent4[2:0] == 3'h3),
                                        	(que_b0_index_ent4[2:0] == 3'h2),
                                        	(que_b0_index_ent4[2:0] == 3'h1), 
						(que_b0_index_ent4[2:0] == 3'h0) };

assign que_b0_banksel_addr5_dec[7:0] = { (que_b0_index_ent5[2:0] == 3'h7), 
                                        	(que_b0_index_ent5[2:0] == 3'h6),
                                        	(que_b0_index_ent5[2:0] == 3'h5),
                                        	(que_b0_index_ent5[2:0] == 3'h4),
                                        	(que_b0_index_ent5[2:0] == 3'h3),
                                        	(que_b0_index_ent5[2:0] == 3'h2),
                                        	(que_b0_index_ent5[2:0] == 3'h1), 
						(que_b0_index_ent5[2:0] == 3'h0) };

assign que_b0_banksel_addr6_dec[7:0] = { (que_b0_index_ent6[2:0] == 3'h7), 
                                        	(que_b0_index_ent6[2:0] == 3'h6),
                                        	(que_b0_index_ent6[2:0] == 3'h5),
                                        	(que_b0_index_ent6[2:0] == 3'h4),
                                        	(que_b0_index_ent6[2:0] == 3'h3),
                                        	(que_b0_index_ent6[2:0] == 3'h2),
                                        	(que_b0_index_ent6[2:0] == 3'h1), 
						(que_b0_index_ent6[2:0] == 3'h0) };

assign que_b0_banksel_addr7_dec[7:0] = { (que_b0_index_ent7[2:0] == 3'h7), 
                                        	(que_b0_index_ent7[2:0] == 3'h6),
                                        	(que_b0_index_ent7[2:0] == 3'h5),
                                        	(que_b0_index_ent7[2:0] == 3'h4),
                                        	(que_b0_index_ent7[2:0] == 3'h3),
                                        	(que_b0_index_ent7[2:0] == 3'h2),
                                        	(que_b0_index_ent7[2:0] == 3'h1), 
						(que_b0_index_ent7[2:0] == 3'h0) };

// WRITE bank valids for scheduler

assign que_b0_wr_banksel_addr0_dec[7:0] = { (que_b0_wr_index_ent0[2:0] == 3'h7), 
                                        	(que_b0_wr_index_ent0[2:0] == 3'h6),
                                        	(que_b0_wr_index_ent0[2:0] == 3'h5),
                                        	(que_b0_wr_index_ent0[2:0] == 3'h4),
                                        	(que_b0_wr_index_ent0[2:0] == 3'h3),
                                        	(que_b0_wr_index_ent0[2:0] == 3'h2),
                                        	(que_b0_wr_index_ent0[2:0] == 3'h1), 
						(que_b0_wr_index_ent0[2:0] == 3'h0) };

assign que_b0_wr_banksel_addr1_dec[7:0] = { (que_b0_wr_index_ent1[2:0] == 3'h7), 
                                        	(que_b0_wr_index_ent1[2:0] == 3'h6),
                                        	(que_b0_wr_index_ent1[2:0] == 3'h5),
                                        	(que_b0_wr_index_ent1[2:0] == 3'h4),
                                        	(que_b0_wr_index_ent1[2:0] == 3'h3),
                                        	(que_b0_wr_index_ent1[2:0] == 3'h2),
                                        	(que_b0_wr_index_ent1[2:0] == 3'h1), 
						(que_b0_wr_index_ent1[2:0] == 3'h0) };

assign que_b0_wr_banksel_addr2_dec[7:0] = { (que_b0_wr_index_ent2[2:0] == 3'h7), 
                                        	(que_b0_wr_index_ent2[2:0] == 3'h6),
                                        	(que_b0_wr_index_ent2[2:0] == 3'h5),
                                        	(que_b0_wr_index_ent2[2:0] == 3'h4),
                                        	(que_b0_wr_index_ent2[2:0] == 3'h3),
                                        	(que_b0_wr_index_ent2[2:0] == 3'h2),
                                        	(que_b0_wr_index_ent2[2:0] == 3'h1), 
						(que_b0_wr_index_ent2[2:0] == 3'h0) };

assign que_b0_wr_banksel_addr3_dec[7:0] = { (que_b0_wr_index_ent3[2:0] == 3'h7), 
                                        	(que_b0_wr_index_ent3[2:0] == 3'h6),
                                        	(que_b0_wr_index_ent3[2:0] == 3'h5),
                                        	(que_b0_wr_index_ent3[2:0] == 3'h4),
                                        	(que_b0_wr_index_ent3[2:0] == 3'h3),
                                        	(que_b0_wr_index_ent3[2:0] == 3'h2),
                                        	(que_b0_wr_index_ent3[2:0] == 3'h1), 
						(que_b0_wr_index_ent3[2:0] == 3'h0) };

assign que_b0_wr_banksel_addr4_dec[7:0] = { (que_b0_wr_index_ent4[2:0] == 3'h7), 
                                        	(que_b0_wr_index_ent4[2:0] == 3'h6),
                                        	(que_b0_wr_index_ent4[2:0] == 3'h5),
                                        	(que_b0_wr_index_ent4[2:0] == 3'h4),
                                        	(que_b0_wr_index_ent4[2:0] == 3'h3),
                                        	(que_b0_wr_index_ent4[2:0] == 3'h2),
                                        	(que_b0_wr_index_ent4[2:0] == 3'h1), 
						(que_b0_wr_index_ent4[2:0] == 3'h0) };

assign que_b0_wr_banksel_addr5_dec[7:0] = { (que_b0_wr_index_ent5[2:0] == 3'h7), 
                                        	(que_b0_wr_index_ent5[2:0] == 3'h6),
                                        	(que_b0_wr_index_ent5[2:0] == 3'h5),
                                        	(que_b0_wr_index_ent5[2:0] == 3'h4),
                                        	(que_b0_wr_index_ent5[2:0] == 3'h3),
                                        	(que_b0_wr_index_ent5[2:0] == 3'h2),
                                        	(que_b0_wr_index_ent5[2:0] == 3'h1), 
						(que_b0_wr_index_ent5[2:0] == 3'h0) };

assign que_b0_wr_banksel_addr6_dec[7:0] = { (que_b0_wr_index_ent6[2:0] == 3'h7), 
                                        	(que_b0_wr_index_ent6[2:0] == 3'h6),
                                        	(que_b0_wr_index_ent6[2:0] == 3'h5),
                                        	(que_b0_wr_index_ent6[2:0] == 3'h4),
                                        	(que_b0_wr_index_ent6[2:0] == 3'h3),
                                        	(que_b0_wr_index_ent6[2:0] == 3'h2),
                                        	(que_b0_wr_index_ent6[2:0] == 3'h1), 
						(que_b0_wr_index_ent6[2:0] == 3'h0) };

assign que_b0_wr_banksel_addr7_dec[7:0] = { (que_b0_wr_index_ent7[2:0] == 3'h7), 
                                        	(que_b0_wr_index_ent7[2:0] == 3'h6),
                                        	(que_b0_wr_index_ent7[2:0] == 3'h5),
                                        	(que_b0_wr_index_ent7[2:0] == 3'h4),
                                        	(que_b0_wr_index_ent7[2:0] == 3'h3),
                                        	(que_b0_wr_index_ent7[2:0] == 3'h2),
                                        	(que_b0_wr_index_ent7[2:0] == 3'h1), 
						(que_b0_wr_index_ent7[2:0] == 3'h0) };

// Qualify the read dec address with valid
assign que_b0_indx7_val = {8{que_b0_index_ent7[6]}} & que_b0_banksel_addr7_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_index_ent7[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_indx6_val = {8{que_b0_index_ent6[6]}} & que_b0_banksel_addr6_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_index_ent6[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_indx5_val = {8{que_b0_index_ent5[6]}} & que_b0_banksel_addr5_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_index_ent5[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_indx4_val = {8{que_b0_index_ent4[6]}} & que_b0_banksel_addr4_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_index_ent4[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_indx3_val = {8{que_b0_index_ent3[6]}} & que_b0_banksel_addr3_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_index_ent3[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_indx2_val = {8{que_b0_index_ent2[6]}} & que_b0_banksel_addr2_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_index_ent2[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_indx1_val = {8{que_b0_index_ent1[6]}} & que_b0_banksel_addr1_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_index_ent1[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_indx0_val = {8{que_b0_index_ent0[6]}} & que_b0_banksel_addr0_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_index_ent0[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 

// Qualify the write dec address with valid
assign que_b0_wr_indx7_val = {8{que_b0_wr_index_ent7[6]}} & que_b0_wr_banksel_addr7_dec[7:0] & 
				{8{(((que_refresh_rank != que_b0_wr_index_ent7[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_wr_indx6_val = {8{que_b0_wr_index_ent6[6]}} & que_b0_wr_banksel_addr6_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_wr_index_ent6[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_wr_indx5_val = {8{que_b0_wr_index_ent5[6]}} & que_b0_wr_banksel_addr5_dec[7:0] & 
				{8{(((que_refresh_rank != que_b0_wr_index_ent5[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_wr_indx4_val = {8{que_b0_wr_index_ent4[6]}} & que_b0_wr_banksel_addr4_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_wr_index_ent4[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_wr_indx3_val = {8{que_b0_wr_index_ent3[6]}} & que_b0_wr_banksel_addr3_dec[7:0] & 
				{8{(((que_refresh_rank != que_b0_wr_index_ent3[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_wr_indx2_val = {8{que_b0_wr_index_ent2[6]}} & que_b0_wr_banksel_addr2_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_wr_index_ent2[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_wr_indx1_val = {8{que_b0_wr_index_ent1[6]}} & que_b0_wr_banksel_addr1_dec[7:0] & 
				{8{(((que_refresh_rank != que_b0_wr_index_ent1[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 
assign que_b0_wr_indx0_val = {8{que_b0_wr_index_ent0[6]}} & que_b0_wr_banksel_addr0_dec[7:0] &
				{8{(((que_refresh_rank != que_b0_wr_index_ent0[8:7]) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 

wire [7:0] que_scrb_indx_val = que_scrb_bank_valid[7:0] & 
		{8{(((que_refresh_rank != {que_split_scrb_addr[35], que_split_scrb_addr[33]}) &
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 

// Keep track of delayed val for resetting the wr valid que after ras_picked

dff_ns #(24) 	ff_rd_indx0_val(
        	.din({que_b0_indx0_val, que_b0_indx1_val, que_b0_indx2_val}),
        	.q({que_b0_indx0_val_d1, que_b0_indx1_val_d1, que_b0_indx2_val_d1}),
        	.clk(clk));

dff_ns #(24) 	ff_rd_indx3_val(
        	.din({que_b0_indx3_val, que_b0_indx4_val, que_b0_indx5_val}),
        	.q({que_b0_indx3_val_d1, que_b0_indx4_val_d1, que_b0_indx5_val_d1}),
        	.clk(clk));

dff_ns #(16) 	ff_rd_indx6_val(
        	.din({que_b0_indx6_val, que_b0_indx7_val}),
        	.q({que_b0_indx6_val_d1, que_b0_indx7_val_d1}),
        	.clk(clk));

dff_ns #(24)    ff_wr_indx0_val(
                .din({que_b0_wr_indx0_val, que_b0_wr_indx1_val, que_b0_wr_indx2_val}),
                .q({que_b0_wr_indx0_val_d1, que_b0_wr_indx1_val_d1, que_b0_wr_indx2_val_d1}),
                .clk(clk));

dff_ns #(24)    ff_wr_indx3_val(
                .din({que_b0_wr_indx3_val, que_b0_wr_indx4_val, que_b0_wr_indx5_val}),
                .q({que_b0_wr_indx3_val_d1, que_b0_wr_indx4_val_d1, que_b0_wr_indx5_val_d1}),
                .clk(clk));

dff_ns #(16)    ff_wr_indx6_val(
                .din({que_b0_wr_indx6_val, que_b0_wr_indx7_val}),
                .q({que_b0_wr_indx6_val_d1, que_b0_wr_indx7_val_d1}),
                .clk(clk));

////////////////////////////////////////
// Decoding wr addr and rd addr for just incomming and assert valids to arbitration
////////////////////////////////////////

wire [7:0]	que_b0_banksel_addr_rd_in_dec;
wire [7:0]	que_b0_rd_in_val;

assign que_b0_banksel_addr_rd_in_dec[7:0] = { (que_rd_addr0[2:0] == 3'h7), 
                                        	(que_rd_addr0[2:0] == 3'h6),
                                        	(que_rd_addr0[2:0] == 3'h5),
                                        	(que_rd_addr0[2:0] == 3'h4),
                                        	(que_rd_addr0[2:0] == 3'h3),
                                        	(que_rd_addr0[2:0] == 3'h2),
                                        	(que_rd_addr0[2:0] == 3'h1), 
						(que_rd_addr0[2:0] == 3'h0) };

// qualify with read req 
assign que_b0_rd_in_val = {8{que_rd_req}} & que_b0_banksel_addr_rd_in_dec[7:0] &
				{8{(((que_refresh_rank != {que_rd_addr0[35], que_rd_addr0[33]}) & 
				(que_pos == 5'hb | que_pos == 5'hd) & ~que_init) | que_pos == 5'ha)}}; 

assign que_b0_bank_val[7:0] = {que_b0_indx7_val | que_b0_indx6_val | que_b0_indx5_val | 
			que_b0_indx4_val | que_b0_indx3_val | que_b0_indx2_val| que_b0_indx1_val | 
			que_b0_indx0_val | que_b0_wr_indx7_val | que_b0_wr_indx6_val | 
			que_b0_wr_indx5_val | que_b0_wr_indx4_val | que_b0_wr_indx3_val | 
			que_b0_wr_indx2_val | que_b0_wr_indx1_val | que_b0_wr_indx0_val | 
			que_b0_rd_in_val} & {8{que_init_dram_done}};

// ASSERT VALIDS for the aribiter or with scrub read/writes.
assign que_bank_l2req_valids[7:0] = que_b0_bank_val[7:0] & {8{~que_channel_disabled}}; 

// Send valids to other channel if this channel is disabled
assign que_l2req_valids[7:0] = que_b0_bank_val[7:0] & {8{que_channel_disabled}}; 

// OR the l2 req valids, other channel l2 req valids and scrub valids
// Refresh needs to be sent when que_pos == 5'hc, so should not pick ras/cas this cycle. 
// REFRESH/RAS/CAS picked this cycle sent followig cycle to I/O
wire [7:0] que_this_ch_valids = que_bank_l2req_valids[7:0] | que_scrb_indx_val[7:0];
assign que_bank_valids[7:0] =  (que_this_ch_valids[7:0] | ch1_que_l2req_valids[7:0] ) & 
						{8{~pt_ch_blk_new_openbank}} &
		{8{~(&b0_cas_cnt[7:0] | &b1_cas_cnt[7:0] | &b2_cas_cnt[7:0] | &b3_cas_cnt[7:0] | 
		&b4_cas_cnt[7:0] | &b5_cas_cnt[7:0] | &b6_cas_cnt[7:0] | &b7_cas_cnt[7:0])}}; 

// ARB TO PICK CH0 or CH1 requests
// These ARB should be reset on dram_dbginit_l so its repeatable.

// Flop dgbinit before using it.
dff_ns #(1) 	ff_dbginit(
        	.din(dram_dbginit_l),
        	.q(que_dbginit_l),
        	.clk(clk));

wire que_arb_reset_l = rst_l & que_dbginit_l;

wire	que_prev_picked0;
wire	que_prev_picked1;
wire	que_prev_picked2;
wire	que_prev_picked3;
wire	que_prev_picked4;
wire	que_prev_picked5;
wire	que_prev_picked6;
wire	que_prev_picked7;

wire que_prev_picked0_in = ~que_prev_picked0;
wire que_prev_picked0_en = que_this_ch_valids[0] & ch1_que_l2req_valids[0] & que_ras_picked[0];

dffrle_ns #(1) 	ff_prev_picked0(
        	.din(que_prev_picked0_in),
        	.q(que_prev_picked0),
		.en(que_prev_picked0_en),
        	.rst_l(que_arb_reset_l),
        	.clk(clk));

wire que_prev_picked1_in = ~que_prev_picked1;
wire que_prev_picked1_en = que_this_ch_valids[1] & ch1_que_l2req_valids[1] & que_ras_picked[1];

dffrle_ns #(1) 	ff_prev_picked1(
        	.din(que_prev_picked1_in),
        	.q(que_prev_picked1),
		.en(que_prev_picked1_en),
        	.rst_l(que_arb_reset_l),
        	.clk(clk));

wire que_prev_picked2_in = ~que_prev_picked2;
wire que_prev_picked2_en = que_this_ch_valids[2] & ch1_que_l2req_valids[2] & que_ras_picked[2];

dffrle_ns #(1) 	ff_prev_picked2(
        	.din(que_prev_picked2_in),
        	.q(que_prev_picked2),
		.en(que_prev_picked2_en),
        	.rst_l(que_arb_reset_l),
        	.clk(clk));

wire que_prev_picked3_in = ~que_prev_picked3;
wire que_prev_picked3_en = que_this_ch_valids[3] & ch1_que_l2req_valids[3] & que_ras_picked[3];

dffrle_ns #(1) 	ff_prev_picked3(
        	.din(que_prev_picked3_in),
        	.q(que_prev_picked3),
		.en(que_prev_picked3_en),
        	.rst_l(que_arb_reset_l),
        	.clk(clk));

wire que_prev_picked4_in = ~que_prev_picked4;
wire que_prev_picked4_en = que_this_ch_valids[4] & ch1_que_l2req_valids[4] & que_ras_picked[4];

dffrle_ns #(1) 	ff_prev_picked4(
        	.din(que_prev_picked4_in),
        	.q(que_prev_picked4),
		.en(que_prev_picked4_en),
        	.rst_l(que_arb_reset_l),
        	.clk(clk));

wire que_prev_picked5_in = ~que_prev_picked5;
wire que_prev_picked5_en = que_this_ch_valids[5] & ch1_que_l2req_valids[5] & que_ras_picked[5];

dffrle_ns #(1) 	ff_prev_picked5(
        	.din(que_prev_picked5_in),
        	.q(que_prev_picked5),
		.en(que_prev_picked5_en),
        	.rst_l(que_arb_reset_l),
        	.clk(clk));

wire que_prev_picked6_in = ~que_prev_picked6;
wire que_prev_picked6_en = que_this_ch_valids[6] & ch1_que_l2req_valids[6] & que_ras_picked[6];

dffrle_ns #(1) 	ff_prev_picked6(
        	.din(que_prev_picked6_in),
        	.q(que_prev_picked6),
		.en(que_prev_picked6_en),
        	.rst_l(que_arb_reset_l),
        	.clk(clk));

wire que_prev_picked7_in = ~que_prev_picked7;
wire que_prev_picked7_en = que_this_ch_valids[7] & ch1_que_l2req_valids[7] & que_ras_picked[7];

dffrle_ns #(1) 	ff_prev_picked7(
        	.din(que_prev_picked7_in),
        	.q(que_prev_picked7),
		.en(que_prev_picked7_en),
        	.rst_l(que_arb_reset_l),
        	.clk(clk));

// IN 2 CHANNEL MODE SCRUB HAS HIGHER PRIOPRITY THAN LOAD/STORES SO TO NOT CORRUPT MEMORY
wire que_channel_picked = que_scrb_picked ? 1'b0 :
			que_ras_picked[0] ? (que_this_ch_valids[0] & ch1_que_l2req_valids[0] ? 
				que_prev_picked0 : ch1_que_l2req_valids[0]) : 
			que_ras_picked[1] ? (que_this_ch_valids[1] & ch1_que_l2req_valids[1] ? 
				que_prev_picked1 : ch1_que_l2req_valids[1]) : 
			que_ras_picked[2] ? (que_this_ch_valids[2] & ch1_que_l2req_valids[2] ? 
				que_prev_picked2 : ch1_que_l2req_valids[2]) : 
			que_ras_picked[3] ? (que_this_ch_valids[3] & ch1_que_l2req_valids[3] ? 
				que_prev_picked3 : ch1_que_l2req_valids[3]) : 
			que_ras_picked[4] ? (que_this_ch_valids[4] & ch1_que_l2req_valids[4] ? 
				que_prev_picked4 : ch1_que_l2req_valids[4]) : 
			que_ras_picked[5] ? (que_this_ch_valids[5] & ch1_que_l2req_valids[5] ? 
				que_prev_picked5 : ch1_que_l2req_valids[5]) : 
			que_ras_picked[6] ? (que_this_ch_valids[6] & ch1_que_l2req_valids[6] ? 
				que_prev_picked6 : ch1_que_l2req_valids[6]) : 
			que_ras_picked[7] ? (que_this_ch_valids[7] & ch1_que_l2req_valids[7] ? 
				que_prev_picked7 : ch1_que_l2req_valids[7]) : 1'b0;

assign que_channel_picked_internal = que_channel_disabled ? ch0_que_channel_picked : 
					que_channel_picked;

assign que_cas_picked = b7_cas_picked | b6_cas_picked | b5_cas_picked |
				b4_cas_picked | b3_cas_picked | b2_cas_picked |
				b1_cas_picked | b0_cas_picked;
assign que_cas_int_picked = {b7_cas_picked , b6_cas_picked , b5_cas_picked ,
				b4_cas_picked , b3_cas_picked , b2_cas_picked ,
				b1_cas_picked , b0_cas_picked};

//////////////////////////////////////////////////////////////////
// SCHEDULER 
//////////////////////////////////////////////////////////////////
// DRAM state machine
//////////////////////////////////////////////////////////////////

// ras to ras (bankA to bankB) delay timer.
assign rrd_cnt_next = (|que_ras_picked[7:0]) & rrd_cnt_is_zero ? rrd_reg[3:0] - 4'h1 : 
					(rrd_cnt == 4'h0) ? 4'h0 : rrd_cnt - 4'h1;

dffrl_ns #(4) 	ff_rrd_cnt(
        	.din(rrd_cnt_next[3:0]),
        	.q(rrd_cnt[3:0]),
        	.rst_l(rst_l),
        	.clk(clk));

assign rrd_cnt_is_zero = (rrd_cnt == 4'h0);

// read to write cas to cas (bankA to bankA/bankB) delay timer for not clashing read and write data.
// If read is picked during cas assert rtw_cnt to regular cnt + rtw delay.
wire [3:0]	rtw_cnt_next;
wire [3:0]	rtw_dly_reg;
wire [3:0]	rtw_reg;
wire [3:0]	rtw_cnt;
wire		rtw_cnt_is_zero;
wire		que_mux_write_en;

assign rtw_cnt_next = que_cas_picked & ~que_mux_write_en ? rtw_reg[3:0] - 4'h1 : 
				(rtw_cnt == 4'h0) ? 4'h0 : rtw_cnt - 4'h1;

dffrl_ns #(4)       ff_rtw_cnt(
                .din(rtw_cnt_next[3:0]),
                .q(rtw_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign rtw_cnt_is_zero = (rtw_cnt == 4'h0);

// write to read cas to cas (bankA to bankA/bankB) delay timer for not clashing read and write data.
assign wtr_cnt_next = que_cas_picked & que_mux_write_en ? wtr_reg[3:0] - 4'h1 : 
				(wtr_cnt == 4'h0) ? 4'h0 : wtr_cnt - 4'h1;

dffrl_ns #(4) 	ff_wtr_cnt(
        	.din(wtr_cnt_next[3:0]),
        	.q(wtr_cnt[3:0]),
        	.rst_l(rst_l),
        	.clk(clk));

assign wtr_cnt_is_zero = (wtr_cnt == 4'h0);

// read to read cas to cas (bankA to bankA/bankB) delay timer for not clashing read data.
assign rtr_cnt_next = que_cas_picked & ~que_mux_write_en ? 1'h1 :
                                (rtr_cnt == 1'h0) ? 1'h0 : rtr_cnt - 1'h1;

dffrl_ns #(1)   ff_rtr_cnt(
                .din(rtr_cnt_next),
                .q(rtr_cnt),
                .rst_l(rst_l),
                .clk(clk));

assign rtr_cnt_is_zero = (rtr_cnt == 1'h0);

// write to write cas to cas (bankA to bankA/bankB) delay timer for not clashing store data.
assign wtw_cnt_next = que_cas_picked & que_mux_write_en ? 1'h1 :
                                (wtw_cnt == 1'h0) ? 1'h0 : wtw_cnt - 1'h1;

dffrl_ns #(1)   ff_wtw_cnt(
                .din(wtw_cnt_next),
                .q(wtw_cnt),
                .rst_l(rst_l),
                .clk(clk));

assign wtw_cnt_is_zero = (wtw_cnt == 1'h0);

// Refresh to Active delay timer 
// wait for tRFC count
assign rfc_cnt_next = que_refresh_req_picked ? rfc_reg[6:0] : (rfc_cnt == 7'h0) ? 7'h0 : 
									rfc_cnt - 7'h1;

dffrl_ns #(7)       ff_rfc_cnt(
                .din(rfc_cnt_next[6:0]),
                .q(rfc_cnt[6:0]),
                .rst_l(rst_l),
                .clk(clk));

assign rfc_cnt_is_zero = (rfc_cnt == 7'h0);

//////////////////////////////////////////////////////////////////
// DRAM BANK state machine
// There is one SM for one DRAM bank. This keeps track of the 
// commands issued to it and generate appropriate signals to 
// DRAM state machine.
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// dram bank0 SM
//////////////////////////////////////////////////////////////////

// ras to cas delay timer
assign b0_rcd_cnt_next = b0_ras_picked ? rcd_reg[3:0] - 4'h1 : 
			(b0_rcd_cnt == 4'h0) ?  4'h0 : b0_rcd_cnt - 4'h1;

dffrl_ns #(4) 	ff_b0_rcd_cnt(
        	.din(b0_rcd_cnt_next[3:0]),
        	.q(b0_rcd_cnt[3:0]),
        	.rst_l(rst_l),
        	.clk(clk));

assign b0_rcd_cnt_is_zero = (b0_rcd_cnt == 4'h0);

// ras to ras (bankA to bankA) delay timer
assign b0_rc_cnt_next = b0_ras_picked ? rc_reg[4:0] - 5'h1 : (b0_rc_cnt == 5'h0) ? 5'h0 : b0_rc_cnt - 5'h1;

dffrl_ns #(5) 	ff_b0_rc_cnt(
        	.din(b0_rc_cnt_next[4:0]),
        	.q(b0_rc_cnt[4:0]),
        	.rst_l(rst_l),
        	.clk(clk));

assign b0_rc_cnt_is_zero = (b0_rc_cnt == 5'h0);

// read/write to ras (DAL) delay timer
assign b0_dal_cnt_next = b0_cas_picked ? (b0_cas_info[19] ? dal_reg[3:0] : ral_reg[3:0]) :
                                ((b0_dal_cnt == 4'h0) ? 4'h0 : b0_dal_cnt - 4'h1);

dffrl_ns #(4)       ff_b0_dal_cnt(
                .din(b0_dal_cnt_next[3:0]),
                .q(b0_dal_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b0_dal_cnt_is_zero = (b0_dal_cnt == 4'h0);

//////////////////////////////////////////////////////////////////
// dram bank1 SM
//////////////////////////////////////////////////////////////////

// ras to cas delay timer
assign b1_rcd_cnt_next = b1_ras_picked ? rcd_reg[3:0] - 4'h1 :
                        (b1_rcd_cnt == 4'h0) ?  4'h0 : b1_rcd_cnt - 4'h1;

dffrl_ns #(4)       ff_b1_rcd_cnt(
                .din(b1_rcd_cnt_next[3:0]),
                .q(b1_rcd_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b1_rcd_cnt_is_zero = (b1_rcd_cnt == 4'h0);

// ras to ras (bankA to bankA) delay timer
assign b1_rc_cnt_next = b1_ras_picked ? rc_reg[4:0] - 5'h1 : (b1_rc_cnt == 5'h0) ? 5'h0 : b1_rc_cnt - 5'h1;

dffrl_ns #(5)       ff_b1_rc_cnt(
                .din(b1_rc_cnt_next[4:0]),
                .q(b1_rc_cnt[4:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b1_rc_cnt_is_zero = (b1_rc_cnt == 5'h0);

// read/write to ras (DAL) delay timer
assign b1_dal_cnt_next = b1_cas_picked ? (b1_cas_info[19] ? dal_reg[3:0] : ral_reg[3:0]) :
                                ((b1_dal_cnt == 4'h0) ? 4'h0 : b1_dal_cnt - 4'h1);

dffrl_ns #(4)       ff_b1_dal_cnt(
                .din(b1_dal_cnt_next[3:0]),
                .q(b1_dal_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b1_dal_cnt_is_zero = (b1_dal_cnt == 4'h0);

//////////////////////////////////////////////////////////////////
// dram bank2 SM
//////////////////////////////////////////////////////////////////

// ras to cas delay timer
assign b2_rcd_cnt_next = b2_ras_picked ? rcd_reg[3:0] - 4'h1 :
                        (b2_rcd_cnt == 4'h0) ?  4'h0 : b2_rcd_cnt - 4'h1;

dffrl_ns #(4)       ff_b2_rcd_cnt(
                .din(b2_rcd_cnt_next[3:0]),
                .q(b2_rcd_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b2_rcd_cnt_is_zero = (b2_rcd_cnt == 4'h0);

// ras to ras (bankA to bankA) delay timer
assign b2_rc_cnt_next = b2_ras_picked ? rc_reg[4:0] - 5'h1 : (b2_rc_cnt == 5'h0) ? 5'h0 : b2_rc_cnt - 5'h1;

dffrl_ns #(5)       ff_b2_rc_cnt(
                .din(b2_rc_cnt_next[4:0]),
                .q(b2_rc_cnt[4:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b2_rc_cnt_is_zero = (b2_rc_cnt == 5'h0);

// read/write to ras (DAL) delay timer
assign b2_dal_cnt_next = b2_cas_picked ? (b2_cas_info[19] ? dal_reg[3:0] : ral_reg[3:0]) :
                                ((b2_dal_cnt == 4'h0) ? 4'h0 : b2_dal_cnt - 4'h1);

dffrl_ns #(4)       ff_b2_dal_cnt(
                .din(b2_dal_cnt_next[3:0]),
                .q(b2_dal_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b2_dal_cnt_is_zero = (b2_dal_cnt == 4'h0);

//////////////////////////////////////////////////////////////////
// dram bank3 SM
//////////////////////////////////////////////////////////////////

// ras to cas delay timer
assign b3_rcd_cnt_next = b3_ras_picked ? rcd_reg[3:0] - 4'h1 :
                        (b3_rcd_cnt == 4'h0) ?  4'h0 : b3_rcd_cnt - 4'h1;

dffrl_ns #(4)       ff_b3_rcd_cnt(
                .din(b3_rcd_cnt_next[3:0]),
                .q(b3_rcd_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b3_rcd_cnt_is_zero = (b3_rcd_cnt == 4'h0);

// ras to ras (bankA to bankA) delay timer
assign b3_rc_cnt_next = b3_ras_picked ? rc_reg[4:0] - 5'h1 : (b3_rc_cnt == 5'h0) ? 5'h0 : b3_rc_cnt - 5'h1;

dffrl_ns #(5)       ff_b3_rc_cnt(
                .din(b3_rc_cnt_next[4:0]),
                .q(b3_rc_cnt[4:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b3_rc_cnt_is_zero = (b3_rc_cnt == 5'h0);

// read/write to ras (DAL) delay timer
assign b3_dal_cnt_next = b3_cas_picked ? (b3_cas_info[19] ? dal_reg[3:0] : ral_reg[3:0]) :
                                ((b3_dal_cnt == 4'h0) ? 4'h0 : b3_dal_cnt - 4'h1);

dffrl_ns #(4)       ff_b3_dal_cnt(
                .din(b3_dal_cnt_next[3:0]),
                .q(b3_dal_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b3_dal_cnt_is_zero = (b3_dal_cnt == 4'h0);

//////////////////////////////////////////////////////////////////
// dram bank4 SM
//////////////////////////////////////////////////////////////////

// ras to cas delay timer
assign b4_rcd_cnt_next = b4_ras_picked ? rcd_reg[3:0] - 4'h1 :
                        (b4_rcd_cnt == 4'h0) ?  4'h0 : b4_rcd_cnt - 4'h1;

dffrl_ns #(4)       ff_b4_rcd_cnt(
                .din(b4_rcd_cnt_next[3:0]),
                .q(b4_rcd_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b4_rcd_cnt_is_zero = (b4_rcd_cnt == 4'h0);

// ras to ras (bankA to bankA) delay timer
assign b4_rc_cnt_next = b4_ras_picked ? rc_reg[4:0] - 5'h1 : (b4_rc_cnt == 5'h0) ? 5'h0 : b4_rc_cnt - 5'h1;

dffrl_ns #(5)       ff_b4_rc_cnt(
                .din(b4_rc_cnt_next[4:0]),
                .q(b4_rc_cnt[4:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b4_rc_cnt_is_zero = (b4_rc_cnt == 5'h0);

// read/write to ras (DAL) delay timer
assign b4_dal_cnt_next = b4_cas_picked ? (b4_cas_info[19] ? dal_reg[3:0] : ral_reg[3:0]) :
                                ((b4_dal_cnt == 4'h0) ? 4'h0 : b4_dal_cnt - 4'h1);

dffrl_ns #(4)       ff_b4_dal_cnt(
                .din(b4_dal_cnt_next[3:0]),
                .q(b4_dal_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b4_dal_cnt_is_zero = (b4_dal_cnt == 4'h0);

//////////////////////////////////////////////////////////////////
// dram bank5 SM
//////////////////////////////////////////////////////////////////

// ras to cas delay timer
assign b5_rcd_cnt_next = b5_ras_picked ? rcd_reg[3:0] - 4'h1 :
                        (b5_rcd_cnt == 4'h0) ?  4'h0 : b5_rcd_cnt - 4'h1;

dffrl_ns #(4)       ff_b5_rcd_cnt(
                .din(b5_rcd_cnt_next[3:0]),
                .q(b5_rcd_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b5_rcd_cnt_is_zero = (b5_rcd_cnt == 4'h0);

// ras to ras (bankA to bankA) delay timer
assign b5_rc_cnt_next = b5_ras_picked ? rc_reg[4:0] - 5'h1 : (b5_rc_cnt == 5'h0) ? 5'h0 : b5_rc_cnt - 5'h1;

dffrl_ns #(5)       ff_b5_rc_cnt(
                .din(b5_rc_cnt_next[4:0]),
                .q(b5_rc_cnt[4:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b5_rc_cnt_is_zero = (b5_rc_cnt == 5'h0);

// read/write to ras (DAL) delay timer
assign b5_dal_cnt_next = b5_cas_picked ? (b5_cas_info[19] ? dal_reg[3:0] : ral_reg[3:0]) :
                                ((b5_dal_cnt == 4'h0) ? 4'h0 : b5_dal_cnt - 4'h1);

dffrl_ns #(4)       ff_b5_dal_cnt(
                .din(b5_dal_cnt_next[3:0]),
                .q(b5_dal_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b5_dal_cnt_is_zero = (b5_dal_cnt == 4'h0);

//////////////////////////////////////////////////////////////////
// dram bank6 SM
//////////////////////////////////////////////////////////////////

// ras to cas delay timer
assign b6_rcd_cnt_next = b6_ras_picked ? rcd_reg[3:0] - 4'h1 :
                        (b6_rcd_cnt == 4'h0) ?  4'h0 : b6_rcd_cnt - 4'h1;

dffrl_ns #(4)       ff_b6_rcd_cnt(
                .din(b6_rcd_cnt_next[3:0]),
                .q(b6_rcd_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b6_rcd_cnt_is_zero = (b6_rcd_cnt == 4'h0);

// ras to ras (bankA to bankA) delay timer
assign b6_rc_cnt_next = b6_ras_picked ? rc_reg[4:0] - 5'h1 : (b6_rc_cnt == 5'h0) ? 5'h0 : b6_rc_cnt - 5'h1;

dffrl_ns #(5)       ff_b6_rc_cnt(
                .din(b6_rc_cnt_next[4:0]),
                .q(b6_rc_cnt[4:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b6_rc_cnt_is_zero = (b6_rc_cnt == 5'h0);

// read/write to ras (DAL) delay timer
assign b6_dal_cnt_next = b6_cas_picked ? (b6_cas_info[19] ? dal_reg[3:0] : ral_reg[3:0]) :
                                ((b6_dal_cnt == 4'h0) ? 4'h0 : b6_dal_cnt - 4'h1);

dffrl_ns #(4)       ff_b6_dal_cnt(
                .din(b6_dal_cnt_next[3:0]),
                .q(b6_dal_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b6_dal_cnt_is_zero = (b6_dal_cnt == 4'h0);

//////////////////////////////////////////////////////////////////
// dram bank7 SM
//////////////////////////////////////////////////////////////////

// ras to cas delay timer
assign b7_rcd_cnt_next = b7_ras_picked ? rcd_reg[3:0] - 4'h1 :
                        (b7_rcd_cnt == 4'h0) ?  4'h0 : b7_rcd_cnt - 4'h1;

dffrl_ns #(4)       ff_b7_rcd_cnt(
                .din(b7_rcd_cnt_next[3:0]),
                .q(b7_rcd_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b7_rcd_cnt_is_zero = (b7_rcd_cnt == 4'h0);

// ras to ras (bankA to bankA) delay timer
assign b7_rc_cnt_next = b7_ras_picked ? rc_reg[4:0] - 5'h1 : (b7_rc_cnt == 5'h0) ? 5'h0 : b7_rc_cnt - 5'h1;

dffrl_ns #(5)       ff_b7_rc_cnt(
                .din(b7_rc_cnt_next[4:0]),
                .q(b7_rc_cnt[4:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b7_rc_cnt_is_zero = (b7_rc_cnt == 5'h0);

// read/write to ras (DAL) delay timer
assign b7_dal_cnt_next = b7_cas_picked ? (b7_cas_info[19] ? dal_reg[3:0] : ral_reg[3:0]) :
                                ((b7_dal_cnt == 4'h0) ? 4'h0 : b7_dal_cnt - 4'h1);

dffrl_ns #(4)       ff_b7_dal_cnt(
                .din(b7_dal_cnt_next[3:0]),
                .q(b7_dal_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign b7_dal_cnt_is_zero = (b7_dal_cnt == 4'h0);

//////////////////////////////////////////////////////////////////
// Performing ARBITRATION for RAS and CAS reqeust based on previous 
// valids generated
//////////////////////////////////////////////////////////////////

// Picking RAS and CAS has to be done so that no body is starved.
// The bank that gets picked will be put in the bottom of the priority.

wire [7:0]	que_ras_bank_picked_d1;
wire [7:0]	que_cas_bank_picked_d1;
wire		que_hw_selfrsh;

assign que_ras_bank_picked_en = |que_ras_picked[7:0];

dffrle_ns #(8) 	ff_prev_ras_bank_picked(
                .din(que_ras_picked[7:0]),
                .q(que_ras_bank_picked_d1[7:0]), 
		.en(que_ras_bank_picked_en),
		.rst_l(que_arb_reset_l),
                .clk(clk));

dffrle_ns #(8)  ff_prev_cas_bank_picked(
                .din({b7_cas_picked, b6_cas_picked, b5_cas_picked, b4_cas_picked,
			b3_cas_picked, b2_cas_picked, b1_cas_picked, b0_cas_picked}),
                .q(que_cas_bank_picked_d1[7:0]),
                .en(que_cas_picked),
		.rst_l(que_arb_reset_l),
                .clk(clk));

assign b7_ras_pend_req = que_bank_valids[7] & b7_rc_cnt_is_zero & ~que_cas_valid[7] & 
				b7_dal_cnt_is_zero & rrd_cnt_is_zero; 
assign b6_ras_pend_req = que_bank_valids[6] & b6_rc_cnt_is_zero & ~que_cas_valid[6] & 
				b6_dal_cnt_is_zero & rrd_cnt_is_zero; 
assign b5_ras_pend_req = que_bank_valids[5] & b5_rc_cnt_is_zero & ~que_cas_valid[5] & 
				b5_dal_cnt_is_zero & rrd_cnt_is_zero; 
assign b4_ras_pend_req = que_bank_valids[4] & b4_rc_cnt_is_zero & ~que_cas_valid[4] & 
				b4_dal_cnt_is_zero & rrd_cnt_is_zero; 
assign b3_ras_pend_req = que_bank_valids[3] & b3_rc_cnt_is_zero & ~que_cas_valid[3] & 
				b3_dal_cnt_is_zero & rrd_cnt_is_zero; 
assign b2_ras_pend_req = que_bank_valids[2] & b2_rc_cnt_is_zero & ~que_cas_valid[2] & 
				b2_dal_cnt_is_zero & rrd_cnt_is_zero; 
assign b1_ras_pend_req = que_bank_valids[1] & b1_rc_cnt_is_zero & ~que_cas_valid[1] & 
				b1_dal_cnt_is_zero & rrd_cnt_is_zero; 
assign b0_ras_pend_req = que_bank_valids[0] & b0_rc_cnt_is_zero & ~que_cas_valid[0] & 
				b0_dal_cnt_is_zero & rrd_cnt_is_zero; 

wire b0_ras_int_picked = ~que_cas_picked & b0_ras_pend_req & (((que_ras_bank_picked_d1 == 8'h80) |
        (que_ras_bank_picked_d1 == 8'h40) & ~b7_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h20) & ~b7_ras_pend_req & ~b6_ras_pend_req  |
        (que_ras_bank_picked_d1 == 8'h10) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req|
        (que_ras_bank_picked_d1 == 8'h8) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h4) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req & ~b3_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h2) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req & ~b3_ras_pend_req & ~b2_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h1) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req & ~b3_ras_pend_req & ~b2_ras_pend_req & ~b1_ras_pend_req) |
		(que_ras_bank_picked_d1 == 8'h0));

wire b1_ras_int_picked = ~que_cas_picked & b1_ras_pend_req & (((que_ras_bank_picked_d1 == 8'h1) |
        (que_ras_bank_picked_d1 == 8'h80) & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h40) & ~b7_ras_pend_req & ~b0_ras_pend_req  |
        (que_ras_bank_picked_d1 == 8'h20) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b0_ras_pend_req|
        (que_ras_bank_picked_d1 == 8'h10) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h8) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h4) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req & ~b3_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h2) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req & ~b3_ras_pend_req & ~b2_ras_pend_req & ~b0_ras_pend_req) |
		(que_ras_bank_picked_d1 == 8'h0) & ~b0_ras_pend_req);

wire b2_ras_int_picked = ~que_cas_picked & b2_ras_pend_req & (((que_ras_bank_picked_d1 == 8'h2) |
        (que_ras_bank_picked_d1 == 8'h1) & ~b1_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h80) & ~b1_ras_pend_req & ~b0_ras_pend_req  |
        (que_ras_bank_picked_d1 == 8'h40) & ~b7_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req|
        (que_ras_bank_picked_d1 == 8'h20) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b1_ras_pend_req&
                ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h10) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b1_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h8) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h4) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req & ~b3_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req) |
		(que_ras_bank_picked_d1 == 8'h0) & ~b0_ras_pend_req & ~b1_ras_pend_req);

wire b3_ras_int_picked = ~que_cas_picked & b3_ras_pend_req & (((que_ras_bank_picked_d1 == 8'h4) |
        (que_ras_bank_picked_d1 == 8'h2) & ~b2_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h1) & ~b1_ras_pend_req & ~b2_ras_pend_req  |
        (que_ras_bank_picked_d1 == 8'h80) & ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req|
        (que_ras_bank_picked_d1 == 8'h40) & ~b7_ras_pend_req & ~b2_ras_pend_req & ~b1_ras_pend_req&
                ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h20) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b2_ras_pend_req&
                ~b1_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h10) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h8) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req & ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req) |
		(que_ras_bank_picked_d1 == 8'h0) & ~b0_ras_pend_req & ~b1_ras_pend_req & 
		~b2_ras_pend_req);

wire b4_ras_int_picked = ~que_cas_picked & b4_ras_pend_req & (((que_ras_bank_picked_d1 == 8'h8) |
        (que_ras_bank_picked_d1 == 8'h4) & ~b3_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h2) & ~b3_ras_pend_req & ~b2_ras_pend_req  |
        (que_ras_bank_picked_d1 == 8'h1) & ~b2_ras_pend_req & ~b1_ras_pend_req & ~b3_ras_pend_req|
        (que_ras_bank_picked_d1 == 8'h80) & ~b3_ras_pend_req & ~b2_ras_pend_req & ~b1_ras_pend_req&
                ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h40) & ~b7_ras_pend_req & ~b3_ras_pend_req & ~b2_ras_pend_req&
                ~b1_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h20) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b3_ras_pend_req&
                ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h10) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b3_ras_pend_req & ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req) |
                (que_ras_bank_picked_d1 == 8'h0) & ~b0_ras_pend_req & ~b1_ras_pend_req &
                ~b2_ras_pend_req & ~b3_ras_pend_req);

wire b5_ras_int_picked = ~que_cas_picked & b5_ras_pend_req & (((que_ras_bank_picked_d1 == 8'h10) |
        (que_ras_bank_picked_d1 == 8'h8) & ~b4_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h4) & ~b3_ras_pend_req & ~b4_ras_pend_req  |
        (que_ras_bank_picked_d1 == 8'h2) & ~b2_ras_pend_req & ~b4_ras_pend_req & ~b3_ras_pend_req|
        (que_ras_bank_picked_d1 == 8'h1) & ~b3_ras_pend_req & ~b2_ras_pend_req & ~b1_ras_pend_req&
                ~b4_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h80) & ~b4_ras_pend_req & ~b3_ras_pend_req & ~b2_ras_pend_req&
                ~b1_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h40) & ~b7_ras_pend_req & ~b4_ras_pend_req & ~b3_ras_pend_req&
                ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h20) & ~b7_ras_pend_req & ~b6_ras_pend_req & ~b4_ras_pend_req&
                ~b3_ras_pend_req & ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req) |
                (que_ras_bank_picked_d1 == 8'h0) & ~b0_ras_pend_req & ~b1_ras_pend_req &
                ~b2_ras_pend_req & ~b3_ras_pend_req & ~b4_ras_pend_req);

wire b6_ras_int_picked = ~que_cas_picked & b6_ras_pend_req & (((que_ras_bank_picked_d1 == 8'h20) |
        (que_ras_bank_picked_d1 == 8'h10) & ~b5_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h8) & ~b5_ras_pend_req & ~b4_ras_pend_req  |
        (que_ras_bank_picked_d1 == 8'h4) & ~b5_ras_pend_req & ~b4_ras_pend_req & ~b3_ras_pend_req|
        (que_ras_bank_picked_d1 == 8'h2) & ~b3_ras_pend_req & ~b2_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h1) & ~b4_ras_pend_req & ~b3_ras_pend_req & ~b2_ras_pend_req&
                ~b1_ras_pend_req & ~b5_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h80) & ~b5_ras_pend_req & ~b4_ras_pend_req & ~b3_ras_pend_req&
                ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h40) & ~b7_ras_pend_req & ~b5_ras_pend_req & ~b4_ras_pend_req&
                ~b3_ras_pend_req & ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req) |
                (que_ras_bank_picked_d1 == 8'h0) & ~b0_ras_pend_req & ~b1_ras_pend_req &
                ~b2_ras_pend_req & ~b3_ras_pend_req & ~b4_ras_pend_req & ~b5_ras_pend_req);

wire b7_ras_int_picked = ~que_cas_picked & b7_ras_pend_req & (((que_ras_bank_picked_d1 == 8'h40) |
        (que_ras_bank_picked_d1 == 8'h20) & ~b6_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h10) & ~b5_ras_pend_req & ~b6_ras_pend_req  |
        (que_ras_bank_picked_d1 == 8'h8) & ~b5_ras_pend_req & ~b4_ras_pend_req & ~b6_ras_pend_req|
        (que_ras_bank_picked_d1 == 8'h4) & ~b3_ras_pend_req & ~b6_ras_pend_req & ~b5_ras_pend_req&
                ~b4_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h2) & ~b4_ras_pend_req & ~b3_ras_pend_req & ~b2_ras_pend_req&
                ~b6_ras_pend_req & ~b5_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h1) & ~b5_ras_pend_req & ~b4_ras_pend_req & ~b3_ras_pend_req&
                ~b2_ras_pend_req & ~b1_ras_pend_req & ~b6_ras_pend_req |
        (que_ras_bank_picked_d1 == 8'h80) & ~b6_ras_pend_req & ~b5_ras_pend_req & ~b4_ras_pend_req&
                ~b3_ras_pend_req & ~b2_ras_pend_req & ~b1_ras_pend_req & ~b0_ras_pend_req) |
                (que_ras_bank_picked_d1 == 8'h0) & ~b0_ras_pend_req & ~b1_ras_pend_req &
      ~b2_ras_pend_req & ~b3_ras_pend_req & ~b4_ras_pend_req & ~b5_ras_pend_req & ~b6_ras_pend_req);

assign b0_ras_picked = (que_channel_disabled ? ch0_que_ras_int_picked[0] : b0_ras_int_picked) & ~que_hw_selfrsh;
assign b1_ras_picked = (que_channel_disabled ? ch0_que_ras_int_picked[1] : b1_ras_int_picked) & ~que_hw_selfrsh;
assign b2_ras_picked = (que_channel_disabled ? ch0_que_ras_int_picked[2] : b2_ras_int_picked) & ~que_hw_selfrsh;
assign b3_ras_picked = (que_channel_disabled ? ch0_que_ras_int_picked[3] : b3_ras_int_picked) & ~que_hw_selfrsh;
assign b4_ras_picked = (que_channel_disabled ? ch0_que_ras_int_picked[4] : b4_ras_int_picked) & ~que_hw_selfrsh;
assign b5_ras_picked = (que_channel_disabled ? ch0_que_ras_int_picked[5] : b5_ras_int_picked) & ~que_hw_selfrsh;
assign b6_ras_picked = (que_channel_disabled ? ch0_que_ras_int_picked[6] : b6_ras_int_picked) & ~que_hw_selfrsh;
assign b7_ras_picked = (que_channel_disabled ? ch0_que_ras_int_picked[7] : b7_ras_int_picked) & ~que_hw_selfrsh;

// Refresh needs to be sent when que_pos == 5'hc, so should not pick ras/cas this cycle. 
// REFRESH/RAS/CAS picked this cycle sent followig cycle to I/O
assign que_cas_valid[7:0] = {8{~(que_pos == 5'hc)}} & 
				{b7_cas_info[20], b6_cas_info[20], b5_cas_info[20],
				b4_cas_info[20], b3_cas_info[20], b2_cas_info[20],
				b1_cas_info[20], b0_cas_info[20]};

wire [1:0] b0_phy_bank_bits = {b0_cas_info[27], b0_cas_info[30]};
wire [1:0] b1_phy_bank_bits = {b1_cas_info[27], b1_cas_info[30]};
wire [1:0] b2_phy_bank_bits = {b2_cas_info[27], b2_cas_info[30]};
wire [1:0] b3_phy_bank_bits = {b3_cas_info[27], b3_cas_info[30]};
wire [1:0] b4_phy_bank_bits = {b4_cas_info[27], b4_cas_info[30]};
wire [1:0] b5_phy_bank_bits = {b5_cas_info[27], b5_cas_info[30]};
wire [1:0] b6_phy_bank_bits = {b6_cas_info[27], b6_cas_info[30]};
wire [1:0] b7_phy_bank_bits = {b7_cas_info[27], b7_cas_info[30]};

// To not starve CAS pending requests for a long time due to weird cases, I introduced a 
// counter that could help to get over long latency issues for some requests.
// If the CAS request is waiting to get picked for more than 64 cycles (8 bit counter)
// then automatically stop the picking any new RAS requests.

assign b0_cas_cnt_in = que_cas_valid[0] & (b0_cas_cnt[7:0] == 8'hff) ? b0_cas_cnt[7:0] :
			que_cas_valid[0] ? b0_cas_cnt[7:0] + 8'h1 : 8'h0;

dffrl_ns #(8) 	ff_cas0_cnt(
                .din(b0_cas_cnt_in[7:0]),
                .q(b0_cas_cnt[7:0]), 
		.rst_l(que_cas_valid[0]),
                .clk(clk));

assign b1_cas_cnt_in = que_cas_valid[1] & (b1_cas_cnt[7:0] == 8'hff) ? b1_cas_cnt[7:0] :
                        que_cas_valid[1] ? b1_cas_cnt[7:0] + 8'h1 : 8'h0;
                 
dffrl_ns #(8)   ff_cas1_cnt(
                .din(b1_cas_cnt_in[7:0]),
                .q(b1_cas_cnt[7:0]),    
                .rst_l(que_cas_valid[1]),      
                .clk(clk)); 

assign b2_cas_cnt_in = que_cas_valid[2] & (b2_cas_cnt[7:0] == 8'hff) ? b2_cas_cnt[7:0] :
                        que_cas_valid[2] ? b2_cas_cnt[7:0] + 8'h1 : 8'h0;
                 
dffrl_ns #(8)   ff_cas2_cnt(
                .din(b2_cas_cnt_in[7:0]),
                .q(b2_cas_cnt[7:0]),    
                .rst_l(que_cas_valid[2]),      
                .clk(clk));  

assign b3_cas_cnt_in = que_cas_valid[3] & (b3_cas_cnt[7:0] == 8'hff) ? b3_cas_cnt[7:0] :
                        que_cas_valid[3] ? b3_cas_cnt[7:0] + 8'h1 : 8'h0;
                 
dffrl_ns #(8)   ff_cas3_cnt(
                .din(b3_cas_cnt_in[7:0]),
                .q(b3_cas_cnt[7:0]),    
                .rst_l(que_cas_valid[3]),      
                .clk(clk));  

assign b4_cas_cnt_in = que_cas_valid[4] & (b4_cas_cnt[7:0] == 8'hff) ? b4_cas_cnt[7:0] :
                        que_cas_valid[4] ? b4_cas_cnt[7:0] + 8'h1 : 8'h0;
                 
dffrl_ns #(8)   ff_cas4_cnt(
                .din(b4_cas_cnt_in[7:0]),
                .q(b4_cas_cnt[7:0]),    
                .rst_l(que_cas_valid[4]),      
                .clk(clk));  

assign b5_cas_cnt_in = que_cas_valid[5] & (b5_cas_cnt[7:0] == 8'hff) ? b5_cas_cnt[7:0] :
                        que_cas_valid[5] ? b5_cas_cnt[7:0] + 8'h1 : 8'h0;
                 
dffrl_ns #(8)   ff_cas5_cnt(
                .din(b5_cas_cnt_in[7:0]),
                .q(b5_cas_cnt[7:0]),    
                .rst_l(que_cas_valid[5]),      
                .clk(clk));  

assign b6_cas_cnt_in = que_cas_valid[6] & (b6_cas_cnt[7:0] == 8'hff) ? b6_cas_cnt[7:0] :
                        que_cas_valid[6] ? b6_cas_cnt[7:0] + 8'h1 : 8'h0;
                 
dffrl_ns #(8)   ff_cas6_cnt(
                .din(b6_cas_cnt_in[7:0]),
                .q(b6_cas_cnt[7:0]),    
                .rst_l(que_cas_valid[6]),      
                .clk(clk));  

assign b7_cas_cnt_in = que_cas_valid[7] & (b7_cas_cnt[7:0] == 8'hff) ? b7_cas_cnt[7:0] :
                        que_cas_valid[7] ? b7_cas_cnt[7:0] + 8'h1 : 8'h0;
                 
dffrl_ns #(8)   ff_cas7_cnt(
                .din(b7_cas_cnt_in[7:0]),
                .q(b7_cas_cnt[7:0]),    
                .rst_l(que_cas_valid[7]),      
                .clk(clk));  

assign b0_cas_pend_req = que_cas_valid[0] & b0_rcd_cnt_is_zero & 
			(~que_phy_bank_wait | b0_phy_bank_bits == que_phy_bank_picked) &
			(b0_cas_info[19] & rtw_cnt_is_zero & wtw_cnt_is_zero |
                	~b0_cas_info[19] & wtr_cnt_is_zero & rtr_cnt_is_zero);
assign b1_cas_pend_req = que_cas_valid[1] & b1_rcd_cnt_is_zero & 
			(~que_phy_bank_wait | b1_phy_bank_bits == que_phy_bank_picked) &
			(b1_cas_info[19] & rtw_cnt_is_zero & wtw_cnt_is_zero |
                	~b1_cas_info[19] & wtr_cnt_is_zero & rtr_cnt_is_zero);
assign b2_cas_pend_req = que_cas_valid[2] & b2_rcd_cnt_is_zero & 
			(~que_phy_bank_wait | b2_phy_bank_bits == que_phy_bank_picked) &
			(b2_cas_info[19] & rtw_cnt_is_zero & wtw_cnt_is_zero |
                	~b2_cas_info[19] & wtr_cnt_is_zero & rtr_cnt_is_zero);
assign b3_cas_pend_req = que_cas_valid[3] & b3_rcd_cnt_is_zero & 
			(~que_phy_bank_wait | b3_phy_bank_bits == que_phy_bank_picked) &
			(b3_cas_info[19] & rtw_cnt_is_zero & wtw_cnt_is_zero |
                	~b3_cas_info[19] & wtr_cnt_is_zero & rtr_cnt_is_zero);
assign b4_cas_pend_req = que_cas_valid[4] & b4_rcd_cnt_is_zero & 
			(~que_phy_bank_wait | b4_phy_bank_bits == que_phy_bank_picked) &
			(b4_cas_info[19] & rtw_cnt_is_zero & wtw_cnt_is_zero |
                	~b4_cas_info[19] & wtr_cnt_is_zero & rtr_cnt_is_zero);
assign b5_cas_pend_req = que_cas_valid[5] & b5_rcd_cnt_is_zero & 
			(~que_phy_bank_wait | b5_phy_bank_bits == que_phy_bank_picked) &
			(b5_cas_info[19] & rtw_cnt_is_zero & wtw_cnt_is_zero |
                	~b5_cas_info[19] & wtr_cnt_is_zero & rtr_cnt_is_zero);
assign b6_cas_pend_req = que_cas_valid[6] & b6_rcd_cnt_is_zero & 
			(~que_phy_bank_wait | b6_phy_bank_bits == que_phy_bank_picked) &
			(b6_cas_info[19] & rtw_cnt_is_zero & wtw_cnt_is_zero |
                	~b6_cas_info[19] & wtr_cnt_is_zero & rtr_cnt_is_zero);
assign b7_cas_pend_req = que_cas_valid[7] & b7_rcd_cnt_is_zero & 
			(~que_phy_bank_wait | b7_phy_bank_bits == que_phy_bank_picked) &
			(b7_cas_info[19] & rtw_cnt_is_zero & wtw_cnt_is_zero |
                	~b7_cas_info[19] & wtr_cnt_is_zero & rtr_cnt_is_zero);

assign b0_cas_picked = b0_cas_pend_req & (((que_cas_bank_picked_d1 == 8'h80) |
	(que_cas_bank_picked_d1 == 8'h40) & ~b7_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h20) & ~b7_cas_pend_req & ~b6_cas_pend_req  |
	(que_cas_bank_picked_d1 == 8'h10) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req|
	(que_cas_bank_picked_d1 == 8'h8) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h4) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req & ~b3_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h2) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req & ~b3_cas_pend_req & ~b2_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h1) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req & ~b3_cas_pend_req & ~b2_cas_pend_req & ~b1_cas_pend_req) |
		(que_cas_bank_picked_d1 == 8'h0));

assign b1_cas_picked = b1_cas_pend_req & (((que_cas_bank_picked_d1 == 8'h1) |
	(que_cas_bank_picked_d1 == 8'h80) & ~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h40) & ~b7_cas_pend_req & ~b0_cas_pend_req  |
	(que_cas_bank_picked_d1 == 8'h20) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b0_cas_pend_req|
	(que_cas_bank_picked_d1 == 8'h10) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h8) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req & ~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h4) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req & ~b3_cas_pend_req & ~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h2) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req & ~b3_cas_pend_req & ~b2_cas_pend_req & ~b0_cas_pend_req) |
		(que_cas_bank_picked_d1 == 8'h0) & ~b0_cas_pend_req);

assign b2_cas_picked = b2_cas_pend_req & (((que_cas_bank_picked_d1 == 8'h2) |
	(que_cas_bank_picked_d1 == 8'h1) & ~b1_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h80) & ~b1_cas_pend_req & ~b0_cas_pend_req  |
	(que_cas_bank_picked_d1 == 8'h40) & ~b7_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req|
	(que_cas_bank_picked_d1 == 8'h20) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b1_cas_pend_req&
 		~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h10) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b1_cas_pend_req & ~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h8) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h4) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req & ~b3_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req) |
		(que_cas_bank_picked_d1 == 8'h0) & ~b0_cas_pend_req & ~b1_cas_pend_req);

assign b3_cas_picked = b3_cas_pend_req & (((que_cas_bank_picked_d1 == 8'h4) |
	(que_cas_bank_picked_d1 == 8'h2) & ~b2_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h1) & ~b1_cas_pend_req & ~b2_cas_pend_req  |
	(que_cas_bank_picked_d1 == 8'h80) & ~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req|
	(que_cas_bank_picked_d1 == 8'h40) & ~b7_cas_pend_req & ~b2_cas_pend_req & ~b1_cas_pend_req&
 		~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h20) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b2_cas_pend_req&
 		~b1_cas_pend_req & ~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h10) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req |
	(que_cas_bank_picked_d1 == 8'h8) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
 		~b4_cas_pend_req & ~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req) |
		(que_cas_bank_picked_d1 == 8'h0) & ~b0_cas_pend_req & ~b1_cas_pend_req & 
		~b2_cas_pend_req);

assign b4_cas_picked = b4_cas_pend_req & (((que_cas_bank_picked_d1 == 8'h8) |
        (que_cas_bank_picked_d1 == 8'h4) & ~b3_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h2) & ~b3_cas_pend_req & ~b2_cas_pend_req  |
        (que_cas_bank_picked_d1 == 8'h1) & ~b2_cas_pend_req & ~b1_cas_pend_req & ~b3_cas_pend_req|
        (que_cas_bank_picked_d1 == 8'h80) & ~b3_cas_pend_req & ~b2_cas_pend_req & ~b1_cas_pend_req&
                ~b0_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h40) & ~b7_cas_pend_req & ~b3_cas_pend_req & ~b2_cas_pend_req&
                ~b1_cas_pend_req & ~b0_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h20) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b3_cas_pend_req&
                ~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h10) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
                ~b3_cas_pend_req & ~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req) |
                (que_cas_bank_picked_d1 == 8'h0) & ~b0_cas_pend_req & ~b1_cas_pend_req &
                ~b2_cas_pend_req & ~b3_cas_pend_req);

assign b5_cas_picked = b5_cas_pend_req & (((que_cas_bank_picked_d1 == 8'h10) |
        (que_cas_bank_picked_d1 == 8'h8) & ~b4_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h4) & ~b3_cas_pend_req & ~b4_cas_pend_req  |
        (que_cas_bank_picked_d1 == 8'h2) & ~b2_cas_pend_req & ~b4_cas_pend_req & ~b3_cas_pend_req|
        (que_cas_bank_picked_d1 == 8'h1) & ~b3_cas_pend_req & ~b2_cas_pend_req & ~b1_cas_pend_req&
                ~b4_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h80) & ~b4_cas_pend_req & ~b3_cas_pend_req & ~b2_cas_pend_req&
                ~b1_cas_pend_req & ~b0_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h40) & ~b7_cas_pend_req & ~b4_cas_pend_req & ~b3_cas_pend_req&
                ~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h20) & ~b7_cas_pend_req & ~b6_cas_pend_req & ~b4_cas_pend_req&
                ~b3_cas_pend_req & ~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req) |
                (que_cas_bank_picked_d1 == 8'h0) & ~b0_cas_pend_req & ~b1_cas_pend_req &
                ~b2_cas_pend_req & ~b3_cas_pend_req & ~b4_cas_pend_req);

assign b6_cas_picked = b6_cas_pend_req & (((que_cas_bank_picked_d1 == 8'h20) |
        (que_cas_bank_picked_d1 == 8'h10) & ~b5_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h8) & ~b5_cas_pend_req & ~b4_cas_pend_req  |
        (que_cas_bank_picked_d1 == 8'h4) & ~b5_cas_pend_req & ~b4_cas_pend_req & ~b3_cas_pend_req|
        (que_cas_bank_picked_d1 == 8'h2) & ~b3_cas_pend_req & ~b2_cas_pend_req & ~b5_cas_pend_req&
                ~b4_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h1) & ~b4_cas_pend_req & ~b3_cas_pend_req & ~b2_cas_pend_req&
                ~b1_cas_pend_req & ~b5_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h80) & ~b5_cas_pend_req & ~b4_cas_pend_req & ~b3_cas_pend_req&
                ~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h40) & ~b7_cas_pend_req & ~b5_cas_pend_req & ~b4_cas_pend_req&
                ~b3_cas_pend_req & ~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req) |
                (que_cas_bank_picked_d1 == 8'h0) & ~b0_cas_pend_req & ~b1_cas_pend_req &
                ~b2_cas_pend_req & ~b3_cas_pend_req & ~b4_cas_pend_req & ~b5_cas_pend_req);

assign b7_cas_picked = b7_cas_pend_req & (((que_cas_bank_picked_d1 == 8'h40) |
        (que_cas_bank_picked_d1 == 8'h20) & ~b6_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h10) & ~b5_cas_pend_req & ~b6_cas_pend_req  |
        (que_cas_bank_picked_d1 == 8'h8) & ~b5_cas_pend_req & ~b4_cas_pend_req & ~b6_cas_pend_req|
        (que_cas_bank_picked_d1 == 8'h4) & ~b3_cas_pend_req & ~b6_cas_pend_req & ~b5_cas_pend_req&
                ~b4_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h2) & ~b4_cas_pend_req & ~b3_cas_pend_req & ~b2_cas_pend_req&
                ~b6_cas_pend_req & ~b5_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h1) & ~b5_cas_pend_req & ~b4_cas_pend_req & ~b3_cas_pend_req&
                ~b2_cas_pend_req & ~b1_cas_pend_req & ~b6_cas_pend_req |
        (que_cas_bank_picked_d1 == 8'h80) & ~b6_cas_pend_req & ~b5_cas_pend_req & ~b4_cas_pend_req&
                ~b3_cas_pend_req & ~b2_cas_pend_req & ~b1_cas_pend_req & ~b0_cas_pend_req) |
                (que_cas_bank_picked_d1 == 8'h0) & ~b0_cas_pend_req & ~b1_cas_pend_req &
    ~b2_cas_pend_req & ~b3_cas_pend_req & ~b4_cas_pend_req & ~b5_cas_pend_req & ~b6_cas_pend_req);

// RANK PICKED IS KEPT TRACK HERE
wire que_phy_bank_picked_en = |que_cas_picked_d1[7:0];

dffrle_ns #(1)  ff_rank_picked(
                .din(que_mux_rank_adr_d1),
                .q(que_rank_picked),
                .rst_l(rst_l),
                .en(que_phy_bank_picked_en),
                .clk(clk));

dffrle_ns #(1)  ff_rank_cmd_picked(
                .din(que_mux_write_en),
                .q(que_phy_bank_cmd_picked),
                .rst_l(rst_l),
                .en(que_phy_bank_picked_en),
                .clk(clk));

wire que_phy_bank_wait_reset = ~rst_l | 
				(que_phy_bank_cmd_picked ? rtw_cnt_is_zero & wtw_cnt_is_zero :
				rtr_cnt_is_zero & wtr_cnt_is_zero);

dffrle_ns #(1)  ff_phy_bank_bubble(
                .din(1'b1),
                .q(que_phy_bank_wait),
                .rst_l(~que_phy_bank_wait_reset),
                .en(que_phy_bank_picked_en),
                .clk(clk));

// CHIP SELECT PICKED IS KEPT TRACK HERE

dffrle_ns #(1)  ff_cs_picked(
                .din(que_mux_stack_adr_d1),
                .q(que_cs_picked),
                .rst_l(rst_l),
                .en(que_phy_bank_picked_en),
                .clk(clk));

// PHYSICAL BANK PICKED

assign que_phy_bank_picked = {que_rank_picked, que_cs_picked};

//////////////////////////////////////////////////////////////////
// Generate signals necessary for Muxing RAS and CAS address - RAS PICKED
//////////////////////////////////////////////////////////////////

wire [2:0]	que_b0_rd_index_picked;
wire [35:0]	que_b0_rd_addr_picked;
wire [2:0]	que_b0_rd_id_picked;
wire [2:0]	que_b0_wr_index_picked;
wire [35:0]	que_b0_wr_addr_picked;
wire [2:0]	que_b0_wr_id_picked;

assign que_ras_picked[7:0] = {b7_ras_picked, b6_ras_picked, b5_ras_picked,
				b4_ras_picked, b3_ras_picked, b2_ras_picked,
				b1_ras_picked, b0_ras_picked};

assign que_ras_int_picked[7:0] = {b7_ras_int_picked, b6_ras_int_picked, b5_ras_int_picked,
				b4_ras_int_picked, b3_ras_int_picked, b2_ras_int_picked,
				b1_ras_int_picked, b0_ras_int_picked};

assign que_scrb_picked = (que_scrb_indx_val[7:0] == que_ras_picked[7:0]) & (|que_ras_picked[7:0]) &
				(que_scrb_read_valid | que_scrb_write_valid);

assign que_scrb_rd_picked = (que_scrb_indx_val[7:0] == que_ras_picked[7:0]) & (|que_ras_picked[7:0]) &
				(que_scrb_read_valid & ~que_scrb_write_valid);

assign que_b0_index0_picked = (que_b0_indx0_val[7:0] == que_ras_picked[7:0]);
assign que_b0_index1_picked = (que_b0_indx1_val[7:0] == que_ras_picked[7:0]);
assign que_b0_index2_picked = (que_b0_indx2_val[7:0] == que_ras_picked[7:0]);
assign que_b0_index3_picked = (que_b0_indx3_val[7:0] == que_ras_picked[7:0]);
assign que_b0_index4_picked = (que_b0_indx4_val[7:0] == que_ras_picked[7:0]);
assign que_b0_index5_picked = (que_b0_indx5_val[7:0] == que_ras_picked[7:0]);
assign que_b0_index6_picked = (que_b0_indx6_val[7:0] == que_ras_picked[7:0]);
assign que_b0_index7_picked = (que_b0_indx7_val[7:0] == que_ras_picked[7:0]);

wire que_rd_addr_picked_vld = que_b0_rd_picked & (|que_ras_picked[7:0]);

assign que_b0_wr_index0_picked = (que_b0_wr_indx0_val[7:0] == que_ras_picked[7:0]);
assign que_b0_wr_index1_picked = (que_b0_wr_indx1_val[7:0] == que_ras_picked[7:0]);
assign que_b0_wr_index2_picked = (que_b0_wr_indx2_val[7:0] == que_ras_picked[7:0]);
assign que_b0_wr_index3_picked = (que_b0_wr_indx3_val[7:0] == que_ras_picked[7:0]);
assign que_b0_wr_index4_picked = (que_b0_wr_indx4_val[7:0] == que_ras_picked[7:0]);
assign que_b0_wr_index5_picked = (que_b0_wr_indx5_val[7:0] == que_ras_picked[7:0]);
assign que_b0_wr_index6_picked = (que_b0_wr_indx6_val[7:0] == que_ras_picked[7:0]);
assign que_b0_wr_index7_picked = (que_b0_wr_indx7_val[7:0] == que_ras_picked[7:0]);

assign que_b0_rd_index_picked = que_b0_index7_picked ? que_b0_index_ent7[5:3] :
                                que_b0_index6_picked ? que_b0_index_ent6[5:3] :
                                que_b0_index5_picked ? que_b0_index_ent5[5:3] : 
				que_b0_index4_picked ? que_b0_index_ent4[5:3] :
				que_b0_index3_picked ? que_b0_index_ent3[5:3] :
                                que_b0_index2_picked ? que_b0_index_ent2[5:3] :
                                que_b0_index1_picked ? que_b0_index_ent1[5:3] : 
					que_b0_index_ent0[5:3]; 
	
assign que_b0_rd_addr_picked = (que_b0_rd_index_picked == 3'h4) ? readqbank0addr4[35:0] :
                                (que_b0_rd_index_picked == 3'h5) ? readqbank0addr5[35:0] :
                                (que_b0_rd_index_picked == 3'h6) ? readqbank0addr6[35:0] :
                                (que_b0_rd_index_picked == 3'h7) ? readqbank0addr7[35:0] :
                                (que_b0_rd_index_picked == 3'h1) ? readqbank0addr1[35:0] :
                                (que_b0_rd_index_picked == 3'h2) ? readqbank0addr2[35:0] :
                                (que_b0_rd_index_picked == 3'h3) ? readqbank0addr3[35:0] : 
					readqbank0addr0[35:0]; 

assign que_b0_rd_id_picked = (que_b0_rd_index_picked == 3'h4) ? readqbank0id4[2:0] :
                                (que_b0_rd_index_picked == 3'h5) ? readqbank0id5[2:0] :
                                (que_b0_rd_index_picked == 3'h6) ? readqbank0id6[2:0] :
                                (que_b0_rd_index_picked == 3'h7) ? readqbank0id7[2:0] : 
                                (que_b0_rd_index_picked == 3'h1) ? readqbank0id1[2:0] :
                                (que_b0_rd_index_picked == 3'h2) ? readqbank0id2[2:0] :
                                (que_b0_rd_index_picked == 3'h3) ? readqbank0id3[2:0] : 
					readqbank0id0[2:0]; 

assign que_b0_wr_index_picked = que_b0_wr_index7_picked ? que_b0_wr_index_ent7[5:3] :
                                que_b0_wr_index6_picked ? que_b0_wr_index_ent6[5:3] :
                                que_b0_wr_index5_picked ? que_b0_wr_index_ent5[5:3] :
                                que_b0_wr_index4_picked ? que_b0_wr_index_ent4[5:3] :
                                que_b0_wr_index3_picked ? que_b0_wr_index_ent3[5:3] :
                                que_b0_wr_index2_picked ? que_b0_wr_index_ent2[5:3] :
                                que_b0_wr_index1_picked ? que_b0_wr_index_ent1[5:3] : 
					que_b0_wr_index_ent0[5:3];

assign que_b0_wr_addr_picked = (que_b0_wr_index_picked == 3'h4) ? writeqbank0addr4[35:0] :
                                (que_b0_wr_index_picked == 3'h5) ? writeqbank0addr5[35:0] :
                                (que_b0_wr_index_picked == 3'h6) ? writeqbank0addr6[35:0] :
                                (que_b0_wr_index_picked == 3'h7) ? writeqbank0addr7[35:0] :
                                (que_b0_wr_index_picked == 3'h1) ? writeqbank0addr1[35:0] :
                                (que_b0_wr_index_picked == 3'h2) ? writeqbank0addr2[35:0] :
                                (que_b0_wr_index_picked == 3'h3) ? writeqbank0addr3[35:0] : 
					writeqbank0addr0[35:0]; 

assign que_b0_wr_id_picked = (que_b0_wr_index_picked == 3'h4) ? writeqaddr4[2:0] :
                                (que_b0_wr_index_picked == 3'h5) ? writeqaddr5[2:0] :
                                (que_b0_wr_index_picked == 3'h6) ? writeqaddr6[2:0] :
                                (que_b0_wr_index_picked == 3'h7) ? writeqaddr7[2:0] :
                                (que_b0_wr_index_picked == 3'h1) ? writeqaddr1[2:0] :
                                (que_b0_wr_index_picked == 3'h2) ? writeqaddr2[2:0] :
                                (que_b0_wr_index_picked == 3'h3) ? writeqaddr3[2:0] : 
					writeqaddr0[2:0]; 

// Check for whether read index matches with write index. If does then writes
// need to go ahead of read or else read can go with its priorotiy over writes.

// The offset of the requests don't need to be compared as they are to the same cacheline.
wire [31:0] que_rd_addr_picked = {que_b0_rd_addr_picked[35], que_b0_rd_addr_picked[33], 
					que_b0_rd_addr_picked[31:5], que_b0_rd_addr_picked[2:0]};

wire que_wr_addr_picked_vld = que_b0_wr_index0_picked | que_b0_wr_index1_picked | 
				que_b0_wr_index2_picked | que_b0_wr_index3_picked | 
				que_b0_wr_index4_picked | que_b0_wr_index5_picked |
				que_b0_wr_index6_picked | que_b0_wr_index7_picked;

assign que_b0_wr_index_pend = (
        (que_rd_addr_picked[31:0] == {writeqbank0addr0[35], writeqbank0addr0[33], writeqbank0addr0[31:5], 
			writeqbank0addr0[2:0]}) & writeqbank0vld0_arb |
        (que_rd_addr_picked[31:0] == {writeqbank0addr1[35], writeqbank0addr1[33], writeqbank0addr1[31:5],
			writeqbank0addr1[2:0]}) & writeqbank0vld1_arb |
        (que_rd_addr_picked[31:0] == {writeqbank0addr2[35], writeqbank0addr2[33], writeqbank0addr2[31:5],
			writeqbank0addr2[2:0]}) & writeqbank0vld2_arb |
        (que_rd_addr_picked[31:0] == {writeqbank0addr3[35], writeqbank0addr3[33], writeqbank0addr3[31:5],
			writeqbank0addr3[2:0]}) & writeqbank0vld3_arb |
        (que_rd_addr_picked[31:0] == {writeqbank0addr4[35], writeqbank0addr4[33], writeqbank0addr4[31:5],
			writeqbank0addr4[2:0]}) & writeqbank0vld4_arb |
        (que_rd_addr_picked[31:0] == {writeqbank0addr5[35], writeqbank0addr5[33], writeqbank0addr5[31:5],
			writeqbank0addr5[2:0]}) & writeqbank0vld5_arb |
        (que_rd_addr_picked[31:0] == {writeqbank0addr6[35], writeqbank0addr6[33], writeqbank0addr6[31:5],
			writeqbank0addr6[2:0]}) & writeqbank0vld6_arb |
        (que_rd_addr_picked[31:0] == {writeqbank0addr7[35], writeqbank0addr7[33], writeqbank0addr7[31:5],
			writeqbank0addr7[2:0]}) & writeqbank0vld7_arb) & que_wr_addr_picked_vld &
			que_rd_addr_picked_vld;

// Pick either read or write based on info on the top
assign que_b0_rd_picked = que_b0_index0_picked | que_b0_index1_picked | que_b0_index2_picked |
                   	que_b0_index3_picked | que_b0_index4_picked | que_b0_index5_picked |
			que_b0_index6_picked | que_b0_index7_picked;
assign que_b0_wr_picked = que_b0_wr_index0_picked | que_b0_wr_index1_picked | 
				que_b0_wr_index2_picked | que_b0_wr_index3_picked | 
				que_b0_wr_index4_picked | que_b0_wr_index5_picked | 
				que_b0_wr_index6_picked | que_b0_wr_index7_picked;

// Making sure stores are not starved
// Keep a counter that triggers on que_b0_wrq_full 
// and reaches a max cnt. Then give writes pref over reads 
// till it counts down to 0.

wire [5:0]	que_wr_starve_cnt_in;
wire [5:0]	que_wr_starve_cnt;
wire		que_pick_wr_first;

wire que_wr_starve_cnt_rst_l = rst_l & (que_b0_wrq_full | que_pick_wr_first);
assign que_wr_starve_cnt_in[5:0] = que_pick_wr_first ? que_wr_starve_cnt[5:0] - 6'h1 :
							que_wr_starve_cnt[5:0] + 6'h1;

dffrl_ns #(6) 	ff_wr_starve_cnt(
                .din(que_wr_starve_cnt_in[5:0]),
                .q(que_wr_starve_cnt[5:0]),
                .rst_l(que_wr_starve_cnt_rst_l),
                .clk(clk));

wire que_pick_wr_first_in = (que_wr_starve_cnt[5:0] == 6'h3e) ;
wire que_pick_wr_first_rst_l = rst_l & ~(que_wr_starve_cnt[5:0] == 6'h0);

dffrle_ns #(1) 	ff_pick_wr_first(
                .din(que_pick_wr_first_in),
                .q(que_pick_wr_first),
		.en(que_pick_wr_first_in),
                .rst_l(que_pick_wr_first_rst_l),
                .clk(clk));

// Priority picking of reads and writes
assign que_b0_addr_picked = (que_b0_wr_index_pend & que_b0_rd_picked | 
		que_pick_wr_first & que_b0_wr_picked) ? que_b0_wr_addr_picked[35:0] :
                                que_b0_rd_picked ? que_b0_rd_addr_picked[35:0] :
                                que_b0_wr_picked ? que_b0_wr_addr_picked[35:0] : 
					que_rd_addr0[35:0];

assign que_b0_id_picked = (que_b0_wr_index_pend & que_b0_rd_picked | 
				que_pick_wr_first & que_b0_wr_picked) ? que_b0_wr_id_picked[2:0] :
                                que_b0_rd_picked ? que_b0_rd_id_picked[2:0] :
                                que_b0_wr_picked ? que_b0_wr_id_picked[2:0] : que_rd_id0;

assign que_b0_cmd_picked = (que_b0_wr_index_pend & que_b0_rd_picked | 
				que_pick_wr_first & que_b0_wr_picked) ? 1'b1 :
                                que_b0_rd_picked ? 1'b0 :
                                que_b0_wr_picked ? 1'b1 : 1'b0;

assign que_b0_index_picked = (que_b0_wr_index_pend & que_b0_rd_picked | 
				que_pick_wr_first & que_b0_wr_picked) ? que_b0_wr_index_picked :
                                que_b0_rd_picked ? que_b0_rd_index_picked :
                                que_b0_wr_picked ? que_b0_wr_index_picked : que_rd_addr_in;

// Pick between CH0 and CH1
wire [35:0] que_ch01_addr_picked = que_channel_picked_internal ? ch1_que_b0_addr_picked : 
								que_b0_addr_picked;
wire [2:0] que_ch01_id_picked = que_channel_picked_internal ? ch1_que_b0_id_picked : 
								que_b0_id_picked;
wire [2:0] que_ch01_index_picked = que_channel_picked_internal ? ch1_que_b0_index_picked : 
								que_b0_index_picked;
wire que_ch01_cmd_picked = que_channel_picked_internal ? ch1_que_b0_cmd_picked : que_b0_cmd_picked;

// Finally picked stuff
assign que_scrb_addr_p1[32:0] = two_channel_mode ? 
			{1'b0, que_scrb_rank_addr, que_scrb_stack_addr, que_scrb_ras_addr[14:0], 
					que_scrb_cas_addr[8:0], que_scrb_bank[2:0], 3'h0} :
			{que_scrb_rank_addr, que_scrb_stack_addr, que_scrb_ras_addr[14:0], 
					que_scrb_cas_addr[8:0], que_scrb_bank[2:0], 4'h0};

// Flop enable to hold the address till the ecc address error can capture this.
dff_ns #(1) ff_scrb_wr_vld_d1(
                .din(que_scrb_write_valid),
                .q(que_scrb_write_valid_d1),
                .clk(clk));

// Enable change only when write valid is not asserted. This way ecc error in read data 
// captures correct scrub PA.

wire que_scrb_addr_en = ~que_scrb_write_valid_d1;

dffrle_ns #(33) ff_scrb_addr(
                .din(que_scrb_addr_p1[32:0]),
                .q(que_scrb_addr[32:0]),
                .rst_l(rst_l),
                .en(que_scrb_addr_en),
                .clk(clk));

wire [35:0]	que_split_scrb_addr_hi;
wire [35:0]	que_split_scrb_addr_lo;

assign two_channel_mode = que_channel_disabled | other_que_channel_disabled;

// Generate bank, ras, cas and addr error signals for wr addr.

/*dram_addr_gen AUTO_TEMPLATE( .addr_err(que_split_scrb_addr_hi[32]),
                              .addr_parity(que_split_scrb_addr_hi[34]),
                              .stack_adr (que_split_scrb_addr_hi[33]),
                              .rank_adr (que_split_scrb_addr_hi[35]),
                              .ras_adr  (que_split_scrb_addr_hi[31:17]),
                              .cas_adr  (que_split_scrb_addr_hi[16:3]),
                              .bank_adr (que_split_scrb_addr_hi[2:0]),
                              // Inputs
                              .addr_in  ({3'h0, que_scrb_addr[32:0]}),
                              .eight_bank_mode(que_eight_bank_mode),
                              .rank1_present(que_rank1_present),
                              .two_channel_mode(two_channel_mode),
                              .config_reg(config_reg[8:0])); */

/*dram_addr_gen_lo AUTO_TEMPLATE( .addr_err(que_split_scrb_addr_lo[32]),
                              .addr_parity(que_split_scrb_addr_lo[34]),
                              .stack_adr (que_split_scrb_addr_lo[33]),
                              .rank_adr (que_split_scrb_addr_lo[35]),
                              .ras_adr  (que_split_scrb_addr_lo[31:17]),
                              .cas_adr  (que_split_scrb_addr_lo[16:3]),
                              .bank_adr (que_split_scrb_addr_lo[2:0]),
                              // Inputs
                              .addr_in  ({3'h0, que_scrb_addr[32:0]}),
                              .eight_bank_mode(que_eight_bank_mode),
                              .rank1_present(que_rank1_present),
                              .two_channel_mode(two_channel_mode),
                              .config_reg(config_reg[8:0])); */

dram_addr_gen scrub_addr_gen(/*AUTOINST*/
			     // Outputs
			     .addr_parity(que_split_scrb_addr_hi[34]), // Templated
			     .addr_err	(que_split_scrb_addr_hi[32]), // Templated
			     .rank_adr	(que_split_scrb_addr_hi[35]), // Templated
			     .stack_adr	(que_split_scrb_addr_hi[33]), // Templated
			     .bank_adr	(que_split_scrb_addr_hi[2:0]), // Templated
			     .ras_adr	(que_split_scrb_addr_hi[31:17]), // Templated
			     .cas_adr	(que_split_scrb_addr_hi[16:3]), // Templated
			     // Inputs
			     .addr_in	({3'h0, que_scrb_addr[32:0]}), // Templated
			     .config_reg(config_reg[8:0]),	 // Templated
			     .rank1_present(que_rank1_present),	 // Templated
			     .eight_bank_mode(que_eight_bank_mode), // Templated
			     .two_channel_mode(two_channel_mode)); // Templated
dram_addr_gen_lo scrub_addr_gen_lo( /*AUTOINST*/
				   // Outputs
				   .addr_parity(que_split_scrb_addr_lo[34]), // Templated
				   .addr_err(que_split_scrb_addr_lo[32]), // Templated
				   .rank_adr(que_split_scrb_addr_lo[35]), // Templated
				   .stack_adr(que_split_scrb_addr_lo[33]), // Templated
				   .bank_adr(que_split_scrb_addr_lo[2:0]), // Templated
				   .ras_adr(que_split_scrb_addr_lo[31:17]), // Templated
				   .cas_adr(que_split_scrb_addr_lo[16:3]), // Templated
				   // Inputs
				   .addr_in({3'h0, que_scrb_addr[32:0]}), // Templated
				   .config_reg(config_reg[8:0]), // Templated
				   .rank1_present(que_rank1_present), // Templated
				   .eight_bank_mode(que_eight_bank_mode), // Templated
				   .two_channel_mode(two_channel_mode)); // Templated
assign que_split_scrb_addr = que_addr_bank_low_sel ? que_split_scrb_addr_lo : 
					que_split_scrb_addr_hi;

assign que_scrb_bank_valid[7:0] = {8{que_scrb_read_valid | que_scrb_write_valid}} & 
		{que_split_scrb_addr[2:0] == 3'h7, que_split_scrb_addr[2:0] == 3'h6, 
			que_split_scrb_addr[2:0] == 3'h5, que_split_scrb_addr[2:0] == 3'h4, 
			que_split_scrb_addr[2:0] == 3'h3, que_split_scrb_addr[2:0] == 3'h2, 
			que_split_scrb_addr[2:0] == 3'h1, que_split_scrb_addr[2:0] == 3'h0};

wire	que_dram_addr_err;
wire	que_rank_adr;
wire	que_addr_err;
wire	que_addr_parity;
wire	que_stack_adr;

wire [35:0] que_scrb_addr_picked = que_scrb_picked ? que_split_scrb_addr[35:0] : 
				que_ch01_addr_picked[35:0];
assign que_rank_adr = que_scrb_addr_picked[35];
assign que_addr_parity = que_scrb_addr_picked[34];
assign que_stack_adr = que_scrb_addr_picked[33];
assign que_addr_err = que_scrb_addr_picked[32];
assign que_ras_adr = que_scrb_addr_picked[31:17];
assign que_cas_adr = que_scrb_addr_picked[16:3];
assign que_bank_adr = que_scrb_addr_picked[2:0];
assign que_id_picked = que_ch01_id_picked;
assign que_index_picked = que_ch01_index_picked; 
assign que_cmd_picked = que_scrb_picked ? que_scrb_write_valid : que_ch01_cmd_picked;
assign que_dram_addr_err = que_addr_err;

//////////////////////////////////////////////////////////////////
// Write the cas and command info to the buffers.
// This stores the command id also till the command is issued.
// It has valid bit, read(0)/write(1), id and cas value.
//////////////////////////////////////////////////////////////////

assign que_bank0_cas_valid = ~b0_cas_picked;
assign que_bank1_cas_valid = ~b1_cas_picked;
assign que_bank2_cas_valid = ~b2_cas_picked;
assign que_bank3_cas_valid = ~b3_cas_picked;
assign que_bank4_cas_valid = ~b4_cas_picked;
assign que_bank5_cas_valid = ~b5_cas_picked;
assign que_bank6_cas_valid = ~b6_cas_picked;
assign que_bank7_cas_valid = ~b7_cas_picked;
assign que_bank0_cas_en = ~que_channel_disabled & (b0_ras_picked | b0_cas_picked);
assign que_bank1_cas_en = ~que_channel_disabled & (b1_ras_picked | b1_cas_picked);
assign que_bank2_cas_en = ~que_channel_disabled & (b2_ras_picked | b2_cas_picked);
assign que_bank3_cas_en = ~que_channel_disabled & (b3_ras_picked | b3_cas_picked);
assign que_bank4_cas_en = ~que_channel_disabled & (b4_ras_picked | b4_cas_picked);
assign que_bank5_cas_en = ~que_channel_disabled & (b5_ras_picked | b5_cas_picked);
assign que_bank6_cas_en = ~que_channel_disabled & (b6_ras_picked | b6_cas_picked);
assign que_bank7_cas_en = ~que_channel_disabled & (b7_ras_picked | b7_cas_picked);

dffrle_ns #(32)     bank0_cas(
                .din({que_addr_parity, 
			que_stack_adr, que_channel_picked_internal, que_dram_addr_err, 
			que_rank_adr, que_id_picked[2], que_scrb_rd_picked, 
			que_index_picked[2:0], que_scrb_picked, que_bank0_cas_valid,
			que_cmd_picked, que_id_picked[1:0], que_cas_adr[13:0], 
			que_bank_adr[2:0]}),
                .rst_l(rst_l),
                .en(que_bank0_cas_en),
                .q(b0_cas_info[31:0]),
                .clk(clk));

dffrle_ns #(32)     bank1_cas(
                .din({que_addr_parity, 
			que_stack_adr, que_channel_picked_internal, que_dram_addr_err, 
			que_rank_adr, que_id_picked[2], que_scrb_rd_picked, 
			que_index_picked[2:0], que_scrb_picked, que_bank1_cas_valid,
			que_cmd_picked, que_id_picked[1:0], que_cas_adr[13:0], 
			que_bank_adr[2:0]}),
                .rst_l(rst_l),
                .en(que_bank1_cas_en),
                .q(b1_cas_info[31:0]),
                .clk(clk));

dffrle_ns #(32)     bank2_cas(
                .din({que_addr_parity, 
			que_stack_adr, que_channel_picked_internal, que_dram_addr_err, 
			que_rank_adr, que_id_picked[2], que_scrb_rd_picked, 
			que_index_picked[2:0], que_scrb_picked, que_bank2_cas_valid,
			que_cmd_picked, que_id_picked[1:0], que_cas_adr[13:0], 
			que_bank_adr[2:0]}),
                .rst_l(rst_l),
                .en(que_bank2_cas_en),
                .q(b2_cas_info[31:0]),
                .clk(clk));

dffrle_ns #(32)     bank3_cas(
                .din({que_addr_parity, 
			que_stack_adr, que_channel_picked_internal, que_dram_addr_err, 
			que_rank_adr, que_id_picked[2], que_scrb_rd_picked, 
			que_index_picked[2:0], que_scrb_picked, que_bank3_cas_valid,
			que_cmd_picked, que_id_picked[1:0], que_cas_adr[13:0], 
			que_bank_adr[2:0]}),
                .rst_l(rst_l),
                .en(que_bank3_cas_en),
                .q(b3_cas_info[31:0]),
                .clk(clk));

dffrle_ns #(32)     bank4_cas(
                .din({que_addr_parity, 
			que_stack_adr, que_channel_picked_internal, que_dram_addr_err, 
			que_rank_adr, que_id_picked[2], que_scrb_rd_picked, 
			que_index_picked[2:0], que_scrb_picked, que_bank4_cas_valid,
			que_cmd_picked, que_id_picked[1:0], que_cas_adr[13:0], 
			que_bank_adr[2:0]}),
                .rst_l(rst_l),
                .en(que_bank4_cas_en),
                .q(b4_cas_info[31:0]),
                .clk(clk));

dffrle_ns #(32)     bank5_cas(
                .din({que_addr_parity, 
			que_stack_adr, que_channel_picked_internal, que_dram_addr_err, 
			que_rank_adr, que_id_picked[2], que_scrb_rd_picked, 
			que_index_picked[2:0], que_scrb_picked, que_bank5_cas_valid,
			que_cmd_picked, que_id_picked[1:0], que_cas_adr[13:0], 
			que_bank_adr[2:0]}),
                .rst_l(rst_l),
                .en(que_bank5_cas_en),
                .q(b5_cas_info[31:0]),
                .clk(clk));

dffrle_ns #(32)     bank6_cas(
                .din({que_addr_parity, 
			que_stack_adr, que_channel_picked_internal, que_dram_addr_err, 
			que_rank_adr, que_id_picked[2], que_scrb_rd_picked, 
			que_index_picked[2:0], que_scrb_picked, que_bank6_cas_valid,
			que_cmd_picked, que_id_picked[1:0], que_cas_adr[13:0], 
			que_bank_adr[2:0]}),
                .rst_l(rst_l),
                .en(que_bank6_cas_en),
                .q(b6_cas_info[31:0]),
                .clk(clk));

dffrle_ns #(32)     bank7_cas(
                .din({que_addr_parity, 
			que_stack_adr, que_channel_picked_internal, que_dram_addr_err, 
			que_rank_adr, que_id_picked[2], que_scrb_rd_picked, 
			que_index_picked[2:0], que_scrb_picked, que_bank7_cas_valid,
			que_cmd_picked, que_id_picked[1:0], que_cas_adr[13:0], 
			que_bank_adr[2:0]}),
                .rst_l(rst_l),
                .en(que_bank7_cas_en),
                .q(b7_cas_info[31:0]),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Generating the signals to the pads
//////////////////////////////////////////////////////////////////
wire [14:0]	que_ras_adr_d1;
wire [14:0]	que_mux_cas_adr_d1;
wire [2:0]	que_bank_adr_d1;
wire [2:0]	que_mux_bank_adr_d1;

dff_ns #(8)    ff_cas_picked(
                .din({b7_cas_picked, b6_cas_picked, b5_cas_picked,
			b4_cas_picked, b3_cas_picked, b2_cas_picked,
			b1_cas_picked, b0_cas_picked}),
                .q(que_cas_picked_d1[7:0]), 
                .clk(clk));

dffe_ns #(8)    ff_cas_picked_io(
                .din({b7_cas_picked, b6_cas_picked, b5_cas_picked,
			b4_cas_picked, b3_cas_picked, b2_cas_picked,
			b1_cas_picked, b0_cas_picked}),
                .q(que_cas_picked_io_d1[7:0]), 
		.en(~que_channel_disabled),
                .clk(clk));

dff_ns #(8)    ff_ras_picked(
                .din(que_ras_picked[7:0]),
                .q(que_ras_picked_d1[7:0]), 
                .clk(clk));

dffe_ns #(8)    ff_ras_picked_io(
                .din(que_ras_picked[7:0]),
                .q(que_ras_picked_io_d1[7:0]), 
		.en(~que_channel_disabled),
                .clk(clk));

dffe_ns #(15)   ff_ras_adr(
                .din(que_ras_adr[14:0]),
                .q(que_ras_adr_d1[14:0]), 
		.en(~que_channel_disabled),
                .clk(clk));

dffe_ns #(15)   ff_cas_adr(
                .din(que_mux_cas_adr[14:0]),
                .q(que_mux_cas_adr_d1[14:0]), 
		.en(~que_channel_disabled),
                .clk(clk));

dffe_ns #(3)    ff_bank_adr(
                .din(que_bank_adr[2:0]),
                .q(que_bank_adr_d1[2:0]), 
		.en(~que_channel_disabled),
                .clk(clk));

dffe_ns #(1)    ff_rank_adr(
                .din(que_rank_adr),
                .q(que_rank_adr_d1), 
		.en(~que_channel_disabled),
                .clk(clk));

dffe_ns #(1)    ff_stack_adr(
                .din(que_stack_adr),
                .q(que_stack_adr_d1), 
		.en(~que_channel_disabled),
                .clk(clk));

dffe_ns #(1)    ff_mux_rank_adr(
                .din(que_mux_rank_adr),
                .q(que_mux_rank_adr_d1), 
		.en(~que_channel_disabled),
                .clk(clk));

dffe_ns #(1)    ff_mux_stack_adr(
                .din(que_mux_stack_adr),
                .q(que_mux_stack_adr_d1), 
		.en(~que_channel_disabled),
                .clk(clk));

dffe_ns #(3)    ff_mux_bank_adr(
                .din(que_mux_bank_adr[2:0]),
                .q(que_mux_bank_adr_d1[2:0]), 
		.en(~que_channel_disabled),
                .clk(clk));

dffe_ns #(1)    ff_mux_wr_en(
                .din(que_mux_write_en),
                .q(que_mux_write_en_d1), 
		.en(~que_channel_disabled),
                .clk(clk));

assign que_mux_cas_adr = b7_cas_picked ? {1'b0, b7_cas_info[16:3]} :
			b6_cas_picked ? {1'b0, b6_cas_info[16:3]} :
			b5_cas_picked ? {1'b0, b5_cas_info[16:3]} :
			b4_cas_picked ? {1'b0, b4_cas_info[16:3]} :
			b3_cas_picked ? {1'b0, b3_cas_info[16:3]} :
			b2_cas_picked ? {1'b0, b2_cas_info[16:3]} :
			b1_cas_picked ? {1'b0, b1_cas_info[16:3]} : {1'b0, b0_cas_info[16:3]};
assign que_mux_bank_adr = b7_cas_picked ? b7_cas_info[2:0] :
			b6_cas_picked ? b6_cas_info[2:0] :
			b5_cas_picked ? b5_cas_info[2:0] :
			b4_cas_picked ? b4_cas_info[2:0] :
			b3_cas_picked ? b3_cas_info[2:0] :
			b2_cas_picked ? b2_cas_info[2:0] :
			b1_cas_picked ? b1_cas_info[2:0] : b0_cas_info[2:0];
assign que_mux_write_en = b7_cas_picked ? b7_cas_info[19] :
			b6_cas_picked ? b6_cas_info[19] :	
			b5_cas_picked ? b5_cas_info[19] :	
			b4_cas_picked ? b4_cas_info[19] :	
			b3_cas_picked ? b3_cas_info[19] :	
			b2_cas_picked ? b2_cas_info[19] :	
			b1_cas_picked ? b1_cas_info[19] : 
			b0_cas_picked ? b0_cas_info[19] : 1'b0;
assign que_mux_rank_adr = b7_cas_picked ? b7_cas_info[27] :
                        b6_cas_picked ? b6_cas_info[27] :
                        b5_cas_picked ? b5_cas_info[27] :
                        b4_cas_picked ? b4_cas_info[27] :
                        b3_cas_picked ? b3_cas_info[27] :
                        b2_cas_picked ? b2_cas_info[27] :
                        b1_cas_picked ? b1_cas_info[27] : b0_cas_info[27];
assign que_mux_stack_adr = b7_cas_picked ? b7_cas_info[30] :
                        b6_cas_picked ? b6_cas_info[30] :
                        b5_cas_picked ? b5_cas_info[30] :
                        b4_cas_picked ? b4_cas_info[30] :
                        b3_cas_picked ? b3_cas_info[30] :
                        b2_cas_picked ? b2_cas_info[30] :
                        b1_cas_picked ? b1_cas_info[30] : b0_cas_info[30];

assign que_write_en_int = que_mux_write_en_d1 & (|que_cas_picked_io_d1[7:0]);

assign dram_io_cs_l[1:0] = que_mux_special_data ?  que_po_cs_l[1:0] : 
			(|que_ras_picked_io_d1[7:0] & ~que_rank_adr_d1) ?  
					(que_stack_adr_d1 ? 2'b01 : 2'b10) : 
			(|que_cas_picked_io_d1[7:0] & ~que_mux_rank_adr_d1) ?  
					(que_mux_stack_adr_d1 ? 2'b01 : 2'b10) : 2'b11;

assign dram_io_cs_l[3:2] = que_mux_special_data ?  que_po_cs_l[3:2] : 
			(|que_ras_picked_io_d1[7:0] & que_rank_adr_d1) ?  
					(que_stack_adr_d1 ? 2'b01 : 2'b10) : 
			(|que_cas_picked_io_d1[7:0] & que_mux_rank_adr_d1) ?  
					(que_mux_stack_adr_d1 ? 2'b01 : 2'b10) : 2'b11;

assign dram_io_addr[14:0] =  que_mux_special_data ? que_po_addr :
		|que_ras_picked_io_d1[7:0] ? que_ras_adr_d1 : que_mux_cas_adr_d1;
assign dram_io_bank[2:0] = que_mux_special_data ? que_po_bank :
		|que_ras_picked_io_d1[7:0] ? que_bank_adr_d1[2:0] : que_mux_bank_adr_d1[2:0];
assign dram_io_ras_l = que_mux_special_data ? que_po_ras_l : 
				~(|que_ras_picked_io_d1[7:0]);
assign dram_io_cas_l = que_mux_special_data ? que_po_cas_l : 
				~(|que_cas_picked_io_d1[7:0]);
assign dram_io_write_en_l = que_mux_special_data ? que_po_write_en_l : ~que_write_en_int;

assign config_reg[8:0] = chip_config_reg[8:0];
assign dram_io_channel_disabled = que_channel_disabled;

// SOFTWARE PROGRAMMED PAD ENABLE

assign dram_io_sw_mux_cnt_in = dram_io_sw_mux_cnt + 2'h1;
assign dram_io_sw_mux_cnt_en = (|dram_io_sw_mux_cnt[1:0]) | dram_io_pad_enable;

dffrle_ns #(2)  ff_sw_pad_en(
                .din(dram_io_sw_mux_cnt_in),
                .q(dram_io_sw_mux_cnt),
		.en(dram_io_sw_mux_cnt_en),
		.rst_l(rst_l),
                .clk(clk));

assign dram_io_pad_enable_in = (que_tot_data_del_cnt[3:0] - 4'h2 == que_b0_data_rtn_cnt[3:0]) |
				(que_tot_data_del_cnt[3:0] - 4'h2 == que_b1_data_rtn_cnt[3:0]) |
				(que_tot_data_del_cnt[3:0] - 4'h2 == que_b2_data_rtn_cnt[3:0]) |
				(que_tot_data_del_cnt[3:0] - 4'h2 == que_b3_data_rtn_cnt[3:0]) |
				(que_tot_data_del_cnt[3:0] - 4'h2 == que_b4_data_rtn_cnt[3:0]) |
				(que_tot_data_del_cnt[3:0] - 4'h2 == que_b5_data_rtn_cnt[3:0]) |
				(que_tot_data_del_cnt[3:0] - 4'h2 == que_b6_data_rtn_cnt[3:0]) |
				(que_tot_data_del_cnt[3:0] - 4'h2 == que_b7_data_rtn_cnt[3:0]); 

dffrl_ns #(1)   ff_pad_en(
                .din(dram_io_pad_enable_in),
                .q(dram_io_pad_enable), 
		.rst_l(rst_l),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Generating the signals to store data buffer for READING DATA
//////////////////////////////////////////////////////////////////

wire		que_write_addr_updt;
wire [3:0]	que_b0_data_addr_1p;

assign  que_b0_wr_data_addr_picked[2:0] = 
			  	b0_cas_picked ? {b0_cas_info[26], b0_cas_info[18:17]} :
                               	b1_cas_picked ? {b1_cas_info[26], b1_cas_info[18:17]} :
                               	b2_cas_picked ? {b2_cas_info[26], b2_cas_info[18:17]} :
                               	b3_cas_picked ? {b3_cas_info[26], b3_cas_info[18:17]} :
                               	b4_cas_picked ? {b4_cas_info[26], b4_cas_info[18:17]} :
                               	b5_cas_picked ? {b5_cas_info[26], b5_cas_info[18:17]} :
                               	b6_cas_picked ? {b6_cas_info[26], b6_cas_info[18:17]} : 
                               			{b7_cas_info[26], b7_cas_info[18:17]};

assign que_write_addr_updt = que_mux_write_en & (b7_cas_picked | b6_cas_picked | 
			b5_cas_picked | b4_cas_picked | b3_cas_picked | 
			b2_cas_picked | b1_cas_picked | b0_cas_picked );

// There is a corner case where the write que gets deallocated 
// and a new request tries to write to the data buffer but
// the data is not read out to send to dram. So we need to delay
// the invalidation of the write buffer. 

wire		que_wl_cas_ch01_picked0;
wire		que_wl_cas_ch01_picked0_d1;
wire [3:0]	que_wl_index01_picked0;
wire [3:0]	que_wl_index01_picked0_d1;
wire		que_wl_data_addr0_load_d1;
wire		que_wl_data_addr0_load;
wire		que_wl_addr_parity0;
wire [3:0]	que_wl_data_addr0;
wire [3:0]	que_wl_data_addr0_d1;
wire		que_wl_scrb_wr_req0;

wire [3:0] que_wr_index01_picked = b7_cas_picked ? {b7_cas_info[19], b7_cas_info[24:22]} :
			b6_cas_picked ? {b6_cas_info[19], b6_cas_info[24:22]} :	
			b5_cas_picked ? {b5_cas_info[19], b5_cas_info[24:22]} :	
			b4_cas_picked ? {b4_cas_info[19], b4_cas_info[24:22]} :	
			b3_cas_picked ? {b3_cas_info[19], b3_cas_info[24:22]} :	
			b2_cas_picked ? {b2_cas_info[19], b2_cas_info[24:22]} :	
			b1_cas_picked ? {b1_cas_info[19], b1_cas_info[24:22]} : 
				{b0_cas_info[19], b0_cas_info[24:22]};

wire que_wr_cas_ch01_picked = b7_cas_picked ? b7_cas_info[29] :
				b6_cas_picked ? b6_cas_info[29] :
				b5_cas_picked ? b5_cas_info[29] :
				b4_cas_picked ? b4_cas_info[29] :
				b3_cas_picked ? b3_cas_info[29] :
				b2_cas_picked ? b2_cas_info[29] :
				b1_cas_picked ? b1_cas_info[29] : b0_cas_info[29];

wire [3:0] que_index01_picked_p1 = que_wl_index01_picked0_d1; 
wire que_cas_ch01_picked_p1 = que_wl_cas_ch01_picked0_d1; 
wire que_wr_picked_p1 = que_wl_data_addr0_load_d1;

dff_ns #(6) ff_wr_que_reset_ch01_picked (
        .din    ({que_wr_picked_p1, que_index01_picked_p1, que_cas_ch01_picked_p1}),
        .q      ({que_int_wr_picked, que_int_index01_picked, que_int_cas_ch01_picked}),
        .clk    (clk));

// for DDR-II we have to wait WL = RL-1 = AL+CL-1 = CL-1 as AL=0 here.

assign que_cl2_stg_info[11:0] = {que_write_addr_updt, {que_b0_wr_data_addr_picked[2:0], 1'h0}, 
			que_scrb_write_req, que_l2if_send_info_in[9], que_wr_index01_picked, 
			que_wr_cas_ch01_picked};

// Staging Flops for covering 2 to 5 CL.

dffrl_ns #(12)   ff_cl3_stg(
                .din(que_cl2_stg_info[11:0]),
                .q(que_cl3_stg_info[11:0]),
		.rst_l(rst_l),
                .clk(clk));

dffrl_ns #(12)   ff_cl4_stg(
                .din(que_cl3_stg_info[11:0]),
                .q(que_cl4_stg_info[11:0]),
		.rst_l(rst_l),
                .clk(clk));

dffrl_ns #(12)   ff_cl5_stg(
                .din(que_cl4_stg_info[11:0]),
                .q(que_cl5_stg_info[11:0]),
		.rst_l(rst_l),
                .clk(clk));

assign {que_wl_data_addr0_load, que_wl_data_addr0, que_wl_scrb_wr_req0, que_wl_addr_parity0, 
                que_wl_index01_picked0, que_wl_cas_ch01_picked0} = 
					(mode_reg[6:4] == 3'h2) ? que_cl2_stg_info[11:0] :
					(mode_reg[6:4] == 3'h3) ? que_cl3_stg_info[11:0] :
					(mode_reg[6:4] == 3'h4) ? que_cl4_stg_info[11:0] : 
								  que_cl5_stg_info[11:0]; 
						
dff_ns #(12)   ff_sel_info(
                .din({que_wl_data_addr0_load, que_wl_data_addr0, que_wl_scrb_wr_req0, 
			que_wl_addr_parity0, que_wl_index01_picked0, que_wl_cas_ch01_picked0}), 
                .q({que_wl_data_addr0_load_d1, que_wl_data_addr0_d1, que_wl_scrb_wr_req0_d1, 
			que_wl_addr_parity0_d1, que_wl_index01_picked0_d1, 
			que_wl_cas_ch01_picked0_d1}), 
                .clk(clk));

// generating the memory address to read data
assign que_b0_data_addr_1p = que_wl_data_addr0_load_d1 ? que_wl_data_addr0_d1 + 4'h1 :
				que_wl_data_addr0; 
				
// generating active low mem read enable
wire que_b0_data_en_1p = ~( que_wl_data_addr0_load  & ~que_wl_scrb_wr_req0 | 
				que_wl_data_addr0_load_d1 & ~que_wl_scrb_wr_req0_d1);

// generating the channel that needs to read the data from memory
wire que_b0_cas_ch01_picked_1p = que_wl_data_addr0_load_d1 ? que_wl_cas_ch01_picked0_d1 : que_wl_cas_ch01_picked0;

dffrl_ns #(6)   ff_mem_addr(
                .din({que_b0_cas_ch01_picked_1p, que_b0_data_en_1p, que_b0_data_addr_1p[3:0]}),
                .q(que_b0_data_addr[5:0]),
		.rst_l(rst_l),
                .clk(clk));

assign que_mem_addr[3:0] = que_channel_disabled ? ch0_que_b0_data_addr[3:0] : que_b0_data_addr[3:0];
wire [1:0] que_mem_addr_en = que_channel_disabled ? ch0_que_b0_data_addr[5:4] : que_b0_data_addr[5:4];
assign que_mem_addr[4] = que_mem_addr_en[0] | ~(que_mem_addr_en[1] == que_channel_disabled);

// This free entry is sent one cycle later than it could have been becuase
// the entry could be used for in few cpu cycles by another pending wr 
// but the read could be still happening as its rd enable is flopped in memory.
// que_mem_addr[4] is only low when memory is read so free that location during then.
// It is valid for two cycles but no problem as [3:1] is not changed. 
// Need to also assert free entry valid for 1 cycle so reset next cycle after asserting it.

wire [3:0]	que_wr_entry_free_p1;

dffrl_ns #(4)  	ff_entry_free(
                .din({~que_mem_addr[4] & ~que_wr_entry_free_p1[3], que_mem_addr[3:1]}),
                .q(que_wr_entry_free_p1[3:0]),
		.rst_l(rst_l),
                .clk(clk));

// Have to delay freeing entry one more cycle because the second read for memlocation 
// could be going on while a new entry is allocated and writing to it. 

dff_ns #(4)  	ff_entry_free_d1(
                .din(que_wr_entry_free_p1),
                .q(que_wr_entry_free[3:0]),
                .clk(clk));

///////
// Stage the address parity bit so that store data ecc can be XORed with this bit.
///////

wire que_st_cmd_addr_parity = que_wl_addr_parity0_d1;

/////////////////////////////////////////////////////////////////////
// Generating driver enable for the dq and dqs pad.
/////////////////////////////////////////////////////////////////////

// for DDR-II we have to wait WL = RL-1 = AL+CL-1 = CL-1 as AL=0 here.

wire que_drive_dqs = que_wl_data_addr0_load_d1;

dffrl_ns #(1)   ff_write_en(
                .din(que_drive_dqs),
                .q(que_drive_dqs_1f),
                .rst_l(rst_l),
                .clk(clk));

assign que_burst_wr_cnt_in = que_burst_wr_cnt + 1'b1;
assign que_burst_write_cnt_en = que_drive_dqs_1f | que_burst_wr_cnt;

dffrle_ns #(1)  ff_burst_wr_cnt(
                .din(que_burst_wr_cnt_in),
                .q(que_burst_wr_cnt),
                .rst_l(rst_l),
                .en(que_burst_write_cnt_en),
                .clk(clk));

wire dram_io_drive_data_1p = que_drive_dqs_1f | que_burst_wr_cnt | que_channel_disabled;
wire dram_io_drive_enable_1p = dram_io_drive_data_1p | que_drive_dqs | que_channel_disabled;

dffrl_ns #(1)  	ff_drive_data(
                .din(dram_io_drive_data_1p),
                .q(dram_io_drive_data), 
		.rst_l(rst_l),
                .clk(clk));

dffrl_ns #(1)  	ff_drive_enable(
                .din(dram_io_drive_enable_1p),
                .q(dram_io_drive_enable), 
		.rst_l(rst_l),
                .clk(clk));

/////////////////////////////////////////////////////
// Generate signal for bypass of scrub. 
// Also this signal needs to be staged after it got picked up to align with data.
/////////////////////////////////////////////////////

// NEED TO ADJUST THIS SO THAT WL = RL -1

assign que_scrb_write_req = que_mux_write_en & 
			(b7_cas_picked ? b7_cas_info[21] & ~b7_cas_info[25] :
			b6_cas_picked ? b6_cas_info[21] & ~b6_cas_info[25] :	
			b5_cas_picked ? b5_cas_info[21] & ~b5_cas_info[25] :	
			b4_cas_picked ? b4_cas_info[21] & ~b4_cas_info[25] :	
			b3_cas_picked ? b3_cas_info[21] & ~b3_cas_info[25] :	
			b2_cas_picked ? b2_cas_info[21] & ~b2_cas_info[25] :	
			b1_cas_picked ? b1_cas_info[21] & ~b1_cas_info[25] : 
			b0_cas_picked ? b0_cas_info[21] & ~b0_cas_info[25] : 1'b0);

wire que_bypass_scrb_data_p1 = que_wl_scrb_wr_req0_d1;

dffrl_ns #(1)   ff_scrb_bypass_data(
                .din(que_bypass_scrb_data_p1),
                .q(que_int_bypass_scrb_data),
		.rst_l(rst_l),
                .clk(clk));

// NEED TO SEND CAS RELATED INFO TO OTHER CHANNEL AFTER ITS PICKED TO INV QUEUE'S
assign que_int_wr_que_inv_info = {que_int_bypass_scrb_data, que_int_wr_picked, que_int_index01_picked, 
					que_int_cas_ch01_picked};
wire [6:0] que_wr_que_inv_info = que_channel_disabled ? ch1_que_int_wr_que_inv_info : que_int_wr_que_inv_info;
assign {que_bypass_scrb_data, que_wr_picked, que_index01_picked, 
                                        que_cas_ch01_picked} = que_wr_que_inv_info[6:0];

//////////////
// For 2 channel this signal tells the wr data comming from other ch or this channel.
//////////////

//wire que_wr_channel_mux_in = que_b0_cas_ch01_picked_1p & ~que_wr_channel_mux;
//wire que_wr_channel_mux_en = que_b0_cas_ch01_picked_1p | que_wr_channel_mux;

dff_ns #(1)   	ff_wr_ch_mux(
                .din(que_b0_data_addr[5]),
                .q(que_wr_channel_mux),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Store ID and the offset for read request response
//////////////////////////////////////////////////////////////////

wire		que_l2_b0_val;

// Picking addr_err, id[2], scrub_cmd, id[1:0] and offset[2:0]
assign que_l2_send_id[8:0] = b0_cas_picked ? 
                {b0_cas_info[31], b0_cas_info[29:28], b0_cas_info[26], b0_cas_info[25], 
			b0_cas_info[18:17], b0_cas_info[4:3]} : b1_cas_picked ? 
                {b1_cas_info[31], b1_cas_info[29:28], b1_cas_info[26], b1_cas_info[25], 
			b1_cas_info[18:17], b1_cas_info[4:3]} : b2_cas_picked ? 
                {b2_cas_info[31], b2_cas_info[29:28], b2_cas_info[26], b2_cas_info[25], 
			b2_cas_info[18:17], b2_cas_info[4:3]} : b3_cas_picked ? 
                {b3_cas_info[31], b3_cas_info[29:28], b3_cas_info[26], b3_cas_info[25], 
			b3_cas_info[18:17], b3_cas_info[4:3]} : b4_cas_picked ? 
                {b4_cas_info[31], b4_cas_info[29:28], b4_cas_info[26], b4_cas_info[25], 
			b4_cas_info[18:17], b4_cas_info[4:3]} : b5_cas_picked ? 
                {b5_cas_info[31], b5_cas_info[29:28], b5_cas_info[26], b5_cas_info[25], 
			b5_cas_info[18:17], b5_cas_info[4:3]} : b6_cas_picked ? 
                {b6_cas_info[31], b6_cas_info[29:28], b6_cas_info[26], b6_cas_info[25], 
			b6_cas_info[18:17], b6_cas_info[4:3]} : b7_cas_picked ? 
                {b7_cas_info[31], b7_cas_info[29:28], b7_cas_info[26], b7_cas_info[25], 
			b7_cas_info[18:17], b7_cas_info[4:3]} : 9'h0;

assign que_l2_b0_val = que_cas_picked & ~que_l2_send_id[4] & ~que_mux_write_en; 
assign que_l2if_send_info_in = {que_l2_send_id[8:6], que_l2_b0_val, que_l2_send_id[4], 
						que_l2_send_id[5], que_l2_send_id[3:0]};

dffrl_ns #(10)  ff_l2_send_info(
                .din(que_l2if_send_info_in[9:0]),
                .q(que_l2if_send_info[9:0]),
		.rst_l(rst_l),
                .clk(clk));

// To get rid of the sync pulse to reset in cpu clk domain we use a toggle
// signal to indicate a start of new dram clk.

assign que_dram_clk_toggle_in = ~que_dram_clk_toggle;
dffrl_ns #(1)    ff_toggle_dram_clk(
                .din(que_dram_clk_toggle_in),
                .q(que_dram_clk_toggle),
		.rst_l(rst_l),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// POWER UP SEQUENCE REQUIRED LOGIC
//////////////////////////////////////////////////////////////////

reg		que_pull_cke_low;
wire		que_cke_reg;

// After power is up and 200u seconds are run down. We count
// 200us here.

// This reset should be power and clk state signal
assign dram_io_cke_p1 = que_cke_reg ? (que_pull_cke_low ? 1'b0 : 1'b1) : 1'b0;

// One nop command needs to be sent.
// Addr = 15'hxxx, RAS = 1, CAS = 1, WE = 1, BA = x;

// precharge all banks before next command
// Addr = 15'h400, RAS = 0, CAS = 1, WE = 0, BA = x;

// Write extended mode register
// Addr = 15'hxxx, RAS = 0, CAS = 0, WE = 0, BA = 2'b01;

// Wait for tMRD
// precharge all banks before next command
// Addr = 15'h400, RAS = 0, CAS = 1, WE = 0, BA = x;

// Write mode register
// Addr = 15'hxxx, RAS = 0, CAS = 0, WE = 0, BA = 2'b00;

// Wait for tMRD

assign que_po_addr_p1      = que_channel_disabled ? 15'h3fff : 
				(que_pos == 5'h3) & mrd_cnt_is_zero ? {ext_mode_reg1[14:0]} :
				(que_pos == 5'h10) & rp_cnt_is_zero ? {ext_mode_reg2[14:0]} :
				(que_pos == 5'h11) & mrd_cnt_is_zero ? {ext_mode_reg3[14:0]} :
		(que_pos == 5'h12) & mrd_cnt_is_zero ? {ext_mode_reg1[14:10], 3'h7, ext_mode_reg1[6:0]} :
		(que_pos == 5'h13) & mrd_cnt_is_zero ? {ext_mode_reg1[14:10], 3'h0, ext_mode_reg1[6:0]} :
                                (que_pos == 5'h4) & mrd_cnt_is_zero ?  {2'h0, wr_reg[3:0]-4'b1, 2'h2, mode_reg[6:0]} :
                                (que_pos == 5'h8) & rfc_cnt_is_zero ?  {2'h0, wr_reg[3:0]-4'b1, 2'h0, mode_reg[6:0]} : 
					15'h400;
assign que_po_bank_p1      = que_channel_disabled ? 3'h7 : 
				((que_pos == 5'h3) & mrd_cnt_is_zero | (que_pos == 5'h13) & mrd_cnt_is_zero | 
				(que_pos == 5'h12) & mrd_cnt_is_zero) ? 3'h1 : 
				(que_pos == 5'h10) & rp_cnt_is_zero ? 3'h2 : 
				(que_pos == 5'h11) & mrd_cnt_is_zero ? 3'h3 : 3'h0;
assign que_po_ras_l_p1     = que_channel_disabled ? 1'b1 :
			((que_pos == 5'h3) & mrd_cnt_is_zero | (que_pos == 5'h10) & rp_cnt_is_zero |
			(que_pos == 5'h11) & mrd_cnt_is_zero | (que_pos == 5'h4) & mrd_cnt_is_zero |
			(que_pos == 5'h12) & mrd_cnt_is_zero | (que_pos == 5'h13) & mrd_cnt_is_zero |
                        (que_pos == 5'h8) & rfc_cnt_is_zero | (que_pos == 5'h2) |
                        (que_pos == 5'h5) & mrd_cnt_is_zero | (que_pos == 5'hc) ) ? 1'b0 : 1'b1;
assign que_po_cas_l_p1     = que_channel_disabled ? 1'b1 :
			((que_pos == 5'h3) & mrd_cnt_is_zero | (que_pos == 5'h10) & rp_cnt_is_zero |
                        (que_pos == 5'h11) & mrd_cnt_is_zero | (que_pos == 5'h4) & mrd_cnt_is_zero |
			(que_pos == 5'h12) & mrd_cnt_is_zero | (que_pos == 5'h13) & mrd_cnt_is_zero |
                        (que_pos == 5'h8) & rfc_cnt_is_zero | (que_pos == 5'hc) ) ? 1'b0 : 1'b1;
assign que_po_write_en_l_p1 = que_channel_disabled ? 1'b1 :
			((que_pos == 5'h3) & mrd_cnt_is_zero | (que_pos == 5'h10) & rp_cnt_is_zero |
                        (que_pos == 5'h11) & mrd_cnt_is_zero | (que_pos == 5'h4) & mrd_cnt_is_zero |
			(que_pos == 5'h12) & mrd_cnt_is_zero | (que_pos == 5'h13) & mrd_cnt_is_zero |
                                (que_pos == 5'h8) & rfc_cnt_is_zero | (que_pos == 5'h2) |
                                (que_pos == 5'h5) & mrd_cnt_is_zero ) ? 1'h0 : 1'h1;
assign que_po_cs_l_p1 = (que_channel_disabled | (~dram_io_cke_p1 & ~(que_pos == 5'hc)) ) ? 4'hf :
			( (que_pos == 5'hc) & que_pull_cke_low | 
				(que_pos == 5'he) & ~que_pull_cke_low) ? 4'h0 :
			(que_pos == 5'hc | que_init_dram_done | que_pos == 5'h2 | 
					que_pos == 5'h5 & mrd_cnt_is_zero) ? 
				~({que_refresh_rank == 2'h3, que_refresh_rank == 2'h2, 
				que_refresh_rank == 2'h1, que_refresh_rank == 2'h0}) : 4'h0;

dff_ns #(26)       ff_init_cmds(
                .din({ dram_io_cke_p1, que_po_addr_p1, que_po_bank_p1, que_po_ras_l_p1, 
			que_po_cas_l_p1, que_po_write_en_l_p1, que_po_cs_l_p1}),
                .q({dram_io_cke, que_po_addr, que_po_bank, que_po_ras_l, que_po_cas_l, 
			que_po_write_en_l, que_po_cs_l}),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// STATE MACHINE TO KEEP TRACK of ABOVE COMMANDS
//////////////////////////////////////////////////////////////////

reg [4:0]	que_pos_next;
reg 		que_200us_wait_met_next;
reg 		que_second_precharge_all_in;
reg [7:0]	que_cyc_cnt_next;
wire [7:0]	que_cyc_cnt;
wire [1:0]	mrd_cnt_next;
wire [1:0]	mrd_reg;
wire [1:0]	mrd_cnt;
wire [3:0]	rp_cnt_next;
wire [3:0]	rp_cnt;
wire		que_ref_go;

dffrl_ns #(5)   ff_pos(
                .din(que_pos_next[4:0]),
                .q(que_int_pos[4:0]),
		.rst_l(rst_l),
                .clk(clk));

assign que_pos[4:0] = que_channel_disabled ? other_que_pos[4:0] : que_int_pos[4:0];

dff_ns #(8)     ff_cyc_cnt(
                .din(que_cyc_cnt_next[7:0]),
                .q(que_cyc_cnt[7:0]),
                .clk(clk));

// FLOP THE SELF REFRESH CONTROL SIGNAL

wire    que_self_ref_go_en = (que_pos == 5'ha) | (que_pos == 5'he) | (que_pos == 5'h0);

dffe_ns #(1)     ff_hw_selfref(
                .din(l2if_que_selfrsh),
                .q(que_hw_selfrsh),
                .en(que_self_ref_go_en),
                .clk(clk));

// wait for tMRD count
assign mrd_cnt_next = ( (que_pos == 5'h10) | (que_pos == 5'h11) & mrd_cnt_is_zero |
			(que_pos == 5'h12) & mrd_cnt_is_zero | (que_pos == 5'h13) & mrd_cnt_is_zero |
		(que_pos == 5'h3) & mrd_cnt_is_zero | (que_pos == 5'h4) & mrd_cnt_is_zero | 
		(que_pos == 5'h8) & rfc_cnt_is_zero ) ? mrd_reg[1:0] : 
                                ((mrd_cnt == 2'h0) ? 2'h0 : mrd_cnt - 2'h1);

dffrl_ns #(2)       ff_mrd_cnt(
                .din(mrd_cnt_next[1:0]),
                .q(mrd_cnt[1:0]),
                .rst_l(rst_l),
                .clk(clk));

assign mrd_cnt_is_zero = (mrd_cnt == 2'h0);

// wait for tRP count
assign rp_cnt_next = (que_pos == 5'h5) & mrd_cnt_is_zero | (que_pos == 5'h2) ? 
			(que_eight_bank_mode ? ((rp_reg != 4'hf) ? rp_reg[3:0] + 4'h1 : rp_reg[3:0]) : 
				rp_reg[3:0]) : ((rp_cnt == 4'h0) ? 4'h0 : rp_cnt - 4'h1);

dffrl_ns #(4)       ff_rp_cnt(
                .din(rp_cnt_next[3:0]),
                .q(rp_cnt[3:0]),
                .rst_l(rst_l),
                .clk(clk));

assign rp_cnt_is_zero = (rp_cnt == 4'h0);

// Count to clear all the requests to all banks so that refresh command could be issued.
reg		que_first_refresh_in;
reg [4:0]	que_bank_idle_cnt_next;
reg [1:0]	que_refresh_rank_in;
reg [2:0]	que_refresh_rank_cnt_in;
wire [4:0]	que_bank_idle_cnt;
wire [2:0]	que_tot_ranks;
wire [7:0]	que_precharge_wait;

dffrl_ns #(5)   ff_bank_idle_cnt(
                .din(que_bank_idle_cnt_next[4:0]),
                .q(que_bank_idle_cnt[4:0]),
                .rst_l(rst_l),
                .clk(clk));

dff_ns #(2)     ff_refresh_rank(
                .din(que_refresh_rank_in),
                .q(que_refresh_rank),
                .clk(clk));

dff_ns #(3)     ff_refresh_rank_cnt(
                .din(que_refresh_rank_cnt_in),
                .q(que_refresh_rank_cnt),
                .clk(clk));

dffrl_ns #(1)   ff_first_refresh(
                .din(que_first_refresh_in),
                .q(que_first_refresh),
		.rst_l(rst_l),
                .clk(clk));

dffrl_ns #(1)   ff_200us_wait(
                .din(que_200us_wait_met_next),
                .q(que_200us_wait_met),
		.rst_l(rst_l),
                .clk(clk));

dffrl_ns #(1)   ff_second_pre_chr_all(
                .din(que_second_precharge_all_in),
                .q(que_second_precharge_all),
		.rst_l(rst_l),
                .clk(clk));


/////////////////////////////////////////////////////////////
// MAIN STATE MACHINE THAT KEEPS TRACK OF THE CONTROLLER STATE
/////////////////////////////////////////////////////////////

always @(/*AUTOSENSE*/b0_phy_bank_bits or b1_phy_bank_bits
	 or b2_phy_bank_bits or b3_phy_bank_bits or b4_phy_bank_bits
	 or b5_phy_bank_bits or b6_phy_bank_bits or b7_phy_bank_bits
	 or chip_config_reg or dal_reg or mrd_cnt_is_zero or que_second_precharge_all
	 or que_bank_idle_cnt or que_cas_valid or que_cyc_cnt
	 or que_first_refresh or que_hw_selfrsh or que_init
	 or que_init_dram_done or que_pos or que_precharge_wait
	 or que_rank1_present or que_ref_cnt_166_200 or que_ref_go
	 or que_refresh_rank or que_refresh_rank_cnt or que_tot_ranks
	 or rfc_cnt_is_zero or rp_cnt_is_zero or que_200us_wait_met) 
begin
	que_200us_wait_met_next = que_200us_wait_met;
	que_pos_next = que_pos;
	que_cyc_cnt_next = que_cyc_cnt + 8'h1;
	que_bank_idle_cnt_next = que_bank_idle_cnt;
	que_pull_cke_low = 1'b0;
	que_refresh_rank_in = que_refresh_rank;
	que_refresh_rank_cnt_in = que_refresh_rank_cnt;
	que_first_refresh_in = que_first_refresh;
	que_second_precharge_all_in = que_second_precharge_all;
case(que_pos) 
	5'h0:	begin
			if(que_hw_selfrsh) que_pos_next = 5'he;
			else if(que_init) 
			begin
				que_pos_next = 5'h1;
				que_cyc_cnt_next = 8'h0;
			end
		end
	5'h1:	begin
			// send NOP command
			que_second_precharge_all_in = 1'b0;
			que_refresh_rank_in = 2'h0;
			que_refresh_rank_cnt_in = 3'h0;
			if(que_cyc_cnt == que_precharge_wait) begin
				que_pos_next = 5'h2;
			end
		end
	5'h2:	begin
			// send PRECHARGE command
			que_pos_next = 5'h15;
		end
	5'h3:	begin
			// send write EXT MODE1 reg command
			if(mrd_cnt_is_zero) que_pos_next = 5'h4;
		end
	5'h4:	begin
			// wait for tMRD and send write MODE reg commad
			if(mrd_cnt_is_zero) begin
				que_pos_next = 5'h5;
				que_cyc_cnt_next = 8'h0;
			end
			que_refresh_rank_in = 2'h0;
			que_refresh_rank_cnt_in = 3'h0;
		end
	5'h5:	begin
			// send PRECHARGE command
			if(mrd_cnt_is_zero) begin
				que_pos_next = 5'h15;
				que_second_precharge_all_in = 1'b1;
			end
		end
	5'h6:	begin
			// wait for tRP send AUTOREF command
			que_second_precharge_all_in = 1'b0;
			if(rp_cnt_is_zero) begin
				que_refresh_rank_in = 2'h0;
				que_refresh_rank_cnt_in = 3'h0;
				que_pos_next = 5'hc;
				que_first_refresh_in = 1'b1;
			end
		end
	5'h7:	begin
			// no need to wait for tRFC as its already done before getting here
			// send AUTOREF command
			que_first_refresh_in = 1'b0;
			que_refresh_rank_in = 2'h0;
			que_refresh_rank_cnt_in = 3'h0;
			que_pos_next = 5'hc;
		end
	5'h8:	begin
			// no need to wait for tRFC as its already done before getting here
			// send MODE reg command
			que_pos_next = 5'h9;
		end
	5'h9:	begin
			// WAIT for 200 cycles to expire from MODE reg command
			if(que_cyc_cnt >= 8'hC8) que_pos_next = 5'h12;
			que_refresh_rank_in = 2'h0;
			que_refresh_rank_cnt_in = 3'h0;
		end
	5'ha:   begin
			// IN NORMAL operation but wait for refresh requests
			if(que_ref_go | que_hw_selfrsh) que_pos_next = 5'hb;
			else que_pos_next = 5'ha;
			que_bank_idle_cnt_next = 5'h0;
		end
	5'hb:   begin
			// WAIT for pending cas requests for that rank to go and wait tDAL cycles
			// (worst case) to make the banks idle 
			if( ~((que_cas_valid[0] & (b0_phy_bank_bits == que_refresh_rank)) |
			 	(que_cas_valid[1] & (b1_phy_bank_bits == que_refresh_rank)) | 
			 	(que_cas_valid[2] & (b2_phy_bank_bits == que_refresh_rank)) | 
			 	(que_cas_valid[3] & (b3_phy_bank_bits == que_refresh_rank)) | 
			 	(que_cas_valid[4] & (b4_phy_bank_bits == que_refresh_rank)) | 
			 	(que_cas_valid[5] & (b5_phy_bank_bits == que_refresh_rank)) | 
			 	(que_cas_valid[6] & (b6_phy_bank_bits == que_refresh_rank)) | 
			 	(que_cas_valid[7] & (b7_phy_bank_bits == que_refresh_rank))) ) 
			begin
				if(que_bank_idle_cnt[3:0] == dal_reg[3:0]) 
				begin
					que_bank_idle_cnt_next = 5'h0;
					que_pos_next = 5'hc;
				end
				else que_bank_idle_cnt_next = que_bank_idle_cnt + 5'h1;
			end
		end
	5'hc:   begin
			// SEND the AUTO refresh command
			if( (que_hw_selfrsh) & 
				(que_refresh_rank_cnt == (que_tot_ranks - 3'h1)) ) 
			begin
				que_refresh_rank_in = 2'h0;
				que_refresh_rank_cnt_in = 3'h0;
				que_pos_next = 5'he;
				que_pull_cke_low = 1'h1;
				que_cyc_cnt_next = 8'h0;
			end
			else que_pos_next = 5'hd;
		end
	5'hd:   begin
			// WAIT for tRFC and back to normal operation
			if(rfc_cnt_is_zero) begin
				if(que_refresh_rank_cnt == (que_tot_ranks - 3'h1 ) ) begin
					if(que_init_dram_done) begin
						que_pos_next = 5'ha;
						// SW control to write mode regs
						if(que_init) que_pos_next = 5'h1; 	
					end
					else if(que_first_refresh) que_pos_next = 5'h7;
					else que_pos_next = 5'h8;
					que_refresh_rank_cnt_in = 3'h0;
					que_refresh_rank_in = 2'h0;
				end
				else begin
					if(que_init_dram_done) que_pos_next = 5'hb;
					else que_pos_next = 5'hc;
					que_refresh_rank_in = chip_config_reg[0] & que_rank1_present ? 
						que_refresh_rank + 2'h1 : 
						que_rank1_present ? que_refresh_rank + 2'h2 :
						chip_config_reg[0] ? {1'h0, (que_refresh_rank[0] + 1'h1)} :
						que_refresh_rank;
					que_refresh_rank_cnt_in = que_refresh_rank_cnt + 3'h1;
				end
			end
		end
	5'he:  begin
			// WAIT till self refresh bit is unset
			que_pull_cke_low = 1'h1;

			// count 200 micro sec wait after the clocks to dimms are enabled
                        // putting the count of 200usec in this counter(re using it later)
                        if(que_ref_cnt_166_200[12:0] == 13'h0) begin
                        	que_bank_idle_cnt_next = que_bank_idle_cnt + 5'h1;
                        end
                        if(que_bank_idle_cnt == 5'h1c) begin
				que_200us_wait_met_next = 1'b1;
                        end
			if(~que_hw_selfrsh & que_200us_wait_met) begin
				que_pull_cke_low = 1'h0;
				que_pos_next = 5'hf;
				que_cyc_cnt_next = 8'h0;
			end
		end
	5'hf:  begin
			// WAIT for 200 cycles after comming out of self refresh for 
			// back to normal operation
			if(que_cyc_cnt == 8'hC8) que_pos_next = 5'ha;
		end
	5'h10:  begin
			// send write EXT MODE2 reg command
			if(rp_cnt_is_zero) que_pos_next = 5'h11;
		end
	5'h11:  begin
			// send write EXT MODE3 reg command
			if(mrd_cnt_is_zero) que_pos_next = 5'h3;
		end
	5'h12:  begin
			// send write EXT MODE1 reg for OCD default command
			if(mrd_cnt_is_zero) que_pos_next = 5'h13;
		end
	5'h13:  begin
			// send write EXT MODE1 reg for OCD exit command
			if(mrd_cnt_is_zero) que_pos_next = 5'h14;
		end
	5'h14:  begin
			// wait for tOIT < 12ns to go into normal mode
			que_pos_next = 5'ha;
		end
	5'h15:  begin
			// Issue precharge all for each rank
			if(rp_cnt_is_zero) begin
				que_pos_next = 5'h2;
				que_refresh_rank_in = chip_config_reg[0] & que_rank1_present ? 
					que_refresh_rank + 2'h1 : 
					que_rank1_present ? que_refresh_rank + 2'h2 :
					chip_config_reg[0] ? {1'h0, (que_refresh_rank[0] + 1'h1)} :
					que_refresh_rank;
				que_refresh_rank_cnt_in = que_refresh_rank_cnt + 3'h1;
			end	
			if(que_refresh_rank_cnt == (que_tot_ranks - 3'h1 ) ) 
				if(que_second_precharge_all) que_pos_next = 5'h6;
				else que_pos_next = 5'h10;
		end
	default:begin
			que_pos_next = 5'ha;
		end
endcase
end

// ENABLE asserting valids and NORMAL operation

wire que_mux_special_data_in = ~((que_pos == 5'ha) | (que_pos == 5'hb) | (que_pos == 5'hd));

dff_ns #(1)     ff_mux_special_data(
                .din(que_mux_special_data_in),
                .q(que_mux_special_data),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// SOFTWARE PROGRAMMABLE REGISTER
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
// MODE REGISTER
//////////////////////////////////////////////////////////////////

assign sch_mode_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'h10);
assign mode_reg_in = ~rst_l ? mode_reg :
			que_ucb_wr_req_vld & (que_ucb_addr == 32'h10) ? 
			{que_ucb_data[2:0],mode_reg[3:0]} : mode_reg;

dffsl_async_ns #(3)    ff_mode_reg_s(
                .din({mode_reg_in[5], mode_reg_in[4], mode_reg_in[1]}),
                .set_l(arst_l),
                .q({mode_reg[5], mode_reg[4], mode_reg[1]}),
                .clk(clk));

dffrl_async_ns #(4)    ff_mode_reg_r(
                .din({mode_reg_in[6], mode_reg_in[3], mode_reg_in[2], mode_reg_in[0]}),
                .rst_l(arst_l),
                .q({mode_reg[6], mode_reg[3], mode_reg[2], mode_reg[0]}),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// EXTENDED MODE REGISTER 1
//////////////////////////////////////////////////////////////////

assign ext_mode_reg1_in = ~rst_l ? ext_mode_reg1[14:0] : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h118) ? 
				que_ucb_data[14:0] : ext_mode_reg1[14:0]; 

dffsl_async_ns #(1)   ff_ext_mode_reg1_s(
                .din(ext_mode_reg1_in[10]),
                .q(ext_mode_reg1[10]),
                .set_l(arst_l),
                .clk(clk));

dffrl_async_ns #(14)   ff_ext_mode_reg1_r(
                .din({ext_mode_reg1_in[14:11], ext_mode_reg1_in[9:0]}),
                .q({ext_mode_reg1[14:11], ext_mode_reg1[9:0]}),
		.rst_l(arst_l),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// EXTENDED MODE REGISTER 2
//////////////////////////////////////////////////////////////////

assign ext_mode_reg2_in = ~rst_l ? ext_mode_reg2[14:0] : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h110) ? 
				que_ucb_data[14:0] : ext_mode_reg2[14:0];

dffrl_async_ns #(15)   ff_ext_mode_reg2(
                .din(ext_mode_reg2_in[14:0]),
                .q(ext_mode_reg2[14:0]),
                .rst_l(arst_l),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// EXTENDED MODE REGISTER 3
//////////////////////////////////////////////////////////////////

assign ext_mode_reg3_in = ~rst_l ? ext_mode_reg3[14:0] : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h120) ? 
				que_ucb_data[14:0] : ext_mode_reg3[14:0];

dffrl_async_ns #(15)   ff_ext_mode_reg3(
                .din(ext_mode_reg3_in[14:0]),
                .q(ext_mode_reg3[14:0]),
                .rst_l(arst_l),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// CHIP CONFIGURATION REGISTER 
// 0 - set to 1 if stacked dimm 
// 1-4 cas address bits size
// 5-8 ras address bits size
// 9-20 Frequency of scrubbing
//////////////////////////////////////////////////////////////////

wire		que_stacked_dimm_en;

assign que_stacked_dimm_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'h108); 
assign chip_config_reg_in[0] = ~rst_l ? chip_config_reg[0] :
			que_ucb_wr_req_vld & (que_ucb_addr == 32'h108) ? que_ucb_data[0] :
			chip_config_reg[0]; 

dffrl_async_ns #(1)     ff_stacked_dimm(
                .din(chip_config_reg_in[0]),
                .q(chip_config_reg[0]),
		.rst_l(arst_l),
                .clk(clk));

assign chip_config_reg_in[4:1] = ~rst_l ? chip_config_reg[4:1] : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h0) ? 
				que_ucb_data[3:0] : chip_config_reg[4:1]; 

dffsl_async_ns #(3)     ff_cas_addr_bits_s(
                .din({chip_config_reg_in[4], chip_config_reg_in[2:1]}),
                .q({chip_config_reg[4], chip_config_reg[2:1]}),
                .set_l(arst_l),
                .clk(clk));

dffrl_async_ns #(1)     ff_cas_addr_bits_r(
                .din(chip_config_reg_in[3]),
                .rst_l(arst_l),
                .q(chip_config_reg[3]),
                .clk(clk));

assign chip_config_reg_in[8:5] = ~rst_l ? chip_config_reg[8:5] : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h8) ? 
				que_ucb_data[3:0] : chip_config_reg[8:5]; 

dffsl_async_ns #(4)     ff_ras_addr_bits(
                .din(chip_config_reg_in[8:5]),
                .set_l(arst_l),
                .q(chip_config_reg[8:5]),
                .clk(clk));

assign chip_config_reg_in[20:9] = ~rst_l ? chip_config_reg[20:9] : 
					que_ucb_wr_req_vld & (que_ucb_addr == 32'h18) ?
					que_ucb_data[11:0] : chip_config_reg[20:9];

dffsl_async_ns #(12)     ff_freq_scrb(
                .din(chip_config_reg_in[20:9]),
                .set_l(arst_l),
                .q(chip_config_reg[20:9]),
                .clk(clk));

// DIMMS PRESENT bit
wire [3:0]	que_dimms_present;
wire [3:0] que_dimms_present_in = ~rst_l ? que_dimms_present : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h218) ?
				que_ucb_data[3:0] : que_dimms_present;

dffsl_async_ns #(2)  ff_dimms_present_s(
                .din(que_dimms_present_in[1:0]),
                .set_l(arst_l),
                .q(que_dimms_present[1:0]),
		.clk(clk));

dffrl_async_ns #(2)  ff_dimms_present_r(
                .din(que_dimms_present_in[3:2]),
                .rst_l(arst_l),
                .q(que_dimms_present[3:2]),
		.clk(clk));

// START INIT PROCESS AND SET MODE REGS
assign que_init_en = (que_ucb_wr_req_vld & (que_ucb_addr == 32'h1a0)) | 
				((que_pos == 5'h9) & que_init);
assign que_init_in = que_ucb_data[0] & ~(que_init & (que_pos == 5'h9));

dffrle_ns #(1)     ff_init(
                .din(que_init_in),
                .en(que_init_en),
                .q(que_init),
		.rst_l(rst_l),
                .clk(clk));

// SOFTWARE PROGRAMMED DATA DELAY COUNT
assign que_data_del_cnt_in = ~rst_l ? que_data_del_cnt : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h1b0) ?
				que_ucb_data[2:0] : que_data_del_cnt;

dffsl_async_ns #(1)     ff_data_del_cnt_s(
                .din(que_data_del_cnt_in[0]),
                .set_l(arst_l),
                .q(que_data_del_cnt[0]),
                .clk(clk));

dffrl_async_ns #(2)     ff_data_del_cnt_r(
                .din(que_data_del_cnt_in[2:1]),
                .rst_l(arst_l),
                .q(que_data_del_cnt[2:1]),
                .clk(clk));

assign que_tot_data_del_cnt = {1'b0,que_data_del_cnt[2:0]} + {1'b0,mode_reg[6:4]};

// PAD CLK TO INV FOR HW GENERATED DATA VALID
wire que_hw_clk_inv_in = ~rst_l ? dram_io_pad_clk_inv : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h1b8) ? que_ucb_data[0] :
				dram_io_pad_clk_inv;

dffrl_async_ns #(1)     ff_hw_clk_inv(
                .din(que_hw_clk_inv_in),
                .rst_l(arst_l),
                .q(dram_io_pad_clk_inv),
                .clk(clk));

// PAD ENABLE CAPTURE CLK TO INV FOR FIFO POINTER 
wire [4:0] que_ptr_clk_inv_in = ~rst_l ? dram_io_ptr_clk_inv : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h1c0) ? que_ucb_data[4:0] :
				dram_io_ptr_clk_inv;

dffsl_async_ns #(2)     ff_ptr_clk_inv_s(
                .din(que_ptr_clk_inv_in[3:2]),
                .set_l(arst_l),
                .q(dram_io_ptr_clk_inv[3:2]),
                .clk(clk));

dffrl_async_ns #(3)     ff_ptr_clk_inv_r(
                .din({que_ptr_clk_inv_in[4], que_ptr_clk_inv_in[1:0]}),
                .rst_l(arst_l),
                .q({dram_io_ptr_clk_inv[4], dram_io_ptr_clk_inv[1:0]}),
                .clk(clk));

// RANK 1 PRESENT 
wire que_rank1_present_en = que_dimms_present[2] & que_dimms_present[3] |
					que_ucb_wr_req_vld & (que_ucb_addr == 32'h130);
wire que_rank1_present_in = ~rst_l ? que_rank1_present :
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h130) ? 
				que_ucb_data[0] : 
				que_dimms_present[2] & que_dimms_present[3] ? 1'b1 :
				que_rank1_present;

dffrl_async_ns #(1)  ff_rank1_present(
                .din(que_rank1_present_in),
                .rst_l(arst_l),
                .q(que_rank1_present),
                .clk(clk));

// TOTAL RANKS PRESENT
wire que_tot_ranks_en = que_rank1_present_en | que_stacked_dimm_en;
wire [2:0] que_tot_ranks_in = ~rst_l ? que_tot_ranks : que_tot_ranks_en ? 
				(que_rank1_present_in & chip_config_reg_in[0] ? 3'h4 :
				(que_rank1_present_in | chip_config_reg_in[0]) ? 3'h2 : 3'h1) :
				que_tot_ranks;

dffsl_async_ns #(1)  	ff_tot_ranks_present_s(
                .din(que_tot_ranks_in[0]),
                .set_l(arst_l),
                .q(que_tot_ranks[0]),
                .clk(clk));

dffrl_async_ns #(2)  	ff_tot_ranks_present_r(
                .din(que_tot_ranks_in[2:1]),
                .rst_l(arst_l),
                .q(que_tot_ranks[2:1]),
                .clk(clk));

// CHANNEL DISABLED
wire que_channel_dis_in = ~rst_l ? que_channel_disabled : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h138) ?
				que_ucb_data[0] : que_channel_disabled;

dffrl_async_ns #(1)  ff_ch_enabled(
                .din(que_channel_dis_in),
                .q(que_channel_disabled),
                .rst_l(arst_l),
                .clk(clk));

// BANK BITS TO SELECT - LOW ORDER 
wire que_addr_bank_low_sel_in = ~rst_l ? que_addr_bank_low_sel :
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h140) ? 
				que_ucb_data[0] : que_addr_bank_low_sel;

dffrl_async_ns #(1)  ff_bank_low_sel(
                .din(que_addr_bank_low_sel_in),
                .q(que_addr_bank_low_sel),
                .rst_l(arst_l),
                .clk(clk));

// EIGHT BANK MODE REG
wire que_eight_bank_mode_in = ~rst_l ? que_eight_bank_mode : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h128) ? que_ucb_data[0] :
				que_eight_bank_mode;

dffsl_async_ns #(1)  ff_eight_bank_present(
                .din(que_eight_bank_mode_in),
                .set_l(arst_l),
                .q(que_eight_bank_mode), 
                .clk(clk));

// FAIL OVER MODE BIT
wire que_fail_over_mode_in = ~rst_l ? dram_fail_over_mode :
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h220) ?
				que_ucb_data[0] : dram_fail_over_mode;

dffrl_async_ns #(1)  ff_fail_over_mode(
                .din(que_fail_over_mode_in),
                .q(dram_fail_over_mode),
                .rst_l(arst_l),
                .clk(clk));

// CLOCK ENABLE BIT
wire que_clk_enable_in = ((que_pos == 5'he) & que_hw_selfrsh) ? 1'b1 : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h1a0) ? que_ucb_data[2] :
				dram_io_clk_enable;

dffrl_ns #(1)  ff_pad_clk_enable(
                .din(que_clk_enable_in),
                .q(dram_io_clk_enable),
		.rst_l(rst_l),
                .clk(clk));

// CKE ENABLE BIT
wire que_cke_in = ((que_pos == 5'he) & ~que_hw_selfrsh) ? 1'b1 :
			que_ucb_wr_req_vld & (que_ucb_addr == 32'h1a0) ? que_ucb_data[1] : 
			que_cke_reg; 

dffrl_ns #(1)  ff_cke_enable(
                .din(que_cke_in),
                .q(que_cke_reg),
		.rst_l(rst_l),
                .clk(clk));

////////////////////////////////////////////////
// MASK REG FOR MUXING DEAD CHIP ON DIMM
// The interpretation of the parity is as following ecc[15:0] = {p0,p1,p2,p3} where p3 is not used
// failover mode.                                                                                 
// The error location is as = {err_in_p3, err_in_p2, ... err_in_d2, err_in_d1, err_in_d0}         
// If the error location bit is 1, and to create mask in failover mode set all the bits left of 1 to 1
// (including the bit 1 set in err location) upto bit location 34.
////////////////////////////////////////////////
wire [34:0]	que_fail_over_mask_in;

assign que_fail_over_mask_in = ~rst_l ? dram_fail_over_mask :
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h228) ? que_ucb_data[34:0] :
				dram_fail_over_mask;

dffrl_async_ns #(35)  ff_fail_over_mask(
                .din(que_fail_over_mask_in),
                .q(dram_fail_over_mask),
                .rst_l(arst_l),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Ras to Ras Delay to different bank (RRD) REGISTER
//////////////////////////////////////////////////////////////////

assign rrd_reg_in = ~rst_l ? rrd_reg[3:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'h80) ? que_ucb_data[3:0] :
			rrd_reg[3:0];

dffsl_async_ns #(1)     ff_rrd_reg_s(
                .din(rrd_reg_in[1]),
                .set_l(arst_l),
                .q(rrd_reg[1]),
                .clk(clk));

dffrl_async_ns #(3)     ff_rrd_reg_r(
                .din({rrd_reg_in[3:2], rrd_reg_in[0]}),
                .rst_l(arst_l),
                .q({rrd_reg[3:2], rrd_reg[0]}),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Ras to Cas Delay (RCD) REGISTER
//////////////////////////////////////////////////////////////////

assign rcd_reg_in = ~rst_l ? rcd_reg[3:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'h90) ? que_ucb_data[3:0] :
			rcd_reg[3:0];
                                
dffsl_async_ns #(2)     ff_rcd_reg_s(
                .din(rcd_reg_in[1:0]),
                .set_l(arst_l),
                .q(rcd_reg[1:0]),
                .clk(clk));

dffrl_async_ns #(2)     ff_rcd_reg_r(
                .din(rcd_reg_in[3:2]),
                .rst_l(arst_l),
                .q(rcd_reg[3:2]),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Internal write to read command delay (IWTR) REGISTER
//////////////////////////////////////////////////////////////////

// tWTR delay
assign iwtr_reg_in = ~rst_l ? iwtr_reg[1:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'he0) ? que_ucb_data[1:0] :
			iwtr_reg[1:0];

dffsl_async_ns #(1)     ff_iwtr_reg_s(
                .din(iwtr_reg_in[1]),
                .set_l(arst_l),
                .q(iwtr_reg[1]),
                .clk(clk));

dffrl_async_ns #(1)     ff_iwtr_reg_r(
                .din(iwtr_reg_in[0]),
                .rst_l(arst_l),
                .q(iwtr_reg[0]),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Write to Read (CAS) Delay to any bank (WTR) REGISTER
//////////////////////////////////////////////////////////////////

// This is because CL - 1 + BL/2 + iwtr due to the WTR delay
assign wtr_reg_in = ~rst_l ? wtr_dly_reg[3:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'h98) ? que_ucb_data[3:0] :
			wtr_dly_reg[3:0];

dffrl_async_ns #(4)     ff_wtr_reg(
                .din(wtr_reg_in[3:0]),
                .rst_l(arst_l),
                .q(wtr_dly_reg[3:0]),
                .clk(clk));

assign wtr_reg = wtr_dly_reg + {1'h0, mode_reg[6:4]} + 4'h1 + {2'h0, iwtr_reg[1:0]};

//////////////////////////////////////////////////////////////////
// Read to Write (CAS) Delay to any bank (RTW) REGISTER
//////////////////////////////////////////////////////////////////
wire [3:0]	rtw_reg_in;

// This is CL + 2 cyc data access + 1 cyc for wire delay
assign rtw_reg_in = ~rst_l ? rtw_dly_reg[3:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'ha0) ? que_ucb_data[3:0] :
			rtw_dly_reg[3:0];

dffrl_async_ns #(4)     ff_rtw_reg(
                .din(rtw_reg_in[3:0]),
                .rst_l(arst_l),
                .q(rtw_dly_reg[3:0]),
                .clk(clk));

assign rtw_reg = rtw_dly_reg + {1'h0, mode_reg[6:4]} + 4'h2;

//////////////////////////////////////////////////////////////////
// For AUTO_PRECHARGE case, after write the time tDAL (auto precharge
// write recovery + precharge time) has to be met. tDAL = tRP + tWR.
// We have these registers seperate as following.
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
// Precharge command period for write (DAL) REGISTER
// Its CAS to RAS time period for same bank on a write with auto precharge.
// Normally tDAL = BL/2 + tRP + tWR + (Read Latency - 1)  for data to be written.
// tRP starts from last chunk of data written.
//////////////////////////////////////////////////////////////////
wire            sch_dal_reg_en;
wire [3:0]      dal_reg_in;
wire		sch_rp_reg_en;
wire [3:0]	rp_reg_in;
wire		sch_wr_reg_en;
wire [3:0]	wr_reg_in;

//assign sch_dal_reg_en = ~rst_l | sch_rp_reg_en | sch_wr_reg_en | sch_mode_reg_en;
//assign dal_reg_in = 4'h2 + rp_reg_in[3:0] + wr_reg_in[3:0] + ({1'h0, mode_reg_in[6:4]} - 4'h1);
assign dal_reg_in = 4'h2 + rp_reg[3:0] + wr_reg[3:0] + ({1'h0, mode_reg[6:4]} - 4'h1);

dff_ns #(4)     ff_dal_reg(
                .din(dal_reg_in[3:0]),
                //.en(sch_dal_reg_en),
                .q(dal_reg[3:0]),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Precharge command period for read (RAL) REGISTER ITs CL + BL/2 + tRP 
// Its CAS to RAS time period for same bank on a read with auto precharge.
// tRP on read starts from the 
//////////////////////////////////////////////////////////////////

wire            sch_rtp_reg_en;
wire [3:0]      ral_reg_in;
wire [2:0]	rtp_reg_in;
wire [2:0]	rtp_reg;
 
// Its CL half rounded to upper one + 2 cycles of data + tRP
assign ral_reg_in =  {1'b0, rtp_reg[2:0]} + rp_reg[3:0]; 

dff_ns #(4)     ff_ral_reg(
                .din(ral_reg_in[3:0]),
                .q(ral_reg[3:0]),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Internal Read to Precharge command delay (tRTP) REGISTER
//////////////////////////////////////////////////////////////////

assign sch_rtp_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'ha8);
assign rtp_reg_in = ~rst_l ? rtp_reg[2:0] : 
		que_ucb_wr_req_vld & (que_ucb_addr == 32'ha8) & (que_ucb_data[2:0] > 3'h2) ? 
		que_ucb_data[2:0] : que_ucb_wr_req_vld & (que_ucb_addr == 32'ha8) ?
		3'h2 : rtp_reg;

dffsl_async_ns #(1)     ff_rtp_reg_s(
                .din(rtp_reg_in[1]),
                .set_l(arst_l),
                .q(rtp_reg[1]),
                .clk(clk));

dffrl_async_ns #(2)     ff_rtp_reg_r(
                .din({rtp_reg_in[2], rtp_reg_in[0]}),
                .rst_l(arst_l),
                .q({rtp_reg[2], rtp_reg[0]}),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Active to Precharge command period (tRAS) REGISTER
//////////////////////////////////////////////////////////////////

wire [3:0]	ras_reg_in;
wire [3:0]	ras_reg;

wire sch_ras_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'hb0);
assign ras_reg_in = ~rst_l ? ras_reg[3:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'hb0) ? 
			que_ucb_data[3:0] : ras_reg;

dffsl_async_ns #(2)     ff_ras_reg_s(
                .din({ras_reg_in[3], ras_reg_in[0]}),
                .set_l(arst_l),
                .q({ras_reg[3], ras_reg[0]}),
                .clk(clk));

dffrl_async_ns #(2)     ff_ras_reg_r(
                .din(ras_reg_in[2:1]),
                .rst_l(arst_l),
                .q(ras_reg[2:1]),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Precharge command period (RP) REGISTER
//////////////////////////////////////////////////////////////////

assign sch_rp_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'hb8);
assign rp_reg_in = ~rst_l ? rp_reg[3:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'hb8) ? que_ucb_data[3:0] : 
			rp_reg;

dffsl_async_ns #(2)     ff_rp_reg_s(
                .din(rp_reg_in[1:0]),
                .set_l(arst_l),
                .q(rp_reg[1:0]),
                .clk(clk));

dffrl_async_ns #(2)     ff_rp_reg_r(
                .din(rp_reg_in[3:2]),
                .rst_l(arst_l),
                .q(rp_reg[3:2]),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Ras to Ras Delay to same bank (RC) REGISTER = tRAS + tRP
//////////////////////////////////////////////////////////////////

assign rc_reg_in = ~rst_l ? rc_reg : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'h88) ? que_ucb_data[4:0] :
			sch_rp_reg_en ? {1'b0,ras_reg} + {1'b0,rp_reg_in} : 
			sch_ras_reg_en ? {1'b0,rp_reg} + {1'b0,ras_reg_in} : rc_reg;
                                
dffsl_async_ns #(2)     ff_rc_reg_s(
                .din(rc_reg_in[3:2]),
                .set_l(arst_l),
                .q(rc_reg[3:2]),
                .clk(clk));

dffrl_async_ns #(3)     ff_rc_reg_r(
                .din({rc_reg_in[4], rc_reg_in[1:0]}),
                .rst_l(arst_l),
                .q({rc_reg[4], rc_reg[1:0]}),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Write recovery time period (WR) REGISTER
//////////////////////////////////////////////////////////////////

assign sch_wr_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'hc0);
assign wr_reg_in = ~rst_l ? wr_reg[3:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'hc0) ? 
			que_ucb_data[3:0] : wr_reg;

dffsl_async_ns #(2)     ff_wr_reg_s(
                .din(wr_reg_in[1:0]),
                .set_l(arst_l),
                .q(wr_reg[1:0]),
                .clk(clk));

dffrl_async_ns #(2)     ff_wr_reg_r(
                .din(wr_reg_in[3:2]),
                .rst_l(arst_l),
                .q(wr_reg[3:2]),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// Auto refresh to active time period (RFC) REGISTER
//////////////////////////////////////////////////////////////////
wire [6:0]      rfc_reg_in;

assign rfc_reg_in = ~rst_l ? rfc_reg[6:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'hc8) ? que_ucb_data[6:0] :
			rfc_reg[6:0];

dffsl_async_ns #(4)     ff_rfc_reg_s(
                .din({rfc_reg_in[5], rfc_reg_in[2:0]}),
                .set_l(arst_l),
                .q({rfc_reg[5], rfc_reg[2:0]}),
                .clk(clk));

dffrl_async_ns #(3)     ff_rfc_reg_r(
                .din({rfc_reg_in[6], rfc_reg_in[4:3]}),
                .rst_l(arst_l),
                .q({rfc_reg[6], rfc_reg[4:3]}),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// MODE REGISTER SET command period (tMRD) REGISTER
//////////////////////////////////////////////////////////////////
wire [1:0]      mrd_reg_in;

assign mrd_reg_in = ~rst_l ? mrd_reg[1:0] : 
			 que_ucb_wr_req_vld & (que_ucb_addr == 32'hd0) ? que_ucb_data[1:0] :
			mrd_reg[1:0];

dffsl_async_ns #(1)     ff_mrd_reg_s(
                .din(mrd_reg_in[1]),
                .set_l(arst_l),
                .q(mrd_reg[1]),
                .clk(clk));

dffrl_async_ns #(1)     ff_mrd_reg_r(
                .din(mrd_reg_in[0]),
                .rst_l(arst_l),
                .q(mrd_reg[0]),
                .clk(clk));

//////////////////////////////////////////////////////////////////
// POWER ON INIT WAIT FOR PRECHARGE. Should be 400ns implies 
// 80 cycle (appx. 8'h55 some margin) on 200 MHz.
//////////////////////////////////////////////////////////////////
wire [7:0]      que_precharge_wait_in;

assign que_precharge_wait_in = ~rst_l ? que_precharge_wait[7:0] : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'he8) ? que_ucb_data[7:0] :
				que_precharge_wait[7:0];

dffsl_async_ns #(4)     ff_txp_reg_s(
                .din({que_precharge_wait_in[6], que_precharge_wait_in[4], 
			que_precharge_wait_in[2], que_precharge_wait_in[0]}),
                .set_l(arst_l),
                .q({que_precharge_wait[6], que_precharge_wait[4], 
			que_precharge_wait[2], que_precharge_wait[0]}),
                .clk(clk));

dffrl_async_ns #(4)     ff_txp_reg_r(
                .din({que_precharge_wait_in[7], que_precharge_wait_in[5], 
			que_precharge_wait_in[3], que_precharge_wait_in[1]}),
                .rst_l(arst_l),
                .q({que_precharge_wait[7], que_precharge_wait[5], 
			que_precharge_wait[3], que_precharge_wait[1]}),
                .clk(clk));

//////////////////////////////////////////////////////
// DRAM ERROR INJECTION REGISTER
//////////////////////////////////////////////////////

wire	que_err_injected;
wire	sshot_err_reg;

wire err_inj_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'h290) | 
				sshot_err_reg & que_err_injected;
wire err_inj_reg_in = que_ucb_wr_req_vld & (que_ucb_addr == 32'h290) ? que_ucb_data[31] : 1'b0;

dffrle_ns #(1)  ff_err_inj(
                .din(err_inj_reg_in),
                .en(err_inj_reg_en),
                .q(err_inj_reg),
		.rst_l(rst_l),
                .clk(clk));

wire sshot_err_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'h290) | que_err_injected;
wire sshot_err_reg_in = que_ucb_wr_req_vld & (que_ucb_addr == 32'h290) ? que_ucb_data[30] : 1'b0;

dffrle_ns #(1)  ff_sshot(
                .din(sshot_err_reg_in),
                .en(sshot_err_reg_en),
                .q(sshot_err_reg),
		.rst_l(rst_l),
                .clk(clk));

wire err_mask_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'h290);
wire [15:0] err_mask_reg_in = que_ucb_data[15:0];

dffrle_ns #(16) ff_err_mask(
                .din(err_mask_reg_in[15:0]),
                .en(err_mask_reg_en),
                .q(err_mask_reg[15:0]),
		.rst_l(rst_l),
                .clk(clk));

// Generation of "que_err_injected" signal. It is done by checking the first write
// and then latching on to it till the second wr_en_l is generated. It is reset before
// the data going out to DIMM is read from wr que memories.

wire	que_first_wr_cmd;
wire 	que_first_wr_cmd_in = que_mux_write_en & que_cas_picked & err_inj_reg & ~que_first_wr_cmd;
// FIX FOR 2.0
wire  que_first_wr_cmd_en = que_mux_write_en & que_cas_picked;

dffrle_ns #(1)  ff_wr(
                .din(que_first_wr_cmd_in),
                .en(que_first_wr_cmd_en),
                .q(que_first_wr_cmd),
		.rst_l(rst_l),
                .clk(clk));

// Reset on the first cycle of data from memory.
assign que_err_injected = que_first_wr_cmd & que_wr_entry_free_p1[3];

//////////////////////////////////////////////////////////////////
// REFRESH counters for 166MHz and 200MHz frequency.
// We have to have one refresh for every 7.8micro seconds
// Therefore for 166.67 count is 7.8micro/6.0nano = 1300
// and for 200 count is 7.8micro/5nano = 1560
// We can also post upto 8 refreshes at a time.
//////////////////////////////////////////////////////////////////
wire [12:0]	que_ref_cnt_in;
wire [12:0]	que_ref_cnt;

assign que_ref_cnt_in =  ~rst_l ? que_ref_cnt[12:0] : 
			que_ucb_wr_req_vld & (que_ucb_addr == 32'h20) ? que_ucb_data[12:0] :
			que_ref_cnt[12:0];

dffsl_async_ns #(4)  	ff_ref_cnt_s(
                .din({que_ref_cnt_in[10], que_ref_cnt_in[8], que_ref_cnt_in[4], que_ref_cnt_in[2]}),
                .q({que_ref_cnt[10], que_ref_cnt[8], que_ref_cnt[4], que_ref_cnt[2]}),
                .set_l(arst_l),
                .clk(clk));

dffrl_async_ns #(9)  	ff_ref_cnt_r(
                .din({que_ref_cnt_in[12:11], que_ref_cnt_in[9], que_ref_cnt_in[7:5], 
				que_ref_cnt_in[3], que_ref_cnt_in[1:0]}),
                .q({que_ref_cnt[12:11], que_ref_cnt[9], que_ref_cnt[7:5], 
				que_ref_cnt[3], que_ref_cnt[1:0]}),
                .rst_l(arst_l),
                .clk(clk));

assign que_refresh_req_picked = (que_pos == 5'hc);
assign que_ref_cnt_166_200_in = ~rst_l ? que_ref_cnt_166_200 :
					que_ref_go | (que_ucb_wr_req_vld & (que_ucb_addr == 32'h20)) ? 13'h0 :
					que_ucb_wr_req_vld & (que_ucb_addr == 32'h38) ? 
					que_ucb_data[12:0] : que_ref_cnt_166_200 + 13'h1;

dffrl_async_ns #(13) ff_ref_cnt_166_200(
                .din(que_ref_cnt_166_200_in[12:0]),
                .q(que_ref_cnt_166_200[12:0]),
                .rst_l(arst_l),
                .clk(clk));

assign que_ref_go = (que_ref_cnt_166_200 == que_ref_cnt);

//////////////////////////////////////////////////////////////////
// Logic that generates scrubbing for all address at periodic interval
// that is programmable.
// Part of this logic is also used to initialize the DRAM on powerup.
//////////////////////////////////////////////////////////////////

wire		que_scrb_write_en;
wire		que_scrb_write_reset;
wire		que_data_scrub_enabled;

// SCRUB ENABLE BIT
wire que_data_scrub_en_in = ~rst_l ? que_data_scrub_enabled :
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h40) ? que_ucb_data[0] :
				que_data_scrub_enabled;

dffrl_async_ns #(1)  ff_data_scrub(
                .din(que_data_scrub_en_in),
                .q(que_data_scrub_enabled),
                .rst_l(arst_l),
                .clk(clk));

assign que_scrb_cnt_in = que_scrb_cnt + 12'h1;
assign que_scrb_cnt_reset =  (rst_l & ~(que_scrb_picked & que_scrb_read_valid) & que_init_dram_done);

dffrle_ns #(12) ff_scrb_cnt(
                .din(que_scrb_cnt_in[11:0]),
                .q(que_scrb_cnt[11:0]),
		.en(que_data_scrub_enabled),
                .rst_l(que_scrb_cnt_reset),
                .clk(clk));

// Assert read valid when its time to scrub and there is no pending scrub write 
// Reset the read valid on read valid is picked
assign que_scrb_time = (que_scrb_cnt[11:0] >= chip_config_reg[20:9]) & que_data_scrub_enabled & ~que_hw_selfrsh;
assign que_scrb_read_en = que_scrb_time & ~(que_scrb_write_valid | que_prev_scrb_wr_pending);

dffrle_ns #(1)  ff_scrb_read(
                .din(que_scrb_time),
                .q(que_scrb_read_valid),
                .rst_l(rst_l & ~(que_scrb_read_valid & que_scrb_picked)),
		.en(que_scrb_read_en),
                .clk(clk));

assign que_scrb_write_en = (que_scrb_read_valid & que_scrb_picked);
assign que_scrb_write_reset = rst_l & ~(que_scrb_write_valid & que_scrb_picked);

dffrle_ns #(1)  ff_scrb_write(
                .din(1'b1),
                .q(que_scrb_write_valid),
                .rst_l(que_scrb_write_reset),
		.en(que_scrb_write_en),
                .clk(clk));

// SCRUB WR DONE SIGNAL TO NOT SEND ANOTHER SCRUB RD TILL PREV SCRUB WR IS COMPLETE 

wire que_prev_scrb_wr_pending_in = que_scrb_write_valid & que_scrb_picked; 
wire que_prev_scrb_wr_pending_en = que_scrb_write_valid & que_scrb_picked | que_scrb_write_req;

dffrle_ns #(1)  ff_prev_scrb_write(
                .din(que_prev_scrb_wr_pending_in),  
                .q(que_prev_scrb_wr_pending),
                .en(que_prev_scrb_wr_pending_en),
                .rst_l(rst_l),
                .clk(clk));

////////////////////////
// Generate address for scrub
////////////////////////

// The scrub address resets itself on crossing the limit
// ie, when error bit is set.
wire que_scrb_addr_reset_l = (~que_split_scrb_addr[32] & que_arb_reset_l);

wire que_scrb_rank_addr_in = que_scrb_stack_addr & (que_scrb_ras_addr == 15'h7fff) & 
				(que_scrb_cas_addr == 9'h1ff) &
                                (que_scrb_bank == 3'h7) & que_scrb_picked &
			que_scrb_write_valid ? ~que_scrb_rank_addr : que_scrb_rank_addr;

dffrl_ns #(1)  ff_scrb_rank_addr(
                .din(que_scrb_rank_addr_in),
                .q(que_scrb_rank_addr),
                .rst_l(que_scrb_addr_reset_l),
                .clk(clk));

wire que_scrb_stack_addr_in = (que_scrb_ras_addr == 15'h7fff) & (que_scrb_cas_addr == 9'h1ff) &
                                (que_scrb_bank == 3'h7) & que_scrb_picked &
           		que_scrb_write_valid ? ~que_scrb_stack_addr : que_scrb_stack_addr;

dffrl_ns #(1)  ff_scrb_stack_addr(
                .din(que_scrb_stack_addr_in),
                .q(que_scrb_stack_addr),
                .rst_l(que_scrb_addr_reset_l),
                .clk(clk));

assign que_scrb_ras_addr_in = (que_scrb_cas_addr == 9'h1ff) & (que_scrb_bank == 3'h7) & 
				que_scrb_picked & que_scrb_write_valid ?
                		que_scrb_ras_addr + 15'h1 : que_scrb_ras_addr[14:0];

dffrl_ns #(15)  ff_scrb_ras_addr(
                .din(que_scrb_ras_addr_in[14:0]),
                .q(que_scrb_ras_addr[14:0]),
                .rst_l(que_scrb_addr_reset_l),
                .clk(clk));

assign que_scrb_cas_addr_in = (que_scrb_bank == 3'h7) & que_scrb_picked & que_scrb_write_valid ? 
				que_scrb_cas_addr + 9'h1 : que_scrb_cas_addr[8:0];

dffrl_ns #(9)  	ff_scrb_cas_addr(
                .din(que_scrb_cas_addr_in[8:0]),
                .q(que_scrb_cas_addr[8:0]),
                .rst_l(que_scrb_addr_reset_l),
                .clk(clk));

////////////////////////
// Generate bank bits for scrub
////////////////////////

assign que_scrb_bank_in = que_scrb_write_valid & que_scrb_picked ?  
				que_scrb_bank + 3'h1 : que_scrb_bank[2:0];

dffrl_ns #(3)   ff_scrb_bank(
                .din(que_scrb_bank_in[2:0]),
                .q(que_scrb_bank[2:0]),
                .rst_l(que_scrb_addr_reset_l),
                .clk(clk));

//////////////////////////////////////
// Max banks open at any given time
//////////////////////////////////////

assign dram_local_pt_opened_bank = |que_ras_picked_io_d1[7:0]; 	// One cycle after its picked
assign que_max_banks_open_valid = que_ucb_wr_req_vld & (que_ucb_addr == 32'h28);
assign que_max_time_valid = que_ucb_wr_req_vld & (que_ucb_addr == 32'h48);
assign que_max_banks_open = que_ucb_data[16:0];

//////////////////////////////////////
// IO read command
//////////////////////////////////////

wire [63:0]	que_read_ucb_data;
wire		que_init_status_reg;
wire		que_wr_mode_reg_done;

wire que_wr_mode_reg_done_in = (que_pos[4] | (que_pos[3] & (que_pos[2] | que_pos[1]))) | 
				que_wr_mode_reg_done;

dffrl_ns #(1)  	ff_wr_mode_reg(
                .din(que_wr_mode_reg_done_in),
                .q(que_wr_mode_reg_done),
		.rst_l(rst_l & ~(que_ucb_wr_req_vld & (que_ucb_addr == 32'h1a0)) | que_hw_selfrsh),
                .clk(clk));

wire que_init_dram_done_in = (que_pos_next == 5'ha) | que_init_dram_done & ~(que_pos == 5'h1);

dffrl_ns #(1)  	ff_init_done(
                .din(que_init_dram_done_in),
                .q(que_init_dram_done),
		.rst_l(rst_l | que_hw_selfrsh),
                .clk(clk));

// DRAM INIT STATUS REG 
wire que_init_status_reg_in = ((que_pos != 5'ha) & (que_pos_next == 5'ha)) | que_init_status_reg;

dffrl_ns #(1)  	ff_init_status_reg(
                .din(que_init_status_reg_in),
                .q(que_init_status_reg),
		.rst_l(rst_l & ~(que_ucb_wr_req_vld & (que_ucb_addr == 32'h1a0)) | que_hw_selfrsh),
                .clk(clk));

wire [65:0] que_read_ucb_info = 
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h0) ? {2'b01, 60'h0, chip_config_reg[4:1]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h8) ? {2'b01, 60'h0, chip_config_reg[8:5]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h10) ? {2'b01, 61'h0, mode_reg[6:4]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h18) ? {2'b01, 52'h0, chip_config_reg[20:9]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h20) ? {2'b01, 51'h0, que_ref_cnt[12:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h28) ? {2'b01, 47'h0, pt_max_banks_open[16:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h38) ? {2'b01, 51'h0, que_ref_cnt_166_200[12:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h40) ? {2'b01, 63'h0, que_data_scrub_enabled} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h48) ? {2'b01, 48'h0, pt_max_time[15:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h80) ? {2'b01, 60'h0, rrd_reg[3:0]} :
        que_ucb_rd_req_vld & (que_ucb_addr == 32'h88) ? {2'b01, 59'h0, rc_reg[4:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h90) ? {2'b01, 60'h0, rcd_reg[3:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h98) ? {2'b01, 60'h0, wtr_dly_reg[3:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'ha0) ? {2'b01, 60'h0, rtw_dly_reg[3:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'ha8) ? {2'b01, 61'h0, rtp_reg[2:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'hb0) ? {2'b01, 60'h0, ras_reg[3:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'hb8) ? {2'b01, 60'h0, rp_reg[3:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'hc0) ? {2'b01, 60'h0, wr_reg[3:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'hc8) ? {2'b01, 57'h0, rfc_reg[6:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'hd0) ? {2'b01, 62'h0, mrd_reg[1:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'he0) ? {2'b01, 62'h0, iwtr_reg[1:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'he8) ? {2'b01, 56'h0, que_precharge_wait[7:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h108) ? {2'b01, 63'h0, chip_config_reg[0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h110) ? {2'b01, 49'h0, ext_mode_reg2[14:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h118) ? {2'b01, 49'h0, ext_mode_reg1[14:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h120) ? {2'b01, 49'h0, ext_mode_reg3[14:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h128) ? {2'b01, 63'h0, que_eight_bank_mode} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h130) ? {2'b01, 63'h0, que_rank1_present} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h138) ? {2'b01, 63'h0, que_channel_disabled} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h140) ? {2'b01, 63'h0, que_addr_bank_low_sel} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h1a0) ? {2'b01, 61'h0, dram_io_clk_enable, que_cke_reg, que_init} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h1b0) ? {2'b01, 61'h0, que_data_del_cnt[2:0]} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h1b8) ? {2'b01, 63'h0, dram_io_pad_clk_inv} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h1c0) ? {2'b01, 59'h0, dram_io_ptr_clk_inv} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h208) ? {2'b01, 63'h0, que_wr_mode_reg_done} :
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h210) ? {2'b01, 63'h0, que_init_status_reg} : 
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h218) ? {2'b01, 60'h0, que_dimms_present} : 
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h220) ? {2'b01, 63'h0, dram_fail_over_mode} : 
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h228) ? {2'b01, 29'h0, dram_fail_over_mask[34:0]} : 
	que_ucb_rd_req_vld & (que_ucb_addr == 32'h230) ? {2'b01, 56'h0, 
								que_margin_reg[4:0], que_dbg_trig_en, 2'h0} : 
                que_ucb_rd_req_vld & (que_ucb_addr == 32'h280) ? 
			{2'b01, que_err_sts_reg[22], que_err_sts_reg[21], 
			que_err_sts_reg[20], que_err_sts_reg[19], que_err_sts_reg[18], 
			que_err_sts_reg[17], que_err_sts_reg[16], 41'h0, que_err_sts_reg[15:0]} :
                que_ucb_rd_req_vld & (que_ucb_addr == 32'h288) ? 
			{2'b01, 24'h0, que_err_addr_reg[35:0], 4'h0} :
		que_ucb_rd_req_vld & (que_ucb_addr == 32'h290) ? {2'b01, 32'h0, 
			{err_inj_reg, sshot_err_reg, 14'h0, err_mask_reg[15:0]}} : 
		que_ucb_rd_req_vld & (que_ucb_addr == 32'h298) ? {2'b01, 46'h0, que_err_cnt[17:0]} :
		que_ucb_rd_req_vld & (que_ucb_addr == 32'h2a0) ? {2'b01, 28'h0, que_err_loc[35:0]} :
		que_ucb_rd_req_vld & (que_ucb_addr == 32'h400) ? {2'b01, 56'h0, que_perf_cntl_reg[7:0]} :
		que_ucb_rd_req_vld & (que_ucb_addr == 32'h408) ? {2'b01, que_perf_cnt0_reg,que_perf_cnt1_reg} :
		que_ucb_rd_req_vld ? {2'b10, 64'h0} : 66'h0;

assign que_nack_vld_in = que_read_ucb_info[65];
assign que_ack_vld_in = que_read_ucb_info[64];
assign que_read_ucb_data[63:0] = que_read_ucb_info[63:0];

// Generate ack valid and flop both valid and data

dffrl_ns #(2)   ff_ucb_data_vld(
                .din({que_ack_vld_in, que_nack_vld_in}),
                .q({que_l2if_ack_vld, que_l2if_nack_vld}),
		.rst_l(rst_l),
                .clk(clk));

dff_ns #(64)    ff_ucb_data(
                .din(que_read_ucb_data[63:0]),
                .q(que_l2if_data[63:0]),
                .clk(clk));

//////////////////////////////////////////////////////////////////////////////////////
// GENERATE DATA VALID AND GENERATING ENABLE FOR PADS
//////////////////////////////////////////////////////////////////////////////////////

///////////////////////////
// Gen data valid for Bank0
///////////////////////////

reg [3:0]       que_b0_data_rtn_cnt_next;
reg             que_b0_start_counting_next;
wire		que_b0_data_val;

dffrl_ns #(5)       ff_b0_data_rtn_cnt(
                .din({que_b0_data_rtn_cnt_next[3:0],
                        que_b0_start_counting_next}),
                .q({que_b0_data_rtn_cnt[3:0], que_b0_start_counting}),
                .rst_l(rst_l),
                .clk(clk));

always @(/*AUTOSENSE*/que_b0_data_rtn_cnt 
	 or que_b0_data_val or que_b0_start_counting
	 or que_cas_picked_d1 or que_mux_write_en_d1)
begin
        que_b0_data_rtn_cnt_next[3:0] = que_b0_data_rtn_cnt[3:0];
        que_b0_start_counting_next = 1'h0;
	begin
                if(que_cas_picked_d1[0] & ~que_mux_write_en_d1) que_b0_start_counting_next = 1'h1;
                if(que_b0_start_counting | (|que_b0_data_rtn_cnt[3:0]) )
                begin
			if(que_b0_data_val) que_b0_data_rtn_cnt_next[3:0] = 4'h0;
                        else que_b0_data_rtn_cnt_next[3:0] = que_b0_data_rtn_cnt[3:0] + 4'h1;
		end
        end
end

assign que_b0_data_val = ((que_tot_data_del_cnt[3:0] - 4'h1) == que_b0_data_rtn_cnt[3:0]);

///////////////////////////
// Gen data valid for Bank1
///////////////////////////

reg [3:0]       que_b1_data_rtn_cnt_next;
reg             que_b1_start_counting_next;
wire            que_b1_data_val;

dffrl_ns #(5)       ff_b1_data_rtn_cnt(
                .din({que_b1_data_rtn_cnt_next[3:0],
                        que_b1_start_counting_next}),
                .q({que_b1_data_rtn_cnt[3:0], que_b1_start_counting}),
                .rst_l(rst_l),
                .clk(clk));

always @(/*AUTOSENSE*/que_b1_data_rtn_cnt 
	 or que_b1_data_val or que_b1_start_counting
	 or que_cas_picked_d1 or que_mux_write_en_d1)
begin
        que_b1_data_rtn_cnt_next[3:0] = que_b1_data_rtn_cnt[3:0];
        que_b1_start_counting_next = 1'h0;
	begin
                if(que_cas_picked_d1[1] & ~que_mux_write_en_d1) que_b1_start_counting_next = 1'h1;
                if(que_b1_start_counting | (|que_b1_data_rtn_cnt[3:0]) )
                begin
			if(que_b1_data_val) que_b1_data_rtn_cnt_next[3:0] = 4'h0;
                        else que_b1_data_rtn_cnt_next[3:0] = que_b1_data_rtn_cnt[3:0] + 4'h1;
		end
        end
end

assign que_b1_data_val = ((que_tot_data_del_cnt[3:0] - 4'h1) == que_b1_data_rtn_cnt[3:0]);

///////////////////////////
// Gen data valid for Bank2
///////////////////////////

reg [3:0]       que_b2_data_rtn_cnt_next;
reg             que_b2_start_counting_next;
wire            que_b2_data_val;

dffrl_ns #(5)       ff_b2_data_rtn_cnt(
                .din({que_b2_data_rtn_cnt_next[3:0],
                        que_b2_start_counting_next}),
                .q({que_b2_data_rtn_cnt[3:0], que_b2_start_counting}),
                .rst_l(rst_l),
                .clk(clk));

always @(/*AUTOSENSE*/que_b2_data_rtn_cnt 
	 or que_b2_data_val or que_b2_start_counting
	 or que_cas_picked_d1 or que_mux_write_en_d1)
begin
        que_b2_data_rtn_cnt_next[3:0] = que_b2_data_rtn_cnt[3:0];
        que_b2_start_counting_next = 1'h0;
	begin
                if(que_cas_picked_d1[2] & ~que_mux_write_en_d1) que_b2_start_counting_next = 1'h1;
                if(que_b2_start_counting | (|que_b2_data_rtn_cnt[3:0]) )
                begin
			if(que_b2_data_val) que_b2_data_rtn_cnt_next[3:0] = 4'h0;
                        else que_b2_data_rtn_cnt_next[3:0] = que_b2_data_rtn_cnt[3:0] + 4'h1;
		end
        end
end

assign que_b2_data_val = ((que_tot_data_del_cnt[3:0] - 4'h1) == que_b2_data_rtn_cnt[3:0]);

///////////////////////////
// Gen data valid for Bank3
///////////////////////////

reg [3:0]       que_b3_data_rtn_cnt_next;
reg             que_b3_start_counting_next;
wire            que_b3_data_val;

dffrl_ns #(5)       ff_b3_data_rtn_cnt(
                .din({que_b3_data_rtn_cnt_next[3:0],
                        que_b3_start_counting_next}),
                .q({que_b3_data_rtn_cnt[3:0], que_b3_start_counting}),
                .rst_l(rst_l),
                .clk(clk));

always @(/*AUTOSENSE*/que_b3_data_rtn_cnt 
	 or que_b3_data_val or que_b3_start_counting
	 or que_cas_picked_d1 or que_mux_write_en_d1)
begin
        que_b3_data_rtn_cnt_next[3:0] = que_b3_data_rtn_cnt[3:0];
        que_b3_start_counting_next = 1'h0;
	begin
                if(que_cas_picked_d1[3] & ~que_mux_write_en_d1) que_b3_start_counting_next = 1'h1;
                if(que_b3_start_counting | (|que_b3_data_rtn_cnt[3:0]) )
                begin
			if(que_b3_data_val) que_b3_data_rtn_cnt_next[3:0] = 4'h0;
                        else que_b3_data_rtn_cnt_next[3:0] = que_b3_data_rtn_cnt[3:0] + 4'h1;
		end
        end
end

assign que_b3_data_val = ((que_tot_data_del_cnt[3:0] - 4'h1) == que_b3_data_rtn_cnt[3:0]);

///////////////////////////
// Gen data valid for Bank4
///////////////////////////

reg [3:0]       que_b4_data_rtn_cnt_next;
reg             que_b4_start_counting_next;
wire            que_b4_data_val;

dffrl_ns #(5)       ff_b4_data_rtn_cnt(
                .din({que_b4_data_rtn_cnt_next[3:0],
                        que_b4_start_counting_next}),
                .q({que_b4_data_rtn_cnt[3:0], que_b4_start_counting}),
                .rst_l(rst_l),
                .clk(clk));

always @(/*AUTOSENSE*/que_b4_data_rtn_cnt 
	 or que_b4_data_val or que_b4_start_counting
	 or que_cas_picked_d1 or que_mux_write_en_d1)
begin
        que_b4_data_rtn_cnt_next[3:0] = que_b4_data_rtn_cnt[3:0];
        que_b4_start_counting_next = 1'h0;
	begin
                if(que_cas_picked_d1[4] & ~que_mux_write_en_d1) que_b4_start_counting_next = 1'h1;
                if(que_b4_start_counting | (|que_b4_data_rtn_cnt[3:0]) )
                begin
			if(que_b4_data_val) que_b4_data_rtn_cnt_next[3:0] = 4'h0;
                        else que_b4_data_rtn_cnt_next[3:0] = que_b4_data_rtn_cnt[3:0] + 4'h1;
		end
        end
end

assign que_b4_data_val = ((que_tot_data_del_cnt[3:0] - 4'h1) == que_b4_data_rtn_cnt[3:0]);

///////////////////////////
// Gen data valid for Bank5
///////////////////////////

reg [3:0]       que_b5_data_rtn_cnt_next;
reg             que_b5_start_counting_next;
wire            que_b5_data_val;

dffrl_ns #(5)       ff_b5_data_rtn_cnt(
                .din({que_b5_data_rtn_cnt_next[3:0],
                        que_b5_start_counting_next}),
                .q({que_b5_data_rtn_cnt[3:0], que_b5_start_counting}),
                .rst_l(rst_l),
                .clk(clk));

always @(/*AUTOSENSE*/que_b5_data_rtn_cnt 
	 or que_b5_data_val or que_b5_start_counting
	 or que_cas_picked_d1 or que_mux_write_en_d1)
begin
        que_b5_data_rtn_cnt_next[3:0] = que_b5_data_rtn_cnt[3:0];
        que_b5_start_counting_next = 1'h0;
	begin
                if(que_cas_picked_d1[5] & ~que_mux_write_en_d1) que_b5_start_counting_next = 1'h1;
                if(que_b5_start_counting | (|que_b5_data_rtn_cnt[3:0]) )
                begin
			if(que_b5_data_val) que_b5_data_rtn_cnt_next[3:0] = 4'h0;
                        else que_b5_data_rtn_cnt_next[3:0] = que_b5_data_rtn_cnt[3:0] + 4'h1;
		end
        end
end

assign que_b5_data_val = ((que_tot_data_del_cnt[3:0] - 4'h1) == que_b5_data_rtn_cnt[3:0]);

///////////////////////////
// Gen data valid for Bank6
///////////////////////////

reg [3:0]       que_b6_data_rtn_cnt_next;
reg             que_b6_start_counting_next;
wire            que_b6_data_val;

dffrl_ns #(5)       ff_b6_data_rtn_cnt(
                .din({que_b6_data_rtn_cnt_next[3:0],
                        que_b6_start_counting_next}),
                .q({que_b6_data_rtn_cnt[3:0], que_b6_start_counting}),
                .rst_l(rst_l),
                .clk(clk));

always @(/*AUTOSENSE*/que_b6_data_rtn_cnt 
	 or que_b6_data_val or que_b6_start_counting
	 or que_cas_picked_d1 or que_mux_write_en_d1)
begin
        que_b6_data_rtn_cnt_next[3:0] = que_b6_data_rtn_cnt[3:0];
        que_b6_start_counting_next = 1'h0;
	begin
                if(que_cas_picked_d1[6] & ~que_mux_write_en_d1) que_b6_start_counting_next = 1'h1;
                if(que_b6_start_counting | (|que_b6_data_rtn_cnt[3:0]) )
		begin
                	if(que_b6_data_val) que_b6_data_rtn_cnt_next[3:0] = 4'h0;
                        else que_b6_data_rtn_cnt_next[3:0] = que_b6_data_rtn_cnt[3:0] + 4'h1;
		end
        end
end

assign que_b6_data_val = ((que_tot_data_del_cnt[3:0] - 4'h1) == que_b6_data_rtn_cnt[3:0]);

///////////////////////////
// Gen data valid for Bank7
///////////////////////////

reg [3:0]       que_b7_data_rtn_cnt_next;
reg             que_b7_start_counting_next;
wire            que_b7_data_val;

dffrl_ns #(5)       ff_b7_data_rtn_cnt(
                .din({que_b7_data_rtn_cnt_next[3:0],
                        que_b7_start_counting_next}),
                .q({que_b7_data_rtn_cnt[3:0], que_b7_start_counting}),
                .rst_l(rst_l),
                .clk(clk));

always @(/*AUTOSENSE*/que_b7_data_rtn_cnt 
	 or que_b7_data_val or que_b7_start_counting
	 or que_cas_picked_d1 or que_mux_write_en_d1)
begin
        que_b7_data_rtn_cnt_next[3:0] = que_b7_data_rtn_cnt[3:0];
        que_b7_start_counting_next = 1'h0;
        begin
                if(que_cas_picked_d1[7] & ~que_mux_write_en_d1) que_b7_start_counting_next = 1'h1;
                if(que_b7_start_counting | (|que_b7_data_rtn_cnt[3:0]) )
		begin
                	if(que_b7_data_val) que_b7_data_rtn_cnt_next[3:0] = 4'h0;
                        else que_b7_data_rtn_cnt_next[3:0] = que_b7_data_rtn_cnt[3:0] + 4'h1;
		end
        end
end

assign que_b7_data_val = ((que_tot_data_del_cnt[3:0] - 4'h1) == que_b7_data_rtn_cnt[3:0]);

//////////////
// MARGIN BITS
//////////////

wire [4:0] que_margin_reg_in = ~rst_l ? que_margin_reg : 
				que_ucb_wr_req_vld & (que_ucb_addr == 32'h230) & ~sehold ? 
				que_ucb_data[7:3] : que_margin_reg;

dffsl_async_ns #(3)     ff_margin_bits_s(
                .din({que_margin_reg_in[4], que_margin_reg_in[2], que_margin_reg_in[0]}),
                .q({que_margin_reg[4], que_margin_reg[2], que_margin_reg[0]}),
		.set_l(arst_l),
                .clk(clk));

dffrl_async_ns #(2)     ff_margin_bits_r(
                .din({que_margin_reg_in[3], que_margin_reg_in[1]}),
                .q({que_margin_reg[3], que_margin_reg[1]}),
		.rst_l(arst_l),
                .clk(clk));

/////////////////////////////////////////////////////////
// PERFORMANCE COUNTERS
/////////////////////////////////////////////////////////

wire que_perf_cntl_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'h400);
wire [7:0] que_perf_cntl_reg_in = que_ucb_data[7:0];

dffrle_ns #(8)  ff_perf_cntl_reg(
                .din(que_perf_cntl_reg_in),
                .en(que_perf_cntl_reg_en),
                .q(que_perf_cntl_reg),
                .rst_l(rst_l),
                .clk(clk));

// Due to timing issues we have to flop some critical siganls and then do the increment 
// of the perf counter in the following cycle.

dff_ns #(12)  ff_crit_sig(
                .din({que_rd_xaction_picked, que_wr_xaction_picked, que_bank_busy_stall,
			que_rd_que_latency[3:0], que_wr_que_latency[3:0], que_writeback_buf_hit}),
                .q({que_rd_xaction_picked_d1, que_wr_xaction_picked_d1, que_bank_busy_stall_d1,
			que_rd_que_latency_d1[3:0], que_wr_que_latency_d1[3:0], que_writeback_buf_hit_d1}),
                .clk(clk));

wire que_perf_cnt0_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'h408) | ~que_perf_cntl_reg[7];
wire [31:0] que_perf_cnt0_reg_in = que_ucb_wr_req_vld & (que_ucb_addr == 32'h408) ? que_ucb_data[63:32] :
				(que_perf_cntl_reg[6:4] == 3'h0) ? 
	{(que_perf_cnt0_reg[31] | (que_perf_cnt0_reg[30:0] == 31'h7fffffff) & que_rd_xaction_picked_d1), 
			(que_perf_cnt0_reg[30:0] + {30'h0, que_rd_xaction_picked_d1}) } : 
				(que_perf_cntl_reg[6:4] == 3'h1) ? 
	{(que_perf_cnt0_reg[31] | (que_perf_cnt0_reg[30:0] == 31'h7fffffff) & que_wr_xaction_picked_d1), 
			(que_perf_cnt0_reg[30:0] + {30'h0, que_wr_xaction_picked_d1}) } : 
				(que_perf_cntl_reg[6:4] == 3'h2) ? 
	{(que_perf_cnt0_reg[31] | (que_perf_cnt0_reg[30:0] == 31'h7fffffff) & que_rd_or_wr_xaction_picked_d1), 
			(que_perf_cnt0_reg[30:0] + {30'h0, que_rd_or_wr_xaction_picked_d1})} : 
				(que_perf_cntl_reg[6:4] == 3'h3) ?  
	{(que_perf_cnt0_reg[31] | (que_perf_cnt0_reg[30:0] == 31'h7fffffff) & que_bank_busy_stall_d1), 
			(que_perf_cnt0_reg[30:0] + {30'h0, que_bank_busy_stall_d1})} : 
				(que_perf_cntl_reg[6:4] == 3'h4) ?  
	{(que_perf_cnt0_reg[31] | ((que_perf_cnt0_reg[31:0] + {28'h0, que_rd_que_latency_d1}) > 32'h7fffffff)), 
			(que_perf_cnt0_reg[30:0] + {27'h0, que_rd_que_latency_d1})} : 
				(que_perf_cntl_reg[6:4] == 3'h5) ?  
	{(que_perf_cnt0_reg[31] | ((que_perf_cnt0_reg[31:0] + {28'h0, que_wr_que_latency_d1}) > 32'h7fffffff)), 
			(que_perf_cnt0_reg[30:0] + {27'h0, que_wr_que_latency_d1})} : 
				(que_perf_cntl_reg[6:4] == 3'h6) ?  
	{(que_perf_cnt0_reg[31] | ((que_perf_cnt0_reg[31:0] + {27'h0, que_rd_or_wr_que_latency_d1}) > 32'h7fffffff)), 
			(que_perf_cnt0_reg[30:0] + {26'h0, que_rd_or_wr_que_latency_d1})} : 
	{(que_perf_cnt0_reg[31] | (que_perf_cnt0_reg[30:0] == 31'h7fffffff) & que_writeback_buf_hit_d1), 
			(que_perf_cnt0_reg[30:0] + {30'h0, que_writeback_buf_hit_d1})}; 

dffrle_ns #(32)  ff_perf_cnt0_reg(
                .din(que_perf_cnt0_reg_in),
                .en(que_perf_cnt0_reg_en),
                .q(que_perf_cnt0_reg),
                .rst_l(rst_l),
                .clk(clk));

wire que_perf_cnt1_reg_en = que_ucb_wr_req_vld & (que_ucb_addr == 32'h408) | ~que_perf_cntl_reg[3];
wire [31:0] que_perf_cnt1_reg_in = que_ucb_wr_req_vld & (que_ucb_addr == 32'h408) ? que_ucb_data[31:0] :
                                (que_perf_cntl_reg[2:0] == 3'h0) ?
        {(que_perf_cnt1_reg[31] | (que_perf_cnt1_reg[30:0] == 31'h7fffffff) & que_rd_xaction_picked_d1),
                        (que_perf_cnt1_reg[30:0] + {30'h0, que_rd_xaction_picked_d1}) } :
                                (que_perf_cntl_reg[2:0] == 3'h1) ?
        {(que_perf_cnt1_reg[31] | (que_perf_cnt1_reg[30:0] == 31'h7fffffff) & que_wr_xaction_picked_d1),
                        (que_perf_cnt1_reg[30:0] + {30'h0, que_wr_xaction_picked_d1}) } :
                                (que_perf_cntl_reg[2:0] == 3'h2) ?
        {(que_perf_cnt1_reg[31] | (que_perf_cnt1_reg[30:0] == 31'h7fffffff) & que_rd_or_wr_xaction_picked_d1),
                        (que_perf_cnt1_reg[30:0] + {30'h0, que_rd_or_wr_xaction_picked_d1})} :
                                (que_perf_cntl_reg[2:0] == 3'h3) ?
        {(que_perf_cnt1_reg[31] | (que_perf_cnt1_reg[30:0] == 31'h7fffffff) & que_bank_busy_stall_d1),
                        (que_perf_cnt1_reg[30:0] + {30'h0, que_bank_busy_stall_d1})} :              
                                (que_perf_cntl_reg[2:0] == 3'h4) ? 
        {(que_perf_cnt1_reg[31] | ((que_perf_cnt1_reg[31:0] + {28'h0, que_rd_que_latency_d1}) > 32'h7fffffff)),    
                        (que_perf_cnt1_reg[30:0] + {27'h0, que_rd_que_latency_d1})} :        
                                (que_perf_cntl_reg[2:0] == 3'h5) ?
        {(que_perf_cnt1_reg[31] | ((que_perf_cnt1_reg[31:0] + {28'h0, que_wr_que_latency_d1}) > 32'h7fffffff)),       
                        (que_perf_cnt1_reg[30:0] + {27'h0, que_wr_que_latency_d1})} :
                                (que_perf_cntl_reg[2:0] == 3'h6) ?
        {(que_perf_cnt1_reg[31] | ((que_perf_cnt1_reg[31:0] + {27'h0, que_rd_or_wr_que_latency_d1}) > 32'h7fffffff)), 
                        (que_perf_cnt1_reg[30:0] + {26'h0, que_rd_or_wr_que_latency_d1})} :
        {(que_perf_cnt1_reg[31] | (que_perf_cnt1_reg[30:0] == 31'h7fffffff) & que_writeback_buf_hit_d1),
                        (que_perf_cnt1_reg[30:0] + {30'h0, que_writeback_buf_hit_d1})};

dffrle_ns #(32)  ff_perf_cnt1_reg(
                .din(que_perf_cnt1_reg_in),
                .en(que_perf_cnt1_reg_en),
                .q(que_perf_cnt1_reg),
                .rst_l(rst_l), 
                .clk(clk));

// This CAS PICKED is generated to cover 2 ch mode case too! 
wire b0_cas_picked_int = que_channel_disabled ? ch0_que_cas_int_picked[0] : b0_cas_picked;
wire b1_cas_picked_int = que_channel_disabled ? ch0_que_cas_int_picked[1] : b1_cas_picked;
wire b2_cas_picked_int = que_channel_disabled ? ch0_que_cas_int_picked[2] : b2_cas_picked;
wire b3_cas_picked_int = que_channel_disabled ? ch0_que_cas_int_picked[3] : b3_cas_picked;
wire b4_cas_picked_int = que_channel_disabled ? ch0_que_cas_int_picked[4] : b4_cas_picked;
wire b5_cas_picked_int = que_channel_disabled ? ch0_que_cas_int_picked[5] : b5_cas_picked;
wire b6_cas_picked_int = que_channel_disabled ? ch0_que_cas_int_picked[6] : b6_cas_picked;
wire b7_cas_picked_int = que_channel_disabled ? ch0_que_cas_int_picked[7] : b7_cas_picked;

wire que_cas_picked_for_perf = b0_cas_picked_int | b1_cas_picked_int | b2_cas_picked_int |
				b3_cas_picked_int | b4_cas_picked_int | b5_cas_picked_int |
				b6_cas_picked_int | b7_cas_picked_int;
wire que_cmd_write = que_channel_disabled ? ch0_que_mux_write_en : que_mux_write_en;
wire que_cas_ch_picked = que_channel_disabled ? ch0_que_wr_cas_ch01_picked : que_wr_cas_ch01_picked;

// READ XACTION
assign que_rd_xaction_picked = que_cas_picked_for_perf & ~que_cmd_write & (que_pos == 5'ha | que_pos == 5'hb |
				que_pos == 5'hd) & (que_cas_ch_picked == que_channel_disabled); 

// WRITE XACTION
assign que_wr_xaction_picked = que_cas_picked_for_perf & que_cmd_write & (que_pos == 5'ha | que_pos == 5'hb |
				que_pos == 5'hd) & (que_cas_ch_picked == que_channel_disabled);

// READ OR WRITE XACTION
assign que_rd_or_wr_xaction_picked_d1 = que_rd_xaction_picked_d1 | que_wr_xaction_picked_d1;

// BANK BUSY STALLS
assign que_bank_busy_stall = (que_b0_index_ent0[6] | que_b0_index_ent1[6] | que_b0_index_ent2[6] |
				que_b0_index_ent3[6] | que_b0_index_ent4[6] | que_b0_index_ent5[6] |
			que_b0_index_ent6[6] | que_b0_index_ent7[6] | que_b0_wr_index_ent0[6] |
			que_b0_wr_index_ent1[6] | que_b0_wr_index_ent2[6] | que_b0_wr_index_ent3[6] | 
			que_b0_wr_index_ent4[6] | que_b0_wr_index_ent5[6] | que_b0_wr_index_ent6[6] | 
			que_b0_wr_index_ent7[6]) & ~( (|que_ras_picked[7:0]) | que_cas_picked_for_perf ) & 
				(que_pos == 5'ha | que_pos == 5'hb | que_pos == 5'hd) & que_init_status_reg;

// READ QUE LATENCY
assign que_rd_que_latency = ({3'h0, que_b0_index_ent0[6]} + {3'h0, que_b0_index_ent1[6]} + 
				{3'h0, que_b0_index_ent2[6]} + {3'h0, que_b0_index_ent3[6]} +
				{3'h0, que_b0_index_ent4[6]} + {3'h0, que_b0_index_ent5[6]} +
				{3'h0, que_b0_index_ent6[6]} + {3'h0, que_b0_index_ent7[6]} - 
				{3'h0, (|que_ras_picked[7:0]) & ~que_cmd_picked & ~que_scrb_picked &
					(que_channel_picked_internal == que_channel_disabled)} - 
			{3'h0, (|que_ras_picked_d1[7:0]) & ~que_cmd_picked_d1 & ~que_scrb_picked_d1 &
					(que_channel_picked_internal_d1 == que_channel_disabled)}) &
			{4{(que_pos == 5'ha | que_pos == 5'hb | que_pos == 5'hc | que_pos == 5'hd)}} &
				{4{que_init_status_reg}}; 

// WRITE QUE LATENCY
assign que_wr_que_latency = ({3'h0, que_b0_wr_index_ent0[6]} + {3'h0, que_b0_wr_index_ent1[6]} + 
                                {3'h0, que_b0_wr_index_ent2[6]} + {3'h0, que_b0_wr_index_ent3[6]} +
                                {3'h0, que_b0_wr_index_ent4[6]} + {3'h0, que_b0_wr_index_ent5[6]} +
                                {3'h0, que_b0_wr_index_ent6[6]} + {3'h0, que_b0_wr_index_ent7[6]} -
				{3'h0, (|que_ras_picked[7:0]) & que_cmd_picked & ~que_scrb_picked & 
					(que_channel_picked_internal == que_channel_disabled)} - 
			{3'h0, (|que_ras_picked_d1[7:0]) & que_cmd_picked_d1 & ~que_scrb_picked_d1 &
					(que_channel_picked_internal_d1 == que_channel_disabled)}) &
			{4{(que_pos == 5'ha | que_pos == 5'hb | que_pos == 5'hc | que_pos == 5'hd)}} &
				{4{que_init_status_reg}};

// READ OR WRITE QUE LATENCY
assign que_rd_or_wr_que_latency_d1 = {1'b0, que_rd_que_latency_d1[3:0]} + {1'b0, que_wr_que_latency_d1[3:0]};

// WRITEBACK BUFFER HITS
assign que_writeback_buf_hit = que_b0_wr_index_pend & que_b0_rd_picked & (|que_ras_picked[7:0]) &
				(que_channel_picked_internal == que_channel_disabled) &
				(que_pos == 5'ha | que_pos == 5'hb | que_pos == 5'hd) &
				que_init_status_reg;

endmodule 
