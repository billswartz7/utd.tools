// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_ctl_pad.v
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
module dram_ctl_pad(/*AUTOARG*/
   // Outputs
   ctl_pad_clk_so, bso, 
   // Inouts
   pad, 
   // Inputs
   vrefcode, vdd_h, update_dr, testmode_l, shift_dr, rst_l, 
   mode_ctrl, hiz_n, data, ctl_pad_clk_si, ctl_pad_clk_se, clock_dr, 
   clk, cbu, cbd, bsi
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			bsi;			// To sstl_pad of dram_sstl_pad.v
input [8:1]		cbd;			// To sstl_pad of dram_sstl_pad.v
input [8:1]		cbu;			// To sstl_pad of dram_sstl_pad.v
input			clk;			// To ctl_edgelogic of dram_ctl_edgelogic.v
input			clock_dr;		// To sstl_pad of dram_sstl_pad.v
input			ctl_pad_clk_se;		// To ctl_edgelogic of dram_ctl_edgelogic.v
input			ctl_pad_clk_si;		// To ctl_edgelogic of dram_ctl_edgelogic.v
input			data;			// To ctl_edgelogic of dram_ctl_edgelogic.v
input			hiz_n;			// To sstl_pad of dram_sstl_pad.v
input			mode_ctrl;		// To sstl_pad of dram_sstl_pad.v
input			rst_l;			// To ctl_edgelogic of dram_ctl_edgelogic.v
input			shift_dr;		// To sstl_pad of dram_sstl_pad.v
input			testmode_l;		// To ctl_edgelogic of dram_ctl_edgelogic.v
input			update_dr;		// To sstl_pad of dram_sstl_pad.v
input			vdd_h;			// To sstl_pad of dram_sstl_pad.v
input [7:0]		vrefcode;		// To sstl_pad of dram_sstl_pad.v
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
output			bso;			// From sstl_pad of dram_sstl_pad.v
output			ctl_pad_clk_so;		// From ctl_edgelogic of dram_ctl_edgelogic.v
// End of automatics

//////////////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////////////
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			to_pad;			// From ctl_edgelogic of dram_ctl_edgelogic.v
// End of automatics

// INSTANTIATING PAD LOGIC

dram_ctl_edgelogic ctl_edgelogic(/*AUTOINST*/
				 // Outputs
				 .ctl_pad_clk_so(ctl_pad_clk_so),
				 .to_pad(to_pad),
				 // Inputs
				 .clk	(clk),
				 .rst_l	(rst_l),
				 .testmode_l(testmode_l),
				 .ctl_pad_clk_se(ctl_pad_clk_se),
				 .ctl_pad_clk_si(ctl_pad_clk_si),
				 .data	(data));

// SSTL LOGIC

/*dram_sstl_pad AUTO_TEMPLATE(
                  .pad                  (pad),
                  .oe                  	(1'b1),
		  .to_core		(),
		  .odt_enable_mask	(1'b1),
                  .data_in              (to_pad));
*/

dram_sstl_pad sstl_pad(/*AUTOINST*/
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
