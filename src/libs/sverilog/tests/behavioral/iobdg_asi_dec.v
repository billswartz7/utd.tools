// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_asi_dec.v
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
//  Module Name:	iobdg_asi_dec
//  Description:	Decode TAP access to CPU ASI's.
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
module iobdg_asi_dec (/*AUTOARG*/
   // Outputs
   asi_ctrl, asi_addr, 
   // Inputs
   ucb_packet
   );

   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   input [`UCB_64PAY_PKT_WIDTH-1:0]    ucb_packet;
   output [31:0] 		       asi_ctrl;
   output [31:0] 		       asi_addr;
   
   reg [31:0] 			       asi_ctrl;
   
   wire [`UCB_ADDR_WIDTH-1:0] 	       ucb_packet_addr;
   
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   assign 	 ucb_packet_addr = ucb_packet[`UCB_ADDR_HI:`UCB_ADDR_LO];
   
   // Special decode for ASI access
   // Control bits (mapped to data[127:96] of cpx packet):
   // L1I data,L1D data,BIST,MARGIN,DEFEATURE,PC,TID
   // These 8b are mapped to bits 104:96 of the cpx pkt.
   // (TID is the lowest order 2 bits).
   // *Note that a write to pc is ignored by hardware.
   // *The cpx-reply will not contain the control information.
   // *TID(Thread id) applies only to pc and defeature.
   //
   // Address bits (mapped to data[95:64] of cpx packet):
   // This is used to access the L1 cache arrays.  This field
   // is a dont-care for the bist/margin/defeature/pc ASIs.
   // Only the lower 32 bits are specified here.  The core will
   // pad zeros create a 64-bit address.
   //
   // Data bits (mapped to data[63:0] of cpx packet):
   // PC(48b),Margin(36b),Bist-Ctl(14b),Defeature(4b).
   // The largest field of 48b is mapped to bits 47:0 of the cpx pkt.
   
   // LSU needs these control bits zeroed out if accessing
   // non-asi registers.
   always @(/*AUTOSENSE*/ucb_packet_addr) begin
      case (ucb_packet_addr[39:28])
	{`CPU_ASI,`IOB_ASI_L1ID}:begin
	   asi_ctrl = {30'b0100000,ucb_packet_addr[24:23]};
	end
	{`CPU_ASI,`IOB_ASI_L1DD}:begin
	   asi_ctrl = {30'b0010000,ucb_packet_addr[24:23]};
	end
	{`CPU_ASI,`IOB_ASI_BIST}:begin
	   asi_ctrl = {30'b0001000,ucb_packet_addr[24:23]};
	end
	{`CPU_ASI,`IOB_ASI_MARGIN}:begin
	   asi_ctrl = {30'b0000100,ucb_packet_addr[24:23]};
	end
	{`CPU_ASI,`IOB_ASI_DEFEATURE}:begin
	   asi_ctrl = {30'b0000010,ucb_packet_addr[24:23]};
	end
	{`CPU_ASI,`IOB_ASI_PC}:begin
	   asi_ctrl = {30'b0000001,ucb_packet_addr[24:23]};
	end
	default:begin
	   asi_ctrl = 32'b0;
	end
      endcase
   end // always @ (...
   
   assign        asi_addr = {9'b0,ucb_packet_addr[22:0]};


endmodule // iobdg_asi_dec



// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
