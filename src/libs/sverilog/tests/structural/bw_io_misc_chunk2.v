// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_misc_chunk2.v
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
module bw_io_misc_chunk2(io_pll_char_in ,sel_bypass ,tck2 ,io_tck2 ,
     pll_char_in ,ssi_mosi ,jbi_io_ssi_mosi ,ssi_miso ,io_jbi_ssi_miso ,
     obsel ,vddo ,vref ,ckd ,so ,bso ,rst_val_up ,rst_val_dn ,reset_l ,
     si ,se ,bsi ,rst_io_l ,hiz_l ,shift_dr ,update_dr ,clock_dr ,
     mode_ctl ,clk ,por_l );
input [5:4]	obsel ;
output		io_pll_char_in ;
output		io_tck2 ;
output		io_jbi_ssi_miso ;
output		so ;
output		bso ;
input		sel_bypass ;
input		jbi_io_ssi_mosi ;
input		vddo ;
input		vref ;
input		ckd ;
input		rst_val_up ;
input		rst_val_dn ;
input		reset_l ;
input		si ;
input		se ;
input		bsi ;
input		rst_io_l ;
input		hiz_l ;
input		shift_dr ;
input		update_dr ;
input		clock_dr ;
input		mode_ctl ;
input		clk ;
input		por_l ;
inout		tck2 ;
inout		pll_char_in ;
inout		ssi_mosi ;
inout		ssi_miso ;
supply1		vdd ;
supply0		vss ;
 
wire		bscan_ssi_miso_ssi_mosi ;
wire		net36 ;
wire		net066 ;
wire		scan_ssi_mosi_ssi_miso ;
 
 
bw_u1_ckbuf_40x Iclkbuf_2 (
     .clk             (net066 ),
     .rclk            (clk ) );
bw_io_hstl_pad ssi_miso_pad (
     .obsel           ({obsel } ),
     .so              (so ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net066 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bscan_ssi_miso_ssi_mosi ),
     .bsr_si          (bsi ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (scan_ssi_mosi_ssi_miso ),
     .oe              (vss ),
     .data            (vss ),
     .se              (se ),
     .to_core         (io_jbi_ssi_miso ),
     .por_l           (por_l ),
     .pad             (ssi_miso ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
bw_io_cmos2_pad pll_char_in_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_pll_char_in ),
     .pad             (pll_char_in ),
     .por_l           (por_l ) );
bw_io_cmos2_pad tck2_pad (
     .oe              (vss ),
     .vddo            (vddo ),
     .data            (vss ),
     .to_core         (io_tck2 ),
     .pad             (tck2 ),
     .por_l           (por_l ) );
bw_io_hstl_pad ssi_mosi_pad (
     .obsel           ({obsel } ),
     .so              (scan_ssi_mosi_ssi_miso ),
     .clock_dr        (clock_dr ),
     .vref            (vref ),
     .update_dr       (update_dr ),
     .clk             (net066 ),
     .reset_l         (reset_l ),
     .hiz_l           (hiz_l ),
     .shift_dr        (shift_dr ),
     .rst_io_l        (rst_io_l ),
     .rst_val_up      (rst_val_up ),
     .bso             (bso ),
     .bsr_si          (bscan_ssi_miso_ssi_mosi ),
     .rst_val_dn      (rst_val_dn ),
     .mode_ctl        (mode_ctl ),
     .si              (si ),
     .oe              (vdd ),
     .data            (jbi_io_ssi_mosi ),
     .se              (se ),
     .to_core         (net36 ),
     .por_l           (por_l ),
     .pad             (ssi_mosi ),
     .vddo            (vddo ),
     .sel_bypass      (sel_bypass ),
     .ckd             (ckd ) );
endmodule
