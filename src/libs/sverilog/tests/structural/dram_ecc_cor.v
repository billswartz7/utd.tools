// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_ecc_cor.v
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

module dram_ecc_cor (/*AUTOARG*/
   // Outputs
   ecc_multi_err, ecc_single_err, cor_data, ecc_loc, syndrome,
   // Inputs
   clk, raw_ecc, raw_data, l2if_dram_fail_over_mode
   );

// synopsys template
// Input Declarations
input 	    	clk;
input [15:0] 	raw_ecc;
input [127:0]	raw_data;
input		l2if_dram_fail_over_mode;
 
// Output Declarations
output       	ecc_multi_err;
output       	ecc_single_err;
output [127:0]  cor_data;
output [35:0]	ecc_loc;
output [15:0] 	syndrome;

// Wire Declarations
wire [127:0]  	fixed_data;
wire [3:0] 	outbyte0;
wire [3:0] 	outbyte1;
wire [3:0] 	outbyte2;
wire [3:0] 	outbyte3;
wire [3:0] 	outbyte4;
wire [3:0] 	outbyte5;
wire [3:0] 	outbyte6;
wire [3:0] 	outbyte7;
wire [3:0] 	outbyte8;
wire [3:0] 	outbyte9;
wire [3:0] 	outbyte10;
wire [3:0] 	outbyte11;
wire [3:0] 	outbyte12;
wire [3:0] 	outbyte13;
wire [3:0] 	outbyte14;
wire [3:0] 	outbyte15;
wire [3:0] 	outbyte16;
wire [3:0] 	outbyte17;
wire [3:0] 	outbyte18;
wire [3:0] 	outbyte19;
wire [3:0] 	outbyte20;
wire [3:0] 	outbyte21;
wire [3:0] 	outbyte22;
wire [3:0] 	outbyte23;
wire [3:0] 	outbyte24;
wire [3:0] 	outbyte25;
wire [3:0] 	outbyte26;
wire [3:0] 	outbyte27;
wire [3:0] 	outbyte28;
wire [3:0] 	outbyte29;
wire [3:0] 	outbyte30;
wire [3:0] 	outbyte31;

wire [3:0] 	eccresult0;
wire [3:0] 	eccresult1;
wire [3:0] 	eccresult2;
wire [3:0] 	eccresult3;
wire [3:0] 	eccresult0_d1;
wire [3:0] 	eccresult1_d1;
wire [3:0] 	eccresult2_d1;
wire [3:0] 	eccresult3_d1;

wire [3:0]	diff_ecc0;
wire [3:0]	diff_ecc1;
wire [3:0]	diff_ecc2;
wire [3:0]	diff_ecc3;

wire [3:0]      diff_ecc0_d1;
wire [3:0]      diff_ecc1_d1;
wire [3:0]      diff_ecc2_d1;
wire [3:0]      diff_ecc3_d1;

wire [111:0] 	cor_result;
wire [127:0] 	raw_data_d1;

wire [3:0] 	cor_result2_d1;
wire [3:0] 	cor_result3_d1;
wire [3:0] 	cor_result4_d1;
wire [3:0] 	cor_result5_d1;
wire [3:0] 	cor_result6_d1;
wire [3:0] 	cor_result7_d1;
wire [3:0] 	cor_result8_d1;
wire [3:0] 	cor_result9_d1;
wire [3:0] 	cor_result10_d1;
wire [3:0] 	cor_result11_d1;
wire [3:0] 	cor_result12_d1;
wire [3:0] 	cor_result13_d1;
wire [3:0] 	cor_result14_d1;
wire [3:0] 	cor_result15_d1;
//wire [3:0] 	cor_result16_d1;
wire [3:0] 	cor_result17_d1;
wire [3:0] 	cor_result18_d1;
wire [3:0] 	cor_result19_d1;
wire [3:0] 	cor_result20_d1;
wire [3:0] 	cor_result21_d1;
wire [3:0] 	cor_result22_d1;
wire [3:0] 	cor_result23_d1;
wire [3:0] 	cor_result24_d1;
wire [3:0] 	cor_result25_d1;
wire [3:0] 	cor_result26_d1;
wire [3:0] 	cor_result27_d1;
wire [3:0] 	cor_result28_d1;
wire [3:0] 	cor_result29_d1;
wire [3:0] 	cor_result30_d1;

wire [3:0] 	inbyte0_d2;
wire [3:0] 	inbyte1_d2;
wire [3:0] 	inbyte2_d2;
wire [3:0] 	inbyte3_d2;
wire [3:0] 	inbyte4_d2;
wire [3:0] 	inbyte5_d2;
wire [3:0] 	inbyte6_d2;
wire [3:0] 	inbyte7_d2;
wire [3:0] 	inbyte8_d2;
wire [3:0] 	inbyte9_d2;
wire [3:0] 	inbyte10_d2;
wire [3:0] 	inbyte11_d2;
wire [3:0] 	inbyte12_d2;
wire [3:0] 	inbyte13_d2;
wire [3:0] 	inbyte14_d2;
wire [3:0] 	inbyte15_d2;
wire [3:0]      inbyte16_d2;
wire [3:0]      inbyte17_d2;
wire [3:0]      inbyte18_d2;
wire [3:0]      inbyte19_d2;
wire [3:0]      inbyte20_d2;
wire [3:0]      inbyte21_d2;
wire [3:0]      inbyte22_d2;
wire [3:0]      inbyte23_d2;
wire [3:0]      inbyte24_d2;
wire [3:0]      inbyte25_d2;
wire [3:0]      inbyte26_d2;
wire [3:0]      inbyte27_d2;
wire [3:0]      inbyte28_d2;
wire [3:0]      inbyte29_d2;
wire [3:0]      inbyte30_d2;
wire [3:0]      inbyte31_d2;

wire [15:0]	raw_ecc_d1;

///////////////////////////////
////// Code Begins Here ///////
///////////////////////////////

dram_ecc_gen    ecc_gen(
               	// Outputs
                .ecc({eccresult0, eccresult1, eccresult2, eccresult3}),
                // Intputs
                .data(raw_data));

// Find if ecc generated is different from the stored ecc

dff_ns #(16)      ff_ecc_result(
                .din({eccresult0, eccresult1, eccresult2, eccresult3}),
                .q({eccresult0_d1, eccresult1_d1, eccresult2_d1, eccresult3_d1}),
                .clk(clk));

dff_ns #(16)      ff_raw_ecc(
                .din(raw_ecc[15:0]),
                .q(raw_ecc_d1[15:0]),
                .clk(clk));

assign diff_ecc0 = eccresult0_d1 ^ raw_ecc_d1[15:12];
assign diff_ecc1 = eccresult1_d1 ^ raw_ecc_d1[11:8];
assign diff_ecc2 = eccresult2_d1 ^ raw_ecc_d1[7:4];
assign diff_ecc3 = eccresult3_d1 ^ raw_ecc_d1[3:0];

assign syndrome = {diff_ecc3, diff_ecc2, diff_ecc1, diff_ecc0};

/////////////////////////////////////////////////////////////////////////
// ECC correction logic
/////////////////////////////////////////////////////////////////////////

wire [3:0]  err_nibble;

assign err_nibble = (diff_ecc2 != 4'h0) ? diff_ecc2 : diff_ecc1;

dram_ecc_gen    ecc_cor(
               	// Outputs
		.result(cor_result), 
                // Intputs
                .data({32{err_nibble[3:0]}}));

// If 3 out of 4 syndrome nibbles are zero then its error in syndrome bits. So, we force the diff ecc to 0 in such case
// to not flip data bits.
wire [3:0]	diff_ecc0_in;
wire [3:0]	diff_ecc1_in;
wire [3:0]	diff_ecc2_in;
wire [3:0]	diff_ecc3_in;
wire [3:0]	secc_err;
wire [3:0]	secc_err_d1;

assign diff_ecc0_in = (diff_ecc1 == 4'h0) & (diff_ecc2 == 4'h0) & ((diff_ecc3 == 4'h0) & ~l2if_dram_fail_over_mode |
						l2if_dram_fail_over_mode) ? 4'h0 : diff_ecc0;
assign diff_ecc1_in = (diff_ecc0 == 4'h0) & (diff_ecc2 == 4'h0) & ((diff_ecc3 == 4'h0) & ~l2if_dram_fail_over_mode |
						l2if_dram_fail_over_mode) ? 4'h0 : diff_ecc1;
assign diff_ecc2_in = (diff_ecc0 == 4'h0) & (diff_ecc1 == 4'h0) & ((diff_ecc3 == 4'h0) & ~l2if_dram_fail_over_mode |
						l2if_dram_fail_over_mode) ? 4'h0 : diff_ecc2;
assign diff_ecc3_in = (diff_ecc0 == 4'h0) & (diff_ecc1 == 4'h0) & (diff_ecc2 == 4'h0) ? 4'h0 : diff_ecc3;

assign secc_err[0] = (diff_ecc1 == 4'h0) & (diff_ecc2 == 4'h0) & ((diff_ecc3 == 4'h0) & ~l2if_dram_fail_over_mode |
						l2if_dram_fail_over_mode) & (diff_ecc0 != 4'h0) ? 1'b1 : 1'b0;
assign secc_err[1] = (diff_ecc0 == 4'h0) & (diff_ecc2 == 4'h0) & ((diff_ecc3 == 4'h0) & ~l2if_dram_fail_over_mode |
						l2if_dram_fail_over_mode) & (diff_ecc1 != 4'h0) ? 1'b1 : 1'b0;
assign secc_err[2] = (diff_ecc0 == 4'h0) & (diff_ecc1 == 4'h0) & ((diff_ecc3 == 4'h0) & ~l2if_dram_fail_over_mode |
						l2if_dram_fail_over_mode) & (diff_ecc2 != 4'h0) ? 1'b1 : 1'b0;
assign secc_err[3] = (diff_ecc0 == 4'h0) & (diff_ecc1 == 4'h0) & (diff_ecc2 == 4'h0) & (diff_ecc3 != 4'h0) & 
						~l2if_dram_fail_over_mode ? 1'b1 : 1'b0;

// Need to flop to meet timing
dff_ns #(20)      ff_diff_ecc(
                .din({secc_err, diff_ecc0_in, diff_ecc1_in, diff_ecc2_in, diff_ecc3_in}),
                .q({secc_err_d1, diff_ecc0_d1, diff_ecc1_d1, diff_ecc2_d1, diff_ecc3_d1}),
                .clk(clk));

dff_ns #(112)      ff_cor_res(
                .din(cor_result),
                .q({ cor_result30_d1, cor_result29_d1, cor_result28_d1, cor_result27_d1, 
			cor_result26_d1, cor_result25_d1, cor_result24_d1, cor_result23_d1, 
			cor_result22_d1, cor_result21_d1, cor_result20_d1, 
			cor_result19_d1, cor_result18_d1, cor_result17_d1, 
			cor_result15_d1, cor_result14_d1, cor_result13_d1, 
			cor_result12_d1, cor_result11_d1, cor_result10_d1, cor_result9_d1, 
			cor_result8_d1, cor_result7_d1, cor_result6_d1, cor_result5_d1, 
			cor_result4_d1, cor_result3_d1, cor_result2_d1}),
                .clk(clk));

// Flop input data 
dff_ns #(128)     ff_raw_data(
                .din(raw_data[127:0]),
                .q(raw_data_d1[127:0]),
                .clk(clk));

dff_ns #(128)     ff_raw_data_d1(
                .din(raw_data_d1[127:0]),
                .q({inbyte31_d2, inbyte30_d2, inbyte29_d2, inbyte28_d2, inbyte27_d2, inbyte26_d2,
			inbyte25_d2, inbyte24_d2, inbyte23_d2, inbyte22_d2, inbyte21_d2, 
			inbyte20_d2, inbyte19_d2, inbyte18_d2, inbyte17_d2, inbyte16_d2,
			inbyte15_d2, inbyte14_d2, inbyte13_d2, inbyte12_d2, inbyte11_d2, 
			inbyte10_d2, inbyte9_d2, inbyte8_d2, inbyte7_d2, inbyte6_d2,
			inbyte5_d2, inbyte4_d2, inbyte3_d2, inbyte2_d2, inbyte1_d2, inbyte0_d2 }),
                .clk(clk));

// Correcting nibbles 0-14 - diff0/diff1
wire byte0_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (diff_ecc1_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte0 = inbyte0_d2 ^ (byte0_err ? diff_ecc1_d1 : 4'h0);

wire byte1_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result2_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte1 = inbyte1_d2 ^ (byte1_err ? diff_ecc1_d1 : 4'h0);

wire byte2_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result3_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte2 = inbyte2_d2 ^ (byte2_err ? diff_ecc1_d1 : 4'h0);

wire byte3_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result4_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte3 = inbyte3_d2 ^ (byte3_err ? diff_ecc1_d1 : 4'h0);

wire byte4_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result5_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte4 = inbyte4_d2 ^ (byte4_err ? diff_ecc1_d1 : 4'h0);

wire byte5_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result6_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte5 = inbyte5_d2 ^ (byte5_err ? diff_ecc1_d1 : 4'h0);

wire byte6_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result7_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte6 = inbyte6_d2 ^ (byte6_err ? diff_ecc1_d1 : 4'h0);

wire byte7_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result8_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte7 = inbyte7_d2 ^ (byte7_err ? diff_ecc1_d1 : 4'h0);

wire byte8_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result9_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte8 = inbyte8_d2 ^ (byte8_err ? diff_ecc1_d1 : 4'h0);

wire byte9_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result10_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte9 = inbyte9_d2 ^ (byte9_err ? diff_ecc1_d1 : 4'h0);

wire byte10_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result11_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte10 = inbyte10_d2 ^ (byte10_err ? diff_ecc1_d1 : 4'h0);

wire byte11_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result12_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte11 = inbyte11_d2 ^ (byte11_err ? diff_ecc1_d1 : 4'h0);

wire byte12_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result13_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte12 = inbyte12_d2 ^ (byte12_err ? diff_ecc1_d1 : 4'h0);

wire byte13_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result14_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte13 = inbyte13_d2 ^ (byte13_err ? diff_ecc1_d1 : 4'h0);

wire byte14_err = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result15_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte14 = inbyte14_d2 ^ (byte14_err ? diff_ecc1_d1 : 4'h0);

// Logic used for MECC detection - diff3/diff1
wire byte0_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (diff_ecc1_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte8_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result2_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte13_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result3_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte12_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result4_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte10_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result5_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte6_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result6_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte5_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result7_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte14_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result8_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte1_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result9_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte11_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result10_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte4_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result11_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte9_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result12_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte3_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result13_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte2_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result14_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte7_err_mecc = (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (cor_result15_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;

wire [14:0] err_byte_0_14_loc = {byte14_err_mecc, byte13_err_mecc, byte12_err_mecc, byte11_err_mecc,
					byte10_err_mecc, byte9_err_mecc, byte8_err_mecc, byte7_err_mecc,
					byte6_err_mecc, byte5_err_mecc, byte4_err_mecc, byte3_err_mecc,
					byte2_err_mecc, byte1_err_mecc, byte0_err_mecc};
					
// Correcting nibbles 15-29 - diff0/diff2
wire byte15_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (diff_ecc2_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte15 = inbyte15_d2 ^ (byte15_err ? diff_ecc2_d1 : 4'h0);

wire byte16_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result17_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte16 = inbyte16_d2 ^ (byte16_err ? diff_ecc2_d1 : 4'h0);

wire byte17_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result18_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte17 = inbyte17_d2 ^ (byte17_err ? diff_ecc2_d1 : 4'h0);

wire byte18_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result19_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte18 = inbyte18_d2 ^ (byte18_err ? diff_ecc2_d1 : 4'h0);

wire byte19_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result20_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte19 = inbyte19_d2 ^ (byte19_err ? diff_ecc2_d1 : 4'h0);

wire byte20_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result21_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte20 = inbyte20_d2 ^ (byte20_err ? diff_ecc2_d1 : 4'h0);

wire byte21_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result22_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte21 = inbyte21_d2 ^ (byte21_err ? diff_ecc2_d1 : 4'h0);

wire byte22_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result23_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte22 = inbyte22_d2 ^ (byte22_err ? diff_ecc2_d1 : 4'h0);

wire byte23_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result24_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte23 = inbyte23_d2 ^ (byte23_err ? diff_ecc2_d1 : 4'h0);

wire byte24_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result25_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte24 = inbyte24_d2 ^ (byte24_err ? diff_ecc2_d1 : 4'h0);

wire byte25_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result26_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte25 = inbyte25_d2 ^ (byte25_err ? diff_ecc2_d1 : 4'h0);

wire byte26_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result27_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte26 = inbyte26_d2 ^ (byte26_err ? diff_ecc2_d1 : 4'h0);

wire byte27_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result28_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte27 = inbyte27_d2 ^ (byte27_err ? diff_ecc2_d1 : 4'h0);

wire byte28_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result29_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte28 = inbyte28_d2 ^ (byte28_err ? diff_ecc2_d1 : 4'h0);

wire byte29_err = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result30_d1 == diff_ecc0_d1) ? 1'b1 : 1'b0;
assign outbyte29 = inbyte29_d2 ^ (byte29_err ? diff_ecc2_d1 : 4'h0);

// Logic used for MECC detection - diff3/diff2
wire byte15_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (diff_ecc2_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte23_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result2_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte28_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result3_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte27_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result4_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte25_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result5_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte21_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result6_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte20_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result7_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte29_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result8_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte16_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result9_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte26_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result10_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte19_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result11_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte24_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result12_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte18_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result13_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte17_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result14_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;
wire byte22_err_mecc = (diff_ecc2_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (cor_result15_d1 == diff_ecc3_d1) ? 1'b1 : 1'b0;

wire [14:0] err_byte_15_29_loc = {byte29_err_mecc, byte28_err_mecc, byte27_err_mecc, byte26_err_mecc,
					byte25_err_mecc, byte24_err_mecc, byte23_err_mecc, byte22_err_mecc,
					byte21_err_mecc, byte20_err_mecc, byte19_err_mecc, byte18_err_mecc,
					byte17_err_mecc, byte16_err_mecc, byte15_err_mecc};
					
// Correcting nibbles 30-31
wire byte30_err = (diff_ecc0_d1 == 4'h0) & (diff_ecc1_d1 == diff_ecc2_d1) & (diff_ecc1_d1 != 4'h0) ? 
					1'b1 : 1'b0;
assign outbyte30 = inbyte30_d2 ^ (byte30_err ? diff_ecc2_d1 : 4'h0);

wire byte31_err = (diff_ecc0_d1 == diff_ecc1_d1) & (diff_ecc1_d1 == diff_ecc2_d1) & (diff_ecc0_d1 != 4'h0) ? 
					1'b1 : 1'b0;
assign outbyte31 = inbyte31_d2 ^ (byte31_err ? diff_ecc2_d1 : 4'h0);

// ecc location
assign ecc_loc[35:0] = {secc_err_d1[3:0], byte31_err, byte30_err, byte29_err, byte28_err, byte27_err, byte26_err, 
				byte25_err, byte24_err,
				byte23_err, byte22_err, byte21_err, byte20_err, byte19_err, byte18_err, byte17_err, 
				byte16_err, byte15_err, byte14_err, byte13_err, byte12_err, byte11_err, byte10_err, 
				byte9_err, byte8_err, byte7_err, byte6_err, byte5_err, byte4_err, byte3_err, 
				byte2_err, byte1_err, byte0_err};

// Generate multi ecc error signal. 
assign ecc_multi_err = ~l2if_dram_fail_over_mode & ( 
	((diff_ecc0_d1 == 4'h0) & (diff_ecc1_d1 == 4'h0) & (diff_ecc2_d1 != 4'h0) & (diff_ecc3_d1 != 4'h0)) |
        ((diff_ecc0_d1 != 4'h0) & (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (diff_ecc3_d1 == 4'h0)) |
        ((diff_ecc0_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (diff_ecc2_d1 != 4'h0) & (diff_ecc3_d1 == 4'h0)) |
        ((diff_ecc0_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (diff_ecc2_d1 == 4'h0) & (diff_ecc3_d1 != 4'h0)) |
        ((diff_ecc0_d1 == 4'h0) & (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (diff_ecc3_d1 != 4'h0)) |
        ((diff_ecc0_d1 == 4'h0) & (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 != 4'h0) & (diff_ecc3_d1 == 4'h0)) |
        ((diff_ecc0_d1 != 4'h0) & (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 != 4'h0) & (diff_ecc3_d1 != 4'h0)) |
        ((diff_ecc0_d1 != 4'h0) & (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0) & (diff_ecc3_d1 != 4'h0) &
		(ecc_loc[14:0] !=  err_byte_0_14_loc[14:0]) ) |
        ((diff_ecc0_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0) & (diff_ecc2_d1 != 4'h0) & (diff_ecc3_d1 != 4'h0) &
		(ecc_loc[29:15] != err_byte_15_29_loc[14:0]) ) |
	((diff_ecc0_d1 != 4'h0) & (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 != 4'h0) & (diff_ecc3_d1 == 4'h0) &
		((diff_ecc0_d1 != diff_ecc1_d1) | (diff_ecc1_d1 != diff_ecc2_d1)) ) |
  	((diff_ecc0_d1 == 4'h0) & (diff_ecc1_d1 != 4'h0) & (diff_ecc2_d1 != 4'h0) & (diff_ecc3_d1 != 4'h0) & 
		((diff_ecc1_d1 != diff_ecc2_d1) | (diff_ecc2_d1 != diff_ecc3_d1)) )); 

// Generate single ecc error signal. 
wire secc_err31 = (diff_ecc0_d1 != 4'h0) & ( (diff_ecc2_d1 == diff_ecc1_d1) & (diff_ecc2_d1 == diff_ecc0_d1) );
wire secc_err30 = (diff_ecc1_d1 != 4'h0) & ( (diff_ecc1_d1 == diff_ecc2_d1) & (diff_ecc0_d1 == 4'h0) );
wire secc_err_lo = (diff_ecc1_d1 != 4'h0) & (diff_ecc0_d1 != 4'h0) & (diff_ecc2_d1 == 4'h0); 
wire secc_err_hi = (diff_ecc2_d1 != 4'h0) & (diff_ecc0_d1 != 4'h0) & (diff_ecc1_d1 == 4'h0); 
assign ecc_single_err = ~ecc_multi_err & ((secc_err31 | secc_err30 | secc_err_hi | secc_err_lo) | (|secc_err_d1));

// Corrected data
assign fixed_data[127:0] = {outbyte31, outbyte30, outbyte29, outbyte28, outbyte27, outbyte26,
                        outbyte25, outbyte24, outbyte23, outbyte22, outbyte21,
                        outbyte20, outbyte19, outbyte18, outbyte17, outbyte16,
                        outbyte15, outbyte14, outbyte13, outbyte12, outbyte11,
                        outbyte10, outbyte9, outbyte8, outbyte7, outbyte6,
                        outbyte5, outbyte4, outbyte3, outbyte2, outbyte1, outbyte0};

assign cor_data[127:0] = ecc_multi_err ? 
			({inbyte31_d2, inbyte30_d2, inbyte29_d2, inbyte28_d2, inbyte27_d2, inbyte26_d2,
			inbyte25_d2, inbyte24_d2, inbyte23_d2, inbyte22_d2, inbyte21_d2, 
			inbyte20_d2, inbyte19_d2, inbyte18_d2, inbyte17_d2, inbyte16_d2,
			inbyte15_d2, inbyte14_d2, inbyte13_d2, inbyte12_d2, inbyte11_d2, 
			inbyte10_d2, inbyte9_d2, inbyte8_d2, inbyte7_d2, inbyte6_d2,
			inbyte5_d2, inbyte4_d2, inbyte3_d2, inbyte2_d2, inbyte1_d2, inbyte0_d2 }) : fixed_data;

endmodule // ecc 
