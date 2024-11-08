// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_cl_ctu_2xcmp_b.v
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
module bw_clk_cl_ctu_2xcmp_b(bw_pll_2x_clk_local_b ,bw_pll_2xclk_b );
output		bw_pll_2x_clk_local_b ;
input		bw_pll_2xclk_b ;
 
assign bw_pll_2x_clk_local_b =  bw_pll_2xclk_b;
/*
wire		net6 ;
 
 
bw_u1_ckbuf_33x I3 (
     .clk             (net6 ),
     .rclk            (bw_pll_2xclk_b ) );
bw_u1_ckbuf_33x local_driver_3_ (
     .clk             (bw_pll_2x_clk_local_b ),
     .rclk            (net6 ) );
bw_u1_ckbuf_33x local_driver_4_ (
     .clk             (bw_pll_2x_clk_local_b ),
     .rclk            (net6 ) );
bw_u1_ckbuf_33x local_driver_1_ (
     .clk             (bw_pll_2x_clk_local_b ),
     .rclk            (net6 ) );
bw_u1_ckbuf_33x local_driver_2_ (
     .clk             (bw_pll_2x_clk_local_b ),
     .rclk            (net6 ) );
bw_u1_ckbuf_33x local_driver_0_ (
     .clk             (bw_pll_2x_clk_local_b ),
     .rclk            (net6 ) );
*/
endmodule

