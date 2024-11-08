// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_bscl2.v
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
module bw_io_dtl_bscl2(scan_mode ,mode_ctl ,out_type ,rst_val_dn ,
     bscan_oe ,sel_data_n ,q25_dn_mux_l ,down_25 ,rst_io_l ,ps_select ,
     q_dn_mux_l ,up_open ,bscan_d ,hiz_l ,q_up_mux ,ps_data ,rst_val_up
      );
output		sel_data_n ;
output		q25_dn_mux_l ;
output		q_dn_mux_l ;
output		q_up_mux ;
input		scan_mode ;
input		mode_ctl ;
input		out_type ;
input		rst_val_dn ;
input		bscan_oe ;
input		down_25 ;
input		rst_io_l ;
input		ps_select ;
input		up_open ;
input		bscan_d ;
input		hiz_l ;
input		ps_data ;
input		rst_val_up ;
supply1		vdd ;
 
wire		net186 ;
wire		net106 ;
wire		net188 ;
wire		q_up_log2 ;
wire		uo_n ;
wire		net191 ;
wire		net194 ;
wire		net197 ;
wire		net118 ;
wire		n1 ;
wire		n2 ;
wire		bsoe ;
wire		rmd ;
wire		q_dn_log2 ;
wire		bsoe_n ;
wire		rmd25 ;
wire		net136 ;
wire		q25_dn_log2 ;
wire		rmu ;
wire		a1b ;
wire		bsd_n ;
wire		net149 ;
wire		rin_n ;
wire		net153 ;
wire		net157 ;
wire		n1b ;
wire		net163 ;
wire		net166 ;
wire		bsd ;
wire		hiz ;
wire		net178 ;
wire		hz_n ;
wire		net182 ;
 
 
bw_u1_inv_8x I63 (
     .z               (sel_data_n ),
     .a               (net118 ) );
bw_u1_inv_1x inv1x_rst (
     .z               (rin_n ),
     .a               (rst_io_l ) );
bw_u1_inv_3x I64 (
     .z               (net118 ),
     .a               (net163 ) );
bw_u1_nor2_1x I66 (
     .z               (net194 ),
     .a               (rin_n ),
     .b               (mode_ctl ) );
bw_u1_nor2_1x I67 (
     .z               (net197 ),
     .a               (ps_select ),
     .b               (scan_mode ) );
bw_u1_muxi21_1x rst_mux_dn (
     .z               (net149 ),
     .d0              (q_dn_log2 ),
     .d1              (rst_val_dn ),
     .s               (net191 ) );
bw_u1_inv_4x inv2x_bmc (
     .z               (net188 ),
     .a               (net136 ) );
bw_u1_inv_2x oe_inv2x (
     .z               (bsoe_n ),
     .a               (bscan_oe ) );
bw_u1_inv_2x boe_inv2x (
     .z               (bsoe ),
     .a               (bsoe_n ) );
bw_u1_inv_1x hiz_inv1x (
     .z               (hiz ),
     .a               (hiz_l ) );
bw_u1_nor2_2x nor2_rst (
     .z               (net191 ),
     .a               (mode_ctl ),
     .b               (rst_io_l ) );
bw_u1_inv_8x inv8x_1 (
     .z               (q_up_mux ),
     .a               (net178 ) );
bw_u1_inv_8x inv8x_2 (
     .z               (q_dn_mux_l ),
     .a               (net186 ) );
bw_u1_inv_8x inv8x_3 (
     .z               (q25_dn_mux_l ),
     .a               (net182 ) );
bw_u1_nand2_1x nand2_bmc (
     .z               (net163 ),
     .a               (net194 ),
     .b               (net197 ) );
bw_u1_muxi21_2x scn_mx_up (
     .z               (net178 ),
     .d0              (rmu ),
     .d1              (a1b ),
     .s               (net188 ) );
bw_u1_muxi21_2x scn_mx_dn25 (
     .z               (net182 ),
     .d0              (rmd25 ),
     .d1              (vdd ),
     .s               (net188 ) );
bw_u1_inv_1x pd_inv1x (
     .z               (net106 ),
     .a               (ps_data ) );
bw_u1_inv_1x open_inv1x (
     .z               (uo_n ),
     .a               (up_open ) );
bw_u1_inv_3x hiz_inv3x (
     .z               (hz_n ),
     .a               (hiz ) );
bw_u1_inv_1x inv1x_1 (
     .z               (rmu ),
     .a               (net153 ) );
bw_u1_inv_1x inv1x_2 (
     .z               (rmd ),
     .a               (net149 ) );
bw_u1_inv_1x inv1x_3 (
     .z               (rmd25 ),
     .a               (net157 ) );
bw_u1_nand2_1x nand2_pd (
     .z               (n1b ),
     .a               (out_type ),
     .b               (net106 ) );
bw_u1_inv_1x bs_inv1x (
     .z               (bsd ),
     .a               (bsd_n ) );
bw_u1_muxi21_2x scn_mx_dn (
     .z               (net186 ),
     .d0              (rmd ),
     .d1              (n1b ),
     .s               (net188 ) );
bw_u1_inv_1x qup_inv1x (
     .z               (a1b ),
     .a               (net166 ) );
bw_u1_muxi21_1x rst_mux_up (
     .z               (net153 ),
     .d0              (q_up_log2 ),
     .d1              (rst_val_up ),
     .s               (net191 ) );
bw_u1_nand2_2x nand2_1 (
     .z               (q_up_log2 ),
     .a               (n1 ),
     .b               (n2 ) );
bw_u1_nand3_1x nand3_1 (
     .z               (n1 ),
     .a               (hz_n ),
     .b               (bsoe ),
     .c               (bsd ) );
bw_u1_nand2_1x nand2_4 (
     .z               (net166 ),
     .a               (ps_data ),
     .b               (out_type ) );
bw_u1_nand2_2x nand2_sm (
     .z               (net136 ),
     .a               (ps_select ),
     .b               (scan_mode ) );
bw_u1_nand3_1x nand3_2 (
     .z               (n2 ),
     .a               (hz_n ),
     .b               (bsoe_n ),
     .c               (uo_n ) );
bw_u1_nand4_2x nand4_1 (
     .z               (q25_dn_log2 ),
     .a               (hz_n ),
     .b               (bsoe ),
     .c               (bsd_n ),
     .d               (down_25 ) );
bw_u1_nand3_2x nand3_3 (
     .z               (q_dn_log2 ),
     .a               (hz_n ),
     .b               (bsoe ),
     .c               (bsd_n ) );
bw_u1_muxi21_1x rst_mux_dn25 (
     .z               (net157 ),
     .d0              (q25_dn_log2 ),
     .d1              (rst_val_dn ),
     .s               (net191 ) );
bw_u1_inv_3x bs_inv3x (
     .z               (bsd_n ),
     .a               (bscan_d ) );
endmodule

