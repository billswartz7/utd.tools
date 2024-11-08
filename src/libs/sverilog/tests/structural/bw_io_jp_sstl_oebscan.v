// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_jp_sstl_oebscan.v
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
module bw_io_jp_sstl_oebscan(bsr_si ,update_dr ,in ,bsr_hiz_l ,
     test_mode_oe ,mode_ctl ,shift_dr ,clock_dr ,out_type ,bsr_so ,out
      );
output		bsr_so ;
output		out ;
input		bsr_si ;
input		update_dr ;
input		in ;
input		bsr_hiz_l ;
input		test_mode_oe ;
input		mode_ctl ;
input		shift_dr ;
input		clock_dr ;
input		out_type ;
 
wire		upd_hiz ;
wire		net32 ;
wire		net40 ;
wire		net44 ;
wire		net51 ;
wire		net53 ;
wire		net55 ;
wire		net60 ;
 
 
bw_u1_muxi21_2x bs_mux (
     .z               (net44 ),
     .d0              (in ),
     .d1              (upd_hiz ),
     .s               (net32 ) );
bw_u1_inv_1x se_inv (
     .z               (net53 ),
     .a               (test_mode_oe ) );
bw_u1_nand3_1x hiz_nand (
     .z               (net55 ),
     .a               (net51 ),
     .b               (bsr_hiz_l ),
     .c               (net53 ) );
bw_u1_inv_2x ctl_inv2x (
     .z               (net32 ),
     .a               (net60 ) );
bw_io_jp_bs_baseblk bs_baseblk (
     .upd_q           (net51 ),
     .bsr_si          (bsr_si ),
     .update_dr       (update_dr ),
     .clock_dr        (clock_dr ),
     .shift_dr        (shift_dr ),
     .bsr_so          (bsr_so ),
     .in              (in ) );
bw_u1_nand2_1x hiz_se_nand (
     .z               (upd_hiz ),
     .a               (net55 ),
     .b               (net40 ) );
bw_u1_nand2_1x se_nand (
     .z               (net40 ),
     .a               (test_mode_oe ),
     .b               (out_type ) );
bw_u1_inv_5x out_inv5x (
     .z               (out ),
     .a               (net44 ) );
bw_u1_nor2_1x ctl_nor1x (
     .z               (net60 ),
     .a               (mode_ctl ),
     .b               (test_mode_oe ) );
endmodule

