// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_1r1w_rf32.v
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
//  Module Name:	iobdg_1r1w_rf32
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
module iobdg_1r1w_rf32 (/*AUTOARG*/
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
   
   input [4:0] 		     rd_a;
   input [4:0] 		     wr_a;
   input [REG_WIDTH-1:0]     din;
   input 		     wen_l;
   
   output [REG_WIDTH-1:0]    dout;

   wire [4:0] 		     wr_a_d1;
   wire [REG_WIDTH-1:0]      din_d1;
   wire 		     wen_l_d1;
   wire [31:0] 		     wr_a_dec_d1;
   wire [31:0] 		     wen_dec_d1;
   wire [REG_WIDTH-1:0]      line0;
   wire [REG_WIDTH-1:0]      line1;
   wire [REG_WIDTH-1:0]      line2;
   wire [REG_WIDTH-1:0]      line3;
   wire [REG_WIDTH-1:0]      line4;
   wire [REG_WIDTH-1:0]      line5;
   wire [REG_WIDTH-1:0]      line6;
   wire [REG_WIDTH-1:0]      line7;
   wire [REG_WIDTH-1:0]      line8;
   wire [REG_WIDTH-1:0]      line9;
   wire [REG_WIDTH-1:0]      line10;
   wire [REG_WIDTH-1:0]      line11;
   wire [REG_WIDTH-1:0]      line12;
   wire [REG_WIDTH-1:0]      line13;
   wire [REG_WIDTH-1:0]      line14;
   wire [REG_WIDTH-1:0]      line15;
   wire [REG_WIDTH-1:0]      line16;
   wire [REG_WIDTH-1:0]      line17;
   wire [REG_WIDTH-1:0]      line18;
   wire [REG_WIDTH-1:0]      line19;
   wire [REG_WIDTH-1:0]      line20;
   wire [REG_WIDTH-1:0]      line21;
   wire [REG_WIDTH-1:0]      line22;
   wire [REG_WIDTH-1:0]      line23;
   wire [REG_WIDTH-1:0]      line24;
   wire [REG_WIDTH-1:0]      line25;
   wire [REG_WIDTH-1:0]      line26;
   wire [REG_WIDTH-1:0]      line27;
   wire [REG_WIDTH-1:0]      line28;
   wire [REG_WIDTH-1:0]      line29;
   wire [REG_WIDTH-1:0]      line30;
   wire [REG_WIDTH-1:0]      line31;
   wire [4:0] 		     rd_a_d1;
   reg [REG_WIDTH-1:0] 	     dout;
   
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   // Flop write address, write data and write enable
   dff_ns #(5) wr_a_d1_ff (.din(wr_a),
			   .clk(wr_clk),
			   .q(wr_a_d1));

   dff_ns #(REG_WIDTH) din_d1_ff (.din(din),
				  .clk(wr_clk),
				  .q(din_d1));

   dff_ns #(1) wen_l_d1_ff (.din(wen_l),
			    .clk(wr_clk),
			    .q(wen_l_d1));

   assign 	     wr_a_dec_d1 = 1'b1 << wr_a_d1;
   
   assign 	     wen_dec_d1 = {32{~wen_l_d1}} & wr_a_dec_d1;

   
   // FF's for storage
   dffe_ns #(REG_WIDTH) line0_ff (.din(din_d1),.en(wen_dec_d1[0]),.clk(wr_clk),.q(line0));
   dffe_ns #(REG_WIDTH) line1_ff (.din(din_d1),.en(wen_dec_d1[1]),.clk(wr_clk),.q(line1));
   dffe_ns #(REG_WIDTH) line2_ff (.din(din_d1),.en(wen_dec_d1[2]),.clk(wr_clk),.q(line2));
   dffe_ns #(REG_WIDTH) line3_ff (.din(din_d1),.en(wen_dec_d1[3]),.clk(wr_clk),.q(line3));
   dffe_ns #(REG_WIDTH) line4_ff (.din(din_d1),.en(wen_dec_d1[4]),.clk(wr_clk),.q(line4));
   dffe_ns #(REG_WIDTH) line5_ff (.din(din_d1),.en(wen_dec_d1[5]),.clk(wr_clk),.q(line5));
   dffe_ns #(REG_WIDTH) line6_ff (.din(din_d1),.en(wen_dec_d1[6]),.clk(wr_clk),.q(line6));
   dffe_ns #(REG_WIDTH) line7_ff (.din(din_d1),.en(wen_dec_d1[7]),.clk(wr_clk),.q(line7));
   dffe_ns #(REG_WIDTH) line8_ff (.din(din_d1),.en(wen_dec_d1[8]),.clk(wr_clk),.q(line8));
   dffe_ns #(REG_WIDTH) line9_ff (.din(din_d1),.en(wen_dec_d1[9]),.clk(wr_clk),.q(line9));
   dffe_ns #(REG_WIDTH) line10_ff (.din(din_d1),.en(wen_dec_d1[10]),.clk(wr_clk),.q(line10));
   dffe_ns #(REG_WIDTH) line11_ff (.din(din_d1),.en(wen_dec_d1[11]),.clk(wr_clk),.q(line11));
   dffe_ns #(REG_WIDTH) line12_ff (.din(din_d1),.en(wen_dec_d1[12]),.clk(wr_clk),.q(line12));
   dffe_ns #(REG_WIDTH) line13_ff (.din(din_d1),.en(wen_dec_d1[13]),.clk(wr_clk),.q(line13));
   dffe_ns #(REG_WIDTH) line14_ff (.din(din_d1),.en(wen_dec_d1[14]),.clk(wr_clk),.q(line14));
   dffe_ns #(REG_WIDTH) line15_ff (.din(din_d1),.en(wen_dec_d1[15]),.clk(wr_clk),.q(line15));
   dffe_ns #(REG_WIDTH) line16_ff (.din(din_d1),.en(wen_dec_d1[16]),.clk(wr_clk),.q(line16));
   dffe_ns #(REG_WIDTH) line17_ff (.din(din_d1),.en(wen_dec_d1[17]),.clk(wr_clk),.q(line17));
   dffe_ns #(REG_WIDTH) line18_ff (.din(din_d1),.en(wen_dec_d1[18]),.clk(wr_clk),.q(line18));
   dffe_ns #(REG_WIDTH) line19_ff (.din(din_d1),.en(wen_dec_d1[19]),.clk(wr_clk),.q(line19));
   dffe_ns #(REG_WIDTH) line20_ff (.din(din_d1),.en(wen_dec_d1[20]),.clk(wr_clk),.q(line20));
   dffe_ns #(REG_WIDTH) line21_ff (.din(din_d1),.en(wen_dec_d1[21]),.clk(wr_clk),.q(line21));
   dffe_ns #(REG_WIDTH) line22_ff (.din(din_d1),.en(wen_dec_d1[22]),.clk(wr_clk),.q(line22));
   dffe_ns #(REG_WIDTH) line23_ff (.din(din_d1),.en(wen_dec_d1[23]),.clk(wr_clk),.q(line23));
   dffe_ns #(REG_WIDTH) line24_ff (.din(din_d1),.en(wen_dec_d1[24]),.clk(wr_clk),.q(line24));
   dffe_ns #(REG_WIDTH) line25_ff (.din(din_d1),.en(wen_dec_d1[25]),.clk(wr_clk),.q(line25));
   dffe_ns #(REG_WIDTH) line26_ff (.din(din_d1),.en(wen_dec_d1[26]),.clk(wr_clk),.q(line26));
   dffe_ns #(REG_WIDTH) line27_ff (.din(din_d1),.en(wen_dec_d1[27]),.clk(wr_clk),.q(line27));
   dffe_ns #(REG_WIDTH) line28_ff (.din(din_d1),.en(wen_dec_d1[28]),.clk(wr_clk),.q(line28));
   dffe_ns #(REG_WIDTH) line29_ff (.din(din_d1),.en(wen_dec_d1[29]),.clk(wr_clk),.q(line29));
   dffe_ns #(REG_WIDTH) line30_ff (.din(din_d1),.en(wen_dec_d1[30]),.clk(wr_clk),.q(line30));
   dffe_ns #(REG_WIDTH) line31_ff (.din(din_d1),.en(wen_dec_d1[31]),.clk(wr_clk),.q(line31));

   // Flop read address
   dff_ns #(5) rd_a_d1_ff (.din(rd_a),
			   .clk(rd_clk),
			   .q(rd_a_d1));

   // Mux out read data
   always @(/*AUTOSENSE*/line0 or line1 or line10 or line11 or line12
	    or line13 or line14 or line15 or line16 or line17
	    or line18 or line19 or line2 or line20 or line21 or line22
	    or line23 or line24 or line25 or line26 or line27
	    or line28 or line29 or line3 or line30 or line31 or line4
	    or line5 or line6 or line7 or line8 or line9 or rd_a_d1) begin
      case (rd_a_d1)
	5'd0: dout = line0;
	5'd1: dout = line1;
	5'd2: dout = line2;
	5'd3: dout = line3;
	5'd4: dout = line4;
	5'd5: dout = line5;
	5'd6: dout = line6;
	5'd7: dout = line7;
	5'd8: dout = line8;
	5'd9: dout = line9;
	5'd10: dout = line10;
	5'd11: dout = line11;
	5'd12: dout = line12;
	5'd13: dout = line13;
	5'd14: dout = line14;
	5'd15: dout = line15;
	5'd16: dout = line16;
	5'd17: dout = line17;
	5'd18: dout = line18;
	5'd19: dout = line19;
	5'd20: dout = line20;
	5'd21: dout = line21;
	5'd22: dout = line22;
	5'd23: dout = line23;
	5'd24: dout = line24;
	5'd25: dout = line25;
	5'd26: dout = line26;
	5'd27: dout = line27;
	5'd28: dout = line28;
	5'd29: dout = line29;
	5'd30: dout = line30;
	5'd31: dout = line31;
	default: dout = {REG_WIDTH{1'bx}};
      endcase // case(rd_a_d1)
   end
   
   
endmodule // iobdg_1r1w_rf32





// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
