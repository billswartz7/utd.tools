`ifndef SYNTHESIS
/* verilog_memcomp Version: p1.0.12-EAC */
/* common_memcomp Version: p1.0.3-EAC */
/* lang compiler Version: 4.7.0-EAC Jun  3 2015 18:38:59 */
//
//       CONFIDENTIAL AND PROPRIETARY SOFTWARE OF ARM PHYSICAL IP, INC.
//      
//       Copyright (c) 1993 - 2018 ARM Physical IP, Inc.  All Rights Reserved.
//      
//       Use of this Software is subject to the terms and conditions of the
//       applicable license agreement with ARM Physical IP, Inc.
//       In addition, this Software is protected by patents, copyright law 
//       and international treaties.
//      
//       The copyright notice(s) in this Software does not indicate actual or
//       intended publication of this Software.
//
//      Verilog model for Synchronous Single-Port Register File
//
//       Instance Name:              tsmc16_1rw_1024_64b
//       Words:                      1024
//       Bits:                       64
//       Mux:                        8
//       Drive:                      6
//       Write Mask:                 Off
//       Write Thru:                 Off
//       Extra Margin Adjustment:    On
//       Redundany:                  Off
//       Test Muxes                  Off
//       Power Gating:               Off
//       Retention:                  On
//       Pipeline:                   Off
//       Read Disturb Test:	        Off
//       
//       Creation Date:  Wed Sep 12 16:16:46 2018
//       Version: 	r1p0
//
//      Modeling Assumptions: This model supports full gate level simulation
//          including proper x-handling and timing check behavior.  Unit
//          delay timing is included in the model. Back-annotation of SDF
//          (v3.0 or v2.1) is supported.  SDF can be created utilyzing the delay
//          calculation views provided with this generator and supported
//          delay calculators.  All buses are modeled [MSB:LSB].  All 
//          ports are padded with Verilog primitives.
//
//      Modeling Limitations: None.
//
//      Known Bugs: None.
//
//      Known Work Arounds: N/A
//
`timescale 1 ns/1 ps
`define ARM_MEM_PROP 1.000
`define ARM_MEM_RETAIN 1.000
`define ARM_MEM_PERIOD 3.000
`define ARM_MEM_WIDTH 1.000
`define ARM_MEM_SETUP 1.000
`define ARM_MEM_HOLD 0.500
`define ARM_MEM_COLLISION 3.000

module datapath_latch_tsmc16_1rw_1024_64b (CLK,Q_update,D_update,SE,SI,D,DFTRAMBYP,mem_path,XQ,Q);
	input CLK,Q_update,D_update,SE,SI,D,DFTRAMBYP,mem_path,XQ;
	output Q;

	reg    D_int;
	reg    Q;

   //  Model PHI2 portion
   always @(CLK or SE or SI or D) begin
      if (CLK === 1'b0) begin
         if (SE===1'b1)
           D_int=SI;
         else if (SE===1'bx)
           D_int=1'bx;
         else
           D_int=D;
      end
   end

   // model output side of RAM latch
   always @(posedge Q_update or posedge D_update or mem_path or posedge XQ) begin
      if (XQ===1'b0) begin
         if (DFTRAMBYP===1'b1)
           Q=D_int;
         else
           Q=mem_path;
      end
      else
        Q=1'bx;
   end
endmodule // datapath_latch_tsmc16_1rw_1024_64b

// If ARM_UD_MODEL is defined at Simulator Command Line, it Selects the Fast Functional Model
`ifdef ARM_UD_MODEL

// Following parameter Values can be overridden at Simulator Command Line.

// ARM_UD_DP Defines the delay through Data Paths, for Memory Models it represents BIST MUX output delays.
`ifdef ARM_UD_DP
`else
`define ARM_UD_DP #0.001
`endif
// ARM_UD_CP Defines the delay through Clock Path Cells, for Memory Models it is not used.
`ifdef ARM_UD_CP
`else
`define ARM_UD_CP
`endif
// ARM_UD_SEQ Defines the delay through the Memory, for Memory Models it is used for CLK->Q delays.
`ifdef ARM_UD_SEQ
`else
`define ARM_UD_SEQ #0.01
`endif

`celldefine
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
module tsmc16_1rw_1024_64b (VDDCE, VDDPE, VSSE, Q, CLK, CEN, GWEN, A, D, STOV, EMA,
    EMAW, EMAS, RET1N);
`else
module tsmc16_1rw_1024_64b (Q, CLK, CEN, GWEN, A, D, STOV, EMA, EMAW, EMAS, RET1N);
`endif

  parameter ASSERT_PREFIX = "";
  parameter BITS = 64;
  parameter WORDS = 1024;
  parameter MUX = 8;
  parameter MEM_WIDTH = 512; // redun block size 8, 256 on left, 256 on right
  parameter MEM_HEIGHT = 128;
  parameter WP_SIZE = 64 ;
  parameter UPM_WIDTH = 3;
  parameter UPMW_WIDTH = 2;
  parameter UPMS_WIDTH = 1;
  parameter ROWS = 128;

  output [63:0] Q;
  input  CLK;
  input  CEN;
  input  GWEN;
  input [9:0] A;
  input [63:0] D;
  input  STOV;
  input [2:0] EMA;
  input [1:0] EMAW;
  input  EMAS;
  input  RET1N;
`ifdef POWER_PINS
  inout VDDCE;
  inout VDDPE;
  inout VSSE;
`endif

`ifdef POWER_PINS
  reg bad_VDDCE;
  reg bad_VDDPE;
  reg bad_VSSE;
  reg bad_power;
`endif
  wire corrupt_power;
  reg pre_charge_st;
  integer row_address;
  integer mux_address;
  initial row_address = 0;
  initial mux_address = 0;
  reg [511:0] mem [0:127];
  reg [511:0] row, row_t;
  reg LAST_CLK;
  reg [511:0] row_mask;
  reg [511:0] new_data;
  reg [511:0] data_out;
  reg [63:0] readLatch0;
  reg [63:0] shifted_readLatch0;
  wire [63:0] Q_int;
  reg [63:0] Q_int_delayed;
  reg XQ, Q_update;
  reg XD_sh, D_sh_update;
  wire [63:0] D_int_bmux;
  reg [63:0] mem_path;
  reg [63:0] mem_path_d;
  reg [63:0] writeEnable;
  reg clk0_int;

  wire [63:0] Q_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  reg  CEN_p2;
  wire  GWEN_;
  reg  GWEN_int;
  wire [9:0] A_;
  reg [9:0] A_int;
  wire [63:0] D_;
  reg [63:0] D_int;
  reg [63:0] XD_int;
  wire  STOV_;
  reg  STOV_int;
  wire [2:0] EMA_;
  reg [2:0] EMA_int;
  wire [1:0] EMAW_;
  reg [1:0] EMAW_int;
  wire  EMAS_;
  reg  EMAS_int;
  wire  RET1N_;
  reg  RET1N_int;

  assign Q[0] = Q_[0]; 
  assign Q[1] = Q_[1]; 
  assign Q[2] = Q_[2]; 
  assign Q[3] = Q_[3]; 
  assign Q[4] = Q_[4]; 
  assign Q[5] = Q_[5]; 
  assign Q[6] = Q_[6]; 
  assign Q[7] = Q_[7]; 
  assign Q[8] = Q_[8]; 
  assign Q[9] = Q_[9]; 
  assign Q[10] = Q_[10]; 
  assign Q[11] = Q_[11]; 
  assign Q[12] = Q_[12]; 
  assign Q[13] = Q_[13]; 
  assign Q[14] = Q_[14]; 
  assign Q[15] = Q_[15]; 
  assign Q[16] = Q_[16]; 
  assign Q[17] = Q_[17]; 
  assign Q[18] = Q_[18]; 
  assign Q[19] = Q_[19]; 
  assign Q[20] = Q_[20]; 
  assign Q[21] = Q_[21]; 
  assign Q[22] = Q_[22]; 
  assign Q[23] = Q_[23]; 
  assign Q[24] = Q_[24]; 
  assign Q[25] = Q_[25]; 
  assign Q[26] = Q_[26]; 
  assign Q[27] = Q_[27]; 
  assign Q[28] = Q_[28]; 
  assign Q[29] = Q_[29]; 
  assign Q[30] = Q_[30]; 
  assign Q[31] = Q_[31]; 
  assign Q[32] = Q_[32]; 
  assign Q[33] = Q_[33]; 
  assign Q[34] = Q_[34]; 
  assign Q[35] = Q_[35]; 
  assign Q[36] = Q_[36]; 
  assign Q[37] = Q_[37]; 
  assign Q[38] = Q_[38]; 
  assign Q[39] = Q_[39]; 
  assign Q[40] = Q_[40]; 
  assign Q[41] = Q_[41]; 
  assign Q[42] = Q_[42]; 
  assign Q[43] = Q_[43]; 
  assign Q[44] = Q_[44]; 
  assign Q[45] = Q_[45]; 
  assign Q[46] = Q_[46]; 
  assign Q[47] = Q_[47]; 
  assign Q[48] = Q_[48]; 
  assign Q[49] = Q_[49]; 
  assign Q[50] = Q_[50]; 
  assign Q[51] = Q_[51]; 
  assign Q[52] = Q_[52]; 
  assign Q[53] = Q_[53]; 
  assign Q[54] = Q_[54]; 
  assign Q[55] = Q_[55]; 
  assign Q[56] = Q_[56]; 
  assign Q[57] = Q_[57]; 
  assign Q[58] = Q_[58]; 
  assign Q[59] = Q_[59]; 
  assign Q[60] = Q_[60]; 
  assign Q[61] = Q_[61]; 
  assign Q[62] = Q_[62]; 
  assign Q[63] = Q_[63]; 
  assign CLK_ = CLK;
  assign CEN_ = CEN;
  assign GWEN_ = GWEN;
  assign A_[0] = A[0];
  assign A_[1] = A[1];
  assign A_[2] = A[2];
  assign A_[3] = A[3];
  assign A_[4] = A[4];
  assign A_[5] = A[5];
  assign A_[6] = A[6];
  assign A_[7] = A[7];
  assign A_[8] = A[8];
  assign A_[9] = A[9];
  assign D_[0] = D[0];
  assign D_[1] = D[1];
  assign D_[2] = D[2];
  assign D_[3] = D[3];
  assign D_[4] = D[4];
  assign D_[5] = D[5];
  assign D_[6] = D[6];
  assign D_[7] = D[7];
  assign D_[8] = D[8];
  assign D_[9] = D[9];
  assign D_[10] = D[10];
  assign D_[11] = D[11];
  assign D_[12] = D[12];
  assign D_[13] = D[13];
  assign D_[14] = D[14];
  assign D_[15] = D[15];
  assign D_[16] = D[16];
  assign D_[17] = D[17];
  assign D_[18] = D[18];
  assign D_[19] = D[19];
  assign D_[20] = D[20];
  assign D_[21] = D[21];
  assign D_[22] = D[22];
  assign D_[23] = D[23];
  assign D_[24] = D[24];
  assign D_[25] = D[25];
  assign D_[26] = D[26];
  assign D_[27] = D[27];
  assign D_[28] = D[28];
  assign D_[29] = D[29];
  assign D_[30] = D[30];
  assign D_[31] = D[31];
  assign D_[32] = D[32];
  assign D_[33] = D[33];
  assign D_[34] = D[34];
  assign D_[35] = D[35];
  assign D_[36] = D[36];
  assign D_[37] = D[37];
  assign D_[38] = D[38];
  assign D_[39] = D[39];
  assign D_[40] = D[40];
  assign D_[41] = D[41];
  assign D_[42] = D[42];
  assign D_[43] = D[43];
  assign D_[44] = D[44];
  assign D_[45] = D[45];
  assign D_[46] = D[46];
  assign D_[47] = D[47];
  assign D_[48] = D[48];
  assign D_[49] = D[49];
  assign D_[50] = D[50];
  assign D_[51] = D[51];
  assign D_[52] = D[52];
  assign D_[53] = D[53];
  assign D_[54] = D[54];
  assign D_[55] = D[55];
  assign D_[56] = D[56];
  assign D_[57] = D[57];
  assign D_[58] = D[58];
  assign D_[59] = D[59];
  assign D_[60] = D[60];
  assign D_[61] = D[61];
  assign D_[62] = D[62];
  assign D_[63] = D[63];
  assign STOV_ = STOV;
  assign EMA_[0] = EMA[0];
  assign EMA_[1] = EMA[1];
  assign EMA_[2] = EMA[2];
  assign EMAW_[0] = EMAW[0];
  assign EMAW_[1] = EMAW[1];
  assign EMAS_ = EMAS;
  assign RET1N_ = RET1N;

`ifdef POWER_PINS
  assign corrupt_power = bad_power;
`else
  assign corrupt_power = 1'b0;
`endif

   `ifdef ARM_FAULT_MODELING
     tsmc16_1rw_1024_64b_error_injection u1(.CLK(CLK_), .Q_out(Q_), .A(A_int), .CEN(CEN_int), .GWEN(GWEN_int), .WEN(GWEN_int), .Q_in(Q_int));
  `else
  assign `ARM_UD_SEQ Q_ = (RET1N_ | pre_charge_st) & ~corrupt_power ? ((STOV_ ? (Q_int_delayed) : (Q_int))) : {64{1'bx}};
  `endif

// If INITIALIZE_MEMORY is defined at Simulator Command Line, it Initializes the Memory with all ZEROS.
`ifdef INITIALIZE_MEMORY
  integer i;
  initial
  begin
    #0;
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
  end
`endif
  always @ (EMA_) begin
  	if(EMA_ < 2) 
   	$display("Warning: Set Value for EMA doesn't match Default value 2 in %m at %0t", $time);
  end
  always @ (EMAW_) begin
  	if(EMAW_ < 1) 
   	$display("Warning: Set Value for EMAW doesn't match Default value 1 in %m at %0t", $time);
  end
  always @ (EMAS_) begin
  	if(EMAS_ < 0) 
   	$display("Warning: Set Value for EMAS doesn't match Default value 0 in %m at %0t", $time);
  end
	always @ (STOV_) begin
		if(CLK_ == 1'b1) begin
			XQ = 1'b1; Q_update = 1'b1;
			#0; Q_update = 1'b0;
			XQ = 1'b0;
		end
	end

  task failedWrite;
  input port_f;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitval;
    begin
      isBitX = ( bitval===1'bx || bitval===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


task loadmem;
	input [1000*8-1:0] filename;
	reg [BITS-1:0] memld [0:WORDS-1];
	integer i;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
	$readmemb(filename, memld);
     if (CEN_ === 1'b1) begin
	  for (i=0;i<WORDS;i=i+1) begin
	  wordtemp = memld[i];
	  Atemp = i;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        row_mask =  ( {7'b0000000, writeEnable[63], 7'b0000000, writeEnable[62], 7'b0000000, writeEnable[61],
          7'b0000000, writeEnable[60], 7'b0000000, writeEnable[59], 7'b0000000, writeEnable[58],
          7'b0000000, writeEnable[57], 7'b0000000, writeEnable[56], 7'b0000000, writeEnable[55],
          7'b0000000, writeEnable[54], 7'b0000000, writeEnable[53], 7'b0000000, writeEnable[52],
          7'b0000000, writeEnable[51], 7'b0000000, writeEnable[50], 7'b0000000, writeEnable[49],
          7'b0000000, writeEnable[48], 7'b0000000, writeEnable[47], 7'b0000000, writeEnable[46],
          7'b0000000, writeEnable[45], 7'b0000000, writeEnable[44], 7'b0000000, writeEnable[43],
          7'b0000000, writeEnable[42], 7'b0000000, writeEnable[41], 7'b0000000, writeEnable[40],
          7'b0000000, writeEnable[39], 7'b0000000, writeEnable[38], 7'b0000000, writeEnable[37],
          7'b0000000, writeEnable[36], 7'b0000000, writeEnable[35], 7'b0000000, writeEnable[34],
          7'b0000000, writeEnable[33], 7'b0000000, writeEnable[32], 7'b0000000, writeEnable[31],
          7'b0000000, writeEnable[30], 7'b0000000, writeEnable[29], 7'b0000000, writeEnable[28],
          7'b0000000, writeEnable[27], 7'b0000000, writeEnable[26], 7'b0000000, writeEnable[25],
          7'b0000000, writeEnable[24], 7'b0000000, writeEnable[23], 7'b0000000, writeEnable[22],
          7'b0000000, writeEnable[21], 7'b0000000, writeEnable[20], 7'b0000000, writeEnable[19],
          7'b0000000, writeEnable[18], 7'b0000000, writeEnable[17], 7'b0000000, writeEnable[16],
          7'b0000000, writeEnable[15], 7'b0000000, writeEnable[14], 7'b0000000, writeEnable[13],
          7'b0000000, writeEnable[12], 7'b0000000, writeEnable[11], 7'b0000000, writeEnable[10],
          7'b0000000, writeEnable[9], 7'b0000000, writeEnable[8], 7'b0000000, writeEnable[7],
          7'b0000000, writeEnable[6], 7'b0000000, writeEnable[5], 7'b0000000, writeEnable[4],
          7'b0000000, writeEnable[3], 7'b0000000, writeEnable[2], 7'b0000000, writeEnable[1],
          7'b0000000, writeEnable[0]} << mux_address);
        new_data =  ( {7'b0000000, wordtemp[63], 7'b0000000, wordtemp[62], 7'b0000000, wordtemp[61],
          7'b0000000, wordtemp[60], 7'b0000000, wordtemp[59], 7'b0000000, wordtemp[58],
          7'b0000000, wordtemp[57], 7'b0000000, wordtemp[56], 7'b0000000, wordtemp[55],
          7'b0000000, wordtemp[54], 7'b0000000, wordtemp[53], 7'b0000000, wordtemp[52],
          7'b0000000, wordtemp[51], 7'b0000000, wordtemp[50], 7'b0000000, wordtemp[49],
          7'b0000000, wordtemp[48], 7'b0000000, wordtemp[47], 7'b0000000, wordtemp[46],
          7'b0000000, wordtemp[45], 7'b0000000, wordtemp[44], 7'b0000000, wordtemp[43],
          7'b0000000, wordtemp[42], 7'b0000000, wordtemp[41], 7'b0000000, wordtemp[40],
          7'b0000000, wordtemp[39], 7'b0000000, wordtemp[38], 7'b0000000, wordtemp[37],
          7'b0000000, wordtemp[36], 7'b0000000, wordtemp[35], 7'b0000000, wordtemp[34],
          7'b0000000, wordtemp[33], 7'b0000000, wordtemp[32], 7'b0000000, wordtemp[31],
          7'b0000000, wordtemp[30], 7'b0000000, wordtemp[29], 7'b0000000, wordtemp[28],
          7'b0000000, wordtemp[27], 7'b0000000, wordtemp[26], 7'b0000000, wordtemp[25],
          7'b0000000, wordtemp[24], 7'b0000000, wordtemp[23], 7'b0000000, wordtemp[22],
          7'b0000000, wordtemp[21], 7'b0000000, wordtemp[20], 7'b0000000, wordtemp[19],
          7'b0000000, wordtemp[18], 7'b0000000, wordtemp[17], 7'b0000000, wordtemp[16],
          7'b0000000, wordtemp[15], 7'b0000000, wordtemp[14], 7'b0000000, wordtemp[13],
          7'b0000000, wordtemp[12], 7'b0000000, wordtemp[11], 7'b0000000, wordtemp[10],
          7'b0000000, wordtemp[9], 7'b0000000, wordtemp[8], 7'b0000000, wordtemp[7],
          7'b0000000, wordtemp[6], 7'b0000000, wordtemp[5], 7'b0000000, wordtemp[4],
          7'b0000000, wordtemp[3], 7'b0000000, wordtemp[2], 7'b0000000, wordtemp[1],
          7'b0000000, wordtemp[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
  	end
    end
  end
  endtask

task dumpmem;
	input [1000*8-1:0] filename_dump;
	integer i, dump_file_desc;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
	dump_file_desc = $fopen(filename_dump);
     if (CEN_ === 1'b1) begin
	  for (i=0;i<WORDS;i=i+1) begin
	  Atemp = i;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[504], data_out[496], data_out[488], data_out[480], data_out[472],
          data_out[464], data_out[456], data_out[448], data_out[440], data_out[432],
          data_out[424], data_out[416], data_out[408], data_out[400], data_out[392],
          data_out[384], data_out[376], data_out[368], data_out[360], data_out[352],
          data_out[344], data_out[336], data_out[328], data_out[320], data_out[312],
          data_out[304], data_out[296], data_out[288], data_out[280], data_out[272],
          data_out[264], data_out[256], data_out[248], data_out[240], data_out[232],
          data_out[224], data_out[216], data_out[208], data_out[200], data_out[192],
          data_out[184], data_out[176], data_out[168], data_out[160], data_out[152],
          data_out[144], data_out[136], data_out[128], data_out[120], data_out[112],
          data_out[104], data_out[96], data_out[88], data_out[80], data_out[72], data_out[64],
          data_out[56], data_out[48], data_out[40], data_out[32], data_out[24], data_out[16],
          data_out[8], data_out[0]};
        shifted_readLatch0 = readLatch0;
        mem_path_d = {shifted_readLatch0[63], shifted_readLatch0[62], shifted_readLatch0[61],
          shifted_readLatch0[60], shifted_readLatch0[59], shifted_readLatch0[58], shifted_readLatch0[57],
          shifted_readLatch0[56], shifted_readLatch0[55], shifted_readLatch0[54], shifted_readLatch0[53],
          shifted_readLatch0[52], shifted_readLatch0[51], shifted_readLatch0[50], shifted_readLatch0[49],
          shifted_readLatch0[48], shifted_readLatch0[47], shifted_readLatch0[46], shifted_readLatch0[45],
          shifted_readLatch0[44], shifted_readLatch0[43], shifted_readLatch0[42], shifted_readLatch0[41],
          shifted_readLatch0[40], shifted_readLatch0[39], shifted_readLatch0[38], shifted_readLatch0[37],
          shifted_readLatch0[36], shifted_readLatch0[35], shifted_readLatch0[34], shifted_readLatch0[33],
          shifted_readLatch0[32], shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
   	$fdisplay(dump_file_desc, "%b", mem_path_d);
  end
  	end
    $fclose(dump_file_desc);
  end
  endtask

task loadaddr;
	input [9:0] load_addr;
	input [63:0] load_data;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
     if (CEN_ === 1'b1) begin
	  wordtemp = load_data;
	  Atemp = load_addr;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        row_mask =  ( {7'b0000000, writeEnable[63], 7'b0000000, writeEnable[62], 7'b0000000, writeEnable[61],
          7'b0000000, writeEnable[60], 7'b0000000, writeEnable[59], 7'b0000000, writeEnable[58],
          7'b0000000, writeEnable[57], 7'b0000000, writeEnable[56], 7'b0000000, writeEnable[55],
          7'b0000000, writeEnable[54], 7'b0000000, writeEnable[53], 7'b0000000, writeEnable[52],
          7'b0000000, writeEnable[51], 7'b0000000, writeEnable[50], 7'b0000000, writeEnable[49],
          7'b0000000, writeEnable[48], 7'b0000000, writeEnable[47], 7'b0000000, writeEnable[46],
          7'b0000000, writeEnable[45], 7'b0000000, writeEnable[44], 7'b0000000, writeEnable[43],
          7'b0000000, writeEnable[42], 7'b0000000, writeEnable[41], 7'b0000000, writeEnable[40],
          7'b0000000, writeEnable[39], 7'b0000000, writeEnable[38], 7'b0000000, writeEnable[37],
          7'b0000000, writeEnable[36], 7'b0000000, writeEnable[35], 7'b0000000, writeEnable[34],
          7'b0000000, writeEnable[33], 7'b0000000, writeEnable[32], 7'b0000000, writeEnable[31],
          7'b0000000, writeEnable[30], 7'b0000000, writeEnable[29], 7'b0000000, writeEnable[28],
          7'b0000000, writeEnable[27], 7'b0000000, writeEnable[26], 7'b0000000, writeEnable[25],
          7'b0000000, writeEnable[24], 7'b0000000, writeEnable[23], 7'b0000000, writeEnable[22],
          7'b0000000, writeEnable[21], 7'b0000000, writeEnable[20], 7'b0000000, writeEnable[19],
          7'b0000000, writeEnable[18], 7'b0000000, writeEnable[17], 7'b0000000, writeEnable[16],
          7'b0000000, writeEnable[15], 7'b0000000, writeEnable[14], 7'b0000000, writeEnable[13],
          7'b0000000, writeEnable[12], 7'b0000000, writeEnable[11], 7'b0000000, writeEnable[10],
          7'b0000000, writeEnable[9], 7'b0000000, writeEnable[8], 7'b0000000, writeEnable[7],
          7'b0000000, writeEnable[6], 7'b0000000, writeEnable[5], 7'b0000000, writeEnable[4],
          7'b0000000, writeEnable[3], 7'b0000000, writeEnable[2], 7'b0000000, writeEnable[1],
          7'b0000000, writeEnable[0]} << mux_address);
        new_data =  ( {7'b0000000, wordtemp[63], 7'b0000000, wordtemp[62], 7'b0000000, wordtemp[61],
          7'b0000000, wordtemp[60], 7'b0000000, wordtemp[59], 7'b0000000, wordtemp[58],
          7'b0000000, wordtemp[57], 7'b0000000, wordtemp[56], 7'b0000000, wordtemp[55],
          7'b0000000, wordtemp[54], 7'b0000000, wordtemp[53], 7'b0000000, wordtemp[52],
          7'b0000000, wordtemp[51], 7'b0000000, wordtemp[50], 7'b0000000, wordtemp[49],
          7'b0000000, wordtemp[48], 7'b0000000, wordtemp[47], 7'b0000000, wordtemp[46],
          7'b0000000, wordtemp[45], 7'b0000000, wordtemp[44], 7'b0000000, wordtemp[43],
          7'b0000000, wordtemp[42], 7'b0000000, wordtemp[41], 7'b0000000, wordtemp[40],
          7'b0000000, wordtemp[39], 7'b0000000, wordtemp[38], 7'b0000000, wordtemp[37],
          7'b0000000, wordtemp[36], 7'b0000000, wordtemp[35], 7'b0000000, wordtemp[34],
          7'b0000000, wordtemp[33], 7'b0000000, wordtemp[32], 7'b0000000, wordtemp[31],
          7'b0000000, wordtemp[30], 7'b0000000, wordtemp[29], 7'b0000000, wordtemp[28],
          7'b0000000, wordtemp[27], 7'b0000000, wordtemp[26], 7'b0000000, wordtemp[25],
          7'b0000000, wordtemp[24], 7'b0000000, wordtemp[23], 7'b0000000, wordtemp[22],
          7'b0000000, wordtemp[21], 7'b0000000, wordtemp[20], 7'b0000000, wordtemp[19],
          7'b0000000, wordtemp[18], 7'b0000000, wordtemp[17], 7'b0000000, wordtemp[16],
          7'b0000000, wordtemp[15], 7'b0000000, wordtemp[14], 7'b0000000, wordtemp[13],
          7'b0000000, wordtemp[12], 7'b0000000, wordtemp[11], 7'b0000000, wordtemp[10],
          7'b0000000, wordtemp[9], 7'b0000000, wordtemp[8], 7'b0000000, wordtemp[7],
          7'b0000000, wordtemp[6], 7'b0000000, wordtemp[5], 7'b0000000, wordtemp[4],
          7'b0000000, wordtemp[3], 7'b0000000, wordtemp[2], 7'b0000000, wordtemp[1],
          7'b0000000, wordtemp[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
  	end
  end
  endtask

task dumpaddr;
	output [63:0] dump_data;
	input [9:0] dump_addr;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
     if (CEN_ === 1'b1) begin
	  Atemp = dump_addr;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[504], data_out[496], data_out[488], data_out[480], data_out[472],
          data_out[464], data_out[456], data_out[448], data_out[440], data_out[432],
          data_out[424], data_out[416], data_out[408], data_out[400], data_out[392],
          data_out[384], data_out[376], data_out[368], data_out[360], data_out[352],
          data_out[344], data_out[336], data_out[328], data_out[320], data_out[312],
          data_out[304], data_out[296], data_out[288], data_out[280], data_out[272],
          data_out[264], data_out[256], data_out[248], data_out[240], data_out[232],
          data_out[224], data_out[216], data_out[208], data_out[200], data_out[192],
          data_out[184], data_out[176], data_out[168], data_out[160], data_out[152],
          data_out[144], data_out[136], data_out[128], data_out[120], data_out[112],
          data_out[104], data_out[96], data_out[88], data_out[80], data_out[72], data_out[64],
          data_out[56], data_out[48], data_out[40], data_out[32], data_out[24], data_out[16],
          data_out[8], data_out[0]};
        shifted_readLatch0 = readLatch0;
        mem_path_d = {shifted_readLatch0[63], shifted_readLatch0[62], shifted_readLatch0[61],
          shifted_readLatch0[60], shifted_readLatch0[59], shifted_readLatch0[58], shifted_readLatch0[57],
          shifted_readLatch0[56], shifted_readLatch0[55], shifted_readLatch0[54], shifted_readLatch0[53],
          shifted_readLatch0[52], shifted_readLatch0[51], shifted_readLatch0[50], shifted_readLatch0[49],
          shifted_readLatch0[48], shifted_readLatch0[47], shifted_readLatch0[46], shifted_readLatch0[45],
          shifted_readLatch0[44], shifted_readLatch0[43], shifted_readLatch0[42], shifted_readLatch0[41],
          shifted_readLatch0[40], shifted_readLatch0[39], shifted_readLatch0[38], shifted_readLatch0[37],
          shifted_readLatch0[36], shifted_readLatch0[35], shifted_readLatch0[34], shifted_readLatch0[33],
          shifted_readLatch0[32], shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
   	dump_data = mem_path_d;
  	end
  end
  endtask


  task readWrite;
  begin
    if (RET1N_int === 1'bx || RET1N_int === 1'bz) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (RET1N_int === 1'b0 && CEN_int === 1'b0) begin
    end else if (RET1N_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{(EMA_int), (EMAW_int), (EMAS_int)} === 1'bx) begin
  if(isBitX(EMAS_int)) begin 
        XQ = 1'b1; Q_update = 1'b1;
  end
  if(isBitX(EMAW_int)) begin 
      failedWrite(0);
  end
  if(isBitX(EMA_int)) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
  end
    end else if (^{CEN_int, (STOV_int && !CEN_int), RET1N_int} === 1'bx) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
        XQ = GWEN_int !== 1'b1 ? 1'b0 : 1'b1; Q_update = GWEN_int !== 1'b1 ? 1'b0 : 1'b1;
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      if (GWEN_int !== 1'b1)
        failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (CEN_int === 1'b0) begin
      mux_address = (A_int & 3'b111);
      row_address = (A_int >> 3);
      if (row_address > 127)
        row = {512{1'bx}};
      else
        row = mem[row_address];
        writeEnable = ~ {64{GWEN_int}};
      if (GWEN_int !== 1'b1) begin
        row_mask =  ( {7'b0000000, writeEnable[63], 7'b0000000, writeEnable[62], 7'b0000000, writeEnable[61],
          7'b0000000, writeEnable[60], 7'b0000000, writeEnable[59], 7'b0000000, writeEnable[58],
          7'b0000000, writeEnable[57], 7'b0000000, writeEnable[56], 7'b0000000, writeEnable[55],
          7'b0000000, writeEnable[54], 7'b0000000, writeEnable[53], 7'b0000000, writeEnable[52],
          7'b0000000, writeEnable[51], 7'b0000000, writeEnable[50], 7'b0000000, writeEnable[49],
          7'b0000000, writeEnable[48], 7'b0000000, writeEnable[47], 7'b0000000, writeEnable[46],
          7'b0000000, writeEnable[45], 7'b0000000, writeEnable[44], 7'b0000000, writeEnable[43],
          7'b0000000, writeEnable[42], 7'b0000000, writeEnable[41], 7'b0000000, writeEnable[40],
          7'b0000000, writeEnable[39], 7'b0000000, writeEnable[38], 7'b0000000, writeEnable[37],
          7'b0000000, writeEnable[36], 7'b0000000, writeEnable[35], 7'b0000000, writeEnable[34],
          7'b0000000, writeEnable[33], 7'b0000000, writeEnable[32], 7'b0000000, writeEnable[31],
          7'b0000000, writeEnable[30], 7'b0000000, writeEnable[29], 7'b0000000, writeEnable[28],
          7'b0000000, writeEnable[27], 7'b0000000, writeEnable[26], 7'b0000000, writeEnable[25],
          7'b0000000, writeEnable[24], 7'b0000000, writeEnable[23], 7'b0000000, writeEnable[22],
          7'b0000000, writeEnable[21], 7'b0000000, writeEnable[20], 7'b0000000, writeEnable[19],
          7'b0000000, writeEnable[18], 7'b0000000, writeEnable[17], 7'b0000000, writeEnable[16],
          7'b0000000, writeEnable[15], 7'b0000000, writeEnable[14], 7'b0000000, writeEnable[13],
          7'b0000000, writeEnable[12], 7'b0000000, writeEnable[11], 7'b0000000, writeEnable[10],
          7'b0000000, writeEnable[9], 7'b0000000, writeEnable[8], 7'b0000000, writeEnable[7],
          7'b0000000, writeEnable[6], 7'b0000000, writeEnable[5], 7'b0000000, writeEnable[4],
          7'b0000000, writeEnable[3], 7'b0000000, writeEnable[2], 7'b0000000, writeEnable[1],
          7'b0000000, writeEnable[0]} << mux_address);
        new_data =  ( {7'b0000000, D_int[63], 7'b0000000, D_int[62], 7'b0000000, D_int[61],
          7'b0000000, D_int[60], 7'b0000000, D_int[59], 7'b0000000, D_int[58], 7'b0000000, D_int[57],
          7'b0000000, D_int[56], 7'b0000000, D_int[55], 7'b0000000, D_int[54], 7'b0000000, D_int[53],
          7'b0000000, D_int[52], 7'b0000000, D_int[51], 7'b0000000, D_int[50], 7'b0000000, D_int[49],
          7'b0000000, D_int[48], 7'b0000000, D_int[47], 7'b0000000, D_int[46], 7'b0000000, D_int[45],
          7'b0000000, D_int[44], 7'b0000000, D_int[43], 7'b0000000, D_int[42], 7'b0000000, D_int[41],
          7'b0000000, D_int[40], 7'b0000000, D_int[39], 7'b0000000, D_int[38], 7'b0000000, D_int[37],
          7'b0000000, D_int[36], 7'b0000000, D_int[35], 7'b0000000, D_int[34], 7'b0000000, D_int[33],
          7'b0000000, D_int[32], 7'b0000000, D_int[31], 7'b0000000, D_int[30], 7'b0000000, D_int[29],
          7'b0000000, D_int[28], 7'b0000000, D_int[27], 7'b0000000, D_int[26], 7'b0000000, D_int[25],
          7'b0000000, D_int[24], 7'b0000000, D_int[23], 7'b0000000, D_int[22], 7'b0000000, D_int[21],
          7'b0000000, D_int[20], 7'b0000000, D_int[19], 7'b0000000, D_int[18], 7'b0000000, D_int[17],
          7'b0000000, D_int[16], 7'b0000000, D_int[15], 7'b0000000, D_int[14], 7'b0000000, D_int[13],
          7'b0000000, D_int[12], 7'b0000000, D_int[11], 7'b0000000, D_int[10], 7'b0000000, D_int[9],
          7'b0000000, D_int[8], 7'b0000000, D_int[7], 7'b0000000, D_int[6], 7'b0000000, D_int[5],
          7'b0000000, D_int[4], 7'b0000000, D_int[3], 7'b0000000, D_int[2], 7'b0000000, D_int[1],
          7'b0000000, D_int[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
      end else begin
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[504], data_out[496], data_out[488], data_out[480], data_out[472],
          data_out[464], data_out[456], data_out[448], data_out[440], data_out[432],
          data_out[424], data_out[416], data_out[408], data_out[400], data_out[392],
          data_out[384], data_out[376], data_out[368], data_out[360], data_out[352],
          data_out[344], data_out[336], data_out[328], data_out[320], data_out[312],
          data_out[304], data_out[296], data_out[288], data_out[280], data_out[272],
          data_out[264], data_out[256], data_out[248], data_out[240], data_out[232],
          data_out[224], data_out[216], data_out[208], data_out[200], data_out[192],
          data_out[184], data_out[176], data_out[168], data_out[160], data_out[152],
          data_out[144], data_out[136], data_out[128], data_out[120], data_out[112],
          data_out[104], data_out[96], data_out[88], data_out[80], data_out[72], data_out[64],
          data_out[56], data_out[48], data_out[40], data_out[32], data_out[24], data_out[16],
          data_out[8], data_out[0]};
        shifted_readLatch0 = readLatch0;
        mem_path = {shifted_readLatch0[63], shifted_readLatch0[62], shifted_readLatch0[61],
          shifted_readLatch0[60], shifted_readLatch0[59], shifted_readLatch0[58], shifted_readLatch0[57],
          shifted_readLatch0[56], shifted_readLatch0[55], shifted_readLatch0[54], shifted_readLatch0[53],
          shifted_readLatch0[52], shifted_readLatch0[51], shifted_readLatch0[50], shifted_readLatch0[49],
          shifted_readLatch0[48], shifted_readLatch0[47], shifted_readLatch0[46], shifted_readLatch0[45],
          shifted_readLatch0[44], shifted_readLatch0[43], shifted_readLatch0[42], shifted_readLatch0[41],
          shifted_readLatch0[40], shifted_readLatch0[39], shifted_readLatch0[38], shifted_readLatch0[37],
          shifted_readLatch0[36], shifted_readLatch0[35], shifted_readLatch0[34], shifted_readLatch0[33],
          shifted_readLatch0[32], shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
        	XQ = 1'b0; Q_update = 1'b1;
      end
      if( isBitX(GWEN_int) )  begin
        XQ = 1'b1; Q_update = 1'b1;
      end
    end
  end
  endtask
  always @ (CEN_ or CLK_) begin
  	if(CLK_ == 1'b0) begin
  		CEN_p2 = CEN_;
  	end
  end

`ifdef POWER_PINS
  always @ (VDDCE) begin
      if (VDDCE != 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDCE should be powered down after VDDPE, Illegal power down sequencing in %m at %0t", $time);
       end
        $display("In PowerDown Mode in %m at %0t", $time);
        failedWrite(0);
      end
      if (VDDCE == 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDPE should be powered up after VDDCE in %m at %0t", $time);
        $display("Illegal power up sequencing in %m at %0t", $time);
       end
        failedWrite(0);
      end
  end
`endif
`ifdef POWER_PINS
  always @ (RET1N_ or VDDPE or VDDCE or VSSE) begin
`else     
  always @ RET1N_ begin
`endif
`ifdef POWER_PINS
    if (RET1N_ == 1'b1 && RET1N_int == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1 && pre_charge_st == 1'b1 && (CEN_ === 1'bx || CLK_ === 1'bx)) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end
`else     
`endif
`ifdef POWER_PINS
`else     
      pre_charge_st = 0;
`endif
    if (RET1N_ === 1'bx || RET1N_ === 1'bz) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (RET1N_ === 1'b0 && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (RET1N_ === 1'b1 && RET1N_int !== 1'bx && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end
`ifdef POWER_PINS
    if (RET1N_ == 1'b1 && VDDPE !== 1'b1) begin
        $display("Warning: Illegal value for VDDPE %b in %m at %0t", VDDPE, $time);
        failedWrite(0);
    end else if (RET1N_ == 1'b0 && VDDCE == 1'b1 && VDDPE == 1'b1) begin
      pre_charge_st = 1;
    end else if (RET1N_ == 1'b0 && VDDPE == 1'b0) begin
      pre_charge_st = 0;
      if (VDDCE != 1'b1) begin
        failedWrite(0);
      end
`else     
    if (RET1N_ == 1'b0) begin
`endif
        XQ = 1'b1; Q_update = 1'b1;
      Q_int_delayed = {64{1'bx}};
      CEN_int = 1'bx;
      GWEN_int = 1'bx;
      A_int = {10{1'bx}};
      D_int = {64{1'bx}};
      STOV_int = 1'bx;
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      EMAS_int = 1'bx;
      RET1N_int = 1'bx;
`ifdef POWER_PINS
    end else if (RET1N_ == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1) begin
      pre_charge_st = 0;
      XQ = 1'b0;
    end else begin
      pre_charge_st = 0;
`else     
    end else begin
`endif
				#0;
if ($realtime != 0)  XQ = 1'b1;
        Q_update = 1'b1;
      Q_int_delayed = {64{1'bx}};
      CEN_int = 1'bx;
      GWEN_int = 1'bx;
      A_int = {10{1'bx}};
      D_int = {64{1'bx}};
      STOV_int = 1'bx;
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      EMAS_int = 1'bx;
      RET1N_int = 1'bx;
    end
    #0;
    RET1N_int = RET1N_;
        Q_update = 1'b0;
  end


  always @ CLK_ begin
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
`endif
`ifdef POWER_PINS
  if (RET1N_ == 1'b0) begin
`else     
  if (RET1N_ == 1'b0) begin
`endif
      // no cycle in retention mode
`ifdef POWER_PINS
    end else if ((VDDCE === 1'bx || VDDCE === 1'bz)) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
  end else if (RET1N_ == 1'b1 && VDDPE !== 1'b1) begin
  end else if (VSSE !== 1'b0) begin
`endif
  end else begin
    if ((CLK_ === 1'bx || CLK_ === 1'bz) && RET1N_ !== 1'b0) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if ((CLK_ === 1'b1 || CLK_ === 1'b0) && LAST_CLK === 1'bx) begin
       D_sh_update = 1'b0;  XD_sh = 1'b0;
       XD_int = {64{1'b0}};
       XQ = 1'b0; Q_update = 1'b0; 
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      CEN_int = CEN_;
      STOV_int = STOV_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      EMAS_int = EMAS_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        GWEN_int = GWEN_;
        A_int = A_;
        D_int = D_;
      end
      clk0_int = 1'b0;
      CEN_int = CEN_;
      STOV_int = STOV_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      EMAS_int = EMAS_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        GWEN_int = GWEN_;
        A_int = A_;
        D_int = D_;
      end
      clk0_int = 1'b0;
      if (CEN_int === 1'b0 && GWEN_int === 1'b1) 
         Q_int_delayed = {64{1'bx}};
    readWrite;
    end else if (CLK_ === 1'b0 && LAST_CLK === 1'b1) begin
      Q_int_delayed = Q_int;
      Q_update = 1'b0;
      D_sh_update = 1'b0;
      XQ = 1'b0;
       XD_int = {64{1'b0}};
    end
  end
    LAST_CLK = CLK_;
  end

  assign D_int_bmux = D_;

  datapath_latch_tsmc16_1rw_1024_64b uDQ0 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(1'b0), .D(D_int_bmux[0]), .DFTRAMBYP(1'b0), .mem_path(mem_path[0]), .XQ(XQ|XD_int[0]|1'b0), .Q(Q_int[0]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ1 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[0]), .D(D_int_bmux[1]), .DFTRAMBYP(1'b0), .mem_path(mem_path[1]), .XQ(XQ|XD_int[1]), .Q(Q_int[1]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ2 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[1]), .D(D_int_bmux[2]), .DFTRAMBYP(1'b0), .mem_path(mem_path[2]), .XQ(XQ|XD_int[2]), .Q(Q_int[2]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ3 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[2]), .D(D_int_bmux[3]), .DFTRAMBYP(1'b0), .mem_path(mem_path[3]), .XQ(XQ|XD_int[3]), .Q(Q_int[3]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ4 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[3]), .D(D_int_bmux[4]), .DFTRAMBYP(1'b0), .mem_path(mem_path[4]), .XQ(XQ|XD_int[4]), .Q(Q_int[4]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ5 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[4]), .D(D_int_bmux[5]), .DFTRAMBYP(1'b0), .mem_path(mem_path[5]), .XQ(XQ|XD_int[5]), .Q(Q_int[5]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ6 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[5]), .D(D_int_bmux[6]), .DFTRAMBYP(1'b0), .mem_path(mem_path[6]), .XQ(XQ|XD_int[6]), .Q(Q_int[6]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ7 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[6]), .D(D_int_bmux[7]), .DFTRAMBYP(1'b0), .mem_path(mem_path[7]), .XQ(XQ|XD_int[7]), .Q(Q_int[7]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ8 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[7]), .D(D_int_bmux[8]), .DFTRAMBYP(1'b0), .mem_path(mem_path[8]), .XQ(XQ|XD_int[8]), .Q(Q_int[8]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ9 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[8]), .D(D_int_bmux[9]), .DFTRAMBYP(1'b0), .mem_path(mem_path[9]), .XQ(XQ|XD_int[9]), .Q(Q_int[9]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ10 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[9]), .D(D_int_bmux[10]), .DFTRAMBYP(1'b0), .mem_path(mem_path[10]), .XQ(XQ|XD_int[10]), .Q(Q_int[10]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ11 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[10]), .D(D_int_bmux[11]), .DFTRAMBYP(1'b0), .mem_path(mem_path[11]), .XQ(XQ|XD_int[11]), .Q(Q_int[11]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ12 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[11]), .D(D_int_bmux[12]), .DFTRAMBYP(1'b0), .mem_path(mem_path[12]), .XQ(XQ|XD_int[12]), .Q(Q_int[12]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ13 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[12]), .D(D_int_bmux[13]), .DFTRAMBYP(1'b0), .mem_path(mem_path[13]), .XQ(XQ|XD_int[13]), .Q(Q_int[13]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ14 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[13]), .D(D_int_bmux[14]), .DFTRAMBYP(1'b0), .mem_path(mem_path[14]), .XQ(XQ|XD_int[14]), .Q(Q_int[14]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ15 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[14]), .D(D_int_bmux[15]), .DFTRAMBYP(1'b0), .mem_path(mem_path[15]), .XQ(XQ|XD_int[15]), .Q(Q_int[15]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ16 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[15]), .D(D_int_bmux[16]), .DFTRAMBYP(1'b0), .mem_path(mem_path[16]), .XQ(XQ|XD_int[16]), .Q(Q_int[16]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ17 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[16]), .D(D_int_bmux[17]), .DFTRAMBYP(1'b0), .mem_path(mem_path[17]), .XQ(XQ|XD_int[17]), .Q(Q_int[17]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ18 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[17]), .D(D_int_bmux[18]), .DFTRAMBYP(1'b0), .mem_path(mem_path[18]), .XQ(XQ|XD_int[18]), .Q(Q_int[18]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ19 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[18]), .D(D_int_bmux[19]), .DFTRAMBYP(1'b0), .mem_path(mem_path[19]), .XQ(XQ|XD_int[19]), .Q(Q_int[19]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ20 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[19]), .D(D_int_bmux[20]), .DFTRAMBYP(1'b0), .mem_path(mem_path[20]), .XQ(XQ|XD_int[20]), .Q(Q_int[20]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ21 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[20]), .D(D_int_bmux[21]), .DFTRAMBYP(1'b0), .mem_path(mem_path[21]), .XQ(XQ|XD_int[21]), .Q(Q_int[21]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ22 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[21]), .D(D_int_bmux[22]), .DFTRAMBYP(1'b0), .mem_path(mem_path[22]), .XQ(XQ|XD_int[22]), .Q(Q_int[22]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ23 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[22]), .D(D_int_bmux[23]), .DFTRAMBYP(1'b0), .mem_path(mem_path[23]), .XQ(XQ|XD_int[23]), .Q(Q_int[23]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ24 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[23]), .D(D_int_bmux[24]), .DFTRAMBYP(1'b0), .mem_path(mem_path[24]), .XQ(XQ|XD_int[24]), .Q(Q_int[24]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ25 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[24]), .D(D_int_bmux[25]), .DFTRAMBYP(1'b0), .mem_path(mem_path[25]), .XQ(XQ|XD_int[25]), .Q(Q_int[25]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ26 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[25]), .D(D_int_bmux[26]), .DFTRAMBYP(1'b0), .mem_path(mem_path[26]), .XQ(XQ|XD_int[26]), .Q(Q_int[26]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ27 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[26]), .D(D_int_bmux[27]), .DFTRAMBYP(1'b0), .mem_path(mem_path[27]), .XQ(XQ|XD_int[27]), .Q(Q_int[27]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ28 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[27]), .D(D_int_bmux[28]), .DFTRAMBYP(1'b0), .mem_path(mem_path[28]), .XQ(XQ|XD_int[28]), .Q(Q_int[28]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ29 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[28]), .D(D_int_bmux[29]), .DFTRAMBYP(1'b0), .mem_path(mem_path[29]), .XQ(XQ|XD_int[29]), .Q(Q_int[29]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ30 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[29]), .D(D_int_bmux[30]), .DFTRAMBYP(1'b0), .mem_path(mem_path[30]), .XQ(XQ|XD_int[30]), .Q(Q_int[30]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ31 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[30]), .D(D_int_bmux[31]), .DFTRAMBYP(1'b0), .mem_path(mem_path[31]), .XQ(XQ|XD_int[31]), .Q(Q_int[31]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ32 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[33]), .D(D_int_bmux[32]), .DFTRAMBYP(1'b0), .mem_path(mem_path[32]), .XQ(XQ|XD_int[32]), .Q(Q_int[32]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ33 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[34]), .D(D_int_bmux[33]), .DFTRAMBYP(1'b0), .mem_path(mem_path[33]), .XQ(XQ|XD_int[33]), .Q(Q_int[33]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ34 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[35]), .D(D_int_bmux[34]), .DFTRAMBYP(1'b0), .mem_path(mem_path[34]), .XQ(XQ|XD_int[34]), .Q(Q_int[34]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ35 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[36]), .D(D_int_bmux[35]), .DFTRAMBYP(1'b0), .mem_path(mem_path[35]), .XQ(XQ|XD_int[35]), .Q(Q_int[35]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ36 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[37]), .D(D_int_bmux[36]), .DFTRAMBYP(1'b0), .mem_path(mem_path[36]), .XQ(XQ|XD_int[36]), .Q(Q_int[36]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ37 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[38]), .D(D_int_bmux[37]), .DFTRAMBYP(1'b0), .mem_path(mem_path[37]), .XQ(XQ|XD_int[37]), .Q(Q_int[37]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ38 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[39]), .D(D_int_bmux[38]), .DFTRAMBYP(1'b0), .mem_path(mem_path[38]), .XQ(XQ|XD_int[38]), .Q(Q_int[38]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ39 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[40]), .D(D_int_bmux[39]), .DFTRAMBYP(1'b0), .mem_path(mem_path[39]), .XQ(XQ|XD_int[39]), .Q(Q_int[39]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ40 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[41]), .D(D_int_bmux[40]), .DFTRAMBYP(1'b0), .mem_path(mem_path[40]), .XQ(XQ|XD_int[40]), .Q(Q_int[40]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ41 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[42]), .D(D_int_bmux[41]), .DFTRAMBYP(1'b0), .mem_path(mem_path[41]), .XQ(XQ|XD_int[41]), .Q(Q_int[41]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ42 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[43]), .D(D_int_bmux[42]), .DFTRAMBYP(1'b0), .mem_path(mem_path[42]), .XQ(XQ|XD_int[42]), .Q(Q_int[42]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ43 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[44]), .D(D_int_bmux[43]), .DFTRAMBYP(1'b0), .mem_path(mem_path[43]), .XQ(XQ|XD_int[43]), .Q(Q_int[43]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ44 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[45]), .D(D_int_bmux[44]), .DFTRAMBYP(1'b0), .mem_path(mem_path[44]), .XQ(XQ|XD_int[44]), .Q(Q_int[44]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ45 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[46]), .D(D_int_bmux[45]), .DFTRAMBYP(1'b0), .mem_path(mem_path[45]), .XQ(XQ|XD_int[45]), .Q(Q_int[45]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ46 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[47]), .D(D_int_bmux[46]), .DFTRAMBYP(1'b0), .mem_path(mem_path[46]), .XQ(XQ|XD_int[46]), .Q(Q_int[46]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ47 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[48]), .D(D_int_bmux[47]), .DFTRAMBYP(1'b0), .mem_path(mem_path[47]), .XQ(XQ|XD_int[47]), .Q(Q_int[47]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ48 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[49]), .D(D_int_bmux[48]), .DFTRAMBYP(1'b0), .mem_path(mem_path[48]), .XQ(XQ|XD_int[48]), .Q(Q_int[48]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ49 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[50]), .D(D_int_bmux[49]), .DFTRAMBYP(1'b0), .mem_path(mem_path[49]), .XQ(XQ|XD_int[49]), .Q(Q_int[49]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ50 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[51]), .D(D_int_bmux[50]), .DFTRAMBYP(1'b0), .mem_path(mem_path[50]), .XQ(XQ|XD_int[50]), .Q(Q_int[50]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ51 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[52]), .D(D_int_bmux[51]), .DFTRAMBYP(1'b0), .mem_path(mem_path[51]), .XQ(XQ|XD_int[51]), .Q(Q_int[51]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ52 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[53]), .D(D_int_bmux[52]), .DFTRAMBYP(1'b0), .mem_path(mem_path[52]), .XQ(XQ|XD_int[52]), .Q(Q_int[52]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ53 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[54]), .D(D_int_bmux[53]), .DFTRAMBYP(1'b0), .mem_path(mem_path[53]), .XQ(XQ|XD_int[53]), .Q(Q_int[53]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ54 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[55]), .D(D_int_bmux[54]), .DFTRAMBYP(1'b0), .mem_path(mem_path[54]), .XQ(XQ|XD_int[54]), .Q(Q_int[54]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ55 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[56]), .D(D_int_bmux[55]), .DFTRAMBYP(1'b0), .mem_path(mem_path[55]), .XQ(XQ|XD_int[55]), .Q(Q_int[55]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ56 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[57]), .D(D_int_bmux[56]), .DFTRAMBYP(1'b0), .mem_path(mem_path[56]), .XQ(XQ|XD_int[56]), .Q(Q_int[56]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ57 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[58]), .D(D_int_bmux[57]), .DFTRAMBYP(1'b0), .mem_path(mem_path[57]), .XQ(XQ|XD_int[57]), .Q(Q_int[57]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ58 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[59]), .D(D_int_bmux[58]), .DFTRAMBYP(1'b0), .mem_path(mem_path[58]), .XQ(XQ|XD_int[58]), .Q(Q_int[58]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ59 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[60]), .D(D_int_bmux[59]), .DFTRAMBYP(1'b0), .mem_path(mem_path[59]), .XQ(XQ|XD_int[59]), .Q(Q_int[59]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ60 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[61]), .D(D_int_bmux[60]), .DFTRAMBYP(1'b0), .mem_path(mem_path[60]), .XQ(XQ|XD_int[60]), .Q(Q_int[60]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ61 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[62]), .D(D_int_bmux[61]), .DFTRAMBYP(1'b0), .mem_path(mem_path[61]), .XQ(XQ|XD_int[61]), .Q(Q_int[61]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ62 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[63]), .D(D_int_bmux[62]), .DFTRAMBYP(1'b0), .mem_path(mem_path[62]), .XQ(XQ|XD_int[62]), .Q(Q_int[62]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ63 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(1'b0), .D(D_int_bmux[63]), .DFTRAMBYP(1'b0), .mem_path(mem_path[63]), .XQ(XQ|XD_int[63]|1'b0), .Q(Q_int[63]));


// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
	always @ (VDDCE or VDDPE or VSSE) begin
		if (VDDCE === 1'bx || VDDCE === 1'bz) begin
			$display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
        XQ = 1'b1; Q_update = 1'b1;
			failedWrite(0);
			bad_VDDCE = 1'b1;
		end else begin
			bad_VDDCE = 1'b0;
		end
		if (RET1N_ == 1'b1 && VDDPE !== 1'b1) begin
			$display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
        XQ = 1'b1; Q_update = 1'b1;
			failedWrite(0);
			bad_VDDPE = 1'b1;
		end else begin
			bad_VDDPE = 1'b0;
		end
		if (VSSE !== 1'b0) begin
			$display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
        XQ = 1'b1; Q_update = 1'b1;
			failedWrite(0);
			bad_VSSE = 1'b1;
		end else begin
			bad_VSSE = 1'b0;
		end
		bad_power = bad_VDDCE | bad_VDDPE | bad_VSSE ;
	end
`endif

endmodule
`endcelldefine
`else
// If ARM_NEG_MODEL is defined at Simulator Command Line, it Selects the NEGATIVE Model
`ifdef ARM_NEG_MODEL

`celldefine
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
module tsmc16_1rw_1024_64b (VDDCE, VDDPE, VSSE, Q, CLK, CEN, GWEN, A, D, STOV, EMA,
    EMAW, EMAS, RET1N);
`else
module tsmc16_1rw_1024_64b (Q, CLK, CEN, GWEN, A, D, STOV, EMA, EMAW, EMAS, RET1N);
`endif

  parameter ASSERT_PREFIX = "";
  parameter BITS = 64;
  parameter WORDS = 1024;
  parameter MUX = 8;
  parameter MEM_WIDTH = 512; // redun block size 8, 256 on left, 256 on right
  parameter MEM_HEIGHT = 128;
  parameter WP_SIZE = 64 ;
  parameter UPM_WIDTH = 3;
  parameter UPMW_WIDTH = 2;
  parameter UPMS_WIDTH = 1;
  parameter ROWS = 128;

  output [63:0] Q;
  input  CLK;
  input  CEN;
  input  GWEN;
  input [9:0] A;
  input [63:0] D;
  input  STOV;
  input [2:0] EMA;
  input [1:0] EMAW;
  input  EMAS;
  input  RET1N;
`ifdef POWER_PINS
  inout VDDCE;
  inout VDDPE;
  inout VSSE;
`endif

`ifdef POWER_PINS
  reg bad_VDDCE;
  reg bad_VDDPE;
  reg bad_VSSE;
  reg bad_power;
`endif
  wire corrupt_power;
  reg pre_charge_st;
  integer row_address;
  integer mux_address;
  initial row_address = 0;
  initial mux_address = 0;
  reg [511:0] mem [0:127];
  reg [511:0] row, row_t;
  reg LAST_CLK;
  reg [511:0] row_mask;
  reg [511:0] new_data;
  reg [511:0] data_out;
  reg [63:0] readLatch0;
  reg [63:0] shifted_readLatch0;
  wire [63:0] Q_int;
  reg [63:0] Q_int_delayed;
  reg XQ, Q_update;
  reg XD_sh, D_sh_update;
  wire [63:0] D_int_bmux;
  reg [63:0] mem_path;
  reg [63:0] mem_path_d;
  reg [63:0] writeEnable;

  reg NOT_CEN, NOT_GWEN, NOT_A9, NOT_A8, NOT_A7, NOT_A6, NOT_A5, NOT_A4, NOT_A3, NOT_A2;
  reg NOT_A1, NOT_A0, NOT_D63, NOT_D62, NOT_D61, NOT_D60, NOT_D59, NOT_D58, NOT_D57;
  reg NOT_D56, NOT_D55, NOT_D54, NOT_D53, NOT_D52, NOT_D51, NOT_D50, NOT_D49, NOT_D48;
  reg NOT_D47, NOT_D46, NOT_D45, NOT_D44, NOT_D43, NOT_D42, NOT_D41, NOT_D40, NOT_D39;
  reg NOT_D38, NOT_D37, NOT_D36, NOT_D35, NOT_D34, NOT_D33, NOT_D32, NOT_D31, NOT_D30;
  reg NOT_D29, NOT_D28, NOT_D27, NOT_D26, NOT_D25, NOT_D24, NOT_D23, NOT_D22, NOT_D21;
  reg NOT_D20, NOT_D19, NOT_D18, NOT_D17, NOT_D16, NOT_D15, NOT_D14, NOT_D13, NOT_D12;
  reg NOT_D11, NOT_D10, NOT_D9, NOT_D8, NOT_D7, NOT_D6, NOT_D5, NOT_D4, NOT_D3, NOT_D2;
  reg NOT_D1, NOT_D0, NOT_STOV, NOT_EMA2, NOT_EMA1, NOT_EMA0, NOT_EMAW1, NOT_EMAW0;
  reg NOT_EMAS, NOT_RET1N;
  reg NOT_CLK_PER, NOT_CLK_MINH, NOT_CLK_MINL;
  reg clk0_int;

  wire [63:0] Q_;
 wire  CLK_;
 wire  dCLK;
  wire  CEN_;
 wire  dCEN;
  reg  CEN_int;
  reg  CEN_p2;
  wire  GWEN_;
 wire  dGWEN;
  reg  GWEN_int;
  wire [9:0] A_;
 wire [9:0] dA;
  reg [9:0] A_int;
  wire [63:0] D_;
 wire [63:0] dD;
  reg [63:0] D_int;
  reg [63:0] XD_int;
  wire  STOV_;
 wire  dSTOV;
  reg  STOV_int;
  wire [2:0] EMA_;
 wire [2:0] dEMA;
  reg [2:0] EMA_int;
  wire [1:0] EMAW_;
 wire [1:0] dEMAW;
  reg [1:0] EMAW_int;
  wire  EMAS_;
 wire  dEMAS;
  reg  EMAS_int;
  wire  RET1N_;
 wire  dRET1N;
  reg  RET1N_int;

  buf B0(Q[0], Q_[0]);
  buf B1(Q[1], Q_[1]);
  buf B2(Q[2], Q_[2]);
  buf B3(Q[3], Q_[3]);
  buf B4(Q[4], Q_[4]);
  buf B5(Q[5], Q_[5]);
  buf B6(Q[6], Q_[6]);
  buf B7(Q[7], Q_[7]);
  buf B8(Q[8], Q_[8]);
  buf B9(Q[9], Q_[9]);
  buf B10(Q[10], Q_[10]);
  buf B11(Q[11], Q_[11]);
  buf B12(Q[12], Q_[12]);
  buf B13(Q[13], Q_[13]);
  buf B14(Q[14], Q_[14]);
  buf B15(Q[15], Q_[15]);
  buf B16(Q[16], Q_[16]);
  buf B17(Q[17], Q_[17]);
  buf B18(Q[18], Q_[18]);
  buf B19(Q[19], Q_[19]);
  buf B20(Q[20], Q_[20]);
  buf B21(Q[21], Q_[21]);
  buf B22(Q[22], Q_[22]);
  buf B23(Q[23], Q_[23]);
  buf B24(Q[24], Q_[24]);
  buf B25(Q[25], Q_[25]);
  buf B26(Q[26], Q_[26]);
  buf B27(Q[27], Q_[27]);
  buf B28(Q[28], Q_[28]);
  buf B29(Q[29], Q_[29]);
  buf B30(Q[30], Q_[30]);
  buf B31(Q[31], Q_[31]);
  buf B32(Q[32], Q_[32]);
  buf B33(Q[33], Q_[33]);
  buf B34(Q[34], Q_[34]);
  buf B35(Q[35], Q_[35]);
  buf B36(Q[36], Q_[36]);
  buf B37(Q[37], Q_[37]);
  buf B38(Q[38], Q_[38]);
  buf B39(Q[39], Q_[39]);
  buf B40(Q[40], Q_[40]);
  buf B41(Q[41], Q_[41]);
  buf B42(Q[42], Q_[42]);
  buf B43(Q[43], Q_[43]);
  buf B44(Q[44], Q_[44]);
  buf B45(Q[45], Q_[45]);
  buf B46(Q[46], Q_[46]);
  buf B47(Q[47], Q_[47]);
  buf B48(Q[48], Q_[48]);
  buf B49(Q[49], Q_[49]);
  buf B50(Q[50], Q_[50]);
  buf B51(Q[51], Q_[51]);
  buf B52(Q[52], Q_[52]);
  buf B53(Q[53], Q_[53]);
  buf B54(Q[54], Q_[54]);
  buf B55(Q[55], Q_[55]);
  buf B56(Q[56], Q_[56]);
  buf B57(Q[57], Q_[57]);
  buf B58(Q[58], Q_[58]);
  buf B59(Q[59], Q_[59]);
  buf B60(Q[60], Q_[60]);
  buf B61(Q[61], Q_[61]);
  buf B62(Q[62], Q_[62]);
  buf B63(Q[63], Q_[63]);
  buf B64(CLK_, dCLK);
  buf B65(CEN_, dCEN);
  buf B66(GWEN_, dGWEN);
  buf B67(A_[0],dA[0]);
  buf B68(A_[1],dA[1]);
  buf B69(A_[2],dA[2]);
  buf B70(A_[3],dA[3]);
  buf B71(A_[4],dA[4]);
  buf B72(A_[5],dA[5]);
  buf B73(A_[6],dA[6]);
  buf B74(A_[7],dA[7]);
  buf B75(A_[8],dA[8]);
  buf B76(A_[9],dA[9]);
  buf B77(D_[0],dD[0]);
  buf B78(D_[1],dD[1]);
  buf B79(D_[2],dD[2]);
  buf B80(D_[3],dD[3]);
  buf B81(D_[4],dD[4]);
  buf B82(D_[5],dD[5]);
  buf B83(D_[6],dD[6]);
  buf B84(D_[7],dD[7]);
  buf B85(D_[8],dD[8]);
  buf B86(D_[9],dD[9]);
  buf B87(D_[10],dD[10]);
  buf B88(D_[11],dD[11]);
  buf B89(D_[12],dD[12]);
  buf B90(D_[13],dD[13]);
  buf B91(D_[14],dD[14]);
  buf B92(D_[15],dD[15]);
  buf B93(D_[16],dD[16]);
  buf B94(D_[17],dD[17]);
  buf B95(D_[18],dD[18]);
  buf B96(D_[19],dD[19]);
  buf B97(D_[20],dD[20]);
  buf B98(D_[21],dD[21]);
  buf B99(D_[22],dD[22]);
  buf B100(D_[23],dD[23]);
  buf B101(D_[24],dD[24]);
  buf B102(D_[25],dD[25]);
  buf B103(D_[26],dD[26]);
  buf B104(D_[27],dD[27]);
  buf B105(D_[28],dD[28]);
  buf B106(D_[29],dD[29]);
  buf B107(D_[30],dD[30]);
  buf B108(D_[31],dD[31]);
  buf B109(D_[32],dD[32]);
  buf B110(D_[33],dD[33]);
  buf B111(D_[34],dD[34]);
  buf B112(D_[35],dD[35]);
  buf B113(D_[36],dD[36]);
  buf B114(D_[37],dD[37]);
  buf B115(D_[38],dD[38]);
  buf B116(D_[39],dD[39]);
  buf B117(D_[40],dD[40]);
  buf B118(D_[41],dD[41]);
  buf B119(D_[42],dD[42]);
  buf B120(D_[43],dD[43]);
  buf B121(D_[44],dD[44]);
  buf B122(D_[45],dD[45]);
  buf B123(D_[46],dD[46]);
  buf B124(D_[47],dD[47]);
  buf B125(D_[48],dD[48]);
  buf B126(D_[49],dD[49]);
  buf B127(D_[50],dD[50]);
  buf B128(D_[51],dD[51]);
  buf B129(D_[52],dD[52]);
  buf B130(D_[53],dD[53]);
  buf B131(D_[54],dD[54]);
  buf B132(D_[55],dD[55]);
  buf B133(D_[56],dD[56]);
  buf B134(D_[57],dD[57]);
  buf B135(D_[58],dD[58]);
  buf B136(D_[59],dD[59]);
  buf B137(D_[60],dD[60]);
  buf B138(D_[61],dD[61]);
  buf B139(D_[62],dD[62]);
  buf B140(D_[63],dD[63]);
  buf B141(STOV_, dSTOV);
  buf B142(EMA_[0],dEMA[0]);
  buf B143(EMA_[1],dEMA[1]);
  buf B144(EMA_[2],dEMA[2]);
  buf B145(EMAW_[0],dEMAW[0]);
  buf B146(EMAW_[1],dEMAW[1]);
  buf B147(EMAS_, dEMAS);
  buf B148(RET1N_, dRET1N);

`ifdef POWER_PINS
  assign corrupt_power = bad_power;
`else
  assign corrupt_power = 1'b0;
`endif

  assign Q_ = (RET1N_ | pre_charge_st) & ~corrupt_power ? ((STOV_ ? (Q_int_delayed) : (Q_int))) : {64{1'bx}};

// If INITIALIZE_MEMORY is defined at Simulator Command Line, it Initializes the Memory with all ZEROS.
`ifdef INITIALIZE_MEMORY
  integer i;
  initial
  begin
    #0;
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
  end
`endif
  always @ (EMA_) begin
  	if(EMA_ < 2) 
   	$display("Warning: Set Value for EMA doesn't match Default value 2 in %m at %0t", $time);
  end
  always @ (EMAW_) begin
  	if(EMAW_ < 1) 
   	$display("Warning: Set Value for EMAW doesn't match Default value 1 in %m at %0t", $time);
  end
  always @ (EMAS_) begin
  	if(EMAS_ < 0) 
   	$display("Warning: Set Value for EMAS doesn't match Default value 0 in %m at %0t", $time);
  end
	always @ (STOV_) begin
		if(CLK_ == 1'b1) begin
			XQ = 1'b1; Q_update = 1'b1;
			#0; Q_update = 1'b0;
			XQ = 1'b0;
		end
	end

  task failedWrite;
  input port_f;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitval;
    begin
      isBitX = ( bitval===1'bx || bitval===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


task loadmem;
	input [1000*8-1:0] filename;
	reg [BITS-1:0] memld [0:WORDS-1];
	integer i;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
	$readmemb(filename, memld);
     if (CEN_ === 1'b1) begin
	  for (i=0;i<WORDS;i=i+1) begin
	  wordtemp = memld[i];
	  Atemp = i;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        row_mask =  ( {7'b0000000, writeEnable[63], 7'b0000000, writeEnable[62], 7'b0000000, writeEnable[61],
          7'b0000000, writeEnable[60], 7'b0000000, writeEnable[59], 7'b0000000, writeEnable[58],
          7'b0000000, writeEnable[57], 7'b0000000, writeEnable[56], 7'b0000000, writeEnable[55],
          7'b0000000, writeEnable[54], 7'b0000000, writeEnable[53], 7'b0000000, writeEnable[52],
          7'b0000000, writeEnable[51], 7'b0000000, writeEnable[50], 7'b0000000, writeEnable[49],
          7'b0000000, writeEnable[48], 7'b0000000, writeEnable[47], 7'b0000000, writeEnable[46],
          7'b0000000, writeEnable[45], 7'b0000000, writeEnable[44], 7'b0000000, writeEnable[43],
          7'b0000000, writeEnable[42], 7'b0000000, writeEnable[41], 7'b0000000, writeEnable[40],
          7'b0000000, writeEnable[39], 7'b0000000, writeEnable[38], 7'b0000000, writeEnable[37],
          7'b0000000, writeEnable[36], 7'b0000000, writeEnable[35], 7'b0000000, writeEnable[34],
          7'b0000000, writeEnable[33], 7'b0000000, writeEnable[32], 7'b0000000, writeEnable[31],
          7'b0000000, writeEnable[30], 7'b0000000, writeEnable[29], 7'b0000000, writeEnable[28],
          7'b0000000, writeEnable[27], 7'b0000000, writeEnable[26], 7'b0000000, writeEnable[25],
          7'b0000000, writeEnable[24], 7'b0000000, writeEnable[23], 7'b0000000, writeEnable[22],
          7'b0000000, writeEnable[21], 7'b0000000, writeEnable[20], 7'b0000000, writeEnable[19],
          7'b0000000, writeEnable[18], 7'b0000000, writeEnable[17], 7'b0000000, writeEnable[16],
          7'b0000000, writeEnable[15], 7'b0000000, writeEnable[14], 7'b0000000, writeEnable[13],
          7'b0000000, writeEnable[12], 7'b0000000, writeEnable[11], 7'b0000000, writeEnable[10],
          7'b0000000, writeEnable[9], 7'b0000000, writeEnable[8], 7'b0000000, writeEnable[7],
          7'b0000000, writeEnable[6], 7'b0000000, writeEnable[5], 7'b0000000, writeEnable[4],
          7'b0000000, writeEnable[3], 7'b0000000, writeEnable[2], 7'b0000000, writeEnable[1],
          7'b0000000, writeEnable[0]} << mux_address);
        new_data =  ( {7'b0000000, wordtemp[63], 7'b0000000, wordtemp[62], 7'b0000000, wordtemp[61],
          7'b0000000, wordtemp[60], 7'b0000000, wordtemp[59], 7'b0000000, wordtemp[58],
          7'b0000000, wordtemp[57], 7'b0000000, wordtemp[56], 7'b0000000, wordtemp[55],
          7'b0000000, wordtemp[54], 7'b0000000, wordtemp[53], 7'b0000000, wordtemp[52],
          7'b0000000, wordtemp[51], 7'b0000000, wordtemp[50], 7'b0000000, wordtemp[49],
          7'b0000000, wordtemp[48], 7'b0000000, wordtemp[47], 7'b0000000, wordtemp[46],
          7'b0000000, wordtemp[45], 7'b0000000, wordtemp[44], 7'b0000000, wordtemp[43],
          7'b0000000, wordtemp[42], 7'b0000000, wordtemp[41], 7'b0000000, wordtemp[40],
          7'b0000000, wordtemp[39], 7'b0000000, wordtemp[38], 7'b0000000, wordtemp[37],
          7'b0000000, wordtemp[36], 7'b0000000, wordtemp[35], 7'b0000000, wordtemp[34],
          7'b0000000, wordtemp[33], 7'b0000000, wordtemp[32], 7'b0000000, wordtemp[31],
          7'b0000000, wordtemp[30], 7'b0000000, wordtemp[29], 7'b0000000, wordtemp[28],
          7'b0000000, wordtemp[27], 7'b0000000, wordtemp[26], 7'b0000000, wordtemp[25],
          7'b0000000, wordtemp[24], 7'b0000000, wordtemp[23], 7'b0000000, wordtemp[22],
          7'b0000000, wordtemp[21], 7'b0000000, wordtemp[20], 7'b0000000, wordtemp[19],
          7'b0000000, wordtemp[18], 7'b0000000, wordtemp[17], 7'b0000000, wordtemp[16],
          7'b0000000, wordtemp[15], 7'b0000000, wordtemp[14], 7'b0000000, wordtemp[13],
          7'b0000000, wordtemp[12], 7'b0000000, wordtemp[11], 7'b0000000, wordtemp[10],
          7'b0000000, wordtemp[9], 7'b0000000, wordtemp[8], 7'b0000000, wordtemp[7],
          7'b0000000, wordtemp[6], 7'b0000000, wordtemp[5], 7'b0000000, wordtemp[4],
          7'b0000000, wordtemp[3], 7'b0000000, wordtemp[2], 7'b0000000, wordtemp[1],
          7'b0000000, wordtemp[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
  	end
    end
  end
  endtask

task dumpmem;
	input [1000*8-1:0] filename_dump;
	integer i, dump_file_desc;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
	dump_file_desc = $fopen(filename_dump);
     if (CEN_ === 1'b1) begin
	  for (i=0;i<WORDS;i=i+1) begin
	  Atemp = i;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[504], data_out[496], data_out[488], data_out[480], data_out[472],
          data_out[464], data_out[456], data_out[448], data_out[440], data_out[432],
          data_out[424], data_out[416], data_out[408], data_out[400], data_out[392],
          data_out[384], data_out[376], data_out[368], data_out[360], data_out[352],
          data_out[344], data_out[336], data_out[328], data_out[320], data_out[312],
          data_out[304], data_out[296], data_out[288], data_out[280], data_out[272],
          data_out[264], data_out[256], data_out[248], data_out[240], data_out[232],
          data_out[224], data_out[216], data_out[208], data_out[200], data_out[192],
          data_out[184], data_out[176], data_out[168], data_out[160], data_out[152],
          data_out[144], data_out[136], data_out[128], data_out[120], data_out[112],
          data_out[104], data_out[96], data_out[88], data_out[80], data_out[72], data_out[64],
          data_out[56], data_out[48], data_out[40], data_out[32], data_out[24], data_out[16],
          data_out[8], data_out[0]};
        shifted_readLatch0 = readLatch0;
        mem_path_d = {shifted_readLatch0[63], shifted_readLatch0[62], shifted_readLatch0[61],
          shifted_readLatch0[60], shifted_readLatch0[59], shifted_readLatch0[58], shifted_readLatch0[57],
          shifted_readLatch0[56], shifted_readLatch0[55], shifted_readLatch0[54], shifted_readLatch0[53],
          shifted_readLatch0[52], shifted_readLatch0[51], shifted_readLatch0[50], shifted_readLatch0[49],
          shifted_readLatch0[48], shifted_readLatch0[47], shifted_readLatch0[46], shifted_readLatch0[45],
          shifted_readLatch0[44], shifted_readLatch0[43], shifted_readLatch0[42], shifted_readLatch0[41],
          shifted_readLatch0[40], shifted_readLatch0[39], shifted_readLatch0[38], shifted_readLatch0[37],
          shifted_readLatch0[36], shifted_readLatch0[35], shifted_readLatch0[34], shifted_readLatch0[33],
          shifted_readLatch0[32], shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
   	$fdisplay(dump_file_desc, "%b", mem_path_d);
  end
  	end
    $fclose(dump_file_desc);
  end
  endtask

task loadaddr;
	input [9:0] load_addr;
	input [63:0] load_data;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
     if (CEN_ === 1'b1) begin
	  wordtemp = load_data;
	  Atemp = load_addr;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        row_mask =  ( {7'b0000000, writeEnable[63], 7'b0000000, writeEnable[62], 7'b0000000, writeEnable[61],
          7'b0000000, writeEnable[60], 7'b0000000, writeEnable[59], 7'b0000000, writeEnable[58],
          7'b0000000, writeEnable[57], 7'b0000000, writeEnable[56], 7'b0000000, writeEnable[55],
          7'b0000000, writeEnable[54], 7'b0000000, writeEnable[53], 7'b0000000, writeEnable[52],
          7'b0000000, writeEnable[51], 7'b0000000, writeEnable[50], 7'b0000000, writeEnable[49],
          7'b0000000, writeEnable[48], 7'b0000000, writeEnable[47], 7'b0000000, writeEnable[46],
          7'b0000000, writeEnable[45], 7'b0000000, writeEnable[44], 7'b0000000, writeEnable[43],
          7'b0000000, writeEnable[42], 7'b0000000, writeEnable[41], 7'b0000000, writeEnable[40],
          7'b0000000, writeEnable[39], 7'b0000000, writeEnable[38], 7'b0000000, writeEnable[37],
          7'b0000000, writeEnable[36], 7'b0000000, writeEnable[35], 7'b0000000, writeEnable[34],
          7'b0000000, writeEnable[33], 7'b0000000, writeEnable[32], 7'b0000000, writeEnable[31],
          7'b0000000, writeEnable[30], 7'b0000000, writeEnable[29], 7'b0000000, writeEnable[28],
          7'b0000000, writeEnable[27], 7'b0000000, writeEnable[26], 7'b0000000, writeEnable[25],
          7'b0000000, writeEnable[24], 7'b0000000, writeEnable[23], 7'b0000000, writeEnable[22],
          7'b0000000, writeEnable[21], 7'b0000000, writeEnable[20], 7'b0000000, writeEnable[19],
          7'b0000000, writeEnable[18], 7'b0000000, writeEnable[17], 7'b0000000, writeEnable[16],
          7'b0000000, writeEnable[15], 7'b0000000, writeEnable[14], 7'b0000000, writeEnable[13],
          7'b0000000, writeEnable[12], 7'b0000000, writeEnable[11], 7'b0000000, writeEnable[10],
          7'b0000000, writeEnable[9], 7'b0000000, writeEnable[8], 7'b0000000, writeEnable[7],
          7'b0000000, writeEnable[6], 7'b0000000, writeEnable[5], 7'b0000000, writeEnable[4],
          7'b0000000, writeEnable[3], 7'b0000000, writeEnable[2], 7'b0000000, writeEnable[1],
          7'b0000000, writeEnable[0]} << mux_address);
        new_data =  ( {7'b0000000, wordtemp[63], 7'b0000000, wordtemp[62], 7'b0000000, wordtemp[61],
          7'b0000000, wordtemp[60], 7'b0000000, wordtemp[59], 7'b0000000, wordtemp[58],
          7'b0000000, wordtemp[57], 7'b0000000, wordtemp[56], 7'b0000000, wordtemp[55],
          7'b0000000, wordtemp[54], 7'b0000000, wordtemp[53], 7'b0000000, wordtemp[52],
          7'b0000000, wordtemp[51], 7'b0000000, wordtemp[50], 7'b0000000, wordtemp[49],
          7'b0000000, wordtemp[48], 7'b0000000, wordtemp[47], 7'b0000000, wordtemp[46],
          7'b0000000, wordtemp[45], 7'b0000000, wordtemp[44], 7'b0000000, wordtemp[43],
          7'b0000000, wordtemp[42], 7'b0000000, wordtemp[41], 7'b0000000, wordtemp[40],
          7'b0000000, wordtemp[39], 7'b0000000, wordtemp[38], 7'b0000000, wordtemp[37],
          7'b0000000, wordtemp[36], 7'b0000000, wordtemp[35], 7'b0000000, wordtemp[34],
          7'b0000000, wordtemp[33], 7'b0000000, wordtemp[32], 7'b0000000, wordtemp[31],
          7'b0000000, wordtemp[30], 7'b0000000, wordtemp[29], 7'b0000000, wordtemp[28],
          7'b0000000, wordtemp[27], 7'b0000000, wordtemp[26], 7'b0000000, wordtemp[25],
          7'b0000000, wordtemp[24], 7'b0000000, wordtemp[23], 7'b0000000, wordtemp[22],
          7'b0000000, wordtemp[21], 7'b0000000, wordtemp[20], 7'b0000000, wordtemp[19],
          7'b0000000, wordtemp[18], 7'b0000000, wordtemp[17], 7'b0000000, wordtemp[16],
          7'b0000000, wordtemp[15], 7'b0000000, wordtemp[14], 7'b0000000, wordtemp[13],
          7'b0000000, wordtemp[12], 7'b0000000, wordtemp[11], 7'b0000000, wordtemp[10],
          7'b0000000, wordtemp[9], 7'b0000000, wordtemp[8], 7'b0000000, wordtemp[7],
          7'b0000000, wordtemp[6], 7'b0000000, wordtemp[5], 7'b0000000, wordtemp[4],
          7'b0000000, wordtemp[3], 7'b0000000, wordtemp[2], 7'b0000000, wordtemp[1],
          7'b0000000, wordtemp[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
  	end
  end
  endtask

task dumpaddr;
	output [63:0] dump_data;
	input [9:0] dump_addr;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
     if (CEN_ === 1'b1) begin
	  Atemp = dump_addr;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[504], data_out[496], data_out[488], data_out[480], data_out[472],
          data_out[464], data_out[456], data_out[448], data_out[440], data_out[432],
          data_out[424], data_out[416], data_out[408], data_out[400], data_out[392],
          data_out[384], data_out[376], data_out[368], data_out[360], data_out[352],
          data_out[344], data_out[336], data_out[328], data_out[320], data_out[312],
          data_out[304], data_out[296], data_out[288], data_out[280], data_out[272],
          data_out[264], data_out[256], data_out[248], data_out[240], data_out[232],
          data_out[224], data_out[216], data_out[208], data_out[200], data_out[192],
          data_out[184], data_out[176], data_out[168], data_out[160], data_out[152],
          data_out[144], data_out[136], data_out[128], data_out[120], data_out[112],
          data_out[104], data_out[96], data_out[88], data_out[80], data_out[72], data_out[64],
          data_out[56], data_out[48], data_out[40], data_out[32], data_out[24], data_out[16],
          data_out[8], data_out[0]};
        shifted_readLatch0 = readLatch0;
        mem_path_d = {shifted_readLatch0[63], shifted_readLatch0[62], shifted_readLatch0[61],
          shifted_readLatch0[60], shifted_readLatch0[59], shifted_readLatch0[58], shifted_readLatch0[57],
          shifted_readLatch0[56], shifted_readLatch0[55], shifted_readLatch0[54], shifted_readLatch0[53],
          shifted_readLatch0[52], shifted_readLatch0[51], shifted_readLatch0[50], shifted_readLatch0[49],
          shifted_readLatch0[48], shifted_readLatch0[47], shifted_readLatch0[46], shifted_readLatch0[45],
          shifted_readLatch0[44], shifted_readLatch0[43], shifted_readLatch0[42], shifted_readLatch0[41],
          shifted_readLatch0[40], shifted_readLatch0[39], shifted_readLatch0[38], shifted_readLatch0[37],
          shifted_readLatch0[36], shifted_readLatch0[35], shifted_readLatch0[34], shifted_readLatch0[33],
          shifted_readLatch0[32], shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
   	dump_data = mem_path_d;
  	end
  end
  endtask


  task readWrite;
  begin
    if (RET1N_int === 1'bx || RET1N_int === 1'bz) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (RET1N_int === 1'b0 && CEN_int === 1'b0) begin
    end else if (RET1N_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{(EMA_int), (EMAW_int), (EMAS_int)} === 1'bx) begin
  if(isBitX(EMAS_int)) begin 
        XQ = 1'b1; Q_update = 1'b1;
  end
  if(isBitX(EMAW_int)) begin 
      failedWrite(0);
  end
  if(isBitX(EMA_int)) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
  end
    end else if (^{CEN_int, (STOV_int && !CEN_int), RET1N_int} === 1'bx) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
        XQ = GWEN_int !== 1'b1 ? 1'b0 : 1'b1; Q_update = GWEN_int !== 1'b1 ? 1'b0 : 1'b1;
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      if (GWEN_int !== 1'b1)
        failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (CEN_int === 1'b0) begin
      mux_address = (A_int & 3'b111);
      row_address = (A_int >> 3);
      if (row_address > 127)
        row = {512{1'bx}};
      else
        row = mem[row_address];
        writeEnable = ~ {64{GWEN_int}};
      if (GWEN_int !== 1'b1) begin
        row_mask =  ( {7'b0000000, writeEnable[63], 7'b0000000, writeEnable[62], 7'b0000000, writeEnable[61],
          7'b0000000, writeEnable[60], 7'b0000000, writeEnable[59], 7'b0000000, writeEnable[58],
          7'b0000000, writeEnable[57], 7'b0000000, writeEnable[56], 7'b0000000, writeEnable[55],
          7'b0000000, writeEnable[54], 7'b0000000, writeEnable[53], 7'b0000000, writeEnable[52],
          7'b0000000, writeEnable[51], 7'b0000000, writeEnable[50], 7'b0000000, writeEnable[49],
          7'b0000000, writeEnable[48], 7'b0000000, writeEnable[47], 7'b0000000, writeEnable[46],
          7'b0000000, writeEnable[45], 7'b0000000, writeEnable[44], 7'b0000000, writeEnable[43],
          7'b0000000, writeEnable[42], 7'b0000000, writeEnable[41], 7'b0000000, writeEnable[40],
          7'b0000000, writeEnable[39], 7'b0000000, writeEnable[38], 7'b0000000, writeEnable[37],
          7'b0000000, writeEnable[36], 7'b0000000, writeEnable[35], 7'b0000000, writeEnable[34],
          7'b0000000, writeEnable[33], 7'b0000000, writeEnable[32], 7'b0000000, writeEnable[31],
          7'b0000000, writeEnable[30], 7'b0000000, writeEnable[29], 7'b0000000, writeEnable[28],
          7'b0000000, writeEnable[27], 7'b0000000, writeEnable[26], 7'b0000000, writeEnable[25],
          7'b0000000, writeEnable[24], 7'b0000000, writeEnable[23], 7'b0000000, writeEnable[22],
          7'b0000000, writeEnable[21], 7'b0000000, writeEnable[20], 7'b0000000, writeEnable[19],
          7'b0000000, writeEnable[18], 7'b0000000, writeEnable[17], 7'b0000000, writeEnable[16],
          7'b0000000, writeEnable[15], 7'b0000000, writeEnable[14], 7'b0000000, writeEnable[13],
          7'b0000000, writeEnable[12], 7'b0000000, writeEnable[11], 7'b0000000, writeEnable[10],
          7'b0000000, writeEnable[9], 7'b0000000, writeEnable[8], 7'b0000000, writeEnable[7],
          7'b0000000, writeEnable[6], 7'b0000000, writeEnable[5], 7'b0000000, writeEnable[4],
          7'b0000000, writeEnable[3], 7'b0000000, writeEnable[2], 7'b0000000, writeEnable[1],
          7'b0000000, writeEnable[0]} << mux_address);
        new_data =  ( {7'b0000000, D_int[63], 7'b0000000, D_int[62], 7'b0000000, D_int[61],
          7'b0000000, D_int[60], 7'b0000000, D_int[59], 7'b0000000, D_int[58], 7'b0000000, D_int[57],
          7'b0000000, D_int[56], 7'b0000000, D_int[55], 7'b0000000, D_int[54], 7'b0000000, D_int[53],
          7'b0000000, D_int[52], 7'b0000000, D_int[51], 7'b0000000, D_int[50], 7'b0000000, D_int[49],
          7'b0000000, D_int[48], 7'b0000000, D_int[47], 7'b0000000, D_int[46], 7'b0000000, D_int[45],
          7'b0000000, D_int[44], 7'b0000000, D_int[43], 7'b0000000, D_int[42], 7'b0000000, D_int[41],
          7'b0000000, D_int[40], 7'b0000000, D_int[39], 7'b0000000, D_int[38], 7'b0000000, D_int[37],
          7'b0000000, D_int[36], 7'b0000000, D_int[35], 7'b0000000, D_int[34], 7'b0000000, D_int[33],
          7'b0000000, D_int[32], 7'b0000000, D_int[31], 7'b0000000, D_int[30], 7'b0000000, D_int[29],
          7'b0000000, D_int[28], 7'b0000000, D_int[27], 7'b0000000, D_int[26], 7'b0000000, D_int[25],
          7'b0000000, D_int[24], 7'b0000000, D_int[23], 7'b0000000, D_int[22], 7'b0000000, D_int[21],
          7'b0000000, D_int[20], 7'b0000000, D_int[19], 7'b0000000, D_int[18], 7'b0000000, D_int[17],
          7'b0000000, D_int[16], 7'b0000000, D_int[15], 7'b0000000, D_int[14], 7'b0000000, D_int[13],
          7'b0000000, D_int[12], 7'b0000000, D_int[11], 7'b0000000, D_int[10], 7'b0000000, D_int[9],
          7'b0000000, D_int[8], 7'b0000000, D_int[7], 7'b0000000, D_int[6], 7'b0000000, D_int[5],
          7'b0000000, D_int[4], 7'b0000000, D_int[3], 7'b0000000, D_int[2], 7'b0000000, D_int[1],
          7'b0000000, D_int[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
      end else begin
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[504], data_out[496], data_out[488], data_out[480], data_out[472],
          data_out[464], data_out[456], data_out[448], data_out[440], data_out[432],
          data_out[424], data_out[416], data_out[408], data_out[400], data_out[392],
          data_out[384], data_out[376], data_out[368], data_out[360], data_out[352],
          data_out[344], data_out[336], data_out[328], data_out[320], data_out[312],
          data_out[304], data_out[296], data_out[288], data_out[280], data_out[272],
          data_out[264], data_out[256], data_out[248], data_out[240], data_out[232],
          data_out[224], data_out[216], data_out[208], data_out[200], data_out[192],
          data_out[184], data_out[176], data_out[168], data_out[160], data_out[152],
          data_out[144], data_out[136], data_out[128], data_out[120], data_out[112],
          data_out[104], data_out[96], data_out[88], data_out[80], data_out[72], data_out[64],
          data_out[56], data_out[48], data_out[40], data_out[32], data_out[24], data_out[16],
          data_out[8], data_out[0]};
        shifted_readLatch0 = readLatch0;
        mem_path = {shifted_readLatch0[63], shifted_readLatch0[62], shifted_readLatch0[61],
          shifted_readLatch0[60], shifted_readLatch0[59], shifted_readLatch0[58], shifted_readLatch0[57],
          shifted_readLatch0[56], shifted_readLatch0[55], shifted_readLatch0[54], shifted_readLatch0[53],
          shifted_readLatch0[52], shifted_readLatch0[51], shifted_readLatch0[50], shifted_readLatch0[49],
          shifted_readLatch0[48], shifted_readLatch0[47], shifted_readLatch0[46], shifted_readLatch0[45],
          shifted_readLatch0[44], shifted_readLatch0[43], shifted_readLatch0[42], shifted_readLatch0[41],
          shifted_readLatch0[40], shifted_readLatch0[39], shifted_readLatch0[38], shifted_readLatch0[37],
          shifted_readLatch0[36], shifted_readLatch0[35], shifted_readLatch0[34], shifted_readLatch0[33],
          shifted_readLatch0[32], shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
        	XQ = 1'b0; Q_update = 1'b1;
      end
      if( isBitX(GWEN_int) )  begin
        XQ = 1'b1; Q_update = 1'b1;
      end
    end
  end
  endtask
  always @ (CEN_ or CLK_) begin
  	if(CLK_ == 1'b0) begin
  		CEN_p2 = CEN_;
  	end
  end

`ifdef POWER_PINS
  always @ (VDDCE) begin
      if (VDDCE != 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDCE should be powered down after VDDPE, Illegal power down sequencing in %m at %0t", $time);
       end
        $display("In PowerDown Mode in %m at %0t", $time);
        failedWrite(0);
      end
      if (VDDCE == 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDPE should be powered up after VDDCE in %m at %0t", $time);
        $display("Illegal power up sequencing in %m at %0t", $time);
       end
        failedWrite(0);
      end
  end
`endif
`ifdef POWER_PINS
  always @ (RET1N_ or VDDPE or VDDCE or VSSE) begin
`else     
  always @ RET1N_ begin
`endif
`ifdef POWER_PINS
    if (RET1N_ == 1'b1 && RET1N_int == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1 && pre_charge_st == 1'b1 && (CEN_ === 1'bx || CLK_ === 1'bx)) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end
`else     
`endif
`ifdef POWER_PINS
`else     
      pre_charge_st = 0;
`endif
    if (RET1N_ === 1'bx || RET1N_ === 1'bz) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (RET1N_ === 1'b0 && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (RET1N_ === 1'b1 && RET1N_int !== 1'bx && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end
`ifdef POWER_PINS
    if (RET1N_ == 1'b1 && VDDPE !== 1'b1) begin
        $display("Warning: Illegal value for VDDPE %b in %m at %0t", VDDPE, $time);
        failedWrite(0);
    end else if (RET1N_ == 1'b0 && VDDCE == 1'b1 && VDDPE == 1'b1) begin
      pre_charge_st = 1;
    end else if (RET1N_ == 1'b0 && VDDPE == 1'b0) begin
      pre_charge_st = 0;
      if (VDDCE != 1'b1) begin
        failedWrite(0);
      end
`else     
    if (RET1N_ == 1'b0) begin
`endif
        XQ = 1'b1; Q_update = 1'b1;
      Q_int_delayed = {64{1'bx}};
      CEN_int = 1'bx;
      GWEN_int = 1'bx;
      A_int = {10{1'bx}};
      D_int = {64{1'bx}};
      STOV_int = 1'bx;
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      EMAS_int = 1'bx;
      RET1N_int = 1'bx;
`ifdef POWER_PINS
    end else if (RET1N_ == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1) begin
      pre_charge_st = 0;
      XQ = 1'b0;
    end else begin
      pre_charge_st = 0;
`else     
    end else begin
`endif
				#0;
if ($realtime != 0)  XQ = 1'b1;
        Q_update = 1'b1;
      Q_int_delayed = {64{1'bx}};
      CEN_int = 1'bx;
      GWEN_int = 1'bx;
      A_int = {10{1'bx}};
      D_int = {64{1'bx}};
      STOV_int = 1'bx;
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      EMAS_int = 1'bx;
      RET1N_int = 1'bx;
    end
    #0;
    RET1N_int = RET1N_;
        Q_update = 1'b0;
  end


  always @ CLK_ begin
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
`endif
`ifdef POWER_PINS
  if (RET1N_ == 1'b0) begin
`else     
  if (RET1N_ == 1'b0) begin
`endif
      // no cycle in retention mode
`ifdef POWER_PINS
    end else if ((VDDCE === 1'bx || VDDCE === 1'bz)) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
  end else if (RET1N_ == 1'b1 && VDDPE !== 1'b1) begin
  end else if (VSSE !== 1'b0) begin
`endif
  end else begin
    if ((CLK_ === 1'bx || CLK_ === 1'bz) && RET1N_ !== 1'b0) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if ((CLK_ === 1'b1 || CLK_ === 1'b0) && LAST_CLK === 1'bx) begin
       D_sh_update = 1'b0;  XD_sh = 1'b0;
       XD_int = {64{1'b0}};
       XQ = 1'b0; Q_update = 1'b0; 
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      CEN_int = CEN_;
      STOV_int = STOV_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      EMAS_int = EMAS_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        GWEN_int = GWEN_;
        A_int = A_;
        D_int = D_;
      end
      clk0_int = 1'b0;
      CEN_int = CEN_;
      STOV_int = STOV_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      EMAS_int = EMAS_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        GWEN_int = GWEN_;
        A_int = A_;
        D_int = D_;
      end
      clk0_int = 1'b0;
      if (CEN_int === 1'b0 && GWEN_int === 1'b1) 
         Q_int_delayed = {64{1'bx}};
    readWrite;
    end else if (CLK_ === 1'b0 && LAST_CLK === 1'b1) begin
      Q_int_delayed = Q_int;
      Q_update = 1'b0;
      D_sh_update = 1'b0;
      XQ = 1'b0;
       XD_int = {64{1'b0}};
    end
  end
    LAST_CLK = CLK_;
  end

  reg globalNotifier0;
  initial globalNotifier0 = 1'b0;

  always @ globalNotifier0 begin
    if ($realtime == 0) begin
    end else if (CEN_int === 1'bx || RET1N_int === 1'bx || (STOV_int && !CEN_int) === 1'bx || 
      clk0_int === 1'bx) begin
        XQ = 1'b1; Q_update = 1'b1;
    	 mem_path = {64{1'bx}};
      Q_int_delayed = {64{1'bx}};
      failedWrite(0);
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
        failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else begin
      #0;
      readWrite;
   end
      #0;
        XQ = 1'b0; Q_update = 1'b0;
    globalNotifier0 = 1'b0;
  end

  assign D_int_bmux = D_;

  datapath_latch_tsmc16_1rw_1024_64b uDQ0 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(1'b0), .D(D_int_bmux[0]), .DFTRAMBYP(1'b0), .mem_path(mem_path[0]), .XQ(XQ|XD_int[0]|1'b0), .Q(Q_int[0]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ1 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[0]), .D(D_int_bmux[1]), .DFTRAMBYP(1'b0), .mem_path(mem_path[1]), .XQ(XQ|XD_int[1]), .Q(Q_int[1]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ2 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[1]), .D(D_int_bmux[2]), .DFTRAMBYP(1'b0), .mem_path(mem_path[2]), .XQ(XQ|XD_int[2]), .Q(Q_int[2]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ3 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[2]), .D(D_int_bmux[3]), .DFTRAMBYP(1'b0), .mem_path(mem_path[3]), .XQ(XQ|XD_int[3]), .Q(Q_int[3]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ4 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[3]), .D(D_int_bmux[4]), .DFTRAMBYP(1'b0), .mem_path(mem_path[4]), .XQ(XQ|XD_int[4]), .Q(Q_int[4]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ5 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[4]), .D(D_int_bmux[5]), .DFTRAMBYP(1'b0), .mem_path(mem_path[5]), .XQ(XQ|XD_int[5]), .Q(Q_int[5]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ6 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[5]), .D(D_int_bmux[6]), .DFTRAMBYP(1'b0), .mem_path(mem_path[6]), .XQ(XQ|XD_int[6]), .Q(Q_int[6]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ7 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[6]), .D(D_int_bmux[7]), .DFTRAMBYP(1'b0), .mem_path(mem_path[7]), .XQ(XQ|XD_int[7]), .Q(Q_int[7]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ8 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[7]), .D(D_int_bmux[8]), .DFTRAMBYP(1'b0), .mem_path(mem_path[8]), .XQ(XQ|XD_int[8]), .Q(Q_int[8]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ9 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[8]), .D(D_int_bmux[9]), .DFTRAMBYP(1'b0), .mem_path(mem_path[9]), .XQ(XQ|XD_int[9]), .Q(Q_int[9]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ10 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[9]), .D(D_int_bmux[10]), .DFTRAMBYP(1'b0), .mem_path(mem_path[10]), .XQ(XQ|XD_int[10]), .Q(Q_int[10]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ11 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[10]), .D(D_int_bmux[11]), .DFTRAMBYP(1'b0), .mem_path(mem_path[11]), .XQ(XQ|XD_int[11]), .Q(Q_int[11]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ12 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[11]), .D(D_int_bmux[12]), .DFTRAMBYP(1'b0), .mem_path(mem_path[12]), .XQ(XQ|XD_int[12]), .Q(Q_int[12]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ13 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[12]), .D(D_int_bmux[13]), .DFTRAMBYP(1'b0), .mem_path(mem_path[13]), .XQ(XQ|XD_int[13]), .Q(Q_int[13]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ14 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[13]), .D(D_int_bmux[14]), .DFTRAMBYP(1'b0), .mem_path(mem_path[14]), .XQ(XQ|XD_int[14]), .Q(Q_int[14]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ15 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[14]), .D(D_int_bmux[15]), .DFTRAMBYP(1'b0), .mem_path(mem_path[15]), .XQ(XQ|XD_int[15]), .Q(Q_int[15]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ16 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[15]), .D(D_int_bmux[16]), .DFTRAMBYP(1'b0), .mem_path(mem_path[16]), .XQ(XQ|XD_int[16]), .Q(Q_int[16]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ17 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[16]), .D(D_int_bmux[17]), .DFTRAMBYP(1'b0), .mem_path(mem_path[17]), .XQ(XQ|XD_int[17]), .Q(Q_int[17]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ18 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[17]), .D(D_int_bmux[18]), .DFTRAMBYP(1'b0), .mem_path(mem_path[18]), .XQ(XQ|XD_int[18]), .Q(Q_int[18]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ19 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[18]), .D(D_int_bmux[19]), .DFTRAMBYP(1'b0), .mem_path(mem_path[19]), .XQ(XQ|XD_int[19]), .Q(Q_int[19]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ20 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[19]), .D(D_int_bmux[20]), .DFTRAMBYP(1'b0), .mem_path(mem_path[20]), .XQ(XQ|XD_int[20]), .Q(Q_int[20]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ21 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[20]), .D(D_int_bmux[21]), .DFTRAMBYP(1'b0), .mem_path(mem_path[21]), .XQ(XQ|XD_int[21]), .Q(Q_int[21]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ22 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[21]), .D(D_int_bmux[22]), .DFTRAMBYP(1'b0), .mem_path(mem_path[22]), .XQ(XQ|XD_int[22]), .Q(Q_int[22]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ23 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[22]), .D(D_int_bmux[23]), .DFTRAMBYP(1'b0), .mem_path(mem_path[23]), .XQ(XQ|XD_int[23]), .Q(Q_int[23]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ24 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[23]), .D(D_int_bmux[24]), .DFTRAMBYP(1'b0), .mem_path(mem_path[24]), .XQ(XQ|XD_int[24]), .Q(Q_int[24]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ25 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[24]), .D(D_int_bmux[25]), .DFTRAMBYP(1'b0), .mem_path(mem_path[25]), .XQ(XQ|XD_int[25]), .Q(Q_int[25]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ26 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[25]), .D(D_int_bmux[26]), .DFTRAMBYP(1'b0), .mem_path(mem_path[26]), .XQ(XQ|XD_int[26]), .Q(Q_int[26]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ27 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[26]), .D(D_int_bmux[27]), .DFTRAMBYP(1'b0), .mem_path(mem_path[27]), .XQ(XQ|XD_int[27]), .Q(Q_int[27]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ28 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[27]), .D(D_int_bmux[28]), .DFTRAMBYP(1'b0), .mem_path(mem_path[28]), .XQ(XQ|XD_int[28]), .Q(Q_int[28]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ29 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[28]), .D(D_int_bmux[29]), .DFTRAMBYP(1'b0), .mem_path(mem_path[29]), .XQ(XQ|XD_int[29]), .Q(Q_int[29]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ30 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[29]), .D(D_int_bmux[30]), .DFTRAMBYP(1'b0), .mem_path(mem_path[30]), .XQ(XQ|XD_int[30]), .Q(Q_int[30]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ31 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[30]), .D(D_int_bmux[31]), .DFTRAMBYP(1'b0), .mem_path(mem_path[31]), .XQ(XQ|XD_int[31]), .Q(Q_int[31]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ32 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[33]), .D(D_int_bmux[32]), .DFTRAMBYP(1'b0), .mem_path(mem_path[32]), .XQ(XQ|XD_int[32]), .Q(Q_int[32]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ33 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[34]), .D(D_int_bmux[33]), .DFTRAMBYP(1'b0), .mem_path(mem_path[33]), .XQ(XQ|XD_int[33]), .Q(Q_int[33]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ34 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[35]), .D(D_int_bmux[34]), .DFTRAMBYP(1'b0), .mem_path(mem_path[34]), .XQ(XQ|XD_int[34]), .Q(Q_int[34]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ35 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[36]), .D(D_int_bmux[35]), .DFTRAMBYP(1'b0), .mem_path(mem_path[35]), .XQ(XQ|XD_int[35]), .Q(Q_int[35]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ36 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[37]), .D(D_int_bmux[36]), .DFTRAMBYP(1'b0), .mem_path(mem_path[36]), .XQ(XQ|XD_int[36]), .Q(Q_int[36]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ37 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[38]), .D(D_int_bmux[37]), .DFTRAMBYP(1'b0), .mem_path(mem_path[37]), .XQ(XQ|XD_int[37]), .Q(Q_int[37]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ38 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[39]), .D(D_int_bmux[38]), .DFTRAMBYP(1'b0), .mem_path(mem_path[38]), .XQ(XQ|XD_int[38]), .Q(Q_int[38]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ39 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[40]), .D(D_int_bmux[39]), .DFTRAMBYP(1'b0), .mem_path(mem_path[39]), .XQ(XQ|XD_int[39]), .Q(Q_int[39]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ40 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[41]), .D(D_int_bmux[40]), .DFTRAMBYP(1'b0), .mem_path(mem_path[40]), .XQ(XQ|XD_int[40]), .Q(Q_int[40]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ41 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[42]), .D(D_int_bmux[41]), .DFTRAMBYP(1'b0), .mem_path(mem_path[41]), .XQ(XQ|XD_int[41]), .Q(Q_int[41]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ42 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[43]), .D(D_int_bmux[42]), .DFTRAMBYP(1'b0), .mem_path(mem_path[42]), .XQ(XQ|XD_int[42]), .Q(Q_int[42]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ43 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[44]), .D(D_int_bmux[43]), .DFTRAMBYP(1'b0), .mem_path(mem_path[43]), .XQ(XQ|XD_int[43]), .Q(Q_int[43]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ44 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[45]), .D(D_int_bmux[44]), .DFTRAMBYP(1'b0), .mem_path(mem_path[44]), .XQ(XQ|XD_int[44]), .Q(Q_int[44]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ45 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[46]), .D(D_int_bmux[45]), .DFTRAMBYP(1'b0), .mem_path(mem_path[45]), .XQ(XQ|XD_int[45]), .Q(Q_int[45]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ46 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[47]), .D(D_int_bmux[46]), .DFTRAMBYP(1'b0), .mem_path(mem_path[46]), .XQ(XQ|XD_int[46]), .Q(Q_int[46]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ47 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[48]), .D(D_int_bmux[47]), .DFTRAMBYP(1'b0), .mem_path(mem_path[47]), .XQ(XQ|XD_int[47]), .Q(Q_int[47]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ48 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[49]), .D(D_int_bmux[48]), .DFTRAMBYP(1'b0), .mem_path(mem_path[48]), .XQ(XQ|XD_int[48]), .Q(Q_int[48]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ49 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[50]), .D(D_int_bmux[49]), .DFTRAMBYP(1'b0), .mem_path(mem_path[49]), .XQ(XQ|XD_int[49]), .Q(Q_int[49]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ50 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[51]), .D(D_int_bmux[50]), .DFTRAMBYP(1'b0), .mem_path(mem_path[50]), .XQ(XQ|XD_int[50]), .Q(Q_int[50]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ51 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[52]), .D(D_int_bmux[51]), .DFTRAMBYP(1'b0), .mem_path(mem_path[51]), .XQ(XQ|XD_int[51]), .Q(Q_int[51]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ52 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[53]), .D(D_int_bmux[52]), .DFTRAMBYP(1'b0), .mem_path(mem_path[52]), .XQ(XQ|XD_int[52]), .Q(Q_int[52]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ53 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[54]), .D(D_int_bmux[53]), .DFTRAMBYP(1'b0), .mem_path(mem_path[53]), .XQ(XQ|XD_int[53]), .Q(Q_int[53]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ54 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[55]), .D(D_int_bmux[54]), .DFTRAMBYP(1'b0), .mem_path(mem_path[54]), .XQ(XQ|XD_int[54]), .Q(Q_int[54]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ55 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[56]), .D(D_int_bmux[55]), .DFTRAMBYP(1'b0), .mem_path(mem_path[55]), .XQ(XQ|XD_int[55]), .Q(Q_int[55]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ56 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[57]), .D(D_int_bmux[56]), .DFTRAMBYP(1'b0), .mem_path(mem_path[56]), .XQ(XQ|XD_int[56]), .Q(Q_int[56]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ57 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[58]), .D(D_int_bmux[57]), .DFTRAMBYP(1'b0), .mem_path(mem_path[57]), .XQ(XQ|XD_int[57]), .Q(Q_int[57]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ58 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[59]), .D(D_int_bmux[58]), .DFTRAMBYP(1'b0), .mem_path(mem_path[58]), .XQ(XQ|XD_int[58]), .Q(Q_int[58]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ59 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[60]), .D(D_int_bmux[59]), .DFTRAMBYP(1'b0), .mem_path(mem_path[59]), .XQ(XQ|XD_int[59]), .Q(Q_int[59]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ60 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[61]), .D(D_int_bmux[60]), .DFTRAMBYP(1'b0), .mem_path(mem_path[60]), .XQ(XQ|XD_int[60]), .Q(Q_int[60]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ61 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[62]), .D(D_int_bmux[61]), .DFTRAMBYP(1'b0), .mem_path(mem_path[61]), .XQ(XQ|XD_int[61]), .Q(Q_int[61]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ62 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[63]), .D(D_int_bmux[62]), .DFTRAMBYP(1'b0), .mem_path(mem_path[62]), .XQ(XQ|XD_int[62]), .Q(Q_int[62]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ63 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(1'b0), .D(D_int_bmux[63]), .DFTRAMBYP(1'b0), .mem_path(mem_path[63]), .XQ(XQ|XD_int[63]|1'b0), .Q(Q_int[63]));


// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
	always @ (VDDCE or VDDPE or VSSE) begin
		if (VDDCE === 1'bx || VDDCE === 1'bz) begin
			$display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
        XQ = 1'b1; Q_update = 1'b1;
			failedWrite(0);
			bad_VDDCE = 1'b1;
		end else begin
			bad_VDDCE = 1'b0;
		end
		if (RET1N_ == 1'b1 && VDDPE !== 1'b1) begin
			$display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
        XQ = 1'b1; Q_update = 1'b1;
			failedWrite(0);
			bad_VDDPE = 1'b1;
		end else begin
			bad_VDDPE = 1'b0;
		end
		if (VSSE !== 1'b0) begin
			$display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
        XQ = 1'b1; Q_update = 1'b1;
			failedWrite(0);
			bad_VSSE = 1'b1;
		end else begin
			bad_VSSE = 1'b0;
		end
		bad_power = bad_VDDCE | bad_VDDPE | bad_VSSE ;
	end
`endif

  always @ NOT_CEN begin
    CEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_GWEN begin
    GWEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A9 begin
    A_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A8 begin
    A_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A7 begin
    A_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A6 begin
    A_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A5 begin
    A_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A4 begin
    A_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A3 begin
    A_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A2 begin
    A_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A1 begin
    A_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A0 begin
    A_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D63 begin
    D_int[63] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D62 begin
    D_int[62] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D61 begin
    D_int[61] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D60 begin
    D_int[60] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D59 begin
    D_int[59] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D58 begin
    D_int[58] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D57 begin
    D_int[57] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D56 begin
    D_int[56] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D55 begin
    D_int[55] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D54 begin
    D_int[54] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D53 begin
    D_int[53] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D52 begin
    D_int[52] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D51 begin
    D_int[51] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D50 begin
    D_int[50] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D49 begin
    D_int[49] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D48 begin
    D_int[48] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D47 begin
    D_int[47] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D46 begin
    D_int[46] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D45 begin
    D_int[45] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D44 begin
    D_int[44] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D43 begin
    D_int[43] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D42 begin
    D_int[42] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D41 begin
    D_int[41] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D40 begin
    D_int[40] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D39 begin
    D_int[39] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D38 begin
    D_int[38] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D37 begin
    D_int[37] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D36 begin
    D_int[36] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D35 begin
    D_int[35] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D34 begin
    D_int[34] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D33 begin
    D_int[33] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D32 begin
    D_int[32] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D31 begin
    D_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D30 begin
    D_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D29 begin
    D_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D28 begin
    D_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D27 begin
    D_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D26 begin
    D_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D25 begin
    D_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D24 begin
    D_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D23 begin
    D_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D22 begin
    D_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D21 begin
    D_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D20 begin
    D_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D19 begin
    D_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D18 begin
    D_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D17 begin
    D_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D16 begin
    D_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D15 begin
    D_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D14 begin
    D_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D13 begin
    D_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D12 begin
    D_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D11 begin
    D_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D10 begin
    D_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D9 begin
    D_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D8 begin
    D_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D7 begin
    D_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D6 begin
    D_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D5 begin
    D_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D4 begin
    D_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D3 begin
    D_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D2 begin
    D_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D1 begin
    D_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D0 begin
    D_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_STOV begin
    STOV_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA2 begin
    EMA_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA1 begin
    EMA_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA0 begin
    EMA_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAW1 begin
    EMAW_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAW0 begin
    EMAW_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAS begin
    EMAS_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_RET1N begin
    RET1N_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end

  always @ NOT_CLK_PER begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINH begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINL begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end



  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1;
  wire STOVeq1aRET1Neq1, STOVeq0aRET1Neq1aCENeq0, STOVeq1aRET1Neq1aCENeq0, RET1Neq1;
  wire RET1Neq1aCENeq0aGWENeq0, RET1Neq1aCENeq0;

  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;


  assign STOVeq0aRET1Neq1aCENeq0 = !STOV&&RET1N&&!CEN;
  assign STOVeq1aRET1Neq1aCENeq0 = STOV&&RET1N&&!CEN;
  assign RET1Neq1aCENeq0aGWENeq0 = RET1N&&!CEN&&!GWEN;

  assign STOVeq1aRET1Neq1 = STOV&&RET1N;
  assign RET1Neq1 = RET1N;
  assign RET1Neq1aCENeq0 = RET1N&&!CEN;

  specify

    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);


   // Define SDTC only if back-annotating SDF file generated by Design Compiler
   `ifdef NO_SDTC
       $period(posedge CLK, `ARM_MEM_PERIOD, NOT_CLK_PER);
   `else
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq1aRET1Neq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
   `endif


   // Define SDTC only if back-annotating SDF file generated by Design Compiler
   `ifdef NO_SDTC
       $width(posedge CLK, `ARM_MEM_WIDTH, 0, NOT_CLK_MINH);
       $width(negedge CLK, `ARM_MEM_WIDTH, 0, NOT_CLK_MINL);
   `else
       $width(posedge CLK &&& STOVeq0aRET1Neq1aCENeq0, `ARM_MEM_WIDTH, 0, NOT_CLK_MINH);
       $width(posedge CLK &&& STOVeq1aRET1Neq1aCENeq0, `ARM_MEM_WIDTH, 0, NOT_CLK_MINH);
       $width(negedge CLK &&& STOVeq0aRET1Neq1aCENeq0, `ARM_MEM_WIDTH, 0, NOT_CLK_MINL);
       $width(negedge CLK &&& STOVeq1aRET1Neq1aCENeq0, `ARM_MEM_WIDTH, 0, NOT_CLK_MINL);
   `endif

    $setuphold(posedge CLK &&& RET1Neq1, posedge CEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_CEN,,,dCLK,dCEN);
    $setuphold(posedge CLK &&& RET1Neq1, negedge CEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_CEN,,,dCLK,dCEN);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge GWEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_GWEN,,,dCLK,dGWEN);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge GWEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_GWEN,,,dCLK,dGWEN);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A9,,,dCLK,dA[9]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A8,,,dCLK,dA[8]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A7,,,dCLK,dA[7]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A6,,,dCLK,dA[6]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A5,,,dCLK,dA[5]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A4,,,dCLK,dA[4]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A3,,,dCLK,dA[3]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A2,,,dCLK,dA[2]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A1,,,dCLK,dA[1]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A0,,,dCLK,dA[0]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A9,,,dCLK,dA[9]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A8,,,dCLK,dA[8]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A7,,,dCLK,dA[7]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A6,,,dCLK,dA[6]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A5,,,dCLK,dA[5]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A4,,,dCLK,dA[4]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A3,,,dCLK,dA[3]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A2,,,dCLK,dA[2]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A1,,,dCLK,dA[1]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A0,,,dCLK,dA[0]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[63], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D63,,,dCLK,dD[63]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[62], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D62,,,dCLK,dD[62]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[61], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D61,,,dCLK,dD[61]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[60], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D60,,,dCLK,dD[60]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[59], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D59,,,dCLK,dD[59]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[58], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D58,,,dCLK,dD[58]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[57], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D57,,,dCLK,dD[57]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[56], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D56,,,dCLK,dD[56]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[55], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D55,,,dCLK,dD[55]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[54], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D54,,,dCLK,dD[54]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[53], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D53,,,dCLK,dD[53]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[52], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D52,,,dCLK,dD[52]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[51], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D51,,,dCLK,dD[51]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[50], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D50,,,dCLK,dD[50]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[49], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D49,,,dCLK,dD[49]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[48], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D48,,,dCLK,dD[48]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[47], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D47,,,dCLK,dD[47]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[46], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D46,,,dCLK,dD[46]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[45], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D45,,,dCLK,dD[45]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[44], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D44,,,dCLK,dD[44]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[43], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D43,,,dCLK,dD[43]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[42], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D42,,,dCLK,dD[42]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[41], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D41,,,dCLK,dD[41]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[40], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D40,,,dCLK,dD[40]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[39], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D39,,,dCLK,dD[39]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[38], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D38,,,dCLK,dD[38]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[37], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D37,,,dCLK,dD[37]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[36], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D36,,,dCLK,dD[36]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[35], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D35,,,dCLK,dD[35]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[34], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D34,,,dCLK,dD[34]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[33], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D33,,,dCLK,dD[33]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[32], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D32,,,dCLK,dD[32]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[31], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D31,,,dCLK,dD[31]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[30], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D30,,,dCLK,dD[30]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[29], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D29,,,dCLK,dD[29]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[28], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D28,,,dCLK,dD[28]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[27], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D27,,,dCLK,dD[27]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[26], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D26,,,dCLK,dD[26]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[25], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D25,,,dCLK,dD[25]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[24], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D24,,,dCLK,dD[24]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[23], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D23,,,dCLK,dD[23]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[22], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D22,,,dCLK,dD[22]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[21], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D21,,,dCLK,dD[21]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[20], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D20,,,dCLK,dD[20]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[19], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D19,,,dCLK,dD[19]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[18], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D18,,,dCLK,dD[18]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[17], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D17,,,dCLK,dD[17]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[16], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D16,,,dCLK,dD[16]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[15], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D15,,,dCLK,dD[15]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[14], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D14,,,dCLK,dD[14]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[13], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D13,,,dCLK,dD[13]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[12], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D12,,,dCLK,dD[12]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[11], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D11,,,dCLK,dD[11]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[10], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D10,,,dCLK,dD[10]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D9,,,dCLK,dD[9]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D8,,,dCLK,dD[8]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D7,,,dCLK,dD[7]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D6,,,dCLK,dD[6]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D5,,,dCLK,dD[5]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D4,,,dCLK,dD[4]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D3,,,dCLK,dD[3]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D2,,,dCLK,dD[2]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D1,,,dCLK,dD[1]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D0,,,dCLK,dD[0]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[63], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D63,,,dCLK,dD[63]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[62], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D62,,,dCLK,dD[62]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[61], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D61,,,dCLK,dD[61]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[60], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D60,,,dCLK,dD[60]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[59], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D59,,,dCLK,dD[59]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[58], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D58,,,dCLK,dD[58]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[57], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D57,,,dCLK,dD[57]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[56], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D56,,,dCLK,dD[56]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[55], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D55,,,dCLK,dD[55]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[54], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D54,,,dCLK,dD[54]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[53], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D53,,,dCLK,dD[53]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[52], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D52,,,dCLK,dD[52]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[51], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D51,,,dCLK,dD[51]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[50], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D50,,,dCLK,dD[50]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[49], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D49,,,dCLK,dD[49]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[48], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D48,,,dCLK,dD[48]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[47], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D47,,,dCLK,dD[47]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[46], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D46,,,dCLK,dD[46]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[45], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D45,,,dCLK,dD[45]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[44], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D44,,,dCLK,dD[44]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[43], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D43,,,dCLK,dD[43]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[42], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D42,,,dCLK,dD[42]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[41], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D41,,,dCLK,dD[41]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[40], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D40,,,dCLK,dD[40]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[39], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D39,,,dCLK,dD[39]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[38], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D38,,,dCLK,dD[38]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[37], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D37,,,dCLK,dD[37]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[36], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D36,,,dCLK,dD[36]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[35], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D35,,,dCLK,dD[35]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[34], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D34,,,dCLK,dD[34]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[33], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D33,,,dCLK,dD[33]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[32], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D32,,,dCLK,dD[32]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[31], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D31,,,dCLK,dD[31]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[30], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D30,,,dCLK,dD[30]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[29], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D29,,,dCLK,dD[29]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[28], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D28,,,dCLK,dD[28]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[27], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D27,,,dCLK,dD[27]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[26], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D26,,,dCLK,dD[26]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[25], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D25,,,dCLK,dD[25]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[24], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D24,,,dCLK,dD[24]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[23], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D23,,,dCLK,dD[23]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[22], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D22,,,dCLK,dD[22]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[21], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D21,,,dCLK,dD[21]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[20], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D20,,,dCLK,dD[20]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[19], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D19,,,dCLK,dD[19]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[18], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D18,,,dCLK,dD[18]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[17], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D17,,,dCLK,dD[17]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[16], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D16,,,dCLK,dD[16]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[15], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D15,,,dCLK,dD[15]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[14], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D14,,,dCLK,dD[14]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[13], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D13,,,dCLK,dD[13]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[12], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D12,,,dCLK,dD[12]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[11], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D11,,,dCLK,dD[11]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[10], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D10,,,dCLK,dD[10]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D9,,,dCLK,dD[9]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D8,,,dCLK,dD[8]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D7,,,dCLK,dD[7]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D6,,,dCLK,dD[6]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D5,,,dCLK,dD[5]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D4,,,dCLK,dD[4]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D3,,,dCLK,dD[3]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D2,,,dCLK,dD[2]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D1,,,dCLK,dD[1]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D0,,,dCLK,dD[0]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge STOV, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_STOV,,,dCLK,dSTOV);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge STOV, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_STOV,,,dCLK,dSTOV);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMA[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA2,,,dCLK,dEMA[2]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMA[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA1,,,dCLK,dEMA[1]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMA[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA0,,,dCLK,dEMA[0]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMA[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA2,,,dCLK,dEMA[2]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMA[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA1,,,dCLK,dEMA[1]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMA[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA0,,,dCLK,dEMA[0]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMAW[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW1,,,dCLK,dEMAW[1]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMAW[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW0,,,dCLK,dEMAW[0]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMAW[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW1,,,dCLK,dEMAW[1]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMAW[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW0,,,dCLK,dEMAW[0]);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMAS, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAS,,,dCLK,dEMAS);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMAS, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAS,,,dCLK,dEMAS);
    $setuphold(negedge RET1N, negedge CEN, 0.000, `ARM_MEM_HOLD, NOT_RET1N,,,dRET1N,dCEN);
    $setuphold(posedge RET1N, negedge CEN, 0.000, `ARM_MEM_HOLD, NOT_RET1N,,,dRET1N,dCEN);
    $setuphold(posedge CEN, posedge RET1N, 0.000, `ARM_MEM_HOLD, NOT_RET1N,,,dCEN,dRET1N);
    $setuphold(posedge CEN, negedge RET1N, 0.000, `ARM_MEM_HOLD, NOT_RET1N,,,dCEN,dRET1N);
  endspecify


endmodule
`endcelldefine
`else
`celldefine
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
module tsmc16_1rw_1024_64b (VDDCE, VDDPE, VSSE, Q, CLK, CEN, GWEN, A, D, STOV, EMA,
    EMAW, EMAS, RET1N);
`else
module tsmc16_1rw_1024_64b (Q, CLK, CEN, GWEN, A, D, STOV, EMA, EMAW, EMAS, RET1N);
`endif

  parameter ASSERT_PREFIX = "";
  parameter BITS = 64;
  parameter WORDS = 1024;
  parameter MUX = 8;
  parameter MEM_WIDTH = 512; // redun block size 8, 256 on left, 256 on right
  parameter MEM_HEIGHT = 128;
  parameter WP_SIZE = 64 ;
  parameter UPM_WIDTH = 3;
  parameter UPMW_WIDTH = 2;
  parameter UPMS_WIDTH = 1;
  parameter ROWS = 128;

  output [63:0] Q;
  input  CLK;
  input  CEN;
  input  GWEN;
  input [9:0] A;
  input [63:0] D;
  input  STOV;
  input [2:0] EMA;
  input [1:0] EMAW;
  input  EMAS;
  input  RET1N;
`ifdef POWER_PINS
  inout VDDCE;
  inout VDDPE;
  inout VSSE;
`endif

`ifdef POWER_PINS
  reg bad_VDDCE;
  reg bad_VDDPE;
  reg bad_VSSE;
  reg bad_power;
`endif
  wire corrupt_power;
  reg pre_charge_st;
  integer row_address;
  integer mux_address;
  initial row_address = 0;
  initial mux_address = 0;
  reg [511:0] mem [0:127];
  reg [511:0] row, row_t;
  reg LAST_CLK;
  reg [511:0] row_mask;
  reg [511:0] new_data;
  reg [511:0] data_out;
  reg [63:0] readLatch0;
  reg [63:0] shifted_readLatch0;
  wire [63:0] Q_int;
  reg [63:0] Q_int_delayed;
  reg XQ, Q_update;
  reg XD_sh, D_sh_update;
  wire [63:0] D_int_bmux;
  reg [63:0] mem_path;
  reg [63:0] mem_path_d;
  reg [63:0] writeEnable;

  reg NOT_CEN, NOT_GWEN, NOT_A9, NOT_A8, NOT_A7, NOT_A6, NOT_A5, NOT_A4, NOT_A3, NOT_A2;
  reg NOT_A1, NOT_A0, NOT_D63, NOT_D62, NOT_D61, NOT_D60, NOT_D59, NOT_D58, NOT_D57;
  reg NOT_D56, NOT_D55, NOT_D54, NOT_D53, NOT_D52, NOT_D51, NOT_D50, NOT_D49, NOT_D48;
  reg NOT_D47, NOT_D46, NOT_D45, NOT_D44, NOT_D43, NOT_D42, NOT_D41, NOT_D40, NOT_D39;
  reg NOT_D38, NOT_D37, NOT_D36, NOT_D35, NOT_D34, NOT_D33, NOT_D32, NOT_D31, NOT_D30;
  reg NOT_D29, NOT_D28, NOT_D27, NOT_D26, NOT_D25, NOT_D24, NOT_D23, NOT_D22, NOT_D21;
  reg NOT_D20, NOT_D19, NOT_D18, NOT_D17, NOT_D16, NOT_D15, NOT_D14, NOT_D13, NOT_D12;
  reg NOT_D11, NOT_D10, NOT_D9, NOT_D8, NOT_D7, NOT_D6, NOT_D5, NOT_D4, NOT_D3, NOT_D2;
  reg NOT_D1, NOT_D0, NOT_STOV, NOT_EMA2, NOT_EMA1, NOT_EMA0, NOT_EMAW1, NOT_EMAW0;
  reg NOT_EMAS, NOT_RET1N;
  reg NOT_CLK_PER, NOT_CLK_MINH, NOT_CLK_MINL;
  reg clk0_int;

  wire [63:0] Q_;
 wire  CLK_;
  wire  CEN_;
  reg  CEN_int;
  reg  CEN_p2;
  wire  GWEN_;
  reg  GWEN_int;
  wire [9:0] A_;
  reg [9:0] A_int;
  wire [63:0] D_;
  reg [63:0] D_int;
  reg [63:0] XD_int;
  wire  STOV_;
  reg  STOV_int;
  wire [2:0] EMA_;
  reg [2:0] EMA_int;
  wire [1:0] EMAW_;
  reg [1:0] EMAW_int;
  wire  EMAS_;
  reg  EMAS_int;
  wire  RET1N_;
  reg  RET1N_int;

  buf B149(Q[0], Q_[0]);
  buf B150(Q[1], Q_[1]);
  buf B151(Q[2], Q_[2]);
  buf B152(Q[3], Q_[3]);
  buf B153(Q[4], Q_[4]);
  buf B154(Q[5], Q_[5]);
  buf B155(Q[6], Q_[6]);
  buf B156(Q[7], Q_[7]);
  buf B157(Q[8], Q_[8]);
  buf B158(Q[9], Q_[9]);
  buf B159(Q[10], Q_[10]);
  buf B160(Q[11], Q_[11]);
  buf B161(Q[12], Q_[12]);
  buf B162(Q[13], Q_[13]);
  buf B163(Q[14], Q_[14]);
  buf B164(Q[15], Q_[15]);
  buf B165(Q[16], Q_[16]);
  buf B166(Q[17], Q_[17]);
  buf B167(Q[18], Q_[18]);
  buf B168(Q[19], Q_[19]);
  buf B169(Q[20], Q_[20]);
  buf B170(Q[21], Q_[21]);
  buf B171(Q[22], Q_[22]);
  buf B172(Q[23], Q_[23]);
  buf B173(Q[24], Q_[24]);
  buf B174(Q[25], Q_[25]);
  buf B175(Q[26], Q_[26]);
  buf B176(Q[27], Q_[27]);
  buf B177(Q[28], Q_[28]);
  buf B178(Q[29], Q_[29]);
  buf B179(Q[30], Q_[30]);
  buf B180(Q[31], Q_[31]);
  buf B181(Q[32], Q_[32]);
  buf B182(Q[33], Q_[33]);
  buf B183(Q[34], Q_[34]);
  buf B184(Q[35], Q_[35]);
  buf B185(Q[36], Q_[36]);
  buf B186(Q[37], Q_[37]);
  buf B187(Q[38], Q_[38]);
  buf B188(Q[39], Q_[39]);
  buf B189(Q[40], Q_[40]);
  buf B190(Q[41], Q_[41]);
  buf B191(Q[42], Q_[42]);
  buf B192(Q[43], Q_[43]);
  buf B193(Q[44], Q_[44]);
  buf B194(Q[45], Q_[45]);
  buf B195(Q[46], Q_[46]);
  buf B196(Q[47], Q_[47]);
  buf B197(Q[48], Q_[48]);
  buf B198(Q[49], Q_[49]);
  buf B199(Q[50], Q_[50]);
  buf B200(Q[51], Q_[51]);
  buf B201(Q[52], Q_[52]);
  buf B202(Q[53], Q_[53]);
  buf B203(Q[54], Q_[54]);
  buf B204(Q[55], Q_[55]);
  buf B205(Q[56], Q_[56]);
  buf B206(Q[57], Q_[57]);
  buf B207(Q[58], Q_[58]);
  buf B208(Q[59], Q_[59]);
  buf B209(Q[60], Q_[60]);
  buf B210(Q[61], Q_[61]);
  buf B211(Q[62], Q_[62]);
  buf B212(Q[63], Q_[63]);
  buf B213(CLK_, CLK);
  buf B214(CEN_, CEN);
  buf B215(GWEN_, GWEN);
  buf B216(A_[0], A[0]);
  buf B217(A_[1], A[1]);
  buf B218(A_[2], A[2]);
  buf B219(A_[3], A[3]);
  buf B220(A_[4], A[4]);
  buf B221(A_[5], A[5]);
  buf B222(A_[6], A[6]);
  buf B223(A_[7], A[7]);
  buf B224(A_[8], A[8]);
  buf B225(A_[9], A[9]);
  buf B226(D_[0], D[0]);
  buf B227(D_[1], D[1]);
  buf B228(D_[2], D[2]);
  buf B229(D_[3], D[3]);
  buf B230(D_[4], D[4]);
  buf B231(D_[5], D[5]);
  buf B232(D_[6], D[6]);
  buf B233(D_[7], D[7]);
  buf B234(D_[8], D[8]);
  buf B235(D_[9], D[9]);
  buf B236(D_[10], D[10]);
  buf B237(D_[11], D[11]);
  buf B238(D_[12], D[12]);
  buf B239(D_[13], D[13]);
  buf B240(D_[14], D[14]);
  buf B241(D_[15], D[15]);
  buf B242(D_[16], D[16]);
  buf B243(D_[17], D[17]);
  buf B244(D_[18], D[18]);
  buf B245(D_[19], D[19]);
  buf B246(D_[20], D[20]);
  buf B247(D_[21], D[21]);
  buf B248(D_[22], D[22]);
  buf B249(D_[23], D[23]);
  buf B250(D_[24], D[24]);
  buf B251(D_[25], D[25]);
  buf B252(D_[26], D[26]);
  buf B253(D_[27], D[27]);
  buf B254(D_[28], D[28]);
  buf B255(D_[29], D[29]);
  buf B256(D_[30], D[30]);
  buf B257(D_[31], D[31]);
  buf B258(D_[32], D[32]);
  buf B259(D_[33], D[33]);
  buf B260(D_[34], D[34]);
  buf B261(D_[35], D[35]);
  buf B262(D_[36], D[36]);
  buf B263(D_[37], D[37]);
  buf B264(D_[38], D[38]);
  buf B265(D_[39], D[39]);
  buf B266(D_[40], D[40]);
  buf B267(D_[41], D[41]);
  buf B268(D_[42], D[42]);
  buf B269(D_[43], D[43]);
  buf B270(D_[44], D[44]);
  buf B271(D_[45], D[45]);
  buf B272(D_[46], D[46]);
  buf B273(D_[47], D[47]);
  buf B274(D_[48], D[48]);
  buf B275(D_[49], D[49]);
  buf B276(D_[50], D[50]);
  buf B277(D_[51], D[51]);
  buf B278(D_[52], D[52]);
  buf B279(D_[53], D[53]);
  buf B280(D_[54], D[54]);
  buf B281(D_[55], D[55]);
  buf B282(D_[56], D[56]);
  buf B283(D_[57], D[57]);
  buf B284(D_[58], D[58]);
  buf B285(D_[59], D[59]);
  buf B286(D_[60], D[60]);
  buf B287(D_[61], D[61]);
  buf B288(D_[62], D[62]);
  buf B289(D_[63], D[63]);
  buf B290(STOV_, STOV);
  buf B291(EMA_[0], EMA[0]);
  buf B292(EMA_[1], EMA[1]);
  buf B293(EMA_[2], EMA[2]);
  buf B294(EMAW_[0], EMAW[0]);
  buf B295(EMAW_[1], EMAW[1]);
  buf B296(EMAS_, EMAS);
  buf B297(RET1N_, RET1N);

`ifdef POWER_PINS
  assign corrupt_power = bad_power;
`else
  assign corrupt_power = 1'b0;
`endif

   `ifdef ARM_FAULT_MODELING
     tsmc16_1rw_1024_64b_error_injection u1(.CLK(CLK_), .Q_out(Q_), .A(A_int), .CEN(CEN_int), .GWEN(GWEN_int), .WEN(GWEN_int), .Q_in(Q_int));
  `else
  assign Q_ = (RET1N_ | pre_charge_st) & ~corrupt_power ? ((STOV_ ? (Q_int_delayed) : (Q_int))) : {64{1'bx}};
  `endif

// If INITIALIZE_MEMORY is defined at Simulator Command Line, it Initializes the Memory with all ZEROS.
`ifdef INITIALIZE_MEMORY
  integer i;
  initial
  begin
    #0;
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'b0}};
  end
`endif
  always @ (EMA_) begin
  	if(EMA_ < 2) 
   	$display("Warning: Set Value for EMA doesn't match Default value 2 in %m at %0t", $time);
  end
  always @ (EMAW_) begin
  	if(EMAW_ < 1) 
   	$display("Warning: Set Value for EMAW doesn't match Default value 1 in %m at %0t", $time);
  end
  always @ (EMAS_) begin
  	if(EMAS_ < 0) 
   	$display("Warning: Set Value for EMAS doesn't match Default value 0 in %m at %0t", $time);
  end
	always @ (STOV_) begin
		if(CLK_ == 1'b1) begin
			XQ = 1'b1; Q_update = 1'b1;
			#0; Q_update = 1'b0;
			XQ = 1'b0;
		end
	end

  task failedWrite;
  input port_f;
  integer i;
  begin
    for (i = 0; i < MEM_HEIGHT; i = i + 1)
      mem[i] = {MEM_WIDTH{1'bx}};
  end
  endtask

  function isBitX;
    input bitval;
    begin
      isBitX = ( bitval===1'bx || bitval===1'bz ) ? 1'b1 : 1'b0;
    end
  endfunction


task loadmem;
	input [1000*8-1:0] filename;
	reg [BITS-1:0] memld [0:WORDS-1];
	integer i;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
	$readmemb(filename, memld);
     if (CEN_ === 1'b1) begin
	  for (i=0;i<WORDS;i=i+1) begin
	  wordtemp = memld[i];
	  Atemp = i;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        row_mask =  ( {7'b0000000, writeEnable[63], 7'b0000000, writeEnable[62], 7'b0000000, writeEnable[61],
          7'b0000000, writeEnable[60], 7'b0000000, writeEnable[59], 7'b0000000, writeEnable[58],
          7'b0000000, writeEnable[57], 7'b0000000, writeEnable[56], 7'b0000000, writeEnable[55],
          7'b0000000, writeEnable[54], 7'b0000000, writeEnable[53], 7'b0000000, writeEnable[52],
          7'b0000000, writeEnable[51], 7'b0000000, writeEnable[50], 7'b0000000, writeEnable[49],
          7'b0000000, writeEnable[48], 7'b0000000, writeEnable[47], 7'b0000000, writeEnable[46],
          7'b0000000, writeEnable[45], 7'b0000000, writeEnable[44], 7'b0000000, writeEnable[43],
          7'b0000000, writeEnable[42], 7'b0000000, writeEnable[41], 7'b0000000, writeEnable[40],
          7'b0000000, writeEnable[39], 7'b0000000, writeEnable[38], 7'b0000000, writeEnable[37],
          7'b0000000, writeEnable[36], 7'b0000000, writeEnable[35], 7'b0000000, writeEnable[34],
          7'b0000000, writeEnable[33], 7'b0000000, writeEnable[32], 7'b0000000, writeEnable[31],
          7'b0000000, writeEnable[30], 7'b0000000, writeEnable[29], 7'b0000000, writeEnable[28],
          7'b0000000, writeEnable[27], 7'b0000000, writeEnable[26], 7'b0000000, writeEnable[25],
          7'b0000000, writeEnable[24], 7'b0000000, writeEnable[23], 7'b0000000, writeEnable[22],
          7'b0000000, writeEnable[21], 7'b0000000, writeEnable[20], 7'b0000000, writeEnable[19],
          7'b0000000, writeEnable[18], 7'b0000000, writeEnable[17], 7'b0000000, writeEnable[16],
          7'b0000000, writeEnable[15], 7'b0000000, writeEnable[14], 7'b0000000, writeEnable[13],
          7'b0000000, writeEnable[12], 7'b0000000, writeEnable[11], 7'b0000000, writeEnable[10],
          7'b0000000, writeEnable[9], 7'b0000000, writeEnable[8], 7'b0000000, writeEnable[7],
          7'b0000000, writeEnable[6], 7'b0000000, writeEnable[5], 7'b0000000, writeEnable[4],
          7'b0000000, writeEnable[3], 7'b0000000, writeEnable[2], 7'b0000000, writeEnable[1],
          7'b0000000, writeEnable[0]} << mux_address);
        new_data =  ( {7'b0000000, wordtemp[63], 7'b0000000, wordtemp[62], 7'b0000000, wordtemp[61],
          7'b0000000, wordtemp[60], 7'b0000000, wordtemp[59], 7'b0000000, wordtemp[58],
          7'b0000000, wordtemp[57], 7'b0000000, wordtemp[56], 7'b0000000, wordtemp[55],
          7'b0000000, wordtemp[54], 7'b0000000, wordtemp[53], 7'b0000000, wordtemp[52],
          7'b0000000, wordtemp[51], 7'b0000000, wordtemp[50], 7'b0000000, wordtemp[49],
          7'b0000000, wordtemp[48], 7'b0000000, wordtemp[47], 7'b0000000, wordtemp[46],
          7'b0000000, wordtemp[45], 7'b0000000, wordtemp[44], 7'b0000000, wordtemp[43],
          7'b0000000, wordtemp[42], 7'b0000000, wordtemp[41], 7'b0000000, wordtemp[40],
          7'b0000000, wordtemp[39], 7'b0000000, wordtemp[38], 7'b0000000, wordtemp[37],
          7'b0000000, wordtemp[36], 7'b0000000, wordtemp[35], 7'b0000000, wordtemp[34],
          7'b0000000, wordtemp[33], 7'b0000000, wordtemp[32], 7'b0000000, wordtemp[31],
          7'b0000000, wordtemp[30], 7'b0000000, wordtemp[29], 7'b0000000, wordtemp[28],
          7'b0000000, wordtemp[27], 7'b0000000, wordtemp[26], 7'b0000000, wordtemp[25],
          7'b0000000, wordtemp[24], 7'b0000000, wordtemp[23], 7'b0000000, wordtemp[22],
          7'b0000000, wordtemp[21], 7'b0000000, wordtemp[20], 7'b0000000, wordtemp[19],
          7'b0000000, wordtemp[18], 7'b0000000, wordtemp[17], 7'b0000000, wordtemp[16],
          7'b0000000, wordtemp[15], 7'b0000000, wordtemp[14], 7'b0000000, wordtemp[13],
          7'b0000000, wordtemp[12], 7'b0000000, wordtemp[11], 7'b0000000, wordtemp[10],
          7'b0000000, wordtemp[9], 7'b0000000, wordtemp[8], 7'b0000000, wordtemp[7],
          7'b0000000, wordtemp[6], 7'b0000000, wordtemp[5], 7'b0000000, wordtemp[4],
          7'b0000000, wordtemp[3], 7'b0000000, wordtemp[2], 7'b0000000, wordtemp[1],
          7'b0000000, wordtemp[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
  	end
    end
  end
  endtask

task dumpmem;
	input [1000*8-1:0] filename_dump;
	integer i, dump_file_desc;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
	dump_file_desc = $fopen(filename_dump);
     if (CEN_ === 1'b1) begin
	  for (i=0;i<WORDS;i=i+1) begin
	  Atemp = i;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[504], data_out[496], data_out[488], data_out[480], data_out[472],
          data_out[464], data_out[456], data_out[448], data_out[440], data_out[432],
          data_out[424], data_out[416], data_out[408], data_out[400], data_out[392],
          data_out[384], data_out[376], data_out[368], data_out[360], data_out[352],
          data_out[344], data_out[336], data_out[328], data_out[320], data_out[312],
          data_out[304], data_out[296], data_out[288], data_out[280], data_out[272],
          data_out[264], data_out[256], data_out[248], data_out[240], data_out[232],
          data_out[224], data_out[216], data_out[208], data_out[200], data_out[192],
          data_out[184], data_out[176], data_out[168], data_out[160], data_out[152],
          data_out[144], data_out[136], data_out[128], data_out[120], data_out[112],
          data_out[104], data_out[96], data_out[88], data_out[80], data_out[72], data_out[64],
          data_out[56], data_out[48], data_out[40], data_out[32], data_out[24], data_out[16],
          data_out[8], data_out[0]};
        shifted_readLatch0 = readLatch0;
        mem_path_d = {shifted_readLatch0[63], shifted_readLatch0[62], shifted_readLatch0[61],
          shifted_readLatch0[60], shifted_readLatch0[59], shifted_readLatch0[58], shifted_readLatch0[57],
          shifted_readLatch0[56], shifted_readLatch0[55], shifted_readLatch0[54], shifted_readLatch0[53],
          shifted_readLatch0[52], shifted_readLatch0[51], shifted_readLatch0[50], shifted_readLatch0[49],
          shifted_readLatch0[48], shifted_readLatch0[47], shifted_readLatch0[46], shifted_readLatch0[45],
          shifted_readLatch0[44], shifted_readLatch0[43], shifted_readLatch0[42], shifted_readLatch0[41],
          shifted_readLatch0[40], shifted_readLatch0[39], shifted_readLatch0[38], shifted_readLatch0[37],
          shifted_readLatch0[36], shifted_readLatch0[35], shifted_readLatch0[34], shifted_readLatch0[33],
          shifted_readLatch0[32], shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
   	$fdisplay(dump_file_desc, "%b", mem_path_d);
  end
  	end
    $fclose(dump_file_desc);
  end
  endtask

task loadaddr;
	input [9:0] load_addr;
	input [63:0] load_data;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
     if (CEN_ === 1'b1) begin
	  wordtemp = load_data;
	  Atemp = load_addr;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        row_mask =  ( {7'b0000000, writeEnable[63], 7'b0000000, writeEnable[62], 7'b0000000, writeEnable[61],
          7'b0000000, writeEnable[60], 7'b0000000, writeEnable[59], 7'b0000000, writeEnable[58],
          7'b0000000, writeEnable[57], 7'b0000000, writeEnable[56], 7'b0000000, writeEnable[55],
          7'b0000000, writeEnable[54], 7'b0000000, writeEnable[53], 7'b0000000, writeEnable[52],
          7'b0000000, writeEnable[51], 7'b0000000, writeEnable[50], 7'b0000000, writeEnable[49],
          7'b0000000, writeEnable[48], 7'b0000000, writeEnable[47], 7'b0000000, writeEnable[46],
          7'b0000000, writeEnable[45], 7'b0000000, writeEnable[44], 7'b0000000, writeEnable[43],
          7'b0000000, writeEnable[42], 7'b0000000, writeEnable[41], 7'b0000000, writeEnable[40],
          7'b0000000, writeEnable[39], 7'b0000000, writeEnable[38], 7'b0000000, writeEnable[37],
          7'b0000000, writeEnable[36], 7'b0000000, writeEnable[35], 7'b0000000, writeEnable[34],
          7'b0000000, writeEnable[33], 7'b0000000, writeEnable[32], 7'b0000000, writeEnable[31],
          7'b0000000, writeEnable[30], 7'b0000000, writeEnable[29], 7'b0000000, writeEnable[28],
          7'b0000000, writeEnable[27], 7'b0000000, writeEnable[26], 7'b0000000, writeEnable[25],
          7'b0000000, writeEnable[24], 7'b0000000, writeEnable[23], 7'b0000000, writeEnable[22],
          7'b0000000, writeEnable[21], 7'b0000000, writeEnable[20], 7'b0000000, writeEnable[19],
          7'b0000000, writeEnable[18], 7'b0000000, writeEnable[17], 7'b0000000, writeEnable[16],
          7'b0000000, writeEnable[15], 7'b0000000, writeEnable[14], 7'b0000000, writeEnable[13],
          7'b0000000, writeEnable[12], 7'b0000000, writeEnable[11], 7'b0000000, writeEnable[10],
          7'b0000000, writeEnable[9], 7'b0000000, writeEnable[8], 7'b0000000, writeEnable[7],
          7'b0000000, writeEnable[6], 7'b0000000, writeEnable[5], 7'b0000000, writeEnable[4],
          7'b0000000, writeEnable[3], 7'b0000000, writeEnable[2], 7'b0000000, writeEnable[1],
          7'b0000000, writeEnable[0]} << mux_address);
        new_data =  ( {7'b0000000, wordtemp[63], 7'b0000000, wordtemp[62], 7'b0000000, wordtemp[61],
          7'b0000000, wordtemp[60], 7'b0000000, wordtemp[59], 7'b0000000, wordtemp[58],
          7'b0000000, wordtemp[57], 7'b0000000, wordtemp[56], 7'b0000000, wordtemp[55],
          7'b0000000, wordtemp[54], 7'b0000000, wordtemp[53], 7'b0000000, wordtemp[52],
          7'b0000000, wordtemp[51], 7'b0000000, wordtemp[50], 7'b0000000, wordtemp[49],
          7'b0000000, wordtemp[48], 7'b0000000, wordtemp[47], 7'b0000000, wordtemp[46],
          7'b0000000, wordtemp[45], 7'b0000000, wordtemp[44], 7'b0000000, wordtemp[43],
          7'b0000000, wordtemp[42], 7'b0000000, wordtemp[41], 7'b0000000, wordtemp[40],
          7'b0000000, wordtemp[39], 7'b0000000, wordtemp[38], 7'b0000000, wordtemp[37],
          7'b0000000, wordtemp[36], 7'b0000000, wordtemp[35], 7'b0000000, wordtemp[34],
          7'b0000000, wordtemp[33], 7'b0000000, wordtemp[32], 7'b0000000, wordtemp[31],
          7'b0000000, wordtemp[30], 7'b0000000, wordtemp[29], 7'b0000000, wordtemp[28],
          7'b0000000, wordtemp[27], 7'b0000000, wordtemp[26], 7'b0000000, wordtemp[25],
          7'b0000000, wordtemp[24], 7'b0000000, wordtemp[23], 7'b0000000, wordtemp[22],
          7'b0000000, wordtemp[21], 7'b0000000, wordtemp[20], 7'b0000000, wordtemp[19],
          7'b0000000, wordtemp[18], 7'b0000000, wordtemp[17], 7'b0000000, wordtemp[16],
          7'b0000000, wordtemp[15], 7'b0000000, wordtemp[14], 7'b0000000, wordtemp[13],
          7'b0000000, wordtemp[12], 7'b0000000, wordtemp[11], 7'b0000000, wordtemp[10],
          7'b0000000, wordtemp[9], 7'b0000000, wordtemp[8], 7'b0000000, wordtemp[7],
          7'b0000000, wordtemp[6], 7'b0000000, wordtemp[5], 7'b0000000, wordtemp[4],
          7'b0000000, wordtemp[3], 7'b0000000, wordtemp[2], 7'b0000000, wordtemp[1],
          7'b0000000, wordtemp[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
  	end
  end
  endtask

task dumpaddr;
	output [63:0] dump_data;
	input [9:0] dump_addr;
	reg [BITS-1:0] wordtemp;
	reg [9:0] Atemp;
  begin
     if (CEN_ === 1'b1) begin
	  Atemp = dump_addr;
	  mux_address = (Atemp & 3'b111);
      row_address = (Atemp >> 3);
      row = mem[row_address];
        writeEnable = {64{1'b1}};
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[504], data_out[496], data_out[488], data_out[480], data_out[472],
          data_out[464], data_out[456], data_out[448], data_out[440], data_out[432],
          data_out[424], data_out[416], data_out[408], data_out[400], data_out[392],
          data_out[384], data_out[376], data_out[368], data_out[360], data_out[352],
          data_out[344], data_out[336], data_out[328], data_out[320], data_out[312],
          data_out[304], data_out[296], data_out[288], data_out[280], data_out[272],
          data_out[264], data_out[256], data_out[248], data_out[240], data_out[232],
          data_out[224], data_out[216], data_out[208], data_out[200], data_out[192],
          data_out[184], data_out[176], data_out[168], data_out[160], data_out[152],
          data_out[144], data_out[136], data_out[128], data_out[120], data_out[112],
          data_out[104], data_out[96], data_out[88], data_out[80], data_out[72], data_out[64],
          data_out[56], data_out[48], data_out[40], data_out[32], data_out[24], data_out[16],
          data_out[8], data_out[0]};
        shifted_readLatch0 = readLatch0;
        mem_path_d = {shifted_readLatch0[63], shifted_readLatch0[62], shifted_readLatch0[61],
          shifted_readLatch0[60], shifted_readLatch0[59], shifted_readLatch0[58], shifted_readLatch0[57],
          shifted_readLatch0[56], shifted_readLatch0[55], shifted_readLatch0[54], shifted_readLatch0[53],
          shifted_readLatch0[52], shifted_readLatch0[51], shifted_readLatch0[50], shifted_readLatch0[49],
          shifted_readLatch0[48], shifted_readLatch0[47], shifted_readLatch0[46], shifted_readLatch0[45],
          shifted_readLatch0[44], shifted_readLatch0[43], shifted_readLatch0[42], shifted_readLatch0[41],
          shifted_readLatch0[40], shifted_readLatch0[39], shifted_readLatch0[38], shifted_readLatch0[37],
          shifted_readLatch0[36], shifted_readLatch0[35], shifted_readLatch0[34], shifted_readLatch0[33],
          shifted_readLatch0[32], shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
   	dump_data = mem_path_d;
  	end
  end
  endtask


  task readWrite;
  begin
    if (RET1N_int === 1'bx || RET1N_int === 1'bz) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (RET1N_int === 1'b0 && CEN_int === 1'b0) begin
    end else if (RET1N_int === 1'b0) begin
      // no cycle in retention mode
    end else if (^{(EMA_int), (EMAW_int), (EMAS_int)} === 1'bx) begin
  if(isBitX(EMAS_int)) begin 
        XQ = 1'b1; Q_update = 1'b1;
  end
  if(isBitX(EMAW_int)) begin 
      failedWrite(0);
  end
  if(isBitX(EMA_int)) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
  end
    end else if (^{CEN_int, (STOV_int && !CEN_int), RET1N_int} === 1'bx) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if ((A_int >= WORDS) && (CEN_int === 1'b0)) begin
        XQ = GWEN_int !== 1'b1 ? 1'b0 : 1'b1; Q_update = GWEN_int !== 1'b1 ? 1'b0 : 1'b1;
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
      if (GWEN_int !== 1'b1)
        failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (CEN_int === 1'b0) begin
      mux_address = (A_int & 3'b111);
      row_address = (A_int >> 3);
      if (row_address > 127)
        row = {512{1'bx}};
      else
        row = mem[row_address];
        writeEnable = ~ {64{GWEN_int}};
      if (GWEN_int !== 1'b1) begin
        row_mask =  ( {7'b0000000, writeEnable[63], 7'b0000000, writeEnable[62], 7'b0000000, writeEnable[61],
          7'b0000000, writeEnable[60], 7'b0000000, writeEnable[59], 7'b0000000, writeEnable[58],
          7'b0000000, writeEnable[57], 7'b0000000, writeEnable[56], 7'b0000000, writeEnable[55],
          7'b0000000, writeEnable[54], 7'b0000000, writeEnable[53], 7'b0000000, writeEnable[52],
          7'b0000000, writeEnable[51], 7'b0000000, writeEnable[50], 7'b0000000, writeEnable[49],
          7'b0000000, writeEnable[48], 7'b0000000, writeEnable[47], 7'b0000000, writeEnable[46],
          7'b0000000, writeEnable[45], 7'b0000000, writeEnable[44], 7'b0000000, writeEnable[43],
          7'b0000000, writeEnable[42], 7'b0000000, writeEnable[41], 7'b0000000, writeEnable[40],
          7'b0000000, writeEnable[39], 7'b0000000, writeEnable[38], 7'b0000000, writeEnable[37],
          7'b0000000, writeEnable[36], 7'b0000000, writeEnable[35], 7'b0000000, writeEnable[34],
          7'b0000000, writeEnable[33], 7'b0000000, writeEnable[32], 7'b0000000, writeEnable[31],
          7'b0000000, writeEnable[30], 7'b0000000, writeEnable[29], 7'b0000000, writeEnable[28],
          7'b0000000, writeEnable[27], 7'b0000000, writeEnable[26], 7'b0000000, writeEnable[25],
          7'b0000000, writeEnable[24], 7'b0000000, writeEnable[23], 7'b0000000, writeEnable[22],
          7'b0000000, writeEnable[21], 7'b0000000, writeEnable[20], 7'b0000000, writeEnable[19],
          7'b0000000, writeEnable[18], 7'b0000000, writeEnable[17], 7'b0000000, writeEnable[16],
          7'b0000000, writeEnable[15], 7'b0000000, writeEnable[14], 7'b0000000, writeEnable[13],
          7'b0000000, writeEnable[12], 7'b0000000, writeEnable[11], 7'b0000000, writeEnable[10],
          7'b0000000, writeEnable[9], 7'b0000000, writeEnable[8], 7'b0000000, writeEnable[7],
          7'b0000000, writeEnable[6], 7'b0000000, writeEnable[5], 7'b0000000, writeEnable[4],
          7'b0000000, writeEnable[3], 7'b0000000, writeEnable[2], 7'b0000000, writeEnable[1],
          7'b0000000, writeEnable[0]} << mux_address);
        new_data =  ( {7'b0000000, D_int[63], 7'b0000000, D_int[62], 7'b0000000, D_int[61],
          7'b0000000, D_int[60], 7'b0000000, D_int[59], 7'b0000000, D_int[58], 7'b0000000, D_int[57],
          7'b0000000, D_int[56], 7'b0000000, D_int[55], 7'b0000000, D_int[54], 7'b0000000, D_int[53],
          7'b0000000, D_int[52], 7'b0000000, D_int[51], 7'b0000000, D_int[50], 7'b0000000, D_int[49],
          7'b0000000, D_int[48], 7'b0000000, D_int[47], 7'b0000000, D_int[46], 7'b0000000, D_int[45],
          7'b0000000, D_int[44], 7'b0000000, D_int[43], 7'b0000000, D_int[42], 7'b0000000, D_int[41],
          7'b0000000, D_int[40], 7'b0000000, D_int[39], 7'b0000000, D_int[38], 7'b0000000, D_int[37],
          7'b0000000, D_int[36], 7'b0000000, D_int[35], 7'b0000000, D_int[34], 7'b0000000, D_int[33],
          7'b0000000, D_int[32], 7'b0000000, D_int[31], 7'b0000000, D_int[30], 7'b0000000, D_int[29],
          7'b0000000, D_int[28], 7'b0000000, D_int[27], 7'b0000000, D_int[26], 7'b0000000, D_int[25],
          7'b0000000, D_int[24], 7'b0000000, D_int[23], 7'b0000000, D_int[22], 7'b0000000, D_int[21],
          7'b0000000, D_int[20], 7'b0000000, D_int[19], 7'b0000000, D_int[18], 7'b0000000, D_int[17],
          7'b0000000, D_int[16], 7'b0000000, D_int[15], 7'b0000000, D_int[14], 7'b0000000, D_int[13],
          7'b0000000, D_int[12], 7'b0000000, D_int[11], 7'b0000000, D_int[10], 7'b0000000, D_int[9],
          7'b0000000, D_int[8], 7'b0000000, D_int[7], 7'b0000000, D_int[6], 7'b0000000, D_int[5],
          7'b0000000, D_int[4], 7'b0000000, D_int[3], 7'b0000000, D_int[2], 7'b0000000, D_int[1],
          7'b0000000, D_int[0]} << mux_address);
        row = (row & ~row_mask) | (row_mask & (~row_mask | new_data));
        mem[row_address] = row;
      end else begin
        data_out = (row >> (mux_address));
        readLatch0 = {data_out[504], data_out[496], data_out[488], data_out[480], data_out[472],
          data_out[464], data_out[456], data_out[448], data_out[440], data_out[432],
          data_out[424], data_out[416], data_out[408], data_out[400], data_out[392],
          data_out[384], data_out[376], data_out[368], data_out[360], data_out[352],
          data_out[344], data_out[336], data_out[328], data_out[320], data_out[312],
          data_out[304], data_out[296], data_out[288], data_out[280], data_out[272],
          data_out[264], data_out[256], data_out[248], data_out[240], data_out[232],
          data_out[224], data_out[216], data_out[208], data_out[200], data_out[192],
          data_out[184], data_out[176], data_out[168], data_out[160], data_out[152],
          data_out[144], data_out[136], data_out[128], data_out[120], data_out[112],
          data_out[104], data_out[96], data_out[88], data_out[80], data_out[72], data_out[64],
          data_out[56], data_out[48], data_out[40], data_out[32], data_out[24], data_out[16],
          data_out[8], data_out[0]};
        shifted_readLatch0 = readLatch0;
        mem_path = {shifted_readLatch0[63], shifted_readLatch0[62], shifted_readLatch0[61],
          shifted_readLatch0[60], shifted_readLatch0[59], shifted_readLatch0[58], shifted_readLatch0[57],
          shifted_readLatch0[56], shifted_readLatch0[55], shifted_readLatch0[54], shifted_readLatch0[53],
          shifted_readLatch0[52], shifted_readLatch0[51], shifted_readLatch0[50], shifted_readLatch0[49],
          shifted_readLatch0[48], shifted_readLatch0[47], shifted_readLatch0[46], shifted_readLatch0[45],
          shifted_readLatch0[44], shifted_readLatch0[43], shifted_readLatch0[42], shifted_readLatch0[41],
          shifted_readLatch0[40], shifted_readLatch0[39], shifted_readLatch0[38], shifted_readLatch0[37],
          shifted_readLatch0[36], shifted_readLatch0[35], shifted_readLatch0[34], shifted_readLatch0[33],
          shifted_readLatch0[32], shifted_readLatch0[31], shifted_readLatch0[30], shifted_readLatch0[29],
          shifted_readLatch0[28], shifted_readLatch0[27], shifted_readLatch0[26], shifted_readLatch0[25],
          shifted_readLatch0[24], shifted_readLatch0[23], shifted_readLatch0[22], shifted_readLatch0[21],
          shifted_readLatch0[20], shifted_readLatch0[19], shifted_readLatch0[18], shifted_readLatch0[17],
          shifted_readLatch0[16], shifted_readLatch0[15], shifted_readLatch0[14], shifted_readLatch0[13],
          shifted_readLatch0[12], shifted_readLatch0[11], shifted_readLatch0[10], shifted_readLatch0[9],
          shifted_readLatch0[8], shifted_readLatch0[7], shifted_readLatch0[6], shifted_readLatch0[5],
          shifted_readLatch0[4], shifted_readLatch0[3], shifted_readLatch0[2], shifted_readLatch0[1],
          shifted_readLatch0[0]};
        	XQ = 1'b0; Q_update = 1'b1;
      end
      if( isBitX(GWEN_int) )  begin
        XQ = 1'b1; Q_update = 1'b1;
      end
    end
  end
  endtask
  always @ (CEN_ or CLK_) begin
  	if(CLK_ == 1'b0) begin
  		CEN_p2 = CEN_;
  	end
  end

`ifdef POWER_PINS
  always @ (VDDCE) begin
      if (VDDCE != 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDCE should be powered down after VDDPE, Illegal power down sequencing in %m at %0t", $time);
       end
        $display("In PowerDown Mode in %m at %0t", $time);
        failedWrite(0);
      end
      if (VDDCE == 1'b1) begin
       if (VDDPE == 1'b1) begin
        $display("VDDPE should be powered up after VDDCE in %m at %0t", $time);
        $display("Illegal power up sequencing in %m at %0t", $time);
       end
        failedWrite(0);
      end
  end
`endif
`ifdef POWER_PINS
  always @ (RET1N_ or VDDPE or VDDCE or VSSE) begin
`else     
  always @ RET1N_ begin
`endif
`ifdef POWER_PINS
    if (RET1N_ == 1'b1 && RET1N_int == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1 && pre_charge_st == 1'b1 && (CEN_ === 1'bx || CLK_ === 1'bx)) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end
`else     
`endif
`ifdef POWER_PINS
`else     
      pre_charge_st = 0;
`endif
    if (RET1N_ === 1'bx || RET1N_ === 1'bz) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (RET1N_ === 1'b0 && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if (RET1N_ === 1'b1 && RET1N_int !== 1'bx && CEN_p2 === 1'b0 ) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end
`ifdef POWER_PINS
    if (RET1N_ == 1'b1 && VDDPE !== 1'b1) begin
        $display("Warning: Illegal value for VDDPE %b in %m at %0t", VDDPE, $time);
        failedWrite(0);
    end else if (RET1N_ == 1'b0 && VDDCE == 1'b1 && VDDPE == 1'b1) begin
      pre_charge_st = 1;
    end else if (RET1N_ == 1'b0 && VDDPE == 1'b0) begin
      pre_charge_st = 0;
      if (VDDCE != 1'b1) begin
        failedWrite(0);
      end
`else     
    if (RET1N_ == 1'b0) begin
`endif
        XQ = 1'b1; Q_update = 1'b1;
      Q_int_delayed = {64{1'bx}};
      CEN_int = 1'bx;
      GWEN_int = 1'bx;
      A_int = {10{1'bx}};
      D_int = {64{1'bx}};
      STOV_int = 1'bx;
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      EMAS_int = 1'bx;
      RET1N_int = 1'bx;
`ifdef POWER_PINS
    end else if (RET1N_ == 1'b1 && VDDCE == 1'b1 && VDDPE == 1'b1) begin
      pre_charge_st = 0;
      XQ = 1'b0;
    end else begin
      pre_charge_st = 0;
`else     
    end else begin
`endif
				#0;
if ($realtime != 0)  XQ = 1'b1;
        Q_update = 1'b1;
      Q_int_delayed = {64{1'bx}};
      CEN_int = 1'bx;
      GWEN_int = 1'bx;
      A_int = {10{1'bx}};
      D_int = {64{1'bx}};
      STOV_int = 1'bx;
      EMA_int = {3{1'bx}};
      EMAW_int = {2{1'bx}};
      EMAS_int = 1'bx;
      RET1N_int = 1'bx;
    end
    #0;
    RET1N_int = RET1N_;
        Q_update = 1'b0;
  end


  always @ CLK_ begin
// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
    if (VDDCE === 1'bx || VDDCE === 1'bz)
      $display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
    if (VDDPE === 1'bx || VDDPE === 1'bz)
      $display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
    if (VSSE === 1'bx || VSSE === 1'bz)
      $display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
`endif
`ifdef POWER_PINS
  if (RET1N_ == 1'b0) begin
`else     
  if (RET1N_ == 1'b0) begin
`endif
      // no cycle in retention mode
`ifdef POWER_PINS
    end else if ((VDDCE === 1'bx || VDDCE === 1'bz)) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
  end else if (RET1N_ == 1'b1 && VDDPE !== 1'b1) begin
  end else if (VSSE !== 1'b0) begin
`endif
  end else begin
    if ((CLK_ === 1'bx || CLK_ === 1'bz) && RET1N_ !== 1'b0) begin
      failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else if ((CLK_ === 1'b1 || CLK_ === 1'b0) && LAST_CLK === 1'bx) begin
       D_sh_update = 1'b0;  XD_sh = 1'b0;
       XD_int = {64{1'b0}};
       XQ = 1'b0; Q_update = 1'b0; 
    end else if (CLK_ === 1'b1 && LAST_CLK === 1'b0) begin
      CEN_int = CEN_;
      STOV_int = STOV_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      EMAS_int = EMAS_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        GWEN_int = GWEN_;
        A_int = A_;
        D_int = D_;
      end
      clk0_int = 1'b0;
      CEN_int = CEN_;
      STOV_int = STOV_;
      EMA_int = EMA_;
      EMAW_int = EMAW_;
      EMAS_int = EMAS_;
      RET1N_int = RET1N_;
      if (CEN_int != 1'b1) begin
        GWEN_int = GWEN_;
        A_int = A_;
        D_int = D_;
      end
      clk0_int = 1'b0;
      if (CEN_int === 1'b0 && GWEN_int === 1'b1) 
         Q_int_delayed = {64{1'bx}};
    readWrite;
    end else if (CLK_ === 1'b0 && LAST_CLK === 1'b1) begin
      Q_int_delayed = Q_int;
      Q_update = 1'b0;
      D_sh_update = 1'b0;
      XQ = 1'b0;
       XD_int = {64{1'b0}};
    end
  end
    LAST_CLK = CLK_;
  end

  reg globalNotifier0;
  initial globalNotifier0 = 1'b0;

  always @ globalNotifier0 begin
    if ($realtime == 0) begin
    end else if (CEN_int === 1'bx || RET1N_int === 1'bx || (STOV_int && !CEN_int) === 1'bx || 
      clk0_int === 1'bx) begin
        XQ = 1'b1; Q_update = 1'b1;
    	 mem_path = {64{1'bx}};
      Q_int_delayed = {64{1'bx}};
      failedWrite(0);
    end else if (CEN_int === 1'b0 && (^A_int) === 1'bx) begin
        failedWrite(0);
        XQ = 1'b1; Q_update = 1'b1;
    end else begin
      #0;
      readWrite;
   end
      #0;
        XQ = 1'b0; Q_update = 1'b0;
    globalNotifier0 = 1'b0;
  end

  assign D_int_bmux = D_;

  datapath_latch_tsmc16_1rw_1024_64b uDQ0 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(1'b0), .D(D_int_bmux[0]), .DFTRAMBYP(1'b0), .mem_path(mem_path[0]), .XQ(XQ|XD_int[0]|1'b0), .Q(Q_int[0]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ1 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[0]), .D(D_int_bmux[1]), .DFTRAMBYP(1'b0), .mem_path(mem_path[1]), .XQ(XQ|XD_int[1]), .Q(Q_int[1]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ2 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[1]), .D(D_int_bmux[2]), .DFTRAMBYP(1'b0), .mem_path(mem_path[2]), .XQ(XQ|XD_int[2]), .Q(Q_int[2]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ3 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[2]), .D(D_int_bmux[3]), .DFTRAMBYP(1'b0), .mem_path(mem_path[3]), .XQ(XQ|XD_int[3]), .Q(Q_int[3]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ4 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[3]), .D(D_int_bmux[4]), .DFTRAMBYP(1'b0), .mem_path(mem_path[4]), .XQ(XQ|XD_int[4]), .Q(Q_int[4]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ5 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[4]), .D(D_int_bmux[5]), .DFTRAMBYP(1'b0), .mem_path(mem_path[5]), .XQ(XQ|XD_int[5]), .Q(Q_int[5]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ6 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[5]), .D(D_int_bmux[6]), .DFTRAMBYP(1'b0), .mem_path(mem_path[6]), .XQ(XQ|XD_int[6]), .Q(Q_int[6]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ7 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[6]), .D(D_int_bmux[7]), .DFTRAMBYP(1'b0), .mem_path(mem_path[7]), .XQ(XQ|XD_int[7]), .Q(Q_int[7]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ8 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[7]), .D(D_int_bmux[8]), .DFTRAMBYP(1'b0), .mem_path(mem_path[8]), .XQ(XQ|XD_int[8]), .Q(Q_int[8]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ9 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[8]), .D(D_int_bmux[9]), .DFTRAMBYP(1'b0), .mem_path(mem_path[9]), .XQ(XQ|XD_int[9]), .Q(Q_int[9]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ10 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[9]), .D(D_int_bmux[10]), .DFTRAMBYP(1'b0), .mem_path(mem_path[10]), .XQ(XQ|XD_int[10]), .Q(Q_int[10]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ11 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[10]), .D(D_int_bmux[11]), .DFTRAMBYP(1'b0), .mem_path(mem_path[11]), .XQ(XQ|XD_int[11]), .Q(Q_int[11]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ12 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[11]), .D(D_int_bmux[12]), .DFTRAMBYP(1'b0), .mem_path(mem_path[12]), .XQ(XQ|XD_int[12]), .Q(Q_int[12]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ13 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[12]), .D(D_int_bmux[13]), .DFTRAMBYP(1'b0), .mem_path(mem_path[13]), .XQ(XQ|XD_int[13]), .Q(Q_int[13]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ14 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[13]), .D(D_int_bmux[14]), .DFTRAMBYP(1'b0), .mem_path(mem_path[14]), .XQ(XQ|XD_int[14]), .Q(Q_int[14]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ15 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[14]), .D(D_int_bmux[15]), .DFTRAMBYP(1'b0), .mem_path(mem_path[15]), .XQ(XQ|XD_int[15]), .Q(Q_int[15]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ16 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[15]), .D(D_int_bmux[16]), .DFTRAMBYP(1'b0), .mem_path(mem_path[16]), .XQ(XQ|XD_int[16]), .Q(Q_int[16]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ17 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[16]), .D(D_int_bmux[17]), .DFTRAMBYP(1'b0), .mem_path(mem_path[17]), .XQ(XQ|XD_int[17]), .Q(Q_int[17]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ18 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[17]), .D(D_int_bmux[18]), .DFTRAMBYP(1'b0), .mem_path(mem_path[18]), .XQ(XQ|XD_int[18]), .Q(Q_int[18]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ19 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[18]), .D(D_int_bmux[19]), .DFTRAMBYP(1'b0), .mem_path(mem_path[19]), .XQ(XQ|XD_int[19]), .Q(Q_int[19]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ20 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[19]), .D(D_int_bmux[20]), .DFTRAMBYP(1'b0), .mem_path(mem_path[20]), .XQ(XQ|XD_int[20]), .Q(Q_int[20]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ21 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[20]), .D(D_int_bmux[21]), .DFTRAMBYP(1'b0), .mem_path(mem_path[21]), .XQ(XQ|XD_int[21]), .Q(Q_int[21]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ22 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[21]), .D(D_int_bmux[22]), .DFTRAMBYP(1'b0), .mem_path(mem_path[22]), .XQ(XQ|XD_int[22]), .Q(Q_int[22]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ23 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[22]), .D(D_int_bmux[23]), .DFTRAMBYP(1'b0), .mem_path(mem_path[23]), .XQ(XQ|XD_int[23]), .Q(Q_int[23]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ24 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[23]), .D(D_int_bmux[24]), .DFTRAMBYP(1'b0), .mem_path(mem_path[24]), .XQ(XQ|XD_int[24]), .Q(Q_int[24]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ25 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[24]), .D(D_int_bmux[25]), .DFTRAMBYP(1'b0), .mem_path(mem_path[25]), .XQ(XQ|XD_int[25]), .Q(Q_int[25]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ26 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[25]), .D(D_int_bmux[26]), .DFTRAMBYP(1'b0), .mem_path(mem_path[26]), .XQ(XQ|XD_int[26]), .Q(Q_int[26]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ27 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[26]), .D(D_int_bmux[27]), .DFTRAMBYP(1'b0), .mem_path(mem_path[27]), .XQ(XQ|XD_int[27]), .Q(Q_int[27]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ28 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[27]), .D(D_int_bmux[28]), .DFTRAMBYP(1'b0), .mem_path(mem_path[28]), .XQ(XQ|XD_int[28]), .Q(Q_int[28]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ29 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[28]), .D(D_int_bmux[29]), .DFTRAMBYP(1'b0), .mem_path(mem_path[29]), .XQ(XQ|XD_int[29]), .Q(Q_int[29]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ30 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[29]), .D(D_int_bmux[30]), .DFTRAMBYP(1'b0), .mem_path(mem_path[30]), .XQ(XQ|XD_int[30]), .Q(Q_int[30]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ31 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[30]), .D(D_int_bmux[31]), .DFTRAMBYP(1'b0), .mem_path(mem_path[31]), .XQ(XQ|XD_int[31]), .Q(Q_int[31]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ32 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[33]), .D(D_int_bmux[32]), .DFTRAMBYP(1'b0), .mem_path(mem_path[32]), .XQ(XQ|XD_int[32]), .Q(Q_int[32]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ33 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[34]), .D(D_int_bmux[33]), .DFTRAMBYP(1'b0), .mem_path(mem_path[33]), .XQ(XQ|XD_int[33]), .Q(Q_int[33]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ34 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[35]), .D(D_int_bmux[34]), .DFTRAMBYP(1'b0), .mem_path(mem_path[34]), .XQ(XQ|XD_int[34]), .Q(Q_int[34]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ35 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[36]), .D(D_int_bmux[35]), .DFTRAMBYP(1'b0), .mem_path(mem_path[35]), .XQ(XQ|XD_int[35]), .Q(Q_int[35]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ36 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[37]), .D(D_int_bmux[36]), .DFTRAMBYP(1'b0), .mem_path(mem_path[36]), .XQ(XQ|XD_int[36]), .Q(Q_int[36]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ37 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[38]), .D(D_int_bmux[37]), .DFTRAMBYP(1'b0), .mem_path(mem_path[37]), .XQ(XQ|XD_int[37]), .Q(Q_int[37]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ38 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[39]), .D(D_int_bmux[38]), .DFTRAMBYP(1'b0), .mem_path(mem_path[38]), .XQ(XQ|XD_int[38]), .Q(Q_int[38]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ39 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[40]), .D(D_int_bmux[39]), .DFTRAMBYP(1'b0), .mem_path(mem_path[39]), .XQ(XQ|XD_int[39]), .Q(Q_int[39]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ40 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[41]), .D(D_int_bmux[40]), .DFTRAMBYP(1'b0), .mem_path(mem_path[40]), .XQ(XQ|XD_int[40]), .Q(Q_int[40]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ41 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[42]), .D(D_int_bmux[41]), .DFTRAMBYP(1'b0), .mem_path(mem_path[41]), .XQ(XQ|XD_int[41]), .Q(Q_int[41]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ42 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[43]), .D(D_int_bmux[42]), .DFTRAMBYP(1'b0), .mem_path(mem_path[42]), .XQ(XQ|XD_int[42]), .Q(Q_int[42]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ43 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[44]), .D(D_int_bmux[43]), .DFTRAMBYP(1'b0), .mem_path(mem_path[43]), .XQ(XQ|XD_int[43]), .Q(Q_int[43]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ44 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[45]), .D(D_int_bmux[44]), .DFTRAMBYP(1'b0), .mem_path(mem_path[44]), .XQ(XQ|XD_int[44]), .Q(Q_int[44]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ45 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[46]), .D(D_int_bmux[45]), .DFTRAMBYP(1'b0), .mem_path(mem_path[45]), .XQ(XQ|XD_int[45]), .Q(Q_int[45]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ46 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[47]), .D(D_int_bmux[46]), .DFTRAMBYP(1'b0), .mem_path(mem_path[46]), .XQ(XQ|XD_int[46]), .Q(Q_int[46]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ47 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[48]), .D(D_int_bmux[47]), .DFTRAMBYP(1'b0), .mem_path(mem_path[47]), .XQ(XQ|XD_int[47]), .Q(Q_int[47]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ48 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[49]), .D(D_int_bmux[48]), .DFTRAMBYP(1'b0), .mem_path(mem_path[48]), .XQ(XQ|XD_int[48]), .Q(Q_int[48]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ49 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[50]), .D(D_int_bmux[49]), .DFTRAMBYP(1'b0), .mem_path(mem_path[49]), .XQ(XQ|XD_int[49]), .Q(Q_int[49]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ50 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[51]), .D(D_int_bmux[50]), .DFTRAMBYP(1'b0), .mem_path(mem_path[50]), .XQ(XQ|XD_int[50]), .Q(Q_int[50]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ51 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[52]), .D(D_int_bmux[51]), .DFTRAMBYP(1'b0), .mem_path(mem_path[51]), .XQ(XQ|XD_int[51]), .Q(Q_int[51]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ52 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[53]), .D(D_int_bmux[52]), .DFTRAMBYP(1'b0), .mem_path(mem_path[52]), .XQ(XQ|XD_int[52]), .Q(Q_int[52]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ53 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[54]), .D(D_int_bmux[53]), .DFTRAMBYP(1'b0), .mem_path(mem_path[53]), .XQ(XQ|XD_int[53]), .Q(Q_int[53]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ54 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[55]), .D(D_int_bmux[54]), .DFTRAMBYP(1'b0), .mem_path(mem_path[54]), .XQ(XQ|XD_int[54]), .Q(Q_int[54]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ55 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[56]), .D(D_int_bmux[55]), .DFTRAMBYP(1'b0), .mem_path(mem_path[55]), .XQ(XQ|XD_int[55]), .Q(Q_int[55]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ56 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[57]), .D(D_int_bmux[56]), .DFTRAMBYP(1'b0), .mem_path(mem_path[56]), .XQ(XQ|XD_int[56]), .Q(Q_int[56]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ57 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[58]), .D(D_int_bmux[57]), .DFTRAMBYP(1'b0), .mem_path(mem_path[57]), .XQ(XQ|XD_int[57]), .Q(Q_int[57]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ58 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[59]), .D(D_int_bmux[58]), .DFTRAMBYP(1'b0), .mem_path(mem_path[58]), .XQ(XQ|XD_int[58]), .Q(Q_int[58]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ59 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[60]), .D(D_int_bmux[59]), .DFTRAMBYP(1'b0), .mem_path(mem_path[59]), .XQ(XQ|XD_int[59]), .Q(Q_int[59]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ60 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[61]), .D(D_int_bmux[60]), .DFTRAMBYP(1'b0), .mem_path(mem_path[60]), .XQ(XQ|XD_int[60]), .Q(Q_int[60]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ61 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[62]), .D(D_int_bmux[61]), .DFTRAMBYP(1'b0), .mem_path(mem_path[61]), .XQ(XQ|XD_int[61]), .Q(Q_int[61]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ62 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(Q_int[63]), .D(D_int_bmux[62]), .DFTRAMBYP(1'b0), .mem_path(mem_path[62]), .XQ(XQ|XD_int[62]), .Q(Q_int[62]));
  datapath_latch_tsmc16_1rw_1024_64b uDQ63 (.CLK(CLK), .Q_update(Q_update), .D_update(D_sh_update), .SE(1'b0), .SI(1'b0), .D(D_int_bmux[63]), .DFTRAMBYP(1'b0), .mem_path(mem_path[63]), .XQ(XQ|XD_int[63]|1'b0), .Q(Q_int[63]));


// If POWER_PINS is defined at Simulator Command Line, it selects the module definition with Power Ports
`ifdef POWER_PINS
	always @ (VDDCE or VDDPE or VSSE) begin
		if (VDDCE === 1'bx || VDDCE === 1'bz) begin
			$display("Warning: Unknown value for VDDCE %b in %m at %0t", VDDCE, $time);
        XQ = 1'b1; Q_update = 1'b1;
			failedWrite(0);
			bad_VDDCE = 1'b1;
		end else begin
			bad_VDDCE = 1'b0;
		end
		if (RET1N_ == 1'b1 && VDDPE !== 1'b1) begin
			$display("Warning: Unknown value for VDDPE %b in %m at %0t", VDDPE, $time);
        XQ = 1'b1; Q_update = 1'b1;
			failedWrite(0);
			bad_VDDPE = 1'b1;
		end else begin
			bad_VDDPE = 1'b0;
		end
		if (VSSE !== 1'b0) begin
			$display("Warning: Unknown value for VSSE %b in %m at %0t", VSSE, $time);
        XQ = 1'b1; Q_update = 1'b1;
			failedWrite(0);
			bad_VSSE = 1'b1;
		end else begin
			bad_VSSE = 1'b0;
		end
		bad_power = bad_VDDCE | bad_VDDPE | bad_VSSE ;
	end
`endif

  always @ NOT_CEN begin
    CEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_GWEN begin
    GWEN_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A9 begin
    A_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A8 begin
    A_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A7 begin
    A_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A6 begin
    A_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A5 begin
    A_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A4 begin
    A_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A3 begin
    A_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A2 begin
    A_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A1 begin
    A_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_A0 begin
    A_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D63 begin
    D_int[63] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D62 begin
    D_int[62] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D61 begin
    D_int[61] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D60 begin
    D_int[60] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D59 begin
    D_int[59] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D58 begin
    D_int[58] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D57 begin
    D_int[57] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D56 begin
    D_int[56] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D55 begin
    D_int[55] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D54 begin
    D_int[54] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D53 begin
    D_int[53] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D52 begin
    D_int[52] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D51 begin
    D_int[51] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D50 begin
    D_int[50] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D49 begin
    D_int[49] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D48 begin
    D_int[48] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D47 begin
    D_int[47] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D46 begin
    D_int[46] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D45 begin
    D_int[45] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D44 begin
    D_int[44] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D43 begin
    D_int[43] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D42 begin
    D_int[42] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D41 begin
    D_int[41] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D40 begin
    D_int[40] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D39 begin
    D_int[39] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D38 begin
    D_int[38] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D37 begin
    D_int[37] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D36 begin
    D_int[36] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D35 begin
    D_int[35] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D34 begin
    D_int[34] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D33 begin
    D_int[33] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D32 begin
    D_int[32] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D31 begin
    D_int[31] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D30 begin
    D_int[30] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D29 begin
    D_int[29] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D28 begin
    D_int[28] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D27 begin
    D_int[27] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D26 begin
    D_int[26] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D25 begin
    D_int[25] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D24 begin
    D_int[24] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D23 begin
    D_int[23] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D22 begin
    D_int[22] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D21 begin
    D_int[21] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D20 begin
    D_int[20] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D19 begin
    D_int[19] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D18 begin
    D_int[18] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D17 begin
    D_int[17] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D16 begin
    D_int[16] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D15 begin
    D_int[15] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D14 begin
    D_int[14] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D13 begin
    D_int[13] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D12 begin
    D_int[12] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D11 begin
    D_int[11] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D10 begin
    D_int[10] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D9 begin
    D_int[9] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D8 begin
    D_int[8] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D7 begin
    D_int[7] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D6 begin
    D_int[6] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D5 begin
    D_int[5] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D4 begin
    D_int[4] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D3 begin
    D_int[3] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D2 begin
    D_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D1 begin
    D_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_D0 begin
    D_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_STOV begin
    STOV_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA2 begin
    EMA_int[2] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA1 begin
    EMA_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMA0 begin
    EMA_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAW1 begin
    EMAW_int[1] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAW0 begin
    EMAW_int[0] = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_EMAS begin
    EMAS_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_RET1N begin
    RET1N_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end

  always @ NOT_CLK_PER begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINH begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end
  always @ NOT_CLK_MINL begin
    clk0_int = 1'bx;
    if ( globalNotifier0 === 1'b0 ) globalNotifier0 = 1'bx;
  end



  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1;
  wire STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1;
  wire STOVeq1aRET1Neq1, STOVeq0aRET1Neq1aCENeq0, STOVeq1aRET1Neq1aCENeq0, RET1Neq1;
  wire RET1Neq1aCENeq0aGWENeq0, RET1Neq1aCENeq0;

  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&!EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&!EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&!EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&!EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&!EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&!EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;
  assign STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1 = 
  !STOV&&RET1N&&EMA[2]&&EMA[1]&&EMA[0]&&EMAW[1]&&EMAW[0]&&EMAS;


  assign STOVeq0aRET1Neq1aCENeq0 = !STOV&&RET1N&&!CEN;
  assign STOVeq1aRET1Neq1aCENeq0 = STOV&&RET1N&&!CEN;
  assign RET1Neq1aCENeq0aGWENeq0 = RET1N&&!CEN&&!GWEN;

  assign STOVeq1aRET1Neq1 = STOV&&RET1N;
  assign RET1Neq1 = RET1N;
  assign RET1Neq1aCENeq0 = RET1N&&!CEN;

  specify

    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b0 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b0)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b0 && EMA[0] == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b0)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[63] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[62] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[61] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[60] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[59] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[58] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[57] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[56] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[55] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[54] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[53] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[52] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[51] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[50] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[49] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[48] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[47] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[46] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[45] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[44] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[43] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[42] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[41] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[40] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[39] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[38] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[37] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[36] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[35] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[34] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[33] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[32] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[31] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[30] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[29] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[28] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[27] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[26] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[25] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[24] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[23] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[22] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[21] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[20] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[19] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[18] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[17] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[16] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[15] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[14] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[13] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[12] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[11] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[10] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[9] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[8] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[7] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[6] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[5] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[4] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[3] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[2] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[1] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);
    if (RET1N == 1'b1 && GWEN == 1'b1 && EMA[2] == 1'b1 && EMA[1] == 1'b1 && EMA[0] == 1'b1)
       (posedge CLK => (Q[0] : 1'b0)) = (`ARM_MEM_PROP, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP, `ARM_MEM_RETAIN, `ARM_MEM_PROP);


   // Define SDTC only if back-annotating SDF file generated by Design Compiler
   `ifdef NO_SDTC
       $period(posedge CLK, `ARM_MEM_PERIOD, NOT_CLK_PER);
   `else
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq0, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq0aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq0aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq0aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq0aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq0aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq0aRET1Neq1aEMA2eq1aEMA1eq1aEMA0eq1aEMAW1eq1aEMAW0eq1aEMASeq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
       $period(posedge CLK &&& STOVeq1aRET1Neq1, `ARM_MEM_PERIOD, NOT_CLK_PER);
   `endif


   // Define SDTC only if back-annotating SDF file generated by Design Compiler
   `ifdef NO_SDTC
       $width(posedge CLK, `ARM_MEM_WIDTH, 0, NOT_CLK_MINH);
       $width(negedge CLK, `ARM_MEM_WIDTH, 0, NOT_CLK_MINL);
   `else
       $width(posedge CLK &&& STOVeq0aRET1Neq1aCENeq0, `ARM_MEM_WIDTH, 0, NOT_CLK_MINH);
       $width(posedge CLK &&& STOVeq1aRET1Neq1aCENeq0, `ARM_MEM_WIDTH, 0, NOT_CLK_MINH);
       $width(negedge CLK &&& STOVeq0aRET1Neq1aCENeq0, `ARM_MEM_WIDTH, 0, NOT_CLK_MINL);
       $width(negedge CLK &&& STOVeq1aRET1Neq1aCENeq0, `ARM_MEM_WIDTH, 0, NOT_CLK_MINL);
   `endif

    $setuphold(posedge CLK &&& RET1Neq1, posedge CEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_CEN);
    $setuphold(posedge CLK &&& RET1Neq1, negedge CEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_CEN);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge GWEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_GWEN);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge GWEN, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_GWEN);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A9);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A8);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge A[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A9);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A8);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge A[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_A0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[63], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D63);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[62], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D62);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[61], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D61);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[60], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D60);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[59], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D59);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[58], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D58);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[57], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D57);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[56], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D56);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[55], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D55);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[54], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D54);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[53], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D53);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[52], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D52);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[51], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D51);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[50], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D50);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[49], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D49);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[48], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D48);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[47], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D47);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[46], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D46);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[45], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D45);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[44], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D44);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[43], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D43);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[42], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D42);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[41], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D41);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[40], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D40);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[39], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D39);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[38], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D38);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[37], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D37);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[36], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D36);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[35], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D35);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[34], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D34);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[33], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D33);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[32], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D32);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[31], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D31);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[30], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D30);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[29], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D29);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[28], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D28);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[27], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D27);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[26], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D26);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[25], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D25);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[24], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D24);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[23], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D23);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[22], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D22);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[21], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D21);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[20], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D20);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[19], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D19);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[18], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D18);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[17], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D17);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[16], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D16);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[15], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D15);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[14], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D14);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[13], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D13);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[12], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D12);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[11], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D11);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[10], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D10);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D9);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D8);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, posedge D[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[63], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D63);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[62], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D62);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[61], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D61);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[60], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D60);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[59], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D59);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[58], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D58);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[57], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D57);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[56], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D56);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[55], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D55);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[54], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D54);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[53], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D53);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[52], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D52);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[51], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D51);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[50], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D50);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[49], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D49);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[48], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D48);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[47], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D47);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[46], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D46);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[45], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D45);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[44], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D44);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[43], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D43);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[42], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D42);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[41], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D41);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[40], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D40);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[39], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D39);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[38], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D38);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[37], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D37);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[36], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D36);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[35], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D35);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[34], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D34);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[33], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D33);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[32], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D32);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[31], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D31);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[30], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D30);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[29], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D29);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[28], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D28);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[27], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D27);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[26], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D26);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[25], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D25);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[24], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D24);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[23], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D23);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[22], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D22);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[21], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D21);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[20], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D20);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[19], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D19);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[18], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D18);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[17], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D17);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[16], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D16);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[15], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D15);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[14], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D14);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[13], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D13);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[12], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D12);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[11], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D11);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[10], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D10);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[9], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D9);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[8], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D8);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[7], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D7);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[6], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D6);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[5], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D5);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[4], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D4);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[3], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D3);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0aGWENeq0, negedge D[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_D0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge STOV, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_STOV);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge STOV, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_STOV);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMA[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMA[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMA[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMA[2], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA2);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMA[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMA[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMA0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMAW[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMAW[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMAW[1], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW1);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMAW[0], `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAW0);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, posedge EMAS, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAS);
    $setuphold(posedge CLK &&& RET1Neq1aCENeq0, negedge EMAS, `ARM_MEM_SETUP, `ARM_MEM_HOLD, NOT_EMAS);
    $setuphold(negedge RET1N, negedge CEN, 0.000, `ARM_MEM_HOLD, NOT_RET1N);
    $setuphold(posedge RET1N, negedge CEN, 0.000, `ARM_MEM_HOLD, NOT_RET1N);
    $setuphold(posedge CEN, posedge RET1N, 0.000, `ARM_MEM_HOLD, NOT_RET1N);
    $setuphold(posedge CEN, negedge RET1N, 0.000, `ARM_MEM_HOLD, NOT_RET1N);
  endspecify


endmodule
`endcelldefine
`endif
`endif
`timescale 1ns/1ps
module tsmc16_1rw_1024_64b_error_injection (Q_out, Q_in, CLK, A, CEN, WEN, GWEN);
   output [63:0] Q_out;
   input [63:0] Q_in;
   input CLK;
   input [9:0] A;
   input CEN;
   input WEN;
   input GWEN;
   parameter LEFT_RED_COLUMN_FAULT = 2'd1;
   parameter RIGHT_RED_COLUMN_FAULT = 2'd2;
   parameter NO_RED_FAULT = 2'd0;
   reg [63:0] Q_out;
   reg entry_found;
   reg list_complete;
   reg [20:0] fault_table [127:0];
   reg [20:0] fault_entry;
initial
begin
   `ifdef DUT
      `define pre_pend_path TB.DUT_inst.CHIP
   `else
       `define pre_pend_path TB.CHIP
   `endif
   `ifdef ARM_NONREPAIRABLE_FAULT
      `pre_pend_path.SMARCHCHKBVCD_LVISION_MBISTPG_ASSEMBLY_UNDER_TEST_INST.MEM0_MEM_INST.u1.add_fault(10'd754,6'd6,2'd1,2'd0);
   `endif
end
   task add_fault;
   //This task injects fault in memory
      input [9:0] address;
      input [5:0] bitPlace;
      input [1:0] fault_type;
      input [1:0] red_fault;
 
      integer i;
      reg done;
   begin
      done = 1'b0;
      i = 0;
      while ((!done) && i < 127)
      begin
         fault_entry = fault_table[i];
         if (fault_entry[0] === 1'b0 || fault_entry[0] === 1'bx)
         begin
            fault_entry[0] = 1'b1;
            fault_entry[2:1] = red_fault;
            fault_entry[4:3] = fault_type;
            fault_entry[10:5] = bitPlace;
            fault_entry[20:11] = address;
            fault_table[i] = fault_entry;
            done = 1'b1;
         end
         i = i+1;
      end
   end
   endtask
//This task removes all fault entries injected by user
task remove_all_faults;
   integer i;
begin
   for (i = 0; i < 128; i=i+1)
   begin
      fault_entry = fault_table[i];
      fault_entry[0] = 1'b0;
      fault_table[i] = fault_entry;
   end
end
endtask
task bit_error;
// This task is used to inject error in memory and should be called
// only from current module.
//
// This task injects error depending upon fault type to particular bit
// of the output
   inout [63:0] q_int;
   input [1:0] fault_type;
   input [5:0] bitLoc;
begin
   if (fault_type === 2'd0)
      q_int[bitLoc] = 1'b0;
   else if (fault_type === 2'd1)
      q_int[bitLoc] = 1'b1;
   else
      q_int[bitLoc] = ~q_int[bitLoc];
end
endtask
task error_injection_on_output;
// This function goes through error injection table for every
// read cycle and corrupts Q output if fault for the particular
// address is present in fault table
//
// If fault is redundant column is detected, this task corrupts
// Q output in read cycle
//
// If fault is repaired using repair bus, this task does not
// courrpt Q output in read cycle
//
   output [63:0] Q_output;
   reg list_complete;
   integer i;
   reg [4:0] FRA_reg;
   reg [6:0] row_address;
   reg [2:0] column_address;
   reg [5:0] bitPlace;
   reg [1:0] fault_type;
   reg [1:0] red_fault;
   reg valid;
   reg [5:0] msb_bit_calc;
begin
   entry_found = 1'b0;
   list_complete = 1'b0;
   i = 0;
   Q_output = Q_in;
   while(!list_complete)
   begin
      fault_entry = fault_table[i];
      {row_address, column_address, bitPlace, fault_type, red_fault, valid} = fault_entry;
      FRA_reg = row_address/4;
      i = i + 1;
      if (valid == 1'b1)
      begin
         if (red_fault === NO_RED_FAULT)
         begin
            if (row_address == A[9:3] && column_address == A[2:0])
            begin
               if (bitPlace < 32)
                  bit_error(Q_output,fault_type, bitPlace);
               else if (bitPlace >= 32 )
                  bit_error(Q_output,fault_type, bitPlace);
            end
         end
      end
      else
         list_complete = 1'b1;
      end
   end
   endtask
   always @ (Q_in or CLK or A or CEN or WEN or GWEN)
   begin
   if (CEN === 1'b0 && &WEN === 1'b1 && GWEN === 1'b1)
      error_injection_on_output(Q_out);
   else
      Q_out = Q_in;
   end
endmodule
`endif
