// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_jp_sstl_dq_bscan.v
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
module bw_io_jp_sstl_dq_bscan(se ,mode_ctl ,bypass_enable ,clock_dr ,in
      ,ps_in ,bsr_so ,ps_select ,out ,bypass ,shift_dr ,bsr_si ,
     update_dr );
output		bsr_so ;
output		out ;
output		bypass ;
input		se ;
input		mode_ctl ;
input		bypass_enable ;
input		clock_dr ;
input		in ;
input		ps_in ;
input		ps_select ;
input		shift_dr ;
input		bsr_si ;
input		update_dr ;
 
wire		net39 ;
wire		net47 ;
wire		net51 ;
wire		net58 ;
wire		net60 ;
wire		net63 ;
wire		net66 ;
 
 
bw_u1_inv_2x ps_inv (
     .z               (bypass ),
     .a               (net63 ) );
bw_u1_muxi21_2x bs_mux1 (
     .z               (net51 ),
     .d0              (net58 ),
     .d1              (ps_in ),
     .s               (ps_select ) );
bw_u1_muxi21_2x bs_mux2 (
     .z               (net47 ),
     .d0              (in ),
     .d1              (net60 ),
     .s               (net39 ) );
bw_u1_nand2_1x ps_nand2 (
     .z               (net63 ),
     .a               (net58 ),
     .b               (bypass_enable ) );
bw_u1_inv_2x ctl_inv2x (
     .z               (net39 ),
     .a               (net66 ) );
bw_io_jp_bs_baseblk bs_baseblk (
     .upd_q           (net58 ),
     .bsr_si          (bsr_si ),
     .update_dr       (update_dr ),
     .clock_dr        (clock_dr ),
     .shift_dr        (shift_dr ),
     .bsr_so          (bsr_so ),
     .in              (in ) );
bw_u1_inv_5x out_inv5x (
     .z               (out ),
     .a               (net47 ) );
bw_u1_inv_1x bs_inv1x (
     .z               (net60 ),
     .a               (net51 ) );
bw_u1_nor2_1x ctl_nor1x (
     .z               (net66 ),
     .a               (se ),
     .b               (mode_ctl ) );
endmodule

