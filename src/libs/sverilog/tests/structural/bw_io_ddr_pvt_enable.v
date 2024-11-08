// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_pvt_enable.v
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
module bw_io_ddr_pvt_enable(cbd_in ,si ,en ,rclk ,se ,cbu_in ,cbu_out ,
     cbd_out ,so );
output [8:1]	cbu_out ;
output [8:1]	cbd_out ;
input [8:1]	cbd_in ;
input [8:1]	cbu_in ;
output		so ;
input		si ;
input		en ;
input		rclk ;
input		se ;
 
wire [8:2]	scan1 ;
wire [8:1]	scan0 ;
wire [7:0]	net038 ;
wire [7:0]	net044 ;
wire		en_l ;
wire		clk ;
wire		se_l ;
 
 
bw_u1_inv_30x cbuINV_6_ (
     .z               (cbu_out[6] ),
     .a               (net044[2] ) );
bw_u1_soffi_8x cbuFF_1_ (
     .q_l             (net044[7] ),
     .so              (scan0[1] ),
     .ck              (clk ),
     .d               (cbu_in[1] ),
     .se              (se ),
     .sd              (scan0[2] ) );
bw_u1_ckenbuf_6x I0 (
     .clk             (clk ),
     .rclk            (rclk ),
     .en_l            (en_l ),
     .tm_l            (se_l ) );
bw_u1_soffi_8x cbdFF_8_ (
     .q_l             (net038[0] ),
     .so              (scan1[8] ),
     .ck              (clk ),
     .d               (cbd_in[8] ),
     .se              (se ),
     .sd              (scan0[1] ) );
bw_u1_inv_30x cbdINV_6_ (
     .z               (cbd_out[6] ),
     .a               (net038[2] ) );
bw_u1_inv_1x I9 (
     .z               (se_l ),
     .a               (se ) );
bw_u1_soffi_8x cbuFF_4_ (
     .q_l             (net044[4] ),
     .so              (scan0[4] ),
     .ck              (clk ),
     .d               (cbu_in[4] ),
     .se              (se ),
     .sd              (scan0[5] ) );
bw_u1_inv_30x cbuINV_5_ (
     .z               (cbu_out[5] ),
     .a               (net044[3] ) );
bw_u1_soffi_8x cbdFF_7_ (
     .q_l             (net038[1] ),
     .so              (scan1[7] ),
     .ck              (clk ),
     .d               (cbd_in[7] ),
     .se              (se ),
     .sd              (scan1[8] ) );
bw_u1_inv_30x cbdINV_7_ (
     .z               (cbd_out[7] ),
     .a               (net038[1] ) );
bw_u1_soffi_8x cbuFF_3_ (
     .q_l             (net044[5] ),
     .so              (scan0[3] ),
     .ck              (clk ),
     .d               (cbu_in[3] ),
     .se              (se ),
     .sd              (scan0[4] ) );
bw_u1_inv_30x cbuINV_8_ (
     .z               (cbu_out[8] ),
     .a               (net044[0] ) );
bw_u1_soffi_8x cbdFF_2_ (
     .q_l             (net038[6] ),
     .so              (scan1[2] ),
     .ck              (clk ),
     .d               (cbd_in[2] ),
     .se              (se ),
     .sd              (scan1[3] ) );
bw_u1_inv_30x cbdINV_8_ (
     .z               (cbd_out[8] ),
     .a               (net038[0] ) );
bw_u1_soffi_8x cbuFF_6_ (
     .q_l             (net044[2] ),
     .so              (scan0[6] ),
     .ck              (clk ),
     .d               (cbu_in[6] ),
     .se              (se ),
     .sd              (scan0[7] ) );
bw_u1_inv_30x cbuINV_7_ (
     .z               (cbu_out[7] ),
     .a               (net044[1] ) );
bw_u1_inv_1x I12 (
     .z               (en_l ),
     .a               (en ) );
bw_u1_inv_30x cbdINV_1_ (
     .z               (cbd_out[1] ),
     .a               (net038[7] ) );
bw_u1_soffi_8x cbdFF_1_ (
     .q_l             (net038[7] ),
     .so              (so ),
     .ck              (clk ),
     .d               (cbd_in[1] ),
     .se              (se ),
     .sd              (scan1[2] ) );
bw_u1_soffi_8x cbuFF_5_ (
     .q_l             (net044[3] ),
     .so              (scan0[5] ),
     .ck              (clk ),
     .d               (cbu_in[5] ),
     .se              (se ),
     .sd              (scan0[6] ) );
bw_u1_inv_30x cbuINV_2_ (
     .z               (cbu_out[2] ),
     .a               (net044[6] ) );
bw_u1_soffi_8x cbdFF_4_ (
     .q_l             (net038[4] ),
     .so              (scan1[4] ),
     .ck              (clk ),
     .d               (cbd_in[4] ),
     .se              (se ),
     .sd              (scan1[5] ) );
bw_u1_inv_30x cbdINV_2_ (
     .z               (cbd_out[2] ),
     .a               (net038[6] ) );
bw_u1_soffi_8x cbuFF_8_ (
     .q_l             (net044[0] ),
     .so              (scan0[8] ),
     .ck              (clk ),
     .d               (cbu_in[8] ),
     .se              (se ),
     .sd              (si ) );
bw_u1_inv_30x cbuINV_1_ (
     .z               (cbu_out[1] ),
     .a               (net044[7] ) );
bw_u1_soffi_8x cbdFF_3_ (
     .q_l             (net038[5] ),
     .so              (scan1[3] ),
     .ck              (clk ),
     .d               (cbd_in[3] ),
     .se              (se ),
     .sd              (scan1[4] ) );
bw_u1_inv_30x cbdINV_3_ (
     .z               (cbd_out[3] ),
     .a               (net038[5] ) );
bw_u1_soffi_8x cbuFF_7_ (
     .q_l             (net044[1] ),
     .so              (scan0[7] ),
     .ck              (clk ),
     .d               (cbu_in[7] ),
     .se              (se ),
     .sd              (scan0[8] ) );
bw_u1_inv_30x cbuINV_4_ (
     .z               (cbu_out[4] ),
     .a               (net044[4] ) );
bw_u1_soffi_8x cbdFF_6_ (
     .q_l             (net038[2] ),
     .so              (scan1[6] ),
     .ck              (clk ),
     .d               (cbd_in[6] ),
     .se              (se ),
     .sd              (scan1[7] ) );
bw_u1_inv_30x cbdINV_4_ (
     .z               (cbd_out[4] ),
     .a               (net038[4] ) );
bw_u1_inv_30x cbuINV_3_ (
     .z               (cbu_out[3] ),
     .a               (net044[5] ) );
bw_u1_soffi_8x cbuFF_2_ (
     .q_l             (net044[6] ),
     .so              (scan0[2] ),
     .ck              (clk ),
     .d               (cbu_in[2] ),
     .se              (se ),
     .sd              (scan0[3] ) );
bw_u1_soffi_8x cbdFF_5_ (
     .q_l             (net038[3] ),
     .so              (scan1[5] ),
     .ck              (clk ),
     .d               (cbd_in[5] ),
     .se              (se ),
     .sd              (scan1[6] ) );
bw_u1_inv_30x cbdINV_5_ (
     .z               (cbd_out[5] ),
     .a               (net038[3] ) );
endmodule
