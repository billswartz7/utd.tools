// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_ctu_clk_sync_mux.v
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
// ------------------------------------------------------------------
/*
module zsoffi_prim (q_l, so, ck, d, se, sd);
output q_l, so;
input  ck, d, se, sd;
reg    q_r;
  always @ (posedge ck)
      q_r <= se ? sd : d;
  assign q_l = ~q_r;
  assign so  = q_r;
endmodule
*/


/*
module bw_clk_zgclk_zinv_32x(clkout ,clkin );


output		clkout ;
input		clkin ;


supply1		vdd ;
supply0		vss ;
nmos n_0_ (clkout ,clkin ,vss  );
pmos p_4_ (clkout ,clkin ,vdd  );
nmos n_1_ (clkout ,clkin ,vss  );
pmos p_5_ (clkout ,clkin ,vdd  );
nmos n_2_ (clkout ,clkin ,vss  );
nmos ns0 (vdd ,vss ,vss  );
nmos ns1 (vdd ,vss ,vss  );
pmos p_6_ (clkout ,clkin ,vdd  );
pmos ps0 (vdd ,vss ,vdd  );
pmos ps1 (vdd ,vss ,vdd  );
nmos n_3_ (clkout ,clkin ,vss  );
pmos p_7_ (clkout ,clkin ,vdd  );
nmos n_4_ (clkout ,clkin ,vss  );
pmos p_0_ (clkout ,clkin ,vdd  );
nmos n_5_ (clkout ,clkin ,vss  );
pmos p_1_ (clkout ,clkin ,vdd  );
nmos n_6_ (clkout ,clkin ,vss  );
pmos p_2_ (clkout ,clkin ,vdd  );
nmos n_7_ (clkout ,clkin ,vss  );
pmos p_3_ (clkout ,clkin ,vdd  );
endmodule

module bw_clk_zgclk_inv_320x(clkin ,clkout );
output [9:0]	clkout ;
input [9:0]	clkin ;
 
 
bw_clk_zgclk_zinv_32x x2 (
     .clkout          (clkout[2] ),
     .clkin           (clkin[2] ) );
bw_clk_zgclk_zinv_32x x3 (
     .clkout          (clkout[3] ),
     .clkin           (clkin[3] ) );
bw_clk_zgclk_zinv_32x x4 (
     .clkout          (clkout[4] ),
     .clkin           (clkin[4] ) );
bw_clk_zgclk_zinv_32x x5 (
     .clkout          (clkout[5] ),
     .clkin           (clkin[5] ) );
bw_clk_zgclk_zinv_32x x6 (
     .clkout          (clkout[6] ),
     .clkin           (clkin[6] ) );
bw_clk_zgclk_zinv_32x x7 (
     .clkout          (clkout[7] ),
     .clkin           (clkin[7] ) );
bw_clk_zgclk_zinv_32x x8 (
     .clkout          (clkout[8] ),
     .clkin           (clkin[8] ) );
bw_clk_zgclk_zinv_32x x9 (
     .clkout          (clkout[9] ),
     .clkin           (clkin[9] ) );
bw_clk_zgclk_zinv_32x x0 (
     .clkout          (clkout[0] ),
     .clkin           (clkin[0] ) );
bw_clk_zgclk_zinv_32x x1 (
     .clkout          (clkout[1] ),
     .clkin           (clkin[1] ) );
endmodule

module bw_clk_gclk_inv_256x(clkout ,clkin );
output		clkout ;
input		clkin ;
supply1		vdd ;
supply0		vss ;
 
bw_clk_zgclk_inv_320x x0 (
     .clkin           ({vss ,vss ,{8 {clkin }} } ),
     .clkout          ({vdd ,vdd ,{8 {clkout }} } ) );

endmodule

module bw_clk_zcclk_zinv_16x(clkout ,clkin );
output		clkout ;
input		clkin ;
supply1		vdd ;
supply0		vss ;
 
 
 
pmos p3 (clkout ,clkin ,vdd  );
nmos ns0 (vdd ,vss ,vss  );
nmos ns1 (vdd ,vss ,vss  );
pmos ps0 (vdd ,vss ,vdd  );
pmos ps1 (vdd ,vss ,vdd  );
nmos n0 (clkout ,clkin ,vss  );
nmos n1 (clkout ,clkin ,vss  );
nmos n2 (clkout ,clkin ,vss  );
nmos n3 (clkout ,clkin ,vss  );
pmos p0 (clkout ,clkin ,vdd  );
pmos p1 (clkout ,clkin ,vdd  );
pmos p2 (clkout ,clkin ,vdd  );
endmodule

module bw_clk_zcclk_inv_128x(clkout ,clkin );
output [7:0]	clkout ;
input [7:0]	clkin ;
 
 
 
bw_clk_zcclk_zinv_16x x2 (
     .clkout          (clkout[2] ),
     .clkin           (clkin[2] ) );
bw_clk_zcclk_zinv_16x x3 (
     .clkout          (clkout[3] ),
     .clkin           (clkin[3] ) );
bw_clk_zcclk_zinv_16x x4 (
     .clkout          (clkout[4] ),
     .clkin           (clkin[4] ) );
bw_clk_zcclk_zinv_16x x5 (
     .clkout          (clkout[5] ),
     .clkin           (clkin[5] ) );
bw_clk_zcclk_zinv_16x x6 (
     .clkout          (clkout[6] ),
     .clkin           (clkin[6] ) );
bw_clk_zcclk_zinv_16x x7 (
     .clkout          (clkout[7] ),
     .clkin           (clkin[7] ) );
bw_clk_zcclk_zinv_16x x0 (
     .clkout          (clkout[0] ),
     .clkin           (clkin[0] ) );
bw_clk_zcclk_zinv_16x x1 (
     .clkout          (clkout[1] ),
     .clkin           (clkin[1] ) );
endmodule

module bw_clk_cclk_inv_64x(clkout ,clkin );
output		clkout ;
input		clkin ;
supply1		vdd ;
supply0		vss ;
 
 
 
bw_clk_zcclk_inv_128x x0 (
     .clkout          ({vdd ,vdd ,vdd ,vdd ,{4 {clkout }} } ),
     .clkin           ({vss ,vss ,vss ,vss ,{4 {clkin }} } ) );
endmodule
module bw_ctu_muxi21_16x(s ,d1 ,d0 ,z );
output		z ;
input		s ;
input		d1 ;
input		d0 ;
supply1		vdd ;
supply0		vss ;
 
wire		s_l ;
wire		net44 ;
wire		net48 ;
wire		net58 ;
wire		net67 ;
 
 
nmos MNS (s_l ,s ,vss  );
pmos I11 (net44 ,d0 ,vdd  );
nmos I12 (net58 ,d0 ,vss  );
pmos I15 (net48 ,d1 ,vdd  );
pmos I16 (z ,s_l ,net48  );
nmos I17 (net67 ,d1 ,vss  );
nmos I18 (z ,s ,net67  );
nmos M0 (z ,s_l ,net58  );
pmos M1 (z ,s ,net44  );
pmos MPS (s_l ,s ,vdd  );
endmodule
*/

module bw_ctu_clk_sync_mux_1path(pll_clk_out_l ,muxin0 ,mux_out_l ,in1 ,
     selg ,in0 ,pll_clk_out ,clk_out );
output		mux_out_l ;
output		clk_out ;
input		pll_clk_out_l ;
input		muxin0 ;
input		in1 ;
input		selg ;
input		in0 ;
input		pll_clk_out ;
//supply0	vss ;
 
wire		fout0_l ;
wire		fout1_l ;
wire		gclk_mux_l ;
wire		net22 ;
wire		net28 ;
wire		clk_out_l ;
wire		gclk_mux ;
wire		gclk ;

// synopsys translate_off
assign gclk_mux = ~(fout1_l & fout0_l);
assign gclk_mux_l = ~gclk_mux;
assign mux_out_l = ~gclk_mux;
assign clk_out = ~clk_out_l;
assign clk_out_l = ~gclk;

bw_u1_soffi_4x xf0 (
     .q_l             (fout0_l ),
     .so              (),
     .ck              (pll_clk_out ),
     .d               (in0 ),
     .se              (1'b0),
     .sd              () );

bw_u1_soffi_4x xf1 (
     .q_l             (fout1_l ),
     .so              (),
     .ck              (pll_clk_out_l ),
     .d               (in1 ),
     .se              (1'b0),
     .sd              () );

bw_u1_muxi21_4x xmux (
     .s               (selg ),
     .d1              (gclk_mux_l ),
     .d0              (muxin0 ),
     .z               (gclk ) );

// synopsys translate_on
 
/*
 
snand2 xnd2 (
     .Y               (gclk_mux ),
     .B               (fout1_l ),
     .A               (fout0_l ) );

sinv xi1 (
     .Y               (gclk_mux_l ),
     .A               (gclk_mux ) );
sinv ximo (
     .Y               (mux_out_l ),
     .A               (gclk_mux ) );


bw_ctu_muxi21_16x xmux (
     .s               (selg ),
     .d1              (gclk_mux_l ),
     .d0              (muxin0 ),
     .z               (gclk ) );
bw_clk_gclk_inv_256x xcb256 (
     .clkout          (clk_out ),
     .clkin           (clk_out_l ) );

bw_u1_soffi_4x xf0 (
     .q_l             (fout0_l ),
     .so              (net22 ),
     .ck              (pll_clk_out ),
     .d               (in0 ),
     .se              (vss ),
     .sd              (vss ) );
bw_u1_soffi_4x xf1 (
     .q_l             (fout1_l ),
     .so              (net28 ),
     .ck              (pll_clk_out_l ),
     .d               (in1 ),
     .se              (vss ),
     .sd              (vss ) );
bw_clk_cclk_inv_64x xcb64 (
     .clkout          (clk_out_l ),
     .clkin           (gclk ) );

*/
endmodule

module bw_ctu_clk_sync_mux(jbus_div0 ,jbus_clk_mux_0 ,tcu_sel_jbus ,
     jbus_div1 ,dram_clk_mux_0 ,dram_div0 ,dram_div1 ,tcu_sel_dram ,
     tcu_sel_cpu ,pll_clk_out ,cmp_div1 ,cmp_div0 ,cmp_clk_mux_0 ,
     cmp_gclk_byp ,dram_gclk_byp ,jbus_gclk_byp ,pll_clk_out_l ,
     cmp_gclk_out ,dram_gclk_out ,jbus_gclk_out ,jbus_gclk_dup_byp ,
     jbus_gclk_dup_out ,jbus_gclk_dupl_mux_0 ,jbus_dup_div0 ,
     jbus_dup_div1 ,tcu_sel_jbus_dup );
input [0:0]	tcu_sel_jbus ;
input [0:0]	tcu_sel_dram ;
input [0:0]	tcu_sel_cpu ;
input [0:0]	tcu_sel_jbus_dup ;
output		cmp_gclk_byp ;
output		dram_gclk_byp ;
output		jbus_gclk_byp ;
output		cmp_gclk_out ;
output		dram_gclk_out ;
output		jbus_gclk_out ;
output		jbus_gclk_dup_byp ;
output		jbus_gclk_dup_out ;
input		jbus_div0 ;
input		jbus_clk_mux_0 ;
input		jbus_div1 ;
input		dram_clk_mux_0 ;
input		dram_div0 ;
input		dram_div1 ;
input		pll_clk_out ;
input		cmp_div1 ;
input		cmp_div0 ;
input		cmp_clk_mux_0 ;
input		pll_clk_out_l ;
input		jbus_gclk_dupl_mux_0 ;
input		jbus_dup_div0 ;
input		jbus_dup_div1 ;
 
 
// This is the verilog code  for synthesis 
// synopsys translate_off
 
bw_ctu_clk_sync_mux_1path x2 (
     .pll_clk_out_l   (pll_clk_out_l ),
     .muxin0          (jbus_gclk_dupl_mux_0 ),
     .mux_out_l       (jbus_gclk_dup_byp ),
     .in1             (jbus_dup_div1 ),
     .selg            (tcu_sel_jbus_dup[0] ),
     .in0             (jbus_dup_div0 ),
     .pll_clk_out     (pll_clk_out ),
     .clk_out         (jbus_gclk_dup_out ) );
bw_ctu_clk_sync_mux_1path xcsm1 (
     .pll_clk_out_l   (pll_clk_out_l ),
     .muxin0          (cmp_clk_mux_0 ),
     .mux_out_l       (cmp_gclk_byp ),
     .in1             (cmp_div1 ),
     .selg            (tcu_sel_cpu[0] ),
     .in0             (cmp_div0 ),
     .pll_clk_out     (pll_clk_out ),
     .clk_out         (cmp_gclk_out ) );
bw_ctu_clk_sync_mux_1path x0 (
     .pll_clk_out_l   (pll_clk_out_l ),
     .muxin0          (dram_clk_mux_0 ),
     .mux_out_l       (dram_gclk_byp ),
     .in1             (dram_div1 ),
     .selg            (tcu_sel_dram[0] ),
     .in0             (dram_div0 ),
     .pll_clk_out     (pll_clk_out ),
     .clk_out         (dram_gclk_out ) );
bw_ctu_clk_sync_mux_1path x1 (
     .pll_clk_out_l   (pll_clk_out_l ),
     .muxin0          (jbus_clk_mux_0 ),
     .mux_out_l       (jbus_gclk_byp ),
     .in1             (jbus_div1 ),
     .selg            (tcu_sel_jbus[0] ),
     .in0             (jbus_div0 ),
     .pll_clk_out     (pll_clk_out ),
     .clk_out         (jbus_gclk_out ) );

// synopsys translate_on
endmodule

