// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_pt.v
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
module dram_pt(/*AUTOARG*/
   // Outputs
   pt_ch0_blk_new_openbank, pt_ch1_blk_new_openbank, 
   pt_max_banks_open, pt_max_time, dram_pt_max_banks_open_valid, 
   dram_pt_max_time_valid, dram_pt_ucb_data, 
   // Inputs
   clk, rst_l, dram_local_pt0_opened_bank, 
   dram_local_pt1_opened_bank, dram_other_pt0_opened_bank, 
   dram_other_pt1_opened_bank, que_max_banks_open_valid0, 
   que_max_banks_open_valid1, que_max_banks_open0, 
   que_max_banks_open1, que_max_time_valid0, que_max_time_valid1, 
   arst_l, 
   dram_other_pt_max_banks_open_valid, dram_other_pt_max_time_valid, 
   dram_other_pt_ucb_data
   );

////////////////////////////////////////////////////////////////
// OUTPUTS
////////////////////////////////////////////////////////////////
output		pt_ch0_blk_new_openbank;
output		pt_ch1_blk_new_openbank;

// IO READ
output [16:0]	pt_max_banks_open;
output [15:0]	pt_max_time;

// TO OTHER power control logic 
output 		dram_pt_max_banks_open_valid;
output 		dram_pt_max_time_valid;
output [16:0]	dram_pt_ucb_data;

////////////////////////////////////////////////////////////////
// INPUTS
////////////////////////////////////////////////////////////////
input		clk;
input		rst_l;
input		dram_local_pt0_opened_bank;
input		dram_local_pt1_opened_bank;
input		dram_other_pt0_opened_bank;
input		dram_other_pt1_opened_bank;

// IO WRITE
input          	que_max_banks_open_valid0;
input          	que_max_banks_open_valid1;
input [16:0]	que_max_banks_open0;
input [16:0]	que_max_banks_open1;

input          	que_max_time_valid0;
input          	que_max_time_valid1;

input		arst_l;

// FROM OTHER power control logic 
input 		dram_other_pt_max_banks_open_valid;
input 		dram_other_pt_max_time_valid;
input [16:0]	dram_other_pt_ucb_data;

////////////////////////////////////////////////////////////////
// WIRES
////////////////////////////////////////////////////////////////
wire [15:0]	pt_time_cntr_in;
wire [15:0]	pt_time_cntr;

////////////////////////////////////////////////////////////////
// CODE
////////////////////////////////////////////////////////////////

// DONOT NEED TO FLOP AS THEY ARE COMMING FROM A FLOP
// opened bank bits comming from other dram control

wire pt_other_pt0_opened_bank = dram_other_pt0_opened_bank;
wire pt_other_pt1_opened_bank = dram_other_pt1_opened_bank;

// Prepare data for other power controller - COMMING FROM FLOP

assign dram_pt_max_banks_open_valid = que_max_banks_open_valid0 | que_max_banks_open_valid1;
assign dram_pt_max_time_valid = que_max_time_valid0 | que_max_time_valid1;
assign dram_pt_ucb_data = que_max_banks_open_valid0 ? que_max_banks_open0[16:0] : 
				que_max_banks_open_valid1 ? que_max_banks_open1[16:0] :
		que_max_time_valid0 ? {1'b0, que_max_banks_open0[15:0]} : {1'b0, que_max_banks_open1[15:0]};

//////////////////////////////////////
// Max programmable banks open at in a given programmable time 
// Programmed by software.
//////////////////////////////////////

wire [16:0]     pt_max_banks_open_in;

assign pt_max_banks_open_in =  ~rst_l ? pt_max_banks_open[16:0] : 
				dram_other_pt_max_banks_open_valid ? dram_other_pt_ucb_data :
				que_max_banks_open_valid0 ? que_max_banks_open0[16:0] : 
				que_max_banks_open_valid1 ? que_max_banks_open1[16:0] :
				pt_max_banks_open[16:0];

dffsl_async_ns #(17)   ff_max_banks_open(
                .din(pt_max_banks_open_in[16:0]),
                .q(pt_max_banks_open[16:0]),
                .set_l(arst_l),
                .clk(clk));

//////////////////////////////////////
// Max programmable programmable time
// Max @200MHz is 327.68uS = 64*1024 ticks 
// Programmed by software.
//////////////////////////////////////

wire            pt_max_time_en;
wire [15:0]     pt_max_time_in;

assign pt_max_time_en = ~rst_l | que_max_time_valid0 | que_max_time_valid1 | dram_other_pt_max_time_valid;
assign pt_max_time_in =  ~rst_l ? pt_max_time[15:0] : 
				dram_other_pt_max_time_valid ? dram_other_pt_ucb_data[15:0] :
				que_max_time_valid0 ? que_max_banks_open0[15:0] : 
				que_max_time_valid1 ? que_max_banks_open1[15:0] :
				pt_max_time[15:0];

dffsl_async_ns #(16)   ff_max_time(
                .din(pt_max_time_in[15:0]),
                .q(pt_max_time[15:0]),
                .set_l(arst_l),
                .clk(clk));

//////////////////////////////////////
// counter to keep track of the number of 
// banks open at any given time
//////////////////////////////////////

wire            pt_banks_open_en;
wire [16:0]     pt_banks_open_in;
wire [16:0]     pt_banks_open;

assign pt_banks_open_en = dram_local_pt0_opened_bank | dram_local_pt1_opened_bank |
				pt_other_pt0_opened_bank | pt_other_pt1_opened_bank;
assign pt_banks_open_in = pt_banks_open[16:0] + {16'h0,dram_local_pt0_opened_bank} + 
				{16'h0, dram_local_pt1_opened_bank} +
				{16'h0, pt_other_pt0_opened_bank} + 
				{16'h0, pt_other_pt1_opened_bank}; 
wire pt_banks_open_rst_l = rst_l & ~(pt_max_time[15:0] == pt_time_cntr[15:0]);

dffrle_ns #(17) ff_banks_open(
                .din(pt_banks_open_in[16:0]),
                .q(pt_banks_open[16:0]),
		.rst_l(pt_banks_open_rst_l),
                .en(pt_banks_open_en),
                .clk(clk));

//////////////////////////////////////
// counter to keep track of the time (327.68uS) = 64*1024 ticks @200MHz
//////////////////////////////////////

assign pt_time_cntr_in[15:0] = pt_time_cntr[15:0] + 16'b1;
wire pt_time_cntr_rst_l = rst_l & ~(pt_time_cntr[15:0] >= pt_max_time[15:0]);

dffrl_ns #(16) ff_time_cntr(
                .din(pt_time_cntr_in[15:0]),
                .q(pt_time_cntr[15:0]),
		.rst_l(pt_time_cntr_rst_l),
                .clk(clk));

//////////////////////////////////////
// Block openbanks in the next cycle
//////////////////////////////////////

wire pt_blk_new_openbank = (pt_banks_open_in[16:0] >= pt_max_banks_open[16:0]);

dff_ns #(1)       ff_blk_openbank(
                .din(pt_blk_new_openbank),
                .q(pt_blk_new_openbank_d1),
                .clk(clk));

assign pt_ch0_blk_new_openbank = pt_blk_new_openbank_d1;
assign pt_ch1_blk_new_openbank = pt_blk_new_openbank_d1;

endmodule
