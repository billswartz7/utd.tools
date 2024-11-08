// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg.v
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
/*
//  Module Name:	iobdg (IO Bridge)
//  Description:        This block is interface block between SPARC cores
//                      via the crossbar and the IO Subsystem.
*/
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////
`include	"sys.h" // system level definition file which contains the 
			// time scale definition
`include        "iop.h"


////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////


module iobdg (/*AUTOARG*/
   // Outputs
   iob_pcx_stall_pq, iob_jbi_mondo_nack, iob_jbi_mondo_ack, 
   iob_jbi_dbg_lo_vld, iob_jbi_dbg_lo_data, iob_jbi_dbg_hi_vld, 
   iob_jbi_dbg_hi_data, iob_io_dbg_en, iob_io_dbg_data, 
   iob_io_dbg_ck_p, iob_io_dbg_ck_n, iob_ctu_coreavail, 
   iob_cpx_req_cq, iob_cpx_data_ca, iob_clk_tr, iob_clk_l2_tr, 
   iob_clk_data, iob_clk_stall, iob_clk_vld, iob_dram02_data, 
   iob_dram02_stall, iob_dram02_vld, iob_dram13_data, 
   iob_dram13_stall, iob_dram13_vld, iob_jbi_pio_data, 
   iob_jbi_pio_stall, iob_jbi_pio_vld, iob_jbi_spi_data, 
   iob_jbi_spi_stall, iob_jbi_spi_vld, iob_tap_data, iob_tap_stall, 
   iob_tap_vld, iob_scanout, 
   // Inputs
   tap_iob_vld, tap_iob_stall, tap_iob_data, pcx_iob_data_rdy_px2, 
   pcx_iob_data_px2, l2_dbgbus_23, l2_dbgbus_01, jbus_grst_l, 
   jbus_gdbginit_l, jbus_gclk, jbus_arst_l, jbus_adbginit_l, 
   jbi_iob_spi_vld, jbi_iob_spi_stall, jbi_iob_spi_data, 
   jbi_iob_pio_vld, jbi_iob_pio_stall, jbi_iob_pio_data, 
   jbi_iob_mondo_vld, jbi_iob_mondo_data, io_trigin, io_temp_trig, 
   global_shift_enable, efc_iob_sernum2_dshift, 
   efc_iob_sernum1_dshift, efc_iob_sernum0_dshift, 
   efc_iob_fusestat_dshift, efc_iob_fuse_data, 
   efc_iob_coreavail_dshift, dram13_iob_vld, dram13_iob_stall, 
   dram13_iob_data, dram02_iob_vld, dram02_iob_stall, 
   dram02_iob_data, dbg_en_23, dbg_en_01, ctu_tst_short_chain, 
   ctu_tst_scanmode, ctu_tst_scan_disable, ctu_tst_pre_grst_l, 
   ctu_tst_macrotest, ctu_iob_wake_thr, cpx_iob_grant_cx2, 
   cmp_grst_l, cmp_gdbginit_l, cmp_gclk, cmp_arst_l, cmp_adbginit_l, 
   clspine_jbus_tx_sync, clspine_jbus_rx_sync, 
   clspine_iob_resetstat_wr, clspine_iob_resetstat, clk_iob_vld, 
   clk_iob_stall, clk_iob_jbus_cken, clk_iob_data, clk_iob_cmp_cken, 
   efc_iob_fuse_clk1, iob_scanin
   );

   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		clk_iob_cmp_cken;	// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v
   input [`CLK_IOB_WIDTH-1:0]clk_iob_data;	// To i2c of i2c.v, ...
   input		clk_iob_jbus_cken;	// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   input		clk_iob_stall;		// To c2i of c2i.v, ...
   input		clk_iob_vld;		// To i2c of i2c.v, ...
   input [`IOB_RESET_STAT_WIDTH-1:0]clspine_iob_resetstat;// To iobdg_ctrl of iobdg_ctrl.v
   input		clspine_iob_resetstat_wr;// To iobdg_ctrl of iobdg_ctrl.v
   input		clspine_jbus_rx_sync;	// To cluster_header_sync of cluster_header_sync.v
   input		clspine_jbus_tx_sync;	// To cluster_header_sync of cluster_header_sync.v
   input		cmp_adbginit_l;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v
   input		cmp_arst_l;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v, ...
   input		cmp_gclk;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v, ...
   input		cmp_gdbginit_l;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v
   input		cmp_grst_l;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v
   input [`IOB_CPU_WIDTH-1:0]cpx_iob_grant_cx2;	// To i2c of i2c.v
   input		ctu_iob_wake_thr;	// To iobdg_ctrl of iobdg_ctrl.v
   input		ctu_tst_macrotest;	// To test_stub_scan of test_stub_scan.v
   input		ctu_tst_pre_grst_l;	// To test_stub_scan of test_stub_scan.v
   input		ctu_tst_scan_disable;	// To test_stub_scan of test_stub_scan.v
   input		ctu_tst_scanmode;	// To test_stub_scan of test_stub_scan.v
   input		ctu_tst_short_chain;	// To test_stub_scan of test_stub_scan.v
   input		dbg_en_01;		// To iobdg_dbg of iobdg_dbg.v
   input		dbg_en_23;		// To iobdg_dbg of iobdg_dbg.v
   input [`DRAM_IOB_WIDTH-1:0]dram02_iob_data;	// To i2c of i2c.v, ...
   input		dram02_iob_stall;	// To c2i of c2i.v, ...
   input		dram02_iob_vld;		// To i2c of i2c.v, ...
   input [`DRAM_IOB_WIDTH-1:0]dram13_iob_data;	// To i2c of i2c.v, ...
   input		dram13_iob_stall;	// To c2i of c2i.v, ...
   input		dram13_iob_vld;		// To i2c of i2c.v, ...
   input		efc_iob_coreavail_dshift;// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_fuse_data;	// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_fusestat_dshift;// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_sernum0_dshift;	// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_sernum1_dshift;	// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_sernum2_dshift;	// To iobdg_ctrl of iobdg_ctrl.v
   input		global_shift_enable;	// To test_stub_scan of test_stub_scan.v
   input		io_temp_trig;		// To iobdg_ctrl of iobdg_ctrl.v
   input		io_trigin;		// To iobdg_dbg of iobdg_dbg.v
   input [`JBI_IOB_MONDO_BUS_WIDTH-1:0]jbi_iob_mondo_data;// To i2c of i2c.v
   input		jbi_iob_mondo_vld;	// To i2c of i2c.v
   input [`JBI_IOB_WIDTH-1:0]jbi_iob_pio_data;	// To i2c of i2c.v, ...
   input		jbi_iob_pio_stall;	// To c2i of c2i.v, ...
   input		jbi_iob_pio_vld;	// To i2c of i2c.v, ...
   input [`SPI_IOB_WIDTH-1:0]jbi_iob_spi_data;	// To i2c of i2c.v, ...
   input		jbi_iob_spi_stall;	// To c2i of c2i.v, ...
   input		jbi_iob_spi_vld;	// To i2c of i2c.v, ...
   input		jbus_adbginit_l;	// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   input		jbus_arst_l;		// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v, ...
   input		jbus_gclk;		// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   input		jbus_gdbginit_l;	// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   input		jbus_grst_l;		// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   input [39:0]		l2_dbgbus_01;		// To iobdg_dbg of iobdg_dbg.v
   input [39:0]		l2_dbgbus_23;		// To iobdg_dbg of iobdg_dbg.v
   input [`PCX_WIDTH-1:0]pcx_iob_data_px2;	// To c2i of c2i.v
   input		pcx_iob_data_rdy_px2;	// To c2i of c2i.v
   input [`TAP_IOB_WIDTH-1:0]tap_iob_data;	// To c2i of c2i.v, ...
   input		tap_iob_stall;		// To i2c of i2c.v, ...
   input		tap_iob_vld;		// To c2i of c2i.v, ...
   // End of automatics

   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		iob_clk_l2_tr;		// From iobdg_dbg of iobdg_dbg.v
   output		iob_clk_tr;		// From iobdg_dbg of iobdg_dbg.v
   output [`CPX_WIDTH-1:0]iob_cpx_data_ca;	// From i2c of i2c.v
   output [`IOB_CPU_WIDTH-1:0]iob_cpx_req_cq;	// From i2c of i2c.v
   output [`IOB_CPU_WIDTH-1:0]iob_ctu_coreavail;// From iobdg_ctrl of iobdg_ctrl.v
   output [2:0]		iob_io_dbg_ck_n;	// From iobdg_dbg of iobdg_dbg.v
   output [2:0]		iob_io_dbg_ck_p;	// From iobdg_dbg of iobdg_dbg.v
   output [39:0]	iob_io_dbg_data;	// From iobdg_dbg of iobdg_dbg.v
   output		iob_io_dbg_en;		// From iobdg_dbg of iobdg_dbg.v
   output [47:0]	iob_jbi_dbg_hi_data;	// From iobdg_dbg of iobdg_dbg.v
   output		iob_jbi_dbg_hi_vld;	// From iobdg_dbg of iobdg_dbg.v
   output [47:0]	iob_jbi_dbg_lo_data;	// From iobdg_dbg of iobdg_dbg.v
   output		iob_jbi_dbg_lo_vld;	// From iobdg_dbg of iobdg_dbg.v
   output		iob_jbi_mondo_ack;	// From i2c of i2c.v
   output		iob_jbi_mondo_nack;	// From i2c of i2c.v
   output		iob_pcx_stall_pq;	// From c2i of c2i.v
   // End of automatics

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [`UCB_64PAY_PKT_WIDTH-1:0]bounce_ack_packet;// From iobdg_ctrl of iobdg_ctrl.v
   wire			bounce_ack_rd;		// From i2c of i2c.v
   wire			bounce_ack_vld;		// From iobdg_ctrl of iobdg_ctrl.v
   wire			bounce_ucb_buf_acpt;	// From iobdg_ctrl of iobdg_ctrl.v
   wire			bounce_ucb_sel;		// From c2i of c2i.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]c2i_packet;	// From c2i of c2i.v
   wire			c2i_packet_is_rd_req;	// From c2i of c2i.v
   wire			c2i_packet_is_wr_req;	// From c2i of c2i.v
   wire			c2i_packet_vld;		// From c2i of c2i.v
   wire [`UCB_NOPAY_PKT_WIDTH-1:0]c2i_rd_nack_packet;// From c2i of c2i.v
   wire			cmp_rclk;		// From bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v
   wire [64:0]		cpu_buf_din_hi;		// From c2i of c2i.v
   wire [64:0]		cpu_buf_din_lo;		// From c2i of c2i.v
   wire [64:0]		cpu_buf_dout_hi;	// From cpu_buf_hi of bw_rf_16x65.v
   wire [64:0]		cpu_buf_dout_lo;	// From cpu_buf_lo of bw_rf_16x65.v
   wire [`IOB_CPU_BUF_INDEX-1:0]cpu_buf_head_ptr;// From c2i of c2i.v
   wire			cpu_buf_rd_l;		// From c2i of c2i.v
   wire [`IOB_CPU_BUF_INDEX-1:0]cpu_buf_tail_ptr;// From c2i of c2i.v
   wire			cpu_buf_wr_l;		// From c2i of c2i.v
   wire			cpu_intctrl_acc;	// From iobdg_ctrl of iobdg_ctrl.v
   wire			cpu_intman_acc;		// From iobdg_ctrl of iobdg_ctrl.v
   wire			cpu_mondo_rd_d2;	// From c2i of c2i.v
   wire			cpu_mondo_wr_d2;	// From c2i of c2i.v
   wire [63:0]		creg_dbg_enet_ctrl;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_enet_idleval;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_iob_vis_ctrl;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_ctrl;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_hi_cmp0;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_hi_cmp1;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_hi_cnt0;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_hi_cnt1;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_hi_mask0;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_hi_mask1;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_lo_cmp0;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_lo_cmp1;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_lo_cnt0;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_lo_cnt1;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_lo_mask0;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_jbus_lo_mask1;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_l2_vis_cmpa_s;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_l2_vis_cmpb_s;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_l2_vis_ctrl;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_l2_vis_maska_s;// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_l2_vis_maskb_s;// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		creg_dbg_l2_vis_trig_delay_s;// From iobdg_ctrl of iobdg_ctrl.v
   wire			creg_intctrl_mask;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [`IOB_INT_VEC_WIDTH-1:0]creg_jintv_vec;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [4:0]		creg_margin_16x65;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [`IOB_CPU_WIDTH-1:0]first_availcore;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [159:0]		int_buf_din_raw;	// From c2i of c2i.v
   wire [159:0]		int_buf_dout_raw;	// From int_buf of iobdg_1r1w_rf16x160.v
   wire [`IOB_INT_BUF_INDEX-1:0]int_buf_head_ptr;// From i2c of i2c.v
   wire			int_buf_hit_hwm;	// From i2c of i2c.v
   wire [`IOB_INT_BUF_INDEX-1:0]int_buf_tail_ptr;// From i2c of i2c.v
   wire			int_buf_wr;		// From i2c of i2c.v
   wire [`IOB_INT_TAB_INDEX-1:0]int_cpu_addr;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [14:0]		int_cpu_din_raw;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [14:0]		int_cpu_dout_raw;	// From int_cpu_stat of iobdg_1r1w_rf4.v
   wire			int_cpu_wr_l;		// From iobdg_ctrl of iobdg_ctrl.v
   wire			int_srvcd;		// From i2c of i2c.v
   wire			int_srvcd_d1;		// From i2c of i2c.v
   wire [`IOB_INT_TAB_INDEX-1:0]int_vec_addr;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [14:0]		int_vec_din_raw;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [14:0]		int_vec_dout_raw;	// From int_vec_stat of iobdg_1r1w_rf4.v
   wire			int_vec_wr_l;		// From iobdg_ctrl of iobdg_ctrl.v
   wire			io_buf_avail;		// From i2c of i2c.v
   wire [159:0]		io_buf_din_raw;		// From i2c of i2c.v
   wire [159:0]		io_buf_dout_raw;	// From io_buf of iobdg_1r1w_rf16x160.v
   wire [`IOB_IO_BUF_INDEX-1:0]io_buf_head_ptr;	// From i2c of i2c.v
   wire [`IOB_IO_BUF_INDEX-1:0]io_buf_tail_ptr;	// From i2c of i2c.v
   wire			io_buf_wr;		// From i2c of i2c.v
   wire [`IOB_INT_TAB_INDEX-1:0]io_intman_addr;	// From i2c of i2c.v
   wire [63:0]		io_mondo_data0_din_s;	// From i2c of i2c.v
   wire [63:0]		io_mondo_data1_din_s;	// From i2c of i2c.v
   wire [`IOB_CPUTHR_INDEX-1:0]io_mondo_data_wr_addr_s;// From i2c of i2c.v
   wire			io_mondo_data_wr_s;	// From i2c of i2c.v
   wire [`JBI_IOB_MONDO_SRC_WIDTH-1:0]io_mondo_source_din_s;// From i2c of i2c.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]iob_int_ack_packet;// From iobdg_ctrl of iobdg_ctrl.v
   wire			iob_int_ack_rd;		// From i2c of i2c.v
   wire			iob_int_ack_vld;	// From iobdg_ctrl of iobdg_ctrl.v
   wire			iob_int_ucb_buf_acpt;	// From iobdg_ctrl of iobdg_ctrl.v
   wire			iob_int_ucb_sel;	// From c2i of c2i.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]iob_man_ack_packet;// From iobdg_ctrl of iobdg_ctrl.v
   wire			iob_man_ack_rd;		// From i2c of i2c.v
   wire			iob_man_ack_vld;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [`UCB_INT_PKT_WIDTH-1:0]iob_man_int_packet;// From iobdg_ctrl of iobdg_ctrl.v
   wire			iob_man_int_rd;		// From i2c of i2c.v
   wire			iob_man_int_vld;	// From iobdg_ctrl of iobdg_ctrl.v
   wire			iob_man_ucb_buf_acpt;	// From iobdg_ctrl of iobdg_ctrl.v
   wire			iob_man_ucb_sel;	// From c2i of c2i.v
   wire			jbus_rclk;		// From bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   wire			l2_vis_armin;		// From iobdg_dbg of iobdg_dbg.v
   wire [64:0]		l2_vis_buf_din_hi;	// From iobdg_dbg of iobdg_dbg.v
   wire [64:0]		l2_vis_buf_din_lo;	// From iobdg_dbg of iobdg_dbg.v
   wire [64:0]		l2_vis_buf_dout_hi;	// From l2_vis_buf_hi of bw_rf_16x65.v
   wire [64:0]		l2_vis_buf_dout_lo;	// From l2_vis_buf_lo of bw_rf_16x65.v
   wire [`IOB_L2_VIS_BUF_INDEX-1:0]l2_vis_buf_head_ptr;// From iobdg_dbg of iobdg_dbg.v
   wire			l2_vis_buf_rd_hi_l;	// From iobdg_dbg of iobdg_dbg.v
   wire			l2_vis_buf_rd_lo_l;	// From iobdg_dbg of iobdg_dbg.v
   wire [`IOB_L2_VIS_BUF_INDEX-1:0]l2_vis_buf_tail_ptr;// From iobdg_dbg of iobdg_dbg.v
   wire			l2_vis_buf_wr_hi_l;	// From iobdg_dbg of iobdg_dbg.v
   wire			l2_vis_buf_wr_lo_l;	// From iobdg_dbg of iobdg_dbg.v
   wire			mem_bypass;		// From test_stub_scan of test_stub_scan.v
   wire [`IOB_MONDO_DATA_INDEX-1:0]mondo_busy_addr_p0;// From c2i of c2i.v
   wire [`IOB_MONDO_DATA_INDEX-1:0]mondo_busy_addr_p1;// From c2i of c2i.v
   wire [`IOB_MONDO_DATA_INDEX-1:0]mondo_busy_addr_p2;// From c2i of c2i.v
   wire			mondo_busy_din_p1;	// From c2i of c2i.v
   wire			mondo_busy_din_p2;	// From c2i of c2i.v
   wire			mondo_busy_dout;	// From mondo_busy of iobdg_1r2w_vec.v
   wire [`IOB_CPUTHR_WIDTH-1:0]mondo_busy_vec_f;// From mondo_busy of iobdg_1r2w_vec.v
   wire			mondo_busy_wr_p1;	// From c2i of c2i.v
   wire			mondo_busy_wr_p2;	// From c2i of c2i.v
   wire [64:0]		mondo_data0_din_hi;	// From c2i of c2i.v
   wire [64:0]		mondo_data0_din_lo;	// From c2i of c2i.v
   wire [64:0]		mondo_data0_dout_hi;	// From mondo_data0_hi of bw_rf_16x65.v
   wire [64:0]		mondo_data0_dout_lo;	// From mondo_data0_lo of bw_rf_16x65.v
   wire			mondo_data0_wr_hi_l;	// From c2i of c2i.v
   wire			mondo_data0_wr_lo_l;	// From c2i of c2i.v
   wire [64:0]		mondo_data1_din_hi;	// From c2i of c2i.v
   wire [64:0]		mondo_data1_din_lo;	// From c2i of c2i.v
   wire [64:0]		mondo_data1_dout_hi;	// From mondo_data1_hi of bw_rf_16x65.v
   wire [64:0]		mondo_data1_dout_lo;	// From mondo_data1_lo of bw_rf_16x65.v
   wire			mondo_data1_wr_hi_l;	// From c2i of c2i.v
   wire			mondo_data1_wr_lo_l;	// From c2i of c2i.v
   wire [`IOB_MONDO_DATA_INDEX-1:0]mondo_data_addr_p0;// From c2i of c2i.v
   wire [`IOB_MONDO_DATA_INDEX-1:0]mondo_data_addr_p1;// From c2i of c2i.v
   wire [`IOB_MONDO_SRC_WIDTH-1:0]mondo_source_din;// From c2i of c2i.v
   wire [`IOB_MONDO_SRC_WIDTH-1:0]mondo_source_dout;// From mondo_source of iobdg_1r1w_rf32.v
   wire			mondo_source_wr_l;	// From c2i of c2i.v
   wire [`UCB_NOPAY_PKT_WIDTH-1:0]rd_nack_packet;// From iobdg_ctrl of iobdg_ctrl.v
   wire			rd_nack_rd;		// From i2c of i2c.v
   wire			rd_nack_ucb_buf_acpt;	// From iobdg_ctrl of iobdg_ctrl.v
   wire			rd_nack_ucb_sel;	// From c2i of c2i.v
   wire			rd_nack_vld;		// From iobdg_ctrl of iobdg_ctrl.v
   wire			rst_l;			// From bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   wire			rst_tri_en;		// From test_stub_scan of test_stub_scan.v
   wire			sehold;			// From test_stub_scan of test_stub_scan.v
   wire			srvc_wr_ack;		// From c2i of c2i.v
   wire			tap_mondo_acc_addr_invld_d2_f;// From c2i of c2i.v
   wire [`IOB_ADDR_WIDTH-1:0]tap_mondo_acc_addr_s;// From iobdg_ctrl of iobdg_ctrl.v
   wire			tap_mondo_acc_seq_d2_f;	// From c2i of c2i.v
   wire			tap_mondo_acc_seq_s;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		tap_mondo_din_s;	// From iobdg_ctrl of iobdg_ctrl.v
   wire [63:0]		tap_mondo_dout_d2_f;	// From c2i of c2i.v
   wire			tap_mondo_wr_s;		// From iobdg_ctrl of iobdg_ctrl.v
   wire			ucb_buf_acpt;		// From c2i of c2i.v
   wire [`IOB_IO_BUF_WIDTH-1:0]wr_ack_io_buf_din;// From c2i of c2i.v
   // End of automatics

   output [`IOB_CLK_WIDTH-1:0]iob_clk_data;	// From c2i of c2i.v
   output		iob_clk_stall;		// From i2c of i2c.v
   output		iob_clk_vld;		// From c2i of c2i.v
   output [`IOB_DRAM_WIDTH-1:0]iob_dram02_data;	// From c2i of c2i.v
   output		iob_dram02_stall;	// From i2c of i2c.v
   output		iob_dram02_vld;		// From c2i of c2i.v
   output [`IOB_DRAM_WIDTH-1:0]iob_dram13_data;	// From c2i of c2i.v
   output		iob_dram13_stall;	// From i2c of i2c.v
   output		iob_dram13_vld;		// From c2i of c2i.v
   output [`IOB_JBI_WIDTH-1:0]iob_jbi_pio_data;	// From c2i of c2i.v
   output		iob_jbi_pio_stall;	// From i2c of i2c.v
   output		iob_jbi_pio_vld;	// From c2i of c2i.v
   output [`IOB_SPI_WIDTH-1:0]iob_jbi_spi_data;	// From c2i of c2i.v
   output		iob_jbi_spi_stall;	// From i2c of i2c.v
   output		iob_jbi_spi_vld;	// From c2i of c2i.v
   output [`IOB_TAP_WIDTH-1:0]iob_tap_data;	// From i2c of i2c.v
   output		iob_tap_stall;		// From c2i of c2i.v
   output		iob_tap_vld;		// From i2c of i2c.v

   
   wire 	  cmp_pre_rst_l;
   wire 	  cmp_rst_l;
   wire 	  pre_rx_sync;
   wire 	  pre_tx_sync;
   wire 	  rx_sync;
   wire 	  tx_sync;

   input 	  efc_iob_fuse_clk1;
   wire 	  efuse_rclk;
   
   input 	  iob_scanin;
   output         iob_scanout;
   wire 	  se;

   wire 	  so_0;
   wire 	  long_chain_so_0;
   wire 	  short_chain_so_0;
   wire 	  testmode_l;
   
   
   /***********************************************************
    * Hand edit begin fixme
    ***********************************************************/

   /***********************************************************
    * Hand edit end
    ***********************************************************/

   
////////////////////////////////////////////////////////////////////////
// Code start here 
////////////////////////////////////////////////////////////////////////
   /*****************************************************************
    * CMP Cluster Header
    *****************************************************************/
   /* bw_clk_cl_iobdg_cmp AUTO_TEMPLATE (
    // Outputs
    .dbginit_l          (),
    .rclk               (cmp_rclk),
    .so                 (),
    // Inputs
    .gclk               (cmp_gclk),
    .cluster_cken       (clk_iob_cmp_cken),
    .arst_l             (cmp_arst_l),
    .grst_l             (cmp_grst_l),
    .adbginit_l         (cmp_adbginit_l),
    .gdbginit_l         (cmp_gdbginit_l),
    .si                 (),
    .se                 (se),
    ); */

   bw_clk_cl_iobdg_cmp bw_clk_cl_iobdg_cmp (.cluster_grst_l(cmp_pre_rst_l),
					    /*AUTOINST*/
					    // Outputs
					    .dbginit_l(),	 // Templated
					    .rclk(cmp_rclk),	 // Templated
					    .so(),		 // Templated
					    // Inputs
					    .adbginit_l(cmp_adbginit_l), // Templated
					    .arst_l(cmp_arst_l), // Templated
					    .cluster_cken(clk_iob_cmp_cken), // Templated
					    .gclk(cmp_gclk),	 // Templated
					    .gdbginit_l(cmp_gdbginit_l), // Templated
					    .grst_l(cmp_grst_l), // Templated
					    .se(se),		 // Templated
					    .si());		 // Templated

   
   // async flop for cmp_rst_l distribution
   dffrl_async_ns #(1) cmp_rst_l_ff (.din(cmp_pre_rst_l),
			 	     .clk(cmp_rclk),
			 	     .rst_l(cmp_arst_l),
			 	     .q(cmp_rst_l));

   
   /*****************************************************************
    * JBUS Cluster Header
    *****************************************************************/
   /* bw_clk_cl_iobdg_jbus AUTO_TEMPLATE (
    // Outputs
    .dbginit_l          (),
    .cluster_grst_l     (rst_l),
    .rclk               (jbus_rclk),
    .so                 (),
    // Inputs
    .gclk               (jbus_gclk),
    .cluster_cken       (clk_iob_jbus_cken),
    .arst_l             (jbus_arst_l),
    .grst_l             (jbus_grst_l),
    .adbginit_l         (jbus_adbginit_l),
    .gdbginit_l         (jbus_gdbginit_l),
    .si                 (),
    .se                 (se),
    ); */

   bw_clk_cl_iobdg_jbus bw_clk_cl_iobdg_jbus (/*AUTOINST*/
					      // Outputs
					      .cluster_grst_l(rst_l), // Templated
					      .dbginit_l(),	 // Templated
					      .rclk(jbus_rclk),	 // Templated
					      .so(),		 // Templated
					      // Inputs
					      .adbginit_l(jbus_adbginit_l), // Templated
					      .arst_l(jbus_arst_l), // Templated
					      .cluster_cken(clk_iob_jbus_cken), // Templated
					      .gclk(jbus_gclk),	 // Templated
					      .gdbginit_l(jbus_gdbginit_l), // Templated
					      .grst_l(jbus_grst_l), // Templated
					      .se(se),		 // Templated
					      .si());		 // Templated


   /*****************************************************************
    * Mux between efuse clock and jbus clock so that the efuse flops
    * are controllable by scan
    *****************************************************************/
   assign 	  efuse_rclk = testmode_l ? efc_iob_fuse_clk1 : jbus_rclk;

   
   /*****************************************************************
    * Flop Sync signals
    *****************************************************************/
   /* cluster_header_sync AUTO_TEMPLATE (
    // Outputs
    .dram_rx_sync_local(),
    .dram_tx_sync_local(),
    .jbus_rx_sync_local(pre_rx_sync),
    .jbus_tx_sync_local(pre_tx_sync),
    .so(),
    // Inputs
    .dram_rx_sync_global(1'b0),
    .dram_tx_sync_global(1'b0),
    .jbus_rx_sync_global(clspine_jbus_rx_sync),
    .jbus_tx_sync_global(clspine_jbus_tx_sync),
    .cmp_gclk(cmp_gclk),
    .cmp_rclk(cmp_rclk),
    .si(),
    .se(se)); */

   cluster_header_sync cluster_header_sync (.jbus_rx_sync_local(pre_rx_sync),
					    .jbus_tx_sync_local(pre_tx_sync),
					    /*AUTOINST*/
					    // Outputs
					    .dram_rx_sync_local(), // Templated
					    .dram_tx_sync_local(), // Templated
					    .so(),		 // Templated
					    // Inputs
					    .dram_rx_sync_global(1'b0), // Templated
					    .dram_tx_sync_global(1'b0), // Templated
					    .jbus_rx_sync_global(clspine_jbus_rx_sync), // Templated
					    .jbus_tx_sync_global(clspine_jbus_tx_sync), // Templated
					    .cmp_gclk(cmp_gclk), // Templated
					    .cmp_rclk(cmp_rclk), // Templated
					    .si(),		 // Templated
					    .se(se));		 // Templated

   // flop for rx_sync and tx_sync distribution
   dff_ns #(1) rx_sync_ff (.din(pre_rx_sync),
			   .clk(cmp_rclk),
			   .q(rx_sync));

   dff_ns #(1) tx_sync_ff (.din(pre_tx_sync),
			   .clk(cmp_rclk),
			   .q(tx_sync));

   
   /*****************************************************************
    * Test Stub
    *****************************************************************/
   /* test_stub_scan AUTO_TEMPLATE (
    // Outputs
    .mux_drive_disable  (),
    .mem_write_disable  (rst_tri_en),
    // Inputs
    .arst_l             (jbus_arst_l),
    ); */

   test_stub_scan test_stub_scan (.so_0	(so_0),
				  .so_1	(),
				  .so_2	(),
				  .long_chain_so_0(long_chain_so_0),
				  .short_chain_so_0(short_chain_so_0),
				  .long_chain_so_1(),
				  .short_chain_so_1(),
				  .long_chain_so_2(),
				  .short_chain_so_2(),
				  .testmode_l(testmode_l),
				  /*AUTOINST*/
				  // Outputs
				  .mux_drive_disable(),		 // Templated
				  .mem_write_disable(rst_tri_en), // Templated
				  .sehold(sehold),
				  .se	(se),
				  .mem_bypass(mem_bypass),
				  // Inputs
				  .ctu_tst_pre_grst_l(ctu_tst_pre_grst_l),
				  .arst_l(jbus_arst_l),		 // Templated
				  .global_shift_enable(global_shift_enable),
				  .ctu_tst_scan_disable(ctu_tst_scan_disable),
				  .ctu_tst_scanmode(ctu_tst_scanmode),
				  .ctu_tst_macrotest(ctu_tst_macrotest),
				  .ctu_tst_short_chain(ctu_tst_short_chain));
   
   
   /*****************************************************************
    * cpu-to-io
    *****************************************************************/
   /* c2i AUTO_TEMPLATE (
    // Inputs
    .cpu_clk           (cmp_rclk),
    .clk               (jbus_rclk),
    .cpu_rst_l	       (cmp_rst_l),
    ); */

   c2i c2i (/*AUTOINST*/
	    // Outputs
	    .bounce_ucb_sel		(bounce_ucb_sel),
	    .c2i_packet_is_rd_req	(c2i_packet_is_rd_req),
	    .c2i_packet_is_wr_req	(c2i_packet_is_wr_req),
	    .c2i_rd_nack_packet		(c2i_rd_nack_packet[`UCB_NOPAY_PKT_WIDTH-1:0]),
	    .cpu_buf_din_hi		(cpu_buf_din_hi[64:0]),
	    .cpu_buf_din_lo		(cpu_buf_din_lo[64:0]),
	    .cpu_buf_head_ptr		(cpu_buf_head_ptr[`IOB_CPU_BUF_INDEX-1:0]),
	    .cpu_buf_rd_l		(cpu_buf_rd_l),
	    .cpu_buf_tail_ptr		(cpu_buf_tail_ptr[`IOB_CPU_BUF_INDEX-1:0]),
	    .cpu_buf_wr_l		(cpu_buf_wr_l),
	    .cpu_mondo_wr_d2		(cpu_mondo_wr_d2),
	    .int_buf_din_raw		(int_buf_din_raw[159:0]),
	    .iob_clk_data		(iob_clk_data[`IOB_CLK_WIDTH-1:0]),
	    .iob_clk_vld		(iob_clk_vld),
	    .iob_dram02_data		(iob_dram02_data[`IOB_DRAM_WIDTH-1:0]),
	    .iob_dram02_vld		(iob_dram02_vld),
	    .iob_dram13_data		(iob_dram13_data[`IOB_DRAM_WIDTH-1:0]),
	    .iob_dram13_vld		(iob_dram13_vld),
	    .iob_int_ucb_sel		(iob_int_ucb_sel),
	    .iob_jbi_pio_data		(iob_jbi_pio_data[`IOB_JBI_WIDTH-1:0]),
	    .iob_jbi_pio_vld		(iob_jbi_pio_vld),
	    .iob_jbi_spi_data		(iob_jbi_spi_data[`IOB_SPI_WIDTH-1:0]),
	    .iob_jbi_spi_vld		(iob_jbi_spi_vld),
	    .iob_man_ucb_sel		(iob_man_ucb_sel),
	    .iob_pcx_stall_pq		(iob_pcx_stall_pq),
	    .iob_tap_stall		(iob_tap_stall),
	    .mondo_busy_addr_p0		(mondo_busy_addr_p0[`IOB_MONDO_DATA_INDEX-1:0]),
	    .mondo_busy_addr_p1		(mondo_busy_addr_p1[`IOB_MONDO_DATA_INDEX-1:0]),
	    .mondo_busy_addr_p2		(mondo_busy_addr_p2[`IOB_MONDO_DATA_INDEX-1:0]),
	    .mondo_busy_din_p1		(mondo_busy_din_p1),
	    .mondo_busy_din_p2		(mondo_busy_din_p2),
	    .mondo_busy_wr_p1		(mondo_busy_wr_p1),
	    .mondo_busy_wr_p2		(mondo_busy_wr_p2),
	    .mondo_data0_din_hi		(mondo_data0_din_hi[64:0]),
	    .mondo_data0_din_lo		(mondo_data0_din_lo[64:0]),
	    .mondo_data0_wr_hi_l	(mondo_data0_wr_hi_l),
	    .mondo_data0_wr_lo_l	(mondo_data0_wr_lo_l),
	    .mondo_data1_din_hi		(mondo_data1_din_hi[64:0]),
	    .mondo_data1_din_lo		(mondo_data1_din_lo[64:0]),
	    .mondo_data1_wr_hi_l	(mondo_data1_wr_hi_l),
	    .mondo_data1_wr_lo_l	(mondo_data1_wr_lo_l),
	    .mondo_data_addr_p0		(mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-1:0]),
	    .mondo_data_addr_p1		(mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-1:0]),
	    .mondo_source_din		(mondo_source_din[`IOB_MONDO_SRC_WIDTH-1:0]),
	    .mondo_source_wr_l		(mondo_source_wr_l),
	    .rd_nack_ucb_sel		(rd_nack_ucb_sel),
	    .srvc_wr_ack		(srvc_wr_ack),
	    .tap_mondo_acc_addr_invld_d2_f(tap_mondo_acc_addr_invld_d2_f),
	    .tap_mondo_acc_seq_d2_f	(tap_mondo_acc_seq_d2_f),
	    .tap_mondo_dout_d2_f	(tap_mondo_dout_d2_f[63:0]),
	    .ucb_buf_acpt		(ucb_buf_acpt),
	    .wr_ack_io_buf_din		(wr_ack_io_buf_din[`IOB_IO_BUF_WIDTH-1:0]),
	    .cpu_mondo_rd_d2		(cpu_mondo_rd_d2),
	    .c2i_packet			(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
	    .c2i_packet_vld		(c2i_packet_vld),
	    // Inputs
	    .bounce_ucb_buf_acpt	(bounce_ucb_buf_acpt),
	    .clk			(jbus_rclk),		 // Templated
	    .clk_iob_stall		(clk_iob_stall),
	    .cpu_buf_dout_hi		(cpu_buf_dout_hi[64:0]),
	    .cpu_buf_dout_lo		(cpu_buf_dout_lo[64:0]),
	    .cpu_clk			(cmp_rclk),		 // Templated
	    .cpu_rst_l			(cmp_rst_l),		 // Templated
	    .dram02_iob_stall		(dram02_iob_stall),
	    .dram13_iob_stall		(dram13_iob_stall),
	    .int_buf_hit_hwm		(int_buf_hit_hwm),
	    .io_buf_avail		(io_buf_avail),
	    .io_mondo_data0_din_s	(io_mondo_data0_din_s[`IOB_MONDO_DATA_WIDTH-1:0]),
	    .io_mondo_data1_din_s	(io_mondo_data1_din_s[`IOB_MONDO_DATA_WIDTH-1:0]),
	    .io_mondo_data_wr_addr_s	(io_mondo_data_wr_addr_s[`IOB_MONDO_DATA_INDEX-1:0]),
	    .io_mondo_data_wr_s		(io_mondo_data_wr_s),
	    .io_mondo_source_din_s	(io_mondo_source_din_s[`IOB_MONDO_SRC_WIDTH-1:0]),
	    .iob_int_ucb_buf_acpt	(iob_int_ucb_buf_acpt),
	    .iob_man_ucb_buf_acpt	(iob_man_ucb_buf_acpt),
	    .jbi_iob_pio_stall		(jbi_iob_pio_stall),
	    .jbi_iob_spi_stall		(jbi_iob_spi_stall),
	    .mondo_busy_dout		(mondo_busy_dout),
	    .mondo_data0_dout_hi	(mondo_data0_dout_hi[64:0]),
	    .mondo_data0_dout_lo	(mondo_data0_dout_lo[64:0]),
	    .mondo_data1_dout_hi	(mondo_data1_dout_hi[64:0]),
	    .mondo_data1_dout_lo	(mondo_data1_dout_lo[64:0]),
	    .mondo_source_dout		(mondo_source_dout[`IOB_MONDO_SRC_WIDTH-1:0]),
	    .pcx_iob_data_px2		(pcx_iob_data_px2[`PCX_WIDTH-1:0]),
	    .pcx_iob_data_rdy_px2	(pcx_iob_data_rdy_px2),
	    .rd_nack_ucb_buf_acpt	(rd_nack_ucb_buf_acpt),
	    .rst_l			(rst_l),
	    .rx_sync			(rx_sync),
	    .tap_iob_data		(tap_iob_data[`TAP_IOB_WIDTH-1:0]),
	    .tap_iob_vld		(tap_iob_vld),
	    .tap_mondo_acc_addr_s	(tap_mondo_acc_addr_s[`IOB_ADDR_WIDTH-1:0]),
	    .tap_mondo_acc_seq_s	(tap_mondo_acc_seq_s),
	    .tap_mondo_din_s		(tap_mondo_din_s[63:0]),
	    .tap_mondo_wr_s		(tap_mondo_wr_s),
	    .tx_sync			(tx_sync));

   
   /*****************************************************************
    * io-to-cpu
    *****************************************************************/
   /* i2c AUTO_TEMPLATE (
    // Inputs
    .cpu_clk           (cmp_rclk),
    .clk               (jbus_rclk),
    .cpu_rst_l	       (cmp_rst_l),
    ); */

   i2c i2c (/*AUTOINST*/
	    // Outputs
	    .bounce_ack_rd		(bounce_ack_rd),
	    .int_buf_head_ptr		(int_buf_head_ptr[`IOB_INT_BUF_INDEX-1:0]),
	    .int_buf_hit_hwm		(int_buf_hit_hwm),
	    .int_buf_tail_ptr		(int_buf_tail_ptr[`IOB_INT_BUF_INDEX-1:0]),
	    .int_buf_wr			(int_buf_wr),
	    .int_srvcd			(int_srvcd),
	    .io_buf_avail		(io_buf_avail),
	    .io_buf_din_raw		(io_buf_din_raw[159:0]),
	    .io_buf_head_ptr		(io_buf_head_ptr[`IOB_IO_BUF_INDEX-1:0]),
	    .io_buf_tail_ptr		(io_buf_tail_ptr[`IOB_IO_BUF_INDEX-1:0]),
	    .io_buf_wr			(io_buf_wr),
	    .io_intman_addr		(io_intman_addr[`IOB_INT_TAB_INDEX-1:0]),
	    .io_mondo_data0_din_s	(io_mondo_data0_din_s[63:0]),
	    .io_mondo_data1_din_s	(io_mondo_data1_din_s[63:0]),
	    .io_mondo_data_wr_addr_s	(io_mondo_data_wr_addr_s[`IOB_CPUTHR_INDEX-1:0]),
	    .io_mondo_data_wr_s		(io_mondo_data_wr_s),
	    .io_mondo_source_din_s	(io_mondo_source_din_s[`JBI_IOB_MONDO_SRC_WIDTH-1:0]),
	    .iob_clk_stall		(iob_clk_stall),
	    .iob_cpx_data_ca		(iob_cpx_data_ca[`CPX_WIDTH-1:0]),
	    .iob_cpx_req_cq		(iob_cpx_req_cq[`IOB_CPU_WIDTH-1:0]),
	    .iob_dram02_stall		(iob_dram02_stall),
	    .iob_dram13_stall		(iob_dram13_stall),
	    .iob_int_ack_rd		(iob_int_ack_rd),
	    .iob_jbi_mondo_ack		(iob_jbi_mondo_ack),
	    .iob_jbi_mondo_nack		(iob_jbi_mondo_nack),
	    .iob_jbi_pio_stall		(iob_jbi_pio_stall),
	    .iob_jbi_spi_stall		(iob_jbi_spi_stall),
	    .iob_man_ack_rd		(iob_man_ack_rd),
	    .iob_man_int_rd		(iob_man_int_rd),
	    .iob_tap_data		(iob_tap_data[`IOB_TAP_WIDTH-1:0]),
	    .iob_tap_vld		(iob_tap_vld),
	    .rd_nack_rd			(rd_nack_rd),
	    .int_srvcd_d1		(int_srvcd_d1),
	    // Inputs
	    .bounce_ack_packet		(bounce_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
	    .bounce_ack_vld		(bounce_ack_vld),
	    .clk			(jbus_rclk),		 // Templated
	    .clk_iob_data		(clk_iob_data[`CLK_IOB_WIDTH-1:0]),
	    .clk_iob_vld		(clk_iob_vld),
	    .cpu_clk			(cmp_rclk),		 // Templated
	    .cpu_intctrl_acc		(cpu_intctrl_acc),
	    .cpu_intman_acc		(cpu_intman_acc),
	    .cpu_mondo_rd_d2		(cpu_mondo_rd_d2),
	    .cpu_mondo_wr_d2		(cpu_mondo_wr_d2),
	    .cpu_rst_l			(cmp_rst_l),		 // Templated
	    .cpx_iob_grant_cx2		(cpx_iob_grant_cx2[`IOB_CPU_WIDTH-1:0]),
	    .creg_intctrl_mask		(creg_intctrl_mask),
	    .creg_jintv_vec		(creg_jintv_vec[`IOB_INT_VEC_WIDTH-1:0]),
	    .dram02_iob_data		(dram02_iob_data[`DRAM_IOB_WIDTH-1:0]),
	    .dram02_iob_vld		(dram02_iob_vld),
	    .dram13_iob_data		(dram13_iob_data[`DRAM_IOB_WIDTH-1:0]),
	    .dram13_iob_vld		(dram13_iob_vld),
	    .first_availcore		(first_availcore[`IOB_CPU_WIDTH-1:0]),
	    .int_buf_dout_raw		(int_buf_dout_raw[159:0]),
	    .int_cpu_dout_raw		(int_cpu_dout_raw[14:0]),
	    .int_vec_dout_raw		(int_vec_dout_raw[14:0]),
	    .io_buf_dout_raw		(io_buf_dout_raw[159:0]),
	    .iob_int_ack_packet		(iob_int_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
	    .iob_int_ack_vld		(iob_int_ack_vld),
	    .iob_man_ack_packet		(iob_man_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
	    .iob_man_ack_vld		(iob_man_ack_vld),
	    .iob_man_int_packet		(iob_man_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
	    .iob_man_int_vld		(iob_man_int_vld),
	    .jbi_iob_mondo_data		(jbi_iob_mondo_data[`JBI_IOB_MONDO_BUS_WIDTH-1:0]),
	    .jbi_iob_mondo_vld		(jbi_iob_mondo_vld),
	    .jbi_iob_pio_data		(jbi_iob_pio_data[`JBI_IOB_WIDTH-1:0]),
	    .jbi_iob_pio_vld		(jbi_iob_pio_vld),
	    .jbi_iob_spi_data		(jbi_iob_spi_data[`SPI_IOB_WIDTH-1:0]),
	    .jbi_iob_spi_vld		(jbi_iob_spi_vld),
	    .mondo_busy_vec_f		(mondo_busy_vec_f[`IOB_CPUTHR_WIDTH-1:0]),
	    .rd_nack_packet		(rd_nack_packet[`UCB_NOPAY_PKT_WIDTH-1:0]),
	    .rd_nack_vld		(rd_nack_vld),
	    .rst_l			(rst_l),
	    .rx_sync			(rx_sync),
	    .srvc_wr_ack		(srvc_wr_ack),
	    .tap_iob_stall		(tap_iob_stall),
	    .tx_sync			(tx_sync),
	    .wr_ack_io_buf_din		(wr_ack_io_buf_din[`IOB_IO_BUF_WIDTH-1:0]));

   
   /*****************************************************************
    * IOB control
    *****************************************************************/
   /* iobdg_ctrl AUTO_TEMPLATE (
    // Inputs
    .clk               (jbus_rclk),
    .arst_l            (jbus_arst_l),
    ); */

   iobdg_ctrl iobdg_ctrl (.fuse_clk(efuse_rclk),
			  /*AUTOINST*/
			  // Outputs
			  .tap_mondo_acc_addr_s(tap_mondo_acc_addr_s[`IOB_ADDR_WIDTH-1:0]),
			  .tap_mondo_acc_seq_s(tap_mondo_acc_seq_s),
			  .tap_mondo_wr_s(tap_mondo_wr_s),
			  .tap_mondo_din_s(tap_mondo_din_s[63:0]),
			  .iob_man_ucb_buf_acpt(iob_man_ucb_buf_acpt),
			  .iob_int_ucb_buf_acpt(iob_int_ucb_buf_acpt),
			  .bounce_ucb_buf_acpt(bounce_ucb_buf_acpt),
			  .rd_nack_ucb_buf_acpt(rd_nack_ucb_buf_acpt),
			  .iob_man_int_vld(iob_man_int_vld),
			  .iob_man_int_packet(iob_man_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
			  .iob_man_ack_vld(iob_man_ack_vld),
			  .iob_man_ack_packet(iob_man_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
			  .iob_int_ack_vld(iob_int_ack_vld),
			  .iob_int_ack_packet(iob_int_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
			  .bounce_ack_vld(bounce_ack_vld),
			  .bounce_ack_packet(bounce_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
			  .rd_nack_vld	(rd_nack_vld),
			  .rd_nack_packet(rd_nack_packet[`UCB_NOPAY_PKT_WIDTH-1:0]),
			  .cpu_intman_acc(cpu_intman_acc),
			  .cpu_intctrl_acc(cpu_intctrl_acc),
			  .creg_intctrl_mask(creg_intctrl_mask),
			  .creg_jintv_vec(creg_jintv_vec[`IOB_INT_VEC_WIDTH-1:0]),
			  .first_availcore(first_availcore[`IOB_CPU_WIDTH-1:0]),
			  .iob_ctu_coreavail(iob_ctu_coreavail[`IOB_CPU_WIDTH-1:0]),
			  .int_vec_addr	(int_vec_addr[`IOB_INT_TAB_INDEX-1:0]),
			  .int_vec_din_raw(int_vec_din_raw[14:0]),
			  .int_vec_wr_l	(int_vec_wr_l),
			  .int_cpu_addr	(int_cpu_addr[`IOB_INT_TAB_INDEX-1:0]),
			  .int_cpu_din_raw(int_cpu_din_raw[14:0]),
			  .int_cpu_wr_l	(int_cpu_wr_l),
			  .creg_dbg_l2_vis_ctrl(creg_dbg_l2_vis_ctrl[63:0]),
			  .creg_dbg_l2_vis_maska_s(creg_dbg_l2_vis_maska_s[63:0]),
			  .creg_dbg_l2_vis_maskb_s(creg_dbg_l2_vis_maskb_s[63:0]),
			  .creg_dbg_l2_vis_cmpa_s(creg_dbg_l2_vis_cmpa_s[63:0]),
			  .creg_dbg_l2_vis_cmpb_s(creg_dbg_l2_vis_cmpb_s[63:0]),
			  .creg_dbg_l2_vis_trig_delay_s(creg_dbg_l2_vis_trig_delay_s[63:0]),
			  .creg_dbg_iob_vis_ctrl(creg_dbg_iob_vis_ctrl[63:0]),
			  .creg_dbg_enet_ctrl(creg_dbg_enet_ctrl[63:0]),
			  .creg_dbg_enet_idleval(creg_dbg_enet_idleval[63:0]),
			  .creg_dbg_jbus_ctrl(creg_dbg_jbus_ctrl[63:0]),
			  .creg_dbg_jbus_lo_mask0(creg_dbg_jbus_lo_mask0[63:0]),
			  .creg_dbg_jbus_lo_mask1(creg_dbg_jbus_lo_mask1[63:0]),
			  .creg_dbg_jbus_lo_cmp0(creg_dbg_jbus_lo_cmp0[63:0]),
			  .creg_dbg_jbus_lo_cmp1(creg_dbg_jbus_lo_cmp1[63:0]),
			  .creg_dbg_jbus_lo_cnt0(creg_dbg_jbus_lo_cnt0[63:0]),
			  .creg_dbg_jbus_lo_cnt1(creg_dbg_jbus_lo_cnt1[63:0]),
			  .creg_dbg_jbus_hi_mask0(creg_dbg_jbus_hi_mask0[63:0]),
			  .creg_dbg_jbus_hi_mask1(creg_dbg_jbus_hi_mask1[63:0]),
			  .creg_dbg_jbus_hi_cmp0(creg_dbg_jbus_hi_cmp0[63:0]),
			  .creg_dbg_jbus_hi_cmp1(creg_dbg_jbus_hi_cmp1[63:0]),
			  .creg_dbg_jbus_hi_cnt0(creg_dbg_jbus_hi_cnt0[63:0]),
			  .creg_dbg_jbus_hi_cnt1(creg_dbg_jbus_hi_cnt1[63:0]),
			  .creg_margin_16x65(creg_margin_16x65[4:0]),
			  // Inputs
			  .rst_l	(rst_l),
			  .arst_l	(jbus_arst_l),		 // Templated
			  .clk		(jbus_rclk),		 // Templated
			  .sehold	(sehold),
			  .tap_mondo_acc_addr_invld_d2_f(tap_mondo_acc_addr_invld_d2_f),
			  .tap_mondo_acc_seq_d2_f(tap_mondo_acc_seq_d2_f),
			  .tap_mondo_dout_d2_f(tap_mondo_dout_d2_f[63:0]),
			  .iob_man_ucb_sel(iob_man_ucb_sel),
			  .iob_int_ucb_sel(iob_int_ucb_sel),
			  .bounce_ucb_sel(bounce_ucb_sel),
			  .c2i_packet_vld(c2i_packet_vld),
			  .c2i_packet_is_rd_req(c2i_packet_is_rd_req),
			  .c2i_packet_is_wr_req(c2i_packet_is_wr_req),
			  .c2i_packet	(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
			  .rd_nack_ucb_sel(rd_nack_ucb_sel),
			  .c2i_rd_nack_packet(c2i_rd_nack_packet[`UCB_NOPAY_PKT_WIDTH-1:0]),
			  .iob_man_int_rd(iob_man_int_rd),
			  .iob_man_ack_rd(iob_man_ack_rd),
			  .iob_int_ack_rd(iob_int_ack_rd),
			  .bounce_ack_rd(bounce_ack_rd),
			  .rd_nack_rd	(rd_nack_rd),
			  .io_intman_addr(io_intman_addr[`IOB_INT_TAB_INDEX-1:0]),
			  .int_srvcd	(int_srvcd),
			  .int_srvcd_d1	(int_srvcd_d1),
			  .clspine_iob_resetstat_wr(clspine_iob_resetstat_wr),
			  .clspine_iob_resetstat(clspine_iob_resetstat[`IOB_RESET_STAT_WIDTH-1:0]),
			  .ctu_iob_wake_thr(ctu_iob_wake_thr),
			  .efc_iob_fuse_data(efc_iob_fuse_data),
			  .efc_iob_coreavail_dshift(efc_iob_coreavail_dshift),
			  .efc_iob_sernum0_dshift(efc_iob_sernum0_dshift),
			  .efc_iob_sernum1_dshift(efc_iob_sernum1_dshift),
			  .efc_iob_sernum2_dshift(efc_iob_sernum2_dshift),
			  .efc_iob_fusestat_dshift(efc_iob_fusestat_dshift),
			  .io_temp_trig	(io_temp_trig),
			  .int_vec_dout_raw(int_vec_dout_raw[14:0]),
			  .int_cpu_dout_raw(int_cpu_dout_raw[14:0]),
			  .l2_vis_armin	(l2_vis_armin));

   
   /*****************************************************************
    * IOB debug
    *****************************************************************/
   /* iobdg_dbg AUTO_TEMPLATE (
    // Inputs
    .cpu_clk           (cmp_rclk),
    .clk               (jbus_rclk),
    .cpu_rst_l	       (cmp_rst_l),
    ); */

   iobdg_dbg iobdg_dbg (/*AUTOINST*/
			// Outputs
			.iob_clk_l2_tr	(iob_clk_l2_tr),
			.iob_clk_tr	(iob_clk_tr),
			.iob_io_dbg_ck_n(iob_io_dbg_ck_n[2:0]),
			.iob_io_dbg_ck_p(iob_io_dbg_ck_p[2:0]),
			.iob_io_dbg_data(iob_io_dbg_data[39:0]),
			.iob_io_dbg_en	(iob_io_dbg_en),
			.iob_jbi_dbg_hi_data(iob_jbi_dbg_hi_data[47:0]),
			.iob_jbi_dbg_hi_vld(iob_jbi_dbg_hi_vld),
			.iob_jbi_dbg_lo_data(iob_jbi_dbg_lo_data[47:0]),
			.iob_jbi_dbg_lo_vld(iob_jbi_dbg_lo_vld),
			.l2_vis_armin	(l2_vis_armin),
			.l2_vis_buf_din_hi(l2_vis_buf_din_hi[64:0]),
			.l2_vis_buf_din_lo(l2_vis_buf_din_lo[64:0]),
			.l2_vis_buf_head_ptr(l2_vis_buf_head_ptr[`IOB_L2_VIS_BUF_INDEX-1:0]),
			.l2_vis_buf_rd_hi_l(l2_vis_buf_rd_hi_l),
			.l2_vis_buf_rd_lo_l(l2_vis_buf_rd_lo_l),
			.l2_vis_buf_tail_ptr(l2_vis_buf_tail_ptr[`IOB_L2_VIS_BUF_INDEX-1:0]),
			.l2_vis_buf_wr_hi_l(l2_vis_buf_wr_hi_l),
			.l2_vis_buf_wr_lo_l(l2_vis_buf_wr_lo_l),
			// Inputs
			.c2i_packet	(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
			.clk		(jbus_rclk),		 // Templated
			.clk_iob_data	(clk_iob_data[`CLK_IOB_WIDTH-1:0]),
			.clk_iob_stall	(clk_iob_stall),
			.clk_iob_vld	(clk_iob_vld),
			.cpu_clk	(cmp_rclk),		 // Templated
			.cpu_rst_l	(cmp_rst_l),		 // Templated
			.creg_dbg_enet_ctrl(creg_dbg_enet_ctrl[63:0]),
			.creg_dbg_enet_idleval(creg_dbg_enet_idleval[63:0]),
			.creg_dbg_iob_vis_ctrl(creg_dbg_iob_vis_ctrl[63:0]),
			.creg_dbg_jbus_ctrl(creg_dbg_jbus_ctrl[63:0]),
			.creg_dbg_jbus_hi_cmp0(creg_dbg_jbus_hi_cmp0[63:0]),
			.creg_dbg_jbus_hi_cmp1(creg_dbg_jbus_hi_cmp1[63:0]),
			.creg_dbg_jbus_hi_cnt0(creg_dbg_jbus_hi_cnt0[63:0]),
			.creg_dbg_jbus_hi_cnt1(creg_dbg_jbus_hi_cnt1[63:0]),
			.creg_dbg_jbus_hi_mask0(creg_dbg_jbus_hi_mask0[63:0]),
			.creg_dbg_jbus_hi_mask1(creg_dbg_jbus_hi_mask1[63:0]),
			.creg_dbg_jbus_lo_cmp0(creg_dbg_jbus_lo_cmp0[63:0]),
			.creg_dbg_jbus_lo_cmp1(creg_dbg_jbus_lo_cmp1[63:0]),
			.creg_dbg_jbus_lo_cnt0(creg_dbg_jbus_lo_cnt0[63:0]),
			.creg_dbg_jbus_lo_cnt1(creg_dbg_jbus_lo_cnt1[63:0]),
			.creg_dbg_jbus_lo_mask0(creg_dbg_jbus_lo_mask0[63:0]),
			.creg_dbg_jbus_lo_mask1(creg_dbg_jbus_lo_mask1[63:0]),
			.creg_dbg_l2_vis_cmpa_s(creg_dbg_l2_vis_cmpa_s[63:0]),
			.creg_dbg_l2_vis_cmpb_s(creg_dbg_l2_vis_cmpb_s[63:0]),
			.creg_dbg_l2_vis_ctrl(creg_dbg_l2_vis_ctrl[63:0]),
			.creg_dbg_l2_vis_maska_s(creg_dbg_l2_vis_maska_s[63:0]),
			.creg_dbg_l2_vis_maskb_s(creg_dbg_l2_vis_maskb_s[63:0]),
			.creg_dbg_l2_vis_trig_delay_s(creg_dbg_l2_vis_trig_delay_s[63:0]),
			.dbg_en_01	(dbg_en_01),
			.dbg_en_23	(dbg_en_23),
			.dram02_iob_data(dram02_iob_data[`DRAM_IOB_WIDTH-1:0]),
			.dram02_iob_stall(dram02_iob_stall),
			.dram02_iob_vld	(dram02_iob_vld),
			.dram13_iob_data(dram13_iob_data[`DRAM_IOB_WIDTH-1:0]),
			.dram13_iob_stall(dram13_iob_stall),
			.dram13_iob_vld	(dram13_iob_vld),
			.io_trigin	(io_trigin),
			.iob_clk_data	(iob_clk_data[`IOB_CLK_WIDTH-1:0]),
			.iob_clk_stall	(iob_clk_stall),
			.iob_clk_vld	(iob_clk_vld),
			.iob_dram02_data(iob_dram02_data[`IOB_DRAM_WIDTH-1:0]),
			.iob_dram02_stall(iob_dram02_stall),
			.iob_dram02_vld	(iob_dram02_vld),
			.iob_dram13_data(iob_dram13_data[`IOB_DRAM_WIDTH-1:0]),
			.iob_dram13_stall(iob_dram13_stall),
			.iob_dram13_vld	(iob_dram13_vld),
			.iob_jbi_pio_data(iob_jbi_pio_data[`IOB_JBI_WIDTH-1:0]),
			.iob_jbi_pio_stall(iob_jbi_pio_stall),
			.iob_jbi_pio_vld(iob_jbi_pio_vld),
			.iob_jbi_spi_data(iob_jbi_spi_data[`IOB_SPI_WIDTH-1:0]),
			.iob_jbi_spi_stall(iob_jbi_spi_stall),
			.iob_jbi_spi_vld(iob_jbi_spi_vld),
			.iob_tap_data	(iob_tap_data[`IOB_TAP_WIDTH-1:0]),
			.iob_tap_stall	(iob_tap_stall),
			.iob_tap_vld	(iob_tap_vld),
			.jbi_iob_pio_data(jbi_iob_pio_data[`JBI_IOB_WIDTH-1:0]),
			.jbi_iob_pio_stall(jbi_iob_pio_stall),
			.jbi_iob_pio_vld(jbi_iob_pio_vld),
			.jbi_iob_spi_data(jbi_iob_spi_data[`SPI_IOB_WIDTH-1:0]),
			.jbi_iob_spi_stall(jbi_iob_spi_stall),
			.jbi_iob_spi_vld(jbi_iob_spi_vld),
			.l2_dbgbus_01	(l2_dbgbus_01[39:0]),
			.l2_dbgbus_23	(l2_dbgbus_23[39:0]),
			.l2_vis_buf_dout_hi(l2_vis_buf_dout_hi[64:0]),
			.l2_vis_buf_dout_lo(l2_vis_buf_dout_lo[64:0]),
			.rst_l		(rst_l),
			.rx_sync	(rx_sync),
			.tap_iob_data	(tap_iob_data[`TAP_IOB_WIDTH-1:0]),
			.tap_iob_stall	(tap_iob_stall),
			.tap_iob_vld	(tap_iob_vld),
			.tx_sync	(tx_sync),
			.ucb_buf_acpt	(ucb_buf_acpt));

   
   /*****************************************************************
    * cpu-to-io cpu buffer
    *****************************************************************/
   /* bw_rf_16x65 AUTO_TEMPLATE (
    // Outputs
    .so                 (),
    .do                 (cpu_buf_dout_lo[64:0]),
    .listen_out         (),
    // Inputs
    .rd_clk             (jbus_rclk),
    .wr_clk             (cmp_rclk),
    .csn_rd             (cpu_buf_rd_l),
    .csn_wr             (cpu_buf_wr_l),
    .hold               (sehold),
    .scan_en            (se),
    .margin             (creg_margin_16x65),
    .rd_a               (cpu_buf_head_ptr[3:0]),
    .wr_a               (cpu_buf_tail_ptr[3:0]),
    .di                 (cpu_buf_din_lo[64:0]),
    .si                 (),
    .testmux_sel        (mem_bypass),
    ); */

   bw_rf_16x65 cpu_buf_lo (/*AUTOINST*/
			   // Outputs
			   .so		(),			 // Templated
			   .do		(cpu_buf_dout_lo[64:0]), // Templated
			   .listen_out	(),			 // Templated
			   // Inputs
			   .rd_clk	(jbus_rclk),		 // Templated
			   .wr_clk	(cmp_rclk),		 // Templated
			   .csn_rd	(cpu_buf_rd_l),		 // Templated
			   .csn_wr	(cpu_buf_wr_l),		 // Templated
			   .hold	(sehold),		 // Templated
			   .testmux_sel	(mem_bypass),		 // Templated
			   .scan_en	(se),			 // Templated
			   .margin	(creg_margin_16x65),	 // Templated
			   .rd_a	(cpu_buf_head_ptr[3:0]), // Templated
			   .wr_a	(cpu_buf_tail_ptr[3:0]), // Templated
			   .di		(cpu_buf_din_lo[64:0]),	 // Templated
			   .si		());			 // Templated

   /* bw_rf_16x65 AUTO_TEMPLATE (
    // Outputs
    .so                 (),
    .do                 (cpu_buf_dout_hi[64:0]),
    .listen_out         (),
    // Inputs
    .rd_clk             (jbus_rclk),
    .wr_clk             (cmp_rclk),
    .csn_rd             (cpu_buf_rd_l),
    .csn_wr             (cpu_buf_wr_l),
    .hold               (sehold),
    .scan_en            (se),
    .margin             (creg_margin_16x65),
    .rd_a               (cpu_buf_head_ptr[3:0]),
    .wr_a               (cpu_buf_tail_ptr[3:0]),
    .di                 (cpu_buf_din_hi[64:0]),
    .si                 (),
    .testmux_sel        (mem_bypass),
    ); */

   bw_rf_16x65 cpu_buf_hi (/*AUTOINST*/
			   // Outputs
			   .so		(),			 // Templated
			   .do		(cpu_buf_dout_hi[64:0]), // Templated
			   .listen_out	(),			 // Templated
			   // Inputs
			   .rd_clk	(jbus_rclk),		 // Templated
			   .wr_clk	(cmp_rclk),		 // Templated
			   .csn_rd	(cpu_buf_rd_l),		 // Templated
			   .csn_wr	(cpu_buf_wr_l),		 // Templated
			   .hold	(sehold),		 // Templated
			   .testmux_sel	(mem_bypass),		 // Templated
			   .scan_en	(se),			 // Templated
			   .margin	(creg_margin_16x65),	 // Templated
			   .rd_a	(cpu_buf_head_ptr[3:0]), // Templated
			   .wr_a	(cpu_buf_tail_ptr[3:0]), // Templated
			   .di		(cpu_buf_din_hi[64:0]),	 // Templated
			   .si		());			 // Templated


   /*****************************************************************
    * io-to-cpu interrupt/mondo read result buffer
    *****************************************************************/
   /* iobdg_1r1w_rf16x160 AUTO_TEMPLATE (
    // Outputs
    .dout		(int_buf_dout_raw[159:0]),
    .so_r	        (),
    .so_w	        (),
    // Inputs
    .din		(int_buf_din_raw[159:0]),
    .rd_adr	        (int_buf_head_ptr[`IOB_INT_BUF_INDEX-1:0]),
    .wr_adr	        (int_buf_tail_ptr[`IOB_INT_BUF_INDEX-1:0]),
    .read_en	        (1'b1),
    .wr_en	        (int_buf_wr),
    .rst_tri_en	        (rst_tri_en),
    .word_wen	        (4'hf),
    .byte_wen	        (20'hfffff),
    .rd_clk		(cmp_rclk),
    .wr_clk		(cmp_rclk),
    .se		        (se),
    .si_r	        (),
    .si_w	        (),
    .reset_l	        (cmp_arst_l),
    .sehold	        (sehold),
    .testmux_sel        (mem_bypass),
    ); */

   iobdg_1r1w_rf16x160 int_buf (/*AUTOINST*/
				// Outputs
				.so_r	(),			 // Templated
				.so_w	(),			 // Templated
				.dout	(int_buf_dout_raw[159:0]), // Templated
				// Inputs
				.byte_wen(20'hfffff),		 // Templated
				.din	(int_buf_din_raw[159:0]), // Templated
				.rd_adr	(int_buf_head_ptr[`IOB_INT_BUF_INDEX-1:0]), // Templated
				.rd_clk	(cmp_rclk),		 // Templated
				.read_en(1'b1),			 // Templated
				.reset_l(cmp_arst_l),		 // Templated
				.rst_tri_en(rst_tri_en),	 // Templated
				.se	(se),			 // Templated
				.sehold	(sehold),		 // Templated
				.si_r	(),			 // Templated
				.si_w	(),			 // Templated
				.word_wen(4'hf),		 // Templated
				.wr_adr	(int_buf_tail_ptr[`IOB_INT_BUF_INDEX-1:0]), // Templated
				.wr_clk	(cmp_rclk),		 // Templated
				.wr_en	(int_buf_wr),		 // Templated
				.testmux_sel(mem_bypass));	 // Templated

   
   /*****************************************************************
    * io-to-cpu io buffer
    *****************************************************************/
   /* iobdg_1r1w_rf16x160 AUTO_TEMPLATE (
    // Outputs
    .dout		(io_buf_dout_raw[159:0]),
    .so_r	        (),
    .so_w	        (),
    // Inputs
    .din		(io_buf_din_raw[159:0]),
    .rd_adr	        (io_buf_head_ptr[`IOB_IO_BUF_INDEX-1:0]),
    .wr_adr	        (io_buf_tail_ptr[`IOB_IO_BUF_INDEX-1:0]),
    .read_en	        (1'b1),
    .wr_en	        (io_buf_wr),
    .rst_tri_en	        (rst_tri_en),
    .word_wen	        (4'hf),
    .byte_wen	        (20'hfffff),
    .rd_clk		(cmp_rclk),
    .wr_clk		(jbus_rclk),
    .se		        (se),
    .si_r	        (),
    .si_w	        (),
    .reset_l	        (cmp_arst_l),
    .sehold	        (sehold),
    .testmux_sel        (mem_bypass),
    ); */

   iobdg_1r1w_rf16x160 io_buf (/*AUTOINST*/
			       // Outputs
			       .so_r	(),			 // Templated
			       .so_w	(),			 // Templated
			       .dout	(io_buf_dout_raw[159:0]), // Templated
			       // Inputs
			       .byte_wen(20'hfffff),		 // Templated
			       .din	(io_buf_din_raw[159:0]), // Templated
			       .rd_adr	(io_buf_head_ptr[`IOB_IO_BUF_INDEX-1:0]), // Templated
			       .rd_clk	(cmp_rclk),		 // Templated
			       .read_en	(1'b1),			 // Templated
			       .reset_l	(cmp_arst_l),		 // Templated
			       .rst_tri_en(rst_tri_en),		 // Templated
			       .se	(se),			 // Templated
			       .sehold	(sehold),		 // Templated
			       .si_r	(),			 // Templated
			       .si_w	(),			 // Templated
			       .word_wen(4'hf),			 // Templated
			       .wr_adr	(io_buf_tail_ptr[`IOB_IO_BUF_INDEX-1:0]), // Templated
			       .wr_clk	(jbus_rclk),		 // Templated
			       .wr_en	(io_buf_wr),		 // Templated
			       .testmux_sel(mem_bypass));	 // Templated

   
   /*****************************************************************
    * Interrupt vector table
    *****************************************************************/
   // Only one port is needed.  Tie both read and write address to same.
   /* iobdg_1r1w_rf4 AUTO_TEMPLATE (
    // Outputs
    .dout               (int_vec_dout_raw[14:0]),
    // Inputs
    .rd_clk             (jbus_rclk),
    .wr_clk             (jbus_rclk),
    .rd_a               (int_vec_addr[`IOB_INT_TAB_INDEX-1:0]),
    .wr_a               (int_vec_addr[`IOB_INT_TAB_INDEX-1:0]),
    .din                (int_vec_din_raw[14:0]),
    .wen_l              (int_vec_wr_l),
    ); */

   iobdg_1r1w_rf4 #(15) int_vec_stat (/*AUTOINST*/
				      // Outputs
				      .dout(int_vec_dout_raw[14:0]), // Templated
				      // Inputs
				      .rd_clk(jbus_rclk),	 // Templated
				      .wr_clk(jbus_rclk),	 // Templated
				      .rd_a(int_vec_addr[`IOB_INT_TAB_INDEX-1:0]), // Templated
				      .wr_a(int_vec_addr[`IOB_INT_TAB_INDEX-1:0]), // Templated
				      .din(int_vec_din_raw[14:0]), // Templated
				      .wen_l(int_vec_wr_l));	 // Templated
   
	
   /*****************************************************************
    * Interrupt cpu table
    *****************************************************************/
   // Only one port is needed.  Tie both read and write address to same.
   /* iobdg_1r1w_rf4 AUTO_TEMPLATE (
    // Outputs
    .dout               (int_cpu_dout_raw[14:0]),
    // Inputs
    .rd_clk             (jbus_rclk),
    .wr_clk             (jbus_rclk),
    .rd_a               (int_cpu_addr[`IOB_INT_TAB_INDEX-1:0]),
    .wr_a               (int_cpu_addr[`IOB_INT_TAB_INDEX-1:0]),
    .din                (int_cpu_din_raw[14:0]),
    .wen_l              (int_cpu_wr_l),
    ); */

   iobdg_1r1w_rf4 #(15) int_cpu_stat (/*AUTOINST*/
				      // Outputs
				      .dout(int_cpu_dout_raw[14:0]), // Templated
				      // Inputs
				      .rd_clk(jbus_rclk),	 // Templated
				      .wr_clk(jbus_rclk),	 // Templated
				      .rd_a(int_cpu_addr[`IOB_INT_TAB_INDEX-1:0]), // Templated
				      .wr_a(int_cpu_addr[`IOB_INT_TAB_INDEX-1:0]), // Templated
				      .din(int_cpu_din_raw[14:0]), // Templated
				      .wen_l(int_cpu_wr_l));	 // Templated

   
   /*****************************************************************
    * Mondo data0 table
    *****************************************************************/
   /* bw_rf_16x65 AUTO_TEMPLATE (
    // Outputs
    .so                 (),
    .do                 (mondo_data0_dout_lo[64:0]),
    .listen_out         (),
    // Inputs
    .rd_clk             (cmp_rclk),
    .wr_clk             (cmp_rclk),
    .csn_rd             (1'b0),
    .csn_wr             (mondo_data0_wr_lo_l),
    .hold               (sehold),
    .scan_en            (se),
    .margin             (creg_margin_16x65),
    .rd_a               (mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-2:0]),
    .wr_a               (mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-2:0]),
    .di                 (mondo_data0_din_lo[64:0]),
    .si                 (),
    .testmux_sel        (mem_bypass),
    ); */

   bw_rf_16x65 #(1,1,1) mondo_data0_lo (/*AUTOINST*/
					// Outputs
					.so(),			 // Templated
					.do(mondo_data0_dout_lo[64:0]), // Templated
					.listen_out(),		 // Templated
					// Inputs
					.rd_clk(cmp_rclk),	 // Templated
					.wr_clk(cmp_rclk),	 // Templated
					.csn_rd(1'b0),		 // Templated
					.csn_wr(mondo_data0_wr_lo_l), // Templated
					.hold(sehold),		 // Templated
					.testmux_sel(mem_bypass), // Templated
					.scan_en(se),		 // Templated
					.margin(creg_margin_16x65), // Templated
					.rd_a(mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-2:0]), // Templated
					.wr_a(mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-2:0]), // Templated
					.di(mondo_data0_din_lo[64:0]), // Templated
					.si());			 // Templated

   
   /* bw_rf_16x65 AUTO_TEMPLATE (
    // Outputs
    .so                 (),
    .do                 (mondo_data0_dout_hi[64:0]),
    .listen_out         (),
    // Inputs
    .rd_clk             (cmp_rclk),
    .wr_clk             (cmp_rclk),
    .csn_rd             (1'b0),
    .csn_wr             (mondo_data0_wr_hi_l),
    .hold               (sehold),
    .scan_en            (se),
    .margin             (creg_margin_16x65),
    .rd_a               (mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-2:0]),
    .wr_a               (mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-2:0]),
    .di                 (mondo_data0_din_hi[64:0]),
    .si                 (),
    .testmux_sel        (mem_bypass),
    ); */

   bw_rf_16x65 #(1,1,1) mondo_data0_hi (/*AUTOINST*/
					// Outputs
					.so(),			 // Templated
					.do(mondo_data0_dout_hi[64:0]), // Templated
					.listen_out(),		 // Templated
					// Inputs
					.rd_clk(cmp_rclk),	 // Templated
					.wr_clk(cmp_rclk),	 // Templated
					.csn_rd(1'b0),		 // Templated
					.csn_wr(mondo_data0_wr_hi_l), // Templated
					.hold(sehold),		 // Templated
					.testmux_sel(mem_bypass), // Templated
					.scan_en(se),		 // Templated
					.margin(creg_margin_16x65), // Templated
					.rd_a(mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-2:0]), // Templated
					.wr_a(mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-2:0]), // Templated
					.di(mondo_data0_din_hi[64:0]), // Templated
					.si());			 // Templated

   
   /*****************************************************************
    * Mondo data1 table
    *****************************************************************/
   /* bw_rf_16x65 AUTO_TEMPLATE (
    // Outputs
    .so                 (),
    .do                 (mondo_data1_dout_lo[64:0]),
    .listen_out         (),
    // Inputs
    .rd_clk             (cmp_rclk),
    .wr_clk             (cmp_rclk),
    .csn_rd             (1'b0),
    .csn_wr             (mondo_data1_wr_lo_l),
    .hold               (sehold),
    .scan_en            (se),
    .margin             (creg_margin_16x65),
    .rd_a               (mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-2:0]),
    .wr_a               (mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-2:0]),
    .di                 (mondo_data1_din_lo[64:0]),
    .si                 (),
    .testmux_sel        (mem_bypass),
    ); */

   bw_rf_16x65 #(1,1,1) mondo_data1_lo (/*AUTOINST*/
					// Outputs
					.so(),			 // Templated
					.do(mondo_data1_dout_lo[64:0]), // Templated
					.listen_out(),		 // Templated
					// Inputs
					.rd_clk(cmp_rclk),	 // Templated
					.wr_clk(cmp_rclk),	 // Templated
					.csn_rd(1'b0),		 // Templated
					.csn_wr(mondo_data1_wr_lo_l), // Templated
					.hold(sehold),		 // Templated
					.testmux_sel(mem_bypass), // Templated
					.scan_en(se),		 // Templated
					.margin(creg_margin_16x65), // Templated
					.rd_a(mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-2:0]), // Templated
					.wr_a(mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-2:0]), // Templated
					.di(mondo_data1_din_lo[64:0]), // Templated
					.si());			 // Templated

   /* bw_rf_16x65 AUTO_TEMPLATE (
    // Outputs
    .so                 (),
    .do                 (mondo_data1_dout_hi[64:0]),
    .listen_out         (),
    // Inputs
    .rd_clk             (cmp_rclk),
    .wr_clk             (cmp_rclk),
    .csn_rd             (1'b0),
    .csn_wr             (mondo_data1_wr_hi_l),
    .hold               (sehold),
    .scan_en            (se),
    .margin             (creg_margin_16x65),
    .rd_a               (mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-2:0]),
    .wr_a               (mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-2:0]),
    .di                 (mondo_data1_din_hi[64:0]),
    .si                 (),
    .testmux_sel        (mem_bypass),
    ); */

   bw_rf_16x65 #(1,1,1) mondo_data1_hi (/*AUTOINST*/
					// Outputs
					.so(),			 // Templated
					.do(mondo_data1_dout_hi[64:0]), // Templated
					.listen_out(),		 // Templated
					// Inputs
					.rd_clk(cmp_rclk),	 // Templated
					.wr_clk(cmp_rclk),	 // Templated
					.csn_rd(1'b0),		 // Templated
					.csn_wr(mondo_data1_wr_hi_l), // Templated
					.hold(sehold),		 // Templated
					.testmux_sel(mem_bypass), // Templated
					.scan_en(se),		 // Templated
					.margin(creg_margin_16x65), // Templated
					.rd_a(mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-2:0]), // Templated
					.wr_a(mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-2:0]), // Templated
					.di(mondo_data1_din_hi[64:0]), // Templated
					.si());			 // Templated

   
   /*****************************************************************
    * Mondo source table
    *****************************************************************/
   /* iobdg_1r1w_rf32 AUTO_TEMPLATE (
    // Outputs
    .dout	        (mondo_source_dout[`IOB_MONDO_SRC_WIDTH-1:0]),
    // Inputs
    .rd_a	        (mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-1:0]),
    .wr_a	        (mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-1:0]),
    .din                (mondo_source_din[`IOB_MONDO_SRC_WIDTH-1:0]),
    .rd_clk             (cmp_rclk),
    .wr_clk             (cmp_rclk),
    .wen_l              (mondo_source_wr_l),
    ); */

   iobdg_1r1w_rf32 #(`IOB_MONDO_SRC_WIDTH) mondo_source (/*AUTOINST*/
							 // Outputs
							 .dout(mondo_source_dout[`IOB_MONDO_SRC_WIDTH-1:0]), // Templated
							 // Inputs
							 .rd_clk(cmp_rclk), // Templated
							 .wr_clk(cmp_rclk), // Templated
							 .rd_a(mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-1:0]), // Templated
							 .wr_a(mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-1:0]), // Templated
							 .din(mondo_source_din[`IOB_MONDO_SRC_WIDTH-1:0]), // Templated
							 .wen_l(mondo_source_wr_l)); // Templated
   
	
   /*****************************************************************
    * Mondo busy table
    *****************************************************************/
   /* iobdg_1r2w_vec AUTO_TEMPLATE (
    // Outputs
    .dout	        (mondo_busy_dout),
    .dout_vec           (mondo_busy_vec_f[`IOB_CPUTHR_WIDTH-1:0]),
    // Inputs
    .rd_a	        (mondo_busy_addr_p0[`IOB_MONDO_DATA_INDEX-1:0]),
    .wr1_a	        (mondo_busy_addr_p1[`IOB_MONDO_DATA_INDEX-1:0]),
    .wr2_a	        (mondo_busy_addr_p2[`IOB_MONDO_DATA_INDEX-1:0]),
    .din1               (mondo_busy_din_p1),
    .din2               (mondo_busy_din_p2),
    .clk                (cmp_rclk),
    .rst_l              (cmp_rst_l),
    .wen1               (mondo_busy_wr_p1),
    .wen2               (mondo_busy_wr_p2), 
    .tx_en              (tx_sync),
    ); */

   iobdg_1r2w_vec #(`IOB_CPUTHR_WIDTH,`IOB_CPUTHR_INDEX) mondo_busy (/*AUTOINST*/
								     // Outputs
								     .dout(mondo_busy_dout), // Templated
								     .dout_vec(mondo_busy_vec_f[`IOB_CPUTHR_WIDTH-1:0]), // Templated
								     // Inputs
								     .clk(cmp_rclk), // Templated
								     .rst_l(cmp_rst_l), // Templated
								     .tx_en(tx_sync), // Templated
								     .rd_a(mondo_busy_addr_p0[`IOB_MONDO_DATA_INDEX-1:0]), // Templated
								     .wr1_a(mondo_busy_addr_p1[`IOB_MONDO_DATA_INDEX-1:0]), // Templated
								     .wr2_a(mondo_busy_addr_p2[`IOB_MONDO_DATA_INDEX-1:0]), // Templated
								     .din1(mondo_busy_din_p1), // Templated
								     .din2(mondo_busy_din_p2), // Templated
								     .wen1(mondo_busy_wr_p1), // Templated
								     .wen2(mondo_busy_wr_p2)); // Templated
   
	
   /*****************************************************************
    * L2 Debug Buffer
    *****************************************************************/
   /* bw_rf_16x65 AUTO_TEMPLATE (
    // Outputs
    .so                 (),
    .do                 (l2_vis_buf_dout_lo[64:0]),
    .listen_out         (),
    // Inputs
    .rd_clk             (jbus_rclk),
    .wr_clk             (cmp_rclk),
    .csn_rd             (l2_vis_buf_rd_lo_l),
    .csn_wr             (l2_vis_buf_wr_lo_l),
    .hold               (sehold),
    .scan_en            (se),
    .margin             (creg_margin_16x65),
    .rd_a               (l2_vis_buf_head_ptr[`IOB_L2_VIS_BUF_INDEX-2:0]),
    .wr_a               (l2_vis_buf_tail_ptr[`IOB_L2_VIS_BUF_INDEX-2:0]),
    .di                 (l2_vis_buf_din_lo[64:0]),
    .si                 (),
    .testmux_sel        (mem_bypass),
    ); */

   bw_rf_16x65 l2_vis_buf_lo (/*AUTOINST*/
			      // Outputs
			      .so	(),			 // Templated
			      .do	(l2_vis_buf_dout_lo[64:0]), // Templated
			      .listen_out(),			 // Templated
			      // Inputs
			      .rd_clk	(jbus_rclk),		 // Templated
			      .wr_clk	(cmp_rclk),		 // Templated
			      .csn_rd	(l2_vis_buf_rd_lo_l),	 // Templated
			      .csn_wr	(l2_vis_buf_wr_lo_l),	 // Templated
			      .hold	(sehold),		 // Templated
			      .testmux_sel(mem_bypass),		 // Templated
			      .scan_en	(se),			 // Templated
			      .margin	(creg_margin_16x65),	 // Templated
			      .rd_a	(l2_vis_buf_head_ptr[`IOB_L2_VIS_BUF_INDEX-2:0]), // Templated
			      .wr_a	(l2_vis_buf_tail_ptr[`IOB_L2_VIS_BUF_INDEX-2:0]), // Templated
			      .di	(l2_vis_buf_din_lo[64:0]), // Templated
			      .si	());			 // Templated

   /* bw_rf_16x65 AUTO_TEMPLATE (
    // Outputs
    .so                 (),
    .do                 (l2_vis_buf_dout_hi[64:0]),
    .listen_out         (),
    // Inputs
    .rd_clk             (jbus_rclk),
    .wr_clk             (cmp_rclk),
    .csn_rd             (l2_vis_buf_rd_hi_l),
    .csn_wr             (l2_vis_buf_wr_hi_l),
    .hold               (sehold),
    .scan_en            (se),
    .margin             (creg_margin_16x65),
    .rd_a               (l2_vis_buf_head_ptr[`IOB_L2_VIS_BUF_INDEX-2:0]),
    .wr_a               (l2_vis_buf_tail_ptr[`IOB_L2_VIS_BUF_INDEX-2:0]),
    .di                 (l2_vis_buf_din_hi[64:0]),
    .si                 (),
    .testmux_sel        (mem_bypass),
    ); */

   bw_rf_16x65 l2_vis_buf_hi (/*AUTOINST*/
			      // Outputs
			      .so	(),			 // Templated
			      .do	(l2_vis_buf_dout_hi[64:0]), // Templated
			      .listen_out(),			 // Templated
			      // Inputs
			      .rd_clk	(jbus_rclk),		 // Templated
			      .wr_clk	(cmp_rclk),		 // Templated
			      .csn_rd	(l2_vis_buf_rd_hi_l),	 // Templated
			      .csn_wr	(l2_vis_buf_wr_hi_l),	 // Templated
			      .hold	(sehold),		 // Templated
			      .testmux_sel(mem_bypass),		 // Templated
			      .scan_en	(se),			 // Templated
			      .margin	(creg_margin_16x65),	 // Templated
			      .rd_a	(l2_vis_buf_head_ptr[`IOB_L2_VIS_BUF_INDEX-2:0]), // Templated
			      .wr_a	(l2_vis_buf_tail_ptr[`IOB_L2_VIS_BUF_INDEX-2:0]), // Templated
			      .di	(l2_vis_buf_din_hi[64:0]), // Templated
			      .si	());			 // Templated

   
endmodule // iobdg


// Local Variables:
// verilog-library-directories:("." "../../common/rtl" "../../srams/rtl" "../common/rtl" "../c2i/rtl" "../i2c/rtl" "../iobdg_ctrl/rtl" "../iobdg_dbg/rtl")
// End:


