// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: pad_misc.v
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
module pad_misc(io_tdo_en ,bscan_hiz_l_in ,bscan_update_dr_in ,tdi ,
     spare_misc_pad ,spare_misc_pad_to_core ,spare_misc_pindata ,
     spare_misc_pin ,burnin ,io_burnin ,spare_misc_paddata ,
     spare_misc_padoe ,vreg_selbg_l ,io_pmi ,tck2 ,pad_misc_bsi ,
     pad_misc_se ,pad_misc_si ,pad_misc_so ,bscan_clock_dr_in ,ssi_miso
      ,ssi_mosi ,temp_trig ,jbus_arst_l ,jbus_adbginit_l ,ext_int_l ,
     vdd_sense ,jbus_gdbginit_l ,bscan_shift_dr_out ,bscan_update_dr_out
      ,bscan_clock_dr_out ,bscan_mode_ctl_out ,pmi ,io_ext_int_l ,
     pll_char_in ,jbus_grst_l ,jbus_gclk ,vss_sense ,clk_stretch ,
     pwron_rst_l ,test_mode ,vddo ,io_trigin ,pmo ,pgrm_en ,io_test_mode
      ,clk_misc_cken ,hstl_vref ,tms ,pcm_misc_oe ,io_pwron_rst_l ,
     io_tms ,io_pmo ,io_pgrm_en ,io_pll_char_in ,io_tdo ,jbi_io_ssi_sck
      ,jbi_io_ssi_mosi ,io_trst_l ,io_tck ,io_tdi ,io_temp_trig ,
     spare_misc_pin_to_core ,io_jbi_ssi_miso ,tck ,tdo ,trst_l ,ssi_sck
      ,bscan_mode_ctl_in ,bscan_shift_dr_in ,bscan_hiz_l_out ,
     pad_misc_bso ,io_tck2 ,spare_misc_pinoe ,io_vreg_selbg_l ,
     io_clk_stretch ,trigin );
output [2:0]	spare_misc_pad_to_core ;
input [2:0]	spare_misc_paddata ;
input [2:0]	spare_misc_padoe ;
inout [2:0]	spare_misc_pad ;
output		io_burnin ;
output		io_pmi ;
output		pad_misc_so ;
output		bscan_shift_dr_out ;
output		bscan_update_dr_out ;
output		bscan_clock_dr_out ;
output		bscan_mode_ctl_out ;
output		io_ext_int_l ;
output		io_trigin ;
output		io_test_mode ;
output		io_pwron_rst_l ;
output		io_tms ;
output		io_pgrm_en ;
output		io_pll_char_in ;
output		io_trst_l ;
output		io_tck ;
output		io_tdi ;
output		io_temp_trig ;
output		spare_misc_pin_to_core ;
output		io_jbi_ssi_miso ;
output		bscan_hiz_l_out ;
output		pad_misc_bso ;
output		io_tck2 ;
output		io_vreg_selbg_l ;
output		io_clk_stretch ;
input		io_tdo_en ;
input		bscan_hiz_l_in ;
input		bscan_update_dr_in ;
input		spare_misc_pindata ;
input		pad_misc_bsi ;
input		pad_misc_se ;
input		pad_misc_si ;
input		bscan_clock_dr_in ;
input		jbus_arst_l ;
input		jbus_adbginit_l ;
input		jbus_gdbginit_l ;
input		jbus_grst_l ;
input		jbus_gclk ;
input		vddo ;
input		clk_misc_cken ;
input		pcm_misc_oe ;
input		io_pmo ;
input		io_tdo ;
input		jbi_io_ssi_sck ;
input		jbi_io_ssi_mosi ;
input		bscan_mode_ctl_in ;
input		bscan_shift_dr_in ;
input		spare_misc_pinoe ;
inout		tdi ;
inout		spare_misc_pin ;
inout		burnin ;
inout		vreg_selbg_l ;
inout		tck2 ;
inout		ssi_miso ;
inout		ssi_mosi ;
inout		temp_trig ;
inout		ext_int_l ;
inout		vdd_sense ;
inout		pmi ;
inout		pll_char_in ;
inout		vss_sense ;
inout		clk_stretch ;
inout		pwron_rst_l ;
inout		test_mode ;
inout		pmo ;
inout		pgrm_en ;
inout		hstl_vref ;
inout		tms ;
inout		tck ;
inout		tdo ;
inout		trst_l ;
inout		ssi_sck ;
inout		trigin ;
supply1		vdd ;
supply0		vss ;
 
wire		net282 ;
wire		net300 ;
wire		net283 ;
wire		net301 ;
wire		net284 ;
wire		net302 ;
wire		net285 ;
wire		net286 ;
wire		net287 ;
wire		net288 ;
wire		net305 ;
wire		chunk1_so ;
wire		chunk5_so ;
wire		net296 ;
wire		net297 ;
wire		net412 ;
wire		net298 ;
wire		net413 ;
wire		net299 ;
wire		chunk2_bso ;
wire		net0251 ;
wire		chunk1_bso ;
wire		net0254 ;
wire		net324 ;
wire		net0257 ;
wire		net325 ;
wire		net326 ;
wire		net327 ;
wire		net328 ;
wire		net329 ;
wire		reset_l ;
wire		net330 ;
wire		net338 ;
wire		net339 ;
wire		net340 ;
wire		net341 ;
wire		net342 ;
wire		net343 ;
wire		net344 ;
wire		net346 ;
wire		chunk3_bso ;
wire		rclk ;
wire		misc_si_1 ;
wire		misc_si_2 ;
wire		header_si ;
wire		chunk2_so ;
wire		net273 ;
 
 
bw_u1_minbuf_4x I141 (
     .z               (header_si ),
     .a               (misc_si_2 ) );
bw_clk_cl_misc_jbus pad_misc_header (
     .arst_l          (jbus_arst_l ),
     .adbginit_l      (jbus_adbginit_l ),
     .se              (pad_misc_se ),
     .si              (pad_misc_si ),
     .cluster_grst_l  (reset_l ),
     .so              (misc_si_1 ),
     .dbginit_l       (net273 ),
     .rclk            (rclk ),
     .gclk            (jbus_gclk ),
     .cluster_cken    (clk_misc_cken ),
     .grst_l          (jbus_grst_l ),
     .gdbginit_l      (jbus_gdbginit_l ) );
bw_u1_ckbuf_1p5x so_ckbuf (
     .clk             (net0251 ),
     .rclk            (rclk ) );
bw_u1_scanl_2x lockup_bso (
     .so              (net0254 ),
     .sd              (chunk1_bso ),
     .ck              (net341 ) );
bw_u1_minbuf_1x si_minbuf1 (
     .z               (misc_si_2 ),
     .a               (misc_si_1 ) );
bw_io_misc_rpt rpt0 (
     .in2             (bscan_mode_ctl_in ),
     .out2            (net343 ),
     .out3            (net342 ),
     .out4            (net341 ),
     .out5            (net340 ),
     .out6            (net339 ),
     .out7            (net338 ),
     .in3             (bscan_shift_dr_in ),
     .in4             (bscan_clock_dr_in ),
     .in5             (bscan_update_dr_in ),
     .in6             (reset_l ),
     .in7             (pad_misc_se ),
     .in1             (bscan_hiz_l_in ),
     .out1            (net344 ) );
bw_io_misc_rpt rpt1 (
     .in2             (net343 ),
     .out2            (net329 ),
     .out3            (net328 ),
     .out4            (net327 ),
     .out5            (net326 ),
     .out6            (net325 ),
     .out7            (net324 ),
     .in3             (net342 ),
     .in4             (net341 ),
     .in5             (net340 ),
     .in6             (net339 ),
     .in7             (net338 ),
     .in1             (net344 ),
     .out1            (net330 ) );
bw_io_misc_rpt rpt2 (
     .in2             (net329 ),
     .out2            (net287 ),
     .out3            (net286 ),
     .out4            (net285 ),
     .out5            (net284 ),
     .out6            (net283 ),
     .out7            (net282 ),
     .in3             (net328 ),
     .in4             (net327 ),
     .in5             (net326 ),
     .in6             (net325 ),
     .in7             (net324 ),
     .in1             (net330 ),
     .out1            (net288 ) );
bw_io_misc_rpt rpt3 (
     .in2             (net287 ),
     .out2            (net301 ),
     .out3            (net300 ),
     .out4            (net299 ),
     .out5            (net298 ),
     .out6            (net297 ),
     .out7            (net296 ),
     .in3             (net286 ),
     .in4             (net285 ),
     .in5             (net284 ),
     .in6             (net283 ),
     .in7             (net282 ),
     .in1             (net288 ),
     .out1            (net302 ) );
bw_io_misc_rpt rpt4 (
     .in2             (net301 ),
     .out2            (bscan_mode_ctl_out ),
     .out3            (bscan_shift_dr_out ),
     .out4            (bscan_clock_dr_out ),
     .out5            (bscan_update_dr_out ),
     .out6            (net346 ),
     .out7            (net305 ),
     .in3             (net300 ),
     .in4             (net299 ),
     .in5             (net298 ),
     .in6             (vss ),
     .in7             (vss ),
     .in1             (net302 ),
     .out1            (bscan_hiz_l_out ) );
bw_u1_buf_20x so_buf (
     .z               (pad_misc_so ),
     .a               (net0257 ) );
bw_u1_scanl_2x lockup_so (
     .so              (net0257 ),
     .sd              (chunk5_so ),
     .ck              (net0251 ) );
bw_io_hstl_drv hstl_vref_dummy (
     .cbu             ({vss ,vss ,vss ,vss ,vdd ,vdd ,vdd ,vdd } ),
     .cbd             ({vss ,vss ,vss ,vss ,vdd ,vdd ,vdd ,vdd } ),
     .pad             (hstl_vref ),
     .sel_data_n      (vss ),
     .pad_up          (vss ),
     .pad_dn_l        (vdd ),
     .por             (vss ),
     .bsr_up          (vss ),
     .bsr_dn_l        (vdd ),
     .vddo            (vddo ) );
bw_io_misc_chunk1 chunk1 (
     .obsel           ({vss ,vss } ),
     .io_ext_int_l    (io_ext_int_l ),
     .spare_misc_pinoe (spare_misc_pinoe ),
     .sel_bypass      (vss ),
     .vss_sense       (vss_sense ),
     .vdd_sense       (vdd_sense ),
     .test_mode       (test_mode ),
     .ext_int_l       (ext_int_l ),
     .temp_trig       (temp_trig ),
     .spare_misc_pindata (spare_misc_pindata ),
     .ckd             (vss ),
     .vref            (hstl_vref ),
     .vddo            (vddo ),
     .clk_stretch     (clk_stretch ),
     .hiz_l           (net344 ),
     .rst_val_dn      (vdd ),
     .rst_val_up      (vdd ),
     .reset_l         (net339 ),
     .mode_ctl        (net343 ),
     .update_dr       (net340 ),
     .io_test_mode    (io_test_mode ),
     .shift_dr        (net342 ),
     .clock_dr        (net341 ),
     .io_clk_stretch  (io_clk_stretch ),
     .por_l           (vdd ),
     .rst_io_l        (vdd ),
     .bsi             (chunk2_bso ),
     .se              (net338 ),
     .si              (header_si ),
     .so              (chunk1_so ),
     .bso             (chunk1_bso ),
     .clk             (rclk ),
     .io_pgrm_en      (io_pgrm_en ),
     .io_burnin       (io_burnin ),
     .burnin          (burnin ),
     .pgrm_en         (pgrm_en ),
     .io_temp_trig    (io_temp_trig ),
     .pwron_rst_l     (pwron_rst_l ),
     .io_pwron_rst_l  (io_pwron_rst_l ),
     .spare_misc_pin  (spare_misc_pin ),
     .spare_misc_pin_to_core (spare_misc_pin_to_core ) );
bw_io_misc_chunk2 chunk2 (
     .obsel           ({vss ,vss } ),
     .io_pll_char_in  (io_pll_char_in ),
     .sel_bypass      (vss ),
     .tck2            (tck2 ),
     .io_tck2         (io_tck2 ),
     .pll_char_in     (pll_char_in ),
     .ssi_mosi        (ssi_mosi ),
     .jbi_io_ssi_mosi (jbi_io_ssi_mosi ),
     .ssi_miso        (ssi_miso ),
     .io_jbi_ssi_miso (io_jbi_ssi_miso ),
     .vddo            (vddo ),
     .vref            (hstl_vref ),
     .ckd             (vss ),
     .so              (chunk2_so ),
     .bso             (chunk2_bso ),
     .rst_val_up      (vdd ),
     .rst_val_dn      (vdd ),
     .reset_l         (net325 ),
     .si              (chunk1_so ),
     .se              (net324 ),
     .bsi             (chunk3_bso ),
     .rst_io_l        (vdd ),
     .hiz_l           (net330 ),
     .shift_dr        (net328 ),
     .update_dr       (net326 ),
     .clock_dr        (net327 ),
     .mode_ctl        (net329 ),
     .clk             (rclk ),
     .por_l           (vdd ) );
bw_io_misc_chunk3 chunk3 (
     .spare_misc_pad  ({spare_misc_pad[0] } ),
     .spare_misc_paddata ({spare_misc_paddata[0] } ),
     .spare_misc_pad_to_core ({spare_misc_pad_to_core[0] } ),
     .obsel           ({vss ,vss } ),
     .spare_misc_padoe ({spare_misc_padoe[0] } ),
     .ssi_sck         (ssi_sck ),
     .jbi_io_ssi_sck  (jbi_io_ssi_sck ),
     .trigin          (trigin ),
     .io_trigin       (io_trigin ),
     .io_tms          (io_tms ),
     .io_vreg_selbg_l (io_vreg_selbg_l ),
     .clk             (rclk ),
     .ckd             (vss ),
     .vref            (hstl_vref ),
     .vddo            (vddo ),
     .rst_val_up      (vdd ),
     .tms             (tms ),
     .sel_bypass      (vss ),
     .mode_ctl        (net287 ),
     .rst_val_dn      (vdd ),
     .bsi             (net412 ),
     .clock_dr        (net285 ),
     .shift_dr        (net286 ),
     .hiz_l           (net288 ),
     .update_dr       (net284 ),
     .rst_io_l        (vdd ),
     .por_l           (vdd ),
     .se              (net282 ),
     .si              (chunk2_so ),
     .reset_l         (net283 ),
     .so              (net413 ),
     .bso             (chunk3_bso ),
     .hstl_vref       (hstl_vref ),
     .vreg_selbg_l    (vreg_selbg_l ) );
bw_u1_buf_30x bso_buf (
     .z               (pad_misc_bso ),
     .a               (net0254 ) );
bw_io_misc_chunk5 chunk5 (
     .spare_misc_pad  ({spare_misc_pad[2:1] } ),
     .spare_misc_paddata ({spare_misc_paddata[2:1] } ),
     .obsel           ({vss ,vss } ),
     .spare_misc_padoe ({spare_misc_padoe[2:1] } ),
     .spare_misc_pad_to_core ({spare_misc_pad_to_core[2:1] } ),
     .clk             (rclk ),
     .sel_bypass      (vss ),
     .io_tdo_en       (io_tdo_en ),
     .ckd             (vss ),
     .vref            (hstl_vref ),
     .vddo            (vddo ),
     .io_tdo          (io_tdo ),
     .rst_val_up      (vdd ),
     .io_tdi          (io_tdi ),
     .mode_ctl        (net301 ),
     .rst_val_dn      (vdd ),
     .io_trst_l       (io_trst_l ),
     .bsi             (pad_misc_bsi ),
     .io_tck          (io_tck ),
     .clock_dr        (net299 ),
     .tck             (tck ),
     .shift_dr        (net300 ),
     .trst_l          (trst_l ),
     .hiz_l           (net302 ),
     .tdi             (tdi ),
     .update_dr       (net298 ),
     .rst_io_l        (vdd ),
     .por_l           (vdd ),
     .tdo             (tdo ),
     .se              (net296 ),
     .si              (net413 ),
     .reset_l         (net297 ),
     .so              (chunk5_so ),
     .bso             (net412 ) );
bw_io_misc_chunk6 chunk6 (
     .io_pmi          (io_pmi ),
     .pcm_misc_oe     (pcm_misc_oe ),
     .vddo            (vddo ),
     .pmo             (pmo ),
     .io_pmo          (io_pmo ),
     .por_l           (vdd ),
     .pmi             (pmi ) );
endmodule
