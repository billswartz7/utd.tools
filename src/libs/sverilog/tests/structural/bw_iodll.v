// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_iodll.v
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
//
//    Unit Name:  bw_iodll (delay-locked loop -> Master DLL)
//    Block Name:  DLL
//    Files that must be included:  none
//
//

module bw_iodll(
	// inputs in alphabetical order
        bypass_data,
	ddr_clk_in,
	ddr_testmode_l,
	delay_ctrl,
	io_dll_bypass_l,
	io_dll_reset_l,
	se,
	si,
	//outputs in alphabetical order
	iodll_lock,	
	lpf_out,
	overflow,
	so,
	strobe
          );

	input [4:0]     bypass_data;
	input		ddr_clk_in;
	input		ddr_testmode_l;
	input [2:0]     delay_ctrl;
	input           io_dll_bypass_l;
	input		io_dll_reset_l;
	input		se;
	input		si;

	output		iodll_lock;
	output [4:0] 	lpf_out;
	output		overflow;
	output		so;
	output		strobe;


assign lpf_out = (io_dll_bypass_l == 1'b0)? bypass_data:5'b00000;

endmodule
	
