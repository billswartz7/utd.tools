// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_clsm.v
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
module bw_io_impctl_clsm(clk ,deltabit ,sz ,to_csr ,z_post ,we_csr ,
     from_csr ,d ,synced_upd_imped ,updclk ,hard_reset_n ,adv_sgn ,si_l
      ,config_pmos ,se ,freeze ,so_l ,above ,bypass ,global_reset_n );
output [7:0]	to_csr ;
output [7:0]	z_post ;
output [7:0]	d ;
input [7:0]	sz ;
input [7:0]	from_csr ;
output		deltabit ;
output		so_l ;
input		clk ;
input		we_csr ;
input		synced_upd_imped ;
input		updclk ;
input		hard_reset_n ;
input		adv_sgn ;
input		si_l ;
input		config_pmos ;
input		se ;
input		freeze ;
input		above ;
input		bypass ;
input		global_reset_n ;
supply0		vss ;
 
wire [7:0]	net0228 ;
wire [7:0]	net0225 ;
wire [7:0]	net0237 ;
wire [7:0]	mz ;
wire [7:0]	scan_data ;
wire [7:0]	net0201 ;
wire [7:0]	net0247 ;
wire [7:0]	net0207 ;
wire [7:0]	precnt ;
wire [7:0]	net0209 ;
wire [7:0]	net0189 ;
wire [7:0]	net0186 ;
wire [7:0]	net0246 ;
wire [7:0]	net0204 ;
wire [7:0]	net0146 ;
wire [7:0]	net0212 ;
wire [7:0]	net0192 ;
wire [7:0]	net0198 ;
wire [7:0]	z ;
wire [7:0]	net0213 ;
wire [7:0]	zbuf ;
wire [7:0]	net0221 ;
wire [7:0]	net0222 ;
wire		net0174 ;
wire		net087 ;
wire		net088 ;
wire		net186 ;
wire		net189 ;
wire		chose_z ;
wire		down_cond ;
wire		net192 ;
wire		net195 ;
wire		chose_z_n ;
wire		net0154 ;
wire		net0156 ;
wire		net94 ;
wire		net97 ;
wire		cofgp_n ;
wire		net0130 ;
wire		net0134 ;
wire		net0234 ;
wire		updclkbuf ;
wire		net0140 ;
wire		net0141 ;
wire		net0240 ;
wire		net0243 ;
wire		net0145 ;
wire		net164 ;
wire		net166 ;
wire		net0216 ;
wire		scan_in ;
wire		net0417 ;
wire		chzn ;
wire		net170 ;
wire		net0122 ;
wire		net172 ;
wire		net174 ;
wire		net0323 ;
wire		net0128 ;
wire		scan_out ;
wire		up_cond ;
 
 
bw_u1_inv_2x I128 (
     .z               (net164 ),
     .a               (global_reset_n ) );
bw_u1_nand2_4x I223_5_ (
     .z               (net0192[2] ),
     .a               (net0207[2] ),
     .b               (net0189[2] ) );
bw_u1_soffm2_4x I166_0_ (
     .q               (z[0] ),
     .so              (scan_out ),
     .ck              (clk ),
     .d0              (precnt[0] ),
     .d1              (net0192[7] ),
     .s               (hard_reset_n ),
     .se              (se ),
     .sd              (scan_data[1] ) );
bw_u1_nand2_2x I265_2_ (
     .z               (net0209[5] ),
     .a               (net0221[5] ),
     .b               (net0145 ) );
bw_u1_nand2_2x I225_1_ (
     .z               (net0189[6] ),
     .a               (synced_upd_imped ),
     .b               (sz[1] ) );
bw_u1_nand2_2x I264_0_ (
     .z               (net0212[7] ),
     .a               (freeze ),
     .b               (zbuf[0] ) );
bw_u1_nand2_2x I224_7_ (
     .z               (net0207[0] ),
     .a               (mz[7] ),
     .b               (net0174 ) );
bw_u1_nand2_2x I229_1_ (
     .z               (net0204[6] ),
     .a               (net0128 ),
     .b               (zbuf[0] ) );
bw_u1_nand2_2x I266_4_ (
     .z               (mz[4] ),
     .a               (net0209[3] ),
     .b               (net0212[3] ) );
bw_u1_inv_5x I269_2_ (
     .z               (zbuf[2] ),
     .a               (net0146[5] ) );
bw_u1_nand2_2x I228_7_ (
     .z               (net0246[0] ),
     .a               (net0247[0] ),
     .b               (net087 ) );
bw_u1_nand2_4x I235_1_ (
     .z               (net0247[6] ),
     .a               (net0213[6] ),
     .b               (net0186[6] ) );
bw_u1_nand2_2x I230_7_ (
     .z               (net0221[0] ),
     .a               (net0246[0] ),
     .b               (net0204[0] ) );
bw_u1_nand2_2x I233_5_ (
     .z               (net0186[2] ),
     .a               (net0141 ),
     .b               (z[6] ) );
bw_u1_nand2_4x I239_1_ (
     .z               (precnt[1] ),
     .a               (net0225[6] ),
     .b               (net0222[6] ) );
bw_u1_nand2_2x I237_5_ (
     .z               (net0222[2] ),
     .a               (net0134 ),
     .b               (vss ) );
bw_u1_nand2_2x I234_7_ (
     .z               (net0213[0] ),
     .a               (z[7] ),
     .b               (net088 ) );
bw_u1_nand2_2x I238_7_ (
     .z               (net0225[0] ),
     .a               (vss ),
     .b               (config_pmos ) );
bw_u1_nand2_2x I241_1_ (
     .z               (net0237[6] ),
     .a               (net0154 ),
     .b               (zbuf[2] ) );
bw_u1_nor2_2x I131 (
     .z               (net97 ),
     .a               (net170 ),
     .b               (freeze ) );
bw_u1_nand2_4x I243_5_ (
     .z               (d[5] ),
     .a               (net0228[2] ),
     .b               (net0237[2] ) );
bw_u1_inv_4x I132 (
     .z               (net174 ),
     .a               (net189 ) );
bw_u1_nand2_2x I242_3_ (
     .z               (net0228[4] ),
     .a               (zbuf[3] ),
     .b               (chose_z ) );
bw_u1_nand2_4x I246_3_ (
     .z               (z_post[3] ),
     .a               (net0198[4] ),
     .b               (net0201[4] ) );
bw_u1_nand2_2x I133 (
     .z               (net189 ),
     .a               (net94 ),
     .b               (net97 ) );
bw_u1_nand2_2x I247_5_ (
     .z               (net0198[2] ),
     .a               (from_csr[5] ),
     .b               (we_csr ) );
bw_u1_nand3_4x I231 (
     .z               (net087 ),
     .a               (updclkbuf ),
     .b               (chose_z ),
     .c               (up_cond ) );
bw_u1_nand2_4x I134 (
     .z               (net186 ),
     .a               (updclkbuf ),
     .b               (net0417 ) );
bw_u1_nand2_2x I248_7_ (
     .z               (net0201[0] ),
     .a               (net0130 ),
     .b               (zbuf[7] ) );
bw_u1_inv_5x I232 (
     .z               (net0128 ),
     .a               (net087 ) );
bw_u1_inv_2x I135 (
     .z               (net170 ),
     .a               (net186 ) );
bw_u1_inv_4x I215_0_ (
     .z               (net0146[7] ),
     .a               (z[0] ) );
bw_u1_inv_8x I214_6_ (
     .z               (to_csr[6] ),
     .a               (net0146[1] ) );
bw_u1_inv_2x I137 (
     .z               (net172 ),
     .a               (above ) );
bw_u1_inv_4x I236 (
     .z               (net0134 ),
     .a               (config_pmos ) );
bw_u1_inv_2x I138 (
     .z               (net166 ),
     .a               (adv_sgn ) );
bw_u1_nand2_4x I223_4_ (
     .z               (net0192[3] ),
     .a               (net0207[3] ),
     .b               (net0189[3] ) );
bw_u1_nand2_2x I265_1_ (
     .z               (net0209[6] ),
     .a               (net0221[6] ),
     .b               (net0145 ) );
bw_u1_nand2_2x I224_6_ (
     .z               (net0207[1] ),
     .a               (mz[6] ),
     .b               (net0174 ) );
bw_u1_nand2_2x I225_0_ (
     .z               (net0189[7] ),
     .a               (synced_upd_imped ),
     .b               (sz[0] ) );
bw_u1_soffm2_4x I166_7_ (
     .q               (z[7] ),
     .so              (scan_data[7] ),
     .ck              (clk ),
     .d0              (precnt[7] ),
     .d1              (net0192[0] ),
     .s               (hard_reset_n ),
     .se              (se ),
     .sd              (scan_data[0] ) );
bw_u1_nand2_2x I228_6_ (
     .z               (net0246[1] ),
     .a               (net0247[1] ),
     .b               (net087 ) );
bw_u1_nand2_2x I229_0_ (
     .z               (net0204[7] ),
     .a               (net0128 ),
     .b               (cofgp_n ) );
bw_u1_nand2_2x I266_3_ (
     .z               (mz[3] ),
     .a               (net0209[4] ),
     .b               (net0212[4] ) );
bw_u1_nand2_2x I264_7_ (
     .z               (net0212[0] ),
     .a               (freeze ),
     .b               (zbuf[7] ) );
bw_u1_inv_5x I269_1_ (
     .z               (zbuf[1] ),
     .a               (net0146[6] ) );
bw_u1_nand2_2x I230_6_ (
     .z               (net0221[1] ),
     .a               (net0246[1] ),
     .b               (net0204[1] ) );
bw_u1_nand2_4x I235_0_ (
     .z               (net0247[7] ),
     .a               (net0213[7] ),
     .b               (net0186[7] ) );
bw_u1_nand2_2x I234_6_ (
     .z               (net0213[1] ),
     .a               (z[6] ),
     .b               (net088 ) );
bw_u1_nand2_2x I233_4_ (
     .z               (net0186[3] ),
     .a               (net0141 ),
     .b               (z[5] ) );
bw_u1_nand2_4x I239_0_ (
     .z               (precnt[0] ),
     .a               (net0225[7] ),
     .b               (net0222[7] ) );
bw_u1_nand2_2x I238_6_ (
     .z               (net0225[1] ),
     .a               (vss ),
     .b               (config_pmos ) );
bw_u1_nand2_2x I237_4_ (
     .z               (net0222[3] ),
     .a               (net0134 ),
     .b               (vss ) );
bw_u1_nand2_2x I141 (
     .z               (net192 ),
     .a               (updclkbuf ),
     .b               (net0323 ) );
bw_u1_nand2_2x I241_0_ (
     .z               (net0237[7] ),
     .a               (net0154 ),
     .b               (zbuf[1] ) );
bw_u1_nand2_2x I242_2_ (
     .z               (net0228[5] ),
     .a               (zbuf[2] ),
     .b               (chose_z ) );
bw_u1_nand2_4x I243_4_ (
     .z               (d[4] ),
     .a               (net0228[3] ),
     .b               (net0237[3] ) );
bw_u1_nand2_4x I142 (
     .z               (net195 ),
     .a               (net192 ),
     .b               (chose_z ) );
bw_u1_nand2_4x I246_2_ (
     .z               (z_post[2] ),
     .a               (net0198[5] ),
     .b               (net0201[5] ) );
bw_u1_inv_8x I240 (
     .z               (net0154 ),
     .a               (chose_z ) );
bw_u1_nand2_2x I248_6_ (
     .z               (net0201[1] ),
     .a               (net0130 ),
     .b               (zbuf[6] ) );
bw_u1_nand2_2x I247_4_ (
     .z               (net0198[3] ),
     .a               (from_csr[4] ),
     .b               (we_csr ) );
bw_u1_inv_8x I214_5_ (
     .z               (to_csr[5] ),
     .a               (net0146[2] ) );
bw_u1_inv_4x I215_7_ (
     .z               (net0146[0] ),
     .a               (z[7] ) );
bw_u1_inv_8x I245 (
     .z               (net0130 ),
     .a               (we_csr ) );
bw_u1_nand2_4x I223_3_ (
     .z               (net0192[4] ),
     .a               (net0207[4] ),
     .b               (net0189[4] ) );
bw_u1_soffm2_4x I166_6_ (
     .q               (z[6] ),
     .so              (scan_data[6] ),
     .ck              (clk ),
     .d0              (precnt[6] ),
     .d1              (net0192[1] ),
     .s               (hard_reset_n ),
     .se              (se ),
     .sd              (scan_data[7] ) );
bw_u1_nand2_2x I265_0_ (
     .z               (net0209[7] ),
     .a               (net0221[7] ),
     .b               (net0145 ) );
bw_u1_nand2_2x I224_5_ (
     .z               (net0207[2] ),
     .a               (mz[5] ),
     .b               (net0174 ) );
bw_u1_nand2_2x I266_2_ (
     .z               (mz[2] ),
     .a               (net0209[5] ),
     .b               (net0212[5] ) );
bw_u1_nand2_2x I264_6_ (
     .z               (net0212[1] ),
     .a               (freeze ),
     .b               (zbuf[6] ) );
bw_u1_nand2_2x I228_5_ (
     .z               (net0246[2] ),
     .a               (net0247[2] ),
     .b               (net087 ) );
bw_u1_nand2_2x I225_7_ (
     .z               (net0189[0] ),
     .a               (synced_upd_imped ),
     .b               (sz[7] ) );
bw_u1_inv_5x I269_0_ (
     .z               (zbuf[0] ),
     .a               (net0146[7] ) );
bw_u1_nand2_2x I229_7_ (
     .z               (net0204[0] ),
     .a               (net0128 ),
     .b               (zbuf[6] ) );
bw_u1_nand2_2x I230_5_ (
     .z               (net0221[2] ),
     .a               (net0246[2] ),
     .b               (net0204[2] ) );
bw_u1_nand2_2x I234_5_ (
     .z               (net0213[2] ),
     .a               (z[5] ),
     .b               (net088 ) );
bw_u1_nand2_2x I233_3_ (
     .z               (net0186[4] ),
     .a               (net0141 ),
     .b               (z[4] ) );
bw_u1_nand2_4x I235_7_ (
     .z               (net0247[0] ),
     .a               (net0213[0] ),
     .b               (net0186[0] ) );
