// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_rpt.v
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
module bw_io_dtl_rpt(out18 ,in7 ,in0 ,out16 ,in3 ,in2 ,in6 ,out19 ,in8 ,
     in9 ,out15 ,out17 ,in1 ,in4 ,in5 ,out13 ,in10 ,in11 ,in12 ,in13 ,
     in19 ,in18 ,in17 ,in16 ,in15 ,out6 ,out7 ,out8 ,out9 ,out10 ,out11
      ,out12 ,out0 ,out1 ,out2 ,out3 ,out4 ,out5 );
output [1:0]	out18 ;
output [1:0]	out16 ;
output [1:0]	out19 ;
output [1:0]	out15 ;
output [1:0]	out17 ;
output [1:0]	out13 ;
output [1:0]	out6 ;
output [1:0]	out7 ;
output [1:0]	out8 ;
output [1:0]	out9 ;
output [1:0]	out10 ;
output [1:0]	out11 ;
output [1:0]	out12 ;
output [8:1]	out0 ;
output [8:1]	out1 ;
output [8:1]	out2 ;
output [8:1]	out3 ;
output [1:0]	out4 ;
output [1:0]	out5 ;
input [1:0]	in7 ;
input [8:1]	in0 ;
input [8:1]	in3 ;
input [8:1]	in2 ;
input [1:0]	in6 ;
input [1:0]	in8 ;
input [1:0]	in9 ;
input [8:1]	in1 ;
input [1:0]	in4 ;
input [1:0]	in5 ;
input [1:0]	in10 ;
input [1:0]	in11 ;
input [1:0]	in12 ;
input [1:0]	in13 ;
input [1:0]	in19 ;
input [1:0]	in18 ;
input [1:0]	in17 ;
input [1:0]	in16 ;
input [1:0]	in15 ;
 
 
 
bw_u1_buf_15x I40_0_ (
     .z               (out19[0] ),
     .a               (in19[0] ) );
bw_u1_buf_15x I44_0_ (
     .z               (out13[0] ),
     .a               (in13[0] ) );
bw_u1_buf_15x I46_4_ (
     .z               (out3[4] ),
     .a               (in3[4] ) );
bw_u1_buf_15x I48_0_ (
     .z               (out15[0] ),
     .a               (in15[0] ) );
bw_u1_buf_15x I52_0_ (
     .z               (out9[0] ),
     .a               (in9[0] ) );
bw_u1_buf_15x I56_0_ (
     .z               (out7[0] ),
     .a               (in7[0] ) );
bw_u1_buf_15x I38_1_ (
     .z               (out1[1] ),
     .a               (in1[1] ) );
bw_u1_buf_15x I37_3_ (
     .z               (out2[3] ),
     .a               (in2[3] ) );
bw_u1_buf_15x I39_7_ (
     .z               (out0[7] ),
     .a               (in0[7] ) );
bw_u1_buf_15x I40_1_ (
     .z               (out19[1] ),
     .a               (in19[1] ) );
bw_u1_buf_15x I44_1_ (
     .z               (out13[1] ),
     .a               (in13[1] ) );
bw_u1_buf_15x I46_5_ (
     .z               (out3[5] ),
     .a               (in3[5] ) );
bw_u1_buf_15x I48_1_ (
     .z               (out15[1] ),
     .a               (in15[1] ) );
bw_u1_buf_15x I52_1_ (
     .z               (out9[1] ),
     .a               (in9[1] ) );
bw_u1_buf_15x I56_1_ (
     .z               (out7[1] ),
     .a               (in7[1] ) );
bw_u1_buf_15x I38_2_ (
     .z               (out1[2] ),
     .a               (in1[2] ) );
bw_u1_buf_15x I37_4_ (
     .z               (out2[4] ),
     .a               (in2[4] ) );
bw_u1_buf_15x I39_8_ (
     .z               (out0[8] ),
     .a               (in0[8] ) );
bw_u1_buf_15x I41_0_ (
     .z               (out18[0] ),
     .a               (in18[0] ) );
bw_u1_buf_15x I45_0_ (
     .z               (out12[0] ),
     .a               (in12[0] ) );
bw_u1_buf_15x I46_6_ (
     .z               (out3[6] ),
     .a               (in3[6] ) );
bw_u1_buf_15x I49_0_ (
     .z               (out11[0] ),
     .a               (in11[0] ) );
bw_u1_buf_15x I53_0_ (
     .z               (out5[0] ),
     .a               (in5[0] ) );
bw_u1_buf_15x I39_1_ (
     .z               (out0[1] ),
     .a               (in0[1] ) );
bw_u1_buf_15x I38_3_ (
     .z               (out1[3] ),
     .a               (in1[3] ) );
bw_u1_buf_15x I37_5_ (
     .z               (out2[5] ),
     .a               (in2[5] ) );
bw_u1_buf_15x I41_1_ (
     .z               (out18[1] ),
     .a               (in18[1] ) );
bw_u1_buf_15x I45_1_ (
     .z               (out12[1] ),
     .a               (in12[1] ) );
bw_u1_buf_15x I46_7_ (
     .z               (out3[7] ),
     .a               (in3[7] ) );
bw_u1_buf_15x I49_1_ (
     .z               (out11[1] ),
     .a               (in11[1] ) );
bw_u1_buf_15x I53_1_ (
     .z               (out5[1] ),
     .a               (in5[1] ) );
bw_u1_buf_15x I39_2_ (
     .z               (out0[2] ),
     .a               (in0[2] ) );
bw_u1_buf_15x I38_4_ (
     .z               (out1[4] ),
     .a               (in1[4] ) );
bw_u1_buf_15x I37_6_ (
     .z               (out2[6] ),
     .a               (in2[6] ) );
bw_u1_buf_15x I42_0_ (
     .z               (out16[0] ),
     .a               (in16[0] ) );
bw_u1_buf_15x I46_8_ (
     .z               (out3[8] ),
     .a               (in3[8] ) );
bw_u1_buf_15x I50_0_ (
     .z               (out10[0] ),
     .a               (in10[0] ) );
bw_u1_buf_15x I54_0_ (
     .z               (out4[0] ),
     .a               (in4[0] ) );
bw_u1_buf_15x I39_3_ (
     .z               (out0[3] ),
     .a               (in0[3] ) );
bw_u1_buf_15x I38_5_ (
     .z               (out1[5] ),
     .a               (in1[5] ) );
bw_u1_buf_15x I37_7_ (
     .z               (out2[7] ),
     .a               (in2[7] ) );
bw_u1_buf_15x I42_1_ (
     .z               (out16[1] ),
     .a               (in16[1] ) );
bw_u1_buf_15x I46_1_ (
     .z               (out3[1] ),
     .a               (in3[1] ) );
bw_u1_buf_15x I50_1_ (
     .z               (out10[1] ),
     .a               (in10[1] ) );
bw_u1_buf_15x I54_1_ (
     .z               (out4[1] ),
     .a               (in4[1] ) );
bw_u1_buf_15x I39_4_ (
     .z               (out0[4] ),
     .a               (in0[4] ) );
bw_u1_buf_15x I38_6_ (
     .z               (out1[6] ),
     .a               (in1[6] ) );
bw_u1_buf_15x I37_8_ (
     .z               (out2[8] ),
     .a               (in2[8] ) );
bw_u1_buf_15x I43_0_ (
     .z               (out17[0] ),
     .a               (in17[0] ) );
bw_u1_buf_15x I46_2_ (
     .z               (out3[2] ),
     .a               (in3[2] ) );
bw_u1_buf_15x I51_0_ (
     .z               (out8[0] ),
     .a               (in8[0] ) );
bw_u1_buf_15x I55_0_ (
     .z               (out6[0] ),
     .a               (in6[0] ) );
bw_u1_buf_15x I37_1_ (
     .z               (out2[1] ),
     .a               (in2[1] ) );
bw_u1_buf_15x I39_5_ (
     .z               (out0[5] ),
     .a               (in0[5] ) );
bw_u1_buf_15x I38_7_ (
     .z               (out1[7] ),
     .a               (in1[7] ) );
bw_u1_buf_15x I43_1_ (
     .z               (out17[1] ),
     .a               (in17[1] ) );
bw_u1_buf_15x I46_3_ (
     .z               (out3[3] ),
     .a               (in3[3] ) );
bw_u1_buf_15x I51_1_ (
     .z               (out8[1] ),
     .a               (in8[1] ) );
bw_u1_buf_15x I55_1_ (
     .z               (out6[1] ),
     .a               (in6[1] ) );
bw_u1_buf_15x I37_2_ (
     .z               (out2[2] ),
     .a               (in2[2] ) );
bw_u1_buf_15x I39_6_ (
     .z               (out0[6] ),
     .a               (in0[6] ) );
bw_u1_buf_15x I38_8_ (
     .z               (out1[8] ),
     .a               (in1[8] ) );
endmodule
