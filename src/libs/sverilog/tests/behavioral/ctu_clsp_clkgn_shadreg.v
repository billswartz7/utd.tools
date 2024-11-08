// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp_clkgn_shadreg.v
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
//    Unit Name: ctu_clsp_clkgn_shadreg
//
//-----------------------------------------------------------------------------
`include "sys.h"
`include "ctu.h"

module ctu_clsp_clkgn_shadreg (/*AUTOARG*/
// Outputs
jsync_shadreg_rx2, jsync_shadreg_rx1, jsync_shadreg_rx0, 
jsync_shadreg_tx2, jsync_shadreg_tx1, jsync_shadreg_tx0, 
jsync_shadreg_period, jsync_shadreg_init, dsync_shadreg_rx2, 
dsync_shadreg_rx1, dsync_shadreg_rx0, dsync_shadreg_tx2, 
dsync_shadreg_tx1, dsync_shadreg_tx0, dsync_shadreg_period, 
dsync_shadreg_init, shadreg_cdiv_vec, shadreg_cdiv_0, 
shadreg_ddiv_vec, shadreg_ddiv_0, shadreg_jdiv_vec, shadreg_jdiv_0, 
cmp_grst_cl_l, cmp_dbginit_cl_l, a_grst_dl, a_dbginit_dl, 
de_grst_dsync_edge_dl, de_grst_jsync_edge, de_dbginit_dsync_edge_dl, 
de_dbginit_jsync_edge, coin_cnt_en, coin_cnt_ld, coin_edge, 
shadreg_div_jmult, shadreg_div_dmult, shadreg_div_cmult, 
// Inputs
io_pwron_rst_l, se, start_clk_early_jl, start_clk_cl, cmp_clk, 
jbus_tx_sync, ctu_dram_tx_sync_early, a_dbginit_cl, de_dbginit_cl, 
de_grst_cl, a_grst_cl, dram_a_grst_cl, update_shadow_cl, 
jtag_ctu_bypass_mode, jsync_reg_rx2, jsync_reg_rx1, jsync_reg_rx0, 
jsync_reg_tx2, jsync_reg_tx1, jsync_reg_tx0, jsync_reg_period, 
jsync_reg_init, dsync_reg_rx2, dsync_reg_rx1, dsync_reg_rx0, 
dsync_reg_tx2, dsync_reg_tx1, dsync_reg_tx0, dsync_reg_period, 
dsync_reg_init, reg_div_cmult, reg_div_jmult, reg_div_dmult, 
reg_cdiv_0, reg_cdiv_vec, reg_ddiv_0, reg_ddiv_vec, reg_jdiv_0, 
reg_jdiv_vec
);

   // global inputs
   input io_pwron_rst_l;
   input se;
   input start_clk_early_jl;
   input start_clk_cl;    // reset to flops that interface to fstlog block

   input cmp_clk;

   input jbus_tx_sync;    
   input  ctu_dram_tx_sync_early;    

   // reset ctrl signals
   input a_dbginit_cl;
   input de_dbginit_cl;
   input de_grst_cl;
   input a_grst_cl;
   input dram_a_grst_cl;
   input update_shadow_cl;
   input jtag_ctu_bypass_mode;

   // CSR registers
   input [1:0] jsync_reg_rx2;
   input [1:0] jsync_reg_rx1;
   input [1:0] jsync_reg_rx0;
   input [4:0] jsync_reg_tx2;
   input [4:0] jsync_reg_tx1;
   input [4:0] jsync_reg_tx0;
   input [4:0] jsync_reg_period;
   input [4:0] jsync_reg_init;

   input [1:0] dsync_reg_rx2;
   input [1:0] dsync_reg_rx1;
   input [1:0] dsync_reg_rx0;
   input [4:0] dsync_reg_tx2;
   input [4:0] dsync_reg_tx1;
   input [4:0] dsync_reg_tx0;
   input [4:0] dsync_reg_period;
   input [4:0] dsync_reg_init;

   input [13:0]  reg_div_cmult;
   input [9:0]  reg_div_jmult;
   input [9:0]  reg_div_dmult;


   input  reg_cdiv_0;
   input  [14:0] reg_cdiv_vec;
   input  reg_ddiv_0;
   input  [14:0] reg_ddiv_vec;
   input  reg_jdiv_0;
   input  [14:0] reg_jdiv_vec;

   
   output [1:0] jsync_shadreg_rx2;
   output [1:0] jsync_shadreg_rx1;
   output [1:0] jsync_shadreg_rx0;
   output [4:0] jsync_shadreg_tx2;
   output [4:0] jsync_shadreg_tx1;
   output [4:0] jsync_shadreg_tx0;
   output [4:0] jsync_shadreg_period;
   output [4:0] jsync_shadreg_init;

   output [1:0] dsync_shadreg_rx2;
   output [1:0] dsync_shadreg_rx1;
   output [1:0] dsync_shadreg_rx0;
   output [4:0] dsync_shadreg_tx2;
   output [4:0] dsync_shadreg_tx1;
   output [4:0] dsync_shadreg_tx0;
   output [4:0] dsync_shadreg_period;
   output [4:0] dsync_shadreg_init;

   output [14:0] shadreg_cdiv_vec;
   output shadreg_cdiv_0;
   output [14:0] shadreg_ddiv_vec;
   output shadreg_ddiv_0;
   output [14:0] shadreg_jdiv_vec;
   output shadreg_jdiv_0;

    // reset output ( generated with sync pulses)
   output cmp_grst_cl_l;
   output cmp_dbginit_cl_l;

   output a_grst_dl;
   output a_dbginit_dl;
   output de_grst_dsync_edge_dl;
   output de_grst_jsync_edge;
   output de_dbginit_dsync_edge_dl;
   output de_dbginit_jsync_edge;

  // to clkgen for sync pulses

   output      coin_cnt_en;
   output      coin_cnt_ld;
   output      coin_edge;

   output [9:0] shadreg_div_jmult;
   output [9:0] shadreg_div_dmult;
   output [13:0] shadreg_div_cmult;


   wire se_bar;
   // rx & tx sync pulse

   wire coin_cnt_1st_en;
   wire coin_cnt_en;
   wire coin_cnt_ld;


   // lcm logic

   wire cnt_ld;
   wire [13:0] lcm_cnt_minus_1;
   wire [13:0] lcm_cnt_nxt;
   wire [13:0] lcm_cnt;
   wire lcm_cnt_zero;
   wire grst_en_window_nxt;
   wire grst_en_window;
   wire cmp_grst_cl_l_nxt;
   wire dbginit_en_window_nxt;
   wire dbginit_en_window;
   wire cmp_dbginit_cl_l_nxt;


   // shadow registers

   wire jsync_update_shadow_cl;
   wire dsync_update_shadow_cl;
   wire [1:0] jsync_shadreg_rx2_nxt;
   wire [1:0] jsync_shadreg_rx1_nxt;
   wire [1:0] jsync_shadreg_rx0_nxt;
   wire [4:0] jsync_shadreg_tx2_nxt;
   wire [4:0] jsync_shadreg_tx1_nxt;
   wire [4:0] jsync_shadreg_tx0_nxt;
   wire [4:0] jsync_shadreg_period_nxt;
   wire [4:0] jsync_shadreg_init_nxt;
   wire [1:0] dsync_shadreg_rx2_nxt;
   wire [1:0] dsync_shadreg_rx1_nxt;
   wire [1:0] dsync_shadreg_rx0_nxt;
   wire [4:0] dsync_shadreg_tx2_nxt;
   wire [4:0] dsync_shadreg_tx1_nxt;
   wire [4:0] dsync_shadreg_tx0_nxt;
   wire [4:0] dsync_shadreg_period_nxt;
   wire [4:0] dsync_shadreg_init_nxt;

   wire update_shadow_1sht;
   wire update_shadow_cl_dly_l;
   wire mult_update_shadow_cl;
   wire [13:0] shadreg_div_cmult_nxt;
   wire [13:0] shadreg_div_cmult;
   wire [9:0] shadreg_div_dmult_nxt;
   wire [9:0] shadreg_div_jmult_nxt;
   wire [9:0] shadreg_div_jmult;
   wire [9:0] shadreg_div_dmult;

   wire div_update_shadow_cl;
   wire shadreg_cdiv_0_nxt;
   wire shadreg_cdiv_0;
   wire shadreg_jdiv_0_nxt;
   wire shadreg_jdiv_0;
   wire shadreg_ddiv_0_nxt;
   wire shadreg_ddiv_0;

   wire [14:0] shadreg_cdiv_vec_nxt;
   wire [14:0] shadreg_cdiv_vec;
   wire [14:0] shadreg_cdiv_vec_pre;
   wire [14:0] shadreg_jdiv_vec_nxt;
   wire [14:0] shadreg_jdiv_vec;
   wire [14:0] shadreg_jdiv_vec_pre;
   wire [14:0] shadreg_jdiv_vec_byp;
   wire [14:0] shadreg_jdiv_vec_byp_nxt;
   wire [14:0] shadreg_ddiv_vec_nxt;
   wire [14:0] shadreg_ddiv_vec;
   wire [14:0] shadreg_ddiv_vec_pre;
   wire [14:0] shadreg_ddiv_vec_byp;
   wire [14:0] shadreg_ddiv_vec_byp_nxt;

   wire  ctu_dram_tx_sync_early;
   wire coin_edge_nxt;
   wire de_grst_jsync_edge_nxt;
   wire de_grst_dsync_edge_dl_nxt;
   wire a_grst_dl_nxt;
   wire a_dbginit_dl_nxt;
   wire de_dbginit_jsync_edge_nxt;
   wire de_dbginit_dsync_edge_dl_nxt;



   // -----------------------------------------------
   // 
   //  Register input
   // 
   // -----------------------------------------------

    dff_ns  u_update_shadow_cl_dly_l(
         .din (~update_shadow_cl),
         .clk (cmp_clk),
         .q(update_shadow_cl_dly_l));

   //assign update_shadow_1sht = update_shadow_cl & update_shadow_cl_dly_l & start_clk_cl;
   assign update_shadow_1sht = update_shadow_cl & update_shadow_cl_dly_l  ;

    dffrl_async_ns #(4)  u_update_shadow_cl(
         .din ({4{update_shadow_1sht}}),
         .clk (cmp_clk),
         .rst_l (io_pwron_rst_l),
         .q   ({jsync_update_shadow_cl,
                dsync_update_shadow_cl,
                mult_update_shadow_cl,
                div_update_shadow_cl}));

// -----------------------------------------
// 
//  Rx Tx sync pulse enable
// 
// -----------------------------------------

// enable as soon as clock cmp_clk is available
   
dffrl_async_ns u_coin_cnt_en(
		   .din (1'b1),
		   .clk (cmp_clk),
                   //.rst_l (io_pwron_rst_l),
                   .rst_l (start_clk_early_jl),
                   .q(coin_cnt_1st_en));

dffrl_async_ns u_coin_cnt_en_ff(
                  .din(coin_cnt_1st_en), 
                  .clk(cmp_clk),
                  .rst_l (start_clk_early_jl),
                  //.rst_l (io_pwron_rst_l),
                  .q(coin_cnt_en));

assign coin_cnt_ld = coin_cnt_1st_en & ~coin_cnt_en;

dffsl_async_ns  u_cnt_ld(
                   .din (1'b0),
                   .clk (cmp_clk),
                   .set_l (start_clk_early_jl),
                   .q(cnt_ld));


assign lcm_cnt_minus_1 = lcm_cnt - 14'h0001;

assign lcm_cnt_nxt =  cnt_ld? shadreg_div_cmult[13:0]:
                      (|(lcm_cnt[13:1])) ?   lcm_cnt_minus_1  :
                      shadreg_div_cmult[13:0];

dffrl_async_ns #(14) u_lcm_ff (
		   .din (lcm_cnt_nxt),
		   .clk (cmp_clk),
                   .rst_l (start_clk_early_jl), 
                   .q(lcm_cnt));

assign lcm_cnt_zero =  ~(|(lcm_cnt[13:1]));
assign coin_edge_nxt =  (lcm_cnt == `COIN_EDGE_LATENCY) & start_clk_cl;
dffrl_async_ns u_coin_edge( .din (coin_edge_nxt),
		   .clk (cmp_clk),
                   .rst_l (io_pwron_rst_l),
                   .q(coin_edge));

// -----------------------------------------
// 
//  sync edges align (LCM) for generating grst
// 
// -----------------------------------------

// -----------------------------------------
// 
//  de_grst_dsync_edge_dl open enable window in dram_gclk domain
//  de_grst_jsync_edge opens enable window in jbus_clk domain
//  same for dbginit signals
// 
// -----------------------------------------

assign de_grst_dsync_edge_dl_nxt = ( ctu_dram_tx_sync_early ? de_grst_cl: de_grst_dsync_edge_dl) & start_clk_cl;

dffrl_async_ns u_de_grst_dsync_edge_dl (.din (de_grst_dsync_edge_dl_nxt),
                       .rst_l (io_pwron_rst_l),
                       .clk(cmp_clk),
                       .q(de_grst_dsync_edge_dl));

assign de_grst_jsync_edge_nxt = (jbus_tx_sync ? de_grst_cl: de_grst_jsync_edge) & start_clk_cl;
dffrl_async_ns u_de_grst_jsync_edge (.din (de_grst_jsync_edge_nxt),
                       .rst_l (io_pwron_rst_l),
                       .clk(cmp_clk),
                       .q(de_grst_jsync_edge));

assign de_dbginit_dsync_edge_dl_nxt = ( ctu_dram_tx_sync_early? de_grst_cl | de_dbginit_cl:
                                                  de_dbginit_dsync_edge_dl) & start_clk_cl;

dffrl_async_ns u_de_dbginit_dsync_edge_dl (.din (de_dbginit_dsync_edge_dl_nxt),
                       .rst_l (io_pwron_rst_l),
                       .clk(cmp_clk),
                       .q(de_dbginit_dsync_edge_dl));

assign de_dbginit_jsync_edge_nxt = (jbus_tx_sync? de_grst_cl | de_dbginit_cl:
                                                  de_dbginit_jsync_edge) & start_clk_cl;
dffrl_async_ns u_de_dbginit_jsync_edge (.din (de_dbginit_jsync_edge_nxt),
                       .rst_l (io_pwron_rst_l),
                       .clk(cmp_clk),
                       .q(de_dbginit_jsync_edge));


// -----------------------------------------
// 
//  grst_l signal only allow to de-assert when grst_en_window is 1
// 
// -----------------------------------------

assign grst_en_window_nxt = de_grst_dsync_edge_dl & de_grst_jsync_edge & lcm_cnt_zero ? 1'b1:
                            lcm_cnt_zero &  grst_en_window ? 1'b0:
                            grst_en_window;

dffrl_ns u_grst_en_window( .din (grst_en_window_nxt),
		   .clk (cmp_clk),
                   .rst_l (start_clk_cl),
                   .q(grst_en_window));

// -----------------------------------------
// 
//  cmp_grst_cl_l is set when the pipeline latency is reached and enable window is 1
//  cmp_grst_cl_l is reset by a_grst_cl 
// 
// -----------------------------------------


assign cmp_grst_cl_l_nxt  = (lcm_cnt == `CMP_GLOBAL_LATENCY) & grst_en_window ? 1'b1:
                        a_grst_cl ? 1'b0:
                        cmp_grst_cl_l;

dffrl_ns u_cmp_grst_cl_l(
		   .din (cmp_grst_cl_l_nxt),
		   .clk (cmp_clk),
                   .rst_l(start_clk_cl),
                   .q(cmp_grst_cl_l));
// ----------------------------------------------------------------------
// 
//  dbginit_l signal only allow to de-assert when dbginit_en_window is 1
//  (i.e. when  de_grst_cl | de_dbginit_cl is asserted) 
//  dbginit_l signal is reset by a_grst_cl | a_dbginit_cl signal
// 
// ---------------------------------------------------------------------

assign dbginit_en_window_nxt = de_dbginit_dsync_edge_dl & de_dbginit_jsync_edge &  lcm_cnt_zero  ? 1'b1:
                            lcm_cnt_zero  &  dbginit_en_window ? 1'b0:
                            dbginit_en_window;

dffrl_ns u_dbginit_en_window( .din (dbginit_en_window_nxt),
                   .clk (cmp_clk),
                   .rst_l (start_clk_cl),
                   .q(dbginit_en_window));

assign cmp_dbginit_cl_l_nxt  = 
                        a_grst_cl | a_dbginit_cl ? 1'b0:
                        (lcm_cnt == `CMP_GLOBAL_LATENCY) & dbginit_en_window ? 1'b1:
                        cmp_dbginit_cl_l;

dffrl_ns u_cmp_dbginit_cl_l(
		   .din (cmp_dbginit_cl_l_nxt),
		   .clk (cmp_clk),
                   .rst_l(start_clk_cl),
                   .q(cmp_dbginit_cl_l));

//---------------------------------------------------------------------------
//
// assert signal synchronize in cmp clock domain
//
//---------------------------------------------------------------------------

assign a_grst_dl_nxt = ( ctu_dram_tx_sync_early ? dram_a_grst_cl: a_grst_dl) & start_clk_cl;

dffrl_async_ns u_a_grst_dl (.din (a_grst_dl_nxt),
                       .rst_l (io_pwron_rst_l),
                       .clk(cmp_clk),
                       .q(a_grst_dl));

assign a_dbginit_dl_nxt =  ( ctu_dram_tx_sync_early ? a_dbginit_cl : a_dbginit_dl) & start_clk_cl;
dffrl_async_ns u_a_dbginit_dl (.din (a_dbginit_dl_nxt),
                       .rst_l (io_pwron_rst_l),
                       .clk(cmp_clk),
                       .q(a_dbginit_dl));

//---------------------------------------------------------------------------
//
// Register : jbus  sync pulse (cmp_clk)
//
//---------------------------------------------------------------------------

// JSYNC_TRN2 36:32  (default 1)
// JSYNC_RCV1 28:24  (default 2)
// JSYNC_TRN1 23:22  (default 1)
// JSYNC_RCV0 20:16  (default 2)
// JSYNC_TRN0 15:13  (default 1)
// JSYNC_INIT 12:8   (default 5)
// JSYNC_PERIOD 4:0  (default 3)


assign    jsync_shadreg_rx2_nxt  =  jsync_update_shadow_cl ? jsync_reg_rx2
                           :    jsync_shadreg_rx2;

dffrl_async_ns  u_jsync_shadreg_rx2_1_ff_async ( .din(jsync_shadreg_rx2_nxt[1]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (jsync_shadreg_rx2[1])
                               );

dffsl_async_ns  u_jsync_shadreg_rx2_0_ff_async ( .din(jsync_shadreg_rx2_nxt[0]), 
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l), 
                                 .q (jsync_shadreg_rx2[0])
                               );

assign    jsync_shadreg_tx2_nxt  =  jsync_update_shadow_cl ? jsync_reg_tx2
                           :    jsync_shadreg_tx2;

dffrl_async_ns  #(5) u_jsync_shadreg_tx2_4_0_ff_async ( .din(jsync_shadreg_tx2_nxt[4:0]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (jsync_shadreg_tx2[4:0])
                               );

assign    jsync_shadreg_rx1_nxt  =  jsync_update_shadow_cl ? jsync_reg_rx1
                           :    jsync_shadreg_rx1;

dffsl_async_ns  u_jsync_shadreg_rx1_0_ff_async ( .din(jsync_shadreg_rx1_nxt[0]), 
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l), 
                                 .q (jsync_shadreg_rx1[0])
                               );

dffrl_async_ns  u_jsync_shadreg_rx1_1_ff_async ( .din(jsync_shadreg_rx1_nxt[1]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (jsync_shadreg_rx1[1])
                               );


// default 6'd10
assign    jsync_shadreg_tx1_nxt  =  jsync_update_shadow_cl ? jsync_reg_tx1
                           :    jsync_shadreg_tx1;

dffrl_async_ns  #(5) u_jsync_shadreg_tx1_4_0_ff_async ( .din(jsync_shadreg_tx1_nxt[4:0]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (jsync_shadreg_tx1[4:0])
                               );


assign    jsync_shadreg_rx0_nxt  =  jsync_update_shadow_cl ? jsync_reg_rx0
                           :    jsync_shadreg_rx0;

dffrl_async_ns  u_jsync_shadreg_rx0_1_ff_async ( .din(jsync_shadreg_rx0_nxt[1]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (jsync_shadreg_rx0[1])
                               );

dffsl_async_ns  u_jsync_shadreg_rx0_0_ff_async ( .din(jsync_shadreg_rx0_nxt[0]), 
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l), 
                                 .q (jsync_shadreg_rx0[0])
                               );


assign    jsync_shadreg_tx0_nxt  =  jsync_update_shadow_cl ? jsync_reg_tx0
                           :    jsync_shadreg_tx0;

dffrl_async_ns  #(5) u_jsync_shadreg_tx0_4_0_ff_async ( .din(jsync_shadreg_tx0_nxt[4:0]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (jsync_shadreg_tx0[4:0])
                               );


// default to 3

assign    jsync_shadreg_period_nxt  =  jsync_update_shadow_cl ?   jsync_reg_period
                             :     jsync_shadreg_period;

dffrl_async_ns  #(3) u_jsync_shadreg_period_4_2 ( .din(jsync_shadreg_period_nxt[4:2]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (jsync_shadreg_period[4:2])
                               );


dffsl_async_ns  #(2)  jsync_shadreg_period_1_0_ff ( .din(jsync_shadreg_period_nxt[1:0]),
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l),
                                 .q (jsync_shadreg_period[1:0])
                               );

// default to  2


assign    jsync_shadreg_init_nxt  =  jsync_update_shadow_cl ? jsync_reg_init
                           :     jsync_shadreg_init;

dffrl_async_ns  #(3) jsync_shadreg_init_4_2_ff ( .din(jsync_shadreg_init_nxt[4:2]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (jsync_shadreg_init[4:2])
                               );

dffsl_async_ns  jsync_shadreg_init_1_ff ( .din(jsync_shadreg_init_nxt[1]),
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l),
                                 .q (jsync_shadreg_init[1])
                               );

dffrl_async_ns       jsync_shadreg_init_0_ff ( .din(jsync_shadreg_init_nxt[0]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (jsync_shadreg_init[0])
                               );
//---------------------------------------------------------------------------
//
// Register : dram sync pulse (cmp_clk)
//
//---------------------------------------------------------------------------
// default 13:2
// DSYNC_RCV2 39:38  (default 2)
// DSYNC_TRN2 36:32  (default 1)
// DSYNC_RCV1 28:24  (default 2)
// DSYNC_TRN1 23:22  (default 1)
// DSYNC_RCV0 20:16  (default 2)
// DSYNC_TRN0 15:13  (default 1)
// DSYNC_INIT 12:8   (default 5)
// DSYNC_PERIOD 4:0  (default 3)


assign    dsync_shadreg_rx2_nxt  =  dsync_update_shadow_cl ? dsync_reg_rx2
                           :    dsync_shadreg_rx2;

dffrl_async_ns  u_dsync_shadreg_rx2_1_ff_async ( .din(dsync_shadreg_rx2_nxt[1]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (dsync_shadreg_rx2[1])
                               );

dffsl_async_ns  u_dsync_shadreg_rx2_0_ff_async ( .din(dsync_shadreg_rx2_nxt[0]), 
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l), 
                                 .q (dsync_shadreg_rx2[0])
                               );

assign    dsync_shadreg_tx2_nxt  =  dsync_update_shadow_cl ? dsync_reg_tx2
                           :    dsync_shadreg_tx2;

dffrl_async_ns  #(5) u_dsync_shadreg_tx2_4_0_ff_async ( .din(dsync_shadreg_tx2_nxt[4:0]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (dsync_shadreg_tx2[4:0])
                               );

 

assign    dsync_shadreg_rx1_nxt  =  dsync_update_shadow_cl ? dsync_reg_rx1
                           :    dsync_shadreg_rx1;

dffsl_async_ns  u_dsync_shadreg_rx1_0_ff_async ( .din(dsync_shadreg_rx1_nxt[0]), 
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l), 
                                 .q (dsync_shadreg_rx1[0])
                               );

dffrl_async_ns  u_dsync_shadreg_rx1_1_ff_async ( .din(dsync_shadreg_rx1_nxt[1]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (dsync_shadreg_rx1[1])
                               );


// default 6'd10
assign    dsync_shadreg_tx1_nxt  =  dsync_update_shadow_cl ? dsync_reg_tx1
                           :    dsync_shadreg_tx1;

dffrl_async_ns  #(5) u_dsync_shadreg_tx1_4_0_ff_async ( .din(dsync_shadreg_tx1_nxt[4:0]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (dsync_shadreg_tx1[4:0])
                               );

 

assign    dsync_shadreg_rx0_nxt  =  dsync_update_shadow_cl ? dsync_reg_rx0
                           :    dsync_shadreg_rx0;

dffrl_async_ns  u_dsync_shadreg_rx0_1_ff_async ( .din(dsync_shadreg_rx0_nxt[1]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (dsync_shadreg_rx0[1])
                               );

dffsl_async_ns  u_dsync_shadreg_rx0_0_ff_async ( .din(dsync_shadreg_rx0_nxt[0]), 
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l), 
                                 .q (dsync_shadreg_rx0[0])
                               );


assign    dsync_shadreg_tx0_nxt  =  dsync_update_shadow_cl ? dsync_reg_tx0
                           :    dsync_shadreg_tx0;

dffrl_async_ns  #(5) u_dsync_shadreg_tx0_4_0_ff_async ( .din(dsync_shadreg_tx0_nxt[4:0]), 
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l), 
                                 .q (dsync_shadreg_tx0[4:0])
                               );


// default to 4
assign    dsync_shadreg_period_nxt  =  dsync_update_shadow_cl ?   dsync_reg_period
                             :     dsync_shadreg_period;


dffrl_async_ns  #(3) u_dsync_shadreg_period_4_2_ff ( .din(dsync_shadreg_period_nxt[4:2]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (dsync_shadreg_period[4:2])
                               );


dffsl_async_ns  #(2)  dsync_shadreg_period_1_0_ff ( .din(dsync_shadreg_period_nxt[1:0]),
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l),
                                 .q (dsync_shadreg_period[1:0])
                               );

// default to  2

assign    dsync_shadreg_init_nxt  =  dsync_update_shadow_cl ? dsync_reg_init
                           :     dsync_shadreg_init;

dffrl_async_ns  #(3) dsync_shadreg_init_4_2_ff ( .din(dsync_shadreg_init_nxt[4:2]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (dsync_shadreg_init[4:2]));

dffsl_async_ns       dsync_shadreg_init_1_ff ( .din(dsync_shadreg_init_nxt[1]),
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l),
                                 .q (dsync_shadreg_init[1]));

dffrl_async_ns       dsync_shadreg_init_0_ff ( .din(dsync_shadreg_init_nxt[0]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (dsync_shadreg_init[0]));

//---------------------------------------------------------------------------
//
// Register : div mult  (cmp_clk)
//
//---------------------------------------------------------------------------


assign    shadreg_div_cmult_nxt =  mult_update_shadow_cl ? reg_div_cmult:
                                  shadreg_div_cmult;
assign    shadreg_div_dmult_nxt =  mult_update_shadow_cl ? reg_div_dmult:
                                  shadreg_div_dmult;
assign    shadreg_div_jmult_nxt =  mult_update_shadow_cl ? reg_div_jmult:
                                  shadreg_div_jmult;

// default to 32
dffrl_async_ns #(8)   u_shadreg_div_cmult_13_6_ff  ( .din(shadreg_div_cmult_nxt[13:6]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (shadreg_div_cmult[13:6])
                               );

dffsl_async_ns        u_shadreg_div_cmult_5_ff ( .din(shadreg_div_cmult_nxt[5]),
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l),
                                 .q (shadreg_div_cmult[5])
                               );

dffrl_async_ns #(5)   u_shadreg_div_cmult_4_0_ff  ( .din(shadreg_div_cmult_nxt[4:0]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (shadreg_div_cmult[4:0])
                               );

// default to 8
dffrl_async_ns #(6)   u_shadreg_div_dmult_9_4_ff  ( .din(shadreg_div_dmult_nxt[9:4]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (shadreg_div_dmult[9:4])
                               );

dffsl_async_ns        u_shadreg_div_dmult_3_ff ( .din(shadreg_div_dmult_nxt[3]),
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l),
                                 .q (shadreg_div_dmult[3])
                               );

dffrl_async_ns #(3)   u_shadreg_div_dmult_2_0_ff  ( .din(shadreg_div_dmult_nxt[2:0]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (shadreg_div_dmult[2:0])
                               );

// default to 8
dffrl_async_ns #(6)   u_shadreg_div_jmult_9_4_ff  ( .din(shadreg_div_jmult_nxt[9:4]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (shadreg_div_jmult[9:4])
                               );

dffsl_async_ns        u_shadreg_div_jmult_3_ff ( .din(shadreg_div_jmult_nxt[3]),
                                 .clk(cmp_clk),
                                 .set_l ( io_pwron_rst_l),
                                 .q (shadreg_div_jmult[3])
                               );

dffrl_async_ns #(3)   u_shadreg_div_jmult_2_0_ff  ( .din(shadreg_div_jmult_nxt[2:0]),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (shadreg_div_jmult[2:0])
                               );
//---------------------------------------------------------------------------
//
// Register : divs  (cmp_clk)
//
//---------------------------------------------------------------------------

assign    se_bar = ~se;


assign    shadreg_cdiv_0_nxt =  div_update_shadow_cl ? reg_cdiv_0 :    
                               shadreg_cdiv_0;

dffrl_async_ns  u_shadreg_cdiv_0_nxt ( .din(shadreg_cdiv_0_nxt),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (shadreg_cdiv_0));

assign   shadreg_ddiv_0_nxt =  div_update_shadow_cl ? reg_ddiv_0
                           :    shadreg_ddiv_0;

dffrl_async_ns  u_shadreg_ddiv_0_nxt ( .din(shadreg_ddiv_0_nxt),
                                 .clk(cmp_clk),
                                 .rst_l ( io_pwron_rst_l),
                                 .q (shadreg_ddiv_0));

assign    shadreg_jdiv_0_nxt =  div_update_shadow_cl ? reg_jdiv_0
                           :    shadreg_jdiv_0;

dffrl_async_ns  u_shadreg_jdiv_0_nxt ( .din(shadreg_jdiv_0_nxt),
                                      .clk(cmp_clk),
                                      .rst_l ( io_pwron_rst_l),
                                      .q (shadreg_jdiv_0));

assign    shadreg_cdiv_vec_nxt =  div_update_shadow_cl ? reg_cdiv_vec :    
                                  shadreg_cdiv_vec_pre;

     dffrl_async_ns  #(5) u_shadreg_cdiv_vec_14_10(.din( shadreg_cdiv_vec_nxt[14:10]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_cdiv_vec_pre[14:10])
                                       );

     dffsl_async_ns #(1) u_shadreg_cdiv_vec_9 (.din( shadreg_cdiv_vec_nxt[9]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_cdiv_vec_pre[9])
                                      );

     dffrl_async_ns #(1) u_shadreg_cdiv_vec_8 (.din( shadreg_cdiv_vec_nxt[8]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_cdiv_vec_pre[8])
                                       );

     dffsl_async_ns #(1) u_shadreg_cdiv_vec_7 (.din( shadreg_cdiv_vec_nxt[7]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_cdiv_vec_pre[7])
                                      );

     dffrl_async_ns  #(3) u_shadreg_cdiv_vec_6_4(.din( shadreg_cdiv_vec_nxt[6:4]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_cdiv_vec_pre[6:4])
                                       );

     dffsl_async_ns #(1) u_shadreg_cdiv_vec_3(.din( shadreg_cdiv_vec_nxt[3]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_cdiv_vec_pre[3])
                                       );

     dffrl_async_ns #(3) u_shadreg_cdiv_vec_2_0(.din( shadreg_cdiv_vec_nxt[2:0]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_cdiv_vec_pre[2:0])
                                       );

    //assign shadreg_cdiv_vec = se? 15'b000_0000_0000_0000 : shadreg_cdiv_vec_pre;
    assign shadreg_cdiv_vec =  {15 {se_bar}} &  shadreg_cdiv_vec_pre;


assign    shadreg_jdiv_vec_nxt =  div_update_shadow_cl ? reg_jdiv_vec :    
                                  shadreg_jdiv_vec_pre;

     dffrl_async_ns  #(1)  u_shadreg_jdiv_vec_14(.din( shadreg_jdiv_vec_nxt[14]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_pre[14])
                                       );

     dffsl_async_ns #(2) u_shadreg_jdiv_vec_13_12 (.din( shadreg_jdiv_vec_nxt[13:12]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_pre[13:12])
                                       );

     dffrl_async_ns #(2) u_shadreg_jdiv_vec_11_10(.din( shadreg_jdiv_vec_nxt[11:10]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_pre[11:10])
                                       );
     dffsl_async_ns #(1) u_shadreg_jdiv_vec_9 (.din( shadreg_jdiv_vec_nxt[9]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_pre[9])
                                       );

     dffrl_async_ns #(3) u_shadreg_jdiv_vec_8_6(.din( shadreg_jdiv_vec_nxt[8:6]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_pre[8:6])
                                       );

     dffsl_async_ns #(1) u_shadreg_jdiv_vec_5(.din( shadreg_jdiv_vec_nxt[5]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_pre[5])
                                       );

     dffrl_async_ns #(3) u_shadreg_jdiv_vec_4_2(.din( shadreg_jdiv_vec_nxt[4:2]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_pre[4:2])
                                       );

     dffsl_async_ns #(1) u_shadreg_jdiv_vec_1(.din( shadreg_jdiv_vec_nxt[1]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_pre[1])
                                       );

     dffrl_async_ns #(1) u_shadreg_jdiv_vec_0(.din( shadreg_jdiv_vec_nxt[0]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_pre[0])
                                       );

     assign    shadreg_jdiv_vec_byp_nxt =  div_update_shadow_cl ? reg_jdiv_vec :
                                  shadreg_jdiv_vec_byp;

     dffrl_async_ns #(5) u_shadreg_jdiv_vec_byp_14_10(.din( shadreg_jdiv_vec_byp_nxt[14:10]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_byp[14:10])
                                       );
     dffsl_async_ns #(1) u_shadreg_jdiv_vec_byp_9 (.din( shadreg_jdiv_vec_byp_nxt[9]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_byp[9])
                                       );

     dffrl_async_ns #(1) u_shadreg_jdiv_vec_byp_8(.din( shadreg_jdiv_vec_byp_nxt[8]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_byp[8])
                                       );

     dffsl_async_ns #(1) u_shadreg_jdiv_vec_byp_7(.din( shadreg_jdiv_vec_byp_nxt[7]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_byp[7])
                                       );

     dffrl_async_ns #(3) u_shadreg_jdiv_vec_byp_6_4(.din( shadreg_jdiv_vec_byp_nxt[6:4]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_byp[6:4])
                                       );

     dffsl_async_ns #(1) u_shadreg_jdiv_vec_byp_3(.din( shadreg_jdiv_vec_byp_nxt[3]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_byp[3])
                                       );

     dffrl_async_ns #(3) u_shadreg_jdiv_vec_byp_2_0(.din( shadreg_jdiv_vec_byp_nxt[2:0]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_jdiv_vec_byp[2:0])
                                       );

    //assign shadreg_jdiv_vec = se? 15'b000_0000_0000_0000:
    //                          jtag_ctu_bypass_mode? shadreg_jdiv_vec_byp
    //                                              : shadreg_jdiv_vec_pre;


    assign shadreg_jdiv_vec =  {15 {se_bar}} &
                              (jtag_ctu_bypass_mode? shadreg_jdiv_vec_byp
                                                  : shadreg_jdiv_vec_pre) ;

    assign shadreg_ddiv_vec_nxt =  div_update_shadow_cl ? reg_ddiv_vec :    
                                  shadreg_ddiv_vec_pre;


     dffrl_async_ns  #(1)  u_shadreg_ddiv_vec_14(.din( shadreg_ddiv_vec_nxt[14]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_pre[14])
                                       );

     dffsl_async_ns #(2) u_shadreg_ddiv_vec_13_12 (.din( shadreg_ddiv_vec_nxt[13:12]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_pre[13:12])
                                       );

     dffrl_async_ns #(2) u_shadreg_ddiv_vec_11_10(.din( shadreg_ddiv_vec_nxt[11:10]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_pre[11:10])
                                       );
     dffsl_async_ns #(1) u_shadreg_ddiv_vec_9 (.din( shadreg_ddiv_vec_nxt[9]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_pre[9])
                                       );

     dffrl_async_ns #(3) u_shadreg_ddiv_vec_8_6(.din( shadreg_ddiv_vec_nxt[8:6]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_pre[8:6])
                                       );

     dffsl_async_ns #(1) u_shadreg_ddiv_vec_5(.din( shadreg_ddiv_vec_nxt[5]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_pre[5])
                                       );

     dffrl_async_ns #(3) u_shadreg_ddiv_vec_4_2(.din( shadreg_ddiv_vec_nxt[4:2]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_pre[4:2])
                                       );

     dffsl_async_ns #(1) u_shadreg_ddiv_vec_1(.din( shadreg_ddiv_vec_nxt[1]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_pre[1])
                                       );

     dffrl_async_ns #(1) u_shadreg_ddiv_vec_0(.din( shadreg_ddiv_vec_nxt[0]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_pre[0])
                                       );

     assign    shadreg_ddiv_vec_byp_nxt =  div_update_shadow_cl ? reg_ddiv_vec :
                                  shadreg_ddiv_vec_byp;

     dffrl_async_ns #(5) u_shadreg_ddiv_vec_byp_14_10(.din( shadreg_ddiv_vec_byp_nxt[14:10]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_byp[14:10])
                                       );
     dffsl_async_ns #(1) u_shadreg_ddiv_vec_byp_9 (.din( shadreg_ddiv_vec_byp_nxt[9]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_byp[9])
                                       );

     dffrl_async_ns #(1) u_shadreg_ddiv_vec_byp_8(.din( shadreg_ddiv_vec_byp_nxt[8]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_byp[8])
                                       );

     dffsl_async_ns #(1) u_shadreg_ddiv_vec_byp_7(.din( shadreg_ddiv_vec_byp_nxt[7]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_byp[7])
                                       );

     dffrl_async_ns #(3) u_shadreg_ddiv_vec_byp_6_4(.din( shadreg_ddiv_vec_byp_nxt[6:4]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_byp[6:4])
                                       );

     dffsl_async_ns #(1) u_shadreg_ddiv_vec_byp_3(.din( shadreg_ddiv_vec_byp_nxt[3]),
                                      .clk(cmp_clk),
                                      .set_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_byp[3])
                                       );

     dffrl_async_ns #(3) u_shadreg_ddiv_vec_byp_2_0(.din( shadreg_ddiv_vec_byp_nxt[2:0]),
                                      .clk(cmp_clk),
                                      .rst_l (io_pwron_rst_l),
                                      .q (shadreg_ddiv_vec_byp[2:0])
                                       );

     //assign shadreg_ddiv_vec = se? 15'b000_0000_0000_0000 :
     //                         jtag_ctu_bypass_mode? shadreg_ddiv_vec_byp
     //                                             : shadreg_ddiv_vec_pre;

     assign shadreg_ddiv_vec = {15 {se_bar}} &
                              (jtag_ctu_bypass_mode? shadreg_ddiv_vec_byp
                                                  : shadreg_ddiv_vec_pre);


endmodule // ctu_clsp_clkgn_shadreg