bw_u1_nand2_2x I238_5_ (
     .z               (net0225[2] ),
     .a               (vss ),
     .b               (config_pmos ) );
bw_u1_nand2_2x I237_3_ (
     .z               (net0222[4] ),
     .a               (net0134 ),
     .b               (vss ) );
bw_u1_nand2_4x I239_7_ (
     .z               (precnt[7] ),
     .a               (net0225[0] ),
     .b               (net0222[0] ) );
bw_u1_nand2_2x I242_1_ (
     .z               (net0228[6] ),
     .a               (zbuf[1] ),
     .b               (chose_z ) );
bw_u1_nand2_4x I243_3_ (
     .z               (d[3] ),
     .a               (net0228[4] ),
     .b               (net0237[4] ) );
bw_u1_nand2_4x I246_1_ (
     .z               (z_post[1] ),
     .a               (net0198[6] ),
     .b               (net0201[6] ) );
bw_u1_nand2_2x I241_7_ (
     .z               (net0237[0] ),
     .a               (net0154 ),
     .b               (config_pmos ) );
bw_u1_nand2_2x I248_5_ (
     .z               (net0201[2] ),
     .a               (net0130 ),
     .b               (zbuf[5] ) );
bw_u1_nand2_2x I247_3_ (
     .z               (net0198[4] ),
     .a               (from_csr[3] ),
     .b               (we_csr ) );
bw_u1_nand2_2x I252 (
     .z               (net0234 ),
     .a               (adv_sgn ),
     .b               (net0156 ) );
bw_u1_nand2_2x I253 (
     .z               (net0216 ),
     .a               (bypass ),
     .b               (net172 ) );
bw_u1_inv_4x I215_6_ (
     .z               (net0146[1] ),
     .a               (z[6] ) );
bw_u1_inv_2x I254 (
     .z               (net0156 ),
     .a               (bypass ) );
bw_u1_inv_8x I214_4_ (
     .z               (to_csr[4] ),
     .a               (net0146[3] ) );
bw_u1_nand2_2x I255 (
     .z               (net0240 ),
     .a               (net166 ),
     .b               (net0122 ) );
bw_u1_nand2_2x I256 (
     .z               (net0243 ),
     .a               (bypass ),
     .b               (above ) );
bw_u1_nand2_4x I223_2_ (
     .z               (net0192[5] ),
     .a               (net0207[5] ),
     .b               (net0189[5] ) );
bw_u1_inv_2x I257 (
     .z               (net0122 ),
     .a               (bypass ) );
bw_u1_soffm2_4x I166_5_ (
     .q               (z[5] ),
     .so              (scan_data[5] ),
     .ck              (clk ),
     .d0              (precnt[5] ),
     .d1              (net0192[2] ),
     .s               (hard_reset_n ),
     .se              (se ),
     .sd              (scan_data[6] ) );
bw_u1_nand2_2x I224_4_ (
     .z               (net0207[3] ),
     .a               (mz[4] ),
     .b               (net0174 ) );
bw_u1_nand2_2x I225_6_ (
     .z               (net0189[1] ),
     .a               (synced_upd_imped ),
     .b               (sz[6] ) );
bw_u1_nand2_2x I266_1_ (
     .z               (mz[1] ),
     .a               (net0209[6] ),
     .b               (net0212[6] ) );
bw_u1_nand2_2x I264_5_ (
     .z               (net0212[2] ),
     .a               (freeze ),
     .b               (zbuf[5] ) );
bw_u1_nand2_5x I258 (
     .z               (up_cond ),
     .a               (net0240 ),
     .b               (net0243 ) );
bw_u1_inv_4x I259 (
     .z               (net0323 ),
     .a               (up_cond ) );
bw_u1_nand2_2x I228_4_ (
     .z               (net0246[3] ),
     .a               (net0247[3] ),
     .b               (net087 ) );
bw_u1_nand2_2x I265_7_ (
     .z               (net0209[0] ),
     .a               (net0221[0] ),
     .b               (net0145 ) );
bw_u1_nand2_2x I229_6_ (
     .z               (net0204[1] ),
     .a               (net0128 ),
     .b               (zbuf[5] ) );
bw_u1_inv_5x I269_7_ (
     .z               (zbuf[7] ),
     .a               (net0146[0] ) );
bw_u1_nand2_2x I230_4_ (
     .z               (net0221[3] ),
     .a               (net0246[3] ),
     .b               (net0204[3] ) );
bw_u1_nand2_2x I233_2_ (
     .z               (net0186[5] ),
     .a               (net0141 ),
     .b               (z[3] ) );
bw_u1_nand2_4x I235_6_ (
     .z               (net0247[1] ),
     .a               (net0213[1] ),
     .b               (net0186[1] ) );
bw_u1_nand2_2x I237_2_ (
     .z               (net0222[5] ),
     .a               (net0134 ),
     .b               (vss ) );
bw_u1_nand2_2x I234_4_ (
     .z               (net0213[3] ),
     .a               (z[4] ),
     .b               (net088 ) );
bw_u1_nand2_4x I239_6_ (
     .z               (precnt[6] ),
     .a               (net0225[1] ),
     .b               (net0222[1] ) );
bw_u1_nand2_2x I238_4_ (
     .z               (net0225[3] ),
     .a               (vss ),
     .b               (config_pmos ) );
bw_u1_nand2_4x I243_2_ (
     .z               (d[2] ),
     .a               (net0228[5] ),
     .b               (net0237[5] ) );
bw_u1_nand2_2x I241_6_ (
     .z               (net0237[1] ),
     .a               (net0154 ),
     .b               (zbuf[7] ) );
bw_u1_nand2_2x I242_0_ (
     .z               (net0228[7] ),
     .a               (zbuf[0] ),
     .b               (chose_z ) );
bw_u1_nand2_4x I246_0_ (
     .z               (z_post[0] ),
     .a               (net0198[7] ),
     .b               (net0201[7] ) );
bw_u1_nand2_2x I247_2_ (
     .z               (net0198[5] ),
     .a               (from_csr[2] ),
     .b               (we_csr ) );
bw_u1_nand2_5x I260 (
     .z               (down_cond ),
     .a               (net0234 ),
     .b               (net0216 ) );
bw_u1_nand2_2x I248_4_ (
     .z               (net0201[3] ),
     .a               (net0130 ),
     .b               (zbuf[4] ) );
bw_u1_inv_2x I261 (
     .z               (net0417 ),
     .a               (down_cond ) );
bw_u1_inv_8x I262 (
     .z               (deltabit ),
     .a               (chzn ) );
bw_u1_inv_4x I215_5_ (
     .z               (net0146[2] ),
     .a               (z[5] ) );
bw_u1_inv_8x I214_3_ (
     .z               (to_csr[3] ),
     .a               (net0146[4] ) );
bw_u1_nand2_4x I223_1_ (
     .z               (net0192[6] ),
     .a               (net0207[6] ),
     .b               (net0189[6] ) );
bw_u1_inv_8x I267 (
     .z               (net0145 ),
     .a               (freeze ) );
bw_u1_soffm2_4x I166_4_ (
     .q               (z[4] ),
     .so              (scan_data[4] ),
     .ck              (clk ),
     .d0              (precnt[4] ),
     .d1              (net0192[3] ),
     .s               (hard_reset_n ),
     .se              (se ),
     .sd              (scan_data[5] ) );
bw_u1_nand2_2x I265_6_ (
     .z               (net0209[1] ),
     .a               (net0221[1] ),
     .b               (net0145 ) );
bw_u1_nand2_2x I224_3_ (
     .z               (net0207[4] ),
     .a               (mz[3] ),
     .b               (net0174 ) );
bw_u1_nand2_2x I225_5_ (
     .z               (net0189[2] ),
     .a               (synced_upd_imped ),
     .b               (sz[5] ) );
bw_u1_nand2_2x I266_0_ (
     .z               (mz[0] ),
     .a               (net0209[7] ),
     .b               (net0212[7] ) );
bw_u1_nand2_2x I264_4_ (
     .z               (net0212[3] ),
     .a               (freeze ),
     .b               (zbuf[4] ) );
bw_u1_nand2_2x I228_3_ (
     .z               (net0246[4] ),
     .a               (net0247[4] ),
     .b               (net087 ) );
bw_u1_nand2_2x I229_5_ (
     .z               (net0204[2] ),
     .a               (net0128 ),
     .b               (zbuf[4] ) );
bw_u1_inv_5x I269_6_ (
     .z               (zbuf[6] ),
     .a               (net0146[1] ) );
bw_u1_nand2_2x I230_3_ (
     .z               (net0221[4] ),
     .a               (net0246[4] ),
     .b               (net0204[4] ) );
bw_u1_nand2_2x I233_1_ (
     .z               (net0186[6] ),
     .a               (net0141 ),
     .b               (z[2] ) );
bw_u1_nand2_4x I235_5_ (
     .z               (net0247[2] ),
     .a               (net0213[2] ),
     .b               (net0186[2] ) );
bw_u1_nand2_2x I237_1_ (
     .z               (net0222[6] ),
     .a               (net0134 ),
     .b               (vss ) );
bw_u1_nand2_2x I234_3_ (
     .z               (net0213[4] ),
     .a               (z[3] ),
     .b               (net088 ) );
bw_u1_nand2_4x I239_5_ (
     .z               (precnt[5] ),
     .a               (net0225[2] ),
     .b               (net0222[2] ) );
