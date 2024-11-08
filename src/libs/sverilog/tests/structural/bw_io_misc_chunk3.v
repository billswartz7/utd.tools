// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_misc_chunk3.v
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
module bw_io_misc_chunk3(spare_misc_pad ,ssi_sck ,jbi_io_ssi_sck ,
     spare_misc_paddata ,spare_misc_pad_to_core ,trigin ,io_trigin ,
     io_tms ,io_vreg_selbg_l ,clk ,ckd ,vref ,vddo ,rst_val_up ,tms ,
     obsel ,sel_bypass ,mode_ctl ,rst_val_dn ,bsi ,clock_dr ,shift_dr ,
     hiz_l ,update_dr ,rst_io_l ,por_l ,se ,si ,reset_l ,so ,bso ,
     hstl_vref ,vreg_selbg_l ,spare_misc_padoe );
output [0:0]	spare_misc_pad_to_core ;
input [0:0]	spare_misc_paddata ;
input [5:4]	obsel ;
input [0:0]	spare_misc_padoe ;
inout [0:0]	spare_misc_pad ;
output		io_trigin ;
output		io_tms ;
output		io_vreg_selbg_l ;
output		so ;
output		bso ;
input		jbi_io_ssi_sck ;
input		clk ;
input		ckd ;
input		vref ;
input		vddo ;
input		rst_val_up ;
input		sel_bypass ;
input		mode_ctl ;
input		rst_val_dn ;
input		bsi ;
input		clock_dr ;
input		shift_dr ;
input		hiz_l ;
input		update_dr ;
input		rst_io_l ;
input		por_l ;
input		se ;
input		si ;
input		reset_l ;
inout		ssi_sck ;
inout		trigin ;
inout		tms ;
inout		hstl_vref ;
inout		vreg_selbg_l ;
supply1		vdd ;
supply0		vss ;
 
wire		scan_trigin_sck_spare0 ;
wire		bscan_sck_trigin ;
wire		net155 ;
wire		scan_trigin_sck ;
wire		bscan_trigin_sck_spare0 ;
wire		net082 ;
 
 
bw_io_hstl_pad ssi_sck_pad (
     .obsel           ({obsel } ),
     .so              (so ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net082 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bscan_sck_trigin ),
     .bsr_si          (bsi ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (scan_trigin_sck ),
     .oe              (vdd ),
     .data            (jbi_io_ssi_sck ),
     .se              (se ),
     .to_core         (net155 ),
     .por_l           (por_l ),
     .pad             (ssi_sck ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
bw_u1_ckbuf_40x Iclkbuf_3 (
     .clk             (net082 ),
     .rclk            (clk ) );
bw_io_hstl_pad spare_misc_pad_0_pad (
     .obsel           ({obsel } ),
     .so              (scan_trigin_sck_spare0 ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net082 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bso ),
     .bsr_si          (bscan_trigin_sck_spare0 ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (si ),
     .oe              (spare_misc_padoe[0] ),
     .data            (spare_misc_paddata[0] ),
     .se              (se ),
     .to_core         (spare_misc_pad_to_core[0] ),
     .por_l           (por_l ),
     .pad             (spare_misc_pad[0] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
bw_io_cmos2_pad vreg_selbg_l_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_vreg_selbg_l ),
     .pad             (vreg_selbg_l ),
     .por_l           (por_l ) );
bw_io_hstl_pad trigin_pad (
     .obsel           ({obsel } ),
     .so              (scan_trigin_sck ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net082 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bscan_trigin_sck_spare0 ),
     .bsr_si          (bscan_sck_trigin ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (scan_trigin_sck_spare0 ),
     .oe              (vss ),
     .data            (vss ),
     .se              (se ),
     .to_core         (io_trigin ),
     .por_l           (por_l ),
     .pad             (trigin ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
bw_io_cmos2_pad_up tms_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_tms ),
     .pad             (tms ),
     .por_l           (por_l ) );
endmodule

