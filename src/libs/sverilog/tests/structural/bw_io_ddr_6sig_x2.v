// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_6sig_x2.v
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
module bw_io_ddr_6sig_x2(ps_select_i_l ,testmode_l_i_l ,test_mode_i_l ,
     testmode_l_i_r ,test_mode_i_r ,serial_out ,serial_in ,afo ,
     pad_clk_so ,afi ,vrefcode_i_l ,vrefcode_i_r ,dq_pad ,
     io_dram_data_in ,io_dram_data_in_hi ,data_neg ,data_pos ,dqs_pad ,
     ps_select_i_r ,ctl_pad_1 ,bso ,ctl_data_0 ,pad_clk_si ,
     bypass_enable_i_l ,vdd_h ,strobe_i_r ,lpf_code_i_r ,
     burst_length_four_i_r ,dram_io_ptr_clk_inv_i_r ,
     dram_io_pad_enable_i_r ,dram_io_drive_enable_i_r ,rst_l_i_r , arst_l_i_r, 
     pad_pos_cnt_i_r ,pad_neg_cnt_i_r ,dram_io_channel_disabled_i_r ,
     dram_io_drive_data_i_r ,cbu_i_r ,cbd_i_r ,se_i_r ,mode_ctrl_i_r ,
     shift_dr_i_r ,clock_dr_i_r ,hiz_n_i_r ,update_dr_i_r ,strobe_i_l ,
     lpf_code_i_l ,burst_length_four_i_l ,dram_io_ptr_clk_inv_i_l ,
     dram_io_pad_enable_i_l ,dram_io_drive_enable_i_l ,ctl_data_1 ,
     rst_l_i_l , arst_l_i_l, pad_pos_cnt_i_l ,pad_neg_cnt_i_l ,
     dram_io_channel_disabled_i_l ,dram_io_drive_data_i_l ,cbu_i_l ,
     cbd_i_l ,se_i_l ,mode_ctrl_i_l ,shift_dr_i_l ,clock_dr_i_l ,
     hiz_n_i_l ,update_dr_i_l ,rclk ,bypass_enable_i_r ,bsi ,ctl_pad_0
      );
output [7:0]	serial_out ;
output [7:0]	afi ;
output [7:0]	io_dram_data_in ;
output [7:0]	io_dram_data_in_hi ;
input [7:0]	serial_in ;
input [7:0]	afo ;
input [7:0]	vrefcode_i_l ;
input [7:0]	vrefcode_i_r ;
input [7:0]	data_neg ;
input [7:0]	data_pos ;
input [4:0]	lpf_code_i_r ;
input [1:0]	dram_io_ptr_clk_inv_i_r ;
input [1:0]	pad_pos_cnt_i_r ;
input [1:0]	pad_neg_cnt_i_r ;
input [8:1]	cbu_i_r ;
input [8:1]	cbd_i_r ;
input [4:0]	lpf_code_i_l ;
input [1:0]	dram_io_ptr_clk_inv_i_l ;
input [1:0]	pad_pos_cnt_i_l ;
input [1:0]	pad_neg_cnt_i_l ;
input [8:1]	cbu_i_l ;
input [8:1]	cbd_i_l ;
inout [7:0]	dq_pad ;
inout [1:0]	dqs_pad ;
output		pad_clk_so ;
output		bso ;
input		ps_select_i_l ;
input		testmode_l_i_l ;
input		test_mode_i_l ;
input		testmode_l_i_r ;
input		test_mode_i_r ;
input		ps_select_i_r ;
input		ctl_data_0 ;
input		pad_clk_si ;
input		bypass_enable_i_l ;
input		vdd_h ;
input		strobe_i_r ;
input		burst_length_four_i_r ;
input		dram_io_pad_enable_i_r ;
input		dram_io_drive_enable_i_r ;
input		rst_l_i_r ;
input		arst_l_i_r ;
input		dram_io_channel_disabled_i_r ;
input		dram_io_drive_data_i_r ;
input		se_i_r ;
input		mode_ctrl_i_r ;
input		shift_dr_i_r ;
input		clock_dr_i_r ;
input		hiz_n_i_r ;
input		update_dr_i_r ;
input		strobe_i_l ;
input		burst_length_four_i_l ;
input		dram_io_pad_enable_i_l ;
input		dram_io_drive_enable_i_l ;
input		ctl_data_1 ;
input		rst_l_i_l ;
input		arst_l_i_l ;
input		dram_io_channel_disabled_i_l ;
input		dram_io_drive_data_i_l ;
input		se_i_l ;
input		mode_ctrl_i_l ;
input		shift_dr_i_l ;
input		clock_dr_i_l ;
input		hiz_n_i_l ;
input		update_dr_i_l ;
input		rclk ;
input		bypass_enable_i_r ;
input		bsi ;
inout		ctl_pad_1 ;
inout		ctl_pad_0 ;
 
