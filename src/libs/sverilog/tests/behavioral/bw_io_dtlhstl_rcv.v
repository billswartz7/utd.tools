// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtlhstl_rcv.v
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
// _____________________________________________________________________________
//
// bw_io_dtlhstl_rcv -- DTL/HSTL Receiver sense amp with thick oxide.
// _____________________________________________________________________________


module bw_io_dtlhstl_rcv (/*AUTOARG*/
  // Outputs
  out, so, 
  // Inputs
  pad, ref, clk, pad_clk_en_l, cmsi_clk_en_l, cmsi_l, se_buf, vddo
  );

  input		pad;
  input 	ref;
  input		clk;
  input		pad_clk_en_l;
  input		cmsi_clk_en_l;
  input		cmsi_l;
  input		se_buf;
  input		vddo;

  output	out;
  output	so;


  assign so = out;
  wire net0281 = se_buf; // dummy tie off

  reg out;
  always @(posedge clk) begin
    casex ({ pad_clk_en_l, pad, cmsi_clk_en_l, cmsi_l })
      4'b001x: out <= 1'b0;
      4'b011x: out <= 1'b1;
      4'b1x00: out <= 1'b1;
      4'b1x01: out <= 1'b0;
      default: out <= 1'bx;
      endcase
    end


  endmodule


// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
