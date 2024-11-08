// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_dqs_pad.v
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
module dram_dqs_pad(/*AUTOARG*/
   // Outputs
   dqs_pad_clk_so, clk_sel, bso, 
   // Inouts
   pad, 
   // Inputs
   vrefcode, vdd_h, update_dr, testmode_l, shift_dr, odt_enable_mask, 
   mode_ctrl, hiz_n, dram_io_drive_enable, dram_io_drive_data, 
   dram_io_channel_disabled, dqs_pad_clk_si, dqs_pad_clk_se, 
   clock_dr, clk, cbu, cbd, bsi
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			bsi;			// To sstl_pad of dram_sstl_pad.v
input [8:1]		cbd;			// To sstl_pad of dram_sstl_pad.v
input [8:1]		cbu;			// To sstl_pad of dram_sstl_pad.v
input			clk;			// To dqs_edgelogic of dram_dqs_edgelogic.v
input			clock_dr;		// To sstl_pad of dram_sstl_pad.v
input			dqs_pad_clk_se;		// To dqs_edgelogic of dram_dqs_edgelogic.v
input			dqs_pad_clk_si;		// To dqs_edgelogic of dram_dqs_edgelogic.v
input			dram_io_channel_disabled;// To dqs_edgelogic of dram_dqs_edgelogic.v
input			dram_io_drive_data;	// To dqs_edgelogic of dram_dqs_edgelogic.v
input			dram_io_drive_enable;	// To dqs_edgelogic of dram_dqs_edgelogic.v
input			hiz_n;			// To sstl_pad of dram_sstl_pad.v
input			mode_ctrl;		// To sstl_pad of dram_sstl_pad.v
input			odt_enable_mask;	// To sstl_pad of dram_sstl_pad.v
input			shift_dr;		// To sstl_pad of dram_sstl_pad.v
input			testmode_l;		// To dqs_edgelogic of dram_dqs_edgelogic.v
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
output			clk_sel;		// From dqs_edgelogic of dram_dqs_edgelogic.v
output			dqs_pad_clk_so;		// From dqs_edgelogic of dram_dqs_edgelogic.v
// End of automatics

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			oe;			// From dqs_edgelogic of dram_dqs_edgelogic.v
wire			to_core;		// From sstl_pad of dram_sstl_pad.v
wire			to_pad;			// From dqs_edgelogic of dram_dqs_edgelogic.v
// End of automatics

//////////////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////////////

// INSTANTIATING PAD LOGIC
dram_dqs_edgelogic dqs_edgelogic(/*AUTOINST*/
				 // Outputs
				 .clk_sel(clk_sel),
				 .dqs_pad_clk_so(dqs_pad_clk_so),
				 .to_pad(to_pad),
				 .oe	(oe),
				 // Inputs
				 .clk	(clk),
				 .testmode_l(testmode_l),
				 .dqs_pad_clk_se(dqs_pad_clk_se),
				 .dqs_pad_clk_si(dqs_pad_clk_si),
				 .dram_io_drive_enable(dram_io_drive_enable),
				 .dram_io_drive_data(dram_io_drive_data),
				 .dram_io_channel_disabled(dram_io_channel_disabled),
				 .to_core(to_core));

// SSTL LOGIC

/*dram_sstl_pad AUTO_TEMPLATE(
                  .pad                  (pad),
                  .oe                   (oe),
                  .data_in              (to_pad));
*/
dram_sstl_pad sstl_pad(/*AUTOINST*/
		       // Outputs
		       .bso		(bso),
		       .to_core		(to_core),
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
		       .odt_enable_mask	(odt_enable_mask),
		       .oe		(oe),			 // Templated
		       .shift_dr	(shift_dr),
		       .update_dr	(update_dr),
		       .vdd_h		(vdd_h),
		       .vrefcode	(vrefcode[7:0]));
endmodule