wire		clk_out0 ;
wire		clk_out1 ;
wire		dll_s0 ;
wire		dll_s1 ;
wire		bs0 ;
wire		strobe0 ;
wire		strobe1 ;
wire		dl_clk_in0 ;
wire		dl_clk_in1 ;
wire		pad_clk_s0 ;
wire		dl_clk_out0 ;
wire		dl_clk_out1 ;
 
 
bw_io_ddr_6sig ddr_6sig0 (
     .serial_out      ({serial_out[3:0] } ),
     .serial_in       ({serial_in[3:0] } ),
     .vrefcode        ({vrefcode_i_l } ),
     .io_dram_data_in_hi ({io_dram_data_in_hi[3:0] } ),
     .afo             ({afo[3:0] } ),
     .afi             ({afi[3:0] } ),
     .dram_io_ptr_clk_inv ({dram_io_ptr_clk_inv_i_l } ),
     .dq_pad          ({dq_pad[3:0] } ),
     .io_dram_data_in ({io_dram_data_in[3:0] } ),
     .data_pos        ({data_pos[3:0] } ),
     .data_neg        ({data_neg[3:0] } ),
     .pad_neg_cnt     ({pad_neg_cnt_i_l } ),
     .pad_pos_cnt     ({pad_pos_cnt_i_l } ),
     .cbu             ({cbu_i_l } ),
     .cbd             ({cbd_i_l } ),
     .testmode_l      (testmode_l_i_l ),
     .test_mode       (test_mode_i_l ),
     .clk_out         (clk_out0 ),
     .mode_ctrl       (mode_ctrl_i_l ),
     .pad_clk_si      (pad_clk_si ),
     .rclk            (rclk ),
     .pad_clk_so      (dll_s0 ),
     .bypass_enable   (bypass_enable_i_l ),
     .ps_select       (ps_select_i_l ),
     .ctl_pad         (ctl_pad_0 ),
     .dqs_pad         (dqs_pad[0] ),
     .clk_sel         (dl_clk_in0 ),
     .vdd_h           (vdd_h ),
     .se              (se_i_l ),
     .bso             (bs0 ),
     .bsi             (bsi ),
     .hiz_n           (hiz_n_i_l ),
     .clock_dr        (clock_dr_i_l ),
     .shift_dr        (shift_dr_i_l ),
     .data            (ctl_data_0 ),
     .dram_io_drive_data (dram_io_drive_data_i_l ),
     .dram_io_channel_disabled (dram_io_channel_disabled_i_l ),
     .update_dr       (update_dr_i_l ),
     .rst_l           (rst_l_i_l ),
     .arst_l          (arst_l_i_l ),
     .dram_io_pad_enable (dram_io_pad_enable_i_l ),
     .dram_io_drive_enable (dram_io_drive_enable_i_l ),
     .dqs_read        (dl_clk_out0 ),
     .burst_length_four (burst_length_four_i_l ) );
bw_io_ddr_6sig ddr_6sig1 (
     .serial_out      ({serial_out[7:4] } ),
     .serial_in       ({serial_in[7:4] } ),
     .vrefcode        ({vrefcode_i_r } ),
     .io_dram_data_in_hi ({io_dram_data_in_hi[7:4] } ),
     .afo             ({afo[7:4] } ),
     .afi             ({afi[7:4] } ),
     .dram_io_ptr_clk_inv ({dram_io_ptr_clk_inv_i_r } ),
     .dq_pad          ({dq_pad[7:4] } ),
     .io_dram_data_in ({io_dram_data_in[7:4] } ),
     .data_pos        ({data_pos[7:4] } ),
     .data_neg        ({data_neg[7:4] } ),
     .pad_neg_cnt     ({pad_neg_cnt_i_r } ),
     .pad_pos_cnt     ({pad_pos_cnt_i_r } ),
     .cbu             ({cbu_i_r } ),
     .cbd             ({cbd_i_r } ),
     .testmode_l      (testmode_l_i_r ),
     .test_mode       (test_mode_i_r ),
     .clk_out         (clk_out1 ),
     .mode_ctrl       (mode_ctrl_i_r ),
     .pad_clk_si      (pad_clk_s0 ),
     .rclk            (rclk ),
     .pad_clk_so      (dll_s1 ),
     .bypass_enable   (bypass_enable_i_r ),
     .ps_select       (ps_select_i_r ),
     .ctl_pad         (ctl_pad_1 ),
     .dqs_pad         (dqs_pad[1] ),
     .clk_sel         (dl_clk_in1 ),
     .vdd_h           (vdd_h ),
     .se              (se_i_r ),
     .bso             (bso ),
     .bsi             (bs0 ),
     .hiz_n           (hiz_n_i_r ),
     .clock_dr        (clock_dr_i_r ),
     .shift_dr        (shift_dr_i_r ),
     .data            (ctl_data_1 ),
     .dram_io_drive_data (dram_io_drive_data_i_r ),
     .dram_io_channel_disabled (dram_io_channel_disabled_i_r ),
     .update_dr       (update_dr_i_r ),
     .rst_l           (rst_l_i_r ),
     .arst_l          (arst_l_i_r ),
     .dram_io_pad_enable (dram_io_pad_enable_i_r ),
     .dram_io_drive_enable (dram_io_drive_enable_i_r ),
     .dqs_read        (dl_clk_out1 ),
     .burst_length_four (burst_length_four_i_r ) );
bw_ioslave_dl io_slave_dl0 (
     .lpf_out         ({lpf_code_i_l } ),
     .dqs_in          (dl_clk_in0 ),
     .si              (dll_s0 ),
     .se              (se_i_l ),
     .strobe          (strobe0 ),
     .so              (pad_clk_s0 ),
     .dqs_out         (dl_clk_out0 ) );
bw_ioslave_dl io_slave_dl1 (
     .lpf_out         ({lpf_code_i_r } ),
     .dqs_in          (dl_clk_in1 ),
     .si              (dll_s1 ),
     .se              (se_i_r ),
     .strobe          (strobe1 ),
     .so              (pad_clk_so ),
     .dqs_out         (dl_clk_out1 ) );
bw_io_ddr_testmux testmux0 (
     .strobe_out      (strobe0 ),
     .clk             (clk_out0 ),
     .testmode_l      (testmode_l_i_l ),
     .strobe          (strobe_i_l ) );
bw_io_ddr_testmux testmux1 (
     .strobe_out      (strobe1 ),
     .clk             (clk_out1 ),
     .testmode_l      (testmode_l_i_r ),
     .strobe          (strobe_i_r ) );
endmodule
