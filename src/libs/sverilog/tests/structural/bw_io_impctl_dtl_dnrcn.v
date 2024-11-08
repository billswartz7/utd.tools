// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_dtl_dnrcn.v
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
module bw_io_impctl_dtl_dnrcn(above ,global_reset_n ,cbd ,sclk ,se ,vddo
      ,si_l ,pad ,clk ,so_l );
input [8:1]	cbd ;
output		above ;
output		pad ;
output		so_l ;
input		global_reset_n ;
input		sclk ;
input		se ;
input		vddo ;
input		si_l ;
input		clk ;
supply1		vdd ;
supply0		vss ;
 
wire		net102 ;
wire		net103 ;
wire		net104 ;
wire		net105 ;
wire		net106 ;
wire		net71 ;
wire		net73 ;
wire		net111 ;
wire		sclk1 ;
wire		sclk2 ;
wire		net115 ;
wire		srcv ;
wire		bsr_dn_l ;
wire		si ;
wire		scan1 ;
wire		net95 ;
wire		bsr_dn25_l ;
wire		net064 ;
wire		bsr_up ;
wire		net56 ;
wire		net57 ;
wire		abvref ;
wire		net65 ;
wire		net68 ;
wire		net101 ;
 
 
bw_io_dtl_drv_zctl I227 (
     .cbu             ({vss ,vss ,vss ,vss ,vss ,vss ,vss ,vss } ),
     .cbd             ({cbd } ),
     .pad             (pad ),
     .sel_data_n      (vss ),
     .pad_up          (net111 ),
     .pad_dn_l        (net101 ),
     .pad_dn25_l      (net102 ),
     .por             (net115 ),
     .bsr_up          (bsr_up ),
     .bsr_dn_l        (bsr_dn_l ),
     .bsr_dn25_l      (bsr_dn25_l ),
     .vddo            (vddo ) );
bw_io_dtlhstl_rcv I1 (
     .out             (abvref ),
     .so              (srcv ),
     .pad             (net95 ),
     .ref             (net064 ),
     .clk             (clk ),
     .pad_clk_en_l    (net103 ),
     .cmsi_clk_en_l   (net104 ),
     .cmsi_l          (net105 ),
     .se_buf          (net106 ),
     .vddo            (vddo ) );
bw_u1_soff_4x I257 (
     .q               (sclk1 ),
     .so              (net56 ),
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
     .sd              (net56 ),
     .r_l             (global_reset_n ) );
bw_u1_soffr_4x I263 (
     .q               (above ),
     .so              (net57 ),
     .ck              (clk ),
     .d               (net71 ),
     .se              (se ),
     .sd              (scan1 ),
     .r_l             (global_reset_n ) );
bw_u1_inv_4x I268 (
     .z               (net73 ),
     .a               (sclk2 ) );
bw_u1_nand2_4x I269 (
     .z               (net71 ),
     .a               (net65 ),
     .b               (net68 ) );
bw_u1_nand2_4x I270 (
     .z               (net68 ),
     .a               (net73 ),
     .b               (above ) );
bw_u1_nand2_4x I271 (
     .z               (net65 ),
     .a               (abvref ),
     .b               (sclk2 ) );
bw_u1_inv_4x I304 (
     .z               (si ),
     .a               (si_l ) );
bw_u1_inv_4x I305 (
     .z               (so_l ),
     .a               (net57 ) );
bw_io_dtl_edgelogic I306 (
     .pad_clk_en_l    (net103 ),
     .cmsi_clk_en_l   (net104 ),
     .bsr_dn25_l      (bsr_dn25_l ),
     .pad_dn_l        (net101 ),
     .pad_dn25_l      (net102 ),
     .bsr_up          (bsr_up ),
     .bsr_mode        (vss ),
     .bsr_data_to_core (vss ),
     .por_l           (vdd ),
     .bsr_dn_l        (bsr_dn_l ),
     .se_buf          (net106 ),
     .cmsi_l          (net105 ),
     .por             (net115 ),
     .reset_l         (vdd ),
     .sel_bypass      (vss ),
     .up_open         (vss ),
     .oe              (vdd ),
     .down_25         (vss ),
     .clk             (clk ),
     .data            (vss ),
     .se              (se ),
     .si              (si ),
     .pad_up          (net111 ) );
bw_io_ic_filter I310 (
     .torcvr          (net95 ),
     .topad           (pad ),
     .vddo            (vddo ) );
bw_io_dtl_vref I313 (
     .vref_impctl     (net064 ),
     .vddo            (vddo ) );
endmodule
