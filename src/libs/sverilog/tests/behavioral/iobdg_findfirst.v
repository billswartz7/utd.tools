// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_findfirst.v
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
//  Module Name:	iobdg_lib_findfirst
//  Description:	Find the first bit that is set to 1 in a vector.
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
module iobdg_findfirst (/*AUTOARG*/
   // Outputs
   vec_out, 
   // Inputs
   vec_in
   );

// synopsys template

   parameter VEC_WIDTH = 64;
   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   input [VEC_WIDTH-1:0]     vec_in;
   output [VEC_WIDTH-1:0]    vec_out;
   reg [VEC_WIDTH-1:0]       vec_out;
   
   reg [VEC_WIDTH-1:0]       selected;
   
   integer 		      i;

   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   always @(vec_in or selected)
     begin
     	selected[0] = vec_in[0];
	vec_out[0] = vec_in[0];
	for (i=1; i<VEC_WIDTH; i=i+1)
	  begin
	     selected[i] = vec_in[i] | selected[i-1];
	     vec_out[i] = vec_in[i] & ~selected[i-1];
	  end
     end

endmodule // iobdg_findfirst



// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
