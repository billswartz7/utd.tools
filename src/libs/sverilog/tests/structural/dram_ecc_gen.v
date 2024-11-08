// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_ecc_gen.v
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
//Galois multiplication by 4 
//GF (2 ^ 4) mult - primitive polynomial is 10011
//
//                                a3 a2 a1 a0
//                                b3 b2 b1 b0
//
//                        a3*b0 a2*b0 a1*b0 a0*b0
//                  a3*b1 a2*b1 a1*b1 a0*b1
//            a3*b2 a2*b2 a1*b2 a0*b2
//      a3*b3 a2*b3 a1*b3 a0*b3
//------------------------------------------------
//        s6   s5    s4    s3   s2    s1    s0
//        s6               s6   s6
//             s5               s5    s5
//                   s4               s4    s4
//------------------------------------------------
//			   p3   p2    p1    p0
//
//pw0 = a0*b0 + a1*b3 + a2*b2 + a3*b1
//pw1 = a1*b0 + a0*b1 + a3*b2 + a2*b3 + a3*b1 + a2*b2 + a1*b3
//pw2 = a2*b0 + a1*b1 + a0*b2 + a3*b3 + a3*b2 + a2*b3
//pw3 = a3*b0 + a2*b1 + a1*b2 + a0*b3 + a3*b3

// SYNDROMES
//P1(4 bits) = W0 + 2*W1 + 3*W2 +  4*W3 + 5*W4 + 6*W5 + 7*W6 + 8*W7 +
//               9*W8 + A*W9 + B*W10 + C*W11 + D*W12 + E*W13 + F*W14 +
//               W15 + 2*W16 + 3*W17 + 4*W18 + 5*W19 + 6*W20 + 7*W21 + 8*W22 +
//               9*W23 + A*W24 + B*W25 + C*W26 + D*W27 + E*W28 + F*W29 + W31
//
//P2(4 bits) =  W0 + W1 + W2 + W3 + W4 + W5 + W6 + W7 + W8 + W9 + W10 +
//                W11 + W12 + W13 + W14 + W30 + W31
//
//P3(4 bits) = W15 + W16 + W17 + W18 + W19 + W20 + W21 + W22 + W23 + W24 +
//               W25 + W26 + W27 + W28 + W29 + W30 + W31
//
//P4(4 bits) = W0 + 9*W1 + E*W2 +  D*W3 + B*W4 + 7*W5 + 6*W6 + F*W7 +
//             	2*W8 + C*W9 + 5*W10 + A*W11 + 4*W12 + 3*W13 + 8*W14 +
//             	W15 + 9*W16 + E*W17 + D*W18 + B*W19 + 7*W20 + 6*W21 + F*W22 +
//              2*W23 + C*W24 + 5*W25 + A*W26 + 4*W27 + 3*W28 + 8*W29 + W30

module dram_ecc_gen (/*AUTOARG*/
   // Inputs
   data,
   // Outputs
   result,
   ecc
   );

// Input Declarations
input [127:0] data;

// Output Declarations
output [111:0] result;
output [15:0] ecc;
 
// Wire Declarations

wire [3:0]	w0;
wire [3:0]	w1;
wire [3:0]	w2;
wire [3:0]	w3;
wire [3:0]	w4;
wire [3:0]	w5;
wire [3:0]	w6;
wire [3:0]	w7;
wire [3:0]	w8;
wire [3:0]	w9;
wire [3:0]	w10;
wire [3:0]	w11;
wire [3:0]	w12;
wire [3:0]	w13;
wire [3:0]	w14;
wire [3:0]	w15;
wire [3:0]	w16;
wire [3:0]	w17;
wire [3:0]	w18;
wire [3:0]	w19;
wire [3:0]	w20;
wire [3:0]	w21;
wire [3:0]	w22;
wire [3:0]	w23;
wire [3:0]	w24;
wire [3:0]	w25;
wire [3:0]	w26;
wire [3:0]	w27;
wire [3:0]	w28;
wire [3:0]	w29;
wire [3:0]	w30;
wire [3:0]	w31;

//wire [3:0]	pw0;
wire [3:0]	pw1;
wire [3:0]	pw2;
wire [3:0]	pw3;
wire [3:0]	pw4;
wire [3:0]	pw5;
wire [3:0]	pw6;
wire [3:0]	pw7;
wire [3:0]	pw8;
wire [3:0]	pw9;
wire [3:0]	pw10;
wire [3:0]	pw11;
wire [3:0]	pw12;
wire [3:0]	pw13;
wire [3:0]	pw14;
//wire [3:0]	pw15;
wire [3:0]	pw16;
wire [3:0]	pw17;
wire [3:0]	pw18;
wire [3:0]	pw19;
wire [3:0]	pw20;
wire [3:0]	pw21;
wire [3:0]	pw22;
wire [3:0]	pw23;
wire [3:0]	pw24;
wire [3:0]	pw25;
wire [3:0]	pw26;
wire [3:0]	pw27;
wire [3:0]	pw28;
wire [3:0]	pw29;
//wire [3:0]	pw30;
//wire [3:0]	pw31;

wire [3:0]	pw_1;
wire [3:0]	pw_2;
wire [3:0]	pw_3;
wire [3:0]	pw_4;
wire [3:0]	pw_5;
wire [3:0]	pw_6;
wire [3:0]	pw_7;
wire [3:0]	pw_8;
wire [3:0]	pw_9;
wire [3:0]	pw_10;
wire [3:0]	pw_11;
wire [3:0]	pw_12;
wire [3:0]	pw_13;
wire [3:0]	pw_14;
wire [3:0]	pw_16;
wire [3:0]	pw_17;
wire [3:0]	pw_18;
wire [3:0]	pw_19;
wire [3:0]	pw_20;
wire [3:0]	pw_21;
wire [3:0]	pw_22;
wire [3:0]	pw_23;
wire [3:0]	pw_24;
wire [3:0]	pw_25;
wire [3:0]	pw_26;
wire [3:0]	pw_27;
wire [3:0]	pw_28;
wire [3:0]	pw_29;

///////////////////////////////
////// Code Begins Here ///////
///////////////////////////////

assign w0[3:0]  = data[3:0];
assign w1[3:0]  = data[7:4];
assign w2[3:0]  = data[11:8];
assign w3[3:0]  = data[15:12];
assign w4[3:0]  = data[19:16];
assign w5[3:0]  = data[23:20];
assign w6[3:0]  = data[27:24];
assign w7[3:0]  = data[31:28];
assign w8[3:0]  = data[35:32];
assign w9[3:0]  = data[39:36];
assign w10[3:0] = data[43:40];
assign w11[3:0] = data[47:44];
assign w12[3:0] = data[51:48];
assign w13[3:0] = data[55:52];
assign w14[3:0] = data[59:56];
assign w15[3:0] = data[63:60];
assign w16[3:0] = data[67:64];
assign w17[3:0] = data[71:68];
assign w18[3:0] = data[75:72];
assign w19[3:0] = data[79:76];
assign w20[3:0] = data[83:80];
assign w21[3:0] = data[87:84];
assign w22[3:0] = data[91:88];
assign w23[3:0] = data[95:92];
assign w24[3:0] = data[99:96];
assign w25[3:0] = data[103:100];
assign w26[3:0] = data[107:104];
assign w27[3:0] = data[111:108];
assign w28[3:0] = data[115:112];
assign w29[3:0] = data[119:116];
assign w30[3:0] = data[123:120];
assign w31[3:0] = data[127:124];

/////////////////////////////
/// Galois Multiplication by 4
/////////////////////////////

// 2*w1

assign pw1[0] = w1[3]; 
assign pw1[1] = w1[0] ^ w1[3];
assign pw1[2] = w1[1];
assign pw1[3] = w1[2]; 

// 3*w2

assign pw2[0] = w2[0] ^ w2[3];
assign pw2[1] = w2[0] ^ w2[3] ^ w2[1];
assign pw2[2] = w2[1] ^ w2[2];
assign pw2[3] = w2[2] ^ w2[3];

// 4*w3

assign pw3[0] = w3[2];
assign pw3[1] = w3[3] ^ w3[2]; 
assign pw3[2] = w3[0] ^ w3[3];
assign pw3[3] = w3[1];

// 5*w4

assign pw4[0] = w4[2] ^ w4[0];
assign pw4[1] = w4[3] ^ w4[2] ^ w4[1];
assign pw4[2] = w4[0] ^ w4[3] ^ w4[2];
assign pw4[3] = w4[1] ^ w4[3];

// 6*w5

assign pw5[0] = w5[2] ^ w5[3];
assign pw5[1] = w5[2] ^ w5[0];
assign pw5[2] = w5[0] ^ w5[3] ^ w5[1];
assign pw5[3] = w5[1] ^ w5[2];

// 7*w6

assign pw6[0] = w6[2] ^ w6[3] ^ w6[0];
assign pw6[1] = w6[2] ^ w6[0] ^ w6[1];
assign pw6[2] = w6[0] ^ w6[3] ^ w6[1] ^ w6[2];
assign pw6[3] = w6[1] ^ w6[2] ^ w6[3];

// 8*w7

assign pw7[0] = w7[1];
assign pw7[1] = w7[2] ^ w7[1];
assign pw7[2] = w7[3] ^ w7[2];
assign pw7[3] = w7[0] ^ w7[3];

// 9*w8

assign pw8[0] = w8[1] ^ w8[0];
assign pw8[1] = w8[2];
assign pw8[2] = w8[3];
assign pw8[3] = w8[0];

// a*w9

assign pw9[0] = w9[1] ^ w9[3];
assign pw9[1] = w9[2] ^ w9[1] ^ w9[0] ^ w9[3];
assign pw9[2] = w9[3] ^ w9[2] ^ w9[1];
assign pw9[3] = w9[0] ^ w9[3] ^ w9[2];

// b*w10

assign pw10[0] = w10[1] ^ w10[0] ^ w10[3];
assign pw10[1] = w10[2] ^ w10[0] ^ w10[3];
assign pw10[2] = w10[3] ^ w10[1];
assign pw10[3] = w10[0] ^ w10[2];

// c*w11

assign pw11[0] = w11[1] ^ w11[2];
assign pw11[1] = w11[3] ^ w11[1];
assign pw11[2] = w11[0] ^ w11[2];
assign pw11[3] = w11[0] ^ w11[3] ^ w11[1];

// d*w12

assign pw12[0] = w12[1] ^ w12[2] ^ w12[0];
assign pw12[1] = w12[3];
assign pw12[2] = w12[0];
assign pw12[3] = w12[0] ^ w12[1];

// e*w13

assign pw13[0] = w13[1] ^ w13[2] ^ w13[3];
assign pw13[1] = w13[1] ^ w13[0];
assign pw13[2] = w13[0] ^ w13[2] ^ w13[1];
assign pw13[3] = w13[0] ^ w13[3] ^ w13[1] ^ w13[2];

// f*w14

assign pw14[0] = w14[1] ^ w14[2] ^ w14[3] ^ w14[0];
assign pw14[1] = w14[0];
assign pw14[2] = w14[0] ^ w14[1];
assign pw14[3] = w14[0] ^ w14[1] ^ w14[2];

// 1*w15

//assign pw15[3:0] = w15[3:0];

// 2*w16

assign pw16[0] = w16[3];
assign pw16[1] = w16[0] ^ w16[3];
assign pw16[2] = w16[1];
assign pw16[3] = w16[2];

// 3*w17

assign pw17[0] = w17[0] ^ w17[3];
assign pw17[1] = w17[0] ^ w17[3] ^ w17[1];
assign pw17[2] = w17[1] ^ w17[2];
assign pw17[3] = w17[2] ^ w17[3];

// 4*w18

assign pw18[0] = w18[2];
assign pw18[1] = w18[3] ^ w18[2];
assign pw18[2] = w18[0] ^ w18[3];
assign pw18[3] = w18[1];

// 5*w19

assign pw19[0] = w19[2] ^ w19[0];
assign pw19[1] = w19[3] ^ w19[2] ^ w19[1];
assign pw19[2] = w19[0] ^ w19[3] ^ w19[2];
assign pw19[3] = w19[1] ^ w19[3];

// 6*w20

assign pw20[0] = w20[2] ^ w20[3];
assign pw20[1] = w20[2] ^ w20[0];
assign pw20[2] = w20[0] ^ w20[3] ^ w20[1];
assign pw20[3] = w20[1] ^ w20[2];

// 7*w21

assign pw21[0] = w21[2] ^ w21[3] ^ w21[0];
assign pw21[1] = w21[2] ^ w21[0] ^ w21[1];
assign pw21[2] = w21[0] ^ w21[3] ^ w21[1] ^ w21[2];
assign pw21[3] = w21[1] ^ w21[2] ^ w21[3];

// 8*w22

assign pw22[0] = w22[1];
assign pw22[1] = w22[2] ^ w22[1];
assign pw22[2] = w22[3] ^ w22[2];
assign pw22[3] = w22[0] ^ w22[3];

// 9*w23

assign pw23[0] = w23[1] ^ w23[0];
assign pw23[1] = w23[2];
assign pw23[2] = w23[3];
assign pw23[3] = w23[0];

// a*w24

assign pw24[0] = w24[1] ^ w24[3];
assign pw24[1] = w24[2] ^ w24[1] ^ w24[0] ^ w24[3];
assign pw24[2] = w24[3] ^ w24[2] ^ w24[1];
assign pw24[3] = w24[0] ^ w24[3] ^ w24[2];

// b*w25

assign pw25[0] = w25[1] ^ w25[0] ^ w25[3];
assign pw25[1] = w25[2] ^ w25[0] ^ w25[3];
assign pw25[2] = w25[3] ^ w25[1];
assign pw25[3] = w25[0] ^ w25[2];

// c*w26

assign pw26[0] = w26[1] ^ w26[2];
assign pw26[1] = w26[3] ^ w26[1];
assign pw26[2] = w26[0] ^ w26[2];
assign pw26[3] = w26[0] ^ w26[3] ^ w26[1];

// d*w27

assign pw27[0] = w27[1] ^ w27[2] ^ w27[0];
assign pw27[1] = w27[3];
assign pw27[2] = w27[0];
assign pw27[3] = w27[0] ^ w27[1];

// e*w28

assign pw28[0] = w28[1] ^ w28[2] ^ w28[3];
assign pw28[1] = w28[1] ^ w28[0];
assign pw28[2] = w28[0] ^ w28[2] ^ w28[1];
assign pw28[3] = w28[0] ^ w28[3] ^ w28[1] ^ w28[2];

// f*w29

assign pw29[0] = w29[1] ^ w29[2] ^ w29[3] ^ w29[0];
assign pw29[1] = w29[0];
assign pw29[2] = w29[0] ^ w29[1];
assign pw29[3] = w29[0] ^ w29[1] ^ w29[2];
 
// 1*w30

//assign pw30[3:0] = w30[3:0];

// 1*w31

//assign pw31[3:0] = w31[3:0];

//////////////
// Parity 4 calculations
//////////////

// 2*w8

assign pw_8[0] = w8[3]; 
assign pw_8[1] = w8[0] ^ w8[3];
assign pw_8[2] = w8[1];
assign pw_8[3] = w8[2]; 

// 3*w13

assign pw_13[0] = w13[0] ^ w13[3];
assign pw_13[1] = w13[0] ^ w13[3] ^ w13[1];
assign pw_13[2] = w13[1] ^ w13[2];
assign pw_13[3] = w13[2] ^ w13[3];

// 4*w12

assign pw_12[0] = w12[2];
assign pw_12[1] = w12[3] ^ w12[2]; 
assign pw_12[2] = w12[0] ^ w12[3];
assign pw_12[3] = w12[1];

// 5*w10

assign pw_10[0] = w10[2] ^ w10[0];
assign pw_10[1] = w10[3] ^ w10[2] ^ w10[1];
assign pw_10[2] = w10[0] ^ w10[3] ^ w10[2];
assign pw_10[3] = w10[1] ^ w10[3];

// 6*w6

assign pw_6[0] = w6[2] ^ w6[3];
assign pw_6[1] = w6[2] ^ w6[0];
assign pw_6[2] = w6[0] ^ w6[3] ^ w6[1];
assign pw_6[3] = w6[1] ^ w6[2];

// 7*w5

assign pw_5[0] = w5[2] ^ w5[3] ^ w5[0];
assign pw_5[1] = w5[2] ^ w5[0] ^ w5[1];
assign pw_5[2] = w5[0] ^ w5[3] ^ w5[1] ^ w5[2];
assign pw_5[3] = w5[1] ^ w5[2] ^ w5[3];

// 8*w14

assign pw_14[0] = w14[1];
assign pw_14[1] = w14[2] ^ w14[1];
assign pw_14[2] = w14[3] ^ w14[2];
assign pw_14[3] = w14[0] ^ w14[3];

// 9*w1

assign pw_1[0] = w1[1] ^ w1[0];
assign pw_1[1] = w1[2];
assign pw_1[2] = w1[3];
assign pw_1[3] = w1[0];

// a*w11

assign pw_11[0] = w11[1] ^ w11[3];
assign pw_11[1] = w11[2] ^ w11[1] ^ w11[0] ^ w11[3];
assign pw_11[2] = w11[3] ^ w11[2] ^ w11[1];
assign pw_11[3] = w11[0] ^ w11[3] ^ w11[2];

// b*w4

assign pw_4[0] = w4[1] ^ w4[0] ^ w4[3];
assign pw_4[1] = w4[2] ^ w4[0] ^ w4[3];
assign pw_4[2] = w4[3] ^ w4[1];
assign pw_4[3] = w4[0] ^ w4[2];

// c*w9

assign pw_9[0] = w9[1] ^ w9[2];
assign pw_9[1] = w9[3] ^ w9[1];
assign pw_9[2] = w9[0] ^ w9[2];
assign pw_9[3] = w9[0] ^ w9[3] ^ w9[1];

// d*w3

assign pw_3[0] = w3[1] ^ w3[2] ^ w3[0];
assign pw_3[1] = w3[3];
assign pw_3[2] = w3[0];
assign pw_3[3] = w3[0] ^ w3[1];

// e*w2

assign pw_2[0] = w2[1] ^ w2[2] ^ w2[3];
assign pw_2[1] = w2[1] ^ w2[0];
assign pw_2[2] = w2[0] ^ w2[2] ^ w2[1];
assign pw_2[3] = w2[0] ^ w2[3] ^ w2[1] ^ w2[2];

// f*w7

assign pw_7[0] = w7[1] ^ w7[2] ^ w7[3] ^ w7[0];
assign pw_7[1] = w7[0];
assign pw_7[2] = w7[0] ^ w7[1];
assign pw_7[3] = w7[0] ^ w7[1] ^ w7[2];

// 2*w23

assign pw_23[0] = w23[3]; 
assign pw_23[1] = w23[0] ^ w23[3];
assign pw_23[2] = w23[1];
assign pw_23[3] = w23[2]; 

// 3*w28

assign pw_28[0] = w28[0] ^ w28[3];
assign pw_28[1] = w28[0] ^ w28[3] ^ w28[1];
assign pw_28[2] = w28[1] ^ w28[2];
assign pw_28[3] = w28[2] ^ w28[3];

// 4*w27

assign pw_27[0] = w27[2];
assign pw_27[1] = w27[3] ^ w27[2]; 
assign pw_27[2] = w27[0] ^ w27[3];
assign pw_27[3] = w27[1];

// 5*w25

assign pw_25[0] = w25[2] ^ w25[0];
assign pw_25[1] = w25[3] ^ w25[2] ^ w25[1];
assign pw_25[2] = w25[0] ^ w25[3] ^ w25[2];
assign pw_25[3] = w25[1] ^ w25[3];

// 6*w21

assign pw_21[0] = w21[2] ^ w21[3];
assign pw_21[1] = w21[2] ^ w21[0];
assign pw_21[2] = w21[0] ^ w21[3] ^ w21[1];
assign pw_21[3] = w21[1] ^ w21[2];

// 7*w20

assign pw_20[0] = w20[2] ^ w20[3] ^ w20[0];
assign pw_20[1] = w20[2] ^ w20[0] ^ w20[1];
assign pw_20[2] = w20[0] ^ w20[3] ^ w20[1] ^ w20[2];
assign pw_20[3] = w20[1] ^ w20[2] ^ w20[3];

// 8*w29

assign pw_29[0] = w29[1];
assign pw_29[1] = w29[2] ^ w29[1];
assign pw_29[2] = w29[3] ^ w29[2];
assign pw_29[3] = w29[0] ^ w29[3];

// 9*w16

assign pw_16[0] = w16[1] ^ w16[0];
assign pw_16[1] = w16[2];
assign pw_16[2] = w16[3];
assign pw_16[3] = w16[0];

// a*w26

assign pw_26[0] = w26[1] ^ w26[3];
assign pw_26[1] = w26[2] ^ w26[1] ^ w26[0] ^ w26[3];
assign pw_26[2] = w26[3] ^ w26[2] ^ w26[1];
assign pw_26[3] = w26[0] ^ w26[3] ^ w26[2];

// b*w19

assign pw_19[0] = w19[1] ^ w19[0] ^ w19[3];
assign pw_19[1] = w19[2] ^ w19[0] ^ w19[3];
assign pw_19[2] = w19[3] ^ w19[1];
assign pw_19[3] = w19[0] ^ w19[2];

// c*w24

assign pw_24[0] = w24[1] ^ w24[2];
assign pw_24[1] = w24[3] ^ w24[1];
assign pw_24[2] = w24[0] ^ w24[2];
assign pw_24[3] = w24[0] ^ w24[3] ^ w24[1];

// d*w18

assign pw_18[0] = w18[1] ^ w18[2] ^ w18[0];
assign pw_18[1] = w18[3];
assign pw_18[2] = w18[0];
assign pw_18[3] = w18[0] ^ w18[1];

// e*w17

assign pw_17[0] = w17[1] ^ w17[2] ^ w17[3];
assign pw_17[1] = w17[1] ^ w17[0];
assign pw_17[2] = w17[0] ^ w17[2] ^ w17[1];
assign pw_17[3] = w17[0] ^ w17[3] ^ w17[1] ^ w17[2];

// f*w22

assign pw_22[0] = w22[1] ^ w22[2] ^ w22[3] ^ w22[0];
assign pw_22[1] = w22[0];
assign pw_22[2] = w22[0] ^ w22[1];
assign pw_22[3] = w22[0] ^ w22[1] ^ w22[2];

/////////////////////////////////////////////////////////////////////////
// Final ECC Calculation
// ECC generation logic for the incomming data
/////////////////////////////////////////////////////////////////////////

wire [3:0]	partialsum;
wire [3:0]	p3_partialsum;
wire [3:0]	syndrom0;
wire [3:0]	syndrom1;
wire [3:0]	syndrom2;
wire [3:0]	syndrom3;

// partial sum
assign partialsum[3:0] = pw1 ^ pw2 ^ pw3 ^ pw4 ^ pw5 ^ pw6 ^ pw7 ^ pw8 ^ pw9 ^ pw10 ^
		  pw11 ^ pw12 ^ pw13 ^ pw14 ^ pw16 ^ pw17 ^ pw18 ^ pw19 ^ pw20 ^
		  pw21 ^ pw22 ^ pw23 ^ pw24 ^ pw25 ^ pw26 ^ pw27 ^ pw28 ^ pw29;

assign p3_partialsum = pw_1 ^ pw_2 ^ pw_3 ^ pw_4 ^ pw_5 ^ pw_6 ^ pw_7 ^ pw_8 ^
			pw_9 ^ pw_10 ^ pw_11 ^ pw_12 ^ pw_13 ^ pw_14 ^
			pw_16 ^ pw_17 ^ pw_18 ^ pw_19 ^ pw_20 ^ pw_21 ^ pw_22 ^ pw_23 ^
                        pw_24 ^ pw_25 ^ pw_26 ^ pw_27 ^ pw_28 ^ pw_29;

assign syndrom0[3:0] = w0 ^ w15 ^ w31 ^ partialsum;

assign syndrom1[3:0] = w0 ^ w1 ^ w2 ^ w3 ^ w4 ^ w5 ^ w6 ^ w7 ^ w8 ^ w9 ^ w10 ^
		w11 ^ w12 ^ w13 ^ w14 ^ w30 ^ w31; 

assign syndrom2[3:0] = w15 ^ w16 ^ w17 ^ w18 ^ w19 ^ w20 ^ w21 ^ w22 ^ w23 ^ w24 ^ w25 ^
                w26 ^ w27 ^ w28 ^ w29 ^ w30 ^ w31;

assign syndrom3[3:0] = w0 ^ w15 ^ w30 ^ p3_partialsum;

assign ecc = {syndrom0, syndrom1, syndrom2, syndrom3};
assign result = { pw29, pw28, pw27, pw26, pw25, pw24, pw23, pw22, pw21, pw20, pw19, pw18, pw17, pw16, 
	    	  pw14, pw13, pw12, pw11, pw10, pw9, pw8, pw7, pw6, pw5, pw4, pw3, pw2, pw1};

endmodule
