// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: i2c.v
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
//  Module Name:	i2c (io-to-cpu)
//  Description:	
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
module i2c (/*AUTOARG*/
   // Outputs
   rd_nack_rd, iob_tap_vld, iob_tap_data, iob_man_int_rd, 
   iob_man_ack_rd, iob_jbi_spi_stall, iob_jbi_pio_stall, 
   iob_jbi_mondo_nack, iob_jbi_mondo_ack, iob_int_ack_rd, 
   iob_dram13_stall, iob_dram02_stall, iob_cpx_req_cq, 
   iob_cpx_data_ca, iob_clk_stall, io_mondo_source_din_s, 
   io_mondo_data_wr_s, io_mondo_data_wr_addr_s, io_mondo_data1_din_s, 
   io_mondo_data0_din_s, io_intman_addr, io_buf_wr, io_buf_tail_ptr, 
   io_buf_head_ptr, io_buf_din_raw, io_buf_avail, int_srvcd, 
   int_buf_wr, int_buf_tail_ptr, int_buf_hit_hwm, int_buf_head_ptr, 
   bounce_ack_rd, int_srvcd_d1, 
   // Inputs
   wr_ack_io_buf_din, tx_sync, tap_iob_stall, srvc_wr_ack, rx_sync, 
   rst_l, rd_nack_vld, rd_nack_packet, mondo_busy_vec_f, 
   jbi_iob_spi_vld, jbi_iob_spi_data, jbi_iob_pio_vld, 
   jbi_iob_pio_data, jbi_iob_mondo_vld, jbi_iob_mondo_data, 
   iob_man_int_vld, iob_man_int_packet, iob_man_ack_vld, 
   iob_man_ack_packet, iob_int_ack_vld, iob_int_ack_packet, 
   io_buf_dout_raw, int_vec_dout_raw, int_cpu_dout_raw, 
   int_buf_dout_raw, first_availcore, dram13_iob_vld, 
   dram13_iob_data, dram02_iob_vld, dram02_iob_data, creg_jintv_vec, 
   creg_intctrl_mask, cpx_iob_grant_cx2, cpu_rst_l, cpu_mondo_wr_d2, 
   cpu_mondo_rd_d2, cpu_intman_acc, cpu_intctrl_acc, cpu_clk, 
   clk_iob_vld, clk_iob_data, clk, bounce_ack_vld, bounce_ack_packet
   );
   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input [`UCB_64PAY_PKT_WIDTH-1:0]bounce_ack_packet;// To i2c_sdp of i2c_sdp.v
   input		bounce_ack_vld;		// To i2c_sctrl of i2c_sctrl.v
   input		clk;			// To i2c_sctrl of i2c_sctrl.v, ...
   input [`CLK_IOB_WIDTH-1:0]clk_iob_data;	// To clk_ucb_buf of i2c_buf.v
   input		clk_iob_vld;		// To clk_ucb_buf of i2c_buf.v
   input		cpu_clk;		// To i2c_fctrl of i2c_fctrl.v, ...
   input		cpu_intctrl_acc;	// To i2c_sctrl of i2c_sctrl.v
   input		cpu_intman_acc;		// To i2c_sctrl of i2c_sctrl.v
   input		cpu_mondo_rd_d2;	// To i2c_fctrl of i2c_fctrl.v
   input		cpu_mondo_wr_d2;	// To i2c_fctrl of i2c_fctrl.v
   input		cpu_rst_l;		// To i2c_fctrl of i2c_fctrl.v
   input [`IOB_CPU_WIDTH-1:0]cpx_iob_grant_cx2;	// To i2c_fctrl of i2c_fctrl.v
   input		creg_intctrl_mask;	// To i2c_sctrl of i2c_sctrl.v
   input [`IOB_INT_VEC_WIDTH-1:0]creg_jintv_vec;// To i2c_sdp of i2c_sdp.v
   input [`DRAM_IOB_WIDTH-1:0]dram02_iob_data;	// To dram0_ucb_buf of i2c_buf.v
   input		dram02_iob_vld;		// To dram0_ucb_buf of i2c_buf.v
   input [`DRAM_IOB_WIDTH-1:0]dram13_iob_data;	// To dram1_ucb_buf of i2c_buf.v
   input		dram13_iob_vld;		// To dram1_ucb_buf of i2c_buf.v
   input [`IOB_CPU_WIDTH-1:0]first_availcore;	// To i2c_sdp of i2c_sdp.v
   input [159:0]	int_buf_dout_raw;	// To i2c_fdp of i2c_fdp.v
   input [14:0]		int_cpu_dout_raw;	// To i2c_sdp of i2c_sdp.v
   input [14:0]		int_vec_dout_raw;	// To i2c_sdp of i2c_sdp.v
   input [159:0]	io_buf_dout_raw;	// To i2c_fdp of i2c_fdp.v
   input [`UCB_64PAY_PKT_WIDTH-1:0]iob_int_ack_packet;// To i2c_sdp of i2c_sdp.v
   input		iob_int_ack_vld;	// To i2c_sctrl of i2c_sctrl.v
   input [`UCB_64PAY_PKT_WIDTH-1:0]iob_man_ack_packet;// To i2c_sdp of i2c_sdp.v
   input		iob_man_ack_vld;	// To i2c_sctrl of i2c_sctrl.v
   input [`UCB_INT_PKT_WIDTH-1:0]iob_man_int_packet;// To i2c_sdp of i2c_sdp.v
   input		iob_man_int_vld;	// To i2c_sctrl of i2c_sctrl.v
   input [`JBI_IOB_MONDO_BUS_WIDTH-1:0]jbi_iob_mondo_data;// To jbus_mondo_buf of iobdg_jbus_mondo_buf.v
   input		jbi_iob_mondo_vld;	// To jbus_mondo_buf of iobdg_jbus_mondo_buf.v
   input [`JBI_IOB_WIDTH-1:0]jbi_iob_pio_data;	// To jbi_ucb_buf of i2c_buf.v
   input		jbi_iob_pio_vld;	// To jbi_ucb_buf of i2c_buf.v
   input [`SPI_IOB_WIDTH-1:0]jbi_iob_spi_data;	// To spi_ucb_buf of i2c_buf.v
   input		jbi_iob_spi_vld;	// To spi_ucb_buf of i2c_buf.v
   input [`IOB_CPUTHR_WIDTH-1:0]mondo_busy_vec_f;// To i2c_sctrl of i2c_sctrl.v
   input [`UCB_NOPAY_PKT_WIDTH-1:0]rd_nack_packet;// To i2c_sdp of i2c_sdp.v
   input		rd_nack_vld;		// To i2c_sctrl of i2c_sctrl.v
   input		rst_l;			// To i2c_sctrl of i2c_sctrl.v, ...
   input		rx_sync;		// To i2c_fctrl of i2c_fctrl.v, ...
   input		srvc_wr_ack;		// To i2c_sctrl of i2c_sctrl.v
   input		tap_iob_stall;		// To tap_ucb_buf of ucb_bus_out.v
   input		tx_sync;		// To i2c_fctrl of i2c_fctrl.v
   input [`IOB_IO_BUF_WIDTH-1:0]wr_ack_io_buf_din;// To i2c_sdp of i2c_sdp.v
   // End of automatics

   
   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		bounce_ack_rd;		// From i2c_sctrl of i2c_sctrl.v
   output [`IOB_INT_BUF_INDEX-1:0]int_buf_head_ptr;// From i2c_fctrl of i2c_fctrl.v
   output		int_buf_hit_hwm;	// From i2c_fctrl of i2c_fctrl.v
   output [`IOB_INT_BUF_INDEX-1:0]int_buf_tail_ptr;// From i2c_fctrl of i2c_fctrl.v
   output		int_buf_wr;		// From i2c_fctrl of i2c_fctrl.v
   output		int_srvcd;		// From i2c_sctrl of i2c_sctrl.v
   output		io_buf_avail;		// From i2c_sctrl of i2c_sctrl.v
   output [159:0]	io_buf_din_raw;		// From i2c_sdp of i2c_sdp.v
   output [`IOB_IO_BUF_INDEX-1:0]io_buf_head_ptr;// From i2c_fctrl of i2c_fctrl.v
   output [`IOB_IO_BUF_INDEX-1:0]io_buf_tail_ptr;// From i2c_sctrl of i2c_sctrl.v
   output		io_buf_wr;		// From i2c_sctrl of i2c_sctrl.v
   output [`IOB_INT_TAB_INDEX-1:0]io_intman_addr;// From i2c_sdp of i2c_sdp.v
   output [63:0]	io_mondo_data0_din_s;	// From i2c_sdp of i2c_sdp.v
   output [63:0]	io_mondo_data1_din_s;	// From i2c_sdp of i2c_sdp.v
   output [`IOB_CPUTHR_INDEX-1:0]io_mondo_data_wr_addr_s;// From i2c_sdp of i2c_sdp.v
   output		io_mondo_data_wr_s;	// From i2c_sctrl of i2c_sctrl.v
   output [`JBI_IOB_MONDO_SRC_WIDTH-1:0]io_mondo_source_din_s;// From i2c_sdp of i2c_sdp.v
   output		iob_clk_stall;		// From clk_ucb_buf of i2c_buf.v
   output [`CPX_WIDTH-1:0]iob_cpx_data_ca;	// From i2c_fdp of i2c_fdp.v
   output [`IOB_CPU_WIDTH-1:0]iob_cpx_req_cq;	// From i2c_fdp of i2c_fdp.v
   output		iob_dram02_stall;	// From dram0_ucb_buf of i2c_buf.v
   output		iob_dram13_stall;	// From dram1_ucb_buf of i2c_buf.v
   output		iob_int_ack_rd;		// From i2c_sctrl of i2c_sctrl.v
   output		iob_jbi_mondo_ack;	// From i2c_sctrl of i2c_sctrl.v
   output		iob_jbi_mondo_nack;	// From i2c_sctrl of i2c_sctrl.v
   output		iob_jbi_pio_stall;	// From jbi_ucb_buf of i2c_buf.v
   output		iob_jbi_spi_stall;	// From spi_ucb_buf of i2c_buf.v
   output		iob_man_ack_rd;		// From i2c_sctrl of i2c_sctrl.v
   output		iob_man_int_rd;		// From i2c_sctrl of i2c_sctrl.v
   output [`IOB_TAP_WIDTH-1:0]iob_tap_data;	// From tap_ucb_buf of ucb_bus_out.v
   output		iob_tap_vld;		// From tap_ucb_buf of ucb_bus_out.v
   output		rd_nack_rd;		// From i2c_sctrl of i2c_sctrl.v
   // End of automatics
   
   // iobdg_ctrl interface
   output 		int_srvcd_d1;		// From i2c_sctrl of i2c_sctrl.v
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [`UCB_128PAY_PKT_WIDTH-1:0]ack_packet_d1;// From i2c_sdp of i2c_sdp.v
   wire [`IOB_ACK_AVEC_WIDTH-1:0]ack_sel;	// From i2c_sctrl of i2c_sctrl.v
   wire			ack_srvcd_d1;		// From i2c_sctrl of i2c_sctrl.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]clk_ack_packet;// From clk_ucb_buf of i2c_buf.v
   wire			clk_ack_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			clk_ack_vld;		// From clk_ucb_buf of i2c_buf.v
   wire [`UCB_INT_PKT_WIDTH-1:0]clk_int_packet;	// From clk_ucb_buf of i2c_buf.v
   wire			clk_int_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			clk_int_vld;		// From clk_ucb_buf of i2c_buf.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]dram0_ack_packet;// From dram0_ucb_buf of i2c_buf.v
   wire			dram0_ack_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			dram0_ack_vld;		// From dram0_ucb_buf of i2c_buf.v
   wire [`UCB_INT_PKT_WIDTH-1:0]dram0_int_packet;// From dram0_ucb_buf of i2c_buf.v
   wire			dram0_int_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			dram0_int_vld;		// From dram0_ucb_buf of i2c_buf.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]dram1_ack_packet;// From dram1_ucb_buf of i2c_buf.v
   wire			dram1_ack_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			dram1_ack_vld;		// From dram1_ucb_buf of i2c_buf.v
   wire [`UCB_INT_PKT_WIDTH-1:0]dram1_int_packet;// From dram1_ucb_buf of i2c_buf.v
   wire			dram1_int_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			dram1_int_vld;		// From dram1_ucb_buf of i2c_buf.v
   wire [`IOB_CPU_WIDTH-1:0]int_buf_cpx_req;	// From i2c_fdp of i2c_fdp.v
   wire			int_buf_rd;		// From i2c_fctrl of i2c_fctrl.v
   wire			int_buf_sel_next;	// From i2c_fctrl of i2c_fctrl.v
   wire [`IOB_INT_AVEC_WIDTH-1:0]int_sel;	// From i2c_sctrl of i2c_sctrl.v
   wire [`IOB_CPU_WIDTH-1:0]io_buf_cpx_req;	// From i2c_fdp of i2c_fdp.v
   wire [`IOB_IO_BUF_INDEX:0]io_buf_head_f;	// From i2c_fctrl of i2c_fctrl.v
   wire			io_buf_rd;		// From i2c_fctrl of i2c_fctrl.v
   wire			io_buf_sel_next;	// From i2c_fctrl of i2c_fctrl.v
   wire [`IOB_IO_BUF_INDEX:0]io_buf_tail_s;	// From i2c_sctrl of i2c_sctrl.v
   wire [`IOB_CPU_WIDTH-1:0]iob_cpx_req_next;	// From i2c_fdp of i2c_fdp.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]iob_tap_packet;// From i2c_sdp of i2c_sdp.v
   wire			iob_tap_packet_vld;	// From i2c_sctrl of i2c_sctrl.v
   wire [`UCB_128PAY_PKT_WIDTH-1:0]jbi_ack_packet;// From jbi_ucb_buf of i2c_buf.v
   wire			jbi_ack_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			jbi_ack_vld;		// From jbi_ucb_buf of i2c_buf.v
   wire [`UCB_INT_PKT_WIDTH-1:0]jbi_int_packet;	// From jbi_ucb_buf of i2c_buf.v
   wire			jbi_int_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			jbi_int_vld;		// From jbi_ucb_buf of i2c_buf.v
   wire [63:0]		jbi_mondo_data0;	// From jbus_mondo_buf of iobdg_jbus_mondo_buf.v
   wire [63:0]		jbi_mondo_data1;	// From jbus_mondo_buf of iobdg_jbus_mondo_buf.v
   wire			jbi_mondo_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire [`JBI_IOB_MONDO_SRC_WIDTH-1:0]jbi_mondo_source;// From jbus_mondo_buf of iobdg_jbus_mondo_buf.v
   wire [`JBI_IOB_MONDO_TRG_WIDTH-1:0]jbi_mondo_target;// From jbus_mondo_buf of iobdg_jbus_mondo_buf.v
   wire			jbi_mondo_vld;		// From jbus_mondo_buf of iobdg_jbus_mondo_buf.v
   wire			mondo_srvcd_d1;		// From i2c_sctrl of i2c_sctrl.v
   wire [`UCB_64PAY_PKT_WIDTH-1:0]spi_ack_packet;// From spi_ucb_buf of i2c_buf.v
   wire			spi_ack_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			spi_ack_vld;		// From spi_ucb_buf of i2c_buf.v
   wire [`UCB_INT_PKT_WIDTH-1:0]spi_int_packet;	// From spi_ucb_buf of i2c_buf.v
   wire			spi_int_rd;		// From i2c_sctrl of i2c_sctrl.v
   wire			spi_int_vld;		// From spi_ucb_buf of i2c_buf.v
   wire			tap_iob_busy;		// From tap_ucb_buf of ucb_bus_out.v
   // End of automatics

   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /*****************************************************************
    * io-to-cpu fast control
    *****************************************************************/
   i2c_fctrl i2c_fctrl (
			/*AUTOINST*/
			// Outputs
			.int_buf_sel_next(int_buf_sel_next),
			.io_buf_sel_next(io_buf_sel_next),
			.int_buf_rd	(int_buf_rd),
			.io_buf_rd	(io_buf_rd),
			.int_buf_hit_hwm(int_buf_hit_hwm),
			.io_buf_head_f	(io_buf_head_f[`IOB_IO_BUF_INDEX:0]),
			.int_buf_wr	(int_buf_wr),
			.int_buf_tail_ptr(int_buf_tail_ptr[`IOB_INT_BUF_INDEX-1:0]),
			.int_buf_head_ptr(int_buf_head_ptr[`IOB_INT_BUF_INDEX-1:0]),
			.io_buf_head_ptr(io_buf_head_ptr[`IOB_IO_BUF_INDEX-1:0]),
			// Inputs
			.cpu_rst_l	(cpu_rst_l),
			.cpu_clk	(cpu_clk),
			.tx_sync	(tx_sync),
			.rx_sync	(rx_sync),
			.cpx_iob_grant_cx2(cpx_iob_grant_cx2[`IOB_CPU_WIDTH-1:0]),
			.int_buf_cpx_req(int_buf_cpx_req[`IOB_CPU_WIDTH-1:0]),
			.io_buf_cpx_req	(io_buf_cpx_req[`IOB_CPU_WIDTH-1:0]),
			.iob_cpx_req_next(iob_cpx_req_next[`IOB_CPU_WIDTH-1:0]),
			.cpu_mondo_rd_d2(cpu_mondo_rd_d2),
			.cpu_mondo_wr_d2(cpu_mondo_wr_d2),
			.io_buf_tail_s	(io_buf_tail_s[`IOB_IO_BUF_INDEX:0]));
   
   
   /*****************************************************************
    * io-to-cpu fast datapath
    *****************************************************************/
   i2c_fdp i2c_fdp (
		    /*AUTOINST*/
		    // Outputs
		    .iob_cpx_req_cq	(iob_cpx_req_cq[`IOB_CPU_WIDTH-1:0]),
		    .iob_cpx_data_ca	(iob_cpx_data_ca[`CPX_WIDTH-1:0]),
		    .int_buf_cpx_req	(int_buf_cpx_req[`IOB_CPU_WIDTH-1:0]),
		    .io_buf_cpx_req	(io_buf_cpx_req[`IOB_CPU_WIDTH-1:0]),
		    .iob_cpx_req_next	(iob_cpx_req_next[`IOB_CPU_WIDTH-1:0]),
		    // Inputs
		    .cpu_clk		(cpu_clk),
		    .rx_sync		(rx_sync),
		    .int_buf_sel_next	(int_buf_sel_next),
		    .io_buf_sel_next	(io_buf_sel_next),
		    .int_buf_rd		(int_buf_rd),
		    .io_buf_rd		(io_buf_rd),
		    .int_buf_dout_raw	(int_buf_dout_raw[159:0]),
		    .io_buf_dout_raw	(io_buf_dout_raw[159:0]));
   

   /*****************************************************************
    * io-to-cpu slow control
    *****************************************************************/
   i2c_sctrl i2c_sctrl (/*AUTOINST*/
			// Outputs
			.jbi_mondo_rd	(jbi_mondo_rd),
			.jbi_int_rd	(jbi_int_rd),
			.clk_int_rd	(clk_int_rd),
			.dram0_int_rd	(dram0_int_rd),
			.dram1_int_rd	(dram1_int_rd),
			.iob_man_int_rd	(iob_man_int_rd),
			.spi_int_rd	(spi_int_rd),
			.jbi_ack_rd	(jbi_ack_rd),
			.clk_ack_rd	(clk_ack_rd),
			.dram0_ack_rd	(dram0_ack_rd),
			.dram1_ack_rd	(dram1_ack_rd),
			.iob_man_ack_rd	(iob_man_ack_rd),
			.iob_int_ack_rd	(iob_int_ack_rd),
			.spi_ack_rd	(spi_ack_rd),
			.bounce_ack_rd	(bounce_ack_rd),
			.rd_nack_rd	(rd_nack_rd),
			.int_sel	(int_sel[`IOB_INT_AVEC_WIDTH-1:0]),
			.ack_sel	(ack_sel[`IOB_ACK_AVEC_WIDTH-1:0]),
			.mondo_srvcd_d1	(mondo_srvcd_d1),
			.int_srvcd_d1	(int_srvcd_d1),
			.ack_srvcd_d1	(ack_srvcd_d1),
			.io_buf_tail_s	(io_buf_tail_s[`IOB_IO_BUF_INDEX:0]),
			.io_mondo_data_wr_s(io_mondo_data_wr_s),
			.io_buf_avail	(io_buf_avail),
			.int_srvcd	(int_srvcd),
			.io_buf_wr	(io_buf_wr),
			.io_buf_tail_ptr(io_buf_tail_ptr[`IOB_IO_BUF_INDEX-1:0]),
			.iob_tap_packet_vld(iob_tap_packet_vld),
			.iob_jbi_mondo_ack(iob_jbi_mondo_ack),
			.iob_jbi_mondo_nack(iob_jbi_mondo_nack),
			// Inputs
			.rst_l		(rst_l),
			.clk		(clk),
			.jbi_mondo_vld	(jbi_mondo_vld),
			.jbi_mondo_target(jbi_mondo_target[`IOB_CPUTHR_INDEX-1:0]),
			.spi_int_vld	(spi_int_vld),
			.iob_man_int_vld(iob_man_int_vld),
			.dram1_int_vld	(dram1_int_vld),
			.dram0_int_vld	(dram0_int_vld),
			.clk_int_vld	(clk_int_vld),
			.jbi_int_vld	(jbi_int_vld),
			.rd_nack_vld	(rd_nack_vld),
			.bounce_ack_vld	(bounce_ack_vld),
			.spi_ack_vld	(spi_ack_vld),
			.iob_int_ack_vld(iob_int_ack_vld),
			.iob_man_ack_vld(iob_man_ack_vld),
			.dram1_ack_vld	(dram1_ack_vld),
			.dram0_ack_vld	(dram0_ack_vld),
			.clk_ack_vld	(clk_ack_vld),
			.jbi_ack_vld	(jbi_ack_vld),
			.ack_packet_d1	(ack_packet_d1[`UCB_128PAY_PKT_WIDTH-1:0]),
			.io_buf_head_f	(io_buf_head_f[`IOB_IO_BUF_INDEX:0]),
			.mondo_busy_vec_f(mondo_busy_vec_f[`IOB_CPUTHR_WIDTH-1:0]),
			.srvc_wr_ack	(srvc_wr_ack),
			.cpu_intman_acc	(cpu_intman_acc),
			.cpu_intctrl_acc(cpu_intctrl_acc),
			.creg_intctrl_mask(creg_intctrl_mask),
			.tap_iob_busy	(tap_iob_busy));
   
   
   /*****************************************************************
    * io-to-cpu slow datapath
    *****************************************************************/
   i2c_sdp i2c_sdp (/*AUTOINST*/
		    // Outputs
		    .io_mondo_data_wr_addr_s(io_mondo_data_wr_addr_s[`IOB_CPUTHR_INDEX-1:0]),
		    .io_mondo_data0_din_s(io_mondo_data0_din_s[63:0]),
		    .io_mondo_data1_din_s(io_mondo_data1_din_s[63:0]),
		    .io_mondo_source_din_s(io_mondo_source_din_s[`JBI_IOB_MONDO_SRC_WIDTH-1:0]),
		    .io_intman_addr	(io_intman_addr[`IOB_INT_TAB_INDEX-1:0]),
		    .ack_packet_d1	(ack_packet_d1[`UCB_128PAY_PKT_WIDTH-1:0]),
		    .io_buf_din_raw	(io_buf_din_raw[159:0]),
		    .iob_tap_packet	(iob_tap_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    // Inputs
		    .clk		(clk),
		    .jbi_mondo_data0	(jbi_mondo_data0[63:0]),
		    .jbi_mondo_data1	(jbi_mondo_data1[63:0]),
		    .jbi_mondo_target	(jbi_mondo_target[`IOB_CPUTHR_INDEX-1:0]),
		    .jbi_mondo_source	(jbi_mondo_source[`JBI_IOB_MONDO_SRC_WIDTH-1:0]),
		    .jbi_int_packet	(jbi_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
		    .clk_int_packet	(clk_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
		    .dram0_int_packet	(dram0_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
		    .dram1_int_packet	(dram1_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
		    .iob_man_int_packet	(iob_man_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
		    .spi_int_packet	(spi_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
		    .jbi_ack_packet	(jbi_ack_packet[`UCB_128PAY_PKT_WIDTH-1:0]),
		    .clk_ack_packet	(clk_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .dram0_ack_packet	(dram0_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .dram1_ack_packet	(dram1_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .iob_man_ack_packet	(iob_man_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .iob_int_ack_packet	(iob_int_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .spi_ack_packet	(spi_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .bounce_ack_packet	(bounce_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
		    .rd_nack_packet	(rd_nack_packet[`UCB_NOPAY_PKT_WIDTH-1:0]),
		    .int_vec_dout_raw	(int_vec_dout_raw[14:0]),
		    .int_cpu_dout_raw	(int_cpu_dout_raw[14:0]),
		    .int_sel		(int_sel[`IOB_INT_AVEC_WIDTH-1:0]),
		    .ack_sel		(ack_sel[`IOB_ACK_AVEC_WIDTH-1:0]),
		    .mondo_srvcd_d1	(mondo_srvcd_d1),
		    .int_srvcd_d1	(int_srvcd_d1),
		    .ack_srvcd_d1	(ack_srvcd_d1),
		    .wr_ack_io_buf_din	(wr_ack_io_buf_din[`IOB_IO_BUF_WIDTH-1:0]),
		    .creg_jintv_vec	(creg_jintv_vec[`IOB_INT_VEC_WIDTH-1:0]),
		    .first_availcore	(first_availcore[`IOB_CPU_WIDTH-1:0]));
   

   /*****************************************************************
    * outbound to TAP
    *****************************************************************/
   /* ucb_bus_out AUTO_TEMPLATE (
     // Outputs
    .vld                (iob_tap_vld),
    .data               (iob_tap_data[`IOB_TAP_WIDTH-1:0]),
    .outdata_buf_busy   (tap_iob_busy),
    // Inputs
    .stall              (tap_iob_stall),
    .outdata_buf_in     (iob_tap_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .outdata_vec_in     ({128/`IOB_TAP_WIDTH{1'b1}}),
    .outdata_buf_wr     (iob_tap_packet_vld),
    ); */

   ucb_bus_out #(`IOB_TAP_WIDTH,64) tap_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .vld				(iob_tap_vld),		 // Templated
      .data				(iob_tap_data[`IOB_TAP_WIDTH-1:0]), // Templated
      .outdata_buf_busy			(tap_iob_busy),		 // Templated
      // Inputs
      .clk				(clk),
      .rst_l				(rst_l),
      .stall				(tap_iob_stall),	 // Templated
      .outdata_buf_in			(iob_tap_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .outdata_vec_in			({128/`IOB_TAP_WIDTH{1'b1}}), // Templated
      .outdata_buf_wr			(iob_tap_packet_vld));	 // Templated

   
   /*****************************************************************
    * inbound jbi ucb buffers
    *****************************************************************/
   /* i2c_buf AUTO_TEMPLATE (
     // Outputs
    .iob_ucb_stall      (iob_jbi_pio_stall),
    .req_ack_obj        (jbi_ack_packet[`UCB_128PAY_PKT_WIDTH-1:0]),
    .req_ack_vld        (jbi_ack_vld),
    .int_obj            (jbi_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
    .int_vld            (jbi_int_vld),
    // Inputs
    .ucb_iob_vld        (jbi_iob_pio_vld),
    .ucb_iob_data       (jbi_iob_pio_data[`JBI_IOB_WIDTH-1:0]),
    .rd_req_ack_dbl_buf (jbi_ack_rd),
    .rd_int_dbl_buf     (jbi_int_rd),
    ); */

   i2c_buf #(`JBI_IOB_WIDTH,128,`UCB_128PAY_PKT_WIDTH,`UCB_INT_PKT_WIDTH) jbi_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .iob_ucb_stall			(iob_jbi_pio_stall),	 // Templated
      .req_ack_obj			(jbi_ack_packet[`UCB_128PAY_PKT_WIDTH-1:0]), // Templated
      .req_ack_vld			(jbi_ack_vld),		 // Templated
      .int_obj				(jbi_int_packet[`UCB_INT_PKT_WIDTH-1:0]), // Templated
      .int_vld				(jbi_int_vld),		 // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .ucb_iob_vld			(jbi_iob_pio_vld),	 // Templated
      .ucb_iob_data			(jbi_iob_pio_data[`JBI_IOB_WIDTH-1:0]), // Templated
      .rd_req_ack_dbl_buf		(jbi_ack_rd),		 // Templated
      .rd_int_dbl_buf			(jbi_int_rd));		 // Templated

   
   /*****************************************************************
    * inbound clk ucb buffers
    *****************************************************************/
   /* i2c_buf AUTO_TEMPLATE (
     // Outputs
    .iob_ucb_stall      (iob_clk_stall),
    .req_ack_obj        (clk_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .req_ack_vld        (clk_ack_vld),
    .int_obj            (clk_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
    .int_vld            (clk_int_vld),
    // Inputs
    .ucb_iob_vld        (clk_iob_vld),
    .ucb_iob_data       (clk_iob_data[`CLK_IOB_WIDTH-1:0]),
    .rd_req_ack_dbl_buf (clk_ack_rd),
    .rd_int_dbl_buf     (clk_int_rd),
    ); */

   i2c_buf #(`CLK_IOB_WIDTH,64,`UCB_64PAY_PKT_WIDTH,`UCB_INT_PKT_WIDTH) clk_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .iob_ucb_stall			(iob_clk_stall),	 // Templated
      .req_ack_obj			(clk_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .req_ack_vld			(clk_ack_vld),		 // Templated
      .int_obj				(clk_int_packet[`UCB_INT_PKT_WIDTH-1:0]), // Templated
      .int_vld				(clk_int_vld),		 // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .ucb_iob_vld			(clk_iob_vld),		 // Templated
      .ucb_iob_data			(clk_iob_data[`CLK_IOB_WIDTH-1:0]), // Templated
      .rd_req_ack_dbl_buf		(clk_ack_rd),		 // Templated
      .rd_int_dbl_buf			(clk_int_rd));		 // Templated

   
   /*****************************************************************
    * inbound dram0 ucb buffers
    *****************************************************************/
   /* i2c_buf AUTO_TEMPLATE (
     // Outputs
    .iob_ucb_stall      (iob_dram02_stall),
    .req_ack_obj        (dram0_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .req_ack_vld        (dram0_ack_vld),
    .int_obj            (dram0_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
    .int_vld            (dram0_int_vld),
    // Inputs
    .ucb_iob_vld        (dram02_iob_vld),
    .ucb_iob_data       (dram02_iob_data[`DRAM_IOB_WIDTH-1:0]),
    .rd_req_ack_dbl_buf (dram0_ack_rd),
    .rd_int_dbl_buf     (dram0_int_rd),
    ); */

   i2c_buf #(`DRAM_IOB_WIDTH,64,`UCB_64PAY_PKT_WIDTH,`UCB_INT_PKT_WIDTH) dram0_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .iob_ucb_stall			(iob_dram02_stall),	 // Templated
      .req_ack_obj			(dram0_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .req_ack_vld			(dram0_ack_vld),	 // Templated
      .int_obj				(dram0_int_packet[`UCB_INT_PKT_WIDTH-1:0]), // Templated
      .int_vld				(dram0_int_vld),	 // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .ucb_iob_vld			(dram02_iob_vld),	 // Templated
      .ucb_iob_data			(dram02_iob_data[`DRAM_IOB_WIDTH-1:0]), // Templated
      .rd_req_ack_dbl_buf		(dram0_ack_rd),		 // Templated
      .rd_int_dbl_buf			(dram0_int_rd));		 // Templated

   
   /*****************************************************************
    * inbound dram1 ucb buffers
    *****************************************************************/
   /* i2c_buf AUTO_TEMPLATE (
     // Outputs
    .iob_ucb_stall      (iob_dram13_stall),
    .req_ack_obj        (dram1_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .req_ack_vld        (dram1_ack_vld),
    .int_obj            (dram1_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
    .int_vld            (dram1_int_vld),
    // Inputs
    .ucb_iob_vld        (dram13_iob_vld),
    .ucb_iob_data       (dram13_iob_data[`DRAM_IOB_WIDTH-1:0]),
    .rd_req_ack_dbl_buf (dram1_ack_rd),
    .rd_int_dbl_buf     (dram1_int_rd),
    ); */

   i2c_buf #(`DRAM_IOB_WIDTH,64,`UCB_64PAY_PKT_WIDTH,`UCB_INT_PKT_WIDTH) dram1_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .iob_ucb_stall			(iob_dram13_stall),	 // Templated
      .req_ack_obj			(dram1_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .req_ack_vld			(dram1_ack_vld),	 // Templated
      .int_obj				(dram1_int_packet[`UCB_INT_PKT_WIDTH-1:0]), // Templated
      .int_vld				(dram1_int_vld),	 // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .ucb_iob_vld			(dram13_iob_vld),	 // Templated
      .ucb_iob_data			(dram13_iob_data[`DRAM_IOB_WIDTH-1:0]), // Templated
      .rd_req_ack_dbl_buf		(dram1_ack_rd),		 // Templated
      .rd_int_dbl_buf			(dram1_int_rd));		 // Templated

   
   /*****************************************************************
    * inbound spi ucb buffers
    *****************************************************************/
   /* i2c_buf AUTO_TEMPLATE (
     // Outputs
    .iob_ucb_stall      (iob_jbi_spi_stall),
    .req_ack_obj        (spi_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
    .req_ack_vld        (spi_ack_vld),
    .int_obj            (spi_int_packet[`UCB_INT_PKT_WIDTH-1:0]),
    .int_vld            (spi_int_vld),
    // Inputs
    .ucb_iob_vld        (jbi_iob_spi_vld),
    .ucb_iob_data       (jbi_iob_spi_data[`SPI_IOB_WIDTH-1:0]),
    .rd_req_ack_dbl_buf (spi_ack_rd),
    .rd_int_dbl_buf     (spi_int_rd),
    ); */

   i2c_buf #(`SPI_IOB_WIDTH,64,`UCB_64PAY_PKT_WIDTH,`UCB_INT_PKT_WIDTH) spi_ucb_buf
     (
      /*AUTOINST*/
      // Outputs
      .iob_ucb_stall			(iob_jbi_spi_stall),	 // Templated
      .req_ack_obj			(spi_ack_packet[`UCB_64PAY_PKT_WIDTH-1:0]), // Templated
      .req_ack_vld			(spi_ack_vld),		 // Templated
      .int_obj				(spi_int_packet[`UCB_INT_PKT_WIDTH-1:0]), // Templated
      .int_vld				(spi_int_vld),		 // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .ucb_iob_vld			(jbi_iob_spi_vld),	 // Templated
      .ucb_iob_data			(jbi_iob_spi_data[`SPI_IOB_WIDTH-1:0]), // Templated
      .rd_req_ack_dbl_buf		(spi_ack_rd),		 // Templated
      .rd_int_dbl_buf			(spi_int_rd));		 // Templated

   
   /*****************************************************************
    * jbus interrupt buffer
    *****************************************************************/
   /* iobdg_jbus_mondo_buf AUTO_TEMPLATE (
    // Outputs
    .mondo_vld		(jbi_mondo_vld),
    .mondo_data0	(jbi_mondo_data0[63:0]),
    .mondo_data1	(jbi_mondo_data1[63:0]),
    .mondo_target	(jbi_mondo_target[`JBI_IOB_MONDO_TRG_WIDTH-1:0]),
    .mondo_source	(jbi_mondo_source[`JBI_IOB_MONDO_SRC_WIDTH-1:0]),
    // Inputs
    .jbi_iob_vld	(jbi_iob_mondo_vld),
    .jbi_iob_data	(jbi_iob_mondo_data[`JBI_IOB_MONDO_BUS_WIDTH-1:0]),
    .rd_mondo_buf	(jbi_mondo_rd),
    ); */

   iobdg_jbus_mondo_buf jbus_mondo_buf
     (
      /*AUTOINST*/
      // Outputs
      .mondo_vld			(jbi_mondo_vld),	 // Templated
      .mondo_data0			(jbi_mondo_data0[63:0]), // Templated
      .mondo_data1			(jbi_mondo_data1[63:0]), // Templated
      .mondo_target			(jbi_mondo_target[`JBI_IOB_MONDO_TRG_WIDTH-1:0]), // Templated
      .mondo_source			(jbi_mondo_source[`JBI_IOB_MONDO_SRC_WIDTH-1:0]), // Templated
      // Inputs
      .rst_l				(rst_l),
      .clk				(clk),
      .jbi_iob_vld			(jbi_iob_mondo_vld),	 // Templated
      .jbi_iob_data			(jbi_iob_mondo_data[`JBI_IOB_MONDO_BUS_WIDTH-1:0]), // Templated
      .rd_mondo_buf			(jbi_mondo_rd));		 // Templated
      
endmodule // i2c


// Local Variables:
// verilog-library-directories:("." "../../common/rtl" "../../../common/rtl" "../../../common/dolphin/rtl")
// End:
