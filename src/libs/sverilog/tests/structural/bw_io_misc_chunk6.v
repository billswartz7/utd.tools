// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_misc_chunk6.v
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
module bw_io_misc_chunk6(io_pmi ,pcm_misc_oe ,vddo ,pmo ,io_pmo ,por_l ,
     pmi );
output		io_pmi ;
input		pcm_misc_oe ;
input		vddo ;
input		io_pmo ;
input		por_l ;
inout		pmo ;
inout		pmi ;
supply0		vss ;
 
wire		net26 ;
 
 
bw_io_cmos2_pad pmi_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_pmi ),
     .pad             (pmi ),
     .por_l           (por_l ) );
bw_io_cmos2_pad pmo_pad (
     .oe              (pcm_misc_oe ),
     .vddo            (vddo ),
     .data            (io_pmo ),
     .to_core         (net26 ),
     .pad             (pmo ),
     .por_l           (por_l ) );
endmodule
