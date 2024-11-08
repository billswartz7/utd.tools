// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: i2c_cpx_cnt.v
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
//  Module Name:	i2c_cpx_cnt (io-to-cpu cpx buffer counter)
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
module i2c_cpx_cnt (/*AUTOARG*/
   // Outputs
   cpx_buf_full, 
   // Inputs
   rst_l, clk, iob_cpx_req_next, cpx_iob_grant
   );
   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input         rst_l;
   input 	 clk;

   
   // Fast control interface
   input 	 iob_cpx_req_next;
   input 	 cpx_iob_grant;
   output 	 cpx_buf_full;   

   
   // Internal signals
   wire 	 cpx_cnt_plus1_sel;
   wire 	 cpx_cnt_minus1_sel;
   wire [1:0] 	 cpx_cnt_plus1;
   wire [1:0] 	 cpx_cnt_minus1;
   wire [1:0] 	 cpx_cnt;
   reg [1:0] 	 cpx_cnt_next;

   wire 	 cpx_buf_full;

   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /************************************************************
    * Counters to keep track of each CPX's buffer level
    ************************************************************/
   // Assertion: request cannot be asserted if count is 2
   //            grant cannot be asserted if count is 0
   assign 	 cpx_cnt_plus1_sel = iob_cpx_req_next & ~cpx_iob_grant;
   assign 	 cpx_cnt_minus1_sel = cpx_iob_grant &  ~iob_cpx_req_next;
   
   assign 	 cpx_cnt_plus1 = cpx_cnt + 2'b01;
   assign 	 cpx_cnt_minus1 = cpx_cnt - 2'b01;

  
   always @(/*AUTOSENSE*/cpx_cnt or cpx_cnt_minus1
	    or cpx_cnt_minus1_sel or cpx_cnt_plus1
	    or cpx_cnt_plus1_sel)
     case ({cpx_cnt_minus1_sel,cpx_cnt_plus1_sel}) // synopsys infer_mux
       2'b00:cpx_cnt_next = cpx_cnt;
       2'b01:cpx_cnt_next = cpx_cnt_plus1;
       2'b10:cpx_cnt_next = cpx_cnt_minus1;
       2'b11:cpx_cnt_next = cpx_cnt;               // this case should never happen
     endcase // case(cpx_cnt_plus1_sel,cpx_cnt_minus1_sel)

   dffrl_ns #(2) cpx_cnt_ff (.din(cpx_cnt_next),
	       	             .clk(clk),
			     .rst_l(rst_l),
		             .q(cpx_cnt));

   assign 	 cpx_buf_full = cpx_cnt[1];

   
endmodule // i2c_cpx_cnt

