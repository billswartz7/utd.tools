// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp_clkgn_syncp.v
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
//    Unit Name: ctu_clsp_clkgn_syncp
//
//-----------------------------------------------------------------------------
`include "sys.h"
`include "ctu.h"

module ctu_clsp_clkgn_syncp (/*AUTOARG*/
// Outputs
tx_sync, rx_sync, 
// Inputs
cmp_clk, start_clk_early_jl, coin_cnt_en, coin_cnt_ld, clsp_sync_tx0, 
clsp_sync_tx1, clsp_sync_tx2, clsp_sync_rx0, clsp_sync_rx1, 
clsp_sync_rx2, clsp_sync_init, clsp_sync_period
);

//-----------------------------------------------------------------------------
// Output sync pulse
//-----------------------------------------------------------------------------
output      tx_sync;
output      rx_sync;

//-----------------------------------------------------------------------------
// Reset & clock
//-----------------------------------------------------------------------------

// Counters Need reset because 1 cmp clock is unknown

input       cmp_clk;
input       start_clk_early_jl; 


//-----------------------------------------------------------------------------
// from cmp clock domain 
//-----------------------------------------------------------------------------

input coin_cnt_en;
input coin_cnt_ld;

input [4:0] clsp_sync_tx0;
input [4:0] clsp_sync_tx1;
input [4:0] clsp_sync_tx2;
input [1:0] clsp_sync_rx0;
input [1:0] clsp_sync_rx1;
input [1:0] clsp_sync_rx2;

input [4:0] clsp_sync_init;
input [4:0] clsp_sync_period;


//=============================================================================
//  Wire/reg declarations
//-----------------------------------------------------------------------------

wire [4:0] coin_tx_cnt_nxt;
wire [4:0] coin_tx_cnt;
wire [4:0] coin_tx_cnt_minus_1;

wire coin_tx0_cmp;
wire coin_tx1_cmp;
wire coin_tx2_cmp;
wire tx_sync;
wire tx_sync_nxt;

wire [1:0] coin_rx_cnt_nxt;
wire [1:0] coin_rx_cnt;
wire [1:0] coin_rx_cnt_plus_1;

wire coin_rx0_cmp;
wire coin_rx1_cmp;
wire coin_rx2_cmp;
wire coin_rx_cnt0_en_nxt;
wire coin_rx_cnt0_en;
wire coin_rx_cnt1_en_nxt;
wire coin_rx_cnt1_en;
wire coin_rx_cnt2_en_nxt;
wire coin_rx_cnt2_en;
wire coin_rx_cnt_en;
wire rx_sync;
wire rx_sync_nxt;

//-----------------------------------------------------------------------------
//  Tx sync count
//-----------------------------------------------------------------------------

assign coin_tx0_cmp = (clsp_sync_tx0 == coin_tx_cnt) & coin_cnt_en;
assign coin_tx1_cmp = (clsp_sync_tx1 == coin_tx_cnt) & coin_cnt_en;
assign coin_tx2_cmp = (clsp_sync_tx2 == coin_tx_cnt) & coin_cnt_en;

assign tx_sync_nxt = coin_tx0_cmp | coin_tx1_cmp | coin_tx2_cmp;

dffrl_async_ns u_tx_sync(
                    .din(tx_sync_nxt), 
                    .rst_l(start_clk_early_jl),
                    .clk(cmp_clk),
                    .q(tx_sync));


assign coin_tx_cnt_minus_1 = coin_tx_cnt - 5'b00001;

assign coin_tx_cnt_nxt =  coin_cnt_ld  ?   clsp_sync_init :
                          (|coin_tx_cnt[4:0])?  coin_tx_cnt_minus_1:
                          clsp_sync_period;

dffrl_async_ns #(5) u_dffrle_coin_tx_cnt(
                    .din(coin_tx_cnt_nxt), 
                    .rst_l(start_clk_early_jl),
                    .clk(cmp_clk),
                    .q(coin_tx_cnt));

//-----------------------------------------------------------------------------
//  Rx sync count
//-----------------------------------------------------------------------------

assign coin_rx0_cmp = (clsp_sync_rx0 == coin_rx_cnt) & coin_rx_cnt0_en;
assign coin_rx1_cmp = (clsp_sync_rx1 == coin_rx_cnt) & coin_rx_cnt1_en;
assign coin_rx2_cmp = (clsp_sync_rx2 == coin_rx_cnt) & coin_rx_cnt2_en;

assign rx_sync_nxt = coin_rx0_cmp | coin_rx1_cmp | coin_rx2_cmp;

dffrl_async_ns u_rx_sync(
                    .din(rx_sync_nxt), 
                    .rst_l(start_clk_early_jl),
                    .clk(cmp_clk),
                    .q(rx_sync));

assign coin_rx_cnt_plus_1 = coin_rx_cnt + 2'b01;

assign coin_rx_cnt_nxt = (rx_sync | coin_cnt_ld) ? 2'b00 : 
                          coin_rx_cnt_en? coin_rx_cnt_plus_1:
                          coin_rx_cnt;

assign coin_rx_cnt0_en_nxt =   coin_tx0_cmp ? 1'b1: coin_rx0_cmp | coin_cnt_ld ? 1'b0: coin_rx_cnt0_en;
assign coin_rx_cnt1_en_nxt =   coin_tx1_cmp ? 1'b1: coin_rx1_cmp | coin_cnt_ld? 1'b0: coin_rx_cnt1_en;
assign coin_rx_cnt2_en_nxt =   coin_tx2_cmp ? 1'b1: coin_rx2_cmp | coin_cnt_ld? 1'b0: coin_rx_cnt2_en;

assign coin_rx_cnt_en = coin_rx_cnt0_en | coin_rx_cnt1_en | coin_rx_cnt2_en | coin_cnt_ld;

dffrl_async_ns u_dff_coin_rx_cnt0_en(
                  .din(coin_rx_cnt0_en_nxt), 
                  .clk(cmp_clk),
                  .rst_l (start_clk_early_jl),
                  .q(coin_rx_cnt0_en));
dffrl_async_ns u_dff_coin_rx_cnt1_en(
                  .din(coin_rx_cnt1_en_nxt), 
                  .clk(cmp_clk),
                  .rst_l (start_clk_early_jl),
                  .q(coin_rx_cnt1_en));
dffrl_async_ns u_dff_coin_rx_cnt2_en(
                  .din(coin_rx_cnt2_en_nxt), 
                  .clk(cmp_clk),
                  .rst_l (start_clk_early_jl),
                  .q(coin_rx_cnt2_en));

dffrl_async_ns #(2) u_dffe_coin_rx_cnt(
                    .din(coin_rx_cnt_nxt), 
                    .clk(cmp_clk),
                    .rst_l (start_clk_early_jl),
                    .q(coin_rx_cnt));


endmodule
// Local Variables:
// verilog-library-directories:("." "../../common/rtl")
// verilog-library-files:      ("../../common/rtl/swrvr_clib.v")
// verilog-auto-sense-defines-constant:t
// End:
