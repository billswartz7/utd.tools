// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_cl_ccx_cmp.v
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

//FPGA_SYN enables all FPGA related modifications
`ifdef FPGA_SYN 
`define FPGA_SYN_CLK
`endif

module bw_clk_cl_ccx_cmp(so ,grst_l ,gdbginit_l ,gclk ,dbginit_l ,
       cluster_grst_l,rclk ,si ,se, se2,adbginit_l ,arst_l ,arst2_l ,
       cluster_cken );
output     so ;
input      grst_l ;
input      gdbginit_l ;
input [1:0]     gclk ;
input      si ;
output          dbginit_l ;
output          cluster_grst_l ;
output          rclk ;
input           se ;
input           se2 ;
input           adbginit_l ;
input           arst_l ;
input           arst2_l ;
input           cluster_cken ;

wire            net73 ;
wire            net74 ;
wire            net75 ;
wire            so0_2_si1 ;

cluster_header_dup Iprimary (
     .rclk            (rclk ),
     .so              (so0_2_si1 ),
     .dbginit_l       (dbginit_l ),
     .cluster_grst_l  (cluster_grst_l ),
     .si              (si ),
     .se              (se ),
     .adbginit_l      (adbginit_l ),
     .gdbginit_l      (gdbginit_l ),
     .arst_l          (arst_l ),
     .grst_l          (grst_l ),
     .cluster_cken    (cluster_cken ),
     .gclk            (gclk[0] ) );

`ifdef FPGA_SYN_CLK
`else
cluster_header_dup Iseconadry (
     .rclk            (rclk ),
     .so              (so ),
     .dbginit_l       (net75 ),
     .cluster_grst_l  (net73 ),
     .si              (so0_2_si1),
     .se              (se2 ),
     .adbginit_l      (1'b1 ),
     .gdbginit_l      (1'b1 ),
     .arst_l          (arst2_l ),
     .grst_l          (1'b1 ),
     .cluster_cken    (cluster_cken ),
     .gclk            (gclk[1] ) );
`endif

endmodule

