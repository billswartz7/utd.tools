// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_rng.v
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
module bw_rng (/*AUTOARG*/
	// Outputs
	rng_data, rng_clk, 
	// Inputs
 	vsup_rng_hv18, sel_bg_l, vctrl, clk_jbus, rst_l 
   	);

 	input	vsup_rng_hv18;
	input	sel_bg_l;
	input [2:0] vctrl;
	input 	clk_jbus;
	input 	rst_l ;
   	output rng_data;
   	output rng_clk;

   	//synopsys translate_off
   	integer     	seed;
   	reg		rand_num;
   	reg		rng_clk;
   	reg		rng_data;
   
   	initial
   	begin
	  seed = 2;
      	  rng_clk = 1'b0;
   	end
   
   	always 
        begin
	  #500000 rng_clk = ~rng_clk;  //period of 1000000 ps
	  rand_num = $random (seed) & rst_l;
	  rng_data = rand_num;
     	end
   //synopsys translate_on

endmodule // bw_rng

  
