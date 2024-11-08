// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp_clkgn_nstep.v
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
//    Unit Name: ctu_clsp_clkgn_nstep
//
//-----------------------------------------------------------------------------
`include "sys.h"

module ctu_clsp_clkgn_nstep(/*AUTOARG*/
// Outputs
cmp_nstep_sel, jbus_nstep_sel, dram_nstep_sel, 
// Inputs
io_pwron_rst_l, jtag_clock_dr_cmp, jtag_clock_dr_dram, 
jtag_clock_dr_jbus, jtag_clsp_force_cken_jbus, 
jtag_clsp_force_cken_dram, jtag_clsp_force_cken_cmp, 
jtag_nstep_count, jtag_nstep_domain, jtag_nstep_vld, cmp_gclk_bypass, 
dram_gclk_bypass, jbus_gclk_bypass, capture_l, start_clk_early_jl, 
testmode_l, shadreg_div_cmult, shadreg_div_jmult, shadreg_div_dmult
);


input io_pwron_rst_l;
input jtag_clock_dr_cmp;
input jtag_clock_dr_dram;
input jtag_clock_dr_jbus;
input jtag_clsp_force_cken_jbus;
input jtag_clsp_force_cken_dram;
input jtag_clsp_force_cken_cmp;

input [3:0] jtag_nstep_count;
input [2:0] jtag_nstep_domain;
input jtag_nstep_vld;

input cmp_gclk_bypass;
input dram_gclk_bypass;
input jbus_gclk_bypass;


input capture_l;
input start_clk_early_jl;
input testmode_l;

input [13:0] shadreg_div_cmult;
input [9:0] shadreg_div_jmult;
input [9:0] shadreg_div_dmult;

output cmp_nstep_sel;
output jbus_nstep_sel;
output dram_nstep_sel;


/* ctu_clsp_clkgn_nstep_cnt AUTO_TEMPLATE (
          .io_pwron_rst_l(io_pwron_rst_l),
          .clk (cmp_gclk_bypass),
          .jtag_clock_dr(jtag_clock_dr_cmp),
          .jtag_nstep_count(jtag_nstep_count[]),     
          .jtag_nstep_domain(jtag_nstep_domain[0]),
          .jtag_nstep_vld(jtag_nstep_vld),
          .nstep_sel(cmp_nstep_sel),
          .shadreg_div_mult(shadreg_div_cmult[13:0]),
          .force_cken(jtag_clsp_force_cken_cmp),
      
      );
*/

   ctu_clsp_clkgn_nstep_cnt u_cmp(/*AUTOINST*/
				  // Outputs
				  .nstep_sel(cmp_nstep_sel),	 // Templated
				  // Inputs
				  .io_pwron_rst_l(io_pwron_rst_l), // Templated
				  .clk	(cmp_gclk_bypass),	 // Templated
				  .jtag_clock_dr(jtag_clock_dr_cmp), // Templated
				  .jtag_nstep_count(jtag_nstep_count[3:0]), // Templated
				  .jtag_nstep_domain(jtag_nstep_domain[0]), // Templated
				  .jtag_nstep_vld(jtag_nstep_vld), // Templated
				  .capture_l(capture_l),
				  .testmode_l(testmode_l),
				  .start_clk_early_jl(start_clk_early_jl),
				  .shadreg_div_mult(shadreg_div_cmult[13:0]), // Templated
				  .force_cken(jtag_clsp_force_cken_cmp)); // Templated


/* ctu_clsp_clkgn_nstep_cnt AUTO_TEMPLATE (
          .io_pwron_rst_l(io_pwron_rst_l),
          .clk (jbus_gclk_bypass),
          .jtag_clock_dr(jtag_clock_dr_jbus),
          .jtag_nstep_count(jtag_nstep_count[]),     
          .jtag_nstep_domain(jtag_nstep_domain[2]),
          .jtag_nstep_vld(jtag_nstep_vld),
          .nstep_sel(jbus_nstep_sel),
          .shadreg_div_mult({4'h0,shadreg_div_jmult[9:0]}),
          .force_cken(jtag_clsp_force_cken_jbus),
      );
*/
   
   ctu_clsp_clkgn_nstep_cnt u_jbus(/*AUTOINST*/
				   // Outputs
				   .nstep_sel(jbus_nstep_sel),	 // Templated
				   // Inputs
				   .io_pwron_rst_l(io_pwron_rst_l), // Templated
				   .clk	(jbus_gclk_bypass),	 // Templated
				   .jtag_clock_dr(jtag_clock_dr_jbus), // Templated
				   .jtag_nstep_count(jtag_nstep_count[3:0]), // Templated
				   .jtag_nstep_domain(jtag_nstep_domain[2]), // Templated
				   .jtag_nstep_vld(jtag_nstep_vld), // Templated
				   .capture_l(capture_l),
				   .testmode_l(testmode_l),
				   .start_clk_early_jl(start_clk_early_jl),
				   .shadreg_div_mult({4'h0,shadreg_div_jmult[9:0]}), // Templated
				   .force_cken(jtag_clsp_force_cken_jbus)); // Templated


/* ctu_clsp_clkgn_nstep_cnt AUTO_TEMPLATE (
          .io_pwron_rst_l(io_pwron_rst_l),
          .clk (dram_gclk_bypass),
          .jtag_clock_dr(jtag_clock_dr_dram),
          .jtag_nstep_count(jtag_nstep_count[]),     
          .jtag_nstep_domain(jtag_nstep_domain[1]),
          .jtag_nstep_vld(jtag_nstep_vld),
          .nstep_sel(dram_nstep_sel),
          .shadreg_div_mult({4'h0,shadreg_div_dmult[9:0]}),
          .force_cken(jtag_clsp_force_cken_dram),
      );
*/

    ctu_clsp_clkgn_nstep_cnt u_dram(/*AUTOINST*/
				    // Outputs
				    .nstep_sel(dram_nstep_sel),	 // Templated
				    // Inputs
				    .io_pwron_rst_l(io_pwron_rst_l), // Templated
				    .clk(dram_gclk_bypass),	 // Templated
				    .jtag_clock_dr(jtag_clock_dr_dram), // Templated
				    .jtag_nstep_count(jtag_nstep_count[3:0]), // Templated
				    .jtag_nstep_domain(jtag_nstep_domain[1]), // Templated
				    .jtag_nstep_vld(jtag_nstep_vld), // Templated
				    .capture_l(capture_l),
				    .testmode_l(testmode_l),
				    .start_clk_early_jl(start_clk_early_jl),
				    .shadreg_div_mult({4'h0,shadreg_div_dmult[9:0]}), // Templated
				    .force_cken(jtag_clsp_force_cken_dram)); // Templated


endmodule
// Local Variables:
// verilog-library-directories:("." "../../common/rtl")
// verilog-library-files:      ("../../common/rtl/swrvr_clib.v")
// verilog-auto-sense-defines-constant:t
// End:
