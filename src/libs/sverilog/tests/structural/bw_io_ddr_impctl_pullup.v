// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_impctl_pullup.v
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
module bw_io_ddr_impctl_pullup(rclk ,so ,z ,deltabit ,hard_reset_n ,
     clk_dis_l ,from_csr ,we_csr ,si ,se ,ctu_io_sscan_se ,vdd18 ,
     ctu_io_sscan_in ,ctu_io_sscan_out ,ctu_io_sscan_update ,pad ,to_csr
      ,ctu_global_snap ,tclk );
output [7:0]	z ;
output [7:0]	to_csr ;
input [7:0]	from_csr ;
output		so ;
output		deltabit ;
output		ctu_io_sscan_out ;
input		rclk ;
input		hard_reset_n ;
input		clk_dis_l ;
input		we_csr ;
input		si ;
input		se ;
input		ctu_io_sscan_se ;
input		vdd18 ;
input		ctu_io_sscan_in ;
input		ctu_io_sscan_update ;
input		ctu_global_snap ;
input		tclk ;
inout		pad ;
supply1		vdd ;
 
wire [7:0]	z_post ;
wire [7:0]	d ;
wire [7:0]	net67 ;
wire		clk ;
wire		net086 ;
wire		net091 ;
wire		net092 ;
wire		above ;
wire		global_reset_n ;
wire		sodr_l ;
wire		sos_l ;
wire		bypass ;
wire		oe_out ;
wire		net055 ;
wire		updclk ;
wire		clk_en_l ;
wire		sclk ;
wire		avgcntr_rst ;
 
 
bw_u1_inv_4x I28_1_ (
     .z               (net67[6] ),
     .a               (z_post[6] ) );
bw_u1_inv_10x I29_7_ (
     .z               (z[7] ),
     .a               (net67[0] ) );
bw_u1_inv_10x I29_0_ (
     .z               (z[0] ),
     .a               (net67[7] ) );
bw_u1_inv_4x I28_2_ (
     .z               (net67[5] ),
     .a               (z_post[5] ) );
bw_io_impctl_ddr_uprcn I241 (
     .cbu             ({d[0] ,d[1] ,d[2] ,d[3] ,d[4] ,d[5] ,d[6] ,d[7] }
             ),
     .oe              (oe_out ),
     .vdd18           (vdd18 ),
     .si_l            (net091 ),
     .so_l            (sodr_l ),
     .pad             (pad ),
     .sclk            (sclk ),
     .above           (above ),
     .clk             (clk ),
     .se              (se ),
     .global_reset_n  (global_reset_n ) );
bw_u1_inv_10x I29_1_ (
     .z               (z[1] ),
     .a               (net67[6] ) );
bw_u1_inv_4x I28_3_ (
     .z               (net67[4] ),
     .a               (z_post[4] ) );
bw_u1_inv_10x I29_2_ (
     .z               (z[2] ),
     .a               (net67[5] ) );
bw_u1_inv_4x I28_4_ (
     .z               (net67[3] ),
     .a               (z_post[3] ) );
bw_u1_inv_10x I29_3_ (
     .z               (z[3] ),
     .a               (net67[4] ) );
bw_u1_inv_4x I28_5_ (
     .z               (net67[2] ),
     .a               (z_post[2] ) );
bw_io_impctl_smachine_new I23 (
     .z_post          ({z_post } ),
     .from_csr        ({from_csr } ),
     .to_csr          ({to_csr } ),
     .d               ({d } ),
     .deltabit        (deltabit ),
     .ctu_io_sscan_se (ctu_io_sscan_se ),
     .updclk          (updclk ),
     .we_csr          (we_csr ),
     .l2clk           (rclk ),
     .ctu_io_sscan_in (ctu_io_sscan_in ),
     .above           (above ),
     .bypass          (bypass ),
     .config_pmos     (vdd ),
     .global_reset_n  (global_reset_n ),
     .hard_reset_n    (hard_reset_n ),
     .ctu_global_snap (ctu_global_snap ),
     .sclk            (sclk ),
     .avgcntr_rst     (avgcntr_rst ),
     .so              (net055 ),
     .se              (se ),
     .si_l            (sodr_l ),
     .io_ctu_sscan_out (ctu_io_sscan_out ),
     .tclk            (tclk ),
     .ctu_io_sscan_update (ctu_io_sscan_update ),
     .clk_en_l        (clk_en_l ) );
bw_io_impctl_clkgen I24 (
     .se              (se ),
     .oe_out          (oe_out ),
     .updclk          (updclk ),
     .so_l            (net086 ),
     .si_l            (sos_l ),
     .clk            (clk ),        ///changed from rclk
     .synced_upd_imped (ctu_io_sscan_update ),
     .bypass          (bypass ),
     .global_reset_n  (global_reset_n ),
     .hard_reset_n    (hard_reset_n ),
     .sclk            (sclk ),
     .reset_l         (vdd ),
     .avgcntr_rst     (avgcntr_rst ) );
bw_u1_inv_10x I29_4_ (
     .z               (z[4] ),
     .a               (net67[3] ) );
bw_u1_inv_4x I28_6_ (
     .z               (net67[1] ),
     .a               (z_post[1] ) );
bw_u1_ckenbuf_6x I30 (
     .clk             (clk ),
     .rclk            (rclk ),
     .en_l            (clk_en_l ),
     .tm_l            (net092 ) );
bw_u1_inv_4x I33 (
     .z               (so ),
     .a               (net086 ) );
bw_u1_inv_4x I34 (
     .z               (net091 ),
     .a               (si ) );
bw_u1_inv_4x I36 (
     .z               (sos_l ),
     .a               (net055 ) );
bw_u1_inv_10x I29_5_ (
     .z               (z[5] ),
     .a               (net67[2] ) );
bw_u1_inv_4x I28_7_ (
     .z               (net67[0] ),
     .a               (z_post[0] ) );
bw_u1_inv_10x I46 (
     .z               (clk_en_l ),
     .a               (clk_dis_l ) );
bw_u1_inv_4x I48 (
     .z               (net092 ),
     .a               (se ) );
bw_u1_inv_4x I28_0_ (
     .z               (net67[7] ),
     .a               (z_post[7] ) );
bw_u1_inv_10x I29_6_ (
     .z               (z[6] ),
     .a               (net67[1] ) );
endmodule


