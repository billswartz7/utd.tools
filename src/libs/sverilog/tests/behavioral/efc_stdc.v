// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: efc_stdc.v
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
//
//    Cluster Name:  Efuse Cluster
//    Unit Name:  efc_stdc (Efuse Standard Cell)
//    Block Name: EFC
//
//
//-----------------------------------------------------------------------------
`include "sys.h"
`include "iop.h"

module efc_stdc (/*AUTOARG*/
   // Outputs
   efc_ctu_data_out, efc_spc1357_fuse_clk1, efc_spc1357_fuse_clk2, 
   efc_spc0246_fuse_clk1, efc_spc0246_fuse_clk2, 
   efc_spc1357_fuse_data, efc_spc0246_fuse_data, 
   efc_spc7_ifuse_ashift, efc_spc7_ifuse_dshift, 
   efc_spc7_dfuse_ashift, efc_spc7_dfuse_dshift, 
   efc_spc6_ifuse_ashift, efc_spc6_ifuse_dshift, 
   efc_spc6_dfuse_ashift, efc_spc6_dfuse_dshift, 
   efc_spc5_ifuse_ashift, efc_spc5_ifuse_dshift, 
   efc_spc5_dfuse_ashift, efc_spc5_dfuse_dshift, 
   efc_spc4_ifuse_ashift, efc_spc4_ifuse_dshift, 
   efc_spc4_dfuse_ashift, efc_spc4_dfuse_dshift, 
   efc_spc3_ifuse_ashift, efc_spc3_ifuse_dshift, 
   efc_spc3_dfuse_ashift, efc_spc3_dfuse_dshift, 
   efc_spc2_ifuse_ashift, efc_spc2_ifuse_dshift, 
   efc_spc2_dfuse_ashift, efc_spc2_dfuse_dshift, 
   efc_spc1_ifuse_ashift, efc_spc1_ifuse_dshift, 
   efc_spc1_dfuse_ashift, efc_spc1_dfuse_dshift, 
   efc_spc0_ifuse_ashift, efc_spc0_ifuse_dshift, 
   efc_spc0_dfuse_ashift, efc_spc0_dfuse_dshift, 
   efc_sctag02_fuse_clk1, efc_sctag02_fuse_clk2, 
   efc_sctag02_fuse_data, efc_sctag13_fuse_clk1, 
   efc_sctag13_fuse_clk2, efc_sctag13_fuse_data, 
   efc_sctag3_fuse_ashift, efc_sctag3_fuse_dshift, 
   efc_sctag2_fuse_ashift, efc_sctag2_fuse_dshift, 
   efc_sctag1_fuse_ashift, efc_sctag1_fuse_dshift, 
   efc_sctag0_fuse_ashift, efc_sctag0_fuse_dshift, 
   efc_scdata02_fuse_clk1, efc_scdata02_fuse_clk2, 
   efc_scdata02_fuse_data, efc_scdata13_fuse_clk1, 
   efc_scdata13_fuse_clk2, efc_scdata13_fuse_data, 
   efc_scdata3_fuse_ashift, efc_scdata3_fuse_dshift, 
   efc_scdata2_fuse_ashift, efc_scdata2_fuse_dshift, 
   efc_scdata1_fuse_ashift, efc_scdata1_fuse_dshift, 
   efc_scdata0_fuse_ashift, efc_scdata0_fuse_dshift, 
   efc_iob_fuse_clk1, efc_iob_fuse_data, efc_iob_sernum0_dshift, 
   efc_iob_sernum1_dshift, efc_iob_sernum2_dshift, 
   efc_iob_fusestat_dshift, efc_iob_coreavail_dshift, 
   sbc_efa_read_en, sbc_efa_word_addr, sbc_efa_bit_addr, 
   sbc_efa_margin0_rd, sbc_efa_margin1_rd, pwr_ok, por_n, 
   sbc_efa_sup_det_rd, sbc_efa_power_down, 
   // Inputs
   clk, efc_rst_l, jbus_arst_l, testmode_l, ctu_efc_rowaddr, 
   ctu_efc_coladdr, ctu_efc_read_en, ctu_efc_read_mode, 
   ctu_efc_read_start, ctu_efc_fuse_bypass, ctu_efc_dest_sample, 
   ctu_efc_data_in, ctu_efc_updatedr, ctu_efc_shiftdr, 
   ctu_efc_capturedr, tck, spc7_efc_ifuse_data, spc7_efc_dfuse_data, 
   spc6_efc_ifuse_data, spc6_efc_dfuse_data, spc5_efc_ifuse_data, 
   spc5_efc_dfuse_data, spc4_efc_ifuse_data, spc4_efc_dfuse_data, 
   spc3_efc_ifuse_data, spc3_efc_dfuse_data, spc2_efc_ifuse_data, 
   spc2_efc_dfuse_data, spc1_efc_ifuse_data, spc1_efc_dfuse_data, 
   spc0_efc_ifuse_data, spc0_efc_dfuse_data, sctag3_efc_fuse_data, 
   sctag2_efc_fuse_data, sctag1_efc_fuse_data, sctag0_efc_fuse_data, 
   scdata3_efc_fuse_data, scdata2_efc_fuse_data, 
   scdata1_efc_fuse_data, scdata0_efc_fuse_data, efa_sbc_data
   );
//-----------------------------------------------------------------------------
//  I/O declarations
//-----------------------------------------------------------------------------
// Chip Primary Inputs/Globals

input   clk;
input	efc_rst_l;
input	jbus_arst_l;		// JBus clock domain async reset.
input	testmode_l;

// CTU/JTAG Interface

input [6:0]   ctu_efc_rowaddr;
input [4:0]   ctu_efc_coladdr;

input         ctu_efc_read_en;	// Read Enable
input [2:0]   ctu_efc_read_mode; // 00=normal, 01=margin0, 10=1A, 11=1B
input         ctu_efc_read_start; // Start SM for scanning bits out
input         ctu_efc_fuse_bypass; //ctu_efc_fuse_bypass 
input         ctu_efc_dest_sample; // sample data from dest reg

// CTU/JTAG Shift Interface
input           ctu_efc_data_in;        // Serial(scan) in from ctu
output          efc_ctu_data_out;       // Serial(scan) out to ctu
input           ctu_efc_updatedr;       // read reg updated from shift reg
input           ctu_efc_shiftdr;        // shift data register
input           ctu_efc_capturedr;      // shift data reg captures read reg val
input           tck;                    // Shift dr data in/out from ctu

// Destination Register Interface
output		efc_spc1357_fuse_clk1;
output		efc_spc1357_fuse_clk2;
output		efc_spc0246_fuse_clk1;
output		efc_spc0246_fuse_clk2;
output		efc_spc1357_fuse_data;
output		efc_spc0246_fuse_data;

output		efc_spc7_ifuse_ashift;
output		efc_spc7_ifuse_dshift;
output		efc_spc7_dfuse_ashift;
output		efc_spc7_dfuse_dshift;
input		spc7_efc_ifuse_data;
input		spc7_efc_dfuse_data;

output		efc_spc6_ifuse_ashift;
output		efc_spc6_ifuse_dshift;
output		efc_spc6_dfuse_ashift;
output		efc_spc6_dfuse_dshift;
input		spc6_efc_ifuse_data;
input		spc6_efc_dfuse_data;

output		efc_spc5_ifuse_ashift;
output		efc_spc5_ifuse_dshift;
output		efc_spc5_dfuse_ashift;
output		efc_spc5_dfuse_dshift;
input		spc5_efc_ifuse_data;
input		spc5_efc_dfuse_data;

output		efc_spc4_ifuse_ashift;
output		efc_spc4_ifuse_dshift;
output		efc_spc4_dfuse_ashift;
output		efc_spc4_dfuse_dshift;
input		spc4_efc_ifuse_data;
input		spc4_efc_dfuse_data;

output		efc_spc3_ifuse_ashift;
output		efc_spc3_ifuse_dshift;
output		efc_spc3_dfuse_ashift;
output		efc_spc3_dfuse_dshift;
input		spc3_efc_ifuse_data;
input		spc3_efc_dfuse_data;

output		efc_spc2_ifuse_ashift;
output		efc_spc2_ifuse_dshift;
output		efc_spc2_dfuse_ashift;
output		efc_spc2_dfuse_dshift;
input		spc2_efc_ifuse_data;
input		spc2_efc_dfuse_data;

output		efc_spc1_ifuse_ashift;
output		efc_spc1_ifuse_dshift;
output		efc_spc1_dfuse_ashift;
output		efc_spc1_dfuse_dshift;
input		spc1_efc_ifuse_data;
input		spc1_efc_dfuse_data;

output		efc_spc0_ifuse_ashift;
output		efc_spc0_ifuse_dshift;
output		efc_spc0_dfuse_ashift;
output		efc_spc0_dfuse_dshift;
input		spc0_efc_ifuse_data;
input		spc0_efc_dfuse_data;

output		efc_sctag02_fuse_clk1;
output		efc_sctag02_fuse_clk2;
output		efc_sctag02_fuse_data;
output		efc_sctag13_fuse_clk1;
output		efc_sctag13_fuse_clk2;
output		efc_sctag13_fuse_data;

output		efc_sctag3_fuse_ashift;
output		efc_sctag3_fuse_dshift;
input		sctag3_efc_fuse_data;

output		efc_sctag2_fuse_ashift;
output		efc_sctag2_fuse_dshift;
input		sctag2_efc_fuse_data;

output		efc_sctag1_fuse_ashift;
output		efc_sctag1_fuse_dshift;
input		sctag1_efc_fuse_data;

output		efc_sctag0_fuse_ashift;
output		efc_sctag0_fuse_dshift;
input		sctag0_efc_fuse_data;

output		efc_scdata02_fuse_clk1;
output		efc_scdata02_fuse_clk2;
output		efc_scdata02_fuse_data;
output		efc_scdata13_fuse_clk1;
output		efc_scdata13_fuse_clk2;
output		efc_scdata13_fuse_data;

output		efc_scdata3_fuse_ashift;
output		efc_scdata3_fuse_dshift;
input		scdata3_efc_fuse_data;

output		efc_scdata2_fuse_ashift;
output		efc_scdata2_fuse_dshift;
input		scdata2_efc_fuse_data;

output		efc_scdata1_fuse_ashift;
output		efc_scdata1_fuse_dshift;
input		scdata1_efc_fuse_data;

output		efc_scdata0_fuse_ashift;
output		efc_scdata0_fuse_dshift;
input		scdata0_efc_fuse_data;

output		efc_iob_fuse_clk1;
output		efc_iob_fuse_data;

output		efc_iob_sernum0_dshift;
output		efc_iob_sernum1_dshift;
output		efc_iob_sernum2_dshift;
output		efc_iob_fusestat_dshift;
output		efc_iob_coreavail_dshift;


// EFA interface 
input  [31:0]    efa_sbc_data;
output           sbc_efa_read_en; 
output	[5:0]    sbc_efa_word_addr;
output  [4:0]    sbc_efa_bit_addr;
output           sbc_efa_margin0_rd; 
output           sbc_efa_margin1_rd;

output		 pwr_ok;
output		 por_n;
output		 sbc_efa_sup_det_rd;
output		 sbc_efa_power_down;

//-----------------------------------------------------------------------------
//  Wire/reg declarations
//-----------------------------------------------------------------------------
/*AUTOWIRE*/
// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [31:0]		tck_shft_data_ff;	// From efctck of efc_tck.v
// End of automatics
wire  [31:0]    efa_out_data;

wire		efc_spc7_ifuse_ashift;
wire		efc_spc7_ifuse_dshift;
wire		efc_spc7_dfuse_ashift;
wire		efc_spc7_dfuse_dshift;

wire		efc_spc6_ifuse_ashift;
wire		efc_spc6_ifuse_dshift;
wire		efc_spc6_dfuse_ashift;
wire		efc_spc6_dfuse_dshift;

wire		efc_spc5_ifuse_ashift;
wire		efc_spc5_ifuse_dshift;
wire		efc_spc5_dfuse_ashift;
wire		efc_spc5_dfuse_dshift;

wire		efc_spc4_ifuse_ashift;
wire		efc_spc4_ifuse_dshift;
wire		efc_spc4_dfuse_ashift;
wire		efc_spc4_dfuse_dshift;

wire		efc_spc3_ifuse_ashift;
wire		efc_spc3_ifuse_dshift;
wire		efc_spc3_dfuse_ashift;
wire		efc_spc3_dfuse_dshift;

wire		efc_spc2_ifuse_ashift;
wire		efc_spc2_ifuse_dshift;
wire		efc_spc2_dfuse_ashift;
wire		efc_spc2_dfuse_dshift;

wire		efc_spc1_ifuse_ashift;
wire		efc_spc1_ifuse_dshift;
wire		efc_spc1_dfuse_ashift;
wire		efc_spc1_dfuse_dshift;

wire		efc_spc0_ifuse_ashift;
wire		efc_spc0_ifuse_dshift;
wire		efc_spc0_dfuse_ashift;
wire		efc_spc0_dfuse_dshift;

wire		efc_sctag3_fuse_ashift;
wire		efc_sctag3_fuse_dshift;
wire		efc_sctag2_fuse_ashift;
wire		efc_sctag2_fuse_dshift;
wire		efc_sctag1_fuse_ashift;
wire		efc_sctag1_fuse_dshift;
wire		efc_sctag0_fuse_ashift;
wire		efc_sctag0_fuse_dshift;

wire		efc_scdata3_fuse_ashift;
wire		efc_scdata3_fuse_dshift;
wire		efc_scdata2_fuse_ashift;
wire		efc_scdata2_fuse_dshift;
wire		efc_scdata1_fuse_ashift;
wire		efc_scdata1_fuse_dshift;
wire		efc_scdata0_fuse_ashift;
wire		efc_scdata0_fuse_dshift;

wire		efc_iob_fuse_clk1;
wire		efc_iob_fuse_data;

wire		efc_iob_sernum0_dshift;
wire		efc_iob_sernum1_dshift;
wire		efc_iob_sernum2_dshift;
wire		efc_iob_fusestat_dshift;
wire		efc_iob_coreavail_dshift;

wire		local_efc_read_start;
wire [6:0]	addr_cnt_nxt;
wire		addr_cnt_en;
wire [6:0]	addr_cnt_ff;
wire [5:0]	addr_cnt_inc1;
wire		addr_cnt_max;
wire		shift_done;
wire		mrd_cnt_done;
wire		rd_array_done;
wire		recover_done;
wire		local_fuse_bypass; //ctu_efc_fuse_bypass 
wire		local_dest_sample; //ctu_efc_fuse_bypass 
wire		local_read_en; //ctu_efc_fuse_bypass 
wire		read_data_en;
wire  [31:0]	read_data_nxt;
wire  [31:0]    read_data_ff;
reg  [3:0]	seq_state_nxt;
reg		enter_rsltshft;
wire [3:0]	seq_state_ff;
wire		seq_state_idle;
wire		seq_state_dump;
wire		seq_state_sglrd;
//wire		seq_state_bypass;
wire		seq_state_dest_smpl;
wire		seq_state_l2rr_smpl;
wire		seq_state_rsltshft;
wire		spc0_ifuse_dec;
wire		spc0_dfuse_dec;
wire		spc1_ifuse_dec;
wire		spc1_dfuse_dec;
wire		spc2_ifuse_dec;
wire		spc2_dfuse_dec;
wire		spc3_ifuse_dec;
wire		spc3_dfuse_dec;
wire		spc4_ifuse_dec;
wire		spc4_dfuse_dec;
wire		spc5_ifuse_dec;
wire		spc5_dfuse_dec;
wire		spc6_ifuse_dec;
wire		spc6_dfuse_dec;
wire		spc7_ifuse_dec;
wire		spc7_dfuse_dec;
wire		sctag0_fuse_dec;
wire		sctag1_fuse_dec;
wire		sctag2_fuse_dec;
wire		sctag3_fuse_dec;
wire		scdata_fuse_dec;
wire		scdata0_fuse_dec;
wire		scdata1_fuse_dec;
wire		scdata2_fuse_dec;
wire		scdata3_fuse_dec;
wire		iob_coreavail_dec;
wire		iob_sernum0_dec;
wire		iob_sernum1_dec;
wire		iob_sernum2_dec;
wire		iob_fusestat_dec;

wire		scdata0_read_dec;
wire		scdata1_read_dec;
wire		scdata2_read_dec;
wire		scdata3_read_dec;

wire		inhibit_power_down_snc_l;
wire		inhibit_power_down_l;
wire		efa_read_en_lt;
wire		enable_efa_por_nxt_l;
wire		enable_efa_por_ff_l;
wire		efa_array_power_down_ff;
wire		efa_array_power_down_nxt;
//-----------------------------------------------------------------------------
//  Misc signals
//-----------------------------------------------------------------------------
assign pwr_ok = jbus_arst_l;
assign por_n  = jbus_arst_l;

//-----------------------------------------------------------------------------
//  tck
//-----------------------------------------------------------------------------
efc_tck efctck(/*AUTOINST*/
	       // Outputs
	       .tck_shft_data_ff	(tck_shft_data_ff[31:0]),
	       .efc_ctu_data_out	(efc_ctu_data_out),
	       // Inputs
	       .read_data_ff		(read_data_ff[31:0]),
	       .ctu_efc_data_in		(ctu_efc_data_in),
	       .ctu_efc_shiftdr		(ctu_efc_shiftdr),
	       .ctu_efc_capturedr	(ctu_efc_capturedr),
	       .tck			(tck));

//-----------------------------------------------------------------------------
//  Synchronizers and Edge Detectors
//-----------------------------------------------------------------------------
wire		update_dr_jbus;
efc_saed updtdr(
	      .rise_det			(update_dr_jbus),
	      .fall_det			(),
	      .async_in			(ctu_efc_updatedr),
	      .clk			(clk));
efc_saed read_en(
	      .rise_det			(local_read_en),
	      .fall_det			(),
	      .async_in			(ctu_efc_read_en),
	      .clk			(clk));
efc_saed read_start(
	      .rise_det			(local_efc_read_start),
	      .fall_det			(),
	      .async_in			(ctu_efc_read_start),
	      .clk			(clk));
efc_saed fuse_bypass(
	      .rise_det			(local_fuse_bypass),
	      .fall_det			(),
	      .async_in			(ctu_efc_fuse_bypass),
	      .clk			(clk));
efc_saed dest_sample(
	      .rise_det			(local_dest_sample),
	      .fall_det			(),
	      .async_in			(ctu_efc_dest_sample),
	      .clk			(clk));

wire [6:0]	snc1_rowaddr;
bw_u1_syncff_4x snc1_rowaddr_reg6 ( .so(), .q (snc1_rowaddr[6]),
		  .ck (clk), .d (ctu_efc_rowaddr[6]), .sd(), .se(1'b0));
bw_u1_syncff_4x snc1_rowaddr_reg5 ( .so(), .q (snc1_rowaddr[5]),
		  .ck (clk), .d (ctu_efc_rowaddr[5]), .sd(), .se(1'b0));
bw_u1_syncff_4x snc1_rowaddr_reg4 ( .so(), .q (snc1_rowaddr[4]),
		  .ck (clk), .d (ctu_efc_rowaddr[4]), .sd(), .se(1'b0));
bw_u1_syncff_4x snc1_rowaddr_reg3 ( .so(), .q (snc1_rowaddr[3]),
		  .ck (clk), .d (ctu_efc_rowaddr[3]), .sd(), .se(1'b0));
bw_u1_syncff_4x snc1_rowaddr_reg2 ( .so(), .q (snc1_rowaddr[2]),
		  .ck (clk), .d (ctu_efc_rowaddr[2]), .sd(), .se(1'b0));
bw_u1_syncff_4x snc1_rowaddr_reg1 ( .so(), .q (snc1_rowaddr[1]),
		  .ck (clk), .d (ctu_efc_rowaddr[1]), .sd(), .se(1'b0));
bw_u1_syncff_4x snc1_rowaddr_reg0 ( .so(), .q (snc1_rowaddr[0]),
		  .ck (clk), .d (ctu_efc_rowaddr[0]), .sd(), .se(1'b0));

bw_u1_syncff_4x inhbpwrdn_snc1_reg ( .so(), .q (inhibit_power_down_snc_l),
		  .ck (clk), .d (!ctu_efc_read_mode[2]), .sd(), .se(1'b0));
dff_ns #(1)  inhbpwrdn_snc2_reg (.din(inhibit_power_down_snc_l), 
		   .q(inhibit_power_down_l), .clk(clk));
//-----------------------------------------------------------------------------
//  Power down control
//-----------------------------------------------------------------------------

assign enable_efa_por_nxt_l = seq_state_rsltshft || enable_efa_por_ff_l;
dffrl_async_ns #(1)  enable_efa_por_reg(
	.din(enable_efa_por_nxt_l), 
	.q(enable_efa_por_ff_l), .clk(clk), .rst_l(jbus_arst_l));

assign efa_array_power_down_nxt 
	= seq_state_idle && !(local_efc_read_start || local_fuse_bypass
			      || local_read_en || local_dest_sample)
	  && enable_efa_por_ff_l && inhibit_power_down_l;
dff_ns #(1)  efa_array_power_down_reg(.din(efa_array_power_down_nxt), 
		   .q(efa_array_power_down_ff), .clk(clk));

//-----------------------------------------------------------------------------
//  Read whole array sequencer
//-----------------------------------------------------------------------------
/* Note| State encodings are chosen so the outputs are equal to signle
         state bits.  Changing state encodings will change outputs! */
/* Bit[3] is used to indicate idle/not idle.  */
parameter      		MSEQ_IDLE	= 4'b0000,
			MSEQ_DUMP    	= 4'b1001,
			MSEQ_RSLTSHFT  	= 4'b1011,
			MSEQ_SGLRD	= 4'b1010,
			MSEQ_BYPASS    	= 4'b1100,
			MSEQ_DEST_SMPL	= 4'b1101,
			MSEQ_L2RR_SMPL	= 4'b1110,
			MSEQ_SHIFT	= 4'b1111;

always @(/*AUTOSENSE*/addr_cnt_max or local_dest_sample
	 or local_efc_read_start or local_fuse_bypass or local_read_en
	 or mrd_cnt_done or recover_done or scdata_fuse_dec
	 or seq_state_ff or shift_done)
  begin
    enter_rsltshft = 1'b0;
    case (seq_state_ff) //synopsys parallel_case full_case
      MSEQ_IDLE:
	if (local_efc_read_start)
	  begin
	    seq_state_nxt = MSEQ_DUMP;
	  end
	else if (local_fuse_bypass)
	  begin
	    seq_state_nxt = MSEQ_SHIFT;
	  end
	else if (local_read_en)
	  begin
	    seq_state_nxt = MSEQ_SGLRD;
	  end
	else if (local_dest_sample && scdata_fuse_dec)
	  begin
	    seq_state_nxt = MSEQ_L2RR_SMPL;
	  end
	else if (local_dest_sample)
	  begin
	    seq_state_nxt = MSEQ_DEST_SMPL;
	  end
	else
	  seq_state_nxt = MSEQ_IDLE;
      MSEQ_DUMP:
	if (addr_cnt_max && shift_done)
	  begin
	    seq_state_nxt = MSEQ_RSLTSHFT;
	    enter_rsltshft = 1'b1;
	  end
	else
	    seq_state_nxt = MSEQ_DUMP;
      MSEQ_RSLTSHFT:
	if (mrd_cnt_done)
	  begin
	    seq_state_nxt = MSEQ_IDLE;
	  end
	else
	    seq_state_nxt = MSEQ_RSLTSHFT;
      MSEQ_SGLRD:
	if (recover_done)
	  seq_state_nxt = MSEQ_IDLE;
	else
	  seq_state_nxt = MSEQ_SGLRD;
      MSEQ_SHIFT:
	if (shift_done)
	  seq_state_nxt = MSEQ_IDLE;
	else
	  seq_state_nxt = MSEQ_SHIFT;
      MSEQ_DEST_SMPL:
	if (shift_done)
	  seq_state_nxt = MSEQ_IDLE;
	else
	  seq_state_nxt = MSEQ_DEST_SMPL;
      MSEQ_L2RR_SMPL:
	if (shift_done)
	  seq_state_nxt = MSEQ_IDLE;
	else
	  seq_state_nxt = MSEQ_L2RR_SMPL;
      MSEQ_BYPASS:
	if (shift_done)
	  seq_state_nxt = MSEQ_IDLE;
	else
	  seq_state_nxt = MSEQ_BYPASS;
      default:
	  seq_state_nxt = MSEQ_IDLE;
    endcase
  end
assign seq_state_idle     = (!seq_state_ff[3]);
assign seq_state_dump     = (seq_state_ff == MSEQ_DUMP);
assign seq_state_sglrd    = (seq_state_ff == MSEQ_SGLRD);
//assign seq_state_bypass   = (seq_state_ff == MSEQ_BYPASS);
assign seq_state_rsltshft = (seq_state_ff == MSEQ_RSLTSHFT);
assign seq_state_dest_smpl = (seq_state_ff == MSEQ_DEST_SMPL);
assign seq_state_l2rr_smpl = (seq_state_ff == MSEQ_L2RR_SMPL);

dffrl_ns #(4) seq_state_reg (.din(seq_state_nxt), .q(seq_state_ff), 
			.rst_l(efc_rst_l), .clk(clk));
//-----------------------------------------------------------------------------
//  Address Counter
//-----------------------------------------------------------------------------
assign addr_cnt_inc1[5:0] = addr_cnt_ff[5:0] + 6'b000001;
assign addr_cnt_nxt [6:0] = local_efc_read_start ? 7'b0000000
			      : !seq_state_dump ? snc1_rowaddr[6:0]
			      : {1'b0,addr_cnt_inc1};
assign addr_cnt_max       = &addr_cnt_ff[5:0];
assign addr_cnt_en = local_efc_read_start 
	      || shift_done && !addr_cnt_max && seq_state_dump
              || !seq_state_dump;
dffe_ns #(7) addr_cnt_reg (.din(addr_cnt_nxt), .en(addr_cnt_en), 
		   .q(addr_cnt_ff), .clk(clk));

//-----------------------------------------------------------------------------
// Read and process one entry sequencer
//-----------------------------------------------------------------------------
parameter      		MRD_IDLE	= 3'b000,
			MRD_RD_ARRAY	= 3'b100,
			MRD_ASHIFT	= 3'b001,
			MRD_DSHIFT	= 3'b011,
			MRD_RECOVER	= 3'b010;
// Note!! MRD_RD_ARRAY encoding was chosen so that mrd_state_ff[2] uniquely
//  defines being in that state.  (like one hot, but only for that state)
reg  [2:0]	mrd_state_nxt;
wire [2:0]	mrd_state_ff;
reg		enter_rd_array;
reg		enter_ashift;
reg		enter_dshift;
reg		enter_recover;
//wire		mrd_state_idle;
wire		mrd_state_rd_array;
wire		mrd_state_ashift;
wire		mrd_state_dshift;
wire		mrd_state_shift;
wire		mrd_state_recover;

always @(/*AUTOSENSE*/local_dest_sample or local_fuse_bypass
	 or mrd_cnt_done or mrd_state_ff or seq_state_dump
	 or seq_state_sglrd)
  begin
    enter_rd_array  = 1'b0;
    enter_ashift    = 1'b0;
    enter_recover   = 1'b0;
    enter_dshift    = 1'b0;
    case (mrd_state_ff) //synopsys parallel_case full_case
      MRD_IDLE:
	if (seq_state_sglrd || seq_state_dump)
	  begin
	    mrd_state_nxt = MRD_RD_ARRAY;
	    enter_rd_array = 1'b1;
	  end
	else if (local_fuse_bypass || local_dest_sample)
	  begin
	    mrd_state_nxt = MRD_ASHIFT;
	    enter_ashift    = 1'b1;
	  end
	else
	  mrd_state_nxt = MRD_IDLE;
      MRD_RD_ARRAY:
	if (mrd_cnt_done && seq_state_dump)
	  begin
	    mrd_state_nxt = MRD_ASHIFT;
	    enter_ashift    = 1'b1;
	  end
	else if (mrd_cnt_done)
	  begin
	    mrd_state_nxt = MRD_RECOVER;
	    enter_recover   = 1'b1;
	  end
	else
	  mrd_state_nxt = MRD_RD_ARRAY;
      MRD_ASHIFT:
	if (mrd_cnt_done)
	  begin
	    mrd_state_nxt = MRD_DSHIFT;
	    enter_dshift    = 1'b1;
	  end
	else
	  mrd_state_nxt = MRD_ASHIFT;
      MRD_DSHIFT:
	if (mrd_cnt_done)
	  mrd_state_nxt = MRD_IDLE;
	else
	  mrd_state_nxt = MRD_DSHIFT;
      MRD_RECOVER:
	if (mrd_cnt_done)
	  mrd_state_nxt = MRD_IDLE;
	else
	  mrd_state_nxt = MRD_RECOVER;
      default:
	  mrd_state_nxt = MRD_IDLE;
    endcase
  end
//assign mrd_state_idle     = (mrd_state_ff == MRD_IDLE);
assign mrd_state_rd_array  = mrd_state_ff[2];
assign mrd_state_ashift    = (mrd_state_ff == MRD_ASHIFT);
assign mrd_state_dshift    = (mrd_state_ff == MRD_DSHIFT);
assign mrd_state_shift     = mrd_state_ashift || mrd_state_dshift;
assign mrd_state_recover   = (mrd_state_ff == MRD_RECOVER);
assign shift_done 	   = mrd_state_dshift && mrd_cnt_done;
assign rd_array_done 	   = mrd_state_rd_array && mrd_cnt_done;
assign recover_done 	   = mrd_state_recover  && mrd_cnt_done;

dffrl_ns #(3) mrd_state_reg (.din(mrd_state_nxt), .q(mrd_state_ff), 
			.rst_l(efc_rst_l), .clk(clk));

//-----------------------------------------------------------------------------
//  General purpose timing counter
//-----------------------------------------------------------------------------
parameter       	RD_CNT_START		= 9'd20,
			ASHIFT_CNT_START	= {(7'd09),2'b11},
			DSHIFT_CNT_START	= {(7'd12),2'b11},
			RSLTSHIFT_CNT_START	= {(7'd63),2'b11},
			RECOVER_CNT_START	= 9'd10;

wire [8:0]	mrd_cnt_ff;
wire [8:0]	mrd_cnt_nxt;
wire [8:0]	mrd_cnt_dec1;
wire [5:0]	l2rr_read_cnt;

assign l2rr_read_cnt = read_data_ff[17:12];
/* General purpose CNTer used for timing reads from array and shifting
   to destination registers.  Note that CNTdown stops at 0 and won't wrap.*/
assign mrd_cnt_dec1[8:0] = mrd_cnt_ff[8:0] - 9'b0_0000_0001;
assign mrd_cnt_nxt [8:0] = 
       enter_rd_array ? RD_CNT_START
       : enter_ashift  ? ASHIFT_CNT_START
       : enter_dshift && seq_state_l2rr_smpl ? {1'b0,l2rr_read_cnt,2'b11}
       : enter_dshift ? DSHIFT_CNT_START
       : enter_rsltshft ? RSLTSHIFT_CNT_START
       : enter_recover ? RECOVER_CNT_START
       : mrd_cnt_dec1 & {9{!mrd_cnt_done}};
assign mrd_cnt_done = ~|mrd_cnt_ff;
dff_ns #(9) mrd_cnt_reg (.din(mrd_cnt_nxt), .q(mrd_cnt_ff), .clk(clk));

//-----------------------------------------------------------------------------
//  Read array data register
//-----------------------------------------------------------------------------
wire  [2:0]	valid_bits;
//wire		parity_bit;
wire  [5:0]	block_id;
//wire  [21:0]	payload_data;
wire		computed_parity;
wire		good_parity;
wire		valid_row;
wire		row_error;
wire [31:0]	read_data_shift;
wire [31:0]	read_data_l2shift;
wire		read_data_shift_en;
wire		shift_in;
wire [1:0]	l2rd_id_ff;
wire      	l2rd_id_en;

assign 	shift_in = 1'b0
		|| spc7_ifuse_dec && spc7_efc_ifuse_data
		|| spc7_dfuse_dec && spc7_efc_dfuse_data
		|| spc6_ifuse_dec && spc6_efc_ifuse_data
		|| spc6_dfuse_dec && spc6_efc_dfuse_data
		|| spc5_ifuse_dec && spc5_efc_ifuse_data
		|| spc5_dfuse_dec && spc5_efc_dfuse_data
		|| spc4_ifuse_dec && spc4_efc_ifuse_data
		|| spc4_dfuse_dec && spc4_efc_dfuse_data
		|| spc3_ifuse_dec && spc3_efc_ifuse_data
		|| spc3_dfuse_dec && spc3_efc_dfuse_data
		|| spc2_ifuse_dec && spc2_efc_ifuse_data
		|| spc2_dfuse_dec && spc2_efc_dfuse_data
		|| spc1_ifuse_dec && spc1_efc_ifuse_data
		|| spc1_dfuse_dec && spc1_efc_dfuse_data
		|| spc0_ifuse_dec && spc0_efc_ifuse_data
		|| spc0_dfuse_dec && spc0_efc_dfuse_data
		|| sctag3_fuse_dec && sctag3_efc_fuse_data
		|| sctag2_fuse_dec && sctag2_efc_fuse_data
		|| sctag1_fuse_dec && sctag1_efc_fuse_data
		|| sctag0_fuse_dec && sctag0_efc_fuse_data
		|| scdata3_read_dec && scdata3_efc_fuse_data
		|| scdata2_read_dec && scdata2_efc_fuse_data
		|| scdata1_read_dec && scdata1_efc_fuse_data
		|| scdata0_read_dec && scdata0_efc_fuse_data
		;

assign read_data_shift_en = (seq_state_dest_smpl 
                             || seq_state_l2rr_smpl && mrd_state_dshift)
			    && (mrd_cnt_ff[1:0]==2'b00);
assign read_data_en = rd_array_done || update_dr_jbus || read_data_shift_en;
assign read_data_shift   = {read_data_ff[31:12], read_data_ff[10:0], shift_in};
assign read_data_l2shift = {read_data_ff[30:0], shift_in};
assign read_data_nxt = update_dr_jbus ? tck_shft_data_ff 
	    : seq_state_dest_smpl ? read_data_shift 
	    : seq_state_l2rr_smpl ? read_data_l2shift
	    : efa_out_data;
assign l2rd_id_en = enter_ashift;

dffe_ns #(32) read_data_reg (.din(read_data_nxt), .en(read_data_en), 
		   .q(read_data_ff), .clk(clk));
dffe_ns #( 2) l2rd_id_reg (.din(block_id[1:0]), .en(l2rd_id_en), 
		   .q(l2rd_id_ff), .clk(clk));

assign valid_bits = read_data_ff[31:29];
//assign parity_bit = read_data_ff[28];
assign block_id = read_data_ff[27:22];
//assign payload_data = read_data_ff[21:0];
assign computed_parity = ^read_data_ff[28:0];
assign good_parity = !computed_parity;

reg		valid;
reg		val_err;
always @(/*AUTOSENSE*/valid_bits)
  case (valid_bits) //synopsys parallel_case full_case
    3'b000: {valid, val_err} = 2'b00;
    3'b001: {valid, val_err} = 2'b01;
    3'b010: {valid, val_err} = 2'b01;
    3'b100: {valid, val_err} = 2'b01;
    3'b011: {valid, val_err} = 2'b10;
    3'b101: {valid, val_err} = 2'b10;
    3'b110: {valid, val_err} = 2'b10;
    3'b111: {valid, val_err} = 2'b10;
  endcase

assign valid_row = good_parity && valid;
wire [63:0]		rslt_status_nxt;
wire [63:0]		rslt_status_ff;
wire			rslt_status_en;
wire [63:0]		rslt_status_set;
wire [63:0]		rslt_status_clr;
wire [63:0]		rslt_status_vect;


assign row_error = val_err || (valid && !good_parity);
assign rslt_status_en = seq_state_dump && shift_done;
assign rslt_status_vect = ({{63{1'b0}},rslt_status_en} << addr_cnt_ff[5:0]);
assign rslt_status_set  = rslt_status_vect & {64{row_error}};
assign rslt_status_clr  = rslt_status_vect & {64{!row_error}};

assign rslt_status_nxt = rslt_status_set | ~rslt_status_clr & rslt_status_ff;
dff_ns #(64) rslt_status_reg (.din(rslt_status_nxt), 
			    .q(rslt_status_ff), .clk(clk));
//-----------------------------------------------------------------------------
// Shift control
//-----------------------------------------------------------------------------
wire		mrd_cnt_ge_12;
wire		mrd_cnt_ge_2;
wire		mrd_cnt_ge_1;
wire		local_fuse_clk1_nxt;
wire		local_fuse_ashift_nxt;
wire		local_fuse_dshift_nxt;
wire		fuse_data_bit_mux;
wire		fuse_rid_bit_mux;
wire		rslt_data_bit_mux;
wire		local_fuse_data_nxt;
wire		decode_enable;
wire		decode_enable_l2rr;
wire		local_fuse_clk1_ff;
wire		local_fuse_clk1_dly_ff;
wire		local_fuse_clk2_ff;
wire		local_fuse_data_ff;
wire [15:0]	rid_data;
wire [31:0]	write_dest_data;
wire		write_en;
wire		dest_iob;

assign dest_iob = iob_coreavail_dec || iob_sernum0_dec 
		       || iob_sernum1_dec || iob_sernum2_dec;
assign rid_data =        dest_iob 
                         ? {{6{1'b0}},
			    read_data_ff[21:12]}
                         : {{5{1'b0}},
			    read_data_ff[21:12], write_en};
assign write_en = !(seq_state_dest_smpl || seq_state_l2rr_smpl);
assign write_dest_data = {{8{1'b0}},
                          read_data_ff[21:12], write_en, 
			  read_data_ff[11:0],
			  1'b0};

assign local_fuse_clk1_nxt = (mrd_state_shift || seq_state_rsltshft) 
			      && (mrd_cnt_ff[1:0]==2'b10) && efc_rst_l;
assign mrd_cnt_ge_12 = (mrd_cnt_ff[6:0] >= {5'd12,2'b00});
assign mrd_cnt_ge_2  = (mrd_cnt_ff[6:0] >= { 5'd2,2'b00});
assign mrd_cnt_ge_1  = (mrd_cnt_ff[8:0] >= { 7'd1,2'b00});
assign local_fuse_ashift_nxt = mrd_state_ashift && efc_rst_l;
assign local_fuse_dshift_nxt = efc_rst_l && (seq_state_rsltshft 
       || (mrd_state_dshift && 
	     (seq_state_dest_smpl  ? (!mrd_cnt_ge_12 && mrd_cnt_ge_1)
	      : seq_state_l2rr_smpl ? (mrd_cnt_ge_1)
	      : mrd_cnt_ge_2 || dest_iob && mrd_cnt_ge_1)) );
assign fuse_data_bit_mux = write_dest_data[mrd_cnt_ff[6:2]];
assign fuse_rid_bit_mux  = rid_data[mrd_cnt_ff[5:2]];
assign rslt_data_bit_mux = rslt_status_ff[mrd_cnt_ff[7:2]];
assign local_fuse_data_nxt = (mrd_state_ashift && fuse_rid_bit_mux)
			      || (mrd_state_dshift && fuse_data_bit_mux)
			      || (seq_state_rsltshft && rslt_data_bit_mux);

dffrl_async_ns #(1) local_fuse_clk1_reg (.din(local_fuse_clk1_nxt),
		    .q(local_fuse_clk1_ff), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) local_fuse_clk1_dly_reg (.din(local_fuse_clk1_ff),
		    .q(local_fuse_clk1_dly_ff), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) local_fuse_clk2_reg (.din(local_fuse_clk1_dly_ff),
		    .q(local_fuse_clk2_ff), .clk(clk), .rst_l(jbus_arst_l));
dff_ns #(1) local_fuse_data_reg (.din(local_fuse_data_nxt),
				.q(local_fuse_data_ff), .clk(clk));

assign decode_enable = mrd_state_shift && (valid_row || seq_state_dest_smpl);
assign decode_enable_l2rr = mrd_state_shift && seq_state_l2rr_smpl;

//-----------------------------------------------------------------------------
//  destination decoder
//-----------------------------------------------------------------------------

assign spc0_ifuse_dec 	= (block_id[5:0] == 6'b000000) && decode_enable;
assign spc0_dfuse_dec 	= (block_id[5:0] == 6'b000001) && decode_enable;
assign spc1_ifuse_dec 	= (block_id[5:0] == 6'b000010) && decode_enable;
assign spc1_dfuse_dec 	= (block_id[5:0] == 6'b000011) && decode_enable;
assign spc2_ifuse_dec 	= (block_id[5:0] == 6'b000100) && decode_enable;
assign spc2_dfuse_dec 	= (block_id[5:0] == 6'b000101) && decode_enable;
assign spc3_ifuse_dec 	= (block_id[5:0] == 6'b000110) && decode_enable;
assign spc3_dfuse_dec 	= (block_id[5:0] == 6'b000111) && decode_enable;
assign spc4_ifuse_dec 	= (block_id[5:0] == 6'b001000) && decode_enable;
assign spc4_dfuse_dec 	= (block_id[5:0] == 6'b001001) && decode_enable;
assign spc5_ifuse_dec 	= (block_id[5:0] == 6'b001010) && decode_enable;
assign spc5_dfuse_dec 	= (block_id[5:0] == 6'b001011) && decode_enable;
assign spc6_ifuse_dec 	= (block_id[5:0] == 6'b001100) && decode_enable;
assign spc6_dfuse_dec 	= (block_id[5:0] == 6'b001101) && decode_enable;
assign spc7_ifuse_dec 	= (block_id[5:0] == 6'b001110) && decode_enable;
assign spc7_dfuse_dec 	= (block_id[5:0] == 6'b001111) && decode_enable;
assign sctag0_fuse_dec 	= (block_id[5:0] == 6'b010000) && decode_enable;
assign sctag1_fuse_dec 	= (block_id[5:0] == 6'b010001) && decode_enable;
assign sctag2_fuse_dec 	= (block_id[5:0] == 6'b010010) && decode_enable;
assign sctag3_fuse_dec 	= (block_id[5:0] == 6'b010011) && decode_enable;
assign scdata0_fuse_dec = (block_id[5:0] == 6'b010100) && decode_enable;
assign scdata1_fuse_dec = (block_id[5:0] == 6'b010101) && decode_enable;
assign scdata2_fuse_dec = (block_id[5:0] == 6'b010110) && decode_enable;
assign scdata3_fuse_dec = (block_id[5:0] == 6'b010111) && decode_enable;
assign iob_coreavail_dec= (block_id[5:0] == 6'b011000) && decode_enable;
assign iob_sernum0_dec 	= (block_id[5:0] == 6'b100000) && decode_enable;
assign iob_sernum1_dec 	= (block_id[5:0] == 6'b100001) && decode_enable;
assign iob_sernum2_dec 	= (block_id[5:0] == 6'b100010) && decode_enable;
assign iob_fusestat_dec 	= seq_state_rsltshft;

assign scdata_fuse_dec = (block_id[5:2] == 4'b0101);
assign scdata0_read_dec = (l2rd_id_ff[1:0] == 2'b00) && decode_enable_l2rr; 
assign scdata1_read_dec = (l2rd_id_ff[1:0] == 2'b01) && decode_enable_l2rr; 
assign scdata2_read_dec = (l2rd_id_ff[1:0] == 2'b10) && decode_enable_l2rr; 
assign scdata3_read_dec = (l2rd_id_ff[1:0] == 2'b11) && decode_enable_l2rr; 
			 

//-----------------------------------------------------------------------------
//  destination demux
//-----------------------------------------------------------------------------
wire		fuse_clk1;
wire		fuse_clk2;
assign fuse_clk1   =  local_fuse_clk1_ff && testmode_l;
assign fuse_clk2   =  local_fuse_clk2_ff && testmode_l;

assign efc_spc1357_fuse_clk1   =  fuse_clk1;
assign efc_spc1357_fuse_clk2   =  fuse_clk2;
assign efc_spc0246_fuse_clk1   =  fuse_clk1;
assign efc_spc0246_fuse_clk2   =  fuse_clk2;
assign efc_sctag02_fuse_clk1   =  fuse_clk1;
assign efc_sctag02_fuse_clk2   =  fuse_clk2;
assign efc_sctag13_fuse_clk1   =  fuse_clk1;
assign efc_sctag13_fuse_clk2   =  fuse_clk2;
assign efc_scdata02_fuse_clk1   =  fuse_clk1;
assign efc_scdata02_fuse_clk2   =  fuse_clk2;
assign efc_scdata13_fuse_clk1   =  fuse_clk1;
assign efc_scdata13_fuse_clk2   =  fuse_clk2;

assign efc_spc0246_fuse_data   = local_fuse_data_ff;
assign efc_spc1357_fuse_data   = local_fuse_data_ff;
assign efc_sctag02_fuse_data   = local_fuse_data_ff;
assign efc_sctag13_fuse_data   = local_fuse_data_ff;
assign efc_scdata02_fuse_data   = local_fuse_data_ff;
assign efc_scdata13_fuse_data   = local_fuse_data_ff;

assign efc_iob_fuse_clk1 = fuse_clk1;
assign efc_iob_fuse_data = local_fuse_data_ff;

//-----------------------------------------------------------------------------
//  Shift Output flops
//-----------------------------------------------------------------------------
dffrl_async_ns #(1) spc0_ifuse_ashift_reg (
	.din(spc0_ifuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc0_ifuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc0_ifuse_dshift_reg (
	.din(spc0_ifuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc0_ifuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc0_dfuse_ashift_reg (
	.din(spc0_dfuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc0_dfuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc0_dfuse_dshift_reg (
	.din(spc0_dfuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc0_dfuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc1_ifuse_ashift_reg (
	.din(spc1_ifuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc1_ifuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc1_ifuse_dshift_reg (
	.din(spc1_ifuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc1_ifuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc1_dfuse_ashift_reg (
	.din(spc1_dfuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc1_dfuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc1_dfuse_dshift_reg (
	.din(spc1_dfuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc1_dfuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc2_ifuse_ashift_reg (
	.din(spc2_ifuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc2_ifuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc2_ifuse_dshift_reg (
	.din(spc2_ifuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc2_ifuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc2_dfuse_ashift_reg (
	.din(spc2_dfuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc2_dfuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc2_dfuse_dshift_reg (
	.din(spc2_dfuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc2_dfuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc3_ifuse_ashift_reg (
	.din(spc3_ifuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc3_ifuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc3_ifuse_dshift_reg (
	.din(spc3_ifuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc3_ifuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc3_dfuse_ashift_reg (
	.din(spc3_dfuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc3_dfuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc3_dfuse_dshift_reg (
	.din(spc3_dfuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc3_dfuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc4_ifuse_ashift_reg (
	.din(spc4_ifuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc4_ifuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc4_ifuse_dshift_reg (
	.din(spc4_ifuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc4_ifuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc4_dfuse_ashift_reg (
	.din(spc4_dfuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc4_dfuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc4_dfuse_dshift_reg (
	.din(spc4_dfuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc4_dfuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc5_ifuse_ashift_reg (
	.din(spc5_ifuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc5_ifuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc5_ifuse_dshift_reg (
	.din(spc5_ifuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc5_ifuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc5_dfuse_ashift_reg (
	.din(spc5_dfuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc5_dfuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc5_dfuse_dshift_reg (
	.din(spc5_dfuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc5_dfuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc6_ifuse_ashift_reg (
	.din(spc6_ifuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc6_ifuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc6_ifuse_dshift_reg (
	.din(spc6_ifuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc6_ifuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc6_dfuse_ashift_reg (
	.din(spc6_dfuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc6_dfuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc6_dfuse_dshift_reg (
	.din(spc6_dfuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc6_dfuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc7_ifuse_ashift_reg (
	.din(spc7_ifuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc7_ifuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc7_ifuse_dshift_reg (
	.din(spc7_ifuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc7_ifuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc7_dfuse_ashift_reg (
	.din(spc7_dfuse_dec && local_fuse_ashift_nxt), 
	.q(efc_spc7_dfuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) spc7_dfuse_dshift_reg (
	.din(spc7_dfuse_dec && local_fuse_dshift_nxt), 
	.q(efc_spc7_dfuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) sctag0_fuse_ashift_reg (
	.din(sctag0_fuse_dec && local_fuse_ashift_nxt), 
	.q(efc_sctag0_fuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) sctag0_fuse_dshift_reg (
	.din(sctag0_fuse_dec && local_fuse_dshift_nxt), 
	.q(efc_sctag0_fuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) sctag1_fuse_ashift_reg (
	.din(sctag1_fuse_dec && local_fuse_ashift_nxt), 
	.q(efc_sctag1_fuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) sctag1_fuse_dshift_reg (
	.din(sctag1_fuse_dec && local_fuse_dshift_nxt), 
	.q(efc_sctag1_fuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) sctag2_fuse_ashift_reg (
	.din(sctag2_fuse_dec && local_fuse_ashift_nxt), 
	.q(efc_sctag2_fuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) sctag2_fuse_dshift_reg (
	.din(sctag2_fuse_dec && local_fuse_dshift_nxt), 
	.q(efc_sctag2_fuse_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) sctag3_fuse_ashift_reg (
	.din(sctag3_fuse_dec && local_fuse_ashift_nxt), 
	.q(efc_sctag3_fuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) sctag3_fuse_dshift_reg (
	.din(sctag3_fuse_dec && local_fuse_dshift_nxt), 
	.q(efc_sctag3_fuse_dshift), .clk(clk), .rst_l(jbus_arst_l));

dffrl_async_ns #(1) scdata0_fuse_ashift_reg (
	.din((scdata0_fuse_dec||scdata0_read_dec) && local_fuse_ashift_nxt), 
	.q(efc_scdata0_fuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) scdata0_fuse_dshift_reg (
	.din((scdata0_fuse_dec||scdata0_read_dec) && local_fuse_dshift_nxt), 
	.q(efc_scdata0_fuse_dshift), .clk(clk), .rst_l(jbus_arst_l));

dffrl_async_ns #(1) scdata1_fuse_ashift_reg (
	.din((scdata1_fuse_dec||scdata1_read_dec) && local_fuse_ashift_nxt), 
	.q(efc_scdata1_fuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) scdata1_fuse_dshift_reg (
	.din((scdata1_fuse_dec||scdata1_read_dec) && local_fuse_dshift_nxt), 
	.q(efc_scdata1_fuse_dshift), .clk(clk), .rst_l(jbus_arst_l));

dffrl_async_ns #(1) scdata2_fuse_ashift_reg (
	.din((scdata2_fuse_dec||scdata2_read_dec) && local_fuse_ashift_nxt), 
	.q(efc_scdata2_fuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) scdata2_fuse_dshift_reg (
	.din((scdata2_fuse_dec||scdata2_read_dec) && local_fuse_dshift_nxt), 
	.q(efc_scdata2_fuse_dshift), .clk(clk), .rst_l(jbus_arst_l));

dffrl_async_ns #(1) scdata3_fuse_ashift_reg (
	.din((scdata3_fuse_dec||scdata3_read_dec) && local_fuse_ashift_nxt), 
	.q(efc_scdata3_fuse_ashift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) scdata3_fuse_dshift_reg (
	.din((scdata3_fuse_dec||scdata3_read_dec) && local_fuse_dshift_nxt), 
	.q(efc_scdata3_fuse_dshift), .clk(clk), .rst_l(jbus_arst_l));

dffrl_async_ns #(1) iob_coreavail_dshift_reg (
	.din(iob_coreavail_dec && (local_fuse_ashift_nxt || local_fuse_dshift_nxt)), 
	.q(efc_iob_coreavail_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) iob_sernum0_dshift_reg (
	.din(iob_sernum0_dec && (local_fuse_ashift_nxt || local_fuse_dshift_nxt)), 
	.q(efc_iob_sernum0_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) iob_sernum1_dshift_reg (
	.din(iob_sernum1_dec && (local_fuse_ashift_nxt || local_fuse_dshift_nxt)), 
	.q(efc_iob_sernum1_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) iob_sernum2_dshift_reg (
	.din(iob_sernum2_dec && (local_fuse_ashift_nxt || local_fuse_dshift_nxt)), 
	.q(efc_iob_sernum2_dshift), .clk(clk), .rst_l(jbus_arst_l));
dffrl_async_ns #(1) iob_fusestat_dshift_reg (
	.din(iob_fusestat_dec && (local_fuse_ashift_nxt || local_fuse_dshift_nxt)), 
	.q(efc_iob_fusestat_dshift), .clk(clk), .rst_l(jbus_arst_l));

//----------------------------------------------------------------------------
//  latches for hold time at efa interface
//----------------------------------------------------------------------------
bw_efc_latch #(1) rdenlt(.q(efa_read_en_lt),
			 .d(mrd_state_rd_array),
			 .c(clk));
assign sbc_efa_read_en = efa_read_en_lt && testmode_l;

bw_efc_latch #(6) wdadlt(.q(sbc_efa_word_addr[5:0]),
			 .d(addr_cnt_ff[5:0]),
			 .c(clk));
bw_efc_latch #(5) cladlt(.q(sbc_efa_bit_addr[4:0]),
			 .d(ctu_efc_coladdr),
			 .c(clk));
bw_efc_latch #(2) marglt(.q({sbc_efa_margin1_rd, sbc_efa_margin0_rd}),
			 .d(ctu_efc_read_mode[1:0]),
			 .c(clk));
bw_efc_latch #(1) supllt(.q(sbc_efa_sup_det_rd),
			 .d(addr_cnt_ff[6]),
			 .c(clk));
bw_efc_latch #(1) pwdnlt(.q(sbc_efa_power_down),
			 .d(efa_array_power_down_ff),
			 .c(clk));
bw_efc_latch #(32) rddtlt(.q(efa_out_data),
			 .d(efa_sbc_data),
			 .c(clk));

endmodule
// Local Variables:
// verilog-library-directories:("." "../../common/rtl")
// verilog-library-files:      ("./efc_lib.v" "../../common/rtl/swrvr_clib.v")
// verilog-auto-sense-defines-constant:t
// End:
