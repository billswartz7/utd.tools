// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_rptr_c.v
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
module bw_io_ddr_rptr_c(out21 ,out20 ,out19 ,out18 ,out17 ,out16 ,out15
      ,out14 ,out13 ,out12 ,out10 ,out9 ,out8 ,out6 ,out5 ,out4 ,out3 ,
     out2 ,in21 ,in20 ,in19 ,in18 ,in17 ,in16 ,in15 ,in14 ,in13 ,in12 ,
     out1 ,out0 ,in10 ,in22 ,out22 ,in24 ,out24 ,out25 ,vdd18 ,in25 ,in2
      ,in5 ,in1 ,in4 ,in9 ,out11 ,in3 ,in11 ,in0 ,in6 ,in8 );
output [8:1]	out14 ;
output [8:1]	out13 ;
output [1:0]	out10 ;
output [1:0]	out9 ;
output [1:0]	out4 ;
output [4:0]	out1 ;
output [7:0]	out25 ;
input [8:1]	in14 ;
input [8:1]	in13 ;
input [1:0]	in10 ;
input [7:0]	in25 ;
input [4:0]	in1 ;
input [1:0]	in4 ;
input [1:0]	in9 ;
output		out21 ;
output		out20 ;
output		out19 ;
output		out18 ;
output		out17 ;
output		out16 ;
output		out15 ;
output		out12 ;
output		out8 ;
output		out6 ;
output		out5 ;
output		out3 ;
output		out2 ;
output		out0 ;
output		out22 ;
output		out24 ;
output		out11 ;
input		in21 ;
input		in20 ;
input		in19 ;
input		in18 ;
input		in17 ;
input		in16 ;
input		in15 ;
input		in12 ;
input		in22 ;
input		in24 ;
input		vdd18 ;
input		in2 ;
input		in5 ;
input		in3 ;
input		in11 ;
input		in0 ;
input		in6 ;
input		in8 ;
 
 
 
bw_u1_buf_30x I10_1_ (
     .z               (out9[1] ),
     .a               (in9[1] ) );
bw_u1_buf_30x I0 (
     .z               (out2 ),
     .a               (in2 ) );
bw_u1_buf_30x I1 (
     .z               (out3 ),
     .a               (in3 ) );
bw_u1_buf_30x I65_2_ (
     .z               (out1[2] ),
     .a               (in1[2] ) );
bw_u1_buf_30x I4 (
     .z               (out6 ),
     .a               (in6 ) );
bw_u1_buf_30x I5 (
     .z               (out5 ),
     .a               (in5 ) );
bw_u1_buf_30x I34_1_ (
     .z               (out13[1] ),
     .a               (in13[1] ) );
bw_u1_buf_30x I6 (
     .z               (out11 ),
     .a               (in11 ) );
bw_u1_buf_30x I35_7_ (
     .z               (out14[7] ),
     .a               (in14[7] ) );
bw_u1_buf_30x I7 (
     .z               (out12 ),
     .a               (in12 ) );
bw_u1_buf_30x I66 (
     .z               (out0 ),
     .a               (in0 ) );
bw_u1_buf_30x I65_3_ (
     .z               (out1[3] ),
     .a               (in1[3] ) );
bw_u1_buf_30x I34_2_ (
     .z               (out13[2] ),
     .a               (in13[2] ) );
bw_u1_buf_30x I35_8_ (
     .z               (out14[8] ),
     .a               (in14[8] ) );
bw_u1_buf_30x I65_4_ (
     .z               (out1[4] ),
     .a               (in1[4] ) );
bw_u1_buf_30x I34_3_ (
     .z               (out13[3] ),
     .a               (in13[3] ) );
bw_u1_buf_30x I35_1_ (
     .z               (out14[1] ),
     .a               (in14[1] ) );
bw_u1_buf_30x I9_0_ (
     .z               (out10[0] ),
     .a               (in10[0] ) );
bw_u1_buf_30x I11 (
     .z               (out8 ),
     .a               (in8 ) );
bw_u1_buf_30x I34_4_ (
     .z               (out13[4] ),
     .a               (in13[4] ) );
bw_u1_buf_30x I35_2_ (
     .z               (out14[2] ),
     .a               (in14[2] ) );
bw_u1_buf_30x I9_1_ (
     .z               (out10[1] ),
     .a               (in10[1] ) );
bw_u1_buf_30x I34_5_ (
     .z               (out13[5] ),
     .a               (in13[5] ) );
bw_u1_buf_30x I35_3_ (
     .z               (out14[3] ),
     .a               (in14[3] ) );
bw_u1_buf_30x I2_0_ (
     .z               (out4[0] ),
     .a               (in4[0] ) );
bw_u1_buf_30x I102 (
     .z               (out22 ),
     .a               (in22 ) );
bw_u1_buf_30x I34_6_ (
     .z               (out13[6] ),
     .a               (in13[6] ) );
bw_u1_buf_30x I35_4_ (
     .z               (out14[4] ),
     .a               (in14[4] ) );
bw_u1_buf_30x I36 (
     .z               (out15 ),
     .a               (in15 ) );
bw_u1_buf_30x I37 (
     .z               (out16 ),
     .a               (in16 ) );
bw_u1_buf_30x I38 (
     .z               (out17 ),
     .a               (in17 ) );
bw_u1_buf_30x I39 (
     .z               (out19 ),
     .a               (in19 ) );
bw_u1_buf_30x I110 (
     .z               (out24 ),
     .a               (in24 ) );
bw_u1_buf_30x I65_0_ (
     .z               (out1[0] ),
     .a               (in1[0] ) );
bw_u1_buf_30x I2_1_ (
     .z               (out4[1] ),
     .a               (in4[1] ) );
bw_u1_buf_30x I40 (
     .z               (out18 ),
     .a               (in18 ) );
bw_u1_buf_30x I41 (
     .z               (out20 ),
     .a               (in20 ) );
bw_u1_buf_30x I42 (
     .z               (out21 ),
     .a               (in21 ) );
bw_io_ddr_vref_rptr I115 (
     .out             ({out25 } ),
     .in              ({in25 } ),
     .vdd18           (vdd18 ) );
bw_u1_buf_30x I34_7_ (
     .z               (out13[7] ),
     .a               (in13[7] ) );
bw_u1_buf_30x I35_5_ (
     .z               (out14[5] ),
     .a               (in14[5] ) );
bw_u1_buf_30x I10_0_ (
     .z               (out9[0] ),
     .a               (in9[0] ) );
bw_u1_buf_30x I65_1_ (
     .z               (out1[1] ),
     .a               (in1[1] ) );
bw_u1_buf_30x I34_8_ (
     .z               (out13[8] ),
     .a               (in13[8] ) );
bw_u1_buf_30x I35_6_ (
     .z               (out14[6] ),
     .a               (in14[6] ) );
endmodule
