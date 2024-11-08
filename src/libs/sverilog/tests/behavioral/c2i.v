// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: c2i.v
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
//  Module Name:	c2i (cpu-to-io)
//  Description:	This module handles data coming from the
//                      crossbar, tap, pmb and going to the IO.
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

////////////////////////////////////////////////////////////////////////
// Interface signal list declarations
////////////////////////////////////////////////////////////////////////
module c2i (/*AUTOARG*/
   // Outputs
   wr_ack_io_buf_din, ucb_buf_acpt, tap_mondo_dout_d2_f, 
   tap_mondo_acc_seq_d2_f, tap_mondo_acc_addr_invld_d2_f, 
   srvc_wr_ack, rd_nack_ucb_sel, mondo_source_wr_l, mondo_source_din, 
   mondo_data_addr_p1, mondo_data_addr_p0, mondo_data1_wr_lo_l, 
   mondo_data1_wr_hi_l, mondo_data1_din_lo, mondo_data1_din_hi, 
   mondo_data0_wr_lo_l, mondo_data0_wr_hi_l, mondo_data0_din_lo, 
   mondo_data0_din_hi, mondo_busy_wr_p2, mondo_busy_wr_p1, 
   mondo_busy_din_p2, mondo_busy_din_p1, mondo_busy_addr_p2, 
   mondo_busy_addr_p1, mondo_busy_addr_p0, iob_tap_stall, 
   iob_pcx_stall_pq, iob_man_ucb_sel, iob_jbi_spi_vld, 
   iob_jbi_spi_data, iob_jbi_pio_vld, iob_jbi_pio_data, 
   iob_int_ucb_sel, iob_dram13_vld, iob_dram13_data, iob_dram02_vld, 
   iob_dram02_data, iob_clk_vld, iob_clk_data, int_buf_din_raw, 
   cpu_mondo_wr_d2, cpu_buf_wr_l, cpu_buf_tail_ptr, cpu_buf_rd_l, 
   cpu_buf_head_ptr, cpu_buf_din_lo, cpu_buf_din_hi, 
   c2i_rd_nack_packet, c2i_packet_is_wr_req, c2i_packet_is_rd_req, 
   bounce_ucb_sel, cpu_mondo_rd_d2, c2i_packet, c2i_packet_vld, 
   // Inputs
   tx_sync, tap_mondo_wr_s, tap_mondo_din_s, tap_mondo_acc_seq_s, 
   tap_mondo_acc_addr_s, tap_iob_vld, tap_iob_data, rx_sync, rst_l, 
   rd_nack_ucb_buf_acpt, pcx_iob_data_rdy_px2, pcx_iob_data_px2, 
   mondo_source_dout, mondo_data1_dout_lo, mondo_data1_dout_hi, 
   mondo_data0_dout_lo, mondo_data0_dout_hi, mondo_busy_dout, 
   jbi_iob_spi_stall, jbi_iob_pio_stall, iob_man_ucb_buf_acpt, 
   iob_int_ucb_buf_acpt, io_mondo_source_din_s, io_mondo_data_wr_s, 
   io_mondo_data_wr_addr_s, io_mondo_data1_din_s, 
   io_mondo_data0_din_s, io_buf_avail, int_buf_hit_hwm, 
   dram13_iob_stall, dram02_iob_stall, cpu_rst_l, cpu_clk, 
   cpu_buf_dout_lo, cpu_buf_dout_hi, clk_iob_stall, clk, 
   bounce_ucb_buf_acpt
   );

   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		bounce_ucb_buf_acpt;	// To c2i_sctrl of c2i_sctrl.v
   input		clk;			// To c2i_sctrl of c2i_sctrl.v, ...
   input		clk_iob_stall;		// To clk_ucb_buf of c2i_buf.v
   input [64:0]		cpu_buf_dout_hi;	// To c2i_sdp of c2i_sdp.v
   input [64:0]		cpu_buf_dout_lo;	// To c2i_sdp of c2i_sdp.v
   input		cpu_clk;		// To c2i_fctrl of c2i_fctrl.v, ...
   input		cpu_rst_l;		// To c2i_fctrl of c2i_fctrl.v
   input		dram02_iob_stall;	// To dram0_ucb_buf of c2i_buf.v
   input		dram13_iob_stall;	// To dram1_ucb_buf of c2i_buf.v
   input		int_buf_hit_hwm;	// To c2i_fctrl of c2i_fctrl.v
   input		io_buf_avail;		// To c2i_sctrl of c2i_sctrl.v
   input [`IOB_MONDO_DATA_WIDTH-1:0]io_mondo_data0_din_s;// To c2i_fdp of c2i_fdp.v
   input [`IOB_MONDO_DATA_WIDTH-1:0]io_mondo_data1_din_s;// To c2i_fdp of c2i_fdp.v
   input [`IOB_MONDO_DATA_INDEX-1:0]io_mondo_data_wr_addr_s;// To c2i_fctrl of c2i_fctrl.v
   input		io_mondo_data_wr_s;	// To c2i_fctrl of c2i_fctrl.v
   input [`IOB_MONDO_SRC_WIDTH-1:0]io_mondo_source_din_s;// To c2i_fdp of c2i_fdp.v
   input		iob_int_ucb_buf_acpt;	// To c2i_sctrl of c2i_sctrl.v
   input		iob_man_ucb_buf_acpt;	// To c2i_sctrl of c2i_sctrl.v
   input		jbi_iob_pio_stall;	// To jbi_ucb_buf of c2i_buf.v
   input		jbi_iob_spi_stall;	// To spi_ucb_buf of c2i_buf.v
   input		mondo_busy_dout;	// To c2i_fdp of c2i_fdp.v
   input [64:0]		mondo_data0_dout_hi;	// To c2i_fdp of c2i_fdp.v
   input [64:0]		mondo_data0_dout_lo;	// To c2i_fdp of c2i_fdp.v
   input [64:0]		mondo_data1_dout_hi;	// To c2i_fdp of c2i_fdp.v
   input [64:0]		mondo_data1_dout_lo;	// To c2i_fdp of c2i_fdp.v
   input [`IOB_MONDO_SRC_WIDTH-1:0]mondo_source_dout;// To c2i_fdp of c2i_fdp.v
   input [`PCX_WIDTH-1:0]pcx_iob_data_px2;	// To c2i_fdp of c2i_fdp.v
   input		pcx_iob_data_rdy_px2;	// To c2i_fctrl of c2i_fctrl.v
   input		rd_nack_ucb_buf_acpt;	// To c2i_sctrl of c2i_sctrl.v
   input		rst_l;			// To c2i_sctrl of c2i_sctrl.v, ...
   input		rx_sync;		// To c2i_fctrl of c2i_fctrl.v, ...
   input [`TAP_IOB_WIDTH-1:0]tap_iob_data;	// To tap_ucb_buf of ucb_bus_in.v
   input		tap_iob_vld;		// To tap_ucb_buf of ucb_bus_in.v
   input [`IOB_ADDR_WIDTH-1:0]tap_mondo_acc_addr_s;// To c2i_fctrl of c2i_fctrl.v
   input		tap_mondo_acc_seq_s;	// To c2i_fctrl of c2i_fctrl.v
   input [63:0]		tap_mondo_din_s;	// To c2i_fdp of c2i_fdp.v
   input		tap_mondo_wr_s;		// To c2i_fctrl of c2i_fctrl.v
   input		tx_sync;		// To c2i_fctrl of c2i_fctrl.v, ...
   // End of automatics


   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		bounce_ucb_sel;		// From c2i_sctrl of c2i_sctrl.v
   output		c2i_packet_is_rd_req;	// From c2i_sctrl of c2i_sctrl.v
   output		c2i_packet_is_wr_req;	// From c2i_sctrl of c2i_sctrl.v
   output [`UCB_NOPAY_PKT_WIDTH-1:0]c2i_rd_nack_packet;// From c2i_sdp of c2i_sdp.v
   output [64:0]	cpu_buf_din_hi;		// From c2i_fdp of c2i_fdp.v
   output [64:0]	cpu_buf_din_lo;		// From c2i_fdp of c2i_fdp.v
   output [`IOB_CPU_BUF_INDEX-1:0]cpu_buf_head_ptr;// From c2i_sctrl of c2i_sctrl.v
   output		cpu_buf_rd_l;		// From c2i_sctrl of c2i_sctrl.v
   output [`IOB_CPU_BUF_INDEX-1:0]cpu_buf_tail_ptr;// From c2i_fctrl of c2i_fctrl.v
   output		cpu_buf_wr_l;		// From c2i_fctrl of c2i_fctrl.v
   output		cpu_mondo_wr_d2;	// From c2i_fctrl of c2i_fctrl.v
   output [159:0]	int_buf_din_raw;	// From c2i_fdp of c2i_fdp.v
   output [`IOB_CLK_WIDTH-1:0]iob_clk_data;	// From clk_ucb_buf of c2i_buf.v
   output		iob_clk_vld;		// From clk_ucb_buf of c2i_buf.v
   output [`IOB_DRAM_WIDTH-1:0]iob_dram02_data;	// From dram0_ucb_buf of c2i_buf.v
   output		iob_dram02_vld;		// From dram0_ucb_buf of c2i_buf.v
   output [`IOB_DRAM_WIDTH-1:0]iob_dram13_data;	// From dram1_ucb_buf of c2i_buf.v
   output		iob_dram13_vld;		// From dram1_ucb_buf of c2i_buf.v
   output		iob_int_ucb_sel;	// From c2i_sctrl of c2i_sctrl.v
   output [`IOB_JBI_WIDTH-1:0]iob_jbi_pio_data;	// From jbi_ucb_buf of c2i_buf.v
   output		iob_jbi_pio_vld;	// From jbi_ucb_buf of c2i_buf.v
   output [`IOB_SPI_WIDTH-1:0]iob_jbi_spi_data;	// From spi_ucb_buf of c2i_buf.v
   output		iob_jbi_spi_vld;	// From spi_ucb_buf of c2i_buf.v
   output		iob_man_ucb_sel;	// From c2i_sctrl of c2i_sctrl.v
   output		iob_pcx_stall_pq;	// From c2i_fctrl of c2i_fctrl.v
   output		iob_tap_stall;		// From tap_ucb_buf of ucb_bus_in.v
   output [`IOB_MONDO_DATA_INDEX-1:0]mondo_busy_addr_p0;// From c2i_fctrl of c2i_fctrl.v
   output [`IOB_MONDO_DATA_INDEX-1:0]mondo_busy_addr_p1;// From c2i_fctrl of c2i_fctrl.v
   output [`IOB_MONDO_DATA_INDEX-1:0]mondo_busy_addr_p2;// From c2i_fctrl of c2i_fctrl.v
   output		mondo_busy_din_p1;	// From c2i_fdp of c2i_fdp.v
   output		mondo_busy_din_p2;	// From c2i_fdp of c2i_fdp.v
   output		mondo_busy_wr_p1;	// From c2i_fctrl of c2i_fctrl.v
   output		mondo_busy_wr_p2;	// From c2i_fctrl of c2i_fctrl.v
   output [64:0]	mondo_data0_din_hi;	// From c2i_fdp of c2i_fdp.v
   output [64:0]	mondo_data0_din_lo;	// From c2i_fdp of c2i_fdp.v
   output		mondo_data0_wr_hi_l;	// From c2i_fctrl of c2i_fctrl.v
   output		mondo_data0_wr_lo_l;	// From c2i_fctrl of c2i_fctrl.v
   output [64:0]	mondo_data1_din_hi;	// From c2i_fdp of c2i_fdp.v
   output [64:0]	mondo_data1_din_lo;	// From c2i_fdp of c2i_fdp.v
   output		mondo_data1_wr_hi_l;	// From c2i_fctrl of c2i_fctrl.v
   output		mondo_data1_wr_lo_l;	// From c2i_fctrl of c2i_fctrl.v
   output [`IOB_MONDO_DATA_INDEX-1:0]mondo_data_addr_p0;// From c2i_fctrl of c2i_fctrl.v
   output [`IOB_MONDO_DATA_INDEX-1:0]mondo_data_addr_p1;// From c2i_fctrl of c2i_fctrl.v
   output [`IOB_MONDO_SRC_WIDTH-1:0]mondo_source_din;// From c2i_fdp of c2i_fdp.v
   output		mondo_source_wr_l;	// From c2i_fctrl of c2i_fctrl.v
   output		rd_nack_ucb_sel;	// From c2i_sctrl of c2i_sctrl.v
   output		srvc_wr_ack;		// From c2i_sctrl of c2i_sctrl.v
   output		tap_mondo_acc_addr_invld_d2_f;// From c2i_fctrl of c2i_fctrl.v
   output		tap_mondo_acc_seq_d2_f;	// From c2i_fctrl of c2i_fctrl.v
   output [63:0]	tap_mondo_dout_d2_f;	// From c2i_fdp of c2i_fdp.v
   output		ucb_buf_acpt;		// From c2i_sctrl of c2i_sctrl.v
   output [`IOB_IO_BUF_WIDTH-1:0]wr_ack_io_buf_din;// From c2i_sdp of c2i_sdp.v
   // End of automatics

   // i2c interface
   output		cpu_mondo_rd_d2;	// From c2i_fctrl of c2i_fctrl.v

   // iobdg_ctrl interface
   output [`UCB_64PAY_PKT_WIDTH-1:0]c2i_packet;	// From c2i_sdp of c2i_sdp.v
   output 		c2i_packet_vld;		// From c2i_sctrl of c2i_sctrl.v
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [`UCB_ADDR_WIDTH-1:0]c2i_packet_addr;	// From c2i_sdp of c2i_sdp.v
   wire			clk_ucb_buf_acpt;	// From clk_ucb_buf of c2i_buf.v
   wire			clk_ucb_sel;		// From c2i_sctrl of c2i_sctrl.v
   wire [`IOB_CPU_BUF_INDEX:0]cpu_buf_head_s;	// From c2i_sctrl of c2i_sctrl.v
   wire			cpu_buf_rd;		// From c2i_sctrl of c2i_sctrl.v
   wire [`IOB_CPU_BUF_INDEX:0]cpu_buf_tail_f;	// From c2i_fctrl of c2i_fctrl.v
   wire			cpu_mondo_addr_invld_d2;// From c2i_fctrl of c2i_fctrl.v
   wire			cpu_mondo_rd_d1;	// From c2i_fctrl of c2i_fctrl.v
   wire			cpu_packet_is_req;	// From c2i_sctrl of c2i_sctrl.v
   wire [`UCB_PKT_WIDTH-1:0]cpu_packet_type;	// From c2i_sctrl of c2i_sctrl.v
   wire			dram0_ucb_buf_acpt;	// From dram0_ucb_buf of c2i_buf.v
   wire			dram0_ucb_sel;		// From c2i_sctrl of c2i_sctrl.v
   wire			dram1_ucb_buf_acpt;	// From dram1_ucb_buf of c2i_buf.v
   wire			dram1_ucb_sel;		// From c2i_sctrl of c2i_sctrl.v
   wire			io_mondo_data_wr;	// From c2i_fctrl of c2i_fctrl.v
   wire			iob_tap_busy;		// From c2i_sctrl of c2i_sctrl.v
   wire			jbi_ucb_buf_acpt;	// From jbi_ucb_buf of c2i_buf.v
   wire			jbi_ucb_sel;		// From c2i_sctrl of c2i_sctrl.v
   wire			mondo_addr_creg_mbusy_dec_d1;// From c2i_fctrl of c2i_fctrl.v
   wire			mondo_addr_creg_mdata0_dec_d1;// From c2i_fctrl of c2i_fctrl.v
   wire			mondo_addr_creg_mdata1_dec_d1;// From c2i_fctrl of c2i_fctrl.v
   wire [`IOB_MONDO_DATA_INDEX-1:0]mondo_data_addr_p0_d1;// From c2i_fctrl of c2i_fctrl.v
   wire			mondo_data_bypass_d1;	// From c2i_fctrl of c2i_fctrl.v
   wire [`PCX_AD_HI-`PCX_AD_LO:0]pcx_iob_addr;	// From c2i_fdp of c2i_fdp.v
   wire [`PCX_CP_HI-`PCX_TH_LO:0]pcx_iob_cputhr;// From c2i_fdp of c2i_fdp.v
   wire [`PCX_RQ_HI-`PCX_RQ_LO:0]pcx_iob_req;	// From c2i_fdp of c2i_fdp.v
   wire			pcx_iob_vld;		// From c2i_fdp of c2i_fdp.v
   wire [`PCX_WIDTH-1:0]pcx_packet;		// From c2i_sdp of c2i_sdp.v
   wire			spi_ucb_buf_acpt;	// From spi_ucb_buf of c2i_buf.v
   wire			spi_ucb_sel;		// From c2i_sctrl of c2i_sctrl.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]tap_iob_packet;// From tap_ucb_buf of ucb_bus_in.v
   wire			tap_iob_packet_vld;	// From tap_ucb_buf of ucb_bus_in.v
   wire			tap_mondo_rd_d1;	// From c2i_fctrl of c2i_fctrl.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]tap_packet;	// From c2i_sdp of c2i_sdp.v
   wire			tap_sel;		// From c2i_sctrl of c2i_sctrl.v
   // End of automatics
   
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /*****************************************************************
    * cpu-to-io fast control
    *****************************************************************/
   c2i_fctrl c2i_fctrl (
			/*AUTOINST*/
			// Outputs
			.iob_pcx_stall_pq(iob_pcx_stall_pq),
			.io_mondo_data_wr(io_mondo_data_wr),
			.mondo_data_bypass_d1(mondo_data_bypass_d1),
			.mondo_addr_creg_mdata0_dec_d1(mondo_addr_creg_mdata0_dec_d1),
			.mondo_addr_creg_mdata1_dec_d1(mondo_addr_creg_mdata1_dec_d1),
			.mondo_addr_creg_mbusy_dec_d1(mondo_addr_creg_mbusy_dec_d1),
			.cpu_mondo_rd_d1(cpu_mondo_rd_d1),
			.tap_mondo_rd_d1(tap_mondo_rd_d1),
			.cpu_mondo_rd_d2(cpu_mondo_rd_d2),
			.cpu_mondo_addr_invld_d2(cpu_mondo_addr_invld_d2),
			.mondo_data_addr_p0_d1(mondo_data_addr_p0_d1[`IOB_MONDO_DATA_INDEX-1:0]),
			.cpu_buf_tail_f	(cpu_buf_tail_f[`IOB_CPU_BUF_INDEX:0]),
			.cpu_mondo_wr_d2(cpu_mondo_wr_d2),
			.tap_mondo_acc_addr_invld_d2_f(tap_mondo_acc_addr_invld_d2_f),
			.tap_mondo_acc_seq_d2_f(tap_mondo_acc_seq_d2_f),
			.mondo_data_addr_p0(mondo_data_addr_p0[`IOB_MONDO_DATA_INDEX-1:0]),
			.mondo_data_addr_p1(mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-1:0]),
			.mondo_data0_wr_lo_l(mondo_data0_wr_lo_l),
			.mondo_data0_wr_hi_l(mondo_data0_wr_hi_l),
			.mondo_data1_wr_lo_l(mondo_data1_wr_lo_l),
			.mondo_data1_wr_hi_l(mondo_data1_wr_hi_l),
			.mondo_source_wr_l(mondo_source_wr_l),
			.mondo_busy_addr_p0(mondo_busy_addr_p0[`IOB_MONDO_DATA_INDEX-1:0]),
			.mondo_busy_addr_p1(mondo_busy_addr_p1[`IOB_MONDO_DATA_INDEX-1:0]),
			.mondo_busy_addr_p2(mondo_busy_addr_p2[`IOB_MONDO_DATA_INDEX-1:0]),
			.mondo_busy_wr_p1(mondo_busy_wr_p1),
			.mondo_busy_wr_p2(mondo_busy_wr_p2),
			.cpu_buf_wr_l	(cpu_buf_wr_l),
			.cpu_buf_tail_ptr(cpu_buf_tail_ptr[`IOB_CPU_BUF_INDEX-1:0]),
			// Inputs
			.cpu_rst_l	(cpu_rst_l),
			.cpu_clk	(cpu_clk),
			.tx_sync	(tx_sync),
			.rx_sync	(rx_sync),
			.pcx_iob_data_rdy_px2(pcx_iob_data_rdy_px2),
			.pcx_iob_vld	(pcx_iob_vld),
			.pcx_iob_req	(pcx_iob_req[`PCX_RQ_HI-`PCX_RQ_LO:0]),
			.pcx_iob_addr	(pcx_iob_addr[`PCX_AD_HI-`PCX_AD_LO:0]),
			.pcx_iob_cputhr	(pcx_iob_cputhr[`PCX_CP_HI-`PCX_TH_LO:0]),
			.cpu_buf_head_s	(cpu_buf_head_s[`IOB_CPU_BUF_INDEX:0]),
			.int_buf_hit_hwm(int_buf_hit_hwm),
			.io_mondo_data_wr_s(io_mondo_data_wr_s),
			.io_mondo_data_wr_addr_s(io_mondo_data_wr_addr_s[`IOB_MONDO_DATA_INDEX-1:0]),
			.tap_mondo_acc_addr_s(tap_mondo_acc_addr_s[`IOB_ADDR_WIDTH-1:0]),
			.tap_mondo_acc_seq_s(tap_mondo_acc_seq_s),
			.tap_mondo_wr_s	(tap_mondo_wr_s));

   
   /*****************************************************************
    * cpu-to-io fast datapath
    *****************************************************************/
   c2i_fdp c2i_fdp (
		    /*AUTOINST*/
		    // Outputs
		    .pcx_iob_vld	(pcx_iob_vld),
		    .pcx_iob_req	(pcx_iob_req[`PCX_RQ_HI-`PCX_RQ_LO:0]),
		    .pcx_iob_addr	(pcx_iob_addr[`PCX_AD_HI-`PCX_AD_LO:0]),
		    .pcx_iob_cputhr	(pcx_iob_cputhr[`PCX_CP_HI-`PCX_TH_LO:0]),
		    .int_buf_din_raw	(int_buf_din_raw[159:0]),
		    .tap_mondo_dout_d2_f(tap_mondo_dout_d2_f[63:0]),
		    .mondo_data0_din_lo	(mondo_data0_din_lo[64:0]),
		    .mondo_data0_din_hi	(mondo_data0_din_hi[64:0]),
		    .mondo_data1_din_lo	(mondo_data1_din_lo[64:0]),
		    .mondo_data1_din_hi	(mondo_data1_din_hi[64:0]),
		    .mondo_source_din	(mondo_source_din[`IOB_MONDO_SRC_WIDTH-1:0]),
		    .mondo_busy_din_p1	(mondo_busy_din_p1),
		    .mondo_busy_din_p2	(mondo_busy_din_p2),
		    .cpu_buf_din_lo	(cpu_buf_din_lo[64:0]),
		    .cpu_buf_din_hi	(cpu_buf_din_hi[64:0]),
		    // Inputs
		    .cpu_clk		(cpu_clk),
		    .tx_sync		(tx_sync),
		    .rx_sync		(rx_sync),
		    .pcx_iob_data_px2	(pcx_iob_data_px2[`PCX_WIDTH-1:0]),
		    .io_mondo_data_wr	(io_mondo_data_wr),
		    .mondo_data_bypass_d1(mondo_data_bypass_d1),
		    .mondo_addr_creg_mdata0_dec_d1(mondo_addr_creg_mdata0_dec_d1),
		    .mondo_addr_creg_mdata1_dec_d1(mondo_addr_creg_mdata1_dec_d1),
		    .mondo_addr_creg_mbusy_dec_d1(mondo_addr_creg_mbusy_dec_d1),
		    .cpu_mondo_rd_d1	(cpu_mondo_rd_d1),
		    .tap_mondo_rd_d1	(tap_mondo_rd_d1),
		    .cpu_mondo_rd_d2	(cpu_mondo_rd_d2),
		    .cpu_mondo_addr_invld_d2(cpu_mondo_addr_invld_d2),
		    .mondo_data_addr_p0_d1(mondo_data_addr_p0_d1[`IOB_MONDO_DATA_INDEX-1:0]),
		    .io_mondo_data0_din_s(io_mondo_data0_din_s[`IOB_MONDO_DATA_WIDTH-1:0]),
		    .io_mondo_data1_din_s(io_mondo_data1_din_s[`IOB_MONDO_DATA_WIDTH-1:0]),
		    .io_mondo_source_din_s(io_mondo_source_din_s[`IOB_MONDO_SRC_WIDTH-1:0]),
		    .tap_mondo_din_s	(tap_mondo_din_s[63:0]),
		    .mondo_data0_dout_lo(mondo_data0_dout_lo[64:0]),
		    .mondo_data0_dout_hi(mondo_data0_dout_hi[64:0]),
		    .mondo_data1_dout_lo(mondo_data1_dout_lo[64:0]),
		    .mondo_data1_dout_hi(mondo_data1_dout_hi[64:0]),
		    .mondo_source_dout	(mondo_source_dout[`IOB_MONDO_SRC_WIDTH-1:0]),
		    .mondo_busy_dout	(mondo_busy_dout));

   
   /*****************************************************************
    * cpu-to-io slow control
    *****************************************************************/
   c2i_sctrl c2i_sctrl (
			/*AUTOINST*/
			// Outputs
			.iob_tap_busy	(iob_tap_busy),
			.cpu_buf_rd	(cpu_buf_rd),
			.tap_sel	(tap_sel),
			.cpu_packet_is_req(cpu_packet_is_req),
			.cpu_packet_type(cpu_packet_type[`UCB_PKT_WIDTH-1:0]),
			.cpu_buf_head_s	(cpu_buf_head_s[`IOB_CPU_BUF_INDEX:0]),
			.srvc_wr_ack	(srvc_wr_ack),
			.cpu_buf_head_ptr(cpu_buf_head_ptr[`IOB_CPU_BUF_INDEX-1:0]),
			.cpu_buf_rd_l	(cpu_buf_rd_l),
			.c2i_packet_vld	(c2i_packet_vld),
			.c2i_packet_is_rd_req(c2i_packet_is_rd_req),
			.c2i_packet_is_wr_req(c2i_packet_is_wr_req),
			.jbi_ucb_sel	(jbi_ucb_sel),
			.clk_ucb_sel	(clk_ucb_sel),
			.dram0_ucb_sel	(dram0_ucb_sel),
			.dram1_ucb_sel	(dram1_ucb_sel),
			.iob_man_ucb_sel(iob_man_ucb_sel),
			.iob_int_ucb_sel(iob_int_ucb_sel),
			.spi_ucb_sel	(spi_ucb_sel),
			.bounce_ucb_sel	(bounce_ucb_sel),
			.rd_nack_ucb_sel(rd_nack_ucb_sel),
			.ucb_buf_acpt	(ucb_buf_acpt),
			// Inputs
			.rst_l		(rst_l),
			.clk		(clk),
			.tap_iob_packet_vld(tap_iob_packet_vld),
			.pcx_packet	(pcx_packet[`PCX_WIDTH-1:0]),
			.tap_packet	(tap_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
			.c2i_packet_addr(c2i_packet_addr[`UCB_ADDR_WIDTH-1:0]),
			.cpu_buf_tail_f	(cpu_buf_tail_f[`IOB_CPU_BUF_INDEX:0]),
			.io_buf_avail	(io_buf_avail),
			.jbi_ucb_buf_acpt(jbi_ucb_buf_acpt),
			.clk_ucb_buf_acpt(clk_ucb_buf_acpt),
			.dram0_ucb_buf_acpt(dram0_ucb_buf_acpt),
			.dram1_ucb_buf_acpt(dram1_ucb_buf_acpt),
			.iob_man_ucb_buf_acpt(iob_man_ucb_buf_acpt),
			.iob_int_ucb_buf_acpt(iob_int_ucb_buf_acpt),
			.spi_ucb_buf_acpt(spi_ucb_buf_acpt),
			.bounce_ucb_buf_acpt(bounce_ucb_buf_acpt),
			.rd_nack_ucb_buf_acpt(rd_nack_ucb_buf_acpt));

   
   /*****************************************************************
    * cpu-to-io slow datapath
    *****************************************************************/
   c2i_sdp c2i_sdp (
		    /*AUTOINST*/
		    // Outputs
		    .pcx_packet		(pcx_packet[`PCX_WIDTH-1:0]),
		    .tap_packet		(tap_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .c2i_packet_addr	(c2i_packet_addr[`UCB_ADDR_WIDTH-1:0]),
		    .c2i_packet		(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .c2i_rd_nack_packet	(c2i_rd_nack_packet[`UCB_NOPAY_PKT_WIDTH-1:0]),
		    .wr_ack_io_buf_din	(wr_ack_io_buf_din[`IOB_IO_BUF_WIDTH-1:0]),
		    // Inputs
		    .clk		(clk),
		    .tap_iob_packet	(tap_iob_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .cpu_buf_dout_lo	(cpu_buf_dout_lo[64:0]),
		    .cpu_buf_dout_hi	(cpu_buf_dout_hi[64:0]),
		    .cpu_buf_rd		(cpu_buf_rd),
		    .tap_sel		(tap_sel),
		    .cpu_packet_is_req	(cpu_packet_is_req),
		    .cpu_packet_type	(cpu_packet_type[`UCB_PKT_WIDTH-1:0]));

   
   /*****************************************************************
    * inbound from TAP 
    *****************************************************************/
   /* ucb_bus_in AUTO_TEMPLATE (
    // Outputs
    .stall              (iob_tap_stall),
    .indata_buf_vld     (tap_iob_packet_vld),
    .indata_buf         (tap_iob_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    // Inputs
    .vld                (tap_iob_vld),
    .data               (tap_iob_data[`TAP_IOB_WIDTH-1:0]),
    .stall_a1           (iob_tap_busy),
    ); */

   ucb_bus_in #(`TAP_IOB_WIDTH,64) tap_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .stall				(iob_tap_stall),	 // Templated
      .indata_buf_vld			(tap_iob_packet_vld),	 // Templated
      .indata_buf			(tap_iob_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .vld				(tap_iob_vld),		 // Templated
      .data				(tap_iob_data[`TAP_IOB_WIDTH-1:0]), // Templated
      .stall_a1				(iob_tap_busy));		 // Templated

   
   /*****************************************************************
    * outbound jbi ucb buffers
    *****************************************************************/
   /* c2i_buf AUTO_TEMPLATE (
    // Outputs
    .iob_ucb_vld        (iob_jbi_pio_vld),
    .iob_ucb_data       (iob_jbi_pio_data[`IOB_JBI_WIDTH-1:0]),
    .ucb_buf_acpt       (jbi_ucb_buf_acpt),
    // Inputs
    .c2i_packet		(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .ucb_sel            (jbi_ucb_sel),
    .ucb_iob_stall      (jbi_iob_pio_stall),
    ); */

   c2i_buf #(64,`IOB_JBI_WIDTH) jbi_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .ucb_buf_acpt			(jbi_ucb_buf_acpt),	 // Templated
      .iob_ucb_vld			(iob_jbi_pio_vld),	 // Templated
      .iob_ucb_data			(iob_jbi_pio_data[`IOB_JBI_WIDTH-1:0]), // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .c2i_packet_vld			(c2i_packet_vld),
      .ucb_sel				(jbi_ucb_sel),		 // Templated
      .c2i_packet			(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .ucb_iob_stall			(jbi_iob_pio_stall));	 // Templated

   
   /*****************************************************************
    * outbound clk ucb buffers
    *****************************************************************/
   /* c2i_buf AUTO_TEMPLATE (
    // Outputs
    .iob_ucb_vld        (iob_clk_vld),
    .iob_ucb_data       (iob_clk_data[`IOB_CLK_WIDTH-1:0]),
    .ucb_buf_acpt       (clk_ucb_buf_acpt),
    // Inputs
    .c2i_packet		(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .ucb_sel            (clk_ucb_sel),
    .ucb_iob_stall      (clk_iob_stall),
    ); */

   c2i_buf #(64,`IOB_CLK_WIDTH) clk_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .ucb_buf_acpt			(clk_ucb_buf_acpt),	 // Templated
      .iob_ucb_vld			(iob_clk_vld),		 // Templated
      .iob_ucb_data			(iob_clk_data[`IOB_CLK_WIDTH-1:0]), // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .c2i_packet_vld			(c2i_packet_vld),
      .ucb_sel				(clk_ucb_sel),		 // Templated
      .c2i_packet			(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .ucb_iob_stall			(clk_iob_stall));	 // Templated

   
   /*****************************************************************
    * outbound dram0 ucb buffers
    *****************************************************************/
   /* c2i_buf AUTO_TEMPLATE (
    // Outputs
    .iob_ucb_vld        (iob_dram02_vld),
    .iob_ucb_data       (iob_dram02_data[`IOB_DRAM_WIDTH-1:0]),
    .ucb_buf_acpt       (dram0_ucb_buf_acpt),
    // Inputs
    .c2i_packet		(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .ucb_sel            (dram0_ucb_sel),
    .ucb_iob_stall      (dram02_iob_stall),
    ); */

   c2i_buf #(64,`IOB_DRAM_WIDTH) dram0_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .ucb_buf_acpt			(dram0_ucb_buf_acpt),	 // Templated
      .iob_ucb_vld			(iob_dram02_vld),	 // Templated
      .iob_ucb_data			(iob_dram02_data[`IOB_DRAM_WIDTH-1:0]), // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .c2i_packet_vld			(c2i_packet_vld),
      .ucb_sel				(dram0_ucb_sel),	 // Templated
      .c2i_packet			(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .ucb_iob_stall			(dram02_iob_stall));	 // Templated

   
   /*****************************************************************
    * outbound dram1 ucb buffers
    *****************************************************************/
   /* c2i_buf AUTO_TEMPLATE (
    // Outputs
    .iob_ucb_vld        (iob_dram13_vld),
    .iob_ucb_data       (iob_dram13_data[`IOB_DRAM_WIDTH-1:0]),
    .ucb_buf_acpt       (dram1_ucb_buf_acpt),
    // Inputs
    .c2i_packet		(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .ucb_sel            (dram1_ucb_sel),
    .ucb_iob_stall      (dram13_iob_stall),
    ); */

   c2i_buf #(64,`IOB_DRAM_WIDTH) dram1_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .ucb_buf_acpt			(dram1_ucb_buf_acpt),	 // Templated
      .iob_ucb_vld			(iob_dram13_vld),	 // Templated
      .iob_ucb_data			(iob_dram13_data[`IOB_DRAM_WIDTH-1:0]), // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .c2i_packet_vld			(c2i_packet_vld),
      .ucb_sel				(dram1_ucb_sel),	 // Templated
      .c2i_packet			(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .ucb_iob_stall			(dram13_iob_stall));	 // Templated

   
   /*****************************************************************
    * outbound spi ucb buffers
    *****************************************************************/
   /* c2i_buf AUTO_TEMPLATE (
    // Outputs
    .iob_ucb_vld        (iob_jbi_spi_vld),
    .iob_ucb_data       (iob_jbi_spi_data[`IOB_SPI_WIDTH-1:0]),
    .ucb_buf_acpt       (spi_ucb_buf_acpt),
    // Inputs
    .c2i_packet		(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .ucb_sel            (spi_ucb_sel),
    .ucb_iob_stall      (jbi_iob_spi_stall),
    ); */

   c2i_buf #(64,`IOB_SPI_WIDTH) spi_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .ucb_buf_acpt			(spi_ucb_buf_acpt),	 // Templated
      .iob_ucb_vld			(iob_jbi_spi_vld),	 // Templated
      .iob_ucb_data			(iob_jbi_spi_data[`IOB_SPI_WIDTH-1:0]), // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .c2i_packet_vld			(c2i_packet_vld),
      .ucb_sel				(spi_ucb_sel),		 // Templated
      .c2i_packet			(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .ucb_iob_stall			(jbi_iob_spi_stall));	 // Templated

   
endmodule // c2i


// Local Variables:
// verilog-library-directories:("." "../../../common/rtl" "../../../common/dolphin/rtl")
// End:
