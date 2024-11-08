// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_gl.v
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
module bw_clk_gl(gclk_jbus_c0_r ,clk_fdbk_in ,clk_fdbk_out ,
     gclk_cmp_c3_r ,gclk_ddr_c3_r ,gclk_jbus_c2_r ,gclk_cmp_c2_r ,
     gclk_ddr_c2_r ,gclk_jbus_c1_r ,gclk_cmp_c1_r ,gclk_ddr_c1_r ,
     gclk_cmp_c0_r ,gclk_jbus ,gclk_ddr ,gclk_cmp ,gclk_jbus_c3_r ,
     gclk_ddr_c0_r );
output [7:0]	gclk_jbus_c0_r ;
output [7:0]	gclk_cmp_c3_r ;
output [7:0]	gclk_ddr_c3_r ;
output [7:0]	gclk_jbus_c2_r ;
output [7:0]	gclk_cmp_c2_r ;
output [7:0]	gclk_ddr_c2_r ;
output [7:0]	gclk_jbus_c1_r ;
output [7:0]	gclk_cmp_c1_r ;
output [7:0]	gclk_ddr_c1_r ;
output [7:0]	gclk_cmp_c0_r ;
output [7:0]	gclk_jbus_c3_r ;
output [7:0]	gclk_ddr_c0_r ;
output		clk_fdbk_out ;
input		clk_fdbk_in ;
input		gclk_jbus ;
input		gclk_ddr ;
input		gclk_cmp ;
 
wire [2:1]	ddr_col1_c8 ;
wire [2:1]	cmp_col3_c9 ;
wire [3:0]	cmp_c11 ;
wire [2:1]	ddr_col2_c9 ;
wire [2:1]	ddr_col0_c8 ;
wire [2:1]	cmp_col0_c8 ;
wire [2:1]	ddr_col1_c9 ;
wire [2:1]	cmp_col1_c8 ;
wire [2:1]	jbus_col3_c8 ;
wire [2:1]	ddr_col0_c9 ;
wire [2:1]	cmp_col2_c8 ;
wire [3:0]	ddr_c11 ;
wire [2:1]	ddr_col3_c8 ;
wire [2:1]	cmp_col0_c9 ;
wire [3:0]	jbus_c11 ;
wire [2:1]	cmp_col1_c9 ;
wire [2:1]	jbus_col3_c9 ;
wire [2:1]	cmp_col2_c9 ;
wire [2:1]	jbus_col0_c8 ;
wire [2:1]	ddr_col3_c9 ;
wire [2:1]	jbus_col1_c8 ;
wire [2:1]	jbus_col2_c8 ;
wire [2:1]	jbus_col0_c9 ;
wire [2:1]	cmp_col3_c8 ;
wire [2:1]	jbus_col1_c9 ;
wire [2:1]	ddr_col2_c8 ;
wire [2:1]	jbus_col2_c9 ;
wire		jbus_center ;
wire		cmp_center ;
wire		fdbk_center ;
wire		ddr_center ;
 
 
bw_clk_gclk_inv_224x x3 (
     .clkout          (fdbk_center ),
     .clkin           (clk_fdbk_in ) );
bw_clk_gclk_sctag_3inv xc2_sctag_0_ (
     .jbus_out        (jbus_col2_c8[1] ),
     .ddr_out         (ddr_col2_c8[1] ),
     .cmp_out         (cmp_col2_c8[1] ),
     .jbus_in         (jbus_col2_c9[1] ),
     .ddr_in          (ddr_col2_c9[1] ),
     .cmp_in          (cmp_col2_c9[1] ) );
bw_clk_gl_vrt_all xcol_0_ (
     .cmp_sctag_out   ({cmp_col0_c9 } ),
     .cmp_sctag_in    ({cmp_col0_c8 } ),
     .ddr_sctag_in    ({ddr_col0_c8 } ),
     .ddr_sctag_out   ({ddr_col0_c9 } ),
     .jbus_sctag_in   ({jbus_col0_c8 } ),
     .jbus_sctag_out  ({jbus_col0_c9 } ),
     .gclk_jbus       ({gclk_jbus_c0_r } ),
     .gclk_cmp        ({gclk_cmp_c0_r } ),
     .gclk_ddr        ({gclk_ddr_c0_r } ),
     .jbus_c12        (jbus_c11[0] ),
     .cmp_c12         (cmp_c11[0] ),
     .ddr_c12         (ddr_c11[0] ) );
bw_clk_gclk_sctag_3inv xc1_sctag_1_ (
     .jbus_out        (jbus_col1_c8[2] ),
     .ddr_out         (ddr_col1_c8[2] ),
     .cmp_out         (cmp_col1_c8[2] ),
     .jbus_in         (jbus_col1_c9[2] ),
     .ddr_in          (ddr_col1_c9[2] ),
     .cmp_in          (cmp_col1_c9[2] ) );
bw_clk_gclk_sctag_3inv xc3_sctag_0_ (
     .jbus_out        (jbus_col3_c8[1] ),
     .ddr_out         (ddr_col3_c8[1] ),
     .cmp_out         (cmp_col3_c8[1] ),
     .jbus_in         (jbus_col3_c9[1] ),
     .ddr_in          (ddr_col3_c9[1] ),
     .cmp_in          (cmp_col3_c9[1] ) );
bw_clk_gclk_sctag_3inv xc2_sctag_1_ (
     .jbus_out        (jbus_col2_c8[2] ),
     .ddr_out         (ddr_col2_c8[2] ),
     .cmp_out         (cmp_col2_c8[2] ),
     .jbus_in         (jbus_col2_c9[2] ),
     .ddr_in          (ddr_col2_c9[2] ),
     .cmp_in          (cmp_col2_c9[2] ) );
bw_clk_gclk_center_3inv xcenter (
     .jbus_out        (jbus_center ),
     .ddr_out         (ddr_center ),
     .cmp_out         (cmp_center ),
     .jbus_in         (gclk_jbus ),
     .ddr_in          (gclk_ddr ),
     .cmp_in          (gclk_cmp ) );
bw_clk_gl_vrt_all xcol_3_ (
     .cmp_sctag_out   ({cmp_col3_c9 } ),
     .cmp_sctag_in    ({cmp_col3_c8 } ),
     .ddr_sctag_in    ({ddr_col3_c8 } ),
     .ddr_sctag_out   ({ddr_col3_c9 } ),
     .jbus_sctag_in   ({jbus_col3_c8 } ),
     .jbus_sctag_out  ({jbus_col3_c9 } ),
     .gclk_jbus       ({gclk_jbus_c3_r } ),
     .gclk_cmp        ({gclk_cmp_c3_r } ),
     .gclk_ddr        ({gclk_ddr_c3_r } ),
     .jbus_c12        (jbus_c11[3] ),
     .cmp_c12         (cmp_c11[3] ),
     .ddr_c12         (ddr_c11[3] ) );
bw_clk_gclk_sctag_3inv xc0_sctag_0_ (
     .jbus_out        (jbus_col0_c8[1] ),
     .ddr_out         (ddr_col0_c8[1] ),
     .cmp_out         (cmp_col0_c8[1] ),
     .jbus_in         (jbus_col0_c9[1] ),
     .ddr_in          (ddr_col0_c9[1] ),
     .cmp_in          (cmp_col0_c9[1] ) );
bw_clk_gclk_sctag_3inv xc3_sctag_1_ (
     .jbus_out        (jbus_col3_c8[2] ),
     .ddr_out         (ddr_col3_c8[2] ),
     .cmp_out         (cmp_col3_c8[2] ),
     .jbus_in         (jbus_col3_c9[2] ),
     .ddr_in          (ddr_col3_c9[2] ),
     .cmp_in          (cmp_col3_c9[2] ) );
bw_clk_gl_fdbk xfdbk (
     .clk_fdbk_in     (fdbk_center ),
     .clk_fdbk_out    (clk_fdbk_out ) );
bw_clk_gl_vrt_all xcol_1_ (
     .cmp_sctag_out   ({cmp_col1_c9 } ),
     .cmp_sctag_in    ({cmp_col1_c8 } ),
     .ddr_sctag_in    ({ddr_col1_c8 } ),
     .ddr_sctag_out   ({ddr_col1_c9 } ),
     .jbus_sctag_in   ({jbus_col1_c8 } ),
     .jbus_sctag_out  ({jbus_col1_c9 } ),
     .gclk_jbus       ({gclk_jbus_c1_r } ),
     .gclk_cmp        ({gclk_cmp_c1_r } ),
     .gclk_ddr        ({gclk_ddr_c1_r } ),
     .jbus_c12        (jbus_c11[1] ),
     .cmp_c12         (cmp_c11[1] ),
     .ddr_c12         (ddr_c11[1] ) );
bw_clk_gclk_sctag_3inv xc1_sctag_0_ (
     .jbus_out        (jbus_col1_c8[1] ),
     .ddr_out         (ddr_col1_c8[1] ),
     .cmp_out         (cmp_col1_c8[1] ),
     .jbus_in         (jbus_col1_c9[1] ),
     .ddr_in          (ddr_col1_c9[1] ),
     .cmp_in          (cmp_col1_c9[1] ) );
bw_clk_gl_hz xrow (
     .cmp_c11         ({cmp_c11 } ),
     .jbus_c11        ({jbus_c11 } ),
     .ddr_c11         ({ddr_c11 } ),
     .ddr_center      (ddr_center ),
     .jbus_center     (jbus_center ),
     .cmp_center      (cmp_center ) );
bw_clk_gl_vrt_all xcol_2_ (
     .cmp_sctag_out   ({cmp_col2_c9 } ),
     .cmp_sctag_in    ({cmp_col2_c8 } ),
     .ddr_sctag_in    ({ddr_col2_c8 } ),
     .ddr_sctag_out   ({ddr_col2_c9 } ),
     .jbus_sctag_in   ({jbus_col2_c8 } ),
     .jbus_sctag_out  ({jbus_col2_c9 } ),
     .gclk_jbus       ({gclk_jbus_c2_r } ),
     .gclk_cmp        ({gclk_cmp_c2_r } ),
     .gclk_ddr        ({gclk_ddr_c2_r } ),
     .jbus_c12        (jbus_c11[2] ),
     .cmp_c12         (cmp_c11[2] ),
     .ddr_c12         (ddr_c11[2] ) );
bw_clk_gclk_sctag_3inv xc0_sctag_1_ (
     .jbus_out        (jbus_col0_c8[2] ),
     .ddr_out         (ddr_col0_c8[2] ),
     .cmp_out         (cmp_col0_c8[2] ),
     .jbus_in         (jbus_col0_c9[2] ),
     .ddr_in          (ddr_col0_c9[2] ),
     .cmp_in          (cmp_col0_c9[2] ) );
endmodule

