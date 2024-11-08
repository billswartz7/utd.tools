// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp_clkgn_ddiv.v
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
////////////////////////////////////////////////////////////////////////
//
//  Module Name:        clk_ddiv
//
//  Description:	clock divider based on Johnson counter
//
//                      - supports odd/even divisors from 2 to 24 (12 stages of Jons. cnt)
//                      - supports clock stretch for duration of sig "stretch"
//
//                      - positive clock counter have sigs *joa*
//                      - negative clock counter have sigs *job*
//
//    			- outputs joa_q_2, joa_q_1, joa_q_0 might be used for synchronization
//
//			- the last stages of counters "joa_q[0]" and "job_q[0]"
//			  are registered into "joa_q_0_reg" and "job_q_0_reg"   
//
//               	- the "joa_q_0_reg" and "job_q_0_reg" are ORed into "out_gclk".
//
//
//
// Mimi 7/8/03 : Added input stretch_b,rst_b_l

module ctu_clsp_clkgn_ddiv (/*AUTOARG*/
// Outputs
dom_div0, align_edge, align_edge_b, dom_div1, so, 
// Inputs
pll_clk_out, pll_clk_out_l, rst_l, rst_b_l, div_dec, stretch_l, 
stretch_b_l, se, si
);


   // Globals
   input                                pll_clk_out;
   input                                pll_clk_out_l;
   input 				rst_l;
   input 				rst_b_l;
   
   // Divisor
   input [14:0] 			div_dec	;

   // The "stretch" is expected synced with pll_clk_out
   input 				stretch_l;
   input                                stretch_b_l;

   // Clock outputs
   output                               dom_div0;
   output                               align_edge;
   output                               align_edge_b;
   output                               dom_div1;
   
   input                                si;
   input 				se;
   output				so;

   /*
   output 				out_gclk;
   output 				out_gclk_l;
   */


ctu_clsp_clkgn_1div pos(
			// Outputs
			.dom_div	(dom_div0),
			.align_edge	(align_edge),
			.align_edge_b	(align_edge_b),
			.so		(),
			// Inputs
			.pll_clk	(pll_clk_out),
			.pll_clk_l	(pll_clk_out_l),
			.init_l		(rst_l),
			.div_dec	(div_dec[14:0]),
			.stretch_l	(stretch_l),
			.se		(se),
			.si		());

ctu_clsp_clkgn_1div neg(
			// Outputs
			.dom_div	(dom_div1),
			.align_edge	(),
			.align_edge_b	(),
			.so		(),
			// Inputs
			.pll_clk	(pll_clk_out_l),
			.pll_clk_l	(pll_clk_out),
			.init_l		(rst_b_l),
			.div_dec	(div_dec[14:0]),
			.stretch_l	(stretch_b_l),
			.se		(se),
			.si		());


endmodule // clk_ddiv
