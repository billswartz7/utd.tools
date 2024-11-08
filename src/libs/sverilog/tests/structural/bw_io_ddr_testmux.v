// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_testmux.v
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
module bw_io_ddr_testmux(strobe_out ,clk ,testmode_l ,strobe );
output		strobe_out ;
input		clk ;
input		testmode_l ;
input		strobe ;
 
wire		tclkn ;
 
 
bw_u1_inv_20x I3 (
     .z               (strobe_out ),
     .a               (tclkn ) );
bw_u1_muxi21_6x I5 (
     .z               (tclkn ),
     .d0              (clk ),
     .d1              (strobe ),
     .s               (testmode_l ) );
endmodule