bw_u1_nand2_2x I238_3_ (
     .z               (net0225[4] ),
     .a               (vss ),
     .b               (config_pmos ) );
bw_u1_nand2_4x I243_1_ (
     .z               (d[1] ),
     .a               (net0228[6] ),
     .b               (net0237[6] ) );
bw_u1_soffr_4x I171 (
     .q               (chose_z_n ),
     .so              (scan_data[0] ),
     .ck              (clk ),
     .d               (net195 ),
     .se              (se ),
     .sd              (scan_in ),
     .r_l             (net174 ) );
bw_u1_nand2_2x I241_5_ (
     .z               (net0237[2] ),
     .a               (net0154 ),
     .b               (zbuf[6] ) );
bw_u1_nand2_2x I242_7_ (
     .z               (net0228[0] ),
     .a               (zbuf[7] ),
     .b               (chose_z ) );
bw_u1_nand2_2x I247_1_ (
     .z               (net0198[6] ),
     .a               (from_csr[1] ),
     .b               (we_csr ) );
bw_u1_inv_2x I270 (
     .z               (net0140 ),
     .a               (updclk ) );
bw_u1_nand2_4x I246_7_ (
     .z               (z_post[7] ),
     .a               (net0198[0] ),
     .b               (net0201[0] ) );
bw_u1_nand2_2x I248_3_ (
     .z               (net0201[4] ),
     .a               (net0130 ),
     .b               (zbuf[3] ) );
bw_u1_inv_5x I271 (
     .z               (updclkbuf ),
     .a               (net0140 ) );
bw_u1_inv_8x I214_2_ (
     .z               (to_csr[2] ),
     .a               (net0146[5] ) );
bw_u1_inv_4x I215_4_ (
     .z               (net0146[3] ),
     .a               (z[4] ) );
bw_u1_nand2_4x I223_0_ (
     .z               (net0192[7] ),
     .a               (net0207[7] ),
     .b               (net0189[7] ) );
bw_u1_nand2_2x I224_2_ (
     .z               (net0207[5] ),
     .a               (mz[2] ),
     .b               (net0174 ) );
bw_u1_soffm2_4x I166_3_ (
     .q               (z[3] ),
     .so              (scan_data[3] ),
     .ck              (clk ),
     .d0              (precnt[3] ),
     .d1              (net0192[4] ),
     .s               (hard_reset_n ),
     .se              (se ),
     .sd              (scan_data[4] ) );
bw_u1_nand2_2x I228_2_ (
     .z               (net0246[5] ),
     .a               (net0247[5] ),
     .b               (net087 ) );
bw_u1_nand2_2x I265_5_ (
     .z               (net0209[2] ),
     .a               (net0221[2] ),
     .b               (net0145 ) );
bw_u1_nand2_2x I225_4_ (
     .z               (net0189[3] ),
     .a               (synced_upd_imped ),
     .b               (sz[4] ) );
bw_u1_nand2_2x I264_3_ (
     .z               (net0212[4] ),
     .a               (freeze ),
     .b               (zbuf[3] ) );
bw_u1_nand2_2x I229_4_ (
     .z               (net0204[3] ),
     .a               (net0128 ),
     .b               (zbuf[3] ) );
bw_u1_nand2_2x I266_7_ (
     .z               (mz[7] ),
     .a               (net0209[0] ),
     .b               (net0212[0] ) );
bw_u1_inv_5x I269_5_ (
     .z               (zbuf[5] ),
     .a               (net0146[2] ) );
bw_u1_nand2_2x I230_2_ (
     .z               (net0221[5] ),
     .a               (net0246[5] ),
     .b               (net0204[5] ) );
bw_u1_nand2_2x I234_2_ (
     .z               (net0213[5] ),
     .a               (z[2] ),
     .b               (net088 ) );
bw_u1_nand2_2x I233_0_ (
     .z               (net0186[7] ),
     .a               (net0141 ),
     .b               (z[1] ) );
bw_u1_nand2_4x I235_4_ (
     .z               (net0247[3] ),
     .a               (net0213[3] ),
     .b               (net0186[3] ) );
bw_u1_nand2_2x I238_2_ (
     .z               (net0225[5] ),
     .a               (vss ),
     .b               (config_pmos ) );
bw_u1_nand2_2x I237_0_ (
     .z               (net0222[7] ),
     .a               (net0134 ),
     .b               (vss ) );
bw_u1_nand2_4x I239_4_ (
     .z               (precnt[4] ),
     .a               (net0225[3] ),
     .b               (net0222[3] ) );
bw_u1_nand2_4x I243_0_ (
     .z               (d[0] ),
     .a               (net0228[7] ),
     .b               (net0237[7] ) );
bw_u1_nand2_2x I241_4_ (
     .z               (net0237[3] ),
     .a               (net0154 ),
     .b               (zbuf[5] ) );
