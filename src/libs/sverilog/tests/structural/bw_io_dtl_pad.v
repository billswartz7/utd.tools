// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_pad.v
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
module bw_io_dtl_pad(bypass_enable ,so ,por_l ,clock_dr ,bypass_in ,
     serial_in ,update_dr ,clk ,reset_l ,hiz_l ,ps_select ,out_type ,
     shift_dr ,rst_io_l ,rst_val_up ,bso ,serial_out ,bsr_si ,rst_val_dn
      ,mode_ctl ,si ,oe ,data ,se ,up_open ,down_25 ,to_core ,ref ,pad ,
     vddo ,cbu ,cbd ,sel_bypass );
input [8:1]	cbu ;
input [8:1]	cbd ;
output		so ;
output		bso ;
output		serial_out ;
output		to_core ;
input		bypass_enable ;
input		por_l ;
input		clock_dr ;
input		bypass_in ;
input		serial_in ;
input		update_dr ;
input		clk ;
input		reset_l ;
input		hiz_l ;
input		ps_select ;
input		out_type ;
input		shift_dr ;
input		rst_io_l ;
input		rst_val_up ;
input		bsr_si ;
input		rst_val_dn ;
input		mode_ctl ;
input		si ;
input		oe ;
input		data ;
input		se ;
input		up_open ;
input		down_25 ;
input		ref ;
input		vddo ;
input		sel_bypass ;
inout		pad ;
 
wire		pad_dn25_l ;
wire		cmsi_clk_en_l ;
wire		se_buf ;
wire		q_up_pad ;
wire		net82 ;
wire		bsr_dn_l ;
wire		so_bscan ;
wire		q_dn_pad_l ;
wire		rcvr_data_to_bsr ;
wire		pad_clk_en_l ;
wire		por ;
wire		bsr_data_to_core ;
wire		q_dn25_pad_l ;
wire		cmsi_l ;
wire		bsr_dn25_l ;
wire		pad_up ;
wire		bsr_up ;
wire		pad_dn_l ;
 
 
bw_io_dtlhstl_rcv dtlhstl_rcv (
     .out             (to_core ),
     .so              (so ),
     .pad             (pad ),
     .ref             (ref ),
     .clk             (clk ),
     .pad_clk_en_l    (pad_clk_en_l ),
     .cmsi_clk_en_l   (cmsi_clk_en_l ),
     .cmsi_l          (cmsi_l ),
     .se_buf          (se_buf ),
     .vddo            (vddo ) );
bw_io_dtl_edgelogic dtl_edge (
     .pad_clk_en_l    (pad_clk_en_l ),
     .cmsi_clk_en_l   (cmsi_clk_en_l ),
     .bsr_dn25_l      (q_dn25_pad_l ),
     .pad_dn_l        (pad_dn_l ),
     .pad_dn25_l      (pad_dn25_l ),
     .bsr_up          (q_up_pad ),
     .bsr_mode        (mode_ctl ),
     .bsr_data_to_core (bsr_data_to_core ),
     .por_l           (por_l ),
     .bsr_dn_l        (q_dn_pad_l ),
     .se_buf          (se_buf ),
     .cmsi_l          (cmsi_l ),
     .por             (por ),
     .reset_l         (reset_l ),
     .sel_bypass      (sel_bypass ),
     .up_open         (up_open ),
     .oe              (oe ),
     .down_25         (down_25 ),
     .clk             (clk ),
     .data            (data ),
     .se              (se ),
     .si              (so_bscan ),
     .pad_up          (pad_up ) );
bw_io_dtl_bscan bscan (
     .bypass_enable   (bypass_enable ),
     .q25_dn_pad_l    (q_dn25_pad_l ),
     .q_up_mux        (bsr_up ),
     .rst_val_dn      (rst_val_dn ),
     .q_dn_mux_l      (bsr_dn_l ),
     .mode_ctl        (mode_ctl ),
     .hiz_l           (hiz_l ),
     .rst_io_l        (rst_io_l ),
     .bsr_si          (bsr_si ),
     .clk             (clk ),
     .bsr_data_to_core (bsr_data_to_core ),
     .shift_dr        (shift_dr ),
     .up_open         (up_open ),
     .sel_data_n      (net82 ),
     .q_up_pad        (q_up_pad ),
     .rcvr_data_to_bsr (rcvr_data_to_bsr ),
     .clock_dr        (clock_dr ),
     .serial_out      (serial_out ),
     .down_25         (down_25 ),
     .q_dn_pad_l      (q_dn_pad_l ),
     .bypass_in       (bypass_in ),
     .rst_val_up      (rst_val_up ),
     .update_dr       (update_dr ),
     .serial_in       (serial_in ),
     .bsr_so          (bso ),
     .ps_select       (ps_select ),
     .q25_dn_mux_l    (bsr_dn25_l ),
     .out_type        (out_type ),
     .se              (se ) );
bw_io_dtl_drv dtl_drv (
     .cbu             ({cbu } ),
     .cbd             ({cbd } ),
     .pad             (pad ),
     .sel_data_n      (net82 ),
     .pad_up          (pad_up ),
     .pad_dn_l        (pad_dn_l ),
     .pad_dn25_l      (pad_dn25_l ),
     .por             (por ),
     .bsr_up          (bsr_up ),
     .bsr_dn_l        (bsr_dn_l ),
     .bsr_dn25_l      (bsr_dn25_l ),
     .vddo            (vddo ) );
bw_io_dtl_rcv_dc dc_rcv (
     .so              (rcvr_data_to_bsr ),
     .pad             (pad ),
     .ref             (ref ),
     .vddo            (vddo ) );
endmodule
