// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: scdata.v
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
/////////////////////////////////////////////////////
//`include "sys.h"
//`include "iop.h"

module scdata (/*AUTOARG*/
   // Outputs
   scdata_sctag_decc_c6, 
   scdata_scbuf_decc_out_c7, scdata_efc_fuse_data, so, 
   // Inputs
   sctag_scdata_word_en_c2, sctag_scdata_way_sel_c2, 
   sctag_scdata_stdecc_c2, sctag_scdata_set_c2, 
   sctag_scdata_rd_wr_c2, sctag_scdata_fbrd_c3, 
   sctag_scdata_fb_hit_c3, sctag_scdata_col_offset_c2, 
   scbuf_scdata_fbdecc_c4, efc_scdata_fuse_dshift, 
   efc_scdata_fuse_data, efc_scdata_fuse_clk2, efc_scdata_fuse_clk1, 
   efc_scdata_fuse_ashift, cmp_gclk, global_shift_enable, si, arst_l, 
   grst_l, cluster_cken, ctu_tst_pre_grst_l, ctu_tst_scanmode, 
   ctu_tst_scan_disable, ctu_tst_macrotest, ctu_tst_short_chain
   );

   input [1:0] 		cmp_gclk;                    // To data of bw_r_l2d.v
   input 		global_shift_enable;    // To data of bw_r_l2d.v
   input 		si;      // To data of bw_r_l2d.v
   input 		arst_l, grst_l;
   input 		cluster_cken;
   input 		ctu_tst_pre_grst_l;
   input 		ctu_tst_scanmode;
   input 		ctu_tst_scan_disable;
   input 		ctu_tst_macrotest;
   input 		ctu_tst_short_chain;
		
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input		efc_scdata_fuse_ashift;	// To efuse_hdr of scdata_efuse_hdr.v
   input		efc_scdata_fuse_clk1;	// To efuse_hdr of scdata_efuse_hdr.v, ...
   input		efc_scdata_fuse_clk2;	// To efuse_hdr of scdata_efuse_hdr.v, ...
   input		efc_scdata_fuse_data;	// To efuse_hdr of scdata_efuse_hdr.v
   input		efc_scdata_fuse_dshift;	// To efuse_hdr of scdata_efuse_hdr.v
   input [623:0]	scbuf_scdata_fbdecc_c4;	// To periph_io of scdata_periph_io.v
   input [3:0]		sctag_scdata_col_offset_c2;// To rep of scdata_rep.v
   input		sctag_scdata_fb_hit_c3;	// To rep of scdata_rep.v
   input		sctag_scdata_fbrd_c3;	// To rep of scdata_rep.v
   input		sctag_scdata_rd_wr_c2;	// To rep of scdata_rep.v
   input [9:0]		sctag_scdata_set_c2;	// To rep of scdata_rep.v
   input [77:0]		sctag_scdata_stdecc_c2;	// To rep of scdata_rep.v
   input [11:0]		sctag_scdata_way_sel_c2;// To rep of scdata_rep.v
   input [15:0]		sctag_scdata_word_en_c2;// To rep of scdata_rep.v
   // End of automatics

   output 		so;
   
   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		scdata_efc_fuse_data;	// From efuse_hdr of scdata_efuse_hdr.v
   output [623:0]	scdata_scbuf_decc_out_c7;// From periph_io of scdata_periph_io.v
   output [155:0]	scdata_sctag_decc_c6;	// From rep of scdata_rep.v
   // End of automatics

   wire 		tm_l;
   wire 		so_subbank_3;
   wire 		so_clk_hdr;
   wire 		so_efuse_hdr;
   wire 		so_subbank_0;
   wire 		mem_write_disable;
   wire 		se_buf;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [3:0]		cache_col_offset_c3;	// From ctr of scdata_ctr_io.v
   wire [623:0]		cache_decc_in_c3;	// From ctr of scdata_ctr_io.v
   wire [623:0]		cache_decc_out_c5;	// From subbank_0 of scdata_subbank.v, ...
   wire [9:0]		cache_set_c3_0;		// From ctr of scdata_ctr_io.v
   wire [9:0]		cache_set_c3_1;		// From ctr of scdata_ctr_io.v
   wire [9:0]		cache_set_c3_2;		// From ctr of scdata_ctr_io.v
   wire [9:0]		cache_set_c3_3;		// From ctr of scdata_ctr_io.v
   wire [11:0]		cache_way_sel_c3_0;	// From ctr of scdata_ctr_io.v
   wire [11:0]		cache_way_sel_c3_1;	// From ctr of scdata_ctr_io.v
   wire [11:0]		cache_way_sel_c3_2;	// From ctr of scdata_ctr_io.v
   wire [11:0]		cache_way_sel_c3_3;	// From ctr of scdata_ctr_io.v
   wire [15:0]		cache_word_en_c3;	// From ctr of scdata_ctr_io.v
   wire			cache_wr_en_c3_0;	// From ctr of scdata_ctr_io.v
   wire			cache_wr_en_c3_1;	// From ctr of scdata_ctr_io.v
   wire			cache_wr_en_c3_2;	// From ctr of scdata_ctr_io.v
   wire			cache_wr_en_c3_3;	// From ctr of scdata_ctr_io.v
   wire			fuse_red_data;		// From efuse_hdr of scdata_efuse_hdr.v
   wire [2:0]		fuse_red_rid;		// From efuse_hdr of scdata_efuse_hdr.v
   wire [5:0]		fuse_red_subbank0_dshift;// From efuse_hdr of scdata_efuse_hdr.v
   wire 		fuse_red_read_shift;// From efuse_hdr of scdata_efuse_hdr.v
   wire [5:0]		fuse_red_subbank1_dshift;// From efuse_hdr of scdata_efuse_hdr.v
   wire [5:0]		fuse_red_subbank2_dshift;// From efuse_hdr of scdata_efuse_hdr.v
   wire [5:0]		fuse_red_subbank3_dshift;// From efuse_hdr of scdata_efuse_hdr.v
   wire			red_fuse_data;		// From subbank_2 of scdata_subbank.v
   wire			red_fuse_data_0;	// From subbank_0 of scdata_subbank.v
   wire			red_fuse_data_1;	// From subbank_1 of scdata_subbank.v
   wire			red_fuse_data_3;	// From subbank_3 of scdata_subbank.v
   wire [623:0]		scbuf_scdata_fbdecc_c5;	// From periph_io of scdata_periph_io.v
   wire [623:0]		scbuf_scdata_fbdecc_c5_buf;// From subbank_1 of scdata_subbank.v, ...
   wire [623:0]		scdata_decc_out_c6;	// From ctr of scdata_ctr_io.v
   wire [623:0]		scdata_scbuf_decc_c6_buf;// From subbank_1 of scdata_subbank.v, ...
   wire [155:0]		scdata_sctag_decc_c6_ctr;// From ctr of scdata_ctr_io.v
   wire [3:0]		sctag_scdata_col_offset_c2_buf;// From rep of scdata_rep.v
   wire			sctag_scdata_fb_hit_c3_buf;// From rep of scdata_rep.v
   wire			sctag_scdata_fbrd_c3_buf;// From rep of scdata_rep.v
   wire			sctag_scdata_rd_wr_c2_buf;// From rep of scdata_rep.v
   wire [9:0]		sctag_scdata_set_c2_buf;// From rep of scdata_rep.v
   wire [77:0]		sctag_scdata_stdecc_c2_buf;// From rep of scdata_rep.v
   wire [11:0]		sctag_scdata_way_sel_c2_buf;// From rep of scdata_rep.v
   wire [15:0]		sctag_scdata_word_en_c2_buf;// From rep of scdata_rep.v
   wire			so_ctr_io;		// From ctr of scdata_ctr_io.v
   wire			so_periph_io;		// From periph_io of scdata_periph_io.v
   wire			so_subbank_1;		// From subbank_1 of scdata_subbank.v
   wire			so_subbank_2;		// From subbank_2 of scdata_subbank.v
   // End of automatics

   wire 		rclk;
   wire 		se;
   wire 		sehold;

   bw_clk_cl_scdata_cmp  header(.cluster_grst_l(),
                        	.gclk(cmp_gclk),
                        	.se(global_shift_enable),
                        	.si(so_subbank_3),
                        	.so(so_clk_hdr),
                        	.rclk(rclk),
                        	.dbginit_l    (),
				.cluster_cken (cluster_cken),
				.arst_l       (arst_l),
				.arst2_l       (arst_l),
				.grst_l       (grst_l),
				.adbginit_l   (1'b1),
				.gdbginit_l   (1'b0));

test_stub_scan tstub
  (// Outputs
   .mux_drive_disable    (mem_write_disable),
   .mem_write_disable    (),
   .sehold               (sehold),
   .se                   (se),
   .testmode_l           (tm_l),
   .mem_bypass           (),
   .so_0                 (so),
   .so_1                 (),
   .so_2                 (),

   // Inputs
   .ctu_tst_pre_grst_l   (ctu_tst_pre_grst_l),
   .arst_l               (1'b1),
   .global_shift_enable  (global_shift_enable),
   .ctu_tst_scan_disable (ctu_tst_scan_disable),
   .ctu_tst_scanmode     (ctu_tst_scanmode),
   .ctu_tst_macrotest    (ctu_tst_macrotest),
   .ctu_tst_short_chain  (ctu_tst_short_chain),
   .long_chain_so_0      (so_efuse_hdr),
   .short_chain_so_0     (1'b0),
   .long_chain_so_1      (1'b0),
   .short_chain_so_1     (1'b0),
   .long_chain_so_2      (1'b0),
   .short_chain_so_2     (1'b0)
  );

   scdata_rep rep(/*AUTOINST*/
		  // Outputs
		  .sctag_scdata_col_offset_c2_buf(sctag_scdata_col_offset_c2_buf[3:0]),
		  .sctag_scdata_fb_hit_c3_buf(sctag_scdata_fb_hit_c3_buf),
		  .sctag_scdata_fbrd_c3_buf(sctag_scdata_fbrd_c3_buf),
		  .sctag_scdata_rd_wr_c2_buf(sctag_scdata_rd_wr_c2_buf),
		  .sctag_scdata_set_c2_buf(sctag_scdata_set_c2_buf[9:0]),
		  .sctag_scdata_stdecc_c2_buf(sctag_scdata_stdecc_c2_buf[77:0]),
		  .sctag_scdata_way_sel_c2_buf(sctag_scdata_way_sel_c2_buf[11:0]),
		  .sctag_scdata_word_en_c2_buf(sctag_scdata_word_en_c2_buf[15:0]),
		  .scdata_sctag_decc_c6	(scdata_sctag_decc_c6[155:0]),
		  // Inputs
		  .sctag_scdata_col_offset_c2(sctag_scdata_col_offset_c2[3:0]),
		  .sctag_scdata_fb_hit_c3(sctag_scdata_fb_hit_c3),
		  .sctag_scdata_fbrd_c3	(sctag_scdata_fbrd_c3),
		  .sctag_scdata_rd_wr_c2(sctag_scdata_rd_wr_c2),
		  .sctag_scdata_set_c2	(sctag_scdata_set_c2[9:0]),
		  .sctag_scdata_stdecc_c2(sctag_scdata_stdecc_c2[77:0]),
		  .sctag_scdata_way_sel_c2(sctag_scdata_way_sel_c2[11:0]),
		  .sctag_scdata_word_en_c2(sctag_scdata_word_en_c2[15:0]),
		  .scdata_sctag_decc_c6_ctr(scdata_sctag_decc_c6_ctr[155:0]));
		  
   scdata_ctr_io ctr(
		     // Inputs
		     .scbuf_scdata_fbdecc_c5(scbuf_scdata_fbdecc_c5_buf[623:0]),
		     .se		(se),
		     .si		(so_subbank_1),
		     // Outputs
		     .so		(so_ctr_io),
		     /*AUTOINST*/
		     // Outputs
		     .scdata_sctag_decc_c6_ctr(scdata_sctag_decc_c6_ctr[155:0]),
		     .scdata_decc_out_c6(scdata_decc_out_c6[623:0]),
		     .cache_decc_in_c3	(cache_decc_in_c3[623:0]),
		     .cache_col_offset_c3(cache_col_offset_c3[3:0]),
		     .cache_word_en_c3	(cache_word_en_c3[15:0]),
		     .cache_way_sel_c3_0(cache_way_sel_c3_0[11:0]),
		     .cache_set_c3_0	(cache_set_c3_0[9:0]),
		     .cache_wr_en_c3_0	(cache_wr_en_c3_0),
		     .cache_way_sel_c3_1(cache_way_sel_c3_1[11:0]),
		     .cache_set_c3_1	(cache_set_c3_1[9:0]),
		     .cache_wr_en_c3_1	(cache_wr_en_c3_1),
		     .cache_way_sel_c3_2(cache_way_sel_c3_2[11:0]),
		     .cache_set_c3_2	(cache_set_c3_2[9:0]),
		     .cache_wr_en_c3_2	(cache_wr_en_c3_2),
		     .cache_way_sel_c3_3(cache_way_sel_c3_3[11:0]),
		     .cache_set_c3_3	(cache_set_c3_3[9:0]),
		     .cache_wr_en_c3_3	(cache_wr_en_c3_3),
		     // Inputs
		     .sctag_scdata_way_sel_c2_buf(sctag_scdata_way_sel_c2_buf[11:0]),
		     .sctag_scdata_rd_wr_c2_buf(sctag_scdata_rd_wr_c2_buf),
		     .sctag_scdata_set_c2_buf(sctag_scdata_set_c2_buf[9:0]),
		     .sctag_scdata_col_offset_c2_buf(sctag_scdata_col_offset_c2_buf[3:0]),
		     .sctag_scdata_word_en_c2_buf(sctag_scdata_word_en_c2_buf[15:0]),
		     .sctag_scdata_fbrd_c3_buf(sctag_scdata_fbrd_c3_buf),
		     .sctag_scdata_fb_hit_c3_buf(sctag_scdata_fb_hit_c3_buf),
		     .sctag_scdata_stdecc_c2_buf(sctag_scdata_stdecc_c2_buf[77:0]),
		     .cache_decc_out_c5	(cache_decc_out_c5[623:0]),
		     .rclk		(rclk));

   scdata_periph_io  periph_io(
			       // Inputs
			       .scdata_decc_out_c6(scdata_scbuf_decc_c6_buf[623:0]),
			       .se	(se_buf),
			       .si	(si),
			       // Outputs
			       .so	(so_periph_io),
			       /*AUTOINST*/
			       // Outputs
			       .scdata_scbuf_decc_out_c7(scdata_scbuf_decc_out_c7[623:0]),
			       .scbuf_scdata_fbdecc_c5(scbuf_scdata_fbdecc_c5[623:0]),
			       // Inputs
			       .scbuf_scdata_fbdecc_c4(scbuf_scdata_fbdecc_c4[623:0]),
			       .rclk	(rclk));
   

   scdata_efuse_hdr efuse_hdr(
			      .si	(so_subbank_0),
			      .so	(so_efuse_hdr),
			      .testmode_l(tm_l),
			      /*AUTOINST*/
			      // Outputs
			      .scdata_efc_fuse_data(scdata_efc_fuse_data),
			      .fuse_red_data(fuse_red_data),
			      .fuse_red_subbank0_dshift(fuse_red_subbank0_dshift[5:0]),
			      .fuse_red_subbank1_dshift(fuse_red_subbank1_dshift[5:0]),
			      .fuse_red_subbank2_dshift(fuse_red_subbank2_dshift[5:0]),
			      .fuse_red_subbank3_dshift(fuse_red_subbank3_dshift[5:0]),
			      .fuse_red_read_shift(fuse_red_read_shift),
			      .fuse_red_rid(fuse_red_rid[2:0]),
			      // Inputs
			      .rclk	(rclk),
			      .se	(se),
			      .efc_scdata_fuse_clk1(efc_scdata_fuse_clk1),
			      .efc_scdata_fuse_clk2(efc_scdata_fuse_clk2),
			      .efc_scdata_fuse_ashift(efc_scdata_fuse_ashift),
			      .efc_scdata_fuse_dshift(efc_scdata_fuse_dshift),
			      .efc_scdata_fuse_data(efc_scdata_fuse_data),
			      .red_fuse_data(red_fuse_data),
			      .arst_l	(arst_l));   

   
   /*scdata_subbank   AUTO_TEMPLATE(
    .decc_out	(cache_decc_out_c5[@"(+ 155 (* 156 @))":@"(* 156 @)"]),
    // Inputs
    .col_offset	(cache_col_offset_c3[@]),
    .decc_in	(cache_decc_in_c3[@"(+ 155 (* 156 @))":@"(* 156 @)"]),
    .set	(cache_set_c3_@[9:0]),
    .way_sel	(cache_way_sel_c3_@[11:0]),
    .word_en	(cache_word_en_c3[@"(+ 3 (* @ 4))":@"(* @ 4)"]),
    .wr_en	(cache_wr_en_c3_@),
    .fuse_l2d_wren (fuse_red_subbank@_dshift[5:0]),
    .fuse_l2d_rden (fuse_red_read_shift),
    .fuse_l2d_rid  (fuse_red_rid[2:0]),
    .fuse_l2d_data_in (fuse_red_data),
    .l2d_fuse_data_out (red_fuse_data_@));
    */

   scdata_subbank  subbank_0(
			     // Outputs
			     .scbuf_scdata_fbdecc_bot_buf(),
			     .scbuf_scdata_fbdecc_top_buf(),
			     .scdata_scbuf_decc_c6_bot_buf(),
			     .scdata_scbuf_decc_c6_top_buf(),
			     .so	(so_subbank_0),
			     .se_buf(),
			     // Inputs
			     .fuse_read_data_in(red_fuse_data_1),
			     .scbuf_scdata_fbdecc_bot(156'b0),
			     .scbuf_scdata_fbdecc_top(156'b0),
			     .scdata_scbuf_decc_bot(156'b0),
			     .scdata_scbuf_decc_top(156'b0),
			     .se	(se),
			     .si	(so_subbank_2),
			     /*AUTOINST*/
			     // Outputs
			     .decc_out	(cache_decc_out_c5[155:0]), // Templated
			     .l2d_fuse_data_out(red_fuse_data_0), // Templated
			     // Inputs
			     .way_sel	(cache_way_sel_c3_0[11:0]), // Templated
			     .arst_l	(arst_l),
			     .col_offset(cache_col_offset_c3[0]), // Templated
			     .decc_in	(cache_decc_in_c3[155:0]), // Templated
			     .efc_scdata_fuse_clk1(efc_scdata_fuse_clk1),
			     .efc_scdata_fuse_clk2(efc_scdata_fuse_clk2),
			     .fuse_l2d_data_in(fuse_red_data),	 // Templated
			     .fuse_l2d_rden(fuse_red_read_shift), // Templated
			     .fuse_l2d_rid(fuse_red_rid[2:0]),	 // Templated
			     .fuse_l2d_wren(fuse_red_subbank0_dshift[5:0]), // Templated
			     .mem_write_disable(mem_write_disable),
			     .rclk	(rclk),
			     .sehold	(sehold),
			     .set	(cache_set_c3_0[9:0]),	 // Templated
			     .word_en	(cache_word_en_c3[3:0]), // Templated
			     .wr_en	(cache_wr_en_c3_0));	 // Templated

   scdata_subbank  subbank_1(
			     // Outputs
			     .scbuf_scdata_fbdecc_top_buf(scbuf_scdata_fbdecc_c5_buf[311:156]),
			     .scbuf_scdata_fbdecc_bot_buf(scbuf_scdata_fbdecc_c5_buf[155:0]),
			     .scdata_scbuf_decc_c6_top_buf(scdata_scbuf_decc_c6_buf[311:156]),
			     .scdata_scbuf_decc_c6_bot_buf(scdata_scbuf_decc_c6_buf[155:0]),
			     .so	(so_subbank_1),
			     .se_buf(),
			     // Inputs
			     .fuse_read_data_in(red_fuse_data_3),
			     .scbuf_scdata_fbdecc_top(scbuf_scdata_fbdecc_c5[311:156]),
			     .scbuf_scdata_fbdecc_bot(scbuf_scdata_fbdecc_c5[155:0]),
			     .scdata_scbuf_decc_top(scdata_decc_out_c6[311:156]),
			     .scdata_scbuf_decc_bot(scdata_decc_out_c6[155:0]),
			     .se	(se),
			     .si	(so_clk_hdr),
			     /*AUTOINST*/
			     // Outputs
			     .decc_out	(cache_decc_out_c5[311:156]), // Templated
			     .l2d_fuse_data_out(red_fuse_data_1), // Templated
			     // Inputs
			     .way_sel	(cache_way_sel_c3_1[11:0]), // Templated
			     .arst_l	(arst_l),
			     .col_offset(cache_col_offset_c3[1]), // Templated
			     .decc_in	(cache_decc_in_c3[311:156]), // Templated
			     .efc_scdata_fuse_clk1(efc_scdata_fuse_clk1),
			     .efc_scdata_fuse_clk2(efc_scdata_fuse_clk2),
			     .fuse_l2d_data_in(fuse_red_data),	 // Templated
			     .fuse_l2d_rden(fuse_red_read_shift), // Templated
			     .fuse_l2d_rid(fuse_red_rid[2:0]),	 // Templated
			     .fuse_l2d_wren(fuse_red_subbank1_dshift[5:0]), // Templated
			     .mem_write_disable(mem_write_disable),
			     .rclk	(rclk),
			     .sehold	(sehold),
			     .set	(cache_set_c3_1[9:0]),	 // Templated
			     .word_en	(cache_word_en_c3[7:4]), // Templated
			     .wr_en	(cache_wr_en_c3_1));	 // Templated

   scdata_subbank  subbank_2(
			     // Outputs
			     .scbuf_scdata_fbdecc_bot_buf(),
			     .scbuf_scdata_fbdecc_top_buf(),
			     .scdata_scbuf_decc_c6_bot_buf(),
			     .scdata_scbuf_decc_c6_top_buf(),
			     .so	(so_subbank_2),
			     .se_buf(),
			     .l2d_fuse_data_out (red_fuse_data),
			     // Inputs
			     .fuse_read_data_in(red_fuse_data_0),
			     .scbuf_scdata_fbdecc_bot(156'b0),
			     .scbuf_scdata_fbdecc_top(156'b0),
			     .scdata_scbuf_decc_bot(156'b0),
			     .scdata_scbuf_decc_top(156'b0),
			     .se	(se),
			     .si	(so_ctr_io),
			     /*AUTOINST*/
			     // Outputs
			     .decc_out	(cache_decc_out_c5[467:312]), // Templated
			     // Inputs
			     .way_sel	(cache_way_sel_c3_2[11:0]), // Templated
			     .arst_l	(arst_l),
			     .col_offset(cache_col_offset_c3[2]), // Templated
			     .decc_in	(cache_decc_in_c3[467:312]), // Templated
			     .efc_scdata_fuse_clk1(efc_scdata_fuse_clk1),
			     .efc_scdata_fuse_clk2(efc_scdata_fuse_clk2),
			     .fuse_l2d_data_in(fuse_red_data),	 // Templated
			     .fuse_l2d_rden(fuse_red_read_shift), // Templated
			     .fuse_l2d_rid(fuse_red_rid[2:0]),	 // Templated
			     .fuse_l2d_wren(fuse_red_subbank2_dshift[5:0]), // Templated
			     .mem_write_disable(mem_write_disable),
			     .rclk	(rclk),
			     .sehold	(sehold),
			     .set	(cache_set_c3_2[9:0]),	 // Templated
			     .word_en	(cache_word_en_c3[11:8]), // Templated
			     .wr_en	(cache_wr_en_c3_2));	 // Templated

   scdata_subbank  subbank_3(
			     // Outputs
			     .scbuf_scdata_fbdecc_top_buf(scbuf_scdata_fbdecc_c5_buf[623:468]),
			     .scbuf_scdata_fbdecc_bot_buf(scbuf_scdata_fbdecc_c5_buf[467:312]),
			     .scdata_scbuf_decc_c6_top_buf(scdata_scbuf_decc_c6_buf[623:468]),
			     .scdata_scbuf_decc_c6_bot_buf(scdata_scbuf_decc_c6_buf[467:312]),
			     .so	(so_subbank_3),
			     .se_buf(se_buf),
			     // Inputs
			     .fuse_read_data_in(1'b0),
			     .scbuf_scdata_fbdecc_top(scbuf_scdata_fbdecc_c5[623:468]),
			     .scbuf_scdata_fbdecc_bot(scbuf_scdata_fbdecc_c5[467:312]),
			     .scdata_scbuf_decc_top(scdata_decc_out_c6[623:468]),
			     .scdata_scbuf_decc_bot(scdata_decc_out_c6[467:312]),
			     .se	(se),
			     .si	(so_periph_io),
			     /*AUTOINST*/
			     // Outputs
			     .decc_out	(cache_decc_out_c5[623:468]), // Templated
			     .l2d_fuse_data_out(red_fuse_data_3), // Templated
			     // Inputs
			     .way_sel	(cache_way_sel_c3_3[11:0]), // Templated
			     .arst_l	(arst_l),
			     .col_offset(cache_col_offset_c3[3]), // Templated
			     .decc_in	(cache_decc_in_c3[623:468]), // Templated
			     .efc_scdata_fuse_clk1(efc_scdata_fuse_clk1),
			     .efc_scdata_fuse_clk2(efc_scdata_fuse_clk2),
			     .fuse_l2d_data_in(fuse_red_data),	 // Templated
			     .fuse_l2d_rden(fuse_red_read_shift), // Templated
			     .fuse_l2d_rid(fuse_red_rid[2:0]),	 // Templated
			     .fuse_l2d_wren(fuse_red_subbank3_dshift[5:0]), // Templated
			     .mem_write_disable(mem_write_disable),
			     .rclk	(rclk),
			     .sehold	(sehold),
			     .set	(cache_set_c3_3[9:0]),	 // Templated
			     .word_en	(cache_word_en_c3[15:12]), // Templated
			     .wr_en	(cache_wr_en_c3_3));	 // Templated


   // synopsys translate_off
   // for monitor, MSS, and debug

   // breaking scdata_scbuf_decc_out_c7 into data and ecc
   wire [511:0] 	scdata_scbuf_data_out_c7;
   wire [111:0] 	scdata_scbuf_ecc_out_c7;
   assign 		{ scdata_scbuf_data_out_c7[31:0], scdata_scbuf_ecc_out_c7[6:0] } = scdata_scbuf_decc_out_c7[38:0];
   assign 		{ scdata_scbuf_data_out_c7[63:32], scdata_scbuf_ecc_out_c7[13:7] } = scdata_scbuf_decc_out_c7[77:39];
   assign 		{ scdata_scbuf_data_out_c7[95:64], scdata_scbuf_ecc_out_c7[20:14] } = scdata_scbuf_decc_out_c7[116:78];
   assign 		{ scdata_scbuf_data_out_c7[127:96], scdata_scbuf_ecc_out_c7[27:21] } = scdata_scbuf_decc_out_c7[155:117];
   assign 		{ scdata_scbuf_data_out_c7[159:128], scdata_scbuf_ecc_out_c7[34:28] } = scdata_scbuf_decc_out_c7[194:156];
   assign 		{ scdata_scbuf_data_out_c7[191:160], scdata_scbuf_ecc_out_c7[41:35] } = scdata_scbuf_decc_out_c7[233:195];
   assign 		{ scdata_scbuf_data_out_c7[223:192], scdata_scbuf_ecc_out_c7[48:42] } = scdata_scbuf_decc_out_c7[272:234];
   assign 		{ scdata_scbuf_data_out_c7[255:224], scdata_scbuf_ecc_out_c7[55:49] } = scdata_scbuf_decc_out_c7[311:273];
   assign 		{ scdata_scbuf_data_out_c7[287:256], scdata_scbuf_ecc_out_c7[62:56] } = scdata_scbuf_decc_out_c7[350:312];
   assign 		{ scdata_scbuf_data_out_c7[319:288], scdata_scbuf_ecc_out_c7[69:63] } = scdata_scbuf_decc_out_c7[389:351];
   assign 		{ scdata_scbuf_data_out_c7[351:320], scdata_scbuf_ecc_out_c7[76:70] } = scdata_scbuf_decc_out_c7[428:390];
   assign 		{ scdata_scbuf_data_out_c7[383:352], scdata_scbuf_ecc_out_c7[83:77] } = scdata_scbuf_decc_out_c7[467:429];
   assign 		{ scdata_scbuf_data_out_c7[415:384], scdata_scbuf_ecc_out_c7[90:84] } = scdata_scbuf_decc_out_c7[506:468];
   assign 		{ scdata_scbuf_data_out_c7[447:416], scdata_scbuf_ecc_out_c7[97:91] } = scdata_scbuf_decc_out_c7[545:507];
   assign 		{ scdata_scbuf_data_out_c7[479:448], scdata_scbuf_ecc_out_c7[104:98] } = scdata_scbuf_decc_out_c7[584:546];
   assign 		{ scdata_scbuf_data_out_c7[511:480], scdata_scbuf_ecc_out_c7[111:105] } = scdata_scbuf_decc_out_c7[623:585];


   // breaking cache_decc_out_c5 into data and ecc
   wire [511:0] 	cache_data_out_c5;
   wire [111:0] 	cache_ecc_out_c5;
   
   assign 		{ cache_data_out_c5[31:0], cache_ecc_out_c5[6:0] } = cache_decc_out_c5[38:0];
   assign 		{ cache_data_out_c5[63:32], cache_ecc_out_c5[13:7] } = cache_decc_out_c5[77:39];
   assign 		{ cache_data_out_c5[95:64], cache_ecc_out_c5[20:14] } = cache_decc_out_c5[116:78];
   assign 		{ cache_data_out_c5[127:96], cache_ecc_out_c5[27:21] } = cache_decc_out_c5[155:117];
   assign 		{ cache_data_out_c5[159:128], cache_ecc_out_c5[34:28] } = cache_decc_out_c5[194:156];
   assign 		{ cache_data_out_c5[191:160], cache_ecc_out_c5[41:35] } = cache_decc_out_c5[233:195];
   assign 		{ cache_data_out_c5[223:192], cache_ecc_out_c5[48:42] } = cache_decc_out_c5[272:234];
   assign 		{ cache_data_out_c5[255:224], cache_ecc_out_c5[55:49] } = cache_decc_out_c5[311:273];
   assign 		{ cache_data_out_c5[287:256], cache_ecc_out_c5[62:56] } = cache_decc_out_c5[350:312];
   assign 		{ cache_data_out_c5[319:288], cache_ecc_out_c5[69:63] } = cache_decc_out_c5[389:351];
   assign 		{ cache_data_out_c5[351:320], cache_ecc_out_c5[76:70] } = cache_decc_out_c5[428:390];
   assign 		{ cache_data_out_c5[383:352], cache_ecc_out_c5[83:77] } = cache_decc_out_c5[467:429];
   assign 		{ cache_data_out_c5[415:384], cache_ecc_out_c5[90:84] } = cache_decc_out_c5[506:468];
   assign 		{ cache_data_out_c5[447:416], cache_ecc_out_c5[97:91] } = cache_decc_out_c5[545:507];
   assign 		{ cache_data_out_c5[479:448], cache_ecc_out_c5[104:98] } = cache_decc_out_c5[584:546];
   assign 		{ cache_data_out_c5[511:480], cache_ecc_out_c5[111:105] } = cache_decc_out_c5[623:585];

   // Stagin cache_data/ecc out
   reg 			cache_acc_en_c3, cache_acc_en_c4;
   reg 			cache_wr_en_c4;
   reg [9:0] 		cache_set_c4;
   reg [3:0]		cache_col_offset_c4;
   reg [15:0] 		cache_word_en_c4;
   reg [11:0] 		cache_way_sel_c4;
   reg [3:0] 		col_offset_c3;
   
   always @(posedge rclk) begin
      // Access enable is a 16b OR of way selects.
      cache_acc_en_c3  <= |(sctag_scdata_way_sel_c2);
      cache_acc_en_c4	 <=  cache_acc_en_c3 ;

      cache_wr_en_c4 <= cache_wr_en_c3_0;
      cache_set_c4 <= cache_set_c3_0;
      col_offset_c3 <= sctag_scdata_col_offset_c2[3:0];
      cache_col_offset_c4 <= cache_col_offset_c3;
      cache_word_en_c4 <= cache_word_en_c3;
      cache_way_sel_c4 <= cache_way_sel_c3_0;
   end

   // Checkers
   
   always @(cache_acc_en_c3 or cache_acc_en_c4
	    or col_offset_c3 or cache_col_offset_c4) begin
      if( cache_acc_en_c3 & ~|( col_offset_c3) ) begin
	`ifdef MODELSIM	  
	 $display( "SCDATA", " column Offset  Should not be zero%h", col_offset_c3 );
	`else 
	 $error( "SCDATA", " column Offset  Should not be zero%h", col_offset_c3 );
	`endif
      end
      if( cache_acc_en_c3 & cache_acc_en_c4 & (|( col_offset_c3 & cache_col_offset_c4)) ) begin
	`ifdef MODELSIM  
	 $display( "SCDATA", "Illegal  back to back accesses c3_col=%b c4_col=%b ", 
		 col_offset_c3, cache_col_offset_c4 );
	`else
	 $error( "SCDATA", "Illegal  back to back accesses c3_col=%b c4_col=%b ", 
		 col_offset_c3, cache_col_offset_c4 );
	`endif
      end
   end
   
   always @(posedge rclk) begin
	if (arst_l & grst_l) begin
	   case(sctag_scdata_way_sel_c2)
	     12'b000000000000: ;
	     12'b000000000001: ;
	     12'b000000000010: ;
	     12'b000000000100: ;
	     12'b000000001000: ;
	     12'b000000010000: ;
	     12'b000000100000: ;
	     12'b000001000000: ;
	     12'b000010000000: ;
	     12'b000100000000: ;
	     12'b001000000000: ;
	     12'b010000000000: ;
	     12'b100000000000: ;
	     default:
		`ifdef MODELSIM
		 	$display("L2_DATA_ERR"," way select error %h ", sctag_scdata_way_sel_c2[11:0]);
		`else	
		 	$error("L2_DATA_ERR"," way select error %h ", sctag_scdata_way_sel_c2[11:0]); 
		`endif	
	   endcase
	end // if (arst_l & grst_l)
   end // always @ (posedge rclk)

   // synopsys translate_on
   
   
endmodule // scdata
