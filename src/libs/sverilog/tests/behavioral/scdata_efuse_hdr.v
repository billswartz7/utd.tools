// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: scdata_efuse_hdr.v
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
module scdata_efuse_hdr (/*AUTOARG*/
   // Outputs
   so, scdata_efc_fuse_data, fuse_red_data, fuse_red_subbank0_dshift, 
   fuse_red_subbank1_dshift, fuse_red_subbank2_dshift, 
   fuse_red_subbank3_dshift, fuse_red_rid, fuse_red_read_shift, 
   // Inputs
   rclk, se, si, efc_scdata_fuse_clk1, efc_scdata_fuse_clk2, 
   efc_scdata_fuse_ashift, efc_scdata_fuse_dshift, 
   efc_scdata_fuse_data, red_fuse_data, arst_l, testmode_l
   );


   input           rclk, se, si;
   output          so;
   // Efuse inputs from scdata
   input           efc_scdata_fuse_clk1;
   input           efc_scdata_fuse_clk2;
   input           efc_scdata_fuse_ashift;
   input           efc_scdata_fuse_dshift;
   input           efc_scdata_fuse_data;   
   // Efuse inputs from 32KB memory block
   input           red_fuse_data; // hook up to efuse_data_out
   input           arst_l;                      // reset, active low
   input           testmode_l;          // Gate off Write enables

   // Efuse outputs to 32KB memory block
   output          scdata_efc_fuse_data; // output of scdata
   output          fuse_red_data; // hook up to efuse_data_in
   output [5:0]    fuse_red_subbank0_dshift; // hook up to efuse_wren
   output [5:0]    fuse_red_subbank1_dshift; // hook up to efuse_wren
   output [5:0]    fuse_red_subbank2_dshift; // hook up to efuse_wren
   output [5:0]    fuse_red_subbank3_dshift; // hook up to efuse_wren
   output [2:0]    fuse_red_rid; // hook up to efuse_rid
   output          fuse_red_read_shift;     // hook up to FF enable for read shift

   ////////////////////////////////////////////////////////////////////////
   // Efuse Control
   ////////////////////////////////////////////////////////////////////////

   //------------------------------------------------------------------------
   //  Test logic
   //------------------------------------------------------------------------
   wire            int_clk1;
   wire            int_clk2;
   wire            int_scanin;  // !! hook up to 1st flop in scan chain !!

   assign          int_clk1 = testmode_l ? efc_scdata_fuse_clk1 : rclk;
   assign          int_clk2 = testmode_l ? efc_scdata_fuse_clk2 : rclk;

   bw_u1_scanlg_2x si_lockup(.so(int_scanin), .sd(si), .ck(rclk), .se(se));

   //------------------------------------------------------------------------
   //  Shift registers
   //------------------------------------------------------------------------
   wire [8:0]      addr_shft_nxt;
   wire [8:0]      addr_shft_ff;
   wire            addr_shft_en;
   wire            wren_bit;
   wire            fuse_datain_ph1;
   wire            fuse_dataout_ph2;

   dff_s #(9) addr_shft_reg (.din(addr_shft_nxt),
                           .q(addr_shft_ff), .clk(ashft_clk1),
                           .se(se), .si(), .so());
   clken_buf  ashft_clk1_buf  (.clk(ashft_clk1), .rclk(int_clk1), .enb_l(~addr_shft_en), .tmb_l(testmode_l));
   
   dff_s  #(3) rid_reg       (.din(addr_shft_ff[3:1]), .q(fuse_red_rid[2:0]), 
                            .clk(int_clk2), .se(se), .si(), .so());

   assign          wren_bit = addr_shft_ff[0];
   dff_s #(1) datain_dly1_reg (.din(efc_scdata_fuse_data), .q(fuse_datain_ph1), 
                            .clk(int_clk1), .se(se), .si(), .so());
   dff_s #(1) datain_dly2_reg (.din(fuse_datain_ph1), .q(fuse_red_data), 
                            .clk(int_clk2), .se(se), .si(), .so());
   
   dff_s #(1) dataout_dly1_reg (.din(red_fuse_data), .q(fuse_dataout_ph2), 
                             .clk(int_clk1), .se(se), .si(), .so());
   dff_s #(1) dataout_dly2_reg (.din(fuse_dataout_ph2), .q(scdata_efc_fuse_data), 
                             .clk(int_clk1), .se(se), .si(), .so());
   
   //------------------------------------------------------------------------
   //  Shift control
   //------------------------------------------------------------------------
   wire            dshift_dly1_ff;
   wire            dshift_dly3_ff;
   wire            wren_ph1;
   wire            rden_ph1;
   wire [5:0]      wren0;
   wire [5:0]      wren1;
   wire [5:0]      wren2;
   wire [5:0]      wren3;   
   wire [5:0]      subbank0_dshift_ff;
   wire [5:0]      subbank1_dshift_ff;
   wire [5:0]      subbank2_dshift_ff;
   wire [5:0]      subbank3_dshift_ff;
   wire 	   read_shift_ff;
   assign          addr_shft_en = efc_scdata_fuse_ashift;
   assign          addr_shft_nxt = {addr_shft_ff[7:0], efc_scdata_fuse_data};
   
   dffrl_async #(1) dshift_dly1_reg (.din(efc_scdata_fuse_dshift), .q(dshift_dly1_ff), 
                             .rst_l(arst_l), .clk(int_clk1), .se(se), .si(), .so());
   dffrl_async #(1) dshift_dly3_reg (.din(dshift_dly1_ff), .q(dshift_dly3_ff), 
                             .rst_l(arst_l), .clk(int_clk1), .se(se), .si(), .so());
   assign wren_ph1 = (dshift_dly1_ff || dshift_dly3_ff)
                              && wren_bit;
   assign rden_ph1 = dshift_dly1_ff && !wren_bit;

   dffrl_async #(6) wren0_reg (.din(wren0[5:0]), .q(subbank0_dshift_ff[5:0]), 
                       .rst_l(arst_l), .clk(int_clk2), .se(se), .si(), .so());
   dffrl_async #(6) wren1_reg (.din(wren1[5:0]), .q(subbank1_dshift_ff[5:0]), 
                       .rst_l(arst_l), .clk(int_clk2), .se(se), .si(), .so());
   dffrl_async #(6) wren2_reg (.din(wren2[5:0]), .q(subbank2_dshift_ff[5:0]), 
                       .rst_l(arst_l), .clk(int_clk2), .se(se), .si(), .so());
   dffrl_async #(6) wren3_reg (.din(wren3[5:0]), .q(subbank3_dshift_ff[5:0]), 
                       .rst_l(arst_l), .clk(int_clk2), .se(se), .si(), .so());

   dffrl_async #(1) rden_reg (.din(rden_ph1), .q(read_shift_ff),
                       .rst_l(arst_l), .clk(int_clk2), .se(se), .si(), .so());
   
   assign fuse_red_subbank0_dshift[5:0] = subbank0_dshift_ff[5:0] & {6{testmode_l}};
   assign fuse_red_subbank1_dshift[5:0] = subbank1_dshift_ff[5:0] & {6{testmode_l}};
   assign fuse_red_subbank2_dshift[5:0] = subbank2_dshift_ff[5:0] & {6{testmode_l}};
   assign fuse_red_subbank3_dshift[5:0] = subbank3_dshift_ff[5:0] & {6{testmode_l}};

   assign fuse_red_read_shift = read_shift_ff & testmode_l;

   //------------------------------------------------------------------------
   //  Subbank decode
   //------------------------------------------------------------------------

   wire [3:0] subbank;
   
   assign     subbank[0] = ~addr_shft_ff[8] && ~addr_shft_ff[7];
   assign     subbank[1] = ~addr_shft_ff[8] && addr_shft_ff[7];
   assign     subbank[2] = addr_shft_ff[8] && ~addr_shft_ff[7];
   assign     subbank[3] = addr_shft_ff[8] && addr_shft_ff[7];

   //------------------------------------------------------------------------
   //  RID decode
   //------------------------------------------------------------------------
   
   wire [5:0] rid;
   
   assign     rid[0] = ~addr_shft_ff[6] && ~addr_shft_ff[5] && ~addr_shft_ff[4];
   assign     rid[1] = ~addr_shft_ff[6] && ~addr_shft_ff[5] && addr_shft_ff[4];
   assign     rid[2] = ~addr_shft_ff[6] && addr_shft_ff[5] && ~addr_shft_ff[4];
   assign     rid[3] = ~addr_shft_ff[6] && addr_shft_ff[5] && addr_shft_ff[4];
   assign     rid[4] = addr_shft_ff[6] && ~addr_shft_ff[5] && ~addr_shft_ff[4];
   assign     rid[5] = addr_shft_ff[6] && ~addr_shft_ff[5] && addr_shft_ff[4];

   //------------------------------------------------------------------------
   //  Uniquify wren & rden
   //------------------------------------------------------------------------

   assign     wren0[0] = wren_ph1 && subbank[0] && rid[0];
   assign     wren0[1] = wren_ph1 && subbank[0] && rid[1];
   assign     wren0[2] = wren_ph1 && subbank[0] && rid[2];
   assign     wren0[3] = wren_ph1 && subbank[0] && rid[3];
   assign     wren0[4] = wren_ph1 && subbank[0] && rid[4];
   assign     wren0[5] = wren_ph1 && subbank[0] && rid[5];

   assign     wren1[0] = wren_ph1 && subbank[1] && rid[0];
   assign     wren1[1] = wren_ph1 && subbank[1] && rid[1];
   assign     wren1[2] = wren_ph1 && subbank[1] && rid[2];
   assign     wren1[3] = wren_ph1 && subbank[1] && rid[3];
   assign     wren1[4] = wren_ph1 && subbank[1] && rid[4];
   assign     wren1[5] = wren_ph1 && subbank[1] && rid[5];

   assign     wren2[0] = wren_ph1 && subbank[2] && rid[0];
   assign     wren2[1] = wren_ph1 && subbank[2] && rid[1];
   assign     wren2[2] = wren_ph1 && subbank[2] && rid[2];
   assign     wren2[3] = wren_ph1 && subbank[2] && rid[3];
   assign     wren2[4] = wren_ph1 && subbank[2] && rid[4];
   assign     wren2[5] = wren_ph1 && subbank[2] && rid[5];

   assign     wren3[0] = wren_ph1 && subbank[3] && rid[0];
   assign     wren3[1] = wren_ph1 && subbank[3] && rid[1];
   assign     wren3[2] = wren_ph1 && subbank[3] && rid[2];
   assign     wren3[3] = wren_ph1 && subbank[3] && rid[3];
   assign     wren3[4] = wren_ph1 && subbank[3] && rid[4];
   assign     wren3[5] = wren_ph1 && subbank[3] && rid[5];
   
endmodule // scdata_efuse_hdr
