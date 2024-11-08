// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp_synch_jlcl.v
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
//    Unit Name: ctu_clsp_dramif
//
//-----------------------------------------------------------------------------
`include "sys.h"
`include "ctu.h"

module ctu_clsp_synch_jlcl(/*AUTOARG*/
// Outputs
update_clkctrl_reg_cl, stop_id_vld_cl, sctag3_ctu_tr_cl, 
sctag2_ctu_tr_cl, sctag1_ctu_tr_cl, sctag0_ctu_tr_cl, 
rstctrl_idle_cl, rstctrl_enclk_cl, rstctrl_disclk_cl, 
rd_clkctrl_reg_cl, jbi_ctu_tr_cl, iob_ctu_tr_cl, iob_ctu_l2_tr_cl, 
dram_a_grst_cl, dram13_ctu_tr_cl, dram02_ctu_tr_cl, de_grst_cl, 
de_dbginit_cl, dbgtrig_dly_cnt_val_cl, ctu_sparc7_cmp_cken_cg, 
ctu_sparc6_cmp_cken_cg, ctu_sparc5_cmp_cken_cg, 
ctu_sparc4_cmp_cken_cg, ctu_sparc3_cmp_cken_cg, 
ctu_sparc2_cmp_cken_cg, ctu_sparc1_cmp_cken_cg, 
ctu_sparc0_cmp_cken_cg, ctu_sctag3_cmp_cken_cg, 
ctu_sctag2_cmp_cken_cg, ctu_sctag1_cmp_cken_cg, 
ctu_sctag0_cmp_cken_cg, ctu_scdata3_cmp_cken_cg, 
ctu_scdata2_cmp_cken_cg, ctu_scdata1_cmp_cken_cg, 
ctu_scdata0_cmp_cken_cg, ctu_misc_cken_pre_jl, ctu_jbusr_cken_pre_jl, 
ctu_jbusl_cken_pre_jl, ctu_jbi_cmp_cken_cg, ctu_jbi_cken_pre_jl, 
ctu_iob_cmp_cken_cg, ctu_iob_cken_pre_jl, ctu_io_j_err_jl, 
ctu_fpu_cmp_cken_cg, ctu_efc_cken_pre_jl, ctu_dram13_cmp_cken_cg, 
ctu_dram13_cken_pre_jl, ctu_dram02_cmp_cken_cg, 
ctu_dram02_cken_pre_jl, ctu_dbg_cken_pre_jl, ctu_ccx_cmp_cken_cg, 
creg_cken_vld_cl, clsp_ctrl_srarm_pre_jl, clkctrl_dn_jl, a_grst_cl, 
a_dbginit_cl, start_clk_cl, update_shadow_cl, 
// Inputs
stop_id_vld_jl, sctag3_ctu_tr, sctag2_ctu_tr, sctag1_ctu_tr, 
sctag0_ctu_tr, rstctrl_idle_jl, rstctrl_enclk_jl, rstctrl_disclk_jl, 
jbus_tx_sync, jbi_ctu_tr_jl, iob_ctu_tr_jl, iob_ctu_l2_tr_jl, 
dram_a_grst_jl, dram13_ctu_tr_jl, dram02_ctu_tr_jl, de_grst_jl, 
de_dbginit_jl, dbgtrig_dly_cnt_val, ctu_sparc7_cken_cl, 
ctu_sparc6_cken_cl, ctu_sparc5_cken_cl, ctu_sparc4_cken_cl, 
ctu_sparc3_cken_cl, ctu_sparc2_cken_cl, ctu_sparc1_cken_cl, 
ctu_sparc0_cken_cl, ctu_sctag3_cken_cl, ctu_sctag2_cken_cl, 
ctu_sctag1_cken_cl, ctu_sctag0_cken_cl, ctu_scdata3_cken_cl, 
ctu_scdata2_cken_cl, ctu_scdata1_cken_cl, ctu_scdata0_cken_cl, 
ctu_jbi_cken_cl, ctu_iob_cken_cl, ctu_io_j_err_cl, ctu_fpu_cken_cl, 
ctu_efc_cken_cl, ctu_dram13_cken_cl, ctu_dram02_cken_cl, 
ctu_ccx_cken_cl, creg_cken_vld_jl, cmp_clk, clsp_ctrl_srarm_cl, 
clkctrl_dn_cl, a_grst_jl, a_dbginit_jl, jbus_rx_sync, io_pwron_rst_l, 
update_shadow_jl, ctu_jbus_rx_sync_cl, ctu_jbusr_cken_cl, 
ctu_jbusl_cken_cl, ctu_misc_cken_cl, ctu_dbg_cken_cl, 
update_clkctrl_reg_jl, rd_clkctrl_reg_jl, start_clk_early_jl, 
jtag_clsp_force_cken_cmp, testmode_l
);

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input			a_dbginit_jl;		// To u_a_dbginit of dffrle_ns.v
input			a_grst_jl;		// To u_grst_dis of dffrle_ns.v
input			clkctrl_dn_cl;		// To u_clkctrl_dn_jl of dffrle_ns.v
input			clsp_ctrl_srarm_cl;	// To u_clsp_ctrl_srarm_pre_jl of dffrle_ns.v
input			cmp_clk;		// To u_ctu_sparc0_cmp_cken_cl of ctu_synch_cl_cg.v, ...
input			creg_cken_vld_jl;	// To u_creg_cken_vld_cl of dffrle_ns.v
input			ctu_ccx_cken_cl;	// To u_ctu_ccx_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_dram02_cken_cl;	// To u_ctu_dram02_cmp_cken_cl of ctu_synch_cl_cg.v, ...
input			ctu_dram13_cken_cl;	// To u_ctu_dram13_cmp_cken_cl of ctu_synch_cl_cg.v, ...
input			ctu_efc_cken_cl;	// To u_ctu_efc_cken_jl of dffrle_ns.v
input			ctu_fpu_cken_cl;	// To u_ctu_fpu_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_io_j_err_cl;	// To u_ctu_io_j_err_jl of dffrle_ns.v
input			ctu_iob_cken_cl;	// To u_ctu_iob_cmp_cken_cl of ctu_synch_cl_cg.v, ...
input			ctu_jbi_cken_cl;	// To u_ctu_jbi_cmp_cken_cl of ctu_synch_cl_cg.v, ...
input			ctu_scdata0_cken_cl;	// To u_ctu_scdata0_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_scdata1_cken_cl;	// To u_ctu_scdata1_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_scdata2_cken_cl;	// To u_ctu_scdata2_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_scdata3_cken_cl;	// To u_ctu_scdata3_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sctag0_cken_cl;	// To u_ctu_sctag0_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sctag1_cken_cl;	// To u_ctu_sctag1_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sctag2_cken_cl;	// To u_ctu_sctag2_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sctag3_cken_cl;	// To u_ctu_sctag3_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sparc0_cken_cl;	// To u_ctu_sparc0_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sparc1_cken_cl;	// To u_ctu_sparc1_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sparc2_cken_cl;	// To u_ctu_sparc2_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sparc3_cken_cl;	// To u_ctu_sparc3_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sparc4_cken_cl;	// To u_ctu_sparc4_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sparc5_cken_cl;	// To u_ctu_sparc5_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sparc6_cken_cl;	// To u_ctu_sparc6_cmp_cken_cl of ctu_synch_cl_cg.v
input			ctu_sparc7_cken_cl;	// To u_ctu_sparc7_cmp_cken_cl of ctu_synch_cl_cg.v
input [4:0]		dbgtrig_dly_cnt_val;	// To u_dbgtrig_dly_cnt_val of dffrle_ns.v
input			de_dbginit_jl;		// To u_de_dbginit of dffrle_ns.v
input			de_grst_jl;		// To u_grst_en of dffrle_ns.v
input			dram02_ctu_tr_jl;	// To u_dram02_ctu_tr_cl of dffrle_ns.v
input			dram13_ctu_tr_jl;	// To u_dram13_ctu_tr_cl of dffrle_ns.v
input			dram_a_grst_jl;		// To u_dram_grst_dis of dffrle_ns.v
input			iob_ctu_l2_tr_jl;	// To u_iob_ctu_l2_tr_cl of dffrle_ns.v
input			iob_ctu_tr_jl;		// To u_iob_ctu_tr_cl of dffrle_ns.v
input			jbi_ctu_tr_jl;		// To u_jbi_ctu_tr_cl of dffrle_ns.v
input			jbus_tx_sync;		// To u_clkctrl_dn_jl of dffrle_ns.v, ...
input			rstctrl_disclk_jl;	// To u_rstctrl_disclk_cl of dffrle_ns.v
input			rstctrl_enclk_jl;	// To u_rstctrl_enclk_cl of dffrle_ns.v
input			rstctrl_idle_jl;	// To u_rstctrl_idle_cl of dffrle_ns.v
input			sctag0_ctu_tr;		// To u_sctag0_ctu_tr_ff of dffrl_ns.v
input			sctag1_ctu_tr;		// To u_sctag1_ctu_tr_ff of dffrl_ns.v
input			sctag2_ctu_tr;		// To u_sctag2_ctu_tr_ff of dffrl_ns.v
input			sctag3_ctu_tr;		// To u_sctag3_ctu_tr_ff of dffrl_ns.v
input			stop_id_vld_jl;		// To u_stop_id_vld_cl of dffrle_ns.v
// End of automatics
input			jbus_rx_sync;		// To u_ctu_sparc0_cmp_cken_cl of ctu_synch_cl_cg.v, ...
input                   io_pwron_rst_l;
input			update_shadow_jl;		// To u_start_clk_cl of ctu_synch_jl_cl.v
input                   ctu_jbus_rx_sync_cl;
input                   ctu_jbusr_cken_cl;
input                   ctu_jbusl_cken_cl;
input                   ctu_misc_cken_cl;
input                   ctu_dbg_cken_cl;
input                   update_clkctrl_reg_jl;
input                   rd_clkctrl_reg_jl;
input                   start_clk_early_jl;
input                   jtag_clsp_force_cken_cmp;
input                   testmode_l;

/*AUTOOUTPUT*/
// Beginning of automatic outputs (from unused autoinst outputs)
output			a_dbginit_cl;		// From u_a_dbginit of dffrle_ns.v
output			a_grst_cl;		// From u_grst_dis of dffrle_ns.v
output			clkctrl_dn_jl;		// From u_clkctrl_dn_jl of dffrle_ns.v
output			clsp_ctrl_srarm_pre_jl;	// From u_clsp_ctrl_srarm_pre_jl of dffrle_ns.v
output			creg_cken_vld_cl;	// From u_creg_cken_vld_cl of dffrle_ns.v
output			ctu_ccx_cmp_cken_cg;	// From u_ctu_ccx_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_dbg_cken_pre_jl;	// From u_ctu_dbg_cken_jl of dffsl_async_ns.v
output			ctu_dram02_cken_pre_jl;	// From u_ctu_dram02_cken_jl of dffrle_ns.v
output			ctu_dram02_cmp_cken_cg;	// From u_ctu_dram02_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_dram13_cken_pre_jl;	// From u_ctu_dram13_cken_jl of dffrle_ns.v
output			ctu_dram13_cmp_cken_cg;	// From u_ctu_dram13_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_efc_cken_pre_jl;	// From u_ctu_efc_cken_jl of dffrle_ns.v
output			ctu_fpu_cmp_cken_cg;	// From u_ctu_fpu_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_io_j_err_jl;	// From u_ctu_io_j_err_jl of dffrle_ns.v
output			ctu_iob_cken_pre_jl;	// From u_ctu_iob_cken_jl of dffrle_ns.v
output			ctu_iob_cmp_cken_cg;	// From u_ctu_iob_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_jbi_cken_pre_jl;	// From u_ctu_jbi_cken_jl of dffrle_ns.v
output			ctu_jbi_cmp_cken_cg;	// From u_ctu_jbi_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_jbusl_cken_pre_jl;	// From u_ctu_jbusl_cken_jl of dffsl_async_ns.v
output			ctu_jbusr_cken_pre_jl;	// From u_ctu_jbusr_cken_jl of dffsl_async_ns.v
output			ctu_misc_cken_pre_jl;	// From u_ctu_misc_cken_jl of dffsl_async_ns.v
output			ctu_scdata0_cmp_cken_cg;// From u_ctu_scdata0_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_scdata1_cmp_cken_cg;// From u_ctu_scdata1_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_scdata2_cmp_cken_cg;// From u_ctu_scdata2_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_scdata3_cmp_cken_cg;// From u_ctu_scdata3_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sctag0_cmp_cken_cg;	// From u_ctu_sctag0_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sctag1_cmp_cken_cg;	// From u_ctu_sctag1_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sctag2_cmp_cken_cg;	// From u_ctu_sctag2_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sctag3_cmp_cken_cg;	// From u_ctu_sctag3_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sparc0_cmp_cken_cg;	// From u_ctu_sparc0_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sparc1_cmp_cken_cg;	// From u_ctu_sparc1_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sparc2_cmp_cken_cg;	// From u_ctu_sparc2_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sparc3_cmp_cken_cg;	// From u_ctu_sparc3_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sparc4_cmp_cken_cg;	// From u_ctu_sparc4_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sparc5_cmp_cken_cg;	// From u_ctu_sparc5_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sparc6_cmp_cken_cg;	// From u_ctu_sparc6_cmp_cken_cl of ctu_synch_cl_cg.v
output			ctu_sparc7_cmp_cken_cg;	// From u_ctu_sparc7_cmp_cken_cl of ctu_synch_cl_cg.v
output [4:0]		dbgtrig_dly_cnt_val_cl;	// From u_dbgtrig_dly_cnt_val of dffrle_ns.v
output			de_dbginit_cl;		// From u_de_dbginit of dffrle_ns.v
output			de_grst_cl;		// From u_grst_en of dffrle_ns.v
output			dram02_ctu_tr_cl;	// From u_dram02_ctu_tr_cl of dffrle_ns.v
output			dram13_ctu_tr_cl;	// From u_dram13_ctu_tr_cl of dffrle_ns.v
output			dram_a_grst_cl;		// From u_dram_grst_dis of dffrle_ns.v
output			iob_ctu_l2_tr_cl;	// From u_iob_ctu_l2_tr_cl of dffrle_ns.v
output			iob_ctu_tr_cl;		// From u_iob_ctu_tr_cl of dffrle_ns.v
output			jbi_ctu_tr_cl;		// From u_jbi_ctu_tr_cl of dffrle_ns.v
output			rd_clkctrl_reg_cl;	// From u_rd_clkctrl_reg_jl of dffrl_async_ns.v
output			rstctrl_disclk_cl;	// From u_rstctrl_disclk_cl of dffrle_ns.v
output			rstctrl_enclk_cl;	// From u_rstctrl_enclk_cl of dffrle_ns.v
output			rstctrl_idle_cl;	// From u_rstctrl_idle_cl of dffrle_ns.v
output			sctag0_ctu_tr_cl;	// From u_sctag0_ctu_tr_cl of dffrl_ns.v
output			sctag1_ctu_tr_cl;	// From u_sctag1_ctu_tr_cl of dffrl_ns.v
output			sctag2_ctu_tr_cl;	// From u_sctag2_ctu_tr_cl of dffrl_ns.v
output			sctag3_ctu_tr_cl;	// From u_sctag3_ctu_tr_cl of dffrl_ns.v
output			stop_id_vld_cl;		// From u_stop_id_vld_cl of dffrle_ns.v
output			update_clkctrl_reg_cl;	// From u_update_clkctrl_reg_cl of dffrl_async_ns.v
// End of automatics
output			start_clk_cl;		// From u_start_clk_cl of ctu_synch_jl_cl.v
output			update_shadow_cl;		// To u_start_clk_cl of ctu_synch_jl_cl.v
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire			sctag0_ctu_tr_ff;	// From u_sctag0_ctu_tr_ff of dffrl_ns.v
wire			sctag1_ctu_tr_ff;	// From u_sctag1_ctu_tr_ff of dffrl_ns.v
wire			sctag2_ctu_tr_ff;	// From u_sctag2_ctu_tr_ff of dffrl_ns.v
wire			sctag3_ctu_tr_ff;	// From u_sctag3_ctu_tr_ff of dffrl_ns.v
// End of automatics

// Beginning of automatic wires (for undeclared instantiated-module outputs)
// End of automatics
wire ctu_jbusl_cken_jl_nxt;
wire ctu_jbusr_cken_jl_nxt;
wire ctu_jbusl_cken_pre_jl;
wire ctu_jbusr_cken_pre_jl;
wire update_clkctrl_reg_jl_nxt;
wire rd_clkctrl_reg_jl_nxt;
wire ctu_misc_cken_jl_nxt;
wire ctu_dbg_cken_jl_nxt;
wire start_clk_sync_nxt;



wire start_clk_tmp_nxt;
wire start_clk_tmp;
wire start_clk_dly_nxt;
wire start_clk_dly1;
wire start_clk_dly2;
wire start_clk_dly3;
wire start_clk_dly4;
wire start_clk_dly5;
wire start_clk_dly6;
wire start_clk_dly7;
wire update_shadow_cl_nxt;
wire force_cken ;


    assign force_cken = jtag_clsp_force_cken_cmp | ~testmode_l;

    // transimit sync pulses are generated ahead of rx 
    assign  start_clk_tmp_nxt = ctu_jbus_rx_sync_cl? 1'b1: start_clk_tmp;

    dffrl_async_ns  u_start_clk_tmp(
                   .din (start_clk_tmp_nxt),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (start_clk_tmp));

    assign  start_clk_dly_nxt = ctu_jbus_rx_sync_cl & start_clk_tmp ? 1'b1: start_clk_dly1;

    dffrl_async_ns  u_start_clk_dly1(
                   .din (start_clk_dly_nxt),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (start_clk_dly1));

    dffrl_async_ns  u_start_clk_dly2(
                   .din (start_clk_dly1),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (start_clk_dly2));

    dffrl_async_ns  u_start_clk_dly3(
                   .din (start_clk_dly2),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (start_clk_dly3));

    dffrl_async_ns  u_start_clk_dly4(
                   .din (start_clk_dly3),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (start_clk_dly4));

    dffrl_async_ns  u_start_clk_dly5(
                   .din (start_clk_dly4),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (start_clk_dly5));

    dffrl_async_ns  u_start_clk_dly6(
                   .din (start_clk_dly5),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (start_clk_dly6));

    dffrl_async_ns  u_start_clk_dly7(
                   .din (start_clk_dly6),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (start_clk_dly7));

//    dffrl_async_ns  u_start_clk_cl(
//                   .din (start_clk_dly7),
//                   .clk (cmp_clk),
//                   .rst_l(io_pwron_rst_l),
//                   .q (start_clk_cl));

    // de-asset start_clk_cl during warm_rst
    assign start_clk_sync_nxt = (jbus_rx_sync ?  start_clk_early_jl : start_clk_cl) & start_clk_dly7;

    dffrl_async_ns  u_start_clk_cl(
                   .din (start_clk_sync_nxt),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (start_clk_cl));


    assign update_shadow_cl_nxt = (jbus_rx_sync ? update_shadow_jl : update_shadow_cl) & start_clk_cl;

    dffrl_async_ns  u_update_shadow_cl(
                   .din (update_shadow_cl_nxt),
                   .clk (cmp_clk),
                   .rst_l(io_pwron_rst_l),
                   .q (update_shadow_cl));



   /* ctu_synch_cl_cg AUTO_TEMPLATE (
       .presyncdata (ctu_sparc@_cken_cl),
       .syncdata (ctu_sparc@_cmp_cken_cg),
       .arst_l(io_pwron_rst_l),
    );
  */
   ctu_synch_cl_cg u_ctu_sparc0_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sparc0_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sparc0_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sparc1_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sparc1_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sparc1_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sparc2_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sparc2_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sparc2_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sparc3_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sparc3_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sparc3_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sparc4_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sparc4_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sparc4_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sparc5_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sparc5_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sparc5_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sparc6_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sparc6_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sparc6_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sparc7_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sparc7_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sparc7_cken_cl)); // Templated

   /* ctu_synch_cl_cg AUTO_TEMPLATE (
       .presyncdata (ctu_scdata@_cken_cl),
       .syncdata (ctu_scdata@_cmp_cken_cg),
       .arst_l(io_pwron_rst_l),
    );
  */
   ctu_synch_cl_cg u_ctu_scdata0_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					     // Outputs
					     .syncdata(ctu_scdata0_cmp_cken_cg), // Templated
					     // Inputs
					     .cmp_clk(cmp_clk),
					     .arst_l(io_pwron_rst_l), // Templated
					     .force_cken(force_cken),
					     .presyncdata(ctu_scdata0_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_scdata1_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					     // Outputs
					     .syncdata(ctu_scdata1_cmp_cken_cg), // Templated
					     // Inputs
					     .cmp_clk(cmp_clk),
					     .arst_l(io_pwron_rst_l), // Templated
					     .force_cken(force_cken),
					     .presyncdata(ctu_scdata1_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_scdata2_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					     // Outputs
					     .syncdata(ctu_scdata2_cmp_cken_cg), // Templated
					     // Inputs
					     .cmp_clk(cmp_clk),
					     .arst_l(io_pwron_rst_l), // Templated
					     .force_cken(force_cken),
					     .presyncdata(ctu_scdata2_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_scdata3_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					     // Outputs
					     .syncdata(ctu_scdata3_cmp_cken_cg), // Templated
					     // Inputs
					     .cmp_clk(cmp_clk),
					     .arst_l(io_pwron_rst_l), // Templated
					     .force_cken(force_cken),
					     .presyncdata(ctu_scdata3_cken_cl)); // Templated
    

   /* ctu_synch_cl_cg AUTO_TEMPLATE (
       .presyncdata (ctu_sctag@_cken_cl),
       .syncdata (ctu_sctag@_cmp_cken_cg),
       .arst_l(io_pwron_rst_l),
    );
  */

   ctu_synch_cl_cg u_ctu_sctag0_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sctag0_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sctag0_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sctag1_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sctag1_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sctag1_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sctag2_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sctag2_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sctag2_cken_cl)); // Templated
   ctu_synch_cl_cg u_ctu_sctag3_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_sctag3_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_sctag3_cken_cl)); // Templated

   /* ctu_synch_cl_cg AUTO_TEMPLATE (
       .presyncdata (ctu_ccx_cken_cl),
       .syncdata (ctu_ccx_cmp_cken_cg),
       .arst_l(io_pwron_rst_l),
    );
  */
   ctu_synch_cl_cg u_ctu_ccx_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					 // Outputs
					 .syncdata(ctu_ccx_cmp_cken_cg), // Templated
					 // Inputs
					 .cmp_clk(cmp_clk),
					 .arst_l(io_pwron_rst_l), // Templated
					 .force_cken(force_cken),
					 .presyncdata(ctu_ccx_cken_cl)); // Templated

   /* ctu_synch_cl_cg  AUTO_TEMPLATE (
       .presyncdata (ctu_fpu_cken_cl),
       .syncdata (ctu_fpu_cmp_cken_cg),
       .arst_l(io_pwron_rst_l),
    );
  */
   ctu_synch_cl_cg u_ctu_fpu_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					 // Outputs
					 .syncdata(ctu_fpu_cmp_cken_cg), // Templated
					 // Inputs
					 .cmp_clk(cmp_clk),
					 .arst_l(io_pwron_rst_l), // Templated
					 .force_cken(force_cken),
					 .presyncdata(ctu_fpu_cken_cl)); // Templated


   /* ctu_synch_cl_cg  AUTO_TEMPLATE (
       .presyncdata (ctu_iob_cken_cl),
       .syncdata (ctu_iob_cmp_cken_cg),
       .arst_l(io_pwron_rst_l),
    );
  */
   ctu_synch_cl_cg u_ctu_iob_cmp_cken_cl(
					    .start_clk_cl(start_clk_cl),
                                            /*AUTOINST*/
					 // Outputs
					 .syncdata(ctu_iob_cmp_cken_cg), // Templated
					 // Inputs
					 .cmp_clk(cmp_clk),
					 .arst_l(io_pwron_rst_l), // Templated
					 .force_cken(force_cken),
					 .presyncdata(ctu_iob_cken_cl)); // Templated

   /* ctu_synch_cl_cg  AUTO_TEMPLATE (
       .presyncdata (ctu_jbi_cken_cl),
       .syncdata (ctu_jbi_cmp_cken_cg),
       .arst_l(io_pwron_rst_l),
    );
  */
   ctu_synch_cl_cg u_ctu_jbi_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					 // Outputs
					 .syncdata(ctu_jbi_cmp_cken_cg), // Templated
					 // Inputs
					 .cmp_clk(cmp_clk),
					 .arst_l(io_pwron_rst_l), // Templated
					 .force_cken(force_cken),
					 .presyncdata(ctu_jbi_cken_cl)); // Templated

   /* ctu_synch_cl_cg  AUTO_TEMPLATE (
       .presyncdata (ctu_dram02_cken_cl),
       .syncdata (ctu_dram02_cmp_cken_cg),
       .arst_l(io_pwron_rst_l),
    );
  */
   ctu_synch_cl_cg u_ctu_dram02_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_dram02_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_dram02_cken_cl)); // Templated

   /* ctu_synch_cl_cg  AUTO_TEMPLATE (
       .presyncdata (ctu_dram13_cken_cl),
       .syncdata (ctu_dram13_cmp_cken_cg),
       .arst_l(io_pwron_rst_l),
    );
  */
   ctu_synch_cl_cg u_ctu_dram13_cmp_cken_cl(
					       .start_clk_cl(start_clk_cl),
                                               /*AUTOINST*/
					    // Outputs
					    .syncdata(ctu_dram13_cmp_cken_cg), // Templated
					    // Inputs
					    .cmp_clk(cmp_clk),
					    .arst_l(io_pwron_rst_l), // Templated
					    .force_cken(force_cken),
					    .presyncdata(ctu_dram13_cken_cl)); // Templated



    /* dffrle_ns AUTO_TEMPLATE (
       .din (de_grst_jl),
       .q (de_grst_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns  u_grst_en(
			  .rst_l	(start_clk_cl),
                          /*AUTOINST*/
			  // Outputs
			  .q		(de_grst_cl),		 // Templated
			  // Inputs
			  .din		(de_grst_jl),		 // Templated
			  .en		(jbus_rx_sync),		 // Templated
			  .clk		(cmp_clk));		 // Templated

   /* dffrle_ns AUTO_TEMPLATE (
       .din (a_grst_jl),
       .q (a_grst_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_grst_dis(
			  .rst_l	(start_clk_cl),
                          /*AUTOINST*/
			  // Outputs
			  .q		(a_grst_cl),		 // Templated
			  // Inputs
			  .din		(a_grst_jl),		 // Templated
			  .en		(jbus_rx_sync),		 // Templated
			  .clk		(cmp_clk));		 // Templated

   /* dffrle_ns AUTO_TEMPLATE (
       .din (dram_a_grst_jl),
       .q (dram_a_grst_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
    dffrle_ns u_dram_grst_dis(
			      .rst_l	(start_clk_cl),
                               /*AUTOINST*/
			      // Outputs
			      .q	(dram_a_grst_cl),	 // Templated
			      // Inputs
			      .din	(dram_a_grst_jl),	 // Templated
			      .en	(jbus_rx_sync),		 // Templated
			      .clk	(cmp_clk));		 // Templated




   /* dffrle_ns AUTO_TEMPLATE (
       .din(de_dbginit_jl),
       .q (de_dbginit_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */

     dffrle_ns u_de_dbginit(
			       .rst_l	(start_clk_cl),
                               /*AUTOINST*/
			    // Outputs
			    .q		(de_dbginit_cl),	 // Templated
			    // Inputs
			    .din	(de_dbginit_jl),	 // Templated
			    .en		(jbus_rx_sync),		 // Templated
			    .clk	(cmp_clk));		 // Templated

   /* dffrle_ns AUTO_TEMPLATE (
       .din(a_dbginit_jl),
       .q (a_dbginit_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */

     dffrle_ns u_a_dbginit(
			       .rst_l	(start_clk_cl),
                               /*AUTOINST*/
			   // Outputs
			   .q		(a_dbginit_cl),		 // Templated
			   // Inputs
			   .din		(a_dbginit_jl),		 // Templated
			   .en		(jbus_rx_sync),		 // Templated
			   .clk		(cmp_clk));		 // Templated


   // clkctrl block

   /* dffrl_ns AUTO_TEMPLATE (
       .din(sctag@_ctu_tr),
       .q (sctag@_ctu_tr_ff),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrl_ns u_sctag0_ctu_tr_ff ( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(sctag0_ctu_tr_ff),	 // Templated
				  // Inputs
				  .din	(sctag0_ctu_tr),	 // Templated
				  .clk	(cmp_clk));		 // Templated
     dffrl_ns u_sctag1_ctu_tr_ff ( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(sctag1_ctu_tr_ff),	 // Templated
				  // Inputs
				  .din	(sctag1_ctu_tr),	 // Templated
				  .clk	(cmp_clk));		 // Templated
     dffrl_ns u_sctag2_ctu_tr_ff ( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(sctag2_ctu_tr_ff),	 // Templated
				  // Inputs
				  .din	(sctag2_ctu_tr),	 // Templated
				  .clk	(cmp_clk));		 // Templated
     dffrl_ns u_sctag3_ctu_tr_ff ( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(sctag3_ctu_tr_ff),	 // Templated
				  // Inputs
				  .din	(sctag3_ctu_tr),	 // Templated
				  .clk	(cmp_clk));		 // Templated

   /* dffrl_ns AUTO_TEMPLATE (
       .din(sctag@_ctu_tr_ff),
       .q (sctag@_ctu_tr_cl),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrl_ns u_sctag0_ctu_tr_cl ( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(sctag0_ctu_tr_cl),	 // Templated
				  // Inputs
				  .din	(sctag0_ctu_tr_ff),	 // Templated
				  .clk	(cmp_clk));		 // Templated
     dffrl_ns u_sctag1_ctu_tr_cl ( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(sctag1_ctu_tr_cl),	 // Templated
				  // Inputs
				  .din	(sctag1_ctu_tr_ff),	 // Templated
				  .clk	(cmp_clk));		 // Templated
     dffrl_ns u_sctag2_ctu_tr_cl ( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(sctag2_ctu_tr_cl),	 // Templated
				  // Inputs
				  .din	(sctag2_ctu_tr_ff),	 // Templated
				  .clk	(cmp_clk));		 // Templated
     dffrl_ns u_sctag3_ctu_tr_cl ( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(sctag3_ctu_tr_cl),	 // Templated
				  // Inputs
				  .din	(sctag3_ctu_tr_ff),	 // Templated
				  .clk	(cmp_clk));		 // Templated
      

   /* dffrle_ns AUTO_TEMPLATE (
       .din(creg_cken_vld_jl),
       .q (creg_cken_vld_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_creg_cken_vld_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(creg_cken_vld_cl),	 // Templated
				  // Inputs
				  .din	(creg_cken_vld_jl),	 // Templated
				  .en	(jbus_rx_sync),		 // Templated
				  .clk	(cmp_clk));		 // Templated

   /* dffrle_ns AUTO_TEMPLATE (
       .din(rstctrl_idle_jl),
       .q (rstctrl_idle_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_rstctrl_idle_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
				 // Outputs
				 .q	(rstctrl_idle_cl),	 // Templated
				 // Inputs
				 .din	(rstctrl_idle_jl),	 // Templated
				 .en	(jbus_rx_sync),		 // Templated
				 .clk	(cmp_clk));		 // Templated

   /* dffrle_ns AUTO_TEMPLATE (
       .din(rstctrl_disclk_jl),
       .q (rstctrl_disclk_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_rstctrl_disclk_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
				   // Outputs
				   .q	(rstctrl_disclk_cl),	 // Templated
				   // Inputs
				   .din	(rstctrl_disclk_jl),	 // Templated
				   .en	(jbus_rx_sync),		 // Templated
				   .clk	(cmp_clk));		 // Templated


   /* dffrle_ns AUTO_TEMPLATE (
       .din(rstctrl_enclk_jl),
       .q (rstctrl_enclk_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_rstctrl_enclk_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(rstctrl_enclk_cl),	 // Templated
				  // Inputs
				  .din	(rstctrl_enclk_jl),	 // Templated
				  .en	(jbus_rx_sync),		 // Templated
				  .clk	(cmp_clk));		 // Templated


   /* dffrle_ns AUTO_TEMPLATE (
       .din(iob_ctu_tr_jl),
       .q (iob_ctu_tr_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_iob_ctu_tr_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
			       // Outputs
			       .q	(iob_ctu_tr_cl),	 // Templated
			       // Inputs
			       .din	(iob_ctu_tr_jl),	 // Templated
			       .en	(jbus_rx_sync),		 // Templated
			       .clk	(cmp_clk));		 // Templated

   /* dffrle_ns AUTO_TEMPLATE (
       .din(dram@_ctu_tr_jl),
       .q (dram@_ctu_tr_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_dram02_ctu_tr_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(dram02_ctu_tr_cl),	 // Templated
				  // Inputs
				  .din	(dram02_ctu_tr_jl),	 // Templated
				  .en	(jbus_rx_sync),		 // Templated
				  .clk	(cmp_clk));		 // Templated
     dffrle_ns u_dram13_ctu_tr_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(dram13_ctu_tr_cl),	 // Templated
				  // Inputs
				  .din	(dram13_ctu_tr_jl),	 // Templated
				  .en	(jbus_rx_sync),		 // Templated
				  .clk	(cmp_clk));		 // Templated

   /* dffrle_ns AUTO_TEMPLATE (
       .din(jbi_ctu_tr_jl),
       .q (jbi_ctu_tr_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_jbi_ctu_tr_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
			       // Outputs
			       .q	(jbi_ctu_tr_cl),	 // Templated
			       // Inputs
			       .din	(jbi_ctu_tr_jl),	 // Templated
			       .en	(jbus_rx_sync),		 // Templated
			       .clk	(cmp_clk));		 // Templated


   /* dffrle_ns AUTO_TEMPLATE (
       .din(iob_ctu_l2_tr_jl),
       .q (iob_ctu_l2_tr_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_iob_ctu_l2_tr_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(iob_ctu_l2_tr_cl),	 // Templated
				  // Inputs
				  .din	(iob_ctu_l2_tr_jl),	 // Templated
				  .en	(jbus_rx_sync),		 // Templated
				  .clk	(cmp_clk));		 // Templated



   /* dffrle_ns AUTO_TEMPLATE (
       .din(stop_id_vld_jl),
       .q (stop_id_vld_cl),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_stop_id_vld_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
				// Outputs
				.q	(stop_id_vld_cl),	 // Templated
				// Inputs
				.din	(stop_id_vld_jl),	 // Templated
				.en	(jbus_rx_sync),		 // Templated
				.clk	(cmp_clk));		 // Templated


   /* dffrle_ns AUTO_TEMPLATE (
       .din(stop_id_decoded_jl[`CCTRLSM_MAX_ST-1:0]),
       .q (stop_id_decoded_cl[`CCTRLSM_MAX_ST-1:0]),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     //dffrle_ns #(`CCTRLSM_MAX_ST) u_stop_id_decoded_cl( .rst_l	(start_clk_cl), /*AUTOINST*/
//						       // Outputs
//						       .q(stop_id_decoded_cl[`CCTRLSM_MAX_ST-1:0]),
//						       // Inputs
//						       .din(stop_id_decoded_jl[`CCTRLSM_MAX_ST-1:0]),
//						       .en(jbus_rx_sync),
//						       .clk(cmp_clk));

   /* dffrle_ns AUTO_TEMPLATE (
       .din(dbgtrig_dly_cnt_val[4:0]),
       .q (dbgtrig_dly_cnt_val_cl[4:0]),
       .en(jbus_rx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns #(5) u_dbgtrig_dly_cnt_val ( .rst_l	(start_clk_cl), /*AUTOINST*/
					   // Outputs
					   .q(dbgtrig_dly_cnt_val_cl[4:0]), // Templated
					   // Inputs
					   .din(dbgtrig_dly_cnt_val[4:0]), // Templated
					   .en(jbus_rx_sync),	 // Templated
					   .clk(cmp_clk));	 // Templated

   /* dffrl_async_ns AUTO_TEMPLATE (
       .din(update_clkctrl_reg_jl_nxt ),
       .q (update_clkctrl_reg_cl),
       .rst_l(io_pwron_rst_l),
       .clk (cmp_clk),
    );
  */
   
     assign update_clkctrl_reg_jl_nxt = (jbus_rx_sync ? update_clkctrl_reg_jl : update_clkctrl_reg_cl)
				        & start_clk_cl;

     dffrl_async_ns u_update_clkctrl_reg_cl( .din (update_clkctrl_reg_jl_nxt), /*AUTOINST*/
					    // Outputs
					    .q(update_clkctrl_reg_cl), // Templated
					    // Inputs
					    .clk(cmp_clk),	 // Templated
					    .rst_l(io_pwron_rst_l)); // Templated

   /* dffrl_async_ns AUTO_TEMPLATE (
       .din(rd_clkctrl_reg_jl_nxt ),
       .q (rd_clkctrl_reg_cl),
       .rst_l(io_pwron_rst_l),
       .clk (cmp_clk),
    );
  */
     assign rd_clkctrl_reg_jl_nxt = (jbus_rx_sync ? rd_clkctrl_reg_jl : rd_clkctrl_reg_cl)
				        & start_clk_cl;

     dffrl_async_ns u_rd_clkctrl_reg_jl( .din (rd_clkctrl_reg_jl_nxt), /*AUTOINST*/
					// Outputs
					.q(rd_clkctrl_reg_cl),	 // Templated
					// Inputs
					.clk(cmp_clk),		 // Templated
					.rst_l(io_pwron_rst_l));	 // Templated




   /* dffrle_ns AUTO_TEMPLATE (
       .din (clkctrl_dn_cl),
       .q (clkctrl_dn_jl),
       .en(jbus_tx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_clkctrl_dn_jl ( .rst_l        (start_clk_cl), /*AUTOINST*/
				// Outputs
				.q	(clkctrl_dn_jl),	 // Templated
				// Inputs
				.din	(clkctrl_dn_cl),	 // Templated
				.en	(jbus_tx_sync),		 // Templated
				.clk	(cmp_clk));		 // Templated

   /* dffrle_ns AUTO_TEMPLATE (
       .din (ctu_io_j_err_cl),
       .q (ctu_io_j_err_jl),
       .en(jbus_tx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_ctu_io_j_err_jl ( .rst_l        (start_clk_cl), /*AUTOINST*/
				  // Outputs
				  .q	(ctu_io_j_err_jl),	 // Templated
				  // Inputs
				  .din	(ctu_io_j_err_cl),	 // Templated
				  .en	(jbus_tx_sync),		 // Templated
				  .clk	(cmp_clk));		 // Templated


   /* dffrle_ns AUTO_TEMPLATE (
       .din(ctu_dram@_cken_cl),
       .q (ctu_dram@_cken_pre_jl),
       .en(jbus_tx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_ctu_dram02_cken_jl( .rst_l	(start_clk_cl), /*AUTOINST*/
				    // Outputs
				    .q	(ctu_dram02_cken_pre_jl), // Templated
				    // Inputs
				    .din(ctu_dram02_cken_cl),	 // Templated
				    .en	(jbus_tx_sync),		 // Templated
				    .clk(cmp_clk));		 // Templated
     dffrle_ns u_ctu_dram13_cken_jl( .rst_l	(start_clk_cl), /*AUTOINST*/
				    // Outputs
				    .q	(ctu_dram13_cken_pre_jl), // Templated
				    // Inputs
				    .din(ctu_dram13_cken_cl),	 // Templated
				    .en	(jbus_tx_sync),		 // Templated
				    .clk(cmp_clk));		 // Templated


   /* dffrle_ns AUTO_TEMPLATE (
       .din(ctu_iob_cken_cl),
       .q (ctu_iob_cken_pre_jl),
       .en(jbus_tx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_ctu_iob_cken_jl( .rst_l	(start_clk_cl), /*AUTOINST*/
				 // Outputs
				 .q	(ctu_iob_cken_pre_jl),	 // Templated
				 // Inputs
				 .din	(ctu_iob_cken_cl),	 // Templated
				 .en	(jbus_tx_sync),		 // Templated
				 .clk	(cmp_clk));		 // Templated

   /* dffrle_ns AUTO_TEMPLATE (
       .din(ctu_efc_cken_cl),
       .q (ctu_efc_cken_pre_jl),
       .en(jbus_tx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_ctu_efc_cken_jl( .rst_l	(start_clk_cl), /*AUTOINST*/
				 // Outputs
				 .q	(ctu_efc_cken_pre_jl),	 // Templated
				 // Inputs
				 .din	(ctu_efc_cken_cl),	 // Templated
				 .en	(jbus_tx_sync),		 // Templated
				 .clk	(cmp_clk));		 // Templated


   /* dffsl_async_ns AUTO_TEMPLATE (
       .din(ctu_jbusl_cken_jl_nxt),
       .q (ctu_jbusl_cken_pre_jl),
       .set_l(io_pwron_rst_l),
       .clk (cmp_clk),
    );
  */
     assign ctu_jbusl_cken_jl_nxt =  start_clk_cl ? 
                                     (jbus_rx_sync? ctu_jbusl_cken_cl: ctu_jbusl_cken_pre_jl):
                                      1'b1;
 
     dffsl_async_ns u_ctu_jbusl_cken_jl(
				   .din	(ctu_jbusl_cken_jl_nxt),
                                   /*AUTOINST*/
					// Outputs
					.q(ctu_jbusl_cken_pre_jl), // Templated
					// Inputs
					.clk(cmp_clk),		 // Templated
					.set_l(io_pwron_rst_l));	 // Templated

   /* dffsl_async_ns AUTO_TEMPLATE (
       .din(ctu_jbusr_cken_jl_nxt),
       .q (ctu_jbusr_cken_pre_jl),
       .set_l(io_pwron_rst_l),
       .clk (cmp_clk),
    );
  */
     assign ctu_jbusr_cken_jl_nxt =   start_clk_cl ? 
                                      (jbus_rx_sync  ? ctu_jbusr_cken_cl:  ctu_jbusr_cken_pre_jl):
                                      1'b1;

     dffsl_async_ns u_ctu_jbusr_cken_jl( 
				   .din	(ctu_jbusr_cken_jl_nxt),
                                   /*AUTOINST*/
					// Outputs
					.q(ctu_jbusr_cken_pre_jl), // Templated
					// Inputs
					.clk(cmp_clk),		 // Templated
					.set_l(io_pwron_rst_l));	 // Templated


   /* dffrle_ns AUTO_TEMPLATE (
       .din(ctu_jbi_cken_cl),
       .q (ctu_jbi_cken_pre_jl),
       .en(jbus_tx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */
     dffrle_ns u_ctu_jbi_cken_jl( .rst_l	(start_clk_cl), /*AUTOINST*/
				 // Outputs
				 .q	(ctu_jbi_cken_pre_jl),	 // Templated
				 // Inputs
				 .din	(ctu_jbi_cken_cl),	 // Templated
				 .en	(jbus_tx_sync),		 // Templated
				 .clk	(cmp_clk));		 // Templated

   /* dffsl_async_ns AUTO_TEMPLATE (
       .din(ctu_dbg_cken_jl_nxt),
       .q (ctu_dbg_cken_pre_jl),
       .set_l(io_pwron_rst_l),
       .clk (cmp_clk),
    );
  */

     assign ctu_dbg_cken_jl_nxt =   start_clk_cl ? 
                                      (jbus_rx_sync  ? ctu_dbg_cken_cl:  ctu_dbg_cken_pre_jl):
                                      1'b1;
     dffsl_async_ns u_ctu_dbg_cken_jl( .din	(ctu_dbg_cken_jl_nxt),
                                   /*AUTOINST*/
				      // Outputs
				      .q(ctu_dbg_cken_pre_jl),	 // Templated
				      // Inputs
				      .clk(cmp_clk),		 // Templated
				      .set_l(io_pwron_rst_l));	 // Templated


   /* dffsl_async_ns AUTO_TEMPLATE (
       .din(ctu_misc_cken_jl_nxt),
       .q (ctu_misc_cken_pre_jl),
       .set_l(io_pwron_rst_l),
       .clk (cmp_clk),
    );
  */

     assign ctu_misc_cken_jl_nxt =   start_clk_cl ? 
                                      (jbus_rx_sync  ? ctu_misc_cken_cl:  ctu_misc_cken_pre_jl):
                                      1'b1;
     dffsl_async_ns u_ctu_misc_cken_jl( .din	(ctu_misc_cken_jl_nxt),
                                   /*AUTOINST*/
				       // Outputs
				       .q(ctu_misc_cken_pre_jl), // Templated
				       // Inputs
				       .clk(cmp_clk),		 // Templated
				       .set_l(io_pwron_rst_l));	 // Templated


   /* dffrle_ns AUTO_TEMPLATE (
       .din(clsp_ctrl_srarm_cl),
       .q (clsp_ctrl_srarm_pre_jl),
       .en(jbus_tx_sync),
       .rst_l(start_clk_cl),
       .clk (cmp_clk),
    );
  */

     dffrle_ns u_clsp_ctrl_srarm_pre_jl( .rst_l	(start_clk_cl), /*AUTOINST*/
					// Outputs
					.q(clsp_ctrl_srarm_pre_jl), // Templated
					// Inputs
					.din(clsp_ctrl_srarm_cl), // Templated
					.en(jbus_tx_sync),	 // Templated
					.clk(cmp_clk));		 // Templated

endmodule // ctu_clsp_jl_cl


// Local Variables:
// verilog-library-directories:("." "../common/rtl")
// verilog-library-files:("../common/rtl/ctu_lib.v" "../../common/rtl/swrvr_clib.v")
// verilog-auto-sense-defines-constant:t
// End:








