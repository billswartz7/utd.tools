// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_1r2w_vec.v
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
//  Module Name:	iobdg_1r2w_vec
//  Description:	1r2w bit vector implemented using FF's.
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
module iobdg_1r2w_vec (/*AUTOARG*/
   // Outputs
   dout, dout_vec, 
   // Inputs
   clk, rst_l, tx_en, rd_a, wr1_a, wr2_a, din1, din2, wen1, wen2
   );

   parameter WIDTH = 32;
   parameter INDEX = 5;
   
   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   input                     clk;
   input 		     rst_l;
   input 		     tx_en;
   
   input [INDEX-1:0] 	     rd_a;
   input [INDEX-1:0] 	     wr1_a;
   input [INDEX-1:0] 	     wr2_a;
   input 		     din1;
   input 		     din2;
   input 		     wen1;
   input 		     wen2;
   
   output 		     dout;
   output [WIDTH-1:0] 	     dout_vec;
   
   wire [INDEX-1:0] 	     wr1_a_d1;
   wire [INDEX-1:0] 	     wr2_a_d1;
   wire 		     din1_d1;
   wire 		     din2_d1;
   wire 		     wen1_d1;
   wire 		     wen2_d1;
   wire [WIDTH-1:0] 	     wr1_a_dec_d1;
   wire [WIDTH-1:0] 	     wr2_a_dec_d1;
   wire [WIDTH-1:0] 	     wen1_dec_d1;
   wire [WIDTH-1:0] 	     wen2_dec_d1;
   wire [WIDTH-1:0] 	     vec;
   reg [WIDTH-1:0] 	     vec_next;
   wire [INDEX-1:0] 	     rd_a_d1;
   wire [WIDTH-1:0] 	     rd_a_dec_d1;
   wire 		     dout;
   
   integer 		     i;

   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   // Flop write address, write data and write enable
   dff_ns #(INDEX) wr1_a_d1_ff (.din(wr1_a),
			   	.clk(clk),
			   	.q(wr1_a_d1));

   dff_ns #(INDEX) wr2_a_d1_ff (.din(wr2_a),
			   	.clk(clk),
			   	.q(wr2_a_d1));

   dff_ns #(1) din1_d1_ff (.din(din1),
			   .clk(clk),
			   .q(din1_d1));

   dff_ns #(1) din2_d1_ff (.din(din2),
			   .clk(clk),
			   .q(din2_d1));

   dff_ns #(1) wen1_d1_ff (.din(wen1),
			   .clk(clk),
			   .q(wen1_d1));

   dff_ns #(1) wen2_d1_ff (.din(wen2),
			   .clk(clk),
			   .q(wen2_d1));

   assign 	     wr1_a_dec_d1 = 1'b1 << wr1_a_d1;
   
   assign 	     wr2_a_dec_d1 = 1'b1 << wr2_a_d1;
   
   assign 	     wen1_dec_d1 = {WIDTH{wen1_d1}} & wr1_a_dec_d1;

   assign 	     wen2_dec_d1 = {WIDTH{wen2_d1}} & wr2_a_dec_d1;

   always @(/*AUTOSENSE*/din1_d1 or din2_d1 or rst_l or vec
	    or wen1_dec_d1 or wen2_dec_d1)
     begin
   	for (i=0; i<WIDTH; i=i+1)
	  begin
	     vec_next[i] = ~rst_l         ? 1'b0    :
			   wen1_dec_d1[i] ? din1_d1 :
			   wen2_dec_d1[i] ? din2_d1 :
			                    vec[i];
	  end
     end

   // FF's for storage
   dff_ns #(WIDTH) vec_ff (.din(vec_next),
			   .clk(clk),
			   .q(vec));
   
   // Send vector to other clock domain
   dffe_ns #(WIDTH) dout_vec_ff (.din(vec),
				 .en(tx_en),
				 .clk(clk),
				 .q(dout_vec));
   

   // Flop read address
   dff_ns #(INDEX) rd_a_d1_ff (.din(rd_a),
			       .clk(clk),
			       .q(rd_a_d1));

   assign            rd_a_dec_d1 = 1'b1 << rd_a_d1;
   
   assign 	     dout = |(vec & rd_a_dec_d1);

   
endmodule // iobdg_1r2w_vec





// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
