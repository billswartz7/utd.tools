// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_dtl_upclk.v
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
module bw_io_impctl_dtl_upclk(avgcntr_rst ,int_sclk ,l2clk ,
     synced_upd_imped ,updclk ,reset_l ,bypass ,so_l ,hard_reset_n ,si_l
      ,se ,global_reset_n );
output		avgcntr_rst ;
output		updclk ;
output		bypass ;
output		so_l ;
output		global_reset_n ;
input		int_sclk ;
input		l2clk ;
input		synced_upd_imped ;
input		reset_l ;
input		hard_reset_n ;
input		si_l ;
input		se ;
 
wire [9:0]	scan_data ;
wire [7:0]	ucarry ;
wire [7:0]	next_ucount ;
wire [7:0]	ucount ;
wire		net189 ;
wire		net0101 ;
wire		net78 ;
wire		net0201 ;
wire		net094 ;
wire		net114 ;
wire		net116 ;
wire		net120 ;
wire		int_avgcntr_rst ;
wire		net98 ;
wire		net145 ;
wire		osflag_n ;
wire		net156 ;
wire		net0210 ;
wire		net0113 ;
wire		net162 ;
wire		net068 ;
wire		net168 ;
wire		net0198 ;
wire		scan_in ;
wire		net170 ;
wire		net171 ;
wire		net174 ;
wire		net177 ;
wire		scan_out ;
wire		osflag ;
wire		oneshot_trig ;
 
 
bw_u1_soffr_4x I226 (
     .q               (osflag_n ),
     .so              (scan_data[9] ),
     .ck              (l2clk ),
     .d               (net174 ),
     .se              (se ),
     .sd              (scan_in ),
     .r_l             (hard_reset_n ) );
bw_u1_xor2_4x I218_7_ (
     .z               (next_ucount[7] ),
     .a               (ucarry[6] ),
     .b               (ucount[7] ) );
bw_u1_inv_5x I228 (
     .z               (int_avgcntr_rst ),
     .a               (net068 ) );
bw_u1_soffr_4x I229 (
     .q               (avgcntr_rst ),
     .so              (scan_data[8] ),
     .ck              (l2clk ),
     .d               (int_avgcntr_rst ),
     .se              (se ),
     .sd              (scan_data[9] ),
     .r_l             (global_reset_n ) );
bw_u1_inv_5x I234 (
     .z               (scan_in ),
     .a               (si_l ) );
bw_u1_soffr_4x I217_4_ (
     .q               (ucount[4] ),
     .so              (scan_data[4] ),
     .ck              (l2clk ),
     .d               (next_ucount[4] ),
     .se              (se ),
     .sd              (scan_data[5] ),
     .r_l             (global_reset_n ) );
bw_u1_xor2_4x I218_6_ (
     .z               (next_ucount[6] ),
     .a               (ucarry[5] ),
     .b               (ucount[6] ) );
bw_u1_nand2_7x I241 (
     .z               (net0210 ),
     .a               (net094 ),
     .b               (net0101 ) );
bw_u1_nor2_4x I242 (
     .z               (net094 ),
     .a               (net0113 ),
     .b               (synced_upd_imped ) );
bw_u1_soffr_4x I217_3_ (
     .q               (ucount[3] ),
     .so              (scan_data[3] ),
     .ck              (l2clk ),
     .d               (next_ucount[3] ),
     .se              (se ),
     .sd              (scan_data[4] ),
     .r_l             (global_reset_n ) );
bw_u1_xor2_4x I218_5_ (
     .z               (next_ucount[5] ),
     .a               (ucarry[4] ),
     .b               (ucount[5] ) );
bw_u1_nand2_2x I245 (
     .z               (net0201 ),
     .a               (osflag ),
     .b               (oneshot_trig ) );
bw_u1_inv_4x I246 (
     .z               (net0113 ),
     .a               (net0201 ) );
bw_u1_nand2_2x I248 (
     .z               (net0198 ),
     .a               (hard_reset_n ),
     .b               (reset_l ) );
bw_u1_inv_4x I249 (
     .z               (net0101 ),
     .a               (net0198 ) );
bw_u1_inv_20x I252 (
     .z               (global_reset_n ),
     .a               (net0210 ) );
bw_u1_nand2_4x I253 (
     .z               (net145 ),
     .a               (int_sclk ),
     .b               (ucount[0] ) );
bw_u1_soffr_4x I217_2_ (
     .q               (ucount[2] ),
     .so              (scan_data[2] ),
     .ck              (l2clk ),
     .d               (next_ucount[2] ),
     .se              (se ),
     .sd              (scan_data[3] ),
     .r_l             (global_reset_n ) );
bw_u1_xor2_4x I218_4_ (
     .z               (next_ucount[4] ),
     .a               (ucarry[3] ),
     .b               (ucount[4] ) );
bw_u1_nor2_6x I255 (
     .z               (oneshot_trig ),
     .a               (net120 ),
     .b               (net177 ) );
bw_u1_nand2_4x I256 (
     .z               (net120 ),
     .a               (ucount[2] ),
     .b               (ucount[3] ) );
bw_u1_nor2_2x I257 (
     .z               (ucarry[7] ),
     .a               (net156 ),
     .b               (net78 ) );
bw_u1_inv_5x I259 (
     .z               (bypass ),
     .a               (osflag_n ) );
bw_u1_inv_4x I260 (
     .z               (net168 ),
     .a               (ucarry[6] ) );
bw_u1_inv_4x I163 (
     .z               (ucarry[0] ),
     .a               (net145 ) );
bw_u1_inv_2x I261 (
     .z               (net189 ),
     .a               (oneshot_trig ) );
bw_u1_nand2_4x I164 (
     .z               (net177 ),
     .a               (ucarry[0] ),
     .b               (ucount[1] ) );
bw_u1_inv_2x I262 (
     .z               (net068 ),
     .a               (ucarry[6] ) );
bw_u1_inv_4x I165 (
     .z               (ucarry[1] ),
     .a               (net177 ) );
bw_u1_soffr_4x I217_1_ (
     .q               (ucount[1] ),
     .so              (scan_data[1] ),
     .ck              (l2clk ),
     .d               (next_ucount[1] ),
     .se              (se ),
     .sd              (scan_data[2] ),
     .r_l             (global_reset_n ) );
bw_u1_inv_2x I166 (
     .z               (net116 ),
     .a               (ucount[2] ) );
bw_u1_xor2_4x I218_3_ (
     .z               (next_ucount[3] ),
     .a               (ucarry[2] ),
     .b               (ucount[3] ) );
bw_u1_nor2_4x I167 (
     .z               (ucarry[2] ),
     .a               (net116 ),
     .b               (net177 ) );
bw_u1_nor2_4x I175 (
     .z               (ucarry[6] ),
     .a               (net98 ),
     .b               (net78 ) );
bw_u1_soffr_4x I217_0_ (
     .q               (ucount[0] ),
     .so              (scan_data[0] ),
     .ck              (l2clk ),
     .d               (next_ucount[0] ),
     .se              (se ),
     .sd              (scan_data[1] ),
     .r_l             (global_reset_n ) );
bw_u1_xor2_4x I218_2_ (
     .z               (next_ucount[2] ),
     .a               (ucarry[1] ),
     .b               (ucount[2] ) );
bw_u1_inv_5x I179 (
     .z               (ucarry[5] ),
     .a               (net78 ) );
bw_u1_inv_2x I180 (
     .z               (net98 ),
     .a               (ucount[6] ) );
bw_u1_inv_4x I205 (
     .z               (ucarry[3] ),
     .a               (net189 ) );
bw_u1_xor2_4x I218_1_ (
     .z               (next_ucount[1] ),
     .a               (ucarry[0] ),
     .b               (ucount[1] ) );
bw_u1_inv_4x I187 (
     .z               (ucarry[4] ),
     .a               (net162 ) );
bw_u1_soffr_4x I217_7_ (
     .q               (ucount[7] ),
     .so              (scan_data[7] ),
     .ck              (l2clk ),
     .d               (next_ucount[7] ),
     .se              (se ),
     .sd              (scan_data[8] ),
     .r_l             (global_reset_n ) );
bw_u1_nand2_5x I207 (
     .z               (net156 ),
     .a               (ucount[6] ),
     .b               (ucount[7] ) );
bw_u1_nand3_4x I189 (
     .z               (net78 ),
     .a               (oneshot_trig ),
     .b               (ucount[4] ),
     .c               (ucount[5] ) );
bw_u1_nand2_4x I211 (
     .z               (net171 ),
     .a               (net168 ),
     .b               (net170 ) );
bw_u1_nand2_2x I212 (
     .z               (net170 ),
     .a               (bypass ),
     .b               (int_sclk ) );
bw_u1_soffr_4x I217_6_ (
     .q               (ucount[6] ),
     .so              (scan_data[6] ),
     .ck              (l2clk ),
     .d               (next_ucount[6] ),
     .se              (se ),
     .sd              (scan_data[7] ),
     .r_l             (global_reset_n ) );
bw_u1_xor2_4x I218_0_ (
     .z               (next_ucount[0] ),
     .a               (int_sclk ),
     .b               (ucount[0] ) );
bw_u1_nand2_2x I196 (
     .z               (net162 ),
     .a               (oneshot_trig ),
     .b               (ucount[4] ) );
bw_u1_inv_5x I198 (
     .z               (so_l ),
     .a               (scan_out ) );
bw_u1_soffr_4x I199 (
     .q               (updclk ),
     .so              (scan_out ),
     .ck              (l2clk ),
     .d               (net171 ),
     .se              (se ),
     .sd              (scan_data[0] ),
     .r_l             (global_reset_n ) );
bw_u1_nand2_4x I223 (
     .z               (net174 ),
     .a               (osflag ),
     .b               (net114 ) );
bw_u1_inv_2x I224 (
     .z               (net114 ),
     .a               (oneshot_trig ) );
bw_u1_soffr_4x I217_5_ (
     .q               (ucount[5] ),
     .so              (scan_data[5] ),
     .ck              (l2clk ),
     .d               (next_ucount[5] ),
     .se              (se ),
     .sd              (scan_data[6] ),
     .r_l             (global_reset_n ) );
bw_u1_inv_2x I225 (
     .z               (osflag ),
     .a               (osflag_n ) );
endmodule
