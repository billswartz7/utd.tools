// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_gl_hz.v
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
module bw_clk_gl_hz1(col_clk ,center_clk );
output [3:0]	col_clk ;
input		center_clk ;
 
wire [1:0]	c13 ;
wire [1:0]	c14 ;
wire		c15 ;
 
 
bw_clk_gclk_inv_224x x2 (
     .clkout          (c15 ),
     .clkin           (center_clk ) );
bw_clk_gclk_inv_224x x3 (
     .clkout          (col_clk[2] ),
     .clkin           (c13[1] ) );
bw_clk_gclk_inv_192x x4 (
     .clkout          (c13[1] ),
     .clkin           (c14[1] ) );
bw_clk_gclk_inv_224x x5 (
     .clkout          (col_clk[1] ),
     .clkin           (c13[0] ) );
bw_clk_gclk_inv_288x x6 (
     .clkout          (c14[0] ),
     .clkin           (c15 ) );
bw_clk_gclk_inv_224x x7 (
     .clkout          (col_clk[0] ),
     .clkin           (c13[0] ) );
bw_clk_gclk_inv_288x x8 (
     .clkout          (c14[1] ),
     .clkin           (c15 ) );
bw_clk_gclk_inv_224x x0 (
     .clkout          (col_clk[3] ),
     .clkin           (c13[1] ) );
bw_clk_gclk_inv_192x x1 (
     .clkout          (c13[0] ),
     .clkin           (c14[0] ) );
endmodule

module bw_clk_gl_hz(ddr_center ,jbus_center ,cmp_center ,cmp_c11 ,
     jbus_c11 ,ddr_c11 );
output [3:0]	cmp_c11 ;
output [3:0]	jbus_c11 ;
output [3:0]	ddr_c11 ;
input		ddr_center ;
input		jbus_center ;
input		cmp_center ;
 
 
 
bw_clk_gl_hz1 xddr (
     .col_clk         ({ddr_c11 } ),
     .center_clk      (ddr_center ) );
bw_clk_gl_hz1 xjbus (
     .col_clk         ({jbus_c11 } ),
     .center_clk      (jbus_center ) );
bw_clk_gl_hz1 xcmp (
     .col_clk         ({cmp_c11 } ),
     .center_clk      (cmp_center ) );
endmodule

