// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_dft.v
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

`include "sys.h"
`include "iop.h"
`include "ctu.h"

module ctu_dft (/*AUTOARG*/
// Outputs
testmode_l, tap_iob_vld, tap_iob_stall, tap_iob_data, rt_data_out, 
rt_ack, pscan_select, pll_bypass, jtag_nstep_vld, jtag_nstep_domain, 
jtag_nstep_count, jtag_clsp_stop_id_vld, jtag_clsp_stop_id, 
jtag_clsp_sel_tck2, jtag_clsp_ignore_wrm_rst, 
jtag_clsp_force_cken_jbus, jtag_clsp_force_cken_dram, 
jtag_clsp_force_cken_cmp, jtag_clock_dr, io_tdo_en, 
global_shift_enable, global_scan_bypass_en, dft_wake_thr, 
dft_tsr_tsel, dft_tsr_reset_l, dft_tsr_div, dft_tdo, dft_rng_vctrl, 
dft_rng_rst_l, dft_pll_testmode, dft_pll_div2, dft_pll_clamp_fltr, 
dft_pll_arst_l, dft_pin_pscan_l, dft_ctu_scan_disable, 
dft_clsp_nstep_capture_l, ctu_tst_short_chain, ctu_tst_scanmode, 
ctu_tst_scan_disable, ctu_tst_macrotest, ctu_spc_sscan_tid, 
ctu_spc7_tck, ctu_spc7_sscan_se, ctu_spc7_mbisten, ctu_spc6_tck, 
ctu_spc6_sscan_se, ctu_spc6_mbisten, ctu_spc5_tck, ctu_spc5_sscan_se, 
ctu_spc5_mbisten, ctu_spc4_tck, ctu_spc4_sscan_se, ctu_spc4_mbisten, 
ctu_spc3_tck, ctu_spc3_sscan_se, ctu_spc3_mbisten, ctu_spc2_tck, 
ctu_spc2_sscan_se, ctu_spc2_mbisten, ctu_spc1_tck, ctu_spc1_sscan_se, 
ctu_spc1_mbisten, ctu_spc0_tck, ctu_spc0_sscan_se, ctu_spc0_mbisten, 
ctu_sel_jbus, ctu_sel_dram, ctu_sel_cpu, ctu_sctag3_mbisten, 
ctu_sctag2_mbisten, ctu_sctag1_mbisten, ctu_sctag0_mbisten, 
ctu_pads_sscan_update, ctu_pads_so, ctu_pads_bso, ctu_misc_update_dr, 
ctu_misc_shift_dr, ctu_misc_mode_ctl, ctu_misc_hiz_l, 
ctu_misc_clock_dr, ctu_jbusr_update_dr, ctu_jbusr_shift_dr, 
ctu_jbusr_mode_ctl, ctu_jbusr_hiz_l, ctu_jbusr_clock_dr, 
ctu_jbusl_update_dr, ctu_jbusl_shift_dr, ctu_jbusl_mode_ctl, 
ctu_jbusl_hiz_l, ctu_jbusl_clock_dr, ctu_global_snap, ctu_fpu_so, 
ctu_efc_updatedr, ctu_efc_tck, ctu_efc_shiftdr, ctu_efc_rowaddr, 
ctu_efc_read_mode, ctu_efc_read_en, ctu_efc_fuse_bypass, 
ctu_efc_dest_sample, ctu_efc_data_in, ctu_efc_coladdr, 
ctu_efc_capturedr, ctu_debug_update_dr, ctu_debug_shift_dr, 
ctu_debug_mode_ctl, ctu_debug_hiz_l, ctu_debug_clock_dr, 
ctu_ddr_testmode_l, ctu_ddr3_update_dr, ctu_ddr3_shift_dr, 
ctu_ddr3_mode_ctl, ctu_ddr3_hiz_l, ctu_ddr3_clock_dr, 
ctu_ddr2_update_dr, ctu_ddr2_shift_dr, ctu_ddr2_mode_ctl, 
ctu_ddr2_hiz_l, ctu_ddr2_clock_dr, ctu_ddr1_update_dr, 
ctu_ddr1_shift_dr, ctu_ddr1_mode_ctl, ctu_ddr1_hiz_l, 
ctu_ddr1_clock_dr, ctu_ddr0_update_dr, ctu_ddr0_shift_dr, 
ctu_ddr0_mode_ctl, ctu_ddr0_hiz_l, ctu_ddr0_clock_dr, 
// Inputs
test_mode_pin, tck_l, start_clk_jl, spc7_ctu_sscan_out, 
spc7_ctu_mbisterr, spc7_ctu_mbistdone, spc6_ctu_sscan_out, 
spc6_ctu_mbisterr, spc6_ctu_mbistdone, spc5_ctu_sscan_out, 
spc5_ctu_mbisterr, spc5_ctu_mbistdone, spc4_ctu_sscan_out, 
spc4_ctu_mbisterr, spc4_ctu_mbistdone, spc3_ctu_sscan_out, 
spc3_ctu_mbisterr, spc3_ctu_mbistdone, spc2_ctu_sscan_out, 
spc2_ctu_mbisterr, spc2_ctu_mbistdone, spc1_ctu_sscan_out, 
spc1_ctu_mbisterr, spc1_ctu_mbistdone, spc0_ctu_sscan_out, 
spc0_ctu_mbisterr, spc0_ctu_mbistdone, sctag3_ctu_mbisterr, 
sctag3_ctu_mbistdone, sctag2_ctu_serial_scan_in, sctag2_ctu_mbisterr, 
sctag2_ctu_mbistdone, sctag1_ctu_mbisterr, sctag1_ctu_mbistdone, 
sctag0_ctu_mbisterr, sctag0_ctu_mbistdone, rt_valid, rt_read_write, 
rt_high_low, rt_data_in, rt_addr_data, pll_reset_ref_l, 
pll_bypass_pin, pads_ctu_si, pads_ctu_bsi, jtag_id, jbus_rst_l, 
jbus_clk, iob_tap_vld, iob_tap_stall, iob_tap_data, 
iob_ctu_coreavail, io_trst_l, io_tms, io_tdi, io_tck, io_pwron_rst_l, 
efc_ctu_data_out, cmp_tx_en, cmp_rx_en, cmp_rst_l, cmp_clk, 
clsp_bist_type, clsp_bist_dobist, clsp_bist_ctrl, bist_mode_pin, 
afi_tsr_tsel, afi_tsr_mode, afi_tsr_div, afi_rng_ctl, afi_pll_trst_l, 
afi_pll_div2, afi_pll_clamp_fltr, afi_pll_char_mode
);

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			afi_pll_char_mode;	// To u_jtag of ctu_dft_jtag.v
input			afi_pll_clamp_fltr;	// To u_jtag of ctu_dft_jtag.v
input [5:0]		afi_pll_div2;		// To u_jtag of ctu_dft_jtag.v
input			afi_pll_trst_l;		// To u_jtag of ctu_dft_jtag.v
input [2:0]		afi_rng_ctl;		// To u_jtag of ctu_dft_jtag.v
input [9:1]		afi_tsr_div;		// To u_jtag of ctu_dft_jtag.v
input			afi_tsr_mode;		// To u_jtag of ctu_dft_jtag.v
input [7:0]		afi_tsr_tsel;		// To u_jtag of ctu_dft_jtag.v
input			bist_mode_pin;		// To u_creg of ctu_dft_creg.v
input [5:0]		clsp_bist_ctrl;		// To u_bist of ctu_dft_bist.v
input			clsp_bist_dobist;	// To u_bist of ctu_dft_bist.v
input			clsp_bist_type;		// To u_bist of ctu_dft_bist.v
input			cmp_clk;		// To u_bist of ctu_dft_bist.v
input			cmp_rst_l;		// To u_bist of ctu_dft_bist.v
input			cmp_rx_en;		// To u_bist of ctu_dft_bist.v
input			cmp_tx_en;		// To u_bist of ctu_dft_bist.v
input			efc_ctu_data_out;	// To u_jtag of ctu_dft_jtag.v
input			io_pwron_rst_l;		// To u_creg of ctu_dft_creg.v
input			io_tck;			// To u_jtag of ctu_dft_jtag.v, ...
input			io_tdi;			// To u_jtag of ctu_dft_jtag.v
input			io_tms;			// To u_jtag of ctu_dft_jtag.v
input			io_trst_l;		// To u_jtag of ctu_dft_jtag.v
input [`IOB_CPU_WIDTH-1:0]iob_ctu_coreavail;	// To u_bist of ctu_dft_bist.v
input [7:0]		iob_tap_data;		// To u_creg of ctu_dft_creg.v
input			iob_tap_stall;		// To u_creg of ctu_dft_creg.v
input			iob_tap_vld;		// To u_creg of ctu_dft_creg.v
input			jbus_clk;		// To u_bist of ctu_dft_bist.v, ...
input			jbus_rst_l;		// To u_jtag of ctu_dft_jtag.v, ...
input [3:0]		jtag_id;		// To u_jtag of ctu_dft_jtag.v
input			pads_ctu_bsi;		// To u_jtag of ctu_dft_jtag.v
input			pads_ctu_si;		// To u_jtag of ctu_dft_jtag.v
input			pll_bypass_pin;		// To u_jtag of ctu_dft_jtag.v
input			pll_reset_ref_l;	// To u_jtag of ctu_dft_jtag.v
input			rt_addr_data;		// To u_creg of ctu_dft_creg.v
input [31:0]		rt_data_in;		// To u_creg of ctu_dft_creg.v
input			rt_high_low;		// To u_creg of ctu_dft_creg.v
input			rt_read_write;		// To u_creg of ctu_dft_creg.v
input			rt_valid;		// To u_creg of ctu_dft_creg.v
input			sctag0_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			sctag0_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			sctag1_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			sctag1_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			sctag2_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			sctag2_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			sctag2_ctu_serial_scan_in;// To u_jtag of ctu_dft_jtag.v
input			sctag3_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			sctag3_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			spc0_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			spc0_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			spc0_ctu_sscan_out;	// To u_jtag of ctu_dft_jtag.v
input			spc1_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			spc1_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			spc1_ctu_sscan_out;	// To u_jtag of ctu_dft_jtag.v
input			spc2_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			spc2_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			spc2_ctu_sscan_out;	// To u_jtag of ctu_dft_jtag.v
input			spc3_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			spc3_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			spc3_ctu_sscan_out;	// To u_jtag of ctu_dft_jtag.v
input			spc4_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			spc4_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			spc4_ctu_sscan_out;	// To u_jtag of ctu_dft_jtag.v
input			spc5_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			spc5_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			spc5_ctu_sscan_out;	// To u_jtag of ctu_dft_jtag.v
input			spc6_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			spc6_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			spc6_ctu_sscan_out;	// To u_jtag of ctu_dft_jtag.v
input			spc7_ctu_mbistdone;	// To u_bist of ctu_dft_bist.v
input			spc7_ctu_mbisterr;	// To u_bist of ctu_dft_bist.v
input			spc7_ctu_sscan_out;	// To u_jtag of ctu_dft_jtag.v
input			start_clk_jl;		// To u_creg of ctu_dft_creg.v
input			tck_l;			// To u_jtag of ctu_dft_jtag.v
input			test_mode_pin;		// To u_jtag of ctu_dft_jtag.v, ...
// End of automatics

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output			ctu_ddr0_clock_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr0_hiz_l;		// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr0_mode_ctl;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr0_shift_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr0_update_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr1_clock_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr1_hiz_l;		// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr1_mode_ctl;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr1_shift_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr1_update_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr2_clock_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr2_hiz_l;		// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr2_mode_ctl;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr2_shift_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr2_update_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr3_clock_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr3_hiz_l;		// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr3_mode_ctl;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr3_shift_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr3_update_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_ddr_testmode_l;	// From u_jtag of ctu_dft_jtag.v
output			ctu_debug_clock_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_debug_hiz_l;	// From u_jtag of ctu_dft_jtag.v
output			ctu_debug_mode_ctl;	// From u_jtag of ctu_dft_jtag.v
output			ctu_debug_shift_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_debug_update_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_efc_capturedr;	// From u_jtag of ctu_dft_jtag.v
output [4:0]		ctu_efc_coladdr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_efc_data_in;	// From u_jtag of ctu_dft_jtag.v
output			ctu_efc_dest_sample;	// From u_jtag of ctu_dft_jtag.v
output			ctu_efc_fuse_bypass;	// From u_jtag of ctu_dft_jtag.v
output			ctu_efc_read_en;	// From u_jtag of ctu_dft_jtag.v
output [2:0]		ctu_efc_read_mode;	// From u_jtag of ctu_dft_jtag.v
output [6:0]		ctu_efc_rowaddr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_efc_shiftdr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_efc_tck;		// From u_jtag of ctu_dft_jtag.v
output			ctu_efc_updatedr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_fpu_so;		// From u_jtag of ctu_dft_jtag.v
output			ctu_global_snap;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusl_clock_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusl_hiz_l;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusl_mode_ctl;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusl_shift_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusl_update_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusr_clock_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusr_hiz_l;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusr_mode_ctl;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusr_shift_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_jbusr_update_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_misc_clock_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_misc_hiz_l;		// From u_jtag of ctu_dft_jtag.v
output			ctu_misc_mode_ctl;	// From u_jtag of ctu_dft_jtag.v
output			ctu_misc_shift_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_misc_update_dr;	// From u_jtag of ctu_dft_jtag.v
output			ctu_pads_bso;		// From u_jtag of ctu_dft_jtag.v
output			ctu_pads_so;		// From u_jtag of ctu_dft_jtag.v
output			ctu_pads_sscan_update;	// From u_jtag of ctu_dft_jtag.v
output			ctu_sctag0_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_sctag1_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_sctag2_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_sctag3_mbisten;	// From u_bist of ctu_dft_bist.v
output [2:0]		ctu_sel_cpu;		// From u_jtag of ctu_dft_jtag.v
output [2:0]		ctu_sel_dram;		// From u_jtag of ctu_dft_jtag.v
output [2:0]		ctu_sel_jbus;		// From u_jtag of ctu_dft_jtag.v
output			ctu_spc0_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_spc0_sscan_se;	// From u_jtag of ctu_dft_jtag.v
output			ctu_spc0_tck;		// From u_jtag of ctu_dft_jtag.v
output			ctu_spc1_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_spc1_sscan_se;	// From u_jtag of ctu_dft_jtag.v
output			ctu_spc1_tck;		// From u_jtag of ctu_dft_jtag.v
output			ctu_spc2_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_spc2_sscan_se;	// From u_jtag of ctu_dft_jtag.v
output			ctu_spc2_tck;		// From u_jtag of ctu_dft_jtag.v
output			ctu_spc3_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_spc3_sscan_se;	// From u_jtag of ctu_dft_jtag.v
output			ctu_spc3_tck;		// From u_jtag of ctu_dft_jtag.v
output			ctu_spc4_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_spc4_sscan_se;	// From u_jtag of ctu_dft_jtag.v
output			ctu_spc4_tck;		// From u_jtag of ctu_dft_jtag.v
output			ctu_spc5_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_spc5_sscan_se;	// From u_jtag of ctu_dft_jtag.v
output			ctu_spc5_tck;		// From u_jtag of ctu_dft_jtag.v
output			ctu_spc6_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_spc6_sscan_se;	// From u_jtag of ctu_dft_jtag.v
output			ctu_spc6_tck;		// From u_jtag of ctu_dft_jtag.v
output			ctu_spc7_mbisten;	// From u_bist of ctu_dft_bist.v
output			ctu_spc7_sscan_se;	// From u_jtag of ctu_dft_jtag.v
output			ctu_spc7_tck;		// From u_jtag of ctu_dft_jtag.v
output [3:0]		ctu_spc_sscan_tid;	// From u_jtag of ctu_dft_jtag.v
output			ctu_tst_macrotest;	// From u_jtag of ctu_dft_jtag.v
output			ctu_tst_scan_disable;	// From u_jtag of ctu_dft_jtag.v
output			ctu_tst_scanmode;	// From u_jtag of ctu_dft_jtag.v
output			ctu_tst_short_chain;	// From u_jtag of ctu_dft_jtag.v
output			dft_clsp_nstep_capture_l;// From u_jtag of ctu_dft_jtag.v
output			dft_ctu_scan_disable;	// From u_jtag of ctu_dft_jtag.v
output			dft_pin_pscan_l;	// From u_jtag of ctu_dft_jtag.v
output			dft_pll_arst_l;		// From u_jtag of ctu_dft_jtag.v
output			dft_pll_clamp_fltr;	// From u_jtag of ctu_dft_jtag.v
output [5:0]		dft_pll_div2;		// From u_jtag of ctu_dft_jtag.v
output			dft_pll_testmode;	// From u_jtag of ctu_dft_jtag.v
output			dft_rng_rst_l;		// From u_jtag of ctu_dft_jtag.v
output [2:0]		dft_rng_vctrl;		// From u_jtag of ctu_dft_jtag.v
output			dft_tdo;		// From u_jtag of ctu_dft_jtag.v
output [9:1]		dft_tsr_div;		// From u_jtag of ctu_dft_jtag.v
output			dft_tsr_reset_l;	// From u_jtag of ctu_dft_jtag.v
output [7:0]		dft_tsr_tsel;		// From u_jtag of ctu_dft_jtag.v
output			dft_wake_thr;		// From u_bist of ctu_dft_bist.v
output			global_scan_bypass_en;	// From u_jtag of ctu_dft_jtag.v
output			global_shift_enable;	// From u_jtag of ctu_dft_jtag.v
output			io_tdo_en;		// From u_jtag of ctu_dft_jtag.v
output			jtag_clock_dr;		// From u_jtag of ctu_dft_jtag.v
output			jtag_clsp_force_cken_cmp;// From u_jtag of ctu_dft_jtag.v
output			jtag_clsp_force_cken_dram;// From u_jtag of ctu_dft_jtag.v
output			jtag_clsp_force_cken_jbus;// From u_jtag of ctu_dft_jtag.v
output			jtag_clsp_ignore_wrm_rst;// From u_jtag of ctu_dft_jtag.v
output			jtag_clsp_sel_tck2;	// From u_jtag of ctu_dft_jtag.v
output [5:0]		jtag_clsp_stop_id;	// From u_jtag of ctu_dft_jtag.v
output			jtag_clsp_stop_id_vld;	// From u_jtag of ctu_dft_jtag.v
output [3:0]		jtag_nstep_count;	// From u_jtag of ctu_dft_jtag.v
output [2:0]		jtag_nstep_domain;	// From u_jtag of ctu_dft_jtag.v
output			jtag_nstep_vld;		// From u_jtag of ctu_dft_jtag.v
output			pll_bypass;		// From u_jtag of ctu_dft_jtag.v
output			pscan_select;		// From u_jtag of ctu_dft_jtag.v
output			rt_ack;			// From u_creg of ctu_dft_creg.v
output [31:0]		rt_data_out;		// From u_creg of ctu_dft_creg.v
output [7:0]		tap_iob_data;		// From u_creg of ctu_dft_creg.v
output			tap_iob_stall;		// From u_creg of ctu_dft_creg.v
output			tap_iob_vld;		// From u_creg of ctu_dft_creg.v
output			testmode_l;		// From u_jtag of ctu_dft_jtag.v
// End of automatics

/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			bist_jtag_abort_done;	// From u_bist of ctu_dft_bist.v
wire [(`CTU_BIST_CNT*2)-1:0]bist_jtag_result;	// From u_bist of ctu_dft_bist.v
wire [63:0]		creg_jtag_rdrtrn_data;	// From u_creg of ctu_dft_creg.v
wire			creg_jtag_rdrtrn_vld;	// From u_creg of ctu_dft_creg.v
wire [63:0]		creg_jtag_scratch_data;	// From u_creg of ctu_dft_creg.v
wire			jtag_bist_abort;	// From u_jtag of ctu_dft_jtag.v
wire [`CTU_BIST_CNT-1:0]jtag_bist_active;	// From u_jtag of ctu_dft_jtag.v
wire			jtag_bist_parallel;	// From u_jtag of ctu_dft_jtag.v
wire			jtag_bist_serial;	// From u_jtag of ctu_dft_jtag.v
wire [39:0]		jtag_creg_addr;		// From u_jtag of ctu_dft_jtag.v
wire			jtag_creg_addr_en;	// From u_jtag of ctu_dft_jtag.v
wire [63:0]		jtag_creg_data;		// From u_jtag of ctu_dft_jtag.v
wire			jtag_creg_data_en;	// From u_jtag of ctu_dft_jtag.v
wire			jtag_creg_rd_en;	// From u_jtag of ctu_dft_jtag.v
wire			jtag_creg_rdrtrn_complete;// From u_jtag of ctu_dft_jtag.v
wire			jtag_creg_wr_en;	// From u_jtag of ctu_dft_jtag.v
// End of automatics

ctu_dft_jtag u_jtag (/*AUTOINST*/
		     // Outputs
		     .dft_tdo		(dft_tdo),
		     .io_tdo_en		(io_tdo_en),
		     .jtag_creg_addr	(jtag_creg_addr[39:0]),
		     .jtag_creg_data	(jtag_creg_data[63:0]),
		     .jtag_creg_rd_en	(jtag_creg_rd_en),
		     .jtag_creg_wr_en	(jtag_creg_wr_en),
		     .jtag_creg_addr_en	(jtag_creg_addr_en),
		     .jtag_creg_data_en	(jtag_creg_data_en),
		     .jtag_creg_rdrtrn_complete(jtag_creg_rdrtrn_complete),
		     .jtag_bist_serial	(jtag_bist_serial),
		     .jtag_bist_parallel(jtag_bist_parallel),
		     .jtag_bist_active	(jtag_bist_active[`CTU_BIST_CNT-1:0]),
		     .jtag_bist_abort	(jtag_bist_abort),
		     .dft_pll_div2	(dft_pll_div2[5:0]),
		     .dft_pll_arst_l	(dft_pll_arst_l),
		     .dft_pll_testmode	(dft_pll_testmode),
		     .dft_pll_clamp_fltr(dft_pll_clamp_fltr),
		     .jtag_clsp_stop_id_vld(jtag_clsp_stop_id_vld),
		     .jtag_clsp_stop_id	(jtag_clsp_stop_id[5:0]),
		     .jtag_nstep_vld	(jtag_nstep_vld),
		     .jtag_nstep_domain	(jtag_nstep_domain[2:0]),
		     .jtag_nstep_count	(jtag_nstep_count[3:0]),
		     .dft_clsp_nstep_capture_l(dft_clsp_nstep_capture_l),
		     .jtag_clock_dr	(jtag_clock_dr),
		     .jtag_clsp_ignore_wrm_rst(jtag_clsp_ignore_wrm_rst),
		     .jtag_clsp_sel_tck2(jtag_clsp_sel_tck2),
		     .jtag_clsp_force_cken_cmp(jtag_clsp_force_cken_cmp),
		     .jtag_clsp_force_cken_dram(jtag_clsp_force_cken_dram),
		     .jtag_clsp_force_cken_jbus(jtag_clsp_force_cken_jbus),
		     .pll_bypass	(pll_bypass),
		     .ctu_sel_cpu	(ctu_sel_cpu[2:0]),
		     .ctu_sel_dram	(ctu_sel_dram[2:0]),
		     .ctu_sel_jbus	(ctu_sel_jbus[2:0]),
		     .ctu_spc0_sscan_se	(ctu_spc0_sscan_se),
		     .ctu_spc1_sscan_se	(ctu_spc1_sscan_se),
		     .ctu_spc2_sscan_se	(ctu_spc2_sscan_se),
		     .ctu_spc3_sscan_se	(ctu_spc3_sscan_se),
		     .ctu_spc4_sscan_se	(ctu_spc4_sscan_se),
		     .ctu_spc5_sscan_se	(ctu_spc5_sscan_se),
		     .ctu_spc6_sscan_se	(ctu_spc6_sscan_se),
		     .ctu_spc7_sscan_se	(ctu_spc7_sscan_se),
		     .ctu_spc0_tck	(ctu_spc0_tck),
		     .ctu_spc1_tck	(ctu_spc1_tck),
		     .ctu_spc2_tck	(ctu_spc2_tck),
		     .ctu_spc3_tck	(ctu_spc3_tck),
		     .ctu_spc4_tck	(ctu_spc4_tck),
		     .ctu_spc5_tck	(ctu_spc5_tck),
		     .ctu_spc6_tck	(ctu_spc6_tck),
		     .ctu_spc7_tck	(ctu_spc7_tck),
		     .ctu_spc_sscan_tid	(ctu_spc_sscan_tid[3:0]),
		     .ctu_pads_sscan_update(ctu_pads_sscan_update),
		     .ctu_global_snap	(ctu_global_snap),
		     .ctu_ddr0_mode_ctl	(ctu_ddr0_mode_ctl),
		     .ctu_ddr0_hiz_l	(ctu_ddr0_hiz_l),
		     .ctu_ddr0_update_dr(ctu_ddr0_update_dr),
		     .ctu_ddr0_clock_dr	(ctu_ddr0_clock_dr),
		     .ctu_ddr0_shift_dr	(ctu_ddr0_shift_dr),
		     .ctu_ddr1_mode_ctl	(ctu_ddr1_mode_ctl),
		     .ctu_ddr1_hiz_l	(ctu_ddr1_hiz_l),
		     .ctu_ddr1_update_dr(ctu_ddr1_update_dr),
		     .ctu_ddr1_clock_dr	(ctu_ddr1_clock_dr),
		     .ctu_ddr1_shift_dr	(ctu_ddr1_shift_dr),
		     .ctu_ddr2_mode_ctl	(ctu_ddr2_mode_ctl),
		     .ctu_ddr2_hiz_l	(ctu_ddr2_hiz_l),
		     .ctu_ddr2_update_dr(ctu_ddr2_update_dr),
		     .ctu_ddr2_clock_dr	(ctu_ddr2_clock_dr),
		     .ctu_ddr2_shift_dr	(ctu_ddr2_shift_dr),
		     .ctu_ddr3_mode_ctl	(ctu_ddr3_mode_ctl),
		     .ctu_ddr3_hiz_l	(ctu_ddr3_hiz_l),
		     .ctu_ddr3_update_dr(ctu_ddr3_update_dr),
		     .ctu_ddr3_clock_dr	(ctu_ddr3_clock_dr),
		     .ctu_ddr3_shift_dr	(ctu_ddr3_shift_dr),
		     .ctu_jbusl_mode_ctl(ctu_jbusl_mode_ctl),
		     .ctu_jbusl_hiz_l	(ctu_jbusl_hiz_l),
		     .ctu_jbusl_update_dr(ctu_jbusl_update_dr),
		     .ctu_jbusl_clock_dr(ctu_jbusl_clock_dr),
		     .ctu_jbusl_shift_dr(ctu_jbusl_shift_dr),
		     .ctu_jbusr_mode_ctl(ctu_jbusr_mode_ctl),
		     .ctu_jbusr_hiz_l	(ctu_jbusr_hiz_l),
		     .ctu_jbusr_update_dr(ctu_jbusr_update_dr),
		     .ctu_jbusr_clock_dr(ctu_jbusr_clock_dr),
		     .ctu_jbusr_shift_dr(ctu_jbusr_shift_dr),
		     .ctu_debug_mode_ctl(ctu_debug_mode_ctl),
		     .ctu_debug_hiz_l	(ctu_debug_hiz_l),
		     .ctu_debug_update_dr(ctu_debug_update_dr),
		     .ctu_debug_clock_dr(ctu_debug_clock_dr),
		     .ctu_debug_shift_dr(ctu_debug_shift_dr),
		     .ctu_misc_mode_ctl	(ctu_misc_mode_ctl),
		     .ctu_misc_hiz_l	(ctu_misc_hiz_l),
		     .ctu_misc_update_dr(ctu_misc_update_dr),
		     .ctu_misc_clock_dr	(ctu_misc_clock_dr),
		     .ctu_misc_shift_dr	(ctu_misc_shift_dr),
		     .ctu_pads_bso	(ctu_pads_bso),
		     .global_shift_enable(global_shift_enable),
		     .global_scan_bypass_en(global_scan_bypass_en),
		     .dft_ctu_scan_disable(dft_ctu_scan_disable),
		     .dft_pin_pscan_l	(dft_pin_pscan_l),
		     .ctu_pads_so	(ctu_pads_so),
		     .ctu_fpu_so	(ctu_fpu_so),
		     .pscan_select	(pscan_select),
		     .ctu_ddr_testmode_l(ctu_ddr_testmode_l),
		     .ctu_tst_scanmode	(ctu_tst_scanmode),
		     .ctu_tst_macrotest	(ctu_tst_macrotest),
		     .ctu_tst_short_chain(ctu_tst_short_chain),
		     .ctu_tst_scan_disable(ctu_tst_scan_disable),
		     .ctu_efc_data_in	(ctu_efc_data_in),
		     .ctu_efc_updatedr	(ctu_efc_updatedr),
		     .ctu_efc_shiftdr	(ctu_efc_shiftdr),
		     .ctu_efc_capturedr	(ctu_efc_capturedr),
		     .ctu_efc_tck	(ctu_efc_tck),
		     .ctu_efc_rowaddr	(ctu_efc_rowaddr[6:0]),
		     .ctu_efc_coladdr	(ctu_efc_coladdr[4:0]),
		     .ctu_efc_read_en	(ctu_efc_read_en),
		     .ctu_efc_read_mode	(ctu_efc_read_mode[2:0]),
		     .ctu_efc_fuse_bypass(ctu_efc_fuse_bypass),
		     .ctu_efc_dest_sample(ctu_efc_dest_sample),
		     .dft_rng_vctrl	(dft_rng_vctrl[2:0]),
		     .dft_rng_rst_l	(dft_rng_rst_l),
		     .dft_tsr_div	(dft_tsr_div[9:1]),
		     .dft_tsr_tsel	(dft_tsr_tsel[7:0]),
		     .dft_tsr_reset_l	(dft_tsr_reset_l),
		     .testmode_l	(testmode_l),
		     // Inputs
		     .jbus_rst_l	(jbus_rst_l),
		     .io_tdi		(io_tdi),
		     .io_tms		(io_tms),
		     .io_trst_l		(io_trst_l),
		     .io_tck		(io_tck),
		     .tck_l		(tck_l),
		     .jtag_id		(jtag_id[3:0]),
		     .test_mode_pin	(test_mode_pin),
		     .afi_rng_ctl	(afi_rng_ctl[2:0]),
		     .afi_tsr_div	(afi_tsr_div[9:1]),
		     .afi_tsr_mode	(afi_tsr_mode),
		     .afi_pll_char_mode	(afi_pll_char_mode),
		     .afi_pll_div2	(afi_pll_div2[5:0]),
		     .afi_pll_trst_l	(afi_pll_trst_l),
		     .afi_tsr_tsel	(afi_tsr_tsel[7:0]),
		     .afi_pll_clamp_fltr(afi_pll_clamp_fltr),
		     .creg_jtag_scratch_data(creg_jtag_scratch_data[63:0]),
		     .creg_jtag_rdrtrn_data(creg_jtag_rdrtrn_data[63:0]),
		     .creg_jtag_rdrtrn_vld(creg_jtag_rdrtrn_vld),
		     .bist_jtag_result	(bist_jtag_result[(`CTU_BIST_CNT*2)-1:0]),
		     .bist_jtag_abort_done(bist_jtag_abort_done),
		     .pll_bypass_pin	(pll_bypass_pin),
		     .pll_reset_ref_l	(pll_reset_ref_l),
		     .spc0_ctu_sscan_out(spc0_ctu_sscan_out),
		     .spc1_ctu_sscan_out(spc1_ctu_sscan_out),
		     .spc2_ctu_sscan_out(spc2_ctu_sscan_out),
		     .spc3_ctu_sscan_out(spc3_ctu_sscan_out),
		     .spc4_ctu_sscan_out(spc4_ctu_sscan_out),
		     .spc5_ctu_sscan_out(spc5_ctu_sscan_out),
		     .spc6_ctu_sscan_out(spc6_ctu_sscan_out),
		     .spc7_ctu_sscan_out(spc7_ctu_sscan_out),
		     .pads_ctu_bsi	(pads_ctu_bsi),
		     .pads_ctu_si	(pads_ctu_si),
		     .sctag2_ctu_serial_scan_in(sctag2_ctu_serial_scan_in),
		     .efc_ctu_data_out	(efc_ctu_data_out));

ctu_dft_bist u_bist (/*AUTOINST*/
		     // Outputs
		     .dft_wake_thr	(dft_wake_thr),
		     .bist_jtag_result	(bist_jtag_result[(`CTU_BIST_CNT*2)-1:0]),
		     .bist_jtag_abort_done(bist_jtag_abort_done),
		     .ctu_sctag0_mbisten(ctu_sctag0_mbisten),
		     .ctu_sctag1_mbisten(ctu_sctag1_mbisten),
		     .ctu_sctag2_mbisten(ctu_sctag2_mbisten),
		     .ctu_sctag3_mbisten(ctu_sctag3_mbisten),
		     .ctu_spc7_mbisten	(ctu_spc7_mbisten),
		     .ctu_spc6_mbisten	(ctu_spc6_mbisten),
		     .ctu_spc5_mbisten	(ctu_spc5_mbisten),
		     .ctu_spc4_mbisten	(ctu_spc4_mbisten),
		     .ctu_spc3_mbisten	(ctu_spc3_mbisten),
		     .ctu_spc2_mbisten	(ctu_spc2_mbisten),
		     .ctu_spc1_mbisten	(ctu_spc1_mbisten),
		     .ctu_spc0_mbisten	(ctu_spc0_mbisten),
		     // Inputs
		     .cmp_clk		(cmp_clk),
		     .cmp_rst_l		(cmp_rst_l),
		     .cmp_tx_en		(cmp_tx_en),
		     .cmp_rx_en		(cmp_rx_en),
		     .jbus_clk		(jbus_clk),
		     .jbus_rst_l	(jbus_rst_l),
		     .io_tck		(io_tck),
		     .iob_ctu_coreavail	(iob_ctu_coreavail[`IOB_CPU_WIDTH-1:0]),
		     .clsp_bist_dobist	(clsp_bist_dobist),
		     .clsp_bist_type	(clsp_bist_type),
		     .clsp_bist_ctrl	(clsp_bist_ctrl[5:0]),
		     .jtag_bist_serial	(jtag_bist_serial),
		     .jtag_bist_parallel(jtag_bist_parallel),
		     .jtag_bist_active	(jtag_bist_active[`CTU_BIST_CNT-1:0]),
		     .jtag_bist_abort	(jtag_bist_abort),
		     .sctag0_ctu_mbistdone(sctag0_ctu_mbistdone),
		     .sctag1_ctu_mbistdone(sctag1_ctu_mbistdone),
		     .sctag2_ctu_mbistdone(sctag2_ctu_mbistdone),
		     .sctag3_ctu_mbistdone(sctag3_ctu_mbistdone),
		     .spc7_ctu_mbistdone(spc7_ctu_mbistdone),
		     .spc6_ctu_mbistdone(spc6_ctu_mbistdone),
		     .spc5_ctu_mbistdone(spc5_ctu_mbistdone),
		     .spc4_ctu_mbistdone(spc4_ctu_mbistdone),
		     .spc3_ctu_mbistdone(spc3_ctu_mbistdone),
		     .spc2_ctu_mbistdone(spc2_ctu_mbistdone),
		     .spc1_ctu_mbistdone(spc1_ctu_mbistdone),
		     .spc0_ctu_mbistdone(spc0_ctu_mbistdone),
		     .sctag0_ctu_mbisterr(sctag0_ctu_mbisterr),
		     .sctag1_ctu_mbisterr(sctag1_ctu_mbisterr),
		     .sctag2_ctu_mbisterr(sctag2_ctu_mbisterr),
		     .sctag3_ctu_mbisterr(sctag3_ctu_mbisterr),
		     .spc7_ctu_mbisterr	(spc7_ctu_mbisterr),
		     .spc6_ctu_mbisterr	(spc6_ctu_mbisterr),
		     .spc5_ctu_mbisterr	(spc5_ctu_mbisterr),
		     .spc4_ctu_mbisterr	(spc4_ctu_mbisterr),
		     .spc3_ctu_mbisterr	(spc3_ctu_mbisterr),
		     .spc2_ctu_mbisterr	(spc2_ctu_mbisterr),
		     .spc1_ctu_mbisterr	(spc1_ctu_mbisterr),
		     .spc0_ctu_mbisterr	(spc0_ctu_mbisterr));

ctu_dft_creg u_creg (/*AUTOINST*/
		     // Outputs
		     .creg_jtag_scratch_data(creg_jtag_scratch_data[63:0]),
		     .creg_jtag_rdrtrn_data(creg_jtag_rdrtrn_data[63:0]),
		     .creg_jtag_rdrtrn_vld(creg_jtag_rdrtrn_vld),
		     .tap_iob_stall	(tap_iob_stall),
		     .tap_iob_vld	(tap_iob_vld),
		     .tap_iob_data	(tap_iob_data[7:0]),
		     .rt_ack		(rt_ack),
		     .rt_data_out	(rt_data_out[31:0]),
		     // Inputs
		     .io_tck		(io_tck),
		     .jbus_clk		(jbus_clk),
		     .jbus_rst_l	(jbus_rst_l),
		     .io_pwron_rst_l	(io_pwron_rst_l),
		     .test_mode_pin	(test_mode_pin),
		     .bist_mode_pin	(bist_mode_pin),
		     .start_clk_jl	(start_clk_jl),
		     .jtag_creg_addr	(jtag_creg_addr[39:0]),
		     .jtag_creg_data	(jtag_creg_data[63:0]),
		     .jtag_creg_rd_en	(jtag_creg_rd_en),
		     .jtag_creg_wr_en	(jtag_creg_wr_en),
		     .jtag_creg_addr_en	(jtag_creg_addr_en),
		     .jtag_creg_data_en	(jtag_creg_data_en),
		     .jtag_creg_rdrtrn_complete(jtag_creg_rdrtrn_complete),
		     .iob_tap_vld	(iob_tap_vld),
		     .iob_tap_data	(iob_tap_data[7:0]),
		     .iob_tap_stall	(iob_tap_stall),
		     .rt_valid		(rt_valid),
		     .rt_addr_data	(rt_addr_data),
		     .rt_read_write	(rt_read_write),
		     .rt_high_low	(rt_high_low),
		     .rt_data_in	(rt_data_in[31:0]),
		     .bist_jtag_result	(bist_jtag_result[(`CTU_BIST_CNT*2)-1:0]));

endmodule

// Local Variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// End:

