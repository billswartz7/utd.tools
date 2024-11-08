// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_tsr.v
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
module bw_tsr (/*AUTOARG*/
	vdd_tsr,
	div,
	clk,
	reset_l,
	tsel,
   	dout,
   	testio,
	i50,
	v0p5,
	vreg_selbg_l);

	input  vdd_tsr;
	input  [9:1] div;
	input  clk;
	input  reset_l;
	input  [7:0] tsel;
	input  vreg_selbg_l;

   	output [7:0] dout;
   	output [1:0] testio;
	output [7:0] i50;
	output v0p5;

    //synopsys translate_off

//	  integer     	temperature;
//	  reg		dout;
//	  reg		testio;
//	  reg		i50;
//	  reg		v0p5
//   
//	  always @(clk)
//	  begin
//	    dout = 255*(125 - temperature)/100;
//	  end

    //synopsys translate_on

endmodule
