// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_ddr_sig_top.v
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
module bw_io_ddr_sig_top(spare_ddr_data ,vrefcode_i_l ,vrefcode_i_r ,afo
      ,mode_ctrl_out ,update_dr_out ,shift_dr_out ,clock_dr_out ,
     hiz_n_out ,bypass_enable_out ,ps_select_out ,serial_in ,serial_out
      ,afi ,test_mode_i_r ,strobe_i_r ,lpf_code_i_r ,testmode_l_i_l ,
     burst_length_four_i_r ,dram_io_ptr_clk_inv_i_r ,
     dram_io_pad_enable_i_r ,dram_io_drive_enable_i_r ,rst_l_i_r , arst_l_i_r,
     pad_pos_cnt_i_r ,pad_neg_cnt_i_r ,dram_io_channel_disabled_i_r ,
     dram_io_drive_data_i_r ,cbu_i_r ,cbd_i_r ,se_i_r ,mode_ctrl_i_r ,
     shift_dr_i_r ,clock_dr_i_r ,hiz_n_i_r ,update_dr_i_r ,vdd_h ,
     strobe_i_l ,bypass_enable_i_l ,ps_select_i_r ,ps_select_i_l ,
     test_mode_i_l ,testmode_l_i_r ,lpf_code_i_l ,dram_io_pad_enable_i_l
      ,dram_io_ptr_clk_inv_i_l ,burst_length_four_i_l ,
     \dram_io_data_out[95] ,\dram_io_data_out[94] ,\dram_io_data_out[93]
      ,\dram_io_data_out[92] ,\dram_io_data_out[91] ,
     \dram_io_data_out[90] ,\dram_io_data_out[89] ,\dram_io_data_out[88]
      ,\dram_io_data_out[87] ,\dram_io_data_out[86] ,
     \dram_io_data_out[85] ,\dram_io_data_out[84] ,\dram_io_data_out[83]
      ,\dram_io_data_out[82] ,\dram_io_data_out[81] ,
     \dram_io_data_out[80] ,\dram_io_data_out[79] ,\dram_io_data_out[78]
      ,\dram_io_data_out[77] ,\dram_io_data_out[76] ,
     \dram_io_data_out[75] ,\dram_io_data_out[74] ,\dram_io_data_out[73]
      ,\dram_io_data_out[72] ,\dram_io_data_out[71] ,
     \dram_io_data_out[70] ,\dram_io_data_out[69] ,\dram_io_data_out[68]
      ,\dram_io_data_out[67] ,\dram_io_data_out[66] ,
     \dram_io_data_out[65] ,\dram_io_data_out[64] ,\dram_io_data_out[31]
      ,\dram_io_data_out[30] ,\dram_io_data_out[29] ,
     \dram_io_data_out[28] ,\dram_io_data_out[27] ,\dram_io_data_out[26]
      ,\dram_io_data_out[25] ,\dram_io_data_out[24] ,
     \dram_io_data_out[23] ,\dram_io_data_out[22] ,\dram_io_data_out[21]
      ,\dram_io_data_out[20] ,\dram_io_data_out[19] ,
     \dram_io_data_out[18] ,\dram_io_data_out[17] ,\dram_io_data_out[16]
      ,\dram_io_data_out[15] ,\dram_io_data_out[14] ,
     \dram_io_data_out[13] ,\dram_io_data_out[12] ,\dram_io_data_out[11]
      ,\dram_io_data_out[10] ,\dram_io_data_out[9] ,\dram_io_data_out[8]
      ,\dram_io_data_out[7] ,\dram_io_data_out[6] ,\dram_io_data_out[5]
      ,\dram_io_data_out[4] ,\dram_io_data_out[3] ,\dram_io_data_out[2]
      ,\dram_io_data_out[1] ,\dram_io_data_out[0] ,
     dram_io_channel_disabled_i_l ,cbd_i_l ,dram_io_drive_enable_i_l ,
     rclk ,\dram_io_data_out[175] ,\dram_io_data_out[174] ,
     \dram_io_data_out[173] ,\dram_io_data_out[172] ,
     \dram_io_data_out[171] ,\dram_io_data_out[170] ,
     \dram_io_data_out[169] ,\dram_io_data_out[168] ,
     \dram_io_data_out[167] ,\dram_io_data_out[166] ,
     \dram_io_data_out[165] ,\dram_io_data_out[164] ,
     \dram_io_data_out[163] ,\dram_io_data_out[162] ,
     \dram_io_data_out[161] ,\dram_io_data_out[160] ,
     \dram_io_data_out[159] ,\dram_io_data_out[158] ,
     \dram_io_data_out[157] ,\dram_io_data_out[156] ,
     \dram_io_data_out[155] ,\dram_io_data_out[154] ,
     \dram_io_data_out[153] ,\dram_io_data_out[152] ,
     \dram_io_data_out[151] ,\dram_io_data_out[150] ,
     \dram_io_data_out[149] ,\dram_io_data_out[148] ,
     \dram_io_data_out[147] ,\dram_io_data_out[146] ,
     \dram_io_data_out[145] ,\dram_io_data_out[144] ,
     \dram_io_data_out[279] ,\dram_io_data_out[278] ,
     \dram_io_data_out[277] ,\dram_io_data_out[276] ,
     \dram_io_data_out[275] ,\dram_io_data_out[274] ,
     \dram_io_data_out[273] ,\dram_io_data_out[272] ,
     \io_dram_data_in[223] ,\io_dram_data_in[222] ,\io_dram_data_in[221]
      ,\io_dram_data_in[220] ,\io_dram_data_in[219] ,
     \io_dram_data_in[218] ,\io_dram_data_in[217] ,\io_dram_data_in[216]
      ,\io_dram_data_in[215] ,\io_dram_data_in[214] ,
     \io_dram_data_in[213] ,\io_dram_data_in[212] ,\io_dram_data_in[211]
      ,\io_dram_data_in[210] ,\io_dram_data_in[209] ,
     \io_dram_data_in[208] ,\io_dram_data_in[207] ,\io_dram_data_in[206]
      ,\io_dram_data_in[205] ,\io_dram_data_in[204] ,
     \io_dram_data_in[203] ,\io_dram_data_in[202] ,\io_dram_data_in[201]
      ,\io_dram_data_in[200] ,\io_dram_data_in[199] ,
     \io_dram_data_in[198] ,\io_dram_data_in[197] ,\io_dram_data_in[196]
      ,\io_dram_data_in[195] ,\io_dram_data_in[194] ,
     \io_dram_data_in[193] ,\io_dram_data_in[192] ,
     \dram_io_data_out[135] ,\dram_io_data_out[134] ,
     \dram_io_data_out[133] ,\dram_io_data_out[132] ,
     \dram_io_data_out[131] ,\dram_io_data_out[130] ,
     \dram_io_data_out[129] ,\dram_io_data_out[128] ,\io_dram_ecc_in[23]
      ,\io_dram_ecc_in[22] ,\io_dram_ecc_in[21] ,\io_dram_ecc_in[20] ,
     \io_dram_ecc_in[19] ,\io_dram_ecc_in[18] ,\io_dram_ecc_in[17] ,
     \io_dram_ecc_in[16] ,\io_dram_ecc_in[7] ,\io_dram_ecc_in[6] ,
     \io_dram_ecc_in[5] ,\io_dram_ecc_in[4] ,\io_dram_ecc_in[3] ,
     \io_dram_ecc_in[2] ,\io_dram_ecc_in[1] ,\io_dram_ecc_in[0] ,
     \io_dram_data_in[159] ,\io_dram_data_in[158] ,\io_dram_data_in[157]
      ,\io_dram_data_in[156] ,\io_dram_data_in[155] ,
     \io_dram_data_in[154] ,\io_dram_data_in[153] ,\io_dram_data_in[152]
      ,\io_dram_data_in[151] ,\io_dram_data_in[150] ,
     \io_dram_data_in[149] ,\io_dram_data_in[148] ,\io_dram_data_in[147]
      ,\io_dram_data_in[146] ,\io_dram_data_in[145] ,
     \io_dram_data_in[144] ,\io_dram_data_in[143] ,\io_dram_data_in[142]
      ,\io_dram_data_in[141] ,\io_dram_data_in[140] ,
     \io_dram_data_in[139] ,\io_dram_data_in[138] ,\io_dram_data_in[137]
      ,\io_dram_data_in[136] ,\io_dram_data_in[135] ,
     \io_dram_data_in[134] ,\io_dram_data_in[133] ,\io_dram_data_in[132]
      ,\io_dram_data_in[131] ,\io_dram_data_in[130] ,
     \io_dram_data_in[129] ,\io_dram_data_in[128] ,\io_dram_data_in[31]
      ,\io_dram_data_in[30] ,\io_dram_data_in[29] ,\io_dram_data_in[28]
      ,\io_dram_data_in[27] ,\io_dram_data_in[26] ,\io_dram_data_in[25]
      ,\io_dram_data_in[24] ,\io_dram_data_in[23] ,\io_dram_data_in[22]
      ,\io_dram_data_in[21] ,\io_dram_data_in[20] ,\io_dram_data_in[19]
      ,\io_dram_data_in[18] ,\io_dram_data_in[17] ,\io_dram_data_in[16]
      ,\io_dram_data_in[15] ,\io_dram_data_in[14] ,\io_dram_data_in[13]
      ,\io_dram_data_in[12] ,\io_dram_data_in[11] ,\io_dram_data_in[10]
      ,\io_dram_data_in[9] ,\io_dram_data_in[8] ,\io_dram_data_in[7] ,
     \io_dram_data_in[6] ,\io_dram_data_in[5] ,\io_dram_data_in[4] ,
     \io_dram_data_in[3] ,\io_dram_data_in[2] ,\io_dram_data_in[1] ,
     \io_dram_data_in[0] ,pad_clk_so ,pad_clk_si ,\dram_addr[9] ,
     \dram_addr[8] ,\dram_addr[7] ,\dram_addr[6] ,\dram_addr[5] ,
     \dram_addr[4] ,\dram_addr[3] ,\dram_addr[2] ,\dram_addr[1] ,
     \dram_addr[0] ,\dram_io_addr[9] ,\dram_io_addr[8] ,\dram_io_addr[7]
      ,\dram_io_addr[6] ,\dram_io_addr[5] ,\dram_io_addr[4] ,
     \dram_io_addr[3] ,\dram_io_addr[2] ,\dram_io_addr[1] ,
     \dram_io_addr[0] ,\dram_dqs[12] ,\dram_dqs[11] ,\dram_dqs[10] ,
     \dram_dqs[9] ,\dram_dqs[8] ,bso ,spare_ddr_pin ,bsi ,
     dram_io_clk_enable ,dram_ck_n ,dram_ck_p ,dram_io_bank ,
     \dram_addr[14] ,\dram_addr[13] ,\dram_addr[12] ,\dram_addr[11] ,
     dram_cke ,dram_ba ,dram_io_cke ,\dram_io_addr[14] ,
     \dram_io_addr[13] ,\dram_io_addr[12] ,\dram_io_addr[11] ,
     \dram_dq[95] ,\dram_dq[94] ,\dram_dq[93] ,\dram_dq[92] ,
     \dram_dq[91] ,\dram_dq[90] ,\dram_dq[89] ,\dram_dq[88] ,
     \dram_dq[87] ,\dram_dq[86] ,\dram_dq[85] ,\dram_dq[84] ,
     \dram_dq[83] ,\dram_dq[82] ,\dram_dq[81] ,\dram_dq[80] ,
     \dram_dq[79] ,\dram_dq[78] ,\dram_dq[77] ,\dram_dq[76] ,
     \dram_dq[75] ,\dram_dq[74] ,\dram_dq[73] ,\dram_dq[72] ,
     \dram_dq[71] ,\dram_dq[70] ,\dram_dq[69] ,\dram_dq[68] ,
     \dram_dq[67] ,\dram_dq[66] ,\dram_dq[65] ,\dram_dq[64] ,
     \dram_dq[31] ,\dram_dq[30] ,\dram_dq[29] ,\dram_dq[28] ,
     \dram_dq[27] ,\dram_dq[26] ,\dram_dq[25] ,\dram_dq[24] ,
     \dram_dq[23] ,\dram_dq[22] ,\dram_dq[21] ,\dram_dq[20] ,
     \dram_dq[19] ,\dram_dq[18] ,\dram_dq[17] ,\dram_dq[16] ,
     \dram_dq[15] ,\dram_dq[14] ,\dram_dq[13] ,\dram_dq[12] ,
     \dram_dq[11] ,\dram_dq[10] ,\dram_dq[9] ,\dram_dq[8] ,\dram_dq[7] ,
     \dram_dq[6] ,\dram_dq[5] ,\dram_dq[4] ,\dram_dq[3] ,\dram_dq[2] ,
     \dram_dq[1] ,\dram_dq[0] ,\dram_dqs[3] ,\dram_dqs[2] ,\dram_dqs[1]
      ,\dram_dqs[0] ,\dram_dqs[21] ,\dram_dqs[20] ,\dram_dqs[19] ,
     \dram_dqs[18] ,\dram_dqs[17] ,\dram_dqs[30] ,\dram_dqs[29] ,
     \dram_dqs[28] ,\dram_dqs[27] ,pad_neg_cnt_i_l ,rst_l_i_l , arst_l_i_l,
     bypass_enable_i_r ,hiz_n_i_l ,cbu_i_l ,shift_dr_i_l ,mode_ctrl_i_l
      ,dram_cb ,dram_io_drive_data_i_l ,se_i_l ,pad_pos_cnt_i_l ,
     update_dr_i_l ,clock_dr_i_l ,\io_dram_data_in[95] ,
     \io_dram_data_in[94] ,\io_dram_data_in[93] ,\io_dram_data_in[92] ,
     \io_dram_data_in[91] ,\io_dram_data_in[90] ,\io_dram_data_in[89] ,
     \io_dram_data_in[88] ,\io_dram_data_in[87] ,\io_dram_data_in[86] ,
     \io_dram_data_in[85] ,\io_dram_data_in[84] ,\io_dram_data_in[83] ,
     \io_dram_data_in[82] ,\io_dram_data_in[81] ,\io_dram_data_in[80] ,
     \io_dram_data_in[79] ,\io_dram_data_in[78] ,\io_dram_data_in[77] ,
     \io_dram_data_in[76] ,\io_dram_data_in[75] ,\io_dram_data_in[74] ,
     \io_dram_data_in[73] ,\io_dram_data_in[72] ,\io_dram_data_in[71] ,
     \io_dram_data_in[70] ,\io_dram_data_in[69] ,\io_dram_data_in[68] ,
     \io_dram_data_in[67] ,\io_dram_data_in[66] ,\io_dram_data_in[65] ,
     \io_dram_data_in[64] ,\dram_io_data_out[239] ,
     \dram_io_data_out[238] ,\dram_io_data_out[237] ,
     \dram_io_data_out[236] ,\dram_io_data_out[235] ,
     \dram_io_data_out[234] ,\dram_io_data_out[233] ,
     \dram_io_data_out[232] ,\dram_io_data_out[231] ,
     \dram_io_data_out[230] ,\dram_io_data_out[229] ,
     \dram_io_data_out[228] ,\dram_io_data_out[227] ,
     \dram_io_data_out[226] ,\dram_io_data_out[225] ,
     \dram_io_data_out[224] ,\dram_io_data_out[223] ,
     \dram_io_data_out[222] ,\dram_io_data_out[221] ,
     \dram_io_data_out[220] ,\dram_io_data_out[219] ,
     \dram_io_data_out[218] ,\dram_io_data_out[217] ,
     \dram_io_data_out[216] ,\dram_io_data_out[215] ,
     \dram_io_data_out[214] ,\dram_io_data_out[213] ,
     \dram_io_data_out[212] ,\dram_io_data_out[211] ,
     \dram_io_data_out[210] ,\dram_io_data_out[209] ,
     \dram_io_data_out[208] );
output [71:0]	serial_out ;
output [71:0]	afi ;
input [9:8]	spare_ddr_data ;
input [7:0]	vrefcode_i_l ;
input [7:0]	vrefcode_i_r ;
input [71:0]	afo ;
input [71:0]	serial_in ;
input [4:0]	lpf_code_i_r ;
input [1:0]	dram_io_ptr_clk_inv_i_r ;
input [1:0]	pad_pos_cnt_i_r ;
input [1:0]	pad_neg_cnt_i_r ;
input [8:1]	cbu_i_r ;
input [8:1]	cbd_i_r ;
input [4:0]	lpf_code_i_l ;
input [1:0]	dram_io_ptr_clk_inv_i_l ;
input [8:1]	cbd_i_l ;
input [2:2]	dram_io_bank ;
input [1:0]	pad_neg_cnt_i_l ;
input [8:1]	cbu_i_l ;
input [1:0]	pad_pos_cnt_i_l ;
inout [9:8]	spare_ddr_pin ;
inout [3:0]	dram_ck_n ;
inout [3:0]	dram_ck_p ;
inout [2:2]	dram_ba ;
inout [7:0]	dram_cb ;
output		mode_ctrl_out ;
output		update_dr_out ;
output		shift_dr_out ;
output		clock_dr_out ;
output		hiz_n_out ;
output		bypass_enable_out ;
output		ps_select_out ;
output		\io_dram_data_in[223] ;
output		\io_dram_data_in[222] ;
output		\io_dram_data_in[221] ;
output		\io_dram_data_in[220] ;
output		\io_dram_data_in[219] ;
output		\io_dram_data_in[218] ;
output		\io_dram_data_in[217] ;
output		\io_dram_data_in[216] ;
output		\io_dram_data_in[215] ;
output		\io_dram_data_in[214] ;
output		\io_dram_data_in[213] ;
output		\io_dram_data_in[212] ;
output		\io_dram_data_in[211] ;
output		\io_dram_data_in[210] ;
output		\io_dram_data_in[209] ;
output		\io_dram_data_in[208] ;
output		\io_dram_data_in[207] ;
output		\io_dram_data_in[206] ;
output		\io_dram_data_in[205] ;
output		\io_dram_data_in[204] ;
output		\io_dram_data_in[203] ;
output		\io_dram_data_in[202] ;
output		\io_dram_data_in[201] ;
output		\io_dram_data_in[200] ;
output		\io_dram_data_in[199] ;
output		\io_dram_data_in[198] ;
output		\io_dram_data_in[197] ;
output		\io_dram_data_in[196] ;
output		\io_dram_data_in[195] ;
output		\io_dram_data_in[194] ;
output		\io_dram_data_in[193] ;
output		\io_dram_data_in[192] ;
output		\io_dram_ecc_in[23] ;
output		\io_dram_ecc_in[22] ;
output		\io_dram_ecc_in[21] ;
output		\io_dram_ecc_in[20] ;
output		\io_dram_ecc_in[19] ;
output		\io_dram_ecc_in[18] ;
output		\io_dram_ecc_in[17] ;
output		\io_dram_ecc_in[16] ;
output		\io_dram_ecc_in[7] ;
output		\io_dram_ecc_in[6] ;
output		\io_dram_ecc_in[5] ;
output		\io_dram_ecc_in[4] ;
output		\io_dram_ecc_in[3] ;
output		\io_dram_ecc_in[2] ;
output		\io_dram_ecc_in[1] ;
output		\io_dram_ecc_in[0] ;
output		\io_dram_data_in[159] ;
output		\io_dram_data_in[158] ;
output		\io_dram_data_in[157] ;
output		\io_dram_data_in[156] ;
output		\io_dram_data_in[155] ;
output		\io_dram_data_in[154] ;
output		\io_dram_data_in[153] ;
output		\io_dram_data_in[152] ;
output		\io_dram_data_in[151] ;
output		\io_dram_data_in[150] ;
output		\io_dram_data_in[149] ;
output		\io_dram_data_in[148] ;
output		\io_dram_data_in[147] ;
output		\io_dram_data_in[146] ;
output		\io_dram_data_in[145] ;
output		\io_dram_data_in[144] ;
output		\io_dram_data_in[143] ;
output		\io_dram_data_in[142] ;
output		\io_dram_data_in[141] ;
output		\io_dram_data_in[140] ;
output		\io_dram_data_in[139] ;
output		\io_dram_data_in[138] ;
output		\io_dram_data_in[137] ;
output		\io_dram_data_in[136] ;
output		\io_dram_data_in[135] ;
output		\io_dram_data_in[134] ;
output		\io_dram_data_in[133] ;
output		\io_dram_data_in[132] ;
output		\io_dram_data_in[131] ;
output		\io_dram_data_in[130] ;
output		\io_dram_data_in[129] ;
output		\io_dram_data_in[128] ;
output		\io_dram_data_in[31] ;
output		\io_dram_data_in[30] ;
output		\io_dram_data_in[29] ;
output		\io_dram_data_in[28] ;
output		\io_dram_data_in[27] ;
output		\io_dram_data_in[26] ;
output		\io_dram_data_in[25] ;
output		\io_dram_data_in[24] ;
output		\io_dram_data_in[23] ;
output		\io_dram_data_in[22] ;
output		\io_dram_data_in[21] ;
output		\io_dram_data_in[20] ;
output		\io_dram_data_in[19] ;
output		\io_dram_data_in[18] ;
output		\io_dram_data_in[17] ;
output		\io_dram_data_in[16] ;
output		\io_dram_data_in[15] ;
output		\io_dram_data_in[14] ;
output		\io_dram_data_in[13] ;
output		\io_dram_data_in[12] ;
output		\io_dram_data_in[11] ;
output		\io_dram_data_in[10] ;
output		\io_dram_data_in[9] ;
output		\io_dram_data_in[8] ;
output		\io_dram_data_in[7] ;
output		\io_dram_data_in[6] ;
output		\io_dram_data_in[5] ;
output		\io_dram_data_in[4] ;
output		\io_dram_data_in[3] ;
output		\io_dram_data_in[2] ;
output		\io_dram_data_in[1] ;
output		\io_dram_data_in[0] ;
output		pad_clk_so ;
output		bso ;
output		\io_dram_data_in[95] ;
output		\io_dram_data_in[94] ;
output		\io_dram_data_in[93] ;
output		\io_dram_data_in[92] ;
output		\io_dram_data_in[91] ;
output		\io_dram_data_in[90] ;
output		\io_dram_data_in[89] ;
output		\io_dram_data_in[88] ;
output		\io_dram_data_in[87] ;
output		\io_dram_data_in[86] ;
output		\io_dram_data_in[85] ;
output		\io_dram_data_in[84] ;
output		\io_dram_data_in[83] ;
output		\io_dram_data_in[82] ;
output		\io_dram_data_in[81] ;
output		\io_dram_data_in[80] ;
output		\io_dram_data_in[79] ;
output		\io_dram_data_in[78] ;
output		\io_dram_data_in[77] ;
output		\io_dram_data_in[76] ;
output		\io_dram_data_in[75] ;
output		\io_dram_data_in[74] ;
output		\io_dram_data_in[73] ;
output		\io_dram_data_in[72] ;
output		\io_dram_data_in[71] ;
output		\io_dram_data_in[70] ;
output		\io_dram_data_in[69] ;
output		\io_dram_data_in[68] ;
output		\io_dram_data_in[67] ;
output		\io_dram_data_in[66] ;
output		\io_dram_data_in[65] ;
output		\io_dram_data_in[64] ;
input		test_mode_i_r ;
input		strobe_i_r ;
input		testmode_l_i_l ;
input		burst_length_four_i_r ;
input		dram_io_pad_enable_i_r ;
input		dram_io_drive_enable_i_r ;
input		rst_l_i_r ;
input		arst_l_i_r ;
input		dram_io_channel_disabled_i_r ;
input		dram_io_drive_data_i_r ;
input		se_i_r ;
input		mode_ctrl_i_r ;
input		shift_dr_i_r ;
input		clock_dr_i_r ;
input		hiz_n_i_r ;
input		update_dr_i_r ;
input		vdd_h ;
input		strobe_i_l ;
input		bypass_enable_i_l ;
input		ps_select_i_r ;
input		ps_select_i_l ;
input		test_mode_i_l ;
input		testmode_l_i_r ;
input		dram_io_pad_enable_i_l ;
input		burst_length_four_i_l ;
input		\dram_io_data_out[95] ;
input		\dram_io_data_out[94] ;
input		\dram_io_data_out[93] ;
input		\dram_io_data_out[92] ;
input		\dram_io_data_out[91] ;
input		\dram_io_data_out[90] ;
input		\dram_io_data_out[89] ;
input		\dram_io_data_out[88] ;
input		\dram_io_data_out[87] ;
input		\dram_io_data_out[86] ;
input		\dram_io_data_out[85] ;
input		\dram_io_data_out[84] ;
input		\dram_io_data_out[83] ;
input		\dram_io_data_out[82] ;
input		\dram_io_data_out[81] ;
input		\dram_io_data_out[80] ;
input		\dram_io_data_out[79] ;
input		\dram_io_data_out[78] ;
input		\dram_io_data_out[77] ;
input		\dram_io_data_out[76] ;
input		\dram_io_data_out[75] ;
input		\dram_io_data_out[74] ;
input		\dram_io_data_out[73] ;
input		\dram_io_data_out[72] ;
input		\dram_io_data_out[71] ;
input		\dram_io_data_out[70] ;
input		\dram_io_data_out[69] ;
input		\dram_io_data_out[68] ;
input		\dram_io_data_out[67] ;
input		\dram_io_data_out[66] ;
input		\dram_io_data_out[65] ;
input		\dram_io_data_out[64] ;
input		\dram_io_data_out[31] ;
input		\dram_io_data_out[30] ;
input		\dram_io_data_out[29] ;
input		\dram_io_data_out[28] ;
input		\dram_io_data_out[27] ;
input		\dram_io_data_out[26] ;
input		\dram_io_data_out[25] ;
input		\dram_io_data_out[24] ;
input		\dram_io_data_out[23] ;
input		\dram_io_data_out[22] ;
input		\dram_io_data_out[21] ;
input		\dram_io_data_out[20] ;
input		\dram_io_data_out[19] ;
input		\dram_io_data_out[18] ;
input		\dram_io_data_out[17] ;
input		\dram_io_data_out[16] ;
input		\dram_io_data_out[15] ;
input		\dram_io_data_out[14] ;
input		\dram_io_data_out[13] ;
input		\dram_io_data_out[12] ;
input		\dram_io_data_out[11] ;
input		\dram_io_data_out[10] ;
input		\dram_io_data_out[9] ;
input		\dram_io_data_out[8] ;
input		\dram_io_data_out[7] ;
input		\dram_io_data_out[6] ;
input		\dram_io_data_out[5] ;
input		\dram_io_data_out[4] ;
input		\dram_io_data_out[3] ;
input		\dram_io_data_out[2] ;
input		\dram_io_data_out[1] ;
input		\dram_io_data_out[0] ;
input		dram_io_channel_disabled_i_l ;
input		dram_io_drive_enable_i_l ;
input		rclk ;
input		\dram_io_data_out[175] ;
input		\dram_io_data_out[174] ;
input		\dram_io_data_out[173] ;
input		\dram_io_data_out[172] ;
input		\dram_io_data_out[171] ;
input		\dram_io_data_out[170] ;
input		\dram_io_data_out[169] ;
input		\dram_io_data_out[168] ;
input		\dram_io_data_out[167] ;
input		\dram_io_data_out[166] ;
input		\dram_io_data_out[165] ;
input		\dram_io_data_out[164] ;
input		\dram_io_data_out[163] ;
input		\dram_io_data_out[162] ;
input		\dram_io_data_out[161] ;
input		\dram_io_data_out[160] ;
input		\dram_io_data_out[159] ;
input		\dram_io_data_out[158] ;
input		\dram_io_data_out[157] ;
input		\dram_io_data_out[156] ;
input		\dram_io_data_out[155] ;
input		\dram_io_data_out[154] ;
input		\dram_io_data_out[153] ;
input		\dram_io_data_out[152] ;
input		\dram_io_data_out[151] ;
input		\dram_io_data_out[150] ;
input		\dram_io_data_out[149] ;
input		\dram_io_data_out[148] ;
input		\dram_io_data_out[147] ;
input		\dram_io_data_out[146] ;
input		\dram_io_data_out[145] ;
input		\dram_io_data_out[144] ;
input		\dram_io_data_out[279] ;
input		\dram_io_data_out[278] ;
input		\dram_io_data_out[277] ;
input		\dram_io_data_out[276] ;
input		\dram_io_data_out[275] ;
input		\dram_io_data_out[274] ;
input		\dram_io_data_out[273] ;
input		\dram_io_data_out[272] ;
input		\dram_io_data_out[135] ;
input		\dram_io_data_out[134] ;
input		\dram_io_data_out[133] ;
input		\dram_io_data_out[132] ;
input		\dram_io_data_out[131] ;
input		\dram_io_data_out[130] ;
input		\dram_io_data_out[129] ;
input		\dram_io_data_out[128] ;
input		pad_clk_si ;
input		\dram_io_addr[9] ;
input		\dram_io_addr[8] ;
input		\dram_io_addr[7] ;
input		\dram_io_addr[6] ;
input		\dram_io_addr[5] ;
input		\dram_io_addr[4] ;
input		\dram_io_addr[3] ;
input		\dram_io_addr[2] ;
input		\dram_io_addr[1] ;
input		\dram_io_addr[0] ;
input		bsi ;
input		dram_io_clk_enable ;
input		dram_io_cke ;
input		\dram_io_addr[14] ;
input		\dram_io_addr[13] ;
input		\dram_io_addr[12] ;
input		\dram_io_addr[11] ;
input		rst_l_i_l ;
input		arst_l_i_l ;
input		bypass_enable_i_r ;
input		hiz_n_i_l ;
input		shift_dr_i_l ;
input		mode_ctrl_i_l ;
input		dram_io_drive_data_i_l ;
input		se_i_l ;
input		update_dr_i_l ;
input		clock_dr_i_l ;
input		\dram_io_data_out[239] ;
input		\dram_io_data_out[238] ;
input		\dram_io_data_out[237] ;
input		\dram_io_data_out[236] ;
input		\dram_io_data_out[235] ;
input		\dram_io_data_out[234] ;
input		\dram_io_data_out[233] ;
input		\dram_io_data_out[232] ;
input		\dram_io_data_out[231] ;
input		\dram_io_data_out[230] ;
input		\dram_io_data_out[229] ;
input		\dram_io_data_out[228] ;
input		\dram_io_data_out[227] ;
input		\dram_io_data_out[226] ;
input		\dram_io_data_out[225] ;
input		\dram_io_data_out[224] ;
input		\dram_io_data_out[223] ;
input		\dram_io_data_out[222] ;
input		\dram_io_data_out[221] ;
input		\dram_io_data_out[220] ;
input		\dram_io_data_out[219] ;
input		\dram_io_data_out[218] ;
input		\dram_io_data_out[217] ;
input		\dram_io_data_out[216] ;
input		\dram_io_data_out[215] ;
input		\dram_io_data_out[214] ;
input		\dram_io_data_out[213] ;
input		\dram_io_data_out[212] ;
input		\dram_io_data_out[211] ;
input		\dram_io_data_out[210] ;
input		\dram_io_data_out[209] ;
input		\dram_io_data_out[208] ;
inout		\dram_addr[9] ;
inout		\dram_addr[8] ;
inout		\dram_addr[7] ;
inout		\dram_addr[6] ;
inout		\dram_addr[5] ;
inout		\dram_addr[4] ;
inout		\dram_addr[3] ;
inout		\dram_addr[2] ;
inout		\dram_addr[1] ;
inout		\dram_addr[0] ;
inout		\dram_dqs[12] ;
inout		\dram_dqs[11] ;
inout		\dram_dqs[10] ;
inout		\dram_dqs[9] ;
inout		\dram_dqs[8] ;
inout		\dram_addr[14] ;
inout		\dram_addr[13] ;
inout		\dram_addr[12] ;
inout		\dram_addr[11] ;
inout		dram_cke ;
inout		\dram_dq[95] ;
inout		\dram_dq[94] ;
inout		\dram_dq[93] ;
inout		\dram_dq[92] ;
inout		\dram_dq[91] ;
inout		\dram_dq[90] ;
inout		\dram_dq[89] ;
inout		\dram_dq[88] ;
inout		\dram_dq[87] ;
inout		\dram_dq[86] ;
inout		\dram_dq[85] ;
inout		\dram_dq[84] ;
inout		\dram_dq[83] ;
inout		\dram_dq[82] ;
inout		\dram_dq[81] ;
inout		\dram_dq[80] ;
inout		\dram_dq[79] ;
inout		\dram_dq[78] ;
inout		\dram_dq[77] ;
inout		\dram_dq[76] ;
inout		\dram_dq[75] ;
inout		\dram_dq[74] ;
inout		\dram_dq[73] ;
inout		\dram_dq[72] ;
inout		\dram_dq[71] ;
inout		\dram_dq[70] ;
inout		\dram_dq[69] ;
inout		\dram_dq[68] ;
inout		\dram_dq[67] ;
inout		\dram_dq[66] ;
inout		\dram_dq[65] ;
inout		\dram_dq[64] ;
inout		\dram_dq[31] ;
inout		\dram_dq[30] ;
inout		\dram_dq[29] ;
inout		\dram_dq[28] ;
inout		\dram_dq[27] ;
inout		\dram_dq[26] ;
inout		\dram_dq[25] ;
inout		\dram_dq[24] ;
inout		\dram_dq[23] ;
inout		\dram_dq[22] ;
inout		\dram_dq[21] ;
inout		\dram_dq[20] ;
inout		\dram_dq[19] ;
inout		\dram_dq[18] ;
inout		\dram_dq[17] ;
inout		\dram_dq[16] ;
inout		\dram_dq[15] ;
inout		\dram_dq[14] ;
inout		\dram_dq[13] ;
inout		\dram_dq[12] ;
inout		\dram_dq[11] ;
inout		\dram_dq[10] ;
inout		\dram_dq[9] ;
inout		\dram_dq[8] ;
inout		\dram_dq[7] ;
inout		\dram_dq[6] ;
inout		\dram_dq[5] ;
inout		\dram_dq[4] ;
inout		\dram_dq[3] ;
inout		\dram_dq[2] ;
inout		\dram_dq[1] ;
inout		\dram_dq[0] ;
inout		\dram_dqs[3] ;
inout		\dram_dqs[2] ;
inout		\dram_dqs[1] ;
inout		\dram_dqs[0] ;
inout		\dram_dqs[21] ;
inout		\dram_dqs[20] ;
inout		\dram_dqs[19] ;
inout		\dram_dqs[18] ;
inout		\dram_dqs[17] ;
inout		\dram_dqs[30] ;
inout		\dram_dqs[29] ;
inout		\dram_dqs[28] ;
inout		\dram_dqs[27] ;
 
