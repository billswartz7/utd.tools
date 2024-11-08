// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_jp_sstl_odt_oebscan.v
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
module bw_io_jp_sstl_odt_oebscan(test_mode_oe ,bsr_hiz_l ,in ,update_dr
      ,mode_ctl ,shift_dr ,clock_dr ,bsr_so ,out ,bsr_si );
output		bsr_so ;
output		out ;
input		test_mode_oe ;
input		bsr_hiz_l ;
input		in ;
input		update_dr ;
input		mode_ctl ;
input		shift_dr ;
input		clock_dr ;
input		bsr_si ;
 
wire		net021 ;
wire		upd_hiz ;
wire		net037 ;
wire		net039 ;
wire		net046 ;
wire		net047 ;
wire		net54 ;
 
 
bw_u1_muxi21_2x bs_mux (
     .z               (net54 ),
     .d0              (in ),
     .d1              (upd_hiz ),
     .s               (net021 ) );
bw_u1_inv_1x hiz_inv (
     .z               (upd_hiz ),
     .a               (net037 ) );
bw_u1_inv_1x se_inv (
     .z               (net039 ),
     .a               (test_mode_oe ) );
bw_u1_nand3_1x hiz_nand (
     .z               (net037 ),
     .a               (net046 ),
     .b               (bsr_hiz_l ),
     .c               (net039 ) );
bw_u1_inv_2x ctl_inv2x (
     .z               (net021 ),
     .a               (net047 ) );
bw_io_jp_bs_baseblk bs_baseblk (
     .upd_q           (net046 ),
     .bsr_si          (bsr_si ),
     .update_dr       (update_dr ),
     .clock_dr        (clock_dr ),
     .shift_dr        (shift_dr ),
     .bsr_so          (bsr_so ),
     .in              (in ) );
bw_u1_inv_5x out_inv5x (
     .z               (out ),
     .a               (net54 ) );
bw_u1_nor2_1x ctl_nor1x (
     .z               (net047 ),
     .a               (mode_ctl ),
     .b               (test_mode_oe ) );
endmodule

