// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_misc_chunk1.v
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
module bw_io_misc_chunk1(io_ext_int_l ,spare_misc_pinoe ,sel_bypass ,
     vss_sense ,vdd_sense ,test_mode ,ext_int_l ,temp_trig ,
     spare_misc_pindata ,ckd ,vref ,vddo ,clk_stretch ,hiz_l ,rst_val_dn
      ,rst_val_up ,reset_l ,mode_ctl ,update_dr ,io_test_mode ,shift_dr
      ,clock_dr ,io_clk_stretch ,por_l ,rst_io_l ,bsi ,se ,si ,so ,bso ,
     clk ,io_pgrm_en ,io_burnin ,burnin ,obsel ,pgrm_en ,io_temp_trig ,
     pwron_rst_l ,io_pwron_rst_l ,spare_misc_pin ,spare_misc_pin_to_core
      );
input [5:4]	obsel ;
output		io_ext_int_l ;
output		io_test_mode ;
output		io_clk_stretch ;
output		so ;
output		bso ;
output		io_pgrm_en ;
output		io_burnin ;
output		io_temp_trig ;
output		io_pwron_rst_l ;
output		spare_misc_pin_to_core ;
input		spare_misc_pinoe ;
input		sel_bypass ;
input		spare_misc_pindata ;
input		ckd ;
input		vref ;
input		vddo ;
input		hiz_l ;
input		rst_val_dn ;
input		rst_val_up ;
input		reset_l ;
input		mode_ctl ;
input		update_dr ;
input		shift_dr ;
input		clock_dr ;
input		por_l ;
input		rst_io_l ;
input		bsi ;
input		se ;
input		si ;
input		clk ;
inout		vss_sense ;
inout		vdd_sense ;
inout		test_mode ;
inout		ext_int_l ;
inout		temp_trig ;
inout		clk_stretch ;
inout		burnin ;
inout		pgrm_en ;
inout		pwron_rst_l ;
inout		spare_misc_pin ;
supply1		vdd ;
supply0		vss ;
 
wire		net107 ;
wire		scan_clk_stretch_spare0 ;
wire		bscan_temp_trig_ext_int_l ;
wire		bscan_test_mode_por ;
wire		bscan_ext_int_l_spare0 ;
wire		bscan_spare0_clk_stretch ;
wire		bscan_por_temp_trig ;
wire		scan_ext_int_l_temp_trig ;
wire		scan_spare0_ext_int_l ;
 
 
bw_u1_ckbuf_40x Iclkbuf_1 (
     .clk             (net107 ),
     .rclk            (clk ) );
bw_io_cmos2_pad burnin_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_burnin ),
     .pad             (burnin ),
     .por_l           (por_l ) );
bw_io_cmos_pad test_mode_pad (
     .oe              (vss ),
     .bsr_si          (bsi ),
     .rst_io_l        (reset_l ),
     .vddo            (vddo ),
     .se              (vdd ),
     .rst_val_up      (rst_val_up ),
     .data            (vss ),
     .mode_ctl        (mode_ctl ),
     .clock_dr        (clock_dr ),
     .update_dr       (update_dr ),
     .rst_val_dn      (rst_val_dn ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .bso             (bscan_test_mode_por ),
     .to_core         (io_test_mode ),
     .pad             (test_mode ),
     .por_l           (vss ) );
bw_io_hstl_pad temp_trig_pad (
     .obsel           ({obsel } ),
     .so              (so ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net107 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bscan_temp_trig_ext_int_l ),
     .bsr_si          (bscan_por_temp_trig ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (scan_ext_int_l_temp_trig ),
     .oe              (vss ),
     .data            (vss ),
     .se              (se ),
     .to_core         (io_temp_trig ),
     .por_l           (por_l ),
     .pad             (temp_trig ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
bw_io_hstl_pad ext_int_l_pad (
     .obsel           ({obsel } ),
     .so              (scan_ext_int_l_temp_trig ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net107 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bscan_ext_int_l_spare0 ),
     .bsr_si          (bscan_temp_trig_ext_int_l ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (scan_spare0_ext_int_l ),
     .oe              (vss ),
     .data            (vss ),
     .se              (se ),
     .to_core         (io_ext_int_l ),
     .por_l           (por_l ),
     .pad             (ext_int_l ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
bw_io_cmos_pad pwron_rst_l_pad (
     .oe              (vss ),
     .bsr_si          (bscan_test_mode_por ),
     .rst_io_l        (reset_l ),
     .vddo            (vddo ),
     .se              (vdd ),
     .rst_val_up      (rst_val_up ),
     .data            (vss ),
     .mode_ctl        (mode_ctl ),
     .clock_dr        (clock_dr ),
     .update_dr       (update_dr ),
     .rst_val_dn      (rst_val_dn ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .bso             (bscan_por_temp_trig ),
     .to_core         (io_pwron_rst_l ),
     .pad             (pwron_rst_l ),
     .por_l           (vss ) );
bw_io_cmos2_pad pgrm_en_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_pgrm_en ),
     .pad             (pgrm_en ),
     .por_l           (por_l ) );
bw_io_hstl_pad spare_misc_pin_0_pad (
     .obsel           ({obsel } ),
     .so              (scan_spare0_ext_int_l ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net107 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bscan_spare0_clk_stretch ),
     .bsr_si          (bscan_ext_int_l_spare0 ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (scan_clk_stretch_spare0 ),
     .oe              (spare_misc_pinoe ),
     .data            (spare_misc_pindata ),
     .se              (se ),
     .to_core         (spare_misc_pin_to_core ),
     .por_l           (por_l ),
     .pad             (spare_misc_pin ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
bw_io_hstl_pad clk_stretch_pad (
     .obsel           ({obsel } ),
     .so              (scan_clk_stretch_spare0 ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net107 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bso ),
     .bsr_si          (bscan_spare0_clk_stretch ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (si ),
     .oe              (vss ),
     .data            (vss ),
     .se              (se ),
     .to_core         (io_clk_stretch ),
     .por_l           (por_l ),
     .pad             (clk_stretch ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
endmodule

