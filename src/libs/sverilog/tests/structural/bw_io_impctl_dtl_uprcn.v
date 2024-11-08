// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_dtl_uprcn.v
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
module bw_io_impctl_dtl_uprcn(si_l ,so_l ,pad ,sclk ,vddo ,cbu ,above ,
     clk ,se ,global_reset_n );
input [8:1]	cbu ;
output		so_l ;
output		pad ;
output		above ;
input		si_l ;
input		sclk ;
input		vddo ;
input		clk ;
input		se ;
input		global_reset_n ;
supply1		vdd ;
supply0		vss ;
 
wire		net093 ;
wire		net0103 ;
wire		sclk1 ;
wire		sclk2 ;
wire		srcv ;
wire		net0153 ;
wire		bsr_dn_l ;
wire		si ;
wire		scan1 ;
wire		net0130 ;
wire		net0135 ;
wire		net0139 ;
wire		net051 ;
wire		net056 ;
wire		net059 ;
wire		net062 ;
wire		bsr_dn25_l ;
wire		net067 ;
wire		bsr_up ;
wire		net073 ;
wire		net0125 ;
wire		net0126 ;
wire		net0127 ;
wire		net0129 ;
wire		abvref ;
 
 
bw_io_dtl_drv_zctl I227 (
     .cbu             ({cbu } ),
     .cbd             ({vss ,vss ,vss ,vss ,vss ,vss ,vss ,vss } ),
     .pad             (pad ),
     .sel_data_n      (vss ),
     .pad_up          (net0135 ),
     .pad_dn_l        (net0125 ),
     .pad_dn25_l      (net0126 ),
     .por             (net0139 ),
     .bsr_up          (bsr_up ),
     .bsr_dn_l        (bsr_dn_l ),
     .bsr_dn25_l      (bsr_dn25_l ),
     .vddo            (vddo ) );
bw_io_dtlhstl_rcv I1 (
     .out             (abvref ),
     .so              (srcv ),
     .pad             (net0103 ),
     .ref             (net067 ),
     .clk             (clk ),
     .pad_clk_en_l    (net0127 ),
     .cmsi_clk_en_l   (net0153 ),
     .cmsi_l          (net0129 ),
     .se_buf          (net0130 ),
     .vddo            (vddo ) );
bw_u1_soff_4x I257 (
     .q               (sclk1 ),
     .so              (net093 ),
     .ck              (clk ),
     .d               (sclk ),
     .se              (se ),
     .sd              (srcv ) );
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
     .so              (net073 ),
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
bw_u1_inv_4x I304 (
     .z               (si ),
     .a               (si_l ) );
bw_u1_inv_4x I305 (
     .z               (so_l ),
     .a               (net073 ) );
bw_io_dtl_edgelogic I306 (
     .pad_clk_en_l    (net0127 ),
     .cmsi_clk_en_l   (net0153 ),
     .bsr_dn25_l      (bsr_dn25_l ),
     .pad_dn_l        (net0125 ),
     .pad_dn25_l      (net0126 ),
     .bsr_up          (bsr_up ),
     .bsr_mode        (vss ),
     .bsr_data_to_core (vss ),
     .por_l           (vdd ),
     .bsr_dn_l        (bsr_dn_l ),
     .se_buf          (net0130 ),
     .cmsi_l          (net0129 ),
     .por             (net0139 ),
     .reset_l         (vdd ),
     .sel_bypass      (vss ),
     .up_open         (vss ),
     .oe              (vdd ),
     .down_25         (vss ),
     .clk             (clk ),
     .data            (vdd ),
     .se              (se ),
     .si              (si ),
     .pad_up          (net0135 ) );
bw_io_ic_filter I310 (
     .torcvr          (net0103 ),
     .topad           (pad ),
     .vddo            (vddo ) );
bw_io_dtl_vref I313 (
     .vref_impctl     (net067 ),
     .vddo            (vddo ) );
endmodule
