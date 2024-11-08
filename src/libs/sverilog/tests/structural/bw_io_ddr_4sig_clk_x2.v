// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_4sig_clk_x2.v
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
module bw_io_ddr_4sig_clk_x2(pad_clk_si ,testmode_l_i_r ,pad_clk_so ,
     vrefcode_i_l ,vrefcode_i_r ,testmode_l_i_l ,dram_ck_n ,dram_ck_p ,
     shift_dr_i_l ,clock_dr_i_l ,cbd_i_l ,se_i_l ,update_dr_i_l ,cbu_i_l
      ,mode_ctrl_i_l ,hiz_n_i_l ,dram_io_clk_enable ,bso ,bsi ,cbu_i_r ,
     cbd_i_r ,se_i_r ,mode_ctrl_i_r ,shift_dr_i_r ,clock_dr_i_r ,
     hiz_n_i_r ,update_dr_i_r ,rclk ,vdd_h );
input [7:0]	vrefcode_i_l ;
input [7:0]	vrefcode_i_r ;
input [8:1]	cbd_i_l ;
input [8:1]	cbu_i_l ;
input [8:1]	cbu_i_r ;
input [8:1]	cbd_i_r ;
inout [3:0]	dram_ck_n ;
inout [3:0]	dram_ck_p ;
output		pad_clk_so ;
output		bso ;
input		pad_clk_si ;
input		testmode_l_i_r ;
input		testmode_l_i_l ;
input		shift_dr_i_l ;
input		clock_dr_i_l ;
input		se_i_l ;
input		update_dr_i_l ;
input		mode_ctrl_i_l ;
input		hiz_n_i_l ;
input		dram_io_clk_enable ;
input		bsi ;
input		se_i_r ;
input		mode_ctrl_i_r ;
input		shift_dr_i_r ;
input		clock_dr_i_r ;
input		hiz_n_i_r ;
input		update_dr_i_r ;
input		rclk ;
input		vdd_h ;
supply1		vdd ;
supply0		vss ;
 
wire		clk_pad_clk_s0 ;
wire		bs0 ;
 
 
bw_io_ddr_4sig_clk ddr_4sig_clk0 (
     .vrefcode        ({vrefcode_i_l } ),
     .dram_ck         ({dram_ck_p[1:0] ,dram_ck_n[1:0] } ),
     .clk_value       ({vdd ,vdd ,vss ,vss } ),
     .cbu             ({cbu_i_l } ),
     .cbd             ({cbd_i_l } ),
     .dram_io_clk_enable (dram_io_clk_enable ),
     .testmode_l      (testmode_l_i_l ),
     .pad_clk_si      (pad_clk_si ),
     .pad_clk_so      (clk_pad_clk_s0 ),
     .se              (se_i_l ),
     .rclk            (rclk ),
     .mode_ctrl       (mode_ctrl_i_l ),
     .vdd_h           (vdd_h ),
     .bso             (bs0 ),
     .bsi             (bsi ),
     .hiz_n           (hiz_n_i_l ),
     .clock_dr        (clock_dr_i_l ),
     .shift_dr        (shift_dr_i_l ),
     .update_dr       (update_dr_i_l ) );
bw_io_ddr_4sig_clk ddr_4sig_clk1 (
     .vrefcode        ({vrefcode_i_r } ),
     .dram_ck         ({dram_ck_p[3:2] ,dram_ck_n[3:2] } ),
     .clk_value       ({vdd ,vdd ,vss ,vss } ),
     .cbu             ({cbu_i_r } ),
     .cbd             ({cbd_i_r } ),
     .dram_io_clk_enable (dram_io_clk_enable ),
     .testmode_l      (testmode_l_i_r ),
     .pad_clk_si      (clk_pad_clk_s0 ),
     .pad_clk_so      (pad_clk_so ),
     .se              (se_i_r ),
     .rclk            (rclk ),
     .mode_ctrl       (mode_ctrl_i_r ),
     .vdd_h           (vdd_h ),
     .bso             (bso ),
     .bsi             (bs0 ),
     .hiz_n           (hiz_n_i_r ),
     .clock_dr        (clock_dr_i_r ),
     .shift_dr        (shift_dr_i_r ),
     .update_dr       (update_dr_i_r ) );
endmodule
