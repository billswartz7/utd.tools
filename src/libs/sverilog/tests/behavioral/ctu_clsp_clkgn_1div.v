// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ctu_clsp_clkgn_1div.v
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

`define CTU_PATH cmp_top.iop.ctu

module ctu_clsp_clkgn_1div ( dom_div, align_edge, align_edge_b, so, pll_clk, 
    pll_clk_l, init_l, div_dec, stretch_l, se, si );
input  [14:0] div_dec;
input  pll_clk, pll_clk_l, init_l, stretch_l, se, si;
output dom_div, align_edge, align_edge_b, so;
    wire [19:0] scan ;
    wire joa_q_11_, joa_q_10_, joa_q_9_, joa_q_8_, joa_q_7_, joa_q_6_, 
        joa_q_5_, joa_q_4_, joa_q_2_, joa_q_1_, d0_nxt_11_, d0_nxt_7_, 
        d0_nxt_5_, d0_nxt_4_, d0_nxt_3_, d0_nxt_1_, d0_nxt_0_ ;
    wire [11:0] d1_nxt ;
    wire u_align_edge_din_tmp, joa_algn_ff_din_tmp, joa_algn_ff_q_tmp, 
        joa_clk_ff_din_tmp, init_reg_q_tmp, rst_slct_reg_din_tmp, 
        rst_slct_reg_q_tmp, init_strch_reg_din_tmp, init_strch_reg_q_tmp, 
        strch_din_tmp, strch_q_tmp, n9, n11, n12, n18, n55, n56, n58, n61, n62, 
        n63, n64, n65, n66, n67, n69, n70, n71, n72, n73, n74, n76, n77, n79, 
        n80, n81, n82, n83, n84, n86, n88, n89, n90, n93, n95, n96, n100, n101, 
        n109, n111, n112, n114, n115, n116, n118, n119, n122, n123, n124, 
        net219, net674, n125, n126, n127, n128, n129, n130, n131, n132, n133, 
        n135, n136, n137, n138, n139, n140, n141, n142, n143, n144, n145, n146;
    // ECO 
    wire strch_rst_wdelay;
    wire rst_slct_reg_q_tmp_inv;
    bw_u1_inv_5x u_rst_slct_reg_q_tmp_inv_eco ( .a(rst_slct_reg_q_tmp), .z(rst_slct_reg_q_tmp_inv) );
    bw_u1_nand2_4x u_strch_rst_wdelay_eco ( .a(n58), .b(rst_slct_reg_q_tmp_inv), .z(strch_rst_wdelay) );

    bw_u1_soff_8x rst_slct_reg_u_dff_0_ ( .ck(pll_clk), .d(
        rst_slct_reg_din_tmp), .sd(scan[16]), .se(se), .q(rst_slct_reg_q_tmp), 
        .so(scan[17]) );
    bw_u1_soff_8x init_reg_u_dff_0_ ( .ck(pll_clk), .d(init_l), .sd(scan[15]), 
        .se(se), .q(init_reg_q_tmp), .so(scan[16]) );
    bw_u1_soffm2_8x joa_ff_u_dffmx_9_ ( .ck(pll_clk), .d0(net674), .d1(d1_nxt
        [9]), .s(rst_slct_reg_q_tmp), .sd(scan[12]), .se(se), .q(joa_q_9_), 
        .so(scan[13]) );
    bw_u1_soffm2_8x joa_ff_u_dffmx_1_ ( .ck(pll_clk), .d0(d0_nxt_1_), .d1(
        d1_nxt[1]), .s(rst_slct_reg_q_tmp), .sd(scan[4]), .se(se), .q(joa_q_1_
        ), .so(scan[5]) );
    bw_u1_soffm2_8x joa_ff_u_dffmx_0_ ( .ck(pll_clk), .d0(d0_nxt_0_), .d1(
        d1_nxt[0]), .s(rst_slct_reg_q_tmp), .sd(scan[3]), .se(se), .q(
        joa_clk_ff_din_tmp), .so(scan[4]) );
    bw_u1_soffm2_4x joa_ff_u_dffmx_5_ ( .ck(pll_clk), .d0(d0_nxt_5_), .d1(
        d1_nxt[5]), .s(rst_slct_reg_q_tmp), .sd(scan[8]), .se(se), .q(joa_q_5_
        ), .so(scan[9]) );
    bw_u1_soffm2_4x joa_ff_u_dffmx_6_ ( .ck(pll_clk), .d0(joa_q_7_), .d1(
        d1_nxt[6]), .s(rst_slct_reg_q_tmp), .sd(scan[9]), .se(se), .q(joa_q_6_
        ), .so(scan[10]) );
    bw_u1_soffm2_4x joa_ff_u_dffmx_7_ ( .ck(pll_clk), .d0(d0_nxt_7_), .d1(
        d1_nxt[7]), .s(rst_slct_reg_q_tmp), .sd(scan[10]), .se(se), .q(
        joa_q_7_), .so(scan[11]) );
    bw_u1_soffr_2x joa_clk_ff_u_dffrl_0_ ( .ck(pll_clk), .d(n56), .r_l(n12), 
        .sd(scan[0]), .se(se), .q(dom_div), .so(scan[1]) );
    bw_u1_nand2_4x U96 ( .a(init_l), .b(stretch_l), .z(n93) );
    bw_u1_nand2_5x U97 ( .a(n11), .b(n64), .z(d1_nxt[5]) );
    bw_u1_buf_30x U98 ( .a(strch_q_tmp), .z(n112) );
    bw_u1_nand2_4x U99 ( .a(n11), .b(n65), .z(d1_nxt[6]) );
    bw_u1_nand2_4x U100 ( .a(joa_q_6_), .b(n112), .z(n65) );
    bw_u1_nand2_4x U102 ( .a(n11), .b(n66), .z(d1_nxt[7]) );
    bw_u1_nand2_4x U103 ( .a(joa_q_7_), .b(n112), .z(n66) );
    bw_u1_inv_5x U104 ( .a(stretch_l), .z(strch_din_tmp) );
    bw_u1_inv_5x U105 ( .a(div_dec[0]), .z(n73) );
    bw_u1_nand2_4x U111 ( .a(n12), .b(n62), .z(d1_nxt[3]) );
    bw_u1_inv_5x U112 ( .a(div_dec[14]), .z(n101) );
    bw_u1_nand2_4x U115 ( .a(n11), .b(n63), .z(d1_nxt[2]) );
    bw_u1_nand2_4x U116 ( .a(joa_q_2_), .b(n111), .z(n63) );
    bw_u1_inv_5x U120 ( .a(joa_q_2_), .z(n89) );
    bw_u1_inv_5x U122 ( .a(joa_q_5_), .z(n72) );
    bw_u1_inv_5x U123 ( .a(joa_q_6_), .z(n95) );
    bw_u1_inv_5x U124 ( .a(joa_q_7_), .z(n71) );
    bw_u1_buf_30x U125 ( .a(strch_q_tmp), .z(n111) );
    bw_u1_soffr_4x joa_algn_ff_u_dffrl_0_ ( .ck(pll_clk), .d(
        joa_algn_ff_din_tmp), .r_l(n11), .sd(scan[1]), .se(se), .q(
        joa_algn_ff_q_tmp), .so(scan[2]) );
    bw_u1_nand2_4x U130 ( .a(n76), .b(n77), .z(d0_nxt_11_) );
    bw_u1_inv_5x U132 ( .a(n56), .z(n55) );
    bw_u1_nand2_4x U135 ( .a(n73), .b(n55), .z(joa_algn_ff_din_tmp) );
    bw_u1_soffm2_4x joa_ff_u_dffmx_2_ ( .ck(pll_clk), .d0(n109), .d1(d1_nxt[2]
        ), .s(rst_slct_reg_q_tmp), .sd(scan[5]), .se(se), .q(joa_q_2_), .so(
        scan[6]) );
    bw_u1_inv_8x U146 ( .a(n100), .z(d1_nxt[0]) );
    bw_u1_soffm2_4x joa_ff_u_dffmx_11_ ( .ck(pll_clk), .d0(d0_nxt_11_), .d1(
        d1_nxt[11]), .s(n9), .sd(scan[14]), .se(se), .q(joa_q_11_), .so(scan
        [15]) );
    bw_u1_soffm2_4x joa_ff_u_dffmx_3_ ( .ck(pll_clk), .d0(d0_nxt_3_), .d1(
        d1_nxt[3]), .s(n9), .sd(scan[6]), .se(se), .q(n18), .so(scan[7]) );
    bw_u1_soffr_8x strch_u_dffrl_0_ ( .ck(pll_clk), .d(strch_din_tmp), .r_l(
        n12), .sd(si), .se(se), .q(strch_q_tmp), .so(scan[0]) );
    bw_u1_soff_2x init_strch_reg_u_dff_0_ ( .ck(pll_clk), .d(
        init_strch_reg_din_tmp), .sd(scan[17]), .se(se), .q(
        init_strch_reg_q_tmp), .so(scan[18]) );
    bw_u1_inv_5x U183 ( .a(div_dec[2]), .z(n127) );
    bw_u1_nand2_4x U187 ( .a(n12), .b(n79), .z(d1_nxt[4]) );
    bw_u1_nand2_4x U189 ( .a(n12), .b(n69), .z(d1_nxt[10]) );
    bw_u1_buf_30x U190 ( .a(init_reg_q_tmp), .z(n12) );
    bw_u1_nand2_4x U192 ( .a(n12), .b(n67), .z(d1_nxt[8]) );
    bw_u1_nand2_4x U193 ( .a(n130), .b(n111), .z(n67) );
    bw_u1_inv_5x U195 ( .a(n93), .z(init_strch_reg_din_tmp) );
    bw_u1_buf_30x U196 ( .a(init_reg_q_tmp), .z(n11) );
    bw_u1_nand2_7x U197 ( .a(joa_q_5_), .b(n112), .z(n64) );
    bw_u1_muxi21_2x U198 ( .s(div_dec[12]), .d0(n95), .d1(n71), .z(d0_nxt_5_)
         );
    bw_u1_nand2_4x U199 ( .a(n11), .b(n125), .z(d1_nxt[9]) );
    bw_u1_nand2_15x U217 ( .a(n96), .b(n74), .z(n76) );
    bw_u1_inv_8x U218 ( .a(joa_q_1_), .z(n135) );
    bw_u1_nand2_4x U219 ( .a(n11), .b(n133), .z(d1_nxt[1]) );
    bw_u1_soffm2_8x joa_ff_u_dffmx_4_ ( .ck(pll_clk), .d0(d0_nxt_4_), .d1(
        //d1_nxt[4]), .s(rst_slct_reg_q_tmp), .sd(scan[7]), .se(se), .q(joa_q_4_
        d1_nxt[4]), .s(strch_rst_wdelay), .sd(scan[7]), .se(se), .q(joa_q_4_
        ), .so(scan[8]) );
    bw_u1_soffr_4x u_align_edge_u_dffrl_0_ ( .ck(pll_clk), .d(
        u_align_edge_din_tmp), .r_l(n11), .sd(scan[2]), .se(se), .q(align_edge
        ), .so(scan[3]) );
    bw_u1_soffm2_8x joa_ff_u_dffmx_10_ ( .ck(pll_clk), .d0(n131), .d1(d1_nxt
        [10]), .s(rst_slct_reg_q_tmp), .sd(scan[13]), .se(se), .q(joa_q_10_), 
        .so(scan[14]) );
    bw_u1_nand2_4x U220 ( .a(n111), .b(joa_q_9_), .z(n125) );
    bw_u1_inv_8x U221 ( .a(joa_q_9_), .z(n128) );
    bw_u1_soffm2_8x joa_ff_u_dffmx_8_ ( .ck(pll_clk), .d0(joa_q_9_), .d1(
        d1_nxt[8]), .s(rst_slct_reg_q_tmp), .sd(scan[11]), .se(se), .q(
        joa_q_8_), .so(scan[12]) );
    bw_u1_nand3_5x U222 ( .a(n111), .b(n56), .c(n12), .z(n100) );
    bw_u1_buf_30x U223 ( .a(joa_clk_ff_din_tmp), .z(n56) );
    bw_u1_inv_5x U224 ( .a(n96), .z(n129) );
    bw_u1_inv_15x U225 ( .a(joa_q_1_), .z(n96) );
    bw_u1_nand2_4x U131 ( .a(init_strch_reg_din_tmp), .b(n132), .z(
        rst_slct_reg_din_tmp) );
    bw_u1_muxi21_2x U149 ( .s(div_dec[0]), .d0(n96), .d1(n136), .z(d0_nxt_0_)
         );
    bw_u1_nand2_4x U136 ( .a(n101), .b(n74), .z(n77) );
    bw_u1_nand2_4x U227 ( .a(n129), .b(n111), .z(n133) );
    bw_u1_inv_8x U228 ( .a(joa_clk_ff_din_tmp), .z(n74) );
    bw_u1_inv_5x U229 ( .a(n74), .z(n136) );
    bw_u1_nand2_5x U230 ( .a(n58), .b(init_strch_reg_q_tmp), .z(n9) );
    bw_u1_nor2_8x U231 ( .a(n90), .b(n145), .z(n142) );
    bw_u1_inv_5x U232 ( .a(div_dec[3]), .z(n145) );
    bw_u1_invh_15x U233 ( .a(joa_q_10_), .z(n90) );
    bw_u1_nand2_5x U234 ( .a(n137), .b(n139), .z(n138) );
    bw_u1_inv_5x U235 ( .a(div_dec[0]), .z(n139) );
    bw_u1_oai21_4x U236 ( .a(n138), .b1(n142), .b2(n137), .z(n122) );
    bw_u1_nand3_5x U151 ( .a(n61), .b(n140), .c(n122), .z(u_align_edge_din_tmp
        ) );
    bw_u1_inv_5x U237 ( .a(joa_q_11_), .z(n137) );
    bw_u1_inv_5x U238 ( .a(n137), .z(n141) );
    bw_u1_nand2_4x U114 ( .a(n112), .b(n141), .z(n146) );
    bw_u1_buf_30x U239 ( .a(joa_q_11_), .z(net219) );
    bw_u1_aoi31_8x U240 ( .a(n143), .b1(n116), .b2(net219), .b3(n90), .z(n140)
         );
    bw_u1_invh_15x U214 ( .a(net219), .z(n70) );
    bw_u1_oai21_4x U145 ( .a(div_dec[1]), .b1(n83), .b2(n80), .z(n61) );
    bw_u1_nor3_3x U185 ( .a(n84), .b(n115), .c(joa_q_8_), .z(n83) );
    bw_u1_inv_5x U126 ( .a(joa_algn_ff_q_tmp), .z(n84) );
    bw_u1_nor2_2x U181 ( .a(div_dec[7]), .b(div_dec[8]), .z(n115) );
    bw_u1_inv_5x U182 ( .a(n115), .z(n86) );
    bw_u1_muxi41d_6x U201 ( .s0(div_dec[7]), .d0(n56), .s1(div_dec[6]), .d1(
        n70), .s2(div_dec[8]), .d2(n76), .s3(div_dec[5]), .d3(n81), .z(
        d0_nxt_3_) );
    bw_u1_inv_5x U202 ( .a(joa_q_8_), .z(n123) );
    bw_u1_muxi21_2x U241 ( .s(div_dec[13]), .d0(n123), .d1(n70), .z(d0_nxt_7_)
         );
    bw_u1_inv_5x U194 ( .a(n123), .z(n130) );
    bw_u1_nor3_3x U128 ( .a(n81), .b(n82), .c(n18), .z(n80) );
    bw_u1_inv_5x U109 ( .a(joa_q_4_), .z(n81) );
    bw_u1_buf_10x U203 ( .a(joa_q_4_), .z(n124) );
    bw_u1_nand2_4x U188 ( .a(n111), .b(n124), .z(n79) );
    bw_u1_inv_5x U140 ( .a(div_dec[5]), .z(n82) );
    bw_u1_buf_10x U119 ( .a(n18), .z(n109) );
    bw_u1_inv_8x U204 ( .a(n109), .z(n88) );
    bw_u1_nand2_4x U143 ( .a(n109), .b(n112), .z(n62) );
    bw_u1_muxi41d_4x U205 ( .s0(div_dec[4]), .d0(n76), .s1(div_dec[2]), .d1(
        n88), .s2(div_dec[1]), .d2(n89), .s3(div_dec[3]), .d3(n56), .z(
        d0_nxt_1_) );
    bw_u1_oai21_8x U215 ( .a(n114), .b1(div_dec[0]), .b2(n118), .z(n116) );
    bw_u1_inv_5x U184 ( .a(div_dec[6]), .z(n118) );
    bw_u1_inv_5x U200 ( .a(div_dec[4]), .z(n114) );
    bw_u1_nor3_1p4x U180 ( .a(div_dec[0]), .b(div_dec[3]), .c(div_dec[4]), .z(
        n144) );
    bw_u1_nand3_3x U150 ( .a(n144), .b(n96), .c(n56), .z(n132) );
    bw_u1_nor2_2x U186 ( .a(div_dec[4]), .b(div_dec[0]), .z(n126) );
    bw_u1_nand4_4x U211 ( .a(n135), .b(joa_clk_ff_din_tmp), .c(n126), .d(n119), 
        .z(n58) );
    bw_u1_inv_8x U226 ( .a(n70), .z(n131) );
    bw_u1_muxi31d_4x U216 ( .s0(div_dec[11]), .d0(n70), .s1(div_dec[10]), .d1(
        n71), .s2(div_dec[9]), .d2(n72), .z(d0_nxt_4_) );
    bw_u1_inv_8x U208 ( .a(n90), .z(net674) );
    bw_u1_nand2_4x U191 ( .a(n112), .b(net674), .z(n69) );
    bw_u1_nor3_3x U209 ( .a(n128), .b(joa_q_10_), .c(n127), .z(n143) );
    bw_u1_inv_40x U210 ( .a(div_dec[3]), .z(n119) );
    bw_u1_nand2_4x U113 ( .a(n146), .b(n12), .z(d1_nxt[11]) );
    bw_zzctu_sync al_sync ( .d(u_align_edge_din_tmp), .out(align_edge_b), 
        .pll_out(pll_clk), .pll_out_l(pll_clk_l), .se(se), .si(scan[19]), 
        .sib(scan[18]), .so(so), .sob(scan[19]) );

    //synopsys translate_off
       always @ ( /*AUTOSENSE*/div_dec or se or `CTU_PATH.io_pwron_rst_l) 
       begin
            // getting out of bypass mode directly going into freq change 
            #1;
           // U216
           if(  (`CTU_PATH.io_pwron_rst_l === 1'b1) &
               (({div_dec[9],div_dec[10],div_dec[11]} !== 3'b000) &
                ({div_dec[9],div_dec[10],div_dec[11]}  !== 3'b100) &
                ({div_dec[9],div_dec[10],div_dec[11]}  !== 3'b010) &
                ({div_dec[9],div_dec[10],div_dec[11]}  !== 3'b001))
             )
    `ifdef MODELSIM
	       $display ( "CTU_not_one_hot_error", 
                    "Select signals to data path mux U216 are not one hot: %h",
                     {div_dec[9],div_dec[10],div_dec[11]} );	
	`else
	       $error ( "CTU_not_one_hot_error", 
                    "Select signals to data path mux U216 are not one hot: %h",
                     {div_dec[9],div_dec[10],div_dec[11]} );
	`endif
           // U205
           if(  (`CTU_PATH.io_pwron_rst_l === 1'b1) &
               (({div_dec[4],div_dec[2],div_dec[1],div_dec[3]} !== 4'b0000) &
                ({div_dec[4],div_dec[2],div_dec[1],div_dec[3]}  !== 4'b1000) &
                ({div_dec[4],div_dec[2],div_dec[1],div_dec[3]}  !== 4'b0100) &
                ({div_dec[4],div_dec[2],div_dec[1],div_dec[3]}  !== 4'b0010) &
                ({div_dec[4],div_dec[2],div_dec[1],div_dec[3]}  !== 4'b0001))
             )
	`ifdef MODELSIM
           $display ( "CTU_not_one_hot_error",
                    "Select signals to data path mux U205 are not one hot: %h",
                    {div_dec[4],div_dec[2],div_dec[1],div_dec[3]} );
	`else
           $error ( "CTU_not_one_hot_error",
                    "Select signals to data path mux U205 are not one hot: %h",
                    {div_dec[4],div_dec[2],div_dec[1],div_dec[3]} );
	`endif
           // U201
           if(  (`CTU_PATH.io_pwron_rst_l === 1'b1) &
              (( {div_dec[7],div_dec[6],div_dec[8],div_dec[5]} !== 4'b0000) &
                ({div_dec[7],div_dec[6],div_dec[8],div_dec[5]} !== 4'b1000) &
                ({div_dec[7],div_dec[6],div_dec[8],div_dec[5]} !== 4'b0100) &
                ({div_dec[7],div_dec[6],div_dec[8],div_dec[5]} !== 4'b0010) &
                ({div_dec[7],div_dec[6],div_dec[8],div_dec[5]} !== 4'b0001))
             )
	`ifdef MODELSIM
           $display (  "CTU_not_one_hot_error",
                     "Select signals to data path mux U201 are not one hot: %h",
                      {div_dec[7],div_dec[6],div_dec[8],div_dec[5]} );
	`else
           $error (  "CTU_not_one_hot_error",
                     "Select signals to data path mux U201 are not one hot: %h",
                      {div_dec[7],div_dec[6],div_dec[8],div_dec[5]} );
	`endif
      end
    //synopsys translate_on
endmodule

