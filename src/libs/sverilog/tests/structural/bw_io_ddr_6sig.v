// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_6sig.v
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
module bw_io_ddr_6sig(testmode_l ,test_mode ,serial_out ,serial_in ,
     clk_out ,mode_ctrl ,pad_clk_si ,vrefcode ,rclk ,pad_clk_so ,
     io_dram_data_in_hi ,bypass_enable ,ps_select ,afo ,afi ,
     dram_io_ptr_clk_inv ,ctl_pad ,dqs_pad ,dq_pad ,clk_sel ,
     io_dram_data_in ,vdd_h ,se ,bso ,bsi ,hiz_n ,clock_dr ,shift_dr ,
     data ,dram_io_drive_data ,dram_io_channel_disabled ,data_pos ,
     data_neg ,update_dr ,rst_l ,arst_l, pad_neg_cnt ,pad_pos_cnt ,
     dram_io_pad_enable ,dram_io_drive_enable ,dqs_read ,cbu ,cbd ,
     burst_length_four );
output [3:0]	serial_out ;
output [3:0]	io_dram_data_in_hi ;
output [3:0]	afi ;
output [3:0]	io_dram_data_in ;
input [3:0]	serial_in ;
input [7:0]	vrefcode ;
input [3:0]	afo ;
input [1:0]	dram_io_ptr_clk_inv ;
input [3:0]	data_pos ;
input [3:0]	data_neg ;
input [1:0]	pad_neg_cnt ;
input [1:0]	pad_pos_cnt ;
input [8:1]	cbu ;
input [8:1]	cbd ;
inout [3:0]	dq_pad ;
output		clk_out ;
output		pad_clk_so ;
output		clk_sel ;
output		bso ;
input		testmode_l ;
input		test_mode ;
input		mode_ctrl ;
input		pad_clk_si ;
input		rclk ;
input		bypass_enable ;
input		ps_select ;
input		vdd_h ;
input		se ;
input		bsi ;
input		hiz_n ;
input		clock_dr ;
input		shift_dr ;
input		data ;
input		dram_io_drive_data ;
input		dram_io_channel_disabled ;
input		update_dr ;
input		rst_l ;
input		arst_l ;
input		dram_io_pad_enable ;
input		dram_io_drive_enable ;
input		dqs_read ;
input		burst_length_four ;
inout		ctl_pad ;
inout		dqs_pad ;
supply1		vdd ;
supply0		vss ;
 
wire		dq2_bso_dq3_bsi ;
wire		net201 ;
wire		dq1_bso_dq2_bsi ;
wire		dq0_bso_dq1_bsi ;
wire		pad_clk_so1_si2 ;
wire		pad_clk_so2_si3 ;
wire		pad_clk_so0_si1 ;
wire		dqs_bso_ctl_bsi ;
wire		pad_clk_so3_si4 ;
wire		pad_clk_so4_si5 ;
wire		dq3_bso_dqs_bsi ;
 
 
dram_dq_pad dq_pad0 (
     .dram_io_ptr_clk_inv ({dram_io_ptr_clk_inv } ),
     .vrefcode        ({vrefcode } ),
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .pad_neg_cnt     ({pad_neg_cnt } ),
     .pad_pos_cnt     ({pad_pos_cnt } ),
     .pad             (dq_pad[0] ),
     .bypass_enable   (bypass_enable ),
     .test_mode       (test_mode ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[0] ),
     .ps_select       (ps_select ),
     .bsi             (bsi ),
     .burst_length_four (burst_length_four ),
     .clk             (net201 ),
     .clock_dr        (clock_dr ),
     .data_neg        (data_neg[0] ),
     .data_pos        (data_pos[0] ),
     .dq_pad_clk_se   (se ),
     .dq_pad_clk_si   (pad_clk_si ),
     .dqs_read        (dqs_read ),
     .dram_io_drive_enable (dram_io_drive_enable ),
     .dram_io_pad_enable (dram_io_pad_enable ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .rst_l           (rst_l ),
     .arst_l           (arst_l ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (dq0_bso_dq1_bsi ),
     .dq_pad_clk_so   (pad_clk_so0_si1 ),
     .io_dram_data_in (io_dram_data_in[0] ),
     .io_dram_data_in_hi (io_dram_data_in_hi[0] ),
     .testmode_l      (testmode_l ),
     .afi             (afi[0] ),
     .out_type        (vss ),
     .serial_out      (serial_out[0] ),
     .afo             (afo[0] ) );
dram_dq_pad dq_pad1 (
     .dram_io_ptr_clk_inv ({dram_io_ptr_clk_inv } ),
     .vrefcode        ({vrefcode } ),
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .pad_neg_cnt     ({pad_neg_cnt } ),
     .pad_pos_cnt     ({pad_pos_cnt } ),
     .pad             (dq_pad[1] ),
     .bypass_enable   (bypass_enable ),
     .test_mode       (test_mode ),
     .bypass_in       (serial_out[0] ),
     .serial_in       (serial_in[1] ),
     .ps_select       (ps_select ),
     .bsi             (dq0_bso_dq1_bsi ),
     .burst_length_four (burst_length_four ),
     .clk             (net201 ),
     .clock_dr        (clock_dr ),
     .data_neg        (data_neg[1] ),
     .data_pos        (data_pos[1] ),
     .dq_pad_clk_se   (se ),
     .dq_pad_clk_si   (pad_clk_so0_si1 ),
     .dqs_read        (dqs_read ),
     .dram_io_drive_enable (dram_io_drive_enable ),
     .dram_io_pad_enable (dram_io_pad_enable ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .rst_l           (rst_l ),
     .arst_l           (arst_l ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (dq1_bso_dq2_bsi ),
     .dq_pad_clk_so   (pad_clk_so1_si2 ),
     .io_dram_data_in (io_dram_data_in[1] ),
     .io_dram_data_in_hi (io_dram_data_in_hi[1] ),
     .testmode_l      (testmode_l ),
     .afi             (afi[1] ),
     .out_type        (vdd ),
     .serial_out      (serial_out[1] ),
     .afo             (afo[1] ) );
dram_dq_pad dq_pad2 (
     .dram_io_ptr_clk_inv ({dram_io_ptr_clk_inv } ),
     .vrefcode        ({vrefcode } ),
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .pad_neg_cnt     ({pad_neg_cnt } ),
     .pad_pos_cnt     ({pad_pos_cnt } ),
     .pad             (dq_pad[2] ),
     .bypass_enable   (bypass_enable ),
     .test_mode       (test_mode ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[2] ),
     .ps_select       (ps_select ),
     .bsi             (dq1_bso_dq2_bsi ),
     .burst_length_four (burst_length_four ),
     .clk             (net201 ),
     .clock_dr        (clock_dr ),
     .data_neg        (data_neg[2] ),
     .data_pos        (data_pos[2] ),
     .dq_pad_clk_se   (se ),
     .dq_pad_clk_si   (pad_clk_so1_si2 ),
     .dqs_read        (dqs_read ),
     .dram_io_drive_enable (dram_io_drive_enable ),
     .dram_io_pad_enable (dram_io_pad_enable ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .rst_l           (rst_l ),
     .arst_l           (arst_l ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (dq2_bso_dq3_bsi ),
     .dq_pad_clk_so   (pad_clk_so2_si3 ),
     .io_dram_data_in (io_dram_data_in[2] ),
     .io_dram_data_in_hi (io_dram_data_in_hi[2] ),
     .testmode_l      (testmode_l ),
     .afi             (afi[2] ),
     .out_type        (vss ),
     .serial_out      (serial_out[2] ),
     .afo             (afo[2] ) );
dram_dq_pad dq_pad3 (
     .dram_io_ptr_clk_inv ({dram_io_ptr_clk_inv } ),
     .vrefcode        ({vrefcode } ),
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .pad_neg_cnt     ({pad_neg_cnt } ),
     .pad_pos_cnt     ({pad_pos_cnt } ),
     .pad             (dq_pad[3] ),
     .bypass_enable   (bypass_enable ),
     .test_mode       (test_mode ),
     .bypass_in       (serial_out[2] ),
     .serial_in       (serial_in[3] ),
     .ps_select       (ps_select ),
     .bsi             (dq2_bso_dq3_bsi ),
     .burst_length_four (burst_length_four ),
     .clk             (clk_out ),
     .clock_dr        (clock_dr ),
     .data_neg        (data_neg[3] ),
     .data_pos        (data_pos[3] ),
     .dq_pad_clk_se   (se ),
     .dq_pad_clk_si   (pad_clk_so2_si3 ),
     .dqs_read        (dqs_read ),
     .dram_io_drive_enable (dram_io_drive_enable ),
     .dram_io_pad_enable (dram_io_pad_enable ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .rst_l           (rst_l ),
     .arst_l           (arst_l ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (dq3_bso_dqs_bsi ),
     .dq_pad_clk_so   (pad_clk_so3_si4 ),
     .io_dram_data_in (io_dram_data_in[3] ),
     .io_dram_data_in_hi (io_dram_data_in_hi[3] ),
     .testmode_l      (testmode_l ),
     .afi             (afi[3] ),
     .out_type        (vdd ),
     .serial_out      (serial_out[3] ),
     .afo             (afo[3] ) );
bw_u1_ckbuf_19x I95 (
     .clk             (net201 ),
     .rclk            (rclk ) );
bw_u1_ckbuf_11x I96 (
     .clk             (clk_out ),
     .rclk            (rclk ) );
dram_ctl_pad ctl_pad0 (
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .vrefcode        ({vrefcode } ),
     .pad             (ctl_pad ),
     .ctl_pad_clk_si  (pad_clk_so4_si5 ),
     .testmode_l      (testmode_l ),
     .bsi             (dqs_bso_ctl_bsi ),
     .clk             (clk_out ),
     .clock_dr        (clock_dr ),
     .data            (data ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .ctl_pad_clk_se  (se ),
     .rst_l           (rst_l ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (bso ),
     .ctl_pad_clk_so  (pad_clk_so ) );
dram_dqs_pad dqs_pad0 (
     .vrefcode        ({vrefcode } ),
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .odt_enable_mask (dram_io_ptr_clk_inv[0] ),
     .pad             (dqs_pad ),
     .testmode_l      (testmode_l ),
     .bsi             (dq3_bso_dqs_bsi ),
     .clk             (clk_out ),
     .clock_dr        (clock_dr ),
     .dqs_pad_clk_se  (se ),
     .dqs_pad_clk_si  (pad_clk_so3_si4 ),
     .dram_io_channel_disabled (dram_io_channel_disabled ),
     .dram_io_drive_data (dram_io_drive_data ),
     .dram_io_drive_enable (dram_io_drive_enable ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (dqs_bso_ctl_bsi ),
     .clk_sel         (clk_sel ),
     .dqs_pad_clk_so  (pad_clk_so4_si5 ) );
endmodule
