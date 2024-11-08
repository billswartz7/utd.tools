// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_ddr_dnrcn.v
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
module bw_io_impctl_ddr_dnrcn(si ,vdd18 ,cbd ,so ,pad ,sclk ,oe ,above ,
     clk ,se ,global_reset_n );
input [8:1]	cbd ;
output		so ;
output		pad ;
output		above ;
input		si ;
input		vdd18 ;
input		sclk ;
input		oe ;
input		clk ;
input		se ;
input		global_reset_n ;
supply0		vss ;
 
wire		net093 ;
wire		sclk1 ;
wire		sclk2 ;
wire		scan1 ;
wire		net051 ;
wire		net056 ;
wire		net059 ;
wire		vf ;
wire		net062 ;
wire		abvref ;
 
 
bw_u1_soff_4x I257 (
     .q               (sclk1 ),
     .so              (net093 ),
     .ck              (clk ),
     .d               (sclk ),
     .se              (se ),
     .sd              (si ) );
bw_u1_soffr_4x I260 (
     .q               (sclk2 ),
     .so              (scan1 ),
     .ck              (clk ),
     .d               (sclk1 ),
     .se              (se ),
     .sd              (net093 ),
     .r_l             (global_reset_n ) );
bw_u1_soffr_4x I263 (
     .q               (above ),
     .so              (so ),
     .ck              (clk ),
     .d               (net062 ),
     .se              (se ),
     .sd              (scan1 ),
     .r_l             (global_reset_n ) );
bw_u1_inv_4x I268 (
     .z               (net051 ),
     .a               (sclk2 ) );
bw_u1_nand2_4x I269 (
     .z               (net062 ),
     .a               (net056 ),
     .b               (net059 ) );
bw_u1_nand2_4x I270 (
     .z               (net059 ),
     .a               (net051 ),
     .b               (above ) );
bw_u1_nand2_4x I271 (
     .z               (net056 ),
     .a               (abvref ),
     .b               (sclk2 ) );
bw_io_ddr_pad_txrx_zctl I304 (
     .vrefcode        ({{4 {vf }} ,vss ,vss ,vss ,vss } ),
     .cbu             ({vss ,vss ,vss ,vss ,vss ,vss ,vss ,vss } ),
     .cbd             ({cbd } ),
     .out             (abvref ),
     .pad             (pad ),
     .vdd_h           (vdd18 ),
     .data            (vss ),
     .oe              (oe ),
     .odt_enable      (vss ) );
bw_io_ddr_rptr_vddcom I319 (
     .vdd18           (vdd18 ),
     .vdd_com         (vf ) );
endmodule

