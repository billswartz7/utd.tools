// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_mclk_pad.v
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
module dram_mclk_pad(/*AUTOARG*/
   // Outputs
   to_core, bso, 
   // Inouts
   pad, 
   // Inputs
   vrefcode, vdd_h, update_dr, shift_dr, oe, odt_enable_mask, 
   mode_ctrl, hiz_n, data_in, clock_dr, cbu, cbd, bsi
   );

inout			pad;

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output			bso;			// From dram_pad_scan_jtag of dram_pad_scan_jtag.v
output			to_core;		// From dram_pad_scan_jtag of dram_pad_scan_jtag.v
// End of automatics

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			bsi;			// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input [8:1]		cbd;			// To bw_io_ddr_mclk_txrx of bw_io_ddr_mclk_txrx.v
input [8:1]		cbu;			// To bw_io_ddr_mclk_txrx of bw_io_ddr_mclk_txrx.v
input			clock_dr;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			data_in;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			hiz_n;			// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			mode_ctrl;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			odt_enable_mask;	// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			oe;			// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			shift_dr;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			update_dr;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			vdd_h;			// To bw_io_ddr_mclk_txrx of bw_io_ddr_mclk_txrx.v
input [7:0]		vrefcode;		// To bw_io_ddr_mclk_txrx of bw_io_ddr_mclk_txrx.v
// End of automatics

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			bscan_oe;		// From dram_pad_scan_jtag of dram_pad_scan_jtag.v
wire			data_out;		// From dram_pad_scan_jtag of dram_pad_scan_jtag.v
wire			odt_enable;		// From dram_pad_scan_jtag of dram_pad_scan_jtag.v
wire			rx_out;			// From bw_io_ddr_mclk_txrx of bw_io_ddr_mclk_txrx.v
// End of automatics


/////////////////////
// TRANSCEIVER module
/////////////////////

/* bw_io_ddr_mclk_txrx AUTO_TEMPLATE(
                            // Outputs
                            .out        (rx_out),
                            // Inputs
                            .data       (data_out),
                            .oe         (bscan_oe));
*/

bw_io_ddr_mclk_txrx bw_io_ddr_mclk_txrx(/*AUTOINST*/
				      // Outputs
				      .out(rx_out),		 // Templated
				      // Inouts
				      .pad(pad),
				      // Inputs
				      .vrefcode(vrefcode[7:0]),
				      .odt_enable(odt_enable),
				      .vdd_h(vdd_h),
				      .cbu(cbu[8:1]),
				      .cbd(cbd[8:1]),
				      .data(data_out),		 // Templated
				      .oe(bscan_oe));		 // Templated
/////////////////////
// SCAN & JTAG module
/////////////////////

/*dram_pad_scan_jtag    AUTO_TEMPLATE(
                                           // Outputs
                                           .oe(bscan_oe),
                                           // Inputs
                                           .rcv_in(rx_out),
                                           .drv_oe(oe));
*/

bw_io_sstl_bscan	bw_io_sstl_bscan(/*AUTOINST*/
					   // Outputs
					   .to_core(to_core),
					   .data_out(data_out),
					   .oe(bscan_oe),	 // Templated
					   .bso(bso),
					   .odt_enable(odt_enable),
					   // Inputs
					   .bsi(bsi),
					   .mode_ctrl(mode_ctrl),
					   .clock_dr(clock_dr),
					   .shift_dr(shift_dr),
					   .update_dr(update_dr),
					   .hiz_l(hiz_n),
					   .rcv_in(rx_out),	 // Templated
					   .data_in(data_in),
					   .drv_oe(oe),		 // Templated
					   .odt_enable_mask(odt_enable_mask));
endmodule
// Local Variables:
// verilog-library-directories:(".") 
