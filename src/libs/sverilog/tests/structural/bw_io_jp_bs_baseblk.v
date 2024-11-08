// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_jp_bs_baseblk.v
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
module bw_io_jp_bs_baseblk(upd_q ,bsr_si ,update_dr ,clock_dr ,shift_dr
      ,bsr_so ,in );
output		upd_q ;
output		bsr_so ;
input		bsr_si ;
input		update_dr ;
input		clock_dr ;
input		shift_dr ;
input		in ;
supply1		vdd ;
 
wire		net73 ;
wire		qn ;
wire		net032 ;
wire		net037 ;
 
 
bw_u1_soff_2x bsff (
     .q               (qn ),
     .so              (net73 ),
     .ck              (clock_dr ),
     .d               (in ),
     .se              (shift_dr ),
     .sd              (bsr_si ) );
bw_u1_inv_1x ud_inv1x (
     .z               (net032 ),
     .a               (update_dr ) );
bw_u1_inv_4x so_inv4x (
     .z               (bsr_so ),
     .a               (net037 ) );
bw_u1_inv_1x so_inv2x (
     .z               (net037 ),
     .a               (qn ) );
bw_u1_scanlg_2x latch_bsrc (
     .so              (upd_q ),
     .sd              (qn ),
     .ck              (net032 ),
     .se              (vdd ) );
endmodule

