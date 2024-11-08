// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: c2i_fctrl.v
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
//  Module Name:	c2i_fctrl (cpu-to-io fast control)
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
module c2i_fctrl (/*AUTOARG*/
   // Outputs
   iob_pcx_stall_pq, io_mondo_data_wr, mondo_data_bypass_d1, 
   mondo_addr_creg_mdata0_dec_d1, mondo_addr_creg_mdata1_dec_d1, 
   mondo_addr_creg_mbusy_dec_d1, cpu_mondo_rd_d1, tap_mondo_rd_d1, 
   cpu_mondo_rd_d2, cpu_mondo_addr_invld_d2, mondo_data_addr_p0_d1, 
   cpu_buf_tail_f, cpu_mondo_wr_d2, tap_mondo_acc_addr_invld_d2_f, 
   tap_mondo_acc_seq_d2_f, mondo_data_addr_p0, mondo_data_addr_p1, 
   mondo_data0_wr_lo_l, mondo_data0_wr_hi_l, mondo_data1_wr_lo_l, 
   mondo_data1_wr_hi_l, mondo_source_wr_l, mondo_busy_addr_p0, 
   mondo_busy_addr_p1, mondo_busy_addr_p2, mondo_busy_wr_p1, 
   mondo_busy_wr_p2, cpu_buf_wr_l, cpu_buf_tail_ptr, 
   // Inputs
   cpu_rst_l, cpu_clk, tx_sync, rx_sync, pcx_iob_data_rdy_px2, 
   pcx_iob_vld, pcx_iob_req, pcx_iob_addr, pcx_iob_cputhr, 
   cpu_buf_head_s, int_buf_hit_hwm, io_mondo_data_wr_s, 
   io_mondo_data_wr_addr_s, tap_mondo_acc_addr_s, 
   tap_mondo_acc_seq_s, tap_mondo_wr_s
   );
   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input                              cpu_rst_l;
   input 			      cpu_clk;
   input 			      tx_sync;
   input 			      rx_sync;

   
   // Crossbar interface
   input 			      pcx_iob_data_rdy_px2;
   output 			      iob_pcx_stall_pq;
   
 
   // c2i fast datapath interface
   input 			      pcx_iob_vld;
   input [`PCX_RQ_HI-`PCX_RQ_LO:0]    pcx_iob_req;
   input [`PCX_AD_HI-`PCX_AD_LO:0]    pcx_iob_addr;
   input [`PCX_CP_HI-`PCX_TH_LO:0]    pcx_iob_cputhr;
 			      
   output 			      io_mondo_data_wr;
   output 			      mondo_data_bypass_d1;
   output 			      mondo_addr_creg_mdata0_dec_d1;
   output 			      mondo_addr_creg_mdata1_dec_d1;
   output 			      mondo_addr_creg_mbusy_dec_d1;
   output 			      cpu_mondo_rd_d1;
   output 			      tap_mondo_rd_d1;
   output 			      cpu_mondo_rd_d2;
   output 			      cpu_mondo_addr_invld_d2;
   
   output [`IOB_MONDO_DATA_INDEX-1:0] mondo_data_addr_p0_d1;

   
   // c2i slow control interface
   input [`IOB_CPU_BUF_INDEX:0]       cpu_buf_head_s;
   output [`IOB_CPU_BUF_INDEX:0]      cpu_buf_tail_f;

   
   // i2c fast control interface
   //output 			      cpu_mondo_rd_d2;
   output 			      cpu_mondo_wr_d2;
   
   input 			      int_buf_hit_hwm;

   
   // i2c slow control interface
   input 			      io_mondo_data_wr_s;

   
   // i2c slow datapath interface
   input [`IOB_MONDO_DATA_INDEX-1:0]  io_mondo_data_wr_addr_s;
   
   
   // IOB control interface
   input [`IOB_ADDR_WIDTH-1:0] 	      tap_mondo_acc_addr_s;
   input 			      tap_mondo_acc_seq_s;
   input 			      tap_mondo_wr_s;
   output 			      tap_mondo_acc_addr_invld_d2_f;
   output 			      tap_mondo_acc_seq_d2_f;
   
   
   // Mondo data table interface
   output [`IOB_MONDO_DATA_INDEX-1:0] mondo_data_addr_p0;
   output [`IOB_MONDO_DATA_INDEX-1:0] mondo_data_addr_p1;
   output 			      mondo_data0_wr_lo_l;
   output 			      mondo_data0_wr_hi_l;
   output 			      mondo_data1_wr_lo_l;
   output 			      mondo_data1_wr_hi_l;
   output 			      mondo_source_wr_l;
   output [`IOB_MONDO_DATA_INDEX-1:0] mondo_busy_addr_p0;
   output [`IOB_MONDO_DATA_INDEX-1:0] mondo_busy_addr_p1;
   output [`IOB_MONDO_DATA_INDEX-1:0] mondo_busy_addr_p2;
   output 			      mondo_busy_wr_p1;
   output 			      mondo_busy_wr_p2;
   
   
   // Cpu buffer interface
   output 			      cpu_buf_wr_l;
   output [`IOB_CPU_BUF_INDEX-1:0]    cpu_buf_tail_ptr;

   
   // Internal signals
   wire 			      pcx_iob_data_rdy;
   wire 			      cpu_mondo_acc;
   wire 			      cpu_mondo_rd;
   wire 			      cpu_mondo_wr;
   wire 			      cpu_mondo_wr_d1;
   wire 			      cpu_mondo_addr_creg_mdata0_dec;
   wire 			      cpu_mondo_addr_creg_mdata1_dec;
   wire 			      cpu_mondo_addr_creg_mbusy_dec;
   wire [`IOB_MONDO_DATA_INDEX-1:0]   cpu_mondo_data_addr;
   wire 			      cpu_mondo_addr_invld;
   wire 			      cpu_mondo_addr_creg_mdata0_dec_d1;
   wire 			      cpu_mondo_addr_creg_mdata1_dec_d1;
   wire 			      cpu_mondo_addr_creg_mbusy_dec_d1;
   wire 			      cpu_mondo_addr_invld_d1;

   wire [`IOB_MONDO_DATA_INDEX-1:0]   io_mondo_data_addr;
   
   wire [`IOB_ADDR_WIDTH-1:0] 	      tap_mondo_acc_addr;
   wire 			      tap_mondo_addr_creg_mdata0_dec;
   wire 			      tap_mondo_addr_creg_mdata1_dec;
   wire 			      tap_mondo_addr_creg_mbusy_dec;
   wire [`IOB_MONDO_DATA_INDEX-1:0]   tap_mondo_data_addr;
   wire 			      tap_mondo_addr_invld;
   wire 			      tap_mondo_addr_creg_mdata0_dec_d1;
   wire 			      tap_mondo_addr_creg_mdata1_dec_d1;
   wire 			      tap_mondo_addr_creg_mbusy_dec_d1;
   wire 			      tap_mondo_addr_invld_d1;
   wire 			      tap_mondo_addr_invld_d2;
   wire 			      tap_mondo_acc_seq;
   wire 			      tap_mondo_acc_seq_d1;
   wire 			      tap_mondo_acc_seq_d2;
   wire 			      tap_mondo_wr;
   wire 			      tap_mondo_acc;
   wire 			      tap_mondo_rd;

   wire 			      mondo_data0_wr;
   wire 			      mondo_data0_wr_lo;
   wire 			      mondo_data0_wr_hi;
   wire 			      mondo_data1_wr;
   wire 			      mondo_data1_wr_lo;
   wire 			      mondo_data1_wr_hi;
   wire 			      mondo_source_wr;
   wire 			      mondo_data_wr_d1;
   wire [`IOB_MONDO_DATA_INDEX-1:0]   mondo_data_addr_p1_d1;
   
   wire 			      cpu_buf_wr;
   wire [`IOB_CPU_BUF_INDEX:0] 	      cpu_buf_tail_plus;
   wire [`IOB_CPU_BUF_INDEX:0] 	      cpu_buf_tail;
   wire [`IOB_CPU_BUF_INDEX:0] 	      cpu_buf_head;
   wire [`IOB_CPU_BUF_INDEX:0] 	      cpu_buf_tail_plus8;
   wire 			      cpu_buf_hit_hwm;

   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /*****************************************************************
    * Read/Write request to the interrupt status table, mondo data tables,
    * and mondo busy table from CPU.
    * Write will not update the tables (only generates ack) except the
    * mondo busy bit because the entries are read-only by software.
    *****************************************************************/ 
   dffrl_ns #(1) pcx_iob_data_rdy_ff (.din(pcx_iob_data_rdy_px2),
				      .clk(cpu_clk),
				      .rst_l(cpu_rst_l),
				      .q(pcx_iob_data_rdy));

   // Check address to see if request is mondo data, or mondo busy.
   // They are all in the `IOB_INT_CSR space.
   assign       cpu_mondo_acc = pcx_iob_data_rdy & pcx_iob_vld &
	                        (pcx_iob_addr[`ADDR_MAP_HI:`ADDR_MAP_LO] == `IOB_INT_CSR);
   
   assign 	cpu_mondo_rd = cpu_mondo_acc & (pcx_iob_req == `LOAD_RQ);
   
   dffrl_ns #(1) cpu_mondo_rd_d1_ff (.din(cpu_mondo_rd),
				     .clk(cpu_clk),
				     .rst_l(cpu_rst_l),
				     .q(cpu_mondo_rd_d1));
   
   dffrl_ns #(1) cpu_mondo_rd_d2_ff (.din(cpu_mondo_rd_d1),
				     .clk(cpu_clk),
				     .rst_l(cpu_rst_l),
				     .q(cpu_mondo_rd_d2));

   assign 	cpu_mondo_wr = cpu_mondo_acc & (pcx_iob_req == `STORE_RQ);

   dffrl_ns #(1) cpu_mondo_wr_d1_ff (.din(cpu_mondo_wr),
				     .clk(cpu_clk),
				     .rst_l(cpu_rst_l),
				     .q(cpu_mondo_wr_d1));
   
   dffrl_ns #(1) cpu_mondo_wr_d2_ff (.din(cpu_mondo_wr_d1),
				     .clk(cpu_clk),
				     .rst_l(cpu_rst_l),
				     .q(cpu_mondo_wr_d2));

   // Decode address to access interrupt table
   iobdg_int_mondo_addr_dec cpu_mondo_addr_dec (.addr_in(pcx_iob_addr),
					    	.thr_id_in(pcx_iob_cputhr),
					    	.creg_mdata0_dec(cpu_mondo_addr_creg_mdata0_dec),
					    	.creg_mdata1_dec(cpu_mondo_addr_creg_mdata1_dec),
					    	.creg_mbusy_dec(cpu_mondo_addr_creg_mbusy_dec),
					    	.mondo_data_addr(cpu_mondo_data_addr),
					    	.addr_invld(cpu_mondo_addr_invld));

   dffrl_ns #(1) cpu_mondo_addr_creg_mdata0_dec_d1_ff (.din(cpu_mondo_addr_creg_mdata0_dec),
						       .clk(cpu_clk),
						       .rst_l(cpu_rst_l),
						       .q(cpu_mondo_addr_creg_mdata0_dec_d1));

   dffrl_ns #(1) cpu_mondo_addr_creg_mdata1_dec_d1_ff (.din(cpu_mondo_addr_creg_mdata1_dec),
						       .clk(cpu_clk),
						       .rst_l(cpu_rst_l),
						       .q(cpu_mondo_addr_creg_mdata1_dec_d1));

   dffrl_ns #(1) cpu_mondo_addr_creg_mbusy_dec_d1_ff (.din(cpu_mondo_addr_creg_mbusy_dec),
						      .clk(cpu_clk),
						      .rst_l(cpu_rst_l),
						      .q(cpu_mondo_addr_creg_mbusy_dec_d1));
   
   dffrl_ns #(1) cpu_mondo_addr_invld_d1_ff (.din(cpu_mondo_addr_invld),
					     .clk(cpu_clk),
					     .rst_l(cpu_rst_l),
					     .q(cpu_mondo_addr_invld_d1));
   
   dffrl_ns #(1) cpu_mondo_addr_invld_d2_ff (.din(cpu_mondo_addr_invld_d1),
					     .clk(cpu_clk),
					     .rst_l(cpu_rst_l),
					     .q(cpu_mondo_addr_invld_d2));

  
   /*****************************************************************
    * Write request to the mondo data0, mondo data1, mondo busy table
    * from JBI
    *****************************************************************/
   // Write will be asserted for multiple cycles.  That's okay.  The
   // same entry in the array will be written several times.
   dffrle_ns #(1) io_mondo_data_wr_ff (.din(io_mondo_data_wr_s),
				       .rst_l(cpu_rst_l),
				       .en(rx_sync),
				       .clk(cpu_clk),
				       .q(io_mondo_data_wr));

   dffe_ns #(`IOB_MONDO_DATA_INDEX) io_mondo_data_addr_ff (.din(io_mondo_data_wr_addr_s),
						      	   .en(rx_sync),
						      	   .clk(cpu_clk),
						      	   .q(io_mondo_data_addr));
   

   /*****************************************************************
    * Read/Write request to the mondo data, mondo busy table from TAP
    *****************************************************************/ 
   // Flop address to convert to cpu clock domain
   dffe_ns #(`IOB_ADDR_WIDTH) tap_mondo_acc_addr_ff (.din(tap_mondo_acc_addr_s),
						     .en(rx_sync),
						     .clk(cpu_clk),
						     .q(tap_mondo_acc_addr));
   
   // Decode address to access interrupt table, mondo data, mondo busy
   // Thread ID is hardwired to zero.  TAP should use alias address to access
   // mondo data table.  If it tries to use the software address, only
   // thread 0's entry is accessible.
   iobdg_int_mondo_addr_dec tap_mondo_addr_dec (.addr_in(tap_mondo_acc_addr),
					    	.thr_id_in(`IOB_CPUTHR_INDEX'b0),
					    	.creg_mdata0_dec(tap_mondo_addr_creg_mdata0_dec),
					    	.creg_mdata1_dec(tap_mondo_addr_creg_mdata1_dec),
					    	.creg_mbusy_dec(tap_mondo_addr_creg_mbusy_dec),
					    	.mondo_data_addr(tap_mondo_data_addr),
					    	.addr_invld(tap_mondo_addr_invld));
   
   dffrle_ns #(1) tap_mondo_addr_creg_mdata0_dec_d1_ff (.din(tap_mondo_addr_creg_mdata0_dec),
							.rst_l(cpu_rst_l),
							.en(tap_mondo_acc),
							.clk(cpu_clk),
							.q(tap_mondo_addr_creg_mdata0_dec_d1));

   dffrle_ns #(1) tap_mondo_addr_creg_mdata1_dec_d1_ff (.din(tap_mondo_addr_creg_mdata1_dec),
							.rst_l(cpu_rst_l),
							.en(tap_mondo_acc),
							.clk(cpu_clk),
							.q(tap_mondo_addr_creg_mdata1_dec_d1));

   dffrle_ns #(1) tap_mondo_addr_creg_mbusy_dec_d1_ff (.din(tap_mondo_addr_creg_mbusy_dec),
						       .rst_l(cpu_rst_l),
						       .en(tap_mondo_acc),
						       .clk(cpu_clk),
						       .q(tap_mondo_addr_creg_mbusy_dec_d1));

   dffrle_ns #(1) tap_mondo_addr_invld_d1_ff (.din(tap_mondo_addr_invld),
					      .rst_l(cpu_rst_l),
					      .en(tap_mondo_acc),
					      .clk(cpu_clk),
					      .q(tap_mondo_addr_invld_d1));

   dffrl_ns #(1) tap_mondo_addr_invld_d2_ff (.din(tap_mondo_addr_invld_d1),
					     .clk(cpu_clk),
					     .rst_l(cpu_rst_l),
					     .q(tap_mondo_addr_invld_d2));

   // Send result back to BSC clock domain
   dffrle_ns #(1) tap_mondo_acc_addr_invld_d2_f_ff (.din(tap_mondo_addr_invld_d2),
						    .rst_l(cpu_rst_l),
						    .en(tx_sync),
						    .clk(cpu_clk),
						    .q(tap_mondo_acc_addr_invld_d2_f));


   // Flop sequence number to convert to cpu clock domain
   dffrle_ns #(1) tap_mondo_acc_seq_ff (.din(tap_mondo_acc_seq_s),
					.rst_l(cpu_rst_l),
					.en(rx_sync),
					.clk(cpu_clk),
					.q(tap_mondo_acc_seq));

   // Keep track of which sequence number has been serviced
   dffrle_ns #(1) tap_mondo_acc_seq_d1_ff (.din(tap_mondo_acc_seq),
					   .rst_l(cpu_rst_l),
					   .en(tap_mondo_acc),
					   .clk(cpu_clk),
					   .q(tap_mondo_acc_seq_d1));

   dffrl_ns #(1) tap_mondo_acc_seq_d2_ff (.din(tap_mondo_acc_seq_d1),
					  .clk(cpu_clk),
					  .rst_l(cpu_rst_l),
					  .q(tap_mondo_acc_seq_d2));

   // Send result back to JBUS clock domain
   dffrle_ns #(1) tap_mondo_acc_seq_d2_f_ff (.din(tap_mondo_acc_seq_d2),
					     .rst_l(cpu_rst_l),
					     .en(tx_sync),
					     .clk(cpu_clk),
					     .q(tap_mondo_acc_seq_d2_f));

   
   // Flop write signal to convert to cpu clock domain
   dffrle_ns #(1) tap_mondo_wr_ff (.din(tap_mondo_wr_s),
				   .rst_l(cpu_rst_l),
				   .en(rx_sync),
				   .clk(cpu_clk),
				   .q(tap_mondo_wr));


   // CPU read and IO write has higher priority than TAP read/write
   assign 	tap_mondo_acc = ~cpu_mondo_acc &
		                ~io_mondo_data_wr &
	                        (tap_mondo_acc_seq != tap_mondo_acc_seq_d1);

   assign 	tap_mondo_rd = tap_mondo_acc & ~tap_mondo_wr;
   
   dffrl_ns #(1) tap_mondo_rd_d1_ff (.din(tap_mondo_rd),
				     .clk(cpu_clk),
				     .rst_l(cpu_rst_l),
				     .q(tap_mondo_rd_d1));

   
   /*****************************************************************
    * Mux out decoded signals depending on CPU or TAP access
    *****************************************************************/
   assign 	mondo_addr_creg_mdata0_dec_d1 = 
		cpu_mondo_rd_d1 ? cpu_mondo_addr_creg_mdata0_dec_d1 :
		                  tap_mondo_addr_creg_mdata0_dec_d1;
   
   assign 	mondo_addr_creg_mdata1_dec_d1 = 
		cpu_mondo_rd_d1 ? cpu_mondo_addr_creg_mdata1_dec_d1 :
		                  tap_mondo_addr_creg_mdata1_dec_d1;
   
   assign 	mondo_addr_creg_mbusy_dec_d1 = 
		cpu_mondo_rd_d1 ? cpu_mondo_addr_creg_mbusy_dec_d1 :
		                  tap_mondo_addr_creg_mbusy_dec_d1;
   
		
   /*****************************************************************
    * Setup read/write access to mondo data table
    *****************************************************************/ 
   assign 	mondo_data_addr_p0 = cpu_mondo_acc ? cpu_mondo_data_addr :
	                                             tap_mondo_data_addr;

   assign 	mondo_data_addr_p1 = io_mondo_data_wr ? io_mondo_data_addr :
	                                                tap_mondo_data_addr;

   assign 	mondo_data0_wr = io_mondo_data_wr |
		                 (tap_mondo_acc & tap_mondo_wr & tap_mondo_addr_creg_mdata0_dec);
   assign 	mondo_data0_wr_lo = mondo_data0_wr & ~mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-1];
   assign 	mondo_data0_wr_hi = mondo_data0_wr & mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-1];
   
   assign 	mondo_data1_wr = io_mondo_data_wr |
		                 (tap_mondo_acc & tap_mondo_wr & tap_mondo_addr_creg_mdata1_dec);
   assign 	mondo_data1_wr_lo = mondo_data1_wr & ~mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-1];
   assign 	mondo_data1_wr_hi = mondo_data1_wr & mondo_data_addr_p1[`IOB_MONDO_DATA_INDEX-1];
   
   assign 	mondo_source_wr = io_mondo_data_wr |
		                  (tap_mondo_acc & tap_mondo_wr & tap_mondo_addr_creg_mbusy_dec);

   assign 	mondo_data0_wr_lo_l = ~mondo_data0_wr_lo;
   assign 	mondo_data0_wr_hi_l = ~mondo_data0_wr_hi;
   assign 	mondo_data1_wr_lo_l = ~mondo_data1_wr_lo;
   assign 	mondo_data1_wr_hi_l = ~mondo_data1_wr_hi;
   assign 	mondo_source_wr_l = ~mondo_source_wr;
   
   // Bypass detection - Only bypass if io_mondo_data_wr.  This bypass
   //                    is for the case when Jbus interrupt updates the
   //                    tables and CPU tries to read the exact same
   //                    entry.
   //                    No need to bypass if TAP is writing because
   //                    TAP access is allowed only if CPU is not
   //                    accessing the tables.
   dffrl_ns #(1) mondo_data_wr_d1_ff (.din(io_mondo_data_wr),
				      .clk(cpu_clk),
				      .rst_l(cpu_rst_l),
				      .q(mondo_data_wr_d1));

   dff_ns #(`IOB_MONDO_DATA_INDEX) mondo_data_addr_p0_d1_ff (.din(mondo_data_addr_p0),
							     .clk(cpu_clk),
							     .q(mondo_data_addr_p0_d1));
   
   dff_ns #(`IOB_MONDO_DATA_INDEX) mondo_data_addr_p1_d1_ff (.din(mondo_data_addr_p1),
							     .clk(cpu_clk),
							     .q(mondo_data_addr_p1_d1));

   assign 	mondo_data_bypass_d1 = mondo_data_wr_d1 &
	                               (mondo_data_addr_p0_d1 == mondo_data_addr_p1_d1);
   
   
   /*****************************************************************
    * Setup read/write access to mondo busy
    *****************************************************************/
   // Need two write ports because JBUS and CPU may write the Busy bit
   // at the same time.  If they try to write the same entry at the same
   // time (which is probably a software bug), JBUS wins.
   // Port 0 - CPU or TAP read
   // Port 1 - JBUS or TAP write
   // Port 2 - CPU write
   assign 	mondo_busy_addr_p0 = mondo_data_addr_p0;

   assign 	mondo_busy_addr_p1 = mondo_data_addr_p1;

   assign 	mondo_busy_addr_p2 = cpu_mondo_data_addr;
   

   assign 	mondo_busy_wr_p1 = io_mondo_data_wr |
                                   (tap_mondo_acc & tap_mondo_wr & tap_mondo_addr_creg_mbusy_dec);
   
   assign 	mondo_busy_wr_p2 = cpu_mondo_acc & cpu_mondo_wr & cpu_mondo_addr_creg_mbusy_dec;

 
   /*****************************************************************
    * Cpu Buffer Control
    *****************************************************************/ 
   assign 	cpu_buf_wr = pcx_iob_data_rdy & pcx_iob_vld & ~(cpu_mondo_rd | cpu_mondo_wr);
   assign 	cpu_buf_wr_l = ~cpu_buf_wr;

   
   // Tail pointer to cpu buffer
   dffrle_ns #(`IOB_CPU_BUF_INDEX+1) cpu_buf_tail_ff (.din(cpu_buf_tail_plus),
						      .rst_l(cpu_rst_l),
						      .en(cpu_buf_wr),
						      .clk(cpu_clk),
						      .q(cpu_buf_tail));
   
   assign 	cpu_buf_tail_plus = cpu_buf_tail + 5'b1;
   
   assign 	cpu_buf_tail_ptr = cpu_buf_tail[`IOB_CPU_BUF_INDEX-1:0];
   
   // Send tail pointer to BSC clock domain
   dffrle_ns #(`IOB_CPU_BUF_INDEX+1) cpu_buf_tail_f_ff (.din(cpu_buf_tail),
							.rst_l(cpu_rst_l),
							.en(tx_sync),
							.clk(cpu_clk),
							.q(cpu_buf_tail_f));
   

   // Flop head pointer to convert to CPU clock domain
   dffrle_ns #(`IOB_CPU_BUF_INDEX+1) cpu_buf_head_ff (.din(cpu_buf_head_s),
						      .rst_l(cpu_rst_l),
						      .en(rx_sync),
						      .clk(cpu_clk),
						      .q(cpu_buf_head));


   /************************************************************************
    *                                                   __tail incremented here
    *                                      flop req    |  for packet in PX2
    *                                          |       |
    *                                          |       |    compute    __stall sent here  
    *                                          |       |      hwm     |
    *                                          |       |       |      |
    *                                          V       V       V      V
    *     PQ      PA      PX1     rptr    PX2     C1      C2      C3      rtpr
    *             PQ      PA      PX1     rptr    PX2     C1      C2      C3      rptr
    *                     PQ      PA      PX1     rptr    PX2     C1      C2      C3      rptr
    *                             PQ      PA      PX1     rptr    PX2     C1      C2      C3      rptr
    *                                     PQ      PA      PX1     rptr    PX2     C1      C2      C3      rptr
    *                                             PQ      PA      PX1     rptr    PX2     C1      C2      C3      rptr
    *                                                     PQ      PA      PX1     rptr    PX2     C1      C2      C3      rptr
    *                                                             PQ      PA      PX1     rptr    PX2     C1      C2      C3      rptr
    *                                                                     PQ      PA      PX1     rptr    PX2     C1      C2      C3      rptr
    *                                                                         --> PQ      PA      
    *                                                                        |    
    *                                                                        |    
    *                                                           packet in this PQ is stalled
    * 
    * When the stall is signalled, there can potentially be 8 packets in
    * C2, C1, PX2, rptr, PX1, PA, PQ, and PQ-1 that need to be queued in
    * the CPU shared buffer.
    * Hence, the high water mark is 16 - 8 = 8.
    ************************************************************************/
   // Assert stall to crossbar if we are 7 or less entries away from filling
   // up cpu buffer.
   assign 	cpu_buf_tail_plus8 = cpu_buf_tail + 5'b01000;
   
   assign 	cpu_buf_hit_hwm = ((cpu_buf_tail_plus8[`IOB_CPU_BUF_INDEX] != cpu_buf_head[`IOB_CPU_BUF_INDEX]) &
	             		   (cpu_buf_tail_plus8[`IOB_CPU_BUF_INDEX-1:0] >= cpu_buf_head[`IOB_CPU_BUF_INDEX-1:0])) |
				  ((cpu_buf_tail_plus8[`IOB_CPU_BUF_INDEX] == cpu_buf_head[`IOB_CPU_BUF_INDEX]) &
	             		   (cpu_buf_tail_plus8[`IOB_CPU_BUF_INDEX-1:0] <= cpu_buf_head[`IOB_CPU_BUF_INDEX-1:0]));
   
   dffrl_ns #(1) iob_pcx_stall_pq_ff (.din(cpu_buf_hit_hwm | int_buf_hit_hwm),
				      .clk(cpu_clk),
				      .rst_l(cpu_rst_l),
				      .q(iob_pcx_stall_pq));
   

endmodule // c2i_fctrl

