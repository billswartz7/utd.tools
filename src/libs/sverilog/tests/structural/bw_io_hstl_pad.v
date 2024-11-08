// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_hstl_pad.v
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
/////////////////////////////////////////////////////////////////////////
/*
//  HSTL PAD
*/
////////////////////////////////////////////////////////////////////////

`include "sys.h" 

module bw_io_hstl_pad(so ,obsel ,clock_dr ,vref ,update_dr ,clk ,reset_l
      ,hiz_l ,shift_dr ,rst_io_l ,rst_val_up ,bso ,bsr_si ,
     rst_val_dn ,mode_ctl ,si ,oe ,data ,se ,to_core ,por_l ,pad ,
     sel_bypass ,ckd, vddo );
input [5:4]	obsel ;
output		so ;
output		bso ;
output		to_core ;
input		clock_dr ;
input		vref ;
input		update_dr ;
input		clk ;
input		reset_l ;
input		hiz_l ;
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
input		por_l ;
input		sel_bypass ;
input		ckd ;
inout		pad ;
input		vddo ;
supply1		vdd ;
supply0		vss ;
 
wire		cmsi_clk_en_l ;
wire		se_buf ;
wire		net199 ;
wire		q_up_pad ;
wire		bsr_dn_l ;
wire		q_dn_pad_l ;
wire		rcvr_data_to_bsr ;
wire		pad_clk_en_l ;
wire		por ;
wire		bsr_data_to_core ;
wire		sel_data_n ;
wire		cmsi_l ;
wire		pad_up ;
wire		bsr_up ;
wire		pad_dn_l ;
 
 
bw_io_dtlhstl_rcv I1 (
     .pad_clk_en_l    (pad_clk_en_l ),
     .pad             (pad ),
     .clk             (clk ),
     .cmsi_l          (cmsi_l ),
     .ref             (vref ),
     .cmsi_clk_en_l   (cmsi_clk_en_l ),
     .so              (so ),
     .se_buf          (se_buf ),
     .out             (to_core ),
     .vddo            (vddo) );
bw_io_hstl_edgelogic I2 (
     .obsel           ({obsel } ),
     .ckd             (ckd ),
     .bsr_up          (q_up_pad ),
     .bsr_dn_l        (q_dn_pad_l ),
     .pad_dn_l        (pad_dn_l ),
     .pad_up          (pad_up ),
     .oe              (oe ),
     .data            (data ),
     .clk             (clk ),
     .por_l           (por_l ),
     .se              (se ),
     .bsr_mode        (mode_ctl ),
     .sel_bypass      (sel_bypass ),
     .reset_l         (reset_l ),
     .por             (por ),
     .si              (si ),
     .bsr_data_to_core (bsr_data_to_core ),
     .cmsi_clk_en_l   (cmsi_clk_en_l ),
     .cmsi_l          (cmsi_l ),
     .pad_clk_en_l    (pad_clk_en_l ),
     .se_buf          (se_buf ) );
bw_io_hstl_drv I3 (
     .cbu             ({vss ,vss ,vss ,vss ,vdd ,vdd ,vdd ,vdd } ),
     .cbd             ({vss ,vss ,vss ,vss ,vdd ,vdd ,vdd ,vdd } ),
     .por             (por ),
     .bsr_dn_l        (bsr_dn_l ),
     .bsr_up          (bsr_up ),
     .pad_dn_l        (pad_dn_l ),
     .sel_data_n      (sel_data_n ),
     .pad_up          (pad_up ),
     .pad             (pad ),
     .vddo            (vddo) );
bw_io_dtl_bscan bscan (
     .bsr_data_to_core (bsr_data_to_core ),
     .hiz_l           (hiz_l ),
     .rst_io_l        (rst_io_l ),
     .rst_val_dn      (rst_val_dn ),
     .rst_val_up      (rst_val_up ),
     .shift_dr        (shift_dr ),
     .clock_dr        (clock_dr ),
     .update_dr       (update_dr ),
     .up_open         (vdd ),
     .bsr_so          (bso ),
     .se              (se ),
     .mode_ctl        (mode_ctl ),
     .bsr_si          (bsr_si ),
     .q_up_mux        (bsr_up ),
     .down_25         (vss ),
     .sel_data_n      (sel_data_n ),
     .rcvr_data_to_bsr (rcvr_data_to_bsr ),
     .q25_dn_pad_l    (vdd ),
     .q_dn_pad_l      (q_dn_pad_l ),
     .q_dn_mux_l      (bsr_dn_l ),
     .q25_dn_mux_l    (net199 ),
     .q_up_pad        (q_up_pad ),
     .serial_out      (),
     .bypass_enable   (vss),	       
     .clk             (vss),
     .bypass_in       (vss),
     .serial_in       (vss),
     .ps_select       (vss),	      
     .out_type        (vss) );
bw_io_schmitt I41 (
     .vddo            (vddo ),
     .out             (rcvr_data_to_bsr ),
     .in              (pad ) );
endmodule

