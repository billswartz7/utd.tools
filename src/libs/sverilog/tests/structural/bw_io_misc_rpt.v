// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_misc_rpt.v
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
module bw_io_misc_rpt(in2 ,out2 ,out3 ,out4 ,out5 ,out6 ,out7 ,in3 ,in4
      ,in5 ,in6 ,in7 ,in1 ,out1 );
output		out2 ;
output		out3 ;
output		out4 ;
output		out5 ;
output		out6 ;
output		out7 ;
output		out1 ;
input		in2 ;
input		in3 ;
input		in4 ;
input		in5 ;
input		in6 ;
input		in7 ;
input		in1 ;
 
 
 
bw_u1_buf_40x I1 (
     .z               (out1 ),
     .a               (in1 ) );
bw_u1_buf_40x I132 (
     .z               (out7 ),
     .a               (in7 ) );
bw_u1_buf_40x I102 (
     .z               (out2 ),
     .a               (in2 ) );
bw_u1_buf_40x I103 (
     .z               (out3 ),
     .a               (in3 ) );
bw_u1_buf_40x I112 (
     .z               (out6 ),
     .a               (in6 ) );
bw_u1_buf_40x I113 (
     .z               (out5 ),
     .a               (in5 ) );
bw_u1_buf_40x I114 (
     .z               (out4 ),
     .a               (in4 ) );
endmodule
