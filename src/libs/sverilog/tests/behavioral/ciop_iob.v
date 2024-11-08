// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ciop_iob.v
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
`timescale 1ps/1ps

module ciop_iob(
   // Outputs
   iob_pcx_stall_pq, iob_jbi_mondo_nack, iob_jbi_mondo_ack, 
   iob_jbi_dbg_lo_vld, iob_jbi_dbg_lo_data, iob_jbi_dbg_hi_vld, 
   iob_jbi_dbg_hi_data, iob_io_dbg_en, iob_io_dbg_data, 
   iob_ctu_coreavail, iob_cpx_req_cq, iob_cpx_data_ca, iob_clk_tr, 
   iob_clk_l2_tr, iob_clk_data, iob_clk_stall, iob_clk_vld, 
   iob_dram02_data, iob_dram02_stall, iob_dram02_vld, 
   iob_dram13_data, iob_dram13_stall, iob_dram13_vld, 
   iob_jbi_pio_data, iob_jbi_pio_stall, iob_jbi_pio_vld, 
   iob_jbi_spi_data, iob_jbi_spi_stall, iob_jbi_spi_vld, 
   iob_tap_data, iob_tap_stall, iob_tap_vld, iob_scanout, 
   iob_io_dbg_ck_p, iob_io_dbg_ck_n, 
   // Inputs
   pcx_iob_data_rdy_px2, pcx_iob_data_px2, l2_dbgbus_23, 
   l2_dbgbus_01, jbus_grst_l, jbus_gdbginit_l, jbus_gclk, 
   jbus_arst_l, jbus_adbginit_l, jbi_iob_mondo_vld, 
   jbi_iob_mondo_data, io_trigin, io_temp_trig, global_shift_enable, 
   efc_iob_sernum2_dshift, efc_iob_sernum1_dshift, 
   efc_iob_sernum0_dshift, efc_iob_fusestat_dshift, 
   efc_iob_fuse_data, efc_iob_fuse_clk2, efc_iob_fuse_clk1, 
   efc_iob_coreavail_dshift, dbg_en_23, dbg_en_01, 
   ctu_tst_short_chain, ctu_tst_scanmode, ctu_tst_scan_disable, 
   ctu_tst_pre_grst_l, ctu_tst_macrotest, ctu_iob_wake_thr, 
   cpx_iob_grant_cx2, cmp_grst_l, cmp_gdbginit_l, cmp_gclk, 
   cmp_arst_l, cmp_adbginit_l, clspine_jbus_tx_sync, 
   clspine_jbus_rx_sync, clspine_iob_resetstat_wr, 
   clspine_iob_resetstat, clk_iob_cken, clk_iob_data, clk_iob_stall, 
   clk_iob_vld, dram02_iob_data, dram02_iob_stall, dram02_iob_vld, 
   dram13_iob_data, dram13_iob_stall, dram13_iob_vld, 
   jbi_iob_pio_data, jbi_iob_pio_stall, jbi_iob_pio_vld, 
   jbi_iob_spi_data, jbi_iob_spi_stall, jbi_iob_spi_vld, 
   tap_iob_data, tap_iob_stall, tap_iob_vld, iob_scanin,
   spc0_inst_done, pc_w0, spc1_inst_done, pc_w1, spc2_inst_done, 
   pc_w2, spc3_inst_done, pc_w3, spc4_inst_done, pc_w4, 
   spc5_inst_done, pc_w5, spc6_inst_done, pc_w6, spc7_inst_done, 
   pc_w7
   );

   input		clk_iob_cken;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v, ...
   input [`IOB_RESET_STAT_WIDTH-1:0]clspine_iob_resetstat;// To iobdg_ctrl of iobdg_ctrl.v
   input		clspine_iob_resetstat_wr;// To iobdg_ctrl of iobdg_ctrl.v
   input		clspine_jbus_rx_sync;	// To cluster_header_sync of cluster_header_sync.v
   input		clspine_jbus_tx_sync;	// To cluster_header_sync of cluster_header_sync.v
   input		cmp_adbginit_l;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v
   input		cmp_arst_l;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v
   input		cmp_gclk;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v, ...
   input		cmp_gdbginit_l;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v
   input		cmp_grst_l;		// To bw_clk_cl_iobdg_cmp of bw_clk_cl_iobdg_cmp.v
   input [`IOB_CPU_WIDTH-1:0]cpx_iob_grant_cx2;	// To i2c of i2c.v
   input		ctu_iob_wake_thr;	// To iobdg_ctrl of iobdg_ctrl.v
   input		ctu_tst_macrotest;	// To test_stub_scan of test_stub_scan.v
   input		ctu_tst_pre_grst_l;	// To test_stub_scan of test_stub_scan.v
   input		ctu_tst_scan_disable;	// To test_stub_scan of test_stub_scan.v
   input		ctu_tst_scanmode;	// To test_stub_scan of test_stub_scan.v
   input		ctu_tst_short_chain;	// To test_stub_scan of test_stub_scan.v
   input		dbg_en_01;		// To iobdg_dbg of iobdg_dbg.v
   input		dbg_en_23;		// To iobdg_dbg of iobdg_dbg.v
   input		efc_iob_coreavail_dshift;// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_fuse_clk1;	// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_fuse_clk2;	// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_fuse_data;	// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_fusestat_dshift;// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_sernum0_dshift;	// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_sernum1_dshift;	// To iobdg_ctrl of iobdg_ctrl.v
   input		efc_iob_sernum2_dshift;	// To iobdg_ctrl of iobdg_ctrl.v
   input		global_shift_enable;	// To test_stub_scan of test_stub_scan.v
   input		io_temp_trig;		// To iobdg_ctrl of iobdg_ctrl.v
   input		io_trigin;		// To iobdg_dbg of iobdg_dbg.v
   input [`JBI_IOB_MONDO_BUS_WIDTH-1:0]jbi_iob_mondo_data;// To i2c of i2c.v
   input		jbi_iob_mondo_vld;	// To i2c of i2c.v
   input		jbus_adbginit_l;	// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   input		jbus_arst_l;		// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v, ...
   input		jbus_gclk;		// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   input		jbus_gdbginit_l;	// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   input		jbus_grst_l;		// To bw_clk_cl_iobdg_jbus of bw_clk_cl_iobdg_jbus.v
   input [39:0]		l2_dbgbus_01;		// To iobdg_dbg of iobdg_dbg.v
   input [39:0]		l2_dbgbus_23;		// To iobdg_dbg of iobdg_dbg.v
   input [`PCX_WIDTH-1:0]pcx_iob_data_px2;	// To c2i of c2i.v
   input		pcx_iob_data_rdy_px2;	// To c2i of c2i.v

   input                spc0_inst_done;
   input [48:0]         pc_w0;
   input                spc1_inst_done;
   input [48:0]         pc_w1;
   input                spc2_inst_done;
   input [48:0]         pc_w2;
   input                spc3_inst_done;
   input [48:0]         pc_w3;
   input                spc4_inst_done;
   input [48:0]         pc_w4;
   input                spc5_inst_done;
   input [48:0]         pc_w5;
   input                spc6_inst_done;
   input [48:0]         pc_w6;
   input                spc7_inst_done;
   input [48:0]         pc_w7;          

   output		iob_clk_l2_tr;		// From iobdg_dbg of iobdg_dbg.v
   output		iob_clk_tr;		// From iobdg_dbg of iobdg_dbg.v
   output [`CPX_WIDTH-1:0]iob_cpx_data_ca;	// From i2c of i2c.v
   output [`IOB_CPU_WIDTH-1:0]iob_cpx_req_cq;	// From i2c of i2c.v
   output [`IOB_CPU_WIDTH-1:0]iob_ctu_coreavail;// From iobdg_ctrl of iobdg_ctrl.v
   output [39:0]	iob_io_dbg_data;	// From iobdg_dbg of iobdg_dbg.v
   output		iob_io_dbg_en;		// From iobdg_dbg of iobdg_dbg.v
   output [47:0]	iob_jbi_dbg_hi_data;	// From iobdg_dbg of iobdg_dbg.v
   output		iob_jbi_dbg_hi_vld;	// From iobdg_dbg of iobdg_dbg.v
   output [47:0]	iob_jbi_dbg_lo_data;	// From iobdg_dbg of iobdg_dbg.v
   output		iob_jbi_dbg_lo_vld;	// From iobdg_dbg of iobdg_dbg.v
   output		iob_jbi_mondo_ack;	// From i2c of i2c.v
   output		iob_jbi_mondo_nack;	// From i2c of i2c.v
   output		iob_pcx_stall_pq;	// From c2i of c2i.v

   input [`CLK_IOB_WIDTH-1:0]clk_iob_data;	// To i2c of i2c.v
   input		clk_iob_stall;		// To c2i of c2i.v
   input		clk_iob_vld;		// To i2c of i2c.v
   input [`DRAM_IOB_WIDTH-1:0]dram02_iob_data;	// To i2c of i2c.v
   input		dram02_iob_stall;	// To c2i of c2i.v
   input		dram02_iob_vld;		// To i2c of i2c.v
   input [`DRAM_IOB_WIDTH-1:0]dram13_iob_data;	// To i2c of i2c.v
   input		dram13_iob_stall;	// To c2i of c2i.v
   input		dram13_iob_vld;		// To i2c of i2c.v
   input [`JBI_IOB_WIDTH-1:0]jbi_iob_pio_data;	// To i2c of i2c.v
   input		jbi_iob_pio_stall;	// To c2i of c2i.v
   input		jbi_iob_pio_vld;	// To i2c of i2c.v
   input [`SPI_IOB_WIDTH-1:0]jbi_iob_spi_data;	// To i2c of i2c.v
   input		jbi_iob_spi_stall;	// To c2i of c2i.v
   input		jbi_iob_spi_vld;	// To i2c of i2c.v
   input [`TAP_IOB_WIDTH-1:0]tap_iob_data;	// To c2i of c2i.v
   input		tap_iob_stall;		// To i2c of i2c.v
   input		tap_iob_vld;		// To c2i of c2i.v

   output [`IOB_CLK_WIDTH-1:0]iob_clk_data;	// From c2i of c2i.v
   output		iob_clk_stall;		// From i2c of i2c.v
   output		iob_clk_vld;		// From c2i of c2i.v
   output [`IOB_DRAM_WIDTH-1:0]iob_dram02_data;	// From c2i of c2i.v
   output		iob_dram02_stall;	// From i2c of i2c.v
   output		iob_dram02_vld;		// From c2i of c2i.v
   output [`IOB_DRAM_WIDTH-1:0]iob_dram13_data;	// From c2i of c2i.v
   output		iob_dram13_stall;	// From i2c of i2c.v
   output		iob_dram13_vld;		// From c2i of c2i.v
   output [`IOB_JBI_WIDTH-1:0]iob_jbi_pio_data;	// From c2i of c2i.v
   output		iob_jbi_pio_stall;	// From i2c of i2c.v
   output		iob_jbi_pio_vld;	// From c2i of c2i.v
   output [`IOB_SPI_WIDTH-1:0]iob_jbi_spi_data;	// From c2i of c2i.v
   output		iob_jbi_spi_stall;	// From i2c of i2c.v
   output		iob_jbi_spi_vld;	// From c2i of c2i.v
   output [`IOB_TAP_WIDTH-1:0]iob_tap_data;	// From i2c of i2c.v
   output		iob_tap_stall;		// From c2i of c2i.v
   output		iob_tap_vld;		// From i2c of i2c.v

   input 	  iob_scanin;
   output         iob_scanout;
   
   output [2:0]	  iob_io_dbg_ck_p;
   output [2:0]   iob_io_dbg_ck_n;
   

   //temp. memory.
   reg [`IOB_CPU_WIDTH-1:0] 	    cpx_req;
   reg [`CPX_WIDTH-1:0] 	    cpx_data;
   reg 				    pio_vld;
   reg [`IOB_JBI_WIDTH-1:0] 	    pio_data;		    
   //jbi ucb
   reg [3:0] 			    jspi_data;
   reg 				    jspi_stall;
   reg 				    jspi_vld;
   //iob and dram interface
   reg [3:0] 			    dram02_data;
   reg 				    dram02_vld;
   reg [3:0] 			    dram13_data;
   reg 				    dram13_vld;
  
   wire 			    iob_pcx_stall_pq;
   wire 			    iob_jbi_pio_stall;
   wire 			    iob_jbi_dbg_hi_vld;
   wire 			    iob_jbi_dbg_lo_vld;
   wire 			    iob_jbi_mondo_ack;
   wire 			    iob_jbi_mondo_nack;
   wire 			    iob_clk_stall;
   wire 			    iob_clk_vld;
   wire 			    iob_clspine_stall;
   wire 			    iob_clspine_vld;
   wire 			    iob_dram02_stall;
   wire 			    iob_dram02_vld;
   wire 			    iob_dram13_stall;
   wire 			    iob_dram13_vld;
   
   wire 			    iob_jbi_spi_stall;
   wire 			    iob_jbi_spi_vld;
   wire 			    iob_tap_stall;
   wire 			    iob_tap_vld;
   
   // input signals
   wire  [`PCX_WIDTH-1:0]           pcx_iob_data        = pcx_iob_data_px2;
   wire  [`IOB_CPU_WIDTH-1:0]       cpx_iob_grant       = cpx_iob_grant_cx2;	
   wire                             spc0_inst_done_buf  = spc0_inst_done;
   wire [48:0]                      pc_w0_buf           = pc_w0;
   wire                             spc1_inst_done_buf  = spc1_inst_done;
   wire [48:0]                      pc_w1_buf           = pc_w1;
   wire                             spc2_inst_done_buf  = spc2_inst_done;
   wire [48:0]                      pc_w2_buf           = pc_w2;
   wire                             spc3_inst_done_buf  = spc3_inst_done;
   wire [48:0]                      pc_w3_buf           = pc_w3;
   wire                             spc4_inst_done_buf  = spc4_inst_done;
   wire [48:0]                      pc_w4_buf           = pc_w4;
   wire                             spc5_inst_done_buf  = spc5_inst_done;
   wire [48:0]                      pc_w5_buf           = pc_w5;
   wire                             spc6_inst_done_buf  = spc6_inst_done;
   wire [48:0]                      pc_w6_buf           = pc_w6;
   wire                             spc7_inst_done_buf  = spc7_inst_done;
   wire [48:0]                      pc_w7_buf           = pc_w7;          

   //drive signals.
   assign 			    iob_pcx_stall_pq    = 0;
   assign 			    iob_jbi_pio_stall   = 0;
   assign 			    iob_cpx_req_cq      = cpx_req;
   assign 			    iob_cpx_data_ca     = cpx_data;
   assign 			    iob_jbi_pio_vld     = pio_vld;
   assign 			    iob_jbi_pio_data    = pio_data;
   assign 			    iob_jbi_dbg_hi_vld  = 0;
   assign 			    iob_jbi_dbg_lo_vld  = 0;
   assign 			    iob_jbi_mondo_ack   = 0;
   assign 			    iob_jbi_mondo_nack  = 0;
   assign 			    iob_clk_stall       = 0;
   assign 			    iob_clk_vld         = 0;
   assign 			    iob_clspine_stall   = 0;
   assign 			    iob_clspine_vld     = 0;
   assign 			    iob_dram02_stall    = 0;
   assign 			    iob_dram02_vld      = dram02_vld;
   assign 			    iob_dram02_data     = dram02_data;
   assign 			    iob_dram13_stall    = 0;
   assign 			    iob_dram13_vld      = dram13_vld;
   assign 			    iob_dram13_data     = dram13_data;
   assign 			    iob_jbi_spi_stall   = 0;
   assign 			    iob_jbi_spi_vld     = 0;
   assign 			    iob_tap_stall       = 0;
   assign 			    iob_tap_vld         = 0;

   //jbi ucb interface here
   assign 			    iob_jbi_spi_stall   = 0;
   assign 			    iob_jbi_spi_vld     = jspi_vld;
   assign 			    iob_jbi_spi_data    = jspi_data;
   
 
   //Start here
   reg 	 ok_iob;
   initial
     begin
   	ok_iob    = 0;
	cpx_req   = 0;
	cpx_data  = 0;
	pio_vld   = 0;
	
	//iob and dram interface
	dram02_data = 0;
   	dram02_vld  = 0;

  	dram13_data = 0;
 	dram13_vld  = 0;
	//jbi
	jspi_vld    = 0;
	jspi_data   = 0;
	
	$init_iob_model();
   	//repeat(1)@(posedge jbus_grst_l);//wait for the push butten reset.
	repeat(1)@(posedge ctu_iob_wake_thr);
   	//repeat(4)@(posedge jbus_gclk);//Delay issuing wakeup interrupt to let ccx come out of reset.
   	ok_iob      = 1;
     end
   //cmp clock domain
   always @(negedge cmp_gclk)
     begin
	if(ok_iob)begin
	   $iob_cdriver(//input to pli
		      //pcx packet from core
		      pcx_iob_data,
		      //cpx request from iob
		      cpx_req,
		      cpx_data,
		      //grand and request
		      cpx_iob_grant,
		      //pc event
		      spc0_inst_done_buf,
		      pc_w0_buf,
		      spc1_inst_done_buf,
		      pc_w1_buf,
		      spc2_inst_done_buf,
		      pc_w2_buf,
		      spc3_inst_done_buf,
		      pc_w3_buf,
		      spc4_inst_done_buf,
		      pc_w4_buf,
		      spc5_inst_done_buf,
		      pc_w5_buf,
		      spc6_inst_done_buf,
		      pc_w6_buf,
		      spc7_inst_done_buf,
		      pc_w7_buf
		      );
	end // if (ok_iob)
      end // always @ (posedge cmp_gclk)
   //jbus clock domain
  always @(posedge jbus_gclk)begin
     if(ok_iob)begin
	$iob_jdriver(
		     pio_vld, pio_data,
		     //dram and iob interface
		     //output from pli
		     dram02_iob_stall, dram02_vld, dram02_data,
		     dram13_iob_stall, dram13_vld, dram13_data,
		     //input to pli.
		     dram02_iob_vld,  dram02_iob_data,
		     dram13_iob_vld,  dram13_iob_data,
		     //pio input 13-14
		     jbi_iob_pio_vld, jbi_iob_pio_data,
		     //jbi interface
		     //out from pli 13-15
		     jbi_iob_spi_stall, jspi_vld, jspi_data,
		     //in to pli 16-17
		     jbi_iob_spi_vld, jbi_iob_spi_data
		     );
     end
    end
endmodule
