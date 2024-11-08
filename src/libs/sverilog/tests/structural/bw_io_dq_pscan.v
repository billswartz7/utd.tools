// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dq_pscan.v
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
module bw_io_dq_pscan(serial_in ,serial_out ,bypass_in ,out_type ,clk ,
     bypass ,ps_select ,rcv_in );
output		serial_out ;
input		serial_in ;
input		bypass_in ;
input		out_type ;
input		clk ;
input		bypass ;
input		ps_select ;
input		rcv_in ;
supply0		vss ;
 
wire		net70 ;
wire		net73 ;
wire		net80 ;
wire		net44 ;
wire		net46 ;
wire		net48 ;
wire		net50 ;
wire		net52 ;
wire		net54 ;
wire		net58 ;
wire		net62 ;
wire		net66 ;
 
 
bw_u1_inv_1x ps_inv1 (
     .z               (net48 ),
     .a               (net73 ) );
bw_u1_inv_1x ps_inv2 (
     .z               (net44 ),
     .a               (net58 ) );
bw_u1_soff_1x psff (
     .q               (net73 ),
     .so              (net80 ),
     .ck              (net54 ),
     .d               (net62 ),
     .se              (vss ),
     .sd              (vss ) );
bw_u1_inv_1x clk_inv (
     .z               (net54 ),
     .a               (clk ) );
bw_u1_buf_20x out_buf (
     .z               (serial_out ),
     .a               (net44 ) );
bw_u1_muxi21_1x I48 (
     .z               (net70 ),
     .d0              (rcv_in ),
     .d1              (serial_in ),
     .s               (out_type ) );
bw_u1_muxi21_1x I52 (
     .z               (net66 ),
     .d0              (net52 ),
     .d1              (bypass ),
     .s               (out_type ) );
bw_u1_inv_1x I53 (
     .z               (net46 ),
     .a               (net66 ) );
bw_u1_muxi21_1x ps_mux1 (
     .z               (net62 ),
     .d0              (serial_in ),
     .d1              (bypass_in ),
     .s               (out_type ) );
bw_u1_inv_1x I54 (
     .z               (net52 ),
     .a               (ps_select ) );
bw_u1_muxi21_1x ps_mux2 (
     .z               (net58 ),
     .d0              (net50 ),
     .d1              (net48 ),
     .s               (net46 ) );
bw_u1_inv_1x I55 (
     .z               (net50 ),
     .a               (net70 ) );
endmodule

