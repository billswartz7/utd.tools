// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_sstl_dq_bscan.v
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
module bw_io_sstl_dq_bscan(update_dr ,data_out ,out_type ,serial_out ,
     bso ,odt_enable ,oe ,clk ,shift_dr ,bypass_in ,serial_in ,
     bypass_enable ,data_in ,ps_select ,rcv_in ,drv_oe ,odt_enable_mask
      ,se ,test_mode ,to_core ,hiz_l ,clock_dr ,bsi ,mode_ctrl );
output		data_out ;
output		serial_out ;
output		bso ;
output		odt_enable ;
output		oe ;
output		to_core ;
input		update_dr ;
input		out_type ;
input		clk ;
input		shift_dr ;
input		bypass_in ;
input		serial_in ;
input		bypass_enable ;
input		data_in ;
input		ps_select ;
input		rcv_in ;
input		drv_oe ;
input		odt_enable_mask ;
input		se ;
input		test_mode ;
input		hiz_l ;
input		clock_dr ;
input		bsi ;
input		mode_ctrl ;
 
wire		test_mode_oe ;
wire		bso_1 ;
wire		bso_2 ;
wire		bso_3 ;
wire		odt_enable_in ;
wire		net138 ;
wire		net144 ;
 
 
bw_io_jp_sstl_bscan bscan_input (
     .in              (rcv_in ),
     .update_dr       (update_dr ),
     .mode_ctl        (mode_ctrl ),
     .shift_dr        (shift_dr ),
     .clock_dr        (clock_dr ),
     .bsr_so          (bso_1 ),
     .out             (to_core ),
     .bsr_si          (bsi ) );
bw_io_jp_sstl_oebscan bscan_oe (
     .bsr_si          (bso_3 ),
     .update_dr       (update_dr ),
     .in              (drv_oe ),
     .bsr_hiz_l       (hiz_l ),
     .test_mode_oe    (test_mode_oe ),
     .mode_ctl        (mode_ctrl ),
     .shift_dr        (shift_dr ),
     .clock_dr        (clock_dr ),
     .out_type        (out_type ),
     .bsr_so          (bso ),
     .out             (oe ) );
bw_io_dq_pscan pscan (
     .serial_in       (serial_in ),
     .serial_out      (serial_out ),
     .bypass_in       (bypass_in ),
     .out_type        (out_type ),
     .clk             (clk ),
     .bypass          (net138 ),
     .ps_select       (ps_select ),
     .rcv_in          (rcv_in ) );
bw_u1_nor2_1x odt_nor2 (
     .z               (odt_enable_in ),
     .a               (drv_oe ),
     .b               (odt_enable_mask ) );
bw_io_jp_sstl_dq_bscan bscan_output (
     .se              (se ),
     .mode_ctl        (mode_ctrl ),
     .bypass_enable   (bypass_enable ),
     .clock_dr        (clock_dr ),
     .in              (data_in ),
     .ps_in           (serial_out ),
     .bsr_so          (bso_3 ),
     .ps_select       (ps_select ),
     .out             (data_out ),
     .bypass          (net138 ),
     .shift_dr        (shift_dr ),
     .bsr_si          (bso_2 ),
     .update_dr       (update_dr ) );
bw_u1_inv_0p6x I46 (
     .z               (test_mode_oe ),
     .a               (net144 ) );
bw_io_jp_sstl_odt_oebscan bscan_odt_en (
     .test_mode_oe    (test_mode_oe ),
     .bsr_hiz_l       (hiz_l ),
     .in              (odt_enable_in ),
     .update_dr       (update_dr ),
     .mode_ctl        (mode_ctrl ),
     .shift_dr        (shift_dr ),
     .clock_dr        (clock_dr ),
     .bsr_so          (bso_2 ),
     .out             (odt_enable ),
     .bsr_si          (bso_1 ) );
bw_u1_muxi21_0p6x I47 (
     .z               (net144 ),
     .d0              (test_mode ),
     .d1              (se ),
     .s               (ps_select ) );
endmodule

