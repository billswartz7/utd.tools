// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_jp_sstl_bscan.v
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
module bw_io_jp_sstl_bscan(in ,update_dr ,mode_ctl ,shift_dr ,clock_dr ,
     bsr_so ,out ,bsr_si );
output		bsr_so ;
output		out ;
input		in ;
input		update_dr ;
input		mode_ctl ;
input		shift_dr ;
input		clock_dr ;
input		bsr_si ;
 
wire		net033 ;
wire		net035 ;
wire		net042 ;
wire		update_q ;
 
 
bw_u1_muxi21_2x bs_mux (
     .z               (net033 ),
     .d0              (in ),
     .d1              (update_q ),
     .s               (net042 ) );
bw_u1_inv_2x ctl_inv2x (
     .z               (net042 ),
     .a               (net035 ) );
bw_io_jp_bs_baseblk bs_baseblk (
     .upd_q           (update_q ),
     .bsr_si          (bsr_si ),
     .update_dr       (update_dr ),
     .clock_dr        (clock_dr ),
     .shift_dr        (shift_dr ),
     .bsr_so          (bsr_so ),
     .in              (in ) );
bw_u1_inv_1x ctl_inv1x (
     .z               (net035 ),
     .a               (mode_ctl ) );
bw_u1_inv_5x out_inv5x (
     .z               (out ),
     .a               (net033 ) );
endmodule

