// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_gl_vrt_all.v
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
module bw_clk_gl_vrt1(c12 ,sctag_in ,sctag_out ,c7 );
output [1:0]	sctag_out ;
output [7:0]	c7 ;
input [1:0]	sctag_in ;
input		c12 ;
 
wire [1:0]	c11 ;
wire [3:0]	c8 ;
wire [1:0]	c10 ;
wire [1:0]	c9 ;
 
assign	c8[2] = sctag_in[1] ;
assign	c8[1] = sctag_in[0] ;
assign	sctag_out[1] = c9[1] ;
assign	sctag_out[0] = c9[0] ;
 
bw_clk_gclk_inv_r90_224x xc7_1_ (
     .clkout          (c7[1] ),
     .clkin           (c8[0] ) );
bw_clk_gclk_inv_r90_256x xc10a_0_ (
     .clkout          (c11[0] ),
     .clkin           (c12 ) );
bw_clk_gclk_inv_r90_224x xc7_2_ (
     .clkout          (c7[2] ),
     .clkin           (c8[1] ) );
bw_clk_gclk_inv_r90_192x xc8_0_ (
     .clkout          (c8[0] ),
     .clkin           (c9[0] ) );
bw_clk_gclk_inv_r90_256x xc10a_1_ (
     .clkout          (c11[1] ),
     .clkin           (c12 ) );
bw_clk_gclk_inv_r90_224x xc7_3_ (
     .clkout          (c7[3] ),
     .clkin           (c8[1] ) );
bw_clk_gclk_inv_r90_192x xc10b_0_ (
     .clkout          (c10[0] ),
     .clkin           (c11[0] ) );
bw_clk_gclk_inv_r90_224x xc7_4_ (
     .clkout          (c7[4] ),
     .clkin           (c8[2] ) );
bw_clk_gclk_inv_r90_224x xc9_0_ (
     .clkout          (c9[0] ),
     .clkin           (c10[0] ) );
bw_clk_gclk_inv_r90_192x xc10b_1_ (
     .clkout          (c10[1] ),
     .clkin           (c11[1] ) );
bw_clk_gclk_inv_r90_224x xc7_5_ (
     .clkout          (c7[5] ),
     .clkin           (c8[2] ) );
bw_clk_gclk_inv_r90_224x xc9_1_ (
     .clkout          (c9[1] ),
     .clkin           (c10[1] ) );
bw_clk_gclk_inv_r90_192x xc8_3_ (
     .clkout          (c8[3] ),
     .clkin           (c9[1] ) );
bw_clk_gclk_inv_r90_224x xc7_6_ (
     .clkout          (c7[6] ),
     .clkin           (c8[3] ) );
bw_clk_gclk_inv_r90_224x xc7_7_ (
     .clkout          (c7[7] ),
     .clkin           (c8[3] ) );
bw_clk_gclk_inv_r90_224x xc7_0_ (
     .clkout          (c7[0] ),
     .clkin           (c8[0] ) );
endmodule

module bw_clk_gl_vrt2(c7 ,sctag_out ,sctag_in ,c12 );
output [7:0]	c7 ;
output [1:0]	sctag_out ;
input [1:0]	sctag_in ;
input		c12 ;
 
wire [1:0]	c11 ;
wire [3:0]	c8 ;
wire [1:0]	c10 ;
wire [1:0]	c9 ;
 
assign	sctag_out[1] = c9[1] ;
assign	sctag_out[0] = c9[0] ;
assign	c8[2] = sctag_in[1] ;
assign	c8[1] = sctag_in[0] ;
 
bw_clk_gclk_inv_r90_224x xc7_1_ (
     .clkout          (c7[1] ),
     .clkin           (c8[0] ) );
bw_clk_gclk_inv_r90_256x xc10a_0_ (
     .clkout          (c11[0] ),
     .clkin           (c12 ) );
bw_clk_gclk_inv_r90_192x xc8_0_ (
     .clkout          (c8[0] ),
     .clkin           (c9[0] ) );
bw_clk_gclk_inv_r90_224x xc7_2_ (
     .clkout          (c7[2] ),
     .clkin           (c8[1] ) );
bw_clk_gclk_inv_r90_256x xc10a_1_ (
     .clkout          (c11[1] ),
     .clkin           (c12 ) );
bw_clk_gclk_inv_r90_224x xc7_3_ (
     .clkout          (c7[3] ),
     .clkin           (c8[1] ) );
bw_clk_gclk_inv_r90_192x xc10b_0_ (
     .clkout          (c10[0] ),
     .clkin           (c11[0] ) );
bw_clk_gclk_inv_r90_224x xc7_4_ (
     .clkout          (c7[4] ),
     .clkin           (c8[2] ) );
bw_clk_gclk_inv_r90_224x xc9_0_ (
     .clkout          (c9[0] ),
     .clkin           (c10[0] ) );
bw_clk_gclk_inv_r90_192x xc10b_1_ (
     .clkout          (c10[1] ),
     .clkin           (c11[1] ) );
bw_clk_gclk_inv_r90_192x xc8_3_ (
     .clkout          (c8[3] ),
     .clkin           (c9[1] ) );
bw_clk_gclk_inv_r90_224x xc7_5_ (
     .clkout          (c7[5] ),
     .clkin           (c8[2] ) );
bw_clk_gclk_inv_r90_224x xc9_1_ (
     .clkout          (c9[1] ),
     .clkin           (c10[1] ) );
bw_clk_gclk_inv_r90_224x xc7_6_ (
     .clkout          (c7[6] ),
     .clkin           (c8[3] ) );
bw_clk_gclk_inv_r90_224x xc7_7_ (
     .clkout          (c7[7] ),
     .clkin           (c8[3] ) );
bw_clk_gclk_inv_r90_224x xc7_0_ (
     .clkout          (c7[0] ),
     .clkin           (c8[0] ) );
endmodule

module bw_clk_gl_vrt3(c7 ,sctag_out ,sctag_in ,c12 );
output [7:0]	c7 ;
output [1:0]	sctag_out ;
input [1:0]	sctag_in ;
input		c12 ;
 
wire [1:0]	c11 ;
wire [3:0]	c8 ;
wire [1:0]	c10 ;
wire [1:0]	c9 ;
 
assign	sctag_out[1] = c9[1] ;
assign	sctag_out[0] = c9[0] ;
assign	c8[2] = sctag_in[1] ;
assign	c8[1] = sctag_in[0] ;
 
bw_clk_gclk_inv_r90_224x xc7_1_ (
     .clkout          (c7[1] ),
     .clkin           (c8[0] ) );
bw_clk_gclk_inv_r90_256x xc10a_0_ (
     .clkout          (c11[0] ),
     .clkin           (c12 ) );
bw_clk_gclk_inv_r90_224x xc7_2_ (
     .clkout          (c7[2] ),
     .clkin           (c8[1] ) );
bw_clk_gclk_inv_r90_192x xc8_0_ (
     .clkout          (c8[0] ),
     .clkin           (c9[0] ) );
bw_clk_gclk_inv_r90_256x xc10a_1_ (
     .clkout          (c11[1] ),
     .clkin           (c12 ) );
bw_clk_gclk_inv_r90_224x xc7_3_ (
     .clkout          (c7[3] ),
     .clkin           (c8[1] ) );
bw_clk_gclk_inv_r90_192x xc10b_0_ (
     .clkout          (c10[0] ),
     .clkin           (c11[0] ) );
bw_clk_gclk_inv_r90_224x xc9_0_ (
     .clkout          (c9[0] ),
     .clkin           (c10[0] ) );
bw_clk_gclk_inv_r90_224x xc7_4_ (
     .clkout          (c7[4] ),
     .clkin           (c8[2] ) );
bw_clk_gclk_inv_r90_192x xc10b_1_ (
     .clkout          (c10[1] ),
     .clkin           (c11[1] ) );
bw_clk_gclk_inv_r90_224x xc9_1_ (
     .clkout          (c9[1] ),
     .clkin           (c10[1] ) );
bw_clk_gclk_inv_r90_224x xc7_5_ (
     .clkout          (c7[5] ),
     .clkin           (c8[2] ) );
bw_clk_gclk_inv_r90_192x xc8_3_ (
     .clkout          (c8[3] ),
     .clkin           (c9[1] ) );
bw_clk_gclk_inv_r90_224x xc7_6_ (
     .clkout          (c7[6] ),
     .clkin           (c8[3] ) );
bw_clk_gclk_inv_r90_224x xc7_7_ (
     .clkout          (c7[7] ),
     .clkin           (c8[3] ) );
bw_clk_gclk_inv_r90_224x xc7_0_ (
     .clkout          (c7[0] ),
     .clkin           (c8[0] ) );
endmodule

module bw_clk_gl_vrt_all(jbus_c12 ,cmp_c12 ,cmp_sctag_out ,cmp_sctag_in
      ,ddr_sctag_in ,ddr_sctag_out ,jbus_sctag_in ,jbus_sctag_out ,
     gclk_jbus ,gclk_cmp ,gclk_ddr ,ddr_c12 );
output [1:0]	cmp_sctag_out ;
output [1:0]	ddr_sctag_out ;
output [1:0]	jbus_sctag_out ;
output [7:0]	gclk_jbus ;
output [7:0]	gclk_cmp ;
output [7:0]	gclk_ddr ;
input [1:0]	cmp_sctag_in ;
input [1:0]	ddr_sctag_in ;
input [1:0]	jbus_sctag_in ;
input		jbus_c12 ;
input		cmp_c12 ;
input		ddr_c12 ;
 
 
 
bw_clk_gl_vrt1 xcmp (
     .sctag_in        ({cmp_sctag_in } ),
     .sctag_out       ({cmp_sctag_out } ),
     .c7              ({gclk_cmp } ),
     .c12             (cmp_c12 ) );
bw_clk_gl_vrt2 x0 (
     .c7              ({gclk_ddr } ),
     .sctag_out       ({ddr_sctag_out } ),
     .sctag_in        ({ddr_sctag_in } ),
     .c12             (ddr_c12 ) );
bw_clk_gl_vrt3 x1 (
     .c7              ({gclk_jbus } ),
     .sctag_out       ({jbus_sctag_out } ),
     .sctag_in        ({jbus_sctag_in } ),
     .c12             (jbus_c12 ) );
endmodule

