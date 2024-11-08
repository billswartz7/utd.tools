// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_dbg_iob.v
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
//  Module Name:	iobdg_dbg_iob (IO Bridge debug/visibility)
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
module iobdg_dbg_iob (/*AUTOARG*/
   // Outputs
   iob_dbg_bus, iob_jbi_pio_data_d1, jbi_iob_pio_data_d1, 
   // Inputs
   rst_l, clk, c2i_packet, ucb_buf_acpt, creg_dbg_iob_vis_ctrl, 
   iob_clk_vld, iob_clk_data, clk_iob_stall, iob_dram02_vld, 
   iob_dram02_data, dram02_iob_stall, iob_dram13_vld, 
   iob_dram13_data, dram13_iob_stall, iob_jbi_pio_vld, 
   iob_jbi_pio_data, jbi_iob_pio_stall, iob_jbi_spi_vld, 
   iob_jbi_spi_data, jbi_iob_spi_stall, iob_tap_vld, iob_tap_data, 
   tap_iob_stall, clk_iob_vld, clk_iob_data, iob_clk_stall, 
   dram02_iob_vld, dram02_iob_data, iob_dram02_stall, dram13_iob_vld, 
   dram13_iob_data, iob_dram13_stall, jbi_iob_pio_vld, 
   jbi_iob_pio_data, iob_jbi_pio_stall, jbi_iob_spi_vld, 
   jbi_iob_spi_data, iob_jbi_spi_stall, tap_iob_vld, tap_iob_data, 
   iob_tap_stall
   );

////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input                                    rst_l;
   input 				    clk;
   

   // Debug unit interface
   output [43:0] 			    iob_dbg_bus;


   // IOB interface
   input [`UCB_64PAY_PKT_WIDTH-1:0] 	    c2i_packet;
   input 				    ucb_buf_acpt;

   input [63:0] 			    creg_dbg_iob_vis_ctrl;

   
   // UCB interface
   input 				    iob_clk_vld;
   input [`IOB_CLK_WIDTH-1:0] 		    iob_clk_data;
   input 				    clk_iob_stall;
   
   input 				    iob_dram02_vld;
   input [`IOB_DRAM_WIDTH-1:0] 		    iob_dram02_data;
   input 				    dram02_iob_stall;
   
   input 				    iob_dram13_vld;
   input [`IOB_DRAM_WIDTH-1:0] 		    iob_dram13_data;
   input 				    dram13_iob_stall;
   
   input 				    iob_jbi_pio_vld;
   input [`IOB_JBI_WIDTH-1:0] 		    iob_jbi_pio_data;
   input 				    jbi_iob_pio_stall;
   
   input 				    iob_jbi_spi_vld;
   input [`IOB_SPI_WIDTH-1:0] 		    iob_jbi_spi_data;
   input 				    jbi_iob_spi_stall;
   
   input 				    iob_tap_vld;
   input [`IOB_TAP_WIDTH-1:0] 		    iob_tap_data;
   input 				    tap_iob_stall;
   
   input 				    clk_iob_vld;
   input [`CLK_IOB_WIDTH-1:0] 		    clk_iob_data;
   input 				    iob_clk_stall;
   
   input 				    dram02_iob_vld;
   input [`DRAM_IOB_WIDTH-1:0] 		    dram02_iob_data;
   input 				    iob_dram02_stall;
   
   input 				    dram13_iob_vld;
   input [`DRAM_IOB_WIDTH-1:0] 		    dram13_iob_data;
   input 				    iob_dram13_stall;
   
   input 				    jbi_iob_pio_vld;
   input [`JBI_IOB_WIDTH-1:0] 		    jbi_iob_pio_data;
   input 				    iob_jbi_pio_stall;
   
   input 				    jbi_iob_spi_vld;
   input [`SPI_IOB_WIDTH-1:0] 		    jbi_iob_spi_data;
   input 				    iob_jbi_spi_stall;
   
   input 				    tap_iob_vld;
   input [`TAP_IOB_WIDTH-1:0] 		    tap_iob_data;
   input 				    iob_tap_stall;
   

   // Internal signals
   wire [`UCB_64PAY_PKT_WIDTH-1:0] 	    c2i_packet_d1;
   wire 				    ucb_buf_acpt_d1;
   wire [`IOB_ADDR_WIDTH-1:0] 		    c2i_packet_addr_d1;
   wire [`IOB_CPUTHR_INDEX-1:0] 	    c2i_packet_cputhr_d1;
   wire 				    c2i_packet_src_d1;
   reg [1:0] 				    c2i_packet_tt_d1;
   
   wire 				    iob_clk_vld_d1;
   wire [`IOB_CLK_WIDTH-1:0] 		    iob_clk_data_d1;
   wire 				    clk_iob_stall_d1;

   wire 				    iob_dram02_vld_d1;
   wire [`IOB_DRAM_WIDTH-1:0] 		    iob_dram02_data_d1;
   wire 				    dram02_iob_stall_d1;

   wire 				    iob_dram13_vld_d1;
   wire [`IOB_DRAM_WIDTH-1:0] 		    iob_dram13_data_d1;
   wire 				    dram13_iob_stall_d1;

   wire 				    iob_jbi_pio_vld_d1;
   output [`IOB_JBI_WIDTH-1:0] 		    iob_jbi_pio_data_d1; // need to tap this for Port B Low
   wire 				    jbi_iob_pio_stall_d1;
   
   wire 				    iob_jbi_spi_vld_d1;
   wire [`IOB_SPI_WIDTH-1:0] 		    iob_jbi_spi_data_d1;
   wire 				    jbi_iob_spi_stall_d1;

   wire 				    iob_tap_vld_d1;
   wire [`IOB_TAP_WIDTH-1:0] 		    iob_tap_data_d1;
   wire 				    tap_iob_stall_d1;

   wire 				    clk_iob_vld_d1;
   wire [`CLK_IOB_WIDTH-1:0] 		    clk_iob_data_d1;
   wire 				    iob_clk_stall_d1;

   wire 				    dram02_iob_vld_d1;
   wire [`DRAM_IOB_WIDTH-1:0] 		    dram02_iob_data_d1;
   wire 				    iob_dram02_stall_d1;

   wire 				    dram13_iob_vld_d1;
   wire [`DRAM_IOB_WIDTH-1:0] 		    dram13_iob_data_d1;
   wire 				    iob_dram13_stall_d1;
   
   wire 				    jbi_iob_pio_vld_d1;
   output [`JBI_IOB_WIDTH-1:0] 		    jbi_iob_pio_data_d1;  // need to tap this for Port B Low
   wire 				    iob_jbi_pio_stall_d1;

   wire 				    jbi_iob_spi_vld_d1;
   wire [`SPI_IOB_WIDTH-1:0] 		    jbi_iob_spi_data_d1;
   wire 				    iob_jbi_spi_stall_d1;

   wire 				    tap_iob_vld_d1;
   wire [`TAP_IOB_WIDTH-1:0] 		    tap_iob_data_d1;
   wire 				    iob_tap_stall_d1;

   reg [43:0] 				    iob_dbg_bus;

       
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /*****************************************************************
    * Flop c2i packet
    *****************************************************************/
   dff_ns #(`UCB_64PAY_PKT_WIDTH) c2i_packet_d1_ff (.din(c2i_packet),
						    .clk(clk),
						    .q(c2i_packet_d1));
   
   dff_ns #(1) ucb_buf_acpt_d1_ff (.din(ucb_buf_acpt),
				   .clk(clk),
				   .q(ucb_buf_acpt_d1));

   assign 	c2i_packet_addr_d1 = c2i_packet_d1[`UCB_ADDR_HI:`UCB_ADDR_LO];

   assign 	c2i_packet_cputhr_d1 = c2i_packet_d1[`IOB_CPUTHR_INDEX+`UCB_THR_LO-1:`UCB_THR_LO];

   // source
   // 0 = cpu
   // 1 = tap
   assign 	c2i_packet_src_d1 = (c2i_packet_d1[`UCB_BUF_HI:`UCB_BUF_LO] == `UCB_BID_TAP);

   // transaction type
   // 00 = read
   // 01 = write
   // 10 = ifill
   // 11 = others/undefined
   always @(/*AUTOSENSE*/c2i_packet_d1)
     case (c2i_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO])
       `UCB_READ_REQ:  c2i_packet_tt_d1 = 2'b00;
       `UCB_WRITE_REQ: c2i_packet_tt_d1 = 2'b01;
       `UCB_IFILL_REQ: c2i_packet_tt_d1 = 2'b10;
       default:        c2i_packet_tt_d1 = 2'b11;
     endcase // case(c2i_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO])
   

   /*****************************************************************
    * Flop IOB->UCB buses
    *****************************************************************/
   dff_ns #(1) iob_clk_vld_d1_ff (.din(iob_clk_vld),
				  .clk(clk),
				  .q(iob_clk_vld_d1));
   
   dff_ns #(`IOB_CLK_WIDTH) iob_clk_data_d1_ff (.din(iob_clk_data),
						.clk(clk),
						.q(iob_clk_data_d1));

   dff_ns #(1) clk_iob_stall_d1_ff (.din(clk_iob_stall),
				    .clk(clk),
				    .q(clk_iob_stall_d1));
   

   dff_ns #(1) iob_dram02_vld_d1_ff (.din(iob_dram02_vld),
				     .clk(clk),
				     .q(iob_dram02_vld_d1));
   
   dff_ns #(`IOB_DRAM_WIDTH) iob_dram02_data_d1_ff (.din(iob_dram02_data),
						    .clk(clk),
						    .q(iob_dram02_data_d1));

   dff_ns #(1) dram02_iob_stall_d1_ff (.din(dram02_iob_stall),
				       .clk(clk),
				       .q(dram02_iob_stall_d1));
   

   dff_ns #(1) iob_dram13_vld_d1_ff (.din(iob_dram13_vld),
				     .clk(clk),
				     .q(iob_dram13_vld_d1));
   
   dff_ns #(`IOB_DRAM_WIDTH) iob_dram13_data_d1_ff (.din(iob_dram13_data),
						    .clk(clk),
						    .q(iob_dram13_data_d1));

   dff_ns #(1) dram13_iob_stall_d1_ff (.din(dram13_iob_stall),
				       .clk(clk),
				       .q(dram13_iob_stall_d1));
   

   dff_ns #(1) iob_jbi_pio_vld_d1_ff (.din(iob_jbi_pio_vld),
				      .clk(clk),
				      .q(iob_jbi_pio_vld_d1));
   
   dff_ns #(`IOB_JBI_WIDTH) iob_jbi_pio_data_d1_ff (.din(iob_jbi_pio_data),
						    .clk(clk),
						    .q(iob_jbi_pio_data_d1));

   dff_ns #(1) jbi_iob_pio_stall_d1_ff (.din(jbi_iob_pio_stall),
				    	.clk(clk),
				    	.q(jbi_iob_pio_stall_d1));

   
   dff_ns #(1) iob_jbi_spi_vld_d1_ff (.din(iob_jbi_spi_vld),
				      .clk(clk),
				      .q(iob_jbi_spi_vld_d1));
   
   dff_ns #(`IOB_SPI_WIDTH) iob_jbi_spi_data_d1_ff (.din(iob_jbi_spi_data),
						    .clk(clk),
						    .q(iob_jbi_spi_data_d1));

   dff_ns #(1) jbi_iob_spi_stall_d1_ff (.din(jbi_iob_spi_stall),
				    	.clk(clk),
				    	.q(jbi_iob_spi_stall_d1));

   
   dff_ns #(1) iob_tap_vld_d1_ff (.din(iob_tap_vld),
				  .clk(clk),
				  .q(iob_tap_vld_d1));
   
   dff_ns #(`IOB_TAP_WIDTH) iob_tap_data_d1_ff (.din(iob_tap_data),
						.clk(clk),
						.q(iob_tap_data_d1));

   dff_ns #(1) tap_iob_stall_d1_ff (.din(tap_iob_stall),
				    .clk(clk),
				    .q(tap_iob_stall_d1));
   

   /*****************************************************************
    * Flop UCB->IOB buses
    *****************************************************************/
   dff_ns #(1) clk_iob_vld_d1_ff (.din(clk_iob_vld),
				  .clk(clk),
				  .q(clk_iob_vld_d1));
   
   dff_ns #(`CLK_IOB_WIDTH) clk_iob_data_d1_ff (.din(clk_iob_data),
						.clk(clk),
						.q(clk_iob_data_d1));

   dff_ns #(1) iob_clk_stall_d1_ff (.din(iob_clk_stall),
				    .clk(clk),
				    .q(iob_clk_stall_d1));
   
   
   dff_ns #(1) dram02_iob_vld_d1_ff (.din(dram02_iob_vld),
				     .clk(clk),
				     .q(dram02_iob_vld_d1));
   
   dff_ns #(`DRAM_IOB_WIDTH) dram02_iob_data_d1_ff (.din(dram02_iob_data),
						    .clk(clk),
						    .q(dram02_iob_data_d1));
   
   dff_ns #(1) iob_dram02_stall_d1_ff (.din(iob_dram02_stall),
				       .clk(clk),
				       .q(iob_dram02_stall_d1));

   
   dff_ns #(1) dram13_iob_vld_d1_ff (.din(dram13_iob_vld),
				     .clk(clk),
				     .q(dram13_iob_vld_d1));
   
   dff_ns #(`DRAM_IOB_WIDTH) dram13_iob_data_d1_ff (.din(dram13_iob_data),
						    .clk(clk),
						    .q(dram13_iob_data_d1));
   
   dff_ns #(1) iob_dram13_stall_d1_ff (.din(iob_dram13_stall),
				       .clk(clk),
				       .q(iob_dram13_stall_d1));

   
   dff_ns #(1) jbi_iob_pio_vld_d1_ff (.din(jbi_iob_pio_vld),
				      .clk(clk),
				      .q(jbi_iob_pio_vld_d1));
   
   dff_ns #(`JBI_IOB_WIDTH) jbi_iob_pio_data_d1_ff (.din(jbi_iob_pio_data),
						    .clk(clk),
						    .q(jbi_iob_pio_data_d1));
   
   dff_ns #(1) iob_jbi_pio_stall_d1_ff (.din(iob_jbi_pio_stall),
				    	.clk(clk),
				    	.q(iob_jbi_pio_stall_d1));

   
   dff_ns #(1) jbi_iob_spi_vld_d1_ff (.din(jbi_iob_spi_vld),
				      .clk(clk),
				      .q(jbi_iob_spi_vld_d1));
   
   dff_ns #(`SPI_IOB_WIDTH) jbi_iob_spi_data_d1_ff (.din(jbi_iob_spi_data),
						    .clk(clk),
						    .q(jbi_iob_spi_data_d1));

   dff_ns #(1) iob_jbi_spi_stall_d1_ff (.din(iob_jbi_spi_stall),
				    	.clk(clk),
				    	.q(iob_jbi_spi_stall_d1));

   
   dff_ns #(1) tap_iob_vld_d1_ff (.din(tap_iob_vld),
				  .clk(clk),
				  .q(tap_iob_vld_d1));
   
   dff_ns #(`TAP_IOB_WIDTH) tap_iob_data_d1_ff (.din(tap_iob_data),
						.clk(clk),
						.q(tap_iob_data_d1));
   
   dff_ns #(1) iob_tap_stall_d1_ff (.din(iob_tap_stall),
				    .clk(clk),
				    .q(iob_tap_stall_d1));

   
   /*****************************************************************
    * Mux IOB visibility port
    *****************************************************************/
   always @(/*AUTOSENSE*/c2i_packet_addr_d1 or c2i_packet_cputhr_d1
	    or c2i_packet_src_d1 or c2i_packet_tt_d1
	    or clk_iob_data_d1 or clk_iob_stall_d1 or clk_iob_vld_d1
	    or creg_dbg_iob_vis_ctrl or dram02_iob_data_d1
	    or dram02_iob_stall_d1 or dram02_iob_vld_d1
	    or dram13_iob_data_d1 or dram13_iob_stall_d1
	    or dram13_iob_vld_d1 or iob_clk_data_d1
	    or iob_clk_stall_d1 or iob_clk_vld_d1
	    or iob_dram02_data_d1 or iob_dram02_stall_d1
	    or iob_dram02_vld_d1 or iob_dram13_data_d1
	    or iob_dram13_stall_d1 or iob_dram13_vld_d1
	    or iob_jbi_pio_data_d1 or iob_jbi_pio_stall_d1
	    or iob_jbi_pio_vld_d1 or iob_jbi_spi_data_d1
	    or iob_jbi_spi_stall_d1 or iob_jbi_spi_vld_d1
	    or iob_tap_data_d1 or iob_tap_stall_d1 or iob_tap_vld_d1
	    or jbi_iob_pio_data_d1 or jbi_iob_pio_stall_d1
	    or jbi_iob_pio_vld_d1 or jbi_iob_spi_data_d1
	    or jbi_iob_spi_stall_d1 or jbi_iob_spi_vld_d1
	    or tap_iob_data_d1 or tap_iob_stall_d1 or tap_iob_vld_d1
	    or ucb_buf_acpt_d1)
     case (creg_dbg_iob_vis_ctrl[3:0])
       4'b0111: iob_dbg_bus = {jbi_iob_spi_vld_d1,
			       iob_jbi_spi_stall_d1,
			       iob_jbi_spi_vld_d1,
			       jbi_iob_spi_stall_d1,
			       dram13_iob_vld_d1,
			       iob_dram13_stall_d1,
			       iob_dram13_vld_d1,
			       dram13_iob_stall_d1,
			       dram02_iob_vld_d1,
			       iob_dram02_stall_d1,
			       iob_dram02_vld_d1,
			       dram02_iob_stall_d1,
			       dram13_iob_data_d1,
			       iob_dram13_data_d1,
			       dram02_iob_data_d1,
			       iob_dram02_data_d1,
			       8'b0,
			       jbi_iob_spi_data_d1,
			       iob_jbi_spi_data_d1};
       4'b0110: iob_dbg_bus = {tap_iob_vld_d1,
			       iob_tap_stall_d1,
			       iob_tap_vld_d1,
			       tap_iob_stall_d1,
			       1'b0,
			       1'b0,
			       1'b0,
			       1'b0,
			       clk_iob_vld_d1,
			       iob_clk_stall_d1,
			       iob_clk_vld_d1,
			       clk_iob_stall_d1,
			       4'b0,
			       4'b0,
			       clk_iob_data_d1,
			       iob_clk_data_d1,
			       tap_iob_data_d1,
			       iob_tap_data_d1};
       4'b0011: iob_dbg_bus = {jbi_iob_pio_vld_d1,
			       iob_jbi_pio_stall_d1,
			       iob_jbi_pio_vld_d1,
			       jbi_iob_pio_stall_d1,
			       24'b0,
			       jbi_iob_pio_data_d1[15:0]};
       4'b0010: iob_dbg_bus = {jbi_iob_pio_vld_d1,
			       iob_jbi_pio_stall_d1,
			       iob_jbi_pio_vld_d1,
			       jbi_iob_pio_stall_d1,
			       jbi_iob_pio_data_d1[15:8],
			       iob_jbi_pio_data_d1[63:32]};
       4'b0001: iob_dbg_bus = {jbi_iob_pio_vld_d1,
			       iob_jbi_pio_stall_d1,
			       iob_jbi_pio_vld_d1,
			       jbi_iob_pio_stall_d1,
			       jbi_iob_pio_data_d1[7:0],
			       iob_jbi_pio_data_d1[31:0]};
       4'b0000: iob_dbg_bus = {ucb_buf_acpt_d1,
			       c2i_packet_tt_d1,
			       c2i_packet_src_d1,
			       c2i_packet_cputhr_d1,
			       c2i_packet_addr_d1[37:3]};
       default: iob_dbg_bus = 44'b0;
     endcase // case(creg_vis_ctrl[3:0])

   
endmodule // iobdg_dbg_iob


// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:



