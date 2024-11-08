// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_clkgen.v
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
module bw_io_impctl_clkgen(se ,oe_out ,updclk ,so_l ,si_l ,
     synced_upd_imped ,bypass ,global_reset_n ,clk ,hard_reset_n ,sclk ,
     reset_l ,avgcntr_rst );
output		oe_out ;
output		updclk ;
output		so_l ;
output		bypass ;
output		global_reset_n ;
output		sclk ;
output		avgcntr_rst ;
input		se ;
input		si_l ;
input		synced_upd_imped ;
input		clk ;
input		hard_reset_n ;
input		reset_l ;
 
wire		int_sclk ;
wire		net42 ;
 
 
bw_io_impctl_sclk I227 (
     .l2clk           (clk ),
     .int_sclk        (int_sclk ),
     .sclk            (sclk ),
     .ssclk_n         (net42 ),
     .se              (se ),
     .si_l            (si_l ),
     .global_reset_n  (global_reset_n ) );
bw_io_impctl_upclk I208 (
     .int_sclk        (int_sclk ),
     .l2clk           (clk ),
     .synced_upd_imped (synced_upd_imped ),
     .updclk          (updclk ),
     .reset_l         (reset_l ),
     .oe_out          (oe_out ),
     .bypass          (bypass ),
     .avgcntr_rst     (avgcntr_rst ),
     .so_l            (so_l ),
     .hard_reset_n    (hard_reset_n ),
     .si_l            (net42 ),
     .se              (se ),
     .global_reset_n  (global_reset_n ) );
endmodule