wire [7:0]	net704 ;
wire [4:0]	net692 ;
wire [7:0]	net0781 ;
wire [7:0]	net0742 ;
wire [1:0]	net943 ;
wire [7:0]	net0608 ;
wire [1:0]	net799 ;
wire [7:0]	net0424 ;
wire [7:0]	net0609 ;
wire [4:0]	net818 ;
wire [7:0]	net0848 ;
wire [7:0]	net0743 ;
wire [7:0]	net0849 ;
wire [7:0]	net0883 ;
wire [4:0]	net918 ;
wire [7:0]	net569 ;
wire [7:0]	net0341 ;
wire [7:0]	net0475 ;
wire [1:0]	net565 ;
wire [7:0]	net0695 ;
wire [7:0]	net570 ;
wire [7:0]	net0694 ;
wire [1:0]	net826 ;
wire [7:0]	net830 ;
wire [4:0]	net438 ;
wire [4:0]	net579 ;
wire [7:0]	net831 ;
wire [7:0]	net0628 ;
wire [1:0]	net673 ;
wire [7:0]	net0526 ;
wire [7:0]	net682 ;
wire [7:0]	net0730 ;
wire [7:0]	net0577 ;
wire [1:0]	net700 ;
wire [7:0]	net0832 ;
wire [4:0]	net940 ;
wire [7:0]	net705 ;
wire [7:0]	net809 ;
wire [7:0]	net592 ;
wire [7:0]	net683 ;
wire [7:0]	net591 ;
wire [7:0]	net808 ;
wire [1:0]	net948 ;
wire [1:0]	net566 ;
wire [4:0]	net670 ;
wire [1:0]	net678 ;
wire [1:0]	net582 ;
wire [1:0]	net701 ;
wire [1:0]	net413 ;
wire [4:0]	net796 ;
wire [1:0]	net921 ;
wire [1:0]	net827 ;
wire [1:0]	net949 ;
wire [4:0]	net557 ;
wire [1:0]	net679 ;
wire [1:0]	net587 ;
wire [4:0]	net410 ;
wire [1:0]	net804 ;
wire [1:0]	net695 ;
wire [1:0]	net430 ;
wire [1:0]	net926 ;
wire [1:0]	net440 ;
wire [1:0]	net560 ;
wire [1:0]	net588 ;
wire [1:0]	net805 ;
wire [1:0]	net821 ;
wire [1:0]	net429 ;
wire [1:0]	net927 ;
wire [1:0]	net435 ;
wire [1:0]	net441 ;
wire		net01157 ;
wire		net580 ;
wire		net581 ;
wire		net680 ;
wire		net583 ;
wire		net681 ;
wire		net584 ;
wire		net586 ;
wire		net684 ;
wire		net685 ;
wire		net800 ;
wire		net702 ;
wire		net686 ;
wire		net409 ;
wire		net801 ;
wire		net703 ;
wire		net687 ;
wire		net589 ;
wire		net688 ;
wire		net803 ;
wire		net689 ;
wire		net706 ;
wire		net707 ;
wire		net708 ;
wire		net806 ;
wire		net709 ;
wire		net807 ;
wire		net0482 ;
wire		net590 ;
wire		net411 ;
wire		net412 ;
wire		net0386 ;
wire		net690 ;
wire		net414 ;
wire		net593 ;
wire		net691 ;
wire		net594 ;
wire		net415 ;
wire		net0487 ;
wire		net710 ;
wire		net595 ;
wire		net416 ;
wire		net693 ;
wire		net711 ;
wire		net596 ;
wire		net694 ;
wire		net712 ;
wire		net597 ;
wire		net418 ;
wire		net810 ;
wire		net696 ;
wire		net598 ;
wire		net419 ;
wire		net811 ;
wire		net697 ;
wire		net599 ;
wire		net795 ;
wire		net812 ;
wire		net813 ;
wire		net814 ;
wire		net699 ;
wire		net797 ;
wire		net798 ;
wire		net815 ;
wire		net816 ;
wire		net0530 ;
wire		net817 ;
wire		net420 ;
wire		net421 ;
wire		net917 ;
wire		net422 ;
wire		net0631 ;
wire		net423 ;
wire		net919 ;
wire		net0535 ;
wire		net424 ;
wire		net427 ;
wire		net428 ;
wire		net820 ;
wire		bso0_bsi1 ;
wire		net822 ;
wire		net920 ;
wire		net823 ;
wire		bso2_bsi3 ;
wire		net922 ;
wire		net825 ;
wire		net923 ;
wire		bso4_bsi5 ;
wire		net925 ;
wire		net828 ;
wire		net829 ;
wire		net432 ;
wire		net928 ;
wire		net433 ;
wire		net929 ;
wire		net434 ;
wire		net436 ;
wire		net437 ;
wire		net439 ;
wire		net832 ;
wire		net833 ;
wire		net932 ;
wire		net834 ;
wire		net835 ;
wire		net836 ;
wire		net837 ;
wire		net838 ;
wire		net0434 ;
wire		net442 ;
wire		net939 ;
wire		net443 ;
wire		pad_clk_so1_si2 ;
wire		net0439 ;
wire		net446 ;
wire		net447 ;
wire		net448 ;
wire		net449 ;
wire		pad_clk_so2_si3 ;
wire		net942 ;
wire		net0818 ;
wire		net944 ;
wire		net450 ;
wire		net945 ;
wire		net451 ;
wire		pad_clk_so0_si1 ;
wire		net452 ;
wire		net947 ;
wire		net0722 ;
wire		net556 ;
wire		net0823 ;
wire		net558 ;
wire		net950 ;
wire		net01234 ;
wire		net559 ;
wire		net951 ;
wire		net0727 ;
wire		net954 ;
wire		net0391 ;
wire		net955 ;
wire		pad_clk_so3_si4 ;
wire		net956 ;
wire		net957 ;
wire		net958 ;
wire		net959 ;
wire		net561 ;
wire		net562 ;
wire		pad_clk_so4_si5 ;
wire		net564 ;
wire		net0770 ;
wire		net0674 ;
wire		net567 ;
wire		net568 ;
wire		net960 ;
wire		net0578 ;
wire		bso1_bsi2 ;
wire		net0775 ;
wire		net0679 ;
wire		net669 ;
wire		bso3_bsi4 ;
wire		net571 ;
wire		net572 ;
wire		net0583 ;
wire		net573 ;
wire		net671 ;
wire		net574 ;
wire		net672 ;
wire		net575 ;
wire		net576 ;
wire		net674 ;
wire		net577 ;
wire		net675 ;
wire		net578 ;
wire		net677 ;
 
 
bw_io_ddr_6sig_x4 I0 (
     .serial_in       ({serial_in[15:0] } ),
     .afo             ({afo[15:0] } ),
     .serial_out      ({serial_out[15:0] } ),
     .afi             ({afi[15:0] } ),
     .vrefcode_i_l    ({net0341[0] ,net0341[1] ,net0341[2] ,net0341[3] ,
            net0341[4] ,net0341[5] ,net0341[6] ,net0341[7] } ),
     .vrefcode_i_r    ({net0730[0] ,net0730[1] ,net0730[2] ,net0730[3] ,
            net0730[4] ,net0730[5] ,net0730[6] ,net0730[7] } ),
     .data_neg        ({\dram_io_data_out[215] ,\dram_io_data_out[214] ,
            \dram_io_data_out[213] ,\dram_io_data_out[212] ,
            \dram_io_data_out[211] ,\dram_io_data_out[210] ,
            \dram_io_data_out[209] ,\dram_io_data_out[208] ,
            \dram_io_data_out[151] ,\dram_io_data_out[150] ,
            \dram_io_data_out[149] ,\dram_io_data_out[148] ,
            \dram_io_data_out[147] ,\dram_io_data_out[146] ,
            \dram_io_data_out[145] ,\dram_io_data_out[144] } ),
     .data_pos        ({\dram_io_data_out[71] ,\dram_io_data_out[70] ,
            \dram_io_data_out[69] ,\dram_io_data_out[68] ,
            \dram_io_data_out[67] ,\dram_io_data_out[66] ,
            \dram_io_data_out[65] ,\dram_io_data_out[64] ,
            \dram_io_data_out[7] ,\dram_io_data_out[6] ,
            \dram_io_data_out[5] ,\dram_io_data_out[4] ,
            \dram_io_data_out[3] ,\dram_io_data_out[2] ,
            \dram_io_data_out[1] ,\dram_io_data_out[0] } ),
     .io_dram_data_in ({\io_dram_data_in[71] ,\io_dram_data_in[70] ,
            \io_dram_data_in[69] ,\io_dram_data_in[68] ,
            \io_dram_data_in[67] ,\io_dram_data_in[66] ,
            \io_dram_data_in[65] ,\io_dram_data_in[64] ,
            \io_dram_data_in[7] ,\io_dram_data_in[6] ,
            \io_dram_data_in[5] ,\io_dram_data_in[4] ,
            \io_dram_data_in[3] ,\io_dram_data_in[2] ,
            \io_dram_data_in[1] ,\io_dram_data_in[0] } ),
     .io_dram_data_in_hi ({\io_dram_data_in[199] ,\io_dram_data_in[198]
             ,\io_dram_data_in[197] ,\io_dram_data_in[196] ,
            \io_dram_data_in[195] ,\io_dram_data_in[194] ,
            \io_dram_data_in[193] ,\io_dram_data_in[192] ,
            \io_dram_data_in[135] ,\io_dram_data_in[134] ,
            \io_dram_data_in[133] ,\io_dram_data_in[132] ,
            \io_dram_data_in[131] ,\io_dram_data_in[130] ,
            \io_dram_data_in[129] ,\io_dram_data_in[128] } ),
     .dq_pad          ({\dram_dq[71] ,\dram_dq[70] ,\dram_dq[69] ,
            \dram_dq[68] ,\dram_dq[67] ,\dram_dq[66] ,\dram_dq[65] ,
            \dram_dq[64] ,\dram_dq[7] ,\dram_dq[6] ,\dram_dq[5] ,
            \dram_dq[4] ,\dram_dq[3] ,\dram_dq[2] ,\dram_dq[1] ,
            \dram_dq[0] } ),
     .lpf_code_i_r    ({net940[0] ,net940[1] ,net940[2] ,net940[3] ,
            net940[4] } ),
     .dram_io_ptr_clk_inv_i_r ({net943[0] ,net943[1] } ),
     .pad_pos_cnt_i_r ({net948[0] ,net948[1] } ),
     .pad_neg_cnt_i_r ({net949[0] ,net949[1] } ),
     .cbu_i_r         ({net0743[0] ,net0743[1] ,net0743[2] ,net0743[3] ,
            net0743[4] ,net0743[5] ,net0743[6] ,net0743[7] } ),
     .cbd_i_r         ({net0742[0] ,net0742[1] ,net0742[2] ,net0742[3] ,
            net0742[4] ,net0742[5] ,net0742[6] ,net0742[7] } ),
     .dqs_pad         ({\dram_dqs[27] ,\dram_dqs[18] ,\dram_dqs[9] ,
            \dram_dqs[0] } ),
     .lpf_code_i_l    ({net918[0] ,net918[1] ,net918[2] ,net918[3] ,
            net918[4] } ),
     .dram_io_ptr_clk_inv_i_l ({net921[0] ,net921[1] } ),
     .pad_pos_cnt_i_l ({net926[0] ,net926[1] } ),
     .pad_neg_cnt_i_l ({net927[0] ,net927[1] } ),
     .cbu_i_l         ({net0695[0] ,net0695[1] ,net0695[2] ,net0695[3] ,
            net0695[4] ,net0695[5] ,net0695[6] ,net0695[7] } ),
     .cbd_i_l         ({net0694[0] ,net0694[1] ,net0694[2] ,net0694[3] ,
            net0694[4] ,net0694[5] ,net0694[6] ,net0694[7] } ),
     .bypass_enable_i_r (net960 ),
     .ps_select_i_r   (net0674 ),
     .test_mode_i_l   (net0631 ),
     .testmode_l_i_l  (net925 ),
     .rclk            (rclk ),
     .vdd_h           (vdd_h ),
     .test_mode_i_r   (net0679 ),
     .strobe_i_r      (net939 ),
     .burst_length_four_i_r (net942 ),
     .dram_io_pad_enable_i_r (net944 ),
     .dram_io_drive_enable_i_r (net945 ),
     .rst_l_i_r       (net01234 ),
     .arst_l_i_r       (arst_l_i_r ),
     .dram_io_channel_disabled_i_r (net950 ),
     .dram_io_drive_data_i_r (net951 ),
     .se_i_r          (net954 ),
     .mode_ctrl_i_r   (net955 ),
     .update_dr_i_r   (net956 ),
     .shift_dr_i_r    (net957 ),
     .clock_dr_i_r    (net958 ),
     .hiz_n_i_r       (net959 ),
     .pad_clk_si      (pad_clk_si ),
     .pad_clk_so      (pad_clk_so0_si1 ),
     .ctl_pad_0       (spare_ddr_pin[9] ),
     .ctl_pad_1       (\dram_addr[14] ),
     .ctl_pad_3       (dram_cke ),
     .ctl_pad_2       (\dram_addr[13] ),
     .ctl_data_0      (spare_ddr_data[9] ),
     .ctl_data_1      (\dram_io_addr[14] ),
     .ctl_data_2      (\dram_io_addr[13] ),
     .ctl_data_3      (dram_io_cke ),
     .bsi             (bsi ),
     .bso             (bso0_bsi1 ),
     .strobe_i_l      (net917 ),
     .burst_length_four_i_l (net920 ),
     .dram_io_pad_enable_i_l (net922 ),
     .dram_io_drive_enable_i_l (net923 ),
     .rst_l_i_l       (net919 ),
     .arst_l_i_l       (arst_l_i_l ),
     .dram_io_channel_disabled_i_l (net928 ),
     .dram_io_drive_data_i_l (net929 ),
     .se_i_l          (net932 ),
     .mode_ctrl_i_l   (mode_ctrl_out ),
     .ps_select_i_l   (ps_select_out ),
     .shift_dr_i_l    (shift_dr_out ),
     .clock_dr_i_l    (clock_dr_out ),
     .testmode_l_i_r  (net947 ),
     .hiz_n_i_l       (hiz_n_out ),
     .bypass_enable_i_l (bypass_enable_out ),
     .update_dr_i_l   (update_dr_out ) );
bw_io_ddr_6sig_x4 I1 (
     .serial_in       ({serial_in[31:16] } ),
     .afo             ({afo[31:16] } ),
     .serial_out      ({serial_out[31:16] } ),
     .afi             ({afi[31:16] } ),
     .vrefcode_i_l    ({net0883[0] ,net0883[1] ,net0883[2] ,net0883[3] ,
            net0883[4] ,net0883[5] ,net0883[6] ,net0883[7] } ),
     .vrefcode_i_r    ({net0628[0] ,net0628[1] ,net0628[2] ,net0628[3] ,
            net0628[4] ,net0628[5] ,net0628[6] ,net0628[7] } ),
     .data_neg        ({\dram_io_data_out[223] ,\dram_io_data_out[222] ,
            \dram_io_data_out[221] ,\dram_io_data_out[220] ,
            \dram_io_data_out[219] ,\dram_io_data_out[218] ,
            \dram_io_data_out[217] ,\dram_io_data_out[216] ,
            \dram_io_data_out[159] ,\dram_io_data_out[158] ,
            \dram_io_data_out[157] ,\dram_io_data_out[156] ,
            \dram_io_data_out[155] ,\dram_io_data_out[154] ,
            \dram_io_data_out[153] ,\dram_io_data_out[152] } ),
     .data_pos        ({\dram_io_data_out[79] ,\dram_io_data_out[78] ,
            \dram_io_data_out[77] ,\dram_io_data_out[76] ,
            \dram_io_data_out[75] ,\dram_io_data_out[74] ,
            \dram_io_data_out[73] ,\dram_io_data_out[72] ,
            \dram_io_data_out[15] ,\dram_io_data_out[14] ,
            \dram_io_data_out[13] ,\dram_io_data_out[12] ,
            \dram_io_data_out[11] ,\dram_io_data_out[10] ,
            \dram_io_data_out[9] ,\dram_io_data_out[8] } ),
     .io_dram_data_in ({\io_dram_data_in[79] ,\io_dram_data_in[78] ,
            \io_dram_data_in[77] ,\io_dram_data_in[76] ,
            \io_dram_data_in[75] ,\io_dram_data_in[74] ,
            \io_dram_data_in[73] ,\io_dram_data_in[72] ,
            \io_dram_data_in[15] ,\io_dram_data_in[14] ,
            \io_dram_data_in[13] ,\io_dram_data_in[12] ,
            \io_dram_data_in[11] ,\io_dram_data_in[10] ,
            \io_dram_data_in[9] ,\io_dram_data_in[8] } ),
     .io_dram_data_in_hi ({\io_dram_data_in[207] ,\io_dram_data_in[206]
             ,\io_dram_data_in[205] ,\io_dram_data_in[204] ,
            \io_dram_data_in[203] ,\io_dram_data_in[202] ,
            \io_dram_data_in[201] ,\io_dram_data_in[200] ,
            \io_dram_data_in[143] ,\io_dram_data_in[142] ,
            \io_dram_data_in[141] ,\io_dram_data_in[140] ,
            \io_dram_data_in[139] ,\io_dram_data_in[138] ,
            \io_dram_data_in[137] ,\io_dram_data_in[136] } ),
     .dq_pad          ({\dram_dq[79] ,\dram_dq[78] ,\dram_dq[77] ,
            \dram_dq[76] ,\dram_dq[75] ,\dram_dq[74] ,\dram_dq[73] ,
            \dram_dq[72] ,\dram_dq[15] ,\dram_dq[14] ,\dram_dq[13] ,
            \dram_dq[12] ,\dram_dq[11] ,\dram_dq[10] ,\dram_dq[9] ,
            \dram_dq[8] } ),
     .lpf_code_i_r    ({net818[0] ,net818[1] ,net818[2] ,net818[3] ,
            net818[4] } ),
     .dram_io_ptr_clk_inv_i_r ({net821[0] ,net821[1] } ),
     .pad_pos_cnt_i_r ({net826[0] ,net826[1] } ),
     .pad_neg_cnt_i_r ({net827[0] ,net827[1] } ),
     .cbu_i_r         ({net831[0] ,net831[1] ,net831[2] ,net831[3] ,
            net831[4] ,net831[5] ,net831[6] ,net831[7] } ),
     .cbd_i_r         ({net830[0] ,net830[1] ,net830[2] ,net830[3] ,
            net830[4] ,net830[5] ,net830[6] ,net830[7] } ),
     .dqs_pad         ({\dram_dqs[28] ,\dram_dqs[19] ,\dram_dqs[10] ,
            \dram_dqs[1] } ),
     .lpf_code_i_l    ({net796[0] ,net796[1] ,net796[2] ,net796[3] ,
            net796[4] } ),
     .dram_io_ptr_clk_inv_i_l ({net799[0] ,net799[1] } ),
     .pad_pos_cnt_i_l ({net804[0] ,net804[1] } ),
     .pad_neg_cnt_i_l ({net805[0] ,net805[1] } ),
     .cbu_i_l         ({net809[0] ,net809[1] ,net809[2] ,net809[3] ,
            net809[4] ,net809[5] ,net809[6] ,net809[7] } ),
     .cbd_i_l         ({net808[0] ,net808[1] ,net808[2] ,net808[3] ,
            net808[4] ,net808[5] ,net808[6] ,net808[7] } ),
     .bypass_enable_i_r (net838 ),
     .ps_select_i_r   (net0578 ),
     .test_mode_i_l   (net0823 ),
     .testmode_l_i_l  (net803 ),
     .rclk            (rclk ),
     .vdd_h           (vdd_h ),
     .test_mode_i_r   (net0583 ),
     .strobe_i_r      (net817 ),
     .burst_length_four_i_r (net820 ),
     .dram_io_pad_enable_i_r (net822 ),
     .dram_io_drive_enable_i_r (net823 ),
     .rst_l_i_r       (net01157 ),
     .arst_l_i_r      (arst_l_i_r ),
     .dram_io_channel_disabled_i_r (net828 ),
     .dram_io_drive_data_i_r (net829 ),
     .se_i_r          (net832 ),
     .mode_ctrl_i_r   (net833 ),
     .update_dr_i_r   (net834 ),
     .shift_dr_i_r    (net835 ),
     .clock_dr_i_r    (net836 ),
     .hiz_n_i_r       (net837 ),
     .pad_clk_si      (pad_clk_so0_si1 ),
     .pad_clk_so      (pad_clk_so1_si2 ),
     .ctl_pad_0       (dram_ba[2] ),
     .ctl_pad_1       (\dram_addr[12] ),
     .ctl_pad_3       (\dram_addr[9] ),
     .ctl_pad_2       (\dram_addr[11] ),
     .ctl_data_0      (dram_io_bank[2] ),
     .ctl_data_1      (\dram_io_addr[12] ),
     .ctl_data_2      (\dram_io_addr[11] ),
     .ctl_data_3      (\dram_io_addr[9] ),
     .bsi             (bso0_bsi1 ),
     .bso             (bso1_bsi2 ),
     .strobe_i_l      (net795 ),
     .burst_length_four_i_l (net798 ),
     .dram_io_pad_enable_i_l (net800 ),
     .dram_io_drive_enable_i_l (net801 ),
     .rst_l_i_l       (net797 ),
     .arst_l_i_l      (arst_l_i_l ),
     .dram_io_channel_disabled_i_l (net806 ),
     .dram_io_drive_data_i_l (net807 ),
     .se_i_l          (net810 ),
     .mode_ctrl_i_l   (net811 ),
     .ps_select_i_l   (net0818 ),
     .shift_dr_i_l    (net813 ),
     .clock_dr_i_l    (net814 ),
     .testmode_l_i_r  (net825 ),
     .hiz_n_i_l       (net815 ),
     .bypass_enable_i_l (net816 ),
     .update_dr_i_l   (net812 ) );
bw_io_ddr_6sig_x4 I2 (
     .serial_in       ({serial_in[47:32] } ),
     .afo             ({afo[47:32] } ),
     .serial_out      ({serial_out[47:32] } ),
     .afi             ({afi[47:32] } ),
     .vrefcode_i_l    ({net0424[0] ,net0424[1] ,net0424[2] ,net0424[3] ,
            net0424[4] ,net0424[5] ,net0424[6] ,net0424[7] } ),
     .vrefcode_i_r    ({net0526[0] ,net0526[1] ,net0526[2] ,net0526[3] ,
            net0526[4] ,net0526[5] ,net0526[6] ,net0526[7] } ),
     .data_neg        ({\dram_io_data_out[231] ,\dram_io_data_out[230] ,
            \dram_io_data_out[229] ,\dram_io_data_out[228] ,
            \dram_io_data_out[227] ,\dram_io_data_out[226] ,
            \dram_io_data_out[225] ,\dram_io_data_out[224] ,
            \dram_io_data_out[167] ,\dram_io_data_out[166] ,
            \dram_io_data_out[165] ,\dram_io_data_out[164] ,
            \dram_io_data_out[163] ,\dram_io_data_out[162] ,
            \dram_io_data_out[161] ,\dram_io_data_out[160] } ),
     .data_pos        ({\dram_io_data_out[87] ,\dram_io_data_out[86] ,
            \dram_io_data_out[85] ,\dram_io_data_out[84] ,
            \dram_io_data_out[83] ,\dram_io_data_out[82] ,
            \dram_io_data_out[81] ,\dram_io_data_out[80] ,
            \dram_io_data_out[23] ,\dram_io_data_out[22] ,
            \dram_io_data_out[21] ,\dram_io_data_out[20] ,
            \dram_io_data_out[19] ,\dram_io_data_out[18] ,
            \dram_io_data_out[17] ,\dram_io_data_out[16] } ),
     .io_dram_data_in ({\io_dram_data_in[87] ,\io_dram_data_in[86] ,
            \io_dram_data_in[85] ,\io_dram_data_in[84] ,
            \io_dram_data_in[83] ,\io_dram_data_in[82] ,
            \io_dram_data_in[81] ,\io_dram_data_in[80] ,
            \io_dram_data_in[23] ,\io_dram_data_in[22] ,
            \io_dram_data_in[21] ,\io_dram_data_in[20] ,
            \io_dram_data_in[19] ,\io_dram_data_in[18] ,
            \io_dram_data_in[17] ,\io_dram_data_in[16] } ),
     .io_dram_data_in_hi ({\io_dram_data_in[215] ,\io_dram_data_in[214]
             ,\io_dram_data_in[213] ,\io_dram_data_in[212] ,
            \io_dram_data_in[211] ,\io_dram_data_in[210] ,
            \io_dram_data_in[209] ,\io_dram_data_in[208] ,
            \io_dram_data_in[151] ,\io_dram_data_in[150] ,
            \io_dram_data_in[149] ,\io_dram_data_in[148] ,
            \io_dram_data_in[147] ,\io_dram_data_in[146] ,
            \io_dram_data_in[145] ,\io_dram_data_in[144] } ),
     .dq_pad          ({\dram_dq[87] ,\dram_dq[86] ,\dram_dq[85] ,
            \dram_dq[84] ,\dram_dq[83] ,\dram_dq[82] ,\dram_dq[81] ,
            \dram_dq[80] ,\dram_dq[23] ,\dram_dq[22] ,\dram_dq[21] ,
            \dram_dq[20] ,\dram_dq[19] ,\dram_dq[18] ,\dram_dq[17] ,
            \dram_dq[16] } ),
     .lpf_code_i_r    ({net692[0] ,net692[1] ,net692[2] ,net692[3] ,
            net692[4] } ),
     .dram_io_ptr_clk_inv_i_r ({net695[0] ,net695[1] } ),
     .pad_pos_cnt_i_r ({net700[0] ,net700[1] } ),
     .pad_neg_cnt_i_r ({net701[0] ,net701[1] } ),
     .cbu_i_r         ({net705[0] ,net705[1] ,net705[2] ,net705[3] ,
            net705[4] ,net705[5] ,net705[6] ,net705[7] } ),
     .cbd_i_r         ({net704[0] ,net704[1] ,net704[2] ,net704[3] ,
            net704[4] ,net704[5] ,net704[6] ,net704[7] } ),
     .dqs_pad         ({\dram_dqs[29] ,\dram_dqs[20] ,\dram_dqs[11] ,
            \dram_dqs[2] } ),
     .lpf_code_i_l    ({net670[0] ,net670[1] ,net670[2] ,net670[3] ,
            net670[4] } ),
     .dram_io_ptr_clk_inv_i_l ({net673[0] ,net673[1] } ),
     .pad_pos_cnt_i_l ({net678[0] ,net678[1] } ),
     .pad_neg_cnt_i_l ({net679[0] ,net679[1] } ),
     .cbu_i_l         ({net683[0] ,net683[1] ,net683[2] ,net683[3] ,
            net683[4] ,net683[5] ,net683[6] ,net683[7] } ),
     .cbd_i_l         ({net682[0] ,net682[1] ,net682[2] ,net682[3] ,
            net682[4] ,net682[5] ,net682[6] ,net682[7] } ),
     .bypass_enable_i_r (net712 ),
     .ps_select_i_r   (net0482 ),
     .test_mode_i_l   (net0391 ),
     .testmode_l_i_l  (net677 ),
     .rclk            (rclk ),
     .vdd_h           (vdd_h ),
     .test_mode_i_r   (net0487 ),
     .strobe_i_r      (net691 ),
     .burst_length_four_i_r (net694 ),
     .dram_io_pad_enable_i_r (net696 ),
     .dram_io_drive_enable_i_r (net697 ),
     .rst_l_i_r       (net693 ),
     .arst_l_i_r      (arst_l_i_r ),
     .dram_io_channel_disabled_i_r (net702 ),
     .dram_io_drive_data_i_r (net703 ),
     .se_i_r          (net706 ),
     .mode_ctrl_i_r   (net707 ),
     .update_dr_i_r   (net708 ),
     .shift_dr_i_r    (net709 ),
     .clock_dr_i_r    (net710 ),
     .hiz_n_i_r       (net711 ),
     .pad_clk_si      (pad_clk_so1_si2 ),
     .pad_clk_so      (pad_clk_so2_si3 ),
     .ctl_pad_0       (\dram_addr[8] ),
     .ctl_pad_1       (\dram_addr[7] ),
     .ctl_pad_3       (\dram_addr[6] ),
     .ctl_pad_2       (spare_ddr_pin[8] ),
     .ctl_data_0      (\dram_io_addr[8] ),
     .ctl_data_1      (\dram_io_addr[7] ),
     .ctl_data_2      (spare_ddr_data[8] ),
     .ctl_data_3      (\dram_io_addr[6] ),
     .bsi             (bso1_bsi2 ),
     .bso             (bso2_bsi3 ),
     .strobe_i_l      (net669 ),
     .burst_length_four_i_l (net672 ),
     .dram_io_pad_enable_i_l (net674 ),
     .dram_io_drive_enable_i_l (net675 ),
     .rst_l_i_l       (net671 ),
     .arst_l_i_l      (arst_l_i_l ),
     .dram_io_channel_disabled_i_l (net680 ),
     .dram_io_drive_data_i_l (net681 ),
     .se_i_l          (net684 ),
     .mode_ctrl_i_l   (net685 ),
     .ps_select_i_l   (net0386 ),
     .shift_dr_i_l    (net687 ),
     .clock_dr_i_l    (net688 ),
     .testmode_l_i_r  (net699 ),
     .hiz_n_i_l       (net689 ),
     .bypass_enable_i_l (net690 ),
     .update_dr_i_l   (net686 ) );
bw_io_ddr_6sig_x4 I3 (
     .serial_in       ({serial_in[63:48] } ),
     .afo             ({afo[63:48] } ),
     .serial_out      ({serial_out[63:48] } ),
     .afi             ({afi[63:48] } ),
     .vrefcode_i_l    ({net0475[0] ,net0475[1] ,net0475[2] ,net0475[3] ,
            net0475[4] ,net0475[5] ,net0475[6] ,net0475[7] } ),
     .vrefcode_i_r    ({net0781[0] ,net0781[1] ,net0781[2] ,net0781[3] ,
            net0781[4] ,net0781[5] ,net0781[6] ,net0781[7] } ),
     .data_neg        ({\dram_io_data_out[279] ,\dram_io_data_out[278] ,
            \dram_io_data_out[277] ,\dram_io_data_out[276] ,
            \dram_io_data_out[275] ,\dram_io_data_out[274] ,
            \dram_io_data_out[273] ,\dram_io_data_out[272] ,
            \dram_io_data_out[175] ,\dram_io_data_out[174] ,
            \dram_io_data_out[173] ,\dram_io_data_out[172] ,
            \dram_io_data_out[171] ,\dram_io_data_out[170] ,
            \dram_io_data_out[169] ,\dram_io_data_out[168] } ),
     .data_pos        ({\dram_io_data_out[135] ,\dram_io_data_out[134] ,
            \dram_io_data_out[133] ,\dram_io_data_out[132] ,
            \dram_io_data_out[131] ,\dram_io_data_out[130] ,
            \dram_io_data_out[129] ,\dram_io_data_out[128] ,
            \dram_io_data_out[31] ,\dram_io_data_out[30] ,
            \dram_io_data_out[29] ,\dram_io_data_out[28] ,
            \dram_io_data_out[27] ,\dram_io_data_out[26] ,
            \dram_io_data_out[25] ,\dram_io_data_out[24] } ),
     .io_dram_data_in ({\io_dram_ecc_in[7] ,\io_dram_ecc_in[6] ,
            \io_dram_ecc_in[5] ,\io_dram_ecc_in[4] ,\io_dram_ecc_in[3] ,
            \io_dram_ecc_in[2] ,\io_dram_ecc_in[1] ,\io_dram_ecc_in[0] ,
            \io_dram_data_in[31] ,\io_dram_data_in[30] ,
            \io_dram_data_in[29] ,\io_dram_data_in[28] ,
            \io_dram_data_in[27] ,\io_dram_data_in[26] ,
            \io_dram_data_in[25] ,\io_dram_data_in[24] } ),
     .io_dram_data_in_hi ({\io_dram_ecc_in[23] ,\io_dram_ecc_in[22] ,
            \io_dram_ecc_in[21] ,\io_dram_ecc_in[20] ,
            \io_dram_ecc_in[19] ,\io_dram_ecc_in[18] ,
            \io_dram_ecc_in[17] ,\io_dram_ecc_in[16] ,
            \io_dram_data_in[159] ,\io_dram_data_in[158] ,
            \io_dram_data_in[157] ,\io_dram_data_in[156] ,
            \io_dram_data_in[155] ,\io_dram_data_in[154] ,
            \io_dram_data_in[153] ,\io_dram_data_in[152] } ),
     .dq_pad          ({dram_cb[7:0] ,\dram_dq[31] ,\dram_dq[30] ,
            \dram_dq[29] ,\dram_dq[28] ,\dram_dq[27] ,\dram_dq[26] ,
            \dram_dq[25] ,\dram_dq[24] } ),
     .lpf_code_i_r    ({net579[0] ,net579[1] ,net579[2] ,net579[3] ,
            net579[4] } ),
     .dram_io_ptr_clk_inv_i_r ({net582[0] ,net582[1] } ),
     .pad_pos_cnt_i_r ({net587[0] ,net587[1] } ),
     .pad_neg_cnt_i_r ({net588[0] ,net588[1] } ),
     .cbu_i_r         ({net592[0] ,net592[1] ,net592[2] ,net592[3] ,
            net592[4] ,net592[5] ,net592[6] ,net592[7] } ),
     .cbd_i_r         ({net591[0] ,net591[1] ,net591[2] ,net591[3] ,
            net591[4] ,net591[5] ,net591[6] ,net591[7] } ),
     .dqs_pad         ({\dram_dqs[17] ,\dram_dqs[8] ,\dram_dqs[12] ,
            \dram_dqs[3] } ),
     .lpf_code_i_l    ({net557[0] ,net557[1] ,net557[2] ,net557[3] ,
            net557[4] } ),
     .dram_io_ptr_clk_inv_i_l ({net560[0] ,net560[1] } ),
     .pad_pos_cnt_i_l ({net565[0] ,net565[1] } ),
     .pad_neg_cnt_i_l ({net566[0] ,net566[1] } ),
     .cbu_i_l         ({net570[0] ,net570[1] ,net570[2] ,net570[3] ,
            net570[4] ,net570[5] ,net570[6] ,net570[7] } ),
     .cbd_i_l         ({net569[0] ,net569[1] ,net569[2] ,net569[3] ,
            net569[4] ,net569[5] ,net569[6] ,net569[7] } ),
     .bypass_enable_i_r (net599 ),
     .ps_select_i_r   (net0722 ),
     .test_mode_i_l   (net0439 ),
     .testmode_l_i_l  (net564 ),
     .rclk            (rclk ),
     .vdd_h           (vdd_h ),
     .test_mode_i_r   (net0727 ),
     .strobe_i_r      (net578 ),
     .burst_length_four_i_r (net581 ),
     .dram_io_pad_enable_i_r (net583 ),
     .dram_io_drive_enable_i_r (net584 ),
     .rst_l_i_r       (net580 ),
     .arst_l_i_r      (arst_l_i_r ),
     .dram_io_channel_disabled_i_r (net589 ),
     .dram_io_drive_data_i_r (net590 ),
     .se_i_r          (net593 ),
     .mode_ctrl_i_r   (net594 ),
     .update_dr_i_r   (net595 ),
     .shift_dr_i_r    (net596 ),
     .clock_dr_i_r    (net597 ),
     .hiz_n_i_r       (net598 ),
     .pad_clk_si      (pad_clk_so2_si3 ),
     .pad_clk_so      (pad_clk_so3_si4 ),
     .ctl_pad_0       (\dram_addr[5] ),
     .ctl_pad_1       (\dram_addr[4] ),
     .ctl_pad_3       (\dram_addr[2] ),
     .ctl_pad_2       (\dram_addr[3] ),
     .ctl_data_0      (\dram_io_addr[5] ),
     .ctl_data_1      (\dram_io_addr[4] ),
     .ctl_data_2      (\dram_io_addr[3] ),
     .ctl_data_3      (\dram_io_addr[2] ),
     .bsi             (bso2_bsi3 ),
     .bso             (bso3_bsi4 ),
     .strobe_i_l      (net556 ),
     .burst_length_four_i_l (net559 ),
     .dram_io_pad_enable_i_l (net561 ),
     .dram_io_drive_enable_i_l (net562 ),
     .rst_l_i_l       (net558 ),
     .arst_l_i_l      (arst_l_i_l ),
     .dram_io_channel_disabled_i_l (net567 ),
     .dram_io_drive_data_i_l (net568 ),
     .se_i_l          (net571 ),
     .mode_ctrl_i_l   (net572 ),
     .ps_select_i_l   (net0434 ),
     .shift_dr_i_l    (net574 ),
     .clock_dr_i_l    (net575 ),
     .testmode_l_i_r  (net586 ),
     .hiz_n_i_l       (net576 ),
     .bypass_enable_i_l (net577 ),
     .update_dr_i_l   (net573 ) );
bw_io_ddr_rptr_a I248 (
     .out14           ({net0848[0] ,net0848[1] ,net0848[2] ,net0848[3] ,
            net0848[4] ,net0848[5] ,net0848[6] ,net0848[7] } ),
     .out13           ({net0849[0] ,net0849[1] ,net0849[2] ,net0849[3] ,
            net0849[4] ,net0849[5] ,net0849[6] ,net0849[7] } ),
     .out10           ({net441[0] ,net441[1] } ),
     .out9            ({net440[0] ,net440[1] } ),
     .out4            ({net435[0] ,net435[1] } ),
     .in14            ({cbd_i_l } ),
     .in13            ({cbu_i_l } ),
     .out1            ({net438[0] ,net438[1] ,net438[2] ,net438[3] ,
            net438[4] } ),
     .in10            ({pad_neg_cnt_i_l } ),
     .in25            ({vrefcode_i_l } ),
     .out25           ({net0832[0] ,net0832[1] ,net0832[2] ,net0832[3] ,
            net0832[4] ,net0832[5] ,net0832[6] ,net0832[7] } ),
     .in1             ({lpf_code_i_l } ),
     .in4             ({dram_io_ptr_clk_inv_i_l } ),
     .in9             ({pad_pos_cnt_i_l } ),
     .out21           (net448 ),
     .out20           (net450 ),
     .out19           (net451 ),
     .out18           (net447 ),
     .out17           (net446 ),
     .out16           (net449 ),
     .out15           (net452 ),
     .out12           (net442 ),
     .out8            (net432 ),
     .out6            (net436 ),
     .out5            (net434 ),
     .out3            (net437 ),
     .out2            (net433 ),
     .in21            (bypass_enable_i_l ),
     .in20            (hiz_n_i_l ),
     .in19            (clock_dr_i_l ),
     .in18            (shift_dr_i_l ),
     .in17            (update_dr_i_l ),
     .in16            (mode_ctrl_i_l ),
     .in15            (se_i_l ),
     .in12            (dram_io_drive_data_i_l ),
     .out0            (net439 ),
     .in22            (ps_select_i_l ),
     .out22           (net0770 ),
     .in24            (test_mode_i_l ),
     .out24           (net0775 ),
     .vdd18           (vdd_h ),
     .in2             (rst_l_i_l ),
     .in5             (dram_io_pad_enable_i_l ),
     .out11           (net443 ),
     .in3             (burst_length_four_i_l ),
     .in11            (dram_io_channel_disabled_i_l ),
     .in0             (strobe_i_l ),
     .in6             (dram_io_drive_enable_i_l ),
     .in8             (testmode_l_i_l ) );
bw_io_ddr_rptr_a I249 (
     .out14           ({net0608[0] ,net0608[1] ,net0608[2] ,net0608[3] ,
            net0608[4] ,net0608[5] ,net0608[6] ,net0608[7] } ),
     .out13           ({net0609[0] ,net0609[1] ,net0609[2] ,net0609[3] ,
            net0609[4] ,net0609[5] ,net0609[6] ,net0609[7] } ),
     .out10           ({net429[0] ,net429[1] } ),
     .out9            ({net430[0] ,net430[1] } ),
     .out4            ({net413[0] ,net413[1] } ),
     .in14            ({cbd_i_r } ),
     .in13            ({cbu_i_r } ),
     .out1            ({net410[0] ,net410[1] ,net410[2] ,net410[3] ,
            net410[4] } ),
     .in10            ({pad_neg_cnt_i_r } ),
     .in25            ({vrefcode_i_r } ),
     .out25           ({net0577[0] ,net0577[1] ,net0577[2] ,net0577[3] ,
            net0577[4] ,net0577[5] ,net0577[6] ,net0577[7] } ),
     .in1             ({lpf_code_i_r } ),
     .in4             ({dram_io_ptr_clk_inv_i_r } ),
     .in9             ({pad_pos_cnt_i_r } ),
     .out21           (net422 ),
     .out20           (net420 ),
     .out19           (net419 ),
     .out18           (net423 ),
     .out17           (net424 ),
     .out16           (net421 ),
     .out15           (net418 ),
     .out12           (net428 ),
     .out8            (net416 ),
     .out6            (net412 ),
     .out5            (net414 ),
     .out3            (net411 ),
     .out2            (net415 ),
     .in21            (bypass_enable_i_r ),
     .in20            (hiz_n_i_r ),
     .in19            (clock_dr_i_r ),
     .in18            (shift_dr_i_r ),
     .in17            (update_dr_i_r ),
     .in16            (mode_ctrl_i_r ),
     .in15            (se_i_r ),
     .in12            (dram_io_drive_data_i_r ),
     .out0            (net409 ),
     .in22            (ps_select_i_r ),
     .out22           (net0530 ),
     .in24            (test_mode_i_r ),
     .out24           (net0535 ),
     .vdd18           (vdd_h ),
     .in2             (rst_l_i_r ),
     .in5             (dram_io_pad_enable_i_r ),
     .out11           (net427 ),
     .in3             (burst_length_four_i_r ),
     .in11            (dram_io_channel_disabled_i_r ),
     .in0             (strobe_i_r ),
     .in6             (dram_io_drive_enable_i_r ),
     .in8             (testmode_l_i_r ) );
bw_io_ddr_rptr_a I250 (
     .out14           ({net569[0] ,net569[1] ,net569[2] ,net569[3] ,
            net569[4] ,net569[5] ,net569[6] ,net569[7] } ),
     .out13           ({net570[0] ,net570[1] ,net570[2] ,net570[3] ,
            net570[4] ,net570[5] ,net570[6] ,net570[7] } ),
     .out10           ({net566[0] ,net566[1] } ),
     .out9            ({net565[0] ,net565[1] } ),
     .out4            ({net560[0] ,net560[1] } ),
     .in14            ({net0848[0] ,net0848[1] ,net0848[2] ,net0848[3] ,
            net0848[4] ,net0848[5] ,net0848[6] ,net0848[7] } ),
     .in13            ({net0849[0] ,net0849[1] ,net0849[2] ,net0849[3] ,
            net0849[4] ,net0849[5] ,net0849[6] ,net0849[7] } ),
     .out1            ({net557[0] ,net557[1] ,net557[2] ,net557[3] ,
            net557[4] } ),
     .in10            ({net441[0] ,net441[1] } ),
     .in25            ({net0832[0] ,net0832[1] ,net0832[2] ,net0832[3] ,
            net0832[4] ,net0832[5] ,net0832[6] ,net0832[7] } ),
     .out25           ({net0475[0] ,net0475[1] ,net0475[2] ,net0475[3] ,
            net0475[4] ,net0475[5] ,net0475[6] ,net0475[7] } ),
     .in1             ({net438[0] ,net438[1] ,net438[2] ,net438[3] ,
            net438[4] } ),
     .in4             ({net435[0] ,net435[1] } ),
     .in9             ({net440[0] ,net440[1] } ),
     .out21           (net577 ),
     .out20           (net576 ),
     .out19           (net575 ),
     .out18           (net574 ),
     .out17           (net573 ),
     .out16           (net572 ),
     .out15           (net571 ),
     .out12           (net568 ),
     .out8            (net564 ),
     .out6            (net562 ),
     .out5            (net561 ),
     .out3            (net559 ),
     .out2            (net558 ),
     .in21            (net448 ),
     .in20            (net450 ),
     .in19            (net451 ),
     .in18            (net447 ),
     .in17            (net446 ),
     .in16            (net449 ),
     .in15            (net452 ),
     .in12            (net442 ),
     .out0            (net556 ),
     .in22            (net0770 ),
     .out22           (net0434 ),
     .in24            (net0775 ),
     .out24           (net0439 ),
     .vdd18           (vdd_h ),
     .in2             (net433 ),
     .in5             (net434 ),
     .out11           (net567 ),
     .in3             (net437 ),
     .in11            (net443 ),
     .in0             (net439 ),
     .in6             (net436 ),
     .in8             (net432 ) );
bw_io_ddr_rptr_a I251 (
     .out14           ({net591[0] ,net591[1] ,net591[2] ,net591[3] ,
            net591[4] ,net591[5] ,net591[6] ,net591[7] } ),
     .out13           ({net592[0] ,net592[1] ,net592[2] ,net592[3] ,
            net592[4] ,net592[5] ,net592[6] ,net592[7] } ),
     .out10           ({net588[0] ,net588[1] } ),
     .out9            ({net587[0] ,net587[1] } ),
     .out4            ({net582[0] ,net582[1] } ),
     .in14            ({net0608[0] ,net0608[1] ,net0608[2] ,net0608[3] ,
            net0608[4] ,net0608[5] ,net0608[6] ,net0608[7] } ),
     .in13            ({net0609[0] ,net0609[1] ,net0609[2] ,net0609[3] ,
            net0609[4] ,net0609[5] ,net0609[6] ,net0609[7] } ),
     .out1            ({net579[0] ,net579[1] ,net579[2] ,net579[3] ,
            net579[4] } ),
     .in10            ({net429[0] ,net429[1] } ),
     .in25            ({net0577[0] ,net0577[1] ,net0577[2] ,net0577[3] ,
            net0577[4] ,net0577[5] ,net0577[6] ,net0577[7] } ),
     .out25           ({net0781[0] ,net0781[1] ,net0781[2] ,net0781[3] ,
            net0781[4] ,net0781[5] ,net0781[6] ,net0781[7] } ),
     .in1             ({net410[0] ,net410[1] ,net410[2] ,net410[3] ,
            net410[4] } ),
     .in4             ({net413[0] ,net413[1] } ),
     .in9             ({net430[0] ,net430[1] } ),
     .out21           (net599 ),
     .out20           (net598 ),
     .out19           (net597 ),
     .out18           (net596 ),
     .out17           (net595 ),
     .out16           (net594 ),
     .out15           (net593 ),
     .out12           (net590 ),
     .out8            (net586 ),
     .out6            (net584 ),
     .out5            (net583 ),
     .out3            (net581 ),
     .out2            (net580 ),
     .in21            (net422 ),
     .in20            (net420 ),
     .in19            (net419 ),
     .in18            (net423 ),
     .in17            (net424 ),
     .in16            (net421 ),
     .in15            (net418 ),
     .in12            (net428 ),
     .out0            (net578 ),
     .in22            (net0530 ),
     .out22           (net0722 ),
     .in24            (net0535 ),
     .out24           (net0727 ),
     .vdd18           (vdd_h ),
     .in2             (net415 ),
     .in5             (net414 ),
     .out11           (net589 ),
     .in3             (net411 ),
     .in11            (net427 ),
     .in0             (net409 ),
     .in6             (net412 ),
     .in8             (net416 ) );
bw_io_ddr_rptr_a I252 (
     .out14           ({net682[0] ,net682[1] ,net682[2] ,net682[3] ,
            net682[4] ,net682[5] ,net682[6] ,net682[7] } ),
     .out13           ({net683[0] ,net683[1] ,net683[2] ,net683[3] ,
            net683[4] ,net683[5] ,net683[6] ,net683[7] } ),
     .out10           ({net679[0] ,net679[1] } ),
     .out9            ({net678[0] ,net678[1] } ),
     .out4            ({net673[0] ,net673[1] } ),
     .in14            ({net569[0] ,net569[1] ,net569[2] ,net569[3] ,
            net569[4] ,net569[5] ,net569[6] ,net569[7] } ),
     .in13            ({net570[0] ,net570[1] ,net570[2] ,net570[3] ,
            net570[4] ,net570[5] ,net570[6] ,net570[7] } ),
     .out1            ({net670[0] ,net670[1] ,net670[2] ,net670[3] ,
            net670[4] } ),
     .in10            ({net566[0] ,net566[1] } ),
     .in25            ({net0475[0] ,net0475[1] ,net0475[2] ,net0475[3] ,
            net0475[4] ,net0475[5] ,net0475[6] ,net0475[7] } ),
     .out25           ({net0424[0] ,net0424[1] ,net0424[2] ,net0424[3] ,
            net0424[4] ,net0424[5] ,net0424[6] ,net0424[7] } ),
     .in1             ({net557[0] ,net557[1] ,net557[2] ,net557[3] ,
            net557[4] } ),
     .in4             ({net560[0] ,net560[1] } ),
     .in9             ({net565[0] ,net565[1] } ),
     .out21           (net690 ),
     .out20           (net689 ),
     .out19           (net688 ),
     .out18           (net687 ),
     .out17           (net686 ),
     .out16           (net685 ),
     .out15           (net684 ),
     .out12           (net681 ),
     .out8            (net677 ),
     .out6            (net675 ),
     .out5            (net674 ),
     .out3            (net672 ),
     .out2            (net671 ),
     .in21            (net577 ),
     .in20            (net576 ),
     .in19            (net575 ),
     .in18            (net574 ),
     .in17            (net573 ),
     .in16            (net572 ),
     .in15            (net571 ),
     .in12            (net568 ),
     .out0            (net669 ),
     .in22            (net0434 ),
     .out22           (net0386 ),
     .in24            (net0439 ),
     .out24           (net0391 ),
     .vdd18           (vdd_h ),
     .in2             (net558 ),
     .in5             (net561 ),
     .out11           (net680 ),
     .in3             (net559 ),
     .in11            (net567 ),
     .in0             (net556 ),
     .in6             (net562 ),
     .in8             (net564 ) );
bw_io_ddr_rptr_a I253 (
     .out14           ({net704[0] ,net704[1] ,net704[2] ,net704[3] ,
            net704[4] ,net704[5] ,net704[6] ,net704[7] } ),
     .out13           ({net705[0] ,net705[1] ,net705[2] ,net705[3] ,
            net705[4] ,net705[5] ,net705[6] ,net705[7] } ),
     .out10           ({net701[0] ,net701[1] } ),
     .out9            ({net700[0] ,net700[1] } ),
     .out4            ({net695[0] ,net695[1] } ),
     .in14            ({net591[0] ,net591[1] ,net591[2] ,net591[3] ,
            net591[4] ,net591[5] ,net591[6] ,net591[7] } ),
     .in13            ({net592[0] ,net592[1] ,net592[2] ,net592[3] ,
            net592[4] ,net592[5] ,net592[6] ,net592[7] } ),
     .out1            ({net692[0] ,net692[1] ,net692[2] ,net692[3] ,
            net692[4] } ),
     .in10            ({net588[0] ,net588[1] } ),
     .in25            ({net0781[0] ,net0781[1] ,net0781[2] ,net0781[3] ,
            net0781[4] ,net0781[5] ,net0781[6] ,net0781[7] } ),
     .out25           ({net0526[0] ,net0526[1] ,net0526[2] ,net0526[3] ,
            net0526[4] ,net0526[5] ,net0526[6] ,net0526[7] } ),
     .in1             ({net579[0] ,net579[1] ,net579[2] ,net579[3] ,
            net579[4] } ),
     .in4             ({net582[0] ,net582[1] } ),
     .in9             ({net587[0] ,net587[1] } ),
     .out21           (net712 ),
     .out20           (net711 ),
     .out19           (net710 ),
     .out18           (net709 ),
     .out17           (net708 ),
     .out16           (net707 ),
     .out15           (net706 ),
     .out12           (net703 ),
     .out8            (net699 ),
     .out6            (net697 ),
     .out5            (net696 ),
     .out3            (net694 ),
     .out2            (net693 ),
     .in21            (net599 ),
     .in20            (net598 ),
     .in19            (net597 ),
     .in18            (net596 ),
     .in17            (net595 ),
     .in16            (net594 ),
     .in15            (net593 ),
     .in12            (net590 ),
     .out0            (net691 ),
     .in22            (net0722 ),
     .out22           (net0482 ),
     .in24            (net0727 ),
     .out24           (net0487 ),
     .vdd18           (vdd_h ),
     .in2             (net580 ),
     .in5             (net583 ),
     .out11           (net702 ),
     .in3             (net581 ),
     .in11            (net589 ),
     .in0             (net578 ),
     .in6             (net584 ),
     .in8             (net586 ) );
bw_io_ddr_rptr_a I254 (
     .out14           ({net808[0] ,net808[1] ,net808[2] ,net808[3] ,
            net808[4] ,net808[5] ,net808[6] ,net808[7] } ),
     .out13           ({net809[0] ,net809[1] ,net809[2] ,net809[3] ,
            net809[4] ,net809[5] ,net809[6] ,net809[7] } ),
     .out10           ({net805[0] ,net805[1] } ),
     .out9            ({net804[0] ,net804[1] } ),
     .out4            ({net799[0] ,net799[1] } ),
     .in14            ({net682[0] ,net682[1] ,net682[2] ,net682[3] ,
            net682[4] ,net682[5] ,net682[6] ,net682[7] } ),
     .in13            ({net683[0] ,net683[1] ,net683[2] ,net683[3] ,
            net683[4] ,net683[5] ,net683[6] ,net683[7] } ),
     .out1            ({net796[0] ,net796[1] ,net796[2] ,net796[3] ,
            net796[4] } ),
     .in10            ({net679[0] ,net679[1] } ),
     .in25            ({net0424[0] ,net0424[1] ,net0424[2] ,net0424[3] ,
            net0424[4] ,net0424[5] ,net0424[6] ,net0424[7] } ),
     .out25           ({net0883[0] ,net0883[1] ,net0883[2] ,net0883[3] ,
            net0883[4] ,net0883[5] ,net0883[6] ,net0883[7] } ),
     .in1             ({net670[0] ,net670[1] ,net670[2] ,net670[3] ,
            net670[4] } ),
     .in4             ({net673[0] ,net673[1] } ),
     .in9             ({net678[0] ,net678[1] } ),
     .out21           (net816 ),
     .out20           (net815 ),
     .out19           (net814 ),
     .out18           (net813 ),
     .out17           (net812 ),
     .out16           (net811 ),
     .out15           (net810 ),
     .out12           (net807 ),
     .out8            (net803 ),
     .out6            (net801 ),
     .out5            (net800 ),
     .out3            (net798 ),
     .out2            (net797 ),
     .in21            (net690 ),
     .in20            (net689 ),
     .in19            (net688 ),
     .in18            (net687 ),
     .in17            (net686 ),
     .in16            (net685 ),
     .in15            (net684 ),
     .in12            (net681 ),
     .out0            (net795 ),
     .in22            (net0386 ),
     .out22           (net0818 ),
     .in24            (net0391 ),
     .out24           (net0823 ),
     .vdd18           (vdd_h ),
     .in2             (net671 ),
     .in5             (net674 ),
     .out11           (net806 ),
     .in3             (net672 ),
     .in11            (net680 ),
     .in0             (net669 ),
     .in6             (net675 ),
     .in8             (net677 ) );
bw_io_ddr_rptr_a I255 (
     .out14           ({net830[0] ,net830[1] ,net830[2] ,net830[3] ,
            net830[4] ,net830[5] ,net830[6] ,net830[7] } ),
     .out13           ({net831[0] ,net831[1] ,net831[2] ,net831[3] ,
            net831[4] ,net831[5] ,net831[6] ,net831[7] } ),
     .out10           ({net827[0] ,net827[1] } ),
     .out9            ({net826[0] ,net826[1] } ),
     .out4            ({net821[0] ,net821[1] } ),
     .in14            ({net704[0] ,net704[1] ,net704[2] ,net704[3] ,
            net704[4] ,net704[5] ,net704[6] ,net704[7] } ),
     .in13            ({net705[0] ,net705[1] ,net705[2] ,net705[3] ,
            net705[4] ,net705[5] ,net705[6] ,net705[7] } ),
     .out1            ({net818[0] ,net818[1] ,net818[2] ,net818[3] ,
            net818[4] } ),
     .in10            ({net701[0] ,net701[1] } ),
     .in25            ({net0526[0] ,net0526[1] ,net0526[2] ,net0526[3] ,
            net0526[4] ,net0526[5] ,net0526[6] ,net0526[7] } ),
     .out25           ({net0628[0] ,net0628[1] ,net0628[2] ,net0628[3] ,
            net0628[4] ,net0628[5] ,net0628[6] ,net0628[7] } ),
     .in1             ({net692[0] ,net692[1] ,net692[2] ,net692[3] ,
            net692[4] } ),
     .in4             ({net695[0] ,net695[1] } ),
     .in9             ({net700[0] ,net700[1] } ),
     .out21           (net838 ),
     .out20           (net837 ),
     .out19           (net836 ),
     .out18           (net835 ),
     .out17           (net834 ),
     .out16           (net833 ),
     .out15           (net832 ),
     .out12           (net829 ),
     .out8            (net825 ),
     .out6            (net823 ),
     .out5            (net822 ),
     .out3            (net820 ),
     .out2            (net01157 ),
     .in21            (net712 ),
     .in20            (net711 ),
     .in19            (net710 ),
     .in18            (net709 ),
     .in17            (net708 ),
     .in16            (net707 ),
     .in15            (net706 ),
     .in12            (net703 ),
     .out0            (net817 ),
     .in22            (net0482 ),
     .out22           (net0578 ),
     .in24            (net0487 ),
     .out24           (net0583 ),
     .vdd18           (vdd_h ),
     .in2             (net693 ),
     .in5             (net696 ),
     .out11           (net828 ),
     .in3             (net694 ),
     .in11            (net702 ),
     .in0             (net691 ),
     .in6             (net697 ),
     .in8             (net699 ) );
bw_io_ddr_rptr_a I256 (
     .out14           ({net0694[0] ,net0694[1] ,net0694[2] ,net0694[3] ,
            net0694[4] ,net0694[5] ,net0694[6] ,net0694[7] } ),
     .out13           ({net0695[0] ,net0695[1] ,net0695[2] ,net0695[3] ,
            net0695[4] ,net0695[5] ,net0695[6] ,net0695[7] } ),
     .out10           ({net927[0] ,net927[1] } ),
     .out9            ({net926[0] ,net926[1] } ),
     .out4            ({net921[0] ,net921[1] } ),
     .in14            ({net808[0] ,net808[1] ,net808[2] ,net808[3] ,
            net808[4] ,net808[5] ,net808[6] ,net808[7] } ),
     .in13            ({net809[0] ,net809[1] ,net809[2] ,net809[3] ,
            net809[4] ,net809[5] ,net809[6] ,net809[7] } ),
     .out1            ({net918[0] ,net918[1] ,net918[2] ,net918[3] ,
            net918[4] } ),
     .in10            ({net805[0] ,net805[1] } ),
     .in25            ({net0883[0] ,net0883[1] ,net0883[2] ,net0883[3] ,
            net0883[4] ,net0883[5] ,net0883[6] ,net0883[7] } ),
     .out25           ({net0341[0] ,net0341[1] ,net0341[2] ,net0341[3] ,
            net0341[4] ,net0341[5] ,net0341[6] ,net0341[7] } ),
     .in1             ({net796[0] ,net796[1] ,net796[2] ,net796[3] ,
            net796[4] } ),
     .in4             ({net799[0] ,net799[1] } ),
     .in9             ({net804[0] ,net804[1] } ),
     .out21           (bypass_enable_out ),
     .out20           (hiz_n_out ),
     .out19           (clock_dr_out ),
     .out18           (shift_dr_out ),
     .out17           (update_dr_out ),
     .out16           (mode_ctrl_out ),
     .out15           (net932 ),
     .out12           (net929 ),
     .out8            (net925 ),
     .out6            (net923 ),
     .out5            (net922 ),
     .out3            (net920 ),
     .out2            (net919 ),
     .in21            (net816 ),
     .in20            (net815 ),
     .in19            (net814 ),
     .in18            (net813 ),
     .in17            (net812 ),
     .in16            (net811 ),
     .in15            (net810 ),
     .in12            (net807 ),
     .out0            (net917 ),
     .in22            (net0818 ),
     .out22           (ps_select_out ),
     .in24            (net0823 ),
     .out24           (net0631 ),
     .vdd18           (vdd_h ),
     .in2             (net797 ),
     .in5             (net800 ),
     .out11           (net928 ),
     .in3             (net798 ),
     .in11            (net806 ),
     .in0             (net795 ),
     .in6             (net801 ),
     .in8             (net803 ) );
bw_io_ddr_rptr_a I257 (
     .out14           ({net0742[0] ,net0742[1] ,net0742[2] ,net0742[3] ,
            net0742[4] ,net0742[5] ,net0742[6] ,net0742[7] } ),
     .out13           ({net0743[0] ,net0743[1] ,net0743[2] ,net0743[3] ,
            net0743[4] ,net0743[5] ,net0743[6] ,net0743[7] } ),
     .out10           ({net949[0] ,net949[1] } ),
     .out9            ({net948[0] ,net948[1] } ),
     .out4            ({net943[0] ,net943[1] } ),
     .in14            ({net830[0] ,net830[1] ,net830[2] ,net830[3] ,
            net830[4] ,net830[5] ,net830[6] ,net830[7] } ),
     .in13            ({net831[0] ,net831[1] ,net831[2] ,net831[3] ,
            net831[4] ,net831[5] ,net831[6] ,net831[7] } ),
     .out1            ({net940[0] ,net940[1] ,net940[2] ,net940[3] ,
            net940[4] } ),
     .in10            ({net827[0] ,net827[1] } ),
     .in25            ({net0628[0] ,net0628[1] ,net0628[2] ,net0628[3] ,
            net0628[4] ,net0628[5] ,net0628[6] ,net0628[7] } ),
     .out25           ({net0730[0] ,net0730[1] ,net0730[2] ,net0730[3] ,
            net0730[4] ,net0730[5] ,net0730[6] ,net0730[7] } ),
     .in1             ({net818[0] ,net818[1] ,net818[2] ,net818[3] ,
            net818[4] } ),
     .in4             ({net821[0] ,net821[1] } ),
     .in9             ({net826[0] ,net826[1] } ),
     .out21           (net960 ),
     .out20           (net959 ),
     .out19           (net958 ),
     .out18           (net957 ),
     .out17           (net956 ),
     .out16           (net955 ),
     .out15           (net954 ),
     .out12           (net951 ),
     .out8            (net947 ),
     .out6            (net945 ),
     .out5            (net944 ),
     .out3            (net942 ),
     .out2            (net01234 ),
     .in21            (net838 ),
     .in20            (net837 ),
     .in19            (net836 ),
     .in18            (net835 ),
     .in17            (net834 ),
     .in16            (net833 ),
     .in15            (net832 ),
     .in12            (net829 ),
     .out0            (net939 ),
     .in22            (net0578 ),
     .out22           (net0674 ),
     .in24            (net0583 ),
     .out24           (net0679 ),
     .vdd18           (vdd_h ),
     .in2             (net01157 ),
     .in5             (net822 ),
     .out11           (net950 ),
     .in3             (net820 ),
     .in11            (net828 ),
     .in0             (net817 ),
     .in6             (net823 ),
     .in8             (net825 ) );
bw_io_ddr_6sig_x2 I110 (
     .serial_out      ({serial_out[71:64] } ),
     .serial_in       ({serial_in[71:64] } ),
     .afo             ({afo[71:64] } ),
     .afi             ({afi[71:64] } ),
     .vrefcode_i_l    ({net0832[0] ,net0832[1] ,net0832[2] ,net0832[3] ,
            net0832[4] ,net0832[5] ,net0832[6] ,net0832[7] } ),
     .vrefcode_i_r    ({net0577[0] ,net0577[1] ,net0577[2] ,net0577[3] ,
            net0577[4] ,net0577[5] ,net0577[6] ,net0577[7] } ),
     .dq_pad          ({\dram_dq[95] ,\dram_dq[94] ,\dram_dq[93] ,
            \dram_dq[92] ,\dram_dq[91] ,\dram_dq[90] ,\dram_dq[89] ,
            \dram_dq[88] } ),
     .io_dram_data_in ({\io_dram_data_in[95] ,\io_dram_data_in[94] ,
            \io_dram_data_in[93] ,\io_dram_data_in[92] ,
            \io_dram_data_in[91] ,\io_dram_data_in[90] ,
            \io_dram_data_in[89] ,\io_dram_data_in[88] } ),
     .io_dram_data_in_hi ({\io_dram_data_in[223] ,\io_dram_data_in[222]
             ,\io_dram_data_in[221] ,\io_dram_data_in[220] ,
            \io_dram_data_in[219] ,\io_dram_data_in[218] ,
            \io_dram_data_in[217] ,\io_dram_data_in[216] } ),
     .data_neg        ({\dram_io_data_out[239] ,\dram_io_data_out[238] ,
            \dram_io_data_out[237] ,\dram_io_data_out[236] ,
            \dram_io_data_out[235] ,\dram_io_data_out[234] ,
            \dram_io_data_out[233] ,\dram_io_data_out[232] } ),
     .data_pos        ({\dram_io_data_out[95] ,\dram_io_data_out[94] ,
            \dram_io_data_out[93] ,\dram_io_data_out[92] ,
            \dram_io_data_out[91] ,\dram_io_data_out[90] ,
            \dram_io_data_out[89] ,\dram_io_data_out[88] } ),
     .dqs_pad         ({\dram_dqs[30] ,\dram_dqs[21] } ),
     .lpf_code_i_r    ({net410[0] ,net410[1] ,net410[2] ,net410[3] ,
            net410[4] } ),
     .dram_io_ptr_clk_inv_i_r ({net413[0] ,net413[1] } ),
     .pad_pos_cnt_i_r ({net430[0] ,net430[1] } ),
     .pad_neg_cnt_i_r ({net429[0] ,net429[1] } ),
     .cbu_i_r         ({net0609[0] ,net0609[1] ,net0609[2] ,net0609[3] ,
            net0609[4] ,net0609[5] ,net0609[6] ,net0609[7] } ),
     .cbd_i_r         ({net0608[0] ,net0608[1] ,net0608[2] ,net0608[3] ,
            net0608[4] ,net0608[5] ,net0608[6] ,net0608[7] } ),
     .lpf_code_i_l    ({net438[0] ,net438[1] ,net438[2] ,net438[3] ,
            net438[4] } ),
     .dram_io_ptr_clk_inv_i_l ({net435[0] ,net435[1] } ),
     .pad_pos_cnt_i_l ({net440[0] ,net440[1] } ),
     .pad_neg_cnt_i_l ({net441[0] ,net441[1] } ),
     .cbu_i_l         ({net0849[0] ,net0849[1] ,net0849[2] ,net0849[3] ,
            net0849[4] ,net0849[5] ,net0849[6] ,net0849[7] } ),
     .cbd_i_l         ({net0848[0] ,net0848[1] ,net0848[2] ,net0848[3] ,
            net0848[4] ,net0848[5] ,net0848[6] ,net0848[7] } ),
     .ps_select_i_l   (net0770 ),
     .testmode_l_i_l  (net432 ),
     .test_mode_i_l   (net0775 ),
     .testmode_l_i_r  (net416 ),
     .test_mode_i_r   (net0535 ),
     .pad_clk_so      (pad_clk_so4_si5 ),
     .ps_select_i_r   (net0530 ),
     .ctl_pad_1       (\dram_addr[0] ),
     .bso             (bso4_bsi5 ),
     .ctl_data_0      (\dram_io_addr[1] ),
     .pad_clk_si      (pad_clk_so3_si4 ),
     .bypass_enable_i_l (net448 ),
     .vdd_h           (vdd_h ),
     .strobe_i_r      (net409 ),
     .burst_length_four_i_r (net411 ),
     .dram_io_pad_enable_i_r (net414 ),
     .dram_io_drive_enable_i_r (net412 ),
     .rst_l_i_r       (net415 ),
     .arst_l_i_r      (arst_l_i_r ),
     .dram_io_channel_disabled_i_r (net427 ),
     .dram_io_drive_data_i_r (net428 ),
     .se_i_r          (net418 ),
     .mode_ctrl_i_r   (net421 ),
     .shift_dr_i_r    (net423 ),
     .clock_dr_i_r    (net419 ),
     .hiz_n_i_r       (net420 ),
     .update_dr_i_r   (net424 ),
     .strobe_i_l      (net439 ),
     .burst_length_four_i_l (net437 ),
     .dram_io_pad_enable_i_l (net434 ),
     .dram_io_drive_enable_i_l (net436 ),
     .ctl_data_1      (\dram_io_addr[0] ),
     .rst_l_i_l       (net433 ),
     .arst_l_i_l      (arst_l_i_l ),
     .dram_io_channel_disabled_i_l (net443 ),
     .dram_io_drive_data_i_l (net442 ),
     .se_i_l          (net452 ),
     .mode_ctrl_i_l   (net449 ),
     .shift_dr_i_l    (net447 ),
     .clock_dr_i_l    (net451 ),
     .hiz_n_i_l       (net450 ),
     .update_dr_i_l   (net446 ),
     .rclk            (rclk ),
     .bypass_enable_i_r (net422 ),
     .bsi             (bso3_bsi4 ),
     .ctl_pad_0       (\dram_addr[1] ) );
bw_io_ddr_4sig_clk_x2 I119 (
     .vrefcode_i_l    ({net0832[0] ,net0832[1] ,net0832[2] ,net0832[3] ,
            net0832[4] ,net0832[5] ,net0832[6] ,net0832[7] } ),
     .vrefcode_i_r    ({net0577[0] ,net0577[1] ,net0577[2] ,net0577[3] ,
            net0577[4] ,net0577[5] ,net0577[6] ,net0577[7] } ),
     .dram_ck_n       ({dram_ck_n } ),
     .dram_ck_p       ({dram_ck_p } ),
     .cbd_i_l         ({net0848[0] ,net0848[1] ,net0848[2] ,net0848[3] ,
            net0848[4] ,net0848[5] ,net0848[6] ,net0848[7] } ),
     .cbu_i_l         ({net0849[0] ,net0849[1] ,net0849[2] ,net0849[3] ,
            net0849[4] ,net0849[5] ,net0849[6] ,net0849[7] } ),
     .cbu_i_r         ({net0609[0] ,net0609[1] ,net0609[2] ,net0609[3] ,
            net0609[4] ,net0609[5] ,net0609[6] ,net0609[7] } ),
     .cbd_i_r         ({net0608[0] ,net0608[1] ,net0608[2] ,net0608[3] ,
            net0608[4] ,net0608[5] ,net0608[6] ,net0608[7] } ),
     .pad_clk_si      (pad_clk_so4_si5 ),
     .testmode_l_i_r  (net416 ),
     .pad_clk_so      (pad_clk_so ),
     .testmode_l_i_l  (net432 ),
     .shift_dr_i_l    (net447 ),
     .clock_dr_i_l    (net451 ),
     .se_i_l          (net452 ),
     .update_dr_i_l   (net446 ),
     .mode_ctrl_i_l   (net449 ),
     .hiz_n_i_l       (net450 ),
     .dram_io_clk_enable (dram_io_clk_enable ),
     .bso             (bso ),
     .bsi             (bso4_bsi5 ),
     .se_i_r          (net418 ),
     .mode_ctrl_i_r   (net421 ),
     .shift_dr_i_r    (net423 ),
     .clock_dr_i_r    (net419 ),
     .hiz_n_i_r       (net420 ),
     .update_dr_i_r   (net424 ),
     .rclk            (rclk ),
     .vdd_h           (vdd_h ) );
endmodule
