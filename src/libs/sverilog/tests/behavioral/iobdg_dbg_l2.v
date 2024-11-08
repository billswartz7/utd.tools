// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_dbg_l2.v
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
//  Module Name:	iobdg_dbg_l2 (IO Bridge debug/visibility)
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
module iobdg_dbg_l2 (/*AUTOARG*/
   // Outputs
   l2_dbg_vld, l2_dbg_tstamp, l2_dbg_data, iob_clk_l2_tr, 
   l2_vis_buf_wr_lo_l, l2_vis_buf_wr_hi_l, l2_vis_buf_rd_lo_l, 
   l2_vis_buf_rd_hi_l, l2_vis_buf_tail_ptr, l2_vis_buf_head_ptr, 
   l2_vis_buf_din_lo, l2_vis_buf_din_hi, 
   // Inputs
   cpu_rst_l, rst_l, cpu_clk, clk, tx_sync, rx_sync, l2_dbgbus_01, 
   l2_dbgbus_23, dbg_en_01, dbg_en_23, creg_dbg_l2_vis_ctrl, 
   creg_dbg_l2_vis_maska_s, creg_dbg_l2_vis_cmpa_s, 
   creg_dbg_l2_vis_maskb_s, creg_dbg_l2_vis_cmpb_s, 
   creg_dbg_l2_vis_trig_delay_s, l2_vis_buf_dout_lo, 
   l2_vis_buf_dout_hi
   );

////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input                                    cpu_rst_l;
   input                                    rst_l;
   input 				    cpu_clk;
   input 				    clk;
   input 				    tx_sync;
   input 				    rx_sync;

   
   // L2 interface
   input [39:0] 			    l2_dbgbus_01;
   input [39:0] 			    l2_dbgbus_23;
   input 				    dbg_en_01;
   input 				    dbg_en_23;

   
   // Debug port interface
   output 				    l2_dbg_vld;
   output [7:0] 			    l2_dbg_tstamp;
   output [39:0] 			    l2_dbg_data;

   
   // Clock unit interface
   output 				    iob_clk_l2_tr;

   
   // Control
   input [63:0] 			    creg_dbg_l2_vis_ctrl;
   input [63:0]				    creg_dbg_l2_vis_maska_s;
   input [63:0]				    creg_dbg_l2_vis_cmpa_s;
   input [63:0]				    creg_dbg_l2_vis_maskb_s;
   input [63:0]				    creg_dbg_l2_vis_cmpb_s;
   input [63:0] 			    creg_dbg_l2_vis_trig_delay_s;
   
   
   // L2 vis buffer interface
   output 				    l2_vis_buf_wr_lo_l;
   output 				    l2_vis_buf_wr_hi_l;
   output 				    l2_vis_buf_rd_lo_l;
   output 				    l2_vis_buf_rd_hi_l;
   
   output [`IOB_L2_VIS_BUF_INDEX-1:0] 	    l2_vis_buf_tail_ptr;
   output [`IOB_L2_VIS_BUF_INDEX-1:0] 	    l2_vis_buf_head_ptr;
   
   wire [`IOB_L2_VIS_BUF_WIDTH-1:0] 	    l2_vis_buf_din;
   wire [`IOB_L2_VIS_BUF_WIDTH-1:0] 	    l2_vis_buf_dout;
   
   output [64:0] 			    l2_vis_buf_din_lo;
   output [64:0] 			    l2_vis_buf_din_hi;
   input [64:0] 			    l2_vis_buf_dout_lo;
   input [64:0] 			    l2_vis_buf_dout_hi;
   wire [`IOB_L2_VIS_BUF_INDEX:0] 	    l2_vis_buf_head_d1;
   
   assign 	l2_vis_buf_din_lo = {{(65-`IOB_L2_VIS_BUF_WIDTH){1'b0}},l2_vis_buf_din};
   assign 	l2_vis_buf_din_hi = {{(65-`IOB_L2_VIS_BUF_WIDTH){1'b0}},l2_vis_buf_din};
   assign 	l2_vis_buf_dout = l2_vis_buf_head_d1[`IOB_L2_VIS_BUF_INDEX-1] ?
		                  l2_vis_buf_dout_hi[`IOB_L2_VIS_BUF_WIDTH-1:0] :
		                  l2_vis_buf_dout_lo[`IOB_L2_VIS_BUF_WIDTH-1:0];
   
   
   // Internal signals
   wire 	                            creg_dbg_l2_vis_ctrl_en;
   wire [63:0]				    creg_dbg_l2_vis_maska;
   wire [63:0]				    creg_dbg_l2_vis_cmpa;
   wire [63:0]				    creg_dbg_l2_vis_maskb;
   wire [63:0]				    creg_dbg_l2_vis_cmpb;
   wire [63:0] 				    creg_dbg_l2_vis_trig_delay;
   
   wire [7:0] 				    l2_timestamp;
   wire [7:0] 				    l2_timestamp_plus1;
   wire [39:0] 				    l2_dbgbus_01_d1;
   wire [39:0] 				    l2_dbgbus_23_d1;
   wire 				    dbg_en_01_d1;
   wire 				    dbg_en_23_d1;
   wire [39:0]				    l2_dbgbus;
   wire [38:0]				    l2_dbgbus_d1;
   wire 				    l2_dbgbus_vld;
   wire 				    l2_dbgbus_vld_d1;
   wire [38:0] 				    l2_vis_maska;
   wire [38:0] 				    l2_vis_cmpa;
   wire 				    l2_trig_a;
   wire [38:0] 				    l2_vis_maskb;
   wire [38:0] 				    l2_vis_cmpb;
   wire 				    l2_trig_b;
   wire 				    l2_vis_buf_wr;
   wire 				    l2_vis_buf_wr_lo;
   wire 				    l2_vis_buf_wr_hi;
   wire 				    l2_vis_buf_tail_inc;
   wire [`IOB_L2_VIS_BUF_INDEX:0] 	    l2_vis_buf_tail;
   wire [`IOB_L2_VIS_BUF_INDEX:0] 	    l2_vis_buf_tail_plus1;
   wire [`IOB_L2_VIS_BUF_INDEX:0] 	    l2_vis_buf_tail_f;
   wire [`IOB_L2_VIS_BUF_INDEX:0] 	    l2_vis_buf_head_cpu;
   wire 				    l2_vis_buf_hwm;
   wire 				    l2_vis_buf_drop;
   wire [`IOB_L2_VIS_BUF_INDEX:0] 	    l2_vis_buf_head;
   wire [`IOB_L2_VIS_BUF_INDEX:0] 	    l2_vis_buf_head_plus1;
   wire [`IOB_L2_VIS_BUF_INDEX:0] 	    l2_vis_buf_head_s;
   wire [`IOB_L2_VIS_BUF_INDEX:0] 	    l2_vis_buf_tail_jbus;
   wire 				    l2_vis_buf_empty;
   wire 				    l2_vis_buf_rd;
   wire 				    l2_vis_buf_rd_lo;
   wire 				    l2_vis_buf_rd_hi;
   wire 				    l2_vis_buf_empty_d1;
   wire 				    l2_vis_buf_head_inc;
   wire 				    l2_dbg_vld_a1;
   wire [`IOB_L2_VIS_BUF_WIDTH-1:0] 	    l2_vis_buf_dout_d1;
   
   wire 				    l2_trig_pulse;
   wire [31:0] 				    l2_trig_counter_next;
   wire [31:0] 				    l2_trig_counter;
   wire 				    l2_trig_counter_on;
   wire 				    l2_trig_step_next;
   wire 				    l2_trig_step;
   wire 				    l2_trig;
   wire 				    l2_trig_f;
   wire 				    l2_trig_s;
   wire 				    iob_clk_l2_tr_a1;

 
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /*****************************************************************
    * Convert frequency for control registers that need to be used
    * in the CPU clk domain
    *****************************************************************/
   dffe_ns #(1) creg_dbg_l2_vis_ctrl_en_ff (.din(creg_dbg_l2_vis_ctrl[3]),
					    .en(rx_sync),
					    .clk(cpu_clk),
					    .q(creg_dbg_l2_vis_ctrl_en));
   
   dffe_ns #(64) creg_dbg_l2_vis_maska_ff (.din(creg_dbg_l2_vis_maska_s),
					   .en(rx_sync),
					   .clk(cpu_clk),
					   .q(creg_dbg_l2_vis_maska));
   
   dffe_ns #(64) creg_dbg_l2_vis_maskb_ff (.din(creg_dbg_l2_vis_maskb_s),
					   .en(rx_sync),
					   .clk(cpu_clk),
					   .q(creg_dbg_l2_vis_maskb));
   
   dffe_ns #(64) creg_dbg_l2_vis_cmpa_ff (.din(creg_dbg_l2_vis_cmpa_s),
					  .en(rx_sync),
					  .clk(cpu_clk),
					  .q(creg_dbg_l2_vis_cmpa));
   
   dffe_ns #(64) creg_dbg_l2_vis_cmpb_ff (.din(creg_dbg_l2_vis_cmpb_s),
					  .en(rx_sync),
					  .clk(cpu_clk),
					  .q(creg_dbg_l2_vis_cmpb));
   
   dffe_ns #(64) creg_dbg_l2_vis_trig_delay_ff (.din(creg_dbg_l2_vis_trig_delay_s),
						.en(rx_sync),
						.clk(cpu_clk),
						.q(creg_dbg_l2_vis_trig_delay));

   
   /*****************************************************************
    * L2 visibility port - CPU clk
    *****************************************************************/
   // L2 visibility timestamp
   assign 	l2_timestamp_plus1 = l2_timestamp + 8'b01;

   dffrl_ns #(8) l2_timestamp_ff (.din(l2_timestamp_plus1),
				  .clk(cpu_clk),
				  .rst_l(cpu_rst_l),
				  .q(l2_timestamp));

   // flop debug buses coming from L2
   dff_ns #(40) l2_dbgbus_01_d1_ff (.din(l2_dbgbus_01),
				    .clk(cpu_clk),
				    .q(l2_dbgbus_01_d1));

   dff_ns #(40) l2_dbgbus_23_d1_ff (.din(l2_dbgbus_23),
				    .clk(cpu_clk),
				    .q(l2_dbgbus_23_d1));

   dffrl_ns #(1) dbg_en_01_d1_ff (.din(dbg_en_01),
				  .clk(cpu_clk),
				  .rst_l(cpu_rst_l),
				  .q(dbg_en_01_d1));
   
   dffrl_ns #(1) dbg_en_23_d1_ff (.din(dbg_en_23),
				  .clk(cpu_clk),
				  .rst_l(cpu_rst_l),
				  .q(dbg_en_23_d1));
   
   assign 	l2_dbgbus = dbg_en_01_d1 ? l2_dbgbus_01_d1 : l2_dbgbus_23_d1;

   assign 	l2_dbgbus_vld = (dbg_en_01_d1 | dbg_en_23_d1) & l2_dbgbus[39] & creg_dbg_l2_vis_ctrl_en;
				
   dff_ns #(39) l2_dbgbus_d1_ff (.din(l2_dbgbus[38:0]),
				 .clk(cpu_clk),
				 .q(l2_dbgbus_d1));

   dffrl_ns #(1) l2_dbgbus_vld_d1_ff (.din(l2_dbgbus_vld),
				      .clk(cpu_clk),
				      .rst_l(cpu_rst_l),
				      .q(l2_dbgbus_vld_d1));


   assign 	l2_vis_maska = {creg_dbg_l2_vis_maska[51:48],
				creg_dbg_l2_vis_maska[44:40],
				creg_dbg_l2_vis_maska[33:8],
				creg_dbg_l2_vis_maska[5:2]};

   assign 	l2_vis_cmpa = {creg_dbg_l2_vis_cmpa[51:48],
			       creg_dbg_l2_vis_cmpa[44:40],
			       creg_dbg_l2_vis_cmpa[33:8],
			       creg_dbg_l2_vis_cmpa[5:2]};
   
   assign 	l2_trig_a = l2_dbgbus_vld_d1 &
		            ((l2_dbgbus_d1 & l2_vis_maska) == l2_vis_cmpa);
   

   assign 	l2_vis_maskb = {creg_dbg_l2_vis_maskb[51:48],
				creg_dbg_l2_vis_maskb[44:40],
				creg_dbg_l2_vis_maskb[33:8],
				creg_dbg_l2_vis_maskb[5:2]};

   assign 	l2_vis_cmpb = {creg_dbg_l2_vis_cmpb[51:48],
			       creg_dbg_l2_vis_cmpb[44:40],
			       creg_dbg_l2_vis_cmpb[33:8],
			       creg_dbg_l2_vis_cmpb[5:2]};
   
   assign 	l2_trig_b = l2_dbgbus_vld_d1 &
		            ((l2_dbgbus_d1 & l2_vis_maskb) == l2_vis_cmpb);
   

   assign 	l2_vis_buf_wr = (l2_trig_a | l2_trig_b);
   assign 	l2_vis_buf_wr_lo = l2_vis_buf_wr & ~l2_vis_buf_tail_ptr[`IOB_L2_VIS_BUF_INDEX-1];
   assign 	l2_vis_buf_wr_hi = l2_vis_buf_wr & l2_vis_buf_tail_ptr[`IOB_L2_VIS_BUF_INDEX-1];
   
   assign 	l2_vis_buf_wr_lo_l = ~l2_vis_buf_wr_lo;
   assign 	l2_vis_buf_wr_hi_l = ~l2_vis_buf_wr_hi;
   
   assign 	l2_vis_buf_tail_inc = l2_vis_buf_wr & ~l2_vis_buf_hwm;
   
   // Tail pointer to L2_VIS buffer
   dffrle_ns #(`IOB_L2_VIS_BUF_INDEX+1) l2_vis_buf_tail_ff (.din(l2_vis_buf_tail_plus1),
							    .rst_l(cpu_rst_l),
							    .en(l2_vis_buf_tail_inc),
							    .clk(cpu_clk),
							    .q(l2_vis_buf_tail));
   
   assign 	l2_vis_buf_tail_plus1 = l2_vis_buf_tail + 6'b1;
   
   assign 	l2_vis_buf_tail_ptr = l2_vis_buf_tail[`IOB_L2_VIS_BUF_INDEX-1:0];

   
   // Send tail pointer to JBUS clock domain
   dffrle_ns #(`IOB_L2_VIS_BUF_INDEX+1) l2_vis_buf_tail_f_ff (.din(l2_vis_buf_tail),
							      .rst_l(cpu_rst_l),
							      .en(tx_sync),
							      .clk(cpu_clk),
							      .q(l2_vis_buf_tail_f));
   
   // Flop head pointer to convert to CPU clock domain
   dffrle_ns #(`IOB_L2_VIS_BUF_INDEX+1) l2_vis_buf_head_cpu_ff (.din(l2_vis_buf_head_s),
								.rst_l(cpu_rst_l),
								.en(rx_sync),
								.clk(cpu_clk),
								.q(l2_vis_buf_head_cpu));

   assign 	l2_vis_buf_hwm = (l2_vis_buf_tail_plus1[`IOB_L2_VIS_BUF_INDEX] != l2_vis_buf_head_cpu[`IOB_L2_VIS_BUF_INDEX]) &
				 (l2_vis_buf_tail_plus1[`IOB_L2_VIS_BUF_INDEX-1:0] == l2_vis_buf_head_cpu[`IOB_L2_VIS_BUF_INDEX-1:0]);
   
   // Set drop bit for next entry
   dffrle_ns #(1) l2_vis_buf_drop_ff (.din(l2_vis_buf_hwm),
				      .rst_l(cpu_rst_l),
				      .en(l2_vis_buf_wr),
				      .clk(cpu_clk),
				      .q(l2_vis_buf_drop));
   
   assign 	l2_vis_buf_din = {l2_timestamp,l2_dbgbus_d1[38:35],l2_vis_buf_drop,l2_dbgbus_d1[34:0]};

   
   /*****************************************************************
    * L2 visibility port - JBUS clk
    *****************************************************************/
   // Head pointer to L2_VIS buffer
   dffrl_ns #(`IOB_L2_VIS_BUF_INDEX+1) l2_vis_buf_head_d1_ff (.din(l2_vis_buf_head),
							      .clk(clk),
							      .rst_l(rst_l),
							      .q(l2_vis_buf_head_d1));
   
   assign       l2_vis_buf_head_plus1 = l2_vis_buf_head_d1 + 6'b1;
   
   assign 	l2_vis_buf_head = l2_vis_buf_head_inc ? l2_vis_buf_head_plus1 :
	                                                l2_vis_buf_head_d1;
   
   assign 	l2_vis_buf_head_ptr = l2_vis_buf_head[`IOB_L2_VIS_BUF_INDEX-1:0];
   
   assign 	l2_vis_buf_head_s = l2_vis_buf_head_d1;
   
   // Flop tail pointer to convert to JBUS clock domain
   dffrl_ns #(`IOB_L2_VIS_BUF_INDEX+1) l2_vis_buf_tail_jbus_ff (.din(l2_vis_buf_tail_f),
							       .clk(clk),
							       .rst_l(rst_l),
							       .q(l2_vis_buf_tail_jbus));

   // L2_vis buffer is empty if head == tail  
   assign 	l2_vis_buf_empty = (l2_vis_buf_head == l2_vis_buf_tail_jbus);

   assign 	l2_vis_buf_rd = ~l2_vis_buf_empty;
   assign 	l2_vis_buf_rd_lo = l2_vis_buf_rd & ~l2_vis_buf_head_ptr[`IOB_L2_VIS_BUF_INDEX-1];
   assign 	l2_vis_buf_rd_hi = l2_vis_buf_rd & l2_vis_buf_head_ptr[`IOB_L2_VIS_BUF_INDEX-1];
   assign 	l2_vis_buf_rd_lo_l = ~l2_vis_buf_rd_lo;
   assign 	l2_vis_buf_rd_hi_l = ~l2_vis_buf_rd_hi;
   
   dff_ns #(1) l2_vis_buf_empty_d1_ff (.din(l2_vis_buf_empty|~rst_l),
				       .clk(clk),
				       .q(l2_vis_buf_empty_d1));

   assign 	l2_vis_buf_head_inc = ~l2_vis_buf_empty_d1;

   // Send signals to debug block
   assign 	l2_dbg_vld_a1 = ~l2_vis_buf_empty_d1;
   
   dffrl_ns #(1) l2_dbg_vld_ff (.din(l2_dbg_vld_a1),
				.clk(clk),
				.rst_l(rst_l),
				.q(l2_dbg_vld));

   dff_ns #(`IOB_L2_VIS_BUF_WIDTH) l2_vis_buf_dout_d1_ff (.din(l2_vis_buf_dout),
							  .clk(clk),
							  .q(l2_vis_buf_dout_d1));

   assign 	{l2_dbg_tstamp,l2_dbg_data} = l2_vis_buf_dout_d1;

   
   /*****************************************************************
    * L2 debug trigger - CPU to JBUS clk
    *****************************************************************/
   // Trigger pulse at cpu clock
   assign 	l2_trig_pulse = l2_trig_b;

   assign 	l2_trig_counter_next =
		l2_trig_counter_on              ? (l2_trig_counter - 32'b1) :
		(l2_trig_pulse & ~l2_trig_step) ? creg_dbg_l2_vis_trig_delay[31:0] :
		                                  l2_trig_counter;

   dffrl_ns #(32) l2_trig_counter_ff (.din(l2_trig_counter_next),
				      .clk(cpu_clk),
				      .rst_l(cpu_rst_l),
				      .q(l2_trig_counter));

   assign 	l2_trig_counter_on = |l2_trig_counter;

   // Trigger step (asserted until trigger is sent to jbus clock) at cpu clock
   assign 	l2_trig_step_next = (l2_trig_step | l2_trig_pulse) &
				      ~(tx_sync & l2_trig);
	  
   dffrl_ns #(1) l2_trig_step_ff (.din(l2_trig_step_next),
				  .clk(cpu_clk),
				  .rst_l(cpu_rst_l),
				  .q(l2_trig_step));

   assign 	l2_trig = l2_trig_step & ~l2_trig_counter_on;
   
		
   dffrle_ns #(1) l2_trig_f_ff (.din(l2_trig),
				.rst_l(cpu_rst_l),
				.en(tx_sync),
				.clk(cpu_clk),
				.q(l2_trig_f));
   
   dffrl_ns #(1) l2_trig_s_ff (.din(l2_trig_f),
			       .clk(clk),
			       .rst_l(rst_l),
			       .q(l2_trig_s));

   assign 	iob_clk_l2_tr_a1 = l2_trig_s & creg_dbg_l2_vis_ctrl[2];
   
   dffrl_ns #(1) iob_clk_l2_tr_ff (.din(iob_clk_l2_tr_a1),
				   .clk(clk),
				   .rst_l(rst_l),
				   .q(iob_clk_l2_tr));
   
endmodule // iobdg_dbg_l2



// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:



