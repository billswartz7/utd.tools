// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: cpx_dp_macc_l.v
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
//	Description:	datapath portion of CPX
*/

////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////

`include	"sys.h" // system level definition file which contains the 
			// time scale definition

`include "iop.h"


////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////

module cpx_dp_macc_l(/*AUTOARG*/
   // Outputs
   data_out_cx_l, scan_out, shiftenable_buf, 
   // Inputs
   arb_cpxdp_qsel1_ca, arb_cpxdp_qsel0_ca, arb_cpxdp_grant_ca, 
   arb_cpxdp_shift_cx, arb_cpxdp_q0_hold_ca, src_cpx_data_ca, 
   data_crit_cx_l, data_ncrit_cx_l, rclk, scan_in, shiftenable
   );	

   output [149:0] data_out_cx_l;  // cpx to destination pkt
   output 		   scan_out;
   output 		   shiftenable_buf;
   
   input  	           arb_cpxdp_qsel1_ca;  // queue write sel
   input  	           arb_cpxdp_qsel0_ca;  // queue write sel
   input 		   arb_cpxdp_grant_ca;//grant signal
   input 		   arb_cpxdp_shift_cx;//grant signal
   input 		   arb_cpxdp_q0_hold_ca;//grant signal
   input [149:0]  src_cpx_data_ca;  // scache to cpx data
   input [149:0]  data_crit_cx_l;
   input [149:0]  data_ncrit_cx_l;	    
   input 		   rclk;
   //input 		   tmb_l;
   input 		   scan_in;
   input 		   shiftenable;

   wire 		   grant_cx;
   wire [149:0]   q1_datain_ca, q0_datain_ca;
   wire [149:0]   q1_dataout, q0_dataout;
   wire [149:0]   data_cx_l;
   wire 		   clkq0, clkq1;

   reg 			   clkenq0, clkenq1;

//HEADER SECTION
// Generate gated clocks for hold function

assign shiftenable_buf  =  shiftenable;


/*
  always @ (clk or arb_cpxdp_qsel1_ca )
    begin
    if (!clk)	//latch opens on rclk low phase
      clkenq1 = arb_cpxdp_qsel1_ca ;
    end // always @ (clk or arb_cpxdp_qsel1_ca or tmb)
   
  assign clkq1 = clkenq1 & clk;

  always @ (clk or arb_cpxdp_q0_hold_ca )
    begin
    if (!clk)	//latch opens on rclk low phase
      clkenq0 = !arb_cpxdp_q0_hold_ca ;
    end // always @ (clk or arb_cpxdp_q0_hold_ca or tmb)
   
   
  assign clkq0 = clkenq0 & clk;
*/

//replace tmb_l w/ ~se
wire   se_l ;
assign se_l  = ~shiftenable ;


   
clken_buf ck0 (
	       .clk  (clkq0),
	       .rclk (rclk),
	       .enb_l(~arb_cpxdp_q0_hold_ca),
	       .tmb_l(se_l));

clken_buf ck1 (
	       .clk  (clkq1),
	       .rclk (rclk),
	       .enb_l(~arb_cpxdp_qsel1_ca),
	       .tmb_l(se_l));

   
   dff_s   #(1) dff_cpx_grin_r(
	    .din           (arb_cpxdp_grant_ca),
	    .q             (grant_cx),
	    .clk           (rclk),
	    .se            (1'b0),
	    .si            (1'b0),
	    .so            ());

//DATAPATH SECTION

   
   dff_s   #(150) dff_cpx_datain_q1(
	    .din           (src_cpx_data_ca[149:0]),
	    .q             (q1_dataout[149:0]),
	    .clk           (clkq1),
	    .se            (1'b0),
	    .si            (),
	    .so            ());

   
assign q0_datain_ca[149:0] = 
             (arb_cpxdp_qsel0_ca ? src_cpx_data_ca[149:0] : 150'd0) |
	     (arb_cpxdp_shift_cx ? q1_dataout[149:0] : 150'd0) ;
   
   
   dff_s   #(150) dff_cpx_datain_q0(
	    .din           (q0_datain_ca[149:0]),
	    .q             (q0_dataout[149:0]),
	    .clk           (clkq0),
	    .se            (1'b0),
	    .si            (),
	    .so            ());
   
   assign data_cx_l[149:0] = ~(grant_cx ? q0_dataout[149:0] : 150'd0);
   assign data_out_cx_l[149:0] = data_crit_cx_l[149:0] & data_ncrit_cx_l[149:0] & data_cx_l[149:0];
   
// Local Variables:
// verilog-library-directories:("." "../../../../../common/rtl")
// End:


   
// Code start here 
//
endmodule





