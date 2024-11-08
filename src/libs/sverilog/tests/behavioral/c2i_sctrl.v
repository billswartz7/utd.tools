// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: c2i_sctrl.v
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
//  Module Name:	c2i_sctrl (cpu-to-io slow control)
//  Description:	This block is the interface block between SPARC cores
//                      via the crossbar and the IO subsystem.
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
module c2i_sctrl (/*AUTOARG*/
   // Outputs
   iob_tap_busy, cpu_buf_rd, tap_sel, cpu_packet_is_req, 
   cpu_packet_type, cpu_buf_head_s, srvc_wr_ack, cpu_buf_head_ptr, 
   cpu_buf_rd_l, c2i_packet_vld, c2i_packet_is_rd_req, 
   c2i_packet_is_wr_req, jbi_ucb_sel, clk_ucb_sel, dram0_ucb_sel, 
   dram1_ucb_sel, iob_man_ucb_sel, iob_int_ucb_sel, spi_ucb_sel, 
   bounce_ucb_sel, rd_nack_ucb_sel, ucb_buf_acpt, 
   // Inputs
   rst_l, clk, tap_iob_packet_vld, pcx_packet, tap_packet, 
   c2i_packet_addr, cpu_buf_tail_f, io_buf_avail, jbi_ucb_buf_acpt, 
   clk_ucb_buf_acpt, dram0_ucb_buf_acpt, dram1_ucb_buf_acpt, 
   iob_man_ucb_buf_acpt, iob_int_ucb_buf_acpt, spi_ucb_buf_acpt, 
   bounce_ucb_buf_acpt, rd_nack_ucb_buf_acpt
   );
   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input                              rst_l;
   input 			      clk;


   // TAP interface
   input 			      tap_iob_packet_vld;
   output 			      iob_tap_busy;
   

   // c2i slow datapath interface
   input [`PCX_WIDTH-1:0] 	      pcx_packet;
   input [`UCB_64PAY_PKT_WIDTH-1:0]   tap_packet;
   output 			      cpu_buf_rd;
   output 			      tap_sel;
   output 			      cpu_packet_is_req;
   output [`UCB_PKT_WIDTH-1:0] 	      cpu_packet_type;
   
   input [`UCB_ADDR_WIDTH-1:0] 	      c2i_packet_addr;
   
   
   // c2i fast control interface
   input [`IOB_CPU_BUF_INDEX:0]       cpu_buf_tail_f;
   output [`IOB_CPU_BUF_INDEX:0]      cpu_buf_head_s;


   // i2c slow control interface
   input 			      io_buf_avail;
   output 			      srvc_wr_ack;

   
   // CPU buffer interface
   output [`IOB_CPU_BUF_INDEX-1:0]    cpu_buf_head_ptr;
   output 			      cpu_buf_rd_l;
   

   // UCB buffer interface
   output 			      c2i_packet_vld;
   output 			      c2i_packet_is_rd_req;
   output 			      c2i_packet_is_wr_req;
   
   output 			      jbi_ucb_sel;
   input 			      jbi_ucb_buf_acpt;
   
   output 			      clk_ucb_sel;
   input 			      clk_ucb_buf_acpt;

   output 			      dram0_ucb_sel;
   input 			      dram0_ucb_buf_acpt;

   output 			      dram1_ucb_sel;
   input 			      dram1_ucb_buf_acpt;

   output 			      iob_man_ucb_sel;
   input 			      iob_man_ucb_buf_acpt;
   
   output 			      iob_int_ucb_sel;
   input 			      iob_int_ucb_buf_acpt;
   
   output 			      spi_ucb_sel;
   input 			      spi_ucb_buf_acpt;

   output 			      bounce_ucb_sel;
   input 			      bounce_ucb_buf_acpt;
   
   output 			      rd_nack_ucb_sel;
   input 			      rd_nack_ucb_buf_acpt;

   
   // Debug logic interface
   output 			      ucb_buf_acpt;

   
   // Internal signals
   wire [`IOB_CPU_BUF_INDEX:0] 	      cpu_buf_head;
   wire [`IOB_CPU_BUF_INDEX:0] 	      cpu_buf_head_d1;
   wire [`IOB_CPU_BUF_INDEX:0] 	      cpu_buf_head_plus1;
   wire 			      cpu_buf_head_inc;
   wire [`IOB_CPU_BUF_INDEX:0] 	      cpu_buf_tail;
   wire 			      cpu_buf_empty;
   wire 			      cpu_buf_empty_d1;

   wire 			      cpu_vld;
   wire 			      cpu_vld_next;
   wire 			      tap_vld;
   wire 			      cpu_sel;
   
   reg 				      cpu_packet_is_rd_req;
   reg 				      cpu_packet_is_wr_req;
   reg 				      cpu_packet_is_if_req;
   reg 				      cpu_packet_is_ack;
   reg [`UCB_PKT_WIDTH-1:0] 	      cpu_packet_type;
   wire 			      cpu_packet_needs_wr_ack;
   wire 			      cpu_packet_is_8B;
   
   reg 				      tap_packet_is_rd_req;
   reg 				      tap_packet_is_wr_req;
   reg 				      tap_packet_is_ack;
   wire 			      tap_packet_is_8B;
   
   wire 			      c2i_packet_is_ack;
   wire 			      c2i_packet_is_if_req;
   wire 			      c2i_packet_is_8B;
   
   wire [`ADDR_MAP_HI-`ADDR_MAP_LO:0] c2i_packet_addr_msb;
   // Request packets for these masters will go to one ucb
   wire 			      mem_ucb_sel;
   wire 			      l2_ucb_sel;
   wire 			      tap_ucb_sel;
   wire 			      asi_ucb_sel;
   
   
   wire 			      no_match_ucb;
   
   wire 			      blackhole_acpt;
   
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /*****************************************************************
    * CPU Buffer Control
    *****************************************************************/ 
   // Head pointer to cpu buffer
   dffrl_ns #(`IOB_CPU_BUF_INDEX+1) cpu_buf_head_d1_ff (.din(cpu_buf_head),
							.clk(clk),
							.rst_l(rst_l),
							.q(cpu_buf_head_d1));
   
   assign       cpu_buf_head_plus1 = cpu_buf_head_d1 + 5'b1;
   
   assign 	cpu_buf_head = cpu_buf_head_inc ? cpu_buf_head_plus1 :
	                                          cpu_buf_head_d1;
   
   assign 	cpu_buf_head_ptr = cpu_buf_head[`IOB_CPU_BUF_INDEX-1:0];
   
   assign 	cpu_buf_head_s = cpu_buf_head_d1;
   
   // Flop tail pointer to convert to BSC clock domain
   dffrl_ns #(`IOB_CPU_BUF_INDEX+1) cpu_buf_tail_ff (.din(cpu_buf_tail_f),
						     .clk(clk),
						     .rst_l(rst_l),
						     .q(cpu_buf_tail));

   // Cpu buffer is empty if head == tail  
   assign 	cpu_buf_empty = (cpu_buf_head == cpu_buf_tail);

   assign 	cpu_buf_rd_l = cpu_buf_empty;
   
   dff_ns #(1) cpu_buf_empty_d1_ff (.din(cpu_buf_empty|~rst_l),
				    .clk(clk),
				    .q(cpu_buf_empty_d1));

   
   // Read CPU buffer only when it is not empty.
   assign 	cpu_buf_rd = ~cpu_buf_empty_d1 &
	                     ((cpu_vld & cpu_sel & ucb_buf_acpt) |
	                      ~cpu_vld);

   assign 	cpu_buf_head_inc = cpu_buf_rd;

   
   /*****************************************************************
    * Arbitrate between TAP and CPU requests
    *****************************************************************/ 
   // Valid indicates which master has a valid packet pending
   assign 	cpu_vld_next = cpu_buf_rd |
	                       (cpu_vld & ~(cpu_sel & ucb_buf_acpt));
   
   dffrl_ns #(1) cpu_vld_ff (.din(cpu_vld_next),
			     .clk(clk),
			     .rst_l(rst_l),
			     .q(cpu_vld));

   assign 	tap_vld = tap_iob_packet_vld;

   
   // TAP packets priority > PCX packets priority
   assign 	tap_sel = tap_vld;
   assign 	cpu_sel = ~tap_vld;

   // Signal masters if the packet is accepted
   assign 	iob_tap_busy = tap_vld & ~ucb_buf_acpt;
   

   assign 	c2i_packet_vld = tap_vld |
	                         (cpu_vld &
				  ~(cpu_packet_needs_wr_ack & ~io_buf_avail));
   
   
   /*****************************************************************
    * Decode packet from CPU buffer
    *****************************************************************/
   always @(/*AUTOSENSE*/pcx_packet) begin
      // Packet will be dropped if it is neither a request nor ack
      cpu_packet_is_rd_req = 1'b0;
      cpu_packet_is_wr_req = 1'b0;
      cpu_packet_is_if_req = 1'b0;
      cpu_packet_is_ack = 1'b0;
      cpu_packet_type = `UCB_PKT_WIDTH'bx;
      case (pcx_packet[`PCX_RQ_HI:`PCX_RQ_LO]) 
	`LOAD_RQ:begin
	   cpu_packet_is_rd_req = 1'b1;
	   cpu_packet_is_wr_req = 1'b0;
	   cpu_packet_is_if_req = 1'b0;
	   cpu_packet_is_ack = 1'b0;
	   cpu_packet_type = `UCB_READ_REQ;
	end
	`IMISS_RQ:begin
	   cpu_packet_is_rd_req = 1'b0;
	   cpu_packet_is_wr_req = 1'b0;
	   cpu_packet_is_if_req = 1'b1;
	   cpu_packet_is_ack = 1'b0;
	   cpu_packet_type = `UCB_IFILL_REQ;
	end
	`STORE_RQ:begin
	   cpu_packet_is_rd_req = 1'b0;
	   cpu_packet_is_wr_req = 1'b1;
	   cpu_packet_is_if_req = 1'b0;
	   cpu_packet_is_ack = 1'b0;
	   cpu_packet_type = `UCB_WRITE_REQ;
	end
	`FWD_RPY:begin
	   cpu_packet_is_rd_req = 1'b0;
	   cpu_packet_is_wr_req = 1'b0;
	   cpu_packet_is_if_req = 1'b0;
	   cpu_packet_is_ack = 1'b1;
	   // Forward reply error will generate a read nack
	   // Assumption: error is reported at bit 1 of the error field
	   cpu_packet_type = ~pcx_packet[`PCX_R]       ? `UCB_WRITE_ACK :
			     pcx_packet[`PCX_ERR_LO+1] ? `UCB_READ_NACK :
			                                 `UCB_READ_ACK;
	end
      endcase // case(pcx_packet[`PCX_RQ_HI:`PCX_RQ_LO])
   end

   assign       cpu_packet_is_req = cpu_packet_is_rd_req |
				    cpu_packet_is_wr_req |
				    cpu_packet_is_if_req;

   // Decode PCX packet to see if it is a write request.  We need to
   // generate acks for writes.
   assign 	cpu_packet_needs_wr_ack = pcx_packet[`PCX_RQ_HI:`PCX_RQ_LO] == `STORE_RQ;
   
   assign 	cpu_packet_is_8B = pcx_packet[`PCX_SZ_HI:`PCX_SZ_LO] == `PCX_SZ_8B;
   
   
   /*****************************************************************
    * Decode packet from TAP
    *****************************************************************/
   always @(/*AUTOSENSE*/tap_packet) begin
      tap_packet_is_rd_req = 1'b0;
      tap_packet_is_wr_req = 1'b0;
      tap_packet_is_ack = 1'b0;
      case (tap_packet[`UCB_PKT_HI:`UCB_PKT_LO])
	`UCB_READ_REQ:begin
	   tap_packet_is_rd_req = 1'b1;
	   tap_packet_is_wr_req = 1'b0;
	   tap_packet_is_ack = 1'b0;
	end
	`UCB_WRITE_REQ:begin
	   tap_packet_is_rd_req = 1'b0;
	   tap_packet_is_wr_req = 1'b1;
	   tap_packet_is_ack = 1'b0;
	end
	`UCB_READ_NACK,
	`UCB_READ_ACK:begin
	   tap_packet_is_rd_req = 1'b0;
	   tap_packet_is_wr_req = 1'b0;
	   tap_packet_is_ack = 1'b1;
	end
      endcase
   end // always @ (...
   
   assign 	tap_packet_is_8B = tap_packet[`UCB_SIZE_HI:`UCB_SIZE_LO] == `UCB_SIZE_8B;
   
   
   /*****************************************************************
    * Mux between TAP and CPU packet
    *****************************************************************/
   assign 	c2i_packet_is_rd_req = tap_sel ? tap_packet_is_rd_req :
		                                 cpu_packet_is_rd_req;
   
   assign 	c2i_packet_is_wr_req = tap_sel ? tap_packet_is_wr_req :
		                                 cpu_packet_is_wr_req;
   
   assign 	c2i_packet_is_if_req = tap_sel ? 1'b0 :
		                                 cpu_packet_is_if_req;
   
   assign 	c2i_packet_is_ack = tap_sel ? tap_packet_is_ack :
		                              cpu_packet_is_ack;
   
   assign 	c2i_packet_is_8B = tap_sel ? tap_packet_is_8B :
		                             cpu_packet_is_8B;

   
   /*****************************************************************
    * Decode 8 MSB of c2i packet address to figure out which UCB it
    * should go to
    *****************************************************************/ 
   assign 	c2i_packet_addr_msb = c2i_packet_addr[`ADDR_MAP_HI:`ADDR_MAP_LO];
   assign 	mem_ucb_sel      = ((c2i_packet_addr_msb <= `DRAM_DATA_HI) &
				    (c2i_packet_addr_msb >= `DRAM_DATA_LO)) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req);
   assign 	l2_ucb_sel       = ((c2i_packet_addr_msb <= `L2C_CSR_HI) &
				    (c2i_packet_addr_msb >= `L2C_CSR_LO)) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req) &
		                     c2i_packet_is_8B;
   assign 	jbi_ucb_sel      = ((c2i_packet_addr_msb == `JBUS1) |
				    ((c2i_packet_addr_msb <= `JBUS2_HI) &
				     (c2i_packet_addr_msb >= `JBUS2_LO))) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req);
   
   assign 	clk_ucb_sel      = (c2i_packet_addr_msb == `CLOCK_UNIT_CSR) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req) &
		                     c2i_packet_is_8B;
   // Bit 12 indicates which DRAM control we want
   assign 	dram0_ucb_sel    = ((c2i_packet_addr_msb == `DRAM_CSR) &
				    (c2i_packet_addr[12] == 1'b0)) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req) &
		                     c2i_packet_is_8B;
   assign 	dram1_ucb_sel    = ((c2i_packet_addr_msb == `DRAM_CSR) &
				    (c2i_packet_addr[12] == 1'b1)) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req) &
		                     c2i_packet_is_8B;
   assign 	iob_man_ucb_sel  = (c2i_packet_addr_msb == `IOB_MAN_CSR) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req) &
		                     c2i_packet_is_8B;
   assign 	tap_ucb_sel      = (c2i_packet_addr_msb == `TAP_CSR) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req) &
		                     c2i_packet_is_8B;
   assign 	iob_int_ucb_sel  = (c2i_packet_addr_msb == `IOB_INT_CSR) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req) &
		                     c2i_packet_is_8B;
   
   assign 	asi_ucb_sel      = (c2i_packet_addr_msb == `CPU_ASI) &
				     (c2i_packet_is_rd_req | c2i_packet_is_wr_req) &
		                     c2i_packet_is_8B;
   
   assign 	spi_ucb_sel      = (c2i_packet_addr_msb == `SPI_CSR) &
				     (c2i_packet_is_rd_req |
				      c2i_packet_is_wr_req |
				      c2i_packet_is_if_req);

   // Request to L2/TAP/ASI addresses can only be accessed through the i2c path
   // Ack to CPU/TAP is also sent through the i2c path
   assign     bounce_ucb_sel = mem_ucb_sel | l2_ucb_sel | tap_ucb_sel |	asi_ucb_sel | c2i_packet_is_ack;

   // Any request that does not match any defined address space
   assign     no_match_ucb = ~(mem_ucb_sel |
			       l2_ucb_sel |
			       jbi_ucb_sel |
			       clk_ucb_sel |
			       dram0_ucb_sel |
			       dram1_ucb_sel |
			       iob_man_ucb_sel |
			       tap_ucb_sel |
			       iob_int_ucb_sel |
			       asi_ucb_sel |
			       spi_ucb_sel);

   // This handles either read nack or ifill nack
   assign     rd_nack_ucb_sel = no_match_ucb &
	                        (c2i_packet_is_rd_req | c2i_packet_is_if_req);
   
   // The Black-Hole ucb is for sinking packets with undefined transaction
   // type
   assign     blackhole_acpt = c2i_packet_vld &
	                       ((~c2i_packet_is_rd_req &
				 ~c2i_packet_is_wr_req &
				 ~c2i_packet_is_if_req &
				 ~c2i_packet_is_ack) |
				(no_match_ucb & c2i_packet_is_wr_req));
   
   // ucb_buf_acpt means c2i_packet has been accepted by a ucb buffer
   // Assertion: At most only one device should accept
   assign     ucb_buf_acpt = (jbi_ucb_buf_acpt |
			      clk_ucb_buf_acpt |
			      dram0_ucb_buf_acpt |
			      dram1_ucb_buf_acpt |
	                      iob_man_ucb_buf_acpt |
	                      iob_int_ucb_buf_acpt |
			      spi_ucb_buf_acpt |
			      bounce_ucb_buf_acpt |
			      rd_nack_ucb_buf_acpt |
			      blackhole_acpt);


   // Generate write ack if ucb buffer is accepting a write request
   assign     srvc_wr_ack = cpu_sel & ucb_buf_acpt & cpu_packet_needs_wr_ack;

   
endmodule // c2i_sctrl


// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
