// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: c2i_fdp.v
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
//  Module Name:	c2i_fdp (cpu-to-io fast datapath)
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
module c2i_fdp (/*AUTOARG*/
   // Outputs
   pcx_iob_vld, pcx_iob_req, pcx_iob_addr, pcx_iob_cputhr, 
   int_buf_din_raw, tap_mondo_dout_d2_f, mondo_data0_din_lo, 
   mondo_data0_din_hi, mondo_data1_din_lo, mondo_data1_din_hi, 
   mondo_source_din, mondo_busy_din_p1, mondo_busy_din_p2, 
   cpu_buf_din_lo, cpu_buf_din_hi, 
   // Inputs
   cpu_clk, tx_sync, rx_sync, pcx_iob_data_px2, io_mondo_data_wr, 
   mondo_data_bypass_d1, mondo_addr_creg_mdata0_dec_d1, 
   mondo_addr_creg_mdata1_dec_d1, mondo_addr_creg_mbusy_dec_d1, 
   cpu_mondo_rd_d1, tap_mondo_rd_d1, cpu_mondo_rd_d2, 
   cpu_mondo_addr_invld_d2, mondo_data_addr_p0_d1, 
   io_mondo_data0_din_s, io_mondo_data1_din_s, io_mondo_source_din_s, 
   tap_mondo_din_s, mondo_data0_dout_lo, mondo_data0_dout_hi, 
   mondo_data1_dout_lo, mondo_data1_dout_hi, mondo_source_dout, 
   mondo_busy_dout
   );
   
////////////////////////////////////////////////////////////////////////
// Interface signal type declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input 			      cpu_clk;
   input 			      tx_sync;
   input 			      rx_sync;
   
   
   // Crossbar interface
   input [`PCX_WIDTH-1:0] 	      pcx_iob_data_px2;


   // c2i fast control interface
   output 		              pcx_iob_vld;
   output [`PCX_RQ_HI-`PCX_RQ_LO:0]   pcx_iob_req;
   output [`PCX_AD_HI-`PCX_AD_LO:0]   pcx_iob_addr;
   output [`PCX_CP_HI-`PCX_TH_LO:0]   pcx_iob_cputhr;
   
   input 			      io_mondo_data_wr;
   input 			      mondo_data_bypass_d1;
   input 			      mondo_addr_creg_mdata0_dec_d1;
   input 			      mondo_addr_creg_mdata1_dec_d1;
   input 			      mondo_addr_creg_mbusy_dec_d1;
   input 			      cpu_mondo_rd_d1;
   input 			      tap_mondo_rd_d1;
   input 			      cpu_mondo_rd_d2;
   input 			      cpu_mondo_addr_invld_d2;
   
   input [`IOB_MONDO_DATA_INDEX-1:0]  mondo_data_addr_p0_d1;

   
   // i2c fast datapath interface
   wire [`IOB_INT_BUF_WIDTH-1:0]      int_buf_din;
   output [159:0] 		      int_buf_din_raw;

   assign 	int_buf_din_raw = {{(160-`IOB_INT_BUF_WIDTH){1'b0}},int_buf_din};

   
   // i2c slow datapath interface
   input [`IOB_MONDO_DATA_WIDTH-1:0]  io_mondo_data0_din_s;
   input [`IOB_MONDO_DATA_WIDTH-1:0]  io_mondo_data1_din_s;
   input [`IOB_MONDO_SRC_WIDTH-1:0]   io_mondo_source_din_s;


   // IOB control interface
   input [63:0] 		      tap_mondo_din_s;
   output [63:0] 		      tap_mondo_dout_d2_f;

   
   // Mondo data table interface
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   mondo_data0_din;
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   mondo_data0_dout;
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   mondo_data1_din;
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   mondo_data1_dout;
   
   output [64:0] 		      mondo_data0_din_lo;
   input [64:0] 		      mondo_data0_dout_lo;
   output [64:0] 		      mondo_data0_din_hi;
   input [64:0] 		      mondo_data0_dout_hi;
   
   output [64:0] 		      mondo_data1_din_lo;
   input [64:0] 		      mondo_data1_dout_lo;
   output [64:0] 		      mondo_data1_din_hi;
   input [64:0] 		      mondo_data1_dout_hi;
   
   assign 	mondo_data0_din_lo = {{(65-`IOB_MONDO_DATA_WIDTH){1'b0}},mondo_data0_din};
   assign 	mondo_data0_din_hi = {{(65-`IOB_MONDO_DATA_WIDTH){1'b0}},mondo_data0_din};
   assign 	mondo_data0_dout = mondo_data_addr_p0_d1[`IOB_MONDO_DATA_INDEX-1] ?
		                   mondo_data0_dout_hi[`IOB_MONDO_DATA_WIDTH-1:0] :
		                   mondo_data0_dout_lo[`IOB_MONDO_DATA_WIDTH-1:0];
   
   assign 	mondo_data1_din_lo = {{(65-`IOB_MONDO_DATA_WIDTH){1'b0}},mondo_data1_din};
   assign 	mondo_data1_din_hi = {{(65-`IOB_MONDO_DATA_WIDTH){1'b0}},mondo_data1_din};
   assign 	mondo_data1_dout = mondo_data_addr_p0_d1[`IOB_MONDO_DATA_INDEX-1] ?
		                   mondo_data1_dout_hi[`IOB_MONDO_DATA_WIDTH-1:0] :
		                   mondo_data1_dout_lo[`IOB_MONDO_DATA_WIDTH-1:0];
   
   output [`IOB_MONDO_SRC_WIDTH-1:0]  mondo_source_din;
   input [`IOB_MONDO_SRC_WIDTH-1:0]   mondo_source_dout;
   output 			      mondo_busy_din_p1;
   output 			      mondo_busy_din_p2;
   input 			      mondo_busy_dout;
   
   
   // Cpu buffer interface
   wire [`PCX_WIDTH-1:0] 	      cpu_buf_din;
   output [64:0] 		      cpu_buf_din_lo;
   output [64:0] 		      cpu_buf_din_hi;
   
   assign       cpu_buf_din_lo = {1'b0,cpu_buf_din[63:0]};
   assign       cpu_buf_din_hi = {{(129-`PCX_WIDTH){1'b0}},cpu_buf_din[`PCX_WIDTH-1:64]};

   
   // Internal signals
   wire [`PCX_WIDTH-1:0] 	      pcx_iob_data;
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   io_mondo_data0_din;
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   io_mondo_data1_din;
   wire [`IOB_MONDO_SRC_WIDTH-1:0]    io_mondo_source_din;
   wire [63:0] 			      tap_mondo_din;
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   mondo_data0_din_d1;
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   mondo_data1_din_d1;
   wire [`IOB_MONDO_SRC_WIDTH-1:0]    mondo_source_din_d1;
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   mondo_data0_dout_byp;
   wire [`IOB_MONDO_DATA_WIDTH-1:0]   mondo_data1_dout_byp;
   wire [`IOB_MONDO_SRC_WIDTH-1:0]    mondo_source_dout_byp;
   wire [63:0] 			      mondo_dout;
   wire [63:0] 			      cpu_mondo_dout_d2;
   wire [`IOB_CPU_INDEX-1:0] 	      cpu_mondo_cpu_id_d1;
   wire [`IOB_CPU_INDEX-1:0] 	      cpu_mondo_cpu_id_d2;
   wire [`IOB_THR_INDEX-1:0] 	      cpu_mondo_thr_id_d1;
   wire [`IOB_THR_INDEX-1:0] 	      cpu_mondo_thr_id_d2;
   wire [`PCX_P_HI-`PCX_P_LO:0]       cpu_mondo_pkt_id_d1;
   wire [`PCX_P_HI-`PCX_P_LO:0]       cpu_mondo_pkt_id_d2;
   wire 			      cpu_mondo_b109_d1;
   wire 			      cpu_mondo_b109_d2;
   wire [`IOB_CPU_WIDTH-1:0] 	      cpu_mondo_cpu_id_dec_d2;
   wire [63:0] 			      tap_mondo_dout_d2;
   

////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /*****************************************************************
    * Flop data from PCX
    *****************************************************************/ 
   dff_ns #(`PCX_WIDTH) pcx_iob_data_ff (.din(pcx_iob_data_px2),
					 .clk(cpu_clk),
					 .q(pcx_iob_data));

   assign       cpu_buf_din = pcx_iob_data;
   
   assign 	pcx_iob_vld = pcx_iob_data[`PCX_VLD];
   assign 	pcx_iob_req = pcx_iob_data[`PCX_RQ_HI:`PCX_RQ_LO];
   assign 	pcx_iob_addr = pcx_iob_data[`PCX_AD_HI:`PCX_AD_LO];
   assign 	pcx_iob_cputhr = pcx_iob_data[`PCX_CP_HI:`PCX_TH_LO];
   

   /*****************************************************************
    * Mondo data0/data1/busy table write data
    *****************************************************************/
   // Convert from BSC to CPU clock
   dffe_ns #(`IOB_MONDO_DATA_WIDTH) io_mondo_data0_din_ff (.din(io_mondo_data0_din_s),
						      	   .en(rx_sync),
						      	   .clk(cpu_clk),
						      	   .q(io_mondo_data0_din));
   
   dffe_ns #(`IOB_MONDO_DATA_WIDTH) io_mondo_data1_din_ff (.din(io_mondo_data1_din_s),
						      	   .en(rx_sync),
						      	   .clk(cpu_clk),
						      	   .q(io_mondo_data1_din));
   
   dffe_ns #(`IOB_MONDO_SRC_WIDTH) io_mondo_source_din_ff (.din(io_mondo_source_din_s),
						      	   .en(rx_sync),
						      	   .clk(cpu_clk),
						      	   .q(io_mondo_source_din));
   
   dffe_ns #(64) tap_mondo_din_ff (.din(tap_mondo_din_s),
				   .en(rx_sync),
				   .clk(cpu_clk),
				   .q(tap_mondo_din));

   assign 	mondo_data0_din = io_mondo_data_wr ? io_mondo_data0_din :
	                                             tap_mondo_din;
   
   dff_ns #(`IOB_MONDO_DATA_WIDTH) mondo_data0_din_d1_ff (.din(mondo_data0_din),
							  .clk(cpu_clk),
							  .q(mondo_data0_din_d1));
   
   assign 	mondo_data1_din = io_mondo_data_wr ? io_mondo_data1_din :
	                                             tap_mondo_din;
   
   dff_ns #(`IOB_MONDO_DATA_WIDTH) mondo_data1_din_d1_ff (.din(mondo_data1_din),
							  .clk(cpu_clk),
							  .q(mondo_data1_din_d1));
   
   assign 	mondo_source_din = io_mondo_data_wr ? io_mondo_source_din :
	                                              tap_mondo_din[`IOB_MONDO_SRC_WIDTH-1:0];
   
   dff_ns #(`IOB_MONDO_SRC_WIDTH) mondo_source_din_d1_ff (.din(mondo_source_din),
							  .clk(cpu_clk),
							  .q(mondo_source_din_d1));

   assign 	mondo_busy_din_p1 = io_mondo_data_wr ? 1'b1 :
		                                       tap_mondo_din[`IOB_MONDO_BUSY];
   
   assign 	mondo_busy_din_p2 = pcx_iob_data[`IOB_MONDO_BUSY];
   
   
   /*****************************************************************
    * Mondo data0/data1/busy table read data (CPU read)
    *****************************************************************/ 
   assign 	mondo_data0_dout_byp = mondo_data_bypass_d1 ? mondo_data0_din_d1 :
	                                                      mondo_data0_dout;
   
   assign 	mondo_data1_dout_byp = mondo_data_bypass_d1 ? mondo_data1_din_d1 :
	                                                      mondo_data1_dout;
   
   assign 	mondo_source_dout_byp = mondo_data_bypass_d1 ? mondo_source_din_d1 :
	                                                       mondo_source_dout;

   // Use AND/OR to implement a 4-to-1 mux
   assign 	mondo_dout = ({64{mondo_addr_creg_mdata0_dec_d1}}  & mondo_data0_dout_byp) |
                             ({64{mondo_addr_creg_mdata1_dec_d1}}  & mondo_data1_dout_byp) |
		             ({64{mondo_addr_creg_mbusy_dec_d1}}   & {58'b0,mondo_busy_dout,mondo_source_dout_byp});
   
   dffe_ns #(64) cpu_mondo_dout_d2_ff (.din(mondo_dout),
				       .en(cpu_mondo_rd_d1),
				       .clk(cpu_clk),
				       .q(cpu_mondo_dout_d2));

   
   dff_ns #(`IOB_CPU_INDEX) cpu_mondo_cpu_id_d1_ff (.din(pcx_iob_data[`PCX_CP_HI:`PCX_CP_LO]),
						    .clk(cpu_clk),
						    .q(cpu_mondo_cpu_id_d1));
   
   dff_ns #(`IOB_CPU_INDEX) cpu_mondo_cpu_id_d2_ff (.din(cpu_mondo_cpu_id_d1),
						    .clk(cpu_clk),
						    .q(cpu_mondo_cpu_id_d2));
   
   
   dff_ns #(`IOB_THR_INDEX) cpu_mondo_thr_id_d1_ff (.din(pcx_iob_data[`PCX_TH_HI:`PCX_TH_LO]),
						    .clk(cpu_clk),
						    .q(cpu_mondo_thr_id_d1));
   
   dff_ns #(`IOB_THR_INDEX) cpu_mondo_thr_id_d2_ff (.din(cpu_mondo_thr_id_d1),
						    .clk(cpu_clk),
						    .q(cpu_mondo_thr_id_d2));

   
   dff_ns #(`PCX_P_HI-`PCX_P_LO+1) cpu_mondo_pkt_id_d1_ff (.din(pcx_iob_data[`PCX_P_HI:`PCX_P_LO]),
							   .clk(cpu_clk),
							   .q(cpu_mondo_pkt_id_d1));
   
   dff_ns #(`PCX_P_HI-`PCX_P_LO+1) cpu_mondo_pkt_id_d2_ff (.din(cpu_mondo_pkt_id_d1),
							   .clk(cpu_clk),
							   .q(cpu_mondo_pkt_id_d2));

   
   dff_ns #(1) cpu_mondo_b109_d1_ff (.din(pcx_iob_data[109]),
				     .clk(cpu_clk),
				     .q(cpu_mondo_b109_d1));
   
   dff_ns #(1) cpu_mondo_b109_d2_ff (.din(cpu_mondo_b109_d1),
				     .clk(cpu_clk),
				     .q(cpu_mondo_b109_d2));

   
   assign 	cpu_mondo_cpu_id_dec_d2 = 1'b1 << cpu_mondo_cpu_id_d2;
   
   assign 	int_buf_din = cpu_mondo_rd_d2 ?
		              // read ack to CPU
		              {cpu_mondo_cpu_id_dec_d2,               // cpu ID
			       1'b1,                                  // valid            [144]
			       `LOAD_RET,                             // return type      [143:140]
			       1'b0,cpu_mondo_addr_invld_d2,1'b0,     // error            [139:137]
			       1'b1,                                  // NC               [136]
			       cpu_mondo_thr_id_d2,                   // thread ID        [135:134]
			       3'b0,                                  // WV, W, W         [133:131]
			       3'b0,                                  // X, atomic, 0     [130:128]
	                       cpu_mondo_dout_d2,                     // interrupt status [127:64]
			       cpu_mondo_dout_d2} :                   // interrupt status [63:0]
		              // write ack to CPU
		              {cpu_mondo_cpu_id_dec_d2,               // cpu ID
			       1'b1,                                  // valid            [144]
			       `ST_ACK,                               // return type      [143:140]
			       3'b0,                                  // error            [139:137]
			       1'b1,                                  // NC               [136]
			       cpu_mondo_thr_id_d2,                   // thread ID        [135:134]
			       2'b0,                                  // XX               [133:132]
			       cpu_mondo_pkt_id_d2,                   // packet ID        [131:130]
			       1'b0,                                  // atomic           [129]
			       1'b0,                                  // 0                [128]
			       2'b0,                                  // XX               [127:0]
			       cpu_mondo_b109_d2,                     // reflect pcx[109] to cpx[125] for blk-st/binit-st
			       4'b0,                                  // XXXX
			       cpu_mondo_cpu_id_d2,                   // cpu ID
			       118'b0};                               // un-used            
   
   
   /*****************************************************************
    * Interrupt status table, Mondo data0/data1/busy table read data (TAP read)
    *****************************************************************/ 
   dffe_ns #(64) tap_mondo_dout_d2_ff (.din(mondo_dout),
				       .en(tap_mondo_rd_d1),
				       .clk(cpu_clk),
				       .q(tap_mondo_dout_d2));

   // Send result back to BSC clock domain   
   dffe_ns #(64) tap_mondo_dout_d2_f_ff (.din(tap_mondo_dout_d2),
					 .en(tx_sync),
					 .clk(cpu_clk),
					 .q(tap_mondo_dout_d2_f));
   

endmodule // c2i_fdp

// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
