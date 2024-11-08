// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: tso_mon.v
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
////////////////////////////////////////////////////////;
// tso_mon.v
//
// Description: This is a rather eclectic monitor 
// to do tso coverage gathering. It also has some checkers
// and other useful stuff. It pokes into L2 the sparc core pipeline
// as well as the LSU. 
//
////////////////////////////////////////////////////////

`define FPOP1_RQ 5'b01010
`define FPOP2_RQ 5'b01011
`define STB_DRAIN_TO 8000

`ifdef GATE_SIM
`else
`include "cross_module.h"
`include "sys.h"
`include "iop.h"
`include "sctag.h"
`endif

//--------------------------------------------------------------------------------------
// module definition:
//  Note that most of the stuff is cross-module referencing,
// so the interface is minimal
//--------------------------------------------------------------------------------------
module tso_mon ( clk, rst_l);

  input clk;		// the cpu clock
  input rst_l;		// reset (active low).

`ifdef GATE_SIM
`else

  reg tso_mon_msg; 		// decides should we print all tso_mon messages
  reg disable_lock_check;	// disable one of my checkes
  reg kill_on_cross_mod_code;
  reg force_dfq;
  integer stb_drain_to_max;	// what the Store buffer timeout will be.
  reg enable_ifu_lsu_inv_clear;

  initial
  begin
    if( $test$plusargs("force_dfq") ) 
      force_dfq = 1'b1;
    else
      force_dfq= 1'b0;

    if( $test$plusargs("enable_ifu_lsu_inv_clear") ) 
	enable_ifu_lsu_inv_clear = 1;
    else
	enable_ifu_lsu_inv_clear = 0;


    if( $test$plusargs("tso_mon_msg") ) 
      tso_mon_msg = 1'b1;
    else
      tso_mon_msg= 1'b0;

    if( $test$plusargs("disable_lock_check") ) 
      disable_lock_check = 1'b1;
    else
      disable_lock_check = 1'b0;


    if (! $value$plusargs("stb_drain_to_max=%d", stb_drain_to_max)) begin
      stb_drain_to_max = `STB_DRAIN_TO ;
    end

    $display("%0d tso_mon: stb_drain_to_max = %d", $time, stb_drain_to_max);

    if( $test$plusargs("kill_on_cross_mod_code") ) 
      kill_on_cross_mod_code = 1'b1;
    else
      kill_on_cross_mod_code = 1'b0;


  end

wire tso_mon_vcc = 1'b1;
wire pll_lock = `TOP_MEMORY.ctu.u_pll.pll_lock;

//--------------------------------------------------------------------------------------
// related to bug 6372 - need to monitor some DFQ signals
//--------------------------------------------------------------------------------------
`ifdef RTL_SPARC0
wire       spc0_dfq_byp_ff_en      = `TOP_DESIGN.sparc0.lsu.qctl2.dfq_byp_ff_en;
wire       spc0_dfq_wr_en          = `TOP_DESIGN.sparc0.lsu.qctl2.dfq_wr_en;
reg        spc0_dfq_byp_ff_en_d1;
reg        spc0_dfq_wr_en_d1;
`endif
`ifdef RTL_SPARC1
wire       spc1_dfq_byp_ff_en      = `TOP_DESIGN.sparc1.lsu.qctl2.dfq_byp_ff_en;
wire       spc1_dfq_wr_en          = `TOP_DESIGN.sparc1.lsu.qctl2.dfq_wr_en;
reg        spc1_dfq_byp_ff_en_d1;
reg        spc1_dfq_wr_en_d1;
`endif
`ifdef RTL_SPARC2
wire       spc2_dfq_byp_ff_en      = `TOP_DESIGN.sparc2.lsu.qctl2.dfq_byp_ff_en;
wire       spc2_dfq_wr_en          = `TOP_DESIGN.sparc2.lsu.qctl2.dfq_wr_en;
reg        spc2_dfq_byp_ff_en_d1;
reg        spc2_dfq_wr_en_d1;
`endif
`ifdef RTL_SPARC3
wire       spc3_dfq_byp_ff_en      = `TOP_DESIGN.sparc3.lsu.qctl2.dfq_byp_ff_en;
wire       spc3_dfq_wr_en          = `TOP_DESIGN.sparc3.lsu.qctl2.dfq_wr_en;
reg        spc3_dfq_byp_ff_en_d1;
reg        spc3_dfq_wr_en_d1;
`endif
`ifdef RTL_SPARC4
wire       spc4_dfq_byp_ff_en      = `TOP_DESIGN.sparc4.lsu.qctl2.dfq_byp_ff_en;
wire       spc4_dfq_wr_en          = `TOP_DESIGN.sparc4.lsu.qctl2.dfq_wr_en;
reg        spc4_dfq_byp_ff_en_d1;
reg        spc4_dfq_wr_en_d1;
`endif
`ifdef RTL_SPARC5
wire       spc5_dfq_byp_ff_en      = `TOP_DESIGN.sparc5.lsu.qctl2.dfq_byp_ff_en;
wire       spc5_dfq_wr_en          = `TOP_DESIGN.sparc5.lsu.qctl2.dfq_wr_en;
reg        spc5_dfq_byp_ff_en_d1;
reg        spc5_dfq_wr_en_d1;
`endif
`ifdef RTL_SPARC6
wire       spc6_dfq_byp_ff_en      = `TOP_DESIGN.sparc6.lsu.qctl2.dfq_byp_ff_en;
wire       spc6_dfq_wr_en          = `TOP_DESIGN.sparc6.lsu.qctl2.dfq_wr_en;
reg        spc6_dfq_byp_ff_en_d1;
reg        spc6_dfq_wr_en_d1;
`endif
`ifdef RTL_SPARC7
wire       spc7_dfq_byp_ff_en      = `TOP_DESIGN.sparc7.lsu.qctl2.dfq_byp_ff_en;
wire       spc7_dfq_wr_en          = `TOP_DESIGN.sparc7.lsu.qctl2.dfq_wr_en;
reg        spc7_dfq_byp_ff_en_d1;
reg        spc7_dfq_wr_en_d1;
`endif

//--------------------------------------------------------------------------------------
// spc to pcx packets
//--------------------------------------------------------------------------------------
   wire  [4:0] 		  spc0_pcx_req_pq 	= `TOP_MEMORY.spc0_pcx_req_pq[4:0];
   wire        		  spc0_pcx_atom_pq	= `TOP_MEMORY.spc0_pcx_atom_pq;
   wire  [`PCX_WIDTH-1:0] spc0_pcx_data_pa 	= `TOP_MEMORY.spc0_pcx_data_pa[`PCX_WIDTH-1:0];

   reg 			  pcx0_vld_d1;	// valid pcx packet
   reg 			  pcx0_atom_pq_d1;	// atomic bit delayed by 1
   reg 			  pcx0_atom_pq_d2;	// delayed by 2
   reg 			  pcx0_req_pq_d1;	// OR of request bits delayed by 1
   reg [5:0]		  pcx0_type_d1;	// packet type delayed by 1
   wire  [4:0] 		  spc1_pcx_req_pq 	= `TOP_MEMORY.spc1_pcx_req_pq[4:0];
   wire        		  spc1_pcx_atom_pq	= `TOP_MEMORY.spc1_pcx_atom_pq;
   wire  [`PCX_WIDTH-1:0] spc1_pcx_data_pa 	= `TOP_MEMORY.spc1_pcx_data_pa[`PCX_WIDTH-1:0];

   reg 			  pcx1_vld_d1;	// valid pcx packet
   reg 			  pcx1_atom_pq_d1;	// atomic bit delayed by 1
   reg 			  pcx1_atom_pq_d2;	// delayed by 2
   reg 			  pcx1_req_pq_d1;	// OR of request bits delayed by 1
   reg [5:0]		  pcx1_type_d1;	// packet type delayed by 1
   wire  [4:0] 		  spc2_pcx_req_pq 	= `TOP_MEMORY.spc2_pcx_req_pq[4:0];
   wire        		  spc2_pcx_atom_pq	= `TOP_MEMORY.spc2_pcx_atom_pq;
   wire  [`PCX_WIDTH-1:0] spc2_pcx_data_pa 	= `TOP_MEMORY.spc2_pcx_data_pa[`PCX_WIDTH-1:0];

   reg 			  pcx2_vld_d1;	// valid pcx packet
   reg 			  pcx2_atom_pq_d1;	// atomic bit delayed by 1
   reg 			  pcx2_atom_pq_d2;	// delayed by 2
   reg 			  pcx2_req_pq_d1;	// OR of request bits delayed by 1
   reg [5:0]		  pcx2_type_d1;	// packet type delayed by 1
   wire  [4:0] 		  spc3_pcx_req_pq 	= `TOP_MEMORY.spc3_pcx_req_pq[4:0];
   wire        		  spc3_pcx_atom_pq	= `TOP_MEMORY.spc3_pcx_atom_pq;
   wire  [`PCX_WIDTH-1:0] spc3_pcx_data_pa 	= `TOP_MEMORY.spc3_pcx_data_pa[`PCX_WIDTH-1:0];

   reg 			  pcx3_vld_d1;	// valid pcx packet
   reg 			  pcx3_atom_pq_d1;	// atomic bit delayed by 1
   reg 			  pcx3_atom_pq_d2;	// delayed by 2
   reg 			  pcx3_req_pq_d1;	// OR of request bits delayed by 1
   reg [5:0]		  pcx3_type_d1;	// packet type delayed by 1
   wire  [4:0] 		  spc4_pcx_req_pq 	= `TOP_MEMORY.spc4_pcx_req_pq[4:0];
   wire        		  spc4_pcx_atom_pq	= `TOP_MEMORY.spc4_pcx_atom_pq;
   wire  [`PCX_WIDTH-1:0] spc4_pcx_data_pa 	= `TOP_MEMORY.spc4_pcx_data_pa[`PCX_WIDTH-1:0];

   reg 			  pcx4_vld_d1;	// valid pcx packet
   reg 			  pcx4_atom_pq_d1;	// atomic bit delayed by 1
   reg 			  pcx4_atom_pq_d2;	// delayed by 2
   reg 			  pcx4_req_pq_d1;	// OR of request bits delayed by 1
   reg [5:0]		  pcx4_type_d1;	// packet type delayed by 1
   wire  [4:0] 		  spc5_pcx_req_pq 	= `TOP_MEMORY.spc5_pcx_req_pq[4:0];
   wire        		  spc5_pcx_atom_pq	= `TOP_MEMORY.spc5_pcx_atom_pq;
   wire  [`PCX_WIDTH-1:0] spc5_pcx_data_pa 	= `TOP_MEMORY.spc5_pcx_data_pa[`PCX_WIDTH-1:0];

   reg 			  pcx5_vld_d1;	// valid pcx packet
   reg 			  pcx5_atom_pq_d1;	// atomic bit delayed by 1
   reg 			  pcx5_atom_pq_d2;	// delayed by 2
   reg 			  pcx5_req_pq_d1;	// OR of request bits delayed by 1
   reg [5:0]		  pcx5_type_d1;	// packet type delayed by 1
   wire  [4:0] 		  spc6_pcx_req_pq 	= `TOP_MEMORY.spc6_pcx_req_pq[4:0];
   wire        		  spc6_pcx_atom_pq	= `TOP_MEMORY.spc6_pcx_atom_pq;
   wire  [`PCX_WIDTH-1:0] spc6_pcx_data_pa 	= `TOP_MEMORY.spc6_pcx_data_pa[`PCX_WIDTH-1:0];

   reg 			  pcx6_vld_d1;	// valid pcx packet
   reg 			  pcx6_atom_pq_d1;	// atomic bit delayed by 1
   reg 			  pcx6_atom_pq_d2;	// delayed by 2
   reg 			  pcx6_req_pq_d1;	// OR of request bits delayed by 1
   reg [5:0]		  pcx6_type_d1;	// packet type delayed by 1
   wire  [4:0] 		  spc7_pcx_req_pq 	= `TOP_MEMORY.spc7_pcx_req_pq[4:0];
   wire        		  spc7_pcx_atom_pq	= `TOP_MEMORY.spc7_pcx_atom_pq;
   wire  [`PCX_WIDTH-1:0] spc7_pcx_data_pa 	= `TOP_MEMORY.spc7_pcx_data_pa[`PCX_WIDTH-1:0];

   reg 			  pcx7_vld_d1;	// valid pcx packet
   reg 			  pcx7_atom_pq_d1;	// atomic bit delayed by 1
   reg 			  pcx7_atom_pq_d2;	// delayed by 2
   reg 			  pcx7_req_pq_d1;	// OR of request bits delayed by 1
   reg [5:0]		  pcx7_type_d1;	// packet type delayed by 1

//--------------------------------------------------------------------------------------
// L2 tags tp cpx packets 
//--------------------------------------------------------------------------------------
   wire [7:0]            sctag0_cpx_req_cq	= `TOP_MEMORY.sctag0_cpx_req_cq[7:0]; 
   wire [7:0]            sctag0_cpx_atom_cq 	= `TOP_MEMORY.sctag0_cpx_atom_cq; 
   wire [`CPX_WIDTH-1:0] sctag0_cpx_data_ca 	= `TOP_MEMORY.sctag0_cpx_data_ca[`CPX_WIDTH-1:0]; 

   wire 		 sctag0_pcx_stall_pq = `TOP_MEMORY.sctag0_pcx_stall_pq;
   reg [7:0] 		 sctag0_cpx_req_cq_d1;	// delayed by 1
   reg [7:0] 		 sctag0_cpx_req_cq_d2;	// delayed by 2
   reg [7:0] 		 sctag0_cpx_atom_cq_d1;	// delayed by 1
   reg [7:0] 		 sctag0_cpx_atom_cq_d2;	// delayed by 2
   reg [127:0] 		 sctag0_cpx_type_str;	// in string format
   reg [3:0]   		 sctag0_cpx_type;		// packet type

   reg  sctag0_dc_lkup_c5;
   reg  sctag0_ic_lkup_c5;
   reg  sctag0_dc_lkup_c6;
   reg  sctag0_ic_lkup_c6;

   wire [3:0] sctag0_dc_lkup_panel_dec_c4 	= `TOP_MEMORY.sctag0.dirrep.dc_lkup_panel_dec_c4[3:0]; 
   wire [3:0] sctag0_dc_lkup_row_dec_c4 	= `TOP_MEMORY.sctag0.dirrep.dc_lkup_row_dec_c4[3:0]; 

   wire [3:0] sctag0_ic_lkup_panel_dec_c4 	= `TOP_MEMORY.sctag0.dirrep.ic_lkup_panel_dec_c4[3:0]; 
   wire [3:0] sctag0_ic_lkup_row_dec_c4 	= `TOP_MEMORY.sctag0.dirrep.ic_lkup_row_dec_c4[3:0]; 

   wire [127:0] sctag0_dc_cam_hit_c6		= `TOP_MEMORY.sctag0.dirvec_dp.dc_cam_hit_c6[127:0]; 
   wire [127:0] sctag0_ic_cam_hit_c6		= `TOP_MEMORY.sctag0.dirvec_dp.ic_cam_hit_c6[127:0]; 


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble0_sum  = sctag0_dc_cam_hit_c6[0] + sctag0_dc_cam_hit_c6[1] +
                                                        sctag0_dc_cam_hit_c6[2] + sctag0_dc_cam_hit_c6[3];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble0_sum  = sctag0_ic_cam_hit_c6[0] + sctag0_ic_cam_hit_c6[1] +
                                                        sctag0_ic_cam_hit_c6[2] + sctag0_ic_cam_hit_c6[3];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble0_sum= sctag0_dc_cam_hit_c6[0] + sctag0_dc_cam_hit_c6[1] +
                                                        sctag0_dc_cam_hit_c6[2] + sctag0_dc_cam_hit_c6[3] +
                                                        sctag0_ic_cam_hit_c6[0] + sctag0_ic_cam_hit_c6[1] +
                                                        sctag0_ic_cam_hit_c6[2] + sctag0_ic_cam_hit_c6[3];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble1_sum  = sctag0_dc_cam_hit_c6[4] + sctag0_dc_cam_hit_c6[5] +
                                                        sctag0_dc_cam_hit_c6[6] + sctag0_dc_cam_hit_c6[7];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble1_sum  = sctag0_ic_cam_hit_c6[4] + sctag0_ic_cam_hit_c6[5] +
                                                        sctag0_ic_cam_hit_c6[6] + sctag0_ic_cam_hit_c6[7];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble1_sum= sctag0_dc_cam_hit_c6[4] + sctag0_dc_cam_hit_c6[5] +
                                                        sctag0_dc_cam_hit_c6[6] + sctag0_dc_cam_hit_c6[7] +
                                                        sctag0_ic_cam_hit_c6[4] + sctag0_ic_cam_hit_c6[5] +
                                                        sctag0_ic_cam_hit_c6[6] + sctag0_ic_cam_hit_c6[7];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble2_sum  = sctag0_dc_cam_hit_c6[8] + sctag0_dc_cam_hit_c6[9] +
                                                        sctag0_dc_cam_hit_c6[10] + sctag0_dc_cam_hit_c6[11];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble2_sum  = sctag0_ic_cam_hit_c6[8] + sctag0_ic_cam_hit_c6[9] +
                                                        sctag0_ic_cam_hit_c6[10] + sctag0_ic_cam_hit_c6[11];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble2_sum= sctag0_dc_cam_hit_c6[8] + sctag0_dc_cam_hit_c6[9] +
                                                        sctag0_dc_cam_hit_c6[10] + sctag0_dc_cam_hit_c6[11] +
                                                        sctag0_ic_cam_hit_c6[8] + sctag0_ic_cam_hit_c6[9] +
                                                        sctag0_ic_cam_hit_c6[10] + sctag0_ic_cam_hit_c6[11];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble3_sum  = sctag0_dc_cam_hit_c6[12] + sctag0_dc_cam_hit_c6[13] +
                                                        sctag0_dc_cam_hit_c6[14] + sctag0_dc_cam_hit_c6[15];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble3_sum  = sctag0_ic_cam_hit_c6[12] + sctag0_ic_cam_hit_c6[13] +
                                                        sctag0_ic_cam_hit_c6[14] + sctag0_ic_cam_hit_c6[15];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble3_sum= sctag0_dc_cam_hit_c6[12] + sctag0_dc_cam_hit_c6[13] +
                                                        sctag0_dc_cam_hit_c6[14] + sctag0_dc_cam_hit_c6[15] +
                                                        sctag0_ic_cam_hit_c6[12] + sctag0_ic_cam_hit_c6[13] +
                                                        sctag0_ic_cam_hit_c6[14] + sctag0_ic_cam_hit_c6[15];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble4_sum  = sctag0_dc_cam_hit_c6[16] + sctag0_dc_cam_hit_c6[17] +
                                                        sctag0_dc_cam_hit_c6[18] + sctag0_dc_cam_hit_c6[19];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble4_sum  = sctag0_ic_cam_hit_c6[16] + sctag0_ic_cam_hit_c6[17] +
                                                        sctag0_ic_cam_hit_c6[18] + sctag0_ic_cam_hit_c6[19];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble4_sum= sctag0_dc_cam_hit_c6[16] + sctag0_dc_cam_hit_c6[17] +
                                                        sctag0_dc_cam_hit_c6[18] + sctag0_dc_cam_hit_c6[19] +
                                                        sctag0_ic_cam_hit_c6[16] + sctag0_ic_cam_hit_c6[17] +
                                                        sctag0_ic_cam_hit_c6[18] + sctag0_ic_cam_hit_c6[19];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble5_sum  = sctag0_dc_cam_hit_c6[20] + sctag0_dc_cam_hit_c6[21] +
                                                        sctag0_dc_cam_hit_c6[22] + sctag0_dc_cam_hit_c6[23];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble5_sum  = sctag0_ic_cam_hit_c6[20] + sctag0_ic_cam_hit_c6[21] +
                                                        sctag0_ic_cam_hit_c6[22] + sctag0_ic_cam_hit_c6[23];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble5_sum= sctag0_dc_cam_hit_c6[20] + sctag0_dc_cam_hit_c6[21] +
                                                        sctag0_dc_cam_hit_c6[22] + sctag0_dc_cam_hit_c6[23] +
                                                        sctag0_ic_cam_hit_c6[20] + sctag0_ic_cam_hit_c6[21] +
                                                        sctag0_ic_cam_hit_c6[22] + sctag0_ic_cam_hit_c6[23];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble6_sum  = sctag0_dc_cam_hit_c6[24] + sctag0_dc_cam_hit_c6[25] +
                                                        sctag0_dc_cam_hit_c6[26] + sctag0_dc_cam_hit_c6[27];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble6_sum  = sctag0_ic_cam_hit_c6[24] + sctag0_ic_cam_hit_c6[25] +
                                                        sctag0_ic_cam_hit_c6[26] + sctag0_ic_cam_hit_c6[27];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble6_sum= sctag0_dc_cam_hit_c6[24] + sctag0_dc_cam_hit_c6[25] +
                                                        sctag0_dc_cam_hit_c6[26] + sctag0_dc_cam_hit_c6[27] +
                                                        sctag0_ic_cam_hit_c6[24] + sctag0_ic_cam_hit_c6[25] +
                                                        sctag0_ic_cam_hit_c6[26] + sctag0_ic_cam_hit_c6[27];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble7_sum  = sctag0_dc_cam_hit_c6[28] + sctag0_dc_cam_hit_c6[29] +
                                                        sctag0_dc_cam_hit_c6[30] + sctag0_dc_cam_hit_c6[31];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble7_sum  = sctag0_ic_cam_hit_c6[28] + sctag0_ic_cam_hit_c6[29] +
                                                        sctag0_ic_cam_hit_c6[30] + sctag0_ic_cam_hit_c6[31];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble7_sum= sctag0_dc_cam_hit_c6[28] + sctag0_dc_cam_hit_c6[29] +
                                                        sctag0_dc_cam_hit_c6[30] + sctag0_dc_cam_hit_c6[31] +
                                                        sctag0_ic_cam_hit_c6[28] + sctag0_ic_cam_hit_c6[29] +
                                                        sctag0_ic_cam_hit_c6[30] + sctag0_ic_cam_hit_c6[31];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble8_sum  = sctag0_dc_cam_hit_c6[32] + sctag0_dc_cam_hit_c6[33] +
                                                        sctag0_dc_cam_hit_c6[34] + sctag0_dc_cam_hit_c6[35];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble8_sum  = sctag0_ic_cam_hit_c6[32] + sctag0_ic_cam_hit_c6[33] +
                                                        sctag0_ic_cam_hit_c6[34] + sctag0_ic_cam_hit_c6[35];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble8_sum= sctag0_dc_cam_hit_c6[32] + sctag0_dc_cam_hit_c6[33] +
                                                        sctag0_dc_cam_hit_c6[34] + sctag0_dc_cam_hit_c6[35] +
                                                        sctag0_ic_cam_hit_c6[32] + sctag0_ic_cam_hit_c6[33] +
                                                        sctag0_ic_cam_hit_c6[34] + sctag0_ic_cam_hit_c6[35];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble9_sum  = sctag0_dc_cam_hit_c6[36] + sctag0_dc_cam_hit_c6[37] +
                                                        sctag0_dc_cam_hit_c6[38] + sctag0_dc_cam_hit_c6[39];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble9_sum  = sctag0_ic_cam_hit_c6[36] + sctag0_ic_cam_hit_c6[37] +
                                                        sctag0_ic_cam_hit_c6[38] + sctag0_ic_cam_hit_c6[39];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble9_sum= sctag0_dc_cam_hit_c6[36] + sctag0_dc_cam_hit_c6[37] +
                                                        sctag0_dc_cam_hit_c6[38] + sctag0_dc_cam_hit_c6[39] +
                                                        sctag0_ic_cam_hit_c6[36] + sctag0_ic_cam_hit_c6[37] +
                                                        sctag0_ic_cam_hit_c6[38] + sctag0_ic_cam_hit_c6[39];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble10_sum  = sctag0_dc_cam_hit_c6[40] + sctag0_dc_cam_hit_c6[41] +
                                                        sctag0_dc_cam_hit_c6[42] + sctag0_dc_cam_hit_c6[43];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble10_sum  = sctag0_ic_cam_hit_c6[40] + sctag0_ic_cam_hit_c6[41] +
                                                        sctag0_ic_cam_hit_c6[42] + sctag0_ic_cam_hit_c6[43];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble10_sum= sctag0_dc_cam_hit_c6[40] + sctag0_dc_cam_hit_c6[41] +
                                                        sctag0_dc_cam_hit_c6[42] + sctag0_dc_cam_hit_c6[43] +
                                                        sctag0_ic_cam_hit_c6[40] + sctag0_ic_cam_hit_c6[41] +
                                                        sctag0_ic_cam_hit_c6[42] + sctag0_ic_cam_hit_c6[43];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble11_sum  = sctag0_dc_cam_hit_c6[44] + sctag0_dc_cam_hit_c6[45] +
                                                        sctag0_dc_cam_hit_c6[46] + sctag0_dc_cam_hit_c6[47];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble11_sum  = sctag0_ic_cam_hit_c6[44] + sctag0_ic_cam_hit_c6[45] +
                                                        sctag0_ic_cam_hit_c6[46] + sctag0_ic_cam_hit_c6[47];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble11_sum= sctag0_dc_cam_hit_c6[44] + sctag0_dc_cam_hit_c6[45] +
                                                        sctag0_dc_cam_hit_c6[46] + sctag0_dc_cam_hit_c6[47] +
                                                        sctag0_ic_cam_hit_c6[44] + sctag0_ic_cam_hit_c6[45] +
                                                        sctag0_ic_cam_hit_c6[46] + sctag0_ic_cam_hit_c6[47];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble12_sum  = sctag0_dc_cam_hit_c6[48] + sctag0_dc_cam_hit_c6[49] +
                                                        sctag0_dc_cam_hit_c6[50] + sctag0_dc_cam_hit_c6[51];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble12_sum  = sctag0_ic_cam_hit_c6[48] + sctag0_ic_cam_hit_c6[49] +
                                                        sctag0_ic_cam_hit_c6[50] + sctag0_ic_cam_hit_c6[51];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble12_sum= sctag0_dc_cam_hit_c6[48] + sctag0_dc_cam_hit_c6[49] +
                                                        sctag0_dc_cam_hit_c6[50] + sctag0_dc_cam_hit_c6[51] +
                                                        sctag0_ic_cam_hit_c6[48] + sctag0_ic_cam_hit_c6[49] +
                                                        sctag0_ic_cam_hit_c6[50] + sctag0_ic_cam_hit_c6[51];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble13_sum  = sctag0_dc_cam_hit_c6[52] + sctag0_dc_cam_hit_c6[53] +
                                                        sctag0_dc_cam_hit_c6[54] + sctag0_dc_cam_hit_c6[55];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble13_sum  = sctag0_ic_cam_hit_c6[52] + sctag0_ic_cam_hit_c6[53] +
                                                        sctag0_ic_cam_hit_c6[54] + sctag0_ic_cam_hit_c6[55];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble13_sum= sctag0_dc_cam_hit_c6[52] + sctag0_dc_cam_hit_c6[53] +
                                                        sctag0_dc_cam_hit_c6[54] + sctag0_dc_cam_hit_c6[55] +
                                                        sctag0_ic_cam_hit_c6[52] + sctag0_ic_cam_hit_c6[53] +
                                                        sctag0_ic_cam_hit_c6[54] + sctag0_ic_cam_hit_c6[55];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble14_sum  = sctag0_dc_cam_hit_c6[56] + sctag0_dc_cam_hit_c6[57] +
                                                        sctag0_dc_cam_hit_c6[58] + sctag0_dc_cam_hit_c6[59];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble14_sum  = sctag0_ic_cam_hit_c6[56] + sctag0_ic_cam_hit_c6[57] +
                                                        sctag0_ic_cam_hit_c6[58] + sctag0_ic_cam_hit_c6[59];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble14_sum= sctag0_dc_cam_hit_c6[56] + sctag0_dc_cam_hit_c6[57] +
                                                        sctag0_dc_cam_hit_c6[58] + sctag0_dc_cam_hit_c6[59] +
                                                        sctag0_ic_cam_hit_c6[56] + sctag0_ic_cam_hit_c6[57] +
                                                        sctag0_ic_cam_hit_c6[58] + sctag0_ic_cam_hit_c6[59];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble15_sum  = sctag0_dc_cam_hit_c6[60] + sctag0_dc_cam_hit_c6[61] +
                                                        sctag0_dc_cam_hit_c6[62] + sctag0_dc_cam_hit_c6[63];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble15_sum  = sctag0_ic_cam_hit_c6[60] + sctag0_ic_cam_hit_c6[61] +
                                                        sctag0_ic_cam_hit_c6[62] + sctag0_ic_cam_hit_c6[63];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble15_sum= sctag0_dc_cam_hit_c6[60] + sctag0_dc_cam_hit_c6[61] +
                                                        sctag0_dc_cam_hit_c6[62] + sctag0_dc_cam_hit_c6[63] +
                                                        sctag0_ic_cam_hit_c6[60] + sctag0_ic_cam_hit_c6[61] +
                                                        sctag0_ic_cam_hit_c6[62] + sctag0_ic_cam_hit_c6[63];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble16_sum  = sctag0_dc_cam_hit_c6[64] + sctag0_dc_cam_hit_c6[65] +
                                                        sctag0_dc_cam_hit_c6[66] + sctag0_dc_cam_hit_c6[67];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble16_sum  = sctag0_ic_cam_hit_c6[64] + sctag0_ic_cam_hit_c6[65] +
                                                        sctag0_ic_cam_hit_c6[66] + sctag0_ic_cam_hit_c6[67];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble16_sum= sctag0_dc_cam_hit_c6[64] + sctag0_dc_cam_hit_c6[65] +
                                                        sctag0_dc_cam_hit_c6[66] + sctag0_dc_cam_hit_c6[67] +
                                                        sctag0_ic_cam_hit_c6[64] + sctag0_ic_cam_hit_c6[65] +
                                                        sctag0_ic_cam_hit_c6[66] + sctag0_ic_cam_hit_c6[67];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble17_sum  = sctag0_dc_cam_hit_c6[68] + sctag0_dc_cam_hit_c6[69] +
                                                        sctag0_dc_cam_hit_c6[70] + sctag0_dc_cam_hit_c6[71];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble17_sum  = sctag0_ic_cam_hit_c6[68] + sctag0_ic_cam_hit_c6[69] +
                                                        sctag0_ic_cam_hit_c6[70] + sctag0_ic_cam_hit_c6[71];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble17_sum= sctag0_dc_cam_hit_c6[68] + sctag0_dc_cam_hit_c6[69] +
                                                        sctag0_dc_cam_hit_c6[70] + sctag0_dc_cam_hit_c6[71] +
                                                        sctag0_ic_cam_hit_c6[68] + sctag0_ic_cam_hit_c6[69] +
                                                        sctag0_ic_cam_hit_c6[70] + sctag0_ic_cam_hit_c6[71];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble18_sum  = sctag0_dc_cam_hit_c6[72] + sctag0_dc_cam_hit_c6[73] +
                                                        sctag0_dc_cam_hit_c6[74] + sctag0_dc_cam_hit_c6[75];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble18_sum  = sctag0_ic_cam_hit_c6[72] + sctag0_ic_cam_hit_c6[73] +
                                                        sctag0_ic_cam_hit_c6[74] + sctag0_ic_cam_hit_c6[75];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble18_sum= sctag0_dc_cam_hit_c6[72] + sctag0_dc_cam_hit_c6[73] +
                                                        sctag0_dc_cam_hit_c6[74] + sctag0_dc_cam_hit_c6[75] +
                                                        sctag0_ic_cam_hit_c6[72] + sctag0_ic_cam_hit_c6[73] +
                                                        sctag0_ic_cam_hit_c6[74] + sctag0_ic_cam_hit_c6[75];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble19_sum  = sctag0_dc_cam_hit_c6[76] + sctag0_dc_cam_hit_c6[77] +
                                                        sctag0_dc_cam_hit_c6[78] + sctag0_dc_cam_hit_c6[79];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble19_sum  = sctag0_ic_cam_hit_c6[76] + sctag0_ic_cam_hit_c6[77] +
                                                        sctag0_ic_cam_hit_c6[78] + sctag0_ic_cam_hit_c6[79];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble19_sum= sctag0_dc_cam_hit_c6[76] + sctag0_dc_cam_hit_c6[77] +
                                                        sctag0_dc_cam_hit_c6[78] + sctag0_dc_cam_hit_c6[79] +
                                                        sctag0_ic_cam_hit_c6[76] + sctag0_ic_cam_hit_c6[77] +
                                                        sctag0_ic_cam_hit_c6[78] + sctag0_ic_cam_hit_c6[79];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble20_sum  = sctag0_dc_cam_hit_c6[80] + sctag0_dc_cam_hit_c6[81] +
                                                        sctag0_dc_cam_hit_c6[82] + sctag0_dc_cam_hit_c6[83];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble20_sum  = sctag0_ic_cam_hit_c6[80] + sctag0_ic_cam_hit_c6[81] +
                                                        sctag0_ic_cam_hit_c6[82] + sctag0_ic_cam_hit_c6[83];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble20_sum= sctag0_dc_cam_hit_c6[80] + sctag0_dc_cam_hit_c6[81] +
                                                        sctag0_dc_cam_hit_c6[82] + sctag0_dc_cam_hit_c6[83] +
                                                        sctag0_ic_cam_hit_c6[80] + sctag0_ic_cam_hit_c6[81] +
                                                        sctag0_ic_cam_hit_c6[82] + sctag0_ic_cam_hit_c6[83];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble21_sum  = sctag0_dc_cam_hit_c6[84] + sctag0_dc_cam_hit_c6[85] +
                                                        sctag0_dc_cam_hit_c6[86] + sctag0_dc_cam_hit_c6[87];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble21_sum  = sctag0_ic_cam_hit_c6[84] + sctag0_ic_cam_hit_c6[85] +
                                                        sctag0_ic_cam_hit_c6[86] + sctag0_ic_cam_hit_c6[87];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble21_sum= sctag0_dc_cam_hit_c6[84] + sctag0_dc_cam_hit_c6[85] +
                                                        sctag0_dc_cam_hit_c6[86] + sctag0_dc_cam_hit_c6[87] +
                                                        sctag0_ic_cam_hit_c6[84] + sctag0_ic_cam_hit_c6[85] +
                                                        sctag0_ic_cam_hit_c6[86] + sctag0_ic_cam_hit_c6[87];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble22_sum  = sctag0_dc_cam_hit_c6[88] + sctag0_dc_cam_hit_c6[89] +
                                                        sctag0_dc_cam_hit_c6[90] + sctag0_dc_cam_hit_c6[91];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble22_sum  = sctag0_ic_cam_hit_c6[88] + sctag0_ic_cam_hit_c6[89] +
                                                        sctag0_ic_cam_hit_c6[90] + sctag0_ic_cam_hit_c6[91];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble22_sum= sctag0_dc_cam_hit_c6[88] + sctag0_dc_cam_hit_c6[89] +
                                                        sctag0_dc_cam_hit_c6[90] + sctag0_dc_cam_hit_c6[91] +
                                                        sctag0_ic_cam_hit_c6[88] + sctag0_ic_cam_hit_c6[89] +
                                                        sctag0_ic_cam_hit_c6[90] + sctag0_ic_cam_hit_c6[91];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble23_sum  = sctag0_dc_cam_hit_c6[92] + sctag0_dc_cam_hit_c6[93] +
                                                        sctag0_dc_cam_hit_c6[94] + sctag0_dc_cam_hit_c6[95];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble23_sum  = sctag0_ic_cam_hit_c6[92] + sctag0_ic_cam_hit_c6[93] +
                                                        sctag0_ic_cam_hit_c6[94] + sctag0_ic_cam_hit_c6[95];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble23_sum= sctag0_dc_cam_hit_c6[92] + sctag0_dc_cam_hit_c6[93] +
                                                        sctag0_dc_cam_hit_c6[94] + sctag0_dc_cam_hit_c6[95] +
                                                        sctag0_ic_cam_hit_c6[92] + sctag0_ic_cam_hit_c6[93] +
                                                        sctag0_ic_cam_hit_c6[94] + sctag0_ic_cam_hit_c6[95];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble24_sum  = sctag0_dc_cam_hit_c6[96] + sctag0_dc_cam_hit_c6[97] +
                                                        sctag0_dc_cam_hit_c6[98] + sctag0_dc_cam_hit_c6[99];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble24_sum  = sctag0_ic_cam_hit_c6[96] + sctag0_ic_cam_hit_c6[97] +
                                                        sctag0_ic_cam_hit_c6[98] + sctag0_ic_cam_hit_c6[99];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble24_sum= sctag0_dc_cam_hit_c6[96] + sctag0_dc_cam_hit_c6[97] +
                                                        sctag0_dc_cam_hit_c6[98] + sctag0_dc_cam_hit_c6[99] +
                                                        sctag0_ic_cam_hit_c6[96] + sctag0_ic_cam_hit_c6[97] +
                                                        sctag0_ic_cam_hit_c6[98] + sctag0_ic_cam_hit_c6[99];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble25_sum  = sctag0_dc_cam_hit_c6[100] + sctag0_dc_cam_hit_c6[101] +
                                                        sctag0_dc_cam_hit_c6[102] + sctag0_dc_cam_hit_c6[103];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble25_sum  = sctag0_ic_cam_hit_c6[100] + sctag0_ic_cam_hit_c6[101] +
                                                        sctag0_ic_cam_hit_c6[102] + sctag0_ic_cam_hit_c6[103];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble25_sum= sctag0_dc_cam_hit_c6[100] + sctag0_dc_cam_hit_c6[101] +
                                                        sctag0_dc_cam_hit_c6[102] + sctag0_dc_cam_hit_c6[103] +
                                                        sctag0_ic_cam_hit_c6[100] + sctag0_ic_cam_hit_c6[101] +
                                                        sctag0_ic_cam_hit_c6[102] + sctag0_ic_cam_hit_c6[103];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble26_sum  = sctag0_dc_cam_hit_c6[104] + sctag0_dc_cam_hit_c6[105] +
                                                        sctag0_dc_cam_hit_c6[106] + sctag0_dc_cam_hit_c6[107];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble26_sum  = sctag0_ic_cam_hit_c6[104] + sctag0_ic_cam_hit_c6[105] +
                                                        sctag0_ic_cam_hit_c6[106] + sctag0_ic_cam_hit_c6[107];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble26_sum= sctag0_dc_cam_hit_c6[104] + sctag0_dc_cam_hit_c6[105] +
                                                        sctag0_dc_cam_hit_c6[106] + sctag0_dc_cam_hit_c6[107] +
                                                        sctag0_ic_cam_hit_c6[104] + sctag0_ic_cam_hit_c6[105] +
                                                        sctag0_ic_cam_hit_c6[106] + sctag0_ic_cam_hit_c6[107];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble27_sum  = sctag0_dc_cam_hit_c6[108] + sctag0_dc_cam_hit_c6[109] +
                                                        sctag0_dc_cam_hit_c6[110] + sctag0_dc_cam_hit_c6[111];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble27_sum  = sctag0_ic_cam_hit_c6[108] + sctag0_ic_cam_hit_c6[109] +
                                                        sctag0_ic_cam_hit_c6[110] + sctag0_ic_cam_hit_c6[111];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble27_sum= sctag0_dc_cam_hit_c6[108] + sctag0_dc_cam_hit_c6[109] +
                                                        sctag0_dc_cam_hit_c6[110] + sctag0_dc_cam_hit_c6[111] +
                                                        sctag0_ic_cam_hit_c6[108] + sctag0_ic_cam_hit_c6[109] +
                                                        sctag0_ic_cam_hit_c6[110] + sctag0_ic_cam_hit_c6[111];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble28_sum  = sctag0_dc_cam_hit_c6[112] + sctag0_dc_cam_hit_c6[113] +
                                                        sctag0_dc_cam_hit_c6[114] + sctag0_dc_cam_hit_c6[115];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble28_sum  = sctag0_ic_cam_hit_c6[112] + sctag0_ic_cam_hit_c6[113] +
                                                        sctag0_ic_cam_hit_c6[114] + sctag0_ic_cam_hit_c6[115];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble28_sum= sctag0_dc_cam_hit_c6[112] + sctag0_dc_cam_hit_c6[113] +
                                                        sctag0_dc_cam_hit_c6[114] + sctag0_dc_cam_hit_c6[115] +
                                                        sctag0_ic_cam_hit_c6[112] + sctag0_ic_cam_hit_c6[113] +
                                                        sctag0_ic_cam_hit_c6[114] + sctag0_ic_cam_hit_c6[115];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble29_sum  = sctag0_dc_cam_hit_c6[116] + sctag0_dc_cam_hit_c6[117] +
                                                        sctag0_dc_cam_hit_c6[118] + sctag0_dc_cam_hit_c6[119];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble29_sum  = sctag0_ic_cam_hit_c6[116] + sctag0_ic_cam_hit_c6[117] +
                                                        sctag0_ic_cam_hit_c6[118] + sctag0_ic_cam_hit_c6[119];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble29_sum= sctag0_dc_cam_hit_c6[116] + sctag0_dc_cam_hit_c6[117] +
                                                        sctag0_dc_cam_hit_c6[118] + sctag0_dc_cam_hit_c6[119] +
                                                        sctag0_ic_cam_hit_c6[116] + sctag0_ic_cam_hit_c6[117] +
                                                        sctag0_ic_cam_hit_c6[118] + sctag0_ic_cam_hit_c6[119];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble30_sum  = sctag0_dc_cam_hit_c6[120] + sctag0_dc_cam_hit_c6[121] +
                                                        sctag0_dc_cam_hit_c6[122] + sctag0_dc_cam_hit_c6[123];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble30_sum  = sctag0_ic_cam_hit_c6[120] + sctag0_ic_cam_hit_c6[121] +
                                                        sctag0_ic_cam_hit_c6[122] + sctag0_ic_cam_hit_c6[123];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble30_sum= sctag0_dc_cam_hit_c6[120] + sctag0_dc_cam_hit_c6[121] +
                                                        sctag0_dc_cam_hit_c6[122] + sctag0_dc_cam_hit_c6[123] +
                                                        sctag0_ic_cam_hit_c6[120] + sctag0_ic_cam_hit_c6[121] +
                                                        sctag0_ic_cam_hit_c6[122] + sctag0_ic_cam_hit_c6[123];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag0_dc_cam_hit_c6_nibble31_sum  = sctag0_dc_cam_hit_c6[124] + sctag0_dc_cam_hit_c6[125] +
                                                        sctag0_dc_cam_hit_c6[126] + sctag0_dc_cam_hit_c6[127];

   wire [2:0] sctag0_ic_cam_hit_c6_nibble31_sum  = sctag0_ic_cam_hit_c6[124] + sctag0_ic_cam_hit_c6[125] +
                                                        sctag0_ic_cam_hit_c6[126] + sctag0_ic_cam_hit_c6[127];
   
   wire [3:0] sctag0_both_cam_hit_c6_nibble31_sum= sctag0_dc_cam_hit_c6[124] + sctag0_dc_cam_hit_c6[125] +
                                                        sctag0_dc_cam_hit_c6[126] + sctag0_dc_cam_hit_c6[127] +
                                                        sctag0_ic_cam_hit_c6[124] + sctag0_ic_cam_hit_c6[125] +
                                                        sctag0_ic_cam_hit_c6[126] + sctag0_ic_cam_hit_c6[127];

   wire [7:0]            sctag1_cpx_req_cq	= `TOP_MEMORY.sctag1_cpx_req_cq[7:0]; 
   wire [7:0]            sctag1_cpx_atom_cq 	= `TOP_MEMORY.sctag1_cpx_atom_cq; 
   wire [`CPX_WIDTH-1:0] sctag1_cpx_data_ca 	= `TOP_MEMORY.sctag1_cpx_data_ca[`CPX_WIDTH-1:0]; 

   wire 		 sctag1_pcx_stall_pq = `TOP_MEMORY.sctag1_pcx_stall_pq;
   reg [7:0] 		 sctag1_cpx_req_cq_d1;	// delayed by 1
   reg [7:0] 		 sctag1_cpx_req_cq_d2;	// delayed by 2
   reg [7:0] 		 sctag1_cpx_atom_cq_d1;	// delayed by 1
   reg [7:0] 		 sctag1_cpx_atom_cq_d2;	// delayed by 2
   reg [127:0] 		 sctag1_cpx_type_str;	// in string format
   reg [3:0]   		 sctag1_cpx_type;		// packet type

   reg  sctag1_dc_lkup_c5;
   reg  sctag1_ic_lkup_c5;
   reg  sctag1_dc_lkup_c6;
   reg  sctag1_ic_lkup_c6;

   wire [3:0] sctag1_dc_lkup_panel_dec_c4 	= `TOP_MEMORY.sctag1.dirrep.dc_lkup_panel_dec_c4[3:0]; 
   wire [3:0] sctag1_dc_lkup_row_dec_c4 	= `TOP_MEMORY.sctag1.dirrep.dc_lkup_row_dec_c4[3:0]; 

   wire [3:0] sctag1_ic_lkup_panel_dec_c4 	= `TOP_MEMORY.sctag1.dirrep.ic_lkup_panel_dec_c4[3:0]; 
   wire [3:0] sctag1_ic_lkup_row_dec_c4 	= `TOP_MEMORY.sctag1.dirrep.ic_lkup_row_dec_c4[3:0]; 

   wire [127:0] sctag1_dc_cam_hit_c6		= `TOP_MEMORY.sctag1.dirvec_dp.dc_cam_hit_c6[127:0]; 
   wire [127:0] sctag1_ic_cam_hit_c6		= `TOP_MEMORY.sctag1.dirvec_dp.ic_cam_hit_c6[127:0]; 


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble0_sum  = sctag1_dc_cam_hit_c6[0] + sctag1_dc_cam_hit_c6[1] +
                                                        sctag1_dc_cam_hit_c6[2] + sctag1_dc_cam_hit_c6[3];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble0_sum  = sctag1_ic_cam_hit_c6[0] + sctag1_ic_cam_hit_c6[1] +
                                                        sctag1_ic_cam_hit_c6[2] + sctag1_ic_cam_hit_c6[3];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble0_sum= sctag1_dc_cam_hit_c6[0] + sctag1_dc_cam_hit_c6[1] +
                                                        sctag1_dc_cam_hit_c6[2] + sctag1_dc_cam_hit_c6[3] +
                                                        sctag1_ic_cam_hit_c6[0] + sctag1_ic_cam_hit_c6[1] +
                                                        sctag1_ic_cam_hit_c6[2] + sctag1_ic_cam_hit_c6[3];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble1_sum  = sctag1_dc_cam_hit_c6[4] + sctag1_dc_cam_hit_c6[5] +
                                                        sctag1_dc_cam_hit_c6[6] + sctag1_dc_cam_hit_c6[7];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble1_sum  = sctag1_ic_cam_hit_c6[4] + sctag1_ic_cam_hit_c6[5] +
                                                        sctag1_ic_cam_hit_c6[6] + sctag1_ic_cam_hit_c6[7];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble1_sum= sctag1_dc_cam_hit_c6[4] + sctag1_dc_cam_hit_c6[5] +
                                                        sctag1_dc_cam_hit_c6[6] + sctag1_dc_cam_hit_c6[7] +
                                                        sctag1_ic_cam_hit_c6[4] + sctag1_ic_cam_hit_c6[5] +
                                                        sctag1_ic_cam_hit_c6[6] + sctag1_ic_cam_hit_c6[7];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble2_sum  = sctag1_dc_cam_hit_c6[8] + sctag1_dc_cam_hit_c6[9] +
                                                        sctag1_dc_cam_hit_c6[10] + sctag1_dc_cam_hit_c6[11];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble2_sum  = sctag1_ic_cam_hit_c6[8] + sctag1_ic_cam_hit_c6[9] +
                                                        sctag1_ic_cam_hit_c6[10] + sctag1_ic_cam_hit_c6[11];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble2_sum= sctag1_dc_cam_hit_c6[8] + sctag1_dc_cam_hit_c6[9] +
                                                        sctag1_dc_cam_hit_c6[10] + sctag1_dc_cam_hit_c6[11] +
                                                        sctag1_ic_cam_hit_c6[8] + sctag1_ic_cam_hit_c6[9] +
                                                        sctag1_ic_cam_hit_c6[10] + sctag1_ic_cam_hit_c6[11];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble3_sum  = sctag1_dc_cam_hit_c6[12] + sctag1_dc_cam_hit_c6[13] +
                                                        sctag1_dc_cam_hit_c6[14] + sctag1_dc_cam_hit_c6[15];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble3_sum  = sctag1_ic_cam_hit_c6[12] + sctag1_ic_cam_hit_c6[13] +
                                                        sctag1_ic_cam_hit_c6[14] + sctag1_ic_cam_hit_c6[15];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble3_sum= sctag1_dc_cam_hit_c6[12] + sctag1_dc_cam_hit_c6[13] +
                                                        sctag1_dc_cam_hit_c6[14] + sctag1_dc_cam_hit_c6[15] +
                                                        sctag1_ic_cam_hit_c6[12] + sctag1_ic_cam_hit_c6[13] +
                                                        sctag1_ic_cam_hit_c6[14] + sctag1_ic_cam_hit_c6[15];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble4_sum  = sctag1_dc_cam_hit_c6[16] + sctag1_dc_cam_hit_c6[17] +
                                                        sctag1_dc_cam_hit_c6[18] + sctag1_dc_cam_hit_c6[19];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble4_sum  = sctag1_ic_cam_hit_c6[16] + sctag1_ic_cam_hit_c6[17] +
                                                        sctag1_ic_cam_hit_c6[18] + sctag1_ic_cam_hit_c6[19];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble4_sum= sctag1_dc_cam_hit_c6[16] + sctag1_dc_cam_hit_c6[17] +
                                                        sctag1_dc_cam_hit_c6[18] + sctag1_dc_cam_hit_c6[19] +
                                                        sctag1_ic_cam_hit_c6[16] + sctag1_ic_cam_hit_c6[17] +
                                                        sctag1_ic_cam_hit_c6[18] + sctag1_ic_cam_hit_c6[19];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble5_sum  = sctag1_dc_cam_hit_c6[20] + sctag1_dc_cam_hit_c6[21] +
                                                        sctag1_dc_cam_hit_c6[22] + sctag1_dc_cam_hit_c6[23];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble5_sum  = sctag1_ic_cam_hit_c6[20] + sctag1_ic_cam_hit_c6[21] +
                                                        sctag1_ic_cam_hit_c6[22] + sctag1_ic_cam_hit_c6[23];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble5_sum= sctag1_dc_cam_hit_c6[20] + sctag1_dc_cam_hit_c6[21] +
                                                        sctag1_dc_cam_hit_c6[22] + sctag1_dc_cam_hit_c6[23] +
                                                        sctag1_ic_cam_hit_c6[20] + sctag1_ic_cam_hit_c6[21] +
                                                        sctag1_ic_cam_hit_c6[22] + sctag1_ic_cam_hit_c6[23];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble6_sum  = sctag1_dc_cam_hit_c6[24] + sctag1_dc_cam_hit_c6[25] +
                                                        sctag1_dc_cam_hit_c6[26] + sctag1_dc_cam_hit_c6[27];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble6_sum  = sctag1_ic_cam_hit_c6[24] + sctag1_ic_cam_hit_c6[25] +
                                                        sctag1_ic_cam_hit_c6[26] + sctag1_ic_cam_hit_c6[27];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble6_sum= sctag1_dc_cam_hit_c6[24] + sctag1_dc_cam_hit_c6[25] +
                                                        sctag1_dc_cam_hit_c6[26] + sctag1_dc_cam_hit_c6[27] +
                                                        sctag1_ic_cam_hit_c6[24] + sctag1_ic_cam_hit_c6[25] +
                                                        sctag1_ic_cam_hit_c6[26] + sctag1_ic_cam_hit_c6[27];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble7_sum  = sctag1_dc_cam_hit_c6[28] + sctag1_dc_cam_hit_c6[29] +
                                                        sctag1_dc_cam_hit_c6[30] + sctag1_dc_cam_hit_c6[31];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble7_sum  = sctag1_ic_cam_hit_c6[28] + sctag1_ic_cam_hit_c6[29] +
                                                        sctag1_ic_cam_hit_c6[30] + sctag1_ic_cam_hit_c6[31];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble7_sum= sctag1_dc_cam_hit_c6[28] + sctag1_dc_cam_hit_c6[29] +
                                                        sctag1_dc_cam_hit_c6[30] + sctag1_dc_cam_hit_c6[31] +
                                                        sctag1_ic_cam_hit_c6[28] + sctag1_ic_cam_hit_c6[29] +
                                                        sctag1_ic_cam_hit_c6[30] + sctag1_ic_cam_hit_c6[31];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble8_sum  = sctag1_dc_cam_hit_c6[32] + sctag1_dc_cam_hit_c6[33] +
                                                        sctag1_dc_cam_hit_c6[34] + sctag1_dc_cam_hit_c6[35];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble8_sum  = sctag1_ic_cam_hit_c6[32] + sctag1_ic_cam_hit_c6[33] +
                                                        sctag1_ic_cam_hit_c6[34] + sctag1_ic_cam_hit_c6[35];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble8_sum= sctag1_dc_cam_hit_c6[32] + sctag1_dc_cam_hit_c6[33] +
                                                        sctag1_dc_cam_hit_c6[34] + sctag1_dc_cam_hit_c6[35] +
                                                        sctag1_ic_cam_hit_c6[32] + sctag1_ic_cam_hit_c6[33] +
                                                        sctag1_ic_cam_hit_c6[34] + sctag1_ic_cam_hit_c6[35];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble9_sum  = sctag1_dc_cam_hit_c6[36] + sctag1_dc_cam_hit_c6[37] +
                                                        sctag1_dc_cam_hit_c6[38] + sctag1_dc_cam_hit_c6[39];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble9_sum  = sctag1_ic_cam_hit_c6[36] + sctag1_ic_cam_hit_c6[37] +
                                                        sctag1_ic_cam_hit_c6[38] + sctag1_ic_cam_hit_c6[39];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble9_sum= sctag1_dc_cam_hit_c6[36] + sctag1_dc_cam_hit_c6[37] +
                                                        sctag1_dc_cam_hit_c6[38] + sctag1_dc_cam_hit_c6[39] +
                                                        sctag1_ic_cam_hit_c6[36] + sctag1_ic_cam_hit_c6[37] +
                                                        sctag1_ic_cam_hit_c6[38] + sctag1_ic_cam_hit_c6[39];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble10_sum  = sctag1_dc_cam_hit_c6[40] + sctag1_dc_cam_hit_c6[41] +
                                                        sctag1_dc_cam_hit_c6[42] + sctag1_dc_cam_hit_c6[43];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble10_sum  = sctag1_ic_cam_hit_c6[40] + sctag1_ic_cam_hit_c6[41] +
                                                        sctag1_ic_cam_hit_c6[42] + sctag1_ic_cam_hit_c6[43];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble10_sum= sctag1_dc_cam_hit_c6[40] + sctag1_dc_cam_hit_c6[41] +
                                                        sctag1_dc_cam_hit_c6[42] + sctag1_dc_cam_hit_c6[43] +
                                                        sctag1_ic_cam_hit_c6[40] + sctag1_ic_cam_hit_c6[41] +
                                                        sctag1_ic_cam_hit_c6[42] + sctag1_ic_cam_hit_c6[43];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble11_sum  = sctag1_dc_cam_hit_c6[44] + sctag1_dc_cam_hit_c6[45] +
                                                        sctag1_dc_cam_hit_c6[46] + sctag1_dc_cam_hit_c6[47];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble11_sum  = sctag1_ic_cam_hit_c6[44] + sctag1_ic_cam_hit_c6[45] +
                                                        sctag1_ic_cam_hit_c6[46] + sctag1_ic_cam_hit_c6[47];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble11_sum= sctag1_dc_cam_hit_c6[44] + sctag1_dc_cam_hit_c6[45] +
                                                        sctag1_dc_cam_hit_c6[46] + sctag1_dc_cam_hit_c6[47] +
                                                        sctag1_ic_cam_hit_c6[44] + sctag1_ic_cam_hit_c6[45] +
                                                        sctag1_ic_cam_hit_c6[46] + sctag1_ic_cam_hit_c6[47];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble12_sum  = sctag1_dc_cam_hit_c6[48] + sctag1_dc_cam_hit_c6[49] +
                                                        sctag1_dc_cam_hit_c6[50] + sctag1_dc_cam_hit_c6[51];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble12_sum  = sctag1_ic_cam_hit_c6[48] + sctag1_ic_cam_hit_c6[49] +
                                                        sctag1_ic_cam_hit_c6[50] + sctag1_ic_cam_hit_c6[51];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble12_sum= sctag1_dc_cam_hit_c6[48] + sctag1_dc_cam_hit_c6[49] +
                                                        sctag1_dc_cam_hit_c6[50] + sctag1_dc_cam_hit_c6[51] +
                                                        sctag1_ic_cam_hit_c6[48] + sctag1_ic_cam_hit_c6[49] +
                                                        sctag1_ic_cam_hit_c6[50] + sctag1_ic_cam_hit_c6[51];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble13_sum  = sctag1_dc_cam_hit_c6[52] + sctag1_dc_cam_hit_c6[53] +
                                                        sctag1_dc_cam_hit_c6[54] + sctag1_dc_cam_hit_c6[55];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble13_sum  = sctag1_ic_cam_hit_c6[52] + sctag1_ic_cam_hit_c6[53] +
                                                        sctag1_ic_cam_hit_c6[54] + sctag1_ic_cam_hit_c6[55];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble13_sum= sctag1_dc_cam_hit_c6[52] + sctag1_dc_cam_hit_c6[53] +
                                                        sctag1_dc_cam_hit_c6[54] + sctag1_dc_cam_hit_c6[55] +
                                                        sctag1_ic_cam_hit_c6[52] + sctag1_ic_cam_hit_c6[53] +
                                                        sctag1_ic_cam_hit_c6[54] + sctag1_ic_cam_hit_c6[55];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble14_sum  = sctag1_dc_cam_hit_c6[56] + sctag1_dc_cam_hit_c6[57] +
                                                        sctag1_dc_cam_hit_c6[58] + sctag1_dc_cam_hit_c6[59];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble14_sum  = sctag1_ic_cam_hit_c6[56] + sctag1_ic_cam_hit_c6[57] +
                                                        sctag1_ic_cam_hit_c6[58] + sctag1_ic_cam_hit_c6[59];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble14_sum= sctag1_dc_cam_hit_c6[56] + sctag1_dc_cam_hit_c6[57] +
                                                        sctag1_dc_cam_hit_c6[58] + sctag1_dc_cam_hit_c6[59] +
                                                        sctag1_ic_cam_hit_c6[56] + sctag1_ic_cam_hit_c6[57] +
                                                        sctag1_ic_cam_hit_c6[58] + sctag1_ic_cam_hit_c6[59];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble15_sum  = sctag1_dc_cam_hit_c6[60] + sctag1_dc_cam_hit_c6[61] +
                                                        sctag1_dc_cam_hit_c6[62] + sctag1_dc_cam_hit_c6[63];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble15_sum  = sctag1_ic_cam_hit_c6[60] + sctag1_ic_cam_hit_c6[61] +
                                                        sctag1_ic_cam_hit_c6[62] + sctag1_ic_cam_hit_c6[63];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble15_sum= sctag1_dc_cam_hit_c6[60] + sctag1_dc_cam_hit_c6[61] +
                                                        sctag1_dc_cam_hit_c6[62] + sctag1_dc_cam_hit_c6[63] +
                                                        sctag1_ic_cam_hit_c6[60] + sctag1_ic_cam_hit_c6[61] +
                                                        sctag1_ic_cam_hit_c6[62] + sctag1_ic_cam_hit_c6[63];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble16_sum  = sctag1_dc_cam_hit_c6[64] + sctag1_dc_cam_hit_c6[65] +
                                                        sctag1_dc_cam_hit_c6[66] + sctag1_dc_cam_hit_c6[67];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble16_sum  = sctag1_ic_cam_hit_c6[64] + sctag1_ic_cam_hit_c6[65] +
                                                        sctag1_ic_cam_hit_c6[66] + sctag1_ic_cam_hit_c6[67];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble16_sum= sctag1_dc_cam_hit_c6[64] + sctag1_dc_cam_hit_c6[65] +
                                                        sctag1_dc_cam_hit_c6[66] + sctag1_dc_cam_hit_c6[67] +
                                                        sctag1_ic_cam_hit_c6[64] + sctag1_ic_cam_hit_c6[65] +
                                                        sctag1_ic_cam_hit_c6[66] + sctag1_ic_cam_hit_c6[67];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble17_sum  = sctag1_dc_cam_hit_c6[68] + sctag1_dc_cam_hit_c6[69] +
                                                        sctag1_dc_cam_hit_c6[70] + sctag1_dc_cam_hit_c6[71];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble17_sum  = sctag1_ic_cam_hit_c6[68] + sctag1_ic_cam_hit_c6[69] +
                                                        sctag1_ic_cam_hit_c6[70] + sctag1_ic_cam_hit_c6[71];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble17_sum= sctag1_dc_cam_hit_c6[68] + sctag1_dc_cam_hit_c6[69] +
                                                        sctag1_dc_cam_hit_c6[70] + sctag1_dc_cam_hit_c6[71] +
                                                        sctag1_ic_cam_hit_c6[68] + sctag1_ic_cam_hit_c6[69] +
                                                        sctag1_ic_cam_hit_c6[70] + sctag1_ic_cam_hit_c6[71];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble18_sum  = sctag1_dc_cam_hit_c6[72] + sctag1_dc_cam_hit_c6[73] +
                                                        sctag1_dc_cam_hit_c6[74] + sctag1_dc_cam_hit_c6[75];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble18_sum  = sctag1_ic_cam_hit_c6[72] + sctag1_ic_cam_hit_c6[73] +
                                                        sctag1_ic_cam_hit_c6[74] + sctag1_ic_cam_hit_c6[75];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble18_sum= sctag1_dc_cam_hit_c6[72] + sctag1_dc_cam_hit_c6[73] +
                                                        sctag1_dc_cam_hit_c6[74] + sctag1_dc_cam_hit_c6[75] +
                                                        sctag1_ic_cam_hit_c6[72] + sctag1_ic_cam_hit_c6[73] +
                                                        sctag1_ic_cam_hit_c6[74] + sctag1_ic_cam_hit_c6[75];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble19_sum  = sctag1_dc_cam_hit_c6[76] + sctag1_dc_cam_hit_c6[77] +
                                                        sctag1_dc_cam_hit_c6[78] + sctag1_dc_cam_hit_c6[79];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble19_sum  = sctag1_ic_cam_hit_c6[76] + sctag1_ic_cam_hit_c6[77] +
                                                        sctag1_ic_cam_hit_c6[78] + sctag1_ic_cam_hit_c6[79];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble19_sum= sctag1_dc_cam_hit_c6[76] + sctag1_dc_cam_hit_c6[77] +
                                                        sctag1_dc_cam_hit_c6[78] + sctag1_dc_cam_hit_c6[79] +
                                                        sctag1_ic_cam_hit_c6[76] + sctag1_ic_cam_hit_c6[77] +
                                                        sctag1_ic_cam_hit_c6[78] + sctag1_ic_cam_hit_c6[79];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble20_sum  = sctag1_dc_cam_hit_c6[80] + sctag1_dc_cam_hit_c6[81] +
                                                        sctag1_dc_cam_hit_c6[82] + sctag1_dc_cam_hit_c6[83];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble20_sum  = sctag1_ic_cam_hit_c6[80] + sctag1_ic_cam_hit_c6[81] +
                                                        sctag1_ic_cam_hit_c6[82] + sctag1_ic_cam_hit_c6[83];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble20_sum= sctag1_dc_cam_hit_c6[80] + sctag1_dc_cam_hit_c6[81] +
                                                        sctag1_dc_cam_hit_c6[82] + sctag1_dc_cam_hit_c6[83] +
                                                        sctag1_ic_cam_hit_c6[80] + sctag1_ic_cam_hit_c6[81] +
                                                        sctag1_ic_cam_hit_c6[82] + sctag1_ic_cam_hit_c6[83];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble21_sum  = sctag1_dc_cam_hit_c6[84] + sctag1_dc_cam_hit_c6[85] +
                                                        sctag1_dc_cam_hit_c6[86] + sctag1_dc_cam_hit_c6[87];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble21_sum  = sctag1_ic_cam_hit_c6[84] + sctag1_ic_cam_hit_c6[85] +
                                                        sctag1_ic_cam_hit_c6[86] + sctag1_ic_cam_hit_c6[87];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble21_sum= sctag1_dc_cam_hit_c6[84] + sctag1_dc_cam_hit_c6[85] +
                                                        sctag1_dc_cam_hit_c6[86] + sctag1_dc_cam_hit_c6[87] +
                                                        sctag1_ic_cam_hit_c6[84] + sctag1_ic_cam_hit_c6[85] +
                                                        sctag1_ic_cam_hit_c6[86] + sctag1_ic_cam_hit_c6[87];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble22_sum  = sctag1_dc_cam_hit_c6[88] + sctag1_dc_cam_hit_c6[89] +
                                                        sctag1_dc_cam_hit_c6[90] + sctag1_dc_cam_hit_c6[91];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble22_sum  = sctag1_ic_cam_hit_c6[88] + sctag1_ic_cam_hit_c6[89] +
                                                        sctag1_ic_cam_hit_c6[90] + sctag1_ic_cam_hit_c6[91];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble22_sum= sctag1_dc_cam_hit_c6[88] + sctag1_dc_cam_hit_c6[89] +
                                                        sctag1_dc_cam_hit_c6[90] + sctag1_dc_cam_hit_c6[91] +
                                                        sctag1_ic_cam_hit_c6[88] + sctag1_ic_cam_hit_c6[89] +
                                                        sctag1_ic_cam_hit_c6[90] + sctag1_ic_cam_hit_c6[91];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble23_sum  = sctag1_dc_cam_hit_c6[92] + sctag1_dc_cam_hit_c6[93] +
                                                        sctag1_dc_cam_hit_c6[94] + sctag1_dc_cam_hit_c6[95];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble23_sum  = sctag1_ic_cam_hit_c6[92] + sctag1_ic_cam_hit_c6[93] +
                                                        sctag1_ic_cam_hit_c6[94] + sctag1_ic_cam_hit_c6[95];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble23_sum= sctag1_dc_cam_hit_c6[92] + sctag1_dc_cam_hit_c6[93] +
                                                        sctag1_dc_cam_hit_c6[94] + sctag1_dc_cam_hit_c6[95] +
                                                        sctag1_ic_cam_hit_c6[92] + sctag1_ic_cam_hit_c6[93] +
                                                        sctag1_ic_cam_hit_c6[94] + sctag1_ic_cam_hit_c6[95];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble24_sum  = sctag1_dc_cam_hit_c6[96] + sctag1_dc_cam_hit_c6[97] +
                                                        sctag1_dc_cam_hit_c6[98] + sctag1_dc_cam_hit_c6[99];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble24_sum  = sctag1_ic_cam_hit_c6[96] + sctag1_ic_cam_hit_c6[97] +
                                                        sctag1_ic_cam_hit_c6[98] + sctag1_ic_cam_hit_c6[99];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble24_sum= sctag1_dc_cam_hit_c6[96] + sctag1_dc_cam_hit_c6[97] +
                                                        sctag1_dc_cam_hit_c6[98] + sctag1_dc_cam_hit_c6[99] +
                                                        sctag1_ic_cam_hit_c6[96] + sctag1_ic_cam_hit_c6[97] +
                                                        sctag1_ic_cam_hit_c6[98] + sctag1_ic_cam_hit_c6[99];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble25_sum  = sctag1_dc_cam_hit_c6[100] + sctag1_dc_cam_hit_c6[101] +
                                                        sctag1_dc_cam_hit_c6[102] + sctag1_dc_cam_hit_c6[103];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble25_sum  = sctag1_ic_cam_hit_c6[100] + sctag1_ic_cam_hit_c6[101] +
                                                        sctag1_ic_cam_hit_c6[102] + sctag1_ic_cam_hit_c6[103];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble25_sum= sctag1_dc_cam_hit_c6[100] + sctag1_dc_cam_hit_c6[101] +
                                                        sctag1_dc_cam_hit_c6[102] + sctag1_dc_cam_hit_c6[103] +
                                                        sctag1_ic_cam_hit_c6[100] + sctag1_ic_cam_hit_c6[101] +
                                                        sctag1_ic_cam_hit_c6[102] + sctag1_ic_cam_hit_c6[103];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble26_sum  = sctag1_dc_cam_hit_c6[104] + sctag1_dc_cam_hit_c6[105] +
                                                        sctag1_dc_cam_hit_c6[106] + sctag1_dc_cam_hit_c6[107];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble26_sum  = sctag1_ic_cam_hit_c6[104] + sctag1_ic_cam_hit_c6[105] +
                                                        sctag1_ic_cam_hit_c6[106] + sctag1_ic_cam_hit_c6[107];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble26_sum= sctag1_dc_cam_hit_c6[104] + sctag1_dc_cam_hit_c6[105] +
                                                        sctag1_dc_cam_hit_c6[106] + sctag1_dc_cam_hit_c6[107] +
                                                        sctag1_ic_cam_hit_c6[104] + sctag1_ic_cam_hit_c6[105] +
                                                        sctag1_ic_cam_hit_c6[106] + sctag1_ic_cam_hit_c6[107];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble27_sum  = sctag1_dc_cam_hit_c6[108] + sctag1_dc_cam_hit_c6[109] +
                                                        sctag1_dc_cam_hit_c6[110] + sctag1_dc_cam_hit_c6[111];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble27_sum  = sctag1_ic_cam_hit_c6[108] + sctag1_ic_cam_hit_c6[109] +
                                                        sctag1_ic_cam_hit_c6[110] + sctag1_ic_cam_hit_c6[111];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble27_sum= sctag1_dc_cam_hit_c6[108] + sctag1_dc_cam_hit_c6[109] +
                                                        sctag1_dc_cam_hit_c6[110] + sctag1_dc_cam_hit_c6[111] +
                                                        sctag1_ic_cam_hit_c6[108] + sctag1_ic_cam_hit_c6[109] +
                                                        sctag1_ic_cam_hit_c6[110] + sctag1_ic_cam_hit_c6[111];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble28_sum  = sctag1_dc_cam_hit_c6[112] + sctag1_dc_cam_hit_c6[113] +
                                                        sctag1_dc_cam_hit_c6[114] + sctag1_dc_cam_hit_c6[115];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble28_sum  = sctag1_ic_cam_hit_c6[112] + sctag1_ic_cam_hit_c6[113] +
                                                        sctag1_ic_cam_hit_c6[114] + sctag1_ic_cam_hit_c6[115];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble28_sum= sctag1_dc_cam_hit_c6[112] + sctag1_dc_cam_hit_c6[113] +
                                                        sctag1_dc_cam_hit_c6[114] + sctag1_dc_cam_hit_c6[115] +
                                                        sctag1_ic_cam_hit_c6[112] + sctag1_ic_cam_hit_c6[113] +
                                                        sctag1_ic_cam_hit_c6[114] + sctag1_ic_cam_hit_c6[115];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble29_sum  = sctag1_dc_cam_hit_c6[116] + sctag1_dc_cam_hit_c6[117] +
                                                        sctag1_dc_cam_hit_c6[118] + sctag1_dc_cam_hit_c6[119];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble29_sum  = sctag1_ic_cam_hit_c6[116] + sctag1_ic_cam_hit_c6[117] +
                                                        sctag1_ic_cam_hit_c6[118] + sctag1_ic_cam_hit_c6[119];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble29_sum= sctag1_dc_cam_hit_c6[116] + sctag1_dc_cam_hit_c6[117] +
                                                        sctag1_dc_cam_hit_c6[118] + sctag1_dc_cam_hit_c6[119] +
                                                        sctag1_ic_cam_hit_c6[116] + sctag1_ic_cam_hit_c6[117] +
                                                        sctag1_ic_cam_hit_c6[118] + sctag1_ic_cam_hit_c6[119];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble30_sum  = sctag1_dc_cam_hit_c6[120] + sctag1_dc_cam_hit_c6[121] +
                                                        sctag1_dc_cam_hit_c6[122] + sctag1_dc_cam_hit_c6[123];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble30_sum  = sctag1_ic_cam_hit_c6[120] + sctag1_ic_cam_hit_c6[121] +
                                                        sctag1_ic_cam_hit_c6[122] + sctag1_ic_cam_hit_c6[123];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble30_sum= sctag1_dc_cam_hit_c6[120] + sctag1_dc_cam_hit_c6[121] +
                                                        sctag1_dc_cam_hit_c6[122] + sctag1_dc_cam_hit_c6[123] +
                                                        sctag1_ic_cam_hit_c6[120] + sctag1_ic_cam_hit_c6[121] +
                                                        sctag1_ic_cam_hit_c6[122] + sctag1_ic_cam_hit_c6[123];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag1_dc_cam_hit_c6_nibble31_sum  = sctag1_dc_cam_hit_c6[124] + sctag1_dc_cam_hit_c6[125] +
                                                        sctag1_dc_cam_hit_c6[126] + sctag1_dc_cam_hit_c6[127];

   wire [2:0] sctag1_ic_cam_hit_c6_nibble31_sum  = sctag1_ic_cam_hit_c6[124] + sctag1_ic_cam_hit_c6[125] +
                                                        sctag1_ic_cam_hit_c6[126] + sctag1_ic_cam_hit_c6[127];
   
   wire [3:0] sctag1_both_cam_hit_c6_nibble31_sum= sctag1_dc_cam_hit_c6[124] + sctag1_dc_cam_hit_c6[125] +
                                                        sctag1_dc_cam_hit_c6[126] + sctag1_dc_cam_hit_c6[127] +
                                                        sctag1_ic_cam_hit_c6[124] + sctag1_ic_cam_hit_c6[125] +
                                                        sctag1_ic_cam_hit_c6[126] + sctag1_ic_cam_hit_c6[127];

   wire [7:0]            sctag2_cpx_req_cq	= `TOP_MEMORY.sctag2_cpx_req_cq[7:0]; 
   wire [7:0]            sctag2_cpx_atom_cq 	= `TOP_MEMORY.sctag2_cpx_atom_cq; 
   wire [`CPX_WIDTH-1:0] sctag2_cpx_data_ca 	= `TOP_MEMORY.sctag2_cpx_data_ca[`CPX_WIDTH-1:0]; 

   wire 		 sctag2_pcx_stall_pq = `TOP_MEMORY.sctag2_pcx_stall_pq;
   reg [7:0] 		 sctag2_cpx_req_cq_d1;	// delayed by 1
   reg [7:0] 		 sctag2_cpx_req_cq_d2;	// delayed by 2
   reg [7:0] 		 sctag2_cpx_atom_cq_d1;	// delayed by 1
   reg [7:0] 		 sctag2_cpx_atom_cq_d2;	// delayed by 2
   reg [127:0] 		 sctag2_cpx_type_str;	// in string format
   reg [3:0]   		 sctag2_cpx_type;		// packet type

   reg  sctag2_dc_lkup_c5;
   reg  sctag2_ic_lkup_c5;
   reg  sctag2_dc_lkup_c6;
   reg  sctag2_ic_lkup_c6;

   wire [3:0] sctag2_dc_lkup_panel_dec_c4 	= `TOP_MEMORY.sctag2.dirrep.dc_lkup_panel_dec_c4[3:0]; 
   wire [3:0] sctag2_dc_lkup_row_dec_c4 	= `TOP_MEMORY.sctag2.dirrep.dc_lkup_row_dec_c4[3:0]; 

   wire [3:0] sctag2_ic_lkup_panel_dec_c4 	= `TOP_MEMORY.sctag2.dirrep.ic_lkup_panel_dec_c4[3:0]; 
   wire [3:0] sctag2_ic_lkup_row_dec_c4 	= `TOP_MEMORY.sctag2.dirrep.ic_lkup_row_dec_c4[3:0]; 

   wire [127:0] sctag2_dc_cam_hit_c6		= `TOP_MEMORY.sctag2.dirvec_dp.dc_cam_hit_c6[127:0]; 
   wire [127:0] sctag2_ic_cam_hit_c6		= `TOP_MEMORY.sctag2.dirvec_dp.ic_cam_hit_c6[127:0]; 


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble0_sum  = sctag2_dc_cam_hit_c6[0] + sctag2_dc_cam_hit_c6[1] +
                                                        sctag2_dc_cam_hit_c6[2] + sctag2_dc_cam_hit_c6[3];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble0_sum  = sctag2_ic_cam_hit_c6[0] + sctag2_ic_cam_hit_c6[1] +
                                                        sctag2_ic_cam_hit_c6[2] + sctag2_ic_cam_hit_c6[3];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble0_sum= sctag2_dc_cam_hit_c6[0] + sctag2_dc_cam_hit_c6[1] +
                                                        sctag2_dc_cam_hit_c6[2] + sctag2_dc_cam_hit_c6[3] +
                                                        sctag2_ic_cam_hit_c6[0] + sctag2_ic_cam_hit_c6[1] +
                                                        sctag2_ic_cam_hit_c6[2] + sctag2_ic_cam_hit_c6[3];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble1_sum  = sctag2_dc_cam_hit_c6[4] + sctag2_dc_cam_hit_c6[5] +
                                                        sctag2_dc_cam_hit_c6[6] + sctag2_dc_cam_hit_c6[7];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble1_sum  = sctag2_ic_cam_hit_c6[4] + sctag2_ic_cam_hit_c6[5] +
                                                        sctag2_ic_cam_hit_c6[6] + sctag2_ic_cam_hit_c6[7];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble1_sum= sctag2_dc_cam_hit_c6[4] + sctag2_dc_cam_hit_c6[5] +
                                                        sctag2_dc_cam_hit_c6[6] + sctag2_dc_cam_hit_c6[7] +
                                                        sctag2_ic_cam_hit_c6[4] + sctag2_ic_cam_hit_c6[5] +
                                                        sctag2_ic_cam_hit_c6[6] + sctag2_ic_cam_hit_c6[7];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble2_sum  = sctag2_dc_cam_hit_c6[8] + sctag2_dc_cam_hit_c6[9] +
                                                        sctag2_dc_cam_hit_c6[10] + sctag2_dc_cam_hit_c6[11];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble2_sum  = sctag2_ic_cam_hit_c6[8] + sctag2_ic_cam_hit_c6[9] +
                                                        sctag2_ic_cam_hit_c6[10] + sctag2_ic_cam_hit_c6[11];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble2_sum= sctag2_dc_cam_hit_c6[8] + sctag2_dc_cam_hit_c6[9] +
                                                        sctag2_dc_cam_hit_c6[10] + sctag2_dc_cam_hit_c6[11] +
                                                        sctag2_ic_cam_hit_c6[8] + sctag2_ic_cam_hit_c6[9] +
                                                        sctag2_ic_cam_hit_c6[10] + sctag2_ic_cam_hit_c6[11];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble3_sum  = sctag2_dc_cam_hit_c6[12] + sctag2_dc_cam_hit_c6[13] +
                                                        sctag2_dc_cam_hit_c6[14] + sctag2_dc_cam_hit_c6[15];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble3_sum  = sctag2_ic_cam_hit_c6[12] + sctag2_ic_cam_hit_c6[13] +
                                                        sctag2_ic_cam_hit_c6[14] + sctag2_ic_cam_hit_c6[15];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble3_sum= sctag2_dc_cam_hit_c6[12] + sctag2_dc_cam_hit_c6[13] +
                                                        sctag2_dc_cam_hit_c6[14] + sctag2_dc_cam_hit_c6[15] +
                                                        sctag2_ic_cam_hit_c6[12] + sctag2_ic_cam_hit_c6[13] +
                                                        sctag2_ic_cam_hit_c6[14] + sctag2_ic_cam_hit_c6[15];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble4_sum  = sctag2_dc_cam_hit_c6[16] + sctag2_dc_cam_hit_c6[17] +
                                                        sctag2_dc_cam_hit_c6[18] + sctag2_dc_cam_hit_c6[19];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble4_sum  = sctag2_ic_cam_hit_c6[16] + sctag2_ic_cam_hit_c6[17] +
                                                        sctag2_ic_cam_hit_c6[18] + sctag2_ic_cam_hit_c6[19];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble4_sum= sctag2_dc_cam_hit_c6[16] + sctag2_dc_cam_hit_c6[17] +
                                                        sctag2_dc_cam_hit_c6[18] + sctag2_dc_cam_hit_c6[19] +
                                                        sctag2_ic_cam_hit_c6[16] + sctag2_ic_cam_hit_c6[17] +
                                                        sctag2_ic_cam_hit_c6[18] + sctag2_ic_cam_hit_c6[19];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble5_sum  = sctag2_dc_cam_hit_c6[20] + sctag2_dc_cam_hit_c6[21] +
                                                        sctag2_dc_cam_hit_c6[22] + sctag2_dc_cam_hit_c6[23];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble5_sum  = sctag2_ic_cam_hit_c6[20] + sctag2_ic_cam_hit_c6[21] +
                                                        sctag2_ic_cam_hit_c6[22] + sctag2_ic_cam_hit_c6[23];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble5_sum= sctag2_dc_cam_hit_c6[20] + sctag2_dc_cam_hit_c6[21] +
                                                        sctag2_dc_cam_hit_c6[22] + sctag2_dc_cam_hit_c6[23] +
                                                        sctag2_ic_cam_hit_c6[20] + sctag2_ic_cam_hit_c6[21] +
                                                        sctag2_ic_cam_hit_c6[22] + sctag2_ic_cam_hit_c6[23];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble6_sum  = sctag2_dc_cam_hit_c6[24] + sctag2_dc_cam_hit_c6[25] +
                                                        sctag2_dc_cam_hit_c6[26] + sctag2_dc_cam_hit_c6[27];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble6_sum  = sctag2_ic_cam_hit_c6[24] + sctag2_ic_cam_hit_c6[25] +
                                                        sctag2_ic_cam_hit_c6[26] + sctag2_ic_cam_hit_c6[27];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble6_sum= sctag2_dc_cam_hit_c6[24] + sctag2_dc_cam_hit_c6[25] +
                                                        sctag2_dc_cam_hit_c6[26] + sctag2_dc_cam_hit_c6[27] +
                                                        sctag2_ic_cam_hit_c6[24] + sctag2_ic_cam_hit_c6[25] +
                                                        sctag2_ic_cam_hit_c6[26] + sctag2_ic_cam_hit_c6[27];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble7_sum  = sctag2_dc_cam_hit_c6[28] + sctag2_dc_cam_hit_c6[29] +
                                                        sctag2_dc_cam_hit_c6[30] + sctag2_dc_cam_hit_c6[31];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble7_sum  = sctag2_ic_cam_hit_c6[28] + sctag2_ic_cam_hit_c6[29] +
                                                        sctag2_ic_cam_hit_c6[30] + sctag2_ic_cam_hit_c6[31];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble7_sum= sctag2_dc_cam_hit_c6[28] + sctag2_dc_cam_hit_c6[29] +
                                                        sctag2_dc_cam_hit_c6[30] + sctag2_dc_cam_hit_c6[31] +
                                                        sctag2_ic_cam_hit_c6[28] + sctag2_ic_cam_hit_c6[29] +
                                                        sctag2_ic_cam_hit_c6[30] + sctag2_ic_cam_hit_c6[31];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble8_sum  = sctag2_dc_cam_hit_c6[32] + sctag2_dc_cam_hit_c6[33] +
                                                        sctag2_dc_cam_hit_c6[34] + sctag2_dc_cam_hit_c6[35];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble8_sum  = sctag2_ic_cam_hit_c6[32] + sctag2_ic_cam_hit_c6[33] +
                                                        sctag2_ic_cam_hit_c6[34] + sctag2_ic_cam_hit_c6[35];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble8_sum= sctag2_dc_cam_hit_c6[32] + sctag2_dc_cam_hit_c6[33] +
                                                        sctag2_dc_cam_hit_c6[34] + sctag2_dc_cam_hit_c6[35] +
                                                        sctag2_ic_cam_hit_c6[32] + sctag2_ic_cam_hit_c6[33] +
                                                        sctag2_ic_cam_hit_c6[34] + sctag2_ic_cam_hit_c6[35];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble9_sum  = sctag2_dc_cam_hit_c6[36] + sctag2_dc_cam_hit_c6[37] +
                                                        sctag2_dc_cam_hit_c6[38] + sctag2_dc_cam_hit_c6[39];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble9_sum  = sctag2_ic_cam_hit_c6[36] + sctag2_ic_cam_hit_c6[37] +
                                                        sctag2_ic_cam_hit_c6[38] + sctag2_ic_cam_hit_c6[39];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble9_sum= sctag2_dc_cam_hit_c6[36] + sctag2_dc_cam_hit_c6[37] +
                                                        sctag2_dc_cam_hit_c6[38] + sctag2_dc_cam_hit_c6[39] +
                                                        sctag2_ic_cam_hit_c6[36] + sctag2_ic_cam_hit_c6[37] +
                                                        sctag2_ic_cam_hit_c6[38] + sctag2_ic_cam_hit_c6[39];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble10_sum  = sctag2_dc_cam_hit_c6[40] + sctag2_dc_cam_hit_c6[41] +
                                                        sctag2_dc_cam_hit_c6[42] + sctag2_dc_cam_hit_c6[43];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble10_sum  = sctag2_ic_cam_hit_c6[40] + sctag2_ic_cam_hit_c6[41] +
                                                        sctag2_ic_cam_hit_c6[42] + sctag2_ic_cam_hit_c6[43];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble10_sum= sctag2_dc_cam_hit_c6[40] + sctag2_dc_cam_hit_c6[41] +
                                                        sctag2_dc_cam_hit_c6[42] + sctag2_dc_cam_hit_c6[43] +
                                                        sctag2_ic_cam_hit_c6[40] + sctag2_ic_cam_hit_c6[41] +
                                                        sctag2_ic_cam_hit_c6[42] + sctag2_ic_cam_hit_c6[43];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble11_sum  = sctag2_dc_cam_hit_c6[44] + sctag2_dc_cam_hit_c6[45] +
                                                        sctag2_dc_cam_hit_c6[46] + sctag2_dc_cam_hit_c6[47];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble11_sum  = sctag2_ic_cam_hit_c6[44] + sctag2_ic_cam_hit_c6[45] +
                                                        sctag2_ic_cam_hit_c6[46] + sctag2_ic_cam_hit_c6[47];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble11_sum= sctag2_dc_cam_hit_c6[44] + sctag2_dc_cam_hit_c6[45] +
                                                        sctag2_dc_cam_hit_c6[46] + sctag2_dc_cam_hit_c6[47] +
                                                        sctag2_ic_cam_hit_c6[44] + sctag2_ic_cam_hit_c6[45] +
                                                        sctag2_ic_cam_hit_c6[46] + sctag2_ic_cam_hit_c6[47];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble12_sum  = sctag2_dc_cam_hit_c6[48] + sctag2_dc_cam_hit_c6[49] +
                                                        sctag2_dc_cam_hit_c6[50] + sctag2_dc_cam_hit_c6[51];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble12_sum  = sctag2_ic_cam_hit_c6[48] + sctag2_ic_cam_hit_c6[49] +
                                                        sctag2_ic_cam_hit_c6[50] + sctag2_ic_cam_hit_c6[51];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble12_sum= sctag2_dc_cam_hit_c6[48] + sctag2_dc_cam_hit_c6[49] +
                                                        sctag2_dc_cam_hit_c6[50] + sctag2_dc_cam_hit_c6[51] +
                                                        sctag2_ic_cam_hit_c6[48] + sctag2_ic_cam_hit_c6[49] +
                                                        sctag2_ic_cam_hit_c6[50] + sctag2_ic_cam_hit_c6[51];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble13_sum  = sctag2_dc_cam_hit_c6[52] + sctag2_dc_cam_hit_c6[53] +
                                                        sctag2_dc_cam_hit_c6[54] + sctag2_dc_cam_hit_c6[55];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble13_sum  = sctag2_ic_cam_hit_c6[52] + sctag2_ic_cam_hit_c6[53] +
                                                        sctag2_ic_cam_hit_c6[54] + sctag2_ic_cam_hit_c6[55];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble13_sum= sctag2_dc_cam_hit_c6[52] + sctag2_dc_cam_hit_c6[53] +
                                                        sctag2_dc_cam_hit_c6[54] + sctag2_dc_cam_hit_c6[55] +
                                                        sctag2_ic_cam_hit_c6[52] + sctag2_ic_cam_hit_c6[53] +
                                                        sctag2_ic_cam_hit_c6[54] + sctag2_ic_cam_hit_c6[55];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble14_sum  = sctag2_dc_cam_hit_c6[56] + sctag2_dc_cam_hit_c6[57] +
                                                        sctag2_dc_cam_hit_c6[58] + sctag2_dc_cam_hit_c6[59];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble14_sum  = sctag2_ic_cam_hit_c6[56] + sctag2_ic_cam_hit_c6[57] +
                                                        sctag2_ic_cam_hit_c6[58] + sctag2_ic_cam_hit_c6[59];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble14_sum= sctag2_dc_cam_hit_c6[56] + sctag2_dc_cam_hit_c6[57] +
                                                        sctag2_dc_cam_hit_c6[58] + sctag2_dc_cam_hit_c6[59] +
                                                        sctag2_ic_cam_hit_c6[56] + sctag2_ic_cam_hit_c6[57] +
                                                        sctag2_ic_cam_hit_c6[58] + sctag2_ic_cam_hit_c6[59];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble15_sum  = sctag2_dc_cam_hit_c6[60] + sctag2_dc_cam_hit_c6[61] +
                                                        sctag2_dc_cam_hit_c6[62] + sctag2_dc_cam_hit_c6[63];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble15_sum  = sctag2_ic_cam_hit_c6[60] + sctag2_ic_cam_hit_c6[61] +
                                                        sctag2_ic_cam_hit_c6[62] + sctag2_ic_cam_hit_c6[63];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble15_sum= sctag2_dc_cam_hit_c6[60] + sctag2_dc_cam_hit_c6[61] +
                                                        sctag2_dc_cam_hit_c6[62] + sctag2_dc_cam_hit_c6[63] +
                                                        sctag2_ic_cam_hit_c6[60] + sctag2_ic_cam_hit_c6[61] +
                                                        sctag2_ic_cam_hit_c6[62] + sctag2_ic_cam_hit_c6[63];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble16_sum  = sctag2_dc_cam_hit_c6[64] + sctag2_dc_cam_hit_c6[65] +
                                                        sctag2_dc_cam_hit_c6[66] + sctag2_dc_cam_hit_c6[67];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble16_sum  = sctag2_ic_cam_hit_c6[64] + sctag2_ic_cam_hit_c6[65] +
                                                        sctag2_ic_cam_hit_c6[66] + sctag2_ic_cam_hit_c6[67];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble16_sum= sctag2_dc_cam_hit_c6[64] + sctag2_dc_cam_hit_c6[65] +
                                                        sctag2_dc_cam_hit_c6[66] + sctag2_dc_cam_hit_c6[67] +
                                                        sctag2_ic_cam_hit_c6[64] + sctag2_ic_cam_hit_c6[65] +
                                                        sctag2_ic_cam_hit_c6[66] + sctag2_ic_cam_hit_c6[67];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble17_sum  = sctag2_dc_cam_hit_c6[68] + sctag2_dc_cam_hit_c6[69] +
                                                        sctag2_dc_cam_hit_c6[70] + sctag2_dc_cam_hit_c6[71];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble17_sum  = sctag2_ic_cam_hit_c6[68] + sctag2_ic_cam_hit_c6[69] +
                                                        sctag2_ic_cam_hit_c6[70] + sctag2_ic_cam_hit_c6[71];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble17_sum= sctag2_dc_cam_hit_c6[68] + sctag2_dc_cam_hit_c6[69] +
                                                        sctag2_dc_cam_hit_c6[70] + sctag2_dc_cam_hit_c6[71] +
                                                        sctag2_ic_cam_hit_c6[68] + sctag2_ic_cam_hit_c6[69] +
                                                        sctag2_ic_cam_hit_c6[70] + sctag2_ic_cam_hit_c6[71];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble18_sum  = sctag2_dc_cam_hit_c6[72] + sctag2_dc_cam_hit_c6[73] +
                                                        sctag2_dc_cam_hit_c6[74] + sctag2_dc_cam_hit_c6[75];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble18_sum  = sctag2_ic_cam_hit_c6[72] + sctag2_ic_cam_hit_c6[73] +
                                                        sctag2_ic_cam_hit_c6[74] + sctag2_ic_cam_hit_c6[75];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble18_sum= sctag2_dc_cam_hit_c6[72] + sctag2_dc_cam_hit_c6[73] +
                                                        sctag2_dc_cam_hit_c6[74] + sctag2_dc_cam_hit_c6[75] +
                                                        sctag2_ic_cam_hit_c6[72] + sctag2_ic_cam_hit_c6[73] +
                                                        sctag2_ic_cam_hit_c6[74] + sctag2_ic_cam_hit_c6[75];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble19_sum  = sctag2_dc_cam_hit_c6[76] + sctag2_dc_cam_hit_c6[77] +
                                                        sctag2_dc_cam_hit_c6[78] + sctag2_dc_cam_hit_c6[79];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble19_sum  = sctag2_ic_cam_hit_c6[76] + sctag2_ic_cam_hit_c6[77] +
                                                        sctag2_ic_cam_hit_c6[78] + sctag2_ic_cam_hit_c6[79];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble19_sum= sctag2_dc_cam_hit_c6[76] + sctag2_dc_cam_hit_c6[77] +
                                                        sctag2_dc_cam_hit_c6[78] + sctag2_dc_cam_hit_c6[79] +
                                                        sctag2_ic_cam_hit_c6[76] + sctag2_ic_cam_hit_c6[77] +
                                                        sctag2_ic_cam_hit_c6[78] + sctag2_ic_cam_hit_c6[79];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble20_sum  = sctag2_dc_cam_hit_c6[80] + sctag2_dc_cam_hit_c6[81] +
                                                        sctag2_dc_cam_hit_c6[82] + sctag2_dc_cam_hit_c6[83];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble20_sum  = sctag2_ic_cam_hit_c6[80] + sctag2_ic_cam_hit_c6[81] +
                                                        sctag2_ic_cam_hit_c6[82] + sctag2_ic_cam_hit_c6[83];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble20_sum= sctag2_dc_cam_hit_c6[80] + sctag2_dc_cam_hit_c6[81] +
                                                        sctag2_dc_cam_hit_c6[82] + sctag2_dc_cam_hit_c6[83] +
                                                        sctag2_ic_cam_hit_c6[80] + sctag2_ic_cam_hit_c6[81] +
                                                        sctag2_ic_cam_hit_c6[82] + sctag2_ic_cam_hit_c6[83];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble21_sum  = sctag2_dc_cam_hit_c6[84] + sctag2_dc_cam_hit_c6[85] +
                                                        sctag2_dc_cam_hit_c6[86] + sctag2_dc_cam_hit_c6[87];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble21_sum  = sctag2_ic_cam_hit_c6[84] + sctag2_ic_cam_hit_c6[85] +
                                                        sctag2_ic_cam_hit_c6[86] + sctag2_ic_cam_hit_c6[87];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble21_sum= sctag2_dc_cam_hit_c6[84] + sctag2_dc_cam_hit_c6[85] +
                                                        sctag2_dc_cam_hit_c6[86] + sctag2_dc_cam_hit_c6[87] +
                                                        sctag2_ic_cam_hit_c6[84] + sctag2_ic_cam_hit_c6[85] +
                                                        sctag2_ic_cam_hit_c6[86] + sctag2_ic_cam_hit_c6[87];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble22_sum  = sctag2_dc_cam_hit_c6[88] + sctag2_dc_cam_hit_c6[89] +
                                                        sctag2_dc_cam_hit_c6[90] + sctag2_dc_cam_hit_c6[91];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble22_sum  = sctag2_ic_cam_hit_c6[88] + sctag2_ic_cam_hit_c6[89] +
                                                        sctag2_ic_cam_hit_c6[90] + sctag2_ic_cam_hit_c6[91];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble22_sum= sctag2_dc_cam_hit_c6[88] + sctag2_dc_cam_hit_c6[89] +
                                                        sctag2_dc_cam_hit_c6[90] + sctag2_dc_cam_hit_c6[91] +
                                                        sctag2_ic_cam_hit_c6[88] + sctag2_ic_cam_hit_c6[89] +
                                                        sctag2_ic_cam_hit_c6[90] + sctag2_ic_cam_hit_c6[91];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble23_sum  = sctag2_dc_cam_hit_c6[92] + sctag2_dc_cam_hit_c6[93] +
                                                        sctag2_dc_cam_hit_c6[94] + sctag2_dc_cam_hit_c6[95];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble23_sum  = sctag2_ic_cam_hit_c6[92] + sctag2_ic_cam_hit_c6[93] +
                                                        sctag2_ic_cam_hit_c6[94] + sctag2_ic_cam_hit_c6[95];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble23_sum= sctag2_dc_cam_hit_c6[92] + sctag2_dc_cam_hit_c6[93] +
                                                        sctag2_dc_cam_hit_c6[94] + sctag2_dc_cam_hit_c6[95] +
                                                        sctag2_ic_cam_hit_c6[92] + sctag2_ic_cam_hit_c6[93] +
                                                        sctag2_ic_cam_hit_c6[94] + sctag2_ic_cam_hit_c6[95];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble24_sum  = sctag2_dc_cam_hit_c6[96] + sctag2_dc_cam_hit_c6[97] +
                                                        sctag2_dc_cam_hit_c6[98] + sctag2_dc_cam_hit_c6[99];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble24_sum  = sctag2_ic_cam_hit_c6[96] + sctag2_ic_cam_hit_c6[97] +
                                                        sctag2_ic_cam_hit_c6[98] + sctag2_ic_cam_hit_c6[99];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble24_sum= sctag2_dc_cam_hit_c6[96] + sctag2_dc_cam_hit_c6[97] +
                                                        sctag2_dc_cam_hit_c6[98] + sctag2_dc_cam_hit_c6[99] +
                                                        sctag2_ic_cam_hit_c6[96] + sctag2_ic_cam_hit_c6[97] +
                                                        sctag2_ic_cam_hit_c6[98] + sctag2_ic_cam_hit_c6[99];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble25_sum  = sctag2_dc_cam_hit_c6[100] + sctag2_dc_cam_hit_c6[101] +
                                                        sctag2_dc_cam_hit_c6[102] + sctag2_dc_cam_hit_c6[103];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble25_sum  = sctag2_ic_cam_hit_c6[100] + sctag2_ic_cam_hit_c6[101] +
                                                        sctag2_ic_cam_hit_c6[102] + sctag2_ic_cam_hit_c6[103];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble25_sum= sctag2_dc_cam_hit_c6[100] + sctag2_dc_cam_hit_c6[101] +
                                                        sctag2_dc_cam_hit_c6[102] + sctag2_dc_cam_hit_c6[103] +
                                                        sctag2_ic_cam_hit_c6[100] + sctag2_ic_cam_hit_c6[101] +
                                                        sctag2_ic_cam_hit_c6[102] + sctag2_ic_cam_hit_c6[103];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble26_sum  = sctag2_dc_cam_hit_c6[104] + sctag2_dc_cam_hit_c6[105] +
                                                        sctag2_dc_cam_hit_c6[106] + sctag2_dc_cam_hit_c6[107];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble26_sum  = sctag2_ic_cam_hit_c6[104] + sctag2_ic_cam_hit_c6[105] +
                                                        sctag2_ic_cam_hit_c6[106] + sctag2_ic_cam_hit_c6[107];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble26_sum= sctag2_dc_cam_hit_c6[104] + sctag2_dc_cam_hit_c6[105] +
                                                        sctag2_dc_cam_hit_c6[106] + sctag2_dc_cam_hit_c6[107] +
                                                        sctag2_ic_cam_hit_c6[104] + sctag2_ic_cam_hit_c6[105] +
                                                        sctag2_ic_cam_hit_c6[106] + sctag2_ic_cam_hit_c6[107];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble27_sum  = sctag2_dc_cam_hit_c6[108] + sctag2_dc_cam_hit_c6[109] +
                                                        sctag2_dc_cam_hit_c6[110] + sctag2_dc_cam_hit_c6[111];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble27_sum  = sctag2_ic_cam_hit_c6[108] + sctag2_ic_cam_hit_c6[109] +
                                                        sctag2_ic_cam_hit_c6[110] + sctag2_ic_cam_hit_c6[111];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble27_sum= sctag2_dc_cam_hit_c6[108] + sctag2_dc_cam_hit_c6[109] +
                                                        sctag2_dc_cam_hit_c6[110] + sctag2_dc_cam_hit_c6[111] +
                                                        sctag2_ic_cam_hit_c6[108] + sctag2_ic_cam_hit_c6[109] +
                                                        sctag2_ic_cam_hit_c6[110] + sctag2_ic_cam_hit_c6[111];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble28_sum  = sctag2_dc_cam_hit_c6[112] + sctag2_dc_cam_hit_c6[113] +
                                                        sctag2_dc_cam_hit_c6[114] + sctag2_dc_cam_hit_c6[115];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble28_sum  = sctag2_ic_cam_hit_c6[112] + sctag2_ic_cam_hit_c6[113] +
                                                        sctag2_ic_cam_hit_c6[114] + sctag2_ic_cam_hit_c6[115];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble28_sum= sctag2_dc_cam_hit_c6[112] + sctag2_dc_cam_hit_c6[113] +
                                                        sctag2_dc_cam_hit_c6[114] + sctag2_dc_cam_hit_c6[115] +
                                                        sctag2_ic_cam_hit_c6[112] + sctag2_ic_cam_hit_c6[113] +
                                                        sctag2_ic_cam_hit_c6[114] + sctag2_ic_cam_hit_c6[115];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble29_sum  = sctag2_dc_cam_hit_c6[116] + sctag2_dc_cam_hit_c6[117] +
                                                        sctag2_dc_cam_hit_c6[118] + sctag2_dc_cam_hit_c6[119];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble29_sum  = sctag2_ic_cam_hit_c6[116] + sctag2_ic_cam_hit_c6[117] +
                                                        sctag2_ic_cam_hit_c6[118] + sctag2_ic_cam_hit_c6[119];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble29_sum= sctag2_dc_cam_hit_c6[116] + sctag2_dc_cam_hit_c6[117] +
                                                        sctag2_dc_cam_hit_c6[118] + sctag2_dc_cam_hit_c6[119] +
                                                        sctag2_ic_cam_hit_c6[116] + sctag2_ic_cam_hit_c6[117] +
                                                        sctag2_ic_cam_hit_c6[118] + sctag2_ic_cam_hit_c6[119];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble30_sum  = sctag2_dc_cam_hit_c6[120] + sctag2_dc_cam_hit_c6[121] +
                                                        sctag2_dc_cam_hit_c6[122] + sctag2_dc_cam_hit_c6[123];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble30_sum  = sctag2_ic_cam_hit_c6[120] + sctag2_ic_cam_hit_c6[121] +
                                                        sctag2_ic_cam_hit_c6[122] + sctag2_ic_cam_hit_c6[123];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble30_sum= sctag2_dc_cam_hit_c6[120] + sctag2_dc_cam_hit_c6[121] +
                                                        sctag2_dc_cam_hit_c6[122] + sctag2_dc_cam_hit_c6[123] +
                                                        sctag2_ic_cam_hit_c6[120] + sctag2_ic_cam_hit_c6[121] +
                                                        sctag2_ic_cam_hit_c6[122] + sctag2_ic_cam_hit_c6[123];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag2_dc_cam_hit_c6_nibble31_sum  = sctag2_dc_cam_hit_c6[124] + sctag2_dc_cam_hit_c6[125] +
                                                        sctag2_dc_cam_hit_c6[126] + sctag2_dc_cam_hit_c6[127];

   wire [2:0] sctag2_ic_cam_hit_c6_nibble31_sum  = sctag2_ic_cam_hit_c6[124] + sctag2_ic_cam_hit_c6[125] +
                                                        sctag2_ic_cam_hit_c6[126] + sctag2_ic_cam_hit_c6[127];
   
   wire [3:0] sctag2_both_cam_hit_c6_nibble31_sum= sctag2_dc_cam_hit_c6[124] + sctag2_dc_cam_hit_c6[125] +
                                                        sctag2_dc_cam_hit_c6[126] + sctag2_dc_cam_hit_c6[127] +
                                                        sctag2_ic_cam_hit_c6[124] + sctag2_ic_cam_hit_c6[125] +
                                                        sctag2_ic_cam_hit_c6[126] + sctag2_ic_cam_hit_c6[127];

   wire [7:0]            sctag3_cpx_req_cq	= `TOP_MEMORY.sctag3_cpx_req_cq[7:0]; 
   wire [7:0]            sctag3_cpx_atom_cq 	= `TOP_MEMORY.sctag3_cpx_atom_cq; 
   wire [`CPX_WIDTH-1:0] sctag3_cpx_data_ca 	= `TOP_MEMORY.sctag3_cpx_data_ca[`CPX_WIDTH-1:0]; 

   wire 		 sctag3_pcx_stall_pq = `TOP_MEMORY.sctag3_pcx_stall_pq;
   reg [7:0] 		 sctag3_cpx_req_cq_d1;	// delayed by 1
   reg [7:0] 		 sctag3_cpx_req_cq_d2;	// delayed by 2
   reg [7:0] 		 sctag3_cpx_atom_cq_d1;	// delayed by 1
   reg [7:0] 		 sctag3_cpx_atom_cq_d2;	// delayed by 2
   reg [127:0] 		 sctag3_cpx_type_str;	// in string format
   reg [3:0]   		 sctag3_cpx_type;		// packet type

   reg  sctag3_dc_lkup_c5;
   reg  sctag3_ic_lkup_c5;
   reg  sctag3_dc_lkup_c6;
   reg  sctag3_ic_lkup_c6;

   wire [3:0] sctag3_dc_lkup_panel_dec_c4 	= `TOP_MEMORY.sctag3.dirrep.dc_lkup_panel_dec_c4[3:0]; 
   wire [3:0] sctag3_dc_lkup_row_dec_c4 	= `TOP_MEMORY.sctag3.dirrep.dc_lkup_row_dec_c4[3:0]; 

   wire [3:0] sctag3_ic_lkup_panel_dec_c4 	= `TOP_MEMORY.sctag3.dirrep.ic_lkup_panel_dec_c4[3:0]; 
   wire [3:0] sctag3_ic_lkup_row_dec_c4 	= `TOP_MEMORY.sctag3.dirrep.ic_lkup_row_dec_c4[3:0]; 

   wire [127:0] sctag3_dc_cam_hit_c6		= `TOP_MEMORY.sctag3.dirvec_dp.dc_cam_hit_c6[127:0]; 
   wire [127:0] sctag3_ic_cam_hit_c6		= `TOP_MEMORY.sctag3.dirvec_dp.ic_cam_hit_c6[127:0]; 


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble0_sum  = sctag3_dc_cam_hit_c6[0] + sctag3_dc_cam_hit_c6[1] +
                                                        sctag3_dc_cam_hit_c6[2] + sctag3_dc_cam_hit_c6[3];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble0_sum  = sctag3_ic_cam_hit_c6[0] + sctag3_ic_cam_hit_c6[1] +
                                                        sctag3_ic_cam_hit_c6[2] + sctag3_ic_cam_hit_c6[3];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble0_sum= sctag3_dc_cam_hit_c6[0] + sctag3_dc_cam_hit_c6[1] +
                                                        sctag3_dc_cam_hit_c6[2] + sctag3_dc_cam_hit_c6[3] +
                                                        sctag3_ic_cam_hit_c6[0] + sctag3_ic_cam_hit_c6[1] +
                                                        sctag3_ic_cam_hit_c6[2] + sctag3_ic_cam_hit_c6[3];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble1_sum  = sctag3_dc_cam_hit_c6[4] + sctag3_dc_cam_hit_c6[5] +
                                                        sctag3_dc_cam_hit_c6[6] + sctag3_dc_cam_hit_c6[7];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble1_sum  = sctag3_ic_cam_hit_c6[4] + sctag3_ic_cam_hit_c6[5] +
                                                        sctag3_ic_cam_hit_c6[6] + sctag3_ic_cam_hit_c6[7];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble1_sum= sctag3_dc_cam_hit_c6[4] + sctag3_dc_cam_hit_c6[5] +
                                                        sctag3_dc_cam_hit_c6[6] + sctag3_dc_cam_hit_c6[7] +
                                                        sctag3_ic_cam_hit_c6[4] + sctag3_ic_cam_hit_c6[5] +
                                                        sctag3_ic_cam_hit_c6[6] + sctag3_ic_cam_hit_c6[7];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble2_sum  = sctag3_dc_cam_hit_c6[8] + sctag3_dc_cam_hit_c6[9] +
                                                        sctag3_dc_cam_hit_c6[10] + sctag3_dc_cam_hit_c6[11];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble2_sum  = sctag3_ic_cam_hit_c6[8] + sctag3_ic_cam_hit_c6[9] +
                                                        sctag3_ic_cam_hit_c6[10] + sctag3_ic_cam_hit_c6[11];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble2_sum= sctag3_dc_cam_hit_c6[8] + sctag3_dc_cam_hit_c6[9] +
                                                        sctag3_dc_cam_hit_c6[10] + sctag3_dc_cam_hit_c6[11] +
                                                        sctag3_ic_cam_hit_c6[8] + sctag3_ic_cam_hit_c6[9] +
                                                        sctag3_ic_cam_hit_c6[10] + sctag3_ic_cam_hit_c6[11];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble3_sum  = sctag3_dc_cam_hit_c6[12] + sctag3_dc_cam_hit_c6[13] +
                                                        sctag3_dc_cam_hit_c6[14] + sctag3_dc_cam_hit_c6[15];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble3_sum  = sctag3_ic_cam_hit_c6[12] + sctag3_ic_cam_hit_c6[13] +
                                                        sctag3_ic_cam_hit_c6[14] + sctag3_ic_cam_hit_c6[15];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble3_sum= sctag3_dc_cam_hit_c6[12] + sctag3_dc_cam_hit_c6[13] +
                                                        sctag3_dc_cam_hit_c6[14] + sctag3_dc_cam_hit_c6[15] +
                                                        sctag3_ic_cam_hit_c6[12] + sctag3_ic_cam_hit_c6[13] +
                                                        sctag3_ic_cam_hit_c6[14] + sctag3_ic_cam_hit_c6[15];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble4_sum  = sctag3_dc_cam_hit_c6[16] + sctag3_dc_cam_hit_c6[17] +
                                                        sctag3_dc_cam_hit_c6[18] + sctag3_dc_cam_hit_c6[19];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble4_sum  = sctag3_ic_cam_hit_c6[16] + sctag3_ic_cam_hit_c6[17] +
                                                        sctag3_ic_cam_hit_c6[18] + sctag3_ic_cam_hit_c6[19];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble4_sum= sctag3_dc_cam_hit_c6[16] + sctag3_dc_cam_hit_c6[17] +
                                                        sctag3_dc_cam_hit_c6[18] + sctag3_dc_cam_hit_c6[19] +
                                                        sctag3_ic_cam_hit_c6[16] + sctag3_ic_cam_hit_c6[17] +
                                                        sctag3_ic_cam_hit_c6[18] + sctag3_ic_cam_hit_c6[19];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble5_sum  = sctag3_dc_cam_hit_c6[20] + sctag3_dc_cam_hit_c6[21] +
                                                        sctag3_dc_cam_hit_c6[22] + sctag3_dc_cam_hit_c6[23];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble5_sum  = sctag3_ic_cam_hit_c6[20] + sctag3_ic_cam_hit_c6[21] +
                                                        sctag3_ic_cam_hit_c6[22] + sctag3_ic_cam_hit_c6[23];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble5_sum= sctag3_dc_cam_hit_c6[20] + sctag3_dc_cam_hit_c6[21] +
                                                        sctag3_dc_cam_hit_c6[22] + sctag3_dc_cam_hit_c6[23] +
                                                        sctag3_ic_cam_hit_c6[20] + sctag3_ic_cam_hit_c6[21] +
                                                        sctag3_ic_cam_hit_c6[22] + sctag3_ic_cam_hit_c6[23];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble6_sum  = sctag3_dc_cam_hit_c6[24] + sctag3_dc_cam_hit_c6[25] +
                                                        sctag3_dc_cam_hit_c6[26] + sctag3_dc_cam_hit_c6[27];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble6_sum  = sctag3_ic_cam_hit_c6[24] + sctag3_ic_cam_hit_c6[25] +
                                                        sctag3_ic_cam_hit_c6[26] + sctag3_ic_cam_hit_c6[27];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble6_sum= sctag3_dc_cam_hit_c6[24] + sctag3_dc_cam_hit_c6[25] +
                                                        sctag3_dc_cam_hit_c6[26] + sctag3_dc_cam_hit_c6[27] +
                                                        sctag3_ic_cam_hit_c6[24] + sctag3_ic_cam_hit_c6[25] +
                                                        sctag3_ic_cam_hit_c6[26] + sctag3_ic_cam_hit_c6[27];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble7_sum  = sctag3_dc_cam_hit_c6[28] + sctag3_dc_cam_hit_c6[29] +
                                                        sctag3_dc_cam_hit_c6[30] + sctag3_dc_cam_hit_c6[31];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble7_sum  = sctag3_ic_cam_hit_c6[28] + sctag3_ic_cam_hit_c6[29] +
                                                        sctag3_ic_cam_hit_c6[30] + sctag3_ic_cam_hit_c6[31];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble7_sum= sctag3_dc_cam_hit_c6[28] + sctag3_dc_cam_hit_c6[29] +
                                                        sctag3_dc_cam_hit_c6[30] + sctag3_dc_cam_hit_c6[31] +
                                                        sctag3_ic_cam_hit_c6[28] + sctag3_ic_cam_hit_c6[29] +
                                                        sctag3_ic_cam_hit_c6[30] + sctag3_ic_cam_hit_c6[31];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble8_sum  = sctag3_dc_cam_hit_c6[32] + sctag3_dc_cam_hit_c6[33] +
                                                        sctag3_dc_cam_hit_c6[34] + sctag3_dc_cam_hit_c6[35];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble8_sum  = sctag3_ic_cam_hit_c6[32] + sctag3_ic_cam_hit_c6[33] +
                                                        sctag3_ic_cam_hit_c6[34] + sctag3_ic_cam_hit_c6[35];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble8_sum= sctag3_dc_cam_hit_c6[32] + sctag3_dc_cam_hit_c6[33] +
                                                        sctag3_dc_cam_hit_c6[34] + sctag3_dc_cam_hit_c6[35] +
                                                        sctag3_ic_cam_hit_c6[32] + sctag3_ic_cam_hit_c6[33] +
                                                        sctag3_ic_cam_hit_c6[34] + sctag3_ic_cam_hit_c6[35];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble9_sum  = sctag3_dc_cam_hit_c6[36] + sctag3_dc_cam_hit_c6[37] +
                                                        sctag3_dc_cam_hit_c6[38] + sctag3_dc_cam_hit_c6[39];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble9_sum  = sctag3_ic_cam_hit_c6[36] + sctag3_ic_cam_hit_c6[37] +
                                                        sctag3_ic_cam_hit_c6[38] + sctag3_ic_cam_hit_c6[39];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble9_sum= sctag3_dc_cam_hit_c6[36] + sctag3_dc_cam_hit_c6[37] +
                                                        sctag3_dc_cam_hit_c6[38] + sctag3_dc_cam_hit_c6[39] +
                                                        sctag3_ic_cam_hit_c6[36] + sctag3_ic_cam_hit_c6[37] +
                                                        sctag3_ic_cam_hit_c6[38] + sctag3_ic_cam_hit_c6[39];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble10_sum  = sctag3_dc_cam_hit_c6[40] + sctag3_dc_cam_hit_c6[41] +
                                                        sctag3_dc_cam_hit_c6[42] + sctag3_dc_cam_hit_c6[43];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble10_sum  = sctag3_ic_cam_hit_c6[40] + sctag3_ic_cam_hit_c6[41] +
                                                        sctag3_ic_cam_hit_c6[42] + sctag3_ic_cam_hit_c6[43];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble10_sum= sctag3_dc_cam_hit_c6[40] + sctag3_dc_cam_hit_c6[41] +
                                                        sctag3_dc_cam_hit_c6[42] + sctag3_dc_cam_hit_c6[43] +
                                                        sctag3_ic_cam_hit_c6[40] + sctag3_ic_cam_hit_c6[41] +
                                                        sctag3_ic_cam_hit_c6[42] + sctag3_ic_cam_hit_c6[43];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble11_sum  = sctag3_dc_cam_hit_c6[44] + sctag3_dc_cam_hit_c6[45] +
                                                        sctag3_dc_cam_hit_c6[46] + sctag3_dc_cam_hit_c6[47];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble11_sum  = sctag3_ic_cam_hit_c6[44] + sctag3_ic_cam_hit_c6[45] +
                                                        sctag3_ic_cam_hit_c6[46] + sctag3_ic_cam_hit_c6[47];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble11_sum= sctag3_dc_cam_hit_c6[44] + sctag3_dc_cam_hit_c6[45] +
                                                        sctag3_dc_cam_hit_c6[46] + sctag3_dc_cam_hit_c6[47] +
                                                        sctag3_ic_cam_hit_c6[44] + sctag3_ic_cam_hit_c6[45] +
                                                        sctag3_ic_cam_hit_c6[46] + sctag3_ic_cam_hit_c6[47];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble12_sum  = sctag3_dc_cam_hit_c6[48] + sctag3_dc_cam_hit_c6[49] +
                                                        sctag3_dc_cam_hit_c6[50] + sctag3_dc_cam_hit_c6[51];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble12_sum  = sctag3_ic_cam_hit_c6[48] + sctag3_ic_cam_hit_c6[49] +
                                                        sctag3_ic_cam_hit_c6[50] + sctag3_ic_cam_hit_c6[51];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble12_sum= sctag3_dc_cam_hit_c6[48] + sctag3_dc_cam_hit_c6[49] +
                                                        sctag3_dc_cam_hit_c6[50] + sctag3_dc_cam_hit_c6[51] +
                                                        sctag3_ic_cam_hit_c6[48] + sctag3_ic_cam_hit_c6[49] +
                                                        sctag3_ic_cam_hit_c6[50] + sctag3_ic_cam_hit_c6[51];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble13_sum  = sctag3_dc_cam_hit_c6[52] + sctag3_dc_cam_hit_c6[53] +
                                                        sctag3_dc_cam_hit_c6[54] + sctag3_dc_cam_hit_c6[55];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble13_sum  = sctag3_ic_cam_hit_c6[52] + sctag3_ic_cam_hit_c6[53] +
                                                        sctag3_ic_cam_hit_c6[54] + sctag3_ic_cam_hit_c6[55];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble13_sum= sctag3_dc_cam_hit_c6[52] + sctag3_dc_cam_hit_c6[53] +
                                                        sctag3_dc_cam_hit_c6[54] + sctag3_dc_cam_hit_c6[55] +
                                                        sctag3_ic_cam_hit_c6[52] + sctag3_ic_cam_hit_c6[53] +
                                                        sctag3_ic_cam_hit_c6[54] + sctag3_ic_cam_hit_c6[55];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble14_sum  = sctag3_dc_cam_hit_c6[56] + sctag3_dc_cam_hit_c6[57] +
                                                        sctag3_dc_cam_hit_c6[58] + sctag3_dc_cam_hit_c6[59];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble14_sum  = sctag3_ic_cam_hit_c6[56] + sctag3_ic_cam_hit_c6[57] +
                                                        sctag3_ic_cam_hit_c6[58] + sctag3_ic_cam_hit_c6[59];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble14_sum= sctag3_dc_cam_hit_c6[56] + sctag3_dc_cam_hit_c6[57] +
                                                        sctag3_dc_cam_hit_c6[58] + sctag3_dc_cam_hit_c6[59] +
                                                        sctag3_ic_cam_hit_c6[56] + sctag3_ic_cam_hit_c6[57] +
                                                        sctag3_ic_cam_hit_c6[58] + sctag3_ic_cam_hit_c6[59];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble15_sum  = sctag3_dc_cam_hit_c6[60] + sctag3_dc_cam_hit_c6[61] +
                                                        sctag3_dc_cam_hit_c6[62] + sctag3_dc_cam_hit_c6[63];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble15_sum  = sctag3_ic_cam_hit_c6[60] + sctag3_ic_cam_hit_c6[61] +
                                                        sctag3_ic_cam_hit_c6[62] + sctag3_ic_cam_hit_c6[63];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble15_sum= sctag3_dc_cam_hit_c6[60] + sctag3_dc_cam_hit_c6[61] +
                                                        sctag3_dc_cam_hit_c6[62] + sctag3_dc_cam_hit_c6[63] +
                                                        sctag3_ic_cam_hit_c6[60] + sctag3_ic_cam_hit_c6[61] +
                                                        sctag3_ic_cam_hit_c6[62] + sctag3_ic_cam_hit_c6[63];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble16_sum  = sctag3_dc_cam_hit_c6[64] + sctag3_dc_cam_hit_c6[65] +
                                                        sctag3_dc_cam_hit_c6[66] + sctag3_dc_cam_hit_c6[67];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble16_sum  = sctag3_ic_cam_hit_c6[64] + sctag3_ic_cam_hit_c6[65] +
                                                        sctag3_ic_cam_hit_c6[66] + sctag3_ic_cam_hit_c6[67];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble16_sum= sctag3_dc_cam_hit_c6[64] + sctag3_dc_cam_hit_c6[65] +
                                                        sctag3_dc_cam_hit_c6[66] + sctag3_dc_cam_hit_c6[67] +
                                                        sctag3_ic_cam_hit_c6[64] + sctag3_ic_cam_hit_c6[65] +
                                                        sctag3_ic_cam_hit_c6[66] + sctag3_ic_cam_hit_c6[67];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble17_sum  = sctag3_dc_cam_hit_c6[68] + sctag3_dc_cam_hit_c6[69] +
                                                        sctag3_dc_cam_hit_c6[70] + sctag3_dc_cam_hit_c6[71];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble17_sum  = sctag3_ic_cam_hit_c6[68] + sctag3_ic_cam_hit_c6[69] +
                                                        sctag3_ic_cam_hit_c6[70] + sctag3_ic_cam_hit_c6[71];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble17_sum= sctag3_dc_cam_hit_c6[68] + sctag3_dc_cam_hit_c6[69] +
                                                        sctag3_dc_cam_hit_c6[70] + sctag3_dc_cam_hit_c6[71] +
                                                        sctag3_ic_cam_hit_c6[68] + sctag3_ic_cam_hit_c6[69] +
                                                        sctag3_ic_cam_hit_c6[70] + sctag3_ic_cam_hit_c6[71];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble18_sum  = sctag3_dc_cam_hit_c6[72] + sctag3_dc_cam_hit_c6[73] +
                                                        sctag3_dc_cam_hit_c6[74] + sctag3_dc_cam_hit_c6[75];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble18_sum  = sctag3_ic_cam_hit_c6[72] + sctag3_ic_cam_hit_c6[73] +
                                                        sctag3_ic_cam_hit_c6[74] + sctag3_ic_cam_hit_c6[75];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble18_sum= sctag3_dc_cam_hit_c6[72] + sctag3_dc_cam_hit_c6[73] +
                                                        sctag3_dc_cam_hit_c6[74] + sctag3_dc_cam_hit_c6[75] +
                                                        sctag3_ic_cam_hit_c6[72] + sctag3_ic_cam_hit_c6[73] +
                                                        sctag3_ic_cam_hit_c6[74] + sctag3_ic_cam_hit_c6[75];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble19_sum  = sctag3_dc_cam_hit_c6[76] + sctag3_dc_cam_hit_c6[77] +
                                                        sctag3_dc_cam_hit_c6[78] + sctag3_dc_cam_hit_c6[79];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble19_sum  = sctag3_ic_cam_hit_c6[76] + sctag3_ic_cam_hit_c6[77] +
                                                        sctag3_ic_cam_hit_c6[78] + sctag3_ic_cam_hit_c6[79];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble19_sum= sctag3_dc_cam_hit_c6[76] + sctag3_dc_cam_hit_c6[77] +
                                                        sctag3_dc_cam_hit_c6[78] + sctag3_dc_cam_hit_c6[79] +
                                                        sctag3_ic_cam_hit_c6[76] + sctag3_ic_cam_hit_c6[77] +
                                                        sctag3_ic_cam_hit_c6[78] + sctag3_ic_cam_hit_c6[79];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble20_sum  = sctag3_dc_cam_hit_c6[80] + sctag3_dc_cam_hit_c6[81] +
                                                        sctag3_dc_cam_hit_c6[82] + sctag3_dc_cam_hit_c6[83];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble20_sum  = sctag3_ic_cam_hit_c6[80] + sctag3_ic_cam_hit_c6[81] +
                                                        sctag3_ic_cam_hit_c6[82] + sctag3_ic_cam_hit_c6[83];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble20_sum= sctag3_dc_cam_hit_c6[80] + sctag3_dc_cam_hit_c6[81] +
                                                        sctag3_dc_cam_hit_c6[82] + sctag3_dc_cam_hit_c6[83] +
                                                        sctag3_ic_cam_hit_c6[80] + sctag3_ic_cam_hit_c6[81] +
                                                        sctag3_ic_cam_hit_c6[82] + sctag3_ic_cam_hit_c6[83];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble21_sum  = sctag3_dc_cam_hit_c6[84] + sctag3_dc_cam_hit_c6[85] +
                                                        sctag3_dc_cam_hit_c6[86] + sctag3_dc_cam_hit_c6[87];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble21_sum  = sctag3_ic_cam_hit_c6[84] + sctag3_ic_cam_hit_c6[85] +
                                                        sctag3_ic_cam_hit_c6[86] + sctag3_ic_cam_hit_c6[87];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble21_sum= sctag3_dc_cam_hit_c6[84] + sctag3_dc_cam_hit_c6[85] +
                                                        sctag3_dc_cam_hit_c6[86] + sctag3_dc_cam_hit_c6[87] +
                                                        sctag3_ic_cam_hit_c6[84] + sctag3_ic_cam_hit_c6[85] +
                                                        sctag3_ic_cam_hit_c6[86] + sctag3_ic_cam_hit_c6[87];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble22_sum  = sctag3_dc_cam_hit_c6[88] + sctag3_dc_cam_hit_c6[89] +
                                                        sctag3_dc_cam_hit_c6[90] + sctag3_dc_cam_hit_c6[91];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble22_sum  = sctag3_ic_cam_hit_c6[88] + sctag3_ic_cam_hit_c6[89] +
                                                        sctag3_ic_cam_hit_c6[90] + sctag3_ic_cam_hit_c6[91];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble22_sum= sctag3_dc_cam_hit_c6[88] + sctag3_dc_cam_hit_c6[89] +
                                                        sctag3_dc_cam_hit_c6[90] + sctag3_dc_cam_hit_c6[91] +
                                                        sctag3_ic_cam_hit_c6[88] + sctag3_ic_cam_hit_c6[89] +
                                                        sctag3_ic_cam_hit_c6[90] + sctag3_ic_cam_hit_c6[91];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble23_sum  = sctag3_dc_cam_hit_c6[92] + sctag3_dc_cam_hit_c6[93] +
                                                        sctag3_dc_cam_hit_c6[94] + sctag3_dc_cam_hit_c6[95];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble23_sum  = sctag3_ic_cam_hit_c6[92] + sctag3_ic_cam_hit_c6[93] +
                                                        sctag3_ic_cam_hit_c6[94] + sctag3_ic_cam_hit_c6[95];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble23_sum= sctag3_dc_cam_hit_c6[92] + sctag3_dc_cam_hit_c6[93] +
                                                        sctag3_dc_cam_hit_c6[94] + sctag3_dc_cam_hit_c6[95] +
                                                        sctag3_ic_cam_hit_c6[92] + sctag3_ic_cam_hit_c6[93] +
                                                        sctag3_ic_cam_hit_c6[94] + sctag3_ic_cam_hit_c6[95];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble24_sum  = sctag3_dc_cam_hit_c6[96] + sctag3_dc_cam_hit_c6[97] +
                                                        sctag3_dc_cam_hit_c6[98] + sctag3_dc_cam_hit_c6[99];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble24_sum  = sctag3_ic_cam_hit_c6[96] + sctag3_ic_cam_hit_c6[97] +
                                                        sctag3_ic_cam_hit_c6[98] + sctag3_ic_cam_hit_c6[99];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble24_sum= sctag3_dc_cam_hit_c6[96] + sctag3_dc_cam_hit_c6[97] +
                                                        sctag3_dc_cam_hit_c6[98] + sctag3_dc_cam_hit_c6[99] +
                                                        sctag3_ic_cam_hit_c6[96] + sctag3_ic_cam_hit_c6[97] +
                                                        sctag3_ic_cam_hit_c6[98] + sctag3_ic_cam_hit_c6[99];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble25_sum  = sctag3_dc_cam_hit_c6[100] + sctag3_dc_cam_hit_c6[101] +
                                                        sctag3_dc_cam_hit_c6[102] + sctag3_dc_cam_hit_c6[103];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble25_sum  = sctag3_ic_cam_hit_c6[100] + sctag3_ic_cam_hit_c6[101] +
                                                        sctag3_ic_cam_hit_c6[102] + sctag3_ic_cam_hit_c6[103];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble25_sum= sctag3_dc_cam_hit_c6[100] + sctag3_dc_cam_hit_c6[101] +
                                                        sctag3_dc_cam_hit_c6[102] + sctag3_dc_cam_hit_c6[103] +
                                                        sctag3_ic_cam_hit_c6[100] + sctag3_ic_cam_hit_c6[101] +
                                                        sctag3_ic_cam_hit_c6[102] + sctag3_ic_cam_hit_c6[103];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble26_sum  = sctag3_dc_cam_hit_c6[104] + sctag3_dc_cam_hit_c6[105] +
                                                        sctag3_dc_cam_hit_c6[106] + sctag3_dc_cam_hit_c6[107];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble26_sum  = sctag3_ic_cam_hit_c6[104] + sctag3_ic_cam_hit_c6[105] +
                                                        sctag3_ic_cam_hit_c6[106] + sctag3_ic_cam_hit_c6[107];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble26_sum= sctag3_dc_cam_hit_c6[104] + sctag3_dc_cam_hit_c6[105] +
                                                        sctag3_dc_cam_hit_c6[106] + sctag3_dc_cam_hit_c6[107] +
                                                        sctag3_ic_cam_hit_c6[104] + sctag3_ic_cam_hit_c6[105] +
                                                        sctag3_ic_cam_hit_c6[106] + sctag3_ic_cam_hit_c6[107];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble27_sum  = sctag3_dc_cam_hit_c6[108] + sctag3_dc_cam_hit_c6[109] +
                                                        sctag3_dc_cam_hit_c6[110] + sctag3_dc_cam_hit_c6[111];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble27_sum  = sctag3_ic_cam_hit_c6[108] + sctag3_ic_cam_hit_c6[109] +
                                                        sctag3_ic_cam_hit_c6[110] + sctag3_ic_cam_hit_c6[111];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble27_sum= sctag3_dc_cam_hit_c6[108] + sctag3_dc_cam_hit_c6[109] +
                                                        sctag3_dc_cam_hit_c6[110] + sctag3_dc_cam_hit_c6[111] +
                                                        sctag3_ic_cam_hit_c6[108] + sctag3_ic_cam_hit_c6[109] +
                                                        sctag3_ic_cam_hit_c6[110] + sctag3_ic_cam_hit_c6[111];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble28_sum  = sctag3_dc_cam_hit_c6[112] + sctag3_dc_cam_hit_c6[113] +
                                                        sctag3_dc_cam_hit_c6[114] + sctag3_dc_cam_hit_c6[115];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble28_sum  = sctag3_ic_cam_hit_c6[112] + sctag3_ic_cam_hit_c6[113] +
                                                        sctag3_ic_cam_hit_c6[114] + sctag3_ic_cam_hit_c6[115];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble28_sum= sctag3_dc_cam_hit_c6[112] + sctag3_dc_cam_hit_c6[113] +
                                                        sctag3_dc_cam_hit_c6[114] + sctag3_dc_cam_hit_c6[115] +
                                                        sctag3_ic_cam_hit_c6[112] + sctag3_ic_cam_hit_c6[113] +
                                                        sctag3_ic_cam_hit_c6[114] + sctag3_ic_cam_hit_c6[115];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble29_sum  = sctag3_dc_cam_hit_c6[116] + sctag3_dc_cam_hit_c6[117] +
                                                        sctag3_dc_cam_hit_c6[118] + sctag3_dc_cam_hit_c6[119];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble29_sum  = sctag3_ic_cam_hit_c6[116] + sctag3_ic_cam_hit_c6[117] +
                                                        sctag3_ic_cam_hit_c6[118] + sctag3_ic_cam_hit_c6[119];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble29_sum= sctag3_dc_cam_hit_c6[116] + sctag3_dc_cam_hit_c6[117] +
                                                        sctag3_dc_cam_hit_c6[118] + sctag3_dc_cam_hit_c6[119] +
                                                        sctag3_ic_cam_hit_c6[116] + sctag3_ic_cam_hit_c6[117] +
                                                        sctag3_ic_cam_hit_c6[118] + sctag3_ic_cam_hit_c6[119];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble30_sum  = sctag3_dc_cam_hit_c6[120] + sctag3_dc_cam_hit_c6[121] +
                                                        sctag3_dc_cam_hit_c6[122] + sctag3_dc_cam_hit_c6[123];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble30_sum  = sctag3_ic_cam_hit_c6[120] + sctag3_ic_cam_hit_c6[121] +
                                                        sctag3_ic_cam_hit_c6[122] + sctag3_ic_cam_hit_c6[123];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble30_sum= sctag3_dc_cam_hit_c6[120] + sctag3_dc_cam_hit_c6[121] +
                                                        sctag3_dc_cam_hit_c6[122] + sctag3_dc_cam_hit_c6[123] +
                                                        sctag3_ic_cam_hit_c6[120] + sctag3_ic_cam_hit_c6[121] +
                                                        sctag3_ic_cam_hit_c6[122] + sctag3_ic_cam_hit_c6[123];


//----------------------------------------------------------------------------------------
   wire [2:0] sctag3_dc_cam_hit_c6_nibble31_sum  = sctag3_dc_cam_hit_c6[124] + sctag3_dc_cam_hit_c6[125] +
                                                        sctag3_dc_cam_hit_c6[126] + sctag3_dc_cam_hit_c6[127];

   wire [2:0] sctag3_ic_cam_hit_c6_nibble31_sum  = sctag3_ic_cam_hit_c6[124] + sctag3_ic_cam_hit_c6[125] +
                                                        sctag3_ic_cam_hit_c6[126] + sctag3_ic_cam_hit_c6[127];
   
   wire [3:0] sctag3_both_cam_hit_c6_nibble31_sum= sctag3_dc_cam_hit_c6[124] + sctag3_dc_cam_hit_c6[125] +
                                                        sctag3_dc_cam_hit_c6[126] + sctag3_dc_cam_hit_c6[127] +
                                                        sctag3_ic_cam_hit_c6[124] + sctag3_ic_cam_hit_c6[125] +
                                                        sctag3_ic_cam_hit_c6[126] + sctag3_ic_cam_hit_c6[127];


// This one is an OR of all 4 SCTAGS
//----------------------------------
wire sctag_pcx_stall_pq = sctag0_pcx_stall_pq | sctag1_pcx_stall_pq | sctag2_pcx_stall_pq | sctag3_pcx_stall_pq;

//--------------------------------------------------------------------------------------
// cpx to spc (sparc) packets
//--------------------------------------------------------------------------------------
   wire                  cpx_spc0_data_vld 	= `TOP_MEMORY.cpx_spc0_data_cx2[`CPX_WIDTH-1]; 
   wire [`CPX_WIDTH-1:0] cpx_spc0_data_cx2	= `TOP_MEMORY.cpx_spc0_data_cx2[`CPX_WIDTH-1:0]; 

   reg [`CPX_WIDTH-1:0] cpx_spc0_data_cx2_d1;	// packet delayed by 1
   reg [`CPX_WIDTH-1:0] cpx_spc0_data_cx2_d2;	// packet delayed by 2
   reg [127:0]		spc0_pcx_type_str;		// packet type in string format for debug.

   reg [127:0]		cpx_spc0_type_str;		// in string format for debug

   wire [3:0]  		cpx_spc0_type     	= cpx_spc0_data_vld ? cpx_spc0_data_cx2[`CPX_RQ_HI:`CPX_RQ_LO] :4'h0;
   wire        		cpx_spc0_wyvld    	= cpx_spc0_data_cx2[`CPX_WYVLD] & cpx_spc0_data_vld;

   wire cpx_spc0_st_ack = (cpx_spc0_type == `ST_ACK) | (cpx_spc0_type == `STRST_ACK);
   wire cpx_spc0_evict  = (cpx_spc0_type == `EVICT_REQ);

   reg cpx_spc0_ifill_wyvld;
   reg cpx_spc0_dfill_wyvld;

  wire cpx_spc0_st_ack_dc_inval_1c_tmp = (cpx_spc0_data_cx2[122:121] == 2'b00) ?  cpx_spc0_data_cx2[0]  :
                                          (cpx_spc0_data_cx2[122:121] == 2'b01)   ?  cpx_spc0_data_cx2[32] :
                                          (cpx_spc0_data_cx2[122:121] == 2'b10)   ?  cpx_spc0_data_cx2[56] :
                                          					        cpx_spc0_data_cx2[88];

  wire [2:0] cpx_spc0_st_ack_dc_inval_1c = {2'b00, cpx_spc0_st_ack & cpx_spc0_st_ack_dc_inval_1c_tmp};

  wire cpx_spc0_st_ack_ic_inval_1c_tmp = cpx_spc0_data_cx2[122] ?  cpx_spc0_data_cx2[57] : cpx_spc0_data_cx2[1];
  wire [2:0] cpx_spc0_st_ack_ic_inval_1c = {2'b00, (cpx_spc0_st_ack & cpx_spc0_st_ack_ic_inval_1c_tmp)};
  wire [5:0] cpx_spc0_st_ack_icdc_inval_1c = {6{cpx_spc0_st_ack}} & 
					        {cpx_spc0_st_ack_ic_inval_1c, cpx_spc0_st_ack_dc_inval_1c};

  wire [2:0] cpx_spc0_evict_dc_inval_1c   = cpx_spc0_data_cx2[0]  + cpx_spc0_data_cx2[32] +
                                       cpx_spc0_data_cx2[56] + cpx_spc0_data_cx2[88];
  wire [1:0] cpx_spc0_evict_ic_inval_1c   = cpx_spc0_data_cx2[1]  + cpx_spc0_data_cx2[57];


  reg cpx_spc0_evict_d1;
  always @(posedge clk) 
    cpx_spc0_evict_d1 <= cpx_spc0_evict;

  wire cpx_spc0_b2b_evict = cpx_spc0_evict_d1 & cpx_spc0_evict;

  wire [5:0] cpx_spc0_evict_icdc_inval_1c;
  assign cpx_spc0_evict_icdc_inval_1c[4:0]={5{cpx_spc0_evict}} &
                                              {cpx_spc0_evict_ic_inval_1c,cpx_spc0_evict_dc_inval_1c};

  assign cpx_spc0_evict_icdc_inval_1c[5] = cpx_spc0_b2b_evict;

  wire [5:0] cpx_spc0_st_ack_dc_inval_8c_tmp = (cpx_spc0_data_cx2[122:121] == 2'b00) ? (
									     cpx_spc0_data_cx2[0] + cpx_spc0_data_cx2[4]   +
									     cpx_spc0_data_cx2[8] + cpx_spc0_data_cx2[12]  +
									     cpx_spc0_data_cx2[16] + cpx_spc0_data_cx2[20] +
									     cpx_spc0_data_cx2[24] + cpx_spc0_data_cx2[28] 
                                                                           ) :
                                  (cpx_spc0_data_cx2[122:121] == 2'b01) ? (
									     cpx_spc0_data_cx2[32] + cpx_spc0_data_cx2[35] +
									     cpx_spc0_data_cx2[38] + cpx_spc0_data_cx2[41] +
									     cpx_spc0_data_cx2[44] + cpx_spc0_data_cx2[47] +
									     cpx_spc0_data_cx2[50] + cpx_spc0_data_cx2[53] 
                                                                           ) :
                                  (cpx_spc0_data_cx2[122:121] == 2'b10) ? (
									     cpx_spc0_data_cx2[56] + cpx_spc0_data_cx2[60] +
									     cpx_spc0_data_cx2[64] + cpx_spc0_data_cx2[68] +
									     cpx_spc0_data_cx2[72] + cpx_spc0_data_cx2[76] +
									     cpx_spc0_data_cx2[80] + cpx_spc0_data_cx2[84] 
                                                                           ) :
									   ( cpx_spc0_data_cx2[88] + cpx_spc0_data_cx2[91] +
									     cpx_spc0_data_cx2[94] + cpx_spc0_data_cx2[97] +
									     cpx_spc0_data_cx2[100]+ cpx_spc0_data_cx2[103]+
									     cpx_spc0_data_cx2[106]+ cpx_spc0_data_cx2[109] 
                                                                           ) ;

  wire [5:0] cpx_spc0_st_ack_dc_inval_8c = {6{cpx_spc0_st_ack}} & cpx_spc0_st_ack_dc_inval_8c_tmp;

  wire [5:0] cpx_spc0_st_ack_ic_inval_8c_tmp = ~cpx_spc0_data_cx2[122] ? (
                                                                             cpx_spc0_data_cx2[1] + cpx_spc0_data_cx2[5]   +
                                                                             cpx_spc0_data_cx2[9] + cpx_spc0_data_cx2[13]  +
                                                                             cpx_spc0_data_cx2[17] + cpx_spc0_data_cx2[21] +
                                                                             cpx_spc0_data_cx2[25] + cpx_spc0_data_cx2[29] 
                                                                           ) :
                                                                           ( cpx_spc0_data_cx2[57] + cpx_spc0_data_cx2[61] +
                                                                             cpx_spc0_data_cx2[65] + cpx_spc0_data_cx2[69] +
                                                                             cpx_spc0_data_cx2[73] + cpx_spc0_data_cx2[77] +
                                                                             cpx_spc0_data_cx2[81] + cpx_spc0_data_cx2[85] 
                                                                           ) ;

  wire [5:0] cpx_spc0_st_ack_ic_inval_8c = {4{cpx_spc0_st_ack}} & cpx_spc0_st_ack_ic_inval_8c_tmp;

  wire [5:0] cpx_spc0_evict_dc_inval_8c_tmp = 
									     cpx_spc0_data_cx2[0] + cpx_spc0_data_cx2[4] +
									     cpx_spc0_data_cx2[8] + cpx_spc0_data_cx2[12] +
									     cpx_spc0_data_cx2[16] + cpx_spc0_data_cx2[20] +
									     cpx_spc0_data_cx2[24] + cpx_spc0_data_cx2[28] +
									     cpx_spc0_data_cx2[32] + cpx_spc0_data_cx2[35] +
									     cpx_spc0_data_cx2[38] + cpx_spc0_data_cx2[41] +
									     cpx_spc0_data_cx2[44] + cpx_spc0_data_cx2[47] +
									     cpx_spc0_data_cx2[50] + cpx_spc0_data_cx2[53] +
									     cpx_spc0_data_cx2[56] + cpx_spc0_data_cx2[60] +
									     cpx_spc0_data_cx2[64] + cpx_spc0_data_cx2[68] +
									     cpx_spc0_data_cx2[72] + cpx_spc0_data_cx2[76] +
									     cpx_spc0_data_cx2[80] + cpx_spc0_data_cx2[84] +
									     cpx_spc0_data_cx2[88] + cpx_spc0_data_cx2[91] +
									     cpx_spc0_data_cx2[94] + cpx_spc0_data_cx2[97] +
									     cpx_spc0_data_cx2[100]+ cpx_spc0_data_cx2[103]+
									     cpx_spc0_data_cx2[106]+ cpx_spc0_data_cx2[109];

  wire [5:0] cpx_spc0_evict_dc_inval_8c = {6{cpx_spc0_evict}} & cpx_spc0_evict_dc_inval_8c_tmp;

  wire [5:0] cpx_spc0_evict_ic_inval_8c_tmp = 
                                                                             cpx_spc0_data_cx2[1] + cpx_spc0_data_cx2[5] +
                                                                             cpx_spc0_data_cx2[9] + cpx_spc0_data_cx2[13] +
                                                                             cpx_spc0_data_cx2[17] + cpx_spc0_data_cx2[21] +
                                                                             cpx_spc0_data_cx2[25] + cpx_spc0_data_cx2[29] +
                                                                             cpx_spc0_data_cx2[57] + cpx_spc0_data_cx2[61] +
                                                                             cpx_spc0_data_cx2[65] + cpx_spc0_data_cx2[69] +
                                                                             cpx_spc0_data_cx2[73] + cpx_spc0_data_cx2[77] +
                                                                             cpx_spc0_data_cx2[81] + cpx_spc0_data_cx2[85];

  wire [5:0] cpx_spc0_evict_ic_inval_8c = {6{cpx_spc0_evict}} & cpx_spc0_evict_ic_inval_8c_tmp;

  reg [3:0] 	blk_st_cnt0;			// counts the number of block  stores without an acknowledge in between
  reg [3:0] 	ini_st_cnt0;			// counts the number of init   stores without an acknowledge in between
  reg  		st_blkst_mixture0;		// a flag set upon detection of block store and normal store mixture.
  reg  		st_inist_mixture0;		// a flag set upon detection of init  store and normal store mixture.
  reg 		atomic_ret0;			// atomic  cpx to spc package
  reg 		non_b2b_atomic_ret0;		// atomic  cpx to spc package did not return in back to back cycles
   wire                  cpx_spc1_data_vld 	= `TOP_MEMORY.cpx_spc1_data_cx2[`CPX_WIDTH-1]; 
   wire [`CPX_WIDTH-1:0] cpx_spc1_data_cx2	= `TOP_MEMORY.cpx_spc1_data_cx2[`CPX_WIDTH-1:0]; 

   reg [`CPX_WIDTH-1:0] cpx_spc1_data_cx2_d1;	// packet delayed by 1
   reg [`CPX_WIDTH-1:0] cpx_spc1_data_cx2_d2;	// packet delayed by 2
   reg [127:0]		spc1_pcx_type_str;		// packet type in string format for debug.

   reg [127:0]		cpx_spc1_type_str;		// in string format for debug

   wire [3:0]  		cpx_spc1_type     	= cpx_spc1_data_vld ? cpx_spc1_data_cx2[`CPX_RQ_HI:`CPX_RQ_LO] :4'h0;
   wire        		cpx_spc1_wyvld    	= cpx_spc1_data_cx2[`CPX_WYVLD] & cpx_spc1_data_vld;

   wire cpx_spc1_st_ack = (cpx_spc1_type == `ST_ACK) | (cpx_spc1_type == `STRST_ACK);
   wire cpx_spc1_evict  = (cpx_spc1_type == `EVICT_REQ);

   reg cpx_spc1_ifill_wyvld;
   reg cpx_spc1_dfill_wyvld;

  wire cpx_spc1_st_ack_dc_inval_1c_tmp = (cpx_spc1_data_cx2[122:121] == 2'b00) ?  cpx_spc1_data_cx2[0]  :
                                          (cpx_spc1_data_cx2[122:121] == 2'b01)   ?  cpx_spc1_data_cx2[32] :
                                          (cpx_spc1_data_cx2[122:121] == 2'b10)   ?  cpx_spc1_data_cx2[56] :
                                          					        cpx_spc1_data_cx2[88];

  wire [2:0] cpx_spc1_st_ack_dc_inval_1c = {2'b00, cpx_spc1_st_ack & cpx_spc1_st_ack_dc_inval_1c_tmp};

  wire cpx_spc1_st_ack_ic_inval_1c_tmp = cpx_spc1_data_cx2[122] ?  cpx_spc1_data_cx2[57] : cpx_spc1_data_cx2[1];
  wire [2:0] cpx_spc1_st_ack_ic_inval_1c = {2'b00, (cpx_spc1_st_ack & cpx_spc1_st_ack_ic_inval_1c_tmp)};
  wire [5:0] cpx_spc1_st_ack_icdc_inval_1c = {6{cpx_spc1_st_ack}} & 
					        {cpx_spc1_st_ack_ic_inval_1c, cpx_spc1_st_ack_dc_inval_1c};

  wire [2:0] cpx_spc1_evict_dc_inval_1c   = cpx_spc1_data_cx2[0]  + cpx_spc1_data_cx2[32] +
                                       cpx_spc1_data_cx2[56] + cpx_spc1_data_cx2[88];
  wire [1:0] cpx_spc1_evict_ic_inval_1c   = cpx_spc1_data_cx2[1]  + cpx_spc1_data_cx2[57];


  reg cpx_spc1_evict_d1;
  always @(posedge clk) 
    cpx_spc1_evict_d1 <= cpx_spc1_evict;

  wire cpx_spc1_b2b_evict = cpx_spc1_evict_d1 & cpx_spc1_evict;

  wire [5:0] cpx_spc1_evict_icdc_inval_1c;
  assign cpx_spc1_evict_icdc_inval_1c[4:0]={5{cpx_spc1_evict}} &
                                              {cpx_spc1_evict_ic_inval_1c,cpx_spc1_evict_dc_inval_1c};

  assign cpx_spc1_evict_icdc_inval_1c[5] = cpx_spc1_b2b_evict;

  wire [5:0] cpx_spc1_st_ack_dc_inval_8c_tmp = (cpx_spc1_data_cx2[122:121] == 2'b00) ? (
									     cpx_spc1_data_cx2[0] + cpx_spc1_data_cx2[4]   +
									     cpx_spc1_data_cx2[8] + cpx_spc1_data_cx2[12]  +
									     cpx_spc1_data_cx2[16] + cpx_spc1_data_cx2[20] +
									     cpx_spc1_data_cx2[24] + cpx_spc1_data_cx2[28] 
                                                                           ) :
                                  (cpx_spc1_data_cx2[122:121] == 2'b01) ? (
									     cpx_spc1_data_cx2[32] + cpx_spc1_data_cx2[35] +
									     cpx_spc1_data_cx2[38] + cpx_spc1_data_cx2[41] +
									     cpx_spc1_data_cx2[44] + cpx_spc1_data_cx2[47] +
									     cpx_spc1_data_cx2[50] + cpx_spc1_data_cx2[53] 
                                                                           ) :
                                  (cpx_spc1_data_cx2[122:121] == 2'b10) ? (
									     cpx_spc1_data_cx2[56] + cpx_spc1_data_cx2[60] +
									     cpx_spc1_data_cx2[64] + cpx_spc1_data_cx2[68] +
									     cpx_spc1_data_cx2[72] + cpx_spc1_data_cx2[76] +
									     cpx_spc1_data_cx2[80] + cpx_spc1_data_cx2[84] 
                                                                           ) :
									   ( cpx_spc1_data_cx2[88] + cpx_spc1_data_cx2[91] +
									     cpx_spc1_data_cx2[94] + cpx_spc1_data_cx2[97] +
									     cpx_spc1_data_cx2[100]+ cpx_spc1_data_cx2[103]+
									     cpx_spc1_data_cx2[106]+ cpx_spc1_data_cx2[109] 
                                                                           ) ;

  wire [5:0] cpx_spc1_st_ack_dc_inval_8c = {6{cpx_spc1_st_ack}} & cpx_spc1_st_ack_dc_inval_8c_tmp;

  wire [5:0] cpx_spc1_st_ack_ic_inval_8c_tmp = ~cpx_spc1_data_cx2[122] ? (
                                                                             cpx_spc1_data_cx2[1] + cpx_spc1_data_cx2[5]   +
                                                                             cpx_spc1_data_cx2[9] + cpx_spc1_data_cx2[13]  +
                                                                             cpx_spc1_data_cx2[17] + cpx_spc1_data_cx2[21] +
                                                                             cpx_spc1_data_cx2[25] + cpx_spc1_data_cx2[29] 
                                                                           ) :
                                                                           ( cpx_spc1_data_cx2[57] + cpx_spc1_data_cx2[61] +
                                                                             cpx_spc1_data_cx2[65] + cpx_spc1_data_cx2[69] +
                                                                             cpx_spc1_data_cx2[73] + cpx_spc1_data_cx2[77] +
                                                                             cpx_spc1_data_cx2[81] + cpx_spc1_data_cx2[85] 
                                                                           ) ;

  wire [5:0] cpx_spc1_st_ack_ic_inval_8c = {4{cpx_spc1_st_ack}} & cpx_spc1_st_ack_ic_inval_8c_tmp;

  wire [5:0] cpx_spc1_evict_dc_inval_8c_tmp = 
									     cpx_spc1_data_cx2[0] + cpx_spc1_data_cx2[4] +
									     cpx_spc1_data_cx2[8] + cpx_spc1_data_cx2[12] +
									     cpx_spc1_data_cx2[16] + cpx_spc1_data_cx2[20] +
									     cpx_spc1_data_cx2[24] + cpx_spc1_data_cx2[28] +
									     cpx_spc1_data_cx2[32] + cpx_spc1_data_cx2[35] +
									     cpx_spc1_data_cx2[38] + cpx_spc1_data_cx2[41] +
									     cpx_spc1_data_cx2[44] + cpx_spc1_data_cx2[47] +
									     cpx_spc1_data_cx2[50] + cpx_spc1_data_cx2[53] +
									     cpx_spc1_data_cx2[56] + cpx_spc1_data_cx2[60] +
									     cpx_spc1_data_cx2[64] + cpx_spc1_data_cx2[68] +
									     cpx_spc1_data_cx2[72] + cpx_spc1_data_cx2[76] +
									     cpx_spc1_data_cx2[80] + cpx_spc1_data_cx2[84] +
									     cpx_spc1_data_cx2[88] + cpx_spc1_data_cx2[91] +
									     cpx_spc1_data_cx2[94] + cpx_spc1_data_cx2[97] +
									     cpx_spc1_data_cx2[100]+ cpx_spc1_data_cx2[103]+
									     cpx_spc1_data_cx2[106]+ cpx_spc1_data_cx2[109];

  wire [5:0] cpx_spc1_evict_dc_inval_8c = {6{cpx_spc1_evict}} & cpx_spc1_evict_dc_inval_8c_tmp;

  wire [5:0] cpx_spc1_evict_ic_inval_8c_tmp = 
                                                                             cpx_spc1_data_cx2[1] + cpx_spc1_data_cx2[5] +
                                                                             cpx_spc1_data_cx2[9] + cpx_spc1_data_cx2[13] +
                                                                             cpx_spc1_data_cx2[17] + cpx_spc1_data_cx2[21] +
                                                                             cpx_spc1_data_cx2[25] + cpx_spc1_data_cx2[29] +
                                                                             cpx_spc1_data_cx2[57] + cpx_spc1_data_cx2[61] +
                                                                             cpx_spc1_data_cx2[65] + cpx_spc1_data_cx2[69] +
                                                                             cpx_spc1_data_cx2[73] + cpx_spc1_data_cx2[77] +
                                                                             cpx_spc1_data_cx2[81] + cpx_spc1_data_cx2[85];

  wire [5:0] cpx_spc1_evict_ic_inval_8c = {6{cpx_spc1_evict}} & cpx_spc1_evict_ic_inval_8c_tmp;

  reg [3:0] 	blk_st_cnt1;			// counts the number of block  stores without an acknowledge in between
  reg [3:0] 	ini_st_cnt1;			// counts the number of init   stores without an acknowledge in between
  reg  		st_blkst_mixture1;		// a flag set upon detection of block store and normal store mixture.
  reg  		st_inist_mixture1;		// a flag set upon detection of init  store and normal store mixture.
  reg 		atomic_ret1;			// atomic  cpx to spc package
  reg 		non_b2b_atomic_ret1;		// atomic  cpx to spc package did not return in back to back cycles
   wire                  cpx_spc2_data_vld 	= `TOP_MEMORY.cpx_spc2_data_cx2[`CPX_WIDTH-1]; 
   wire [`CPX_WIDTH-1:0] cpx_spc2_data_cx2	= `TOP_MEMORY.cpx_spc2_data_cx2[`CPX_WIDTH-1:0]; 

   reg [`CPX_WIDTH-1:0] cpx_spc2_data_cx2_d1;	// packet delayed by 1
   reg [`CPX_WIDTH-1:0] cpx_spc2_data_cx2_d2;	// packet delayed by 2
   reg [127:0]		spc2_pcx_type_str;		// packet type in string format for debug.

   reg [127:0]		cpx_spc2_type_str;		// in string format for debug

   wire [3:0]  		cpx_spc2_type     	= cpx_spc2_data_vld ? cpx_spc2_data_cx2[`CPX_RQ_HI:`CPX_RQ_LO] :4'h0;
   wire        		cpx_spc2_wyvld    	= cpx_spc2_data_cx2[`CPX_WYVLD] & cpx_spc2_data_vld;

   wire cpx_spc2_st_ack = (cpx_spc2_type == `ST_ACK) | (cpx_spc2_type == `STRST_ACK);
   wire cpx_spc2_evict  = (cpx_spc2_type == `EVICT_REQ);

   reg cpx_spc2_ifill_wyvld;
   reg cpx_spc2_dfill_wyvld;

  wire cpx_spc2_st_ack_dc_inval_1c_tmp = (cpx_spc2_data_cx2[122:121] == 2'b00) ?  cpx_spc2_data_cx2[0]  :
                                          (cpx_spc2_data_cx2[122:121] == 2'b01)   ?  cpx_spc2_data_cx2[32] :
                                          (cpx_spc2_data_cx2[122:121] == 2'b10)   ?  cpx_spc2_data_cx2[56] :
                                          					        cpx_spc2_data_cx2[88];

  wire [2:0] cpx_spc2_st_ack_dc_inval_1c = {2'b00, cpx_spc2_st_ack & cpx_spc2_st_ack_dc_inval_1c_tmp};

  wire cpx_spc2_st_ack_ic_inval_1c_tmp = cpx_spc2_data_cx2[122] ?  cpx_spc2_data_cx2[57] : cpx_spc2_data_cx2[1];
  wire [2:0] cpx_spc2_st_ack_ic_inval_1c = {2'b00, (cpx_spc2_st_ack & cpx_spc2_st_ack_ic_inval_1c_tmp)};
  wire [5:0] cpx_spc2_st_ack_icdc_inval_1c = {6{cpx_spc2_st_ack}} & 
					        {cpx_spc2_st_ack_ic_inval_1c, cpx_spc2_st_ack_dc_inval_1c};

  wire [2:0] cpx_spc2_evict_dc_inval_1c   = cpx_spc2_data_cx2[0]  + cpx_spc2_data_cx2[32] +
                                       cpx_spc2_data_cx2[56] + cpx_spc2_data_cx2[88];
  wire [1:0] cpx_spc2_evict_ic_inval_1c   = cpx_spc2_data_cx2[1]  + cpx_spc2_data_cx2[57];


  reg cpx_spc2_evict_d1;
  always @(posedge clk) 
    cpx_spc2_evict_d1 <= cpx_spc2_evict;

  wire cpx_spc2_b2b_evict = cpx_spc2_evict_d1 & cpx_spc2_evict;

  wire [5:0] cpx_spc2_evict_icdc_inval_1c;
  assign cpx_spc2_evict_icdc_inval_1c[4:0]={5{cpx_spc2_evict}} &
                                              {cpx_spc2_evict_ic_inval_1c,cpx_spc2_evict_dc_inval_1c};

  assign cpx_spc2_evict_icdc_inval_1c[5] = cpx_spc2_b2b_evict;

  wire [5:0] cpx_spc2_st_ack_dc_inval_8c_tmp = (cpx_spc2_data_cx2[122:121] == 2'b00) ? (
									     cpx_spc2_data_cx2[0] + cpx_spc2_data_cx2[4]   +
									     cpx_spc2_data_cx2[8] + cpx_spc2_data_cx2[12]  +
									     cpx_spc2_data_cx2[16] + cpx_spc2_data_cx2[20] +
									     cpx_spc2_data_cx2[24] + cpx_spc2_data_cx2[28] 
                                                                           ) :
                                  (cpx_spc2_data_cx2[122:121] == 2'b01) ? (
									     cpx_spc2_data_cx2[32] + cpx_spc2_data_cx2[35] +
									     cpx_spc2_data_cx2[38] + cpx_spc2_data_cx2[41] +
									     cpx_spc2_data_cx2[44] + cpx_spc2_data_cx2[47] +
									     cpx_spc2_data_cx2[50] + cpx_spc2_data_cx2[53] 
                                                                           ) :
                                  (cpx_spc2_data_cx2[122:121] == 2'b10) ? (
									     cpx_spc2_data_cx2[56] + cpx_spc2_data_cx2[60] +
									     cpx_spc2_data_cx2[64] + cpx_spc2_data_cx2[68] +
									     cpx_spc2_data_cx2[72] + cpx_spc2_data_cx2[76] +
									     cpx_spc2_data_cx2[80] + cpx_spc2_data_cx2[84] 
                                                                           ) :
									   ( cpx_spc2_data_cx2[88] + cpx_spc2_data_cx2[91] +
									     cpx_spc2_data_cx2[94] + cpx_spc2_data_cx2[97] +
									     cpx_spc2_data_cx2[100]+ cpx_spc2_data_cx2[103]+
									     cpx_spc2_data_cx2[106]+ cpx_spc2_data_cx2[109] 
                                                                           ) ;

  wire [5:0] cpx_spc2_st_ack_dc_inval_8c = {6{cpx_spc2_st_ack}} & cpx_spc2_st_ack_dc_inval_8c_tmp;

  wire [5:0] cpx_spc2_st_ack_ic_inval_8c_tmp = ~cpx_spc2_data_cx2[122] ? (
                                                                             cpx_spc2_data_cx2[1] + cpx_spc2_data_cx2[5]   +
                                                                             cpx_spc2_data_cx2[9] + cpx_spc2_data_cx2[13]  +
                                                                             cpx_spc2_data_cx2[17] + cpx_spc2_data_cx2[21] +
                                                                             cpx_spc2_data_cx2[25] + cpx_spc2_data_cx2[29] 
                                                                           ) :
                                                                           ( cpx_spc2_data_cx2[57] + cpx_spc2_data_cx2[61] +
                                                                             cpx_spc2_data_cx2[65] + cpx_spc2_data_cx2[69] +
                                                                             cpx_spc2_data_cx2[73] + cpx_spc2_data_cx2[77] +
                                                                             cpx_spc2_data_cx2[81] + cpx_spc2_data_cx2[85] 
                                                                           ) ;

  wire [5:0] cpx_spc2_st_ack_ic_inval_8c = {4{cpx_spc2_st_ack}} & cpx_spc2_st_ack_ic_inval_8c_tmp;

  wire [5:0] cpx_spc2_evict_dc_inval_8c_tmp = 
									     cpx_spc2_data_cx2[0] + cpx_spc2_data_cx2[4] +
									     cpx_spc2_data_cx2[8] + cpx_spc2_data_cx2[12] +
									     cpx_spc2_data_cx2[16] + cpx_spc2_data_cx2[20] +
									     cpx_spc2_data_cx2[24] + cpx_spc2_data_cx2[28] +
									     cpx_spc2_data_cx2[32] + cpx_spc2_data_cx2[35] +
									     cpx_spc2_data_cx2[38] + cpx_spc2_data_cx2[41] +
									     cpx_spc2_data_cx2[44] + cpx_spc2_data_cx2[47] +
									     cpx_spc2_data_cx2[50] + cpx_spc2_data_cx2[53] +
									     cpx_spc2_data_cx2[56] + cpx_spc2_data_cx2[60] +
									     cpx_spc2_data_cx2[64] + cpx_spc2_data_cx2[68] +
									     cpx_spc2_data_cx2[72] + cpx_spc2_data_cx2[76] +
									     cpx_spc2_data_cx2[80] + cpx_spc2_data_cx2[84] +
									     cpx_spc2_data_cx2[88] + cpx_spc2_data_cx2[91] +
									     cpx_spc2_data_cx2[94] + cpx_spc2_data_cx2[97] +
									     cpx_spc2_data_cx2[100]+ cpx_spc2_data_cx2[103]+
									     cpx_spc2_data_cx2[106]+ cpx_spc2_data_cx2[109];

  wire [5:0] cpx_spc2_evict_dc_inval_8c = {6{cpx_spc2_evict}} & cpx_spc2_evict_dc_inval_8c_tmp;

  wire [5:0] cpx_spc2_evict_ic_inval_8c_tmp = 
                                                                             cpx_spc2_data_cx2[1] + cpx_spc2_data_cx2[5] +
                                                                             cpx_spc2_data_cx2[9] + cpx_spc2_data_cx2[13] +
                                                                             cpx_spc2_data_cx2[17] + cpx_spc2_data_cx2[21] +
                                                                             cpx_spc2_data_cx2[25] + cpx_spc2_data_cx2[29] +
                                                                             cpx_spc2_data_cx2[57] + cpx_spc2_data_cx2[61] +
                                                                             cpx_spc2_data_cx2[65] + cpx_spc2_data_cx2[69] +
                                                                             cpx_spc2_data_cx2[73] + cpx_spc2_data_cx2[77] +
                                                                             cpx_spc2_data_cx2[81] + cpx_spc2_data_cx2[85];

  wire [5:0] cpx_spc2_evict_ic_inval_8c = {6{cpx_spc2_evict}} & cpx_spc2_evict_ic_inval_8c_tmp;

  reg [3:0] 	blk_st_cnt2;			// counts the number of block  stores without an acknowledge in between
  reg [3:0] 	ini_st_cnt2;			// counts the number of init   stores without an acknowledge in between
  reg  		st_blkst_mixture2;		// a flag set upon detection of block store and normal store mixture.
  reg  		st_inist_mixture2;		// a flag set upon detection of init  store and normal store mixture.
  reg 		atomic_ret2;			// atomic  cpx to spc package
  reg 		non_b2b_atomic_ret2;		// atomic  cpx to spc package did not return in back to back cycles
   wire                  cpx_spc3_data_vld 	= `TOP_MEMORY.cpx_spc3_data_cx2[`CPX_WIDTH-1]; 
   wire [`CPX_WIDTH-1:0] cpx_spc3_data_cx2	= `TOP_MEMORY.cpx_spc3_data_cx2[`CPX_WIDTH-1:0]; 

   reg [`CPX_WIDTH-1:0] cpx_spc3_data_cx2_d1;	// packet delayed by 1
   reg [`CPX_WIDTH-1:0] cpx_spc3_data_cx2_d2;	// packet delayed by 2
   reg [127:0]		spc3_pcx_type_str;		// packet type in string format for debug.

   reg [127:0]		cpx_spc3_type_str;		// in string format for debug

   wire [3:0]  		cpx_spc3_type     	= cpx_spc3_data_vld ? cpx_spc3_data_cx2[`CPX_RQ_HI:`CPX_RQ_LO] :4'h0;
   wire        		cpx_spc3_wyvld    	= cpx_spc3_data_cx2[`CPX_WYVLD] & cpx_spc3_data_vld;

   wire cpx_spc3_st_ack = (cpx_spc3_type == `ST_ACK) | (cpx_spc3_type == `STRST_ACK);
   wire cpx_spc3_evict  = (cpx_spc3_type == `EVICT_REQ);

   reg cpx_spc3_ifill_wyvld;
   reg cpx_spc3_dfill_wyvld;

  wire cpx_spc3_st_ack_dc_inval_1c_tmp = (cpx_spc3_data_cx2[122:121] == 2'b00) ?  cpx_spc3_data_cx2[0]  :
                                          (cpx_spc3_data_cx2[122:121] == 2'b01)   ?  cpx_spc3_data_cx2[32] :
                                          (cpx_spc3_data_cx2[122:121] == 2'b10)   ?  cpx_spc3_data_cx2[56] :
                                          					        cpx_spc3_data_cx2[88];

  wire [2:0] cpx_spc3_st_ack_dc_inval_1c = {2'b00, cpx_spc3_st_ack & cpx_spc3_st_ack_dc_inval_1c_tmp};

  wire cpx_spc3_st_ack_ic_inval_1c_tmp = cpx_spc3_data_cx2[122] ?  cpx_spc3_data_cx2[57] : cpx_spc3_data_cx2[1];
  wire [2:0] cpx_spc3_st_ack_ic_inval_1c = {2'b00, (cpx_spc3_st_ack & cpx_spc3_st_ack_ic_inval_1c_tmp)};
  wire [5:0] cpx_spc3_st_ack_icdc_inval_1c = {6{cpx_spc3_st_ack}} & 
					        {cpx_spc3_st_ack_ic_inval_1c, cpx_spc3_st_ack_dc_inval_1c};

  wire [2:0] cpx_spc3_evict_dc_inval_1c   = cpx_spc3_data_cx2[0]  + cpx_spc3_data_cx2[32] +
                                       cpx_spc3_data_cx2[56] + cpx_spc3_data_cx2[88];
  wire [1:0] cpx_spc3_evict_ic_inval_1c   = cpx_spc3_data_cx2[1]  + cpx_spc3_data_cx2[57];


  reg cpx_spc3_evict_d1;
  always @(posedge clk) 
    cpx_spc3_evict_d1 <= cpx_spc3_evict;

  wire cpx_spc3_b2b_evict = cpx_spc3_evict_d1 & cpx_spc3_evict;

  wire [5:0] cpx_spc3_evict_icdc_inval_1c;
  assign cpx_spc3_evict_icdc_inval_1c[4:0]={5{cpx_spc3_evict}} &
                                              {cpx_spc3_evict_ic_inval_1c,cpx_spc3_evict_dc_inval_1c};

  assign cpx_spc3_evict_icdc_inval_1c[5] = cpx_spc3_b2b_evict;

  wire [5:0] cpx_spc3_st_ack_dc_inval_8c_tmp = (cpx_spc3_data_cx2[122:121] == 2'b00) ? (
									     cpx_spc3_data_cx2[0] + cpx_spc3_data_cx2[4]   +
									     cpx_spc3_data_cx2[8] + cpx_spc3_data_cx2[12]  +
									     cpx_spc3_data_cx2[16] + cpx_spc3_data_cx2[20] +
									     cpx_spc3_data_cx2[24] + cpx_spc3_data_cx2[28] 
                                                                           ) :
                                  (cpx_spc3_data_cx2[122:121] == 2'b01) ? (
									     cpx_spc3_data_cx2[32] + cpx_spc3_data_cx2[35] +
									     cpx_spc3_data_cx2[38] + cpx_spc3_data_cx2[41] +
									     cpx_spc3_data_cx2[44] + cpx_spc3_data_cx2[47] +
									     cpx_spc3_data_cx2[50] + cpx_spc3_data_cx2[53] 
                                                                           ) :
                                  (cpx_spc3_data_cx2[122:121] == 2'b10) ? (
									     cpx_spc3_data_cx2[56] + cpx_spc3_data_cx2[60] +
									     cpx_spc3_data_cx2[64] + cpx_spc3_data_cx2[68] +
									     cpx_spc3_data_cx2[72] + cpx_spc3_data_cx2[76] +
									     cpx_spc3_data_cx2[80] + cpx_spc3_data_cx2[84] 
                                                                           ) :
									   ( cpx_spc3_data_cx2[88] + cpx_spc3_data_cx2[91] +
									     cpx_spc3_data_cx2[94] + cpx_spc3_data_cx2[97] +
									     cpx_spc3_data_cx2[100]+ cpx_spc3_data_cx2[103]+
									     cpx_spc3_data_cx2[106]+ cpx_spc3_data_cx2[109] 
                                                                           ) ;

  wire [5:0] cpx_spc3_st_ack_dc_inval_8c = {6{cpx_spc3_st_ack}} & cpx_spc3_st_ack_dc_inval_8c_tmp;

  wire [5:0] cpx_spc3_st_ack_ic_inval_8c_tmp = ~cpx_spc3_data_cx2[122] ? (
                                                                             cpx_spc3_data_cx2[1] + cpx_spc3_data_cx2[5]   +
                                                                             cpx_spc3_data_cx2[9] + cpx_spc3_data_cx2[13]  +
                                                                             cpx_spc3_data_cx2[17] + cpx_spc3_data_cx2[21] +
                                                                             cpx_spc3_data_cx2[25] + cpx_spc3_data_cx2[29] 
                                                                           ) :
                                                                           ( cpx_spc3_data_cx2[57] + cpx_spc3_data_cx2[61] +
                                                                             cpx_spc3_data_cx2[65] + cpx_spc3_data_cx2[69] +
                                                                             cpx_spc3_data_cx2[73] + cpx_spc3_data_cx2[77] +
                                                                             cpx_spc3_data_cx2[81] + cpx_spc3_data_cx2[85] 
                                                                           ) ;

  wire [5:0] cpx_spc3_st_ack_ic_inval_8c = {4{cpx_spc3_st_ack}} & cpx_spc3_st_ack_ic_inval_8c_tmp;

  wire [5:0] cpx_spc3_evict_dc_inval_8c_tmp = 
									     cpx_spc3_data_cx2[0] + cpx_spc3_data_cx2[4] +
									     cpx_spc3_data_cx2[8] + cpx_spc3_data_cx2[12] +
									     cpx_spc3_data_cx2[16] + cpx_spc3_data_cx2[20] +
									     cpx_spc3_data_cx2[24] + cpx_spc3_data_cx2[28] +
									     cpx_spc3_data_cx2[32] + cpx_spc3_data_cx2[35] +
									     cpx_spc3_data_cx2[38] + cpx_spc3_data_cx2[41] +
									     cpx_spc3_data_cx2[44] + cpx_spc3_data_cx2[47] +
									     cpx_spc3_data_cx2[50] + cpx_spc3_data_cx2[53] +
									     cpx_spc3_data_cx2[56] + cpx_spc3_data_cx2[60] +
									     cpx_spc3_data_cx2[64] + cpx_spc3_data_cx2[68] +
									     cpx_spc3_data_cx2[72] + cpx_spc3_data_cx2[76] +
									     cpx_spc3_data_cx2[80] + cpx_spc3_data_cx2[84] +
									     cpx_spc3_data_cx2[88] + cpx_spc3_data_cx2[91] +
									     cpx_spc3_data_cx2[94] + cpx_spc3_data_cx2[97] +
									     cpx_spc3_data_cx2[100]+ cpx_spc3_data_cx2[103]+
									     cpx_spc3_data_cx2[106]+ cpx_spc3_data_cx2[109];

  wire [5:0] cpx_spc3_evict_dc_inval_8c = {6{cpx_spc3_evict}} & cpx_spc3_evict_dc_inval_8c_tmp;

  wire [5:0] cpx_spc3_evict_ic_inval_8c_tmp = 
                                                                             cpx_spc3_data_cx2[1] + cpx_spc3_data_cx2[5] +
                                                                             cpx_spc3_data_cx2[9] + cpx_spc3_data_cx2[13] +
                                                                             cpx_spc3_data_cx2[17] + cpx_spc3_data_cx2[21] +
                                                                             cpx_spc3_data_cx2[25] + cpx_spc3_data_cx2[29] +
                                                                             cpx_spc3_data_cx2[57] + cpx_spc3_data_cx2[61] +
                                                                             cpx_spc3_data_cx2[65] + cpx_spc3_data_cx2[69] +
                                                                             cpx_spc3_data_cx2[73] + cpx_spc3_data_cx2[77] +
                                                                             cpx_spc3_data_cx2[81] + cpx_spc3_data_cx2[85];

  wire [5:0] cpx_spc3_evict_ic_inval_8c = {6{cpx_spc3_evict}} & cpx_spc3_evict_ic_inval_8c_tmp;

  reg [3:0] 	blk_st_cnt3;			// counts the number of block  stores without an acknowledge in between
  reg [3:0] 	ini_st_cnt3;			// counts the number of init   stores without an acknowledge in between
  reg  		st_blkst_mixture3;		// a flag set upon detection of block store and normal store mixture.
  reg  		st_inist_mixture3;		// a flag set upon detection of init  store and normal store mixture.
  reg 		atomic_ret3;			// atomic  cpx to spc package
  reg 		non_b2b_atomic_ret3;		// atomic  cpx to spc package did not return in back to back cycles
   wire                  cpx_spc4_data_vld 	= `TOP_MEMORY.cpx_spc4_data_cx2[`CPX_WIDTH-1]; 
   wire [`CPX_WIDTH-1:0] cpx_spc4_data_cx2	= `TOP_MEMORY.cpx_spc4_data_cx2[`CPX_WIDTH-1:0]; 

   reg [`CPX_WIDTH-1:0] cpx_spc4_data_cx2_d1;	// packet delayed by 1
   reg [`CPX_WIDTH-1:0] cpx_spc4_data_cx2_d2;	// packet delayed by 2
   reg [127:0]		spc4_pcx_type_str;		// packet type in string format for debug.

   reg [127:0]		cpx_spc4_type_str;		// in string format for debug

   wire [3:0]  		cpx_spc4_type     	= cpx_spc4_data_vld ? cpx_spc4_data_cx2[`CPX_RQ_HI:`CPX_RQ_LO] :4'h0;
   wire        		cpx_spc4_wyvld    	= cpx_spc4_data_cx2[`CPX_WYVLD] & cpx_spc4_data_vld;

   wire cpx_spc4_st_ack = (cpx_spc4_type == `ST_ACK) | (cpx_spc4_type == `STRST_ACK);
   wire cpx_spc4_evict  = (cpx_spc4_type == `EVICT_REQ);

   reg cpx_spc4_ifill_wyvld;
   reg cpx_spc4_dfill_wyvld;

  wire cpx_spc4_st_ack_dc_inval_1c_tmp = (cpx_spc4_data_cx2[122:121] == 2'b00) ?  cpx_spc4_data_cx2[0]  :
                                          (cpx_spc4_data_cx2[122:121] == 2'b01)   ?  cpx_spc4_data_cx2[32] :
                                          (cpx_spc4_data_cx2[122:121] == 2'b10)   ?  cpx_spc4_data_cx2[56] :
                                          					        cpx_spc4_data_cx2[88];

  wire [2:0] cpx_spc4_st_ack_dc_inval_1c = {2'b00, cpx_spc4_st_ack & cpx_spc4_st_ack_dc_inval_1c_tmp};

  wire cpx_spc4_st_ack_ic_inval_1c_tmp = cpx_spc4_data_cx2[122] ?  cpx_spc4_data_cx2[57] : cpx_spc4_data_cx2[1];
  wire [2:0] cpx_spc4_st_ack_ic_inval_1c = {2'b00, (cpx_spc4_st_ack & cpx_spc4_st_ack_ic_inval_1c_tmp)};
  wire [5:0] cpx_spc4_st_ack_icdc_inval_1c = {6{cpx_spc4_st_ack}} & 
					        {cpx_spc4_st_ack_ic_inval_1c, cpx_spc4_st_ack_dc_inval_1c};

  wire [2:0] cpx_spc4_evict_dc_inval_1c   = cpx_spc4_data_cx2[0]  + cpx_spc4_data_cx2[32] +
                                       cpx_spc4_data_cx2[56] + cpx_spc4_data_cx2[88];
  wire [1:0] cpx_spc4_evict_ic_inval_1c   = cpx_spc4_data_cx2[1]  + cpx_spc4_data_cx2[57];


  reg cpx_spc4_evict_d1;
  always @(posedge clk) 
    cpx_spc4_evict_d1 <= cpx_spc4_evict;

  wire cpx_spc4_b2b_evict = cpx_spc4_evict_d1 & cpx_spc4_evict;

  wire [5:0] cpx_spc4_evict_icdc_inval_1c;
  assign cpx_spc4_evict_icdc_inval_1c[4:0]={5{cpx_spc4_evict}} &
                                              {cpx_spc4_evict_ic_inval_1c,cpx_spc4_evict_dc_inval_1c};

  assign cpx_spc4_evict_icdc_inval_1c[5] = cpx_spc4_b2b_evict;

  wire [5:0] cpx_spc4_st_ack_dc_inval_8c_tmp = (cpx_spc4_data_cx2[122:121] == 2'b00) ? (
									     cpx_spc4_data_cx2[0] + cpx_spc4_data_cx2[4]   +
									     cpx_spc4_data_cx2[8] + cpx_spc4_data_cx2[12]  +
									     cpx_spc4_data_cx2[16] + cpx_spc4_data_cx2[20] +
									     cpx_spc4_data_cx2[24] + cpx_spc4_data_cx2[28] 
                                                                           ) :
                                  (cpx_spc4_data_cx2[122:121] == 2'b01) ? (
									     cpx_spc4_data_cx2[32] + cpx_spc4_data_cx2[35] +
									     cpx_spc4_data_cx2[38] + cpx_spc4_data_cx2[41] +
									     cpx_spc4_data_cx2[44] + cpx_spc4_data_cx2[47] +
									     cpx_spc4_data_cx2[50] + cpx_spc4_data_cx2[53] 
                                                                           ) :
                                  (cpx_spc4_data_cx2[122:121] == 2'b10) ? (
									     cpx_spc4_data_cx2[56] + cpx_spc4_data_cx2[60] +
									     cpx_spc4_data_cx2[64] + cpx_spc4_data_cx2[68] +
									     cpx_spc4_data_cx2[72] + cpx_spc4_data_cx2[76] +
									     cpx_spc4_data_cx2[80] + cpx_spc4_data_cx2[84] 
                                                                           ) :
									   ( cpx_spc4_data_cx2[88] + cpx_spc4_data_cx2[91] +
									     cpx_spc4_data_cx2[94] + cpx_spc4_data_cx2[97] +
									     cpx_spc4_data_cx2[100]+ cpx_spc4_data_cx2[103]+
									     cpx_spc4_data_cx2[106]+ cpx_spc4_data_cx2[109] 
                                                                           ) ;

  wire [5:0] cpx_spc4_st_ack_dc_inval_8c = {6{cpx_spc4_st_ack}} & cpx_spc4_st_ack_dc_inval_8c_tmp;

  wire [5:0] cpx_spc4_st_ack_ic_inval_8c_tmp = ~cpx_spc4_data_cx2[122] ? (
                                                                             cpx_spc4_data_cx2[1] + cpx_spc4_data_cx2[5]   +
                                                                             cpx_spc4_data_cx2[9] + cpx_spc4_data_cx2[13]  +
                                                                             cpx_spc4_data_cx2[17] + cpx_spc4_data_cx2[21] +
                                                                             cpx_spc4_data_cx2[25] + cpx_spc4_data_cx2[29] 
                                                                           ) :
                                                                           ( cpx_spc4_data_cx2[57] + cpx_spc4_data_cx2[61] +
                                                                             cpx_spc4_data_cx2[65] + cpx_spc4_data_cx2[69] +
                                                                             cpx_spc4_data_cx2[73] + cpx_spc4_data_cx2[77] +
                                                                             cpx_spc4_data_cx2[81] + cpx_spc4_data_cx2[85] 
                                                                           ) ;

  wire [5:0] cpx_spc4_st_ack_ic_inval_8c = {4{cpx_spc4_st_ack}} & cpx_spc4_st_ack_ic_inval_8c_tmp;

  wire [5:0] cpx_spc4_evict_dc_inval_8c_tmp = 
									     cpx_spc4_data_cx2[0] + cpx_spc4_data_cx2[4] +
									     cpx_spc4_data_cx2[8] + cpx_spc4_data_cx2[12] +
									     cpx_spc4_data_cx2[16] + cpx_spc4_data_cx2[20] +
									     cpx_spc4_data_cx2[24] + cpx_spc4_data_cx2[28] +
									     cpx_spc4_data_cx2[32] + cpx_spc4_data_cx2[35] +
									     cpx_spc4_data_cx2[38] + cpx_spc4_data_cx2[41] +
									     cpx_spc4_data_cx2[44] + cpx_spc4_data_cx2[47] +
									     cpx_spc4_data_cx2[50] + cpx_spc4_data_cx2[53] +
									     cpx_spc4_data_cx2[56] + cpx_spc4_data_cx2[60] +
									     cpx_spc4_data_cx2[64] + cpx_spc4_data_cx2[68] +
									     cpx_spc4_data_cx2[72] + cpx_spc4_data_cx2[76] +
									     cpx_spc4_data_cx2[80] + cpx_spc4_data_cx2[84] +
									     cpx_spc4_data_cx2[88] + cpx_spc4_data_cx2[91] +
									     cpx_spc4_data_cx2[94] + cpx_spc4_data_cx2[97] +
									     cpx_spc4_data_cx2[100]+ cpx_spc4_data_cx2[103]+
									     cpx_spc4_data_cx2[106]+ cpx_spc4_data_cx2[109];

  wire [5:0] cpx_spc4_evict_dc_inval_8c = {6{cpx_spc4_evict}} & cpx_spc4_evict_dc_inval_8c_tmp;

  wire [5:0] cpx_spc4_evict_ic_inval_8c_tmp = 
                                                                             cpx_spc4_data_cx2[1] + cpx_spc4_data_cx2[5] +
                                                                             cpx_spc4_data_cx2[9] + cpx_spc4_data_cx2[13] +
                                                                             cpx_spc4_data_cx2[17] + cpx_spc4_data_cx2[21] +
                                                                             cpx_spc4_data_cx2[25] + cpx_spc4_data_cx2[29] +
                                                                             cpx_spc4_data_cx2[57] + cpx_spc4_data_cx2[61] +
                                                                             cpx_spc4_data_cx2[65] + cpx_spc4_data_cx2[69] +
                                                                             cpx_spc4_data_cx2[73] + cpx_spc4_data_cx2[77] +
                                                                             cpx_spc4_data_cx2[81] + cpx_spc4_data_cx2[85];

  wire [5:0] cpx_spc4_evict_ic_inval_8c = {6{cpx_spc4_evict}} & cpx_spc4_evict_ic_inval_8c_tmp;

  reg [3:0] 	blk_st_cnt4;			// counts the number of block  stores without an acknowledge in between
  reg [3:0] 	ini_st_cnt4;			// counts the number of init   stores without an acknowledge in between
  reg  		st_blkst_mixture4;		// a flag set upon detection of block store and normal store mixture.
  reg  		st_inist_mixture4;		// a flag set upon detection of init  store and normal store mixture.
  reg 		atomic_ret4;			// atomic  cpx to spc package
  reg 		non_b2b_atomic_ret4;		// atomic  cpx to spc package did not return in back to back cycles
   wire                  cpx_spc5_data_vld 	= `TOP_MEMORY.cpx_spc5_data_cx2[`CPX_WIDTH-1]; 
   wire [`CPX_WIDTH-1:0] cpx_spc5_data_cx2	= `TOP_MEMORY.cpx_spc5_data_cx2[`CPX_WIDTH-1:0]; 

   reg [`CPX_WIDTH-1:0] cpx_spc5_data_cx2_d1;	// packet delayed by 1
   reg [`CPX_WIDTH-1:0] cpx_spc5_data_cx2_d2;	// packet delayed by 2
   reg [127:0]		spc5_pcx_type_str;		// packet type in string format for debug.

   reg [127:0]		cpx_spc5_type_str;		// in string format for debug

   wire [3:0]  		cpx_spc5_type     	= cpx_spc5_data_vld ? cpx_spc5_data_cx2[`CPX_RQ_HI:`CPX_RQ_LO] :4'h0;
   wire        		cpx_spc5_wyvld    	= cpx_spc5_data_cx2[`CPX_WYVLD] & cpx_spc5_data_vld;

   wire cpx_spc5_st_ack = (cpx_spc5_type == `ST_ACK) | (cpx_spc5_type == `STRST_ACK);
   wire cpx_spc5_evict  = (cpx_spc5_type == `EVICT_REQ);

   reg cpx_spc5_ifill_wyvld;
   reg cpx_spc5_dfill_wyvld;

  wire cpx_spc5_st_ack_dc_inval_1c_tmp = (cpx_spc5_data_cx2[122:121] == 2'b00) ?  cpx_spc5_data_cx2[0]  :
                                          (cpx_spc5_data_cx2[122:121] == 2'b01)   ?  cpx_spc5_data_cx2[32] :
                                          (cpx_spc5_data_cx2[122:121] == 2'b10)   ?  cpx_spc5_data_cx2[56] :
                                          					        cpx_spc5_data_cx2[88];

  wire [2:0] cpx_spc5_st_ack_dc_inval_1c = {2'b00, cpx_spc5_st_ack & cpx_spc5_st_ack_dc_inval_1c_tmp};

  wire cpx_spc5_st_ack_ic_inval_1c_tmp = cpx_spc5_data_cx2[122] ?  cpx_spc5_data_cx2[57] : cpx_spc5_data_cx2[1];
  wire [2:0] cpx_spc5_st_ack_ic_inval_1c = {2'b00, (cpx_spc5_st_ack & cpx_spc5_st_ack_ic_inval_1c_tmp)};
  wire [5:0] cpx_spc5_st_ack_icdc_inval_1c = {6{cpx_spc5_st_ack}} & 
					        {cpx_spc5_st_ack_ic_inval_1c, cpx_spc5_st_ack_dc_inval_1c};

  wire [2:0] cpx_spc5_evict_dc_inval_1c   = cpx_spc5_data_cx2[0]  + cpx_spc5_data_cx2[32] +
                                       cpx_spc5_data_cx2[56] + cpx_spc5_data_cx2[88];
  wire [1:0] cpx_spc5_evict_ic_inval_1c   = cpx_spc5_data_cx2[1]  + cpx_spc5_data_cx2[57];


  reg cpx_spc5_evict_d1;
  always @(posedge clk) 
    cpx_spc5_evict_d1 <= cpx_spc5_evict;

  wire cpx_spc5_b2b_evict = cpx_spc5_evict_d1 & cpx_spc5_evict;

  wire [5:0] cpx_spc5_evict_icdc_inval_1c;
  assign cpx_spc5_evict_icdc_inval_1c[4:0]={5{cpx_spc5_evict}} &
                                              {cpx_spc5_evict_ic_inval_1c,cpx_spc5_evict_dc_inval_1c};

  assign cpx_spc5_evict_icdc_inval_1c[5] = cpx_spc5_b2b_evict;

  wire [5:0] cpx_spc5_st_ack_dc_inval_8c_tmp = (cpx_spc5_data_cx2[122:121] == 2'b00) ? (
									     cpx_spc5_data_cx2[0] + cpx_spc5_data_cx2[4]   +
									     cpx_spc5_data_cx2[8] + cpx_spc5_data_cx2[12]  +
									     cpx_spc5_data_cx2[16] + cpx_spc5_data_cx2[20] +
									     cpx_spc5_data_cx2[24] + cpx_spc5_data_cx2[28] 
                                                                           ) :
                                  (cpx_spc5_data_cx2[122:121] == 2'b01) ? (
									     cpx_spc5_data_cx2[32] + cpx_spc5_data_cx2[35] +
									     cpx_spc5_data_cx2[38] + cpx_spc5_data_cx2[41] +
									     cpx_spc5_data_cx2[44] + cpx_spc5_data_cx2[47] +
									     cpx_spc5_data_cx2[50] + cpx_spc5_data_cx2[53] 
                                                                           ) :
                                  (cpx_spc5_data_cx2[122:121] == 2'b10) ? (
									     cpx_spc5_data_cx2[56] + cpx_spc5_data_cx2[60] +
									     cpx_spc5_data_cx2[64] + cpx_spc5_data_cx2[68] +
									     cpx_spc5_data_cx2[72] + cpx_spc5_data_cx2[76] +
									     cpx_spc5_data_cx2[80] + cpx_spc5_data_cx2[84] 
                                                                           ) :
									   ( cpx_spc5_data_cx2[88] + cpx_spc5_data_cx2[91] +
									     cpx_spc5_data_cx2[94] + cpx_spc5_data_cx2[97] +
									     cpx_spc5_data_cx2[100]+ cpx_spc5_data_cx2[103]+
									     cpx_spc5_data_cx2[106]+ cpx_spc5_data_cx2[109] 
                                                                           ) ;

  wire [5:0] cpx_spc5_st_ack_dc_inval_8c = {6{cpx_spc5_st_ack}} & cpx_spc5_st_ack_dc_inval_8c_tmp;

  wire [5:0] cpx_spc5_st_ack_ic_inval_8c_tmp = ~cpx_spc5_data_cx2[122] ? (
                                                                             cpx_spc5_data_cx2[1] + cpx_spc5_data_cx2[5]   +
                                                                             cpx_spc5_data_cx2[9] + cpx_spc5_data_cx2[13]  +
                                                                             cpx_spc5_data_cx2[17] + cpx_spc5_data_cx2[21] +
                                                                             cpx_spc5_data_cx2[25] + cpx_spc5_data_cx2[29] 
                                                                           ) :
                                                                           ( cpx_spc5_data_cx2[57] + cpx_spc5_data_cx2[61] +
                                                                             cpx_spc5_data_cx2[65] + cpx_spc5_data_cx2[69] +
                                                                             cpx_spc5_data_cx2[73] + cpx_spc5_data_cx2[77] +
                                                                             cpx_spc5_data_cx2[81] + cpx_spc5_data_cx2[85] 
                                                                           ) ;

  wire [5:0] cpx_spc5_st_ack_ic_inval_8c = {4{cpx_spc5_st_ack}} & cpx_spc5_st_ack_ic_inval_8c_tmp;

  wire [5:0] cpx_spc5_evict_dc_inval_8c_tmp = 
									     cpx_spc5_data_cx2[0] + cpx_spc5_data_cx2[4] +
									     cpx_spc5_data_cx2[8] + cpx_spc5_data_cx2[12] +
									     cpx_spc5_data_cx2[16] + cpx_spc5_data_cx2[20] +
									     cpx_spc5_data_cx2[24] + cpx_spc5_data_cx2[28] +
									     cpx_spc5_data_cx2[32] + cpx_spc5_data_cx2[35] +
									     cpx_spc5_data_cx2[38] + cpx_spc5_data_cx2[41] +
									     cpx_spc5_data_cx2[44] + cpx_spc5_data_cx2[47] +
									     cpx_spc5_data_cx2[50] + cpx_spc5_data_cx2[53] +
									     cpx_spc5_data_cx2[56] + cpx_spc5_data_cx2[60] +
									     cpx_spc5_data_cx2[64] + cpx_spc5_data_cx2[68] +
									     cpx_spc5_data_cx2[72] + cpx_spc5_data_cx2[76] +
									     cpx_spc5_data_cx2[80] + cpx_spc5_data_cx2[84] +
									     cpx_spc5_data_cx2[88] + cpx_spc5_data_cx2[91] +
									     cpx_spc5_data_cx2[94] + cpx_spc5_data_cx2[97] +
									     cpx_spc5_data_cx2[100]+ cpx_spc5_data_cx2[103]+
									     cpx_spc5_data_cx2[106]+ cpx_spc5_data_cx2[109];

  wire [5:0] cpx_spc5_evict_dc_inval_8c = {6{cpx_spc5_evict}} & cpx_spc5_evict_dc_inval_8c_tmp;

  wire [5:0] cpx_spc5_evict_ic_inval_8c_tmp = 
                                                                             cpx_spc5_data_cx2[1] + cpx_spc5_data_cx2[5] +
                                                                             cpx_spc5_data_cx2[9] + cpx_spc5_data_cx2[13] +
                                                                             cpx_spc5_data_cx2[17] + cpx_spc5_data_cx2[21] +
                                                                             cpx_spc5_data_cx2[25] + cpx_spc5_data_cx2[29] +
                                                                             cpx_spc5_data_cx2[57] + cpx_spc5_data_cx2[61] +
                                                                             cpx_spc5_data_cx2[65] + cpx_spc5_data_cx2[69] +
                                                                             cpx_spc5_data_cx2[73] + cpx_spc5_data_cx2[77] +
                                                                             cpx_spc5_data_cx2[81] + cpx_spc5_data_cx2[85];

  wire [5:0] cpx_spc5_evict_ic_inval_8c = {6{cpx_spc5_evict}} & cpx_spc5_evict_ic_inval_8c_tmp;

  reg [3:0] 	blk_st_cnt5;			// counts the number of block  stores without an acknowledge in between
  reg [3:0] 	ini_st_cnt5;			// counts the number of init   stores without an acknowledge in between
  reg  		st_blkst_mixture5;		// a flag set upon detection of block store and normal store mixture.
  reg  		st_inist_mixture5;		// a flag set upon detection of init  store and normal store mixture.
  reg 		atomic_ret5;			// atomic  cpx to spc package
  reg 		non_b2b_atomic_ret5;		// atomic  cpx to spc package did not return in back to back cycles
   wire                  cpx_spc6_data_vld 	= `TOP_MEMORY.cpx_spc6_data_cx2[`CPX_WIDTH-1]; 
   wire [`CPX_WIDTH-1:0] cpx_spc6_data_cx2	= `TOP_MEMORY.cpx_spc6_data_cx2[`CPX_WIDTH-1:0]; 

   reg [`CPX_WIDTH-1:0] cpx_spc6_data_cx2_d1;	// packet delayed by 1
   reg [`CPX_WIDTH-1:0] cpx_spc6_data_cx2_d2;	// packet delayed by 2
   reg [127:0]		spc6_pcx_type_str;		// packet type in string format for debug.

   reg [127:0]		cpx_spc6_type_str;		// in string format for debug

   wire [3:0]  		cpx_spc6_type     	= cpx_spc6_data_vld ? cpx_spc6_data_cx2[`CPX_RQ_HI:`CPX_RQ_LO] :4'h0;
   wire        		cpx_spc6_wyvld    	= cpx_spc6_data_cx2[`CPX_WYVLD] & cpx_spc6_data_vld;

   wire cpx_spc6_st_ack = (cpx_spc6_type == `ST_ACK) | (cpx_spc6_type == `STRST_ACK);
   wire cpx_spc6_evict  = (cpx_spc6_type == `EVICT_REQ);

   reg cpx_spc6_ifill_wyvld;
   reg cpx_spc6_dfill_wyvld;

  wire cpx_spc6_st_ack_dc_inval_1c_tmp = (cpx_spc6_data_cx2[122:121] == 2'b00) ?  cpx_spc6_data_cx2[0]  :
                                          (cpx_spc6_data_cx2[122:121] == 2'b01)   ?  cpx_spc6_data_cx2[32] :
                                          (cpx_spc6_data_cx2[122:121] == 2'b10)   ?  cpx_spc6_data_cx2[56] :
                                          					        cpx_spc6_data_cx2[88];

  wire [2:0] cpx_spc6_st_ack_dc_inval_1c = {2'b00, cpx_spc6_st_ack & cpx_spc6_st_ack_dc_inval_1c_tmp};

  wire cpx_spc6_st_ack_ic_inval_1c_tmp = cpx_spc6_data_cx2[122] ?  cpx_spc6_data_cx2[57] : cpx_spc6_data_cx2[1];
  wire [2:0] cpx_spc6_st_ack_ic_inval_1c = {2'b00, (cpx_spc6_st_ack & cpx_spc6_st_ack_ic_inval_1c_tmp)};
  wire [5:0] cpx_spc6_st_ack_icdc_inval_1c = {6{cpx_spc6_st_ack}} & 
					        {cpx_spc6_st_ack_ic_inval_1c, cpx_spc6_st_ack_dc_inval_1c};

  wire [2:0] cpx_spc6_evict_dc_inval_1c   = cpx_spc6_data_cx2[0]  + cpx_spc6_data_cx2[32] +
                                       cpx_spc6_data_cx2[56] + cpx_spc6_data_cx2[88];
  wire [1:0] cpx_spc6_evict_ic_inval_1c   = cpx_spc6_data_cx2[1]  + cpx_spc6_data_cx2[57];


  reg cpx_spc6_evict_d1;
  always @(posedge clk) 
    cpx_spc6_evict_d1 <= cpx_spc6_evict;

  wire cpx_spc6_b2b_evict = cpx_spc6_evict_d1 & cpx_spc6_evict;

  wire [5:0] cpx_spc6_evict_icdc_inval_1c;
  assign cpx_spc6_evict_icdc_inval_1c[4:0]={5{cpx_spc6_evict}} &
                                              {cpx_spc6_evict_ic_inval_1c,cpx_spc6_evict_dc_inval_1c};

  assign cpx_spc6_evict_icdc_inval_1c[5] = cpx_spc6_b2b_evict;

  wire [5:0] cpx_spc6_st_ack_dc_inval_8c_tmp = (cpx_spc6_data_cx2[122:121] == 2'b00) ? (
									     cpx_spc6_data_cx2[0] + cpx_spc6_data_cx2[4]   +
									     cpx_spc6_data_cx2[8] + cpx_spc6_data_cx2[12]  +
									     cpx_spc6_data_cx2[16] + cpx_spc6_data_cx2[20] +
									     cpx_spc6_data_cx2[24] + cpx_spc6_data_cx2[28] 
                                                                           ) :
                                  (cpx_spc6_data_cx2[122:121] == 2'b01) ? (
									     cpx_spc6_data_cx2[32] + cpx_spc6_data_cx2[35] +
									     cpx_spc6_data_cx2[38] + cpx_spc6_data_cx2[41] +
									     cpx_spc6_data_cx2[44] + cpx_spc6_data_cx2[47] +
									     cpx_spc6_data_cx2[50] + cpx_spc6_data_cx2[53] 
                                                                           ) :
                                  (cpx_spc6_data_cx2[122:121] == 2'b10) ? (
									     cpx_spc6_data_cx2[56] + cpx_spc6_data_cx2[60] +
									     cpx_spc6_data_cx2[64] + cpx_spc6_data_cx2[68] +
									     cpx_spc6_data_cx2[72] + cpx_spc6_data_cx2[76] +
									     cpx_spc6_data_cx2[80] + cpx_spc6_data_cx2[84] 
                                                                           ) :
									   ( cpx_spc6_data_cx2[88] + cpx_spc6_data_cx2[91] +
									     cpx_spc6_data_cx2[94] + cpx_spc6_data_cx2[97] +
									     cpx_spc6_data_cx2[100]+ cpx_spc6_data_cx2[103]+
									     cpx_spc6_data_cx2[106]+ cpx_spc6_data_cx2[109] 
                                                                           ) ;

  wire [5:0] cpx_spc6_st_ack_dc_inval_8c = {6{cpx_spc6_st_ack}} & cpx_spc6_st_ack_dc_inval_8c_tmp;

  wire [5:0] cpx_spc6_st_ack_ic_inval_8c_tmp = ~cpx_spc6_data_cx2[122] ? (
                                                                             cpx_spc6_data_cx2[1] + cpx_spc6_data_cx2[5]   +
                                                                             cpx_spc6_data_cx2[9] + cpx_spc6_data_cx2[13]  +
                                                                             cpx_spc6_data_cx2[17] + cpx_spc6_data_cx2[21] +
                                                                             cpx_spc6_data_cx2[25] + cpx_spc6_data_cx2[29] 
                                                                           ) :
                                                                           ( cpx_spc6_data_cx2[57] + cpx_spc6_data_cx2[61] +
                                                                             cpx_spc6_data_cx2[65] + cpx_spc6_data_cx2[69] +
                                                                             cpx_spc6_data_cx2[73] + cpx_spc6_data_cx2[77] +
                                                                             cpx_spc6_data_cx2[81] + cpx_spc6_data_cx2[85] 
                                                                           ) ;

  wire [5:0] cpx_spc6_st_ack_ic_inval_8c = {4{cpx_spc6_st_ack}} & cpx_spc6_st_ack_ic_inval_8c_tmp;

  wire [5:0] cpx_spc6_evict_dc_inval_8c_tmp = 
									     cpx_spc6_data_cx2[0] + cpx_spc6_data_cx2[4] +
									     cpx_spc6_data_cx2[8] + cpx_spc6_data_cx2[12] +
									     cpx_spc6_data_cx2[16] + cpx_spc6_data_cx2[20] +
									     cpx_spc6_data_cx2[24] + cpx_spc6_data_cx2[28] +
									     cpx_spc6_data_cx2[32] + cpx_spc6_data_cx2[35] +
									     cpx_spc6_data_cx2[38] + cpx_spc6_data_cx2[41] +
									     cpx_spc6_data_cx2[44] + cpx_spc6_data_cx2[47] +
									     cpx_spc6_data_cx2[50] + cpx_spc6_data_cx2[53] +
									     cpx_spc6_data_cx2[56] + cpx_spc6_data_cx2[60] +
									     cpx_spc6_data_cx2[64] + cpx_spc6_data_cx2[68] +
									     cpx_spc6_data_cx2[72] + cpx_spc6_data_cx2[76] +
									     cpx_spc6_data_cx2[80] + cpx_spc6_data_cx2[84] +
									     cpx_spc6_data_cx2[88] + cpx_spc6_data_cx2[91] +
									     cpx_spc6_data_cx2[94] + cpx_spc6_data_cx2[97] +
									     cpx_spc6_data_cx2[100]+ cpx_spc6_data_cx2[103]+
									     cpx_spc6_data_cx2[106]+ cpx_spc6_data_cx2[109];

  wire [5:0] cpx_spc6_evict_dc_inval_8c = {6{cpx_spc6_evict}} & cpx_spc6_evict_dc_inval_8c_tmp;

  wire [5:0] cpx_spc6_evict_ic_inval_8c_tmp = 
                                                                             cpx_spc6_data_cx2[1] + cpx_spc6_data_cx2[5] +
                                                                             cpx_spc6_data_cx2[9] + cpx_spc6_data_cx2[13] +
                                                                             cpx_spc6_data_cx2[17] + cpx_spc6_data_cx2[21] +
                                                                             cpx_spc6_data_cx2[25] + cpx_spc6_data_cx2[29] +
                                                                             cpx_spc6_data_cx2[57] + cpx_spc6_data_cx2[61] +
                                                                             cpx_spc6_data_cx2[65] + cpx_spc6_data_cx2[69] +
                                                                             cpx_spc6_data_cx2[73] + cpx_spc6_data_cx2[77] +
                                                                             cpx_spc6_data_cx2[81] + cpx_spc6_data_cx2[85];

  wire [5:0] cpx_spc6_evict_ic_inval_8c = {6{cpx_spc6_evict}} & cpx_spc6_evict_ic_inval_8c_tmp;

  reg [3:0] 	blk_st_cnt6;			// counts the number of block  stores without an acknowledge in between
  reg [3:0] 	ini_st_cnt6;			// counts the number of init   stores without an acknowledge in between
  reg  		st_blkst_mixture6;		// a flag set upon detection of block store and normal store mixture.
  reg  		st_inist_mixture6;		// a flag set upon detection of init  store and normal store mixture.
  reg 		atomic_ret6;			// atomic  cpx to spc package
  reg 		non_b2b_atomic_ret6;		// atomic  cpx to spc package did not return in back to back cycles
   wire                  cpx_spc7_data_vld 	= `TOP_MEMORY.cpx_spc7_data_cx2[`CPX_WIDTH-1]; 
   wire [`CPX_WIDTH-1:0] cpx_spc7_data_cx2	= `TOP_MEMORY.cpx_spc7_data_cx2[`CPX_WIDTH-1:0]; 

   reg [`CPX_WIDTH-1:0] cpx_spc7_data_cx2_d1;	// packet delayed by 1
   reg [`CPX_WIDTH-1:0] cpx_spc7_data_cx2_d2;	// packet delayed by 2
   reg [127:0]		spc7_pcx_type_str;		// packet type in string format for debug.

   reg [127:0]		cpx_spc7_type_str;		// in string format for debug

   wire [3:0]  		cpx_spc7_type     	= cpx_spc7_data_vld ? cpx_spc7_data_cx2[`CPX_RQ_HI:`CPX_RQ_LO] :4'h0;
   wire        		cpx_spc7_wyvld    	= cpx_spc7_data_cx2[`CPX_WYVLD] & cpx_spc7_data_vld;

   wire cpx_spc7_st_ack = (cpx_spc7_type == `ST_ACK) | (cpx_spc7_type == `STRST_ACK);
   wire cpx_spc7_evict  = (cpx_spc7_type == `EVICT_REQ);

   reg cpx_spc7_ifill_wyvld;
   reg cpx_spc7_dfill_wyvld;

  wire cpx_spc7_st_ack_dc_inval_1c_tmp = (cpx_spc7_data_cx2[122:121] == 2'b00) ?  cpx_spc7_data_cx2[0]  :
                                          (cpx_spc7_data_cx2[122:121] == 2'b01)   ?  cpx_spc7_data_cx2[32] :
                                          (cpx_spc7_data_cx2[122:121] == 2'b10)   ?  cpx_spc7_data_cx2[56] :
                                          					        cpx_spc7_data_cx2[88];

  wire [2:0] cpx_spc7_st_ack_dc_inval_1c = {2'b00, cpx_spc7_st_ack & cpx_spc7_st_ack_dc_inval_1c_tmp};

  wire cpx_spc7_st_ack_ic_inval_1c_tmp = cpx_spc7_data_cx2[122] ?  cpx_spc7_data_cx2[57] : cpx_spc7_data_cx2[1];
  wire [2:0] cpx_spc7_st_ack_ic_inval_1c = {2'b00, (cpx_spc7_st_ack & cpx_spc7_st_ack_ic_inval_1c_tmp)};
  wire [5:0] cpx_spc7_st_ack_icdc_inval_1c = {6{cpx_spc7_st_ack}} & 
					        {cpx_spc7_st_ack_ic_inval_1c, cpx_spc7_st_ack_dc_inval_1c};

  wire [2:0] cpx_spc7_evict_dc_inval_1c   = cpx_spc7_data_cx2[0]  + cpx_spc7_data_cx2[32] +
                                       cpx_spc7_data_cx2[56] + cpx_spc7_data_cx2[88];
  wire [1:0] cpx_spc7_evict_ic_inval_1c   = cpx_spc7_data_cx2[1]  + cpx_spc7_data_cx2[57];


  reg cpx_spc7_evict_d1;
  always @(posedge clk) 
    cpx_spc7_evict_d1 <= cpx_spc7_evict;

  wire cpx_spc7_b2b_evict = cpx_spc7_evict_d1 & cpx_spc7_evict;

  wire [5:0] cpx_spc7_evict_icdc_inval_1c;
  assign cpx_spc7_evict_icdc_inval_1c[4:0]={5{cpx_spc7_evict}} &
                                              {cpx_spc7_evict_ic_inval_1c,cpx_spc7_evict_dc_inval_1c};

  assign cpx_spc7_evict_icdc_inval_1c[5] = cpx_spc7_b2b_evict;

  wire [5:0] cpx_spc7_st_ack_dc_inval_8c_tmp = (cpx_spc7_data_cx2[122:121] == 2'b00) ? (
									     cpx_spc7_data_cx2[0] + cpx_spc7_data_cx2[4]   +
									     cpx_spc7_data_cx2[8] + cpx_spc7_data_cx2[12]  +
									     cpx_spc7_data_cx2[16] + cpx_spc7_data_cx2[20] +
									     cpx_spc7_data_cx2[24] + cpx_spc7_data_cx2[28] 
                                                                           ) :
                                  (cpx_spc7_data_cx2[122:121] == 2'b01) ? (
									     cpx_spc7_data_cx2[32] + cpx_spc7_data_cx2[35] +
									     cpx_spc7_data_cx2[38] + cpx_spc7_data_cx2[41] +
									     cpx_spc7_data_cx2[44] + cpx_spc7_data_cx2[47] +
									     cpx_spc7_data_cx2[50] + cpx_spc7_data_cx2[53] 
                                                                           ) :
                                  (cpx_spc7_data_cx2[122:121] == 2'b10) ? (
									     cpx_spc7_data_cx2[56] + cpx_spc7_data_cx2[60] +
									     cpx_spc7_data_cx2[64] + cpx_spc7_data_cx2[68] +
									     cpx_spc7_data_cx2[72] + cpx_spc7_data_cx2[76] +
									     cpx_spc7_data_cx2[80] + cpx_spc7_data_cx2[84] 
                                                                           ) :
									   ( cpx_spc7_data_cx2[88] + cpx_spc7_data_cx2[91] +
									     cpx_spc7_data_cx2[94] + cpx_spc7_data_cx2[97] +
									     cpx_spc7_data_cx2[100]+ cpx_spc7_data_cx2[103]+
									     cpx_spc7_data_cx2[106]+ cpx_spc7_data_cx2[109] 
                                                                           ) ;

  wire [5:0] cpx_spc7_st_ack_dc_inval_8c = {6{cpx_spc7_st_ack}} & cpx_spc7_st_ack_dc_inval_8c_tmp;

  wire [5:0] cpx_spc7_st_ack_ic_inval_8c_tmp = ~cpx_spc7_data_cx2[122] ? (
                                                                             cpx_spc7_data_cx2[1] + cpx_spc7_data_cx2[5]   +
                                                                             cpx_spc7_data_cx2[9] + cpx_spc7_data_cx2[13]  +
                                                                             cpx_spc7_data_cx2[17] + cpx_spc7_data_cx2[21] +
                                                                             cpx_spc7_data_cx2[25] + cpx_spc7_data_cx2[29] 
                                                                           ) :
                                                                           ( cpx_spc7_data_cx2[57] + cpx_spc7_data_cx2[61] +
                                                                             cpx_spc7_data_cx2[65] + cpx_spc7_data_cx2[69] +
                                                                             cpx_spc7_data_cx2[73] + cpx_spc7_data_cx2[77] +
                                                                             cpx_spc7_data_cx2[81] + cpx_spc7_data_cx2[85] 
                                                                           ) ;

  wire [5:0] cpx_spc7_st_ack_ic_inval_8c = {4{cpx_spc7_st_ack}} & cpx_spc7_st_ack_ic_inval_8c_tmp;

  wire [5:0] cpx_spc7_evict_dc_inval_8c_tmp = 
									     cpx_spc7_data_cx2[0] + cpx_spc7_data_cx2[4] +
									     cpx_spc7_data_cx2[8] + cpx_spc7_data_cx2[12] +
									     cpx_spc7_data_cx2[16] + cpx_spc7_data_cx2[20] +
									     cpx_spc7_data_cx2[24] + cpx_spc7_data_cx2[28] +
									     cpx_spc7_data_cx2[32] + cpx_spc7_data_cx2[35] +
									     cpx_spc7_data_cx2[38] + cpx_spc7_data_cx2[41] +
									     cpx_spc7_data_cx2[44] + cpx_spc7_data_cx2[47] +
									     cpx_spc7_data_cx2[50] + cpx_spc7_data_cx2[53] +
									     cpx_spc7_data_cx2[56] + cpx_spc7_data_cx2[60] +
									     cpx_spc7_data_cx2[64] + cpx_spc7_data_cx2[68] +
									     cpx_spc7_data_cx2[72] + cpx_spc7_data_cx2[76] +
									     cpx_spc7_data_cx2[80] + cpx_spc7_data_cx2[84] +
									     cpx_spc7_data_cx2[88] + cpx_spc7_data_cx2[91] +
									     cpx_spc7_data_cx2[94] + cpx_spc7_data_cx2[97] +
									     cpx_spc7_data_cx2[100]+ cpx_spc7_data_cx2[103]+
									     cpx_spc7_data_cx2[106]+ cpx_spc7_data_cx2[109];

  wire [5:0] cpx_spc7_evict_dc_inval_8c = {6{cpx_spc7_evict}} & cpx_spc7_evict_dc_inval_8c_tmp;

  wire [5:0] cpx_spc7_evict_ic_inval_8c_tmp = 
                                                                             cpx_spc7_data_cx2[1] + cpx_spc7_data_cx2[5] +
                                                                             cpx_spc7_data_cx2[9] + cpx_spc7_data_cx2[13] +
                                                                             cpx_spc7_data_cx2[17] + cpx_spc7_data_cx2[21] +
                                                                             cpx_spc7_data_cx2[25] + cpx_spc7_data_cx2[29] +
                                                                             cpx_spc7_data_cx2[57] + cpx_spc7_data_cx2[61] +
                                                                             cpx_spc7_data_cx2[65] + cpx_spc7_data_cx2[69] +
                                                                             cpx_spc7_data_cx2[73] + cpx_spc7_data_cx2[77] +
                                                                             cpx_spc7_data_cx2[81] + cpx_spc7_data_cx2[85];

  wire [5:0] cpx_spc7_evict_ic_inval_8c = {6{cpx_spc7_evict}} & cpx_spc7_evict_ic_inval_8c_tmp;

  reg [3:0] 	blk_st_cnt7;			// counts the number of block  stores without an acknowledge in between
  reg [3:0] 	ini_st_cnt7;			// counts the number of init   stores without an acknowledge in between
  reg  		st_blkst_mixture7;		// a flag set upon detection of block store and normal store mixture.
  reg  		st_inist_mixture7;		// a flag set upon detection of init  store and normal store mixture.
  reg 		atomic_ret7;			// atomic  cpx to spc package
  reg 		non_b2b_atomic_ret7;		// atomic  cpx to spc package did not return in back to back cycles

//----------------------------------------------------------------------------------------
// The real thing starts somewhere here
//----------------------------------------------------------------------------------------
  
// This check belongs to another monitor (PLL) but since the PLL monitor does not
// exist and I do want this chip to work I put it here. 
//--------------------------------------------------------------------------------
always @(posedge clk)
begin
  if(rst_l & ~pll_lock & ~disable_lock_check)
    finish_test("tso_mon", "PLL is not locked", 0);
end

always @(posedge clk)
begin
  pcx0_vld_d1 	<= spc0_pcx_data_pa[123];
  pcx0_type_d1 	<= spc0_pcx_data_pa[122:118];
  pcx0_req_pq_d1 	<= |spc0_pcx_req_pq;
  pcx0_atom_pq_d1 	<= spc0_pcx_atom_pq;
  pcx0_atom_pq_d2 	<= pcx0_atom_pq_d1;


// Multiple block stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc0_type == `ST_ACK) | ~rst_l)
    blk_st_cnt0 <=  4'h0;
  else if(pcx0_req_pq_d1 & (spc0_pcx_data_pa[122:118] == `STORE_RQ) & spc0_pcx_data_pa[109] & spc0_pcx_data_pa[110])
    blk_st_cnt0 <= blk_st_cnt0 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(blk_st_cnt0 & (spc0_pcx_data_pa[122:118] == `STORE_RQ) & ~spc0_pcx_data_pa[109])
    st_blkst_mixture0 <= 1'b1;
  else if(blk_st_cnt0 == 4'h0)
    st_blkst_mixture0 <= 1'b0;

// Multiple init stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc0_type == `ST_ACK) | ~rst_l)
    ini_st_cnt0 <=  4'h0;
  else if(pcx0_req_pq_d1 & (spc0_pcx_data_pa[122:118] == `STORE_RQ) & spc0_pcx_data_pa[109] & ~spc0_pcx_data_pa[110])
    ini_st_cnt0 <= ini_st_cnt0 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(ini_st_cnt0 && (spc0_pcx_data_pa[122:118] == `STORE_RQ) & ~spc0_pcx_data_pa[109])
    st_inist_mixture0 <= 1'b1;
  else if(ini_st_cnt0 == 4'h0)
    st_inist_mixture0 <= 1'b0;

  if(~rst_l)
    cpx_spc0_ifill_wyvld <= 1'b0;
  else 
    cpx_spc0_ifill_wyvld <= ((cpx_spc0_type == `IFILL_RET) & cpx_spc0_wyvld);
  
  if(~rst_l)
    cpx_spc0_dfill_wyvld <= 1'b0;
  else 
    cpx_spc0_dfill_wyvld <= ((cpx_spc0_type == `LOAD_RET) & cpx_spc0_wyvld);

  pcx1_vld_d1 	<= spc1_pcx_data_pa[123];
  pcx1_type_d1 	<= spc1_pcx_data_pa[122:118];
  pcx1_req_pq_d1 	<= |spc1_pcx_req_pq;
  pcx1_atom_pq_d1 	<= spc1_pcx_atom_pq;
  pcx1_atom_pq_d2 	<= pcx1_atom_pq_d1;


// Multiple block stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc1_type == `ST_ACK) | ~rst_l)
    blk_st_cnt1 <=  4'h0;
  else if(pcx1_req_pq_d1 & (spc1_pcx_data_pa[122:118] == `STORE_RQ) & spc1_pcx_data_pa[109] & spc1_pcx_data_pa[110])
    blk_st_cnt1 <= blk_st_cnt1 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(blk_st_cnt1 & (spc1_pcx_data_pa[122:118] == `STORE_RQ) & ~spc1_pcx_data_pa[109])
    st_blkst_mixture1 <= 1'b1;
  else if(blk_st_cnt1 == 4'h0)
    st_blkst_mixture1 <= 1'b0;

// Multiple init stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc1_type == `ST_ACK) | ~rst_l)
    ini_st_cnt1 <=  4'h0;
  else if(pcx1_req_pq_d1 & (spc1_pcx_data_pa[122:118] == `STORE_RQ) & spc1_pcx_data_pa[109] & ~spc1_pcx_data_pa[110])
    ini_st_cnt1 <= ini_st_cnt1 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(ini_st_cnt1 && (spc1_pcx_data_pa[122:118] == `STORE_RQ) & ~spc1_pcx_data_pa[109])
    st_inist_mixture1 <= 1'b1;
  else if(ini_st_cnt1 == 4'h0)
    st_inist_mixture1 <= 1'b0;

  if(~rst_l)
    cpx_spc1_ifill_wyvld <= 1'b0;
  else 
    cpx_spc1_ifill_wyvld <= ((cpx_spc1_type == `IFILL_RET) & cpx_spc1_wyvld);
  
  if(~rst_l)
    cpx_spc1_dfill_wyvld <= 1'b0;
  else 
    cpx_spc1_dfill_wyvld <= ((cpx_spc1_type == `LOAD_RET) & cpx_spc1_wyvld);

  pcx2_vld_d1 	<= spc2_pcx_data_pa[123];
  pcx2_type_d1 	<= spc2_pcx_data_pa[122:118];
  pcx2_req_pq_d1 	<= |spc2_pcx_req_pq;
  pcx2_atom_pq_d1 	<= spc2_pcx_atom_pq;
  pcx2_atom_pq_d2 	<= pcx2_atom_pq_d1;


// Multiple block stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc2_type == `ST_ACK) | ~rst_l)
    blk_st_cnt2 <=  4'h0;
  else if(pcx2_req_pq_d1 & (spc2_pcx_data_pa[122:118] == `STORE_RQ) & spc2_pcx_data_pa[109] & spc2_pcx_data_pa[110])
    blk_st_cnt2 <= blk_st_cnt2 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(blk_st_cnt2 & (spc2_pcx_data_pa[122:118] == `STORE_RQ) & ~spc2_pcx_data_pa[109])
    st_blkst_mixture2 <= 1'b1;
  else if(blk_st_cnt2 == 4'h0)
    st_blkst_mixture2 <= 1'b0;

// Multiple init stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc2_type == `ST_ACK) | ~rst_l)
    ini_st_cnt2 <=  4'h0;
  else if(pcx2_req_pq_d1 & (spc2_pcx_data_pa[122:118] == `STORE_RQ) & spc2_pcx_data_pa[109] & ~spc2_pcx_data_pa[110])
    ini_st_cnt2 <= ini_st_cnt2 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(ini_st_cnt2 && (spc2_pcx_data_pa[122:118] == `STORE_RQ) & ~spc2_pcx_data_pa[109])
    st_inist_mixture2 <= 1'b1;
  else if(ini_st_cnt2 == 4'h0)
    st_inist_mixture2 <= 1'b0;

  if(~rst_l)
    cpx_spc2_ifill_wyvld <= 1'b0;
  else 
    cpx_spc2_ifill_wyvld <= ((cpx_spc2_type == `IFILL_RET) & cpx_spc2_wyvld);
  
  if(~rst_l)
    cpx_spc2_dfill_wyvld <= 1'b0;
  else 
    cpx_spc2_dfill_wyvld <= ((cpx_spc2_type == `LOAD_RET) & cpx_spc2_wyvld);

  pcx3_vld_d1 	<= spc3_pcx_data_pa[123];
  pcx3_type_d1 	<= spc3_pcx_data_pa[122:118];
  pcx3_req_pq_d1 	<= |spc3_pcx_req_pq;
  pcx3_atom_pq_d1 	<= spc3_pcx_atom_pq;
  pcx3_atom_pq_d2 	<= pcx3_atom_pq_d1;


// Multiple block stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc3_type == `ST_ACK) | ~rst_l)
    blk_st_cnt3 <=  4'h0;
  else if(pcx3_req_pq_d1 & (spc3_pcx_data_pa[122:118] == `STORE_RQ) & spc3_pcx_data_pa[109] & spc3_pcx_data_pa[110])
    blk_st_cnt3 <= blk_st_cnt3 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(blk_st_cnt3 & (spc3_pcx_data_pa[122:118] == `STORE_RQ) & ~spc3_pcx_data_pa[109])
    st_blkst_mixture3 <= 1'b1;
  else if(blk_st_cnt3 == 4'h0)
    st_blkst_mixture3 <= 1'b0;

// Multiple init stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc3_type == `ST_ACK) | ~rst_l)
    ini_st_cnt3 <=  4'h0;
  else if(pcx3_req_pq_d1 & (spc3_pcx_data_pa[122:118] == `STORE_RQ) & spc3_pcx_data_pa[109] & ~spc3_pcx_data_pa[110])
    ini_st_cnt3 <= ini_st_cnt3 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(ini_st_cnt3 && (spc3_pcx_data_pa[122:118] == `STORE_RQ) & ~spc3_pcx_data_pa[109])
    st_inist_mixture3 <= 1'b1;
  else if(ini_st_cnt3 == 4'h0)
    st_inist_mixture3 <= 1'b0;

  if(~rst_l)
    cpx_spc3_ifill_wyvld <= 1'b0;
  else 
    cpx_spc3_ifill_wyvld <= ((cpx_spc3_type == `IFILL_RET) & cpx_spc3_wyvld);
  
  if(~rst_l)
    cpx_spc3_dfill_wyvld <= 1'b0;
  else 
    cpx_spc3_dfill_wyvld <= ((cpx_spc3_type == `LOAD_RET) & cpx_spc3_wyvld);

  pcx4_vld_d1 	<= spc4_pcx_data_pa[123];
  pcx4_type_d1 	<= spc4_pcx_data_pa[122:118];
  pcx4_req_pq_d1 	<= |spc4_pcx_req_pq;
  pcx4_atom_pq_d1 	<= spc4_pcx_atom_pq;
  pcx4_atom_pq_d2 	<= pcx4_atom_pq_d1;


// Multiple block stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc4_type == `ST_ACK) | ~rst_l)
    blk_st_cnt4 <=  4'h0;
  else if(pcx4_req_pq_d1 & (spc4_pcx_data_pa[122:118] == `STORE_RQ) & spc4_pcx_data_pa[109] & spc4_pcx_data_pa[110])
    blk_st_cnt4 <= blk_st_cnt4 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(blk_st_cnt4 & (spc4_pcx_data_pa[122:118] == `STORE_RQ) & ~spc4_pcx_data_pa[109])
    st_blkst_mixture4 <= 1'b1;
  else if(blk_st_cnt4 == 4'h0)
    st_blkst_mixture4 <= 1'b0;

// Multiple init stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc4_type == `ST_ACK) | ~rst_l)
    ini_st_cnt4 <=  4'h0;
  else if(pcx4_req_pq_d1 & (spc4_pcx_data_pa[122:118] == `STORE_RQ) & spc4_pcx_data_pa[109] & ~spc4_pcx_data_pa[110])
    ini_st_cnt4 <= ini_st_cnt4 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(ini_st_cnt4 && (spc4_pcx_data_pa[122:118] == `STORE_RQ) & ~spc4_pcx_data_pa[109])
    st_inist_mixture4 <= 1'b1;
  else if(ini_st_cnt4 == 4'h0)
    st_inist_mixture4 <= 1'b0;

  if(~rst_l)
    cpx_spc4_ifill_wyvld <= 1'b0;
  else 
    cpx_spc4_ifill_wyvld <= ((cpx_spc4_type == `IFILL_RET) & cpx_spc4_wyvld);
  
  if(~rst_l)
    cpx_spc4_dfill_wyvld <= 1'b0;
  else 
    cpx_spc4_dfill_wyvld <= ((cpx_spc4_type == `LOAD_RET) & cpx_spc4_wyvld);

  pcx5_vld_d1 	<= spc5_pcx_data_pa[123];
  pcx5_type_d1 	<= spc5_pcx_data_pa[122:118];
  pcx5_req_pq_d1 	<= |spc5_pcx_req_pq;
  pcx5_atom_pq_d1 	<= spc5_pcx_atom_pq;
  pcx5_atom_pq_d2 	<= pcx5_atom_pq_d1;


// Multiple block stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc5_type == `ST_ACK) | ~rst_l)
    blk_st_cnt5 <=  4'h0;
  else if(pcx5_req_pq_d1 & (spc5_pcx_data_pa[122:118] == `STORE_RQ) & spc5_pcx_data_pa[109] & spc5_pcx_data_pa[110])
    blk_st_cnt5 <= blk_st_cnt5 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(blk_st_cnt5 & (spc5_pcx_data_pa[122:118] == `STORE_RQ) & ~spc5_pcx_data_pa[109])
    st_blkst_mixture5 <= 1'b1;
  else if(blk_st_cnt5 == 4'h0)
    st_blkst_mixture5 <= 1'b0;

// Multiple init stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc5_type == `ST_ACK) | ~rst_l)
    ini_st_cnt5 <=  4'h0;
  else if(pcx5_req_pq_d1 & (spc5_pcx_data_pa[122:118] == `STORE_RQ) & spc5_pcx_data_pa[109] & ~spc5_pcx_data_pa[110])
    ini_st_cnt5 <= ini_st_cnt5 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(ini_st_cnt5 && (spc5_pcx_data_pa[122:118] == `STORE_RQ) & ~spc5_pcx_data_pa[109])
    st_inist_mixture5 <= 1'b1;
  else if(ini_st_cnt5 == 4'h0)
    st_inist_mixture5 <= 1'b0;

  if(~rst_l)
    cpx_spc5_ifill_wyvld <= 1'b0;
  else 
    cpx_spc5_ifill_wyvld <= ((cpx_spc5_type == `IFILL_RET) & cpx_spc5_wyvld);
  
  if(~rst_l)
    cpx_spc5_dfill_wyvld <= 1'b0;
  else 
    cpx_spc5_dfill_wyvld <= ((cpx_spc5_type == `LOAD_RET) & cpx_spc5_wyvld);

  pcx6_vld_d1 	<= spc6_pcx_data_pa[123];
  pcx6_type_d1 	<= spc6_pcx_data_pa[122:118];
  pcx6_req_pq_d1 	<= |spc6_pcx_req_pq;
  pcx6_atom_pq_d1 	<= spc6_pcx_atom_pq;
  pcx6_atom_pq_d2 	<= pcx6_atom_pq_d1;


// Multiple block stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc6_type == `ST_ACK) | ~rst_l)
    blk_st_cnt6 <=  4'h0;
  else if(pcx6_req_pq_d1 & (spc6_pcx_data_pa[122:118] == `STORE_RQ) & spc6_pcx_data_pa[109] & spc6_pcx_data_pa[110])
    blk_st_cnt6 <= blk_st_cnt6 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(blk_st_cnt6 & (spc6_pcx_data_pa[122:118] == `STORE_RQ) & ~spc6_pcx_data_pa[109])
    st_blkst_mixture6 <= 1'b1;
  else if(blk_st_cnt6 == 4'h0)
    st_blkst_mixture6 <= 1'b0;

// Multiple init stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc6_type == `ST_ACK) | ~rst_l)
    ini_st_cnt6 <=  4'h0;
  else if(pcx6_req_pq_d1 & (spc6_pcx_data_pa[122:118] == `STORE_RQ) & spc6_pcx_data_pa[109] & ~spc6_pcx_data_pa[110])
    ini_st_cnt6 <= ini_st_cnt6 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(ini_st_cnt6 && (spc6_pcx_data_pa[122:118] == `STORE_RQ) & ~spc6_pcx_data_pa[109])
    st_inist_mixture6 <= 1'b1;
  else if(ini_st_cnt6 == 4'h0)
    st_inist_mixture6 <= 1'b0;

  if(~rst_l)
    cpx_spc6_ifill_wyvld <= 1'b0;
  else 
    cpx_spc6_ifill_wyvld <= ((cpx_spc6_type == `IFILL_RET) & cpx_spc6_wyvld);
  
  if(~rst_l)
    cpx_spc6_dfill_wyvld <= 1'b0;
  else 
    cpx_spc6_dfill_wyvld <= ((cpx_spc6_type == `LOAD_RET) & cpx_spc6_wyvld);

  pcx7_vld_d1 	<= spc7_pcx_data_pa[123];
  pcx7_type_d1 	<= spc7_pcx_data_pa[122:118];
  pcx7_req_pq_d1 	<= |spc7_pcx_req_pq;
  pcx7_atom_pq_d1 	<= spc7_pcx_atom_pq;
  pcx7_atom_pq_d2 	<= pcx7_atom_pq_d1;


// Multiple block stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc7_type == `ST_ACK) | ~rst_l)
    blk_st_cnt7 <=  4'h0;
  else if(pcx7_req_pq_d1 & (spc7_pcx_data_pa[122:118] == `STORE_RQ) & spc7_pcx_data_pa[109] & spc7_pcx_data_pa[110])
    blk_st_cnt7 <= blk_st_cnt7 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(blk_st_cnt7 & (spc7_pcx_data_pa[122:118] == `STORE_RQ) & ~spc7_pcx_data_pa[109])
    st_blkst_mixture7 <= 1'b1;
  else if(blk_st_cnt7 == 4'h0)
    st_blkst_mixture7 <= 1'b0;

// Multiple init stores without an ACK in between
//---------------------------------------------------
  if((cpx_spc7_type == `ST_ACK) | ~rst_l)
    ini_st_cnt7 <=  4'h0;
  else if(pcx7_req_pq_d1 & (spc7_pcx_data_pa[122:118] == `STORE_RQ) & spc7_pcx_data_pa[109] & ~spc7_pcx_data_pa[110])
    ini_st_cnt7 <= ini_st_cnt7 + 1'b1;

// detect if a normal store came while this counter is not zero.
//--------------------------------------------------------------
  if(ini_st_cnt7 && (spc7_pcx_data_pa[122:118] == `STORE_RQ) & ~spc7_pcx_data_pa[109])
    st_inist_mixture7 <= 1'b1;
  else if(ini_st_cnt7 == 4'h0)
    st_inist_mixture7 <= 1'b0;

  if(~rst_l)
    cpx_spc7_ifill_wyvld <= 1'b0;
  else 
    cpx_spc7_ifill_wyvld <= ((cpx_spc7_type == `IFILL_RET) & cpx_spc7_wyvld);
  
  if(~rst_l)
    cpx_spc7_dfill_wyvld <= 1'b0;
  else 
    cpx_spc7_dfill_wyvld <= ((cpx_spc7_type == `LOAD_RET) & cpx_spc7_wyvld);

end

  wire ifill_wyvld = cpx_spc0_ifill_wyvld;
  wire dfill_wyvld = cpx_spc0_dfill_wyvld;

always @(negedge clk)
begin
  if (rst_l & (^spc0_pcx_req_pq === 1'bx))
     finish_test("spc", "pcx_req_pq has X-s", 0);
  else if(rst_l & pcx0_req_pq_d1)
     get_pcx(	spc0_pcx_type_str, spc0_pcx_data_pa, pcx0_type_d1,
		pcx0_atom_pq_d1, pcx0_atom_pq_d2, 3'h0, pcx0_req_pq_d1);
  if (rst_l & (^spc1_pcx_req_pq === 1'bx))
     finish_test("spc", "pcx_req_pq has X-s", 1);
  else if(rst_l & pcx1_req_pq_d1)
     get_pcx(	spc1_pcx_type_str, spc1_pcx_data_pa, pcx1_type_d1,
		pcx1_atom_pq_d1, pcx1_atom_pq_d2, 3'h1, pcx1_req_pq_d1);
  if (rst_l & (^spc2_pcx_req_pq === 1'bx))
     finish_test("spc", "pcx_req_pq has X-s", 2);
  else if(rst_l & pcx2_req_pq_d1)
     get_pcx(	spc2_pcx_type_str, spc2_pcx_data_pa, pcx2_type_d1,
		pcx2_atom_pq_d1, pcx2_atom_pq_d2, 3'h2, pcx2_req_pq_d1);
  if (rst_l & (^spc3_pcx_req_pq === 1'bx))
     finish_test("spc", "pcx_req_pq has X-s", 3);
  else if(rst_l & pcx3_req_pq_d1)
     get_pcx(	spc3_pcx_type_str, spc3_pcx_data_pa, pcx3_type_d1,
		pcx3_atom_pq_d1, pcx3_atom_pq_d2, 3'h3, pcx3_req_pq_d1);
  if (rst_l & (^spc4_pcx_req_pq === 1'bx))
     finish_test("spc", "pcx_req_pq has X-s", 4);
  else if(rst_l & pcx4_req_pq_d1)
     get_pcx(	spc4_pcx_type_str, spc4_pcx_data_pa, pcx4_type_d1,
		pcx4_atom_pq_d1, pcx4_atom_pq_d2, 3'h4, pcx4_req_pq_d1);
  if (rst_l & (^spc5_pcx_req_pq === 1'bx))
     finish_test("spc", "pcx_req_pq has X-s", 5);
  else if(rst_l & pcx5_req_pq_d1)
     get_pcx(	spc5_pcx_type_str, spc5_pcx_data_pa, pcx5_type_d1,
		pcx5_atom_pq_d1, pcx5_atom_pq_d2, 3'h5, pcx5_req_pq_d1);
  if (rst_l & (^spc6_pcx_req_pq === 1'bx))
     finish_test("spc", "pcx_req_pq has X-s", 6);
  else if(rst_l & pcx6_req_pq_d1)
     get_pcx(	spc6_pcx_type_str, spc6_pcx_data_pa, pcx6_type_d1,
		pcx6_atom_pq_d1, pcx6_atom_pq_d2, 3'h6, pcx6_req_pq_d1);
  if (rst_l & (^spc7_pcx_req_pq === 1'bx))
     finish_test("spc", "pcx_req_pq has X-s", 7);
  else if(rst_l & pcx7_req_pq_d1)
     get_pcx(	spc7_pcx_type_str, spc7_pcx_data_pa, pcx7_type_d1,
		pcx7_atom_pq_d1, pcx7_atom_pq_d2, 3'h7, pcx7_req_pq_d1);
end

//----------------------------------------------------------------------------------------
// This section deals with the sctag to cpx packets 
// All the info signals are just for usage by the tso coverage vera objects
//----------------------------------------------------------------------------------------
reg [3:0] sctag0_valid_spcs;
reg [3:0] cpx0_inv_fanout;
reg [3:0] sctag1_valid_spcs;
reg [3:0] cpx1_inv_fanout;
reg [3:0] sctag2_valid_spcs;
reg [3:0] cpx2_inv_fanout;
reg [3:0] sctag3_valid_spcs;
reg [3:0] cpx3_inv_fanout;
reg [3:0] sctag4_valid_spcs;
reg [3:0] cpx4_inv_fanout;
reg [3:0] sctag5_valid_spcs;
reg [3:0] cpx5_inv_fanout;
reg [3:0] sctag6_valid_spcs;
reg [3:0] cpx6_inv_fanout;
reg [3:0] sctag7_valid_spcs;
reg [3:0] cpx7_inv_fanout;

reg  multiple_inv01;
reg  multiple_inv01_multiple_fanout;
reg  multiple_inv0123;
reg  multiple_inv0123_multiple_fanout;

wire [3:0] multiple_fanout_info = { 	multiple_inv01_multiple_fanout,   multiple_inv01,
   					multiple_inv0123_multiple_fanout, multiple_inv0123};

always @(posedge clk)
begin
  sctag0_cpx_req_cq_d1  <= sctag0_cpx_req_cq;
  sctag0_cpx_atom_cq_d1 <= sctag0_cpx_atom_cq;
  sctag0_cpx_atom_cq_d2 <= sctag0_cpx_atom_cq_d1;
  sctag1_cpx_req_cq_d1  <= sctag1_cpx_req_cq;
  sctag1_cpx_atom_cq_d1 <= sctag1_cpx_atom_cq;
  sctag1_cpx_atom_cq_d2 <= sctag1_cpx_atom_cq_d1;
  sctag2_cpx_req_cq_d1  <= sctag2_cpx_req_cq;
  sctag2_cpx_atom_cq_d1 <= sctag2_cpx_atom_cq;
  sctag2_cpx_atom_cq_d2 <= sctag2_cpx_atom_cq_d1;
  sctag3_cpx_req_cq_d1  <= sctag3_cpx_req_cq;
  sctag3_cpx_atom_cq_d1 <= sctag3_cpx_atom_cq;
  sctag3_cpx_atom_cq_d2 <= sctag3_cpx_atom_cq_d1;
end

always @(negedge clk)
begin
  if(rst_l)
  begin
    get_sctag_cpx(sctag0_cpx_type, sctag0_cpx_type_str, sctag0_cpx_req_cq_d1, sctag0_cpx_data_ca, 3'h0);

    sctag0_valid_spcs = 
                  sctag0_cpx_req_cq_d1[0] + sctag0_cpx_req_cq_d1[1] + sctag0_cpx_req_cq_d1[2] +
                  sctag0_cpx_req_cq_d1[3] + sctag0_cpx_req_cq_d1[4] + sctag0_cpx_req_cq_d1[5] +
                  sctag0_cpx_req_cq_d1[6] + sctag0_cpx_req_cq_d1[7];

    if((sctag0_valid_spcs > 0) &
       ((sctag0_cpx_type == `ST_ACK) | (sctag0_cpx_type == `STRST_ACK) | (sctag0_cpx_type == `EVICT_REQ)))
    begin
      cpx0_inv_fanout = sctag0_valid_spcs;
      if(tso_mon_msg) $display("%0d tso_mon: sctag0 invalidation to multiple cores %d", $time, cpx0_inv_fanout);
    end
    else
    begin
      cpx0_inv_fanout = 4'h0;
    end

    sctag0_dc_lkup_c5 <= |sctag0_dc_lkup_panel_dec_c4 & |sctag0_dc_lkup_row_dec_c4;
    sctag0_ic_lkup_c5 <= |sctag0_ic_lkup_panel_dec_c4 & |sctag0_ic_lkup_row_dec_c4;
    sctag0_dc_lkup_c6 <= sctag0_dc_lkup_c5;
    sctag0_ic_lkup_c6 <= sctag0_ic_lkup_c5;

// THESE ARE ACTUALLY CHECKERS - THEY ARE  IMPORTANT - CAUGHT A FEW BUGS
//----------------------------------------------------------------------
    if(sctag0_ic_lkup_c6)
    begin
     if(sctag0_ic_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
     if(sctag0_ic_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 0);
    end
   
    if(sctag0_dc_lkup_c6)
    begin
     if(sctag0_dc_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble8_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble9_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble10_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble11_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble12_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble13_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble14_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble15_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble24_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble25_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble26_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble27_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble28_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble29_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble30_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
     if(sctag0_dc_cam_hit_c6_nibble31_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 0);
    end

    if(sctag0_ic_lkup_c6 & sctag0_dc_lkup_c6)
    begin
     if(sctag0_both_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);

     if(sctag0_both_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
     if(sctag0_both_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 0);
    end
    get_sctag_cpx(sctag1_cpx_type, sctag1_cpx_type_str, sctag1_cpx_req_cq_d1, sctag1_cpx_data_ca, 3'h1);

    sctag1_valid_spcs = 
                  sctag1_cpx_req_cq_d1[0] + sctag1_cpx_req_cq_d1[1] + sctag1_cpx_req_cq_d1[2] +
                  sctag1_cpx_req_cq_d1[3] + sctag1_cpx_req_cq_d1[4] + sctag1_cpx_req_cq_d1[5] +
                  sctag1_cpx_req_cq_d1[6] + sctag1_cpx_req_cq_d1[7];

    if((sctag1_valid_spcs > 0) &
       ((sctag1_cpx_type == `ST_ACK) | (sctag1_cpx_type == `STRST_ACK) | (sctag1_cpx_type == `EVICT_REQ)))
    begin
      cpx1_inv_fanout = sctag1_valid_spcs;
      if(tso_mon_msg) $display("%0d tso_mon: sctag1 invalidation to multiple cores %d", $time, cpx1_inv_fanout);
    end
    else
    begin
      cpx1_inv_fanout = 4'h0;
    end

    sctag1_dc_lkup_c5 <= |sctag1_dc_lkup_panel_dec_c4 & |sctag1_dc_lkup_row_dec_c4;
    sctag1_ic_lkup_c5 <= |sctag1_ic_lkup_panel_dec_c4 & |sctag1_ic_lkup_row_dec_c4;
    sctag1_dc_lkup_c6 <= sctag1_dc_lkup_c5;
    sctag1_ic_lkup_c6 <= sctag1_ic_lkup_c5;

// THESE ARE ACTUALLY CHECKERS - THEY ARE  IMPORTANT - CAUGHT A FEW BUGS
//----------------------------------------------------------------------
    if(sctag1_ic_lkup_c6)
    begin
     if(sctag1_ic_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
     if(sctag1_ic_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 1);
    end
   
    if(sctag1_dc_lkup_c6)
    begin
     if(sctag1_dc_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble8_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble9_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble10_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble11_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble12_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble13_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble14_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble15_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble24_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble25_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble26_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble27_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble28_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble29_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble30_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
     if(sctag1_dc_cam_hit_c6_nibble31_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 1);
    end

    if(sctag1_ic_lkup_c6 & sctag1_dc_lkup_c6)
    begin
     if(sctag1_both_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);

     if(sctag1_both_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
     if(sctag1_both_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 1);
    end
    get_sctag_cpx(sctag2_cpx_type, sctag2_cpx_type_str, sctag2_cpx_req_cq_d1, sctag2_cpx_data_ca, 3'h2);

    sctag2_valid_spcs = 
                  sctag2_cpx_req_cq_d1[0] + sctag2_cpx_req_cq_d1[1] + sctag2_cpx_req_cq_d1[2] +
                  sctag2_cpx_req_cq_d1[3] + sctag2_cpx_req_cq_d1[4] + sctag2_cpx_req_cq_d1[5] +
                  sctag2_cpx_req_cq_d1[6] + sctag2_cpx_req_cq_d1[7];

    if((sctag2_valid_spcs > 0) &
       ((sctag2_cpx_type == `ST_ACK) | (sctag2_cpx_type == `STRST_ACK) | (sctag2_cpx_type == `EVICT_REQ)))
    begin
      cpx2_inv_fanout = sctag2_valid_spcs;
      if(tso_mon_msg) $display("%0d tso_mon: sctag2 invalidation to multiple cores %d", $time, cpx2_inv_fanout);
    end
    else
    begin
      cpx2_inv_fanout = 4'h0;
    end

    sctag2_dc_lkup_c5 <= |sctag2_dc_lkup_panel_dec_c4 & |sctag2_dc_lkup_row_dec_c4;
    sctag2_ic_lkup_c5 <= |sctag2_ic_lkup_panel_dec_c4 & |sctag2_ic_lkup_row_dec_c4;
    sctag2_dc_lkup_c6 <= sctag2_dc_lkup_c5;
    sctag2_ic_lkup_c6 <= sctag2_ic_lkup_c5;

// THESE ARE ACTUALLY CHECKERS - THEY ARE  IMPORTANT - CAUGHT A FEW BUGS
//----------------------------------------------------------------------
    if(sctag2_ic_lkup_c6)
    begin
     if(sctag2_ic_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
     if(sctag2_ic_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 2);
    end
   
    if(sctag2_dc_lkup_c6)
    begin
     if(sctag2_dc_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble8_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble9_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble10_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble11_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble12_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble13_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble14_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble15_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble24_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble25_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble26_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble27_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble28_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble29_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble30_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
     if(sctag2_dc_cam_hit_c6_nibble31_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 2);
    end

    if(sctag2_ic_lkup_c6 & sctag2_dc_lkup_c6)
    begin
     if(sctag2_both_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);

     if(sctag2_both_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
     if(sctag2_both_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 2);
    end
    get_sctag_cpx(sctag3_cpx_type, sctag3_cpx_type_str, sctag3_cpx_req_cq_d1, sctag3_cpx_data_ca, 3'h3);

    sctag3_valid_spcs = 
                  sctag3_cpx_req_cq_d1[0] + sctag3_cpx_req_cq_d1[1] + sctag3_cpx_req_cq_d1[2] +
                  sctag3_cpx_req_cq_d1[3] + sctag3_cpx_req_cq_d1[4] + sctag3_cpx_req_cq_d1[5] +
                  sctag3_cpx_req_cq_d1[6] + sctag3_cpx_req_cq_d1[7];

    if((sctag3_valid_spcs > 0) &
       ((sctag3_cpx_type == `ST_ACK) | (sctag3_cpx_type == `STRST_ACK) | (sctag3_cpx_type == `EVICT_REQ)))
    begin
      cpx3_inv_fanout = sctag3_valid_spcs;
      if(tso_mon_msg) $display("%0d tso_mon: sctag3 invalidation to multiple cores %d", $time, cpx3_inv_fanout);
    end
    else
    begin
      cpx3_inv_fanout = 4'h0;
    end

    sctag3_dc_lkup_c5 <= |sctag3_dc_lkup_panel_dec_c4 & |sctag3_dc_lkup_row_dec_c4;
    sctag3_ic_lkup_c5 <= |sctag3_ic_lkup_panel_dec_c4 & |sctag3_ic_lkup_row_dec_c4;
    sctag3_dc_lkup_c6 <= sctag3_dc_lkup_c5;
    sctag3_ic_lkup_c6 <= sctag3_ic_lkup_c5;

// THESE ARE ACTUALLY CHECKERS - THEY ARE  IMPORTANT - CAUGHT A FEW BUGS
//----------------------------------------------------------------------
    if(sctag3_ic_lkup_c6)
    begin
     if(sctag3_ic_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
     if(sctag3_ic_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 IC DIR  multiple hits ", 3);
    end
   
    if(sctag3_dc_lkup_c6)
    begin
     if(sctag3_dc_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble8_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble9_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble10_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble11_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble12_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble13_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble14_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble15_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble24_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble25_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble26_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble27_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble28_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble29_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble30_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
     if(sctag3_dc_cam_hit_c6_nibble31_sum>1) 
       finish_test("sctag", "tso_mon: L2 DC DIR  multiple hits ", 3);
    end

    if(sctag3_ic_lkup_c6 & sctag3_dc_lkup_c6)
    begin
     if(sctag3_both_cam_hit_c6_nibble0_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble1_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble2_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble3_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble4_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble5_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble6_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble7_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);

     if(sctag3_both_cam_hit_c6_nibble16_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble17_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble18_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble19_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble20_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble21_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble22_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
     if(sctag3_both_cam_hit_c6_nibble23_sum>1) 
       finish_test("sctag", "tso_mon: L2 ICDC DIR  multiple hits ", 3);
    end

  end // of if(rst_l)
  else
  begin
    sctag0_dc_lkup_c5 <= 1'b0;
    sctag0_ic_lkup_c5 <= 1'b0;
    sctag0_dc_lkup_c6 <= 1'b0;
    sctag0_ic_lkup_c6 <= 1'b0;
    sctag1_dc_lkup_c5 <= 1'b0;
    sctag1_ic_lkup_c5 <= 1'b0;
    sctag1_dc_lkup_c6 <= 1'b0;
    sctag1_ic_lkup_c6 <= 1'b0;
    sctag2_dc_lkup_c5 <= 1'b0;
    sctag2_ic_lkup_c5 <= 1'b0;
    sctag2_dc_lkup_c6 <= 1'b0;
    sctag2_ic_lkup_c6 <= 1'b0;
    sctag3_dc_lkup_c5 <= 1'b0;
    sctag3_ic_lkup_c5 <= 1'b0;
    sctag3_dc_lkup_c6 <= 1'b0;
    sctag3_ic_lkup_c6 <= 1'b0;
  end // of else

end // of always

always @(negedge clk)
begin
  if(rst_l)
  begin
    if(cpx0_inv_fanout && cpx1_inv_fanout)
    begin
      multiple_inv01 = 1'b1;
      if((cpx0_inv_fanout>1) && (cpx1_inv_fanout > 1))
        multiple_inv01_multiple_fanout = 1'b1;
    end  
    else
    begin
      multiple_inv01 = 1'b0;
      multiple_inv01_multiple_fanout = 1'b0;
    end

    if(cpx0_inv_fanout && cpx1_inv_fanout && cpx2_inv_fanout && cpx3_inv_fanout)
    begin
      multiple_inv0123 = 1'b1;
      if((cpx0_inv_fanout>1) && (cpx1_inv_fanout>1) &&  (cpx2_inv_fanout>1) && (cpx3_inv_fanout>1))
        multiple_inv0123_multiple_fanout = 1'b1;
    end
    else
    begin
      multiple_inv0123 = 1'b0;
      multiple_inv0123_multiple_fanout = 1'b0;
    end
  end // of if(rst_l)
end  // of always

//----------------------------------------------------------------------------------------
// This section deals with the cpx to spc packets 
//----------------------------------------------------------------------------------------
always @(posedge clk)
begin

       if(cpx_spc0_data_vld & (cpx_spc0_type == `LOAD_RET) & cpx_spc0_data_cx2[129])
       begin
           atomic_ret0 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: atomic_ret0 = 1");
       end
       else if(cpx_spc0_data_vld & (cpx_spc0_type == `ST_ACK) & cpx_spc0_data_cx2[129])
       begin
           atomic_ret0 <= 1'b0;
           if(tso_mon_msg) $display("tso_mon: atomic_ret0 = 0");
       end

       if(atomic_ret0 & cpx_spc0_data_vld & ~(cpx_spc0_type == `ST_ACK))
       begin
           non_b2b_atomic_ret0 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: non_b2b_atomic_ret0");
       end
       else 
          non_b2b_atomic_ret0 <= 1'b0;

       if(cpx_spc1_data_vld & (cpx_spc1_type == `LOAD_RET) & cpx_spc1_data_cx2[129])
       begin
           atomic_ret1 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: atomic_ret1 = 1");
       end
       else if(cpx_spc1_data_vld & (cpx_spc1_type == `ST_ACK) & cpx_spc1_data_cx2[129])
       begin
           atomic_ret1 <= 1'b0;
           if(tso_mon_msg) $display("tso_mon: atomic_ret1 = 0");
       end

       if(atomic_ret1 & cpx_spc1_data_vld & ~(cpx_spc1_type == `ST_ACK))
       begin
           non_b2b_atomic_ret1 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: non_b2b_atomic_ret0");
       end
       else 
          non_b2b_atomic_ret1 <= 1'b0;

       if(cpx_spc2_data_vld & (cpx_spc2_type == `LOAD_RET) & cpx_spc2_data_cx2[129])
       begin
           atomic_ret2 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: atomic_ret2 = 1");
       end
       else if(cpx_spc2_data_vld & (cpx_spc2_type == `ST_ACK) & cpx_spc2_data_cx2[129])
       begin
           atomic_ret2 <= 1'b0;
           if(tso_mon_msg) $display("tso_mon: atomic_ret2 = 0");
       end

       if(atomic_ret2 & cpx_spc2_data_vld & ~(cpx_spc2_type == `ST_ACK))
       begin
           non_b2b_atomic_ret2 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: non_b2b_atomic_ret0");
       end
       else 
          non_b2b_atomic_ret2 <= 1'b0;

       if(cpx_spc3_data_vld & (cpx_spc3_type == `LOAD_RET) & cpx_spc3_data_cx2[129])
       begin
           atomic_ret3 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: atomic_ret3 = 1");
       end
       else if(cpx_spc3_data_vld & (cpx_spc3_type == `ST_ACK) & cpx_spc3_data_cx2[129])
       begin
           atomic_ret3 <= 1'b0;
           if(tso_mon_msg) $display("tso_mon: atomic_ret3 = 0");
       end

       if(atomic_ret3 & cpx_spc3_data_vld & ~(cpx_spc3_type == `ST_ACK))
       begin
           non_b2b_atomic_ret3 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: non_b2b_atomic_ret0");
       end
       else 
          non_b2b_atomic_ret3 <= 1'b0;

       if(cpx_spc4_data_vld & (cpx_spc4_type == `LOAD_RET) & cpx_spc4_data_cx2[129])
       begin
           atomic_ret4 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: atomic_ret4 = 1");
       end
       else if(cpx_spc4_data_vld & (cpx_spc4_type == `ST_ACK) & cpx_spc4_data_cx2[129])
       begin
           atomic_ret4 <= 1'b0;
           if(tso_mon_msg) $display("tso_mon: atomic_ret4 = 0");
       end

       if(atomic_ret4 & cpx_spc4_data_vld & ~(cpx_spc4_type == `ST_ACK))
       begin
           non_b2b_atomic_ret4 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: non_b2b_atomic_ret0");
       end
       else 
          non_b2b_atomic_ret4 <= 1'b0;

       if(cpx_spc5_data_vld & (cpx_spc5_type == `LOAD_RET) & cpx_spc5_data_cx2[129])
       begin
           atomic_ret5 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: atomic_ret5 = 1");
       end
       else if(cpx_spc5_data_vld & (cpx_spc5_type == `ST_ACK) & cpx_spc5_data_cx2[129])
       begin
           atomic_ret5 <= 1'b0;
           if(tso_mon_msg) $display("tso_mon: atomic_ret5 = 0");
       end

       if(atomic_ret5 & cpx_spc5_data_vld & ~(cpx_spc5_type == `ST_ACK))
       begin
           non_b2b_atomic_ret5 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: non_b2b_atomic_ret0");
       end
       else 
          non_b2b_atomic_ret5 <= 1'b0;

       if(cpx_spc6_data_vld & (cpx_spc6_type == `LOAD_RET) & cpx_spc6_data_cx2[129])
       begin
           atomic_ret6 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: atomic_ret6 = 1");
       end
       else if(cpx_spc6_data_vld & (cpx_spc6_type == `ST_ACK) & cpx_spc6_data_cx2[129])
       begin
           atomic_ret6 <= 1'b0;
           if(tso_mon_msg) $display("tso_mon: atomic_ret6 = 0");
       end

       if(atomic_ret6 & cpx_spc6_data_vld & ~(cpx_spc6_type == `ST_ACK))
       begin
           non_b2b_atomic_ret6 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: non_b2b_atomic_ret0");
       end
       else 
          non_b2b_atomic_ret6 <= 1'b0;

       if(cpx_spc7_data_vld & (cpx_spc7_type == `LOAD_RET) & cpx_spc7_data_cx2[129])
       begin
           atomic_ret7 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: atomic_ret7 = 1");
       end
       else if(cpx_spc7_data_vld & (cpx_spc7_type == `ST_ACK) & cpx_spc7_data_cx2[129])
       begin
           atomic_ret7 <= 1'b0;
           if(tso_mon_msg) $display("tso_mon: atomic_ret7 = 0");
       end

       if(atomic_ret7 & cpx_spc7_data_vld & ~(cpx_spc7_type == `ST_ACK))
       begin
           non_b2b_atomic_ret7 <= 1'b1;
           if(tso_mon_msg) $display("tso_mon: non_b2b_atomic_ret0");
       end
       else 
          non_b2b_atomic_ret7 <= 1'b0;
end

always @(negedge clk)
begin
  if(rst_l)
  begin
  if(cpx_spc0_data_vld)
    get_cpx_spc(cpx_spc0_type_str, cpx_spc0_type);
  if(tso_mon_msg)
    $display("%0d:Info cpx-to-spc%d packet TYPE= %s data= %x", $time, 0, cpx_spc0_type_str, cpx_spc0_data_cx2[127:0]);

  if(cpx_spc1_data_vld)
    get_cpx_spc(cpx_spc1_type_str, cpx_spc1_type);
  if(tso_mon_msg)
    $display("%0d:Info cpx-to-spc%d packet TYPE= %s data= %x", $time, 1, cpx_spc1_type_str, cpx_spc1_data_cx2[127:0]);

  if(cpx_spc2_data_vld)
    get_cpx_spc(cpx_spc2_type_str, cpx_spc2_type);
  if(tso_mon_msg)
    $display("%0d:Info cpx-to-spc%d packet TYPE= %s data= %x", $time, 2, cpx_spc2_type_str, cpx_spc2_data_cx2[127:0]);

  if(cpx_spc3_data_vld)
    get_cpx_spc(cpx_spc3_type_str, cpx_spc3_type);
  if(tso_mon_msg)
    $display("%0d:Info cpx-to-spc%d packet TYPE= %s data= %x", $time, 3, cpx_spc3_type_str, cpx_spc3_data_cx2[127:0]);

  if(cpx_spc4_data_vld)
    get_cpx_spc(cpx_spc4_type_str, cpx_spc4_type);
  if(tso_mon_msg)
    $display("%0d:Info cpx-to-spc%d packet TYPE= %s data= %x", $time, 4, cpx_spc4_type_str, cpx_spc4_data_cx2[127:0]);

  if(cpx_spc5_data_vld)
    get_cpx_spc(cpx_spc5_type_str, cpx_spc5_type);
  if(tso_mon_msg)
    $display("%0d:Info cpx-to-spc%d packet TYPE= %s data= %x", $time, 5, cpx_spc5_type_str, cpx_spc5_data_cx2[127:0]);

  if(cpx_spc6_data_vld)
    get_cpx_spc(cpx_spc6_type_str, cpx_spc6_type);
  if(tso_mon_msg)
    $display("%0d:Info cpx-to-spc%d packet TYPE= %s data= %x", $time, 6, cpx_spc6_type_str, cpx_spc6_data_cx2[127:0]);

  if(cpx_spc7_data_vld)
    get_cpx_spc(cpx_spc7_type_str, cpx_spc7_type);
  if(tso_mon_msg)
    $display("%0d:Info cpx-to-spc%d packet TYPE= %s data= %x", $time, 7, cpx_spc7_type_str, cpx_spc7_data_cx2[127:0]);

  end // of rst_l
end


//==============================================================================
// L2 stuff
//==============================================================================

//==============================================================================
// This is stuff related to the L2 tags queues. Measure fullness and high-water mark
// The queus are - miss buffer, output q, input q, fill buffer, write back buffer
// rdma (write) q and snoop q.
//==============================================================================
wire [4:0] 	sctag0_mb_count   = `TOP_MEMORY.sctag0.mbctl.mb_count_c4[4:0];
wire [4:0] 	sctag0_oq_count   = `TOP_MEMORY.sctag0.oqctl.oq_count_p[4:0];
wire [4:0] 	sctag0_iq_count   = `TOP_MEMORY.sctag0.iqctl.que_cnt[4:0];
wire [3:0] 	sctag0_fb_count   = `TOP_MEMORY.sctag0.fbctl.fb_count[3:0];
wire [3:0] 	sctag0_wb_count   = `TOP_MEMORY.sctag0.wbctl.wb_count[3:0];
wire [3:0] 	sctag0_rdma_valid = `TOP_MEMORY.sctag0.rdmatctl.rdma_valid[3:0];
wire [1:0] 	sctag0_snpq_valid = `TOP_MEMORY.sctag0.snpctl.snpq_valid[1:0];

wire sctag0_mb_full 	 = (sctag0_mb_count == 5'd16);
wire sctag0_mb_hwm  	 = (sctag0_mb_count >= 5'd12);
wire sctag0_oq_full 	 = (sctag0_oq_count == 5'd16);
wire sctag0_oq_hwm  	 = (sctag0_oq_count >= 5'd01);
wire sctag0_iq_full 	 = (sctag0_iq_count == 5'd16);
wire sctag0_iq_hwm  	 = (sctag0_iq_count >= 5'd11);
wire sctag0_fb_full 	 = (sctag0_fb_count == 4'd8);
wire sctag0_fb_hwm  	 = (sctag0_fb_count >= 4'd7);
wire sctag0_wb_full 	 = (sctag0_wb_count == 4'd8);
wire sctag0_wb_hwm  	 = (sctag0_wb_count >= 4'd1);
wire sctag0_rdma_full = (sctag0_rdma_valid == 4'b1111);
wire sctag0_snpq_full = (sctag0_snpq_valid == 2'b11);

wire [1:0] sctag0_mb_info = {sctag0_mb_full, sctag0_mb_hwm};
wire [1:0] sctag0_oq_info = {sctag0_oq_full, sctag0_oq_hwm};
wire [1:0] sctag0_iq_info = {sctag0_iq_full, sctag0_iq_hwm};
wire [1:0] sctag0_fb_info = {sctag0_fb_full, sctag0_fb_hwm};
wire [1:0] sctag0_wb_info = {sctag0_wb_full, sctag0_wb_hwm};
wire [4:0] 	sctag1_mb_count   = `TOP_MEMORY.sctag1.mbctl.mb_count_c4[4:0];
wire [4:0] 	sctag1_oq_count   = `TOP_MEMORY.sctag1.oqctl.oq_count_p[4:0];
wire [4:0] 	sctag1_iq_count   = `TOP_MEMORY.sctag1.iqctl.que_cnt[4:0];
wire [3:0] 	sctag1_fb_count   = `TOP_MEMORY.sctag1.fbctl.fb_count[3:0];
wire [3:0] 	sctag1_wb_count   = `TOP_MEMORY.sctag1.wbctl.wb_count[3:0];
wire [3:0] 	sctag1_rdma_valid = `TOP_MEMORY.sctag1.rdmatctl.rdma_valid[3:0];
wire [1:0] 	sctag1_snpq_valid = `TOP_MEMORY.sctag1.snpctl.snpq_valid[1:0];

wire sctag1_mb_full 	 = (sctag1_mb_count == 5'd16);
wire sctag1_mb_hwm  	 = (sctag1_mb_count >= 5'd12);
wire sctag1_oq_full 	 = (sctag1_oq_count == 5'd16);
wire sctag1_oq_hwm  	 = (sctag1_oq_count >= 5'd01);
wire sctag1_iq_full 	 = (sctag1_iq_count == 5'd16);
wire sctag1_iq_hwm  	 = (sctag1_iq_count >= 5'd11);
wire sctag1_fb_full 	 = (sctag1_fb_count == 4'd8);
wire sctag1_fb_hwm  	 = (sctag1_fb_count >= 4'd7);
wire sctag1_wb_full 	 = (sctag1_wb_count == 4'd8);
wire sctag1_wb_hwm  	 = (sctag1_wb_count >= 4'd1);
wire sctag1_rdma_full = (sctag1_rdma_valid == 4'b1111);
wire sctag1_snpq_full = (sctag1_snpq_valid == 2'b11);

wire [1:0] sctag1_mb_info = {sctag1_mb_full, sctag1_mb_hwm};
wire [1:0] sctag1_oq_info = {sctag1_oq_full, sctag1_oq_hwm};
wire [1:0] sctag1_iq_info = {sctag1_iq_full, sctag1_iq_hwm};
wire [1:0] sctag1_fb_info = {sctag1_fb_full, sctag1_fb_hwm};
wire [1:0] sctag1_wb_info = {sctag1_wb_full, sctag1_wb_hwm};
wire [4:0] 	sctag2_mb_count   = `TOP_MEMORY.sctag2.mbctl.mb_count_c4[4:0];
wire [4:0] 	sctag2_oq_count   = `TOP_MEMORY.sctag2.oqctl.oq_count_p[4:0];
wire [4:0] 	sctag2_iq_count   = `TOP_MEMORY.sctag2.iqctl.que_cnt[4:0];
wire [3:0] 	sctag2_fb_count   = `TOP_MEMORY.sctag2.fbctl.fb_count[3:0];
wire [3:0] 	sctag2_wb_count   = `TOP_MEMORY.sctag2.wbctl.wb_count[3:0];
wire [3:0] 	sctag2_rdma_valid = `TOP_MEMORY.sctag2.rdmatctl.rdma_valid[3:0];
wire [1:0] 	sctag2_snpq_valid = `TOP_MEMORY.sctag2.snpctl.snpq_valid[1:0];

wire sctag2_mb_full 	 = (sctag2_mb_count == 5'd16);
wire sctag2_mb_hwm  	 = (sctag2_mb_count >= 5'd12);
wire sctag2_oq_full 	 = (sctag2_oq_count == 5'd16);
wire sctag2_oq_hwm  	 = (sctag2_oq_count >= 5'd01);
wire sctag2_iq_full 	 = (sctag2_iq_count == 5'd16);
wire sctag2_iq_hwm  	 = (sctag2_iq_count >= 5'd11);
wire sctag2_fb_full 	 = (sctag2_fb_count == 4'd8);
wire sctag2_fb_hwm  	 = (sctag2_fb_count >= 4'd7);
wire sctag2_wb_full 	 = (sctag2_wb_count == 4'd8);
wire sctag2_wb_hwm  	 = (sctag2_wb_count >= 4'd1);
wire sctag2_rdma_full = (sctag2_rdma_valid == 4'b1111);
wire sctag2_snpq_full = (sctag2_snpq_valid == 2'b11);

wire [1:0] sctag2_mb_info = {sctag2_mb_full, sctag2_mb_hwm};
wire [1:0] sctag2_oq_info = {sctag2_oq_full, sctag2_oq_hwm};
wire [1:0] sctag2_iq_info = {sctag2_iq_full, sctag2_iq_hwm};
wire [1:0] sctag2_fb_info = {sctag2_fb_full, sctag2_fb_hwm};
wire [1:0] sctag2_wb_info = {sctag2_wb_full, sctag2_wb_hwm};
wire [4:0] 	sctag3_mb_count   = `TOP_MEMORY.sctag3.mbctl.mb_count_c4[4:0];
wire [4:0] 	sctag3_oq_count   = `TOP_MEMORY.sctag3.oqctl.oq_count_p[4:0];
wire [4:0] 	sctag3_iq_count   = `TOP_MEMORY.sctag3.iqctl.que_cnt[4:0];
wire [3:0] 	sctag3_fb_count   = `TOP_MEMORY.sctag3.fbctl.fb_count[3:0];
wire [3:0] 	sctag3_wb_count   = `TOP_MEMORY.sctag3.wbctl.wb_count[3:0];
wire [3:0] 	sctag3_rdma_valid = `TOP_MEMORY.sctag3.rdmatctl.rdma_valid[3:0];
wire [1:0] 	sctag3_snpq_valid = `TOP_MEMORY.sctag3.snpctl.snpq_valid[1:0];

wire sctag3_mb_full 	 = (sctag3_mb_count == 5'd16);
wire sctag3_mb_hwm  	 = (sctag3_mb_count >= 5'd12);
wire sctag3_oq_full 	 = (sctag3_oq_count == 5'd16);
wire sctag3_oq_hwm  	 = (sctag3_oq_count >= 5'd01);
wire sctag3_iq_full 	 = (sctag3_iq_count == 5'd16);
wire sctag3_iq_hwm  	 = (sctag3_iq_count >= 5'd11);
wire sctag3_fb_full 	 = (sctag3_fb_count == 4'd8);
wire sctag3_fb_hwm  	 = (sctag3_fb_count >= 4'd7);
wire sctag3_wb_full 	 = (sctag3_wb_count == 4'd8);
wire sctag3_wb_hwm  	 = (sctag3_wb_count >= 4'd1);
wire sctag3_rdma_full = (sctag3_rdma_valid == 4'b1111);
wire sctag3_snpq_full = (sctag3_snpq_valid == 2'b11);

wire [1:0] sctag3_mb_info = {sctag3_mb_full, sctag3_mb_hwm};
wire [1:0] sctag3_oq_info = {sctag3_oq_full, sctag3_oq_hwm};
wire [1:0] sctag3_iq_info = {sctag3_iq_full, sctag3_iq_hwm};
wire [1:0] sctag3_fb_info = {sctag3_fb_full, sctag3_fb_hwm};
wire [1:0] sctag3_wb_info = {sctag3_wb_full, sctag3_wb_hwm};

//==============================================================================
// L2 Miss buffer linked list stuff 
// valid, young, next link,  type
//==============================================================================
wire [15:0] 	sctag0_mb_valid	    = `TOP_MEMORY.sctag0.mbctl.mb_valid[15:0];
wire [15:0] 	sctag0_mb_young	    = `TOP_MEMORY.sctag0.mbctl.mb_young[15:0];
//wire [3:0] 	sctag0_next_link_entry0  = `TOP_MEMORY.sctag0.mbctl.next_link_entry0[3:0];
//...
//wire [3:0] 	sctag0_next_link_entry15 = `TOP_MEMORY.sctag0.mbctl.next_link_entry15[3:0];

wire [155:0] 	sctag0_mb_data_array0  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[0];
wire [155:0] 	sctag0_mb_data_array1  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[1];
wire [155:0] 	sctag0_mb_data_array2  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[2];
wire [155:0] 	sctag0_mb_data_array3  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[3];
wire [155:0] 	sctag0_mb_data_array4  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[4];
wire [155:0] 	sctag0_mb_data_array5  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[5];
wire [155:0] 	sctag0_mb_data_array6  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[6];
wire [155:0] 	sctag0_mb_data_array7  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[7];
wire [155:0] 	sctag0_mb_data_array8  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[8];
wire [155:0] 	sctag0_mb_data_array9  	= `TOP_MEMORY.sctag0.mbdata.inq_ary[9];
wire [155:0] 	sctag0_mb_data_array10 	= `TOP_MEMORY.sctag0.mbdata.inq_ary[10];
wire [155:0] 	sctag0_mb_data_array11 	= `TOP_MEMORY.sctag0.mbdata.inq_ary[11];
wire [155:0] 	sctag0_mb_data_array12 	= `TOP_MEMORY.sctag0.mbdata.inq_ary[12];
wire [155:0] 	sctag0_mb_data_array13 	= `TOP_MEMORY.sctag0.mbdata.inq_ary[13];
wire [155:0] 	sctag0_mb_data_array14 	= `TOP_MEMORY.sctag0.mbdata.inq_ary[14];
wire [155:0] 	sctag0_mb_data_array15 	= `TOP_MEMORY.sctag0.mbdata.inq_ary[15];

//-----------------------------------------------------------------------------------------------
// look at sctag.v for L2_RDMA_HI L2_RQTYP_HI L2_RQTYP_LO and L2_RSVD
// Based ont the equation: .mb_data_write_data({57'b0,mbdata_inst_tecc_c8...
//-----------------------------------------------------------------------------------------------
wire [5:0]     sctag0_mb_type0  =	{sctag0_mb_data_array0 [77], sctag0_mb_data_array0 [83:79]};
wire [5:0]     sctag0_mb_type1  =	{sctag0_mb_data_array1 [77], sctag0_mb_data_array1 [83:79]};
wire [5:0]     sctag0_mb_type2  =	{sctag0_mb_data_array2 [77], sctag0_mb_data_array2 [83:79]};
wire [5:0]     sctag0_mb_type3  =	{sctag0_mb_data_array3 [77], sctag0_mb_data_array3 [83:79]};
wire [5:0]     sctag0_mb_type4  =	{sctag0_mb_data_array4 [77], sctag0_mb_data_array4 [83:79]};
wire [5:0]     sctag0_mb_type5  =	{sctag0_mb_data_array5 [77], sctag0_mb_data_array5 [83:79]};
wire [5:0]     sctag0_mb_type6  =	{sctag0_mb_data_array6 [77], sctag0_mb_data_array6 [83:79]};
wire [5:0]     sctag0_mb_type7  =	{sctag0_mb_data_array7 [77], sctag0_mb_data_array7 [83:79]};
wire [5:0]     sctag0_mb_type8  =	{sctag0_mb_data_array8 [77], sctag0_mb_data_array8 [83:79]};
wire [5:0]     sctag0_mb_type9  =	{sctag0_mb_data_array9 [77], sctag0_mb_data_array9 [83:79]};
wire [5:0]     sctag0_mb_type10 =	{sctag0_mb_data_array10[77], sctag0_mb_data_array10[83:79]};
wire [5:0]     sctag0_mb_type11 =	{sctag0_mb_data_array11[77], sctag0_mb_data_array11[83:79]};
wire [5:0]     sctag0_mb_type12 =	{sctag0_mb_data_array12[77], sctag0_mb_data_array12[83:79]};
wire [5:0]     sctag0_mb_type13 =	{sctag0_mb_data_array13[77], sctag0_mb_data_array13[83:79]};
wire [5:0]     sctag0_mb_type14 =	{sctag0_mb_data_array14[77], sctag0_mb_data_array14[83:79]};
wire [5:0]     sctag0_mb_type15 =	{sctag0_mb_data_array15[77], sctag0_mb_data_array15[83:79]};

//--------------------------------------------------------------
// Start figuring out what the entries are.
// bit 5 says if this is a DMA type or normal type
//--------------------------------------------------------------

wire sctag0_mb0_st_ny     = sctag0_mb_valid[0] & ~sctag0_mb_young[0] & ~sctag0_mb_type0[5] & (sctag0_mb_type0[4:0] == `STORE_RQ);
wire sctag0_mb0_ld_ny     = sctag0_mb_valid[0] & ~sctag0_mb_young[0] & ~sctag0_mb_type0[5] & (sctag0_mb_type0[4:0] == `LOAD_RQ);
wire sctag0_mb0_wris8_ny  = sctag0_mb_valid[0] & ~sctag0_mb_young[0] &  sctag0_mb_type0[5] &  sctag0_mb_type0[1];
wire sctag0_mb0_wris64_ny = sctag0_mb_valid[0] & ~sctag0_mb_young[0] &  sctag0_mb_type0[5] &  sctag0_mb_type0[2];
wire sctag0_mb0_st_y      = sctag0_mb_valid[0] &  sctag0_mb_young[0] & ~sctag0_mb_type0[5] & (sctag0_mb_type0[4:0] == `STORE_RQ);
wire sctag0_mb0_ld_y      = sctag0_mb_valid[0] &  sctag0_mb_young[0] & ~sctag0_mb_type0[5] & (sctag0_mb_type0[4:0] == `LOAD_RQ);
wire sctag0_mb0_wris8_y   = sctag0_mb_valid[0] &  sctag0_mb_young[0] &  sctag0_mb_type0[5] &  sctag0_mb_type0[1];
wire sctag0_mb0_wris64_y  = sctag0_mb_valid[0] &  sctag0_mb_young[0] &  sctag0_mb_type0[5] &  sctag0_mb_type0[2];

wire sctag0_mb1_st_ny     = sctag0_mb_valid[1] & ~sctag0_mb_young[1] & ~sctag0_mb_type1[5] & (sctag0_mb_type1[4:0] == `STORE_RQ);
wire sctag0_mb1_ld_ny     = sctag0_mb_valid[1] & ~sctag0_mb_young[1] & ~sctag0_mb_type1[5] & (sctag0_mb_type1[4:0] == `LOAD_RQ);
wire sctag0_mb1_wris8_ny  = sctag0_mb_valid[1] & ~sctag0_mb_young[1] &  sctag0_mb_type1[5] &  sctag0_mb_type1[1];
wire sctag0_mb1_wris64_ny = sctag0_mb_valid[1] & ~sctag0_mb_young[1] &  sctag0_mb_type1[5] &  sctag0_mb_type1[2];
wire sctag0_mb1_st_y      = sctag0_mb_valid[1] &  sctag0_mb_young[1] & ~sctag0_mb_type1[5] & (sctag0_mb_type1[4:0] == `STORE_RQ);
wire sctag0_mb1_ld_y      = sctag0_mb_valid[1] &  sctag0_mb_young[1] & ~sctag0_mb_type1[5] & (sctag0_mb_type1[4:0] == `LOAD_RQ);
wire sctag0_mb1_wris8_y   = sctag0_mb_valid[1] &  sctag0_mb_young[1] &  sctag0_mb_type1[5] &  sctag0_mb_type1[1];
wire sctag0_mb1_wris64_y  = sctag0_mb_valid[1] &  sctag0_mb_young[1] &  sctag0_mb_type1[5] &  sctag0_mb_type1[2];

wire sctag0_mb2_st_ny     = sctag0_mb_valid[2] & ~sctag0_mb_young[2] & ~sctag0_mb_type2[5] & (sctag0_mb_type2[4:0] == `STORE_RQ);
wire sctag0_mb2_ld_ny     = sctag0_mb_valid[2] & ~sctag0_mb_young[2] & ~sctag0_mb_type2[5] & (sctag0_mb_type2[4:0] == `LOAD_RQ);
wire sctag0_mb2_wris8_ny  = sctag0_mb_valid[2] & ~sctag0_mb_young[2] &  sctag0_mb_type2[5] &  sctag0_mb_type2[1];
wire sctag0_mb2_wris64_ny = sctag0_mb_valid[2] & ~sctag0_mb_young[2] &  sctag0_mb_type2[5] &  sctag0_mb_type2[2];
wire sctag0_mb2_st_y      = sctag0_mb_valid[2] &  sctag0_mb_young[2] & ~sctag0_mb_type2[5] & (sctag0_mb_type2[4:0] == `STORE_RQ);
wire sctag0_mb2_ld_y      = sctag0_mb_valid[2] &  sctag0_mb_young[2] & ~sctag0_mb_type2[5] & (sctag0_mb_type2[4:0] == `LOAD_RQ);
wire sctag0_mb2_wris8_y   = sctag0_mb_valid[2] &  sctag0_mb_young[2] &  sctag0_mb_type2[5] &  sctag0_mb_type2[1];
wire sctag0_mb2_wris64_y  = sctag0_mb_valid[2] &  sctag0_mb_young[2] &  sctag0_mb_type2[5] &  sctag0_mb_type2[2];

wire sctag0_mb3_st_ny     = sctag0_mb_valid[3] & ~sctag0_mb_young[3] & ~sctag0_mb_type3[5] & (sctag0_mb_type3[4:0] == `STORE_RQ);
wire sctag0_mb3_ld_ny     = sctag0_mb_valid[3] & ~sctag0_mb_young[3] & ~sctag0_mb_type3[5] & (sctag0_mb_type3[4:0] == `LOAD_RQ);
wire sctag0_mb3_wris8_ny  = sctag0_mb_valid[3] & ~sctag0_mb_young[3] &  sctag0_mb_type3[5] &  sctag0_mb_type3[1];
wire sctag0_mb3_wris64_ny = sctag0_mb_valid[3] & ~sctag0_mb_young[3] &  sctag0_mb_type3[5] &  sctag0_mb_type3[2];
wire sctag0_mb3_st_y      = sctag0_mb_valid[3] &  sctag0_mb_young[3] & ~sctag0_mb_type3[5] & (sctag0_mb_type3[4:0] == `STORE_RQ);
wire sctag0_mb3_ld_y      = sctag0_mb_valid[3] &  sctag0_mb_young[3] & ~sctag0_mb_type3[5] & (sctag0_mb_type3[4:0] == `LOAD_RQ);
wire sctag0_mb3_wris8_y   = sctag0_mb_valid[3] &  sctag0_mb_young[3] &  sctag0_mb_type3[5] &  sctag0_mb_type3[1];
wire sctag0_mb3_wris64_y  = sctag0_mb_valid[3] &  sctag0_mb_young[3] &  sctag0_mb_type3[5] &  sctag0_mb_type3[2];

wire sctag0_mb4_st_ny     = sctag0_mb_valid[4] & ~sctag0_mb_young[4] & ~sctag0_mb_type4[5] & (sctag0_mb_type4[4:0] == `STORE_RQ);
wire sctag0_mb4_ld_ny     = sctag0_mb_valid[4] & ~sctag0_mb_young[4] & ~sctag0_mb_type4[5] & (sctag0_mb_type4[4:0] == `LOAD_RQ);
wire sctag0_mb4_wris8_ny  = sctag0_mb_valid[4] & ~sctag0_mb_young[4] &  sctag0_mb_type4[5] &  sctag0_mb_type4[1];
wire sctag0_mb4_wris64_ny = sctag0_mb_valid[4] & ~sctag0_mb_young[4] &  sctag0_mb_type4[5] &  sctag0_mb_type4[2];
wire sctag0_mb4_st_y      = sctag0_mb_valid[4] &  sctag0_mb_young[4] & ~sctag0_mb_type4[5] & (sctag0_mb_type4[4:0] == `STORE_RQ);
wire sctag0_mb4_ld_y      = sctag0_mb_valid[4] &  sctag0_mb_young[4] & ~sctag0_mb_type4[5] & (sctag0_mb_type4[4:0] == `LOAD_RQ);
wire sctag0_mb4_wris8_y   = sctag0_mb_valid[4] &  sctag0_mb_young[4] &  sctag0_mb_type4[5] &  sctag0_mb_type4[1];
wire sctag0_mb4_wris64_y  = sctag0_mb_valid[4] &  sctag0_mb_young[4] &  sctag0_mb_type4[5] &  sctag0_mb_type4[2];

wire sctag0_mb5_st_ny     = sctag0_mb_valid[5] & ~sctag0_mb_young[5] & ~sctag0_mb_type5[5] & (sctag0_mb_type5[4:0] == `STORE_RQ);
wire sctag0_mb5_ld_ny     = sctag0_mb_valid[5] & ~sctag0_mb_young[5] & ~sctag0_mb_type5[5] & (sctag0_mb_type5[4:0] == `LOAD_RQ);
wire sctag0_mb5_wris8_ny  = sctag0_mb_valid[5] & ~sctag0_mb_young[5] &  sctag0_mb_type5[5] &  sctag0_mb_type5[1];
wire sctag0_mb5_wris64_ny = sctag0_mb_valid[5] & ~sctag0_mb_young[5] &  sctag0_mb_type5[5] &  sctag0_mb_type5[2];
wire sctag0_mb5_st_y      = sctag0_mb_valid[5] &  sctag0_mb_young[5] & ~sctag0_mb_type5[5] & (sctag0_mb_type5[4:0] == `STORE_RQ);
wire sctag0_mb5_ld_y      = sctag0_mb_valid[5] &  sctag0_mb_young[5] & ~sctag0_mb_type5[5] & (sctag0_mb_type5[4:0] == `LOAD_RQ);
wire sctag0_mb5_wris8_y   = sctag0_mb_valid[5] &  sctag0_mb_young[5] &  sctag0_mb_type5[5] &  sctag0_mb_type5[1];
wire sctag0_mb5_wris64_y  = sctag0_mb_valid[5] &  sctag0_mb_young[5] &  sctag0_mb_type5[5] &  sctag0_mb_type5[2];

wire sctag0_mb6_st_ny     = sctag0_mb_valid[6] & ~sctag0_mb_young[6] & ~sctag0_mb_type6[5] & (sctag0_mb_type6[4:0] == `STORE_RQ);
wire sctag0_mb6_ld_ny     = sctag0_mb_valid[6] & ~sctag0_mb_young[6] & ~sctag0_mb_type6[5] & (sctag0_mb_type6[4:0] == `LOAD_RQ);
wire sctag0_mb6_wris8_ny  = sctag0_mb_valid[6] & ~sctag0_mb_young[6] &  sctag0_mb_type6[5] &  sctag0_mb_type6[1];
wire sctag0_mb6_wris64_ny = sctag0_mb_valid[6] & ~sctag0_mb_young[6] &  sctag0_mb_type6[5] &  sctag0_mb_type6[2];
wire sctag0_mb6_st_y      = sctag0_mb_valid[6] &  sctag0_mb_young[6] & ~sctag0_mb_type6[5] & (sctag0_mb_type6[4:0] == `STORE_RQ);
wire sctag0_mb6_ld_y      = sctag0_mb_valid[6] &  sctag0_mb_young[6] & ~sctag0_mb_type6[5] & (sctag0_mb_type6[4:0] == `LOAD_RQ);
wire sctag0_mb6_wris8_y   = sctag0_mb_valid[6] &  sctag0_mb_young[6] &  sctag0_mb_type6[5] &  sctag0_mb_type6[1];
wire sctag0_mb6_wris64_y  = sctag0_mb_valid[6] &  sctag0_mb_young[6] &  sctag0_mb_type6[5] &  sctag0_mb_type6[2];

wire sctag0_mb7_st_ny     = sctag0_mb_valid[7] & ~sctag0_mb_young[7] & ~sctag0_mb_type7[5] & (sctag0_mb_type7[4:0] == `STORE_RQ);
wire sctag0_mb7_ld_ny     = sctag0_mb_valid[7] & ~sctag0_mb_young[7] & ~sctag0_mb_type7[5] & (sctag0_mb_type7[4:0] == `LOAD_RQ);
wire sctag0_mb7_wris8_ny  = sctag0_mb_valid[7] & ~sctag0_mb_young[7] &  sctag0_mb_type7[5] &  sctag0_mb_type7[1];
wire sctag0_mb7_wris64_ny = sctag0_mb_valid[7] & ~sctag0_mb_young[7] &  sctag0_mb_type7[5] &  sctag0_mb_type7[2];
wire sctag0_mb7_st_y      = sctag0_mb_valid[7] &  sctag0_mb_young[7] & ~sctag0_mb_type7[5] & (sctag0_mb_type7[4:0] == `STORE_RQ);
wire sctag0_mb7_ld_y      = sctag0_mb_valid[7] &  sctag0_mb_young[7] & ~sctag0_mb_type7[5] & (sctag0_mb_type7[4:0] == `LOAD_RQ);
wire sctag0_mb7_wris8_y   = sctag0_mb_valid[7] &  sctag0_mb_young[7] &  sctag0_mb_type7[5] &  sctag0_mb_type7[1];
wire sctag0_mb7_wris64_y  = sctag0_mb_valid[7] &  sctag0_mb_young[7] &  sctag0_mb_type7[5] &  sctag0_mb_type7[2];

wire sctag0_mb8_st_ny     = sctag0_mb_valid[8] & ~sctag0_mb_young[8] & ~sctag0_mb_type8[5] & (sctag0_mb_type8[4:0] == `STORE_RQ);
wire sctag0_mb8_ld_ny     = sctag0_mb_valid[8] & ~sctag0_mb_young[8] & ~sctag0_mb_type8[5] & (sctag0_mb_type8[4:0] == `LOAD_RQ);
wire sctag0_mb8_wris8_ny  = sctag0_mb_valid[8] & ~sctag0_mb_young[8] &  sctag0_mb_type8[5] &  sctag0_mb_type8[1];
wire sctag0_mb8_wris64_ny = sctag0_mb_valid[8] & ~sctag0_mb_young[8] &  sctag0_mb_type8[5] &  sctag0_mb_type8[2];
wire sctag0_mb8_st_y      = sctag0_mb_valid[8] &  sctag0_mb_young[8] & ~sctag0_mb_type8[5] & (sctag0_mb_type8[4:0] == `STORE_RQ);
wire sctag0_mb8_ld_y      = sctag0_mb_valid[8] &  sctag0_mb_young[8] & ~sctag0_mb_type8[5] & (sctag0_mb_type8[4:0] == `LOAD_RQ);
wire sctag0_mb8_wris8_y   = sctag0_mb_valid[8] &  sctag0_mb_young[8] &  sctag0_mb_type8[5] &  sctag0_mb_type8[1];
wire sctag0_mb8_wris64_y  = sctag0_mb_valid[8] &  sctag0_mb_young[8] &  sctag0_mb_type8[5] &  sctag0_mb_type8[2];

wire sctag0_mb9_st_ny     = sctag0_mb_valid[9] & ~sctag0_mb_young[9] & ~sctag0_mb_type9[5] & (sctag0_mb_type9[4:0] == `STORE_RQ);
wire sctag0_mb9_ld_ny     = sctag0_mb_valid[9] & ~sctag0_mb_young[9] & ~sctag0_mb_type9[5] & (sctag0_mb_type9[4:0] == `LOAD_RQ);
wire sctag0_mb9_wris8_ny  = sctag0_mb_valid[9] & ~sctag0_mb_young[9] &  sctag0_mb_type9[5] &  sctag0_mb_type9[1];
wire sctag0_mb9_wris64_ny = sctag0_mb_valid[9] & ~sctag0_mb_young[9] &  sctag0_mb_type9[5] &  sctag0_mb_type9[2];
wire sctag0_mb9_st_y      = sctag0_mb_valid[9] &  sctag0_mb_young[9] & ~sctag0_mb_type9[5] & (sctag0_mb_type9[4:0] == `STORE_RQ);
wire sctag0_mb9_ld_y      = sctag0_mb_valid[9] &  sctag0_mb_young[9] & ~sctag0_mb_type9[5] & (sctag0_mb_type9[4:0] == `LOAD_RQ);
wire sctag0_mb9_wris8_y   = sctag0_mb_valid[9] &  sctag0_mb_young[9] &  sctag0_mb_type9[5] &  sctag0_mb_type9[1];
wire sctag0_mb9_wris64_y  = sctag0_mb_valid[9] &  sctag0_mb_young[9] &  sctag0_mb_type9[5] &  sctag0_mb_type9[2];

wire sctag0_mb10_st_ny     = sctag0_mb_valid[10] & ~sctag0_mb_young[10] & ~sctag0_mb_type10[5] & (sctag0_mb_type10[4:0] == `STORE_RQ);
wire sctag0_mb10_ld_ny     = sctag0_mb_valid[10] & ~sctag0_mb_young[10] & ~sctag0_mb_type10[5] & (sctag0_mb_type10[4:0] == `LOAD_RQ);
wire sctag0_mb10_wris8_ny  = sctag0_mb_valid[10] & ~sctag0_mb_young[10] &  sctag0_mb_type10[5] &  sctag0_mb_type10[1];
wire sctag0_mb10_wris64_ny = sctag0_mb_valid[10] & ~sctag0_mb_young[10] &  sctag0_mb_type10[5] &  sctag0_mb_type10[2];
wire sctag0_mb10_st_y      = sctag0_mb_valid[10] &  sctag0_mb_young[10] & ~sctag0_mb_type10[5] & (sctag0_mb_type10[4:0] == `STORE_RQ);
wire sctag0_mb10_ld_y      = sctag0_mb_valid[10] &  sctag0_mb_young[10] & ~sctag0_mb_type10[5] & (sctag0_mb_type10[4:0] == `LOAD_RQ);
wire sctag0_mb10_wris8_y   = sctag0_mb_valid[10] &  sctag0_mb_young[10] &  sctag0_mb_type10[5] &  sctag0_mb_type10[1];
wire sctag0_mb10_wris64_y  = sctag0_mb_valid[10] &  sctag0_mb_young[10] &  sctag0_mb_type10[5] &  sctag0_mb_type10[2];

wire sctag0_mb11_st_ny     = sctag0_mb_valid[11] & ~sctag0_mb_young[11] & ~sctag0_mb_type11[5] & (sctag0_mb_type11[4:0] == `STORE_RQ);
wire sctag0_mb11_ld_ny     = sctag0_mb_valid[11] & ~sctag0_mb_young[11] & ~sctag0_mb_type11[5] & (sctag0_mb_type11[4:0] == `LOAD_RQ);
wire sctag0_mb11_wris8_ny  = sctag0_mb_valid[11] & ~sctag0_mb_young[11] &  sctag0_mb_type11[5] &  sctag0_mb_type11[1];
wire sctag0_mb11_wris64_ny = sctag0_mb_valid[11] & ~sctag0_mb_young[11] &  sctag0_mb_type11[5] &  sctag0_mb_type11[2];
wire sctag0_mb11_st_y      = sctag0_mb_valid[11] &  sctag0_mb_young[11] & ~sctag0_mb_type11[5] & (sctag0_mb_type11[4:0] == `STORE_RQ);
wire sctag0_mb11_ld_y      = sctag0_mb_valid[11] &  sctag0_mb_young[11] & ~sctag0_mb_type11[5] & (sctag0_mb_type11[4:0] == `LOAD_RQ);
wire sctag0_mb11_wris8_y   = sctag0_mb_valid[11] &  sctag0_mb_young[11] &  sctag0_mb_type11[5] &  sctag0_mb_type11[1];
wire sctag0_mb11_wris64_y  = sctag0_mb_valid[11] &  sctag0_mb_young[11] &  sctag0_mb_type11[5] &  sctag0_mb_type11[2];

wire sctag0_mb12_st_ny     = sctag0_mb_valid[12] & ~sctag0_mb_young[12] & ~sctag0_mb_type12[5] & (sctag0_mb_type12[4:0] == `STORE_RQ);
wire sctag0_mb12_ld_ny     = sctag0_mb_valid[12] & ~sctag0_mb_young[12] & ~sctag0_mb_type12[5] & (sctag0_mb_type12[4:0] == `LOAD_RQ);
wire sctag0_mb12_wris8_ny  = sctag0_mb_valid[12] & ~sctag0_mb_young[12] &  sctag0_mb_type12[5] &  sctag0_mb_type12[1];
wire sctag0_mb12_wris64_ny = sctag0_mb_valid[12] & ~sctag0_mb_young[12] &  sctag0_mb_type12[5] &  sctag0_mb_type12[2];
wire sctag0_mb12_st_y      = sctag0_mb_valid[12] &  sctag0_mb_young[12] & ~sctag0_mb_type12[5] & (sctag0_mb_type12[4:0] == `STORE_RQ);
wire sctag0_mb12_ld_y      = sctag0_mb_valid[12] &  sctag0_mb_young[12] & ~sctag0_mb_type12[5] & (sctag0_mb_type12[4:0] == `LOAD_RQ);
wire sctag0_mb12_wris8_y   = sctag0_mb_valid[12] &  sctag0_mb_young[12] &  sctag0_mb_type12[5] &  sctag0_mb_type12[1];
wire sctag0_mb12_wris64_y  = sctag0_mb_valid[12] &  sctag0_mb_young[12] &  sctag0_mb_type12[5] &  sctag0_mb_type12[2];

wire sctag0_mb13_st_ny     = sctag0_mb_valid[13] & ~sctag0_mb_young[13] & ~sctag0_mb_type13[5] & (sctag0_mb_type13[4:0] == `STORE_RQ);
wire sctag0_mb13_ld_ny     = sctag0_mb_valid[13] & ~sctag0_mb_young[13] & ~sctag0_mb_type13[5] & (sctag0_mb_type13[4:0] == `LOAD_RQ);
wire sctag0_mb13_wris8_ny  = sctag0_mb_valid[13] & ~sctag0_mb_young[13] &  sctag0_mb_type13[5] &  sctag0_mb_type13[1];
wire sctag0_mb13_wris64_ny = sctag0_mb_valid[13] & ~sctag0_mb_young[13] &  sctag0_mb_type13[5] &  sctag0_mb_type13[2];
wire sctag0_mb13_st_y      = sctag0_mb_valid[13] &  sctag0_mb_young[13] & ~sctag0_mb_type13[5] & (sctag0_mb_type13[4:0] == `STORE_RQ);
wire sctag0_mb13_ld_y      = sctag0_mb_valid[13] &  sctag0_mb_young[13] & ~sctag0_mb_type13[5] & (sctag0_mb_type13[4:0] == `LOAD_RQ);
wire sctag0_mb13_wris8_y   = sctag0_mb_valid[13] &  sctag0_mb_young[13] &  sctag0_mb_type13[5] &  sctag0_mb_type13[1];
wire sctag0_mb13_wris64_y  = sctag0_mb_valid[13] &  sctag0_mb_young[13] &  sctag0_mb_type13[5] &  sctag0_mb_type13[2];

wire sctag0_mb14_st_ny     = sctag0_mb_valid[14] & ~sctag0_mb_young[14] & ~sctag0_mb_type14[5] & (sctag0_mb_type14[4:0] == `STORE_RQ);
wire sctag0_mb14_ld_ny     = sctag0_mb_valid[14] & ~sctag0_mb_young[14] & ~sctag0_mb_type14[5] & (sctag0_mb_type14[4:0] == `LOAD_RQ);
wire sctag0_mb14_wris8_ny  = sctag0_mb_valid[14] & ~sctag0_mb_young[14] &  sctag0_mb_type14[5] &  sctag0_mb_type14[1];
wire sctag0_mb14_wris64_ny = sctag0_mb_valid[14] & ~sctag0_mb_young[14] &  sctag0_mb_type14[5] &  sctag0_mb_type14[2];
wire sctag0_mb14_st_y      = sctag0_mb_valid[14] &  sctag0_mb_young[14] & ~sctag0_mb_type14[5] & (sctag0_mb_type14[4:0] == `STORE_RQ);
wire sctag0_mb14_ld_y      = sctag0_mb_valid[14] &  sctag0_mb_young[14] & ~sctag0_mb_type14[5] & (sctag0_mb_type14[4:0] == `LOAD_RQ);
wire sctag0_mb14_wris8_y   = sctag0_mb_valid[14] &  sctag0_mb_young[14] &  sctag0_mb_type14[5] &  sctag0_mb_type14[1];
wire sctag0_mb14_wris64_y  = sctag0_mb_valid[14] &  sctag0_mb_young[14] &  sctag0_mb_type14[5] &  sctag0_mb_type14[2];

wire sctag0_mb15_st_ny     = sctag0_mb_valid[15] & ~sctag0_mb_young[15] & ~sctag0_mb_type15[5] & (sctag0_mb_type15[4:0] == `STORE_RQ);
wire sctag0_mb15_ld_ny     = sctag0_mb_valid[15] & ~sctag0_mb_young[15] & ~sctag0_mb_type15[5] & (sctag0_mb_type15[4:0] == `LOAD_RQ);
wire sctag0_mb15_wris8_ny  = sctag0_mb_valid[15] & ~sctag0_mb_young[15] &  sctag0_mb_type15[5] &  sctag0_mb_type15[1];
wire sctag0_mb15_wris64_ny = sctag0_mb_valid[15] & ~sctag0_mb_young[15] &  sctag0_mb_type15[5] &  sctag0_mb_type15[2];
wire sctag0_mb15_st_y      = sctag0_mb_valid[15] &  sctag0_mb_young[15] & ~sctag0_mb_type15[5] & (sctag0_mb_type15[4:0] == `STORE_RQ);
wire sctag0_mb15_ld_y      = sctag0_mb_valid[15] &  sctag0_mb_young[15] & ~sctag0_mb_type15[5] & (sctag0_mb_type15[4:0] == `LOAD_RQ);
wire sctag0_mb15_wris8_y   = sctag0_mb_valid[15] &  sctag0_mb_young[15] &  sctag0_mb_type15[5] &  sctag0_mb_type15[1];
wire sctag0_mb15_wris64_y  = sctag0_mb_valid[15] &  sctag0_mb_young[15] &  sctag0_mb_type15[5] &  sctag0_mb_type15[2];


wire [15:0] 	sctag1_mb_valid	    = `TOP_MEMORY.sctag1.mbctl.mb_valid[15:0];
wire [15:0] 	sctag1_mb_young	    = `TOP_MEMORY.sctag1.mbctl.mb_young[15:0];
//wire [3:0] 	sctag1_next_link_entry0  = `TOP_MEMORY.sctag1.mbctl.next_link_entry0[3:0];
//...
//wire [3:0] 	sctag1_next_link_entry15 = `TOP_MEMORY.sctag1.mbctl.next_link_entry15[3:0];

wire [155:0] 	sctag1_mb_data_array0  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[0];
wire [155:0] 	sctag1_mb_data_array1  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[1];
wire [155:0] 	sctag1_mb_data_array2  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[2];
wire [155:0] 	sctag1_mb_data_array3  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[3];
wire [155:0] 	sctag1_mb_data_array4  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[4];
wire [155:0] 	sctag1_mb_data_array5  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[5];
wire [155:0] 	sctag1_mb_data_array6  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[6];
wire [155:0] 	sctag1_mb_data_array7  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[7];
wire [155:0] 	sctag1_mb_data_array8  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[8];
wire [155:0] 	sctag1_mb_data_array9  	= `TOP_MEMORY.sctag1.mbdata.inq_ary[9];
wire [155:0] 	sctag1_mb_data_array10 	= `TOP_MEMORY.sctag1.mbdata.inq_ary[10];
wire [155:0] 	sctag1_mb_data_array11 	= `TOP_MEMORY.sctag1.mbdata.inq_ary[11];
wire [155:0] 	sctag1_mb_data_array12 	= `TOP_MEMORY.sctag1.mbdata.inq_ary[12];
wire [155:0] 	sctag1_mb_data_array13 	= `TOP_MEMORY.sctag1.mbdata.inq_ary[13];
wire [155:0] 	sctag1_mb_data_array14 	= `TOP_MEMORY.sctag1.mbdata.inq_ary[14];
wire [155:0] 	sctag1_mb_data_array15 	= `TOP_MEMORY.sctag1.mbdata.inq_ary[15];

//-----------------------------------------------------------------------------------------------
// look at sctag.v for L2_RDMA_HI L2_RQTYP_HI L2_RQTYP_LO and L2_RSVD
// Based ont the equation: .mb_data_write_data({57'b0,mbdata_inst_tecc_c8...
//-----------------------------------------------------------------------------------------------
wire [5:0]     sctag1_mb_type0  =	{sctag1_mb_data_array0 [77], sctag1_mb_data_array0 [83:79]};
wire [5:0]     sctag1_mb_type1  =	{sctag1_mb_data_array1 [77], sctag1_mb_data_array1 [83:79]};
wire [5:0]     sctag1_mb_type2  =	{sctag1_mb_data_array2 [77], sctag1_mb_data_array2 [83:79]};
wire [5:0]     sctag1_mb_type3  =	{sctag1_mb_data_array3 [77], sctag1_mb_data_array3 [83:79]};
wire [5:0]     sctag1_mb_type4  =	{sctag1_mb_data_array4 [77], sctag1_mb_data_array4 [83:79]};
wire [5:0]     sctag1_mb_type5  =	{sctag1_mb_data_array5 [77], sctag1_mb_data_array5 [83:79]};
wire [5:0]     sctag1_mb_type6  =	{sctag1_mb_data_array6 [77], sctag1_mb_data_array6 [83:79]};
wire [5:0]     sctag1_mb_type7  =	{sctag1_mb_data_array7 [77], sctag1_mb_data_array7 [83:79]};
wire [5:0]     sctag1_mb_type8  =	{sctag1_mb_data_array8 [77], sctag1_mb_data_array8 [83:79]};
wire [5:0]     sctag1_mb_type9  =	{sctag1_mb_data_array9 [77], sctag1_mb_data_array9 [83:79]};
wire [5:0]     sctag1_mb_type10 =	{sctag1_mb_data_array10[77], sctag1_mb_data_array10[83:79]};
wire [5:0]     sctag1_mb_type11 =	{sctag1_mb_data_array11[77], sctag1_mb_data_array11[83:79]};
wire [5:0]     sctag1_mb_type12 =	{sctag1_mb_data_array12[77], sctag1_mb_data_array12[83:79]};
wire [5:0]     sctag1_mb_type13 =	{sctag1_mb_data_array13[77], sctag1_mb_data_array13[83:79]};
wire [5:0]     sctag1_mb_type14 =	{sctag1_mb_data_array14[77], sctag1_mb_data_array14[83:79]};
wire [5:0]     sctag1_mb_type15 =	{sctag1_mb_data_array15[77], sctag1_mb_data_array15[83:79]};

//--------------------------------------------------------------
// Start figuring out what the entries are.
// bit 5 says if this is a DMA type or normal type
//--------------------------------------------------------------

wire sctag1_mb0_st_ny     = sctag1_mb_valid[0] & ~sctag1_mb_young[0] & ~sctag1_mb_type0[5] & (sctag1_mb_type0[4:0] == `STORE_RQ);
wire sctag1_mb0_ld_ny     = sctag1_mb_valid[0] & ~sctag1_mb_young[0] & ~sctag1_mb_type0[5] & (sctag1_mb_type0[4:0] == `LOAD_RQ);
wire sctag1_mb0_wris8_ny  = sctag1_mb_valid[0] & ~sctag1_mb_young[0] &  sctag1_mb_type0[5] &  sctag1_mb_type0[1];
wire sctag1_mb0_wris64_ny = sctag1_mb_valid[0] & ~sctag1_mb_young[0] &  sctag1_mb_type0[5] &  sctag1_mb_type0[2];
wire sctag1_mb0_st_y      = sctag1_mb_valid[0] &  sctag1_mb_young[0] & ~sctag1_mb_type0[5] & (sctag1_mb_type0[4:0] == `STORE_RQ);
wire sctag1_mb0_ld_y      = sctag1_mb_valid[0] &  sctag1_mb_young[0] & ~sctag1_mb_type0[5] & (sctag1_mb_type0[4:0] == `LOAD_RQ);
wire sctag1_mb0_wris8_y   = sctag1_mb_valid[0] &  sctag1_mb_young[0] &  sctag1_mb_type0[5] &  sctag1_mb_type0[1];
wire sctag1_mb0_wris64_y  = sctag1_mb_valid[0] &  sctag1_mb_young[0] &  sctag1_mb_type0[5] &  sctag1_mb_type0[2];

wire sctag1_mb1_st_ny     = sctag1_mb_valid[1] & ~sctag1_mb_young[1] & ~sctag1_mb_type1[5] & (sctag1_mb_type1[4:0] == `STORE_RQ);
wire sctag1_mb1_ld_ny     = sctag1_mb_valid[1] & ~sctag1_mb_young[1] & ~sctag1_mb_type1[5] & (sctag1_mb_type1[4:0] == `LOAD_RQ);
wire sctag1_mb1_wris8_ny  = sctag1_mb_valid[1] & ~sctag1_mb_young[1] &  sctag1_mb_type1[5] &  sctag1_mb_type1[1];
wire sctag1_mb1_wris64_ny = sctag1_mb_valid[1] & ~sctag1_mb_young[1] &  sctag1_mb_type1[5] &  sctag1_mb_type1[2];
wire sctag1_mb1_st_y      = sctag1_mb_valid[1] &  sctag1_mb_young[1] & ~sctag1_mb_type1[5] & (sctag1_mb_type1[4:0] == `STORE_RQ);
wire sctag1_mb1_ld_y      = sctag1_mb_valid[1] &  sctag1_mb_young[1] & ~sctag1_mb_type1[5] & (sctag1_mb_type1[4:0] == `LOAD_RQ);
wire sctag1_mb1_wris8_y   = sctag1_mb_valid[1] &  sctag1_mb_young[1] &  sctag1_mb_type1[5] &  sctag1_mb_type1[1];
wire sctag1_mb1_wris64_y  = sctag1_mb_valid[1] &  sctag1_mb_young[1] &  sctag1_mb_type1[5] &  sctag1_mb_type1[2];

wire sctag1_mb2_st_ny     = sctag1_mb_valid[2] & ~sctag1_mb_young[2] & ~sctag1_mb_type2[5] & (sctag1_mb_type2[4:0] == `STORE_RQ);
wire sctag1_mb2_ld_ny     = sctag1_mb_valid[2] & ~sctag1_mb_young[2] & ~sctag1_mb_type2[5] & (sctag1_mb_type2[4:0] == `LOAD_RQ);
wire sctag1_mb2_wris8_ny  = sctag1_mb_valid[2] & ~sctag1_mb_young[2] &  sctag1_mb_type2[5] &  sctag1_mb_type2[1];
wire sctag1_mb2_wris64_ny = sctag1_mb_valid[2] & ~sctag1_mb_young[2] &  sctag1_mb_type2[5] &  sctag1_mb_type2[2];
wire sctag1_mb2_st_y      = sctag1_mb_valid[2] &  sctag1_mb_young[2] & ~sctag1_mb_type2[5] & (sctag1_mb_type2[4:0] == `STORE_RQ);
wire sctag1_mb2_ld_y      = sctag1_mb_valid[2] &  sctag1_mb_young[2] & ~sctag1_mb_type2[5] & (sctag1_mb_type2[4:0] == `LOAD_RQ);
wire sctag1_mb2_wris8_y   = sctag1_mb_valid[2] &  sctag1_mb_young[2] &  sctag1_mb_type2[5] &  sctag1_mb_type2[1];
wire sctag1_mb2_wris64_y  = sctag1_mb_valid[2] &  sctag1_mb_young[2] &  sctag1_mb_type2[5] &  sctag1_mb_type2[2];

wire sctag1_mb3_st_ny     = sctag1_mb_valid[3] & ~sctag1_mb_young[3] & ~sctag1_mb_type3[5] & (sctag1_mb_type3[4:0] == `STORE_RQ);
wire sctag1_mb3_ld_ny     = sctag1_mb_valid[3] & ~sctag1_mb_young[3] & ~sctag1_mb_type3[5] & (sctag1_mb_type3[4:0] == `LOAD_RQ);
wire sctag1_mb3_wris8_ny  = sctag1_mb_valid[3] & ~sctag1_mb_young[3] &  sctag1_mb_type3[5] &  sctag1_mb_type3[1];
wire sctag1_mb3_wris64_ny = sctag1_mb_valid[3] & ~sctag1_mb_young[3] &  sctag1_mb_type3[5] &  sctag1_mb_type3[2];
wire sctag1_mb3_st_y      = sctag1_mb_valid[3] &  sctag1_mb_young[3] & ~sctag1_mb_type3[5] & (sctag1_mb_type3[4:0] == `STORE_RQ);
wire sctag1_mb3_ld_y      = sctag1_mb_valid[3] &  sctag1_mb_young[3] & ~sctag1_mb_type3[5] & (sctag1_mb_type3[4:0] == `LOAD_RQ);
wire sctag1_mb3_wris8_y   = sctag1_mb_valid[3] &  sctag1_mb_young[3] &  sctag1_mb_type3[5] &  sctag1_mb_type3[1];
wire sctag1_mb3_wris64_y  = sctag1_mb_valid[3] &  sctag1_mb_young[3] &  sctag1_mb_type3[5] &  sctag1_mb_type3[2];

wire sctag1_mb4_st_ny     = sctag1_mb_valid[4] & ~sctag1_mb_young[4] & ~sctag1_mb_type4[5] & (sctag1_mb_type4[4:0] == `STORE_RQ);
wire sctag1_mb4_ld_ny     = sctag1_mb_valid[4] & ~sctag1_mb_young[4] & ~sctag1_mb_type4[5] & (sctag1_mb_type4[4:0] == `LOAD_RQ);
wire sctag1_mb4_wris8_ny  = sctag1_mb_valid[4] & ~sctag1_mb_young[4] &  sctag1_mb_type4[5] &  sctag1_mb_type4[1];
wire sctag1_mb4_wris64_ny = sctag1_mb_valid[4] & ~sctag1_mb_young[4] &  sctag1_mb_type4[5] &  sctag1_mb_type4[2];
wire sctag1_mb4_st_y      = sctag1_mb_valid[4] &  sctag1_mb_young[4] & ~sctag1_mb_type4[5] & (sctag1_mb_type4[4:0] == `STORE_RQ);
wire sctag1_mb4_ld_y      = sctag1_mb_valid[4] &  sctag1_mb_young[4] & ~sctag1_mb_type4[5] & (sctag1_mb_type4[4:0] == `LOAD_RQ);
wire sctag1_mb4_wris8_y   = sctag1_mb_valid[4] &  sctag1_mb_young[4] &  sctag1_mb_type4[5] &  sctag1_mb_type4[1];
wire sctag1_mb4_wris64_y  = sctag1_mb_valid[4] &  sctag1_mb_young[4] &  sctag1_mb_type4[5] &  sctag1_mb_type4[2];

wire sctag1_mb5_st_ny     = sctag1_mb_valid[5] & ~sctag1_mb_young[5] & ~sctag1_mb_type5[5] & (sctag1_mb_type5[4:0] == `STORE_RQ);
wire sctag1_mb5_ld_ny     = sctag1_mb_valid[5] & ~sctag1_mb_young[5] & ~sctag1_mb_type5[5] & (sctag1_mb_type5[4:0] == `LOAD_RQ);
wire sctag1_mb5_wris8_ny  = sctag1_mb_valid[5] & ~sctag1_mb_young[5] &  sctag1_mb_type5[5] &  sctag1_mb_type5[1];
wire sctag1_mb5_wris64_ny = sctag1_mb_valid[5] & ~sctag1_mb_young[5] &  sctag1_mb_type5[5] &  sctag1_mb_type5[2];
wire sctag1_mb5_st_y      = sctag1_mb_valid[5] &  sctag1_mb_young[5] & ~sctag1_mb_type5[5] & (sctag1_mb_type5[4:0] == `STORE_RQ);
wire sctag1_mb5_ld_y      = sctag1_mb_valid[5] &  sctag1_mb_young[5] & ~sctag1_mb_type5[5] & (sctag1_mb_type5[4:0] == `LOAD_RQ);
wire sctag1_mb5_wris8_y   = sctag1_mb_valid[5] &  sctag1_mb_young[5] &  sctag1_mb_type5[5] &  sctag1_mb_type5[1];
wire sctag1_mb5_wris64_y  = sctag1_mb_valid[5] &  sctag1_mb_young[5] &  sctag1_mb_type5[5] &  sctag1_mb_type5[2];

wire sctag1_mb6_st_ny     = sctag1_mb_valid[6] & ~sctag1_mb_young[6] & ~sctag1_mb_type6[5] & (sctag1_mb_type6[4:0] == `STORE_RQ);
wire sctag1_mb6_ld_ny     = sctag1_mb_valid[6] & ~sctag1_mb_young[6] & ~sctag1_mb_type6[5] & (sctag1_mb_type6[4:0] == `LOAD_RQ);
wire sctag1_mb6_wris8_ny  = sctag1_mb_valid[6] & ~sctag1_mb_young[6] &  sctag1_mb_type6[5] &  sctag1_mb_type6[1];
wire sctag1_mb6_wris64_ny = sctag1_mb_valid[6] & ~sctag1_mb_young[6] &  sctag1_mb_type6[5] &  sctag1_mb_type6[2];
wire sctag1_mb6_st_y      = sctag1_mb_valid[6] &  sctag1_mb_young[6] & ~sctag1_mb_type6[5] & (sctag1_mb_type6[4:0] == `STORE_RQ);
wire sctag1_mb6_ld_y      = sctag1_mb_valid[6] &  sctag1_mb_young[6] & ~sctag1_mb_type6[5] & (sctag1_mb_type6[4:0] == `LOAD_RQ);
wire sctag1_mb6_wris8_y   = sctag1_mb_valid[6] &  sctag1_mb_young[6] &  sctag1_mb_type6[5] &  sctag1_mb_type6[1];
wire sctag1_mb6_wris64_y  = sctag1_mb_valid[6] &  sctag1_mb_young[6] &  sctag1_mb_type6[5] &  sctag1_mb_type6[2];

wire sctag1_mb7_st_ny     = sctag1_mb_valid[7] & ~sctag1_mb_young[7] & ~sctag1_mb_type7[5] & (sctag1_mb_type7[4:0] == `STORE_RQ);
wire sctag1_mb7_ld_ny     = sctag1_mb_valid[7] & ~sctag1_mb_young[7] & ~sctag1_mb_type7[5] & (sctag1_mb_type7[4:0] == `LOAD_RQ);
wire sctag1_mb7_wris8_ny  = sctag1_mb_valid[7] & ~sctag1_mb_young[7] &  sctag1_mb_type7[5] &  sctag1_mb_type7[1];
wire sctag1_mb7_wris64_ny = sctag1_mb_valid[7] & ~sctag1_mb_young[7] &  sctag1_mb_type7[5] &  sctag1_mb_type7[2];
wire sctag1_mb7_st_y      = sctag1_mb_valid[7] &  sctag1_mb_young[7] & ~sctag1_mb_type7[5] & (sctag1_mb_type7[4:0] == `STORE_RQ);
wire sctag1_mb7_ld_y      = sctag1_mb_valid[7] &  sctag1_mb_young[7] & ~sctag1_mb_type7[5] & (sctag1_mb_type7[4:0] == `LOAD_RQ);
wire sctag1_mb7_wris8_y   = sctag1_mb_valid[7] &  sctag1_mb_young[7] &  sctag1_mb_type7[5] &  sctag1_mb_type7[1];
wire sctag1_mb7_wris64_y  = sctag1_mb_valid[7] &  sctag1_mb_young[7] &  sctag1_mb_type7[5] &  sctag1_mb_type7[2];

wire sctag1_mb8_st_ny     = sctag1_mb_valid[8] & ~sctag1_mb_young[8] & ~sctag1_mb_type8[5] & (sctag1_mb_type8[4:0] == `STORE_RQ);
wire sctag1_mb8_ld_ny     = sctag1_mb_valid[8] & ~sctag1_mb_young[8] & ~sctag1_mb_type8[5] & (sctag1_mb_type8[4:0] == `LOAD_RQ);
wire sctag1_mb8_wris8_ny  = sctag1_mb_valid[8] & ~sctag1_mb_young[8] &  sctag1_mb_type8[5] &  sctag1_mb_type8[1];
wire sctag1_mb8_wris64_ny = sctag1_mb_valid[8] & ~sctag1_mb_young[8] &  sctag1_mb_type8[5] &  sctag1_mb_type8[2];
wire sctag1_mb8_st_y      = sctag1_mb_valid[8] &  sctag1_mb_young[8] & ~sctag1_mb_type8[5] & (sctag1_mb_type8[4:0] == `STORE_RQ);
wire sctag1_mb8_ld_y      = sctag1_mb_valid[8] &  sctag1_mb_young[8] & ~sctag1_mb_type8[5] & (sctag1_mb_type8[4:0] == `LOAD_RQ);
wire sctag1_mb8_wris8_y   = sctag1_mb_valid[8] &  sctag1_mb_young[8] &  sctag1_mb_type8[5] &  sctag1_mb_type8[1];
wire sctag1_mb8_wris64_y  = sctag1_mb_valid[8] &  sctag1_mb_young[8] &  sctag1_mb_type8[5] &  sctag1_mb_type8[2];

wire sctag1_mb9_st_ny     = sctag1_mb_valid[9] & ~sctag1_mb_young[9] & ~sctag1_mb_type9[5] & (sctag1_mb_type9[4:0] == `STORE_RQ);
wire sctag1_mb9_ld_ny     = sctag1_mb_valid[9] & ~sctag1_mb_young[9] & ~sctag1_mb_type9[5] & (sctag1_mb_type9[4:0] == `LOAD_RQ);
wire sctag1_mb9_wris8_ny  = sctag1_mb_valid[9] & ~sctag1_mb_young[9] &  sctag1_mb_type9[5] &  sctag1_mb_type9[1];
wire sctag1_mb9_wris64_ny = sctag1_mb_valid[9] & ~sctag1_mb_young[9] &  sctag1_mb_type9[5] &  sctag1_mb_type9[2];
wire sctag1_mb9_st_y      = sctag1_mb_valid[9] &  sctag1_mb_young[9] & ~sctag1_mb_type9[5] & (sctag1_mb_type9[4:0] == `STORE_RQ);
wire sctag1_mb9_ld_y      = sctag1_mb_valid[9] &  sctag1_mb_young[9] & ~sctag1_mb_type9[5] & (sctag1_mb_type9[4:0] == `LOAD_RQ);
wire sctag1_mb9_wris8_y   = sctag1_mb_valid[9] &  sctag1_mb_young[9] &  sctag1_mb_type9[5] &  sctag1_mb_type9[1];
wire sctag1_mb9_wris64_y  = sctag1_mb_valid[9] &  sctag1_mb_young[9] &  sctag1_mb_type9[5] &  sctag1_mb_type9[2];

wire sctag1_mb10_st_ny     = sctag1_mb_valid[10] & ~sctag1_mb_young[10] & ~sctag1_mb_type10[5] & (sctag1_mb_type10[4:0] == `STORE_RQ);
wire sctag1_mb10_ld_ny     = sctag1_mb_valid[10] & ~sctag1_mb_young[10] & ~sctag1_mb_type10[5] & (sctag1_mb_type10[4:0] == `LOAD_RQ);
wire sctag1_mb10_wris8_ny  = sctag1_mb_valid[10] & ~sctag1_mb_young[10] &  sctag1_mb_type10[5] &  sctag1_mb_type10[1];
wire sctag1_mb10_wris64_ny = sctag1_mb_valid[10] & ~sctag1_mb_young[10] &  sctag1_mb_type10[5] &  sctag1_mb_type10[2];
wire sctag1_mb10_st_y      = sctag1_mb_valid[10] &  sctag1_mb_young[10] & ~sctag1_mb_type10[5] & (sctag1_mb_type10[4:0] == `STORE_RQ);
wire sctag1_mb10_ld_y      = sctag1_mb_valid[10] &  sctag1_mb_young[10] & ~sctag1_mb_type10[5] & (sctag1_mb_type10[4:0] == `LOAD_RQ);
wire sctag1_mb10_wris8_y   = sctag1_mb_valid[10] &  sctag1_mb_young[10] &  sctag1_mb_type10[5] &  sctag1_mb_type10[1];
wire sctag1_mb10_wris64_y  = sctag1_mb_valid[10] &  sctag1_mb_young[10] &  sctag1_mb_type10[5] &  sctag1_mb_type10[2];

wire sctag1_mb11_st_ny     = sctag1_mb_valid[11] & ~sctag1_mb_young[11] & ~sctag1_mb_type11[5] & (sctag1_mb_type11[4:0] == `STORE_RQ);
wire sctag1_mb11_ld_ny     = sctag1_mb_valid[11] & ~sctag1_mb_young[11] & ~sctag1_mb_type11[5] & (sctag1_mb_type11[4:0] == `LOAD_RQ);
wire sctag1_mb11_wris8_ny  = sctag1_mb_valid[11] & ~sctag1_mb_young[11] &  sctag1_mb_type11[5] &  sctag1_mb_type11[1];
wire sctag1_mb11_wris64_ny = sctag1_mb_valid[11] & ~sctag1_mb_young[11] &  sctag1_mb_type11[5] &  sctag1_mb_type11[2];
wire sctag1_mb11_st_y      = sctag1_mb_valid[11] &  sctag1_mb_young[11] & ~sctag1_mb_type11[5] & (sctag1_mb_type11[4:0] == `STORE_RQ);
wire sctag1_mb11_ld_y      = sctag1_mb_valid[11] &  sctag1_mb_young[11] & ~sctag1_mb_type11[5] & (sctag1_mb_type11[4:0] == `LOAD_RQ);
wire sctag1_mb11_wris8_y   = sctag1_mb_valid[11] &  sctag1_mb_young[11] &  sctag1_mb_type11[5] &  sctag1_mb_type11[1];
wire sctag1_mb11_wris64_y  = sctag1_mb_valid[11] &  sctag1_mb_young[11] &  sctag1_mb_type11[5] &  sctag1_mb_type11[2];

wire sctag1_mb12_st_ny     = sctag1_mb_valid[12] & ~sctag1_mb_young[12] & ~sctag1_mb_type12[5] & (sctag1_mb_type12[4:0] == `STORE_RQ);
wire sctag1_mb12_ld_ny     = sctag1_mb_valid[12] & ~sctag1_mb_young[12] & ~sctag1_mb_type12[5] & (sctag1_mb_type12[4:0] == `LOAD_RQ);
wire sctag1_mb12_wris8_ny  = sctag1_mb_valid[12] & ~sctag1_mb_young[12] &  sctag1_mb_type12[5] &  sctag1_mb_type12[1];
wire sctag1_mb12_wris64_ny = sctag1_mb_valid[12] & ~sctag1_mb_young[12] &  sctag1_mb_type12[5] &  sctag1_mb_type12[2];
wire sctag1_mb12_st_y      = sctag1_mb_valid[12] &  sctag1_mb_young[12] & ~sctag1_mb_type12[5] & (sctag1_mb_type12[4:0] == `STORE_RQ);
wire sctag1_mb12_ld_y      = sctag1_mb_valid[12] &  sctag1_mb_young[12] & ~sctag1_mb_type12[5] & (sctag1_mb_type12[4:0] == `LOAD_RQ);
wire sctag1_mb12_wris8_y   = sctag1_mb_valid[12] &  sctag1_mb_young[12] &  sctag1_mb_type12[5] &  sctag1_mb_type12[1];
wire sctag1_mb12_wris64_y  = sctag1_mb_valid[12] &  sctag1_mb_young[12] &  sctag1_mb_type12[5] &  sctag1_mb_type12[2];

wire sctag1_mb13_st_ny     = sctag1_mb_valid[13] & ~sctag1_mb_young[13] & ~sctag1_mb_type13[5] & (sctag1_mb_type13[4:0] == `STORE_RQ);
wire sctag1_mb13_ld_ny     = sctag1_mb_valid[13] & ~sctag1_mb_young[13] & ~sctag1_mb_type13[5] & (sctag1_mb_type13[4:0] == `LOAD_RQ);
wire sctag1_mb13_wris8_ny  = sctag1_mb_valid[13] & ~sctag1_mb_young[13] &  sctag1_mb_type13[5] &  sctag1_mb_type13[1];
wire sctag1_mb13_wris64_ny = sctag1_mb_valid[13] & ~sctag1_mb_young[13] &  sctag1_mb_type13[5] &  sctag1_mb_type13[2];
wire sctag1_mb13_st_y      = sctag1_mb_valid[13] &  sctag1_mb_young[13] & ~sctag1_mb_type13[5] & (sctag1_mb_type13[4:0] == `STORE_RQ);
wire sctag1_mb13_ld_y      = sctag1_mb_valid[13] &  sctag1_mb_young[13] & ~sctag1_mb_type13[5] & (sctag1_mb_type13[4:0] == `LOAD_RQ);
wire sctag1_mb13_wris8_y   = sctag1_mb_valid[13] &  sctag1_mb_young[13] &  sctag1_mb_type13[5] &  sctag1_mb_type13[1];
wire sctag1_mb13_wris64_y  = sctag1_mb_valid[13] &  sctag1_mb_young[13] &  sctag1_mb_type13[5] &  sctag1_mb_type13[2];

wire sctag1_mb14_st_ny     = sctag1_mb_valid[14] & ~sctag1_mb_young[14] & ~sctag1_mb_type14[5] & (sctag1_mb_type14[4:0] == `STORE_RQ);
wire sctag1_mb14_ld_ny     = sctag1_mb_valid[14] & ~sctag1_mb_young[14] & ~sctag1_mb_type14[5] & (sctag1_mb_type14[4:0] == `LOAD_RQ);
wire sctag1_mb14_wris8_ny  = sctag1_mb_valid[14] & ~sctag1_mb_young[14] &  sctag1_mb_type14[5] &  sctag1_mb_type14[1];
wire sctag1_mb14_wris64_ny = sctag1_mb_valid[14] & ~sctag1_mb_young[14] &  sctag1_mb_type14[5] &  sctag1_mb_type14[2];
wire sctag1_mb14_st_y      = sctag1_mb_valid[14] &  sctag1_mb_young[14] & ~sctag1_mb_type14[5] & (sctag1_mb_type14[4:0] == `STORE_RQ);
wire sctag1_mb14_ld_y      = sctag1_mb_valid[14] &  sctag1_mb_young[14] & ~sctag1_mb_type14[5] & (sctag1_mb_type14[4:0] == `LOAD_RQ);
wire sctag1_mb14_wris8_y   = sctag1_mb_valid[14] &  sctag1_mb_young[14] &  sctag1_mb_type14[5] &  sctag1_mb_type14[1];
wire sctag1_mb14_wris64_y  = sctag1_mb_valid[14] &  sctag1_mb_young[14] &  sctag1_mb_type14[5] &  sctag1_mb_type14[2];

wire sctag1_mb15_st_ny     = sctag1_mb_valid[15] & ~sctag1_mb_young[15] & ~sctag1_mb_type15[5] & (sctag1_mb_type15[4:0] == `STORE_RQ);
wire sctag1_mb15_ld_ny     = sctag1_mb_valid[15] & ~sctag1_mb_young[15] & ~sctag1_mb_type15[5] & (sctag1_mb_type15[4:0] == `LOAD_RQ);
wire sctag1_mb15_wris8_ny  = sctag1_mb_valid[15] & ~sctag1_mb_young[15] &  sctag1_mb_type15[5] &  sctag1_mb_type15[1];
wire sctag1_mb15_wris64_ny = sctag1_mb_valid[15] & ~sctag1_mb_young[15] &  sctag1_mb_type15[5] &  sctag1_mb_type15[2];
wire sctag1_mb15_st_y      = sctag1_mb_valid[15] &  sctag1_mb_young[15] & ~sctag1_mb_type15[5] & (sctag1_mb_type15[4:0] == `STORE_RQ);
wire sctag1_mb15_ld_y      = sctag1_mb_valid[15] &  sctag1_mb_young[15] & ~sctag1_mb_type15[5] & (sctag1_mb_type15[4:0] == `LOAD_RQ);
wire sctag1_mb15_wris8_y   = sctag1_mb_valid[15] &  sctag1_mb_young[15] &  sctag1_mb_type15[5] &  sctag1_mb_type15[1];
wire sctag1_mb15_wris64_y  = sctag1_mb_valid[15] &  sctag1_mb_young[15] &  sctag1_mb_type15[5] &  sctag1_mb_type15[2];


wire [15:0] 	sctag2_mb_valid	    = `TOP_MEMORY.sctag2.mbctl.mb_valid[15:0];
wire [15:0] 	sctag2_mb_young	    = `TOP_MEMORY.sctag2.mbctl.mb_young[15:0];
//wire [3:0] 	sctag2_next_link_entry0  = `TOP_MEMORY.sctag2.mbctl.next_link_entry0[3:0];
//...
//wire [3:0] 	sctag2_next_link_entry15 = `TOP_MEMORY.sctag2.mbctl.next_link_entry15[3:0];

wire [155:0] 	sctag2_mb_data_array0  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[0];
wire [155:0] 	sctag2_mb_data_array1  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[1];
wire [155:0] 	sctag2_mb_data_array2  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[2];
wire [155:0] 	sctag2_mb_data_array3  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[3];
wire [155:0] 	sctag2_mb_data_array4  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[4];
wire [155:0] 	sctag2_mb_data_array5  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[5];
wire [155:0] 	sctag2_mb_data_array6  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[6];
wire [155:0] 	sctag2_mb_data_array7  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[7];
wire [155:0] 	sctag2_mb_data_array8  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[8];
wire [155:0] 	sctag2_mb_data_array9  	= `TOP_MEMORY.sctag2.mbdata.inq_ary[9];
wire [155:0] 	sctag2_mb_data_array10 	= `TOP_MEMORY.sctag2.mbdata.inq_ary[10];
wire [155:0] 	sctag2_mb_data_array11 	= `TOP_MEMORY.sctag2.mbdata.inq_ary[11];
wire [155:0] 	sctag2_mb_data_array12 	= `TOP_MEMORY.sctag2.mbdata.inq_ary[12];
wire [155:0] 	sctag2_mb_data_array13 	= `TOP_MEMORY.sctag2.mbdata.inq_ary[13];
wire [155:0] 	sctag2_mb_data_array14 	= `TOP_MEMORY.sctag2.mbdata.inq_ary[14];
wire [155:0] 	sctag2_mb_data_array15 	= `TOP_MEMORY.sctag2.mbdata.inq_ary[15];

//-----------------------------------------------------------------------------------------------
// look at sctag.v for L2_RDMA_HI L2_RQTYP_HI L2_RQTYP_LO and L2_RSVD
// Based ont the equation: .mb_data_write_data({57'b0,mbdata_inst_tecc_c8...
//-----------------------------------------------------------------------------------------------
wire [5:0]     sctag2_mb_type0  =	{sctag2_mb_data_array0 [77], sctag2_mb_data_array0 [83:79]};
wire [5:0]     sctag2_mb_type1  =	{sctag2_mb_data_array1 [77], sctag2_mb_data_array1 [83:79]};
wire [5:0]     sctag2_mb_type2  =	{sctag2_mb_data_array2 [77], sctag2_mb_data_array2 [83:79]};
wire [5:0]     sctag2_mb_type3  =	{sctag2_mb_data_array3 [77], sctag2_mb_data_array3 [83:79]};
wire [5:0]     sctag2_mb_type4  =	{sctag2_mb_data_array4 [77], sctag2_mb_data_array4 [83:79]};
wire [5:0]     sctag2_mb_type5  =	{sctag2_mb_data_array5 [77], sctag2_mb_data_array5 [83:79]};
wire [5:0]     sctag2_mb_type6  =	{sctag2_mb_data_array6 [77], sctag2_mb_data_array6 [83:79]};
wire [5:0]     sctag2_mb_type7  =	{sctag2_mb_data_array7 [77], sctag2_mb_data_array7 [83:79]};
wire [5:0]     sctag2_mb_type8  =	{sctag2_mb_data_array8 [77], sctag2_mb_data_array8 [83:79]};
wire [5:0]     sctag2_mb_type9  =	{sctag2_mb_data_array9 [77], sctag2_mb_data_array9 [83:79]};
wire [5:0]     sctag2_mb_type10 =	{sctag2_mb_data_array10[77], sctag2_mb_data_array10[83:79]};
wire [5:0]     sctag2_mb_type11 =	{sctag2_mb_data_array11[77], sctag2_mb_data_array11[83:79]};
wire [5:0]     sctag2_mb_type12 =	{sctag2_mb_data_array12[77], sctag2_mb_data_array12[83:79]};
wire [5:0]     sctag2_mb_type13 =	{sctag2_mb_data_array13[77], sctag2_mb_data_array13[83:79]};
wire [5:0]     sctag2_mb_type14 =	{sctag2_mb_data_array14[77], sctag2_mb_data_array14[83:79]};
wire [5:0]     sctag2_mb_type15 =	{sctag2_mb_data_array15[77], sctag2_mb_data_array15[83:79]};

//--------------------------------------------------------------
// Start figuring out what the entries are.
// bit 5 says if this is a DMA type or normal type
//--------------------------------------------------------------

wire sctag2_mb0_st_ny     = sctag2_mb_valid[0] & ~sctag2_mb_young[0] & ~sctag2_mb_type0[5] & (sctag2_mb_type0[4:0] == `STORE_RQ);
wire sctag2_mb0_ld_ny     = sctag2_mb_valid[0] & ~sctag2_mb_young[0] & ~sctag2_mb_type0[5] & (sctag2_mb_type0[4:0] == `LOAD_RQ);
wire sctag2_mb0_wris8_ny  = sctag2_mb_valid[0] & ~sctag2_mb_young[0] &  sctag2_mb_type0[5] &  sctag2_mb_type0[1];
wire sctag2_mb0_wris64_ny = sctag2_mb_valid[0] & ~sctag2_mb_young[0] &  sctag2_mb_type0[5] &  sctag2_mb_type0[2];
wire sctag2_mb0_st_y      = sctag2_mb_valid[0] &  sctag2_mb_young[0] & ~sctag2_mb_type0[5] & (sctag2_mb_type0[4:0] == `STORE_RQ);
wire sctag2_mb0_ld_y      = sctag2_mb_valid[0] &  sctag2_mb_young[0] & ~sctag2_mb_type0[5] & (sctag2_mb_type0[4:0] == `LOAD_RQ);
wire sctag2_mb0_wris8_y   = sctag2_mb_valid[0] &  sctag2_mb_young[0] &  sctag2_mb_type0[5] &  sctag2_mb_type0[1];
wire sctag2_mb0_wris64_y  = sctag2_mb_valid[0] &  sctag2_mb_young[0] &  sctag2_mb_type0[5] &  sctag2_mb_type0[2];

wire sctag2_mb1_st_ny     = sctag2_mb_valid[1] & ~sctag2_mb_young[1] & ~sctag2_mb_type1[5] & (sctag2_mb_type1[4:0] == `STORE_RQ);
wire sctag2_mb1_ld_ny     = sctag2_mb_valid[1] & ~sctag2_mb_young[1] & ~sctag2_mb_type1[5] & (sctag2_mb_type1[4:0] == `LOAD_RQ);
wire sctag2_mb1_wris8_ny  = sctag2_mb_valid[1] & ~sctag2_mb_young[1] &  sctag2_mb_type1[5] &  sctag2_mb_type1[1];
wire sctag2_mb1_wris64_ny = sctag2_mb_valid[1] & ~sctag2_mb_young[1] &  sctag2_mb_type1[5] &  sctag2_mb_type1[2];
wire sctag2_mb1_st_y      = sctag2_mb_valid[1] &  sctag2_mb_young[1] & ~sctag2_mb_type1[5] & (sctag2_mb_type1[4:0] == `STORE_RQ);
wire sctag2_mb1_ld_y      = sctag2_mb_valid[1] &  sctag2_mb_young[1] & ~sctag2_mb_type1[5] & (sctag2_mb_type1[4:0] == `LOAD_RQ);
wire sctag2_mb1_wris8_y   = sctag2_mb_valid[1] &  sctag2_mb_young[1] &  sctag2_mb_type1[5] &  sctag2_mb_type1[1];
wire sctag2_mb1_wris64_y  = sctag2_mb_valid[1] &  sctag2_mb_young[1] &  sctag2_mb_type1[5] &  sctag2_mb_type1[2];

wire sctag2_mb2_st_ny     = sctag2_mb_valid[2] & ~sctag2_mb_young[2] & ~sctag2_mb_type2[5] & (sctag2_mb_type2[4:0] == `STORE_RQ);
wire sctag2_mb2_ld_ny     = sctag2_mb_valid[2] & ~sctag2_mb_young[2] & ~sctag2_mb_type2[5] & (sctag2_mb_type2[4:0] == `LOAD_RQ);
wire sctag2_mb2_wris8_ny  = sctag2_mb_valid[2] & ~sctag2_mb_young[2] &  sctag2_mb_type2[5] &  sctag2_mb_type2[1];
wire sctag2_mb2_wris64_ny = sctag2_mb_valid[2] & ~sctag2_mb_young[2] &  sctag2_mb_type2[5] &  sctag2_mb_type2[2];
wire sctag2_mb2_st_y      = sctag2_mb_valid[2] &  sctag2_mb_young[2] & ~sctag2_mb_type2[5] & (sctag2_mb_type2[4:0] == `STORE_RQ);
wire sctag2_mb2_ld_y      = sctag2_mb_valid[2] &  sctag2_mb_young[2] & ~sctag2_mb_type2[5] & (sctag2_mb_type2[4:0] == `LOAD_RQ);
wire sctag2_mb2_wris8_y   = sctag2_mb_valid[2] &  sctag2_mb_young[2] &  sctag2_mb_type2[5] &  sctag2_mb_type2[1];
wire sctag2_mb2_wris64_y  = sctag2_mb_valid[2] &  sctag2_mb_young[2] &  sctag2_mb_type2[5] &  sctag2_mb_type2[2];

wire sctag2_mb3_st_ny     = sctag2_mb_valid[3] & ~sctag2_mb_young[3] & ~sctag2_mb_type3[5] & (sctag2_mb_type3[4:0] == `STORE_RQ);
wire sctag2_mb3_ld_ny     = sctag2_mb_valid[3] & ~sctag2_mb_young[3] & ~sctag2_mb_type3[5] & (sctag2_mb_type3[4:0] == `LOAD_RQ);
wire sctag2_mb3_wris8_ny  = sctag2_mb_valid[3] & ~sctag2_mb_young[3] &  sctag2_mb_type3[5] &  sctag2_mb_type3[1];
wire sctag2_mb3_wris64_ny = sctag2_mb_valid[3] & ~sctag2_mb_young[3] &  sctag2_mb_type3[5] &  sctag2_mb_type3[2];
wire sctag2_mb3_st_y      = sctag2_mb_valid[3] &  sctag2_mb_young[3] & ~sctag2_mb_type3[5] & (sctag2_mb_type3[4:0] == `STORE_RQ);
wire sctag2_mb3_ld_y      = sctag2_mb_valid[3] &  sctag2_mb_young[3] & ~sctag2_mb_type3[5] & (sctag2_mb_type3[4:0] == `LOAD_RQ);
wire sctag2_mb3_wris8_y   = sctag2_mb_valid[3] &  sctag2_mb_young[3] &  sctag2_mb_type3[5] &  sctag2_mb_type3[1];
wire sctag2_mb3_wris64_y  = sctag2_mb_valid[3] &  sctag2_mb_young[3] &  sctag2_mb_type3[5] &  sctag2_mb_type3[2];

wire sctag2_mb4_st_ny     = sctag2_mb_valid[4] & ~sctag2_mb_young[4] & ~sctag2_mb_type4[5] & (sctag2_mb_type4[4:0] == `STORE_RQ);
wire sctag2_mb4_ld_ny     = sctag2_mb_valid[4] & ~sctag2_mb_young[4] & ~sctag2_mb_type4[5] & (sctag2_mb_type4[4:0] == `LOAD_RQ);
wire sctag2_mb4_wris8_ny  = sctag2_mb_valid[4] & ~sctag2_mb_young[4] &  sctag2_mb_type4[5] &  sctag2_mb_type4[1];
wire sctag2_mb4_wris64_ny = sctag2_mb_valid[4] & ~sctag2_mb_young[4] &  sctag2_mb_type4[5] &  sctag2_mb_type4[2];
wire sctag2_mb4_st_y      = sctag2_mb_valid[4] &  sctag2_mb_young[4] & ~sctag2_mb_type4[5] & (sctag2_mb_type4[4:0] == `STORE_RQ);
wire sctag2_mb4_ld_y      = sctag2_mb_valid[4] &  sctag2_mb_young[4] & ~sctag2_mb_type4[5] & (sctag2_mb_type4[4:0] == `LOAD_RQ);
wire sctag2_mb4_wris8_y   = sctag2_mb_valid[4] &  sctag2_mb_young[4] &  sctag2_mb_type4[5] &  sctag2_mb_type4[1];
wire sctag2_mb4_wris64_y  = sctag2_mb_valid[4] &  sctag2_mb_young[4] &  sctag2_mb_type4[5] &  sctag2_mb_type4[2];

wire sctag2_mb5_st_ny     = sctag2_mb_valid[5] & ~sctag2_mb_young[5] & ~sctag2_mb_type5[5] & (sctag2_mb_type5[4:0] == `STORE_RQ);
wire sctag2_mb5_ld_ny     = sctag2_mb_valid[5] & ~sctag2_mb_young[5] & ~sctag2_mb_type5[5] & (sctag2_mb_type5[4:0] == `LOAD_RQ);
wire sctag2_mb5_wris8_ny  = sctag2_mb_valid[5] & ~sctag2_mb_young[5] &  sctag2_mb_type5[5] &  sctag2_mb_type5[1];
wire sctag2_mb5_wris64_ny = sctag2_mb_valid[5] & ~sctag2_mb_young[5] &  sctag2_mb_type5[5] &  sctag2_mb_type5[2];
wire sctag2_mb5_st_y      = sctag2_mb_valid[5] &  sctag2_mb_young[5] & ~sctag2_mb_type5[5] & (sctag2_mb_type5[4:0] == `STORE_RQ);
wire sctag2_mb5_ld_y      = sctag2_mb_valid[5] &  sctag2_mb_young[5] & ~sctag2_mb_type5[5] & (sctag2_mb_type5[4:0] == `LOAD_RQ);
wire sctag2_mb5_wris8_y   = sctag2_mb_valid[5] &  sctag2_mb_young[5] &  sctag2_mb_type5[5] &  sctag2_mb_type5[1];
wire sctag2_mb5_wris64_y  = sctag2_mb_valid[5] &  sctag2_mb_young[5] &  sctag2_mb_type5[5] &  sctag2_mb_type5[2];

wire sctag2_mb6_st_ny     = sctag2_mb_valid[6] & ~sctag2_mb_young[6] & ~sctag2_mb_type6[5] & (sctag2_mb_type6[4:0] == `STORE_RQ);
wire sctag2_mb6_ld_ny     = sctag2_mb_valid[6] & ~sctag2_mb_young[6] & ~sctag2_mb_type6[5] & (sctag2_mb_type6[4:0] == `LOAD_RQ);
wire sctag2_mb6_wris8_ny  = sctag2_mb_valid[6] & ~sctag2_mb_young[6] &  sctag2_mb_type6[5] &  sctag2_mb_type6[1];
wire sctag2_mb6_wris64_ny = sctag2_mb_valid[6] & ~sctag2_mb_young[6] &  sctag2_mb_type6[5] &  sctag2_mb_type6[2];
wire sctag2_mb6_st_y      = sctag2_mb_valid[6] &  sctag2_mb_young[6] & ~sctag2_mb_type6[5] & (sctag2_mb_type6[4:0] == `STORE_RQ);
wire sctag2_mb6_ld_y      = sctag2_mb_valid[6] &  sctag2_mb_young[6] & ~sctag2_mb_type6[5] & (sctag2_mb_type6[4:0] == `LOAD_RQ);
wire sctag2_mb6_wris8_y   = sctag2_mb_valid[6] &  sctag2_mb_young[6] &  sctag2_mb_type6[5] &  sctag2_mb_type6[1];
wire sctag2_mb6_wris64_y  = sctag2_mb_valid[6] &  sctag2_mb_young[6] &  sctag2_mb_type6[5] &  sctag2_mb_type6[2];

wire sctag2_mb7_st_ny     = sctag2_mb_valid[7] & ~sctag2_mb_young[7] & ~sctag2_mb_type7[5] & (sctag2_mb_type7[4:0] == `STORE_RQ);
wire sctag2_mb7_ld_ny     = sctag2_mb_valid[7] & ~sctag2_mb_young[7] & ~sctag2_mb_type7[5] & (sctag2_mb_type7[4:0] == `LOAD_RQ);
wire sctag2_mb7_wris8_ny  = sctag2_mb_valid[7] & ~sctag2_mb_young[7] &  sctag2_mb_type7[5] &  sctag2_mb_type7[1];
wire sctag2_mb7_wris64_ny = sctag2_mb_valid[7] & ~sctag2_mb_young[7] &  sctag2_mb_type7[5] &  sctag2_mb_type7[2];
wire sctag2_mb7_st_y      = sctag2_mb_valid[7] &  sctag2_mb_young[7] & ~sctag2_mb_type7[5] & (sctag2_mb_type7[4:0] == `STORE_RQ);
wire sctag2_mb7_ld_y      = sctag2_mb_valid[7] &  sctag2_mb_young[7] & ~sctag2_mb_type7[5] & (sctag2_mb_type7[4:0] == `LOAD_RQ);
wire sctag2_mb7_wris8_y   = sctag2_mb_valid[7] &  sctag2_mb_young[7] &  sctag2_mb_type7[5] &  sctag2_mb_type7[1];
wire sctag2_mb7_wris64_y  = sctag2_mb_valid[7] &  sctag2_mb_young[7] &  sctag2_mb_type7[5] &  sctag2_mb_type7[2];

wire sctag2_mb8_st_ny     = sctag2_mb_valid[8] & ~sctag2_mb_young[8] & ~sctag2_mb_type8[5] & (sctag2_mb_type8[4:0] == `STORE_RQ);
wire sctag2_mb8_ld_ny     = sctag2_mb_valid[8] & ~sctag2_mb_young[8] & ~sctag2_mb_type8[5] & (sctag2_mb_type8[4:0] == `LOAD_RQ);
wire sctag2_mb8_wris8_ny  = sctag2_mb_valid[8] & ~sctag2_mb_young[8] &  sctag2_mb_type8[5] &  sctag2_mb_type8[1];
wire sctag2_mb8_wris64_ny = sctag2_mb_valid[8] & ~sctag2_mb_young[8] &  sctag2_mb_type8[5] &  sctag2_mb_type8[2];
wire sctag2_mb8_st_y      = sctag2_mb_valid[8] &  sctag2_mb_young[8] & ~sctag2_mb_type8[5] & (sctag2_mb_type8[4:0] == `STORE_RQ);
wire sctag2_mb8_ld_y      = sctag2_mb_valid[8] &  sctag2_mb_young[8] & ~sctag2_mb_type8[5] & (sctag2_mb_type8[4:0] == `LOAD_RQ);
wire sctag2_mb8_wris8_y   = sctag2_mb_valid[8] &  sctag2_mb_young[8] &  sctag2_mb_type8[5] &  sctag2_mb_type8[1];
wire sctag2_mb8_wris64_y  = sctag2_mb_valid[8] &  sctag2_mb_young[8] &  sctag2_mb_type8[5] &  sctag2_mb_type8[2];

wire sctag2_mb9_st_ny     = sctag2_mb_valid[9] & ~sctag2_mb_young[9] & ~sctag2_mb_type9[5] & (sctag2_mb_type9[4:0] == `STORE_RQ);
wire sctag2_mb9_ld_ny     = sctag2_mb_valid[9] & ~sctag2_mb_young[9] & ~sctag2_mb_type9[5] & (sctag2_mb_type9[4:0] == `LOAD_RQ);
wire sctag2_mb9_wris8_ny  = sctag2_mb_valid[9] & ~sctag2_mb_young[9] &  sctag2_mb_type9[5] &  sctag2_mb_type9[1];
wire sctag2_mb9_wris64_ny = sctag2_mb_valid[9] & ~sctag2_mb_young[9] &  sctag2_mb_type9[5] &  sctag2_mb_type9[2];
wire sctag2_mb9_st_y      = sctag2_mb_valid[9] &  sctag2_mb_young[9] & ~sctag2_mb_type9[5] & (sctag2_mb_type9[4:0] == `STORE_RQ);
wire sctag2_mb9_ld_y      = sctag2_mb_valid[9] &  sctag2_mb_young[9] & ~sctag2_mb_type9[5] & (sctag2_mb_type9[4:0] == `LOAD_RQ);
wire sctag2_mb9_wris8_y   = sctag2_mb_valid[9] &  sctag2_mb_young[9] &  sctag2_mb_type9[5] &  sctag2_mb_type9[1];
wire sctag2_mb9_wris64_y  = sctag2_mb_valid[9] &  sctag2_mb_young[9] &  sctag2_mb_type9[5] &  sctag2_mb_type9[2];

wire sctag2_mb10_st_ny     = sctag2_mb_valid[10] & ~sctag2_mb_young[10] & ~sctag2_mb_type10[5] & (sctag2_mb_type10[4:0] == `STORE_RQ);
wire sctag2_mb10_ld_ny     = sctag2_mb_valid[10] & ~sctag2_mb_young[10] & ~sctag2_mb_type10[5] & (sctag2_mb_type10[4:0] == `LOAD_RQ);
wire sctag2_mb10_wris8_ny  = sctag2_mb_valid[10] & ~sctag2_mb_young[10] &  sctag2_mb_type10[5] &  sctag2_mb_type10[1];
wire sctag2_mb10_wris64_ny = sctag2_mb_valid[10] & ~sctag2_mb_young[10] &  sctag2_mb_type10[5] &  sctag2_mb_type10[2];
wire sctag2_mb10_st_y      = sctag2_mb_valid[10] &  sctag2_mb_young[10] & ~sctag2_mb_type10[5] & (sctag2_mb_type10[4:0] == `STORE_RQ);
wire sctag2_mb10_ld_y      = sctag2_mb_valid[10] &  sctag2_mb_young[10] & ~sctag2_mb_type10[5] & (sctag2_mb_type10[4:0] == `LOAD_RQ);
wire sctag2_mb10_wris8_y   = sctag2_mb_valid[10] &  sctag2_mb_young[10] &  sctag2_mb_type10[5] &  sctag2_mb_type10[1];
wire sctag2_mb10_wris64_y  = sctag2_mb_valid[10] &  sctag2_mb_young[10] &  sctag2_mb_type10[5] &  sctag2_mb_type10[2];

wire sctag2_mb11_st_ny     = sctag2_mb_valid[11] & ~sctag2_mb_young[11] & ~sctag2_mb_type11[5] & (sctag2_mb_type11[4:0] == `STORE_RQ);
wire sctag2_mb11_ld_ny     = sctag2_mb_valid[11] & ~sctag2_mb_young[11] & ~sctag2_mb_type11[5] & (sctag2_mb_type11[4:0] == `LOAD_RQ);
wire sctag2_mb11_wris8_ny  = sctag2_mb_valid[11] & ~sctag2_mb_young[11] &  sctag2_mb_type11[5] &  sctag2_mb_type11[1];
wire sctag2_mb11_wris64_ny = sctag2_mb_valid[11] & ~sctag2_mb_young[11] &  sctag2_mb_type11[5] &  sctag2_mb_type11[2];
wire sctag2_mb11_st_y      = sctag2_mb_valid[11] &  sctag2_mb_young[11] & ~sctag2_mb_type11[5] & (sctag2_mb_type11[4:0] == `STORE_RQ);
wire sctag2_mb11_ld_y      = sctag2_mb_valid[11] &  sctag2_mb_young[11] & ~sctag2_mb_type11[5] & (sctag2_mb_type11[4:0] == `LOAD_RQ);
wire sctag2_mb11_wris8_y   = sctag2_mb_valid[11] &  sctag2_mb_young[11] &  sctag2_mb_type11[5] &  sctag2_mb_type11[1];
wire sctag2_mb11_wris64_y  = sctag2_mb_valid[11] &  sctag2_mb_young[11] &  sctag2_mb_type11[5] &  sctag2_mb_type11[2];

wire sctag2_mb12_st_ny     = sctag2_mb_valid[12] & ~sctag2_mb_young[12] & ~sctag2_mb_type12[5] & (sctag2_mb_type12[4:0] == `STORE_RQ);
wire sctag2_mb12_ld_ny     = sctag2_mb_valid[12] & ~sctag2_mb_young[12] & ~sctag2_mb_type12[5] & (sctag2_mb_type12[4:0] == `LOAD_RQ);
wire sctag2_mb12_wris8_ny  = sctag2_mb_valid[12] & ~sctag2_mb_young[12] &  sctag2_mb_type12[5] &  sctag2_mb_type12[1];
wire sctag2_mb12_wris64_ny = sctag2_mb_valid[12] & ~sctag2_mb_young[12] &  sctag2_mb_type12[5] &  sctag2_mb_type12[2];
wire sctag2_mb12_st_y      = sctag2_mb_valid[12] &  sctag2_mb_young[12] & ~sctag2_mb_type12[5] & (sctag2_mb_type12[4:0] == `STORE_RQ);
wire sctag2_mb12_ld_y      = sctag2_mb_valid[12] &  sctag2_mb_young[12] & ~sctag2_mb_type12[5] & (sctag2_mb_type12[4:0] == `LOAD_RQ);
wire sctag2_mb12_wris8_y   = sctag2_mb_valid[12] &  sctag2_mb_young[12] &  sctag2_mb_type12[5] &  sctag2_mb_type12[1];
wire sctag2_mb12_wris64_y  = sctag2_mb_valid[12] &  sctag2_mb_young[12] &  sctag2_mb_type12[5] &  sctag2_mb_type12[2];

wire sctag2_mb13_st_ny     = sctag2_mb_valid[13] & ~sctag2_mb_young[13] & ~sctag2_mb_type13[5] & (sctag2_mb_type13[4:0] == `STORE_RQ);
wire sctag2_mb13_ld_ny     = sctag2_mb_valid[13] & ~sctag2_mb_young[13] & ~sctag2_mb_type13[5] & (sctag2_mb_type13[4:0] == `LOAD_RQ);
wire sctag2_mb13_wris8_ny  = sctag2_mb_valid[13] & ~sctag2_mb_young[13] &  sctag2_mb_type13[5] &  sctag2_mb_type13[1];
wire sctag2_mb13_wris64_ny = sctag2_mb_valid[13] & ~sctag2_mb_young[13] &  sctag2_mb_type13[5] &  sctag2_mb_type13[2];
wire sctag2_mb13_st_y      = sctag2_mb_valid[13] &  sctag2_mb_young[13] & ~sctag2_mb_type13[5] & (sctag2_mb_type13[4:0] == `STORE_RQ);
wire sctag2_mb13_ld_y      = sctag2_mb_valid[13] &  sctag2_mb_young[13] & ~sctag2_mb_type13[5] & (sctag2_mb_type13[4:0] == `LOAD_RQ);
wire sctag2_mb13_wris8_y   = sctag2_mb_valid[13] &  sctag2_mb_young[13] &  sctag2_mb_type13[5] &  sctag2_mb_type13[1];
wire sctag2_mb13_wris64_y  = sctag2_mb_valid[13] &  sctag2_mb_young[13] &  sctag2_mb_type13[5] &  sctag2_mb_type13[2];

wire sctag2_mb14_st_ny     = sctag2_mb_valid[14] & ~sctag2_mb_young[14] & ~sctag2_mb_type14[5] & (sctag2_mb_type14[4:0] == `STORE_RQ);
wire sctag2_mb14_ld_ny     = sctag2_mb_valid[14] & ~sctag2_mb_young[14] & ~sctag2_mb_type14[5] & (sctag2_mb_type14[4:0] == `LOAD_RQ);
wire sctag2_mb14_wris8_ny  = sctag2_mb_valid[14] & ~sctag2_mb_young[14] &  sctag2_mb_type14[5] &  sctag2_mb_type14[1];
wire sctag2_mb14_wris64_ny = sctag2_mb_valid[14] & ~sctag2_mb_young[14] &  sctag2_mb_type14[5] &  sctag2_mb_type14[2];
wire sctag2_mb14_st_y      = sctag2_mb_valid[14] &  sctag2_mb_young[14] & ~sctag2_mb_type14[5] & (sctag2_mb_type14[4:0] == `STORE_RQ);
wire sctag2_mb14_ld_y      = sctag2_mb_valid[14] &  sctag2_mb_young[14] & ~sctag2_mb_type14[5] & (sctag2_mb_type14[4:0] == `LOAD_RQ);
wire sctag2_mb14_wris8_y   = sctag2_mb_valid[14] &  sctag2_mb_young[14] &  sctag2_mb_type14[5] &  sctag2_mb_type14[1];
wire sctag2_mb14_wris64_y  = sctag2_mb_valid[14] &  sctag2_mb_young[14] &  sctag2_mb_type14[5] &  sctag2_mb_type14[2];

wire sctag2_mb15_st_ny     = sctag2_mb_valid[15] & ~sctag2_mb_young[15] & ~sctag2_mb_type15[5] & (sctag2_mb_type15[4:0] == `STORE_RQ);
wire sctag2_mb15_ld_ny     = sctag2_mb_valid[15] & ~sctag2_mb_young[15] & ~sctag2_mb_type15[5] & (sctag2_mb_type15[4:0] == `LOAD_RQ);
wire sctag2_mb15_wris8_ny  = sctag2_mb_valid[15] & ~sctag2_mb_young[15] &  sctag2_mb_type15[5] &  sctag2_mb_type15[1];
wire sctag2_mb15_wris64_ny = sctag2_mb_valid[15] & ~sctag2_mb_young[15] &  sctag2_mb_type15[5] &  sctag2_mb_type15[2];
wire sctag2_mb15_st_y      = sctag2_mb_valid[15] &  sctag2_mb_young[15] & ~sctag2_mb_type15[5] & (sctag2_mb_type15[4:0] == `STORE_RQ);
wire sctag2_mb15_ld_y      = sctag2_mb_valid[15] &  sctag2_mb_young[15] & ~sctag2_mb_type15[5] & (sctag2_mb_type15[4:0] == `LOAD_RQ);
wire sctag2_mb15_wris8_y   = sctag2_mb_valid[15] &  sctag2_mb_young[15] &  sctag2_mb_type15[5] &  sctag2_mb_type15[1];
wire sctag2_mb15_wris64_y  = sctag2_mb_valid[15] &  sctag2_mb_young[15] &  sctag2_mb_type15[5] &  sctag2_mb_type15[2];


wire [15:0] 	sctag3_mb_valid	    = `TOP_MEMORY.sctag3.mbctl.mb_valid[15:0];
wire [15:0] 	sctag3_mb_young	    = `TOP_MEMORY.sctag3.mbctl.mb_young[15:0];
//wire [3:0] 	sctag3_next_link_entry0  = `TOP_MEMORY.sctag3.mbctl.next_link_entry0[3:0];
//...
//wire [3:0] 	sctag3_next_link_entry15 = `TOP_MEMORY.sctag3.mbctl.next_link_entry15[3:0];

wire [155:0] 	sctag3_mb_data_array0  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[0];
wire [155:0] 	sctag3_mb_data_array1  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[1];
wire [155:0] 	sctag3_mb_data_array2  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[2];
wire [155:0] 	sctag3_mb_data_array3  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[3];
wire [155:0] 	sctag3_mb_data_array4  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[4];
wire [155:0] 	sctag3_mb_data_array5  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[5];
wire [155:0] 	sctag3_mb_data_array6  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[6];
wire [155:0] 	sctag3_mb_data_array7  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[7];
wire [155:0] 	sctag3_mb_data_array8  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[8];
wire [155:0] 	sctag3_mb_data_array9  	= `TOP_MEMORY.sctag3.mbdata.inq_ary[9];
wire [155:0] 	sctag3_mb_data_array10 	= `TOP_MEMORY.sctag3.mbdata.inq_ary[10];
wire [155:0] 	sctag3_mb_data_array11 	= `TOP_MEMORY.sctag3.mbdata.inq_ary[11];
wire [155:0] 	sctag3_mb_data_array12 	= `TOP_MEMORY.sctag3.mbdata.inq_ary[12];
wire [155:0] 	sctag3_mb_data_array13 	= `TOP_MEMORY.sctag3.mbdata.inq_ary[13];
wire [155:0] 	sctag3_mb_data_array14 	= `TOP_MEMORY.sctag3.mbdata.inq_ary[14];
wire [155:0] 	sctag3_mb_data_array15 	= `TOP_MEMORY.sctag3.mbdata.inq_ary[15];

//-----------------------------------------------------------------------------------------------
// look at sctag.v for L2_RDMA_HI L2_RQTYP_HI L2_RQTYP_LO and L2_RSVD
// Based ont the equation: .mb_data_write_data({57'b0,mbdata_inst_tecc_c8...
//-----------------------------------------------------------------------------------------------
wire [5:0]     sctag3_mb_type0  =	{sctag3_mb_data_array0 [77], sctag3_mb_data_array0 [83:79]};
wire [5:0]     sctag3_mb_type1  =	{sctag3_mb_data_array1 [77], sctag3_mb_data_array1 [83:79]};
wire [5:0]     sctag3_mb_type2  =	{sctag3_mb_data_array2 [77], sctag3_mb_data_array2 [83:79]};
wire [5:0]     sctag3_mb_type3  =	{sctag3_mb_data_array3 [77], sctag3_mb_data_array3 [83:79]};
wire [5:0]     sctag3_mb_type4  =	{sctag3_mb_data_array4 [77], sctag3_mb_data_array4 [83:79]};
wire [5:0]     sctag3_mb_type5  =	{sctag3_mb_data_array5 [77], sctag3_mb_data_array5 [83:79]};
wire [5:0]     sctag3_mb_type6  =	{sctag3_mb_data_array6 [77], sctag3_mb_data_array6 [83:79]};
wire [5:0]     sctag3_mb_type7  =	{sctag3_mb_data_array7 [77], sctag3_mb_data_array7 [83:79]};
wire [5:0]     sctag3_mb_type8  =	{sctag3_mb_data_array8 [77], sctag3_mb_data_array8 [83:79]};
wire [5:0]     sctag3_mb_type9  =	{sctag3_mb_data_array9 [77], sctag3_mb_data_array9 [83:79]};
wire [5:0]     sctag3_mb_type10 =	{sctag3_mb_data_array10[77], sctag3_mb_data_array10[83:79]};
wire [5:0]     sctag3_mb_type11 =	{sctag3_mb_data_array11[77], sctag3_mb_data_array11[83:79]};
wire [5:0]     sctag3_mb_type12 =	{sctag3_mb_data_array12[77], sctag3_mb_data_array12[83:79]};
wire [5:0]     sctag3_mb_type13 =	{sctag3_mb_data_array13[77], sctag3_mb_data_array13[83:79]};
wire [5:0]     sctag3_mb_type14 =	{sctag3_mb_data_array14[77], sctag3_mb_data_array14[83:79]};
wire [5:0]     sctag3_mb_type15 =	{sctag3_mb_data_array15[77], sctag3_mb_data_array15[83:79]};

//--------------------------------------------------------------
// Start figuring out what the entries are.
// bit 5 says if this is a DMA type or normal type
//--------------------------------------------------------------

wire sctag3_mb0_st_ny     = sctag3_mb_valid[0] & ~sctag3_mb_young[0] & ~sctag3_mb_type0[5] & (sctag3_mb_type0[4:0] == `STORE_RQ);
wire sctag3_mb0_ld_ny     = sctag3_mb_valid[0] & ~sctag3_mb_young[0] & ~sctag3_mb_type0[5] & (sctag3_mb_type0[4:0] == `LOAD_RQ);
wire sctag3_mb0_wris8_ny  = sctag3_mb_valid[0] & ~sctag3_mb_young[0] &  sctag3_mb_type0[5] &  sctag3_mb_type0[1];
wire sctag3_mb0_wris64_ny = sctag3_mb_valid[0] & ~sctag3_mb_young[0] &  sctag3_mb_type0[5] &  sctag3_mb_type0[2];
wire sctag3_mb0_st_y      = sctag3_mb_valid[0] &  sctag3_mb_young[0] & ~sctag3_mb_type0[5] & (sctag3_mb_type0[4:0] == `STORE_RQ);
wire sctag3_mb0_ld_y      = sctag3_mb_valid[0] &  sctag3_mb_young[0] & ~sctag3_mb_type0[5] & (sctag3_mb_type0[4:0] == `LOAD_RQ);
wire sctag3_mb0_wris8_y   = sctag3_mb_valid[0] &  sctag3_mb_young[0] &  sctag3_mb_type0[5] &  sctag3_mb_type0[1];
wire sctag3_mb0_wris64_y  = sctag3_mb_valid[0] &  sctag3_mb_young[0] &  sctag3_mb_type0[5] &  sctag3_mb_type0[2];

wire sctag3_mb1_st_ny     = sctag3_mb_valid[1] & ~sctag3_mb_young[1] & ~sctag3_mb_type1[5] & (sctag3_mb_type1[4:0] == `STORE_RQ);
wire sctag3_mb1_ld_ny     = sctag3_mb_valid[1] & ~sctag3_mb_young[1] & ~sctag3_mb_type1[5] & (sctag3_mb_type1[4:0] == `LOAD_RQ);
wire sctag3_mb1_wris8_ny  = sctag3_mb_valid[1] & ~sctag3_mb_young[1] &  sctag3_mb_type1[5] &  sctag3_mb_type1[1];
wire sctag3_mb1_wris64_ny = sctag3_mb_valid[1] & ~sctag3_mb_young[1] &  sctag3_mb_type1[5] &  sctag3_mb_type1[2];
wire sctag3_mb1_st_y      = sctag3_mb_valid[1] &  sctag3_mb_young[1] & ~sctag3_mb_type1[5] & (sctag3_mb_type1[4:0] == `STORE_RQ);
wire sctag3_mb1_ld_y      = sctag3_mb_valid[1] &  sctag3_mb_young[1] & ~sctag3_mb_type1[5] & (sctag3_mb_type1[4:0] == `LOAD_RQ);
wire sctag3_mb1_wris8_y   = sctag3_mb_valid[1] &  sctag3_mb_young[1] &  sctag3_mb_type1[5] &  sctag3_mb_type1[1];
wire sctag3_mb1_wris64_y  = sctag3_mb_valid[1] &  sctag3_mb_young[1] &  sctag3_mb_type1[5] &  sctag3_mb_type1[2];

wire sctag3_mb2_st_ny     = sctag3_mb_valid[2] & ~sctag3_mb_young[2] & ~sctag3_mb_type2[5] & (sctag3_mb_type2[4:0] == `STORE_RQ);
wire sctag3_mb2_ld_ny     = sctag3_mb_valid[2] & ~sctag3_mb_young[2] & ~sctag3_mb_type2[5] & (sctag3_mb_type2[4:0] == `LOAD_RQ);
wire sctag3_mb2_wris8_ny  = sctag3_mb_valid[2] & ~sctag3_mb_young[2] &  sctag3_mb_type2[5] &  sctag3_mb_type2[1];
wire sctag3_mb2_wris64_ny = sctag3_mb_valid[2] & ~sctag3_mb_young[2] &  sctag3_mb_type2[5] &  sctag3_mb_type2[2];
wire sctag3_mb2_st_y      = sctag3_mb_valid[2] &  sctag3_mb_young[2] & ~sctag3_mb_type2[5] & (sctag3_mb_type2[4:0] == `STORE_RQ);
wire sctag3_mb2_ld_y      = sctag3_mb_valid[2] &  sctag3_mb_young[2] & ~sctag3_mb_type2[5] & (sctag3_mb_type2[4:0] == `LOAD_RQ);
wire sctag3_mb2_wris8_y   = sctag3_mb_valid[2] &  sctag3_mb_young[2] &  sctag3_mb_type2[5] &  sctag3_mb_type2[1];
wire sctag3_mb2_wris64_y  = sctag3_mb_valid[2] &  sctag3_mb_young[2] &  sctag3_mb_type2[5] &  sctag3_mb_type2[2];

wire sctag3_mb3_st_ny     = sctag3_mb_valid[3] & ~sctag3_mb_young[3] & ~sctag3_mb_type3[5] & (sctag3_mb_type3[4:0] == `STORE_RQ);
wire sctag3_mb3_ld_ny     = sctag3_mb_valid[3] & ~sctag3_mb_young[3] & ~sctag3_mb_type3[5] & (sctag3_mb_type3[4:0] == `LOAD_RQ);
wire sctag3_mb3_wris8_ny  = sctag3_mb_valid[3] & ~sctag3_mb_young[3] &  sctag3_mb_type3[5] &  sctag3_mb_type3[1];
wire sctag3_mb3_wris64_ny = sctag3_mb_valid[3] & ~sctag3_mb_young[3] &  sctag3_mb_type3[5] &  sctag3_mb_type3[2];
wire sctag3_mb3_st_y      = sctag3_mb_valid[3] &  sctag3_mb_young[3] & ~sctag3_mb_type3[5] & (sctag3_mb_type3[4:0] == `STORE_RQ);
wire sctag3_mb3_ld_y      = sctag3_mb_valid[3] &  sctag3_mb_young[3] & ~sctag3_mb_type3[5] & (sctag3_mb_type3[4:0] == `LOAD_RQ);
wire sctag3_mb3_wris8_y   = sctag3_mb_valid[3] &  sctag3_mb_young[3] &  sctag3_mb_type3[5] &  sctag3_mb_type3[1];
wire sctag3_mb3_wris64_y  = sctag3_mb_valid[3] &  sctag3_mb_young[3] &  sctag3_mb_type3[5] &  sctag3_mb_type3[2];

wire sctag3_mb4_st_ny     = sctag3_mb_valid[4] & ~sctag3_mb_young[4] & ~sctag3_mb_type4[5] & (sctag3_mb_type4[4:0] == `STORE_RQ);
wire sctag3_mb4_ld_ny     = sctag3_mb_valid[4] & ~sctag3_mb_young[4] & ~sctag3_mb_type4[5] & (sctag3_mb_type4[4:0] == `LOAD_RQ);
wire sctag3_mb4_wris8_ny  = sctag3_mb_valid[4] & ~sctag3_mb_young[4] &  sctag3_mb_type4[5] &  sctag3_mb_type4[1];
wire sctag3_mb4_wris64_ny = sctag3_mb_valid[4] & ~sctag3_mb_young[4] &  sctag3_mb_type4[5] &  sctag3_mb_type4[2];
wire sctag3_mb4_st_y      = sctag3_mb_valid[4] &  sctag3_mb_young[4] & ~sctag3_mb_type4[5] & (sctag3_mb_type4[4:0] == `STORE_RQ);
wire sctag3_mb4_ld_y      = sctag3_mb_valid[4] &  sctag3_mb_young[4] & ~sctag3_mb_type4[5] & (sctag3_mb_type4[4:0] == `LOAD_RQ);
wire sctag3_mb4_wris8_y   = sctag3_mb_valid[4] &  sctag3_mb_young[4] &  sctag3_mb_type4[5] &  sctag3_mb_type4[1];
wire sctag3_mb4_wris64_y  = sctag3_mb_valid[4] &  sctag3_mb_young[4] &  sctag3_mb_type4[5] &  sctag3_mb_type4[2];

wire sctag3_mb5_st_ny     = sctag3_mb_valid[5] & ~sctag3_mb_young[5] & ~sctag3_mb_type5[5] & (sctag3_mb_type5[4:0] == `STORE_RQ);
wire sctag3_mb5_ld_ny     = sctag3_mb_valid[5] & ~sctag3_mb_young[5] & ~sctag3_mb_type5[5] & (sctag3_mb_type5[4:0] == `LOAD_RQ);
wire sctag3_mb5_wris8_ny  = sctag3_mb_valid[5] & ~sctag3_mb_young[5] &  sctag3_mb_type5[5] &  sctag3_mb_type5[1];
wire sctag3_mb5_wris64_ny = sctag3_mb_valid[5] & ~sctag3_mb_young[5] &  sctag3_mb_type5[5] &  sctag3_mb_type5[2];
wire sctag3_mb5_st_y      = sctag3_mb_valid[5] &  sctag3_mb_young[5] & ~sctag3_mb_type5[5] & (sctag3_mb_type5[4:0] == `STORE_RQ);
wire sctag3_mb5_ld_y      = sctag3_mb_valid[5] &  sctag3_mb_young[5] & ~sctag3_mb_type5[5] & (sctag3_mb_type5[4:0] == `LOAD_RQ);
wire sctag3_mb5_wris8_y   = sctag3_mb_valid[5] &  sctag3_mb_young[5] &  sctag3_mb_type5[5] &  sctag3_mb_type5[1];
wire sctag3_mb5_wris64_y  = sctag3_mb_valid[5] &  sctag3_mb_young[5] &  sctag3_mb_type5[5] &  sctag3_mb_type5[2];

wire sctag3_mb6_st_ny     = sctag3_mb_valid[6] & ~sctag3_mb_young[6] & ~sctag3_mb_type6[5] & (sctag3_mb_type6[4:0] == `STORE_RQ);
wire sctag3_mb6_ld_ny     = sctag3_mb_valid[6] & ~sctag3_mb_young[6] & ~sctag3_mb_type6[5] & (sctag3_mb_type6[4:0] == `LOAD_RQ);
wire sctag3_mb6_wris8_ny  = sctag3_mb_valid[6] & ~sctag3_mb_young[6] &  sctag3_mb_type6[5] &  sctag3_mb_type6[1];
wire sctag3_mb6_wris64_ny = sctag3_mb_valid[6] & ~sctag3_mb_young[6] &  sctag3_mb_type6[5] &  sctag3_mb_type6[2];
wire sctag3_mb6_st_y      = sctag3_mb_valid[6] &  sctag3_mb_young[6] & ~sctag3_mb_type6[5] & (sctag3_mb_type6[4:0] == `STORE_RQ);
wire sctag3_mb6_ld_y      = sctag3_mb_valid[6] &  sctag3_mb_young[6] & ~sctag3_mb_type6[5] & (sctag3_mb_type6[4:0] == `LOAD_RQ);
wire sctag3_mb6_wris8_y   = sctag3_mb_valid[6] &  sctag3_mb_young[6] &  sctag3_mb_type6[5] &  sctag3_mb_type6[1];
wire sctag3_mb6_wris64_y  = sctag3_mb_valid[6] &  sctag3_mb_young[6] &  sctag3_mb_type6[5] &  sctag3_mb_type6[2];

wire sctag3_mb7_st_ny     = sctag3_mb_valid[7] & ~sctag3_mb_young[7] & ~sctag3_mb_type7[5] & (sctag3_mb_type7[4:0] == `STORE_RQ);
wire sctag3_mb7_ld_ny     = sctag3_mb_valid[7] & ~sctag3_mb_young[7] & ~sctag3_mb_type7[5] & (sctag3_mb_type7[4:0] == `LOAD_RQ);
wire sctag3_mb7_wris8_ny  = sctag3_mb_valid[7] & ~sctag3_mb_young[7] &  sctag3_mb_type7[5] &  sctag3_mb_type7[1];
wire sctag3_mb7_wris64_ny = sctag3_mb_valid[7] & ~sctag3_mb_young[7] &  sctag3_mb_type7[5] &  sctag3_mb_type7[2];
wire sctag3_mb7_st_y      = sctag3_mb_valid[7] &  sctag3_mb_young[7] & ~sctag3_mb_type7[5] & (sctag3_mb_type7[4:0] == `STORE_RQ);
wire sctag3_mb7_ld_y      = sctag3_mb_valid[7] &  sctag3_mb_young[7] & ~sctag3_mb_type7[5] & (sctag3_mb_type7[4:0] == `LOAD_RQ);
wire sctag3_mb7_wris8_y   = sctag3_mb_valid[7] &  sctag3_mb_young[7] &  sctag3_mb_type7[5] &  sctag3_mb_type7[1];
wire sctag3_mb7_wris64_y  = sctag3_mb_valid[7] &  sctag3_mb_young[7] &  sctag3_mb_type7[5] &  sctag3_mb_type7[2];

wire sctag3_mb8_st_ny     = sctag3_mb_valid[8] & ~sctag3_mb_young[8] & ~sctag3_mb_type8[5] & (sctag3_mb_type8[4:0] == `STORE_RQ);
wire sctag3_mb8_ld_ny     = sctag3_mb_valid[8] & ~sctag3_mb_young[8] & ~sctag3_mb_type8[5] & (sctag3_mb_type8[4:0] == `LOAD_RQ);
wire sctag3_mb8_wris8_ny  = sctag3_mb_valid[8] & ~sctag3_mb_young[8] &  sctag3_mb_type8[5] &  sctag3_mb_type8[1];
wire sctag3_mb8_wris64_ny = sctag3_mb_valid[8] & ~sctag3_mb_young[8] &  sctag3_mb_type8[5] &  sctag3_mb_type8[2];
wire sctag3_mb8_st_y      = sctag3_mb_valid[8] &  sctag3_mb_young[8] & ~sctag3_mb_type8[5] & (sctag3_mb_type8[4:0] == `STORE_RQ);
wire sctag3_mb8_ld_y      = sctag3_mb_valid[8] &  sctag3_mb_young[8] & ~sctag3_mb_type8[5] & (sctag3_mb_type8[4:0] == `LOAD_RQ);
wire sctag3_mb8_wris8_y   = sctag3_mb_valid[8] &  sctag3_mb_young[8] &  sctag3_mb_type8[5] &  sctag3_mb_type8[1];
wire sctag3_mb8_wris64_y  = sctag3_mb_valid[8] &  sctag3_mb_young[8] &  sctag3_mb_type8[5] &  sctag3_mb_type8[2];

wire sctag3_mb9_st_ny     = sctag3_mb_valid[9] & ~sctag3_mb_young[9] & ~sctag3_mb_type9[5] & (sctag3_mb_type9[4:0] == `STORE_RQ);
wire sctag3_mb9_ld_ny     = sctag3_mb_valid[9] & ~sctag3_mb_young[9] & ~sctag3_mb_type9[5] & (sctag3_mb_type9[4:0] == `LOAD_RQ);
wire sctag3_mb9_wris8_ny  = sctag3_mb_valid[9] & ~sctag3_mb_young[9] &  sctag3_mb_type9[5] &  sctag3_mb_type9[1];
wire sctag3_mb9_wris64_ny = sctag3_mb_valid[9] & ~sctag3_mb_young[9] &  sctag3_mb_type9[5] &  sctag3_mb_type9[2];
wire sctag3_mb9_st_y      = sctag3_mb_valid[9] &  sctag3_mb_young[9] & ~sctag3_mb_type9[5] & (sctag3_mb_type9[4:0] == `STORE_RQ);
wire sctag3_mb9_ld_y      = sctag3_mb_valid[9] &  sctag3_mb_young[9] & ~sctag3_mb_type9[5] & (sctag3_mb_type9[4:0] == `LOAD_RQ);
wire sctag3_mb9_wris8_y   = sctag3_mb_valid[9] &  sctag3_mb_young[9] &  sctag3_mb_type9[5] &  sctag3_mb_type9[1];
wire sctag3_mb9_wris64_y  = sctag3_mb_valid[9] &  sctag3_mb_young[9] &  sctag3_mb_type9[5] &  sctag3_mb_type9[2];

wire sctag3_mb10_st_ny     = sctag3_mb_valid[10] & ~sctag3_mb_young[10] & ~sctag3_mb_type10[5] & (sctag3_mb_type10[4:0] == `STORE_RQ);
wire sctag3_mb10_ld_ny     = sctag3_mb_valid[10] & ~sctag3_mb_young[10] & ~sctag3_mb_type10[5] & (sctag3_mb_type10[4:0] == `LOAD_RQ);
wire sctag3_mb10_wris8_ny  = sctag3_mb_valid[10] & ~sctag3_mb_young[10] &  sctag3_mb_type10[5] &  sctag3_mb_type10[1];
wire sctag3_mb10_wris64_ny = sctag3_mb_valid[10] & ~sctag3_mb_young[10] &  sctag3_mb_type10[5] &  sctag3_mb_type10[2];
wire sctag3_mb10_st_y      = sctag3_mb_valid[10] &  sctag3_mb_young[10] & ~sctag3_mb_type10[5] & (sctag3_mb_type10[4:0] == `STORE_RQ);
wire sctag3_mb10_ld_y      = sctag3_mb_valid[10] &  sctag3_mb_young[10] & ~sctag3_mb_type10[5] & (sctag3_mb_type10[4:0] == `LOAD_RQ);
wire sctag3_mb10_wris8_y   = sctag3_mb_valid[10] &  sctag3_mb_young[10] &  sctag3_mb_type10[5] &  sctag3_mb_type10[1];
wire sctag3_mb10_wris64_y  = sctag3_mb_valid[10] &  sctag3_mb_young[10] &  sctag3_mb_type10[5] &  sctag3_mb_type10[2];

wire sctag3_mb11_st_ny     = sctag3_mb_valid[11] & ~sctag3_mb_young[11] & ~sctag3_mb_type11[5] & (sctag3_mb_type11[4:0] == `STORE_RQ);
wire sctag3_mb11_ld_ny     = sctag3_mb_valid[11] & ~sctag3_mb_young[11] & ~sctag3_mb_type11[5] & (sctag3_mb_type11[4:0] == `LOAD_RQ);
wire sctag3_mb11_wris8_ny  = sctag3_mb_valid[11] & ~sctag3_mb_young[11] &  sctag3_mb_type11[5] &  sctag3_mb_type11[1];
wire sctag3_mb11_wris64_ny = sctag3_mb_valid[11] & ~sctag3_mb_young[11] &  sctag3_mb_type11[5] &  sctag3_mb_type11[2];
wire sctag3_mb11_st_y      = sctag3_mb_valid[11] &  sctag3_mb_young[11] & ~sctag3_mb_type11[5] & (sctag3_mb_type11[4:0] == `STORE_RQ);
wire sctag3_mb11_ld_y      = sctag3_mb_valid[11] &  sctag3_mb_young[11] & ~sctag3_mb_type11[5] & (sctag3_mb_type11[4:0] == `LOAD_RQ);
wire sctag3_mb11_wris8_y   = sctag3_mb_valid[11] &  sctag3_mb_young[11] &  sctag3_mb_type11[5] &  sctag3_mb_type11[1];
wire sctag3_mb11_wris64_y  = sctag3_mb_valid[11] &  sctag3_mb_young[11] &  sctag3_mb_type11[5] &  sctag3_mb_type11[2];

wire sctag3_mb12_st_ny     = sctag3_mb_valid[12] & ~sctag3_mb_young[12] & ~sctag3_mb_type12[5] & (sctag3_mb_type12[4:0] == `STORE_RQ);
wire sctag3_mb12_ld_ny     = sctag3_mb_valid[12] & ~sctag3_mb_young[12] & ~sctag3_mb_type12[5] & (sctag3_mb_type12[4:0] == `LOAD_RQ);
wire sctag3_mb12_wris8_ny  = sctag3_mb_valid[12] & ~sctag3_mb_young[12] &  sctag3_mb_type12[5] &  sctag3_mb_type12[1];
wire sctag3_mb12_wris64_ny = sctag3_mb_valid[12] & ~sctag3_mb_young[12] &  sctag3_mb_type12[5] &  sctag3_mb_type12[2];
wire sctag3_mb12_st_y      = sctag3_mb_valid[12] &  sctag3_mb_young[12] & ~sctag3_mb_type12[5] & (sctag3_mb_type12[4:0] == `STORE_RQ);
wire sctag3_mb12_ld_y      = sctag3_mb_valid[12] &  sctag3_mb_young[12] & ~sctag3_mb_type12[5] & (sctag3_mb_type12[4:0] == `LOAD_RQ);
wire sctag3_mb12_wris8_y   = sctag3_mb_valid[12] &  sctag3_mb_young[12] &  sctag3_mb_type12[5] &  sctag3_mb_type12[1];
wire sctag3_mb12_wris64_y  = sctag3_mb_valid[12] &  sctag3_mb_young[12] &  sctag3_mb_type12[5] &  sctag3_mb_type12[2];

wire sctag3_mb13_st_ny     = sctag3_mb_valid[13] & ~sctag3_mb_young[13] & ~sctag3_mb_type13[5] & (sctag3_mb_type13[4:0] == `STORE_RQ);
wire sctag3_mb13_ld_ny     = sctag3_mb_valid[13] & ~sctag3_mb_young[13] & ~sctag3_mb_type13[5] & (sctag3_mb_type13[4:0] == `LOAD_RQ);
wire sctag3_mb13_wris8_ny  = sctag3_mb_valid[13] & ~sctag3_mb_young[13] &  sctag3_mb_type13[5] &  sctag3_mb_type13[1];
wire sctag3_mb13_wris64_ny = sctag3_mb_valid[13] & ~sctag3_mb_young[13] &  sctag3_mb_type13[5] &  sctag3_mb_type13[2];
wire sctag3_mb13_st_y      = sctag3_mb_valid[13] &  sctag3_mb_young[13] & ~sctag3_mb_type13[5] & (sctag3_mb_type13[4:0] == `STORE_RQ);
wire sctag3_mb13_ld_y      = sctag3_mb_valid[13] &  sctag3_mb_young[13] & ~sctag3_mb_type13[5] & (sctag3_mb_type13[4:0] == `LOAD_RQ);
wire sctag3_mb13_wris8_y   = sctag3_mb_valid[13] &  sctag3_mb_young[13] &  sctag3_mb_type13[5] &  sctag3_mb_type13[1];
wire sctag3_mb13_wris64_y  = sctag3_mb_valid[13] &  sctag3_mb_young[13] &  sctag3_mb_type13[5] &  sctag3_mb_type13[2];

wire sctag3_mb14_st_ny     = sctag3_mb_valid[14] & ~sctag3_mb_young[14] & ~sctag3_mb_type14[5] & (sctag3_mb_type14[4:0] == `STORE_RQ);
wire sctag3_mb14_ld_ny     = sctag3_mb_valid[14] & ~sctag3_mb_young[14] & ~sctag3_mb_type14[5] & (sctag3_mb_type14[4:0] == `LOAD_RQ);
wire sctag3_mb14_wris8_ny  = sctag3_mb_valid[14] & ~sctag3_mb_young[14] &  sctag3_mb_type14[5] &  sctag3_mb_type14[1];
wire sctag3_mb14_wris64_ny = sctag3_mb_valid[14] & ~sctag3_mb_young[14] &  sctag3_mb_type14[5] &  sctag3_mb_type14[2];
wire sctag3_mb14_st_y      = sctag3_mb_valid[14] &  sctag3_mb_young[14] & ~sctag3_mb_type14[5] & (sctag3_mb_type14[4:0] == `STORE_RQ);
wire sctag3_mb14_ld_y      = sctag3_mb_valid[14] &  sctag3_mb_young[14] & ~sctag3_mb_type14[5] & (sctag3_mb_type14[4:0] == `LOAD_RQ);
wire sctag3_mb14_wris8_y   = sctag3_mb_valid[14] &  sctag3_mb_young[14] &  sctag3_mb_type14[5] &  sctag3_mb_type14[1];
wire sctag3_mb14_wris64_y  = sctag3_mb_valid[14] &  sctag3_mb_young[14] &  sctag3_mb_type14[5] &  sctag3_mb_type14[2];

wire sctag3_mb15_st_ny     = sctag3_mb_valid[15] & ~sctag3_mb_young[15] & ~sctag3_mb_type15[5] & (sctag3_mb_type15[4:0] == `STORE_RQ);
wire sctag3_mb15_ld_ny     = sctag3_mb_valid[15] & ~sctag3_mb_young[15] & ~sctag3_mb_type15[5] & (sctag3_mb_type15[4:0] == `LOAD_RQ);
wire sctag3_mb15_wris8_ny  = sctag3_mb_valid[15] & ~sctag3_mb_young[15] &  sctag3_mb_type15[5] &  sctag3_mb_type15[1];
wire sctag3_mb15_wris64_ny = sctag3_mb_valid[15] & ~sctag3_mb_young[15] &  sctag3_mb_type15[5] &  sctag3_mb_type15[2];
wire sctag3_mb15_st_y      = sctag3_mb_valid[15] &  sctag3_mb_young[15] & ~sctag3_mb_type15[5] & (sctag3_mb_type15[4:0] == `STORE_RQ);
wire sctag3_mb15_ld_y      = sctag3_mb_valid[15] &  sctag3_mb_young[15] & ~sctag3_mb_type15[5] & (sctag3_mb_type15[4:0] == `LOAD_RQ);
wire sctag3_mb15_wris8_y   = sctag3_mb_valid[15] &  sctag3_mb_young[15] &  sctag3_mb_type15[5] &  sctag3_mb_type15[1];
wire sctag3_mb15_wris64_y  = sctag3_mb_valid[15] &  sctag3_mb_young[15] &  sctag3_mb_type15[5] &  sctag3_mb_type15[2];



//==========================================================================================
// L2 pipeline stuff. Detecting  miss/hit combinations of stores.
//==========================================================================================
wire [`L2_FBF:`L2_SZ_LO] sctag0_inst_c2       	      = `TOP_MEMORY.sctag0.arbdecdp.arbdp_inst_c2;
wire [39:0]  		 sctag0_addr_c2       	      = `TOP_MEMORY.sctag0.arbaddrdp.arbdp_addr_c2;
wire         		 sctag0_tagctl_hit_c2 	      = `TOP_MEMORY.sctag0.tagctl.tagctl_hit_c2;
wire         		 sctag0_inst_vld_c2   	      = `TOP_MEMORY.sctag0.arbctl_inst_vld_c2;
wire         		 sctag0_mbctl_tagctl_hit_unqual_c2 = `TOP_MEMORY.sctag0.mbctl_tagctl_hit_unqual_c2;

wire         		 sctag0_l2_enable     = ~`TOP_MEMORY.sctag0.l2_bypass_mode_on;
wire         		 sctag0_l2_dir_map_on =  `TOP_MEMORY.sctag0.l2_dir_map_on;

// A store which does not hit in the L2 miss buffer
//-------------------------------------------------
wire store0 = (sctag0_inst_c2[`L2_RQTYP_HI:`L2_RQTYP_LO] == `STORE_RQ) & ~sctag0_inst_c2[`L2_RSVD] |
                  sctag0_inst_vld_c2 & ~sctag0_mbctl_tagctl_hit_unqual_c2;

wire wris80 = sctag0_inst_c2[`L2_RQTYP_LO + 1] &  sctag0_inst_c2[`L2_RSVD] & 
                 sctag0_inst_vld_c2 & ~sctag0_mbctl_tagctl_hit_unqual_c2;

wire wris640= sctag0_inst_c2[`L2_RQTYP_LO + 2]  &  sctag0_inst_c2[`L2_RSVD] & 
                 sctag0_inst_vld_c2 & ~sctag0_mbctl_tagctl_hit_unqual_c2;

wire load0  = (sctag0_inst_c2[`L2_RQTYP_HI:`L2_RQTYP_LO] == `LOAD_RQ)  & ~sctag0_inst_c2[`L2_RSVD] &
                  sctag0_inst_vld_c2 & ~sctag0_mbctl_tagctl_hit_unqual_c2;

wire ldd0   = sctag0_inst_c2[`L2_RQTYP_LO]  &  sctag0_inst_c2[`L2_RSVD] & 
                  sctag0_inst_vld_c2 & ~sctag0_mbctl_tagctl_hit_unqual_c2;
wire [`L2_FBF:`L2_SZ_LO] sctag1_inst_c2       	      = `TOP_MEMORY.sctag1.arbdecdp.arbdp_inst_c2;
wire [39:0]  		 sctag1_addr_c2       	      = `TOP_MEMORY.sctag1.arbaddrdp.arbdp_addr_c2;
wire         		 sctag1_tagctl_hit_c2 	      = `TOP_MEMORY.sctag1.tagctl.tagctl_hit_c2;
wire         		 sctag1_inst_vld_c2   	      = `TOP_MEMORY.sctag1.arbctl_inst_vld_c2;
wire         		 sctag1_mbctl_tagctl_hit_unqual_c2 = `TOP_MEMORY.sctag1.mbctl_tagctl_hit_unqual_c2;

wire         		 sctag1_l2_enable     = ~`TOP_MEMORY.sctag1.l2_bypass_mode_on;
wire         		 sctag1_l2_dir_map_on =  `TOP_MEMORY.sctag1.l2_dir_map_on;

// A store which does not hit in the L2 miss buffer
//-------------------------------------------------
wire store1 = (sctag1_inst_c2[`L2_RQTYP_HI:`L2_RQTYP_LO] == `STORE_RQ) & ~sctag1_inst_c2[`L2_RSVD] |
                  sctag1_inst_vld_c2 & ~sctag1_mbctl_tagctl_hit_unqual_c2;

wire wris81 = sctag1_inst_c2[`L2_RQTYP_LO + 1] &  sctag1_inst_c2[`L2_RSVD] & 
                 sctag1_inst_vld_c2 & ~sctag1_mbctl_tagctl_hit_unqual_c2;

wire wris641= sctag1_inst_c2[`L2_RQTYP_LO + 2]  &  sctag1_inst_c2[`L2_RSVD] & 
                 sctag1_inst_vld_c2 & ~sctag1_mbctl_tagctl_hit_unqual_c2;

wire load1  = (sctag1_inst_c2[`L2_RQTYP_HI:`L2_RQTYP_LO] == `LOAD_RQ)  & ~sctag1_inst_c2[`L2_RSVD] &
                  sctag1_inst_vld_c2 & ~sctag1_mbctl_tagctl_hit_unqual_c2;

wire ldd1   = sctag1_inst_c2[`L2_RQTYP_LO]  &  sctag1_inst_c2[`L2_RSVD] & 
                  sctag1_inst_vld_c2 & ~sctag1_mbctl_tagctl_hit_unqual_c2;
wire [`L2_FBF:`L2_SZ_LO] sctag2_inst_c2       	      = `TOP_MEMORY.sctag2.arbdecdp.arbdp_inst_c2;
wire [39:0]  		 sctag2_addr_c2       	      = `TOP_MEMORY.sctag2.arbaddrdp.arbdp_addr_c2;
wire         		 sctag2_tagctl_hit_c2 	      = `TOP_MEMORY.sctag2.tagctl.tagctl_hit_c2;
wire         		 sctag2_inst_vld_c2   	      = `TOP_MEMORY.sctag2.arbctl_inst_vld_c2;
wire         		 sctag2_mbctl_tagctl_hit_unqual_c2 = `TOP_MEMORY.sctag2.mbctl_tagctl_hit_unqual_c2;

wire         		 sctag2_l2_enable     = ~`TOP_MEMORY.sctag2.l2_bypass_mode_on;
wire         		 sctag2_l2_dir_map_on =  `TOP_MEMORY.sctag2.l2_dir_map_on;

// A store which does not hit in the L2 miss buffer
//-------------------------------------------------
wire store2 = (sctag2_inst_c2[`L2_RQTYP_HI:`L2_RQTYP_LO] == `STORE_RQ) & ~sctag2_inst_c2[`L2_RSVD] |
                  sctag2_inst_vld_c2 & ~sctag2_mbctl_tagctl_hit_unqual_c2;

wire wris82 = sctag2_inst_c2[`L2_RQTYP_LO + 1] &  sctag2_inst_c2[`L2_RSVD] & 
                 sctag2_inst_vld_c2 & ~sctag2_mbctl_tagctl_hit_unqual_c2;

wire wris642= sctag2_inst_c2[`L2_RQTYP_LO + 2]  &  sctag2_inst_c2[`L2_RSVD] & 
                 sctag2_inst_vld_c2 & ~sctag2_mbctl_tagctl_hit_unqual_c2;

wire load2  = (sctag2_inst_c2[`L2_RQTYP_HI:`L2_RQTYP_LO] == `LOAD_RQ)  & ~sctag2_inst_c2[`L2_RSVD] &
                  sctag2_inst_vld_c2 & ~sctag2_mbctl_tagctl_hit_unqual_c2;

wire ldd2   = sctag2_inst_c2[`L2_RQTYP_LO]  &  sctag2_inst_c2[`L2_RSVD] & 
                  sctag2_inst_vld_c2 & ~sctag2_mbctl_tagctl_hit_unqual_c2;
wire [`L2_FBF:`L2_SZ_LO] sctag3_inst_c2       	      = `TOP_MEMORY.sctag3.arbdecdp.arbdp_inst_c2;
wire [39:0]  		 sctag3_addr_c2       	      = `TOP_MEMORY.sctag3.arbaddrdp.arbdp_addr_c2;
wire         		 sctag3_tagctl_hit_c2 	      = `TOP_MEMORY.sctag3.tagctl.tagctl_hit_c2;
wire         		 sctag3_inst_vld_c2   	      = `TOP_MEMORY.sctag3.arbctl_inst_vld_c2;
wire         		 sctag3_mbctl_tagctl_hit_unqual_c2 = `TOP_MEMORY.sctag3.mbctl_tagctl_hit_unqual_c2;

wire         		 sctag3_l2_enable     = ~`TOP_MEMORY.sctag3.l2_bypass_mode_on;
wire         		 sctag3_l2_dir_map_on =  `TOP_MEMORY.sctag3.l2_dir_map_on;

// A store which does not hit in the L2 miss buffer
//-------------------------------------------------
wire store3 = (sctag3_inst_c2[`L2_RQTYP_HI:`L2_RQTYP_LO] == `STORE_RQ) & ~sctag3_inst_c2[`L2_RSVD] |
                  sctag3_inst_vld_c2 & ~sctag3_mbctl_tagctl_hit_unqual_c2;

wire wris83 = sctag3_inst_c2[`L2_RQTYP_LO + 1] &  sctag3_inst_c2[`L2_RSVD] & 
                 sctag3_inst_vld_c2 & ~sctag3_mbctl_tagctl_hit_unqual_c2;

wire wris643= sctag3_inst_c2[`L2_RQTYP_LO + 2]  &  sctag3_inst_c2[`L2_RSVD] & 
                 sctag3_inst_vld_c2 & ~sctag3_mbctl_tagctl_hit_unqual_c2;

wire load3  = (sctag3_inst_c2[`L2_RQTYP_HI:`L2_RQTYP_LO] == `LOAD_RQ)  & ~sctag3_inst_c2[`L2_RSVD] &
                  sctag3_inst_vld_c2 & ~sctag3_mbctl_tagctl_hit_unqual_c2;

wire ldd3   = sctag3_inst_c2[`L2_RQTYP_LO]  &  sctag3_inst_c2[`L2_RSVD] & 
                  sctag3_inst_vld_c2 & ~sctag3_mbctl_tagctl_hit_unqual_c2;

wire[3:0] l2_enable = {sctag3_l2_enable, sctag2_l2_enable, sctag1_l2_enable, sctag0_l2_enable};
always @(l2_enable)
    $display("%0d tso_mon: l2_enable changed to %x", $time, l2_enable);

wire[3:0] l2_dir_map_on = {sctag3_l2_dir_map_on, sctag2_l2_dir_map_on, sctag1_l2_dir_map_on, sctag0_l2_dir_map_on};
always @(l2_dir_map_on)
    $display("%0d tso_mon: l2_dir_map_on changed to %x", $time, l2_dir_map_on);

//==========================================================================================
// Some FSM-s for coverage - NOT very important
`define L2_FSM_IDLE    4'b0000
`define L2_FSM_ST1     4'b0001
`define L2_FSM_ST2M    4'b0010
`define L2_FSM_LD1M    4'b0011
`define L2_FSM_LD2M    4'b0100
`define L2_FSM_ST2H    4'b0101
`define L2_FSM_LD1H    4'b0110
`define L2_FSM_LD2H    4'b0111

//==========================================================================================
reg     [3:0] l2_fsm1;
integer       l2_fsm1_counter;
reg [39:8] l2_fsm1_addr1, l2_fsm1_addr2;
reg [4:0]  l2_fsm1_id1, l2_fsm1_id2;

always @(posedge clk)
begin
  if(~rst_l)
     l2_fsm1_counter <= 0;
  else if(l2_fsm1 == `L2_FSM_IDLE)
     l2_fsm1_counter <= 0;
  else 
     l2_fsm1_counter <= l2_fsm1_counter + 1;

  if(~rst_l)
  begin
     l2_fsm1 <= `L2_FSM_IDLE;
  end

// A first store not issued from miss buffer
//-------------------------------------------------------------------------------
  else if(store0 & ~sctag0_inst_c2[`L2_MBF] & ~sctag0_tagctl_hit_c2 & (l2_fsm1 == `L2_FSM_IDLE))
  begin
    l2_fsm1_addr1 <= sctag0_addr_c2[39:8];
    l2_fsm1_id1   <= sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm1       <= `L2_FSM_ST1;
  end
  else if(store1 & ~sctag1_inst_c2[`L2_MBF] & ~sctag1_tagctl_hit_c2 & (l2_fsm1 == `L2_FSM_IDLE))
  begin
    l2_fsm1_addr1 <= sctag1_addr_c2[39:8];
    l2_fsm1_id1   <= sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm1       <= `L2_FSM_ST1;
  end
  else if(store2 & ~sctag2_inst_c2[`L2_MBF] & ~sctag2_tagctl_hit_c2 & (l2_fsm1 == `L2_FSM_IDLE))
  begin
    l2_fsm1_addr1 <= sctag2_addr_c2[39:8];
    l2_fsm1_id1   <= sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm1       <= `L2_FSM_ST1;
  end
  else if(store3 & ~sctag3_inst_c2[`L2_MBF] & ~sctag3_tagctl_hit_c2 & (l2_fsm1 == `L2_FSM_IDLE))
  begin
    l2_fsm1_addr1 <= sctag3_addr_c2[39:8];
    l2_fsm1_id1   <= sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm1       <= `L2_FSM_ST1;
  end

// The second store - may be a miss  or  a hit
//-------------------------------------------------------------------------------
  else if(store0 & ~sctag0_inst_c2[`L2_MBF] & (l2_fsm1 == `L2_FSM_ST1)) 
  begin
    l2_fsm1_addr2  <= sctag0_addr_c2[39:8];
    l2_fsm1_id2    <= sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm1   <= sctag0_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(store1 & ~sctag1_inst_c2[`L2_MBF] & (l2_fsm1 == `L2_FSM_ST1)) 
  begin
    l2_fsm1_addr2  <= sctag1_addr_c2[39:8];
    l2_fsm1_id2    <= sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm1   <= sctag1_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(store2 & ~sctag2_inst_c2[`L2_MBF] & (l2_fsm1 == `L2_FSM_ST1)) 
  begin
    l2_fsm1_addr2  <= sctag2_addr_c2[39:8];
    l2_fsm1_id2    <= sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm1   <= sctag2_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(store3 & ~sctag3_inst_c2[`L2_MBF] & (l2_fsm1 == `L2_FSM_ST1)) 
  begin
    l2_fsm1_addr2  <= sctag3_addr_c2[39:8];
    l2_fsm1_id2    <= sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm1   <= sctag3_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end

// A load to address2 is a hit or returned already
// the load is eaither not starting from the L2 MB and is a hit
// or is starting from the L2MB.
//-------------------------------------------------------------------------------
  else if(load0 & (~sctag0_inst_c2[`L2_MBF]   & sctag0_tagctl_hit_c2 | 
                      ~sctag0_inst_c2[`L2_EVICT] & sctag0_inst_c2[`L2_MBF]) & 
	  ((l2_fsm1 == `L2_FSM_ST2M) | (l2_fsm1 == `L2_FSM_ST2H)) &
	  (sctag0_addr_c2[39:8] == l2_fsm1_addr2[39:8])) 
  begin
    if(l2_fsm1 == `L2_FSM_ST2M) 	l2_fsm1   <= `L2_FSM_LD1M;
    else 				l2_fsm1   <= `L2_FSM_LD1H;
  end
  else if(load1 & (~sctag1_inst_c2[`L2_MBF]   & sctag1_tagctl_hit_c2 | 
                      ~sctag1_inst_c2[`L2_EVICT] & sctag1_inst_c2[`L2_MBF]) & 
	  ((l2_fsm1 == `L2_FSM_ST2M) | (l2_fsm1 == `L2_FSM_ST2H)) &
	  (sctag1_addr_c2[39:8] == l2_fsm1_addr2[39:8])) 
  begin
    if(l2_fsm1 == `L2_FSM_ST2M) 	l2_fsm1   <= `L2_FSM_LD1M;
    else 				l2_fsm1   <= `L2_FSM_LD1H;
  end
  else if(load2 & (~sctag2_inst_c2[`L2_MBF]   & sctag2_tagctl_hit_c2 | 
                      ~sctag2_inst_c2[`L2_EVICT] & sctag2_inst_c2[`L2_MBF]) & 
	  ((l2_fsm1 == `L2_FSM_ST2M) | (l2_fsm1 == `L2_FSM_ST2H)) &
	  (sctag2_addr_c2[39:8] == l2_fsm1_addr2[39:8])) 
  begin
    if(l2_fsm1 == `L2_FSM_ST2M) 	l2_fsm1   <= `L2_FSM_LD1M;
    else 				l2_fsm1   <= `L2_FSM_LD1H;
  end
  else if(load3 & (~sctag3_inst_c2[`L2_MBF]   & sctag3_tagctl_hit_c2 | 
                      ~sctag3_inst_c2[`L2_EVICT] & sctag3_inst_c2[`L2_MBF]) & 
	  ((l2_fsm1 == `L2_FSM_ST2M) | (l2_fsm1 == `L2_FSM_ST2H)) &
	  (sctag3_addr_c2[39:8] == l2_fsm1_addr2[39:8])) 
  begin
    if(l2_fsm1 == `L2_FSM_ST2M) 	l2_fsm1   <= `L2_FSM_LD1M;
    else 				l2_fsm1   <= `L2_FSM_LD1H;
  end

// A load to address1 is a miss.
//-------------------------------------------------------------------------------
  else if(load0 & ~sctag0_tagctl_hit_c2 & 
          ((l2_fsm1 == `L2_FSM_LD1M) | (l2_fsm1 == `L2_FSM_LD1H)) &
          (sctag0_addr_c2[39:8] == l2_fsm1_addr1)) 
  begin
    if(l2_fsm1 == `L2_FSM_LD1M) 	l2_fsm1   <= `L2_FSM_LD2M;
    else 				l2_fsm1   <= `L2_FSM_LD2H;
  end
  else if(load1 & ~sctag1_tagctl_hit_c2 & 
          ((l2_fsm1 == `L2_FSM_LD1M) | (l2_fsm1 == `L2_FSM_LD1H)) &
          (sctag1_addr_c2[39:8] == l2_fsm1_addr1)) 
  begin
    if(l2_fsm1 == `L2_FSM_LD1M) 	l2_fsm1   <= `L2_FSM_LD2M;
    else 				l2_fsm1   <= `L2_FSM_LD2H;
  end
  else if(load2 & ~sctag2_tagctl_hit_c2 & 
          ((l2_fsm1 == `L2_FSM_LD1M) | (l2_fsm1 == `L2_FSM_LD1H)) &
          (sctag2_addr_c2[39:8] == l2_fsm1_addr1)) 
  begin
    if(l2_fsm1 == `L2_FSM_LD1M) 	l2_fsm1   <= `L2_FSM_LD2M;
    else 				l2_fsm1   <= `L2_FSM_LD2H;
  end
  else if(load3 & ~sctag3_tagctl_hit_c2 & 
          ((l2_fsm1 == `L2_FSM_LD1M) | (l2_fsm1 == `L2_FSM_LD1H)) &
          (sctag3_addr_c2[39:8] == l2_fsm1_addr1)) 
  begin
    if(l2_fsm1 == `L2_FSM_LD1M) 	l2_fsm1   <= `L2_FSM_LD2M;
    else 				l2_fsm1   <= `L2_FSM_LD2H;
  end
//-------------------------------------------
// returning the FSM to idle stuff
// when the original store does the last pass.
//-------------------------------------------
  else if(store0 & (sctag0_addr_c2[39:8] == l2_fsm1_addr1[39:8]) &
          (sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm1_id1)  &
          ~sctag0_inst_c2[`L2_EVICT] & sctag0_inst_c2[`L2_MBF])
    l2_fsm1   <= `L2_FSM_IDLE;
  else if(store1 & (sctag1_addr_c2[39:8] == l2_fsm1_addr1[39:8]) &
          (sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm1_id1)  &
          ~sctag1_inst_c2[`L2_EVICT] & sctag1_inst_c2[`L2_MBF])
    l2_fsm1   <= `L2_FSM_IDLE;
  else if(store2 & (sctag2_addr_c2[39:8] == l2_fsm1_addr1[39:8]) &
          (sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm1_id1)  &
          ~sctag2_inst_c2[`L2_EVICT] & sctag2_inst_c2[`L2_MBF])
    l2_fsm1   <= `L2_FSM_IDLE;
  else if(store3 & (sctag3_addr_c2[39:8] == l2_fsm1_addr1[39:8]) &
          (sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm1_id1)  &
          ~sctag3_inst_c2[`L2_EVICT] & sctag3_inst_c2[`L2_MBF])
    l2_fsm1   <= `L2_FSM_IDLE;
  else if(l2_fsm1_counter > 1000)
    l2_fsm1   <= `L2_FSM_IDLE;
end

//==========================================================================================
reg     [3:0] l2_fsm2;
integer       l2_fsm2_counter;
reg [39:8] l2_fsm2_addr1, l2_fsm2_addr2;
reg [4:0]  l2_fsm2_id1, l2_fsm2_id2;

always @(posedge clk)
begin
  if(~rst_l)
     l2_fsm2_counter <= 0;
  else if(l2_fsm2 == `L2_FSM_IDLE)
     l2_fsm2_counter <= 0;
  else 
     l2_fsm2_counter <= l2_fsm2_counter + 1;

  if(~rst_l)
  begin
     l2_fsm2 <= `L2_FSM_IDLE;
  end

// A first store or wris8 not issued from miss buffer.
//-------------------------------------------------------------------------------
  else if(wris640 & ~sctag0_inst_c2[`L2_MBF] & ~sctag0_tagctl_hit_c2 & (l2_fsm2 == `L2_FSM_IDLE))
  begin
    l2_fsm2_addr1 <= sctag0_addr_c2[39:8];
    l2_fsm2_id1   <= sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm2   <= `L2_FSM_ST1;
  end
  else if(wris641 & ~sctag1_inst_c2[`L2_MBF] & ~sctag1_tagctl_hit_c2 & (l2_fsm2 == `L2_FSM_IDLE))
  begin
    l2_fsm2_addr1 <= sctag1_addr_c2[39:8];
    l2_fsm2_id1   <= sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm2   <= `L2_FSM_ST1;
  end
  else if(wris642 & ~sctag2_inst_c2[`L2_MBF] & ~sctag2_tagctl_hit_c2 & (l2_fsm2 == `L2_FSM_IDLE))
  begin
    l2_fsm2_addr1 <= sctag2_addr_c2[39:8];
    l2_fsm2_id1   <= sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm2   <= `L2_FSM_ST1;
  end
  else if(wris643 & ~sctag3_inst_c2[`L2_MBF] & ~sctag3_tagctl_hit_c2 & (l2_fsm2 == `L2_FSM_IDLE))
  begin
    l2_fsm2_addr1 <= sctag3_addr_c2[39:8];
    l2_fsm2_id1   <= sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm2   <= `L2_FSM_ST1;
  end

// The second store - may be a miss  or  a hit
//-------------------------------------------------------------------------------
  else if(wris640 & ~sctag0_inst_c2[`L2_MBF] & (l2_fsm2 == `L2_FSM_ST1)) 
  begin
    l2_fsm2_addr2  <= sctag0_addr_c2[39:8];
    l2_fsm2_id2    <= sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm2        <= sctag0_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(wris641 & ~sctag1_inst_c2[`L2_MBF] & (l2_fsm2 == `L2_FSM_ST1)) 
  begin
    l2_fsm2_addr2  <= sctag1_addr_c2[39:8];
    l2_fsm2_id2    <= sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm2        <= sctag1_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(wris642 & ~sctag2_inst_c2[`L2_MBF] & (l2_fsm2 == `L2_FSM_ST1)) 
  begin
    l2_fsm2_addr2  <= sctag2_addr_c2[39:8];
    l2_fsm2_id2    <= sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm2        <= sctag2_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(wris643 & ~sctag3_inst_c2[`L2_MBF] & (l2_fsm2 == `L2_FSM_ST1)) 
  begin
    l2_fsm2_addr2  <= sctag3_addr_c2[39:8];
    l2_fsm2_id2    <= sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm2        <= sctag3_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end

// A load to address2 is a hit or returned already
// the load is eaither not starting from the L2 MB and is a hit
// or is starting from the L2MB.
//-------------------------------------------------------------------------------
  else if(load0 & (~sctag0_inst_c2[`L2_MBF]   & sctag0_tagctl_hit_c2 | 
                      ~sctag0_inst_c2[`L2_EVICT] & sctag0_inst_c2[`L2_MBF]) & 
	  ((l2_fsm2 == `L2_FSM_ST2M) | (l2_fsm2 == `L2_FSM_ST2H)) &
	  (sctag0_addr_c2[39:8] == l2_fsm2_addr2[39:8])) 
  begin
    if(l2_fsm2 == `L2_FSM_ST2M) 	l2_fsm2   <= `L2_FSM_LD1M;
    else 				l2_fsm2   <= `L2_FSM_LD1H;
  end
  else if(load1 & (~sctag1_inst_c2[`L2_MBF]   & sctag1_tagctl_hit_c2 | 
                      ~sctag1_inst_c2[`L2_EVICT] & sctag1_inst_c2[`L2_MBF]) & 
	  ((l2_fsm2 == `L2_FSM_ST2M) | (l2_fsm2 == `L2_FSM_ST2H)) &
	  (sctag1_addr_c2[39:8] == l2_fsm2_addr2[39:8])) 
  begin
    if(l2_fsm2 == `L2_FSM_ST2M) 	l2_fsm2   <= `L2_FSM_LD1M;
    else 				l2_fsm2   <= `L2_FSM_LD1H;
  end
  else if(load2 & (~sctag2_inst_c2[`L2_MBF]   & sctag2_tagctl_hit_c2 | 
                      ~sctag2_inst_c2[`L2_EVICT] & sctag2_inst_c2[`L2_MBF]) & 
	  ((l2_fsm2 == `L2_FSM_ST2M) | (l2_fsm2 == `L2_FSM_ST2H)) &
	  (sctag2_addr_c2[39:8] == l2_fsm2_addr2[39:8])) 
  begin
    if(l2_fsm2 == `L2_FSM_ST2M) 	l2_fsm2   <= `L2_FSM_LD1M;
    else 				l2_fsm2   <= `L2_FSM_LD1H;
  end
  else if(load3 & (~sctag3_inst_c2[`L2_MBF]   & sctag3_tagctl_hit_c2 | 
                      ~sctag3_inst_c2[`L2_EVICT] & sctag3_inst_c2[`L2_MBF]) & 
	  ((l2_fsm2 == `L2_FSM_ST2M) | (l2_fsm2 == `L2_FSM_ST2H)) &
	  (sctag3_addr_c2[39:8] == l2_fsm2_addr2[39:8])) 
  begin
    if(l2_fsm2 == `L2_FSM_ST2M) 	l2_fsm2   <= `L2_FSM_LD1M;
    else 				l2_fsm2   <= `L2_FSM_LD1H;
  end

// A load to address1 is a miss.
//-------------------------------------------------------------------------------
  else if(load0 & ~sctag0_tagctl_hit_c2 & 
          ((l2_fsm2 == `L2_FSM_LD1M) | (l2_fsm2 == `L2_FSM_LD1H)) &
          (sctag0_addr_c2[39:8] == l2_fsm2_addr1)) 
  begin
    if(l2_fsm2 == `L2_FSM_LD1M) 	l2_fsm2   <= `L2_FSM_LD2M;
    else 				l2_fsm2   <= `L2_FSM_LD2H;
  end
  else if(load1 & ~sctag1_tagctl_hit_c2 & 
          ((l2_fsm2 == `L2_FSM_LD1M) | (l2_fsm2 == `L2_FSM_LD1H)) &
          (sctag1_addr_c2[39:8] == l2_fsm2_addr1)) 
  begin
    if(l2_fsm2 == `L2_FSM_LD1M) 	l2_fsm2   <= `L2_FSM_LD2M;
    else 				l2_fsm2   <= `L2_FSM_LD2H;
  end
  else if(load2 & ~sctag2_tagctl_hit_c2 & 
          ((l2_fsm2 == `L2_FSM_LD1M) | (l2_fsm2 == `L2_FSM_LD1H)) &
          (sctag2_addr_c2[39:8] == l2_fsm2_addr1)) 
  begin
    if(l2_fsm2 == `L2_FSM_LD1M) 	l2_fsm2   <= `L2_FSM_LD2M;
    else 				l2_fsm2   <= `L2_FSM_LD2H;
  end
  else if(load3 & ~sctag3_tagctl_hit_c2 & 
          ((l2_fsm2 == `L2_FSM_LD1M) | (l2_fsm2 == `L2_FSM_LD1H)) &
          (sctag3_addr_c2[39:8] == l2_fsm2_addr1)) 
  begin
    if(l2_fsm2 == `L2_FSM_LD1M) 	l2_fsm2   <= `L2_FSM_LD2M;
    else 				l2_fsm2   <= `L2_FSM_LD2H;
  end
//-------------------------------------------
// returning the FSM to idle stuff
// when the original store does the last pass.
//-------------------------------------------
  else if(store0 & (sctag0_addr_c2[39:8] == l2_fsm2_addr1[39:8]) &
          (sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm2_id1)  &
          ~sctag0_inst_c2[`L2_EVICT] & sctag0_inst_c2[`L2_MBF])
    l2_fsm2   <= `L2_FSM_IDLE;
  else if(store1 & (sctag1_addr_c2[39:8] == l2_fsm2_addr1[39:8]) &
          (sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm2_id1)  &
          ~sctag1_inst_c2[`L2_EVICT] & sctag1_inst_c2[`L2_MBF])
    l2_fsm2   <= `L2_FSM_IDLE;
  else if(store2 & (sctag2_addr_c2[39:8] == l2_fsm2_addr1[39:8]) &
          (sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm2_id1)  &
          ~sctag2_inst_c2[`L2_EVICT] & sctag2_inst_c2[`L2_MBF])
    l2_fsm2   <= `L2_FSM_IDLE;
  else if(store3 & (sctag3_addr_c2[39:8] == l2_fsm2_addr1[39:8]) &
          (sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm2_id1)  &
          ~sctag3_inst_c2[`L2_EVICT] & sctag3_inst_c2[`L2_MBF])
    l2_fsm2   <= `L2_FSM_IDLE;
  else if(l2_fsm2_counter > 1000)
    l2_fsm2   <= `L2_FSM_IDLE;
end

//==========================================================================================
reg     [3:0] l2_fsm3;
integer       l2_fsm3_counter;
reg [39:8] l2_fsm3_addr1, l2_fsm3_addr2;
reg [4:0]  l2_fsm3_id1, l2_fsm3_id2;

always @(posedge clk)
begin
  if(~rst_l)
     l2_fsm3_counter <= 0;
  else if(l2_fsm3 == `L2_FSM_IDLE)
     l2_fsm3_counter <= 0;
  else 
     l2_fsm3_counter <= l2_fsm3_counter + 1;

  if(~rst_l)
  begin
     l2_fsm3 <= `L2_FSM_IDLE;
  end

// A first store or wris8 not issued from miss buffer.
//-------------------------------------------------------------------------------
  else if(wris80 & ~sctag0_inst_c2[`L2_MBF] & ~sctag0_tagctl_hit_c2 & (l2_fsm3 == `L2_FSM_IDLE))
  begin
    l2_fsm3_addr1 <= sctag0_addr_c2[39:8];
    l2_fsm3_id1   <= sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm3   <= `L2_FSM_ST1;
  end
  else if(wris81 & ~sctag1_inst_c2[`L2_MBF] & ~sctag1_tagctl_hit_c2 & (l2_fsm3 == `L2_FSM_IDLE))
  begin
    l2_fsm3_addr1 <= sctag1_addr_c2[39:8];
    l2_fsm3_id1   <= sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm3   <= `L2_FSM_ST1;
  end
  else if(wris82 & ~sctag2_inst_c2[`L2_MBF] & ~sctag2_tagctl_hit_c2 & (l2_fsm3 == `L2_FSM_IDLE))
  begin
    l2_fsm3_addr1 <= sctag2_addr_c2[39:8];
    l2_fsm3_id1   <= sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm3   <= `L2_FSM_ST1;
  end
  else if(wris83 & ~sctag3_inst_c2[`L2_MBF] & ~sctag3_tagctl_hit_c2 & (l2_fsm3 == `L2_FSM_IDLE))
  begin
    l2_fsm3_addr1 <= sctag3_addr_c2[39:8];
    l2_fsm3_id1   <= sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm3   <= `L2_FSM_ST1;
  end

// The second store - may be a miss  or  a hit
//-------------------------------------------------------------------------------
  else if(wris80 & ~sctag0_inst_c2[`L2_MBF] & (l2_fsm3 == `L2_FSM_ST1)) 
  begin
    l2_fsm3_addr2  <= sctag0_addr_c2[39:8];
    l2_fsm3_id2    <= sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm3   <= sctag0_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(wris81 & ~sctag1_inst_c2[`L2_MBF] & (l2_fsm3 == `L2_FSM_ST1)) 
  begin
    l2_fsm3_addr2  <= sctag1_addr_c2[39:8];
    l2_fsm3_id2    <= sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm3   <= sctag1_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(wris82 & ~sctag2_inst_c2[`L2_MBF] & (l2_fsm3 == `L2_FSM_ST1)) 
  begin
    l2_fsm3_addr2  <= sctag2_addr_c2[39:8];
    l2_fsm3_id2    <= sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm3   <= sctag2_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(wris83 & ~sctag3_inst_c2[`L2_MBF] & (l2_fsm3 == `L2_FSM_ST1)) 
  begin
    l2_fsm3_addr2  <= sctag3_addr_c2[39:8];
    l2_fsm3_id2    <= sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm3   <= sctag3_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end

// A load to address2 is a hit or returned already
// the load is eaither not starting from the L2 MB and is a hit
// or is starting from the L2MB.
//-------------------------------------------------------------------------------
  else if(load0 & (~sctag0_inst_c2[`L2_MBF]   & sctag0_tagctl_hit_c2 | 
                      ~sctag0_inst_c2[`L2_EVICT] & sctag0_inst_c2[`L2_MBF]) & 
	  ((l2_fsm3 == `L2_FSM_ST2M) | (l2_fsm3 == `L2_FSM_ST2H)) &
	  (sctag0_addr_c2[39:8] == l2_fsm3_addr2[39:8])) 
  begin
    if(l2_fsm3 == `L2_FSM_ST2M) 	l2_fsm3   <= `L2_FSM_LD1M;
    else 				l2_fsm3   <= `L2_FSM_LD1H;
  end
  else if(load1 & (~sctag1_inst_c2[`L2_MBF]   & sctag1_tagctl_hit_c2 | 
                      ~sctag1_inst_c2[`L2_EVICT] & sctag1_inst_c2[`L2_MBF]) & 
	  ((l2_fsm3 == `L2_FSM_ST2M) | (l2_fsm3 == `L2_FSM_ST2H)) &
	  (sctag1_addr_c2[39:8] == l2_fsm3_addr2[39:8])) 
  begin
    if(l2_fsm3 == `L2_FSM_ST2M) 	l2_fsm3   <= `L2_FSM_LD1M;
    else 				l2_fsm3   <= `L2_FSM_LD1H;
  end
  else if(load2 & (~sctag2_inst_c2[`L2_MBF]   & sctag2_tagctl_hit_c2 | 
                      ~sctag2_inst_c2[`L2_EVICT] & sctag2_inst_c2[`L2_MBF]) & 
	  ((l2_fsm3 == `L2_FSM_ST2M) | (l2_fsm3 == `L2_FSM_ST2H)) &
	  (sctag2_addr_c2[39:8] == l2_fsm3_addr2[39:8])) 
  begin
    if(l2_fsm3 == `L2_FSM_ST2M) 	l2_fsm3   <= `L2_FSM_LD1M;
    else 				l2_fsm3   <= `L2_FSM_LD1H;
  end
  else if(load3 & (~sctag3_inst_c2[`L2_MBF]   & sctag3_tagctl_hit_c2 | 
                      ~sctag3_inst_c2[`L2_EVICT] & sctag3_inst_c2[`L2_MBF]) & 
	  ((l2_fsm3 == `L2_FSM_ST2M) | (l2_fsm3 == `L2_FSM_ST2H)) &
	  (sctag3_addr_c2[39:8] == l2_fsm3_addr2[39:8])) 
  begin
    if(l2_fsm3 == `L2_FSM_ST2M) 	l2_fsm3   <= `L2_FSM_LD1M;
    else 				l2_fsm3   <= `L2_FSM_LD1H;
  end

// A load to address1 is a miss.
//-------------------------------------------------------------------------------
  else if(load0 & ~sctag0_tagctl_hit_c2 & 
          ((l2_fsm3 == `L2_FSM_LD1M) | (l2_fsm3 == `L2_FSM_LD1H)) &
          (sctag0_addr_c2[39:8] == l2_fsm3_addr1)) 
  begin
    if(l2_fsm3 == `L2_FSM_LD1M) 	l2_fsm3   <= `L2_FSM_LD2M;
    else 				l2_fsm3   <= `L2_FSM_LD2H;
  end
  else if(load1 & ~sctag1_tagctl_hit_c2 & 
          ((l2_fsm3 == `L2_FSM_LD1M) | (l2_fsm3 == `L2_FSM_LD1H)) &
          (sctag1_addr_c2[39:8] == l2_fsm3_addr1)) 
  begin
    if(l2_fsm3 == `L2_FSM_LD1M) 	l2_fsm3   <= `L2_FSM_LD2M;
    else 				l2_fsm3   <= `L2_FSM_LD2H;
  end
  else if(load2 & ~sctag2_tagctl_hit_c2 & 
          ((l2_fsm3 == `L2_FSM_LD1M) | (l2_fsm3 == `L2_FSM_LD1H)) &
          (sctag2_addr_c2[39:8] == l2_fsm3_addr1)) 
  begin
    if(l2_fsm3 == `L2_FSM_LD1M) 	l2_fsm3   <= `L2_FSM_LD2M;
    else 				l2_fsm3   <= `L2_FSM_LD2H;
  end
  else if(load3 & ~sctag3_tagctl_hit_c2 & 
          ((l2_fsm3 == `L2_FSM_LD1M) | (l2_fsm3 == `L2_FSM_LD1H)) &
          (sctag3_addr_c2[39:8] == l2_fsm3_addr1)) 
  begin
    if(l2_fsm3 == `L2_FSM_LD1M) 	l2_fsm3   <= `L2_FSM_LD2M;
    else 				l2_fsm3   <= `L2_FSM_LD2H;
  end
//-------------------------------------------
// returning the FSM to idle stuff
// Note - NOT when the original store does the last pass
// but when a new store comes
// when the original store does the last pass.
//-------------------------------------------
  else if(wris80 & (sctag0_addr_c2[39:8] == l2_fsm3_addr1[39:8]) &
          ~sctag0_inst_c2[`L2_EVICT] & ~sctag0_inst_c2[`L2_MBF])
    l2_fsm3   <= `L2_FSM_IDLE;
  else if(wris81 & (sctag1_addr_c2[39:8] == l2_fsm3_addr1[39:8]) &
          ~sctag1_inst_c2[`L2_EVICT] & ~sctag1_inst_c2[`L2_MBF])
    l2_fsm3   <= `L2_FSM_IDLE;
  else if(wris82 & (sctag2_addr_c2[39:8] == l2_fsm3_addr1[39:8]) &
          ~sctag2_inst_c2[`L2_EVICT] & ~sctag2_inst_c2[`L2_MBF])
    l2_fsm3   <= `L2_FSM_IDLE;
  else if(wris83 & (sctag3_addr_c2[39:8] == l2_fsm3_addr1[39:8]) &
          ~sctag3_inst_c2[`L2_EVICT] & ~sctag3_inst_c2[`L2_MBF])
    l2_fsm3   <= `L2_FSM_IDLE;
  else if(l2_fsm3_counter > 1000)
    l2_fsm3   <= `L2_FSM_IDLE;
end

//==========================================================================================
reg     [3:0] l2_fsm4;
integer       l2_fsm4_counter;
reg [39:8] l2_fsm4_addr1, l2_fsm4_addr2;
reg [4:0]  l2_fsm4_id1, l2_fsm4_id2;

always @(posedge clk)
begin
  if(~rst_l)
     l2_fsm4_counter <= 0;
  else if(l2_fsm4 == `L2_FSM_IDLE)
     l2_fsm4_counter <= 0;
  else 
     l2_fsm4_counter <= l2_fsm4_counter + 1;

  if(~rst_l)
  begin
     l2_fsm4 <= `L2_FSM_IDLE;
  end

// A first store  not issued from miss buffer.
//-------------------------------------------------------------------------------
  else if(store0 & ~sctag0_inst_c2[`L2_MBF] & ~sctag0_tagctl_hit_c2 & (l2_fsm4 == `L2_FSM_IDLE))
  begin
    l2_fsm4_addr1 <= sctag0_addr_c2[39:8];
    l2_fsm4_id1   <= sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm4   <= `L2_FSM_ST1;
  end
  else if(store1 & ~sctag1_inst_c2[`L2_MBF] & ~sctag1_tagctl_hit_c2 & (l2_fsm4 == `L2_FSM_IDLE))
  begin
    l2_fsm4_addr1 <= sctag1_addr_c2[39:8];
    l2_fsm4_id1   <= sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm4   <= `L2_FSM_ST1;
  end
  else if(store2 & ~sctag2_inst_c2[`L2_MBF] & ~sctag2_tagctl_hit_c2 & (l2_fsm4 == `L2_FSM_IDLE))
  begin
    l2_fsm4_addr1 <= sctag2_addr_c2[39:8];
    l2_fsm4_id1   <= sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm4   <= `L2_FSM_ST1;
  end
  else if(store3 & ~sctag3_inst_c2[`L2_MBF] & ~sctag3_tagctl_hit_c2 & (l2_fsm4 == `L2_FSM_IDLE))
  begin
    l2_fsm4_addr1 <= sctag3_addr_c2[39:8];
    l2_fsm4_id1   <= sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm4   <= `L2_FSM_ST1;
  end

// The second store - may be a miss  or  a hit
//-------------------------------------------------------------------------------
  else if(store0 & ~sctag0_inst_c2[`L2_MBF] & (l2_fsm4 == `L2_FSM_ST1)) 
  begin
    l2_fsm4_addr2  <= sctag0_addr_c2[39:8];
    l2_fsm4_id2    <= sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm4   <= sctag0_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(store1 & ~sctag1_inst_c2[`L2_MBF] & (l2_fsm4 == `L2_FSM_ST1)) 
  begin
    l2_fsm4_addr2  <= sctag1_addr_c2[39:8];
    l2_fsm4_id2    <= sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm4   <= sctag1_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(store2 & ~sctag2_inst_c2[`L2_MBF] & (l2_fsm4 == `L2_FSM_ST1)) 
  begin
    l2_fsm4_addr2  <= sctag2_addr_c2[39:8];
    l2_fsm4_id2    <= sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm4   <= sctag2_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end
  else if(store3 & ~sctag3_inst_c2[`L2_MBF] & (l2_fsm4 == `L2_FSM_ST1)) 
  begin
    l2_fsm4_addr2  <= sctag3_addr_c2[39:8];
    l2_fsm4_id2    <= sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO];
    l2_fsm4   <= sctag3_tagctl_hit_c2 ? `L2_FSM_ST2H : `L2_FSM_ST2M;
  end

// A load to address2 is a hit or returned already
// the load is eaither not starting from the L2 MB and is a hit
// or is starting from the L2MB.
//-------------------------------------------------------------------------------
  else if(ldd0 & (~sctag0_inst_c2[`L2_MBF]   & sctag0_tagctl_hit_c2 | 
                      ~sctag0_inst_c2[`L2_EVICT] & sctag0_inst_c2[`L2_MBF]) & 
	  ((l2_fsm4 == `L2_FSM_ST2M) | (l2_fsm4 == `L2_FSM_ST2H)) &
	  (sctag0_addr_c2[39:8] == l2_fsm4_addr2[39:8])) 
  begin
    if(l2_fsm4 == `L2_FSM_ST2M) 	l2_fsm4   <= `L2_FSM_LD1M;
    else 				l2_fsm4   <= `L2_FSM_LD1H;
  end
  else if(ldd1 & (~sctag1_inst_c2[`L2_MBF]   & sctag1_tagctl_hit_c2 | 
                      ~sctag1_inst_c2[`L2_EVICT] & sctag1_inst_c2[`L2_MBF]) & 
	  ((l2_fsm4 == `L2_FSM_ST2M) | (l2_fsm4 == `L2_FSM_ST2H)) &
	  (sctag1_addr_c2[39:8] == l2_fsm4_addr2[39:8])) 
  begin
    if(l2_fsm4 == `L2_FSM_ST2M) 	l2_fsm4   <= `L2_FSM_LD1M;
    else 				l2_fsm4   <= `L2_FSM_LD1H;
  end
  else if(ldd2 & (~sctag2_inst_c2[`L2_MBF]   & sctag2_tagctl_hit_c2 | 
                      ~sctag2_inst_c2[`L2_EVICT] & sctag2_inst_c2[`L2_MBF]) & 
	  ((l2_fsm4 == `L2_FSM_ST2M) | (l2_fsm4 == `L2_FSM_ST2H)) &
	  (sctag2_addr_c2[39:8] == l2_fsm4_addr2[39:8])) 
  begin
    if(l2_fsm4 == `L2_FSM_ST2M) 	l2_fsm4   <= `L2_FSM_LD1M;
    else 				l2_fsm4   <= `L2_FSM_LD1H;
  end
  else if(ldd3 & (~sctag3_inst_c2[`L2_MBF]   & sctag3_tagctl_hit_c2 | 
                      ~sctag3_inst_c2[`L2_EVICT] & sctag3_inst_c2[`L2_MBF]) & 
	  ((l2_fsm4 == `L2_FSM_ST2M) | (l2_fsm4 == `L2_FSM_ST2H)) &
	  (sctag3_addr_c2[39:8] == l2_fsm4_addr2[39:8])) 
  begin
    if(l2_fsm4 == `L2_FSM_ST2M) 	l2_fsm4   <= `L2_FSM_LD1M;
    else 				l2_fsm4   <= `L2_FSM_LD1H;
  end

// A load to address1 is a miss.
//-------------------------------------------------------------------------------
  else if(load0 & ~sctag0_tagctl_hit_c2 & 
          ((l2_fsm4 == `L2_FSM_LD1M) | (l2_fsm4 == `L2_FSM_LD1H)) &
          (sctag0_addr_c2[39:8] == l2_fsm4_addr1)) 
  begin
    if(l2_fsm4 == `L2_FSM_LD1M) 	l2_fsm4   <= `L2_FSM_LD2M;
    else 				l2_fsm4   <= `L2_FSM_LD2H;
  end
  else if(load1 & ~sctag1_tagctl_hit_c2 & 
          ((l2_fsm4 == `L2_FSM_LD1M) | (l2_fsm4 == `L2_FSM_LD1H)) &
          (sctag1_addr_c2[39:8] == l2_fsm4_addr1)) 
  begin
    if(l2_fsm4 == `L2_FSM_LD1M) 	l2_fsm4   <= `L2_FSM_LD2M;
    else 				l2_fsm4   <= `L2_FSM_LD2H;
  end
  else if(load2 & ~sctag2_tagctl_hit_c2 & 
          ((l2_fsm4 == `L2_FSM_LD1M) | (l2_fsm4 == `L2_FSM_LD1H)) &
          (sctag2_addr_c2[39:8] == l2_fsm4_addr1)) 
  begin
    if(l2_fsm4 == `L2_FSM_LD1M) 	l2_fsm4   <= `L2_FSM_LD2M;
    else 				l2_fsm4   <= `L2_FSM_LD2H;
  end
  else if(load3 & ~sctag3_tagctl_hit_c2 & 
          ((l2_fsm4 == `L2_FSM_LD1M) | (l2_fsm4 == `L2_FSM_LD1H)) &
          (sctag3_addr_c2[39:8] == l2_fsm4_addr1)) 
  begin
    if(l2_fsm4 == `L2_FSM_LD1M) 	l2_fsm4   <= `L2_FSM_LD2M;
    else 				l2_fsm4   <= `L2_FSM_LD2H;
  end
//-------------------------------------------
// returning the FSM to idle stuff
// when the original store does the last pass.
//-------------------------------------------
  else if(store0 & (sctag0_addr_c2[39:8] == l2_fsm4_addr1[39:8]) &
          (sctag0_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm4_id1)  &
          ~sctag0_inst_c2[`L2_EVICT] & sctag0_inst_c2[`L2_MBF])
    l2_fsm4   <= `L2_FSM_IDLE;
  else if(store1 & (sctag1_addr_c2[39:8] == l2_fsm4_addr1[39:8]) &
          (sctag1_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm4_id1)  &
          ~sctag1_inst_c2[`L2_EVICT] & sctag1_inst_c2[`L2_MBF])
    l2_fsm4   <= `L2_FSM_IDLE;
  else if(store2 & (sctag2_addr_c2[39:8] == l2_fsm4_addr1[39:8]) &
          (sctag2_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm4_id1)  &
          ~sctag2_inst_c2[`L2_EVICT] & sctag2_inst_c2[`L2_MBF])
    l2_fsm4   <= `L2_FSM_IDLE;
  else if(store3 & (sctag3_addr_c2[39:8] == l2_fsm4_addr1[39:8]) &
          (sctag3_inst_c2[`L2_CPUID_HI:`L2_TID_LO] == l2_fsm4_id1)  &
          ~sctag3_inst_c2[`L2_EVICT] & sctag3_inst_c2[`L2_MBF])
    l2_fsm4   <= `L2_FSM_IDLE;
  else if(l2_fsm4_counter > 1000)
    l2_fsm4   <= `L2_FSM_IDLE;
end

//-------------------------------------------------------------------
// L2MB related stuff again - the states of each individual L2MB
//-------------------------------------------------------------------
`define L2MB_IDLE 		4'b0000
`define L2MB_EVICT 		4'b0001
`define L2MB_EVICT_FILL		4'b0010
`define L2MB_EVICT_BYPASS 	4'b0011

reg [39:8] sctag0_l2mb_addr [0:15];
reg [3:0]  sctag0_l2mb_state[0:15];

wire [3:0] sctag0_l2mb_state0  = sctag0_l2mb_state[0];
wire [3:0] sctag0_l2mb_state1  = sctag0_l2mb_state[1];
wire [3:0] sctag0_l2mb_state2  = sctag0_l2mb_state[2];
wire [3:0] sctag0_l2mb_state3  = sctag0_l2mb_state[3];
wire [3:0] sctag0_l2mb_state4  = sctag0_l2mb_state[4];
wire [3:0] sctag0_l2mb_state5  = sctag0_l2mb_state[5];
wire [3:0] sctag0_l2mb_state6  = sctag0_l2mb_state[6];
wire [3:0] sctag0_l2mb_state7  = sctag0_l2mb_state[7];
wire [3:0] sctag0_l2mb_state8  = sctag0_l2mb_state[8];
wire [3:0] sctag0_l2mb_state9  = sctag0_l2mb_state[9];
wire [3:0] sctag0_l2mb_state10 = sctag0_l2mb_state[10];
wire [3:0] sctag0_l2mb_state11 = sctag0_l2mb_state[11];
wire [3:0] sctag0_l2mb_state12 = sctag0_l2mb_state[12];
wire [3:0] sctag0_l2mb_state13 = sctag0_l2mb_state[13];
wire [3:0] sctag0_l2mb_state14 = sctag0_l2mb_state[14];
wire [3:0] sctag0_l2mb_state15 = sctag0_l2mb_state[15];

reg sctag0_l2mb_pointer;
integer sctag0_iii;
reg [39:8] sctag1_l2mb_addr [0:15];
reg [3:0]  sctag1_l2mb_state[0:15];

wire [3:0] sctag1_l2mb_state0  = sctag1_l2mb_state[0];
wire [3:0] sctag1_l2mb_state1  = sctag1_l2mb_state[1];
wire [3:0] sctag1_l2mb_state2  = sctag1_l2mb_state[2];
wire [3:0] sctag1_l2mb_state3  = sctag1_l2mb_state[3];
wire [3:0] sctag1_l2mb_state4  = sctag1_l2mb_state[4];
wire [3:0] sctag1_l2mb_state5  = sctag1_l2mb_state[5];
wire [3:0] sctag1_l2mb_state6  = sctag1_l2mb_state[6];
wire [3:0] sctag1_l2mb_state7  = sctag1_l2mb_state[7];
wire [3:0] sctag1_l2mb_state8  = sctag1_l2mb_state[8];
wire [3:0] sctag1_l2mb_state9  = sctag1_l2mb_state[9];
wire [3:0] sctag1_l2mb_state10 = sctag1_l2mb_state[10];
wire [3:0] sctag1_l2mb_state11 = sctag1_l2mb_state[11];
wire [3:0] sctag1_l2mb_state12 = sctag1_l2mb_state[12];
wire [3:0] sctag1_l2mb_state13 = sctag1_l2mb_state[13];
wire [3:0] sctag1_l2mb_state14 = sctag1_l2mb_state[14];
wire [3:0] sctag1_l2mb_state15 = sctag1_l2mb_state[15];

reg sctag1_l2mb_pointer;
integer sctag1_iii;
reg [39:8] sctag2_l2mb_addr [0:15];
reg [3:0]  sctag2_l2mb_state[0:15];

wire [3:0] sctag2_l2mb_state0  = sctag2_l2mb_state[0];
wire [3:0] sctag2_l2mb_state1  = sctag2_l2mb_state[1];
wire [3:0] sctag2_l2mb_state2  = sctag2_l2mb_state[2];
wire [3:0] sctag2_l2mb_state3  = sctag2_l2mb_state[3];
wire [3:0] sctag2_l2mb_state4  = sctag2_l2mb_state[4];
wire [3:0] sctag2_l2mb_state5  = sctag2_l2mb_state[5];
wire [3:0] sctag2_l2mb_state6  = sctag2_l2mb_state[6];
wire [3:0] sctag2_l2mb_state7  = sctag2_l2mb_state[7];
wire [3:0] sctag2_l2mb_state8  = sctag2_l2mb_state[8];
wire [3:0] sctag2_l2mb_state9  = sctag2_l2mb_state[9];
wire [3:0] sctag2_l2mb_state10 = sctag2_l2mb_state[10];
wire [3:0] sctag2_l2mb_state11 = sctag2_l2mb_state[11];
wire [3:0] sctag2_l2mb_state12 = sctag2_l2mb_state[12];
wire [3:0] sctag2_l2mb_state13 = sctag2_l2mb_state[13];
wire [3:0] sctag2_l2mb_state14 = sctag2_l2mb_state[14];
wire [3:0] sctag2_l2mb_state15 = sctag2_l2mb_state[15];

reg sctag2_l2mb_pointer;
integer sctag2_iii;
reg [39:8] sctag3_l2mb_addr [0:15];
reg [3:0]  sctag3_l2mb_state[0:15];

wire [3:0] sctag3_l2mb_state0  = sctag3_l2mb_state[0];
wire [3:0] sctag3_l2mb_state1  = sctag3_l2mb_state[1];
wire [3:0] sctag3_l2mb_state2  = sctag3_l2mb_state[2];
wire [3:0] sctag3_l2mb_state3  = sctag3_l2mb_state[3];
wire [3:0] sctag3_l2mb_state4  = sctag3_l2mb_state[4];
wire [3:0] sctag3_l2mb_state5  = sctag3_l2mb_state[5];
wire [3:0] sctag3_l2mb_state6  = sctag3_l2mb_state[6];
wire [3:0] sctag3_l2mb_state7  = sctag3_l2mb_state[7];
wire [3:0] sctag3_l2mb_state8  = sctag3_l2mb_state[8];
wire [3:0] sctag3_l2mb_state9  = sctag3_l2mb_state[9];
wire [3:0] sctag3_l2mb_state10 = sctag3_l2mb_state[10];
wire [3:0] sctag3_l2mb_state11 = sctag3_l2mb_state[11];
wire [3:0] sctag3_l2mb_state12 = sctag3_l2mb_state[12];
wire [3:0] sctag3_l2mb_state13 = sctag3_l2mb_state[13];
wire [3:0] sctag3_l2mb_state14 = sctag3_l2mb_state[14];
wire [3:0] sctag3_l2mb_state15 = sctag3_l2mb_state[15];

reg sctag3_l2mb_pointer;
integer sctag3_iii;

always @(posedge clk)
begin
  if(~rst_l)
  begin
    for(sctag0_iii=0; sctag0_iii<16; sctag0_iii = sctag0_iii+1)
	sctag0_l2mb_state[sctag0_iii] = `L2MB_IDLE;
  end

  else if(sctag0_inst_vld_c2 & sctag0_inst_c2[`L2_MBF] & sctag0_inst_c2[`L2_EVICT])
  begin
     sctag0_l2mb_pointer = sctag_find_next_available(2'h0);
     sctag0_l2mb_addr [sctag0_l2mb_pointer] <= sctag0_addr_c2[39:8];
     sctag0_l2mb_state[sctag0_l2mb_pointer] <= `L2MB_EVICT;
  end

  else if(sctag0_inst_vld_c2 & sctag0_inst_c2[`L2_FBF])
  begin
     sctag0_l2mb_pointer =  sctag_l2mb_cam(2'h0);
     sctag0_l2mb_state[sctag0_l2mb_pointer] <= (sctag0_l2mb_state[sctag0_l2mb_pointer] == `L2MB_EVICT) ?
							 `L2MB_EVICT_FILL: `L2MB_IDLE;
  end
  else if(sctag0_inst_vld_c2 & sctag0_inst_c2[`L2_MBF] & ~sctag0_inst_c2[`L2_EVICT])
  begin
     sctag0_l2mb_pointer = sctag_l2mb_cam(2'h0);
     sctag0_l2mb_state[sctag0_l2mb_pointer] <= (sctag0_l2mb_state[sctag0_l2mb_pointer] == `L2MB_EVICT) ?
							 `L2MB_EVICT_BYPASS: `L2MB_IDLE;
  end
end
always @(posedge clk)
begin
  if(~rst_l)
  begin
    for(sctag1_iii=0; sctag1_iii<16; sctag1_iii = sctag1_iii+1)
	sctag1_l2mb_state[sctag1_iii] = `L2MB_IDLE;
  end

  else if(sctag1_inst_vld_c2 & sctag1_inst_c2[`L2_MBF] & sctag1_inst_c2[`L2_EVICT])
  begin
     sctag1_l2mb_pointer = sctag_find_next_available(2'h1);
     sctag1_l2mb_addr [sctag1_l2mb_pointer] <= sctag1_addr_c2[39:8];
     sctag1_l2mb_state[sctag1_l2mb_pointer] <= `L2MB_EVICT;
  end

  else if(sctag1_inst_vld_c2 & sctag1_inst_c2[`L2_FBF])
  begin
     sctag1_l2mb_pointer =  sctag_l2mb_cam(2'h1);
     sctag1_l2mb_state[sctag1_l2mb_pointer] <= (sctag1_l2mb_state[sctag1_l2mb_pointer] == `L2MB_EVICT) ?
							 `L2MB_EVICT_FILL: `L2MB_IDLE;
  end
  else if(sctag1_inst_vld_c2 & sctag1_inst_c2[`L2_MBF] & ~sctag1_inst_c2[`L2_EVICT])
  begin
     sctag1_l2mb_pointer = sctag_l2mb_cam(2'h1);
     sctag1_l2mb_state[sctag0_l2mb_pointer] <= (sctag1_l2mb_state[sctag1_l2mb_pointer] == `L2MB_EVICT) ?
							 `L2MB_EVICT_BYPASS: `L2MB_IDLE;
  end
end
always @(posedge clk)
begin
  if(~rst_l)
  begin
    for(sctag2_iii=0; sctag2_iii<16; sctag2_iii = sctag2_iii+1)
	sctag2_l2mb_state[sctag2_iii] = `L2MB_IDLE;
  end

  else if(sctag2_inst_vld_c2 & sctag2_inst_c2[`L2_MBF] & sctag2_inst_c2[`L2_EVICT])
  begin
     sctag2_l2mb_pointer = sctag_find_next_available(2'h2);
     sctag2_l2mb_addr [sctag2_l2mb_pointer] <= sctag2_addr_c2[39:8];
     sctag2_l2mb_state[sctag2_l2mb_pointer] <= `L2MB_EVICT;
  end

  else if(sctag2_inst_vld_c2 & sctag2_inst_c2[`L2_FBF])
  begin
     sctag2_l2mb_pointer =  sctag_l2mb_cam(2'h2);
     sctag2_l2mb_state[sctag2_l2mb_pointer] <= (sctag2_l2mb_state[sctag2_l2mb_pointer] == `L2MB_EVICT) ?
							 `L2MB_EVICT_FILL: `L2MB_IDLE;
  end
  else if(sctag2_inst_vld_c2 & sctag2_inst_c2[`L2_MBF] & ~sctag2_inst_c2[`L2_EVICT])
  begin
     sctag2_l2mb_pointer = sctag_l2mb_cam(2'h2);
     sctag2_l2mb_state[sctag0_l2mb_pointer] <= (sctag2_l2mb_state[sctag2_l2mb_pointer] == `L2MB_EVICT) ?
							 `L2MB_EVICT_BYPASS: `L2MB_IDLE;
  end
end
always @(posedge clk)
begin
  if(~rst_l)
  begin
    for(sctag3_iii=0; sctag3_iii<16; sctag3_iii = sctag3_iii+1)
	sctag3_l2mb_state[sctag3_iii] = `L2MB_IDLE;
  end

  else if(sctag3_inst_vld_c2 & sctag3_inst_c2[`L2_MBF] & sctag3_inst_c2[`L2_EVICT])
  begin
     sctag3_l2mb_pointer = sctag_find_next_available(2'h3);
     sctag3_l2mb_addr [sctag3_l2mb_pointer] <= sctag3_addr_c2[39:8];
     sctag3_l2mb_state[sctag3_l2mb_pointer] <= `L2MB_EVICT;
  end

  else if(sctag3_inst_vld_c2 & sctag3_inst_c2[`L2_FBF])
  begin
     sctag3_l2mb_pointer =  sctag_l2mb_cam(2'h3);
     sctag3_l2mb_state[sctag3_l2mb_pointer] <= (sctag3_l2mb_state[sctag3_l2mb_pointer] == `L2MB_EVICT) ?
							 `L2MB_EVICT_FILL: `L2MB_IDLE;
  end
  else if(sctag3_inst_vld_c2 & sctag3_inst_c2[`L2_MBF] & ~sctag3_inst_c2[`L2_EVICT])
  begin
     sctag3_l2mb_pointer = sctag_l2mb_cam(2'h3);
     sctag3_l2mb_state[sctag0_l2mb_pointer] <= (sctag3_l2mb_state[sctag3_l2mb_pointer] == `L2MB_EVICT) ?
							 `L2MB_EVICT_BYPASS: `L2MB_IDLE;
  end
end

//============================================================================================
// LSU stuff
//============================================================================================

//============================================================================================
// Back to back invalidates and loads ...cores...
//============================================================================================
`ifdef RTL_SPARC0
wire   C0T0_stb_ne    = |`TOP_DESIGN.sparc0.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C0T1_stb_ne    = |`TOP_DESIGN.sparc0.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C0T2_stb_ne    = |`TOP_DESIGN.sparc0.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C0T3_stb_ne    = |`TOP_DESIGN.sparc0.lsu.stb_ctl3.stb_state_vld[7:0];

wire   C0T0_stb_nced  = |(	 `TOP_DESIGN.sparc0.lsu.stb_ctl0.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc0.lsu.stb_ctl0.stb_state_ced[7:0]);
wire   C0T1_stb_nced  = |(	 `TOP_DESIGN.sparc0.lsu.stb_ctl1.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc0.lsu.stb_ctl1.stb_state_ced[7:0]);
wire   C0T2_stb_nced  = |(	 `TOP_DESIGN.sparc0.lsu.stb_ctl2.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc0.lsu.stb_ctl2.stb_state_ced[7:0]);
wire   C0T3_stb_nced  = |(	 `TOP_DESIGN.sparc0.lsu.stb_ctl3.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc0.lsu.stb_ctl3.stb_state_ced[7:0]);

`else
wire   C0T0_stb_ne    = 1'b0;
wire   C0T1_stb_ne    = 1'b0;
wire   C0T2_stb_ne    = 1'b0;
wire   C0T3_stb_ne    = 1'b0;

wire   C0T0_stb_nced  = 1'b0;
wire   C0T1_stb_nced  = 1'b0;
wire   C0T2_stb_nced  = 1'b0;
wire   C0T3_stb_nced  = 1'b0;
`endif // ifdef RTL_SPARC0

`ifdef RTL_SPARC0

wire   spc0_lsu_ifill_pkt_vld	= `TOP_DESIGN.sparc0.lsu.qctl2.lsu_ifill_pkt_vld;
wire   spc0_dfq_rd_advance  		= `TOP_DESIGN.sparc0.lsu.qctl2.dfq_rd_advance;
wire   spc0_dfq_int_type  		= `TOP_DESIGN.sparc0.lsu.qctl2.dfq_int_type;

wire   spc0_ifu_lsu_inv_clear	= `TOP_DESIGN.sparc0.lsu.qctl2.ifu_lsu_inv_clear;

wire 	    spc0_dva_svld_e 	 	= `TOP_DESIGN.sparc0.lsu.qctl2.dva_svld_e;
wire 	    spc0_dva_rvld_e	 	= `TOP_DESIGN.sparc0.lsu.dva.rd_en;
wire [10:4] spc0_dva_rd_addr_e  	= `TOP_DESIGN.sparc0.lsu.dva.rd_adr1[6:0];
wire [4:0]  spc0_dva_snp_addr_e 	= `TOP_DESIGN.sparc0.lsu.qctl2.dva_snp_addr_e[4:0];

wire [4:0]  spc0_stb_data_rd_ptr   	= `TOP_DESIGN.sparc0.lsu.stb_data_rd_ptr[4:0];
wire [4:0]  spc0_stb_data_wr_ptr   	= `TOP_DESIGN.sparc0.lsu.stb_data_wr_ptr[4:0];
wire        spc0_stb_data_wptr_vld 	= `TOP_DESIGN.sparc0.lsu.stb_data_wptr_vld;
wire        spc0_stb_data_rptr_vld 	= `TOP_DESIGN.sparc0.lsu.stb_data_rptr_vld;
wire        spc0_stbrwctl_flush_pipe_w = `TOP_DESIGN.sparc0.lsu.stb_rwctl.lsu_stbrwctl_flush_pipe_w;
wire        spc0_lsu_st_pcx_rq_pick 	= |`TOP_DESIGN.sparc0.lsu.stb_rwctl.lsu_st_pcx_rq_pick[3:0];

wire [3:0]  spc0_lsu_rd_dtag_parity_g = `TOP_DESIGN.sparc0.lsu.dctl.lsu_rd_dtag_parity_g[3:0];
wire [3:0]  spc0_dva_vld_g		 = `TOP_DESIGN.sparc0.lsu.dctl.dva_vld_g[3:0];

wire [3:0]  spc0_lsu_dc_tag_pe_g_unmasked    = spc0_lsu_rd_dtag_parity_g[3:0] & spc0_dva_vld_g[3:0];
wire        spc0_lsu_dc_tag_pe_g_unmasked_or = |spc0_lsu_dc_tag_pe_g_unmasked[3:0];

wire   C0T0_stb_full  = &`TOP_DESIGN.sparc0.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C0T1_stb_full  = &`TOP_DESIGN.sparc0.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C0T2_stb_full  = &`TOP_DESIGN.sparc0.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C0T3_stb_full  = &`TOP_DESIGN.sparc0.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [7:0] C0T0_stb_vld  = `TOP_DESIGN.sparc0.lsu.stb_ctl0.stb_state_vld[7:0];
wire   [7:0] C0T1_stb_vld  = `TOP_DESIGN.sparc0.lsu.stb_ctl1.stb_state_vld[7:0];
wire   [7:0] C0T2_stb_vld  = `TOP_DESIGN.sparc0.lsu.stb_ctl2.stb_state_vld[7:0];
wire   [7:0] C0T3_stb_vld  = `TOP_DESIGN.sparc0.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [4:0] C0T0_stb_vld_sum  =  C0T0_stb_vld[0] +  C0T0_stb_vld[1] +  C0T0_stb_vld[2] +  C0T0_stb_vld[3] +
                                     C0T0_stb_vld[4] +  C0T0_stb_vld[5] +  C0T0_stb_vld[6] +  C0T0_stb_vld[7] ;
wire   [4:0] C0T1_stb_vld_sum  =  C0T1_stb_vld[0] +  C0T1_stb_vld[1] +  C0T1_stb_vld[2] +  C0T1_stb_vld[3] +
                                     C0T1_stb_vld[4] +  C0T1_stb_vld[5] +  C0T1_stb_vld[6] +  C0T1_stb_vld[7] ;
wire   [4:0] C0T2_stb_vld_sum  =  C0T2_stb_vld[0] +  C0T2_stb_vld[1] +  C0T2_stb_vld[2] +  C0T2_stb_vld[3] +
                                     C0T2_stb_vld[4] +  C0T2_stb_vld[5] +  C0T2_stb_vld[6] +  C0T2_stb_vld[7] ;
wire   [4:0] C0T3_stb_vld_sum  =  C0T3_stb_vld[0] +  C0T3_stb_vld[1] +  C0T3_stb_vld[2] +  C0T3_stb_vld[3] +
                                     C0T3_stb_vld[4] +  C0T3_stb_vld[5] +  C0T3_stb_vld[6] +  C0T3_stb_vld[7] ;

reg [4:0] C0T0_stb_vld_sum_d1;
reg [4:0] C0T1_stb_vld_sum_d1;
reg [4:0] C0T2_stb_vld_sum_d1;
reg [4:0] C0T3_stb_vld_sum_d1;

wire   C0T0_st_ack  = &`TOP_DESIGN.sparc0.lsu.cpx_st_ack_tid0;
wire   C0T1_st_ack  = &`TOP_DESIGN.sparc0.lsu.cpx_st_ack_tid1;
wire   C0T2_st_ack  = &`TOP_DESIGN.sparc0.lsu.cpx_st_ack_tid2;
wire   C0T3_st_ack  = &`TOP_DESIGN.sparc0.lsu.cpx_st_ack_tid3;

wire   C0T0_defr_trp_en	= &`TOP_DESIGN.sparc0.lsu.excpctl.st_defr_trp_en0;
wire   C0T1_defr_trp_en	= &`TOP_DESIGN.sparc0.lsu.excpctl.st_defr_trp_en1;
wire   C0T2_defr_trp_en	= &`TOP_DESIGN.sparc0.lsu.excpctl.st_defr_trp_en2;
wire   C0T3_defr_trp_en	= &`TOP_DESIGN.sparc0.lsu.excpctl.st_defr_trp_en3;

reg C0T0_defr_trp_en_d1;
reg C0T1_defr_trp_en_d1;
reg C0T2_defr_trp_en_d1;
reg C0T3_defr_trp_en_d1;

integer C0T0_stb_drain_cnt;
integer C0T1_stb_drain_cnt;
integer C0T2_stb_drain_cnt;
integer C0T3_stb_drain_cnt;

// Hits in the store buffer
//-------------------------
wire       spc0_inst_vld_w		= `TOP_DESIGN.sparc0.ifu.fcl.inst_vld_w;
wire [1:0] spc0_sas_thrid_w		= `TOP_DESIGN.sparc0.ifu.fcl.sas_thrid_w[1:0];

wire C0_st_ack_w = (spc0_sas_thrid_w == 2'b00) & C0T0_st_ack |
                      (spc0_sas_thrid_w == 2'b01) & C0T1_st_ack |
                      (spc0_sas_thrid_w == 2'b10) & C0T2_st_ack |
                      (spc0_sas_thrid_w == 2'b11) & C0T3_st_ack;

wire [7:0] spc0_stb_ld_full_raw	= `TOP_DESIGN.sparc0.lsu.stb_ld_full_raw[7:0];
wire [7:0] spc0_stb_ld_partial_raw	= `TOP_DESIGN.sparc0.lsu.stb_ld_partial_raw[7:0];
wire       spc0_stb_cam_mhit		= `TOP_DESIGN.sparc0.lsu.stb_cam_mhit;
wire       spc0_stb_cam_hit		= `TOP_DESIGN.sparc0.lsu.stb_cam_hit;
wire [3:0] spc0_lsu_way_hit		= `TOP_DESIGN.sparc0.lsu.dctl.lsu_way_hit[3:0];
wire       spc0_lsu_ifu_ldst_miss_w	= `TOP_DESIGN.sparc0.lsu.lsu_ifu_ldst_miss_w;
wire       spc0_ld_inst_vld_g	= `TOP_DESIGN.sparc0.lsu.dctl.ld_inst_vld_g;
wire       spc0_ldst_dbl_g		= `TOP_DESIGN.sparc0.lsu.dctl.ldst_dbl_g;
wire       spc0_quad_asi_g		= `TOP_DESIGN.sparc0.lsu.dctl.quad_asi_g;
wire [1:0] spc0_ldst_sz_g		= `TOP_DESIGN.sparc0.lsu.dctl.ldst_sz_g;
wire       spc0_lsu_alt_space_g	= `TOP_DESIGN.sparc0.lsu.dctl.lsu_alt_space_g;

wire       spc0_mbar_inst0_g		= `TOP_DESIGN.sparc0.lsu.dctl.mbar_inst0_g;
wire       spc0_mbar_inst1_g		= `TOP_DESIGN.sparc0.lsu.dctl.mbar_inst1_g;
wire       spc0_mbar_inst2_g		= `TOP_DESIGN.sparc0.lsu.dctl.mbar_inst2_g;
wire       spc0_mbar_inst3_g		= `TOP_DESIGN.sparc0.lsu.dctl.mbar_inst3_g;

wire       spc0_flush_inst0_g	= `TOP_DESIGN.sparc0.lsu.dctl.flush_inst0_g;
wire       spc0_flush_inst1_g	= `TOP_DESIGN.sparc0.lsu.dctl.flush_inst1_g;
wire       spc0_flush_inst2_g	= `TOP_DESIGN.sparc0.lsu.dctl.flush_inst2_g;
wire       spc0_flush_inst3_g	= `TOP_DESIGN.sparc0.lsu.dctl.flush_inst3_g;

wire       spc0_intrpt_disp_asi0_g	= `TOP_DESIGN.sparc0.lsu.dctl.intrpt_disp_asi_g & (spc0_sas_thrid_w == 2'b00);
wire       spc0_intrpt_disp_asi1_g	= `TOP_DESIGN.sparc0.lsu.dctl.intrpt_disp_asi_g & (spc0_sas_thrid_w == 2'b01);
wire       spc0_intrpt_disp_asi2_g	= `TOP_DESIGN.sparc0.lsu.dctl.intrpt_disp_asi_g & (spc0_sas_thrid_w == 2'b10);
wire       spc0_intrpt_disp_asi3_g	= `TOP_DESIGN.sparc0.lsu.dctl.intrpt_disp_asi_g & (spc0_sas_thrid_w == 2'b11);

wire       spc0_st_inst_vld_g	= `TOP_DESIGN.sparc0.lsu.dctl.st_inst_vld_g;
wire       spc0_non_altspace_ldst_g	= `TOP_DESIGN.sparc0.lsu.dctl.non_altspace_ldst_g;

wire       spc0_dctl_flush_pipe_w	= `TOP_DESIGN.sparc0.lsu.dctl.dctl_flush_pipe_w;

wire [3:0] spc0_no_spc_rmo_st	= `TOP_DESIGN.sparc0.lsu.dctl.no_spc_rmo_st[3:0];


wire       spc0_ldst_fp_e		= `TOP_DESIGN.sparc0.lsu.ifu_lsu_ldst_fp_e;
wire [2:0] spc0_stb_rdptr		= `TOP_DESIGN.sparc0.lsu.stb_rwctl.stb_rdptr_l;

wire 	   spc0_ld_l2cache_req 	= `TOP_DESIGN.sparc0.lsu.qctl1.ld3_l2cache_rq |
					  `TOP_DESIGN.sparc0.lsu.qctl1.ld2_l2cache_rq |
                 			  `TOP_DESIGN.sparc0.lsu.qctl1.ld1_l2cache_rq |
					  `TOP_DESIGN.sparc0.lsu.qctl1.ld0_l2cache_rq;

wire [3:0] spc0_dcache_enable	= {`TOP_DESIGN.sparc0.lsu.dctl.lsu_ctl_reg0[1],
                                    	   `TOP_DESIGN.sparc0.lsu.dctl.lsu_ctl_reg1[1],
					   `TOP_DESIGN.sparc0.lsu.dctl.lsu_ctl_reg2[1],
					   `TOP_DESIGN.sparc0.lsu.dctl.lsu_ctl_reg3[1]};

wire [3:0] spc0_icache_enable	= `TOP_DESIGN.sparc0.lsu.lsu_ifu_icache_en[3:0];

wire spc0_dc_direct_map 		= `TOP_DESIGN.sparc0.lsu.dc_direct_map;
wire spc0_lsu_ifu_direct_map_l1	= `TOP_DESIGN.sparc0.lsu.lsu_ifu_direct_map_l1;

always @(spc0_dcache_enable)
    $display("%0d tso_mon: spc0_dcache_enable changed to %x", $time, spc0_dcache_enable);

always @(spc0_icache_enable)
    $display("%0d tso_mon: spc0_icache_enable changed to %x", $time, spc0_icache_enable);

always @(spc0_dc_direct_map)
    $display("%0d tso_mon: spc0_dc_direct_map changed to %x", $time, spc0_dc_direct_map);

always @(spc0_lsu_ifu_direct_map_l1)
   $display("%0d tso_mon: spc0_lsu_ifu_direct_map_l1 changed to %x", $time, spc0_lsu_ifu_direct_map_l1);

reg 		spc0_dva_svld_e_d1;
reg 		spc0_dva_rvld_e_d1;
reg [10:4] 	spc0_dva_rd_addr_e_d1;
reg [4:0]  	spc0_dva_snp_addr_e_d1;

reg   		spc0_lsu_snp_after_rd;
reg   		spc0_lsu_rd_after_snp;

reg 	   	spc0_ldst_fp_m, spc0_ldst_fp_g;

integer 	spc0_multiple_hits;

reg spc0_skid_d1, spc0_skid_d2, spc0_skid_d3;
initial begin
  spc0_skid_d1 = 0;
  spc0_skid_d2 = 0;
  spc0_skid_d3 = 0;
end

always @(posedge clk)
begin

  spc0_skid_d1 <= (~spc0_ifu_lsu_inv_clear & spc0_dfq_rd_advance & spc0_dfq_int_type);
  spc0_skid_d2 <= spc0_skid_d1 & ~spc0_ifu_lsu_inv_clear;
  spc0_skid_d3 <= spc0_skid_d2 & ~spc0_ifu_lsu_inv_clear;

// The full tracking of this condition is complicated since after the interrupt is advanced
// there may be more invalidations to the IFQ.
// All we care about is that the invalidations BEFORE the interrupt are finished.
// I provided a command line argument to disable this check.
  if(spc0_skid_d3 & enable_ifu_lsu_inv_clear)
     finish_test("spc", "tso_mon:   spc0_ifu_lsu_inv_clear should have been clear by now", 0);

  spc0_dva_svld_e_d1 	<= spc0_dva_svld_e;
  spc0_dva_rvld_e_d1 	<= spc0_dva_rvld_e;
  spc0_dva_rd_addr_e_d1 	<= spc0_dva_rd_addr_e;
  spc0_dva_snp_addr_e_d1 	<= spc0_dva_snp_addr_e;

  if(spc0_dva_svld_e_d1 & spc0_dva_rvld_e & (spc0_dva_rd_addr_e_d1[10:6] == spc0_dva_snp_addr_e[4:0]))
    spc0_lsu_rd_after_snp <= 1'b1;
  else 
    spc0_lsu_rd_after_snp <= 1'b0;

  if(spc0_dva_svld_e & spc0_dva_rvld_e_d1 & (spc0_dva_rd_addr_e[10:6] == spc0_dva_snp_addr_e_d1[4:0]))
    spc0_lsu_snp_after_rd <= 1'b1;
  else 
    spc0_lsu_snp_after_rd <= 1'b0;

  spc0_ldst_fp_m <= spc0_ldst_fp_e;
  spc0_ldst_fp_g <= spc0_ldst_fp_m;

  if(spc0_stb_data_rptr_vld & spc0_stb_data_wptr_vld & ~spc0_stbrwctl_flush_pipe_w &
     (spc0_stb_data_rd_ptr == spc0_stb_data_wr_ptr) & spc0_lsu_st_pcx_rq_pick)
  begin
    finish_test("spc", "tso_mon: LSU stb data write and read in the same cycle", 0);
  end

   spc0_multiple_hits = (spc0_lsu_way_hit[3] + spc0_lsu_way_hit[2] + spc0_lsu_way_hit[1] + spc0_lsu_way_hit[0]);
   if(!spc0_lsu_ifu_ldst_miss_w && (spc0_multiple_hits >1) && spc0_inst_vld_w && !spc0_dctl_flush_pipe_w && !spc0_lsu_dc_tag_pe_g_unmasked_or)
     finish_test("spc", "tso_mon: LSU multiple hits ", 0);
end

wire spc0_ld_dbl      = spc0_ld_inst_vld_g &  spc0_ldst_dbl_g &  ~spc0_quad_asi_g;
wire spc0_ld_quad     = spc0_ld_inst_vld_g &  spc0_ldst_dbl_g &  spc0_quad_asi_g;
wire spc0_ld_other    = spc0_ld_inst_vld_g & ~spc0_ldst_dbl_g;

wire spc0_ld_dbl_fp   = spc0_ld_dbl        &  spc0_ldst_fp_g;
wire spc0_ld_other_fp = spc0_ld_other      &  spc0_ldst_fp_g;

wire spc0_ld_dbl_int  = spc0_ld_dbl        & ~spc0_ldst_fp_g;
wire spc0_ld_quad_int = spc0_ld_quad       & ~spc0_ldst_fp_g;
wire spc0_ld_other_int= spc0_ld_other      & ~spc0_ldst_fp_g;

wire spc0_ld_bypassok_hit = |spc0_stb_ld_full_raw[7:0] & ~spc0_stb_cam_mhit;
wire spc0_ld_partial_hit  = |spc0_stb_ld_partial_raw[7:0] & ~spc0_stb_cam_mhit;
wire spc0_ld_multiple_hit =  spc0_stb_cam_mhit;

wire spc0_any_lsu_way_hit = |spc0_lsu_way_hit;

wire [7:0] spc0_stb_rdptr_decoded = 	(spc0_stb_rdptr ==3'b000) ? 8'b00000001 :
                               		(spc0_stb_rdptr ==3'b001) ? 8'b00000010 :
                               		(spc0_stb_rdptr ==3'b010) ? 8'b00000100 :
                              		(spc0_stb_rdptr ==3'b011) ? 8'b00001000 :
                              		(spc0_stb_rdptr ==3'b100) ? 8'b00010000 :
                              		(spc0_stb_rdptr ==3'b101) ? 8'b00100000 :
                             		(spc0_stb_rdptr ==3'b110) ? 8'b01000000 :
                              		(spc0_stb_rdptr ==3'b111) ? 8'b10000000 : 8'h00;


wire spc0_stb_top_hit = |(spc0_stb_rdptr_decoded & (spc0_stb_ld_full_raw | spc0_stb_ld_partial_raw));

//---------------------------------------------------------------------
// ld_type[4:0] hit_type[2:0], cache_hit, hit_top
// this is passed to the coverage monitor.
//---------------------------------------------------------------------
wire [10:0] spc0_stb_ld_hit_info = 
	{spc0_ld_dbl_fp,        spc0_ld_other_fp,
	 spc0_ld_dbl_int, 	   spc0_ld_quad_int,    spc0_ld_other_int,
	 spc0_ld_bypassok_hit,  spc0_ld_partial_hit, spc0_ld_multiple_hit,
	 spc0_any_lsu_way_hit,
	 spc0_stb_top_hit, C0_st_ack_w};

reg spc0_mbar0_active;
reg spc0_mbar1_active;
reg spc0_mbar2_active;
reg spc0_mbar3_active;

reg spc0_flush0_active;
reg spc0_flush1_active;
reg spc0_flush2_active;
reg spc0_flush3_active;

reg spc0_intr0_active;
reg spc0_intr1_active;
reg spc0_intr2_active;
reg spc0_intr3_active;

always @(negedge clk)
begin
  if(~rst_l)
  begin
     spc0_mbar0_active <= 1'b0;
     spc0_mbar1_active <= 1'b0;
     spc0_mbar2_active <= 1'b0;
     spc0_mbar3_active <= 1'b0;

     spc0_flush0_active <= 1'b0;
     spc0_flush1_active <= 1'b0;
     spc0_flush2_active <= 1'b0;
     spc0_flush3_active <= 1'b0;

     spc0_intr0_active <= 1'b0;
     spc0_intr1_active <= 1'b0;
     spc0_intr2_active <= 1'b0;
     spc0_intr3_active <= 1'b0;

  end
  else
  begin
    if(spc0_mbar_inst0_g & ~spc0_dctl_flush_pipe_w & (C0T0_stb_ne|~spc0_no_spc_rmo_st[0]))
	spc0_mbar0_active <= 1'b1;
    else if(~C0T0_stb_ne & spc0_no_spc_rmo_st[0])
	spc0_mbar0_active <= 1'b0;
    if(spc0_mbar_inst1_g & ~ spc0_dctl_flush_pipe_w & (C0T1_stb_ne|~spc0_no_spc_rmo_st[1]))
	spc0_mbar1_active <= 1'b1;
    else if(~C0T1_stb_ne & spc0_no_spc_rmo_st[1])
	spc0_mbar1_active <= 1'b0;
    if(spc0_mbar_inst2_g & ~ spc0_dctl_flush_pipe_w & (C0T2_stb_ne|~spc0_no_spc_rmo_st[2]))
	spc0_mbar2_active <= 1'b1;
    else if(~C0T2_stb_ne & spc0_no_spc_rmo_st[2])
	spc0_mbar2_active <= 1'b0;
    if(spc0_mbar_inst3_g & ~ spc0_dctl_flush_pipe_w & (C0T3_stb_ne|~spc0_no_spc_rmo_st[3]))
	spc0_mbar3_active <= 1'b1;
    else if(~C0T3_stb_ne & spc0_no_spc_rmo_st[3])
	spc0_mbar3_active <= 1'b0;

    if(spc0_flush_inst0_g & ~spc0_dctl_flush_pipe_w & C0T0_stb_ne) 	spc0_flush0_active <= 1'b1;
    else if(~C0T0_stb_ne)			  				spc0_flush0_active <= 1'b0;
    if(spc0_flush_inst1_g & ~spc0_dctl_flush_pipe_w & C0T1_stb_ne) 	spc0_flush1_active <= 1'b1;
    else if(~C0T1_stb_ne)			  				spc0_flush1_active <= 1'b0;
    if(spc0_flush_inst2_g & ~spc0_dctl_flush_pipe_w & C0T2_stb_ne) 	spc0_flush2_active <= 1'b1;
    else if(~C0T2_stb_ne)			  				spc0_flush2_active <= 1'b0;
    if(spc0_flush_inst3_g & ~spc0_dctl_flush_pipe_w & C0T3_stb_ne) 	spc0_flush3_active <= 1'b1;
    else if(~C0T3_stb_ne)			  				spc0_flush3_active <= 1'b0;

    if(spc0_intrpt_disp_asi0_g & spc0_st_inst_vld_g & ~spc0_non_altspace_ldst_g & ~spc0_dctl_flush_pipe_w & C0T0_stb_ne)
	spc0_intr0_active <= 1'b1;
    else if(~C0T0_stb_ne)			  				
	spc0_intr0_active <= 1'b0;
    if(spc0_intrpt_disp_asi1_g &  spc0_st_inst_vld_g & ~spc0_non_altspace_ldst_g & ~spc0_dctl_flush_pipe_w & C0T1_stb_ne)
	spc0_intr1_active <= 1'b1;
    else if(~C0T1_stb_ne)
	spc0_intr1_active <= 1'b0;
    if(spc0_intrpt_disp_asi2_g &  spc0_st_inst_vld_g & ~spc0_non_altspace_ldst_g & ~spc0_dctl_flush_pipe_w & C0T2_stb_ne)
	spc0_intr2_active <= 1'b1;
    else if(~C0T2_stb_ne)
	spc0_intr2_active <= 1'b0;
    if(spc0_intrpt_disp_asi3_g &  spc0_st_inst_vld_g & ~spc0_non_altspace_ldst_g & ~spc0_dctl_flush_pipe_w & C0T3_stb_ne)
	spc0_intr3_active <= 1'b1;
    else if(~C0T3_stb_ne)
	spc0_intr3_active <= 1'b0;
  end

  if(spc0_mbar0_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "membar violation thread 0", 0);
  if(spc0_mbar1_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "membar violation thread 1", 0);
  if(spc0_mbar2_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "membar violation thread 2", 0);
  if(spc0_mbar3_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "membar violation thread 3", 0);

  if(spc0_flush0_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "flush violation thread 0", 0);
  if(spc0_flush1_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "flush violation thread 1", 0);
  if(spc0_flush2_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "flush violation thread 2", 0);
  if(spc0_flush3_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "flush violation thread 3", 0);

  if(spc0_intr0_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "intr violation thread 0", 0);
  if(spc0_intr1_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "intr violation thread 1", 0);
  if(spc0_intr2_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "intr violation thread 2", 0);
  if(spc0_intr3_active & spc0_inst_vld_w & spc0_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "intr violation thread 3", 0);

   if(~rst_l | ~C0T0_stb_full | sctag_pcx_stall_pq) 	C0T0_stb_drain_cnt = 0;
   else							C0T0_stb_drain_cnt = C0T0_stb_drain_cnt + 1;
   if(C0T0_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 0 is not draining", 0);

   if(~rst_l | ~C0T1_stb_full | sctag_pcx_stall_pq) 	C0T1_stb_drain_cnt = 0;
   else							C0T1_stb_drain_cnt = C0T1_stb_drain_cnt + 1;
   if(C0T1_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 1 is not draining", 0);

   if(~rst_l | ~C0T2_stb_full | sctag_pcx_stall_pq) 	C0T2_stb_drain_cnt = 0;
   else							C0T2_stb_drain_cnt = C0T2_stb_drain_cnt + 1;
   if(C0T2_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 2 is not draining", 0);

   if(~rst_l | ~C0T3_stb_full | sctag_pcx_stall_pq) 	C0T3_stb_drain_cnt = 0;
   else							C0T3_stb_drain_cnt = C0T3_stb_drain_cnt + 1;
   if(C0T3_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 3 is not draining", 0);

  C0T0_stb_vld_sum_d1 <= C0T0_stb_vld_sum;
  C0T1_stb_vld_sum_d1 <= C0T1_stb_vld_sum;
  C0T2_stb_vld_sum_d1 <= C0T2_stb_vld_sum;
  C0T3_stb_vld_sum_d1 <= C0T3_stb_vld_sum;
  C0T0_defr_trp_en_d1 <= C0T0_defr_trp_en;
  C0T1_defr_trp_en_d1 <= C0T1_defr_trp_en;
  C0T2_defr_trp_en_d1 <= C0T2_defr_trp_en;
  C0T3_defr_trp_en_d1 <= C0T3_defr_trp_en;

  if(rst_l & C0T0_defr_trp_en_d1 & (C0T0_stb_vld_sum_d1 < C0T0_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T0", 0);
  if(rst_l & C0T1_defr_trp_en_d1 & (C0T1_stb_vld_sum_d1 < C0T1_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T1", 0);
  if(rst_l & C0T2_defr_trp_en_d1 & (C0T2_stb_vld_sum_d1 < C0T2_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T2", 0);
  if(rst_l & C0T3_defr_trp_en_d1 & (C0T3_stb_vld_sum_d1 < C0T3_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T3", 0);
 
end

`endif // ifdef RTL_SPARC0
`ifdef RTL_SPARC1
wire   C1T0_stb_ne    = |`TOP_DESIGN.sparc1.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C1T1_stb_ne    = |`TOP_DESIGN.sparc1.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C1T2_stb_ne    = |`TOP_DESIGN.sparc1.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C1T3_stb_ne    = |`TOP_DESIGN.sparc1.lsu.stb_ctl3.stb_state_vld[7:0];

wire   C1T0_stb_nced  = |(	 `TOP_DESIGN.sparc1.lsu.stb_ctl0.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc1.lsu.stb_ctl0.stb_state_ced[7:0]);
wire   C1T1_stb_nced  = |(	 `TOP_DESIGN.sparc1.lsu.stb_ctl1.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc1.lsu.stb_ctl1.stb_state_ced[7:0]);
wire   C1T2_stb_nced  = |(	 `TOP_DESIGN.sparc1.lsu.stb_ctl2.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc1.lsu.stb_ctl2.stb_state_ced[7:0]);
wire   C1T3_stb_nced  = |(	 `TOP_DESIGN.sparc1.lsu.stb_ctl3.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc1.lsu.stb_ctl3.stb_state_ced[7:0]);

`else
wire   C1T0_stb_ne    = 1'b0;
wire   C1T1_stb_ne    = 1'b0;
wire   C1T2_stb_ne    = 1'b0;
wire   C1T3_stb_ne    = 1'b0;

wire   C1T0_stb_nced  = 1'b0;
wire   C1T1_stb_nced  = 1'b0;
wire   C1T2_stb_nced  = 1'b0;
wire   C1T3_stb_nced  = 1'b0;
`endif // ifdef RTL_SPARC1

`ifdef RTL_SPARC1

wire   spc1_lsu_ifill_pkt_vld	= `TOP_DESIGN.sparc1.lsu.qctl2.lsu_ifill_pkt_vld;
wire   spc1_dfq_rd_advance  		= `TOP_DESIGN.sparc1.lsu.qctl2.dfq_rd_advance;
wire   spc1_dfq_int_type  		= `TOP_DESIGN.sparc1.lsu.qctl2.dfq_int_type;

wire   spc1_ifu_lsu_inv_clear	= `TOP_DESIGN.sparc1.lsu.qctl2.ifu_lsu_inv_clear;

wire 	    spc1_dva_svld_e 	 	= `TOP_DESIGN.sparc1.lsu.qctl2.dva_svld_e;
wire 	    spc1_dva_rvld_e	 	= `TOP_DESIGN.sparc1.lsu.dva.rd_en;
wire [10:4] spc1_dva_rd_addr_e  	= `TOP_DESIGN.sparc1.lsu.dva.rd_adr1[6:0];
wire [4:0]  spc1_dva_snp_addr_e 	= `TOP_DESIGN.sparc1.lsu.qctl2.dva_snp_addr_e[4:0];

wire [4:0]  spc1_stb_data_rd_ptr   	= `TOP_DESIGN.sparc1.lsu.stb_data_rd_ptr[4:0];
wire [4:0]  spc1_stb_data_wr_ptr   	= `TOP_DESIGN.sparc1.lsu.stb_data_wr_ptr[4:0];
wire        spc1_stb_data_wptr_vld 	= `TOP_DESIGN.sparc1.lsu.stb_data_wptr_vld;
wire        spc1_stb_data_rptr_vld 	= `TOP_DESIGN.sparc1.lsu.stb_data_rptr_vld;
wire        spc1_stbrwctl_flush_pipe_w = `TOP_DESIGN.sparc1.lsu.stb_rwctl.lsu_stbrwctl_flush_pipe_w;
wire        spc1_lsu_st_pcx_rq_pick 	= |`TOP_DESIGN.sparc1.lsu.stb_rwctl.lsu_st_pcx_rq_pick[3:0];

wire [3:0]  spc1_lsu_rd_dtag_parity_g = `TOP_DESIGN.sparc1.lsu.dctl.lsu_rd_dtag_parity_g[3:0];
wire [3:0]  spc1_dva_vld_g		 = `TOP_DESIGN.sparc1.lsu.dctl.dva_vld_g[3:0];

wire [3:0]  spc1_lsu_dc_tag_pe_g_unmasked    = spc1_lsu_rd_dtag_parity_g[3:0] & spc1_dva_vld_g[3:0];
wire        spc1_lsu_dc_tag_pe_g_unmasked_or = |spc1_lsu_dc_tag_pe_g_unmasked[3:0];

wire   C1T0_stb_full  = &`TOP_DESIGN.sparc1.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C1T1_stb_full  = &`TOP_DESIGN.sparc1.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C1T2_stb_full  = &`TOP_DESIGN.sparc1.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C1T3_stb_full  = &`TOP_DESIGN.sparc1.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [7:0] C1T0_stb_vld  = `TOP_DESIGN.sparc1.lsu.stb_ctl0.stb_state_vld[7:0];
wire   [7:0] C1T1_stb_vld  = `TOP_DESIGN.sparc1.lsu.stb_ctl1.stb_state_vld[7:0];
wire   [7:0] C1T2_stb_vld  = `TOP_DESIGN.sparc1.lsu.stb_ctl2.stb_state_vld[7:0];
wire   [7:0] C1T3_stb_vld  = `TOP_DESIGN.sparc1.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [4:0] C1T0_stb_vld_sum  =  C1T0_stb_vld[0] +  C1T0_stb_vld[1] +  C1T0_stb_vld[2] +  C1T0_stb_vld[3] +
                                     C1T0_stb_vld[4] +  C1T0_stb_vld[5] +  C1T0_stb_vld[6] +  C1T0_stb_vld[7] ;
wire   [4:0] C1T1_stb_vld_sum  =  C1T1_stb_vld[0] +  C1T1_stb_vld[1] +  C1T1_stb_vld[2] +  C1T1_stb_vld[3] +
                                     C1T1_stb_vld[4] +  C1T1_stb_vld[5] +  C1T1_stb_vld[6] +  C1T1_stb_vld[7] ;
wire   [4:0] C1T2_stb_vld_sum  =  C1T2_stb_vld[0] +  C1T2_stb_vld[1] +  C1T2_stb_vld[2] +  C1T2_stb_vld[3] +
                                     C1T2_stb_vld[4] +  C1T2_stb_vld[5] +  C1T2_stb_vld[6] +  C1T2_stb_vld[7] ;
wire   [4:0] C1T3_stb_vld_sum  =  C1T3_stb_vld[0] +  C1T3_stb_vld[1] +  C1T3_stb_vld[2] +  C1T3_stb_vld[3] +
                                     C1T3_stb_vld[4] +  C1T3_stb_vld[5] +  C1T3_stb_vld[6] +  C1T3_stb_vld[7] ;

reg [4:0] C1T0_stb_vld_sum_d1;
reg [4:0] C1T1_stb_vld_sum_d1;
reg [4:0] C1T2_stb_vld_sum_d1;
reg [4:0] C1T3_stb_vld_sum_d1;

wire   C1T0_st_ack  = &`TOP_DESIGN.sparc1.lsu.cpx_st_ack_tid0;
wire   C1T1_st_ack  = &`TOP_DESIGN.sparc1.lsu.cpx_st_ack_tid1;
wire   C1T2_st_ack  = &`TOP_DESIGN.sparc1.lsu.cpx_st_ack_tid2;
wire   C1T3_st_ack  = &`TOP_DESIGN.sparc1.lsu.cpx_st_ack_tid3;

wire   C1T0_defr_trp_en	= &`TOP_DESIGN.sparc1.lsu.excpctl.st_defr_trp_en0;
wire   C1T1_defr_trp_en	= &`TOP_DESIGN.sparc1.lsu.excpctl.st_defr_trp_en1;
wire   C1T2_defr_trp_en	= &`TOP_DESIGN.sparc1.lsu.excpctl.st_defr_trp_en2;
wire   C1T3_defr_trp_en	= &`TOP_DESIGN.sparc1.lsu.excpctl.st_defr_trp_en3;

reg C1T0_defr_trp_en_d1;
reg C1T1_defr_trp_en_d1;
reg C1T2_defr_trp_en_d1;
reg C1T3_defr_trp_en_d1;

integer C1T0_stb_drain_cnt;
integer C1T1_stb_drain_cnt;
integer C1T2_stb_drain_cnt;
integer C1T3_stb_drain_cnt;

// Hits in the store buffer
//-------------------------
wire       spc1_inst_vld_w		= `TOP_DESIGN.sparc1.ifu.fcl.inst_vld_w;
wire [1:0] spc1_sas_thrid_w		= `TOP_DESIGN.sparc1.ifu.fcl.sas_thrid_w[1:0];

wire C1_st_ack_w = (spc1_sas_thrid_w == 2'b00) & C1T0_st_ack |
                      (spc1_sas_thrid_w == 2'b01) & C1T1_st_ack |
                      (spc1_sas_thrid_w == 2'b10) & C1T2_st_ack |
                      (spc1_sas_thrid_w == 2'b11) & C1T3_st_ack;

wire [7:0] spc1_stb_ld_full_raw	= `TOP_DESIGN.sparc1.lsu.stb_ld_full_raw[7:0];
wire [7:0] spc1_stb_ld_partial_raw	= `TOP_DESIGN.sparc1.lsu.stb_ld_partial_raw[7:0];
wire       spc1_stb_cam_mhit		= `TOP_DESIGN.sparc1.lsu.stb_cam_mhit;
wire       spc1_stb_cam_hit		= `TOP_DESIGN.sparc1.lsu.stb_cam_hit;
wire [3:0] spc1_lsu_way_hit		= `TOP_DESIGN.sparc1.lsu.dctl.lsu_way_hit[3:0];
wire       spc1_lsu_ifu_ldst_miss_w	= `TOP_DESIGN.sparc1.lsu.lsu_ifu_ldst_miss_w;
wire       spc1_ld_inst_vld_g	= `TOP_DESIGN.sparc1.lsu.dctl.ld_inst_vld_g;
wire       spc1_ldst_dbl_g		= `TOP_DESIGN.sparc1.lsu.dctl.ldst_dbl_g;
wire       spc1_quad_asi_g		= `TOP_DESIGN.sparc1.lsu.dctl.quad_asi_g;
wire [1:0] spc1_ldst_sz_g		= `TOP_DESIGN.sparc1.lsu.dctl.ldst_sz_g;
wire       spc1_lsu_alt_space_g	= `TOP_DESIGN.sparc1.lsu.dctl.lsu_alt_space_g;

wire       spc1_mbar_inst0_g		= `TOP_DESIGN.sparc1.lsu.dctl.mbar_inst0_g;
wire       spc1_mbar_inst1_g		= `TOP_DESIGN.sparc1.lsu.dctl.mbar_inst1_g;
wire       spc1_mbar_inst2_g		= `TOP_DESIGN.sparc1.lsu.dctl.mbar_inst2_g;
wire       spc1_mbar_inst3_g		= `TOP_DESIGN.sparc1.lsu.dctl.mbar_inst3_g;

wire       spc1_flush_inst0_g	= `TOP_DESIGN.sparc1.lsu.dctl.flush_inst0_g;
wire       spc1_flush_inst1_g	= `TOP_DESIGN.sparc1.lsu.dctl.flush_inst1_g;
wire       spc1_flush_inst2_g	= `TOP_DESIGN.sparc1.lsu.dctl.flush_inst2_g;
wire       spc1_flush_inst3_g	= `TOP_DESIGN.sparc1.lsu.dctl.flush_inst3_g;

wire       spc1_intrpt_disp_asi0_g	= `TOP_DESIGN.sparc1.lsu.dctl.intrpt_disp_asi_g & (spc1_sas_thrid_w == 2'b00);
wire       spc1_intrpt_disp_asi1_g	= `TOP_DESIGN.sparc1.lsu.dctl.intrpt_disp_asi_g & (spc1_sas_thrid_w == 2'b01);
wire       spc1_intrpt_disp_asi2_g	= `TOP_DESIGN.sparc1.lsu.dctl.intrpt_disp_asi_g & (spc1_sas_thrid_w == 2'b10);
wire       spc1_intrpt_disp_asi3_g	= `TOP_DESIGN.sparc1.lsu.dctl.intrpt_disp_asi_g & (spc1_sas_thrid_w == 2'b11);

wire       spc1_st_inst_vld_g	= `TOP_DESIGN.sparc1.lsu.dctl.st_inst_vld_g;
wire       spc1_non_altspace_ldst_g	= `TOP_DESIGN.sparc1.lsu.dctl.non_altspace_ldst_g;

wire       spc1_dctl_flush_pipe_w	= `TOP_DESIGN.sparc1.lsu.dctl.dctl_flush_pipe_w;

wire [3:0] spc1_no_spc_rmo_st	= `TOP_DESIGN.sparc1.lsu.dctl.no_spc_rmo_st[3:0];


wire       spc1_ldst_fp_e		= `TOP_DESIGN.sparc1.lsu.ifu_lsu_ldst_fp_e;
wire [2:0] spc1_stb_rdptr		= `TOP_DESIGN.sparc1.lsu.stb_rwctl.stb_rdptr_l;

wire 	   spc1_ld_l2cache_req 	= `TOP_DESIGN.sparc1.lsu.qctl1.ld3_l2cache_rq |
					  `TOP_DESIGN.sparc1.lsu.qctl1.ld2_l2cache_rq |
                 			  `TOP_DESIGN.sparc1.lsu.qctl1.ld1_l2cache_rq |
					  `TOP_DESIGN.sparc1.lsu.qctl1.ld0_l2cache_rq;

wire [3:0] spc1_dcache_enable	= {`TOP_DESIGN.sparc1.lsu.dctl.lsu_ctl_reg0[1],
                                    	   `TOP_DESIGN.sparc1.lsu.dctl.lsu_ctl_reg1[1],
					   `TOP_DESIGN.sparc1.lsu.dctl.lsu_ctl_reg2[1],
					   `TOP_DESIGN.sparc1.lsu.dctl.lsu_ctl_reg3[1]};

wire [3:0] spc1_icache_enable	= `TOP_DESIGN.sparc1.lsu.lsu_ifu_icache_en[3:0];

wire spc1_dc_direct_map 		= `TOP_DESIGN.sparc1.lsu.dc_direct_map;
wire spc1_lsu_ifu_direct_map_l1	= `TOP_DESIGN.sparc1.lsu.lsu_ifu_direct_map_l1;

always @(spc1_dcache_enable)
    $display("%0d tso_mon: spc1_dcache_enable changed to %x", $time, spc1_dcache_enable);

always @(spc1_icache_enable)
    $display("%0d tso_mon: spc1_icache_enable changed to %x", $time, spc1_icache_enable);

always @(spc1_dc_direct_map)
    $display("%0d tso_mon: spc1_dc_direct_map changed to %x", $time, spc1_dc_direct_map);

always @(spc1_lsu_ifu_direct_map_l1)
   $display("%0d tso_mon: spc1_lsu_ifu_direct_map_l1 changed to %x", $time, spc1_lsu_ifu_direct_map_l1);

reg 		spc1_dva_svld_e_d1;
reg 		spc1_dva_rvld_e_d1;
reg [10:4] 	spc1_dva_rd_addr_e_d1;
reg [4:0]  	spc1_dva_snp_addr_e_d1;

reg   		spc1_lsu_snp_after_rd;
reg   		spc1_lsu_rd_after_snp;

reg 	   	spc1_ldst_fp_m, spc1_ldst_fp_g;

integer 	spc1_multiple_hits;

reg spc1_skid_d1, spc1_skid_d2, spc1_skid_d3;
initial begin
  spc1_skid_d1 = 0;
  spc1_skid_d2 = 0;
  spc1_skid_d3 = 0;
end

always @(posedge clk)
begin

  spc1_skid_d1 <= (~spc1_ifu_lsu_inv_clear & spc1_dfq_rd_advance & spc1_dfq_int_type);
  spc1_skid_d2 <= spc1_skid_d1 & ~spc1_ifu_lsu_inv_clear;
  spc1_skid_d3 <= spc1_skid_d2 & ~spc1_ifu_lsu_inv_clear;

// The full tracking of this condition is complicated since after the interrupt is advanced
// there may be more invalidations to the IFQ.
// All we care about is that the invalidations BEFORE the interrupt are finished.
// I provided a command line argument to disable this check.
  if(spc1_skid_d3 & enable_ifu_lsu_inv_clear)
     finish_test("spc", "tso_mon:   spc1_ifu_lsu_inv_clear should have been clear by now", 1);

  spc1_dva_svld_e_d1 	<= spc1_dva_svld_e;
  spc1_dva_rvld_e_d1 	<= spc1_dva_rvld_e;
  spc1_dva_rd_addr_e_d1 	<= spc1_dva_rd_addr_e;
  spc1_dva_snp_addr_e_d1 	<= spc1_dva_snp_addr_e;

  if(spc1_dva_svld_e_d1 & spc1_dva_rvld_e & (spc1_dva_rd_addr_e_d1[10:6] == spc1_dva_snp_addr_e[4:0]))
    spc1_lsu_rd_after_snp <= 1'b1;
  else 
    spc1_lsu_rd_after_snp <= 1'b0;

  if(spc1_dva_svld_e & spc1_dva_rvld_e_d1 & (spc1_dva_rd_addr_e[10:6] == spc1_dva_snp_addr_e_d1[4:0]))
    spc1_lsu_snp_after_rd <= 1'b1;
  else 
    spc1_lsu_snp_after_rd <= 1'b0;

  spc1_ldst_fp_m <= spc1_ldst_fp_e;
  spc1_ldst_fp_g <= spc1_ldst_fp_m;

  if(spc1_stb_data_rptr_vld & spc1_stb_data_wptr_vld & ~spc1_stbrwctl_flush_pipe_w &
     (spc1_stb_data_rd_ptr == spc1_stb_data_wr_ptr) & spc1_lsu_st_pcx_rq_pick)
  begin
    finish_test("spc", "tso_mon: LSU stb data write and read in the same cycle", 1);
  end

   spc1_multiple_hits = (spc1_lsu_way_hit[3] + spc1_lsu_way_hit[2] + spc1_lsu_way_hit[1] + spc1_lsu_way_hit[0]);
   if(!spc1_lsu_ifu_ldst_miss_w && (spc1_multiple_hits >1) && spc1_inst_vld_w && !spc1_dctl_flush_pipe_w && !spc1_lsu_dc_tag_pe_g_unmasked_or)
     finish_test("spc", "tso_mon: LSU multiple hits ", 1);
end

wire spc1_ld_dbl      = spc1_ld_inst_vld_g &  spc1_ldst_dbl_g &  ~spc1_quad_asi_g;
wire spc1_ld_quad     = spc1_ld_inst_vld_g &  spc1_ldst_dbl_g &  spc1_quad_asi_g;
wire spc1_ld_other    = spc1_ld_inst_vld_g & ~spc1_ldst_dbl_g;

wire spc1_ld_dbl_fp   = spc1_ld_dbl        &  spc1_ldst_fp_g;
wire spc1_ld_other_fp = spc1_ld_other      &  spc1_ldst_fp_g;

wire spc1_ld_dbl_int  = spc1_ld_dbl        & ~spc1_ldst_fp_g;
wire spc1_ld_quad_int = spc1_ld_quad       & ~spc1_ldst_fp_g;
wire spc1_ld_other_int= spc1_ld_other      & ~spc1_ldst_fp_g;

wire spc1_ld_bypassok_hit = |spc1_stb_ld_full_raw[7:0] & ~spc1_stb_cam_mhit;
wire spc1_ld_partial_hit  = |spc1_stb_ld_partial_raw[7:0] & ~spc1_stb_cam_mhit;
wire spc1_ld_multiple_hit =  spc1_stb_cam_mhit;

wire spc1_any_lsu_way_hit = |spc1_lsu_way_hit;

wire [7:0] spc1_stb_rdptr_decoded = 	(spc1_stb_rdptr ==3'b000) ? 8'b00000001 :
                               		(spc1_stb_rdptr ==3'b001) ? 8'b00000010 :
                               		(spc1_stb_rdptr ==3'b010) ? 8'b00000100 :
                              		(spc1_stb_rdptr ==3'b011) ? 8'b00001000 :
                              		(spc1_stb_rdptr ==3'b100) ? 8'b00010000 :
                              		(spc1_stb_rdptr ==3'b101) ? 8'b00100000 :
                             		(spc1_stb_rdptr ==3'b110) ? 8'b01000000 :
                              		(spc1_stb_rdptr ==3'b111) ? 8'b10000000 : 8'h00;


wire spc1_stb_top_hit = |(spc1_stb_rdptr_decoded & (spc1_stb_ld_full_raw | spc1_stb_ld_partial_raw));

//---------------------------------------------------------------------
// ld_type[4:0] hit_type[2:0], cache_hit, hit_top
// this is passed to the coverage monitor.
//---------------------------------------------------------------------
wire [10:0] spc1_stb_ld_hit_info = 
	{spc1_ld_dbl_fp,        spc1_ld_other_fp,
	 spc1_ld_dbl_int, 	   spc1_ld_quad_int,    spc1_ld_other_int,
	 spc1_ld_bypassok_hit,  spc1_ld_partial_hit, spc1_ld_multiple_hit,
	 spc1_any_lsu_way_hit,
	 spc1_stb_top_hit, C1_st_ack_w};

reg spc1_mbar0_active;
reg spc1_mbar1_active;
reg spc1_mbar2_active;
reg spc1_mbar3_active;

reg spc1_flush0_active;
reg spc1_flush1_active;
reg spc1_flush2_active;
reg spc1_flush3_active;

reg spc1_intr0_active;
reg spc1_intr1_active;
reg spc1_intr2_active;
reg spc1_intr3_active;

always @(negedge clk)
begin
  if(~rst_l)
  begin
     spc1_mbar0_active <= 1'b0;
     spc1_mbar1_active <= 1'b0;
     spc1_mbar2_active <= 1'b0;
     spc1_mbar3_active <= 1'b0;

     spc1_flush0_active <= 1'b0;
     spc1_flush1_active <= 1'b0;
     spc1_flush2_active <= 1'b0;
     spc1_flush3_active <= 1'b0;

     spc1_intr0_active <= 1'b0;
     spc1_intr1_active <= 1'b0;
     spc1_intr2_active <= 1'b0;
     spc1_intr3_active <= 1'b0;

  end
  else
  begin
    if(spc1_mbar_inst0_g & ~spc1_dctl_flush_pipe_w & (C1T0_stb_ne|~spc1_no_spc_rmo_st[0]))
	spc1_mbar0_active <= 1'b1;
    else if(~C1T0_stb_ne & spc1_no_spc_rmo_st[0])
	spc1_mbar0_active <= 1'b0;
    if(spc1_mbar_inst1_g & ~ spc1_dctl_flush_pipe_w & (C1T1_stb_ne|~spc1_no_spc_rmo_st[1]))
	spc1_mbar1_active <= 1'b1;
    else if(~C1T1_stb_ne & spc1_no_spc_rmo_st[1])
	spc1_mbar1_active <= 1'b0;
    if(spc1_mbar_inst2_g & ~ spc1_dctl_flush_pipe_w & (C1T2_stb_ne|~spc1_no_spc_rmo_st[2]))
	spc1_mbar2_active <= 1'b1;
    else if(~C1T2_stb_ne & spc1_no_spc_rmo_st[2])
	spc1_mbar2_active <= 1'b0;
    if(spc1_mbar_inst3_g & ~ spc1_dctl_flush_pipe_w & (C1T3_stb_ne|~spc1_no_spc_rmo_st[3]))
	spc1_mbar3_active <= 1'b1;
    else if(~C1T3_stb_ne & spc1_no_spc_rmo_st[3])
	spc1_mbar3_active <= 1'b0;

    if(spc1_flush_inst0_g & ~spc1_dctl_flush_pipe_w & C1T0_stb_ne) 	spc1_flush0_active <= 1'b1;
    else if(~C1T0_stb_ne)			  				spc1_flush0_active <= 1'b0;
    if(spc1_flush_inst1_g & ~spc1_dctl_flush_pipe_w & C1T1_stb_ne) 	spc1_flush1_active <= 1'b1;
    else if(~C1T1_stb_ne)			  				spc1_flush1_active <= 1'b0;
    if(spc1_flush_inst2_g & ~spc1_dctl_flush_pipe_w & C1T2_stb_ne) 	spc1_flush2_active <= 1'b1;
    else if(~C1T2_stb_ne)			  				spc1_flush2_active <= 1'b0;
    if(spc1_flush_inst3_g & ~spc1_dctl_flush_pipe_w & C1T3_stb_ne) 	spc1_flush3_active <= 1'b1;
    else if(~C1T3_stb_ne)			  				spc1_flush3_active <= 1'b0;

    if(spc1_intrpt_disp_asi0_g & spc1_st_inst_vld_g & ~spc1_non_altspace_ldst_g & ~spc1_dctl_flush_pipe_w & C1T0_stb_ne)
	spc1_intr0_active <= 1'b1;
    else if(~C1T0_stb_ne)			  				
	spc1_intr0_active <= 1'b0;
    if(spc1_intrpt_disp_asi1_g &  spc1_st_inst_vld_g & ~spc1_non_altspace_ldst_g & ~spc1_dctl_flush_pipe_w & C1T1_stb_ne)
	spc1_intr1_active <= 1'b1;
    else if(~C1T1_stb_ne)
	spc1_intr1_active <= 1'b0;
    if(spc1_intrpt_disp_asi2_g &  spc1_st_inst_vld_g & ~spc1_non_altspace_ldst_g & ~spc1_dctl_flush_pipe_w & C1T2_stb_ne)
	spc1_intr2_active <= 1'b1;
    else if(~C1T2_stb_ne)
	spc1_intr2_active <= 1'b0;
    if(spc1_intrpt_disp_asi3_g &  spc1_st_inst_vld_g & ~spc1_non_altspace_ldst_g & ~spc1_dctl_flush_pipe_w & C1T3_stb_ne)
	spc1_intr3_active <= 1'b1;
    else if(~C1T3_stb_ne)
	spc1_intr3_active <= 1'b0;
  end

  if(spc1_mbar0_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "membar violation thread 0", 1);
  if(spc1_mbar1_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "membar violation thread 1", 1);
  if(spc1_mbar2_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "membar violation thread 2", 1);
  if(spc1_mbar3_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "membar violation thread 3", 1);

  if(spc1_flush0_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "flush violation thread 0", 1);
  if(spc1_flush1_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "flush violation thread 1", 1);
  if(spc1_flush2_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "flush violation thread 2", 1);
  if(spc1_flush3_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "flush violation thread 3", 1);

  if(spc1_intr0_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "intr violation thread 0", 1);
  if(spc1_intr1_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "intr violation thread 1", 1);
  if(spc1_intr2_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "intr violation thread 2", 1);
  if(spc1_intr3_active & spc1_inst_vld_w & spc1_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "intr violation thread 3", 1);

   if(~rst_l | ~C1T0_stb_full | sctag_pcx_stall_pq) 	C1T0_stb_drain_cnt = 0;
   else							C1T0_stb_drain_cnt = C1T0_stb_drain_cnt + 1;
   if(C1T0_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 0 is not draining", 1);

   if(~rst_l | ~C1T1_stb_full | sctag_pcx_stall_pq) 	C1T1_stb_drain_cnt = 0;
   else							C1T1_stb_drain_cnt = C1T1_stb_drain_cnt + 1;
   if(C1T1_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 1 is not draining", 1);

   if(~rst_l | ~C1T2_stb_full | sctag_pcx_stall_pq) 	C1T2_stb_drain_cnt = 0;
   else							C1T2_stb_drain_cnt = C1T2_stb_drain_cnt + 1;
   if(C1T2_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 2 is not draining", 1);

   if(~rst_l | ~C1T3_stb_full | sctag_pcx_stall_pq) 	C1T3_stb_drain_cnt = 0;
   else							C1T3_stb_drain_cnt = C1T3_stb_drain_cnt + 1;
   if(C1T3_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 3 is not draining", 1);

  C1T0_stb_vld_sum_d1 <= C1T0_stb_vld_sum;
  C1T1_stb_vld_sum_d1 <= C1T1_stb_vld_sum;
  C1T2_stb_vld_sum_d1 <= C1T2_stb_vld_sum;
  C1T3_stb_vld_sum_d1 <= C1T3_stb_vld_sum;
  C1T0_defr_trp_en_d1 <= C1T0_defr_trp_en;
  C1T1_defr_trp_en_d1 <= C1T1_defr_trp_en;
  C1T2_defr_trp_en_d1 <= C1T2_defr_trp_en;
  C1T3_defr_trp_en_d1 <= C1T3_defr_trp_en;

  if(rst_l & C1T0_defr_trp_en_d1 & (C1T0_stb_vld_sum_d1 < C1T0_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T0", 1);
  if(rst_l & C1T1_defr_trp_en_d1 & (C1T1_stb_vld_sum_d1 < C1T1_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T1", 1);
  if(rst_l & C1T2_defr_trp_en_d1 & (C1T2_stb_vld_sum_d1 < C1T2_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T2", 1);
  if(rst_l & C1T3_defr_trp_en_d1 & (C1T3_stb_vld_sum_d1 < C1T3_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T3", 1);
 
end

`endif // ifdef RTL_SPARC1
`ifdef RTL_SPARC2
wire   C2T0_stb_ne    = |`TOP_DESIGN.sparc2.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C2T1_stb_ne    = |`TOP_DESIGN.sparc2.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C2T2_stb_ne    = |`TOP_DESIGN.sparc2.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C2T3_stb_ne    = |`TOP_DESIGN.sparc2.lsu.stb_ctl3.stb_state_vld[7:0];

wire   C2T0_stb_nced  = |(	 `TOP_DESIGN.sparc2.lsu.stb_ctl0.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc2.lsu.stb_ctl0.stb_state_ced[7:0]);
wire   C2T1_stb_nced  = |(	 `TOP_DESIGN.sparc2.lsu.stb_ctl1.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc2.lsu.stb_ctl1.stb_state_ced[7:0]);
wire   C2T2_stb_nced  = |(	 `TOP_DESIGN.sparc2.lsu.stb_ctl2.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc2.lsu.stb_ctl2.stb_state_ced[7:0]);
wire   C2T3_stb_nced  = |(	 `TOP_DESIGN.sparc2.lsu.stb_ctl3.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc2.lsu.stb_ctl3.stb_state_ced[7:0]);

`else
wire   C2T0_stb_ne    = 1'b0;
wire   C2T1_stb_ne    = 1'b0;
wire   C2T2_stb_ne    = 1'b0;
wire   C2T3_stb_ne    = 1'b0;

wire   C2T0_stb_nced  = 1'b0;
wire   C2T1_stb_nced  = 1'b0;
wire   C2T2_stb_nced  = 1'b0;
wire   C2T3_stb_nced  = 1'b0;
`endif // ifdef RTL_SPARC2

`ifdef RTL_SPARC2

wire   spc2_lsu_ifill_pkt_vld	= `TOP_DESIGN.sparc2.lsu.qctl2.lsu_ifill_pkt_vld;
wire   spc2_dfq_rd_advance  		= `TOP_DESIGN.sparc2.lsu.qctl2.dfq_rd_advance;
wire   spc2_dfq_int_type  		= `TOP_DESIGN.sparc2.lsu.qctl2.dfq_int_type;

wire   spc2_ifu_lsu_inv_clear	= `TOP_DESIGN.sparc2.lsu.qctl2.ifu_lsu_inv_clear;

wire 	    spc2_dva_svld_e 	 	= `TOP_DESIGN.sparc2.lsu.qctl2.dva_svld_e;
wire 	    spc2_dva_rvld_e	 	= `TOP_DESIGN.sparc2.lsu.dva.rd_en;
wire [10:4] spc2_dva_rd_addr_e  	= `TOP_DESIGN.sparc2.lsu.dva.rd_adr1[6:0];
wire [4:0]  spc2_dva_snp_addr_e 	= `TOP_DESIGN.sparc2.lsu.qctl2.dva_snp_addr_e[4:0];

wire [4:0]  spc2_stb_data_rd_ptr   	= `TOP_DESIGN.sparc2.lsu.stb_data_rd_ptr[4:0];
wire [4:0]  spc2_stb_data_wr_ptr   	= `TOP_DESIGN.sparc2.lsu.stb_data_wr_ptr[4:0];
wire        spc2_stb_data_wptr_vld 	= `TOP_DESIGN.sparc2.lsu.stb_data_wptr_vld;
wire        spc2_stb_data_rptr_vld 	= `TOP_DESIGN.sparc2.lsu.stb_data_rptr_vld;
wire        spc2_stbrwctl_flush_pipe_w = `TOP_DESIGN.sparc2.lsu.stb_rwctl.lsu_stbrwctl_flush_pipe_w;
wire        spc2_lsu_st_pcx_rq_pick 	= |`TOP_DESIGN.sparc2.lsu.stb_rwctl.lsu_st_pcx_rq_pick[3:0];

wire [3:0]  spc2_lsu_rd_dtag_parity_g = `TOP_DESIGN.sparc2.lsu.dctl.lsu_rd_dtag_parity_g[3:0];
wire [3:0]  spc2_dva_vld_g		 = `TOP_DESIGN.sparc2.lsu.dctl.dva_vld_g[3:0];

wire [3:0]  spc2_lsu_dc_tag_pe_g_unmasked    = spc2_lsu_rd_dtag_parity_g[3:0] & spc2_dva_vld_g[3:0];
wire        spc2_lsu_dc_tag_pe_g_unmasked_or = |spc2_lsu_dc_tag_pe_g_unmasked[3:0];

wire   C2T0_stb_full  = &`TOP_DESIGN.sparc2.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C2T1_stb_full  = &`TOP_DESIGN.sparc2.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C2T2_stb_full  = &`TOP_DESIGN.sparc2.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C2T3_stb_full  = &`TOP_DESIGN.sparc2.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [7:0] C2T0_stb_vld  = `TOP_DESIGN.sparc2.lsu.stb_ctl0.stb_state_vld[7:0];
wire   [7:0] C2T1_stb_vld  = `TOP_DESIGN.sparc2.lsu.stb_ctl1.stb_state_vld[7:0];
wire   [7:0] C2T2_stb_vld  = `TOP_DESIGN.sparc2.lsu.stb_ctl2.stb_state_vld[7:0];
wire   [7:0] C2T3_stb_vld  = `TOP_DESIGN.sparc2.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [4:0] C2T0_stb_vld_sum  =  C2T0_stb_vld[0] +  C2T0_stb_vld[1] +  C2T0_stb_vld[2] +  C2T0_stb_vld[3] +
                                     C2T0_stb_vld[4] +  C2T0_stb_vld[5] +  C2T0_stb_vld[6] +  C2T0_stb_vld[7] ;
wire   [4:0] C2T1_stb_vld_sum  =  C2T1_stb_vld[0] +  C2T1_stb_vld[1] +  C2T1_stb_vld[2] +  C2T1_stb_vld[3] +
                                     C2T1_stb_vld[4] +  C2T1_stb_vld[5] +  C2T1_stb_vld[6] +  C2T1_stb_vld[7] ;
wire   [4:0] C2T2_stb_vld_sum  =  C2T2_stb_vld[0] +  C2T2_stb_vld[1] +  C2T2_stb_vld[2] +  C2T2_stb_vld[3] +
                                     C2T2_stb_vld[4] +  C2T2_stb_vld[5] +  C2T2_stb_vld[6] +  C2T2_stb_vld[7] ;
wire   [4:0] C2T3_stb_vld_sum  =  C2T3_stb_vld[0] +  C2T3_stb_vld[1] +  C2T3_stb_vld[2] +  C2T3_stb_vld[3] +
                                     C2T3_stb_vld[4] +  C2T3_stb_vld[5] +  C2T3_stb_vld[6] +  C2T3_stb_vld[7] ;

reg [4:0] C2T0_stb_vld_sum_d1;
reg [4:0] C2T1_stb_vld_sum_d1;
reg [4:0] C2T2_stb_vld_sum_d1;
reg [4:0] C2T3_stb_vld_sum_d1;

wire   C2T0_st_ack  = &`TOP_DESIGN.sparc2.lsu.cpx_st_ack_tid0;
wire   C2T1_st_ack  = &`TOP_DESIGN.sparc2.lsu.cpx_st_ack_tid1;
wire   C2T2_st_ack  = &`TOP_DESIGN.sparc2.lsu.cpx_st_ack_tid2;
wire   C2T3_st_ack  = &`TOP_DESIGN.sparc2.lsu.cpx_st_ack_tid3;

wire   C2T0_defr_trp_en	= &`TOP_DESIGN.sparc2.lsu.excpctl.st_defr_trp_en0;
wire   C2T1_defr_trp_en	= &`TOP_DESIGN.sparc2.lsu.excpctl.st_defr_trp_en1;
wire   C2T2_defr_trp_en	= &`TOP_DESIGN.sparc2.lsu.excpctl.st_defr_trp_en2;
wire   C2T3_defr_trp_en	= &`TOP_DESIGN.sparc2.lsu.excpctl.st_defr_trp_en3;

reg C2T0_defr_trp_en_d1;
reg C2T1_defr_trp_en_d1;
reg C2T2_defr_trp_en_d1;
reg C2T3_defr_trp_en_d1;

integer C2T0_stb_drain_cnt;
integer C2T1_stb_drain_cnt;
integer C2T2_stb_drain_cnt;
integer C2T3_stb_drain_cnt;

// Hits in the store buffer
//-------------------------
wire       spc2_inst_vld_w		= `TOP_DESIGN.sparc2.ifu.fcl.inst_vld_w;
wire [1:0] spc2_sas_thrid_w		= `TOP_DESIGN.sparc2.ifu.fcl.sas_thrid_w[1:0];

wire C2_st_ack_w = (spc2_sas_thrid_w == 2'b00) & C2T0_st_ack |
                      (spc2_sas_thrid_w == 2'b01) & C2T1_st_ack |
                      (spc2_sas_thrid_w == 2'b10) & C2T2_st_ack |
                      (spc2_sas_thrid_w == 2'b11) & C2T3_st_ack;

wire [7:0] spc2_stb_ld_full_raw	= `TOP_DESIGN.sparc2.lsu.stb_ld_full_raw[7:0];
wire [7:0] spc2_stb_ld_partial_raw	= `TOP_DESIGN.sparc2.lsu.stb_ld_partial_raw[7:0];
wire       spc2_stb_cam_mhit		= `TOP_DESIGN.sparc2.lsu.stb_cam_mhit;
wire       spc2_stb_cam_hit		= `TOP_DESIGN.sparc2.lsu.stb_cam_hit;
wire [3:0] spc2_lsu_way_hit		= `TOP_DESIGN.sparc2.lsu.dctl.lsu_way_hit[3:0];
wire       spc2_lsu_ifu_ldst_miss_w	= `TOP_DESIGN.sparc2.lsu.lsu_ifu_ldst_miss_w;
wire       spc2_ld_inst_vld_g	= `TOP_DESIGN.sparc2.lsu.dctl.ld_inst_vld_g;
wire       spc2_ldst_dbl_g		= `TOP_DESIGN.sparc2.lsu.dctl.ldst_dbl_g;
wire       spc2_quad_asi_g		= `TOP_DESIGN.sparc2.lsu.dctl.quad_asi_g;
wire [1:0] spc2_ldst_sz_g		= `TOP_DESIGN.sparc2.lsu.dctl.ldst_sz_g;
wire       spc2_lsu_alt_space_g	= `TOP_DESIGN.sparc2.lsu.dctl.lsu_alt_space_g;

wire       spc2_mbar_inst0_g		= `TOP_DESIGN.sparc2.lsu.dctl.mbar_inst0_g;
wire       spc2_mbar_inst1_g		= `TOP_DESIGN.sparc2.lsu.dctl.mbar_inst1_g;
wire       spc2_mbar_inst2_g		= `TOP_DESIGN.sparc2.lsu.dctl.mbar_inst2_g;
wire       spc2_mbar_inst3_g		= `TOP_DESIGN.sparc2.lsu.dctl.mbar_inst3_g;

wire       spc2_flush_inst0_g	= `TOP_DESIGN.sparc2.lsu.dctl.flush_inst0_g;
wire       spc2_flush_inst1_g	= `TOP_DESIGN.sparc2.lsu.dctl.flush_inst1_g;
wire       spc2_flush_inst2_g	= `TOP_DESIGN.sparc2.lsu.dctl.flush_inst2_g;
wire       spc2_flush_inst3_g	= `TOP_DESIGN.sparc2.lsu.dctl.flush_inst3_g;

wire       spc2_intrpt_disp_asi0_g	= `TOP_DESIGN.sparc2.lsu.dctl.intrpt_disp_asi_g & (spc2_sas_thrid_w == 2'b00);
wire       spc2_intrpt_disp_asi1_g	= `TOP_DESIGN.sparc2.lsu.dctl.intrpt_disp_asi_g & (spc2_sas_thrid_w == 2'b01);
wire       spc2_intrpt_disp_asi2_g	= `TOP_DESIGN.sparc2.lsu.dctl.intrpt_disp_asi_g & (spc2_sas_thrid_w == 2'b10);
wire       spc2_intrpt_disp_asi3_g	= `TOP_DESIGN.sparc2.lsu.dctl.intrpt_disp_asi_g & (spc2_sas_thrid_w == 2'b11);

wire       spc2_st_inst_vld_g	= `TOP_DESIGN.sparc2.lsu.dctl.st_inst_vld_g;
wire       spc2_non_altspace_ldst_g	= `TOP_DESIGN.sparc2.lsu.dctl.non_altspace_ldst_g;

wire       spc2_dctl_flush_pipe_w	= `TOP_DESIGN.sparc2.lsu.dctl.dctl_flush_pipe_w;

wire [3:0] spc2_no_spc_rmo_st	= `TOP_DESIGN.sparc2.lsu.dctl.no_spc_rmo_st[3:0];


wire       spc2_ldst_fp_e		= `TOP_DESIGN.sparc2.lsu.ifu_lsu_ldst_fp_e;
wire [2:0] spc2_stb_rdptr		= `TOP_DESIGN.sparc2.lsu.stb_rwctl.stb_rdptr_l;

wire 	   spc2_ld_l2cache_req 	= `TOP_DESIGN.sparc2.lsu.qctl1.ld3_l2cache_rq |
					  `TOP_DESIGN.sparc2.lsu.qctl1.ld2_l2cache_rq |
                 			  `TOP_DESIGN.sparc2.lsu.qctl1.ld1_l2cache_rq |
					  `TOP_DESIGN.sparc2.lsu.qctl1.ld0_l2cache_rq;

wire [3:0] spc2_dcache_enable	= {`TOP_DESIGN.sparc2.lsu.dctl.lsu_ctl_reg0[1],
                                    	   `TOP_DESIGN.sparc2.lsu.dctl.lsu_ctl_reg1[1],
					   `TOP_DESIGN.sparc2.lsu.dctl.lsu_ctl_reg2[1],
					   `TOP_DESIGN.sparc2.lsu.dctl.lsu_ctl_reg3[1]};

wire [3:0] spc2_icache_enable	= `TOP_DESIGN.sparc2.lsu.lsu_ifu_icache_en[3:0];

wire spc2_dc_direct_map 		= `TOP_DESIGN.sparc2.lsu.dc_direct_map;
wire spc2_lsu_ifu_direct_map_l1	= `TOP_DESIGN.sparc2.lsu.lsu_ifu_direct_map_l1;

always @(spc2_dcache_enable)
    $display("%0d tso_mon: spc2_dcache_enable changed to %x", $time, spc2_dcache_enable);

always @(spc2_icache_enable)
    $display("%0d tso_mon: spc2_icache_enable changed to %x", $time, spc2_icache_enable);

always @(spc2_dc_direct_map)
    $display("%0d tso_mon: spc2_dc_direct_map changed to %x", $time, spc2_dc_direct_map);

always @(spc2_lsu_ifu_direct_map_l1)
   $display("%0d tso_mon: spc2_lsu_ifu_direct_map_l1 changed to %x", $time, spc2_lsu_ifu_direct_map_l1);

reg 		spc2_dva_svld_e_d1;
reg 		spc2_dva_rvld_e_d1;
reg [10:4] 	spc2_dva_rd_addr_e_d1;
reg [4:0]  	spc2_dva_snp_addr_e_d1;

reg   		spc2_lsu_snp_after_rd;
reg   		spc2_lsu_rd_after_snp;

reg 	   	spc2_ldst_fp_m, spc2_ldst_fp_g;

integer 	spc2_multiple_hits;

reg spc2_skid_d1, spc2_skid_d2, spc2_skid_d3;
initial begin
  spc2_skid_d1 = 0;
  spc2_skid_d2 = 0;
  spc2_skid_d3 = 0;
end

always @(posedge clk)
begin

  spc2_skid_d1 <= (~spc2_ifu_lsu_inv_clear & spc2_dfq_rd_advance & spc2_dfq_int_type);
  spc2_skid_d2 <= spc2_skid_d1 & ~spc2_ifu_lsu_inv_clear;
  spc2_skid_d3 <= spc2_skid_d2 & ~spc2_ifu_lsu_inv_clear;

// The full tracking of this condition is complicated since after the interrupt is advanced
// there may be more invalidations to the IFQ.
// All we care about is that the invalidations BEFORE the interrupt are finished.
// I provided a command line argument to disable this check.
  if(spc2_skid_d3 & enable_ifu_lsu_inv_clear)
     finish_test("spc", "tso_mon:   spc2_ifu_lsu_inv_clear should have been clear by now", 2);

  spc2_dva_svld_e_d1 	<= spc2_dva_svld_e;
  spc2_dva_rvld_e_d1 	<= spc2_dva_rvld_e;
  spc2_dva_rd_addr_e_d1 	<= spc2_dva_rd_addr_e;
  spc2_dva_snp_addr_e_d1 	<= spc2_dva_snp_addr_e;

  if(spc2_dva_svld_e_d1 & spc2_dva_rvld_e & (spc2_dva_rd_addr_e_d1[10:6] == spc2_dva_snp_addr_e[4:0]))
    spc2_lsu_rd_after_snp <= 1'b1;
  else 
    spc2_lsu_rd_after_snp <= 1'b0;

  if(spc2_dva_svld_e & spc2_dva_rvld_e_d1 & (spc2_dva_rd_addr_e[10:6] == spc2_dva_snp_addr_e_d1[4:0]))
    spc2_lsu_snp_after_rd <= 1'b1;
  else 
    spc2_lsu_snp_after_rd <= 1'b0;

  spc2_ldst_fp_m <= spc2_ldst_fp_e;
  spc2_ldst_fp_g <= spc2_ldst_fp_m;

  if(spc2_stb_data_rptr_vld & spc2_stb_data_wptr_vld & ~spc2_stbrwctl_flush_pipe_w &
     (spc2_stb_data_rd_ptr == spc2_stb_data_wr_ptr) & spc2_lsu_st_pcx_rq_pick)
  begin
    finish_test("spc", "tso_mon: LSU stb data write and read in the same cycle", 2);
  end

   spc2_multiple_hits = (spc2_lsu_way_hit[3] + spc2_lsu_way_hit[2] + spc2_lsu_way_hit[1] + spc2_lsu_way_hit[0]);
   if(!spc2_lsu_ifu_ldst_miss_w && (spc2_multiple_hits >1) && spc2_inst_vld_w && !spc2_dctl_flush_pipe_w && !spc2_lsu_dc_tag_pe_g_unmasked_or)
     finish_test("spc", "tso_mon: LSU multiple hits ", 2);
end

wire spc2_ld_dbl      = spc2_ld_inst_vld_g &  spc2_ldst_dbl_g &  ~spc2_quad_asi_g;
wire spc2_ld_quad     = spc2_ld_inst_vld_g &  spc2_ldst_dbl_g &  spc2_quad_asi_g;
wire spc2_ld_other    = spc2_ld_inst_vld_g & ~spc2_ldst_dbl_g;

wire spc2_ld_dbl_fp   = spc2_ld_dbl        &  spc2_ldst_fp_g;
wire spc2_ld_other_fp = spc2_ld_other      &  spc2_ldst_fp_g;

wire spc2_ld_dbl_int  = spc2_ld_dbl        & ~spc2_ldst_fp_g;
wire spc2_ld_quad_int = spc2_ld_quad       & ~spc2_ldst_fp_g;
wire spc2_ld_other_int= spc2_ld_other      & ~spc2_ldst_fp_g;

wire spc2_ld_bypassok_hit = |spc2_stb_ld_full_raw[7:0] & ~spc2_stb_cam_mhit;
wire spc2_ld_partial_hit  = |spc2_stb_ld_partial_raw[7:0] & ~spc2_stb_cam_mhit;
wire spc2_ld_multiple_hit =  spc2_stb_cam_mhit;

wire spc2_any_lsu_way_hit = |spc2_lsu_way_hit;

wire [7:0] spc2_stb_rdptr_decoded = 	(spc2_stb_rdptr ==3'b000) ? 8'b00000001 :
                               		(spc2_stb_rdptr ==3'b001) ? 8'b00000010 :
                               		(spc2_stb_rdptr ==3'b010) ? 8'b00000100 :
                              		(spc2_stb_rdptr ==3'b011) ? 8'b00001000 :
                              		(spc2_stb_rdptr ==3'b100) ? 8'b00010000 :
                              		(spc2_stb_rdptr ==3'b101) ? 8'b00100000 :
                             		(spc2_stb_rdptr ==3'b110) ? 8'b01000000 :
                              		(spc2_stb_rdptr ==3'b111) ? 8'b10000000 : 8'h00;


wire spc2_stb_top_hit = |(spc2_stb_rdptr_decoded & (spc2_stb_ld_full_raw | spc2_stb_ld_partial_raw));

//---------------------------------------------------------------------
// ld_type[4:0] hit_type[2:0], cache_hit, hit_top
// this is passed to the coverage monitor.
//---------------------------------------------------------------------
wire [10:0] spc2_stb_ld_hit_info = 
	{spc2_ld_dbl_fp,        spc2_ld_other_fp,
	 spc2_ld_dbl_int, 	   spc2_ld_quad_int,    spc2_ld_other_int,
	 spc2_ld_bypassok_hit,  spc2_ld_partial_hit, spc2_ld_multiple_hit,
	 spc2_any_lsu_way_hit,
	 spc2_stb_top_hit, C2_st_ack_w};

reg spc2_mbar0_active;
reg spc2_mbar1_active;
reg spc2_mbar2_active;
reg spc2_mbar3_active;

reg spc2_flush0_active;
reg spc2_flush1_active;
reg spc2_flush2_active;
reg spc2_flush3_active;

reg spc2_intr0_active;
reg spc2_intr1_active;
reg spc2_intr2_active;
reg spc2_intr3_active;

always @(negedge clk)
begin
  if(~rst_l)
  begin
     spc2_mbar0_active <= 1'b0;
     spc2_mbar1_active <= 1'b0;
     spc2_mbar2_active <= 1'b0;
     spc2_mbar3_active <= 1'b0;

     spc2_flush0_active <= 1'b0;
     spc2_flush1_active <= 1'b0;
     spc2_flush2_active <= 1'b0;
     spc2_flush3_active <= 1'b0;

     spc2_intr0_active <= 1'b0;
     spc2_intr1_active <= 1'b0;
     spc2_intr2_active <= 1'b0;
     spc2_intr3_active <= 1'b0;

  end
  else
  begin
    if(spc2_mbar_inst0_g & ~spc2_dctl_flush_pipe_w & (C2T0_stb_ne|~spc2_no_spc_rmo_st[0]))
	spc2_mbar0_active <= 1'b1;
    else if(~C2T0_stb_ne & spc2_no_spc_rmo_st[0])
	spc2_mbar0_active <= 1'b0;
    if(spc2_mbar_inst1_g & ~ spc2_dctl_flush_pipe_w & (C2T1_stb_ne|~spc2_no_spc_rmo_st[1]))
	spc2_mbar1_active <= 1'b1;
    else if(~C2T1_stb_ne & spc2_no_spc_rmo_st[1])
	spc2_mbar1_active <= 1'b0;
    if(spc2_mbar_inst2_g & ~ spc2_dctl_flush_pipe_w & (C2T2_stb_ne|~spc2_no_spc_rmo_st[2]))
	spc2_mbar2_active <= 1'b1;
    else if(~C2T2_stb_ne & spc2_no_spc_rmo_st[2])
	spc2_mbar2_active <= 1'b0;
    if(spc2_mbar_inst3_g & ~ spc2_dctl_flush_pipe_w & (C2T3_stb_ne|~spc2_no_spc_rmo_st[3]))
	spc2_mbar3_active <= 1'b1;
    else if(~C2T3_stb_ne & spc2_no_spc_rmo_st[3])
	spc2_mbar3_active <= 1'b0;

    if(spc2_flush_inst0_g & ~spc2_dctl_flush_pipe_w & C2T0_stb_ne) 	spc2_flush0_active <= 1'b1;
    else if(~C2T0_stb_ne)			  				spc2_flush0_active <= 1'b0;
    if(spc2_flush_inst1_g & ~spc2_dctl_flush_pipe_w & C2T1_stb_ne) 	spc2_flush1_active <= 1'b1;
    else if(~C2T1_stb_ne)			  				spc2_flush1_active <= 1'b0;
    if(spc2_flush_inst2_g & ~spc2_dctl_flush_pipe_w & C2T2_stb_ne) 	spc2_flush2_active <= 1'b1;
    else if(~C2T2_stb_ne)			  				spc2_flush2_active <= 1'b0;
    if(spc2_flush_inst3_g & ~spc2_dctl_flush_pipe_w & C2T3_stb_ne) 	spc2_flush3_active <= 1'b1;
    else if(~C2T3_stb_ne)			  				spc2_flush3_active <= 1'b0;

    if(spc2_intrpt_disp_asi0_g & spc2_st_inst_vld_g & ~spc2_non_altspace_ldst_g & ~spc2_dctl_flush_pipe_w & C2T0_stb_ne)
	spc2_intr0_active <= 1'b1;
    else if(~C2T0_stb_ne)			  				
	spc2_intr0_active <= 1'b0;
    if(spc2_intrpt_disp_asi1_g &  spc2_st_inst_vld_g & ~spc2_non_altspace_ldst_g & ~spc2_dctl_flush_pipe_w & C2T1_stb_ne)
	spc2_intr1_active <= 1'b1;
    else if(~C2T1_stb_ne)
	spc2_intr1_active <= 1'b0;
    if(spc2_intrpt_disp_asi2_g &  spc2_st_inst_vld_g & ~spc2_non_altspace_ldst_g & ~spc2_dctl_flush_pipe_w & C2T2_stb_ne)
	spc2_intr2_active <= 1'b1;
    else if(~C2T2_stb_ne)
	spc2_intr2_active <= 1'b0;
    if(spc2_intrpt_disp_asi3_g &  spc2_st_inst_vld_g & ~spc2_non_altspace_ldst_g & ~spc2_dctl_flush_pipe_w & C2T3_stb_ne)
	spc2_intr3_active <= 1'b1;
    else if(~C2T3_stb_ne)
	spc2_intr3_active <= 1'b0;
  end

  if(spc2_mbar0_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "membar violation thread 0", 2);
  if(spc2_mbar1_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "membar violation thread 1", 2);
  if(spc2_mbar2_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "membar violation thread 2", 2);
  if(spc2_mbar3_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "membar violation thread 3", 2);

  if(spc2_flush0_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "flush violation thread 0", 2);
  if(spc2_flush1_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "flush violation thread 1", 2);
  if(spc2_flush2_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "flush violation thread 2", 2);
  if(spc2_flush3_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "flush violation thread 3", 2);

  if(spc2_intr0_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "intr violation thread 0", 2);
  if(spc2_intr1_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "intr violation thread 1", 2);
  if(spc2_intr2_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "intr violation thread 2", 2);
  if(spc2_intr3_active & spc2_inst_vld_w & spc2_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "intr violation thread 3", 2);

   if(~rst_l | ~C2T0_stb_full | sctag_pcx_stall_pq) 	C2T0_stb_drain_cnt = 0;
   else							C2T0_stb_drain_cnt = C2T0_stb_drain_cnt + 1;
   if(C2T0_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 0 is not draining", 2);

   if(~rst_l | ~C2T1_stb_full | sctag_pcx_stall_pq) 	C2T1_stb_drain_cnt = 0;
   else							C2T1_stb_drain_cnt = C2T1_stb_drain_cnt + 1;
   if(C2T1_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 1 is not draining", 2);

   if(~rst_l | ~C2T2_stb_full | sctag_pcx_stall_pq) 	C2T2_stb_drain_cnt = 0;
   else							C2T2_stb_drain_cnt = C2T2_stb_drain_cnt + 1;
   if(C2T2_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 2 is not draining", 2);

   if(~rst_l | ~C2T3_stb_full | sctag_pcx_stall_pq) 	C2T3_stb_drain_cnt = 0;
   else							C2T3_stb_drain_cnt = C2T3_stb_drain_cnt + 1;
   if(C2T3_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 3 is not draining", 2);

  C2T0_stb_vld_sum_d1 <= C2T0_stb_vld_sum;
  C2T1_stb_vld_sum_d1 <= C2T1_stb_vld_sum;
  C2T2_stb_vld_sum_d1 <= C2T2_stb_vld_sum;
  C2T3_stb_vld_sum_d1 <= C2T3_stb_vld_sum;
  C2T0_defr_trp_en_d1 <= C2T0_defr_trp_en;
  C2T1_defr_trp_en_d1 <= C2T1_defr_trp_en;
  C2T2_defr_trp_en_d1 <= C2T2_defr_trp_en;
  C2T3_defr_trp_en_d1 <= C2T3_defr_trp_en;

  if(rst_l & C2T0_defr_trp_en_d1 & (C2T0_stb_vld_sum_d1 < C2T0_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T0", 2);
  if(rst_l & C2T1_defr_trp_en_d1 & (C2T1_stb_vld_sum_d1 < C2T1_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T1", 2);
  if(rst_l & C2T2_defr_trp_en_d1 & (C2T2_stb_vld_sum_d1 < C2T2_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T2", 2);
  if(rst_l & C2T3_defr_trp_en_d1 & (C2T3_stb_vld_sum_d1 < C2T3_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T3", 2);
 
end

`endif // ifdef RTL_SPARC2
`ifdef RTL_SPARC3
wire   C3T0_stb_ne    = |`TOP_DESIGN.sparc3.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C3T1_stb_ne    = |`TOP_DESIGN.sparc3.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C3T2_stb_ne    = |`TOP_DESIGN.sparc3.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C3T3_stb_ne    = |`TOP_DESIGN.sparc3.lsu.stb_ctl3.stb_state_vld[7:0];

wire   C3T0_stb_nced  = |(	 `TOP_DESIGN.sparc3.lsu.stb_ctl0.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc3.lsu.stb_ctl0.stb_state_ced[7:0]);
wire   C3T1_stb_nced  = |(	 `TOP_DESIGN.sparc3.lsu.stb_ctl1.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc3.lsu.stb_ctl1.stb_state_ced[7:0]);
wire   C3T2_stb_nced  = |(	 `TOP_DESIGN.sparc3.lsu.stb_ctl2.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc3.lsu.stb_ctl2.stb_state_ced[7:0]);
wire   C3T3_stb_nced  = |(	 `TOP_DESIGN.sparc3.lsu.stb_ctl3.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc3.lsu.stb_ctl3.stb_state_ced[7:0]);

`else
wire   C3T0_stb_ne    = 1'b0;
wire   C3T1_stb_ne    = 1'b0;
wire   C3T2_stb_ne    = 1'b0;
wire   C3T3_stb_ne    = 1'b0;

wire   C3T0_stb_nced  = 1'b0;
wire   C3T1_stb_nced  = 1'b0;
wire   C3T2_stb_nced  = 1'b0;
wire   C3T3_stb_nced  = 1'b0;
`endif // ifdef RTL_SPARC3

`ifdef RTL_SPARC3

wire   spc3_lsu_ifill_pkt_vld	= `TOP_DESIGN.sparc3.lsu.qctl2.lsu_ifill_pkt_vld;
wire   spc3_dfq_rd_advance  		= `TOP_DESIGN.sparc3.lsu.qctl2.dfq_rd_advance;
wire   spc3_dfq_int_type  		= `TOP_DESIGN.sparc3.lsu.qctl2.dfq_int_type;

wire   spc3_ifu_lsu_inv_clear	= `TOP_DESIGN.sparc3.lsu.qctl2.ifu_lsu_inv_clear;

wire 	    spc3_dva_svld_e 	 	= `TOP_DESIGN.sparc3.lsu.qctl2.dva_svld_e;
wire 	    spc3_dva_rvld_e	 	= `TOP_DESIGN.sparc3.lsu.dva.rd_en;
wire [10:4] spc3_dva_rd_addr_e  	= `TOP_DESIGN.sparc3.lsu.dva.rd_adr1[6:0];
wire [4:0]  spc3_dva_snp_addr_e 	= `TOP_DESIGN.sparc3.lsu.qctl2.dva_snp_addr_e[4:0];

wire [4:0]  spc3_stb_data_rd_ptr   	= `TOP_DESIGN.sparc3.lsu.stb_data_rd_ptr[4:0];
wire [4:0]  spc3_stb_data_wr_ptr   	= `TOP_DESIGN.sparc3.lsu.stb_data_wr_ptr[4:0];
wire        spc3_stb_data_wptr_vld 	= `TOP_DESIGN.sparc3.lsu.stb_data_wptr_vld;
wire        spc3_stb_data_rptr_vld 	= `TOP_DESIGN.sparc3.lsu.stb_data_rptr_vld;
wire        spc3_stbrwctl_flush_pipe_w = `TOP_DESIGN.sparc3.lsu.stb_rwctl.lsu_stbrwctl_flush_pipe_w;
wire        spc3_lsu_st_pcx_rq_pick 	= |`TOP_DESIGN.sparc3.lsu.stb_rwctl.lsu_st_pcx_rq_pick[3:0];

wire [3:0]  spc3_lsu_rd_dtag_parity_g = `TOP_DESIGN.sparc3.lsu.dctl.lsu_rd_dtag_parity_g[3:0];
wire [3:0]  spc3_dva_vld_g		 = `TOP_DESIGN.sparc3.lsu.dctl.dva_vld_g[3:0];

wire [3:0]  spc3_lsu_dc_tag_pe_g_unmasked    = spc3_lsu_rd_dtag_parity_g[3:0] & spc3_dva_vld_g[3:0];
wire        spc3_lsu_dc_tag_pe_g_unmasked_or = |spc3_lsu_dc_tag_pe_g_unmasked[3:0];

wire   C3T0_stb_full  = &`TOP_DESIGN.sparc3.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C3T1_stb_full  = &`TOP_DESIGN.sparc3.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C3T2_stb_full  = &`TOP_DESIGN.sparc3.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C3T3_stb_full  = &`TOP_DESIGN.sparc3.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [7:0] C3T0_stb_vld  = `TOP_DESIGN.sparc3.lsu.stb_ctl0.stb_state_vld[7:0];
wire   [7:0] C3T1_stb_vld  = `TOP_DESIGN.sparc3.lsu.stb_ctl1.stb_state_vld[7:0];
wire   [7:0] C3T2_stb_vld  = `TOP_DESIGN.sparc3.lsu.stb_ctl2.stb_state_vld[7:0];
wire   [7:0] C3T3_stb_vld  = `TOP_DESIGN.sparc3.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [4:0] C3T0_stb_vld_sum  =  C3T0_stb_vld[0] +  C3T0_stb_vld[1] +  C3T0_stb_vld[2] +  C3T0_stb_vld[3] +
                                     C3T0_stb_vld[4] +  C3T0_stb_vld[5] +  C3T0_stb_vld[6] +  C3T0_stb_vld[7] ;
wire   [4:0] C3T1_stb_vld_sum  =  C3T1_stb_vld[0] +  C3T1_stb_vld[1] +  C3T1_stb_vld[2] +  C3T1_stb_vld[3] +
                                     C3T1_stb_vld[4] +  C3T1_stb_vld[5] +  C3T1_stb_vld[6] +  C3T1_stb_vld[7] ;
wire   [4:0] C3T2_stb_vld_sum  =  C3T2_stb_vld[0] +  C3T2_stb_vld[1] +  C3T2_stb_vld[2] +  C3T2_stb_vld[3] +
                                     C3T2_stb_vld[4] +  C3T2_stb_vld[5] +  C3T2_stb_vld[6] +  C3T2_stb_vld[7] ;
wire   [4:0] C3T3_stb_vld_sum  =  C3T3_stb_vld[0] +  C3T3_stb_vld[1] +  C3T3_stb_vld[2] +  C3T3_stb_vld[3] +
                                     C3T3_stb_vld[4] +  C3T3_stb_vld[5] +  C3T3_stb_vld[6] +  C3T3_stb_vld[7] ;

reg [4:0] C3T0_stb_vld_sum_d1;
reg [4:0] C3T1_stb_vld_sum_d1;
reg [4:0] C3T2_stb_vld_sum_d1;
reg [4:0] C3T3_stb_vld_sum_d1;

wire   C3T0_st_ack  = &`TOP_DESIGN.sparc3.lsu.cpx_st_ack_tid0;
wire   C3T1_st_ack  = &`TOP_DESIGN.sparc3.lsu.cpx_st_ack_tid1;
wire   C3T2_st_ack  = &`TOP_DESIGN.sparc3.lsu.cpx_st_ack_tid2;
wire   C3T3_st_ack  = &`TOP_DESIGN.sparc3.lsu.cpx_st_ack_tid3;

wire   C3T0_defr_trp_en	= &`TOP_DESIGN.sparc3.lsu.excpctl.st_defr_trp_en0;
wire   C3T1_defr_trp_en	= &`TOP_DESIGN.sparc3.lsu.excpctl.st_defr_trp_en1;
wire   C3T2_defr_trp_en	= &`TOP_DESIGN.sparc3.lsu.excpctl.st_defr_trp_en2;
wire   C3T3_defr_trp_en	= &`TOP_DESIGN.sparc3.lsu.excpctl.st_defr_trp_en3;

reg C3T0_defr_trp_en_d1;
reg C3T1_defr_trp_en_d1;
reg C3T2_defr_trp_en_d1;
reg C3T3_defr_trp_en_d1;

integer C3T0_stb_drain_cnt;
integer C3T1_stb_drain_cnt;
integer C3T2_stb_drain_cnt;
integer C3T3_stb_drain_cnt;

// Hits in the store buffer
//-------------------------
wire       spc3_inst_vld_w		= `TOP_DESIGN.sparc3.ifu.fcl.inst_vld_w;
wire [1:0] spc3_sas_thrid_w		= `TOP_DESIGN.sparc3.ifu.fcl.sas_thrid_w[1:0];

wire C3_st_ack_w = (spc3_sas_thrid_w == 2'b00) & C3T0_st_ack |
                      (spc3_sas_thrid_w == 2'b01) & C3T1_st_ack |
                      (spc3_sas_thrid_w == 2'b10) & C3T2_st_ack |
                      (spc3_sas_thrid_w == 2'b11) & C3T3_st_ack;

wire [7:0] spc3_stb_ld_full_raw	= `TOP_DESIGN.sparc3.lsu.stb_ld_full_raw[7:0];
wire [7:0] spc3_stb_ld_partial_raw	= `TOP_DESIGN.sparc3.lsu.stb_ld_partial_raw[7:0];
wire       spc3_stb_cam_mhit		= `TOP_DESIGN.sparc3.lsu.stb_cam_mhit;
wire       spc3_stb_cam_hit		= `TOP_DESIGN.sparc3.lsu.stb_cam_hit;
wire [3:0] spc3_lsu_way_hit		= `TOP_DESIGN.sparc3.lsu.dctl.lsu_way_hit[3:0];
wire       spc3_lsu_ifu_ldst_miss_w	= `TOP_DESIGN.sparc3.lsu.lsu_ifu_ldst_miss_w;
wire       spc3_ld_inst_vld_g	= `TOP_DESIGN.sparc3.lsu.dctl.ld_inst_vld_g;
wire       spc3_ldst_dbl_g		= `TOP_DESIGN.sparc3.lsu.dctl.ldst_dbl_g;
wire       spc3_quad_asi_g		= `TOP_DESIGN.sparc3.lsu.dctl.quad_asi_g;
wire [1:0] spc3_ldst_sz_g		= `TOP_DESIGN.sparc3.lsu.dctl.ldst_sz_g;
wire       spc3_lsu_alt_space_g	= `TOP_DESIGN.sparc3.lsu.dctl.lsu_alt_space_g;

wire       spc3_mbar_inst0_g		= `TOP_DESIGN.sparc3.lsu.dctl.mbar_inst0_g;
wire       spc3_mbar_inst1_g		= `TOP_DESIGN.sparc3.lsu.dctl.mbar_inst1_g;
wire       spc3_mbar_inst2_g		= `TOP_DESIGN.sparc3.lsu.dctl.mbar_inst2_g;
wire       spc3_mbar_inst3_g		= `TOP_DESIGN.sparc3.lsu.dctl.mbar_inst3_g;

wire       spc3_flush_inst0_g	= `TOP_DESIGN.sparc3.lsu.dctl.flush_inst0_g;
wire       spc3_flush_inst1_g	= `TOP_DESIGN.sparc3.lsu.dctl.flush_inst1_g;
wire       spc3_flush_inst2_g	= `TOP_DESIGN.sparc3.lsu.dctl.flush_inst2_g;
wire       spc3_flush_inst3_g	= `TOP_DESIGN.sparc3.lsu.dctl.flush_inst3_g;

wire       spc3_intrpt_disp_asi0_g	= `TOP_DESIGN.sparc3.lsu.dctl.intrpt_disp_asi_g & (spc3_sas_thrid_w == 2'b00);
wire       spc3_intrpt_disp_asi1_g	= `TOP_DESIGN.sparc3.lsu.dctl.intrpt_disp_asi_g & (spc3_sas_thrid_w == 2'b01);
wire       spc3_intrpt_disp_asi2_g	= `TOP_DESIGN.sparc3.lsu.dctl.intrpt_disp_asi_g & (spc3_sas_thrid_w == 2'b10);
wire       spc3_intrpt_disp_asi3_g	= `TOP_DESIGN.sparc3.lsu.dctl.intrpt_disp_asi_g & (spc3_sas_thrid_w == 2'b11);

wire       spc3_st_inst_vld_g	= `TOP_DESIGN.sparc3.lsu.dctl.st_inst_vld_g;
wire       spc3_non_altspace_ldst_g	= `TOP_DESIGN.sparc3.lsu.dctl.non_altspace_ldst_g;

wire       spc3_dctl_flush_pipe_w	= `TOP_DESIGN.sparc3.lsu.dctl.dctl_flush_pipe_w;

wire [3:0] spc3_no_spc_rmo_st	= `TOP_DESIGN.sparc3.lsu.dctl.no_spc_rmo_st[3:0];


wire       spc3_ldst_fp_e		= `TOP_DESIGN.sparc3.lsu.ifu_lsu_ldst_fp_e;
wire [2:0] spc3_stb_rdptr		= `TOP_DESIGN.sparc3.lsu.stb_rwctl.stb_rdptr_l;

wire 	   spc3_ld_l2cache_req 	= `TOP_DESIGN.sparc3.lsu.qctl1.ld3_l2cache_rq |
					  `TOP_DESIGN.sparc3.lsu.qctl1.ld2_l2cache_rq |
                 			  `TOP_DESIGN.sparc3.lsu.qctl1.ld1_l2cache_rq |
					  `TOP_DESIGN.sparc3.lsu.qctl1.ld0_l2cache_rq;

wire [3:0] spc3_dcache_enable	= {`TOP_DESIGN.sparc3.lsu.dctl.lsu_ctl_reg0[1],
                                    	   `TOP_DESIGN.sparc3.lsu.dctl.lsu_ctl_reg1[1],
					   `TOP_DESIGN.sparc3.lsu.dctl.lsu_ctl_reg2[1],
					   `TOP_DESIGN.sparc3.lsu.dctl.lsu_ctl_reg3[1]};

wire [3:0] spc3_icache_enable	= `TOP_DESIGN.sparc3.lsu.lsu_ifu_icache_en[3:0];

wire spc3_dc_direct_map 		= `TOP_DESIGN.sparc3.lsu.dc_direct_map;
wire spc3_lsu_ifu_direct_map_l1	= `TOP_DESIGN.sparc3.lsu.lsu_ifu_direct_map_l1;

always @(spc3_dcache_enable)
    $display("%0d tso_mon: spc3_dcache_enable changed to %x", $time, spc3_dcache_enable);

always @(spc3_icache_enable)
    $display("%0d tso_mon: spc3_icache_enable changed to %x", $time, spc3_icache_enable);

always @(spc3_dc_direct_map)
    $display("%0d tso_mon: spc3_dc_direct_map changed to %x", $time, spc3_dc_direct_map);

always @(spc3_lsu_ifu_direct_map_l1)
   $display("%0d tso_mon: spc3_lsu_ifu_direct_map_l1 changed to %x", $time, spc3_lsu_ifu_direct_map_l1);

reg 		spc3_dva_svld_e_d1;
reg 		spc3_dva_rvld_e_d1;
reg [10:4] 	spc3_dva_rd_addr_e_d1;
reg [4:0]  	spc3_dva_snp_addr_e_d1;

reg   		spc3_lsu_snp_after_rd;
reg   		spc3_lsu_rd_after_snp;

reg 	   	spc3_ldst_fp_m, spc3_ldst_fp_g;

integer 	spc3_multiple_hits;

reg spc3_skid_d1, spc3_skid_d2, spc3_skid_d3;
initial begin
  spc3_skid_d1 = 0;
  spc3_skid_d2 = 0;
  spc3_skid_d3 = 0;
end

always @(posedge clk)
begin

  spc3_skid_d1 <= (~spc3_ifu_lsu_inv_clear & spc3_dfq_rd_advance & spc3_dfq_int_type);
  spc3_skid_d2 <= spc3_skid_d1 & ~spc3_ifu_lsu_inv_clear;
  spc3_skid_d3 <= spc3_skid_d2 & ~spc3_ifu_lsu_inv_clear;

// The full tracking of this condition is complicated since after the interrupt is advanced
// there may be more invalidations to the IFQ.
// All we care about is that the invalidations BEFORE the interrupt are finished.
// I provided a command line argument to disable this check.
  if(spc3_skid_d3 & enable_ifu_lsu_inv_clear)
     finish_test("spc", "tso_mon:   spc3_ifu_lsu_inv_clear should have been clear by now", 3);

  spc3_dva_svld_e_d1 	<= spc3_dva_svld_e;
  spc3_dva_rvld_e_d1 	<= spc3_dva_rvld_e;
  spc3_dva_rd_addr_e_d1 	<= spc3_dva_rd_addr_e;
  spc3_dva_snp_addr_e_d1 	<= spc3_dva_snp_addr_e;

  if(spc3_dva_svld_e_d1 & spc3_dva_rvld_e & (spc3_dva_rd_addr_e_d1[10:6] == spc3_dva_snp_addr_e[4:0]))
    spc3_lsu_rd_after_snp <= 1'b1;
  else 
    spc3_lsu_rd_after_snp <= 1'b0;

  if(spc3_dva_svld_e & spc3_dva_rvld_e_d1 & (spc3_dva_rd_addr_e[10:6] == spc3_dva_snp_addr_e_d1[4:0]))
    spc3_lsu_snp_after_rd <= 1'b1;
  else 
    spc3_lsu_snp_after_rd <= 1'b0;

  spc3_ldst_fp_m <= spc3_ldst_fp_e;
  spc3_ldst_fp_g <= spc3_ldst_fp_m;

  if(spc3_stb_data_rptr_vld & spc3_stb_data_wptr_vld & ~spc3_stbrwctl_flush_pipe_w &
     (spc3_stb_data_rd_ptr == spc3_stb_data_wr_ptr) & spc3_lsu_st_pcx_rq_pick)
  begin
    finish_test("spc", "tso_mon: LSU stb data write and read in the same cycle", 3);
  end

   spc3_multiple_hits = (spc3_lsu_way_hit[3] + spc3_lsu_way_hit[2] + spc3_lsu_way_hit[1] + spc3_lsu_way_hit[0]);
   if(!spc3_lsu_ifu_ldst_miss_w && (spc3_multiple_hits >1) && spc3_inst_vld_w && !spc3_dctl_flush_pipe_w && !spc3_lsu_dc_tag_pe_g_unmasked_or)
     finish_test("spc", "tso_mon: LSU multiple hits ", 3);
end

wire spc3_ld_dbl      = spc3_ld_inst_vld_g &  spc3_ldst_dbl_g &  ~spc3_quad_asi_g;
wire spc3_ld_quad     = spc3_ld_inst_vld_g &  spc3_ldst_dbl_g &  spc3_quad_asi_g;
wire spc3_ld_other    = spc3_ld_inst_vld_g & ~spc3_ldst_dbl_g;

wire spc3_ld_dbl_fp   = spc3_ld_dbl        &  spc3_ldst_fp_g;
wire spc3_ld_other_fp = spc3_ld_other      &  spc3_ldst_fp_g;

wire spc3_ld_dbl_int  = spc3_ld_dbl        & ~spc3_ldst_fp_g;
wire spc3_ld_quad_int = spc3_ld_quad       & ~spc3_ldst_fp_g;
wire spc3_ld_other_int= spc3_ld_other      & ~spc3_ldst_fp_g;

wire spc3_ld_bypassok_hit = |spc3_stb_ld_full_raw[7:0] & ~spc3_stb_cam_mhit;
wire spc3_ld_partial_hit  = |spc3_stb_ld_partial_raw[7:0] & ~spc3_stb_cam_mhit;
wire spc3_ld_multiple_hit =  spc3_stb_cam_mhit;

wire spc3_any_lsu_way_hit = |spc3_lsu_way_hit;

wire [7:0] spc3_stb_rdptr_decoded = 	(spc3_stb_rdptr ==3'b000) ? 8'b00000001 :
                               		(spc3_stb_rdptr ==3'b001) ? 8'b00000010 :
                               		(spc3_stb_rdptr ==3'b010) ? 8'b00000100 :
                              		(spc3_stb_rdptr ==3'b011) ? 8'b00001000 :
                              		(spc3_stb_rdptr ==3'b100) ? 8'b00010000 :
                              		(spc3_stb_rdptr ==3'b101) ? 8'b00100000 :
                             		(spc3_stb_rdptr ==3'b110) ? 8'b01000000 :
                              		(spc3_stb_rdptr ==3'b111) ? 8'b10000000 : 8'h00;


wire spc3_stb_top_hit = |(spc3_stb_rdptr_decoded & (spc3_stb_ld_full_raw | spc3_stb_ld_partial_raw));

//---------------------------------------------------------------------
// ld_type[4:0] hit_type[2:0], cache_hit, hit_top
// this is passed to the coverage monitor.
//---------------------------------------------------------------------
wire [10:0] spc3_stb_ld_hit_info = 
	{spc3_ld_dbl_fp,        spc3_ld_other_fp,
	 spc3_ld_dbl_int, 	   spc3_ld_quad_int,    spc3_ld_other_int,
	 spc3_ld_bypassok_hit,  spc3_ld_partial_hit, spc3_ld_multiple_hit,
	 spc3_any_lsu_way_hit,
	 spc3_stb_top_hit, C3_st_ack_w};

reg spc3_mbar0_active;
reg spc3_mbar1_active;
reg spc3_mbar2_active;
reg spc3_mbar3_active;

reg spc3_flush0_active;
reg spc3_flush1_active;
reg spc3_flush2_active;
reg spc3_flush3_active;

reg spc3_intr0_active;
reg spc3_intr1_active;
reg spc3_intr2_active;
reg spc3_intr3_active;

always @(negedge clk)
begin
  if(~rst_l)
  begin
     spc3_mbar0_active <= 1'b0;
     spc3_mbar1_active <= 1'b0;
     spc3_mbar2_active <= 1'b0;
     spc3_mbar3_active <= 1'b0;

     spc3_flush0_active <= 1'b0;
     spc3_flush1_active <= 1'b0;
     spc3_flush2_active <= 1'b0;
     spc3_flush3_active <= 1'b0;

     spc3_intr0_active <= 1'b0;
     spc3_intr1_active <= 1'b0;
     spc3_intr2_active <= 1'b0;
     spc3_intr3_active <= 1'b0;

  end
  else
  begin
    if(spc3_mbar_inst0_g & ~spc3_dctl_flush_pipe_w & (C3T0_stb_ne|~spc3_no_spc_rmo_st[0]))
	spc3_mbar0_active <= 1'b1;
    else if(~C3T0_stb_ne & spc3_no_spc_rmo_st[0])
	spc3_mbar0_active <= 1'b0;
    if(spc3_mbar_inst1_g & ~ spc3_dctl_flush_pipe_w & (C3T1_stb_ne|~spc3_no_spc_rmo_st[1]))
	spc3_mbar1_active <= 1'b1;
    else if(~C3T1_stb_ne & spc3_no_spc_rmo_st[1])
	spc3_mbar1_active <= 1'b0;
    if(spc3_mbar_inst2_g & ~ spc3_dctl_flush_pipe_w & (C3T2_stb_ne|~spc3_no_spc_rmo_st[2]))
	spc3_mbar2_active <= 1'b1;
    else if(~C3T2_stb_ne & spc3_no_spc_rmo_st[2])
	spc3_mbar2_active <= 1'b0;
    if(spc3_mbar_inst3_g & ~ spc3_dctl_flush_pipe_w & (C3T3_stb_ne|~spc3_no_spc_rmo_st[3]))
	spc3_mbar3_active <= 1'b1;
    else if(~C3T3_stb_ne & spc3_no_spc_rmo_st[3])
	spc3_mbar3_active <= 1'b0;

    if(spc3_flush_inst0_g & ~spc3_dctl_flush_pipe_w & C3T0_stb_ne) 	spc3_flush0_active <= 1'b1;
    else if(~C3T0_stb_ne)			  				spc3_flush0_active <= 1'b0;
    if(spc3_flush_inst1_g & ~spc3_dctl_flush_pipe_w & C3T1_stb_ne) 	spc3_flush1_active <= 1'b1;
    else if(~C3T1_stb_ne)			  				spc3_flush1_active <= 1'b0;
    if(spc3_flush_inst2_g & ~spc3_dctl_flush_pipe_w & C3T2_stb_ne) 	spc3_flush2_active <= 1'b1;
    else if(~C3T2_stb_ne)			  				spc3_flush2_active <= 1'b0;
    if(spc3_flush_inst3_g & ~spc3_dctl_flush_pipe_w & C3T3_stb_ne) 	spc3_flush3_active <= 1'b1;
    else if(~C3T3_stb_ne)			  				spc3_flush3_active <= 1'b0;

    if(spc3_intrpt_disp_asi0_g & spc3_st_inst_vld_g & ~spc3_non_altspace_ldst_g & ~spc3_dctl_flush_pipe_w & C3T0_stb_ne)
	spc3_intr0_active <= 1'b1;
    else if(~C3T0_stb_ne)			  				
	spc3_intr0_active <= 1'b0;
    if(spc3_intrpt_disp_asi1_g &  spc3_st_inst_vld_g & ~spc3_non_altspace_ldst_g & ~spc3_dctl_flush_pipe_w & C3T1_stb_ne)
	spc3_intr1_active <= 1'b1;
    else if(~C3T1_stb_ne)
	spc3_intr1_active <= 1'b0;
    if(spc3_intrpt_disp_asi2_g &  spc3_st_inst_vld_g & ~spc3_non_altspace_ldst_g & ~spc3_dctl_flush_pipe_w & C3T2_stb_ne)
	spc3_intr2_active <= 1'b1;
    else if(~C3T2_stb_ne)
	spc3_intr2_active <= 1'b0;
    if(spc3_intrpt_disp_asi3_g &  spc3_st_inst_vld_g & ~spc3_non_altspace_ldst_g & ~spc3_dctl_flush_pipe_w & C3T3_stb_ne)
	spc3_intr3_active <= 1'b1;
    else if(~C3T3_stb_ne)
	spc3_intr3_active <= 1'b0;
  end

  if(spc3_mbar0_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "membar violation thread 0", 3);
  if(spc3_mbar1_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "membar violation thread 1", 3);
  if(spc3_mbar2_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "membar violation thread 2", 3);
  if(spc3_mbar3_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "membar violation thread 3", 3);

  if(spc3_flush0_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "flush violation thread 0", 3);
  if(spc3_flush1_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "flush violation thread 1", 3);
  if(spc3_flush2_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "flush violation thread 2", 3);
  if(spc3_flush3_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "flush violation thread 3", 3);

  if(spc3_intr0_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "intr violation thread 0", 3);
  if(spc3_intr1_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "intr violation thread 1", 3);
  if(spc3_intr2_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "intr violation thread 2", 3);
  if(spc3_intr3_active & spc3_inst_vld_w & spc3_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "intr violation thread 3", 3);

   if(~rst_l | ~C3T0_stb_full | sctag_pcx_stall_pq) 	C3T0_stb_drain_cnt = 0;
   else							C3T0_stb_drain_cnt = C3T0_stb_drain_cnt + 1;
   if(C3T0_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 0 is not draining", 3);

   if(~rst_l | ~C3T1_stb_full | sctag_pcx_stall_pq) 	C3T1_stb_drain_cnt = 0;
   else							C3T1_stb_drain_cnt = C3T1_stb_drain_cnt + 1;
   if(C3T1_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 1 is not draining", 3);

   if(~rst_l | ~C3T2_stb_full | sctag_pcx_stall_pq) 	C3T2_stb_drain_cnt = 0;
   else							C3T2_stb_drain_cnt = C3T2_stb_drain_cnt + 1;
   if(C3T2_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 2 is not draining", 3);

   if(~rst_l | ~C3T3_stb_full | sctag_pcx_stall_pq) 	C3T3_stb_drain_cnt = 0;
   else							C3T3_stb_drain_cnt = C3T3_stb_drain_cnt + 1;
   if(C3T3_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 3 is not draining", 3);

  C3T0_stb_vld_sum_d1 <= C3T0_stb_vld_sum;
  C3T1_stb_vld_sum_d1 <= C3T1_stb_vld_sum;
  C3T2_stb_vld_sum_d1 <= C3T2_stb_vld_sum;
  C3T3_stb_vld_sum_d1 <= C3T3_stb_vld_sum;
  C3T0_defr_trp_en_d1 <= C3T0_defr_trp_en;
  C3T1_defr_trp_en_d1 <= C3T1_defr_trp_en;
  C3T2_defr_trp_en_d1 <= C3T2_defr_trp_en;
  C3T3_defr_trp_en_d1 <= C3T3_defr_trp_en;

  if(rst_l & C3T0_defr_trp_en_d1 & (C3T0_stb_vld_sum_d1 < C3T0_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T0", 3);
  if(rst_l & C3T1_defr_trp_en_d1 & (C3T1_stb_vld_sum_d1 < C3T1_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T1", 3);
  if(rst_l & C3T2_defr_trp_en_d1 & (C3T2_stb_vld_sum_d1 < C3T2_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T2", 3);
  if(rst_l & C3T3_defr_trp_en_d1 & (C3T3_stb_vld_sum_d1 < C3T3_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T3", 3);
 
end

`endif // ifdef RTL_SPARC3
`ifdef RTL_SPARC4
wire   C4T0_stb_ne    = |`TOP_DESIGN.sparc4.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C4T1_stb_ne    = |`TOP_DESIGN.sparc4.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C4T2_stb_ne    = |`TOP_DESIGN.sparc4.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C4T3_stb_ne    = |`TOP_DESIGN.sparc4.lsu.stb_ctl3.stb_state_vld[7:0];

wire   C4T0_stb_nced  = |(	 `TOP_DESIGN.sparc4.lsu.stb_ctl0.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc4.lsu.stb_ctl0.stb_state_ced[7:0]);
wire   C4T1_stb_nced  = |(	 `TOP_DESIGN.sparc4.lsu.stb_ctl1.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc4.lsu.stb_ctl1.stb_state_ced[7:0]);
wire   C4T2_stb_nced  = |(	 `TOP_DESIGN.sparc4.lsu.stb_ctl2.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc4.lsu.stb_ctl2.stb_state_ced[7:0]);
wire   C4T3_stb_nced  = |(	 `TOP_DESIGN.sparc4.lsu.stb_ctl3.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc4.lsu.stb_ctl3.stb_state_ced[7:0]);

`else
wire   C4T0_stb_ne    = 1'b0;
wire   C4T1_stb_ne    = 1'b0;
wire   C4T2_stb_ne    = 1'b0;
wire   C4T3_stb_ne    = 1'b0;

wire   C4T0_stb_nced  = 1'b0;
wire   C4T1_stb_nced  = 1'b0;
wire   C4T2_stb_nced  = 1'b0;
wire   C4T3_stb_nced  = 1'b0;
`endif // ifdef RTL_SPARC4

`ifdef RTL_SPARC4

wire   spc4_lsu_ifill_pkt_vld	= `TOP_DESIGN.sparc4.lsu.qctl2.lsu_ifill_pkt_vld;
wire   spc4_dfq_rd_advance  		= `TOP_DESIGN.sparc4.lsu.qctl2.dfq_rd_advance;
wire   spc4_dfq_int_type  		= `TOP_DESIGN.sparc4.lsu.qctl2.dfq_int_type;

wire   spc4_ifu_lsu_inv_clear	= `TOP_DESIGN.sparc4.lsu.qctl2.ifu_lsu_inv_clear;

wire 	    spc4_dva_svld_e 	 	= `TOP_DESIGN.sparc4.lsu.qctl2.dva_svld_e;
wire 	    spc4_dva_rvld_e	 	= `TOP_DESIGN.sparc4.lsu.dva.rd_en;
wire [10:4] spc4_dva_rd_addr_e  	= `TOP_DESIGN.sparc4.lsu.dva.rd_adr1[6:0];
wire [4:0]  spc4_dva_snp_addr_e 	= `TOP_DESIGN.sparc4.lsu.qctl2.dva_snp_addr_e[4:0];

wire [4:0]  spc4_stb_data_rd_ptr   	= `TOP_DESIGN.sparc4.lsu.stb_data_rd_ptr[4:0];
wire [4:0]  spc4_stb_data_wr_ptr   	= `TOP_DESIGN.sparc4.lsu.stb_data_wr_ptr[4:0];
wire        spc4_stb_data_wptr_vld 	= `TOP_DESIGN.sparc4.lsu.stb_data_wptr_vld;
wire        spc4_stb_data_rptr_vld 	= `TOP_DESIGN.sparc4.lsu.stb_data_rptr_vld;
wire        spc4_stbrwctl_flush_pipe_w = `TOP_DESIGN.sparc4.lsu.stb_rwctl.lsu_stbrwctl_flush_pipe_w;
wire        spc4_lsu_st_pcx_rq_pick 	= |`TOP_DESIGN.sparc4.lsu.stb_rwctl.lsu_st_pcx_rq_pick[3:0];

wire [3:0]  spc4_lsu_rd_dtag_parity_g = `TOP_DESIGN.sparc4.lsu.dctl.lsu_rd_dtag_parity_g[3:0];
wire [3:0]  spc4_dva_vld_g		 = `TOP_DESIGN.sparc4.lsu.dctl.dva_vld_g[3:0];

wire [3:0]  spc4_lsu_dc_tag_pe_g_unmasked    = spc4_lsu_rd_dtag_parity_g[3:0] & spc4_dva_vld_g[3:0];
wire        spc4_lsu_dc_tag_pe_g_unmasked_or = |spc4_lsu_dc_tag_pe_g_unmasked[3:0];

wire   C4T0_stb_full  = &`TOP_DESIGN.sparc4.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C4T1_stb_full  = &`TOP_DESIGN.sparc4.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C4T2_stb_full  = &`TOP_DESIGN.sparc4.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C4T3_stb_full  = &`TOP_DESIGN.sparc4.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [7:0] C4T0_stb_vld  = `TOP_DESIGN.sparc4.lsu.stb_ctl0.stb_state_vld[7:0];
wire   [7:0] C4T1_stb_vld  = `TOP_DESIGN.sparc4.lsu.stb_ctl1.stb_state_vld[7:0];
wire   [7:0] C4T2_stb_vld  = `TOP_DESIGN.sparc4.lsu.stb_ctl2.stb_state_vld[7:0];
wire   [7:0] C4T3_stb_vld  = `TOP_DESIGN.sparc4.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [4:0] C4T0_stb_vld_sum  =  C4T0_stb_vld[0] +  C4T0_stb_vld[1] +  C4T0_stb_vld[2] +  C4T0_stb_vld[3] +
                                     C4T0_stb_vld[4] +  C4T0_stb_vld[5] +  C4T0_stb_vld[6] +  C4T0_stb_vld[7] ;
wire   [4:0] C4T1_stb_vld_sum  =  C4T1_stb_vld[0] +  C4T1_stb_vld[1] +  C4T1_stb_vld[2] +  C4T1_stb_vld[3] +
                                     C4T1_stb_vld[4] +  C4T1_stb_vld[5] +  C4T1_stb_vld[6] +  C4T1_stb_vld[7] ;
wire   [4:0] C4T2_stb_vld_sum  =  C4T2_stb_vld[0] +  C4T2_stb_vld[1] +  C4T2_stb_vld[2] +  C4T2_stb_vld[3] +
                                     C4T2_stb_vld[4] +  C4T2_stb_vld[5] +  C4T2_stb_vld[6] +  C4T2_stb_vld[7] ;
wire   [4:0] C4T3_stb_vld_sum  =  C4T3_stb_vld[0] +  C4T3_stb_vld[1] +  C4T3_stb_vld[2] +  C4T3_stb_vld[3] +
                                     C4T3_stb_vld[4] +  C4T3_stb_vld[5] +  C4T3_stb_vld[6] +  C4T3_stb_vld[7] ;

reg [4:0] C4T0_stb_vld_sum_d1;
reg [4:0] C4T1_stb_vld_sum_d1;
reg [4:0] C4T2_stb_vld_sum_d1;
reg [4:0] C4T3_stb_vld_sum_d1;

wire   C4T0_st_ack  = &`TOP_DESIGN.sparc4.lsu.cpx_st_ack_tid0;
wire   C4T1_st_ack  = &`TOP_DESIGN.sparc4.lsu.cpx_st_ack_tid1;
wire   C4T2_st_ack  = &`TOP_DESIGN.sparc4.lsu.cpx_st_ack_tid2;
wire   C4T3_st_ack  = &`TOP_DESIGN.sparc4.lsu.cpx_st_ack_tid3;

wire   C4T0_defr_trp_en	= &`TOP_DESIGN.sparc4.lsu.excpctl.st_defr_trp_en0;
wire   C4T1_defr_trp_en	= &`TOP_DESIGN.sparc4.lsu.excpctl.st_defr_trp_en1;
wire   C4T2_defr_trp_en	= &`TOP_DESIGN.sparc4.lsu.excpctl.st_defr_trp_en2;
wire   C4T3_defr_trp_en	= &`TOP_DESIGN.sparc4.lsu.excpctl.st_defr_trp_en3;

reg C4T0_defr_trp_en_d1;
reg C4T1_defr_trp_en_d1;
reg C4T2_defr_trp_en_d1;
reg C4T3_defr_trp_en_d1;

integer C4T0_stb_drain_cnt;
integer C4T1_stb_drain_cnt;
integer C4T2_stb_drain_cnt;
integer C4T3_stb_drain_cnt;

// Hits in the store buffer
//-------------------------
wire       spc4_inst_vld_w		= `TOP_DESIGN.sparc4.ifu.fcl.inst_vld_w;
wire [1:0] spc4_sas_thrid_w		= `TOP_DESIGN.sparc4.ifu.fcl.sas_thrid_w[1:0];

wire C4_st_ack_w = (spc4_sas_thrid_w == 2'b00) & C4T0_st_ack |
                      (spc4_sas_thrid_w == 2'b01) & C4T1_st_ack |
                      (spc4_sas_thrid_w == 2'b10) & C4T2_st_ack |
                      (spc4_sas_thrid_w == 2'b11) & C4T3_st_ack;

wire [7:0] spc4_stb_ld_full_raw	= `TOP_DESIGN.sparc4.lsu.stb_ld_full_raw[7:0];
wire [7:0] spc4_stb_ld_partial_raw	= `TOP_DESIGN.sparc4.lsu.stb_ld_partial_raw[7:0];
wire       spc4_stb_cam_mhit		= `TOP_DESIGN.sparc4.lsu.stb_cam_mhit;
wire       spc4_stb_cam_hit		= `TOP_DESIGN.sparc4.lsu.stb_cam_hit;
wire [3:0] spc4_lsu_way_hit		= `TOP_DESIGN.sparc4.lsu.dctl.lsu_way_hit[3:0];
wire       spc4_lsu_ifu_ldst_miss_w	= `TOP_DESIGN.sparc4.lsu.lsu_ifu_ldst_miss_w;
wire       spc4_ld_inst_vld_g	= `TOP_DESIGN.sparc4.lsu.dctl.ld_inst_vld_g;
wire       spc4_ldst_dbl_g		= `TOP_DESIGN.sparc4.lsu.dctl.ldst_dbl_g;
wire       spc4_quad_asi_g		= `TOP_DESIGN.sparc4.lsu.dctl.quad_asi_g;
wire [1:0] spc4_ldst_sz_g		= `TOP_DESIGN.sparc4.lsu.dctl.ldst_sz_g;
wire       spc4_lsu_alt_space_g	= `TOP_DESIGN.sparc4.lsu.dctl.lsu_alt_space_g;

wire       spc4_mbar_inst0_g		= `TOP_DESIGN.sparc4.lsu.dctl.mbar_inst0_g;
wire       spc4_mbar_inst1_g		= `TOP_DESIGN.sparc4.lsu.dctl.mbar_inst1_g;
wire       spc4_mbar_inst2_g		= `TOP_DESIGN.sparc4.lsu.dctl.mbar_inst2_g;
wire       spc4_mbar_inst3_g		= `TOP_DESIGN.sparc4.lsu.dctl.mbar_inst3_g;

wire       spc4_flush_inst0_g	= `TOP_DESIGN.sparc4.lsu.dctl.flush_inst0_g;
wire       spc4_flush_inst1_g	= `TOP_DESIGN.sparc4.lsu.dctl.flush_inst1_g;
wire       spc4_flush_inst2_g	= `TOP_DESIGN.sparc4.lsu.dctl.flush_inst2_g;
wire       spc4_flush_inst3_g	= `TOP_DESIGN.sparc4.lsu.dctl.flush_inst3_g;

wire       spc4_intrpt_disp_asi0_g	= `TOP_DESIGN.sparc4.lsu.dctl.intrpt_disp_asi_g & (spc4_sas_thrid_w == 2'b00);
wire       spc4_intrpt_disp_asi1_g	= `TOP_DESIGN.sparc4.lsu.dctl.intrpt_disp_asi_g & (spc4_sas_thrid_w == 2'b01);
wire       spc4_intrpt_disp_asi2_g	= `TOP_DESIGN.sparc4.lsu.dctl.intrpt_disp_asi_g & (spc4_sas_thrid_w == 2'b10);
wire       spc4_intrpt_disp_asi3_g	= `TOP_DESIGN.sparc4.lsu.dctl.intrpt_disp_asi_g & (spc4_sas_thrid_w == 2'b11);

wire       spc4_st_inst_vld_g	= `TOP_DESIGN.sparc4.lsu.dctl.st_inst_vld_g;
wire       spc4_non_altspace_ldst_g	= `TOP_DESIGN.sparc4.lsu.dctl.non_altspace_ldst_g;

wire       spc4_dctl_flush_pipe_w	= `TOP_DESIGN.sparc4.lsu.dctl.dctl_flush_pipe_w;

wire [3:0] spc4_no_spc_rmo_st	= `TOP_DESIGN.sparc4.lsu.dctl.no_spc_rmo_st[3:0];


wire       spc4_ldst_fp_e		= `TOP_DESIGN.sparc4.lsu.ifu_lsu_ldst_fp_e;
wire [2:0] spc4_stb_rdptr		= `TOP_DESIGN.sparc4.lsu.stb_rwctl.stb_rdptr_l;

wire 	   spc4_ld_l2cache_req 	= `TOP_DESIGN.sparc4.lsu.qctl1.ld3_l2cache_rq |
					  `TOP_DESIGN.sparc4.lsu.qctl1.ld2_l2cache_rq |
                 			  `TOP_DESIGN.sparc4.lsu.qctl1.ld1_l2cache_rq |
					  `TOP_DESIGN.sparc4.lsu.qctl1.ld0_l2cache_rq;

wire [3:0] spc4_dcache_enable	= {`TOP_DESIGN.sparc4.lsu.dctl.lsu_ctl_reg0[1],
                                    	   `TOP_DESIGN.sparc4.lsu.dctl.lsu_ctl_reg1[1],
					   `TOP_DESIGN.sparc4.lsu.dctl.lsu_ctl_reg2[1],
					   `TOP_DESIGN.sparc4.lsu.dctl.lsu_ctl_reg3[1]};

wire [3:0] spc4_icache_enable	= `TOP_DESIGN.sparc4.lsu.lsu_ifu_icache_en[3:0];

wire spc4_dc_direct_map 		= `TOP_DESIGN.sparc4.lsu.dc_direct_map;
wire spc4_lsu_ifu_direct_map_l1	= `TOP_DESIGN.sparc4.lsu.lsu_ifu_direct_map_l1;

always @(spc4_dcache_enable)
    $display("%0d tso_mon: spc4_dcache_enable changed to %x", $time, spc4_dcache_enable);

always @(spc4_icache_enable)
    $display("%0d tso_mon: spc4_icache_enable changed to %x", $time, spc4_icache_enable);

always @(spc4_dc_direct_map)
    $display("%0d tso_mon: spc4_dc_direct_map changed to %x", $time, spc4_dc_direct_map);

always @(spc4_lsu_ifu_direct_map_l1)
   $display("%0d tso_mon: spc4_lsu_ifu_direct_map_l1 changed to %x", $time, spc4_lsu_ifu_direct_map_l1);

reg 		spc4_dva_svld_e_d1;
reg 		spc4_dva_rvld_e_d1;
reg [10:4] 	spc4_dva_rd_addr_e_d1;
reg [4:0]  	spc4_dva_snp_addr_e_d1;

reg   		spc4_lsu_snp_after_rd;
reg   		spc4_lsu_rd_after_snp;

reg 	   	spc4_ldst_fp_m, spc4_ldst_fp_g;

integer 	spc4_multiple_hits;

reg spc4_skid_d1, spc4_skid_d2, spc4_skid_d3;
initial begin
  spc4_skid_d1 = 0;
  spc4_skid_d2 = 0;
  spc4_skid_d3 = 0;
end

always @(posedge clk)
begin

  spc4_skid_d1 <= (~spc4_ifu_lsu_inv_clear & spc4_dfq_rd_advance & spc4_dfq_int_type);
  spc4_skid_d2 <= spc4_skid_d1 & ~spc4_ifu_lsu_inv_clear;
  spc4_skid_d3 <= spc4_skid_d2 & ~spc4_ifu_lsu_inv_clear;

// The full tracking of this condition is complicated since after the interrupt is advanced
// there may be more invalidations to the IFQ.
// All we care about is that the invalidations BEFORE the interrupt are finished.
// I provided a command line argument to disable this check.
  if(spc4_skid_d3 & enable_ifu_lsu_inv_clear)
     finish_test("spc", "tso_mon:   spc4_ifu_lsu_inv_clear should have been clear by now", 4);

  spc4_dva_svld_e_d1 	<= spc4_dva_svld_e;
  spc4_dva_rvld_e_d1 	<= spc4_dva_rvld_e;
  spc4_dva_rd_addr_e_d1 	<= spc4_dva_rd_addr_e;
  spc4_dva_snp_addr_e_d1 	<= spc4_dva_snp_addr_e;

  if(spc4_dva_svld_e_d1 & spc4_dva_rvld_e & (spc4_dva_rd_addr_e_d1[10:6] == spc4_dva_snp_addr_e[4:0]))
    spc4_lsu_rd_after_snp <= 1'b1;
  else 
    spc4_lsu_rd_after_snp <= 1'b0;

  if(spc4_dva_svld_e & spc4_dva_rvld_e_d1 & (spc4_dva_rd_addr_e[10:6] == spc4_dva_snp_addr_e_d1[4:0]))
    spc4_lsu_snp_after_rd <= 1'b1;
  else 
    spc4_lsu_snp_after_rd <= 1'b0;

  spc4_ldst_fp_m <= spc4_ldst_fp_e;
  spc4_ldst_fp_g <= spc4_ldst_fp_m;

  if(spc4_stb_data_rptr_vld & spc4_stb_data_wptr_vld & ~spc4_stbrwctl_flush_pipe_w &
     (spc4_stb_data_rd_ptr == spc4_stb_data_wr_ptr) & spc4_lsu_st_pcx_rq_pick)
  begin
    finish_test("spc", "tso_mon: LSU stb data write and read in the same cycle", 4);
  end

   spc4_multiple_hits = (spc4_lsu_way_hit[3] + spc4_lsu_way_hit[2] + spc4_lsu_way_hit[1] + spc4_lsu_way_hit[0]);
   if(!spc4_lsu_ifu_ldst_miss_w && (spc4_multiple_hits >1) && spc4_inst_vld_w && !spc4_dctl_flush_pipe_w && !spc4_lsu_dc_tag_pe_g_unmasked_or)
     finish_test("spc", "tso_mon: LSU multiple hits ", 4);
end

wire spc4_ld_dbl      = spc4_ld_inst_vld_g &  spc4_ldst_dbl_g &  ~spc4_quad_asi_g;
wire spc4_ld_quad     = spc4_ld_inst_vld_g &  spc4_ldst_dbl_g &  spc4_quad_asi_g;
wire spc4_ld_other    = spc4_ld_inst_vld_g & ~spc4_ldst_dbl_g;

wire spc4_ld_dbl_fp   = spc4_ld_dbl        &  spc4_ldst_fp_g;
wire spc4_ld_other_fp = spc4_ld_other      &  spc4_ldst_fp_g;

wire spc4_ld_dbl_int  = spc4_ld_dbl        & ~spc4_ldst_fp_g;
wire spc4_ld_quad_int = spc4_ld_quad       & ~spc4_ldst_fp_g;
wire spc4_ld_other_int= spc4_ld_other      & ~spc4_ldst_fp_g;

wire spc4_ld_bypassok_hit = |spc4_stb_ld_full_raw[7:0] & ~spc4_stb_cam_mhit;
wire spc4_ld_partial_hit  = |spc4_stb_ld_partial_raw[7:0] & ~spc4_stb_cam_mhit;
wire spc4_ld_multiple_hit =  spc4_stb_cam_mhit;

wire spc4_any_lsu_way_hit = |spc4_lsu_way_hit;

wire [7:0] spc4_stb_rdptr_decoded = 	(spc4_stb_rdptr ==3'b000) ? 8'b00000001 :
                               		(spc4_stb_rdptr ==3'b001) ? 8'b00000010 :
                               		(spc4_stb_rdptr ==3'b010) ? 8'b00000100 :
                              		(spc4_stb_rdptr ==3'b011) ? 8'b00001000 :
                              		(spc4_stb_rdptr ==3'b100) ? 8'b00010000 :
                              		(spc4_stb_rdptr ==3'b101) ? 8'b00100000 :
                             		(spc4_stb_rdptr ==3'b110) ? 8'b01000000 :
                              		(spc4_stb_rdptr ==3'b111) ? 8'b10000000 : 8'h00;


wire spc4_stb_top_hit = |(spc4_stb_rdptr_decoded & (spc4_stb_ld_full_raw | spc4_stb_ld_partial_raw));

//---------------------------------------------------------------------
// ld_type[4:0] hit_type[2:0], cache_hit, hit_top
// this is passed to the coverage monitor.
//---------------------------------------------------------------------
wire [10:0] spc4_stb_ld_hit_info = 
	{spc4_ld_dbl_fp,        spc4_ld_other_fp,
	 spc4_ld_dbl_int, 	   spc4_ld_quad_int,    spc4_ld_other_int,
	 spc4_ld_bypassok_hit,  spc4_ld_partial_hit, spc4_ld_multiple_hit,
	 spc4_any_lsu_way_hit,
	 spc4_stb_top_hit, C4_st_ack_w};

reg spc4_mbar0_active;
reg spc4_mbar1_active;
reg spc4_mbar2_active;
reg spc4_mbar3_active;

reg spc4_flush0_active;
reg spc4_flush1_active;
reg spc4_flush2_active;
reg spc4_flush3_active;

reg spc4_intr0_active;
reg spc4_intr1_active;
reg spc4_intr2_active;
reg spc4_intr3_active;

always @(negedge clk)
begin
  if(~rst_l)
  begin
     spc4_mbar0_active <= 1'b0;
     spc4_mbar1_active <= 1'b0;
     spc4_mbar2_active <= 1'b0;
     spc4_mbar3_active <= 1'b0;

     spc4_flush0_active <= 1'b0;
     spc4_flush1_active <= 1'b0;
     spc4_flush2_active <= 1'b0;
     spc4_flush3_active <= 1'b0;

     spc4_intr0_active <= 1'b0;
     spc4_intr1_active <= 1'b0;
     spc4_intr2_active <= 1'b0;
     spc4_intr3_active <= 1'b0;

  end
  else
  begin
    if(spc4_mbar_inst0_g & ~spc4_dctl_flush_pipe_w & (C4T0_stb_ne|~spc4_no_spc_rmo_st[0]))
	spc4_mbar0_active <= 1'b1;
    else if(~C4T0_stb_ne & spc4_no_spc_rmo_st[0])
	spc4_mbar0_active <= 1'b0;
    if(spc4_mbar_inst1_g & ~ spc4_dctl_flush_pipe_w & (C4T1_stb_ne|~spc4_no_spc_rmo_st[1]))
	spc4_mbar1_active <= 1'b1;
    else if(~C4T1_stb_ne & spc4_no_spc_rmo_st[1])
	spc4_mbar1_active <= 1'b0;
    if(spc4_mbar_inst2_g & ~ spc4_dctl_flush_pipe_w & (C4T2_stb_ne|~spc4_no_spc_rmo_st[2]))
	spc4_mbar2_active <= 1'b1;
    else if(~C4T2_stb_ne & spc4_no_spc_rmo_st[2])
	spc4_mbar2_active <= 1'b0;
    if(spc4_mbar_inst3_g & ~ spc4_dctl_flush_pipe_w & (C4T3_stb_ne|~spc4_no_spc_rmo_st[3]))
	spc4_mbar3_active <= 1'b1;
    else if(~C4T3_stb_ne & spc4_no_spc_rmo_st[3])
	spc4_mbar3_active <= 1'b0;

    if(spc4_flush_inst0_g & ~spc4_dctl_flush_pipe_w & C4T0_stb_ne) 	spc4_flush0_active <= 1'b1;
    else if(~C4T0_stb_ne)			  				spc4_flush0_active <= 1'b0;
    if(spc4_flush_inst1_g & ~spc4_dctl_flush_pipe_w & C4T1_stb_ne) 	spc4_flush1_active <= 1'b1;
    else if(~C4T1_stb_ne)			  				spc4_flush1_active <= 1'b0;
    if(spc4_flush_inst2_g & ~spc4_dctl_flush_pipe_w & C4T2_stb_ne) 	spc4_flush2_active <= 1'b1;
    else if(~C4T2_stb_ne)			  				spc4_flush2_active <= 1'b0;
    if(spc4_flush_inst3_g & ~spc4_dctl_flush_pipe_w & C4T3_stb_ne) 	spc4_flush3_active <= 1'b1;
    else if(~C4T3_stb_ne)			  				spc4_flush3_active <= 1'b0;

    if(spc4_intrpt_disp_asi0_g & spc4_st_inst_vld_g & ~spc4_non_altspace_ldst_g & ~spc4_dctl_flush_pipe_w & C4T0_stb_ne)
	spc4_intr0_active <= 1'b1;
    else if(~C4T0_stb_ne)			  				
	spc4_intr0_active <= 1'b0;
    if(spc4_intrpt_disp_asi1_g &  spc4_st_inst_vld_g & ~spc4_non_altspace_ldst_g & ~spc4_dctl_flush_pipe_w & C4T1_stb_ne)
	spc4_intr1_active <= 1'b1;
    else if(~C4T1_stb_ne)
	spc4_intr1_active <= 1'b0;
    if(spc4_intrpt_disp_asi2_g &  spc4_st_inst_vld_g & ~spc4_non_altspace_ldst_g & ~spc4_dctl_flush_pipe_w & C4T2_stb_ne)
	spc4_intr2_active <= 1'b1;
    else if(~C4T2_stb_ne)
	spc4_intr2_active <= 1'b0;
    if(spc4_intrpt_disp_asi3_g &  spc4_st_inst_vld_g & ~spc4_non_altspace_ldst_g & ~spc4_dctl_flush_pipe_w & C4T3_stb_ne)
	spc4_intr3_active <= 1'b1;
    else if(~C4T3_stb_ne)
	spc4_intr3_active <= 1'b0;
  end

  if(spc4_mbar0_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "membar violation thread 0", 4);
  if(spc4_mbar1_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "membar violation thread 1", 4);
  if(spc4_mbar2_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "membar violation thread 2", 4);
  if(spc4_mbar3_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "membar violation thread 3", 4);

  if(spc4_flush0_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "flush violation thread 0", 4);
  if(spc4_flush1_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "flush violation thread 1", 4);
  if(spc4_flush2_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "flush violation thread 2", 4);
  if(spc4_flush3_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "flush violation thread 3", 4);

  if(spc4_intr0_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "intr violation thread 0", 4);
  if(spc4_intr1_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "intr violation thread 1", 4);
  if(spc4_intr2_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "intr violation thread 2", 4);
  if(spc4_intr3_active & spc4_inst_vld_w & spc4_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "intr violation thread 3", 4);

   if(~rst_l | ~C4T0_stb_full | sctag_pcx_stall_pq) 	C4T0_stb_drain_cnt = 0;
   else							C4T0_stb_drain_cnt = C4T0_stb_drain_cnt + 1;
   if(C4T0_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 0 is not draining", 4);

   if(~rst_l | ~C4T1_stb_full | sctag_pcx_stall_pq) 	C4T1_stb_drain_cnt = 0;
   else							C4T1_stb_drain_cnt = C4T1_stb_drain_cnt + 1;
   if(C4T1_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 1 is not draining", 4);

   if(~rst_l | ~C4T2_stb_full | sctag_pcx_stall_pq) 	C4T2_stb_drain_cnt = 0;
   else							C4T2_stb_drain_cnt = C4T2_stb_drain_cnt + 1;
   if(C4T2_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 2 is not draining", 4);

   if(~rst_l | ~C4T3_stb_full | sctag_pcx_stall_pq) 	C4T3_stb_drain_cnt = 0;
   else							C4T3_stb_drain_cnt = C4T3_stb_drain_cnt + 1;
   if(C4T3_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 3 is not draining", 4);

  C4T0_stb_vld_sum_d1 <= C4T0_stb_vld_sum;
  C4T1_stb_vld_sum_d1 <= C4T1_stb_vld_sum;
  C4T2_stb_vld_sum_d1 <= C4T2_stb_vld_sum;
  C4T3_stb_vld_sum_d1 <= C4T3_stb_vld_sum;
  C4T0_defr_trp_en_d1 <= C4T0_defr_trp_en;
  C4T1_defr_trp_en_d1 <= C4T1_defr_trp_en;
  C4T2_defr_trp_en_d1 <= C4T2_defr_trp_en;
  C4T3_defr_trp_en_d1 <= C4T3_defr_trp_en;

  if(rst_l & C4T0_defr_trp_en_d1 & (C4T0_stb_vld_sum_d1 < C4T0_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T0", 4);
  if(rst_l & C4T1_defr_trp_en_d1 & (C4T1_stb_vld_sum_d1 < C4T1_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T1", 4);
  if(rst_l & C4T2_defr_trp_en_d1 & (C4T2_stb_vld_sum_d1 < C4T2_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T2", 4);
  if(rst_l & C4T3_defr_trp_en_d1 & (C4T3_stb_vld_sum_d1 < C4T3_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T3", 4);
 
end

`endif // ifdef RTL_SPARC4
`ifdef RTL_SPARC5
wire   C5T0_stb_ne    = |`TOP_DESIGN.sparc5.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C5T1_stb_ne    = |`TOP_DESIGN.sparc5.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C5T2_stb_ne    = |`TOP_DESIGN.sparc5.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C5T3_stb_ne    = |`TOP_DESIGN.sparc5.lsu.stb_ctl3.stb_state_vld[7:0];

wire   C5T0_stb_nced  = |(	 `TOP_DESIGN.sparc5.lsu.stb_ctl0.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc5.lsu.stb_ctl0.stb_state_ced[7:0]);
wire   C5T1_stb_nced  = |(	 `TOP_DESIGN.sparc5.lsu.stb_ctl1.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc5.lsu.stb_ctl1.stb_state_ced[7:0]);
wire   C5T2_stb_nced  = |(	 `TOP_DESIGN.sparc5.lsu.stb_ctl2.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc5.lsu.stb_ctl2.stb_state_ced[7:0]);
wire   C5T3_stb_nced  = |(	 `TOP_DESIGN.sparc5.lsu.stb_ctl3.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc5.lsu.stb_ctl3.stb_state_ced[7:0]);

`else
wire   C5T0_stb_ne    = 1'b0;
wire   C5T1_stb_ne    = 1'b0;
wire   C5T2_stb_ne    = 1'b0;
wire   C5T3_stb_ne    = 1'b0;

wire   C5T0_stb_nced  = 1'b0;
wire   C5T1_stb_nced  = 1'b0;
wire   C5T2_stb_nced  = 1'b0;
wire   C5T3_stb_nced  = 1'b0;
`endif // ifdef RTL_SPARC5

`ifdef RTL_SPARC5

wire   spc5_lsu_ifill_pkt_vld	= `TOP_DESIGN.sparc5.lsu.qctl2.lsu_ifill_pkt_vld;
wire   spc5_dfq_rd_advance  		= `TOP_DESIGN.sparc5.lsu.qctl2.dfq_rd_advance;
wire   spc5_dfq_int_type  		= `TOP_DESIGN.sparc5.lsu.qctl2.dfq_int_type;

wire   spc5_ifu_lsu_inv_clear	= `TOP_DESIGN.sparc5.lsu.qctl2.ifu_lsu_inv_clear;

wire 	    spc5_dva_svld_e 	 	= `TOP_DESIGN.sparc5.lsu.qctl2.dva_svld_e;
wire 	    spc5_dva_rvld_e	 	= `TOP_DESIGN.sparc5.lsu.dva.rd_en;
wire [10:4] spc5_dva_rd_addr_e  	= `TOP_DESIGN.sparc5.lsu.dva.rd_adr1[6:0];
wire [4:0]  spc5_dva_snp_addr_e 	= `TOP_DESIGN.sparc5.lsu.qctl2.dva_snp_addr_e[4:0];

wire [4:0]  spc5_stb_data_rd_ptr   	= `TOP_DESIGN.sparc5.lsu.stb_data_rd_ptr[4:0];
wire [4:0]  spc5_stb_data_wr_ptr   	= `TOP_DESIGN.sparc5.lsu.stb_data_wr_ptr[4:0];
wire        spc5_stb_data_wptr_vld 	= `TOP_DESIGN.sparc5.lsu.stb_data_wptr_vld;
wire        spc5_stb_data_rptr_vld 	= `TOP_DESIGN.sparc5.lsu.stb_data_rptr_vld;
wire        spc5_stbrwctl_flush_pipe_w = `TOP_DESIGN.sparc5.lsu.stb_rwctl.lsu_stbrwctl_flush_pipe_w;
wire        spc5_lsu_st_pcx_rq_pick 	= |`TOP_DESIGN.sparc5.lsu.stb_rwctl.lsu_st_pcx_rq_pick[3:0];

wire [3:0]  spc5_lsu_rd_dtag_parity_g = `TOP_DESIGN.sparc5.lsu.dctl.lsu_rd_dtag_parity_g[3:0];
wire [3:0]  spc5_dva_vld_g		 = `TOP_DESIGN.sparc5.lsu.dctl.dva_vld_g[3:0];

wire [3:0]  spc5_lsu_dc_tag_pe_g_unmasked    = spc5_lsu_rd_dtag_parity_g[3:0] & spc5_dva_vld_g[3:0];
wire        spc5_lsu_dc_tag_pe_g_unmasked_or = |spc5_lsu_dc_tag_pe_g_unmasked[3:0];

wire   C5T0_stb_full  = &`TOP_DESIGN.sparc5.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C5T1_stb_full  = &`TOP_DESIGN.sparc5.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C5T2_stb_full  = &`TOP_DESIGN.sparc5.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C5T3_stb_full  = &`TOP_DESIGN.sparc5.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [7:0] C5T0_stb_vld  = `TOP_DESIGN.sparc5.lsu.stb_ctl0.stb_state_vld[7:0];
wire   [7:0] C5T1_stb_vld  = `TOP_DESIGN.sparc5.lsu.stb_ctl1.stb_state_vld[7:0];
wire   [7:0] C5T2_stb_vld  = `TOP_DESIGN.sparc5.lsu.stb_ctl2.stb_state_vld[7:0];
wire   [7:0] C5T3_stb_vld  = `TOP_DESIGN.sparc5.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [4:0] C5T0_stb_vld_sum  =  C5T0_stb_vld[0] +  C5T0_stb_vld[1] +  C5T0_stb_vld[2] +  C5T0_stb_vld[3] +
                                     C5T0_stb_vld[4] +  C5T0_stb_vld[5] +  C5T0_stb_vld[6] +  C5T0_stb_vld[7] ;
wire   [4:0] C5T1_stb_vld_sum  =  C5T1_stb_vld[0] +  C5T1_stb_vld[1] +  C5T1_stb_vld[2] +  C5T1_stb_vld[3] +
                                     C5T1_stb_vld[4] +  C5T1_stb_vld[5] +  C5T1_stb_vld[6] +  C5T1_stb_vld[7] ;
wire   [4:0] C5T2_stb_vld_sum  =  C5T2_stb_vld[0] +  C5T2_stb_vld[1] +  C5T2_stb_vld[2] +  C5T2_stb_vld[3] +
                                     C5T2_stb_vld[4] +  C5T2_stb_vld[5] +  C5T2_stb_vld[6] +  C5T2_stb_vld[7] ;
wire   [4:0] C5T3_stb_vld_sum  =  C5T3_stb_vld[0] +  C5T3_stb_vld[1] +  C5T3_stb_vld[2] +  C5T3_stb_vld[3] +
                                     C5T3_stb_vld[4] +  C5T3_stb_vld[5] +  C5T3_stb_vld[6] +  C5T3_stb_vld[7] ;

reg [4:0] C5T0_stb_vld_sum_d1;
reg [4:0] C5T1_stb_vld_sum_d1;
reg [4:0] C5T2_stb_vld_sum_d1;
reg [4:0] C5T3_stb_vld_sum_d1;

wire   C5T0_st_ack  = &`TOP_DESIGN.sparc5.lsu.cpx_st_ack_tid0;
wire   C5T1_st_ack  = &`TOP_DESIGN.sparc5.lsu.cpx_st_ack_tid1;
wire   C5T2_st_ack  = &`TOP_DESIGN.sparc5.lsu.cpx_st_ack_tid2;
wire   C5T3_st_ack  = &`TOP_DESIGN.sparc5.lsu.cpx_st_ack_tid3;

wire   C5T0_defr_trp_en	= &`TOP_DESIGN.sparc5.lsu.excpctl.st_defr_trp_en0;
wire   C5T1_defr_trp_en	= &`TOP_DESIGN.sparc5.lsu.excpctl.st_defr_trp_en1;
wire   C5T2_defr_trp_en	= &`TOP_DESIGN.sparc5.lsu.excpctl.st_defr_trp_en2;
wire   C5T3_defr_trp_en	= &`TOP_DESIGN.sparc5.lsu.excpctl.st_defr_trp_en3;

reg C5T0_defr_trp_en_d1;
reg C5T1_defr_trp_en_d1;
reg C5T2_defr_trp_en_d1;
reg C5T3_defr_trp_en_d1;

integer C5T0_stb_drain_cnt;
integer C5T1_stb_drain_cnt;
integer C5T2_stb_drain_cnt;
integer C5T3_stb_drain_cnt;

// Hits in the store buffer
//-------------------------
wire       spc5_inst_vld_w		= `TOP_DESIGN.sparc5.ifu.fcl.inst_vld_w;
wire [1:0] spc5_sas_thrid_w		= `TOP_DESIGN.sparc5.ifu.fcl.sas_thrid_w[1:0];

wire C5_st_ack_w = (spc5_sas_thrid_w == 2'b00) & C5T0_st_ack |
                      (spc5_sas_thrid_w == 2'b01) & C5T1_st_ack |
                      (spc5_sas_thrid_w == 2'b10) & C5T2_st_ack |
                      (spc5_sas_thrid_w == 2'b11) & C5T3_st_ack;

wire [7:0] spc5_stb_ld_full_raw	= `TOP_DESIGN.sparc5.lsu.stb_ld_full_raw[7:0];
wire [7:0] spc5_stb_ld_partial_raw	= `TOP_DESIGN.sparc5.lsu.stb_ld_partial_raw[7:0];
wire       spc5_stb_cam_mhit		= `TOP_DESIGN.sparc5.lsu.stb_cam_mhit;
wire       spc5_stb_cam_hit		= `TOP_DESIGN.sparc5.lsu.stb_cam_hit;
wire [3:0] spc5_lsu_way_hit		= `TOP_DESIGN.sparc5.lsu.dctl.lsu_way_hit[3:0];
wire       spc5_lsu_ifu_ldst_miss_w	= `TOP_DESIGN.sparc5.lsu.lsu_ifu_ldst_miss_w;
wire       spc5_ld_inst_vld_g	= `TOP_DESIGN.sparc5.lsu.dctl.ld_inst_vld_g;
wire       spc5_ldst_dbl_g		= `TOP_DESIGN.sparc5.lsu.dctl.ldst_dbl_g;
wire       spc5_quad_asi_g		= `TOP_DESIGN.sparc5.lsu.dctl.quad_asi_g;
wire [1:0] spc5_ldst_sz_g		= `TOP_DESIGN.sparc5.lsu.dctl.ldst_sz_g;
wire       spc5_lsu_alt_space_g	= `TOP_DESIGN.sparc5.lsu.dctl.lsu_alt_space_g;

wire       spc5_mbar_inst0_g		= `TOP_DESIGN.sparc5.lsu.dctl.mbar_inst0_g;
wire       spc5_mbar_inst1_g		= `TOP_DESIGN.sparc5.lsu.dctl.mbar_inst1_g;
wire       spc5_mbar_inst2_g		= `TOP_DESIGN.sparc5.lsu.dctl.mbar_inst2_g;
wire       spc5_mbar_inst3_g		= `TOP_DESIGN.sparc5.lsu.dctl.mbar_inst3_g;

wire       spc5_flush_inst0_g	= `TOP_DESIGN.sparc5.lsu.dctl.flush_inst0_g;
wire       spc5_flush_inst1_g	= `TOP_DESIGN.sparc5.lsu.dctl.flush_inst1_g;
wire       spc5_flush_inst2_g	= `TOP_DESIGN.sparc5.lsu.dctl.flush_inst2_g;
wire       spc5_flush_inst3_g	= `TOP_DESIGN.sparc5.lsu.dctl.flush_inst3_g;

wire       spc5_intrpt_disp_asi0_g	= `TOP_DESIGN.sparc5.lsu.dctl.intrpt_disp_asi_g & (spc5_sas_thrid_w == 2'b00);
wire       spc5_intrpt_disp_asi1_g	= `TOP_DESIGN.sparc5.lsu.dctl.intrpt_disp_asi_g & (spc5_sas_thrid_w == 2'b01);
wire       spc5_intrpt_disp_asi2_g	= `TOP_DESIGN.sparc5.lsu.dctl.intrpt_disp_asi_g & (spc5_sas_thrid_w == 2'b10);
wire       spc5_intrpt_disp_asi3_g	= `TOP_DESIGN.sparc5.lsu.dctl.intrpt_disp_asi_g & (spc5_sas_thrid_w == 2'b11);

wire       spc5_st_inst_vld_g	= `TOP_DESIGN.sparc5.lsu.dctl.st_inst_vld_g;
wire       spc5_non_altspace_ldst_g	= `TOP_DESIGN.sparc5.lsu.dctl.non_altspace_ldst_g;

wire       spc5_dctl_flush_pipe_w	= `TOP_DESIGN.sparc5.lsu.dctl.dctl_flush_pipe_w;

wire [3:0] spc5_no_spc_rmo_st	= `TOP_DESIGN.sparc5.lsu.dctl.no_spc_rmo_st[3:0];


wire       spc5_ldst_fp_e		= `TOP_DESIGN.sparc5.lsu.ifu_lsu_ldst_fp_e;
wire [2:0] spc5_stb_rdptr		= `TOP_DESIGN.sparc5.lsu.stb_rwctl.stb_rdptr_l;

wire 	   spc5_ld_l2cache_req 	= `TOP_DESIGN.sparc5.lsu.qctl1.ld3_l2cache_rq |
					  `TOP_DESIGN.sparc5.lsu.qctl1.ld2_l2cache_rq |
                 			  `TOP_DESIGN.sparc5.lsu.qctl1.ld1_l2cache_rq |
					  `TOP_DESIGN.sparc5.lsu.qctl1.ld0_l2cache_rq;

wire [3:0] spc5_dcache_enable	= {`TOP_DESIGN.sparc5.lsu.dctl.lsu_ctl_reg0[1],
                                    	   `TOP_DESIGN.sparc5.lsu.dctl.lsu_ctl_reg1[1],
					   `TOP_DESIGN.sparc5.lsu.dctl.lsu_ctl_reg2[1],
					   `TOP_DESIGN.sparc5.lsu.dctl.lsu_ctl_reg3[1]};

wire [3:0] spc5_icache_enable	= `TOP_DESIGN.sparc5.lsu.lsu_ifu_icache_en[3:0];

wire spc5_dc_direct_map 		= `TOP_DESIGN.sparc5.lsu.dc_direct_map;
wire spc5_lsu_ifu_direct_map_l1	= `TOP_DESIGN.sparc5.lsu.lsu_ifu_direct_map_l1;

always @(spc5_dcache_enable)
    $display("%0d tso_mon: spc5_dcache_enable changed to %x", $time, spc5_dcache_enable);

always @(spc5_icache_enable)
    $display("%0d tso_mon: spc5_icache_enable changed to %x", $time, spc5_icache_enable);

always @(spc5_dc_direct_map)
    $display("%0d tso_mon: spc5_dc_direct_map changed to %x", $time, spc5_dc_direct_map);

always @(spc5_lsu_ifu_direct_map_l1)
   $display("%0d tso_mon: spc5_lsu_ifu_direct_map_l1 changed to %x", $time, spc5_lsu_ifu_direct_map_l1);

reg 		spc5_dva_svld_e_d1;
reg 		spc5_dva_rvld_e_d1;
reg [10:4] 	spc5_dva_rd_addr_e_d1;
reg [4:0]  	spc5_dva_snp_addr_e_d1;

reg   		spc5_lsu_snp_after_rd;
reg   		spc5_lsu_rd_after_snp;

reg 	   	spc5_ldst_fp_m, spc5_ldst_fp_g;

integer 	spc5_multiple_hits;

reg spc5_skid_d1, spc5_skid_d2, spc5_skid_d3;
initial begin
  spc5_skid_d1 = 0;
  spc5_skid_d2 = 0;
  spc5_skid_d3 = 0;
end

always @(posedge clk)
begin

  spc5_skid_d1 <= (~spc5_ifu_lsu_inv_clear & spc5_dfq_rd_advance & spc5_dfq_int_type);
  spc5_skid_d2 <= spc5_skid_d1 & ~spc5_ifu_lsu_inv_clear;
  spc5_skid_d3 <= spc5_skid_d2 & ~spc5_ifu_lsu_inv_clear;

// The full tracking of this condition is complicated since after the interrupt is advanced
// there may be more invalidations to the IFQ.
// All we care about is that the invalidations BEFORE the interrupt are finished.
// I provided a command line argument to disable this check.
  if(spc5_skid_d3 & enable_ifu_lsu_inv_clear)
     finish_test("spc", "tso_mon:   spc5_ifu_lsu_inv_clear should have been clear by now", 5);

  spc5_dva_svld_e_d1 	<= spc5_dva_svld_e;
  spc5_dva_rvld_e_d1 	<= spc5_dva_rvld_e;
  spc5_dva_rd_addr_e_d1 	<= spc5_dva_rd_addr_e;
  spc5_dva_snp_addr_e_d1 	<= spc5_dva_snp_addr_e;

  if(spc5_dva_svld_e_d1 & spc5_dva_rvld_e & (spc5_dva_rd_addr_e_d1[10:6] == spc5_dva_snp_addr_e[4:0]))
    spc5_lsu_rd_after_snp <= 1'b1;
  else 
    spc5_lsu_rd_after_snp <= 1'b0;

  if(spc5_dva_svld_e & spc5_dva_rvld_e_d1 & (spc5_dva_rd_addr_e[10:6] == spc5_dva_snp_addr_e_d1[4:0]))
    spc5_lsu_snp_after_rd <= 1'b1;
  else 
    spc5_lsu_snp_after_rd <= 1'b0;

  spc5_ldst_fp_m <= spc5_ldst_fp_e;
  spc5_ldst_fp_g <= spc5_ldst_fp_m;

  if(spc5_stb_data_rptr_vld & spc5_stb_data_wptr_vld & ~spc5_stbrwctl_flush_pipe_w &
     (spc5_stb_data_rd_ptr == spc5_stb_data_wr_ptr) & spc5_lsu_st_pcx_rq_pick)
  begin
    finish_test("spc", "tso_mon: LSU stb data write and read in the same cycle", 5);
  end

   spc5_multiple_hits = (spc5_lsu_way_hit[3] + spc5_lsu_way_hit[2] + spc5_lsu_way_hit[1] + spc5_lsu_way_hit[0]);
   if(!spc5_lsu_ifu_ldst_miss_w && (spc5_multiple_hits >1) && spc5_inst_vld_w && !spc5_dctl_flush_pipe_w && !spc5_lsu_dc_tag_pe_g_unmasked_or)
     finish_test("spc", "tso_mon: LSU multiple hits ", 5);
end

wire spc5_ld_dbl      = spc5_ld_inst_vld_g &  spc5_ldst_dbl_g &  ~spc5_quad_asi_g;
wire spc5_ld_quad     = spc5_ld_inst_vld_g &  spc5_ldst_dbl_g &  spc5_quad_asi_g;
wire spc5_ld_other    = spc5_ld_inst_vld_g & ~spc5_ldst_dbl_g;

wire spc5_ld_dbl_fp   = spc5_ld_dbl        &  spc5_ldst_fp_g;
wire spc5_ld_other_fp = spc5_ld_other      &  spc5_ldst_fp_g;

wire spc5_ld_dbl_int  = spc5_ld_dbl        & ~spc5_ldst_fp_g;
wire spc5_ld_quad_int = spc5_ld_quad       & ~spc5_ldst_fp_g;
wire spc5_ld_other_int= spc5_ld_other      & ~spc5_ldst_fp_g;

wire spc5_ld_bypassok_hit = |spc5_stb_ld_full_raw[7:0] & ~spc5_stb_cam_mhit;
wire spc5_ld_partial_hit  = |spc5_stb_ld_partial_raw[7:0] & ~spc5_stb_cam_mhit;
wire spc5_ld_multiple_hit =  spc5_stb_cam_mhit;

wire spc5_any_lsu_way_hit = |spc5_lsu_way_hit;

wire [7:0] spc5_stb_rdptr_decoded = 	(spc5_stb_rdptr ==3'b000) ? 8'b00000001 :
                               		(spc5_stb_rdptr ==3'b001) ? 8'b00000010 :
                               		(spc5_stb_rdptr ==3'b010) ? 8'b00000100 :
                              		(spc5_stb_rdptr ==3'b011) ? 8'b00001000 :
                              		(spc5_stb_rdptr ==3'b100) ? 8'b00010000 :
                              		(spc5_stb_rdptr ==3'b101) ? 8'b00100000 :
                             		(spc5_stb_rdptr ==3'b110) ? 8'b01000000 :
                              		(spc5_stb_rdptr ==3'b111) ? 8'b10000000 : 8'h00;


wire spc5_stb_top_hit = |(spc5_stb_rdptr_decoded & (spc5_stb_ld_full_raw | spc5_stb_ld_partial_raw));

//---------------------------------------------------------------------
// ld_type[4:0] hit_type[2:0], cache_hit, hit_top
// this is passed to the coverage monitor.
//---------------------------------------------------------------------
wire [10:0] spc5_stb_ld_hit_info = 
	{spc5_ld_dbl_fp,        spc5_ld_other_fp,
	 spc5_ld_dbl_int, 	   spc5_ld_quad_int,    spc5_ld_other_int,
	 spc5_ld_bypassok_hit,  spc5_ld_partial_hit, spc5_ld_multiple_hit,
	 spc5_any_lsu_way_hit,
	 spc5_stb_top_hit, C5_st_ack_w};

reg spc5_mbar0_active;
reg spc5_mbar1_active;
reg spc5_mbar2_active;
reg spc5_mbar3_active;

reg spc5_flush0_active;
reg spc5_flush1_active;
reg spc5_flush2_active;
reg spc5_flush3_active;

reg spc5_intr0_active;
reg spc5_intr1_active;
reg spc5_intr2_active;
reg spc5_intr3_active;

always @(negedge clk)
begin
  if(~rst_l)
  begin
     spc5_mbar0_active <= 1'b0;
     spc5_mbar1_active <= 1'b0;
     spc5_mbar2_active <= 1'b0;
     spc5_mbar3_active <= 1'b0;

     spc5_flush0_active <= 1'b0;
     spc5_flush1_active <= 1'b0;
     spc5_flush2_active <= 1'b0;
     spc5_flush3_active <= 1'b0;

     spc5_intr0_active <= 1'b0;
     spc5_intr1_active <= 1'b0;
     spc5_intr2_active <= 1'b0;
     spc5_intr3_active <= 1'b0;

  end
  else
  begin
    if(spc5_mbar_inst0_g & ~spc5_dctl_flush_pipe_w & (C5T0_stb_ne|~spc5_no_spc_rmo_st[0]))
	spc5_mbar0_active <= 1'b1;
    else if(~C5T0_stb_ne & spc5_no_spc_rmo_st[0])
	spc5_mbar0_active <= 1'b0;
    if(spc5_mbar_inst1_g & ~ spc5_dctl_flush_pipe_w & (C5T1_stb_ne|~spc5_no_spc_rmo_st[1]))
	spc5_mbar1_active <= 1'b1;
    else if(~C5T1_stb_ne & spc5_no_spc_rmo_st[1])
	spc5_mbar1_active <= 1'b0;
    if(spc5_mbar_inst2_g & ~ spc5_dctl_flush_pipe_w & (C5T2_stb_ne|~spc5_no_spc_rmo_st[2]))
	spc5_mbar2_active <= 1'b1;
    else if(~C5T2_stb_ne & spc5_no_spc_rmo_st[2])
	spc5_mbar2_active <= 1'b0;
    if(spc5_mbar_inst3_g & ~ spc5_dctl_flush_pipe_w & (C5T3_stb_ne|~spc5_no_spc_rmo_st[3]))
	spc5_mbar3_active <= 1'b1;
    else if(~C5T3_stb_ne & spc5_no_spc_rmo_st[3])
	spc5_mbar3_active <= 1'b0;

    if(spc5_flush_inst0_g & ~spc5_dctl_flush_pipe_w & C5T0_stb_ne) 	spc5_flush0_active <= 1'b1;
    else if(~C5T0_stb_ne)			  				spc5_flush0_active <= 1'b0;
    if(spc5_flush_inst1_g & ~spc5_dctl_flush_pipe_w & C5T1_stb_ne) 	spc5_flush1_active <= 1'b1;
    else if(~C5T1_stb_ne)			  				spc5_flush1_active <= 1'b0;
    if(spc5_flush_inst2_g & ~spc5_dctl_flush_pipe_w & C5T2_stb_ne) 	spc5_flush2_active <= 1'b1;
    else if(~C5T2_stb_ne)			  				spc5_flush2_active <= 1'b0;
    if(spc5_flush_inst3_g & ~spc5_dctl_flush_pipe_w & C5T3_stb_ne) 	spc5_flush3_active <= 1'b1;
    else if(~C5T3_stb_ne)			  				spc5_flush3_active <= 1'b0;

    if(spc5_intrpt_disp_asi0_g & spc5_st_inst_vld_g & ~spc5_non_altspace_ldst_g & ~spc5_dctl_flush_pipe_w & C5T0_stb_ne)
	spc5_intr0_active <= 1'b1;
    else if(~C5T0_stb_ne)			  				
	spc5_intr0_active <= 1'b0;
    if(spc5_intrpt_disp_asi1_g &  spc5_st_inst_vld_g & ~spc5_non_altspace_ldst_g & ~spc5_dctl_flush_pipe_w & C5T1_stb_ne)
	spc5_intr1_active <= 1'b1;
    else if(~C5T1_stb_ne)
	spc5_intr1_active <= 1'b0;
    if(spc5_intrpt_disp_asi2_g &  spc5_st_inst_vld_g & ~spc5_non_altspace_ldst_g & ~spc5_dctl_flush_pipe_w & C5T2_stb_ne)
	spc5_intr2_active <= 1'b1;
    else if(~C5T2_stb_ne)
	spc5_intr2_active <= 1'b0;
    if(spc5_intrpt_disp_asi3_g &  spc5_st_inst_vld_g & ~spc5_non_altspace_ldst_g & ~spc5_dctl_flush_pipe_w & C5T3_stb_ne)
	spc5_intr3_active <= 1'b1;
    else if(~C5T3_stb_ne)
	spc5_intr3_active <= 1'b0;
  end

  if(spc5_mbar0_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "membar violation thread 0", 5);
  if(spc5_mbar1_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "membar violation thread 1", 5);
  if(spc5_mbar2_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "membar violation thread 2", 5);
  if(spc5_mbar3_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "membar violation thread 3", 5);

  if(spc5_flush0_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "flush violation thread 0", 5);
  if(spc5_flush1_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "flush violation thread 1", 5);
  if(spc5_flush2_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "flush violation thread 2", 5);
  if(spc5_flush3_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "flush violation thread 3", 5);

  if(spc5_intr0_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "intr violation thread 0", 5);
  if(spc5_intr1_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "intr violation thread 1", 5);
  if(spc5_intr2_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "intr violation thread 2", 5);
  if(spc5_intr3_active & spc5_inst_vld_w & spc5_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "intr violation thread 3", 5);

   if(~rst_l | ~C5T0_stb_full | sctag_pcx_stall_pq) 	C5T0_stb_drain_cnt = 0;
   else							C5T0_stb_drain_cnt = C5T0_stb_drain_cnt + 1;
   if(C5T0_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 0 is not draining", 5);

   if(~rst_l | ~C5T1_stb_full | sctag_pcx_stall_pq) 	C5T1_stb_drain_cnt = 0;
   else							C5T1_stb_drain_cnt = C5T1_stb_drain_cnt + 1;
   if(C5T1_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 1 is not draining", 5);

   if(~rst_l | ~C5T2_stb_full | sctag_pcx_stall_pq) 	C5T2_stb_drain_cnt = 0;
   else							C5T2_stb_drain_cnt = C5T2_stb_drain_cnt + 1;
   if(C5T2_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 2 is not draining", 5);

   if(~rst_l | ~C5T3_stb_full | sctag_pcx_stall_pq) 	C5T3_stb_drain_cnt = 0;
   else							C5T3_stb_drain_cnt = C5T3_stb_drain_cnt + 1;
   if(C5T3_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 3 is not draining", 5);

  C5T0_stb_vld_sum_d1 <= C5T0_stb_vld_sum;
  C5T1_stb_vld_sum_d1 <= C5T1_stb_vld_sum;
  C5T2_stb_vld_sum_d1 <= C5T2_stb_vld_sum;
  C5T3_stb_vld_sum_d1 <= C5T3_stb_vld_sum;
  C5T0_defr_trp_en_d1 <= C5T0_defr_trp_en;
  C5T1_defr_trp_en_d1 <= C5T1_defr_trp_en;
  C5T2_defr_trp_en_d1 <= C5T2_defr_trp_en;
  C5T3_defr_trp_en_d1 <= C5T3_defr_trp_en;

  if(rst_l & C5T0_defr_trp_en_d1 & (C5T0_stb_vld_sum_d1 < C5T0_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T0", 5);
  if(rst_l & C5T1_defr_trp_en_d1 & (C5T1_stb_vld_sum_d1 < C5T1_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T1", 5);
  if(rst_l & C5T2_defr_trp_en_d1 & (C5T2_stb_vld_sum_d1 < C5T2_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T2", 5);
  if(rst_l & C5T3_defr_trp_en_d1 & (C5T3_stb_vld_sum_d1 < C5T3_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T3", 5);
 
end

`endif // ifdef RTL_SPARC5
`ifdef RTL_SPARC6
wire   C6T0_stb_ne    = |`TOP_DESIGN.sparc6.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C6T1_stb_ne    = |`TOP_DESIGN.sparc6.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C6T2_stb_ne    = |`TOP_DESIGN.sparc6.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C6T3_stb_ne    = |`TOP_DESIGN.sparc6.lsu.stb_ctl3.stb_state_vld[7:0];

wire   C6T0_stb_nced  = |(	 `TOP_DESIGN.sparc6.lsu.stb_ctl0.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc6.lsu.stb_ctl0.stb_state_ced[7:0]);
wire   C6T1_stb_nced  = |(	 `TOP_DESIGN.sparc6.lsu.stb_ctl1.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc6.lsu.stb_ctl1.stb_state_ced[7:0]);
wire   C6T2_stb_nced  = |(	 `TOP_DESIGN.sparc6.lsu.stb_ctl2.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc6.lsu.stb_ctl2.stb_state_ced[7:0]);
wire   C6T3_stb_nced  = |(	 `TOP_DESIGN.sparc6.lsu.stb_ctl3.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc6.lsu.stb_ctl3.stb_state_ced[7:0]);

`else
wire   C6T0_stb_ne    = 1'b0;
wire   C6T1_stb_ne    = 1'b0;
wire   C6T2_stb_ne    = 1'b0;
wire   C6T3_stb_ne    = 1'b0;

wire   C6T0_stb_nced  = 1'b0;
wire   C6T1_stb_nced  = 1'b0;
wire   C6T2_stb_nced  = 1'b0;
wire   C6T3_stb_nced  = 1'b0;
`endif // ifdef RTL_SPARC6

`ifdef RTL_SPARC6

wire   spc6_lsu_ifill_pkt_vld	= `TOP_DESIGN.sparc6.lsu.qctl2.lsu_ifill_pkt_vld;
wire   spc6_dfq_rd_advance  		= `TOP_DESIGN.sparc6.lsu.qctl2.dfq_rd_advance;
wire   spc6_dfq_int_type  		= `TOP_DESIGN.sparc6.lsu.qctl2.dfq_int_type;

wire   spc6_ifu_lsu_inv_clear	= `TOP_DESIGN.sparc6.lsu.qctl2.ifu_lsu_inv_clear;

wire 	    spc6_dva_svld_e 	 	= `TOP_DESIGN.sparc6.lsu.qctl2.dva_svld_e;
wire 	    spc6_dva_rvld_e	 	= `TOP_DESIGN.sparc6.lsu.dva.rd_en;
wire [10:4] spc6_dva_rd_addr_e  	= `TOP_DESIGN.sparc6.lsu.dva.rd_adr1[6:0];
wire [4:0]  spc6_dva_snp_addr_e 	= `TOP_DESIGN.sparc6.lsu.qctl2.dva_snp_addr_e[4:0];

wire [4:0]  spc6_stb_data_rd_ptr   	= `TOP_DESIGN.sparc6.lsu.stb_data_rd_ptr[4:0];
wire [4:0]  spc6_stb_data_wr_ptr   	= `TOP_DESIGN.sparc6.lsu.stb_data_wr_ptr[4:0];
wire        spc6_stb_data_wptr_vld 	= `TOP_DESIGN.sparc6.lsu.stb_data_wptr_vld;
wire        spc6_stb_data_rptr_vld 	= `TOP_DESIGN.sparc6.lsu.stb_data_rptr_vld;
wire        spc6_stbrwctl_flush_pipe_w = `TOP_DESIGN.sparc6.lsu.stb_rwctl.lsu_stbrwctl_flush_pipe_w;
wire        spc6_lsu_st_pcx_rq_pick 	= |`TOP_DESIGN.sparc6.lsu.stb_rwctl.lsu_st_pcx_rq_pick[3:0];

wire [3:0]  spc6_lsu_rd_dtag_parity_g = `TOP_DESIGN.sparc6.lsu.dctl.lsu_rd_dtag_parity_g[3:0];
wire [3:0]  spc6_dva_vld_g		 = `TOP_DESIGN.sparc6.lsu.dctl.dva_vld_g[3:0];

wire [3:0]  spc6_lsu_dc_tag_pe_g_unmasked    = spc6_lsu_rd_dtag_parity_g[3:0] & spc6_dva_vld_g[3:0];
wire        spc6_lsu_dc_tag_pe_g_unmasked_or = |spc6_lsu_dc_tag_pe_g_unmasked[3:0];

wire   C6T0_stb_full  = &`TOP_DESIGN.sparc6.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C6T1_stb_full  = &`TOP_DESIGN.sparc6.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C6T2_stb_full  = &`TOP_DESIGN.sparc6.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C6T3_stb_full  = &`TOP_DESIGN.sparc6.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [7:0] C6T0_stb_vld  = `TOP_DESIGN.sparc6.lsu.stb_ctl0.stb_state_vld[7:0];
wire   [7:0] C6T1_stb_vld  = `TOP_DESIGN.sparc6.lsu.stb_ctl1.stb_state_vld[7:0];
wire   [7:0] C6T2_stb_vld  = `TOP_DESIGN.sparc6.lsu.stb_ctl2.stb_state_vld[7:0];
wire   [7:0] C6T3_stb_vld  = `TOP_DESIGN.sparc6.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [4:0] C6T0_stb_vld_sum  =  C6T0_stb_vld[0] +  C6T0_stb_vld[1] +  C6T0_stb_vld[2] +  C6T0_stb_vld[3] +
                                     C6T0_stb_vld[4] +  C6T0_stb_vld[5] +  C6T0_stb_vld[6] +  C6T0_stb_vld[7] ;
wire   [4:0] C6T1_stb_vld_sum  =  C6T1_stb_vld[0] +  C6T1_stb_vld[1] +  C6T1_stb_vld[2] +  C6T1_stb_vld[3] +
                                     C6T1_stb_vld[4] +  C6T1_stb_vld[5] +  C6T1_stb_vld[6] +  C6T1_stb_vld[7] ;
wire   [4:0] C6T2_stb_vld_sum  =  C6T2_stb_vld[0] +  C6T2_stb_vld[1] +  C6T2_stb_vld[2] +  C6T2_stb_vld[3] +
                                     C6T2_stb_vld[4] +  C6T2_stb_vld[5] +  C6T2_stb_vld[6] +  C6T2_stb_vld[7] ;
wire   [4:0] C6T3_stb_vld_sum  =  C6T3_stb_vld[0] +  C6T3_stb_vld[1] +  C6T3_stb_vld[2] +  C6T3_stb_vld[3] +
                                     C6T3_stb_vld[4] +  C6T3_stb_vld[5] +  C6T3_stb_vld[6] +  C6T3_stb_vld[7] ;

reg [4:0] C6T0_stb_vld_sum_d1;
reg [4:0] C6T1_stb_vld_sum_d1;
reg [4:0] C6T2_stb_vld_sum_d1;
reg [4:0] C6T3_stb_vld_sum_d1;

wire   C6T0_st_ack  = &`TOP_DESIGN.sparc6.lsu.cpx_st_ack_tid0;
wire   C6T1_st_ack  = &`TOP_DESIGN.sparc6.lsu.cpx_st_ack_tid1;
wire   C6T2_st_ack  = &`TOP_DESIGN.sparc6.lsu.cpx_st_ack_tid2;
wire   C6T3_st_ack  = &`TOP_DESIGN.sparc6.lsu.cpx_st_ack_tid3;

wire   C6T0_defr_trp_en	= &`TOP_DESIGN.sparc6.lsu.excpctl.st_defr_trp_en0;
wire   C6T1_defr_trp_en	= &`TOP_DESIGN.sparc6.lsu.excpctl.st_defr_trp_en1;
wire   C6T2_defr_trp_en	= &`TOP_DESIGN.sparc6.lsu.excpctl.st_defr_trp_en2;
wire   C6T3_defr_trp_en	= &`TOP_DESIGN.sparc6.lsu.excpctl.st_defr_trp_en3;

reg C6T0_defr_trp_en_d1;
reg C6T1_defr_trp_en_d1;
reg C6T2_defr_trp_en_d1;
reg C6T3_defr_trp_en_d1;

integer C6T0_stb_drain_cnt;
integer C6T1_stb_drain_cnt;
integer C6T2_stb_drain_cnt;
integer C6T3_stb_drain_cnt;

// Hits in the store buffer
//-------------------------
wire       spc6_inst_vld_w		= `TOP_DESIGN.sparc6.ifu.fcl.inst_vld_w;
wire [1:0] spc6_sas_thrid_w		= `TOP_DESIGN.sparc6.ifu.fcl.sas_thrid_w[1:0];

wire C6_st_ack_w = (spc6_sas_thrid_w == 2'b00) & C6T0_st_ack |
                      (spc6_sas_thrid_w == 2'b01) & C6T1_st_ack |
                      (spc6_sas_thrid_w == 2'b10) & C6T2_st_ack |
                      (spc6_sas_thrid_w == 2'b11) & C6T3_st_ack;

wire [7:0] spc6_stb_ld_full_raw	= `TOP_DESIGN.sparc6.lsu.stb_ld_full_raw[7:0];
wire [7:0] spc6_stb_ld_partial_raw	= `TOP_DESIGN.sparc6.lsu.stb_ld_partial_raw[7:0];
wire       spc6_stb_cam_mhit		= `TOP_DESIGN.sparc6.lsu.stb_cam_mhit;
wire       spc6_stb_cam_hit		= `TOP_DESIGN.sparc6.lsu.stb_cam_hit;
wire [3:0] spc6_lsu_way_hit		= `TOP_DESIGN.sparc6.lsu.dctl.lsu_way_hit[3:0];
wire       spc6_lsu_ifu_ldst_miss_w	= `TOP_DESIGN.sparc6.lsu.lsu_ifu_ldst_miss_w;
wire       spc6_ld_inst_vld_g	= `TOP_DESIGN.sparc6.lsu.dctl.ld_inst_vld_g;
wire       spc6_ldst_dbl_g		= `TOP_DESIGN.sparc6.lsu.dctl.ldst_dbl_g;
wire       spc6_quad_asi_g		= `TOP_DESIGN.sparc6.lsu.dctl.quad_asi_g;
wire [1:0] spc6_ldst_sz_g		= `TOP_DESIGN.sparc6.lsu.dctl.ldst_sz_g;
wire       spc6_lsu_alt_space_g	= `TOP_DESIGN.sparc6.lsu.dctl.lsu_alt_space_g;

wire       spc6_mbar_inst0_g		= `TOP_DESIGN.sparc6.lsu.dctl.mbar_inst0_g;
wire       spc6_mbar_inst1_g		= `TOP_DESIGN.sparc6.lsu.dctl.mbar_inst1_g;
wire       spc6_mbar_inst2_g		= `TOP_DESIGN.sparc6.lsu.dctl.mbar_inst2_g;
wire       spc6_mbar_inst3_g		= `TOP_DESIGN.sparc6.lsu.dctl.mbar_inst3_g;

wire       spc6_flush_inst0_g	= `TOP_DESIGN.sparc6.lsu.dctl.flush_inst0_g;
wire       spc6_flush_inst1_g	= `TOP_DESIGN.sparc6.lsu.dctl.flush_inst1_g;
wire       spc6_flush_inst2_g	= `TOP_DESIGN.sparc6.lsu.dctl.flush_inst2_g;
wire       spc6_flush_inst3_g	= `TOP_DESIGN.sparc6.lsu.dctl.flush_inst3_g;

wire       spc6_intrpt_disp_asi0_g	= `TOP_DESIGN.sparc6.lsu.dctl.intrpt_disp_asi_g & (spc6_sas_thrid_w == 2'b00);
wire       spc6_intrpt_disp_asi1_g	= `TOP_DESIGN.sparc6.lsu.dctl.intrpt_disp_asi_g & (spc6_sas_thrid_w == 2'b01);
wire       spc6_intrpt_disp_asi2_g	= `TOP_DESIGN.sparc6.lsu.dctl.intrpt_disp_asi_g & (spc6_sas_thrid_w == 2'b10);
wire       spc6_intrpt_disp_asi3_g	= `TOP_DESIGN.sparc6.lsu.dctl.intrpt_disp_asi_g & (spc6_sas_thrid_w == 2'b11);

wire       spc6_st_inst_vld_g	= `TOP_DESIGN.sparc6.lsu.dctl.st_inst_vld_g;
wire       spc6_non_altspace_ldst_g	= `TOP_DESIGN.sparc6.lsu.dctl.non_altspace_ldst_g;

wire       spc6_dctl_flush_pipe_w	= `TOP_DESIGN.sparc6.lsu.dctl.dctl_flush_pipe_w;

wire [3:0] spc6_no_spc_rmo_st	= `TOP_DESIGN.sparc6.lsu.dctl.no_spc_rmo_st[3:0];


wire       spc6_ldst_fp_e		= `TOP_DESIGN.sparc6.lsu.ifu_lsu_ldst_fp_e;
wire [2:0] spc6_stb_rdptr		= `TOP_DESIGN.sparc6.lsu.stb_rwctl.stb_rdptr_l;

wire 	   spc6_ld_l2cache_req 	= `TOP_DESIGN.sparc6.lsu.qctl1.ld3_l2cache_rq |
					  `TOP_DESIGN.sparc6.lsu.qctl1.ld2_l2cache_rq |
                 			  `TOP_DESIGN.sparc6.lsu.qctl1.ld1_l2cache_rq |
					  `TOP_DESIGN.sparc6.lsu.qctl1.ld0_l2cache_rq;

wire [3:0] spc6_dcache_enable	= {`TOP_DESIGN.sparc6.lsu.dctl.lsu_ctl_reg0[1],
                                    	   `TOP_DESIGN.sparc6.lsu.dctl.lsu_ctl_reg1[1],
					   `TOP_DESIGN.sparc6.lsu.dctl.lsu_ctl_reg2[1],
					   `TOP_DESIGN.sparc6.lsu.dctl.lsu_ctl_reg3[1]};

wire [3:0] spc6_icache_enable	= `TOP_DESIGN.sparc6.lsu.lsu_ifu_icache_en[3:0];

wire spc6_dc_direct_map 		= `TOP_DESIGN.sparc6.lsu.dc_direct_map;
wire spc6_lsu_ifu_direct_map_l1	= `TOP_DESIGN.sparc6.lsu.lsu_ifu_direct_map_l1;

always @(spc6_dcache_enable)
    $display("%0d tso_mon: spc6_dcache_enable changed to %x", $time, spc6_dcache_enable);

always @(spc6_icache_enable)
    $display("%0d tso_mon: spc6_icache_enable changed to %x", $time, spc6_icache_enable);

always @(spc6_dc_direct_map)
    $display("%0d tso_mon: spc6_dc_direct_map changed to %x", $time, spc6_dc_direct_map);

always @(spc6_lsu_ifu_direct_map_l1)
   $display("%0d tso_mon: spc6_lsu_ifu_direct_map_l1 changed to %x", $time, spc6_lsu_ifu_direct_map_l1);

reg 		spc6_dva_svld_e_d1;
reg 		spc6_dva_rvld_e_d1;
reg [10:4] 	spc6_dva_rd_addr_e_d1;
reg [4:0]  	spc6_dva_snp_addr_e_d1;

reg   		spc6_lsu_snp_after_rd;
reg   		spc6_lsu_rd_after_snp;

reg 	   	spc6_ldst_fp_m, spc6_ldst_fp_g;

integer 	spc6_multiple_hits;

reg spc6_skid_d1, spc6_skid_d2, spc6_skid_d3;
initial begin
  spc6_skid_d1 = 0;
  spc6_skid_d2 = 0;
  spc6_skid_d3 = 0;
end

always @(posedge clk)
begin

  spc6_skid_d1 <= (~spc6_ifu_lsu_inv_clear & spc6_dfq_rd_advance & spc6_dfq_int_type);
  spc6_skid_d2 <= spc6_skid_d1 & ~spc6_ifu_lsu_inv_clear;
  spc6_skid_d3 <= spc6_skid_d2 & ~spc6_ifu_lsu_inv_clear;

// The full tracking of this condition is complicated since after the interrupt is advanced
// there may be more invalidations to the IFQ.
// All we care about is that the invalidations BEFORE the interrupt are finished.
// I provided a command line argument to disable this check.
  if(spc6_skid_d3 & enable_ifu_lsu_inv_clear)
     finish_test("spc", "tso_mon:   spc6_ifu_lsu_inv_clear should have been clear by now", 6);

  spc6_dva_svld_e_d1 	<= spc6_dva_svld_e;
  spc6_dva_rvld_e_d1 	<= spc6_dva_rvld_e;
  spc6_dva_rd_addr_e_d1 	<= spc6_dva_rd_addr_e;
  spc6_dva_snp_addr_e_d1 	<= spc6_dva_snp_addr_e;

  if(spc6_dva_svld_e_d1 & spc6_dva_rvld_e & (spc6_dva_rd_addr_e_d1[10:6] == spc6_dva_snp_addr_e[4:0]))
    spc6_lsu_rd_after_snp <= 1'b1;
  else 
    spc6_lsu_rd_after_snp <= 1'b0;

  if(spc6_dva_svld_e & spc6_dva_rvld_e_d1 & (spc6_dva_rd_addr_e[10:6] == spc6_dva_snp_addr_e_d1[4:0]))
    spc6_lsu_snp_after_rd <= 1'b1;
  else 
    spc6_lsu_snp_after_rd <= 1'b0;

  spc6_ldst_fp_m <= spc6_ldst_fp_e;
  spc6_ldst_fp_g <= spc6_ldst_fp_m;

  if(spc6_stb_data_rptr_vld & spc6_stb_data_wptr_vld & ~spc6_stbrwctl_flush_pipe_w &
     (spc6_stb_data_rd_ptr == spc6_stb_data_wr_ptr) & spc6_lsu_st_pcx_rq_pick)
  begin
    finish_test("spc", "tso_mon: LSU stb data write and read in the same cycle", 6);
  end

   spc6_multiple_hits = (spc6_lsu_way_hit[3] + spc6_lsu_way_hit[2] + spc6_lsu_way_hit[1] + spc6_lsu_way_hit[0]);
   if(!spc6_lsu_ifu_ldst_miss_w && (spc6_multiple_hits >1) && spc6_inst_vld_w && !spc6_dctl_flush_pipe_w && !spc6_lsu_dc_tag_pe_g_unmasked_or)
     finish_test("spc", "tso_mon: LSU multiple hits ", 6);
end

wire spc6_ld_dbl      = spc6_ld_inst_vld_g &  spc6_ldst_dbl_g &  ~spc6_quad_asi_g;
wire spc6_ld_quad     = spc6_ld_inst_vld_g &  spc6_ldst_dbl_g &  spc6_quad_asi_g;
wire spc6_ld_other    = spc6_ld_inst_vld_g & ~spc6_ldst_dbl_g;

wire spc6_ld_dbl_fp   = spc6_ld_dbl        &  spc6_ldst_fp_g;
wire spc6_ld_other_fp = spc6_ld_other      &  spc6_ldst_fp_g;

wire spc6_ld_dbl_int  = spc6_ld_dbl        & ~spc6_ldst_fp_g;
wire spc6_ld_quad_int = spc6_ld_quad       & ~spc6_ldst_fp_g;
wire spc6_ld_other_int= spc6_ld_other      & ~spc6_ldst_fp_g;

wire spc6_ld_bypassok_hit = |spc6_stb_ld_full_raw[7:0] & ~spc6_stb_cam_mhit;
wire spc6_ld_partial_hit  = |spc6_stb_ld_partial_raw[7:0] & ~spc6_stb_cam_mhit;
wire spc6_ld_multiple_hit =  spc6_stb_cam_mhit;

wire spc6_any_lsu_way_hit = |spc6_lsu_way_hit;

wire [7:0] spc6_stb_rdptr_decoded = 	(spc6_stb_rdptr ==3'b000) ? 8'b00000001 :
                               		(spc6_stb_rdptr ==3'b001) ? 8'b00000010 :
                               		(spc6_stb_rdptr ==3'b010) ? 8'b00000100 :
                              		(spc6_stb_rdptr ==3'b011) ? 8'b00001000 :
                              		(spc6_stb_rdptr ==3'b100) ? 8'b00010000 :
                              		(spc6_stb_rdptr ==3'b101) ? 8'b00100000 :
                             		(spc6_stb_rdptr ==3'b110) ? 8'b01000000 :
                              		(spc6_stb_rdptr ==3'b111) ? 8'b10000000 : 8'h00;


wire spc6_stb_top_hit = |(spc6_stb_rdptr_decoded & (spc6_stb_ld_full_raw | spc6_stb_ld_partial_raw));

//---------------------------------------------------------------------
// ld_type[4:0] hit_type[2:0], cache_hit, hit_top
// this is passed to the coverage monitor.
//---------------------------------------------------------------------
wire [10:0] spc6_stb_ld_hit_info = 
	{spc6_ld_dbl_fp,        spc6_ld_other_fp,
	 spc6_ld_dbl_int, 	   spc6_ld_quad_int,    spc6_ld_other_int,
	 spc6_ld_bypassok_hit,  spc6_ld_partial_hit, spc6_ld_multiple_hit,
	 spc6_any_lsu_way_hit,
	 spc6_stb_top_hit, C6_st_ack_w};

reg spc6_mbar0_active;
reg spc6_mbar1_active;
reg spc6_mbar2_active;
reg spc6_mbar3_active;

reg spc6_flush0_active;
reg spc6_flush1_active;
reg spc6_flush2_active;
reg spc6_flush3_active;

reg spc6_intr0_active;
reg spc6_intr1_active;
reg spc6_intr2_active;
reg spc6_intr3_active;

always @(negedge clk)
begin
  if(~rst_l)
  begin
     spc6_mbar0_active <= 1'b0;
     spc6_mbar1_active <= 1'b0;
     spc6_mbar2_active <= 1'b0;
     spc6_mbar3_active <= 1'b0;

     spc6_flush0_active <= 1'b0;
     spc6_flush1_active <= 1'b0;
     spc6_flush2_active <= 1'b0;
     spc6_flush3_active <= 1'b0;

     spc6_intr0_active <= 1'b0;
     spc6_intr1_active <= 1'b0;
     spc6_intr2_active <= 1'b0;
     spc6_intr3_active <= 1'b0;

  end
  else
  begin
    if(spc6_mbar_inst0_g & ~spc6_dctl_flush_pipe_w & (C6T0_stb_ne|~spc6_no_spc_rmo_st[0]))
	spc6_mbar0_active <= 1'b1;
    else if(~C6T0_stb_ne & spc6_no_spc_rmo_st[0])
	spc6_mbar0_active <= 1'b0;
    if(spc6_mbar_inst1_g & ~ spc6_dctl_flush_pipe_w & (C6T1_stb_ne|~spc6_no_spc_rmo_st[1]))
	spc6_mbar1_active <= 1'b1;
    else if(~C6T1_stb_ne & spc6_no_spc_rmo_st[1])
	spc6_mbar1_active <= 1'b0;
    if(spc6_mbar_inst2_g & ~ spc6_dctl_flush_pipe_w & (C6T2_stb_ne|~spc6_no_spc_rmo_st[2]))
	spc6_mbar2_active <= 1'b1;
    else if(~C6T2_stb_ne & spc6_no_spc_rmo_st[2])
	spc6_mbar2_active <= 1'b0;
    if(spc6_mbar_inst3_g & ~ spc6_dctl_flush_pipe_w & (C6T3_stb_ne|~spc6_no_spc_rmo_st[3]))
	spc6_mbar3_active <= 1'b1;
    else if(~C6T3_stb_ne & spc6_no_spc_rmo_st[3])
	spc6_mbar3_active <= 1'b0;

    if(spc6_flush_inst0_g & ~spc6_dctl_flush_pipe_w & C6T0_stb_ne) 	spc6_flush0_active <= 1'b1;
    else if(~C6T0_stb_ne)			  				spc6_flush0_active <= 1'b0;
    if(spc6_flush_inst1_g & ~spc6_dctl_flush_pipe_w & C6T1_stb_ne) 	spc6_flush1_active <= 1'b1;
    else if(~C6T1_stb_ne)			  				spc6_flush1_active <= 1'b0;
    if(spc6_flush_inst2_g & ~spc6_dctl_flush_pipe_w & C6T2_stb_ne) 	spc6_flush2_active <= 1'b1;
    else if(~C6T2_stb_ne)			  				spc6_flush2_active <= 1'b0;
    if(spc6_flush_inst3_g & ~spc6_dctl_flush_pipe_w & C6T3_stb_ne) 	spc6_flush3_active <= 1'b1;
    else if(~C6T3_stb_ne)			  				spc6_flush3_active <= 1'b0;

    if(spc6_intrpt_disp_asi0_g & spc6_st_inst_vld_g & ~spc6_non_altspace_ldst_g & ~spc6_dctl_flush_pipe_w & C6T0_stb_ne)
	spc6_intr0_active <= 1'b1;
    else if(~C6T0_stb_ne)			  				
	spc6_intr0_active <= 1'b0;
    if(spc6_intrpt_disp_asi1_g &  spc6_st_inst_vld_g & ~spc6_non_altspace_ldst_g & ~spc6_dctl_flush_pipe_w & C6T1_stb_ne)
	spc6_intr1_active <= 1'b1;
    else if(~C6T1_stb_ne)
	spc6_intr1_active <= 1'b0;
    if(spc6_intrpt_disp_asi2_g &  spc6_st_inst_vld_g & ~spc6_non_altspace_ldst_g & ~spc6_dctl_flush_pipe_w & C6T2_stb_ne)
	spc6_intr2_active <= 1'b1;
    else if(~C6T2_stb_ne)
	spc6_intr2_active <= 1'b0;
    if(spc6_intrpt_disp_asi3_g &  spc6_st_inst_vld_g & ~spc6_non_altspace_ldst_g & ~spc6_dctl_flush_pipe_w & C6T3_stb_ne)
	spc6_intr3_active <= 1'b1;
    else if(~C6T3_stb_ne)
	spc6_intr3_active <= 1'b0;
  end

  if(spc6_mbar0_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "membar violation thread 0", 6);
  if(spc6_mbar1_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "membar violation thread 1", 6);
  if(spc6_mbar2_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "membar violation thread 2", 6);
  if(spc6_mbar3_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "membar violation thread 3", 6);

  if(spc6_flush0_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "flush violation thread 0", 6);
  if(spc6_flush1_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "flush violation thread 1", 6);
  if(spc6_flush2_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "flush violation thread 2", 6);
  if(spc6_flush3_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "flush violation thread 3", 6);

  if(spc6_intr0_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "intr violation thread 0", 6);
  if(spc6_intr1_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "intr violation thread 1", 6);
  if(spc6_intr2_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "intr violation thread 2", 6);
  if(spc6_intr3_active & spc6_inst_vld_w & spc6_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "intr violation thread 3", 6);

   if(~rst_l | ~C6T0_stb_full | sctag_pcx_stall_pq) 	C6T0_stb_drain_cnt = 0;
   else							C6T0_stb_drain_cnt = C6T0_stb_drain_cnt + 1;
   if(C6T0_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 0 is not draining", 6);

   if(~rst_l | ~C6T1_stb_full | sctag_pcx_stall_pq) 	C6T1_stb_drain_cnt = 0;
   else							C6T1_stb_drain_cnt = C6T1_stb_drain_cnt + 1;
   if(C6T1_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 1 is not draining", 6);

   if(~rst_l | ~C6T2_stb_full | sctag_pcx_stall_pq) 	C6T2_stb_drain_cnt = 0;
   else							C6T2_stb_drain_cnt = C6T2_stb_drain_cnt + 1;
   if(C6T2_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 2 is not draining", 6);

   if(~rst_l | ~C6T3_stb_full | sctag_pcx_stall_pq) 	C6T3_stb_drain_cnt = 0;
   else							C6T3_stb_drain_cnt = C6T3_stb_drain_cnt + 1;
   if(C6T3_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 3 is not draining", 6);

  C6T0_stb_vld_sum_d1 <= C6T0_stb_vld_sum;
  C6T1_stb_vld_sum_d1 <= C6T1_stb_vld_sum;
  C6T2_stb_vld_sum_d1 <= C6T2_stb_vld_sum;
  C6T3_stb_vld_sum_d1 <= C6T3_stb_vld_sum;
  C6T0_defr_trp_en_d1 <= C6T0_defr_trp_en;
  C6T1_defr_trp_en_d1 <= C6T1_defr_trp_en;
  C6T2_defr_trp_en_d1 <= C6T2_defr_trp_en;
  C6T3_defr_trp_en_d1 <= C6T3_defr_trp_en;

  if(rst_l & C6T0_defr_trp_en_d1 & (C6T0_stb_vld_sum_d1 < C6T0_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T0", 6);
  if(rst_l & C6T1_defr_trp_en_d1 & (C6T1_stb_vld_sum_d1 < C6T1_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T1", 6);
  if(rst_l & C6T2_defr_trp_en_d1 & (C6T2_stb_vld_sum_d1 < C6T2_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T2", 6);
  if(rst_l & C6T3_defr_trp_en_d1 & (C6T3_stb_vld_sum_d1 < C6T3_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T3", 6);
 
end

`endif // ifdef RTL_SPARC6
`ifdef RTL_SPARC7
wire   C7T0_stb_ne    = |`TOP_DESIGN.sparc7.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C7T1_stb_ne    = |`TOP_DESIGN.sparc7.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C7T2_stb_ne    = |`TOP_DESIGN.sparc7.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C7T3_stb_ne    = |`TOP_DESIGN.sparc7.lsu.stb_ctl3.stb_state_vld[7:0];

wire   C7T0_stb_nced  = |(	 `TOP_DESIGN.sparc7.lsu.stb_ctl0.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc7.lsu.stb_ctl0.stb_state_ced[7:0]);
wire   C7T1_stb_nced  = |(	 `TOP_DESIGN.sparc7.lsu.stb_ctl1.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc7.lsu.stb_ctl1.stb_state_ced[7:0]);
wire   C7T2_stb_nced  = |(	 `TOP_DESIGN.sparc7.lsu.stb_ctl2.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc7.lsu.stb_ctl2.stb_state_ced[7:0]);
wire   C7T3_stb_nced  = |(	 `TOP_DESIGN.sparc7.lsu.stb_ctl3.stb_state_vld[7:0] &
				~`TOP_DESIGN.sparc7.lsu.stb_ctl3.stb_state_ced[7:0]);

`else
wire   C7T0_stb_ne    = 1'b0;
wire   C7T1_stb_ne    = 1'b0;
wire   C7T2_stb_ne    = 1'b0;
wire   C7T3_stb_ne    = 1'b0;

wire   C7T0_stb_nced  = 1'b0;
wire   C7T1_stb_nced  = 1'b0;
wire   C7T2_stb_nced  = 1'b0;
wire   C7T3_stb_nced  = 1'b0;
`endif // ifdef RTL_SPARC7

`ifdef RTL_SPARC7

wire   spc7_lsu_ifill_pkt_vld	= `TOP_DESIGN.sparc7.lsu.qctl2.lsu_ifill_pkt_vld;
wire   spc7_dfq_rd_advance  		= `TOP_DESIGN.sparc7.lsu.qctl2.dfq_rd_advance;
wire   spc7_dfq_int_type  		= `TOP_DESIGN.sparc7.lsu.qctl2.dfq_int_type;

wire   spc7_ifu_lsu_inv_clear	= `TOP_DESIGN.sparc7.lsu.qctl2.ifu_lsu_inv_clear;

wire 	    spc7_dva_svld_e 	 	= `TOP_DESIGN.sparc7.lsu.qctl2.dva_svld_e;
wire 	    spc7_dva_rvld_e	 	= `TOP_DESIGN.sparc7.lsu.dva.rd_en;
wire [10:4] spc7_dva_rd_addr_e  	= `TOP_DESIGN.sparc7.lsu.dva.rd_adr1[6:0];
wire [4:0]  spc7_dva_snp_addr_e 	= `TOP_DESIGN.sparc7.lsu.qctl2.dva_snp_addr_e[4:0];

wire [4:0]  spc7_stb_data_rd_ptr   	= `TOP_DESIGN.sparc7.lsu.stb_data_rd_ptr[4:0];
wire [4:0]  spc7_stb_data_wr_ptr   	= `TOP_DESIGN.sparc7.lsu.stb_data_wr_ptr[4:0];
wire        spc7_stb_data_wptr_vld 	= `TOP_DESIGN.sparc7.lsu.stb_data_wptr_vld;
wire        spc7_stb_data_rptr_vld 	= `TOP_DESIGN.sparc7.lsu.stb_data_rptr_vld;
wire        spc7_stbrwctl_flush_pipe_w = `TOP_DESIGN.sparc7.lsu.stb_rwctl.lsu_stbrwctl_flush_pipe_w;
wire        spc7_lsu_st_pcx_rq_pick 	= |`TOP_DESIGN.sparc7.lsu.stb_rwctl.lsu_st_pcx_rq_pick[3:0];

wire [3:0]  spc7_lsu_rd_dtag_parity_g = `TOP_DESIGN.sparc7.lsu.dctl.lsu_rd_dtag_parity_g[3:0];
wire [3:0]  spc7_dva_vld_g		 = `TOP_DESIGN.sparc7.lsu.dctl.dva_vld_g[3:0];

wire [3:0]  spc7_lsu_dc_tag_pe_g_unmasked    = spc7_lsu_rd_dtag_parity_g[3:0] & spc7_dva_vld_g[3:0];
wire        spc7_lsu_dc_tag_pe_g_unmasked_or = |spc7_lsu_dc_tag_pe_g_unmasked[3:0];

wire   C7T0_stb_full  = &`TOP_DESIGN.sparc7.lsu.stb_ctl0.stb_state_vld[7:0];
wire   C7T1_stb_full  = &`TOP_DESIGN.sparc7.lsu.stb_ctl1.stb_state_vld[7:0];
wire   C7T2_stb_full  = &`TOP_DESIGN.sparc7.lsu.stb_ctl2.stb_state_vld[7:0];
wire   C7T3_stb_full  = &`TOP_DESIGN.sparc7.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [7:0] C7T0_stb_vld  = `TOP_DESIGN.sparc7.lsu.stb_ctl0.stb_state_vld[7:0];
wire   [7:0] C7T1_stb_vld  = `TOP_DESIGN.sparc7.lsu.stb_ctl1.stb_state_vld[7:0];
wire   [7:0] C7T2_stb_vld  = `TOP_DESIGN.sparc7.lsu.stb_ctl2.stb_state_vld[7:0];
wire   [7:0] C7T3_stb_vld  = `TOP_DESIGN.sparc7.lsu.stb_ctl3.stb_state_vld[7:0];

wire   [4:0] C7T0_stb_vld_sum  =  C7T0_stb_vld[0] +  C7T0_stb_vld[1] +  C7T0_stb_vld[2] +  C7T0_stb_vld[3] +
                                     C7T0_stb_vld[4] +  C7T0_stb_vld[5] +  C7T0_stb_vld[6] +  C7T0_stb_vld[7] ;
wire   [4:0] C7T1_stb_vld_sum  =  C7T1_stb_vld[0] +  C7T1_stb_vld[1] +  C7T1_stb_vld[2] +  C7T1_stb_vld[3] +
                                     C7T1_stb_vld[4] +  C7T1_stb_vld[5] +  C7T1_stb_vld[6] +  C7T1_stb_vld[7] ;
wire   [4:0] C7T2_stb_vld_sum  =  C7T2_stb_vld[0] +  C7T2_stb_vld[1] +  C7T2_stb_vld[2] +  C7T2_stb_vld[3] +
                                     C7T2_stb_vld[4] +  C7T2_stb_vld[5] +  C7T2_stb_vld[6] +  C7T2_stb_vld[7] ;
wire   [4:0] C7T3_stb_vld_sum  =  C7T3_stb_vld[0] +  C7T3_stb_vld[1] +  C7T3_stb_vld[2] +  C7T3_stb_vld[3] +
                                     C7T3_stb_vld[4] +  C7T3_stb_vld[5] +  C7T3_stb_vld[6] +  C7T3_stb_vld[7] ;

reg [4:0] C7T0_stb_vld_sum_d1;
reg [4:0] C7T1_stb_vld_sum_d1;
reg [4:0] C7T2_stb_vld_sum_d1;
reg [4:0] C7T3_stb_vld_sum_d1;

wire   C7T0_st_ack  = &`TOP_DESIGN.sparc7.lsu.cpx_st_ack_tid0;
wire   C7T1_st_ack  = &`TOP_DESIGN.sparc7.lsu.cpx_st_ack_tid1;
wire   C7T2_st_ack  = &`TOP_DESIGN.sparc7.lsu.cpx_st_ack_tid2;
wire   C7T3_st_ack  = &`TOP_DESIGN.sparc7.lsu.cpx_st_ack_tid3;

wire   C7T0_defr_trp_en	= &`TOP_DESIGN.sparc7.lsu.excpctl.st_defr_trp_en0;
wire   C7T1_defr_trp_en	= &`TOP_DESIGN.sparc7.lsu.excpctl.st_defr_trp_en1;
wire   C7T2_defr_trp_en	= &`TOP_DESIGN.sparc7.lsu.excpctl.st_defr_trp_en2;
wire   C7T3_defr_trp_en	= &`TOP_DESIGN.sparc7.lsu.excpctl.st_defr_trp_en3;

reg C7T0_defr_trp_en_d1;
reg C7T1_defr_trp_en_d1;
reg C7T2_defr_trp_en_d1;
reg C7T3_defr_trp_en_d1;

integer C7T0_stb_drain_cnt;
integer C7T1_stb_drain_cnt;
integer C7T2_stb_drain_cnt;
integer C7T3_stb_drain_cnt;

// Hits in the store buffer
//-------------------------
wire       spc7_inst_vld_w		= `TOP_DESIGN.sparc7.ifu.fcl.inst_vld_w;
wire [1:0] spc7_sas_thrid_w		= `TOP_DESIGN.sparc7.ifu.fcl.sas_thrid_w[1:0];

wire C7_st_ack_w = (spc7_sas_thrid_w == 2'b00) & C7T0_st_ack |
                      (spc7_sas_thrid_w == 2'b01) & C7T1_st_ack |
                      (spc7_sas_thrid_w == 2'b10) & C7T2_st_ack |
                      (spc7_sas_thrid_w == 2'b11) & C7T3_st_ack;

wire [7:0] spc7_stb_ld_full_raw	= `TOP_DESIGN.sparc7.lsu.stb_ld_full_raw[7:0];
wire [7:0] spc7_stb_ld_partial_raw	= `TOP_DESIGN.sparc7.lsu.stb_ld_partial_raw[7:0];
wire       spc7_stb_cam_mhit		= `TOP_DESIGN.sparc7.lsu.stb_cam_mhit;
wire       spc7_stb_cam_hit		= `TOP_DESIGN.sparc7.lsu.stb_cam_hit;
wire [3:0] spc7_lsu_way_hit		= `TOP_DESIGN.sparc7.lsu.dctl.lsu_way_hit[3:0];
wire       spc7_lsu_ifu_ldst_miss_w	= `TOP_DESIGN.sparc7.lsu.lsu_ifu_ldst_miss_w;
wire       spc7_ld_inst_vld_g	= `TOP_DESIGN.sparc7.lsu.dctl.ld_inst_vld_g;
wire       spc7_ldst_dbl_g		= `TOP_DESIGN.sparc7.lsu.dctl.ldst_dbl_g;
wire       spc7_quad_asi_g		= `TOP_DESIGN.sparc7.lsu.dctl.quad_asi_g;
wire [1:0] spc7_ldst_sz_g		= `TOP_DESIGN.sparc7.lsu.dctl.ldst_sz_g;
wire       spc7_lsu_alt_space_g	= `TOP_DESIGN.sparc7.lsu.dctl.lsu_alt_space_g;

wire       spc7_mbar_inst0_g		= `TOP_DESIGN.sparc7.lsu.dctl.mbar_inst0_g;
wire       spc7_mbar_inst1_g		= `TOP_DESIGN.sparc7.lsu.dctl.mbar_inst1_g;
wire       spc7_mbar_inst2_g		= `TOP_DESIGN.sparc7.lsu.dctl.mbar_inst2_g;
wire       spc7_mbar_inst3_g		= `TOP_DESIGN.sparc7.lsu.dctl.mbar_inst3_g;

wire       spc7_flush_inst0_g	= `TOP_DESIGN.sparc7.lsu.dctl.flush_inst0_g;
wire       spc7_flush_inst1_g	= `TOP_DESIGN.sparc7.lsu.dctl.flush_inst1_g;
wire       spc7_flush_inst2_g	= `TOP_DESIGN.sparc7.lsu.dctl.flush_inst2_g;
wire       spc7_flush_inst3_g	= `TOP_DESIGN.sparc7.lsu.dctl.flush_inst3_g;

wire       spc7_intrpt_disp_asi0_g	= `TOP_DESIGN.sparc7.lsu.dctl.intrpt_disp_asi_g & (spc7_sas_thrid_w == 2'b00);
wire       spc7_intrpt_disp_asi1_g	= `TOP_DESIGN.sparc7.lsu.dctl.intrpt_disp_asi_g & (spc7_sas_thrid_w == 2'b01);
wire       spc7_intrpt_disp_asi2_g	= `TOP_DESIGN.sparc7.lsu.dctl.intrpt_disp_asi_g & (spc7_sas_thrid_w == 2'b10);
wire       spc7_intrpt_disp_asi3_g	= `TOP_DESIGN.sparc7.lsu.dctl.intrpt_disp_asi_g & (spc7_sas_thrid_w == 2'b11);

wire       spc7_st_inst_vld_g	= `TOP_DESIGN.sparc7.lsu.dctl.st_inst_vld_g;
wire       spc7_non_altspace_ldst_g	= `TOP_DESIGN.sparc7.lsu.dctl.non_altspace_ldst_g;

wire       spc7_dctl_flush_pipe_w	= `TOP_DESIGN.sparc7.lsu.dctl.dctl_flush_pipe_w;

wire [3:0] spc7_no_spc_rmo_st	= `TOP_DESIGN.sparc7.lsu.dctl.no_spc_rmo_st[3:0];


wire       spc7_ldst_fp_e		= `TOP_DESIGN.sparc7.lsu.ifu_lsu_ldst_fp_e;
wire [2:0] spc7_stb_rdptr		= `TOP_DESIGN.sparc7.lsu.stb_rwctl.stb_rdptr_l;

wire 	   spc7_ld_l2cache_req 	= `TOP_DESIGN.sparc7.lsu.qctl1.ld3_l2cache_rq |
					  `TOP_DESIGN.sparc7.lsu.qctl1.ld2_l2cache_rq |
                 			  `TOP_DESIGN.sparc7.lsu.qctl1.ld1_l2cache_rq |
					  `TOP_DESIGN.sparc7.lsu.qctl1.ld0_l2cache_rq;

wire [3:0] spc7_dcache_enable	= {`TOP_DESIGN.sparc7.lsu.dctl.lsu_ctl_reg0[1],
                                    	   `TOP_DESIGN.sparc7.lsu.dctl.lsu_ctl_reg1[1],
					   `TOP_DESIGN.sparc7.lsu.dctl.lsu_ctl_reg2[1],
					   `TOP_DESIGN.sparc7.lsu.dctl.lsu_ctl_reg3[1]};

wire [3:0] spc7_icache_enable	= `TOP_DESIGN.sparc7.lsu.lsu_ifu_icache_en[3:0];

wire spc7_dc_direct_map 		= `TOP_DESIGN.sparc7.lsu.dc_direct_map;
wire spc7_lsu_ifu_direct_map_l1	= `TOP_DESIGN.sparc7.lsu.lsu_ifu_direct_map_l1;

always @(spc7_dcache_enable)
    $display("%0d tso_mon: spc7_dcache_enable changed to %x", $time, spc7_dcache_enable);

always @(spc7_icache_enable)
    $display("%0d tso_mon: spc7_icache_enable changed to %x", $time, spc7_icache_enable);

always @(spc7_dc_direct_map)
    $display("%0d tso_mon: spc7_dc_direct_map changed to %x", $time, spc7_dc_direct_map);

always @(spc7_lsu_ifu_direct_map_l1)
   $display("%0d tso_mon: spc7_lsu_ifu_direct_map_l1 changed to %x", $time, spc7_lsu_ifu_direct_map_l1);

reg 		spc7_dva_svld_e_d1;
reg 		spc7_dva_rvld_e_d1;
reg [10:4] 	spc7_dva_rd_addr_e_d1;
reg [4:0]  	spc7_dva_snp_addr_e_d1;

reg   		spc7_lsu_snp_after_rd;
reg   		spc7_lsu_rd_after_snp;

reg 	   	spc7_ldst_fp_m, spc7_ldst_fp_g;

integer 	spc7_multiple_hits;

reg spc7_skid_d1, spc7_skid_d2, spc7_skid_d3;
initial begin
  spc7_skid_d1 = 0;
  spc7_skid_d2 = 0;
  spc7_skid_d3 = 0;
end

always @(posedge clk)
begin

  spc7_skid_d1 <= (~spc7_ifu_lsu_inv_clear & spc7_dfq_rd_advance & spc7_dfq_int_type);
  spc7_skid_d2 <= spc7_skid_d1 & ~spc7_ifu_lsu_inv_clear;
  spc7_skid_d3 <= spc7_skid_d2 & ~spc7_ifu_lsu_inv_clear;

// The full tracking of this condition is complicated since after the interrupt is advanced
// there may be more invalidations to the IFQ.
// All we care about is that the invalidations BEFORE the interrupt are finished.
// I provided a command line argument to disable this check.
  if(spc7_skid_d3 & enable_ifu_lsu_inv_clear)
     finish_test("spc", "tso_mon:   spc7_ifu_lsu_inv_clear should have been clear by now", 7);

  spc7_dva_svld_e_d1 	<= spc7_dva_svld_e;
  spc7_dva_rvld_e_d1 	<= spc7_dva_rvld_e;
  spc7_dva_rd_addr_e_d1 	<= spc7_dva_rd_addr_e;
  spc7_dva_snp_addr_e_d1 	<= spc7_dva_snp_addr_e;

  if(spc7_dva_svld_e_d1 & spc7_dva_rvld_e & (spc7_dva_rd_addr_e_d1[10:6] == spc7_dva_snp_addr_e[4:0]))
    spc7_lsu_rd_after_snp <= 1'b1;
  else 
    spc7_lsu_rd_after_snp <= 1'b0;

  if(spc7_dva_svld_e & spc7_dva_rvld_e_d1 & (spc7_dva_rd_addr_e[10:6] == spc7_dva_snp_addr_e_d1[4:0]))
    spc7_lsu_snp_after_rd <= 1'b1;
  else 
    spc7_lsu_snp_after_rd <= 1'b0;

  spc7_ldst_fp_m <= spc7_ldst_fp_e;
  spc7_ldst_fp_g <= spc7_ldst_fp_m;

  if(spc7_stb_data_rptr_vld & spc7_stb_data_wptr_vld & ~spc7_stbrwctl_flush_pipe_w &
     (spc7_stb_data_rd_ptr == spc7_stb_data_wr_ptr) & spc7_lsu_st_pcx_rq_pick)
  begin
    finish_test("spc", "tso_mon: LSU stb data write and read in the same cycle", 7);
  end

   spc7_multiple_hits = (spc7_lsu_way_hit[3] + spc7_lsu_way_hit[2] + spc7_lsu_way_hit[1] + spc7_lsu_way_hit[0]);
   if(!spc7_lsu_ifu_ldst_miss_w && (spc7_multiple_hits >1) && spc7_inst_vld_w && !spc7_dctl_flush_pipe_w && !spc7_lsu_dc_tag_pe_g_unmasked_or)
     finish_test("spc", "tso_mon: LSU multiple hits ", 7);
end

wire spc7_ld_dbl      = spc7_ld_inst_vld_g &  spc7_ldst_dbl_g &  ~spc7_quad_asi_g;
wire spc7_ld_quad     = spc7_ld_inst_vld_g &  spc7_ldst_dbl_g &  spc7_quad_asi_g;
wire spc7_ld_other    = spc7_ld_inst_vld_g & ~spc7_ldst_dbl_g;

wire spc7_ld_dbl_fp   = spc7_ld_dbl        &  spc7_ldst_fp_g;
wire spc7_ld_other_fp = spc7_ld_other      &  spc7_ldst_fp_g;

wire spc7_ld_dbl_int  = spc7_ld_dbl        & ~spc7_ldst_fp_g;
wire spc7_ld_quad_int = spc7_ld_quad       & ~spc7_ldst_fp_g;
wire spc7_ld_other_int= spc7_ld_other      & ~spc7_ldst_fp_g;

wire spc7_ld_bypassok_hit = |spc7_stb_ld_full_raw[7:0] & ~spc7_stb_cam_mhit;
wire spc7_ld_partial_hit  = |spc7_stb_ld_partial_raw[7:0] & ~spc7_stb_cam_mhit;
wire spc7_ld_multiple_hit =  spc7_stb_cam_mhit;

wire spc7_any_lsu_way_hit = |spc7_lsu_way_hit;

wire [7:0] spc7_stb_rdptr_decoded = 	(spc7_stb_rdptr ==3'b000) ? 8'b00000001 :
                               		(spc7_stb_rdptr ==3'b001) ? 8'b00000010 :
                               		(spc7_stb_rdptr ==3'b010) ? 8'b00000100 :
                              		(spc7_stb_rdptr ==3'b011) ? 8'b00001000 :
                              		(spc7_stb_rdptr ==3'b100) ? 8'b00010000 :
                              		(spc7_stb_rdptr ==3'b101) ? 8'b00100000 :
                             		(spc7_stb_rdptr ==3'b110) ? 8'b01000000 :
                              		(spc7_stb_rdptr ==3'b111) ? 8'b10000000 : 8'h00;


wire spc7_stb_top_hit = |(spc7_stb_rdptr_decoded & (spc7_stb_ld_full_raw | spc7_stb_ld_partial_raw));

//---------------------------------------------------------------------
// ld_type[4:0] hit_type[2:0], cache_hit, hit_top
// this is passed to the coverage monitor.
//---------------------------------------------------------------------
wire [10:0] spc7_stb_ld_hit_info = 
	{spc7_ld_dbl_fp,        spc7_ld_other_fp,
	 spc7_ld_dbl_int, 	   spc7_ld_quad_int,    spc7_ld_other_int,
	 spc7_ld_bypassok_hit,  spc7_ld_partial_hit, spc7_ld_multiple_hit,
	 spc7_any_lsu_way_hit,
	 spc7_stb_top_hit, C7_st_ack_w};

reg spc7_mbar0_active;
reg spc7_mbar1_active;
reg spc7_mbar2_active;
reg spc7_mbar3_active;

reg spc7_flush0_active;
reg spc7_flush1_active;
reg spc7_flush2_active;
reg spc7_flush3_active;

reg spc7_intr0_active;
reg spc7_intr1_active;
reg spc7_intr2_active;
reg spc7_intr3_active;

always @(negedge clk)
begin
  if(~rst_l)
  begin
     spc7_mbar0_active <= 1'b0;
     spc7_mbar1_active <= 1'b0;
     spc7_mbar2_active <= 1'b0;
     spc7_mbar3_active <= 1'b0;

     spc7_flush0_active <= 1'b0;
     spc7_flush1_active <= 1'b0;
     spc7_flush2_active <= 1'b0;
     spc7_flush3_active <= 1'b0;

     spc7_intr0_active <= 1'b0;
     spc7_intr1_active <= 1'b0;
     spc7_intr2_active <= 1'b0;
     spc7_intr3_active <= 1'b0;

  end
  else
  begin
    if(spc7_mbar_inst0_g & ~spc7_dctl_flush_pipe_w & (C7T0_stb_ne|~spc7_no_spc_rmo_st[0]))
	spc7_mbar0_active <= 1'b1;
    else if(~C7T0_stb_ne & spc7_no_spc_rmo_st[0])
	spc7_mbar0_active <= 1'b0;
    if(spc7_mbar_inst1_g & ~ spc7_dctl_flush_pipe_w & (C7T1_stb_ne|~spc7_no_spc_rmo_st[1]))
	spc7_mbar1_active <= 1'b1;
    else if(~C7T1_stb_ne & spc7_no_spc_rmo_st[1])
	spc7_mbar1_active <= 1'b0;
    if(spc7_mbar_inst2_g & ~ spc7_dctl_flush_pipe_w & (C7T2_stb_ne|~spc7_no_spc_rmo_st[2]))
	spc7_mbar2_active <= 1'b1;
    else if(~C7T2_stb_ne & spc7_no_spc_rmo_st[2])
	spc7_mbar2_active <= 1'b0;
    if(spc7_mbar_inst3_g & ~ spc7_dctl_flush_pipe_w & (C7T3_stb_ne|~spc7_no_spc_rmo_st[3]))
	spc7_mbar3_active <= 1'b1;
    else if(~C7T3_stb_ne & spc7_no_spc_rmo_st[3])
	spc7_mbar3_active <= 1'b0;

    if(spc7_flush_inst0_g & ~spc7_dctl_flush_pipe_w & C7T0_stb_ne) 	spc7_flush0_active <= 1'b1;
    else if(~C7T0_stb_ne)			  				spc7_flush0_active <= 1'b0;
    if(spc7_flush_inst1_g & ~spc7_dctl_flush_pipe_w & C7T1_stb_ne) 	spc7_flush1_active <= 1'b1;
    else if(~C7T1_stb_ne)			  				spc7_flush1_active <= 1'b0;
    if(spc7_flush_inst2_g & ~spc7_dctl_flush_pipe_w & C7T2_stb_ne) 	spc7_flush2_active <= 1'b1;
    else if(~C7T2_stb_ne)			  				spc7_flush2_active <= 1'b0;
    if(spc7_flush_inst3_g & ~spc7_dctl_flush_pipe_w & C7T3_stb_ne) 	spc7_flush3_active <= 1'b1;
    else if(~C7T3_stb_ne)			  				spc7_flush3_active <= 1'b0;

    if(spc7_intrpt_disp_asi0_g & spc7_st_inst_vld_g & ~spc7_non_altspace_ldst_g & ~spc7_dctl_flush_pipe_w & C7T0_stb_ne)
	spc7_intr0_active <= 1'b1;
    else if(~C7T0_stb_ne)			  				
	spc7_intr0_active <= 1'b0;
    if(spc7_intrpt_disp_asi1_g &  spc7_st_inst_vld_g & ~spc7_non_altspace_ldst_g & ~spc7_dctl_flush_pipe_w & C7T1_stb_ne)
	spc7_intr1_active <= 1'b1;
    else if(~C7T1_stb_ne)
	spc7_intr1_active <= 1'b0;
    if(spc7_intrpt_disp_asi2_g &  spc7_st_inst_vld_g & ~spc7_non_altspace_ldst_g & ~spc7_dctl_flush_pipe_w & C7T2_stb_ne)
	spc7_intr2_active <= 1'b1;
    else if(~C7T2_stb_ne)
	spc7_intr2_active <= 1'b0;
    if(spc7_intrpt_disp_asi3_g &  spc7_st_inst_vld_g & ~spc7_non_altspace_ldst_g & ~spc7_dctl_flush_pipe_w & C7T3_stb_ne)
	spc7_intr3_active <= 1'b1;
    else if(~C7T3_stb_ne)
	spc7_intr3_active <= 1'b0;
  end

  if(spc7_mbar0_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "membar violation thread 0", 7);
  if(spc7_mbar1_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "membar violation thread 1", 7);
  if(spc7_mbar2_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "membar violation thread 2", 7);
  if(spc7_mbar3_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "membar violation thread 3", 7);

  if(spc7_flush0_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "flush violation thread 0", 7);
  if(spc7_flush1_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "flush violation thread 1", 7);
  if(spc7_flush2_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "flush violation thread 2", 7);
  if(spc7_flush3_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "flush violation thread 3", 7);

  if(spc7_intr0_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b00)
    finish_test("spc", "intr violation thread 0", 7);
  if(spc7_intr1_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b01)
    finish_test("spc", "intr violation thread 1", 7);
  if(spc7_intr2_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b10)
    finish_test("spc", "intr violation thread 2", 7);
  if(spc7_intr3_active & spc7_inst_vld_w & spc7_sas_thrid_w[1:0] == 2'b11)
    finish_test("spc", "intr violation thread 3", 7);

   if(~rst_l | ~C7T0_stb_full | sctag_pcx_stall_pq) 	C7T0_stb_drain_cnt = 0;
   else							C7T0_stb_drain_cnt = C7T0_stb_drain_cnt + 1;
   if(C7T0_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 0 is not draining", 7);

   if(~rst_l | ~C7T1_stb_full | sctag_pcx_stall_pq) 	C7T1_stb_drain_cnt = 0;
   else							C7T1_stb_drain_cnt = C7T1_stb_drain_cnt + 1;
   if(C7T1_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 1 is not draining", 7);

   if(~rst_l | ~C7T2_stb_full | sctag_pcx_stall_pq) 	C7T2_stb_drain_cnt = 0;
   else							C7T2_stb_drain_cnt = C7T2_stb_drain_cnt + 1;
   if(C7T2_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 2 is not draining", 7);

   if(~rst_l | ~C7T3_stb_full | sctag_pcx_stall_pq) 	C7T3_stb_drain_cnt = 0;
   else							C7T3_stb_drain_cnt = C7T3_stb_drain_cnt + 1;
   if(C7T3_stb_drain_cnt > stb_drain_to_max)
     finish_test("spc", "stb 3 is not draining", 7);

  C7T0_stb_vld_sum_d1 <= C7T0_stb_vld_sum;
  C7T1_stb_vld_sum_d1 <= C7T1_stb_vld_sum;
  C7T2_stb_vld_sum_d1 <= C7T2_stb_vld_sum;
  C7T3_stb_vld_sum_d1 <= C7T3_stb_vld_sum;
  C7T0_defr_trp_en_d1 <= C7T0_defr_trp_en;
  C7T1_defr_trp_en_d1 <= C7T1_defr_trp_en;
  C7T2_defr_trp_en_d1 <= C7T2_defr_trp_en;
  C7T3_defr_trp_en_d1 <= C7T3_defr_trp_en;

  if(rst_l & C7T0_defr_trp_en_d1 & (C7T0_stb_vld_sum_d1 < C7T0_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T0", 7);
  if(rst_l & C7T1_defr_trp_en_d1 & (C7T1_stb_vld_sum_d1 < C7T1_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T1", 7);
  if(rst_l & C7T2_defr_trp_en_d1 & (C7T2_stb_vld_sum_d1 < C7T2_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T2", 7);
  if(rst_l & C7T3_defr_trp_en_d1 & (C7T3_stb_vld_sum_d1 < C7T3_stb_vld_sum))
     finish_test("spc", "tso_mon: deferred trap problems for store T3", 7);
 
end

`endif // ifdef RTL_SPARC7

//-----------------------------------------------------------------------------
// This is put to catch a nasty rust bug where IFILL packet does not invalidate the
// D I exclusivity
// pardon my hardwired numbers
// FSM - 00 iDLE
//       01 started
//       10 ifill_pkt is out the ibuf_busy is high so handshake not finished
//----------------------------------------------------------------------------
reg [1:0] spc0_dfq_fsm1;
integer  spc0_dfq_forced;
`ifdef RTL_SPARC0

initial begin
    spc0_dfq_fsm1   = 2'b00;
    spc0_dfq_forced = 0;
end

always @(posedge clk)
begin
  if(~rst_l)
  begin
    cpx_spc0_data_cx2_d2  <= `CPX_WIDTH'b0;
    cpx_spc0_data_cx2_d1  <= `CPX_WIDTH'b0;
    spc0_dfq_byp_ff_en_d1 <= 1'b0;
    spc0_dfq_wr_en_d1     <= 1'b0;
    spc0_dfq_fsm1	     <= 2'b00;
    spc0_dfq_forced       <= 0;
    
  end
  else 
  begin 

    cpx_spc0_data_cx2_d2  <= cpx_spc0_data_cx2_d1;
    cpx_spc0_data_cx2_d1  <= cpx_spc0_data_cx2;
    spc0_dfq_byp_ff_en_d1 <= spc0_dfq_byp_ff_en;
    spc0_dfq_wr_en_d1     <= spc0_dfq_wr_en;

    if(cpx_spc0_data_cx2_d2[144] & (cpx_spc0_data_cx2_d2[143:140] == 4'h1) & ~cpx_spc0_data_cx2_d2[133] &
       cpx_spc0_data_cx2_d1[144] & (cpx_spc0_data_cx2_d1[143:140] == 4'h1) &  cpx_spc0_data_cx2_d1[133])
    begin
      $display("%0d: spc%0d tso_mon:condition1 for bug6362\n", $time, 0);
      if(spc0_dfq_wr_en & ~spc0_dfq_wr_en_d1 & ~spc0_dfq_byp_ff_en)
      begin
        $display("%0d: spc%0d tso_mon:condition2 for bug6362\n", $time, 0);

        if(spc0_dfq_fsm1 == 2'b00)
          spc0_dfq_fsm1 <= 2'b01;
        else
          finish_test("spc", "tso_mon:something is wrong with dfq_fsm1", 0);

        if(kill_on_cross_mod_code)
          finish_test("spc", "tso_mon:condition2 for bug6362", 0);
      end
    end

    if((spc0_dfq_fsm1 == 2'b01) & spc0_lsu_ifill_pkt_vld & spc0_dfq_rd_advance)
    begin
      spc0_dfq_fsm1 <= 2'b00;	// IDLE
    end
    else if((spc0_dfq_fsm1 == 2'b01) & spc0_lsu_ifill_pkt_vld & ~spc0_dfq_rd_advance)
    begin
      spc0_dfq_fsm1 <= 2'b10;	// UNFINISHED HANDSHAKE
    end
    else if((spc0_dfq_fsm1 == 2'b10) & spc0_lsu_ifill_pkt_vld & spc0_dfq_rd_advance)
    begin
      spc0_dfq_fsm1 <= 2'b00;
    end
    else if((spc0_dfq_fsm1 == 2'b10) & ~spc0_lsu_ifill_pkt_vld)
    begin
          finish_test("spc", "tso_mon:bug6362 hit - ifill_pkt goes out BEFORE dfq_rd_advance", 0);
    end

    if(force_dfq & ~spc0_dfq_byp_ff_en & (spc0_dfq_forced == 0))
    begin
      $display("%0d: spc%0d forcing spc0_dfq_forced\n", $time, 0);
      force `TOP_DESIGN.sparc0.lsu.qctl2.dfq_byp_ff_en = 1'b0;
      spc0_dfq_forced = 1;
    end
    else if((spc0_dfq_forced >0) && (spc0_dfq_forced <10))
         spc0_dfq_forced =  spc0_dfq_forced + 1;
    else if(spc0_dfq_forced !=0)
    begin
      $display("%0d: spc%0d releasing spc0_dfq_forced\n", $time, 0);
      release `TOP_DESIGN.sparc0.lsu.qctl2.dfq_byp_ff_en;
      spc0_dfq_forced  = 0;
    end

//-------------
  end // of else reset

end
`endif // ifdef RTL_SPARC0
reg [1:0] spc1_dfq_fsm1;
integer  spc1_dfq_forced;
`ifdef RTL_SPARC1

initial begin
    spc1_dfq_fsm1   = 2'b00;
    spc1_dfq_forced = 0;
end

always @(posedge clk)
begin
  if(~rst_l)
  begin
    cpx_spc1_data_cx2_d2  <= `CPX_WIDTH'b0;
    cpx_spc1_data_cx2_d1  <= `CPX_WIDTH'b0;
    spc1_dfq_byp_ff_en_d1 <= 1'b0;
    spc1_dfq_wr_en_d1     <= 1'b0;
    spc1_dfq_fsm1	     <= 2'b00;
    spc1_dfq_forced       <= 0;
    
  end
  else 
  begin 

    cpx_spc1_data_cx2_d2  <= cpx_spc1_data_cx2_d1;
    cpx_spc1_data_cx2_d1  <= cpx_spc1_data_cx2;
    spc1_dfq_byp_ff_en_d1 <= spc1_dfq_byp_ff_en;
    spc1_dfq_wr_en_d1     <= spc1_dfq_wr_en;

    if(cpx_spc1_data_cx2_d2[144] & (cpx_spc1_data_cx2_d2[143:140] == 4'h1) & ~cpx_spc1_data_cx2_d2[133] &
       cpx_spc1_data_cx2_d1[144] & (cpx_spc1_data_cx2_d1[143:140] == 4'h1) &  cpx_spc1_data_cx2_d1[133])
    begin
      $display("%0d: spc%0d tso_mon:condition1 for bug6362\n", $time, 1);
      if(spc1_dfq_wr_en & ~spc1_dfq_wr_en_d1 & ~spc1_dfq_byp_ff_en)
      begin
        $display("%0d: spc%0d tso_mon:condition2 for bug6362\n", $time, 1);

        if(spc1_dfq_fsm1 == 2'b00)
          spc1_dfq_fsm1 <= 2'b01;
        else
          finish_test("spc", "tso_mon:something is wrong with dfq_fsm1", 1);

        if(kill_on_cross_mod_code)
          finish_test("spc", "tso_mon:condition2 for bug6362", 1);
      end
    end

    if((spc1_dfq_fsm1 == 2'b01) & spc1_lsu_ifill_pkt_vld & spc1_dfq_rd_advance)
    begin
      spc1_dfq_fsm1 <= 2'b00;	// IDLE
    end
    else if((spc1_dfq_fsm1 == 2'b01) & spc1_lsu_ifill_pkt_vld & ~spc1_dfq_rd_advance)
    begin
      spc1_dfq_fsm1 <= 2'b10;	// UNFINISHED HANDSHAKE
    end
    else if((spc1_dfq_fsm1 == 2'b10) & spc1_lsu_ifill_pkt_vld & spc1_dfq_rd_advance)
    begin
      spc1_dfq_fsm1 <= 2'b00;
    end
    else if((spc1_dfq_fsm1 == 2'b10) & ~spc1_lsu_ifill_pkt_vld)
    begin
          finish_test("spc", "tso_mon:bug6362 hit - ifill_pkt goes out BEFORE dfq_rd_advance", 1);
    end

    if(force_dfq & ~spc1_dfq_byp_ff_en & (spc1_dfq_forced == 0))
    begin
      $display("%0d: spc%0d forcing spc1_dfq_forced\n", $time, 1);
      force `TOP_DESIGN.sparc1.lsu.qctl2.dfq_byp_ff_en = 1'b0;
      spc1_dfq_forced = 1;
    end
    else if((spc1_dfq_forced >0) && (spc1_dfq_forced <10))
         spc1_dfq_forced =  spc1_dfq_forced + 1;
    else if(spc1_dfq_forced !=0)
    begin
      $display("%0d: spc%0d releasing spc1_dfq_forced\n", $time, 1);
      release `TOP_DESIGN.sparc1.lsu.qctl2.dfq_byp_ff_en;
      spc1_dfq_forced  = 0;
    end

//-------------
  end // of else reset

end
`endif // ifdef RTL_SPARC1
reg [1:0] spc2_dfq_fsm1;
integer  spc2_dfq_forced;
`ifdef RTL_SPARC2

initial begin
    spc2_dfq_fsm1   = 2'b00;
    spc2_dfq_forced = 0;
end

always @(posedge clk)
begin
  if(~rst_l)
  begin
    cpx_spc2_data_cx2_d2  <= `CPX_WIDTH'b0;
    cpx_spc2_data_cx2_d1  <= `CPX_WIDTH'b0;
    spc2_dfq_byp_ff_en_d1 <= 1'b0;
    spc2_dfq_wr_en_d1     <= 1'b0;
    spc2_dfq_fsm1	     <= 2'b00;
    spc2_dfq_forced       <= 0;
    
  end
  else 
  begin 

    cpx_spc2_data_cx2_d2  <= cpx_spc2_data_cx2_d1;
    cpx_spc2_data_cx2_d1  <= cpx_spc2_data_cx2;
    spc2_dfq_byp_ff_en_d1 <= spc2_dfq_byp_ff_en;
    spc2_dfq_wr_en_d1     <= spc2_dfq_wr_en;

    if(cpx_spc2_data_cx2_d2[144] & (cpx_spc2_data_cx2_d2[143:140] == 4'h1) & ~cpx_spc2_data_cx2_d2[133] &
       cpx_spc2_data_cx2_d1[144] & (cpx_spc2_data_cx2_d1[143:140] == 4'h1) &  cpx_spc2_data_cx2_d1[133])
    begin
      $display("%0d: spc%0d tso_mon:condition1 for bug6362\n", $time, 2);
      if(spc2_dfq_wr_en & ~spc2_dfq_wr_en_d1 & ~spc2_dfq_byp_ff_en)
      begin
        $display("%0d: spc%0d tso_mon:condition2 for bug6362\n", $time, 2);

        if(spc2_dfq_fsm1 == 2'b00)
          spc2_dfq_fsm1 <= 2'b01;
        else
          finish_test("spc", "tso_mon:something is wrong with dfq_fsm1", 2);

        if(kill_on_cross_mod_code)
          finish_test("spc", "tso_mon:condition2 for bug6362", 2);
      end
    end

    if((spc2_dfq_fsm1 == 2'b01) & spc2_lsu_ifill_pkt_vld & spc2_dfq_rd_advance)
    begin
      spc2_dfq_fsm1 <= 2'b00;	// IDLE
    end
    else if((spc2_dfq_fsm1 == 2'b01) & spc2_lsu_ifill_pkt_vld & ~spc2_dfq_rd_advance)
    begin
      spc2_dfq_fsm1 <= 2'b10;	// UNFINISHED HANDSHAKE
    end
    else if((spc2_dfq_fsm1 == 2'b10) & spc2_lsu_ifill_pkt_vld & spc2_dfq_rd_advance)
    begin
      spc2_dfq_fsm1 <= 2'b00;
    end
    else if((spc2_dfq_fsm1 == 2'b10) & ~spc2_lsu_ifill_pkt_vld)
    begin
          finish_test("spc", "tso_mon:bug6362 hit - ifill_pkt goes out BEFORE dfq_rd_advance", 2);
    end

    if(force_dfq & ~spc2_dfq_byp_ff_en & (spc2_dfq_forced == 0))
    begin
      $display("%0d: spc%0d forcing spc2_dfq_forced\n", $time, 2);
      force `TOP_DESIGN.sparc2.lsu.qctl2.dfq_byp_ff_en = 1'b0;
      spc2_dfq_forced = 1;
    end
    else if((spc2_dfq_forced >0) && (spc2_dfq_forced <10))
         spc2_dfq_forced =  spc2_dfq_forced + 1;
    else if(spc2_dfq_forced !=0)
    begin
      $display("%0d: spc%0d releasing spc2_dfq_forced\n", $time, 2);
      release `TOP_DESIGN.sparc2.lsu.qctl2.dfq_byp_ff_en;
      spc2_dfq_forced  = 0;
    end

//-------------
  end // of else reset

end
`endif // ifdef RTL_SPARC2
reg [1:0] spc3_dfq_fsm1;
integer  spc3_dfq_forced;
`ifdef RTL_SPARC3

initial begin
    spc3_dfq_fsm1   = 2'b00;
    spc3_dfq_forced = 0;
end

always @(posedge clk)
begin
  if(~rst_l)
  begin
    cpx_spc3_data_cx2_d2  <= `CPX_WIDTH'b0;
    cpx_spc3_data_cx2_d1  <= `CPX_WIDTH'b0;
    spc3_dfq_byp_ff_en_d1 <= 1'b0;
    spc3_dfq_wr_en_d1     <= 1'b0;
    spc3_dfq_fsm1	     <= 2'b00;
    spc3_dfq_forced       <= 0;
    
  end
  else 
  begin 

    cpx_spc3_data_cx2_d2  <= cpx_spc3_data_cx2_d1;
    cpx_spc3_data_cx2_d1  <= cpx_spc3_data_cx2;
    spc3_dfq_byp_ff_en_d1 <= spc3_dfq_byp_ff_en;
    spc3_dfq_wr_en_d1     <= spc3_dfq_wr_en;

    if(cpx_spc3_data_cx2_d2[144] & (cpx_spc3_data_cx2_d2[143:140] == 4'h1) & ~cpx_spc3_data_cx2_d2[133] &
       cpx_spc3_data_cx2_d1[144] & (cpx_spc3_data_cx2_d1[143:140] == 4'h1) &  cpx_spc3_data_cx2_d1[133])
    begin
      $display("%0d: spc%0d tso_mon:condition1 for bug6362\n", $time, 3);
      if(spc3_dfq_wr_en & ~spc3_dfq_wr_en_d1 & ~spc3_dfq_byp_ff_en)
      begin
        $display("%0d: spc%0d tso_mon:condition2 for bug6362\n", $time, 3);

        if(spc3_dfq_fsm1 == 2'b00)
          spc3_dfq_fsm1 <= 2'b01;
        else
          finish_test("spc", "tso_mon:something is wrong with dfq_fsm1", 3);

        if(kill_on_cross_mod_code)
          finish_test("spc", "tso_mon:condition2 for bug6362", 3);
      end
    end

    if((spc3_dfq_fsm1 == 2'b01) & spc3_lsu_ifill_pkt_vld & spc3_dfq_rd_advance)
    begin
      spc3_dfq_fsm1 <= 2'b00;	// IDLE
    end
    else if((spc3_dfq_fsm1 == 2'b01) & spc3_lsu_ifill_pkt_vld & ~spc3_dfq_rd_advance)
    begin
      spc3_dfq_fsm1 <= 2'b10;	// UNFINISHED HANDSHAKE
    end
    else if((spc3_dfq_fsm1 == 2'b10) & spc3_lsu_ifill_pkt_vld & spc3_dfq_rd_advance)
    begin
      spc3_dfq_fsm1 <= 2'b00;
    end
    else if((spc3_dfq_fsm1 == 2'b10) & ~spc3_lsu_ifill_pkt_vld)
    begin
          finish_test("spc", "tso_mon:bug6362 hit - ifill_pkt goes out BEFORE dfq_rd_advance", 3);
    end

    if(force_dfq & ~spc3_dfq_byp_ff_en & (spc3_dfq_forced == 0))
    begin
      $display("%0d: spc%0d forcing spc3_dfq_forced\n", $time, 3);
      force `TOP_DESIGN.sparc3.lsu.qctl2.dfq_byp_ff_en = 1'b0;
      spc3_dfq_forced = 1;
    end
    else if((spc3_dfq_forced >0) && (spc3_dfq_forced <10))
         spc3_dfq_forced =  spc3_dfq_forced + 1;
    else if(spc3_dfq_forced !=0)
    begin
      $display("%0d: spc%0d releasing spc3_dfq_forced\n", $time, 3);
      release `TOP_DESIGN.sparc3.lsu.qctl2.dfq_byp_ff_en;
      spc3_dfq_forced  = 0;
    end

//-------------
  end // of else reset

end
`endif // ifdef RTL_SPARC3
reg [1:0] spc4_dfq_fsm1;
integer  spc4_dfq_forced;
`ifdef RTL_SPARC4

initial begin
    spc4_dfq_fsm1   = 2'b00;
    spc4_dfq_forced = 0;
end

always @(posedge clk)
begin
  if(~rst_l)
  begin
    cpx_spc4_data_cx2_d2  <= `CPX_WIDTH'b0;
    cpx_spc4_data_cx2_d1  <= `CPX_WIDTH'b0;
    spc4_dfq_byp_ff_en_d1 <= 1'b0;
    spc4_dfq_wr_en_d1     <= 1'b0;
    spc4_dfq_fsm1	     <= 2'b00;
    spc4_dfq_forced       <= 0;
    
  end
  else 
  begin 

    cpx_spc4_data_cx2_d2  <= cpx_spc4_data_cx2_d1;
    cpx_spc4_data_cx2_d1  <= cpx_spc4_data_cx2;
    spc4_dfq_byp_ff_en_d1 <= spc4_dfq_byp_ff_en;
    spc4_dfq_wr_en_d1     <= spc4_dfq_wr_en;

    if(cpx_spc4_data_cx2_d2[144] & (cpx_spc4_data_cx2_d2[143:140] == 4'h1) & ~cpx_spc4_data_cx2_d2[133] &
       cpx_spc4_data_cx2_d1[144] & (cpx_spc4_data_cx2_d1[143:140] == 4'h1) &  cpx_spc4_data_cx2_d1[133])
    begin
      $display("%0d: spc%0d tso_mon:condition1 for bug6362\n", $time, 4);
      if(spc4_dfq_wr_en & ~spc4_dfq_wr_en_d1 & ~spc4_dfq_byp_ff_en)
      begin
        $display("%0d: spc%0d tso_mon:condition2 for bug6362\n", $time, 4);

        if(spc4_dfq_fsm1 == 2'b00)
          spc4_dfq_fsm1 <= 2'b01;
        else
          finish_test("spc", "tso_mon:something is wrong with dfq_fsm1", 4);

        if(kill_on_cross_mod_code)
          finish_test("spc", "tso_mon:condition2 for bug6362", 4);
      end
    end

    if((spc4_dfq_fsm1 == 2'b01) & spc4_lsu_ifill_pkt_vld & spc4_dfq_rd_advance)
    begin
      spc4_dfq_fsm1 <= 2'b00;	// IDLE
    end
    else if((spc4_dfq_fsm1 == 2'b01) & spc4_lsu_ifill_pkt_vld & ~spc4_dfq_rd_advance)
    begin
      spc4_dfq_fsm1 <= 2'b10;	// UNFINISHED HANDSHAKE
    end
    else if((spc4_dfq_fsm1 == 2'b10) & spc4_lsu_ifill_pkt_vld & spc4_dfq_rd_advance)
    begin
      spc4_dfq_fsm1 <= 2'b00;
    end
    else if((spc4_dfq_fsm1 == 2'b10) & ~spc4_lsu_ifill_pkt_vld)
    begin
          finish_test("spc", "tso_mon:bug6362 hit - ifill_pkt goes out BEFORE dfq_rd_advance", 4);
    end

    if(force_dfq & ~spc4_dfq_byp_ff_en & (spc4_dfq_forced == 0))
    begin
      $display("%0d: spc%0d forcing spc4_dfq_forced\n", $time, 4);
      force `TOP_DESIGN.sparc4.lsu.qctl2.dfq_byp_ff_en = 1'b0;
      spc4_dfq_forced = 1;
    end
    else if((spc4_dfq_forced >0) && (spc4_dfq_forced <10))
         spc4_dfq_forced =  spc4_dfq_forced + 1;
    else if(spc4_dfq_forced !=0)
    begin
      $display("%0d: spc%0d releasing spc4_dfq_forced\n", $time, 4);
      release `TOP_DESIGN.sparc4.lsu.qctl2.dfq_byp_ff_en;
      spc4_dfq_forced  = 0;
    end

//-------------
  end // of else reset

end
`endif // ifdef RTL_SPARC4
reg [1:0] spc5_dfq_fsm1;
integer  spc5_dfq_forced;
`ifdef RTL_SPARC5

initial begin
    spc5_dfq_fsm1   = 2'b00;
    spc5_dfq_forced = 0;
end

always @(posedge clk)
begin
  if(~rst_l)
  begin
    cpx_spc5_data_cx2_d2  <= `CPX_WIDTH'b0;
    cpx_spc5_data_cx2_d1  <= `CPX_WIDTH'b0;
    spc5_dfq_byp_ff_en_d1 <= 1'b0;
    spc5_dfq_wr_en_d1     <= 1'b0;
    spc5_dfq_fsm1	     <= 2'b00;
    spc5_dfq_forced       <= 0;
    
  end
  else 
  begin 

    cpx_spc5_data_cx2_d2  <= cpx_spc5_data_cx2_d1;
    cpx_spc5_data_cx2_d1  <= cpx_spc5_data_cx2;
    spc5_dfq_byp_ff_en_d1 <= spc5_dfq_byp_ff_en;
    spc5_dfq_wr_en_d1     <= spc5_dfq_wr_en;

    if(cpx_spc5_data_cx2_d2[144] & (cpx_spc5_data_cx2_d2[143:140] == 4'h1) & ~cpx_spc5_data_cx2_d2[133] &
       cpx_spc5_data_cx2_d1[144] & (cpx_spc5_data_cx2_d1[143:140] == 4'h1) &  cpx_spc5_data_cx2_d1[133])
    begin
      $display("%0d: spc%0d tso_mon:condition1 for bug6362\n", $time, 5);
      if(spc5_dfq_wr_en & ~spc5_dfq_wr_en_d1 & ~spc5_dfq_byp_ff_en)
      begin
        $display("%0d: spc%0d tso_mon:condition2 for bug6362\n", $time, 5);

        if(spc5_dfq_fsm1 == 2'b00)
          spc5_dfq_fsm1 <= 2'b01;
        else
          finish_test("spc", "tso_mon:something is wrong with dfq_fsm1", 5);

        if(kill_on_cross_mod_code)
          finish_test("spc", "tso_mon:condition2 for bug6362", 5);
      end
    end

    if((spc5_dfq_fsm1 == 2'b01) & spc5_lsu_ifill_pkt_vld & spc5_dfq_rd_advance)
    begin
      spc5_dfq_fsm1 <= 2'b00;	// IDLE
    end
    else if((spc5_dfq_fsm1 == 2'b01) & spc5_lsu_ifill_pkt_vld & ~spc5_dfq_rd_advance)
    begin
      spc5_dfq_fsm1 <= 2'b10;	// UNFINISHED HANDSHAKE
    end
    else if((spc5_dfq_fsm1 == 2'b10) & spc5_lsu_ifill_pkt_vld & spc5_dfq_rd_advance)
    begin
      spc5_dfq_fsm1 <= 2'b00;
    end
    else if((spc5_dfq_fsm1 == 2'b10) & ~spc5_lsu_ifill_pkt_vld)
    begin
          finish_test("spc", "tso_mon:bug6362 hit - ifill_pkt goes out BEFORE dfq_rd_advance", 5);
    end

    if(force_dfq & ~spc5_dfq_byp_ff_en & (spc5_dfq_forced == 0))
    begin
      $display("%0d: spc%0d forcing spc5_dfq_forced\n", $time, 5);
      force `TOP_DESIGN.sparc5.lsu.qctl2.dfq_byp_ff_en = 1'b0;
      spc5_dfq_forced = 1;
    end
    else if((spc5_dfq_forced >0) && (spc5_dfq_forced <10))
         spc5_dfq_forced =  spc5_dfq_forced + 1;
    else if(spc5_dfq_forced !=0)
    begin
      $display("%0d: spc%0d releasing spc5_dfq_forced\n", $time, 5);
      release `TOP_DESIGN.sparc5.lsu.qctl2.dfq_byp_ff_en;
      spc5_dfq_forced  = 0;
    end

//-------------
  end // of else reset

end
`endif // ifdef RTL_SPARC5
reg [1:0] spc6_dfq_fsm1;
integer  spc6_dfq_forced;
`ifdef RTL_SPARC6

initial begin
    spc6_dfq_fsm1   = 2'b00;
    spc6_dfq_forced = 0;
end

always @(posedge clk)
begin
  if(~rst_l)
  begin
    cpx_spc6_data_cx2_d2  <= `CPX_WIDTH'b0;
    cpx_spc6_data_cx2_d1  <= `CPX_WIDTH'b0;
    spc6_dfq_byp_ff_en_d1 <= 1'b0;
    spc6_dfq_wr_en_d1     <= 1'b0;
    spc6_dfq_fsm1	     <= 2'b00;
    spc6_dfq_forced       <= 0;
    
  end
  else 
  begin 

    cpx_spc6_data_cx2_d2  <= cpx_spc6_data_cx2_d1;
    cpx_spc6_data_cx2_d1  <= cpx_spc6_data_cx2;
    spc6_dfq_byp_ff_en_d1 <= spc6_dfq_byp_ff_en;
    spc6_dfq_wr_en_d1     <= spc6_dfq_wr_en;

    if(cpx_spc6_data_cx2_d2[144] & (cpx_spc6_data_cx2_d2[143:140] == 4'h1) & ~cpx_spc6_data_cx2_d2[133] &
       cpx_spc6_data_cx2_d1[144] & (cpx_spc6_data_cx2_d1[143:140] == 4'h1) &  cpx_spc6_data_cx2_d1[133])
    begin
      $display("%0d: spc%0d tso_mon:condition1 for bug6362\n", $time, 6);
      if(spc6_dfq_wr_en & ~spc6_dfq_wr_en_d1 & ~spc6_dfq_byp_ff_en)
      begin
        $display("%0d: spc%0d tso_mon:condition2 for bug6362\n", $time, 6);

        if(spc6_dfq_fsm1 == 2'b00)
          spc6_dfq_fsm1 <= 2'b01;
        else
          finish_test("spc", "tso_mon:something is wrong with dfq_fsm1", 6);

        if(kill_on_cross_mod_code)
          finish_test("spc", "tso_mon:condition2 for bug6362", 6);
      end
    end

    if((spc6_dfq_fsm1 == 2'b01) & spc6_lsu_ifill_pkt_vld & spc6_dfq_rd_advance)
    begin
      spc6_dfq_fsm1 <= 2'b00;	// IDLE
    end
    else if((spc6_dfq_fsm1 == 2'b01) & spc6_lsu_ifill_pkt_vld & ~spc6_dfq_rd_advance)
    begin
      spc6_dfq_fsm1 <= 2'b10;	// UNFINISHED HANDSHAKE
    end
    else if((spc6_dfq_fsm1 == 2'b10) & spc6_lsu_ifill_pkt_vld & spc6_dfq_rd_advance)
    begin
      spc6_dfq_fsm1 <= 2'b00;
    end
    else if((spc6_dfq_fsm1 == 2'b10) & ~spc6_lsu_ifill_pkt_vld)
    begin
          finish_test("spc", "tso_mon:bug6362 hit - ifill_pkt goes out BEFORE dfq_rd_advance", 6);
    end

    if(force_dfq & ~spc6_dfq_byp_ff_en & (spc6_dfq_forced == 0))
    begin
      $display("%0d: spc%0d forcing spc6_dfq_forced\n", $time, 6);
      force `TOP_DESIGN.sparc6.lsu.qctl2.dfq_byp_ff_en = 1'b0;
      spc6_dfq_forced = 1;
    end
    else if((spc6_dfq_forced >0) && (spc6_dfq_forced <10))
         spc6_dfq_forced =  spc6_dfq_forced + 1;
    else if(spc6_dfq_forced !=0)
    begin
      $display("%0d: spc%0d releasing spc6_dfq_forced\n", $time, 6);
      release `TOP_DESIGN.sparc6.lsu.qctl2.dfq_byp_ff_en;
      spc6_dfq_forced  = 0;
    end

//-------------
  end // of else reset

end
`endif // ifdef RTL_SPARC6
reg [1:0] spc7_dfq_fsm1;
integer  spc7_dfq_forced;
`ifdef RTL_SPARC7

initial begin
    spc7_dfq_fsm1   = 2'b00;
    spc7_dfq_forced = 0;
end

always @(posedge clk)
begin
  if(~rst_l)
  begin
    cpx_spc7_data_cx2_d2  <= `CPX_WIDTH'b0;
    cpx_spc7_data_cx2_d1  <= `CPX_WIDTH'b0;
    spc7_dfq_byp_ff_en_d1 <= 1'b0;
    spc7_dfq_wr_en_d1     <= 1'b0;
    spc7_dfq_fsm1	     <= 2'b00;
    spc7_dfq_forced       <= 0;
    
  end
  else 
  begin 

    cpx_spc7_data_cx2_d2  <= cpx_spc7_data_cx2_d1;
    cpx_spc7_data_cx2_d1  <= cpx_spc7_data_cx2;
    spc7_dfq_byp_ff_en_d1 <= spc7_dfq_byp_ff_en;
    spc7_dfq_wr_en_d1     <= spc7_dfq_wr_en;

    if(cpx_spc7_data_cx2_d2[144] & (cpx_spc7_data_cx2_d2[143:140] == 4'h1) & ~cpx_spc7_data_cx2_d2[133] &
       cpx_spc7_data_cx2_d1[144] & (cpx_spc7_data_cx2_d1[143:140] == 4'h1) &  cpx_spc7_data_cx2_d1[133])
    begin
      $display("%0d: spc%0d tso_mon:condition1 for bug6362\n", $time, 7);
      if(spc7_dfq_wr_en & ~spc7_dfq_wr_en_d1 & ~spc7_dfq_byp_ff_en)
      begin
        $display("%0d: spc%0d tso_mon:condition2 for bug6362\n", $time, 7);

        if(spc7_dfq_fsm1 == 2'b00)
          spc7_dfq_fsm1 <= 2'b01;
        else
          finish_test("spc", "tso_mon:something is wrong with dfq_fsm1", 7);

        if(kill_on_cross_mod_code)
          finish_test("spc", "tso_mon:condition2 for bug6362", 7);
      end
    end

    if((spc7_dfq_fsm1 == 2'b01) & spc7_lsu_ifill_pkt_vld & spc7_dfq_rd_advance)
    begin
      spc7_dfq_fsm1 <= 2'b00;	// IDLE
    end
    else if((spc7_dfq_fsm1 == 2'b01) & spc7_lsu_ifill_pkt_vld & ~spc7_dfq_rd_advance)
    begin
      spc7_dfq_fsm1 <= 2'b10;	// UNFINISHED HANDSHAKE
    end
    else if((spc7_dfq_fsm1 == 2'b10) & spc7_lsu_ifill_pkt_vld & spc7_dfq_rd_advance)
    begin
      spc7_dfq_fsm1 <= 2'b00;
    end
    else if((spc7_dfq_fsm1 == 2'b10) & ~spc7_lsu_ifill_pkt_vld)
    begin
          finish_test("spc", "tso_mon:bug6362 hit - ifill_pkt goes out BEFORE dfq_rd_advance", 7);
    end

    if(force_dfq & ~spc7_dfq_byp_ff_en & (spc7_dfq_forced == 0))
    begin
      $display("%0d: spc%0d forcing spc7_dfq_forced\n", $time, 7);
      force `TOP_DESIGN.sparc7.lsu.qctl2.dfq_byp_ff_en = 1'b0;
      spc7_dfq_forced = 1;
    end
    else if((spc7_dfq_forced >0) && (spc7_dfq_forced <10))
         spc7_dfq_forced =  spc7_dfq_forced + 1;
    else if(spc7_dfq_forced !=0)
    begin
      $display("%0d: spc%0d releasing spc7_dfq_forced\n", $time, 7);
      release `TOP_DESIGN.sparc7.lsu.qctl2.dfq_byp_ff_en;
      spc7_dfq_forced  = 0;
    end

//-------------
  end // of else reset

end
`endif // ifdef RTL_SPARC7

//==============================================================================
//==    End of Main program ====================================================
//==============================================================================

//==============================================================================
// Tasks and functions
//==============================================================================

//==============================================================================
// tso_mon models the 16 L2MB entries per sctag.
// sctag_l2mb_cam looks for the tso_mon L2MB entry which is valid and has the same
// address as the incoming sctag_addr_c2
//==============================================================================
function sctag_l2mb_cam;

input [1:0] tag;
integer i;
integer done;
begin
  i = 0;
  done = 0;
  if(tag == 2'h0)
  begin
    while(!done)
    begin
      if((sctag0_l2mb_state[i] != `L2MB_IDLE) & (sctag0_l2mb_addr[i] == sctag0_addr_c2[39:8]))
      begin
        done = 1;
      end
      else
      begin
        i = i +1;
        if(i>15) done = 1;
      end
    end
  end
  if(tag == 2'h1)
  begin
    while(!done)
    begin
      if((sctag1_l2mb_state[i] != `L2MB_IDLE) & (sctag1_l2mb_addr[i] == sctag1_addr_c2[39:8]))
      begin
        done = 1;
      end
      else
      begin
        i = i +1;
        if(i>15) done = 1;
      end
    end
  end
  if(tag == 2'h2)
  begin
    while(!done)
    begin
      if((sctag2_l2mb_state[i] != `L2MB_IDLE) & (sctag2_l2mb_addr[i] == sctag2_addr_c2[39:8]))
      begin
        done = 1;
      end
      else
      begin
        i = i +1;
        if(i>15) done = 1;
      end
    end
  end
  if(tag == 2'h3)
  begin
    while(!done)
    begin
      if((sctag3_l2mb_state[i] != `L2MB_IDLE) & (sctag3_l2mb_addr[i] == sctag3_addr_c2[39:8]))
      begin
        done = 1;
      end
      else
      begin
        i = i +1;
        if(i>15) done = 1;
      end
    end
  end

  sctag_l2mb_cam = i;
end
endfunction

//==============================================================================
// tso_mon models the 16 L2MB entries per sctag.
// sctag_find_next_available finds the next available (free) entry to write stuff into it
//==============================================================================

function sctag_find_next_available;
input [1:0] tag;
integer i;
integer done;

begin
  i = 0;
  done = 0;
  if(tag == 2'h0)
  begin
    while(!done)
    begin
      if(sctag0_l2mb_state[i] == `L2MB_IDLE)
      begin
        done = 1;
      end
      else
      begin
        i = i +1;
        if(i>15) done = 1;
      end
    end
  end
  if(tag == 2'h1)
  begin
    while(!done)
    begin
      if(sctag1_l2mb_state[i] == `L2MB_IDLE)
      begin
        done = 1;
      end
      else
      begin
        i = i +1;
        if(i>15) done = 1;
      end
    end
  end
  if(tag == 2'h2)
  begin
    while(!done)
    begin
      if(sctag2_l2mb_state[i] == `L2MB_IDLE)
      begin
        done = 1;
      end
      else
      begin
        i = i +1;
        if(i>15) done = 1;
      end
    end
  end
  if(tag == 2'h3)
  begin
    while(!done)
    begin
      if(sctag3_l2mb_state[i] == `L2MB_IDLE)
      begin
        done = 1;
      end
      else
      begin
        i = i +1;
        if(i>15) done = 1;
      end
    end
  end
  sctag_find_next_available = i;
end
endfunction

//=====================================================================
`define TSO_MON_PCX_VLD        	pcx_data[123]
`define TSO_MON_PCX_TYPE  	pcx_data[122:118]
`define TSO_MON_PCX_NC     	pcx_data[117]
`define TSO_MON_PCX_CPU_ID 	pcx_data[116:114]
`define TSO_MON_PCX_THR_ID 	pcx_data[113:112]
`define TSO_MON_PCX_INV   	pcx_data[111]
`define TSO_MON_PCX_PRF   	pcx_data[110]
`define TSO_MON_PCX_BST   	pcx_data[109]
`define TSO_MON_PCX_RPL   	pcx_data[108:107]
`define TSO_MON_PCX_SIZ   	pcx_data[106:104]
`define TSO_MON_PCX_ADD   	pcx_data[103:64]
`define TSO_MON_PCX_ADD39   	pcx_data[103]
`define TSO_MON_PCX_DAT   	pcx_data[63:0]


//=====================================================================
// This task analyzes PCX packets
//=====================================================================
task get_pcx;

output [127:0] 		pcx_type_str;

input [`PCX_WIDTH-1:0]	pcx_data;
input [5:0] 		pcx_type_d1;
input      		pcx_atom_pq_d1;
input      		pcx_atom_pq_d2;
input [2:0] 		spc_id;
input [4:0]		pcx_req_pq_d1;

reg			current_stb_nced;

begin

// This is just for easy debug
//-----------------------------
  case(`TSO_MON_PCX_TYPE)
	  `LOAD_RQ   : pcx_type_str = "LOAD_RQ";
	  `IMISS_RQ  : pcx_type_str = "IMISS_RQ";
	  `STORE_RQ  : pcx_type_str = "STORE_RQ";
	  `CAS1_RQ   : pcx_type_str = "CAS1_RQ";
	  `CAS2_RQ   : pcx_type_str = "CAS2_RQ";
	  `SWAP_RQ   : pcx_type_str = "SWAP_RQ";
	  `STRLOAD_RQ: pcx_type_str = "STRLOAD_RQ";
	  `STRST_RQ  : pcx_type_str = "STRST_RQ";
	  `STQ_RQ    : pcx_type_str = "STQ_RQ";
	  `INT_RQ    : pcx_type_str = "INT_RQ";
	  `FWD_RQ    : pcx_type_str = "FWD_RQ";
	  `FWD_RPY   : pcx_type_str = "FWD_RPY";
	  `RSVD_RQ   : pcx_type_str = "RSVD_RQ";
	  `FPOP1_RQ  : pcx_type_str = "FPOP1";
	  `FPOP2_RQ  : pcx_type_str = "FPOP2";
           default   : pcx_type_str = "ILLEGAL";
  endcase

  if(tso_mon_msg)
    $display("%0d tso_mon: cpu(%x) thr(%x) pcx pkt: TYPE= %s NC= %x INV= %x PRF= %x BST= %x RPL= %x SZ= %x PA= %x D= %x",
    $time, `TSO_MON_PCX_CPU_ID, `TSO_MON_PCX_THR_ID, pcx_type_str, `TSO_MON_PCX_NC, `TSO_MON_PCX_INV, `TSO_MON_PCX_PRF, `TSO_MON_PCX_BST, `TSO_MON_PCX_RPL, `TSO_MON_PCX_SIZ, `TSO_MON_PCX_ADD, `TSO_MON_PCX_DAT);  

// SOme sanity checks
//--------------------

  if(`TSO_MON_PCX_VLD === 1'bx)
     finish_test("spc", "valid bit -  pcx_data[123] is X", spc_id);

// victorm Feb 2003 - removing the L1 way replacement info from the X checking
// since for prefetches and non-cacheables the way can be an X.
  if(`TSO_MON_PCX_VLD & ~((`TSO_MON_PCX_TYPE == `FWD_RPY) || (`TSO_MON_PCX_TYPE == `INT_RQ)) & ((^pcx_data[122:109] === 1'bx) | (^pcx_data[106:64] === 1'bx)))
     finish_test("spc", "PCX request with valid bit is 1, but  pcx_data[122:64] is X", spc_id);

  if(`TSO_MON_PCX_VLD & (`TSO_MON_PCX_TYPE == `INT_RQ) & (^pcx_data[122:109] === 1'bx))
     finish_test("spc", "PCX INT request with valid bit is 1, but  pcx_data[122:109] is X", spc_id);

  if(`TSO_MON_PCX_VLD & ((`TSO_MON_PCX_TYPE == `CAS1_RQ) || (`TSO_MON_PCX_TYPE == `CAS2_RQ)) & (^pcx_data[122:0] === 1'bx))
     finish_test("spc", "X in CAS packets", spc_id);

// victorm - when the request type is interrupt then this check is not valid.
//--------------------------------------------------------------------------
  if(~((`TSO_MON_PCX_TYPE == `INT_RQ) | (`TSO_MON_PCX_TYPE == `FWD_RQ) | (`TSO_MON_PCX_TYPE == `FWD_RPY)) & ~(`TSO_MON_PCX_CPU_ID == spc_id))
     finish_test("spc", "messed up pcx_id", spc_id);

  if((pcx_type_d1 == `FPOP1_RQ) & ~(`TSO_MON_PCX_TYPE == `FPOP2_RQ))
     finish_test("spc", "FPOP1 without FPOP2", spc_id);

  if(pcx_atom_pq_d1 & ~((`TSO_MON_PCX_TYPE == `FPOP1_RQ) | (`TSO_MON_PCX_TYPE == `CAS1_RQ)))
  begin
     $display("pcx atomic1 problems heads up: pcx_type = %x", `TSO_MON_PCX_TYPE);
     finish_test("spc", "pcx atomic1 problems ", spc_id);
  end

  if(pcx_atom_pq_d2 & ~((`TSO_MON_PCX_TYPE == `FPOP2_RQ) | (`TSO_MON_PCX_TYPE == `CAS2_RQ)))
  begin
     $display("pcx atomic2 problems heads up: pcx_type = %x", `TSO_MON_PCX_TYPE);
     finish_test("spc", "pcx atomic2 problems ", spc_id);
  end

  if(~`TSO_MON_PCX_VLD & tso_mon_msg)
    $display("%0d INFO: spc %d speculative request backoff", $time, spc_id);

  case({`TSO_MON_PCX_CPU_ID, `TSO_MON_PCX_THR_ID})
    5'h00:	current_stb_nced = C0T0_stb_nced;
    5'h01:	current_stb_nced = C0T1_stb_nced;
    5'h02:	current_stb_nced = C0T2_stb_nced;
    5'h03:	current_stb_nced = C0T3_stb_nced;
    5'h04:	current_stb_nced = C1T0_stb_nced;
    5'h05:	current_stb_nced = C1T1_stb_nced;
    5'h06:	current_stb_nced = C1T2_stb_nced;
    5'h07:	current_stb_nced = C1T3_stb_nced;
    5'h08:	current_stb_nced = C2T0_stb_nced;
    5'h09:	current_stb_nced = C2T1_stb_nced;
    5'h0a:	current_stb_nced = C2T2_stb_nced;
    5'h0b:	current_stb_nced = C2T3_stb_nced;
    5'h0c:	current_stb_nced = C3T0_stb_nced;
    5'h0d:	current_stb_nced = C3T1_stb_nced;
    5'h0e:	current_stb_nced = C3T2_stb_nced;
    5'h0f:	current_stb_nced = C3T3_stb_nced;
    5'h10:	current_stb_nced = C4T0_stb_nced;
    5'h11:	current_stb_nced = C4T1_stb_nced;
    5'h12:	current_stb_nced = C4T2_stb_nced;
    5'h13:	current_stb_nced = C4T3_stb_nced;
    5'h14:	current_stb_nced = C5T0_stb_nced;
    5'h15:	current_stb_nced = C5T1_stb_nced;
    5'h16:	current_stb_nced = C5T2_stb_nced;
    5'h17:	current_stb_nced = C5T3_stb_nced;
    5'h18:	current_stb_nced = C6T0_stb_nced;
    5'h19:	current_stb_nced = C6T1_stb_nced;
    5'h1a:	current_stb_nced = C6T2_stb_nced;
    5'h1b:	current_stb_nced = C6T3_stb_nced;
    5'h1c:	current_stb_nced = C7T0_stb_nced;
    5'h1d:	current_stb_nced = C7T1_stb_nced;
    5'h1e:	current_stb_nced = C7T2_stb_nced;
    5'h1f:	current_stb_nced = C7T3_stb_nced;
    default:	current_stb_nced = 1'b1;
  endcase

  if(`TSO_MON_PCX_VLD & ((`TSO_MON_PCX_TYPE == `LOAD_RQ) | (`TSO_MON_PCX_TYPE == `STRLOAD_RQ)) & (`TSO_MON_PCX_ADD39 | pcx_req_pq_d1[4]) & current_stb_nced)
  begin
     finish_test("spc", "IO strong ordering problems ", spc_id);
  end

  if(`TSO_MON_PCX_VLD & ((`TSO_MON_PCX_TYPE == `LOAD_RQ) | (`TSO_MON_PCX_TYPE == `STRLOAD_RQ)) & (`TSO_MON_PCX_ADD39 | pcx_req_pq_d1[4]) & `TSO_MON_PCX_PRF)
  begin
     finish_test("spc", "prefetch to IO space ", spc_id);
  end
end
endtask

//=====================================================================
// This task analyzes sctag to CPX packets
//=====================================================================
task get_sctag_cpx;
output [3:0] type;
output [127:0] sctag_cpx_type_str;

input  			sctag_cpx_req_cq_d1;
input [`CPX_WIDTH-1:0]	sctag_cpx_data_ca; 
input [1:0] 		sctag_id;

begin

  type = 		sctag_cpx_data_ca[`CPX_RQ_HI:`CPX_RQ_LO];

// this is for debugging mostly
  case(sctag_cpx_data_ca[`CPX_RQ_HI:`CPX_RQ_LO])
    `LOAD_RET : 	sctag_cpx_type_str = "LOAD_RET";
    `IFILL_RET: 	sctag_cpx_type_str = "IFILL_RET";
    `INV_RET  : 	sctag_cpx_type_str = "INV_RET";
    `ST_ACK   : 	sctag_cpx_type_str = "ST_ACK";
    `AT_ACK   : 	sctag_cpx_type_str = "AT_ACK";
    `INT_RET  : 	sctag_cpx_type_str = "INT_RET";
    `TEST_RET : 	sctag_cpx_type_str = "TEST_RET";
    `FP_RET   : 	sctag_cpx_type_str = "FP_RET";
    `EVICT_REQ: 	sctag_cpx_type_str = "EVICT_REQ";
    `ERR_RET  : 	sctag_cpx_type_str = "ERR_RET";
    `STRLOAD_RET : 	sctag_cpx_type_str = "STRLOAD_RET";
    `STRST_ACK: 	sctag_cpx_type_str = "STRST_ACK";
    `FWD_RQ_RET:	sctag_cpx_type_str = "FWD_RQ_RET";
    `FWD_RPY_RET:	sctag_cpx_type_str = "FWD_RPY_RET";
    `RSVD_RET : 	sctag_cpx_type_str = "RSVD_RET";
     default:		sctag_cpx_type_str = "ILLEGAL";
  endcase

  if(sctag_cpx_req_cq_d1 & tso_mon_msg)
    $display("%0d tso_mon: sctag%d-to-cpx pkt TYPE= %s data= %x",
	      $time, sctag_id, sctag_cpx_type_str, sctag_cpx_data_ca[127:0]);

end
endtask

//=====================================================================
// This task analyzes CPX to spc packets 
//=====================================================================
task get_cpx_spc;

output [127:0] cpx_spc_type_str;

input [4:0]	cpx_spc_type; 

begin

  case(cpx_spc_type)
    `LOAD_RET : 	cpx_spc_type_str = "LOAD_RET";
    `IFILL_RET: 	cpx_spc_type_str = "IFILL_RET";
    `INV_RET  : 	cpx_spc_type_str = "INV_RET";
    `ST_ACK   : 	cpx_spc_type_str = "ST_ACK";
    `AT_ACK   : 	cpx_spc_type_str = "AT_ACK";
    `INT_RET  : 	cpx_spc_type_str = "INT_RET";
    `TEST_RET : 	cpx_spc_type_str = "TEST_RET";
    `FP_RET   : 	cpx_spc_type_str = "FP_RET";
    `EVICT_REQ: 	cpx_spc_type_str = "EVICT_REQ";
    `ERR_RET  : 	cpx_spc_type_str = "ERR_RET";
    `STRLOAD_RET : 	cpx_spc_type_str = "STRLOAD_RET";
    `STRST_ACK: 	cpx_spc_type_str = "STRST_ACK";
    `FWD_RQ_RET:	cpx_spc_type_str = "FWD_RQ_RET";
    `FWD_RPY_RET:	cpx_spc_type_str = "FWD_RPY_RET";
    `RSVD_RET : 	cpx_spc_type_str = "RSVD_RET";
     default:		cpx_spc_type_str = "ILLEGAL";
  endcase

end
endtask
//------------------------------------------------

//=====================================================================
// This task allows some more clocks and kills the test
//=====================================================================
task finish_test;
input [512:0] message0;
input [512:0] message1;
input [2:0]   id;

begin
  $display("%0d ERROR: %s: %d %s", $time, message0, id, message1);
  repeat(100) @(posedge clk);
  $finish;
end
endtask

`endif	// ifdef GATE_SIM
endmodule
