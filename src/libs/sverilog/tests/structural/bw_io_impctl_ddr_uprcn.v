// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_ddr_uprcn.v
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
module bw_io_impctl_ddr_uprcn(oe ,vdd18 ,si_l ,so_l ,pad ,sclk ,cbu ,
     above ,clk ,se ,global_reset_n );
input [8:1]	cbu ;
output		so_l ;
output		pad ;
output		above ;
input		oe ;
input		vdd18 ;
input		si_l ;
input		sclk ;
input		clk ;
input		se ;
input		global_reset_n ;
supply1		vdd ;
supply0		vss ;
 
wire		net76 ;
wire		net77 ;
wire		sclk1 ;
wire		sclk2 ;
wire		scan1 ;
wire		vf ;
wire		net55 ;
wire		net59 ;
wire		net62 ;
wire		abvref ;
wire		net65 ;
wire		net68 ;
 
 
bw_u1_soff_4x I257 (
     .q               (sclk1 ),
     .so              (net76 ),
     .ck              (clk ),
     .d               (sclk ),
     .se              (se ),
     .sd              (net55 ) );
bw_u1_soffr_4x I260 (
     .q               (sclk2 ),
     .so              (scan1 ),
     .ck              (clk ),
     .d               (sclk1 ),
     .se              (se ),
     .sd              (net76 ),
     .r_l             (global_reset_n ) );
bw_u1_soffr_4x I263 (
     .q               (above ),
     .so              (net77 ),
     .ck              (clk ),
     .d               (net62 ),
     .se              (se ),
     .sd              (scan1 ),
     .r_l             (global_reset_n ) );
bw_u1_inv_4x I268 (
     .z               (net59 ),
     .a               (sclk2 ) );
bw_u1_nand2_4x I269 (
     .z               (net62 ),
     .a               (net68 ),
     .b               (net65 ) );
bw_u1_nand2_4x I270 (
     .z               (net65 ),
     .a               (net59 ),
     .b               (above ) );
bw_u1_nand2_4x I271 (
     .z               (net68 ),
     .a               (abvref ),
     .b               (sclk2 ) );
bw_u1_inv_4x I304 (
     .z               (net55 ),
     .a               (si_l ) );
bw_u1_inv_4x I305 (
     .z               (so_l ),
     .a               (net77 ) );
bw_io_ddr_pad_txrx_zctl I309 (
     .vrefcode        ({{4 {vf }} ,vss ,vss ,vss ,vss } ),
     .cbu             ({cbu } ),
     .cbd             ({vss ,vss ,vss ,vss ,vss ,vss ,vss ,vss } ),
     .out             (abvref ),
     .pad             (pad ),
     .vdd_h           (vdd18 ),
     .data            (vdd ),
     .oe              (oe ),
     .odt_enable      (vss ) );
bw_io_ddr_rptr_vddcom I319 (
     .vdd18           (vdd18 ),
     .vdd_com         (vf ) );
endmodule

