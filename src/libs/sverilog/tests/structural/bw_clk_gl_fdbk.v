// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_gl_fdbk.v
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
module bw_clk_gl_fdbk_hz(c12 ,c16 );
output		c12 ;
input		c16 ;
 
wire		c13 ;
wire		c14 ;
wire		c15 ;
wire		net26 ;
wire		net043 ;
 
 
bw_clk_gclk_inv_224x x5 (
     .clkout          (net043 ),
     .clkin           (c13 ) );
bw_clk_gclk_inv_288x x6 (
     .clkout          (c14 ),
     .clkin           (c15 ) );
bw_clk_gclk_inv_224x x7 (
     .clkout          (c12 ),
     .clkin           (c13 ) );
bw_clk_gclk_inv_288x x8 (
     .clkout          (net26 ),
     .clkin           (c15 ) );
bw_clk_gclk_inv_224x xc14 (
     .clkout          (c15 ),
     .clkin           (c16 ) );
bw_clk_gclk_inv_192x x1 (
     .clkout          (c13 ),
     .clkin           (c14 ) );
endmodule

module bw_clk_gl_fdbk_vrt(c12 ,gclk );
output		gclk ;
input		c12 ;
 
wire		c10 ;
wire		c11a ;
wire		net55 ;
wire		net077 ;
wire		c8 ;
wire		c9 ;
wire		net67 ;
 
 
bw_clk_gclk_inv_r90_224x xc7_1_ (
     .clkout          (net077 ),
     .clkin           (c8 ) );
bw_clk_gclk_inv_r90_192x xc8_0_ (
     .clkout          (c8 ),
     .clkin           (c9 ) );
bw_clk_gclk_inv_r90_256x xc11_0_ (
     .clkout          (c11a ),
     .clkin           (c12 ) );
bw_clk_gclk_inv_r90_192x xc8_1_ (
     .clkout          (net55 ),
     .clkin           (c9 ) );
bw_clk_gclk_inv_r90_192x xc10b_0_ (
     .clkout          (c10 ),
     .clkin           (c11a ) );
bw_clk_gclk_inv_r90_224x xc9_0_ (
     .clkout          (c9 ),
     .clkin           (c10 ) );
bw_clk_gclk_inv_r90_256x xc11_1_ (
     .clkout          (net67 ),
     .clkin           (c12 ) );
bw_clk_gclk_inv_r90_224x xc7_0_ (
     .clkout          (gclk ),
     .clkin           (c8 ) );
endmodule

module bw_clk_gl_fdbk_clstr(rclk ,gclk );
output		rclk ;
input		gclk ;
supply1		vdd ;
supply0		vss ;
 
wire [0:0]	c3 ;
wire		net28 ;
wire		net47 ;
wire		net49 ;
wire		net51 ;
wire		net53 ;
wire		net54 ;
wire		net56 ;
wire		c4 ;
wire		c5 ;
wire		net62 ;
wire		cclk ;
wire		net66 ;
 
 
bw_clk_cclk_inv_128x xc2_3_ (
     .clkout          (net51 ),
     .clkin           (c3[0] ) );
bw_clk_cclk_inv_96x xc3_1_ (
     .clkout          (net66 ),
     .clkin           (c4 ) );
bw_clk_cclk_inv_64x xc4_0_ (
     .clkout          (c4 ),
     .clkin           (c5 ) );
bw_clk_cclk_inv_64x xc4_1_ (
     .clkout          (net62 ),
     .clkin           (c5 ) );
bw_clk_cclk_inv_48x xc5_0_ (
     .clkout          (c5 ),
     .clkin           (cclk ) );
bw_clk_cclk_inv_48x xc5_1_ (
     .clkout          (net28 ),
     .clkin           (cclk ) );
bw_clk_cclk_hdr_64x xclhdr (
     .cluster_cken    (vdd ),
     .grst_l          (vdd ),
     .arst_l          (vdd ),
     .adbginit_l      (vdd ),
     .gclk            (gclk ),
     .rst_l           (net53 ),
     .dbginit_l       (net54 ),
     .so              (net56 ),
     .clk             (cclk ),
     .se              (vss ),
     .si              (vss ),
     .gdbginit_l      (vdd ),
     .rclk            (vss ) );
bw_clk_cclk_inv_128x xc2_0_ (
     .clkout          (rclk ),
     .clkin           (c3[0] ) );
bw_clk_cclk_inv_128x xc2_1_ (
     .clkout          (net47 ),
     .clkin           (c3[0] ) );
bw_clk_cclk_inv_128x xc2_2_ (
     .clkout          (net49 ),
     .clkin           (c3[0] ) );
bw_clk_cclk_inv_96x xc3_0_ (
     .clkout          (c3[0] ),
     .clkin           (c4 ) );
endmodule

module bw_clk_gl_fdbk(clk_fdbk_in ,clk_fdbk_out );
output		clk_fdbk_out ;
input		clk_fdbk_in ;
 
wire		clk12 ;
wire		gclk ;
 
 
bw_clk_gl_fdbk_hz i0 (
     .c12             (clk12 ),
     .c16             (clk_fdbk_in ) );
bw_clk_gl_fdbk_vrt i1 (
     .c12             (clk12 ),
     .gclk            (gclk ) );
bw_clk_gl_fdbk_clstr i2 (
     .rclk            (clk_fdbk_out ),
     .gclk            (gclk ) );
endmodule

