// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_padx12.v
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
module bw_io_dtl_padx12(ps_select_buf ,bypass_en_buf ,serial_out ,
     serial_in ,bso ,to_core ,so ,pad ,por_l_buf ,oe_buf ,reset_l_buf ,
     update_dr_buf ,cbu1 ,cbd1 ,up_open_buf ,bsr_si ,mode_ctl_buf ,
     se_buf ,shift_dr_buf ,hiz_l_buf ,si ,rst_val_dn_buf ,down_25_buf ,
     clk ,data ,clock_dr_buf ,rst_val_up_buf ,sel_bypass_buf ,vddo ,cbu0
      ,cbd0 ,ref ,rst_io_l_buf );
output [11:0]	serial_out ;
output [11:0]	to_core ;
input [1:0]	ps_select_buf ;
input [1:0]	bypass_en_buf ;
input [11:0]	serial_in ;
input [1:0]	por_l_buf ;
input [1:0]	oe_buf ;
input [1:0]	reset_l_buf ;
input [1:0]	update_dr_buf ;
input [8:1]	cbu1 ;
input [8:1]	cbd1 ;
input [1:0]	up_open_buf ;
input [1:0]	mode_ctl_buf ;
input [1:0]	se_buf ;
input [1:0]	shift_dr_buf ;
input [1:0]	hiz_l_buf ;
input [1:0]	rst_val_dn_buf ;
input [1:0]	down_25_buf ;
input [11:0]	data ;
input [1:0]	clock_dr_buf ;
input [1:0]	rst_val_up_buf ;
input [1:0]	sel_bypass_buf ;
input [8:1]	cbu0 ;
input [8:1]	cbd0 ;
input [1:0]	rst_io_l_buf ;
inout [11:0]	pad ;
output		bso ;
output		so ;
input		bsr_si ;
input		si ;
input		clk ;
input		vddo ;
input		ref ;
supply1		vdd ;
supply0		vss ;
 
wire [11:1]	bscan ;
wire [11:1]	scan ;
wire		ck0 ;
wire		ck1 ;
wire		ck2 ;
wire		ck3 ;
 
 
bw_io_dtl_pad DTL_0_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (scan[1] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (serial_out[1] ),
     .serial_in       (serial_in[0] ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck3 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (ps_select_buf[1] ),
     .out_type        (vdd ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[1] ),
     .serial_out      (serial_out[0] ),
     .bsr_si          (bscan[5] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[5] ),
     .oe              (oe_buf[1] ),
     .data            (data[0] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (to_core[0] ),
     .ref             (ref ),
     .pad             (pad[0] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad DTL_8_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (scan[8] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (serial_out[9] ),
     .serial_in       (serial_in[8] ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck2 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (ps_select_buf[1] ),
     .out_type        (vdd ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[8] ),
     .serial_out      (serial_out[8] ),
     .bsr_si          (bscan[3] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[3] ),
     .oe              (oe_buf[1] ),
     .data            (data[8] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (to_core[8] ),
     .ref             (ref ),
     .pad             (pad[8] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad DTL_1_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (so ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[1] ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck3 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (ps_select_buf[1] ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bso ),
     .serial_out      (serial_out[1] ),
     .bsr_si          (bscan[1] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[1] ),
     .oe              (oe_buf[1] ),
     .data            (data[1] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (to_core[1] ),
     .ref             (ref ),
     .pad             (pad[1] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad DTL_9_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (scan[9] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[9] ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck2 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (ps_select_buf[1] ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[9] ),
     .serial_out      (serial_out[9] ),
     .bsr_si          (bscan[8] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[8] ),
     .oe              (oe_buf[1] ),
     .data            (data[9] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (to_core[9] ),
     .ref             (ref ),
     .pad             (pad[9] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad DTL_2_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (scan[2] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (serial_out[3] ),
     .serial_in       (serial_in[2] ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (ps_select_buf[0] ),
     .out_type        (vdd ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[2] ),
     .serial_out      (serial_out[2] ),
     .bsr_si          (bscan[7] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[7] ),
     .oe              (oe_buf[0] ),
     .data            (data[2] ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (to_core[2] ),
     .ref             (ref ),
     .pad             (pad[2] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad DTL_3_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (scan[3] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[3] ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (ps_select_buf[0] ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[3] ),
     .serial_out      (serial_out[3] ),
     .bsr_si          (bscan[2] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[2] ),
     .oe              (oe_buf[0] ),
     .data            (data[3] ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (to_core[3] ),
     .ref             (ref ),
     .pad             (pad[3] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad DTL_11_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (scan[11] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[11] ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck0 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (ps_select_buf[0] ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[11] ),
     .serial_out      (serial_out[11] ),
     .bsr_si          (bscan[10] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[10] ),
     .oe              (oe_buf[0] ),
     .data            (data[11] ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (to_core[11] ),
     .ref             (ref ),
     .pad             (pad[11] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad DTL_4_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (scan[4] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (serial_out[5] ),
     .serial_in       (serial_in[4] ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck3 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (ps_select_buf[1] ),
     .out_type        (vdd ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[4] ),
     .serial_out      (serial_out[4] ),
     .bsr_si          (bscan[9] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[9] ),
     .oe              (oe_buf[1] ),
     .data            (data[4] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (to_core[4] ),
     .ref             (ref ),
     .pad             (pad[4] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad DTL_10_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (scan[10] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (serial_out[11] ),
     .serial_in       (serial_in[10] ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck0 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (ps_select_buf[0] ),
     .out_type        (vdd ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[10] ),
     .serial_out      (serial_out[10] ),
     .bsr_si          (bsr_si ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (si ),
     .oe              (oe_buf[0] ),
     .data            (data[10] ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (to_core[10] ),
     .ref             (ref ),
     .pad             (pad[10] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad DTL_5_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (scan[5] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[5] ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck2 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (ps_select_buf[1] ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[5] ),
     .serial_out      (serial_out[5] ),
     .bsr_si          (bscan[4] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[4] ),
     .oe              (oe_buf[1] ),
     .data            (data[5] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (to_core[5] ),
     .ref             (ref ),
     .pad             (pad[5] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad DTL_6_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (scan[6] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (serial_out[7] ),
     .serial_in       (serial_in[6] ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (ps_select_buf[0] ),
     .out_type        (vdd ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[6] ),
     .serial_out      (serial_out[6] ),
     .bsr_si          (bscan[11] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[11] ),
     .oe              (oe_buf[0] ),
     .data            (data[6] ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (to_core[6] ),
     .ref             (ref ),
     .pad             (pad[6] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_u1_ckbuf_30x I46 (
     .clk             (ck0 ),
     .rclk            (clk ) );
bw_u1_ckbuf_30x I47 (
     .clk             (ck2 ),
     .rclk            (clk ) );
bw_u1_ckbuf_30x I48 (
     .clk             (ck3 ),
     .rclk            (clk ) );
bw_u1_ckbuf_30x I49 (
     .clk             (ck1 ),
     .rclk            (clk ) );
bw_io_dtl_pad DTL_7_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (scan[7] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[7] ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck0 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (ps_select_buf[0] ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[7] ),
     .serial_out      (serial_out[7] ),
     .bsr_si          (bscan[6] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[6] ),
     .oe              (oe_buf[0] ),
     .data            (data[7] ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (to_core[7] ),
     .ref             (ref ),
     .pad             (pad[7] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
endmodule
