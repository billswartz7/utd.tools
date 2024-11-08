// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_pad_adp.v
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
module bw_io_dtl_pad_adp(serial_in ,serial_out ,ps_select_buf ,
     bypass_en_buf ,cbd0 ,cbu0 ,cbd1 ,cbu1 ,vddo ,clk ,por_l_buf ,
     rst_io_l_buf ,shift_dr_buf ,hiz_l_buf ,rst_val_dn_buf ,
     update_dr_buf ,reset_l_buf ,mode_ctl_buf ,sel_bypass_buf ,
     clock_dr_buf ,rst_val_up_buf ,se_buf ,up_open_buf ,down_25_buf ,
     data ,ref ,j_adp_en ,oe_buf ,si ,bsr_si ,j_adp ,to_core ,jadpout ,
     bso ,so ,pad ,jadp );
output [7:0]	serial_out ;
output [7:0]	to_core ;
output [3:0]	jadpout ;
input [7:0]	serial_in ;
input [1:0]	ps_select_buf ;
input [1:0]	bypass_en_buf ;
input [8:1]	cbd0 ;
input [8:1]	cbu0 ;
input [8:1]	cbd1 ;
input [8:1]	cbu1 ;
input [1:0]	por_l_buf ;
input [1:0]	rst_io_l_buf ;
input [1:0]	shift_dr_buf ;
input [1:0]	hiz_l_buf ;
input [1:0]	rst_val_dn_buf ;
input [1:0]	update_dr_buf ;
input [1:0]	reset_l_buf ;
input [1:0]	mode_ctl_buf ;
input [1:0]	sel_bypass_buf ;
input [1:0]	clock_dr_buf ;
input [1:0]	rst_val_up_buf ;
input [1:0]	se_buf ;
input [1:0]	up_open_buf ;
input [1:0]	down_25_buf ;
input [7:0]	data ;
input [1:0]	oe_buf ;
input [3:0]	j_adp ;
inout [7:0]	pad ;
inout [3:0]	jadp ;
output		bso ;
output		so ;
input		vddo ;
input		clk ;
input		ref ;
input		j_adp_en ;
input		si ;
input		bsr_si ;
supply1		vdd ;
supply0		vss ;
 
wire [1:0]	net57 ;
wire [1:0]	net97 ;
wire		\bscan[7] ;
wire		\scan[3] ;
wire		\scan[4] ;
wire		\scan[11] ;
wire		\bscan[9] ;
wire		\bscan[1] ;
wire		bso_next ;
wire		\scan[1] ;
wire		\scan[9] ;
wire		\bscan[4] ;
wire		ck0 ;
wire		ck1 ;
wire		ck2 ;
wire		ck3 ;
wire		\bscan[3] ;
wire		\bscan[10] ;
wire		\scan[7] ;
wire		so_next ;
wire		\bscan[6] ;
wire		\scan[8] ;
wire		\bscan[5] ;
wire		\scan[5] ;
wire		\scan[10] ;
wire		\bscan[8] ;
wire		\bscan[11] ;
wire		\scan[6] ;
 
 
terminator I61_2_ (
     .TERM            (net57[1] ) );
bw_u1_ckbuf_30x I62 (
     .clk             (ck3 ),
     .rclk            (clk ) );
bw_u1_ckbuf_30x I63 (
     .clk             (ck0 ),
     .rclk            (clk ) );
bw_u1_ckbuf_30x I64 (
     .clk             (ck1 ),
     .rclk            (clk ) );
bw_io_dtl_pad dtl_7_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (\scan[6] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[3] ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck0 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (ps_select_buf[0] ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (\bscan[6] ),
     .serial_out      (serial_out[3] ),
     .bsr_si          (\bscan[7] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (\scan[7] ),
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
terminator I61_3_ (
     .TERM            (net57[0] ) );
bw_io_dtl_pad dtl_0_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (\scan[3] ),
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
     .bso             (\bscan[3] ),
     .serial_out      (net57[0] ),
     .bsr_si          (\bscan[4] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (\scan[4] ),
     .oe              (j_adp_en ),
     .data            (j_adp[3] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (jadpout[3] ),
     .ref             (ref ),
     .pad             (jadp[3] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad dtl_8_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (\scan[9] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (serial_out[5] ),
     .serial_in       (serial_in[4] ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck2 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (ps_select_buf[1] ),
     .out_type        (vdd ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (\bscan[9] ),
     .serial_out      (serial_out[4] ),
     .bsr_si          (bso_next ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (so_next ),
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
bw_io_dtl_pad dtl_11_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (\scan[10] ),
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
     .bso             (\bscan[10] ),
     .serial_out      (serial_out[7] ),
     .bsr_si          (\bscan[11] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (\scan[11] ),
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
bw_io_dtl_pad dtl_1_ (
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
     .serial_out      (net57[1] ),
     .bsr_si          (\bscan[3] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (\scan[3] ),
     .oe              (j_adp_en ),
     .data            (j_adp[2] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (jadpout[2] ),
     .ref             (ref ),
     .pad             (jadp[2] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad dtl_9_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (\scan[8] ),
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
     .bso             (\bscan[8] ),
     .serial_out      (serial_out[5] ),
     .bsr_si          (\bscan[9] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (\scan[9] ),
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
bw_io_dtl_pad dtl_2_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (\scan[1] ),
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
     .bso             (\bscan[1] ),
     .serial_out      (net97[0] ),
     .bsr_si          (\bscan[6] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (\scan[6] ),
     .oe              (j_adp_en ),
     .data            (j_adp[1] ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (jadpout[1] ),
     .ref             (ref ),
     .pad             (jadp[1] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad dtl_3_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (so_next ),
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
     .bso             (bso_next ),
     .serial_out      (net97[1] ),
     .bsr_si          (\bscan[1] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (\scan[1] ),
     .oe              (j_adp_en ),
     .data            (j_adp[0] ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (jadpout[0] ),
     .ref             (ref ),
     .pad             (jadp[0] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
terminator I163_5_ (
     .TERM            (net97[0] ) );
bw_io_dtl_pad dtl_4_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (\scan[5] ),
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
     .bso             (\bscan[5] ),
     .serial_out      (serial_out[0] ),
     .bsr_si          (\bscan[8] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (\scan[8] ),
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
terminator I163_4_ (
     .TERM            (net97[1] ) );
bw_io_dtl_pad dtl_5_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (bypass_en_buf[1] ),
     .so              (\scan[4] ),
     .por_l           (por_l_buf[1] ),
     .clock_dr        (clock_dr_buf[1] ),
     .bypass_in       (vss ),
     .serial_in       (serial_in[1] ),
     .update_dr       (update_dr_buf[1] ),
     .clk             (ck2 ),
     .reset_l         (reset_l_buf[1] ),
     .hiz_l           (hiz_l_buf[1] ),
     .ps_select       (ps_select_buf[1] ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[1] ),
     .rst_io_l        (rst_io_l_buf[1] ),
     .rst_val_up      (rst_val_up_buf[1] ),
     .bso             (\bscan[4] ),
     .serial_out      (serial_out[1] ),
     .bsr_si          (\bscan[5] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (\scan[5] ),
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
bw_u1_ckbuf_30x I47 (
     .clk             (ck2 ),
     .rclk            (clk ) );
bw_io_dtl_pad dtl_10_ (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (\scan[11] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (serial_out[7] ),
     .serial_in       (serial_in[6] ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck0 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (ps_select_buf[0] ),
     .out_type        (vdd ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (\bscan[11] ),
     .serial_out      (serial_out[6] ),
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
     .bypass_enable   (bypass_en_buf[0] ),
     .so              (\scan[7] ),
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
     .bso             (\bscan[7] ),
     .serial_out      (serial_out[2] ),
     .bsr_si          (\bscan[10] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (\scan[10] ),
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
