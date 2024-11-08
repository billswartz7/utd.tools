// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp_pllcnt.v
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
//
//    Cluster Name:  CTU
//    Unit Name: ctu_clsp_pllcnt
//
//-----------------------------------------------------------------------------
`include "ctu.h"
module ctu_clsp_pllcnt(/*AUTOARG*/
// Outputs
pll_locked_jl, pll_reset_ref_l, pll_reset_ref_dly1_l, 
// Inputs
pll_raw_clk_out, io_pwron_rst_l, testmode_l, wrm_rst_ref, 
wrm_rst_fc_ref, tst_rst_ref, bypclksel
);


   input       pll_raw_clk_out;
   input       io_pwron_rst_l;
   input       testmode_l;
   input       wrm_rst_ref;
   input       wrm_rst_fc_ref;
   input       tst_rst_ref;
   input       bypclksel;

   output      pll_locked_jl;

   output      pll_reset_ref_l;
   output      pll_reset_ref_dly1_l;


   parameter    PLL_ASSERTION_CNT = 7'h7F; // 128 cycles 
   parameter    PLL_BYPASS_CNT = 15'h0010; // 16 cycles 
   parameter    PLL_LCK_CNT = 15'h7b00; // 25us 32K cycles - pll assertion time
   parameter    WRM_RST_CNT = 15'h7d0;  // 2K cycles 
   parameter    TST_RST_CNT = 15'h100;  // 256 cycles 
   parameter    FC_DCNT = 3'b010;  //  3 cycles
    
   wire wrm_rst_ref_dly2_l;
   wire wrm_rst_ref_fc_dly1;
   wire wrm_rst_ref_fc_dly2_l;
   wire tst_rst_ref_dly1;
   wire tst_rst_ref_dly2_l;
   //wire por_rst_ref_dly_l;
   wire tst_rst_ld;
   wire wrm_rst_ld;
   wire wrm_rst_fc_ld;
   wire por_rst_ld;
   wire relock;

   reg  [14:0] pll_lck_cnt_init_nxt;
   wire [14:0] pll_lck_cnt_init;
   wire pll_lck_cnt_ld_nxt;
   wire pll_lck_cnt_ld_1sht;

   wire pwron_rst_l_d1;
   wire pwron_rst_l_d2;
   wire por_rst_1sht;
   wire pll_locked_ref;

   wire fc_dcnt_dn;
   wire fc_dcnt_ld;
   wire fc_dcnt_ld_nxt;
   wire fc_dcnt_en;
   wire [2:0] fc_dcnt_nxt;
   wire [2:0] fc_dcnt;
 
   wire pll_rst_cnt_dn;
   wire [6:0] pll_rst_cnt_nxt;
   wire [6:0] pll_rst_cnt;
   wire pll_rst_cnt_en;
   wire pll_lck_cnt_dn;
   wire [14:0]  pll_lck_cnt_nxt;
   wire [14:0]  pll_lck_cnt;
   wire pll_lck_cnt_en;

   //wire  pll_reset_ref_pre_l;
   wire  pll_reset_ref_dly1_pre_l;
   wire  bypclksel_sync;
   wire pll_reset_short_l;
   wire pll_reset_short_l_nxt;
   wire pll_reset_dly1_l_nxt;
   wire pll_reset_dly1_l;
   wire pll_reset_dly2_l;
   wire pll_reset_ref_l_nxt;
   wire pll_reset_ref_dly1_l_nxt;

   wire [4:0] rstsm;
   reg [4:0] nxt_rstsm;

//------------------------------
//
//  synchronizers
//
//------------------------------


   ctu_synchronizer u_bypclksel(
             .presyncdata(bypclksel),
             .syncdata (bypclksel_sync),
             .clk(pll_raw_clk_out)
              );

   ctu_synchronizer u_pwron_rst_l(
             .presyncdata(io_pwron_rst_l),
             .syncdata (pwron_rst_l_d1),
             .clk(pll_raw_clk_out)
              );

 // ref_clk -> jbus_clk

   ctu_synch_ref_jl u_pll_locked_jl(
             .presyncdata(pll_locked_ref),
             .syncdata (pll_locked_jl),
             .pll_raw_clk_out(pll_raw_clk_out)
              );

//------------------------------
//
//  register inputs
//
//------------------------------

   dff_ns u_wrm_rst_dly1_l(
		      .din (wrm_rst_ref),
		      .clk (pll_raw_clk_out),
		      .q (wrm_rst_ref_dly1));

   dff_ns u_wrm_rst_dly2_l(
		      .din (~wrm_rst_ref_dly1),
		      .clk (pll_raw_clk_out),
		      .q (wrm_rst_ref_dly2_l));

   assign wrm_rst_ld = wrm_rst_ref_dly1 & wrm_rst_ref_dly2_l; 

   dff_ns u_wrm_rst_fc_dly(
                      .din (wrm_rst_fc_ref),
                      .clk (pll_raw_clk_out),
                      .q (wrm_rst_ref_fc_dly1));

   dff_ns u_wrm_rst_fc_dly2_l(
                      .din (~wrm_rst_ref_fc_dly1),
                      .clk (pll_raw_clk_out),
                      .q (wrm_rst_ref_fc_dly2_l));

   assign wrm_rst_fc_ld = wrm_rst_ref_fc_dly1  & wrm_rst_ref_fc_dly2_l;

   dff_ns u_tst_rst_dly1(
		      .din (tst_rst_ref),
		      .clk (pll_raw_clk_out),
		      .q (tst_rst_ref_dly1));

   dff_ns u_tst_rst_dly2_l(
		      .din (~tst_rst_ref_dly1),
		      .clk (pll_raw_clk_out),
		      .q (tst_rst_ref_dly2_l));

   assign tst_rst_ld = tst_rst_ref_dly1 & tst_rst_ref_dly2_l; 


   assign por_rst_ld = ~pll_reset_ref_l ; 


   always @(/*AUTOSENSE*/bypclksel_sync or pll_lck_cnt_init
	    or por_rst_ld or tst_rst_ld or wrm_rst_fc_ld or wrm_rst_ld)
   begin
       case (1'b1)
       (por_rst_ld & ~bypclksel_sync) | wrm_rst_fc_ld:  pll_lck_cnt_init_nxt =  PLL_LCK_CNT;
       wrm_rst_ld :  pll_lck_cnt_init_nxt =  WRM_RST_CNT;
       tst_rst_ld :  pll_lck_cnt_init_nxt =  TST_RST_CNT;
       (por_rst_ld & bypclksel_sync) :  pll_lck_cnt_init_nxt =  PLL_BYPASS_CNT;
       default : pll_lck_cnt_init_nxt =  pll_lck_cnt_init;
       endcase
   end

   dffrl_async_ns #(15) u_pll_lck_cnt_init(
                      .din ( pll_lck_cnt_init_nxt),
                      .clk (pll_raw_clk_out),
                      .rst_l(io_pwron_rst_l),
                      .q (pll_lck_cnt_init));

 
   assign pll_lck_cnt_ld_nxt = tst_rst_ld | wrm_rst_ld | por_rst_ld | wrm_rst_ld;

   dff_ns u_pll_lck_cnt_ld (
		      .din (pll_lck_cnt_ld_nxt),
		      .clk (pll_raw_clk_out),
		      .q (pll_lck_cnt_ld_1sht));

       
   // tester reset and warm rset are mutually exclusive
   assign  relock = tst_rst_ld | wrm_rst_ld | wrm_rst_fc_ld;

//------------------------------------------------------- 
// detect an edge on por to reset the PLL and lock counter 
// use the reference clock to generate this edge 
//-------------------------------------------------------

  

   dff_ns u_por_rst_ff_d (
		      .din (pwron_rst_l_d1),
		      .clk (pll_raw_clk_out),
		      .q (pwron_rst_l_d2));

   assign por_rst_1sht = pwron_rst_l_d1 & (~pwron_rst_l_d2);

//------------------------------
//
//  pll rst counter:
//
//------------------------------

    assign pll_rst_cnt_dn = (pll_rst_cnt ==  PLL_ASSERTION_CNT );
    assign pll_rst_cnt_nxt = pll_reset_ref_l ? 7'h00:
                             pll_rst_cnt_en ? pll_rst_cnt + 7'b0000001 :
                             pll_rst_cnt;

    dffrl_async_ns #(7) u_pll_rst_cnt (
                      .din ( pll_rst_cnt_nxt),
                      .clk (pll_raw_clk_out),
                      .rst_l(io_pwron_rst_l),
                      .q (pll_rst_cnt));

//------------------------------
//
//  pll lock counter:
//
//------------------------------



    assign pll_lck_cnt_dn = ~(|pll_lck_cnt[14:1]) & pll_lck_cnt[0];
    assign pll_lck_cnt_nxt = pll_lck_cnt_ld_1sht ?  pll_lck_cnt_init:
                             pll_lck_cnt_en ?  pll_lck_cnt - 15'h0001 :
                             pll_lck_cnt;

    dffrl_async_ns #(15) u_pll_lck_cnt (
                      .din ( pll_lck_cnt_nxt),
                      .clk (pll_raw_clk_out),
                      .rst_l(io_pwron_rst_l),
                      .q (pll_lck_cnt));

//------------------------------
//
//  frequncy change delay counter:
//
//------------------------------

    assign fc_dcnt_dn = (fc_dcnt ==  FC_DCNT );
    assign fc_dcnt_nxt = fc_dcnt_ld ? 3'b000:
                             fc_dcnt_en ? fc_dcnt + 3'b001 :
                             fc_dcnt;

    dffrl_async_ns #(3) u_fc_dcnt (
                      .din ( fc_dcnt_nxt),
                      .clk (pll_raw_clk_out),
                      .rst_l(io_pwron_rst_l),
                      .q (fc_dcnt));

//------------------------------
//
//  pll state machine :
//
//------------------------------


   dffrl_async_ns #(4) u_rstsm_4_1 (
			   .din (nxt_rstsm[4:1]),
			   .clk (pll_raw_clk_out),
			   .rst_l (io_pwron_rst_l),
			   .q (rstsm[4:1]));

   dffsl_async_ns    u_rstsm_0 (
			   .din (nxt_rstsm[0]),
			   .clk (pll_raw_clk_out),
			   .set_l (io_pwron_rst_l),
			   .q (rstsm[0]));

   always @(/*AUTOSENSE*/
	    fc_dcnt_dn or pll_lck_cnt_dn or pll_rst_cnt_dn
	    or por_rst_1sht or relock or rstsm or wrm_rst_fc_ref)
   begin
         // CoverMeter line_off
            nxt_rstsm = 5'bxxxxx;
         // CoverMeter line_on

   case (1'b1)                                                         //synopsys parallel_case
	  rstsm[`RSTSM_WAIT_POR]:
	    begin
                 nxt_rstsm = por_rst_1sht? `ST_RSTSM_RST_PLL : `ST_RSTSM_WAIT_POR;
	    end
	  rstsm[`RSTSM_RST_PLL]: 
	    begin
               nxt_rstsm = pll_rst_cnt_dn ? `ST_RSTSM_WAIT_PLL_LCK:
                           `ST_RSTSM_RST_PLL;
	    end
	  rstsm[`RSTSM_WAIT_PLL_LCK]:
	    begin
               nxt_rstsm = pll_lck_cnt_dn? `ST_RSTSM_PLL_LCK:
                           `ST_RSTSM_WAIT_PLL_LCK;
	    end
	  rstsm[`RSTSM_PLL_LCK]:
	    begin
               nxt_rstsm = relock ?
                           (wrm_rst_fc_ref? `ST_RSTSM_FREQ_CHG:`ST_RSTSM_WAIT_PLL_LCK) :
                           `ST_RSTSM_PLL_LCK;
	    end
	  rstsm[`RSTSM_FREQ_CHG]:
	    begin
               nxt_rstsm = fc_dcnt_dn?
                           `ST_RSTSM_RST_PLL : `ST_RSTSM_FREQ_CHG;
	    end
         // CoverMeter line_off
	  default:
	    begin
            nxt_rstsm = 5'bxxxxx;
	    end
         // CoverMeter line_on
	endcase // case(rstsm)
       end // begin

// -----------------------------------------------------------
//
// state outputs as function of current state
//
// -----------------------------------------------------------

  assign  pll_rst_cnt_en =  rstsm[`RSTSM_RST_PLL];
  assign  pll_lck_cnt_en =  rstsm[`RSTSM_WAIT_PLL_LCK];
  assign  fc_dcnt_en =  rstsm[`RSTSM_FREQ_CHG];
 
  assign fc_dcnt_ld_nxt =  nxt_rstsm[`RSTSM_FREQ_CHG] & rstsm[`RSTSM_PLL_LCK];

  dffrl_async_ns u_fc_dcnt_ld ( .din (fc_dcnt_ld_nxt ), 
                 .rst_l (io_pwron_rst_l),
                 .q (fc_dcnt_ld), .clk (pll_raw_clk_out));


  // pll_reset_ref_l is used to reset pll
  // pll_reset_ref_dly1_l is used to reset waveform generator


  // including frequency change
  assign pll_reset_dly1_l_nxt = ~(nxt_rstsm[`RSTSM_RST_PLL]);

  dffsl_async_ns u_pll_reset_dly1_l( .din (pll_reset_dly1_l_nxt), 
                 .set_l (io_pwron_rst_l),
                 .q (pll_reset_dly1_l), .clk (pll_raw_clk_out));

  dffsl_async_ns u_pll_reset_dly2_l( .din (pll_reset_dly1_l), 
                 .set_l (io_pwron_rst_l),
                 .q (pll_reset_dly2_l), .clk (pll_raw_clk_out));


  assign pll_reset_short_l_nxt = nxt_rstsm[`RSTSM_WAIT_POR] | 
                               nxt_rstsm[`RSTSM_WAIT_PLL_LCK] |
			       nxt_rstsm[`RSTSM_PLL_LCK] |
			       nxt_rstsm[`RSTSM_FREQ_CHG] |
			       rstsm[`RSTSM_PLL_LCK] ;

  dffsl_async_ns u_pll_reset_short ( .din (pll_reset_short_l_nxt), 
                 .set_l (io_pwron_rst_l),
                 .q (pll_reset_short_l), .clk (pll_raw_clk_out));


  //assign pll_reset_ref_l_nxt = pll_reset_dly1_l | pll_reset_dly2_l;
  assign pll_reset_ref_l_nxt = pll_reset_short_l | pll_reset_dly2_l;

  dffsl_async_ns u_pll_reset_ref_l( .din (pll_reset_ref_l_nxt), 
                 .set_l (io_pwron_rst_l),
                 .q (pll_reset_ref_l), .clk (pll_raw_clk_out));

  assign  pll_reset_ref_dly1_l_nxt =  pll_reset_short_l & pll_reset_dly2_l;

  dffsl_async_ns u_pll_reset_ref_dly1_l( .din (pll_reset_ref_dly1_l_nxt), 
                 .set_l (io_pwron_rst_l),
                 .q (pll_reset_ref_dly1_pre_l), .clk (pll_raw_clk_out));

  assign pll_reset_ref_dly1_l =  testmode_l ? pll_reset_ref_dly1_pre_l :1'b1;
  
  // Used for clock generation

  assign  pll_locked_ref= rstsm[`RSTSM_PLL_LCK];

//synopsys translate_off

   reg [8*18:1] text; 

   always @(rstsm[4:0])
   case (1'b1)
   rstsm[`RSTSM_WAIT_POR] : text = "POR";
   rstsm[`RSTSM_RST_PLL ] : text = "RPLL";
   rstsm[`RSTSM_WAIT_PLL_LCK] : text = "WLCK";
   rstsm[`RSTSM_PLL_LCK] : text = "LCK";
   rstsm[`RSTSM_FREQ_CHG ] : text = "FC";
   default :  text = "UNKNOWN";
   endcase

//synopsys translate_on


endmodule // pll_cnt 








