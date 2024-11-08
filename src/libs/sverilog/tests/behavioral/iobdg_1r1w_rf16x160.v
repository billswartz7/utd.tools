// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_1r1w_rf16x160.v
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
//  Module Name:	iobdg_1r1w_rf16x160
//  Description:	1r1w regfile
*/
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////
`include	"sys.h" // system level definition file which contains the 
			// time scale definition


////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Interface signal list declarations
////////////////////////////////////////////////////////////////////////
module iobdg_1r1w_rf16x160 (/*AUTOARG*/
   // Outputs
   so_w, so_r, dout, 
   // Inputs
   wr_en, wr_clk, wr_adr, word_wen, si_w, si_r, sehold, se, 
   rst_tri_en, reset_l, read_en, rd_clk, rd_adr, din, byte_wen, 
   testmux_sel
   );

   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input [19:0]		byte_wen;		// To bw_r_rf16x160 of bw_r_rf16x160.v
   input [159:0]	din;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   input [3:0]		rd_adr;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		rd_clk;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		read_en;		// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		reset_l;		// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		rst_tri_en;		// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		se;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		sehold;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		si_r;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		si_w;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   input [3:0]		word_wen;		// To bw_r_rf16x160 of bw_r_rf16x160.v
   input [3:0]		wr_adr;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		wr_clk;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   input		wr_en;			// To bw_r_rf16x160 of bw_r_rf16x160.v
   // End of automatics
   
   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		so_r;			// From bw_r_rf16x160 of bw_r_rf16x160.v
   output		so_w;			// From bw_r_rf16x160 of bw_r_rf16x160.v
   // End of automatics
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   // End of automatics

   input 		testmux_sel;
   output [159:0] 	dout;
   wire [159:0] 	dout_array;
   wire [159:0] 	dout_scan;
   
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   bw_r_rf16x160 bw_r_rf16x160 (.dout	(dout_array[159:0]),
				/*AUTOINST*/
				// Outputs
				.so_w	(so_w),
				.so_r	(so_r),
				// Inputs
				.din	(din[159:0]),
				.rd_adr	(rd_adr[3:0]),
				.wr_adr	(wr_adr[3:0]),
				.read_en(read_en),
				.wr_en	(wr_en),
				.rst_tri_en(rst_tri_en),
				.word_wen(word_wen[3:0]),
				.byte_wen(byte_wen[19:0]),
				.rd_clk	(rd_clk),
				.wr_clk	(wr_clk),
				.se	(se),
				.si_r	(si_r),
				.si_w	(si_w),
				.reset_l(reset_l),
				.sehold	(sehold));

   // testmux for DFT
   assign 		dout = testmux_sel ? dout_scan : dout_array;

   dff_ns #(160) dout_scan_ff (.din(dout_array),
			       .clk(rd_clk),
			       .q(dout_scan));
   
endmodule // iobdg_1r1w_rf16x160



// Local Variables:
// verilog-library-directories:("." "../../../srams/rtl")
// End:
