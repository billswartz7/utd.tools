// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_cmos_pad.v
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
//  CMOS PAD
*/
////////////////////////////////////////////////////////////////////////

`include "sys.h" 

module bw_io_cmos_pad(oe ,bsr_si ,rst_io_l ,se ,rst_val_up ,data ,
     mode_ctl ,clock_dr ,update_dr ,rst_val_dn ,hiz_l ,
     shift_dr ,bso ,to_core ,pad ,por_l, vddo );
output		bso ;
output		to_core ;
input		oe ;
input		bsr_si ;
input		rst_io_l ;
input		se ;
input		rst_val_up ;
input		data ;
input		mode_ctl ;
input		clock_dr ;
input		update_dr ;
input		rst_val_dn ;
input		hiz_l ;
input		shift_dr ;
input		por_l ;
inout		pad ;
input  		vddo ;
supply1		vdd ;
supply0		vss ;
 
wire		q_up_pad ;
wire		net84 ;
wire		rcvr_data ;
wire		bsr_dn_l ;
wire		q_dn_pad_l ;
wire		por ;
wire		bsr_data_to_core ;
wire		sel_data_n ;
wire		pad_up ;
wire		bsr_up ;
wire		pad_dn_l ;
 
 
bw_io_cmos_edgelogic I2 (
     .rcvr_data       (rcvr_data ),
     .to_core         (to_core ),
     .se              (se ),
     .bsr_up          (q_up_pad ),
     .bsr_dn_l        (q_dn_pad_l ),
     .pad_dn_l        (pad_dn_l ),
     .pad_up          (pad_up ),
     .oe              (oe ),
     .data            (data ),
     .por_l           (por_l ),
     .por             (por ),
     .bsr_data_to_core (bsr_data_to_core ),
     .bsr_mode        (mode_ctl ) );
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
     .rcvr_data_to_bsr (rcvr_data ),
     .q25_dn_pad_l    (vdd ),
     .q_dn_pad_l      (q_dn_pad_l ),
     .q_dn_mux_l      (bsr_dn_l ),
     .q25_dn_mux_l    (net84 ),
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
     .out             (rcvr_data ),
     .in              (pad ) );
endmodule

