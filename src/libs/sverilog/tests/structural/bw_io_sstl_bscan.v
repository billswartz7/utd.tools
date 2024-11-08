// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_sstl_bscan.v
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
module bw_io_sstl_bscan(hiz_l ,odt_enable ,odt_enable_mask ,to_core ,
     drv_oe ,rcv_in ,data_out ,bso ,oe ,data_in ,mode_ctrl ,bsi ,
     clock_dr ,update_dr ,shift_dr );
output		odt_enable ;
output		to_core ;
output		data_out ;
output		bso ;
output		oe ;
input		hiz_l ;
input		odt_enable_mask ;
input		drv_oe ;
input		rcv_in ;
input		data_in ;
input		mode_ctrl ;
input		bsi ;
input		clock_dr ;
input		update_dr ;
input		shift_dr ;
supply0		vss ;
 
wire		bso_1 ;
wire		bso_2 ;
wire		bso_3 ;
wire		odt_enable_in ;
 
 
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
     .test_mode_oe    (vss ),
     .mode_ctl        (mode_ctrl ),
     .shift_dr        (shift_dr ),
     .clock_dr        (clock_dr ),
     .out_type        (vss ),
     .bsr_so          (bso ),
     .out             (oe ) );
bw_u1_nor2_1x odt_nor2 (
     .z               (odt_enable_in ),
     .a               (drv_oe ),
     .b               (odt_enable_mask ) );
bw_io_jp_sstl_bscan bscan_output (
     .in              (data_in ),
     .update_dr       (update_dr ),
     .mode_ctl        (mode_ctrl ),
     .shift_dr        (shift_dr ),
     .clock_dr        (clock_dr ),
     .bsr_so          (bso_3 ),
     .out             (data_out ),
     .bsr_si          (bso_2 ) );
bw_io_jp_sstl_oebscan bscan_odt_en (
     .bsr_si          (bso_1 ),
     .update_dr       (update_dr ),
     .in              (odt_enable_in ),
     .bsr_hiz_l       (hiz_l ),
     .test_mode_oe    (vss ),
     .mode_ctl        (mode_ctrl ),
     .shift_dr        (shift_dr ),
     .clock_dr        (clock_dr ),
     .out_type        (vss ),
     .bsr_so          (bso_2 ),
     .out             (odt_enable ) );
endmodule

