// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: i2c_sctrl.v
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
//  Module Name:	i2c_sctrl (scheduler to pick ack/interrupt to CPU)
//  Description:	This is the scheduler control to select an
//                      interrupt or read ack/nack back to the CPU.
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
module i2c_sctrl (/*AUTOARG*/
   // Outputs
   jbi_mondo_rd, jbi_int_rd, clk_int_rd, dram0_int_rd, dram1_int_rd, 
   iob_man_int_rd, spi_int_rd, jbi_ack_rd, clk_ack_rd, dram0_ack_rd, 
   dram1_ack_rd, iob_man_ack_rd, iob_int_ack_rd, spi_ack_rd, 
   bounce_ack_rd, rd_nack_rd, int_sel, ack_sel, mondo_srvcd_d1, 
   int_srvcd_d1, ack_srvcd_d1, io_buf_tail_s, io_mondo_data_wr_s, 
   io_buf_avail, int_srvcd, io_buf_wr, io_buf_tail_ptr, 
   iob_tap_packet_vld, iob_jbi_mondo_ack, iob_jbi_mondo_nack, 
   // Inputs
   rst_l, clk, jbi_mondo_vld, jbi_mondo_target, spi_int_vld, 
   iob_man_int_vld, dram1_int_vld, dram0_int_vld, clk_int_vld, 
   jbi_int_vld, rd_nack_vld, bounce_ack_vld, spi_ack_vld, 
   iob_int_ack_vld, iob_man_ack_vld, dram1_ack_vld, dram0_ack_vld, 
   clk_ack_vld, jbi_ack_vld, ack_packet_d1, io_buf_head_f, 
   mondo_busy_vec_f, srvc_wr_ack, cpu_intman_acc, cpu_intctrl_acc, 
   creg_intctrl_mask, tap_iob_busy
   );

   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input                            rst_l;
   input 			    clk;


   // UCB buffer interface
   input 			    jbi_mondo_vld;
   input [`IOB_CPUTHR_INDEX-1:0]    jbi_mondo_target;
				
   input 			    spi_int_vld;
   input 			    iob_man_int_vld;
   input 			    dram1_int_vld;
   input 			    dram0_int_vld;
   input 			    clk_int_vld;
   input 			    jbi_int_vld;

   input 			    rd_nack_vld;
   input 			    bounce_ack_vld;
   input 			    spi_ack_vld;
   input 			    iob_int_ack_vld;
   input 			    iob_man_ack_vld;
   input 			    dram1_ack_vld;
   input 			    dram0_ack_vld;
   input 			    clk_ack_vld;
   input 			    jbi_ack_vld;

   output 			    jbi_mondo_rd;
   
   output 			    jbi_int_rd;       
   output 			    clk_int_rd;       
   output 			    dram0_int_rd;     
   output 			    dram1_int_rd;
   output 			    iob_man_int_rd;
   output 			    spi_int_rd;       

   output 			    jbi_ack_rd;
   output 			    clk_ack_rd;
   output 			    dram0_ack_rd;
   output 			    dram1_ack_rd;
   output 			    iob_man_ack_rd;
   output 			    iob_int_ack_rd;
   output 			    spi_ack_rd;
   output 			    bounce_ack_rd;
   output 			    rd_nack_rd;
   
   		       
   // i2c slow datapath interface   
   output [`IOB_INT_AVEC_WIDTH-1:0] int_sel;
   output [`IOB_ACK_AVEC_WIDTH-1:0] ack_sel;
   output 			    mondo_srvcd_d1;
   output 			    int_srvcd_d1;
   output 			    ack_srvcd_d1;

   input [`UCB_128PAY_PKT_WIDTH-1:0] ack_packet_d1;
	
   
   // i2c fast control interface
   input [`IOB_IO_BUF_INDEX:0] 	    io_buf_head_f;
   output [`IOB_IO_BUF_INDEX:0]     io_buf_tail_s;

   
   // c2i fast control interface   
   // Mondo data/busy table interface
   // Interrupt status table interface
   output 			    io_mondo_data_wr_s;
   input [`IOB_CPUTHR_WIDTH-1:0]    mondo_busy_vec_f;

   
   // c2i slow control interface
   output 			    io_buf_avail;
   input 			    srvc_wr_ack;
 		       

   // IOB control interface
   input 			    cpu_intman_acc;
   input 			    cpu_intctrl_acc;
   output 			    int_srvcd;
   input 			    creg_intctrl_mask;
   
   
   // IO buffer interface
   output 			    io_buf_wr;
   output [`IOB_IO_BUF_INDEX-1:0]   io_buf_tail_ptr;
   

   // TAP interface
   output 			    iob_tap_packet_vld;
   input 			    tap_iob_busy;
   

   // JBI interface
   output 			    iob_jbi_mondo_ack;
   output 			    iob_jbi_mondo_nack;
   
	 
   // Internal signals
   wire 			    avail_mondo_vec;
   wire [`IOB_INT_AVEC_WIDTH-1:0]   avail_int_vec;
   wire [`IOB_ACK_AVEC_WIDTH-1:0]   avail_ack_vec;
   
   wire 			    snap_now;
   wire 			    mondo_vld;
   wire 			    snapd_mondo_vec;
   wire 			    snapd_mondo_vec_next;
   wire 			    mondo_srvcd;
   
   wire 			    int_vld;
   wire [`IOB_INT_AVEC_WIDTH-1:0]   srvcd_int_vec;
   wire [`IOB_INT_AVEC_WIDTH-1:0]   snapd_int_vec;
   wire [`IOB_INT_AVEC_WIDTH-1:0]   snapd_int_vec_next;
   reg [`IOB_INT_AVEC_WIDTH-1:0]    int_sel;
   reg [`IOB_INT_AVEC_WIDTH-1:0]    int_selected;

   wire 			    ack_vld;
   wire [`IOB_ACK_AVEC_WIDTH-1:0]   srvcd_ack_vec;
   wire [`IOB_ACK_AVEC_WIDTH-1:0]   snapd_ack_vec;
   wire [`IOB_ACK_AVEC_WIDTH-1:0]   snapd_ack_vec_next;
   wire 			    ack_srvcd;
   reg [`IOB_ACK_AVEC_WIDTH-1:0]    ack_sel;
   reg [`IOB_ACK_AVEC_WIDTH-1:0]    ack_selected;

   wire 			    ack_to_cpx_d1;
   wire 			    ack_to_tap_d1;

   wire [`IOB_CPUTHR_WIDTH-1:0]     mondo_busy_vec;
   wire 			    mondo_busy;
   wire 			    mondo_busy_d1;
   wire 			    iob_jbi_mondo_ack_a1;
   wire 			    iob_jbi_mondo_nack_a1;
   
   wire [`IOB_IO_BUF_INDEX:0] 	    io_buf_tail;
   wire [`IOB_IO_BUF_INDEX:0] 	    io_buf_tail_plus;
   wire [`IOB_IO_BUF_INDEX:0] 	    io_buf_head;
   wire 			    io_buf_hit_hwm;

   integer 			    i;
   integer 			    j;

   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /************************************************************
    * Assemble availibility vectors
    ************************************************************/
   assign 	 avail_mondo_vec = jbi_mondo_vld;
   
   assign 	 avail_int_vec = {1'b0,
				  1'b0,
				  spi_int_vld,
				  1'b0,
				  iob_man_int_vld,
				  dram1_int_vld,
				  dram0_int_vld,
				  clk_int_vld,
				  jbi_int_vld};
   
   assign 	 avail_ack_vec = {rd_nack_vld,
				  bounce_ack_vld,
				  spi_ack_vld,
				  iob_int_ack_vld,
				  iob_man_ack_vld,
				  dram1_ack_vld,
				  dram0_ack_vld,
				  clk_ack_vld,
				  jbi_ack_vld};

   
   /************************************************************
    * Handle mondo interrupts here
    ************************************************************/
   // Snap the availibility vector if all previous interrupts and acks
   // have been serviced.
   assign 	 snap_now = ~mondo_vld & ~int_vld & ~ack_vld;

   
   assign 	 snapd_mondo_vec_next = snap_now    ? avail_mondo_vec :
		                        mondo_srvcd ? 1'b0 :
		                                      snapd_mondo_vec;
   
   dffrl_ns #(1) snapd_mondo_vec_ff (.din(snapd_mondo_vec_next),
				     .clk(clk),
				     .rst_l(rst_l),
				     .q(snapd_mondo_vec));

   assign 	 mondo_vld = snapd_mondo_vec;

   // Mondo is serviced only if the IO buffer is not full and
   // CPU is not accessing the Mondo tables
   assign        mondo_srvcd = mondo_vld & ~io_buf_hit_hwm;
   
   dffrl_ns #(1) mondo_srvcd_d1_ff (.din(mondo_srvcd),
				    .clk(clk),
				    .rst_l(rst_l),
				    .q(mondo_srvcd_d1));

   assign 	 jbi_mondo_rd = mondo_srvcd;
		 
   
   /************************************************************
    * Handle on-chip interrupts here
    ************************************************************/
   assign 	 srvcd_int_vec = snapd_int_vec & ~int_sel;
	 
   assign 	 snapd_int_vec_next = snap_now  ? avail_int_vec :
		                      int_srvcd ? srvcd_int_vec :
		                                  snapd_int_vec;
   
   dffrl_ns #(`IOB_INT_AVEC_WIDTH) snapd_int_vec_ff (.din(snapd_int_vec_next),
						     .clk(clk),
						     .rst_l(rst_l),
						     .q(snapd_int_vec));

   assign 	 int_vld = |snapd_int_vec;

   // int_selected[i] means an int has been selected including the
   // ith entry.
   // int_sel is an one-hot or zero-hot vector indicating which int
   // has been selected.
   always @(/*AUTOSENSE*/snapd_int_vec)
     begin
	int_selected = 0;
	int_sel = 0;
	int_selected[0] = snapd_int_vec[0];
	int_sel[0] = snapd_int_vec[0];
	for (i=1; i<`IOB_INT_AVEC_WIDTH; i=i+1)
	  begin
	     int_selected[i] = snapd_int_vec[i] | int_selected[i-1];
	     int_sel[i] = snapd_int_vec[i] & ~int_selected[i-1];
	  end
     end

   // Int is serviced only if no mondo is serviced and the IO buffer is not full and
   // CPU is not accessing the Interrupt Management table
   assign        int_srvcd = int_vld & ~mondo_vld & ~io_buf_hit_hwm &
			     ~cpu_intman_acc & ~cpu_intctrl_acc;

   dffrl_ns #(1) int_srvcd_d1_ff (.din(int_srvcd),
				  .clk(clk),
				  .rst_l(rst_l),
				  .q(int_srvcd_d1));

   // Generate read singals to the double buffer
   assign 	 jbi_int_rd       = int_srvcd & int_sel[0];
   assign 	 clk_int_rd       = int_srvcd & int_sel[1];
   assign 	 dram0_int_rd     = int_srvcd & int_sel[2];
   assign 	 dram1_int_rd     = int_srvcd & int_sel[3];
   assign 	 iob_man_int_rd   = int_srvcd & int_sel[4];
   // 5
   assign 	 spi_int_rd       = int_srvcd & int_sel[6];
   // 7
   // 8

   
   /************************************************************
    * Handle acks here
    ************************************************************/
   assign 	 srvcd_ack_vec = snapd_ack_vec & ~ack_sel;
	 
   assign 	 snapd_ack_vec_next = snap_now  ? avail_ack_vec :
		                      ack_srvcd ? srvcd_ack_vec :
		                                  snapd_ack_vec;
   
   dffrl_ns #(`IOB_ACK_AVEC_WIDTH) snapd_ack_vec_ff (.din(snapd_ack_vec_next),
						     .clk(clk),
						     .rst_l(rst_l),
						     .q(snapd_ack_vec));

   assign 	 ack_vld = |snapd_ack_vec;

   // ack_selected[i] means an ack has been selected including the
   // ith entry.
   // ack_sel is an one-hot or zero-hot vector indicating which ack
   // has been selected.
   always @(/*AUTOSENSE*/snapd_ack_vec)
     begin
	ack_selected = 0;
	ack_sel = 0;
	ack_selected[0] = snapd_ack_vec[0];
	ack_sel[0] = snapd_ack_vec[0];
	for (j=1; j<`IOB_ACK_AVEC_WIDTH; j=j+1)
	  begin
	     ack_selected[j] = snapd_ack_vec[j] | ack_selected[j-1];
	     ack_sel[j] = snapd_ack_vec[j] & ~ack_selected[j-1];
	  end
     end

   // Ack is serviced only if no mondo or interrupt is serviced and the
   // IO buffer/TAP buffer is not full.
   assign        ack_srvcd = ack_vld & ~mondo_vld & ~int_vld & ~io_buf_hit_hwm &
			     ~tap_iob_busy & ~(ack_srvcd_d1 & ack_to_tap_d1);
   
   dffrl_ns #(1) ack_srvcd_d1_ff (.din(ack_srvcd),
				  .clk(clk),
				  .rst_l(rst_l),
				  .q(ack_srvcd_d1));

   // Generate read singals to the double buffer
   assign 	 jbi_ack_rd      = ack_srvcd & ack_sel[0];
   assign 	 clk_ack_rd      = ack_srvcd & ack_sel[1];
   assign 	 dram0_ack_rd    = ack_srvcd & ack_sel[2];
   assign 	 dram1_ack_rd    = ack_srvcd & ack_sel[3];
   assign 	 iob_man_ack_rd  = ack_srvcd & ack_sel[4];
   assign 	 iob_int_ack_rd  = ack_srvcd & ack_sel[5];
   assign 	 spi_ack_rd      = ack_srvcd & ack_sel[6];
   assign 	 bounce_ack_rd   = ack_srvcd & ack_sel[7];
   assign 	 rd_nack_rd      = ack_srvcd & ack_sel[8];
   

   // Determine destination of req/ack
   assign 	 ack_to_cpx_d1 =
		 ((((ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_READ_NACK) |
		    (ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_READ_ACK) |
		    (ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_IFILL_NACK) |
		    (ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_IFILL_ACK)) &
		   (ack_packet_d1[`UCB_BUF_HI:`UCB_BUF_LO] == `UCB_BID_CMP)) |
		  
		  (((ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_READ_REQ) |
		    (ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_WRITE_REQ)) &
		   (((ack_packet_d1[`ADDR_MAP_HI+`UCB_ADDR_LO:`ADDR_MAP_LO+`UCB_ADDR_LO] <= `L2C_CSR_HI) &
		     (ack_packet_d1[`ADDR_MAP_HI+`UCB_ADDR_LO:`ADDR_MAP_LO+`UCB_ADDR_LO] >= `L2C_CSR_LO)) |
		    ((ack_packet_d1[`ADDR_MAP_HI+`UCB_ADDR_LO:`ADDR_MAP_LO+`UCB_ADDR_LO] <= `DRAM_DATA_HI) &
		     (ack_packet_d1[`ADDR_MAP_HI+`UCB_ADDR_LO:`ADDR_MAP_LO+`UCB_ADDR_LO] >= `DRAM_DATA_LO)) |
		    (ack_packet_d1[`ADDR_MAP_HI+`UCB_ADDR_LO:`ADDR_MAP_LO+`UCB_ADDR_LO] == `CPU_ASI))));
   
   assign 	 ack_to_tap_d1 =
		 ((((ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_READ_NACK) |
		    (ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_READ_ACK) |
		    (ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_WRITE_ACK)) &
		   (ack_packet_d1[`UCB_BUF_HI:`UCB_BUF_LO] == `UCB_BID_TAP)) |
		  
		  (((ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_READ_REQ) |
		    (ack_packet_d1[`UCB_PKT_HI:`UCB_PKT_LO] == `UCB_WRITE_REQ)) &
		   (ack_packet_d1[`ADDR_MAP_HI+`UCB_ADDR_LO:`ADDR_MAP_LO+`UCB_ADDR_LO] == `TAP_CSR)));
   
   
   /************************************************************
    * Write mondo data table and busy table
    * Send ack/nack to JBI
    ************************************************************/
   dffrl_ns #(1) io_mondo_data_wr_s_ff (.din(mondo_srvcd & ~mondo_busy),
				      	.clk(clk),
				      	.rst_l(rst_l),
				      	.q(io_mondo_data_wr_s));

   // Busy vector from Mondo Busy Table
   dffrl_ns #(`IOB_CPUTHR_WIDTH) mondo_busy_vec_ff (.din(mondo_busy_vec_f),
					     	    .clk(clk),
					     	    .rst_l(rst_l),
					     	    .q(mondo_busy_vec));
   
   assign 	 mondo_busy = |(mondo_busy_vec & (1'b1 << jbi_mondo_target));

   dffrl_ns #(1) mondo_busy_d1_ff (.din(mondo_busy),
				   .clk(clk),
				   .rst_l(rst_l),
				   .q(mondo_busy_d1));

   // Send ack/nack to JBI
   assign 	 iob_jbi_mondo_ack_a1 = mondo_srvcd & ~mondo_busy;
   assign 	 iob_jbi_mondo_nack_a1 = mondo_srvcd & mondo_busy;
   
   dffrl_ns #(1) iob_jbi_mondo_ack_ff (.din(iob_jbi_mondo_ack_a1),
				       .clk(clk),
				       .rst_l(rst_l),
				       .q(iob_jbi_mondo_ack));

   dffrl_ns #(1) iob_jbi_mondo_nack_ff (.din(iob_jbi_mondo_nack_a1),
				       	.clk(clk),
				       	.rst_l(rst_l),
				       	.q(iob_jbi_mondo_nack));

				
   /************************************************************
    * Let c2i logic know that the IO buffer is ready to accept
    * a write ack.
    ************************************************************/
   assign        io_buf_avail = ~io_buf_hit_hwm &
		                ~mondo_srvcd_d1 &
		                ~int_srvcd_d1 &
                                ~ack_srvcd_d1;
   

   /************************************************************
    * Send transaction to IO buffer
    ************************************************************/
   assign 	 io_buf_wr = (mondo_srvcd_d1 & ~mondo_busy_d1) |
			     (int_srvcd_d1 & ~creg_intctrl_mask) |
			     (ack_srvcd_d1 & ack_to_cpx_d1) |
		             srvc_wr_ack;
   
   // Tail pointer to io buffer
   dffrle_ns #(`IOB_IO_BUF_INDEX+1) io_buf_tail_ff (.din(io_buf_tail_plus),
						    .rst_l(rst_l),
						    .en(io_buf_wr),
						    .clk(clk),
						    .q(io_buf_tail));
   assign     io_buf_tail_plus = io_buf_tail + 5'b1;

   // Have to flop tail one more time before sending to cpu clock domain
   // to guarantee content has been written to memory
   dffrl_ns #(`IOB_IO_BUF_INDEX+1) io_buf_tail_s_ff (.din(io_buf_tail),
						     .clk(clk),
						     .rst_l(rst_l),
						     .q(io_buf_tail_s));
   
   assign     io_buf_tail_ptr = io_buf_tail[`IOB_IO_BUF_INDEX-1:0];
   

   // Flop head pointer once to convert to bsc clock domain
   dffrl_ns #(`IOB_IO_BUF_INDEX+1) io_buf_head_ff (.din(io_buf_head_f),
						   .clk(clk),
						   .rst_l(rst_l),
						   .q(io_buf_head));
   
   // Determine if the io buffer is full
   assign     io_buf_hit_hwm = ((io_buf_tail_plus[`IOB_IO_BUF_INDEX] != io_buf_head[`IOB_IO_BUF_INDEX]) &
				(io_buf_tail_plus[`IOB_IO_BUF_INDEX-1:0] >= io_buf_head[`IOB_IO_BUF_INDEX-1:0])) |
			       ((io_buf_tail_plus[`IOB_IO_BUF_INDEX] == io_buf_head[`IOB_IO_BUF_INDEX]) &
				(io_buf_tail_plus[`IOB_IO_BUF_INDEX-1:0] <= io_buf_head[`IOB_IO_BUF_INDEX-1:0]));
   

   /************************************************************
    * Send transaction to TAP
    ************************************************************/
   assign 	 iob_tap_packet_vld = ack_srvcd_d1 & ack_to_tap_d1;

   
endmodule // i2c_sctrl
			       

// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
