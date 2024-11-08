// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: efc.v
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
//
//    Cluster Name:  Efuse Cluster
//    Unit Name:  efc 
//    Block Name: EFC
//    Files that must be included:  none
//
// Recent changes:
//  - read_mode should be 3 bits
//  - add 1 bit to row addr
//  - add io_pgrm_en directly from the pads (no detour to ctu)
//-----------------------------------------------------------------------------
`include "sys.h"
`include "iop.h"

module efc (/*AUTOARG*/
   // Outputs
   efc_ctu_scanout, efc_ctu_data_out, efc_spc1357_fuse_clk1, 
   efc_spc1357_fuse_clk2, efc_spc0246_fuse_clk1, 
   efc_spc0246_fuse_clk2, efc_spc1357_fuse_data, 
   efc_spc0246_fuse_data, efc_spc7_ifuse_ashift, 
   efc_spc7_ifuse_dshift, efc_spc7_dfuse_ashift, 
   efc_spc7_dfuse_dshift, efc_spc6_ifuse_ashift, 
   efc_spc6_ifuse_dshift, efc_spc6_dfuse_ashift, 
   efc_spc6_dfuse_dshift, efc_spc5_ifuse_ashift, 
   efc_spc5_ifuse_dshift, efc_spc5_dfuse_ashift, 
   efc_spc5_dfuse_dshift, efc_spc4_ifuse_ashift, 
   efc_spc4_ifuse_dshift, efc_spc4_dfuse_ashift, 
   efc_spc4_dfuse_dshift, efc_spc3_ifuse_ashift, 
   efc_spc3_ifuse_dshift, efc_spc3_dfuse_ashift, 
   efc_spc3_dfuse_dshift, efc_spc2_ifuse_ashift, 
   efc_spc2_ifuse_dshift, efc_spc2_dfuse_ashift, 
   efc_spc2_dfuse_dshift, efc_spc1_ifuse_ashift, 
   efc_spc1_ifuse_dshift, efc_spc1_dfuse_ashift, 
   efc_spc1_dfuse_dshift, efc_spc0_ifuse_ashift, 
   efc_spc0_ifuse_dshift, efc_spc0_dfuse_ashift, 
   efc_spc0_dfuse_dshift, efc_sctag02_fuse_clk1, 
   efc_sctag02_fuse_clk2, efc_sctag02_fuse_data, 
   efc_sctag13_fuse_clk1, efc_sctag13_fuse_clk2, 
   efc_sctag13_fuse_data, efc_sctag3_fuse_ashift, 
   efc_sctag3_fuse_dshift, efc_sctag2_fuse_ashift, 
   efc_sctag2_fuse_dshift, efc_sctag1_fuse_ashift, 
   efc_sctag1_fuse_dshift, efc_sctag0_fuse_ashift, 
   efc_sctag0_fuse_dshift, efc_scdata02_fuse_clk1, 
   efc_scdata02_fuse_clk2, efc_scdata02_fuse_data, 
   efc_scdata13_fuse_clk1, efc_scdata13_fuse_clk2, 
   efc_scdata13_fuse_data, efc_scdata3_fuse_ashift, 
   efc_scdata3_fuse_dshift, efc_scdata2_fuse_ashift, 
   efc_scdata2_fuse_dshift, efc_scdata1_fuse_ashift, 
   efc_scdata1_fuse_dshift, efc_scdata0_fuse_ashift, 
   efc_scdata0_fuse_dshift, efc_iob_fuse_clk1, efc_iob_fuse_data, 
   efc_iob_sernum0_dshift, efc_iob_sernum1_dshift, 
   efc_iob_sernum2_dshift, efc_iob_fusestat_dshift, 
   efc_iob_coreavail_dshift, 
   // Inputs
   io_vpp, vddo, jbus_gclk, jbus_arst_l, jbus_grst_l, 
   ctu_tst_scanmode, clk_efc_cken, global_shift_enable, 
   ctu_efc_scanin, jbus_adbginit_l, jbus_gdbginit_l, 
   ctu_tst_pre_grst_l, ctu_tst_scan_disable, ctu_tst_macrotest, 
   ctu_tst_short_chain, ctu_efc_rowaddr, ctu_efc_coladdr, io_pgrm_en, 
   ctu_efc_read_en, ctu_efc_read_mode, ctu_efc_read_start, 
   ctu_efc_fuse_bypass, ctu_efc_dest_sample, ctu_efc_data_in, 
   ctu_efc_updatedr, ctu_efc_shiftdr, ctu_efc_capturedr, tck, 
   spc7_efc_ifuse_data, spc7_efc_dfuse_data, spc6_efc_ifuse_data, 
   spc6_efc_dfuse_data, spc5_efc_ifuse_data, spc5_efc_dfuse_data, 
   spc4_efc_ifuse_data, spc4_efc_dfuse_data, spc3_efc_ifuse_data, 
   spc3_efc_dfuse_data, spc2_efc_ifuse_data, spc2_efc_dfuse_data, 
   spc1_efc_ifuse_data, spc1_efc_dfuse_data, spc0_efc_ifuse_data, 
   spc0_efc_dfuse_data, sctag3_efc_fuse_data, sctag2_efc_fuse_data, 
   sctag1_efc_fuse_data, sctag0_efc_fuse_data, scdata3_efc_fuse_data, 
   scdata2_efc_fuse_data, scdata1_efc_fuse_data, 
   scdata0_efc_fuse_data
   );

//----
// Chip Primary Inputs/Globals
input           io_vpp;                 // Programming Voltage
input		vddo;			// 1.5V I/O voltage supply for 
					//  pgrm_en receiver
input           jbus_gclk;              // input clk (nominally 200 MHz)
input           jbus_arst_l;            // JBus clock domain async reset.
input           jbus_grst_l;            // JBus clock domain reset.
input           ctu_tst_scanmode;       // Scan mode.
input           clk_efc_cken;           // Jbi cluster clock enable.
input           global_shift_enable;    // Scan shift enable signal.
input           ctu_efc_scanin;         // Scan chain input.
output          efc_ctu_scanout;        // Scan chain output.
input           jbus_adbginit_l;        // jbus dbg init (not used)
input           jbus_gdbginit_l;        // jbus dbg init (not used)
input		ctu_tst_pre_grst_l;
input		ctu_tst_scan_disable;
input		ctu_tst_macrotest;
input		ctu_tst_short_chain;

// CTU/JTAG R/W Interface

input [6:0]     ctu_efc_rowaddr;        // Efuse row addr for read/write
input [4:0]     ctu_efc_coladdr;        // efuse col addr for write
input           io_pgrm_en;             // From pad_misc of pad_misc.v
input           ctu_efc_read_en;        // Read Enable
input [2:0]     ctu_efc_read_mode;      // 00=normal, 01=margin0, 10=1A, 11=1B
input           ctu_efc_read_start;     // Start SM for scanning bits out
input           ctu_efc_fuse_bypass;    // shift data from 
input           ctu_efc_dest_sample;	// sample data from dest reg

// CTU/JTAG Shift Interface
input           ctu_efc_data_in;        // Serial(scan) in from ctu
output          efc_ctu_data_out;       // Serial(scan) out to ctu
input           ctu_efc_updatedr;       // read reg updated from shift reg
input           ctu_efc_shiftdr;        // shift data register
input           ctu_efc_capturedr;      // shift data reg captures read reg val
input           tck;                    // Shift dr data in/out from ctu

// Destination Register Interface
output		efc_spc1357_fuse_clk1;
output		efc_spc1357_fuse_clk2;
output		efc_spc0246_fuse_clk1;
output		efc_spc0246_fuse_clk2;
output		efc_spc1357_fuse_data;
output		efc_spc0246_fuse_data;

output		efc_spc7_ifuse_ashift;
output		efc_spc7_ifuse_dshift;
output		efc_spc7_dfuse_ashift;
output		efc_spc7_dfuse_dshift;
input		spc7_efc_ifuse_data;
input		spc7_efc_dfuse_data;

output		efc_spc6_ifuse_ashift;
output		efc_spc6_ifuse_dshift;
output		efc_spc6_dfuse_ashift;
output		efc_spc6_dfuse_dshift;
input		spc6_efc_ifuse_data;
input		spc6_efc_dfuse_data;

output		efc_spc5_ifuse_ashift;
output		efc_spc5_ifuse_dshift;
output		efc_spc5_dfuse_ashift;
output		efc_spc5_dfuse_dshift;
input		spc5_efc_ifuse_data;
input		spc5_efc_dfuse_data;

output		efc_spc4_ifuse_ashift;
output		efc_spc4_ifuse_dshift;
output		efc_spc4_dfuse_ashift;
output		efc_spc4_dfuse_dshift;
input		spc4_efc_ifuse_data;
input		spc4_efc_dfuse_data;

output		efc_spc3_ifuse_ashift;
output		efc_spc3_ifuse_dshift;
output		efc_spc3_dfuse_ashift;
output		efc_spc3_dfuse_dshift;
input		spc3_efc_ifuse_data;
input		spc3_efc_dfuse_data;

output		efc_spc2_ifuse_ashift;
output		efc_spc2_ifuse_dshift;
output		efc_spc2_dfuse_ashift;
output		efc_spc2_dfuse_dshift;
input		spc2_efc_ifuse_data;
input		spc2_efc_dfuse_data;

output		efc_spc1_ifuse_ashift;
output		efc_spc1_ifuse_dshift;
output		efc_spc1_dfuse_ashift;
output		efc_spc1_dfuse_dshift;
input		spc1_efc_ifuse_data;
input		spc1_efc_dfuse_data;

output		efc_spc0_ifuse_ashift;
output		efc_spc0_ifuse_dshift;
output		efc_spc0_dfuse_ashift;
output		efc_spc0_dfuse_dshift;
input		spc0_efc_ifuse_data;
input		spc0_efc_dfuse_data;

output		efc_sctag02_fuse_clk1;
output		efc_sctag02_fuse_clk2;
output		efc_sctag02_fuse_data;
output		efc_sctag13_fuse_clk1;
output		efc_sctag13_fuse_clk2;
output		efc_sctag13_fuse_data;

output		efc_sctag3_fuse_ashift;
output		efc_sctag3_fuse_dshift;
input		sctag3_efc_fuse_data;

output		efc_sctag2_fuse_ashift;
output		efc_sctag2_fuse_dshift;
input		sctag2_efc_fuse_data;

output		efc_sctag1_fuse_ashift;
output		efc_sctag1_fuse_dshift;
input		sctag1_efc_fuse_data;

output		efc_sctag0_fuse_ashift;
output		efc_sctag0_fuse_dshift;
input		sctag0_efc_fuse_data;

output		efc_scdata02_fuse_clk1;
output		efc_scdata02_fuse_clk2;
output		efc_scdata02_fuse_data;
output		efc_scdata13_fuse_clk1;
output		efc_scdata13_fuse_clk2;
output		efc_scdata13_fuse_data;

output		efc_scdata3_fuse_ashift;
output		efc_scdata3_fuse_dshift;
input		scdata3_efc_fuse_data;

output		efc_scdata2_fuse_ashift;
output		efc_scdata2_fuse_dshift;
input		scdata2_efc_fuse_data;

output		efc_scdata1_fuse_ashift;
output		efc_scdata1_fuse_dshift;
input		scdata1_efc_fuse_data;

output		efc_scdata0_fuse_ashift;
output		efc_scdata0_fuse_dshift;
input		scdata0_efc_fuse_data;

output		efc_iob_fuse_clk1;
output		efc_iob_fuse_data;

output		efc_iob_sernum0_dshift;
output		efc_iob_sernum1_dshift;
output		efc_iob_sernum2_dshift;
output		efc_iob_fusestat_dshift;
output		efc_iob_coreavail_dshift;

//-----------------------------------------------------------------------------
// Wire declarations
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire [31:0]		efa_sbc_data;		// From u_efa of bw_r_efa.v
  wire			por_n;			// From u_efa_stdc of efc_stdc.v
  wire			pwr_ok;			// From u_efa_stdc of efc_stdc.v
  wire [4:0]		sbc_efa_bit_addr;	// From u_efa_stdc of efc_stdc.v
  wire			sbc_efa_margin0_rd;	// From u_efa_stdc of efc_stdc.v
  wire			sbc_efa_margin1_rd;	// From u_efa_stdc of efc_stdc.v
  wire			sbc_efa_power_down;	// From u_efa_stdc of efc_stdc.v
  wire			sbc_efa_read_en;	// From u_efa_stdc of efc_stdc.v
  wire			sbc_efa_sup_det_rd;	// From u_efa_stdc of efc_stdc.v
  wire [5:0]		sbc_efa_word_addr;	// From u_efa_stdc of efc_stdc.v
  wire			se;			// From test_stub_scan of test_stub_scan.v
  wire			testmode_l;		// From test_stub_scan of test_stub_scan.v
  // End of automatics
  wire                  io_pgrm_en;             // From pad_misc of pad_misc.v
  wire                  efc_rst_l;

//-----------------------------------------------------------------------------
//  Work in progress
//-----------------------------------------------------------------------------
// Unimplemented/partially implemented signals
//-----------------------------------------------------------------------------
//******************************************************************************
// CLUSTER HEADER
//******************************************************************************
wire            clk_efc_cken;   // Jbi cluster clock enable.
wire            jbus_rclk;
wire		MT_long_chain_so_0;
wire 	  	short_chain_so_0;
wire 	  	so_0;

bw_clk_cl_efc_jbus u_jbus_header (
				   // Outputs
				   .so	(),
				   .dbginit_l(),
				   .cluster_grst_l(efc_rst_l),
				   .rclk(jbus_rclk),
				   // Inputs
				   .si	(1'b0),
				   .se	(1'b0),
				   .adbginit_l(jbus_adbginit_l),
				   .gdbginit_l(jbus_gdbginit_l),
				   .arst_l(jbus_arst_l),
				   .grst_l(jbus_grst_l),
				   .cluster_cken(clk_efc_cken),
				   .gclk(jbus_gclk)
				   );
////////////////////////////////////////////////////////////////////
// Sub-module instantiation
////////////////////////////////////////////////////////////////////
    
/* test_stub_scan AUTO_TEMPLATE (
  // Outputs
  .mux_drive_disable(),
  .mem_write_disable(),
  .sehold	(),
  .se	(se),
  .testmode_l(testmode_l),
  .mem_bypass(),
  .so_0	(so_0),
  .so_1	(),
  .so_2	(),
  // Inputs
  .ctu_tst_pre_grst_l(ctu_tst_pre_grst_l),
  .arst_l	(jbus_arst_l),
  .global_shift_enable(global_shift_enable),
  .ctu_tst_scan_disable(ctu_tst_scan_disable),
  .ctu_tst_scanmode(ctu_tst_scanmode),
  .ctu_tst_macrotest(ctu_tst_macrotest),
  .ctu_tst_short_chain(ctu_tst_short_chain),
  .long_chain_so_0(MT_long_chain_so_0),
  .short_chain_so_0(short_chain_so_0),
  .long_chain_so_1(1'b0),
  .short_chain_so_1(1'b0),
  .long_chain_so_2(1'b0),
  .short_chain_so_2(1'b0));
*/
test_stub_scan test_stub_scan (/*AUTOINST*/
			       // Outputs
			       .mux_drive_disable(),		 // Templated
			       .mem_write_disable(),		 // Templated
			       .sehold	(),			 // Templated
			       .se	(se),			 // Templated
			       .testmode_l(testmode_l),		 // Templated
			       .mem_bypass(),			 // Templated
			       .so_0	(so_0),			 // Templated
			       .so_1	(),			 // Templated
			       .so_2	(),			 // Templated
			       // Inputs
			       .ctu_tst_pre_grst_l(ctu_tst_pre_grst_l), // Templated
			       .arst_l	(jbus_arst_l),		 // Templated
			       .global_shift_enable(global_shift_enable), // Templated
			       .ctu_tst_scan_disable(ctu_tst_scan_disable), // Templated
			       .ctu_tst_scanmode(ctu_tst_scanmode), // Templated
			       .ctu_tst_macrotest(ctu_tst_macrotest), // Templated
			       .ctu_tst_short_chain(ctu_tst_short_chain), // Templated
			       .long_chain_so_0(MT_long_chain_so_0), // Templated
			       .short_chain_so_0(short_chain_so_0), // Templated
			       .long_chain_so_1(1'b0),		 // Templated
			       .short_chain_so_1(1'b0),		 // Templated
			       .long_chain_so_2(1'b0),		 // Templated
			       .short_chain_so_2(1'b0));		 // Templated
//******************************************************************************

/* bw_r_efa  AUTO_TEMPLATE (
               .vpp                     (io_vpp),
               .pi_efa_prog_en          (io_pgrm_en),
               .clk                     (jbus_rclk),
               .so                  (),
               .si                  (1'b0),
               .se                  (1'b0),
 ); */
bw_r_efa u_efa(/*AUTOINST*/
	       // Outputs
	       .efa_sbc_data		(efa_sbc_data[31:0]),
	       .so			(),			 // Templated
	       // Inputs
	       .vpp			(io_vpp),		 // Templated
	       .pi_efa_prog_en		(io_pgrm_en),		 // Templated
	       .sbc_efa_read_en		(sbc_efa_read_en),
	       .sbc_efa_word_addr	(sbc_efa_word_addr[5:0]),
	       .sbc_efa_bit_addr	(sbc_efa_bit_addr[4:0]),
	       .sbc_efa_margin0_rd	(sbc_efa_margin0_rd),
	       .sbc_efa_margin1_rd	(sbc_efa_margin1_rd),
	       .pwr_ok			(pwr_ok),
	       .por_n			(por_n),
	       .sbc_efa_sup_det_rd	(sbc_efa_sup_det_rd),
	       .sbc_efa_power_down	(sbc_efa_power_down),
	       .si			(1'b0),			 // Templated
	       .se			(1'b0),			 // Templated
	       .vddo			(vddo),
	       .clk			(jbus_rclk));		 // Templated
/* efc_stdc AUTO_TEMPLATE (
                    .clk                (jbus_rclk),
); */
efc_stdc u_efa_stdc(/*AUTOINST*/
		    // Outputs
		    .efc_ctu_data_out	(efc_ctu_data_out),
		    .efc_spc1357_fuse_clk1(efc_spc1357_fuse_clk1),
		    .efc_spc1357_fuse_clk2(efc_spc1357_fuse_clk2),
		    .efc_spc0246_fuse_clk1(efc_spc0246_fuse_clk1),
		    .efc_spc0246_fuse_clk2(efc_spc0246_fuse_clk2),
		    .efc_spc1357_fuse_data(efc_spc1357_fuse_data),
		    .efc_spc0246_fuse_data(efc_spc0246_fuse_data),
		    .efc_spc7_ifuse_ashift(efc_spc7_ifuse_ashift),
		    .efc_spc7_ifuse_dshift(efc_spc7_ifuse_dshift),
		    .efc_spc7_dfuse_ashift(efc_spc7_dfuse_ashift),
		    .efc_spc7_dfuse_dshift(efc_spc7_dfuse_dshift),
		    .efc_spc6_ifuse_ashift(efc_spc6_ifuse_ashift),
		    .efc_spc6_ifuse_dshift(efc_spc6_ifuse_dshift),
		    .efc_spc6_dfuse_ashift(efc_spc6_dfuse_ashift),
		    .efc_spc6_dfuse_dshift(efc_spc6_dfuse_dshift),
		    .efc_spc5_ifuse_ashift(efc_spc5_ifuse_ashift),
		    .efc_spc5_ifuse_dshift(efc_spc5_ifuse_dshift),
		    .efc_spc5_dfuse_ashift(efc_spc5_dfuse_ashift),
		    .efc_spc5_dfuse_dshift(efc_spc5_dfuse_dshift),
		    .efc_spc4_ifuse_ashift(efc_spc4_ifuse_ashift),
		    .efc_spc4_ifuse_dshift(efc_spc4_ifuse_dshift),
		    .efc_spc4_dfuse_ashift(efc_spc4_dfuse_ashift),
		    .efc_spc4_dfuse_dshift(efc_spc4_dfuse_dshift),
		    .efc_spc3_ifuse_ashift(efc_spc3_ifuse_ashift),
		    .efc_spc3_ifuse_dshift(efc_spc3_ifuse_dshift),
		    .efc_spc3_dfuse_ashift(efc_spc3_dfuse_ashift),
		    .efc_spc3_dfuse_dshift(efc_spc3_dfuse_dshift),
		    .efc_spc2_ifuse_ashift(efc_spc2_ifuse_ashift),
		    .efc_spc2_ifuse_dshift(efc_spc2_ifuse_dshift),
		    .efc_spc2_dfuse_ashift(efc_spc2_dfuse_ashift),
		    .efc_spc2_dfuse_dshift(efc_spc2_dfuse_dshift),
		    .efc_spc1_ifuse_ashift(efc_spc1_ifuse_ashift),
		    .efc_spc1_ifuse_dshift(efc_spc1_ifuse_dshift),
		    .efc_spc1_dfuse_ashift(efc_spc1_dfuse_ashift),
		    .efc_spc1_dfuse_dshift(efc_spc1_dfuse_dshift),
		    .efc_spc0_ifuse_ashift(efc_spc0_ifuse_ashift),
		    .efc_spc0_ifuse_dshift(efc_spc0_ifuse_dshift),
		    .efc_spc0_dfuse_ashift(efc_spc0_dfuse_ashift),
		    .efc_spc0_dfuse_dshift(efc_spc0_dfuse_dshift),
		    .efc_sctag02_fuse_clk1(efc_sctag02_fuse_clk1),
		    .efc_sctag02_fuse_clk2(efc_sctag02_fuse_clk2),
		    .efc_sctag02_fuse_data(efc_sctag02_fuse_data),
		    .efc_sctag13_fuse_clk1(efc_sctag13_fuse_clk1),
		    .efc_sctag13_fuse_clk2(efc_sctag13_fuse_clk2),
		    .efc_sctag13_fuse_data(efc_sctag13_fuse_data),
		    .efc_sctag3_fuse_ashift(efc_sctag3_fuse_ashift),
		    .efc_sctag3_fuse_dshift(efc_sctag3_fuse_dshift),
		    .efc_sctag2_fuse_ashift(efc_sctag2_fuse_ashift),
		    .efc_sctag2_fuse_dshift(efc_sctag2_fuse_dshift),
		    .efc_sctag1_fuse_ashift(efc_sctag1_fuse_ashift),
		    .efc_sctag1_fuse_dshift(efc_sctag1_fuse_dshift),
		    .efc_sctag0_fuse_ashift(efc_sctag0_fuse_ashift),
		    .efc_sctag0_fuse_dshift(efc_sctag0_fuse_dshift),
		    .efc_scdata02_fuse_clk1(efc_scdata02_fuse_clk1),
		    .efc_scdata02_fuse_clk2(efc_scdata02_fuse_clk2),
		    .efc_scdata02_fuse_data(efc_scdata02_fuse_data),
		    .efc_scdata13_fuse_clk1(efc_scdata13_fuse_clk1),
		    .efc_scdata13_fuse_clk2(efc_scdata13_fuse_clk2),
		    .efc_scdata13_fuse_data(efc_scdata13_fuse_data),
		    .efc_scdata3_fuse_ashift(efc_scdata3_fuse_ashift),
		    .efc_scdata3_fuse_dshift(efc_scdata3_fuse_dshift),
		    .efc_scdata2_fuse_ashift(efc_scdata2_fuse_ashift),
		    .efc_scdata2_fuse_dshift(efc_scdata2_fuse_dshift),
		    .efc_scdata1_fuse_ashift(efc_scdata1_fuse_ashift),
		    .efc_scdata1_fuse_dshift(efc_scdata1_fuse_dshift),
		    .efc_scdata0_fuse_ashift(efc_scdata0_fuse_ashift),
		    .efc_scdata0_fuse_dshift(efc_scdata0_fuse_dshift),
		    .efc_iob_fuse_clk1	(efc_iob_fuse_clk1),
		    .efc_iob_fuse_data	(efc_iob_fuse_data),
		    .efc_iob_sernum0_dshift(efc_iob_sernum0_dshift),
		    .efc_iob_sernum1_dshift(efc_iob_sernum1_dshift),
		    .efc_iob_sernum2_dshift(efc_iob_sernum2_dshift),
		    .efc_iob_fusestat_dshift(efc_iob_fusestat_dshift),
		    .efc_iob_coreavail_dshift(efc_iob_coreavail_dshift),
		    .sbc_efa_read_en	(sbc_efa_read_en),
		    .sbc_efa_word_addr	(sbc_efa_word_addr[5:0]),
		    .sbc_efa_bit_addr	(sbc_efa_bit_addr[4:0]),
		    .sbc_efa_margin0_rd	(sbc_efa_margin0_rd),
		    .sbc_efa_margin1_rd	(sbc_efa_margin1_rd),
		    .pwr_ok		(pwr_ok),
		    .por_n		(por_n),
		    .sbc_efa_sup_det_rd	(sbc_efa_sup_det_rd),
		    .sbc_efa_power_down	(sbc_efa_power_down),
		    // Inputs
		    .clk		(jbus_rclk),		 // Templated
		    .efc_rst_l		(efc_rst_l),
		    .jbus_arst_l	(jbus_arst_l),
		    .testmode_l		(testmode_l),
		    .ctu_efc_rowaddr	(ctu_efc_rowaddr[6:0]),
		    .ctu_efc_coladdr	(ctu_efc_coladdr[4:0]),
		    .ctu_efc_read_en	(ctu_efc_read_en),
		    .ctu_efc_read_mode	(ctu_efc_read_mode[2:0]),
		    .ctu_efc_read_start	(ctu_efc_read_start),
		    .ctu_efc_fuse_bypass(ctu_efc_fuse_bypass),
		    .ctu_efc_dest_sample(ctu_efc_dest_sample),
		    .ctu_efc_data_in	(ctu_efc_data_in),
		    .ctu_efc_updatedr	(ctu_efc_updatedr),
		    .ctu_efc_shiftdr	(ctu_efc_shiftdr),
		    .ctu_efc_capturedr	(ctu_efc_capturedr),
		    .tck		(tck),
		    .spc7_efc_ifuse_data(spc7_efc_ifuse_data),
		    .spc7_efc_dfuse_data(spc7_efc_dfuse_data),
		    .spc6_efc_ifuse_data(spc6_efc_ifuse_data),
		    .spc6_efc_dfuse_data(spc6_efc_dfuse_data),
		    .spc5_efc_ifuse_data(spc5_efc_ifuse_data),
		    .spc5_efc_dfuse_data(spc5_efc_dfuse_data),
		    .spc4_efc_ifuse_data(spc4_efc_ifuse_data),
		    .spc4_efc_dfuse_data(spc4_efc_dfuse_data),
		    .spc3_efc_ifuse_data(spc3_efc_ifuse_data),
		    .spc3_efc_dfuse_data(spc3_efc_dfuse_data),
		    .spc2_efc_ifuse_data(spc2_efc_ifuse_data),
		    .spc2_efc_dfuse_data(spc2_efc_dfuse_data),
		    .spc1_efc_ifuse_data(spc1_efc_ifuse_data),
		    .spc1_efc_dfuse_data(spc1_efc_dfuse_data),
		    .spc0_efc_ifuse_data(spc0_efc_ifuse_data),
		    .spc0_efc_dfuse_data(spc0_efc_dfuse_data),
		    .sctag3_efc_fuse_data(sctag3_efc_fuse_data),
		    .sctag2_efc_fuse_data(sctag2_efc_fuse_data),
		    .sctag1_efc_fuse_data(sctag1_efc_fuse_data),
		    .sctag0_efc_fuse_data(sctag0_efc_fuse_data),
		    .scdata3_efc_fuse_data(scdata3_efc_fuse_data),
		    .scdata2_efc_fuse_data(scdata2_efc_fuse_data),
		    .scdata1_efc_fuse_data(scdata1_efc_fuse_data),
		    .scdata0_efc_fuse_data(scdata0_efc_fuse_data),
		    .efa_sbc_data	(efa_sbc_data[31:0]));


endmodule
// Local Variables:
// verilog-library-directories:("." "../../common/rtl")
// verilog-library-files:      ("../../common/rtl/swrvr_clib.v")
// verilog-auto-sense-defines-constant:t
// End:
