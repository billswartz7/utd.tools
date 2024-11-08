// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_jbus_mondo_buf.v
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
//  Module Name:	iobdg_jbus_int_in
//  Description:	This block assembles interrupts that
//                      come from the JBUS.
*/
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////
`include	"sys.h" // system level definition file which contains the 
			// time scale definition

`include	"iop.h"

////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Interface signal list declarations
////////////////////////////////////////////////////////////////////////
module iobdg_jbus_mondo_buf (/*AUTOARG*/
   // Outputs
   mondo_vld, mondo_data0, mondo_data1, mondo_target, mondo_source, 
   // Inputs
   rst_l, clk, jbi_iob_vld, jbi_iob_data, rd_mondo_buf
   );
   
   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   // Global interface
   input                                 rst_l;
   input 				 clk;


   // JBI interface
   input 				 jbi_iob_vld;
   input [`JBI_IOB_MONDO_BUS_WIDTH-1:0]  jbi_iob_data;

   
   // Local interface
   output 				 mondo_vld;
   output [63:0] 			 mondo_data0;
   output [63:0] 			 mondo_data1;
   output [`JBI_IOB_MONDO_TRG_WIDTH-1:0] mondo_target;
   output [`JBI_IOB_MONDO_SRC_WIDTH-1:0] mondo_source;

   input 				 rd_mondo_buf;

   
   // Internal signals
   wire [`JBI_IOB_MONDO_BUS_CYCLE-1:0] 	 vldreg_next;
   wire [`JBI_IOB_MONDO_BUS_CYCLE-1:0] 	 vldreg;
   wire [`JBI_IOB_MONDO_BUS_WIDTH*`JBI_IOB_MONDO_BUS_CYCLE-1:0] datareg_next;
   wire [`JBI_IOB_MONDO_BUS_WIDTH*`JBI_IOB_MONDO_BUS_CYCLE-1:0] datareg;
   wire 				 shift_en;
   
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /************************************************************
    * Shift register
    ************************************************************/
   assign 	 vldreg_next = {vldreg[`JBI_IOB_MONDO_BUS_CYCLE-2:0],jbi_iob_vld};
   
   dffrle_ns #(`JBI_IOB_MONDO_BUS_CYCLE) vldreg_ff (.din(vldreg_next),
						    .rst_l(rst_l),
						    .en(shift_en),
						    .clk(clk),
						    .q(vldreg));
   
   assign 	 datareg_next = {datareg[`JBI_IOB_MONDO_BUS_WIDTH*(`JBI_IOB_MONDO_BUS_CYCLE-1)-1:0],
				 jbi_iob_data};
   
   dffrle_ns #(`JBI_IOB_MONDO_BUS_WIDTH*`JBI_IOB_MONDO_BUS_CYCLE) datareg_ff (.din(datareg_next),
									      .en(shift_en),
									      .clk(clk),
									      .rst_l(rst_l),
									      .q(datareg));

   assign 	 shift_en = ~&vldreg | rd_mondo_buf;
   
   
   /************************************************************
    * Local interface
    ************************************************************/
   assign 	 mondo_vld = &vldreg;
   assign 	 mondo_target = datareg[`JBI_IOB_MONDO_TRG_HI+128:`JBI_IOB_MONDO_TRG_LO+128];
   assign 	 mondo_source = datareg[`JBI_IOB_MONDO_SRC_HI+128:`JBI_IOB_MONDO_SRC_LO+128];
   assign 	 mondo_data0 = datareg[127:64];
   assign 	 mondo_data1 = datareg[63:0];

   
endmodule // iobdg_jbus_mondo_buf



