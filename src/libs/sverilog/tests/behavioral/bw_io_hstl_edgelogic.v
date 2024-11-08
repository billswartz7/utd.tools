// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_io_hstl_edgelogic.v
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
/////////////////////////////////////////////////////////////////////////
/*
//  DTL edge logic 
*/
////////////////////////////////////////////////////////////////////////

`include "sys.h" 

module bw_io_hstl_edgelogic(
   // Outputs
   pad_up, pad_dn_l, pad_clk_en_l, cmsi_clk_en_l, cmsi_l, se_buf,
   bsr_up, bsr_dn_l, por,

   // Inputs
   data, oe, si, reset_l, sel_bypass, clk, bsr_mode, por_l,
   se, bsr_data_to_core, obsel, ckd
   );

//////////////////////////////////////////////////////////////////////////
// INPUTS
//////////////////////////////////////////////////////////////////////////
input		data;
input		oe;
input		si;
input		reset_l;
input		sel_bypass;
input		clk;
input		bsr_mode;
input		por_l;
input		se;
input		bsr_data_to_core;
input		[5:4] obsel;
input		ckd;
//supply0		vss;
//////////////////////////////////////////////////////////////////////////
// OUTPUTS
//////////////////////////////////////////////////////////////////////////
output		pad_up;
output		pad_dn_l;
output		pad_clk_en_l;
output		cmsi_clk_en_l;
output		cmsi_l;
output		se_buf;
output		bsr_up;
output		bsr_dn_l;
output		por;


// WIRES
wire		up;
wire		dn;
wire edgelogic_so;
wire net204;
wire net210;
wire net200;
wire net212;
wire net206;
reg net0116;
reg net0119;
reg net197;
reg cmsi_l;

wire bsr_up;
wire bsr_dn_l;
wire pad_up;
wire pad_dn_l;
wire por;
wire mselect;
wire s0;
wire s2;
wire se_buf;
wire s3;
wire die;
wire pad_clk_en_l;
wire cmsi_clk_en_l;
		
  
// always @(mselect or net212 or ckd or net200 or oe or data)
// begin
//  s0 = bsr_mode && ~se;
//  s2 = ~se && ~bsr_mode && ~reset_l;
//  se_buf = se;
//  s3 = ~bsr_mode && die;
//  die = ~se && reset_l;
//  pad_clk_en_l = sel_bypass || bsr_mode || ~die;
//  cmsi_clk_en_l = ~(sel_bypass || bsr_mode || ~die);
//  
//  dn = data || ~oe;
//  up = oe ? data : 1'b0;
//  por = ~por_l;
//  bsr_up = pad_up;
//  bsr_dn_l = pad_dn_l;
//  mselect = ~obsel[5] || obsel[4];
//  pad_up = ~(mselect ? ~net212 : ~ckd);
//  pad_dn_l = ~(mselect ? ~net200 : ~ckd);
// end

assign s0 = bsr_mode && ~se;
assign s2 = ~se && ~bsr_mode && ~reset_l;
assign se_buf = se;
assign s3 = ~bsr_mode && die;
assign die = ~se && reset_l;
assign pad_clk_en_l = sel_bypass || bsr_mode || ~die;
assign cmsi_clk_en_l = ~(sel_bypass || bsr_mode || ~die);

assign dn = data || ~oe;
assign up = oe ? data : 1'b0;
assign por = ~por_l;
assign bsr_up = pad_up;
assign bsr_dn_l = pad_dn_l;
assign mselect = ~obsel[5] || obsel[4];
assign pad_up = ~(mselect ? ~net212 : ~ckd);
assign pad_dn_l = ~(mselect ? ~net200 : ~ckd);

//  always @ (s3 or s2 or se_buf or s0 or net206 or edgelogic_so or bsr_data_to_core)
always @(/*AUTOSENSE*/bsr_data_to_core or edgelogic_so or net206 or s0
	 or s2 or s3 or se_buf)
      casex ({s3, net206, s2, 1'b0, se_buf, edgelogic_so, s0, bsr_data_to_core})
          8'b0x0x0x10: cmsi_l= 1'b1;
          8'b0x0x0x11: cmsi_l= 1'b0;
          8'b0x0x100x: cmsi_l= 1'b1;
          8'b0x0x110x: cmsi_l= 1'b0;
          8'b0x0x1010: cmsi_l= 1'b1;
          8'b0x0x1111: cmsi_l= 1'b0;
          8'b0x100x0x: cmsi_l= 1'b1;
          8'b0x110x0x: cmsi_l= 1'b0;
          8'b0x100x10: cmsi_l= 1'b1;
          8'b0x110x11: cmsi_l= 1'b0;
          8'b0x10100x: cmsi_l= 1'b1;
          8'b0x11110x: cmsi_l= 1'b0;
          8'b0x101010: cmsi_l= 1'b1;
          8'b0x111111: cmsi_l= 1'b0;
          8'b100x0x0x: cmsi_l= 1'b1;
          8'b110x0x0x: cmsi_l= 1'b0;
          8'b100x0x10: cmsi_l= 1'b1;
          8'b110x0x11: cmsi_l= 1'b0;
          8'b100x100x: cmsi_l= 1'b1;
          8'b110x110x: cmsi_l= 1'b0;
          8'b100x1010: cmsi_l= 1'b1;
          8'b110x1111: cmsi_l= 1'b0;
          8'b10100x0x: cmsi_l= 1'b1;
          8'b11110x0x: cmsi_l= 1'b0;
          8'b10100x10: cmsi_l= 1'b1;
          8'b11110x11: cmsi_l= 1'b0;
          8'b1010100x: cmsi_l= 1'b1;
          8'b1111110x: cmsi_l= 1'b0;
          8'b10101010: cmsi_l= 1'b1;
          8'b11111111: cmsi_l= 1'b0;
          default: cmsi_l= 1'bx;
      endcase   
 
/* -----\/----- EXCLUDED -----\/-----
always @(posedge clk)
 begin
  
  if (se_buf) //flop_bypass
    begin
    edgelogic_so <= net210;
    net206       <= net210;
    end
  else
    begin
    edgelogic_so <= 1'b1;
    net206 <= data;
    end
      	
  if (se_buf) //flop_dn
    begin
    net210 <= net204;
    net200 <= net204;
    end
  else
    begin
    net210 <= 1'b1;
    net200 <= dn;
    end  	

  if (se_buf) //flop_up
    begin
    net204 <= si;
    net212 <= net204;
    end
  else
    begin
    net204 <= 1'b1;
    net212 <= up;
    end  	
 end
 -----/\----- EXCLUDED -----/\----- */


dff_s u_dff_flop_bypass
   ( .din (data),
     .q   (net206),
     .clk (clk),
     .se  (se_buf),
     .si  (net210),
     .so  (edgelogic_so)
     );

dff_s u_dff_flop_dn
   ( .din (dn),
     .q   (net200),
     .clk (clk),
     .se  (se_buf),
     .si  (net204),
     .so  (net210)
     );

dff_s u_dff_flop_up
   ( .din (up),
     .q   (net212),
     .clk (clk),
     .se  (se_buf),
     .si  (si),
     .so  (net204)
     );



endmodule

// Local Variables:
// verilog-library-directories:(".")
// verilog-auto-sense-defines-constant:t
// End:

