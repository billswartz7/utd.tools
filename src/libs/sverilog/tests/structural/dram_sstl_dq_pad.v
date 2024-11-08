// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_sstl_dq_pad.v
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
module dram_sstl_dq_pad(/*AUTOARG*/
   // Outputs
   bso, to_core, serial_out, 
   // Inouts
   pad, 
   // Inputs
   test_mode, se, vrefcode, bsi, cbd, cbu, clock_dr, data_in, hiz_n, 
   mode_ctrl, oe, shift_dr, update_dr, vdd_h, odt_enable_mask, 
   bypass_in, serial_in, bypass_enable, ps_select, clk, out_type
   );

inout			pad;

/*UTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output			bso;			// From dram_pad_scan_jtag of dram_pad_scan_jtag.v
output			to_core;		// From dram_pad_scan_jtag of dram_pad_scan_jtag.v
output			serial_out;		// From dram_pad_scan_jtag of dram_pad_scan_jtag.v
// End of automatics

/*UTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			test_mode;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			se;			// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input [7:0]		vrefcode;		// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input			bsi;			// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input [8:1]		cbd;			// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input [8:1]		cbu;			// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input			clock_dr;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			data_in;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			hiz_n;			// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			mode_ctrl;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			oe;			// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			shift_dr;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			update_dr;		// To dram_pad_scan_jtag of dram_pad_scan_jtag.v
input			vdd_h;			// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input			odt_enable_mask;	// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input			bypass_in;		// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input			serial_in;		// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input			bypass_enable;		// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input			ps_select;		// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input			clk;			// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
input			out_type;		// To bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
// End of automatics

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			bscan_oe;		// From bw_io_sstl_dq_bscan of bw_io_sstl_dq_bscan.v
wire			data_out;		// From bw_io_sstl_dq_bscan of bw_io_sstl_dq_bscan.v
wire			odt_enable;		// From bw_io_sstl_dq_bscan of bw_io_sstl_dq_bscan.v
wire			rx_out;			// From bw_io_ddr_pad_txrx of bw_io_ddr_pad_txrx.v
// End of automatics


/////////////////////
// TRANSCEIVER module
/////////////////////

/* bw_io_ddr_pad_txrx AUTO_TEMPLATE(
                            // Outputs
                            .out        (rx_out),
                            // Inputs
                            .data       (data_out),
                            .oe         (bscan_oe));
*/

bw_io_ddr_pad_txrx bw_io_ddr_pad_txrx(/*AUTOINST*/
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

/*bw_io_sstl_dq_bscan    AUTO_TEMPLATE(
                                           // Outputs
                                           .oe(bscan_oe),
                                           // Inputs
					   .hiz_l(hiz_n),
                                           .rcv_in(rx_out),
                                           .drv_oe(oe));
*/

bw_io_sstl_dq_bscan	bw_io_sstl_dq_bscan(/*AUTOINST*/
					    // Outputs
					    .data_out(data_out),
					    .serial_out(serial_out),
					    .bso(bso),
					    .odt_enable(odt_enable),
					    .oe(bscan_oe),	 // Templated
					    .to_core(to_core),
					    // Inputs
					    .update_dr(update_dr),
					    .out_type(out_type),
					    .clk(clk),
					    .shift_dr(shift_dr),
					    .bypass_in(bypass_in),
					    .serial_in(serial_in),
					    .bypass_enable(bypass_enable),
					    .data_in(data_in),
					    .ps_select(ps_select),
					    .rcv_in(rx_out),	 // Templated
					    .drv_oe(oe),	 // Templated
					    .odt_enable_mask(odt_enable_mask),
					    .se(se),
					    .test_mode(test_mode),
					    .hiz_l(hiz_n),	 // Templated
					    .clock_dr(clock_dr),
					    .bsi(bsi),
					    .mode_ctrl(mode_ctrl));
endmodule
// Local Variables:
// verilog-library-directories:("." "../../pad_common/rtl/") 
