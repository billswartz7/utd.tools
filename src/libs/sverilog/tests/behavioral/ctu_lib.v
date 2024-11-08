// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_lib.v
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
//
//-----------------------------------------------------------------------------


`include	"sys.h" 
//---------------------------
//
//  Lauching clock:    raw_clk_out
//  Receiving clock :  jbus_clk
//  Method: Latch for hold time
//
//---------------------------
module ctu_synch_ref_jl(/*AUTOARG*/
// Outputs
syncdata, 
// Inputs
pll_raw_clk_out, presyncdata
);
// synopsys template
parameter SIZE = 1;

input  pll_raw_clk_out;
input  [SIZE-1:0]  presyncdata; 
output [SIZE-1:0]  syncdata;

wire [SIZE-1:0]  presyncdata_in; 

bw_u1_scanl_2x u_ctu_synch_ref_jl_0 [SIZE-1:0]
   (.sd (presyncdata[SIZE-1:0]),
    .ck (pll_raw_clk_out),
    .so (syncdata[SIZE-1:0])
    );


endmodule   

//---------------------------
//
//  Lauching clock:    jbus_clk 
//  Receiving clock :  raw_clk_out
//  Method: Latch for hold time
//
//---------------------------
module ctu_synch_jl_ref(/*AUTOARG*/
// Outputs
syncdata, 
// Inputs
jbus_clk, presyncdata
);
// synopsys template
parameter SIZE = 1;

input  jbus_clk;
input  [SIZE-1:0]  presyncdata; 
output [SIZE-1:0]  syncdata;

wire [SIZE-1:0]  presyncdata_in; 

bw_u1_scanl_2x u_ctu_synch_jl_ref_0 [SIZE-1:0]
   (.sd (presyncdata[SIZE-1:0]),
    .ck (jbus_clk),
    .so (syncdata[SIZE-1:0])
    );


endmodule   

//---------------------------
//
//  Lauching clock:    cmp_clk
//  Receiving clock :  cmp_gclk
//
//---------------------------

// Before re-time with gclk,
// the data needs to be register with local clock
// to garuantee setup 
// Since the timing is very tight (200 ps setup skew)
// We move the testmode mux to cmp_clk domain
// before sending it to cmp_gclk
// All clock enable signals

module ctu_synch_cl_cg (/*AUTOARG*/
// Outputs
syncdata, 
// Inputs
cmp_clk, start_clk_cl, arst_l, force_cken, presyncdata
);
// synopsys template
parameter SIZE = 1;

input  cmp_clk;
input  start_clk_cl;
input  arst_l;
input  force_cken;
input  [SIZE-1:0]  presyncdata; 
output [SIZE-1:0]  syncdata;

wire   [SIZE-1:0]  presyncdata_muxed; 


   assign presyncdata_muxed =  force_cken? { SIZE {1'b1}} :  {SIZE {start_clk_cl}}  & presyncdata;

   dffrl_async_ns  #(SIZE)  u_synch_jl_cl_ff1_nsr(
                   .din (presyncdata_muxed[SIZE-1:0]),
                   .clk (cmp_clk),
                   .rst_l(arst_l),
                   .q (syncdata[SIZE-1:0]));
endmodule   
//---------------------------
//
//  Lauching clock:    cmp_clk
//  Receiving clock :  dram_gclk 
//  Method: sync pulse (one clock earlier than dram_tx_sync)
//          data available on rising edge of dram_clk 
//          then clocked by dram_gclk on next edge
//
//---------------------------

module ctu_synch_cl_dl(/*AUTOARG*/
// Outputs
syncdata, 
// Inputs
cmp_clk, ctu_dram_tx_sync_early, presyncdata
);

// synopsys template
parameter SIZE = 1;
input  cmp_clk;
input  ctu_dram_tx_sync_early;
input  [SIZE-1:0]  presyncdata; 
output [SIZE-1:0]  syncdata;

   
   dffe_ns  #(SIZE)  u_synch_cl_dl_ff0(
                   .din (presyncdata[SIZE-1:0]),
                   .clk (cmp_clk),
                   .en(ctu_dram_tx_sync_early),
                   .q (syncdata[SIZE-1:0]));

endmodule   

//---------------------------
//
//  Lauching clock:    jbus_clk
//  Receiving clock :  pseudo dram_clk (make use of coincident edge)
//  Method: jbus_clk -> cmp_clk  through coin edges
//
//---------------------------

module ctu_synch_jl_dl (/*AUTOARG*/
// Outputs
syncdata, 
// Inputs
cmp_clk, jbus_rx_sync, coin_edge, arst_l, presyncdata
);

// synopsys template
parameter SIZE = 1;
input  cmp_clk;
input  jbus_rx_sync;
input  coin_edge;
input  arst_l;
input  [SIZE-1:0]  presyncdata; 
output [SIZE-1:0]  syncdata;

wire   [SIZE-1:0]  presyncdata_in; 
wire   [SIZE-1:0]  presyncdata_in_nxt;
wire   [SIZE-1:0]  syncdata_nxt;

assign presyncdata_in_nxt = jbus_rx_sync ? presyncdata: presyncdata_in; 
   
   dffrl_async_ns  #(SIZE)  u_synch_cl_dl_ff0(
                   .din (presyncdata_in_nxt[SIZE-1:0]),
                   .clk (cmp_clk),
                   .rst_l(arst_l),
                   .q (presyncdata_in[SIZE-1:0]));

assign syncdata_nxt = coin_edge ? presyncdata_in : syncdata;

   dffrl_async_ns  #(SIZE)  u_synch_cl_dl_ff2(
                   .din (syncdata_nxt[SIZE-1:0]),
                   .clk (cmp_clk),
                   .rst_l(arst_l),
                   .q (syncdata[SIZE-1:0]));

endmodule   


//---------------------------
//
//  Asynchronous interface
//
//---------------------------

module ctu_synchronizer (/*AUTOARG*/
// Outputs
syncdata, 
// Inputs
clk, presyncdata
);

// synopsys template
parameter SIZE = 1;

input clk;
input [SIZE-1:0] presyncdata;
output [SIZE-1:0] syncdata;

wire [SIZE-1:0] presyncdata_tmp;

    bw_u1_syncff_4x u_synchronizer_syncff [SIZE-1:0](.q(presyncdata_tmp),
                     .so(),
                     .ck(clk),
                     .d(presyncdata),
                     .sd(),
                     .se(1'b0)
                     );

    bw_u1_soff_2x u_synchronizer_ff[SIZE-1:0] (.q(syncdata),
                     .so(),
                     .ck(clk),
                     .d(presyncdata_tmp),
                     .sd(),
                     .se(1'b0)
                     );
endmodule


//---------------------------
//
//  Asynchronous interface (clock select blocks)
//
//---------------------------

module ctu_clksel_async_synchronizer (/*AUTOARG*/
// Outputs
syncdata, 
// Inputs
clk, presyncdata, arst_l, aset_l
);

// synopsys template
parameter SIZE = 1;

input clk;
input [SIZE-1:0] presyncdata;
input arst_l;
input aset_l;
output [SIZE-1:0] syncdata;

wire [SIZE-1:0] presyncdata_in0;
wire [SIZE-1:0] presyncdata_in1;


    bw_u1_soffasr_2x u_synchronizer_ff0_nsr[SIZE-1:0] (.q( presyncdata_in0),
                     .so(),
                     .ck(clk),
                     .d(presyncdata),
                     .sd(),
                     .se(1'b0),
                     .r_l (arst_l),
                     .s_l (aset_l)
                     );
    bw_u1_soffasr_2x u_synchronizer_ff1_nsr[SIZE-1:0] (.q( presyncdata_in1),
                     .so(),
                     .ck(clk),
                     .d(presyncdata_in0),
                     .sd(),
                     .se(1'b0),
                     .r_l (arst_l),
                     .s_l (aset_l)
                     );

    bw_u1_soffasr_2x u_synchronizer_neg_ff_nsr[SIZE-1:0] (.q( syncdata[SIZE-1:0]),
                     .so(),
                     .ck(~clk),
                     .d(presyncdata_in1[SIZE-1:0]),
                     .sd(),
                     .se(1'b0),
                     .r_l (arst_l),
                     .s_l (aset_l)
                     );

endmodule

module ctu_mux21 (d0, d1, s, z);
// synopsys template
parameter SIZE = 1;
input [SIZE-1:0] d0 ;    // data in 
input [SIZE-1:0] d1 ;    // data in 
input s;      // select

output [SIZE-1:0]      z ;

wire [SIZE-1:0] z_pre ;      

// assign z = s ? d1 : d0;

     bw_u1_muxi21_4x u_muxi21 [SIZE-1:0] (
    .z(z_pre), .d0(d0), .d1(d1), .s(s) );

     bw_u1_inv_5x u_inv [SIZE-1:0] (
     .z(z), .a(z_pre));

endmodule

//---------------------------
//
//  clock select components used in jtag
//
//---------------------------

module ctu_jtag_clk_sel_0_0_ff (/*AUTOARG*/
// Outputs
sel_clk, 
// Inputs
test_mode_pin, trst, pll_bypass_pin, sel_ff
);

input test_mode_pin;
input trst;
input pll_bypass_pin;
input sel_ff;
output sel_clk;

wire   tmp0, tmp1;

bw_u1_oai21_4x u_oai21 (.z(tmp0), .a(test_mode_pin), .b1(trst), .b2(pll_bypass_pin));
bw_u1_nand2_4x u_nand2 (.z(tmp1), .a(tmp0), .b(sel_ff));
bw_u1_inv_8x   u_inv   (.z(sel_clk), .a(tmp1) );

endmodule


module ctu_jtag_clk_sel_1_0_ff (/*AUTOARG*/
// Outputs
sel_clk, 
// Inputs
test_mode_pin, trst, pll_bypass_pin, sel_ff
); 
input test_mode_pin;
input trst;
input pll_bypass_pin;
input sel_ff;
output sel_clk;

wire   tmp0, tmp1;

bw_u1_nand2_4x u_nand2 (.z(tmp0), .a(test_mode_pin), .b(pll_bypass_pin));
bw_u1_aoi22_4x u_aoi22 (.z(tmp1), .a1(test_mode_pin), .a2(trst), .b1(tmp0), .b2(sel_ff));
bw_u1_inv_8x   u_inv   (.z(sel_clk), .a(tmp1));

endmodule


module ctu_jtag_clk_sel_0_1_ff (/*AUTOARG*/
// Outputs
sel_clk, 
// Inputs
test_mode_pin, trst, pll_bypass_pin, sel_ff
); 
input test_mode_pin;
input trst;
input pll_bypass_pin;
input sel_ff;
output sel_clk;

wire   tmp;

bw_u1_aoi21_4x u_aoi21_0 (.z(tmp), .a(sel_ff), .b1(test_mode_pin), .b2(pll_bypass_pin));
bw_u1_aoi21_4x u_aoi21_1 (.z(sel_clk), .a(tmp), .b1(test_mode_pin), .b2(trst));

endmodule


//---------------------------
//
//  gated clock components
//
//---------------------------

module ctu_and2 (z, a, b);

output z;
input  a;
input  b;

bw_u1_nand2_4x u_nand2 ( .z(tmp), .a(a),  .b(b) );
bw_u1_inv_8x   u_inv   ( .z(z),   .a(tmp) );

endmodule

module ctu_and3 (z, a, b,c);

output z;
input  a;
input  b;
input  c;

bw_u1_nand3_4x u_nand2 ( .z(tmp), .a(a),  .b(b), .c(c) );
bw_u1_inv_8x   u_inv   ( .z(z),   .a(tmp) );

endmodule
     
module ctu_inv  (z, a);

output z;
input  a;

bw_u1_inv_8x   u_inv   ( .z(z),   .a(a) );

endmodule


module ctu_or2 (z, a, b);

output z;
input  a;
input  b;

bw_u1_nor2_4x u_nor2 ( .z(tmp), .a(a),  .b(b) );
bw_u1_inv_8x   u_inv   ( .z(z),   .a(tmp) );

endmodule

module ctu_nor2 (z, a, b);

output z;
input  a;
input  b;

bw_u1_nor2_4x u_nor2 ( .z(z), .a(a),  .b(b) );

endmodule

