// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_impctl_clnew.v
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
module bw_io_impctl_clnew(ctu_io_sscan_update ,ctu_io_sscan_out ,clk ,si
      ,so ,ctu_global_snap ,ctu_io_sscan_se ,sz ,tclk ,z ,snap_enable ,
     se ,freeze ,hard_reset_n ,ctu_io_sscan_in );
output [7:0]	sz ;
input [7:0]	z ;
output		ctu_io_sscan_out ;
output		so ;
output		snap_enable ;
output		freeze ;
input		ctu_io_sscan_update ;
input		clk ;
input		si ;
input		ctu_global_snap ;
input		ctu_io_sscan_se ;
input		tclk ;
input		se ;
input		hard_reset_n ;
input		ctu_io_sscan_in ;
 
wire [7:0]	sz_out ;
wire [7:0]	sz_in ;
wire [9:0]	scan_data ;
wire [7:0]	net0104 ;
wire [7:0]	net0106 ;
wire [7:1]	ssz ;
wire [7:0]	net098 ;
wire		net104 ;
wire		sfreeze ;
wire		net0150 ;
wire		net0130 ;
wire		net0133 ;
wire		fsscan ;
wire		net054 ;
wire		net0116 ;
wire		net0118 ;
wire		net0122 ;
wire		net0127 ;
wire		net079 ;
 
 
bw_u1_soff_4x I166_0_ (
     .q               (sz_in[0] ),
     .so              (scan_data[1] ),
     .ck              (clk ),
     .d               (net0106[7] ),
     .se              (se ),
     .sd              (scan_data[2] ) );
bw_u1_buf_10x I222_3_ (
     .z               (sz[3] ),
     .a               (sz_out[3] ) );
bw_u1_nand2_2x I202_2_ (
     .z               (net0104[5] ),
     .a               (sz_in[2] ),
     .b               (net079 ) );
bw_u1_nand2_4x I203_4_ (
     .z               (net0106[3] ),
     .a               (net0104[3] ),
     .b               (net098[3] ) );
bw_u1_nand2_2x I204_6_ (
     .z               (net098[1] ),
     .a               (snap_enable ),
     .b               (z[6] ) );
bw_u1_soffr_4x I231 (
     .q               (freeze ),
     .so              (scan_data[0] ),
     .ck              (clk ),
     .d               (net0130 ),
     .se              (se ),
     .sd              (scan_data[1] ),
     .r_l             (hard_reset_n ) );
bw_u1_nand2_4x I233 (
     .z               (net0127 ),
     .a               (freeze ),
     .b               (net0118 ) );
bw_u1_nand2_4x I234 (
     .z               (net0130 ),
     .a               (net0127 ),
     .b               (net0133 ) );
bw_u1_soff_4x I214_6_ (
     .q               (sz_out[6] ),
     .so              (ssz[6] ),
     .ck              (tclk ),
     .d               (sz_in[6] ),
     .se              (ctu_io_sscan_se ),
     .sd              (ssz[7] ) );
bw_u1_nand2_4x I235 (
     .z               (net0133 ),
     .a               (net0150 ),
     .b               (ctu_io_sscan_update ) );
bw_u1_inv_4x I236 (
     .z               (net0118 ),
     .a               (ctu_io_sscan_update ) );
bw_u1_buf_10x I222_2_ (
     .z               (sz[2] ),
     .a               (sz_out[2] ) );
bw_u1_soff_4x I166_7_ (
     .q               (sz_in[7] ),
     .so              (scan_data[8] ),
     .ck              (clk ),
     .d               (net0106[0] ),
     .se              (se ),
     .sd              (scan_data[9] ) );
bw_u1_nand2_2x I202_1_ (
     .z               (net0104[6] ),
     .a               (sz_in[1] ),
     .b               (net079 ) );
bw_u1_nand2_4x I203_3_ (
     .z               (net0106[4] ),
     .a               (net0104[4] ),
     .b               (net098[4] ) );
bw_u1_nand2_2x I204_5_ (
     .z               (net098[2] ),
     .a               (snap_enable ),
     .b               (z[5] ) );
bw_u1_soff_4x I214_5_ (
     .q               (sz_out[5] ),
     .so              (ssz[5] ),
     .ck              (tclk ),
     .d               (sz_in[5] ),
     .se              (ctu_io_sscan_se ),
     .sd              (ssz[6] ) );
bw_u1_soffr_4x I148 (
     .q               (sfreeze ),
     .so              (so ),
     .ck              (clk ),
     .d               (net104 ),
     .se              (se ),
     .sd              (scan_data[0] ),
     .r_l             (hard_reset_n ) );
bw_u1_buf_10x I222_1_ (
     .z               (sz[1] ),
     .a               (sz_out[1] ) );
bw_u1_soff_4x I166_6_ (
     .q               (sz_in[6] ),
     .so              (scan_data[7] ),
     .ck              (clk ),
     .d               (net0106[1] ),
     .se              (se ),
     .sd              (scan_data[8] ) );
bw_u1_nand2_4x I203_2_ (
     .z               (net0106[5] ),
     .a               (net0104[5] ),
     .b               (net098[5] ) );
bw_u1_nand2_2x I202_0_ (
     .z               (net0104[7] ),
     .a               (sz_in[0] ),
     .b               (net079 ) );
bw_u1_nand2_2x I204_4_ (
     .z               (net098[3] ),
     .a               (snap_enable ),
     .b               (z[4] ) );
bw_u1_soff_4x I214_4_ (
     .q               (sz_out[4] ),
     .so              (ssz[4] ),
     .ck              (tclk ),
     .d               (sz_in[4] ),
     .se              (ctu_io_sscan_se ),
     .sd              (ssz[5] ) );
bw_u1_buf_10x I222_0_ (
     .z               (sz[0] ),
     .a               (sz_out[0] ) );
bw_u1_soff_4x I166_5_ (
     .q               (sz_in[5] ),
     .so              (scan_data[6] ),
     .ck              (clk ),
     .d               (net0106[2] ),
     .se              (se ),
     .sd              (scan_data[7] ) );
bw_u1_nand2_4x I203_1_ (
     .z               (net0106[6] ),
     .a               (net0104[6] ),
     .b               (net098[6] ) );
bw_u1_nand2_2x I204_3_ (
     .z               (net098[4] ),
     .a               (snap_enable ),
     .b               (z[3] ) );
bw_u1_nand2_2x I202_7_ (
     .z               (net0104[0] ),
     .a               (sz_in[7] ),
     .b               (net079 ) );
bw_u1_soff_4x I214_3_ (
     .q               (sz_out[3] ),
     .so              (ssz[3] ),
     .ck              (tclk ),
     .d               (sz_in[3] ),
     .se              (ctu_io_sscan_se ),
     .sd              (ssz[4] ) );
bw_u1_soff_4x I166_4_ (
     .q               (sz_in[4] ),
     .so              (scan_data[5] ),
     .ck              (clk ),
     .d               (net0106[3] ),
     .se              (se ),
     .sd              (scan_data[6] ) );
bw_u1_buf_10x I222_7_ (
     .z               (sz[7] ),
     .a               (sz_out[7] ) );
bw_u1_nand2_4x I203_0_ (
     .z               (net0106[7] ),
     .a               (net0104[7] ),
     .b               (net098[7] ) );
bw_u1_nand2_2x I204_2_ (
     .z               (net098[5] ),
     .a               (snap_enable ),
     .b               (z[2] ) );
bw_u1_nand2_2x I202_6_ (
     .z               (net0104[1] ),
     .a               (sz_in[6] ),
     .b               (net079 ) );
bw_u1_soff_4x I214_2_ (
     .q               (sz_out[2] ),
     .so              (ssz[2] ),
     .ck              (tclk ),
     .d               (sz_in[2] ),
     .se              (ctu_io_sscan_se ),
     .sd              (ssz[3] ) );
bw_u1_buf_10x I222_6_ (
     .z               (sz[6] ),
     .a               (sz_out[6] ) );
bw_u1_soff_4x I166_3_ (
     .q               (sz_in[3] ),
     .so              (scan_data[4] ),
     .ck              (clk ),
     .d               (net0106[4] ),
     .se              (se ),
     .sd              (scan_data[5] ) );
bw_u1_nand2_2x I204_1_ (
     .z               (net098[6] ),
     .a               (snap_enable ),
     .b               (z[1] ) );
bw_u1_nand2_2x I202_5_ (
     .z               (net0104[2] ),
     .a               (sz_in[5] ),
     .b               (net079 ) );
bw_u1_nand2_4x I203_7_ (
     .z               (net0106[0] ),
     .a               (net0104[0] ),
     .b               (net098[0] ) );
bw_u1_inv_4x I201 (
     .z               (net079 ),
     .a               (snap_enable ) );
bw_u1_soff_4x I214_1_ (
     .q               (sz_out[1] ),
     .so              (ssz[1] ),
     .ck              (tclk ),
     .d               (sz_in[1] ),
     .se              (ctu_io_sscan_se ),
     .sd              (ssz[2] ) );
bw_u1_soff_4x I166_2_ (
     .q               (sz_in[2] ),
     .so              (scan_data[3] ),
     .ck              (clk ),
     .d               (net0106[5] ),
     .se              (se ),
     .sd              (scan_data[4] ) );
bw_u1_buf_10x I222_5_ (
     .z               (sz[5] ),
     .a               (sz_out[5] ) );
bw_u1_nand2_4x I203_6_ (
     .z               (net0106[1] ),
     .a               (net0104[1] ),
     .b               (net098[1] ) );
bw_u1_nand2_2x I204_0_ (
     .z               (net098[7] ),
     .a               (snap_enable ),
     .b               (z[0] ) );
bw_u1_nand2_2x I202_4_ (
     .z               (net0104[3] ),
     .a               (sz_in[4] ),
     .b               (net079 ) );
bw_u1_inv_4x I195 (
     .z               (net054 ),
     .a               (snap_enable ) );
bw_u1_soff_4x I214_0_ (
     .q               (sz_out[0] ),
     .so              (ctu_io_sscan_out ),
     .ck              (tclk ),
     .d               (sz_in[0] ),
     .se              (ctu_io_sscan_se ),
     .sd              (ssz[1] ) );
bw_u1_nand2_2x I196 (
     .z               (net0122 ),
     .a               (snap_enable ),
     .b               (freeze ) );
bw_u1_nand2_4x I197 (
     .z               (net104 ),
     .a               (net0116 ),
     .b               (net0122 ) );
bw_u1_nand2_2x I198 (
     .z               (net0116 ),
     .a               (sfreeze ),
     .b               (net054 ) );
bw_u1_soff_4x I166_1_ (
     .q               (sz_in[1] ),
     .so              (scan_data[2] ),
     .ck              (clk ),
     .d               (net0106[6] ),
     .se              (se ),
     .sd              (scan_data[3] ) );
bw_u1_soff_4x I218 (
     .q               (net0150 ),
     .so              (fsscan ),
     .ck              (tclk ),
     .d               (sfreeze ),
     .se              (ctu_io_sscan_se ),
     .sd              (ctu_io_sscan_in ) );
bw_u1_buf_10x I222_4_ (
     .z               (sz[4] ),
     .a               (sz_out[4] ) );
bw_u1_nand2_4x I203_5_ (
     .z               (net0106[2] ),
     .a               (net0104[2] ),
     .b               (net098[2] ) );
bw_u1_nand2_2x I202_3_ (
     .z               (net0104[4] ),
     .a               (sz_in[3] ),
     .b               (net079 ) );
bw_u1_nand2_2x I204_7_ (
     .z               (net098[0] ),
     .a               (snap_enable ),
     .b               (z[7] ) );
bw_u1_soff_4x I223 (
     .q               (snap_enable ),
     .so              (scan_data[9] ),
     .ck              (clk ),
     .d               (ctu_global_snap ),
     .se              (se ),
     .sd              (si ) );
bw_u1_soff_4x I214_7_ (
     .q               (sz_out[7] ),
     .so              (ssz[7] ),
     .ck              (tclk ),
     .d               (sz_in[7] ),
     .se              (ctu_io_sscan_se ),
     .sd              (fsscan ) );
endmodule

