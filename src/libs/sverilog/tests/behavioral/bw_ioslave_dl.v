// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_ioslave_dl.v
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
//    Unit Name:  bw_iodll (delay-locked loop -> Slave Delay line)
//    Block Name:  bw_ioslave_dl
//    Files that must be included:  none
//

module bw_ioslave_dl(
	// inputs in alphabetical order
	dqs_in,
	lpf_out,
	se,
	si,
	strobe,
	//outputs in alphabetical order
	dqs_out,
	so          );

	input		dqs_in;
	input [4:0]	lpf_out;
	input		se;
	input		si;
	input		strobe;

	output		dqs_out;
	output		so;

       parameter DELAY = 1250;

        reg             dqs_out;

        // 1/4 cycle delay line.
        always @(dqs_in)
          begin
            dqs_out <= #DELAY dqs_in;
          end


endmodule
	
