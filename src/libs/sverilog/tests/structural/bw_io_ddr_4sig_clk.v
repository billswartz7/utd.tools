// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_4sig_clk.v
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
module bw_io_ddr_4sig_clk(dram_io_clk_enable ,testmode_l ,pad_clk_si ,
     pad_clk_so ,vrefcode ,dram_ck ,se ,rclk ,mode_ctrl ,vdd_h ,bso ,bsi
      ,hiz_n ,clock_dr ,shift_dr ,update_dr ,clk_value ,cbu ,cbd );
input [7:0]	vrefcode ;
input [3:0]	clk_value ;
input [8:1]	cbu ;
input [8:1]	cbd ;
inout [3:0]	dram_ck ;
output		pad_clk_so ;
output		bso ;
input		dram_io_clk_enable ;
input		testmode_l ;
input		pad_clk_si ;
input		se ;
input		rclk ;
input		mode_ctrl ;
input		vdd_h ;
input		bsi ;
input		hiz_n ;
input		clock_dr ;
input		shift_dr ;
input		update_dr ;
 
wire		net74 ;
wire		clk_so0_clk_si1 ;
wire		bso0_bsi1 ;
wire		bso2_bsi3 ;
wire		clk_so1_clk_si2 ;
wire		clk_so2_clk_si3 ;
wire		bso1_bsi2 ;
 
 
bw_u1_ckbuf_11x I86 (
     .clk             (net74 ),
     .rclk            (rclk ) );
dram_clk_pad clk_pad0 (
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .vrefcode        ({vrefcode } ),
     .pad             (dram_ck[0] ),
     .clk_pad_clk_si  (pad_clk_si ),
     .testmode_l      (testmode_l ),
     .clk_pad_clk_se  (se ),
     .bsi             (bsi ),
     .clk             (net74 ),
     .clk_value       (clk_value[0] ),
     .clock_dr        (clock_dr ),
     .dram_io_clk_enable (dram_io_clk_enable ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .clk_pad_clk_so  (clk_so0_clk_si1 ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (bso0_bsi1 ) );
dram_clk_pad clk_pad1 (
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .vrefcode        ({vrefcode } ),
     .pad             (dram_ck[1] ),
     .clk_pad_clk_si  (clk_so0_clk_si1 ),
     .testmode_l      (testmode_l ),
     .clk_pad_clk_se  (se ),
     .bsi             (bso0_bsi1 ),
     .clk             (net74 ),
     .clk_value       (clk_value[1] ),
     .clock_dr        (clock_dr ),
     .dram_io_clk_enable (dram_io_clk_enable ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .clk_pad_clk_so  (clk_so1_clk_si2 ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (bso1_bsi2 ) );
dram_clk_pad clk_pad2 (
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .vrefcode        ({vrefcode } ),
     .pad             (dram_ck[2] ),
     .clk_pad_clk_si  (clk_so1_clk_si2 ),
     .testmode_l      (testmode_l ),
     .clk_pad_clk_se  (se ),
     .bsi             (bso1_bsi2 ),
     .clk             (net74 ),
     .clk_value       (clk_value[2] ),
     .clock_dr        (clock_dr ),
     .dram_io_clk_enable (dram_io_clk_enable ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .clk_pad_clk_so  (clk_so2_clk_si3 ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (bso2_bsi3 ) );
dram_clk_pad clk_pad3 (
     .cbd             ({cbd } ),
     .cbu             ({cbu } ),
     .vrefcode        ({vrefcode } ),
     .pad             (dram_ck[3] ),
     .clk_pad_clk_si  (clk_so2_clk_si3 ),
     .testmode_l      (testmode_l ),
     .clk_pad_clk_se  (se ),
     .bsi             (bso2_bsi3 ),
     .clk             (net74 ),
     .clk_value       (clk_value[3] ),
     .clock_dr        (clock_dr ),
     .dram_io_clk_enable (dram_io_clk_enable ),
     .hiz_n           (hiz_n ),
     .mode_ctrl       (mode_ctrl ),
     .clk_pad_clk_so  (pad_clk_so ),
     .shift_dr        (shift_dr ),
     .update_dr       (update_dr ),
     .vdd_h           (vdd_h ),
     .bso             (bso ) );
endmodule
