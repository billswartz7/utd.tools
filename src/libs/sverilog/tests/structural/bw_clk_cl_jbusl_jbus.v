// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_cl_jbusl_jbus.v
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
module bw_clk_cl_jbusl_jbus(cluster_grst_l ,so ,dbginit_l ,si ,se ,
     adbginit_l ,gdbginit_l ,arst_l ,grst_l ,cluster_cken ,gclk ,rclk );
output		cluster_grst_l ;
output		so ;
output		dbginit_l ;
output		rclk ;
input		si ;
input		se ;
input		adbginit_l ;
input		gdbginit_l ;
input		arst_l ;
input		grst_l ;
input		cluster_cken ;
input		gclk ;
 
wire [3:0]	noclk ;
wire [2:0]	clk3 ;
wire [1:0]	clk4 ;
wire		clk5 ;
wire		cclk ;
 
 
bw_clk_cclk_inv_64x xc3a (
     .clkout          (clk3[0] ),
     .clkin           (clk4[0] ) );
bw_clk_cclk_inv_64x xc3b (
     .clkout          (clk3[1] ),
     .clkin           (clk4[0] ) );
bw_clk_cclk_inv_128x xgriddrv_3_ (
     .clkout          (rclk ),
     .clkin           (clk3[0] ) );
bw_clk_cclk_inv_128x xgriddrv_11_ (
     .clkout          (noclk[2] ),
     .clkin           (clk3[2] ) );
bw_clk_cclk_inv_64x xc4a (
     .clkout          (clk4[0] ),
     .clkin           (clk5 ) );
bw_clk_cclk_inv_64x xc4b (
     .clkout          (clk4[1] ),
     .clkin           (clk5 ) );
bw_clk_cclk_inv_128x xgriddrv_2_ (
     .clkout          (rclk ),
     .clkin           (clk3[0] ) );
bw_clk_cclk_hdr_48x xCCHdr (
     .rst_l           (cluster_grst_l ),
     .dbginit_l       (dbginit_l ),
     .clk             (cclk ),
     .so              (so ),
     .gclk            (gclk ),
     .cluster_cken    (cluster_cken ),
     .arst_l          (arst_l ),
     .grst_l          (grst_l ),
     .adbginit_l      (adbginit_l ),
     .gdbginit_l      (gdbginit_l ),
     .si              (si ),
     .se              (se ),
     .rclk            (rclk ) );
bw_clk_cclk_inv_128x xgriddrv_9_ (
     .clkout          (noclk[0] ),
     .clkin           (clk3[2] ) );
bw_clk_cclk_inv_128x xgriddrv_1_ (
     .clkout          (rclk ),
     .clkin           (clk3[0] ) );
terminator I26_0_ (
     .TERM            (noclk[0] ) );
bw_clk_cclk_inv_128x xgriddrv_8_ (
     .clkout          (rclk ),
     .clkin           (clk3[2] ) );
bw_clk_cclk_inv_128x xgriddrv_0_ (
     .clkout          (rclk ),
     .clkin           (clk3[0] ) );
bw_clk_cclk_inv_128x xgriddrv_10_ (
     .clkout          (noclk[1] ),
     .clkin           (clk3[2] ) );
bw_clk_cclk_inv_48x xc5 (
     .clkout          (clk5 ),
     .clkin           (cclk ) );
terminator I26_1_ (
     .TERM            (noclk[1] ) );
bw_clk_cclk_inv_128x xgriddrv_7_ (
     .clkout          (rclk ),
     .clkin           (clk3[1] ) );
terminator I25 (
     .TERM            (noclk[3] ) );
terminator I26_2_ (
     .TERM            (noclk[2] ) );
bw_clk_cclk_inv_128x xgriddrv_6_ (
     .clkout          (rclk ),
     .clkin           (clk3[1] ) );
bw_clk_cclk_inv_128x xgriddrv_5_ (
     .clkout          (rclk ),
     .clkin           (clk3[1] ) );
bw_clk_cclk_inv_128x xgriddrv_4_ (
     .clkout          (rclk ),
     .clkin           (clk3[1] ) );
bw_clk_cclk_inv_64x x0 (
     .clkout          (clk3[2] ),
     .clkin           (clk4[1] ) );
bw_clk_cclk_inv_64x x1 (
     .clkout          (noclk[3] ),
     .clkin           (clk4[1] ) );
endmodule
