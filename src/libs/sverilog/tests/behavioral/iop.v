// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iop.v
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
`include "sys.h"
`include "iop.h"

module OpenSPARCT1 (/*AUTOARG*/
   // Outputs
   DRAM0_RAS_L, DRAM0_CAS_L, DRAM0_WE_L, DRAM0_CS_L, DRAM0_CKE, 
   DRAM0_ADDR, DRAM0_BA, DRAM0_CK_P, DRAM0_CK_N, DRAM1_RAS_L, 
   DRAM1_CAS_L, DRAM1_WE_L, DRAM1_CS_L, DRAM1_CKE, DRAM1_ADDR, 
   DRAM1_BA, DRAM1_CK_P, DRAM1_CK_N, DRAM2_RAS_L, DRAM2_CAS_L, 
   DRAM2_WE_L, DRAM2_CS_L, DRAM2_CKE, DRAM2_ADDR, DRAM2_BA, 
   DRAM2_CK_P, DRAM2_CK_N, DRAM3_RAS_L, DRAM3_CAS_L, DRAM3_WE_L, 
   DRAM3_CS_L, DRAM3_CKE, DRAM3_ADDR, DRAM3_BA, DRAM3_CK_P, 
   DRAM3_CK_N, J_PACK0, J_PACK1, J_REQ0_OUT_L, J_REQ1_OUT_L, J_ERR, 
   TSR_TESTIO, TDO, 
   // Inouts
   DRAM0_DQ, DRAM0_CB, DRAM0_DQS, SPARE_DDR0_PIN, DRAM1_DQ, DRAM1_CB, 
   DRAM1_DQS, CLKOBS, SPARE_DDR1_PIN, DRAM2_DQ, DRAM2_CB, DRAM2_DQS, 
   SPARE_DDR2_PIN, DRAM3_DQ, DRAM3_CB, DRAM3_DQS, SPARE_DDR3_PIN, 
   J_AD, J_ADP, J_ADTYPE, SPARE_JBUSR_PIN, DBG_DQ, DBG_CK_P, 
   DBG_CK_N, VDDA, VDDBO, VDDCO, VDDTO, VDDL18, VDDR18, DIODE_TOP, 
   DIODE_BOT, VPP, SSI_MISO, SSI_MOSI, SSI_SCK, PMO, VDD_SENSE, 
   VSS_SENSE, SPARE_MISC_PIN, SPARE_MISC_PAD, SPARE_DDR0_PAD, 
   SPARE_DDR1_PAD, SPARE_DDR2_PAD, SPARE_DDR3_PAD, SPARE_DBG_PAD, 
   // Inputs
   DRAM01_P_REF_RES, DRAM01_N_REF_RES, DRAM23_P_REF_RES, 
   DRAM23_N_REF_RES, J_PAR, J_PACK4, J_PACK5, J_REQ4_IN_L, 
   J_REQ5_IN_L, J_RST_L, DTL_L_VREF, DTL_R_VREF, JBUS_P_REF_RES, 
   JBUS_N_REF_RES, DBG_VREF, J_CLK, TCK, TCK2, TRST_L, TDI, TMS, 
   TEST_MODE, TEMP_TRIG, PWRON_RST_L, CLK_STRETCH, DO_BIST, 
   EXT_INT_L, BURNIN, PMI, PGRM_EN, PLL_CHAR_IN, VREG_SELBG_L, 
   TRIGIN, HSTL_VREF
   );

   output               DRAM0_RAS_L;            // From pad_ddr0 of pad_ddr0.v
   output               DRAM0_CAS_L;            // From pad_ddr0 of pad_ddr0.v
   output               DRAM0_WE_L;             // From pad_ddr0 of pad_ddr0.v
   output  [3:0]        DRAM0_CS_L;             // From pad_ddr0 of pad_ddr0.v
   output               DRAM0_CKE;              // From pad_ddr0 of pad_ddr0.v
   output [14:0]        DRAM0_ADDR;             // From pad_ddr0 of pad_ddr0.v
   output  [2:0]        DRAM0_BA;               // From pad_ddr0 of pad_ddr0.v
   inout [127:0]        DRAM0_DQ;               // To/From pad_ddr0 of pad_ddr0.v
   inout  [15:0]        DRAM0_CB;               // To/From pad_ddr0 of pad_ddr0.v
   inout  [35:0]        DRAM0_DQS;              // To/From pad_ddr0 of pad_ddr0.v
   output  [3:0]        DRAM0_CK_P;             // From pad_ddr0 of pad_ddr0.v
   output  [3:0]        DRAM0_CK_N;             // From pad_ddr0 of pad_ddr0.v
   input                DRAM01_P_REF_RES;       // To pad_ddr0 of pad_ddr0.v
   input                DRAM01_N_REF_RES;       // To pad_ddr0 of pad_ddr0.v
   inout                SPARE_DDR0_PIN;         // To/From pad_ddr0 of pad_ddr0.v

   output               DRAM1_RAS_L;            // From pad_ddr1 of pad_ddr1.v
   output               DRAM1_CAS_L;            // From pad_ddr1 of pad_ddr1.v
   output               DRAM1_WE_L;             // From pad_ddr1 of pad_ddr1.v
   output  [3:0]        DRAM1_CS_L;             // From pad_ddr1 of pad_ddr1.v
   output               DRAM1_CKE;              // From pad_ddr1 of pad_ddr1.v
   output [14:0]        DRAM1_ADDR;             // From pad_ddr1 of pad_ddr1.v
   output  [2:0]        DRAM1_BA;               // From pad_ddr1 of pad_ddr1.v
   inout [127:0]        DRAM1_DQ;               // To/From pad_ddr1 of pad_ddr1.v
   inout  [15:0]        DRAM1_CB;               // To/From pad_ddr1 of pad_ddr1.v
   inout  [35:0]        DRAM1_DQS;              // To/From pad_ddr1 of pad_ddr1.v
   output  [3:0]        DRAM1_CK_P;             // From pad_ddr1 of pad_ddr1.v
   output  [3:0]        DRAM1_CK_N;             // From pad_ddr1 of pad_ddr1.v
   input                DRAM23_P_REF_RES;       // To pad_ddr1 of pad_ddr1.v
   input                DRAM23_N_REF_RES;       // To pad_ddr1 of pad_ddr1.v
   inout   [1:0]        CLKOBS;                 // From pad_ddr1 of pad_ddr1.v
   inout   [2:0]        SPARE_DDR1_PIN;         // To/From pad_ddr1 of pad_ddr1.v

   output               DRAM2_RAS_L;            // From pad_ddr2 of pad_ddr2.v
   output               DRAM2_CAS_L;            // From pad_ddr2 of pad_ddr2.v
   output               DRAM2_WE_L;             // From pad_ddr2 of pad_ddr2.v
   output  [3:0]        DRAM2_CS_L;             // From pad_ddr2 of pad_ddr2.v
   output               DRAM2_CKE;              // From pad_ddr2 of pad_ddr2.v
   output [14:0]        DRAM2_ADDR;             // From pad_ddr2 of pad_ddr2.v
   output  [2:0]        DRAM2_BA;               // From pad_ddr2 of pad_ddr2.v
   inout [127:0]        DRAM2_DQ;               // To/From pad_ddr2 of pad_ddr2.v
   inout  [15:0]        DRAM2_CB;               // To/From pad_ddr2 of pad_ddr2.v
   inout  [35:0]        DRAM2_DQS;              // To/From pad_ddr2 of pad_ddr2.v
   output  [3:0]        DRAM2_CK_P;             // From pad_ddr2 of pad_ddr2.v
   output  [3:0]        DRAM2_CK_N;             // From pad_ddr2 of pad_ddr2.v
   inout   [2:0]        SPARE_DDR2_PIN;         // To/From pad_ddr2 of pad_ddr2.v

   output               DRAM3_RAS_L;            // From pad_ddr3 of pad_ddr3.v
   output               DRAM3_CAS_L;            // From pad_ddr3 of pad_ddr3.v
   output               DRAM3_WE_L;             // From pad_ddr3 of pad_ddr3.v
   output  [3:0]        DRAM3_CS_L;             // From pad_ddr3 of pad_ddr3.v
   output               DRAM3_CKE;              // From pad_ddr3 of pad_ddr3.v
   output [14:0]        DRAM3_ADDR;             // From pad_ddr3 of pad_ddr3.v
   output  [2:0]        DRAM3_BA;               // From pad_ddr3 of pad_ddr3.v
   inout [127:0]        DRAM3_DQ;               // To/From pad_ddr3 of pad_ddr3.v
   inout  [15:0]        DRAM3_CB;               // To/From pad_ddr3 of pad_ddr3.v
   inout  [35:0]        DRAM3_DQS;              // To/From pad_ddr3 of pad_ddr3.v
   output  [3:0]        DRAM3_CK_P;             // From pad_ddr3 of pad_ddr3.v
   output  [3:0]        DRAM3_CK_N;             // From pad_ddr3 of pad_ddr3.v
   inout   [2:0]        SPARE_DDR3_PIN;         // To/From pad_ddr3 of pad_ddr3.v

   inout [127:0]        J_AD;                   // To/From pad_jbusl/r of pad_jbusl/r.v
   inout   [3:0]        J_ADP;                  // To/From pad_jbusr of pad_jbusr.v
   inout   [7:0]        J_ADTYPE;               // To/From pad_jbusr of pad_jbusr.v
   input                J_PAR;                  // To/From pad_jbusr of pad_jbusr.v
   output  [2:0]        J_PACK0;                // From pad_jbusr of pad_jbusr.v
   output  [2:0]        J_PACK1;                // From pad_jbusr of pad_jbusr.v
   input   [2:0]        J_PACK4;                // To pad_jbusr of pad_jbusr.v
   input   [2:0]        J_PACK5;                // To pad_jbusr of pad_jbusr.v
   output               J_REQ0_OUT_L;           // From pad_jbusr of pad_jbusr.v
   output               J_REQ1_OUT_L;           // From pad_jbusr of pad_jbusr.v
   input                J_REQ4_IN_L;            // To pad_jbusr of pad_jbusr.v
   input                J_REQ5_IN_L;            // To pad_jbusr of pad_jbusr.v
   output               J_ERR;                  // From pad_jbusr of pad_jbusr.v
   input                J_RST_L;                // To pad_jbusr of pad_jbusr.v
   input                DTL_L_VREF;             // To pad_jbusl of pad_jbusl.v
   input                DTL_R_VREF;             // To pad_jbusr of pad_jbusr.v
   input                JBUS_P_REF_RES;         // To pad_jbusr of pad_jbusr.v
   input                JBUS_N_REF_RES;         // To pad_jbusr of pad_jbusr.v
   inout   [0:0]        SPARE_JBUSR_PIN;        // To/From pad_jbusr of pad_jbusr.v

   inout  [39:0]        DBG_DQ;                 // From pad_dbg of pad_jbusl.v
   inout   [2:0]        DBG_CK_P;               // From pad_dbg of pad_jbusl.v
   inout   [2:0]        DBG_CK_N;               // From pad_dbg of pad_jbusl.v
   input                DBG_VREF;               // To pad_dbg of pad_jbusl.v

   input   [1:0]        J_CLK;                  // To pad_ctu of pad_ctu.v
   output  [1:0]        TSR_TESTIO;             // From pad_ctu of pad_ctu.v
   inout                VDDA;                   //
   inout                VDDBO;                  //
   inout                VDDCO;                  //
   inout                VDDTO;                  //
   inout                VDDL18;                 // Left side - ddr0 and ddr1.
   inout                VDDR18;                 // Right side - ddr2 anbd ddr3.

   inout   [2:0]        DIODE_TOP;              // From pad_diode0 of pad_diode.v

   inout   [2:0]        DIODE_BOT;              // From pad_diode1 of pad_diode.v

   inout                VPP;                    // To/From pad_efc of pad_efc.v

   input                TCK;                    // To pad_misc of pad_misc.v
   input                TCK2;                   // To pad_misc of pad_misc.v
   input                TRST_L;                 // To pad_misc of pad_misc.v
   input                TDI;                    // To pad_misc of pad_misc.v
   output               TDO;                    // From pad_misc of pad_misc.v
   input                TMS;                    // To pad_misc of pad_misc.v
   input                TEST_MODE;              // To pad_misc of pad_misc.v
   input                TEMP_TRIG;              // To pad_misc of pad_misc.v
   input                PWRON_RST_L;            // To pad_misc of pad_misc.v
   inout                SSI_MISO;               // To pad_misc of pad_misc.v
   inout                SSI_MOSI;               // From pad_misc of pad_misc.v
   inout                SSI_SCK;                // From pad_misc of pad_misc.v
   input                CLK_STRETCH;            // To pad_misc of pad_misc.v
   input                DO_BIST;                // To pad_misc of pad_misc.v
   input                EXT_INT_L;              // To pad_misc of pad_misc.v
   input                BURNIN;                 // To pad_misc of pad_misc.v
   input                PMI;                    // To pad_misc of pad_misc.v
   inout                PMO;                    // From pad_misc of pad_misc.v
   input                PGRM_EN;                // To pad_misc of pad_misc.v
   input                PLL_CHAR_IN;            // To pad_misc of pad_misc.v
   input                VREG_SELBG_L;           // To pad_misc of pad_misc.v
   input                TRIGIN;                 // To pad_misc of pad_misc.v
   inout                VDD_SENSE;              // From pad_misc of pad_misc.v
   inout                VSS_SENSE;              // From pad_misc of pad_misc.v
   input                HSTL_VREF;              // To pad_misc of pad_misc.v
   inout                SPARE_MISC_PIN;         // To/From pad_misc of pad_misc.v
   inout   [2:0]        SPARE_MISC_PAD;         // To/From pad_misc of pad_misc.v
   inout   [6:0]        SPARE_DDR0_PAD;         // To/From pad_ddr0 of pad_ddr0.v
   inout   [6:0]        SPARE_DDR1_PAD;         // To/From pad_ddr1 of pad_ddr1.v
   inout   [6:0]        SPARE_DDR2_PAD;         // To/From pad_ddr2 of pad_ddr2.v
   inout   [6:0]        SPARE_DDR3_PAD;         // To/From pad_ddr3 of pad_ddr3.v
   inout  [23:0]        SPARE_DBG_PAD;          // To/From pad_dbg of pad_jbusl.v

   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   // End of automatics

   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   // End of automatics

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			afi_bist_mode;		// To/From v_m_help of v_m_help.v
   wire			afi_bypass_mode;	// To/From v_m_help of v_m_help.v
   wire			afi_pll_char_mode;	// To/From v_m_help of v_m_help.v
   wire			afi_pll_clamp_fltr;	// To/From v_m_help of v_m_help.v
   wire [5:0]		afi_pll_div2;		// To/From v_m_help of v_m_help.v
   wire			afi_pll_trst_l;		// To/From v_m_help of v_m_help.v
   wire [2:0]		afi_rng_ctl;		// To/From v_m_help of v_m_help.v
   wire			afi_rt_addr_data;	// To/From v_m_help of v_m_help.v
   wire [31:0]		afi_rt_data_in;		// To/From v_m_help of v_m_help.v
   wire			afi_rt_high_low;	// To/From v_m_help of v_m_help.v
   wire			afi_rt_read_write;	// To/From v_m_help of v_m_help.v
   wire			afi_rt_valid;		// To/From v_m_help of v_m_help.v
   wire [9:1]		afi_tsr_div;		// To/From v_m_help of v_m_help.v
   wire			afi_tsr_mode;		// To/From v_m_help of v_m_help.v
   wire [7:0]		afi_tsr_tsel;		// To/From v_m_help of v_m_help.v
   wire			afo_rng_clk;		// To/From v_m_help of v_m_help.v, ...
   wire			afo_rng_data;		// To/From v_m_help of v_m_help.v, ...
   wire			afo_rt_ack;		// To/From v_m_help of v_m_help.v, ...
   wire [31:0]		afo_rt_data_out;	// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		afo_tsr_dout;		// To/From v_m_help of v_m_help.v, ...
   wire			ccx_rclk;		// From ccx of ccx.v
   wire [`CLK_IOB_WIDTH-1:0]clsp_iob_data;	// From ctu of ctu.v
   wire			clsp_iob_stall;		// From ctu of ctu.v
   wire			clsp_iob_vld;		// From ctu of ctu.v
   wire			cmp_adbginit_l;		// From ctu of ctu.v
   wire			cmp_arst_l;		// From ctu of ctu.v
   wire			cmp_gclk;		// From ctu of ctu.v
   wire [7:0]		cmp_gclk_c0_r;		// From bw_clk_gl of bw_clk_gl.v
   wire [7:0]		cmp_gclk_c1_r;		// From bw_clk_gl of bw_clk_gl.v
   wire [7:0]		cmp_gclk_c2_r;		// From bw_clk_gl of bw_clk_gl.v
   wire [7:0]		cmp_gclk_c3_r;		// From bw_clk_gl of bw_clk_gl.v
   wire			cmp_gdbginit_out_l;	// From ctu of ctu.v
   wire			cmp_grst_out_l;		// From ctu of ctu.v
   wire [7:0]		cpx_iob_grant_cx2;	// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		cpx_sctag0_grant_cx;	// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		cpx_sctag1_grant_cx;	// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		cpx_sctag2_grant_cx;	// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		cpx_sctag3_grant_cx;	// To/From v_m_help of v_m_help.v, ...
   wire [`CPX_WIDTH-1:0]cpx_spc0_data_cx2;	// From ccx of ccx.v
   wire [`CPX_WIDTH-1:0]cpx_spc0_data_cx2_buf1;	// From ccx_spc_rpt0 of ccx_spc_rpt.v
   wire			cpx_spc0_data_rdy_cx2;	// From ccx of ccx.v
   wire			cpx_spc0_data_rdy_cx2_buf1;// From ccx_spc_rpt0 of ccx_spc_rpt.v
   wire [`CPX_WIDTH-1:0]cpx_spc1_data_cx2;	// From ccx of ccx.v
   wire [`CPX_WIDTH-1:0]cpx_spc1_data_cx2_buf1;	// From ccx_spc_rpt1 of ccx_spc_rpt.v
   wire			cpx_spc1_data_rdy_cx2;	// From ccx of ccx.v
   wire			cpx_spc1_data_rdy_cx2_buf1;// From ccx_spc_rpt1 of ccx_spc_rpt.v
   wire [`CPX_WIDTH-1:0]cpx_spc2_data_cx2;	// From ccx of ccx.v
   wire [`CPX_WIDTH-1:0]cpx_spc2_data_cx2_buf1;	// From ccx_spc_rpt2 of ccx_spc_rpt.v
   wire			cpx_spc2_data_rdy_cx2;	// From ccx of ccx.v
   wire			cpx_spc2_data_rdy_cx2_buf1;// From ccx_spc_rpt2 of ccx_spc_rpt.v
   wire [`CPX_WIDTH-1:0]cpx_spc3_data_cx2;	// From ccx of ccx.v
   wire [`CPX_WIDTH-1:0]cpx_spc3_data_cx2_buf1;	// From ccx_spc_rpt3 of ccx_spc_rpt.v
   wire			cpx_spc3_data_rdy_cx2;	// From ccx of ccx.v
   wire			cpx_spc3_data_rdy_cx2_buf1;// From ccx_spc_rpt3 of ccx_spc_rpt.v
   wire [`CPX_WIDTH-1:0]cpx_spc4_data_cx2;	// From ccx of ccx.v
   wire [`CPX_WIDTH-1:0]cpx_spc4_data_cx2_buf1;	// From ccx_spc_rpt4 of ccx_spc_rpt.v
   wire			cpx_spc4_data_rdy_cx2;	// From ccx of ccx.v
   wire			cpx_spc4_data_rdy_cx2_buf1;// From ccx_spc_rpt4 of ccx_spc_rpt.v
   wire [`CPX_WIDTH-1:0]cpx_spc5_data_cx2;	// From ccx of ccx.v
   wire [`CPX_WIDTH-1:0]cpx_spc5_data_cx2_buf1;	// From ccx_spc_rpt5 of ccx_spc_rpt.v
   wire			cpx_spc5_data_rdy_cx2;	// From ccx of ccx.v
   wire			cpx_spc5_data_rdy_cx2_buf1;// From ccx_spc_rpt5 of ccx_spc_rpt.v
   wire [`CPX_WIDTH-1:0]cpx_spc6_data_cx2;	// From ccx of ccx.v
   wire [`CPX_WIDTH-1:0]cpx_spc6_data_cx2_buf1;	// From ccx_spc_rpt6 of ccx_spc_rpt.v
   wire			cpx_spc6_data_rdy_cx2;	// From ccx of ccx.v
   wire			cpx_spc6_data_rdy_cx2_buf1;// From ccx_spc_rpt6 of ccx_spc_rpt.v
   wire [`CPX_WIDTH-1:0]cpx_spc7_data_cx2;	// From ccx of ccx.v
   wire [`CPX_WIDTH-1:0]cpx_spc7_data_cx2_buf1;	// From ccx_spc_rpt7 of ccx_spc_rpt.v
   wire			cpx_spc7_data_rdy_cx2;	// From ccx of ccx.v
   wire			cpx_spc7_data_rdy_cx2_buf1;// From ccx_spc_rpt7 of ccx_spc_rpt.v
   wire			ctu_ccx_cmp_cken;	// From ctu of ctu.v
   wire			ctu_dbg_jbus_cken;	// From ctu of ctu.v
   wire			ctu_ddr0_clock_dr;	// From ctu of ctu.v
   wire [2:0]		ctu_ddr0_dll_delayctr;	// From ctu of ctu.v
   wire			ctu_ddr0_dram_cken;	// From ctu of ctu.v
   wire			ctu_ddr0_hiz_l;		// From ctu of ctu.v
   wire			ctu_ddr0_iodll_rst_l;	// From ctu of ctu.v
   wire			ctu_ddr0_mode_ctl;	// From ctu of ctu.v
   wire			ctu_ddr0_shift_dr;	// From ctu of ctu.v
   wire			ctu_ddr0_update_dr;	// From ctu of ctu.v
   wire			ctu_ddr1_bso;		// From ctu of ctu.v
   wire			ctu_ddr1_clock_dr;	// From ctu of ctu.v
   wire [2:0]		ctu_ddr1_dll_delayctr;	// From ctu of ctu.v
   wire			ctu_ddr1_dram_cken;	// From ctu of ctu.v
   wire			ctu_ddr1_hiz_l;		// From ctu of ctu.v
   wire			ctu_ddr1_iodll_rst_l;	// From ctu of ctu.v
   wire			ctu_ddr1_mode_ctl;	// From ctu of ctu.v
   wire			ctu_ddr1_shift_dr;	// From ctu of ctu.v
   wire			ctu_ddr1_update_dr;	// From ctu of ctu.v
   wire			ctu_ddr2_clock_dr;	// From ctu of ctu.v
   wire [2:0]		ctu_ddr2_dll_delayctr;	// From ctu of ctu.v
   wire			ctu_ddr2_dram_cken;	// From ctu of ctu.v
   wire			ctu_ddr2_hiz_l;		// From ctu of ctu.v
   wire			ctu_ddr2_iodll_rst_l;	// From ctu of ctu.v
   wire			ctu_ddr2_mode_ctl;	// From ctu of ctu.v
   wire			ctu_ddr2_shift_dr;	// From ctu of ctu.v
   wire			ctu_ddr2_update_dr;	// From ctu of ctu.v
   wire			ctu_ddr3_clock_dr;	// From ctu of ctu.v
   wire [2:0]		ctu_ddr3_dll_delayctr;	// From ctu of ctu.v
   wire			ctu_ddr3_dram_cken;	// From ctu of ctu.v
   wire			ctu_ddr3_hiz_l;		// From ctu of ctu.v
   wire			ctu_ddr3_iodll_rst_l;	// From ctu of ctu.v
   wire			ctu_ddr3_mode_ctl;	// From ctu of ctu.v
   wire			ctu_ddr3_shift_dr;	// From ctu of ctu.v
   wire			ctu_ddr3_update_dr;	// From ctu of ctu.v
   wire			ctu_ddr_testmode_l;	// From ctu of ctu.v
   wire			ctu_debug_clock_dr;	// From ctu of ctu.v
   wire			ctu_debug_hiz_l;	// From ctu of ctu.v
   wire			ctu_debug_mode_ctl;	// From ctu of ctu.v
   wire			ctu_debug_shift_dr;	// From ctu of ctu.v
   wire			ctu_debug_update_dr;	// From ctu of ctu.v
   wire			ctu_dll0_byp_l;		// From ctu of ctu.v
   wire [4:0]		ctu_dll0_byp_val;	// From ctu of ctu.v
   wire [4:0]		ctu_dll0_ctu_ctrl;	// From pad_ddr0 of pad_ddr0.v
   wire			ctu_dll1_byp_l;		// From ctu of ctu.v
   wire [4:0]		ctu_dll1_byp_val;	// From ctu of ctu.v
   wire [4:0]		ctu_dll1_ctu_ctrl;	// From pad_ddr1 of pad_ddr1.v
   wire			ctu_dll2_byp_l;		// From ctu of ctu.v
   wire [4:0]		ctu_dll2_byp_val;	// From ctu of ctu.v
   wire [4:0]		ctu_dll2_ctu_ctrl;	// From pad_ddr2 of pad_ddr2.v
   wire			ctu_dll3_byp_l;		// From ctu of ctu.v
   wire [4:0]		ctu_dll3_byp_val;	// From ctu of ctu.v
   wire [4:0]		ctu_dll3_ctu_ctrl;	// From pad_ddr3 of pad_ddr3.v
   wire			ctu_dram02_cmp_cken;	// From ctu of ctu.v
   wire			ctu_dram02_dram_cken;	// From ctu of ctu.v
   wire			ctu_dram02_jbus_cken;	// From ctu of ctu.v
   wire			ctu_dram13_cmp_cken;	// From ctu of ctu.v
   wire			ctu_dram13_dram_cken;	// From ctu of ctu.v
   wire			ctu_dram13_jbus_cken;	// From ctu of ctu.v
   wire			ctu_dram_rx_sync_out;	// From ctu of ctu.v
   wire			ctu_dram_selfrsh;	// From ctu of ctu.v
   wire			ctu_dram_tx_sync_out;	// From ctu of ctu.v
   wire			ctu_efc_capturedr;	// From ctu of ctu.v
   wire [4:0]		ctu_efc_coladdr;	// From ctu of ctu.v
   wire			ctu_efc_data_in;	// From ctu of ctu.v
   wire			ctu_efc_dest_sample;	// From ctu of ctu.v
   wire			ctu_efc_fuse_bypass;	// From ctu of ctu.v
   wire			ctu_efc_jbus_cken;	// From ctu of ctu.v
   wire			ctu_efc_read_en;	// From ctu of ctu.v
   wire [2:0]		ctu_efc_read_mode;	// From ctu of ctu.v
   wire			ctu_efc_read_start;	// From ctu of ctu.v
   wire [6:0]		ctu_efc_rowaddr;	// From ctu of ctu.v
   wire			ctu_efc_shiftdr;	// From ctu of ctu.v
   wire			ctu_efc_tck;		// From ctu of ctu.v
   wire			ctu_efc_updatedr;	// From ctu of ctu.v
   wire			ctu_fpu_cmp_cken;	// From ctu of ctu.v
   wire			ctu_global_snap;	// From ctu of ctu.v
   wire [1:0]		ctu_io_clkobs;		// From ctu of ctu.v
   wire			ctu_io_j_err;		// From ctu of ctu.v
   wire			ctu_io_tdo;		// From ctu of ctu.v
   wire			ctu_io_tdo_en;		// From ctu of ctu.v
   wire			ctu_iob_cmp_cken;	// From ctu of ctu.v
   wire			ctu_iob_jbus_cken;	// From ctu of ctu.v
   wire [2:0]		ctu_iob_resetstat;	// From ctu of ctu.v
   wire			ctu_iob_resetstat_wr;	// From ctu of ctu.v
   wire			ctu_iob_wake_thr;	// From ctu of ctu.v
   wire			ctu_jbi_cmp_cken;	// From ctu of ctu.v
   wire			ctu_jbi_jbus_cken;	// From ctu of ctu.v
   wire			ctu_jbi_ssiclk;		// From ctu of ctu.v
   wire			ctu_jbus_rx_sync_out;	// From ctu of ctu.v
   wire			ctu_jbus_tx_sync_out;	// From ctu of ctu.v
   wire			ctu_jbusl_clock_dr;	// From ctu of ctu.v
   wire			ctu_jbusl_hiz_l;	// From ctu of ctu.v
   wire			ctu_jbusl_jbus_cken;	// From ctu of ctu.v
   wire			ctu_jbusl_mode_ctl;	// From ctu of ctu.v
   wire			ctu_jbusl_shift_dr;	// From ctu of ctu.v
   wire			ctu_jbusl_update_dr;	// From ctu of ctu.v
   wire			ctu_jbusr_clock_dr;	// From ctu of ctu.v
   wire			ctu_jbusr_hiz_l;	// From ctu of ctu.v
   wire			ctu_jbusr_jbus_cken;	// From ctu of ctu.v
   wire			ctu_jbusr_mode_ctl;	// From ctu of ctu.v
   wire			ctu_jbusr_shift_dr;	// From ctu of ctu.v
   wire			ctu_jbusr_update_dr;	// From ctu of ctu.v
   wire			ctu_misc_clock_dr;	// From ctu of ctu.v
   wire			ctu_misc_hiz_l;		// From ctu of ctu.v
   wire			ctu_misc_jbus_cken;	// From ctu of ctu.v
   wire			ctu_misc_mode_ctl;	// From ctu of ctu.v
   wire			ctu_misc_shift_dr;	// From ctu of ctu.v
   wire			ctu_misc_update_dr;	// From ctu of ctu.v
   wire			ctu_pads_sscan_update;	// From ctu of ctu.v
   wire			ctu_rtop2_so;		// From ctu of ctu.v
   wire			ctu_scdata0_cmp_cken;	// From ctu of ctu.v
   wire			ctu_scdata1_cmp_cken;	// From ctu of ctu.v
   wire			ctu_scdata2_cmp_cken;	// From ctu of ctu.v
   wire			ctu_scdata3_cmp_cken;	// From ctu of ctu.v
   wire			ctu_sctag0_cmp_cken;	// From ctu of ctu.v
   wire			ctu_sctag0_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_sctag0_mbisten_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			ctu_sctag1_cmp_cken;	// From ctu of ctu.v
   wire			ctu_sctag1_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_sctag1_mbisten_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			ctu_sctag2_cmp_cken;	// From ctu of ctu.v
   wire			ctu_sctag2_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_sctag2_mbisten_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			ctu_sctag3_cmp_cken;	// From ctu of ctu.v
   wire			ctu_sctag3_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_sctag3_mbisten_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc0_cmp_cken;	// From ctu of ctu.v
   wire			ctu_spc0_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc0_mbisten_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc0_sscan_se;	// From ctu of ctu.v
   wire			ctu_spc0_tck;		// From ctu of ctu.v
   wire			ctu_spc1_cmp_cken;	// From ctu of ctu.v
   wire			ctu_spc1_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc1_mbisten_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc1_sscan_se;	// From ctu of ctu.v
   wire			ctu_spc1_tck;		// From ctu of ctu.v
   wire			ctu_spc2_cmp_cken;	// From ctu of ctu.v
   wire			ctu_spc2_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc2_mbisten_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc2_sscan_se;	// From ctu of ctu.v
   wire			ctu_spc2_tck;		// From ctu of ctu.v
   wire			ctu_spc3_cmp_cken;	// From ctu of ctu.v
   wire			ctu_spc3_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc3_mbisten_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc3_sscan_se;	// From ctu of ctu.v
   wire			ctu_spc3_tck;		// From ctu of ctu.v
   wire			ctu_spc4_cmp_cken;	// From ctu of ctu.v
   wire			ctu_spc4_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc4_mbisten_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc4_sscan_se;	// From ctu of ctu.v
   wire			ctu_spc4_tck;		// From ctu of ctu.v
   wire			ctu_spc5_cmp_cken;	// From ctu of ctu.v
   wire			ctu_spc5_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc5_mbisten_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc5_sscan_se;	// From ctu of ctu.v
   wire			ctu_spc5_tck;		// From ctu of ctu.v
   wire			ctu_spc6_cmp_cken;	// From ctu of ctu.v
   wire			ctu_spc6_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc6_mbisten_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc6_sscan_se;	// From ctu of ctu.v
   wire			ctu_spc6_tck;		// From ctu of ctu.v
   wire			ctu_spc7_cmp_cken;	// From ctu of ctu.v
   wire			ctu_spc7_mbisten;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc7_mbisten_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			ctu_spc7_sscan_se;	// From ctu of ctu.v
   wire			ctu_spc7_tck;		// From ctu of ctu.v
   wire [7:0]		ctu_spc_const_maskid;	// From ctu of ctu.v
   wire [3:0]		ctu_spc_sscan_tid;	// From ctu of ctu.v
   wire			ctu_tst_macrotest;	// From ctu of ctu.v
   wire			ctu_tst_pre_grst_l;	// From ctu of ctu.v
   wire			ctu_tst_scan_disable;	// From ctu of ctu.v
   wire			ctu_tst_scanmode;	// From ctu of ctu.v
   wire			ctu_tst_short_chain;	// From ctu of ctu.v
   wire			dbg_ddr0_bso;		// From pad_dbg of pad_jbusl.v
   wire			dbg_en_01;		// From sc_0_1_dbg_rptr of sc_0_1_dbg_rptr.v
   wire			dbg_en_23;		// From sc_2_3_dbg_rptr of sc_2_3_dbg_rptr.v
   wire			ddr0_ctu_bso;		// From pad_ddr0 of pad_ddr0.v
   wire			ddr0_ctu_dll_lock;	// From pad_ddr0 of pad_ddr0.v
   wire			ddr0_ctu_dll_overflow;	// From pad_ddr0 of pad_ddr0.v
   wire			ddr0_ddr0_bso;		// From pad_ddr0 of pad_ddr0.v
   wire [8:1]		ddr0_ddr1_cbd;		// From pad_ddr0 of pad_ddr0.v
   wire [8:1]		ddr0_ddr1_cbu;		// From pad_ddr0 of pad_ddr0.v
   wire			ddr1_ctu_dll_lock;	// From pad_ddr1 of pad_ddr1.v
   wire			ddr1_ctu_dll_overflow;	// From pad_ddr1 of pad_ddr1.v
   wire			ddr1_jbusl_bso;		// From pad_ddr1 of pad_ddr1.v
   wire			ddr2_ctu_dll_lock;	// From pad_ddr2 of pad_ddr2.v
   wire			ddr2_ctu_dll_overflow;	// From pad_ddr2 of pad_ddr2.v
   wire			ddr2_ddr2_bso;		// From pad_ddr2 of pad_ddr2.v
   wire [8:1]		ddr2_ddr3_cbd;		// From pad_ddr2 of pad_ddr2.v
   wire [8:1]		ddr2_ddr3_cbu;		// From pad_ddr2 of pad_ddr2.v
   wire			ddr2_misc_sscan_out;	// From pad_ddr2 of pad_ddr2.v
   wire			ddr3_ctu_dll_lock;	// From pad_ddr3 of pad_ddr3.v
   wire			ddr3_ctu_dll_overflow;	// From pad_ddr3 of pad_ddr3.v
   wire			ddr3_ddr2_bso;		// From pad_ddr3 of pad_ddr3.v
   wire			dram02_ctu_tr;		// From dram02 of dram.v
   wire [3:0]		dram02_iob_data;	// From dram02 of dram.v
   wire			dram02_iob_stall;	// From dram02 of dram.v
   wire			dram02_iob_vld;		// From dram02 of dram.v
   wire [127:0]		dram02_scbuf0_data_r2;	// From dram02 of dram.v
   wire [127:0]		dram02_scbuf0_data_r2_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire [127:0]		dram02_scbuf0_data_r2_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire [127:0]		dram02_scbuf0_data_r2_buf3;// From dram_sc_0_rep3 of dram_l2_buf2.v
   wire [127:0]		dram02_scbuf0_data_r2_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire [27:0]		dram02_scbuf0_ecc_r2;	// From dram02 of dram.v
   wire [27:0]		dram02_scbuf0_ecc_r2_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire [27:0]		dram02_scbuf0_ecc_r2_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire [27:0]		dram02_scbuf0_ecc_r2_buf3;// From dram_sc_0_rep3 of dram_l2_buf2.v
   wire [27:0]		dram02_scbuf0_ecc_r2_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire [127:0]		dram02_scbuf2_data_r2;	// From dram02 of dram.v
   wire [127:0]		dram02_scbuf2_data_r2_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire [127:0]		dram02_scbuf2_data_r2_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire [127:0]		dram02_scbuf2_data_r2_buf3;// From dram_sc_2_rep3 of dram_l2_buf2.v
   wire [127:0]		dram02_scbuf2_data_r2_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire [27:0]		dram02_scbuf2_ecc_r2;	// From dram02 of dram.v
   wire [27:0]		dram02_scbuf2_ecc_r2_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire [27:0]		dram02_scbuf2_ecc_r2_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire [27:0]		dram02_scbuf2_ecc_r2_buf3;// From dram_sc_2_rep3 of dram_l2_buf2.v
   wire [27:0]		dram02_scbuf2_ecc_r2_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire [1:0]		dram02_sctag0_chunk_id_r0;// From dram02 of dram.v
   wire [1:0]		dram02_sctag0_chunk_id_r0_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire [1:0]		dram02_sctag0_chunk_id_r0_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire [1:0]		dram02_sctag0_chunk_id_r0_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			dram02_sctag0_data_vld_r0;// From dram02 of dram.v
   wire			dram02_sctag0_data_vld_r0_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			dram02_sctag0_data_vld_r0_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			dram02_sctag0_data_vld_r0_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			dram02_sctag0_mecc_err_r2;// From dram02 of dram.v
   wire			dram02_sctag0_mecc_err_r2_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			dram02_sctag0_mecc_err_r2_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			dram02_sctag0_mecc_err_r2_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			dram02_sctag0_rd_ack;	// From dram02 of dram.v
   wire			dram02_sctag0_rd_ack_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			dram02_sctag0_rd_ack_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			dram02_sctag0_rd_ack_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire [2:0]		dram02_sctag0_rd_req_id_r0;// From dram02 of dram.v
   wire [2:0]		dram02_sctag0_rd_req_id_r0_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire [2:0]		dram02_sctag0_rd_req_id_r0_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire [2:0]		dram02_sctag0_rd_req_id_r0_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			dram02_sctag0_scb_mecc_err;// From dram02 of dram.v
   wire			dram02_sctag0_scb_mecc_err_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			dram02_sctag0_scb_mecc_err_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			dram02_sctag0_scb_mecc_err_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			dram02_sctag0_scb_secc_err;// From dram02 of dram.v
   wire			dram02_sctag0_scb_secc_err_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			dram02_sctag0_scb_secc_err_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			dram02_sctag0_scb_secc_err_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			dram02_sctag0_secc_err_r2;// From dram02 of dram.v
   wire			dram02_sctag0_secc_err_r2_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			dram02_sctag0_secc_err_r2_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			dram02_sctag0_secc_err_r2_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			dram02_sctag0_wr_ack;	// From dram02 of dram.v
   wire			dram02_sctag0_wr_ack_buf1;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			dram02_sctag0_wr_ack_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			dram02_sctag0_wr_ack_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire [1:0]		dram02_sctag2_chunk_id_r0;// From dram02 of dram.v
   wire [1:0]		dram02_sctag2_chunk_id_r0_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire [1:0]		dram02_sctag2_chunk_id_r0_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire [1:0]		dram02_sctag2_chunk_id_r0_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			dram02_sctag2_data_vld_r0;// From dram02 of dram.v
   wire			dram02_sctag2_data_vld_r0_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			dram02_sctag2_data_vld_r0_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			dram02_sctag2_data_vld_r0_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			dram02_sctag2_mecc_err_r2;// From dram02 of dram.v
   wire			dram02_sctag2_mecc_err_r2_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			dram02_sctag2_mecc_err_r2_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			dram02_sctag2_mecc_err_r2_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			dram02_sctag2_rd_ack;	// From dram02 of dram.v
   wire			dram02_sctag2_rd_ack_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			dram02_sctag2_rd_ack_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			dram02_sctag2_rd_ack_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire [2:0]		dram02_sctag2_rd_req_id_r0;// From dram02 of dram.v
   wire [2:0]		dram02_sctag2_rd_req_id_r0_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire [2:0]		dram02_sctag2_rd_req_id_r0_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire [2:0]		dram02_sctag2_rd_req_id_r0_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			dram02_sctag2_scb_mecc_err;// From dram02 of dram.v
   wire			dram02_sctag2_scb_mecc_err_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			dram02_sctag2_scb_mecc_err_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			dram02_sctag2_scb_mecc_err_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			dram02_sctag2_scb_secc_err;// From dram02 of dram.v
   wire			dram02_sctag2_scb_secc_err_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			dram02_sctag2_scb_secc_err_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			dram02_sctag2_scb_secc_err_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			dram02_sctag2_secc_err_r2;// From dram02 of dram.v
   wire			dram02_sctag2_secc_err_r2_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			dram02_sctag2_secc_err_r2_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			dram02_sctag2_secc_err_r2_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			dram02_sctag2_wr_ack;	// From dram02 of dram.v
   wire			dram02_sctag2_wr_ack_buf1;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			dram02_sctag2_wr_ack_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			dram02_sctag2_wr_ack_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire [14:0]		dram0_io_addr;		// To/From v_m_help of v_m_help.v, ...
   wire [2:0]		dram0_io_bank;		// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_cas_l;		// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_cas_l_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram0_io_channel_disabled;// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_channel_disabled_buf2;// To/From v_m_help of v_m_help.v
   wire			dram0_io_cke;		// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_cke_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram0_io_clk_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_clk_enable_buf2;// To/From v_m_help of v_m_help.v
   wire [3:0]		dram0_io_cs_l;		// To/From v_m_help of v_m_help.v, ...
   wire [287:0]		dram0_io_data_out;	// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_drive_data;	// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_drive_data_buf2;// To/From v_m_help of v_m_help.v
   wire			dram0_io_drive_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_drive_enable_buf2;// To/From v_m_help of v_m_help.v
   wire			dram0_io_pad_clk_inv;	// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_pad_clk_inv_buf2;// To/From v_m_help of v_m_help.v
   wire			dram0_io_pad_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_pad_enable_buf2;// To/From v_m_help of v_m_help.v
   wire [4:0]		dram0_io_ptr_clk_inv;	// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_ras_l;		// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_ras_l_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram0_io_write_en_l;	// To/From v_m_help of v_m_help.v, ...
   wire			dram0_io_write_en_l_buf2;// To/From v_m_help of v_m_help.v
   wire			dram13_ctu_tr;		// From dram13 of dram.v
   wire [3:0]		dram13_iob_data;	// From dram13 of dram.v
   wire			dram13_iob_stall;	// From dram13 of dram.v
   wire			dram13_iob_vld;		// From dram13 of dram.v
   wire [127:0]		dram13_scbuf1_data_r2;	// From dram13 of dram.v
   wire [127:0]		dram13_scbuf1_data_r2_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire [127:0]		dram13_scbuf1_data_r2_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire [127:0]		dram13_scbuf1_data_r2_buf3;// From dram_sc_1_rep3 of dram_l2_buf2.v
   wire [127:0]		dram13_scbuf1_data_r2_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire [27:0]		dram13_scbuf1_ecc_r2;	// From dram13 of dram.v
   wire [27:0]		dram13_scbuf1_ecc_r2_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire [27:0]		dram13_scbuf1_ecc_r2_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire [27:0]		dram13_scbuf1_ecc_r2_buf3;// From dram_sc_1_rep3 of dram_l2_buf2.v
   wire [27:0]		dram13_scbuf1_ecc_r2_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire [127:0]		dram13_scbuf3_data_r2;	// From dram13 of dram.v
   wire [127:0]		dram13_scbuf3_data_r2_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire [127:0]		dram13_scbuf3_data_r2_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire [127:0]		dram13_scbuf3_data_r2_buf3;// From dram_sc_3_rep3 of dram_l2_buf2.v
   wire [127:0]		dram13_scbuf3_data_r2_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire [27:0]		dram13_scbuf3_ecc_r2;	// From dram13 of dram.v
   wire [27:0]		dram13_scbuf3_ecc_r2_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire [27:0]		dram13_scbuf3_ecc_r2_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire [27:0]		dram13_scbuf3_ecc_r2_buf3;// From dram_sc_3_rep3 of dram_l2_buf2.v
   wire [27:0]		dram13_scbuf3_ecc_r2_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire [1:0]		dram13_sctag1_chunk_id_r0;// From dram13 of dram.v
   wire [1:0]		dram13_sctag1_chunk_id_r0_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire [1:0]		dram13_sctag1_chunk_id_r0_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire [1:0]		dram13_sctag1_chunk_id_r0_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			dram13_sctag1_data_vld_r0;// From dram13 of dram.v
   wire			dram13_sctag1_data_vld_r0_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			dram13_sctag1_data_vld_r0_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			dram13_sctag1_data_vld_r0_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			dram13_sctag1_mecc_err_r2;// From dram13 of dram.v
   wire			dram13_sctag1_mecc_err_r2_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			dram13_sctag1_mecc_err_r2_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			dram13_sctag1_mecc_err_r2_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			dram13_sctag1_rd_ack;	// From dram13 of dram.v
   wire			dram13_sctag1_rd_ack_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			dram13_sctag1_rd_ack_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			dram13_sctag1_rd_ack_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire [2:0]		dram13_sctag1_rd_req_id_r0;// From dram13 of dram.v
   wire [2:0]		dram13_sctag1_rd_req_id_r0_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire [2:0]		dram13_sctag1_rd_req_id_r0_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire [2:0]		dram13_sctag1_rd_req_id_r0_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			dram13_sctag1_scb_mecc_err;// From dram13 of dram.v
   wire			dram13_sctag1_scb_mecc_err_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			dram13_sctag1_scb_mecc_err_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			dram13_sctag1_scb_mecc_err_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			dram13_sctag1_scb_secc_err;// From dram13 of dram.v
   wire			dram13_sctag1_scb_secc_err_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			dram13_sctag1_scb_secc_err_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			dram13_sctag1_scb_secc_err_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			dram13_sctag1_secc_err_r2;// From dram13 of dram.v
   wire			dram13_sctag1_secc_err_r2_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			dram13_sctag1_secc_err_r2_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			dram13_sctag1_secc_err_r2_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			dram13_sctag1_wr_ack;	// From dram13 of dram.v
   wire			dram13_sctag1_wr_ack_buf1;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			dram13_sctag1_wr_ack_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			dram13_sctag1_wr_ack_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire [1:0]		dram13_sctag3_chunk_id_r0;// From dram13 of dram.v
   wire [1:0]		dram13_sctag3_chunk_id_r0_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire [1:0]		dram13_sctag3_chunk_id_r0_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire [1:0]		dram13_sctag3_chunk_id_r0_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			dram13_sctag3_data_vld_r0;// From dram13 of dram.v
   wire			dram13_sctag3_data_vld_r0_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			dram13_sctag3_data_vld_r0_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			dram13_sctag3_data_vld_r0_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			dram13_sctag3_mecc_err_r2;// From dram13 of dram.v
   wire			dram13_sctag3_mecc_err_r2_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			dram13_sctag3_mecc_err_r2_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			dram13_sctag3_mecc_err_r2_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			dram13_sctag3_rd_ack;	// From dram13 of dram.v
   wire			dram13_sctag3_rd_ack_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			dram13_sctag3_rd_ack_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			dram13_sctag3_rd_ack_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire [2:0]		dram13_sctag3_rd_req_id_r0;// From dram13 of dram.v
   wire [2:0]		dram13_sctag3_rd_req_id_r0_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire [2:0]		dram13_sctag3_rd_req_id_r0_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire [2:0]		dram13_sctag3_rd_req_id_r0_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			dram13_sctag3_scb_mecc_err;// From dram13 of dram.v
   wire			dram13_sctag3_scb_mecc_err_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			dram13_sctag3_scb_mecc_err_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			dram13_sctag3_scb_mecc_err_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			dram13_sctag3_scb_secc_err;// From dram13 of dram.v
   wire			dram13_sctag3_scb_secc_err_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			dram13_sctag3_scb_secc_err_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			dram13_sctag3_scb_secc_err_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			dram13_sctag3_secc_err_r2;// From dram13 of dram.v
   wire			dram13_sctag3_secc_err_r2_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			dram13_sctag3_secc_err_r2_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			dram13_sctag3_secc_err_r2_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			dram13_sctag3_wr_ack;	// From dram13 of dram.v
   wire			dram13_sctag3_wr_ack_buf1;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			dram13_sctag3_wr_ack_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			dram13_sctag3_wr_ack_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire [14:0]		dram1_io_addr;		// To/From v_m_help of v_m_help.v, ...
   wire [2:0]		dram1_io_bank;		// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_cas_l;		// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_cas_l_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram1_io_channel_disabled;// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_channel_disabled_buf2;// To/From v_m_help of v_m_help.v
   wire			dram1_io_cke;		// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_cke_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram1_io_clk_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_clk_enable_buf2;// To/From v_m_help of v_m_help.v
   wire [3:0]		dram1_io_cs_l;		// To/From v_m_help of v_m_help.v, ...
   wire [287:0]		dram1_io_data_out;	// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_drive_data;	// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_drive_data_buf2;// To/From v_m_help of v_m_help.v
   wire			dram1_io_drive_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_drive_enable_buf2;// To/From v_m_help of v_m_help.v
   wire			dram1_io_pad_clk_inv;	// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_pad_clk_inv_buf2;// To/From v_m_help of v_m_help.v
   wire			dram1_io_pad_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_pad_enable_buf2;// To/From v_m_help of v_m_help.v
   wire [4:0]		dram1_io_ptr_clk_inv;	// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_ras_l;		// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_ras_l_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram1_io_write_en_l;	// To/From v_m_help of v_m_help.v, ...
   wire			dram1_io_write_en_l_buf2;// To/From v_m_help of v_m_help.v
   wire [14:0]		dram2_io_addr;		// To/From v_m_help of v_m_help.v, ...
   wire [2:0]		dram2_io_bank;		// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_cas_l;		// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_cas_l_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram2_io_channel_disabled;// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_channel_disabled_buf2;// To/From v_m_help of v_m_help.v
   wire			dram2_io_cke;		// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_cke_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram2_io_clk_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_clk_enable_buf2;// To/From v_m_help of v_m_help.v
   wire [3:0]		dram2_io_cs_l;		// To/From v_m_help of v_m_help.v, ...
   wire [287:0]		dram2_io_data_out;	// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_drive_data;	// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_drive_data_buf2;// To/From v_m_help of v_m_help.v
   wire			dram2_io_drive_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_drive_enable_buf2;// To/From v_m_help of v_m_help.v
   wire			dram2_io_pad_clk_inv;	// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_pad_clk_inv_buf2;// To/From v_m_help of v_m_help.v
   wire			dram2_io_pad_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_pad_enable_buf2;// To/From v_m_help of v_m_help.v
   wire [4:0]		dram2_io_ptr_clk_inv;	// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_ras_l;		// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_ras_l_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram2_io_write_en_l;	// To/From v_m_help of v_m_help.v, ...
   wire			dram2_io_write_en_l_buf2;// To/From v_m_help of v_m_help.v
   wire [14:0]		dram3_io_addr;		// To/From v_m_help of v_m_help.v, ...
   wire [2:0]		dram3_io_bank;		// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_cas_l;		// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_cas_l_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram3_io_channel_disabled;// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_channel_disabled_buf2;// To/From v_m_help of v_m_help.v
   wire			dram3_io_cke;		// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_cke_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram3_io_clk_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_clk_enable_buf2;// To/From v_m_help of v_m_help.v
   wire [3:0]		dram3_io_cs_l;		// To/From v_m_help of v_m_help.v, ...
   wire [287:0]		dram3_io_data_out;	// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_drive_data;	// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_drive_data_buf2;// To/From v_m_help of v_m_help.v
   wire			dram3_io_drive_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_drive_enable_buf2;// To/From v_m_help of v_m_help.v
   wire			dram3_io_pad_clk_inv;	// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_pad_clk_inv_buf2;// To/From v_m_help of v_m_help.v
   wire			dram3_io_pad_enable;	// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_pad_enable_buf2;// To/From v_m_help of v_m_help.v
   wire [4:0]		dram3_io_ptr_clk_inv;	// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_ras_l;		// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_ras_l_buf2;	// To/From v_m_help of v_m_help.v
   wire			dram3_io_write_en_l;	// To/From v_m_help of v_m_help.v, ...
   wire			dram3_io_write_en_l_buf2;// To/From v_m_help of v_m_help.v
   wire			dram_adbginit_l;	// From ctu of ctu.v
   wire			dram_arst_l;		// From ctu of ctu.v
   wire			dram_gclk;		// From ctu of ctu.v
   wire [7:0]		dram_gclk_c0_r;		// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		dram_gclk_c1_r;		// From bw_clk_gl of bw_clk_gl.v
   wire [7:0]		dram_gclk_c2_r;		// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		dram_gclk_c3_r;		// To/From v_m_help of v_m_help.v, ...
   wire			dram_gdbginit_l;	// From ctu of ctu.v
   wire			dram_grst_l;		// From ctu of ctu.v
   wire			dram_pt02_max_banks_open_valid;// From dram02 of dram.v
   wire			dram_pt02_max_time_valid;// From dram02 of dram.v
   wire [16:0]		dram_pt02_ucb_data;	// From dram02 of dram.v
   wire			dram_pt0_opened_bank;	// From dram02 of dram.v
   wire			dram_pt13_max_banks_open_valid;// From dram13 of dram.v
   wire			dram_pt13_max_time_valid;// From dram13 of dram.v
   wire [16:0]		dram_pt13_ucb_data;	// From dram13 of dram.v
   wire			dram_pt1_opened_bank;	// From dram13 of dram.v
   wire			dram_pt2_opened_bank;	// From dram02 of dram.v
   wire			dram_pt3_opened_bank;	// From dram13 of dram.v
   wire			efc_ctu_data_out;	// From efc of efc.v
   wire			efc_iob_coreavail_dshift;// From efc of efc.v
   wire			efc_iob_fuse_clk1;	// From efc of efc.v
   wire			efc_iob_fuse_data;	// From efc of efc.v
   wire			efc_iob_fusestat_dshift;// From efc of efc.v
   wire			efc_iob_sernum0_dshift;	// From efc of efc.v
   wire			efc_iob_sernum1_dshift;	// From efc of efc.v
   wire			efc_iob_sernum2_dshift;	// From efc of efc.v
   wire			efc_scdata02_fuse_clk1;	// From efc of efc.v
   wire			efc_scdata02_fuse_clk2;	// From efc of efc.v
   wire			efc_scdata02_fuse_data;	// From efc of efc.v
   wire			efc_scdata0_fuse_ashift;// From efc of efc.v
   wire			efc_scdata0_fuse_dshift;// From efc of efc.v
   wire			efc_scdata13_fuse_clk1;	// From efc of efc.v
   wire			efc_scdata13_fuse_clk2;	// From efc of efc.v
   wire			efc_scdata13_fuse_data;	// From efc of efc.v
   wire			efc_scdata1_fuse_ashift;// From efc of efc.v
   wire			efc_scdata1_fuse_dshift;// From efc of efc.v
   wire			efc_scdata2_fuse_ashift;// From efc of efc.v
   wire			efc_scdata2_fuse_dshift;// From efc of efc.v
   wire			efc_scdata3_fuse_ashift;// From efc of efc.v
   wire			efc_scdata3_fuse_dshift;// From efc of efc.v
   wire			efc_sctag02_fuse_clk1;	// From efc of efc.v
   wire			efc_sctag02_fuse_clk2;	// From efc of efc.v
   wire			efc_sctag02_fuse_data;	// From efc of efc.v
   wire			efc_sctag0_fuse_ashift;	// From efc of efc.v
   wire			efc_sctag0_fuse_dshift;	// From efc of efc.v
   wire			efc_sctag13_fuse_clk1;	// From efc of efc.v
   wire			efc_sctag13_fuse_clk2;	// From efc of efc.v
   wire			efc_sctag13_fuse_data;	// From efc of efc.v
   wire			efc_sctag1_fuse_ashift;	// From efc of efc.v
   wire			efc_sctag1_fuse_dshift;	// From efc of efc.v
   wire			efc_sctag2_fuse_ashift;	// From efc of efc.v
   wire			efc_sctag2_fuse_dshift;	// From efc of efc.v
   wire			efc_sctag3_fuse_ashift;	// From efc of efc.v
   wire			efc_sctag3_fuse_dshift;	// From efc of efc.v
   wire			efc_spc0246_fuse_clk1;	// From efc of efc.v
   wire			efc_spc0246_fuse_clk2;	// From efc of efc.v
   wire			efc_spc0246_fuse_data;	// From efc of efc.v
   wire			efc_spc0_dfuse_ashift;	// From efc of efc.v
   wire			efc_spc0_dfuse_dshift;	// From efc of efc.v
   wire			efc_spc0_ifuse_ashift;	// From efc of efc.v
   wire			efc_spc0_ifuse_dshift;	// From efc of efc.v
   wire			efc_spc1357_fuse_clk1;	// From efc of efc.v
   wire			efc_spc1357_fuse_clk2;	// From efc of efc.v
   wire			efc_spc1357_fuse_data;	// From efc of efc.v
   wire			efc_spc1_dfuse_ashift;	// From efc of efc.v
   wire			efc_spc1_dfuse_dshift;	// From efc of efc.v
   wire			efc_spc1_ifuse_ashift;	// From efc of efc.v
   wire			efc_spc1_ifuse_dshift;	// From efc of efc.v
   wire			efc_spc2_dfuse_ashift;	// From efc of efc.v
   wire			efc_spc2_dfuse_dshift;	// From efc of efc.v
   wire			efc_spc2_ifuse_ashift;	// From efc of efc.v
   wire			efc_spc2_ifuse_dshift;	// From efc of efc.v
   wire			efc_spc3_dfuse_ashift;	// From efc of efc.v
   wire			efc_spc3_dfuse_dshift;	// From efc of efc.v
   wire			efc_spc3_ifuse_ashift;	// From efc of efc.v
   wire			efc_spc3_ifuse_dshift;	// From efc of efc.v
   wire			efc_spc4_dfuse_ashift;	// From efc of efc.v
   wire			efc_spc4_dfuse_dshift;	// From efc of efc.v
   wire			efc_spc4_ifuse_ashift;	// From efc of efc.v
   wire			efc_spc4_ifuse_dshift;	// From efc of efc.v
   wire			efc_spc5_dfuse_ashift;	// From efc of efc.v
   wire			efc_spc5_dfuse_dshift;	// From efc of efc.v
   wire			efc_spc5_ifuse_ashift;	// From efc of efc.v
   wire			efc_spc5_ifuse_dshift;	// From efc of efc.v
   wire			efc_spc6_dfuse_ashift;	// From efc of efc.v
   wire			efc_spc6_dfuse_dshift;	// From efc of efc.v
   wire			efc_spc6_ifuse_ashift;	// From efc of efc.v
   wire			efc_spc6_ifuse_dshift;	// From efc of efc.v
   wire			efc_spc7_dfuse_ashift;	// From efc of efc.v
   wire			efc_spc7_dfuse_dshift;	// From efc of efc.v
   wire			efc_spc7_ifuse_ashift;	// From efc of efc.v
   wire			efc_spc7_ifuse_dshift;	// From efc of efc.v
   wire [144:0]		fp_cpx_data_ca;		// From fpu of fpu.v
   wire [7:0]		fp_cpx_req_cq;		// From fpu of fpu.v
   wire			fpu_rdram3_so;		// From fpu of fpu.v
   wire			global_scan_bypass_en;	// From ctu of ctu.v
   wire			global_shift_enable;	// From ctu of ctu.v
   wire			io_clk_stretch;		// From pad_misc of pad_misc.v
   wire			io_do_bist;		// To/From v_m_help of v_m_help.v
   wire [255:0]		io_dram0_data_in;	// To/From v_m_help of v_m_help.v, ...
   wire			io_dram0_data_valid;	// To/From v_m_help of v_m_help.v, ...
   wire			io_dram0_data_valid_buf0;// To/From v_m_help of v_m_help.v
   wire [31:0]		io_dram0_ecc_in;	// To/From v_m_help of v_m_help.v, ...
   wire [255:0]		io_dram1_data_in;	// To/From v_m_help of v_m_help.v, ...
   wire			io_dram1_data_valid;	// To/From v_m_help of v_m_help.v, ...
   wire			io_dram1_data_valid_buf0;// To/From v_m_help of v_m_help.v
   wire [31:0]		io_dram1_ecc_in;	// To/From v_m_help of v_m_help.v, ...
   wire [255:0]		io_dram2_data_in;	// To/From v_m_help of v_m_help.v, ...
   wire			io_dram2_data_valid;	// To/From v_m_help of v_m_help.v, ...
   wire			io_dram2_data_valid_buf0;// To/From v_m_help of v_m_help.v
   wire [31:0]		io_dram2_ecc_in;	// To/From v_m_help of v_m_help.v, ...
   wire [255:0]		io_dram3_data_in;	// To/From v_m_help of v_m_help.v, ...
   wire			io_dram3_data_valid;	// To/From v_m_help of v_m_help.v, ...
   wire			io_dram3_data_valid_buf0;// To/From v_m_help of v_m_help.v
   wire [31:0]		io_dram3_ecc_in;	// To/From v_m_help of v_m_help.v, ...
   wire			io_ext_int_l;		// From pad_misc of pad_misc.v
   wire			io_j_rst_l;		// From pad_jbusr of pad_jbusr.v
   wire [127:0]		io_jbi_j_ad;		// From pad_jbusr of pad_jbusr.v, ...
   wire [3:0]		io_jbi_j_adp;		// From pad_jbusr of pad_jbusr.v
   wire [7:0]		io_jbi_j_adtype;	// From pad_jbusr of pad_jbusr.v
   wire [2:0]		io_jbi_j_pack4;		// From pad_jbusr of pad_jbusr.v
   wire [2:0]		io_jbi_j_pack5;		// From pad_jbusr of pad_jbusr.v
   wire			io_jbi_j_par;		// From pad_jbusr of pad_jbusr.v
   wire			io_jbi_j_req4_in_l;	// From pad_jbusr of pad_jbusr.v
   wire			io_jbi_j_req5_in_l;	// From pad_jbusr of pad_jbusr.v
   wire			io_jbi_ssi_miso;	// From pad_misc of pad_misc.v
   wire			io_pcm_pmi;		// From pad_misc of pad_misc.v
   wire			io_pgrm_en;		// From pad_misc of pad_misc.v
   wire			io_pll_char_in;		// From pad_misc of pad_misc.v
   wire			io_pwron_rst_l;		// From pad_misc of pad_misc.v
   wire			io_tck;			// From pad_misc of pad_misc.v
   wire			io_tck2;		// From pad_misc of pad_misc.v
   wire			io_tdi;			// From pad_misc of pad_misc.v
   wire			io_temp_trig;		// From pad_misc of pad_misc.v
   wire			io_test_mode;		// From pad_misc of pad_misc.v
   wire			io_tms;			// From pad_misc of pad_misc.v
   wire			io_trigin;		// From pad_misc of pad_misc.v
   wire			io_trst_l;		// From pad_misc of pad_misc.v
   wire			io_vreg_selbg_l;	// From pad_misc of pad_misc.v
   wire [`IOB_CLK_WIDTH-1:0]iob_clsp_data;	// From iobdg of iobdg.v
   wire			iob_clsp_stall;		// From iobdg of iobdg.v
   wire			iob_clsp_vld;		// From iobdg of iobdg.v
   wire [`CPX_WIDTH-1:0]iob_cpx_data_ca;	// To/From v_m_help of v_m_help.v, ...
   wire [`IOB_CPU_WIDTH-1:0]iob_cpx_req_cq;	// To/From v_m_help of v_m_help.v, ...
   wire [`IOB_CPU_WIDTH-1:0]iob_ctu_coreavail;	// From iobdg of iobdg.v
   wire			iob_ctu_l2_tr;		// From iobdg of iobdg.v
   wire			iob_ctu_tr;		// From iobdg of iobdg.v
   wire [`IOB_DRAM_WIDTH-1:0]iob_dram02_data;	// From iobdg of iobdg.v
   wire			iob_dram02_stall;	// From iobdg of iobdg.v
   wire			iob_dram02_vld;		// From iobdg of iobdg.v
   wire [`IOB_DRAM_WIDTH-1:0]iob_dram13_data;	// From iobdg of iobdg.v
   wire			iob_dram13_stall;	// From iobdg of iobdg.v
   wire			iob_dram13_vld;		// From iobdg of iobdg.v
   wire [2:0]		iob_io_dbg_ck_n;	// To/From v_m_help of v_m_help.v, ...
   wire [2:0]		iob_io_dbg_ck_p;	// To/From v_m_help of v_m_help.v, ...
   wire [39:0]		iob_io_dbg_data;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_io_dbg_en;		// To/From v_m_help of v_m_help.v, ...
   wire [47:0]		iob_jbi_dbg_hi_data;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_jbi_dbg_hi_vld;	// To/From v_m_help of v_m_help.v, ...
   wire [47:0]		iob_jbi_dbg_lo_data;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_jbi_dbg_lo_vld;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_jbi_mondo_ack;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_jbi_mondo_nack;	// To/From v_m_help of v_m_help.v, ...
   wire [`IOB_JBI_WIDTH-1:0]iob_jbi_pio_data;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_jbi_pio_stall;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_jbi_pio_vld;	// To/From v_m_help of v_m_help.v, ...
   wire [`IOB_SPI_WIDTH-1:0]iob_jbi_spi_data;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_jbi_spi_stall;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_jbi_spi_vld;	// To/From v_m_help of v_m_help.v, ...
   wire			iob_pcx_stall_pq;	// To/From v_m_help of v_m_help.v, ...
   wire [`IOB_TAP_WIDTH-1:0]iob_tap_data;	// From iobdg of iobdg.v
   wire			iob_tap_stall;		// From iobdg of iobdg.v
   wire			iob_tap_vld;		// From iobdg of iobdg.v
   wire			jbi_ctu_tr;		// From jbi of jbi.v
   wire [1:0]		jbi_io_config_dtl;	// From jbi of jbi.v
   wire [127:0]		jbi_io_j_ad;		// From jbi of jbi.v
   wire [3:0]		jbi_io_j_ad_en;		// From jbi of jbi.v
   wire [3:0]		jbi_io_j_adp;		// From jbi of jbi.v
   wire			jbi_io_j_adp_en;	// From jbi of jbi.v
   wire [7:0]		jbi_io_j_adtype;	// From jbi of jbi.v
   wire			jbi_io_j_adtype_en;	// From jbi of jbi.v
   wire [2:0]		jbi_io_j_pack0;		// From jbi of jbi.v
   wire			jbi_io_j_pack0_en;	// From jbi of jbi.v
   wire [2:0]		jbi_io_j_pack1;		// From jbi of jbi.v
   wire			jbi_io_j_pack1_en;	// From jbi of jbi.v
   wire			jbi_io_j_req0_out_en;	// From jbi of jbi.v
   wire			jbi_io_j_req0_out_l;	// From jbi of jbi.v
   wire			jbi_io_ssi_mosi;	// From jbi of jbi.v
   wire			jbi_io_ssi_sck;		// From jbi of jbi.v
   wire [`JBI_IOB_MONDO_BUS_WIDTH-1:0]jbi_iob_mondo_data;// To/From v_m_help of v_m_help.v, ...
   wire			jbi_iob_mondo_vld;	// To/From v_m_help of v_m_help.v, ...
   wire [`JBI_IOB_WIDTH-1:0]jbi_iob_pio_data;	// To/From v_m_help of v_m_help.v, ...
   wire			jbi_iob_pio_stall;	// To/From v_m_help of v_m_help.v, ...
   wire			jbi_iob_pio_vld;	// To/From v_m_help of v_m_help.v, ...
   wire [`SPI_IOB_WIDTH-1:0]jbi_iob_spi_data;	// To/From v_m_help of v_m_help.v, ...
   wire			jbi_iob_spi_stall;	// To/From v_m_help of v_m_help.v, ...
   wire			jbi_iob_spi_vld;	// To/From v_m_help of v_m_help.v, ...
   wire [6:0]		jbi_scbuf0_ecc;		// From jbi of jbi.v
   wire [6:0]		jbi_scbuf0_ecc_d1;	// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire [6:0]		jbi_scbuf0_ecc_d1_buf1;	// From rep_jbi_sc0_1 of jbi_l2_buf2.v
   wire [6:0]		jbi_scbuf0_ecc_d2;	// From ff_jbi_sc0_2 of ff_jbi_sc0_2.v
   wire [6:0]		jbi_scbuf0_ecc_d2_buf1;	// From rep_jbi_sc0_2 of rep_jbi_sc0_2.v
   wire [6:0]		jbi_scbuf1_ecc;		// From jbi of jbi.v
   wire [6:0]		jbi_scbuf1_ecc_d1;	// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire [6:0]		jbi_scbuf1_ecc_d1_buf1;	// From rep_jbi_sc1_1 of jbi_l2_buf2.v
   wire [6:0]		jbi_scbuf1_ecc_d2;	// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire [6:0]		jbi_scbuf1_ecc_d2_buf1;	// From rep_jbi_sc1_2 of rep_jbi_sc1_2.v
   wire [6:0]		jbi_scbuf2_ecc;		// From jbi of jbi.v
   wire [6:0]		jbi_scbuf2_ecc_d1;	// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire [6:0]		jbi_scbuf2_ecc_d1_buf1;	// From rep_jbi_sc2_1 of jbi_l2_buf2.v
   wire [6:0]		jbi_scbuf2_ecc_d2;	// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire [6:0]		jbi_scbuf2_ecc_d2_buf1;	// From rep_jbi_sc2_2 of rep_jbi_sc2_2.v
   wire [6:0]		jbi_scbuf3_ecc;		// From jbi of jbi.v
   wire [6:0]		jbi_scbuf3_ecc_d1;	// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire [6:0]		jbi_scbuf3_ecc_d1_buf1;	// From rep_jbi_sc3_1 of jbi_l2_buf2.v
   wire [6:0]		jbi_scbuf3_ecc_d2;	// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire [6:0]		jbi_scbuf3_ecc_d2_buf1;	// From rep_jbi_sc3_2 of rep_jbi_sc3_2.v
   wire [31:0]		jbi_sctag0_req;		// From jbi of jbi.v
   wire [31:0]		jbi_sctag0_req_d1;	// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire [31:0]		jbi_sctag0_req_d1_buf1;	// From rep_jbi_sc0_1 of jbi_l2_buf2.v
   wire [31:0]		jbi_sctag0_req_d2;	// From ff_jbi_sc0_2 of ff_jbi_sc0_2.v
   wire [31:0]		jbi_sctag0_req_d2_buf1;	// From rep_jbi_sc0_2 of rep_jbi_sc0_2.v
   wire			jbi_sctag0_req_vld;	// From jbi of jbi.v
   wire			jbi_sctag0_req_vld_d1;	// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire			jbi_sctag0_req_vld_d1_buf1;// From rep_jbi_sc0_1 of jbi_l2_buf2.v
   wire			jbi_sctag0_req_vld_d2;	// From ff_jbi_sc0_2 of ff_jbi_sc0_2.v
   wire [31:0]		jbi_sctag1_req;		// From jbi of jbi.v
   wire [31:0]		jbi_sctag1_req_d1;	// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire [31:0]		jbi_sctag1_req_d1_buf1;	// From rep_jbi_sc1_1 of jbi_l2_buf2.v
   wire [31:0]		jbi_sctag1_req_d2;	// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire [31:0]		jbi_sctag1_req_d2_buf1;	// From rep_jbi_sc1_2 of rep_jbi_sc1_2.v
   wire			jbi_sctag1_req_vld;	// From jbi of jbi.v
   wire			jbi_sctag1_req_vld_d1;	// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire			jbi_sctag1_req_vld_d1_buf1;// From rep_jbi_sc1_1 of jbi_l2_buf2.v
   wire			jbi_sctag1_req_vld_d2;	// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire [31:0]		jbi_sctag2_req;		// From jbi of jbi.v
   wire [31:0]		jbi_sctag2_req_d1;	// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire [31:0]		jbi_sctag2_req_d1_buf1;	// From rep_jbi_sc2_1 of jbi_l2_buf2.v
   wire [31:0]		jbi_sctag2_req_d2;	// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire [31:0]		jbi_sctag2_req_d2_buf1;	// From rep_jbi_sc2_2 of rep_jbi_sc2_2.v
   wire			jbi_sctag2_req_vld;	// From jbi of jbi.v
   wire			jbi_sctag2_req_vld_d1;	// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire			jbi_sctag2_req_vld_d1_buf1;// From rep_jbi_sc2_1 of jbi_l2_buf2.v
   wire			jbi_sctag2_req_vld_d2;	// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire [31:0]		jbi_sctag3_req;		// From jbi of jbi.v
   wire [31:0]		jbi_sctag3_req_d1;	// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire [31:0]		jbi_sctag3_req_d1_buf1;	// From rep_jbi_sc3_1 of jbi_l2_buf2.v
   wire [31:0]		jbi_sctag3_req_d2;	// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire [31:0]		jbi_sctag3_req_d2_buf1;	// From rep_jbi_sc3_2 of rep_jbi_sc3_2.v
   wire			jbi_sctag3_req_vld;	// From jbi of jbi.v
   wire			jbi_sctag3_req_vld_d1;	// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire			jbi_sctag3_req_vld_d1_buf1;// From rep_jbi_sc3_1 of jbi_l2_buf2.v
   wire			jbi_sctag3_req_vld_d2;	// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire			jbus_adbginit_l;	// From ctu of ctu.v
   wire			jbus_arst_l;		// From ctu of ctu.v
   wire			jbus_gclk;		// From ctu of ctu.v
   wire [7:0]		jbus_gclk_c0_r;		// From bw_clk_gl of bw_clk_gl.v
   wire [7:0]		jbus_gclk_c1_r;		// From bw_clk_gl of bw_clk_gl.v
   wire [7:0]		jbus_gclk_c2_r;		// From bw_clk_gl of bw_clk_gl.v
   wire [7:0]		jbus_gclk_c3_r;		// From bw_clk_gl of bw_clk_gl.v
   wire			jbus_gclk_dup;		// From bw_clk_gl of bw_clk_gl.v
   wire			jbus_gclk_dup_out;	// From ctu of ctu.v
   wire			jbus_gdbginit_l;	// From ctu of ctu.v
   wire			jbus_grst_l;		// From ctu of ctu.v
   wire			jbusl_jbusr_bso;	// From pad_jbusl of pad_jbusl.v
   wire			jbusr_ddr3_sscan_out;	// From pad_jbusr of pad_jbusr.v
   wire [8:1]		jbusr_jbusl_cbd;	// From pad_jbusr of pad_jbusr.v
   wire [8:1]		jbusr_jbusl_cbu;	// From pad_jbusr of pad_jbusr.v
   wire			jbusr_jbusr_bso;	// From pad_jbusr of pad_jbusr.v
   wire [39:0]		l2_dbgbus_01;		// From sc_0_1_dbg_rptr of sc_0_1_dbg_rptr.v
   wire [39:0]		l2_dbgbus_23;		// From sc_2_3_dbg_rptr of sc_2_3_dbg_rptr.v
   wire			misc_dbg_bso;		// From pad_misc of pad_misc.v
   wire [30:0]		par_scan_head;		// To/From v_m_help of v_m_help.v
   wire [30:0]		par_scan_tail;		// To/From v_m_help of v_m_help.v, ...
   wire			pcm_io_burnin;		// From pad_misc of pad_misc.v
   wire			pcm_io_pmo;		// From pcm of pcm.v
   wire			pcm_misc_oe;		// From pcm of pcm.v
   wire [`PCX_WIDTH-1:0]pcx_fp_data_px2;	// From ccx of ccx.v
   wire			pcx_fp_data_rdy_px2;	// From ccx of ccx.v
   wire [`PCX_WIDTH-1:0]pcx_iob_data_px2;	// To/From v_m_help of v_m_help.v, ...
   wire			pcx_iob_data_rdy_px2;	// To/From v_m_help of v_m_help.v, ...
   wire			pcx_sctag0_atm_px1;	// To/From v_m_help of v_m_help.v, ...
   wire [`PCX_WIDTH-1:0]pcx_sctag0_data_px2;	// To/From v_m_help of v_m_help.v, ...
   wire			pcx_sctag0_data_rdy_px1;// To/From v_m_help of v_m_help.v, ...
   wire			pcx_sctag1_atm_px1;	// To/From v_m_help of v_m_help.v, ...
   wire [`PCX_WIDTH-1:0]pcx_sctag1_data_px2;	// To/From v_m_help of v_m_help.v, ...
   wire			pcx_sctag1_data_rdy_px1;// To/From v_m_help of v_m_help.v, ...
   wire			pcx_sctag2_atm_px1;	// To/From v_m_help of v_m_help.v, ...
   wire [`PCX_WIDTH-1:0]pcx_sctag2_data_px2;	// To/From v_m_help of v_m_help.v, ...
   wire			pcx_sctag2_data_rdy_px1;// To/From v_m_help of v_m_help.v, ...
   wire			pcx_sctag3_atm_px1;	// To/From v_m_help of v_m_help.v, ...
   wire [`PCX_WIDTH-1:0]pcx_sctag3_data_px2;	// To/From v_m_help of v_m_help.v, ...
   wire			pcx_sctag3_data_rdy_px1;// To/From v_m_help of v_m_help.v, ...
   wire [4:0]		pcx_spc0_grant_px;	// From ccx of ccx.v
   wire [4:0]		pcx_spc0_grant_px_buf;	// From ccx_spc_rpt0 of ccx_spc_rpt.v
   wire [4:0]		pcx_spc0_grant_px_buf1;	// From buf_pcx_0 of spc_pcx_buf.v
   wire [4:0]		pcx_spc1_grant_px;	// From ccx of ccx.v
   wire [4:0]		pcx_spc1_grant_px_buf;	// From ccx_spc_rpt1 of ccx_spc_rpt.v
   wire [4:0]		pcx_spc1_grant_px_buf1;	// From buf_pcx_1 of spc_pcx_buf.v
   wire [4:0]		pcx_spc2_grant_px;	// From ccx of ccx.v
   wire [4:0]		pcx_spc2_grant_px_buf;	// From ccx_spc_rpt2 of ccx_spc_rpt.v
   wire [4:0]		pcx_spc2_grant_px_buf1;	// From buf_pcx_2 of spc_pcx_buf.v
   wire [4:0]		pcx_spc3_grant_px;	// From ccx of ccx.v
   wire [4:0]		pcx_spc3_grant_px_buf;	// From ccx_spc_rpt3 of ccx_spc_rpt.v
   wire [4:0]		pcx_spc3_grant_px_buf1;	// From buf_pcx_3 of spc_pcx_buf.v
   wire [4:0]		pcx_spc4_grant_px;	// From ccx of ccx.v
   wire [4:0]		pcx_spc4_grant_px_buf;	// From ccx_spc_rpt4 of ccx_spc_rpt.v
   wire [4:0]		pcx_spc4_grant_px_buf1;	// From buf_pcx_4 of spc_pcx_buf.v
   wire [4:0]		pcx_spc5_grant_px;	// From ccx of ccx.v
   wire [4:0]		pcx_spc5_grant_px_buf;	// From ccx_spc_rpt5 of ccx_spc_rpt.v
   wire [4:0]		pcx_spc5_grant_px_buf1;	// From buf_pcx_5 of spc_pcx_buf.v
   wire [4:0]		pcx_spc6_grant_px;	// From ccx of ccx.v
   wire [4:0]		pcx_spc6_grant_px_buf;	// From ccx_spc_rpt6 of ccx_spc_rpt.v
   wire [4:0]		pcx_spc6_grant_px_buf1;	// From buf_pcx_6 of spc_pcx_buf.v
   wire [4:0]		pcx_spc7_grant_px;	// From ccx of ccx.v
   wire [4:0]		pcx_spc7_grant_px_buf;	// From ccx_spc_rpt7 of ccx_spc_rpt.v
   wire [4:0]		pcx_spc7_grant_px_buf1;	// From buf_pcx_7 of spc_pcx_buf.v
   wire			pdbg_pddr1_so;		// From pad_dbg of pad_jbusl.v
   wire			pddr0_jbi_so;		// From pad_ddr0 of pad_ddr0.v
   wire			pddr1_pjbusl_so;	// From pad_ddr1 of pad_ddr1.v
   wire			pddr2_rsc22_so;		// From pad_ddr2 of pad_ddr2.v
   wire			pddr3_pjbusr_so;	// From pad_ddr3 of pad_ddr3.v
   wire			pjbusl_rptrs_so;	// To/From v_m_help of v_m_help.v, ...
   wire			pjbusr_rptrs_so;	// To/From v_m_help of v_m_help.v, ...
   wire			pmisc_pddr2_so;		// From pad_misc of pad_misc.v
   wire			pscan_select;		// From ctu of ctu.v
   wire			rbot2_ctu_so;		// From ctu_bottom_rptr2 of ctu_bottom_rptr2.v
   wire			rbot_rdram1_so;		// From ctu_bottom_rptr of ctu_bottom_rptr.v
   wire			rdbg01_rsc02_so;	// From sc_0_1_dbg_rptr of sc_0_1_dbg_rptr.v
   wire			rdbg23_rdbg01_so;	// From sc_2_3_dbg_rptr of sc_2_3_dbg_rptr.v
   wire			rdram0_rtop_so;		// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			rdram1_rbot2_so;	// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			rdram2_fpu_so;		// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			rdram3_rbot_so;		// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			rpt_ccx_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_dram_rx_sync_c1;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_dram_rx_sync_c6;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_dram_tx_sync_c1;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_dram_tx_sync_c6;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_gdbginit_l_c0;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_gdbginit_l_c1;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_gdbginit_l_c2;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_gdbginit_l_c3;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_gdbginit_l_c4;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_gdbginit_l_c5;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_gdbginit_l_c7;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_grst_l_c0;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_grst_l_c1;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_grst_l_c2;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_grst_l_c3;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_grst_l_c4;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_grst_l_c5;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_grst_l_c6;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_grst_l_c7;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_jbus_rx_sync_c1;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_jbus_rx_sync_c4;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_jbus_rx_sync_c6;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_jbus_tx_sync_c1;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_jbus_tx_sync_c4;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_cmp_jbus_tx_sync_c6;// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_dram02_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_dram13_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_fpu_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_iob_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_jbi_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_scbuf0_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_scbuf1_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_scbuf2_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_scbuf3_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_scdata0_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_scdata1_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_scdata2_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_scdata3_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_sctag0_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_sctag1_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_sctag2_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_sctag3_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_spc0_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_spc1_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_spc2_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_spc3_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_spc4_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_spc5_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_spc6_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rpt_spc7_cmp_cken;	// From flop_rptrs of bw_clk_gl_rstce_rtl.v
   wire			rptrs_pdbg_so;		// To/From v_m_help of v_m_help.v
   wire			rptrs_pmisc_so;		// To/From v_m_help of v_m_help.v
   wire			rptrs_rsc12_so;		// To/From v_m_help of v_m_help.v
   wire			rsc01_rsc11_so;		// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire			rsc02_rptrs_so;		// To/From v_m_help of v_m_help.v, ...
   wire			rsc11_rsc21_so;		// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire			rsc12_rsc01_so;		// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire			rsc21_rsc31_so;		// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire			rsc21_rsc32_so;		// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire			rsc22_rdbg23_so;	// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire			rsc32_efc_so;		// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire			rtop2_rdram0_so;	// From ctu_top_rptr2 of ctu_top_rptr2.v
   wire			rtop_rdram2_so;		// From ctu_top_rptr of ctu_top_rptr.v
   wire			scbuf0_dram02_data_mecc_r5;// From scbuf0 of scbuf.v
   wire			scbuf0_dram02_data_mecc_r5_buf1;// From dram_sc_0_rep3 of dram_l2_buf2.v
   wire			scbuf0_dram02_data_mecc_r5_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			scbuf0_dram02_data_mecc_r5_buf3;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			scbuf0_dram02_data_mecc_r5_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			scbuf0_dram02_data_vld_r5;// From scbuf0 of scbuf.v
   wire			scbuf0_dram02_data_vld_r5_buf1;// From dram_sc_0_rep3 of dram_l2_buf2.v
   wire			scbuf0_dram02_data_vld_r5_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			scbuf0_dram02_data_vld_r5_buf3;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			scbuf0_dram02_data_vld_r5_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire [63:0]		scbuf0_dram02_wr_data_r5;// From scbuf0 of scbuf.v
   wire [63:0]		scbuf0_dram02_wr_data_r5_buf1;// From dram_sc_0_rep3 of dram_l2_buf2.v
   wire [63:0]		scbuf0_dram02_wr_data_r5_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire [63:0]		scbuf0_dram02_wr_data_r5_buf3;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire [63:0]		scbuf0_dram02_wr_data_r5_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			scbuf0_jbi_ctag_vld;	// From scbuf0 of scbuf.v
   wire			scbuf0_jbi_ctag_vld_buf1;// From rep_jbi_sc0_2 of rep_jbi_sc0_2.v
   wire			scbuf0_jbi_ctag_vld_d1;	// From ff_jbi_sc0_2 of ff_jbi_sc0_2.v
   wire			scbuf0_jbi_ctag_vld_d1_buf1;// From rep_jbi_sc0_1 of jbi_l2_buf2.v
   wire			scbuf0_jbi_ctag_vld_d2;	// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire [31:0]		scbuf0_jbi_data;	// From scbuf0 of scbuf.v
   wire [31:0]		scbuf0_jbi_data_buf1;	// From rep_jbi_sc0_2 of rep_jbi_sc0_2.v
   wire [31:0]		scbuf0_jbi_data_d1;	// From ff_jbi_sc0_2 of ff_jbi_sc0_2.v
   wire [31:0]		scbuf0_jbi_data_d1_buf1;// From rep_jbi_sc0_1 of jbi_l2_buf2.v
   wire [31:0]		scbuf0_jbi_data_d2;	// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire			scbuf0_jbi_ue_err;	// From scbuf0 of scbuf.v
   wire			scbuf0_jbi_ue_err_buf1;	// From rep_jbi_sc0_2 of rep_jbi_sc0_2.v
   wire			scbuf0_jbi_ue_err_d1;	// From ff_jbi_sc0_2 of ff_jbi_sc0_2.v
   wire			scbuf0_jbi_ue_err_d1_buf1;// From rep_jbi_sc0_1 of jbi_l2_buf2.v
   wire			scbuf0_jbi_ue_err_d2;	// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire [623:0]		scbuf0_scdata0_fbdecc_c4;// From scbuf0 of scbuf.v
   wire			scbuf0_scdata0_scanout;	// From scbuf0 of scbuf.v
   wire			scbuf0_sctag0_ev_cerr_r5;// From scbuf0 of scbuf.v
   wire			scbuf0_sctag0_ev_cerr_r5_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			scbuf0_sctag0_ev_uerr_r5;// From scbuf0 of scbuf.v
   wire			scbuf0_sctag0_ev_uerr_r5_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			scbuf0_sctag0_rdma_cerr_c10;// From scbuf0 of scbuf.v
   wire			scbuf0_sctag0_rdma_cerr_c10_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			scbuf0_sctag0_rdma_uerr_c10;// From scbuf0 of scbuf.v
   wire			scbuf0_sctag0_rdma_uerr_c10_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			scbuf1_dram13_data_mecc_r5;// From scbuf1 of scbuf.v
   wire			scbuf1_dram13_data_mecc_r5_buf1;// From dram_sc_1_rep3 of dram_l2_buf2.v
   wire			scbuf1_dram13_data_mecc_r5_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			scbuf1_dram13_data_mecc_r5_buf3;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			scbuf1_dram13_data_mecc_r5_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			scbuf1_dram13_data_vld_r5;// From scbuf1 of scbuf.v
   wire			scbuf1_dram13_data_vld_r5_buf1;// From dram_sc_1_rep3 of dram_l2_buf2.v
   wire			scbuf1_dram13_data_vld_r5_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			scbuf1_dram13_data_vld_r5_buf3;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			scbuf1_dram13_data_vld_r5_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire [63:0]		scbuf1_dram13_wr_data_r5;// From scbuf1 of scbuf.v
   wire [63:0]		scbuf1_dram13_wr_data_r5_buf1;// From dram_sc_1_rep3 of dram_l2_buf2.v
   wire [63:0]		scbuf1_dram13_wr_data_r5_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire [63:0]		scbuf1_dram13_wr_data_r5_buf3;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire [63:0]		scbuf1_dram13_wr_data_r5_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			scbuf1_jbi_ctag_vld;	// From scbuf1 of scbuf.v
   wire			scbuf1_jbi_ctag_vld_buf1;// From rep_jbi_sc1_2 of rep_jbi_sc1_2.v
   wire			scbuf1_jbi_ctag_vld_d1;	// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire			scbuf1_jbi_ctag_vld_d1_buf1;// From rep_jbi_sc1_1 of jbi_l2_buf2.v
   wire			scbuf1_jbi_ctag_vld_d2;	// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire [31:0]		scbuf1_jbi_data;	// From scbuf1 of scbuf.v
   wire [31:0]		scbuf1_jbi_data_buf1;	// From rep_jbi_sc1_2 of rep_jbi_sc1_2.v
   wire [31:0]		scbuf1_jbi_data_d1;	// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire [31:0]		scbuf1_jbi_data_d1_buf1;// From rep_jbi_sc1_1 of jbi_l2_buf2.v
   wire [31:0]		scbuf1_jbi_data_d2;	// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire			scbuf1_jbi_ue_err;	// From scbuf1 of scbuf.v
   wire			scbuf1_jbi_ue_err_buf1;	// From rep_jbi_sc1_2 of rep_jbi_sc1_2.v
   wire			scbuf1_jbi_ue_err_d1;	// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire			scbuf1_jbi_ue_err_d1_buf1;// From rep_jbi_sc1_1 of jbi_l2_buf2.v
   wire			scbuf1_jbi_ue_err_d2;	// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire [623:0]		scbuf1_scdata1_fbdecc_c4;// From scbuf1 of scbuf.v
   wire			scbuf1_scdata1_scanout;	// From scbuf1 of scbuf.v
   wire			scbuf1_sctag1_ev_cerr_r5;// From scbuf1 of scbuf.v
   wire			scbuf1_sctag1_ev_cerr_r5_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			scbuf1_sctag1_ev_uerr_r5;// From scbuf1 of scbuf.v
   wire			scbuf1_sctag1_ev_uerr_r5_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			scbuf1_sctag1_rdma_cerr_c10;// From scbuf1 of scbuf.v
   wire			scbuf1_sctag1_rdma_cerr_c10_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			scbuf1_sctag1_rdma_uerr_c10;// From scbuf1 of scbuf.v
   wire			scbuf1_sctag1_rdma_uerr_c10_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			scbuf2_dram02_data_mecc_r5;// From scbuf2 of scbuf.v
   wire			scbuf2_dram02_data_mecc_r5_buf1;// From dram_sc_2_rep3 of dram_l2_buf2.v
   wire			scbuf2_dram02_data_mecc_r5_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			scbuf2_dram02_data_mecc_r5_buf3;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			scbuf2_dram02_data_mecc_r5_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			scbuf2_dram02_data_vld_r5;// From scbuf2 of scbuf.v
   wire			scbuf2_dram02_data_vld_r5_buf1;// From dram_sc_2_rep3 of dram_l2_buf2.v
   wire			scbuf2_dram02_data_vld_r5_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			scbuf2_dram02_data_vld_r5_buf3;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			scbuf2_dram02_data_vld_r5_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire [63:0]		scbuf2_dram02_wr_data_r5;// From scbuf2 of scbuf.v
   wire [63:0]		scbuf2_dram02_wr_data_r5_buf1;// From dram_sc_2_rep3 of dram_l2_buf2.v
   wire [63:0]		scbuf2_dram02_wr_data_r5_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire [63:0]		scbuf2_dram02_wr_data_r5_buf3;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire [63:0]		scbuf2_dram02_wr_data_r5_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			scbuf2_jbi_ctag_vld;	// From scbuf2 of scbuf.v
   wire			scbuf2_jbi_ctag_vld_buf1;// From rep_jbi_sc2_2 of rep_jbi_sc2_2.v
   wire			scbuf2_jbi_ctag_vld_d1;	// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire			scbuf2_jbi_ctag_vld_d1_buf1;// From rep_jbi_sc2_1 of jbi_l2_buf2.v
   wire			scbuf2_jbi_ctag_vld_d2;	// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire [31:0]		scbuf2_jbi_data;	// From scbuf2 of scbuf.v
   wire [31:0]		scbuf2_jbi_data_buf1;	// From rep_jbi_sc2_2 of rep_jbi_sc2_2.v
   wire [31:0]		scbuf2_jbi_data_d1;	// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire [31:0]		scbuf2_jbi_data_d1_buf1;// From rep_jbi_sc2_1 of jbi_l2_buf2.v
   wire [31:0]		scbuf2_jbi_data_d2;	// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire			scbuf2_jbi_ue_err;	// From scbuf2 of scbuf.v
   wire			scbuf2_jbi_ue_err_buf1;	// From rep_jbi_sc2_2 of rep_jbi_sc2_2.v
   wire			scbuf2_jbi_ue_err_d1;	// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire			scbuf2_jbi_ue_err_d1_buf1;// From rep_jbi_sc2_1 of jbi_l2_buf2.v
   wire			scbuf2_jbi_ue_err_d2;	// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire [623:0]		scbuf2_scdata2_fbdecc_c4;// From scbuf2 of scbuf.v
   wire			scbuf2_scdata2_scanout;	// From scbuf2 of scbuf.v
   wire			scbuf2_sctag2_ev_cerr_r5;// From scbuf2 of scbuf.v
   wire			scbuf2_sctag2_ev_cerr_r5_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			scbuf2_sctag2_ev_uerr_r5;// From scbuf2 of scbuf.v
   wire			scbuf2_sctag2_ev_uerr_r5_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			scbuf2_sctag2_rdma_cerr_c10;// From scbuf2 of scbuf.v
   wire			scbuf2_sctag2_rdma_cerr_c10_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			scbuf2_sctag2_rdma_uerr_c10;// From scbuf2 of scbuf.v
   wire			scbuf2_sctag2_rdma_uerr_c10_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			scbuf3_dram13_data_mecc_r5;// From scbuf3 of scbuf.v
   wire			scbuf3_dram13_data_mecc_r5_buf1;// From dram_sc_3_rep3 of dram_l2_buf2.v
   wire			scbuf3_dram13_data_mecc_r5_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			scbuf3_dram13_data_mecc_r5_buf3;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			scbuf3_dram13_data_mecc_r5_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			scbuf3_dram13_data_vld_r5;// From scbuf3 of scbuf.v
   wire			scbuf3_dram13_data_vld_r5_buf1;// From dram_sc_3_rep3 of dram_l2_buf2.v
   wire			scbuf3_dram13_data_vld_r5_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			scbuf3_dram13_data_vld_r5_buf3;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			scbuf3_dram13_data_vld_r5_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire [63:0]		scbuf3_dram13_wr_data_r5;// From scbuf3 of scbuf.v
   wire [63:0]		scbuf3_dram13_wr_data_r5_buf1;// From dram_sc_3_rep3 of dram_l2_buf2.v
   wire [63:0]		scbuf3_dram13_wr_data_r5_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire [63:0]		scbuf3_dram13_wr_data_r5_buf3;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire [63:0]		scbuf3_dram13_wr_data_r5_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			scbuf3_jbi_ctag_vld;	// From scbuf3 of scbuf.v
   wire			scbuf3_jbi_ctag_vld_buf1;// From rep_jbi_sc3_2 of rep_jbi_sc3_2.v
   wire			scbuf3_jbi_ctag_vld_d1;	// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire			scbuf3_jbi_ctag_vld_d1_buf1;// From rep_jbi_sc3_1 of jbi_l2_buf2.v
   wire			scbuf3_jbi_ctag_vld_d2;	// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire [31:0]		scbuf3_jbi_data;	// From scbuf3 of scbuf.v
   wire [31:0]		scbuf3_jbi_data_buf1;	// From rep_jbi_sc3_2 of rep_jbi_sc3_2.v
   wire [31:0]		scbuf3_jbi_data_d1;	// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire [31:0]		scbuf3_jbi_data_d1_buf1;// From rep_jbi_sc3_1 of jbi_l2_buf2.v
   wire [31:0]		scbuf3_jbi_data_d2;	// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire			scbuf3_jbi_ue_err;	// From scbuf3 of scbuf.v
   wire			scbuf3_jbi_ue_err_buf1;	// From rep_jbi_sc3_2 of rep_jbi_sc3_2.v
   wire			scbuf3_jbi_ue_err_d1;	// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire			scbuf3_jbi_ue_err_d1_buf1;// From rep_jbi_sc3_1 of jbi_l2_buf2.v
   wire			scbuf3_jbi_ue_err_d2;	// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire [623:0]		scbuf3_scdata3_fbdecc_c4;// From scbuf3 of scbuf.v
   wire			scbuf3_scdata3_scanout;	// From scbuf3 of scbuf.v
   wire			scbuf3_sctag3_ev_cerr_r5;// From scbuf3 of scbuf.v
   wire			scbuf3_sctag3_ev_cerr_r5_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			scbuf3_sctag3_ev_uerr_r5;// From scbuf3 of scbuf.v
   wire			scbuf3_sctag3_ev_uerr_r5_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			scbuf3_sctag3_rdma_cerr_c10;// From scbuf3 of scbuf.v
   wire			scbuf3_sctag3_rdma_cerr_c10_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			scbuf3_sctag3_rdma_uerr_c10;// From scbuf3 of scbuf.v
   wire			scbuf3_sctag3_rdma_uerr_c10_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			scdata0_efc_fuse_data;	// From scdata0 of scdata.v
   wire [623:0]		scdata0_scbuf0_decc_out_c7;// From scdata0 of scdata.v
   wire [155:0]		scdata0_sctag0_decc_c6;	// From scdata0 of scdata.v
   wire			scdata1_efc_fuse_data;	// From scdata1 of scdata.v
   wire [623:0]		scdata1_scbuf1_decc_out_c7;// From scdata1 of scdata.v
   wire [155:0]		scdata1_sctag1_decc_c6;	// From scdata1 of scdata.v
   wire			scdata2_efc_fuse_data;	// From scdata2 of scdata.v
   wire [623:0]		scdata2_scbuf2_decc_out_c7;// From scdata2 of scdata.v
   wire [155:0]		scdata2_sctag2_decc_c6;	// From scdata2 of scdata.v
   wire			scdata3_efc_fuse_data;	// From scdata3 of scdata.v
   wire [623:0]		scdata3_scbuf3_decc_out_c7;// From scdata3 of scdata.v
   wire [155:0]		scdata3_sctag3_decc_c6;	// From scdata3 of scdata.v
   wire			sctag0_cpx_atom_cq;	// To/From v_m_help of v_m_help.v, ...
   wire [`CPX_WIDTH-1:0]sctag0_cpx_data_ca;	// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		sctag0_cpx_req_cq;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag0_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag0_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			sctag0_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag0_ctu_mbisterr_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			sctag0_ctu_tr;		// To/From v_m_help of v_m_help.v, ...
   wire			sctag0_ctu_tr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire [40:0]		sctag0_dbgbus_out;	// From sctag0 of sctag.v
   wire [39:5]		sctag0_dram02_addr;	// From sctag0 of sctag.v
   wire [39:5]		sctag0_dram02_addr_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire [39:5]		sctag0_dram02_addr_buf3;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire [39:5]		sctag0_dram02_addr_d1;	// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			sctag0_dram02_rd_dummy_req;// From sctag0 of sctag.v
   wire			sctag0_dram02_rd_dummy_req_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			sctag0_dram02_rd_dummy_req_buf3;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			sctag0_dram02_rd_dummy_req_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			sctag0_dram02_rd_req;	// From sctag0 of sctag.v
   wire			sctag0_dram02_rd_req_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			sctag0_dram02_rd_req_buf3;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			sctag0_dram02_rd_req_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire [2:0]		sctag0_dram02_rd_req_id;// From sctag0 of sctag.v
   wire [2:0]		sctag0_dram02_rd_req_id_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire [2:0]		sctag0_dram02_rd_req_id_buf3;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire [2:0]		sctag0_dram02_rd_req_id_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			sctag0_dram02_wr_req;	// From sctag0 of sctag.v
   wire			sctag0_dram02_wr_req_buf2;// From dram_sc_0_rep2 of dram_sc_0_rep2.v
   wire			sctag0_dram02_wr_req_buf3;// From dram_sc_0_rep1 of dram_l2_buf2.v
   wire			sctag0_dram02_wr_req_d1;// From ff_dram_sc_bank0 of ff_dram_sc_bank0.v
   wire			sctag0_efc_fuse_data;	// From sctag0 of sctag.v
   wire			sctag0_jbi_iq_dequeue;	// From sctag0 of sctag.v
   wire			sctag0_jbi_iq_dequeue_d1;// From ff_jbi_sc0_2 of ff_jbi_sc0_2.v
   wire			sctag0_jbi_iq_dequeue_d1_buf1;// From rep_jbi_sc0_1 of jbi_l2_buf2.v
   wire			sctag0_jbi_iq_dequeue_d2;// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire			sctag0_jbi_por_req;	// From sctag0 of sctag.v
   wire			sctag0_jbi_por_req_d1;	// From ff_jbi_sc0_2 of ff_jbi_sc0_2.v
   wire			sctag0_jbi_por_req_d1_buf1;// From rep_jbi_sc0_1 of jbi_l2_buf2.v
   wire			sctag0_jbi_por_req_d2;	// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire			sctag0_jbi_wib_dequeue;	// From sctag0 of sctag.v
   wire			sctag0_jbi_wib_dequeue_d1;// From ff_jbi_sc0_2 of ff_jbi_sc0_2.v
   wire			sctag0_jbi_wib_dequeue_d1_buf1;// From rep_jbi_sc0_1 of jbi_l2_buf2.v
   wire			sctag0_jbi_wib_dequeue_d2;// From ff_jbi_sc0_1 of ff_jbi_sc0_1.v
   wire			sctag0_pcx_stall_pq;	// To/From v_m_help of v_m_help.v, ...
   wire [14:0]		sctag0_scbuf0_ctag_c7;	// From sctag0 of sctag.v
   wire [14:0]		sctag0_scbuf0_ctag_c7_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			sctag0_scbuf0_ctag_en_c7;// From sctag0 of sctag.v
   wire			sctag0_scbuf0_ctag_en_c7_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [2:0]		sctag0_scbuf0_ev_dword_r0;// From sctag0 of sctag.v
   wire [2:0]		sctag0_scbuf0_ev_dword_r0_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			sctag0_scbuf0_evict_en_r0;// From sctag0 of sctag.v
   wire			sctag0_scbuf0_evict_en_r0_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			sctag0_scbuf0_fbd_stdatasel_c3;// From sctag0 of sctag.v
   wire			sctag0_scbuf0_fbd_stdatasel_c3_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			sctag0_scbuf0_fbrd_en_c3;// From sctag0 of sctag.v
   wire			sctag0_scbuf0_fbrd_en_c3_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [2:0]		sctag0_scbuf0_fbrd_wl_c3;// From sctag0 of sctag.v
   wire [2:0]		sctag0_scbuf0_fbrd_wl_c3_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [15:0]		sctag0_scbuf0_fbwr_wen_r2;// From sctag0 of sctag.v
   wire [15:0]		sctag0_scbuf0_fbwr_wen_r2_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [2:0]		sctag0_scbuf0_fbwr_wl_r2;// From sctag0 of sctag.v
   wire [2:0]		sctag0_scbuf0_fbwr_wl_r2_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			sctag0_scbuf0_rdma_rden_r0;// From sctag0 of sctag.v
   wire			sctag0_scbuf0_rdma_rden_r0_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [1:0]		sctag0_scbuf0_rdma_rdwl_r0;// From sctag0 of sctag.v
   wire [1:0]		sctag0_scbuf0_rdma_rdwl_r0_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [15:0]		sctag0_scbuf0_rdma_wren_s2;// From sctag0 of sctag.v
   wire [15:0]		sctag0_scbuf0_rdma_wren_s2_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [1:0]		sctag0_scbuf0_rdma_wrwl_s2;// From sctag0 of sctag.v
   wire [1:0]		sctag0_scbuf0_rdma_wrwl_s2_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			sctag0_scbuf0_req_en_c7;// From sctag0 of sctag.v
   wire			sctag0_scbuf0_req_en_c7_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [77:0]		sctag0_scbuf0_stdecc_c3;// From sctag0 of sctag.v
   wire [77:0]		sctag0_scbuf0_stdecc_c3_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			sctag0_scbuf0_wbrd_en_r0;// From sctag0 of sctag.v
   wire			sctag0_scbuf0_wbrd_en_r0_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [2:0]		sctag0_scbuf0_wbrd_wl_r0;// From sctag0 of sctag.v
   wire [2:0]		sctag0_scbuf0_wbrd_wl_r0_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [3:0]		sctag0_scbuf0_wbwr_wen_c6;// From sctag0 of sctag.v
   wire [3:0]		sctag0_scbuf0_wbwr_wen_c6_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [2:0]		sctag0_scbuf0_wbwr_wl_c6;// From sctag0 of sctag.v
   wire [2:0]		sctag0_scbuf0_wbwr_wl_c6_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [3:0]		sctag0_scbuf0_word_c7;	// From sctag0 of sctag.v
   wire [3:0]		sctag0_scbuf0_word_c7_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire			sctag0_scbuf0_word_vld_c7;// From sctag0 of sctag.v
   wire			sctag0_scbuf0_word_vld_c7_buf;// From sctag_scbuf_rptr0 of sctag_scbuf_rptr0.v
   wire [3:0]		sctag0_scdata0_col_offset_c2;// From sctag0 of sctag.v
   wire			sctag0_scdata0_fb_hit_c3;// From sctag0 of sctag.v
   wire			sctag0_scdata0_fbrd_c3;	// From sctag0 of sctag.v
   wire			sctag0_scdata0_rd_wr_c2;// From sctag0 of sctag.v
   wire [9:0]		sctag0_scdata0_set_c2;	// From sctag0 of sctag.v
   wire [77:0]		sctag0_scdata0_stdecc_c2;// From sctag0 of sctag.v
   wire [11:0]		sctag0_scdata0_way_sel_c2;// From sctag0 of sctag.v
   wire [15:0]		sctag0_scdata0_word_en_c2;// From sctag0 of sctag.v
   wire			sctag1_cpx_atom_cq;	// To/From v_m_help of v_m_help.v, ...
   wire [`CPX_WIDTH-1:0]sctag1_cpx_data_ca;	// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		sctag1_cpx_req_cq;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag1_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag1_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			sctag1_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag1_ctu_mbisterr_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			sctag1_ctu_tr;		// To/From v_m_help of v_m_help.v, ...
   wire			sctag1_ctu_tr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire [40:0]		sctag1_dbgbus_out;	// From sctag1 of sctag.v
   wire [39:5]		sctag1_dram13_addr;	// From sctag1 of sctag.v
   wire [39:5]		sctag1_dram13_addr_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire [39:5]		sctag1_dram13_addr_buf3;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire [39:5]		sctag1_dram13_addr_d1;	// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			sctag1_dram13_rd_dummy_req;// From sctag1 of sctag.v
   wire			sctag1_dram13_rd_dummy_req_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			sctag1_dram13_rd_dummy_req_buf3;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			sctag1_dram13_rd_dummy_req_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			sctag1_dram13_rd_req;	// From sctag1 of sctag.v
   wire			sctag1_dram13_rd_req_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			sctag1_dram13_rd_req_buf3;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			sctag1_dram13_rd_req_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire [2:0]		sctag1_dram13_rd_req_id;// From sctag1 of sctag.v
   wire [2:0]		sctag1_dram13_rd_req_id_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire [2:0]		sctag1_dram13_rd_req_id_buf3;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire [2:0]		sctag1_dram13_rd_req_id_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			sctag1_dram13_wr_req;	// From sctag1 of sctag.v
   wire			sctag1_dram13_wr_req_buf2;// From dram_sc_1_rep2 of dram_sc_1_rep2.v
   wire			sctag1_dram13_wr_req_buf3;// From dram_sc_1_rep1 of dram_l2_buf2.v
   wire			sctag1_dram13_wr_req_d1;// From ff_dram_sc_bank1 of ff_dram_sc_bank1.v
   wire			sctag1_efc_fuse_data;	// From sctag1 of sctag.v
   wire			sctag1_jbi_iq_dequeue;	// From sctag1 of sctag.v
   wire			sctag1_jbi_iq_dequeue_d1;// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire			sctag1_jbi_iq_dequeue_d1_buf1;// From rep_jbi_sc1_1 of jbi_l2_buf2.v
   wire			sctag1_jbi_iq_dequeue_d2;// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire			sctag1_jbi_por_req;	// From sctag1 of sctag.v
   wire			sctag1_jbi_por_req_d1;	// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire			sctag1_jbi_por_req_d1_buf1;// From rep_jbi_sc1_1 of jbi_l2_buf2.v
   wire			sctag1_jbi_por_req_d2;	// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire			sctag1_jbi_wib_dequeue;	// From sctag1 of sctag.v
   wire			sctag1_jbi_wib_dequeue_d1;// From ff_jbi_sc1_2 of ff_jbi_sc1_2.v
   wire			sctag1_jbi_wib_dequeue_d1_buf1;// From rep_jbi_sc1_1 of jbi_l2_buf2.v
   wire			sctag1_jbi_wib_dequeue_d2;// From ff_jbi_sc1_1 of ff_jbi_sc1_1.v
   wire			sctag1_pcx_stall_pq;	// To/From v_m_help of v_m_help.v, ...
   wire [14:0]		sctag1_scbuf1_ctag_c7;	// From sctag1 of sctag.v
   wire [14:0]		sctag1_scbuf1_ctag_c7_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			sctag1_scbuf1_ctag_en_c7;// From sctag1 of sctag.v
   wire			sctag1_scbuf1_ctag_en_c7_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [2:0]		sctag1_scbuf1_ev_dword_r0;// From sctag1 of sctag.v
   wire [2:0]		sctag1_scbuf1_ev_dword_r0_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			sctag1_scbuf1_evict_en_r0;// From sctag1 of sctag.v
   wire			sctag1_scbuf1_evict_en_r0_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			sctag1_scbuf1_fbd_stdatasel_c3;// From sctag1 of sctag.v
   wire			sctag1_scbuf1_fbd_stdatasel_c3_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			sctag1_scbuf1_fbrd_en_c3;// From sctag1 of sctag.v
   wire			sctag1_scbuf1_fbrd_en_c3_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [2:0]		sctag1_scbuf1_fbrd_wl_c3;// From sctag1 of sctag.v
   wire [2:0]		sctag1_scbuf1_fbrd_wl_c3_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [15:0]		sctag1_scbuf1_fbwr_wen_r2;// From sctag1 of sctag.v
   wire [15:0]		sctag1_scbuf1_fbwr_wen_r2_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [2:0]		sctag1_scbuf1_fbwr_wl_r2;// From sctag1 of sctag.v
   wire [2:0]		sctag1_scbuf1_fbwr_wl_r2_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			sctag1_scbuf1_rdma_rden_r0;// From sctag1 of sctag.v
   wire			sctag1_scbuf1_rdma_rden_r0_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [1:0]		sctag1_scbuf1_rdma_rdwl_r0;// From sctag1 of sctag.v
   wire [1:0]		sctag1_scbuf1_rdma_rdwl_r0_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [15:0]		sctag1_scbuf1_rdma_wren_s2;// From sctag1 of sctag.v
   wire [15:0]		sctag1_scbuf1_rdma_wren_s2_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [1:0]		sctag1_scbuf1_rdma_wrwl_s2;// From sctag1 of sctag.v
   wire [1:0]		sctag1_scbuf1_rdma_wrwl_s2_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			sctag1_scbuf1_req_en_c7;// From sctag1 of sctag.v
   wire			sctag1_scbuf1_req_en_c7_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [77:0]		sctag1_scbuf1_stdecc_c3;// From sctag1 of sctag.v
   wire [77:0]		sctag1_scbuf1_stdecc_c3_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			sctag1_scbuf1_wbrd_en_r0;// From sctag1 of sctag.v
   wire			sctag1_scbuf1_wbrd_en_r0_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [2:0]		sctag1_scbuf1_wbrd_wl_r0;// From sctag1 of sctag.v
   wire [2:0]		sctag1_scbuf1_wbrd_wl_r0_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [3:0]		sctag1_scbuf1_wbwr_wen_c6;// From sctag1 of sctag.v
   wire [3:0]		sctag1_scbuf1_wbwr_wen_c6_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [2:0]		sctag1_scbuf1_wbwr_wl_c6;// From sctag1 of sctag.v
   wire [2:0]		sctag1_scbuf1_wbwr_wl_c6_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [3:0]		sctag1_scbuf1_word_c7;	// From sctag1 of sctag.v
   wire [3:0]		sctag1_scbuf1_word_c7_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire			sctag1_scbuf1_word_vld_c7;// From sctag1 of sctag.v
   wire			sctag1_scbuf1_word_vld_c7_buf;// From sctag_scbuf_rptr1 of sctag_scbuf_rptr1.v
   wire [3:0]		sctag1_scdata1_col_offset_c2;// From sctag1 of sctag.v
   wire			sctag1_scdata1_fb_hit_c3;// From sctag1 of sctag.v
   wire			sctag1_scdata1_fbrd_c3;	// From sctag1 of sctag.v
   wire			sctag1_scdata1_rd_wr_c2;// From sctag1 of sctag.v
   wire [9:0]		sctag1_scdata1_set_c2;	// From sctag1 of sctag.v
   wire [77:0]		sctag1_scdata1_stdecc_c2;// From sctag1 of sctag.v
   wire [11:0]		sctag1_scdata1_way_sel_c2;// From sctag1 of sctag.v
   wire [15:0]		sctag1_scdata1_word_en_c2;// From sctag1 of sctag.v
   wire			sctag2_cpx_atom_cq;	// To/From v_m_help of v_m_help.v, ...
   wire [`CPX_WIDTH-1:0]sctag2_cpx_data_ca;	// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		sctag2_cpx_req_cq;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag2_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag2_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			sctag2_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag2_ctu_mbisterr_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			sctag2_ctu_tr;		// To/From v_m_help of v_m_help.v, ...
   wire			sctag2_ctu_tr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire [40:0]		sctag2_dbgbus_out;	// From sctag2 of sctag.v
   wire [39:5]		sctag2_dram02_addr;	// From sctag2 of sctag.v
   wire [39:5]		sctag2_dram02_addr_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire [39:5]		sctag2_dram02_addr_buf3;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire [39:5]		sctag2_dram02_addr_d1;	// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			sctag2_dram02_rd_dummy_req;// From sctag2 of sctag.v
   wire			sctag2_dram02_rd_dummy_req_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			sctag2_dram02_rd_dummy_req_buf3;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			sctag2_dram02_rd_dummy_req_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			sctag2_dram02_rd_req;	// From sctag2 of sctag.v
   wire			sctag2_dram02_rd_req_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			sctag2_dram02_rd_req_buf3;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			sctag2_dram02_rd_req_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire [2:0]		sctag2_dram02_rd_req_id;// From sctag2 of sctag.v
   wire [2:0]		sctag2_dram02_rd_req_id_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire [2:0]		sctag2_dram02_rd_req_id_buf3;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire [2:0]		sctag2_dram02_rd_req_id_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			sctag2_dram02_wr_req;	// From sctag2 of sctag.v
   wire			sctag2_dram02_wr_req_buf2;// From dram_sc_2_rep2 of dram_sc_2_rep2.v
   wire			sctag2_dram02_wr_req_buf3;// From dram_sc_2_rep1 of dram_l2_buf2.v
   wire			sctag2_dram02_wr_req_d1;// From ff_dram_sc_bank2 of ff_dram_sc_bank2.v
   wire			sctag2_efc_fuse_data;	// From sctag2 of sctag.v
   wire			sctag2_jbi_iq_dequeue;	// From sctag2 of sctag.v
   wire			sctag2_jbi_iq_dequeue_d1;// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire			sctag2_jbi_iq_dequeue_d1_buf1;// From rep_jbi_sc2_1 of jbi_l2_buf2.v
   wire			sctag2_jbi_iq_dequeue_d2;// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire			sctag2_jbi_por_req;	// From sctag2 of sctag.v
   wire			sctag2_jbi_por_req_d1;	// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire			sctag2_jbi_por_req_d1_buf1;// From rep_jbi_sc2_1 of jbi_l2_buf2.v
   wire			sctag2_jbi_por_req_d2;	// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire			sctag2_jbi_wib_dequeue;	// From sctag2 of sctag.v
   wire			sctag2_jbi_wib_dequeue_d1;// From ff_jbi_sc2_2 of ff_jbi_sc2_2.v
   wire			sctag2_jbi_wib_dequeue_d1_buf1;// From rep_jbi_sc2_1 of jbi_l2_buf2.v
   wire			sctag2_jbi_wib_dequeue_d2;// From ff_jbi_sc2_1 of ff_jbi_sc2_1.v
   wire			sctag2_pcx_stall_pq;	// To/From v_m_help of v_m_help.v, ...
   wire [14:0]		sctag2_scbuf2_ctag_c7;	// From sctag2 of sctag.v
   wire [14:0]		sctag2_scbuf2_ctag_c7_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			sctag2_scbuf2_ctag_en_c7;// From sctag2 of sctag.v
   wire			sctag2_scbuf2_ctag_en_c7_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [2:0]		sctag2_scbuf2_ev_dword_r0;// From sctag2 of sctag.v
   wire [2:0]		sctag2_scbuf2_ev_dword_r0_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			sctag2_scbuf2_evict_en_r0;// From sctag2 of sctag.v
   wire			sctag2_scbuf2_evict_en_r0_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			sctag2_scbuf2_fbd_stdatasel_c3;// From sctag2 of sctag.v
   wire			sctag2_scbuf2_fbd_stdatasel_c3_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			sctag2_scbuf2_fbrd_en_c3;// From sctag2 of sctag.v
   wire			sctag2_scbuf2_fbrd_en_c3_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [2:0]		sctag2_scbuf2_fbrd_wl_c3;// From sctag2 of sctag.v
   wire [2:0]		sctag2_scbuf2_fbrd_wl_c3_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [15:0]		sctag2_scbuf2_fbwr_wen_r2;// From sctag2 of sctag.v
   wire [15:0]		sctag2_scbuf2_fbwr_wen_r2_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [2:0]		sctag2_scbuf2_fbwr_wl_r2;// From sctag2 of sctag.v
   wire [2:0]		sctag2_scbuf2_fbwr_wl_r2_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			sctag2_scbuf2_rdma_rden_r0;// From sctag2 of sctag.v
   wire			sctag2_scbuf2_rdma_rden_r0_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [1:0]		sctag2_scbuf2_rdma_rdwl_r0;// From sctag2 of sctag.v
   wire [1:0]		sctag2_scbuf2_rdma_rdwl_r0_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [15:0]		sctag2_scbuf2_rdma_wren_s2;// From sctag2 of sctag.v
   wire [15:0]		sctag2_scbuf2_rdma_wren_s2_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [1:0]		sctag2_scbuf2_rdma_wrwl_s2;// From sctag2 of sctag.v
   wire [1:0]		sctag2_scbuf2_rdma_wrwl_s2_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			sctag2_scbuf2_req_en_c7;// From sctag2 of sctag.v
   wire			sctag2_scbuf2_req_en_c7_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [77:0]		sctag2_scbuf2_stdecc_c3;// From sctag2 of sctag.v
   wire [77:0]		sctag2_scbuf2_stdecc_c3_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			sctag2_scbuf2_wbrd_en_r0;// From sctag2 of sctag.v
   wire			sctag2_scbuf2_wbrd_en_r0_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [2:0]		sctag2_scbuf2_wbrd_wl_r0;// From sctag2 of sctag.v
   wire [2:0]		sctag2_scbuf2_wbrd_wl_r0_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [3:0]		sctag2_scbuf2_wbwr_wen_c6;// From sctag2 of sctag.v
   wire [3:0]		sctag2_scbuf2_wbwr_wen_c6_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [2:0]		sctag2_scbuf2_wbwr_wl_c6;// From sctag2 of sctag.v
   wire [2:0]		sctag2_scbuf2_wbwr_wl_c6_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [3:0]		sctag2_scbuf2_word_c7;	// From sctag2 of sctag.v
   wire [3:0]		sctag2_scbuf2_word_c7_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire			sctag2_scbuf2_word_vld_c7;// From sctag2 of sctag.v
   wire			sctag2_scbuf2_word_vld_c7_buf;// From sctag_scbuf_rptr2 of sctag_scbuf_rptr2.v
   wire [3:0]		sctag2_scdata2_col_offset_c2;// From sctag2 of sctag.v
   wire			sctag2_scdata2_fb_hit_c3;// From sctag2 of sctag.v
   wire			sctag2_scdata2_fbrd_c3;	// From sctag2 of sctag.v
   wire			sctag2_scdata2_rd_wr_c2;// From sctag2 of sctag.v
   wire [9:0]		sctag2_scdata2_set_c2;	// From sctag2 of sctag.v
   wire [77:0]		sctag2_scdata2_stdecc_c2;// From sctag2 of sctag.v
   wire [11:0]		sctag2_scdata2_way_sel_c2;// From sctag2 of sctag.v
   wire [15:0]		sctag2_scdata2_word_en_c2;// From sctag2 of sctag.v
   wire			sctag3_cpx_atom_cq;	// To/From v_m_help of v_m_help.v, ...
   wire [`CPX_WIDTH-1:0]sctag3_cpx_data_ca;	// To/From v_m_help of v_m_help.v, ...
   wire [7:0]		sctag3_cpx_req_cq;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag3_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag3_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			sctag3_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			sctag3_ctu_mbisterr_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			sctag3_ctu_tr;		// To/From v_m_help of v_m_help.v, ...
   wire			sctag3_ctu_tr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire [40:0]		sctag3_dbgbus_out;	// From sctag3 of sctag.v
   wire [39:5]		sctag3_dram13_addr;	// From sctag3 of sctag.v
   wire [39:5]		sctag3_dram13_addr_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire [39:5]		sctag3_dram13_addr_buf3;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire [39:5]		sctag3_dram13_addr_d1;	// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			sctag3_dram13_rd_dummy_req;// From sctag3 of sctag.v
   wire			sctag3_dram13_rd_dummy_req_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			sctag3_dram13_rd_dummy_req_buf3;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			sctag3_dram13_rd_dummy_req_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			sctag3_dram13_rd_req;	// From sctag3 of sctag.v
   wire			sctag3_dram13_rd_req_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			sctag3_dram13_rd_req_buf3;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			sctag3_dram13_rd_req_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire [2:0]		sctag3_dram13_rd_req_id;// From sctag3 of sctag.v
   wire [2:0]		sctag3_dram13_rd_req_id_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire [2:0]		sctag3_dram13_rd_req_id_buf3;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire [2:0]		sctag3_dram13_rd_req_id_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			sctag3_dram13_wr_req;	// From sctag3 of sctag.v
   wire			sctag3_dram13_wr_req_buf2;// From dram_sc_3_rep2 of dram_sc_3_rep2.v
   wire			sctag3_dram13_wr_req_buf3;// From dram_sc_3_rep1 of dram_l2_buf2.v
   wire			sctag3_dram13_wr_req_d1;// From ff_dram_sc_bank3 of ff_dram_sc_bank3.v
   wire			sctag3_efc_fuse_data;	// From sctag3 of sctag.v
   wire			sctag3_jbi_iq_dequeue;	// From sctag3 of sctag.v
   wire			sctag3_jbi_iq_dequeue_d1;// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire			sctag3_jbi_iq_dequeue_d1_buf1;// From rep_jbi_sc3_1 of jbi_l2_buf2.v
   wire			sctag3_jbi_iq_dequeue_d2;// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire			sctag3_jbi_por_req;	// From sctag3 of sctag.v
   wire			sctag3_jbi_por_req_d1;	// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire			sctag3_jbi_por_req_d1_buf1;// From rep_jbi_sc3_1 of jbi_l2_buf2.v
   wire			sctag3_jbi_por_req_d2;	// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire			sctag3_jbi_wib_dequeue;	// From sctag3 of sctag.v
   wire			sctag3_jbi_wib_dequeue_d1;// From ff_jbi_sc3_2 of ff_jbi_sc3_2.v
   wire			sctag3_jbi_wib_dequeue_d1_buf1;// From rep_jbi_sc3_1 of jbi_l2_buf2.v
   wire			sctag3_jbi_wib_dequeue_d2;// From ff_jbi_sc3_1 of ff_jbi_sc3_1.v
   wire			sctag3_pcx_stall_pq;	// To/From v_m_help of v_m_help.v, ...
   wire [14:0]		sctag3_scbuf3_ctag_c7;	// From sctag3 of sctag.v
   wire [14:0]		sctag3_scbuf3_ctag_c7_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			sctag3_scbuf3_ctag_en_c7;// From sctag3 of sctag.v
   wire			sctag3_scbuf3_ctag_en_c7_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [2:0]		sctag3_scbuf3_ev_dword_r0;// From sctag3 of sctag.v
   wire [2:0]		sctag3_scbuf3_ev_dword_r0_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			sctag3_scbuf3_evict_en_r0;// From sctag3 of sctag.v
   wire			sctag3_scbuf3_evict_en_r0_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			sctag3_scbuf3_fbd_stdatasel_c3;// From sctag3 of sctag.v
   wire			sctag3_scbuf3_fbd_stdatasel_c3_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			sctag3_scbuf3_fbrd_en_c3;// From sctag3 of sctag.v
   wire			sctag3_scbuf3_fbrd_en_c3_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [2:0]		sctag3_scbuf3_fbrd_wl_c3;// From sctag3 of sctag.v
   wire [2:0]		sctag3_scbuf3_fbrd_wl_c3_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [15:0]		sctag3_scbuf3_fbwr_wen_r2;// From sctag3 of sctag.v
   wire [15:0]		sctag3_scbuf3_fbwr_wen_r2_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [2:0]		sctag3_scbuf3_fbwr_wl_r2;// From sctag3 of sctag.v
   wire [2:0]		sctag3_scbuf3_fbwr_wl_r2_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			sctag3_scbuf3_rdma_rden_r0;// From sctag3 of sctag.v
   wire			sctag3_scbuf3_rdma_rden_r0_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [1:0]		sctag3_scbuf3_rdma_rdwl_r0;// From sctag3 of sctag.v
   wire [1:0]		sctag3_scbuf3_rdma_rdwl_r0_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [15:0]		sctag3_scbuf3_rdma_wren_s2;// From sctag3 of sctag.v
   wire [15:0]		sctag3_scbuf3_rdma_wren_s2_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [1:0]		sctag3_scbuf3_rdma_wrwl_s2;// From sctag3 of sctag.v
   wire [1:0]		sctag3_scbuf3_rdma_wrwl_s2_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			sctag3_scbuf3_req_en_c7;// From sctag3 of sctag.v
   wire			sctag3_scbuf3_req_en_c7_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [77:0]		sctag3_scbuf3_stdecc_c3;// From sctag3 of sctag.v
   wire [77:0]		sctag3_scbuf3_stdecc_c3_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			sctag3_scbuf3_wbrd_en_r0;// From sctag3 of sctag.v
   wire			sctag3_scbuf3_wbrd_en_r0_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [2:0]		sctag3_scbuf3_wbrd_wl_r0;// From sctag3 of sctag.v
   wire [2:0]		sctag3_scbuf3_wbrd_wl_r0_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [3:0]		sctag3_scbuf3_wbwr_wen_c6;// From sctag3 of sctag.v
   wire [3:0]		sctag3_scbuf3_wbwr_wen_c6_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [2:0]		sctag3_scbuf3_wbwr_wl_c6;// From sctag3 of sctag.v
   wire [2:0]		sctag3_scbuf3_wbwr_wl_c6_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [3:0]		sctag3_scbuf3_word_c7;	// From sctag3 of sctag.v
   wire [3:0]		sctag3_scbuf3_word_c7_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire			sctag3_scbuf3_word_vld_c7;// From sctag3 of sctag.v
   wire			sctag3_scbuf3_word_vld_c7_buf;// From sctag_scbuf_rptr3 of sctag_scbuf_rptr3.v
   wire [3:0]		sctag3_scdata3_col_offset_c2;// From sctag3 of sctag.v
   wire			sctag3_scdata3_fb_hit_c3;// From sctag3 of sctag.v
   wire			sctag3_scdata3_fbrd_c3;	// From sctag3 of sctag.v
   wire			sctag3_scdata3_rd_wr_c2;// From sctag3 of sctag.v
   wire [9:0]		sctag3_scdata3_set_c2;	// From sctag3 of sctag.v
   wire [77:0]		sctag3_scdata3_stdecc_c2;// From sctag3 of sctag.v
   wire [11:0]		sctag3_scdata3_way_sel_c2;// From sctag3 of sctag.v
   wire [15:0]		sctag3_scdata3_word_en_c2;// From sctag3 of sctag.v
   wire [30:0]		ser_scan_out;		// To/From v_m_help of v_m_help.v
   wire			spc0_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			spc0_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			spc0_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			spc0_ctu_mbisterr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			spc0_ctu_sscan_out;	// From sparc0 of sparc.v
   wire			spc0_efc_dfuse_data;	// From sparc0 of sparc.v
   wire			spc0_efc_ifuse_data;	// From sparc0 of sparc.v
   wire			spc0_pcx_atom_pq;	// From sparc0 of sparc.v
   wire			spc0_pcx_atom_pq_buf;	// From buf_pcx_0 of spc_pcx_buf.v
   wire			spc0_pcx_atom_pq_buf1;	// From ccx_spc_rpt0 of ccx_spc_rpt.v
   wire [`PCX_WIDTH-1:0]spc0_pcx_data_pa;	// From sparc0 of sparc.v
   wire [`PCX_WIDTH-1:0]spc0_pcx_data_pa_buf;	// From buf_pcx_0 of spc_pcx_buf.v
   wire [`PCX_WIDTH-1:0]spc0_pcx_data_pa_buf1;	// From ccx_spc_rpt0 of ccx_spc_rpt.v
   wire [4:0]		spc0_pcx_req_pq;	// From sparc0 of sparc.v
   wire [4:0]		spc0_pcx_req_pq_buf;	// From buf_pcx_0 of spc_pcx_buf.v
   wire [4:0]		spc0_pcx_req_pq_buf1;	// From ccx_spc_rpt0 of ccx_spc_rpt.v
   wire			spc1_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			spc1_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			spc1_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			spc1_ctu_mbisterr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			spc1_ctu_sscan_out;	// From sparc1 of sparc.v
   wire			spc1_efc_dfuse_data;	// From sparc1 of sparc.v
   wire			spc1_efc_ifuse_data;	// From sparc1 of sparc.v
   wire			spc1_pcx_atom_pq;	// From sparc1 of sparc.v
   wire			spc1_pcx_atom_pq_buf;	// From buf_pcx_1 of spc_pcx_buf.v
   wire			spc1_pcx_atom_pq_buf1;	// From ccx_spc_rpt1 of ccx_spc_rpt.v
   wire [`PCX_WIDTH-1:0]spc1_pcx_data_pa;	// From sparc1 of sparc.v
   wire [`PCX_WIDTH-1:0]spc1_pcx_data_pa_buf;	// From buf_pcx_1 of spc_pcx_buf.v
   wire [`PCX_WIDTH-1:0]spc1_pcx_data_pa_buf1;	// From ccx_spc_rpt1 of ccx_spc_rpt.v
   wire [4:0]		spc1_pcx_req_pq;	// From sparc1 of sparc.v
   wire [4:0]		spc1_pcx_req_pq_buf;	// From buf_pcx_1 of spc_pcx_buf.v
   wire [4:0]		spc1_pcx_req_pq_buf1;	// From ccx_spc_rpt1 of ccx_spc_rpt.v
   wire			spc2_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			spc2_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			spc2_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			spc2_ctu_mbisterr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			spc2_ctu_sscan_out;	// From sparc2 of sparc.v
   wire			spc2_efc_dfuse_data;	// From sparc2 of sparc.v
   wire			spc2_efc_ifuse_data;	// From sparc2 of sparc.v
   wire			spc2_pcx_atom_pq;	// From sparc2 of sparc.v
   wire			spc2_pcx_atom_pq_buf;	// From buf_pcx_2 of spc_pcx_buf.v
   wire			spc2_pcx_atom_pq_buf1;	// From ccx_spc_rpt2 of ccx_spc_rpt.v
   wire [`PCX_WIDTH-1:0]spc2_pcx_data_pa;	// From sparc2 of sparc.v
   wire [`PCX_WIDTH-1:0]spc2_pcx_data_pa_buf;	// From buf_pcx_2 of spc_pcx_buf.v
   wire [`PCX_WIDTH-1:0]spc2_pcx_data_pa_buf1;	// From ccx_spc_rpt2 of ccx_spc_rpt.v
   wire [4:0]		spc2_pcx_req_pq;	// From sparc2 of sparc.v
   wire [4:0]		spc2_pcx_req_pq_buf;	// From buf_pcx_2 of spc_pcx_buf.v
   wire [4:0]		spc2_pcx_req_pq_buf1;	// From ccx_spc_rpt2 of ccx_spc_rpt.v
   wire			spc3_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			spc3_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			spc3_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			spc3_ctu_mbisterr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			spc3_ctu_sscan_out;	// From sparc3 of sparc.v
   wire			spc3_efc_dfuse_data;	// From sparc3 of sparc.v
   wire			spc3_efc_ifuse_data;	// From sparc3 of sparc.v
   wire			spc3_pcx_atom_pq;	// From sparc3 of sparc.v
   wire			spc3_pcx_atom_pq_buf;	// From buf_pcx_3 of spc_pcx_buf.v
   wire			spc3_pcx_atom_pq_buf1;	// From ccx_spc_rpt3 of ccx_spc_rpt.v
   wire [`PCX_WIDTH-1:0]spc3_pcx_data_pa;	// From sparc3 of sparc.v
   wire [`PCX_WIDTH-1:0]spc3_pcx_data_pa_buf;	// From buf_pcx_3 of spc_pcx_buf.v
   wire [`PCX_WIDTH-1:0]spc3_pcx_data_pa_buf1;	// From ccx_spc_rpt3 of ccx_spc_rpt.v
   wire [4:0]		spc3_pcx_req_pq;	// From sparc3 of sparc.v
   wire [4:0]		spc3_pcx_req_pq_buf;	// From buf_pcx_3 of spc_pcx_buf.v
   wire [4:0]		spc3_pcx_req_pq_buf1;	// From ccx_spc_rpt3 of ccx_spc_rpt.v
   wire			spc4_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			spc4_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			spc4_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			spc4_ctu_mbisterr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			spc4_ctu_sscan_out;	// From sparc4 of sparc.v
   wire			spc4_efc_dfuse_data;	// From sparc4 of sparc.v
   wire			spc4_efc_ifuse_data;	// From sparc4 of sparc.v
   wire			spc4_pcx_atom_pq;	// From sparc4 of sparc.v
   wire			spc4_pcx_atom_pq_buf;	// From buf_pcx_4 of spc_pcx_buf.v
   wire			spc4_pcx_atom_pq_buf1;	// From ccx_spc_rpt4 of ccx_spc_rpt.v
   wire [`PCX_WIDTH-1:0]spc4_pcx_data_pa;	// From sparc4 of sparc.v
   wire [`PCX_WIDTH-1:0]spc4_pcx_data_pa_buf;	// From buf_pcx_4 of spc_pcx_buf.v
   wire [`PCX_WIDTH-1:0]spc4_pcx_data_pa_buf1;	// From ccx_spc_rpt4 of ccx_spc_rpt.v
   wire [4:0]		spc4_pcx_req_pq;	// From sparc4 of sparc.v
   wire [4:0]		spc4_pcx_req_pq_buf;	// From buf_pcx_4 of spc_pcx_buf.v
   wire [4:0]		spc4_pcx_req_pq_buf1;	// From ccx_spc_rpt4 of ccx_spc_rpt.v
   wire			spc5_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			spc5_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			spc5_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			spc5_ctu_mbisterr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			spc5_ctu_sscan_out;	// From sparc5 of sparc.v
   wire			spc5_efc_dfuse_data;	// From sparc5 of sparc.v
   wire			spc5_efc_ifuse_data;	// From sparc5 of sparc.v
   wire			spc5_pcx_atom_pq;	// From sparc5 of sparc.v
   wire			spc5_pcx_atom_pq_buf;	// From buf_pcx_5 of spc_pcx_buf.v
   wire			spc5_pcx_atom_pq_buf1;	// From ccx_spc_rpt5 of ccx_spc_rpt.v
   wire [`PCX_WIDTH-1:0]spc5_pcx_data_pa;	// From sparc5 of sparc.v
   wire [`PCX_WIDTH-1:0]spc5_pcx_data_pa_buf;	// From buf_pcx_5 of spc_pcx_buf.v
   wire [`PCX_WIDTH-1:0]spc5_pcx_data_pa_buf1;	// From ccx_spc_rpt5 of ccx_spc_rpt.v
   wire [4:0]		spc5_pcx_req_pq;	// From sparc5 of sparc.v
   wire [4:0]		spc5_pcx_req_pq_buf;	// From buf_pcx_5 of spc_pcx_buf.v
   wire [4:0]		spc5_pcx_req_pq_buf1;	// From ccx_spc_rpt5 of ccx_spc_rpt.v
   wire			spc6_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			spc6_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			spc6_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			spc6_ctu_mbisterr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			spc6_ctu_sscan_out;	// From sparc6 of sparc.v
   wire			spc6_efc_dfuse_data;	// From sparc6 of sparc.v
   wire			spc6_efc_ifuse_data;	// From sparc6 of sparc.v
   wire			spc6_pcx_atom_pq;	// From sparc6 of sparc.v
   wire			spc6_pcx_atom_pq_buf;	// From buf_pcx_6 of spc_pcx_buf.v
   wire			spc6_pcx_atom_pq_buf1;	// From ccx_spc_rpt6 of ccx_spc_rpt.v
   wire [`PCX_WIDTH-1:0]spc6_pcx_data_pa;	// From sparc6 of sparc.v
   wire [`PCX_WIDTH-1:0]spc6_pcx_data_pa_buf;	// From buf_pcx_6 of spc_pcx_buf.v
   wire [`PCX_WIDTH-1:0]spc6_pcx_data_pa_buf1;	// From ccx_spc_rpt6 of ccx_spc_rpt.v
   wire [4:0]		spc6_pcx_req_pq;	// From sparc6 of sparc.v
   wire [4:0]		spc6_pcx_req_pq_buf;	// From buf_pcx_6 of spc_pcx_buf.v
   wire [4:0]		spc6_pcx_req_pq_buf1;	// From ccx_spc_rpt6 of ccx_spc_rpt.v
   wire			spc7_ctu_mbistdone;	// To/From v_m_help of v_m_help.v, ...
   wire			spc7_ctu_mbistdone_buf2;// To/From v_m_help of v_m_help.v, ...
   wire			spc7_ctu_mbisterr;	// To/From v_m_help of v_m_help.v, ...
   wire			spc7_ctu_mbisterr_buf2;	// To/From v_m_help of v_m_help.v, ...
   wire			spc7_ctu_sscan_out;	// From sparc7 of sparc.v
   wire			spc7_efc_dfuse_data;	// From sparc7 of sparc.v
   wire			spc7_efc_ifuse_data;	// From sparc7 of sparc.v
   wire			spc7_pcx_atom_pq;	// From sparc7 of sparc.v
   wire			spc7_pcx_atom_pq_buf;	// From buf_pcx_7 of spc_pcx_buf.v
   wire			spc7_pcx_atom_pq_buf1;	// From ccx_spc_rpt7 of ccx_spc_rpt.v
   wire [`PCX_WIDTH-1:0]spc7_pcx_data_pa;	// From sparc7 of sparc.v
   wire [`PCX_WIDTH-1:0]spc7_pcx_data_pa_buf;	// From buf_pcx_7 of spc_pcx_buf.v
   wire [`PCX_WIDTH-1:0]spc7_pcx_data_pa_buf1;	// From ccx_spc_rpt7 of ccx_spc_rpt.v
   wire [4:0]		spc7_pcx_req_pq;	// From sparc7 of sparc.v
   wire [4:0]		spc7_pcx_req_pq_buf;	// From buf_pcx_7 of spc_pcx_buf.v
   wire [4:0]		spc7_pcx_req_pq_buf1;	// From ccx_spc_rpt7 of ccx_spc_rpt.v
   wire [7:0]		tap_iob_data;		// From ctu of ctu.v
   wire			tap_iob_stall;		// From ctu of ctu.v
   wire			tap_iob_vld;		// From ctu of ctu.v
   // End of automatics

   wire [143:0]         ddr0_afo = 144'b0;
   wire [143:0]         ddr1_afo = 144'b0;
   wire [143:0]         ddr2_afo = 144'b0;
   wire [143:0]         ddr3_afo = 144'b0;

   wire [143:0]         ddr0_sin = 144'b0;
   wire [143:0]         ddr1_sin = 144'b0;
   wire [143:0]         ddr2_sin = 144'b0;
   wire [143:0]         ddr3_sin = 144'b0;
   wire [ 56: 0]        jbusr_sin=  57'b0;
   wire [127:57]        jbusl_sin=  71'b0;
   wire [127:57]        dbg_sin  =  71'b0;
   wire [127:57]        dbg_from_core_unused = 71'b0;

   wire [143:0]         ddr0_sot;		
   wire [143:0]         ddr1_sot;		
   wire [143:0]         ddr2_sot;		
   wire [143:0]         ddr3_sot;		
   wire [ 56: 0]        jbusr_sot;		
   wire [127:57]        jbusl_sot;		
   wire [127:57]        dbg_sot;		

   wire [143:0]         ddr0_afi;		
   wire [143:0]         ddr1_afi;		
   wire [143:0]         ddr2_afi;		
   wire [143:0]         ddr3_afi;		

   wire [255:0] 	io_dram0_data_in_buf0;
   wire [31:0] 		io_dram0_ecc_in_buf0;
   wire [255:0] 	io_dram0_data_in_buf2;
   wire [31:0] 		io_dram0_ecc_in_buf2;
   wire [255:0] 	io_dram0_data_in_buf1;
   wire [31:0] 		io_dram0_ecc_in_buf1;
   wire [255:0] 	io_dram1_data_in_buf0;
   wire [31:0] 		io_dram1_ecc_in_buf0;
   wire [255:0] 	io_dram1_data_in_buf2;
   wire [31:0] 		io_dram1_ecc_in_buf2;
   wire [255:0] 	io_dram1_data_in_buf1;
   wire [31:0] 		io_dram1_ecc_in_buf1;
   wire [255:0] 	io_dram2_data_in_buf0;
   wire [31:0] 		io_dram2_ecc_in_buf0;
   wire [255:0] 	io_dram2_data_in_buf2;
   wire [31:0] 		io_dram2_ecc_in_buf2;
   wire [255:0] 	io_dram2_data_in_buf1;
   wire [31:0] 		io_dram2_ecc_in_buf1;
   wire [255:0] 	io_dram3_data_in_buf0;
   wire [31:0] 		io_dram3_ecc_in_buf0;
   wire [255:0] 	io_dram3_data_in_buf2;
   wire [31:0] 		io_dram3_ecc_in_buf2;
   wire [255:0] 	io_dram3_data_in_buf1;
   wire [31:0] 		io_dram3_ecc_in_buf1;

   wire [4:0]		dram0_io_ptr_clk_inv_buf0;
   wire [14:0]	 	dram0_io_addr_buf0;
   wire [287:0] 	dram0_io_data_out_buf0;
   wire [3:0] 		dram0_io_cs_l_buf0;
   wire [2:0] 		dram0_io_bank_buf0;
   wire [4:0]		dram0_io_ptr_clk_inv_buf1;
   wire [14:0]	 	dram0_io_addr_buf1;
   wire [287:0] 	dram0_io_data_out_buf1;
   wire [3:0] 		dram0_io_cs_l_buf1;
   wire [2:0] 		dram0_io_bank_buf1;
   wire [4:0]		dram0_io_ptr_clk_inv_buf2;
   wire [14:0]	 	dram0_io_addr_buf2;
   wire [287:0] 	dram0_io_data_out_buf2;
   wire [3:0] 		dram0_io_cs_l_buf2;
   wire [2:0] 		dram0_io_bank_buf2;
   wire [4:0]           dram1_io_ptr_clk_inv_buf0;
   wire [14:0]          dram1_io_addr_buf0;
   wire [287:0]         dram1_io_data_out_buf0;
   wire [3:0]           dram1_io_cs_l_buf0;
   wire [2:0]           dram1_io_bank_buf0;
   wire [4:0]           dram1_io_ptr_clk_inv_buf1;
   wire [14:0]          dram1_io_addr_buf1;
   wire [287:0]         dram1_io_data_out_buf1;
   wire [3:0]           dram1_io_cs_l_buf1;
   wire [2:0]           dram1_io_bank_buf1;
   wire [4:0]           dram1_io_ptr_clk_inv_buf2;
   wire [14:0]          dram1_io_addr_buf2;
   wire [287:0]         dram1_io_data_out_buf2;
   wire [3:0]           dram1_io_cs_l_buf2;
   wire [2:0]           dram1_io_bank_buf2;
   wire [4:0]           dram2_io_ptr_clk_inv_buf0;
   wire [14:0]          dram2_io_addr_buf0;
   wire [287:0]         dram2_io_data_out_buf0;
   wire [3:0]           dram2_io_cs_l_buf0;
   wire [2:0]           dram2_io_bank_buf0;
   wire [4:0]           dram2_io_ptr_clk_inv_buf1;
   wire [14:0]          dram2_io_addr_buf1;
   wire [287:0]         dram2_io_data_out_buf1;
   wire [3:0]           dram2_io_cs_l_buf1;
   wire [2:0]           dram2_io_bank_buf1;
   wire [4:0]           dram2_io_ptr_clk_inv_buf2;
   wire [14:0]          dram2_io_addr_buf2;
   wire [287:0]         dram2_io_data_out_buf2;
   wire [3:0]           dram2_io_cs_l_buf2;
   wire [2:0]           dram2_io_bank_buf2;
   wire [4:0]           dram3_io_ptr_clk_inv_buf0;
   wire [14:0]          dram3_io_addr_buf0;
   wire [287:0]         dram3_io_data_out_buf0;
   wire [3:0]           dram3_io_cs_l_buf0;
   wire [2:0]           dram3_io_bank_buf0;
   wire [4:0]           dram3_io_ptr_clk_inv_buf1;
   wire [14:0]          dram3_io_addr_buf1;
   wire [287:0]         dram3_io_data_out_buf1;
   wire [3:0]           dram3_io_cs_l_buf1;
   wire [2:0]           dram3_io_bank_buf1;
   wire [4:0]           dram3_io_ptr_clk_inv_buf2;
   wire [14:0]          dram3_io_addr_buf2;
   wire [287:0]         dram3_io_data_out_buf2;
   wire [3:0]           dram3_io_cs_l_buf2;
   wire [2:0]           dram3_io_bank_buf2;
   wire [127:57]        dbg_to_core_unused;
   wire [19:0]		ctu_top_rptr_unused;
   wire [19:0]		ctu_top_rptr2_unused;
   wire [19:0]		ctu_bottom_rptr_unused;
   wire [19:0]		ctu_bottom_rptr2_unused;

   wire [36:0]		unused_sctag_pcx_rptr_0i;
   wire [36:0]		unused_sctag_pcx_rptr_0;
   wire [36:0]		unused_sctag_pcx_rptr_1i;
   wire [36:0]		unused_sctag_pcx_rptr_1;
   wire [36:0]		unused_sctag_pcx_rptr_2i;
   wire [36:0]		unused_sctag_pcx_rptr_2;
   wire [36:0]		unused_sctag_pcx_rptr_3i;
   wire [36:0]		unused_sctag_pcx_rptr_3;
   wire [`PCX_WIDTH-1:0]pcx_sctag0_data_px2_buf;
   wire [`PCX_WIDTH-1:0]pcx_sctag1_data_px2_buf;
   wire [`PCX_WIDTH-1:0]pcx_sctag2_data_px2_buf;
   wire [`PCX_WIDTH-1:0]pcx_sctag3_data_px2_buf;
   wire			sctag0_pcx_stall_pq_buf;
   wire			sctag1_pcx_stall_pq_buf;
   wire			sctag2_pcx_stall_pq_buf;
   wire			sctag3_pcx_stall_pq_buf;
   wire			pcx_sctag0_data_rdy_px1_buf;
   wire			pcx_sctag1_data_rdy_px1_buf;
   wire			pcx_sctag2_data_rdy_px1_buf;
   wire			pcx_sctag3_data_rdy_px1_buf;
   wire			pcx_sctag0_atm_px1_buf;
   wire			pcx_sctag1_atm_px1_buf;
   wire			pcx_sctag2_atm_px1_buf;
   wire			pcx_sctag3_atm_px1_buf;
   wire [1:0]		unused_sctag_cpx_rptr_0i;
   wire [1:0]		unused_sctag_cpx_rptr_0;
   wire [1:0]		unused_sctag_cpx_rptr_1i;
   wire [1:0]		unused_sctag_cpx_rptr_1;
   wire [1:0]		unused_sctag_cpx_rptr_2i;
   wire [1:0]		unused_sctag_cpx_rptr_2;
   wire [1:0]		unused_sctag_cpx_rptr_3i;
   wire [1:0]		unused_sctag_cpx_rptr_3;
   wire [7:0]		cpx_sctag0_grant_cx_buf;
   wire [7:0]		cpx_sctag1_grant_cx_buf;
   wire [7:0]		cpx_sctag2_grant_cx_buf;
   wire [7:0]		cpx_sctag3_grant_cx_buf;
   wire [7:0]		sctag0_cpx_req_cq_buf;
   wire [7:0]		sctag1_cpx_req_cq_buf;
   wire [7:0]		sctag2_cpx_req_cq_buf;
   wire [7:0]		sctag3_cpx_req_cq_buf;
   wire			sctag0_cpx_atom_cq_buf;
   wire			sctag1_cpx_atom_cq_buf;
   wire			sctag2_cpx_atom_cq_buf;
   wire			sctag3_cpx_atom_cq_buf;
   wire	[`CPX_WIDTH-1:0]sctag0_cpx_data_ca_buf;
   wire	[`CPX_WIDTH-1:0]sctag1_cpx_data_ca_buf;
   wire	[`CPX_WIDTH-1:0]sctag2_cpx_data_ca_buf;
   wire	[`CPX_WIDTH-1:0]sctag3_cpx_data_ca_buf;
   wire [7:0]		cpx_iob_grant_cx2_buf;
   wire [`PCX_WIDTH-1:0]pcx_iob_data_px2_buf;
   wire			pcx_iob_data_rdy_px2_buf;
   wire [2:0]		unused_ccx_iob_rptri;
   wire [2:0]		unused_ccx_iob_rptr;
   wire [`CPX_WIDTH-1:0]iob_cpx_data_ca_buf;
   wire [`IOB_CPU_WIDTH-1:0]iob_cpx_req_cq_buf;
   wire			iob_pcx_stall_pq_buf;
   wire [9:0]		unused_iob_ccx_rptr_bufi;
   wire [9:0]		unused_iob_ccx_rptr_buf;
   wire [47:0]		iob_jbi_dbg_hi_data_buf;
   wire [47:0]		iob_jbi_dbg_lo_data_buf;
   wire [`IOB_JBI_WIDTH-1:0]iob_jbi_pio_data_buf;
   wire [`IOB_SPI_WIDTH-1:0]iob_jbi_spi_data_buf;
   wire [`JBI_IOB_MONDO_BUS_WIDTH-1:0]jbi_iob_mondo_data_buf;
   wire			jbi_iob_mondo_vld_buf;
   wire [`JBI_IOB_WIDTH-1:0]jbi_iob_pio_data_buf;
   wire			jbi_iob_pio_stall_buf;
   wire			jbi_iob_pio_vld_buf;
   wire [`SPI_IOB_WIDTH-1:0]jbi_iob_spi_data_buf;
   wire			jbi_iob_spi_stall_buf;
   wire			jbi_iob_spi_vld_buf;
   wire			iob_jbi_dbg_hi_vld_buf;
   wire			iob_jbi_dbg_lo_vld_buf;
   wire			iob_jbi_mondo_ack_buf;
   wire			iob_jbi_mondo_nack_buf;
   wire			iob_jbi_pio_stall_buf;
   wire			iob_jbi_pio_vld_buf;
   wire			iob_jbi_spi_stall_buf;
   wire			iob_jbi_spi_vld_buf;
   wire [94:0]		unused_iob_jbi_rptr_1i;
   wire [94:0]		unused_iob_jbi_rptr_1;


   assign  VDD_SENSE = 1'b1;
   assign  VSS_SENSE = 1'b0;



`ifdef DO_NOT_DEFINE_VERILOG_MODE_EXPAND
   v_m_help v_m_help
     (/*AUTOINST*/
      // Inouts
      .afi_bist_mode			(afi_bist_mode),
      .afi_bypass_mode			(afi_bypass_mode),
      .afi_pll_char_mode		(afi_pll_char_mode),
      .afi_pll_clamp_fltr		(afi_pll_clamp_fltr),
      .afi_pll_div2			(afi_pll_div2[5:0]),
      .afi_pll_trst_l			(afi_pll_trst_l),
      .afi_rng_ctl			(afi_rng_ctl[2:0]),
      .afi_rt_addr_data			(afi_rt_addr_data),
      .afi_rt_data_in			(afi_rt_data_in[31:0]),
      .afi_rt_high_low			(afi_rt_high_low),
      .afi_rt_read_write		(afi_rt_read_write),
      .afi_rt_valid			(afi_rt_valid),
      .afi_tsr_div			(afi_tsr_div[9:1]),
      .afi_tsr_mode			(afi_tsr_mode),
      .afi_tsr_tsel			(afi_tsr_tsel[7:0]),
      .afo_rng_clk			(afo_rng_clk),
      .afo_rng_data			(afo_rng_data),
      .afo_rt_ack			(afo_rt_ack),
      .afo_rt_data_out			(afo_rt_data_out[31:0]),
      .afo_tsr_dout			(afo_tsr_dout[7:0]),
      .cpx_iob_grant_cx2		(cpx_iob_grant_cx2[7:0]),
      .cpx_sctag0_grant_cx		(cpx_sctag0_grant_cx[7:0]),
      .cpx_sctag1_grant_cx		(cpx_sctag1_grant_cx[7:0]),
      .cpx_sctag2_grant_cx		(cpx_sctag2_grant_cx[7:0]),
      .cpx_sctag3_grant_cx		(cpx_sctag3_grant_cx[7:0]),
      .ctu_sctag0_mbisten		(ctu_sctag0_mbisten),
      .ctu_sctag0_mbisten_buf2		(ctu_sctag0_mbisten_buf2),
      .ctu_sctag0_mbisten_buf2		(ctu_sctag0_mbisten_buf2),
      .ctu_sctag1_mbisten		(ctu_sctag1_mbisten),
      .ctu_sctag1_mbisten_buf2		(ctu_sctag1_mbisten_buf2),
      .ctu_sctag1_mbisten_buf2		(ctu_sctag1_mbisten_buf2),
      .ctu_sctag2_mbisten		(ctu_sctag2_mbisten),
      .ctu_sctag2_mbisten_buf2		(ctu_sctag2_mbisten_buf2),
      .ctu_sctag2_mbisten_buf2		(ctu_sctag2_mbisten_buf2),
      .ctu_sctag3_mbisten		(ctu_sctag3_mbisten),
      .ctu_sctag3_mbisten_buf2		(ctu_sctag3_mbisten_buf2),
      .ctu_sctag3_mbisten_buf2		(ctu_sctag3_mbisten_buf2),
      .ctu_spc0_mbisten			(ctu_spc0_mbisten),
      .ctu_spc0_mbisten_buf2		(ctu_spc0_mbisten_buf2),
      .ctu_spc0_mbisten_buf2		(ctu_spc0_mbisten_buf2),
      .ctu_spc1_mbisten			(ctu_spc1_mbisten),
      .ctu_spc1_mbisten_buf2		(ctu_spc1_mbisten_buf2),
      .ctu_spc1_mbisten_buf2		(ctu_spc1_mbisten_buf2),
      .ctu_spc2_mbisten			(ctu_spc2_mbisten),
      .ctu_spc2_mbisten_buf2		(ctu_spc2_mbisten_buf2),
      .ctu_spc2_mbisten_buf2		(ctu_spc2_mbisten_buf2),
      .ctu_spc3_mbisten			(ctu_spc3_mbisten),
      .ctu_spc3_mbisten_buf2		(ctu_spc3_mbisten_buf2),
      .ctu_spc3_mbisten_buf2		(ctu_spc3_mbisten_buf2),
      .ctu_spc4_mbisten			(ctu_spc4_mbisten),
      .ctu_spc4_mbisten_buf2		(ctu_spc4_mbisten_buf2),
      .ctu_spc4_mbisten_buf2		(ctu_spc4_mbisten_buf2),
      .ctu_spc5_mbisten			(ctu_spc5_mbisten),
      .ctu_spc5_mbisten_buf2		(ctu_spc5_mbisten_buf2),
      .ctu_spc5_mbisten_buf2		(ctu_spc5_mbisten_buf2),
      .ctu_spc6_mbisten			(ctu_spc6_mbisten),
      .ctu_spc6_mbisten_buf2		(ctu_spc6_mbisten_buf2),
      .ctu_spc6_mbisten_buf2		(ctu_spc6_mbisten_buf2),
      .ctu_spc7_mbisten			(ctu_spc7_mbisten),
      .ctu_spc7_mbisten_buf2		(ctu_spc7_mbisten_buf2),
      .ctu_spc7_mbisten_buf2		(ctu_spc7_mbisten_buf2),
      .dram0_io_addr			(dram0_io_addr[14:0]),
      .dram0_io_bank			(dram0_io_bank[2:0]),
      .dram0_io_cas_l			(dram0_io_cas_l),
      .dram0_io_cas_l_buf2		(dram0_io_cas_l_buf2),
      .dram0_io_channel_disabled	(dram0_io_channel_disabled),
      .dram0_io_channel_disabled_buf2	(dram0_io_channel_disabled_buf2),
      .dram0_io_cke			(dram0_io_cke),
      .dram0_io_cke_buf2		(dram0_io_cke_buf2),
      .dram0_io_clk_enable		(dram0_io_clk_enable),
      .dram0_io_clk_enable_buf2		(dram0_io_clk_enable_buf2),
      .dram0_io_cs_l			(dram0_io_cs_l[3:0]),
      .dram0_io_data_out		(dram0_io_data_out[287:0]),
      .dram0_io_drive_data		(dram0_io_drive_data),
      .dram0_io_drive_data_buf2		(dram0_io_drive_data_buf2),
      .dram0_io_drive_enable		(dram0_io_drive_enable),
      .dram0_io_drive_enable_buf2	(dram0_io_drive_enable_buf2),
      .dram0_io_pad_clk_inv		(dram0_io_pad_clk_inv),
      .dram0_io_pad_clk_inv_buf2	(dram0_io_pad_clk_inv_buf2),
      .dram0_io_pad_enable		(dram0_io_pad_enable),
      .dram0_io_pad_enable_buf2		(dram0_io_pad_enable_buf2),
      .dram0_io_ptr_clk_inv		(dram0_io_ptr_clk_inv[4:0]),
      .dram0_io_ras_l			(dram0_io_ras_l),
      .dram0_io_ras_l_buf2		(dram0_io_ras_l_buf2),
      .dram0_io_write_en_l		(dram0_io_write_en_l),
      .dram0_io_write_en_l_buf2		(dram0_io_write_en_l_buf2),
      .dram1_io_addr			(dram1_io_addr[14:0]),
      .dram1_io_bank			(dram1_io_bank[2:0]),
      .dram1_io_cas_l			(dram1_io_cas_l),
      .dram1_io_cas_l_buf2		(dram1_io_cas_l_buf2),
      .dram1_io_channel_disabled	(dram1_io_channel_disabled),
      .dram1_io_channel_disabled_buf2	(dram1_io_channel_disabled_buf2),
      .dram1_io_cke			(dram1_io_cke),
      .dram1_io_cke_buf2		(dram1_io_cke_buf2),
      .dram1_io_clk_enable		(dram1_io_clk_enable),
      .dram1_io_clk_enable_buf2		(dram1_io_clk_enable_buf2),
      .dram1_io_cs_l			(dram1_io_cs_l[3:0]),
      .dram1_io_data_out		(dram1_io_data_out[287:0]),
      .dram1_io_drive_data		(dram1_io_drive_data),
      .dram1_io_drive_data_buf2		(dram1_io_drive_data_buf2),
      .dram1_io_drive_enable		(dram1_io_drive_enable),
      .dram1_io_drive_enable_buf2	(dram1_io_drive_enable_buf2),
      .dram1_io_pad_clk_inv		(dram1_io_pad_clk_inv),
      .dram1_io_pad_clk_inv_buf2	(dram1_io_pad_clk_inv_buf2),
      .dram1_io_pad_enable		(dram1_io_pad_enable),
      .dram1_io_pad_enable_buf2		(dram1_io_pad_enable_buf2),
      .dram1_io_ptr_clk_inv		(dram1_io_ptr_clk_inv[4:0]),
      .dram1_io_ras_l			(dram1_io_ras_l),
      .dram1_io_ras_l_buf2		(dram1_io_ras_l_buf2),
      .dram1_io_write_en_l		(dram1_io_write_en_l),
      .dram1_io_write_en_l_buf2		(dram1_io_write_en_l_buf2),
      .dram2_io_addr			(dram2_io_addr[14:0]),
      .dram2_io_bank			(dram2_io_bank[2:0]),
      .dram2_io_cas_l			(dram2_io_cas_l),
      .dram2_io_cas_l_buf2		(dram2_io_cas_l_buf2),
      .dram2_io_channel_disabled	(dram2_io_channel_disabled),
      .dram2_io_channel_disabled_buf2	(dram2_io_channel_disabled_buf2),
      .dram2_io_cke			(dram2_io_cke),
      .dram2_io_cke_buf2		(dram2_io_cke_buf2),
      .dram2_io_clk_enable		(dram2_io_clk_enable),
      .dram2_io_clk_enable_buf2		(dram2_io_clk_enable_buf2),
      .dram2_io_cs_l			(dram2_io_cs_l[3:0]),
      .dram2_io_data_out		(dram2_io_data_out[287:0]),
      .dram2_io_drive_data		(dram2_io_drive_data),
      .dram2_io_drive_data_buf2		(dram2_io_drive_data_buf2),
      .dram2_io_drive_enable		(dram2_io_drive_enable),
      .dram2_io_drive_enable_buf2	(dram2_io_drive_enable_buf2),
      .dram2_io_pad_clk_inv		(dram2_io_pad_clk_inv),
      .dram2_io_pad_clk_inv_buf2	(dram2_io_pad_clk_inv_buf2),
      .dram2_io_pad_enable		(dram2_io_pad_enable),
      .dram2_io_pad_enable_buf2		(dram2_io_pad_enable_buf2),
      .dram2_io_ptr_clk_inv		(dram2_io_ptr_clk_inv[4:0]),
      .dram2_io_ras_l			(dram2_io_ras_l),
      .dram2_io_ras_l_buf2		(dram2_io_ras_l_buf2),
      .dram2_io_write_en_l		(dram2_io_write_en_l),
      .dram2_io_write_en_l_buf2		(dram2_io_write_en_l_buf2),
      .dram3_io_addr			(dram3_io_addr[14:0]),
      .dram3_io_bank			(dram3_io_bank[2:0]),
      .dram3_io_cas_l			(dram3_io_cas_l),
      .dram3_io_cas_l_buf2		(dram3_io_cas_l_buf2),
      .dram3_io_channel_disabled	(dram3_io_channel_disabled),
      .dram3_io_channel_disabled_buf2	(dram3_io_channel_disabled_buf2),
      .dram3_io_cke			(dram3_io_cke),
      .dram3_io_cke_buf2		(dram3_io_cke_buf2),
      .dram3_io_clk_enable		(dram3_io_clk_enable),
      .dram3_io_clk_enable_buf2		(dram3_io_clk_enable_buf2),
      .dram3_io_cs_l			(dram3_io_cs_l[3:0]),
      .dram3_io_data_out		(dram3_io_data_out[287:0]),
      .dram3_io_drive_data		(dram3_io_drive_data),
      .dram3_io_drive_data_buf2		(dram3_io_drive_data_buf2),
      .dram3_io_drive_enable		(dram3_io_drive_enable),
      .dram3_io_drive_enable_buf2	(dram3_io_drive_enable_buf2),
      .dram3_io_pad_clk_inv		(dram3_io_pad_clk_inv),
      .dram3_io_pad_clk_inv_buf2	(dram3_io_pad_clk_inv_buf2),
      .dram3_io_pad_enable		(dram3_io_pad_enable),
      .dram3_io_pad_enable_buf2		(dram3_io_pad_enable_buf2),
      .dram3_io_ptr_clk_inv		(dram3_io_ptr_clk_inv[4:0]),
      .dram3_io_ras_l			(dram3_io_ras_l),
      .dram3_io_ras_l_buf2		(dram3_io_ras_l_buf2),
      .dram3_io_write_en_l		(dram3_io_write_en_l),
      .dram3_io_write_en_l_buf2		(dram3_io_write_en_l_buf2),
      .dram_gclk_c0_r			(dram_gclk_c0_r[7:0]),
      .dram_gclk_c2_r			(dram_gclk_c2_r[7:0]),
      .dram_gclk_c3_r			(dram_gclk_c3_r[7:0]),
      .io_do_bist			(io_do_bist),
      .io_dram0_data_in			(io_dram0_data_in[255:0]),
      .io_dram0_data_valid		(io_dram0_data_valid),
      .io_dram0_data_valid_buf0		(io_dram0_data_valid_buf0),
      .io_dram0_ecc_in			(io_dram0_ecc_in[31:0]),
      .io_dram1_data_in			(io_dram1_data_in[255:0]),
      .io_dram1_data_valid		(io_dram1_data_valid),
      .io_dram1_data_valid_buf0		(io_dram1_data_valid_buf0),
      .io_dram1_ecc_in			(io_dram1_ecc_in[31:0]),
      .io_dram2_data_in			(io_dram2_data_in[255:0]),
      .io_dram2_data_valid		(io_dram2_data_valid),
      .io_dram2_data_valid_buf0		(io_dram2_data_valid_buf0),
      .io_dram2_ecc_in			(io_dram2_ecc_in[31:0]),
      .io_dram3_data_in			(io_dram3_data_in[255:0]),
      .io_dram3_data_valid		(io_dram3_data_valid),
      .io_dram3_data_valid_buf0		(io_dram3_data_valid_buf0),
      .io_dram3_ecc_in			(io_dram3_ecc_in[31:0]),
      .iob_cpx_data_ca			(iob_cpx_data_ca[`CPX_WIDTH-1:0]),
      .iob_cpx_req_cq			(iob_cpx_req_cq[`IOB_CPU_WIDTH-1:0]),
      .iob_io_dbg_ck_n			(iob_io_dbg_ck_n[2:0]),
      .iob_io_dbg_ck_p			(iob_io_dbg_ck_p[2:0]),
      .iob_io_dbg_data			(iob_io_dbg_data[39:0]),
      .iob_io_dbg_en			(iob_io_dbg_en),
      .iob_jbi_dbg_hi_data		(iob_jbi_dbg_hi_data[47:0]),
      .iob_jbi_dbg_hi_vld		(iob_jbi_dbg_hi_vld),
      .iob_jbi_dbg_lo_data		(iob_jbi_dbg_lo_data[47:0]),
      .iob_jbi_dbg_lo_vld		(iob_jbi_dbg_lo_vld),
      .iob_jbi_mondo_ack		(iob_jbi_mondo_ack),
      .iob_jbi_mondo_nack		(iob_jbi_mondo_nack),
      .iob_jbi_pio_data			(iob_jbi_pio_data[`IOB_JBI_WIDTH-1:0]),
      .iob_jbi_pio_stall		(iob_jbi_pio_stall),
      .iob_jbi_pio_vld			(iob_jbi_pio_vld),
      .iob_jbi_spi_data			(iob_jbi_spi_data[`IOB_SPI_WIDTH-1:0]),
      .iob_jbi_spi_stall		(iob_jbi_spi_stall),
      .iob_jbi_spi_vld			(iob_jbi_spi_vld),
      .iob_pcx_stall_pq			(iob_pcx_stall_pq),
      .jbi_iob_mondo_data		(jbi_iob_mondo_data[`JBI_IOB_MONDO_BUS_WIDTH-1:0]),
      .jbi_iob_mondo_vld		(jbi_iob_mondo_vld),
      .jbi_iob_pio_data			(jbi_iob_pio_data[`JBI_IOB_WIDTH-1:0]),
      .jbi_iob_pio_stall		(jbi_iob_pio_stall),
      .jbi_iob_pio_vld			(jbi_iob_pio_vld),
      .jbi_iob_spi_data			(jbi_iob_spi_data[`SPI_IOB_WIDTH-1:0]),
      .jbi_iob_spi_stall		(jbi_iob_spi_stall),
      .jbi_iob_spi_vld			(jbi_iob_spi_vld),
      .par_scan_head			(par_scan_head[30:0]),
      .par_scan_tail			(par_scan_tail[30:0]),
      .pcx_iob_data_px2			(pcx_iob_data_px2[`PCX_WIDTH-1:0]),
      .pcx_iob_data_rdy_px2		(pcx_iob_data_rdy_px2),
      .pcx_sctag0_atm_px1		(pcx_sctag0_atm_px1),
      .pcx_sctag0_data_px2		(pcx_sctag0_data_px2[`PCX_WIDTH-1:0]),
      .pcx_sctag0_data_rdy_px1		(pcx_sctag0_data_rdy_px1),
      .pcx_sctag1_atm_px1		(pcx_sctag1_atm_px1),
      .pcx_sctag1_data_px2		(pcx_sctag1_data_px2[`PCX_WIDTH-1:0]),
      .pcx_sctag1_data_rdy_px1		(pcx_sctag1_data_rdy_px1),
      .pcx_sctag2_atm_px1		(pcx_sctag2_atm_px1),
      .pcx_sctag2_data_px2		(pcx_sctag2_data_px2[`PCX_WIDTH-1:0]),
      .pcx_sctag2_data_rdy_px1		(pcx_sctag2_data_rdy_px1),
      .pcx_sctag3_atm_px1		(pcx_sctag3_atm_px1),
      .pcx_sctag3_data_px2		(pcx_sctag3_data_px2[`PCX_WIDTH-1:0]),
      .pcx_sctag3_data_rdy_px1		(pcx_sctag3_data_rdy_px1),
      .pjbusl_rptrs_so			(pjbusl_rptrs_so),
      .pjbusr_rptrs_so			(pjbusr_rptrs_so),
      .rptrs_pdbg_so			(rptrs_pdbg_so),
      .rptrs_pmisc_so			(rptrs_pmisc_so),
      .rptrs_rsc12_so			(rptrs_rsc12_so),
      .rsc02_rptrs_so			(rsc02_rptrs_so),
      .sctag0_cpx_atom_cq		(sctag0_cpx_atom_cq),
      .sctag0_cpx_data_ca		(sctag0_cpx_data_ca[`CPX_WIDTH-1:0]),
      .sctag0_cpx_req_cq		(sctag0_cpx_req_cq[7:0]),
      .sctag0_ctu_mbistdone		(sctag0_ctu_mbistdone),
      .sctag0_ctu_mbistdone_buf2	(sctag0_ctu_mbistdone_buf2),
      .sctag0_ctu_mbistdone_buf2	(sctag0_ctu_mbistdone_buf2),
      .sctag0_ctu_mbisterr		(sctag0_ctu_mbisterr),
      .sctag0_ctu_mbisterr_buf2		(sctag0_ctu_mbisterr_buf2),
      .sctag0_ctu_mbisterr_buf2		(sctag0_ctu_mbisterr_buf2),
      .sctag0_ctu_tr			(sctag0_ctu_tr),
      .sctag0_ctu_tr_buf2		(sctag0_ctu_tr_buf2),
      .sctag0_ctu_tr_buf2		(sctag0_ctu_tr_buf2),
      .sctag0_pcx_stall_pq		(sctag0_pcx_stall_pq),
      .sctag1_cpx_atom_cq		(sctag1_cpx_atom_cq),
      .sctag1_cpx_data_ca		(sctag1_cpx_data_ca[`CPX_WIDTH-1:0]),
      .sctag1_cpx_req_cq		(sctag1_cpx_req_cq[7:0]),
      .sctag1_ctu_mbistdone		(sctag1_ctu_mbistdone),
      .sctag1_ctu_mbistdone_buf2	(sctag1_ctu_mbistdone_buf2),
      .sctag1_ctu_mbistdone_buf2	(sctag1_ctu_mbistdone_buf2),
      .sctag1_ctu_mbisterr		(sctag1_ctu_mbisterr),
      .sctag1_ctu_mbisterr_buf2		(sctag1_ctu_mbisterr_buf2),
      .sctag1_ctu_mbisterr_buf2		(sctag1_ctu_mbisterr_buf2),
      .sctag1_ctu_tr			(sctag1_ctu_tr),
      .sctag1_ctu_tr_buf2		(sctag1_ctu_tr_buf2),
      .sctag1_ctu_tr_buf2		(sctag1_ctu_tr_buf2),
      .sctag1_pcx_stall_pq		(sctag1_pcx_stall_pq),
      .sctag2_cpx_atom_cq		(sctag2_cpx_atom_cq),
      .sctag2_cpx_data_ca		(sctag2_cpx_data_ca[`CPX_WIDTH-1:0]),
      .sctag2_cpx_req_cq		(sctag2_cpx_req_cq[7:0]),
      .sctag2_ctu_mbistdone		(sctag2_ctu_mbistdone),
      .sctag2_ctu_mbistdone_buf2	(sctag2_ctu_mbistdone_buf2),
      .sctag2_ctu_mbistdone_buf2	(sctag2_ctu_mbistdone_buf2),
      .sctag2_ctu_mbisterr		(sctag2_ctu_mbisterr),
      .sctag2_ctu_mbisterr_buf2		(sctag2_ctu_mbisterr_buf2),
      .sctag2_ctu_mbisterr_buf2		(sctag2_ctu_mbisterr_buf2),
      .sctag2_ctu_tr			(sctag2_ctu_tr),
      .sctag2_ctu_tr_buf2		(sctag2_ctu_tr_buf2),
      .sctag2_ctu_tr_buf2		(sctag2_ctu_tr_buf2),
      .sctag2_pcx_stall_pq		(sctag2_pcx_stall_pq),
      .sctag3_cpx_atom_cq		(sctag3_cpx_atom_cq),
      .sctag3_cpx_data_ca		(sctag3_cpx_data_ca[`CPX_WIDTH-1:0]),
      .sctag3_cpx_req_cq		(sctag3_cpx_req_cq[7:0]),
      .sctag3_ctu_mbistdone		(sctag3_ctu_mbistdone),
      .sctag3_ctu_mbistdone_buf2	(sctag3_ctu_mbistdone_buf2),
      .sctag3_ctu_mbistdone_buf2	(sctag3_ctu_mbistdone_buf2),
      .sctag3_ctu_mbisterr		(sctag3_ctu_mbisterr),
      .sctag3_ctu_mbisterr_buf2		(sctag3_ctu_mbisterr_buf2),
      .sctag3_ctu_mbisterr_buf2		(sctag3_ctu_mbisterr_buf2),
      .sctag3_ctu_tr			(sctag3_ctu_tr),
      .sctag3_ctu_tr_buf2		(sctag3_ctu_tr_buf2),
      .sctag3_ctu_tr_buf2		(sctag3_ctu_tr_buf2),
      .sctag3_pcx_stall_pq		(sctag3_pcx_stall_pq),
      .ser_scan_out			(ser_scan_out[30:0]),
      .spc0_ctu_mbistdone		(spc0_ctu_mbistdone),
      .spc0_ctu_mbistdone_buf2		(spc0_ctu_mbistdone_buf2),
      .spc0_ctu_mbistdone_buf2		(spc0_ctu_mbistdone_buf2),
      .spc0_ctu_mbisterr		(spc0_ctu_mbisterr),
      .spc0_ctu_mbisterr_buf2		(spc0_ctu_mbisterr_buf2),
      .spc0_ctu_mbisterr_buf2		(spc0_ctu_mbisterr_buf2),
      .spc1_ctu_mbistdone		(spc1_ctu_mbistdone),
      .spc1_ctu_mbistdone_buf2		(spc1_ctu_mbistdone_buf2),
      .spc1_ctu_mbistdone_buf2		(spc1_ctu_mbistdone_buf2),
      .spc1_ctu_mbisterr		(spc1_ctu_mbisterr),
      .spc1_ctu_mbisterr_buf2		(spc1_ctu_mbisterr_buf2),
      .spc1_ctu_mbisterr_buf2		(spc1_ctu_mbisterr_buf2),
      .spc2_ctu_mbistdone		(spc2_ctu_mbistdone),
      .spc2_ctu_mbistdone_buf2		(spc2_ctu_mbistdone_buf2),
      .spc2_ctu_mbistdone_buf2		(spc2_ctu_mbistdone_buf2),
      .spc2_ctu_mbisterr		(spc2_ctu_mbisterr),
      .spc2_ctu_mbisterr_buf2		(spc2_ctu_mbisterr_buf2),
      .spc2_ctu_mbisterr_buf2		(spc2_ctu_mbisterr_buf2),
      .spc3_ctu_mbistdone		(spc3_ctu_mbistdone),
      .spc3_ctu_mbistdone_buf2		(spc3_ctu_mbistdone_buf2),
      .spc3_ctu_mbistdone_buf2		(spc3_ctu_mbistdone_buf2),
      .spc3_ctu_mbisterr		(spc3_ctu_mbisterr),
      .spc3_ctu_mbisterr_buf2		(spc3_ctu_mbisterr_buf2),
      .spc3_ctu_mbisterr_buf2		(spc3_ctu_mbisterr_buf2),
      .spc4_ctu_mbistdone		(spc4_ctu_mbistdone),
      .spc4_ctu_mbistdone_buf2		(spc4_ctu_mbistdone_buf2),
      .spc4_ctu_mbistdone_buf2		(spc4_ctu_mbistdone_buf2),
      .spc4_ctu_mbisterr		(spc4_ctu_mbisterr),
      .spc4_ctu_mbisterr_buf2		(spc4_ctu_mbisterr_buf2),
      .spc4_ctu_mbisterr_buf2		(spc4_ctu_mbisterr_buf2),
      .spc5_ctu_mbistdone		(spc5_ctu_mbistdone),
      .spc5_ctu_mbistdone_buf2		(spc5_ctu_mbistdone_buf2),
      .spc5_ctu_mbistdone_buf2		(spc5_ctu_mbistdone_buf2),
      .spc5_ctu_mbisterr		(spc5_ctu_mbisterr),
      .spc5_ctu_mbisterr_buf2		(spc5_ctu_mbisterr_buf2),
      .spc5_ctu_mbisterr_buf2		(spc5_ctu_mbisterr_buf2),
      .spc6_ctu_mbistdone		(spc6_ctu_mbistdone),
      .spc6_ctu_mbistdone_buf2		(spc6_ctu_mbistdone_buf2),
      .spc6_ctu_mbistdone_buf2		(spc6_ctu_mbistdone_buf2),
      .spc6_ctu_mbisterr		(spc6_ctu_mbisterr),
      .spc6_ctu_mbisterr_buf2		(spc6_ctu_mbisterr_buf2),
      .spc6_ctu_mbisterr_buf2		(spc6_ctu_mbisterr_buf2),
      .spc7_ctu_mbistdone		(spc7_ctu_mbistdone),
      .spc7_ctu_mbistdone_buf2		(spc7_ctu_mbistdone_buf2),
      .spc7_ctu_mbistdone_buf2		(spc7_ctu_mbistdone_buf2),
      .spc7_ctu_mbisterr		(spc7_ctu_mbisterr),
      .spc7_ctu_mbisterr_buf2		(spc7_ctu_mbisterr_buf2),
      .spc7_ctu_mbisterr_buf2		(spc7_ctu_mbisterr_buf2));
`endif
//


/* bw_temp_diode AUTO_TEMPLATE (
    .b                                  (DIODE_TOP[0]),
    .c                                  (DIODE_TOP[1]),
    .e                                  (DIODE_TOP[2]),
    ); */
//
   bw_temp_diode pad_diode0
     (/*AUTOINST*/
      // Inouts
      .b				(DIODE_TOP[0]),		 // Templated
      .c				(DIODE_TOP[1]),		 // Templated
      .e				(DIODE_TOP[2]));		 // Templated
//


/* bw_temp_diode AUTO_TEMPLATE (
    .b                                  (DIODE_BOT[0]),
    .c                                  (DIODE_BOT[1]),
    .e                                  (DIODE_BOT[2]),
    ); */
//
   bw_temp_diode pad_diode1
     (/*AUTOINST*/
      // Inouts
      .b				(DIODE_BOT[0]),		 // Templated
      .c				(DIODE_BOT[1]),		 // Templated
      .e				(DIODE_BOT[2]));		 // Templated
//


/* ctu AUTO_TEMPLATE (
    .io_vdda_pll                        (VDDA),
    .io_vdda_rng                        (VDDA),
    .io_vdda_tsr                        (VDDA),
    .io_j_clk                           (J_CLK[]),
    .ctu_io_tsr_testio                  (TSR_TESTIO[]),

    .cmp_gclk_out                       (cmp_gclk),
    .dram_gclk_out                      (dram_gclk),
    .jbus_gclk_out                      (jbus_gclk),

    .cmp_gclk				(cmp_gclk_c1_r[4]),
    .cmp_gclk_cts			(cmp_gclk_c1_r[4]),
    .dram_gclk_cts                      (dram_gclk_c1_r[4]),
    .jbus_gclk                          (jbus_gclk_c1_r[4]),
    .jbus_gclk_cts                      (jbus_gclk_c1_r[4]),

    .dram_grst_out_l                    (dram_grst_l),
    .dram_gdbginit_out_l                (dram_gdbginit_l),

    .jbus_grst_out_l                    (jbus_grst_l),
    .jbus_gdbginit_out_l                (jbus_gdbginit_l),

    .cmp_grst_l                         (rpt_cmp_grst_l_c3),

    .pads_ctu_bsi                       (ddr0_ctu_bso),
    .pads_ctu_si                        (rbot2_ctu_so),
    .ctu_fpu_so				(ctu_rtop2_so),
    .ctu_pads_bso                       (ctu_ddr1_bso),
    .ctu_pads_so                        (),

    .spc\([01234567]\)_ctu_mbistdone	(spc\1_ctu_mbistdone_buf2),
    .spc\([01234567]\)_ctu_mbisterr	(spc\1_ctu_mbisterr_buf2),
    .sctag\([0123]\)_ctu_mbistdone	(sctag\1_ctu_mbistdone_buf2),
    .sctag\([0123]\)_ctu_mbisterr	(sctag\1_ctu_mbisterr_buf2),
    .sctag\([0123]\)_ctu_tr		(sctag\1_ctu_tr_buf2),
    .dll\([0123]\)_ctu_ctrl		(ctu_dll\1_ctu_ctrl[]),
    .sctag2_ctu_serial_scan_in		(ser_scan_out[30]),
    ); */
//
`ifdef RTL_CTU
   ctu ctu
     (/*AUTOINST*/
      // Outputs
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .ctu_efc_read_start		(ctu_efc_read_start),
      .ctu_jbi_ssiclk			(ctu_jbi_ssiclk),
      .ctu_dram_rx_sync_out		(ctu_dram_rx_sync_out),
      .ctu_dram_tx_sync_out		(ctu_dram_tx_sync_out),
      .ctu_jbus_rx_sync_out		(ctu_jbus_rx_sync_out),
      .ctu_jbus_tx_sync_out		(ctu_jbus_tx_sync_out),
      .cmp_grst_out_l			(cmp_grst_out_l),
      .afo_rng_clk			(afo_rng_clk),
      .afo_rng_data			(afo_rng_data),
      .afo_rt_ack			(afo_rt_ack),
      .afo_rt_data_out			(afo_rt_data_out[31:0]),
      .afo_tsr_dout			(afo_tsr_dout[7:0]),
      .clsp_iob_data			(clsp_iob_data[`CLK_IOB_WIDTH-1:0]),
      .clsp_iob_stall			(clsp_iob_stall),
      .clsp_iob_vld			(clsp_iob_vld),
      .cmp_adbginit_l			(cmp_adbginit_l),
      .cmp_arst_l			(cmp_arst_l),
      .cmp_gclk_out			(cmp_gclk),		 // Templated
      .cmp_gdbginit_out_l		(cmp_gdbginit_out_l),
      .ctu_ccx_cmp_cken			(ctu_ccx_cmp_cken),
      .ctu_dbg_jbus_cken		(ctu_dbg_jbus_cken),
      .ctu_ddr0_clock_dr		(ctu_ddr0_clock_dr),
      .ctu_ddr0_dll_delayctr		(ctu_ddr0_dll_delayctr[2:0]),
      .ctu_ddr0_dram_cken		(ctu_ddr0_dram_cken),
      .ctu_ddr0_hiz_l			(ctu_ddr0_hiz_l),
      .ctu_ddr0_iodll_rst_l		(ctu_ddr0_iodll_rst_l),
      .ctu_ddr0_mode_ctl		(ctu_ddr0_mode_ctl),
      .ctu_ddr0_shift_dr		(ctu_ddr0_shift_dr),
      .ctu_ddr0_update_dr		(ctu_ddr0_update_dr),
      .ctu_ddr1_clock_dr		(ctu_ddr1_clock_dr),
      .ctu_ddr1_dll_delayctr		(ctu_ddr1_dll_delayctr[2:0]),
      .ctu_ddr1_dram_cken		(ctu_ddr1_dram_cken),
      .ctu_ddr1_hiz_l			(ctu_ddr1_hiz_l),
      .ctu_ddr1_iodll_rst_l		(ctu_ddr1_iodll_rst_l),
      .ctu_ddr1_mode_ctl		(ctu_ddr1_mode_ctl),
      .ctu_ddr1_shift_dr		(ctu_ddr1_shift_dr),
      .ctu_ddr1_update_dr		(ctu_ddr1_update_dr),
      .ctu_ddr2_clock_dr		(ctu_ddr2_clock_dr),
      .ctu_ddr2_dll_delayctr		(ctu_ddr2_dll_delayctr[2:0]),
      .ctu_ddr2_dram_cken		(ctu_ddr2_dram_cken),
      .ctu_ddr2_hiz_l			(ctu_ddr2_hiz_l),
      .ctu_ddr2_iodll_rst_l		(ctu_ddr2_iodll_rst_l),
      .ctu_ddr2_mode_ctl		(ctu_ddr2_mode_ctl),
      .ctu_ddr2_shift_dr		(ctu_ddr2_shift_dr),
      .ctu_ddr2_update_dr		(ctu_ddr2_update_dr),
      .ctu_ddr3_clock_dr		(ctu_ddr3_clock_dr),
      .ctu_ddr3_dll_delayctr		(ctu_ddr3_dll_delayctr[2:0]),
      .ctu_ddr3_dram_cken		(ctu_ddr3_dram_cken),
      .ctu_ddr3_hiz_l			(ctu_ddr3_hiz_l),
      .ctu_ddr3_iodll_rst_l		(ctu_ddr3_iodll_rst_l),
      .ctu_ddr3_mode_ctl		(ctu_ddr3_mode_ctl),
      .ctu_ddr3_shift_dr		(ctu_ddr3_shift_dr),
      .ctu_ddr3_update_dr		(ctu_ddr3_update_dr),
      .ctu_ddr_testmode_l		(ctu_ddr_testmode_l),
      .ctu_debug_clock_dr		(ctu_debug_clock_dr),
      .ctu_debug_hiz_l			(ctu_debug_hiz_l),
      .ctu_debug_mode_ctl		(ctu_debug_mode_ctl),
      .ctu_debug_shift_dr		(ctu_debug_shift_dr),
      .ctu_debug_update_dr		(ctu_debug_update_dr),
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
      .ctu_dram_selfrsh			(ctu_dram_selfrsh),
      .ctu_efc_capturedr		(ctu_efc_capturedr),
      .ctu_efc_coladdr			(ctu_efc_coladdr[4:0]),
      .ctu_efc_data_in			(ctu_efc_data_in),
      .ctu_efc_dest_sample		(ctu_efc_dest_sample),
      .ctu_efc_fuse_bypass		(ctu_efc_fuse_bypass),
      .ctu_efc_jbus_cken		(ctu_efc_jbus_cken),
      .ctu_efc_read_en			(ctu_efc_read_en),
      .ctu_efc_read_mode		(ctu_efc_read_mode[2:0]),
      .ctu_efc_rowaddr			(ctu_efc_rowaddr[6:0]),
      .ctu_efc_shiftdr			(ctu_efc_shiftdr),
      .ctu_efc_tck			(ctu_efc_tck),
      .ctu_efc_updatedr			(ctu_efc_updatedr),
      .ctu_fpu_cmp_cken			(ctu_fpu_cmp_cken),
      .ctu_fpu_so			(ctu_rtop2_so),		 // Templated
      .ctu_global_snap			(ctu_global_snap),
      .ctu_io_clkobs			(ctu_io_clkobs[1:0]),
      .ctu_io_j_err			(ctu_io_j_err),
      .ctu_io_tdo			(ctu_io_tdo),
      .ctu_io_tdo_en			(ctu_io_tdo_en),
      .ctu_io_tsr_testio		(TSR_TESTIO[1:0]),	 // Templated
      .ctu_iob_cmp_cken			(ctu_iob_cmp_cken),
      .ctu_iob_jbus_cken		(ctu_iob_jbus_cken),
      .ctu_iob_resetstat		(ctu_iob_resetstat[2:0]),
      .ctu_iob_resetstat_wr		(ctu_iob_resetstat_wr),
      .ctu_iob_wake_thr			(ctu_iob_wake_thr),
      .ctu_jbi_cmp_cken			(ctu_jbi_cmp_cken),
      .ctu_jbi_jbus_cken		(ctu_jbi_jbus_cken),
      .ctu_jbusl_clock_dr		(ctu_jbusl_clock_dr),
      .ctu_jbusl_hiz_l			(ctu_jbusl_hiz_l),
      .ctu_jbusl_jbus_cken		(ctu_jbusl_jbus_cken),
      .ctu_jbusl_mode_ctl		(ctu_jbusl_mode_ctl),
      .ctu_jbusl_shift_dr		(ctu_jbusl_shift_dr),
      .ctu_jbusl_update_dr		(ctu_jbusl_update_dr),
      .ctu_jbusr_clock_dr		(ctu_jbusr_clock_dr),
      .ctu_jbusr_hiz_l			(ctu_jbusr_hiz_l),
      .ctu_jbusr_jbus_cken		(ctu_jbusr_jbus_cken),
      .ctu_jbusr_mode_ctl		(ctu_jbusr_mode_ctl),
      .ctu_jbusr_shift_dr		(ctu_jbusr_shift_dr),
      .ctu_jbusr_update_dr		(ctu_jbusr_update_dr),
      .ctu_misc_clock_dr		(ctu_misc_clock_dr),
      .ctu_misc_hiz_l			(ctu_misc_hiz_l),
      .ctu_misc_jbus_cken		(ctu_misc_jbus_cken),
      .ctu_misc_mode_ctl		(ctu_misc_mode_ctl),
      .ctu_misc_shift_dr		(ctu_misc_shift_dr),
      .ctu_misc_update_dr		(ctu_misc_update_dr),
      .ctu_pads_bso			(ctu_ddr1_bso),		 // Templated
      .ctu_pads_so			(),			 // Templated
      .ctu_pads_sscan_update		(ctu_pads_sscan_update),
      .ctu_scdata0_cmp_cken		(ctu_scdata0_cmp_cken),
      .ctu_scdata1_cmp_cken		(ctu_scdata1_cmp_cken),
      .ctu_scdata2_cmp_cken		(ctu_scdata2_cmp_cken),
      .ctu_scdata3_cmp_cken		(ctu_scdata3_cmp_cken),
      .ctu_sctag0_cmp_cken		(ctu_sctag0_cmp_cken),
      .ctu_sctag0_mbisten		(ctu_sctag0_mbisten),
      .ctu_sctag1_cmp_cken		(ctu_sctag1_cmp_cken),
      .ctu_sctag1_mbisten		(ctu_sctag1_mbisten),
      .ctu_sctag2_cmp_cken		(ctu_sctag2_cmp_cken),
      .ctu_sctag2_mbisten		(ctu_sctag2_mbisten),
      .ctu_sctag3_cmp_cken		(ctu_sctag3_cmp_cken),
      .ctu_sctag3_mbisten		(ctu_sctag3_mbisten),
      .ctu_spc0_cmp_cken		(ctu_spc0_cmp_cken),
      .ctu_spc0_mbisten			(ctu_spc0_mbisten),
      .ctu_spc0_sscan_se		(ctu_spc0_sscan_se),
      .ctu_spc0_tck			(ctu_spc0_tck),
      .ctu_spc1_cmp_cken		(ctu_spc1_cmp_cken),
      .ctu_spc1_mbisten			(ctu_spc1_mbisten),
      .ctu_spc1_sscan_se		(ctu_spc1_sscan_se),
      .ctu_spc1_tck			(ctu_spc1_tck),
      .ctu_spc2_cmp_cken		(ctu_spc2_cmp_cken),
      .ctu_spc2_mbisten			(ctu_spc2_mbisten),
      .ctu_spc2_sscan_se		(ctu_spc2_sscan_se),
      .ctu_spc2_tck			(ctu_spc2_tck),
      .ctu_spc3_cmp_cken		(ctu_spc3_cmp_cken),
      .ctu_spc3_mbisten			(ctu_spc3_mbisten),
      .ctu_spc3_sscan_se		(ctu_spc3_sscan_se),
      .ctu_spc3_tck			(ctu_spc3_tck),
      .ctu_spc4_cmp_cken		(ctu_spc4_cmp_cken),
      .ctu_spc4_mbisten			(ctu_spc4_mbisten),
      .ctu_spc4_sscan_se		(ctu_spc4_sscan_se),
      .ctu_spc4_tck			(ctu_spc4_tck),
      .ctu_spc5_cmp_cken		(ctu_spc5_cmp_cken),
      .ctu_spc5_mbisten			(ctu_spc5_mbisten),
      .ctu_spc5_sscan_se		(ctu_spc5_sscan_se),
      .ctu_spc5_tck			(ctu_spc5_tck),
      .ctu_spc6_cmp_cken		(ctu_spc6_cmp_cken),
      .ctu_spc6_mbisten			(ctu_spc6_mbisten),
      .ctu_spc6_sscan_se		(ctu_spc6_sscan_se),
      .ctu_spc6_tck			(ctu_spc6_tck),
      .ctu_spc7_cmp_cken		(ctu_spc7_cmp_cken),
      .ctu_spc7_mbisten			(ctu_spc7_mbisten),
      .ctu_spc7_sscan_se		(ctu_spc7_sscan_se),
      .ctu_spc7_tck			(ctu_spc7_tck),
      .ctu_spc_const_maskid		(ctu_spc_const_maskid[7:0]),
      .ctu_spc_sscan_tid		(ctu_spc_sscan_tid[3:0]),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .dram_adbginit_l			(dram_adbginit_l),
      .dram_arst_l			(dram_arst_l),
      .dram_gclk_out			(dram_gclk),		 // Templated
      .dram_gdbginit_out_l		(dram_gdbginit_l),	 // Templated
      .dram_grst_out_l			(dram_grst_l),		 // Templated
      .global_scan_bypass_en		(global_scan_bypass_en),
      .jbus_adbginit_l			(jbus_adbginit_l),
      .jbus_arst_l			(jbus_arst_l),
      .jbus_gclk_dup_out		(jbus_gclk_dup_out),
      .jbus_gclk_out			(jbus_gclk),		 // Templated
      .jbus_gdbginit_out_l		(jbus_gdbginit_l),	 // Templated
      .jbus_grst_out_l			(jbus_grst_l),		 // Templated
      .pscan_select			(pscan_select),
      .tap_iob_data			(tap_iob_data[7:0]),
      .tap_iob_stall			(tap_iob_stall),
      .tap_iob_vld			(tap_iob_vld),
      // Inputs
      .afi_pll_trst_l			(afi_pll_trst_l),
      .afi_tsr_mode			(afi_tsr_mode),
      .io_j_clk				(J_CLK[1:0]),		 // Templated
      .afi_bist_mode			(afi_bist_mode),
      .afi_bypass_mode			(afi_bypass_mode),
      .afi_pll_char_mode		(afi_pll_char_mode),
      .afi_pll_clamp_fltr		(afi_pll_clamp_fltr),
      .afi_pll_div2			(afi_pll_div2[5:0]),
      .afi_rng_ctl			(afi_rng_ctl[2:0]),
      .afi_rt_addr_data			(afi_rt_addr_data),
      .afi_rt_data_in			(afi_rt_data_in[31:0]),
      .afi_rt_high_low			(afi_rt_high_low),
      .afi_rt_read_write		(afi_rt_read_write),
      .afi_rt_valid			(afi_rt_valid),
      .afi_tsr_div			(afi_tsr_div[9:1]),
      .afi_tsr_tsel			(afi_tsr_tsel[7:0]),
      .cmp_gclk				(cmp_gclk_c1_r[4]),	 // Templated
      .cmp_gclk_cts			(cmp_gclk_c1_r[4]),	 // Templated
      .ddr0_ctu_dll_lock		(ddr0_ctu_dll_lock),
      .ddr0_ctu_dll_overflow		(ddr0_ctu_dll_overflow),
      .ddr1_ctu_dll_lock		(ddr1_ctu_dll_lock),
      .ddr1_ctu_dll_overflow		(ddr1_ctu_dll_overflow),
      .ddr2_ctu_dll_lock		(ddr2_ctu_dll_lock),
      .ddr2_ctu_dll_overflow		(ddr2_ctu_dll_overflow),
      .ddr3_ctu_dll_lock		(ddr3_ctu_dll_lock),
      .ddr3_ctu_dll_overflow		(ddr3_ctu_dll_overflow),
      .dll0_ctu_ctrl			(ctu_dll0_ctu_ctrl[4:0]), // Templated
      .dll1_ctu_ctrl			(ctu_dll1_ctu_ctrl[4:0]), // Templated
      .dll2_ctu_ctrl			(ctu_dll2_ctu_ctrl[4:0]), // Templated
      .dll3_ctu_ctrl			(ctu_dll3_ctu_ctrl[4:0]), // Templated
      .dram02_ctu_tr			(dram02_ctu_tr),
      .dram13_ctu_tr			(dram13_ctu_tr),
      .dram_gclk_cts			(dram_gclk_c1_r[4]),	 // Templated
      .efc_ctu_data_out			(efc_ctu_data_out),
      .io_clk_stretch			(io_clk_stretch),
      .io_do_bist			(io_do_bist),
      .io_j_rst_l			(io_j_rst_l),
      .io_pll_char_in			(io_pll_char_in),
      .io_pwron_rst_l			(io_pwron_rst_l),
      .io_tck				(io_tck),
      .io_tck2				(io_tck2),
      .io_tdi				(io_tdi),
      .io_test_mode			(io_test_mode),
      .io_tms				(io_tms),
      .io_trst_l			(io_trst_l),
      .io_vdda_pll			(VDDA),			 // Templated
      .io_vdda_rng			(VDDA),			 // Templated
      .io_vdda_tsr			(VDDA),			 // Templated
      .io_vreg_selbg_l			(io_vreg_selbg_l),
      .iob_clsp_data			(iob_clsp_data[`IOB_CLK_WIDTH-1:0]),
      .iob_clsp_stall			(iob_clsp_stall),
      .iob_clsp_vld			(iob_clsp_vld),
      .iob_ctu_coreavail		(iob_ctu_coreavail[`IOB_CPU_WIDTH-1:0]),
      .iob_ctu_l2_tr			(iob_ctu_l2_tr),
      .iob_ctu_tr			(iob_ctu_tr),
      .iob_tap_data			(iob_tap_data[7:0]),
      .iob_tap_stall			(iob_tap_stall),
      .iob_tap_vld			(iob_tap_vld),
      .jbi_ctu_tr			(jbi_ctu_tr),
      .jbus_gclk			(jbus_gclk_c1_r[4]),	 // Templated
      .jbus_gclk_cts			(jbus_gclk_c1_r[4]),	 // Templated
      .jbus_gclk_dup			(jbus_gclk_dup),
      .jbus_grst_l			(jbus_grst_l),
      .pads_ctu_bsi			(ddr0_ctu_bso),		 // Templated
      .pads_ctu_si			(rbot2_ctu_so),		 // Templated
      .sctag0_ctu_mbistdone		(sctag0_ctu_mbistdone_buf2), // Templated
      .sctag0_ctu_mbisterr		(sctag0_ctu_mbisterr_buf2), // Templated
      .sctag0_ctu_tr			(sctag0_ctu_tr_buf2),	 // Templated
      .sctag1_ctu_mbistdone		(sctag1_ctu_mbistdone_buf2), // Templated
      .sctag1_ctu_mbisterr		(sctag1_ctu_mbisterr_buf2), // Templated
      .sctag1_ctu_tr			(sctag1_ctu_tr_buf2),	 // Templated
      .sctag2_ctu_mbistdone		(sctag2_ctu_mbistdone_buf2), // Templated
      .sctag2_ctu_mbisterr		(sctag2_ctu_mbisterr_buf2), // Templated
      .sctag2_ctu_serial_scan_in	(ser_scan_out[30]),	 // Templated
      .sctag2_ctu_tr			(sctag2_ctu_tr_buf2),	 // Templated
      .sctag3_ctu_mbistdone		(sctag3_ctu_mbistdone_buf2), // Templated
      .sctag3_ctu_mbisterr		(sctag3_ctu_mbisterr_buf2), // Templated
      .sctag3_ctu_tr			(sctag3_ctu_tr_buf2),	 // Templated
      .spc0_ctu_mbistdone		(spc0_ctu_mbistdone_buf2), // Templated
      .spc0_ctu_mbisterr		(spc0_ctu_mbisterr_buf2), // Templated
      .spc0_ctu_sscan_out		(spc0_ctu_sscan_out),
      .spc1_ctu_mbistdone		(spc1_ctu_mbistdone_buf2), // Templated
      .spc1_ctu_mbisterr		(spc1_ctu_mbisterr_buf2), // Templated
      .spc1_ctu_sscan_out		(spc1_ctu_sscan_out),
      .spc2_ctu_mbistdone		(spc2_ctu_mbistdone_buf2), // Templated
      .spc2_ctu_mbisterr		(spc2_ctu_mbisterr_buf2), // Templated
      .spc2_ctu_sscan_out		(spc2_ctu_sscan_out),
      .spc3_ctu_mbistdone		(spc3_ctu_mbistdone_buf2), // Templated
      .spc3_ctu_mbisterr		(spc3_ctu_mbisterr_buf2), // Templated
      .spc3_ctu_sscan_out		(spc3_ctu_sscan_out),
      .spc4_ctu_mbistdone		(spc4_ctu_mbistdone_buf2), // Templated
      .spc4_ctu_mbisterr		(spc4_ctu_mbisterr_buf2), // Templated
      .spc4_ctu_sscan_out		(spc4_ctu_sscan_out),
      .spc5_ctu_mbistdone		(spc5_ctu_mbistdone_buf2), // Templated
      .spc5_ctu_mbisterr		(spc5_ctu_mbisterr_buf2), // Templated
      .spc5_ctu_sscan_out		(spc5_ctu_sscan_out),
      .spc6_ctu_mbistdone		(spc6_ctu_mbistdone_buf2), // Templated
      .spc6_ctu_mbisterr		(spc6_ctu_mbisterr_buf2), // Templated
      .spc6_ctu_sscan_out		(spc6_ctu_sscan_out),
      .spc7_ctu_mbistdone		(spc7_ctu_mbistdone_buf2), // Templated
      .spc7_ctu_mbisterr		(spc7_ctu_mbisterr_buf2), // Templated
      .spc7_ctu_sscan_out		(spc7_ctu_sscan_out));
`endif
//


/* ctu_top_rptr AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rdram0_rtop_so),
    .so                                 (rtop_rdram2_so),
    .dbgbus_b0                          ({1'b0, 40'b0}),
    .dbgbus_b1                   	({1'b0, 20'b0, ctu_sctag0_mbisten_buf, ctu_sctag2_mbisten_buf, ctu_spc0_mbisten_buf, ctu_spc2_mbisten_buf, ctu_spc4_mbisten_buf, ctu_spc6_mbisten_buf, sctag0_ctu_mbistdone, sctag0_ctu_mbisterr, sctag2_ctu_mbistdone, sctag2_ctu_mbisterr, spc0_ctu_mbistdone, spc0_ctu_mbisterr, spc2_ctu_mbistdone, spc2_ctu_mbisterr, spc4_ctu_mbistdone, spc4_ctu_mbisterr, spc6_ctu_mbistdone, spc6_ctu_mbisterr, sctag0_ctu_tr, sctag2_ctu_tr}),
    .enable_01                          (),
    .l2_dbgbus_out                      ({ctu_top_rptr_unused[19:0], ctu_sctag0_mbisten_buf2, ctu_sctag2_mbisten_buf2, ctu_spc0_mbisten_buf2, ctu_spc2_mbisten_buf2, ctu_spc4_mbisten_buf2, ctu_spc6_mbisten_buf2, sctag0_ctu_mbistdone_buf, sctag0_ctu_mbisterr_buf, sctag2_ctu_mbistdone_buf, sctag2_ctu_mbisterr_buf, spc0_ctu_mbistdone_buf, spc0_ctu_mbisterr_buf, spc2_ctu_mbistdone_buf, spc2_ctu_mbisterr_buf, spc4_ctu_mbistdone_buf, spc4_ctu_mbisterr_buf, spc6_ctu_mbistdone_buf, spc6_ctu_mbisterr_buf, sctag0_ctu_tr_buf, sctag2_ctu_tr_buf}),
    ); */
//
   ctu_top_rptr ctu_top_rptr
     (/*AUTOINST*/
      // Outputs
      .l2_dbgbus_out			({ctu_top_rptr_unused[19:0], ctu_sctag0_mbisten_buf2, ctu_sctag2_mbisten_buf2, ctu_spc0_mbisten_buf2, ctu_spc2_mbisten_buf2, ctu_spc4_mbisten_buf2, ctu_spc6_mbisten_buf2, sctag0_ctu_mbistdone_buf, sctag0_ctu_mbisterr_buf, sctag2_ctu_mbistdone_buf, sctag2_ctu_mbisterr_buf, spc0_ctu_mbistdone_buf, spc0_ctu_mbisterr_buf, spc2_ctu_mbistdone_buf, spc2_ctu_mbisterr_buf, spc4_ctu_mbistdone_buf, spc4_ctu_mbisterr_buf, spc6_ctu_mbistdone_buf, spc6_ctu_mbisterr_buf, sctag0_ctu_tr_buf, sctag2_ctu_tr_buf}), // Templated
      .enable_01			(),			 // Templated
      .so				(rtop_rdram2_so),	 // Templated
      // Inputs
      .dbgbus_b0			({1'b0, 40'b0}),	 // Templated
      .dbgbus_b1			({1'b0, 20'b0, ctu_sctag0_mbisten_buf, ctu_sctag2_mbisten_buf, ctu_spc0_mbisten_buf, ctu_spc2_mbisten_buf, ctu_spc4_mbisten_buf, ctu_spc6_mbisten_buf, sctag0_ctu_mbistdone, sctag0_ctu_mbisterr, sctag2_ctu_mbistdone, sctag2_ctu_mbisterr, spc0_ctu_mbistdone, spc0_ctu_mbisterr, spc2_ctu_mbistdone, spc2_ctu_mbisterr, spc4_ctu_mbistdone, spc4_ctu_mbisterr, spc6_ctu_mbistdone, spc6_ctu_mbisterr, sctag0_ctu_tr, sctag2_ctu_tr}), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rdram0_rtop_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ctu_top_rptr2 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (ctu_rtop2_so),
    .so                                 (rtop2_rdram0_so),
    .dbgbus_b0                          ({1'b0, 40'b0}),
    .dbgbus_b1                   	({1'b0, 20'b0, ctu_sctag0_mbisten, ctu_sctag2_mbisten, ctu_spc0_mbisten, ctu_spc2_mbisten, ctu_spc4_mbisten, ctu_spc6_mbisten, sctag0_ctu_mbistdone_buf, sctag0_ctu_mbisterr_buf, sctag2_ctu_mbistdone_buf, sctag2_ctu_mbisterr_buf, spc0_ctu_mbistdone_buf, spc0_ctu_mbisterr_buf, spc2_ctu_mbistdone_buf, spc2_ctu_mbisterr_buf, spc4_ctu_mbistdone_buf, spc4_ctu_mbisterr_buf, spc6_ctu_mbistdone_buf, spc6_ctu_mbisterr_buf, sctag0_ctu_tr_buf, sctag2_ctu_tr_buf}),
    .enable_01                          (),
    .l2_dbgbus_out                      ({ctu_top_rptr2_unused[19:0], ctu_sctag0_mbisten_buf, ctu_sctag2_mbisten_buf, ctu_spc0_mbisten_buf, ctu_spc2_mbisten_buf, ctu_spc4_mbisten_buf, ctu_spc6_mbisten_buf, sctag0_ctu_mbistdone_buf2, sctag0_ctu_mbisterr_buf2, sctag2_ctu_mbistdone_buf2, sctag2_ctu_mbisterr_buf2, spc0_ctu_mbistdone_buf2, spc0_ctu_mbisterr_buf2, spc2_ctu_mbistdone_buf2, spc2_ctu_mbisterr_buf2, spc4_ctu_mbistdone_buf2, spc4_ctu_mbisterr_buf2, spc6_ctu_mbistdone_buf2, spc6_ctu_mbisterr_buf2, sctag0_ctu_tr_buf2, sctag2_ctu_tr_buf2}),
    ); */
//
   ctu_top_rptr2 ctu_top_rptr2
     (/*AUTOINST*/
      // Outputs
      .l2_dbgbus_out			({ctu_top_rptr2_unused[19:0], ctu_sctag0_mbisten_buf, ctu_sctag2_mbisten_buf, ctu_spc0_mbisten_buf, ctu_spc2_mbisten_buf, ctu_spc4_mbisten_buf, ctu_spc6_mbisten_buf, sctag0_ctu_mbistdone_buf2, sctag0_ctu_mbisterr_buf2, sctag2_ctu_mbistdone_buf2, sctag2_ctu_mbisterr_buf2, spc0_ctu_mbistdone_buf2, spc0_ctu_mbisterr_buf2, spc2_ctu_mbistdone_buf2, spc2_ctu_mbisterr_buf2, spc4_ctu_mbistdone_buf2, spc4_ctu_mbisterr_buf2, spc6_ctu_mbistdone_buf2, spc6_ctu_mbisterr_buf2, sctag0_ctu_tr_buf2, sctag2_ctu_tr_buf2}), // Templated
      .enable_01			(),			 // Templated
      .so				(rtop2_rdram0_so),	 // Templated
      // Inputs
      .dbgbus_b0			({1'b0, 40'b0}),	 // Templated
      .dbgbus_b1			({1'b0, 20'b0, ctu_sctag0_mbisten, ctu_sctag2_mbisten, ctu_spc0_mbisten, ctu_spc2_mbisten, ctu_spc4_mbisten, ctu_spc6_mbisten, sctag0_ctu_mbistdone_buf, sctag0_ctu_mbisterr_buf, sctag2_ctu_mbistdone_buf, sctag2_ctu_mbisterr_buf, spc0_ctu_mbistdone_buf, spc0_ctu_mbisterr_buf, spc2_ctu_mbistdone_buf, spc2_ctu_mbisterr_buf, spc4_ctu_mbistdone_buf, spc4_ctu_mbisterr_buf, spc6_ctu_mbistdone_buf, spc6_ctu_mbisterr_buf, sctag0_ctu_tr_buf, sctag2_ctu_tr_buf}), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(ctu_rtop2_so),		 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ctu_bottom_rptr AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rdram3_rbot_so),
    .so                                 (rbot_rdram1_so),
    .dbgbus_b0                          ({1'b0, 40'b0}),
    .dbgbus_b1                   	({1'b0, 20'b0, ctu_sctag1_mbisten_buf, ctu_sctag3_mbisten_buf, ctu_spc1_mbisten_buf, ctu_spc3_mbisten_buf, ctu_spc5_mbisten_buf, ctu_spc7_mbisten_buf, sctag1_ctu_mbistdone, sctag1_ctu_mbisterr, sctag3_ctu_mbistdone, sctag3_ctu_mbisterr, spc1_ctu_mbistdone, spc1_ctu_mbisterr, spc3_ctu_mbistdone, spc3_ctu_mbisterr, spc5_ctu_mbistdone, spc5_ctu_mbisterr, spc7_ctu_mbistdone, spc7_ctu_mbisterr, sctag1_ctu_tr, sctag3_ctu_tr}),
    .enable_01                          (),
    .l2_dbgbus_out                      ({ctu_bottom_rptr_unused[19:0], ctu_sctag1_mbisten_buf2, ctu_sctag3_mbisten_buf2, ctu_spc1_mbisten_buf2, ctu_spc3_mbisten_buf2, ctu_spc5_mbisten_buf2, ctu_spc7_mbisten_buf2, sctag1_ctu_mbistdone_buf, sctag1_ctu_mbisterr_buf, sctag3_ctu_mbistdone_buf, sctag3_ctu_mbisterr_buf, spc1_ctu_mbistdone_buf, spc1_ctu_mbisterr_buf, spc3_ctu_mbistdone_buf, spc3_ctu_mbisterr_buf, spc5_ctu_mbistdone_buf, spc5_ctu_mbisterr_buf, spc7_ctu_mbistdone_buf, spc7_ctu_mbisterr_buf, sctag1_ctu_tr_buf, sctag3_ctu_tr_buf}),
    ); */
//
   ctu_bottom_rptr ctu_bottom_rptr
     (/*AUTOINST*/
      // Outputs
      .l2_dbgbus_out			({ctu_bottom_rptr_unused[19:0], ctu_sctag1_mbisten_buf2, ctu_sctag3_mbisten_buf2, ctu_spc1_mbisten_buf2, ctu_spc3_mbisten_buf2, ctu_spc5_mbisten_buf2, ctu_spc7_mbisten_buf2, sctag1_ctu_mbistdone_buf, sctag1_ctu_mbisterr_buf, sctag3_ctu_mbistdone_buf, sctag3_ctu_mbisterr_buf, spc1_ctu_mbistdone_buf, spc1_ctu_mbisterr_buf, spc3_ctu_mbistdone_buf, spc3_ctu_mbisterr_buf, spc5_ctu_mbistdone_buf, spc5_ctu_mbisterr_buf, spc7_ctu_mbistdone_buf, spc7_ctu_mbisterr_buf, sctag1_ctu_tr_buf, sctag3_ctu_tr_buf}), // Templated
      .enable_01			(),			 // Templated
      .so				(rbot_rdram1_so),	 // Templated
      // Inputs
      .dbgbus_b0			({1'b0, 40'b0}),	 // Templated
      .dbgbus_b1			({1'b0, 20'b0, ctu_sctag1_mbisten_buf, ctu_sctag3_mbisten_buf, ctu_spc1_mbisten_buf, ctu_spc3_mbisten_buf, ctu_spc5_mbisten_buf, ctu_spc7_mbisten_buf, sctag1_ctu_mbistdone, sctag1_ctu_mbisterr, sctag3_ctu_mbistdone, sctag3_ctu_mbisterr, spc1_ctu_mbistdone, spc1_ctu_mbisterr, spc3_ctu_mbistdone, spc3_ctu_mbisterr, spc5_ctu_mbistdone, spc5_ctu_mbisterr, spc7_ctu_mbistdone, spc7_ctu_mbisterr, sctag1_ctu_tr, sctag3_ctu_tr}), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rdram3_rbot_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ctu_bottom_rptr2 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rdram1_rbot2_so),
    .so                                 (rbot2_ctu_so),
    .dbgbus_b0                          ({1'b0, 40'b0}),
    .dbgbus_b1                   	({1'b0, 20'b0, ctu_sctag1_mbisten, ctu_sctag3_mbisten, ctu_spc1_mbisten, ctu_spc3_mbisten, ctu_spc5_mbisten, ctu_spc7_mbisten, sctag1_ctu_mbistdone_buf, sctag1_ctu_mbisterr_buf, sctag3_ctu_mbistdone_buf, sctag3_ctu_mbisterr_buf, spc1_ctu_mbistdone_buf, spc1_ctu_mbisterr_buf, spc3_ctu_mbistdone_buf, spc3_ctu_mbisterr_buf, spc5_ctu_mbistdone_buf, spc5_ctu_mbisterr_buf, spc7_ctu_mbistdone_buf, spc7_ctu_mbisterr_buf, sctag1_ctu_tr_buf, sctag3_ctu_tr_buf}),
    .enable_01                          (),
    .l2_dbgbus_out                      ({ctu_bottom_rptr2_unused[19:0], ctu_sctag1_mbisten_buf, ctu_sctag3_mbisten_buf, ctu_spc1_mbisten_buf, ctu_spc3_mbisten_buf, ctu_spc5_mbisten_buf, ctu_spc7_mbisten_buf, sctag1_ctu_mbistdone_buf2, sctag1_ctu_mbisterr_buf2, sctag3_ctu_mbistdone_buf2, sctag3_ctu_mbisterr_buf2, spc1_ctu_mbistdone_buf2, spc1_ctu_mbisterr_buf2, spc3_ctu_mbistdone_buf2, spc3_ctu_mbisterr_buf2, spc5_ctu_mbistdone_buf2, spc5_ctu_mbisterr_buf2, spc7_ctu_mbistdone_buf2, spc7_ctu_mbisterr_buf2, sctag1_ctu_tr_buf2, sctag3_ctu_tr_buf2}),
    ); */
//
   ctu_bottom_rptr2 ctu_bottom_rptr2
     (/*AUTOINST*/
      // Outputs
      .l2_dbgbus_out			({ctu_bottom_rptr2_unused[19:0], ctu_sctag1_mbisten_buf, ctu_sctag3_mbisten_buf, ctu_spc1_mbisten_buf, ctu_spc3_mbisten_buf, ctu_spc5_mbisten_buf, ctu_spc7_mbisten_buf, sctag1_ctu_mbistdone_buf2, sctag1_ctu_mbisterr_buf2, sctag3_ctu_mbistdone_buf2, sctag3_ctu_mbisterr_buf2, spc1_ctu_mbistdone_buf2, spc1_ctu_mbisterr_buf2, spc3_ctu_mbistdone_buf2, spc3_ctu_mbisterr_buf2, spc5_ctu_mbistdone_buf2, spc5_ctu_mbisterr_buf2, spc7_ctu_mbistdone_buf2, spc7_ctu_mbisterr_buf2, sctag1_ctu_tr_buf2, sctag3_ctu_tr_buf2}), // Templated
      .enable_01			(),			 // Templated
      .so				(rbot2_ctu_so),		 // Templated
      // Inputs
      .dbgbus_b0			({1'b0, 40'b0}),	 // Templated
      .dbgbus_b1			({1'b0, 20'b0, ctu_sctag1_mbisten, ctu_sctag3_mbisten, ctu_spc1_mbisten, ctu_spc3_mbisten, ctu_spc5_mbisten, ctu_spc7_mbisten, sctag1_ctu_mbistdone_buf, sctag1_ctu_mbisterr_buf, sctag3_ctu_mbistdone_buf, sctag3_ctu_mbisterr_buf, spc1_ctu_mbistdone_buf, spc1_ctu_mbisterr_buf, spc3_ctu_mbistdone_buf, spc3_ctu_mbisterr_buf, spc5_ctu_mbistdone_buf, spc5_ctu_mbisterr_buf, spc7_ctu_mbistdone_buf, spc7_ctu_mbisterr_buf, sctag1_ctu_tr_buf, sctag3_ctu_tr_buf}), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rdram1_rbot2_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


`ifdef RTL_FLOP_RPTRS
/* bw_clk_gl AUTO_TEMPLATE (
    .gclk_cmp\(.*\)                     (cmp_gclk\1[]),
    .gclk_ddr\(.*\)                     (dram_gclk\1[]),
    .gclk_jbus\(.*\)                    (jbus_gclk\1[]),
    .clk_fdbk_in                        (jbus_gclk_dup_out),
    .clk_fdbk_out                       (jbus_gclk_dup),
    ); */
//
   bw_clk_gl bw_clk_gl
     (/*AUTOINST*/
      // Outputs
      .gclk_jbus_c0_r			(jbus_gclk_c0_r[7:0]),	 // Templated
      .gclk_cmp_c3_r			(cmp_gclk_c3_r[7:0]),	 // Templated
      .gclk_ddr_c3_r			(dram_gclk_c3_r[7:0]),	 // Templated
      .gclk_jbus_c2_r			(jbus_gclk_c2_r[7:0]),	 // Templated
      .gclk_cmp_c2_r			(cmp_gclk_c2_r[7:0]),	 // Templated
      .gclk_ddr_c2_r			(dram_gclk_c2_r[7:0]),	 // Templated
      .gclk_jbus_c1_r			(jbus_gclk_c1_r[7:0]),	 // Templated
      .gclk_cmp_c1_r			(cmp_gclk_c1_r[7:0]),	 // Templated
      .gclk_ddr_c1_r			(dram_gclk_c1_r[7:0]),	 // Templated
      .gclk_cmp_c0_r			(cmp_gclk_c0_r[7:0]),	 // Templated
      .gclk_jbus_c3_r			(jbus_gclk_c3_r[7:0]),	 // Templated
      .gclk_ddr_c0_r			(dram_gclk_c0_r[7:0]),	 // Templated
      .clk_fdbk_out			(jbus_gclk_dup),	 // Templated
      // Inputs
      .clk_fdbk_in			(jbus_gclk_dup_out),	 // Templated
      .gclk_jbus			(jbus_gclk),		 // Templated
      .gclk_ddr				(dram_gclk),		 // Templated
      .gclk_cmp				(cmp_gclk));		 // Templated
//


/* bw_clk_gl_rstce_rtl AUTO_TEMPLATE (
    .se                                 (global_shift_enable),
    .sd                                 ({rptrs_xc7_so, pjbusr_rptrs_so, pjbusl_rptrs_so, rptrs_xc4_so, rptrs_xa1_so, rptrs_xb1_so, rptrs_xa0_so, rptrs_xc1_so, rptrs_xc6_so, rptrs_xc5_so, rptrs_xb3_so, rptrs_xc0_so, rptrs_xb2_so, rsc02_rptrs_so}),
    .so                                 ({rptrs_xc6_so, rptrs_xc7_so, rptrs_xc4_so, rptrs_xc5_so, rptrs_rsc12_so, rptrs_pmisc_so, rptrs_xc1_so, rptrs_xc0_so, rptrs_xb3_so, rptrs_xb2_so, rptrs_xb1_so, rptrs_pdbg_so, rptrs_xa1_so, rptrs_xa0_so}),
    .gclk_a0                            (cmp_gclk_c1_r[3] ),
    .gclk_a1                            (cmp_gclk_c1_r[4] ),
    .gclk_b0                            (cmp_gclk_c1_r[2] ),
    .gclk_b1                            (cmp_gclk_c2_r[3] ),
    .gclk_b2                            (cmp_gclk_c1_r[5] ),
    .gclk_b3                            (cmp_gclk_c2_r[4] ),
    .gclk_c0                            (cmp_gclk_c1_r[1] ),
    .gclk_c1                            (cmp_gclk_c1_r[2] ),
    .gclk_c2                            (cmp_gclk_c2_r[2] ),
    .gclk_c3                            (cmp_gclk_c1_r[4] ),
    .gclk_c4                            (cmp_gclk_c1_r[5] ),
    .gclk_c5                            (cmp_gclk_c1_r[6] ),
    .gclk_c6                            (cmp_gclk_c2_r[4] ),
    .gclk_c7                            (cmp_gclk_c2_r[5] ),
    .cmp_ag\(.*\)                       (cmp_a\1),
    .cmp_grst_l                         (cmp_grst_out_l),
    .cmp_gdbginit_l                     (cmp_gdbginit_out_l),
    .ctu_scbuf\([0-3]\)_cken            (ctu_scdata\1_cmp_cken),
    .ctu_\(.*\)_cken                    (ctu_\1_cmp_cken),
    .gclk_\(.*\)_cken                   (rpt_\1_cmp_cken),
    .ctu_\(.*\)_sync                    (ctu_\1_sync_out),
    .grst_l_c\([0-7]\)                  (rpt_cmp_grst_l_c\1),
    .gdbginit_l_c\([0123457]\)          (rpt_cmp_gdbginit_l_c\1),
    .dram_rx_sync_c\([16]\)             (rpt_cmp_dram_rx_sync_c\1),
    .dram_tx_sync_c\([16]\)             (rpt_cmp_dram_tx_sync_c\1),
    .jbus_rx_sync_c\([146]\)            (rpt_cmp_jbus_rx_sync_c\1),
    .jbus_tx_sync_c\([146]\)            (rpt_cmp_jbus_tx_sync_c\1),
    .\(.*\)_c\([0-7]\)                  (),
    ); */
//
   bw_clk_gl_rstce_rtl flop_rptrs
     (/*AUTOINST*/
      // Outputs
      .so				({rptrs_xc6_so, rptrs_xc7_so, rptrs_xc4_so, rptrs_xc5_so, rptrs_rsc12_so, rptrs_pmisc_so, rptrs_xc1_so, rptrs_xc0_so, rptrs_xb3_so, rptrs_xb2_so, rptrs_xb1_so, rptrs_pdbg_so, rptrs_xa1_so, rptrs_xa0_so}), // Templated
      .grst_l_c0			(rpt_cmp_grst_l_c0),	 // Templated
      .grst_l_c1			(rpt_cmp_grst_l_c1),	 // Templated
      .grst_l_c2			(rpt_cmp_grst_l_c2),	 // Templated
      .grst_l_c3			(rpt_cmp_grst_l_c3),	 // Templated
      .grst_l_c4			(rpt_cmp_grst_l_c4),	 // Templated
      .grst_l_c5			(rpt_cmp_grst_l_c5),	 // Templated
      .grst_l_c6			(rpt_cmp_grst_l_c6),	 // Templated
      .grst_l_c7			(rpt_cmp_grst_l_c7),	 // Templated
      .gdbginit_l_c0			(rpt_cmp_gdbginit_l_c0), // Templated
      .gdbginit_l_c1			(rpt_cmp_gdbginit_l_c1), // Templated
      .gdbginit_l_c2			(rpt_cmp_gdbginit_l_c2), // Templated
      .gdbginit_l_c3			(rpt_cmp_gdbginit_l_c3), // Templated
      .gdbginit_l_c4			(rpt_cmp_gdbginit_l_c4), // Templated
      .gdbginit_l_c5			(rpt_cmp_gdbginit_l_c5), // Templated
      .gdbginit_l_c6			(),			 // Templated
      .gdbginit_l_c7			(rpt_cmp_gdbginit_l_c7), // Templated
      .dram_rx_sync_c0			(),			 // Templated
      .dram_rx_sync_c1			(rpt_cmp_dram_rx_sync_c1), // Templated
      .dram_rx_sync_c2			(),			 // Templated
      .dram_rx_sync_c3			(),			 // Templated
      .dram_rx_sync_c4			(),			 // Templated
      .dram_rx_sync_c5			(),			 // Templated
      .dram_rx_sync_c6			(rpt_cmp_dram_rx_sync_c6), // Templated
      .dram_rx_sync_c7			(),			 // Templated
      .dram_tx_sync_c0			(),			 // Templated
      .dram_tx_sync_c1			(rpt_cmp_dram_tx_sync_c1), // Templated
      .dram_tx_sync_c2			(),			 // Templated
      .dram_tx_sync_c3			(),			 // Templated
      .dram_tx_sync_c4			(),			 // Templated
      .dram_tx_sync_c5			(),			 // Templated
      .dram_tx_sync_c6			(rpt_cmp_dram_tx_sync_c6), // Templated
      .dram_tx_sync_c7			(),			 // Templated
      .jbus_rx_sync_c0			(),			 // Templated
      .jbus_rx_sync_c1			(rpt_cmp_jbus_rx_sync_c1), // Templated
      .jbus_rx_sync_c2			(),			 // Templated
      .jbus_rx_sync_c3			(),			 // Templated
      .jbus_rx_sync_c4			(rpt_cmp_jbus_rx_sync_c4), // Templated
      .jbus_rx_sync_c5			(),			 // Templated
      .jbus_rx_sync_c6			(rpt_cmp_jbus_rx_sync_c6), // Templated
      .jbus_rx_sync_c7			(),			 // Templated
      .jbus_tx_sync_c0			(),			 // Templated
      .jbus_tx_sync_c1			(rpt_cmp_jbus_tx_sync_c1), // Templated
      .jbus_tx_sync_c2			(),			 // Templated
      .jbus_tx_sync_c3			(),			 // Templated
      .jbus_tx_sync_c4			(rpt_cmp_jbus_tx_sync_c4), // Templated
      .jbus_tx_sync_c5			(),			 // Templated
      .jbus_tx_sync_c6			(rpt_cmp_jbus_tx_sync_c6), // Templated
      .jbus_tx_sync_c7			(),			 // Templated
      .gclk_spc0_cken			(rpt_spc0_cmp_cken),	 // Templated
      .gclk_spc1_cken			(rpt_spc1_cmp_cken),	 // Templated
      .gclk_spc2_cken			(rpt_spc2_cmp_cken),	 // Templated
      .gclk_spc3_cken			(rpt_spc3_cmp_cken),	 // Templated
      .gclk_spc4_cken			(rpt_spc4_cmp_cken),	 // Templated
      .gclk_spc5_cken			(rpt_spc5_cmp_cken),	 // Templated
      .gclk_spc6_cken			(rpt_spc6_cmp_cken),	 // Templated
      .gclk_spc7_cken			(rpt_spc7_cmp_cken),	 // Templated
      .gclk_scbuf0_cken			(rpt_scbuf0_cmp_cken),	 // Templated
      .gclk_scbuf1_cken			(rpt_scbuf1_cmp_cken),	 // Templated
      .gclk_scbuf2_cken			(rpt_scbuf2_cmp_cken),	 // Templated
      .gclk_scbuf3_cken			(rpt_scbuf3_cmp_cken),	 // Templated
      .gclk_scdata0_cken		(rpt_scdata0_cmp_cken),	 // Templated
      .gclk_scdata1_cken		(rpt_scdata1_cmp_cken),	 // Templated
      .gclk_scdata2_cken		(rpt_scdata2_cmp_cken),	 // Templated
      .gclk_scdata3_cken		(rpt_scdata3_cmp_cken),	 // Templated
      .gclk_sctag0_cken			(rpt_sctag0_cmp_cken),	 // Templated
      .gclk_sctag1_cken			(rpt_sctag1_cmp_cken),	 // Templated
      .gclk_sctag2_cken			(rpt_sctag2_cmp_cken),	 // Templated
      .gclk_sctag3_cken			(rpt_sctag3_cmp_cken),	 // Templated
      .gclk_dram02_cken			(rpt_dram02_cmp_cken),	 // Templated
      .gclk_dram13_cken			(rpt_dram13_cmp_cken),	 // Templated
      .gclk_ccx_cken			(rpt_ccx_cmp_cken),	 // Templated
      .gclk_fpu_cken			(rpt_fpu_cmp_cken),	 // Templated
      .gclk_iob_cken			(rpt_iob_cmp_cken),	 // Templated
      .gclk_jbi_cken			(rpt_jbi_cmp_cken),	 // Templated
      // Inputs
      .se				(global_shift_enable),	 // Templated
      .sd				({rptrs_xc7_so, pjbusr_rptrs_so, pjbusl_rptrs_so, rptrs_xc4_so, rptrs_xa1_so, rptrs_xb1_so, rptrs_xa0_so, rptrs_xc1_so, rptrs_xc6_so, rptrs_xc5_so, rptrs_xb3_so, rptrs_xc0_so, rptrs_xb2_so, rsc02_rptrs_so}), // Templated
      .gclk_a0				(cmp_gclk_c1_r[3] ),	 // Templated
      .gclk_a1				(cmp_gclk_c1_r[4] ),	 // Templated
      .gclk_b0				(cmp_gclk_c1_r[2] ),	 // Templated
      .gclk_b1				(cmp_gclk_c2_r[3] ),	 // Templated
      .gclk_b2				(cmp_gclk_c1_r[5] ),	 // Templated
      .gclk_b3				(cmp_gclk_c2_r[4] ),	 // Templated
      .gclk_c0				(cmp_gclk_c1_r[1] ),	 // Templated
      .gclk_c1				(cmp_gclk_c1_r[2] ),	 // Templated
      .gclk_c2				(cmp_gclk_c2_r[2] ),	 // Templated
      .gclk_c3				(cmp_gclk_c1_r[4] ),	 // Templated
      .gclk_c4				(cmp_gclk_c1_r[5] ),	 // Templated
      .gclk_c5				(cmp_gclk_c1_r[6] ),	 // Templated
      .gclk_c6				(cmp_gclk_c2_r[4] ),	 // Templated
      .gclk_c7				(cmp_gclk_c2_r[5] ),	 // Templated
      .cmp_agrst_l			(cmp_arst_l),		 // Templated
      .cmp_agdbginit_l			(cmp_adbginit_l),	 // Templated
      .cmp_grst_l			(cmp_grst_out_l),	 // Templated
      .cmp_gdbginit_l			(cmp_gdbginit_out_l),	 // Templated
      .ctu_dram_rx_sync			(ctu_dram_rx_sync_out),	 // Templated
      .ctu_dram_tx_sync			(ctu_dram_tx_sync_out),	 // Templated
      .ctu_jbus_rx_sync			(ctu_jbus_rx_sync_out),	 // Templated
      .ctu_jbus_tx_sync			(ctu_jbus_tx_sync_out),	 // Templated
      .ctu_spc0_cken			(ctu_spc0_cmp_cken),	 // Templated
      .ctu_spc1_cken			(ctu_spc1_cmp_cken),	 // Templated
      .ctu_spc2_cken			(ctu_spc2_cmp_cken),	 // Templated
      .ctu_spc3_cken			(ctu_spc3_cmp_cken),	 // Templated
      .ctu_spc4_cken			(ctu_spc4_cmp_cken),	 // Templated
      .ctu_spc5_cken			(ctu_spc5_cmp_cken),	 // Templated
      .ctu_spc6_cken			(ctu_spc6_cmp_cken),	 // Templated
      .ctu_spc7_cken			(ctu_spc7_cmp_cken),	 // Templated
      .ctu_scbuf0_cken			(ctu_scdata0_cmp_cken),	 // Templated
      .ctu_scbuf1_cken			(ctu_scdata1_cmp_cken),	 // Templated
      .ctu_scbuf2_cken			(ctu_scdata2_cmp_cken),	 // Templated
      .ctu_scbuf3_cken			(ctu_scdata3_cmp_cken),	 // Templated
      .ctu_scdata0_cken			(ctu_scdata0_cmp_cken),	 // Templated
      .ctu_scdata1_cken			(ctu_scdata1_cmp_cken),	 // Templated
      .ctu_scdata2_cken			(ctu_scdata2_cmp_cken),	 // Templated
      .ctu_scdata3_cken			(ctu_scdata3_cmp_cken),	 // Templated
      .ctu_sctag0_cken			(ctu_sctag0_cmp_cken),	 // Templated
      .ctu_sctag3_cken			(ctu_sctag3_cmp_cken),	 // Templated
      .ctu_sctag2_cken			(ctu_sctag2_cmp_cken),	 // Templated
      .ctu_sctag1_cken			(ctu_sctag1_cmp_cken),	 // Templated
      .ctu_dram02_cken			(ctu_dram02_cmp_cken),	 // Templated
      .ctu_dram13_cken			(ctu_dram13_cmp_cken),	 // Templated
      .ctu_ccx_cken			(ctu_ccx_cmp_cken),	 // Templated
      .ctu_fpu_cken			(ctu_fpu_cmp_cken),	 // Templated
      .ctu_iob_cken			(ctu_iob_cmp_cken),	 // Templated
      .ctu_jbi_cken			(ctu_jbi_cmp_cken));	 // Templated
`endif
//


/* efc AUTO_TEMPLATE (
    .jbus_gclk                          (jbus_gclk_c3_r[3]),
    .tck                                (ctu_efc_tck),
    .clk_efc_cken                       (ctu_efc_jbus_cken),
    .efc_ctu_scanout                    (par_scan_tail[21]),
    .ctu_efc_scanin                     (rsc32_efc_so),
    .vddo				(VDDCO),
    .io_vpp				(VPP),
    ); */
//
`ifdef RTL_EFC
   efc efc
     (/*AUTOINST*/
      // Outputs
      .efc_ctu_scanout			(par_scan_tail[21]),	 // Templated
      .efc_ctu_data_out			(efc_ctu_data_out),
      .efc_spc1357_fuse_clk1		(efc_spc1357_fuse_clk1),
      .efc_spc1357_fuse_clk2		(efc_spc1357_fuse_clk2),
      .efc_spc0246_fuse_clk1		(efc_spc0246_fuse_clk1),
      .efc_spc0246_fuse_clk2		(efc_spc0246_fuse_clk2),
      .efc_spc1357_fuse_data		(efc_spc1357_fuse_data),
      .efc_spc0246_fuse_data		(efc_spc0246_fuse_data),
      .efc_spc7_ifuse_ashift		(efc_spc7_ifuse_ashift),
      .efc_spc7_ifuse_dshift		(efc_spc7_ifuse_dshift),
      .efc_spc7_dfuse_ashift		(efc_spc7_dfuse_ashift),
      .efc_spc7_dfuse_dshift		(efc_spc7_dfuse_dshift),
      .efc_spc6_ifuse_ashift		(efc_spc6_ifuse_ashift),
      .efc_spc6_ifuse_dshift		(efc_spc6_ifuse_dshift),
      .efc_spc6_dfuse_ashift		(efc_spc6_dfuse_ashift),
      .efc_spc6_dfuse_dshift		(efc_spc6_dfuse_dshift),
      .efc_spc5_ifuse_ashift		(efc_spc5_ifuse_ashift),
      .efc_spc5_ifuse_dshift		(efc_spc5_ifuse_dshift),
      .efc_spc5_dfuse_ashift		(efc_spc5_dfuse_ashift),
      .efc_spc5_dfuse_dshift		(efc_spc5_dfuse_dshift),
      .efc_spc4_ifuse_ashift		(efc_spc4_ifuse_ashift),
      .efc_spc4_ifuse_dshift		(efc_spc4_ifuse_dshift),
      .efc_spc4_dfuse_ashift		(efc_spc4_dfuse_ashift),
      .efc_spc4_dfuse_dshift		(efc_spc4_dfuse_dshift),
      .efc_spc3_ifuse_ashift		(efc_spc3_ifuse_ashift),
      .efc_spc3_ifuse_dshift		(efc_spc3_ifuse_dshift),
      .efc_spc3_dfuse_ashift		(efc_spc3_dfuse_ashift),
      .efc_spc3_dfuse_dshift		(efc_spc3_dfuse_dshift),
      .efc_spc2_ifuse_ashift		(efc_spc2_ifuse_ashift),
      .efc_spc2_ifuse_dshift		(efc_spc2_ifuse_dshift),
      .efc_spc2_dfuse_ashift		(efc_spc2_dfuse_ashift),
      .efc_spc2_dfuse_dshift		(efc_spc2_dfuse_dshift),
      .efc_spc1_ifuse_ashift		(efc_spc1_ifuse_ashift),
      .efc_spc1_ifuse_dshift		(efc_spc1_ifuse_dshift),
      .efc_spc1_dfuse_ashift		(efc_spc1_dfuse_ashift),
      .efc_spc1_dfuse_dshift		(efc_spc1_dfuse_dshift),
      .efc_spc0_ifuse_ashift		(efc_spc0_ifuse_ashift),
      .efc_spc0_ifuse_dshift		(efc_spc0_ifuse_dshift),
      .efc_spc0_dfuse_ashift		(efc_spc0_dfuse_ashift),
      .efc_spc0_dfuse_dshift		(efc_spc0_dfuse_dshift),
      .efc_sctag02_fuse_clk1		(efc_sctag02_fuse_clk1),
      .efc_sctag02_fuse_clk2		(efc_sctag02_fuse_clk2),
      .efc_sctag02_fuse_data		(efc_sctag02_fuse_data),
      .efc_sctag13_fuse_clk1		(efc_sctag13_fuse_clk1),
      .efc_sctag13_fuse_clk2		(efc_sctag13_fuse_clk2),
      .efc_sctag13_fuse_data		(efc_sctag13_fuse_data),
      .efc_sctag3_fuse_ashift		(efc_sctag3_fuse_ashift),
      .efc_sctag3_fuse_dshift		(efc_sctag3_fuse_dshift),
      .efc_sctag2_fuse_ashift		(efc_sctag2_fuse_ashift),
      .efc_sctag2_fuse_dshift		(efc_sctag2_fuse_dshift),
      .efc_sctag1_fuse_ashift		(efc_sctag1_fuse_ashift),
      .efc_sctag1_fuse_dshift		(efc_sctag1_fuse_dshift),
      .efc_sctag0_fuse_ashift		(efc_sctag0_fuse_ashift),
      .efc_sctag0_fuse_dshift		(efc_sctag0_fuse_dshift),
      .efc_scdata02_fuse_clk1		(efc_scdata02_fuse_clk1),
      .efc_scdata02_fuse_clk2		(efc_scdata02_fuse_clk2),
      .efc_scdata02_fuse_data		(efc_scdata02_fuse_data),
      .efc_scdata13_fuse_clk1		(efc_scdata13_fuse_clk1),
      .efc_scdata13_fuse_clk2		(efc_scdata13_fuse_clk2),
      .efc_scdata13_fuse_data		(efc_scdata13_fuse_data),
      .efc_scdata3_fuse_ashift		(efc_scdata3_fuse_ashift),
      .efc_scdata3_fuse_dshift		(efc_scdata3_fuse_dshift),
      .efc_scdata2_fuse_ashift		(efc_scdata2_fuse_ashift),
      .efc_scdata2_fuse_dshift		(efc_scdata2_fuse_dshift),
      .efc_scdata1_fuse_ashift		(efc_scdata1_fuse_ashift),
      .efc_scdata1_fuse_dshift		(efc_scdata1_fuse_dshift),
      .efc_scdata0_fuse_ashift		(efc_scdata0_fuse_ashift),
      .efc_scdata0_fuse_dshift		(efc_scdata0_fuse_dshift),
      .efc_iob_fuse_clk1		(efc_iob_fuse_clk1),
      .efc_iob_fuse_data		(efc_iob_fuse_data),
      .efc_iob_sernum0_dshift		(efc_iob_sernum0_dshift),
      .efc_iob_sernum1_dshift		(efc_iob_sernum1_dshift),
      .efc_iob_sernum2_dshift		(efc_iob_sernum2_dshift),
      .efc_iob_fusestat_dshift		(efc_iob_fusestat_dshift),
      .efc_iob_coreavail_dshift		(efc_iob_coreavail_dshift),
      // Inputs
      .io_vpp				(VPP),			 // Templated
      .vddo				(VDDCO),		 // Templated
      .jbus_gclk			(jbus_gclk_c3_r[3]),	 // Templated
      .jbus_arst_l			(jbus_arst_l),
      .jbus_grst_l			(jbus_grst_l),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .clk_efc_cken			(ctu_efc_jbus_cken),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .ctu_efc_scanin			(rsc32_efc_so),		 // Templated
      .jbus_adbginit_l			(jbus_adbginit_l),
      .jbus_gdbginit_l			(jbus_gdbginit_l),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .ctu_efc_rowaddr			(ctu_efc_rowaddr[6:0]),
      .ctu_efc_coladdr			(ctu_efc_coladdr[4:0]),
      .io_pgrm_en			(io_pgrm_en),
      .ctu_efc_read_en			(ctu_efc_read_en),
      .ctu_efc_read_mode		(ctu_efc_read_mode[2:0]),
      .ctu_efc_read_start		(ctu_efc_read_start),
      .ctu_efc_fuse_bypass		(ctu_efc_fuse_bypass),
      .ctu_efc_dest_sample		(ctu_efc_dest_sample),
      .ctu_efc_data_in			(ctu_efc_data_in),
      .ctu_efc_updatedr			(ctu_efc_updatedr),
      .ctu_efc_shiftdr			(ctu_efc_shiftdr),
      .ctu_efc_capturedr		(ctu_efc_capturedr),
      .tck				(ctu_efc_tck),		 // Templated
      .spc7_efc_ifuse_data		(spc7_efc_ifuse_data),
      .spc7_efc_dfuse_data		(spc7_efc_dfuse_data),
      .spc6_efc_ifuse_data		(spc6_efc_ifuse_data),
      .spc6_efc_dfuse_data		(spc6_efc_dfuse_data),
      .spc5_efc_ifuse_data		(spc5_efc_ifuse_data),
      .spc5_efc_dfuse_data		(spc5_efc_dfuse_data),
      .spc4_efc_ifuse_data		(spc4_efc_ifuse_data),
      .spc4_efc_dfuse_data		(spc4_efc_dfuse_data),
      .spc3_efc_ifuse_data		(spc3_efc_ifuse_data),
      .spc3_efc_dfuse_data		(spc3_efc_dfuse_data),
      .spc2_efc_ifuse_data		(spc2_efc_ifuse_data),
      .spc2_efc_dfuse_data		(spc2_efc_dfuse_data),
      .spc1_efc_ifuse_data		(spc1_efc_ifuse_data),
      .spc1_efc_dfuse_data		(spc1_efc_dfuse_data),
      .spc0_efc_ifuse_data		(spc0_efc_ifuse_data),
      .spc0_efc_dfuse_data		(spc0_efc_dfuse_data),
      .sctag3_efc_fuse_data		(sctag3_efc_fuse_data),
      .sctag2_efc_fuse_data		(sctag2_efc_fuse_data),
      .sctag1_efc_fuse_data		(sctag1_efc_fuse_data),
      .sctag0_efc_fuse_data		(sctag0_efc_fuse_data),
      .scdata3_efc_fuse_data		(scdata3_efc_fuse_data),
      .scdata2_efc_fuse_data		(scdata2_efc_fuse_data),
      .scdata1_efc_fuse_data		(scdata1_efc_fuse_data),
      .scdata0_efc_fuse_data		(scdata0_efc_fuse_data));
`endif
//


/* iobdg AUTO_TEMPLATE (
    .iob_scanin                         (par_scan_head[10]),
    .iob_scanout                        (par_scan_tail[10]),
    .jbus_gclk                          (jbus_gclk_c1_r[3]),
    .cmp_gclk                           (cmp_gclk_c1_r[3]),
    .cmp_grst_l				(rpt_cmp_grst_l_c1),
    .cmp_gdbginit_l			(rpt_cmp_gdbginit_l_c2),
    .clspine_jbus_rx_sync               (rpt_cmp_jbus_rx_sync_c1),
    .clspine_jbus_tx_sync               (rpt_cmp_jbus_tx_sync_c1),
    .clk_iob_cmp_cken                   (rpt_iob_cmp_cken),
    .clk_iob_jbus_cken                  (ctu_iob_jbus_cken),
    .clspine_iob_resetstat_wr           (ctu_iob_resetstat_wr),
    .clspine_iob_resetstat              (ctu_iob_resetstat[]),
    .iob_clk_l2_tr                      (iob_ctu_l2_tr),
    .iob_clk_tr                         (iob_ctu_tr),
    .clk_iob_stall                      (clsp_iob_stall),
    .clk_iob_vld                        (clsp_iob_vld),
    .clk_iob_data                       (clsp_iob_data[]),
    .iob_clk_stall                      (iob_clsp_stall),
    .iob_clk_vld                        (iob_clsp_vld),
    .iob_clk_data                       (iob_clsp_data[]),
    .cpx_iob_\(.*\)			(cpx_iob_\1_buf[]),
    .jbi_iob_\(.*\)			(jbi_iob_\1_buf[]),
    .pcx_iob_\(.*\)			(pcx_iob_\1_buf[]),
    ); */
//
`ifdef RTL_IOBDG
   iobdg iobdg
     (/*AUTOINST*/
      // Outputs
      .iob_clk_l2_tr			(iob_ctu_l2_tr),	 // Templated
      .iob_clk_tr			(iob_ctu_tr),		 // Templated
      .iob_cpx_data_ca			(iob_cpx_data_ca[`CPX_WIDTH-1:0]),
      .iob_cpx_req_cq			(iob_cpx_req_cq[`IOB_CPU_WIDTH-1:0]),
      .iob_ctu_coreavail		(iob_ctu_coreavail[`IOB_CPU_WIDTH-1:0]),
      .iob_io_dbg_ck_n			(iob_io_dbg_ck_n[2:0]),
      .iob_io_dbg_ck_p			(iob_io_dbg_ck_p[2:0]),
      .iob_io_dbg_data			(iob_io_dbg_data[39:0]),
      .iob_io_dbg_en			(iob_io_dbg_en),
      .iob_jbi_dbg_hi_data		(iob_jbi_dbg_hi_data[47:0]),
      .iob_jbi_dbg_hi_vld		(iob_jbi_dbg_hi_vld),
      .iob_jbi_dbg_lo_data		(iob_jbi_dbg_lo_data[47:0]),
      .iob_jbi_dbg_lo_vld		(iob_jbi_dbg_lo_vld),
      .iob_jbi_mondo_ack		(iob_jbi_mondo_ack),
      .iob_jbi_mondo_nack		(iob_jbi_mondo_nack),
      .iob_pcx_stall_pq			(iob_pcx_stall_pq),
      .iob_clk_data			(iob_clsp_data[`IOB_CLK_WIDTH-1:0]), // Templated
      .iob_clk_stall			(iob_clsp_stall),	 // Templated
      .iob_clk_vld			(iob_clsp_vld),		 // Templated
      .iob_dram02_data			(iob_dram02_data[`IOB_DRAM_WIDTH-1:0]),
      .iob_dram02_stall			(iob_dram02_stall),
      .iob_dram02_vld			(iob_dram02_vld),
      .iob_dram13_data			(iob_dram13_data[`IOB_DRAM_WIDTH-1:0]),
      .iob_dram13_stall			(iob_dram13_stall),
      .iob_dram13_vld			(iob_dram13_vld),
      .iob_jbi_pio_data			(iob_jbi_pio_data[`IOB_JBI_WIDTH-1:0]),
      .iob_jbi_pio_stall		(iob_jbi_pio_stall),
      .iob_jbi_pio_vld			(iob_jbi_pio_vld),
      .iob_jbi_spi_data			(iob_jbi_spi_data[`IOB_SPI_WIDTH-1:0]),
      .iob_jbi_spi_stall		(iob_jbi_spi_stall),
      .iob_jbi_spi_vld			(iob_jbi_spi_vld),
      .iob_tap_data			(iob_tap_data[`IOB_TAP_WIDTH-1:0]),
      .iob_tap_stall			(iob_tap_stall),
      .iob_tap_vld			(iob_tap_vld),
      .iob_scanout			(par_scan_tail[10]),	 // Templated
      // Inputs
      .clk_iob_cmp_cken			(rpt_iob_cmp_cken),	 // Templated
      .clk_iob_data			(clsp_iob_data[`CLK_IOB_WIDTH-1:0]), // Templated
      .clk_iob_jbus_cken		(ctu_iob_jbus_cken),	 // Templated
      .clk_iob_stall			(clsp_iob_stall),	 // Templated
      .clk_iob_vld			(clsp_iob_vld),		 // Templated
      .clspine_iob_resetstat		(ctu_iob_resetstat[`IOB_RESET_STAT_WIDTH-1:0]), // Templated
      .clspine_iob_resetstat_wr		(ctu_iob_resetstat_wr),	 // Templated
      .clspine_jbus_rx_sync		(rpt_cmp_jbus_rx_sync_c1), // Templated
      .clspine_jbus_tx_sync		(rpt_cmp_jbus_tx_sync_c1), // Templated
      .cmp_adbginit_l			(cmp_adbginit_l),
      .cmp_arst_l			(cmp_arst_l),
      .cmp_gclk				(cmp_gclk_c1_r[3]),	 // Templated
      .cmp_gdbginit_l			(rpt_cmp_gdbginit_l_c2), // Templated
      .cmp_grst_l			(rpt_cmp_grst_l_c1),	 // Templated
      .cpx_iob_grant_cx2		(cpx_iob_grant_cx2_buf[`IOB_CPU_WIDTH-1:0]), // Templated
      .ctu_iob_wake_thr			(ctu_iob_wake_thr),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .dbg_en_01			(dbg_en_01),
      .dbg_en_23			(dbg_en_23),
      .dram02_iob_data			(dram02_iob_data[`DRAM_IOB_WIDTH-1:0]),
      .dram02_iob_stall			(dram02_iob_stall),
      .dram02_iob_vld			(dram02_iob_vld),
      .dram13_iob_data			(dram13_iob_data[`DRAM_IOB_WIDTH-1:0]),
      .dram13_iob_stall			(dram13_iob_stall),
      .dram13_iob_vld			(dram13_iob_vld),
      .efc_iob_coreavail_dshift		(efc_iob_coreavail_dshift),
      .efc_iob_fuse_data		(efc_iob_fuse_data),
      .efc_iob_fusestat_dshift		(efc_iob_fusestat_dshift),
      .efc_iob_sernum0_dshift		(efc_iob_sernum0_dshift),
      .efc_iob_sernum1_dshift		(efc_iob_sernum1_dshift),
      .efc_iob_sernum2_dshift		(efc_iob_sernum2_dshift),
      .global_shift_enable		(global_shift_enable),
      .io_temp_trig			(io_temp_trig),
      .io_trigin			(io_trigin),
      .jbi_iob_mondo_data		(jbi_iob_mondo_data_buf[`JBI_IOB_MONDO_BUS_WIDTH-1:0]), // Templated
      .jbi_iob_mondo_vld		(jbi_iob_mondo_vld_buf), // Templated
      .jbi_iob_pio_data			(jbi_iob_pio_data_buf[`JBI_IOB_WIDTH-1:0]), // Templated
      .jbi_iob_pio_stall		(jbi_iob_pio_stall_buf), // Templated
      .jbi_iob_pio_vld			(jbi_iob_pio_vld_buf),	 // Templated
      .jbi_iob_spi_data			(jbi_iob_spi_data_buf[`SPI_IOB_WIDTH-1:0]), // Templated
      .jbi_iob_spi_stall		(jbi_iob_spi_stall_buf), // Templated
      .jbi_iob_spi_vld			(jbi_iob_spi_vld_buf),	 // Templated
      .jbus_adbginit_l			(jbus_adbginit_l),
      .jbus_arst_l			(jbus_arst_l),
      .jbus_gclk			(jbus_gclk_c1_r[3]),	 // Templated
      .jbus_gdbginit_l			(jbus_gdbginit_l),
      .jbus_grst_l			(jbus_grst_l),
      .l2_dbgbus_01			(l2_dbgbus_01[39:0]),
      .l2_dbgbus_23			(l2_dbgbus_23[39:0]),
      .pcx_iob_data_px2			(pcx_iob_data_px2_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_iob_data_rdy_px2		(pcx_iob_data_rdy_px2_buf), // Templated
      .tap_iob_data			(tap_iob_data[`TAP_IOB_WIDTH-1:0]),
      .tap_iob_stall			(tap_iob_stall),
      .tap_iob_vld			(tap_iob_vld),
      .efc_iob_fuse_clk1		(efc_iob_fuse_clk1),
      .iob_scanin			(par_scan_head[10]));	 // Templated
`endif
//


/* jbi AUTO_TEMPLATE (
    .ddr3_jbi_scanin18                  (pddr0_jbi_so),
    .jbi_ddr3_scanout18                 (par_scan_tail[6]),
    .jbusr_jbi_si                       (),
    .jbi_jbusr_se                       (),
    .jbi_jbusr_so                       (),
    .jbus_gclk                          (jbus_gclk_c2_r[5]),
    .cmp_gclk                           (cmp_gclk_c2_r[5]),
    .cmp_grst_l                         (rpt_cmp_grst_l_c4),
    .ctu_jbi_rx_en                      (rpt_cmp_jbus_rx_sync_c4),
    .ctu_jbi_tx_en                      (rpt_cmp_jbus_tx_sync_c4),
    .clk_jbi_cmp_cken                   (rpt_jbi_cmp_cken),
    .clk_jbi_jbus_cken                  (ctu_jbi_jbus_cken),
    .jbi_clk_tr                         (jbi_ctu_tr),
    .io_jbi_ext_int_l                   (io_ext_int_l),
    .ctu_jbi_fst_rst_l                  (io_j_rst_l),
    .scbuf\([0-3]\)_jbi_\(.*\)_buf      (scbuf\1_jbi_\2_d2),
    .scbuf\([0-3]\)_jbi_\(.*\)          (scbuf\1_jbi_\2_d2),
    .sctag\([0-3]\)_jbi_\(.*\)_buf      (sctag\1_jbi_\2_d2),
    .sctag\([0-3]\)_jbi_\(.*\)          (sctag\1_jbi_\2_d2),
    .iob_jbi_\(.*\)			(iob_jbi_\1_buf[]),
    ); */
//
`ifdef RTL_JBI
   jbi jbi
     (/*AUTOINST*/
      // Outputs
      .jbi_ddr3_scanout18		(par_scan_tail[6]),	 // Templated
      .jbi_clk_tr			(jbi_ctu_tr),		 // Templated
      .jbi_jbusr_so			(),			 // Templated
      .jbi_jbusr_se			(),			 // Templated
      .jbi_sctag0_req			(jbi_sctag0_req[31:0]),
      .jbi_scbuf0_ecc			(jbi_scbuf0_ecc[6:0]),
      .jbi_sctag0_req_vld		(jbi_sctag0_req_vld),
      .jbi_sctag1_req			(jbi_sctag1_req[31:0]),
      .jbi_scbuf1_ecc			(jbi_scbuf1_ecc[6:0]),
      .jbi_sctag1_req_vld		(jbi_sctag1_req_vld),
      .jbi_sctag2_req			(jbi_sctag2_req[31:0]),
      .jbi_scbuf2_ecc			(jbi_scbuf2_ecc[6:0]),
      .jbi_sctag2_req_vld		(jbi_sctag2_req_vld),
      .jbi_sctag3_req			(jbi_sctag3_req[31:0]),
      .jbi_scbuf3_ecc			(jbi_scbuf3_ecc[6:0]),
      .jbi_sctag3_req_vld		(jbi_sctag3_req_vld),
      .jbi_iob_pio_vld			(jbi_iob_pio_vld),
      .jbi_iob_pio_data			(jbi_iob_pio_data[`JBI_IOB_WIDTH-1:0]),
      .jbi_iob_pio_stall		(jbi_iob_pio_stall),
      .jbi_iob_mondo_vld		(jbi_iob_mondo_vld),
      .jbi_iob_mondo_data		(jbi_iob_mondo_data[`JBI_IOB_MONDO_BUS_WIDTH-1:0]),
      .jbi_io_ssi_mosi			(jbi_io_ssi_mosi),
      .jbi_io_ssi_sck			(jbi_io_ssi_sck),
      .jbi_iob_spi_vld			(jbi_iob_spi_vld),
      .jbi_iob_spi_data			(jbi_iob_spi_data[`SPI_IOB_WIDTH-1:0]),
      .jbi_iob_spi_stall		(jbi_iob_spi_stall),
      .jbi_io_j_req0_out_l		(jbi_io_j_req0_out_l),
      .jbi_io_j_req0_out_en		(jbi_io_j_req0_out_en),
      .jbi_io_j_adtype			(jbi_io_j_adtype[7:0]),
      .jbi_io_j_adtype_en		(jbi_io_j_adtype_en),
      .jbi_io_j_ad			(jbi_io_j_ad[127:0]),
      .jbi_io_j_ad_en			(jbi_io_j_ad_en[3:0]),
      .jbi_io_j_pack0			(jbi_io_j_pack0[2:0]),
      .jbi_io_j_pack0_en		(jbi_io_j_pack0_en),
      .jbi_io_j_pack1			(jbi_io_j_pack1[2:0]),
      .jbi_io_j_pack1_en		(jbi_io_j_pack1_en),
      .jbi_io_j_adp			(jbi_io_j_adp[3:0]),
      .jbi_io_j_adp_en			(jbi_io_j_adp_en),
      .jbi_io_config_dtl		(jbi_io_config_dtl[1:0]),
      // Inputs
      .cmp_gclk				(cmp_gclk_c2_r[5]),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .cmp_grst_l			(rpt_cmp_grst_l_c4),	 // Templated
      .jbus_gclk			(jbus_gclk_c2_r[5]),	 // Templated
      .jbus_arst_l			(jbus_arst_l),
      .jbus_grst_l			(jbus_grst_l),
      .ctu_jbi_ssiclk			(ctu_jbi_ssiclk),
      .ctu_jbi_tx_en			(rpt_cmp_jbus_tx_sync_c4), // Templated
      .ctu_jbi_rx_en			(rpt_cmp_jbus_rx_sync_c4), // Templated
      .ctu_jbi_fst_rst_l		(io_j_rst_l),		 // Templated
      .clk_jbi_jbus_cken		(ctu_jbi_jbus_cken),	 // Templated
      .clk_jbi_cmp_cken			(rpt_jbi_cmp_cken),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .ddr3_jbi_scanin18		(pddr0_jbi_so),		 // Templated
      .jbusr_jbi_si			(),			 // Templated
      .sctag0_jbi_iq_dequeue		(sctag0_jbi_iq_dequeue_d2), // Templated
      .sctag0_jbi_wib_dequeue		(sctag0_jbi_wib_dequeue_d2), // Templated
      .scbuf0_jbi_data			(scbuf0_jbi_data_d2),	 // Templated
      .scbuf0_jbi_ctag_vld		(scbuf0_jbi_ctag_vld_d2), // Templated
      .scbuf0_jbi_ue_err		(scbuf0_jbi_ue_err_d2),	 // Templated
      .sctag0_jbi_por_req_buf		(sctag0_jbi_por_req_d2), // Templated
      .sctag1_jbi_iq_dequeue		(sctag1_jbi_iq_dequeue_d2), // Templated
      .sctag1_jbi_wib_dequeue		(sctag1_jbi_wib_dequeue_d2), // Templated
      .scbuf1_jbi_data			(scbuf1_jbi_data_d2),	 // Templated
      .scbuf1_jbi_ctag_vld		(scbuf1_jbi_ctag_vld_d2), // Templated
      .scbuf1_jbi_ue_err		(scbuf1_jbi_ue_err_d2),	 // Templated
      .sctag1_jbi_por_req_buf		(sctag1_jbi_por_req_d2), // Templated
      .sctag2_jbi_iq_dequeue		(sctag2_jbi_iq_dequeue_d2), // Templated
      .sctag2_jbi_wib_dequeue		(sctag2_jbi_wib_dequeue_d2), // Templated
      .scbuf2_jbi_data			(scbuf2_jbi_data_d2),	 // Templated
      .scbuf2_jbi_ctag_vld		(scbuf2_jbi_ctag_vld_d2), // Templated
      .scbuf2_jbi_ue_err		(scbuf2_jbi_ue_err_d2),	 // Templated
      .sctag2_jbi_por_req_buf		(sctag2_jbi_por_req_d2), // Templated
      .sctag3_jbi_iq_dequeue		(sctag3_jbi_iq_dequeue_d2), // Templated
      .sctag3_jbi_wib_dequeue		(sctag3_jbi_wib_dequeue_d2), // Templated
      .scbuf3_jbi_data			(scbuf3_jbi_data_d2),	 // Templated
      .scbuf3_jbi_ctag_vld		(scbuf3_jbi_ctag_vld_d2), // Templated
      .scbuf3_jbi_ue_err		(scbuf3_jbi_ue_err_d2),	 // Templated
      .sctag3_jbi_por_req_buf		(sctag3_jbi_por_req_d2), // Templated
      .iob_jbi_pio_stall		(iob_jbi_pio_stall_buf), // Templated
      .iob_jbi_pio_vld			(iob_jbi_pio_vld_buf),	 // Templated
      .iob_jbi_pio_data			(iob_jbi_pio_data_buf[`IOB_JBI_WIDTH-1:0]), // Templated
      .iob_jbi_mondo_ack		(iob_jbi_mondo_ack_buf), // Templated
      .iob_jbi_mondo_nack		(iob_jbi_mondo_nack_buf), // Templated
      .io_jbi_ssi_miso			(io_jbi_ssi_miso),
      .io_jbi_ext_int_l			(io_ext_int_l),		 // Templated
      .iob_jbi_spi_vld			(iob_jbi_spi_vld_buf),	 // Templated
      .iob_jbi_spi_data			(iob_jbi_spi_data_buf[`IOB_SPI_WIDTH-1:0]), // Templated
      .iob_jbi_spi_stall		(iob_jbi_spi_stall_buf), // Templated
      .io_jbi_j_req4_in_l		(io_jbi_j_req4_in_l),
      .io_jbi_j_req5_in_l		(io_jbi_j_req5_in_l),
      .io_jbi_j_adtype			(io_jbi_j_adtype[7:0]),
      .io_jbi_j_ad			(io_jbi_j_ad[127:0]),
      .io_jbi_j_pack4			(io_jbi_j_pack4[2:0]),
      .io_jbi_j_pack5			(io_jbi_j_pack5[2:0]),
      .io_jbi_j_adp			(io_jbi_j_adp[3:0]),
      .io_jbi_j_par			(io_jbi_j_par),
      .iob_jbi_dbg_hi_data		(iob_jbi_dbg_hi_data_buf[47:0]), // Templated
      .iob_jbi_dbg_hi_vld		(iob_jbi_dbg_hi_vld_buf), // Templated
      .iob_jbi_dbg_lo_data		(iob_jbi_dbg_lo_data_buf[47:0]), // Templated
      .iob_jbi_dbg_lo_vld		(iob_jbi_dbg_lo_vld_buf)); // Templated
`endif
//


/* sparc AUTO_TEMPLATE (
    .const_cpuid                        (4'h@),
    .const_maskid                       (ctu_spc_const_maskid[]),

    .gclk				(cmp_gclk_c1_r[0]),
    .adbginit_l                         (cmp_adbginit_l),

    .cmp_grst_l				(rpt_cmp_grst_l_c0),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c0),
    .cluster_cken                       (rpt_spc@_cmp_cken),

    .spc_scanin0			(par_scan_head[3]),
    .spc_scanout0			(par_scan_tail[3]),
    .spc_scanin1			(par_scan_head[4]),
    .spc_scanout1			(par_scan_tail[4]),

    .ctu_sscan_snap                     (ctu_global_snap),
    .ctu_sscan_tid                      (ctu_spc_sscan_tid[]),
    .ctu_sscan_se                       (ctu_spc@_sscan_se),
    .spc_sscan_so                       (spc@_ctu_sscan_out),

    .ctu_tck                            (ctu_spc@_tck),
    .ctu_tst_mbist_enable               (ctu_spc@_mbisten_buf2),
    .tst_ctu_mbist_done                 (spc@_ctu_mbistdone),
    .tst_ctu_mbist_fail                 (spc@_ctu_mbisterr),

    .efc_spc_fuse_clk1                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk1),
    .efc_spc_fuse_clk2                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk2),
    .efc_spc_ifuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),
    .efc_spc_dfuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),

    .pcx_spc_grant_px                   (pcx_spc@_grant_px_buf1[4:0]),
    .cpx_spc_data_rdy_cx2               (cpx_spc@_data_rdy_cx2_buf1),
    .cpx_spc_data_cx2                   (cpx_spc@_data_cx2_buf1[]),

    .\(.*\)spc\(.*\)                    (\1spc@\2[]),
    ); */
//
`ifdef RTL_SPARC0
   sparc sparc0
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq			(spc0_pcx_req_pq[4:0]),	 // Templated
      .spc_pcx_atom_pq			(spc0_pcx_atom_pq),	 // Templated
      .spc_pcx_data_pa			(spc0_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_sscan_so			(spc0_ctu_sscan_out),	 // Templated
      .spc_scanout0			(par_scan_tail[3]),	 // Templated
      .spc_scanout1			(par_scan_tail[4]),	 // Templated
      .tst_ctu_mbist_done		(spc0_ctu_mbistdone),	 // Templated
      .tst_ctu_mbist_fail		(spc0_ctu_mbisterr),	 // Templated
      .spc_efc_ifuse_data		(spc0_efc_ifuse_data),	 // Templated
      .spc_efc_dfuse_data		(spc0_efc_dfuse_data),	 // Templated
      // Inputs
      .pcx_spc_grant_px			(pcx_spc0_grant_px_buf1[4:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc0_data_rdy_cx2_buf1), // Templated
      .cpx_spc_data_cx2			(cpx_spc0_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .const_cpuid			(4'h0),			 // Templated
      .const_maskid			(ctu_spc_const_maskid[7:0]), // Templated
      .ctu_tck				(ctu_spc0_tck),		 // Templated
      .ctu_sscan_se			(ctu_spc0_sscan_se),	 // Templated
      .ctu_sscan_snap			(ctu_global_snap),	 // Templated
      .ctu_sscan_tid			(ctu_spc_sscan_tid[3:0]), // Templated
      .ctu_tst_mbist_enable		(ctu_spc0_mbisten_buf2), // Templated
      .efc_spc_fuse_clk1		(efc_spc0246_fuse_clk1), // Templated
      .efc_spc_fuse_clk2		(efc_spc0246_fuse_clk2), // Templated
      .efc_spc_ifuse_ashift		(efc_spc0_ifuse_ashift), // Templated
      .efc_spc_ifuse_dshift		(efc_spc0_ifuse_dshift), // Templated
      .efc_spc_ifuse_data		(efc_spc0246_fuse_data), // Templated
      .efc_spc_dfuse_ashift		(efc_spc0_dfuse_ashift), // Templated
      .efc_spc_dfuse_dshift		(efc_spc0_dfuse_dshift), // Templated
      .efc_spc_dfuse_data		(efc_spc0246_fuse_data), // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .spc_scanin0			(par_scan_head[3]),	 // Templated
      .spc_scanin1			(par_scan_head[4]),	 // Templated
      .cluster_cken			(rpt_spc0_cmp_cken),	 // Templated
      .gclk				(cmp_gclk_c1_r[0]),	 // Templated
      .cmp_grst_l			(rpt_cmp_grst_l_c0),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c0)); // Templated
`endif
//


/* sparc AUTO_TEMPLATE (
    .const_cpuid                        (4'h@),
    .const_maskid                       (ctu_spc_const_maskid[]),

    .gclk				(cmp_gclk_c1_r[7]),
    .adbginit_l                         (cmp_adbginit_l),

    .cmp_grst_l				(rpt_cmp_grst_l_c5),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c5),
    .cluster_cken                       (rpt_spc@_cmp_cken),

    .spc_scanin0			(par_scan_head[11]),
    .spc_scanout0			(par_scan_tail[11]),
    .spc_scanin1			(par_scan_head[12]),
    .spc_scanout1			(par_scan_tail[12]),

    .ctu_sscan_snap                     (ctu_global_snap),
    .ctu_sscan_tid                      (ctu_spc_sscan_tid[]),
    .ctu_sscan_se                       (ctu_spc@_sscan_se),
    .spc_sscan_so                       (spc@_ctu_sscan_out),

    .ctu_tck                            (ctu_spc@_tck),
    .ctu_tst_mbist_enable               (ctu_spc@_mbisten_buf2),
    .tst_ctu_mbist_done                 (spc@_ctu_mbistdone),
    .tst_ctu_mbist_fail                 (spc@_ctu_mbisterr),

    .efc_spc_fuse_clk1                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk1),
    .efc_spc_fuse_clk2                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk2),
    .efc_spc_ifuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),
    .efc_spc_dfuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),

    .pcx_spc_grant_px                   (pcx_spc@_grant_px_buf1[4:0]),
    .cpx_spc_data_rdy_cx2               (cpx_spc@_data_rdy_cx2_buf1),
    .cpx_spc_data_cx2                   (cpx_spc@_data_cx2_buf1[]),

    .\(.*\)spc\(.*\)                    (\1spc@\2[]),
    ); */
//
`ifdef RTL_SPARC1
   sparc sparc1
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq			(spc1_pcx_req_pq[4:0]),	 // Templated
      .spc_pcx_atom_pq			(spc1_pcx_atom_pq),	 // Templated
      .spc_pcx_data_pa			(spc1_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_sscan_so			(spc1_ctu_sscan_out),	 // Templated
      .spc_scanout0			(par_scan_tail[11]),	 // Templated
      .spc_scanout1			(par_scan_tail[12]),	 // Templated
      .tst_ctu_mbist_done		(spc1_ctu_mbistdone),	 // Templated
      .tst_ctu_mbist_fail		(spc1_ctu_mbisterr),	 // Templated
      .spc_efc_ifuse_data		(spc1_efc_ifuse_data),	 // Templated
      .spc_efc_dfuse_data		(spc1_efc_dfuse_data),	 // Templated
      // Inputs
      .pcx_spc_grant_px			(pcx_spc1_grant_px_buf1[4:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc1_data_rdy_cx2_buf1), // Templated
      .cpx_spc_data_cx2			(cpx_spc1_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .const_cpuid			(4'h1),			 // Templated
      .const_maskid			(ctu_spc_const_maskid[7:0]), // Templated
      .ctu_tck				(ctu_spc1_tck),		 // Templated
      .ctu_sscan_se			(ctu_spc1_sscan_se),	 // Templated
      .ctu_sscan_snap			(ctu_global_snap),	 // Templated
      .ctu_sscan_tid			(ctu_spc_sscan_tid[3:0]), // Templated
      .ctu_tst_mbist_enable		(ctu_spc1_mbisten_buf2), // Templated
      .efc_spc_fuse_clk1		(efc_spc1357_fuse_clk1), // Templated
      .efc_spc_fuse_clk2		(efc_spc1357_fuse_clk2), // Templated
      .efc_spc_ifuse_ashift		(efc_spc1_ifuse_ashift), // Templated
      .efc_spc_ifuse_dshift		(efc_spc1_ifuse_dshift), // Templated
      .efc_spc_ifuse_data		(efc_spc1357_fuse_data), // Templated
      .efc_spc_dfuse_ashift		(efc_spc1_dfuse_ashift), // Templated
      .efc_spc_dfuse_dshift		(efc_spc1_dfuse_dshift), // Templated
      .efc_spc_dfuse_data		(efc_spc1357_fuse_data), // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .spc_scanin0			(par_scan_head[11]),	 // Templated
      .spc_scanin1			(par_scan_head[12]),	 // Templated
      .cluster_cken			(rpt_spc1_cmp_cken),	 // Templated
      .gclk				(cmp_gclk_c1_r[7]),	 // Templated
      .cmp_grst_l			(rpt_cmp_grst_l_c5),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c5)); // Templated
`endif
//


/* sparc AUTO_TEMPLATE (
    .const_cpuid                        (4'h@),
    .const_maskid                       (ctu_spc_const_maskid[]),

    .gclk				(cmp_gclk_c1_r[0]),
    .adbginit_l                         (cmp_adbginit_l),

    .cmp_grst_l				(rpt_cmp_grst_l_c0),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c0),
    .cluster_cken                       (rpt_spc@_cmp_cken),

    .spc_scanin0			(par_scan_head[1]),
    .spc_scanout0			(par_scan_tail[1]),
    .spc_scanin1			(par_scan_head[2]),
    .spc_scanout1			(par_scan_tail[2]),

    .ctu_sscan_snap                     (ctu_global_snap),
    .ctu_sscan_tid                      (ctu_spc_sscan_tid[]),
    .ctu_sscan_se                       (ctu_spc@_sscan_se),
    .spc_sscan_so                       (spc@_ctu_sscan_out),

    .ctu_tck                            (ctu_spc@_tck),
    .ctu_tst_mbist_enable               (ctu_spc@_mbisten_buf2),
    .tst_ctu_mbist_done                 (spc@_ctu_mbistdone),
    .tst_ctu_mbist_fail                 (spc@_ctu_mbisterr),

    .efc_spc_fuse_clk1                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk1),
    .efc_spc_fuse_clk2                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk2),
    .efc_spc_ifuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),
    .efc_spc_dfuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),

    .pcx_spc_grant_px                   (pcx_spc@_grant_px_buf1[4:0]),
    .cpx_spc_data_rdy_cx2               (cpx_spc@_data_rdy_cx2_buf1),
    .cpx_spc_data_cx2                   (cpx_spc@_data_cx2_buf1[]),

    .\(.*\)spc\(.*\)                    (\1spc@\2[]),
    ); */
//
`ifdef RTL_SPARC2
   sparc sparc2
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq			(spc2_pcx_req_pq[4:0]),	 // Templated
      .spc_pcx_atom_pq			(spc2_pcx_atom_pq),	 // Templated
      .spc_pcx_data_pa			(spc2_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_sscan_so			(spc2_ctu_sscan_out),	 // Templated
      .spc_scanout0			(par_scan_tail[1]),	 // Templated
      .spc_scanout1			(par_scan_tail[2]),	 // Templated
      .tst_ctu_mbist_done		(spc2_ctu_mbistdone),	 // Templated
      .tst_ctu_mbist_fail		(spc2_ctu_mbisterr),	 // Templated
      .spc_efc_ifuse_data		(spc2_efc_ifuse_data),	 // Templated
      .spc_efc_dfuse_data		(spc2_efc_dfuse_data),	 // Templated
      // Inputs
      .pcx_spc_grant_px			(pcx_spc2_grant_px_buf1[4:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc2_data_rdy_cx2_buf1), // Templated
      .cpx_spc_data_cx2			(cpx_spc2_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .const_cpuid			(4'h2),			 // Templated
      .const_maskid			(ctu_spc_const_maskid[7:0]), // Templated
      .ctu_tck				(ctu_spc2_tck),		 // Templated
      .ctu_sscan_se			(ctu_spc2_sscan_se),	 // Templated
      .ctu_sscan_snap			(ctu_global_snap),	 // Templated
      .ctu_sscan_tid			(ctu_spc_sscan_tid[3:0]), // Templated
      .ctu_tst_mbist_enable		(ctu_spc2_mbisten_buf2), // Templated
      .efc_spc_fuse_clk1		(efc_spc0246_fuse_clk1), // Templated
      .efc_spc_fuse_clk2		(efc_spc0246_fuse_clk2), // Templated
      .efc_spc_ifuse_ashift		(efc_spc2_ifuse_ashift), // Templated
      .efc_spc_ifuse_dshift		(efc_spc2_ifuse_dshift), // Templated
      .efc_spc_ifuse_data		(efc_spc0246_fuse_data), // Templated
      .efc_spc_dfuse_ashift		(efc_spc2_dfuse_ashift), // Templated
      .efc_spc_dfuse_dshift		(efc_spc2_dfuse_dshift), // Templated
      .efc_spc_dfuse_data		(efc_spc0246_fuse_data), // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .spc_scanin0			(par_scan_head[1]),	 // Templated
      .spc_scanin1			(par_scan_head[2]),	 // Templated
      .cluster_cken			(rpt_spc2_cmp_cken),	 // Templated
      .gclk				(cmp_gclk_c1_r[0]),	 // Templated
      .cmp_grst_l			(rpt_cmp_grst_l_c0),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c0)); // Templated
`endif
//


/* sparc AUTO_TEMPLATE (
    .const_cpuid                        (4'h@),
    .const_maskid                       (ctu_spc_const_maskid[]),

    .gclk				(cmp_gclk_c1_r[7]),
    .adbginit_l                         (cmp_adbginit_l),

    .cmp_grst_l				(rpt_cmp_grst_l_c5),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c5),
    .cluster_cken                       (rpt_spc@_cmp_cken),

    .spc_scanin0			(par_scan_head[13]),
    .spc_scanout0			(par_scan_tail[13]),
    .spc_scanin1			(par_scan_head[14]),
    .spc_scanout1			(par_scan_tail[14]),

    .ctu_sscan_snap                     (ctu_global_snap),
    .ctu_sscan_tid                      (ctu_spc_sscan_tid[]),
    .ctu_sscan_se                       (ctu_spc@_sscan_se),
    .spc_sscan_so                       (spc@_ctu_sscan_out),

    .ctu_tck                            (ctu_spc@_tck),
    .ctu_tst_mbist_enable               (ctu_spc@_mbisten_buf2),
    .tst_ctu_mbist_done                 (spc@_ctu_mbistdone),
    .tst_ctu_mbist_fail                 (spc@_ctu_mbisterr),

    .efc_spc_fuse_clk1                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk1),
    .efc_spc_fuse_clk2                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk2),
    .efc_spc_ifuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),
    .efc_spc_dfuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),

    .pcx_spc_grant_px                   (pcx_spc@_grant_px_buf1[4:0]),
    .cpx_spc_data_rdy_cx2               (cpx_spc@_data_rdy_cx2_buf1),
    .cpx_spc_data_cx2                   (cpx_spc@_data_cx2_buf1[]),

    .\(.*\)spc\(.*\)                    (\1spc@\2[]),
    ); */
//
`ifdef RTL_SPARC3
   sparc sparc3
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq			(spc3_pcx_req_pq[4:0]),	 // Templated
      .spc_pcx_atom_pq			(spc3_pcx_atom_pq),	 // Templated
      .spc_pcx_data_pa			(spc3_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_sscan_so			(spc3_ctu_sscan_out),	 // Templated
      .spc_scanout0			(par_scan_tail[13]),	 // Templated
      .spc_scanout1			(par_scan_tail[14]),	 // Templated
      .tst_ctu_mbist_done		(spc3_ctu_mbistdone),	 // Templated
      .tst_ctu_mbist_fail		(spc3_ctu_mbisterr),	 // Templated
      .spc_efc_ifuse_data		(spc3_efc_ifuse_data),	 // Templated
      .spc_efc_dfuse_data		(spc3_efc_dfuse_data),	 // Templated
      // Inputs
      .pcx_spc_grant_px			(pcx_spc3_grant_px_buf1[4:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc3_data_rdy_cx2_buf1), // Templated
      .cpx_spc_data_cx2			(cpx_spc3_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .const_cpuid			(4'h3),			 // Templated
      .const_maskid			(ctu_spc_const_maskid[7:0]), // Templated
      .ctu_tck				(ctu_spc3_tck),		 // Templated
      .ctu_sscan_se			(ctu_spc3_sscan_se),	 // Templated
      .ctu_sscan_snap			(ctu_global_snap),	 // Templated
      .ctu_sscan_tid			(ctu_spc_sscan_tid[3:0]), // Templated
      .ctu_tst_mbist_enable		(ctu_spc3_mbisten_buf2), // Templated
      .efc_spc_fuse_clk1		(efc_spc1357_fuse_clk1), // Templated
      .efc_spc_fuse_clk2		(efc_spc1357_fuse_clk2), // Templated
      .efc_spc_ifuse_ashift		(efc_spc3_ifuse_ashift), // Templated
      .efc_spc_ifuse_dshift		(efc_spc3_ifuse_dshift), // Templated
      .efc_spc_ifuse_data		(efc_spc1357_fuse_data), // Templated
      .efc_spc_dfuse_ashift		(efc_spc3_dfuse_ashift), // Templated
      .efc_spc_dfuse_dshift		(efc_spc3_dfuse_dshift), // Templated
      .efc_spc_dfuse_data		(efc_spc1357_fuse_data), // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .spc_scanin0			(par_scan_head[13]),	 // Templated
      .spc_scanin1			(par_scan_head[14]),	 // Templated
      .cluster_cken			(rpt_spc3_cmp_cken),	 // Templated
      .gclk				(cmp_gclk_c1_r[7]),	 // Templated
      .cmp_grst_l			(rpt_cmp_grst_l_c5),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c5)); // Templated
`endif
//


/* sparc AUTO_TEMPLATE (
    .const_cpuid                        (4'h@),
    .const_maskid                       (ctu_spc_const_maskid[]),

    .gclk				(cmp_gclk_c2_r[0]),
    .adbginit_l                         (cmp_adbginit_l),

    .cmp_grst_l				(rpt_cmp_grst_l_c2),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c2),
    .cluster_cken                       (rpt_spc@_cmp_cken),

    .spc_scanin0			(par_scan_head[26]),
    .spc_scanout0			(par_scan_tail[26]),
    .spc_scanin1			(par_scan_head[27]),
    .spc_scanout1			(par_scan_tail[27]),

    .ctu_sscan_snap                     (ctu_global_snap),
    .ctu_sscan_tid                      (ctu_spc_sscan_tid[]),
    .ctu_sscan_se                       (ctu_spc@_sscan_se),
    .spc_sscan_so                       (spc@_ctu_sscan_out),

    .ctu_tck                            (ctu_spc@_tck),
    .ctu_tst_mbist_enable               (ctu_spc@_mbisten_buf2),
    .tst_ctu_mbist_done                 (spc@_ctu_mbistdone),
    .tst_ctu_mbist_fail                 (spc@_ctu_mbisterr),

    .efc_spc_fuse_clk1                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk1),
    .efc_spc_fuse_clk2                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk2),
    .efc_spc_ifuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),
    .efc_spc_dfuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),

    .pcx_spc_grant_px                   (pcx_spc@_grant_px_buf1[4:0]),
    .cpx_spc_data_rdy_cx2               (cpx_spc@_data_rdy_cx2_buf1),
    .cpx_spc_data_cx2                   (cpx_spc@_data_cx2_buf1[]),

    .\(.*\)spc\(.*\)                    (\1spc@\2[]),
    ); */
//
`ifdef RTL_SPARC4
   sparc sparc4
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq			(spc4_pcx_req_pq[4:0]),	 // Templated
      .spc_pcx_atom_pq			(spc4_pcx_atom_pq),	 // Templated
      .spc_pcx_data_pa			(spc4_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_sscan_so			(spc4_ctu_sscan_out),	 // Templated
      .spc_scanout0			(par_scan_tail[26]),	 // Templated
      .spc_scanout1			(par_scan_tail[27]),	 // Templated
      .tst_ctu_mbist_done		(spc4_ctu_mbistdone),	 // Templated
      .tst_ctu_mbist_fail		(spc4_ctu_mbisterr),	 // Templated
      .spc_efc_ifuse_data		(spc4_efc_ifuse_data),	 // Templated
      .spc_efc_dfuse_data		(spc4_efc_dfuse_data),	 // Templated
      // Inputs
      .pcx_spc_grant_px			(pcx_spc4_grant_px_buf1[4:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc4_data_rdy_cx2_buf1), // Templated
      .cpx_spc_data_cx2			(cpx_spc4_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .const_cpuid			(4'h4),			 // Templated
      .const_maskid			(ctu_spc_const_maskid[7:0]), // Templated
      .ctu_tck				(ctu_spc4_tck),		 // Templated
      .ctu_sscan_se			(ctu_spc4_sscan_se),	 // Templated
      .ctu_sscan_snap			(ctu_global_snap),	 // Templated
      .ctu_sscan_tid			(ctu_spc_sscan_tid[3:0]), // Templated
      .ctu_tst_mbist_enable		(ctu_spc4_mbisten_buf2), // Templated
      .efc_spc_fuse_clk1		(efc_spc0246_fuse_clk1), // Templated
      .efc_spc_fuse_clk2		(efc_spc0246_fuse_clk2), // Templated
      .efc_spc_ifuse_ashift		(efc_spc4_ifuse_ashift), // Templated
      .efc_spc_ifuse_dshift		(efc_spc4_ifuse_dshift), // Templated
      .efc_spc_ifuse_data		(efc_spc0246_fuse_data), // Templated
      .efc_spc_dfuse_ashift		(efc_spc4_dfuse_ashift), // Templated
      .efc_spc_dfuse_dshift		(efc_spc4_dfuse_dshift), // Templated
      .efc_spc_dfuse_data		(efc_spc0246_fuse_data), // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .spc_scanin0			(par_scan_head[26]),	 // Templated
      .spc_scanin1			(par_scan_head[27]),	 // Templated
      .cluster_cken			(rpt_spc4_cmp_cken),	 // Templated
      .gclk				(cmp_gclk_c2_r[0]),	 // Templated
      .cmp_grst_l			(rpt_cmp_grst_l_c2),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c2)); // Templated
`endif
//


/* sparc AUTO_TEMPLATE (
    .const_cpuid                        (4'h@),
    .const_maskid                       (ctu_spc_const_maskid[]),

    .gclk				(cmp_gclk_c2_r[7]),
    .adbginit_l                         (cmp_adbginit_l),

    .cmp_grst_l				(rpt_cmp_grst_l_c7),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c7),
    .cluster_cken                       (rpt_spc@_cmp_cken),

    .spc_scanin0			(par_scan_head[15]),
    .spc_scanout0			(par_scan_tail[15]),
    .spc_scanin1			(par_scan_head[16]),
    .spc_scanout1			(par_scan_tail[16]),

    .ctu_sscan_snap                     (ctu_global_snap),
    .ctu_sscan_tid                      (ctu_spc_sscan_tid[]),
    .ctu_sscan_se                       (ctu_spc@_sscan_se),
    .spc_sscan_so                       (spc@_ctu_sscan_out),

    .ctu_tck                            (ctu_spc@_tck),
    .ctu_tst_mbist_enable               (ctu_spc@_mbisten_buf2),
    .tst_ctu_mbist_done                 (spc@_ctu_mbistdone),
    .tst_ctu_mbist_fail                 (spc@_ctu_mbisterr),

    .efc_spc_fuse_clk1                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk1),
    .efc_spc_fuse_clk2                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk2),
    .efc_spc_ifuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),
    .efc_spc_dfuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),

    .pcx_spc_grant_px                   (pcx_spc@_grant_px_buf1[4:0]),
    .cpx_spc_data_rdy_cx2               (cpx_spc@_data_rdy_cx2_buf1),
    .cpx_spc_data_cx2                   (cpx_spc@_data_cx2_buf1[]),

    .\(.*\)spc\(.*\)                    (\1spc@\2[]),
    ); */
//
`ifdef RTL_SPARC5
   sparc sparc5
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq			(spc5_pcx_req_pq[4:0]),	 // Templated
      .spc_pcx_atom_pq			(spc5_pcx_atom_pq),	 // Templated
      .spc_pcx_data_pa			(spc5_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_sscan_so			(spc5_ctu_sscan_out),	 // Templated
      .spc_scanout0			(par_scan_tail[15]),	 // Templated
      .spc_scanout1			(par_scan_tail[16]),	 // Templated
      .tst_ctu_mbist_done		(spc5_ctu_mbistdone),	 // Templated
      .tst_ctu_mbist_fail		(spc5_ctu_mbisterr),	 // Templated
      .spc_efc_ifuse_data		(spc5_efc_ifuse_data),	 // Templated
      .spc_efc_dfuse_data		(spc5_efc_dfuse_data),	 // Templated
      // Inputs
      .pcx_spc_grant_px			(pcx_spc5_grant_px_buf1[4:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc5_data_rdy_cx2_buf1), // Templated
      .cpx_spc_data_cx2			(cpx_spc5_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .const_cpuid			(4'h5),			 // Templated
      .const_maskid			(ctu_spc_const_maskid[7:0]), // Templated
      .ctu_tck				(ctu_spc5_tck),		 // Templated
      .ctu_sscan_se			(ctu_spc5_sscan_se),	 // Templated
      .ctu_sscan_snap			(ctu_global_snap),	 // Templated
      .ctu_sscan_tid			(ctu_spc_sscan_tid[3:0]), // Templated
      .ctu_tst_mbist_enable		(ctu_spc5_mbisten_buf2), // Templated
      .efc_spc_fuse_clk1		(efc_spc1357_fuse_clk1), // Templated
      .efc_spc_fuse_clk2		(efc_spc1357_fuse_clk2), // Templated
      .efc_spc_ifuse_ashift		(efc_spc5_ifuse_ashift), // Templated
      .efc_spc_ifuse_dshift		(efc_spc5_ifuse_dshift), // Templated
      .efc_spc_ifuse_data		(efc_spc1357_fuse_data), // Templated
      .efc_spc_dfuse_ashift		(efc_spc5_dfuse_ashift), // Templated
      .efc_spc_dfuse_dshift		(efc_spc5_dfuse_dshift), // Templated
      .efc_spc_dfuse_data		(efc_spc1357_fuse_data), // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .spc_scanin0			(par_scan_head[15]),	 // Templated
      .spc_scanin1			(par_scan_head[16]),	 // Templated
      .cluster_cken			(rpt_spc5_cmp_cken),	 // Templated
      .gclk				(cmp_gclk_c2_r[7]),	 // Templated
      .cmp_grst_l			(rpt_cmp_grst_l_c7),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c7)); // Templated
`endif
//


/* sparc AUTO_TEMPLATE (
    .const_cpuid                        (4'h@),
    .const_maskid                       (ctu_spc_const_maskid[]),

    .gclk				(cmp_gclk_c2_r[0]),
    .adbginit_l                         (cmp_adbginit_l),

    .cmp_grst_l				(rpt_cmp_grst_l_c2),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c2),
    .cluster_cken                       (rpt_spc@_cmp_cken),

    .spc_scanin0			(par_scan_head[28]),
    .spc_scanout0			(par_scan_tail[28]),
    .spc_scanin1			(par_scan_head[29]),
    .spc_scanout1			(par_scan_tail[29]),

    .ctu_sscan_snap                     (ctu_global_snap),
    .ctu_sscan_tid                      (ctu_spc_sscan_tid[]),
    .ctu_sscan_se                       (ctu_spc@_sscan_se),
    .spc_sscan_so                       (spc@_ctu_sscan_out),

    .ctu_tck                            (ctu_spc@_tck),
    .ctu_tst_mbist_enable               (ctu_spc@_mbisten_buf2),
    .tst_ctu_mbist_done                 (spc@_ctu_mbistdone),
    .tst_ctu_mbist_fail                 (spc@_ctu_mbisterr),

    .efc_spc_fuse_clk1                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk1),
    .efc_spc_fuse_clk2                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk2),
    .efc_spc_ifuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),
    .efc_spc_dfuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),

    .pcx_spc_grant_px                   (pcx_spc@_grant_px_buf1[4:0]),
    .cpx_spc_data_rdy_cx2               (cpx_spc@_data_rdy_cx2_buf1),
    .cpx_spc_data_cx2                   (cpx_spc@_data_cx2_buf1[]),

    .\(.*\)spc\(.*\)                    (\1spc@\2[]),
    ); */
//
`ifdef RTL_SPARC6
   sparc sparc6
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq			(spc6_pcx_req_pq[4:0]),	 // Templated
      .spc_pcx_atom_pq			(spc6_pcx_atom_pq),	 // Templated
      .spc_pcx_data_pa			(spc6_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_sscan_so			(spc6_ctu_sscan_out),	 // Templated
      .spc_scanout0			(par_scan_tail[28]),	 // Templated
      .spc_scanout1			(par_scan_tail[29]),	 // Templated
      .tst_ctu_mbist_done		(spc6_ctu_mbistdone),	 // Templated
      .tst_ctu_mbist_fail		(spc6_ctu_mbisterr),	 // Templated
      .spc_efc_ifuse_data		(spc6_efc_ifuse_data),	 // Templated
      .spc_efc_dfuse_data		(spc6_efc_dfuse_data),	 // Templated
      // Inputs
      .pcx_spc_grant_px			(pcx_spc6_grant_px_buf1[4:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc6_data_rdy_cx2_buf1), // Templated
      .cpx_spc_data_cx2			(cpx_spc6_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .const_cpuid			(4'h6),			 // Templated
      .const_maskid			(ctu_spc_const_maskid[7:0]), // Templated
      .ctu_tck				(ctu_spc6_tck),		 // Templated
      .ctu_sscan_se			(ctu_spc6_sscan_se),	 // Templated
      .ctu_sscan_snap			(ctu_global_snap),	 // Templated
      .ctu_sscan_tid			(ctu_spc_sscan_tid[3:0]), // Templated
      .ctu_tst_mbist_enable		(ctu_spc6_mbisten_buf2), // Templated
      .efc_spc_fuse_clk1		(efc_spc0246_fuse_clk1), // Templated
      .efc_spc_fuse_clk2		(efc_spc0246_fuse_clk2), // Templated
      .efc_spc_ifuse_ashift		(efc_spc6_ifuse_ashift), // Templated
      .efc_spc_ifuse_dshift		(efc_spc6_ifuse_dshift), // Templated
      .efc_spc_ifuse_data		(efc_spc0246_fuse_data), // Templated
      .efc_spc_dfuse_ashift		(efc_spc6_dfuse_ashift), // Templated
      .efc_spc_dfuse_dshift		(efc_spc6_dfuse_dshift), // Templated
      .efc_spc_dfuse_data		(efc_spc0246_fuse_data), // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .spc_scanin0			(par_scan_head[28]),	 // Templated
      .spc_scanin1			(par_scan_head[29]),	 // Templated
      .cluster_cken			(rpt_spc6_cmp_cken),	 // Templated
      .gclk				(cmp_gclk_c2_r[0]),	 // Templated
      .cmp_grst_l			(rpt_cmp_grst_l_c2),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c2)); // Templated
`endif
//


/* sparc AUTO_TEMPLATE (
    .const_cpuid                        (4'h@),
    .const_maskid                       (ctu_spc_const_maskid[]),

    .gclk				(cmp_gclk_c2_r[7]),
    .adbginit_l                         (cmp_adbginit_l),

    .cmp_grst_l				(rpt_cmp_grst_l_c7),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c7),
    .cluster_cken                       (rpt_spc@_cmp_cken),

    .spc_scanin0			(par_scan_head[18]),
    .spc_scanout0			(par_scan_tail[18]),
    .spc_scanin1			(par_scan_head[19]),
    .spc_scanout1			(par_scan_tail[19]),

    .ctu_sscan_snap                     (ctu_global_snap),
    .ctu_sscan_tid                      (ctu_spc_sscan_tid[]),
    .ctu_sscan_se                       (ctu_spc@_sscan_se),
    .spc_sscan_so                       (spc@_ctu_sscan_out),

    .ctu_tck                            (ctu_spc@_tck),
    .ctu_tst_mbist_enable               (ctu_spc@_mbisten_buf2),
    .tst_ctu_mbist_done                 (spc@_ctu_mbistdone),
    .tst_ctu_mbist_fail                 (spc@_ctu_mbisterr),

    .efc_spc_fuse_clk1                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk1),
    .efc_spc_fuse_clk2                  (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_clk2),
    .efc_spc_ifuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),
    .efc_spc_dfuse_data                 (efc_spc@"(% @ 2)"@"(+ (% @ 2) 2)"@"(+ (% @ 2) 4)"@"(+ (% @ 2) 6)"_fuse_data),

    .pcx_spc_grant_px                   (pcx_spc@_grant_px_buf1[4:0]),
    .cpx_spc_data_rdy_cx2               (cpx_spc@_data_rdy_cx2_buf1),
    .cpx_spc_data_cx2                   (cpx_spc@_data_cx2_buf1[]),

    .\(.*\)spc\(.*\)                    (\1spc@\2[]),
    ); */
//
`ifdef RTL_SPARC7
   sparc sparc7
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq			(spc7_pcx_req_pq[4:0]),	 // Templated
      .spc_pcx_atom_pq			(spc7_pcx_atom_pq),	 // Templated
      .spc_pcx_data_pa			(spc7_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_sscan_so			(spc7_ctu_sscan_out),	 // Templated
      .spc_scanout0			(par_scan_tail[18]),	 // Templated
      .spc_scanout1			(par_scan_tail[19]),	 // Templated
      .tst_ctu_mbist_done		(spc7_ctu_mbistdone),	 // Templated
      .tst_ctu_mbist_fail		(spc7_ctu_mbisterr),	 // Templated
      .spc_efc_ifuse_data		(spc7_efc_ifuse_data),	 // Templated
      .spc_efc_dfuse_data		(spc7_efc_dfuse_data),	 // Templated
      // Inputs
      .pcx_spc_grant_px			(pcx_spc7_grant_px_buf1[4:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc7_data_rdy_cx2_buf1), // Templated
      .cpx_spc_data_cx2			(cpx_spc7_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .const_cpuid			(4'h7),			 // Templated
      .const_maskid			(ctu_spc_const_maskid[7:0]), // Templated
      .ctu_tck				(ctu_spc7_tck),		 // Templated
      .ctu_sscan_se			(ctu_spc7_sscan_se),	 // Templated
      .ctu_sscan_snap			(ctu_global_snap),	 // Templated
      .ctu_sscan_tid			(ctu_spc_sscan_tid[3:0]), // Templated
      .ctu_tst_mbist_enable		(ctu_spc7_mbisten_buf2), // Templated
      .efc_spc_fuse_clk1		(efc_spc1357_fuse_clk1), // Templated
      .efc_spc_fuse_clk2		(efc_spc1357_fuse_clk2), // Templated
      .efc_spc_ifuse_ashift		(efc_spc7_ifuse_ashift), // Templated
      .efc_spc_ifuse_dshift		(efc_spc7_ifuse_dshift), // Templated
      .efc_spc_ifuse_data		(efc_spc1357_fuse_data), // Templated
      .efc_spc_dfuse_ashift		(efc_spc7_dfuse_ashift), // Templated
      .efc_spc_dfuse_dshift		(efc_spc7_dfuse_dshift), // Templated
      .efc_spc_dfuse_data		(efc_spc1357_fuse_data), // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .spc_scanin0			(par_scan_head[18]),	 // Templated
      .spc_scanin1			(par_scan_head[19]),	 // Templated
      .cluster_cken			(rpt_spc7_cmp_cken),	 // Templated
      .gclk				(cmp_gclk_c2_r[7]),	 // Templated
      .cmp_grst_l			(rpt_cmp_grst_l_c7),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c7)); // Templated
`endif
//


/* fpu AUTO_TEMPLATE (
    .se                                 (global_shift_enable),
    .si                                 (rdram2_fpu_so),
    .so                                 (fpu_rdram3_so),
    .gclk                               (cmp_gclk_c2_r[4]),
    .arst_l			        (cmp_arst_l),
    .grst_l                             (rpt_cmp_grst_l_c6),
    .cluster_cken                       (rpt_fpu_cmp_cken),
    .pcx_fpio_\(.*\)                    (pcx_fp_\1[]),
    ); */
//
`ifdef RTL_FPU
   fpu fpu
     (/*AUTOINST*/
      // Outputs
      .fp_cpx_req_cq			(fp_cpx_req_cq[7:0]),
      .fp_cpx_data_ca			(fp_cpx_data_ca[144:0]),
      .so				(fpu_rdram3_so),	 // Templated
      // Inputs
      .pcx_fpio_data_rdy_px2		(pcx_fp_data_rdy_px2),	 // Templated
      .pcx_fpio_data_px2		(pcx_fp_data_px2[123:0]), // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c6),	 // Templated
      .gclk				(cmp_gclk_c2_r[4]),	 // Templated
      .cluster_cken			(rpt_fpu_cmp_cken),	 // Templated
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .global_shift_enable		(global_shift_enable),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .si				(rdram2_fpu_so));	 // Templated
`endif
//


/* ccx AUTO_TEMPLATE (
    .ccx_scanin0			(par_scan_head[24]),
    .ccx_scanout0			(par_scan_tail[24]),
    .ccx_scanin1			(par_scan_head[25]),
    .ccx_scanout1			(par_scan_tail[25]),
    .gclk                               ({cmp_gclk_c2_r[3],cmp_gclk_c2_r[3]}),
    .adbginit_l                         (cmp_adbginit_l),
    .cmp_grst_l                         (rpt_cmp_grst_l_c3),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c3),
    .clk_ccx_cken                       (rpt_ccx_cmp_cken),
    .spc\(.*\)_pcx\(.*\)                (spc\1_pcx\2_buf1[]),
    .sctag\(.*\)_cpx\(.*\)              (sctag\1_cpx\2_buf[]),
    .sctag\(.*\)_pcx\(.*\)              (sctag\1_pcx\2_buf[]),
    .rclk                               (ccx_rclk),
    .iob_cpx_\(.*\)			(iob_cpx_\1_buf[]),
    .iob_pcx_\(.*\)			(iob_pcx_\1_buf[]),
   ); */
//
`ifdef RTL_CCX
   ccx ccx
     (/*AUTOINST*/
      // Outputs
      .ccx_scanout0			(par_scan_tail[24]),	 // Templated
      .ccx_scanout1			(par_scan_tail[25]),	 // Templated
      .cpx_iob_grant_cx2		(cpx_iob_grant_cx2[7:0]),
      .cpx_sctag0_grant_cx		(cpx_sctag0_grant_cx[7:0]),
      .cpx_sctag1_grant_cx		(cpx_sctag1_grant_cx[7:0]),
      .cpx_sctag2_grant_cx		(cpx_sctag2_grant_cx[7:0]),
      .cpx_sctag3_grant_cx		(cpx_sctag3_grant_cx[7:0]),
      .cpx_spc0_data_cx2		(cpx_spc0_data_cx2[`CPX_WIDTH-1:0]),
      .cpx_spc0_data_rdy_cx2		(cpx_spc0_data_rdy_cx2),
      .cpx_spc1_data_cx2		(cpx_spc1_data_cx2[`CPX_WIDTH-1:0]),
      .cpx_spc1_data_rdy_cx2		(cpx_spc1_data_rdy_cx2),
      .cpx_spc2_data_cx2		(cpx_spc2_data_cx2[`CPX_WIDTH-1:0]),
      .cpx_spc2_data_rdy_cx2		(cpx_spc2_data_rdy_cx2),
      .cpx_spc3_data_cx2		(cpx_spc3_data_cx2[`CPX_WIDTH-1:0]),
      .cpx_spc3_data_rdy_cx2		(cpx_spc3_data_rdy_cx2),
      .cpx_spc4_data_cx2		(cpx_spc4_data_cx2[`CPX_WIDTH-1:0]),
      .cpx_spc4_data_rdy_cx2		(cpx_spc4_data_rdy_cx2),
      .cpx_spc5_data_cx2		(cpx_spc5_data_cx2[`CPX_WIDTH-1:0]),
      .cpx_spc5_data_rdy_cx2		(cpx_spc5_data_rdy_cx2),
      .cpx_spc6_data_cx2		(cpx_spc6_data_cx2[`CPX_WIDTH-1:0]),
      .cpx_spc6_data_rdy_cx2		(cpx_spc6_data_rdy_cx2),
      .cpx_spc7_data_cx2		(cpx_spc7_data_cx2[`CPX_WIDTH-1:0]),
      .cpx_spc7_data_rdy_cx2		(cpx_spc7_data_rdy_cx2),
      .pcx_fp_data_px2			(pcx_fp_data_px2[`PCX_WIDTH-1:0]),
      .pcx_fp_data_rdy_px2		(pcx_fp_data_rdy_px2),
      .pcx_iob_data_px2			(pcx_iob_data_px2[`PCX_WIDTH-1:0]),
      .pcx_iob_data_rdy_px2		(pcx_iob_data_rdy_px2),
      .pcx_sctag0_atm_px1		(pcx_sctag0_atm_px1),
      .pcx_sctag0_data_px2		(pcx_sctag0_data_px2[`PCX_WIDTH-1:0]),
      .pcx_sctag0_data_rdy_px1		(pcx_sctag0_data_rdy_px1),
      .pcx_sctag1_atm_px1		(pcx_sctag1_atm_px1),
      .pcx_sctag1_data_px2		(pcx_sctag1_data_px2[`PCX_WIDTH-1:0]),
      .pcx_sctag1_data_rdy_px1		(pcx_sctag1_data_rdy_px1),
      .pcx_sctag2_atm_px1		(pcx_sctag2_atm_px1),
      .pcx_sctag2_data_px2		(pcx_sctag2_data_px2[`PCX_WIDTH-1:0]),
      .pcx_sctag2_data_rdy_px1		(pcx_sctag2_data_rdy_px1),
      .pcx_sctag3_atm_px1		(pcx_sctag3_atm_px1),
      .pcx_sctag3_data_px2		(pcx_sctag3_data_px2[`PCX_WIDTH-1:0]),
      .pcx_sctag3_data_rdy_px1		(pcx_sctag3_data_rdy_px1),
      .pcx_spc0_grant_px		(pcx_spc0_grant_px[4:0]),
      .pcx_spc1_grant_px		(pcx_spc1_grant_px[4:0]),
      .pcx_spc2_grant_px		(pcx_spc2_grant_px[4:0]),
      .pcx_spc3_grant_px		(pcx_spc3_grant_px[4:0]),
      .pcx_spc4_grant_px		(pcx_spc4_grant_px[4:0]),
      .pcx_spc5_grant_px		(pcx_spc5_grant_px[4:0]),
      .pcx_spc6_grant_px		(pcx_spc6_grant_px[4:0]),
      .pcx_spc7_grant_px		(pcx_spc7_grant_px[4:0]),
      .rclk				(ccx_rclk),		 // Templated
      // Inputs
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .ccx_scanin0			(par_scan_head[24]),	 // Templated
      .ccx_scanin1			(par_scan_head[25]),	 // Templated
      .clk_ccx_cken			(rpt_ccx_cmp_cken),	 // Templated
      .cmp_arst_l			(cmp_arst_l),
      .cmp_grst_l			(rpt_cmp_grst_l_c3),	 // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .fp_cpx_data_ca			(fp_cpx_data_ca[`CPX_WIDTH-1:0]),
      .fp_cpx_req_cq			(fp_cpx_req_cq[7:0]),
      .gclk				({cmp_gclk_c2_r[3],cmp_gclk_c2_r[3]}), // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c3), // Templated
      .global_shift_enable		(global_shift_enable),
      .iob_cpx_data_ca			(iob_cpx_data_ca_buf[`CPX_WIDTH-1:0]), // Templated
      .iob_cpx_req_cq			(iob_cpx_req_cq_buf[7:0]), // Templated
      .sctag0_cpx_atom_cq		(sctag0_cpx_atom_cq_buf), // Templated
      .sctag0_cpx_data_ca		(sctag0_cpx_data_ca_buf[`CPX_WIDTH-1:0]), // Templated
      .sctag0_cpx_req_cq		(sctag0_cpx_req_cq_buf[7:0]), // Templated
      .sctag0_pcx_stall_pq		(sctag0_pcx_stall_pq_buf), // Templated
      .sctag1_cpx_atom_cq		(sctag1_cpx_atom_cq_buf), // Templated
      .sctag1_cpx_data_ca		(sctag1_cpx_data_ca_buf[`CPX_WIDTH-1:0]), // Templated
      .sctag1_cpx_req_cq		(sctag1_cpx_req_cq_buf[7:0]), // Templated
      .sctag1_pcx_stall_pq		(sctag1_pcx_stall_pq_buf), // Templated
      .sctag2_cpx_atom_cq		(sctag2_cpx_atom_cq_buf), // Templated
      .sctag2_cpx_data_ca		(sctag2_cpx_data_ca_buf[`CPX_WIDTH-1:0]), // Templated
      .sctag2_cpx_req_cq		(sctag2_cpx_req_cq_buf[7:0]), // Templated
      .sctag2_pcx_stall_pq		(sctag2_pcx_stall_pq_buf), // Templated
      .sctag3_cpx_atom_cq		(sctag3_cpx_atom_cq_buf), // Templated
      .sctag3_cpx_data_ca		(sctag3_cpx_data_ca_buf[`CPX_WIDTH-1:0]), // Templated
      .sctag3_cpx_req_cq		(sctag3_cpx_req_cq_buf[7:0]), // Templated
      .sctag3_pcx_stall_pq		(sctag3_pcx_stall_pq_buf), // Templated
      .spc0_pcx_atom_pq			(spc0_pcx_atom_pq_buf1), // Templated
      .spc0_pcx_data_pa			(spc0_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .spc0_pcx_req_pq			(spc0_pcx_req_pq_buf1[4:0]), // Templated
      .spc1_pcx_atom_pq			(spc1_pcx_atom_pq_buf1), // Templated
      .spc1_pcx_data_pa			(spc1_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .spc1_pcx_req_pq			(spc1_pcx_req_pq_buf1[4:0]), // Templated
      .spc2_pcx_atom_pq			(spc2_pcx_atom_pq_buf1), // Templated
      .spc2_pcx_data_pa			(spc2_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .spc2_pcx_req_pq			(spc2_pcx_req_pq_buf1[4:0]), // Templated
      .spc3_pcx_atom_pq			(spc3_pcx_atom_pq_buf1), // Templated
      .spc3_pcx_data_pa			(spc3_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .spc3_pcx_req_pq			(spc3_pcx_req_pq_buf1[4:0]), // Templated
      .spc4_pcx_atom_pq			(spc4_pcx_atom_pq_buf1), // Templated
      .spc4_pcx_data_pa			(spc4_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .spc4_pcx_req_pq			(spc4_pcx_req_pq_buf1[4:0]), // Templated
      .spc5_pcx_atom_pq			(spc5_pcx_atom_pq_buf1), // Templated
      .spc5_pcx_data_pa			(spc5_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .spc5_pcx_req_pq			(spc5_pcx_req_pq_buf1[4:0]), // Templated
      .spc6_pcx_atom_pq			(spc6_pcx_atom_pq_buf1), // Templated
      .spc6_pcx_data_pa			(spc6_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .spc6_pcx_req_pq			(spc6_pcx_req_pq_buf1[4:0]), // Templated
      .spc7_pcx_atom_pq			(spc7_pcx_atom_pq_buf1), // Templated
      .spc7_pcx_data_pa			(spc7_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .spc7_pcx_req_pq			(spc7_pcx_req_pq_buf1[4:0]), // Templated
      .iob_pcx_stall_pq			(iob_pcx_stall_pq_buf));	 // Templated
`endif

   // sctag <-> ccx repeaters.
   sctag_pcx_rptr_0 sctag_pcx_rptr_0 (
        .sig				({ unused_sctag_pcx_rptr_0i[36:0], pcx_sctag0_data_px2[123:0],     sctag0_pcx_stall_pq,     pcx_sctag0_data_rdy_px1,     pcx_sctag0_atm_px1     }),
        .sig_buf			({ unused_sctag_pcx_rptr_0[36:0],  pcx_sctag0_data_px2_buf[123:0], sctag0_pcx_stall_pq_buf, pcx_sctag0_data_rdy_px1_buf, pcx_sctag0_atm_px1_buf }));

   sctag_pcx_rptr_1 sctag_pcx_rptr_1 (
        .sig				({ unused_sctag_pcx_rptr_1i[36:0], pcx_sctag1_data_px2[123:0],     sctag1_pcx_stall_pq,     pcx_sctag1_data_rdy_px1,     pcx_sctag1_atm_px1     }),
        .sig_buf			({ unused_sctag_pcx_rptr_1[36:0],  pcx_sctag1_data_px2_buf[123:0], sctag1_pcx_stall_pq_buf, pcx_sctag1_data_rdy_px1_buf, pcx_sctag1_atm_px1_buf }));

   sctag_pcx_rptr_2 sctag_pcx_rptr_2 (
        .sig				({ unused_sctag_pcx_rptr_2i[36:0], pcx_sctag2_data_px2[123:0],     sctag2_pcx_stall_pq,     pcx_sctag2_data_rdy_px1,     pcx_sctag2_atm_px1     }),
        .sig_buf			({ unused_sctag_pcx_rptr_2[36:0],  pcx_sctag2_data_px2_buf[123:0], sctag2_pcx_stall_pq_buf, pcx_sctag2_data_rdy_px1_buf, pcx_sctag2_atm_px1_buf }));

   sctag_pcx_rptr_3 sctag_pcx_rptr_3 (
        .sig				({ unused_sctag_pcx_rptr_3i[36:0], pcx_sctag3_data_px2[123:0],     sctag3_pcx_stall_pq,     pcx_sctag3_data_rdy_px1,     pcx_sctag3_atm_px1     }),
        .sig_buf			({ unused_sctag_pcx_rptr_3[36:0],  pcx_sctag3_data_px2_buf[123:0], sctag3_pcx_stall_pq_buf, pcx_sctag3_data_rdy_px1_buf, pcx_sctag3_atm_px1_buf }));



   sctag_cpx_rptr_0 sctag_cpx_rptr_0 (
        .sig				({ unused_sctag_cpx_rptr_0i[1:0], cpx_sctag0_grant_cx[7:0],     sctag0_cpx_req_cq[7:0],     sctag0_cpx_atom_cq,     sctag0_cpx_data_ca[144:0]     }),
        .sig_buf			({ unused_sctag_cpx_rptr_0[1:0],  cpx_sctag0_grant_cx_buf[7:0], sctag0_cpx_req_cq_buf[7:0], sctag0_cpx_atom_cq_buf, sctag0_cpx_data_ca_buf[144:0] })); 

   sctag_cpx_rptr_1 sctag_cpx_rptr_1 (
        .sig				({ unused_sctag_cpx_rptr_1i[1:0], cpx_sctag1_grant_cx[7:0],     sctag1_cpx_req_cq[7:0],     sctag1_cpx_atom_cq,     sctag1_cpx_data_ca[144:0]     }),
        .sig_buf			({ unused_sctag_cpx_rptr_1[1:0],  cpx_sctag1_grant_cx_buf[7:0], sctag1_cpx_req_cq_buf[7:0], sctag1_cpx_atom_cq_buf, sctag1_cpx_data_ca_buf[144:0] })); 

   sctag_cpx_rptr_2 sctag_cpx_rptr_2 (
        .sig				({ unused_sctag_cpx_rptr_2i[1:0], cpx_sctag2_grant_cx[7:0],     sctag2_cpx_req_cq[7:0],     sctag2_cpx_atom_cq,     sctag2_cpx_data_ca[144:0]     }),
        .sig_buf			({ unused_sctag_cpx_rptr_2[1:0],  cpx_sctag2_grant_cx_buf[7:0], sctag2_cpx_req_cq_buf[7:0], sctag2_cpx_atom_cq_buf, sctag2_cpx_data_ca_buf[144:0] })); 

   sctag_cpx_rptr_3 sctag_cpx_rptr_3 (
        .sig				({ unused_sctag_cpx_rptr_3i[1:0], cpx_sctag3_grant_cx[7:0],     sctag3_cpx_req_cq[7:0],     sctag3_cpx_atom_cq,     sctag3_cpx_data_ca[144:0]     }),
        .sig_buf			({ unused_sctag_cpx_rptr_3[1:0],  cpx_sctag3_grant_cx_buf[7:0], sctag3_cpx_req_cq_buf[7:0], sctag3_cpx_atom_cq_buf, sctag3_cpx_data_ca_buf[144:0] })); 



   // ccx <-> iob repeaters.
   ccx_iob_rptr ccx_iob_rptr (
	.sig				({ cpx_iob_grant_cx2[7:0],     pcx_iob_data_px2[123:0],     pcx_iob_data_rdy_px2,     unused_ccx_iob_rptri[2:0] }),
        .sig_buf			({ cpx_iob_grant_cx2_buf[7:0], pcx_iob_data_px2_buf[123:0], pcx_iob_data_rdy_px2_buf, unused_ccx_iob_rptr[2:0]  }));

   iob_ccx_rptr iob_ccx_rptr (
	.sig				({ iob_cpx_data_ca[115],     iob_cpx_data_ca[113],     iob_cpx_data_ca[111],     iob_cpx_data_ca[109],     iob_cpx_data_ca[107],
					   iob_cpx_data_ca[105],     iob_cpx_data_ca[103],     iob_cpx_data_ca[101],	 iob_cpx_data_ca[99],	   iob_cpx_data_ca[97],
					   iob_cpx_data_ca[95],	     iob_cpx_data_ca[93],      iob_cpx_data_ca[91],	 iob_cpx_data_ca[89],	   iob_cpx_data_ca[87],
					   iob_cpx_data_ca[85],	     iob_cpx_data_ca[83],      iob_cpx_data_ca[81],	 iob_cpx_data_ca[79],	   iob_cpx_data_ca[77],
					   iob_cpx_data_ca[75],	     iob_cpx_data_ca[73],      iob_cpx_data_ca[71],	 iob_cpx_data_ca[69],	   iob_cpx_data_ca[67],
					   iob_cpx_data_ca[65],	     iob_cpx_data_ca[63],      iob_cpx_data_ca[61],	 iob_cpx_data_ca[59],	   iob_cpx_data_ca[57],
					   iob_cpx_data_ca[55],	     iob_cpx_data_ca[53],      iob_cpx_data_ca[51],	 iob_cpx_data_ca[49],	   iob_cpx_data_ca[47],
					   iob_cpx_data_ca[45],	     iob_cpx_data_ca[43],      iob_cpx_data_ca[41],	 iob_cpx_data_ca[39],	   iob_cpx_data_ca[37],
					   iob_cpx_data_ca[35],	     iob_cpx_data_ca[33],      iob_cpx_data_ca[32],	 iob_cpx_data_ca[30],	   iob_cpx_data_ca[28],
					   iob_cpx_data_ca[26],	     iob_cpx_data_ca[24],      iob_cpx_data_ca[22],	 iob_cpx_data_ca[20],	   iob_cpx_data_ca[18],
					   iob_cpx_data_ca[16],	     iob_cpx_data_ca[14],      iob_cpx_data_ca[12],	 iob_cpx_data_ca[10],	   iob_cpx_data_ca[8],
					   iob_cpx_data_ca[6],	     iob_cpx_data_ca[4],       iob_cpx_data_ca[2],	 iob_cpx_data_ca[0],	   iob_cpx_req_cq[6],
					   iob_cpx_req_cq[4],	     iob_cpx_req_cq[2],	       iob_cpx_req_cq[0],	 iob_cpx_data_ca[143],	   iob_cpx_data_ca[141],
					   iob_cpx_data_ca[139],     iob_cpx_data_ca[137],     iob_cpx_data_ca[135],	 iob_cpx_data_ca[133],	   iob_cpx_data_ca[131],
					   iob_cpx_data_ca[129],     iob_cpx_data_ca[127],     iob_cpx_data_ca[125],	 iob_cpx_data_ca[123],	   iob_cpx_data_ca[121],
					   iob_cpx_data_ca[119],     iob_cpx_data_ca[117],     iob_cpx_data_ca[118],	 iob_cpx_data_ca[120],	   iob_cpx_data_ca[122],
					   iob_cpx_data_ca[124],     iob_cpx_data_ca[126],     iob_cpx_data_ca[128],	 iob_cpx_data_ca[130],	   iob_cpx_data_ca[132],
					   iob_cpx_data_ca[134],     iob_cpx_data_ca[136],     iob_cpx_data_ca[138],	 iob_cpx_data_ca[140],	   iob_cpx_data_ca[142],
					   iob_cpx_data_ca[144],     iob_cpx_req_cq[1],	       iob_cpx_req_cq[3],	 iob_cpx_req_cq[5],	   iob_cpx_req_cq[7],
					   iob_cpx_data_ca[1],	     iob_cpx_data_ca[3],       iob_cpx_data_ca[5],	 iob_cpx_data_ca[7],	   iob_cpx_data_ca[9],
					   iob_cpx_data_ca[11],	     iob_cpx_data_ca[13],      iob_cpx_data_ca[15],	 iob_cpx_data_ca[17],	   iob_cpx_data_ca[19],
					   iob_cpx_data_ca[21],	     iob_cpx_data_ca[23],      iob_cpx_data_ca[25],	 iob_cpx_data_ca[27],	   iob_cpx_data_ca[29],
					   iob_cpx_data_ca[31],	     iob_cpx_data_ca[34],      iob_cpx_data_ca[36],	 iob_cpx_data_ca[38],	   iob_cpx_data_ca[40],
					   iob_cpx_data_ca[42],	     iob_cpx_data_ca[44],      iob_cpx_data_ca[46],	 iob_cpx_data_ca[48],	   iob_cpx_data_ca[50],
					   iob_cpx_data_ca[52],	     iob_cpx_data_ca[54],      iob_cpx_data_ca[56],	 iob_cpx_data_ca[58],	   iob_cpx_data_ca[60],
					   iob_cpx_data_ca[62],	     iob_cpx_data_ca[64],      iob_cpx_data_ca[66],	 iob_cpx_data_ca[68],	   iob_cpx_data_ca[70],
					   iob_cpx_data_ca[72],	     iob_cpx_data_ca[74],      iob_cpx_data_ca[76],	 iob_cpx_data_ca[78],	   iob_cpx_data_ca[80],
					   iob_cpx_data_ca[82],	     iob_cpx_data_ca[84],      iob_cpx_data_ca[86],	 iob_cpx_data_ca[88],	   iob_cpx_data_ca[90],
					   iob_cpx_data_ca[92],	     iob_cpx_data_ca[94],      iob_cpx_data_ca[96],	 iob_cpx_data_ca[98],	   iob_cpx_data_ca[100],
					   iob_cpx_data_ca[102],     iob_cpx_data_ca[104],     iob_cpx_data_ca[106],	 iob_cpx_data_ca[108],	   iob_cpx_data_ca[110],
					   iob_cpx_data_ca[112],     iob_cpx_data_ca[114],     iob_cpx_data_ca[116],	 iob_pcx_stall_pq,	   unused_iob_ccx_rptr_bufi[9:0] }),
        .sig_buf                        ({ iob_cpx_data_ca_buf[115], iob_cpx_data_ca_buf[113], iob_cpx_data_ca_buf[111], iob_cpx_data_ca_buf[109], iob_cpx_data_ca_buf[107],
                                           iob_cpx_data_ca_buf[105], iob_cpx_data_ca_buf[103], iob_cpx_data_ca_buf[101], iob_cpx_data_ca_buf[99],  iob_cpx_data_ca_buf[97],
                                           iob_cpx_data_ca_buf[95],  iob_cpx_data_ca_buf[93],  iob_cpx_data_ca_buf[91],  iob_cpx_data_ca_buf[89],  iob_cpx_data_ca_buf[87],
                                           iob_cpx_data_ca_buf[85],  iob_cpx_data_ca_buf[83],  iob_cpx_data_ca_buf[81],  iob_cpx_data_ca_buf[79],  iob_cpx_data_ca_buf[77],
                                           iob_cpx_data_ca_buf[75],  iob_cpx_data_ca_buf[73],  iob_cpx_data_ca_buf[71],  iob_cpx_data_ca_buf[69],  iob_cpx_data_ca_buf[67],
                                           iob_cpx_data_ca_buf[65],  iob_cpx_data_ca_buf[63],  iob_cpx_data_ca_buf[61],  iob_cpx_data_ca_buf[59],  iob_cpx_data_ca_buf[57],
                                           iob_cpx_data_ca_buf[55],  iob_cpx_data_ca_buf[53],  iob_cpx_data_ca_buf[51],  iob_cpx_data_ca_buf[49],  iob_cpx_data_ca_buf[47],
                                           iob_cpx_data_ca_buf[45],  iob_cpx_data_ca_buf[43],  iob_cpx_data_ca_buf[41],  iob_cpx_data_ca_buf[39],  iob_cpx_data_ca_buf[37],
                                           iob_cpx_data_ca_buf[35],  iob_cpx_data_ca_buf[33],  iob_cpx_data_ca_buf[32],  iob_cpx_data_ca_buf[30],  iob_cpx_data_ca_buf[28],
                                           iob_cpx_data_ca_buf[26],  iob_cpx_data_ca_buf[24],  iob_cpx_data_ca_buf[22],  iob_cpx_data_ca_buf[20],  iob_cpx_data_ca_buf[18],
                                           iob_cpx_data_ca_buf[16],  iob_cpx_data_ca_buf[14],  iob_cpx_data_ca_buf[12],  iob_cpx_data_ca_buf[10],  iob_cpx_data_ca_buf[8],
                                           iob_cpx_data_ca_buf[6],   iob_cpx_data_ca_buf[4],   iob_cpx_data_ca_buf[2],   iob_cpx_data_ca_buf[0],   iob_cpx_req_cq_buf[6],
                                           iob_cpx_req_cq_buf[4],    iob_cpx_req_cq_buf[2],    iob_cpx_req_cq_buf[0],    iob_cpx_data_ca_buf[143], iob_cpx_data_ca_buf[141],
                                           iob_cpx_data_ca_buf[139], iob_cpx_data_ca_buf[137], iob_cpx_data_ca_buf[135], iob_cpx_data_ca_buf[133], iob_cpx_data_ca_buf[131],
                                           iob_cpx_data_ca_buf[129], iob_cpx_data_ca_buf[127], iob_cpx_data_ca_buf[125], iob_cpx_data_ca_buf[123], iob_cpx_data_ca_buf[121],
                                           iob_cpx_data_ca_buf[119], iob_cpx_data_ca_buf[117], iob_cpx_data_ca_buf[118], iob_cpx_data_ca_buf[120], iob_cpx_data_ca_buf[122],
                                           iob_cpx_data_ca_buf[124], iob_cpx_data_ca_buf[126], iob_cpx_data_ca_buf[128], iob_cpx_data_ca_buf[130], iob_cpx_data_ca_buf[132],
                                           iob_cpx_data_ca_buf[134], iob_cpx_data_ca_buf[136], iob_cpx_data_ca_buf[138], iob_cpx_data_ca_buf[140], iob_cpx_data_ca_buf[142],
                                           iob_cpx_data_ca_buf[144], iob_cpx_req_cq_buf[1],    iob_cpx_req_cq_buf[3],    iob_cpx_req_cq_buf[5],    iob_cpx_req_cq_buf[7],
                                           iob_cpx_data_ca_buf[1],   iob_cpx_data_ca_buf[3],   iob_cpx_data_ca_buf[5],   iob_cpx_data_ca_buf[7],   iob_cpx_data_ca_buf[9],
                                           iob_cpx_data_ca_buf[11],  iob_cpx_data_ca_buf[13],  iob_cpx_data_ca_buf[15],  iob_cpx_data_ca_buf[17],  iob_cpx_data_ca_buf[19],
                                           iob_cpx_data_ca_buf[21],  iob_cpx_data_ca_buf[23],  iob_cpx_data_ca_buf[25],  iob_cpx_data_ca_buf[27],  iob_cpx_data_ca_buf[29],
                                           iob_cpx_data_ca_buf[31],  iob_cpx_data_ca_buf[34],  iob_cpx_data_ca_buf[36],  iob_cpx_data_ca_buf[38],  iob_cpx_data_ca_buf[40],
                                           iob_cpx_data_ca_buf[42],  iob_cpx_data_ca_buf[44],  iob_cpx_data_ca_buf[46],  iob_cpx_data_ca_buf[48],  iob_cpx_data_ca_buf[50],
                                           iob_cpx_data_ca_buf[52],  iob_cpx_data_ca_buf[54],  iob_cpx_data_ca_buf[56],  iob_cpx_data_ca_buf[58],  iob_cpx_data_ca_buf[60],
                                           iob_cpx_data_ca_buf[62],  iob_cpx_data_ca_buf[64],  iob_cpx_data_ca_buf[66],  iob_cpx_data_ca_buf[68],  iob_cpx_data_ca_buf[70],
                                           iob_cpx_data_ca_buf[72],  iob_cpx_data_ca_buf[74],  iob_cpx_data_ca_buf[76],  iob_cpx_data_ca_buf[78],  iob_cpx_data_ca_buf[80],
                                           iob_cpx_data_ca_buf[82],  iob_cpx_data_ca_buf[84],  iob_cpx_data_ca_buf[86],  iob_cpx_data_ca_buf[88],  iob_cpx_data_ca_buf[90],
                                           iob_cpx_data_ca_buf[92],  iob_cpx_data_ca_buf[94],  iob_cpx_data_ca_buf[96],  iob_cpx_data_ca_buf[98],  iob_cpx_data_ca_buf[100],
                                           iob_cpx_data_ca_buf[102], iob_cpx_data_ca_buf[104], iob_cpx_data_ca_buf[106], iob_cpx_data_ca_buf[108], iob_cpx_data_ca_buf[110],
                                           iob_cpx_data_ca_buf[112], iob_cpx_data_ca_buf[114], iob_cpx_data_ca_buf[116], iob_pcx_stall_pq_buf,     unused_iob_ccx_rptr_buf[9:0]  }));



   // ccx <-> jbi repeaters.
   iob_jbi_rptr_0 iob_jbi_rptr_0 (
        .sig                            ({ iob_jbi_pio_data[49],        iob_jbi_pio_data[47],        iob_jbi_pio_data[45],        iob_jbi_pio_data[43],        iob_jbi_pio_data[41],
                                           iob_jbi_pio_data[39],        iob_jbi_pio_data[37],        iob_jbi_pio_data[35],        iob_jbi_pio_data[33],        iob_jbi_pio_data[31],
                                           iob_jbi_pio_data[29],        iob_jbi_pio_data[27],        iob_jbi_pio_data[25],        iob_jbi_pio_data[23],        iob_jbi_pio_data[21],
                                           iob_jbi_pio_data[19],        iob_jbi_pio_data[17],        iob_jbi_pio_data[15],        iob_jbi_pio_data[13],        iob_jbi_pio_data[11],
                                           iob_jbi_pio_data[9],         iob_jbi_pio_data[7],         iob_jbi_pio_data[5],         iob_jbi_pio_data[3],         iob_jbi_pio_data[1],
                                           iob_jbi_pio_data[0],         iob_jbi_dbg_lo_data[47],     iob_jbi_dbg_lo_data[45],     iob_jbi_dbg_lo_data[43],     iob_jbi_dbg_lo_data[41],
                                           iob_jbi_dbg_lo_data[39],     iob_jbi_dbg_lo_data[37],     iob_jbi_dbg_lo_data[34],     iob_jbi_dbg_lo_data[32],     iob_jbi_dbg_lo_data[30],
                                           iob_jbi_dbg_lo_data[28],     iob_jbi_dbg_lo_data[26],     iob_jbi_dbg_lo_data[24],     iob_jbi_dbg_lo_data[22],     iob_jbi_dbg_lo_data[20],
                                           iob_jbi_dbg_lo_data[18],     iob_jbi_dbg_lo_data[16],     iob_jbi_dbg_lo_data[14],     iob_jbi_dbg_lo_data[12],     iob_jbi_dbg_lo_data[10],
                                           iob_jbi_dbg_lo_data[9],      iob_jbi_dbg_lo_data[7],      iob_jbi_dbg_lo_data[5],      iob_jbi_dbg_lo_data[2],      iob_jbi_dbg_lo_data[0],
                                           iob_jbi_dbg_hi_data[47],     iob_jbi_dbg_hi_data[45],     iob_jbi_dbg_hi_data[43],     iob_jbi_dbg_hi_data[41],     iob_jbi_dbg_hi_data[39],
                                           iob_jbi_dbg_hi_data[37],     iob_jbi_dbg_hi_data[35],     iob_jbi_dbg_hi_data[33],     iob_jbi_dbg_hi_data[31],     iob_jbi_dbg_hi_data[30],
                                           iob_jbi_dbg_hi_data[29],     iob_jbi_dbg_hi_data[28],     iob_jbi_dbg_hi_data[27],     iob_jbi_dbg_hi_data[25],     iob_jbi_dbg_hi_data[23],
                                           iob_jbi_dbg_hi_data[21],     iob_jbi_dbg_hi_data[19],     iob_jbi_dbg_hi_data[17],     iob_jbi_dbg_hi_data[16],     iob_jbi_dbg_hi_data[15],
                                           iob_jbi_dbg_hi_data[14],     iob_jbi_dbg_hi_data[13],     iob_jbi_dbg_hi_data[12],     iob_jbi_dbg_hi_data[11],     iob_jbi_dbg_hi_data[10],
                                           iob_jbi_dbg_hi_data[9],      iob_jbi_dbg_hi_data[8],      iob_jbi_dbg_hi_data[7],      iob_jbi_dbg_hi_data[6],      iob_jbi_dbg_hi_data[5],
                                           iob_jbi_dbg_hi_data[4],      iob_jbi_dbg_hi_data[3],      iob_jbi_spi_data[3],         iob_jbi_spi_data[1],         iob_jbi_pio_data[63],
                                           iob_jbi_pio_data[61],        iob_jbi_pio_data[60],        iob_jbi_pio_data[59],        iob_jbi_pio_data[58],        iob_jbi_pio_data[57],
                                           iob_jbi_pio_data[56],        iob_jbi_pio_data[55],        iob_jbi_pio_data[54],        iob_jbi_pio_data[53],        iob_jbi_pio_data[52],
                                           iob_jbi_pio_data[51],        iob_jbi_pio_data[50],        iob_jbi_dbg_hi_data[2],      iob_jbi_dbg_hi_data[1],      iob_jbi_dbg_hi_data[0],
                                           iob_jbi_pio_data[62],        iob_jbi_spi_data[0],         iob_jbi_spi_data[2],         iob_jbi_dbg_hi_data[18],     iob_jbi_dbg_hi_data[20],
                                           iob_jbi_dbg_hi_data[22],     iob_jbi_dbg_hi_data[24],     iob_jbi_dbg_hi_data[26],     iob_jbi_dbg_hi_data[32],     iob_jbi_dbg_hi_data[34],
                                           iob_jbi_dbg_hi_data[36],     iob_jbi_dbg_hi_data[38],     iob_jbi_dbg_hi_data[40],     iob_jbi_dbg_hi_data[42],     iob_jbi_dbg_hi_data[44],
                                           iob_jbi_dbg_hi_data[46],     iob_jbi_dbg_lo_data[1],      iob_jbi_dbg_lo_data[3],      iob_jbi_dbg_lo_data[4],      iob_jbi_dbg_lo_data[6],
                                           iob_jbi_dbg_lo_data[8],      iob_jbi_dbg_lo_data[11],     iob_jbi_dbg_lo_data[13],     iob_jbi_dbg_lo_data[15],     iob_jbi_dbg_lo_data[17],
                                           iob_jbi_dbg_lo_data[19],     iob_jbi_dbg_lo_data[21],     iob_jbi_dbg_lo_data[23],     iob_jbi_dbg_lo_data[25],     iob_jbi_dbg_lo_data[27],
                                           iob_jbi_dbg_lo_data[29],     iob_jbi_dbg_lo_data[31],     iob_jbi_dbg_lo_data[33],     iob_jbi_dbg_lo_data[35],     iob_jbi_dbg_lo_data[36],
                                           iob_jbi_dbg_lo_data[38],     iob_jbi_dbg_lo_data[40],     iob_jbi_dbg_lo_data[42],     iob_jbi_dbg_lo_data[44],     iob_jbi_dbg_lo_data[46],
                                           iob_jbi_pio_data[2],         iob_jbi_pio_data[4],         iob_jbi_pio_data[6],         iob_jbi_pio_data[8],         iob_jbi_pio_data[10],
                                           iob_jbi_pio_data[12],        iob_jbi_pio_data[14],        iob_jbi_pio_data[16],        iob_jbi_pio_data[18],        iob_jbi_pio_data[20],
                                           iob_jbi_pio_data[22],        iob_jbi_pio_data[24],        iob_jbi_pio_data[26],        iob_jbi_pio_data[28],        iob_jbi_pio_data[30],
                                           iob_jbi_pio_data[32],        iob_jbi_pio_data[34],        iob_jbi_pio_data[36],        iob_jbi_pio_data[38],        iob_jbi_pio_data[40],
                                           iob_jbi_pio_data[42],        iob_jbi_pio_data[44],        iob_jbi_pio_data[46],        iob_jbi_pio_data[48]                                     }),
        .sig_buf                        ({ iob_jbi_pio_data_buf[49],    iob_jbi_pio_data_buf[47],    iob_jbi_pio_data_buf[45],    iob_jbi_pio_data_buf[43],    iob_jbi_pio_data_buf[41],
                                           iob_jbi_pio_data_buf[39],    iob_jbi_pio_data_buf[37],    iob_jbi_pio_data_buf[35],    iob_jbi_pio_data_buf[33],    iob_jbi_pio_data_buf[31],
                                           iob_jbi_pio_data_buf[29],    iob_jbi_pio_data_buf[27],    iob_jbi_pio_data_buf[25],    iob_jbi_pio_data_buf[23],    iob_jbi_pio_data_buf[21],
                                           iob_jbi_pio_data_buf[19],    iob_jbi_pio_data_buf[17],    iob_jbi_pio_data_buf[15],    iob_jbi_pio_data_buf[13],    iob_jbi_pio_data_buf[11],
                                           iob_jbi_pio_data_buf[9],     iob_jbi_pio_data_buf[7],     iob_jbi_pio_data_buf[5],     iob_jbi_pio_data_buf[3],     iob_jbi_pio_data_buf[1],
                                           iob_jbi_pio_data_buf[0],     iob_jbi_dbg_lo_data_buf[47], iob_jbi_dbg_lo_data_buf[45], iob_jbi_dbg_lo_data_buf[43], iob_jbi_dbg_lo_data_buf[41],
                                           iob_jbi_dbg_lo_data_buf[39], iob_jbi_dbg_lo_data_buf[37], iob_jbi_dbg_lo_data_buf[34], iob_jbi_dbg_lo_data_buf[32], iob_jbi_dbg_lo_data_buf[30],
                                           iob_jbi_dbg_lo_data_buf[28], iob_jbi_dbg_lo_data_buf[26], iob_jbi_dbg_lo_data_buf[24], iob_jbi_dbg_lo_data_buf[22], iob_jbi_dbg_lo_data_buf[20],
                                           iob_jbi_dbg_lo_data_buf[18], iob_jbi_dbg_lo_data_buf[16], iob_jbi_dbg_lo_data_buf[14], iob_jbi_dbg_lo_data_buf[12], iob_jbi_dbg_lo_data_buf[10],
                                           iob_jbi_dbg_lo_data_buf[9],  iob_jbi_dbg_lo_data_buf[7],  iob_jbi_dbg_lo_data_buf[5],  iob_jbi_dbg_lo_data_buf[2],  iob_jbi_dbg_lo_data_buf[0],
                                           iob_jbi_dbg_hi_data_buf[47], iob_jbi_dbg_hi_data_buf[45], iob_jbi_dbg_hi_data_buf[43], iob_jbi_dbg_hi_data_buf[41], iob_jbi_dbg_hi_data_buf[39],
                                           iob_jbi_dbg_hi_data_buf[37], iob_jbi_dbg_hi_data_buf[35], iob_jbi_dbg_hi_data_buf[33], iob_jbi_dbg_hi_data_buf[31], iob_jbi_dbg_hi_data_buf[30],
                                           iob_jbi_dbg_hi_data_buf[29], iob_jbi_dbg_hi_data_buf[28], iob_jbi_dbg_hi_data_buf[27], iob_jbi_dbg_hi_data_buf[25], iob_jbi_dbg_hi_data_buf[23],
                                           iob_jbi_dbg_hi_data_buf[21], iob_jbi_dbg_hi_data_buf[19], iob_jbi_dbg_hi_data_buf[17], iob_jbi_dbg_hi_data_buf[16], iob_jbi_dbg_hi_data_buf[15],
                                           iob_jbi_dbg_hi_data_buf[14], iob_jbi_dbg_hi_data_buf[13], iob_jbi_dbg_hi_data_buf[12], iob_jbi_dbg_hi_data_buf[11], iob_jbi_dbg_hi_data_buf[10],
                                           iob_jbi_dbg_hi_data_buf[9],  iob_jbi_dbg_hi_data_buf[8],  iob_jbi_dbg_hi_data_buf[7],  iob_jbi_dbg_hi_data_buf[6],  iob_jbi_dbg_hi_data_buf[5],
                                           iob_jbi_dbg_hi_data_buf[4],  iob_jbi_dbg_hi_data_buf[3],  iob_jbi_spi_data_buf[3],     iob_jbi_spi_data_buf[1],     iob_jbi_pio_data_buf[63],
                                           iob_jbi_pio_data_buf[61],    iob_jbi_pio_data_buf[60],    iob_jbi_pio_data_buf[59],    iob_jbi_pio_data_buf[58],    iob_jbi_pio_data_buf[57],
                                           iob_jbi_pio_data_buf[56],    iob_jbi_pio_data_buf[55],    iob_jbi_pio_data_buf[54],    iob_jbi_pio_data_buf[53],    iob_jbi_pio_data_buf[52],
                                           iob_jbi_pio_data_buf[51],    iob_jbi_pio_data_buf[50],    iob_jbi_dbg_hi_data_buf[2],  iob_jbi_dbg_hi_data_buf[1],  iob_jbi_dbg_hi_data_buf[0],
                                           iob_jbi_pio_data_buf[62],    iob_jbi_spi_data_buf[0],     iob_jbi_spi_data_buf[2],     iob_jbi_dbg_hi_data_buf[18], iob_jbi_dbg_hi_data_buf[20],
                                           iob_jbi_dbg_hi_data_buf[22], iob_jbi_dbg_hi_data_buf[24], iob_jbi_dbg_hi_data_buf[26], iob_jbi_dbg_hi_data_buf[32], iob_jbi_dbg_hi_data_buf[34],
                                           iob_jbi_dbg_hi_data_buf[36], iob_jbi_dbg_hi_data_buf[38], iob_jbi_dbg_hi_data_buf[40], iob_jbi_dbg_hi_data_buf[42], iob_jbi_dbg_hi_data_buf[44],
                                           iob_jbi_dbg_hi_data_buf[46], iob_jbi_dbg_lo_data_buf[1],  iob_jbi_dbg_lo_data_buf[3],  iob_jbi_dbg_lo_data_buf[4],  iob_jbi_dbg_lo_data_buf[6],
                                           iob_jbi_dbg_lo_data_buf[8],  iob_jbi_dbg_lo_data_buf[11], iob_jbi_dbg_lo_data_buf[13], iob_jbi_dbg_lo_data_buf[15], iob_jbi_dbg_lo_data_buf[17],
                                           iob_jbi_dbg_lo_data_buf[19], iob_jbi_dbg_lo_data_buf[21], iob_jbi_dbg_lo_data_buf[23], iob_jbi_dbg_lo_data_buf[25], iob_jbi_dbg_lo_data_buf[27],
                                           iob_jbi_dbg_lo_data_buf[29], iob_jbi_dbg_lo_data_buf[31], iob_jbi_dbg_lo_data_buf[33], iob_jbi_dbg_lo_data_buf[35], iob_jbi_dbg_lo_data_buf[36],
                                           iob_jbi_dbg_lo_data_buf[38], iob_jbi_dbg_lo_data_buf[40], iob_jbi_dbg_lo_data_buf[42], iob_jbi_dbg_lo_data_buf[44], iob_jbi_dbg_lo_data_buf[46],
                                           iob_jbi_pio_data_buf[2],     iob_jbi_pio_data_buf[4],     iob_jbi_pio_data_buf[6],     iob_jbi_pio_data_buf[8],     iob_jbi_pio_data_buf[10],
                                           iob_jbi_pio_data_buf[12],    iob_jbi_pio_data_buf[14],    iob_jbi_pio_data_buf[16],    iob_jbi_pio_data_buf[18],    iob_jbi_pio_data_buf[20],
                                           iob_jbi_pio_data_buf[22],    iob_jbi_pio_data_buf[24],    iob_jbi_pio_data_buf[26],    iob_jbi_pio_data_buf[28],    iob_jbi_pio_data_buf[30],
                                           iob_jbi_pio_data_buf[32],    iob_jbi_pio_data_buf[34],    iob_jbi_pio_data_buf[36],    iob_jbi_pio_data_buf[38],    iob_jbi_pio_data_buf[40],
                                           iob_jbi_pio_data_buf[42],    iob_jbi_pio_data_buf[44],    iob_jbi_pio_data_buf[46],    iob_jbi_pio_data_buf[48]                                 }));

   iob_jbi_rptr_1 iob_jbi_rptr_1 (
        .sig                            ({ jbi_iob_spi_stall,         jbi_iob_spi_data[2],        jbi_iob_spi_data[0],       jbi_iob_pio_stall,         jbi_iob_pio_data[14],
                                           jbi_iob_pio_data[12],      jbi_iob_pio_data[10],       jbi_iob_pio_data[8],       jbi_iob_pio_data[6],       jbi_iob_pio_data[4],
                                           jbi_iob_pio_data[2],       jbi_iob_pio_data[0],        jbi_iob_mondo_data[7],     jbi_iob_mondo_data[5],     jbi_iob_mondo_data[3],
                                           jbi_iob_mondo_data[1],     iob_jbi_mondo_ack,          iob_jbi_spi_vld,           iob_jbi_pio_vld,           iob_jbi_pio_stall, 
                                           iob_jbi_spi_stall,         iob_jbi_dbg_hi_vld,         iob_jbi_dbg_lo_vld,        iob_jbi_mondo_nack,        jbi_iob_mondo_data[0], 
                                           jbi_iob_mondo_data[2],     jbi_iob_mondo_data[4],      jbi_iob_mondo_data[6],     jbi_iob_mondo_vld,         jbi_iob_pio_data[1], 
                                           jbi_iob_pio_data[3],       jbi_iob_pio_data[5],        jbi_iob_pio_data[7],       jbi_iob_pio_data[9],       jbi_iob_pio_data[11], 
                                           jbi_iob_pio_data[13],      jbi_iob_pio_data[15],       jbi_iob_pio_vld,           jbi_iob_spi_data[1],       jbi_iob_spi_data[3], 
                                           jbi_iob_spi_vld,           unused_iob_jbi_rptr_1i[94:0]                                                                                }),
        .sig_buf                        ({ jbi_iob_spi_stall_buf,     jbi_iob_spi_data_buf[2],    jbi_iob_spi_data_buf[0],   jbi_iob_pio_stall_buf,     jbi_iob_pio_data_buf[14],
                                           jbi_iob_pio_data_buf[12],  jbi_iob_pio_data_buf[10],   jbi_iob_pio_data_buf[8],   jbi_iob_pio_data_buf[6],   jbi_iob_pio_data_buf[4],
                                           jbi_iob_pio_data_buf[2],   jbi_iob_pio_data_buf[0],    jbi_iob_mondo_data_buf[7], jbi_iob_mondo_data_buf[5], jbi_iob_mondo_data_buf[3],
                                           jbi_iob_mondo_data_buf[1], iob_jbi_mondo_ack_buf,      iob_jbi_spi_vld_buf,       iob_jbi_pio_vld_buf,       iob_jbi_pio_stall_buf, 
                                           iob_jbi_spi_stall_buf,     iob_jbi_dbg_hi_vld_buf,     iob_jbi_dbg_lo_vld_buf,    iob_jbi_mondo_nack_buf,    jbi_iob_mondo_data_buf[0], 
                                           jbi_iob_mondo_data_buf[2], jbi_iob_mondo_data_buf[4],  jbi_iob_mondo_data_buf[6], jbi_iob_mondo_vld_buf,     jbi_iob_pio_data_buf[1], 
                                           jbi_iob_pio_data_buf[3],   jbi_iob_pio_data_buf[5],    jbi_iob_pio_data_buf[7],   jbi_iob_pio_data_buf[9],   jbi_iob_pio_data_buf[11], 
                                           jbi_iob_pio_data_buf[13],  jbi_iob_pio_data_buf[15],   jbi_iob_pio_vld_buf,       jbi_iob_spi_data_buf[1],   jbi_iob_spi_data_buf[3], 
                                           jbi_iob_spi_vld_buf,       unused_iob_jbi_rptr_1[94:0]                                                                                 }));
//


/* dram AUTO_TEMPLATE (
    .dram_si				(par_scan_head[0]),
    .dram_so				(par_scan_tail[0]),

    .jbus_gclk				(jbus_gclk_c1_r[3]),
    .dram_gclk				(dram_gclk_c1_r[3]),
    .cmp_gclk				(cmp_gclk_c1_r[3]),
    .cmp_grst_l                         (rpt_cmp_grst_l_c@"(+ 1 (* 6 (% @ 2)))"),
    .cmp_gdbginit_l                     (rpt_cmp_gdbginit_l_c@"(+ 1 (* 6 (% @ 2)))"),
    .clspine_\(.*\)_sync                (rpt_cmp_\1_sync_c@"(+ 1 (* 6 (% @ 2)))"),
    .clk_dram_cmp_cken                  (rpt_dram@"(/ @ 10)"@"(% @ 10)"_cmp_cken),
    .clk_dram_dram_cken                 (ctu_dram@"(/ @ 10)"@"(% @ 10)"_dram_cken),
    .clk_dram_jbus_cken                 (ctu_dram@"(/ @ 10)"@"(% @ 10)"_jbus_cken),

    .clspine_dram_selfrsh               (ctu_dram_selfrsh),

    .dram_clk_tr                        (dram@_ctu_tr),
    .dram_pad_ddr\([01]\)\(.*\)         (dram@_pad_ddr@"(+ (/ @ 10) (* \1 2))"\2[]),

    .dram_pt_\(.*\)                     (dram_pt@_\1[]),
    .dram_other_pt_\(.*\)               (dram_pt@"(% (+ @ 1) 2)"@"(+ (% (+ @ 1) 2) 2)"_\1[]),
    .dram_other_pt\([01]\)_\(.*\)       (dram_pt@"(+ (% (+ @ 1) 2) (* 2 \1) )"_\2[]),
    .dram_local_pt\([01]\)_\(.*\)       (dram_pt@"(+ (%    @    2) (* 2 \1) )"_\2[]),

    .dram_sctag\([01]\)\(.*\)           (dram@_sctag@"(+ (/ @ 10) (* \1 2))"\2[]),
    .sctag\([01]\)_dram\(.*\)           (sctag@"(+ (/ @ 10) (* \1 2))"_dram@\2_d1[]),

    .dram_scbuf\([01]\)\(.*\)           (dram@_scbuf@"(+ (/ @ 10) (* \1 2))"\2[]),
    .scbuf\([01]\)_dram\(.*\)           (scbuf@"(+ (/ @ 10) (* \1 2))"_dram@\2_d1[]),

    .dram\([01]\)_ddr\([01]\)\(.*\)     (dram@"(+ (/ @ 10) (* \1 2))"_ddr@"(+ (/ @ 10) (* \1 2))"\3[]),
    .ddr\([01]\)_dram\([01]\)\(.*\)     (ddr@"(+ (/ @ 10) (* \1 2))"_dram@"(+ (/ @ 10) (* \1 2))"\3[]),

    .ucb_iob\(.*\)                      (dram@_iob\1[]),
    .iob_ucb\(.*\)                      (iob_dram@\1[]),

    .pad\(.*\)                          (io_dram@\1[]),

    .dram_io\(.*\)\([0-1]\)\(.*\)       (dram@"(+ (/ @ 10) (* \2 2))"_io\1\3[]),
    .io_dram\(.*\)\([0-1]\)\(.*\)       (io_dram@"(+ (/ @ 10) (* \2 2))"\1\3_buf0[]),

    ); */
//
`ifdef RTL_DRAM02
   dram dram02
     (/*AUTOINST*/
      // Outputs
      .dram_io_addr0			(dram0_io_addr[14:0]),	 // Templated
      .dram_io_addr1			(dram2_io_addr[14:0]),	 // Templated
      .dram_io_bank0			(dram0_io_bank[2:0]),	 // Templated
      .dram_io_bank1			(dram2_io_bank[2:0]),	 // Templated
      .dram_io_cas0_l			(dram0_io_cas_l),	 // Templated
      .dram_io_cas1_l			(dram2_io_cas_l),	 // Templated
      .dram_io_channel_disabled0	(dram0_io_channel_disabled), // Templated
      .dram_io_channel_disabled1	(dram2_io_channel_disabled), // Templated
      .dram_io_cke0			(dram0_io_cke),		 // Templated
      .dram_io_cke1			(dram2_io_cke),		 // Templated
      .dram_io_clk_enable0		(dram0_io_clk_enable),	 // Templated
      .dram_io_clk_enable1		(dram2_io_clk_enable),	 // Templated
      .dram_io_cs0_l			(dram0_io_cs_l[3:0]),	 // Templated
      .dram_io_cs1_l			(dram2_io_cs_l[3:0]),	 // Templated
      .dram_io_data0_out		(dram0_io_data_out[287:0]), // Templated
      .dram_io_data1_out		(dram2_io_data_out[287:0]), // Templated
      .dram_io_drive_data0		(dram0_io_drive_data),	 // Templated
      .dram_io_drive_data1		(dram2_io_drive_data),	 // Templated
      .dram_io_drive_enable0		(dram0_io_drive_enable), // Templated
      .dram_io_drive_enable1		(dram2_io_drive_enable), // Templated
      .dram_io_pad_clk_inv0		(dram0_io_pad_clk_inv),	 // Templated
      .dram_io_pad_clk_inv1		(dram2_io_pad_clk_inv),	 // Templated
      .dram_io_pad_enable0		(dram0_io_pad_enable),	 // Templated
      .dram_io_pad_enable1		(dram2_io_pad_enable),	 // Templated
      .dram_io_ptr_clk_inv0		(dram0_io_ptr_clk_inv[4:0]), // Templated
      .dram_io_ptr_clk_inv1		(dram2_io_ptr_clk_inv[4:0]), // Templated
      .dram_io_ras0_l			(dram0_io_ras_l),	 // Templated
      .dram_io_ras1_l			(dram2_io_ras_l),	 // Templated
      .dram_io_write_en0_l		(dram0_io_write_en_l),	 // Templated
      .dram_io_write_en1_l		(dram2_io_write_en_l),	 // Templated
      .dram_sctag0_data_vld_r0		(dram02_sctag0_data_vld_r0), // Templated
      .dram_sctag0_rd_ack		(dram02_sctag0_rd_ack),	 // Templated
      .dram_sctag0_scb_mecc_err		(dram02_sctag0_scb_mecc_err), // Templated
      .dram_sctag0_scb_secc_err		(dram02_sctag0_scb_secc_err), // Templated
      .dram_sctag0_wr_ack		(dram02_sctag0_wr_ack),	 // Templated
      .dram_sctag1_data_vld_r0		(dram02_sctag2_data_vld_r0), // Templated
      .dram_sctag1_rd_ack		(dram02_sctag2_rd_ack),	 // Templated
      .dram_sctag1_scb_mecc_err		(dram02_sctag2_scb_mecc_err), // Templated
      .dram_sctag1_scb_secc_err		(dram02_sctag2_scb_secc_err), // Templated
      .dram_sctag1_wr_ack		(dram02_sctag2_wr_ack),	 // Templated
      .ucb_iob_data			(dram02_iob_data[3:0]),	 // Templated
      .ucb_iob_stall			(dram02_iob_stall),	 // Templated
      .ucb_iob_vld			(dram02_iob_vld),	 // Templated
      .dram_sctag0_chunk_id_r0		(dram02_sctag0_chunk_id_r0[1:0]), // Templated
      .dram_sctag0_mecc_err_r2		(dram02_sctag0_mecc_err_r2), // Templated
      .dram_sctag0_rd_req_id_r0		(dram02_sctag0_rd_req_id_r0[2:0]), // Templated
      .dram_sctag0_secc_err_r2		(dram02_sctag0_secc_err_r2), // Templated
      .dram_sctag1_chunk_id_r0		(dram02_sctag2_chunk_id_r0[1:0]), // Templated
      .dram_sctag1_mecc_err_r2		(dram02_sctag2_mecc_err_r2), // Templated
      .dram_sctag1_rd_req_id_r0		(dram02_sctag2_rd_req_id_r0[2:0]), // Templated
      .dram_sctag1_secc_err_r2		(dram02_sctag2_secc_err_r2), // Templated
      .dram_scbuf0_data_r2		(dram02_scbuf0_data_r2[127:0]), // Templated
      .dram_scbuf0_ecc_r2		(dram02_scbuf0_ecc_r2[27:0]), // Templated
      .dram_scbuf1_data_r2		(dram02_scbuf2_data_r2[127:0]), // Templated
      .dram_scbuf1_ecc_r2		(dram02_scbuf2_ecc_r2[27:0]), // Templated
      .dram_local_pt0_opened_bank	(dram_pt0_opened_bank),	 // Templated
      .dram_local_pt1_opened_bank	(dram_pt2_opened_bank),	 // Templated
      .dram_pt_max_banks_open_valid	(dram_pt02_max_banks_open_valid), // Templated
      .dram_pt_max_time_valid		(dram_pt02_max_time_valid), // Templated
      .dram_pt_ucb_data			(dram_pt02_ucb_data[16:0]), // Templated
      .dram_clk_tr			(dram02_ctu_tr),	 // Templated
      .dram_so				(par_scan_tail[0]),	 // Templated
      // Inputs
      .dram_other_pt_max_banks_open_valid(dram_pt13_max_banks_open_valid), // Templated
      .dram_other_pt_max_time_valid	(dram_pt13_max_time_valid), // Templated
      .dram_other_pt_ucb_data		(dram_pt13_ucb_data[16:0]), // Templated
      .dram_other_pt0_opened_bank	(dram_pt1_opened_bank),	 // Templated
      .dram_other_pt1_opened_bank	(dram_pt3_opened_bank),	 // Templated
      .io_dram0_data_in			(io_dram0_data_in_buf0[255:0]), // Templated
      .io_dram0_data_valid		(io_dram0_data_valid_buf0), // Templated
      .io_dram0_ecc_in			(io_dram0_ecc_in_buf0[31:0]), // Templated
      .io_dram1_data_in			(io_dram2_data_in_buf0[255:0]), // Templated
      .io_dram1_data_valid		(io_dram2_data_valid_buf0), // Templated
      .io_dram1_ecc_in			(io_dram2_ecc_in_buf0[31:0]), // Templated
      .iob_ucb_data			(iob_dram02_data[3:0]),	 // Templated
      .iob_ucb_stall			(iob_dram02_stall),	 // Templated
      .iob_ucb_vld			(iob_dram02_vld),	 // Templated
      .scbuf0_dram_data_mecc_r5		(scbuf0_dram02_data_mecc_r5_d1), // Templated
      .scbuf0_dram_data_vld_r5		(scbuf0_dram02_data_vld_r5_d1), // Templated
      .scbuf0_dram_wr_data_r5		(scbuf0_dram02_wr_data_r5_d1[63:0]), // Templated
      .scbuf1_dram_data_mecc_r5		(scbuf2_dram02_data_mecc_r5_d1), // Templated
      .scbuf1_dram_data_vld_r5		(scbuf2_dram02_data_vld_r5_d1), // Templated
      .scbuf1_dram_wr_data_r5		(scbuf2_dram02_wr_data_r5_d1[63:0]), // Templated
      .sctag0_dram_addr			(sctag0_dram02_addr_d1[39:5]), // Templated
      .sctag0_dram_rd_dummy_req		(sctag0_dram02_rd_dummy_req_d1), // Templated
      .sctag0_dram_rd_req		(sctag0_dram02_rd_req_d1), // Templated
      .sctag0_dram_rd_req_id		(sctag0_dram02_rd_req_id_d1[2:0]), // Templated
      .sctag0_dram_wr_req		(sctag0_dram02_wr_req_d1), // Templated
      .sctag1_dram_addr			(sctag2_dram02_addr_d1[39:5]), // Templated
      .sctag1_dram_rd_dummy_req		(sctag2_dram02_rd_dummy_req_d1), // Templated
      .sctag1_dram_rd_req		(sctag2_dram02_rd_req_d1), // Templated
      .sctag1_dram_rd_req_id		(sctag2_dram02_rd_req_id_d1[2:0]), // Templated
      .sctag1_dram_wr_req		(sctag2_dram02_wr_req_d1), // Templated
      .clspine_dram_rx_sync		(rpt_cmp_dram_rx_sync_c1), // Templated
      .clspine_dram_tx_sync		(rpt_cmp_dram_tx_sync_c1), // Templated
      .clspine_jbus_rx_sync		(rpt_cmp_jbus_rx_sync_c1), // Templated
      .clspine_jbus_tx_sync		(rpt_cmp_jbus_tx_sync_c1), // Templated
      .dram_gdbginit_l			(dram_gdbginit_l),
      .clk_dram_jbus_cken		(ctu_dram02_jbus_cken),	 // Templated
      .clk_dram_dram_cken		(ctu_dram02_dram_cken),	 // Templated
      .clk_dram_cmp_cken		(rpt_dram02_cmp_cken),	 // Templated
      .clspine_dram_selfrsh		(ctu_dram_selfrsh),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .dram_si				(par_scan_head[0]),	 // Templated
      .jbus_gclk			(jbus_gclk_c1_r[3]),	 // Templated
      .dram_gclk			(dram_gclk_c1_r[3]),	 // Templated
      .cmp_gclk				(cmp_gclk_c1_r[3]),	 // Templated
      .dram_adbginit_l			(dram_adbginit_l),
      .dram_arst_l			(dram_arst_l),
      .jbus_grst_l			(jbus_grst_l),
      .dram_grst_l			(dram_grst_l),
      .cmp_grst_l			(rpt_cmp_grst_l_c1),	 // Templated
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain));
`endif
//


/* dram AUTO_TEMPLATE (
    .dram_si				(par_scan_head[20]),
    .dram_so				(par_scan_tail[20]),

    .jbus_gclk				(jbus_gclk_c1_r[5]),
    .dram_gclk				(dram_gclk_c1_r[5]),
    .cmp_gclk				(cmp_gclk_c1_r[5]),
    .cmp_grst_l                         (rpt_cmp_grst_l_c6),
    .cmp_gdbginit_l                     (rpt_cmp_gdbginit_l_c@"(+ 1 (* 6 (% @ 2)))"),
    .clspine_dram_rx_sync		(rpt_cmp_dram_rx_sync_c6),
    .clspine_dram_tx_sync		(rpt_cmp_dram_tx_sync_c6),
    .clspine_jbus_rx_sync		(rpt_cmp_jbus_rx_sync_c6),
    .clspine_jbus_tx_sync		(rpt_cmp_jbus_tx_sync_c6),
    .clk_dram_cmp_cken                  (rpt_dram@"(/ @ 10)"@"(% @ 10)"_cmp_cken),
    .clk_dram_dram_cken                 (ctu_dram@"(/ @ 10)"@"(% @ 10)"_dram_cken),
    .clk_dram_jbus_cken                 (ctu_dram@"(/ @ 10)"@"(% @ 10)"_jbus_cken),

    .clspine_dram_selfrsh               (ctu_dram_selfrsh),

    .dram_clk_tr                        (dram@_ctu_tr),
    .dram_pad_ddr\([01]\)\(.*\)         (dram@_pad_ddr@"(+ (/ @ 10) (* \1 2))"\2[]),

    .dram_pt_\(.*\)                     (dram_pt@_\1[]),
    .dram_other_pt_\(.*\)               (dram_pt@"(% (+ @ 1) 2)"@"(+ (% (+ @ 1) 2) 2)"_\1[]),
    .dram_other_pt\([01]\)_\(.*\)       (dram_pt@"(+ (% (+ @ 1) 2) (* 2 \1) )"_\2[]),
    .dram_local_pt\([01]\)_\(.*\)       (dram_pt@"(+ (%    @    2) (* 2 \1) )"_\2[]),

    .dram_sctag\([01]\)\(.*\)           (dram@_sctag@"(+ (/ @ 10) (* \1 2))"\2[]),
    .sctag\([01]\)_dram\(.*\)           (sctag@"(+ (/ @ 10) (* \1 2))"_dram@\2_d1[]),

    .dram_scbuf\([01]\)\(.*\)           (dram@_scbuf@"(+ (/ @ 10) (* \1 2))"\2[]),
    .scbuf\([01]\)_dram\(.*\)           (scbuf@"(+ (/ @ 10) (* \1 2))"_dram@\2_d1[]),

    .dram\([01]\)_ddr\([01]\)\(.*\)     (dram@"(+ (/ @ 10) (* \1 2))"_ddr@"(+ (/ @ 10) (* \1 2))"\3[]),
    .ddr\([01]\)_dram\([01]\)\(.*\)     (ddr@"(+ (/ @ 10) (* \1 2))"_dram@"(+ (/ @ 10) (* \1 2))"\3[]),

    .ucb_iob\(.*\)                      (dram@_iob\1[]),
    .iob_ucb\(.*\)                      (iob_dram@\1[]),

    .pad\(.*\)                          (io_dram@\1[]),

    .dram_io\(.*\)\([0-1]\)\(.*\)       (dram@"(+ (/ @ 10) (* \2 2))"_io\1\3[]),
    .io_dram\(.*\)\([0-1]\)\(.*\)       (io_dram@"(+ (/ @ 10) (* \2 2))"\1\3_buf0[]),

    ); */
//
`ifdef RTL_DRAM13
   dram dram13
     (/*AUTOINST*/
      // Outputs
      .dram_io_addr0			(dram1_io_addr[14:0]),	 // Templated
      .dram_io_addr1			(dram3_io_addr[14:0]),	 // Templated
      .dram_io_bank0			(dram1_io_bank[2:0]),	 // Templated
      .dram_io_bank1			(dram3_io_bank[2:0]),	 // Templated
      .dram_io_cas0_l			(dram1_io_cas_l),	 // Templated
      .dram_io_cas1_l			(dram3_io_cas_l),	 // Templated
      .dram_io_channel_disabled0	(dram1_io_channel_disabled), // Templated
      .dram_io_channel_disabled1	(dram3_io_channel_disabled), // Templated
      .dram_io_cke0			(dram1_io_cke),		 // Templated
      .dram_io_cke1			(dram3_io_cke),		 // Templated
      .dram_io_clk_enable0		(dram1_io_clk_enable),	 // Templated
      .dram_io_clk_enable1		(dram3_io_clk_enable),	 // Templated
      .dram_io_cs0_l			(dram1_io_cs_l[3:0]),	 // Templated
      .dram_io_cs1_l			(dram3_io_cs_l[3:0]),	 // Templated
      .dram_io_data0_out		(dram1_io_data_out[287:0]), // Templated
      .dram_io_data1_out		(dram3_io_data_out[287:0]), // Templated
      .dram_io_drive_data0		(dram1_io_drive_data),	 // Templated
      .dram_io_drive_data1		(dram3_io_drive_data),	 // Templated
      .dram_io_drive_enable0		(dram1_io_drive_enable), // Templated
      .dram_io_drive_enable1		(dram3_io_drive_enable), // Templated
      .dram_io_pad_clk_inv0		(dram1_io_pad_clk_inv),	 // Templated
      .dram_io_pad_clk_inv1		(dram3_io_pad_clk_inv),	 // Templated
      .dram_io_pad_enable0		(dram1_io_pad_enable),	 // Templated
      .dram_io_pad_enable1		(dram3_io_pad_enable),	 // Templated
      .dram_io_ptr_clk_inv0		(dram1_io_ptr_clk_inv[4:0]), // Templated
      .dram_io_ptr_clk_inv1		(dram3_io_ptr_clk_inv[4:0]), // Templated
      .dram_io_ras0_l			(dram1_io_ras_l),	 // Templated
      .dram_io_ras1_l			(dram3_io_ras_l),	 // Templated
      .dram_io_write_en0_l		(dram1_io_write_en_l),	 // Templated
      .dram_io_write_en1_l		(dram3_io_write_en_l),	 // Templated
      .dram_sctag0_data_vld_r0		(dram13_sctag1_data_vld_r0), // Templated
      .dram_sctag0_rd_ack		(dram13_sctag1_rd_ack),	 // Templated
      .dram_sctag0_scb_mecc_err		(dram13_sctag1_scb_mecc_err), // Templated
      .dram_sctag0_scb_secc_err		(dram13_sctag1_scb_secc_err), // Templated
      .dram_sctag0_wr_ack		(dram13_sctag1_wr_ack),	 // Templated
      .dram_sctag1_data_vld_r0		(dram13_sctag3_data_vld_r0), // Templated
      .dram_sctag1_rd_ack		(dram13_sctag3_rd_ack),	 // Templated
      .dram_sctag1_scb_mecc_err		(dram13_sctag3_scb_mecc_err), // Templated
      .dram_sctag1_scb_secc_err		(dram13_sctag3_scb_secc_err), // Templated
      .dram_sctag1_wr_ack		(dram13_sctag3_wr_ack),	 // Templated
      .ucb_iob_data			(dram13_iob_data[3:0]),	 // Templated
      .ucb_iob_stall			(dram13_iob_stall),	 // Templated
      .ucb_iob_vld			(dram13_iob_vld),	 // Templated
      .dram_sctag0_chunk_id_r0		(dram13_sctag1_chunk_id_r0[1:0]), // Templated
      .dram_sctag0_mecc_err_r2		(dram13_sctag1_mecc_err_r2), // Templated
      .dram_sctag0_rd_req_id_r0		(dram13_sctag1_rd_req_id_r0[2:0]), // Templated
      .dram_sctag0_secc_err_r2		(dram13_sctag1_secc_err_r2), // Templated
      .dram_sctag1_chunk_id_r0		(dram13_sctag3_chunk_id_r0[1:0]), // Templated
      .dram_sctag1_mecc_err_r2		(dram13_sctag3_mecc_err_r2), // Templated
      .dram_sctag1_rd_req_id_r0		(dram13_sctag3_rd_req_id_r0[2:0]), // Templated
      .dram_sctag1_secc_err_r2		(dram13_sctag3_secc_err_r2), // Templated
      .dram_scbuf0_data_r2		(dram13_scbuf1_data_r2[127:0]), // Templated
      .dram_scbuf0_ecc_r2		(dram13_scbuf1_ecc_r2[27:0]), // Templated
      .dram_scbuf1_data_r2		(dram13_scbuf3_data_r2[127:0]), // Templated
      .dram_scbuf1_ecc_r2		(dram13_scbuf3_ecc_r2[27:0]), // Templated
      .dram_local_pt0_opened_bank	(dram_pt1_opened_bank),	 // Templated
      .dram_local_pt1_opened_bank	(dram_pt3_opened_bank),	 // Templated
      .dram_pt_max_banks_open_valid	(dram_pt13_max_banks_open_valid), // Templated
      .dram_pt_max_time_valid		(dram_pt13_max_time_valid), // Templated
      .dram_pt_ucb_data			(dram_pt13_ucb_data[16:0]), // Templated
      .dram_clk_tr			(dram13_ctu_tr),	 // Templated
      .dram_so				(par_scan_tail[20]),	 // Templated
      // Inputs
      .dram_other_pt_max_banks_open_valid(dram_pt02_max_banks_open_valid), // Templated
      .dram_other_pt_max_time_valid	(dram_pt02_max_time_valid), // Templated
      .dram_other_pt_ucb_data		(dram_pt02_ucb_data[16:0]), // Templated
      .dram_other_pt0_opened_bank	(dram_pt0_opened_bank),	 // Templated
      .dram_other_pt1_opened_bank	(dram_pt2_opened_bank),	 // Templated
      .io_dram0_data_in			(io_dram1_data_in_buf0[255:0]), // Templated
      .io_dram0_data_valid		(io_dram1_data_valid_buf0), // Templated
      .io_dram0_ecc_in			(io_dram1_ecc_in_buf0[31:0]), // Templated
      .io_dram1_data_in			(io_dram3_data_in_buf0[255:0]), // Templated
      .io_dram1_data_valid		(io_dram3_data_valid_buf0), // Templated
      .io_dram1_ecc_in			(io_dram3_ecc_in_buf0[31:0]), // Templated
      .iob_ucb_data			(iob_dram13_data[3:0]),	 // Templated
      .iob_ucb_stall			(iob_dram13_stall),	 // Templated
      .iob_ucb_vld			(iob_dram13_vld),	 // Templated
      .scbuf0_dram_data_mecc_r5		(scbuf1_dram13_data_mecc_r5_d1), // Templated
      .scbuf0_dram_data_vld_r5		(scbuf1_dram13_data_vld_r5_d1), // Templated
      .scbuf0_dram_wr_data_r5		(scbuf1_dram13_wr_data_r5_d1[63:0]), // Templated
      .scbuf1_dram_data_mecc_r5		(scbuf3_dram13_data_mecc_r5_d1), // Templated
      .scbuf1_dram_data_vld_r5		(scbuf3_dram13_data_vld_r5_d1), // Templated
      .scbuf1_dram_wr_data_r5		(scbuf3_dram13_wr_data_r5_d1[63:0]), // Templated
      .sctag0_dram_addr			(sctag1_dram13_addr_d1[39:5]), // Templated
      .sctag0_dram_rd_dummy_req		(sctag1_dram13_rd_dummy_req_d1), // Templated
      .sctag0_dram_rd_req		(sctag1_dram13_rd_req_d1), // Templated
      .sctag0_dram_rd_req_id		(sctag1_dram13_rd_req_id_d1[2:0]), // Templated
      .sctag0_dram_wr_req		(sctag1_dram13_wr_req_d1), // Templated
      .sctag1_dram_addr			(sctag3_dram13_addr_d1[39:5]), // Templated
      .sctag1_dram_rd_dummy_req		(sctag3_dram13_rd_dummy_req_d1), // Templated
      .sctag1_dram_rd_req		(sctag3_dram13_rd_req_d1), // Templated
      .sctag1_dram_rd_req_id		(sctag3_dram13_rd_req_id_d1[2:0]), // Templated
      .sctag1_dram_wr_req		(sctag3_dram13_wr_req_d1), // Templated
      .clspine_dram_rx_sync		(rpt_cmp_dram_rx_sync_c6), // Templated
      .clspine_dram_tx_sync		(rpt_cmp_dram_tx_sync_c6), // Templated
      .clspine_jbus_rx_sync		(rpt_cmp_jbus_rx_sync_c6), // Templated
      .clspine_jbus_tx_sync		(rpt_cmp_jbus_tx_sync_c6), // Templated
      .dram_gdbginit_l			(dram_gdbginit_l),
      .clk_dram_jbus_cken		(ctu_dram13_jbus_cken),	 // Templated
      .clk_dram_dram_cken		(ctu_dram13_dram_cken),	 // Templated
      .clk_dram_cmp_cken		(rpt_dram13_cmp_cken),	 // Templated
      .clspine_dram_selfrsh		(ctu_dram_selfrsh),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .dram_si				(par_scan_head[20]),	 // Templated
      .jbus_gclk			(jbus_gclk_c1_r[5]),	 // Templated
      .dram_gclk			(dram_gclk_c1_r[5]),	 // Templated
      .cmp_gclk				(cmp_gclk_c1_r[5]),	 // Templated
      .dram_adbginit_l			(dram_adbginit_l),
      .dram_arst_l			(dram_arst_l),
      .jbus_grst_l			(jbus_grst_l),
      .dram_grst_l			(dram_grst_l),
      .cmp_grst_l			(rpt_cmp_grst_l_c6),	 // Templated
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain));
`endif
//


/* scbuf AUTO_TEMPLATE (
    .cmp_gclk				(cmp_gclk_c0_r[3]),
    .arst_l                             (cmp_arst_l),

    .grst_l                             (rpt_cmp_grst_l_c@"(+ 3 (* 4 (% @ 2)))"),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c@"(+ 3 (* 4 (% @ 2)))"),
    .cluster_cken                       (rpt_scbuf@_cmp_cken),

    .si					(par_scan_head[7]),
    .so					(scbuf0_scdata0_scanout),

    .ctu_scbuf\(.*\)                    (ctu_scbuf@\1[]),
    .scbuf_ctu\(.*\)                    (scbuf@_ctu\1[]),

    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf3[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),

    .scdata_scbuf\(.*\)                 (scdata@_scbuf@\1[]),
    .scbuf_scdata\(.*\)                 (scbuf@_scdata@\1[]),

    .sctag_scbuf\(.*\)                  (sctag@_scbuf@\1_buf[]),
    .scbuf_sctag\(.*\)                  (scbuf@_sctag@\1[]),

    .jbi_scbuf\(.*\)                    (jbi_scbuf@\1_d2_buf1[]),
    .scbuf_jbi\(.*\)                    (scbuf@_jbi\1[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .jbi_sctag\(.*\)                    (jbi_sctag@\1_d2_buf1[]),

    ); */
//
`ifdef RTL_SCBUF0
   scbuf scbuf0
     (/*AUTOINST*/
      // Outputs
      .scbuf_sctag_ev_uerr_r5		(scbuf0_sctag0_ev_uerr_r5), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf0_sctag0_ev_cerr_r5), // Templated
      .scbuf_jbi_ctag_vld		(scbuf0_jbi_ctag_vld),	 // Templated
      .scbuf_jbi_data			(scbuf0_jbi_data[31:0]), // Templated
      .scbuf_jbi_ue_err			(scbuf0_jbi_ue_err),	 // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf0_sctag0_rdma_uerr_c10), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf0_sctag0_rdma_cerr_c10), // Templated
      .scbuf_scdata_fbdecc_c4		(scbuf0_scdata0_fbdecc_c4[623:0]), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf0_dram02_data_mecc_r5), // Templated
      .scbuf_dram_wr_data_r5		(scbuf0_dram02_wr_data_r5[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf0_dram02_data_vld_r5), // Templated
      .so				(scbuf0_scdata0_scanout), // Templated
      // Inputs
      .sctag_scbuf_fbrd_en_c3		(sctag0_scbuf0_fbrd_en_c3_buf), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag0_scbuf0_fbrd_wl_c3_buf[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag0_scbuf0_fbwr_wen_r2_buf[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag0_scbuf0_fbwr_wl_r2_buf[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag0_scbuf0_fbd_stdatasel_c3_buf), // Templated
      .sctag_scbuf_stdecc_c3		(sctag0_scbuf0_stdecc_c3_buf[77:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag0_scbuf0_evict_en_r0_buf), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag0_scbuf0_wbwr_wen_c6_buf[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag0_scbuf0_wbwr_wl_c6_buf[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag0_scbuf0_wbrd_en_r0_buf), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag0_scbuf0_wbrd_wl_r0_buf[2:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag0_scbuf0_ev_dword_r0_buf[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag0_scbuf0_rdma_wren_s2_buf[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag0_scbuf0_rdma_wrwl_s2_buf[1:0]), // Templated
      .jbi_sctag_req			(jbi_sctag0_req_d2_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf0_ecc_d2_buf1[6:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag0_scbuf0_rdma_rden_r0_buf), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag0_scbuf0_rdma_rdwl_r0_buf[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag0_scbuf0_ctag_en_c7_buf), // Templated
      .sctag_scbuf_ctag_c7		(sctag0_scbuf0_ctag_c7_buf[14:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag0_scbuf0_req_en_c7_buf), // Templated
      .sctag_scbuf_word_c7		(sctag0_scbuf0_word_c7_buf[3:0]), // Templated
      .sctag_scbuf_word_vld_c7		(sctag0_scbuf0_word_vld_c7_buf), // Templated
      .scdata_scbuf_decc_out_c7		(scdata0_scbuf0_decc_out_c7[623:0]), // Templated
      .dram_scbuf_data_r2		(dram02_scbuf0_data_r2_buf3[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf0_ecc_r2_buf3[27:0]), // Templated
      .cmp_gclk				(cmp_gclk_c0_r[3]),	 // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c3),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .si				(par_scan_head[7]),	 // Templated
      .cluster_cken			(rpt_scbuf0_cmp_cken),	 // Templated
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain));
`endif
//


/* scbuf AUTO_TEMPLATE (
    .cmp_gclk				(cmp_gclk_c0_r[4]),
    .arst_l                             (cmp_arst_l),

    .grst_l				(rpt_cmp_grst_l_c3),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c@"(+ 3 (* 4 (% @ 2)))"),
    .cluster_cken                       (rpt_scbuf@_cmp_cken),

    .si					(par_scan_head[8]),
    .so					(scbuf1_scdata1_scanout),

    .ctu_scbuf\(.*\)                    (ctu_scbuf@\1[]),
    .scbuf_ctu\(.*\)                    (scbuf@_ctu\1[]),

    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf3[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),

    .scdata_scbuf\(.*\)                 (scdata@_scbuf@\1[]),
    .scbuf_scdata\(.*\)                 (scbuf@_scdata@\1[]),

    .sctag_scbuf\(.*\)                  (sctag@_scbuf@\1_buf[]),
    .scbuf_sctag\(.*\)                  (scbuf@_sctag@\1[]),

    .jbi_scbuf\(.*\)                    (jbi_scbuf@\1_d2_buf1[]),
    .scbuf_jbi\(.*\)                    (scbuf@_jbi\1[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .jbi_sctag\(.*\)                    (jbi_sctag@\1_d2_buf1[]),

    ); */
//
`ifdef RTL_SCBUF1
   scbuf scbuf1
     (/*AUTOINST*/
      // Outputs
      .scbuf_sctag_ev_uerr_r5		(scbuf1_sctag1_ev_uerr_r5), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf1_sctag1_ev_cerr_r5), // Templated
      .scbuf_jbi_ctag_vld		(scbuf1_jbi_ctag_vld),	 // Templated
      .scbuf_jbi_data			(scbuf1_jbi_data[31:0]), // Templated
      .scbuf_jbi_ue_err			(scbuf1_jbi_ue_err),	 // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf1_sctag1_rdma_uerr_c10), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf1_sctag1_rdma_cerr_c10), // Templated
      .scbuf_scdata_fbdecc_c4		(scbuf1_scdata1_fbdecc_c4[623:0]), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf1_dram13_data_mecc_r5), // Templated
      .scbuf_dram_wr_data_r5		(scbuf1_dram13_wr_data_r5[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf1_dram13_data_vld_r5), // Templated
      .so				(scbuf1_scdata1_scanout), // Templated
      // Inputs
      .sctag_scbuf_fbrd_en_c3		(sctag1_scbuf1_fbrd_en_c3_buf), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag1_scbuf1_fbrd_wl_c3_buf[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag1_scbuf1_fbwr_wen_r2_buf[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag1_scbuf1_fbwr_wl_r2_buf[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag1_scbuf1_fbd_stdatasel_c3_buf), // Templated
      .sctag_scbuf_stdecc_c3		(sctag1_scbuf1_stdecc_c3_buf[77:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag1_scbuf1_evict_en_r0_buf), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag1_scbuf1_wbwr_wen_c6_buf[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag1_scbuf1_wbwr_wl_c6_buf[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag1_scbuf1_wbrd_en_r0_buf), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag1_scbuf1_wbrd_wl_r0_buf[2:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag1_scbuf1_ev_dword_r0_buf[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag1_scbuf1_rdma_wren_s2_buf[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag1_scbuf1_rdma_wrwl_s2_buf[1:0]), // Templated
      .jbi_sctag_req			(jbi_sctag1_req_d2_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf1_ecc_d2_buf1[6:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag1_scbuf1_rdma_rden_r0_buf), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag1_scbuf1_rdma_rdwl_r0_buf[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag1_scbuf1_ctag_en_c7_buf), // Templated
      .sctag_scbuf_ctag_c7		(sctag1_scbuf1_ctag_c7_buf[14:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag1_scbuf1_req_en_c7_buf), // Templated
      .sctag_scbuf_word_c7		(sctag1_scbuf1_word_c7_buf[3:0]), // Templated
      .sctag_scbuf_word_vld_c7		(sctag1_scbuf1_word_vld_c7_buf), // Templated
      .scdata_scbuf_decc_out_c7		(scdata1_scbuf1_decc_out_c7[623:0]), // Templated
      .dram_scbuf_data_r2		(dram13_scbuf1_data_r2_buf3[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf1_ecc_r2_buf3[27:0]), // Templated
      .cmp_gclk				(cmp_gclk_c0_r[4]),	 // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c3),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .si				(par_scan_head[8]),	 // Templated
      .cluster_cken			(rpt_scbuf1_cmp_cken),	 // Templated
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain));
`endif
//


/* scbuf AUTO_TEMPLATE (
    .cmp_gclk				(cmp_gclk_c3_r[3]),
    .arst_l                             (cmp_arst_l),

    .grst_l				(rpt_cmp_grst_l_c6),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c@"(+ 3 (* 4 (% @ 2)))"),
    .cluster_cken                       (rpt_scbuf@_cmp_cken),

    .si					(par_scan_head[23]),
    .so					(scbuf2_scdata2_scanout),

    .ctu_scbuf\(.*\)                    (ctu_scbuf@\1[]),
    .scbuf_ctu\(.*\)                    (scbuf@_ctu\1[]),

    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf3[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),

    .scdata_scbuf\(.*\)                 (scdata@_scbuf@\1[]),
    .scbuf_scdata\(.*\)                 (scbuf@_scdata@\1[]),

    .sctag_scbuf\(.*\)                  (sctag@_scbuf@\1_buf[]),
    .scbuf_sctag\(.*\)                  (scbuf@_sctag@\1[]),

    .jbi_scbuf\(.*\)                    (jbi_scbuf@\1_d2_buf1[]),
    .scbuf_jbi\(.*\)                    (scbuf@_jbi\1[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .jbi_sctag\(.*\)                    (jbi_sctag@\1_d2_buf1[]),

    ); */
//
`ifdef RTL_SCBUF2
   scbuf scbuf2
     (/*AUTOINST*/
      // Outputs
      .scbuf_sctag_ev_uerr_r5		(scbuf2_sctag2_ev_uerr_r5), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf2_sctag2_ev_cerr_r5), // Templated
      .scbuf_jbi_ctag_vld		(scbuf2_jbi_ctag_vld),	 // Templated
      .scbuf_jbi_data			(scbuf2_jbi_data[31:0]), // Templated
      .scbuf_jbi_ue_err			(scbuf2_jbi_ue_err),	 // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf2_sctag2_rdma_uerr_c10), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf2_sctag2_rdma_cerr_c10), // Templated
      .scbuf_scdata_fbdecc_c4		(scbuf2_scdata2_fbdecc_c4[623:0]), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf2_dram02_data_mecc_r5), // Templated
      .scbuf_dram_wr_data_r5		(scbuf2_dram02_wr_data_r5[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf2_dram02_data_vld_r5), // Templated
      .so				(scbuf2_scdata2_scanout), // Templated
      // Inputs
      .sctag_scbuf_fbrd_en_c3		(sctag2_scbuf2_fbrd_en_c3_buf), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag2_scbuf2_fbrd_wl_c3_buf[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag2_scbuf2_fbwr_wen_r2_buf[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag2_scbuf2_fbwr_wl_r2_buf[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag2_scbuf2_fbd_stdatasel_c3_buf), // Templated
      .sctag_scbuf_stdecc_c3		(sctag2_scbuf2_stdecc_c3_buf[77:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag2_scbuf2_evict_en_r0_buf), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag2_scbuf2_wbwr_wen_c6_buf[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag2_scbuf2_wbwr_wl_c6_buf[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag2_scbuf2_wbrd_en_r0_buf), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag2_scbuf2_wbrd_wl_r0_buf[2:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag2_scbuf2_ev_dword_r0_buf[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag2_scbuf2_rdma_wren_s2_buf[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag2_scbuf2_rdma_wrwl_s2_buf[1:0]), // Templated
      .jbi_sctag_req			(jbi_sctag2_req_d2_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf2_ecc_d2_buf1[6:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag2_scbuf2_rdma_rden_r0_buf), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag2_scbuf2_rdma_rdwl_r0_buf[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag2_scbuf2_ctag_en_c7_buf), // Templated
      .sctag_scbuf_ctag_c7		(sctag2_scbuf2_ctag_c7_buf[14:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag2_scbuf2_req_en_c7_buf), // Templated
      .sctag_scbuf_word_c7		(sctag2_scbuf2_word_c7_buf[3:0]), // Templated
      .sctag_scbuf_word_vld_c7		(sctag2_scbuf2_word_vld_c7_buf), // Templated
      .scdata_scbuf_decc_out_c7		(scdata2_scbuf2_decc_out_c7[623:0]), // Templated
      .dram_scbuf_data_r2		(dram02_scbuf2_data_r2_buf3[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf2_ecc_r2_buf3[27:0]), // Templated
      .cmp_gclk				(cmp_gclk_c3_r[3]),	 // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c6),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .si				(par_scan_head[23]),	 // Templated
      .cluster_cken			(rpt_scbuf2_cmp_cken),	 // Templated
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain));
`endif
//


/* scbuf AUTO_TEMPLATE (
    .cmp_gclk				(cmp_gclk_c3_r[4]),
    .arst_l                             (cmp_arst_l),

    .grst_l				(rpt_cmp_grst_l_c6),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c@"(+ 3 (* 4 (% @ 2)))"),
    .cluster_cken                       (rpt_scbuf@_cmp_cken),

    .si					(par_scan_head[22]),
    .so					(scbuf3_scdata3_scanout),

    .ctu_scbuf\(.*\)                    (ctu_scbuf@\1[]),
    .scbuf_ctu\(.*\)                    (scbuf@_ctu\1[]),

    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf3[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),

    .scdata_scbuf\(.*\)                 (scdata@_scbuf@\1[]),
    .scbuf_scdata\(.*\)                 (scbuf@_scdata@\1[]),

    .sctag_scbuf\(.*\)                  (sctag@_scbuf@\1_buf[]),
    .scbuf_sctag\(.*\)                  (scbuf@_sctag@\1[]),

    .jbi_scbuf\(.*\)                    (jbi_scbuf@\1_d2_buf1[]),
    .scbuf_jbi\(.*\)                    (scbuf@_jbi\1[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .jbi_sctag\(.*\)                    (jbi_sctag@\1_d2_buf1[]),

    ); */
//
`ifdef RTL_SCBUF3
   scbuf scbuf3
     (/*AUTOINST*/
      // Outputs
      .scbuf_sctag_ev_uerr_r5		(scbuf3_sctag3_ev_uerr_r5), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf3_sctag3_ev_cerr_r5), // Templated
      .scbuf_jbi_ctag_vld		(scbuf3_jbi_ctag_vld),	 // Templated
      .scbuf_jbi_data			(scbuf3_jbi_data[31:0]), // Templated
      .scbuf_jbi_ue_err			(scbuf3_jbi_ue_err),	 // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf3_sctag3_rdma_uerr_c10), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf3_sctag3_rdma_cerr_c10), // Templated
      .scbuf_scdata_fbdecc_c4		(scbuf3_scdata3_fbdecc_c4[623:0]), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf3_dram13_data_mecc_r5), // Templated
      .scbuf_dram_wr_data_r5		(scbuf3_dram13_wr_data_r5[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf3_dram13_data_vld_r5), // Templated
      .so				(scbuf3_scdata3_scanout), // Templated
      // Inputs
      .sctag_scbuf_fbrd_en_c3		(sctag3_scbuf3_fbrd_en_c3_buf), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag3_scbuf3_fbrd_wl_c3_buf[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag3_scbuf3_fbwr_wen_r2_buf[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag3_scbuf3_fbwr_wl_r2_buf[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag3_scbuf3_fbd_stdatasel_c3_buf), // Templated
      .sctag_scbuf_stdecc_c3		(sctag3_scbuf3_stdecc_c3_buf[77:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag3_scbuf3_evict_en_r0_buf), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag3_scbuf3_wbwr_wen_c6_buf[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag3_scbuf3_wbwr_wl_c6_buf[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag3_scbuf3_wbrd_en_r0_buf), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag3_scbuf3_wbrd_wl_r0_buf[2:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag3_scbuf3_ev_dword_r0_buf[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag3_scbuf3_rdma_wren_s2_buf[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag3_scbuf3_rdma_wrwl_s2_buf[1:0]), // Templated
      .jbi_sctag_req			(jbi_sctag3_req_d2_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf3_ecc_d2_buf1[6:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag3_scbuf3_rdma_rden_r0_buf), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag3_scbuf3_rdma_rdwl_r0_buf[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag3_scbuf3_ctag_en_c7_buf), // Templated
      .sctag_scbuf_ctag_c7		(sctag3_scbuf3_ctag_c7_buf[14:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag3_scbuf3_req_en_c7_buf), // Templated
      .sctag_scbuf_word_c7		(sctag3_scbuf3_word_c7_buf[3:0]), // Templated
      .sctag_scbuf_word_vld_c7		(sctag3_scbuf3_word_vld_c7_buf), // Templated
      .scdata_scbuf_decc_out_c7		(scdata3_scbuf3_decc_out_c7[623:0]), // Templated
      .dram_scbuf_data_r2		(dram13_scbuf3_data_r2_buf3[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf3_ecc_r2_buf3[27:0]), // Templated
      .cmp_gclk				(cmp_gclk_c3_r[4]),	 // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c6),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .si				(par_scan_head[22]),	 // Templated
      .cluster_cken			(rpt_scbuf3_cmp_cken),	 // Templated
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain));
`endif
//


/* scdata AUTO_TEMPLATE (
    .cmp_gclk				({cmp_gclk_c0_r[1],cmp_gclk_c0_r[2]}),
    .arst_l                             (cmp_arst_l),

    .grst_l                             (rpt_cmp_grst_l_c@"(+ 1 (% @ 2) (* 4 (/ @ 2)))"),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c@"(+ 1 (% @ 2) (* 4 (/ @ 2)))"),
    .cluster_cken                       (rpt_scdata@_cmp_cken),

    .si					(scbuf0_scdata0_scanout),
    .so					(par_scan_tail[7]),

    .efc_scdata_fuse_ashift             (efc_scdata@_fuse_ashift),
    .efc_scdata_fuse_dshift             (efc_scdata@_fuse_dshift),
    .efc_scdata\(.*\)                   (efc_scdata@"(% @ 2)"@"(+ (% @ 2) 2)"\1),
    .scdata_efc\(.*\)                   (scdata@_efc\1),

    .ctu_scdata\(.*\)                   (ctu_scdata@\1[]),
    .scdata_ctu\(.*\)                   (scdata@_ctu\1[]),

    .scbuf_scdata\(.*\)                 (scbuf@_scdata@\1[]),
    .scdata_scbuf\(.*\)                 (scdata@_scbuf@\1[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .scdata_sctag\(.*\)                 (scdata@_sctag@\1[]),
    ); */
//
`ifdef RTL_SCDATA0
   scdata scdata0
     (/*AUTOINST*/
      // Outputs
      .so				(par_scan_tail[7]),	 // Templated
      .scdata_efc_fuse_data		(scdata0_efc_fuse_data), // Templated
      .scdata_scbuf_decc_out_c7		(scdata0_scbuf0_decc_out_c7[623:0]), // Templated
      .scdata_sctag_decc_c6		(scdata0_sctag0_decc_c6[155:0]), // Templated
      // Inputs
      .cmp_gclk				({cmp_gclk_c0_r[1],cmp_gclk_c0_r[2]}), // Templated
      .global_shift_enable		(global_shift_enable),
      .si				(scbuf0_scdata0_scanout), // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c1),	 // Templated
      .cluster_cken			(rpt_scdata0_cmp_cken),	 // Templated
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .efc_scdata_fuse_ashift		(efc_scdata0_fuse_ashift), // Templated
      .efc_scdata_fuse_clk1		(efc_scdata02_fuse_clk1), // Templated
      .efc_scdata_fuse_clk2		(efc_scdata02_fuse_clk2), // Templated
      .efc_scdata_fuse_data		(efc_scdata02_fuse_data), // Templated
      .efc_scdata_fuse_dshift		(efc_scdata0_fuse_dshift), // Templated
      .scbuf_scdata_fbdecc_c4		(scbuf0_scdata0_fbdecc_c4[623:0]), // Templated
      .sctag_scdata_col_offset_c2	(sctag0_scdata0_col_offset_c2[3:0]), // Templated
      .sctag_scdata_fb_hit_c3		(sctag0_scdata0_fb_hit_c3), // Templated
      .sctag_scdata_fbrd_c3		(sctag0_scdata0_fbrd_c3), // Templated
      .sctag_scdata_rd_wr_c2		(sctag0_scdata0_rd_wr_c2), // Templated
      .sctag_scdata_set_c2		(sctag0_scdata0_set_c2[9:0]), // Templated
      .sctag_scdata_stdecc_c2		(sctag0_scdata0_stdecc_c2[77:0]), // Templated
      .sctag_scdata_way_sel_c2		(sctag0_scdata0_way_sel_c2[11:0]), // Templated
      .sctag_scdata_word_en_c2		(sctag0_scdata0_word_en_c2[15:0])); // Templated
`endif
//


/* scdata AUTO_TEMPLATE (
    .cmp_gclk				({cmp_gclk_c0_r[6],cmp_gclk_c0_r[5]}),
    .arst_l                             (cmp_arst_l),

    .grst_l				(rpt_cmp_grst_l_c4),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c@"(+ 1 (% @ 2) (* 4 (/ @ 2)))"),
    .cluster_cken                       (rpt_scdata@_cmp_cken),

    .si					(scbuf1_scdata1_scanout),
    .so					(par_scan_tail[8]),

    .efc_scdata_fuse_ashift             (efc_scdata@_fuse_ashift),
    .efc_scdata_fuse_dshift             (efc_scdata@_fuse_dshift),
    .efc_scdata\(.*\)                   (efc_scdata@"(% @ 2)"@"(+ (% @ 2) 2)"\1),
    .scdata_efc\(.*\)                   (scdata@_efc\1),

    .ctu_scdata\(.*\)                   (ctu_scdata@\1[]),
    .scdata_ctu\(.*\)                   (scdata@_ctu\1[]),

    .scbuf_scdata\(.*\)                 (scbuf@_scdata@\1[]),
    .scdata_scbuf\(.*\)                 (scdata@_scbuf@\1[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .scdata_sctag\(.*\)                 (scdata@_sctag@\1[]),
    ); */
//
`ifdef RTL_SCDATA1
   scdata scdata1
     (/*AUTOINST*/
      // Outputs
      .so				(par_scan_tail[8]),	 // Templated
      .scdata_efc_fuse_data		(scdata1_efc_fuse_data), // Templated
      .scdata_scbuf_decc_out_c7		(scdata1_scbuf1_decc_out_c7[623:0]), // Templated
      .scdata_sctag_decc_c6		(scdata1_sctag1_decc_c6[155:0]), // Templated
      // Inputs
      .cmp_gclk				({cmp_gclk_c0_r[6],cmp_gclk_c0_r[5]}), // Templated
      .global_shift_enable		(global_shift_enable),
      .si				(scbuf1_scdata1_scanout), // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c4),	 // Templated
      .cluster_cken			(rpt_scdata1_cmp_cken),	 // Templated
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .efc_scdata_fuse_ashift		(efc_scdata1_fuse_ashift), // Templated
      .efc_scdata_fuse_clk1		(efc_scdata13_fuse_clk1), // Templated
      .efc_scdata_fuse_clk2		(efc_scdata13_fuse_clk2), // Templated
      .efc_scdata_fuse_data		(efc_scdata13_fuse_data), // Templated
      .efc_scdata_fuse_dshift		(efc_scdata1_fuse_dshift), // Templated
      .scbuf_scdata_fbdecc_c4		(scbuf1_scdata1_fbdecc_c4[623:0]), // Templated
      .sctag_scdata_col_offset_c2	(sctag1_scdata1_col_offset_c2[3:0]), // Templated
      .sctag_scdata_fb_hit_c3		(sctag1_scdata1_fb_hit_c3), // Templated
      .sctag_scdata_fbrd_c3		(sctag1_scdata1_fbrd_c3), // Templated
      .sctag_scdata_rd_wr_c2		(sctag1_scdata1_rd_wr_c2), // Templated
      .sctag_scdata_set_c2		(sctag1_scdata1_set_c2[9:0]), // Templated
      .sctag_scdata_stdecc_c2		(sctag1_scdata1_stdecc_c2[77:0]), // Templated
      .sctag_scdata_way_sel_c2		(sctag1_scdata1_way_sel_c2[11:0]), // Templated
      .sctag_scdata_word_en_c2		(sctag1_scdata1_word_en_c2[15:0])); // Templated
`endif
//


/* scdata AUTO_TEMPLATE (
    .cmp_gclk				({cmp_gclk_c3_r[1],cmp_gclk_c3_r[2]}),
    .arst_l                             (cmp_arst_l),

    .grst_l				(rpt_cmp_grst_l_c2),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c@"(+ 1 (% @ 2) (* 4 (/ @ 2)))"),
    .cluster_cken                       (rpt_scdata@_cmp_cken),

    .si					(scbuf2_scdata2_scanout),
    .so					(par_scan_tail[23]),

    .efc_scdata_fuse_ashift             (efc_scdata@_fuse_ashift),
    .efc_scdata_fuse_dshift             (efc_scdata@_fuse_dshift),
    .efc_scdata\(.*\)                   (efc_scdata@"(% @ 2)"@"(+ (% @ 2) 2)"\1),
    .scdata_efc\(.*\)                   (scdata@_efc\1),

    .ctu_scdata\(.*\)                   (ctu_scdata@\1[]),
    .scdata_ctu\(.*\)                   (scdata@_ctu\1[]),

    .scbuf_scdata\(.*\)                 (scbuf@_scdata@\1[]),
    .scdata_scbuf\(.*\)                 (scdata@_scbuf@\1[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .scdata_sctag\(.*\)                 (scdata@_sctag@\1[]),
    ); */
//
`ifdef RTL_SCDATA2
   scdata scdata2
     (/*AUTOINST*/
      // Outputs
      .so				(par_scan_tail[23]),	 // Templated
      .scdata_efc_fuse_data		(scdata2_efc_fuse_data), // Templated
      .scdata_scbuf_decc_out_c7		(scdata2_scbuf2_decc_out_c7[623:0]), // Templated
      .scdata_sctag_decc_c6		(scdata2_sctag2_decc_c6[155:0]), // Templated
      // Inputs
      .cmp_gclk				({cmp_gclk_c3_r[1],cmp_gclk_c3_r[2]}), // Templated
      .global_shift_enable		(global_shift_enable),
      .si				(scbuf2_scdata2_scanout), // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c2),	 // Templated
      .cluster_cken			(rpt_scdata2_cmp_cken),	 // Templated
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .efc_scdata_fuse_ashift		(efc_scdata2_fuse_ashift), // Templated
      .efc_scdata_fuse_clk1		(efc_scdata02_fuse_clk1), // Templated
      .efc_scdata_fuse_clk2		(efc_scdata02_fuse_clk2), // Templated
      .efc_scdata_fuse_data		(efc_scdata02_fuse_data), // Templated
      .efc_scdata_fuse_dshift		(efc_scdata2_fuse_dshift), // Templated
      .scbuf_scdata_fbdecc_c4		(scbuf2_scdata2_fbdecc_c4[623:0]), // Templated
      .sctag_scdata_col_offset_c2	(sctag2_scdata2_col_offset_c2[3:0]), // Templated
      .sctag_scdata_fb_hit_c3		(sctag2_scdata2_fb_hit_c3), // Templated
      .sctag_scdata_fbrd_c3		(sctag2_scdata2_fbrd_c3), // Templated
      .sctag_scdata_rd_wr_c2		(sctag2_scdata2_rd_wr_c2), // Templated
      .sctag_scdata_set_c2		(sctag2_scdata2_set_c2[9:0]), // Templated
      .sctag_scdata_stdecc_c2		(sctag2_scdata2_stdecc_c2[77:0]), // Templated
      .sctag_scdata_way_sel_c2		(sctag2_scdata2_way_sel_c2[11:0]), // Templated
      .sctag_scdata_word_en_c2		(sctag2_scdata2_word_en_c2[15:0])); // Templated
`endif
//


/* scdata AUTO_TEMPLATE (
    .cmp_gclk				({cmp_gclk_c3_r[6],cmp_gclk_c3_r[5]}),
    .arst_l                             (cmp_arst_l),

    .grst_l				(rpt_cmp_grst_l_c7),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c@"(+ 1 (% @ 2) (* 4 (/ @ 2)))"),
    .cluster_cken                       (rpt_scdata@_cmp_cken),

    .si					(scbuf3_scdata3_scanout),
    .so					(par_scan_tail[22]),

    .efc_scdata_fuse_ashift             (efc_scdata@_fuse_ashift),
    .efc_scdata_fuse_dshift             (efc_scdata@_fuse_dshift),
    .efc_scdata\(.*\)                   (efc_scdata@"(% @ 2)"@"(+ (% @ 2) 2)"\1),
    .scdata_efc\(.*\)                   (scdata@_efc\1),

    .ctu_scdata\(.*\)                   (ctu_scdata@\1[]),
    .scdata_ctu\(.*\)                   (scdata@_ctu\1[]),

    .scbuf_scdata\(.*\)                 (scbuf@_scdata@\1[]),
    .scdata_scbuf\(.*\)                 (scdata@_scbuf@\1[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .scdata_sctag\(.*\)                 (scdata@_sctag@\1[]),
    ); */
//
`ifdef RTL_SCDATA3
   scdata scdata3
     (/*AUTOINST*/
      // Outputs
      .so				(par_scan_tail[22]),	 // Templated
      .scdata_efc_fuse_data		(scdata3_efc_fuse_data), // Templated
      .scdata_scbuf_decc_out_c7		(scdata3_scbuf3_decc_out_c7[623:0]), // Templated
      .scdata_sctag_decc_c6		(scdata3_sctag3_decc_c6[155:0]), // Templated
      // Inputs
      .cmp_gclk				({cmp_gclk_c3_r[6],cmp_gclk_c3_r[5]}), // Templated
      .global_shift_enable		(global_shift_enable),
      .si				(scbuf3_scdata3_scanout), // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c7),	 // Templated
      .cluster_cken			(rpt_scdata3_cmp_cken),	 // Templated
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .efc_scdata_fuse_ashift		(efc_scdata3_fuse_ashift), // Templated
      .efc_scdata_fuse_clk1		(efc_scdata13_fuse_clk1), // Templated
      .efc_scdata_fuse_clk2		(efc_scdata13_fuse_clk2), // Templated
      .efc_scdata_fuse_data		(efc_scdata13_fuse_data), // Templated
      .efc_scdata_fuse_dshift		(efc_scdata3_fuse_dshift), // Templated
      .scbuf_scdata_fbdecc_c4		(scbuf3_scdata3_fbdecc_c4[623:0]), // Templated
      .sctag_scdata_col_offset_c2	(sctag3_scdata3_col_offset_c2[3:0]), // Templated
      .sctag_scdata_fb_hit_c3		(sctag3_scdata3_fb_hit_c3), // Templated
      .sctag_scdata_fbrd_c3		(sctag3_scdata3_fbrd_c3), // Templated
      .sctag_scdata_rd_wr_c2		(sctag3_scdata3_rd_wr_c2), // Templated
      .sctag_scdata_set_c2		(sctag3_scdata3_set_c2[9:0]), // Templated
      .sctag_scdata_stdecc_c2		(sctag3_scdata3_stdecc_c2[77:0]), // Templated
      .sctag_scdata_way_sel_c2		(sctag3_scdata3_way_sel_c2[11:0]), // Templated
      .sctag_scdata_word_en_c2		(sctag3_scdata3_word_en_c2[15:0])); // Templated
`endif
//


/* sctag AUTO_TEMPLATE (
    .cmp_gclk				(cmp_gclk_c1_r[2]),
    .arst_l                             (cmp_arst_l),
    .adbginit_l                         (cmp_adbginit_l),

    .grst_l                             (rpt_cmp_grst_l_c@"(+ 1 (% @ 2) (* 4 (/ @ 2)))"),
    .gdbginit_l                         (rpt_cmp_gdbginit_l_c@"(+ 1 (% @ 2) (* 4 (/ @ 2)))"),
    .cluster_cken                       (rpt_sctag@_cmp_cken),

    .sctag_dbgbus_out                   (sctag@_dbgbus_out[]),

    .efc_sctag_fuse_ashift              (efc_sctag@_fuse_ashift),
    .efc_sctag_fuse_dshift              (efc_sctag@_fuse_dshift),
    .efc_sctag_fuse_\(.*\)              (efc_sctag@"(% @ 2)"@"(+ (% @ 2) 2)"_fuse_\1),
    .sctag_efc_fuse_data                (sctag@_efc_fuse_data),

    .ctu_sctag_scanin			(par_scan_head[5]),
    .sctag_ctu_scanout			(par_scan_tail[5]),

    .sctag_scbuf_scanout                (),
    .scdata_sctag_scanout               (1'b0),

    .sctag_scbuf\(.*\)                  (sctag@_scbuf@\1[]),
    .scbuf_sctag\(.*\)                  (scbuf@_sctag@\1_buf[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .scdata_sctag\(.*\)                 (scdata@_sctag@\1[]),

    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf2[]),

    .sctag_jbi\(.*\)                    (sctag@_jbi\1[]),
    .jbi_sctag\(.*\)                    (jbi_sctag@\1_d2[]),

    .sctag_cpx\(.*\)                    (sctag@_cpx\1[]),
    .sctag_pcx\(.*\)                    (sctag@_pcx\1[]),
    .cpx_sctag\(.*\)                    (cpx_sctag@\1_buf[]),

    .pcx_sctag\(.*\)                    (pcx_sctag@\1_buf[]),

    .sctag_ctu_mbistdone		(sctag@_ctu_mbistdone),
    .sctag_ctu_mbisterr			(sctag@_ctu_mbisterr),
    .sctag_ctu\(.*\)                    (sctag@_ctu\1[]),
    .ctu_sctag_mbisten			(ctu_sctag@_mbisten_buf2),
    .ctu_sctag\(.*\)                    (ctu_sctag@\1[]),

    .sctag_clk_tr                       (sctag@_ctu_tr),
    ); */
//
`ifdef RTL_SCTAG0
   sctag sctag0
     (/*AUTOINST*/
      // Outputs
      .sctag_cpx_req_cq			(sctag0_cpx_req_cq[7:0]), // Templated
      .sctag_cpx_atom_cq		(sctag0_cpx_atom_cq),	 // Templated
      .sctag_cpx_data_ca		(sctag0_cpx_data_ca[`CPX_WIDTH-1:0]), // Templated
      .sctag_pcx_stall_pq		(sctag0_pcx_stall_pq),	 // Templated
      .sctag_jbi_por_req		(sctag0_jbi_por_req),	 // Templated
      .sctag_scdata_way_sel_c2		(sctag0_scdata0_way_sel_c2[11:0]), // Templated
      .sctag_scdata_rd_wr_c2		(sctag0_scdata0_rd_wr_c2), // Templated
      .sctag_scdata_set_c2		(sctag0_scdata0_set_c2[9:0]), // Templated
      .sctag_scdata_col_offset_c2	(sctag0_scdata0_col_offset_c2[3:0]), // Templated
      .sctag_scdata_word_en_c2		(sctag0_scdata0_word_en_c2[15:0]), // Templated
      .sctag_scdata_fbrd_c3		(sctag0_scdata0_fbrd_c3), // Templated
      .sctag_scdata_fb_hit_c3		(sctag0_scdata0_fb_hit_c3), // Templated
      .sctag_scdata_stdecc_c2		(sctag0_scdata0_stdecc_c2[77:0]), // Templated
      .sctag_scbuf_stdecc_c3		(sctag0_scbuf0_stdecc_c3[77:0]), // Templated
      .sctag_scbuf_fbrd_en_c3		(sctag0_scbuf0_fbrd_en_c3), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag0_scbuf0_fbrd_wl_c3[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag0_scbuf0_fbwr_wen_r2[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag0_scbuf0_fbwr_wl_r2[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag0_scbuf0_fbd_stdatasel_c3), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag0_scbuf0_wbwr_wen_c6[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag0_scbuf0_wbwr_wl_c6[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag0_scbuf0_wbrd_en_r0), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag0_scbuf0_wbrd_wl_r0[2:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag0_scbuf0_ev_dword_r0[2:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag0_scbuf0_evict_en_r0), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag0_scbuf0_rdma_wren_s2[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag0_scbuf0_rdma_wrwl_s2[1:0]), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag0_scbuf0_rdma_rdwl_r0[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag0_scbuf0_rdma_rden_r0), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag0_scbuf0_ctag_en_c7), // Templated
      .sctag_scbuf_ctag_c7		(sctag0_scbuf0_ctag_c7[14:0]), // Templated
      .sctag_scbuf_word_c7		(sctag0_scbuf0_word_c7[3:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag0_scbuf0_req_en_c7), // Templated
      .sctag_scbuf_word_vld_c7		(sctag0_scbuf0_word_vld_c7), // Templated
      .sctag_dram_rd_req		(sctag0_dram02_rd_req),	 // Templated
      .sctag_dram_rd_dummy_req		(sctag0_dram02_rd_dummy_req), // Templated
      .sctag_dram_rd_req_id		(sctag0_dram02_rd_req_id[2:0]), // Templated
      .sctag_dram_addr			(sctag0_dram02_addr[39:5]), // Templated
      .sctag_dram_wr_req		(sctag0_dram02_wr_req),	 // Templated
      .sctag_jbi_iq_dequeue		(sctag0_jbi_iq_dequeue), // Templated
      .sctag_jbi_wib_dequeue		(sctag0_jbi_wib_dequeue), // Templated
      .sctag_dbgbus_out			(sctag0_dbgbus_out[40:0]), // Templated
      .sctag_clk_tr			(sctag0_ctu_tr),	 // Templated
      .sctag_ctu_mbistdone		(sctag0_ctu_mbistdone),	 // Templated
      .sctag_ctu_mbisterr		(sctag0_ctu_mbisterr),	 // Templated
      .sctag_ctu_scanout		(par_scan_tail[5]),	 // Templated
      .sctag_scbuf_scanout		(),			 // Templated
      .sctag_efc_fuse_data		(sctag0_efc_fuse_data),	 // Templated
      // Inputs
      .pcx_sctag_data_rdy_px1		(pcx_sctag0_data_rdy_px1_buf), // Templated
      .pcx_sctag_data_px2		(pcx_sctag0_data_px2_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_sctag_atm_px1		(pcx_sctag0_atm_px1_buf), // Templated
      .cpx_sctag_grant_cx		(cpx_sctag0_grant_cx_buf[7:0]), // Templated
      .scdata_sctag_decc_c6		(scdata0_sctag0_decc_c6[155:0]), // Templated
      .scbuf_sctag_ev_uerr_r5		(scbuf0_sctag0_ev_uerr_r5_buf), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf0_sctag0_ev_cerr_r5_buf), // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf0_sctag0_rdma_uerr_c10_buf), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf0_sctag0_rdma_cerr_c10_buf), // Templated
      .dram_sctag_rd_ack		(dram02_sctag0_rd_ack_buf2), // Templated
      .dram_sctag_wr_ack		(dram02_sctag0_wr_ack_buf2), // Templated
      .dram_sctag_chunk_id_r0		(dram02_sctag0_chunk_id_r0_buf2[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram02_sctag0_data_vld_r0_buf2), // Templated
      .dram_sctag_rd_req_id_r0		(dram02_sctag0_rd_req_id_r0_buf2[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram02_sctag0_secc_err_r2_buf2), // Templated
      .dram_sctag_mecc_err_r2		(dram02_sctag0_mecc_err_r2_buf2), // Templated
      .dram_sctag_scb_mecc_err		(dram02_sctag0_scb_mecc_err_buf2), // Templated
      .dram_sctag_scb_secc_err		(dram02_sctag0_scb_secc_err_buf2), // Templated
      .jbi_sctag_req_vld		(jbi_sctag0_req_vld_d2), // Templated
      .jbi_sctag_req			(jbi_sctag0_req_d2[31:0]), // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c1),	 // Templated
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c1), // Templated
      .cluster_cken			(rpt_sctag0_cmp_cken),	 // Templated
      .cmp_gclk				(cmp_gclk_c1_r[2]),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .ctu_sctag_mbisten		(ctu_sctag0_mbisten_buf2), // Templated
      .ctu_sctag_scanin			(par_scan_head[5]),	 // Templated
      .scdata_sctag_scanout		(1'b0),			 // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .efc_sctag_fuse_clk1		(efc_sctag02_fuse_clk1), // Templated
      .efc_sctag_fuse_clk2		(efc_sctag02_fuse_clk2), // Templated
      .efc_sctag_fuse_ashift		(efc_sctag0_fuse_ashift), // Templated
      .efc_sctag_fuse_dshift		(efc_sctag0_fuse_dshift), // Templated
      .efc_sctag_fuse_data		(efc_sctag02_fuse_data)); // Templated
`endif
//


/* sctag AUTO_TEMPLATE (
    .cmp_gclk				(cmp_gclk_c1_r[4]),
    .arst_l                             (cmp_arst_l),
    .adbginit_l                         (cmp_adbginit_l),

    .grst_l				(rpt_cmp_grst_l_c4),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c4),
    .cluster_cken                       (rpt_sctag@_cmp_cken),

    .sctag_dbgbus_out                   (sctag@_dbgbus_out[]),

    .efc_sctag_fuse_ashift              (efc_sctag@_fuse_ashift),
    .efc_sctag_fuse_dshift              (efc_sctag@_fuse_dshift),
    .efc_sctag_fuse_\(.*\)              (efc_sctag@"(% @ 2)"@"(+ (% @ 2) 2)"_fuse_\1),
    .sctag_efc_fuse_data                (sctag@_efc_fuse_data),

    .ctu_sctag_scanin			(par_scan_head[9]),
    .sctag_ctu_scanout			(par_scan_tail[9]),

    .sctag_scbuf_scanout                (),
    .scdata_sctag_scanout               (1'b0),

    .sctag_scbuf\(.*\)                  (sctag@_scbuf@\1[]),
    .scbuf_sctag\(.*\)                  (scbuf@_sctag@\1_buf[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .scdata_sctag\(.*\)                 (scdata@_sctag@\1[]),

    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf2[]),

    .sctag_jbi\(.*\)                    (sctag@_jbi\1[]),
    .jbi_sctag\(.*\)                    (jbi_sctag@\1_d2[]),

    .sctag_cpx\(.*\)                    (sctag@_cpx\1[]),
    .sctag_pcx\(.*\)                    (sctag@_pcx\1[]),
    .cpx_sctag\(.*\)                    (cpx_sctag@\1_buf[]),

    .pcx_sctag\(.*\)                    (pcx_sctag@\1_buf[]),

    .sctag_ctu_mbistdone		(sctag@_ctu_mbistdone),
    .sctag_ctu_mbisterr			(sctag@_ctu_mbisterr),
    .sctag_ctu\(.*\)                    (sctag@_ctu\1[]),
    .ctu_sctag_mbisten			(ctu_sctag@_mbisten_buf2),
    .ctu_sctag\(.*\)                    (ctu_sctag@\1[]),

    .sctag_clk_tr                       (sctag@_ctu_tr),
    ); */
//
`ifdef RTL_SCTAG1
   sctag sctag1
     (/*AUTOINST*/
      // Outputs
      .sctag_cpx_req_cq			(sctag1_cpx_req_cq[7:0]), // Templated
      .sctag_cpx_atom_cq		(sctag1_cpx_atom_cq),	 // Templated
      .sctag_cpx_data_ca		(sctag1_cpx_data_ca[`CPX_WIDTH-1:0]), // Templated
      .sctag_pcx_stall_pq		(sctag1_pcx_stall_pq),	 // Templated
      .sctag_jbi_por_req		(sctag1_jbi_por_req),	 // Templated
      .sctag_scdata_way_sel_c2		(sctag1_scdata1_way_sel_c2[11:0]), // Templated
      .sctag_scdata_rd_wr_c2		(sctag1_scdata1_rd_wr_c2), // Templated
      .sctag_scdata_set_c2		(sctag1_scdata1_set_c2[9:0]), // Templated
      .sctag_scdata_col_offset_c2	(sctag1_scdata1_col_offset_c2[3:0]), // Templated
      .sctag_scdata_word_en_c2		(sctag1_scdata1_word_en_c2[15:0]), // Templated
      .sctag_scdata_fbrd_c3		(sctag1_scdata1_fbrd_c3), // Templated
      .sctag_scdata_fb_hit_c3		(sctag1_scdata1_fb_hit_c3), // Templated
      .sctag_scdata_stdecc_c2		(sctag1_scdata1_stdecc_c2[77:0]), // Templated
      .sctag_scbuf_stdecc_c3		(sctag1_scbuf1_stdecc_c3[77:0]), // Templated
      .sctag_scbuf_fbrd_en_c3		(sctag1_scbuf1_fbrd_en_c3), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag1_scbuf1_fbrd_wl_c3[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag1_scbuf1_fbwr_wen_r2[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag1_scbuf1_fbwr_wl_r2[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag1_scbuf1_fbd_stdatasel_c3), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag1_scbuf1_wbwr_wen_c6[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag1_scbuf1_wbwr_wl_c6[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag1_scbuf1_wbrd_en_r0), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag1_scbuf1_wbrd_wl_r0[2:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag1_scbuf1_ev_dword_r0[2:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag1_scbuf1_evict_en_r0), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag1_scbuf1_rdma_wren_s2[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag1_scbuf1_rdma_wrwl_s2[1:0]), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag1_scbuf1_rdma_rdwl_r0[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag1_scbuf1_rdma_rden_r0), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag1_scbuf1_ctag_en_c7), // Templated
      .sctag_scbuf_ctag_c7		(sctag1_scbuf1_ctag_c7[14:0]), // Templated
      .sctag_scbuf_word_c7		(sctag1_scbuf1_word_c7[3:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag1_scbuf1_req_en_c7), // Templated
      .sctag_scbuf_word_vld_c7		(sctag1_scbuf1_word_vld_c7), // Templated
      .sctag_dram_rd_req		(sctag1_dram13_rd_req),	 // Templated
      .sctag_dram_rd_dummy_req		(sctag1_dram13_rd_dummy_req), // Templated
      .sctag_dram_rd_req_id		(sctag1_dram13_rd_req_id[2:0]), // Templated
      .sctag_dram_addr			(sctag1_dram13_addr[39:5]), // Templated
      .sctag_dram_wr_req		(sctag1_dram13_wr_req),	 // Templated
      .sctag_jbi_iq_dequeue		(sctag1_jbi_iq_dequeue), // Templated
      .sctag_jbi_wib_dequeue		(sctag1_jbi_wib_dequeue), // Templated
      .sctag_dbgbus_out			(sctag1_dbgbus_out[40:0]), // Templated
      .sctag_clk_tr			(sctag1_ctu_tr),	 // Templated
      .sctag_ctu_mbistdone		(sctag1_ctu_mbistdone),	 // Templated
      .sctag_ctu_mbisterr		(sctag1_ctu_mbisterr),	 // Templated
      .sctag_ctu_scanout		(par_scan_tail[9]),	 // Templated
      .sctag_scbuf_scanout		(),			 // Templated
      .sctag_efc_fuse_data		(sctag1_efc_fuse_data),	 // Templated
      // Inputs
      .pcx_sctag_data_rdy_px1		(pcx_sctag1_data_rdy_px1_buf), // Templated
      .pcx_sctag_data_px2		(pcx_sctag1_data_px2_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_sctag_atm_px1		(pcx_sctag1_atm_px1_buf), // Templated
      .cpx_sctag_grant_cx		(cpx_sctag1_grant_cx_buf[7:0]), // Templated
      .scdata_sctag_decc_c6		(scdata1_sctag1_decc_c6[155:0]), // Templated
      .scbuf_sctag_ev_uerr_r5		(scbuf1_sctag1_ev_uerr_r5_buf), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf1_sctag1_ev_cerr_r5_buf), // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf1_sctag1_rdma_uerr_c10_buf), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf1_sctag1_rdma_cerr_c10_buf), // Templated
      .dram_sctag_rd_ack		(dram13_sctag1_rd_ack_buf2), // Templated
      .dram_sctag_wr_ack		(dram13_sctag1_wr_ack_buf2), // Templated
      .dram_sctag_chunk_id_r0		(dram13_sctag1_chunk_id_r0_buf2[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram13_sctag1_data_vld_r0_buf2), // Templated
      .dram_sctag_rd_req_id_r0		(dram13_sctag1_rd_req_id_r0_buf2[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram13_sctag1_secc_err_r2_buf2), // Templated
      .dram_sctag_mecc_err_r2		(dram13_sctag1_mecc_err_r2_buf2), // Templated
      .dram_sctag_scb_mecc_err		(dram13_sctag1_scb_mecc_err_buf2), // Templated
      .dram_sctag_scb_secc_err		(dram13_sctag1_scb_secc_err_buf2), // Templated
      .jbi_sctag_req_vld		(jbi_sctag1_req_vld_d2), // Templated
      .jbi_sctag_req			(jbi_sctag1_req_d2[31:0]), // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c4),	 // Templated
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c4), // Templated
      .cluster_cken			(rpt_sctag1_cmp_cken),	 // Templated
      .cmp_gclk				(cmp_gclk_c1_r[4]),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .ctu_sctag_mbisten		(ctu_sctag1_mbisten_buf2), // Templated
      .ctu_sctag_scanin			(par_scan_head[9]),	 // Templated
      .scdata_sctag_scanout		(1'b0),			 // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .efc_sctag_fuse_clk1		(efc_sctag13_fuse_clk1), // Templated
      .efc_sctag_fuse_clk2		(efc_sctag13_fuse_clk2), // Templated
      .efc_sctag_fuse_ashift		(efc_sctag1_fuse_ashift), // Templated
      .efc_sctag_fuse_dshift		(efc_sctag1_fuse_dshift), // Templated
      .efc_sctag_fuse_data		(efc_sctag13_fuse_data)); // Templated
`endif
//


/* sctag AUTO_TEMPLATE (
    .cmp_gclk				(cmp_gclk_c2_r[2]),
    .arst_l                             (cmp_arst_l),
    .adbginit_l                         (cmp_adbginit_l),

    .grst_l				(rpt_cmp_grst_l_c2),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c2),
    .cluster_cken                       (rpt_sctag@_cmp_cken),

    .sctag_dbgbus_out                   (sctag@_dbgbus_out[]),

    .efc_sctag_fuse_ashift              (efc_sctag@_fuse_ashift),
    .efc_sctag_fuse_dshift              (efc_sctag@_fuse_dshift),
    .efc_sctag_fuse_\(.*\)              (efc_sctag@"(% @ 2)"@"(+ (% @ 2) 2)"_fuse_\1),
    .sctag_efc_fuse_data                (sctag@_efc_fuse_data),

    .ctu_sctag_scanin			(par_scan_head[30]),
    .sctag_ctu_scanout			(par_scan_tail[30]),

    .sctag_scbuf_scanout                (),
    .scdata_sctag_scanout               (1'b0),

    .sctag_scbuf\(.*\)                  (sctag@_scbuf@\1[]),
    .scbuf_sctag\(.*\)                  (scbuf@_sctag@\1_buf[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .scdata_sctag\(.*\)                 (scdata@_sctag@\1[]),

    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf2[]),

    .sctag_jbi\(.*\)                    (sctag@_jbi\1[]),
    .jbi_sctag\(.*\)                    (jbi_sctag@\1_d2[]),

    .sctag_cpx\(.*\)                    (sctag@_cpx\1[]),
    .sctag_pcx\(.*\)                    (sctag@_pcx\1[]),
    .cpx_sctag\(.*\)                    (cpx_sctag@\1_buf[]),

    .pcx_sctag\(.*\)                    (pcx_sctag@\1_buf[]),

    .sctag_ctu_mbistdone		(sctag@_ctu_mbistdone),
    .sctag_ctu_mbisterr			(sctag@_ctu_mbisterr),
    .sctag_ctu\(.*\)                    (sctag@_ctu\1[]),
    .ctu_sctag_mbisten			(ctu_sctag@_mbisten_buf2),
    .ctu_sctag\(.*\)                    (ctu_sctag@\1[]),

    .sctag_clk_tr                       (sctag@_ctu_tr),
    ); */
//
`ifdef RTL_SCTAG2
   sctag sctag2
     (/*AUTOINST*/
      // Outputs
      .sctag_cpx_req_cq			(sctag2_cpx_req_cq[7:0]), // Templated
      .sctag_cpx_atom_cq		(sctag2_cpx_atom_cq),	 // Templated
      .sctag_cpx_data_ca		(sctag2_cpx_data_ca[`CPX_WIDTH-1:0]), // Templated
      .sctag_pcx_stall_pq		(sctag2_pcx_stall_pq),	 // Templated
      .sctag_jbi_por_req		(sctag2_jbi_por_req),	 // Templated
      .sctag_scdata_way_sel_c2		(sctag2_scdata2_way_sel_c2[11:0]), // Templated
      .sctag_scdata_rd_wr_c2		(sctag2_scdata2_rd_wr_c2), // Templated
      .sctag_scdata_set_c2		(sctag2_scdata2_set_c2[9:0]), // Templated
      .sctag_scdata_col_offset_c2	(sctag2_scdata2_col_offset_c2[3:0]), // Templated
      .sctag_scdata_word_en_c2		(sctag2_scdata2_word_en_c2[15:0]), // Templated
      .sctag_scdata_fbrd_c3		(sctag2_scdata2_fbrd_c3), // Templated
      .sctag_scdata_fb_hit_c3		(sctag2_scdata2_fb_hit_c3), // Templated
      .sctag_scdata_stdecc_c2		(sctag2_scdata2_stdecc_c2[77:0]), // Templated
      .sctag_scbuf_stdecc_c3		(sctag2_scbuf2_stdecc_c3[77:0]), // Templated
      .sctag_scbuf_fbrd_en_c3		(sctag2_scbuf2_fbrd_en_c3), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag2_scbuf2_fbrd_wl_c3[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag2_scbuf2_fbwr_wen_r2[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag2_scbuf2_fbwr_wl_r2[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag2_scbuf2_fbd_stdatasel_c3), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag2_scbuf2_wbwr_wen_c6[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag2_scbuf2_wbwr_wl_c6[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag2_scbuf2_wbrd_en_r0), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag2_scbuf2_wbrd_wl_r0[2:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag2_scbuf2_ev_dword_r0[2:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag2_scbuf2_evict_en_r0), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag2_scbuf2_rdma_wren_s2[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag2_scbuf2_rdma_wrwl_s2[1:0]), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag2_scbuf2_rdma_rdwl_r0[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag2_scbuf2_rdma_rden_r0), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag2_scbuf2_ctag_en_c7), // Templated
      .sctag_scbuf_ctag_c7		(sctag2_scbuf2_ctag_c7[14:0]), // Templated
      .sctag_scbuf_word_c7		(sctag2_scbuf2_word_c7[3:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag2_scbuf2_req_en_c7), // Templated
      .sctag_scbuf_word_vld_c7		(sctag2_scbuf2_word_vld_c7), // Templated
      .sctag_dram_rd_req		(sctag2_dram02_rd_req),	 // Templated
      .sctag_dram_rd_dummy_req		(sctag2_dram02_rd_dummy_req), // Templated
      .sctag_dram_rd_req_id		(sctag2_dram02_rd_req_id[2:0]), // Templated
      .sctag_dram_addr			(sctag2_dram02_addr[39:5]), // Templated
      .sctag_dram_wr_req		(sctag2_dram02_wr_req),	 // Templated
      .sctag_jbi_iq_dequeue		(sctag2_jbi_iq_dequeue), // Templated
      .sctag_jbi_wib_dequeue		(sctag2_jbi_wib_dequeue), // Templated
      .sctag_dbgbus_out			(sctag2_dbgbus_out[40:0]), // Templated
      .sctag_clk_tr			(sctag2_ctu_tr),	 // Templated
      .sctag_ctu_mbistdone		(sctag2_ctu_mbistdone),	 // Templated
      .sctag_ctu_mbisterr		(sctag2_ctu_mbisterr),	 // Templated
      .sctag_ctu_scanout		(par_scan_tail[30]),	 // Templated
      .sctag_scbuf_scanout		(),			 // Templated
      .sctag_efc_fuse_data		(sctag2_efc_fuse_data),	 // Templated
      // Inputs
      .pcx_sctag_data_rdy_px1		(pcx_sctag2_data_rdy_px1_buf), // Templated
      .pcx_sctag_data_px2		(pcx_sctag2_data_px2_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_sctag_atm_px1		(pcx_sctag2_atm_px1_buf), // Templated
      .cpx_sctag_grant_cx		(cpx_sctag2_grant_cx_buf[7:0]), // Templated
      .scdata_sctag_decc_c6		(scdata2_sctag2_decc_c6[155:0]), // Templated
      .scbuf_sctag_ev_uerr_r5		(scbuf2_sctag2_ev_uerr_r5_buf), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf2_sctag2_ev_cerr_r5_buf), // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf2_sctag2_rdma_uerr_c10_buf), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf2_sctag2_rdma_cerr_c10_buf), // Templated
      .dram_sctag_rd_ack		(dram02_sctag2_rd_ack_buf2), // Templated
      .dram_sctag_wr_ack		(dram02_sctag2_wr_ack_buf2), // Templated
      .dram_sctag_chunk_id_r0		(dram02_sctag2_chunk_id_r0_buf2[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram02_sctag2_data_vld_r0_buf2), // Templated
      .dram_sctag_rd_req_id_r0		(dram02_sctag2_rd_req_id_r0_buf2[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram02_sctag2_secc_err_r2_buf2), // Templated
      .dram_sctag_mecc_err_r2		(dram02_sctag2_mecc_err_r2_buf2), // Templated
      .dram_sctag_scb_mecc_err		(dram02_sctag2_scb_mecc_err_buf2), // Templated
      .dram_sctag_scb_secc_err		(dram02_sctag2_scb_secc_err_buf2), // Templated
      .jbi_sctag_req_vld		(jbi_sctag2_req_vld_d2), // Templated
      .jbi_sctag_req			(jbi_sctag2_req_d2[31:0]), // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c2),	 // Templated
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c2), // Templated
      .cluster_cken			(rpt_sctag2_cmp_cken),	 // Templated
      .cmp_gclk				(cmp_gclk_c2_r[2]),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .ctu_sctag_mbisten		(ctu_sctag2_mbisten_buf2), // Templated
      .ctu_sctag_scanin			(par_scan_head[30]),	 // Templated
      .scdata_sctag_scanout		(1'b0),			 // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .efc_sctag_fuse_clk1		(efc_sctag02_fuse_clk1), // Templated
      .efc_sctag_fuse_clk2		(efc_sctag02_fuse_clk2), // Templated
      .efc_sctag_fuse_ashift		(efc_sctag2_fuse_ashift), // Templated
      .efc_sctag_fuse_dshift		(efc_sctag2_fuse_dshift), // Templated
      .efc_sctag_fuse_data		(efc_sctag02_fuse_data)); // Templated
`endif
//


/* sctag AUTO_TEMPLATE (
    .cmp_gclk				(cmp_gclk_c2_r[4]),
    .arst_l                             (cmp_arst_l),
    .adbginit_l                         (cmp_adbginit_l),

    .grst_l				(rpt_cmp_grst_l_c7),
    .gdbginit_l				(rpt_cmp_gdbginit_l_c7),
    .cluster_cken                       (rpt_sctag@_cmp_cken),

    .sctag_dbgbus_out                   (sctag@_dbgbus_out[]),

    .efc_sctag_fuse_ashift              (efc_sctag@_fuse_ashift),
    .efc_sctag_fuse_dshift              (efc_sctag@_fuse_dshift),
    .efc_sctag_fuse_\(.*\)              (efc_sctag@"(% @ 2)"@"(+ (% @ 2) 2)"_fuse_\1),
    .sctag_efc_fuse_data                (sctag@_efc_fuse_data),

    .ctu_sctag_scanin			(par_scan_head[17]),
    .sctag_ctu_scanout			(par_scan_tail[17]),

    .sctag_scbuf_scanout                (),
    .scdata_sctag_scanout               (1'b0),

    .sctag_scbuf\(.*\)                  (sctag@_scbuf@\1[]),
    .scbuf_sctag\(.*\)                  (scbuf@_sctag@\1_buf[]),

    .sctag_scdata\(.*\)                 (sctag@_scdata@\1[]),
    .scdata_sctag\(.*\)                 (scdata@_sctag@\1[]),

    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf2[]),

    .sctag_jbi\(.*\)                    (sctag@_jbi\1[]),
    .jbi_sctag\(.*\)                    (jbi_sctag@\1_d2[]),

    .sctag_cpx\(.*\)                    (sctag@_cpx\1[]),
    .sctag_pcx\(.*\)                    (sctag@_pcx\1[]),
    .cpx_sctag\(.*\)                    (cpx_sctag@\1_buf[]),

    .pcx_sctag\(.*\)                    (pcx_sctag@\1_buf[]),

    .sctag_ctu_mbistdone		(sctag@_ctu_mbistdone),
    .sctag_ctu_mbisterr			(sctag@_ctu_mbisterr),
    .sctag_ctu\(.*\)                    (sctag@_ctu\1[]),
    .ctu_sctag_mbisten			(ctu_sctag@_mbisten_buf2),
    .ctu_sctag\(.*\)                    (ctu_sctag@\1[]),

    .sctag_clk_tr                       (sctag@_ctu_tr),
    ); */
//
`ifdef RTL_SCTAG3
   sctag sctag3
     (/*AUTOINST*/
      // Outputs
      .sctag_cpx_req_cq			(sctag3_cpx_req_cq[7:0]), // Templated
      .sctag_cpx_atom_cq		(sctag3_cpx_atom_cq),	 // Templated
      .sctag_cpx_data_ca		(sctag3_cpx_data_ca[`CPX_WIDTH-1:0]), // Templated
      .sctag_pcx_stall_pq		(sctag3_pcx_stall_pq),	 // Templated
      .sctag_jbi_por_req		(sctag3_jbi_por_req),	 // Templated
      .sctag_scdata_way_sel_c2		(sctag3_scdata3_way_sel_c2[11:0]), // Templated
      .sctag_scdata_rd_wr_c2		(sctag3_scdata3_rd_wr_c2), // Templated
      .sctag_scdata_set_c2		(sctag3_scdata3_set_c2[9:0]), // Templated
      .sctag_scdata_col_offset_c2	(sctag3_scdata3_col_offset_c2[3:0]), // Templated
      .sctag_scdata_word_en_c2		(sctag3_scdata3_word_en_c2[15:0]), // Templated
      .sctag_scdata_fbrd_c3		(sctag3_scdata3_fbrd_c3), // Templated
      .sctag_scdata_fb_hit_c3		(sctag3_scdata3_fb_hit_c3), // Templated
      .sctag_scdata_stdecc_c2		(sctag3_scdata3_stdecc_c2[77:0]), // Templated
      .sctag_scbuf_stdecc_c3		(sctag3_scbuf3_stdecc_c3[77:0]), // Templated
      .sctag_scbuf_fbrd_en_c3		(sctag3_scbuf3_fbrd_en_c3), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag3_scbuf3_fbrd_wl_c3[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag3_scbuf3_fbwr_wen_r2[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag3_scbuf3_fbwr_wl_r2[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag3_scbuf3_fbd_stdatasel_c3), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag3_scbuf3_wbwr_wen_c6[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag3_scbuf3_wbwr_wl_c6[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag3_scbuf3_wbrd_en_r0), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag3_scbuf3_wbrd_wl_r0[2:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag3_scbuf3_ev_dword_r0[2:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag3_scbuf3_evict_en_r0), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag3_scbuf3_rdma_wren_s2[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag3_scbuf3_rdma_wrwl_s2[1:0]), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag3_scbuf3_rdma_rdwl_r0[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag3_scbuf3_rdma_rden_r0), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag3_scbuf3_ctag_en_c7), // Templated
      .sctag_scbuf_ctag_c7		(sctag3_scbuf3_ctag_c7[14:0]), // Templated
      .sctag_scbuf_word_c7		(sctag3_scbuf3_word_c7[3:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag3_scbuf3_req_en_c7), // Templated
      .sctag_scbuf_word_vld_c7		(sctag3_scbuf3_word_vld_c7), // Templated
      .sctag_dram_rd_req		(sctag3_dram13_rd_req),	 // Templated
      .sctag_dram_rd_dummy_req		(sctag3_dram13_rd_dummy_req), // Templated
      .sctag_dram_rd_req_id		(sctag3_dram13_rd_req_id[2:0]), // Templated
      .sctag_dram_addr			(sctag3_dram13_addr[39:5]), // Templated
      .sctag_dram_wr_req		(sctag3_dram13_wr_req),	 // Templated
      .sctag_jbi_iq_dequeue		(sctag3_jbi_iq_dequeue), // Templated
      .sctag_jbi_wib_dequeue		(sctag3_jbi_wib_dequeue), // Templated
      .sctag_dbgbus_out			(sctag3_dbgbus_out[40:0]), // Templated
      .sctag_clk_tr			(sctag3_ctu_tr),	 // Templated
      .sctag_ctu_mbistdone		(sctag3_ctu_mbistdone),	 // Templated
      .sctag_ctu_mbisterr		(sctag3_ctu_mbisterr),	 // Templated
      .sctag_ctu_scanout		(par_scan_tail[17]),	 // Templated
      .sctag_scbuf_scanout		(),			 // Templated
      .sctag_efc_fuse_data		(sctag3_efc_fuse_data),	 // Templated
      // Inputs
      .pcx_sctag_data_rdy_px1		(pcx_sctag3_data_rdy_px1_buf), // Templated
      .pcx_sctag_data_px2		(pcx_sctag3_data_px2_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_sctag_atm_px1		(pcx_sctag3_atm_px1_buf), // Templated
      .cpx_sctag_grant_cx		(cpx_sctag3_grant_cx_buf[7:0]), // Templated
      .scdata_sctag_decc_c6		(scdata3_sctag3_decc_c6[155:0]), // Templated
      .scbuf_sctag_ev_uerr_r5		(scbuf3_sctag3_ev_uerr_r5_buf), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf3_sctag3_ev_cerr_r5_buf), // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf3_sctag3_rdma_uerr_c10_buf), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf3_sctag3_rdma_cerr_c10_buf), // Templated
      .dram_sctag_rd_ack		(dram13_sctag3_rd_ack_buf2), // Templated
      .dram_sctag_wr_ack		(dram13_sctag3_wr_ack_buf2), // Templated
      .dram_sctag_chunk_id_r0		(dram13_sctag3_chunk_id_r0_buf2[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram13_sctag3_data_vld_r0_buf2), // Templated
      .dram_sctag_rd_req_id_r0		(dram13_sctag3_rd_req_id_r0_buf2[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram13_sctag3_secc_err_r2_buf2), // Templated
      .dram_sctag_mecc_err_r2		(dram13_sctag3_mecc_err_r2_buf2), // Templated
      .dram_sctag_scb_mecc_err		(dram13_sctag3_scb_mecc_err_buf2), // Templated
      .dram_sctag_scb_secc_err		(dram13_sctag3_scb_secc_err_buf2), // Templated
      .jbi_sctag_req_vld		(jbi_sctag3_req_vld_d2), // Templated
      .jbi_sctag_req			(jbi_sctag3_req_d2[31:0]), // Templated
      .arst_l				(cmp_arst_l),		 // Templated
      .grst_l				(rpt_cmp_grst_l_c7),	 // Templated
      .adbginit_l			(cmp_adbginit_l),	 // Templated
      .gdbginit_l			(rpt_cmp_gdbginit_l_c7), // Templated
      .cluster_cken			(rpt_sctag3_cmp_cken),	 // Templated
      .cmp_gclk				(cmp_gclk_c2_r[4]),	 // Templated
      .global_shift_enable		(global_shift_enable),
      .ctu_sctag_mbisten		(ctu_sctag3_mbisten_buf2), // Templated
      .ctu_sctag_scanin			(par_scan_head[17]),	 // Templated
      .scdata_sctag_scanout		(1'b0),			 // Templated
      .ctu_tst_macrotest		(ctu_tst_macrotest),
      .ctu_tst_pre_grst_l		(ctu_tst_pre_grst_l),
      .ctu_tst_scan_disable		(ctu_tst_scan_disable),
      .ctu_tst_scanmode			(ctu_tst_scanmode),
      .ctu_tst_short_chain		(ctu_tst_short_chain),
      .efc_sctag_fuse_clk1		(efc_sctag13_fuse_clk1), // Templated
      .efc_sctag_fuse_clk2		(efc_sctag13_fuse_clk2), // Templated
      .efc_sctag_fuse_ashift		(efc_sctag3_fuse_ashift), // Templated
      .efc_sctag_fuse_dshift		(efc_sctag3_fuse_dshift), // Templated
      .efc_sctag_fuse_data		(efc_sctag13_fuse_data)); // Templated
`endif
//


/* bw_ctu_pad_cluster AUTO_TEMPLATE (
    .jclk                               (J_CLK[]),
    .tsr_testio                         (TSR_TESTIO[]),
    .vdda                               (VDDA),
    .vddo                               (VDDCO),
    ); */
//
`ifdef RTL_PAD_CTU
   bw_ctu_pad_cluster pad_ctu
     (/*AUTOINST*/
      // Inouts
      .jclk				(J_CLK[1:0]),		 // Templated
      .tsr_testio			(TSR_TESTIO[1:0]),	 // Templated
      .vddo				(VDDCO),		 // Templated
      .vdda				(VDDA));			 // Templated
`endif
//


/* pad_ddr0 AUTO_TEMPLATE (
    .dram0_ras_l                        (DRAM0_RAS_L),
    .dram0_cas_l                        (DRAM0_CAS_L),
    .dram0_we_l                         (DRAM0_WE_L),
    .dram0_cs_l                         (DRAM0_CS_L[]),
    .dram0_cke                          (DRAM0_CKE),
    .dram0_addr                         (DRAM0_ADDR[]),
    .dram0_ba                           (DRAM0_BA[]),
    .dram0_dq                           (DRAM0_DQ[]),
    .dram0_cb                           (DRAM0_CB[]),
    .dram0_dqs                          (DRAM0_DQS[]),
    .dram0_ck_p                         (DRAM0_CK_P[]),
    .dram0_ck_n                         (DRAM0_CK_N[]),
    .dram01_p_ref_res                   (DRAM01_P_REF_RES),
    .dram01_n_ref_res                   (DRAM01_N_REF_RES),
    .spare_ddr0_pin                     (SPARE_DDR0_PIN),
    .spare_ddr0_pindata                 (1'b0),
    .spare_ddr0_pad                     (SPARE_DDR0_PAD[]),
    .spare_ddr0_paddata                 (7'b0101010),
    .clkobs				(CLKOBS[]),

    .dram_gclk                          ({dram_gclk_c0_r[3],dram_gclk_c0_r[1]}),
    .io_pwron_rst_l                     (dram_arst_l),
    .clk_ddr0_cken                      (ctu_ddr0_dram_cken),

    .bscan_\(.*\)_out                   (),
    .pad_ddr0_bsi                       (dbg_ddr0_bso),
    .ddr_si                             (par_scan_head[6]),

    .bscan_\(.*\)_in			(ctu_ddr0_\1),
    .pad_ddr0_bso                       (ddr0_ddr0_bso),
    .ddr_so                             (pddr0_jbi_so),

    .ddr_se                             (global_shift_enable),

    .tck                                (ctu_ddr0_clock_dr),
    .ctu_io_sscan_se                    (ctu_ddr0_shift_dr),
    .ctu_io_sscan_update                (ctu_pads_sscan_update),
    .pad_ddr0_sscan_in                  (ddr0_ddr0_bso),
    .pad_ddr0_sscan_out                 (ddr0_ctu_bso),

    .test_mode                          (io_test_mode),

    .ddr_testmode_l                     (ctu_ddr_testmode_l),

    .bypass_enable                      (global_scan_bypass_en),
    .bypass_enable_out                  (),

    .ps_select                          (pscan_select),
    .ps_select_out                      (),

    .vdd18                              (VDDL18),

    .dram0_io_ptr_clk_inv               (dram0_io_ptr_clk_inv_buf2[]),
    .dram0_io_addr                      (dram0_io_addr_buf2[]),
    .dram0_io_data_out                  (dram0_io_data_out_buf2[]),
    .dram0_io_cs_l                      (dram0_io_cs_l_buf2[]),
    .dram0_io_bank                      (dram0_io_bank_buf2[]),
    .dram0_io_write_en_l                (dram0_io_write_en_l_buf2),
    .dram0_io_ras_l                     (dram0_io_ras_l_buf2),
    .dram0_io_cke                       (dram0_io_cke_buf2),
    .dram0_io_drive_data                (dram0_io_drive_data_buf2),
    .dram0_io_pad_enable                (dram0_io_pad_enable_buf2),
    .dram0_io_drive_enable              (dram0_io_drive_enable_buf2),
    .dram0_io_channel_disabled          (dram0_io_channel_disabled_buf2),
    .dram0_io_cas_l                     (dram0_io_cas_l_buf2),
    .dram0_io_clk_enable                (dram0_io_clk_enable_buf2),
    .dram0_io_pad_clk_inv               (dram0_io_pad_clk_inv_buf2),
    .ddr0_dll_bypass_l			(ctu_dll0_byp_l),
    .ddr0_bypass_data			(ctu_dll0_byp_val[]),
    .ddr0_lpf_code			(ctu_dll0_ctu_ctrl[]),
    ); */
//
`ifdef RTL_PAD_DDR0
   pad_ddr0 pad_ddr0
   (
    .serial_out                         ({ddr0_sot[143:124],
                                        /*ddr0_sot[    123]=DQ[ 59]*/ ser_scan_out[6],
                                        /*ddr0_sot[    122]=DQ[ 58]*/ par_scan_head[6],
                                        /*ddr0_sot[    121]=DQ[ 57]*/ ser_scan_out[5],
                                        /*ddr0_sot[    120]=DQ[ 56]*/ par_scan_head[5],
                                          ddr0_sot[119: 76],
                                        /*ddr0_sot[     75]=DQ[ 35]*/ ser_scan_out[4],
                                        /*ddr0_sot[     74]=DQ[ 34]*/ par_scan_head[4],
                                        /*ddr0_sot[     73]=DQ[ 33]*/ ser_scan_out[3],
                                        /*ddr0_sot[     72]=DQ[ 32]*/ par_scan_head[3],
                                          ddr0_sot[ 71: 36],
                                        /*ddr0_sot[     35]=DQ[ 19]*/ ser_scan_out[2],
                                        /*ddr0_sot[     34]=DQ[ 18]*/ par_scan_head[2],
                                        /*ddr0_sot[     33]=DQ[ 17]*/ ser_scan_out[1],
                                        /*ddr0_sot[     32]=DQ[ 16]*/ par_scan_head[1],
                                          ddr0_sot[ 31:  0]}),

    .serial_in                          ({ddr0_sin[143:124],
                                        /*ddr0_sin[    123]=DQ[ 59]*/ par_scan_tail[6],
                                        /*ddr0_sin[    122]=DQ[ 58]*/ ser_scan_out[5],
                                        /*ddr0_sin[    121]=DQ[ 57]*/ par_scan_tail[5],
                                        /*ddr0_sin[    120]=DQ[ 56]*/ ser_scan_out[4],
                                          ddr0_sin[119: 76],
                                        /*ddr0_sin[     75]=DQ[ 35]*/ par_scan_tail[4],
                                        /*ddr0_sin[     74]=DQ[ 34]*/ ser_scan_out[3],
                                        /*ddr0_sin[     73]=DQ[ 33]*/ par_scan_tail[3],
                                        /*ddr0_sin[     72]=DQ[ 32]*/ ser_scan_out[2],
                                          ddr0_sin[ 71: 36],
                                        /*ddr0_sin[     35]=DQ[ 19]*/ par_scan_tail[2],
                                        /*ddr0_sin[     34]=DQ[ 18]*/ ser_scan_out[1],
                                        /*ddr0_sin[     33]=DQ[ 17]*/ par_scan_tail[1],
                                        /*ddr0_sot[     32]=DQ[ 16]*/ ser_scan_out[0],
                                          ddr0_sin[ 31:  0]}),

    .afi                                ({ddr0_afi[143:131],
                                        /*ddr0_afi[    130]=DQ[122]*/ afi_tsr_tsel[5],
                                          ddr0_afi[    129],
                                        /*ddr0_afi[    128]=DQ[120]*/ afi_tsr_tsel[4],
                                          ddr0_afi[    127],
                                        /*ddr0_afi[    126]=DQ[ 62]*/ afi_tsr_tsel[7],
                                          ddr0_afi[    125],
                                        /*ddr0_afi[    124]=DQ[ 60]*/ afi_tsr_tsel[6],
                                          ddr0_afi[    123],
                                        /*ddr0_afi[    122]=DQ[ 58]*/ afi_rt_data_in[6],
                                          ddr0_afi[    121],
                                        /*ddr0_afi[    120]=DQ[ 56]*/ afi_rt_data_in[5],
                                          ddr0_afi[    119],
                                        /*ddr0_afi[    118]=DQ[118]*/ afi_rng_ctl[2],
                                          ddr0_afi[    117],
                                        /*ddr0_afi[    116]=DQ[116]*/ afi_rng_ctl[1],
                                          ddr0_afi[    115],
                                        /*ddr0_afi[    114]=DQ[114]*/ afi_tsr_tsel[1],
                                          ddr0_afi[    113],
                                        /*ddr0_afi[    112]=DQ[112]*/ afi_tsr_tsel[0],
                                          ddr0_afi[    111],
                                        /*ddr0_afi[    110]=DQ[ 54]*/ afi_tsr_tsel[3],
                                          ddr0_afi[    109],
                                        /*ddr0_afi[    108]=DQ[ 52]*/ afi_tsr_tsel[2],
                                          ddr0_afi[    107],
                                          ddr0_afi[106:103],
                                        /*ddr0_afi[    102]=DQ[110]*/ afi_rng_ctl[0],
                                          ddr0_afi[101: 75],
                                        /*ddr0_afi[     74]=DQ[ 34]*/ afi_rt_data_in[4],
                                          ddr0_afi[     73],
                                        /*ddr0_afi[     72]=DQ[ 32]*/ afi_rt_data_in[3],
                                          ddr0_afi[ 71: 35],
                                        /*ddr0_afi[     34]=DQ[ 18]*/ afi_rt_data_in[2],
                                          ddr0_afi[     33],
                                        /*ddr0_afi[     32]=DQ[ 16]*/ afi_rt_data_in[1],
                                          ddr0_afi[ 31:  3],
                                        /*ddr0_afi[      2]=DQ[  2]*/ afi_rt_data_in[0],
                                          ddr0_afi[  1:  0]}),

    .afo                                ({ddr0_afo[143:132],
                                        /*ddr0_afo[    131]=DQ[123]*/ afo_tsr_dout[5],
                                          ddr0_afo[    130],
                                        /*ddr0_afo[    129]=DQ[121]*/ afo_tsr_dout[4],
                                          ddr0_afo[    128],
                                        /*ddr0_afo[    127]=DQ[ 63]*/ afo_tsr_dout[7],
                                          ddr0_afo[    126],
                                        /*ddr0_afo[    125]=DQ[ 61]*/ afo_tsr_dout[6],
                                          ddr0_afo[    124],
                                        /*ddr0_afo[    123]=DQ[ 59]*/ afo_rt_data_out[6],
                                          ddr0_afo[    122],
                                        /*ddr0_afo[    121]=DQ[ 57]*/ afo_rt_data_out[5],
                                          ddr0_afo[    120],
                                        /*ddr0_afo[    119]=DQ[119]*/ afo_rng_data,
                                          ddr0_afo[118:116],
                                        /*ddr0_afo[    115]=DQ[115]*/ afo_tsr_dout[1],
                                          ddr0_afo[114:112],
                                        /*ddr0_afo[    111]=DQ[ 55]*/ afo_tsr_dout[3],
                                          ddr0_afo[    110],
                                        /*ddr0_afo[    109]=DQ[ 53]*/ afo_tsr_dout[2],
                                          ddr0_afo[    108],
                                        /*ddr0_afo[    107]=DQ[ 51]*/ afo_rng_clk,
                                          ddr0_afo[    106],
                                        /*ddr0_afo[    105]=DQ[ 49]*/ afo_tsr_dout[0],
                                          ddr0_afo[104: 76],
                                        /*ddr0_afo[     75]=DQ[ 35]*/ afo_rt_data_out[4],
                                          ddr0_afo[     74],
                                        /*ddr0_afo[     73]=DQ[ 33]*/ afo_rt_data_out[3],
                                          ddr0_afo[ 72: 36],
                                        /*ddr0_afo[     35]=DQ[ 19]*/ afo_rt_data_out[2],
                                          ddr0_afo[     34],
                                        /*ddr0_afo[     33]=DQ[ 17]*/ afo_rt_data_out[1],
                                          ddr0_afo[ 32:  4],
                                        /*ddr0_afo[      3]=DQ[  3]*/ afo_rt_data_out[0],
                                          ddr0_afo[  2:  0]}),

     /*AUTOINST*/
    // Outputs
    .ddr0_lpf_code			(ctu_dll0_ctu_ctrl[4:0]), // Templated
    .dram0_addr				(DRAM0_ADDR[14:0]),	 // Templated
    .dram0_ba				(DRAM0_BA[2:0]),	 // Templated
    .dram0_cs_l				(DRAM0_CS_L[3:0]),	 // Templated
    .dram0_ck_n				(DRAM0_CK_N[3:0]),	 // Templated
    .dram0_ck_p				(DRAM0_CK_P[3:0]),	 // Templated
    .ddr0_ddr1_cbd			(ddr0_ddr1_cbd[8:1]),
    .ddr0_ddr1_cbu			(ddr0_ddr1_cbu[8:1]),
    .io_dram0_data_in			(io_dram0_data_in[255:0]),
    .io_dram0_ecc_in			(io_dram0_ecc_in[31:0]),
    .ddr_so				(pddr0_jbi_so),		 // Templated
    .pad_ddr0_sscan_out			(ddr0_ctu_bso),		 // Templated
    .bscan_hiz_l_out			(),			 // Templated
    .bscan_shift_dr_out			(),			 // Templated
    .ps_select_out			(),			 // Templated
    .bscan_update_dr_out		(),			 // Templated
    .bypass_enable_out			(),			 // Templated
    .bscan_clock_dr_out			(),			 // Templated
    .bscan_mode_ctl_out			(),			 // Templated
    .dram0_we_l				(DRAM0_WE_L),		 // Templated
    .dram0_cas_l			(DRAM0_CAS_L),		 // Templated
    .dram0_ras_l			(DRAM0_RAS_L),		 // Templated
    .dram0_cke				(DRAM0_CKE),		 // Templated
    .pad_ddr0_bso			(ddr0_ddr0_bso),	 // Templated
    .ddr0_ctu_dll_overflow		(ddr0_ctu_dll_overflow),
    .io_dram0_data_valid		(io_dram0_data_valid),
    .ddr0_ctu_dll_lock			(ddr0_ctu_dll_lock),
    // Inouts
    .spare_ddr0_pin			(SPARE_DDR0_PIN),	 // Templated
    .clkobs				(CLKOBS[1:0]),		 // Templated
    .spare_ddr0_pad			(SPARE_DDR0_PAD[6:0]),	 // Templated
    .dram0_dq				(DRAM0_DQ[127:0]),	 // Templated
    .dram0_dqs				(DRAM0_DQS[35:0]),	 // Templated
    .dram0_cb				(DRAM0_CB[15:0]),	 // Templated
    // Inputs
    .spare_ddr0_paddata			(7'b0101010),		 // Templated
    .ddr0_bypass_data			(ctu_dll0_byp_val[4:0]), // Templated
    .spare_ddr0_pindata			(1'b0),			 // Templated
    .ctu_io_clkobs			(ctu_io_clkobs[1:0]),
    .ctu_ddr0_dll_delayctr		(ctu_ddr0_dll_delayctr[2:0]),
    .dram0_io_ptr_clk_inv		(dram0_io_ptr_clk_inv_buf2[4:0]), // Templated
    .dram_gclk				({dram_gclk_c0_r[3],dram_gclk_c0_r[1]}), // Templated
    .dram0_io_addr			(dram0_io_addr_buf2[14:0]), // Templated
    .dram0_io_data_out			(dram0_io_data_out_buf2[287:0]), // Templated
    .dram0_io_cs_l			(dram0_io_cs_l_buf2[3:0]), // Templated
    .dram0_io_bank			(dram0_io_bank_buf2[2:0]), // Templated
    .bscan_mode_ctl_in			(ctu_ddr0_mode_ctl),	 // Templated
    .ddr_si				(par_scan_head[6]),	 // Templated
    .ddr0_dll_bypass_l			(ctu_dll0_byp_l),	 // Templated
    .tck				(ctu_ddr0_clock_dr),	 // Templated
    .ddr_testmode_l			(ctu_ddr_testmode_l),	 // Templated
    .ddr_se				(global_shift_enable),	 // Templated
    .ps_select				(pscan_select),		 // Templated
    .bypass_enable			(global_scan_bypass_en), // Templated
    .vdd18				(VDDL18),		 // Templated
    .test_mode				(io_test_mode),		 // Templated
    .bscan_hiz_l_in			(ctu_ddr0_hiz_l),	 // Templated
    .ctu_ddr0_iodll_rst_l		(ctu_ddr0_iodll_rst_l),
    .dram_adbginit_l			(dram_adbginit_l),
    .dram_arst_l			(dram_arst_l),
    .dram_gdbginit_l			(dram_gdbginit_l),
    .bscan_clock_dr_in			(ctu_ddr0_clock_dr),	 // Templated
    .pad_ddr0_bsi			(dbg_ddr0_bso),		 // Templated
    .pad_ddr0_sscan_in			(ddr0_ddr0_bso),	 // Templated
    .ctu_io_sscan_se			(ctu_ddr0_shift_dr),	 // Templated
    .ctu_io_sscan_update		(ctu_pads_sscan_update), // Templated
    .ctu_global_snap			(ctu_global_snap),
    .dram01_p_ref_res			(DRAM01_P_REF_RES),	 // Templated
    .bscan_shift_dr_in			(ctu_ddr0_shift_dr),	 // Templated
    .dram01_n_ref_res			(DRAM01_N_REF_RES),	 // Templated
    .bscan_update_dr_in			(ctu_ddr0_update_dr),	 // Templated
    .dram0_io_write_en_l		(dram0_io_write_en_l_buf2), // Templated
    .dram0_io_ras_l			(dram0_io_ras_l_buf2),	 // Templated
    .dram0_io_cke			(dram0_io_cke_buf2),	 // Templated
    .dram0_io_drive_data		(dram0_io_drive_data_buf2), // Templated
    .dram0_io_pad_enable		(dram0_io_pad_enable_buf2), // Templated
    .dram0_io_drive_enable		(dram0_io_drive_enable_buf2), // Templated
    .dram0_io_channel_disabled		(dram0_io_channel_disabled_buf2), // Templated
    .dram_grst_l			(dram_grst_l),
    .clk_ddr0_cken			(ctu_ddr0_dram_cken),	 // Templated
    .dram0_io_cas_l			(dram0_io_cas_l_buf2),	 // Templated
    .dram0_io_clk_enable		(dram0_io_clk_enable_buf2), // Templated
    .dram0_io_pad_clk_inv		(dram0_io_pad_clk_inv_buf2)); // Templated
`endif
//


/* pad_ddr1 AUTO_TEMPLATE (
    .dram1_ras_l                        (DRAM1_RAS_L),
    .dram1_cas_l                        (DRAM1_CAS_L),
    .dram1_we_l                         (DRAM1_WE_L),
    .dram1_cs_l                         (DRAM1_CS_L[]),
    .dram1_cke                          (DRAM1_CKE),
    .dram1_addr                         (DRAM1_ADDR[]),
    .dram1_ba                           (DRAM1_BA[]),
    .dram1_dq                           (DRAM1_DQ[]),
    .dram1_cb                           (DRAM1_CB[]),
    .dram1_dqs                          (DRAM1_DQS[]),
    .dram1_ck_p                         (DRAM1_CK_P[]),
    .dram1_ck_n                         (DRAM1_CK_N[]),
    .spare_ddr1_pin			(SPARE_DDR1_PIN[]),
    .spare_ddr1_pindata			(3'b010),
    .spare_ddr1_pad                     (SPARE_DDR1_PAD[]),
    .spare_ddr1_paddata                 (7'b0101010),

    .dram_gclk                          ({dram_gclk_c0_r[7],dram_gclk_c0_r[5]}),
    .clk_ddr1_cken                      (ctu_ddr1_dram_cken),

    .bscan_\(.*\)_out                   (),
    .pad_ddr1_bsi                       (ctu_ddr1_bso),
    .ddr_si                             (pdbg_pddr1_so),

    .bscan_\(.*\)_in			(ctu_ddr1_\1),
    .pad_ddr1_bso                       (ddr1_jbusl_bso),
    .ddr_so                             (pddr1_pjbusl_so),

    .ddr_se                             (global_shift_enable),

    .test_mode                		(io_test_mode),

    .ddr_testmode_l                     (ctu_ddr_testmode_l),

    .bypass_enable                      (global_scan_bypass_en),
    .bypass_enable_out                  (),

    .ps_select                          (pscan_select),
    .ps_select_out                      (),

    .vdd18                              (VDDL18),

    .io_dram1_data_in                   (io_dram1_data_in[]),
    .io_dram1_ecc_in                    (io_dram1_ecc_in[]),
    .io_dram1_data_valid                (io_dram1_data_valid),

    .dram1_io_bank                      (dram1_io_bank_buf2[]),
    .dram1_io_cs_l                      (dram1_io_cs_l_buf2[]),
    .dram1_io_ptr_clk_inv               (dram1_io_ptr_clk_inv_buf2[]),
    .dram1_io_addr                      (dram1_io_addr_buf2[]),
    .dram1_io_data_out                  (dram1_io_data_out_buf2[]),
    .dram1_io_pad_enable                (dram1_io_pad_enable_buf2),
    .dram1_io_drive_enable              (dram1_io_drive_enable_buf2),
    .dram1_io_write_en_l                (dram1_io_write_en_l_buf2),
    .dram1_io_cas_l                     (dram1_io_cas_l_buf2),
    .dram1_io_ras_l                     (dram1_io_ras_l_buf2),
    .dram1_io_clk_enable                (dram1_io_clk_enable_buf2),
    .dram1_io_channel_disabled          (dram1_io_channel_disabled_buf2),
    .dram1_io_drive_data                (dram1_io_drive_data_buf2),
    .dram1_io_cke                       (dram1_io_cke_buf2),
    .dram1_io_pad_clk_inv               (dram1_io_pad_clk_inv_buf2),
    .ddr1_dll_bypass_l			(ctu_dll1_byp_l),
    .ddr1_bypass_data			(ctu_dll1_byp_val[]),
    .ddr1_lpf_code			(ctu_dll1_ctu_ctrl[]),
    ); */
//
`ifdef RTL_PAD_DDR1
   pad_ddr1 pad_ddr1
   (
    .serial_out                         ({ddr1_sot[143:92],
                                        /*ddr1_sot[     91]=DQ[ 43]*/ ser_scan_out[12],
                                        /*ddr1_sot[     90]=DQ[ 42]*/ par_scan_head[12],
                                        /*ddr1_sot[     89]=DQ[ 41]*/ ser_scan_out[11],
                                        /*ddr1_sot[     88]=DQ[ 40]*/ par_scan_head[11],
                                          ddr1_sot[ 87: 52],
                                        /*ddr1_sot[     51]=DQ[ 27]*/ ser_scan_out[10],
                                        /*ddr1_sot[     50]=DQ[ 26]*/ par_scan_head[10],
                                        /*ddr1_sot[     49]=DQ[ 25]*/ ser_scan_out[9],
                                        /*ddr1_sot[     48]=DQ[ 24]*/ par_scan_head[9],
                                          ddr1_sot[ 47:  4],
                                        /*ddr1_sot[      3]=DQ[  3]*/ ser_scan_out[8],
                                        /*ddr1_sot[      2]=DQ[  2]*/ par_scan_head[8],
                                        /*ddr1_sot[      1]=DQ[  1]*/ ser_scan_out[7],
                                        /*ddr1_sot[      0]=DQ[  0]*/ par_scan_head[7]}),

    .serial_in                          ({ddr1_sin[143:92],
                                        /*ddr1_sin[     91]=DQ[ 43]*/ par_scan_tail[12],
                                        /*ddr1_sin[     90]=DQ[ 42]*/ ser_scan_out[11],
                                        /*ddr1_sin[     89]=DQ[ 41]*/ par_scan_tail[11],
                                        /*ddr1_sin[     88]=DQ[ 40]*/ ser_scan_out[10],
                                          ddr1_sin[ 87: 52],
                                        /*ddr1_sin[     51]=DQ[ 27]*/ par_scan_tail[10],
                                        /*ddr1_sin[     50]=DQ[ 26]*/ ser_scan_out[9],
                                        /*ddr1_sin[     49]=DQ[ 25]*/ par_scan_tail[9],
                                        /*ddr1_sin[     48]=DQ[ 24]*/ ser_scan_out[8],
                                          ddr1_sin[ 47:  4],
                                        /*ddr1_sin[      3]=DQ[  3]*/ par_scan_tail[8],
                                        /*ddr1_sin[      2]=DQ[  2]*/ ser_scan_out[7],
                                        /*ddr1_sin[      1]=DQ[  1]*/ par_scan_tail[7],
                                        /*ddr1_sin[      0]=DQ[  0]*/ ser_scan_out[6]}),

    .afi                                ({ddr1_afi[143:105],
                                        /*ddr1_afi[    104]=DQ[ 48]*/ afi_bist_mode,
                                          ddr1_afi[103: 91],
                                        /*ddr1_afi[     90]=DQ[ 42]*/ afi_rt_data_in[12],
                                          ddr1_afi[     89],
                                        /*ddr1_afi[     88]=DQ[ 40]*/ afi_rt_data_in[11],
                                          ddr1_afi[ 87: 75],
                                        /*ddr1_afi[     74]=DQ[ 34]*/ afi_bypass_mode,
                                          ddr1_afi[ 73: 71],
                                        /*ddr1_afi[     70]=DQ[ 94]*/ afi_pll_trst_l,
                                          ddr1_afi[     69],
                                        /*ddr1_afi[     68]=DQ[ 92]*/ afi_pll_div2[5],
                                          ddr1_afi[ 67 :65],
                                        /*ddr1_afi[     64]=DQ[ 88]*/ afi_pll_char_mode,
                                          ddr1_afi[ 63: 55],
                                        /*ddr1_afi[     54]=DQ[ 30]*/ afi_pll_div2[4],
                                          ddr1_afi[     53],
                                        /*ddr1_afi[     52]=DQ[ 28]*/ afi_pll_div2[3],
                                          ddr1_afi[     51],
                                        /*ddr1_afi[     50]=DQ[ 26]*/ afi_rt_data_in[10],
                                          ddr1_afi[     49],
                                        /*ddr1_afi[     48]=DQ[ 24]*/ afi_rt_data_in[9],
                                          ddr1_afi[     47],
                                        /*ddr1_afi[     46]=DQ[ 86]*/ afi_pll_div2[2],
                                          ddr1_afi[     45],
                                        /*ddr1_afi[     44]=DQ[ 84]*/ afi_pll_div2[1],
                                          ddr1_afi[     43],
                                        /*ddr1_afi[     42]=DQ[ 82]*/ afi_pll_div2[0],
                                          ddr1_afi[     41],
                                        /*ddr1_afi[     40]=DQ[ 80]*/ afi_pll_clamp_fltr,
                                          ddr1_afi[ 39: 35],
                                        /*ddr1_afi[     34]=DQ[ 18]*/ afi_rt_read_write,
                                          ddr1_afi[     33],
                                        /*ddr1_afi[     32]=DQ[ 16]*/ afi_rt_high_low,
                                          ddr1_afi[     31],
                                        /*ddr1_afi[     30]=DQ[ 78]*/ afi_tsr_mode,
                                          ddr1_afi[     29],
                                        /*ddr1_afi[     28]=DQ[ 76]*/ afi_tsr_div[9],
                                          ddr1_afi[     27],
                                        /*ddr1_afi[     26]=DQ[ 74]*/ afi_tsr_div[8],
                                          ddr1_afi[     25],
                                        /*ddr1_afi[     24]=DQ[ 72]*/ afi_tsr_div[7],
                                          ddr1_afi[ 23: 19],
                                        /*ddr1_afi[     18]=DQ[ 10]*/ afi_rt_valid,
                                          ddr1_afi[     17],
                                        /*ddr1_afi[     16]=DQ[  8]*/ afi_rt_addr_data,
                                          ddr1_afi[     15],
                                        /*ddr1_afi[     14]=DQ[ 70]*/ afi_tsr_div[6],
                                          ddr1_afi[     13],
                                        /*ddr1_afi[     12]=DQ[ 68]*/ afi_tsr_div[5],
                                          ddr1_afi[     11],
                                        /*ddr1_afi[     10]=DQ[ 66]*/ afi_tsr_div[4],
                                          ddr1_afi[      9],
                                        /*ddr1_afi[      8]=DQ[ 64]*/ afi_tsr_div[3],
                                          ddr1_afi[      7],
                                        /*ddr1_afi[      6]=DQ[  6]*/ afi_tsr_div[2],
                                          ddr1_afi[      5],
                                        /*ddr1_afi[      4]=DQ[  4]*/ afi_tsr_div[1],
                                          ddr1_afi[      3],
                                        /*ddr1_afi[      2]=DQ[  2]*/ afi_rt_data_in[8],
                                          ddr1_afi[      1],
                                        /*ddr1_afi[      0]=DQ[  0]*/ afi_rt_data_in[7]}),

    .afo                                ({ddr1_afo[143:92],
                                        /*ddr1_afo[     91]=DQ[ 43]*/ afo_rt_data_out[12],
                                          ddr1_afo[     90],
                                        /*ddr1_afo[     89]=DQ[ 41]*/ afo_rt_data_out[11],
                                          ddr1_afo[ 88: 52],
                                        /*ddr1_afo[     51]=DQ[ 27]*/ afo_rt_data_out[10],
                                          ddr1_afo[     50],
                                        /*ddr1_afo[     49]=DQ[ 25]*/ afo_rt_data_out[9],
                                          ddr1_afo[ 48: 18],
                                        /*ddr1_afo[     17]=DQ[  9]*/ afo_rt_ack,
                                          ddr1_afo[ 16:  4],
                                        /*ddr1_afo[      3]=DQ[  3]*/ afo_rt_data_out[8],
                                          ddr1_afo[      2],
                                        /*ddr1_afo[      1]=DQ[  1]*/ afo_rt_data_out[7],
                                          ddr1_afo[      0]}),

     /*AUTOINST*/
    // Outputs
    .ddr1_lpf_code			(ctu_dll1_ctu_ctrl[4:0]), // Templated
    .dram1_ck_p				(DRAM1_CK_P[3:0]),	 // Templated
    .dram1_ba				(DRAM1_BA[2:0]),	 // Templated
    .dram1_addr				(DRAM1_ADDR[14:0]),	 // Templated
    .dram1_ck_n				(DRAM1_CK_N[3:0]),	 // Templated
    .io_dram1_data_in			(io_dram1_data_in[255:0]), // Templated
    .io_dram1_ecc_in			(io_dram1_ecc_in[31:0]), // Templated
    .dram1_cs_l				(DRAM1_CS_L[3:0]),	 // Templated
    .ddr_so				(pddr1_pjbusl_so),	 // Templated
    .bscan_update_dr_out		(),			 // Templated
    .bscan_shift_dr_out			(),			 // Templated
    .bscan_clock_dr_out			(),			 // Templated
    .bscan_hiz_l_out			(),			 // Templated
    .bypass_enable_out			(),			 // Templated
    .ps_select_out			(),			 // Templated
    .bscan_mode_ctl_out			(),			 // Templated
    .pad_ddr1_bso			(ddr1_jbusl_bso),	 // Templated
    .dram1_cas_l			(DRAM1_CAS_L),		 // Templated
    .dram1_ras_l			(DRAM1_RAS_L),		 // Templated
    .dram1_cke				(DRAM1_CKE),		 // Templated
    .ddr1_ctu_dll_lock			(ddr1_ctu_dll_lock),
    .dram1_we_l				(DRAM1_WE_L),		 // Templated
    .ddr1_ctu_dll_overflow		(ddr1_ctu_dll_overflow),
    .io_dram1_data_valid		(io_dram1_data_valid),	 // Templated
    // Inouts
    .spare_ddr1_pin			(SPARE_DDR1_PIN[2:0]),	 // Templated
    .spare_ddr1_pad			(SPARE_DDR1_PAD[6:0]),	 // Templated
    .dram1_dq				(DRAM1_DQ[127:0]),	 // Templated
    .dram1_cb				(DRAM1_CB[15:0]),	 // Templated
    .dram1_dqs				(DRAM1_DQS[35:0]),	 // Templated
    // Inputs
    .ddr1_bypass_data			(ctu_dll1_byp_val[4:0]), // Templated
    .spare_ddr1_pindata			(3'b010),		 // Templated
    .spare_ddr1_paddata			(7'b0101010),		 // Templated
    .ddr0_ddr1_cbu			(ddr0_ddr1_cbu[8:1]),
    .dram1_io_ptr_clk_inv		(dram1_io_ptr_clk_inv_buf2[4:0]), // Templated
    .dram1_io_bank			(dram1_io_bank_buf2[2:0]), // Templated
    .dram_gclk				({dram_gclk_c0_r[7],dram_gclk_c0_r[5]}), // Templated
    .ddr0_ddr1_cbd			(ddr0_ddr1_cbd[8:1]),
    .ctu_ddr1_dll_delayctr		(ctu_ddr1_dll_delayctr[2:0]),
    .dram1_io_cs_l			(dram1_io_cs_l_buf2[3:0]), // Templated
    .dram1_io_addr			(dram1_io_addr_buf2[14:0]), // Templated
    .dram1_io_data_out			(dram1_io_data_out_buf2[287:0]), // Templated
    .ddr_testmode_l			(ctu_ddr_testmode_l),	 // Templated
    .ddr1_dll_bypass_l			(ctu_dll1_byp_l),	 // Templated
    .bscan_mode_ctl_in			(ctu_ddr1_mode_ctl),	 // Templated
    .ps_select				(pscan_select),		 // Templated
    .ddr_se				(global_shift_enable),	 // Templated
    .ddr_si				(pdbg_pddr1_so),	 // Templated
    .bscan_hiz_l_in			(ctu_ddr1_hiz_l),	 // Templated
    .test_mode				(io_test_mode),		 // Templated
    .bypass_enable			(global_scan_bypass_en), // Templated
    .dram_arst_l			(dram_arst_l),
    .dram_gdbginit_l			(dram_gdbginit_l),
    .clk_ddr1_cken			(ctu_ddr1_dram_cken),	 // Templated
    .dram_grst_l			(dram_grst_l),
    .vdd18				(VDDL18),		 // Templated
    .bscan_clock_dr_in			(ctu_ddr1_clock_dr),	 // Templated
    .ctu_ddr1_iodll_rst_l		(ctu_ddr1_iodll_rst_l),
    .dram1_io_pad_enable		(dram1_io_pad_enable_buf2), // Templated
    .pad_ddr1_bsi			(ctu_ddr1_bso),		 // Templated
    .dram_adbginit_l			(dram_adbginit_l),
    .bscan_shift_dr_in			(ctu_ddr1_shift_dr),	 // Templated
    .dram1_io_write_en_l		(dram1_io_write_en_l_buf2), // Templated
    .bscan_update_dr_in			(ctu_ddr1_update_dr),	 // Templated
    .dram1_io_drive_enable		(dram1_io_drive_enable_buf2), // Templated
    .dram1_io_cas_l			(dram1_io_cas_l_buf2),	 // Templated
    .dram1_io_ras_l			(dram1_io_ras_l_buf2),	 // Templated
    .dram1_io_clk_enable		(dram1_io_clk_enable_buf2), // Templated
    .dram1_io_channel_disabled		(dram1_io_channel_disabled_buf2), // Templated
    .dram1_io_drive_data		(dram1_io_drive_data_buf2), // Templated
    .dram1_io_cke			(dram1_io_cke_buf2),	 // Templated
    .dram1_io_pad_clk_inv		(dram1_io_pad_clk_inv_buf2)); // Templated
`endif
//


/* pad_ddr2 AUTO_TEMPLATE (
    .dram2_ras_l                        (DRAM2_RAS_L),
    .dram2_cas_l                        (DRAM2_CAS_L),
    .dram2_we_l                         (DRAM2_WE_L),
    .dram2_cs_l                         (DRAM2_CS_L[]),
    .dram2_cke                          (DRAM2_CKE),
    .dram2_addr                         (DRAM2_ADDR[]),
    .dram2_ba                           (DRAM2_BA[]),
    .dram2_dq                           (DRAM2_DQ[]),
    .dram2_cb                           (DRAM2_CB[]),
    .dram2_dqs                          (DRAM2_DQS[]),
    .dram2_ck_p                         (DRAM2_CK_P[]),
    .dram2_ck_n                         (DRAM2_CK_N[]),
    .dram23_p_ref_res                   (DRAM23_P_REF_RES),
    .dram23_n_ref_res                   (DRAM23_N_REF_RES),
    .spare_ddr2_pin                     (SPARE_DDR2_PIN[]),
    .spare_ddr2_pindata                 (3'b010),
    .spare_ddr2_pad                     (SPARE_DDR2_PAD[]),
    .spare_ddr2_paddata                 (7'b0101010),

    .dram_gclk                          ({dram_gclk_c3_r[3],dram_gclk_c3_r[1]}),
    .io_pwron_rst_l                     (dram_arst_l),
    .clk_ddr2_cken                      (ctu_ddr2_dram_cken),

    .bscan_\(.*\)_out                   (),
    .pad_ddr2_bsi                       (ddr3_ddr2_bso),
    .ddr_si                             (pmisc_pddr2_so),

    .bscan_\(.*\)_in			(ctu_ddr2_\1),
    .pad_ddr2_bso                       (ddr2_ddr2_bso),
    .ddr_so                             (pddr2_rsc22_so),

    .ddr_se                             (global_shift_enable),

    .test_mode                		(io_test_mode),

    .tck                                (ctu_ddr2_clock_dr),
    .ddr_testmode_l                     (ctu_ddr_testmode_l),

    .pad_ddr2_sscan_in                  (ddr2_ddr2_bso),
    .pad_ddr2_sscan_out                 (ddr2_misc_sscan_out),

    .ctu_io_sscan_se                    (ctu_ddr2_shift_dr),
    .ctu_io_sscan_update                (ctu_pads_sscan_update),
    .bypass_enable                      (global_scan_bypass_en),
    .bypass_enable_out                  (),

    .ps_select                          (pscan_select),
    .ps_select_out                      (),

    .vdd18                              (VDDR18),

    .io_dram2_data_in                   (io_dram2_data_in[]),
    .io_dram2_ecc_in                    (io_dram2_ecc_in[]),
    .io_dram2_data_valid                (io_dram2_data_valid),

    .dram2_io_bank                      (dram2_io_bank_buf2[]),
    .dram2_io_cs_l                      (dram2_io_cs_l_buf2[]),
    .dram2_io_ptr_clk_inv               (dram2_io_ptr_clk_inv_buf2[]),
    .dram2_io_addr                      (dram2_io_addr_buf2[]),
    .dram2_io_data_out                  (dram2_io_data_out_buf2[]),
    .dram2_io_pad_enable                (dram2_io_pad_enable_buf2),
    .dram2_io_drive_enable              (dram2_io_drive_enable_buf2),
    .dram2_io_write_en_l                (dram2_io_write_en_l_buf2),
    .dram2_io_cas_l                     (dram2_io_cas_l_buf2),
    .dram2_io_ras_l                     (dram2_io_ras_l_buf2),
    .dram2_io_clk_enable                (dram2_io_clk_enable_buf2),
    .dram2_io_channel_disabled          (dram2_io_channel_disabled_buf2),
    .dram2_io_drive_data                (dram2_io_drive_data_buf2),
    .dram2_io_cke                       (dram2_io_cke_buf2),
    .dram2_io_pad_clk_inv               (dram2_io_pad_clk_inv_buf2),
    .ddr2_dll_bypass_l			(ctu_dll2_byp_l),
    .ddr2_bypass_data			(ctu_dll2_byp_val[]),
    .ddr2_lpf_code			(ctu_dll2_ctu_ctrl[]),
    ); */
//
`ifdef RTL_PAD_DDR2
   pad_ddr2 pad_ddr2
   (
    .serial_out                         ({ddr2_sot[143:92],
                                        /*ddr2_sot[     91]=DQ[ 43]*/ ser_scan_out[24],
                                        /*ddr2_sot[     90]=DQ[ 42]*/ par_scan_head[24],
                                        /*ddr2_sot[     89]=DQ[ 41]*/ ser_scan_out[25],
                                        /*ddr2_sot[     88]=DQ[ 40]*/ par_scan_head[25],
                                          ddr2_sot[ 87: 68],
                                        /*ddr2_sot[     67]=DQ[ 91]*/ ser_scan_out[26],
                                        /*ddr2_sot[     66]=DQ[ 90]*/ par_scan_head[26],
                                        /*ddr2_sot[     65]=DQ[ 89]*/ ser_scan_out[27],
                                        /*ddr2_sot[     64]=DQ[ 88]*/ par_scan_head[27],
                                          ddr2_sot[ 63: 36],
                                        /*ddr2_sot[     35]=DQ[ 19]*/ ser_scan_out[28],
                                        /*ddr2_sot[     34]=DQ[ 18]*/ par_scan_head[28],
                                        /*ddr2_sot[     33]=DQ[ 17]*/ ser_scan_out[29],
                                        /*ddr2_sot[     32]=DQ[ 16]*/ par_scan_head[29],
                                          ddr2_sot[ 31: 18],
                                        /*ddr2_sot[     17]=DQ[  9]*/ ser_scan_out[30],
                                        /*ddr2_sot[     16]=DQ[  8]*/ par_scan_head[30],
                                          ddr2_sot[ 15:  0]}),

    .serial_in                          ({ddr2_sin[143:92],
                                        /*ddr2_sin[     91]=DQ[ 43]*/ par_scan_tail[24],
                                        /*ddr2_sin[     90]=DQ[ 42]*/ ser_scan_out[23],
                                        /*ddr2_sin[     89]=DQ[ 41]*/ par_scan_tail[25],
                                        /*ddr2_sin[     88]=DQ[ 40]*/ ser_scan_out[24],
                                          ddr2_sin[ 87: 68],
                                        /*ddr2_sin[     67]=DQ[ 91]*/ par_scan_tail[26],
                                        /*ddr2_sin[     66]=DQ[ 90]*/ ser_scan_out[25],
                                        /*ddr2_sin[     65]=DQ[ 89]*/ par_scan_tail[27],
                                        /*ddr2_sin[     64]=DQ[ 88]*/ ser_scan_out[26],
                                          ddr2_sin[ 63: 36],
                                        /*ddr2_sin[     35]=DQ[ 19]*/ par_scan_tail[28],
                                        /*ddr2_sin[     34]=DQ[ 18]*/ ser_scan_out[27],
                                        /*ddr2_sin[     33]=DQ[ 17]*/ par_scan_tail[29],
                                        /*ddr2_sin[     32]=DQ[ 16]*/ ser_scan_out[28],
                                          ddr2_sin[ 31: 18],
                                        /*ddr2_sin[     17]=DQ[  9]*/ par_scan_tail[30],
                                        /*ddr2_sin[     16]=DQ[  8]*/ ser_scan_out[29],
                                          ddr2_sin[ 15:  0]}),

    .afi                                ({ddr2_afi[143: 91],
                                        /*ddr2_afi[     90]=DQ[ 42]*/ afi_rt_data_in[24],
                                          ddr2_afi[     89],
                                        /*ddr2_afi[     88]=DQ[ 40]*/ afi_rt_data_in[25],
                                          ddr2_afi[ 87: 67],
                                        /*ddr2_afi[     66]=DQ[ 90]*/ afi_rt_data_in[26],
                                          ddr2_afi[     65],
                                        /*ddr2_afi[     64]=DQ[ 88]*/ afi_rt_data_in[27],
                                          ddr2_afi[ 63: 35],
                                        /*ddr2_afi[     34]=DQ[ 18]*/ afi_rt_data_in[28],
                                          ddr2_afi[     33],
                                        /*ddr2_afi[     32]=DQ[ 16]*/ afi_rt_data_in[29],
                                          ddr2_afi[ 31: 17],
                                        /*ddr2_afi[     16]=DQ[  8]*/ afi_rt_data_in[30],
                                          ddr2_afi[ 15:  3],
                                        /*ddr2_afi[      2]=DQ[  2]*/ afi_rt_data_in[31],
                                          ddr2_afi[  1:  0]}),

    .afo                                ({ddr2_afo[143:92],
                                        /*ddr2_afo[     91]=DQ[ 43]*/ afo_rt_data_out[24],
                                          ddr2_afo[     90],
                                        /*ddr2_afo[     89]=DQ[ 41]*/ afo_rt_data_out[25],
                                          ddr2_afo[ 88: 68],
                                        /*ddr2_afo[     67]=DQ[ 91]*/ afo_rt_data_out[26],
                                          ddr2_afo[     66],
                                        /*ddr2_afo[     65]=DQ[ 89]*/ afo_rt_data_out[27],
                                          ddr2_afo[ 64: 36],
                                        /*ddr2_afo[     35]=DQ[ 19]*/ afo_rt_data_out[28],
                                          ddr2_afo[     34],
                                        /*ddr2_afo[     33]=DQ[ 17]*/ afo_rt_data_out[29],
                                          ddr2_afo[ 32: 18],
                                        /*ddr2_afo[     17]=DQ[  9]*/ afo_rt_data_out[30],
                                          ddr2_afo[ 16:  4],
                                        /*ddr2_afo[      3]=DQ[  3]*/ afo_rt_data_out[31],
                                          ddr2_afo[  2:  0]}),

     /*AUTOINST*/
    // Outputs
    .ddr2_lpf_code			(ctu_dll2_ctu_ctrl[4:0]), // Templated
    .dram2_ba				(DRAM2_BA[2:0]),	 // Templated
    .dram2_ck_p				(DRAM2_CK_P[3:0]),	 // Templated
    .ddr2_ddr3_cbd			(ddr2_ddr3_cbd[8:1]),
    .dram2_addr				(DRAM2_ADDR[14:0]),	 // Templated
    .dram2_ck_n				(DRAM2_CK_N[3:0]),	 // Templated
    .ddr2_ddr3_cbu			(ddr2_ddr3_cbu[8:1]),
    .io_dram2_data_in			(io_dram2_data_in[255:0]), // Templated
    .io_dram2_ecc_in			(io_dram2_ecc_in[31:0]), // Templated
    .dram2_cs_l				(DRAM2_CS_L[3:0]),	 // Templated
    .pad_ddr2_sscan_out			(ddr2_misc_sscan_out),	 // Templated
    .dram2_cas_l			(DRAM2_CAS_L),		 // Templated
    .dram2_ras_l			(DRAM2_RAS_L),		 // Templated
    .dram2_cke				(DRAM2_CKE),		 // Templated
    .bypass_enable_out			(),			 // Templated
    .bscan_shift_dr_out			(),			 // Templated
    .bscan_clock_dr_out			(),			 // Templated
    .bscan_hiz_l_out			(),			 // Templated
    .ps_select_out			(),			 // Templated
    .bscan_update_dr_out		(),			 // Templated
    .ddr2_ctu_dll_overflow		(ddr2_ctu_dll_overflow),
    .bscan_mode_ctl_out			(),			 // Templated
    .ddr_so				(pddr2_rsc22_so),	 // Templated
    .pad_ddr2_bso			(ddr2_ddr2_bso),	 // Templated
    .dram2_we_l				(DRAM2_WE_L),		 // Templated
    .ddr2_ctu_dll_lock			(ddr2_ctu_dll_lock),
    .io_dram2_data_valid		(io_dram2_data_valid),	 // Templated
    // Inouts
    .spare_ddr2_pin			(SPARE_DDR2_PIN[2:0]),	 // Templated
    .spare_ddr2_pad			(SPARE_DDR2_PAD[6:0]),	 // Templated
    .dram2_dq				(DRAM2_DQ[127:0]),	 // Templated
    .dram2_cb				(DRAM2_CB[15:0]),	 // Templated
    .dram2_dqs				(DRAM2_DQS[35:0]),	 // Templated
    // Inputs
    .ddr2_bypass_data			(ctu_dll2_byp_val[4:0]), // Templated
    .dram2_io_bank			(dram2_io_bank_buf2[2:0]), // Templated
    .ctu_ddr2_dll_delayctr		(ctu_ddr2_dll_delayctr[2:0]),
    .dram2_io_cs_l			(dram2_io_cs_l_buf2[3:0]), // Templated
    .dram_gclk				({dram_gclk_c3_r[3],dram_gclk_c3_r[1]}), // Templated
    .dram2_io_ptr_clk_inv		(dram2_io_ptr_clk_inv_buf2[4:0]), // Templated
    .spare_ddr2_paddata			(7'b0101010),		 // Templated
    .dram2_io_addr			(dram2_io_addr_buf2[14:0]), // Templated
    .dram2_io_data_out			(dram2_io_data_out_buf2[287:0]), // Templated
    .spare_ddr2_pindata			(3'b010),		 // Templated
    .ddr2_dll_bypass_l			(ctu_dll2_byp_l),	 // Templated
    .clk_ddr2_cken			(ctu_ddr2_dram_cken),	 // Templated
    .bscan_mode_ctl_in			(ctu_ddr2_mode_ctl),	 // Templated
    .bscan_hiz_l_in			(ctu_ddr2_hiz_l),	 // Templated
    .ddr_si				(pmisc_pddr2_so),	 // Templated
    .tck				(ctu_ddr2_clock_dr),	 // Templated
    .pad_ddr2_sscan_in			(ddr2_ddr2_bso),	 // Templated
    .ddr_testmode_l			(ctu_ddr_testmode_l),	 // Templated
    .bypass_enable			(global_scan_bypass_en), // Templated
    .vdd18				(VDDR18),		 // Templated
    .pad_ddr2_bsi			(ddr3_ddr2_bso),	 // Templated
    .dram_arst_l			(dram_arst_l),
    .dram_grst_l			(dram_grst_l),
    .ctu_global_snap			(ctu_global_snap),
    .dram_gdbginit_l			(dram_gdbginit_l),
    .ctu_ddr2_iodll_rst_l		(ctu_ddr2_iodll_rst_l),
    .test_mode				(io_test_mode),		 // Templated
    .bscan_clock_dr_in			(ctu_ddr2_clock_dr),	 // Templated
    .ctu_io_sscan_update		(ctu_pads_sscan_update), // Templated
    .ctu_io_sscan_se			(ctu_ddr2_shift_dr),	 // Templated
    .dram23_p_ref_res			(DRAM23_P_REF_RES),	 // Templated
    .ps_select				(pscan_select),		 // Templated
    .dram23_n_ref_res			(DRAM23_N_REF_RES),	 // Templated
    .ddr_se				(global_shift_enable),	 // Templated
    .dram_adbginit_l			(dram_adbginit_l),
    .bscan_shift_dr_in			(ctu_ddr2_shift_dr),	 // Templated
    .dram2_io_pad_enable		(dram2_io_pad_enable_buf2), // Templated
    .bscan_update_dr_in			(ctu_ddr2_update_dr),	 // Templated
    .dram2_io_drive_enable		(dram2_io_drive_enable_buf2), // Templated
    .dram2_io_write_en_l		(dram2_io_write_en_l_buf2), // Templated
    .dram2_io_cas_l			(dram2_io_cas_l_buf2),	 // Templated
    .dram2_io_ras_l			(dram2_io_ras_l_buf2),	 // Templated
    .dram2_io_clk_enable		(dram2_io_clk_enable_buf2), // Templated
    .dram2_io_channel_disabled		(dram2_io_channel_disabled_buf2), // Templated
    .dram2_io_drive_data		(dram2_io_drive_data_buf2), // Templated
    .dram2_io_cke			(dram2_io_cke_buf2),	 // Templated
    .dram2_io_pad_clk_inv		(dram2_io_pad_clk_inv_buf2)); // Templated
`endif
//


/* pad_ddr3 AUTO_TEMPLATE (
    .dram3_ras_l                        (DRAM3_RAS_L),
    .dram3_cas_l                        (DRAM3_CAS_L),
    .dram3_we_l                         (DRAM3_WE_L),
    .dram3_cs_l                         (DRAM3_CS_L[]),
    .dram3_cke                          (DRAM3_CKE),
    .dram3_addr                         (DRAM3_ADDR[]),
    .dram3_ba                           (DRAM3_BA[]),
    .dram3_dq                           (DRAM3_DQ[]),
    .dram3_cb                           (DRAM3_CB[]),
    .dram3_dqs                          (DRAM3_DQS[]),
    .dram3_ck_p                         (DRAM3_CK_P[]),
    .dram3_ck_n                         (DRAM3_CK_N[]),
    .spare_ddr3_pin                     (SPARE_DDR3_PIN[]),
    .spare_ddr3_pindata                 (3'b010),
    .spare_ddr3_pad                     (SPARE_DDR3_PAD[]),
    .spare_ddr3_paddata                 (7'b0101010),

    .dram_gclk                          ({dram_gclk_c3_r[7],dram_gclk_c3_r[5]}),
    .clk_ddr3_cken                      (ctu_ddr3_dram_cken),

    .bscan_\(.*\)_out                   (),
    .pad_ddr3_bsi                       (jbusr_ddr3_sscan_out),
    .ddr_si                             (par_scan_head[21]),

    .bscan_\(.*\)_in			(ctu_ddr3_\1),
    .pad_ddr3_bso                       (ddr3_ddr2_bso),
    .ddr_so                             (pddr3_pjbusr_so),

    .ddr_se                             (global_shift_enable),

    .test_mode                		(io_test_mode),

    .ddr_testmode_l                     (ctu_ddr_testmode_l),

    .bypass_enable                      (global_scan_bypass_en),
    .bypass_enable_out                  (),

    .ps_select                          (pscan_select),
    .ps_select_out                      (),

    .vdd18                              (VDDR18),

    .dram3_io_ptr_clk_inv               (dram3_io_ptr_clk_inv_buf2[]),
    .dram3_io_addr                      (dram3_io_addr_buf2[]),
    .dram3_io_data_out                  (dram3_io_data_out_buf2[]),
    .dram3_io_cs_l                      (dram3_io_cs_l_buf2[]),
    .dram3_io_bank                      (dram3_io_bank_buf2[]),
    .dram3_io_write_en_l                (dram3_io_write_en_l_buf2),
    .dram3_io_ras_l                     (dram3_io_ras_l_buf2),
    .dram3_io_cke                       (dram3_io_cke_buf2),
    .dram3_io_drive_data                (dram3_io_drive_data_buf2),
    .dram3_io_pad_enable                (dram3_io_pad_enable_buf2),
    .dram3_io_drive_enable              (dram3_io_drive_enable_buf2),
    .dram3_io_channel_disabled          (dram3_io_channel_disabled_buf2),
    .dram3_io_cas_l                     (dram3_io_cas_l_buf2),
    .dram3_io_clk_enable                (dram3_io_clk_enable_buf2),
    .dram3_io_pad_clk_inv               (dram3_io_pad_clk_inv_buf2),
    .ddr3_dll_bypass_l			(ctu_dll3_byp_l),
    .ddr3_bypass_data			(ctu_dll3_byp_val[]),
    .ddr3_lpf_code			(ctu_dll3_ctu_ctrl[]),
    ); */
//
`ifdef RTL_PAD_DDR3
   pad_ddr3 pad_ddr3
   (
    .serial_out                         ({ddr3_sot[143: 76],
                                        /*ddr3_sot[     75]=DQ[ 35]*/ ser_scan_out[18],
                                        /*ddr3_sot[     74]=DQ[ 34]*/ par_scan_head[18],
                                        /*ddr3_sot[     73]=DQ[ 33]*/ ser_scan_out[19],
                                        /*ddr3_sot[     72]=DQ[ 32]*/ par_scan_head[19],
                                          ddr3_sot[ 71: 52],
                                        /*ddr3_sot[     51]=DQ[ 27]*/ ser_scan_out[20],
                                        /*ddr3_sot[     50]=DQ[ 26]*/ par_scan_head[20],
                                        /*ddr3_sot[     49]=DQ[ 25]*/ ser_scan_out[21],
                                        /*ddr3_sot[     48]=DQ[ 24]*/ par_scan_head[21],
                                          ddr3_sot[ 47: 36],
                                        /*ddr3_sot[     35]=DQ[ 19]*/ ser_scan_out[22],
                                        /*ddr3_sot[     34]=DQ[ 18]*/ par_scan_head[22],
                                        /*ddr3_sot[     33]=DQ[ 17]*/ ser_scan_out[23],
                                        /*ddr3_sot[     32]=DQ[ 16]*/ par_scan_head[23],
                                          ddr3_sot[ 31:  0]}),

    .serial_in                          ({ddr3_sin[143: 76],
                                        /*ddr3_sin[     75]=DQ[ 35]*/ par_scan_tail[18],
                                        /*ddr3_sin[     74]=DQ[ 34]*/ ser_scan_out[17],
                                        /*ddr3_sin[     73]=DQ[ 33]*/ par_scan_tail[19],
                                        /*ddr3_sin[     72]=DQ[ 32]*/ ser_scan_out[18],
                                          ddr3_sin[ 71: 52],
                                        /*ddr3_sin[     51]=DQ[ 27]*/ par_scan_tail[20],
                                        /*ddr3_sin[     50]=DQ[ 26]*/ ser_scan_out[19],
                                        /*ddr3_sin[     49]=DQ[ 25]*/ par_scan_tail[21],
                                        /*ddr3_sin[     48]=DQ[ 24]*/ ser_scan_out[20],
                                          ddr3_sin[ 47: 36],
                                        /*ddr3_sin[     35]=DQ[ 19]*/ par_scan_tail[22],
                                        /*ddr3_sin[     34]=DQ[ 18]*/ ser_scan_out[21],
                                        /*ddr3_sin[     33]=DQ[ 17]*/ par_scan_tail[23],
                                        /*ddr3_sin[     32]=DQ[ 16]*/ ser_scan_out[22],
                                          ddr3_sin[ 31:  0]}),

    .afi                                ({ddr3_afi[143:121],
                                        /*ddr3_afi[    120]=DQ[ 56]*/ afi_rt_data_in[13],
                                          ddr3_afi[119:107],
                                        /*ddr3_afi[    106]=DQ[ 50]*/ afi_rt_data_in[14],
                                          ddr3_afi[    105],
                                        /*ddr3_afi[    104]=DQ[ 48]*/ afi_rt_data_in[15],
                                          ddr3_afi[103: 91],
                                        /*ddr3_afi[     90]=DQ[ 42]*/ afi_rt_data_in[16],
                                          ddr3_afi[     89],
                                        /*ddr3_afi[     88]=DQ[ 40]*/ afi_rt_data_in[17],
                                          ddr3_afi[ 87: 75],
                                        /*ddr3_afi[     74]=DQ[ 34]*/ afi_rt_data_in[18],
                                          ddr3_afi[     73],
                                        /*ddr3_afi[     72]=DQ[ 32]*/ afi_rt_data_in[19],
                                          ddr3_afi[ 71: 51],
                                        /*ddr3_afi[     50]=DQ[ 26]*/ afi_rt_data_in[20],
                                          ddr3_afi[     49],
                                        /*ddr3_afi[     48]=DQ[ 24]*/ afi_rt_data_in[21],
                                          ddr3_afi[ 47: 35],
                                        /*ddr3_afi[     34]=DQ[ 18]*/ afi_rt_data_in[22],
                                          ddr3_afi[     33],
                                        /*ddr3_afi[     32]=DQ[ 16]*/ afi_rt_data_in[23],
                                          ddr3_afi[ 31:  0]}),

    .afo                                ({ddr3_afo[143:122],
                                        /*ddr3_afo[    121]=DQ[ 57]*/ afo_rt_data_out[13],
                                          ddr3_afo[120:108],
                                        /*ddr3_afo[    107]=DQ[ 51]*/ afo_rt_data_out[14],
                                          ddr3_afo[    106],
                                        /*ddr3_afo[    105]=DQ[ 49]*/ afo_rt_data_out[15],
                                          ddr3_afo[104:92],
                                        /*ddr3_afo[     91]=DQ[ 43]*/ afo_rt_data_out[16],
                                          ddr3_afo[     90],
                                        /*ddr3_afo[     89]=DQ[ 41]*/ afo_rt_data_out[17],
                                          ddr3_afo[ 88: 76],
                                        /*ddr3_afo[     75]=DQ[ 35]*/ afo_rt_data_out[18],
                                          ddr3_afo[     74],
                                        /*ddr3_afo[     73]=DQ[ 33]*/ afo_rt_data_out[19],
                                          ddr3_afo[ 72: 52],
                                        /*ddr3_afo[     51]=DQ[ 27]*/ afo_rt_data_out[20],
                                          ddr3_afo[     50],
                                        /*ddr3_afo[     49]=DQ[ 25]*/ afo_rt_data_out[21],
                                          ddr3_afo[ 48: 36],
                                        /*ddr3_afo[     35]=DQ[ 19]*/ afo_rt_data_out[22],
                                          ddr3_afo[     34],
                                        /*ddr3_afo[     33]=DQ[ 17]*/ afo_rt_data_out[23],
                                          ddr3_afo[ 32:  0]}),


     /*AUTOINST*/
    // Outputs
    .ddr3_lpf_code			(ctu_dll3_ctu_ctrl[4:0]), // Templated
    .dram3_ck_p				(DRAM3_CK_P[3:0]),	 // Templated
    .dram3_ba				(DRAM3_BA[2:0]),	 // Templated
    .dram3_addr				(DRAM3_ADDR[14:0]),	 // Templated
    .dram3_ck_n				(DRAM3_CK_N[3:0]),	 // Templated
    .io_dram3_data_in			(io_dram3_data_in[255:0]),
    .io_dram3_ecc_in			(io_dram3_ecc_in[31:0]),
    .dram3_cs_l				(DRAM3_CS_L[3:0]),	 // Templated
    .bscan_mode_ctl_out			(),			 // Templated
    .pad_ddr3_bso			(ddr3_ddr2_bso),	 // Templated
    .dram3_cas_l			(DRAM3_CAS_L),		 // Templated
    .dram3_ras_l			(DRAM3_RAS_L),		 // Templated
    .dram3_cke				(DRAM3_CKE),		 // Templated
    .bscan_hiz_l_out			(),			 // Templated
    .bypass_enable_out			(),			 // Templated
    .bscan_shift_dr_out			(),			 // Templated
    .bscan_clock_dr_out			(),			 // Templated
    .bscan_update_dr_out		(),			 // Templated
    .ddr_so				(pddr3_pjbusr_so),	 // Templated
    .ps_select_out			(),			 // Templated
    .ddr3_ctu_dll_lock			(ddr3_ctu_dll_lock),
    .dram3_we_l				(DRAM3_WE_L),		 // Templated
    .ddr3_ctu_dll_overflow		(ddr3_ctu_dll_overflow),
    .io_dram3_data_valid		(io_dram3_data_valid),
    // Inouts
    .spare_ddr3_pad			(SPARE_DDR3_PAD[6:0]),	 // Templated
    .spare_ddr3_pin			(SPARE_DDR3_PIN[2:0]),	 // Templated
    .dram3_dq				(DRAM3_DQ[127:0]),	 // Templated
    .dram3_cb				(DRAM3_CB[15:0]),	 // Templated
    .dram3_dqs				(DRAM3_DQS[35:0]),	 // Templated
    // Inputs
    .spare_ddr3_paddata			(7'b0101010),		 // Templated
    .ddr3_bypass_data			(ctu_dll3_byp_val[4:0]), // Templated
    .spare_ddr3_pindata			(3'b010),		 // Templated
    .dram_gclk				({dram_gclk_c3_r[7],dram_gclk_c3_r[5]}), // Templated
    .ddr2_ddr3_cbd			(ddr2_ddr3_cbd[8:1]),
    .ctu_ddr3_dll_delayctr		(ctu_ddr3_dll_delayctr[2:0]),
    .dram3_io_bank			(dram3_io_bank_buf2[2:0]), // Templated
    .dram3_io_ptr_clk_inv		(dram3_io_ptr_clk_inv_buf2[4:0]), // Templated
    .dram3_io_cs_l			(dram3_io_cs_l_buf2[3:0]), // Templated
    .dram3_io_addr			(dram3_io_addr_buf2[14:0]), // Templated
    .ddr2_ddr3_cbu			(ddr2_ddr3_cbu[8:1]),
    .dram3_io_data_out			(dram3_io_data_out_buf2[287:0]), // Templated
    .ps_select				(pscan_select),		 // Templated
    .bscan_mode_ctl_in			(ctu_ddr3_mode_ctl),	 // Templated
    .ddr_testmode_l			(ctu_ddr_testmode_l),	 // Templated
    .bscan_clock_dr_in			(ctu_ddr3_clock_dr),	 // Templated
    .ddr3_dll_bypass_l			(ctu_dll3_byp_l),	 // Templated
    .dram_adbginit_l			(dram_adbginit_l),
    .clk_ddr3_cken			(ctu_ddr3_dram_cken),	 // Templated
    .dram_arst_l			(dram_arst_l),
    .dram_gdbginit_l			(dram_gdbginit_l),
    .bscan_hiz_l_in			(ctu_ddr3_hiz_l),	 // Templated
    .dram3_io_pad_enable		(dram3_io_pad_enable_buf2), // Templated
    .vdd18				(VDDR18),		 // Templated
    .ctu_ddr3_iodll_rst_l		(ctu_ddr3_iodll_rst_l),
    .bypass_enable			(global_scan_bypass_en), // Templated
    .pad_ddr3_bsi			(jbusr_ddr3_sscan_out),	 // Templated
    .test_mode				(io_test_mode),		 // Templated
    .ddr_si				(par_scan_head[21]),	 // Templated
    .dram_grst_l			(dram_grst_l),
    .ddr_se				(global_shift_enable),	 // Templated
    .bscan_shift_dr_in			(ctu_ddr3_shift_dr),	 // Templated
    .dram3_io_write_en_l		(dram3_io_write_en_l_buf2), // Templated
    .bscan_update_dr_in			(ctu_ddr3_update_dr),	 // Templated
    .dram3_io_drive_enable		(dram3_io_drive_enable_buf2), // Templated
    .dram3_io_cas_l			(dram3_io_cas_l_buf2),	 // Templated
    .dram3_io_ras_l			(dram3_io_ras_l_buf2),	 // Templated
    .dram3_io_clk_enable		(dram3_io_clk_enable_buf2), // Templated
    .dram3_io_channel_disabled		(dram3_io_channel_disabled_buf2), // Templated
    .dram3_io_drive_data		(dram3_io_drive_data_buf2), // Templated
    .dram3_io_cke			(dram3_io_cke_buf2),	 // Templated
    .dram3_io_pad_clk_inv		(dram3_io_pad_clk_inv_buf2)); // Templated
`endif
//


/* pad_efc AUTO_TEMPLATE (
    .vpp                                (VPP),
    .vddo                               (VDDCO),
    ); */
//
`ifdef RTL_PAD_EFC
   pad_efc pad_efc
     (/*AUTOINST*/
      // Inouts
      .vpp				(VPP),			 // Templated
      .vddo				(VDDCO));		 // Templated
`endif
//


/* pad_jbusr AUTO_TEMPLATE (
    .j_ad                               (J_AD[]),
    .j_adp                              (J_ADP[]),
    .j_adtype                           (J_ADTYPE[]),
    .j_par                              (J_PAR),
    .j_pack0                            (J_PACK0[]),
    .j_pack1                            (J_PACK1[]),
    .j_pack4                            (J_PACK4[]),
    .j_pack5                            (J_PACK5[]),
    .j_req0_out_l                       (J_REQ0_OUT_L),
    .j_req1_out_l                       (J_REQ1_OUT_L),
    .j_req4_in_l                        (J_REQ4_IN_L),
    .j_req5_in_l                        (J_REQ5_IN_L),
    .j_err                              (J_ERR),
    .j_rst_l                            (J_RST_L),
    .dtl_r_vref                         (DTL_R_VREF),
    .jbus_p_ref_res                     (JBUS_P_REF_RES),
    .jbus_n_ref_res                     (JBUS_N_REF_RES),
    .spare_jbusr_pin                    (SPARE_JBUSR_PIN[]),
    .spare_jbusr_to_core                (),
    .spare_jbusr_data                   (1'b0),
    .spare_jbusr_oe                     (1'b0),

    .io_jbi_j_rst_l                     (io_j_rst_l),
    .jbi_io_j_err                       (ctu_io_j_err),

    .jbus_gclk                          (jbus_gclk_c3_r[7]),
    .clk_jbusr_cken                     (ctu_jbusr_jbus_cken),
    .jbus_grst_l                        (1'b1),

    .bscan_\(.*\)_out                   (),
    .pad_jbusr_bsi                      (jbusl_jbusr_bso),
    .pad_jbusr_si                       (pddr3_pjbusr_so),

    .bscan_\(.*\)_in			(ctu_jbusr_\1),
    .pad_jbusr_bso                      (jbusr_jbusr_bso),
    .pad_jbusr_so                       (pjbusr_rptrs_so),

    .pad_jbusr_se                       (global_shift_enable),

    .ctu_io_sscan_se                    (ctu_jbusr_shift_dr),
    .ctu_io_sscan_update                (ctu_pads_sscan_update),
    .pad_jbusr_sscan_out                (jbusr_ddr3_sscan_out),
    .pad_jbusr_sscan_in                 (jbusr_jbusr_bso),

    .bypass_enable                      (global_scan_bypass_en),
    .bypass_enable_out                  (),

    .ps_select                          (pscan_select),
    .ps_select_out                      (),

    .por_l                              (jbus_arst_l),
    .hard_rst_l                         (jbus_grst_l),
    .rst_io_l                           (1'b1),
    .rst_val_dn                         (1'b1),
    .rst_val_up                         (1'b1),
    .scan_mode                          (1'b0),
    .sel_bypass                         (1'b0),
    .up_open                            (1'b0),
    .down_25                            (1'b0),
    .tclk                               (ctu_jbusr_clock_dr),
    .jbi_io_j_par_en			(1'b0),
    .jbi_io_j_par			(1'b0),
    .jbi_io_dsbl_sampling		(1'b0),
    .jbi_io_j_req1_out_en		(jbi_io_j_req0_out_en),
    .jbi_io_j_req1_out_l		(jbi_io_j_req0_out_l),
    .vddo				(VDDBO),
    ); */
//
`ifdef RTL_PAD_JBUSR
   pad_jbusr pad_jbusr
	 (
    .serial_out                         ({jbusr_sot[ 56: 39],
					/*jbusr_sot[     38]=J_AD[38]*/ par_scan_head[15],
                                        /*jbusr_sot[     37]=J_AD[37]*/ ser_scan_out[15],
                                          jbusr_sot[ 36: 35],
                                        /*jbusr_sot[     34]=J_AD[32]*/ par_scan_head[16],
                                        /*jbusr_sot[     33]=J_AD[33]*/ ser_scan_out[16],
                                          jbusr_sot[ 32: 14],
                                        /*jbusr_sot[     13]=J_AD[13]*/ par_scan_head[17],
                                        /*jbusr_sot[     12]=J_AD[12]*/ ser_scan_out[17],
                                          jbusr_sot[ 11:  0]}),

    .serial_in                          ({jbusr_sin[ 56: 39],
                                        /*jbusr_sin[     38]=J_AD[38]*/ ser_scan_out[14],
                                        /*jbusr_sin[     37]=J_AD[37]*/ par_scan_tail[15],
                                          jbusr_sin[ 36: 35],
                                        /*jbusr_sin[     34]=J_AD[34]*/ ser_scan_out[15],
                                        /*jbusr_sin[     33]=J_AD[33]*/ par_scan_tail[16],
                                          jbusr_sin[ 32: 14],
                                        /*jbusr_sin[     13]=J_AD[13]*/ ser_scan_out[16],
                                        /*jbusr_sin[     12]=J_AD[12]*/ par_scan_tail[17],
                                          jbusr_sin[ 11:  0]}),

     /*AUTOINST*/
	  // Outputs
	  .j_pack1			(J_PACK1[2:0]),		 // Templated
	  .j_pack0			(J_PACK0[2:0]),		 // Templated
	  .io_jbi_j_ad			(io_jbi_j_ad[56:0]),
	  .spare_jbusr_to_core		(),			 // Templated
	  .io_jbi_j_adtype		(io_jbi_j_adtype[7:0]),
	  .io_jbi_j_pack4		(io_jbi_j_pack4[2:0]),
	  .io_jbi_j_adp			(io_jbi_j_adp[3:0]),
	  .io_jbi_j_pack5		(io_jbi_j_pack5[2:0]),
	  .jbusr_jbusl_cbu		(jbusr_jbusl_cbu[8:1]),
	  .jbusr_jbusl_cbd		(jbusr_jbusl_cbd[8:1]),
	  .bscan_hiz_l_out		(),			 // Templated
	  .bscan_update_dr_out		(),			 // Templated
	  .bscan_clock_dr_out		(),			 // Templated
	  .bscan_shift_dr_out		(),			 // Templated
	  .bscan_mode_ctl_out		(),			 // Templated
	  .j_req1_out_l			(J_REQ1_OUT_L),		 // Templated
	  .ps_select_out		(),			 // Templated
	  .bypass_enable_out		(),			 // Templated
	  .j_req0_out_l			(J_REQ0_OUT_L),		 // Templated
	  .pad_jbusr_sscan_out		(jbusr_ddr3_sscan_out),	 // Templated
	  .pad_jbusr_so			(pjbusr_rptrs_so),	 // Templated
	  .pad_jbusr_bso		(jbusr_jbusr_bso),	 // Templated
	  .j_err			(J_ERR),		 // Templated
	  .io_jbi_j_req5_in_l		(io_jbi_j_req5_in_l),
	  .io_jbi_j_req4_in_l		(io_jbi_j_req4_in_l),
	  .io_jbi_j_par			(io_jbi_j_par),
	  .io_jbi_j_rst_l		(io_j_rst_l),		 // Templated
	  // Inouts
	  .j_adp			(J_ADP[3:0]),		 // Templated
	  .j_adtype			(J_ADTYPE[7:0]),	 // Templated
	  .j_ad				(J_AD[56:0]),		 // Templated
	  .spare_jbusr_pin		(SPARE_JBUSR_PIN[0:0]),	 // Templated
	  .dtl_r_vref			(DTL_R_VREF),		 // Templated
	  .j_par			(J_PAR),		 // Templated
	  // Inputs
	  .jbi_io_j_ad			(jbi_io_j_ad[56:0]),
	  .j_pack5			(J_PACK5[2:0]),		 // Templated
	  .j_pack4			(J_PACK4[2:0]),		 // Templated
	  .jbi_io_config_dtl		(jbi_io_config_dtl[1:0]),
	  .jbi_io_j_adtype		(jbi_io_j_adtype[7:0]),
	  .jbi_io_j_ad_en		(jbi_io_j_ad_en[1:0]),
	  .jbi_io_j_pack0		(jbi_io_j_pack0[2:0]),
	  .jbi_io_j_pack1		(jbi_io_j_pack1[2:0]),
	  .spare_jbusr_data		(1'b0),			 // Templated
	  .jbi_io_j_adp			(jbi_io_j_adp[3:0]),
	  .spare_jbusr_oe		(1'b0),			 // Templated
	  .bscan_clock_dr_in		(ctu_jbusr_clock_dr),	 // Templated
	  .jbus_n_ref_res		(JBUS_N_REF_RES),	 // Templated
	  .j_req4_in_l			(J_REQ4_IN_L),		 // Templated
	  .jbus_p_ref_res		(JBUS_P_REF_RES),	 // Templated
	  .jbi_io_j_req1_out_en		(jbi_io_j_req0_out_en),	 // Templated
	  .jbi_io_j_req1_out_l		(jbi_io_j_req0_out_l),	 // Templated
	  .ps_select			(pscan_select),		 // Templated
	  .bypass_enable		(global_scan_bypass_en), // Templated
	  .clk_jbusr_cken		(ctu_jbusr_jbus_cken),	 // Templated
	  .jbus_gclk			(jbus_gclk_c3_r[7]),	 // Templated
	  .jbus_grst_l			(1'b1),			 // Templated
	  .jbus_arst_l			(jbus_arst_l),
	  .jbus_gdbginit_l		(jbus_gdbginit_l),
	  .jbus_adbginit_l		(jbus_adbginit_l),
	  .pad_jbusr_se			(global_shift_enable),	 // Templated
	  .bscan_shift_dr_in		(ctu_jbusr_shift_dr),	 // Templated
	  .jbi_io_j_err			(ctu_io_j_err),		 // Templated
	  .tclk				(ctu_jbusr_clock_dr),	 // Templated
	  .pad_jbusr_si			(pddr3_pjbusr_so),	 // Templated
	  .pad_jbusr_bsi		(jbusl_jbusr_bso),	 // Templated
	  .vddo				(VDDBO),		 // Templated
	  .rst_val_up			(1'b1),			 // Templated
	  .bscan_hiz_l_in		(ctu_jbusr_hiz_l),	 // Templated
	  .sel_bypass			(1'b0),			 // Templated
	  .bscan_mode_ctl_in		(ctu_jbusr_mode_ctl),	 // Templated
	  .bscan_update_dr_in		(ctu_jbusr_update_dr),	 // Templated
	  .rst_val_dn			(1'b1),			 // Templated
	  .rst_io_l			(1'b1),			 // Templated
	  .por_l			(jbus_arst_l),		 // Templated
	  .jbi_io_j_adp_en		(jbi_io_j_adp_en),
	  .jbi_io_j_pack0_en		(jbi_io_j_pack0_en),
	  .jbi_io_j_pack1_en		(jbi_io_j_pack1_en),
	  .jbi_io_j_adtype_en		(jbi_io_j_adtype_en),
	  .hard_rst_l			(jbus_grst_l),		 // Templated
	  .jbi_io_j_par_en		(1'b0),			 // Templated
	  .jbi_io_j_req0_out_en		(jbi_io_j_req0_out_en),
	  .ctu_io_sscan_update		(ctu_pads_sscan_update), // Templated
	  .jbi_io_j_req0_out_l		(jbi_io_j_req0_out_l),
	  .jbi_io_j_par			(1'b0),			 // Templated
	  .pad_jbusr_sscan_in		(jbusr_jbusr_bso),	 // Templated
	  .ctu_io_sscan_se		(ctu_jbusr_shift_dr),	 // Templated
	  .j_req5_in_l			(J_REQ5_IN_L),		 // Templated
	  .j_rst_l			(J_RST_L),		 // Templated
	  .ctu_global_snap		(ctu_global_snap));
`endif
//


/* pad_jbusl AUTO_TEMPLATE (
    .jbus_gclk                          (jbus_gclk_c0_r[7]),
    .clk_jbusl_cken                     (ctu_jbusl_jbus_cken),
    .jbus_grst_l                        (1'b1),

    .j_ad                               (J_AD[]),
    .dtl_l_vref                         (DTL_L_VREF),

    .bscan_\(.*\)_out                   (),
    .pad_jbusl_bsi                      (ddr1_jbusl_bso),
    .pad_jbusl_si                       (pddr1_pjbusl_so),

    .bscan_\(.*\)_in			(ctu_jbusl_\1),
    .pad_jbusl_bso                      (jbusl_jbusr_bso),
    .pad_jbusl_so                       (pjbusl_rptrs_so),

    .pad_jbusl_se                       (global_shift_enable),

    .bypass_enable			(global_scan_bypass_en),
    .bypass_enable_out			(),

    .ps_select                          (pscan_select),
    .ps_select_out                      (),

    .por_l                              (jbus_arst_l),
    .rst_io_l                           (1'b1),
    .rst_val_dn                         (1'b1),
    .rst_val_up                         (1'b1),
    .scan_mode                          (1'b0),
    .up_open                            (1'b0),
    .down_25                            (1'b0),
    .sel_bypass                         (1'b0),
    .jbi_io_dsbl_sampling		(1'b0),
    .jbi_io_config_dtl_chunk0		(jbi_io_config_dtl[0]),  // Same as other chunks.
    .jbi_io_j_ad_en_chunk56		(jbi_io_j_ad_en[3]),     // Same as other chunks.
    .vddo				(VDDBO),
    ); */
//
`ifdef RTL_PAD_JBUSL
   pad_jbusl pad_jbusl
   (
    .serial_out                         ({jbusl_sot[127:110],
                                        /*jbusl_sot[    109]=J_AD[109]*/ par_scan_head[13],
                                        /*jbusl_sot[    108]=J_AD[108]*/ ser_scan_out[13],
                                          jbusl_sot[107:106],
                                        /*jbusl_sot[    105]=J_AD[105]*/ par_scan_head[14],
                                        /*jbusl_sot[    104]=J_AD[104]*/ ser_scan_out[14],
                                          jbusl_sot[103: 57]}),

    .serial_in                          ({jbusl_sin[127:110],
                                        /*jbusl_sin[    109]=J_AD[109]*/ ser_scan_out[12],
                                        /*jbusl_sin[    108]=J_AD[108]*/ par_scan_tail[13],
                                          jbusl_sin[107:106],
                                        /*jbusl_sin[    105]=J_AD[105]*/ ser_scan_out[13],
                                        /*jbusl_sin[    104]=J_AD[104]*/ par_scan_tail[14],
                                          jbusl_sin[103: 57]}),

     /*AUTOINST*/
    // Outputs
    .io_jbi_j_ad			(io_jbi_j_ad[127:57]),
    .bscan_hiz_l_out			(),			 // Templated
    .bscan_mode_ctl_out			(),			 // Templated
    .bscan_update_dr_out		(),			 // Templated
    .bscan_shift_dr_out			(),			 // Templated
    .bscan_clock_dr_out			(),			 // Templated
    .bypass_enable_out			(),			 // Templated
    .ps_select_out			(),			 // Templated
    .pad_jbusl_bso			(jbusl_jbusr_bso),	 // Templated
    .pad_jbusl_so			(pjbusl_rptrs_so),	 // Templated
    // Inouts
    .j_ad				(J_AD[127:57]),		 // Templated
    .dtl_l_vref				(DTL_L_VREF),		 // Templated
    // Inputs
    .jbi_io_config_dtl_chunk0		(jbi_io_config_dtl[0]),	 // Templated
    .jbi_io_config_dtl			(jbi_io_config_dtl[1:0]),
    .jbi_io_j_ad			(jbi_io_j_ad[127:57]),
    .jbusr_jbusl_cbd			(jbusr_jbusl_cbd[8:1]),
    .jbi_io_j_ad_en			(jbi_io_j_ad_en[3:2]),
    .jbusr_jbusl_cbu			(jbusr_jbusl_cbu[8:1]),
    .jbi_io_j_ad_en_chunk56		(jbi_io_j_ad_en[3]),	 // Templated
    .bscan_hiz_l_in			(ctu_jbusl_hiz_l),	 // Templated
    .pad_jbusl_se			(global_shift_enable),	 // Templated
    .jbus_arst_l			(jbus_arst_l),
    .jbus_adbginit_l			(jbus_adbginit_l),
    .jbus_gclk				(jbus_gclk_c0_r[7]),	 // Templated
    .jbus_grst_l			(1'b1),			 // Templated
    .clk_jbusl_cken			(ctu_jbusl_jbus_cken),	 // Templated
    .jbus_gdbginit_l			(jbus_gdbginit_l),
    .bscan_update_dr_in			(ctu_jbusl_update_dr),	 // Templated
    .pad_jbusl_si			(pddr1_pjbusl_so),	 // Templated
    .bscan_mode_ctl_in			(ctu_jbusl_mode_ctl),	 // Templated
    .bscan_clock_dr_in			(ctu_jbusl_clock_dr),	 // Templated
    .bypass_enable			(global_scan_bypass_en), // Templated
    .ps_select				(pscan_select),		 // Templated
    .bscan_shift_dr_in			(ctu_jbusl_shift_dr),	 // Templated
    .pad_jbusl_bsi			(ddr1_jbusl_bso),	 // Templated
    .por_l				(jbus_arst_l),		 // Templated
    .rst_io_l				(1'b1),			 // Templated
    .rst_val_up				(1'b1),			 // Templated
    .rst_val_dn				(1'b1),			 // Templated
    .vddo				(VDDBO),		 // Templated
    .sel_bypass				(1'b0));			 // Templated
`endif
//


/* pad_jbusl AUTO_TEMPLATE (
    .dtl_l_vref                         (DBG_VREF),

    .jbus_gclk                          (jbus_gclk_c0_r[0]),
    .clk_jbusl_cken                     (ctu_dbg_jbus_cken),

    .bscan_\(.*\)_out                   (),
    .pad_jbusl_bsi                      (misc_dbg_bso),
    .pad_jbusl_si                       (rptrs_pdbg_so),

    .bscan_\(.*\)_in			(ctu_debug_\1),
    .pad_jbusl_bso                      (dbg_ddr0_bso),
    .pad_jbusl_so                       (pdbg_pddr1_so),

    .pad_jbusl_se                       (global_shift_enable),

    .bypass_enable			(global_scan_bypass_en),
    .bypass_enable_out			(),

    .ps_select                          (pscan_select),
    .ps_select_out                      (),

    .por_l                              (jbus_arst_l),
    .rst_io_l                           (1'b1),
    .rst_val_dn                         (1'b1),
    .rst_val_up                         (1'b1),
    .scan_mode                          (1'b0),
    .up_open                            (1'b0),
    .down_25                            (1'b0),
    .sel_bypass                         (1'b0),
    .jbi_io_dsbl_sampling		(1'b0),
    .jbi_io_config_dtl			(2'b00),   			 // 50 ohm pullup (DTL-END).
    .jbi_io_j_ad_en                     ({iob_io_dbg_en,iob_io_dbg_en}), // Output enable control.
    .jbi_io_config_dtl_chunk0		(1'b1),   			 // No termination.
    .jbi_io_j_ad_en_chunk56		(1'b0),   			 // Input only.
    .jbus_grst_l			(1'b1),				 // Disabled for DO_BIST to propagate sooner.  (Bug 4614)
    .vddo				(VDDTO),
    ); */
//
`ifdef RTL_PAD_DBG
   pad_jbusl pad_dbg
   (
    .serial_out                         ({dbg_sot[127:59],
					/*dbg_sot[    58]=DBG_DQ[1]*/ par_scan_head[0],
					/*dbg_sot[    57]=DBG_DQ[0]*/ ser_scan_out[0]}),

    .serial_in                          ({dbg_sin[127:59],
					/*dbg_sot[    58]=DBG_DQ[1]*/ io_tdi,
					/*dbg_sot[    57]=DBG_DQ[0]*/ par_scan_tail[0]}),

    .j_ad                               ({/*[127:105]*/ SPARE_DBG_PAD[23:1],
                                          /*[    104]*/ DO_BIST,
                                          /*[    103]*/ SPARE_DBG_PAD[0],
                                          /*[102:100]*/ DBG_CK_P[2:0],
                                          /*[ 99: 97]*/ DBG_CK_N[2:0],
                                          /*[ 96: 57]*/ DBG_DQ[39:0]}),

    // Inputs
    .jbi_io_j_ad                        ({/*[127:103]*/ dbg_from_core_unused[127:103],
                                          /*[102:100]*/ iob_io_dbg_ck_p[2:0],
                                          /*[ 99: 97]*/ iob_io_dbg_ck_n[2:0],
                                          /*[ 96: 57]*/ iob_io_dbg_data[39:0]}),
    // Outputs
    .io_jbi_j_ad			({/*[127:105]*/ dbg_to_core_unused[127:105],
                                          /*[    104]*/ io_do_bist,
                                          /*[103: 57]*/ dbg_to_core_unused[103:57]}),
     /*AUTOINST*/
    // Outputs
    .bscan_hiz_l_out			(),			 // Templated
    .bscan_mode_ctl_out			(),			 // Templated
    .bscan_update_dr_out		(),			 // Templated
    .bscan_shift_dr_out			(),			 // Templated
    .bscan_clock_dr_out			(),			 // Templated
    .bypass_enable_out			(),			 // Templated
    .ps_select_out			(),			 // Templated
    .pad_jbusl_bso			(dbg_ddr0_bso),		 // Templated
    .pad_jbusl_so			(pdbg_pddr1_so),	 // Templated
    // Inouts
    .dtl_l_vref				(DBG_VREF),		 // Templated
    // Inputs
    .jbi_io_config_dtl_chunk0		(1'b1),			 // Templated
    .jbi_io_config_dtl			(2'b00),		 // Templated
    .jbusr_jbusl_cbd			(jbusr_jbusl_cbd[8:1]),
    .jbi_io_j_ad_en			({iob_io_dbg_en,iob_io_dbg_en}), // Templated
    .jbusr_jbusl_cbu			(jbusr_jbusl_cbu[8:1]),
    .jbi_io_j_ad_en_chunk56		(1'b0),			 // Templated
    .bscan_hiz_l_in			(ctu_debug_hiz_l),	 // Templated
    .pad_jbusl_se			(global_shift_enable),	 // Templated
    .jbus_arst_l			(jbus_arst_l),
    .jbus_adbginit_l			(jbus_adbginit_l),
    .jbus_gclk				(jbus_gclk_c0_r[0]),	 // Templated
    .jbus_grst_l			(1'b1),			 // Templated
    .clk_jbusl_cken			(ctu_dbg_jbus_cken),	 // Templated
    .jbus_gdbginit_l			(jbus_gdbginit_l),
    .bscan_update_dr_in			(ctu_debug_update_dr),	 // Templated
    .pad_jbusl_si			(rptrs_pdbg_so),	 // Templated
    .bscan_mode_ctl_in			(ctu_debug_mode_ctl),	 // Templated
    .bscan_clock_dr_in			(ctu_debug_clock_dr),	 // Templated
    .bypass_enable			(global_scan_bypass_en), // Templated
    .ps_select				(pscan_select),		 // Templated
    .bscan_shift_dr_in			(ctu_debug_shift_dr),	 // Templated
    .pad_jbusl_bsi			(misc_dbg_bso),		 // Templated
    .por_l				(jbus_arst_l),		 // Templated
    .rst_io_l				(1'b1),			 // Templated
    .rst_val_up				(1'b1),			 // Templated
    .rst_val_dn				(1'b1),			 // Templated
    .vddo				(VDDTO),		 // Templated
    .sel_bypass				(1'b0));			 // Templated
`endif



/* pad_misc AUTO_TEMPLATE (
    .tck                                (TCK),
    .trst_l                             (TRST_L),
    .tdi                                (TDI),
    .tdo                                (TDO),
    .tms                                (TMS),
    .test_mode                          (TEST_MODE),
    .pwron_rst_l                        (PWRON_RST_L),
    .ssi_miso                           (SSI_MISO),
    .ssi_mosi                           (SSI_MOSI),
    .ssi_sck                            (SSI_SCK),
    .clk_stretch                        (CLK_STRETCH),
    .do_bist                            (DO_BIST),
    .ext_int_l                          (EXT_INT_L),
    .pll_char_in                        (PLL_CHAR_IN),
    .burnin                             (BURNIN),
    .pmi                                (PMI),
    .pmo                                (PMO),
    .pgrm_en                            (PGRM_EN),
    .vreg_selbg_l                       (VREG_SELBG_L),
    .temp_trig                          (TEMP_TRIG),
    .trigin                             (TRIGIN),
    .vdd_sense                          (VDD_SENSE),
    .vss_sense                          (VSS_SENSE),
    .hstl_vref                          (HSTL_VREF),
    .tck2				(TCK2),
    .spare_misc_pin                     (SPARE_MISC_PIN),
    .spare_misc_pin_to_core             (),
    .spare_misc_pindata                 (1'b0),
    .spare_misc_pinoe                   (1'b1),
    .spare_misc_pad                     (SPARE_MISC_PAD[]),
    .spare_misc_pad_to_core             (),
    .spare_misc_paddata                 (3'b0),
    .spare_misc_padoe                   (3'b0),

    .bscan_\(.*\)_out                   (),
    .pad_misc_bsi                       (ddr2_misc_sscan_out),
    .pad_misc_si                        (rptrs_pmisc_so),

    .bscan_\(.*\)_in			(ctu_misc_\1),
    .pad_misc_bso                       (misc_dbg_bso),
    .pad_misc_so                        (pmisc_pddr2_so),

    .pad_misc_se                        (global_shift_enable),

    .io_burnin                          (pcm_io_burnin),
    .io_pmi                             (io_pcm_pmi),
    .io_pmo                             (pcm_io_pmo),

    .io_tdo                             (ctu_io_tdo),
    .io_tdo_en                          (ctu_io_tdo_en),

    .jbus_grst_l                        (1'b1),
    .jbus_gclk                          (jbus_gclk_c3_r[0]),
    .clk_misc_cken                      (ctu_misc_jbus_cken),
    .io_pll_char_in			(io_pll_char_in),
    .vddo                               (VDDTO),
    ); */
//
`ifdef RTL_PAD_MISC
   pad_misc pad_misc
     (/*AUTOINST*/
      // Outputs
      .spare_misc_pad_to_core		(),			 // Templated
      .io_burnin			(pcm_io_burnin),	 // Templated
      .io_pmi				(io_pcm_pmi),		 // Templated
      .pad_misc_so			(pmisc_pddr2_so),	 // Templated
      .bscan_shift_dr_out		(),			 // Templated
      .bscan_update_dr_out		(),			 // Templated
      .bscan_clock_dr_out		(),			 // Templated
      .bscan_mode_ctl_out		(),			 // Templated
      .io_ext_int_l			(io_ext_int_l),
      .io_trigin			(io_trigin),
      .io_test_mode			(io_test_mode),
      .io_pwron_rst_l			(io_pwron_rst_l),
      .io_tms				(io_tms),
      .io_pgrm_en			(io_pgrm_en),
      .io_pll_char_in			(io_pll_char_in),	 // Templated
      .io_trst_l			(io_trst_l),
      .io_tck				(io_tck),
      .io_tdi				(io_tdi),
      .io_temp_trig			(io_temp_trig),
      .spare_misc_pin_to_core		(),			 // Templated
      .io_jbi_ssi_miso			(io_jbi_ssi_miso),
      .bscan_hiz_l_out			(),			 // Templated
      .pad_misc_bso			(misc_dbg_bso),		 // Templated
      .io_tck2				(io_tck2),
      .io_vreg_selbg_l			(io_vreg_selbg_l),
      .io_clk_stretch			(io_clk_stretch),
      // Inouts
      .spare_misc_pad			(SPARE_MISC_PAD[2:0]),	 // Templated
      .tdi				(TDI),			 // Templated
      .spare_misc_pin			(SPARE_MISC_PIN),	 // Templated
      .burnin				(BURNIN),		 // Templated
      .vreg_selbg_l			(VREG_SELBG_L),		 // Templated
      .tck2				(TCK2),			 // Templated
      .ssi_miso				(SSI_MISO),		 // Templated
      .ssi_mosi				(SSI_MOSI),		 // Templated
      .temp_trig			(TEMP_TRIG),		 // Templated
      .ext_int_l			(EXT_INT_L),		 // Templated
      .vdd_sense			(VDD_SENSE),		 // Templated
      .pmi				(PMI),			 // Templated
      .pll_char_in			(PLL_CHAR_IN),		 // Templated
      .vss_sense			(VSS_SENSE),		 // Templated
      .clk_stretch			(CLK_STRETCH),		 // Templated
      .pwron_rst_l			(PWRON_RST_L),		 // Templated
      .test_mode			(TEST_MODE),		 // Templated
      .pmo				(PMO),			 // Templated
      .pgrm_en				(PGRM_EN),		 // Templated
      .hstl_vref			(HSTL_VREF),		 // Templated
      .tms				(TMS),			 // Templated
      .tck				(TCK),			 // Templated
      .tdo				(TDO),			 // Templated
      .trst_l				(TRST_L),		 // Templated
      .ssi_sck				(SSI_SCK),		 // Templated
      .trigin				(TRIGIN),		 // Templated
      // Inputs
      .spare_misc_paddata		(3'b0),			 // Templated
      .spare_misc_padoe			(3'b0),			 // Templated
      .io_tdo_en			(ctu_io_tdo_en),	 // Templated
      .bscan_hiz_l_in			(ctu_misc_hiz_l),	 // Templated
      .bscan_update_dr_in		(ctu_misc_update_dr),	 // Templated
      .spare_misc_pindata		(1'b0),			 // Templated
      .pad_misc_bsi			(ddr2_misc_sscan_out),	 // Templated
      .pad_misc_se			(global_shift_enable),	 // Templated
      .pad_misc_si			(rptrs_pmisc_so),	 // Templated
      .bscan_clock_dr_in		(ctu_misc_clock_dr),	 // Templated
      .jbus_arst_l			(jbus_arst_l),
      .jbus_adbginit_l			(jbus_adbginit_l),
      .jbus_gdbginit_l			(jbus_gdbginit_l),
      .jbus_grst_l			(1'b1),			 // Templated
      .jbus_gclk			(jbus_gclk_c3_r[0]),	 // Templated
      .vddo				(VDDTO),		 // Templated
      .clk_misc_cken			(ctu_misc_jbus_cken),	 // Templated
      .pcm_misc_oe			(pcm_misc_oe),
      .io_pmo				(pcm_io_pmo),		 // Templated
      .io_tdo				(ctu_io_tdo),		 // Templated
      .jbi_io_ssi_sck			(jbi_io_ssi_sck),
      .jbi_io_ssi_mosi			(jbi_io_ssi_mosi),
      .bscan_mode_ctl_in		(ctu_misc_mode_ctl),	 // Templated
      .bscan_shift_dr_in		(ctu_misc_shift_dr),	 // Templated
      .spare_misc_pinoe			(1'b1));			 // Templated
`endif
//


/* sctag_scbuf_rptr0 AUTO_TEMPLATE (
    .sctag_scbuf\(.*\)                  (sctag0_scbuf0\1[]),
    .scbuf_sctag\(.*\)                  (scbuf0_sctag0\1[]),
    ); */
//
   sctag_scbuf_rptr0 sctag_scbuf_rptr0
     (/*AUTOINST*/
      // Outputs
      .sctag_scbuf_fbrd_en_c3_buf	(sctag0_scbuf0_fbrd_en_c3_buf), // Templated
      .sctag_scbuf_fbrd_wl_c3_buf	(sctag0_scbuf0_fbrd_wl_c3_buf[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2_buf	(sctag0_scbuf0_fbwr_wen_r2_buf[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2_buf	(sctag0_scbuf0_fbwr_wl_r2_buf[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3_buf	(sctag0_scbuf0_fbd_stdatasel_c3_buf), // Templated
      .sctag_scbuf_stdecc_c3_buf	(sctag0_scbuf0_stdecc_c3_buf[77:0]), // Templated
      .sctag_scbuf_ev_dword_r0_buf	(sctag0_scbuf0_ev_dword_r0_buf[2:0]), // Templated
      .sctag_scbuf_evict_en_r0_buf	(sctag0_scbuf0_evict_en_r0_buf), // Templated
      .sctag_scbuf_wbwr_wen_c6_buf	(sctag0_scbuf0_wbwr_wen_c6_buf[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6_buf	(sctag0_scbuf0_wbwr_wl_c6_buf[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0_buf	(sctag0_scbuf0_wbrd_en_r0_buf), // Templated
      .sctag_scbuf_wbrd_wl_r0_buf	(sctag0_scbuf0_wbrd_wl_r0_buf[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2_buf	(sctag0_scbuf0_rdma_wren_s2_buf[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2_buf	(sctag0_scbuf0_rdma_wrwl_s2_buf[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0_buf	(sctag0_scbuf0_rdma_rden_r0_buf), // Templated
      .sctag_scbuf_rdma_rdwl_r0_buf	(sctag0_scbuf0_rdma_rdwl_r0_buf[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7_buf	(sctag0_scbuf0_ctag_en_c7_buf), // Templated
      .sctag_scbuf_ctag_c7_buf		(sctag0_scbuf0_ctag_c7_buf[14:0]), // Templated
      .sctag_scbuf_req_en_c7_buf	(sctag0_scbuf0_req_en_c7_buf), // Templated
      .sctag_scbuf_word_c7_buf		(sctag0_scbuf0_word_c7_buf[3:0]), // Templated
      .sctag_scbuf_word_vld_c7_buf	(sctag0_scbuf0_word_vld_c7_buf), // Templated
      .scbuf_sctag_ev_uerr_r5_buf	(scbuf0_sctag0_ev_uerr_r5_buf), // Templated
      .scbuf_sctag_ev_cerr_r5_buf	(scbuf0_sctag0_ev_cerr_r5_buf), // Templated
      .scbuf_sctag_rdma_uerr_c10_buf	(scbuf0_sctag0_rdma_uerr_c10_buf), // Templated
      .scbuf_sctag_rdma_cerr_c10_buf	(scbuf0_sctag0_rdma_cerr_c10_buf), // Templated
      // Inputs
      .sctag_scbuf_fbrd_en_c3		(sctag0_scbuf0_fbrd_en_c3), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag0_scbuf0_fbrd_wl_c3[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag0_scbuf0_fbwr_wen_r2[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag0_scbuf0_fbwr_wl_r2[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag0_scbuf0_fbd_stdatasel_c3), // Templated
      .sctag_scbuf_stdecc_c3		(sctag0_scbuf0_stdecc_c3[77:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag0_scbuf0_ev_dword_r0[2:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag0_scbuf0_evict_en_r0), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag0_scbuf0_wbwr_wen_c6[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag0_scbuf0_wbwr_wl_c6[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag0_scbuf0_wbrd_en_r0), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag0_scbuf0_wbrd_wl_r0[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag0_scbuf0_rdma_wren_s2[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag0_scbuf0_rdma_wrwl_s2[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag0_scbuf0_rdma_rden_r0), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag0_scbuf0_rdma_rdwl_r0[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag0_scbuf0_ctag_en_c7), // Templated
      .sctag_scbuf_ctag_c7		(sctag0_scbuf0_ctag_c7[14:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag0_scbuf0_req_en_c7), // Templated
      .sctag_scbuf_word_c7		(sctag0_scbuf0_word_c7[3:0]), // Templated
      .sctag_scbuf_word_vld_c7		(sctag0_scbuf0_word_vld_c7), // Templated
      .scbuf_sctag_ev_uerr_r5		(scbuf0_sctag0_ev_uerr_r5), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf0_sctag0_ev_cerr_r5), // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf0_sctag0_rdma_uerr_c10), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf0_sctag0_rdma_cerr_c10)); // Templated
//


/* sctag_scbuf_rptr1 AUTO_TEMPLATE (
    .sctag_scbuf\(.*\)                  (sctag1_scbuf1\1[]),
    .scbuf_sctag\(.*\)                  (scbuf1_sctag1\1[]),
    ); */
//
   sctag_scbuf_rptr1 sctag_scbuf_rptr1
     (/*AUTOINST*/
      // Outputs
      .sctag_scbuf_fbrd_en_c3_buf	(sctag1_scbuf1_fbrd_en_c3_buf), // Templated
      .sctag_scbuf_fbrd_wl_c3_buf	(sctag1_scbuf1_fbrd_wl_c3_buf[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2_buf	(sctag1_scbuf1_fbwr_wen_r2_buf[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2_buf	(sctag1_scbuf1_fbwr_wl_r2_buf[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3_buf	(sctag1_scbuf1_fbd_stdatasel_c3_buf), // Templated
      .sctag_scbuf_stdecc_c3_buf	(sctag1_scbuf1_stdecc_c3_buf[77:0]), // Templated
      .sctag_scbuf_ev_dword_r0_buf	(sctag1_scbuf1_ev_dword_r0_buf[2:0]), // Templated
      .sctag_scbuf_evict_en_r0_buf	(sctag1_scbuf1_evict_en_r0_buf), // Templated
      .sctag_scbuf_wbwr_wen_c6_buf	(sctag1_scbuf1_wbwr_wen_c6_buf[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6_buf	(sctag1_scbuf1_wbwr_wl_c6_buf[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0_buf	(sctag1_scbuf1_wbrd_en_r0_buf), // Templated
      .sctag_scbuf_wbrd_wl_r0_buf	(sctag1_scbuf1_wbrd_wl_r0_buf[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2_buf	(sctag1_scbuf1_rdma_wren_s2_buf[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2_buf	(sctag1_scbuf1_rdma_wrwl_s2_buf[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0_buf	(sctag1_scbuf1_rdma_rden_r0_buf), // Templated
      .sctag_scbuf_rdma_rdwl_r0_buf	(sctag1_scbuf1_rdma_rdwl_r0_buf[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7_buf	(sctag1_scbuf1_ctag_en_c7_buf), // Templated
      .sctag_scbuf_ctag_c7_buf		(sctag1_scbuf1_ctag_c7_buf[14:0]), // Templated
      .sctag_scbuf_req_en_c7_buf	(sctag1_scbuf1_req_en_c7_buf), // Templated
      .sctag_scbuf_word_c7_buf		(sctag1_scbuf1_word_c7_buf[3:0]), // Templated
      .sctag_scbuf_word_vld_c7_buf	(sctag1_scbuf1_word_vld_c7_buf), // Templated
      .scbuf_sctag_ev_uerr_r5_buf	(scbuf1_sctag1_ev_uerr_r5_buf), // Templated
      .scbuf_sctag_ev_cerr_r5_buf	(scbuf1_sctag1_ev_cerr_r5_buf), // Templated
      .scbuf_sctag_rdma_uerr_c10_buf	(scbuf1_sctag1_rdma_uerr_c10_buf), // Templated
      .scbuf_sctag_rdma_cerr_c10_buf	(scbuf1_sctag1_rdma_cerr_c10_buf), // Templated
      // Inputs
      .sctag_scbuf_fbrd_en_c3		(sctag1_scbuf1_fbrd_en_c3), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag1_scbuf1_fbrd_wl_c3[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag1_scbuf1_fbwr_wen_r2[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag1_scbuf1_fbwr_wl_r2[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag1_scbuf1_fbd_stdatasel_c3), // Templated
      .sctag_scbuf_stdecc_c3		(sctag1_scbuf1_stdecc_c3[77:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag1_scbuf1_ev_dword_r0[2:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag1_scbuf1_evict_en_r0), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag1_scbuf1_wbwr_wen_c6[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag1_scbuf1_wbwr_wl_c6[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag1_scbuf1_wbrd_en_r0), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag1_scbuf1_wbrd_wl_r0[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag1_scbuf1_rdma_wren_s2[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag1_scbuf1_rdma_wrwl_s2[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag1_scbuf1_rdma_rden_r0), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag1_scbuf1_rdma_rdwl_r0[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag1_scbuf1_ctag_en_c7), // Templated
      .sctag_scbuf_ctag_c7		(sctag1_scbuf1_ctag_c7[14:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag1_scbuf1_req_en_c7), // Templated
      .sctag_scbuf_word_c7		(sctag1_scbuf1_word_c7[3:0]), // Templated
      .sctag_scbuf_word_vld_c7		(sctag1_scbuf1_word_vld_c7), // Templated
      .scbuf_sctag_ev_uerr_r5		(scbuf1_sctag1_ev_uerr_r5), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf1_sctag1_ev_cerr_r5), // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf1_sctag1_rdma_uerr_c10), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf1_sctag1_rdma_cerr_c10)); // Templated
//


/* sctag_scbuf_rptr2 AUTO_TEMPLATE (
    .sctag_scbuf\(.*\)                  (sctag2_scbuf2\1[]),
    .scbuf_sctag\(.*\)                  (scbuf2_sctag2\1[]),
    ); */
//
   sctag_scbuf_rptr2 sctag_scbuf_rptr2
     (/*AUTOINST*/
      // Outputs
      .sctag_scbuf_fbrd_en_c3_buf	(sctag2_scbuf2_fbrd_en_c3_buf), // Templated
      .sctag_scbuf_fbrd_wl_c3_buf	(sctag2_scbuf2_fbrd_wl_c3_buf[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2_buf	(sctag2_scbuf2_fbwr_wen_r2_buf[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2_buf	(sctag2_scbuf2_fbwr_wl_r2_buf[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3_buf	(sctag2_scbuf2_fbd_stdatasel_c3_buf), // Templated
      .sctag_scbuf_stdecc_c3_buf	(sctag2_scbuf2_stdecc_c3_buf[77:0]), // Templated
      .sctag_scbuf_ev_dword_r0_buf	(sctag2_scbuf2_ev_dword_r0_buf[2:0]), // Templated
      .sctag_scbuf_evict_en_r0_buf	(sctag2_scbuf2_evict_en_r0_buf), // Templated
      .sctag_scbuf_wbwr_wen_c6_buf	(sctag2_scbuf2_wbwr_wen_c6_buf[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6_buf	(sctag2_scbuf2_wbwr_wl_c6_buf[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0_buf	(sctag2_scbuf2_wbrd_en_r0_buf), // Templated
      .sctag_scbuf_wbrd_wl_r0_buf	(sctag2_scbuf2_wbrd_wl_r0_buf[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2_buf	(sctag2_scbuf2_rdma_wren_s2_buf[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2_buf	(sctag2_scbuf2_rdma_wrwl_s2_buf[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0_buf	(sctag2_scbuf2_rdma_rden_r0_buf), // Templated
      .sctag_scbuf_rdma_rdwl_r0_buf	(sctag2_scbuf2_rdma_rdwl_r0_buf[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7_buf	(sctag2_scbuf2_ctag_en_c7_buf), // Templated
      .sctag_scbuf_ctag_c7_buf		(sctag2_scbuf2_ctag_c7_buf[14:0]), // Templated
      .sctag_scbuf_req_en_c7_buf	(sctag2_scbuf2_req_en_c7_buf), // Templated
      .sctag_scbuf_word_c7_buf		(sctag2_scbuf2_word_c7_buf[3:0]), // Templated
      .sctag_scbuf_word_vld_c7_buf	(sctag2_scbuf2_word_vld_c7_buf), // Templated
      .scbuf_sctag_ev_uerr_r5_buf	(scbuf2_sctag2_ev_uerr_r5_buf), // Templated
      .scbuf_sctag_ev_cerr_r5_buf	(scbuf2_sctag2_ev_cerr_r5_buf), // Templated
      .scbuf_sctag_rdma_uerr_c10_buf	(scbuf2_sctag2_rdma_uerr_c10_buf), // Templated
      .scbuf_sctag_rdma_cerr_c10_buf	(scbuf2_sctag2_rdma_cerr_c10_buf), // Templated
      // Inputs
      .sctag_scbuf_fbrd_en_c3		(sctag2_scbuf2_fbrd_en_c3), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag2_scbuf2_fbrd_wl_c3[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag2_scbuf2_fbwr_wen_r2[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag2_scbuf2_fbwr_wl_r2[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag2_scbuf2_fbd_stdatasel_c3), // Templated
      .sctag_scbuf_stdecc_c3		(sctag2_scbuf2_stdecc_c3[77:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag2_scbuf2_ev_dword_r0[2:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag2_scbuf2_evict_en_r0), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag2_scbuf2_wbwr_wen_c6[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag2_scbuf2_wbwr_wl_c6[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag2_scbuf2_wbrd_en_r0), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag2_scbuf2_wbrd_wl_r0[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag2_scbuf2_rdma_wren_s2[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag2_scbuf2_rdma_wrwl_s2[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag2_scbuf2_rdma_rden_r0), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag2_scbuf2_rdma_rdwl_r0[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag2_scbuf2_ctag_en_c7), // Templated
      .sctag_scbuf_ctag_c7		(sctag2_scbuf2_ctag_c7[14:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag2_scbuf2_req_en_c7), // Templated
      .sctag_scbuf_word_c7		(sctag2_scbuf2_word_c7[3:0]), // Templated
      .sctag_scbuf_word_vld_c7		(sctag2_scbuf2_word_vld_c7), // Templated
      .scbuf_sctag_ev_uerr_r5		(scbuf2_sctag2_ev_uerr_r5), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf2_sctag2_ev_cerr_r5), // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf2_sctag2_rdma_uerr_c10), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf2_sctag2_rdma_cerr_c10)); // Templated
//


/* sctag_scbuf_rptr3 AUTO_TEMPLATE (
    .sctag_scbuf\(.*\)                  (sctag3_scbuf3\1[]),
    .scbuf_sctag\(.*\)                  (scbuf3_sctag3\1[]),
    ); */
//
   sctag_scbuf_rptr3 sctag_scbuf_rptr3
     (/*AUTOINST*/
      // Outputs
      .sctag_scbuf_fbrd_en_c3_buf	(sctag3_scbuf3_fbrd_en_c3_buf), // Templated
      .sctag_scbuf_fbrd_wl_c3_buf	(sctag3_scbuf3_fbrd_wl_c3_buf[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2_buf	(sctag3_scbuf3_fbwr_wen_r2_buf[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2_buf	(sctag3_scbuf3_fbwr_wl_r2_buf[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3_buf	(sctag3_scbuf3_fbd_stdatasel_c3_buf), // Templated
      .sctag_scbuf_stdecc_c3_buf	(sctag3_scbuf3_stdecc_c3_buf[77:0]), // Templated
      .sctag_scbuf_ev_dword_r0_buf	(sctag3_scbuf3_ev_dword_r0_buf[2:0]), // Templated
      .sctag_scbuf_evict_en_r0_buf	(sctag3_scbuf3_evict_en_r0_buf), // Templated
      .sctag_scbuf_wbwr_wen_c6_buf	(sctag3_scbuf3_wbwr_wen_c6_buf[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6_buf	(sctag3_scbuf3_wbwr_wl_c6_buf[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0_buf	(sctag3_scbuf3_wbrd_en_r0_buf), // Templated
      .sctag_scbuf_wbrd_wl_r0_buf	(sctag3_scbuf3_wbrd_wl_r0_buf[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2_buf	(sctag3_scbuf3_rdma_wren_s2_buf[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2_buf	(sctag3_scbuf3_rdma_wrwl_s2_buf[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0_buf	(sctag3_scbuf3_rdma_rden_r0_buf), // Templated
      .sctag_scbuf_rdma_rdwl_r0_buf	(sctag3_scbuf3_rdma_rdwl_r0_buf[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7_buf	(sctag3_scbuf3_ctag_en_c7_buf), // Templated
      .sctag_scbuf_ctag_c7_buf		(sctag3_scbuf3_ctag_c7_buf[14:0]), // Templated
      .sctag_scbuf_req_en_c7_buf	(sctag3_scbuf3_req_en_c7_buf), // Templated
      .sctag_scbuf_word_c7_buf		(sctag3_scbuf3_word_c7_buf[3:0]), // Templated
      .sctag_scbuf_word_vld_c7_buf	(sctag3_scbuf3_word_vld_c7_buf), // Templated
      .scbuf_sctag_ev_uerr_r5_buf	(scbuf3_sctag3_ev_uerr_r5_buf), // Templated
      .scbuf_sctag_ev_cerr_r5_buf	(scbuf3_sctag3_ev_cerr_r5_buf), // Templated
      .scbuf_sctag_rdma_uerr_c10_buf	(scbuf3_sctag3_rdma_uerr_c10_buf), // Templated
      .scbuf_sctag_rdma_cerr_c10_buf	(scbuf3_sctag3_rdma_cerr_c10_buf), // Templated
      // Inputs
      .sctag_scbuf_fbrd_en_c3		(sctag3_scbuf3_fbrd_en_c3), // Templated
      .sctag_scbuf_fbrd_wl_c3		(sctag3_scbuf3_fbrd_wl_c3[2:0]), // Templated
      .sctag_scbuf_fbwr_wen_r2		(sctag3_scbuf3_fbwr_wen_r2[15:0]), // Templated
      .sctag_scbuf_fbwr_wl_r2		(sctag3_scbuf3_fbwr_wl_r2[2:0]), // Templated
      .sctag_scbuf_fbd_stdatasel_c3	(sctag3_scbuf3_fbd_stdatasel_c3), // Templated
      .sctag_scbuf_stdecc_c3		(sctag3_scbuf3_stdecc_c3[77:0]), // Templated
      .sctag_scbuf_ev_dword_r0		(sctag3_scbuf3_ev_dword_r0[2:0]), // Templated
      .sctag_scbuf_evict_en_r0		(sctag3_scbuf3_evict_en_r0), // Templated
      .sctag_scbuf_wbwr_wen_c6		(sctag3_scbuf3_wbwr_wen_c6[3:0]), // Templated
      .sctag_scbuf_wbwr_wl_c6		(sctag3_scbuf3_wbwr_wl_c6[2:0]), // Templated
      .sctag_scbuf_wbrd_en_r0		(sctag3_scbuf3_wbrd_en_r0), // Templated
      .sctag_scbuf_wbrd_wl_r0		(sctag3_scbuf3_wbrd_wl_r0[2:0]), // Templated
      .sctag_scbuf_rdma_wren_s2		(sctag3_scbuf3_rdma_wren_s2[15:0]), // Templated
      .sctag_scbuf_rdma_wrwl_s2		(sctag3_scbuf3_rdma_wrwl_s2[1:0]), // Templated
      .sctag_scbuf_rdma_rden_r0		(sctag3_scbuf3_rdma_rden_r0), // Templated
      .sctag_scbuf_rdma_rdwl_r0		(sctag3_scbuf3_rdma_rdwl_r0[1:0]), // Templated
      .sctag_scbuf_ctag_en_c7		(sctag3_scbuf3_ctag_en_c7), // Templated
      .sctag_scbuf_ctag_c7		(sctag3_scbuf3_ctag_c7[14:0]), // Templated
      .sctag_scbuf_req_en_c7		(sctag3_scbuf3_req_en_c7), // Templated
      .sctag_scbuf_word_c7		(sctag3_scbuf3_word_c7[3:0]), // Templated
      .sctag_scbuf_word_vld_c7		(sctag3_scbuf3_word_vld_c7), // Templated
      .scbuf_sctag_ev_uerr_r5		(scbuf3_sctag3_ev_uerr_r5), // Templated
      .scbuf_sctag_ev_cerr_r5		(scbuf3_sctag3_ev_cerr_r5), // Templated
      .scbuf_sctag_rdma_uerr_c10	(scbuf3_sctag3_rdma_uerr_c10), // Templated
      .scbuf_sctag_rdma_cerr_c10	(scbuf3_sctag3_rdma_cerr_c10)); // Templated
//


/* ff_dram_sc_bank0 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rtop2_rdram0_so),
    .so                                 (rdram0_rtop_so),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1[]),
    .scbuf_dram\(.*\)_d1                (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_d1[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1[]),
    .sctag_dram\(.*\)_d1                (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_d1[]),
    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    ); */
//
   ff_dram_sc_bank0 ff_dram_sc_bank0
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_d1		(dram02_scbuf0_data_r2_d1[127:0]), // Templated
      .dram_scbuf_ecc_r2_d1		(dram02_scbuf0_ecc_r2_d1[27:0]), // Templated
      .scbuf_dram_wr_data_r5_d1		(scbuf0_dram02_wr_data_r5_d1[63:0]), // Templated
      .scbuf_dram_data_vld_r5_d1	(scbuf0_dram02_data_vld_r5_d1), // Templated
      .scbuf_dram_data_mecc_r5_d1	(scbuf0_dram02_data_mecc_r5_d1), // Templated
      .sctag_dram_rd_req_d1		(sctag0_dram02_rd_req_d1), // Templated
      .sctag_dram_rd_dummy_req_d1	(sctag0_dram02_rd_dummy_req_d1), // Templated
      .sctag_dram_rd_req_id_d1		(sctag0_dram02_rd_req_id_d1[2:0]), // Templated
      .sctag_dram_addr_d1		(sctag0_dram02_addr_d1[39:5]), // Templated
      .sctag_dram_wr_req_d1		(sctag0_dram02_wr_req_d1), // Templated
      .dram_sctag_rd_ack_d1		(dram02_sctag0_rd_ack_d1), // Templated
      .dram_sctag_wr_ack_d1		(dram02_sctag0_wr_ack_d1), // Templated
      .dram_sctag_chunk_id_r0_d1	(dram02_sctag0_chunk_id_r0_d1[1:0]), // Templated
      .dram_sctag_data_vld_r0_d1	(dram02_sctag0_data_vld_r0_d1), // Templated
      .dram_sctag_rd_req_id_r0_d1	(dram02_sctag0_rd_req_id_r0_d1[2:0]), // Templated
      .dram_sctag_secc_err_r2_d1	(dram02_sctag0_secc_err_r2_d1), // Templated
      .dram_sctag_mecc_err_r2_d1	(dram02_sctag0_mecc_err_r2_d1), // Templated
      .dram_sctag_scb_mecc_err_d1	(dram02_sctag0_scb_mecc_err_d1), // Templated
      .dram_sctag_scb_secc_err_d1	(dram02_sctag0_scb_secc_err_d1), // Templated
      .so				(rdram0_rtop_so),	 // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram02_scbuf0_data_r2[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf0_ecc_r2[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf0_dram02_wr_data_r5_buf3[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf0_dram02_data_vld_r5_buf3), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf0_dram02_data_mecc_r5_buf3), // Templated
      .sctag_dram_rd_req		(sctag0_dram02_rd_req_buf3), // Templated
      .sctag_dram_rd_dummy_req		(sctag0_dram02_rd_dummy_req_buf3), // Templated
      .sctag_dram_rd_req_id		(sctag0_dram02_rd_req_id_buf3[2:0]), // Templated
      .sctag_dram_addr			(sctag0_dram02_addr_buf3[39:5]), // Templated
      .sctag_dram_wr_req		(sctag0_dram02_wr_req_buf3), // Templated
      .dram_sctag_rd_ack		(dram02_sctag0_rd_ack),	 // Templated
      .dram_sctag_wr_ack		(dram02_sctag0_wr_ack),	 // Templated
      .dram_sctag_chunk_id_r0		(dram02_sctag0_chunk_id_r0[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram02_sctag0_data_vld_r0), // Templated
      .dram_sctag_rd_req_id_r0		(dram02_sctag0_rd_req_id_r0[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram02_sctag0_secc_err_r2), // Templated
      .dram_sctag_mecc_err_r2		(dram02_sctag0_mecc_err_r2), // Templated
      .dram_sctag_scb_mecc_err		(dram02_sctag0_scb_mecc_err), // Templated
      .dram_sctag_scb_secc_err		(dram02_sctag0_scb_secc_err), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rtop2_rdram0_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ff_dram_sc_bank2 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rtop_rdram2_so),
    .so                                 (rdram2_fpu_so),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1[]),
    .scbuf_dram\(.*\)_d1                (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_d1[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1[]),
    .sctag_dram\(.*\)_d1                (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_d1[]),
    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    ); */
//
   ff_dram_sc_bank2 ff_dram_sc_bank2
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_d1		(dram02_scbuf2_data_r2_d1[127:0]), // Templated
      .dram_scbuf_ecc_r2_d1		(dram02_scbuf2_ecc_r2_d1[27:0]), // Templated
      .scbuf_dram_wr_data_r5_d1		(scbuf2_dram02_wr_data_r5_d1[63:0]), // Templated
      .scbuf_dram_data_vld_r5_d1	(scbuf2_dram02_data_vld_r5_d1), // Templated
      .scbuf_dram_data_mecc_r5_d1	(scbuf2_dram02_data_mecc_r5_d1), // Templated
      .sctag_dram_rd_req_d1		(sctag2_dram02_rd_req_d1), // Templated
      .sctag_dram_rd_dummy_req_d1	(sctag2_dram02_rd_dummy_req_d1), // Templated
      .sctag_dram_rd_req_id_d1		(sctag2_dram02_rd_req_id_d1[2:0]), // Templated
      .sctag_dram_addr_d1		(sctag2_dram02_addr_d1[39:5]), // Templated
      .sctag_dram_wr_req_d1		(sctag2_dram02_wr_req_d1), // Templated
      .dram_sctag_rd_ack_d1		(dram02_sctag2_rd_ack_d1), // Templated
      .dram_sctag_wr_ack_d1		(dram02_sctag2_wr_ack_d1), // Templated
      .dram_sctag_chunk_id_r0_d1	(dram02_sctag2_chunk_id_r0_d1[1:0]), // Templated
      .dram_sctag_data_vld_r0_d1	(dram02_sctag2_data_vld_r0_d1), // Templated
      .dram_sctag_rd_req_id_r0_d1	(dram02_sctag2_rd_req_id_r0_d1[2:0]), // Templated
      .dram_sctag_secc_err_r2_d1	(dram02_sctag2_secc_err_r2_d1), // Templated
      .dram_sctag_mecc_err_r2_d1	(dram02_sctag2_mecc_err_r2_d1), // Templated
      .dram_sctag_scb_mecc_err_d1	(dram02_sctag2_scb_mecc_err_d1), // Templated
      .dram_sctag_scb_secc_err_d1	(dram02_sctag2_scb_secc_err_d1), // Templated
      .so				(rdram2_fpu_so),	 // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram02_scbuf2_data_r2[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf2_ecc_r2[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf2_dram02_wr_data_r5_buf3[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf2_dram02_data_vld_r5_buf3), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf2_dram02_data_mecc_r5_buf3), // Templated
      .sctag_dram_rd_req		(sctag2_dram02_rd_req_buf3), // Templated
      .sctag_dram_rd_dummy_req		(sctag2_dram02_rd_dummy_req_buf3), // Templated
      .sctag_dram_rd_req_id		(sctag2_dram02_rd_req_id_buf3[2:0]), // Templated
      .sctag_dram_addr			(sctag2_dram02_addr_buf3[39:5]), // Templated
      .sctag_dram_wr_req		(sctag2_dram02_wr_req_buf3), // Templated
      .dram_sctag_rd_ack		(dram02_sctag2_rd_ack),	 // Templated
      .dram_sctag_wr_ack		(dram02_sctag2_wr_ack),	 // Templated
      .dram_sctag_chunk_id_r0		(dram02_sctag2_chunk_id_r0[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram02_sctag2_data_vld_r0), // Templated
      .dram_sctag_rd_req_id_r0		(dram02_sctag2_rd_req_id_r0[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram02_sctag2_secc_err_r2), // Templated
      .dram_sctag_mecc_err_r2		(dram02_sctag2_mecc_err_r2), // Templated
      .dram_sctag_scb_mecc_err		(dram02_sctag2_scb_mecc_err), // Templated
      .dram_sctag_scb_secc_err		(dram02_sctag2_scb_secc_err), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rtop_rdram2_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ff_dram_sc_bank1 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rbot_rdram1_so),
    .so                                 (rdram1_rbot2_so),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1[]),
    .scbuf_dram\(.*\)_d1                (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_d1[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1[]),
    .sctag_dram\(.*\)_d1                (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_d1[]),
    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    ); */
//
   ff_dram_sc_bank1 ff_dram_sc_bank1
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_d1		(dram13_scbuf1_data_r2_d1[127:0]), // Templated
      .dram_scbuf_ecc_r2_d1		(dram13_scbuf1_ecc_r2_d1[27:0]), // Templated
      .scbuf_dram_wr_data_r5_d1		(scbuf1_dram13_wr_data_r5_d1[63:0]), // Templated
      .scbuf_dram_data_vld_r5_d1	(scbuf1_dram13_data_vld_r5_d1), // Templated
      .scbuf_dram_data_mecc_r5_d1	(scbuf1_dram13_data_mecc_r5_d1), // Templated
      .sctag_dram_rd_req_d1		(sctag1_dram13_rd_req_d1), // Templated
      .sctag_dram_rd_dummy_req_d1	(sctag1_dram13_rd_dummy_req_d1), // Templated
      .sctag_dram_rd_req_id_d1		(sctag1_dram13_rd_req_id_d1[2:0]), // Templated
      .sctag_dram_addr_d1		(sctag1_dram13_addr_d1[39:5]), // Templated
      .sctag_dram_wr_req_d1		(sctag1_dram13_wr_req_d1), // Templated
      .dram_sctag_rd_ack_d1		(dram13_sctag1_rd_ack_d1), // Templated
      .dram_sctag_wr_ack_d1		(dram13_sctag1_wr_ack_d1), // Templated
      .dram_sctag_chunk_id_r0_d1	(dram13_sctag1_chunk_id_r0_d1[1:0]), // Templated
      .dram_sctag_data_vld_r0_d1	(dram13_sctag1_data_vld_r0_d1), // Templated
      .dram_sctag_rd_req_id_r0_d1	(dram13_sctag1_rd_req_id_r0_d1[2:0]), // Templated
      .dram_sctag_secc_err_r2_d1	(dram13_sctag1_secc_err_r2_d1), // Templated
      .dram_sctag_mecc_err_r2_d1	(dram13_sctag1_mecc_err_r2_d1), // Templated
      .dram_sctag_scb_mecc_err_d1	(dram13_sctag1_scb_mecc_err_d1), // Templated
      .dram_sctag_scb_secc_err_d1	(dram13_sctag1_scb_secc_err_d1), // Templated
      .so				(rdram1_rbot2_so),	 // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram13_scbuf1_data_r2[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf1_ecc_r2[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf1_dram13_wr_data_r5_buf3[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf1_dram13_data_vld_r5_buf3), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf1_dram13_data_mecc_r5_buf3), // Templated
      .sctag_dram_rd_req		(sctag1_dram13_rd_req_buf3), // Templated
      .sctag_dram_rd_dummy_req		(sctag1_dram13_rd_dummy_req_buf3), // Templated
      .sctag_dram_rd_req_id		(sctag1_dram13_rd_req_id_buf3[2:0]), // Templated
      .sctag_dram_addr			(sctag1_dram13_addr_buf3[39:5]), // Templated
      .sctag_dram_wr_req		(sctag1_dram13_wr_req_buf3), // Templated
      .dram_sctag_rd_ack		(dram13_sctag1_rd_ack),	 // Templated
      .dram_sctag_wr_ack		(dram13_sctag1_wr_ack),	 // Templated
      .dram_sctag_chunk_id_r0		(dram13_sctag1_chunk_id_r0[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram13_sctag1_data_vld_r0), // Templated
      .dram_sctag_rd_req_id_r0		(dram13_sctag1_rd_req_id_r0[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram13_sctag1_secc_err_r2), // Templated
      .dram_sctag_mecc_err_r2		(dram13_sctag1_mecc_err_r2), // Templated
      .dram_sctag_scb_mecc_err		(dram13_sctag1_scb_mecc_err), // Templated
      .dram_sctag_scb_secc_err		(dram13_sctag1_scb_secc_err), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rbot_rdram1_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ff_dram_sc_bank3 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (fpu_rdram3_so),
    .so                                 (rdram3_rbot_so),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1[]),
    .scbuf_dram\(.*\)_d1                (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_d1[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1[]),
    .sctag_dram\(.*\)_d1                (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_d1[]),
    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    ); */
//
   ff_dram_sc_bank3 ff_dram_sc_bank3
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_d1		(dram13_scbuf3_data_r2_d1[127:0]), // Templated
      .dram_scbuf_ecc_r2_d1		(dram13_scbuf3_ecc_r2_d1[27:0]), // Templated
      .scbuf_dram_wr_data_r5_d1		(scbuf3_dram13_wr_data_r5_d1[63:0]), // Templated
      .scbuf_dram_data_vld_r5_d1	(scbuf3_dram13_data_vld_r5_d1), // Templated
      .scbuf_dram_data_mecc_r5_d1	(scbuf3_dram13_data_mecc_r5_d1), // Templated
      .sctag_dram_rd_req_d1		(sctag3_dram13_rd_req_d1), // Templated
      .sctag_dram_rd_dummy_req_d1	(sctag3_dram13_rd_dummy_req_d1), // Templated
      .sctag_dram_rd_req_id_d1		(sctag3_dram13_rd_req_id_d1[2:0]), // Templated
      .sctag_dram_addr_d1		(sctag3_dram13_addr_d1[39:5]), // Templated
      .sctag_dram_wr_req_d1		(sctag3_dram13_wr_req_d1), // Templated
      .dram_sctag_rd_ack_d1		(dram13_sctag3_rd_ack_d1), // Templated
      .dram_sctag_wr_ack_d1		(dram13_sctag3_wr_ack_d1), // Templated
      .dram_sctag_chunk_id_r0_d1	(dram13_sctag3_chunk_id_r0_d1[1:0]), // Templated
      .dram_sctag_data_vld_r0_d1	(dram13_sctag3_data_vld_r0_d1), // Templated
      .dram_sctag_rd_req_id_r0_d1	(dram13_sctag3_rd_req_id_r0_d1[2:0]), // Templated
      .dram_sctag_secc_err_r2_d1	(dram13_sctag3_secc_err_r2_d1), // Templated
      .dram_sctag_mecc_err_r2_d1	(dram13_sctag3_mecc_err_r2_d1), // Templated
      .dram_sctag_scb_mecc_err_d1	(dram13_sctag3_scb_mecc_err_d1), // Templated
      .dram_sctag_scb_secc_err_d1	(dram13_sctag3_scb_secc_err_d1), // Templated
      .so				(rdram3_rbot_so),	 // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram13_scbuf3_data_r2[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf3_ecc_r2[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf3_dram13_wr_data_r5_buf3[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf3_dram13_data_vld_r5_buf3), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf3_dram13_data_mecc_r5_buf3), // Templated
      .sctag_dram_rd_req		(sctag3_dram13_rd_req_buf3), // Templated
      .sctag_dram_rd_dummy_req		(sctag3_dram13_rd_dummy_req_buf3), // Templated
      .sctag_dram_rd_req_id		(sctag3_dram13_rd_req_id_buf3[2:0]), // Templated
      .sctag_dram_addr			(sctag3_dram13_addr_buf3[39:5]), // Templated
      .sctag_dram_wr_req		(sctag3_dram13_wr_req_buf3), // Templated
      .dram_sctag_rd_ack		(dram13_sctag3_rd_ack),	 // Templated
      .dram_sctag_wr_ack		(dram13_sctag3_wr_ack),	 // Templated
      .dram_sctag_chunk_id_r0		(dram13_sctag3_chunk_id_r0[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram13_sctag3_data_vld_r0), // Templated
      .dram_sctag_rd_req_id_r0		(dram13_sctag3_rd_req_id_r0[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram13_sctag3_secc_err_r2), // Templated
      .dram_sctag_mecc_err_r2		(dram13_sctag3_mecc_err_r2), // Templated
      .dram_sctag_scb_mecc_err		(dram13_sctag3_scb_mecc_err), // Templated
      .dram_sctag_scb_secc_err		(dram13_sctag3_scb_secc_err), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(fpu_rdram3_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* dram_l2_buf2 AUTO_TEMPLATE (
    .dram_scbuf\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf1[]),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_d1[]),
    .scbuf_dram\(.*\)_buf               (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    .dram_sctag\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf1[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_d1[]),
    .sctag_dram\(.*\)_buf               (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf3[]),
    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    );*/
//
   dram_l2_buf2 dram_sc_0_rep1
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram02_scbuf0_data_r2_buf1[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram02_scbuf0_ecc_r2_buf1[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf0_dram02_wr_data_r5_buf3[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf0_dram02_data_vld_r5_buf3), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf0_dram02_data_mecc_r5_buf3), // Templated
      .sctag_dram_rd_req_buf		(sctag0_dram02_rd_req_buf3), // Templated
      .sctag_dram_rd_dummy_req_buf	(sctag0_dram02_rd_dummy_req_buf3), // Templated
      .sctag_dram_rd_req_id_buf		(sctag0_dram02_rd_req_id_buf3[2:0]), // Templated
      .sctag_dram_addr_buf		(sctag0_dram02_addr_buf3[39:5]), // Templated
      .sctag_dram_wr_req_buf		(sctag0_dram02_wr_req_buf3), // Templated
      .dram_sctag_rd_ack_buf		(dram02_sctag0_rd_ack_buf1), // Templated
      .dram_sctag_wr_ack_buf		(dram02_sctag0_wr_ack_buf1), // Templated
      .dram_sctag_chunk_id_r0_buf	(dram02_sctag0_chunk_id_r0_buf1[1:0]), // Templated
      .dram_sctag_data_vld_r0_buf	(dram02_sctag0_data_vld_r0_buf1), // Templated
      .dram_sctag_rd_req_id_r0_buf	(dram02_sctag0_rd_req_id_r0_buf1[2:0]), // Templated
      .dram_sctag_secc_err_r2_buf	(dram02_sctag0_secc_err_r2_buf1), // Templated
      .dram_sctag_mecc_err_r2_buf	(dram02_sctag0_mecc_err_r2_buf1), // Templated
      .dram_sctag_scb_mecc_err_buf	(dram02_sctag0_scb_mecc_err_buf1), // Templated
      .dram_sctag_scb_secc_err_buf	(dram02_sctag0_scb_secc_err_buf1), // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram02_scbuf0_data_r2_d1[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf0_ecc_r2_d1[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf0_dram02_wr_data_r5_buf2[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf0_dram02_data_vld_r5_buf2), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf0_dram02_data_mecc_r5_buf2), // Templated
      .sctag_dram_rd_req		(sctag0_dram02_rd_req_buf2), // Templated
      .sctag_dram_rd_dummy_req		(sctag0_dram02_rd_dummy_req_buf2), // Templated
      .sctag_dram_rd_req_id		(sctag0_dram02_rd_req_id_buf2[2:0]), // Templated
      .sctag_dram_addr			(sctag0_dram02_addr_buf2[39:5]), // Templated
      .sctag_dram_wr_req		(sctag0_dram02_wr_req_buf2), // Templated
      .dram_sctag_rd_ack		(dram02_sctag0_rd_ack_d1), // Templated
      .dram_sctag_wr_ack		(dram02_sctag0_wr_ack_d1), // Templated
      .dram_sctag_chunk_id_r0		(dram02_sctag0_chunk_id_r0_d1[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram02_sctag0_data_vld_r0_d1), // Templated
      .dram_sctag_rd_req_id_r0		(dram02_sctag0_rd_req_id_r0_d1[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram02_sctag0_secc_err_r2_d1), // Templated
      .dram_sctag_mecc_err_r2		(dram02_sctag0_mecc_err_r2_d1), // Templated
      .dram_sctag_scb_mecc_err		(dram02_sctag0_scb_mecc_err_d1), // Templated
      .dram_sctag_scb_secc_err		(dram02_sctag0_scb_secc_err_d1)); // Templated
//
   dram_l2_buf2 dram_sc_1_rep1
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram13_scbuf1_data_r2_buf1[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram13_scbuf1_ecc_r2_buf1[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf1_dram13_wr_data_r5_buf3[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf1_dram13_data_vld_r5_buf3), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf1_dram13_data_mecc_r5_buf3), // Templated
      .sctag_dram_rd_req_buf		(sctag1_dram13_rd_req_buf3), // Templated
      .sctag_dram_rd_dummy_req_buf	(sctag1_dram13_rd_dummy_req_buf3), // Templated
      .sctag_dram_rd_req_id_buf		(sctag1_dram13_rd_req_id_buf3[2:0]), // Templated
      .sctag_dram_addr_buf		(sctag1_dram13_addr_buf3[39:5]), // Templated
      .sctag_dram_wr_req_buf		(sctag1_dram13_wr_req_buf3), // Templated
      .dram_sctag_rd_ack_buf		(dram13_sctag1_rd_ack_buf1), // Templated
      .dram_sctag_wr_ack_buf		(dram13_sctag1_wr_ack_buf1), // Templated
      .dram_sctag_chunk_id_r0_buf	(dram13_sctag1_chunk_id_r0_buf1[1:0]), // Templated
      .dram_sctag_data_vld_r0_buf	(dram13_sctag1_data_vld_r0_buf1), // Templated
      .dram_sctag_rd_req_id_r0_buf	(dram13_sctag1_rd_req_id_r0_buf1[2:0]), // Templated
      .dram_sctag_secc_err_r2_buf	(dram13_sctag1_secc_err_r2_buf1), // Templated
      .dram_sctag_mecc_err_r2_buf	(dram13_sctag1_mecc_err_r2_buf1), // Templated
      .dram_sctag_scb_mecc_err_buf	(dram13_sctag1_scb_mecc_err_buf1), // Templated
      .dram_sctag_scb_secc_err_buf	(dram13_sctag1_scb_secc_err_buf1), // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram13_scbuf1_data_r2_d1[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf1_ecc_r2_d1[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf1_dram13_wr_data_r5_buf2[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf1_dram13_data_vld_r5_buf2), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf1_dram13_data_mecc_r5_buf2), // Templated
      .sctag_dram_rd_req		(sctag1_dram13_rd_req_buf2), // Templated
      .sctag_dram_rd_dummy_req		(sctag1_dram13_rd_dummy_req_buf2), // Templated
      .sctag_dram_rd_req_id		(sctag1_dram13_rd_req_id_buf2[2:0]), // Templated
      .sctag_dram_addr			(sctag1_dram13_addr_buf2[39:5]), // Templated
      .sctag_dram_wr_req		(sctag1_dram13_wr_req_buf2), // Templated
      .dram_sctag_rd_ack		(dram13_sctag1_rd_ack_d1), // Templated
      .dram_sctag_wr_ack		(dram13_sctag1_wr_ack_d1), // Templated
      .dram_sctag_chunk_id_r0		(dram13_sctag1_chunk_id_r0_d1[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram13_sctag1_data_vld_r0_d1), // Templated
      .dram_sctag_rd_req_id_r0		(dram13_sctag1_rd_req_id_r0_d1[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram13_sctag1_secc_err_r2_d1), // Templated
      .dram_sctag_mecc_err_r2		(dram13_sctag1_mecc_err_r2_d1), // Templated
      .dram_sctag_scb_mecc_err		(dram13_sctag1_scb_mecc_err_d1), // Templated
      .dram_sctag_scb_secc_err		(dram13_sctag1_scb_secc_err_d1)); // Templated
//
   dram_l2_buf2 dram_sc_2_rep1
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram02_scbuf2_data_r2_buf1[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram02_scbuf2_ecc_r2_buf1[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf2_dram02_wr_data_r5_buf3[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf2_dram02_data_vld_r5_buf3), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf2_dram02_data_mecc_r5_buf3), // Templated
      .sctag_dram_rd_req_buf		(sctag2_dram02_rd_req_buf3), // Templated
      .sctag_dram_rd_dummy_req_buf	(sctag2_dram02_rd_dummy_req_buf3), // Templated
      .sctag_dram_rd_req_id_buf		(sctag2_dram02_rd_req_id_buf3[2:0]), // Templated
      .sctag_dram_addr_buf		(sctag2_dram02_addr_buf3[39:5]), // Templated
      .sctag_dram_wr_req_buf		(sctag2_dram02_wr_req_buf3), // Templated
      .dram_sctag_rd_ack_buf		(dram02_sctag2_rd_ack_buf1), // Templated
      .dram_sctag_wr_ack_buf		(dram02_sctag2_wr_ack_buf1), // Templated
      .dram_sctag_chunk_id_r0_buf	(dram02_sctag2_chunk_id_r0_buf1[1:0]), // Templated
      .dram_sctag_data_vld_r0_buf	(dram02_sctag2_data_vld_r0_buf1), // Templated
      .dram_sctag_rd_req_id_r0_buf	(dram02_sctag2_rd_req_id_r0_buf1[2:0]), // Templated
      .dram_sctag_secc_err_r2_buf	(dram02_sctag2_secc_err_r2_buf1), // Templated
      .dram_sctag_mecc_err_r2_buf	(dram02_sctag2_mecc_err_r2_buf1), // Templated
      .dram_sctag_scb_mecc_err_buf	(dram02_sctag2_scb_mecc_err_buf1), // Templated
      .dram_sctag_scb_secc_err_buf	(dram02_sctag2_scb_secc_err_buf1), // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram02_scbuf2_data_r2_d1[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf2_ecc_r2_d1[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf2_dram02_wr_data_r5_buf2[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf2_dram02_data_vld_r5_buf2), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf2_dram02_data_mecc_r5_buf2), // Templated
      .sctag_dram_rd_req		(sctag2_dram02_rd_req_buf2), // Templated
      .sctag_dram_rd_dummy_req		(sctag2_dram02_rd_dummy_req_buf2), // Templated
      .sctag_dram_rd_req_id		(sctag2_dram02_rd_req_id_buf2[2:0]), // Templated
      .sctag_dram_addr			(sctag2_dram02_addr_buf2[39:5]), // Templated
      .sctag_dram_wr_req		(sctag2_dram02_wr_req_buf2), // Templated
      .dram_sctag_rd_ack		(dram02_sctag2_rd_ack_d1), // Templated
      .dram_sctag_wr_ack		(dram02_sctag2_wr_ack_d1), // Templated
      .dram_sctag_chunk_id_r0		(dram02_sctag2_chunk_id_r0_d1[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram02_sctag2_data_vld_r0_d1), // Templated
      .dram_sctag_rd_req_id_r0		(dram02_sctag2_rd_req_id_r0_d1[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram02_sctag2_secc_err_r2_d1), // Templated
      .dram_sctag_mecc_err_r2		(dram02_sctag2_mecc_err_r2_d1), // Templated
      .dram_sctag_scb_mecc_err		(dram02_sctag2_scb_mecc_err_d1), // Templated
      .dram_sctag_scb_secc_err		(dram02_sctag2_scb_secc_err_d1)); // Templated
//
   dram_l2_buf2 dram_sc_3_rep1
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram13_scbuf3_data_r2_buf1[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram13_scbuf3_ecc_r2_buf1[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf3_dram13_wr_data_r5_buf3[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf3_dram13_data_vld_r5_buf3), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf3_dram13_data_mecc_r5_buf3), // Templated
      .sctag_dram_rd_req_buf		(sctag3_dram13_rd_req_buf3), // Templated
      .sctag_dram_rd_dummy_req_buf	(sctag3_dram13_rd_dummy_req_buf3), // Templated
      .sctag_dram_rd_req_id_buf		(sctag3_dram13_rd_req_id_buf3[2:0]), // Templated
      .sctag_dram_addr_buf		(sctag3_dram13_addr_buf3[39:5]), // Templated
      .sctag_dram_wr_req_buf		(sctag3_dram13_wr_req_buf3), // Templated
      .dram_sctag_rd_ack_buf		(dram13_sctag3_rd_ack_buf1), // Templated
      .dram_sctag_wr_ack_buf		(dram13_sctag3_wr_ack_buf1), // Templated
      .dram_sctag_chunk_id_r0_buf	(dram13_sctag3_chunk_id_r0_buf1[1:0]), // Templated
      .dram_sctag_data_vld_r0_buf	(dram13_sctag3_data_vld_r0_buf1), // Templated
      .dram_sctag_rd_req_id_r0_buf	(dram13_sctag3_rd_req_id_r0_buf1[2:0]), // Templated
      .dram_sctag_secc_err_r2_buf	(dram13_sctag3_secc_err_r2_buf1), // Templated
      .dram_sctag_mecc_err_r2_buf	(dram13_sctag3_mecc_err_r2_buf1), // Templated
      .dram_sctag_scb_mecc_err_buf	(dram13_sctag3_scb_mecc_err_buf1), // Templated
      .dram_sctag_scb_secc_err_buf	(dram13_sctag3_scb_secc_err_buf1), // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram13_scbuf3_data_r2_d1[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf3_ecc_r2_d1[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf3_dram13_wr_data_r5_buf2[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf3_dram13_data_vld_r5_buf2), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf3_dram13_data_mecc_r5_buf2), // Templated
      .sctag_dram_rd_req		(sctag3_dram13_rd_req_buf2), // Templated
      .sctag_dram_rd_dummy_req		(sctag3_dram13_rd_dummy_req_buf2), // Templated
      .sctag_dram_rd_req_id		(sctag3_dram13_rd_req_id_buf2[2:0]), // Templated
      .sctag_dram_addr			(sctag3_dram13_addr_buf2[39:5]), // Templated
      .sctag_dram_wr_req		(sctag3_dram13_wr_req_buf2), // Templated
      .dram_sctag_rd_ack		(dram13_sctag3_rd_ack_d1), // Templated
      .dram_sctag_wr_ack		(dram13_sctag3_wr_ack_d1), // Templated
      .dram_sctag_chunk_id_r0		(dram13_sctag3_chunk_id_r0_d1[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram13_sctag3_data_vld_r0_d1), // Templated
      .dram_sctag_rd_req_id_r0		(dram13_sctag3_rd_req_id_r0_d1[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram13_sctag3_secc_err_r2_d1), // Templated
      .dram_sctag_mecc_err_r2		(dram13_sctag3_mecc_err_r2_d1), // Templated
      .dram_sctag_scb_mecc_err		(dram13_sctag3_scb_mecc_err_d1), // Templated
      .dram_sctag_scb_secc_err		(dram13_sctag3_scb_secc_err_d1)); // Templated
//


/* dram_sc_0_rep2 AUTO_TEMPLATE (
    .dram_scbuf\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf2[]),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf1[]),
    .dram_sctag\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf2[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf1[]),
    .scbuf_dram\(.*\)_buf               (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf1[]),
    .sctag_dram\(.*\)_buf               (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),
    );*/
//
   dram_sc_0_rep2 dram_sc_0_rep2
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram02_scbuf0_data_r2_buf2[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram02_scbuf0_ecc_r2_buf2[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf0_dram02_wr_data_r5_buf2[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf0_dram02_data_vld_r5_buf2), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf0_dram02_data_mecc_r5_buf2), // Templated
      .sctag_dram_rd_req_buf		(sctag0_dram02_rd_req_buf2), // Templated
      .sctag_dram_rd_dummy_req_buf	(sctag0_dram02_rd_dummy_req_buf2), // Templated
      .sctag_dram_rd_req_id_buf		(sctag0_dram02_rd_req_id_buf2[2:0]), // Templated
      .sctag_dram_addr_buf		(sctag0_dram02_addr_buf2[39:5]), // Templated
      .sctag_dram_wr_req_buf		(sctag0_dram02_wr_req_buf2), // Templated
      .dram_sctag_rd_ack_buf		(dram02_sctag0_rd_ack_buf2), // Templated
      .dram_sctag_wr_ack_buf		(dram02_sctag0_wr_ack_buf2), // Templated
      .dram_sctag_chunk_id_r0_buf	(dram02_sctag0_chunk_id_r0_buf2[1:0]), // Templated
      .dram_sctag_data_vld_r0_buf	(dram02_sctag0_data_vld_r0_buf2), // Templated
      .dram_sctag_rd_req_id_r0_buf	(dram02_sctag0_rd_req_id_r0_buf2[2:0]), // Templated
      .dram_sctag_secc_err_r2_buf	(dram02_sctag0_secc_err_r2_buf2), // Templated
      .dram_sctag_mecc_err_r2_buf	(dram02_sctag0_mecc_err_r2_buf2), // Templated
      .dram_sctag_scb_mecc_err_buf	(dram02_sctag0_scb_mecc_err_buf2), // Templated
      .dram_sctag_scb_secc_err_buf	(dram02_sctag0_scb_secc_err_buf2), // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram02_scbuf0_data_r2_buf1[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf0_ecc_r2_buf1[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf0_dram02_wr_data_r5_buf1[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf0_dram02_data_vld_r5_buf1), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf0_dram02_data_mecc_r5_buf1), // Templated
      .sctag_dram_rd_req		(sctag0_dram02_rd_req),	 // Templated
      .sctag_dram_rd_dummy_req		(sctag0_dram02_rd_dummy_req), // Templated
      .sctag_dram_rd_req_id		(sctag0_dram02_rd_req_id[2:0]), // Templated
      .sctag_dram_addr			(sctag0_dram02_addr[39:5]), // Templated
      .sctag_dram_wr_req		(sctag0_dram02_wr_req),	 // Templated
      .dram_sctag_rd_ack		(dram02_sctag0_rd_ack_buf1), // Templated
      .dram_sctag_wr_ack		(dram02_sctag0_wr_ack_buf1), // Templated
      .dram_sctag_chunk_id_r0		(dram02_sctag0_chunk_id_r0_buf1[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram02_sctag0_data_vld_r0_buf1), // Templated
      .dram_sctag_rd_req_id_r0		(dram02_sctag0_rd_req_id_r0_buf1[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram02_sctag0_secc_err_r2_buf1), // Templated
      .dram_sctag_mecc_err_r2		(dram02_sctag0_mecc_err_r2_buf1), // Templated
      .dram_sctag_scb_mecc_err		(dram02_sctag0_scb_mecc_err_buf1), // Templated
      .dram_sctag_scb_secc_err		(dram02_sctag0_scb_secc_err_buf1)); // Templated
//


/* dram_sc_1_rep2 AUTO_TEMPLATE (
    .dram_scbuf\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf2[]),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf1[]),
    .dram_sctag\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf2[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf1[]),
    .scbuf_dram\(.*\)_buf               (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf1[]),
    .sctag_dram\(.*\)_buf               (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),
    );*/
//
   dram_sc_1_rep2 dram_sc_1_rep2
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram13_scbuf1_data_r2_buf2[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram13_scbuf1_ecc_r2_buf2[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf1_dram13_wr_data_r5_buf2[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf1_dram13_data_vld_r5_buf2), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf1_dram13_data_mecc_r5_buf2), // Templated
      .sctag_dram_rd_req_buf		(sctag1_dram13_rd_req_buf2), // Templated
      .sctag_dram_rd_dummy_req_buf	(sctag1_dram13_rd_dummy_req_buf2), // Templated
      .sctag_dram_rd_req_id_buf		(sctag1_dram13_rd_req_id_buf2[2:0]), // Templated
      .sctag_dram_addr_buf		(sctag1_dram13_addr_buf2[39:5]), // Templated
      .sctag_dram_wr_req_buf		(sctag1_dram13_wr_req_buf2), // Templated
      .dram_sctag_rd_ack_buf		(dram13_sctag1_rd_ack_buf2), // Templated
      .dram_sctag_wr_ack_buf		(dram13_sctag1_wr_ack_buf2), // Templated
      .dram_sctag_chunk_id_r0_buf	(dram13_sctag1_chunk_id_r0_buf2[1:0]), // Templated
      .dram_sctag_data_vld_r0_buf	(dram13_sctag1_data_vld_r0_buf2), // Templated
      .dram_sctag_rd_req_id_r0_buf	(dram13_sctag1_rd_req_id_r0_buf2[2:0]), // Templated
      .dram_sctag_secc_err_r2_buf	(dram13_sctag1_secc_err_r2_buf2), // Templated
      .dram_sctag_mecc_err_r2_buf	(dram13_sctag1_mecc_err_r2_buf2), // Templated
      .dram_sctag_scb_mecc_err_buf	(dram13_sctag1_scb_mecc_err_buf2), // Templated
      .dram_sctag_scb_secc_err_buf	(dram13_sctag1_scb_secc_err_buf2), // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram13_scbuf1_data_r2_buf1[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf1_ecc_r2_buf1[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf1_dram13_wr_data_r5_buf1[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf1_dram13_data_vld_r5_buf1), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf1_dram13_data_mecc_r5_buf1), // Templated
      .sctag_dram_rd_req		(sctag1_dram13_rd_req),	 // Templated
      .sctag_dram_rd_dummy_req		(sctag1_dram13_rd_dummy_req), // Templated
      .sctag_dram_rd_req_id		(sctag1_dram13_rd_req_id[2:0]), // Templated
      .sctag_dram_addr			(sctag1_dram13_addr[39:5]), // Templated
      .sctag_dram_wr_req		(sctag1_dram13_wr_req),	 // Templated
      .dram_sctag_rd_ack		(dram13_sctag1_rd_ack_buf1), // Templated
      .dram_sctag_wr_ack		(dram13_sctag1_wr_ack_buf1), // Templated
      .dram_sctag_chunk_id_r0		(dram13_sctag1_chunk_id_r0_buf1[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram13_sctag1_data_vld_r0_buf1), // Templated
      .dram_sctag_rd_req_id_r0		(dram13_sctag1_rd_req_id_r0_buf1[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram13_sctag1_secc_err_r2_buf1), // Templated
      .dram_sctag_mecc_err_r2		(dram13_sctag1_mecc_err_r2_buf1), // Templated
      .dram_sctag_scb_mecc_err		(dram13_sctag1_scb_mecc_err_buf1), // Templated
      .dram_sctag_scb_secc_err		(dram13_sctag1_scb_secc_err_buf1)); // Templated
//


/* dram_sc_2_rep2 AUTO_TEMPLATE (
    .dram_scbuf\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf2[]),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf1[]),
    .dram_sctag\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf2[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf1[]),
    .scbuf_dram\(.*\)_buf               (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf1[]),
    .sctag_dram\(.*\)_buf               (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),
    );*/
//
   dram_sc_2_rep2 dram_sc_2_rep2
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram02_scbuf2_data_r2_buf2[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram02_scbuf2_ecc_r2_buf2[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf2_dram02_wr_data_r5_buf2[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf2_dram02_data_vld_r5_buf2), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf2_dram02_data_mecc_r5_buf2), // Templated
      .sctag_dram_rd_req_buf		(sctag2_dram02_rd_req_buf2), // Templated
      .sctag_dram_rd_dummy_req_buf	(sctag2_dram02_rd_dummy_req_buf2), // Templated
      .sctag_dram_rd_req_id_buf		(sctag2_dram02_rd_req_id_buf2[2:0]), // Templated
      .sctag_dram_addr_buf		(sctag2_dram02_addr_buf2[39:5]), // Templated
      .sctag_dram_wr_req_buf		(sctag2_dram02_wr_req_buf2), // Templated
      .dram_sctag_rd_ack_buf		(dram02_sctag2_rd_ack_buf2), // Templated
      .dram_sctag_wr_ack_buf		(dram02_sctag2_wr_ack_buf2), // Templated
      .dram_sctag_chunk_id_r0_buf	(dram02_sctag2_chunk_id_r0_buf2[1:0]), // Templated
      .dram_sctag_data_vld_r0_buf	(dram02_sctag2_data_vld_r0_buf2), // Templated
      .dram_sctag_rd_req_id_r0_buf	(dram02_sctag2_rd_req_id_r0_buf2[2:0]), // Templated
      .dram_sctag_secc_err_r2_buf	(dram02_sctag2_secc_err_r2_buf2), // Templated
      .dram_sctag_mecc_err_r2_buf	(dram02_sctag2_mecc_err_r2_buf2), // Templated
      .dram_sctag_scb_mecc_err_buf	(dram02_sctag2_scb_mecc_err_buf2), // Templated
      .dram_sctag_scb_secc_err_buf	(dram02_sctag2_scb_secc_err_buf2), // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram02_scbuf2_data_r2_buf1[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf2_ecc_r2_buf1[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf2_dram02_wr_data_r5_buf1[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf2_dram02_data_vld_r5_buf1), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf2_dram02_data_mecc_r5_buf1), // Templated
      .sctag_dram_rd_req		(sctag2_dram02_rd_req),	 // Templated
      .sctag_dram_rd_dummy_req		(sctag2_dram02_rd_dummy_req), // Templated
      .sctag_dram_rd_req_id		(sctag2_dram02_rd_req_id[2:0]), // Templated
      .sctag_dram_addr			(sctag2_dram02_addr[39:5]), // Templated
      .sctag_dram_wr_req		(sctag2_dram02_wr_req),	 // Templated
      .dram_sctag_rd_ack		(dram02_sctag2_rd_ack_buf1), // Templated
      .dram_sctag_wr_ack		(dram02_sctag2_wr_ack_buf1), // Templated
      .dram_sctag_chunk_id_r0		(dram02_sctag2_chunk_id_r0_buf1[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram02_sctag2_data_vld_r0_buf1), // Templated
      .dram_sctag_rd_req_id_r0		(dram02_sctag2_rd_req_id_r0_buf1[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram02_sctag2_secc_err_r2_buf1), // Templated
      .dram_sctag_mecc_err_r2		(dram02_sctag2_mecc_err_r2_buf1), // Templated
      .dram_sctag_scb_mecc_err		(dram02_sctag2_scb_mecc_err_buf1), // Templated
      .dram_sctag_scb_secc_err		(dram02_sctag2_scb_secc_err_buf1)); // Templated
//


/* dram_sc_3_rep2 AUTO_TEMPLATE (
    .dram_scbuf\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf2[]),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf1[]),
    .dram_sctag\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf2[]),
    .dram_sctag\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_sctag@\1_buf1[]),
    .scbuf_dram\(.*\)_buf               (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf1[]),
    .sctag_dram\(.*\)_buf               (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf2[]),
    .sctag_dram\(.*\)                   (sctag@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),
    );*/
//
   dram_sc_3_rep2 dram_sc_3_rep2
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram13_scbuf3_data_r2_buf2[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram13_scbuf3_ecc_r2_buf2[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf3_dram13_wr_data_r5_buf2[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf3_dram13_data_vld_r5_buf2), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf3_dram13_data_mecc_r5_buf2), // Templated
      .sctag_dram_rd_req_buf		(sctag3_dram13_rd_req_buf2), // Templated
      .sctag_dram_rd_dummy_req_buf	(sctag3_dram13_rd_dummy_req_buf2), // Templated
      .sctag_dram_rd_req_id_buf		(sctag3_dram13_rd_req_id_buf2[2:0]), // Templated
      .sctag_dram_addr_buf		(sctag3_dram13_addr_buf2[39:5]), // Templated
      .sctag_dram_wr_req_buf		(sctag3_dram13_wr_req_buf2), // Templated
      .dram_sctag_rd_ack_buf		(dram13_sctag3_rd_ack_buf2), // Templated
      .dram_sctag_wr_ack_buf		(dram13_sctag3_wr_ack_buf2), // Templated
      .dram_sctag_chunk_id_r0_buf	(dram13_sctag3_chunk_id_r0_buf2[1:0]), // Templated
      .dram_sctag_data_vld_r0_buf	(dram13_sctag3_data_vld_r0_buf2), // Templated
      .dram_sctag_rd_req_id_r0_buf	(dram13_sctag3_rd_req_id_r0_buf2[2:0]), // Templated
      .dram_sctag_secc_err_r2_buf	(dram13_sctag3_secc_err_r2_buf2), // Templated
      .dram_sctag_mecc_err_r2_buf	(dram13_sctag3_mecc_err_r2_buf2), // Templated
      .dram_sctag_scb_mecc_err_buf	(dram13_sctag3_scb_mecc_err_buf2), // Templated
      .dram_sctag_scb_secc_err_buf	(dram13_sctag3_scb_secc_err_buf2), // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram13_scbuf3_data_r2_buf1[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf3_ecc_r2_buf1[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf3_dram13_wr_data_r5_buf1[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf3_dram13_data_vld_r5_buf1), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf3_dram13_data_mecc_r5_buf1), // Templated
      .sctag_dram_rd_req		(sctag3_dram13_rd_req),	 // Templated
      .sctag_dram_rd_dummy_req		(sctag3_dram13_rd_dummy_req), // Templated
      .sctag_dram_rd_req_id		(sctag3_dram13_rd_req_id[2:0]), // Templated
      .sctag_dram_addr			(sctag3_dram13_addr[39:5]), // Templated
      .sctag_dram_wr_req		(sctag3_dram13_wr_req),	 // Templated
      .dram_sctag_rd_ack		(dram13_sctag3_rd_ack_buf1), // Templated
      .dram_sctag_wr_ack		(dram13_sctag3_wr_ack_buf1), // Templated
      .dram_sctag_chunk_id_r0		(dram13_sctag3_chunk_id_r0_buf1[1:0]), // Templated
      .dram_sctag_data_vld_r0		(dram13_sctag3_data_vld_r0_buf1), // Templated
      .dram_sctag_rd_req_id_r0		(dram13_sctag3_rd_req_id_r0_buf1[2:0]), // Templated
      .dram_sctag_secc_err_r2		(dram13_sctag3_secc_err_r2_buf1), // Templated
      .dram_sctag_mecc_err_r2		(dram13_sctag3_mecc_err_r2_buf1), // Templated
      .dram_sctag_scb_mecc_err		(dram13_sctag3_scb_mecc_err_buf1), // Templated
      .dram_sctag_scb_secc_err		(dram13_sctag3_scb_secc_err_buf1)); // Templated
//


/* dram_l2_buf2 AUTO_TEMPLATE (
    .dram_scbuf\(.*\)_buf               (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf3[]),
    .dram_scbuf\(.*\)                   (dram@"(% @ 2)"@"(+ (% @ 2) 2)"_scbuf@\1_buf2[]),
    .scbuf_dram\(.*\)_buf               (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1_buf1[]),
    .scbuf_dram\(.*\)                   (scbuf@_dram@"(% @ 2)"@"(+ (% @ 2) 2)"\1[]),
    .sctag_dram_rd_req                  (1'b0),
    .sctag_dram_rd_dummy_req            (1'b0),
    .sctag_dram_rd_req_id               (3'b0),
    .sctag_dram_addr                    (35'b0),
    .sctag_dram_wr_req                  (1'b0),
    .dram_sctag_rd_ack                  (1'b0),
    .dram_sctag_wr_ack                  (1'b0),
    .dram_sctag_chunk_id_r0             (2'b0),
    .dram_sctag_data_vld_r0             (1'b0),
    .dram_sctag_rd_req_id_r0            (3'b0),
    .dram_sctag_secc_err_r2             (1'b0),
    .dram_sctag_mecc_err_r2             (1'b0),
    .dram_sctag_scb_mecc_err            (1'b0),
    .dram_sctag_scb_secc_err            (1'b0),
    .dram_sctag\(.*\)                   (),
    .sctag_dram\(.*\)                   (),
    );*/
//
   dram_l2_buf2 dram_sc_0_rep3
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram02_scbuf0_data_r2_buf3[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram02_scbuf0_ecc_r2_buf3[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf0_dram02_wr_data_r5_buf1[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf0_dram02_data_vld_r5_buf1), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf0_dram02_data_mecc_r5_buf1), // Templated
      .sctag_dram_rd_req_buf		(),			 // Templated
      .sctag_dram_rd_dummy_req_buf	(),			 // Templated
      .sctag_dram_rd_req_id_buf		(),			 // Templated
      .sctag_dram_addr_buf		(),			 // Templated
      .sctag_dram_wr_req_buf		(),			 // Templated
      .dram_sctag_rd_ack_buf		(),			 // Templated
      .dram_sctag_wr_ack_buf		(),			 // Templated
      .dram_sctag_chunk_id_r0_buf	(),			 // Templated
      .dram_sctag_data_vld_r0_buf	(),			 // Templated
      .dram_sctag_rd_req_id_r0_buf	(),			 // Templated
      .dram_sctag_secc_err_r2_buf	(),			 // Templated
      .dram_sctag_mecc_err_r2_buf	(),			 // Templated
      .dram_sctag_scb_mecc_err_buf	(),			 // Templated
      .dram_sctag_scb_secc_err_buf	(),			 // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram02_scbuf0_data_r2_buf2[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf0_ecc_r2_buf2[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf0_dram02_wr_data_r5[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf0_dram02_data_vld_r5), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf0_dram02_data_mecc_r5), // Templated
      .sctag_dram_rd_req		(1'b0),			 // Templated
      .sctag_dram_rd_dummy_req		(1'b0),			 // Templated
      .sctag_dram_rd_req_id		(3'b0),			 // Templated
      .sctag_dram_addr			(35'b0),		 // Templated
      .sctag_dram_wr_req		(1'b0),			 // Templated
      .dram_sctag_rd_ack		(1'b0),			 // Templated
      .dram_sctag_wr_ack		(1'b0),			 // Templated
      .dram_sctag_chunk_id_r0		(2'b0),			 // Templated
      .dram_sctag_data_vld_r0		(1'b0),			 // Templated
      .dram_sctag_rd_req_id_r0		(3'b0),			 // Templated
      .dram_sctag_secc_err_r2		(1'b0),			 // Templated
      .dram_sctag_mecc_err_r2		(1'b0),			 // Templated
      .dram_sctag_scb_mecc_err		(1'b0),			 // Templated
      .dram_sctag_scb_secc_err		(1'b0));			 // Templated
//
   dram_l2_buf2 dram_sc_1_rep3
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram13_scbuf1_data_r2_buf3[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram13_scbuf1_ecc_r2_buf3[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf1_dram13_wr_data_r5_buf1[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf1_dram13_data_vld_r5_buf1), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf1_dram13_data_mecc_r5_buf1), // Templated
      .sctag_dram_rd_req_buf		(),			 // Templated
      .sctag_dram_rd_dummy_req_buf	(),			 // Templated
      .sctag_dram_rd_req_id_buf		(),			 // Templated
      .sctag_dram_addr_buf		(),			 // Templated
      .sctag_dram_wr_req_buf		(),			 // Templated
      .dram_sctag_rd_ack_buf		(),			 // Templated
      .dram_sctag_wr_ack_buf		(),			 // Templated
      .dram_sctag_chunk_id_r0_buf	(),			 // Templated
      .dram_sctag_data_vld_r0_buf	(),			 // Templated
      .dram_sctag_rd_req_id_r0_buf	(),			 // Templated
      .dram_sctag_secc_err_r2_buf	(),			 // Templated
      .dram_sctag_mecc_err_r2_buf	(),			 // Templated
      .dram_sctag_scb_mecc_err_buf	(),			 // Templated
      .dram_sctag_scb_secc_err_buf	(),			 // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram13_scbuf1_data_r2_buf2[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf1_ecc_r2_buf2[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf1_dram13_wr_data_r5[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf1_dram13_data_vld_r5), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf1_dram13_data_mecc_r5), // Templated
      .sctag_dram_rd_req		(1'b0),			 // Templated
      .sctag_dram_rd_dummy_req		(1'b0),			 // Templated
      .sctag_dram_rd_req_id		(3'b0),			 // Templated
      .sctag_dram_addr			(35'b0),		 // Templated
      .sctag_dram_wr_req		(1'b0),			 // Templated
      .dram_sctag_rd_ack		(1'b0),			 // Templated
      .dram_sctag_wr_ack		(1'b0),			 // Templated
      .dram_sctag_chunk_id_r0		(2'b0),			 // Templated
      .dram_sctag_data_vld_r0		(1'b0),			 // Templated
      .dram_sctag_rd_req_id_r0		(3'b0),			 // Templated
      .dram_sctag_secc_err_r2		(1'b0),			 // Templated
      .dram_sctag_mecc_err_r2		(1'b0),			 // Templated
      .dram_sctag_scb_mecc_err		(1'b0),			 // Templated
      .dram_sctag_scb_secc_err		(1'b0));			 // Templated
//
   dram_l2_buf2 dram_sc_2_rep3
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram02_scbuf2_data_r2_buf3[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram02_scbuf2_ecc_r2_buf3[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf2_dram02_wr_data_r5_buf1[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf2_dram02_data_vld_r5_buf1), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf2_dram02_data_mecc_r5_buf1), // Templated
      .sctag_dram_rd_req_buf		(),			 // Templated
      .sctag_dram_rd_dummy_req_buf	(),			 // Templated
      .sctag_dram_rd_req_id_buf		(),			 // Templated
      .sctag_dram_addr_buf		(),			 // Templated
      .sctag_dram_wr_req_buf		(),			 // Templated
      .dram_sctag_rd_ack_buf		(),			 // Templated
      .dram_sctag_wr_ack_buf		(),			 // Templated
      .dram_sctag_chunk_id_r0_buf	(),			 // Templated
      .dram_sctag_data_vld_r0_buf	(),			 // Templated
      .dram_sctag_rd_req_id_r0_buf	(),			 // Templated
      .dram_sctag_secc_err_r2_buf	(),			 // Templated
      .dram_sctag_mecc_err_r2_buf	(),			 // Templated
      .dram_sctag_scb_mecc_err_buf	(),			 // Templated
      .dram_sctag_scb_secc_err_buf	(),			 // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram02_scbuf2_data_r2_buf2[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram02_scbuf2_ecc_r2_buf2[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf2_dram02_wr_data_r5[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf2_dram02_data_vld_r5), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf2_dram02_data_mecc_r5), // Templated
      .sctag_dram_rd_req		(1'b0),			 // Templated
      .sctag_dram_rd_dummy_req		(1'b0),			 // Templated
      .sctag_dram_rd_req_id		(3'b0),			 // Templated
      .sctag_dram_addr			(35'b0),		 // Templated
      .sctag_dram_wr_req		(1'b0),			 // Templated
      .dram_sctag_rd_ack		(1'b0),			 // Templated
      .dram_sctag_wr_ack		(1'b0),			 // Templated
      .dram_sctag_chunk_id_r0		(2'b0),			 // Templated
      .dram_sctag_data_vld_r0		(1'b0),			 // Templated
      .dram_sctag_rd_req_id_r0		(3'b0),			 // Templated
      .dram_sctag_secc_err_r2		(1'b0),			 // Templated
      .dram_sctag_mecc_err_r2		(1'b0),			 // Templated
      .dram_sctag_scb_mecc_err		(1'b0),			 // Templated
      .dram_sctag_scb_secc_err		(1'b0));			 // Templated
//
   dram_l2_buf2 dram_sc_3_rep3
     (/*AUTOINST*/
      // Outputs
      .dram_scbuf_data_r2_buf		(dram13_scbuf3_data_r2_buf3[127:0]), // Templated
      .dram_scbuf_ecc_r2_buf		(dram13_scbuf3_ecc_r2_buf3[27:0]), // Templated
      .scbuf_dram_wr_data_r5_buf	(scbuf3_dram13_wr_data_r5_buf1[63:0]), // Templated
      .scbuf_dram_data_vld_r5_buf	(scbuf3_dram13_data_vld_r5_buf1), // Templated
      .scbuf_dram_data_mecc_r5_buf	(scbuf3_dram13_data_mecc_r5_buf1), // Templated
      .sctag_dram_rd_req_buf		(),			 // Templated
      .sctag_dram_rd_dummy_req_buf	(),			 // Templated
      .sctag_dram_rd_req_id_buf		(),			 // Templated
      .sctag_dram_addr_buf		(),			 // Templated
      .sctag_dram_wr_req_buf		(),			 // Templated
      .dram_sctag_rd_ack_buf		(),			 // Templated
      .dram_sctag_wr_ack_buf		(),			 // Templated
      .dram_sctag_chunk_id_r0_buf	(),			 // Templated
      .dram_sctag_data_vld_r0_buf	(),			 // Templated
      .dram_sctag_rd_req_id_r0_buf	(),			 // Templated
      .dram_sctag_secc_err_r2_buf	(),			 // Templated
      .dram_sctag_mecc_err_r2_buf	(),			 // Templated
      .dram_sctag_scb_mecc_err_buf	(),			 // Templated
      .dram_sctag_scb_secc_err_buf	(),			 // Templated
      // Inputs
      .dram_scbuf_data_r2		(dram13_scbuf3_data_r2_buf2[127:0]), // Templated
      .dram_scbuf_ecc_r2		(dram13_scbuf3_ecc_r2_buf2[27:0]), // Templated
      .scbuf_dram_wr_data_r5		(scbuf3_dram13_wr_data_r5[63:0]), // Templated
      .scbuf_dram_data_vld_r5		(scbuf3_dram13_data_vld_r5), // Templated
      .scbuf_dram_data_mecc_r5		(scbuf3_dram13_data_mecc_r5), // Templated
      .sctag_dram_rd_req		(1'b0),			 // Templated
      .sctag_dram_rd_dummy_req		(1'b0),			 // Templated
      .sctag_dram_rd_req_id		(3'b0),			 // Templated
      .sctag_dram_addr			(35'b0),		 // Templated
      .sctag_dram_wr_req		(1'b0),			 // Templated
      .dram_sctag_rd_ack		(1'b0),			 // Templated
      .dram_sctag_wr_ack		(1'b0),			 // Templated
      .dram_sctag_chunk_id_r0		(2'b0),			 // Templated
      .dram_sctag_data_vld_r0		(1'b0),			 // Templated
      .dram_sctag_rd_req_id_r0		(3'b0),			 // Templated
      .dram_sctag_secc_err_r2		(1'b0),			 // Templated
      .dram_sctag_mecc_err_r2		(1'b0),			 // Templated
      .dram_sctag_scb_mecc_err		(1'b0),			 // Templated
      .dram_sctag_scb_secc_err		(1'b0));			 // Templated
//


/* ff_jbi_sc0_1 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rsc12_rsc01_so),
    .so                                 (rsc01_rsc11_so),

    .scbuf_jbi_\(.*\)_d1                (scbuf@_jbi_\1_d2[]),
    .scbuf_jbi_\(.*\)                   (scbuf@_jbi_\1_d1_buf1[]),
    .sctag_jbi_\(.*\)_d1                (sctag@_jbi_\1_d2[]),
    .sctag_jbi_\(.*\)                   (sctag@_jbi_\1_d1_buf1[]),
    .jbi_scbuf_\(.*\)                   (jbi_scbuf@_\1[]),
    .jbi_sctag_\(.*\)                   (jbi_sctag@_\1[]),
    );*/
//
   ff_jbi_sc0_1 ff_jbi_sc0_1
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_d1			(jbi_sctag0_req_d1[31:0]), // Templated
      .scbuf_jbi_data_d1		(scbuf0_jbi_data_d2[31:0]), // Templated
      .jbi_scbuf_ecc_d1			(jbi_scbuf0_ecc_d1[6:0]), // Templated
      .jbi_sctag_req_vld_d1		(jbi_sctag0_req_vld_d1), // Templated
      .scbuf_jbi_ctag_vld_d1		(scbuf0_jbi_ctag_vld_d2), // Templated
      .scbuf_jbi_ue_err_d1		(scbuf0_jbi_ue_err_d2),	 // Templated
      .sctag_jbi_iq_dequeue_d1		(sctag0_jbi_iq_dequeue_d2), // Templated
      .sctag_jbi_wib_dequeue_d1		(sctag0_jbi_wib_dequeue_d2), // Templated
      .sctag_jbi_por_req_d1		(sctag0_jbi_por_req_d2), // Templated
      .so				(rsc01_rsc11_so),	 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag0_req[31:0]),	 // Templated
      .scbuf_jbi_data			(scbuf0_jbi_data_d1_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf0_ecc[6:0]),	 // Templated
      .jbi_sctag_req_vld		(jbi_sctag0_req_vld),	 // Templated
      .scbuf_jbi_ctag_vld		(scbuf0_jbi_ctag_vld_d1_buf1), // Templated
      .scbuf_jbi_ue_err			(scbuf0_jbi_ue_err_d1_buf1), // Templated
      .sctag_jbi_iq_dequeue		(sctag0_jbi_iq_dequeue_d1_buf1), // Templated
      .sctag_jbi_wib_dequeue		(sctag0_jbi_wib_dequeue_d1_buf1), // Templated
      .sctag_jbi_por_req		(sctag0_jbi_por_req_d1_buf1), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rsc12_rsc01_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ff_jbi_sc1_1 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rsc01_rsc11_so),
    .so                                 (rsc11_rsc21_so),

    .scbuf_jbi_\(.*\)_d1                (scbuf@_jbi_\1_d2[]),
    .scbuf_jbi_\(.*\)                   (scbuf@_jbi_\1_d1_buf1[]),
    .sctag_jbi_\(.*\)_d1                (sctag@_jbi_\1_d2[]),
    .sctag_jbi_\(.*\)                   (sctag@_jbi_\1_d1_buf1[]),

    .jbi_sctag_\(.*\)_d1                (jbi_sctag@_\1_d1[]),
    .jbi_sctag_\(.*\)                   (jbi_sctag@_\1[]),
    .jbi_scbuf_\(.*\)_d1                (jbi_scbuf@_\1_d1[]),
    .jbi_scbuf_\(.*\)                   (jbi_scbuf@_\1[]),
    );*/
//
   ff_jbi_sc1_1 ff_jbi_sc1_1
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_d1			(jbi_sctag1_req_d1[31:0]), // Templated
      .scbuf_jbi_data_d1		(scbuf1_jbi_data_d2[31:0]), // Templated
      .jbi_scbuf_ecc_d1			(jbi_scbuf1_ecc_d1[6:0]), // Templated
      .jbi_sctag_req_vld_d1		(jbi_sctag1_req_vld_d1), // Templated
      .scbuf_jbi_ctag_vld_d1		(scbuf1_jbi_ctag_vld_d2), // Templated
      .scbuf_jbi_ue_err_d1		(scbuf1_jbi_ue_err_d2),	 // Templated
      .sctag_jbi_iq_dequeue_d1		(sctag1_jbi_iq_dequeue_d2), // Templated
      .sctag_jbi_wib_dequeue_d1		(sctag1_jbi_wib_dequeue_d2), // Templated
      .sctag_jbi_por_req_d1		(sctag1_jbi_por_req_d2), // Templated
      .so				(rsc11_rsc21_so),	 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag1_req[31:0]),	 // Templated
      .scbuf_jbi_data			(scbuf1_jbi_data_d1_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf1_ecc[6:0]),	 // Templated
      .jbi_sctag_req_vld		(jbi_sctag1_req_vld),	 // Templated
      .scbuf_jbi_ctag_vld		(scbuf1_jbi_ctag_vld_d1_buf1), // Templated
      .scbuf_jbi_ue_err			(scbuf1_jbi_ue_err_d1_buf1), // Templated
      .sctag_jbi_iq_dequeue		(sctag1_jbi_iq_dequeue_d1_buf1), // Templated
      .sctag_jbi_wib_dequeue		(sctag1_jbi_wib_dequeue_d1_buf1), // Templated
      .sctag_jbi_por_req		(sctag1_jbi_por_req_d1_buf1), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rsc01_rsc11_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ff_jbi_sc2_1 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rsc11_rsc21_so),
    .so                                 (rsc21_rsc31_so),

    .scbuf_jbi_\(.*\)_d1                (scbuf@_jbi_\1_d2[]),
    .scbuf_jbi_\(.*\)                   (scbuf@_jbi_\1_d1_buf1[]),
    .sctag_jbi_\(.*\)_d1                (sctag@_jbi_\1_d2[]),
    .sctag_jbi_\(.*\)                   (sctag@_jbi_\1_d1_buf1[]),

    .jbi_sctag_\(.*\)_d1                (jbi_sctag@_\1_d1[]),
    .jbi_sctag_\(.*\)                   (jbi_sctag@_\1[]),
    .jbi_scbuf_\(.*\)_d1                (jbi_scbuf@_\1_d1[]),
    .jbi_scbuf_\(.*\)                   (jbi_scbuf@_\1[]),
    );*/
//
   ff_jbi_sc2_1 ff_jbi_sc2_1
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_d1			(jbi_sctag2_req_d1[31:0]), // Templated
      .scbuf_jbi_data_d1		(scbuf2_jbi_data_d2[31:0]), // Templated
      .jbi_scbuf_ecc_d1			(jbi_scbuf2_ecc_d1[6:0]), // Templated
      .jbi_sctag_req_vld_d1		(jbi_sctag2_req_vld_d1), // Templated
      .scbuf_jbi_ctag_vld_d1		(scbuf2_jbi_ctag_vld_d2), // Templated
      .scbuf_jbi_ue_err_d1		(scbuf2_jbi_ue_err_d2),	 // Templated
      .sctag_jbi_iq_dequeue_d1		(sctag2_jbi_iq_dequeue_d2), // Templated
      .sctag_jbi_wib_dequeue_d1		(sctag2_jbi_wib_dequeue_d2), // Templated
      .sctag_jbi_por_req_d1		(sctag2_jbi_por_req_d2), // Templated
      .so				(rsc21_rsc31_so),	 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag2_req[31:0]),	 // Templated
      .scbuf_jbi_data			(scbuf2_jbi_data_d1_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf2_ecc[6:0]),	 // Templated
      .jbi_sctag_req_vld		(jbi_sctag2_req_vld),	 // Templated
      .scbuf_jbi_ctag_vld		(scbuf2_jbi_ctag_vld_d1_buf1), // Templated
      .scbuf_jbi_ue_err			(scbuf2_jbi_ue_err_d1_buf1), // Templated
      .sctag_jbi_iq_dequeue		(sctag2_jbi_iq_dequeue_d1_buf1), // Templated
      .sctag_jbi_wib_dequeue		(sctag2_jbi_wib_dequeue_d1_buf1), // Templated
      .sctag_jbi_por_req		(sctag2_jbi_por_req_d1_buf1), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rsc11_rsc21_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ff_jbi_sc3_1 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rsc21_rsc31_so),
    .so                                 (rsc21_rsc32_so),

    .scbuf_jbi_\(.*\)_d1                (scbuf@_jbi_\1_d2[]),
    .scbuf_jbi_\(.*\)                   (scbuf@_jbi_\1_d1_buf1[]),
    .sctag_jbi_\(.*\)_d1                (sctag@_jbi_\1_d2[]),
    .sctag_jbi_\(.*\)                   (sctag@_jbi_\1_d1_buf1[]),

    .jbi_sctag_\(.*\)_d1                (jbi_sctag@_\1_d1[]),
    .jbi_sctag_\(.*\)                   (jbi_sctag@_\1[]),
    .jbi_scbuf_\(.*\)_d1                (jbi_scbuf@_\1_d1[]),
    .jbi_scbuf_\(.*\)                   (jbi_scbuf@_\1[]),
    );*/
//
   ff_jbi_sc3_1 ff_jbi_sc3_1
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_d1			(jbi_sctag3_req_d1[31:0]), // Templated
      .scbuf_jbi_data_d1		(scbuf3_jbi_data_d2[31:0]), // Templated
      .jbi_scbuf_ecc_d1			(jbi_scbuf3_ecc_d1[6:0]), // Templated
      .jbi_sctag_req_vld_d1		(jbi_sctag3_req_vld_d1), // Templated
      .scbuf_jbi_ctag_vld_d1		(scbuf3_jbi_ctag_vld_d2), // Templated
      .scbuf_jbi_ue_err_d1		(scbuf3_jbi_ue_err_d2),	 // Templated
      .sctag_jbi_iq_dequeue_d1		(sctag3_jbi_iq_dequeue_d2), // Templated
      .sctag_jbi_wib_dequeue_d1		(sctag3_jbi_wib_dequeue_d2), // Templated
      .sctag_jbi_por_req_d1		(sctag3_jbi_por_req_d2), // Templated
      .so				(rsc21_rsc32_so),	 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag3_req[31:0]),	 // Templated
      .scbuf_jbi_data			(scbuf3_jbi_data_d1_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf3_ecc[6:0]),	 // Templated
      .jbi_sctag_req_vld		(jbi_sctag3_req_vld),	 // Templated
      .scbuf_jbi_ctag_vld		(scbuf3_jbi_ctag_vld_d1_buf1), // Templated
      .scbuf_jbi_ue_err			(scbuf3_jbi_ue_err_d1_buf1), // Templated
      .sctag_jbi_iq_dequeue		(sctag3_jbi_iq_dequeue_d1_buf1), // Templated
      .sctag_jbi_wib_dequeue		(sctag3_jbi_wib_dequeue_d1_buf1), // Templated
      .sctag_jbi_por_req		(sctag3_jbi_por_req_d1_buf1), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rsc21_rsc31_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* jbi_l2_buf2 AUTO_TEMPLATE (
    .scbuf_jbi_\(.*\)_buf               (scbuf@_jbi_\1_d1_buf1[]),
    .scbuf_jbi_\(.*\)                   (scbuf@_jbi_\1_d1[]),
    .sctag_jbi_\(.*\)_buf               (sctag@_jbi_\1_d1_buf1[]),
    .sctag_jbi_\(.*\)                   (sctag@_jbi_\1_d1[]),
    .jbi_scbuf\(.*\)_buf                (jbi_scbuf@\1_d1_buf1[]),
    .jbi_scbuf_\(.*\)                   (jbi_scbuf@_\1_d1[]),
    .jbi_sctag_\(.*\)_buf               (jbi_sctag@_\1_d1_buf1[]),
    .jbi_sctag_\(.*\)                   (jbi_sctag@_\1_d1[]),
    );*/
//
   jbi_l2_buf2 rep_jbi_sc0_1
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_buf		(jbi_sctag0_req_d1_buf1[31:0]), // Templated
      .scbuf_jbi_data_buf		(scbuf0_jbi_data_d1_buf1[31:0]), // Templated
      .jbi_scbuf_ecc_buf		(jbi_scbuf0_ecc_d1_buf1[6:0]), // Templated
      .jbi_sctag_req_vld_buf		(jbi_sctag0_req_vld_d1_buf1), // Templated
      .scbuf_jbi_ctag_vld_buf		(scbuf0_jbi_ctag_vld_d1_buf1), // Templated
      .scbuf_jbi_ue_err_buf		(scbuf0_jbi_ue_err_d1_buf1), // Templated
      .sctag_jbi_iq_dequeue_buf		(sctag0_jbi_iq_dequeue_d1_buf1), // Templated
      .sctag_jbi_wib_dequeue_buf	(sctag0_jbi_wib_dequeue_d1_buf1), // Templated
      .sctag_jbi_por_req_buf		(sctag0_jbi_por_req_d1_buf1), // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag0_req_d1[31:0]), // Templated
      .scbuf_jbi_data			(scbuf0_jbi_data_d1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf0_ecc_d1[6:0]), // Templated
      .jbi_sctag_req_vld		(jbi_sctag0_req_vld_d1), // Templated
      .scbuf_jbi_ctag_vld		(scbuf0_jbi_ctag_vld_d1), // Templated
      .scbuf_jbi_ue_err			(scbuf0_jbi_ue_err_d1),	 // Templated
      .sctag_jbi_iq_dequeue		(sctag0_jbi_iq_dequeue_d1), // Templated
      .sctag_jbi_wib_dequeue		(sctag0_jbi_wib_dequeue_d1), // Templated
      .sctag_jbi_por_req		(sctag0_jbi_por_req_d1)); // Templated
//
   jbi_l2_buf2 rep_jbi_sc1_1
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_buf		(jbi_sctag1_req_d1_buf1[31:0]), // Templated
      .scbuf_jbi_data_buf		(scbuf1_jbi_data_d1_buf1[31:0]), // Templated
      .jbi_scbuf_ecc_buf		(jbi_scbuf1_ecc_d1_buf1[6:0]), // Templated
      .jbi_sctag_req_vld_buf		(jbi_sctag1_req_vld_d1_buf1), // Templated
      .scbuf_jbi_ctag_vld_buf		(scbuf1_jbi_ctag_vld_d1_buf1), // Templated
      .scbuf_jbi_ue_err_buf		(scbuf1_jbi_ue_err_d1_buf1), // Templated
      .sctag_jbi_iq_dequeue_buf		(sctag1_jbi_iq_dequeue_d1_buf1), // Templated
      .sctag_jbi_wib_dequeue_buf	(sctag1_jbi_wib_dequeue_d1_buf1), // Templated
      .sctag_jbi_por_req_buf		(sctag1_jbi_por_req_d1_buf1), // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag1_req_d1[31:0]), // Templated
      .scbuf_jbi_data			(scbuf1_jbi_data_d1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf1_ecc_d1[6:0]), // Templated
      .jbi_sctag_req_vld		(jbi_sctag1_req_vld_d1), // Templated
      .scbuf_jbi_ctag_vld		(scbuf1_jbi_ctag_vld_d1), // Templated
      .scbuf_jbi_ue_err			(scbuf1_jbi_ue_err_d1),	 // Templated
      .sctag_jbi_iq_dequeue		(sctag1_jbi_iq_dequeue_d1), // Templated
      .sctag_jbi_wib_dequeue		(sctag1_jbi_wib_dequeue_d1), // Templated
      .sctag_jbi_por_req		(sctag1_jbi_por_req_d1)); // Templated
//
   jbi_l2_buf2 rep_jbi_sc2_1
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_buf		(jbi_sctag2_req_d1_buf1[31:0]), // Templated
      .scbuf_jbi_data_buf		(scbuf2_jbi_data_d1_buf1[31:0]), // Templated
      .jbi_scbuf_ecc_buf		(jbi_scbuf2_ecc_d1_buf1[6:0]), // Templated
      .jbi_sctag_req_vld_buf		(jbi_sctag2_req_vld_d1_buf1), // Templated
      .scbuf_jbi_ctag_vld_buf		(scbuf2_jbi_ctag_vld_d1_buf1), // Templated
      .scbuf_jbi_ue_err_buf		(scbuf2_jbi_ue_err_d1_buf1), // Templated
      .sctag_jbi_iq_dequeue_buf		(sctag2_jbi_iq_dequeue_d1_buf1), // Templated
      .sctag_jbi_wib_dequeue_buf	(sctag2_jbi_wib_dequeue_d1_buf1), // Templated
      .sctag_jbi_por_req_buf		(sctag2_jbi_por_req_d1_buf1), // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag2_req_d1[31:0]), // Templated
      .scbuf_jbi_data			(scbuf2_jbi_data_d1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf2_ecc_d1[6:0]), // Templated
      .jbi_sctag_req_vld		(jbi_sctag2_req_vld_d1), // Templated
      .scbuf_jbi_ctag_vld		(scbuf2_jbi_ctag_vld_d1), // Templated
      .scbuf_jbi_ue_err			(scbuf2_jbi_ue_err_d1),	 // Templated
      .sctag_jbi_iq_dequeue		(sctag2_jbi_iq_dequeue_d1), // Templated
      .sctag_jbi_wib_dequeue		(sctag2_jbi_wib_dequeue_d1), // Templated
      .sctag_jbi_por_req		(sctag2_jbi_por_req_d1)); // Templated
//
   jbi_l2_buf2 rep_jbi_sc3_1
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_buf		(jbi_sctag3_req_d1_buf1[31:0]), // Templated
      .scbuf_jbi_data_buf		(scbuf3_jbi_data_d1_buf1[31:0]), // Templated
      .jbi_scbuf_ecc_buf		(jbi_scbuf3_ecc_d1_buf1[6:0]), // Templated
      .jbi_sctag_req_vld_buf		(jbi_sctag3_req_vld_d1_buf1), // Templated
      .scbuf_jbi_ctag_vld_buf		(scbuf3_jbi_ctag_vld_d1_buf1), // Templated
      .scbuf_jbi_ue_err_buf		(scbuf3_jbi_ue_err_d1_buf1), // Templated
      .sctag_jbi_iq_dequeue_buf		(sctag3_jbi_iq_dequeue_d1_buf1), // Templated
      .sctag_jbi_wib_dequeue_buf	(sctag3_jbi_wib_dequeue_d1_buf1), // Templated
      .sctag_jbi_por_req_buf		(sctag3_jbi_por_req_d1_buf1), // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag3_req_d1[31:0]), // Templated
      .scbuf_jbi_data			(scbuf3_jbi_data_d1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf3_ecc_d1[6:0]), // Templated
      .jbi_sctag_req_vld		(jbi_sctag3_req_vld_d1), // Templated
      .scbuf_jbi_ctag_vld		(scbuf3_jbi_ctag_vld_d1), // Templated
      .scbuf_jbi_ue_err			(scbuf3_jbi_ue_err_d1),	 // Templated
      .sctag_jbi_iq_dequeue		(sctag3_jbi_iq_dequeue_d1), // Templated
      .sctag_jbi_wib_dequeue		(sctag3_jbi_wib_dequeue_d1), // Templated
      .sctag_jbi_por_req		(sctag3_jbi_por_req_d1)); // Templated
//


/* ff_jbi_sc0_2 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rdbg01_rsc02_so),
    .so                                 (rsc02_rptrs_so),

    .scbuf_jbi_\(.*\)_d1                (scbuf@_jbi_\1_d1[]),
    .scbuf_jbi_\(.*\)                   (scbuf@_jbi_\1_buf1[]),
    .sctag_jbi_\(.*\)                   (sctag@_jbi_\1[]),

    .jbi_sctag_\(.*\)_d1                (jbi_sctag@_\1_d2[]),
    .jbi_sctag_\(.*\)                   (jbi_sctag@_\1_d1_buf1[]),
    .jbi_scbuf_\(.*\)_d1                (jbi_scbuf@_\1_d2[]),
    .jbi_scbuf_\(.*\)                   (jbi_scbuf@_\1_d1_buf1[]),
    );*/
//
   ff_jbi_sc0_2 ff_jbi_sc0_2
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_d1			(jbi_sctag0_req_d2[31:0]), // Templated
      .scbuf_jbi_data_d1		(scbuf0_jbi_data_d1[31:0]), // Templated
      .jbi_scbuf_ecc_d1			(jbi_scbuf0_ecc_d2[6:0]), // Templated
      .jbi_sctag_req_vld_d1		(jbi_sctag0_req_vld_d2), // Templated
      .scbuf_jbi_ctag_vld_d1		(scbuf0_jbi_ctag_vld_d1), // Templated
      .scbuf_jbi_ue_err_d1		(scbuf0_jbi_ue_err_d1),	 // Templated
      .sctag_jbi_iq_dequeue_d1		(sctag0_jbi_iq_dequeue_d1), // Templated
      .sctag_jbi_wib_dequeue_d1		(sctag0_jbi_wib_dequeue_d1), // Templated
      .sctag_jbi_por_req_d1		(sctag0_jbi_por_req_d1), // Templated
      .so				(rsc02_rptrs_so),	 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag0_req_d1_buf1[31:0]), // Templated
      .scbuf_jbi_data			(scbuf0_jbi_data_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf0_ecc_d1_buf1[6:0]), // Templated
      .jbi_sctag_req_vld		(jbi_sctag0_req_vld_d1_buf1), // Templated
      .scbuf_jbi_ctag_vld		(scbuf0_jbi_ctag_vld_buf1), // Templated
      .scbuf_jbi_ue_err			(scbuf0_jbi_ue_err_buf1), // Templated
      .sctag_jbi_iq_dequeue		(sctag0_jbi_iq_dequeue), // Templated
      .sctag_jbi_wib_dequeue		(sctag0_jbi_wib_dequeue), // Templated
      .sctag_jbi_por_req		(sctag0_jbi_por_req),	 // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rdbg01_rsc02_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ff_jbi_sc1_2 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rptrs_rsc12_so),
    .so                                 (rsc12_rsc01_so),

    .scbuf_jbi_\(.*\)_d1                (scbuf@_jbi_\1_d1[]),
    .scbuf_jbi_\(.*\)                   (scbuf@_jbi_\1_buf1[]),
    .sctag_jbi_\(.*\)                   (sctag@_jbi_\1[]),

    .jbi_sctag_\(.*\)_d1                (jbi_sctag@_\1_d2[]),
    .jbi_sctag_\(.*\)                   (jbi_sctag@_\1_d1_buf1[]),
    .jbi_scbuf_\(.*\)_d1                (jbi_scbuf@_\1_d2[]),
    .jbi_scbuf_\(.*\)                   (jbi_scbuf@_\1_d1_buf1[]),
    );*/
//
   ff_jbi_sc1_2 ff_jbi_sc1_2
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_d1			(jbi_sctag1_req_d2[31:0]), // Templated
      .scbuf_jbi_data_d1		(scbuf1_jbi_data_d1[31:0]), // Templated
      .jbi_scbuf_ecc_d1			(jbi_scbuf1_ecc_d2[6:0]), // Templated
      .jbi_sctag_req_vld_d1		(jbi_sctag1_req_vld_d2), // Templated
      .scbuf_jbi_ctag_vld_d1		(scbuf1_jbi_ctag_vld_d1), // Templated
      .scbuf_jbi_ue_err_d1		(scbuf1_jbi_ue_err_d1),	 // Templated
      .sctag_jbi_iq_dequeue_d1		(sctag1_jbi_iq_dequeue_d1), // Templated
      .sctag_jbi_wib_dequeue_d1		(sctag1_jbi_wib_dequeue_d1), // Templated
      .sctag_jbi_por_req_d1		(sctag1_jbi_por_req_d1), // Templated
      .so				(rsc12_rsc01_so),	 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag1_req_d1_buf1[31:0]), // Templated
      .scbuf_jbi_data			(scbuf1_jbi_data_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf1_ecc_d1_buf1[6:0]), // Templated
      .jbi_sctag_req_vld		(jbi_sctag1_req_vld_d1_buf1), // Templated
      .scbuf_jbi_ctag_vld		(scbuf1_jbi_ctag_vld_buf1), // Templated
      .scbuf_jbi_ue_err			(scbuf1_jbi_ue_err_buf1), // Templated
      .sctag_jbi_iq_dequeue		(sctag1_jbi_iq_dequeue), // Templated
      .sctag_jbi_wib_dequeue		(sctag1_jbi_wib_dequeue), // Templated
      .sctag_jbi_por_req		(sctag1_jbi_por_req),	 // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rptrs_rsc12_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ff_jbi_sc2_2 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (pddr2_rsc22_so),
    .so                                 (rsc22_rdbg23_so),

    .scbuf_jbi_\(.*\)_d1                (scbuf@_jbi_\1_d1[]),
    .scbuf_jbi_\(.*\)                   (scbuf@_jbi_\1_buf1[]),
    .sctag_jbi_\(.*\)                   (sctag@_jbi_\1[]),

    .jbi_sctag_\(.*\)_d1                (jbi_sctag@_\1_d2[]),
    .jbi_sctag_\(.*\)                   (jbi_sctag@_\1_d1_buf1[]),
    .jbi_scbuf_\(.*\)_d1                (jbi_scbuf@_\1_d2[]),
    .jbi_scbuf_\(.*\)                   (jbi_scbuf@_\1_d1_buf1[]),
    );*/
//
   ff_jbi_sc2_2 ff_jbi_sc2_2
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_d1			(jbi_sctag2_req_d2[31:0]), // Templated
      .scbuf_jbi_data_d1		(scbuf2_jbi_data_d1[31:0]), // Templated
      .jbi_scbuf_ecc_d1			(jbi_scbuf2_ecc_d2[6:0]), // Templated
      .jbi_sctag_req_vld_d1		(jbi_sctag2_req_vld_d2), // Templated
      .scbuf_jbi_ctag_vld_d1		(scbuf2_jbi_ctag_vld_d1), // Templated
      .scbuf_jbi_ue_err_d1		(scbuf2_jbi_ue_err_d1),	 // Templated
      .sctag_jbi_iq_dequeue_d1		(sctag2_jbi_iq_dequeue_d1), // Templated
      .sctag_jbi_wib_dequeue_d1		(sctag2_jbi_wib_dequeue_d1), // Templated
      .sctag_jbi_por_req_d1		(sctag2_jbi_por_req_d1), // Templated
      .so				(rsc22_rdbg23_so),	 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag2_req_d1_buf1[31:0]), // Templated
      .scbuf_jbi_data			(scbuf2_jbi_data_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf2_ecc_d1_buf1[6:0]), // Templated
      .jbi_sctag_req_vld		(jbi_sctag2_req_vld_d1_buf1), // Templated
      .scbuf_jbi_ctag_vld		(scbuf2_jbi_ctag_vld_buf1), // Templated
      .scbuf_jbi_ue_err			(scbuf2_jbi_ue_err_buf1), // Templated
      .sctag_jbi_iq_dequeue		(sctag2_jbi_iq_dequeue), // Templated
      .sctag_jbi_wib_dequeue		(sctag2_jbi_wib_dequeue), // Templated
      .sctag_jbi_por_req		(sctag2_jbi_por_req),	 // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(pddr2_rsc22_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* ff_jbi_sc3_2 AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rsc21_rsc32_so),
    .so                                 (rsc32_efc_so),

    .scbuf_jbi_\(.*\)_d1                (scbuf@_jbi_\1_d1[]),
    .scbuf_jbi_\(.*\)                   (scbuf@_jbi_\1_buf1[]),
    .sctag_jbi_\(.*\)                   (sctag@_jbi_\1[]),

    .jbi_sctag_\(.*\)_d1                (jbi_sctag@_\1_d2[]),
    .jbi_sctag_\(.*\)                   (jbi_sctag@_\1_d1_buf1[]),
    .jbi_scbuf_\(.*\)_d1                (jbi_scbuf@_\1_d2[]),
    .jbi_scbuf_\(.*\)                   (jbi_scbuf@_\1_d1_buf1[]),
    );*/
//
   ff_jbi_sc3_2 ff_jbi_sc3_2
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_d1			(jbi_sctag3_req_d2[31:0]), // Templated
      .scbuf_jbi_data_d1		(scbuf3_jbi_data_d1[31:0]), // Templated
      .jbi_scbuf_ecc_d1			(jbi_scbuf3_ecc_d2[6:0]), // Templated
      .jbi_sctag_req_vld_d1		(jbi_sctag3_req_vld_d2), // Templated
      .scbuf_jbi_ctag_vld_d1		(scbuf3_jbi_ctag_vld_d1), // Templated
      .scbuf_jbi_ue_err_d1		(scbuf3_jbi_ue_err_d1),	 // Templated
      .sctag_jbi_iq_dequeue_d1		(sctag3_jbi_iq_dequeue_d1), // Templated
      .sctag_jbi_wib_dequeue_d1		(sctag3_jbi_wib_dequeue_d1), // Templated
      .sctag_jbi_por_req_d1		(sctag3_jbi_por_req_d1), // Templated
      .so				(rsc32_efc_so),		 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag3_req_d1_buf1[31:0]), // Templated
      .scbuf_jbi_data			(scbuf3_jbi_data_buf1[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf3_ecc_d1_buf1[6:0]), // Templated
      .jbi_sctag_req_vld		(jbi_sctag3_req_vld_d1_buf1), // Templated
      .scbuf_jbi_ctag_vld		(scbuf3_jbi_ctag_vld_buf1), // Templated
      .scbuf_jbi_ue_err			(scbuf3_jbi_ue_err_buf1), // Templated
      .sctag_jbi_iq_dequeue		(sctag3_jbi_iq_dequeue), // Templated
      .sctag_jbi_wib_dequeue		(sctag3_jbi_wib_dequeue), // Templated
      .sctag_jbi_por_req		(sctag3_jbi_por_req),	 // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rsc21_rsc32_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* rep_jbi_sc0_2 AUTO_TEMPLATE (
    .jbi_scbuf_\(.*\)_buf              	(jbi_scbuf@_\1_d2_buf1[]),
    .jbi_scbuf_\(.*\)                  	(jbi_scbuf@_\1_d2[]),
    .scbuf_jbi_\(.*\)_buf              	(scbuf@_jbi_\1_buf1[]),
    .scbuf_jbi_\(.*\)                  	(scbuf@_jbi_\1[]),

    .jbi_sctag_req_buf                 	(jbi_sctag@_req_d2_buf1[]),
    .jbi_sctag_req                     	(jbi_sctag@_req_d2[]),
    .jbi_sctag_req_vld_buf             	(),
    .jbi_sctag_req_vld                 	(1'b0),
    .sctag_jbi_\(.*\)_buf              	(),
    .sctag_jbi_\(.*\)                  	(1'b0),
    );*/
//
   rep_jbi_sc0_2 rep_jbi_sc0_2
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_buf		(jbi_sctag0_req_d2_buf1[31:0]), // Templated
      .scbuf_jbi_data_buf		(scbuf0_jbi_data_buf1[31:0]), // Templated
      .jbi_scbuf_ecc_buf		(jbi_scbuf0_ecc_d2_buf1[6:0]), // Templated
      .jbi_sctag_req_vld_buf		(),			 // Templated
      .scbuf_jbi_ctag_vld_buf		(scbuf0_jbi_ctag_vld_buf1), // Templated
      .scbuf_jbi_ue_err_buf		(scbuf0_jbi_ue_err_buf1), // Templated
      .sctag_jbi_iq_dequeue_buf		(),			 // Templated
      .sctag_jbi_wib_dequeue_buf	(),			 // Templated
      .sctag_jbi_por_req_buf		(),			 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag0_req_d2[31:0]), // Templated
      .scbuf_jbi_data			(scbuf0_jbi_data[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf0_ecc_d2[6:0]), // Templated
      .jbi_sctag_req_vld		(1'b0),			 // Templated
      .scbuf_jbi_ctag_vld		(scbuf0_jbi_ctag_vld),	 // Templated
      .scbuf_jbi_ue_err			(scbuf0_jbi_ue_err),	 // Templated
      .sctag_jbi_iq_dequeue		(1'b0),			 // Templated
      .sctag_jbi_wib_dequeue		(1'b0),			 // Templated
      .sctag_jbi_por_req		(1'b0));			 // Templated
//


/* rep_jbi_sc1_2 AUTO_TEMPLATE (
    .jbi_scbuf_\(.*\)_buf              	(jbi_scbuf@_\1_d2_buf1[]),
    .jbi_scbuf_\(.*\)                  	(jbi_scbuf@_\1_d2[]),
    .scbuf_jbi_\(.*\)_buf              	(scbuf@_jbi_\1_buf1[]),
    .scbuf_jbi_\(.*\)                  	(scbuf@_jbi_\1[]),

    .jbi_sctag_req_buf                 	(jbi_sctag@_req_d2_buf1[]),
    .jbi_sctag_req                     	(jbi_sctag@_req_d2[]),
    .jbi_sctag_req_vld_buf             	(),
    .jbi_sctag_req_vld                 	(1'b0),
    .sctag_jbi_\(.*\)_buf              	(),
    .sctag_jbi_\(.*\)                  	(1'b0),
    );*/
//
   rep_jbi_sc1_2 rep_jbi_sc1_2
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_buf		(jbi_sctag1_req_d2_buf1[31:0]), // Templated
      .scbuf_jbi_data_buf		(scbuf1_jbi_data_buf1[31:0]), // Templated
      .jbi_scbuf_ecc_buf		(jbi_scbuf1_ecc_d2_buf1[6:0]), // Templated
      .jbi_sctag_req_vld_buf		(),			 // Templated
      .scbuf_jbi_ctag_vld_buf		(scbuf1_jbi_ctag_vld_buf1), // Templated
      .scbuf_jbi_ue_err_buf		(scbuf1_jbi_ue_err_buf1), // Templated
      .sctag_jbi_iq_dequeue_buf		(),			 // Templated
      .sctag_jbi_wib_dequeue_buf	(),			 // Templated
      .sctag_jbi_por_req_buf		(),			 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag1_req_d2[31:0]), // Templated
      .scbuf_jbi_data			(scbuf1_jbi_data[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf1_ecc_d2[6:0]), // Templated
      .jbi_sctag_req_vld		(1'b0),			 // Templated
      .scbuf_jbi_ctag_vld		(scbuf1_jbi_ctag_vld),	 // Templated
      .scbuf_jbi_ue_err			(scbuf1_jbi_ue_err),	 // Templated
      .sctag_jbi_iq_dequeue		(1'b0),			 // Templated
      .sctag_jbi_wib_dequeue		(1'b0),			 // Templated
      .sctag_jbi_por_req		(1'b0));			 // Templated
//


/* rep_jbi_sc2_2 AUTO_TEMPLATE (
    .jbi_scbuf_\(.*\)_buf              	(jbi_scbuf@_\1_d2_buf1[]),
    .jbi_scbuf_\(.*\)                  	(jbi_scbuf@_\1_d2[]),
    .scbuf_jbi_\(.*\)_buf              	(scbuf@_jbi_\1_buf1[]),
    .scbuf_jbi_\(.*\)                  	(scbuf@_jbi_\1[]),

    .jbi_sctag_req_buf                 	(jbi_sctag@_req_d2_buf1[]),
    .jbi_sctag_req                     	(jbi_sctag@_req_d2[]),
    .jbi_sctag_req_vld_buf             	(),
    .jbi_sctag_req_vld                 	(1'b0),
    .sctag_jbi_\(.*\)_buf              	(),
    .sctag_jbi_\(.*\)                  	(1'b0),
    );*/
//
   rep_jbi_sc2_2 rep_jbi_sc2_2
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_buf		(jbi_sctag2_req_d2_buf1[31:0]), // Templated
      .scbuf_jbi_data_buf		(scbuf2_jbi_data_buf1[31:0]), // Templated
      .jbi_scbuf_ecc_buf		(jbi_scbuf2_ecc_d2_buf1[6:0]), // Templated
      .jbi_sctag_req_vld_buf		(),			 // Templated
      .scbuf_jbi_ctag_vld_buf		(scbuf2_jbi_ctag_vld_buf1), // Templated
      .scbuf_jbi_ue_err_buf		(scbuf2_jbi_ue_err_buf1), // Templated
      .sctag_jbi_iq_dequeue_buf		(),			 // Templated
      .sctag_jbi_wib_dequeue_buf	(),			 // Templated
      .sctag_jbi_por_req_buf		(),			 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag2_req_d2[31:0]), // Templated
      .scbuf_jbi_data			(scbuf2_jbi_data[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf2_ecc_d2[6:0]), // Templated
      .jbi_sctag_req_vld		(1'b0),			 // Templated
      .scbuf_jbi_ctag_vld		(scbuf2_jbi_ctag_vld),	 // Templated
      .scbuf_jbi_ue_err			(scbuf2_jbi_ue_err),	 // Templated
      .sctag_jbi_iq_dequeue		(1'b0),			 // Templated
      .sctag_jbi_wib_dequeue		(1'b0),			 // Templated
      .sctag_jbi_por_req		(1'b0));			 // Templated
//


/* rep_jbi_sc3_2 AUTO_TEMPLATE (
    .jbi_scbuf_\(.*\)_buf              	(jbi_scbuf@_\1_d2_buf1[]),
    .jbi_scbuf_\(.*\)                  	(jbi_scbuf@_\1_d2[]),
    .scbuf_jbi_\(.*\)_buf              	(scbuf@_jbi_\1_buf1[]),
    .scbuf_jbi_\(.*\)                  	(scbuf@_jbi_\1[]),

    .jbi_sctag_req_buf                 	(jbi_sctag@_req_d2_buf1[]),
    .jbi_sctag_req                     	(jbi_sctag@_req_d2[]),
    .jbi_sctag_req_vld_buf             	(),
    .jbi_sctag_req_vld                 	(1'b0),
    .sctag_jbi_\(.*\)_buf              	(),
    .sctag_jbi_\(.*\)                  	(1'b0),
    );*/
//
   rep_jbi_sc3_2 rep_jbi_sc3_2
     (/*AUTOINST*/
      // Outputs
      .jbi_sctag_req_buf		(jbi_sctag3_req_d2_buf1[31:0]), // Templated
      .scbuf_jbi_data_buf		(scbuf3_jbi_data_buf1[31:0]), // Templated
      .jbi_scbuf_ecc_buf		(jbi_scbuf3_ecc_d2_buf1[6:0]), // Templated
      .jbi_sctag_req_vld_buf		(),			 // Templated
      .scbuf_jbi_ctag_vld_buf		(scbuf3_jbi_ctag_vld_buf1), // Templated
      .scbuf_jbi_ue_err_buf		(scbuf3_jbi_ue_err_buf1), // Templated
      .sctag_jbi_iq_dequeue_buf		(),			 // Templated
      .sctag_jbi_wib_dequeue_buf	(),			 // Templated
      .sctag_jbi_por_req_buf		(),			 // Templated
      // Inputs
      .jbi_sctag_req			(jbi_sctag3_req_d2[31:0]), // Templated
      .scbuf_jbi_data			(scbuf3_jbi_data[31:0]), // Templated
      .jbi_scbuf_ecc			(jbi_scbuf3_ecc_d2[6:0]), // Templated
      .jbi_sctag_req_vld		(1'b0),			 // Templated
      .scbuf_jbi_ctag_vld		(scbuf3_jbi_ctag_vld),	 // Templated
      .scbuf_jbi_ue_err			(scbuf3_jbi_ue_err),	 // Templated
      .sctag_jbi_iq_dequeue		(1'b0),			 // Templated
      .sctag_jbi_wib_dequeue		(1'b0),			 // Templated
      .sctag_jbi_por_req		(1'b0));			 // Templated
//


/* sc_0_1_dbg_rptr AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rdbg23_rdbg01_so),
    .so                                 (rdbg01_rsc02_so),
    .dbgbus_b\([01]\)                   (sctag@"(+ @ \1)"_dbgbus_out[]),
    .enable_01                          (dbg_en_@@"(+ @ 1)"),
    .l2_dbgbus_out                      (l2_dbgbus_@@"(+ @ 1)"[]),
    ); */
//
   sc_0_1_dbg_rptr sc_0_1_dbg_rptr
     (/*AUTOINST*/
      // Outputs
      .l2_dbgbus_out			(l2_dbgbus_01[39:0]),	 // Templated
      .enable_01			(dbg_en_01),		 // Templated
      .so				(rdbg01_rsc02_so),	 // Templated
      // Inputs
      .dbgbus_b0			(sctag0_dbgbus_out[40:0]), // Templated
      .dbgbus_b1			(sctag1_dbgbus_out[40:0]), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rdbg23_rdbg01_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* sc_2_3_dbg_rptr AUTO_TEMPLATE (
    .rclk                               (ccx_rclk),
    .se                                 (global_shift_enable),
    .si                                 (rsc22_rdbg23_so),
    .so                                 (rdbg23_rdbg01_so),
    .dbgbus_b\([01]\)                   (sctag@"(+ @ \1)"_dbgbus_out[]),
    .enable_01                          (dbg_en_@@"(+ @ 1)"),
    .l2_dbgbus_out                      (l2_dbgbus_@@"(+ @ 1)"[]),
    ); */
//
   sc_2_3_dbg_rptr sc_2_3_dbg_rptr
     (/*AUTOINST*/
      // Outputs
      .l2_dbgbus_out			(l2_dbgbus_23[39:0]),	 // Templated
      .enable_01			(dbg_en_23),		 // Templated
      .so				(rdbg23_rdbg01_so),	 // Templated
      // Inputs
      .dbgbus_b0			(sctag2_dbgbus_out[40:0]), // Templated
      .dbgbus_b1			(sctag3_dbgbus_out[40:0]), // Templated
      .rclk				(ccx_rclk),		 // Templated
      .si				(rsc22_rdbg23_so),	 // Templated
      .se				(global_shift_enable));	 // Templated
//


/* spc_pcx_buf AUTO_TEMPLATE (
    .spc_pcx_data_pa			(spc@_pcx_data_pa_buf[]),
    .spc_pcx_atom_pq			(spc@_pcx_atom_pq_buf),
    .spc_pcx_req_pq			(spc@_pcx_req_pq_buf[]),
    .pcx_spc_grant_px_buf		(pcx_spc@_grant_px_buf1[]),
    .spc_pcx_data_pa_buf		(spc@_pcx_data_pa[]),
    .spc_pcx_atom_pq_buf		(spc@_pcx_atom_pq),
    .spc_pcx_req_pq_buf			(spc@_pcx_req_pq[]),
    .pcx_spc_grant_px			(pcx_spc@_grant_px_buf[]),
    ); */
//
   spc_pcx_buf buf_pcx_0
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_data_pa			(spc0_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq			(spc0_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_req_pq			(spc0_pcx_req_pq_buf[4:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc0_grant_px_buf1[4:0]), // Templated
      // Inputs
      .spc_pcx_data_pa_buf		(spc0_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc0_pcx_atom_pq),	 // Templated
      .spc_pcx_req_pq_buf		(spc0_pcx_req_pq[4:0]),	 // Templated
      .pcx_spc_grant_px			(pcx_spc0_grant_px_buf[4:0])); // Templated
//
   spc_pcx_buf buf_pcx_1
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_data_pa			(spc1_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq			(spc1_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_req_pq			(spc1_pcx_req_pq_buf[4:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc1_grant_px_buf1[4:0]), // Templated
      // Inputs
      .spc_pcx_data_pa_buf		(spc1_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc1_pcx_atom_pq),	 // Templated
      .spc_pcx_req_pq_buf		(spc1_pcx_req_pq[4:0]),	 // Templated
      .pcx_spc_grant_px			(pcx_spc1_grant_px_buf[4:0])); // Templated
//
   spc_pcx_buf buf_pcx_2
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_data_pa			(spc2_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq			(spc2_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_req_pq			(spc2_pcx_req_pq_buf[4:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc2_grant_px_buf1[4:0]), // Templated
      // Inputs
      .spc_pcx_data_pa_buf		(spc2_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc2_pcx_atom_pq),	 // Templated
      .spc_pcx_req_pq_buf		(spc2_pcx_req_pq[4:0]),	 // Templated
      .pcx_spc_grant_px			(pcx_spc2_grant_px_buf[4:0])); // Templated
//
   spc_pcx_buf buf_pcx_3
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_data_pa			(spc3_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq			(spc3_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_req_pq			(spc3_pcx_req_pq_buf[4:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc3_grant_px_buf1[4:0]), // Templated
      // Inputs
      .spc_pcx_data_pa_buf		(spc3_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc3_pcx_atom_pq),	 // Templated
      .spc_pcx_req_pq_buf		(spc3_pcx_req_pq[4:0]),	 // Templated
      .pcx_spc_grant_px			(pcx_spc3_grant_px_buf[4:0])); // Templated
//
   spc_pcx_buf buf_pcx_4
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_data_pa			(spc4_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq			(spc4_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_req_pq			(spc4_pcx_req_pq_buf[4:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc4_grant_px_buf1[4:0]), // Templated
      // Inputs
      .spc_pcx_data_pa_buf		(spc4_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc4_pcx_atom_pq),	 // Templated
      .spc_pcx_req_pq_buf		(spc4_pcx_req_pq[4:0]),	 // Templated
      .pcx_spc_grant_px			(pcx_spc4_grant_px_buf[4:0])); // Templated
//
   spc_pcx_buf buf_pcx_5
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_data_pa			(spc5_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq			(spc5_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_req_pq			(spc5_pcx_req_pq_buf[4:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc5_grant_px_buf1[4:0]), // Templated
      // Inputs
      .spc_pcx_data_pa_buf		(spc5_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc5_pcx_atom_pq),	 // Templated
      .spc_pcx_req_pq_buf		(spc5_pcx_req_pq[4:0]),	 // Templated
      .pcx_spc_grant_px			(pcx_spc5_grant_px_buf[4:0])); // Templated
//
   spc_pcx_buf buf_pcx_6
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_data_pa			(spc6_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq			(spc6_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_req_pq			(spc6_pcx_req_pq_buf[4:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc6_grant_px_buf1[4:0]), // Templated
      // Inputs
      .spc_pcx_data_pa_buf		(spc6_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc6_pcx_atom_pq),	 // Templated
      .spc_pcx_req_pq_buf		(spc6_pcx_req_pq[4:0]),	 // Templated
      .pcx_spc_grant_px			(pcx_spc6_grant_px_buf[4:0])); // Templated
//
   spc_pcx_buf buf_pcx_7
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_data_pa			(spc7_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq			(spc7_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_req_pq			(spc7_pcx_req_pq_buf[4:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc7_grant_px_buf1[4:0]), // Templated
      // Inputs
      .spc_pcx_data_pa_buf		(spc7_pcx_data_pa[`PCX_WIDTH-1:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc7_pcx_atom_pq),	 // Templated
      .spc_pcx_req_pq_buf		(spc7_pcx_req_pq[4:0]),	 // Templated
      .pcx_spc_grant_px			(pcx_spc7_grant_px_buf[4:0])); // Templated
//


/* ccx_spc_rpt AUTO_TEMPLATE (
    // Outputs
    .spc_pcx_req_pq_buf			(spc@_pcx_req_pq_buf1[4:0]),
    .spc_pcx_atom_pq_buf		(spc@_pcx_atom_pq_buf1),
    .spc_pcx_data_pa_buf		(spc@_pcx_data_pa_buf1[`PCX_WIDTH-1:0]),
    .pcx_spc_grant_px_buf		(pcx_spc@_grant_px_buf[4:0]),
    .cpx_spc_data_cx2_buf		(cpx_spc@_data_cx2_buf1[`CPX_WIDTH-1:0]),
    .cpx_spc_data_rdy_cx2_buf		(cpx_spc@_data_rdy_cx2_buf1),
    // Inputs
    .spc_pcx_req_pq			(spc@_pcx_req_pq_buf[4:0]),
    .spc_pcx_atom_pq			(spc@_pcx_atom_pq_buf),
    .spc_pcx_data_pa			(spc@_pcx_data_pa_buf[`PCX_WIDTH-1:0]),
    .pcx_spc_grant_px			(pcx_spc@_grant_px[4:0]),
    .cpx_spc_data_cx2			(cpx_spc@_data_cx2[`CPX_WIDTH-1:0]),
    .cpx_spc_data_rdy_cx2		(cpx_spc@_data_rdy_cx2),
    ); */
//
   ccx_spc_rpt ccx_spc_rpt0
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq_buf		(spc0_pcx_req_pq_buf1[4:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc0_pcx_atom_pq_buf1), // Templated
      .spc_pcx_data_pa_buf		(spc0_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc0_grant_px_buf[4:0]), // Templated
      .cpx_spc_data_cx2_buf		(cpx_spc0_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2_buf		(cpx_spc0_data_rdy_cx2_buf1), // Templated
      // Inputs
      .spc_pcx_req_pq			(spc0_pcx_req_pq_buf[4:0]), // Templated
      .spc_pcx_atom_pq			(spc0_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_data_pa			(spc0_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px			(pcx_spc0_grant_px[4:0]), // Templated
      .cpx_spc_data_cx2			(cpx_spc0_data_cx2[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc0_data_rdy_cx2)); // Templated
//
   ccx_spc_rpt ccx_spc_rpt1
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq_buf		(spc1_pcx_req_pq_buf1[4:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc1_pcx_atom_pq_buf1), // Templated
      .spc_pcx_data_pa_buf		(spc1_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc1_grant_px_buf[4:0]), // Templated
      .cpx_spc_data_cx2_buf		(cpx_spc1_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2_buf		(cpx_spc1_data_rdy_cx2_buf1), // Templated
      // Inputs
      .spc_pcx_req_pq			(spc1_pcx_req_pq_buf[4:0]), // Templated
      .spc_pcx_atom_pq			(spc1_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_data_pa			(spc1_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px			(pcx_spc1_grant_px[4:0]), // Templated
      .cpx_spc_data_cx2			(cpx_spc1_data_cx2[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc1_data_rdy_cx2)); // Templated
//
   ccx_spc_rpt ccx_spc_rpt2
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq_buf		(spc2_pcx_req_pq_buf1[4:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc2_pcx_atom_pq_buf1), // Templated
      .spc_pcx_data_pa_buf		(spc2_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc2_grant_px_buf[4:0]), // Templated
      .cpx_spc_data_cx2_buf		(cpx_spc2_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2_buf		(cpx_spc2_data_rdy_cx2_buf1), // Templated
      // Inputs
      .spc_pcx_req_pq			(spc2_pcx_req_pq_buf[4:0]), // Templated
      .spc_pcx_atom_pq			(spc2_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_data_pa			(spc2_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px			(pcx_spc2_grant_px[4:0]), // Templated
      .cpx_spc_data_cx2			(cpx_spc2_data_cx2[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc2_data_rdy_cx2)); // Templated
//
   ccx_spc_rpt ccx_spc_rpt3
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq_buf		(spc3_pcx_req_pq_buf1[4:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc3_pcx_atom_pq_buf1), // Templated
      .spc_pcx_data_pa_buf		(spc3_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc3_grant_px_buf[4:0]), // Templated
      .cpx_spc_data_cx2_buf		(cpx_spc3_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2_buf		(cpx_spc3_data_rdy_cx2_buf1), // Templated
      // Inputs
      .spc_pcx_req_pq			(spc3_pcx_req_pq_buf[4:0]), // Templated
      .spc_pcx_atom_pq			(spc3_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_data_pa			(spc3_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px			(pcx_spc3_grant_px[4:0]), // Templated
      .cpx_spc_data_cx2			(cpx_spc3_data_cx2[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc3_data_rdy_cx2)); // Templated
//
   ccx_spc_rpt ccx_spc_rpt4
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq_buf		(spc4_pcx_req_pq_buf1[4:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc4_pcx_atom_pq_buf1), // Templated
      .spc_pcx_data_pa_buf		(spc4_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc4_grant_px_buf[4:0]), // Templated
      .cpx_spc_data_cx2_buf		(cpx_spc4_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2_buf		(cpx_spc4_data_rdy_cx2_buf1), // Templated
      // Inputs
      .spc_pcx_req_pq			(spc4_pcx_req_pq_buf[4:0]), // Templated
      .spc_pcx_atom_pq			(spc4_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_data_pa			(spc4_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px			(pcx_spc4_grant_px[4:0]), // Templated
      .cpx_spc_data_cx2			(cpx_spc4_data_cx2[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc4_data_rdy_cx2)); // Templated
//
   ccx_spc_rpt ccx_spc_rpt5
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq_buf		(spc5_pcx_req_pq_buf1[4:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc5_pcx_atom_pq_buf1), // Templated
      .spc_pcx_data_pa_buf		(spc5_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc5_grant_px_buf[4:0]), // Templated
      .cpx_spc_data_cx2_buf		(cpx_spc5_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2_buf		(cpx_spc5_data_rdy_cx2_buf1), // Templated
      // Inputs
      .spc_pcx_req_pq			(spc5_pcx_req_pq_buf[4:0]), // Templated
      .spc_pcx_atom_pq			(spc5_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_data_pa			(spc5_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px			(pcx_spc5_grant_px[4:0]), // Templated
      .cpx_spc_data_cx2			(cpx_spc5_data_cx2[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc5_data_rdy_cx2)); // Templated
//
   ccx_spc_rpt ccx_spc_rpt6
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq_buf		(spc6_pcx_req_pq_buf1[4:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc6_pcx_atom_pq_buf1), // Templated
      .spc_pcx_data_pa_buf		(spc6_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc6_grant_px_buf[4:0]), // Templated
      .cpx_spc_data_cx2_buf		(cpx_spc6_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2_buf		(cpx_spc6_data_rdy_cx2_buf1), // Templated
      // Inputs
      .spc_pcx_req_pq			(spc6_pcx_req_pq_buf[4:0]), // Templated
      .spc_pcx_atom_pq			(spc6_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_data_pa			(spc6_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px			(pcx_spc6_grant_px[4:0]), // Templated
      .cpx_spc_data_cx2			(cpx_spc6_data_cx2[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc6_data_rdy_cx2)); // Templated
//
   ccx_spc_rpt ccx_spc_rpt7
     (/*AUTOINST*/
      // Outputs
      .spc_pcx_req_pq_buf		(spc7_pcx_req_pq_buf1[4:0]), // Templated
      .spc_pcx_atom_pq_buf		(spc7_pcx_atom_pq_buf1), // Templated
      .spc_pcx_data_pa_buf		(spc7_pcx_data_pa_buf1[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px_buf		(pcx_spc7_grant_px_buf[4:0]), // Templated
      .cpx_spc_data_cx2_buf		(cpx_spc7_data_cx2_buf1[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2_buf		(cpx_spc7_data_rdy_cx2_buf1), // Templated
      // Inputs
      .spc_pcx_req_pq			(spc7_pcx_req_pq_buf[4:0]), // Templated
      .spc_pcx_atom_pq			(spc7_pcx_atom_pq_buf),	 // Templated
      .spc_pcx_data_pa			(spc7_pcx_data_pa_buf[`PCX_WIDTH-1:0]), // Templated
      .pcx_spc_grant_px			(pcx_spc7_grant_px[4:0]), // Templated
      .cpx_spc_data_cx2			(cpx_spc7_data_cx2[`CPX_WIDTH-1:0]), // Templated
      .cpx_spc_data_rdy_cx2		(cpx_spc7_data_rdy_cx2)); // Templated
//


   dram0_ddr0_rptr dram0_ddr0_rptr0 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram0_data_valid_buf0),
    .io_dram_ecc_in_buf			(io_dram0_ecc_in_buf0[31:0]),
    .io_dram_data_in_buf		(io_dram0_data_in_buf0[255:0]),
    .dram_io_cas_l_buf			(dram0_io_cas_l_buf0),
    .dram_io_channel_disabled_buf	(dram0_io_channel_disabled_buf0),
    .dram_io_cke_buf			(dram0_io_cke_buf0),
    .dram_io_clk_enable_buf		(dram0_io_clk_enable_buf0),
    .dram_io_drive_data_buf		(dram0_io_drive_data_buf0),
    .dram_io_drive_enable_buf		(dram0_io_drive_enable_buf0),
    .dram_io_pad_clk_inv_buf		(dram0_io_pad_clk_inv_buf0),
    .dram_io_pad_enable_buf		(dram0_io_pad_enable_buf0),
    .dram_io_ras_l_buf			(dram0_io_ras_l_buf0),
    .dram_io_write_en_l_buf		(dram0_io_write_en_l_buf0),
    .dram_io_addr_buf			(dram0_io_addr_buf0[14:0]),
    .dram_io_bank_buf			(dram0_io_bank_buf0[2:0]),
    .dram_io_cs_l_buf			(dram0_io_cs_l_buf0[3:0]),
    .dram_io_data_out_buf		(dram0_io_data_out_buf0[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram0_io_ptr_clk_inv_buf0[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram0_data_valid_buf1),
    .io_dram_ecc_in			(io_dram0_ecc_in_buf1[31:0]),
    .io_dram_data_in			(io_dram0_data_in_buf1[255:0]),
    .dram_io_cas_l			(dram0_io_cas_l),
    .dram_io_channel_disabled		(dram0_io_channel_disabled),
    .dram_io_cke			(dram0_io_cke),
    .dram_io_clk_enable			(dram0_io_clk_enable),
    .dram_io_drive_data			(dram0_io_drive_data),
    .dram_io_drive_enable		(dram0_io_drive_enable),
    .dram_io_pad_clk_inv		(dram0_io_pad_clk_inv),
    .dram_io_pad_enable			(dram0_io_pad_enable),
    .dram_io_ras_l			(dram0_io_ras_l),
    .dram_io_write_en_l			(dram0_io_write_en_l),
    .dram_io_addr			(dram0_io_addr[14:0]),
    .dram_io_bank			(dram0_io_bank[2:0]),
    .dram_io_cs_l			(dram0_io_cs_l[3:0]),
    .dram_io_data_out			(dram0_io_data_out[287:0]),
    .dram_io_ptr_clk_inv		(dram0_io_ptr_clk_inv[4:0]));
//


   dram_ddr_rptr dram0_ddr0_rptr1 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram0_data_valid_buf1),
    .io_dram_ecc_in_buf			(io_dram0_ecc_in_buf1[31:0]),
    .io_dram_data_in_buf		(io_dram0_data_in_buf1[255:0]),
    .dram_io_cas_l_buf			(dram0_io_cas_l_buf1),
    .dram_io_channel_disabled_buf	(dram0_io_channel_disabled_buf1),
    .dram_io_cke_buf			(dram0_io_cke_buf1),
    .dram_io_clk_enable_buf		(dram0_io_clk_enable_buf1),
    .dram_io_drive_data_buf		(dram0_io_drive_data_buf1),
    .dram_io_drive_enable_buf		(dram0_io_drive_enable_buf1),
    .dram_io_pad_clk_inv_buf		(dram0_io_pad_clk_inv_buf1),
    .dram_io_pad_enable_buf		(dram0_io_pad_enable_buf1),
    .dram_io_ras_l_buf			(dram0_io_ras_l_buf1),
    .dram_io_write_en_l_buf		(dram0_io_write_en_l_buf1),
    .dram_io_addr_buf			(dram0_io_addr_buf1[14:0]),
    .dram_io_bank_buf			(dram0_io_bank_buf1[2:0]),
    .dram_io_cs_l_buf			(dram0_io_cs_l_buf1[3:0]),
    .dram_io_data_out_buf		(dram0_io_data_out_buf1[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram0_io_ptr_clk_inv_buf1[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram0_data_valid_buf2),
    .io_dram_ecc_in			(io_dram0_ecc_in_buf2[31:0]),
    .io_dram_data_in			(io_dram0_data_in_buf2[255:0]),
    .dram_io_cas_l			(dram0_io_cas_l_buf0),
    .dram_io_channel_disabled		(dram0_io_channel_disabled_buf0),
    .dram_io_cke			(dram0_io_cke_buf0),
    .dram_io_clk_enable			(dram0_io_clk_enable_buf0),
    .dram_io_drive_data			(dram0_io_drive_data_buf0),
    .dram_io_drive_enable		(dram0_io_drive_enable_buf0),
    .dram_io_pad_clk_inv		(dram0_io_pad_clk_inv_buf0),
    .dram_io_pad_enable			(dram0_io_pad_enable_buf0),
    .dram_io_ras_l			(dram0_io_ras_l_buf0),
    .dram_io_write_en_l			(dram0_io_write_en_l_buf0),
    .dram_io_addr			(dram0_io_addr_buf0[14:0]),
    .dram_io_bank			(dram0_io_bank_buf0[2:0]),
    .dram_io_cs_l			(dram0_io_cs_l_buf0[3:0]),
    .dram_io_data_out			(dram0_io_data_out_buf0[287:0]),
    .dram_io_ptr_clk_inv		(dram0_io_ptr_clk_inv_buf0[4:0]));
//


   dram_ddr_pad_rptr dram0_ddr0_rptr2 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram0_data_valid_buf2),
    .io_dram_ecc_in_buf			(io_dram0_ecc_in_buf2[31:0]),
    .io_dram_data_in_buf		(io_dram0_data_in_buf2[255:0]),
    .dram_io_cas_l_buf			(dram0_io_cas_l_buf2),
    .dram_io_channel_disabled_buf	(dram0_io_channel_disabled_buf2),
    .dram_io_cke_buf			(dram0_io_cke_buf2),
    .dram_io_clk_enable_buf		(dram0_io_clk_enable_buf2),
    .dram_io_drive_data_buf		(dram0_io_drive_data_buf2),
    .dram_io_drive_enable_buf		(dram0_io_drive_enable_buf2),
    .dram_io_pad_clk_inv_buf		(dram0_io_pad_clk_inv_buf2),
    .dram_io_pad_enable_buf		(dram0_io_pad_enable_buf2),
    .dram_io_ras_l_buf			(dram0_io_ras_l_buf2),
    .dram_io_write_en_l_buf		(dram0_io_write_en_l_buf2),
    .dram_io_addr_buf			(dram0_io_addr_buf2[14:0]),
    .dram_io_bank_buf			(dram0_io_bank_buf2[2:0]),
    .dram_io_cs_l_buf			(dram0_io_cs_l_buf2[3:0]),
    .dram_io_data_out_buf		(dram0_io_data_out_buf2[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram0_io_ptr_clk_inv_buf2[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram0_data_valid),
    .io_dram_ecc_in			(io_dram0_ecc_in[31:0]),
    .io_dram_data_in			(io_dram0_data_in[255:0]),
    .dram_io_cas_l			(dram0_io_cas_l_buf1),
    .dram_io_channel_disabled		(dram0_io_channel_disabled_buf1),
    .dram_io_cke			(dram0_io_cke_buf1),
    .dram_io_clk_enable			(dram0_io_clk_enable_buf1),
    .dram_io_drive_data			(dram0_io_drive_data_buf1),
    .dram_io_drive_enable		(dram0_io_drive_enable_buf1),
    .dram_io_pad_clk_inv		(dram0_io_pad_clk_inv_buf1),
    .dram_io_pad_enable			(dram0_io_pad_enable_buf1),
    .dram_io_ras_l			(dram0_io_ras_l_buf1),
    .dram_io_write_en_l			(dram0_io_write_en_l_buf1),
    .dram_io_addr			(dram0_io_addr_buf1[14:0]),
    .dram_io_bank			(dram0_io_bank_buf1[2:0]),
    .dram_io_cs_l			(dram0_io_cs_l_buf1[3:0]),
    .dram_io_data_out			(dram0_io_data_out_buf1[287:0]),
    .dram_io_ptr_clk_inv		(dram0_io_ptr_clk_inv_buf1[4:0]));
//


   dram1_ddr1_rptr dram1_ddr1_rptr0 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram1_data_valid_buf0),
    .io_dram_ecc_in_buf			(io_dram1_ecc_in_buf0[31:0]),
    .io_dram_data_in_buf		(io_dram1_data_in_buf0[255:0]),
    .dram_io_cas_l_buf			(dram1_io_cas_l_buf0),
    .dram_io_channel_disabled_buf	(dram1_io_channel_disabled_buf0),
    .dram_io_cke_buf			(dram1_io_cke_buf0),
    .dram_io_clk_enable_buf		(dram1_io_clk_enable_buf0),
    .dram_io_drive_data_buf		(dram1_io_drive_data_buf0),
    .dram_io_drive_enable_buf		(dram1_io_drive_enable_buf0),
    .dram_io_pad_clk_inv_buf		(dram1_io_pad_clk_inv_buf0),
    .dram_io_pad_enable_buf		(dram1_io_pad_enable_buf0),
    .dram_io_ras_l_buf			(dram1_io_ras_l_buf0),
    .dram_io_write_en_l_buf		(dram1_io_write_en_l_buf0),
    .dram_io_addr_buf			(dram1_io_addr_buf0[14:0]),
    .dram_io_bank_buf			(dram1_io_bank_buf0[2:0]),
    .dram_io_cs_l_buf			(dram1_io_cs_l_buf0[3:0]),
    .dram_io_data_out_buf		(dram1_io_data_out_buf0[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram1_io_ptr_clk_inv_buf0[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram1_data_valid_buf1),
    .io_dram_ecc_in			(io_dram1_ecc_in_buf1[31:0]),
    .io_dram_data_in			(io_dram1_data_in_buf1[255:0]),
    .dram_io_cas_l			(dram1_io_cas_l),
    .dram_io_channel_disabled		(dram1_io_channel_disabled),
    .dram_io_cke			(dram1_io_cke),
    .dram_io_clk_enable			(dram1_io_clk_enable),
    .dram_io_drive_data			(dram1_io_drive_data),
    .dram_io_drive_enable		(dram1_io_drive_enable),
    .dram_io_pad_clk_inv		(dram1_io_pad_clk_inv),
    .dram_io_pad_enable			(dram1_io_pad_enable),
    .dram_io_ras_l			(dram1_io_ras_l),
    .dram_io_write_en_l			(dram1_io_write_en_l),
    .dram_io_addr			(dram1_io_addr[14:0]),
    .dram_io_bank			(dram1_io_bank[2:0]),
    .dram_io_cs_l			(dram1_io_cs_l[3:0]),
    .dram_io_data_out			(dram1_io_data_out[287:0]),
    .dram_io_ptr_clk_inv		(dram1_io_ptr_clk_inv[4:0]));
//


   dram_ddr_rptr_south dram1_ddr1_rptr1 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram1_data_valid_buf1),
    .io_dram_ecc_in_buf			(io_dram1_ecc_in_buf1[31:0]),
    .io_dram_data_in_buf		(io_dram1_data_in_buf1[255:0]),
    .dram_io_cas_l_buf			(dram1_io_cas_l_buf1),
    .dram_io_channel_disabled_buf	(dram1_io_channel_disabled_buf1),
    .dram_io_cke_buf			(dram1_io_cke_buf1),
    .dram_io_clk_enable_buf		(dram1_io_clk_enable_buf1),
    .dram_io_drive_data_buf		(dram1_io_drive_data_buf1),
    .dram_io_drive_enable_buf		(dram1_io_drive_enable_buf1),
    .dram_io_pad_clk_inv_buf		(dram1_io_pad_clk_inv_buf1),
    .dram_io_pad_enable_buf		(dram1_io_pad_enable_buf1),
    .dram_io_ras_l_buf			(dram1_io_ras_l_buf1),
    .dram_io_write_en_l_buf		(dram1_io_write_en_l_buf1),
    .dram_io_addr_buf			(dram1_io_addr_buf1[14:0]),
    .dram_io_bank_buf			(dram1_io_bank_buf1[2:0]),
    .dram_io_cs_l_buf			(dram1_io_cs_l_buf1[3:0]),
    .dram_io_data_out_buf		(dram1_io_data_out_buf1[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram1_io_ptr_clk_inv_buf1[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram1_data_valid_buf2),
    .io_dram_ecc_in			(io_dram1_ecc_in_buf2[31:0]),
    .io_dram_data_in			(io_dram1_data_in_buf2[255:0]),
    .dram_io_cas_l			(dram1_io_cas_l_buf0),
    .dram_io_channel_disabled		(dram1_io_channel_disabled_buf0),
    .dram_io_cke			(dram1_io_cke_buf0),
    .dram_io_clk_enable			(dram1_io_clk_enable_buf0),
    .dram_io_drive_data			(dram1_io_drive_data_buf0),
    .dram_io_drive_enable		(dram1_io_drive_enable_buf0),
    .dram_io_pad_clk_inv		(dram1_io_pad_clk_inv_buf0),
    .dram_io_pad_enable			(dram1_io_pad_enable_buf0),
    .dram_io_ras_l			(dram1_io_ras_l_buf0),
    .dram_io_write_en_l			(dram1_io_write_en_l_buf0),
    .dram_io_addr			(dram1_io_addr_buf0[14:0]),
    .dram_io_bank			(dram1_io_bank_buf0[2:0]),
    .dram_io_cs_l			(dram1_io_cs_l_buf0[3:0]),
    .dram_io_data_out			(dram1_io_data_out_buf0[287:0]),
    .dram_io_ptr_clk_inv		(dram1_io_ptr_clk_inv_buf0[4:0]));
//


   dram_ddr_pad_rptr_south dram1_ddr1_rptr2 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram1_data_valid_buf2),
    .io_dram_ecc_in_buf			(io_dram1_ecc_in_buf2[31:0]),
    .io_dram_data_in_buf		(io_dram1_data_in_buf2[255:0]),
    .dram_io_cas_l_buf			(dram1_io_cas_l_buf2),
    .dram_io_channel_disabled_buf	(dram1_io_channel_disabled_buf2),
    .dram_io_cke_buf			(dram1_io_cke_buf2),
    .dram_io_clk_enable_buf		(dram1_io_clk_enable_buf2),
    .dram_io_drive_data_buf		(dram1_io_drive_data_buf2),
    .dram_io_drive_enable_buf		(dram1_io_drive_enable_buf2),
    .dram_io_pad_clk_inv_buf		(dram1_io_pad_clk_inv_buf2),
    .dram_io_pad_enable_buf		(dram1_io_pad_enable_buf2),
    .dram_io_ras_l_buf			(dram1_io_ras_l_buf2),
    .dram_io_write_en_l_buf		(dram1_io_write_en_l_buf2),
    .dram_io_addr_buf			(dram1_io_addr_buf2[14:0]),
    .dram_io_bank_buf			(dram1_io_bank_buf2[2:0]),
    .dram_io_cs_l_buf			(dram1_io_cs_l_buf2[3:0]),
    .dram_io_data_out_buf		(dram1_io_data_out_buf2[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram1_io_ptr_clk_inv_buf2[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram1_data_valid),
    .io_dram_ecc_in			(io_dram1_ecc_in[31:0]),
    .io_dram_data_in			(io_dram1_data_in[255:0]),
    .dram_io_cas_l			(dram1_io_cas_l_buf1),
    .dram_io_channel_disabled		(dram1_io_channel_disabled_buf1),
    .dram_io_cke			(dram1_io_cke_buf1),
    .dram_io_clk_enable			(dram1_io_clk_enable_buf1),
    .dram_io_drive_data			(dram1_io_drive_data_buf1),
    .dram_io_drive_enable		(dram1_io_drive_enable_buf1),
    .dram_io_pad_clk_inv		(dram1_io_pad_clk_inv_buf1),
    .dram_io_pad_enable			(dram1_io_pad_enable_buf1),
    .dram_io_ras_l			(dram1_io_ras_l_buf1),
    .dram_io_write_en_l			(dram1_io_write_en_l_buf1),
    .dram_io_addr			(dram1_io_addr_buf1[14:0]),
    .dram_io_bank			(dram1_io_bank_buf1[2:0]),
    .dram_io_cs_l			(dram1_io_cs_l_buf1[3:0]),
    .dram_io_data_out			(dram1_io_data_out_buf1[287:0]),
    .dram_io_ptr_clk_inv		(dram1_io_ptr_clk_inv_buf1[4:0]));
//


   dram2_ddr2_rptr dram2_ddr2_rptr0 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram2_data_valid_buf0),
    .io_dram_ecc_in_buf			(io_dram2_ecc_in_buf0[31:0]),
    .io_dram_data_in_buf		(io_dram2_data_in_buf0[255:0]),
    .dram_io_cas_l_buf			(dram2_io_cas_l_buf0),
    .dram_io_channel_disabled_buf	(dram2_io_channel_disabled_buf0),
    .dram_io_cke_buf			(dram2_io_cke_buf0),
    .dram_io_clk_enable_buf		(dram2_io_clk_enable_buf0),
    .dram_io_drive_data_buf		(dram2_io_drive_data_buf0),
    .dram_io_drive_enable_buf		(dram2_io_drive_enable_buf0),
    .dram_io_pad_clk_inv_buf		(dram2_io_pad_clk_inv_buf0),
    .dram_io_pad_enable_buf		(dram2_io_pad_enable_buf0),
    .dram_io_ras_l_buf			(dram2_io_ras_l_buf0),
    .dram_io_write_en_l_buf		(dram2_io_write_en_l_buf0),
    .dram_io_addr_buf			(dram2_io_addr_buf0[14:0]),
    .dram_io_bank_buf			(dram2_io_bank_buf0[2:0]),
    .dram_io_cs_l_buf			(dram2_io_cs_l_buf0[3:0]),
    .dram_io_data_out_buf		(dram2_io_data_out_buf0[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram2_io_ptr_clk_inv_buf0[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram2_data_valid_buf1),
    .io_dram_ecc_in			(io_dram2_ecc_in_buf1[31:0]),
    .io_dram_data_in			(io_dram2_data_in_buf1[255:0]),
    .dram_io_cas_l			(dram2_io_cas_l),
    .dram_io_channel_disabled		(dram2_io_channel_disabled),
    .dram_io_cke			(dram2_io_cke),
    .dram_io_clk_enable			(dram2_io_clk_enable),
    .dram_io_drive_data			(dram2_io_drive_data),
    .dram_io_drive_enable		(dram2_io_drive_enable),
    .dram_io_pad_clk_inv		(dram2_io_pad_clk_inv),
    .dram_io_pad_enable			(dram2_io_pad_enable),
    .dram_io_ras_l			(dram2_io_ras_l),
    .dram_io_write_en_l			(dram2_io_write_en_l),
    .dram_io_addr			(dram2_io_addr[14:0]),
    .dram_io_bank			(dram2_io_bank[2:0]),
    .dram_io_cs_l			(dram2_io_cs_l[3:0]),
    .dram_io_data_out			(dram2_io_data_out[287:0]),
    .dram_io_ptr_clk_inv		(dram2_io_ptr_clk_inv[4:0]));
//


   dram_ddr_rptr dram2_ddr2_rptr1 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram2_data_valid_buf1),
    .io_dram_ecc_in_buf			(io_dram2_ecc_in_buf1[31:0]),
    .io_dram_data_in_buf		(io_dram2_data_in_buf1[255:0]),
    .dram_io_cas_l_buf			(dram2_io_cas_l_buf1),
    .dram_io_channel_disabled_buf	(dram2_io_channel_disabled_buf1),
    .dram_io_cke_buf			(dram2_io_cke_buf1),
    .dram_io_clk_enable_buf		(dram2_io_clk_enable_buf1),
    .dram_io_drive_data_buf		(dram2_io_drive_data_buf1),
    .dram_io_drive_enable_buf		(dram2_io_drive_enable_buf1),
    .dram_io_pad_clk_inv_buf		(dram2_io_pad_clk_inv_buf1),
    .dram_io_pad_enable_buf		(dram2_io_pad_enable_buf1),
    .dram_io_ras_l_buf			(dram2_io_ras_l_buf1),
    .dram_io_write_en_l_buf		(dram2_io_write_en_l_buf1),
    .dram_io_addr_buf			(dram2_io_addr_buf1[14:0]),
    .dram_io_bank_buf			(dram2_io_bank_buf1[2:0]),
    .dram_io_cs_l_buf			(dram2_io_cs_l_buf1[3:0]),
    .dram_io_data_out_buf		(dram2_io_data_out_buf1[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram2_io_ptr_clk_inv_buf1[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram2_data_valid_buf2),
    .io_dram_ecc_in			(io_dram2_ecc_in_buf2[31:0]),
    .io_dram_data_in			(io_dram2_data_in_buf2[255:0]),
    .dram_io_cas_l			(dram2_io_cas_l_buf0),
    .dram_io_channel_disabled		(dram2_io_channel_disabled_buf0),
    .dram_io_cke			(dram2_io_cke_buf0),
    .dram_io_clk_enable			(dram2_io_clk_enable_buf0),
    .dram_io_drive_data			(dram2_io_drive_data_buf0),
    .dram_io_drive_enable		(dram2_io_drive_enable_buf0),
    .dram_io_pad_clk_inv		(dram2_io_pad_clk_inv_buf0),
    .dram_io_pad_enable			(dram2_io_pad_enable_buf0),
    .dram_io_ras_l			(dram2_io_ras_l_buf0),
    .dram_io_write_en_l			(dram2_io_write_en_l_buf0),
    .dram_io_addr			(dram2_io_addr_buf0[14:0]),
    .dram_io_bank			(dram2_io_bank_buf0[2:0]),
    .dram_io_cs_l			(dram2_io_cs_l_buf0[3:0]),
    .dram_io_data_out			(dram2_io_data_out_buf0[287:0]),
    .dram_io_ptr_clk_inv		(dram2_io_ptr_clk_inv_buf0[4:0]));
//


   dram_ddr_pad_rptr dram2_ddr2_rptr2 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram2_data_valid_buf2),
    .io_dram_ecc_in_buf			(io_dram2_ecc_in_buf2[31:0]),
    .io_dram_data_in_buf		(io_dram2_data_in_buf2[255:0]),
    .dram_io_cas_l_buf			(dram2_io_cas_l_buf2),
    .dram_io_channel_disabled_buf	(dram2_io_channel_disabled_buf2),
    .dram_io_cke_buf			(dram2_io_cke_buf2),
    .dram_io_clk_enable_buf		(dram2_io_clk_enable_buf2),
    .dram_io_drive_data_buf		(dram2_io_drive_data_buf2),
    .dram_io_drive_enable_buf		(dram2_io_drive_enable_buf2),
    .dram_io_pad_clk_inv_buf		(dram2_io_pad_clk_inv_buf2),
    .dram_io_pad_enable_buf		(dram2_io_pad_enable_buf2),
    .dram_io_ras_l_buf			(dram2_io_ras_l_buf2),
    .dram_io_write_en_l_buf		(dram2_io_write_en_l_buf2),
    .dram_io_addr_buf			(dram2_io_addr_buf2[14:0]),
    .dram_io_bank_buf			(dram2_io_bank_buf2[2:0]),
    .dram_io_cs_l_buf			(dram2_io_cs_l_buf2[3:0]),
    .dram_io_data_out_buf		(dram2_io_data_out_buf2[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram2_io_ptr_clk_inv_buf2[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram2_data_valid),
    .io_dram_ecc_in			(io_dram2_ecc_in[31:0]),
    .io_dram_data_in			(io_dram2_data_in[255:0]),
    .dram_io_cas_l			(dram2_io_cas_l_buf1),
    .dram_io_channel_disabled		(dram2_io_channel_disabled_buf1),
    .dram_io_cke			(dram2_io_cke_buf1),
    .dram_io_clk_enable			(dram2_io_clk_enable_buf1),
    .dram_io_drive_data			(dram2_io_drive_data_buf1),
    .dram_io_drive_enable		(dram2_io_drive_enable_buf1),
    .dram_io_pad_clk_inv		(dram2_io_pad_clk_inv_buf1),
    .dram_io_pad_enable			(dram2_io_pad_enable_buf1),
    .dram_io_ras_l			(dram2_io_ras_l_buf1),
    .dram_io_write_en_l			(dram2_io_write_en_l_buf1),
    .dram_io_addr			(dram2_io_addr_buf1[14:0]),
    .dram_io_bank			(dram2_io_bank_buf1[2:0]),
    .dram_io_cs_l			(dram2_io_cs_l_buf1[3:0]),
    .dram_io_data_out			(dram2_io_data_out_buf1[287:0]),
    .dram_io_ptr_clk_inv		(dram2_io_ptr_clk_inv_buf1[4:0]));
//


   dram3_ddr3_rptr dram3_ddr3_rptr0 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram3_data_valid_buf0),
    .io_dram_ecc_in_buf			(io_dram3_ecc_in_buf0[31:0]),
    .io_dram_data_in_buf		(io_dram3_data_in_buf0[255:0]),
    .dram_io_cas_l_buf			(dram3_io_cas_l_buf0),
    .dram_io_channel_disabled_buf	(dram3_io_channel_disabled_buf0),
    .dram_io_cke_buf			(dram3_io_cke_buf0),
    .dram_io_clk_enable_buf		(dram3_io_clk_enable_buf0),
    .dram_io_drive_data_buf		(dram3_io_drive_data_buf0),
    .dram_io_drive_enable_buf		(dram3_io_drive_enable_buf0),
    .dram_io_pad_clk_inv_buf		(dram3_io_pad_clk_inv_buf0),
    .dram_io_pad_enable_buf		(dram3_io_pad_enable_buf0),
    .dram_io_ras_l_buf			(dram3_io_ras_l_buf0),
    .dram_io_write_en_l_buf		(dram3_io_write_en_l_buf0),
    .dram_io_addr_buf			(dram3_io_addr_buf0[14:0]),
    .dram_io_bank_buf			(dram3_io_bank_buf0[2:0]),
    .dram_io_cs_l_buf			(dram3_io_cs_l_buf0[3:0]),
    .dram_io_data_out_buf		(dram3_io_data_out_buf0[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram3_io_ptr_clk_inv_buf0[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram3_data_valid_buf1),
    .io_dram_ecc_in			(io_dram3_ecc_in_buf1[31:0]),
    .io_dram_data_in			(io_dram3_data_in_buf1[255:0]),
    .dram_io_cas_l			(dram3_io_cas_l),
    .dram_io_channel_disabled		(dram3_io_channel_disabled),
    .dram_io_cke			(dram3_io_cke),
    .dram_io_clk_enable			(dram3_io_clk_enable),
    .dram_io_drive_data			(dram3_io_drive_data),
    .dram_io_drive_enable		(dram3_io_drive_enable),
    .dram_io_pad_clk_inv		(dram3_io_pad_clk_inv),
    .dram_io_pad_enable			(dram3_io_pad_enable),
    .dram_io_ras_l			(dram3_io_ras_l),
    .dram_io_write_en_l			(dram3_io_write_en_l),
    .dram_io_addr			(dram3_io_addr[14:0]),
    .dram_io_bank			(dram3_io_bank[2:0]),
    .dram_io_cs_l			(dram3_io_cs_l[3:0]),
    .dram_io_data_out			(dram3_io_data_out[287:0]),
    .dram_io_ptr_clk_inv		(dram3_io_ptr_clk_inv[4:0]));
//


   dram_ddr_rptr_south dram3_ddr3_rptr1 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram3_data_valid_buf1),
    .io_dram_ecc_in_buf			(io_dram3_ecc_in_buf1[31:0]),
    .io_dram_data_in_buf		(io_dram3_data_in_buf1[255:0]),
    .dram_io_cas_l_buf			(dram3_io_cas_l_buf1),
    .dram_io_channel_disabled_buf	(dram3_io_channel_disabled_buf1),
    .dram_io_cke_buf			(dram3_io_cke_buf1),
    .dram_io_clk_enable_buf		(dram3_io_clk_enable_buf1),
    .dram_io_drive_data_buf		(dram3_io_drive_data_buf1),
    .dram_io_drive_enable_buf		(dram3_io_drive_enable_buf1),
    .dram_io_pad_clk_inv_buf		(dram3_io_pad_clk_inv_buf1),
    .dram_io_pad_enable_buf		(dram3_io_pad_enable_buf1),
    .dram_io_ras_l_buf			(dram3_io_ras_l_buf1),
    .dram_io_write_en_l_buf		(dram3_io_write_en_l_buf1),
    .dram_io_addr_buf			(dram3_io_addr_buf1[14:0]),
    .dram_io_bank_buf			(dram3_io_bank_buf1[2:0]),
    .dram_io_cs_l_buf			(dram3_io_cs_l_buf1[3:0]),
    .dram_io_data_out_buf		(dram3_io_data_out_buf1[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram3_io_ptr_clk_inv_buf1[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram3_data_valid_buf2),
    .io_dram_ecc_in			(io_dram3_ecc_in_buf2[31:0]),
    .io_dram_data_in			(io_dram3_data_in_buf2[255:0]),
    .dram_io_cas_l			(dram3_io_cas_l_buf0),
    .dram_io_channel_disabled		(dram3_io_channel_disabled_buf0),
    .dram_io_cke			(dram3_io_cke_buf0),
    .dram_io_clk_enable			(dram3_io_clk_enable_buf0),
    .dram_io_drive_data			(dram3_io_drive_data_buf0),
    .dram_io_drive_enable		(dram3_io_drive_enable_buf0),
    .dram_io_pad_clk_inv		(dram3_io_pad_clk_inv_buf0),
    .dram_io_pad_enable			(dram3_io_pad_enable_buf0),
    .dram_io_ras_l			(dram3_io_ras_l_buf0),
    .dram_io_write_en_l			(dram3_io_write_en_l_buf0),
    .dram_io_addr			(dram3_io_addr_buf0[14:0]),
    .dram_io_bank			(dram3_io_bank_buf0[2:0]),
    .dram_io_cs_l			(dram3_io_cs_l_buf0[3:0]),
    .dram_io_data_out			(dram3_io_data_out_buf0[287:0]),
    .dram_io_ptr_clk_inv		(dram3_io_ptr_clk_inv_buf0[4:0]));
//


   dram_ddr_pad_rptr_south dram3_ddr3_rptr2 (
    // Outputs
    .io_dram_data_valid_buf		(io_dram3_data_valid_buf2),
    .io_dram_ecc_in_buf			(io_dram3_ecc_in_buf2[31:0]),
    .io_dram_data_in_buf		(io_dram3_data_in_buf2[255:0]),
    .dram_io_cas_l_buf			(dram3_io_cas_l_buf2),
    .dram_io_channel_disabled_buf	(dram3_io_channel_disabled_buf2),
    .dram_io_cke_buf			(dram3_io_cke_buf2),
    .dram_io_clk_enable_buf		(dram3_io_clk_enable_buf2),
    .dram_io_drive_data_buf		(dram3_io_drive_data_buf2),
    .dram_io_drive_enable_buf		(dram3_io_drive_enable_buf2),
    .dram_io_pad_clk_inv_buf		(dram3_io_pad_clk_inv_buf2),
    .dram_io_pad_enable_buf		(dram3_io_pad_enable_buf2),
    .dram_io_ras_l_buf			(dram3_io_ras_l_buf2),
    .dram_io_write_en_l_buf		(dram3_io_write_en_l_buf2),
    .dram_io_addr_buf			(dram3_io_addr_buf2[14:0]),
    .dram_io_bank_buf			(dram3_io_bank_buf2[2:0]),
    .dram_io_cs_l_buf			(dram3_io_cs_l_buf2[3:0]),
    .dram_io_data_out_buf		(dram3_io_data_out_buf2[287:0]),
    .dram_io_ptr_clk_inv_buf		(dram3_io_ptr_clk_inv_buf2[4:0]),
    // Inputs
    .io_dram_data_valid			(io_dram3_data_valid),
    .io_dram_ecc_in			(io_dram3_ecc_in[31:0]),
    .io_dram_data_in			(io_dram3_data_in[255:0]),
    .dram_io_cas_l			(dram3_io_cas_l_buf1),
    .dram_io_channel_disabled		(dram3_io_channel_disabled_buf1),
    .dram_io_cke			(dram3_io_cke_buf1),
    .dram_io_clk_enable			(dram3_io_clk_enable_buf1),
    .dram_io_drive_data			(dram3_io_drive_data_buf1),
    .dram_io_drive_enable		(dram3_io_drive_enable_buf1),
    .dram_io_pad_clk_inv		(dram3_io_pad_clk_inv_buf1),
    .dram_io_pad_enable			(dram3_io_pad_enable_buf1),
    .dram_io_ras_l			(dram3_io_ras_l_buf1),
    .dram_io_write_en_l			(dram3_io_write_en_l_buf1),
    .dram_io_addr			(dram3_io_addr_buf1[14:0]),
    .dram_io_bank			(dram3_io_bank_buf1[2:0]),
    .dram_io_cs_l			(dram3_io_cs_l_buf1[3:0]),
    .dram_io_data_out			(dram3_io_data_out_buf1[287:0]),
    .dram_io_ptr_clk_inv		(dram3_io_ptr_clk_inv_buf1[4:0]));
//


/* pcm AUTO_TEMPLATE (
    .pmo_bump				(PMO),
    .pmi_bump				(PMI),
    .pmo_oe				(pcm_misc_oe),
    .io_pmo				(pcm_io_pmo),
    .io_pmi				(io_pcm_pmi),
    .io_burnin				(pcm_io_burnin),
    .io_pwron_rst_l			(io_pwron_rst_l),
    .pi_state_in_44			(rpt_cmp_grst_l_c1),
    .pi_state_in_45			(jbus_grst_l),
    .pi_state_in_46			(cmp_adbginit_l),
    .pi_state_in_47			(rpt_cmp_jbus_rx_sync_c1),
    .pi_state_in_48			(rpt_cmp_jbus_tx_sync_c1),
    .rclk				(cmp_gclk_c3_r[0]),
    .reset_m3				(1'b0),
    .pmo_m3				(PMO),
    .pmi_m3				(1'b0),
    .sel_m3				(1'b0),
    .vddto				(VDDTO),
    .vddbo				(VDDBO),
    ); */
//
`ifdef RTL_PAD_PCM
   pcm pcm
     (/*AUTOINST*/
      // Outputs
      .pmo_oe				(pcm_misc_oe),		 // Templated
      .io_pmo				(pcm_io_pmo),		 // Templated
      // Inouts
      .pmo_bump				(PMO),			 // Templated
      .pmi_bump				(PMI),			 // Templated
      .vddto				(VDDTO),		 // Templated
      .vddbo				(VDDBO),		 // Templated
      // Inputs
      .io_pmi				(io_pcm_pmi),		 // Templated
      .io_burnin			(pcm_io_burnin),	 // Templated
      .io_pll_char_in			(io_pll_char_in),
      .io_pwron_rst_l			(io_pwron_rst_l),	 // Templated
      .pi_state_in_44			(rpt_cmp_grst_l_c1),	 // Templated
      .pi_state_in_45			(jbus_grst_l),		 // Templated
      .pi_state_in_46			(cmp_adbginit_l),	 // Templated
      .pi_state_in_47			(rpt_cmp_jbus_rx_sync_c1), // Templated
      .pi_state_in_48			(rpt_cmp_jbus_tx_sync_c1), // Templated
      .rclk				(cmp_gclk_c3_r[0]),	 // Templated
      .reset_m3				(1'b0),			 // Templated
      .pmo_m3				(PMO),			 // Templated
      .pmi_m3				(1'b0),			 // Templated
      .sel_m3				(1'b0));			 // Templated
`endif

endmodule // iop


// Local Variables:
// verilog-library-directories:("." "../cmp/rtl" "../ctu/rtl" "../iobdg/rtl" "../jbi/rtl" "../fpu/rtl" "../sparc/rtl" "../ccx/rtl" "../dram/rtl" "../scbuf/rtl" "../sctag/rtl" "../scdata/rtl" "../pads/pad_ddr0/rtl" "../pads/pad_ddr1/rtl" "../pads/pad_ddr2/rtl" "../pads/pad_ddr3/rtl" "../pads/pad_efc/rtl" "../pads/pad_fcram/rtl" "../pads/pad_jbusl/rtl" "../pads/pad_jbusr/rtl" "../pads/pad_rtbi/rtl" "../pads/pad_misc/rtl" "../pads/pad_pcm/rtl" "../efc/rtl" "../analog/bw_temp_diode/rtl" "../analog/bw_clk/rtl" "../analog/bw_ctu_pad_cluster/rtl")
// End:
