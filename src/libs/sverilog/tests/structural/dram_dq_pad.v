// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_dq_pad.v
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
module dram_dq_pad(/*AUTOARG*/
   // Outputs
   serial_out, io_dram_data_in_hi, io_dram_data_in, dq_pad_clk_so, 
   bso, afi, 
   // Inouts
   pad, 
   // Inputs
   vrefcode, vdd_h, update_dr, testmode_l, test_mode, shift_dr, 
   serial_in, rst_l, arst_l, ps_select, pad_pos_cnt, pad_neg_cnt, out_type, 
   mode_ctrl, hiz_n, dram_io_ptr_clk_inv, dram_io_pad_enable, 
   dram_io_drive_enable, dqs_read, dq_pad_clk_si, dq_pad_clk_se, 
   data_pos, data_neg, clock_dr, clk, cbu, cbd, bypass_in, 
   bypass_enable, burst_length_four, bsi, afo
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			afo;			// To dq_edgelogic of dram_dq_edgelogic.v
input			bsi;			// To sstl_dq_pad of dram_sstl_dq_pad.v
input			burst_length_four;	// To dq_edgelogic of dram_dq_edgelogic.v
input			bypass_enable;		// To sstl_dq_pad of dram_sstl_dq_pad.v
input			bypass_in;		// To sstl_dq_pad of dram_sstl_dq_pad.v
input [8:1]		cbd;			// To sstl_dq_pad of dram_sstl_dq_pad.v
input [8:1]		cbu;			// To sstl_dq_pad of dram_sstl_dq_pad.v
input			clk;			// To dq_edgelogic of dram_dq_edgelogic.v, ...
input			clock_dr;		// To sstl_dq_pad of dram_sstl_dq_pad.v
input			data_neg;		// To dq_edgelogic of dram_dq_edgelogic.v
input			data_pos;		// To dq_edgelogic of dram_dq_edgelogic.v
input			dq_pad_clk_se;		// To dq_edgelogic of dram_dq_edgelogic.v, ...
input			dq_pad_clk_si;		// To dq_edgelogic of dram_dq_edgelogic.v
input			dqs_read;		// To dq_edgelogic of dram_dq_edgelogic.v
input			dram_io_drive_enable;	// To dq_edgelogic of dram_dq_edgelogic.v
input			dram_io_pad_enable;	// To dq_edgelogic of dram_dq_edgelogic.v
input [1:0]		dram_io_ptr_clk_inv;	// To sstl_dq_pad of dram_sstl_dq_pad.v
input			hiz_n;			// To sstl_dq_pad of dram_sstl_dq_pad.v
input			mode_ctrl;		// To sstl_dq_pad of dram_sstl_dq_pad.v
input			out_type;		// To dq_edgelogic of dram_dq_edgelogic.v, ...
input [1:0]		pad_neg_cnt;		// To dq_edgelogic of dram_dq_edgelogic.v
input [1:0]		pad_pos_cnt;		// To dq_edgelogic of dram_dq_edgelogic.v
input			ps_select;		// To sstl_dq_pad of dram_sstl_dq_pad.v
input			rst_l;			// To dq_edgelogic of dram_dq_edgelogic.v
input			arst_l;			// To dq_edgelogic of dram_dq_edgelogic.v
input			serial_in;		// To sstl_dq_pad of dram_sstl_dq_pad.v
input			shift_dr;		// To sstl_dq_pad of dram_sstl_dq_pad.v
input			test_mode;		// To dq_edgelogic of dram_dq_edgelogic.v, ...
input			testmode_l;		// To dq_edgelogic of dram_dq_edgelogic.v
input			update_dr;		// To sstl_dq_pad of dram_sstl_dq_pad.v
input			vdd_h;			// To sstl_dq_pad of dram_sstl_dq_pad.v
input [7:0]		vrefcode;		// To sstl_dq_pad of dram_sstl_dq_pad.v
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
output			afi;			// From dq_edgelogic of dram_dq_edgelogic.v
output			bso;			// From sstl_dq_pad of dram_sstl_dq_pad.v
output			dq_pad_clk_so;		// From dq_edgelogic of dram_dq_edgelogic.v
output			io_dram_data_in;	// From dq_edgelogic of dram_dq_edgelogic.v
output			io_dram_data_in_hi;	// From dq_edgelogic of dram_dq_edgelogic.v
output			serial_out;		// From sstl_dq_pad of dram_sstl_dq_pad.v
// End of automatics

//////////////////////////////////////////////////////////////////////////
// CODE
//////////////////////////////////////////////////////////////////////////
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			oe;			// From dq_edgelogic of dram_dq_edgelogic.v
wire			to_core;		// From sstl_dq_pad of dram_sstl_dq_pad.v
wire			to_pad;			// From dq_edgelogic of dram_dq_edgelogic.v
// End of automatics

// EDGE LOGIC
/*dram_dq_edgelogic AUTO_TEMPLATE(
		  .tp_out_type			(out_type));
*/

dram_dq_edgelogic dq_edgelogic(
			       .dram_io_ptr_clk_inv(dram_io_ptr_clk_inv[1]),
				/*AUTOINST*/
			       // Outputs
			       .io_dram_data_in_hi(io_dram_data_in_hi),
			       .io_dram_data_in(io_dram_data_in),
			       .dq_pad_clk_so(dq_pad_clk_so),
			       .to_pad	(to_pad),
			       .oe	(oe),
			       .afi	(afi),
			       // Inputs
			       .clk	(clk),
			       .rst_l	(rst_l),
			       .arst_l	(arst_l),
			       .dq_pad_clk_se(dq_pad_clk_se),
			       .dq_pad_clk_si(dq_pad_clk_si),
			       .dqs_read(dqs_read),
			       .data_pos(data_pos),
			       .data_neg(data_neg),
			       .pad_pos_cnt(pad_pos_cnt[1:0]),
			       .pad_neg_cnt(pad_neg_cnt[1:0]),
			       .dram_io_drive_enable(dram_io_drive_enable),
			       .dram_io_pad_enable(dram_io_pad_enable),
			       .burst_length_four(burst_length_four),
			       .to_core	(to_core),
			       .testmode_l(testmode_l),
			       .test_mode(test_mode),
			       .tp_out_type(out_type),		 // Templated
			       .afo	(afo));

// SSTL LOGIC

/*dram_sstl_dq_pad AUTO_TEMPLATE(
		  //.si			(edgelogic_so),
		  .se			(dq_pad_clk_se),
		  //.so			(dq_pad_clk_so),
                  .pad                  (pad),
                  .oe                   (oe),
		  .odt_enable_mask      (dram_io_ptr_clk_inv[0]),
                  .data_in              (to_pad));
*/
dram_sstl_dq_pad sstl_dq_pad(/*AUTOINST*/
			     // Outputs
			     .bso	(bso),
			     .to_core	(to_core),
			     .serial_out(serial_out),
			     // Inouts
			     .pad	(pad),			 // Templated
			     // Inputs
			     .test_mode	(test_mode),
			     .se	(dq_pad_clk_se),	 // Templated
			     .vrefcode	(vrefcode[7:0]),
			     .bsi	(bsi),
			     .cbd	(cbd[8:1]),
			     .cbu	(cbu[8:1]),
			     .clock_dr	(clock_dr),
			     .data_in	(to_pad),		 // Templated
			     .hiz_n	(hiz_n),
			     .mode_ctrl	(mode_ctrl),
			     .oe	(oe),			 // Templated
			     .shift_dr	(shift_dr),
			     .update_dr	(update_dr),
			     .vdd_h	(vdd_h),
			     .odt_enable_mask(dram_io_ptr_clk_inv[0]), // Templated
			     .bypass_in	(bypass_in),
			     .serial_in	(serial_in),
			     .bypass_enable(bypass_enable),
			     .ps_select	(ps_select),
			     .clk	(clk),
			     .out_type	(out_type));
endmodule
