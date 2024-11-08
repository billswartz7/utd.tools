// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu.v
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
/////////////////////////////////////////////////////////////////////////
//
//    Cluster Name:  CTU
//
//-----------------------------------------------------------------------------

`include "sys.h"
`include "iop.h"

module ctu (/*AUTOARG*/
// Outputs
tap_iob_vld, tap_iob_stall, tap_iob_data, pscan_select, 
jbus_grst_out_l, jbus_gdbginit_out_l, jbus_gclk_out, 
jbus_gclk_dup_out, jbus_arst_l, jbus_adbginit_l, 
global_scan_bypass_en, dram_grst_out_l, dram_gdbginit_out_l, 
dram_gclk_out, dram_arst_l, dram_adbginit_l, ctu_tst_scan_disable, 
ctu_spc_sscan_tid, ctu_spc_const_maskid, ctu_spc7_tck, 
ctu_spc7_sscan_se, ctu_spc7_mbisten, ctu_spc7_cmp_cken, ctu_spc6_tck, 
ctu_spc6_sscan_se, ctu_spc6_mbisten, ctu_spc6_cmp_cken, ctu_spc5_tck, 
ctu_spc5_sscan_se, ctu_spc5_mbisten, ctu_spc5_cmp_cken, ctu_spc4_tck, 
ctu_spc4_sscan_se, ctu_spc4_mbisten, ctu_spc4_cmp_cken, ctu_spc3_tck, 
ctu_spc3_sscan_se, ctu_spc3_mbisten, ctu_spc3_cmp_cken, ctu_spc2_tck, 
ctu_spc2_sscan_se, ctu_spc2_mbisten, ctu_spc2_cmp_cken, ctu_spc1_tck, 
ctu_spc1_sscan_se, ctu_spc1_mbisten, ctu_spc1_cmp_cken, ctu_spc0_tck, 
ctu_spc0_sscan_se, ctu_spc0_mbisten, ctu_spc0_cmp_cken, 
ctu_sctag3_mbisten, ctu_sctag3_cmp_cken, ctu_sctag2_mbisten, 
ctu_sctag2_cmp_cken, ctu_sctag1_mbisten, ctu_sctag1_cmp_cken, 
ctu_sctag0_mbisten, ctu_sctag0_cmp_cken, ctu_scdata3_cmp_cken, 
ctu_scdata2_cmp_cken, ctu_scdata1_cmp_cken, ctu_scdata0_cmp_cken, 
ctu_pads_sscan_update, ctu_pads_so, ctu_pads_bso, ctu_misc_update_dr, 
ctu_misc_shift_dr, ctu_misc_mode_ctl, ctu_misc_jbus_cken, 
ctu_misc_hiz_l, ctu_misc_clock_dr, ctu_jbusr_update_dr, 
ctu_jbusr_shift_dr, ctu_jbusr_mode_ctl, ctu_jbusr_jbus_cken, 
ctu_jbusr_hiz_l, ctu_jbusr_clock_dr, ctu_jbusl_update_dr, 
ctu_jbusl_shift_dr, ctu_jbusl_mode_ctl, ctu_jbusl_jbus_cken, 
ctu_jbusl_hiz_l, ctu_jbusl_clock_dr, ctu_jbi_jbus_cken, 
ctu_jbi_cmp_cken, ctu_iob_wake_thr, ctu_iob_resetstat_wr, 
ctu_iob_resetstat, ctu_iob_jbus_cken, ctu_iob_cmp_cken, 
ctu_io_tsr_testio, ctu_io_tdo_en, ctu_io_tdo, ctu_io_j_err, 
ctu_io_clkobs, ctu_global_snap, ctu_fpu_so, ctu_fpu_cmp_cken, 
ctu_efc_updatedr, ctu_efc_tck, ctu_efc_shiftdr, ctu_efc_rowaddr, 
ctu_efc_read_mode, ctu_efc_read_en, ctu_efc_jbus_cken, 
ctu_efc_fuse_bypass, ctu_efc_dest_sample, ctu_efc_data_in, 
ctu_efc_coladdr, ctu_efc_capturedr, ctu_dram_selfrsh, 
ctu_dram13_jbus_cken, ctu_dram13_dram_cken, ctu_dram13_cmp_cken, 
ctu_dram02_jbus_cken, ctu_dram02_dram_cken, ctu_dram02_cmp_cken, 
ctu_dll3_byp_val, ctu_dll3_byp_l, ctu_dll2_byp_val, ctu_dll2_byp_l, 
ctu_dll1_byp_val, ctu_dll1_byp_l, ctu_dll0_byp_val, ctu_dll0_byp_l, 
ctu_debug_update_dr, ctu_debug_shift_dr, ctu_debug_mode_ctl, 
ctu_debug_hiz_l, ctu_debug_clock_dr, ctu_ddr_testmode_l, 
ctu_ddr3_update_dr, ctu_ddr3_shift_dr, ctu_ddr3_mode_ctl, 
ctu_ddr3_iodll_rst_l, ctu_ddr3_hiz_l, ctu_ddr3_dram_cken, 
ctu_ddr3_dll_delayctr, ctu_ddr3_clock_dr, ctu_ddr2_update_dr, 
ctu_ddr2_shift_dr, ctu_ddr2_mode_ctl, ctu_ddr2_iodll_rst_l, 
ctu_ddr2_hiz_l, ctu_ddr2_dram_cken, ctu_ddr2_dll_delayctr, 
ctu_ddr2_clock_dr, ctu_ddr1_update_dr, ctu_ddr1_shift_dr, 
ctu_ddr1_mode_ctl, ctu_ddr1_iodll_rst_l, ctu_ddr1_hiz_l, 
ctu_ddr1_dram_cken, ctu_ddr1_dll_delayctr, ctu_ddr1_clock_dr, 
ctu_ddr0_update_dr, ctu_ddr0_shift_dr, ctu_ddr0_mode_ctl, 
ctu_ddr0_iodll_rst_l, ctu_ddr0_hiz_l, ctu_ddr0_dram_cken, 
ctu_ddr0_dll_delayctr, ctu_ddr0_clock_dr, ctu_dbg_jbus_cken, 
ctu_ccx_cmp_cken, cmp_gdbginit_out_l, cmp_gclk_out, cmp_arst_l, 
cmp_adbginit_l, clsp_iob_vld, clsp_iob_stall, clsp_iob_data, 
afo_tsr_dout, afo_rt_data_out, afo_rt_ack, afo_rng_data, afo_rng_clk, 
ctu_tst_pre_grst_l, global_shift_enable, ctu_tst_scanmode, 
ctu_tst_macrotest, ctu_tst_short_chain, ctu_efc_read_start, 
ctu_jbi_ssiclk, ctu_dram_rx_sync_out, ctu_dram_tx_sync_out, 
ctu_jbus_rx_sync_out, ctu_jbus_tx_sync_out, cmp_grst_out_l, 
// Inputs
spc7_ctu_sscan_out, spc7_ctu_mbisterr, spc7_ctu_mbistdone, 
spc6_ctu_sscan_out, spc6_ctu_mbisterr, spc6_ctu_mbistdone, 
spc5_ctu_sscan_out, spc5_ctu_mbisterr, spc5_ctu_mbistdone, 
spc4_ctu_sscan_out, spc4_ctu_mbisterr, spc4_ctu_mbistdone, 
spc3_ctu_sscan_out, spc3_ctu_mbisterr, spc3_ctu_mbistdone, 
spc2_ctu_sscan_out, spc2_ctu_mbisterr, spc2_ctu_mbistdone, 
spc1_ctu_sscan_out, spc1_ctu_mbisterr, spc1_ctu_mbistdone, 
spc0_ctu_sscan_out, spc0_ctu_mbisterr, spc0_ctu_mbistdone, 
sctag3_ctu_tr, sctag3_ctu_mbisterr, sctag3_ctu_mbistdone, 
sctag2_ctu_tr, sctag2_ctu_serial_scan_in, sctag2_ctu_mbisterr, 
sctag2_ctu_mbistdone, sctag1_ctu_tr, sctag1_ctu_mbisterr, 
sctag1_ctu_mbistdone, sctag0_ctu_tr, sctag0_ctu_mbisterr, 
sctag0_ctu_mbistdone, pads_ctu_si, pads_ctu_bsi, jbus_grst_l, 
jbus_gclk_dup, jbus_gclk_cts, jbus_gclk, jbi_ctu_tr, iob_tap_vld, 
iob_tap_stall, iob_tap_data, iob_ctu_tr, iob_ctu_l2_tr, 
iob_ctu_coreavail, iob_clsp_vld, iob_clsp_stall, iob_clsp_data, 
io_vreg_selbg_l, io_vdda_tsr, io_vdda_rng, io_vdda_pll, io_trst_l, 
io_tms, io_test_mode, io_tdi, io_tck2, io_tck, io_pwron_rst_l, 
io_pll_char_in, io_j_rst_l, io_do_bist, io_clk_stretch, 
efc_ctu_data_out, dram_gclk_cts, dram13_ctu_tr, dram02_ctu_tr, 
dll3_ctu_ctrl, dll2_ctu_ctrl, dll1_ctu_ctrl, dll0_ctu_ctrl, 
ddr3_ctu_dll_overflow, ddr3_ctu_dll_lock, ddr2_ctu_dll_overflow, 
ddr2_ctu_dll_lock, ddr1_ctu_dll_overflow, ddr1_ctu_dll_lock, 
ddr0_ctu_dll_overflow, ddr0_ctu_dll_lock, cmp_gclk_cts, cmp_gclk, 
afi_tsr_tsel, afi_tsr_div, afi_rt_valid, afi_rt_read_write, 
afi_rt_high_low, afi_rt_data_in, afi_rt_addr_data, afi_rng_ctl, 
afi_pll_div2, afi_pll_clamp_fltr, afi_pll_char_mode, afi_bypass_mode, 
afi_bist_mode, afi_pll_trst_l, afi_tsr_mode, io_j_clk
);



   //***********************
   //
   // UNCONNECTED PORTS 
   //
   //***********************

   //input                  efc_ctu_si;
   //output                 ctu_efc_so;
   //output [5:0]           ctu_rpt_cmp_spare ;     // To gclk_flop_cluster_a_0 of bw_clk_gclkflop.v
   //output                 ctu_pads_sscan_in ;


   // NO longer needed; keep for Int 4.0 only
   //input                dram_grst_l;
   //input              ctu_dram_tx_sync;
   //input		ctu_jbus_rx_sync;	// From ctu_clsp of ctu_clsp.v
   //input		ctu_jbus_tx_sync;	// From ctu_clsp of ctu_clsp.v

   // ------------------


   input                afi_pll_trst_l;    // check assertion level
   input                afi_tsr_mode;
   input [1:0]          io_j_clk;               // To ctu_digital of ctu_digital.v, ...

   output               ctu_tst_pre_grst_l;
   output		global_shift_enable;	// From ctu_dft of ctu_dft.v
   output               ctu_tst_scanmode;	// From ctu_dft of ctu_dft.v
   output		ctu_tst_macrotest;	// From ctu_dft of ctu_dft.v
   output		ctu_tst_short_chain;	// From ctu_dft of ctu_dft.v
   output               ctu_efc_read_start;
   output               ctu_jbi_ssiclk;
   output		ctu_dram_rx_sync_out;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dram_tx_sync_out;	// From ctu_clsp of ctu_clsp.v
   output		ctu_jbus_rx_sync_out;	// From ctu_clsp of ctu_clsp.v
   output		ctu_jbus_tx_sync_out;	// From ctu_clsp of ctu_clsp.v
   output		cmp_grst_out_l;		// From ctu_clsp of ctu_clsp.v


   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		afo_rng_clk;		// From u_rng of bw_rng.v
   output		afo_rng_data;		// From u_rng of bw_rng.v
   output		afo_rt_ack;		// From ctu_dft of ctu_dft.v
   output [31:0]	afo_rt_data_out;	// From ctu_dft of ctu_dft.v
   output [7:0]		afo_tsr_dout;		// From u_tsr of bw_tsr.v
   output [`CLK_IOB_WIDTH-1:0]clsp_iob_data;	// From ctu_clsp of ctu_clsp.v
   output		clsp_iob_stall;		// From ctu_clsp of ctu_clsp.v
   output		clsp_iob_vld;		// From ctu_clsp of ctu_clsp.v
   output		cmp_adbginit_l;		// From ctu_clsp of ctu_clsp.v
   output		cmp_arst_l;		// From ctu_clsp of ctu_clsp.v
   output		cmp_gclk_out;		// From ctu_clsp of ctu_clsp.v
   output		cmp_gdbginit_out_l;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ccx_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dbg_jbus_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ddr0_clock_dr;	// From ctu_dft of ctu_dft.v
   output [2:0]		ctu_ddr0_dll_delayctr;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ddr0_dram_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ddr0_hiz_l;		// From ctu_dft of ctu_dft.v
   output		ctu_ddr0_iodll_rst_l;	// From u_ctu_ddr0_iodll_rst_l_or2_ecobug of ctu_or2.v
   output		ctu_ddr0_mode_ctl;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr0_shift_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr0_update_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr1_clock_dr;	// From ctu_dft of ctu_dft.v
   output [2:0]		ctu_ddr1_dll_delayctr;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ddr1_dram_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ddr1_hiz_l;		// From ctu_dft of ctu_dft.v
   output		ctu_ddr1_iodll_rst_l;	// From u_ctu_ddr1_iodll_rst_l_or2_ecobug of ctu_or2.v
   output		ctu_ddr1_mode_ctl;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr1_shift_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr1_update_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr2_clock_dr;	// From ctu_dft of ctu_dft.v
   output [2:0]		ctu_ddr2_dll_delayctr;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ddr2_dram_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ddr2_hiz_l;		// From ctu_dft of ctu_dft.v
   output		ctu_ddr2_iodll_rst_l;	// From u_ctu_ddr2_iodll_rst_l_or2_ecobug of ctu_or2.v
   output		ctu_ddr2_mode_ctl;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr2_shift_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr2_update_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr3_clock_dr;	// From ctu_dft of ctu_dft.v
   output [2:0]		ctu_ddr3_dll_delayctr;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ddr3_dram_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_ddr3_hiz_l;		// From ctu_dft of ctu_dft.v
   output		ctu_ddr3_iodll_rst_l;	// From u_ctu_ddr3_iodll_rst_l_or2_ecobug of ctu_or2.v
   output		ctu_ddr3_mode_ctl;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr3_shift_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr3_update_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_ddr_testmode_l;	// From ctu_dft of ctu_dft.v
   output		ctu_debug_clock_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_debug_hiz_l;	// From ctu_dft of ctu_dft.v
   output		ctu_debug_mode_ctl;	// From ctu_dft of ctu_dft.v
   output		ctu_debug_shift_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_debug_update_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_dll0_byp_l;		// From ctu_clsp of ctu_clsp.v
   output [4:0]		ctu_dll0_byp_val;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dll1_byp_l;		// From ctu_clsp of ctu_clsp.v
   output [4:0]		ctu_dll1_byp_val;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dll2_byp_l;		// From ctu_clsp of ctu_clsp.v
   output [4:0]		ctu_dll2_byp_val;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dll3_byp_l;		// From ctu_clsp of ctu_clsp.v
   output [4:0]		ctu_dll3_byp_val;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dram02_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dram02_dram_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dram02_jbus_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dram13_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dram13_dram_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dram13_jbus_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_dram_selfrsh;	// From ctu_clsp of ctu_clsp.v
   output		ctu_efc_capturedr;	// From ctu_dft of ctu_dft.v
   output [4:0]		ctu_efc_coladdr;	// From ctu_dft of ctu_dft.v
   output		ctu_efc_data_in;	// From ctu_dft of ctu_dft.v
   output		ctu_efc_dest_sample;	// From ctu_dft of ctu_dft.v
   output		ctu_efc_fuse_bypass;	// From ctu_dft of ctu_dft.v
   output		ctu_efc_jbus_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_efc_read_en;	// From ctu_dft of ctu_dft.v
   output [2:0]		ctu_efc_read_mode;	// From ctu_dft of ctu_dft.v
   output [6:0]		ctu_efc_rowaddr;	// From ctu_dft of ctu_dft.v
   output		ctu_efc_shiftdr;	// From ctu_dft of ctu_dft.v
   output		ctu_efc_tck;		// From ctu_dft of ctu_dft.v
   output		ctu_efc_updatedr;	// From ctu_dft of ctu_dft.v
   output		ctu_fpu_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_fpu_so;		// From ctu_dft of ctu_dft.v
   output		ctu_global_snap;	// From ctu_dft of ctu_dft.v
   output [1:0]		ctu_io_clkobs;		// From u_pll of bw_pll.v
   output		ctu_io_j_err;		// From ctu_clsp of ctu_clsp.v
   output		ctu_io_tdo;		// From u_test_stub of ctu_test_stub_scan.v
   output		ctu_io_tdo_en;		// From ctu_dft of ctu_dft.v
   output [1:0]		ctu_io_tsr_testio;	// From u_tsr of bw_tsr.v
   output		ctu_iob_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_iob_jbus_cken;	// From ctu_clsp of ctu_clsp.v
   output [2:0]		ctu_iob_resetstat;	// From ctu_clsp of ctu_clsp.v
   output		ctu_iob_resetstat_wr;	// From ctu_clsp of ctu_clsp.v
   output		ctu_iob_wake_thr;	// From ctu_clsp of ctu_clsp.v
   output		ctu_jbi_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_jbi_jbus_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_jbusl_clock_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_jbusl_hiz_l;	// From ctu_dft of ctu_dft.v
   output		ctu_jbusl_jbus_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_jbusl_mode_ctl;	// From ctu_dft of ctu_dft.v
   output		ctu_jbusl_shift_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_jbusl_update_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_jbusr_clock_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_jbusr_hiz_l;	// From ctu_dft of ctu_dft.v
   output		ctu_jbusr_jbus_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_jbusr_mode_ctl;	// From ctu_dft of ctu_dft.v
   output		ctu_jbusr_shift_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_jbusr_update_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_misc_clock_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_misc_hiz_l;		// From ctu_dft of ctu_dft.v
   output		ctu_misc_jbus_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_misc_mode_ctl;	// From ctu_dft of ctu_dft.v
   output		ctu_misc_shift_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_misc_update_dr;	// From ctu_dft of ctu_dft.v
   output		ctu_pads_bso;		// From ctu_dft of ctu_dft.v
   output		ctu_pads_so;		// From ctu_dft of ctu_dft.v
   output		ctu_pads_sscan_update;	// From ctu_dft of ctu_dft.v
   output		ctu_scdata0_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_scdata1_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_scdata2_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_scdata3_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_sctag0_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_sctag0_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_sctag1_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_sctag1_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_sctag2_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_sctag2_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_sctag3_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_sctag3_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_spc0_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_spc0_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_spc0_sscan_se;	// From ctu_dft of ctu_dft.v
   output		ctu_spc0_tck;		// From ctu_dft of ctu_dft.v
   output		ctu_spc1_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_spc1_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_spc1_sscan_se;	// From ctu_dft of ctu_dft.v
   output		ctu_spc1_tck;		// From ctu_dft of ctu_dft.v
   output		ctu_spc2_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_spc2_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_spc2_sscan_se;	// From ctu_dft of ctu_dft.v
   output		ctu_spc2_tck;		// From ctu_dft of ctu_dft.v
   output		ctu_spc3_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_spc3_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_spc3_sscan_se;	// From ctu_dft of ctu_dft.v
   output		ctu_spc3_tck;		// From ctu_dft of ctu_dft.v
   output		ctu_spc4_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_spc4_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_spc4_sscan_se;	// From ctu_dft of ctu_dft.v
   output		ctu_spc4_tck;		// From ctu_dft of ctu_dft.v
   output		ctu_spc5_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_spc5_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_spc5_sscan_se;	// From ctu_dft of ctu_dft.v
   output		ctu_spc5_tck;		// From ctu_dft of ctu_dft.v
   output		ctu_spc6_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_spc6_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_spc6_sscan_se;	// From ctu_dft of ctu_dft.v
   output		ctu_spc6_tck;		// From ctu_dft of ctu_dft.v
   output		ctu_spc7_cmp_cken;	// From ctu_clsp of ctu_clsp.v
   output		ctu_spc7_mbisten;	// From ctu_dft of ctu_dft.v
   output		ctu_spc7_sscan_se;	// From ctu_dft of ctu_dft.v
   output		ctu_spc7_tck;		// From ctu_dft of ctu_dft.v
   output [7:0]		ctu_spc_const_maskid;	// From ctu_clsp of ctu_clsp.v
   output [3:0]		ctu_spc_sscan_tid;	// From ctu_dft of ctu_dft.v
   output		ctu_tst_scan_disable;	// From ctu_dft of ctu_dft.v
   output		dram_adbginit_l;	// From ctu_clsp of ctu_clsp.v
   output		dram_arst_l;		// From ctu_clsp of ctu_clsp.v
   output		dram_gclk_out;		// From ctu_clsp of ctu_clsp.v
   output		dram_gdbginit_out_l;	// From ctu_clsp of ctu_clsp.v
   output		dram_grst_out_l;	// From ctu_clsp of ctu_clsp.v
   output		global_scan_bypass_en;	// From ctu_dft of ctu_dft.v
   output		jbus_adbginit_l;	// From ctu_clsp of ctu_clsp.v
   output		jbus_arst_l;		// From ctu_clsp of ctu_clsp.v
   output		jbus_gclk_dup_out;	// From ctu_clsp of ctu_clsp.v
   output		jbus_gclk_out;		// From ctu_clsp of ctu_clsp.v
   output		jbus_gdbginit_out_l;	// From ctu_clsp of ctu_clsp.v
   output		jbus_grst_out_l;	// From ctu_clsp of ctu_clsp.v
   output		pscan_select;		// From ctu_dft of ctu_dft.v
   output [7:0]		tap_iob_data;		// From ctu_dft of ctu_dft.v
   output		tap_iob_stall;		// From ctu_dft of ctu_dft.v
   output		tap_iob_vld;		// From ctu_dft of ctu_dft.v
   // End of automatics

   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		afi_bist_mode;		// To ctu_dft of ctu_dft.v
   input		afi_bypass_mode;	// To ctu_dft of ctu_dft.v
   input		afi_pll_char_mode;	// To ctu_dft of ctu_dft.v
   input		afi_pll_clamp_fltr;	// To ctu_dft of ctu_dft.v
   input [5:0]		afi_pll_div2;		// To ctu_dft of ctu_dft.v
   input [2:0]		afi_rng_ctl;		// To ctu_dft of ctu_dft.v
   input		afi_rt_addr_data;	// To ctu_dft of ctu_dft.v
   input [31:0]		afi_rt_data_in;		// To ctu_dft of ctu_dft.v
   input		afi_rt_high_low;	// To ctu_dft of ctu_dft.v
   input		afi_rt_read_write;	// To ctu_dft of ctu_dft.v
   input		afi_rt_valid;		// To ctu_dft of ctu_dft.v
   input [9:1]		afi_tsr_div;		// To ctu_dft of ctu_dft.v
   input [7:0]		afi_tsr_tsel;		// To ctu_dft of ctu_dft.v
   input		cmp_gclk;		// To u_cmp_header of bw_clk_cl_ctu_cmp.v
   input		cmp_gclk_cts;		// To u_cmp_gclk_dr of bw_u1_ckbuf_40x.v
   input		ddr0_ctu_dll_lock;	// To ctu_clsp of ctu_clsp.v
   input		ddr0_ctu_dll_overflow;	// To ctu_clsp of ctu_clsp.v
   input		ddr1_ctu_dll_lock;	// To ctu_clsp of ctu_clsp.v
   input		ddr1_ctu_dll_overflow;	// To ctu_clsp of ctu_clsp.v
   input		ddr2_ctu_dll_lock;	// To ctu_clsp of ctu_clsp.v
   input		ddr2_ctu_dll_overflow;	// To ctu_clsp of ctu_clsp.v
   input		ddr3_ctu_dll_lock;	// To ctu_clsp of ctu_clsp.v
   input		ddr3_ctu_dll_overflow;	// To ctu_clsp of ctu_clsp.v
   input [4:0]		dll0_ctu_ctrl;		// To ctu_clsp of ctu_clsp.v
   input [4:0]		dll1_ctu_ctrl;		// To ctu_clsp of ctu_clsp.v
   input [4:0]		dll2_ctu_ctrl;		// To ctu_clsp of ctu_clsp.v
   input [4:0]		dll3_ctu_ctrl;		// To ctu_clsp of ctu_clsp.v
   input		dram02_ctu_tr;		// To ctu_clsp of ctu_clsp.v
   input		dram13_ctu_tr;		// To ctu_clsp of ctu_clsp.v
   input		dram_gclk_cts;		// To u_dram_gclk_dr of bw_u1_ckbuf_30x.v
   input		efc_ctu_data_out;	// To ctu_dft of ctu_dft.v
   input		io_clk_stretch;		// To ctu_clsp of ctu_clsp.v
   input		io_do_bist;		// To ctu_clsp of ctu_clsp.v
   input		io_j_rst_l;		// To ctu_clsp of ctu_clsp.v
   input		io_pll_char_in;		// To ctu_clsp of ctu_clsp.v, ...
   input		io_pwron_rst_l;		// To ctu_clsp of ctu_clsp.v, ...
   input		io_tck;			// To u_tck_dr of bw_u1_ckbuf_30x.v, ...
   input		io_tck2;		// To ctu_clsp of ctu_clsp.v
   input		io_tdi;			// To ctu_dft of ctu_dft.v
   input		io_test_mode;		// To ctu_dft of ctu_dft.v
   input		io_tms;			// To ctu_dft of ctu_dft.v
   input		io_trst_l;		// To ctu_dft of ctu_dft.v
   input		io_vdda_pll;		// To u_pll of bw_pll.v
   input		io_vdda_rng;		// To u_rng of bw_rng.v
   input		io_vdda_tsr;		// To u_tsr of bw_tsr.v
   input		io_vreg_selbg_l;	// To u_rng of bw_rng.v, ...
   input [`IOB_CLK_WIDTH-1:0]iob_clsp_data;	// To ctu_clsp of ctu_clsp.v
   input		iob_clsp_stall;		// To ctu_clsp of ctu_clsp.v
   input		iob_clsp_vld;		// To ctu_clsp of ctu_clsp.v
   input [`IOB_CPU_WIDTH-1:0]iob_ctu_coreavail;	// To ctu_dft of ctu_dft.v
   input		iob_ctu_l2_tr;		// To ctu_clsp of ctu_clsp.v
   input		iob_ctu_tr;		// To ctu_clsp of ctu_clsp.v
   input [7:0]		iob_tap_data;		// To ctu_dft of ctu_dft.v
   input		iob_tap_stall;		// To ctu_dft of ctu_dft.v
   input		iob_tap_vld;		// To ctu_dft of ctu_dft.v
   input		jbi_ctu_tr;		// To ctu_clsp of ctu_clsp.v
   input		jbus_gclk;		// To u_jbus_header of bw_clk_cl_ctu_jbus.v
   input		jbus_gclk_cts;		// To u_jbus_gclk_dr of bw_u1_ckbuf_30x.v
   input		jbus_gclk_dup;		// To u_pll of bw_pll.v
   input		jbus_grst_l;		// To u_jbus_header of bw_clk_cl_ctu_jbus.v
   input		pads_ctu_bsi;		// To ctu_dft of ctu_dft.v
   input		pads_ctu_si;		// To ctu_dft of ctu_dft.v
   input		sctag0_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		sctag0_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		sctag0_ctu_tr;		// To ctu_clsp of ctu_clsp.v
   input		sctag1_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		sctag1_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		sctag1_ctu_tr;		// To ctu_clsp of ctu_clsp.v
   input		sctag2_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		sctag2_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		sctag2_ctu_serial_scan_in;// To ctu_dft of ctu_dft.v
   input		sctag2_ctu_tr;		// To ctu_clsp of ctu_clsp.v
   input		sctag3_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		sctag3_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		sctag3_ctu_tr;		// To ctu_clsp of ctu_clsp.v
   input		spc0_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		spc0_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		spc0_ctu_sscan_out;	// To ctu_dft of ctu_dft.v
   input		spc1_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		spc1_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		spc1_ctu_sscan_out;	// To ctu_dft of ctu_dft.v
   input		spc2_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		spc2_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		spc2_ctu_sscan_out;	// To ctu_dft of ctu_dft.v
   input		spc3_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		spc3_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		spc3_ctu_sscan_out;	// To ctu_dft of ctu_dft.v
   input		spc4_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		spc4_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		spc4_ctu_sscan_out;	// To ctu_dft of ctu_dft.v
   input		spc5_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		spc5_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		spc5_ctu_sscan_out;	// To ctu_dft of ctu_dft.v
   input		spc6_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		spc6_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		spc6_ctu_sscan_out;	// To ctu_dft of ctu_dft.v
   input		spc7_ctu_mbistdone;	// To ctu_dft of ctu_dft.v
   input		spc7_ctu_mbisterr;	// To ctu_dft of ctu_dft.v
   input		spc7_ctu_sscan_out;	// To ctu_dft of ctu_dft.v
   // End of automatics

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [5:0]		clsp_bist_ctrl;		// From ctu_clsp of ctu_clsp.v
   wire			clsp_bist_dobist;	// From ctu_clsp of ctu_clsp.v
   wire			clsp_bist_type;		// From ctu_clsp of ctu_clsp.v
   wire			cmp_clk;		// From u_cmp_header of bw_clk_cl_ctu_cmp.v
   wire			cmp_gclk_int;		// From u_cmp_gclk_dr of bw_u1_ckbuf_40x.v
   wire			cmp_grst_l;		// From u_cmp_header_cmp_rst_pipe3 of dff_ns.v
   wire			cmp_grst_pipe1_l;	// From u_cmp_header_cmp_rst_pipe1 of dff_ns.v
   wire			cmp_grst_pipe2_l;	// From u_cmp_header_cmp_rst_pipe2 of dff_ns.v
   wire			cmp_pre_rst_l;		// From u_cmp_header of bw_clk_cl_ctu_cmp.v
   wire			cmp_rst_l;		// From u_cmp_header_cmp_rst_l of dffrl_async_ns.v
   wire			ctu_ddr0_iodll_rst_l_tmp;// From ctu_clsp of ctu_clsp.v
   wire			ctu_ddr1_iodll_rst_l_tmp;// From ctu_clsp of ctu_clsp.v
   wire			ctu_ddr2_iodll_rst_l_tmp;// From ctu_clsp of ctu_clsp.v
   wire			ctu_ddr3_iodll_rst_l_tmp;// From ctu_clsp of ctu_clsp.v
   wire			ctu_dram_tx_sync_early;	// From u_sync_header of ctu_sync_header.v
   wire [2:0]		ctu_sel_cpu;		// From ctu_dft of ctu_dft.v
   wire [2:0]		ctu_sel_dram;		// From ctu_dft of ctu_dft.v
   wire [2:0]		ctu_sel_jbus;		// From ctu_dft of ctu_dft.v
   wire			dft_clsp_nstep_capture_l;// From ctu_dft of ctu_dft.v
   wire			dft_ctu_scan_disable;	// From ctu_dft of ctu_dft.v
   wire			dft_pin_pscan_l;	// From ctu_dft of ctu_dft.v
   wire			dft_pll_arst_l;		// From ctu_dft of ctu_dft.v
   wire			dft_pll_clamp_fltr;	// From ctu_dft of ctu_dft.v
   wire [5:0]		dft_pll_div2;		// From ctu_dft of ctu_dft.v
   wire			dft_pll_testmode;	// From ctu_dft of ctu_dft.v
   wire			dft_rng_rst_l;		// From ctu_dft of ctu_dft.v
   wire [2:0]		dft_rng_vctrl;		// From ctu_dft of ctu_dft.v
   wire			dft_tdo;		// From ctu_dft of ctu_dft.v
   wire [9:1]		dft_tsr_div;		// From ctu_dft of ctu_dft.v
   wire			dft_tsr_reset_l;	// From ctu_dft of ctu_dft.v
   wire [7:0]		dft_tsr_tsel;		// From ctu_dft of ctu_dft.v
   wire			dft_wake_thr;		// From ctu_dft of ctu_dft.v
   wire			dram_gclk_int;		// From u_dram_gclk_dr of bw_u1_ckbuf_30x.v
   wire			jbus_clk;		// From u_jbus_header of bw_clk_cl_ctu_jbus.v
   wire			jbus_gclk_int;		// From u_jbus_gclk_dr of bw_u1_ckbuf_30x.v
   wire			jbus_rst_l;		// From u_jbus_header of bw_clk_cl_ctu_jbus.v
   wire			jbus_rx_sync;		// From u_sync_header of ctu_sync_header.v
   wire			jbus_tx_sync;		// From u_sync_header of ctu_sync_header.v
   wire			jtag_clock_dr;		// From ctu_dft of ctu_dft.v
   wire			jtag_clsp_force_cken_cmp;// From ctu_dft of ctu_dft.v
   wire			jtag_clsp_force_cken_dram;// From ctu_dft of ctu_dft.v
   wire			jtag_clsp_force_cken_jbus;// From ctu_dft of ctu_dft.v
   wire			jtag_clsp_ignore_wrm_rst;// From ctu_dft of ctu_dft.v
   wire			jtag_clsp_sel_tck2;	// From ctu_dft of ctu_dft.v
   wire [5:0]		jtag_clsp_stop_id;	// From ctu_dft of ctu_dft.v
   wire			jtag_clsp_stop_id_vld;	// From ctu_dft of ctu_dft.v
   wire [3:0]		jtag_id;		// From u_revision of ctu_revision.v
   wire [3:0]		jtag_nstep_count;	// From ctu_dft of ctu_dft.v
   wire [2:0]		jtag_nstep_domain;	// From ctu_dft of ctu_dft.v
   wire			jtag_nstep_vld;		// From ctu_dft of ctu_dft.v
   wire [3:0]		mask_major_id;		// From u_revision of ctu_revision.v
   wire [3:0]		mask_minor_id;		// From u_revision of ctu_revision.v
   wire			pll_bypass;		// From ctu_dft of ctu_dft.v
   wire			pll_clk_out;		// From u_pll_clkdr0 of bw_clk_cl_ctu_2xcmp.v
   wire			pll_clk_out_l;		// From u_pll_clkdr1 of bw_clk_cl_ctu_2xcmp_b.v
   wire			pll_clk_out_pre;	// From u_pll of bw_pll.v
   wire			pll_clk_out_pre_l;	// From u_pll of bw_pll.v
   wire			pll_raw_clk_out;	// From u_pll of bw_pll.v
   wire			pll_reset_ref_l;	// From ctu_clsp of ctu_clsp.v
   wire			se;			// From u_test_stub of ctu_test_stub_scan.v
   wire			start_clk_early_jl;	// From ctu_clsp of ctu_clsp.v
   wire			start_clk_jl;		// From ctu_clsp of ctu_clsp.v
   wire			tck_cts;		// From u_tck_dr of bw_u1_ckbuf_30x.v
   wire			tck_l_cts;		// From u_tck_l_dr of bw_u1_inv_30x.v
   wire			testmode_l;		// From ctu_dft of ctu_dft.v
   // End of automatics

   wire 	        ctu_tst_pre_grst_l;
   wire                 MT_long_chain_so_0;

//synopsys translate_off


//    check to see all clk select should be 1 hot
       always @ ( /*AUTOSENSE*/ctu_sel_cpu or ctu_sel_dram
		 or ctu_sel_jbus or io_trst_l)
       begin
           #1 ; // wait for comb logic to settle 
           if(  (io_trst_l === 1'b1) &
                (ctu_sel_cpu[2:0] !== 3'b100) &
                (ctu_sel_cpu[2:0] !== 3'b010) &
                (ctu_sel_cpu[2:0] !== 3'b001) 
             )
		`ifdef MODELSIM
           $display ( "CTU_not_one_hot_error",
                    "Select signals to cmp clkswitch are not one hot: %h",
                     ctu_sel_cpu[2:0] );
		`else
           $error ( "CTU_not_one_hot_error",
                    "Select signals to cmp clkswitch are not one hot: %h",
                     ctu_sel_cpu[2:0] );
		`endif

           if(  (io_trst_l === 1'b1) &
                (ctu_sel_dram[2:0] !== 3'b100) &
                (ctu_sel_dram[2:0] !== 3'b010) &
                (ctu_sel_dram[2:0] !== 3'b001) 
             )
		`ifdef MODELSIM
           $display ( "CTU_not_one_hot_error",
                    "Select signals to dram clkswitch are not one hot: %h",
                     ctu_sel_dram[2:0] );
		`else
           $error ( "CTU_not_one_hot_error",
                    "Select signals to dram clkswitch are not one hot: %h",
                     ctu_sel_dram[2:0] );
		`endif
           if(  (io_trst_l === 1'b1) &
                (ctu_sel_jbus[2:0] !== 3'b100) &
                (ctu_sel_jbus[2:0] !== 3'b010) &
                (ctu_sel_jbus[2:0] !== 3'b001) 
             )
		`ifdef MODELSIM
           $display ( "CTU_not_one_hot_error",
                    "Select signals to jbus clkswitch are not one hot: %h",
                     ctu_sel_jbus[2:0] );
		`else
           $error ( "CTU_not_one_hot_error",
                    "Select signals to jbus clkswitch are not one hot: %h",
                     ctu_sel_jbus[2:0] );
		`endif
      end

//synopsys translate_on

/* ctu_or2  AUTO_TEMPLATE (
 .a (ctu_ddr@_iodll_rst_l_tmp),
 .b (ctu_tst_scanmode),
 .z (ctu_ddr@_iodll_rst_l),
 ); */
ctu_or2 u_ctu_ddr0_iodll_rst_l_or2_ecobug (/*AUTOINST*/
					   // Outputs
					   .z(ctu_ddr0_iodll_rst_l), // Templated
					   // Inputs
					   .a(ctu_ddr0_iodll_rst_l_tmp), // Templated
					   .b(ctu_tst_scanmode)); // Templated
ctu_or2 u_ctu_ddr1_iodll_rst_l_or2_ecobug (/*AUTOINST*/
					   // Outputs
					   .z(ctu_ddr1_iodll_rst_l), // Templated
					   // Inputs
					   .a(ctu_ddr1_iodll_rst_l_tmp), // Templated
					   .b(ctu_tst_scanmode)); // Templated
ctu_or2 u_ctu_ddr2_iodll_rst_l_or2_ecobug (/*AUTOINST*/
					   // Outputs
					   .z(ctu_ddr2_iodll_rst_l), // Templated
					   // Inputs
					   .a(ctu_ddr2_iodll_rst_l_tmp), // Templated
					   .b(ctu_tst_scanmode)); // Templated
ctu_or2 u_ctu_ddr3_iodll_rst_l_or2_ecobug (/*AUTOINST*/
					   // Outputs
					   .z(ctu_ddr3_iodll_rst_l), // Templated
					   // Inputs
					   .a(ctu_ddr3_iodll_rst_l_tmp), // Templated
					   .b(ctu_tst_scanmode)); // Templated



   /* ctu_clsp AUTO_TEMPLATE (
    .jbus_dupl_tst_clk			(1'b0), // NOT CONNECTED YET
    .ctu_sparc\([0-7]\)_cmp_cken	(ctu_spc\1_cmp_cken),
    .jtag_clsp_sel_cpu                  (ctu_sel_cpu[2:0]),
    .jtag_clsp_sel_dram                 (ctu_sel_dram[2:0]),
    .jtag_clsp_sel_jbus                 (ctu_sel_jbus[2:0]),
    .cmp_gclk				(cmp_gclk_int),
    .dram_gclk				(dram_gclk_int),
    .jbus_gclk				(jbus_gclk_int),
    .ctu_ddr0_iodll_rst_l		(ctu_ddr0_iodll_rst_l_tmp),
    .ctu_ddr1_iodll_rst_l		(ctu_ddr1_iodll_rst_l_tmp),
    .ctu_ddr2_iodll_rst_l		(ctu_ddr2_iodll_rst_l_tmp),
    .ctu_ddr3_iodll_rst_l		(ctu_ddr3_iodll_rst_l_tmp),
   ); */
   ctu_clsp ctu_clsp
   (/*AUTOINST*/
    // Outputs
    .clsp_bist_ctrl			(clsp_bist_ctrl[5:0]),
    .clsp_bist_dobist			(clsp_bist_dobist),
    .clsp_bist_type			(clsp_bist_type),
    .clsp_iob_data			(clsp_iob_data[`CLK_IOB_WIDTH-1:0]),
    .clsp_iob_stall			(clsp_iob_stall),
    .clsp_iob_vld			(clsp_iob_vld),
    .cmp_adbginit_l			(cmp_adbginit_l),
    .cmp_arst_l				(cmp_arst_l),
    .cmp_gclk_out			(cmp_gclk_out),
    .cmp_gdbginit_out_l			(cmp_gdbginit_out_l),
    .cmp_grst_out_l			(cmp_grst_out_l),
    .ctu_ccx_cmp_cken			(ctu_ccx_cmp_cken),
    .ctu_dbg_jbus_cken			(ctu_dbg_jbus_cken),
    .ctu_ddr0_dll_delayctr		(ctu_ddr0_dll_delayctr[2:0]),
    .ctu_ddr0_dram_cken			(ctu_ddr0_dram_cken),
    .ctu_ddr1_dll_delayctr		(ctu_ddr1_dll_delayctr[2:0]),
    .ctu_ddr1_dram_cken			(ctu_ddr1_dram_cken),
    .ctu_ddr1_iodll_rst_l		(ctu_ddr1_iodll_rst_l_tmp), // Templated
    .ctu_ddr2_dll_delayctr		(ctu_ddr2_dll_delayctr[2:0]),
    .ctu_ddr2_dram_cken			(ctu_ddr2_dram_cken),
    .ctu_ddr2_iodll_rst_l		(ctu_ddr2_iodll_rst_l_tmp), // Templated
    .ctu_ddr3_dll_delayctr		(ctu_ddr3_dll_delayctr[2:0]),
    .ctu_ddr3_dram_cken			(ctu_ddr3_dram_cken),
    .ctu_ddr3_iodll_rst_l		(ctu_ddr3_iodll_rst_l_tmp), // Templated
    .ctu_dll0_byp_l			(ctu_dll0_byp_l),
    .ctu_dll0_byp_val			(ctu_dll0_byp_val[4:0]),
    .ctu_dll1_byp_l			(ctu_dll1_byp_l),
    .ctu_dll1_byp_val			(ctu_dll1_byp_val[4:0]),
    .ctu_dll2_byp_l			(ctu_dll2_byp_l),
    .ctu_dll2_byp_val			(ctu_dll2_byp_val[4:0]),
    .ctu_dll3_byp_l			(ctu_dll3_byp_l),
    .ctu_dll3_byp_val			(ctu_dll3_byp_val[4:0]),
    .ctu_dram02_cmp_cken		(ctu_dram02_cmp_cken),
    .ctu_dram02_dram_cken		(ctu_dram02_dram_cken),
    .ctu_dram02_jbus_cken		(ctu_dram02_jbus_cken),
    .ctu_dram13_cmp_cken		(ctu_dram13_cmp_cken),
    .ctu_dram13_dram_cken		(ctu_dram13_dram_cken),
    .ctu_dram13_jbus_cken		(ctu_dram13_jbus_cken),
    .ctu_dram_rx_sync_out		(ctu_dram_rx_sync_out),
    .ctu_dram_selfrsh			(ctu_dram_selfrsh),
    .ctu_dram_tx_sync_out		(ctu_dram_tx_sync_out),
    .ctu_efc_jbus_cken			(ctu_efc_jbus_cken),
    .ctu_efc_read_start			(ctu_efc_read_start),
    .ctu_fpu_cmp_cken			(ctu_fpu_cmp_cken),
    .ctu_io_j_err			(ctu_io_j_err),
    .ctu_iob_cmp_cken			(ctu_iob_cmp_cken),
    .ctu_iob_jbus_cken			(ctu_iob_jbus_cken),
    .ctu_iob_resetstat			(ctu_iob_resetstat[2:0]),
    .ctu_iob_resetstat_wr		(ctu_iob_resetstat_wr),
    .ctu_iob_wake_thr			(ctu_iob_wake_thr),
    .ctu_jbi_cmp_cken			(ctu_jbi_cmp_cken),
    .ctu_jbi_jbus_cken			(ctu_jbi_jbus_cken),
    .ctu_jbi_ssiclk			(ctu_jbi_ssiclk),
    .ctu_jbus_tx_sync_out		(ctu_jbus_tx_sync_out),
    .ctu_jbusl_jbus_cken		(ctu_jbusl_jbus_cken),
    .ctu_jbusr_jbus_cken		(ctu_jbusr_jbus_cken),
    .ctu_misc_jbus_cken			(ctu_misc_jbus_cken),
    .ctu_scdata0_cmp_cken		(ctu_scdata0_cmp_cken),
    .ctu_scdata1_cmp_cken		(ctu_scdata1_cmp_cken),
    .ctu_scdata2_cmp_cken		(ctu_scdata2_cmp_cken),
    .ctu_scdata3_cmp_cken		(ctu_scdata3_cmp_cken),
    .ctu_sctag0_cmp_cken		(ctu_sctag0_cmp_cken),
    .ctu_sctag1_cmp_cken		(ctu_sctag1_cmp_cken),
    .ctu_sctag2_cmp_cken		(ctu_sctag2_cmp_cken),
    .ctu_sctag3_cmp_cken		(ctu_sctag3_cmp_cken),
    .ctu_sparc0_cmp_cken		(ctu_spc0_cmp_cken),	 // Templated
    .ctu_sparc1_cmp_cken		(ctu_spc1_cmp_cken),	 // Templated
    .ctu_sparc2_cmp_cken		(ctu_spc2_cmp_cken),	 // Templated
    .ctu_sparc3_cmp_cken		(ctu_spc3_cmp_cken),	 // Templated
    .ctu_sparc4_cmp_cken		(ctu_spc4_cmp_cken),	 // Templated
    .ctu_sparc5_cmp_cken		(ctu_spc5_cmp_cken),	 // Templated
    .ctu_sparc6_cmp_cken		(ctu_spc6_cmp_cken),	 // Templated
    .ctu_sparc7_cmp_cken		(ctu_spc7_cmp_cken),	 // Templated
    .ctu_spc_const_maskid		(ctu_spc_const_maskid[7:0]),
    .ctu_tst_pre_grst_l			(ctu_tst_pre_grst_l),
    .dram_adbginit_l			(dram_adbginit_l),
    .dram_arst_l			(dram_arst_l),
    .dram_gclk_out			(dram_gclk_out),
    .dram_gdbginit_out_l		(dram_gdbginit_out_l),
    .dram_grst_out_l			(dram_grst_out_l),
    .jbus_adbginit_l			(jbus_adbginit_l),
    .jbus_arst_l			(jbus_arst_l),
    .jbus_gclk_dup_out			(jbus_gclk_dup_out),
    .jbus_gclk_out			(jbus_gclk_out),
    .jbus_gdbginit_out_l		(jbus_gdbginit_out_l),
    .jbus_grst_out_l			(jbus_grst_out_l),
    .pll_reset_ref_l			(pll_reset_ref_l),
    .ctu_ddr0_iodll_rst_l		(ctu_ddr0_iodll_rst_l_tmp), // Templated
    .ctu_jbus_rx_sync_out		(ctu_jbus_rx_sync_out),
    .start_clk_jl			(start_clk_jl),
    .start_clk_early_jl			(start_clk_early_jl),
    // Inputs
    .cmp_clk				(cmp_clk),
    .cmp_gclk				(cmp_gclk_int),		 // Templated
    .ctu_dram_tx_sync_early		(ctu_dram_tx_sync_early),
    .ddr0_ctu_dll_lock			(ddr0_ctu_dll_lock),
    .ddr0_ctu_dll_overflow		(ddr0_ctu_dll_overflow),
    .ddr1_ctu_dll_lock			(ddr1_ctu_dll_lock),
    .ddr1_ctu_dll_overflow		(ddr1_ctu_dll_overflow),
    .ddr2_ctu_dll_lock			(ddr2_ctu_dll_lock),
    .ddr2_ctu_dll_overflow		(ddr2_ctu_dll_overflow),
    .ddr3_ctu_dll_lock			(ddr3_ctu_dll_lock),
    .ddr3_ctu_dll_overflow		(ddr3_ctu_dll_overflow),
    .dft_clsp_nstep_capture_l		(dft_clsp_nstep_capture_l),
    .dft_wake_thr			(dft_wake_thr),
    .dll0_ctu_ctrl			(dll0_ctu_ctrl[4:0]),
    .dll1_ctu_ctrl			(dll1_ctu_ctrl[4:0]),
    .dll2_ctu_ctrl			(dll2_ctu_ctrl[4:0]),
    .dll3_ctu_ctrl			(dll3_ctu_ctrl[4:0]),
    .dram02_ctu_tr			(dram02_ctu_tr),
    .dram13_ctu_tr			(dram13_ctu_tr),
    .dram_gclk				(dram_gclk_int),	 // Templated
    .io_clk_stretch			(io_clk_stretch),
    .io_do_bist				(io_do_bist),
    .io_j_rst_l				(io_j_rst_l),
    .io_pll_char_in			(io_pll_char_in),
    .io_pwron_rst_l			(io_pwron_rst_l),
    .io_tck2				(io_tck2),
    .iob_clsp_data			(iob_clsp_data[`IOB_CLK_WIDTH-1:0]),
    .iob_clsp_stall			(iob_clsp_stall),
    .iob_clsp_vld			(iob_clsp_vld),
    .iob_ctu_l2_tr			(iob_ctu_l2_tr),
    .iob_ctu_tr				(iob_ctu_tr),
    .jbi_ctu_tr				(jbi_ctu_tr),
    .jbus_clk				(jbus_clk),
    .jbus_gclk				(jbus_gclk_int),	 // Templated
    .jbus_rst_l				(jbus_rst_l),
    .jbus_rx_sync			(jbus_rx_sync),
    .jbus_tx_sync			(jbus_tx_sync),
    .jtag_clock_dr			(jtag_clock_dr),
    .jtag_clsp_force_cken_cmp		(jtag_clsp_force_cken_cmp),
    .jtag_clsp_force_cken_dram		(jtag_clsp_force_cken_dram),
    .jtag_clsp_force_cken_jbus		(jtag_clsp_force_cken_jbus),
    .jtag_clsp_ignore_wrm_rst		(jtag_clsp_ignore_wrm_rst),
    .jtag_clsp_sel_cpu			(ctu_sel_cpu[2:0]),	 // Templated
    .jtag_clsp_sel_dram			(ctu_sel_dram[2:0]),	 // Templated
    .jtag_clsp_sel_jbus			(ctu_sel_jbus[2:0]),	 // Templated
    .jtag_clsp_sel_tck2			(jtag_clsp_sel_tck2),
    .jtag_clsp_stop_id			(jtag_clsp_stop_id[5:0]),
    .jtag_clsp_stop_id_vld		(jtag_clsp_stop_id_vld),
    .jtag_nstep_count			(jtag_nstep_count[3:0]),
    .jtag_nstep_domain			(jtag_nstep_domain[2:0]),
    .jtag_nstep_vld			(jtag_nstep_vld),
    .mask_major_id			(mask_major_id[3:0]),
    .mask_minor_id			(mask_minor_id[3:0]),
    .pll_clk_out			(pll_clk_out),
    .pll_clk_out_l			(pll_clk_out_l),
    .pll_clk_out_pre			(pll_clk_out_pre),
    .pll_clk_out_pre_l			(pll_clk_out_pre_l),
    .pll_raw_clk_out			(pll_raw_clk_out),
    .sctag0_ctu_tr			(sctag0_ctu_tr),
    .sctag1_ctu_tr			(sctag1_ctu_tr),
    .sctag2_ctu_tr			(sctag2_ctu_tr),
    .sctag3_ctu_tr			(sctag3_ctu_tr),
    .se					(se),
    .testmode_l				(testmode_l));


   /* ctu_dft AUTO_TEMPLATE (
    .rt_data_in				(afi_rt_data_in[]),
    .pscan_mode_pin                     (afi_pscan_mode),
    .pll_bypass_pin                     (afi_bypass_mode),
    .rt_high_low                        (afi_rt_high_low),
    .rt_read_write                      (afi_rt_read_write),
    .rt_addr_data                       (afi_rt_addr_data),
    .rt_valid                           (afi_rt_valid),
    .rt_data_out                        (afo_rt_data_out[]),
    .rt_ack                             (afo_rt_ack),
    .shift_en_pin                       (afi_shift_en),
    .bist_mode_pin                      (afi_bist_mode),
    .test_mode_pin                      (io_test_mode),
    .io_tdo_en				(ctu_io_tdo_en),
    .cmp_rx_en				(jbus_rx_sync),
    .cmp_tx_en				(jbus_tx_sync),
    .io_tck                             (tck_cts),
    .tck_l                              (tck_l_cts),
    ); */
   ctu_dft ctu_dft
   (/*AUTOINST*/
    // Outputs
    .ctu_ddr0_clock_dr			(ctu_ddr0_clock_dr),
    .ctu_ddr0_hiz_l			(ctu_ddr0_hiz_l),
    .ctu_ddr0_mode_ctl			(ctu_ddr0_mode_ctl),
    .ctu_ddr0_shift_dr			(ctu_ddr0_shift_dr),
    .ctu_ddr0_update_dr			(ctu_ddr0_update_dr),
    .ctu_ddr1_clock_dr			(ctu_ddr1_clock_dr),
    .ctu_ddr1_hiz_l			(ctu_ddr1_hiz_l),
    .ctu_ddr1_mode_ctl			(ctu_ddr1_mode_ctl),
    .ctu_ddr1_shift_dr			(ctu_ddr1_shift_dr),
    .ctu_ddr1_update_dr			(ctu_ddr1_update_dr),
    .ctu_ddr2_clock_dr			(ctu_ddr2_clock_dr),
    .ctu_ddr2_hiz_l			(ctu_ddr2_hiz_l),
    .ctu_ddr2_mode_ctl			(ctu_ddr2_mode_ctl),
    .ctu_ddr2_shift_dr			(ctu_ddr2_shift_dr),
    .ctu_ddr2_update_dr			(ctu_ddr2_update_dr),
    .ctu_ddr3_clock_dr			(ctu_ddr3_clock_dr),
    .ctu_ddr3_hiz_l			(ctu_ddr3_hiz_l),
    .ctu_ddr3_mode_ctl			(ctu_ddr3_mode_ctl),
    .ctu_ddr3_shift_dr			(ctu_ddr3_shift_dr),
    .ctu_ddr3_update_dr			(ctu_ddr3_update_dr),
    .ctu_ddr_testmode_l			(ctu_ddr_testmode_l),
    .ctu_debug_clock_dr			(ctu_debug_clock_dr),
    .ctu_debug_hiz_l			(ctu_debug_hiz_l),
    .ctu_debug_mode_ctl			(ctu_debug_mode_ctl),
    .ctu_debug_shift_dr			(ctu_debug_shift_dr),
    .ctu_debug_update_dr		(ctu_debug_update_dr),
    .ctu_efc_capturedr			(ctu_efc_capturedr),
    .ctu_efc_coladdr			(ctu_efc_coladdr[4:0]),
    .ctu_efc_data_in			(ctu_efc_data_in),
    .ctu_efc_dest_sample		(ctu_efc_dest_sample),
    .ctu_efc_fuse_bypass		(ctu_efc_fuse_bypass),
    .ctu_efc_read_en			(ctu_efc_read_en),
    .ctu_efc_read_mode			(ctu_efc_read_mode[2:0]),
    .ctu_efc_rowaddr			(ctu_efc_rowaddr[6:0]),
    .ctu_efc_shiftdr			(ctu_efc_shiftdr),
    .ctu_efc_tck			(ctu_efc_tck),
    .ctu_efc_updatedr			(ctu_efc_updatedr),
    .ctu_fpu_so				(ctu_fpu_so),
    .ctu_global_snap			(ctu_global_snap),
    .ctu_jbusl_clock_dr			(ctu_jbusl_clock_dr),
    .ctu_jbusl_hiz_l			(ctu_jbusl_hiz_l),
    .ctu_jbusl_mode_ctl			(ctu_jbusl_mode_ctl),
    .ctu_jbusl_shift_dr			(ctu_jbusl_shift_dr),
    .ctu_jbusl_update_dr		(ctu_jbusl_update_dr),
    .ctu_jbusr_clock_dr			(ctu_jbusr_clock_dr),
    .ctu_jbusr_hiz_l			(ctu_jbusr_hiz_l),
    .ctu_jbusr_mode_ctl			(ctu_jbusr_mode_ctl),
    .ctu_jbusr_shift_dr			(ctu_jbusr_shift_dr),
    .ctu_jbusr_update_dr		(ctu_jbusr_update_dr),
    .ctu_misc_clock_dr			(ctu_misc_clock_dr),
    .ctu_misc_hiz_l			(ctu_misc_hiz_l),
    .ctu_misc_mode_ctl			(ctu_misc_mode_ctl),
    .ctu_misc_shift_dr			(ctu_misc_shift_dr),
    .ctu_misc_update_dr			(ctu_misc_update_dr),
    .ctu_pads_bso			(ctu_pads_bso),
    .ctu_pads_so			(ctu_pads_so),
    .ctu_pads_sscan_update		(ctu_pads_sscan_update),
    .ctu_sctag0_mbisten			(ctu_sctag0_mbisten),
    .ctu_sctag1_mbisten			(ctu_sctag1_mbisten),
    .ctu_sctag2_mbisten			(ctu_sctag2_mbisten),
    .ctu_sctag3_mbisten			(ctu_sctag3_mbisten),
    .ctu_sel_cpu			(ctu_sel_cpu[2:0]),
    .ctu_sel_dram			(ctu_sel_dram[2:0]),
    .ctu_sel_jbus			(ctu_sel_jbus[2:0]),
    .ctu_spc0_mbisten			(ctu_spc0_mbisten),
    .ctu_spc0_sscan_se			(ctu_spc0_sscan_se),
    .ctu_spc0_tck			(ctu_spc0_tck),
    .ctu_spc1_mbisten			(ctu_spc1_mbisten),
    .ctu_spc1_sscan_se			(ctu_spc1_sscan_se),
    .ctu_spc1_tck			(ctu_spc1_tck),
    .ctu_spc2_mbisten			(ctu_spc2_mbisten),
    .ctu_spc2_sscan_se			(ctu_spc2_sscan_se),
    .ctu_spc2_tck			(ctu_spc2_tck),
    .ctu_spc3_mbisten			(ctu_spc3_mbisten),
    .ctu_spc3_sscan_se			(ctu_spc3_sscan_se),
    .ctu_spc3_tck			(ctu_spc3_tck),
    .ctu_spc4_mbisten			(ctu_spc4_mbisten),
    .ctu_spc4_sscan_se			(ctu_spc4_sscan_se),
    .ctu_spc4_tck			(ctu_spc4_tck),
    .ctu_spc5_mbisten			(ctu_spc5_mbisten),
    .ctu_spc5_sscan_se			(ctu_spc5_sscan_se),
    .ctu_spc5_tck			(ctu_spc5_tck),
    .ctu_spc6_mbisten			(ctu_spc6_mbisten),
    .ctu_spc6_sscan_se			(ctu_spc6_sscan_se),
    .ctu_spc6_tck			(ctu_spc6_tck),
    .ctu_spc7_mbisten			(ctu_spc7_mbisten),
    .ctu_spc7_sscan_se			(ctu_spc7_sscan_se),
    .ctu_spc7_tck			(ctu_spc7_tck),
    .ctu_spc_sscan_tid			(ctu_spc_sscan_tid[3:0]),
    .ctu_tst_macrotest			(ctu_tst_macrotest),
    .ctu_tst_scan_disable		(ctu_tst_scan_disable),
    .ctu_tst_scanmode			(ctu_tst_scanmode),
    .ctu_tst_short_chain		(ctu_tst_short_chain),
    .dft_clsp_nstep_capture_l		(dft_clsp_nstep_capture_l),
    .dft_ctu_scan_disable		(dft_ctu_scan_disable),
    .dft_pin_pscan_l			(dft_pin_pscan_l),
    .dft_pll_arst_l			(dft_pll_arst_l),
    .dft_pll_clamp_fltr			(dft_pll_clamp_fltr),
    .dft_pll_div2			(dft_pll_div2[5:0]),
    .dft_pll_testmode			(dft_pll_testmode),
    .dft_rng_rst_l			(dft_rng_rst_l),
    .dft_rng_vctrl			(dft_rng_vctrl[2:0]),
    .dft_tdo				(dft_tdo),
    .dft_tsr_div			(dft_tsr_div[9:1]),
    .dft_tsr_reset_l			(dft_tsr_reset_l),
    .dft_tsr_tsel			(dft_tsr_tsel[7:0]),
    .dft_wake_thr			(dft_wake_thr),
    .global_scan_bypass_en		(global_scan_bypass_en),
    .global_shift_enable		(global_shift_enable),
    .io_tdo_en				(ctu_io_tdo_en),	 // Templated
    .jtag_clock_dr			(jtag_clock_dr),
    .jtag_clsp_force_cken_cmp		(jtag_clsp_force_cken_cmp),
    .jtag_clsp_force_cken_dram		(jtag_clsp_force_cken_dram),
    .jtag_clsp_force_cken_jbus		(jtag_clsp_force_cken_jbus),
    .jtag_clsp_ignore_wrm_rst		(jtag_clsp_ignore_wrm_rst),
    .jtag_clsp_sel_tck2			(jtag_clsp_sel_tck2),
    .jtag_clsp_stop_id			(jtag_clsp_stop_id[5:0]),
    .jtag_clsp_stop_id_vld		(jtag_clsp_stop_id_vld),
    .jtag_nstep_count			(jtag_nstep_count[3:0]),
    .jtag_nstep_domain			(jtag_nstep_domain[2:0]),
    .jtag_nstep_vld			(jtag_nstep_vld),
    .pll_bypass				(pll_bypass),
    .pscan_select			(pscan_select),
    .rt_ack				(afo_rt_ack),		 // Templated
    .rt_data_out			(afo_rt_data_out[31:0]), // Templated
    .tap_iob_data			(tap_iob_data[7:0]),
    .tap_iob_stall			(tap_iob_stall),
    .tap_iob_vld			(tap_iob_vld),
    .testmode_l				(testmode_l),
    // Inputs
    .afi_pll_char_mode			(afi_pll_char_mode),
    .afi_pll_clamp_fltr			(afi_pll_clamp_fltr),
    .afi_pll_div2			(afi_pll_div2[5:0]),
    .afi_pll_trst_l			(afi_pll_trst_l),
    .afi_rng_ctl			(afi_rng_ctl[2:0]),
    .afi_tsr_div			(afi_tsr_div[9:1]),
    .afi_tsr_mode			(afi_tsr_mode),
    .afi_tsr_tsel			(afi_tsr_tsel[7:0]),
    .bist_mode_pin			(afi_bist_mode),	 // Templated
    .clsp_bist_ctrl			(clsp_bist_ctrl[5:0]),
    .clsp_bist_dobist			(clsp_bist_dobist),
    .clsp_bist_type			(clsp_bist_type),
    .cmp_clk				(cmp_clk),
    .cmp_rst_l				(cmp_rst_l),
    .cmp_rx_en				(jbus_rx_sync),		 // Templated
    .cmp_tx_en				(jbus_tx_sync),		 // Templated
    .efc_ctu_data_out			(efc_ctu_data_out),
    .io_pwron_rst_l			(io_pwron_rst_l),
    .io_tck				(tck_cts),		 // Templated
    .io_tdi				(io_tdi),
    .io_tms				(io_tms),
    .io_trst_l				(io_trst_l),
    .iob_ctu_coreavail			(iob_ctu_coreavail[`IOB_CPU_WIDTH-1:0]),
    .iob_tap_data			(iob_tap_data[7:0]),
    .iob_tap_stall			(iob_tap_stall),
    .iob_tap_vld			(iob_tap_vld),
    .jbus_clk				(jbus_clk),
    .jbus_rst_l				(jbus_rst_l),
    .jtag_id				(jtag_id[3:0]),
    .pads_ctu_bsi			(pads_ctu_bsi),
    .pads_ctu_si			(pads_ctu_si),
    .pll_bypass_pin			(afi_bypass_mode),	 // Templated
    .pll_reset_ref_l			(pll_reset_ref_l),
    .rt_addr_data			(afi_rt_addr_data),	 // Templated
    .rt_data_in				(afi_rt_data_in[31:0]),	 // Templated
    .rt_high_low			(afi_rt_high_low),	 // Templated
    .rt_read_write			(afi_rt_read_write),	 // Templated
    .rt_valid				(afi_rt_valid),		 // Templated
    .sctag0_ctu_mbistdone		(sctag0_ctu_mbistdone),
    .sctag0_ctu_mbisterr		(sctag0_ctu_mbisterr),
    .sctag1_ctu_mbistdone		(sctag1_ctu_mbistdone),
    .sctag1_ctu_mbisterr		(sctag1_ctu_mbisterr),
    .sctag2_ctu_mbistdone		(sctag2_ctu_mbistdone),
    .sctag2_ctu_mbisterr		(sctag2_ctu_mbisterr),
    .sctag2_ctu_serial_scan_in		(sctag2_ctu_serial_scan_in),
    .sctag3_ctu_mbistdone		(sctag3_ctu_mbistdone),
    .sctag3_ctu_mbisterr		(sctag3_ctu_mbisterr),
    .spc0_ctu_mbistdone			(spc0_ctu_mbistdone),
    .spc0_ctu_mbisterr			(spc0_ctu_mbisterr),
    .spc0_ctu_sscan_out			(spc0_ctu_sscan_out),
    .spc1_ctu_mbistdone			(spc1_ctu_mbistdone),
    .spc1_ctu_mbisterr			(spc1_ctu_mbisterr),
    .spc1_ctu_sscan_out			(spc1_ctu_sscan_out),
    .spc2_ctu_mbistdone			(spc2_ctu_mbistdone),
    .spc2_ctu_mbisterr			(spc2_ctu_mbisterr),
    .spc2_ctu_sscan_out			(spc2_ctu_sscan_out),
    .spc3_ctu_mbistdone			(spc3_ctu_mbistdone),
    .spc3_ctu_mbisterr			(spc3_ctu_mbisterr),
    .spc3_ctu_sscan_out			(spc3_ctu_sscan_out),
    .spc4_ctu_mbistdone			(spc4_ctu_mbistdone),
    .spc4_ctu_mbisterr			(spc4_ctu_mbisterr),
    .spc4_ctu_sscan_out			(spc4_ctu_sscan_out),
    .spc5_ctu_mbistdone			(spc5_ctu_mbistdone),
    .spc5_ctu_mbisterr			(spc5_ctu_mbisterr),
    .spc5_ctu_sscan_out			(spc5_ctu_sscan_out),
    .spc6_ctu_mbistdone			(spc6_ctu_mbistdone),
    .spc6_ctu_mbisterr			(spc6_ctu_mbisterr),
    .spc6_ctu_sscan_out			(spc6_ctu_sscan_out),
    .spc7_ctu_mbistdone			(spc7_ctu_mbistdone),
    .spc7_ctu_mbisterr			(spc7_ctu_mbisterr),
    .spc7_ctu_sscan_out			(spc7_ctu_sscan_out),
    .start_clk_jl			(start_clk_jl),
    .tck_l				(tck_l_cts),		 // Templated
    .test_mode_pin			(io_test_mode));		 // Templated

   /* bw_rng AUTO_TEMPLATE (
    .rng_data				(afo_rng_data),
    .rng_clk				(afo_rng_clk),
    // Inputs
    .rst_l                              (dft_rng_rst_l),
    .clk_jbus		                (jbus_clk),
    .vctrl				(dft_rng_vctrl[]),
    .sel_bg_l                           (io_vreg_selbg_l),
    .vsup_rng_hv18                      (io_vdda_rng),
    );
   */
   bw_rng u_rng (/*AUTOINST*/
		 // Outputs
		 .rng_data		(afo_rng_data),		 // Templated
		 .rng_clk		(afo_rng_clk),		 // Templated
		 // Inputs
		 .vsup_rng_hv18		(io_vdda_rng),		 // Templated
		 .sel_bg_l		(io_vreg_selbg_l),	 // Templated
		 .vctrl			(dft_rng_vctrl[2:0]),	 // Templated
		 .clk_jbus		(jbus_clk),		 // Templated
		 .rst_l			(dft_rng_rst_l));	 // Templated

  /* bw_pll AUTO_TEMPLATE (
    // Inputs:
    .pll_sys_clk                       ({io_j_clk[1],io_j_clk[0]}), // Differential System Clock Inputs
    .pll_bypass                        (pll_bypass),         // ctu_pll_bypass or bypass mode pin
    .pll_arst_l                        (dft_pll_arst_l),    // PLL Asynchronous Reset, active low
    .l2clk                             (jbus_gclk_dup),   // Feedback Clock from l2clk duplicated Grid
    .pll_clamp_fltr                    (dft_pll_clamp_fltr),
    .pll_div1                          (6'b00_0000),         // Frequency Divider 1 : Input Reference, cnt=div1+1
                                                             // For Niagara div1=0, => divide by 1
    .pll_div2                          (dft_pll_div2[]),     // Frequency Divider 2 : Feedback Clock , cnt=div2+1
                                                             // Program div2 to desired VCO frequency.
                                                             // Ex. sys_clk=200MHz, div2=0, vco=1.6GHz, clk_out=1.6GHz
    .pll_div3                          (6'b00_0000),         // Frequency Divider 3 : Clocktree Drive, cnt=div3+1
                                                             // For Niagara div3=0, => divide by 1
    .vdd_pll                           (io_vdda_pll),            // Vdd for PLL
    .pll_char_in                       (io_pll_char_in),     // Characterization In - gated with tesa_mode
    .testmode                          (dft_pll_testmode),   // PLL Test Mode. Default=0  
    .vreg_seldb_l                      (io_vreg_selbg_l),    // Default=0 
    // Outputs:
    .pll_raw_clk_out                   (pll_raw_clk_out),// Raw Clock Output from Differential Reciever
    .pll_vco_out                       (),                   // VCO Output
    .pll_clk_out                       (pll_clk_out_pre),    // PLL Clock Output to CTU Digital
    .pll_clk_out_l                     (pll_clk_out_pre_l),  // PLL Clock Output to CTU Digital, Invert of cktree_drv
    .pll_char_out                      (ctu_io_clkobs[]),
    // pll_char_out1 is the invert of pll_char_in (which match the previous release)
    // Characterization Output1 to IO
   ); */   
  bw_pll u_pll
  (
    /*AUTOINST*/
   // Outputs
   .pll_raw_clk_out			(pll_raw_clk_out),	 // Templated
   .pll_vco_out				(),			 // Templated
   .pll_clk_out				(pll_clk_out_pre),	 // Templated
   .pll_clk_out_l			(pll_clk_out_pre_l),	 // Templated
   .pll_char_out			(ctu_io_clkobs[1:0]),	 // Templated
   // Inputs
   .pll_sys_clk				({io_j_clk[1],io_j_clk[0]}), // Templated
   .pll_bypass				(pll_bypass),		 // Templated
   .pll_arst_l				(dft_pll_arst_l),	 // Templated
   .l2clk				(jbus_gclk_dup),	 // Templated
   .pll_clamp_fltr			(dft_pll_clamp_fltr),	 // Templated
   .pll_div1				(6'b00_0000),		 // Templated
   .pll_div2				(dft_pll_div2[5:0]),	 // Templated
   .pll_div3				(6'b00_0000),		 // Templated
   .vdd_pll				(io_vdda_pll),		 // Templated
   .pll_char_in				(io_pll_char_in),	 // Templated
   .testmode				(dft_pll_testmode),	 // Templated
   .vreg_seldb_l			(io_vreg_selbg_l));	 // Templated

   /* bw_tsr AUTO_TEMPLATE (
    // Inputs:
    .vdd_tsr                            (io_vdda_tsr),               // VDD for thermo sensor
    .div                                (dft_tsr_div[]) ,            // controls the macro speed, default  000011001
    .clk                                (jbus_clk) ,            // jbus clock for thermo sensor
    .tsel                               (dft_tsr_tsel[]),        // test mode control, default  00000000
    .reset_l				(dft_tsr_reset_l),
    .vreg_selbg_l                       (io_vreg_selbg_l),
    // Outputs:
    .dout                               (afo_tsr_dout[]),        // thermo sensor output (testmode pins)
    .testio                             (ctu_io_tsr_testio[]),   // c4 bumps with ESD structures
    .i50                                () ,                     //
    .v0p5                               () ,                     //
    ); */
   bw_tsr u_tsr
   (
    /*AUTOINST*/
    // Outputs
    .dout				(afo_tsr_dout[7:0]),	 // Templated
    .testio				(ctu_io_tsr_testio[1:0]), // Templated
    .i50				(),			 // Templated
    .v0p5				(),			 // Templated
    // Inputs
    .vdd_tsr				(io_vdda_tsr),		 // Templated
    .div				(dft_tsr_div[9:1]),	 // Templated
    .clk				(jbus_clk),		 // Templated
    .reset_l				(dft_tsr_reset_l),	 // Templated
    .tsel				(dft_tsr_tsel[7:0]),	 // Templated
    .vreg_selbg_l			(io_vreg_selbg_l));	 // Templated



    /* bw_clk_cl_ctu_jbus AUTO_TEMPLATE (
     .so                                (),
     .si                                (1'b0),
     .se                                (se),
     .cluster_cken                      (1'b1),
     .adbginit_l                        (1'b1),
     .gdbginit_l                        (1'b1),
     .arst_l                            (io_pwron_rst_l),
     .grst_l                            (jbus_grst_l),
     .gclk                              (jbus_gclk ),
     .rclk                              (jbus_clk ),
     .cluster_grst_l			(jbus_rst_l),
     .dbginit_l                         (),
     ); */
   bw_clk_cl_ctu_jbus u_jbus_header
   ( /*AUTOINST*/
    // Outputs
    .cluster_grst_l			(jbus_rst_l),		 // Templated
    .dbginit_l				(),			 // Templated
    .rclk				(jbus_clk ),		 // Templated
    .so					(),			 // Templated
    // Inputs
    .adbginit_l				(1'b1),			 // Templated
    .arst_l				(io_pwron_rst_l),	 // Templated
    .cluster_cken			(1'b1),			 // Templated
    .gclk				(jbus_gclk ),		 // Templated
    .gdbginit_l				(1'b1),			 // Templated
    .grst_l				(jbus_grst_l),		 // Templated
    .se					(se),			 // Templated
    .si					(1'b0));			 // Templated

 /* bw_clk_cl_ctu_cmp AUTO_TEMPLATE (
     .so                                (),
     .si                                (1'b0),
     .se                                (1'b0),
     .cluster_cken                      (1'b1),
     .adbginit_l                        (1'b1),
     .gdbginit_l                        (1'b1),
     .arst_l                            (io_pwron_rst_l),
     .grst_l                            (cmp_grst_l),
     .gclk                              (cmp_gclk),
     .rclk                              (cmp_clk ),
     .cluster_grst_l                    (cmp_pre_rst_l),
     .dbginit_l                         (),
     ); */


   bw_clk_cl_ctu_cmp u_cmp_header
   ( /*AUTOINST*/
    // Outputs
    .cluster_grst_l			(cmp_pre_rst_l),	 // Templated
    .dbginit_l				(),			 // Templated
    .rclk				(cmp_clk ),		 // Templated
    .so					(),			 // Templated
    // Inputs
    .adbginit_l				(1'b1),			 // Templated
    .arst_l				(io_pwron_rst_l),	 // Templated
    .cluster_cken			(1'b1),			 // Templated
    .gclk				(cmp_gclk),		 // Templated
    .gdbginit_l				(1'b1),			 // Templated
    .grst_l				(cmp_grst_l),		 // Templated
    .se					(1'b0),			 // Templated
    .si					(1'b0));			 // Templated


  // Duplicate the cmp pipe 

    /* dff_ns AUTO_TEMPLATE (
              .din (cmp_grst_out_l),
              .q (cmp_grst_pipe1_l),
              .rst_l(io_pwron_rst_l),
              .clk (cmp_gclk_int),
       );
     */
    dff_ns u_cmp_header_cmp_rst_pipe1(/*AUTOINST*/
				      // Outputs
				      .q(cmp_grst_pipe1_l),	 // Templated
				      // Inputs
				      .din(cmp_grst_out_l),	 // Templated
				      .clk(cmp_gclk_int));	 // Templated
    /* dff_ns AUTO_TEMPLATE (
              .din (cmp_grst_pipe1_l),
              .q (cmp_grst_pipe2_l),
              .rst_l(io_pwron_rst_l),
              .clk (cmp_gclk_int),
       );
     */
    dff_ns u_cmp_header_cmp_rst_pipe2(/*AUTOINST*/
				      // Outputs
				      .q(cmp_grst_pipe2_l),	 // Templated
				      // Inputs
				      .din(cmp_grst_pipe1_l),	 // Templated
				      .clk(cmp_gclk_int));	 // Templated
    /* dff_ns AUTO_TEMPLATE (
              .din (cmp_grst_pipe2_l),
              .q (cmp_grst_l),
              .rst_l(io_pwron_rst_l),
              .clk (cmp_gclk_int),
       );
     */
    dff_ns u_cmp_header_cmp_rst_pipe3(/*AUTOINST*/
				      // Outputs
				      .q(cmp_grst_l),		 // Templated
				      // Inputs
				      .din(cmp_grst_pipe2_l),	 // Templated
				      .clk(cmp_gclk_int));	 // Templated


    /* dffrl_async_ns AUTO_TEMPLATE (
              .din (cmp_pre_rst_l),
              .q (cmp_rst_l),
              .rst_l(io_pwron_rst_l),
              .clk (cmp_clk),
       );
     */
    dffrl_async_ns  u_cmp_header_cmp_rst_l(/*AUTOINST*/
					   // Outputs
					   .q(cmp_rst_l),	 // Templated
					   // Inputs
					   .din(cmp_pre_rst_l),	 // Templated
					   .clk(cmp_clk),	 // Templated
					   .rst_l(io_pwron_rst_l)); // Templated



    /* ctu_sync_header AUTO_TEMPLATE (
	.jbus_rx_sync(jbus_rx_sync),
	.jbus_tx_sync(jbus_tx_sync),
	.ctu_jbus_rx_sync(ctu_jbus_rx_sync_out),
	.ctu_jbus_tx_sync(ctu_jbus_tx_sync_out),
	.ctu_dram_tx_sync(ctu_dram_tx_sync_out),
        .cmp_rclk(cmp_clk),
        .cmp_gclk(cmp_gclk_int),
        .si (1'b0),
        .so	(),
      );
      */
    ctu_sync_header u_sync_header (/*AUTOINST*/
				   // Outputs
				   .ctu_dram_tx_sync_early(ctu_dram_tx_sync_early),
				   .jbus_rx_sync(jbus_rx_sync),	 // Templated
				   .jbus_tx_sync(jbus_tx_sync),	 // Templated
				   .so	(),			 // Templated
				   // Inputs
				   .cmp_clk(cmp_clk),
				   .cmp_gclk(cmp_gclk_int),	 // Templated
				   .ctu_dram_tx_sync(ctu_dram_tx_sync_out), // Templated
				   .ctu_jbus_rx_sync(ctu_jbus_rx_sync_out), // Templated
				   .ctu_jbus_tx_sync(ctu_jbus_tx_sync_out), // Templated
				   .se	(se),
				   .si	(1'b0),			 // Templated
				   .start_clk_early_jl(start_clk_early_jl));

    /* bw_u1_ckbuf_30x AUTO_TEMPLATE (
         .rclk (io_tck),
         .clk  (tck_cts),
       );
    */

    bw_u1_ckbuf_30x u_tck_dr (/*AUTOINST*/
			      // Outputs
			      .clk	(tck_cts),		 // Templated
			      // Inputs
			      .rclk	(io_tck));		 // Templated

    /* bw_u1_inv_30x AUTO_TEMPLATE (
         .a(io_tck),
         .z(tck_l_cts),
       );
    */

    bw_u1_inv_30x u_tck_l_dr (/*AUTOINST*/
			      // Outputs
			      .z	(tck_l_cts),		 // Templated
			      // Inputs
			      .a	(io_tck));		 // Templated




    /* bw_u1_ckbuf_40x AUTO_TEMPLATE (
         .rclk (cmp_gclk_cts),
         .clk  (cmp_gclk_int),
       );
    */

    bw_u1_ckbuf_40x u_cmp_gclk_dr (/*AUTOINST*/
				   // Outputs
				   .clk	(cmp_gclk_int),		 // Templated
				   // Inputs
				   .rclk(cmp_gclk_cts));		 // Templated


    /* bw_u1_ckbuf_30x AUTO_TEMPLATE (
         .rclk (jbus_gclk_cts),
         .clk  (jbus_gclk_int),
       );
    */

    bw_u1_ckbuf_30x u_jbus_gclk_dr (/*AUTOINST*/
				    // Outputs
				    .clk(jbus_gclk_int),	 // Templated
				    // Inputs
				    .rclk(jbus_gclk_cts));	 // Templated

    /* bw_u1_ckbuf_30x AUTO_TEMPLATE (
         .rclk (dram_gclk_cts),
         .clk  (dram_gclk_int),
       );
    */

    bw_u1_ckbuf_30x u_dram_gclk_dr (/*AUTOINST*/
				    // Outputs
				    .clk(dram_gclk_int),	 // Templated
				    // Inputs
				    .rclk(dram_gclk_cts));	 // Templated

  
  

    /* bw_clk_cl_ctu_2xcmp AUTO_TEMPLATE (
         .bw_pll_2xclk (pll_clk_out_pre),
         .bw_pll_2x_clk_local (pll_clk_out),
       );
    */

      bw_clk_cl_ctu_2xcmp u_pll_clkdr0 (/*AUTOINST*/
					// Outputs
					.bw_pll_2x_clk_local(pll_clk_out), // Templated
					// Inputs
					.bw_pll_2xclk(pll_clk_out_pre)); // Templated

    /* bw_clk_cl_ctu_2xcmp_b AUTO_TEMPLATE (
         .bw_pll_2xclk_b (pll_clk_out_pre_l),
         .bw_pll_2x_clk_local_b (pll_clk_out_l),
       );
    */
      bw_clk_cl_ctu_2xcmp_b u_pll_clkdr1 (/*AUTOINST*/
					  // Outputs
					  .bw_pll_2x_clk_local_b(pll_clk_out_l), // Templated
					  // Inputs
					  .bw_pll_2xclk_b(pll_clk_out_pre_l)); // Templated



//*******************************************************************************
// Test Stub
//*******************************************************************************

/*ctu_test_stub_scan AUTO_TEMPLATE (
 .ctu_tst_scan_disable (dft_ctu_scan_disable),
 .ctu_tst_short_chain  (dft_pin_pscan_l),
 .so_0                 (ctu_io_tdo),
 .short_chain_so_0     (dft_tdo),
 );*/

ctu_test_stub_scan u_test_stub (
			        .long_chain_so_0      (MT_long_chain_so_0),

			        /*AUTOINST*/
				// Outputs
				.se	(se),
				.so_0	(ctu_io_tdo),		 // Templated
				// Inputs
				.global_shift_enable(global_shift_enable),
				.ctu_tst_scan_disable(dft_ctu_scan_disable), // Templated
				.ctu_tst_short_chain(dft_pin_pscan_l), // Templated
				.short_chain_so_0(dft_tdo));	 // Templated
           
//*******************************************************************************
// Version register
//*******************************************************************************

ctu_revision u_revision ( /*AUTOINST*/
			 // Outputs
			 .jtag_id	(jtag_id[3:0]),
			 .mask_major_id	(mask_major_id[3:0]),
			 .mask_minor_id	(mask_minor_id[3:0]));

endmodule // ctu



//synopsys translate_off

module ctu_sync_pulse_check(/*AUTOARG*/
// Inputs
data, lclk, rclk, enable_chk
);

   input data;
   input lclk;
   input rclk;
   input enable_chk;

   parameter setup_clocks = 1 , 
             hold_clocks  = 0; 

   time  last_clk;
   time  last_data;
   time  first_edge;
   time  period;

   reg     enable_chk_int;

   always @( posedge rclk)
   begin
   if(enable_chk === 1'b1)
       first_edge = $time;
   end

   always @( negedge rclk)
   begin
     if(enable_chk === 1'b1)
        period = ($time - first_edge) * 2;
   end

  always @ (posedge rclk)
  if( ~enable_chk)
      enable_chk_int <= 1'b0;
  else
      enable_chk_int <= enable_chk; 

 always @ (posedge data) 
 begin 
         if((($time  - last_clk ) < ( setup_clocks * period)) & enable_chk_int 
           )
		`ifdef MODELSIM
           $display ( "CTU_mpath_error",
                    "Expect setup time : %t. Actual setup time %t",
                     (setup_clocks * period), ($time  - last_clk ));
		`else
           $error ( "CTU_mpath_error",
                    "Expect setup time : %t. Actual setup time %t",
                     (setup_clocks * period), ($time  - last_clk ));
		`endif
         last_data = $time;
  end

  always @ ( posedge lclk)
  begin
         if( (($time  - last_data) < ( hold_clocks * period)) & enable_chk_int 
           )
		`ifdef MODELSIM
           $display ( "CTU_mpath_error",
                    "Expect hold time : %t. Actual hold time %t",
                     (hold_clocks * period), ($time  - last_data ));
		`else
           $error ( "CTU_mpath_error",
                    "Expect hold time : %t. Actual hold time %t",
                     (hold_clocks * period), ($time  - last_data ));
		`endif
         last_clk = $time;
  end

   endmodule

//synopsys translate_on

