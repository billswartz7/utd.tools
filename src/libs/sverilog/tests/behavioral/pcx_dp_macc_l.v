// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: pcx_dp_macc_l.v
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
//	Description:	datapath portion of PCX
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

module pcx_dp_macc_l(/*AUTOARG*/
   // Outputs
   data_out_px_l, scan_out, shiftenable_buf, 
   // Inputs
   arb_pcxdp_qsel1_pa, arb_pcxdp_qsel0_pa, arb_pcxdp_grant_pa, 
   arb_pcxdp_shift_px, arb_pcxdp_q0_hold_pa, src_pcx_data_pa, 
   data_crit_px_l, data_ncrit_px_l, rclk, scan_in, shiftenable
   );	

   output [129:0] data_out_px_l;  // pcx to destination pkt
   output 		   scan_out;
   output 		   shiftenable_buf;
   
   input  	           arb_pcxdp_qsel1_pa;  // queue write sel
   input  	           arb_pcxdp_qsel0_pa;  // queue write sel
   input 		   arb_pcxdp_grant_pa;//grant signal
   input 		   arb_pcxdp_shift_px;//grant signal
   input 		   arb_pcxdp_q0_hold_pa;//grant signal
   
   input [129:0]  src_pcx_data_pa;  // spache to pcx data
   input [129:0]  data_crit_px_l;   
   input [129:0]  data_ncrit_px_l;   

   input 		   rclk;
   //input 		   tmb_l;
   input 		   scan_in;
   input 		   shiftenable;
   
   wire 		   grant_px;
   wire [129:0]   q0_datain_pa;
   wire [129:0]   q1_dataout, q0_dataout;
   wire [129:0]   data_px_l;
   wire 		   clkq0, clkq1;

   reg 			   clkenq0, clkenq1;

//HEADER SECTION
// Generate gated clocks for hold function


assign shiftenable_buf  =  shiftenable;

//replace tmb_l w/ ~se
wire   se_l ;
assign se_l  = ~shiftenable ;


clken_buf ck0 (
	       .clk  (clkq0),
	       .rclk (rclk),
	       .enb_l(~arb_pcxdp_q0_hold_pa),
	       .tmb_l(se_l));

clken_buf ck1 (
	       .clk  (clkq1),
	       .rclk (rclk),
	       .enb_l(~arb_pcxdp_qsel1_pa),
	       .tmb_l(se_l));
   
   
   // Latch and drive grant signal
   
// Generate write selects

   dff_s   #(1) dff_pcx_grin_r(
	    .din           (arb_pcxdp_grant_pa),
	    .q             (grant_px),
	    .clk           (rclk),
	    .se            (1'b0),
	    .si            (1'b0),
	    .so            ());
//DATAPATH SECTION

   
   dff_s   #(130) dff_pcx_datain_q1(
	    .din           (src_pcx_data_pa[129:0]),
	    .q             (q1_dataout[129:0]),
	    .clk           (clkq1),
	    .se            (1'b0),
	    .si            (),
	    .so            ());

/*
   mux2ds #(`PCX_WIDTH) mx2ds_pcx_datain_q0(
	    .dout            (q0_datain_pa[`PCX_WIDTH-1:0]),
            .in0             (q1_dataout[`PCX_WIDTH-1:0]),
	    .in1             (src_pcx_data_pa[`PCX_WIDTH-1:0]),
	    .sel0            (arb_pcxdp_shift_px),
	    .sel1            (arb_pcxdp_qsel0_pa));
  */
 
assign q0_datain_pa[129:0] = 
             (arb_pcxdp_qsel0_pa ? src_pcx_data_pa[129:0] : 130'd0) |
	     (arb_pcxdp_shift_px ? q1_dataout[129:0] : 130'd0) ;
  
   
   dff_s   #(130) dff_pcx_datain_q0(
	    .din           (q0_datain_pa[129:0]),
	    .q             (q0_dataout[129:0]),
	    .clk           (clkq0),
	    .se            (1'b0),
	    .si            (),
	    .so            ());
   assign data_px_l[129:0] = ~(grant_px ? q0_dataout[129:0]:130'd0);
   assign data_out_px_l[129:0] = data_px_l[129:0] & data_crit_px_l[129:0] & data_ncrit_px_l[129:0];
   
 	 
//    Global Variables:
// verilog-library-directories:("." "../../../../../common/rtl" "../rtl")
// End:


   
// Code start here 
//
endmodule




