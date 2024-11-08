// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_dft_bist.v
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


module ctu_dft_bist (/*AUTOARG*/
// Outputs
dft_wake_thr, bist_jtag_result, bist_jtag_abort_done, 
ctu_sctag0_mbisten, ctu_sctag1_mbisten, ctu_sctag2_mbisten, 
ctu_sctag3_mbisten, ctu_spc7_mbisten, ctu_spc6_mbisten, 
ctu_spc5_mbisten, ctu_spc4_mbisten, ctu_spc3_mbisten, 
ctu_spc2_mbisten, ctu_spc1_mbisten, ctu_spc0_mbisten, 
// Inputs
cmp_clk, cmp_rst_l, cmp_tx_en, cmp_rx_en, jbus_clk, jbus_rst_l, 
io_tck, iob_ctu_coreavail, clsp_bist_dobist, clsp_bist_type, 
clsp_bist_ctrl, jtag_bist_serial, jtag_bist_parallel, 
jtag_bist_active, jtag_bist_abort, sctag0_ctu_mbistdone, 
sctag1_ctu_mbistdone, sctag2_ctu_mbistdone, sctag3_ctu_mbistdone, 
spc7_ctu_mbistdone, spc6_ctu_mbistdone, spc5_ctu_mbistdone, 
spc4_ctu_mbistdone, spc3_ctu_mbistdone, spc2_ctu_mbistdone, 
spc1_ctu_mbistdone, spc0_ctu_mbistdone, sctag0_ctu_mbisterr, 
sctag1_ctu_mbisterr, sctag2_ctu_mbisterr, sctag3_ctu_mbisterr, 
spc7_ctu_mbisterr, spc6_ctu_mbisterr, spc5_ctu_mbisterr, 
spc4_ctu_mbisterr, spc3_ctu_mbisterr, spc2_ctu_mbisterr, 
spc1_ctu_mbisterr, spc0_ctu_mbisterr
);
//global inputs
input cmp_clk;
input cmp_rst_l;
input cmp_tx_en;
input cmp_rx_en;
input jbus_clk;
input jbus_rst_l;
input io_tck;

// iob
input [`IOB_CPU_WIDTH-1:0] iob_ctu_coreavail;
output 			   dft_wake_thr;

// from reset block
input 			   clsp_bist_dobist;
input 			   clsp_bist_type;
input [5:0] 		   clsp_bist_ctrl;

// jtag signals -tck domain
input 			   jtag_bist_serial;
input 			   jtag_bist_parallel;
input [`CTU_BIST_CNT-1:0]  jtag_bist_active;
input 			   jtag_bist_abort;
output [(`CTU_BIST_CNT*2)-1:0] bist_jtag_result;
//output 			       bist_jtag_busy;
output 			       bist_jtag_abort_done;

//bist enable outputs - cmp domain
output 			       ctu_sctag0_mbisten;
output 			       ctu_sctag1_mbisten;
output 			       ctu_sctag2_mbisten;
output 			       ctu_sctag3_mbisten;
output 			       ctu_spc7_mbisten;      
output 			       ctu_spc6_mbisten;    
output 			       ctu_spc5_mbisten;   
output 			       ctu_spc4_mbisten;     
output 			       ctu_spc3_mbisten;    
output 			       ctu_spc2_mbisten;      
output 			       ctu_spc1_mbisten;      
output 			       ctu_spc0_mbisten;     

//bist done inputs - cmp domain
input 			       sctag0_ctu_mbistdone;
input 			       sctag1_ctu_mbistdone;
input 			       sctag2_ctu_mbistdone;
input 			       sctag3_ctu_mbistdone;
input 			       spc7_ctu_mbistdone;    
input 			       spc6_ctu_mbistdone;    
input 			       spc5_ctu_mbistdone;    
input 			       spc4_ctu_mbistdone;    
input 			       spc3_ctu_mbistdone;     
input 			       spc2_ctu_mbistdone;    
input 			       spc1_ctu_mbistdone;    
input 			       spc0_ctu_mbistdone;   

//bist err report - cmp domain
input 			       sctag0_ctu_mbisterr;
input 			       sctag1_ctu_mbisterr;
input 			       sctag2_ctu_mbisterr;
input 			       sctag3_ctu_mbisterr;
input 			       spc7_ctu_mbisterr;    
input 			       spc6_ctu_mbisterr;     
input 			       spc5_ctu_mbisterr;      
input 			       spc4_ctu_mbisterr;      
input 			       spc3_ctu_mbisterr;    
input 			       spc2_ctu_mbisterr;    
input 			       spc1_ctu_mbisterr;   
input 			       spc0_ctu_mbisterr;   


////////////////////////////////////////////////////////////////////////
// Interface signal type declarations
////////////////////////////////////////////////////////////////////////

wire [(`CTU_BIST_CNT*2)-1:0]   bist_jtag_result;
//wire 			       bist_jtag_busy;
wire 			       ctu_sctag0_mbisten;
wire 			       ctu_sctag1_mbisten;
wire 			       ctu_sctag2_mbisten;
wire 			       ctu_sctag3_mbisten;
wire 			       ctu_spc7_mbisten;      
wire 			       ctu_spc6_mbisten;    
wire 			       ctu_spc5_mbisten;   
wire 			       ctu_spc4_mbisten;     
wire 			       ctu_spc3_mbisten;    
wire 			       ctu_spc2_mbisten;      
wire 			       ctu_spc1_mbisten;      
wire 			       ctu_spc0_mbisten;     

////////////////////////////////////////////////////////////////////////
// Local signal declarations 
////////////////////////////////////////////////////////////////////////
parameter BIST_IDLE               = 4'b0000,
	  BIST_PARALLEL_START     = 4'b0001,
	  BIST_PARALLEL_CTRL      = 4'b0011,
	  BIST_PARALLEL_WAIT      = 4'b0010,
	  BIST_PARALLEL_ABORT     = 4'b1110,
	  
	  BIST_SERIAL_SPC_START   = 4'b0100,
	  BIST_SERIAL_SPC_CTRL    = 4'b0101,
	  BIST_SERIAL_SPC_WAIT    = 4'b0111,
	  BIST_SERIAL_SPC_ABORT   = 4'b1111,
	  
	  BIST_SERIAL_SCTAG_START = 4'b1011,
	  BIST_SERIAL_SCTAG_CTRL  = 4'b1010,
	  BIST_SERIAL_SCTAG_WAIT  = 4'b1000,
	  BIST_SERIAL_SCTAG_ABORT = 4'b1100,

	  BIST_MODE_LO            = 2,
	  BIST_MODE_HI            = 3,
	  BIST_MODE_PARALLEL      = 2'b00,
      //  BIST_MODE_SPC           = 2'b01,
      //  BIST_MODE_SCTAG         = 2'b10,
      //  BIST_MODE_ABORT         = 2'b11,
	  
	  BIST_SM_WIDTH           = 4;

parameter BIST_CTRL_WIDTH = 7,
	  BIST_CTRL_MAX_CNT = 3'd6;  // control length minus one
  
wire [BIST_SM_WIDTH-1:0] bist_sm;
wire [2:0] 		 bist_cnt;
wire [2:0] 		 bist_ctrl_cnt;
wire [7:0] 		 bist_spc_done;
wire [3:0] 		 bist_sctag_done;
wire 			 doing_rst_bist;
wire 			 wake_thr;
wire [BIST_CTRL_WIDTH-1:0] bist_ctrl;
wire 			   abort_done;
wire 			   abort_done_jreg;
reg [BIST_SM_WIDTH-1:0]    next_bist_sm;
reg [2:0] 		   next_bist_cnt;
wire [2:0] 		   next_bist_ctrl_cnt;
wire [7:0] 		   next_bist_spc_done;
wire [3:0] 		   next_bist_sctag_done;
wire 			   next_doing_rst_bist;
wire 			   next_wake_thr;
reg [BIST_CTRL_WIDTH-1:0]  next_bist_ctrl;
wire 			   next_abort_done;
wire 			   next_abort_done_jreg;

wire 			 next_ctu_spc0_mbisten;
wire 			 next_ctu_spc1_mbisten;
wire 			 next_ctu_spc2_mbisten;
wire 			 next_ctu_spc3_mbisten;
wire 			 next_ctu_spc4_mbisten;
wire 			 next_ctu_spc5_mbisten;
wire 			 next_ctu_spc6_mbisten;
wire 			 next_ctu_spc7_mbisten;
wire 			 next_ctu_sctag0_mbisten;
wire 			 next_ctu_sctag1_mbisten;
wire 			 next_ctu_sctag2_mbisten;
wire 			 next_ctu_sctag3_mbisten;

wire 			 abort_done_complete;

wire 			 bist_done_rst_l;
wire 			 bist_cnt_rst_l;
wire 			 bist_ctrl_load;
wire 			 bist_ctrl_shift;
wire 			 bist_ctrl_en;

wire [7:0] 		 bist_active_spc;
wire [3:0] 		 bist_active_sctag;

wire 			 spc0_ctu_mbistdone_ff;
wire 			 spc1_ctu_mbistdone_ff;
wire 			 spc2_ctu_mbistdone_ff;
wire 			 spc3_ctu_mbistdone_ff;
wire 			 spc4_ctu_mbistdone_ff;
wire 			 spc5_ctu_mbistdone_ff;
wire 			 spc6_ctu_mbistdone_ff;
wire 			 spc7_ctu_mbistdone_ff;
wire 			 sctag0_ctu_mbistdone_ff;
wire 			 sctag1_ctu_mbistdone_ff;
wire 			 sctag2_ctu_mbistdone_ff;
wire 			 sctag3_ctu_mbistdone_ff;
wire 			 spc0_ctu_mbistdone_d1;
wire 			 spc1_ctu_mbistdone_d1;
wire 			 spc2_ctu_mbistdone_d1;
wire 			 spc3_ctu_mbistdone_d1;
wire 			 spc4_ctu_mbistdone_d1;
wire 			 spc5_ctu_mbistdone_d1;
wire 			 spc6_ctu_mbistdone_d1;
wire 			 spc7_ctu_mbistdone_d1;
wire 			 sctag0_ctu_mbistdone_d1;
wire 			 sctag1_ctu_mbistdone_d1;
wire 			 sctag2_ctu_mbistdone_d1;
wire 			 sctag3_ctu_mbistdone_d1;
wire 			 spc0_ctu_mbistdone_posedge;
wire 			 spc1_ctu_mbistdone_posedge;
wire 			 spc2_ctu_mbistdone_posedge;
wire 			 spc3_ctu_mbistdone_posedge;
wire 			 spc4_ctu_mbistdone_posedge;
wire 			 spc5_ctu_mbistdone_posedge;
wire 			 spc6_ctu_mbistdone_posedge;
wire 			 spc7_ctu_mbistdone_posedge;
wire 			 sctag0_ctu_mbistdone_posedge;
wire 			 sctag1_ctu_mbistdone_posedge;
wire 			 sctag2_ctu_mbistdone_posedge;
wire 			 sctag3_ctu_mbistdone_posedge;
wire [`CTU_BIST_CNT-1:0] bist_done;
reg 			 bist_parallel_done;

wire 			 spc0_ctu_mbisterr_ff;
wire 			 spc1_ctu_mbisterr_ff;
wire 			 spc2_ctu_mbisterr_ff;
wire 			 spc3_ctu_mbisterr_ff;
wire 			 spc4_ctu_mbisterr_ff;
wire 			 spc5_ctu_mbisterr_ff;
wire 			 spc6_ctu_mbisterr_ff;
wire 			 spc7_ctu_mbisterr_ff;
wire 			 sctag0_ctu_mbisterr_ff;
wire 			 sctag1_ctu_mbisterr_ff;
wire 			 sctag2_ctu_mbisterr_ff;
wire 			 sctag3_ctu_mbisterr_ff;

wire			 bist_cnt_incr;
wire 			 bist_ctrl_cnt_rst_l;
wire 			 bist_sm_spc_start_state;
wire 			 bist_sm_sctag_start_state;
wire 			 drive_spc_bist_ctrl_value;
wire 			 drive_sctag_bist_ctrl_value;

//wire 			 bist_busy;
wire 			 clsp_bist_dobist_d1;
wire 			 clsp_bist_dobist_posedge;
wire 			 jtag_bist_serial_c_d1;
wire 			 jtag_bist_serial_posedge;
wire 			 jtag_bist_parallel_c_d1;
wire 			 jtag_bist_parallel_posedge;

// jbus -> cmp
wire 			 clsp_bist_dobist_ff;
wire 			 clsp_bist_dobist_c;
wire 			 clsp_bist_type_ff;
wire 			 clsp_bist_type_c;
wire [5:0] 		 clsp_bist_ctrl_ff;
wire [5:0] 		 clsp_bist_ctrl_c;

// cmp -> jbus
wire 			 wake_thr_tx;
wire 			 wake_thr_j;
wire 			 abort_done_tx;
wire 			 abort_done_j;

// cmp -> tck
wire 			 spc0_ctu_mbistdone_tx;
wire 			 spc1_ctu_mbistdone_tx;
wire 			 spc2_ctu_mbistdone_tx;
wire 			 spc3_ctu_mbistdone_tx;
wire 			 spc4_ctu_mbistdone_tx;
wire 			 spc5_ctu_mbistdone_tx;
wire 			 spc6_ctu_mbistdone_tx;
wire 			 spc7_ctu_mbistdone_tx;
wire 			 sctag0_ctu_mbistdone_tx;
wire 			 sctag1_ctu_mbistdone_tx;
wire 			 sctag2_ctu_mbistdone_tx;
wire 			 sctag3_ctu_mbistdone_tx;
wire 			 spc0_ctu_mbistdone_j;
wire 			 spc1_ctu_mbistdone_j;
wire 			 spc2_ctu_mbistdone_j;
wire 			 spc3_ctu_mbistdone_j;
wire 			 spc4_ctu_mbistdone_j;
wire 			 spc5_ctu_mbistdone_j;
wire 			 spc6_ctu_mbistdone_j;
wire 			 spc7_ctu_mbistdone_j;
wire 			 sctag0_ctu_mbistdone_j;
wire 			 sctag1_ctu_mbistdone_j;
wire 			 sctag2_ctu_mbistdone_j;
wire 			 sctag3_ctu_mbistdone_j;
wire 			 spc0_ctu_mbistdone_t;
wire 			 spc1_ctu_mbistdone_t;
wire 			 spc2_ctu_mbistdone_t;
wire 			 spc3_ctu_mbistdone_t;
wire 			 spc4_ctu_mbistdone_t;
wire 			 spc5_ctu_mbistdone_t;
wire 			 spc6_ctu_mbistdone_t;
wire 			 spc7_ctu_mbistdone_t;
wire 			 sctag0_ctu_mbistdone_t;
wire 			 sctag1_ctu_mbistdone_t;
wire 			 sctag2_ctu_mbistdone_t;
wire 			 sctag3_ctu_mbistdone_t;

wire 			 spc0_ctu_mbisterr_tx;
wire 			 spc1_ctu_mbisterr_tx;
wire 			 spc2_ctu_mbisterr_tx;
wire 			 spc3_ctu_mbisterr_tx;
wire 			 spc4_ctu_mbisterr_tx;
wire 			 spc5_ctu_mbisterr_tx;
wire 			 spc6_ctu_mbisterr_tx;
wire 			 spc7_ctu_mbisterr_tx;
wire 			 sctag0_ctu_mbisterr_tx;
wire 			 sctag1_ctu_mbisterr_tx;
wire 			 sctag2_ctu_mbisterr_tx;
wire 			 sctag3_ctu_mbisterr_tx;
wire 			 spc0_ctu_mbisterr_j;
wire 			 spc1_ctu_mbisterr_j;
wire 			 spc2_ctu_mbisterr_j;
wire 			 spc3_ctu_mbisterr_j;
wire 			 spc4_ctu_mbisterr_j;
wire 			 spc5_ctu_mbisterr_j;
wire 			 spc6_ctu_mbisterr_j;
wire 			 spc7_ctu_mbisterr_j;
wire 			 sctag0_ctu_mbisterr_j;
wire 			 sctag1_ctu_mbisterr_j;
wire 			 sctag2_ctu_mbisterr_j;
wire 			 sctag3_ctu_mbisterr_j;
wire 			 spc0_ctu_mbisterr_t;
wire 			 spc1_ctu_mbisterr_t;
wire 			 spc2_ctu_mbisterr_t;
wire 			 spc3_ctu_mbisterr_t;
wire 			 spc4_ctu_mbisterr_t;
wire 			 spc5_ctu_mbisterr_t;
wire 			 spc6_ctu_mbisterr_t;
wire 			 spc7_ctu_mbisterr_t;
wire 			 sctag0_ctu_mbisterr_t;
wire 			 sctag1_ctu_mbisterr_t;
wire 			 sctag2_ctu_mbisterr_t;
wire 			 sctag3_ctu_mbisterr_t;

//wire 			 bist_busy_tx;
//wire 			 bist_busy_j;
//wire 			 bist_busy_t;

// jbus -> tck
wire 			 abort_done_jreg_t;

// tck ->cmp
wire 			 jtag_bist_serial_j;
wire 			 jtag_bist_serial_c;
wire 			 jtag_bist_parallel_j;
wire 			 jtag_bist_parallel_c;
wire [`CTU_BIST_CNT-1:0] jtag_bist_active_j;
wire [`CTU_BIST_CNT-1:0] jtag_bist_active_c;
wire 			 jtag_bist_abort_j;
wire 			 jtag_bist_abort_c;

// tck -> jbus
wire 			 abort_done_complete_j;
     

//********************************************************************
// BIST State Machine
// - cmp clk domain
//********************************************************************

// reset initiated bist
assign clsp_bist_dobist_posedge = clsp_bist_dobist_c & ~clsp_bist_dobist_d1;

// bist sm busy - all requests ignored
//assign bist_busy = bist_sm != BIST_IDLE;
assign jtag_bist_serial_posedge   = jtag_bist_serial_c   & ~jtag_bist_serial_c_d1;
assign jtag_bist_parallel_posedge = jtag_bist_parallel_c & ~jtag_bist_parallel_c_d1;

// when doing bist, ignore all further requests until done
always @ ( /*AUTOSENSE*/bist_active_sctag or bist_active_spc
	  or bist_cnt or bist_ctrl_cnt or bist_parallel_done
	  or bist_sctag_done or bist_sm or bist_spc_done
	  or clsp_bist_ctrl_c or clsp_bist_dobist_posedge
	  or jtag_bist_abort_c or jtag_bist_parallel_posedge
	  or jtag_bist_serial_posedge) begin
   case (bist_sm)
      BIST_IDLE: begin
	 if (  jtag_bist_serial_posedge
	     | (  clsp_bist_dobist_posedge
		& ~clsp_bist_ctrl_c[0]))  // parallel bit of ctrl
	    next_bist_sm = BIST_SERIAL_SPC_START;
	 else if (  jtag_bist_parallel_posedge
		  | (  clsp_bist_dobist_posedge
		     & clsp_bist_ctrl_c[0]))
	    next_bist_sm = BIST_PARALLEL_START;
	 else
	    next_bist_sm = BIST_IDLE;
      end

      //--- Parallel Bist ---
      BIST_PARALLEL_START: next_bist_sm = BIST_PARALLEL_CTRL;

      BIST_PARALLEL_CTRL:  begin
	 if (bist_ctrl_cnt == BIST_CTRL_MAX_CNT)
	    next_bist_sm = BIST_PARALLEL_WAIT;
	 else
	    next_bist_sm = BIST_PARALLEL_CTRL;
      end

      BIST_PARALLEL_WAIT: begin
	 if (jtag_bist_abort_c)
	    next_bist_sm = BIST_PARALLEL_ABORT;
	 else if (bist_parallel_done)
	    next_bist_sm = BIST_IDLE;
	 else
	    next_bist_sm = BIST_PARALLEL_WAIT;
      end

      BIST_PARALLEL_ABORT: next_bist_sm = BIST_IDLE;

      //--- Serial Bist (SPC) ---
      BIST_SERIAL_SPC_START: begin
	 if (bist_active_spc[bist_cnt[2:0]])
	    next_bist_sm = BIST_SERIAL_SPC_CTRL;
	 else if (bist_cnt[2:0] == 3'd7)
	    next_bist_sm = BIST_SERIAL_SCTAG_START;
	 else
	    next_bist_sm = BIST_SERIAL_SPC_START;
      end

      BIST_SERIAL_SPC_CTRL: begin
	 if (bist_ctrl_cnt == BIST_CTRL_MAX_CNT)
	    next_bist_sm = BIST_SERIAL_SPC_WAIT;
	 else
	    next_bist_sm = BIST_SERIAL_SPC_CTRL;
      end

      BIST_SERIAL_SPC_WAIT: begin
	 if (jtag_bist_abort_c)
	    next_bist_sm = BIST_SERIAL_SPC_ABORT;
	 else begin
	    if (bist_spc_done[bist_cnt[2:0]]) begin
	       if (bist_cnt[2:0] == 3'd7)
		  next_bist_sm = BIST_SERIAL_SCTAG_START;
	       else
		  next_bist_sm = BIST_SERIAL_SPC_START;
	    end
	    else
	       next_bist_sm = BIST_SERIAL_SPC_WAIT;
	 end
      end

      BIST_SERIAL_SPC_ABORT: next_bist_sm = BIST_IDLE;
      
      //--- Serial Bist (SCTAG) ---
      BIST_SERIAL_SCTAG_START: begin
	 if (bist_active_sctag[bist_cnt[1:0]])
	    next_bist_sm = BIST_SERIAL_SCTAG_CTRL;
	 else if (bist_cnt[1:0] == 2'd3)
	    next_bist_sm = BIST_IDLE;
	 else
	    next_bist_sm = BIST_SERIAL_SCTAG_START;
      end

      BIST_SERIAL_SCTAG_CTRL: begin
	 if (bist_ctrl_cnt == BIST_CTRL_MAX_CNT)
	    next_bist_sm = BIST_SERIAL_SCTAG_WAIT;
	 else
	    next_bist_sm = BIST_SERIAL_SCTAG_CTRL;
      end

      BIST_SERIAL_SCTAG_WAIT: begin
	 if (jtag_bist_abort_c)
	    next_bist_sm = BIST_SERIAL_SCTAG_ABORT;
	 else begin
	    if (bist_sctag_done[bist_cnt[1:0]])begin
	       if (bist_cnt[1:0] == 2'd3)
		  next_bist_sm = BIST_IDLE;
	       else
		  next_bist_sm = BIST_SERIAL_SCTAG_START;
	    end
	    else
	       next_bist_sm = BIST_SERIAL_SCTAG_WAIT;
	 end
      end

      BIST_SERIAL_SCTAG_ABORT: next_bist_sm = BIST_IDLE;

// CoverMeter line_off
      default: next_bist_sm = {BIST_SM_WIDTH{1'bx}};
// CoverMeter line_on
   endcase
end

//-----------
// bist abort
// - need to assert abort done long enough to be recognized in tck domain
// - abort_done_complete is the jbus sync version of abort_done_t fed back
//   into the jbus clock domain
//-----------

// cmp clock domain
assign next_abort_done =   (bist_sm == BIST_IDLE & jtag_bist_abort_c)
                         | bist_sm == BIST_PARALLEL_ABORT
			 | bist_sm == BIST_SERIAL_SPC_ABORT
			 | bist_sm == BIST_SERIAL_SCTAG_ABORT
			 | (abort_done & ~cmp_tx_en);

// jbus clock domain
assign next_abort_done_jreg =  abort_done_j
                              | (abort_done_jreg & ~abort_done_complete_j);

// tck clock domain
assign bist_jtag_abort_done = abort_done_jreg_t;
assign abort_done_complete = abort_done_jreg_t;

//------------
// bist active
// - ignore jtag_bist_active value when doing bist as part of reset sequence
// - do not initiate bist is core not available
//------------
assign bist_active_spc =  (jtag_bist_active_c[7:0] | {8{doing_rst_bist}})
                        & iob_ctu_coreavail[7:0];

assign bist_active_sctag =  (jtag_bist_active_c[11:8] | {4{doing_rst_bist}});
	     
//-----------
// bist done
//-----------
assign spc0_ctu_mbistdone_posedge = spc0_ctu_mbistdone_ff & ~spc0_ctu_mbistdone_d1;
assign spc1_ctu_mbistdone_posedge = spc1_ctu_mbistdone_ff & ~spc1_ctu_mbistdone_d1;
assign spc2_ctu_mbistdone_posedge = spc2_ctu_mbistdone_ff & ~spc2_ctu_mbistdone_d1;
assign spc3_ctu_mbistdone_posedge = spc3_ctu_mbistdone_ff & ~spc3_ctu_mbistdone_d1;
assign spc4_ctu_mbistdone_posedge = spc4_ctu_mbistdone_ff & ~spc4_ctu_mbistdone_d1;
assign spc5_ctu_mbistdone_posedge = spc5_ctu_mbistdone_ff & ~spc5_ctu_mbistdone_d1;
assign spc6_ctu_mbistdone_posedge = spc6_ctu_mbistdone_ff & ~spc6_ctu_mbistdone_d1;
assign spc7_ctu_mbistdone_posedge = spc7_ctu_mbistdone_ff & ~spc7_ctu_mbistdone_d1;
assign sctag0_ctu_mbistdone_posedge = sctag0_ctu_mbistdone_ff & ~sctag0_ctu_mbistdone_d1;
assign sctag1_ctu_mbistdone_posedge = sctag1_ctu_mbistdone_ff & ~sctag1_ctu_mbistdone_d1;
assign sctag2_ctu_mbistdone_posedge = sctag2_ctu_mbistdone_ff & ~sctag2_ctu_mbistdone_d1;
assign sctag3_ctu_mbistdone_posedge = sctag3_ctu_mbistdone_ff & ~sctag3_ctu_mbistdone_d1;

assign bist_done_rst_l = cmp_rst_l & ~(bist_sm == BIST_IDLE);

assign next_bist_spc_done[0] =  (~bist_spc_done[0] & spc0_ctu_mbistdone_posedge)
                              | bist_spc_done[0];
assign next_bist_spc_done[1] =  (~bist_spc_done[1] & spc1_ctu_mbistdone_posedge)
                              | bist_spc_done[1];
assign next_bist_spc_done[2] =  (~bist_spc_done[2] & spc2_ctu_mbistdone_posedge)
                              | bist_spc_done[2];
assign next_bist_spc_done[3] =  (~bist_spc_done[3] & spc3_ctu_mbistdone_posedge)
                              | bist_spc_done[3];
assign next_bist_spc_done[4] =  (~bist_spc_done[4] & spc4_ctu_mbistdone_posedge)
                              | bist_spc_done[4];
assign next_bist_spc_done[5] =  (~bist_spc_done[5] & spc5_ctu_mbistdone_posedge)
                              | bist_spc_done[5];
assign next_bist_spc_done[6] =  (~bist_spc_done[6] & spc6_ctu_mbistdone_posedge)
                              | bist_spc_done[6];
assign next_bist_spc_done[7] =  (~bist_spc_done[7] & spc7_ctu_mbistdone_posedge)
                              | bist_spc_done[7];

assign next_bist_sctag_done[0] =  (~bist_sctag_done[0] & sctag0_ctu_mbistdone_posedge)
                                | bist_sctag_done[0];
assign next_bist_sctag_done[1] =  (~bist_sctag_done[1] & sctag1_ctu_mbistdone_posedge)
                                | bist_sctag_done[1];
assign next_bist_sctag_done[2] =  (~bist_sctag_done[2] & sctag2_ctu_mbistdone_posedge)
                                | bist_sctag_done[2];
assign next_bist_sctag_done[3] =  (~bist_sctag_done[3] & sctag3_ctu_mbistdone_posedge)
                                | bist_sctag_done[3];

assign bist_done       = { bist_sctag_done,
			   bist_spc_done };

always @ ( /*AUTOSENSE*/bist_done or doing_rst_bist
	  or iob_ctu_coreavail or jtag_bist_active_c) begin
   if (doing_rst_bist)
      bist_parallel_done = &(bist_done | {4'd0, ~iob_ctu_coreavail});
   else
      bist_parallel_done = ~|(  ((bist_done | {4'd0, ~iob_ctu_coreavail}) & jtag_bist_active_c) 
			      ^ (jtag_bist_active_c)); //ignore inactive bist
end

//-----------
// bist count
//-----------
assign bist_cnt_rst_l = cmp_rst_l & ~(bist_sm == BIST_IDLE);
assign bist_cnt_incr  =   (bist_sm == BIST_SERIAL_SPC_START & next_bist_sm != BIST_SERIAL_SPC_CTRL)
                        | (bist_sm == BIST_SERIAL_SPC_WAIT  
			   & next_bist_sm != BIST_SERIAL_SPC_WAIT
			   & next_bist_sm != BIST_SERIAL_SPC_ABORT)
                        | (bist_sm == BIST_SERIAL_SCTAG_START & next_bist_sm != BIST_SERIAL_SCTAG_CTRL)
                        | (bist_sm == BIST_SERIAL_SCTAG_WAIT  
			   & next_bist_sm != BIST_SERIAL_SCTAG_WAIT
			   & next_bist_sm !=  BIST_SERIAL_SCTAG_ABORT);
        
always @ ( /*AUTOSENSE*/bist_cnt or bist_cnt_incr) begin
   if (bist_cnt_incr)
      next_bist_cnt = bist_cnt + 1'b1;
   else
      next_bist_cnt = bist_cnt;
end

//---------------------
// bist ctrl count
// - counts up to 5
//---------------------
assign bist_ctrl_cnt_rst_l =   bist_sm == BIST_PARALLEL_CTRL
			     | bist_sm == BIST_SERIAL_SPC_CTRL
			     | bist_sm == BIST_SERIAL_SCTAG_CTRL;

assign next_bist_ctrl_cnt = bist_ctrl_cnt + 1'b1;

//-------------------------------------------------
// Identify if doing bist as part of reset sequence
//-------------------------------------------------
assign next_doing_rst_bist =   (clsp_bist_dobist_posedge & bist_sm == BIST_IDLE)
			     | (doing_rst_bist           & next_bist_sm != BIST_IDLE);

assign bist_ctrl_load   =   bist_sm == BIST_IDLE
                          & (  jtag_bist_serial_posedge
			     | jtag_bist_parallel_posedge
			     | clsp_bist_dobist_posedge);
assign bist_ctrl_shift  =   bist_sm == BIST_PARALLEL_CTRL
                          | bist_sm == BIST_SERIAL_SPC_CTRL
                          | bist_sm == BIST_SERIAL_SCTAG_CTRL;

assign bist_ctrl_en     = bist_ctrl_load | bist_ctrl_shift;

always @ ( /*AUTOSENSE*/bist_ctrl or bist_ctrl_load
	  or clsp_bist_ctrl_c or clsp_bist_dobist_posedge
	  or clsp_bist_type_c) begin
   if (bist_ctrl_load) begin
      if (clsp_bist_dobist_posedge)
	 next_bist_ctrl = { 1'b1, clsp_bist_type_c, clsp_bist_ctrl_c[5:1] };
      else
	 next_bist_ctrl = { 1'b1, {BIST_CTRL_WIDTH-1{1'b0}} };
   end
   else
      next_bist_ctrl = {bist_ctrl[BIST_CTRL_WIDTH-2:0], bist_ctrl[BIST_CTRL_WIDTH-1]};
end


// notify iob when done with bist portion of reset sequence
assign next_wake_thr =  doing_rst_bist & next_bist_sm == BIST_IDLE
                      | (wake_thr & ~cmp_tx_en);

assign dft_wake_thr = wake_thr_j;

//********************************************************************
// BIST Enable
//********************************************************************
assign bist_sm_spc_start_state =  bist_sm == BIST_PARALLEL_START
		 		| bist_sm == BIST_SERIAL_SPC_START;

assign bist_sm_sctag_start_state =  bist_sm == BIST_PARALLEL_START
		 		  | bist_sm == BIST_SERIAL_SCTAG_START;

assign drive_spc_bist_ctrl_value =   bist_ctrl[BIST_CTRL_WIDTH-1]
				       & (  bist_sm == BIST_PARALLEL_CTRL 
		 		          | bist_sm == BIST_SERIAL_SPC_CTRL);

assign drive_sctag_bist_ctrl_value =   bist_ctrl[BIST_CTRL_WIDTH-1]
		  		          & (  bist_sm == BIST_PARALLEL_CTRL 
		 		             | bist_sm == BIST_SERIAL_SCTAG_CTRL);

//---------------------
// SPC
//---------------------
assign next_ctu_spc0_mbisten =  iob_ctu_coreavail[0]
                              & (  bist_sm == BIST_PARALLEL_ABORT
                                 | (  (  bist_cnt[2:0] == 3'd0 
				       | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
				    & (  (  bist_active_spc[0]                         // bist start
		     	     	          & bist_sm_spc_start_state)
				      | bist_sm == BIST_SERIAL_SPC_ABORT
			              | drive_spc_bist_ctrl_value)));

assign next_ctu_spc1_mbisten =  iob_ctu_coreavail[1]
                              & (  bist_sm == BIST_PARALLEL_ABORT
                                 | (  (  bist_cnt[2:0] == 3'd1 
			   	       | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
				    & (  (  bist_active_spc[1]                         // bist start
		     	     	          & bist_sm_spc_start_state)
				       | bist_sm == BIST_SERIAL_SPC_ABORT
			               | drive_spc_bist_ctrl_value)));

assign next_ctu_spc2_mbisten =  iob_ctu_coreavail[2]
                              & (  bist_sm == BIST_PARALLEL_ABORT
                                 | (  (  bist_cnt[2:0] == 3'd2 
				       | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
				    & (  (  bist_active_spc[2]                         // bist start
		     	     	          & bist_sm_spc_start_state)
				       | bist_sm == BIST_SERIAL_SPC_ABORT
			               | drive_spc_bist_ctrl_value)));

assign next_ctu_spc3_mbisten =  iob_ctu_coreavail[3]
                              & (  bist_sm == BIST_PARALLEL_ABORT
                                 | (  (  bist_cnt[2:0] == 3'd3 
				       | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
				    & (  (  bist_active_spc[3]                         // bist start
		     	     	          & bist_sm_spc_start_state)
				       | bist_sm == BIST_SERIAL_SPC_ABORT
			               | drive_spc_bist_ctrl_value)));

assign next_ctu_spc4_mbisten =  iob_ctu_coreavail[4]
                              & (  bist_sm == BIST_PARALLEL_ABORT
                                 | (  (  bist_cnt[2:0] == 3'd4 
				       | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
				    & (  (  bist_active_spc[4]                         // bist start
		     	     	          & bist_sm_spc_start_state)
				       | bist_sm == BIST_SERIAL_SPC_ABORT
			               | drive_spc_bist_ctrl_value)));

assign next_ctu_spc5_mbisten =  iob_ctu_coreavail[5]
                              & (  bist_sm == BIST_PARALLEL_ABORT
                                 | (  (  bist_cnt[2:0] == 3'd5 
				       | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
				    & (  (  bist_active_spc[5]                         // bist start
		     	     	          & bist_sm_spc_start_state)
				       | bist_sm == BIST_SERIAL_SPC_ABORT
			               | drive_spc_bist_ctrl_value)));

assign next_ctu_spc6_mbisten =  iob_ctu_coreavail[6]
                              & (  bist_sm == BIST_PARALLEL_ABORT
                                 | (  (  bist_cnt[2:0] == 3'd6 
				       | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
				    & (  (  bist_active_spc[6]                         // bist start
		     	     	          & bist_sm_spc_start_state)
				       | bist_sm == BIST_SERIAL_SPC_ABORT
			               | drive_spc_bist_ctrl_value)));

assign next_ctu_spc7_mbisten =  iob_ctu_coreavail[7]
                              & (  bist_sm == BIST_PARALLEL_ABORT
                                 | (  (  bist_cnt[2:0] == 3'd7 
				       | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
				    & (  (  bist_active_spc[7]                         // bist start
		     	     	          & bist_sm_spc_start_state)
				       | bist_sm == BIST_SERIAL_SPC_ABORT
			               | drive_spc_bist_ctrl_value)));
//---------------------
// SCTAG
//---------------------
assign next_ctu_sctag0_mbisten =  bist_sm == BIST_PARALLEL_ABORT
                                | (  (  bist_cnt[1:0] == 2'd0 
				      | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
                                   & (  (  bist_active_sctag[0]                       // bist start
		     	     		 & bist_sm_sctag_start_state)
				      | bist_sm == BIST_SERIAL_SCTAG_ABORT
			              | drive_sctag_bist_ctrl_value));

assign next_ctu_sctag1_mbisten =  bist_sm == BIST_PARALLEL_ABORT
                                | (  (  bist_cnt[1:0] == 2'd1 
				      | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
                                   & (  (  bist_active_sctag[1]                       // bist start
		     	     		 & bist_sm_sctag_start_state)
				      | bist_sm == BIST_SERIAL_SCTAG_ABORT
			              | drive_sctag_bist_ctrl_value));

assign next_ctu_sctag2_mbisten =  bist_sm == BIST_PARALLEL_ABORT
                                | (  (  bist_cnt[1:0] == 2'd2 
				      | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
                                   & (  (  bist_active_sctag[2]                       // bist start
		     	     		 & bist_sm_sctag_start_state)
				      | bist_sm == BIST_SERIAL_SCTAG_ABORT
			              | drive_sctag_bist_ctrl_value));

assign next_ctu_sctag3_mbisten =  bist_sm == BIST_PARALLEL_ABORT
                                | (  (  bist_cnt[1:0] == 2'd3 
				      | bist_sm[BIST_MODE_HI:BIST_MODE_LO] == BIST_MODE_PARALLEL)
                                   & (  (  bist_active_sctag[3]                       // bist start
		     	     		 & bist_sm_sctag_start_state)
				      | bist_sm == BIST_SERIAL_SCTAG_ABORT
			              | drive_sctag_bist_ctrl_value));



//********************************************************************
// BIST Result
// - tck domain
//********************************************************************

assign bist_jtag_result = { sctag3_ctu_mbisterr_t, sctag3_ctu_mbistdone_t,
			    sctag2_ctu_mbisterr_t, sctag2_ctu_mbistdone_t,
			    sctag1_ctu_mbisterr_t, sctag1_ctu_mbistdone_t,
			    sctag0_ctu_mbisterr_t, sctag0_ctu_mbistdone_t,
			    spc7_ctu_mbisterr_t,   spc7_ctu_mbistdone_t,
			    spc6_ctu_mbisterr_t,   spc6_ctu_mbistdone_t,
			    spc5_ctu_mbisterr_t,   spc5_ctu_mbistdone_t,
			    spc4_ctu_mbisterr_t,   spc4_ctu_mbistdone_t,
			    spc3_ctu_mbisterr_t,   spc3_ctu_mbistdone_t,
			    spc2_ctu_mbisterr_t,   spc2_ctu_mbistdone_t,
			    spc1_ctu_mbisterr_t,   spc1_ctu_mbistdone_t,
			    spc0_ctu_mbisterr_t,   spc0_ctu_mbistdone_t };

//assign bist_jtag_busy = bist_busy_t;

//*******************************************************************************
// Synchronizers
//*******************************************************************************

//------------------
// jbus -> cmp
//------------------

// clsp_bist_dobist
dff_ns #(1) u_dff_clsp_bist_dobist_ff
   ( .din (clsp_bist_dobist),
     .clk (jbus_clk),
     .q (clsp_bist_dobist_ff)
     );

dffrle_ns #(1) u_dffrle_clsp_bist_dobist_c
   (.din  (clsp_bist_dobist_ff),
    .clk  (cmp_clk),
    .en   (cmp_rx_en),
    .rst_l(cmp_rst_l),
    .q    (clsp_bist_dobist_c)
    );

// clsp_bist_type
dff_ns #(1) u_dff_clsp_bist_type_ff
   ( .din (clsp_bist_type),
     .clk (jbus_clk),
     .q (clsp_bist_type_ff)
     );

dffrle_ns #(1) u_dffrle_clsp_bist_type_c
   (.din  (clsp_bist_type_ff),
    .clk  (cmp_clk),
    .en   (cmp_rx_en),
    .rst_l(cmp_rst_l),
    .q    (clsp_bist_type_c)
    );

// clsp_bist_ctrl
dff_ns #(6) u_dff_clsp_bist_ctrl_ff
   ( .din (clsp_bist_ctrl),
     .clk (jbus_clk),
     .q (clsp_bist_ctrl_ff)
     );

dffrle_ns #(6) u_dffrle_clsp_bist_ctrl_c
   (.din  (clsp_bist_ctrl_ff),
    .clk  (cmp_clk),
    .en   (cmp_rx_en),
    .rst_l(cmp_rst_l),
    .q    (clsp_bist_ctrl_c)
    );

//------------------
// cmp -> jbus
//------------------

// wake_thr
dffrle_ns #(1) u_dffrle_wake_thr_tx
   (.din   (wake_thr),
    .clk   (cmp_clk),
    .en    (cmp_tx_en),
    .rst_l (cmp_rst_l),
    .q     (wake_thr_tx)
    );

dffrl_ns #(1) u_dffrl_wake_thr_j
   (.din   (wake_thr_tx),
    .clk   (jbus_clk),
    .rst_l (jbus_rst_l),
    .q     (wake_thr_j)
    );

// abort_done
dffrle_ns #(1) u_dffrle_abort_done_tx
   (.din   (abort_done),
    .clk   (cmp_clk),
    .en    (cmp_tx_en),
    .rst_l (cmp_rst_l),
    .q     (abort_done_tx)
    );

dffrl_ns #(1) u_dffrl_abort_done_j
   (.din   (abort_done_tx),
    .clk   (jbus_clk),
    .rst_l (jbus_rst_l),
    .q     (abort_done_j)
    );

//------------------
// cmp -> tck
//------------------

//mbistdone
dffrle_ns #(`CTU_BIST_CNT) u_dffrle_mbistdone_tx 
   (.din         ({ spc0_ctu_mbistdone_ff,
		    spc1_ctu_mbistdone_ff,
		    spc2_ctu_mbistdone_ff,
		    spc3_ctu_mbistdone_ff,
		    spc4_ctu_mbistdone_ff,
		    spc5_ctu_mbistdone_ff,
		    spc6_ctu_mbistdone_ff,
		    spc7_ctu_mbistdone_ff,
		    sctag0_ctu_mbistdone_ff,
		    sctag1_ctu_mbistdone_ff,
		    sctag2_ctu_mbistdone_ff,
		    sctag3_ctu_mbistdone_ff}),
    .clk        (cmp_clk),
    .en         (cmp_tx_en),
    .rst_l      (cmp_rst_l),
    .q          ({ spc0_ctu_mbistdone_tx,
		   spc1_ctu_mbistdone_tx,
		   spc2_ctu_mbistdone_tx,
		   spc3_ctu_mbistdone_tx,
		   spc4_ctu_mbistdone_tx,
		   spc5_ctu_mbistdone_tx,
		   spc6_ctu_mbistdone_tx,
		   spc7_ctu_mbistdone_tx,
		   sctag0_ctu_mbistdone_tx,
		   sctag1_ctu_mbistdone_tx,
		   sctag2_ctu_mbistdone_tx,
		   sctag3_ctu_mbistdone_tx})
    );

dffrl_ns #(`CTU_BIST_CNT) u_dffrl_mbist_done_j
   (.din        ({ spc0_ctu_mbistdone_tx,
		   spc1_ctu_mbistdone_tx,
		   spc2_ctu_mbistdone_tx,
		   spc3_ctu_mbistdone_tx,
		   spc4_ctu_mbistdone_tx,
		   spc5_ctu_mbistdone_tx,
		   spc6_ctu_mbistdone_tx,
		   spc7_ctu_mbistdone_tx,
		   sctag0_ctu_mbistdone_tx,
		   sctag1_ctu_mbistdone_tx,
		   sctag2_ctu_mbistdone_tx,
		   sctag3_ctu_mbistdone_tx}),
    .clk        (jbus_clk),
    .rst_l      (jbus_rst_l),
    .q          ({ spc0_ctu_mbistdone_j,
		   spc1_ctu_mbistdone_j,
		   spc2_ctu_mbistdone_j,
		   spc3_ctu_mbistdone_j,
		   spc4_ctu_mbistdone_j,
		   spc5_ctu_mbistdone_j,
		   spc6_ctu_mbistdone_j,
		   spc7_ctu_mbistdone_j,
		   sctag0_ctu_mbistdone_j,
		   sctag1_ctu_mbistdone_j,
		   sctag2_ctu_mbistdone_j,
		   sctag3_ctu_mbistdone_j})
    );

ctu_synchronizer #(`CTU_BIST_CNT) u_sync_mbistdone_t
   ( .presyncdata ({ spc0_ctu_mbistdone_j,
		     spc1_ctu_mbistdone_j,
		     spc2_ctu_mbistdone_j,
		     spc3_ctu_mbistdone_j,
		     spc4_ctu_mbistdone_j,
		     spc5_ctu_mbistdone_j,
		     spc6_ctu_mbistdone_j,
		     spc7_ctu_mbistdone_j,
		     sctag0_ctu_mbistdone_j,
		     sctag1_ctu_mbistdone_j,
		     sctag2_ctu_mbistdone_j,
		     sctag3_ctu_mbistdone_j}),
     .syncdata    ({ spc0_ctu_mbistdone_t,
		     spc1_ctu_mbistdone_t,
		     spc2_ctu_mbistdone_t,
		     spc3_ctu_mbistdone_t,
		     spc4_ctu_mbistdone_t,
		     spc5_ctu_mbistdone_t,
		     spc6_ctu_mbistdone_t,
		     spc7_ctu_mbistdone_t,
		     sctag0_ctu_mbistdone_t,
		     sctag1_ctu_mbistdone_t,
		     sctag2_ctu_mbistdone_t,
		     sctag3_ctu_mbistdone_t}),
     .clk         (io_tck)
     );
   
//mbisterr
dffrle_ns #(`CTU_BIST_CNT) u_dffrle_mbisterr_tx 
   (.din         ({ spc0_ctu_mbisterr_ff,
		    spc1_ctu_mbisterr_ff,
		    spc2_ctu_mbisterr_ff,
		    spc3_ctu_mbisterr_ff,
		    spc4_ctu_mbisterr_ff,
		    spc5_ctu_mbisterr_ff,
		    spc6_ctu_mbisterr_ff,
		    spc7_ctu_mbisterr_ff,
		    sctag0_ctu_mbisterr_ff,
		    sctag1_ctu_mbisterr_ff,
		    sctag2_ctu_mbisterr_ff,
		    sctag3_ctu_mbisterr_ff}),
    .clk        (cmp_clk),
    .en         (cmp_tx_en),
    .rst_l      (cmp_rst_l),
    .q          ({ spc0_ctu_mbisterr_tx,
		   spc1_ctu_mbisterr_tx,
		   spc2_ctu_mbisterr_tx,
		   spc3_ctu_mbisterr_tx,
		   spc4_ctu_mbisterr_tx,
		   spc5_ctu_mbisterr_tx,
		   spc6_ctu_mbisterr_tx,
		   spc7_ctu_mbisterr_tx,
		   sctag0_ctu_mbisterr_tx,
		   sctag1_ctu_mbisterr_tx,
		   sctag2_ctu_mbisterr_tx,
		   sctag3_ctu_mbisterr_tx})
    );

dffrl_ns #(`CTU_BIST_CNT) u_dffrl_mbist_err_j
   (.din        ({ spc0_ctu_mbisterr_tx,
		   spc1_ctu_mbisterr_tx,
		   spc2_ctu_mbisterr_tx,
		   spc3_ctu_mbisterr_tx,
		   spc4_ctu_mbisterr_tx,
		   spc5_ctu_mbisterr_tx,
		   spc6_ctu_mbisterr_tx,
		   spc7_ctu_mbisterr_tx,
		   sctag0_ctu_mbisterr_tx,
		   sctag1_ctu_mbisterr_tx,
		   sctag2_ctu_mbisterr_tx,
		   sctag3_ctu_mbisterr_tx}),
    .clk        (jbus_clk),
    .rst_l      (jbus_rst_l),
    .q          ({ spc0_ctu_mbisterr_j,
		   spc1_ctu_mbisterr_j,
		   spc2_ctu_mbisterr_j,
		   spc3_ctu_mbisterr_j,
		   spc4_ctu_mbisterr_j,
		   spc5_ctu_mbisterr_j,
		   spc6_ctu_mbisterr_j,
		   spc7_ctu_mbisterr_j,
		   sctag0_ctu_mbisterr_j,
		   sctag1_ctu_mbisterr_j,
		   sctag2_ctu_mbisterr_j,
		   sctag3_ctu_mbisterr_j})
    );

ctu_synchronizer #(`CTU_BIST_CNT) u_sync_mbisterr_t
   ( .presyncdata ({ spc0_ctu_mbisterr_j,
		     spc1_ctu_mbisterr_j,
		     spc2_ctu_mbisterr_j,
		     spc3_ctu_mbisterr_j,
		     spc4_ctu_mbisterr_j,
		     spc5_ctu_mbisterr_j,
		     spc6_ctu_mbisterr_j,
		     spc7_ctu_mbisterr_j,
		     sctag0_ctu_mbisterr_j,
		     sctag1_ctu_mbisterr_j,
		     sctag2_ctu_mbisterr_j,
		     sctag3_ctu_mbisterr_j}),
     .syncdata    ({ spc0_ctu_mbisterr_t,
		     spc1_ctu_mbisterr_t,
		     spc2_ctu_mbisterr_t,
		     spc3_ctu_mbisterr_t,
		     spc4_ctu_mbisterr_t,
		     spc5_ctu_mbisterr_t,
		     spc6_ctu_mbisterr_t,
		     spc7_ctu_mbisterr_t,
		     sctag0_ctu_mbisterr_t,
		     sctag1_ctu_mbisterr_t,
		     sctag2_ctu_mbisterr_t,
		     sctag3_ctu_mbisterr_t}),
     .clk         (io_tck)
     );

// bist_busy
//dffrle_ns #(1) u_dffrle_bist_busy_tx
//   (.din   (bist_busy),
//    .clk   (cmp_clk),
//    .en    (cmp_tx_en),
//    .rst_l (cmp_rst_l),
//    .q     (bist_busy_tx)
//    );

//dffrl_ns #(1) u_dffrl_bist_busy_j
//   (.din   (bist_busy_tx),
//    .clk   (jbus_clk),
//    .rst_l (jbus_rst_l),
//    .q     (bist_busy_j)
//    );

//ctu_synchronizer u_sync_bist_busy_t
//   (.presyncdata (bist_busy_j),
//    .syncdata (bist_busy_t),
//    .clk (io_tck)
//    );
   
//------------------
// jbus -> tck
//------------------
ctu_synchronizer u_sync_abort_done_jreg_t
   (.presyncdata (abort_done_jreg),
    .syncdata (abort_done_jreg_t),
    .clk (io_tck)
    );


//------------------
// tck -> cmp
//------------------

// jtag_bist_serial
ctu_synchronizer u_sync_jtag_bist_serial_j
   ( .presyncdata (jtag_bist_serial),
     .syncdata    (jtag_bist_serial_j),
     .clk         (jbus_clk)
     );

dffrle_ns #(1) u_dffrle_jtag_bist_serial_c
   (.din  (jtag_bist_serial_j),
    .clk  (cmp_clk),
    .en   (cmp_rx_en),
    .rst_l(cmp_rst_l),
    .q    (jtag_bist_serial_c)
    );

// jtag_bist_parallel
ctu_synchronizer u_sync_jtag_bist_parallel_j
   ( .presyncdata (jtag_bist_parallel),
     .syncdata    (jtag_bist_parallel_j),
     .clk         (jbus_clk)
     );

dffrle_ns #(1) u_dffrle_jtag_bist_parallel_c
   (.din  (jtag_bist_parallel_j),
    .clk  (cmp_clk),
    .en   (cmp_rx_en),
    .rst_l(cmp_rst_l),
    .q    (jtag_bist_parallel_c)
    );

// jtag_bist_active
ctu_synchronizer #(`CTU_BIST_CNT) u_sync_jtag_bist_active_j
   ( .presyncdata (jtag_bist_active),
     .syncdata    (jtag_bist_active_j),
     .clk         (jbus_clk)
     );

dffrle_ns #(`CTU_BIST_CNT) u_dffrle_jtag_bist_active_c
   (.din  (jtag_bist_active_j),
    .clk  (cmp_clk),
    .en   (cmp_rx_en),
    .rst_l(cmp_rst_l),
    .q    (jtag_bist_active_c)
    );

// jtag_bist_abort
ctu_synchronizer u_sync_jtag_bist_abort_j
   ( .presyncdata (jtag_bist_abort),
     .syncdata    (jtag_bist_abort_j),
     .clk         (jbus_clk)
     );

dffrle_ns #(1) u_dffrle_jtag_bist_abort_c
   (.din  (jtag_bist_abort_j),
    .clk  (cmp_clk),
    .en   (cmp_rx_en),
    .rst_l(cmp_rst_l),
    .q    (jtag_bist_abort_c)
    );

//------------------
// tck -> jbus
//------------------
ctu_synchronizer u_sync_abort_done_complete_j
   ( .presyncdata (abort_done_complete),
     .syncdata    (abort_done_complete_j),
     .clk         (jbus_clk)
     );

   
//*******************************************************************************
// DFF Instantiations
//*******************************************************************************
dff_ns #(1) u_dffrl_clsp_bist_dobist_d1
   ( .din (clsp_bist_dobist_c),
     .clk (cmp_clk),
     .q (clsp_bist_dobist_d1)
     );

dff_ns #(1) u_dffrl_jtag_bist_serial_c_d1
   ( .din (jtag_bist_serial_c),
     .clk (cmp_clk),
     .q (jtag_bist_serial_c_d1)
     );

dff_ns #(1) u_dffrl_jtag_bist_parallel_c_d1
   ( .din (jtag_bist_parallel_c),
     .clk (cmp_clk),
     .q (jtag_bist_parallel_c_d1)
     );

dff_ns #(`CTU_BIST_CNT) u_dff_mbistdone_ff
   (.din         ({ spc0_ctu_mbistdone,
		    spc1_ctu_mbistdone,
		    spc2_ctu_mbistdone,
		    spc3_ctu_mbistdone,
		    spc4_ctu_mbistdone,
		    spc5_ctu_mbistdone,
		    spc6_ctu_mbistdone,
		    spc7_ctu_mbistdone,
		    sctag0_ctu_mbistdone,
		    sctag1_ctu_mbistdone,
		    sctag2_ctu_mbistdone,
		    sctag3_ctu_mbistdone}),
    .clk        (cmp_clk),
    .q          ({ spc0_ctu_mbistdone_ff,
		   spc1_ctu_mbistdone_ff,
		   spc2_ctu_mbistdone_ff,
		   spc3_ctu_mbistdone_ff,
		   spc4_ctu_mbistdone_ff,
		   spc5_ctu_mbistdone_ff,
		   spc6_ctu_mbistdone_ff,
		   spc7_ctu_mbistdone_ff,
		   sctag0_ctu_mbistdone_ff,
		   sctag1_ctu_mbistdone_ff,
		   sctag2_ctu_mbistdone_ff,
		   sctag3_ctu_mbistdone_ff})
    );

dff_ns #(`CTU_BIST_CNT) u_dff_mbistdone_d1
   (.din         ({ spc0_ctu_mbistdone_ff,
		    spc1_ctu_mbistdone_ff,
		    spc2_ctu_mbistdone_ff,
		    spc3_ctu_mbistdone_ff,
		    spc4_ctu_mbistdone_ff,
		    spc5_ctu_mbistdone_ff,
		    spc6_ctu_mbistdone_ff,
		    spc7_ctu_mbistdone_ff,
		    sctag0_ctu_mbistdone_ff,
		    sctag1_ctu_mbistdone_ff,
		    sctag2_ctu_mbistdone_ff,
		    sctag3_ctu_mbistdone_ff}),
    .clk        (cmp_clk),
    .q          ({ spc0_ctu_mbistdone_d1,
		   spc1_ctu_mbistdone_d1,
		   spc2_ctu_mbistdone_d1,
		   spc3_ctu_mbistdone_d1,
		   spc4_ctu_mbistdone_d1,
		   spc5_ctu_mbistdone_d1,
		   spc6_ctu_mbistdone_d1,
		   spc7_ctu_mbistdone_d1,
		   sctag0_ctu_mbistdone_d1,
		   sctag1_ctu_mbistdone_d1,
		   sctag2_ctu_mbistdone_d1,
		   sctag3_ctu_mbistdone_d1})
    );

dff_ns #(`CTU_BIST_CNT) u_dff_mbisterr_ff
   (.din         ({ spc0_ctu_mbisterr,
		    spc1_ctu_mbisterr,
		    spc2_ctu_mbisterr,
		    spc3_ctu_mbisterr,
		    spc4_ctu_mbisterr,
		    spc5_ctu_mbisterr,
		    spc6_ctu_mbisterr,
		    spc7_ctu_mbisterr,
		    sctag0_ctu_mbisterr,
		    sctag1_ctu_mbisterr,
		    sctag2_ctu_mbisterr,
		    sctag3_ctu_mbisterr}),
    .clk        (cmp_clk),
    .q          ({ spc0_ctu_mbisterr_ff,
		   spc1_ctu_mbisterr_ff,
		   spc2_ctu_mbisterr_ff,
		   spc3_ctu_mbisterr_ff,
		   spc4_ctu_mbisterr_ff,
		   spc5_ctu_mbisterr_ff,
		   spc6_ctu_mbisterr_ff,
		   spc7_ctu_mbisterr_ff,
		   sctag0_ctu_mbisterr_ff,
		   sctag1_ctu_mbisterr_ff,
		   sctag2_ctu_mbisterr_ff,
		   sctag3_ctu_mbisterr_ff})
    );


//*******************************************************************************
// DFFRL Instantiations
//*******************************************************************************
//-----------
// cmp
//-----------

dffrl_ns #(BIST_SM_WIDTH) u_dffrl_bist_sm
       ( .din (next_bist_sm),
	 .rst_l (cmp_rst_l),
	 .clk (cmp_clk),
	 .q (bist_sm)
	 );

dffrl_ns #(8) u_dffrl_bist_spc_done
       ( .din (next_bist_spc_done),
	 .rst_l (bist_done_rst_l),
	 .clk (cmp_clk),
	 .q (bist_spc_done)
	 );

dffrl_ns #(4) u_dffrl_bist_sctag_done
       ( .din (next_bist_sctag_done),
	 .rst_l (bist_done_rst_l),
	 .clk (cmp_clk),
	 .q (bist_sctag_done)
	 );

dffrl_ns #(3) u_dffrl_bist_cnt
       ( .din (next_bist_cnt),
	 .rst_l (bist_cnt_rst_l),
	 .clk (cmp_clk),
	 .q (bist_cnt)
	 );

dffrl_ns #(3) u_dffrl_bist_ctrl_cnt
       ( .din (next_bist_ctrl_cnt),
	 .rst_l (bist_ctrl_cnt_rst_l),
	 .clk (cmp_clk),
	 .q (bist_ctrl_cnt)
	 );

dffrl_ns #(1) u_dffrl_doing_rst_bist
       ( .din (next_doing_rst_bist),
	 .rst_l (cmp_rst_l),
	 .clk (cmp_clk),
	 .q (doing_rst_bist)
	 );

dffrl_ns #(1) u_dffrl_wake_thr
       ( .din (next_wake_thr),
	 .rst_l (cmp_rst_l),
	 .clk (cmp_clk),
	 .q (wake_thr)
	 );

dffrl_ns #(1) u_dffrl_abort_done
       ( .din (next_abort_done),
	 .rst_l (cmp_rst_l),
	 .clk (cmp_clk),
	 .q (abort_done)
	 );

dffrl_ns #(`CTU_BIST_CNT) u_dffrl_ctu_mbisten
   (.din         ({ next_ctu_spc0_mbisten,
		    next_ctu_spc1_mbisten,
		    next_ctu_spc2_mbisten,
		    next_ctu_spc3_mbisten,
		    next_ctu_spc4_mbisten,
		    next_ctu_spc5_mbisten,
		    next_ctu_spc6_mbisten,
		    next_ctu_spc7_mbisten,
		    next_ctu_sctag0_mbisten,
		    next_ctu_sctag1_mbisten,
		    next_ctu_sctag2_mbisten,
		    next_ctu_sctag3_mbisten}),
    .rst_l      (cmp_rst_l),
    .clk        (cmp_clk),
    .q          ({ ctu_spc0_mbisten,
		   ctu_spc1_mbisten,
		   ctu_spc2_mbisten,
		   ctu_spc3_mbisten,
		   ctu_spc4_mbisten,
		   ctu_spc5_mbisten,
		   ctu_spc6_mbisten,
		   ctu_spc7_mbisten,
		   ctu_sctag0_mbisten,
		   ctu_sctag1_mbisten,
		   ctu_sctag2_mbisten,
		   ctu_sctag3_mbisten})
    );

//------------------
// jbus
//------------------

dffrl_ns #(1) u_dffrl_abort_done_jreg
       ( .din (next_abort_done_jreg),
	 .rst_l (jbus_rst_l),
	 .clk (jbus_clk),
	 .q (abort_done_jreg)
	 );

//*******************************************************************************
// DFFRLE Instantiations
//*******************************************************************************

dffrle_ns #(BIST_CTRL_WIDTH) u_dffrle_bist_ctrl
   (.din  (next_bist_ctrl),
    .clk  (cmp_clk),
    .en   (bist_ctrl_en),
    .rst_l(cmp_rst_l),
    .q    (bist_ctrl)
    );

endmodule

// Local Variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// End:
