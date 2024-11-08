// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_dbg_portb.v
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
//  Module Name:	iobdg_dbg_portb (IO Bridge debug/visibility)
//  Description:	
*/
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////
`include	"sys.h" // system level definition file which contains the 
			// time scale definition
`include        "iop.h"


////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Interface signal list declarations
////////////////////////////////////////////////////////////////////////
module iobdg_dbg_portb (/*AUTOARG*/
   // Outputs
   dbg_data, dbg_vld, 
   // Inputs
   rst_l, clk, src0_data, src2_data, src3_data, src4_data, src0_vld, 
   src2_vld, src3_vld, src4_vld, i_am_hi, creg_dbg_jbus_ctrl, 
   creg_dbg_jbus_mask0, creg_dbg_jbus_cmp0, creg_dbg_jbus_cnt0, 
   creg_dbg_jbus_mask1, creg_dbg_jbus_cmp1, creg_dbg_jbus_cnt1
   );

////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input                                    rst_l;
   input 				    clk;
   

   // Debug input buses
   input [48:0] 			    src0_data;
   input [48:0] 			    src2_data;
   input [48:0] 			    src3_data;
   input [48:0] 			    src4_data;
   
   input                                    src0_vld;
   input                                    src2_vld;
   input                                    src3_vld;
   input                                    src4_vld;

   
   // Debug output bus
   output [47:0] 			    dbg_data;
   output 				    dbg_vld;
	
			    
   // Control interface
   input 				    i_am_hi;
   input [63:0] 			    creg_dbg_jbus_ctrl;
   
   input [63:0] 			    creg_dbg_jbus_mask0;
   input [63:0] 			    creg_dbg_jbus_cmp0;
   input [63:0] 			    creg_dbg_jbus_cnt0;
   
   input [63:0] 			    creg_dbg_jbus_mask1;
   input [63:0] 			    creg_dbg_jbus_cmp1;
   input [63:0] 			    creg_dbg_jbus_cnt1;

   
   // Internal signals
   wire 				    dbg_en;
   wire [2:0] 				    dbg_sel_hi;
   wire [2:0] 				    dbg_sel_lo;
   wire [2:0] 				    dbg_sel;

   wire 				    dbg_mask0_en;
   wire 				    dbg_mask0_inv;
   wire [43:0] 				    dbg_mask0;
   wire [43:0] 				    dbg_cmp0;
   wire 				    dbg_cnt0_vo;
   wire [7:0] 				    dbg_cnt0;
   
   wire 				    dbg_mask1_en;
   wire 				    dbg_mask1_inv;
   wire [43:0] 				    dbg_mask1;
   wire [43:0] 				    dbg_cmp1;
   wire 				    dbg_cnt1_vo;
   wire [7:0] 				    dbg_cnt1;

   reg [48:0] 				    mux_data;
   reg 					    mux_vld;
      
   wire 				    cmp0_hit;
   wire [7:0] 				    dbg_counter0_next;
   wire [7:0] 				    dbg_counter0;
   wire 				    dbg_counter0_on;
   
   wire 				    cmp1_hit;
   wire [7:0] 				    dbg_counter1_next;
   wire [7:0] 				    dbg_counter1;
   wire 				    dbg_counter1_on;

   wire [47:0] 				    dbg_data_a1;
   wire 				    dbg_vld_a1;
	
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   assign 	dbg_en        = creg_dbg_jbus_ctrl[16];
   assign 	dbg_sel_hi    = creg_dbg_jbus_ctrl[6:4];
   assign 	dbg_sel_lo    = creg_dbg_jbus_ctrl[2:0];

   assign 	dbg_sel       = i_am_hi ? dbg_sel_hi : dbg_sel_lo;
   
   assign 	dbg_mask0_en  = creg_dbg_jbus_mask0[45];
   assign 	dbg_mask0_inv = creg_dbg_jbus_mask0[44];
   assign 	dbg_mask0     = creg_dbg_jbus_mask0[43:0];
   assign 	dbg_cmp0      = creg_dbg_jbus_cmp0[43:0];

   assign 	dbg_cnt0_vo   = creg_dbg_jbus_cnt0[8];
   assign 	dbg_cnt0      = creg_dbg_jbus_cnt0[7:0];

   assign 	dbg_mask1_en  = creg_dbg_jbus_mask1[45];
   assign 	dbg_mask1_inv = creg_dbg_jbus_mask1[44];
   assign 	dbg_mask1     = creg_dbg_jbus_mask1[43:0];
   assign 	dbg_cmp1      = creg_dbg_jbus_cmp1[43:0];

   assign 	dbg_cnt1_vo   = creg_dbg_jbus_cnt1[8];
   assign 	dbg_cnt1      = creg_dbg_jbus_cnt1[7:0];


   always @(/*AUTOSENSE*/dbg_sel or src0_data or src0_vld or src2_data
	    or src2_vld or src3_data or src3_vld or src4_data
	    or src4_vld)
     case (dbg_sel)
       3'b000:  {mux_vld,mux_data} = {src0_vld,src0_data};
       3'b001:  {mux_vld,mux_data} = {1'b0,49'b0};
       3'b010:  {mux_vld,mux_data} = {src2_vld,src2_data};
       3'b011:  {mux_vld,mux_data} = {src3_vld,src3_data};
       3'b100:  {mux_vld,mux_data} = {src4_vld,src4_data};
       default:  {mux_vld,mux_data} = {1'b0,49'b0};
     endcase // case(dbg_sel)

   // Data
   assign 	dbg_data_a1 = dbg_en ? mux_data[47:0] : 48'b0;

   dff_ns #(48) dbg_data_ff (.din(dbg_data_a1),
			     .clk(clk),
			     .q(dbg_data));
   
   // Mask and compare 0 - mux_vld is NOT factored into hit because
   //                      the user is supposed to use the valid bit
   //                      in the compare/mask field to pick out valid
   //                      transactions
   assign 	cmp0_hit = dbg_mask0_en &
		           (((dbg_mask0 & {mux_data[43:41],mux_data[48],mux_data[39:0]}) == dbg_cmp0) ^ dbg_mask0_inv);
   
   assign 	dbg_counter0_next = cmp0_hit ? dbg_cnt0 : (dbg_counter0 - 8'h01);

   dffrle_ns #(8) dbg_counter0_ff (.din(dbg_counter0_next),
				   .rst_l(rst_l),
				   .en(dbg_counter0_on),
				   .clk(clk),
				   .q(dbg_counter0));

   assign 	dbg_counter0_on = |dbg_counter0;

   // Mask and compare 1 - mux_vld is NOT factored into hit because
   //                      the user is supposed to use the valid bit
   //                      in the compare/mask field to pick out valid
   //                      transactions
   assign 	cmp1_hit = dbg_mask1_en &
		           (((dbg_mask1 & {mux_data[43:41],mux_data[48],mux_data[39:0]}) == dbg_cmp1) ^ dbg_mask1_inv);
   
   assign 	dbg_counter1_next = cmp1_hit ? dbg_cnt1 : (dbg_counter1 - 8'h01);

   dffrle_ns #(8) dbg_counter1_ff (.din(dbg_counter1_next),
				   .rst_l(rst_l),
				   .en(dbg_counter1_on),
				   .clk(clk),
				   .q(dbg_counter1));

   assign 	dbg_counter1_on = |dbg_counter1;

   // Valid
   assign 	dbg_vld_a1 = dbg_en &
		             (cmp0_hit | cmp1_hit |
			      (dbg_counter0_on & ((dbg_cnt0_vo & mux_vld)|~dbg_cnt0_vo)) |
			      (dbg_counter1_on & ((dbg_cnt1_vo & mux_vld)|~dbg_cnt1_vo)));
			   
   dff_ns #(1) dbg_vld_ff (.din(dbg_vld_a1),
			   .clk(clk),
			   .q(dbg_vld));
   
endmodule // iobdg_dbg_portb


// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:



