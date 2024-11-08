// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_mem.v
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

module dram_mem (/*AUTOARG*/
   // Outputs
   que_mem_data, listen_out, 
   // Inputs
   que_mem_addr, dram_cpu_wr_addr, dram_cpu_wr_data, dram_clk, clk, 
   dram_cpu_wr_en, margin, sehold, mem_bypass
   );

// DRAM memory compiler interface.
output [255:0]		que_mem_data;
output [64:0]		listen_out;

// Inputs
input [4:0]		que_mem_addr; 	// read enable(bit[4]) + addr(bit3-bit0)
input [3:0]		dram_cpu_wr_addr;
input [63:0]		dram_cpu_wr_data;
input			dram_clk;
input			clk;
input [3:0]		dram_cpu_wr_en;
input [4:0]		margin;
input			sehold;
input			mem_bypass;

//////////////////////////////////////////////////////////////////
// Wires
//////////////////////////////////////////////////////////////////
wire			temp0;
wire			temp1;
wire			temp2;
wire			temp3;
wire			si;

wire [64:0]		listen_out1;
wire [64:0]		listen_out2;
wire [64:0]		listen_out3;

// DRAM Write Data queue - using Memory Compiler
// 64 bit word X 32 entries X 4 instances
// Need to run at 700 MHZ SS, 840 MHZ TT
// Dual ported instances
// Port A is the Write port and port B is the Read port Always

/*bw_rf_16x65 	AUTO_TEMPLATE(
		// OUTPUTS
		.do		({temp@, que_mem_data[@"(+ (* (% @ 4) 64) 63)":@"(* (% @ 4) 64)"]}),
		// INPUTS
		.rd_a		(que_mem_addr[3:0]),
		.wr_a		(dram_cpu_wr_addr[3:0]),
		.di		({1'b0, dram_cpu_wr_data[63:0]}),
		.rd_clk		(dram_clk),
		.wr_clk		(clk),
		.hold		(sehold),
	        .scan_en	(1'b0),
		.csn_rd		(que_mem_addr[4]),
		.csn_wr		(dram_cpu_wr_en[@"(% @ 4)"]),
		.testmux_sel	(mem_bypass),
		.oen		(1'b0));
*/

// Bank0 data buffer
bw_rf_16x65 dramdatawrqent0b01(/*AUTOINST*/
			       // Outputs
			       .so	(so),
			       .do	({temp0, que_mem_data[63:0]}), // Templated
			       .listen_out(listen_out[64:0]),
			       // Inputs
			       .rd_clk	(dram_clk),		 // Templated
			       .wr_clk	(clk),			 // Templated
			       .csn_rd	(que_mem_addr[4]),	 // Templated
			       .csn_wr	(dram_cpu_wr_en[0]),	 // Templated
			       .hold	(sehold),		 // Templated
			       .testmux_sel(mem_bypass),	 // Templated
			       .scan_en	(1'b0),			 // Templated
			       .margin	(margin[4:0]),
			       .rd_a	(que_mem_addr[3:0]),	 // Templated
			       .wr_a	(dram_cpu_wr_addr[3:0]), // Templated
			       .di	({1'b0, dram_cpu_wr_data[63:0]}), // Templated
			       .si	(si));
/*bw_rf_16x65 	AUTO_TEMPLATE(
		// OUTPUTS
		.do		({temp@, que_mem_data[@"(+ (* (% @ 4) 64) 63)":@"(* (% @ 4) 64)"]}),
		// INPUTS
		.rd_a		(que_mem_addr[3:0]),
		.wr_a		(dram_cpu_wr_addr[3:0]),
		.di		({1'b0, dram_cpu_wr_data[63:0]}),
		.rd_clk		(dram_clk),
		.wr_clk		(clk),
		.csn_rd		(que_mem_addr[4]),
		.hold		(sehold),
	        .scan_en	(1'b0),
		.csn_wr		(dram_cpu_wr_en[@"(% @ 4)"]),
		.testmux_sel	(mem_bypass),
		.oen		(1'b0));
*/

bw_rf_16x65 dramdatawrqent1b01(/*AUTOINST*/
			       // Outputs
			       .so	(so),
			       .do	({temp1, que_mem_data[127:64]}), // Templated
			       .listen_out(listen_out1[64:0]),
			       // Inputs
			       .rd_clk	(dram_clk),		 // Templated
			       .wr_clk	(clk),			 // Templated
			       .csn_rd	(que_mem_addr[4]),	 // Templated
			       .csn_wr	(dram_cpu_wr_en[1]),	 // Templated
			       .hold	(sehold),		 // Templated
			       .testmux_sel(mem_bypass),	 // Templated
			       .scan_en	(1'b0),			 // Templated
			       .margin	(margin[4:0]),
			       .rd_a	(que_mem_addr[3:0]),	 // Templated
			       .wr_a	(dram_cpu_wr_addr[3:0]), // Templated
			       .di	({1'b0, dram_cpu_wr_data[63:0]}), // Templated
			       .si	(si));
bw_rf_16x65 dramdatawrqent2b01(/*AUTOINST*/
			       // Outputs
			       .so	(so),
			       .do	({temp2, que_mem_data[191:128]}), // Templated
			       .listen_out(listen_out2[64:0]),
			       // Inputs
			       .rd_clk	(dram_clk),		 // Templated
			       .wr_clk	(clk),			 // Templated
			       .csn_rd	(que_mem_addr[4]),	 // Templated
			       .csn_wr	(dram_cpu_wr_en[2]),	 // Templated
			       .hold	(sehold),		 // Templated
			       .testmux_sel(mem_bypass),	 // Templated
			       .scan_en	(1'b0),			 // Templated
			       .margin	(margin[4:0]),
			       .rd_a	(que_mem_addr[3:0]),	 // Templated
			       .wr_a	(dram_cpu_wr_addr[3:0]), // Templated
			       .di	({1'b0, dram_cpu_wr_data[63:0]}), // Templated
			       .si	(si));
/*bw_rf_16x65 	AUTO_TEMPLATE(
		// OUTPUTS
		.do		({temp@, que_mem_data[@"(+ (* (% @ 4) 64) 63)":@"(* (% @ 4) 64)"]}),
		// INPUTS
		.rd_a		(que_mem_addr[3:0]),
		.wr_a		(dram_cpu_wr_addr[3:0]),
		.di		({1'b0, dram_cpu_wr_data[63:0]}),
		.rd_clk		(dram_clk),
		.wr_clk		(clk),
		.hold		(sehold),
	        .scan_en	(1'b0),
		.csn_rd		(que_mem_addr[4]),
		.csn_wr		(dram_cpu_wr_en[@"(% @ 4)"]),
		.testmux_sel	(mem_bypass),
		.oen		(1'b0));
*/

bw_rf_16x65 dramdatawrqent3b01(/*AUTOINST*/
			       // Outputs
			       .so	(so),
			       .do	({temp3, que_mem_data[255:192]}), // Templated
			       .listen_out(listen_out3[64:0]),
			       // Inputs
			       .rd_clk	(dram_clk),		 // Templated
			       .wr_clk	(clk),			 // Templated
			       .csn_rd	(que_mem_addr[4]),	 // Templated
			       .csn_wr	(dram_cpu_wr_en[3]),	 // Templated
			       .hold	(sehold),		 // Templated
			       .testmux_sel(mem_bypass),	 // Templated
			       .scan_en	(1'b0),			 // Templated
			       .margin	(margin[4:0]),
			       .rd_a	(que_mem_addr[3:0]),	 // Templated
			       .wr_a	(dram_cpu_wr_addr[3:0]), // Templated
			       .di	({1'b0, dram_cpu_wr_data[63:0]}), // Templated
			       .si	(si));
endmodule // dram_mem 

// Local Variables:
// verilog-library-directories:("." "../../srams/rtl")
// End:
