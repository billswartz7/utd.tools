// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_pad_r3.v
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
module bw_io_dtl_pad_r3(j_ad ,req1_oe ,cbu0 ,j_rst_l ,cbu1 ,j_req1_i ,
     j_par_data ,serial_in ,spare_out ,j_par_en ,serial_out ,ps_select ,
     bypass_enable ,bso ,down_25_buf ,cbd0 ,j_err_i ,jad32 ,jpar_o ,
     j_rst_l_o ,so ,j_req5 ,cbd1 ,req5_l ,j_req0 ,j_err ,j_req4 ,jpar ,
     spare_in ,por_l_buf ,j_req0_i ,j_req0_en ,vddo ,rst_io_l_buf ,
     bsr_si ,ref ,shift_dr_buf ,hiz_l_buf ,rst_val_dn_buf ,update_dr_buf
      ,req4_l ,jad32_en ,jad32_data ,spare_en ,se_buf ,up_open_buf ,si ,
     clk ,mode_ctl_buf ,rst_val_up_buf ,reset_l_buf ,clock_dr_buf ,spare
      ,sel_bypass_buf );
output [1:0]	spare_out ;
input [8:1]	cbu0 ;
input [8:1]	cbu1 ;
input [1:0]	down_25_buf ;
input [8:1]	cbd0 ;
input [8:1]	cbd1 ;
input [0:0]	spare_in ;
input [1:0]	por_l_buf ;
input [1:0]	rst_io_l_buf ;
input [1:0]	shift_dr_buf ;
input [1:0]	hiz_l_buf ;
input [1:0]	rst_val_dn_buf ;
input [1:0]	update_dr_buf ;
input [0:0]	spare_en ;
input [1:0]	se_buf ;
input [1:0]	up_open_buf ;
input [1:0]	mode_ctl_buf ;
input [1:0]	rst_val_up_buf ;
input [1:0]	reset_l_buf ;
input [1:0]	clock_dr_buf ;
input [1:0]	sel_bypass_buf ;
inout [1:0]	spare ;
output		serial_out ;
output		bso ;
output		jad32 ;
output		jpar_o ;
output		j_rst_l_o ;
output		so ;
output		req5_l ;
output		req4_l ;
input		req1_oe ;
input		j_req1_i ;
input		j_par_data ;
input		serial_in ;
input		j_par_en ;
input		ps_select ;
input		bypass_enable ;
input		j_err_i ;
input		j_req0_i ;
input		j_req0_en ;
input		vddo ;
input		bsr_si ;
input		ref ;
input		jad32_en ;
input		jad32_data ;
input		si ;
input		clk ;
inout		j_ad ;
inout		j_rst_l ;
inout		j_req5 ;
inout		j_req0 ;
inout		j_err ;
inout		j_req4 ;
inout		jpar ;
supply1		vdd ;
supply0		vss ;
 
wire [9:2]	bscan ;
wire [9:2]	scan ;
wire [1:0]	net109 ;
wire [1:0]	net0186 ;
wire [1:0]	net0118 ;
wire		ck0 ;
wire		ck2 ;
wire		ck3 ;
wire		net245 ;
wire		j_req0_o ;
wire		req1_in ;
wire		net177 ;
wire		j_err_o ;
 
assign	req1_in = j_req1_i ;
 
terminator I166_0_ (
     .TERM            (net0186[1] ) );
bw_io_dtl_pad I143_1_ (
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
     .serial_out      (net109[0] ),
     .bsr_si          (bscan[9] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[9] ),
     .oe              (vdd ),
     .data            (j_err_i ),
     .se              (se_buf[0] ),
     .up_open         (vss ),
     .down_25         (vss ),
     .to_core         (j_err_o ),
     .ref             (ref ),
     .pad             (j_err ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad I2 (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (bypass_enable ),
     .so              (scan[3] ),
     .por_l           (por_l_buf[0] ),
     .clock_dr        (clock_dr_buf[0] ),
     .bypass_in       (vss ),
     .serial_in       (serial_in ),
     .update_dr       (update_dr_buf[0] ),
     .clk             (ck0 ),
     .reset_l         (reset_l_buf[0] ),
     .hiz_l           (hiz_l_buf[0] ),
     .ps_select       (ps_select ),
     .out_type        (vss ),
     .shift_dr        (shift_dr_buf[0] ),
     .rst_io_l        (rst_io_l_buf[0] ),
     .rst_val_up      (rst_val_up_buf[0] ),
     .bso             (bscan[3] ),
     .serial_out      (serial_out ),
     .bsr_si          (bscan[4] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[4] ),
     .oe              (jad32_en ),
     .data            (jad32_data ),
     .se              (se_buf[0] ),
     .up_open         (up_open_buf[0] ),
     .down_25         (down_25_buf[0] ),
     .to_core         (jad32 ),
     .ref             (ref ),
     .pad             (j_ad ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
terminator I167_1_ (
     .TERM            (net0118[0] ) );
terminator I141 (
     .TERM            (j_req0_o ) );
bw_io_dtl_pad I143_0_ (
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
     .serial_out      (net109[1] ),
     .bsr_si          (bscan[5] ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (scan[5] ),
     .oe              (j_req0_en ),
     .data            (j_req0_i ),
     .se              (se_buf[0] ),
     .up_open         (vss ),
     .down_25         (vss ),
     .to_core         (j_req0_o ),
     .ref             (ref ),
     .pad             (j_req0 ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
terminator I142 (
     .TERM            (j_err_o ) );
bw_io_dtl_pad I120_1_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[2] ),
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
     .bso             (bscan[2] ),
     .serial_out      (net0118[0] ),
     .bsr_si          (bscan[6] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[6] ),
     .oe              (vss ),
     .data            (vdd ),
     .se              (se_buf[1] ),
     .up_open         (vss ),
     .down_25         (vss ),
     .to_core         (req5_l ),
     .ref             (ref ),
     .pad             (j_req5 ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
terminator I167_0_ (
     .TERM            (net0118[1] ) );
bw_io_dtl_pad I120_0_ (
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
     .serial_out      (net0118[1] ),
     .bsr_si          (bscan[2] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[2] ),
     .oe              (vss ),
     .data            (vdd ),
     .se              (se_buf[1] ),
     .up_open         (vss ),
     .down_25         (vss ),
     .to_core         (req4_l ),
     .ref             (ref ),
     .pad             (j_req4 ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
terminator I164 (
     .TERM            (net177 ) );
terminator I165 (
     .TERM            (net245 ) );
bw_io_dtl_pad I41_2_ (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[6] ),
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
     .bso             (bscan[6] ),
     .serial_out      (net0186[1] ),
     .bsr_si          (bscan[7] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[7] ),
     .oe              (vss ),
     .data            (vdd ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (j_rst_l_o ),
     .ref             (ref ),
     .pad             (j_rst_l ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
bw_io_dtl_pad I41_3_ (
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
     .serial_out      (net0186[0] ),
     .bsr_si          (bscan[8] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[8] ),
     .oe              (j_par_en ),
     .data            (j_par_data ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (jpar_o ),
     .ref             (ref ),
     .pad             (jpar ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
terminator I163_5_ (
     .TERM            (net109[0] ) );
terminator I163_4_ (
     .TERM            (net109[1] ) );
bw_u1_ckbuf_30x I190 (
     .clk             (ck2 ),
     .rclk            (clk ) );
bw_u1_ckbuf_28x I191 (
     .clk             (ck3 ),
     .rclk            (clk ) );
bw_io_dtl_pad I43 (
     .cbu             ({cbu0 } ),
     .cbd             ({cbd0 } ),
     .bypass_enable   (vss ),
     .so              (scan[9] ),
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
     .bso             (bscan[9] ),
     .serial_out      (net177 ),
     .bsr_si          (bsr_si ),
     .rst_val_dn      (rst_val_dn_buf[0] ),
     .mode_ctl        (mode_ctl_buf[0] ),
     .si              (si ),
     .oe              (req1_oe ),
     .data            (req1_in ),
     .se              (se_buf[0] ),
     .up_open         (vss ),
     .down_25         (vss ),
     .to_core         (spare_out[1] ),
     .ref             (ref ),
     .pad             (spare[1] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[0] ) );
bw_io_dtl_pad I119 (
     .cbu             ({cbu1 } ),
     .cbd             ({cbd1 } ),
     .bypass_enable   (vss ),
     .so              (scan[8] ),
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
     .bso             (bscan[8] ),
     .serial_out      (net245 ),
     .bsr_si          (bscan[3] ),
     .rst_val_dn      (rst_val_dn_buf[1] ),
     .mode_ctl        (mode_ctl_buf[1] ),
     .si              (scan[3] ),
     .oe              (spare_en[0] ),
     .data            (spare_in[0] ),
     .se              (se_buf[1] ),
     .up_open         (up_open_buf[1] ),
     .down_25         (down_25_buf[1] ),
     .to_core         (spare_out[0] ),
     .ref             (ref ),
     .pad             (spare[0] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass_buf[1] ) );
terminator I166_1_ (
     .TERM            (net0186[0] ) );
bw_u1_ckbuf_33x I47 (
     .clk             (ck0 ),
     .rclk            (clk ) );
endmodule
