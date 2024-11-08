// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_misc_chunk5.v
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
module bw_io_misc_chunk5(clk ,sel_bypass ,spare_misc_pad ,
     spare_misc_paddata ,obsel ,io_tdo_en ,ckd ,vref ,vddo ,io_tdo ,
     rst_val_up ,io_tdi ,mode_ctl ,rst_val_dn ,io_trst_l ,bsi ,io_tck ,
     clock_dr ,tck ,shift_dr ,trst_l ,hiz_l ,tdi ,update_dr ,rst_io_l ,
     por_l ,tdo ,se ,si ,reset_l ,so ,bso ,spare_misc_padoe ,
     spare_misc_pad_to_core );
output [2:1]	spare_misc_pad_to_core ;
input [2:1]	spare_misc_paddata ;
input [5:4]	obsel ;
input [2:1]	spare_misc_padoe ;
inout [2:1]	spare_misc_pad ;
output		io_tdi ;
output		io_trst_l ;
output		io_tck ;
output		so ;
output		bso ;
input		clk ;
input		sel_bypass ;
input		io_tdo_en ;
input		ckd ;
input		vref ;
input		vddo ;
input		io_tdo ;
input		rst_val_up ;
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
inout		tck ;
inout		trst_l ;
inout		tdi ;
inout		tdo ;
supply0		vss ;
 
wire		bscan_spare1_spare2 ;
wire		net133 ;
wire		bscan_spare2_spare1 ;
wire		net084 ;
 
 
bw_io_cmos2_pad tdo_pad (
     .oe              (io_tdo_en ),
     .vddo            (vddo ),
     .data            (io_tdo ),
     .to_core         (net133 ),
     .pad             (tdo ),
     .por_l           (por_l ) );
bw_u1_ckbuf_40x Iclkbuf_5 (
     .clk             (net084 ),
     .rclk            (clk ) );
bw_io_hstl_pad spare_misc_pad_2_pad (
     .obsel           ({obsel } ),
     .so              (so ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net084 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bscan_spare2_spare1 ),
     .bsr_si          (bsi ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (bscan_spare1_spare2 ),
     .oe              (spare_misc_padoe[2] ),
     .data            (spare_misc_paddata[2] ),
     .se              (se ),
     .to_core         (spare_misc_pad_to_core[2] ),
     .por_l           (por_l ),
     .pad             (spare_misc_pad[2] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
bw_io_hstl_pad spare_misc_pad_1_pad (
     .obsel           ({obsel } ),
     .so              (bscan_spare1_spare2 ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net084 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bso ),
     .bsr_si          (bscan_spare2_spare1 ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (si ),
     .oe              (spare_misc_padoe[1] ),
     .data            (spare_misc_paddata[1] ),
     .se              (se ),
     .to_core         (spare_misc_pad_to_core[1] ),
     .por_l           (por_l ),
     .pad             (spare_misc_pad[1] ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
bw_io_cmos2_pad_dn tck_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_tck ),
     .pad             (tck ),
     .por_l           (por_l ) );
bw_io_cmos2_pad_up tdi_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_tdi ),
     .pad             (tdi ),
     .por_l           (por_l ) );
bw_io_cmos2_pad_up trst_l_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_trst_l ),
     .pad             (trst_l ),
     .por_l           (por_l ) );
endmodule

