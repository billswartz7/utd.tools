// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_gl_rstce_rtl.v
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
// ------------------------------------------------------------------
module bw_clk_gl_rstce_rtl(sd ,cmp_agdbginit_l ,jbus_rx_sync_c0 ,
     grst_l_c0 ,grst_l_c1 ,grst_l_c2 ,grst_l_c3 ,grst_l_c4 ,grst_l_c5 ,
     grst_l_c6 ,grst_l_c7 ,so ,gclk_ccx_cken ,gclk_scdata0_cken ,
     gclk_scbuf3_cken ,gclk_scbuf2_cken ,gclk_scbuf1_cken ,
     gclk_scbuf0_cken ,gclk_jbi_cken ,gclk_spc7_cken ,gclk_spc6_cken ,
     gclk_spc5_cken ,gclk_spc4_cken ,gclk_spc3_cken ,gclk_spc2_cken ,
     gclk_spc1_cken ,gclk_spc0_cken ,gclk_sctag3_cken ,gclk_sctag2_cken
      ,gclk_sctag1_cken ,gclk_sctag0_cken ,gclk_scdata3_cken ,
     gclk_scdata2_cken ,gclk_scdata1_cken ,gclk_iob_cken ,gclk_fpu_cken
      ,gclk_dram13_cken ,gclk_dram02_cken ,gclk_a0 ,gclk_a1 ,gclk_b0 ,
     gclk_b1 ,gclk_b2 ,gclk_b3 ,gclk_c0 ,gclk_c1 ,gclk_c2 ,gclk_c3 ,
     gclk_c4 ,gclk_c5 ,gclk_c6 ,gclk_c7 ,jbus_rx_sync_c7 ,
     dram_rx_sync_c7 ,jbus_tx_sync_c7 ,dram_tx_sync_c6 ,jbus_tx_sync_c5
      ,jbus_rx_sync_c6 ,gdbginit_l_c6 ,gdbginit_l_c7 ,dram_rx_sync_c6 ,
     dram_tx_sync_c5 ,jbus_tx_sync_c6 ,jbus_rx_sync_c5 ,gdbginit_l_c5 ,
     dram_tx_sync_c7 ,dram_rx_sync_c5 ,jbus_rx_sync_c4 ,dram_rx_sync_c4
      ,dram_tx_sync_c4 ,gdbginit_l_c4 ,gdbginit_l_c3 ,dram_tx_sync_c2 ,
     jbus_tx_sync_c2 ,dram_rx_sync_c2 ,jbus_tx_sync_c4 ,dram_tx_sync_c3
      ,dram_rx_sync_c3 ,jbus_tx_sync_c3 ,jbus_rx_sync_c3 ,gdbginit_l_c2
      ,gdbginit_l_c1 ,dram_rx_sync_c1 ,jbus_rx_sync_c2 ,jbus_rx_sync_c1
      ,jbus_tx_sync_c1 ,jbus_tx_sync_c0 ,dram_tx_sync_c1 ,
     dram_rx_sync_c0 ,gdbginit_l_c0 ,dram_tx_sync_c0 ,ctu_jbi_cken ,
     ctu_scbuf3_cken ,ctu_scbuf2_cken ,ctu_scbuf1_cken ,ctu_scbuf0_cken
      ,ctu_scdata0_cken ,ctu_spc7_cken ,ctu_spc6_cken ,ctu_spc5_cken ,
     ctu_spc4_cken ,ctu_spc3_cken ,ctu_spc2_cken ,ctu_spc1_cken ,
     ctu_spc0_cken ,ctu_sctag3_cken ,ctu_sctag2_cken ,ctu_sctag1_cken ,
     ctu_sctag0_cken ,ctu_scdata3_cken ,ctu_scdata2_cken ,
     ctu_scdata1_cken ,ctu_iob_cken ,ctu_fpu_cken ,ctu_dram13_cken ,
     ctu_dram02_cken ,cmp_agrst_l ,cmp_grst_l ,ctu_dram_rx_sync ,se ,
     ctu_ccx_cken ,ctu_jbus_tx_sync ,cmp_gdbginit_l ,ctu_jbus_rx_sync ,
     ctu_dram_tx_sync );

input		      se ;
input  [13:0]	sd ;
output [13:0]	so ;

input		gclk_a0 ;
input		gclk_a1 ;
input		gclk_b0 ;
input		gclk_b1 ;
input		gclk_b2 ;
input		gclk_b3 ;
input		gclk_c0 ;
input		gclk_c1 ;
input		gclk_c2 ;
input		gclk_c3 ;
input		gclk_c4 ;
input		gclk_c5 ;
input		gclk_c6 ;
input		gclk_c7 ;
 
input		cmp_agrst_l ;
input		cmp_agdbginit_l ;

input		cmp_grst_l ;
input		cmp_gdbginit_l ;
input		ctu_dram_rx_sync ;
input		ctu_dram_tx_sync ;
input		ctu_jbus_rx_sync ;
input		ctu_jbus_tx_sync ;
input		ctu_spc0_cken ;
input		ctu_spc1_cken ;
input		ctu_spc2_cken ;
input		ctu_spc3_cken ;
input		ctu_spc4_cken ;
input		ctu_spc5_cken ;
input		ctu_spc6_cken ;
input		ctu_spc7_cken ;
input		ctu_scbuf0_cken ;
input		ctu_scbuf1_cken ;
input		ctu_scbuf2_cken ;
input		ctu_scbuf3_cken ;
input		ctu_scdata0_cken ;
input		ctu_scdata1_cken ;
input		ctu_scdata2_cken ;
input		ctu_scdata3_cken ;
input		ctu_sctag0_cken ;
input		ctu_sctag3_cken ;
input		ctu_sctag2_cken ;
input		ctu_sctag1_cken ;
input		ctu_dram02_cken ;
input		ctu_dram13_cken ;
input		ctu_ccx_cken ;
input		ctu_fpu_cken ;
input		ctu_iob_cken ;
input		ctu_jbi_cken ;

output	grst_l_c0 ;
output	grst_l_c1 ;
output	grst_l_c2 ;
output	grst_l_c3 ;
output	grst_l_c4 ;
output	grst_l_c5 ;
output	grst_l_c6 ;
output	grst_l_c7 ;

output	gdbginit_l_c0 ;
output	gdbginit_l_c1 ;
output	gdbginit_l_c2 ;
output	gdbginit_l_c3 ;
output	gdbginit_l_c4 ;
output	gdbginit_l_c5 ;
output	gdbginit_l_c6 ;
output	gdbginit_l_c7 ;

output	dram_rx_sync_c0 ;
output	dram_rx_sync_c1 ;
output	dram_rx_sync_c2 ;
output	dram_rx_sync_c3 ;
output	dram_rx_sync_c4 ;
output	dram_rx_sync_c5 ;
output	dram_rx_sync_c6 ;
output	dram_rx_sync_c7 ;

output	dram_tx_sync_c0 ;
output	dram_tx_sync_c1 ;
output	dram_tx_sync_c2 ;
output	dram_tx_sync_c3 ;
output	dram_tx_sync_c4 ;
output	dram_tx_sync_c5 ;
output	dram_tx_sync_c6 ;
output	dram_tx_sync_c7 ;

output	jbus_rx_sync_c0 ;
output	jbus_rx_sync_c1 ;
output	jbus_rx_sync_c2 ;
output	jbus_rx_sync_c3 ;
output	jbus_rx_sync_c4 ;
output	jbus_rx_sync_c5 ;
output	jbus_rx_sync_c6 ;
output	jbus_rx_sync_c7 ;

output	jbus_tx_sync_c0 ;
output	jbus_tx_sync_c1 ;
output	jbus_tx_sync_c2 ;
output	jbus_tx_sync_c3 ;
output	jbus_tx_sync_c4 ;
output	jbus_tx_sync_c5 ;
output	jbus_tx_sync_c6 ;
output	jbus_tx_sync_c7 ;

output	gclk_spc0_cken ;
output	gclk_spc1_cken ;
output	gclk_spc2_cken ;
output	gclk_spc3_cken ;
output	gclk_spc4_cken ;
output	gclk_spc5_cken ;
output	gclk_spc6_cken ;
output	gclk_spc7_cken ;
output	gclk_scbuf0_cken ;
output	gclk_scbuf1_cken ;
output	gclk_scbuf2_cken ;
output	gclk_scbuf3_cken ;
output	gclk_scdata0_cken ;
output	gclk_scdata1_cken ;
output	gclk_scdata2_cken ;
output	gclk_scdata3_cken ;
output	gclk_sctag0_cken ;
output	gclk_sctag1_cken ;
output	gclk_sctag2_cken ;
output	gclk_sctag3_cken ;
output	gclk_dram02_cken ;
output	gclk_dram13_cken ;
output	gclk_ccx_cken ;
output	gclk_fpu_cken ;
output	gclk_iob_cken ;
output	gclk_jbi_cken ;

wire [25:0]	ce ;
wire [25:0]	ce_a ;
wire [25:0]	ce_b ;
wire [25:0]	ce_c ;
wire [5:0]	spare_a0 ;
wire [5:0]	spare_a1 ;
wire [5:0]	spare_b0 ;
wire [5:0]	spare_b1 ;
wire [5:0]	spare_b2 ;
wire [5:0]	spare_b3 ;
wire [5:0]	spare_c0 ;
wire [5:0]	spare_c1 ;
wire [5:0]	spare_c2 ;
wire [5:0]	spare_c3 ;
wire [5:0]	spare_c4 ;
wire [5:0]	spare_c5 ;
wire [5:0]	spare_c6 ;
wire [5:0]	spare_c7 ;
wire [25:0]	unused_a0 ;
wire [25:0]	unused_a1 ;
wire [25:0]	unused_b0 ;
wire [25:0]	unused_b1 ;
wire [25:0]	unused_b2 ;
wire [25:0]	unused_b3 ;
wire [25:0]	unused_c0 ;
wire [25:0]	unused_c1 ;
wire [25:0]	unused_c2 ;
wire [25:0]	unused_c3 ;
wire [25:0]	unused_c4 ;
wire [25:0]	unused_c5 ;
wire [25:0]	unused_c6 ;
wire [25:0]	unused_c7 ;

wire	dram_rx_sync_a0 ;
wire	dram_rx_sync_a1 ;
wire	dram_rx_sync_b0 ;
wire	dram_rx_sync_b1 ;
wire	dram_rx_sync_b2 ;
wire	dram_rx_sync_b3 ;
wire	dram_tx_sync_a0 ;
wire	dram_tx_sync_a1 ;
wire	dram_tx_sync_b0 ;
wire	dram_tx_sync_b1 ;
wire	dram_tx_sync_b2 ;
wire	dram_tx_sync_b3 ;
wire	gdbginit_l_a0 ;
wire	gdbginit_l_a1 ;
wire	gdbginit_l_b0 ;
wire	gdbginit_l_b1 ;
wire	gdbginit_l_b2 ;
wire	gdbginit_l_b3 ;
wire	grst_l_a0 ;
wire	grst_l_a1 ;
wire	grst_l_b0 ;
wire	grst_l_b1 ;
wire	grst_l_b2 ;
wire	grst_l_b3 ;
wire	jbus_rx_sync_a0 ;
wire	jbus_rx_sync_a1 ;
wire	jbus_rx_sync_b0 ;
wire	jbus_rx_sync_b1 ;
wire	jbus_rx_sync_b2 ;
wire	jbus_rx_sync_b3 ;
wire	jbus_tx_sync_a0 ;
wire	jbus_tx_sync_a1 ;
wire	jbus_tx_sync_b0 ;
wire	jbus_tx_sync_b1 ;
wire	jbus_tx_sync_b2 ;
wire	jbus_tx_sync_b3 ;
 

assign	gclk_ccx_cken = ce_c[10] ;
assign	gclk_dram02_cken = ce_c[2] ;
assign	gclk_dram13_cken = ce_c[18] ;
assign	gclk_fpu_cken = ce_c[19] ;
assign	gclk_iob_cken = ce_c[5] ;
assign	gclk_jbi_cken = ce_c[13] ;
assign	gclk_scbuf0_cken = ce_c[11] ;
assign	gclk_scbuf2_cken = ce_c[20] ;
assign	gclk_scbuf1_cken = ce_c[12] ;
assign	gclk_scbuf3_cken = ce_c[21] ;
assign	gclk_scdata0_cken = ce_c[3] ;
assign	gclk_scdata2_cken = ce_c[6] ;
assign	gclk_scdata1_cken = ce_c[14] ;
assign	gclk_scdata3_cken = ce_c[23] ;
assign	gclk_sctag0_cken = ce_c[4] ;
assign	gclk_sctag2_cken = ce_c[7] ;
assign	gclk_sctag1_cken = ce_c[15] ;
assign	gclk_sctag3_cken = ce_c[22] ;
assign	gclk_spc0_cken = ce_c[0] ;
assign	gclk_spc2_cken = ce_c[1] ;
assign	gclk_spc4_cken = ce_c[8] ;
assign	gclk_spc6_cken = ce_c[9] ;
assign	gclk_spc1_cken = ce_c[16] ;
assign	gclk_spc3_cken = ce_c[17] ;
assign	gclk_spc5_cken = ce_c[24] ;
assign	gclk_spc7_cken = ce_c[25] ;

assign	ce[0]  = ctu_spc0_cken ;
assign	ce[1]  = ctu_spc2_cken ;
assign	ce[2]  = ctu_dram02_cken ;
assign	ce[3]  = ctu_scdata0_cken ;
assign	ce[4]  = ctu_sctag0_cken ;
assign	ce[5]  = ctu_iob_cken ;
assign	ce[6]  = ctu_scdata2_cken ;
assign	ce[7]  = ctu_sctag2_cken ;
assign	ce[8]  = ctu_spc4_cken ;
assign	ce[9]  = ctu_spc6_cken ;
assign	ce[10] = ctu_ccx_cken ;
assign	ce[11] = ctu_scbuf0_cken ;
assign	ce[12] = ctu_scbuf1_cken ;
assign	ce[13] = ctu_jbi_cken ;
assign	ce[14] = ctu_scdata1_cken ;
assign	ce[15] = ctu_sctag1_cken ;
assign	ce[16] = ctu_spc1_cken ;
assign	ce[17] = ctu_spc3_cken ;
assign	ce[18] = ctu_dram13_cken ;
assign	ce[19] = ctu_fpu_cken ;
assign	ce[20] = ctu_scbuf2_cken ;
assign	ce[21] = ctu_scbuf3_cken ;
assign	ce[22] = ctu_sctag3_cken ;
assign	ce[23] = ctu_scdata3_cken ;
assign	ce[24] = ctu_spc5_cken ;
assign	ce[25] = ctu_spc7_cken ;
 
flop_rptrs_xa0 xa0 (
                     
     .grst_out        (grst_l_a0 ),
     .gdbginit_out    (gdbginit_l_a0 ),
     .ddrsync1_out    (dram_rx_sync_a0 ),
     .ddrsync2_out    (dram_tx_sync_a0 ),
     .jbussync1_out   (jbus_rx_sync_a0 ),
     .jbussync2_out   (jbus_tx_sync_a0 ),

     .grst_in         (cmp_grst_l ),
     .gdbginit_in     (cmp_gdbginit_l ),
     .ddrsync1_in     (ctu_dram_rx_sync ),
     .ddrsync2_in     (ctu_dram_tx_sync ),
     .jbussync1_in    (ctu_jbus_rx_sync ),
     .jbussync2_in    (ctu_jbus_tx_sync ),

     .cken_out        ({unused_a0[25:10] ,ce_a[9:0] } ),
     .cken_in         ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        ce[9:0] } ),

     .sparc_out       ({spare_a0 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[0] ),
     .so              (so[0] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_a0 ) );

flop_rptrs_xa1 xa1 (
                     
     .grst_out        (grst_l_a1 ),
     .gdbginit_out    (gdbginit_l_a1 ),
     .ddrsync1_out    (dram_rx_sync_a1 ),
     .ddrsync2_out    (dram_tx_sync_a1 ),
     .jbussync1_out   (jbus_rx_sync_a1 ),
     .jbussync2_out   (jbus_tx_sync_a1 ),

     .grst_in         (cmp_grst_l ),
     .gdbginit_in     (cmp_gdbginit_l ),
     .ddrsync1_in     (ctu_dram_rx_sync ),
     .ddrsync2_in     (ctu_dram_tx_sync ),
     .jbussync1_in    (ctu_jbus_rx_sync ),
     .jbussync2_in    (ctu_jbus_tx_sync ),

     .cken_out        ({ce_a[25:10] ,unused_a1[9:0] } ),
     .cken_in         ({ ce[25:10] ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_a1 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[1] ),
     .so              (so[1] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_a1 ) );

flop_rptrs_xb0 xb0 (
                     
     .grst_out        (grst_l_b0 ),
     .gdbginit_out    (gdbginit_l_b0 ),
     .ddrsync1_out    (dram_rx_sync_b0 ),
     .ddrsync2_out    (dram_tx_sync_b0 ),
     .jbussync1_out   (jbus_rx_sync_b0 ),
     .jbussync2_out   (jbus_tx_sync_b0 ),

     .grst_in         (grst_l_a0 ),
     .gdbginit_in     (gdbginit_l_a0 ),
     .ddrsync1_in     (dram_rx_sync_a0 ),
     .ddrsync2_in     (dram_tx_sync_a0 ),
     .jbussync1_in    (jbus_rx_sync_a0 ),
     .jbussync2_in    (jbus_tx_sync_a0 ),

     .cken_out        ({unused_b0[25:5] ,ce_b[4:0] } ),
     .cken_in         ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 , 1'b0 ,
                        ce_a[4:0] } ),

     .sparc_out       ({spare_b0 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[2] ),
     .so              (so[2] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_b0 ) );

flop_rptrs_xb1 xb1 (
                     
     .grst_out        (grst_l_b1 ),
     .gdbginit_out    (gdbginit_l_b1 ),
     .ddrsync1_out    (dram_rx_sync_b1 ),
     .ddrsync2_out    (dram_tx_sync_b1 ),
     .jbussync1_out   (jbus_rx_sync_b1 ),
     .jbussync2_out   (jbus_tx_sync_b1 ),

     .grst_in         (grst_l_a0 ),
     .gdbginit_in     (gdbginit_l_a0 ),
     .ddrsync1_in     (dram_rx_sync_a0 ),
     .ddrsync2_in     (dram_tx_sync_a0 ),
     .jbussync1_in    (jbus_rx_sync_a0 ),
     .jbussync2_in    (jbus_tx_sync_a0 ),

     .cken_out        ({unused_b1[25:10] ,ce_b[9:5] ,unused_b1[4:0] } ),
     .cken_in         ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        ce_a[9:5]  ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_b1 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[3] ),
     .so              (so[3] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_b1 ) );

flop_rptrs_xb2 xb2(
                     
     .grst_out        (grst_l_b2 ),
     .gdbginit_out    (gdbginit_l_b2 ),
     .ddrsync1_out    (dram_rx_sync_b2 ),
     .ddrsync2_out    (dram_tx_sync_b2 ),
     .jbussync1_out   (jbus_rx_sync_b2 ),
     .jbussync2_out   (jbus_tx_sync_b2 ),

     .grst_in         (grst_l_a1 ),
     .gdbginit_in     (gdbginit_l_a1 ),
     .ddrsync1_in     (dram_rx_sync_a1 ),
     .ddrsync2_in     (dram_tx_sync_a1 ),
     .jbussync1_in    (jbus_rx_sync_a1 ),
     .jbussync2_in    (jbus_tx_sync_a1 ),

     .cken_out        ({unused_b2[25:18] ,ce_b[17:10] ,unused_b2[9:0] } ),
     .cken_in         ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        ce_a[17:10],1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_b2 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[4] ),
     .so              (so[4] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_b2 ) );

flop_rptrs_xb3 xb3(
                     
     .grst_out        (grst_l_b3 ),
     .gdbginit_out    (gdbginit_l_b3 ),
     .ddrsync1_out    (dram_rx_sync_b3 ),
     .ddrsync2_out    (dram_tx_sync_b3 ),
     .jbussync1_out   (jbus_rx_sync_b3 ),
     .jbussync2_out   (jbus_tx_sync_b3 ),

     .grst_in         (grst_l_a1 ),
     .gdbginit_in     (gdbginit_l_a1 ),
     .ddrsync1_in     (dram_rx_sync_a1 ),
     .ddrsync2_in     (dram_tx_sync_a1 ),
     .jbussync1_in    (jbus_rx_sync_a1 ),
     .jbussync2_in    (jbus_tx_sync_a1 ),

     .cken_out        ({ce_b[25:18] ,unused_b3[17:0] } ),
     .cken_in         ({ce_a[25:18] ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_b3 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[5] ),
     .so              (so[5] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_b3 ) );

flop_rptrs_xc0 xc0(
                     
     .grst_out        (grst_l_c0 ),
     .gdbginit_out    (gdbginit_l_c0 ),
     .ddrsync1_out    (dram_rx_sync_c0 ),
     .ddrsync2_out    (dram_tx_sync_c0 ),
     .jbussync1_out   (jbus_rx_sync_c0 ),
     .jbussync2_out   (jbus_tx_sync_c0 ),

     .grst_in         (grst_l_b0 ),
     .gdbginit_in     (gdbginit_l_b0 ),
     .ddrsync1_in     (dram_rx_sync_b0 ),
     .ddrsync2_in     (dram_tx_sync_b0 ),
     .jbussync1_in    (jbus_rx_sync_b0 ),
     .jbussync2_in    (jbus_tx_sync_b0 ),

     .cken_out        ({unused_c0[25:2] ,ce_c[1:0] } ),
     .cken_in         ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        ce_b[1:0] } ),

     .sparc_out       ({spare_c0 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[6] ),
     .so              (so[6] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_c0 ) );

flop_rptrs_xc1 xc1(
                     
     .grst_out        (grst_l_c1 ),
     .gdbginit_out    (gdbginit_l_c1 ),
     .ddrsync1_out    (dram_rx_sync_c1 ),
     .ddrsync2_out    (dram_tx_sync_c1 ),
     .jbussync1_out   (jbus_rx_sync_c1 ),
     .jbussync2_out   (jbus_tx_sync_c1 ),

     .grst_in         (grst_l_b0 ),
     .gdbginit_in     (gdbginit_l_b0 ),
     .ddrsync1_in     (dram_rx_sync_b0 ),
     .ddrsync2_in     (dram_tx_sync_b0 ),
     .jbussync1_in    (jbus_rx_sync_b0 ),
     .jbussync2_in    (jbus_tx_sync_b0 ),

     .cken_out        ({unused_c1[25:5] ,ce_c[4:2] ,unused_c1[1:0] } ),
     .cken_in         ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 , 1'b0 ,
                        ce_b[4:2] ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_c1 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[7] ),
     .so              (so[7] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_c1 ) );

flop_rptrs_xc2 xc2(
                     
     .grst_out        (grst_l_c2 ),
     .gdbginit_out    (gdbginit_l_c2 ),
     .ddrsync1_out    (dram_rx_sync_c2 ),
     .ddrsync2_out    (dram_tx_sync_c2 ),
     .jbussync1_out   (jbus_rx_sync_c2 ),
     .jbussync2_out   (jbus_tx_sync_c2 ),

     .grst_in         (grst_l_b1 ),
     .gdbginit_in     (gdbginit_l_b1 ),
     .ddrsync1_in     (dram_rx_sync_b1 ),
     .ddrsync2_in     (dram_tx_sync_b1 ),
     .jbussync1_in    (jbus_rx_sync_b1 ),
     .jbussync2_in    (jbus_tx_sync_b1 ),

     .cken_out        ({unused_c2[25:10] ,ce_c[9:5] ,unused_c2[4:0] } ),
     .cken_in         ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                         ce_b[9:5] ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_c2 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[8] ),
     .so              (so[8] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_c2 ) );

flop_rptrs_xc3 xc3(

     .grst_out        (grst_l_c3 ),
     .gdbginit_out    (gdbginit_l_c3 ),
     .ddrsync1_out    (dram_rx_sync_c3 ),
     .ddrsync2_out    (dram_tx_sync_c3 ),
     .jbussync1_out   (jbus_rx_sync_c3 ),
     .jbussync2_out   (jbus_tx_sync_c3 ),

     .grst_in         (grst_l_b2 ),
     .gdbginit_in     (gdbginit_l_b2 ),
     .ddrsync1_in     (dram_rx_sync_b2 ),
     .ddrsync2_in     (dram_tx_sync_b2 ),
     .jbussync1_in    (jbus_rx_sync_b2 ),
     .jbussync2_in    (jbus_tx_sync_b2 ),

     .cken_out        ({unused_c3[25:13] ,ce_c[12:10] ,unused_c3[9:0] } ),
     .cken_in         ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,ce_b[12:10] ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_c3 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[9] ),
     .so              (so[9] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_c3 ) );

flop_rptrs_xc4 xc4(
                     
     .grst_out        (grst_l_c4 ),
     .gdbginit_out    (gdbginit_l_c4 ),
     .ddrsync1_out    (dram_rx_sync_c4 ),
     .ddrsync2_out    (dram_tx_sync_c4 ),
     .jbussync1_out   (jbus_rx_sync_c4 ),
     .jbussync2_out   (jbus_tx_sync_c4 ),

     .grst_in         (grst_l_b2 ),
     .gdbginit_in     (gdbginit_l_b2 ),
     .ddrsync1_in     (dram_rx_sync_b2 ),
     .ddrsync2_in     (dram_tx_sync_b2 ),
     .jbussync1_in    (jbus_rx_sync_b2 ),
     .jbussync2_in    (jbus_tx_sync_b2 ),

     .cken_out        ({unused_c4[25:18] ,ce_c[17:16] ,unused_c4[15:0] } ),
     .cken_in         ({1'b0 ,1'b0 , 1'b0 ,1'b0 ,
                        1'b0 ,1'b0 , 1'b0 ,1'b0 ,
                        ce_b[17:16] ,
                        1'b0 , 1'b0 ,1'b0 ,1'b0 ,
                        1'b0 , 1'b0 ,1'b0 ,1'b0 ,
                        1'b0 , 1'b0 ,1'b0 ,1'b0 ,
                        1'b0 , 1'b0 ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_c4 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[11] ),
     .so              (so[11] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_c4 ) );

flop_rptrs_xc5 xc5(
                     
     .grst_out        (grst_l_c5 ),
     .gdbginit_out    (gdbginit_l_c5 ),
     .ddrsync1_out    (dram_rx_sync_c5 ),
     .ddrsync2_out    (dram_tx_sync_c5 ),
     .jbussync1_out   (jbus_rx_sync_c5 ),
     .jbussync2_out   (jbus_tx_sync_c5 ),

     .grst_in         (grst_l_b2 ),
     .gdbginit_in     (gdbginit_l_b2 ),
     .ddrsync1_in     (dram_rx_sync_b2 ),
     .ddrsync2_in     (dram_tx_sync_b2 ),
     .jbussync1_in    (jbus_rx_sync_b2 ),
     .jbussync2_in    (jbus_tx_sync_b2 ),

     .cken_out        ({unused_c5[25:16] ,ce_c[15:13] ,unused_c5[12:0] } ),
     .cken_in         ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,ce_b[15:13] ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_c5 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[10] ),
     .so              (so[10] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_c5 ) );

flop_rptrs_xc6 xc6(

     .grst_out        (grst_l_c6 ),
     .gdbginit_out    (gdbginit_l_c6 ),
     .ddrsync1_out    (dram_rx_sync_c6 ),
     .ddrsync2_out    (dram_tx_sync_c6 ),
     .jbussync1_out   (jbus_rx_sync_c6 ),
     .jbussync2_out   (jbus_tx_sync_c6 ),

     .grst_in         (grst_l_b3 ),
     .gdbginit_in     (gdbginit_l_b3 ),
     .ddrsync1_in     (dram_rx_sync_b3 ),
     .ddrsync2_in     (dram_tx_sync_b3 ),
     .jbussync1_in    (jbus_rx_sync_b3 ),
     .jbussync2_in    (jbus_tx_sync_b3 ),

     .cken_out        ({unused_c6[25:22] ,ce_c[21:18] ,unused_c6[17:0] } ),
     .cken_in         ({1'b0 ,1'b0 , 1'b0 ,1'b0 ,ce_b[21:18] ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 , 1'b0 ,1'b0 ,
                        1'b0 ,1'b0 , 1'b0 ,1'b0 ,
                        1'b0 ,1'b0 , 1'b0 ,1'b0 ,
                        1'b0 ,1'b0 , 1'b0 ,1'b0 } ),

     .sparc_out       ({spare_c6 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[13] ),
     .so              (so[13] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_c6 ) );

flop_rptrs_xc7 xc7(
                     
     .grst_out        (grst_l_c7 ),
     .gdbginit_out    (gdbginit_l_c7 ),
     .ddrsync1_out    (dram_rx_sync_c7 ),
     .ddrsync2_out    (dram_tx_sync_c7 ),
     .jbussync1_out   (jbus_rx_sync_c7 ),
     .jbussync2_out   (jbus_tx_sync_c7 ),

     .grst_in         (grst_l_b3 ),
     .gdbginit_in     (gdbginit_l_b3 ),
     .ddrsync1_in     (dram_rx_sync_b3 ),
     .ddrsync2_in     (dram_tx_sync_b3 ),
     .jbussync1_in    (jbus_rx_sync_b3 ),
     .jbussync2_in    (jbus_tx_sync_b3 ),

     .cken_out        ({ce_c[25:22] ,unused_c7[21:0] } ),
     .cken_in         ({ce_b[25:22] ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 ,
                        1'b0 ,1'b0 ,1'b0 ,1'b0 } ),

     .sparc_out       ({spare_c7 } ),
     .spare_in        ({1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 ,1'b0 } ),
     .se              (se ),
     .sd              (sd[12] ),
     .so              (so[12] ),
     .agrst_l         (cmp_agrst_l ),
     .adbginit_l      (cmp_agdbginit_l ),
     .gclk            (gclk_c7 ) );

endmodule