bw_u1_nand2_2x I242_6_ (
     .z               (net0228[1] ),
     .a               (zbuf[6] ),
     .b               (chose_z ) );
bw_u1_nand2_4x I246_6_ (
     .z               (z_post[6] ),
     .a               (net0198[1] ),
     .b               (net0201[1] ) );
bw_u1_nand2_2x I248_2_ (
     .z               (net0201[5] ),
     .a               (net0130 ),
     .b               (zbuf[2] ) );
bw_u1_nand2_2x I247_0_ (
     .z               (net0198[7] ),
     .a               (from_csr[0] ),
     .b               (we_csr ) );
bw_u1_inv_8x I214_1_ (
     .z               (to_csr[1] ),
     .a               (net0146[6] ) );
bw_u1_inv_4x I215_3_ (
     .z               (net0146[4] ),
     .a               (z[3] ) );
bw_u1_soffm2_4x I166_2_ (
     .q               (z[2] ),
     .so              (scan_data[2] ),
     .ck              (clk ),
     .d0              (precnt[2] ),
     .d1              (net0192[5] ),
     .s               (hard_reset_n ),
     .se              (se ),
     .sd              (scan_data[3] ) );
bw_u1_nand2_2x I224_1_ (
     .z               (net0207[6] ),
     .a               (mz[1] ),
     .b               (net0174 ) );
bw_u1_nand2_2x I264_2_ (
     .z               (net0212[5] ),
     .a               (freeze ),
     .b               (zbuf[2] ) );
bw_u1_inv_10x I37 (
     .z               (chose_z ),
     .a               (chose_z_n ) );
bw_u1_nand2_4x I223_7_ (
     .z               (net0192[0] ),
     .a               (net0207[0] ),
     .b               (net0189[0] ) );
bw_u1_inv_4x I38 (
     .z               (chzn ),
     .a               (chose_z ) );
bw_u1_nand2_2x I228_1_ (
     .z               (net0246[6] ),
     .a               (net0247[6] ),
     .b               (net087 ) );
bw_u1_nand2_2x I265_4_ (
     .z               (net0209[3] ),
     .a               (net0221[3] ),
     .b               (net0145 ) );
bw_u1_nand2_2x I225_3_ (
     .z               (net0189[4] ),
     .a               (synced_upd_imped ),
     .b               (sz[3] ) );
bw_u1_nand2_2x I266_6_ (
     .z               (mz[6] ),
     .a               (net0209[1] ),
     .b               (net0212[1] ) );
bw_u1_nand2_2x I229_3_ (
     .z               (net0204[4] ),
     .a               (net0128 ),
     .b               (zbuf[2] ) );
bw_u1_inv_5x I269_4_ (
     .z               (zbuf[4] ),
     .a               (net0146[3] ) );
bw_u1_nand2_2x I230_1_ (
     .z               (net0221[6] ),
     .a               (net0246[6] ),
     .b               (net0204[6] ) );
bw_u1_nand2_2x I234_1_ (
     .z               (net0213[6] ),
     .a               (z[1] ),
     .b               (net088 ) );
bw_u1_nand2_4x I235_3_ (
     .z               (net0247[4] ),
     .a               (net0213[4] ),
     .b               (net0186[4] ) );
bw_u1_nand2_2x I238_1_ (
     .z               (net0225[6] ),
     .a               (vss ),
     .b               (config_pmos ) );
bw_u1_nand2_2x I233_7_ (
     .z               (net0186[0] ),
     .a               (net0141 ),
     .b               (config_pmos ) );
bw_u1_nand2_4x I239_3_ (
     .z               (precnt[3] ),
     .a               (net0225[4] ),
     .b               (net0222[4] ) );
bw_u1_nand2_2x I237_7_ (
     .z               (net0222[0] ),
     .a               (net0134 ),
     .b               (vss ) );
bw_u1_nand2_2x I241_3_ (
     .z               (net0237[4] ),
     .a               (net0154 ),
     .b               (zbuf[4] ) );
bw_u1_nand2_2x I242_5_ (
     .z               (net0228[2] ),
     .a               (zbuf[5] ),
     .b               (chose_z ) );
bw_u1_nand2_4x I243_7_ (
     .z               (d[7] ),
     .a               (net0228[0] ),
     .b               (net0237[0] ) );
bw_u1_nand2_4x I246_5_ (
     .z               (z_post[5] ),
     .a               (net0198[2] ),
     .b               (net0201[2] ) );
bw_u1_nand2_2x I248_1_ (
     .z               (net0201[6] ),
     .a               (net0130 ),
     .b               (zbuf[1] ) );
bw_u1_nand2_2x I247_7_ (
     .z               (net0198[0] ),
     .a               (from_csr[7] ),
     .b               (we_csr ) );
bw_u1_nand3_4x I193 (
     .z               (net088 ),
     .a               (updclk ),
     .b               (chzn ),
     .c               (down_cond ) );
bw_u1_inv_5x I194 (
     .z               (net0141 ),
     .a               (net088 ) );
bw_u1_inv_4x I215_2_ (
     .z               (net0146[5] ),
     .a               (z[2] ) );
bw_u1_inv_8x I214_0_ (
     .z               (to_csr[0] ),
     .a               (net0146[7] ) );
bw_u1_inv_4x I196 (
     .z               (cofgp_n ),
     .a               (config_pmos ) );
bw_u1_inv_4x I197 (
     .z               (so_l ),
     .a               (scan_out ) );
bw_u1_nand2_4x I223_6_ (
     .z               (net0192[1] ),
     .a               (net0207[1] ),
     .b               (net0189[1] ) );
bw_u1_inv_4x I199 (
     .z               (scan_in ),
     .a               (si_l ) );
bw_u1_soffm2_4x I166_1_ (
     .q               (z[1] ),
     .so              (scan_data[1] ),
     .ck              (clk ),
     .d0              (precnt[1] ),
     .d1              (net0192[6] ),
     .s               (hard_reset_n ),
     .se              (se ),
     .sd              (scan_data[2] ) );
bw_u1_nand2_2x I224_0_ (
     .z               (net0207[7] ),
     .a               (mz[0] ),
     .b               (net0174 ) );
bw_u1_nand2_2x I225_2_ (
     .z               (net0189[5] ),
     .a               (synced_upd_imped ),
     .b               (sz[2] ) );
bw_u1_nand2_2x I264_1_ (
     .z               (net0212[6] ),
     .a               (freeze ),
     .b               (zbuf[1] ) );
bw_u1_nand2_2x I228_0_ (
     .z               (net0246[7] ),
     .a               (net0247[7] ),
     .b               (net087 ) );
bw_u1_nand2_2x I265_3_ (
     .z               (net0209[4] ),
     .a               (net0221[4] ),
     .b               (net0145 ) );
bw_u1_nand2_2x I229_2_ (
     .z               (net0204[5] ),
     .a               (net0128 ),
     .b               (zbuf[1] ) );
bw_u1_nand2_2x I266_5_ (
     .z               (mz[5] ),
     .a               (net0209[2] ),
     .b               (net0212[2] ) );
bw_u1_inv_5x I269_3_ (
     .z               (zbuf[3] ),
     .a               (net0146[4] ) );
bw_u1_nand2_2x I230_0_ (
     .z               (net0221[7] ),
     .a               (net0246[7] ),
     .b               (net0204[7] ) );
bw_u1_nand2_4x I235_2_ (
     .z               (net0247[5] ),
     .a               (net0213[5] ),
     .b               (net0186[5] ) );
bw_u1_nand2_2x I234_0_ (
     .z               (net0213[7] ),
     .a               (z[0] ),
     .b               (net088 ) );
bw_u1_nand2_2x I233_6_ (
     .z               (net0186[1] ),
     .a               (net0141 ),
     .b               (z[7] ) );
bw_u1_nand2_4x I239_2_ (
     .z               (precnt[2] ),
     .a               (net0225[5] ),
     .b               (net0222[5] ) );
bw_u1_nand2_2x I238_0_ (
     .z               (net0225[7] ),
     .a               (vss ),
     .b               (config_pmos ) );
bw_u1_nand2_2x I237_6_ (
     .z               (net0222[1] ),
     .a               (net0134 ),
     .b               (vss ) );
bw_u1_nand2_2x I241_2_ (
     .z               (net0237[5] ),
     .a               (net0154 ),
     .b               (zbuf[3] ) );
bw_u1_nand2_4x I243_6_ (
     .z               (d[6] ),
     .a               (net0228[1] ),
     .b               (net0237[1] ) );
bw_u1_nand2_2x I242_4_ (
     .z               (net0228[3] ),
     .a               (zbuf[4] ),
     .b               (chose_z ) );
bw_u1_nand2_4x I246_4_ (
     .z               (z_post[4] ),
     .a               (net0198[3] ),
     .b               (net0201[3] ) );
bw_u1_nand2_2x I248_0_ (
     .z               (net0201[7] ),
     .a               (net0130 ),
     .b               (zbuf[0] ) );
bw_u1_nand2_2x I247_6_ (
     .z               (net0198[1] ),
     .a               (from_csr[6] ),
     .b               (we_csr ) );
bw_u1_inv_4x I222 (
     .z               (net0174 ),
     .a               (synced_upd_imped ) );
bw_u1_inv_4x I215_1_ (
     .z               (net0146[6] ),
     .a               (z[1] ) );
bw_u1_inv_8x I214_7_ (
     .z               (to_csr[7] ),
     .a               (net0146[0] ) );
bw_u1_nor2_2x I127 (
     .z               (net94 ),
     .a               (synced_upd_imped ),
     .b               (net164 ) );
endmodule
