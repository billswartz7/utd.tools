// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_dtl_drv_zctl.v
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
// bw_io_dtl_drv -- DTL Driver.
// _____________________________________________________________________________


module bw_io_dtl_drv_zctl (/*AUTOARG*/
  // Outputs
  pad, 
  // Inputs
  cbu, cbd, sel_data_n, pad_up, pad_dn_l, pad_dn25_l, por, bsr_up, bsr_dn_l, 
  bsr_dn25_l, vddo
  );

  output	pad;

  input   [8:1] cbu;
  input   [8:1] cbd;
  input 	sel_data_n;
  input 	pad_up;
  input 	pad_dn_l;
  input 	pad_dn25_l;
  input 	por;
  input 	bsr_up;
  input 	bsr_dn_l;
  input 	bsr_dn25_l;
  input 	vddo;



  reg /*4value*/ pad_reg;
  always @(por or sel_data_n or pad_up or pad_dn_l or pad_dn25_l or bsr_up or bsr_dn_l or bsr_dn25_l) begin
    casex ({por, sel_data_n, pad_up, pad_dn_l,pad_dn25_l, bsr_up, bsr_dn_l, bsr_dn25_l})
      8'b1xxxxxxx: pad_reg = 1'bz; // normal path (pad) reset
      8'b00001xxx: pad_reg = 1'b0; // normal path (pad) write 0, 50 ohms
      8'b00000xxx: pad_reg = 1'b0; // normal path (pad) write 0, 25 ohms
      8'b00011xxx: pad_reg = 1'bz; // normal path (pad) hi-Z
      8'b00111xxx: pad_reg = 1'b1; // normal path (pad) write 1
      8'b01xxx001: pad_reg = 1'b0; // boundary scan (bsr) write 0, 50 ohms
      8'b01xxx000: pad_reg = 1'b0; // boundary scan (bsr) write 0, 25 ohms
      8'b01xxx011: pad_reg = 1'bz; // boundary scan (bsr) hi-Z
      8'b01xxx111: pad_reg = 1'b1; // boundary scan (bsr) write 1
      default:     pad_reg = 1'bx; // all other cases illegal and not defined
      endcase
    end

  assign (pull1, strong0) #1 pad = pad_reg;


  endmodule


// Local Variables:
// verilog-auto-sense-defines-constant:t
// End:
