// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_gclk_center_3inv.v
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
// ------------------------------------------------------------------
module bw_clk_gclk_center_3inv(jbus_out ,ddr_out ,cmp_out ,jbus_in ,
     ddr_in ,cmp_in );
output		jbus_out ;
output		ddr_out ;
output		cmp_out ;
input		jbus_in ;
input		ddr_in ;
input		cmp_in ;
 
 
 
bw_clk_gclk_inv_224x xddr (
     .clkout          (ddr_out ),
     .clkin           (ddr_in ) );
bw_clk_gclk_inv_224x xjbus (
     .clkout          (jbus_out ),
     .clkin           (jbus_in ) );
bw_clk_gclk_inv_224x xcmp (
     .clkout          (cmp_out ),
     .clkin           (cmp_in ) );
endmodule

