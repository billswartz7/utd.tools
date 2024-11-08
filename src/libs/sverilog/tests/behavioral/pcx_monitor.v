// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: pcx_monitor.v
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
// pcx_monitor.v	File to monitor PCX Address.  Will print out IFETCH
//		transactions, and will stop the simulation when GOOD_TRAP or
//		BAD_TRAP is reached.

`timescale 1 ns/10 ps

module pcx_monitor (
	rclk,
	spc_pcx_req_pq, 
	spc_pcx_data_pa 
	);

    input rclk;
    input [4:0] spc_pcx_req_pq;
    input [123:0] spc_pcx_data_pa;

    parameter GOOD_TRAP_1 = 40'h1000122000;
    parameter GOOD_TRAP_2 = 40'h0000082000;
    parameter GOOD_TRAP_3 = 40'h1A00122000;
    parameter BAD_TRAP_1  = 40'h1000122020;
    parameter BAD_TRAP_2  = 40'h0000082020;
    parameter BAD_TRAP_3  = 40'h1A00122020;

    reg any_req_pa;

    // OR together all request pins and delay one cycle
    always @(posedge rclk) begin
	any_req_pa <= | spc_pcx_req_pq;
    end


    // For simulation purposes, print a debug message whenever an I-fetch 
    // packet is seen
    always @(posedge rclk) begin
	if (any_req_pa && spc_pcx_data_pa[123] &&
	    spc_pcx_data_pa[122:118] == 5'b10000) begin
	    $display("PCX:  %t : I-fetch from address  0x%h", $time,
		spc_pcx_data_pa[103:64]);

	    if (spc_pcx_data_pa[103:64] === GOOD_TRAP_1 ||
		spc_pcx_data_pa[103:64] === GOOD_TRAP_2 ||
		spc_pcx_data_pa[103:64] === GOOD_TRAP_3) begin
	    $display("PCX:  %t : Reached good trap:  Diag Passed\n", $time);
	    #500;
	    $finish;
	    end

	    if (spc_pcx_data_pa[103:64] === BAD_TRAP_1 ||
		spc_pcx_data_pa[103:64] === BAD_TRAP_2 ||
		spc_pcx_data_pa[103:64] === BAD_TRAP_3) begin
	    $display( "PCX:  %t : Reached bad trap: Diag Failed\n", $time);
	    #500;
	    $finish;
	    end
	end
    end

endmodule
