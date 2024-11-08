// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_bscl1.v
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
// ------------------------------------------------------------------
module bw_io_dtl_bscl1(intest_oe ,intest_d ,q_dn_pad ,q25_dn_pad ,
     q_up_pad );
output		intest_oe ;
output		intest_d ;
input		q_dn_pad ;
input		q25_dn_pad ;
input		q_up_pad ;
 
wire		net016 ;
wire		n1 ;
 
 
bw_u1_inv_2x up_inv2x (
     .z               (intest_d ),
     .a               (net016 ) );
bw_u1_nand2_1x nand1 (
     .z               (n1 ),
     .a               (q_up_pad ),
     .b               (q25_dn_pad ) );
bw_u1_nand2_1x nand2 (
     .z               (intest_oe ),
     .a               (q_dn_pad ),
     .b               (n1 ) );
bw_u1_inv_1x up_inv1x (
     .z               (net016 ),
     .a               (q_up_pad ) );
endmodule


