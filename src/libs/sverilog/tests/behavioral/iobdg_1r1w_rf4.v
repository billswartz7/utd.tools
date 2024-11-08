// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_1r1w_rf4.v
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
//  Module Name:	iobdg_1r1w_rf4
//  Description:	1r1w regfile emulated using FF's.
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
module iobdg_1r1w_rf4 (/*AUTOARG*/
   // Outputs
   dout, 
   // Inputs
   rd_clk, wr_clk, rd_a, wr_a, din, wen_l
   );

   parameter REG_WIDTH = 64;

   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   input                     rd_clk;
   input                     wr_clk;
   
   input [1:0] 		     rd_a;
   input [1:0] 		     wr_a;
   input [REG_WIDTH-1:0]     din;
   input 		     wen_l;
   
   output [REG_WIDTH-1:0]    dout;

   wire [1:0] 		     wr_a_d1;
   wire [REG_WIDTH-1:0]      din_d1;
   wire 		     wen_l_d1;
   wire [3:0] 		     wr_a_dec_d1;
   wire [3:0] 		     wen_dec_d1;
   wire [REG_WIDTH-1:0]      line0;
   wire [REG_WIDTH-1:0]      line1;
   wire [REG_WIDTH-1:0]      line2;
   wire [REG_WIDTH-1:0]      line3;
   wire [1:0] 		     rd_a_d1;
   reg [REG_WIDTH-1:0] 	     dout;
   
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   // Flop write address, write data and write enable
   dff_ns #(2) wr_a_d1_ff (.din(wr_a),
			   .clk(wr_clk),
			   .q(wr_a_d1));

   dff_ns #(REG_WIDTH) din_d1_ff (.din(din),
				  .clk(wr_clk),
				  .q(din_d1));

   dff_ns #(1) wen_l_d1_ff (.din(wen_l),
			    .clk(wr_clk),
			    .q(wen_l_d1));

   assign 	     wr_a_dec_d1 = 1'b1 << wr_a_d1;
   
   assign 	     wen_dec_d1 = {4{~wen_l_d1}} & wr_a_dec_d1;

   
   // FF's for storage
   dffe_ns #(REG_WIDTH) line0_ff (.din(din_d1),.en(wen_dec_d1[0]),.clk(wr_clk),.q(line0));
   dffe_ns #(REG_WIDTH) line1_ff (.din(din_d1),.en(wen_dec_d1[1]),.clk(wr_clk),.q(line1));
   dffe_ns #(REG_WIDTH) line2_ff (.din(din_d1),.en(wen_dec_d1[2]),.clk(wr_clk),.q(line2));
   dffe_ns #(REG_WIDTH) line3_ff (.din(din_d1),.en(wen_dec_d1[3]),.clk(wr_clk),.q(line3));

   // Flop read address
   dff_ns #(2) rd_a_d1_ff (.din(rd_a),
			   .clk(rd_clk),
			   .q(rd_a_d1));

   // Mux out read data
   always @(/*AUTOSENSE*/line0 or line1 or line2 or line3 or rd_a_d1) begin
      case (rd_a_d1)
	2'd0: dout = line0;
	2'd1: dout = line1;
	2'd2: dout = line2;
	2'd3: dout = line3;
	default: dout = {REG_WIDTH{1'bx}};
      endcase // case(rd_a_d1)
   end
   
   
endmodule // iobdg_1r1w_rf4





// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
