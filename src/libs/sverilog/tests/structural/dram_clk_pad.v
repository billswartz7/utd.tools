// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_clk_pad.v
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
module dram_clk_pad(/*AUTOARG*/
   // Outputs
   clk_pad_clk_so, bso, 
   // Inouts
   pad, 
   // Inputs
   vrefcode, vdd_h, update_dr, testmode_l, shift_dr, mode_ctrl, 
   hiz_n, dram_io_clk_enable, clock_dr, clk_value, clk_pad_clk_si, 
   clk_pad_clk_se, clk, cbu, cbd, bsi
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			bsi;			// To sstl_pad of dram_mclk_pad.v
input [8:1]		cbd;			// To sstl_pad of dram_mclk_pad.v
input [8:1]		cbu;			// To sstl_pad of dram_mclk_pad.v
input			clk;			// To clk_edgelogic of dram_clk_edgelogic.v
input			clk_pad_clk_se;		// To clk_edgelogic of dram_clk_edgelogic.v
input			clk_pad_clk_si;		// To clk_edgelogic of dram_clk_edgelogic.v
input			clk_value;		// To clk_edgelogic of dram_clk_edgelogic.v
input			clock_dr;		// To sstl_pad of dram_mclk_pad.v
input			dram_io_clk_enable;	// To clk_edgelogic of dram_clk_edgelogic.v
input			hiz_n;			// To sstl_pad of dram_mclk_pad.v
input			mode_ctrl;		// To sstl_pad of dram_mclk_pad.v
input			shift_dr;		// To sstl_pad of dram_mclk_pad.v
input			testmode_l;		// To clk_edgelogic of dram_clk_edgelogic.v
input			update_dr;		// To sstl_pad of dram_mclk_pad.v
input			vdd_h;			// To sstl_pad of dram_mclk_pad.v
input [7:0]		vrefcode;		// To sstl_pad of dram_mclk_pad.v
// End of automatics

//////////////////////////////////////////////////////////////////////////
// INOUTPUTS
//////////////////////////////////////////////////////////////////////////
inout			pad;

//////////////////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////////////////
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output			bso;			// From sstl_pad of dram_mclk_pad.v
output			clk_pad_clk_so;		// From clk_edgelogic of dram_clk_edgelogic.v
// End of automatics

//////////////////////////////////////////////////////////////////////////
// WIRES
//////////////////////////////////////////////////////////////////////////
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			to_pad;			// From clk_edgelogic of dram_clk_edgelogic.v
// End of automatics

//////////////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////////////

// INSTANTIATING PAD LOGIC

dram_clk_edgelogic clk_edgelogic(/*AUTOINST*/
				 // Outputs
				 .clk_pad_clk_so(clk_pad_clk_so),
				 .to_pad(to_pad),
				 // Inputs
				 .clk	(clk),
				 .testmode_l(testmode_l),
				 .clk_pad_clk_si(clk_pad_clk_si),
				 .clk_pad_clk_se(clk_pad_clk_se),
				 .clk_value(clk_value),
				 .dram_io_clk_enable(dram_io_clk_enable));

// SSTL LOGIC

/*dram_mclk_pad AUTO_TEMPLATE( 
		.data_in		(to_pad),
		.oe			(1'b1),
		.to_core		(),
		.odt_enable_mask	(1'b1),
		.pad			(pad));
*/
dram_mclk_pad sstl_pad(/*AUTOINST*/
		       // Outputs
		       .bso		(bso),
		       .to_core		(),			 // Templated
		       // Inouts
		       .pad		(pad),			 // Templated
		       // Inputs
		       .bsi		(bsi),
		       .cbd		(cbd[8:1]),
		       .cbu		(cbu[8:1]),
		       .clock_dr	(clock_dr),
		       .data_in		(to_pad),		 // Templated
		       .hiz_n		(hiz_n),
		       .mode_ctrl	(mode_ctrl),
		       .odt_enable_mask	(1'b1),			 // Templated
		       .oe		(1'b1),			 // Templated
		       .shift_dr	(shift_dr),
		       .update_dr	(update_dr),
		       .vdd_h		(vdd_h),
		       .vrefcode	(vrefcode[7:0]));
endmodule
