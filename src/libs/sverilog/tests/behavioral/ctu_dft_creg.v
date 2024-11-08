// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_dft_creg.v
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

`include "sys.h"
`include "iop.h"
`include "ctu.h"

module ctu_dft_creg (/*AUTOARG*/
// Outputs
creg_jtag_scratch_data, creg_jtag_rdrtrn_data, creg_jtag_rdrtrn_vld, 
tap_iob_stall, tap_iob_vld, tap_iob_data, rt_ack, rt_data_out, 
// Inputs
io_tck, jbus_clk, jbus_rst_l, io_pwron_rst_l, test_mode_pin, 
bist_mode_pin, start_clk_jl, jtag_creg_addr, jtag_creg_data, 
jtag_creg_rd_en, jtag_creg_wr_en, jtag_creg_addr_en, 
jtag_creg_data_en, jtag_creg_rdrtrn_complete, iob_tap_vld, 
iob_tap_data, iob_tap_stall, rt_valid, rt_addr_data, rt_read_write, 
rt_high_low, rt_data_in, bist_jtag_result
);

//global inputs
input 	      io_tck;
input 	      jbus_clk;
input 	      jbus_rst_l;
input 	      io_pwron_rst_l;
input 	      test_mode_pin;
input 	      bist_mode_pin;

// clspn
input 	      start_clk_jl;

//jtag block interface
input [39:0] jtag_creg_addr;
input [63:0] jtag_creg_data;
input 	     jtag_creg_rd_en;
input 	     jtag_creg_wr_en;
input 	     jtag_creg_addr_en;
input 	     jtag_creg_data_en;
output [63:0] creg_jtag_scratch_data;
output [63:0] creg_jtag_rdrtrn_data;
output 	      creg_jtag_rdrtrn_vld;
input 	      jtag_creg_rdrtrn_complete;

//iob interface
output 	      tap_iob_stall;
input 	      iob_tap_vld;
input [7:0]   iob_tap_data;

output 	      tap_iob_vld;
output [7:0]  tap_iob_data;
input 	      iob_tap_stall;

// ramtest signals
input 	      rt_valid;
input 	      rt_addr_data;
input 	      rt_read_write;
input 	      rt_high_low;
input [31:0]  rt_data_in;
output 	      rt_ack;
output [31:0] rt_data_out;

// bist
input [(`CTU_BIST_CNT*2)-1:0] bist_jtag_result;


////////////////////////////////////////////////////////////////////////
// Interface signal type declarations
////////////////////////////////////////////////////////////////////////
wire [63:0]   creg_jtag_scratch_data;
wire [63:0]   creg_jtag_rdrtrn_data;
wire 	      creg_jtag_rdrtrn_vld;
wire 	      tap_iob_stall;
wire 	      tap_iob_vld;
wire [7:0]    tap_iob_data;
wire 	      rt_ack;
reg [31:0]    rt_data_out;

////////////////////////////////////////////////////////////////////////
// Local signal declarations 
////////////////////////////////////////////////////////////////////////

//inputs from jtag_block synchronized to jbus_clk
wire 	      jtag_creg_rd_en_sync;
wire 	      jtag_creg_wr_en_sync;
wire 	      jtag_creg_addr_en_sync;
wire 	      jtag_creg_data_en_sync;
wire [39:0]   jtag_creg_addr_sync;
wire [63:0]   jtag_creg_data_sync;
wire 	      jtag_creg_rdrtrn_complete_sync;

wire [39:0]   jtag_addr_reg;
wire [63:0]   jtag_data_reg;
wire [63:0]   scratch_reg;
wire [63:0]   rdrtrn_reg;
wire 	      rdrtrn_reg_vld;
wire [7:0]    rt_addr_high;
wire [31:0]   rt_addr_low;
wire [31:0]   rt_data_high;
wire [31:0]   rt_data_low;
wire [7:0]    ramtest_addr_high;
wire [31:0]   ramtest_addr_low;
wire [31:0]   ramtest_data_high;
wire [31:0]   ramtest_data_low;
wire 	      ramtest_rw;
wire [63:0]   ramtest_rdrtrn;
wire 	      ramtest_req;
wire 	      ramtest_rd_pend;
wire 	      jtag_rd_req;
wire 	      jtag_wr_req;
wire 	      jtag_rd_pend;
wire 	      csr_ack_req;
wire [`UCB_BUF_HI-`UCB_BUF_LO:0] csr_buf_id;
wire [`UCB_THR_HI-`UCB_THR_LO:0] csr_thr_id;
wire [39:0]   next_jtag_addr_reg;
wire [63:0]   next_jtag_data_reg;   
wire [63:0]   next_scratch_reg;
wire [63:0]   next_rdrtrn_reg;
wire 	      next_rdrtrn_reg_vld;
reg [7:0]     next_rt_addr_high;
reg [31:0]    next_rt_addr_low;
reg [31:0]    next_rt_data_high;
reg [31:0]    next_rt_data_low;
wire [7:0]    next_ramtest_addr_high;
wire [31:0]   next_ramtest_addr_low;
wire [31:0]   next_ramtest_data_high;
wire [31:0]   next_ramtest_data_low;
wire 	      next_ramtest_rw;
wire [63:0]   next_ramtest_rdrtrn;
wire 	      next_ramtest_req;
wire 	      next_ramtest_rd_pend;
wire 	      next_jtag_rd_req;
wire 	      next_jtag_wr_req;
wire 	      next_jtag_rd_pend;
wire 	      next_csr_ack_req;
wire [`UCB_BUF_HI-`UCB_BUF_LO:0] next_csr_buf_id;
wire [`UCB_THR_HI-`UCB_THR_LO:0] next_csr_thr_id;
wire 	      next_rt_ack;

wire 	      jtag_addr_reg_en;
wire 	      jtag_data_reg_en;
wire 	      scratch_reg_en;
wire 	      rdrtrn_reg_en;
wire 	      rt_addr_high_en;
wire 	      rt_addr_low_en;
wire 	      rt_data_high_en;
wire 	      rt_data_low_en;
wire 	      ramtest_addr_high_en;
wire 	      ramtest_addr_low_en;
wire 	      ramtest_data_high_en;
wire 	      ramtest_data_low_en;
wire 	      ramtest_rw_en;
wire 	      ramtest_rdrtrn_en;
wire 	      csr_buf_id_en;
wire 	      csr_thr_id_en;

wire [63:0]   scratch_reg_sync;
wire [63:0]   rdrtrn_reg_sync;
wire 	      rdrtrn_reg_vld_sync;

wire 	      jtag_creg_wr_en_sync_d1;
wire 	      jtag_creg_rd_en_sync_d1;

wire 	      ucbout_write_pulse;
wire 	      ucbout_read_pulse;
wire 	      ucbout_ack_pulse;
reg [63:0]    ucbout_data;
reg [39:0]    ucbout_addr;
reg [`UCB_SIZE_HI-`UCB_SIZE_LO:0] ucbout_size;
reg [`UCB_BUF_HI-`UCB_BUF_LO:0]   ucbout_buf_id;
reg [`UCB_THR_HI-`UCB_THR_LO:0]   ucbout_thr_id;
reg [`UCB_PKT_HI-`UCB_PKT_LO:0]  ucbout_request_code;
reg [15:0]    ucbout_vec;
wire [127:0]  ucbout_buf;
wire 	      ucbout_outdata_busy;
wire 	      ucbout_outdata_wr;

wire [127:0]  ucbin_buf;
wire 	      ucbin_buf_vld;
wire [3:0]    ucbin_request;
wire [63:0]   ucbin_data;

wire 	      ucbin_rdrtrn_req;
wire 	      ucbin_write_req;
wire 	      ucbin_read_req;

wire 	      rt_valid_sync;
wire 	      rt_valid_sync_d1;
wire 	      rt_valid_negedge;
wire 	      req_acpt;
wire 	      ack_acpt;

wire 	      ramtest_rd_pend_sync;
wire 	      ramtest_rd_pend_sync_d1;
wire 	      ramtest_rd_pend_sync_negedge;
wire [63:0]   ramtest_rdrtrn_sync;

wire 	      rt_read_write_d1;
wire 	      rt_read_write_negedge;

wire 	      start_clk_jl_sync;

//*******************************************************************************
// Registers
//*******************************************************************************

//---------------------------
// Address Register
//---------------------------
// jbus_clk (assume tck period always longer than jbus_clk - no handshake needed)
assign next_jtag_addr_reg = jtag_creg_addr_sync;
assign jtag_addr_reg_en   = jtag_creg_addr_en_sync;

//---------------------------
// Address Register
//---------------------------
// jbus_clk (assume tck period always longer than jbus_clk - no handshake needed)
assign next_jtag_data_reg = jtag_creg_data_sync;
assign jtag_data_reg_en   = jtag_creg_data_en_sync;


// Handshake Protocol for jbus_clk -> tck domain
// ---------------------------------------------
//   Since the write enable in jbus_clk will go away before the logic at tck
//   is able to flop it and do anything with it. Therefore, at jbus_clk, we execute 
//   a handshake protocol:
//        - writing the rdrtrn_reg register sets the valid bit (jbus_clk)
//          which is cleared when jtag has finished reading it (tck)

//---------------------------
// Read Return Data
//---------------------------
// tck domain
assign creg_jtag_rdrtrn_vld   =   start_clk_jl_sync    //wait until jbus_clk starts toggling
                                & rdrtrn_reg_vld_sync; 
assign creg_jtag_rdrtrn_data  = rdrtrn_reg_sync;

// jbus_clk domain
assign next_rdrtrn_reg     = ucbin_data;
assign rdrtrn_reg_en       = jtag_rd_pend & ucbin_rdrtrn_req;

assign next_rdrtrn_reg_vld =   ~jtag_creg_rdrtrn_complete_sync
                             & (  (jtag_rd_pend & ucbin_rdrtrn_req)
				| rdrtrn_reg_vld);

//---------------------------
// Scratch Register
//---------------------------
// tck domain
assign creg_jtag_scratch_data = scratch_reg_sync;

// jbus_clk domain
// - because tap only has one R/W register, not doing address match and
// assume all reads and writes are to the scatch
assign next_scratch_reg = ucbin_data;
assign scratch_reg_en   = ucbin_write_req; 

//*******************************************************************************
// RAMTEST
// - test_mode_pin assertion makes RAMTEST ports availabel
//*******************************************************************************

//------------
// tck domain
//------------

assign rt_addr_high_en   = test_mode_pin & rt_valid &  rt_addr_data &  rt_high_low;
always @ ( /*AUTOSENSE*/rt_addr_high or rt_addr_high_en or rt_data_in) begin
   if (rt_addr_high_en)
      next_rt_addr_high = rt_data_in[7:0];
   else
      next_rt_addr_high = rt_addr_high;
end

assign rt_addr_low_en   = test_mode_pin & rt_valid &  rt_addr_data & ~rt_high_low;
always @ ( /*AUTOSENSE*/rt_addr_low or rt_addr_low_en or rt_data_in) begin
   if (rt_addr_low_en)
      next_rt_addr_low = rt_data_in;
   else
      next_rt_addr_low= rt_addr_low;
end

assign rt_data_high_en   = test_mode_pin & rt_valid & ~rt_addr_data &  rt_high_low;
always @ ( /*AUTOSENSE*/rt_data_high or rt_data_high_en or rt_data_in) begin
   if (rt_data_high_en)
      next_rt_data_high = rt_data_in;
   else
      next_rt_data_high = rt_data_high;
end

assign rt_data_low_en   = test_mode_pin & rt_valid & ~rt_addr_data & ~rt_high_low;
always @ ( /*AUTOSENSE*/rt_data_in or rt_data_low or rt_data_low_en) begin
   if (rt_data_low_en)
      next_rt_data_low = rt_data_in;
   else
      next_rt_data_low = rt_data_low;
end

assign ramtest_rd_pend_sync_negedge = ~ramtest_rd_pend_sync & ramtest_rd_pend_sync_d1;
assign rt_read_write_negedge        = test_mode_pin & ~rt_read_write & rt_read_write_d1;
assign next_rt_ack =  start_clk_jl_sync  //wait until jbus_clk starts toggling
                    & (  (~rt_ack & ramtest_rd_pend_sync_negedge)
                       | ( rt_ack & ~rt_read_write_negedge));

always @ ( /*AUTOSENSE*/bist_jtag_result or bist_mode_pin
	  or ramtest_rdrtrn_sync or rt_high_low or test_mode_pin) begin
   if (test_mode_pin & bist_mode_pin)
      rt_data_out = { {32-(`CTU_BIST_CNT*2){1'b0}}, bist_jtag_result };
   else begin
      if (rt_high_low)
	 rt_data_out = ramtest_rdrtrn_sync[63:32];
      else
	 rt_data_out = ramtest_rdrtrn_sync[31: 0];
   end
end

//------------
// jbus_clk
//------------

// use falling edge of rt_valid to sync transfer of addr and data from tck to jbus clk domain
assign rt_valid_negedge = test_mode_pin & ~rt_valid_sync & rt_valid_sync_d1;

// request and info registers
assign next_ramtest_addr_high = rt_addr_high;
assign ramtest_addr_high_en   = rt_valid_negedge;

assign next_ramtest_addr_low = rt_addr_low;
assign ramtest_addr_low_en   = rt_valid_negedge;

assign next_ramtest_data_high = rt_data_high;
assign ramtest_data_high_en   = rt_valid_negedge;

assign next_ramtest_data_low = rt_data_low;
assign ramtest_data_low_en   = rt_valid_negedge;

assign next_ramtest_rw         = rt_read_write;
assign ramtest_rw_en           = rt_valid_negedge;

// read return data
assign next_ramtest_rdrtrn     = ucbin_data;
assign ramtest_rdrtrn_en       = ramtest_rd_pend & ucbin_rdrtrn_req;

//*******************************************************************************
// IOB Interface Logic
// - jbus clk domain
//*******************************************************************************

//-------------
// outbound ucb
//-------------

ucb_bus_out #(8,64) u_ucb_out 
   ( // outputs
     .vld              (tap_iob_vld),
     .data             (tap_iob_data),
     .outdata_buf_busy (ucbout_outdata_busy),

     // inputs
     .clk              (jbus_clk),
     .rst_l            (jbus_rst_l),
     .stall            (iob_tap_stall),
     .outdata_buf_in   (ucbout_buf),
     .outdata_vec_in   (ucbout_vec),
     .outdata_buf_wr   (ucbout_outdata_wr)
     );


// ramtest request
assign next_ramtest_req =    rt_valid_negedge
                           | ramtest_req & ~req_acpt;

assign next_ramtest_rd_pend =   ramtest_req & ramtest_rw & req_acpt
                              | ramtest_rd_pend & ~ucbin_rdrtrn_req;

// jtag request
assign next_jtag_rd_req =  jtag_creg_rd_en_sync & ~jtag_creg_rd_en_sync_d1
                         | jtag_rd_req & ~req_acpt;
assign next_jtag_wr_req =  jtag_creg_wr_en_sync & ~jtag_creg_wr_en_sync_d1
                         | jtag_wr_req & ~req_acpt;

assign next_jtag_rd_pend =  jtag_rd_req & req_acpt
                          | jtag_rd_pend & ~ucbin_rdrtrn_req;

// generate read or write valid pulse if busy signal unasserted and not servicing iob read request
assign ucbout_read_pulse  =  ~ucbout_outdata_busy
                           & ~csr_ack_req
                           & (jtag_rd_req | (ramtest_req &  ramtest_rw));
assign ucbout_write_pulse =  ~ucbout_outdata_busy
                           & ~csr_ack_req
                           & (jtag_wr_req | (ramtest_req & ~ramtest_rw));
assign ucbout_ack_pulse   = ~ucbout_outdata_busy & csr_ack_req;

// accept request - assume never running jtag and ramtest mode concurrently
assign req_acpt = ucbout_read_pulse | ucbout_write_pulse;
assign ack_acpt = ucbout_ack_pulse;

// issue request
assign ucbout_outdata_wr   = ucbout_read_pulse | ucbout_write_pulse | ucbout_ack_pulse;

always @ ( /*AUTOSENSE*/csr_ack_req or ucbout_write_pulse) begin
   if (csr_ack_req) begin
      ucbout_vec = 16'hffff;
      ucbout_request_code = `UCB_READ_ACK;
   end
   else if (ucbout_write_pulse) begin
      ucbout_vec = 16'hffff;
      ucbout_request_code = `UCB_WRITE_REQ;
   end
   else begin  // read
      ucbout_vec = 16'h00ff;
      ucbout_request_code = `UCB_READ_REQ;
   end
end

always @ ( /*AUTOSENSE*/csr_ack_req or csr_buf_id or csr_thr_id
	  or jtag_addr_reg or jtag_data_reg or ramtest_addr_high
	  or ramtest_addr_low or ramtest_data_high or ramtest_data_low
	  or ramtest_req or scratch_reg) begin
   if (csr_ack_req) begin
      ucbout_data   = scratch_reg;
      ucbout_addr   = {40{1'b0}};
      ucbout_size   = {(`UCB_SIZE_HI-`UCB_SIZE_LO+1){1'b0}};
      ucbout_buf_id = csr_buf_id;
      ucbout_thr_id = csr_thr_id;
   end
   else if (ramtest_req) begin
      ucbout_data = {ramtest_data_high, ramtest_data_low};
      ucbout_addr = {ramtest_addr_high[7:0], ramtest_addr_low};
      ucbout_size = `PCX_SZ_8B;
      ucbout_buf_id = `UCB_BID_TAP;
      ucbout_thr_id = {(`UCB_THR_HI-`UCB_THR_LO+1){1'b0}};
   end
   else begin
      ucbout_data = jtag_data_reg;
      ucbout_addr = jtag_addr_reg;
      ucbout_size = `PCX_SZ_8B;
      ucbout_buf_id = `UCB_BID_TAP;
      ucbout_thr_id = {(`UCB_THR_HI-`UCB_THR_LO+1){1'b0}};
   end
end

assign ucbout_buf = { ucbout_data,
		      {9{1'b0}},
		      ucbout_addr,
		      ucbout_size,
		      ucbout_buf_id,
		      ucbout_thr_id,
		      ucbout_request_code};

//------------
// inbound ucb 
//------------

ucb_bus_in #(8,64) u_ucb_in 
   ( // outputs
     .stall          (tap_iob_stall),
     .indata_buf_vld (ucbin_buf_vld),
     .indata_buf     (ucbin_buf),

     // inputs
     .rst_l          (jbus_rst_l),
     .clk            (jbus_clk),
     .vld            (iob_tap_vld),
     .data           (iob_tap_data),
     .stall_a1       (csr_ack_req)
     );

// decode the request coming in.
// there are three which we care about
// 1. write requests - always write to scratch reg
// 2. read returns
// 3. write acks -- these will be discarded
// 4. read request -- always ack with scratch_reg

assign ucbin_request = ucbin_buf[`UCB_PKT_HI:`UCB_PKT_LO];
//assign ucbin_address = ucbin_buf[`UCB_ADDR_HI:`UCB_ADDR_LO];
assign ucbin_data    = ucbin_buf[`UCB_DATA_HI:`UCB_DATA_LO];

assign ucbin_rdrtrn_req = ucbin_buf_vld & ucbin_request == `UCB_READ_ACK;
assign ucbin_write_req  = ucbin_buf_vld & ucbin_request == `UCB_WRITE_REQ;
assign ucbin_read_req   = ucbin_buf_vld & ucbin_request == `UCB_READ_REQ;


// read return to iob
assign csr_thr_id_en   = ucbin_read_req;
assign next_csr_thr_id = ucbin_buf[`UCB_THR_HI:`UCB_THR_LO];

assign csr_buf_id_en   = ucbin_read_req;
assign next_csr_buf_id = ucbin_buf[`UCB_BUF_HI:`UCB_BUF_LO];

assign next_csr_ack_req =  ucbin_read_req
                         | csr_ack_req & ~ack_acpt;


//*******************************************************************************
// Synchronizers
//*******************************************************************************

//------------------
// tck -> jbus_clk
//------------------
ctu_synchronizer u_jtag_creg_rd_en_sync 
   ( .syncdata (jtag_creg_rd_en_sync),
     .presyncdata (jtag_creg_rd_en),
     .clk (jbus_clk)
     );

ctu_synchronizer u_jtag_creg_wr_en_sync 
   ( .syncdata (jtag_creg_wr_en_sync),
     .presyncdata (jtag_creg_wr_en),
     .clk (jbus_clk)
     );

ctu_synchronizer u_jtag_creg_addr_en_sync 
   ( .syncdata (jtag_creg_addr_en_sync),
     .presyncdata (jtag_creg_addr_en),
     .clk (jbus_clk)
     );

ctu_synchronizer u_jtag_creg_data_en_sync 
   ( .syncdata (jtag_creg_data_en_sync),
     .presyncdata (jtag_creg_data_en),
     .clk (jbus_clk)
     );

ctu_synchronizer #(40) u_jtag_creg_addr_sync 
   ( .syncdata (jtag_creg_addr_sync),
     .presyncdata (jtag_creg_addr),
     .clk (jbus_clk)
     );

ctu_synchronizer #(64) u_jtag_creg_data_sync 
   ( .syncdata (jtag_creg_data_sync),
     .presyncdata (jtag_creg_data),
     .clk (jbus_clk)
     );

ctu_synchronizer u_sync_jtag_creg_rdrtrn_complete
   ( .presyncdata (jtag_creg_rdrtrn_complete),
     .syncdata (jtag_creg_rdrtrn_complete_sync),
     .clk (jbus_clk)
     );

ctu_synchronizer u_sync_rt_valid
   ( .presyncdata (rt_valid),
     .syncdata (rt_valid_sync),
     .clk (jbus_clk)
     );

//------------------
// jbus_clk -> tck
//------------------
ctu_synchronizer #(64) u_sync_rdrtrn_reg
   ( .presyncdata (rdrtrn_reg),
     .syncdata (rdrtrn_reg_sync),
     .clk (io_tck)
     );

ctu_synchronizer #(64) u_sync_scratch_reg
   ( .presyncdata (scratch_reg),
     .syncdata (scratch_reg_sync),
     .clk (io_tck)
     );

ctu_synchronizer u_sync_rdrtrn_reg_vld
   ( .presyncdata (rdrtrn_reg_vld),
     .syncdata (rdrtrn_reg_vld_sync),
     .clk (io_tck)
     );

ctu_synchronizer u_sync_ramtest_rd_pend
   ( .presyncdata (ramtest_rd_pend),
     .syncdata (ramtest_rd_pend_sync),
     .clk (io_tck)
     );

ctu_synchronizer #(64) u_sync_ramtest_rdrtrn
   ( .presyncdata (ramtest_rdrtrn),
     .syncdata (ramtest_rdrtrn_sync),
     .clk (io_tck)
     );

ctu_synchronizer u_sync_start_clk_jl
   ( .presyncdata (start_clk_jl),
     .syncdata (start_clk_jl_sync),
     .clk (io_tck)
     );


//*******************************************************************************
// Async DFFRL Instantiations
//*******************************************************************************

// tck
dffrl_async_ns #(8) u_dffrl_async_rt_addr_high
   ( .din (next_rt_addr_high),
     .clk (io_tck),
     .rst_l (io_pwron_rst_l),
     .q (rt_addr_high)
     );

dffrl_async_ns #(32) u_dffrl_async_rt_addr_low
   ( .din (next_rt_addr_low),
     .clk (io_tck),
     .rst_l (io_pwron_rst_l),
     .q (rt_addr_low)
     );

dffrl_async_ns #(32) u_dffrl_async_rt_data_high
   ( .din (next_rt_data_high),
     .clk (io_tck),
     .rst_l (io_pwron_rst_l),
     .q (rt_data_high)
     );

dffrl_async_ns #(32) u_dffrl_async_rt_data_low
   ( .din (next_rt_data_low),
     .clk (io_tck),
     .rst_l (io_pwron_rst_l),
     .q (rt_data_low)
     );

dffrl_async_ns #(1) u_dffrl_async_rt_ack
   ( .din (next_rt_ack),
     .clk (io_tck),
     .rst_l (io_pwron_rst_l),
     .q (rt_ack)
     );


//*******************************************************************************
// DFF Instantiations
//*******************************************************************************

// jbus_clk
dff_ns u_dff_jtag_creg_wr_en_sync_d1
   ( .din (jtag_creg_wr_en_sync),
     .clk (jbus_clk),
     .q (jtag_creg_wr_en_sync_d1)
     );


dff_ns u_dff_jtag_creg_rd_en_sync_d1
   ( .din (jtag_creg_rd_en_sync),
     .clk (jbus_clk),
     .q (jtag_creg_rd_en_sync_d1)
     );

dff_ns u_dff_rt_valid_sync_d1
   ( .din (rt_valid_sync),
     .clk (jbus_clk),
     .q (rt_valid_sync_d1)
     );

// tck
dff_ns u_dff_ramtest_rd_pend_sync_d1
   ( .din (ramtest_rd_pend_sync),
     .clk (io_tck),
     .q (ramtest_rd_pend_sync_d1)
     );

dff_ns u_dff_rt_read_write_d1
   ( .din (rt_read_write),
     .clk (io_tck),
     .q (rt_read_write_d1)
     );

//*******************************************************************************
// DFFRL Instantiations
//*******************************************************************************

// jbus_clk
dffrl_ns u_dffrl_rdrtrn_reg_vld 
   ( .din (next_rdrtrn_reg_vld),
     .q (rdrtrn_reg_vld),
     .rst_l (jbus_rst_l),
     .clk (jbus_clk)
     );

dffrl_ns u_dffrl_ramtest_req
   ( .din (next_ramtest_req),
     .q (ramtest_req),
     .rst_l (jbus_rst_l),
     .clk (jbus_clk)
     );

dffrl_ns u_dffrl_ramtest_rd_pend
   ( .din (next_ramtest_rd_pend),
     .q (ramtest_rd_pend),
     .rst_l (jbus_rst_l),
     .clk (jbus_clk)
     );

dffrl_ns u_dffrl_jtag_rd_req
   ( .din (next_jtag_rd_req),
     .q (jtag_rd_req),
     .rst_l (jbus_rst_l),
     .clk (jbus_clk)
     );

dffrl_ns u_dffrl_jtag_wr_req
   ( .din (next_jtag_wr_req),
     .q (jtag_wr_req),
     .rst_l (jbus_rst_l),
     .clk (jbus_clk)
     );

dffrl_ns u_dffrl_jtag_rd_pend
   ( .din (next_jtag_rd_pend),
     .q (jtag_rd_pend),
     .rst_l (jbus_rst_l),
     .clk (jbus_clk)
     );

dffrl_ns u_dffrl_csr_ack_req
   ( .din (next_csr_ack_req),
     .q (csr_ack_req),
     .rst_l (jbus_rst_l),
     .clk (jbus_clk)
     );

//*******************************************************************************
// DFFRLE Instantiations
//*******************************************************************************

// jbus_clk

dffrle_ns #(40) u_dffrle_jtag_addr_reg
   ( .din (next_jtag_addr_reg),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (jtag_addr_reg_en),
     .q (jtag_addr_reg)
     );

dffrle_ns #(64) u_dffrle_jtag_data_reg 
   ( .din (next_jtag_data_reg),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (jtag_data_reg_en),
     .q (jtag_data_reg)
     );

dffrle_ns #(64) u_dffrle_scratch_reg
   ( .din (next_scratch_reg),
     .rst_l (jbus_rst_l),
     .clk (jbus_clk),
     .en (scratch_reg_en),
     .q (scratch_reg)
);

dffrle_ns #(64) u_dffrle_rdrtrn_reg
   ( .din (next_rdrtrn_reg),
     .rst_l (jbus_rst_l),
     .clk (jbus_clk),
     .en (rdrtrn_reg_en),
     .q (rdrtrn_reg)
     );

dffrle_ns #(8) u_dffrle_ramtest_addr_high
   ( .din (next_ramtest_addr_high),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (ramtest_addr_high_en),
     .q (ramtest_addr_high)
     );

dffrle_ns #(32) u_dffrle_ramtest_addr_low
   ( .din (next_ramtest_addr_low),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (ramtest_addr_low_en),
     .q (ramtest_addr_low)
     );

dffrle_ns #(32) u_dffrle_ramtest_data_high
   ( .din (next_ramtest_data_high),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (ramtest_data_high_en),
     .q (ramtest_data_high)
     );

dffrle_ns #(32) u_dffrle_ramtest_data_low
   ( .din (next_ramtest_data_low),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (ramtest_data_low_en),
     .q (ramtest_data_low)
     );

dffrle_ns #(1) u_dffrle_ramtest_rw
   ( .din (next_ramtest_rw),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (ramtest_rw_en),
     .q (ramtest_rw)
     );

dffrle_ns #(64) u_dffrle_ramtest_rdrtrn
   ( .din (next_ramtest_rdrtrn),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (ramtest_rdrtrn_en),
     .q (ramtest_rdrtrn)
     );

dffrle_ns #(`UCB_BUF_HI-`UCB_BUF_LO+1) u_dffrle_csr_buf_id
   ( .din (next_csr_buf_id),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (csr_buf_id_en),
     .q (csr_buf_id)
     );

dffrle_ns #(`UCB_THR_HI-`UCB_THR_LO+1) u_dffrle_csr_thr_id
   ( .din (next_csr_thr_id),
     .clk (jbus_clk),
     .rst_l (jbus_rst_l),
     .en (csr_thr_id_en),
     .q (csr_thr_id)
     );


//*******************************************************************************
// Rule Checks
//*******************************************************************************

//synopsys translate_off

always @ ( /*AUTOSENSE*/ramtest_rd_pend or rt_valid_negedge) begin
   if (ramtest_rd_pend && rt_valid_negedge)
      $display ("%d %m: ERROR - new ramtest request received before previous ramtest read has completed",
		$time);
end
  
always @ ( /*AUTOSENSE*/jtag_rd_req or jtag_wr_req) begin
   if (jtag_rd_req & jtag_wr_req)
      $display ("%d %m: ERROR - concurrent jtag read and write request to IOB",
		$time);
end

//synopsys translate_on
endmodule


// Local Variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// End:

