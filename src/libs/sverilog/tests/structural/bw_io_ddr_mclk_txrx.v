// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_mclk_txrx.v
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
module bw_io_ddr_mclk_txrx(/*AUTOARG*/
   // Outputs
   out, 
   // Inouts
   pad, 
   // Inputs
   vrefcode, vdd_h, cbu, cbd, data, oe, odt_enable
   );

// INPUTS
input [7:0]     vrefcode;       // impedence control bits 
input           odt_enable;    	// ODT control 
input           vdd_h;         	// IO power
input [8:1]     cbu;            // Impedence Control bits for Pullup driver
input [8:1]     cbd;            // Impedence Control bits for Pulldn driver
input           data;        	// Data input to Driver
input           oe;          	// Output tristate control (active high)
// INOUTS
inout           pad;            // Output/Input pad of Driver/Receiver

// OUTPUTS
output          out;            // Receiver output

//////////////////////////
// CODE
//////////////////////////

assign pad = oe ? data : 1'bz;
assign out = pad;

// FIX FOR MAKING INPUT DQS WEAK 0/1 WHEN BUS IS IN "Z" STATE.
//wire pad_in;
//pulldown p1(pad_in); // pulldown by default if no driver
//assign out = (pad === 1'bz) ? pad_in : pad;

endmodule
