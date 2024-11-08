// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_cmos_edgelogic.v
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
//  CMOS edge logic 
*/
////////////////////////////////////////////////////////////////////////

`include "sys.h" 

module bw_io_cmos_edgelogic(
   // Outputs
   to_core, por, pad_up, bsr_up, pad_dn_l, bsr_dn_l,

   // Inputs
   data, oe, bsr_mode, por_l,
   bsr_data_to_core, se, rcvr_data
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
input		data;
input		oe;
input		bsr_mode;
input		por_l;
input		se;
input		bsr_data_to_core;
input		rcvr_data;
supply0		vss;
//////////////////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////////////////
output		pad_up;
output		pad_dn_l;
output		bsr_up;
output		bsr_dn_l;
output		por;
output		to_core;


// WIRES
wire pad_up;
wire pad_dn_l;
wire bsr_up;
wire bsr_dn_l;
wire por;
wire to_core;
		
//always 
//begin
//  bsr_up   = pad_up;
//  bsr_dn_l = pad_dn_l;
//  por      = ~por_l;
//  pad_up   =  data && oe;
//  pad_dn_l = ~(~data && oe);
//  to_core  = (bsr_mode && !se) ? bsr_data_to_core : rcvr_data;
//end

assign bsr_up   = pad_up;
assign bsr_dn_l = pad_dn_l;
assign por      = ~por_l;
assign pad_up   =  data && oe;
assign pad_dn_l = ~(~data && oe);
assign to_core  = (bsr_mode && !se) ? bsr_data_to_core : rcvr_data;

endmodule
