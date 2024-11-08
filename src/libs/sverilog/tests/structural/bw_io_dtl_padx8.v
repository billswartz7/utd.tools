// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_padx8.v
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
module bw_io_dtl_padx8(update_dr_buf ,por_l_buf ,shift_dr_buf ,
     rst_io_l_buf ,reset_l_buf ,mode_ctl_buf ,sel_bypass_buf ,
     clock_dr_buf ,rst_val_up_buf ,se_buf ,oe_buf ,up_open_buf ,
     down_25_buf ,clk ,cbu0 ,cbd0 ,vddo ,si ,bsr_si ,data ,ref ,cbd1 ,
     cbu1 ,hiz_l_buf ,rst_val_dn_buf ,pad ,to_core ,bso ,so );
output [7:0]	to_core ;
input [1:0]	update_dr_buf ;
input [1:0]	por_l_buf ;
input [1:0]	shift_dr_buf ;
input [1:0]	rst_io_l_buf ;
input [1:0]	reset_l_buf ;
input [1:0]	mode_ctl_buf ;
input [1:0]	sel_bypass_buf ;
input [1:0]	clock_dr_buf ;
input [1:0]	rst_val_up_buf ;
input [1:0]	se_buf ;
input [1:0]	oe_buf ;
input [1:0]	up_open_buf ;
input [1:0]	down_25_buf ;
input [8:1]	cbu0 ;
input [8:1]	cbd0 ;
input [7:0]	data ;
input [8:1]	cbd1 ;
input [8:1]	cbu1 ;
input [1:0]	hiz_l_buf ;
input [1:0]	rst_val_dn_buf ;
inout [7:0]	pad ;
output		bso ;
output		so ;
input		clk ;
input		vddo ;
input		si ;
input		bsr_si ;
input		ref ;
supply0		vss ;
 
wire [1:0]	net120 ;
wire [7:1]	bscan ;
wire [7:1]	scan ;
wire [1:0]	net154 ;
wire [1:0]	net52 ;
wire [1:0]	net86 ;
wire		ck0 ;
wire		ck1 ;
 
 
terminator I45_6_ (
     .TERM            (net120[0] ) );
bw_io_dtl_pad dtl_7_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[3] ),
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
     .bso             (bscan[3] ),
     .serial_out      (net154[1] ),
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
terminator I45_7_ (
     .TERM            (net120[1] ) );
bw_io_dtl_pad dtl_8_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[4] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[4] ),
     .serial_out      (net86[0] ),
     .bsr_si          (bscan[3] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[3] ),
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
terminator I40_2_ (
     .TERM            (net154[0] ) );
terminator I43_4_ (
     .TERM            (net86[0] ) );
bw_io_dtl_pad dtl_11_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[7] ),
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
     .bso             (bscan[7] ),
     .serial_out      (net120[1] ),
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
bw_io_dtl_pad dtl_9_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[5] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[5] ),
     .serial_out      (net86[1] ),
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
terminator I40_3_ (
     .TERM            (net154[1] ) );
terminator I43_5_ (
     .TERM            (net86[1] ) );
bw_io_dtl_pad dtl_4_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[1] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bscan[1] ),
     .serial_out      (net52[0] ),
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
terminator I61_0_ (
     .TERM            (net52[0] ) );
bw_io_dtl_pad dtl_5_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (so ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (vss ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck1 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (vss ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (bso ),
     .serial_out      (net52[1] ),
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
bw_u1_ckbuf_33x I46 (
     .clk             (ck0 ),
     .rclk            (clk ) );
bw_u1_ckbuf_33x I47 (
     .clk             (ck1 ),
     .rclk            (clk ) );
terminator I61_1_ (
     .TERM            (net52[1] ) );
bw_io_dtl_pad dtl_10_ (
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
     .serial_out      (net120[0] ),
     .bsr_si          (bsr_si ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (si ),
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
bw_io_dtl_pad dtl_6_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[2] ),
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
     .bso             (bscan[2] ),
     .serial_out      (net154[0] ),
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
endmodule
