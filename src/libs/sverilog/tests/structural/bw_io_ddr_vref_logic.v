// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_vref_logic.v
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
module bw_io_ddr_vref_logic(a ,vrefcode ,c ,b ,vdd18 );
output [7:0]	vrefcode ;
input		a ;
input		c ;
input		b ;
input		vdd18 ;
 
wire		net202 ;
wire		net185 ;
wire		net190 ;
wire		net193 ;
wire		net0106 ;
wire		net196 ;
wire		net0107 ;
wire		net198 ;
wire		net0109 ;
wire		net0120 ;
wire		net181 ;
 
 
bw_u1_nand3_1x I1 (
     .z               (net202 ),
     .a               (a ),
     .b               (b ),
     .c               (c ) );
bw_u1_nand2_1x I2 (
     .z               (net196 ),
     .a               (a ),
     .b               (b ) );
bw_u1_nand2_1x I3 (
     .z               (net193 ),
     .a               (net0107 ),
     .b               (a ) );
bw_u1_nor2_2x I4 (
     .z               (net190 ),
     .a               (c ),
     .b               (b ) );
bw_u1_nand2_1x I9 (
     .z               (net198 ),
     .a               (b ),
     .b               (c ) );
bw_u1_nor2_1x I12 (
     .z               (net185 ),
     .a               (b ),
     .b               (a ) );
bw_u1_nor3_1x I13 (
     .z               (net181 ),
     .a               (c ),
     .b               (b ),
     .c               (a ) );
bw_u1_inv_1x I47 (
     .z               (net0106 ),
     .a               (a ) );
bw_u1_inv_1x I52 (
     .z               (net0109 ),
     .a               (net0120 ) );
bw_u1_nand2_1x I53 (
     .z               (net0120 ),
     .a               (net0106 ),
     .b               (net198 ) );
bw_u1_inv_1x I54 (
     .z               (net0107 ),
     .a               (net190 ) );
bw_io_ddr_vref_logic_high x0 (
     .in              ({net202 ,net196 ,net193 ,net0106 ,net0109 ,net185
             ,net181 } ),
     .vrefcode        ({vrefcode } ),
     .vdd18           (vdd18 ) );
endmodule
