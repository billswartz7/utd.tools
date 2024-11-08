// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_avgcnt.v
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
module bw_io_impctl_avgcnt(adv_sgn ,so_i ,above ,sclk ,avgcntr_rst ,se ,
     si_l ,global_reset_n ,l2clk );
output		adv_sgn ;
output		so_i ;
input		above ;
input		sclk ;
input		avgcntr_rst ;
input		se ;
input		si_l ;
input		global_reset_n ;
input		l2clk ;
 
wire [8:0]	count ;
wire [7:0]	scan_data ;
wire [7:0]	pcarry ;
wire [8:0]	next_count ;
wire [1:0]	net085 ;
wire [1:0]	din ;
wire [1:0]	net082 ;
wire		net200 ;
wire		net183 ;
wire		net201 ;
wire		net185 ;
wire		net203 ;
wire		net112 ;
wire		net194 ;
wire		net195 ;
wire		net196 ;
wire		net115 ;
wire		net199 ;
wire		net216 ;
wire		sc ;
wire		net223 ;
wire		net228 ;
wire		net229 ;
wire		net231 ;
wire		net232 ;
wire		net234 ;
wire		net240 ;
wire		net241 ;
wire		net247 ;
wire		net249 ;
wire		net250 ;
wire		scan_in ;
wire		scan_out ;
wire		net179 ;
 
 
bw_u1_inv_4x I227 (
     .z               (net216 ),
     .a               (avgcntr_rst ) );
bw_u1_inv_4x I229 (
     .z               (scan_in ),
     .a               (si_l ) );
bw_u1_soffr_4x I182_0_ (
     .q               (count[0] ),
     .so              (scan_data[0] ),
     .ck              (l2clk ),
     .d               (din[0] ),
     .se              (se ),
     .sd              (scan_in ),
     .r_l             (net201 ) );
bw_u1_soffr_4x I182_8_ (
     .q               (count[8] ),
     .so              (scan_out ),
     .ck              (l2clk ),
     .d               (next_count[8] ),
     .se              (se ),
     .sd              (scan_data[7] ),
     .r_l             (net201 ) );
bw_u1_xor2_2x I231 (
     .z               (next_count[1] ),
     .a               (net228 ),
     .b               (pcarry[0] ) );
bw_u1_xor2_4x I232 (
     .z               (net228 ),
     .a               (net185 ),
     .b               (count[1] ) );
bw_u1_xor2_2x I233 (
     .z               (net240 ),
     .a               (net185 ),
     .b               (count[3] ) );
bw_u1_xor2_2x I234 (
     .z               (next_count[3] ),
     .a               (pcarry[2] ),
     .b               (count[3] ) );
bw_u1_nand2_2x I298_0_ (
     .z               (net085[1] ),
     .a               (next_count[0] ),
     .b               (sc ) );
bw_u1_xor2_2x I235 (
     .z               (next_count[2] ),
     .a               (pcarry[1] ),
     .b               (count[2] ) );
bw_u1_xor2_2x I236 (
     .z               (net200 ),
     .a               (net185 ),
     .b               (count[2] ) );
bw_u1_xnor2_2x I237 (
     .z               (next_count[7] ),
     .a               (pcarry[6] ),
     .b               (count[7] ) );
bw_u1_xor2_2x I238 (
     .z               (net231 ),
     .a               (net185 ),
     .b               (count[7] ) );
bw_u1_xor2_2x I239 (
     .z               (net196 ),
     .a               (net185 ),
     .b               (count[6] ) );
bw_u1_soffr_4x I182_7_ (
     .q               (count[7] ),
     .so              (scan_data[7] ),
     .ck              (l2clk ),
     .d               (next_count[7] ),
     .se              (se ),
     .sd              (scan_data[6] ),
     .r_l             (net201 ) );
bw_u1_xnor2_2x I240 (
     .z               (next_count[6] ),
     .a               (pcarry[5] ),
     .b               (count[6] ) );
bw_u1_xnor2_2x I241 (
     .z               (next_count[5] ),
     .a               (pcarry[4] ),
     .b               (count[5] ) );
bw_u1_xor2_2x I242 (
     .z               (net249 ),
     .a               (net185 ),
     .b               (count[5] ) );
bw_u1_xor2_2x I243 (
     .z               (net234 ),
     .a               (net185 ),
     .b               (count[4] ) );
bw_u1_xor2_2x I244 (
     .z               (next_count[4] ),
     .a               (pcarry[3] ),
     .b               (count[4] ) );
bw_u1_xnor2_2x I246 (
     .z               (next_count[8] ),
     .a               (pcarry[7] ),
     .b               (count[8] ) );
bw_u1_soffr_4x I182_6_ (
     .q               (count[6] ),
     .so              (scan_data[6] ),
     .ck              (l2clk ),
     .d               (next_count[6] ),
     .se              (se ),
     .sd              (scan_data[5] ),
     .r_l             (net201 ) );
bw_u1_inv_4x I250 (
     .z               (pcarry[0] ),
     .a               (next_count[0] ) );
bw_u1_nand3_5x I251 (
     .z               (net229 ),
     .a               (net194 ),
     .b               (sc ),
     .c               (net228 ) );
bw_u1_inv_2x I252 (
     .z               (net199 ),
     .a               (net200 ) );
bw_u1_nand2_4x I253 (
     .z               (net241 ),
     .a               (net200 ),
     .b               (net240 ) );
bw_u1_nor2_6x I254 (
     .z               (pcarry[3] ),
     .a               (net241 ),
     .b               (net229 ) );
bw_u1_nor2_2x I255 (
     .z               (net115 ),
     .a               (net232 ),
     .b               (net250 ) );
bw_u1_nor2_2x I256 (
     .z               (net112 ),
     .a               (net195 ),
     .b               (net250 ) );
bw_u1_inv_2x I259 (
     .z               (net203 ),
     .a               (net250 ) );
bw_u1_soffr_4x I182_5_ (
     .q               (count[5] ),
     .so              (scan_data[5] ),
     .ck              (l2clk ),
     .d               (next_count[5] ),
     .se              (se ),
     .sd              (scan_data[4] ),
     .r_l             (net201 ) );
bw_u1_inv_2x I260 (
     .z               (net195 ),
     .a               (net196 ) );
bw_u1_nand2_4x I261 (
     .z               (pcarry[4] ),
     .a               (pcarry[3] ),
     .b               (net234 ) );
bw_u1_nand2_2x I262 (
     .z               (net232 ),
     .a               (net196 ),
     .b               (net231 ) );
bw_u1_inv_4x I165 (
     .z               (pcarry[1] ),
     .a               (net229 ) );
bw_u1_nand2_4x I296_1_ (
     .z               (din[1] ),
     .a               (net082[0] ),
     .b               (net085[0] ) );
bw_u1_nand2_4x I264 (
     .z               (pcarry[6] ),
     .a               (pcarry[3] ),
     .b               (net112 ) );
bw_u1_nor2_4x I167 (
     .z               (pcarry[2] ),
     .a               (net199 ),
     .b               (net229 ) );
bw_u1_nand2_4x I266 (
     .z               (pcarry[5] ),
     .a               (pcarry[3] ),
     .b               (net203 ) );
bw_u1_nand2_4x I168 (
     .z               (pcarry[7] ),
     .a               (pcarry[3] ),
     .b               (net115 ) );
bw_u1_nand2_4x I267 (
     .z               (net250 ),
     .a               (net234 ),
     .b               (net249 ) );
bw_u1_nand2_4x I269 (
     .z               (net247 ),
     .a               (global_reset_n ),
     .b               (net183 ) );
bw_u1_soffr_4x I182_4_ (
     .q               (count[4] ),
     .so              (scan_data[4] ),
     .ck              (l2clk ),
     .d               (next_count[4] ),
     .se              (se ),
     .sd              (scan_data[3] ),
     .r_l             (net201 ) );
bw_u1_inv_5x I270 (
     .z               (net201 ),
     .a               (net247 ) );
bw_u1_inv_5x I271 (
     .z               (net183 ),
     .a               (avgcntr_rst ) );
bw_u1_inv_3x I273 (
     .z               (net179 ),
     .a               (count[8] ) );
bw_u1_nand2_4x I296_0_ (
     .z               (din[0] ),
     .a               (net082[1] ),
     .b               (net085[1] ) );
bw_u1_inv_10x I274 (
     .z               (adv_sgn ),
     .a               (net179 ) );
bw_u1_soffr_4x I182_3_ (
     .q               (count[3] ),
     .so              (scan_data[3] ),
     .ck              (l2clk ),
     .d               (next_count[3] ),
     .se              (se ),
     .sd              (scan_data[2] ),
     .r_l             (net201 ) );
bw_u1_inv_8x I282 (
     .z               (net185 ),
     .a               (above ) );
bw_u1_inv_2x I302 (
     .z               (next_count[0] ),
     .a               (count[0] ) );
bw_u1_nand2_2x I297_1_ (
     .z               (net082[0] ),
     .a               (count[1] ),
     .b               (net223 ) );
bw_u1_soffr_4x I182_2_ (
     .q               (count[2] ),
     .so              (scan_data[2] ),
     .ck              (l2clk ),
     .d               (next_count[2] ),
     .se              (se ),
     .sd              (scan_data[1] ),
     .r_l             (net201 ) );
bw_u1_nand2_2x I297_0_ (
     .z               (net082[1] ),
     .a               (count[0] ),
     .b               (net223 ) );
bw_u1_inv_4x I198 (
     .z               (so_i ),
     .a               (scan_out ) );
bw_u1_xor2_4x I217 (
     .z               (net194 ),
     .a               (net185 ),
     .b               (count[0] ) );
bw_u1_inv_5x I219 (
     .z               (sc ),
     .a               (net223 ) );
bw_u1_soffr_4x I182_1_ (
     .q               (count[1] ),
     .so              (scan_data[1] ),
     .ck              (l2clk ),
     .d               (din[1] ),
     .se              (se ),
     .sd              (scan_data[0] ),
     .r_l             (net201 ) );
bw_u1_nand2_4x I220 (
     .z               (net223 ),
     .a               (sclk ),
     .b               (net216 ) );
bw_u1_nand2_2x I298_1_ (
     .z               (net085[0] ),
     .a               (next_count[1] ),
     .b               (sc ) );
endmodule

