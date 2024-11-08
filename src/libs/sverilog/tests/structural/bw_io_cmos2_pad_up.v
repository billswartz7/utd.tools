// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_cmos2_pad_up.v
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
//  CMOS2 PAD
*/
////////////////////////////////////////////////////////////////////////

`include "sys.h" 
module bw_io_cmos2_pad_up(oe ,data ,to_core ,pad ,por_l, vddo );
output		to_core ;
input		oe ;
input		data ;
input		por_l ;
inout		pad ;
input  		vddo ;
supply1		vdd ;
supply0		vss ;
 
wire		rcvr_data ;
wire		por ;
wire		pad_up ;
wire		net58 ;
wire		net59 ;
wire		pad_dn_l ;
 
 
bw_io_cmos_edgelogic I2 (
     .rcvr_data       (rcvr_data ),
     .to_core         (to_core ),
     .se              (vss ),
     .bsr_up          (net58 ),
     .bsr_dn_l        (net59 ),
     .pad_dn_l        (pad_dn_l ),
     .pad_up          (pad_up ),
     .oe              (oe ),
     .data            (data ),
     .por_l           (por_l ),
     .por             (por ),
     .bsr_data_to_core (vss ),
     .bsr_mode        (vss ) );
bw_io_hstl_drv I3 (
     .cbu             ({vss ,vss ,vss ,vss ,vdd ,vdd ,vdd ,vdd } ),
     .cbd             ({vss ,vss ,vss ,vss ,vdd ,vdd ,vdd ,vdd } ),
     .por             (por ),
     .bsr_dn_l        (vss ),
     .bsr_up          (vss ),
     .pad_dn_l        (pad_dn_l ),
     .sel_data_n      (vss ),
     .pad_up          (pad_up ),
     .pad             (pad ),
     .vddo            (vddo) );
bw_io_schmitt I41 (
     .vddo            (vddo ),
     .out             (rcvr_data ),
     .in              (pad ) );
bw_io_cmos2_term_up I18 (
     .vddo            (vddo ),
     .out            (pad ) );
     
endmodule

