// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_bscan.v
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
module bw_io_dtl_bscan(q_dn_mux_l ,rst_val_up ,mode_ctl ,serial_out ,
     bsr_so ,bsr_si ,se ,q25_dn_pad_l ,q_up_pad ,update_dr ,out_type ,
     q25_dn_mux_l ,bsr_data_to_core ,rcvr_data_to_bsr ,shift_dr ,up_open
      ,ps_select ,q_dn_pad_l ,sel_data_n ,bypass_enable ,q_up_mux ,
     down_25 ,rst_val_dn ,clk ,serial_in ,hiz_l ,rst_io_l ,clock_dr ,
     bypass_in );
output		q_dn_mux_l ;
output		serial_out ;
output		bsr_so ;
output		q25_dn_mux_l ;
output		bsr_data_to_core ;
output		sel_data_n ;
output		q_up_mux ;
input		rst_val_up ;
input		mode_ctl ;
input		bsr_si ;
input		se ;
input		q25_dn_pad_l ;
input		q_up_pad ;
input		update_dr ;
input		out_type ;
input		rcvr_data_to_bsr ;
input		shift_dr ;
input		up_open ;
input		ps_select ;
input		q_dn_pad_l ;
input		bypass_enable ;
input		down_25 ;
input		rst_val_dn ;
input		clk ;
input		serial_in ;
input		hiz_l ;
input		rst_io_l ;
input		clock_dr ;
input		bypass_in ;
 
wire [1:0]	doe ;
wire [1:0]	tf ;
wire [2:0]	q ;
wire		net110 ;
wire		net117 ;
wire		net119 ;
wire		net123 ;
wire		bypass ;
wire		net127 ;
wire		sd_n ;
wire		se_n ;
wire		net137 ;
wire		net140 ;
wire		bsr_to_core ;
wire		bso_n ;
wire		se_in ;
 
 
bw_u1_inv_8x so_inv8x (
     .z               (bsr_so ),
     .a               (bso_n ) );
bw_io_dtl_flps three_flps (
     .d               ({rcvr_data_to_bsr ,doe[1:0] } ),
     .q               ({q } ),
     .clk             (clock_dr ),
     .so              (net110 ),
     .si              (bsr_si ),
     .se              (net117 ) );
bw_u1_inv_1x ud_inv1x (
     .z               (net137 ),
     .a               (update_dr ) );
bw_u1_inv_5x bc_inv5x (
     .z               (bsr_data_to_core ),
     .a               (net127 ) );
bw_u1_inv_1x ps_inv1 (
     .z               (bypass ),
     .a               (net140 ) );
bw_u1_inv_3x shfdr_inv3x (
     .z               (net117 ),
     .a               (sd_n ) );
bw_u1_nand2_1x ps_nand2 (
     .z               (net140 ),
     .a               (tf[1] ),
     .b               (bypass_enable ) );
bw_u1_inv_1x shfdr_inv1x (
     .z               (sd_n ),
     .a               (shift_dr ) );
bw_u1_inv_4x so_inv4x (
     .z               (bso_n ),
     .a               (net110 ) );
bw_io_dq_pscan pscan (
     .serial_in       (serial_in ),
     .serial_out      (serial_out ),
     .bypass_in       (bypass_in ),
     .out_type        (out_type ),
     .clk             (clk ),
     .bypass          (bypass ),
     .ps_select       (ps_select ),
     .rcv_in          (rcvr_data_to_bsr ) );
bw_u1_inv_2x bc_inv2x (
     .z               (net127 ),
     .a               (bsr_to_core ) );
bw_io_bs_fsdq_2x three_latches (
     .q               ({bsr_to_core ,tf[1:0] } ),
     .d               ({q } ),
     .up_dr           (net119 ) );
bw_io_dtl_bscl1 comb_lgc_1 (
     .intest_oe       (doe[0] ),
     .intest_d        (doe[1] ),
     .q_dn_pad        (q_dn_pad_l ),
     .q25_dn_pad      (q25_dn_pad_l ),
     .q_up_pad        (q_up_pad ) );
bw_io_dtl_bscl2 comb_lgc_2 (
     .scan_mode       (se_in ),
     .mode_ctl        (mode_ctl ),
     .out_type        (out_type ),
     .rst_val_dn      (rst_val_dn ),
     .bscan_oe        (tf[0] ),
     .sel_data_n      (sel_data_n ),
     .q25_dn_mux_l    (q25_dn_mux_l ),
     .down_25         (down_25 ),
     .rst_io_l        (rst_io_l ),
     .ps_select       (ps_select ),
     .q_dn_mux_l      (q_dn_mux_l ),
     .up_open         (up_open ),
     .bscan_d         (tf[1] ),
     .hiz_l           (hiz_l ),
     .q_up_mux        (q_up_mux ),
     .ps_data         (serial_out ),
     .rst_val_up      (rst_val_up ) );
bw_u1_inv_2x se_inv2x (
     .z               (se_in ),
     .a               (se_n ) );
bw_u1_inv_3x ud_inv3x (
     .z               (net119 ),
     .a               (net123 ) );
bw_u1_inv_1x se_inv1x (
     .z               (se_n ),
     .a               (se ) );
bw_u1_inv_2x ud_inv2x (
     .z               (net123 ),
     .a               (net137 ) );
endmodule


