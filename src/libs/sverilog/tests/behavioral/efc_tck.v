// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: efc_tck.v
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
//    Cluster Name:  Efuse Cluster
//    Unit Name:  efc_tck (tck logic)
//
//-----------------------------------------------------------------------------
`include "sys.h"
`include "iop.h"

module efc_tck (/*AUTOARG*/
   // Outputs
   tck_shft_data_ff, efc_ctu_data_out, 
   // Inputs
   read_data_ff, ctu_efc_data_in, ctu_efc_shiftdr, ctu_efc_capturedr, 
   tck
   );
//-----------------------------------------------------------------------------
//  I/O declarations
//-----------------------------------------------------------------------------
// CTU/JTAG Shift Interface
output [31:0]   tck_shft_data_ff;        // shift register data
input  [31:0]   read_data_ff;		// read reg val
input           ctu_efc_data_in;        // Serial(scan) in from ctu
output          efc_ctu_data_out;       // Serial(scan) out to ctu
input           ctu_efc_shiftdr;        // shift data register
input           ctu_efc_capturedr;      // shift data reg captures read reg val
input           tck;                    // Shift dr data in/out from ctu

//-----------------------------------------------------------------------------
//  Wire/reg declarations
//-----------------------------------------------------------------------------
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
// End of automatics

wire [31:0]	tck_shft_data_nxt;
wire [31:0]	tck_shft_data_ff;
//-----------------------------------------------------------------------------
// Module Body
//-----------------------------------------------------------------------------
assign tck_shft_data_nxt 
	      = ctu_efc_capturedr ? read_data_ff
	       : ctu_efc_shiftdr ? {tck_shft_data_ff[30:0], ctu_efc_data_in}
	       : tck_shft_data_ff;

dff_ns #(32) tck_shft_data_reg (.din(tck_shft_data_nxt ),
		   .q(tck_shft_data_ff ), .clk(tck));

assign       efc_ctu_data_out = tck_shft_data_ff[31];

endmodule
// Local Variables:
// verilog-library-directories:("." "../../common/rtl")
// verilog-library-files:      ("../../common/rtl/swrvr_clib.v")
// verilog-auto-sense-defines-constant:t
// End:
