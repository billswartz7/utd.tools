// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp_dramgif.v
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
//
//    Cluster Name:  CTU
//    Unit Name: ctu_clsp_dramif
//
//-----------------------------------------------------------------------------
`include "sys.h"
`include "ctu.h"

module ctu_clsp_dramgif(/*AUTOARG*/
// Outputs
dram_grst_out_l, dram_arst_l, dram_gdbginit_out_l, dram_adbginit_l, 
ctu_dram02_dram_cken, ctu_dram13_dram_cken, ctu_ddr0_dram_cken, 
ctu_ddr1_dram_cken, ctu_ddr2_dram_cken, ctu_ddr3_dram_cken, 
// Inputs
io_pwron_rst_l, start_clk_early_jl, testmode_l, dram_gclk, 
start_clk_dg, shadreg_div_dmult, de_grst_dsync_edge_dg, 
de_dbginit_dsync_edge_dg, a_grst_dg, a_dbginit_dg, 
ctu_dram02_dram_cken_dg, ctu_dram13_dram_cken_dg, 
ctu_ddr0_dram_cken_dg, ctu_ddr1_dram_cken_dg, ctu_ddr2_dram_cken_dg, 
ctu_ddr3_dram_cken_dg, jtag_clsp_force_cken_dram
);

   input      io_pwron_rst_l;
   input      start_clk_early_jl;
   input      testmode_l;
   input      dram_gclk;
   input      start_clk_dg;
 
   input [9:0]            shadreg_div_dmult;
   input                  de_grst_dsync_edge_dg;
   input                  de_dbginit_dsync_edge_dg;
   input                  a_grst_dg;
   input                  a_dbginit_dg;


   input      ctu_dram02_dram_cken_dg;
   input      ctu_dram13_dram_cken_dg;
   input      ctu_ddr0_dram_cken_dg;
   input      ctu_ddr1_dram_cken_dg;
   input      ctu_ddr2_dram_cken_dg;
   input      ctu_ddr3_dram_cken_dg;
   input      jtag_clsp_force_cken_dram;
   

   output      dram_grst_out_l;
   output      dram_arst_l;
   output      dram_gdbginit_out_l;         
   output      dram_adbginit_l;       
   output      ctu_dram02_dram_cken;
   output      ctu_dram13_dram_cken;
   output      ctu_ddr0_dram_cken;
   output      ctu_ddr1_dram_cken;
   output      ctu_ddr2_dram_cken;
   output      ctu_ddr3_dram_cken;



   wire      ctu_dram02_dram_cken_muxed;
   wire      ctu_dram13_dram_cken_muxed;
   wire      ctu_ddr0_dram_cken_muxed;
   wire      ctu_ddr1_dram_cken_muxed;
   wire      ctu_ddr2_dram_cken_muxed;
   wire      ctu_ddr3_dram_cken_muxed;
   wire      force_cken;


   
// sync edge count

   wire [9:0] lcm_cnt_minus_1;
   wire [9:0] lcm_cnt_nxt;
   wire [9:0] lcm_cnt;
   wire lcm_cnt_zero;
   wire cnt_ld;
   wire dram_grst_l_nxt;
   wire dram_dbginit_l_nxt;
   wire dbginit_en_window_nxt;
   wire dbginit_en_window;
   wire grst_en_window_nxt;
   wire grst_en_window;

  

// -----------------------------------------
// 
//  Negedge flops signals
// 
// -----------------------------------------



// -----------------------------------------
// 
//  Global signals
// 
// -----------------------------------------

// The following flops needs to be non-scanable:

   assign  dram_arst_l =  io_pwron_rst_l ;
   assign  dram_adbginit_l = io_pwron_rst_l ;

   assign  force_cken = jtag_clsp_force_cken_dram | ~testmode_l;

   assign ctu_dram02_dram_cken_muxed = force_cken ? 1'b1: ctu_dram02_dram_cken_dg & start_clk_dg; 
   assign ctu_dram13_dram_cken_muxed = force_cken ? 1'b1: ctu_dram13_dram_cken_dg & start_clk_dg; 
   assign ctu_ddr0_dram_cken_muxed = force_cken ?  1'b1: ctu_ddr0_dram_cken_dg  & start_clk_dg; 
   assign ctu_ddr1_dram_cken_muxed = force_cken ?  1'b1: ctu_ddr1_dram_cken_dg  & start_clk_dg; 
   assign ctu_ddr2_dram_cken_muxed = force_cken ?  1'b1: ctu_ddr2_dram_cken_dg  & start_clk_dg; 
   assign ctu_ddr3_dram_cken_muxed = force_cken ?  1'b1: ctu_ddr3_dram_cken_dg  & start_clk_dg; 

   dffrl_async_ns    u_ctu_dram02_dram_cken_async_nsr(
			   .din (ctu_dram02_dram_cken_muxed),
			   .clk (dram_gclk),
                           .rst_l(io_pwron_rst_l),
			   .q (ctu_dram02_dram_cken));

   dffrl_async_ns    u_ctu_dram13_dram_cken_async_nsr(
			   .din (ctu_dram13_dram_cken_muxed),
			   .clk (dram_gclk),
                           .rst_l(io_pwron_rst_l),
			   .q (ctu_dram13_dram_cken));

   dffrl_async_ns    u_ctu_ddr0_dram_cken_async_nsr(
			   .din (ctu_ddr0_dram_cken_muxed),
			   .clk (dram_gclk),
                           .rst_l(io_pwron_rst_l),
			   .q (ctu_ddr0_dram_cken));

   dffrl_async_ns    u_ctu_ddr1_dram_cken_async_nsr(
			   .din (ctu_ddr1_dram_cken_muxed),
			   .clk (dram_gclk),
                           .rst_l(io_pwron_rst_l),
			   .q (ctu_ddr1_dram_cken));

   dffrl_async_ns    u_ctu_ddr2_dram_cken_async_nsr(
			   .din (ctu_ddr2_dram_cken_muxed),
			   .clk (dram_gclk),
                           .rst_l(io_pwron_rst_l),
			   .q (ctu_ddr2_dram_cken));

   dffrl_async_ns    u_ctu_ddr3_dram_cken_async_nsr(
			   .din (ctu_ddr3_dram_cken_muxed),
			   .clk (dram_gclk),
                           .rst_l(io_pwron_rst_l),
			   .q (ctu_ddr3_dram_cken));
// -----------------------------------------
// 
//   sync edge logic
// 
// -----------------------------------------



dffsl_async_ns  u_cnt_ld(
                   .din (1'b0),
                   .clk (dram_gclk),
                   .set_l (start_clk_early_jl),
                   .q(cnt_ld));

assign lcm_cnt_minus_1 = lcm_cnt - 10'h001;

assign lcm_cnt_nxt =  cnt_ld? shadreg_div_dmult[9:0]: 
                      (|(lcm_cnt[9:1])) ?   lcm_cnt_minus_1  : shadreg_div_dmult[9:0];

dffrl_async_ns #(10) u_lcm_ff (
                   .din (lcm_cnt_nxt),
                   .clk (dram_gclk),
                   .rst_l (start_clk_early_jl),
                   .q(lcm_cnt));

assign lcm_cnt_zero =  ~(|(lcm_cnt[9:1]));


   /************************************************************
    *   Grst logic
    ************************************************************/

assign dram_grst_l_nxt  = (lcm_cnt == `DRAM_GLOBAL_LATENCY) & grst_en_window? 1'b1:
                        a_grst_dg? 1'b0:
                        dram_grst_out_l;

dffrl_async_ns u_dram_grst_jl_l(
                   .din (dram_grst_l_nxt & start_clk_dg),
                   .clk (dram_gclk),
                   .rst_l(io_pwron_rst_l),
                   .q(dram_grst_out_l));

assign dram_dbginit_l_nxt  = 
                        (a_dbginit_dg|a_grst_dg) ? 1'b0:
                        (lcm_cnt == `DRAM_GLOBAL_LATENCY) & dbginit_en_window? 1'b1:
                        dram_gdbginit_out_l;

dffrl_async_ns u_dram_dbginit_l(
                   .din (dram_dbginit_l_nxt & start_clk_dg),
                   .clk (dram_gclk),
                   .rst_l(io_pwron_rst_l),
                   .q(dram_gdbginit_out_l));

assign grst_en_window_nxt = de_grst_dsync_edge_dg & lcm_cnt_zero ? 1'b1:
                            lcm_cnt_zero &  grst_en_window ? 1'b0:
                            grst_en_window;

dffrl_async_ns u_grst_en_window( .din (grst_en_window_nxt & start_clk_dg),
                   .clk (dram_gclk),
                   .rst_l(io_pwron_rst_l),
                   .q(grst_en_window));

assign dbginit_en_window_nxt = de_dbginit_dsync_edge_dg  &  lcm_cnt_zero  ? 1'b1:
                            lcm_cnt_zero  &  dbginit_en_window ? 1'b0:
                            dbginit_en_window;

dffrl_async_ns u_dbginit_en_window( .din (dbginit_en_window_nxt  & start_clk_dg ),
                   .clk (dram_gclk),
                   .rst_l(io_pwron_rst_l),
                   .q(dbginit_en_window));


endmodule // dramif


// Local Variables:
// verilog-library-directories:("." "../common/rtl")
// verilog-auto-sense-defines-constant:t
// End:








