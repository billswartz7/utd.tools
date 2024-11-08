// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_hstl_drv.v
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
/////////////////////////////////////////////////////////////////////////
/*
//  HSTL Driver 
*/
////////////////////////////////////////////////////////////////////////

`include "sys.h" 

module bw_io_hstl_drv(

   // Outputs
   pad, 
   
   // Inputs
   sel_data_n, pad_up, pad_dn_l,  por,
   bsr_up, bsr_dn_l,  cbu, cbd, vddo );

output	pad;
input [8:1] cbu;
input [8:1] cbd;
input	sel_data_n;
input	pad_up;
input	pad_dn_l;
input	por;
input	bsr_up;
input	bsr_dn_l;
inout	vddo;

reg /*4value*/ out;
always @(/*AUTOSENSE*/bsr_dn_l or bsr_up or pad_dn_l or pad_up or por
	 or sel_data_n) begin

// 5/6/2005: Fixed for Bug 7184			 

   if (por == 1'b1) out = 1'bz;
   else if (por == 1'b0) begin
      if (sel_data_n == 1'b0) begin
	 case ({pad_up, pad_dn_l})
	   2'b00: out = 1'b0;
	   2'b01: out = 1'bz;
	   2'b11: out = 1'b1;
	   default: out = 1'bx;
	 endcase // case({pad_up, pad_dn_l})
      end
      else if (sel_data_n == 1'b1) begin
	 case ({bsr_up, bsr_dn_l})
	   2'b00: out = 1'b0;
	   2'b01: out = 1'bz;
	   2'b11: out = 1'b1;
	   default: out = 1'bx;
	 endcase // case({bsr_up, bsr_dn_l})
      end
      else out = 1'bx;
   end // if (por == 1'b0) 
   else out = 1'bx;

//  ORIGINAL CODE
//  casex ({por, sel_data_n, pad_up, pad_dn_l, bsr_up, bsr_dn_l})
//    6'b1xxxxx: out= 1'bz; // normal path (pad) reset
//    6'b0000xx: out= 1'b0; // normal path (pad) write 0
//    6'b0001xx: out= 1'bz; // normal path (pad) hi-Z
//    6'b0011xx: out= 1'b1; // normal path (pad) write 1
//    6'b01xx00: out= 1'b0; // boundary scan (bsr) write 0
//    6'b01xx01: out= 1'bz; // boundary scan (bsr) hi-Z
//    6'b01xx11: out= 1'b1; // boundary scan (bsr) write 1
//    default: out= 1'bx;   // all other cases illegal and not defined
//  endcase   

end // always @ (...
   
assign (pull1, strong0) #1 pad = out;
   
endmodule

// Local Variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// End:

