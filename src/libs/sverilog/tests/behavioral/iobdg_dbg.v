// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_dbg.v
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
//  Module Name:	iobdg_dbg (IO Bridge debug/visibility)
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
module iobdg_dbg (/*AUTOARG*/
   // Outputs
   l2_vis_buf_wr_lo_l, l2_vis_buf_wr_hi_l, l2_vis_buf_tail_ptr, 
   l2_vis_buf_rd_lo_l, l2_vis_buf_rd_hi_l, l2_vis_buf_head_ptr, 
   l2_vis_buf_din_lo, l2_vis_buf_din_hi, l2_vis_armin, 
   iob_jbi_dbg_lo_vld, iob_jbi_dbg_lo_data, iob_jbi_dbg_hi_vld, 
   iob_jbi_dbg_hi_data, iob_io_dbg_en, iob_io_dbg_data, 
   iob_io_dbg_ck_p, iob_io_dbg_ck_n, iob_clk_tr, iob_clk_l2_tr, 
   // Inputs
   ucb_buf_acpt, tx_sync, tap_iob_vld, tap_iob_stall, tap_iob_data, 
   rx_sync, rst_l, l2_vis_buf_dout_lo, l2_vis_buf_dout_hi, 
   l2_dbgbus_23, l2_dbgbus_01, jbi_iob_spi_vld, jbi_iob_spi_stall, 
   jbi_iob_spi_data, jbi_iob_pio_vld, jbi_iob_pio_stall, 
   jbi_iob_pio_data, iob_tap_vld, iob_tap_stall, iob_tap_data, 
   iob_jbi_spi_vld, iob_jbi_spi_stall, iob_jbi_spi_data, 
   iob_jbi_pio_vld, iob_jbi_pio_stall, iob_jbi_pio_data, 
   iob_dram13_vld, iob_dram13_stall, iob_dram13_data, iob_dram02_vld, 
   iob_dram02_stall, iob_dram02_data, iob_clk_vld, iob_clk_stall, 
   iob_clk_data, io_trigin, dram13_iob_vld, dram13_iob_stall, 
   dram13_iob_data, dram02_iob_vld, dram02_iob_stall, 
   dram02_iob_data, dbg_en_23, dbg_en_01, 
   creg_dbg_l2_vis_trig_delay_s, creg_dbg_l2_vis_maskb_s, 
   creg_dbg_l2_vis_maska_s, creg_dbg_l2_vis_ctrl, 
   creg_dbg_l2_vis_cmpb_s, creg_dbg_l2_vis_cmpa_s, 
   creg_dbg_jbus_lo_mask1, creg_dbg_jbus_lo_mask0, 
   creg_dbg_jbus_lo_cnt1, creg_dbg_jbus_lo_cnt0, 
   creg_dbg_jbus_lo_cmp1, creg_dbg_jbus_lo_cmp0, 
   creg_dbg_jbus_hi_mask1, creg_dbg_jbus_hi_mask0, 
   creg_dbg_jbus_hi_cnt1, creg_dbg_jbus_hi_cnt0, 
   creg_dbg_jbus_hi_cmp1, creg_dbg_jbus_hi_cmp0, creg_dbg_jbus_ctrl, 
   creg_dbg_iob_vis_ctrl, creg_dbg_enet_idleval, creg_dbg_enet_ctrl, 
   cpu_rst_l, cpu_clk, clk_iob_vld, clk_iob_stall, clk_iob_data, clk, 
   c2i_packet
   );

////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input [`UCB_64PAY_PKT_WIDTH-1:0]c2i_packet;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		clk;			// To iobdg_dbg_iob of iobdg_dbg_iob.v, ...
   input [`CLK_IOB_WIDTH-1:0]clk_iob_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		clk_iob_stall;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		clk_iob_vld;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		cpu_clk;		// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input		cpu_rst_l;		// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [63:0]		creg_dbg_enet_ctrl;	// To iobdg_dbg_porta of iobdg_dbg_porta.v
   input [63:0]		creg_dbg_enet_idleval;	// To iobdg_dbg_porta of iobdg_dbg_porta.v
   input [63:0]		creg_dbg_iob_vis_ctrl;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [63:0]		creg_dbg_jbus_ctrl;	// To iobdg_dbg_portb_hi of iobdg_dbg_portb.v, ...
   input [63:0]		creg_dbg_jbus_hi_cmp0;	// To iobdg_dbg_portb_hi of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_hi_cmp1;	// To iobdg_dbg_portb_hi of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_hi_cnt0;	// To iobdg_dbg_portb_hi of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_hi_cnt1;	// To iobdg_dbg_portb_hi of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_hi_mask0;	// To iobdg_dbg_portb_hi of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_hi_mask1;	// To iobdg_dbg_portb_hi of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_lo_cmp0;	// To iobdg_dbg_portb_lo of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_lo_cmp1;	// To iobdg_dbg_portb_lo of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_lo_cnt0;	// To iobdg_dbg_portb_lo of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_lo_cnt1;	// To iobdg_dbg_portb_lo of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_lo_mask0;	// To iobdg_dbg_portb_lo of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_jbus_lo_mask1;	// To iobdg_dbg_portb_lo of iobdg_dbg_portb.v
   input [63:0]		creg_dbg_l2_vis_cmpa_s;	// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [63:0]		creg_dbg_l2_vis_cmpb_s;	// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [63:0]		creg_dbg_l2_vis_ctrl;	// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [63:0]		creg_dbg_l2_vis_maska_s;// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [63:0]		creg_dbg_l2_vis_maskb_s;// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [63:0]		creg_dbg_l2_vis_trig_delay_s;// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input		dbg_en_01;		// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input		dbg_en_23;		// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [`DRAM_IOB_WIDTH-1:0]dram02_iob_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		dram02_iob_stall;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		dram02_iob_vld;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [`DRAM_IOB_WIDTH-1:0]dram13_iob_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		dram13_iob_stall;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		dram13_iob_vld;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		io_trigin;		// To iobdg_dbg_porta of iobdg_dbg_porta.v
   input [`IOB_CLK_WIDTH-1:0]iob_clk_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_clk_stall;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_clk_vld;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [`IOB_DRAM_WIDTH-1:0]iob_dram02_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_dram02_stall;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_dram02_vld;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [`IOB_DRAM_WIDTH-1:0]iob_dram13_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_dram13_stall;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_dram13_vld;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [`IOB_JBI_WIDTH-1:0]iob_jbi_pio_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_jbi_pio_stall;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_jbi_pio_vld;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [`IOB_SPI_WIDTH-1:0]iob_jbi_spi_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_jbi_spi_stall;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_jbi_spi_vld;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [`IOB_TAP_WIDTH-1:0]iob_tap_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_tap_stall;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		iob_tap_vld;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [`JBI_IOB_WIDTH-1:0]jbi_iob_pio_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		jbi_iob_pio_stall;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		jbi_iob_pio_vld;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [`SPI_IOB_WIDTH-1:0]jbi_iob_spi_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		jbi_iob_spi_stall;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		jbi_iob_spi_vld;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input [39:0]		l2_dbgbus_01;		// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [39:0]		l2_dbgbus_23;		// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [64:0]		l2_vis_buf_dout_hi;	// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [64:0]		l2_vis_buf_dout_lo;	// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input		rst_l;			// To iobdg_dbg_iob of iobdg_dbg_iob.v, ...
   input		rx_sync;		// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input [`TAP_IOB_WIDTH-1:0]tap_iob_data;	// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		tap_iob_stall;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		tap_iob_vld;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   input		tx_sync;		// To iobdg_dbg_l2 of iobdg_dbg_l2.v
   input		ucb_buf_acpt;		// To iobdg_dbg_iob of iobdg_dbg_iob.v
   // End of automatics

   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		iob_clk_l2_tr;		// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   output		iob_clk_tr;		// From iobdg_dbg_porta of iobdg_dbg_porta.v
   output [2:0]		iob_io_dbg_ck_n;	// From iobdg_dbg_porta of iobdg_dbg_porta.v
   output [2:0]		iob_io_dbg_ck_p;	// From iobdg_dbg_porta of iobdg_dbg_porta.v
   output [39:0]	iob_io_dbg_data;	// From iobdg_dbg_porta of iobdg_dbg_porta.v
   output		iob_io_dbg_en;		// From iobdg_dbg_porta of iobdg_dbg_porta.v
   output [47:0]	iob_jbi_dbg_hi_data;	// From iobdg_dbg_portb_hi of iobdg_dbg_portb.v
   output		iob_jbi_dbg_hi_vld;	// From iobdg_dbg_portb_hi of iobdg_dbg_portb.v
   output [47:0]	iob_jbi_dbg_lo_data;	// From iobdg_dbg_portb_lo of iobdg_dbg_portb.v
   output		iob_jbi_dbg_lo_vld;	// From iobdg_dbg_portb_lo of iobdg_dbg_portb.v
   output		l2_vis_armin;		// From iobdg_dbg_porta of iobdg_dbg_porta.v
   output [64:0]	l2_vis_buf_din_hi;	// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   output [64:0]	l2_vis_buf_din_lo;	// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   output [`IOB_L2_VIS_BUF_INDEX-1:0]l2_vis_buf_head_ptr;// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   output		l2_vis_buf_rd_hi_l;	// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   output		l2_vis_buf_rd_lo_l;	// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   output [`IOB_L2_VIS_BUF_INDEX-1:0]l2_vis_buf_tail_ptr;// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   output		l2_vis_buf_wr_hi_l;	// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   output		l2_vis_buf_wr_lo_l;	// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   // End of automatics

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [43:0]		iob_dbg_bus;		// From iobdg_dbg_iob of iobdg_dbg_iob.v
   wire [39:0]		l2_dbg_data;		// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   wire			l2_dbg_vld;		// From iobdg_dbg_l2 of iobdg_dbg_l2.v
   // End of automatics

   wire [`IOB_JBI_WIDTH-1:0] iob_jbi_pio_data_d1;
   wire [`JBI_IOB_WIDTH-1:0] jbi_iob_pio_data_d1;
       
   wire [5:0] 		iob_vld_bus;
   wire [5:0] 		iob_stall_bus;
   wire [5:0] 		iob_vld_bus_d1;
   wire [5:0] 		iob_stall_bus_d1;
   wire [5:0] 		iob_vld_qual_bus;
   wire [5:0] 		iob_soh_bus;
   
   wire [7:0]		l2_dbg_tstamp;

   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /*****************************************************************
    * IOB debug mux
    *****************************************************************/
   iobdg_dbg_iob iobdg_dbg_iob (.iob_jbi_pio_data_d1(iob_jbi_pio_data_d1[`IOB_JBI_WIDTH-1:0]),
				.jbi_iob_pio_data_d1(jbi_iob_pio_data_d1[`JBI_IOB_WIDTH-1:0]),
		                /*AUTOINST*/
				// Outputs
				.iob_dbg_bus(iob_dbg_bus[43:0]),
				// Inputs
				.rst_l	(rst_l),
				.clk	(clk),
				.c2i_packet(c2i_packet[`UCB_64PAY_PKT_WIDTH-1:0]),
				.ucb_buf_acpt(ucb_buf_acpt),
				.creg_dbg_iob_vis_ctrl(creg_dbg_iob_vis_ctrl[63:0]),
				.iob_clk_vld(iob_clk_vld),
				.iob_clk_data(iob_clk_data[`IOB_CLK_WIDTH-1:0]),
				.clk_iob_stall(clk_iob_stall),
				.iob_dram02_vld(iob_dram02_vld),
				.iob_dram02_data(iob_dram02_data[`IOB_DRAM_WIDTH-1:0]),
				.dram02_iob_stall(dram02_iob_stall),
				.iob_dram13_vld(iob_dram13_vld),
				.iob_dram13_data(iob_dram13_data[`IOB_DRAM_WIDTH-1:0]),
				.dram13_iob_stall(dram13_iob_stall),
				.iob_jbi_pio_vld(iob_jbi_pio_vld),
				.iob_jbi_pio_data(iob_jbi_pio_data[`IOB_JBI_WIDTH-1:0]),
				.jbi_iob_pio_stall(jbi_iob_pio_stall),
				.iob_jbi_spi_vld(iob_jbi_spi_vld),
				.iob_jbi_spi_data(iob_jbi_spi_data[`IOB_SPI_WIDTH-1:0]),
				.jbi_iob_spi_stall(jbi_iob_spi_stall),
				.iob_tap_vld(iob_tap_vld),
				.iob_tap_data(iob_tap_data[`IOB_TAP_WIDTH-1:0]),
				.tap_iob_stall(tap_iob_stall),
				.clk_iob_vld(clk_iob_vld),
				.clk_iob_data(clk_iob_data[`CLK_IOB_WIDTH-1:0]),
				.iob_clk_stall(iob_clk_stall),
				.dram02_iob_vld(dram02_iob_vld),
				.dram02_iob_data(dram02_iob_data[`DRAM_IOB_WIDTH-1:0]),
				.iob_dram02_stall(iob_dram02_stall),
				.dram13_iob_vld(dram13_iob_vld),
				.dram13_iob_data(dram13_iob_data[`DRAM_IOB_WIDTH-1:0]),
				.iob_dram13_stall(iob_dram13_stall),
				.jbi_iob_pio_vld(jbi_iob_pio_vld),
				.jbi_iob_pio_data(jbi_iob_pio_data[`JBI_IOB_WIDTH-1:0]),
				.iob_jbi_pio_stall(iob_jbi_pio_stall),
				.jbi_iob_spi_vld(jbi_iob_spi_vld),
				.jbi_iob_spi_data(jbi_iob_spi_data[`SPI_IOB_WIDTH-1:0]),
				.iob_jbi_spi_stall(iob_jbi_spi_stall),
				.tap_iob_vld(tap_iob_vld),
				.tap_iob_data(tap_iob_data[`TAP_IOB_WIDTH-1:0]),
				.iob_tap_stall(iob_tap_stall));

   assign 	       iob_vld_bus = {iob_dbg_bus[43],
				      iob_dbg_bus[41],
				      iob_dbg_bus[39],
				      iob_dbg_bus[37],
				      iob_dbg_bus[35],
				      iob_dbg_bus[33]};
   
   assign 	       iob_stall_bus = {iob_dbg_bus[42],
					iob_dbg_bus[40],
					iob_dbg_bus[38],
					iob_dbg_bus[36],
					iob_dbg_bus[34],
					iob_dbg_bus[32]};
   
   dff_ns #(6) iob_vld_bus_d1_ff (.din(iob_vld_bus),
				  .clk(clk),
				  .q(iob_vld_bus_d1));
   
   dff_ns #(6) iob_stall_bus_d1_ff (.din(iob_stall_bus),
				    .clk(clk),
				    .q(iob_stall_bus_d1));
   
   assign 	       iob_vld_qual_bus = iob_vld_bus & ~iob_stall_bus_d1;

   assign 	       iob_soh_bus = ~iob_vld_bus_d1 & iob_vld_bus;
   
   
   /*****************************************************************
    * L2 debug filter/buffer
    *****************************************************************/
    /* iobdg_dbg_l2 AUTO_TEMPLATE (
     // Outputs
     .l2_dbg_tstamp      ({l2_dbg_tstamp[7:0]}),
     // Inputs
     ); */
   iobdg_dbg_l2 iobdg_dbg_l2 (
		              /*AUTOINST*/
			      // Outputs
			      .l2_dbg_vld(l2_dbg_vld),
			      .l2_dbg_tstamp({l2_dbg_tstamp[7:0]}), // Templated
			      .l2_dbg_data(l2_dbg_data[39:0]),
			      .iob_clk_l2_tr(iob_clk_l2_tr),
			      .l2_vis_buf_wr_lo_l(l2_vis_buf_wr_lo_l),
			      .l2_vis_buf_wr_hi_l(l2_vis_buf_wr_hi_l),
			      .l2_vis_buf_rd_lo_l(l2_vis_buf_rd_lo_l),
			      .l2_vis_buf_rd_hi_l(l2_vis_buf_rd_hi_l),
			      .l2_vis_buf_tail_ptr(l2_vis_buf_tail_ptr[`IOB_L2_VIS_BUF_INDEX-1:0]),
			      .l2_vis_buf_head_ptr(l2_vis_buf_head_ptr[`IOB_L2_VIS_BUF_INDEX-1:0]),
			      .l2_vis_buf_din_lo(l2_vis_buf_din_lo[64:0]),
			      .l2_vis_buf_din_hi(l2_vis_buf_din_hi[64:0]),
			      // Inputs
			      .cpu_rst_l(cpu_rst_l),
			      .rst_l	(rst_l),
			      .cpu_clk	(cpu_clk),
			      .clk	(clk),
			      .tx_sync	(tx_sync),
			      .rx_sync	(rx_sync),
			      .l2_dbgbus_01(l2_dbgbus_01[39:0]),
			      .l2_dbgbus_23(l2_dbgbus_23[39:0]),
			      .dbg_en_01(dbg_en_01),
			      .dbg_en_23(dbg_en_23),
			      .creg_dbg_l2_vis_ctrl(creg_dbg_l2_vis_ctrl[63:0]),
			      .creg_dbg_l2_vis_maska_s(creg_dbg_l2_vis_maska_s[63:0]),
			      .creg_dbg_l2_vis_cmpa_s(creg_dbg_l2_vis_cmpa_s[63:0]),
			      .creg_dbg_l2_vis_maskb_s(creg_dbg_l2_vis_maskb_s[63:0]),
			      .creg_dbg_l2_vis_cmpb_s(creg_dbg_l2_vis_cmpb_s[63:0]),
			      .creg_dbg_l2_vis_trig_delay_s(creg_dbg_l2_vis_trig_delay_s[63:0]),
			      .l2_vis_buf_dout_lo(l2_vis_buf_dout_lo[64:0]),
			      .l2_vis_buf_dout_hi(l2_vis_buf_dout_hi[64:0]));


   /*****************************************************************
    * Debug Port A
    *****************************************************************/
    /* iobdg_dbg_porta AUTO_TEMPLATE (
     // Outputs
     // Inputs
     .src0_data          (l2_dbg_data[39:0]),
     .src1_data          ({l2_dbg_data[39:30],l2_dbg_tstamp[7:0],l2_dbg_data[21:0]}),
     .src2_data          (iob_dbg_bus[39:0]),
     .src3_data          ({1'b0,|iob_soh_bus[5:0],iob_vld_qual_bus[5:0],iob_dbg_bus[31:0]}),
     .src4_data          ({iob_dbg_bus[39:35],iob_dbg_bus[41],iob_dbg_bus[33:0]}),
     .src0_vld           (l2_dbg_vld),
     .src1_vld           (l2_dbg_vld),
     .src2_vld           (1'b1),
     .src3_vld           ({|iob_vld_qual_bus[5:0]}),
     .src4_vld           (iob_dbg_bus[43]),
     ); */

   iobdg_dbg_porta iobdg_dbg_porta (
				    /*AUTOINST*/
				    // Outputs
				    .iob_io_dbg_data(iob_io_dbg_data[39:0]),
				    .iob_io_dbg_en(iob_io_dbg_en),
				    .iob_io_dbg_ck_p(iob_io_dbg_ck_p[2:0]),
				    .iob_io_dbg_ck_n(iob_io_dbg_ck_n[2:0]),
				    .l2_vis_armin(l2_vis_armin),
				    .iob_clk_tr(iob_clk_tr),
				    // Inputs
				    .rst_l(rst_l),
				    .clk(clk),
				    .src0_data(l2_dbg_data[39:0]), // Templated
				    .src1_data({l2_dbg_data[39:30],l2_dbg_tstamp[7:0],l2_dbg_data[21:0]}), // Templated
				    .src2_data(iob_dbg_bus[39:0]), // Templated
				    .src3_data({1'b0,|iob_soh_bus[5:0],iob_vld_qual_bus[5:0],iob_dbg_bus[31:0]}), // Templated
				    .src4_data({iob_dbg_bus[39:35],iob_dbg_bus[41],iob_dbg_bus[33:0]}), // Templated
				    .src0_vld(l2_dbg_vld),	 // Templated
				    .src1_vld(l2_dbg_vld),	 // Templated
				    .src2_vld(1'b1),		 // Templated
				    .src3_vld({|iob_vld_qual_bus[5:0]}), // Templated
				    .src4_vld(iob_dbg_bus[43]),	 // Templated
				    .creg_dbg_enet_ctrl(creg_dbg_enet_ctrl[63:0]),
				    .creg_dbg_enet_idleval(creg_dbg_enet_idleval[63:0]),
				    .io_trigin(io_trigin));

   
   /*****************************************************************
    * Debug Port B Hi
    *****************************************************************/
    /* iobdg_dbg_portb AUTO_TEMPLATE (
     // Outputs
     .dbg_data           (iob_jbi_dbg_hi_data[47:0]),
     .dbg_vld            (iob_jbi_dbg_hi_vld),
     // Inputs
     .src0_data          ({l2_dbg_vld,l2_dbg_tstamp[7:0],l2_dbg_data[39:0]}),
     .src2_data          ({iob_vld_qual_bus[4],4'b0,iob_soh_bus[5:4],iob_vld_qual_bus[5:4],iob_dbg_bus[39:0]}),
     .src3_data          ({iob_vld_qual_bus[4],4'b0,iob_soh_bus[5:4],iob_vld_qual_bus[5:4],iob_soh_bus[3:0],iob_vld_qual_bus[3:0],iob_dbg_bus[31:0]}),
     .src4_data          ({iob_dbg_bus[40],4'b0,iob_dbg_bus[43:0]}),
     .src0_vld           (l2_dbg_vld),
     .src2_vld           ({|iob_vld_qual_bus[5:4]}),
     .src3_vld           ({|iob_vld_qual_bus[5:0]}),
     .src4_vld           (1'b1),
     .i_am_hi            (1'b1),
     .creg_dbg_jbus_ctrl (creg_dbg_jbus_ctrl[63:0]),
     .creg_dbg_jbus_mask0(creg_dbg_jbus_hi_mask0[63:0]),
     .creg_dbg_jbus_cmp0 (creg_dbg_jbus_hi_cmp0[63:0]),
     .creg_dbg_jbus_cnt0 (creg_dbg_jbus_hi_cnt0[63:0]),
     .creg_dbg_jbus_mask1(creg_dbg_jbus_hi_mask1[63:0]),
     .creg_dbg_jbus_cmp1 (creg_dbg_jbus_hi_cmp1[63:0]),
     .creg_dbg_jbus_cnt1 (creg_dbg_jbus_hi_cnt1[63:0]),
     ); */

   iobdg_dbg_portb iobdg_dbg_portb_hi (
				       /*AUTOINST*/
				       // Outputs
				       .dbg_data(iob_jbi_dbg_hi_data[47:0]), // Templated
				       .dbg_vld(iob_jbi_dbg_hi_vld), // Templated
				       // Inputs
				       .rst_l(rst_l),
				       .clk(clk),
				       .src0_data({l2_dbg_vld,l2_dbg_tstamp[7:0],l2_dbg_data[39:0]}), // Templated
				       .src2_data({iob_vld_qual_bus[4],4'b0,iob_soh_bus[5:4],iob_vld_qual_bus[5:4],iob_dbg_bus[39:0]}), // Templated
				       .src3_data({iob_vld_qual_bus[4],4'b0,iob_soh_bus[5:4],iob_vld_qual_bus[5:4],iob_soh_bus[3:0],iob_vld_qual_bus[3:0],iob_dbg_bus[31:0]}), // Templated
				       .src4_data({iob_dbg_bus[40],4'b0,iob_dbg_bus[43:0]}), // Templated
				       .src0_vld(l2_dbg_vld),	 // Templated
				       .src2_vld({|iob_vld_qual_bus[5:4]}), // Templated
				       .src3_vld({|iob_vld_qual_bus[5:0]}), // Templated
				       .src4_vld(1'b1),		 // Templated
				       .i_am_hi(1'b1),		 // Templated
				       .creg_dbg_jbus_ctrl(creg_dbg_jbus_ctrl[63:0]), // Templated
				       .creg_dbg_jbus_mask0(creg_dbg_jbus_hi_mask0[63:0]), // Templated
				       .creg_dbg_jbus_cmp0(creg_dbg_jbus_hi_cmp0[63:0]), // Templated
				       .creg_dbg_jbus_cnt0(creg_dbg_jbus_hi_cnt0[63:0]), // Templated
				       .creg_dbg_jbus_mask1(creg_dbg_jbus_hi_mask1[63:0]), // Templated
				       .creg_dbg_jbus_cmp1(creg_dbg_jbus_hi_cmp1[63:0]), // Templated
				       .creg_dbg_jbus_cnt1(creg_dbg_jbus_hi_cnt1[63:0])); // Templated

   
   /*****************************************************************
    * Debug Port B Lo
    *****************************************************************/
    /* iobdg_dbg_portb AUTO_TEMPLATE (
     // Outputs
     .dbg_data           (iob_jbi_dbg_lo_data[47:0]),
     .dbg_vld            (iob_jbi_dbg_lo_vld),
     // Inputs
     .src0_data          ({l2_dbg_vld,l2_dbg_tstamp[7:0],l2_dbg_data[39:0]}),
     .src2_data          ({iob_vld_qual_bus[4],4'b0,iob_soh_bus[5:4],iob_vld_qual_bus[5:4],jbi_iob_pio_data_d1[7:0],iob_jbi_pio_data_d1[31:0]}),
     .src3_data          ({iob_vld_qual_bus[4],4'b0,iob_soh_bus[5:4],iob_vld_qual_bus[5:4],iob_soh_bus[3:0],iob_vld_qual_bus[3:0],iob_dbg_bus[31:0]}),
     .src4_data          ({iob_dbg_bus[40],4'b0,iob_dbg_bus[43:0]}),
     .src0_vld           (l2_dbg_vld),
     .src2_vld           ({|iob_vld_qual_bus[5:4]}),
     .src3_vld           ({|iob_vld_qual_bus[5:0]}),
     .src4_vld           (1'b1),
     .i_am_hi            (1'b0),
     .creg_dbg_jbus_ctrl (creg_dbg_jbus_ctrl[63:0]),
     .creg_dbg_jbus_mask0(creg_dbg_jbus_lo_mask0[63:0]),
     .creg_dbg_jbus_cmp0 (creg_dbg_jbus_lo_cmp0[63:0]),
     .creg_dbg_jbus_cnt0 (creg_dbg_jbus_lo_cnt0[63:0]),
     .creg_dbg_jbus_mask1(creg_dbg_jbus_lo_mask1[63:0]),
     .creg_dbg_jbus_cmp1 (creg_dbg_jbus_lo_cmp1[63:0]),
     .creg_dbg_jbus_cnt1 (creg_dbg_jbus_lo_cnt1[63:0]),
     ); */

   iobdg_dbg_portb iobdg_dbg_portb_lo (
				       /*AUTOINST*/
				       // Outputs
				       .dbg_data(iob_jbi_dbg_lo_data[47:0]), // Templated
				       .dbg_vld(iob_jbi_dbg_lo_vld), // Templated
				       // Inputs
				       .rst_l(rst_l),
				       .clk(clk),
				       .src0_data({l2_dbg_vld,l2_dbg_tstamp[7:0],l2_dbg_data[39:0]}), // Templated
				       .src2_data({iob_vld_qual_bus[4],4'b0,iob_soh_bus[5:4],iob_vld_qual_bus[5:4],jbi_iob_pio_data_d1[7:0],iob_jbi_pio_data_d1[31:0]}), // Templated
				       .src3_data({iob_vld_qual_bus[4],4'b0,iob_soh_bus[5:4],iob_vld_qual_bus[5:4],iob_soh_bus[3:0],iob_vld_qual_bus[3:0],iob_dbg_bus[31:0]}), // Templated
				       .src4_data({iob_dbg_bus[40],4'b0,iob_dbg_bus[43:0]}), // Templated
				       .src0_vld(l2_dbg_vld),	 // Templated
				       .src2_vld({|iob_vld_qual_bus[5:4]}), // Templated
				       .src3_vld({|iob_vld_qual_bus[5:0]}), // Templated
				       .src4_vld(1'b1),		 // Templated
				       .i_am_hi(1'b0),		 // Templated
				       .creg_dbg_jbus_ctrl(creg_dbg_jbus_ctrl[63:0]), // Templated
				       .creg_dbg_jbus_mask0(creg_dbg_jbus_lo_mask0[63:0]), // Templated
				       .creg_dbg_jbus_cmp0(creg_dbg_jbus_lo_cmp0[63:0]), // Templated
				       .creg_dbg_jbus_cnt0(creg_dbg_jbus_lo_cnt0[63:0]), // Templated
				       .creg_dbg_jbus_mask1(creg_dbg_jbus_lo_mask1[63:0]), // Templated
				       .creg_dbg_jbus_cmp1(creg_dbg_jbus_lo_cmp1[63:0]), // Templated
				       .creg_dbg_jbus_cnt1(creg_dbg_jbus_lo_cnt1[63:0])); // Templated

   
endmodule // iobdg_dbg


// Local Variables:
// verilog-library-directories:("." "../../common/rtl")
// End:



