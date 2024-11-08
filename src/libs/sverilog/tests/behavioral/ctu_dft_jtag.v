// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_dft_jtag.v
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
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////
`include "sys.h"
`include "ctu.h"

module ctu_dft_jtag (/*AUTOARG*/
// Outputs
dft_tdo, io_tdo_en, jtag_creg_addr, jtag_creg_data, jtag_creg_rd_en, 
jtag_creg_wr_en, jtag_creg_addr_en, jtag_creg_data_en, 
jtag_creg_rdrtrn_complete, jtag_bist_serial, jtag_bist_parallel, 
jtag_bist_active, jtag_bist_abort, dft_pll_div2, dft_pll_arst_l, 
dft_pll_testmode, dft_pll_clamp_fltr, jtag_clsp_stop_id_vld, 
jtag_clsp_stop_id, jtag_nstep_vld, jtag_nstep_domain, 
jtag_nstep_count, dft_clsp_nstep_capture_l, jtag_clock_dr, 
jtag_clsp_ignore_wrm_rst, jtag_clsp_sel_tck2, 
jtag_clsp_force_cken_cmp, jtag_clsp_force_cken_dram, 
jtag_clsp_force_cken_jbus, pll_bypass, ctu_sel_cpu, ctu_sel_dram, 
ctu_sel_jbus, ctu_spc0_sscan_se, ctu_spc1_sscan_se, 
ctu_spc2_sscan_se, ctu_spc3_sscan_se, ctu_spc4_sscan_se, 
ctu_spc5_sscan_se, ctu_spc6_sscan_se, ctu_spc7_sscan_se, 
ctu_spc0_tck, ctu_spc1_tck, ctu_spc2_tck, ctu_spc3_tck, ctu_spc4_tck, 
ctu_spc5_tck, ctu_spc6_tck, ctu_spc7_tck, ctu_spc_sscan_tid, 
ctu_pads_sscan_update, ctu_global_snap, ctu_ddr0_mode_ctl, 
ctu_ddr0_hiz_l, ctu_ddr0_update_dr, ctu_ddr0_clock_dr, 
ctu_ddr0_shift_dr, ctu_ddr1_mode_ctl, ctu_ddr1_hiz_l, 
ctu_ddr1_update_dr, ctu_ddr1_clock_dr, ctu_ddr1_shift_dr, 
ctu_ddr2_mode_ctl, ctu_ddr2_hiz_l, ctu_ddr2_update_dr, 
ctu_ddr2_clock_dr, ctu_ddr2_shift_dr, ctu_ddr3_mode_ctl, 
ctu_ddr3_hiz_l, ctu_ddr3_update_dr, ctu_ddr3_clock_dr, 
ctu_ddr3_shift_dr, ctu_jbusl_mode_ctl, ctu_jbusl_hiz_l, 
ctu_jbusl_update_dr, ctu_jbusl_clock_dr, ctu_jbusl_shift_dr, 
ctu_jbusr_mode_ctl, ctu_jbusr_hiz_l, ctu_jbusr_update_dr, 
ctu_jbusr_clock_dr, ctu_jbusr_shift_dr, ctu_debug_mode_ctl, 
ctu_debug_hiz_l, ctu_debug_update_dr, ctu_debug_clock_dr, 
ctu_debug_shift_dr, ctu_misc_mode_ctl, ctu_misc_hiz_l, 
ctu_misc_update_dr, ctu_misc_clock_dr, ctu_misc_shift_dr, 
ctu_pads_bso, global_shift_enable, global_scan_bypass_en, 
dft_ctu_scan_disable, dft_pin_pscan_l, ctu_pads_so, ctu_fpu_so, 
pscan_select, ctu_ddr_testmode_l, ctu_tst_scanmode, 
ctu_tst_macrotest, ctu_tst_short_chain, ctu_tst_scan_disable, 
ctu_efc_data_in, ctu_efc_updatedr, ctu_efc_shiftdr, 
ctu_efc_capturedr, ctu_efc_tck, ctu_efc_rowaddr, ctu_efc_coladdr, 
ctu_efc_read_en, ctu_efc_read_mode, ctu_efc_fuse_bypass, 
ctu_efc_dest_sample, dft_rng_vctrl, dft_rng_rst_l, dft_tsr_div, 
dft_tsr_tsel, dft_tsr_reset_l, testmode_l, 
// Inputs
jbus_rst_l, io_tdi, io_tms, io_trst_l, io_tck, tck_l, jtag_id, 
test_mode_pin, afi_rng_ctl, afi_tsr_div, afi_tsr_mode, 
afi_pll_char_mode, afi_pll_div2, afi_pll_trst_l, afi_tsr_tsel, 
afi_pll_clamp_fltr, creg_jtag_scratch_data, creg_jtag_rdrtrn_data, 
creg_jtag_rdrtrn_vld, bist_jtag_result, bist_jtag_abort_done, 
pll_bypass_pin, pll_reset_ref_l, spc0_ctu_sscan_out, 
spc1_ctu_sscan_out, spc2_ctu_sscan_out, spc3_ctu_sscan_out, 
spc4_ctu_sscan_out, spc5_ctu_sscan_out, spc6_ctu_sscan_out, 
spc7_ctu_sscan_out, pads_ctu_bsi, pads_ctu_si, 
sctag2_ctu_serial_scan_in, efc_ctu_data_out
);

//global interface
input 	      jbus_rst_l;

//JTAG chip interface
input 	  io_tdi;
input 	  io_tms;
input 	  io_trst_l;
input 	  io_tck;
input 	  tck_l;
output 	  dft_tdo; //io_tdo;
output 	  io_tdo_en;

// id info
input [3:0] jtag_id;

// test_mode pins
input 	      test_mode_pin;
//input 	      pscan_mode_pin;
//input 	      shift_en_pin;
input [2:0]   afi_rng_ctl;
input [9:1]   afi_tsr_div;
input 	      afi_tsr_mode;
input 	      afi_pll_char_mode;
input [5:0]   afi_pll_div2;
input 	      afi_pll_trst_l;
input [7:0]   afi_tsr_tsel;
input 	      afi_pll_clamp_fltr;

//creg R/W interface
output [39:0] jtag_creg_addr;  //address of internal register
output [63:0] jtag_creg_data;     //data to load into internal register
output 	      jtag_creg_rd_en;
output 	      jtag_creg_wr_en;
output 	      jtag_creg_addr_en;
output 	      jtag_creg_data_en;

input [63:0]  creg_jtag_scratch_data;

input [63:0]  creg_jtag_rdrtrn_data;
input 	      creg_jtag_rdrtrn_vld;
output 	      jtag_creg_rdrtrn_complete;

// bist blk interface
//input 	      bist_jtag_busy;
input [(`CTU_BIST_CNT*2)-1:0] bist_jtag_result;
input 			      bist_jtag_abort_done;
output 			      jtag_bist_serial;
output 			      jtag_bist_parallel;
output [`CTU_BIST_CNT-1:0]    jtag_bist_active;
output 			      jtag_bist_abort;

// PLL and clock
input 	      pll_bypass_pin;
input 	      pll_reset_ref_l;
output [5:0]  dft_pll_div2;
output 	      dft_pll_arst_l;
output 	      dft_pll_testmode;
output 	      dft_pll_clamp_fltr;

output 	      jtag_clsp_stop_id_vld;
output [5:0]  jtag_clsp_stop_id;
output 	      jtag_nstep_vld;
output [2:0]  jtag_nstep_domain;
output [3:0]  jtag_nstep_count;
output 	      dft_clsp_nstep_capture_l;
output 	      jtag_clock_dr;
output 	      jtag_clsp_ignore_wrm_rst;
output 	      jtag_clsp_sel_tck2;
//output 	      jtag_clsp_force_cken;
output 	      jtag_clsp_force_cken_cmp;
output 	      jtag_clsp_force_cken_dram;
output 	      jtag_clsp_force_cken_jbus;

//control interface
output 	      pll_bypass;
output [2:0]  ctu_sel_cpu;
output [2:0]  ctu_sel_dram;
output [2:0]  ctu_sel_jbus;

// shadow scan interface
input 	      spc0_ctu_sscan_out;
input 	      spc1_ctu_sscan_out;
input 	      spc2_ctu_sscan_out;
input 	      spc3_ctu_sscan_out;
input 	      spc4_ctu_sscan_out;
input 	      spc5_ctu_sscan_out;
input 	      spc6_ctu_sscan_out;
input 	      spc7_ctu_sscan_out;
output 	      ctu_spc0_sscan_se;
output 	      ctu_spc1_sscan_se;
output 	      ctu_spc2_sscan_se;
output 	      ctu_spc3_sscan_se;
output 	      ctu_spc4_sscan_se;
output 	      ctu_spc5_sscan_se;
output 	      ctu_spc6_sscan_se;
output 	      ctu_spc7_sscan_se;
output 	      ctu_spc0_tck;
output 	      ctu_spc1_tck;
output 	      ctu_spc2_tck;
output 	      ctu_spc3_tck;
output 	      ctu_spc4_tck;
output 	      ctu_spc5_tck;
output 	      ctu_spc6_tck;
output 	      ctu_spc7_tck;
output [3:0]  ctu_spc_sscan_tid;
output 	      ctu_pads_sscan_update;
output 	      ctu_global_snap;

// Boundary Scan
output 	      ctu_ddr0_mode_ctl;
output 	      ctu_ddr0_hiz_l;
output 	      ctu_ddr0_update_dr;
output 	      ctu_ddr0_clock_dr;
output 	      ctu_ddr0_shift_dr;

output 	      ctu_ddr1_mode_ctl;
output 	      ctu_ddr1_hiz_l;
output 	      ctu_ddr1_update_dr;
output 	      ctu_ddr1_clock_dr;
output 	      ctu_ddr1_shift_dr;

output 	      ctu_ddr2_mode_ctl;
output 	      ctu_ddr2_hiz_l;
output 	      ctu_ddr2_update_dr;
output 	      ctu_ddr2_clock_dr;
output 	      ctu_ddr2_shift_dr;

output 	      ctu_ddr3_mode_ctl;
output 	      ctu_ddr3_hiz_l;
output 	      ctu_ddr3_update_dr;
output 	      ctu_ddr3_clock_dr;
output 	      ctu_ddr3_shift_dr;

output 	      ctu_jbusl_mode_ctl;
output 	      ctu_jbusl_hiz_l;
output 	      ctu_jbusl_update_dr;
output 	      ctu_jbusl_clock_dr;
output 	      ctu_jbusl_shift_dr;

output 	      ctu_jbusr_mode_ctl;
output 	      ctu_jbusr_hiz_l;
output 	      ctu_jbusr_update_dr;
output 	      ctu_jbusr_clock_dr;
output 	      ctu_jbusr_shift_dr;

output 	      ctu_debug_mode_ctl;
output 	      ctu_debug_hiz_l;
output 	      ctu_debug_update_dr;
output 	      ctu_debug_clock_dr;
output 	      ctu_debug_shift_dr;

output 	      ctu_misc_mode_ctl;
output 	      ctu_misc_hiz_l;
output 	      ctu_misc_update_dr;
output 	      ctu_misc_clock_dr;
output 	      ctu_misc_shift_dr;

output 	      ctu_pads_bso;
input 	      pads_ctu_bsi;

//scan signals
input 	      pads_ctu_si;
input 	      sctag2_ctu_serial_scan_in;
output 	      global_shift_enable;
output 	      global_scan_bypass_en;
output 	      dft_ctu_scan_disable;  //disable ctu cluster scan if not pin-based scan
output 	      dft_pin_pscan_l;       // select long chain is pin-based scan
output 	      ctu_pads_so;
output 	      ctu_fpu_so;

//pad connection for scan
output 	      pscan_select;

// ctu and pad share scan chain
output 	      ctu_ddr_testmode_l;

//cluster scanin
output        ctu_tst_scanmode;
output 	      ctu_tst_macrotest;
output 	      ctu_tst_short_chain;
output 	      ctu_tst_scan_disable;

// efuse shift interface (tck domain)
input 	      efc_ctu_data_out; // Serial(scan) out from ctu
output 	      ctu_efc_data_in;  // Serial(scan) in to efc
output 	      ctu_efc_updatedr;
output 	      ctu_efc_shiftdr;
output 	      ctu_efc_capturedr;
output 	      ctu_efc_tck;

// efuse r/w interface
output [6:0]  ctu_efc_rowaddr;
output [4:0]  ctu_efc_coladdr;
output 	      ctu_efc_read_en;
output [2:0]  ctu_efc_read_mode;
output 	      ctu_efc_fuse_bypass;

// efuse dest sample
output 	      ctu_efc_dest_sample;

// random number generator
output [2:0]  dft_rng_vctrl;
output 	      dft_rng_rst_l;

// temperature sensor regulator
output [9:1]  dft_tsr_div;
output [7:0]  dft_tsr_tsel;
output 	      dft_tsr_reset_l;

// CTU Internal scan
output 	      testmode_l;

////////////////////////////////////////////////////////////////////////
// Interface signal type declarations
////////////////////////////////////////////////////////////////////////
reg [2:0]     dft_rng_vctrl;
reg 	      dft_rng_rst_l;
reg [9:1]     dft_tsr_div;
reg [7:0]     dft_tsr_tsel;
reg 	      dft_tsr_reset_l;
reg [5:0]     dft_pll_div2;
reg 	      dft_pll_arst_l;
reg 	      dft_pll_clamp_fltr;
reg 	      ctu_pads_bso;
reg 	      ctu_fpu_so;
reg [3:0]     ctu_spc_sscan_tid;

////////////////////////////////////////////////////////////////////////
// Local signal declarations 
////////////////////////////////////////////////////////////////////////

parameter TAP_CMD_LO    = 0,
	  TAP_CMD_HI    = `TAP_CMD_WIDTH - 1,
	  TAP_SSCAN_CFG_WIDTH = 8,
	  TAP_SSCAN_CFG_LO    = TAP_CMD_HI + 1,
	  TAP_SSCAN_CFG_HI    = TAP_SSCAN_CFG_LO + TAP_SSCAN_CFG_WIDTH - 1,
	  TAP_SSCAN_UPDATE    = TAP_SSCAN_CFG_HI + 1,
	  TAP_MBIST_ACTIVE_WIDTH = `CTU_BIST_CNT,
	  TAP_MBIST_ACTIVE_LO    = TAP_CMD_HI + 1,
	  TAP_MBIST_ACTIVE_HI    = TAP_MBIST_ACTIVE_LO + TAP_MBIST_ACTIVE_WIDTH - 1,
	  TAP_CLK_STOP_ID_WIDTH  = 6,
	  TAP_CLK_STOP_ID_LO     = TAP_CMD_HI + 1,
	  TAP_CLK_STOP_ID_HI     = TAP_CLK_STOP_ID_LO + TAP_CLK_STOP_ID_WIDTH - 1,
	  TAP_SUPPRESS_CAP_BIT   = TAP_CMD_HI + 1,
	  TAP_CKEN_BIT           = TAP_CMD_HI + 2,
	  TAP_SCAN_MODE_BIT      = TAP_CMD_HI + 1,
	  TAP_SCAN_NSTEP_DOM_WIDTH = 3,
	  TAP_SCAN_NSTEP_CNT_WIDTH = 4,
	  TAP_SCAN_NSTEP_DOM_LO    = TAP_CMD_HI + 1,
	  TAP_SCAN_NSTEP_DOM_HI    = TAP_SCAN_NSTEP_DOM_LO + TAP_SCAN_NSTEP_DOM_WIDTH - 1,
	  TAP_SCAN_NSTEP_CNT_LO    = TAP_SCAN_NSTEP_DOM_HI + 1,
	  TAP_SCAN_NSTEP_CNT_HI    = TAP_SCAN_NSTEP_CNT_LO + TAP_SCAN_NSTEP_CNT_WIDTH - 1,
	  TAP_SCAN_CLK_SEL_WIDTH   = 3,
	  TAP_SCAN_CLK_SEL_CPU_LO  = TAP_CMD_HI + 1,
	  TAP_SCAN_CLK_SEL_CPU_HI  = TAP_SCAN_CLK_SEL_CPU_LO + TAP_SCAN_CLK_SEL_WIDTH - 1,
	  TAP_SCAN_CLK_SEL_DRAM_LO = TAP_SCAN_CLK_SEL_CPU_HI + 1,
	  TAP_SCAN_CLK_SEL_DRAM_HI = TAP_SCAN_CLK_SEL_DRAM_LO + TAP_SCAN_CLK_SEL_WIDTH - 1,
	  TAP_SCAN_CLK_SEL_JBUS_LO = TAP_SCAN_CLK_SEL_DRAM_HI + 1,
	  TAP_SCAN_CLK_SEL_JBUS_HI = TAP_SCAN_CLK_SEL_JBUS_LO + TAP_SCAN_CLK_SEL_WIDTH - 1;

parameter TAP_SCAN_MODE_PARALLEL = 1'b1,
	  TAP_SCAN_MODE_SERIAL   = 1'b0;

parameter JTAG_SDR_CNT_WIDTH  = 4,
	  JTAG_CKEN_DRAM_WAIT = 4'd6,
  	  JTAG_CKEN_JBUS_WAIT = 4'd6,
	  JTAG_CKEN_OTHER_WAIT = 4'd8;

wire [31:0] idcode;
wire [39:0] creg_addr;
wire [63:0] creg_wdata;
wire [64:0] creg_rdrtrn;
wire [63:0] scratch_reg;
wire 	    instr_normal_scan;
wire 	    instr_scan;
wire 	    global_shift_enable_pre;
wire 	    pscan_select_pre;
wire 	    shadow_scan_instr;
wire [TAP_SSCAN_CFG_WIDTH-1:0] shadow_scan_config_reg;
wire [3:0] 		       spc_sscan_tid;
wire 			       suppress_capture_l;
wire 			       pll_bypass_tap;
wire 			       spc0_sscan_se_pre;
wire 			       spc1_sscan_se_pre;
wire 			       spc2_sscan_se_pre;
wire 			       spc3_sscan_se_pre;
wire 			       spc4_sscan_se_pre;
wire 			       spc5_sscan_se_pre;
wire 			       spc6_sscan_se_pre;
wire 			       spc7_sscan_se_pre;
wire 			       spc0_tck_pre;
wire 			       spc1_tck_pre;
wire 			       spc2_tck_pre;
wire 			       spc3_tck_pre;
wire 			       spc4_tck_pre;
wire 			       spc5_tck_pre;
wire 			       spc6_tck_pre;
wire 			       spc7_tck_pre;
wire 			       bscan_enable;
wire 			       ddr0_clock_dr_pre;
wire 			       ddr0_shift_dr_pre;
wire 			       ddr1_clock_dr_pre;
wire 			       ddr1_shift_dr_pre;
wire 			       ddr2_clock_dr_pre;
wire 			       ddr2_shift_dr_pre;
wire 			       ddr3_clock_dr_pre;
wire 			       ddr3_shift_dr_pre;
wire 			       jbusl_clock_dr_pre;
wire 			       jbusl_shift_dr_pre;
wire 			       jbusr_clock_dr_pre;
wire 			       jbusr_shift_dr_pre;
wire 			       debug_clock_dr_pre;
wire 			       debug_shift_dr_pre;
wire 			       misc_clock_dr_pre;
wire 			       misc_shift_dr_pre;
wire [6:0] 		       efc_rowaddr;
wire [4:0] 		       efc_coladdr;
wire [2:0] 		       efc_read_mode;
wire 			       efc_tck_pre;
wire [JTAG_SDR_CNT_WIDTH-1:0]  scan_dump_shiftdr_cnt;
wire [JTAG_SDR_CNT_WIDTH-1:0]  cken_dram_wait;
wire [JTAG_SDR_CNT_WIDTH-1:0]  cken_jbus_wait;
wire [JTAG_SDR_CNT_WIDTH-1:0]  cken_other_wait;
wire 			       sel_tck2_pre;
wire 			       nstep_mode;
reg [31:0] 		       next_idcode;
reg [39:0] 		       next_creg_addr;
reg [63:0] 		       next_creg_wdata;
reg [64:0] 		       next_creg_rdrtrn;
reg [63:0] 		       next_scratch_reg;
wire 			       next_instr_normal_scan;
wire 			       next_instr_scan;
wire 			       next_global_shift_enable_pre;
wire 			       next_pscan_select_pre;
wire 			       next_shadow_scan_instr;
wire [3:0] 		       next_spc_sscan_tid;
reg [TAP_SSCAN_CFG_WIDTH-1:0]  next_shadow_scan_config_reg;
wire 			       next_pll_bypass_tap;
wire 			       next_spc0_tck_pre;
wire 			       next_spc1_tck_pre;
wire 			       next_spc2_tck_pre;
wire 			       next_spc3_tck_pre;
wire 			       next_spc4_tck_pre;
wire 			       next_spc5_tck_pre;
wire 			       next_spc6_tck_pre;
wire 			       next_spc7_tck_pre;
wire 			       next_spc0_sscan_se_pre;
wire 			       next_spc1_sscan_se_pre;
wire 			       next_spc2_sscan_se_pre;
wire 			       next_spc3_sscan_se_pre;
wire 			       next_spc4_sscan_se_pre;
wire 			       next_spc5_sscan_se_pre;
wire 			       next_spc6_sscan_se_pre;
wire 			       next_spc7_sscan_se_pre;
wire 			       next_bscan_enable;
wire 			       next_ddr0_clock_dr_pre;
wire 			       next_ddr0_shift_dr_pre;
wire 			       next_ddr1_clock_dr_pre;
wire 			       next_ddr1_shift_dr_pre;
wire 			       next_ddr2_clock_dr_pre;
wire 			       next_ddr2_shift_dr_pre;
wire 			       next_ddr3_clock_dr_pre;
wire 			       next_ddr3_shift_dr_pre;
wire 			       next_jbusl_clock_dr_pre;
wire 			       next_jbusl_shift_dr_pre;
wire 			       next_jbusr_clock_dr_pre;
wire 			       next_jbusr_shift_dr_pre;
wire 			       next_debug_clock_dr_pre;
wire 			       next_debug_shift_dr_pre;
wire 			       next_misc_clock_dr_pre;
wire 			       next_misc_shift_dr_pre;
wire 			       next_suppress_capture_l;
reg [6:0] 		       next_efc_rowaddr;
reg [4:0] 		       next_efc_coladdr;
reg [2:0] 		       next_efc_read_mode;
wire 			       next_efc_tck_pre;
reg 			       next_nstep_mode;
reg [JTAG_SDR_CNT_WIDTH-1:0]   next_scan_dump_shiftdr_cnt;
wire [JTAG_SDR_CNT_WIDTH-1:0]  next_cken_dram_wait;
wire [JTAG_SDR_CNT_WIDTH-1:0]  next_cken_jbus_wait;
wire [JTAG_SDR_CNT_WIDTH-1:0]  next_cken_other_wait;
wire 			       next_sel_tck2_pre;

wire 			       creg_addr_shift;
wire 			       creg_wdata_shift;

wire 			       shadow_scan_config_reg_en;
reg [TAP_SSCAN_CFG_WIDTH-1:0]  shadow_scan_config_mask;
reg 			       shadow_scan_out;

wire 			       pin_based_pscan_mode;
wire 			       pin_based_shift_en;
wire 			       pin_based_pll_bypass;
wire 			       tap_rst_l;

wire 	      tap_so;
wire 	      tap_tdo_en;
wire 	      tap_bypass_sel;
wire 	      tap_clock_dr;
wire [`TAP_INSTR_WIDTH-1:0]   tap_instructions;
wire [`TAP_INSTR_WIDTH-1:0]   next_tap_instructions;
wire 	      scratch_en_shift_dr;
wire 	      scratch_reg_load;
wire 	      instr_bypass;
wire 	      instr_idcode;
wire 	      instr_highz;
wire 	      instr_clamp;
wire 	      next_instr_highz;
wire 	      next_instr_clamp;
wire 	      next_instr_extest;
wire 	      next_instr_sample_preload;	      
wire 	      instr_creg_addr;
wire 	      instr_creg_wdata;
wire 	      instr_creg_rdata;
wire 	      instr_creg_scratch;
wire 	      instr_iob_wr;
wire 	      instr_iob_rd;
wire 	      instr_iob_rd_d1;
wire 	      instr_iob_waddr;
wire 	      instr_iob_wdata;
wire 	      instr_iob_raddr;
wire 	      instr_iob_raddr_d1;
wire 	      instr_scan_parallel;
wire 	      instr_scan_serial;
wire 	      instr_scan_dump;
wire 	      instr_scan_mtest;
wire 	      next_instr_scan_parallel;
wire 	      next_instr_scan_serial;
wire 	      next_instr_scan_dump;
wire 	      next_instr_scan_mtest_long;
wire 	      next_instr_scan_mtest_short;
wire 	      next_instr_scan_mtest;
wire 	      next_instr_sscan_t0;
wire 	      next_instr_sscan_t1;
wire 	      next_instr_sscan_t2;
wire 	      next_instr_sscan_t3;
wire 	      instr_scan_bypass_en;
wire 	      instr_scan_nstep;
wire 	      instr_mbist_serial;
wire 	      instr_mbist_parallel;
wire 	      instr_mbist_result;
wire 	      instr_mbist_abort;
wire 	      next_instr_efc_read;
wire 	      next_instr_efc_bypass_data;
wire 	      next_instr_efc_bypass;
wire 	      instr_efc_read;
wire 	      instr_efc_bypass_data;
wire 	      instr_efc_read_mode;
wire 	      instr_efc_col_addr;
wire 	      instr_efc_row_addr;
wire 	      instr_efc_dest_sample;
wire 	      instr_pll_bypass;
wire 	      instr_clk_stop_id;
wire 	      instr_clk_sel;
wire 	      instr_efc_shift;

wire 	      tap_capture_dr_state;
wire 	      tap_shift_dr_state;
wire 	      tap_shift_dr_state_d1;
wire 	      tap_pause_dr_state;
wire 	      tap_update_dr_state;
wire 	      tap_shift_exit2_dr_state;
wire 	      tap_update_ir_state;

wire 	      creg_addr_instr;
wire 	      creg_data_instr;

wire 	      bist_result_reg_load;
wire 	      bist_result_reg_shift;
wire [(`CTU_BIST_CNT*2)-1:0] bist_result_reg;
reg [(`CTU_BIST_CNT*2)-1:0]  next_bist_result_reg;

wire 	      toggle_pll_bypass_tap;

wire 	      creg_rdrtrn_shift;
wire 	      clear_creg_rdrtrn_vld;
wire 	      creg_rdrtrn_vld;
wire 	      next_creg_rdrtrn_vld;
wire 	      creg_rdrtrn_out;
wire 	      creg_rdrtrn_load;
wire 	      creg_rdrtrn_load_d1;
wire 	      creg_jtag_rdrtrn_vld_d;
wire 	      creg_jtag_rdrtrn_vld_d2;
wire 	      clock_dr_instr_scan_dump_capture;
wire [TAP_SCAN_CLK_SEL_WIDTH-1:0]    clk_sel_cpu;
wire [TAP_SCAN_CLK_SEL_WIDTH-1:0]    clk_sel_dram;
wire [TAP_SCAN_CLK_SEL_WIDTH-1:0]    clk_sel_jbus;
wire [2:0]    sel_cpu;
wire [2:0]    sel_dram;
wire [2:0]    sel_jbus;
wire [2:0]    sel_cpu_ff;
wire [2:0]    sel_dram_ff;
wire [2:0]    sel_jbus_ff;
reg [2:0]     next_sel_cpu_ff;
reg [2:0]     next_sel_dram_ff;
reg [2:0]     next_sel_jbus_ff;

wire 	      next_jtag_bist_serial;
wire 	      next_jtag_bist_parallel;
reg [TAP_MBIST_ACTIVE_WIDTH-1:0] next_jtag_bist_active;


wire 	      efc_rowaddr_shift;
wire 	      efc_coladdr_shift;
wire 	      efc_read_mode_shift;

wire 	      next_global_scan_bypass_en;

wire 	      bscan_mode_ctl;
wire 	      bscan_hiz_l;
wire 	      bscan_update_dr;
wire 	      bscan_clock_dr_pre;
wire 	      bscan_shift_dr_pre;
wire 	      next_ctu_ddr0_mode_ctl;
wire 	      next_ctu_ddr0_hiz_l;
wire 	      next_ctu_ddr0_update_dr;
wire 	      next_ctu_ddr1_mode_ctl;
wire 	      next_ctu_ddr1_hiz_l;
wire 	      next_ctu_ddr1_update_dr;
wire 	      next_ctu_ddr2_mode_ctl;
wire 	      next_ctu_ddr2_hiz_l;
wire 	      next_ctu_ddr2_update_dr;
wire 	      next_ctu_ddr3_mode_ctl;
wire 	      next_ctu_ddr3_hiz_l;
wire 	      next_ctu_ddr3_update_dr;
wire 	      next_ctu_jbusl_mode_ctl;
wire 	      next_ctu_jbusl_hiz_l;
wire 	      next_ctu_jbusl_update_dr;
wire 	      next_ctu_jbusr_mode_ctl;
wire 	      next_ctu_jbusr_hiz_l;
wire 	      next_ctu_jbusr_update_dr;
wire 	      next_ctu_debug_mode_ctl;
wire 	      next_ctu_debug_hiz_l;
wire 	      next_ctu_debug_update_dr;
wire 	      next_ctu_misc_mode_ctl;
wire 	      next_ctu_misc_hiz_l;
wire 	      next_ctu_misc_update_dr;

wire 	      pll_bypass;
wire 	      dft_pin_pscan;

wire 	      next_ctu_global_snap;
wire 	      next_ctu_tst_macrotest;
wire 	      next_ctu_tst_short_chain;
wire 	      next_ctu_pads_sscan_update;
wire 	      next_spc0_sscan;
wire 	      next_spc1_sscan;
wire 	      next_spc2_sscan;
wire 	      next_spc3_sscan;
wire 	      next_spc4_sscan;
wire 	      next_spc5_sscan;
wire 	      next_spc6_sscan;
wire 	      next_spc7_sscan;
wire 	      next_pads_sscan;
wire 	      next_pads_sscan_se_pre;
wire 	      next_pads_tck_pre;
wire 	      next_ctu_efc_capturedr;
wire 	      next_ctu_efc_shiftdr;
wire 	      next_ctu_efc_updatedr;
wire 	      next_ctu_efc_fuse_bypass;
wire 	      next_ctu_efc_read_en;
wire 	      next_ctu_efc_dest_sample;
wire [6:0]    next_ctu_efc_rowaddr;
wire [4:0]    next_ctu_efc_coladdr;
wire [2:0]    next_ctu_efc_read_mode;
wire 	      next_jtag_bist_abort;
wire 	      next_jtag_creg_addr_en;
wire 	      next_jtag_creg_wr_en;
wire 	      next_jtag_creg_rd_en;
wire 	      next_jtag_creg_data_en;

wire 	      next_dft_clsp_nstep_capture_l;
wire 	      next_jtag_clsp_force_cken_cmp;
wire 	      next_jtag_clsp_force_cken_dram;
wire 	      next_jtag_clsp_force_cken_jbus;

wire 	      tap_update_ir_state_d1;
wire 	      tap_update_ir_state_d2;

wire 	      scan_dump_cken_cmp;
wire 	      scan_dump_cken_dram;
wire 	      scan_dump_cken_jbus;
wire 	      scan_dump_cken_other;
wire 	      normal_force_cken;
wire 	      inc_scan_dump_shiftdr_cnt;

wire 	      test_mode_pin_l;
wire 	      trst;

wire 	      global_scan_bypass_en_pre;  // bug #5483
wire 	      bypass_chain31;             // bug #5581
reg 	      pads_ctu_si_bypmux_out;     // bug #5581
wire 	      serial_scan;                // bug #5695
wire 	      pads_ctu_si_bypmux_out_ff;  // bug #5696

//********************************************************************
// Pin-based operations
//********************************************************************

// use io_trst_l pin as pscan_mode_pin_l ans io_tms as shift_en_pin 
// when test_mode_pin is asserted

//assign tap_rst_l = test_mode_pin | io_trst_l;
ctu_or2 u_or2_tap_rst_l (.a (test_mode_pin),
			 .b (io_trst_l),
			 .z (tap_rst_l)
			 );

//assign pin_based_pscan_mode = test_mode_pin & ~io_trst_l;
ctu_inv u_inv_test_mode_pin_l (.a (test_mode_pin),
			       .z (test_mode_pin_l)
			       );
ctu_nor2 u_nor2_pin_based_pscan_mode (.a(test_mode_pin_l),
				      .b(io_trst_l),
				      .z(pin_based_pscan_mode)
				      );

//assign pin_based_pll_bypass = test_mode_pin & pll_bypass_pin;
ctu_and2 u_and2_pin_based_pll_bypass (.a(test_mode_pin),
				      .b(pll_bypass_pin),
				      .z(pin_based_pll_bypass)
				      );

assign pin_based_shift_en   = test_mode_pin & ~io_trst_l & io_tms;

//********************************************************************
// TAP Controller
//********************************************************************

ctu_dft_jtag_tap u_tap_controller (
				   // Inputs
				   .tck (io_tck),
				   .tck_l (tck_l),
				   .trst_n (tap_rst_l),
				   .tms (io_tms),
				   .tdi (io_tdi),
				   .so (tap_so),
				   .bypass_sel (tap_bypass_sel),
				   .dft_pin_pscan(dft_pin_pscan),

				   // Outputs
				   .capture_dr_state (tap_capture_dr_state),
				   .shift_dr_state (tap_shift_dr_state),
				   .pause_dr_state (tap_pause_dr_state),
				   .update_dr_state (tap_update_dr_state),
				   .shift_exit2_dr_state (tap_shift_exit2_dr_state),
				   .update_ir_state (tap_update_ir_state),
				   .clock_dr  (tap_clock_dr),
				   .tdo (dft_tdo),
				   .tdo_en (tap_tdo_en),
				   .instructions (tap_instructions),
				   .next_instructions (next_tap_instructions)
				   );
   
				   

//instruction decode
assign instr_bypass           = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == {`TAP_CMD_WIDTH{1'b1}}
                                | (tap_instructions[TAP_CMD_HI:TAP_CMD_HI-3] == 4'b0001   // 0x05 thru 0x07
				   & (|tap_instructions[TAP_CMD_HI-4:TAP_CMD_LO]))
                                | (tap_instructions[TAP_CMD_HI:TAP_CMD_HI-3] == 4'b0100   // 0x11 thru 0x13
				   & (|tap_instructions[TAP_CMD_HI-4:TAP_CMD_LO]))
				| tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == 6'h19
				| tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == 6'h27
                                | tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == 6'h2F
                                | tap_instructions[TAP_CMD_HI:TAP_CMD_HI-1] == 2'd3;
assign instr_idcode           = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_IDCODE;
assign instr_highz            = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_HIGHZ;
assign instr_clamp            = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_CLAMP;
assign next_instr_highz            = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_HIGHZ;
assign next_instr_clamp            = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_CLAMP;
assign next_instr_extest           = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EXTEST;
assign next_instr_sample_preload   = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SAMPLE_PRELOAD;

assign instr_creg_addr        = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_CREG_ADDR;
assign instr_creg_wdata       = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_CREG_WDATA;
assign instr_creg_rdata       = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_CREG_RDATA;
assign instr_creg_scratch     = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_CREG_SCRATCH;
assign instr_iob_wr           = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_IOB_WR;
assign instr_iob_rd           = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_IOB_RD;
assign instr_iob_waddr        = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_IOB_WADDR;
assign instr_iob_wdata        = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_IOB_WDATA;
assign instr_iob_raddr        = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_IOB_RADDR;

assign instr_scan_parallel     = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_PARALLEL;
assign instr_scan_serial       = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_SERIAL;
assign instr_scan_dump         = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_DUMP;
assign next_instr_scan_parallel     = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_PARALLEL;
assign next_instr_scan_serial       = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_SERIAL;
assign next_instr_scan_mtest_long   = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_MTEST_LONG;
assign next_instr_scan_mtest_short  = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_MTEST_SHORT;
assign next_instr_scan_dump         = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_DUMP;

assign next_instr_sscan_t0    = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SSCAN_T0;
assign next_instr_sscan_t1    = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SSCAN_T1;
assign next_instr_sscan_t2    = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SSCAN_T2;
assign next_instr_sscan_t3    = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SSCAN_T3;
assign instr_scan_bypass_en   = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_BYPASS_EN;
assign instr_scan_nstep       = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_NSTEP;   

assign instr_mbist_serial     = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_MBIST_SERIAL;
assign instr_mbist_parallel   = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_MBIST_PARALLEL;
assign instr_mbist_result     = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_MBIST_RESULT;  
assign instr_mbist_abort      = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_MBIST_ABORT;   

assign next_instr_efc_read         = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EFC_READ;
assign next_instr_efc_bypass_data  = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EFC_BYPASS_DATA;
assign next_instr_efc_bypass       = next_tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EFC_BYPASS;

assign instr_efc_read         = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EFC_READ;
assign instr_efc_bypass_data  = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EFC_BYPASS_DATA;
assign instr_efc_read_mode    = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EFC_READ_MODE;  
assign instr_efc_col_addr     = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EFC_COL_ADDR;   
assign instr_efc_row_addr     = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EFC_ROW_ADDR;   
assign instr_efc_dest_sample  = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_EFC_DEST_SAMPLE;

assign instr_pll_bypass       = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_PLL_BYPASS;
assign instr_clk_stop_id      = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_CLK_STOP_ID;
assign instr_clk_sel          = tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_CLK_SEL;    

assign instr_scan_mtest =  tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_MTEST_LONG
                         | tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_MTEST_SHORT;
assign next_instr_scan_mtest = next_instr_scan_mtest_long | next_instr_scan_mtest_short;

assign instr_efc_shift =   instr_efc_bypass_data
			 | instr_efc_read;

//tap_bypass_sel generation
assign tap_bypass_sel   = instr_highz  | instr_clamp | instr_bypass;

assign tap_so =   // (idcode[31]                & instr_idcode)
                  (idcode[0]                 & instr_idcode) // bug #5497
                | (pads_ctu_bsi              & bscan_enable)
		| (creg_addr[39]             & instr_creg_addr) 
		| (creg_wdata[63]            & instr_creg_wdata) 
		| (scratch_reg[63]           & instr_creg_scratch)
		| (creg_rdrtrn_out           & instr_creg_rdata) 
		//| (pads_ctu_si               & instr_scan)
                //| (pads_ctu_si_bypmux_out    & instr_scan) // bug # 5581
                | (pads_ctu_si_bypmux_out_ff & instr_scan)  // bug # 5581 & bug #5696
                | (efc_ctu_data_out          & instr_efc_shift)
                | (shadow_scan_out           & shadow_scan_instr)
                | (bist_result_reg[(`CTU_BIST_CNT*2)-1] & instr_mbist_result);

assign io_tdo_en = tap_tdo_en
                  | instr_creg_rdata
                  | dft_pin_pscan;

//********************************************************************
// IDCODE
//********************************************************************

always @ ( /*AUTOSENSE*/idcode or instr_idcode or io_tdi or jtag_id
	  or tap_capture_dr_state or tap_shift_dr_state) begin
   if (instr_idcode & tap_capture_dr_state)
      next_idcode = { jtag_id[3:0], `CTU_PART_ID, `CTU_MANUFACTURE_ID, 1'b1 };
   else begin
      if (instr_idcode & tap_shift_dr_state)
//	 next_idcode = { idcode[30:0], io_tdi };
	 next_idcode = { io_tdi, idcode[31:1] }; // bug #5497
      else
	 next_idcode = idcode[31:0];
   end
end


//********************************************************************
// CREG
//********************************************************************

//-----------------------
// address shift register
//-----------------------
assign creg_addr_instr =   instr_creg_addr 
                         | instr_iob_waddr 
                         | instr_iob_raddr;
assign creg_addr_shift = creg_addr_instr & tap_shift_dr_state;

always @ ( /*AUTOSENSE*/creg_addr or creg_addr_shift or io_tdi) begin
   if (creg_addr_shift)
      next_creg_addr =  { creg_addr[38:0], io_tdi };
   else
      next_creg_addr = creg_addr;
end

assign jtag_creg_addr = creg_addr[39:0];

//-----------------------
// data  shift register
//-----------------------
assign creg_data_instr  = instr_creg_wdata | instr_iob_wdata ;
assign creg_wdata_shift =   creg_data_instr
                          & tap_shift_dr_state;

always @ ( /*AUTOSENSE*/creg_wdata or creg_wdata_shift or io_tdi) begin
   if (creg_wdata_shift)
      next_creg_wdata[63:0] = { creg_wdata[62:0], io_tdi };
   else
      next_creg_wdata[63:0] = creg_wdata[63:0];
end

assign jtag_creg_data = creg_wdata[63:0];

//------------------------------
//generate enables to creg block
//------------------------------
assign next_jtag_creg_addr_en = tap_update_dr_state & creg_addr_instr;
assign next_jtag_creg_wr_en   =  instr_iob_wr
                          | (  tap_update_dr_state 
			     & (  instr_iob_wdata
			        | instr_iob_waddr));
assign next_jtag_creg_rd_en   =   instr_iob_rd
                           | tap_update_dr_state & instr_iob_raddr;
assign next_jtag_creg_data_en = tap_update_dr_state & creg_data_instr;

//---------------------
// Read Return Register
//---------------------

// Handshake with creg
//   - load_l is generated on rising edge on creg_jtag_rdrtrn_vld
//   - load delayed by one provides the output handshake to ctu_creg

assign creg_rdrtrn_load = creg_jtag_rdrtrn_vld & ~creg_jtag_rdrtrn_vld_d2;

assign jtag_creg_rdrtrn_complete =  creg_rdrtrn_load_d1;

// start shifting out read data once it is valid
assign creg_rdrtrn_shift = instr_creg_rdata & tap_shift_dr_state & creg_rdrtrn_vld;

always @ ( /*AUTOSENSE*/creg_jtag_rdrtrn_data or creg_rdrtrn
	  or creg_rdrtrn_load or creg_rdrtrn_shift or io_tdi) begin
   if (creg_rdrtrn_load)
      next_creg_rdrtrn[64:0] = { 1'b1, creg_jtag_rdrtrn_data };
   else begin
      if (creg_rdrtrn_shift)
	 next_creg_rdrtrn[64:0] = { creg_rdrtrn[63:0], io_tdi };
      else
	 next_creg_rdrtrn[64:0] = creg_rdrtrn[64:0];
   end
end

// set when load data into read-return_reg
assign clear_creg_rdrtrn_vld =   (instr_iob_rd    & ~instr_iob_rd_d1)
                               | (instr_iob_raddr & ~instr_iob_raddr_d1);
assign next_creg_rdrtrn_vld =  creg_rdrtrn_load
                             | (creg_rdrtrn_vld & ~clear_creg_rdrtrn_vld);

assign creg_rdrtrn_out = creg_rdrtrn[64] & creg_rdrtrn_vld;

//---------------------
// Scratch Register
//---------------------
assign scratch_en_shift_dr = instr_creg_scratch & tap_shift_dr_state;
assign scratch_reg_load    = instr_creg_scratch & tap_capture_dr_state;

always @ ( /*AUTOSENSE*/creg_jtag_scratch_data or io_tdi
	  or scratch_en_shift_dr or scratch_reg or scratch_reg_load) begin
   if (scratch_reg_load)
      next_scratch_reg[63:0] = creg_jtag_scratch_data;
   else begin
      if (scratch_en_shift_dr)
	 next_scratch_reg[63:0] = { scratch_reg[62:0], io_tdi };
      else
	 next_scratch_reg[63:0] = scratch_reg[63:0];
   end
end


//*******************************************************************
// Internal Scan
// - parallel and serial scan
// - macro test
//********************************************************************

// to test stub
// do precalc for timing
assign next_instr_normal_scan =  next_instr_scan_parallel
                               | next_instr_scan_serial
                               | next_instr_scan_mtest_long
                               | next_instr_scan_mtest_short;
assign next_instr_scan = next_instr_normal_scan | next_instr_scan_dump;

assign next_global_shift_enable_pre =  (  instr_normal_scan
				        | scan_dump_cken_cmp )
				     & (  tap_shift_exit2_dr_state
					| tap_shift_dr_state_d1); //extend shift_en by 1 cycle to ensure deassert after clock_dr (SRAM)
assign global_shift_enable =   (global_shift_enable_pre & ~pin_based_pscan_mode)  
                             | pin_based_shift_en;

assign ctu_tst_scanmode =  instr_scan
                         | pin_based_pscan_mode;  //needs to be asserted during pin base scan

assign next_ctu_tst_macrotest   =  next_instr_scan_mtest_long
                                 | next_instr_scan_mtest_short;
assign next_ctu_tst_short_chain = next_instr_scan_mtest_short;

// Reuse unused ctu_tst_scan_disable  as "short_scan_disable"
assign ctu_tst_scan_disable = pin_based_pscan_mode;

// ctu and pads in same scan chain
assign ctu_ddr_testmode_l = ~ctu_tst_scanmode;

// boundary scan cell
// negedge
assign next_global_scan_bypass_en =  global_scan_bypass_en
                                   ^ (instr_scan_bypass_en & tap_update_ir_state_d1);  //toggle cmd

// bug #5483
assign global_scan_bypass_en =   global_scan_bypass_en_pre  
                               & ~pin_based_shift_en;

// to pad cluster scan multiplexers
assign next_pscan_select_pre =  next_instr_scan_parallel
                              | (  (next_instr_scan_dump | next_instr_scan_mtest)
				 & next_tap_instructions[TAP_SCAN_MODE_BIT] == TAP_SCAN_MODE_PARALLEL);
assign pscan_select = pin_based_pscan_mode | pscan_select_pre;

// si to pad cluster internal scan
assign ctu_pads_so = io_tdi;

assign dft_pin_pscan   =  pin_based_pscan_mode;
assign dft_pin_pscan_l = ~pin_based_pscan_mode;

// for pin-based parallel scan, ctu scan chain is included
assign dft_ctu_scan_disable = ~dft_pin_pscan;

// hookup for short vs. long chain in test stub
// - long chain activated during pin-based parallel scan
// - long chain includes boundary scan and ctu
always @ ( /*AUTOSENSE*/dft_pin_pscan or io_tdi
	  or pads_ctu_si_bypmux_out) begin
   if (dft_pin_pscan)
//      ctu_pads_bso = pads_ctu_si; // feeds pad cluster internal scan so to boudary scan si
      ctu_pads_bso = pads_ctu_si_bypmux_out; // bug #5581
   else
      ctu_pads_bso = io_tdi;
end

// bug #5581
assign bypass_chain31 =   global_scan_bypass_en
			& ~pin_based_shift_en
                        & tap_instructions[8];
always @ ( /*AUTOSENSE*/bypass_chain31 or ctu_fpu_so or pads_ctu_si) begin
   if (bypass_chain31)
      pads_ctu_si_bypmux_out = ctu_fpu_so;
   else
      pads_ctu_si_bypmux_out = pads_ctu_si;
end


// CTU internal testmode_l - really means "pin-based parallel scan mode"
// force on all clock enables
assign testmode_l = ~pin_based_pscan_mode;

assign jtag_clsp_ignore_wrm_rst = instr_scan;

// scan clock to be distributed during internal scan
assign next_suppress_capture_l = ~(tap_capture_dr_state
				   & (next_instr_scan_dump
				      | (next_tap_instructions[TAP_SUPPRESS_CAP_BIT]
					 & ~nstep_mode
					 & (next_instr_scan_parallel | next_instr_scan_serial))));
ctu_and2 u_and2_clock_dr_scan_dump_cap
   ( .a(tap_clock_dr),
     .b(suppress_capture_l),
     .z(clock_dr_instr_scan_dump_capture)
     );
ctu_mux21 u_mux21_jtag_clock_dr
   ( .d0(clock_dr_instr_scan_dump_capture),
     .d1(io_tck),
     .s (pin_based_pscan_mode),
     .z (jtag_clock_dr)
     );
     
//always @ ( /*AUTOSENSE*/ )
//      jtag_clock_dr = io_tck;
//   else
//      jtag_clock_dr = tap_clock_dr & suppress_capture_l;
//end

//********************************************************************
// Boundary Scan
// - because IO shadow scan chanin is part of boundary scan, need
//   to assert some boundary scan signals during IO shadow scan
//   (bscan_clock_dr_out and bscan_shift_dr_out)
// - negedge
//********************************************************************
assign next_bscan_enable =  next_instr_extest
                          | next_instr_sample_preload;

assign bscan_mode_ctl =  next_instr_extest
                       | next_instr_clamp
                       | next_instr_highz;

assign bscan_hiz_l    = ~next_instr_highz;

assign bscan_update_dr = next_bscan_enable & tap_update_dr_state;

assign bscan_clock_dr_pre =  (next_bscan_enable 
			   & (  tap_capture_dr_state 
			      | tap_shift_dr_state))
                              | next_pads_tck_pre;
                            
assign bscan_shift_dr_pre =   (next_bscan_enable & tap_shift_exit2_dr_state)
                             | next_pads_sscan_se_pre;

// to pad_ddr0
assign next_ctu_ddr0_mode_ctl  = bscan_mode_ctl;
assign next_ctu_ddr0_hiz_l     = bscan_hiz_l;
assign next_ctu_ddr0_update_dr = bscan_update_dr;
assign next_ddr0_clock_dr_pre  = bscan_clock_dr_pre;
assign next_ddr0_shift_dr_pre  = bscan_shift_dr_pre;

assign ctu_ddr0_clock_dr = (ddr0_clock_dr_pre | pin_based_pscan_mode) & io_tck;
assign ctu_ddr0_shift_dr =  ddr0_shift_dr_pre | pin_based_shift_en;

// to pad_ddr1
assign next_ctu_ddr1_mode_ctl  = bscan_mode_ctl;
assign next_ctu_ddr1_hiz_l     = bscan_hiz_l;
assign next_ctu_ddr1_update_dr = bscan_update_dr;
assign next_ddr1_clock_dr_pre  = bscan_clock_dr_pre;
assign next_ddr1_shift_dr_pre  = bscan_shift_dr_pre;

assign ctu_ddr1_clock_dr = (ddr1_clock_dr_pre | pin_based_pscan_mode) & io_tck;
assign ctu_ddr1_shift_dr =  ddr1_shift_dr_pre | pin_based_shift_en;

// to pad_ddr2
assign next_ctu_ddr2_mode_ctl  = bscan_mode_ctl;
assign next_ctu_ddr2_hiz_l     = bscan_hiz_l;
assign next_ctu_ddr2_update_dr = bscan_update_dr;
assign next_ddr2_clock_dr_pre  = bscan_clock_dr_pre;
assign next_ddr2_shift_dr_pre  = bscan_shift_dr_pre;

assign ctu_ddr2_clock_dr = (ddr2_clock_dr_pre | pin_based_pscan_mode) & io_tck;
assign ctu_ddr2_shift_dr =  ddr2_shift_dr_pre | pin_based_shift_en;

// to pad_ddr3
assign next_ctu_ddr3_mode_ctl  = bscan_mode_ctl;
assign next_ctu_ddr3_hiz_l     = bscan_hiz_l;
assign next_ctu_ddr3_update_dr = bscan_update_dr;
assign next_ddr3_clock_dr_pre  = bscan_clock_dr_pre;
assign next_ddr3_shift_dr_pre  = bscan_shift_dr_pre;

assign ctu_ddr3_clock_dr = (ddr3_clock_dr_pre | pin_based_pscan_mode) & io_tck;
assign ctu_ddr3_shift_dr =  ddr3_shift_dr_pre | pin_based_shift_en;

// to pad_jbusl
assign next_ctu_jbusl_mode_ctl  = bscan_mode_ctl;
assign next_ctu_jbusl_hiz_l     = bscan_hiz_l;
assign next_ctu_jbusl_update_dr = bscan_update_dr;
assign next_jbusl_clock_dr_pre  = bscan_clock_dr_pre;
assign next_jbusl_shift_dr_pre  = bscan_shift_dr_pre;

assign ctu_jbusl_clock_dr = (jbusl_clock_dr_pre | pin_based_pscan_mode) & io_tck;
assign ctu_jbusl_shift_dr =  jbusl_shift_dr_pre | pin_based_shift_en;

// to pad_jbusr
assign next_ctu_jbusr_mode_ctl  = bscan_mode_ctl;
assign next_ctu_jbusr_hiz_l     = bscan_hiz_l;
assign next_ctu_jbusr_update_dr = bscan_update_dr;
assign next_jbusr_clock_dr_pre  = bscan_clock_dr_pre;
assign next_jbusr_shift_dr_pre  = bscan_shift_dr_pre;

assign ctu_jbusr_clock_dr = (jbusr_clock_dr_pre | pin_based_pscan_mode) & io_tck;
assign ctu_jbusr_shift_dr =  jbusr_shift_dr_pre | pin_based_shift_en;

// to pad_debug
assign next_ctu_debug_mode_ctl  = bscan_mode_ctl;
assign next_ctu_debug_hiz_l     = bscan_hiz_l;
assign next_ctu_debug_update_dr = bscan_update_dr;
assign next_debug_clock_dr_pre  = bscan_clock_dr_pre;
assign next_debug_shift_dr_pre  = bscan_shift_dr_pre;

assign ctu_debug_clock_dr = (debug_clock_dr_pre | pin_based_pscan_mode) & io_tck;
assign ctu_debug_shift_dr =  debug_shift_dr_pre | pin_based_shift_en;

// to pad_misc
assign next_ctu_misc_mode_ctl  = bscan_mode_ctl;
assign next_ctu_misc_hiz_l     = bscan_hiz_l;
assign next_ctu_misc_update_dr = bscan_update_dr;
assign next_misc_clock_dr_pre  = bscan_clock_dr_pre;
assign next_misc_shift_dr_pre  = bscan_shift_dr_pre;

assign ctu_misc_clock_dr = (misc_clock_dr_pre | pin_based_pscan_mode) & io_tck;
assign ctu_misc_shift_dr =  misc_shift_dr_pre | pin_based_shift_en;

//********************************************************************
// Shadow Scan
//********************************************************************

assign next_shadow_scan_instr =  next_instr_sscan_t0
                               | next_instr_sscan_t1
                               | next_instr_sscan_t2
                               | next_instr_sscan_t3;

// Always snap except in capture_dr state when tck toggles once to
// capture
assign next_ctu_global_snap = next_shadow_scan_instr & ~tap_capture_dr_state;

assign next_spc_sscan_tid[3:0] = { next_instr_sscan_t3,
				   next_instr_sscan_t2,
				   next_instr_sscan_t1,
				   ( next_instr_sscan_t0  // always have at least one bit of tid asserted
				   | ~(  next_instr_sscan_t1
				       | next_instr_sscan_t2
				       | next_instr_sscan_t3)) };

// ensure one-hot during scan
always @ ( /*AUTOSENSE*/global_shift_enable or spc_sscan_tid) begin
   if (global_shift_enable)
      ctu_spc_sscan_tid[3:0] = 4'b0001;
   else
      ctu_spc_sscan_tid[3:0] = spc_sscan_tid[3:0];
end


//----------------------------
// Shadow Scan Config Register
//----------------------------
assign shadow_scan_config_reg_en = shadow_scan_instr
                                   & (  tap_update_ir_state 
				      | tap_pause_dr_state);

always @ ( /*AUTOSENSE*/shadow_scan_config_mask
	  or shadow_scan_config_reg or shadow_scan_config_reg_en
	  or tap_instructions or tap_update_ir_state) begin
   if (shadow_scan_config_reg_en) begin
      if (tap_update_ir_state) // new shadow scan instr
	 next_shadow_scan_config_reg = tap_instructions[TAP_SSCAN_CFG_HI:TAP_SSCAN_CFG_LO];
      else 
	 next_shadow_scan_config_reg = shadow_scan_config_reg & shadow_scan_config_mask;
   end
   else
      next_shadow_scan_config_reg = shadow_scan_config_reg;
end

always @ ( /*AUTOSENSE*/shadow_scan_config_reg) begin
   casex (shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:0])
      8'b1???_????: shadow_scan_config_mask = {    1'b0,   {TAP_SSCAN_CFG_WIDTH-1{1'b1}} };
      8'b01??_????: shadow_scan_config_mask = { {2{1'b0}}, {TAP_SSCAN_CFG_WIDTH-2{1'b1}} };
      8'b001?_????: shadow_scan_config_mask = { {3{1'b0}}, {TAP_SSCAN_CFG_WIDTH-3{1'b1}} };
      8'b0001_????: shadow_scan_config_mask = { {4{1'b0}}, {TAP_SSCAN_CFG_WIDTH-4{1'b1}} };
      8'b0000_1???: shadow_scan_config_mask = { {5{1'b0}}, {TAP_SSCAN_CFG_WIDTH-5{1'b1}} };
      8'b0000_01??: shadow_scan_config_mask = { {6{1'b0}}, {TAP_SSCAN_CFG_WIDTH-6{1'b1}} };
      8'b0000_001?: shadow_scan_config_mask = { {7{1'b0}},                        1'b1   };
      default: shadow_scan_config_mask = {TAP_SSCAN_CFG_WIDTH{1'b0}};
   endcase                                  
end

//----------------------------
// shadow scan shift enable
//----------------------------

assign next_spc0_sscan = next_shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1] == 1'b1;
assign next_spc1_sscan = next_shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:TAP_SSCAN_CFG_WIDTH-2] == 2'b01;
assign next_spc2_sscan = next_shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:TAP_SSCAN_CFG_WIDTH-3] == 3'b001;
assign next_spc3_sscan = next_shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:TAP_SSCAN_CFG_WIDTH-4] == 4'b0001;
assign next_spc4_sscan = next_shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:TAP_SSCAN_CFG_WIDTH-5] == 5'b0000_1;
assign next_spc5_sscan = next_shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:TAP_SSCAN_CFG_WIDTH-6] == 6'b0000_01;
assign next_spc6_sscan = next_shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:TAP_SSCAN_CFG_WIDTH-7] == 7'b0000_001;
assign next_spc7_sscan = next_shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:                    0] == 8'b0000_0001;
assign next_pads_sscan = next_shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:                    0] == 8'b0000_0000;

//negedge
assign next_spc0_sscan_se_pre = tap_shift_exit2_dr_state 
                               & (next_instr_scan
				  | (next_shadow_scan_instr & next_spc0_sscan));
assign next_spc1_sscan_se_pre = tap_shift_exit2_dr_state 
                               & (next_instr_scan 
				  | (next_shadow_scan_instr & next_spc1_sscan));
assign next_spc2_sscan_se_pre = tap_shift_exit2_dr_state 
                               & (next_instr_scan 
				  | (next_shadow_scan_instr & next_spc2_sscan));
assign next_spc3_sscan_se_pre = tap_shift_exit2_dr_state 
                               & (next_instr_scan 
				  | (next_shadow_scan_instr & next_spc3_sscan));
assign next_spc4_sscan_se_pre = tap_shift_exit2_dr_state 
                               & (next_instr_scan 
				  | (next_shadow_scan_instr & next_spc4_sscan));
assign next_spc5_sscan_se_pre = tap_shift_exit2_dr_state 
                               & (next_instr_scan 
				  | (next_shadow_scan_instr & next_spc5_sscan));
assign next_spc6_sscan_se_pre = tap_shift_exit2_dr_state 
                               & (next_instr_scan 
				  | (next_shadow_scan_instr & next_spc6_sscan));
assign next_spc7_sscan_se_pre = tap_shift_exit2_dr_state 
                               & (next_instr_scan 
				  | (next_shadow_scan_instr & next_spc7_sscan));
assign next_pads_sscan_se_pre = tap_shift_exit2_dr_state 
                               & (next_instr_scan 
				  | (next_shadow_scan_instr & next_pads_sscan));

assign ctu_spc0_sscan_se = spc0_sscan_se_pre | pin_based_shift_en;
assign ctu_spc1_sscan_se = spc1_sscan_se_pre | pin_based_shift_en;
assign ctu_spc2_sscan_se = spc2_sscan_se_pre | pin_based_shift_en;
assign ctu_spc3_sscan_se = spc3_sscan_se_pre | pin_based_shift_en;
assign ctu_spc4_sscan_se = spc4_sscan_se_pre | pin_based_shift_en;
assign ctu_spc5_sscan_se = spc5_sscan_se_pre | pin_based_shift_en;
assign ctu_spc6_sscan_se = spc6_sscan_se_pre | pin_based_shift_en;
assign ctu_spc7_sscan_se = spc7_sscan_se_pre | pin_based_shift_en;

//----------------------------
// shadow scan tck
//----------------------------

//negedge
assign next_spc0_tck_pre =  (  tap_capture_dr_state 
			     & next_shadow_scan_instr)
                          | (  tap_shift_dr_state
			     & (next_instr_normal_scan 
				| scan_dump_cken_other
				| (next_shadow_scan_instr & next_spc0_sscan)) );
assign next_spc1_tck_pre =  (  tap_capture_dr_state 
			     & next_shadow_scan_instr)
                          | (  tap_shift_dr_state
			     & (next_instr_normal_scan 
				| scan_dump_cken_other
				| (next_shadow_scan_instr & next_spc1_sscan)) );
assign next_spc2_tck_pre =  (  tap_capture_dr_state 
			     & next_shadow_scan_instr)
                          | (  tap_shift_dr_state
			     & (next_instr_normal_scan 
				| scan_dump_cken_other
				| (next_shadow_scan_instr & next_spc2_sscan)) );
assign next_spc3_tck_pre =  (  tap_capture_dr_state 
			     & next_shadow_scan_instr)
                          | (  tap_shift_dr_state
			     & (next_instr_normal_scan 
				| scan_dump_cken_other
				| (next_shadow_scan_instr & next_spc3_sscan)) );
assign next_spc4_tck_pre =  (  tap_capture_dr_state 
			     & next_shadow_scan_instr)
                          | (  tap_shift_dr_state
			     & (next_instr_normal_scan 
				| scan_dump_cken_other
				| (next_shadow_scan_instr & next_spc4_sscan)) );
assign next_spc5_tck_pre =  (  tap_capture_dr_state 
			     & next_shadow_scan_instr)
                          | (  tap_shift_dr_state
			     & (next_instr_normal_scan 
				| scan_dump_cken_other
				| (next_shadow_scan_instr & next_spc5_sscan)) );
assign next_spc6_tck_pre =  (  tap_capture_dr_state 
			     & next_shadow_scan_instr)
                          | (  tap_shift_dr_state
			     & (next_instr_normal_scan 
				| scan_dump_cken_other
				| (next_shadow_scan_instr & next_spc6_sscan)) );
assign next_spc7_tck_pre =  (  tap_capture_dr_state 
			     & next_shadow_scan_instr)
                          | (  tap_shift_dr_state
			     & (next_instr_normal_scan 
				| scan_dump_cken_other
				| (next_shadow_scan_instr & next_spc7_sscan)) );
assign next_pads_tck_pre =  (  tap_capture_dr_state 
			     & next_shadow_scan_instr)
                          | (  tap_shift_dr_state
			     & (next_instr_normal_scan 
				| scan_dump_cken_other
				| (next_shadow_scan_instr & next_pads_sscan)) );

assign ctu_spc0_tck = io_tck & (spc0_tck_pre | pin_based_pscan_mode);
assign ctu_spc1_tck = io_tck & (spc1_tck_pre | pin_based_pscan_mode);
assign ctu_spc2_tck = io_tck & (spc2_tck_pre | pin_based_pscan_mode);
assign ctu_spc3_tck = io_tck & (spc3_tck_pre | pin_based_pscan_mode);
assign ctu_spc4_tck = io_tck & (spc4_tck_pre | pin_based_pscan_mode);
assign ctu_spc5_tck = io_tck & (spc5_tck_pre | pin_based_pscan_mode);
assign ctu_spc6_tck = io_tck & (spc6_tck_pre | pin_based_pscan_mode);
assign ctu_spc7_tck = io_tck & (spc7_tck_pre | pin_based_pscan_mode);


//----------------------------
// shadow scan out
//----------------------------

always @ ( /*AUTOSENSE*/pads_ctu_bsi or shadow_scan_config_reg
	  or spc0_ctu_sscan_out or spc1_ctu_sscan_out
	  or spc2_ctu_sscan_out or spc3_ctu_sscan_out
	  or spc4_ctu_sscan_out or spc5_ctu_sscan_out
	  or spc6_ctu_sscan_out or spc7_ctu_sscan_out) begin
   casex (shadow_scan_config_reg[TAP_SSCAN_CFG_WIDTH-1:0])
      8'b1???_????: shadow_scan_out = spc0_ctu_sscan_out;
      8'b01??_????: shadow_scan_out = spc1_ctu_sscan_out;
      8'b001?_????: shadow_scan_out = spc2_ctu_sscan_out;
      8'b0001_????: shadow_scan_out = spc3_ctu_sscan_out;
      8'b0000_1???: shadow_scan_out = spc4_ctu_sscan_out;
      8'b0000_01??: shadow_scan_out = spc5_ctu_sscan_out;
      8'b0000_001?: shadow_scan_out = spc6_ctu_sscan_out;
      8'b0000_0001: shadow_scan_out = spc7_ctu_sscan_out;
      default: shadow_scan_out = pads_ctu_bsi;
   endcase                                  
end

// Update-DR: the contents of the shadow chain are latched in the io registers
assign next_ctu_pads_sscan_update =  next_shadow_scan_instr
			           & next_shadow_scan_config_reg == 8'd0
			           & (tap_update_dr_state 
				      & next_tap_instructions[TAP_SSCAN_UPDATE]);
			   

//********************************************************************
// MBIST
//********************************************************************

// Tell mbist control blk to start MBIST
//  - once mbist is kicked off, does not stop until done, unless receive an abort
//  - if bist sm has not completed previous bist, new bist instruction will be ignored
assign next_jtag_bist_serial   =   instr_mbist_serial 
                                 & (tap_update_ir_state_d1 | tap_update_ir_state_d2);
assign next_jtag_bist_parallel =   instr_mbist_parallel 
                                 & (tap_update_ir_state_d1 | tap_update_ir_state_d2);
always @ ( /*AUTOSENSE*/instr_mbist_parallel or instr_mbist_serial
	  or jtag_bist_active or tap_instructions
	  or tap_update_ir_state_d1) begin
   if (  (instr_mbist_serial   & tap_update_ir_state_d1)
       | (instr_mbist_parallel & tap_update_ir_state_d1) )
      next_jtag_bist_active = tap_instructions[TAP_MBIST_ACTIVE_HI:TAP_MBIST_ACTIVE_LO];
   else
      next_jtag_bist_active = jtag_bist_active;
end

// MBIST Abort
assign next_jtag_bist_abort =   (instr_mbist_abort & tap_update_ir_state_d1)
                              | (jtag_bist_abort   & ~bist_jtag_abort_done);

// MBIST Result Register
assign bist_result_reg_load  = instr_mbist_result & tap_capture_dr_state;
assign bist_result_reg_shift = instr_mbist_result & tap_shift_dr_state;

always @ ( /*AUTOSENSE*/bist_jtag_result or bist_result_reg
	  or bist_result_reg_load or bist_result_reg_shift or io_tdi) begin
   if (bist_result_reg_load)
      next_bist_result_reg = bist_jtag_result;
   else begin
      if (bist_result_reg_shift)
	 next_bist_result_reg = { bist_result_reg[(`CTU_BIST_CNT*2)-2:0], io_tdi };
      else
	 next_bist_result_reg = bist_result_reg;
   end
end


//********************************************************************
// Efuse
//********************************************************************

//------------------------
// Shift Interface
//------------------------

assign next_ctu_efc_capturedr =  tap_capture_dr_state
                               & (  next_instr_efc_bypass_data
			          | next_instr_efc_bypass
			          | next_instr_efc_read);

assign next_ctu_efc_shiftdr   = tap_shift_dr_state
                               & (  next_instr_efc_bypass_data 
			          | next_instr_efc_read);

assign next_ctu_efc_updatedr  =  tap_update_dr_state
                               & (  next_instr_efc_bypass_data
			          | next_instr_efc_bypass
			          | next_instr_efc_read);

assign next_efc_tck_pre =  next_ctu_efc_capturedr
                         | next_ctu_efc_shiftdr
                         | (  tap_shift_dr_state
                            & (next_instr_normal_scan | scan_dump_cken_other));

assign ctu_efc_tck = io_tck
                     & (  efc_tck_pre
			| pin_based_pscan_mode);

assign ctu_efc_data_in = io_tdi;

//------------------------
// R/W Interface
//------------------------
assign next_ctu_efc_fuse_bypass = next_instr_efc_bypass;
assign next_ctu_efc_read_en     = next_instr_efc_read;

// row address
assign efc_rowaddr_shift = instr_efc_row_addr & tap_shift_dr_state;

always @ ( /*AUTOSENSE*/efc_rowaddr or efc_rowaddr_shift or io_tdi) begin
   if (efc_rowaddr_shift)
      next_efc_rowaddr[6:0] = { efc_rowaddr[5:0], io_tdi };
   else
      next_efc_rowaddr[6:0] = efc_rowaddr[6:0];
end

assign next_ctu_efc_rowaddr = efc_rowaddr;  //negedge


// column address
assign efc_coladdr_shift = instr_efc_col_addr & tap_shift_dr_state;

always @ ( /*AUTOSENSE*/efc_coladdr or efc_coladdr_shift or io_tdi) begin
   if (efc_coladdr_shift)
      next_efc_coladdr[4:0] = { efc_coladdr[3:0], io_tdi };
   else
      next_efc_coladdr[4:0] = efc_coladdr[4:0];
end

assign next_ctu_efc_coladdr = efc_coladdr;  //negedge

// read mode
assign efc_read_mode_shift = instr_efc_read_mode & tap_shift_dr_state;

always @ ( /*AUTOSENSE*/efc_read_mode or efc_read_mode_shift or io_tdi) begin
   if (efc_read_mode_shift)
      next_efc_read_mode[2:0] = { efc_read_mode[1:0], io_tdi };
   else
      next_efc_read_mode[2:0] = efc_read_mode[2:0];
end

assign next_ctu_efc_read_mode = efc_read_mode; //negedge

//------------------------
// Destination Sample
//------------------------

// negedge
assign next_ctu_efc_dest_sample = instr_efc_dest_sample & tap_update_ir_state_d1;

//********************************************************************
// Clock Control
//********************************************************************

//------------------------
// clk_sel
//------------------------

//default value of ctu_sel_* at reset is 3'b111
// value of ctu_sel* is held until next (tap_instructions[4:0] == `TAP_CLK_SEL)
assign clk_sel_cpu  = next_tap_instructions[TAP_SCAN_CLK_SEL_CPU_HI :TAP_SCAN_CLK_SEL_CPU_LO];  
assign clk_sel_dram = next_tap_instructions[TAP_SCAN_CLK_SEL_DRAM_HI:TAP_SCAN_CLK_SEL_DRAM_LO];
assign clk_sel_jbus = next_tap_instructions[TAP_SCAN_CLK_SEL_JBUS_HI:TAP_SCAN_CLK_SEL_JBUS_LO];

assign sel_cpu[0] =  clk_sel_cpu[0];                                     // normal
assign sel_cpu[1] = ~clk_sel_cpu[0] &  clk_sel_cpu[1] &  clk_sel_cpu[2]; // io_tck mode
assign sel_cpu[2] = ~clk_sel_cpu[0] &  clk_sel_cpu[1] & ~clk_sel_cpu[2]; // pll_bypass

assign sel_dram[0] =  clk_sel_dram[0];                                       // normal 
assign sel_dram[1] = ~clk_sel_dram[0] &  clk_sel_dram[1] &  clk_sel_dram[2]; // io_tck mode
assign sel_dram[2] = ~clk_sel_dram[0] &  clk_sel_dram[1] & ~clk_sel_dram[2]; // pll_bypass

assign sel_jbus[0] =  clk_sel_jbus[0];                                       // normal
assign sel_jbus[1] = ~clk_sel_jbus[0] &  clk_sel_jbus[1] &  clk_sel_jbus[2]; // io_tck mode
assign sel_jbus[2] = ~clk_sel_jbus[0] &  clk_sel_jbus[1] & ~clk_sel_jbus[2]; // pll_bypass

// negedge
always @ ( /*AUTOSENSE*/instr_clk_sel or instr_scan or pll_bypass_tap
	  or sel_cpu or sel_cpu_ff or sel_dram or sel_dram_ff
	  or sel_jbus or sel_jbus_ff or tap_update_ir_state_d1) begin
   if (pll_bypass_tap) begin
      next_sel_cpu_ff  = 3'b100; // pll_bypass mode
      next_sel_dram_ff = 3'b001; // normal
      next_sel_jbus_ff = 3'b100; // pll_bypass mode
   end
   else if (tap_update_ir_state_d1 & instr_scan) begin  // auto clock sel for internal scan instructions
      next_sel_cpu_ff[2:0]  = 3'b010; // tck mode
      next_sel_dram_ff[2:0] = 3'b010;
      next_sel_jbus_ff[2:0] = 3'b010;
   end
   else if (tap_update_ir_state_d1 & instr_clk_sel) begin  // manual clock sel through tap
      next_sel_cpu_ff[2:0]  = sel_cpu[2:0];
      next_sel_dram_ff[2:0] = sel_dram[2:0];
      next_sel_jbus_ff[2:0] = sel_jbus[2:0];
   end
   else begin
      next_sel_cpu_ff[2:0]  = sel_cpu_ff[2:0];
      next_sel_dram_ff[2:0] = sel_dram_ff[2:0];
      next_sel_jbus_ff[2:0] = sel_jbus_ff[2:0];
   end
end

//always @ ( /*AUTOSENSE*/pin_based_pll_bypass or pin_based_pscan_mode
//	  or sel_cpu_ff or sel_dram_ff or sel_jbus_ff) begin
//   if (pin_based_pscan_mode) begin
//      ctu_sel_cpu  = 3'b010; // tck mode
//      ctu_sel_dram = 3'b010;
//      ctu_sel_jbus = 3'b010;
//   end
//   else if (pin_based_pll_bypass) begin 
//      ctu_sel_cpu  = 3'b100; // pll_bypass mode
//      ctu_sel_dram = 3'b001; // normal
//      ctu_sel_jbus = 3'b100; // pll_bypass mode
//   end
//   else begin
//      ctu_sel_cpu  = sel_cpu_ff;
//      ctu_sel_dram = sel_dram_ff;
//      ctu_sel_jbus = sel_jbus_ff;
//   end
//end
//
//assign ctu_sel_cpu[0] = ~(  test_mode_pin                   // 0->0->ff
//			  & (~io_trst_l | pll_bypass_pin)) 
//                        & sel_cpu_ff[0];
//assign ctu_sel_cpu[1] =  (test_mode_pin & ~io_trst_l)       // 1->0->ff
//                       | (  ~(test_mode_pin & pll_bypass_pin) 
//			  & sel_cpu_ff[1]);
//assign ctu_sel_cpu[2] =   ~(test_mode_pin & ~io_trst_l)                    // 0->1->ff
//                        & (  (test_mode_pin & pll_bypass_pin)
//                           | sel_cpu_ff[2]);
//
//ctu_sel_dram[0] = 0->1->ff
//ctu_sel_dram[1] = 1->0->ff
//ctu_sel_dram[2] = 0->0->ff
//
//ctu_sel_jbus[0] = 0->0->ff
//ctu_sel_jbus[1] = 1->0->ff
//ctu_sel_jbus[2] = 0->1->ff

ctu_inv u_inv_trst(.z(trst), .a(io_trst_l));

/* ctu_jtag_clk_sel_0_0_ff AUTO_TEMPLATE (
 .sel_clk (ctu_sel_cpu[@]), 
 .sel_ff(sel_cpu_ff[@]),); */
/* ctu_jtag_clk_sel_1_0_ff AUTO_TEMPLATE (
 .sel_clk (ctu_sel_cpu[@]), 
 .sel_ff(sel_cpu_ff[@]),); */
/* ctu_jtag_clk_sel_0_1_ff AUTO_TEMPLATE (
 .sel_clk (ctu_sel_cpu[@]), 
 .sel_ff(sel_cpu_ff[@]),); */
ctu_jtag_clk_sel_0_0_ff u_ctu_sel_cpu0 (/*AUTOINST*/
					// Outputs
					.sel_clk(ctu_sel_cpu[0]), // Templated
					// Inputs
					.test_mode_pin(test_mode_pin),
					.trst(trst),
					.pll_bypass_pin(pll_bypass_pin),
					.sel_ff(sel_cpu_ff[0]));	 // Templated
ctu_jtag_clk_sel_1_0_ff u_ctu_sel_cpu1 (/*AUTOINST*/
					// Outputs
					.sel_clk(ctu_sel_cpu[1]), // Templated
					// Inputs
					.test_mode_pin(test_mode_pin),
					.trst(trst),
					.pll_bypass_pin(pll_bypass_pin),
					.sel_ff(sel_cpu_ff[1]));	 // Templated
ctu_jtag_clk_sel_0_1_ff u_ctu_sel_cpu2 (/*AUTOINST*/
					// Outputs
					.sel_clk(ctu_sel_cpu[2]), // Templated
					// Inputs
					.test_mode_pin(test_mode_pin),
					.trst(trst),
					.pll_bypass_pin(pll_bypass_pin),
					.sel_ff(sel_cpu_ff[2]));	 // Templated

/* ctu_jtag_clk_sel_0_0_ff AUTO_TEMPLATE (
 .sel_clk (ctu_sel_dram[@]), 
 .sel_ff(sel_dram_ff[@]),); */
/* ctu_jtag_clk_sel_1_0_ff AUTO_TEMPLATE (
 .sel_clk (ctu_sel_dram[@]), 
 .sel_ff(sel_dram_ff[@]),); */
/* ctu_jtag_clk_sel_0_1_ff AUTO_TEMPLATE (
 .sel_clk (ctu_sel_dram[@]), 
 .sel_ff(sel_dram_ff[@]),); */
ctu_jtag_clk_sel_0_1_ff u_ctu_sel_dram0 (/*AUTOINST*/
					 // Outputs
					 .sel_clk(ctu_sel_dram[0]), // Templated
					 // Inputs
					 .test_mode_pin(test_mode_pin),
					 .trst(trst),
					 .pll_bypass_pin(pll_bypass_pin),
					 .sel_ff(sel_dram_ff[0])); // Templated
ctu_jtag_clk_sel_1_0_ff u_ctu_sel_dram1 (/*AUTOINST*/
					 // Outputs
					 .sel_clk(ctu_sel_dram[1]), // Templated
					 // Inputs
					 .test_mode_pin(test_mode_pin),
					 .trst(trst),
					 .pll_bypass_pin(pll_bypass_pin),
					 .sel_ff(sel_dram_ff[1])); // Templated
ctu_jtag_clk_sel_0_0_ff u_ctu_sel_dram2 (/*AUTOINST*/
					 // Outputs
					 .sel_clk(ctu_sel_dram[2]), // Templated
					 // Inputs
					 .test_mode_pin(test_mode_pin),
					 .trst(trst),
					 .pll_bypass_pin(pll_bypass_pin),
					 .sel_ff(sel_dram_ff[2])); // Templated

/* ctu_jtag_clk_sel_0_0_ff AUTO_TEMPLATE (
 .sel_clk (ctu_sel_jbus[@]), 
 .sel_ff(sel_jbus_ff[@]),); */
/* ctu_jtag_clk_sel_1_0_ff AUTO_TEMPLATE (
 .sel_clk (ctu_sel_jbus[@]), 
 .sel_ff(sel_jbus_ff[@]),); */
/* ctu_jtag_clk_sel_0_1_ff AUTO_TEMPLATE (
 .sel_clk (ctu_sel_jbus[@]), 
 .sel_ff(sel_jbus_ff[@]),); */
ctu_jtag_clk_sel_0_0_ff u_ctu_sel_jbus0 (/*AUTOINST*/
					 // Outputs
					 .sel_clk(ctu_sel_jbus[0]), // Templated
					 // Inputs
					 .test_mode_pin(test_mode_pin),
					 .trst(trst),
					 .pll_bypass_pin(pll_bypass_pin),
					 .sel_ff(sel_jbus_ff[0])); // Templated
ctu_jtag_clk_sel_1_0_ff u_ctu_sel_jbus1 (/*AUTOINST*/
					 // Outputs
					 .sel_clk(ctu_sel_jbus[1]), // Templated
					 // Inputs
					 .test_mode_pin(test_mode_pin),
					 .trst(trst),
					 .pll_bypass_pin(pll_bypass_pin),
					 .sel_ff(sel_jbus_ff[1])); // Templated
ctu_jtag_clk_sel_0_1_ff u_ctu_sel_jbus2 (/*AUTOINST*/
					 // Outputs
					 .sel_clk(ctu_sel_jbus[2]), // Templated
					 // Inputs
					 .test_mode_pin(test_mode_pin),
					 .trst(trst),
					 .pll_bypass_pin(pll_bypass_pin),
					 .sel_ff(sel_jbus_ff[2])); // Templated


//------------------------
// scan dump
// - stagger cken and delay shift_enable to compensate for cken repeater fifo not
//   balanced on top level & 
//------------------------

assign next_cken_dram_wait = JTAG_CKEN_DRAM_WAIT;
assign next_cken_jbus_wait = JTAG_CKEN_JBUS_WAIT;
assign next_cken_other_wait = JTAG_CKEN_OTHER_WAIT;

assign scan_dump_cken_cmp   = instr_scan_dump & ~nstep_mode;
assign scan_dump_cken_dram  = scan_dump_cken_cmp & (scan_dump_shiftdr_cnt >= cken_dram_wait);
assign scan_dump_cken_jbus  = scan_dump_cken_cmp & (scan_dump_shiftdr_cnt >= cken_jbus_wait);
assign scan_dump_cken_other = scan_dump_cken_cmp & (scan_dump_shiftdr_cnt >= cken_other_wait);

// negedge
assign inc_scan_dump_shiftdr_cnt = instr_scan_dump & tap_shift_dr_state;

always @ ( /*AUTOSENSE*/inc_scan_dump_shiftdr_cnt or instr_scan_dump
	  or scan_dump_shiftdr_cnt or tap_update_ir_state_d1) begin
   if (tap_update_ir_state_d1 & instr_scan_dump)
      next_scan_dump_shiftdr_cnt = {JTAG_SDR_CNT_WIDTH{1'b0}};
   else begin
      if (inc_scan_dump_shiftdr_cnt & (~&scan_dump_shiftdr_cnt))  // do not overflow counter
	 next_scan_dump_shiftdr_cnt = scan_dump_shiftdr_cnt +1'b1;
      else
	 next_scan_dump_shiftdr_cnt = scan_dump_shiftdr_cnt;
   end
end


//------------------------
// force_cken
//------------------------
assign normal_force_cken =   ~nstep_mode
			   & (  tap_instructions[TAP_CKEN_BIT]
			      & (  instr_scan_parallel 
			  	 | instr_scan_serial   
			  	 | instr_scan_mtest ));
assign next_jtag_clsp_force_cken_cmp  = normal_force_cken | scan_dump_cken_cmp;
assign next_jtag_clsp_force_cken_dram = normal_force_cken | scan_dump_cken_dram;
assign next_jtag_clsp_force_cken_jbus = normal_force_cken | scan_dump_cken_jbus;


//------------------------
// stop_id
//------------------------

// clock stop sequence
assign jtag_clsp_stop_id_vld  = instr_clk_stop_id 
				& (tap_update_ir_state_d1 | tap_update_ir_state_d2);  //sync to jbus
assign jtag_clsp_stop_id[5:0] = tap_instructions[TAP_CLK_STOP_ID_HI:TAP_CLK_STOP_ID_LO];

//------------------------
// nstep
//------------------------
assign jtag_nstep_vld    = instr_scan_nstep 
                           & (tap_update_ir_state_d1 | tap_update_ir_state_d2);      //sync to 
assign jtag_nstep_domain = tap_instructions[TAP_SCAN_NSTEP_DOM_HI:TAP_SCAN_NSTEP_DOM_LO];
assign jtag_nstep_count  = tap_instructions[TAP_SCAN_NSTEP_CNT_HI:TAP_SCAN_NSTEP_CNT_LO];

// TAP_SCAN_NSTEP sets bit, and non-scan instruction clears bit
always @ ( /*AUTOSENSE*/instr_scan or instr_scan_bypass_en
	  or instr_scan_nstep or jtag_nstep_vld or nstep_mode) begin
   if (jtag_nstep_vld)
      next_nstep_mode = 1'b1;
   else if (~instr_scan & ~instr_scan_nstep & ~instr_scan_bypass_en)
      next_nstep_mode = 1'b0;
   else
      next_nstep_mode = nstep_mode;
end

assign next_dft_clsp_nstep_capture_l = ~(tap_capture_dr_state & next_nstep_mode);

//------------------------
// sel_tck2
//------------------------

assign next_sel_tck2_pre =   ~nstep_mode
                          & (   instr_scan_parallel
                             | (instr_scan_mtest & tap_instructions[TAP_SCAN_MODE_BIT] == TAP_SCAN_MODE_PARALLEL));

assign jtag_clsp_sel_tck2 =  sel_tck2_pre
                           | pin_based_pscan_mode;

//********************************************************************
// PLL Control
//********************************************************************

//-----------------------
// PLL_BYPASS
//-----------------------
assign toggle_pll_bypass_tap = instr_pll_bypass & tap_update_ir_state_d1; 
assign next_pll_bypass_tap   = toggle_pll_bypass_tap ^ pll_bypass_tap;

// pll_bypass_pin signal is gated by test_mode_pin
assign pll_bypass =  pin_based_pll_bypass
                   | (~pin_based_pscan_mode & pll_bypass_tap)
                   | jtag_clsp_sel_tck2;


//*******************************************************************************
// Misc Muxes
// - muxes placed here for a lack of a better place
//*******************************************************************************

// Scan

// bug #5695
assign serial_scan = instr_scan_serial
                     | (  tap_instructions[TAP_SCAN_MODE_BIT] == TAP_SCAN_MODE_SERIAL
		        & (  tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_DUMP            // 6'h26
			   | tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_MTEST_LONG      // 6'h22
			   | tap_instructions[TAP_CMD_HI:TAP_CMD_LO] == `TAP_SCAN_MTEST_SHORT));  // 6'h23

always @ ( /*AUTOSENSE*/io_tdi or pin_based_pscan_mode
	  or sctag2_ctu_serial_scan_in or serial_scan) begin
//   if (instr_scan_serial & ~pin_based_pscan_mode)
   if (serial_scan & ~pin_based_pscan_mode)  // bug #5695
      ctu_fpu_so = sctag2_ctu_serial_scan_in;
   else
      ctu_fpu_so = io_tdi;
end


// Random Number Generator
always @ ( /*AUTOSENSE*/afi_rng_ctl or afi_tsr_mode or jbus_rst_l
	  or test_mode_pin) begin
   if (test_mode_pin) begin
      dft_rng_vctrl = afi_rng_ctl[2:0];
      dft_rng_rst_l = afi_tsr_mode;
   end
   else begin
      dft_rng_vctrl = 3'b111;
      dft_rng_rst_l = jbus_rst_l;
   end
end

// Temperature Sensor Regulator Divider
always @ ( /*AUTOSENSE*/afi_tsr_div or afi_tsr_mode or afi_tsr_tsel
	  or test_mode_pin) begin
   if (test_mode_pin) begin
      dft_tsr_div  = afi_tsr_div[9:1];
      dft_tsr_tsel = afi_tsr_tsel[7:0];
      dft_tsr_reset_l = afi_tsr_mode;
   end
   else begin
      dft_tsr_div  = 9'b0_0001_1001;
      dft_tsr_tsel = 8'd0;
      dft_tsr_reset_l = 1'b0;
   end
end

// PLL
always @ ( /*AUTOSENSE*/afi_pll_char_mode or afi_pll_clamp_fltr
	  or afi_pll_div2 or test_mode_pin) begin
   if (test_mode_pin & afi_pll_char_mode) begin
      dft_pll_div2       = afi_pll_div2[5:0];
      dft_pll_clamp_fltr = afi_pll_clamp_fltr;
   end
   else begin
      dft_pll_div2       = 6'd0;
      dft_pll_clamp_fltr = 1'b0;
   end
end

always @ ( /*AUTOSENSE*/afi_pll_char_mode or afi_pll_trst_l
	  or pin_based_pscan_mode or pll_reset_ref_l or test_mode_pin) begin
   if (pin_based_pscan_mode)
      dft_pll_arst_l = 1'b0;
   else if (test_mode_pin & afi_pll_char_mode)
      dft_pll_arst_l = afi_pll_trst_l;
   else
      dft_pll_arst_l = pll_reset_ref_l;
end

assign dft_pll_testmode = test_mode_pin & afi_pll_char_mode;

//*******************************************************************************
// Async Reset and Set DFFRL/DFFSL Instantiations
//*******************************************************************************
//--------------
// posedge flops
//--------------
dffrl_async_ns u_dffrl_async_creg_rdrtrn_vld 
   ( .din (next_creg_rdrtrn_vld),
     .clk (io_tck),
     .rst_l (tap_rst_l),
     .q (creg_rdrtrn_vld)
     );

dffrl_async_ns #(64) u_dffrl_async_scratch_reg
   (.din (next_scratch_reg),
    .clk (io_tck),
     .rst_l (tap_rst_l),
    .q (scratch_reg)
    );

dffrl_async_ns u_dffrl_async_jtag_bist_serial 
   ( .din (next_jtag_bist_serial),
     .rst_l (tap_rst_l),
     .clk (io_tck),
     .q (jtag_bist_serial)
     );

dffrl_async_ns u_dffrl_async_jtag_bist_parallel 
   ( .din (next_jtag_bist_parallel),
     .rst_l (tap_rst_l),
     .clk (io_tck),
     .q (jtag_bist_parallel)
     );

dffrl_async_ns u_dffrl_async_jtag_bist_abort 
   ( .din (next_jtag_bist_abort),
     .rst_l (tap_rst_l),
     .clk (io_tck),
     .q (jtag_bist_abort)
     );

dffrl_async_ns #(TAP_MBIST_ACTIVE_WIDTH) u_dffrl_async_jtag_bist_active 
   ( .din (next_jtag_bist_active),
     .rst_l (tap_rst_l),
     .clk (io_tck),
     .q (jtag_bist_active)
     );

dffrl_async_ns #(TAP_SSCAN_CFG_WIDTH) u_dffrl_async_shadow_scan_config_reg
   ( .din (next_shadow_scan_config_reg),
     .clk (io_tck),
     .rst_l (tap_rst_l),
     .q (shadow_scan_config_reg)
     );

dffrl_async_ns #(1) u_dffrl_async_jtag_creg_addr_en
   ( .din (next_jtag_creg_addr_en),
     .clk (io_tck),
     .rst_l (tap_rst_l),
     .q (jtag_creg_addr_en)
     );

dffrl_async_ns #(1) u_dffrl_async_jtag_creg_wr_en
   ( .din (next_jtag_creg_wr_en),
     .clk (io_tck),
     .rst_l (tap_rst_l),
     .q (jtag_creg_wr_en)
     );

dffrl_async_ns #(1) u_dffrl_async_jtag_creg_rd_en
   ( .din (next_jtag_creg_rd_en),
     .clk (io_tck),
     .rst_l (tap_rst_l),
     .q (jtag_creg_rd_en)
     );

dffrl_async_ns #(1) u_dffrl_async_jtag_creg_data_en
   ( .din (next_jtag_creg_data_en),
     .clk (io_tck),
     .rst_l (tap_rst_l),
     .q (jtag_creg_data_en)
     );


//--------------
// negedge flops
//--------------
dffrl_async_ns u_dffrl_async_global_scan_bypass_en 
   ( .din (next_global_scan_bypass_en),
     .clk (tck_l),
     .rst_l (tap_rst_l),
//     .q (global_scan_bypass_en));
     .q (global_scan_bypass_en_pre)); // bug #5483

dffrl_async_ns u_dffrl_async_pscan_select_pre 
   ( .din (next_pscan_select_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (pscan_select_pre));

// reset clocks in normal mode (bit 0 asserted)
dffsl_async_ns #(1) u_dffsl_async_sel_cpu_ff0
   ( .din (next_sel_cpu_ff[0]),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (sel_cpu_ff[0])
     );

dffrl_async_ns #(2) u_dffrl_async_sel_cpu_ff_1to2
   ( .din (next_sel_cpu_ff[2:1]),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (sel_cpu_ff[2:1])
     );

dffsl_async_ns #(1) u_dffsl_async_sel_dram_ff0
   ( .din (next_sel_dram_ff[0]),
     .clk (tck_l),
     .set_l (tap_rst_l),

     .q (sel_dram_ff[0])
     );

dffrl_async_ns #(2) u_dffrl_async_sel_dram_ff_1to2 
   ( .din (next_sel_dram_ff[2:1]),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (sel_dram_ff[2:1])
     );

dffsl_async_ns #(1) u_dffsl_async_sel_jbus_ff0
   ( .din (next_sel_jbus_ff[0]),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (sel_jbus_ff[0])
     );

dffrl_async_ns #(2) u_dffrl_async_sel_jbus_ff_1to2 
   ( .din (next_sel_jbus_ff[2:1]),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (sel_jbus_ff[2:1])
     );

// boundary scan
dffrl_async_ns #(1) u_dffrl_async_bscan_enable
   ( .din (next_bscan_enable),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (bscan_enable)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_ddr0_mode_ctl
   ( .din (next_ctu_ddr0_mode_ctl),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_ddr0_mode_ctl)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_ddr1_mode_ctl
   ( .din (next_ctu_ddr1_mode_ctl),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_ddr1_mode_ctl)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_ddr2_mode_ctl
   ( .din (next_ctu_ddr2_mode_ctl),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_ddr2_mode_ctl)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_ddr3_mode_ctl
   ( .din (next_ctu_ddr3_mode_ctl),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_ddr3_mode_ctl)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_jbusl_mode_ctl
   ( .din (next_ctu_jbusl_mode_ctl),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_jbusl_mode_ctl)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_jbusr_mode_ctl
   ( .din (next_ctu_jbusr_mode_ctl),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_jbusr_mode_ctl)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_debug_mode_ctl
   ( .din (next_ctu_debug_mode_ctl),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_debug_mode_ctl)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_misc_mode_ctl
   ( .din (next_ctu_misc_mode_ctl),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_misc_mode_ctl)
     );

dffsl_async_ns #(1) u_dffsl_async_ctu_ddr0_hiz_l
   ( .din (next_ctu_ddr0_hiz_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (ctu_ddr0_hiz_l)
     );

dffsl_async_ns #(1) u_dffsl_async_ctu_ddr1_hiz_l
   ( .din (next_ctu_ddr1_hiz_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (ctu_ddr1_hiz_l)
     );

dffsl_async_ns #(1) u_dffsl_async_ctu_ddr2_hiz_l
   ( .din (next_ctu_ddr2_hiz_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (ctu_ddr2_hiz_l)
     );

dffsl_async_ns #(1) u_dffsl_async_ctu_ddr3_hiz_l
   ( .din (next_ctu_ddr3_hiz_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (ctu_ddr3_hiz_l)
     );

dffsl_async_ns #(1) u_dffsl_async_ctu_jbusl_hiz_l
   ( .din (next_ctu_jbusl_hiz_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (ctu_jbusl_hiz_l)
     );

dffsl_async_ns #(1) u_dffsl_async_ctu_jbusr_hiz_l
   ( .din (next_ctu_jbusr_hiz_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (ctu_jbusr_hiz_l)
     );

dffsl_async_ns #(1) u_dffsl_async_ctu_debug_hiz_l
   ( .din (next_ctu_debug_hiz_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (ctu_debug_hiz_l)
     );

dffsl_async_ns #(1) u_dffsl_async_ctu_misc_hiz_l
   ( .din (next_ctu_misc_hiz_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (ctu_misc_hiz_l)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_ddr0_update_dr
   ( .din (next_ctu_ddr0_update_dr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_ddr0_update_dr)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_ddr1_update_dr
   ( .din (next_ctu_ddr1_update_dr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_ddr1_update_dr)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_ddr2_update_dr
   ( .din (next_ctu_ddr2_update_dr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_ddr2_update_dr)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_ddr3_update_dr
   ( .din (next_ctu_ddr3_update_dr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_ddr3_update_dr)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_jbusl_update_dr
   ( .din (next_ctu_jbusl_update_dr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_jbusl_update_dr)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_jbusr_update_dr
   ( .din (next_ctu_jbusr_update_dr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_jbusr_update_dr)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_debug_update_dr
   ( .din (next_ctu_debug_update_dr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_debug_update_dr)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_misc_update_dr
   ( .din (next_ctu_misc_update_dr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_misc_update_dr)
     );

dffrl_async_ns #(1) u_dffrl_async_ddr0_clock_dr_pre
   ( .din (next_ddr0_clock_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ddr0_clock_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ddr1_clock_dr_pre
   ( .din (next_ddr1_clock_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ddr1_clock_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ddr2_clock_dr_pre
   ( .din (next_ddr2_clock_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ddr2_clock_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ddr3_clock_dr_pre
   ( .din (next_ddr3_clock_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ddr3_clock_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_jbusl_clock_dr_pre
   ( .din (next_jbusl_clock_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (jbusl_clock_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_jbusr_clock_dr_pre
   ( .din (next_jbusr_clock_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (jbusr_clock_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_debug_clock_dr_pre
   ( .din (next_debug_clock_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (debug_clock_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_misc_clock_dr_pre
   ( .din (next_misc_clock_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (misc_clock_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ddr0_shift_dr_pre
   ( .din (next_ddr0_shift_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ddr0_shift_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ddr1_shift_dr_pre
   ( .din (next_ddr1_shift_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ddr1_shift_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ddr2_shift_dr_pre
   ( .din (next_ddr2_shift_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ddr2_shift_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ddr3_shift_dr_pre
   ( .din (next_ddr3_shift_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ddr3_shift_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_jbusl_shift_dr_pre
   ( .din (next_jbusl_shift_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (jbusl_shift_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_jbusr_shift_dr_pre
   ( .din (next_jbusr_shift_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (jbusr_shift_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_debug_shift_dr_pre
   ( .din (next_debug_shift_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (debug_shift_dr_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_misc_shift_dr_pre
   ( .din (next_misc_shift_dr_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (misc_shift_dr_pre)
     );

// shadow scan
dffrl_async_ns #(1) u_dffrl_async_shadow_scan_instr
   ( .din (next_shadow_scan_instr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (shadow_scan_instr)
     );

dffsl_async_ns #(1) u_dffsl_async_spc_sscan_tid0
   ( .din (next_spc_sscan_tid[0]),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (spc_sscan_tid[0])
     );

dffrl_async_ns #(3) u_dffrl_async_spc_sscan_tid1to3
   ( .din (next_spc_sscan_tid[3:1]),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc_sscan_tid[3:1])
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_pads_sscan_update
   ( .din (next_ctu_pads_sscan_update),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_pads_sscan_update)
     );

dffrl_async_ns #(1) u_dffrl_async_spc0_sscan_se_pre
   ( .din (next_spc0_sscan_se_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc0_sscan_se_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc1_sscan_se_pre
   ( .din (next_spc1_sscan_se_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc1_sscan_se_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc2_sscan_se_pre
   ( .din (next_spc2_sscan_se_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc2_sscan_se_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc3_sscan_se_pre
   ( .din (next_spc3_sscan_se_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc3_sscan_se_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc4_sscan_se_pre
   ( .din (next_spc4_sscan_se_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc4_sscan_se_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc5_sscan_se_pre
   ( .din (next_spc5_sscan_se_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc5_sscan_se_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc6_sscan_se_pre
   ( .din (next_spc6_sscan_se_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc6_sscan_se_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc7_sscan_se_pre
   ( .din (next_spc7_sscan_se_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc7_sscan_se_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc0_tck_pre
   ( .din (next_spc0_tck_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc0_tck_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc1_tck_pre
   ( .din (next_spc1_tck_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc1_tck_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc2_tck_pre
   ( .din (next_spc2_tck_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc2_tck_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc3_tck_pre
   ( .din (next_spc3_tck_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc3_tck_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc4_tck_pre
   ( .din (next_spc4_tck_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc4_tck_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc5_tck_pre
   ( .din (next_spc5_tck_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc5_tck_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc6_tck_pre
   ( .din (next_spc6_tck_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc6_tck_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_spc7_tck_pre
   ( .din (next_spc7_tck_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (spc7_tck_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_global_snap
   ( .din (next_ctu_global_snap),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_global_snap)
     );

// scan
dffrl_async_ns #(1) u_dffrl_async_instr_normal_scan
   ( .din (next_instr_normal_scan),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (instr_normal_scan)
     );

dffrl_async_ns #(1) u_dffrl_async_instr_scan
   ( .din (next_instr_scan),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (instr_scan)
     );

dffrl_async_ns #(1) u_dffrl_async_global_shift_enable_pre
   ( .din (next_global_shift_enable_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (global_shift_enable_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_tst_macrotest
   ( .din (next_ctu_tst_macrotest),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_tst_macrotest)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_tst_short_chain
   ( .din (next_ctu_tst_short_chain),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_tst_short_chain)
     );


dffrl_async_ns #(JTAG_SDR_CNT_WIDTH) u_dffrl_async_scan_dump_shiftdr_cnt 
   (.din (next_scan_dump_shiftdr_cnt),
    .clk (tck_l),
    .rst_l (tap_rst_l),
    .q (scan_dump_shiftdr_cnt));

// efc
dffrl_async_ns #(1) u_dffrl_async_ctu_efc_capturedr
   ( .din (next_ctu_efc_capturedr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_efc_capturedr)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_efc_shiftdr
   ( .din (next_ctu_efc_shiftdr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_efc_shiftdr)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_efc_updatedr
   ( .din (next_ctu_efc_updatedr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_efc_updatedr)
     );

dffrl_async_ns #(1) u_dffrl_async_efc_tck_pre
   ( .din (next_efc_tck_pre),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (efc_tck_pre)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_efc_fuse_bypass
   ( .din (next_ctu_efc_fuse_bypass),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_efc_fuse_bypass)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_efc_read_en
   ( .din (next_ctu_efc_read_en),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_efc_read_en)
     );

dffrl_async_ns #(1) u_dffrl_async_ctu_efc_dest_sample
   ( .din (next_ctu_efc_dest_sample),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_efc_dest_sample)
     );

dffsl_async_ns #(1) u_dffsl_async_suppress_capture_l
   ( .din (next_suppress_capture_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (suppress_capture_l)
     );

dffrl_async_ns #(7) u_dffrl_async_ctu_efc_rowaddr
   ( .din (next_ctu_efc_rowaddr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_efc_rowaddr)
     );

dffrl_async_ns #(5) u_dffrl_async_ctu_efc_coladdr
   ( .din (next_ctu_efc_coladdr),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_efc_coladdr)
     );

dffrl_async_ns #(3) u_dffrl_async_ctu_efc_read_mode
   ( .din (next_ctu_efc_read_mode),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (ctu_efc_read_mode)
     );

// nstep
dffrl_async_ns #(1) u_dffrl_async_nstep_mode
   ( .din (next_nstep_mode),
     .clk (tck_l),
     .rst_l (tap_rst_l),
     .q (nstep_mode)
     );

dffsl_async_ns #(1) u_dffsl_async_dft_clsp_nstep_capture_l
   ( .din (next_dft_clsp_nstep_capture_l),
     .clk (tck_l),
     .set_l (tap_rst_l),
     .q (dft_clsp_nstep_capture_l)
     );

// clock control
dffrl_async_ns u_dffrl_async_sel_tck2_pre 
   (.din (next_sel_tck2_pre),
    .clk (tck_l),
    .rst_l (tap_rst_l),
    .q (sel_tck2_pre));

dffrl_async_ns u_dffrl_async_jtag_clsp_force_cken_cmp
   (.din (next_jtag_clsp_force_cken_cmp),
    .clk (tck_l),
    .rst_l (tap_rst_l),
    .q (jtag_clsp_force_cken_cmp));

dffrl_async_ns u_dffrl_async_jtag_clsp_force_cken_dram
   (.din (next_jtag_clsp_force_cken_dram),
    .clk (tck_l),
    .rst_l (tap_rst_l),
    .q (jtag_clsp_force_cken_dram));

dffrl_async_ns u_dffrl_async_jtag_clsp_force_cken_jbus
   (.din (next_jtag_clsp_force_cken_jbus),
    .clk (tck_l),
    .rst_l (tap_rst_l),
    .q (jtag_clsp_force_cken_jbus));

dffrl_async_ns u_dffrl_async_pll_bypass_tap 
   (.din (next_pll_bypass_tap),
    .clk (tck_l),
    .rst_l (tap_rst_l),
    .q (pll_bypass_tap));

//*******************************************************************************
// DFF Instantiations
//*******************************************************************************
dff_ns u_dff_creg_rdrtrn_load_d1 
   ( .din (creg_rdrtrn_load),
     .clk (io_tck),
     .q (creg_rdrtrn_load_d1)
     );

dff_ns u_dff_creg_jtag_rdrtrn_vld_d 
   ( .din (creg_jtag_rdrtrn_vld),
     .clk (io_tck),
     .q (creg_jtag_rdrtrn_vld_d)
     );

dff_ns u_dff_creg_jtag_rdrtrn_vld_d2 
   ( .din (creg_jtag_rdrtrn_vld_d),
     .clk (io_tck),
     .q (creg_jtag_rdrtrn_vld_d2)
     );

dff_ns u_dff_tap_shift_dr_state_d1
   (.din (tap_shift_dr_state),
    .clk (io_tck),
    .q (tap_shift_dr_state_d1)
    );

dff_ns u_dff_tap_update_ir_state_d1
   ( .din (tap_update_ir_state),
     .clk (io_tck),
     .q (tap_update_ir_state_d1)
     );

dff_ns u_dff_tap_update_ir_state_d2
   ( .din (tap_update_ir_state_d1),
     .clk (io_tck),
     .q (tap_update_ir_state_d2)
     );

dff_ns u_dff_instr_iob_rd_d1
   (.din (instr_iob_rd),
    .clk (io_tck),
    .q (instr_iob_rd_d1)
    );

dff_ns u_dff_instr_iob_raddr_d1
   (.din (instr_iob_raddr),
    .clk (io_tck),
    .q (instr_iob_raddr_d1)
    );

dff_ns #(3) u_dff_efc_read_mode
   (.din (next_efc_read_mode),
    .clk (io_tck),
    .q (efc_read_mode)
    );

dff_ns #(5) u_dff_efc_coladdr
   (.din (next_efc_coladdr),
    .clk (io_tck),
    .q (efc_coladdr)
    );

dff_ns #(7) u_dff_efc_rowaddr
   (.din (next_efc_rowaddr),
    .clk (io_tck),
    .q (efc_rowaddr)
    );

dff_ns #(`CTU_BIST_CNT*2) u_dff_bist_result_reg
   (.din (next_bist_result_reg),
    .clk (io_tck),
    .q (bist_result_reg)
    );

dff_ns #(65) u_dff_creg_rdrtrn
   (.din (next_creg_rdrtrn),
    .clk (io_tck),
    .q (creg_rdrtrn)
    );

dff_ns #(64) u_dff_creg_wdata
   (.din (next_creg_wdata),
    .clk (io_tck),
    .q (creg_wdata)
    );

dff_ns #(40) u_dff_creg_addr
   (.din (next_creg_addr),
    .clk (io_tck),
    .q (creg_addr)
    );

dff_ns #(32) u_dff_idcode
   (.din (next_idcode),
    .clk (io_tck),
    .q (idcode)
    );

dff_ns #(JTAG_SDR_CNT_WIDTH) u_dff_cken_dram_wait
   (.din (next_cken_dram_wait),
    .clk (io_tck),
    .q (cken_dram_wait)
    );

dff_ns #(JTAG_SDR_CNT_WIDTH) u_dff_cken_jbus_wait
   (.din (next_cken_jbus_wait),
    .clk (io_tck),
    .q (cken_jbus_wait)
    );

dff_ns #(JTAG_SDR_CNT_WIDTH) u_dff_cken_other_wait
   (.din (next_cken_other_wait),
    .clk (io_tck),
    .q (cken_other_wait)
    );

// bug #5696
dff_ns #(1) u_dff_pads_ctu_si_bypmux_out_ff_nsr
   (.din (pads_ctu_si_bypmux_out),
    .clk (io_tck),
    .q (pads_ctu_si_bypmux_out_ff)
    );




endmodule


// Local Variables:
// verilog-library-directories:(".")
// verilog-library-files:("../common/rtl/ctu_lib.v")
// verilog-auto-sense-defines-constant:t
// End:




