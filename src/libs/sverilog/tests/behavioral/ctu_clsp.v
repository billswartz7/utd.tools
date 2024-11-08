// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp.v
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
//    Cluster Name:  CTU
//    Unit Name: ctu_clsp
//
//-----------------------------------------------------------------------------

`include "sys.h"
`include "iop.h"
`include "ctu.h"

module ctu_clsp(/*AUTOARG*/
// Outputs
pll_reset_ref_l, jbus_grst_out_l, jbus_gdbginit_out_l, jbus_gclk_out, 
jbus_gclk_dup_out, jbus_arst_l, jbus_adbginit_l, dram_grst_out_l, 
dram_gdbginit_out_l, dram_gclk_out, dram_arst_l, dram_adbginit_l, 
ctu_tst_pre_grst_l, ctu_spc_const_maskid, ctu_sparc7_cmp_cken, 
ctu_sparc6_cmp_cken, ctu_sparc5_cmp_cken, ctu_sparc4_cmp_cken, 
ctu_sparc3_cmp_cken, ctu_sparc2_cmp_cken, ctu_sparc1_cmp_cken, 
ctu_sparc0_cmp_cken, ctu_sctag3_cmp_cken, ctu_sctag2_cmp_cken, 
ctu_sctag1_cmp_cken, ctu_sctag0_cmp_cken, ctu_scdata3_cmp_cken, 
ctu_scdata2_cmp_cken, ctu_scdata1_cmp_cken, ctu_scdata0_cmp_cken, 
ctu_misc_jbus_cken, ctu_jbusr_jbus_cken, ctu_jbusl_jbus_cken, 
ctu_jbus_tx_sync_out, ctu_jbi_ssiclk, ctu_jbi_jbus_cken, 
ctu_jbi_cmp_cken, ctu_iob_wake_thr, ctu_iob_resetstat_wr, 
ctu_iob_resetstat, ctu_iob_jbus_cken, ctu_iob_cmp_cken, ctu_io_j_err, 
ctu_fpu_cmp_cken, ctu_efc_read_start, ctu_efc_jbus_cken, 
ctu_dram_tx_sync_out, ctu_dram_selfrsh, ctu_dram_rx_sync_out, 
ctu_dram13_jbus_cken, ctu_dram13_dram_cken, ctu_dram13_cmp_cken, 
ctu_dram02_jbus_cken, ctu_dram02_dram_cken, ctu_dram02_cmp_cken, 
ctu_dll3_byp_val, ctu_dll3_byp_l, ctu_dll2_byp_val, ctu_dll2_byp_l, 
ctu_dll1_byp_val, ctu_dll1_byp_l, ctu_dll0_byp_val, ctu_dll0_byp_l, 
ctu_ddr3_iodll_rst_l, ctu_ddr3_dram_cken, ctu_ddr3_dll_delayctr, 
ctu_ddr2_iodll_rst_l, ctu_ddr2_dram_cken, ctu_ddr2_dll_delayctr, 
ctu_ddr1_iodll_rst_l, ctu_ddr1_dram_cken, ctu_ddr1_dll_delayctr, 
ctu_ddr0_dram_cken, ctu_ddr0_dll_delayctr, ctu_dbg_jbus_cken, 
ctu_ccx_cmp_cken, cmp_grst_out_l, cmp_gdbginit_out_l, cmp_gclk_out, 
cmp_arst_l, cmp_adbginit_l, clsp_iob_vld, clsp_iob_stall, 
clsp_iob_data, clsp_bist_type, clsp_bist_dobist, clsp_bist_ctrl, 
ctu_ddr0_iodll_rst_l, ctu_jbus_rx_sync_out, start_clk_jl, 
start_clk_early_jl, 
// Inputs
testmode_l, se, sctag3_ctu_tr, sctag2_ctu_tr, sctag1_ctu_tr, 
sctag0_ctu_tr, pll_raw_clk_out, pll_clk_out_pre_l, pll_clk_out_pre, 
pll_clk_out_l, pll_clk_out, mask_minor_id, mask_major_id, 
jtag_nstep_vld, jtag_nstep_domain, jtag_nstep_count, 
jtag_clsp_stop_id_vld, jtag_clsp_stop_id, jtag_clsp_sel_tck2, 
jtag_clsp_sel_jbus, jtag_clsp_sel_dram, jtag_clsp_sel_cpu, 
jtag_clsp_ignore_wrm_rst, jtag_clsp_force_cken_jbus, 
jtag_clsp_force_cken_dram, jtag_clsp_force_cken_cmp, jtag_clock_dr, 
jbus_tx_sync, jbus_rx_sync, jbus_rst_l, jbus_gclk, jbus_clk, 
jbi_ctu_tr, iob_ctu_tr, iob_ctu_l2_tr, iob_clsp_vld, iob_clsp_stall, 
iob_clsp_data, io_tck2, io_pwron_rst_l, io_pll_char_in, io_j_rst_l, 
io_do_bist, io_clk_stretch, dram_gclk, dram13_ctu_tr, dram02_ctu_tr, 
dll3_ctu_ctrl, dll2_ctu_ctrl, dll1_ctu_ctrl, dll0_ctu_ctrl, 
dft_wake_thr, dft_clsp_nstep_capture_l, ddr3_ctu_dll_overflow, 
ddr3_ctu_dll_lock, ddr2_ctu_dll_overflow, ddr2_ctu_dll_lock, 
ddr1_ctu_dll_overflow, ddr1_ctu_dll_lock, ddr0_ctu_dll_overflow, 
ddr0_ctu_dll_lock, ctu_dram_tx_sync_early, cmp_gclk, cmp_clk
);

   //parameter IOB_UCB_WIDTH = 32;  // data bus width from IOB to UCB
   //parameter UCB_IOB_WIDTH = 8;   // data bus width from UCB to IOB
   parameter REG_WIDTH = 64;      // set this to 128 if unit needs to
                                  // return 128-bit data




/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			cmp_clk;		// To u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v, ...
input			cmp_gclk;		// To u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v, ...
input			ctu_dram_tx_sync_early;	// To u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v, ...
input			ddr0_ctu_dll_lock;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			ddr0_ctu_dll_overflow;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			ddr1_ctu_dll_lock;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			ddr1_ctu_dll_overflow;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			ddr2_ctu_dll_lock;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			ddr2_ctu_dll_overflow;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			ddr3_ctu_dll_lock;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			ddr3_ctu_dll_overflow;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			dft_clsp_nstep_capture_l;// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input			dft_wake_thr;		// To u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
input [4:0]		dll0_ctu_ctrl;		// To u_ctu_clsp_creg of ctu_clsp_creg.v
input [4:0]		dll1_ctu_ctrl;		// To u_ctu_clsp_creg of ctu_clsp_creg.v
input [4:0]		dll2_ctu_ctrl;		// To u_ctu_clsp_creg of ctu_clsp_creg.v
input [4:0]		dll3_ctu_ctrl;		// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			dram02_ctu_tr;		// To u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
input			dram13_ctu_tr;		// To u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
input			dram_gclk;		// To u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
input			io_clk_stretch;		// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			io_do_bist;		// To u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
input			io_j_rst_l;		// To u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
input			io_pll_char_in;		// To u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
input			io_pwron_rst_l;		// To u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v, ...
input			io_tck2;		// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input [`IOB_CLK_WIDTH-1:0]iob_clsp_data;	// To u_ctu_clsp_ucb of ucb_noflow.v
input			iob_clsp_stall;		// To u_ctu_clsp_ucb of ucb_noflow.v
input			iob_clsp_vld;		// To u_ctu_clsp_ucb of ucb_noflow.v
input			iob_ctu_l2_tr;		// To u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
input			iob_ctu_tr;		// To u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
input			jbi_ctu_tr;		// To u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
input			jbus_clk;		// To u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v, ...
input			jbus_gclk;		// To u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
input			jbus_rst_l;		// To u_ctu_clsp_ucb of ucb_noflow.v, ...
input			jbus_rx_sync;		// To u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v, ...
input			jbus_tx_sync;		// To u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v, ...
input			jtag_clock_dr;		// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input			jtag_clsp_force_cken_cmp;// To u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v, ...
input			jtag_clsp_force_cken_dram;// To u_ctu_clsp_dramgif of ctu_clsp_dramgif.v, ...
input			jtag_clsp_force_cken_jbus;// To u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v, ...
input			jtag_clsp_ignore_wrm_rst;// To u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
input [2:0]		jtag_clsp_sel_cpu;	// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input [2:0]		jtag_clsp_sel_dram;	// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input [2:0]		jtag_clsp_sel_jbus;	// To u_ctu_clsp_creg of ctu_clsp_creg.v, ...
input			jtag_clsp_sel_tck2;	// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input [5:0]		jtag_clsp_stop_id;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			jtag_clsp_stop_id_vld;	// To u_ctu_clsp_creg of ctu_clsp_creg.v
input [3:0]		jtag_nstep_count;	// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input [2:0]		jtag_nstep_domain;	// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input			jtag_nstep_vld;		// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input [3:0]		mask_major_id;		// To u_ctu_clsp_creg of ctu_clsp_creg.v
input [3:0]		mask_minor_id;		// To u_ctu_clsp_creg of ctu_clsp_creg.v
input			pll_clk_out;		// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input			pll_clk_out_l;		// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input			pll_clk_out_pre;	// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input			pll_clk_out_pre_l;	// To u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
input			pll_raw_clk_out;	// To u_ctu_clsp_pllcnt of ctu_clsp_pllcnt.v, ...
input			sctag0_ctu_tr;		// To u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
input			sctag1_ctu_tr;		// To u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
input			sctag2_ctu_tr;		// To u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
input			sctag3_ctu_tr;		// To u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
input			se;			// To u_ctu_clsp_creg of ctu_clsp_creg.v, ...
input			testmode_l;		// To u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v, ...
// End of automatics
/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output [5:0]		clsp_bist_ctrl;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output			clsp_bist_dobist;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output			clsp_bist_type;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output [`CLK_IOB_WIDTH-1:0]clsp_iob_data;	// From u_ctu_clsp_ucb of ucb_noflow.v
output			clsp_iob_stall;		// From u_ctu_clsp_ucb of ucb_noflow.v
output			clsp_iob_vld;		// From u_ctu_clsp_ucb of ucb_noflow.v
output			cmp_adbginit_l;		// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			cmp_arst_l;		// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			cmp_gclk_out;		// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
output			cmp_gdbginit_out_l;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			cmp_grst_out_l;		// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_ccx_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_dbg_jbus_cken;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output [2:0]		ctu_ddr0_dll_delayctr;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output			ctu_ddr0_dram_cken;	// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output [2:0]		ctu_ddr1_dll_delayctr;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output			ctu_ddr1_dram_cken;	// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output			ctu_ddr1_iodll_rst_l;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output [2:0]		ctu_ddr2_dll_delayctr;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output			ctu_ddr2_dram_cken;	// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output			ctu_ddr2_iodll_rst_l;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output [2:0]		ctu_ddr3_dll_delayctr;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output			ctu_ddr3_dram_cken;	// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output			ctu_ddr3_iodll_rst_l;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output			ctu_dll0_byp_l;		// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output [4:0]		ctu_dll0_byp_val;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output			ctu_dll1_byp_l;		// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output [4:0]		ctu_dll1_byp_val;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output			ctu_dll2_byp_l;		// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output [4:0]		ctu_dll2_byp_val;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output			ctu_dll3_byp_l;		// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output [4:0]		ctu_dll3_byp_val;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
output			ctu_dram02_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_dram02_dram_cken;	// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output			ctu_dram02_jbus_cken;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			ctu_dram13_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_dram13_dram_cken;	// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output			ctu_dram13_jbus_cken;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			ctu_dram_rx_sync_out;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_dram_selfrsh;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output			ctu_dram_tx_sync_out;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_efc_jbus_cken;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			ctu_efc_read_start;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output			ctu_fpu_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_io_j_err;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output			ctu_iob_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_iob_jbus_cken;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output [2:0]		ctu_iob_resetstat;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output			ctu_iob_resetstat_wr;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output			ctu_iob_wake_thr;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output			ctu_jbi_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_jbi_jbus_cken;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			ctu_jbi_ssiclk;		// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
output			ctu_jbus_tx_sync_out;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_jbusl_jbus_cken;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			ctu_jbusr_jbus_cken;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			ctu_misc_jbus_cken;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			ctu_scdata0_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_scdata1_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_scdata2_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_scdata3_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sctag0_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sctag1_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sctag2_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sctag3_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sparc0_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sparc1_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sparc2_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sparc3_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sparc4_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sparc5_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sparc6_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output			ctu_sparc7_cmp_cken;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output [7:0]		ctu_spc_const_maskid;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
output			ctu_tst_pre_grst_l;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
output			dram_adbginit_l;	// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output			dram_arst_l;		// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output			dram_gclk_out;		// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
output			dram_gdbginit_out_l;	// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output			dram_grst_out_l;	// From u_ctu_clsp_dramgif of ctu_clsp_dramgif.v
output			jbus_adbginit_l;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			jbus_arst_l;		// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			jbus_gclk_dup_out;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
output			jbus_gclk_out;		// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
output			jbus_gdbginit_out_l;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			jbus_grst_out_l;	// From u_ctu_clsp_jbusgif of ctu_clsp_jbusgif.v
output			pll_reset_ref_l;	// From u_ctu_clsp_pllcnt of ctu_clsp_pllcnt.v
// End of automatics
output                  ctu_ddr0_iodll_rst_l ;
output			ctu_jbus_rx_sync_out;	// From u_ctu_clsp_cmpgif of ctu_clsp_cmpgif.v
output                  start_clk_jl;
output                  start_clk_early_jl;

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			a_dbginit_cl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			a_dbginit_dg;		// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			a_dbginit_dl;		// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			a_dbginit_jl;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			a_grst_cl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			a_grst_dg;		// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			a_grst_dl;		// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			a_grst_jl;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			clk_stretch_cnt_val_6;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			clk_stretch_cnt_val_odd;// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			clk_stretch_trig;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [63:0]		clkctrl_data_in_reg;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			clkctrl_dn_cl;		// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			clkctrl_dn_jl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire [63:0]		clsp_ctrl_rd_bus_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			clsp_ctrl_srarm_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			clsp_ctrl_srarm_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			clsp_ctrl_srarm_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire [`UCB_BUF_HI-`UCB_BUF_LO:0]clsp_ucb_buf_id_out;// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [REG_WIDTH-1:0]	clsp_ucb_data_out;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			clsp_ucb_rd_ack_vld;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			clsp_ucb_rd_nack_vld;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [`UCB_THR_HI-`UCB_THR_LO:0]clsp_ucb_thr_id_out;// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			cmp_dbginit_cl_l;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			cmp_grst_cl_l;		// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			coin_edge;		// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			creg_cken_vld_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			creg_cken_vld_jl;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			ctu_ccx_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_ccx_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_dbg_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_dbg_cken_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			ctu_dbg_cken_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_ddr0_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire [2:0]		ctu_ddr0_dll_delayctr_jl;// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			ctu_ddr0_dram_cken_dg;	// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			ctu_ddr0_dram_cken_dl;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
wire			ctu_ddr0_iodll_rst_jl_l;// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			ctu_ddr1_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire [2:0]		ctu_ddr1_dll_delayctr_jl;// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			ctu_ddr1_dram_cken_dg;	// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			ctu_ddr1_dram_cken_dl;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
wire			ctu_ddr1_iodll_rst_jl_l;// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			ctu_ddr2_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire [2:0]		ctu_ddr2_dll_delayctr_jl;// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			ctu_ddr2_dram_cken_dg;	// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			ctu_ddr2_dram_cken_dl;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
wire			ctu_ddr2_iodll_rst_jl_l;// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			ctu_ddr3_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire [2:0]		ctu_ddr3_dll_delayctr_jl;// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			ctu_ddr3_dram_cken_dg;	// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			ctu_ddr3_dram_cken_dl;	// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
wire			ctu_ddr3_iodll_rst_jl_l;// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			ctu_dll0_byp_l_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		ctu_dll0_byp_val_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			ctu_dll1_byp_l_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		ctu_dll1_byp_val_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			ctu_dll2_byp_l_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		ctu_dll2_byp_val_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			ctu_dll3_byp_l_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		ctu_dll3_byp_val_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			ctu_dram02_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_dram02_cken_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			ctu_dram02_cken_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_dram02_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_dram02_dram_cken_dg;// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			ctu_dram02_dram_cken_dl;// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
wire			ctu_dram13_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_dram13_cken_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			ctu_dram13_cken_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_dram13_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_dram13_dram_cken_dg;// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			ctu_dram13_dram_cken_dl;// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
wire			ctu_dram_rx_sync_cl;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			ctu_dram_tx_sync_cl;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			ctu_efc_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_efc_cken_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			ctu_efc_cken_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_fpu_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_fpu_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_io_j_err_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_io_j_err_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_iob_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_iob_cken_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			ctu_iob_cken_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_iob_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_jbi_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_jbi_cken_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			ctu_jbi_cken_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_jbi_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_jbus_rx_sync_cl;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			ctu_jbus_tx_sync_cl;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			ctu_jbusl_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_jbusl_cken_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			ctu_jbusl_cken_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_jbusr_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_jbusr_cken_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			ctu_jbusr_cken_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_misc_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_misc_cken_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			ctu_misc_cken_pre_jl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_scdata0_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_scdata0_cmp_cken_cg;// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_scdata1_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_scdata1_cmp_cken_cg;// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_scdata2_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_scdata2_cmp_cken_cg;// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_scdata3_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_scdata3_cmp_cken_cg;// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sctag0_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sctag0_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sctag1_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sctag1_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sctag2_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sctag2_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sctag3_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sctag3_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sparc0_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sparc0_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sparc1_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sparc1_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sparc2_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sparc2_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sparc3_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sparc3_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sparc4_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sparc4_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sparc5_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sparc5_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sparc6_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sparc6_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			ctu_sparc7_cken_cl;	// From u_ctu_clsp_clkctrl of ctu_clsp_clkctrl.v
wire			ctu_sparc7_cmp_cken_cg;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire [4:0]		dbgtrig_dly_cnt_val;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		dbgtrig_dly_cnt_val_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			de_dbginit_cl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			de_dbginit_dsync_edge_dg;// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			de_dbginit_dsync_edge_dl;// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			de_dbginit_jl;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			de_dbginit_jsync_edge;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			de_grst_cl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			de_grst_dsync_edge_dg;	// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			de_grst_dsync_edge_dl;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			de_grst_jl;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			de_grst_jsync_edge;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			dram02_ctu_tr_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			dram02_ctu_tr_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			dram13_ctu_tr_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			dram13_ctu_tr_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			dram_a_grst_cl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			dram_a_grst_jl;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire [4:0]		dsync_reg_init;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		dsync_reg_period;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [1:0]		dsync_reg_rx0;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [1:0]		dsync_reg_rx1;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [1:0]		dsync_reg_rx2;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		dsync_reg_tx0;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		dsync_reg_tx1;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		dsync_reg_tx2;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			frq_chng_pending_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			iob_ctu_l2_tr_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			iob_ctu_l2_tr_jl;	// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			iob_ctu_tr_cl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			iob_ctu_tr_jl;		// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			jbi_ctu_tr_cl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			jbi_ctu_tr_jl;		// From u_ctu_clsp_synch_cljl of ctu_clsp_synch_cljl.v
wire			jbus_dbginit_jl_l;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			jbus_grst_jl_l;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			jbus_mult_rst_l;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire [4:0]		jsync_reg_init;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		jsync_reg_period;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [1:0]		jsync_reg_rx0;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [1:0]		jsync_reg_rx1;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [1:0]		jsync_reg_rx2;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		jsync_reg_tx0;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		jsync_reg_tx1;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [4:0]		jsync_reg_tx2;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			pll_locked_jl;		// From u_ctu_clsp_pllcnt of ctu_clsp_pllcnt.v
wire			pll_reset_ref_dly1_l;	// From u_ctu_clsp_pllcnt of ctu_clsp_pllcnt.v
wire			rd_clkctrl_reg_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			rd_clkctrl_reg_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			reg_cdiv_0;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [14:0]		reg_cdiv_vec;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			reg_ddiv_0;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [14:0]		reg_ddiv_vec;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [13:0]		reg_div_cmult;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [9:0]		reg_div_dmult;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [9:0]		reg_div_jmult;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			reg_jdiv_0;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [14:0]		reg_jdiv_vec;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			rstctrl_disclk_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			rstctrl_disclk_jl;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			rstctrl_enclk_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			rstctrl_enclk_jl;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			rstctrl_idle_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			rstctrl_idle_jl;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			sctag0_ctu_tr_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			sctag1_ctu_tr_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			sctag2_ctu_tr_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			sctag3_ctu_tr_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire [9:0]		shadreg_div_dmult;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire [9:0]		shadreg_div_jmult;	// From u_ctu_clsp_clkgn of ctu_clsp_clkgn.v
wire			ssiclk_enable;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			start_2clk_early_jl;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			start_clk_cl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			start_clk_dg;		// From u_ctu_clsp_synch_dldg of ctu_clsp_synch_dldg.v
wire			start_clk_dl;		// From u_ctu_clsp_synch_jldl of ctu_clsp_synch_jldl.v
wire [`CCTRLSM_MAX_ST-1:0]stop_id_decoded;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			stop_id_vld_cl;		// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			stop_id_vld_jl;		// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire [14:0]		stretch_cnt_vec;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			tst_rst_ref;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire [`UCB_ADDR_HI-`UCB_ADDR_LO:0]ucb_clsp_addr_in;// From u_ctu_clsp_ucb of ucb_noflow.v
wire [`UCB_BUF_HI-`UCB_BUF_LO:0]ucb_clsp_buf_id_in;// From u_ctu_clsp_ucb of ucb_noflow.v
wire [`UCB_DATA_HI-`UCB_DATA_LO:0]ucb_clsp_data_in;// From u_ctu_clsp_ucb of ucb_noflow.v
wire			ucb_clsp_rd_req_vld;	// From u_ctu_clsp_ucb of ucb_noflow.v
wire [`UCB_THR_HI-`UCB_THR_LO:0]ucb_clsp_thr_id_in;// From u_ctu_clsp_ucb of ucb_noflow.v
wire			ucb_clsp_wr_req_vld;	// From u_ctu_clsp_ucb of ucb_noflow.v
wire			update_clkctrl_reg_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			update_clkctrl_reg_jl;	// From u_ctu_clsp_creg of ctu_clsp_creg.v
wire			update_shadow_cl;	// From u_ctu_clsp_synch_jlcl of ctu_clsp_synch_jlcl.v
wire			update_shadow_jl;	// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			wrm_rst_fc_ref;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
wire			wrm_rst_ref;		// From u_ctu_clsp_ctrl of ctu_clsp_ctrl.v
// End of automatics


//--------------------------------------------------
// 
//   Synchronizers Blocks
//
//--------------------------------------------------
   /*       ctu_clsp_synch_cljl AUTO_TEMPLATE (
      );
    */

     ctu_clsp_synch_cljl  u_ctu_clsp_synch_cljl(/*AUTOINST*/
						// Outputs
						.clsp_ctrl_srarm_jl(clsp_ctrl_srarm_jl),
						.ctu_dbg_cken_jl(ctu_dbg_cken_jl),
						.ctu_dram02_cken_jl(ctu_dram02_cken_jl),
						.ctu_dram13_cken_jl(ctu_dram13_cken_jl),
						.ctu_efc_cken_jl(ctu_efc_cken_jl),
						.ctu_iob_cken_jl(ctu_iob_cken_jl),
						.ctu_jbi_cken_jl(ctu_jbi_cken_jl),
						.ctu_jbusl_cken_jl(ctu_jbusl_cken_jl),
						.ctu_jbusr_cken_jl(ctu_jbusr_cken_jl),
						.ctu_misc_cken_jl(ctu_misc_cken_jl),
						.dram02_ctu_tr_jl(dram02_ctu_tr_jl),
						.dram13_ctu_tr_jl(dram13_ctu_tr_jl),
						.iob_ctu_l2_tr_jl(iob_ctu_l2_tr_jl),
						.iob_ctu_tr_jl(iob_ctu_tr_jl),
						.jbi_ctu_tr_jl(jbi_ctu_tr_jl),
						// Inputs
						.clsp_ctrl_srarm_pre_jl(clsp_ctrl_srarm_pre_jl),
						.ctu_dram02_cken_pre_jl(ctu_dram02_cken_pre_jl),
						.ctu_dram13_cken_pre_jl(ctu_dram13_cken_pre_jl),
						.ctu_efc_cken_pre_jl(ctu_efc_cken_pre_jl),
						.ctu_iob_cken_pre_jl(ctu_iob_cken_pre_jl),
						.ctu_jbi_cken_pre_jl(ctu_jbi_cken_pre_jl),
						.dram02_ctu_tr(dram02_ctu_tr),
						.dram13_ctu_tr(dram13_ctu_tr),
						.io_pwron_rst_l(io_pwron_rst_l),
						.iob_ctu_l2_tr(iob_ctu_l2_tr),
						.iob_ctu_tr(iob_ctu_tr),
						.jbi_ctu_tr(jbi_ctu_tr),
						.jbus_clk(jbus_clk),
						.start_clk_jl(start_clk_jl),
						.ctu_jbusl_cken_pre_jl(ctu_jbusl_cken_pre_jl),
						.ctu_jbusr_cken_pre_jl(ctu_jbusr_cken_pre_jl),
						.ctu_misc_cken_pre_jl(ctu_misc_cken_pre_jl),
						.ctu_dbg_cken_pre_jl(ctu_dbg_cken_pre_jl));

   /* ctu_clsp_synch_jlcl AUTO_TEMPLATE (
            .start_clk_early_jl(start_2clk_early_jl),
      );
    */

     ctu_clsp_synch_jlcl u_ctu_clsp_synch_jlcl(/*AUTOINST*/
					       // Outputs
					       .a_dbginit_cl(a_dbginit_cl),
					       .a_grst_cl(a_grst_cl),
					       .clkctrl_dn_jl(clkctrl_dn_jl),
					       .clsp_ctrl_srarm_pre_jl(clsp_ctrl_srarm_pre_jl),
					       .creg_cken_vld_cl(creg_cken_vld_cl),
					       .ctu_ccx_cmp_cken_cg(ctu_ccx_cmp_cken_cg),
					       .ctu_dbg_cken_pre_jl(ctu_dbg_cken_pre_jl),
					       .ctu_dram02_cken_pre_jl(ctu_dram02_cken_pre_jl),
					       .ctu_dram02_cmp_cken_cg(ctu_dram02_cmp_cken_cg),
					       .ctu_dram13_cken_pre_jl(ctu_dram13_cken_pre_jl),
					       .ctu_dram13_cmp_cken_cg(ctu_dram13_cmp_cken_cg),
					       .ctu_efc_cken_pre_jl(ctu_efc_cken_pre_jl),
					       .ctu_fpu_cmp_cken_cg(ctu_fpu_cmp_cken_cg),
					       .ctu_io_j_err_jl(ctu_io_j_err_jl),
					       .ctu_iob_cken_pre_jl(ctu_iob_cken_pre_jl),
					       .ctu_iob_cmp_cken_cg(ctu_iob_cmp_cken_cg),
					       .ctu_jbi_cken_pre_jl(ctu_jbi_cken_pre_jl),
					       .ctu_jbi_cmp_cken_cg(ctu_jbi_cmp_cken_cg),
					       .ctu_jbusl_cken_pre_jl(ctu_jbusl_cken_pre_jl),
					       .ctu_jbusr_cken_pre_jl(ctu_jbusr_cken_pre_jl),
					       .ctu_misc_cken_pre_jl(ctu_misc_cken_pre_jl),
					       .ctu_scdata0_cmp_cken_cg(ctu_scdata0_cmp_cken_cg),
					       .ctu_scdata1_cmp_cken_cg(ctu_scdata1_cmp_cken_cg),
					       .ctu_scdata2_cmp_cken_cg(ctu_scdata2_cmp_cken_cg),
					       .ctu_scdata3_cmp_cken_cg(ctu_scdata3_cmp_cken_cg),
					       .ctu_sctag0_cmp_cken_cg(ctu_sctag0_cmp_cken_cg),
					       .ctu_sctag1_cmp_cken_cg(ctu_sctag1_cmp_cken_cg),
					       .ctu_sctag2_cmp_cken_cg(ctu_sctag2_cmp_cken_cg),
					       .ctu_sctag3_cmp_cken_cg(ctu_sctag3_cmp_cken_cg),
					       .ctu_sparc0_cmp_cken_cg(ctu_sparc0_cmp_cken_cg),
					       .ctu_sparc1_cmp_cken_cg(ctu_sparc1_cmp_cken_cg),
					       .ctu_sparc2_cmp_cken_cg(ctu_sparc2_cmp_cken_cg),
					       .ctu_sparc3_cmp_cken_cg(ctu_sparc3_cmp_cken_cg),
					       .ctu_sparc4_cmp_cken_cg(ctu_sparc4_cmp_cken_cg),
					       .ctu_sparc5_cmp_cken_cg(ctu_sparc5_cmp_cken_cg),
					       .ctu_sparc6_cmp_cken_cg(ctu_sparc6_cmp_cken_cg),
					       .ctu_sparc7_cmp_cken_cg(ctu_sparc7_cmp_cken_cg),
					       .dbgtrig_dly_cnt_val_cl(dbgtrig_dly_cnt_val_cl[4:0]),
					       .de_dbginit_cl(de_dbginit_cl),
					       .de_grst_cl(de_grst_cl),
					       .dram02_ctu_tr_cl(dram02_ctu_tr_cl),
					       .dram13_ctu_tr_cl(dram13_ctu_tr_cl),
					       .dram_a_grst_cl(dram_a_grst_cl),
					       .iob_ctu_l2_tr_cl(iob_ctu_l2_tr_cl),
					       .iob_ctu_tr_cl(iob_ctu_tr_cl),
					       .jbi_ctu_tr_cl(jbi_ctu_tr_cl),
					       .rd_clkctrl_reg_cl(rd_clkctrl_reg_cl),
					       .rstctrl_disclk_cl(rstctrl_disclk_cl),
					       .rstctrl_enclk_cl(rstctrl_enclk_cl),
					       .rstctrl_idle_cl(rstctrl_idle_cl),
					       .sctag0_ctu_tr_cl(sctag0_ctu_tr_cl),
					       .sctag1_ctu_tr_cl(sctag1_ctu_tr_cl),
					       .sctag2_ctu_tr_cl(sctag2_ctu_tr_cl),
					       .sctag3_ctu_tr_cl(sctag3_ctu_tr_cl),
					       .stop_id_vld_cl(stop_id_vld_cl),
					       .update_clkctrl_reg_cl(update_clkctrl_reg_cl),
					       .start_clk_cl(start_clk_cl),
					       .update_shadow_cl(update_shadow_cl),
					       // Inputs
					       .a_dbginit_jl(a_dbginit_jl),
					       .a_grst_jl(a_grst_jl),
					       .clkctrl_dn_cl(clkctrl_dn_cl),
					       .clsp_ctrl_srarm_cl(clsp_ctrl_srarm_cl),
					       .cmp_clk(cmp_clk),
					       .creg_cken_vld_jl(creg_cken_vld_jl),
					       .ctu_ccx_cken_cl(ctu_ccx_cken_cl),
					       .ctu_dram02_cken_cl(ctu_dram02_cken_cl),
					       .ctu_dram13_cken_cl(ctu_dram13_cken_cl),
					       .ctu_efc_cken_cl(ctu_efc_cken_cl),
					       .ctu_fpu_cken_cl(ctu_fpu_cken_cl),
					       .ctu_io_j_err_cl(ctu_io_j_err_cl),
					       .ctu_iob_cken_cl(ctu_iob_cken_cl),
					       .ctu_jbi_cken_cl(ctu_jbi_cken_cl),
					       .ctu_scdata0_cken_cl(ctu_scdata0_cken_cl),
					       .ctu_scdata1_cken_cl(ctu_scdata1_cken_cl),
					       .ctu_scdata2_cken_cl(ctu_scdata2_cken_cl),
					       .ctu_scdata3_cken_cl(ctu_scdata3_cken_cl),
					       .ctu_sctag0_cken_cl(ctu_sctag0_cken_cl),
					       .ctu_sctag1_cken_cl(ctu_sctag1_cken_cl),
					       .ctu_sctag2_cken_cl(ctu_sctag2_cken_cl),
					       .ctu_sctag3_cken_cl(ctu_sctag3_cken_cl),
					       .ctu_sparc0_cken_cl(ctu_sparc0_cken_cl),
					       .ctu_sparc1_cken_cl(ctu_sparc1_cken_cl),
					       .ctu_sparc2_cken_cl(ctu_sparc2_cken_cl),
					       .ctu_sparc3_cken_cl(ctu_sparc3_cken_cl),
					       .ctu_sparc4_cken_cl(ctu_sparc4_cken_cl),
					       .ctu_sparc5_cken_cl(ctu_sparc5_cken_cl),
					       .ctu_sparc6_cken_cl(ctu_sparc6_cken_cl),
					       .ctu_sparc7_cken_cl(ctu_sparc7_cken_cl),
					       .dbgtrig_dly_cnt_val(dbgtrig_dly_cnt_val[4:0]),
					       .de_dbginit_jl(de_dbginit_jl),
					       .de_grst_jl(de_grst_jl),
					       .dram02_ctu_tr_jl(dram02_ctu_tr_jl),
					       .dram13_ctu_tr_jl(dram13_ctu_tr_jl),
					       .dram_a_grst_jl(dram_a_grst_jl),
					       .iob_ctu_l2_tr_jl(iob_ctu_l2_tr_jl),
					       .iob_ctu_tr_jl(iob_ctu_tr_jl),
					       .jbi_ctu_tr_jl(jbi_ctu_tr_jl),
					       .jbus_tx_sync(jbus_tx_sync),
					       .rstctrl_disclk_jl(rstctrl_disclk_jl),
					       .rstctrl_enclk_jl(rstctrl_enclk_jl),
					       .rstctrl_idle_jl(rstctrl_idle_jl),
					       .sctag0_ctu_tr(sctag0_ctu_tr),
					       .sctag1_ctu_tr(sctag1_ctu_tr),
					       .sctag2_ctu_tr(sctag2_ctu_tr),
					       .sctag3_ctu_tr(sctag3_ctu_tr),
					       .stop_id_vld_jl(stop_id_vld_jl),
					       .jbus_rx_sync(jbus_rx_sync),
					       .io_pwron_rst_l(io_pwron_rst_l),
					       .update_shadow_jl(update_shadow_jl),
					       .ctu_jbus_rx_sync_cl(ctu_jbus_rx_sync_cl),
					       .ctu_jbusr_cken_cl(ctu_jbusr_cken_cl),
					       .ctu_jbusl_cken_cl(ctu_jbusl_cken_cl),
					       .ctu_misc_cken_cl(ctu_misc_cken_cl),
					       .ctu_dbg_cken_cl(ctu_dbg_cken_cl),
					       .update_clkctrl_reg_jl(update_clkctrl_reg_jl),
					       .rd_clkctrl_reg_jl(rd_clkctrl_reg_jl),
                                               .start_clk_early_jl(start_2clk_early_jl),
					       .jtag_clsp_force_cken_cmp(jtag_clsp_force_cken_cmp),
					       .testmode_l(testmode_l));

   /* ctu_clsp_synch_dldg AUTO_TEMPLATE (
      );
    */
     ctu_clsp_synch_dldg u_ctu_clsp_synch_dldg(/*AUTOINST*/
					       // Outputs
					       .start_clk_dg(start_clk_dg),
					       .ctu_ddr0_dram_cken_dg(ctu_ddr0_dram_cken_dg),
					       .ctu_ddr1_dram_cken_dg(ctu_ddr1_dram_cken_dg),
					       .ctu_ddr2_dram_cken_dg(ctu_ddr2_dram_cken_dg),
					       .ctu_ddr3_dram_cken_dg(ctu_ddr3_dram_cken_dg),
					       .ctu_dram02_dram_cken_dg(ctu_dram02_dram_cken_dg),
					       .ctu_dram13_dram_cken_dg(ctu_dram13_dram_cken_dg),
					       .a_grst_dg(a_grst_dg),
					       .a_dbginit_dg(a_dbginit_dg),
					       .de_grst_dsync_edge_dg(de_grst_dsync_edge_dg),
					       .de_dbginit_dsync_edge_dg(de_dbginit_dsync_edge_dg),
					       // Inputs
					       .io_pwron_rst_l(io_pwron_rst_l),
					       .cmp_gclk(cmp_gclk),
					       .ctu_ddr0_dram_cken_dl(ctu_ddr0_dram_cken_dl),
					       .ctu_ddr1_dram_cken_dl(ctu_ddr1_dram_cken_dl),
					       .ctu_ddr2_dram_cken_dl(ctu_ddr2_dram_cken_dl),
					       .ctu_ddr3_dram_cken_dl(ctu_ddr3_dram_cken_dl),
					       .ctu_dram02_dram_cken_dl(ctu_dram02_dram_cken_dl),
					       .ctu_dram13_dram_cken_dl(ctu_dram13_dram_cken_dl),
					       .start_clk_dl(start_clk_dl),
					       .a_grst_dl(a_grst_dl),
					       .a_dbginit_dl(a_dbginit_dl),
					       .de_grst_dsync_edge_dl(de_grst_dsync_edge_dl),
					       .de_dbginit_dsync_edge_dl(de_dbginit_dsync_edge_dl));

   /* ctu_clsp_synch_jldl AUTO_TEMPLATE (
      );
    */
     ctu_clsp_synch_jldl u_ctu_clsp_synch_jldl(/*AUTOINST*/
					       // Outputs
					       .ctu_ddr0_dll_delayctr(ctu_ddr0_dll_delayctr[2:0]),
					       .ctu_ddr0_dram_cken_dl(ctu_ddr0_dram_cken_dl),
					       .ctu_ddr1_dll_delayctr(ctu_ddr1_dll_delayctr[2:0]),
					       .ctu_ddr1_dram_cken_dl(ctu_ddr1_dram_cken_dl),
					       .ctu_ddr2_dll_delayctr(ctu_ddr2_dll_delayctr[2:0]),
					       .ctu_ddr2_dram_cken_dl(ctu_ddr2_dram_cken_dl),
					       .ctu_ddr3_dll_delayctr(ctu_ddr3_dll_delayctr[2:0]),
					       .ctu_ddr3_dram_cken_dl(ctu_ddr3_dram_cken_dl),
					       .ctu_dll0_byp_l(ctu_dll0_byp_l),
					       .ctu_dll0_byp_val(ctu_dll0_byp_val[4:0]),
					       .ctu_dll1_byp_l(ctu_dll1_byp_l),
					       .ctu_dll1_byp_val(ctu_dll1_byp_val[4:0]),
					       .ctu_dll2_byp_l(ctu_dll2_byp_l),
					       .ctu_dll2_byp_val(ctu_dll2_byp_val[4:0]),
					       .ctu_dll3_byp_l(ctu_dll3_byp_l),
					       .ctu_dll3_byp_val(ctu_dll3_byp_val[4:0]),
					       .ctu_dram02_dram_cken_dl(ctu_dram02_dram_cken_dl),
					       .ctu_dram13_dram_cken_dl(ctu_dram13_dram_cken_dl),
					       .ctu_ddr0_iodll_rst_l(ctu_ddr0_iodll_rst_l),
					       .ctu_ddr1_iodll_rst_l(ctu_ddr1_iodll_rst_l),
					       .ctu_ddr2_iodll_rst_l(ctu_ddr2_iodll_rst_l),
					       .ctu_ddr3_iodll_rst_l(ctu_ddr3_iodll_rst_l),
					       .start_clk_dl(start_clk_dl),
					       // Inputs
					       .cmp_clk(cmp_clk),
					       .coin_edge(coin_edge),
					       .ctu_ddr0_cken_cl(ctu_ddr0_cken_cl),
					       .ctu_ddr0_dll_delayctr_jl(ctu_ddr0_dll_delayctr_jl[2:0]),
					       .ctu_ddr0_iodll_rst_jl_l(ctu_ddr0_iodll_rst_jl_l),
					       .ctu_ddr1_cken_cl(ctu_ddr1_cken_cl),
					       .ctu_ddr1_dll_delayctr_jl(ctu_ddr1_dll_delayctr_jl[2:0]),
					       .ctu_ddr1_iodll_rst_jl_l(ctu_ddr1_iodll_rst_jl_l),
					       .ctu_ddr2_cken_cl(ctu_ddr2_cken_cl),
					       .ctu_ddr2_dll_delayctr_jl(ctu_ddr2_dll_delayctr_jl[2:0]),
					       .ctu_ddr2_iodll_rst_jl_l(ctu_ddr2_iodll_rst_jl_l),
					       .ctu_ddr3_cken_cl(ctu_ddr3_cken_cl),
					       .ctu_ddr3_dll_delayctr_jl(ctu_ddr3_dll_delayctr_jl[2:0]),
					       .ctu_ddr3_iodll_rst_jl_l(ctu_ddr3_iodll_rst_jl_l),
					       .ctu_dll0_byp_l_jl(ctu_dll0_byp_l_jl),
					       .ctu_dll0_byp_val_jl(ctu_dll0_byp_val_jl[4:0]),
					       .ctu_dll1_byp_l_jl(ctu_dll1_byp_l_jl),
					       .ctu_dll1_byp_val_jl(ctu_dll1_byp_val_jl[4:0]),
					       .ctu_dll2_byp_l_jl(ctu_dll2_byp_l_jl),
					       .ctu_dll2_byp_val_jl(ctu_dll2_byp_val_jl[4:0]),
					       .ctu_dll3_byp_l_jl(ctu_dll3_byp_l_jl),
					       .ctu_dll3_byp_val_jl(ctu_dll3_byp_val_jl[4:0]),
					       .ctu_dram02_cken_cl(ctu_dram02_cken_cl),
					       .ctu_dram13_cken_cl(ctu_dram13_cken_cl),
					       .jbus_rx_sync(jbus_rx_sync),
					       .start_clk_cl(start_clk_cl),
					       .io_pwron_rst_l(io_pwron_rst_l),
					       .ctu_dram_tx_sync_early(ctu_dram_tx_sync_early));


//--------------------------------------------------
// 
//  Global signal Generation  Blocks
//
//--------------------------------------------------


     ctu_clsp_dramgif u_ctu_clsp_dramgif(/*AUTOINST*/
					 // Outputs
					 .dram_grst_out_l(dram_grst_out_l),
					 .dram_arst_l(dram_arst_l),
					 .dram_gdbginit_out_l(dram_gdbginit_out_l),
					 .dram_adbginit_l(dram_adbginit_l),
					 .ctu_dram02_dram_cken(ctu_dram02_dram_cken),
					 .ctu_dram13_dram_cken(ctu_dram13_dram_cken),
					 .ctu_ddr0_dram_cken(ctu_ddr0_dram_cken),
					 .ctu_ddr1_dram_cken(ctu_ddr1_dram_cken),
					 .ctu_ddr2_dram_cken(ctu_ddr2_dram_cken),
					 .ctu_ddr3_dram_cken(ctu_ddr3_dram_cken),
					 // Inputs
					 .io_pwron_rst_l(io_pwron_rst_l),
					 .start_clk_early_jl(start_clk_early_jl),
					 .testmode_l(testmode_l),
					 .dram_gclk(dram_gclk),
					 .start_clk_dg(start_clk_dg),
					 .shadreg_div_dmult(shadreg_div_dmult[9:0]),
					 .de_grst_dsync_edge_dg(de_grst_dsync_edge_dg),
					 .de_dbginit_dsync_edge_dg(de_dbginit_dsync_edge_dg),
					 .a_grst_dg(a_grst_dg),
					 .a_dbginit_dg(a_dbginit_dg),
					 .ctu_dram02_dram_cken_dg(ctu_dram02_dram_cken_dg),
					 .ctu_dram13_dram_cken_dg(ctu_dram13_dram_cken_dg),
					 .ctu_ddr0_dram_cken_dg(ctu_ddr0_dram_cken_dg),
					 .ctu_ddr1_dram_cken_dg(ctu_ddr1_dram_cken_dg),
					 .ctu_ddr2_dram_cken_dg(ctu_ddr2_dram_cken_dg),
					 .ctu_ddr3_dram_cken_dg(ctu_ddr3_dram_cken_dg),
					 .jtag_clsp_force_cken_dram(jtag_clsp_force_cken_dram));
     ctu_clsp_jbusgif u_ctu_clsp_jbusgif(/*AUTOINST*/
					 // Outputs
					 .ctu_dram02_jbus_cken(ctu_dram02_jbus_cken),
					 .ctu_dram13_jbus_cken(ctu_dram13_jbus_cken),
					 .ctu_jbi_jbus_cken(ctu_jbi_jbus_cken),
					 .ctu_iob_jbus_cken(ctu_iob_jbus_cken),
					 .ctu_jbusl_jbus_cken(ctu_jbusl_jbus_cken),
					 .ctu_jbusr_jbus_cken(ctu_jbusr_jbus_cken),
					 .ctu_misc_jbus_cken(ctu_misc_jbus_cken),
					 .ctu_efc_jbus_cken(ctu_efc_jbus_cken),
					 .ctu_dbg_jbus_cken(ctu_dbg_jbus_cken),
					 .jbus_grst_out_l(jbus_grst_out_l),
					 .jbus_arst_l(jbus_arst_l),
					 .jbus_gdbginit_out_l(jbus_gdbginit_out_l),
					 .jbus_adbginit_l(jbus_adbginit_l),
					 // Inputs
					 .io_pwron_rst_l(io_pwron_rst_l),
					 .start_clk_jl(start_clk_jl),
					 .testmode_l(testmode_l),
					 .jbus_gclk(jbus_gclk),
					 .jbus_grst_jl_l(jbus_grst_jl_l),
					 .jbus_dbginit_jl_l(jbus_dbginit_jl_l),
					 .ctu_dram02_cken_jl(ctu_dram02_cken_jl),
					 .ctu_dram13_cken_jl(ctu_dram13_cken_jl),
					 .ctu_iob_cken_jl(ctu_iob_cken_jl),
					 .ctu_efc_cken_jl(ctu_efc_cken_jl),
					 .ctu_dbg_cken_jl(ctu_dbg_cken_jl),
					 .ctu_jbusl_cken_jl(ctu_jbusl_cken_jl),
					 .ctu_jbusr_cken_jl(ctu_jbusr_cken_jl),
					 .ctu_jbi_cken_jl(ctu_jbi_cken_jl),
					 .ctu_misc_cken_jl(ctu_misc_cken_jl),
					 .jtag_clsp_force_cken_jbus(jtag_clsp_force_cken_jbus));

   /*  ctu_clsp_cmpgif AUTO_TEMPLATE (
				       .ctu_sparc0_cken(ctu_spc0_cken),
				       .ctu_sparc1_cken(ctu_spc1_cken),
				       .ctu_sparc2_cken(ctu_spc2_cken),
				       .ctu_sparc3_cken(ctu_spc3_cken),
				       .ctu_sparc4_cken(ctu_spc4_cken),
				       .ctu_sparc5_cken(ctu_spc5_cken),
				       .ctu_sparc6_cken(ctu_spc6_cken),
				       .ctu_sparc7_cken(ctu_spc7_cken),
      );
    */
     ctu_clsp_cmpgif u_ctu_clsp_cmpgif(/*AUTOINST*/
				       // Outputs
				       .cmp_grst_out_l(cmp_grst_out_l),
				       .cmp_arst_l(cmp_arst_l),
				       .cmp_gdbginit_out_l(cmp_gdbginit_out_l),
				       .cmp_adbginit_l(cmp_adbginit_l),
				       .ctu_dram_tx_sync_out(ctu_dram_tx_sync_out),
				       .ctu_dram_rx_sync_out(ctu_dram_rx_sync_out),
				       .ctu_jbus_tx_sync_out(ctu_jbus_tx_sync_out),
				       .ctu_jbus_rx_sync_out(ctu_jbus_rx_sync_out),
				       .ctu_ccx_cmp_cken(ctu_ccx_cmp_cken),
				       .ctu_dram02_cmp_cken(ctu_dram02_cmp_cken),
				       .ctu_dram13_cmp_cken(ctu_dram13_cmp_cken),
				       .ctu_fpu_cmp_cken(ctu_fpu_cmp_cken),
				       .ctu_iob_cmp_cken(ctu_iob_cmp_cken),
				       .ctu_jbi_cmp_cken(ctu_jbi_cmp_cken),
				       .ctu_scdata0_cmp_cken(ctu_scdata0_cmp_cken),
				       .ctu_scdata1_cmp_cken(ctu_scdata1_cmp_cken),
				       .ctu_scdata2_cmp_cken(ctu_scdata2_cmp_cken),
				       .ctu_scdata3_cmp_cken(ctu_scdata3_cmp_cken),
				       .ctu_sctag0_cmp_cken(ctu_sctag0_cmp_cken),
				       .ctu_sctag1_cmp_cken(ctu_sctag1_cmp_cken),
				       .ctu_sctag2_cmp_cken(ctu_sctag2_cmp_cken),
				       .ctu_sctag3_cmp_cken(ctu_sctag3_cmp_cken),
				       .ctu_sparc0_cmp_cken(ctu_sparc0_cmp_cken),
				       .ctu_sparc1_cmp_cken(ctu_sparc1_cmp_cken),
				       .ctu_sparc2_cmp_cken(ctu_sparc2_cmp_cken),
				       .ctu_sparc3_cmp_cken(ctu_sparc3_cmp_cken),
				       .ctu_sparc4_cmp_cken(ctu_sparc4_cmp_cken),
				       .ctu_sparc5_cmp_cken(ctu_sparc5_cmp_cken),
				       .ctu_sparc6_cmp_cken(ctu_sparc6_cmp_cken),
				       .ctu_sparc7_cmp_cken(ctu_sparc7_cmp_cken),
				       // Inputs
				       .io_pwron_rst_l(io_pwron_rst_l),
				       .cmp_gclk(cmp_gclk),
				       .start_clk_cl(start_clk_cl),
				       .cmp_grst_cl_l(cmp_grst_cl_l),
				       .cmp_dbginit_cl_l(cmp_dbginit_cl_l),
				       .ctu_dram_tx_sync_cl(ctu_dram_tx_sync_cl),
				       .ctu_dram_rx_sync_cl(ctu_dram_rx_sync_cl),
				       .ctu_jbus_tx_sync_cl(ctu_jbus_tx_sync_cl),
				       .ctu_jbus_rx_sync_cl(ctu_jbus_rx_sync_cl),
				       .ctu_ccx_cmp_cken_cg(ctu_ccx_cmp_cken_cg),
				       .ctu_dram02_cmp_cken_cg(ctu_dram02_cmp_cken_cg),
				       .ctu_dram13_cmp_cken_cg(ctu_dram13_cmp_cken_cg),
				       .ctu_fpu_cmp_cken_cg(ctu_fpu_cmp_cken_cg),
				       .ctu_iob_cmp_cken_cg(ctu_iob_cmp_cken_cg),
				       .ctu_jbi_cmp_cken_cg(ctu_jbi_cmp_cken_cg),
				       .ctu_scdata0_cmp_cken_cg(ctu_scdata0_cmp_cken_cg),
				       .ctu_scdata1_cmp_cken_cg(ctu_scdata1_cmp_cken_cg),
				       .ctu_scdata2_cmp_cken_cg(ctu_scdata2_cmp_cken_cg),
				       .ctu_scdata3_cmp_cken_cg(ctu_scdata3_cmp_cken_cg),
				       .ctu_sctag0_cmp_cken_cg(ctu_sctag0_cmp_cken_cg),
				       .ctu_sctag1_cmp_cken_cg(ctu_sctag1_cmp_cken_cg),
				       .ctu_sctag2_cmp_cken_cg(ctu_sctag2_cmp_cken_cg),
				       .ctu_sctag3_cmp_cken_cg(ctu_sctag3_cmp_cken_cg),
				       .ctu_sparc0_cmp_cken_cg(ctu_sparc0_cmp_cken_cg),
				       .ctu_sparc1_cmp_cken_cg(ctu_sparc1_cmp_cken_cg),
				       .ctu_sparc2_cmp_cken_cg(ctu_sparc2_cmp_cken_cg),
				       .ctu_sparc3_cmp_cken_cg(ctu_sparc3_cmp_cken_cg),
				       .ctu_sparc4_cmp_cken_cg(ctu_sparc4_cmp_cken_cg),
				       .ctu_sparc5_cmp_cken_cg(ctu_sparc5_cmp_cken_cg),
				       .ctu_sparc6_cmp_cken_cg(ctu_sparc6_cmp_cken_cg),
				       .ctu_sparc7_cmp_cken_cg(ctu_sparc7_cmp_cken_cg));

//--------------------------------------------------
// 
//   UCB interface and CSR registers
//
//--------------------------------------------------

/* ucb_noflow AUTO_TEMPLATE (
	 .ucb_iob_stall (clsp_iob_stall),
	 .rd_req_vld    (ucb_clsp_rd_req_vld),
	 .wr_req_vld    (ucb_clsp_wr_req_vld),
	 .thr_id_in     (ucb_clsp_thr_id_in[]),
	 .buf_id_in     (ucb_clsp_buf_id_in[]),
	 .size_in       (),
	 .addr_in       (ucb_clsp_addr_in[]),
	 .data_in       (ucb_clsp_data_in[]),
	 .int_busy      (),
	 .ucb_iob_vld   (clsp_iob_vld),
	 .ucb_iob_data  (clsp_iob_data[`CLK_IOB_WIDTH-1:0]),
	 .clk           (jbus_clk),
	 .rst_l         (jbus_rst_l),
	 .iob_ucb_vld   (iob_clsp_vld),
	 .iob_ucb_data  (iob_clsp_data[`IOB_CLK_WIDTH-1:0]),
	 .rd_ack_vld    (clsp_ucb_rd_ack_vld),
	 .rd_nack_vld   (clsp_ucb_rd_nack_vld),
	 .thr_id_out    (clsp_ucb_thr_id_out[]),
	 .buf_id_out    (clsp_ucb_buf_id_out[]),
	 .data128       (1'b0),
	 .data_out      (clsp_ucb_data_out[63:0]),
	 .int_vld       (1'b0),
	 .int_typ       ({`UCB_PKT_HI-`UCB_PKT_LO+1{1'b0}}),
	 .int_thr_id    ({`UCB_THR_HI-`UCB_THR_LO+1{1'b0}}),
	 .dev_id        ({`UCB_INT_DEV_HI-`UCB_INT_DEV_LO+1{1'b0}}),
	 .int_stat      ({`UCB_INT_STAT_HI-`UCB_INT_STAT_LO+1{1'b0}}),
	 .int_vec       ({`UCB_INT_VEC_HI-`UCB_INT_VEC_LO+1{1'b0}}),
	 .iob_ucb_stall (iob_clsp_stall),
 ); */

       ucb_noflow  #(`IOB_CLK_WIDTH,`CLK_IOB_WIDTH,64)  
               u_ctu_clsp_ucb (/*AUTOINST*/
			       // Outputs
			       .ucb_iob_stall(clsp_iob_stall),	 // Templated
			       .rd_req_vld(ucb_clsp_rd_req_vld), // Templated
			       .wr_req_vld(ucb_clsp_wr_req_vld), // Templated
			       .thr_id_in(ucb_clsp_thr_id_in[`UCB_THR_HI-`UCB_THR_LO:0]), // Templated
			       .buf_id_in(ucb_clsp_buf_id_in[`UCB_BUF_HI-`UCB_BUF_LO:0]), // Templated
			       .size_in	(),			 // Templated
			       .addr_in	(ucb_clsp_addr_in[`UCB_ADDR_HI-`UCB_ADDR_LO:0]), // Templated
			       .data_in	(ucb_clsp_data_in[`UCB_DATA_HI-`UCB_DATA_LO:0]), // Templated
			       .int_busy(),			 // Templated
			       .ucb_iob_vld(clsp_iob_vld),	 // Templated
			       .ucb_iob_data(clsp_iob_data[`CLK_IOB_WIDTH-1:0]), // Templated
			       // Inputs
			       .clk	(jbus_clk),		 // Templated
			       .rst_l	(jbus_rst_l),		 // Templated
			       .iob_ucb_vld(iob_clsp_vld),	 // Templated
			       .iob_ucb_data(iob_clsp_data[`IOB_CLK_WIDTH-1:0]), // Templated
			       .rd_ack_vld(clsp_ucb_rd_ack_vld), // Templated
			       .rd_nack_vld(clsp_ucb_rd_nack_vld), // Templated
			       .thr_id_out(clsp_ucb_thr_id_out[`UCB_THR_HI-`UCB_THR_LO:0]), // Templated
			       .buf_id_out(clsp_ucb_buf_id_out[`UCB_BUF_HI-`UCB_BUF_LO:0]), // Templated
			       .data128	(1'b0),			 // Templated
			       .data_out(clsp_ucb_data_out[63:0]), // Templated
			       .int_vld	(1'b0),			 // Templated
			       .int_typ	({`UCB_PKT_HI-`UCB_PKT_LO+1{1'b0}}), // Templated
			       .int_thr_id({`UCB_THR_HI-`UCB_THR_LO+1{1'b0}}), // Templated
			       .dev_id	({`UCB_INT_DEV_HI-`UCB_INT_DEV_LO+1{1'b0}}), // Templated
			       .int_stat({`UCB_INT_STAT_HI-`UCB_INT_STAT_LO+1{1'b0}}), // Templated
			       .int_vec	({`UCB_INT_VEC_HI-`UCB_INT_VEC_LO+1{1'b0}}), // Templated
			       .iob_ucb_stall(iob_clsp_stall));	 // Templated

  /* ctu_clsp_creg AUTO_TEMPLATE (
    .clk(jbus_clk),
    .rst_l(jbus_rst_l),
    .bypclksel(jtag_clsp_sel_jbus[2]),
      );
  */
     ctu_clsp_creg u_ctu_clsp_creg (/*AUTOINST*/
				    // Outputs
				    .reg_cdiv_0(reg_cdiv_0),
				    .reg_ddiv_0(reg_ddiv_0),
				    .reg_jdiv_0(reg_jdiv_0),
				    .reg_cdiv_vec(reg_cdiv_vec[14:0]),
				    .reg_ddiv_vec(reg_ddiv_vec[14:0]),
				    .reg_jdiv_vec(reg_jdiv_vec[14:0]),
				    .stretch_cnt_vec(stretch_cnt_vec[14:0]),
				    .clk_stretch_cnt_val_6(clk_stretch_cnt_val_6),
				    .clk_stretch_cnt_val_odd(clk_stretch_cnt_val_odd),
				    .reg_div_cmult(reg_div_cmult[13:0]),
				    .reg_div_dmult(reg_div_dmult[9:0]),
				    .reg_div_jmult(reg_div_jmult[9:0]),
				    .dsync_reg_init(dsync_reg_init[4:0]),
				    .dsync_reg_period(dsync_reg_period[4:0]),
				    .dsync_reg_rx0(dsync_reg_rx0[1:0]),
				    .dsync_reg_rx1(dsync_reg_rx1[1:0]),
				    .dsync_reg_rx2(dsync_reg_rx2[1:0]),
				    .dsync_reg_tx0(dsync_reg_tx0[4:0]),
				    .dsync_reg_tx1(dsync_reg_tx1[4:0]),
				    .dsync_reg_tx2(dsync_reg_tx2[4:0]),
				    .jsync_reg_init(jsync_reg_init[4:0]),
				    .jsync_reg_period(jsync_reg_period[4:0]),
				    .jsync_reg_rx0(jsync_reg_rx0[1:0]),
				    .jsync_reg_rx1(jsync_reg_rx1[1:0]),
				    .jsync_reg_rx2(jsync_reg_rx2[1:0]),
				    .jsync_reg_tx0(jsync_reg_tx0[4:0]),
				    .jsync_reg_tx1(jsync_reg_tx1[4:0]),
				    .jsync_reg_tx2(jsync_reg_tx2[4:0]),
				    .ctu_spc_const_maskid(ctu_spc_const_maskid[7:0]),
				    .frq_chng_pending_jl(frq_chng_pending_jl),
				    .ctu_ddr0_dll_delayctr_jl(ctu_ddr0_dll_delayctr_jl[2:0]),
				    .ctu_ddr1_dll_delayctr_jl(ctu_ddr1_dll_delayctr_jl[2:0]),
				    .ctu_ddr2_dll_delayctr_jl(ctu_ddr2_dll_delayctr_jl[2:0]),
				    .ctu_ddr3_dll_delayctr_jl(ctu_ddr3_dll_delayctr_jl[2:0]),
				    .de_dbginit_jl(de_dbginit_jl),
				    .a_dbginit_jl(a_dbginit_jl),
				    .clsp_ucb_rd_ack_vld(clsp_ucb_rd_ack_vld),
				    .clsp_ucb_rd_nack_vld(clsp_ucb_rd_nack_vld),
				    .clsp_ucb_thr_id_out(clsp_ucb_thr_id_out[`UCB_THR_HI-`UCB_THR_LO:0]),
				    .clsp_ucb_buf_id_out(clsp_ucb_buf_id_out[`UCB_BUF_HI-`UCB_BUF_LO:0]),
				    .clsp_ucb_data_out(clsp_ucb_data_out[REG_WIDTH-1:0]),
				    .dbgtrig_dly_cnt_val(dbgtrig_dly_cnt_val[4:0]),
				    .jbus_grst_jl_l(jbus_grst_jl_l),
				    .jbus_dbginit_jl_l(jbus_dbginit_jl_l),
				    .clk_stretch_trig(clk_stretch_trig),
				    .ctu_dll3_byp_val_jl(ctu_dll3_byp_val_jl[4:0]),
				    .ctu_dll2_byp_val_jl(ctu_dll2_byp_val_jl[4:0]),
				    .ctu_dll1_byp_val_jl(ctu_dll1_byp_val_jl[4:0]),
				    .ctu_dll0_byp_val_jl(ctu_dll0_byp_val_jl[4:0]),
				    .ctu_dll3_byp_l_jl(ctu_dll3_byp_l_jl),
				    .ctu_dll2_byp_l_jl(ctu_dll2_byp_l_jl),
				    .ctu_dll1_byp_l_jl(ctu_dll1_byp_l_jl),
				    .ctu_dll0_byp_l_jl(ctu_dll0_byp_l_jl),
				    .stop_id_vld_jl(stop_id_vld_jl),
				    .stop_id_decoded(stop_id_decoded[`CCTRLSM_MAX_ST-1:0]),
				    .update_clkctrl_reg_jl(update_clkctrl_reg_jl),
				    .clkctrl_data_in_reg(clkctrl_data_in_reg[63:0]),
				    .rd_clkctrl_reg_jl(rd_clkctrl_reg_jl),
				    // Inputs
				    .se	(se),
				    .mask_major_id(mask_major_id[3:0]),
				    .mask_minor_id(mask_minor_id[3:0]),
				    .ddr0_ctu_dll_lock(ddr0_ctu_dll_lock),
				    .ddr1_ctu_dll_lock(ddr1_ctu_dll_lock),
				    .ddr2_ctu_dll_lock(ddr2_ctu_dll_lock),
				    .ddr3_ctu_dll_lock(ddr3_ctu_dll_lock),
				    .ddr0_ctu_dll_overflow(ddr0_ctu_dll_overflow),
				    .ddr1_ctu_dll_overflow(ddr1_ctu_dll_overflow),
				    .ddr2_ctu_dll_overflow(ddr2_ctu_dll_overflow),
				    .ddr3_ctu_dll_overflow(ddr3_ctu_dll_overflow),
				    .jbus_clk(jbus_clk),
				    .rst_l(jbus_rst_l),		 // Templated
				    .io_pwron_rst_l(io_pwron_rst_l),
				    .start_clk_jl(start_clk_jl),
				    .start_clk_early_jl(start_clk_early_jl),
				    .a_grst_jl(a_grst_jl),
				    .io_clk_stretch(io_clk_stretch),
				    .clsp_ctrl_rd_bus_cl(clsp_ctrl_rd_bus_cl[63:0]),
				    .shadreg_div_jmult(shadreg_div_jmult[9:0]),
				    .de_grst_jsync_edge(de_grst_jsync_edge),
				    .de_dbginit_jsync_edge(de_dbginit_jsync_edge),
				    .ucb_clsp_rd_req_vld(ucb_clsp_rd_req_vld),
				    .ucb_clsp_wr_req_vld(ucb_clsp_wr_req_vld),
				    .ucb_clsp_addr_in(ucb_clsp_addr_in[`UCB_ADDR_HI-`UCB_ADDR_LO:0]),
				    .ucb_clsp_data_in(ucb_clsp_data_in[`UCB_DATA_HI-`UCB_DATA_LO:0]),
				    .ucb_clsp_thr_id_in(ucb_clsp_thr_id_in[`UCB_THR_HI-`UCB_THR_LO:0]),
				    .ucb_clsp_buf_id_in(ucb_clsp_buf_id_in[`UCB_BUF_HI-`UCB_BUF_LO:0]),
				    .bypclksel(jtag_clsp_sel_jbus[2]), // Templated
				    .jbus_mult_rst_l(jbus_mult_rst_l),
				    .jtag_clsp_stop_id_vld(jtag_clsp_stop_id_vld),
				    .jtag_clsp_stop_id(jtag_clsp_stop_id[5:0]),
				    .dll3_ctu_ctrl(dll3_ctu_ctrl[4:0]),
				    .dll2_ctu_ctrl(dll2_ctu_ctrl[4:0]),
				    .dll1_ctu_ctrl(dll1_ctu_ctrl[4:0]),
				    .dll0_ctu_ctrl(dll0_ctu_ctrl[4:0]));

//--------------------------------------------------
// 
//    Clock enable state machine
//
//--------------------------------------------------


  /* ctu_clsp_clkctrl AUTO_TEMPLATE (
      .clk(jbus_clk),
      .rst_l(jbus_rst_l),
      );
  */
     ctu_clsp_clkctrl u_ctu_clsp_clkctrl(/*AUTOINST*/
					 // Outputs
					 .clsp_ctrl_rd_bus_cl(clsp_ctrl_rd_bus_cl[63:0]),
					 .ctu_sparc0_cken_cl(ctu_sparc0_cken_cl),
					 .ctu_sparc1_cken_cl(ctu_sparc1_cken_cl),
					 .ctu_sparc2_cken_cl(ctu_sparc2_cken_cl),
					 .ctu_sparc3_cken_cl(ctu_sparc3_cken_cl),
					 .ctu_sparc4_cken_cl(ctu_sparc4_cken_cl),
					 .ctu_sparc5_cken_cl(ctu_sparc5_cken_cl),
					 .ctu_sparc6_cken_cl(ctu_sparc6_cken_cl),
					 .ctu_sparc7_cken_cl(ctu_sparc7_cken_cl),
					 .ctu_scdata0_cken_cl(ctu_scdata0_cken_cl),
					 .ctu_scdata1_cken_cl(ctu_scdata1_cken_cl),
					 .ctu_scdata2_cken_cl(ctu_scdata2_cken_cl),
					 .ctu_scdata3_cken_cl(ctu_scdata3_cken_cl),
					 .ctu_sctag0_cken_cl(ctu_sctag0_cken_cl),
					 .ctu_sctag1_cken_cl(ctu_sctag1_cken_cl),
					 .ctu_sctag2_cken_cl(ctu_sctag2_cken_cl),
					 .ctu_sctag3_cken_cl(ctu_sctag3_cken_cl),
					 .ctu_dram02_cken_cl(ctu_dram02_cken_cl),
					 .ctu_dram13_cken_cl(ctu_dram13_cken_cl),
					 .ctu_ccx_cken_cl(ctu_ccx_cken_cl),
					 .ctu_fpu_cken_cl(ctu_fpu_cken_cl),
					 .ctu_ddr0_cken_cl(ctu_ddr0_cken_cl),
					 .ctu_ddr1_cken_cl(ctu_ddr1_cken_cl),
					 .ctu_ddr2_cken_cl(ctu_ddr2_cken_cl),
					 .ctu_ddr3_cken_cl(ctu_ddr3_cken_cl),
					 .ctu_iob_cken_cl(ctu_iob_cken_cl),
					 .ctu_efc_cken_cl(ctu_efc_cken_cl),
					 .ctu_dbg_cken_cl(ctu_dbg_cken_cl),
					 .ctu_jbi_cken_cl(ctu_jbi_cken_cl),
					 .ctu_jbusl_cken_cl(ctu_jbusl_cken_cl),
					 .ctu_misc_cken_cl(ctu_misc_cken_cl),
					 .ctu_jbusr_cken_cl(ctu_jbusr_cken_cl),
					 .ctu_io_j_err_cl(ctu_io_j_err_cl),
					 .clkctrl_dn_cl(clkctrl_dn_cl),
					 .clsp_ctrl_srarm_cl(clsp_ctrl_srarm_cl),
					 // Inputs
					 .cmp_clk(cmp_clk),
					 .io_pwron_rst_l(io_pwron_rst_l),
					 .creg_cken_vld_cl(creg_cken_vld_cl),
					 .jbus_tx_sync(jbus_tx_sync),
					 .start_clk_cl(start_clk_cl),
					 .rstctrl_idle_cl(rstctrl_idle_cl),
					 .rstctrl_disclk_cl(rstctrl_disclk_cl),
					 .rstctrl_enclk_cl(rstctrl_enclk_cl),
					 .sctag0_ctu_tr_cl(sctag0_ctu_tr_cl),
					 .sctag1_ctu_tr_cl(sctag1_ctu_tr_cl),
					 .sctag2_ctu_tr_cl(sctag2_ctu_tr_cl),
					 .sctag3_ctu_tr_cl(sctag3_ctu_tr_cl),
					 .iob_ctu_tr_cl(iob_ctu_tr_cl),
					 .dram02_ctu_tr_cl(dram02_ctu_tr_cl),
					 .dram13_ctu_tr_cl(dram13_ctu_tr_cl),
					 .jbi_ctu_tr_cl(jbi_ctu_tr_cl),
					 .iob_ctu_l2_tr_cl(iob_ctu_l2_tr_cl),
					 .dbgtrig_dly_cnt_val_cl(dbgtrig_dly_cnt_val_cl[4:0]),
					 .update_clkctrl_reg_cl(update_clkctrl_reg_cl),
					 .clkctrl_data_in_reg(clkctrl_data_in_reg[63:0]),
					 .rd_clkctrl_reg_cl(rd_clkctrl_reg_cl),
					 .stop_id_vld_cl(stop_id_vld_cl),
					 .stop_id_decoded(stop_id_decoded[`CCTRLSM_MAX_ST-1:0]));

//--------------------------------------------------
// 
//     reset control state machine
//
//--------------------------------------------------


  /* ctu_clsp_ctrl AUTO_TEMPLATE (
         .de_dll_rst_dn(ctu_ddr0_iodll_rst_l),
         .bypclksel( jtag_clsp_sel_jbus[2]),
      );
  */
     ctu_clsp_ctrl u_ctu_clsp_ctrl (/*AUTOINST*/
				    // Outputs
				    .start_clk_jl(start_clk_jl),
				    .start_clk_early_jl(start_clk_early_jl),
				    .start_2clk_early_jl(start_2clk_early_jl),
				    .update_shadow_jl(update_shadow_jl),
				    .ctu_dram_selfrsh(ctu_dram_selfrsh),
				    .de_grst_jl(de_grst_jl),
				    .a_grst_jl(a_grst_jl),
				    .dram_a_grst_jl(dram_a_grst_jl),
				    .wrm_rst_ref(wrm_rst_ref),
				    .wrm_rst_fc_ref(wrm_rst_fc_ref),
				    .tst_rst_ref(tst_rst_ref),
				    .ctu_efc_read_start(ctu_efc_read_start),
				    .ctu_iob_wake_thr(ctu_iob_wake_thr),
				    .creg_cken_vld_jl(creg_cken_vld_jl),
				    .ctu_io_j_err(ctu_io_j_err),
				    .ctu_tst_pre_grst_l(ctu_tst_pre_grst_l),
				    .ctu_ddr0_iodll_rst_jl_l(ctu_ddr0_iodll_rst_jl_l),
				    .ctu_ddr1_iodll_rst_jl_l(ctu_ddr1_iodll_rst_jl_l),
				    .ctu_ddr2_iodll_rst_jl_l(ctu_ddr2_iodll_rst_jl_l),
				    .ctu_ddr3_iodll_rst_jl_l(ctu_ddr3_iodll_rst_jl_l),
				    .clsp_bist_dobist(clsp_bist_dobist),
				    .clsp_bist_type(clsp_bist_type),
				    .clsp_bist_ctrl(clsp_bist_ctrl[5:0]),
				    .rstctrl_disclk_jl(rstctrl_disclk_jl),
				    .rstctrl_enclk_jl(rstctrl_enclk_jl),
				    .rstctrl_idle_jl(rstctrl_idle_jl),
				    .ssiclk_enable(ssiclk_enable),
				    .ctu_iob_resetstat_wr(ctu_iob_resetstat_wr),
				    .ctu_iob_resetstat(ctu_iob_resetstat[2:0]),
				    // Inputs
				    .jbus_clk(jbus_clk),
				    .io_pwron_rst_l(io_pwron_rst_l),
				    .pll_locked_jl(pll_locked_jl),
				    .io_j_rst_l(io_j_rst_l),
				    .frq_chng_pending_jl(frq_chng_pending_jl),
				    .clsp_ctrl_srarm_jl(clsp_ctrl_srarm_jl),
				    .clkctrl_dn_jl(clkctrl_dn_jl),
				    .jbus_grst_jl_l(jbus_grst_jl_l),
				    .io_do_bist(io_do_bist),
				    .io_pll_char_in(io_pll_char_in),
				    .dft_wake_thr(dft_wake_thr),
				    .de_dll_rst_dn(ctu_ddr0_iodll_rst_l), // Templated
				    .ctu_io_j_err_jl(ctu_io_j_err_jl),
				    .testmode_l(testmode_l),
				    .bypclksel( jtag_clsp_sel_jbus[2]), // Templated
				    .jtag_clsp_ignore_wrm_rst(jtag_clsp_ignore_wrm_rst));

  /* ctu_clsp_pllcnt AUTO_TEMPLATE (
       .bypclksel( jtag_clsp_sel_jbus[2]),
      );
  */
     ctu_clsp_pllcnt u_ctu_clsp_pllcnt (/*AUTOINST*/
					// Outputs
					.pll_locked_jl(pll_locked_jl),
					.pll_reset_ref_l(pll_reset_ref_l),
					.pll_reset_ref_dly1_l(pll_reset_ref_dly1_l),
					// Inputs
					.pll_raw_clk_out(pll_raw_clk_out),
					.io_pwron_rst_l(io_pwron_rst_l),
					.testmode_l(testmode_l),
					.wrm_rst_ref(wrm_rst_ref),
					.wrm_rst_fc_ref(wrm_rst_fc_ref),
					.tst_rst_ref(tst_rst_ref),
					.bypclksel( jtag_clsp_sel_jbus[2])); // Templated

//--------------------------------------------------
// 
//     Clock generation block
//
//--------------------------------------------------

  /* ctu_clsp_clkgn AUTO_TEMPLATE (
     .clk_stretch_pin_dl(io_clk_stretch),
     .cmp_div_bypass(),
     .jbus_tx_sync(jbus_tx_sync),
     .jbus_rx_sync(jbus_rx_sync),
     .ctu_dram_tx_sync_cl(ctu_dram_tx_sync_cl),
     .ctu_dram_rx_sync_cl(ctu_dram_rx_sync_cl),
     .ctu_jbus_tx_sync_cl(ctu_jbus_tx_sync_cl),
     .ctu_jbus_rx_sync_cl(ctu_jbus_rx_sync_cl),

      );
  */
     ctu_clsp_clkgn u_ctu_clsp_clkgn(/*AUTOINST*/
				     // Outputs
				     .jbus_gclk_out(jbus_gclk_out),
				     .shadreg_div_dmult(shadreg_div_dmult[9:0]),
				     .shadreg_div_jmult(shadreg_div_jmult[9:0]),
				     .a_dbginit_dl(a_dbginit_dl),
				     .a_grst_dl(a_grst_dl),
				     .cmp_dbginit_cl_l(cmp_dbginit_cl_l),
				     .cmp_gclk_out(cmp_gclk_out),
				     .cmp_grst_cl_l(cmp_grst_cl_l),
				     .coin_edge(coin_edge),
				     .ctu_dram_rx_sync_cl(ctu_dram_rx_sync_cl), // Templated
				     .ctu_dram_tx_sync_cl(ctu_dram_tx_sync_cl), // Templated
				     .ctu_jbi_ssiclk(ctu_jbi_ssiclk),
				     .ctu_jbus_rx_sync_cl(ctu_jbus_rx_sync_cl), // Templated
				     .ctu_jbus_tx_sync_cl(ctu_jbus_tx_sync_cl), // Templated
				     .de_dbginit_dsync_edge_dl(de_dbginit_dsync_edge_dl),
				     .de_dbginit_jsync_edge(de_dbginit_jsync_edge),
				     .de_grst_dsync_edge_dl(de_grst_dsync_edge_dl),
				     .de_grst_jsync_edge(de_grst_jsync_edge),
				     .dram_gclk_out(dram_gclk_out),
				     .jbus_gclk_dup_out(jbus_gclk_dup_out),
				     .jbus_mult_rst_l(jbus_mult_rst_l),
				     // Inputs
				     .a_dbginit_cl(a_dbginit_cl),
				     .a_grst_cl(a_grst_cl),
				     .clk_stretch_cnt_val_6(clk_stretch_cnt_val_6),
				     .clk_stretch_cnt_val_odd(clk_stretch_cnt_val_odd),
				     .clk_stretch_trig(clk_stretch_trig),
				     .cmp_clk(cmp_clk),
				     .ctu_dram_tx_sync_early(ctu_dram_tx_sync_early),
				     .de_dbginit_cl(de_dbginit_cl),
				     .de_grst_cl(de_grst_cl),
				     .dft_clsp_nstep_capture_l(dft_clsp_nstep_capture_l),
				     .dram_a_grst_cl(dram_a_grst_cl),
				     .dsync_reg_init(dsync_reg_init[4:0]),
				     .dsync_reg_period(dsync_reg_period[4:0]),
				     .dsync_reg_rx0(dsync_reg_rx0[1:0]),
				     .dsync_reg_rx1(dsync_reg_rx1[1:0]),
				     .dsync_reg_rx2(dsync_reg_rx2[1:0]),
				     .dsync_reg_tx0(dsync_reg_tx0[4:0]),
				     .dsync_reg_tx1(dsync_reg_tx1[4:0]),
				     .dsync_reg_tx2(dsync_reg_tx2[4:0]),
				     .io_pwron_rst_l(io_pwron_rst_l),
				     .io_tck2(io_tck2),
				     .jbus_clk(jbus_clk),
				     .jbus_tx_sync(jbus_tx_sync), // Templated
				     .jsync_reg_init(jsync_reg_init[4:0]),
				     .jsync_reg_period(jsync_reg_period[4:0]),
				     .jsync_reg_rx0(jsync_reg_rx0[1:0]),
				     .jsync_reg_rx1(jsync_reg_rx1[1:0]),
				     .jsync_reg_rx2(jsync_reg_rx2[1:0]),
				     .jsync_reg_tx0(jsync_reg_tx0[4:0]),
				     .jsync_reg_tx1(jsync_reg_tx1[4:0]),
				     .jsync_reg_tx2(jsync_reg_tx2[4:0]),
				     .jtag_clock_dr(jtag_clock_dr),
				     .jtag_clsp_force_cken_cmp(jtag_clsp_force_cken_cmp),
				     .jtag_clsp_force_cken_dram(jtag_clsp_force_cken_dram),
				     .jtag_clsp_force_cken_jbus(jtag_clsp_force_cken_jbus),
				     .jtag_clsp_sel_cpu(jtag_clsp_sel_cpu[2:0]),
				     .jtag_clsp_sel_dram(jtag_clsp_sel_dram[2:0]),
				     .jtag_clsp_sel_jbus(jtag_clsp_sel_jbus[2:0]),
				     .jtag_clsp_sel_tck2(jtag_clsp_sel_tck2),
				     .jtag_nstep_count(jtag_nstep_count[3:0]),
				     .jtag_nstep_domain(jtag_nstep_domain[2:0]),
				     .jtag_nstep_vld(jtag_nstep_vld),
				     .pll_clk_out(pll_clk_out),
				     .pll_clk_out_l(pll_clk_out_l),
				     .pll_clk_out_pre(pll_clk_out_pre),
				     .pll_clk_out_pre_l(pll_clk_out_pre_l),
				     .pll_raw_clk_out(pll_raw_clk_out),
				     .pll_reset_ref_dly1_l(pll_reset_ref_dly1_l),
				     .reg_cdiv_0(reg_cdiv_0),
				     .reg_cdiv_vec(reg_cdiv_vec[14:0]),
				     .reg_ddiv_0(reg_ddiv_0),
				     .reg_ddiv_vec(reg_ddiv_vec[14:0]),
				     .reg_div_cmult(reg_div_cmult[13:0]),
				     .reg_div_dmult(reg_div_dmult[9:0]),
				     .reg_div_jmult(reg_div_jmult[9:0]),
				     .reg_jdiv_0(reg_jdiv_0),
				     .reg_jdiv_vec(reg_jdiv_vec[14:0]),
				     .se(se),
				     .ssiclk_enable(ssiclk_enable),
				     .start_2clk_early_jl(start_2clk_early_jl),
				     .start_clk_cl(start_clk_cl),
				     .start_clk_early_jl(start_clk_early_jl),
				     .stretch_cnt_vec(stretch_cnt_vec[14:0]),
				     .testmode_l(testmode_l),
				     .update_shadow_cl(update_shadow_cl));




endmodule // ctu_clsp_creg

// Local Variables:
// verilog-library-directories:("." "../../clk/rtl" "../../../common/rtl" "../../common/rtl")
// verilog-library-files:("../../common/rtl/swrvr_u1_clib.v" "../../common/rtl/cluster_header_sync.v")
// verilog-auto-sense-defines-constant:t
// End:
