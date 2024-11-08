// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_smachine_new.v
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
module bw_io_impctl_smachine_new(z_post ,deltabit ,ctu_io_sscan_se ,
     updclk ,we_csr ,l2clk ,ctu_io_sscan_in ,from_csr ,above ,bypass ,
     config_pmos ,global_reset_n ,hard_reset_n ,ctu_global_snap ,sclk ,
     avgcntr_rst ,so ,se ,si_l ,io_ctu_sscan_out ,tclk ,
     ctu_io_sscan_update ,clk_en_l ,to_csr ,d );
output [7:0]    z_post ;
output [7:0]    to_csr ;
output [7:0]    d ;
input [7:0]     from_csr ;
output          deltabit ;
output          so ;
output          io_ctu_sscan_out ;
input           ctu_io_sscan_se ;
input           updclk ;
input           we_csr ;
input           l2clk ;
input           ctu_io_sscan_in ;
input           above ;
input           bypass ;
input           config_pmos ;
input           global_reset_n ;
input           hard_reset_n ;
input           ctu_global_snap ;
input           sclk ;
input           avgcntr_rst ;
input           se ;
input           si_l ;
input           tclk ;
input           ctu_io_sscan_update ;
input           clk_en_l ;

wire [7:0]      sz ;
wire            adv_sgn ;
wire            scan_n ;
wire            freeze ;
wire            se_l ;
wire            l1clk0 ;
wire            l1clk1 ;
wire            l1clk2 ;
wire            so_l ;
wire            net064 ;
wire            net066 ;
wire            net068 ;
wire            net58 ;
wire            net077 ;


bw_io_impctl_clnew I179 (
     .sz              ({sz } ),
     .z               ({to_csr } ),
     .ctu_io_sscan_update (ctu_io_sscan_update ),
     .ctu_io_sscan_out (io_ctu_sscan_out ),
     .clk             (l1clk2 ),
     .si              (net58 ),
     .so              (so ),
     .ctu_global_snap (ctu_global_snap ),
     .ctu_io_sscan_se (ctu_io_sscan_se ),
     .tclk            (tclk ),
     .snap_enable     (net077 ),
     .se              (se ),
     .freeze          (freeze ),
     .hard_reset_n    (hard_reset_n ),
     .ctu_io_sscan_in (ctu_io_sscan_in ) );
bw_u1_ckenbuf_4p5x I30 (
     .clk             (l1clk0 ),
     .rclk            (l2clk ),
     .en_l            (clk_en_l ),
     .tm_l            (se_l ) );
bw_io_impctl_clsm I208 (
     .sz              ({sz } ),
     .to_csr          ({to_csr } ),
     .z_post          ({z_post } ),
     .from_csr        ({from_csr } ),
     .d               ({d } ),
     .clk             (l1clk1 ),
     .deltabit        (deltabit ),
     .we_csr          (we_csr ),
     .synced_upd_imped (ctu_io_sscan_update ),
     .updclk          (updclk ),
     .hard_reset_n    (hard_reset_n ),
     .adv_sgn         (adv_sgn ),
     .si_l            (scan_n ),
     .config_pmos     (config_pmos ),
     .se              (se ),
     .freeze          (freeze ),
     .so_l            (so_l ),
     .above           (above ),
     .bypass          (bypass ),
     .global_reset_n  (global_reset_n ) );
bw_io_impctl_avgcnt I209 (
     .adv_sgn         (adv_sgn ),
     .so_i            (scan_n ),
     .above           (above ),
     .sclk            (sclk ),
     .avgcntr_rst     (avgcntr_rst ),
     .se              (se ),
     .si_l            (si_l ),
     .global_reset_n  (global_reset_n ),
     .l2clk           (l1clk0 ) );
bw_u1_ckenbuf_4p5x I210 (
     .clk             (l1clk1 ),
     .rclk            (l2clk ),
     .en_l            (clk_en_l ),
     .tm_l            (se_l ) );
bw_u1_ckenbuf_6x I213 (
     .clk             (l1clk2 ),
     .rclk            (l2clk ),
     .en_l            (clk_en_l ),
     .tm_l            (se_l ) );
bw_u1_inv_8x I218 (
     .z               (net58 ),
     .a               (so_l ) );
bw_u1_inv_8x I219 (
     .z               (se_l ),
     .a               (se ) );
bw_u1_inv_8x I220 (
     .z               (net064 ),
     .a               (l1clk0 ) );
bw_u1_inv_8x I221 (
     .z               (net066 ),
     .a               (l1clk1 ) );
bw_u1_inv_8x I222 (
     .z               (net068 ),
     .a               (l1clk2 ) );
endmodule


