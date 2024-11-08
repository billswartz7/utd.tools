// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp_clkgn.v
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
//    Unit Name: ctu_clsp_clkgn
//
//-----------------------------------------------------------------------------

`include "sys.h"
`include "iop.h"
`include "ctu.h"

module ctu_clsp_clkgn(/*AUTOARG*/
// Outputs
jbus_mult_rst_l, jbus_gclk_dup_out, dram_gclk_out, 
de_grst_jsync_edge, de_grst_dsync_edge_dl, de_dbginit_jsync_edge, 
de_dbginit_dsync_edge_dl, ctu_jbus_tx_sync_cl, ctu_jbus_rx_sync_cl, 
ctu_jbi_ssiclk, ctu_dram_tx_sync_cl, ctu_dram_rx_sync_cl, coin_edge, 
cmp_grst_cl_l, cmp_gclk_out, cmp_dbginit_cl_l, a_grst_dl, 
a_dbginit_dl, jbus_gclk_out, shadreg_div_dmult, shadreg_div_jmult, 
// Inputs
update_shadow_cl, testmode_l, stretch_cnt_vec, start_clk_early_jl, 
start_clk_cl, start_2clk_early_jl, ssiclk_enable, se, reg_jdiv_vec, 
reg_jdiv_0, reg_div_jmult, reg_div_dmult, reg_div_cmult, 
reg_ddiv_vec, reg_ddiv_0, reg_cdiv_vec, reg_cdiv_0, 
pll_reset_ref_dly1_l, pll_raw_clk_out, pll_clk_out_pre_l, 
pll_clk_out_pre, pll_clk_out_l, pll_clk_out, jtag_nstep_vld, 
jtag_nstep_domain, jtag_nstep_count, jtag_clsp_sel_tck2, 
jtag_clsp_sel_jbus, jtag_clsp_sel_dram, jtag_clsp_sel_cpu, 
jtag_clsp_force_cken_jbus, jtag_clsp_force_cken_dram, 
jtag_clsp_force_cken_cmp, jtag_clock_dr, jsync_reg_tx2, 
jsync_reg_tx1, jsync_reg_tx0, jsync_reg_rx2, jsync_reg_rx1, 
jsync_reg_rx0, jsync_reg_period, jsync_reg_init, jbus_tx_sync, 
jbus_clk, io_tck2, io_pwron_rst_l, dsync_reg_tx2, dsync_reg_tx1, 
dsync_reg_tx0, dsync_reg_rx2, dsync_reg_rx1, dsync_reg_rx0, 
dsync_reg_period, dsync_reg_init, dram_a_grst_cl, 
dft_clsp_nstep_capture_l, de_grst_cl, de_dbginit_cl, 
ctu_dram_tx_sync_early, cmp_clk, clk_stretch_trig, 
clk_stretch_cnt_val_odd, clk_stretch_cnt_val_6, a_grst_cl, 
a_dbginit_cl
);

   output jbus_gclk_out;		// From u_ctu_clsp_clkgn_mux of bw_ctu_clk_sync_mux.v
   
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		a_dbginit_cl;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		a_grst_cl;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		clk_stretch_cnt_val_6;	// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   input		clk_stretch_cnt_val_odd;// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   input		clk_stretch_trig;	// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   input		cmp_clk;		// To u_ctu_clsp_clkgn_jsyncp of ctu_clsp_clkgn_syncp.v, ...
   input		ctu_dram_tx_sync_early;	// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		de_dbginit_cl;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		de_grst_cl;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		dft_clsp_nstep_capture_l;// To u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v, ...
   input		dram_a_grst_cl;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		dsync_reg_init;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		dsync_reg_period;	// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [1:0]		dsync_reg_rx0;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [1:0]		dsync_reg_rx1;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [1:0]		dsync_reg_rx2;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		dsync_reg_tx0;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		dsync_reg_tx1;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		dsync_reg_tx2;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		io_pwron_rst_l;		// To u_ctu_clsp_clkgn_ssiclk of ctu_clsp_clkgn_ssiclk.v, ...
   input		io_tck2;		// To u_ctu_clsp_clkgn_clksw_cmp_tck_mux of ctu_mux21.v
   input		jbus_clk;		// To u_ctu_clsp_clkgn_ssiclk of ctu_clsp_clkgn_ssiclk.v
   input		jbus_tx_sync;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		jsync_reg_init;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		jsync_reg_period;	// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [1:0]		jsync_reg_rx0;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [1:0]		jsync_reg_rx1;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [1:0]		jsync_reg_rx2;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		jsync_reg_tx0;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		jsync_reg_tx1;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [4:0]		jsync_reg_tx2;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		jtag_clock_dr;		// To u_ctu_clsp_clkgn_clksw_cmp_tck_mux of ctu_mux21.v, ...
   input		jtag_clsp_force_cken_cmp;// To u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v
   input		jtag_clsp_force_cken_dram;// To u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v
   input		jtag_clsp_force_cken_jbus;// To u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v
   input [2:0]		jtag_clsp_sel_cpu;	// To u_ctu_clsp_clkgn_clksw of ctu_clsp_clkgn_clksw.v
   input [2:0]		jtag_clsp_sel_dram;	// To u_ctu_clsp_clkgn_clksw of ctu_clsp_clkgn_clksw.v
   input [2:0]		jtag_clsp_sel_jbus;	// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v, ...
   input		jtag_clsp_sel_tck2;	// To u_ctu_clsp_clkgn_clksw_cmp_tck_mux of ctu_mux21.v, ...
   input [3:0]		jtag_nstep_count;	// To u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v
   input [2:0]		jtag_nstep_domain;	// To u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v
   input		jtag_nstep_vld;		// To u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v
   input		pll_clk_out;		// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   input		pll_clk_out_l;		// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   input		pll_clk_out_pre;	// To u_ctu_clsp_clkgn_mux of bw_ctu_clk_sync_mux.v
   input		pll_clk_out_pre_l;	// To u_ctu_clsp_clkgn_mux of bw_ctu_clk_sync_mux.v
   input		pll_raw_clk_out;	// To u_ctu_clsp_clkgn_clksw_jbus_tck_mux of ctu_mux21.v, ...
   input		pll_reset_ref_dly1_l;	// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   input		reg_cdiv_0;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [14:0]		reg_cdiv_vec;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		reg_ddiv_0;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [14:0]		reg_ddiv_vec;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [13:0]		reg_div_cmult;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [9:0]		reg_div_dmult;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [9:0]		reg_div_jmult;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		reg_jdiv_0;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input [14:0]		reg_jdiv_vec;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		se;			// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v, ...
   input		ssiclk_enable;		// To u_ctu_clsp_clkgn_ssiclk of ctu_clsp_clkgn_ssiclk.v
   input		start_2clk_early_jl;	// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   input		start_clk_cl;		// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   input		start_clk_early_jl;	// To u_ctu_clsp_clkgn_jsyncp of ctu_clsp_clkgn_syncp.v, ...
   input [14:0]		stretch_cnt_vec;	// To u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   input		testmode_l;		// To u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v, ...
   input		update_shadow_cl;	// To u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   // End of automatics

   output [9:0]		shadreg_div_dmult;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output [9:0]		shadreg_div_jmult;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		a_dbginit_dl;		// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output		a_grst_dl;		// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output		cmp_dbginit_cl_l;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output		cmp_gclk_out;		// From u_ctu_clsp_clkgn_mux of bw_ctu_clk_sync_mux.v
   output		cmp_grst_cl_l;		// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output		coin_edge;		// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output		ctu_dram_rx_sync_cl;	// From u_ctu_clsp_clkgn_dsyncp of ctu_clsp_clkgn_syncp.v
   output		ctu_dram_tx_sync_cl;	// From u_ctu_clsp_clkgn_dsyncp of ctu_clsp_clkgn_syncp.v
   output		ctu_jbi_ssiclk;		// From u_ctu_clsp_clkgn_ssiclk of ctu_clsp_clkgn_ssiclk.v
   output		ctu_jbus_rx_sync_cl;	// From u_ctu_clsp_clkgn_jsyncp of ctu_clsp_clkgn_syncp.v
   output		ctu_jbus_tx_sync_cl;	// From u_ctu_clsp_clkgn_jsyncp of ctu_clsp_clkgn_syncp.v
   output		de_dbginit_dsync_edge_dl;// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output		de_dbginit_jsync_edge;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output		de_grst_dsync_edge_dl;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output		de_grst_jsync_edge;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   output		dram_gclk_out;		// From u_ctu_clsp_clkgn_mux of bw_ctu_clk_sync_mux.v
   output		jbus_gclk_dup_out;	// From u_ctu_clsp_clkgn_mux of bw_ctu_clk_sync_mux.v
   output		jbus_mult_rst_l;	// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   // End of automatics
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			cmp_clk_sel;		// From u_ctu_clsp_clkgn_clksw of ctu_clsp_clkgn_clksw.v
   wire			cmp_div0;		// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			cmp_div1;		// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			cmp_div_bypass;		// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			cmp_gclk_byp;		// From u_ctu_clsp_clkgn_mux_cmp0_gated of bw_u1_inv_5x.v
   wire			cmp_gclk_byp_int;	// From u_ctu_clsp_clkgn_mux_cmp2_gated of bw_clk_cl_ctu_2xcmp.v
   wire			cmp_gclk_byp_inv;	// From u_ctu_clsp_clkgn_mux of bw_ctu_clk_sync_mux.v
   wire			cmp_gclk_byp_pre;	// From u_ctu_clsp_clkgn_mux_cmp1_gated of bw_u1_inv_5x.v
   wire			cmp_nstep_sel;		// From u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v
   wire			cmp_tst_clk;		// From u_ctu_clsp_clkgn_clksw of ctu_clsp_clkgn_clksw.v
   wire			coin_cnt_en;		// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire			coin_cnt_ld;		// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire			dram_clk_sel;		// From u_ctu_clsp_clkgn_clksw of ctu_clsp_clkgn_clksw.v
   wire			dram_div0;		// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			dram_div1;		// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			dram_gclk_byp;		// From u_ctu_clsp_clkgn_mux_dram0_gated of bw_u1_inv_5x.v
   wire			dram_gclk_byp_int;	// From u_ctu_clsp_clkgn_mux_dram2_gated of bw_u1_ckbuf_30x.v
   wire			dram_gclk_byp_inv;	// From u_ctu_clsp_clkgn_mux of bw_ctu_clk_sync_mux.v
   wire			dram_gclk_byp_pre;	// From u_ctu_clsp_clkgn_mux_dram1_gated of bw_u1_inv_5x.v
   wire			dram_nstep_sel;		// From u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v
   wire			dram_tst_clk;		// From u_ctu_clsp_clkgn_clksw of ctu_clsp_clkgn_clksw.v
   wire [4:0]		dsync_shadreg_init;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [4:0]		dsync_shadreg_period;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [1:0]		dsync_shadreg_rx0;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [1:0]		dsync_shadreg_rx1;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [1:0]		dsync_shadreg_rx2;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [4:0]		dsync_shadreg_tx0;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [4:0]		dsync_shadreg_tx1;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [4:0]		dsync_shadreg_tx2;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire			jbus_alt_bypsel_l;	// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			jbus_clk_sel;		// From u_ctu_clsp_clkgn_clksw of ctu_clsp_clkgn_clksw.v
   wire			jbus_div0;		// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			jbus_div1;		// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			jbus_div_bypass;	// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			jbus_dup_div0;		// From u_ctu_clsp_clkgn_fstlog of ctu_clsp_clkgn_fstlog.v
   wire			jbus_gclk_byp;		// From u_ctu_clsp_clkgn_mux_jbus0_gated of bw_u1_inv_5x.v
   wire			jbus_gclk_byp_int;	// From u_ctu_clsp_clkgn_mux_jbus2_gated of bw_u1_ckbuf_30x.v
   wire			jbus_gclk_byp_inv;	// From u_ctu_clsp_clkgn_mux of bw_ctu_clk_sync_mux.v
   wire			jbus_gclk_byp_pre;	// From u_ctu_clsp_clkgn_mux_jbus1_gated of bw_u1_inv_5x.v
   wire			jbus_nstep_sel;		// From u_ctu_clsp_clkgn_nstep of ctu_clsp_clkgn_nstep.v
   wire			jbus_tst_clk;		// From u_ctu_clsp_clkgn_clksw of ctu_clsp_clkgn_clksw.v
   wire [4:0]		jsync_shadreg_init;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [4:0]		jsync_shadreg_period;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [1:0]		jsync_shadreg_rx0;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [1:0]		jsync_shadreg_rx1;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [1:0]		jsync_shadreg_rx2;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [4:0]		jsync_shadreg_tx0;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [4:0]		jsync_shadreg_tx1;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [4:0]		jsync_shadreg_tx2;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire			jtag_clock_dr_cmp;	// From u_ctu_clsp_clkgn_clksw_cmp_tck_mux of ctu_mux21.v
   wire			jtag_clock_dr_dram;	// From u_ctu_clsp_clkgn_clksw_dram_tck_mux of ctu_mux21.v
   wire			jtag_clock_dr_jbus;	// From u_ctu_clsp_clkgn_clksw_jbus_tck_mux of ctu_mux21.v
   wire			shadreg_cdiv_0;		// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [14:0]		shadreg_cdiv_vec;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire			shadreg_ddiv_0;		// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [14:0]		shadreg_ddiv_vec;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [13:0]		shadreg_div_cmult;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire			shadreg_jdiv_0;		// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   wire [14:0]		shadreg_jdiv_vec;	// From u_ctu_clsp_clkgn_shadreg of ctu_clsp_clkgn_shadreg.v
   // End of automatics


  /* ctu_clsp_clkgn_fstlog AUTO_TEMPLATE (
						     .clsp_fstlog_corepll_j_0(shadreg_jdiv_0),
						     .clsp_fstlog_corepll_d_0(shadreg_ddiv_0),
						     .clsp_fstlog_corepll_c_0(shadreg_cdiv_0),
						     .cdiv_vec(shadreg_cdiv_vec[]),
						     .ddiv_vec(shadreg_ddiv_vec[]),
						     .jdiv_vec(shadreg_jdiv_vec[]),
						     .pll_reset_ref_l(pll_reset_ref_dly1_l),
						     .start_clk_jl(start_2clk_early_jl),
                                                     .io_pwron_rst_l(io_pwron_rst_l),
                                                     .si(1'b0),
                                                     .so(),
						     .bypclksel(jtag_clsp_sel_jbus[2]),
      );
  */
     ctu_clsp_clkgn_fstlog  u_ctu_clsp_clkgn_fstlog (/*AUTOINST*/
						     // Outputs
						     .cmp_div0(cmp_div0),
						     .cmp_div1(cmp_div1),
						     .dram_div0(dram_div0),
						     .dram_div1(dram_div1),
						     .jbus_div0(jbus_div0),
						     .jbus_div1(jbus_div1),
						     .jbus_dup_div0(jbus_dup_div0),
						     .cmp_div_bypass(cmp_div_bypass),
						     .jbus_div_bypass(jbus_div_bypass),
						     .so(),	 // Templated
						     .jbus_mult_rst_l(jbus_mult_rst_l),
						     .jbus_alt_bypsel_l(jbus_alt_bypsel_l),
						     // Inputs
						     .clsp_fstlog_corepll_j_0(shadreg_jdiv_0), // Templated
						     .clsp_fstlog_corepll_d_0(shadreg_ddiv_0), // Templated
						     .clsp_fstlog_corepll_c_0(shadreg_cdiv_0), // Templated
						     .cdiv_vec(shadreg_cdiv_vec[14:0]), // Templated
						     .ddiv_vec(shadreg_ddiv_vec[14:0]), // Templated
						     .jdiv_vec(shadreg_jdiv_vec[14:0]), // Templated
						     .stretch_cnt_vec(stretch_cnt_vec[14:0]),
						     .bypclksel(jtag_clsp_sel_jbus[2]), // Templated
						     .se(se),
						     .si(1'b0),	 // Templated
						     .pll_reset_ref_l(pll_reset_ref_dly1_l), // Templated
						     .start_clk_jl(start_2clk_early_jl), // Templated
						     .clk_stretch_cnt_val_6(clk_stretch_cnt_val_6),
						     .clk_stretch_cnt_val_odd(clk_stretch_cnt_val_odd),
						     .clk_stretch_trig(clk_stretch_trig),
						     .pll_clk_out(pll_clk_out),
						     .pll_clk_out_l(pll_clk_out_l));

  /* ctu_clsp_clkgn_syncp AUTO_TEMPLATE (
						 .tx_sync(ctu_jbus_tx_sync_cl),
						 .rx_sync(ctu_jbus_rx_sync_cl),
						 .tx_cnt_zeroc(jbus_cnt_zero),
						 .clsp_sync_tx0(jsync_shadreg_tx0[4:0]),
						 .clsp_sync_tx1(jsync_shadreg_tx1[4:0]),
						 .clsp_sync_tx2(jsync_shadreg_tx2[4:0]),
						 .clsp_sync_rx0(jsync_shadreg_rx0[1:0]),
						 .clsp_sync_rx1(jsync_shadreg_rx1[1:0]),
						 .clsp_sync_rx2(jsync_shadreg_rx2[1:0]),
						 .clsp_sync_init(jsync_shadreg_init[4:0]),
						 .clsp_sync_period(jsync_shadreg_period[4:0]),
						 .coin_cnt_ld(coin_cnt_ld),
						 .start_clk_jl(start_clk_early_jl),
      );
  */
     ctu_clsp_clkgn_syncp u_ctu_clsp_clkgn_jsyncp(/*AUTOINST*/
						  // Outputs
						  .tx_sync(ctu_jbus_tx_sync_cl), // Templated
						  .rx_sync(ctu_jbus_rx_sync_cl), // Templated
						  // Inputs
						  .cmp_clk(cmp_clk),
						  .start_clk_early_jl(start_clk_early_jl),
						  .coin_cnt_en(coin_cnt_en),
						  .coin_cnt_ld(coin_cnt_ld), // Templated
						  .clsp_sync_tx0(jsync_shadreg_tx0[4:0]), // Templated
						  .clsp_sync_tx1(jsync_shadreg_tx1[4:0]), // Templated
						  .clsp_sync_tx2(jsync_shadreg_tx2[4:0]), // Templated
						  .clsp_sync_rx0(jsync_shadreg_rx0[1:0]), // Templated
						  .clsp_sync_rx1(jsync_shadreg_rx1[1:0]), // Templated
						  .clsp_sync_rx2(jsync_shadreg_rx2[1:0]), // Templated
						  .clsp_sync_init(jsync_shadreg_init[4:0]), // Templated
						  .clsp_sync_period(jsync_shadreg_period[4:0])); // Templated

  /* ctu_clsp_clkgn_syncp AUTO_TEMPLATE (
						 .tx_sync(ctu_dram_tx_sync_cl),
						 .rx_sync(ctu_dram_rx_sync_cl),
						 .tx_cnt_zeroc(dram_cnt_zero),
						 // Inputs
						 .clsp_sync_tx0(dsync_shadreg_tx0[4:0]),
						 .clsp_sync_tx1(dsync_shadreg_tx1[4:0]),
						 .clsp_sync_tx2(dsync_shadreg_tx2[4:0]),
						 .clsp_sync_rx0(dsync_shadreg_rx0[1:0]),
						 .clsp_sync_rx1(dsync_shadreg_rx1[1:0]),
						 .clsp_sync_rx2(dsync_shadreg_rx2[1:0]),
						 .clsp_sync_period(dsync_shadreg_period[4:0]),
						 .clsp_sync_init(dsync_shadreg_init[4:0]),
						 .coin_cnt_ld(coin_cnt_ld),
      );
  */

     ctu_clsp_clkgn_syncp u_ctu_clsp_clkgn_dsyncp(/*AUTOINST*/
						  // Outputs
						  .tx_sync(ctu_dram_tx_sync_cl), // Templated
						  .rx_sync(ctu_dram_rx_sync_cl), // Templated
						  // Inputs
						  .cmp_clk(cmp_clk),
						  .start_clk_early_jl(start_clk_early_jl),
						  .coin_cnt_en(coin_cnt_en),
						  .coin_cnt_ld(coin_cnt_ld), // Templated
						  .clsp_sync_tx0(dsync_shadreg_tx0[4:0]), // Templated
						  .clsp_sync_tx1(dsync_shadreg_tx1[4:0]), // Templated
						  .clsp_sync_tx2(dsync_shadreg_tx2[4:0]), // Templated
						  .clsp_sync_rx0(dsync_shadreg_rx0[1:0]), // Templated
						  .clsp_sync_rx1(dsync_shadreg_rx1[1:0]), // Templated
						  .clsp_sync_rx2(dsync_shadreg_rx2[1:0]), // Templated
						  .clsp_sync_init(dsync_shadreg_init[4:0]), // Templated
						  .clsp_sync_period(dsync_shadreg_period[4:0])); // Templated

  /* ctu_clsp_clkgn_ssiclk AUTO_TEMPLATE (
    );
  */
     ctu_clsp_clkgn_ssiclk u_ctu_clsp_clkgn_ssiclk (/*AUTOINST*/
						    // Outputs
						    .ctu_jbi_ssiclk(ctu_jbi_ssiclk),
						    // Inputs
						    .io_pwron_rst_l(io_pwron_rst_l),
						    .jbus_clk(jbus_clk),
						    .ssiclk_enable(ssiclk_enable));

  


/* ctu_mux21 AUTO_TEMPLATE (
   .s( jtag_clsp_sel_tck2 ),
   .d1 ( io_tck2),
   .d0 ( jtag_clock_dr),
   .z ( jtag_clock_dr_cmp),
  );
*/

    ctu_mux21 u_ctu_clsp_clkgn_clksw_cmp_tck_mux (/*AUTOINST*/
						  // Outputs
						  .z( jtag_clock_dr_cmp), // Templated
						  // Inputs
						  .d0( jtag_clock_dr), // Templated
						  .d1( io_tck2), // Templated
						  .s( jtag_clsp_sel_tck2 )); // Templated


/* ctu_mux21 AUTO_TEMPLATE (
   .s( jtag_clsp_sel_tck2 ),
   .d1 ( pll_raw_clk_out),
   .d0 ( jtag_clock_dr),
   .z ( jtag_clock_dr_jbus),
  );
*/
    ctu_mux21 u_ctu_clsp_clkgn_clksw_jbus_tck_mux (/*AUTOINST*/
						   // Outputs
						   .z( jtag_clock_dr_jbus), // Templated
						   // Inputs
						   .d0( jtag_clock_dr), // Templated
						   .d1( pll_raw_clk_out), // Templated
						   .s( jtag_clsp_sel_tck2 )); // Templated

/* ctu_mux21 AUTO_TEMPLATE (
   .s( jtag_clsp_sel_tck2 ),
   .d1 (pll_raw_clk_out),
   .d0 (jtag_clock_dr),
   .z ( jtag_clock_dr_dram),
  );
*/
    ctu_mux21 u_ctu_clsp_clkgn_clksw_dram_tck_mux (/*AUTOINST*/
						   // Outputs
						   .z( jtag_clock_dr_dram), // Templated
						   // Inputs
						   .d0(jtag_clock_dr), // Templated
						   .d1(pll_raw_clk_out), // Templated
						   .s( jtag_clsp_sel_tck2 )); // Templated




  /* ctu_clsp_clkgn_nstep AUTO_TEMPLATE (
                  .cmp_gclk_bypass(cmp_gclk_byp_int),
                  .dram_gclk_bypass(dram_gclk_byp_int),
                  .jbus_gclk_bypass(jbus_gclk_byp_int),
		  .capture_l(dft_clsp_nstep_capture_l),
                  
   );
  */
    ctu_clsp_clkgn_nstep u_ctu_clsp_clkgn_nstep(/*AUTOINST*/
						// Outputs
						.cmp_nstep_sel(cmp_nstep_sel),
						.jbus_nstep_sel(jbus_nstep_sel),
						.dram_nstep_sel(dram_nstep_sel),
						// Inputs
						.io_pwron_rst_l(io_pwron_rst_l),
						.jtag_clock_dr_cmp(jtag_clock_dr_cmp),
						.jtag_clock_dr_dram(jtag_clock_dr_dram),
						.jtag_clock_dr_jbus(jtag_clock_dr_jbus),
						.jtag_clsp_force_cken_jbus(jtag_clsp_force_cken_jbus),
						.jtag_clsp_force_cken_dram(jtag_clsp_force_cken_dram),
						.jtag_clsp_force_cken_cmp(jtag_clsp_force_cken_cmp),
						.jtag_nstep_count(jtag_nstep_count[3:0]),
						.jtag_nstep_domain(jtag_nstep_domain[2:0]),
						.jtag_nstep_vld(jtag_nstep_vld),
						.cmp_gclk_bypass(cmp_gclk_byp_int), // Templated
						.dram_gclk_bypass(dram_gclk_byp_int), // Templated
						.jbus_gclk_bypass(jbus_gclk_byp_int), // Templated
						.capture_l(dft_clsp_nstep_capture_l), // Templated
						.start_clk_early_jl(start_clk_early_jl),
						.testmode_l(testmode_l),
						.shadreg_div_cmult(shadreg_div_cmult[13:0]),
						.shadreg_div_jmult(shadreg_div_jmult[9:0]),
						.shadreg_div_dmult(shadreg_div_dmult[9:0]));



  /* ctu_clsp_clkgn_clksw AUTO_TEMPLATE (
                  .cmp_gclk_bypass(cmp_gclk_byp),
                  .dram_gclk_bypass(dram_gclk_byp),
                  .jbus_gclk_bypass(jbus_gclk_byp),
		  .capture_l(dft_clsp_nstep_capture_l),
   );
  */
     ctu_clsp_clkgn_clksw u_ctu_clsp_clkgn_clksw(/*AUTOINST*/
						 // Outputs
						 .cmp_tst_clk(cmp_tst_clk),
						 .cmp_clk_sel(cmp_clk_sel),
						 .dram_tst_clk(dram_tst_clk),
						 .dram_clk_sel(dram_clk_sel),
						 .jbus_tst_clk(jbus_tst_clk),
						 .jbus_clk_sel(jbus_clk_sel),
						 // Inputs
						 .io_pwron_rst_l(io_pwron_rst_l),
						 .jtag_clock_dr_cmp(jtag_clock_dr_cmp),
						 .jtag_clock_dr_jbus(jtag_clock_dr_jbus),
						 .jtag_clock_dr_dram(jtag_clock_dr_dram),
						 .capture_l(dft_clsp_nstep_capture_l), // Templated
						 .jtag_clsp_sel_cpu(jtag_clsp_sel_cpu[2:0]),
						 .jtag_clsp_sel_dram(jtag_clsp_sel_dram[2:0]),
						 .jtag_clsp_sel_jbus(jtag_clsp_sel_jbus[2:0]),
						 .jbus_alt_bypsel_l(jbus_alt_bypsel_l),
						 .cmp_div_bypass(cmp_div_bypass),
						 .cmp_gclk_bypass(cmp_gclk_byp), // Templated
						 .jbus_div_bypass(jbus_div_bypass),
						 .jbus_gclk_bypass(jbus_gclk_byp), // Templated
						 .dram_gclk_bypass(dram_gclk_byp), // Templated
						 .testmode_l(testmode_l),
						 .cmp_nstep_sel(cmp_nstep_sel),
						 .jbus_nstep_sel(jbus_nstep_sel),
						 .dram_nstep_sel(dram_nstep_sel));

  /* bw_u1_inv_5x AUTO_TEMPLATE (
                   .z(dram_gclk_byp),
                   .a(dram_gclk_byp_inv),
                                 );
  */
     bw_u1_inv_5x u_ctu_clsp_clkgn_mux_dram0_gated (/*AUTOINST*/
						    // Outputs
						    .z(dram_gclk_byp), // Templated
						    // Inputs
						    .a(dram_gclk_byp_inv)); // Templated

  /* bw_u1_inv_5x AUTO_TEMPLATE (
                   .z(dram_gclk_byp_pre),
                   .a(dram_gclk_byp_inv),
                                 );
  */
     bw_u1_inv_5x u_ctu_clsp_clkgn_mux_dram1_gated (/*AUTOINST*/
						    // Outputs
						    .z(dram_gclk_byp_pre), // Templated
						    // Inputs
						    .a(dram_gclk_byp_inv)); // Templated


 /* bw_u1_ckbuf_30x AUTO_TEMPLATE (
       .rclk(dram_gclk_byp_pre),
       .clk(dram_gclk_byp_int),
     );
  */
     bw_u1_ckbuf_30x u_ctu_clsp_clkgn_mux_dram2_gated (/*AUTOINST*/
						       // Outputs
						       .clk(dram_gclk_byp_int), // Templated
						       // Inputs
						       .rclk(dram_gclk_byp_pre)); // Templated



  /* bw_u1_inv_5x AUTO_TEMPLATE (
                   .z(jbus_gclk_byp),
                   .a(jbus_gclk_byp_inv),
                                 );
  */
     bw_u1_inv_5x u_ctu_clsp_clkgn_mux_jbus0_gated (/*AUTOINST*/
						    // Outputs
						    .z(jbus_gclk_byp), // Templated
						    // Inputs
						    .a(jbus_gclk_byp_inv)); // Templated

  /* bw_u1_inv_5x AUTO_TEMPLATE (
                   .z(jbus_gclk_byp_pre),
                   .a(jbus_gclk_byp_inv),
                                 );
  */
     bw_u1_inv_5x  u_ctu_clsp_clkgn_mux_jbus1_gated (/*AUTOINST*/
						     // Outputs
						     .z(jbus_gclk_byp_pre), // Templated
						     // Inputs
						     .a(jbus_gclk_byp_inv)); // Templated

/* bw_u1_ckbuf_30x AUTO_TEMPLATE (
       .rclk (jbus_gclk_byp_pre),
       .clk(jbus_gclk_byp_int),
     );
  */
     bw_u1_ckbuf_30x u_ctu_clsp_clkgn_mux_jbus2_gated (/*AUTOINST*/
						       // Outputs
						       .clk(jbus_gclk_byp_int), // Templated
						       // Inputs
						       .rclk(jbus_gclk_byp_pre)); // Templated



  /* bw_u1_inv_5x  AUTO_TEMPLATE (
                   .z(cmp_gclk_byp),
                   .a(cmp_gclk_byp_inv),
                                 );
  */
     bw_u1_inv_5x u_ctu_clsp_clkgn_mux_cmp0_gated (/*AUTOINST*/
						   // Outputs
						   .z(cmp_gclk_byp), // Templated
						   // Inputs
						   .a(cmp_gclk_byp_inv)); // Templated

  /* bw_u1_inv_5x  AUTO_TEMPLATE (
                   .z(cmp_gclk_byp_pre),
                   .a(cmp_gclk_byp_inv),
                                 );
  */
     bw_u1_inv_5x  u_ctu_clsp_clkgn_mux_cmp1_gated (/*AUTOINST*/
						    // Outputs
						    .z(cmp_gclk_byp_pre), // Templated
						    // Inputs
						    .a(cmp_gclk_byp_inv)); // Templated

/* bw_clk_cl_ctu_2xcmp AUTO_TEMPLATE (
       .bw_pll_2xclk (cmp_gclk_byp_pre),
       .bw_pll_2x_clk_local (cmp_gclk_byp_int),
     );
  */
     bw_clk_cl_ctu_2xcmp u_ctu_clsp_clkgn_mux_cmp2_gated (/*AUTOINST*/
							  // Outputs
							  .bw_pll_2x_clk_local(cmp_gclk_byp_int), // Templated
							  // Inputs
							  .bw_pll_2xclk(cmp_gclk_byp_pre)); // Templated



  
  /* bw_ctu_clk_sync_mux AUTO_TEMPLATE (
					    .cmp_gclk_byp(cmp_gclk_byp_inv),
					    .dram_gclk_byp(dram_gclk_byp_inv),
					    .jbus_gclk_byp(jbus_gclk_byp_inv),
					    .pll_clk_out(pll_clk_out_pre),
					    .pll_clk_out_l(pll_clk_out_pre_l),
					    .jbus_clk_mux_0(jbus_tst_clk),
					    .dram_clk_mux_0(dram_tst_clk),
					    .cmp_clk_mux_0(cmp_tst_clk),
					    .jbus_gclk_dupl_mux_0(1'b0),
					    .tcu_sel_jbus(jbus_clk_sel),
					    .tcu_sel_dram(dram_clk_sel),
					    .tcu_sel_cpu(cmp_clk_sel),
					    .tcu_sel_jbus_dup(1'b1),
					    .jbus_dup_div1(1'b0),
					    .jbus_gclk_dup_byp(),
      );
  */
     bw_ctu_clk_sync_mux u_ctu_clsp_clkgn_mux(/*AUTOINST*/
					      // Outputs
					      .cmp_gclk_byp(cmp_gclk_byp_inv), // Templated
					      .dram_gclk_byp(dram_gclk_byp_inv), // Templated
					      .jbus_gclk_byp(jbus_gclk_byp_inv), // Templated
					      .cmp_gclk_out(cmp_gclk_out),
					      .dram_gclk_out(dram_gclk_out),
					      .jbus_gclk_out(jbus_gclk_out),
					      .jbus_gclk_dup_byp(), // Templated
					      .jbus_gclk_dup_out(jbus_gclk_dup_out),
					      // Inputs
					      .tcu_sel_jbus(jbus_clk_sel), // Templated
					      .tcu_sel_dram(dram_clk_sel), // Templated
					      .tcu_sel_cpu(cmp_clk_sel), // Templated
					      .tcu_sel_jbus_dup(1'b1), // Templated
					      .jbus_div0(jbus_div0),
					      .jbus_clk_mux_0(jbus_tst_clk), // Templated
					      .jbus_div1(jbus_div1),
					      .dram_clk_mux_0(dram_tst_clk), // Templated
					      .dram_div0(dram_div0),
					      .dram_div1(dram_div1),
					      .pll_clk_out(pll_clk_out_pre), // Templated
					      .cmp_div1(cmp_div1),
					      .cmp_div0(cmp_div0),
					      .cmp_clk_mux_0(cmp_tst_clk), // Templated
					      .pll_clk_out_l(pll_clk_out_pre_l), // Templated
					      .jbus_gclk_dupl_mux_0(1'b0), // Templated
					      .jbus_dup_div0(jbus_dup_div0),
					      .jbus_dup_div1(1'b0)); // Templated


     /* ctu_clsp_clkgn_shadreg AUTO_TEMPLATE (
         .jtag_ctu_bypass_mode(jtag_clsp_sel_jbus[2]),
       );
     */

     ctu_clsp_clkgn_shadreg u_ctu_clsp_clkgn_shadreg(/*AUTOINST*/
						     // Outputs
						     .jsync_shadreg_rx2(jsync_shadreg_rx2[1:0]),
						     .jsync_shadreg_rx1(jsync_shadreg_rx1[1:0]),
						     .jsync_shadreg_rx0(jsync_shadreg_rx0[1:0]),
						     .jsync_shadreg_tx2(jsync_shadreg_tx2[4:0]),
						     .jsync_shadreg_tx1(jsync_shadreg_tx1[4:0]),
						     .jsync_shadreg_tx0(jsync_shadreg_tx0[4:0]),
						     .jsync_shadreg_period(jsync_shadreg_period[4:0]),
						     .jsync_shadreg_init(jsync_shadreg_init[4:0]),
						     .dsync_shadreg_rx2(dsync_shadreg_rx2[1:0]),
						     .dsync_shadreg_rx1(dsync_shadreg_rx1[1:0]),
						     .dsync_shadreg_rx0(dsync_shadreg_rx0[1:0]),
						     .dsync_shadreg_tx2(dsync_shadreg_tx2[4:0]),
						     .dsync_shadreg_tx1(dsync_shadreg_tx1[4:0]),
						     .dsync_shadreg_tx0(dsync_shadreg_tx0[4:0]),
						     .dsync_shadreg_period(dsync_shadreg_period[4:0]),
						     .dsync_shadreg_init(dsync_shadreg_init[4:0]),
						     .shadreg_cdiv_vec(shadreg_cdiv_vec[14:0]),
						     .shadreg_cdiv_0(shadreg_cdiv_0),
						     .shadreg_ddiv_vec(shadreg_ddiv_vec[14:0]),
						     .shadreg_ddiv_0(shadreg_ddiv_0),
						     .shadreg_jdiv_vec(shadreg_jdiv_vec[14:0]),
						     .shadreg_jdiv_0(shadreg_jdiv_0),
						     .cmp_grst_cl_l(cmp_grst_cl_l),
						     .cmp_dbginit_cl_l(cmp_dbginit_cl_l),
						     .a_grst_dl(a_grst_dl),
						     .a_dbginit_dl(a_dbginit_dl),
						     .de_grst_dsync_edge_dl(de_grst_dsync_edge_dl),
						     .de_grst_jsync_edge(de_grst_jsync_edge),
						     .de_dbginit_dsync_edge_dl(de_dbginit_dsync_edge_dl),
						     .de_dbginit_jsync_edge(de_dbginit_jsync_edge),
						     .coin_cnt_en(coin_cnt_en),
						     .coin_cnt_ld(coin_cnt_ld),
						     .coin_edge(coin_edge),
						     .shadreg_div_jmult(shadreg_div_jmult[9:0]),
						     .shadreg_div_dmult(shadreg_div_dmult[9:0]),
						     .shadreg_div_cmult(shadreg_div_cmult[13:0]),
						     // Inputs
						     .io_pwron_rst_l(io_pwron_rst_l),
						     .se(se),
						     .start_clk_early_jl(start_clk_early_jl),
						     .start_clk_cl(start_clk_cl),
						     .cmp_clk(cmp_clk),
						     .jbus_tx_sync(jbus_tx_sync),
						     .ctu_dram_tx_sync_early(ctu_dram_tx_sync_early),
						     .a_dbginit_cl(a_dbginit_cl),
						     .de_dbginit_cl(de_dbginit_cl),
						     .de_grst_cl(de_grst_cl),
						     .a_grst_cl(a_grst_cl),
						     .dram_a_grst_cl(dram_a_grst_cl),
						     .update_shadow_cl(update_shadow_cl),
						     .jtag_ctu_bypass_mode(jtag_clsp_sel_jbus[2]), // Templated
						     .jsync_reg_rx2(jsync_reg_rx2[1:0]),
						     .jsync_reg_rx1(jsync_reg_rx1[1:0]),
						     .jsync_reg_rx0(jsync_reg_rx0[1:0]),
						     .jsync_reg_tx2(jsync_reg_tx2[4:0]),
						     .jsync_reg_tx1(jsync_reg_tx1[4:0]),
						     .jsync_reg_tx0(jsync_reg_tx0[4:0]),
						     .jsync_reg_period(jsync_reg_period[4:0]),
						     .jsync_reg_init(jsync_reg_init[4:0]),
						     .dsync_reg_rx2(dsync_reg_rx2[1:0]),
						     .dsync_reg_rx1(dsync_reg_rx1[1:0]),
						     .dsync_reg_rx0(dsync_reg_rx0[1:0]),
						     .dsync_reg_tx2(dsync_reg_tx2[4:0]),
						     .dsync_reg_tx1(dsync_reg_tx1[4:0]),
						     .dsync_reg_tx0(dsync_reg_tx0[4:0]),
						     .dsync_reg_period(dsync_reg_period[4:0]),
						     .dsync_reg_init(dsync_reg_init[4:0]),
						     .reg_div_cmult(reg_div_cmult[13:0]),
						     .reg_div_jmult(reg_div_jmult[9:0]),
						     .reg_div_dmult(reg_div_dmult[9:0]),
						     .reg_cdiv_0(reg_cdiv_0),
						     .reg_cdiv_vec(reg_cdiv_vec[14:0]),
						     .reg_ddiv_0(reg_ddiv_0),
						     .reg_ddiv_vec(reg_ddiv_vec[14:0]),
						     .reg_jdiv_0(reg_jdiv_0),
						     .reg_jdiv_vec(reg_jdiv_vec[14:0]));





endmodule // ctu_clsp_clkgn

// Local Variables:
// verilog-library-directories:("." "../../clk/rtl" "../../common/rtl" "../common/rtl" "../../analog/bw_pll/rtl")
// verilog-library-files:("." "../../common/rtl/u1.behV" "../common/rtl/ctu_lib.v")
// verilog-auto-sense-defines-constant:t
// End:
