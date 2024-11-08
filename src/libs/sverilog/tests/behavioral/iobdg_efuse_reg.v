// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_efuse_reg.v
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
//  Module Name:	iobdg_efuse_reg
//  Description:	Shift register to hold fuse value from efuse unit.
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
module iobdg_efuse_reg (/*AUTOARG*/
   // Outputs
   fuse_reg, 
   // Inputs
   arst_l, fuse_clk, data_in, shift_en
   );
// synopsys template

   parameter REG_WIDTH = `IOB_FUSE_WIDTH;
   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   input                     arst_l;
   input                     fuse_clk;
   input 		     data_in;
   input 		     shift_en;
   output [REG_WIDTH-1:0]    fuse_reg;
   
   wire [REG_WIDTH-1:0]      fuse_reg_next;
   
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   // The MSB is shifted out first
   assign 	fuse_reg_next = shift_en ? {fuse_reg[REG_WIDTH-2:0],data_in} :
		                           fuse_reg;
   
   dffsl_async_ns #(REG_WIDTH) fuse_reg_ff (.din(fuse_reg_next),
					    .set_l(arst_l),
					    .clk(fuse_clk),
					    .q(fuse_reg));

   
endmodule // iobdg_efuse_reg


// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
