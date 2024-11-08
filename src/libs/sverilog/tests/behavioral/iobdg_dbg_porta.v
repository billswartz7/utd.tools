// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_dbg_porta.v
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
/*
//  Module Name:	iobdg_dbg_porta (IO Bridge debug/visibility)
//  Description:	
*/
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////
`include	"sys.h" // system level definition file which contains the 
			// time scale definition
`include        "iop.h"


////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Interface signal list declarations
////////////////////////////////////////////////////////////////////////
module iobdg_dbg_porta (/*AUTOARG*/
   // Outputs
   iob_io_dbg_data, iob_io_dbg_en, iob_io_dbg_ck_p, iob_io_dbg_ck_n, 
   l2_vis_armin, iob_clk_tr, 
   // Inputs
   rst_l, clk, src0_data, src1_data, src2_data, src3_data, src4_data, 
   src0_vld, src1_vld, src2_vld, src3_vld, src4_vld, 
   creg_dbg_enet_ctrl, creg_dbg_enet_idleval, io_trigin
   );

////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input                                    rst_l;
   input 				    clk;
   

   // Debug input buses
   input [39:0] 			    src0_data;
   input [39:0] 			    src1_data;
   input [39:0] 			    src2_data;
   input [39:0] 			    src3_data;
   input [39:0] 			    src4_data;

   input 				    src0_vld;
   input 				    src1_vld;
   input 				    src2_vld;
   input 				    src3_vld;
   input 				    src4_vld;

   
   // Debug output bus
   output [39:0] 			    iob_io_dbg_data;
   output 				    iob_io_dbg_en;
   output [2:0] 			    iob_io_dbg_ck_p;
   output [2:0] 			    iob_io_dbg_ck_n;
   
			    
   // Control interface
   input [63:0] 			    creg_dbg_enet_ctrl;
   input [63:0] 			    creg_dbg_enet_idleval;

   
   // Misc interface   
   input 				    io_trigin;
   
   output 				    l2_vis_armin;
   output 				    iob_clk_tr;
   

   // Internal signals
   wire 				    dbg_en;
   wire 				    dbg_armin_en;
   wire 				    dbg_trigin_en;
   wire [3:0] 				    dbg_sel;
   wire [39:0] 				    dbg_idleval;
   
   reg [39:0] 				    mux_data;
   reg 					    mux_vld;

   wire [39:0] 				    dbg_data;

   wire 				    iob_io_dbg_ck_p_next;
   
   wire 				    io_trigin_d1;
   wire 				    io_trigin_d2;
   wire 				    io_trigin_d3;
   wire 				    io_trigin_detected;
   wire 				    iob_clk_tr_a1;

		    
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   assign 	dbg_en        = creg_dbg_enet_ctrl[8];
   assign 	dbg_armin_en  = creg_dbg_enet_ctrl[6];
   assign 	dbg_trigin_en = creg_dbg_enet_ctrl[5];
   assign 	dbg_sel       = creg_dbg_enet_ctrl[3:0];
   assign 	dbg_idleval   = creg_dbg_enet_idleval[39:0];
   
   always @(/*AUTOSENSE*/dbg_sel or src0_data or src0_vld or src1_data
	    or src1_vld or src2_data or src2_vld or src3_data
	    or src3_vld or src4_data or src4_vld)
     case (dbg_sel)
       4'b0000:  {mux_vld,mux_data} = {src0_vld,src0_data};
       4'b0001:  {mux_vld,mux_data} = {src1_vld,src1_data};
       4'b0010:  {mux_vld,mux_data} = {src2_vld,src2_data};
       4'b0011:  {mux_vld,mux_data} = {src3_vld,src3_data};
       4'b0100:  {mux_vld,mux_data} = {src4_vld,src4_data};
       default:  {mux_vld,mux_data} = {1'b0,40'b0};
     endcase // case(dbg_sel)
   
   assign 	dbg_data = mux_vld ? mux_data : dbg_idleval;

   dff_ns #(40) iob_io_dbg_data_ff (.din(dbg_data),
				    .clk(clk),
				    .q(iob_io_dbg_data));

   dff_ns #(1) iob_io_dbg_en_ff (.din(dbg_en),
				 .clk(clk),
				 .q(iob_io_dbg_en));
   

   // Generate clocks for the debug pad
   assign 	iob_io_dbg_ck_p_next = ~iob_io_dbg_ck_p[0] & dbg_en;
   
   dff_ns #(1) iob_io_dbg_ck_p_ff (.din(iob_io_dbg_ck_p_next),
				   .clk(clk),
				   .q(iob_io_dbg_ck_p[0]));

   assign       iob_io_dbg_ck_p[1] = iob_io_dbg_ck_p[0];
   assign       iob_io_dbg_ck_p[2] = iob_io_dbg_ck_p[0];
   
   assign 	iob_io_dbg_ck_n = ~iob_io_dbg_ck_p;
   
   
   // Flop TRIGIN pin and detect edge
   dffrl_ns #(1) io_trigin_d1_ff (.din(io_trigin),
				  .clk(clk),
				  .rst_l(rst_l),
				  .q(io_trigin_d1));

   dffrl_ns #(1) io_trigin_d2_ff (.din(io_trigin_d1),
				  .clk(clk),
				  .rst_l(rst_l),
				  .q(io_trigin_d2));

   dffrl_ns #(1) io_trigin_d3_ff (.din(io_trigin_d2),
				  .clk(clk),
				  .rst_l(rst_l),
				  .q(io_trigin_d3));

   assign 	io_trigin_detected = io_trigin_d2 & ~io_trigin_d3;
   
   // Route TRIGIN pin to L2 Visibility port as ARM_IN
   assign 	l2_vis_armin = dbg_armin_en & io_trigin_detected;
	 
   // Route TRIGIN pin to clock block for stop_and_scan
   assign 	iob_clk_tr_a1 = dbg_trigin_en & io_trigin_detected;

   dffrl_ns #(1) iob_clk_tr_ff (.din(iob_clk_tr_a1),
				.clk(clk),
				.rst_l(rst_l),
				.q(iob_clk_tr));
   
endmodule // iobdg_dbg_porta


// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:



