// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_dtl_sclk.v
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
module bw_io_impctl_dtl_sclk(l2clk ,int_sclk ,sclk ,ssclk_n ,se ,si_l ,
     global_reset_n );
output		int_sclk ;
output		sclk ;
output		ssclk_n ;
input		l2clk ;
input		se ;
input		si_l ;
input		global_reset_n ;
 
wire [2:0]	scarry ;
wire [3:0]	scount ;
wire [3:0]	next_scount ;
wire		net113 ;
wire		net050 ;
wire		scan_data_1 ;
wire		scan_data_2 ;
wire		scan_data_3 ;
wire		scan_data_4 ;
wire		scan_in ;
wire		scan_out ;
wire		net65 ;
 
 
bw_u1_soffr_4x I128 (
     .q               (scount[2] ),
     .so              (scan_data_3 ),
     .ck              (l2clk ),
     .d               (next_scount[2] ),
     .se              (se ),
     .sd              (scan_data_2 ),
     .r_l             (global_reset_n ) );
bw_u1_inv_4x I156 (
     .z               (scan_in ),
     .a               (si_l ) );
bw_u1_xor2_4x I159 (
     .z               (next_scount[1] ),
     .a               (scount[1] ),
     .b               (scarry[0] ) );
bw_u1_xor2_4x I160 (
     .z               (next_scount[2] ),
     .a               (scount[2] ),
     .b               (scarry[1] ) );
bw_u1_inv_2x I161 (
     .z               (next_scount[0] ),
     .a               (scount[0] ) );
bw_u1_xor2_4x I162 (
     .z               (next_scount[3] ),
     .a               (scount[3] ),
     .b               (scarry[2] ) );
bw_u1_inv_4x I163 (
     .z               (scarry[0] ),
     .a               (next_scount[0] ) );
bw_u1_nand2_4x I164 (
     .z               (net113 ),
     .a               (scount[0] ),
     .b               (scount[1] ) );
bw_u1_inv_8x I165 (
     .z               (int_sclk ),
     .a               (net113 ) );
bw_u1_inv_4x I166 (
     .z               (net65 ),
     .a               (scount[2] ) );
bw_u1_nor2_2x I167 (
     .z               (scarry[2] ),
     .a               (net65 ),
     .b               (net113 ) );
bw_u1_soffr_4x I171 (
     .q               (sclk ),
     .so              (scan_out ),
     .ck              (l2clk ),
     .d               (scarry[1] ),
     .se              (se ),
     .sd              (scan_data_4 ),
     .r_l             (global_reset_n ) );
bw_u1_soffr_4x I21 (
     .q               (scount[0] ),
     .so              (scan_data_1 ),
     .ck              (l2clk ),
     .d               (next_scount[0] ),
     .se              (se ),
     .sd              (scan_in ),
     .r_l             (global_reset_n ) );
bw_u1_inv_5x I173 (
     .z               (ssclk_n ),
     .a               (scan_out ) );
bw_u1_inv_2x I179 (
     .z               (net050 ),
     .a               (int_sclk ) );
bw_u1_inv_5x I180 (
     .z               (scarry[1] ),
     .a               (net050 ) );
bw_u1_soffr_4x I125 (
     .q               (scount[1] ),
     .so              (scan_data_2 ),
     .ck              (l2clk ),
     .d               (next_scount[1] ),
     .se              (se ),
     .sd              (scan_data_1 ),
     .r_l             (global_reset_n ) );
bw_u1_soffr_4x I127 (
     .q               (scount[3] ),
     .so              (scan_data_4 ),
     .ck              (l2clk ),
     .d               (next_scount[3] ),
     .se              (se ),
     .sd              (scan_data_3 ),
     .r_l             (global_reset_n ) );
endmodule
