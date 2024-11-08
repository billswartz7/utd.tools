// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_pad_pack12.v
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
module bw_io_dtl_pad_pack12(se_buf ,up_open_buf ,down_25_buf ,cbu1 ,ref
      ,si ,clk ,vddo ,cbu0 ,cbd0 ,j_pack1 ,pack0_en ,rst_val_up_buf ,
     pack1_en ,bsr_si ,j_pack0 ,jpack5 ,rst_val_dn_buf ,pack5 ,so ,bso ,
     pack4 ,update_dr_buf ,por_l_buf ,rst_io_l_buf ,hiz_l_buf ,
     reset_l_buf ,sel_bypass_buf ,clock_dr_buf ,cbd1 ,mode_ctl_buf ,
     jpack4 ,jpack1 ,jpack0 ,shift_dr_buf );
output [2:0]	pack5 ;
output [2:0]	pack4 ;
input [1:0]	se_buf ;
input [1:0]	up_open_buf ;
input [1:0]	down_25_buf ;
input [8:1]	cbu1 ;
input [8:1]	cbu0 ;
input [8:1]	cbd0 ;
input [2:0]	j_pack1 ;
input [1:0]	rst_val_up_buf ;
input [2:0]	j_pack0 ;
input [1:0]	rst_val_dn_buf ;
input [1:0]	update_dr_buf ;
input [1:0]	por_l_buf ;
input [1:0]	rst_io_l_buf ;
input [1:0]	hiz_l_buf ;
input [1:0]	reset_l_buf ;
input [1:0]	sel_bypass_buf ;
input [1:0]	clock_dr_buf ;
input [8:1]	cbd1 ;
input [1:0]	mode_ctl_buf ;
input [1:0]	shift_dr_buf ;
inout [2:0]	jpack5 ;
inout [2:0]	jpack4 ;
inout [2:0]	jpack1 ;
inout [2:0]	jpack0 ;
output		so ;
output		bso ;
input		ref ;
input		si ;
input		clk ;
input		vddo ;
input		pack0_en ;
input		pack1_en ;
input		bsr_si ;
supply1		vdd ;
supply0		vss ;
 
wire [2:0]	pack0out ;
wire [11:1]	bscan ;
wire [2:0]	pack1out ;
wire [11:1]	scan ;
wire [5:0]	net64 ;
wire [2:0]	net98 ;
wire [2:0]	net132 ;
wire		ck0 ;
wire		ck1 ;
wire		ck2 ;
wire		ck3 ;
 
 
terminator I58_4_ (
     .TERM            (net64[1] ) );
terminator I61_2_ (
     .TERM            (net98[0] ) );
bw_io_dtl_pad I2_3_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[4] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck0 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[4] ),
     .serial_out      (net64[2] ),
     .bsr_si          (bscan[5] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[5] ),
     .oe              (vss ),
     .data            (vdd ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (pack4[1] ),
     .ref             (ref ),
     .pad             (jpack4[1] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad dtl0_2_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[11] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck2 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[11] ),
     .serial_out      (net132[0] ),
     .bsr_si          (bscan[1] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[1] ),
     .oe              (pack0_en ),
     .data            (j_pack0[0] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (pack0out[0] ),
     .ref             (ref ),
     .pad             (jpack0[0] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad dtl1_0_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (so ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck3 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bso ),
     .serial_out      (net98[2] ),
     .bsr_si          (bscan[7] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[7] ),
     .oe              (pack1_en ),
     .data            (j_pack1[2] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (pack1out[2] ),
     .ref             (ref ),
     .pad             (jpack1[2] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_u1_ckbuf_30x I62 (
     .clk             (ck2 ),
     .rclk            (clk ) );
bw_u1_ckbuf_30x I64 (
     .clk             (ck3 ),
     .rclk            (clk ) );
bw_u1_ckbuf_30x I65 (
     .clk             (ck0 ),
     .rclk            (clk ) );
terminator I58_5_ (
     .TERM            (net64[0] ) );
bw_io_dtl_pad I2_4_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[5] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck0 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[5] ),
     .serial_out      (net64[1] ),
     .bsr_si          (bscan[6] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[6] ),
     .oe              (vss ),
     .data            (vdd ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (pack5[0] ),
     .ref             (ref ),
     .pad             (jpack5[0] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad dtl0_1_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[9] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck2 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[9] ),
     .serial_out      (net132[1] ),
     .bsr_si          (bscan[10] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[10] ),
     .oe              (pack0_en ),
     .data            (j_pack0[1] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (pack0out[1] ),
     .ref             (ref ),
     .pad             (jpack0[1] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
terminator I57_0_ (
     .TERM            (net132[2] ) );
bw_io_dtl_pad I2_5_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[6] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck0 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[6] ),
     .serial_out      (net64[0] ),
     .bsr_si          (bsr_si ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (si ),
     .oe              (vss ),
     .data            (vdd ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (pack4[0] ),
     .ref             (ref ),
     .pad             (jpack4[0] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad dtl1_2_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[10] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck3 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[10] ),
     .serial_out      (net98[0] ),
     .bsr_si          (bscan[11] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[11] ),
     .oe              (pack1_en ),
     .data            (j_pack1[0] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (pack1out[0] ),
     .ref             (ref ),
     .pad             (jpack1[0] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_u1_ckbuf_30x I85 (
     .clk             (ck1 ),
     .rclk            (clk ) );
terminator I57_1_ (
     .TERM            (net132[1] ) );
bw_io_dtl_pad dtl1_1_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[8] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck3 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[8] ),
     .serial_out      (net98[1] ),
     .bsr_si          (bscan[9] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[9] ),
     .oe              (pack1_en ),
     .data            (j_pack1[1] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (pack1out[1] ),
     .ref             (ref ),
     .pad             (jpack1[1] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
terminator I58_0_ (
     .TERM            (net64[5] ) );
terminator I57_2_ (
     .TERM            (net132[0] ) );
terminator I58_1_ (
     .TERM            (net64[4] ) );
bw_io_dtl_pad I2_0_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[1] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[1] ),
     .serial_out      (net64[5] ),
     .bsr_si          (bscan[2] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[2] ),
     .oe              (vss ),
     .data            (vdd ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (pack5[2] ),
     .ref             (ref ),
     .pad             (jpack5[2] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
terminator I58_2_ (
     .TERM            (net64[3] ) );
terminator I61_0_ (
     .TERM            (net98[2] ) );
bw_io_dtl_pad I2_1_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[2] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[2] ),
     .serial_out      (net64[4] ),
     .bsr_si          (bscan[3] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[3] ),
     .oe              (vss ),
     .data            (vdd ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (pack4[2] ),
     .ref             (ref ),
     .pad             (jpack4[2] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad dtl0_0_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[7] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck2 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[7] ),
     .serial_out      (net132[2] ),
     .bsr_si          (bscan[8] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[8] ),
     .oe              (pack0_en ),
     .data            (j_pack0[2] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (pack0out[2] ),
     .ref             (ref ),
     .pad             (jpack0[2] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
terminator I58_3_ (
     .TERM            (net64[2] ) );
terminator I61_1_ (
     .TERM            (net98[1] ) );
bw_io_dtl_pad I2_2_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[3] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[3] ),
     .serial_out      (net64[3] ),
     .bsr_si          (bscan[4] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[4] ),
     .oe              (vss ),
     .data            (vdd ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (pack5[1] ),
     .ref             (ref ),
     .pad             (jpack5[1] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
terminator I122 (
     .TERM            (pack0out[2] ) );
terminator I51 (
     .TERM            (pack0out[1] ) );
terminator I52 (
     .TERM            (pack0out[0] ) );
terminator I53 (
     .TERM            (pack1out[2] ) );
terminator I54 (
     .TERM            (pack1out[1] ) );
terminator I55 (
     .TERM            (pack1out[0] ) );
endmodule
