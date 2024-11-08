// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dimm.v
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
`timescale 1ps/1ps

// `define DIMM_DEB

//----------------------------------------------------------------------
// Functional DIMM model, Only Read/Write supported
//----------------------------------------------------------------------

module dimm(// inputs 
	clk, cs, ras, cas, we, ba, addr, cs_sel,
	// inouts 
	dataq, ecc, dqs, dm_rdqs
	);

   parameter addr_width=17,
`ifdef DRAM_BANK_BITS2
             bank_width=2,
`else
             bank_width=3,
`endif
	     dqs_width=9;

   // inputs
   input [2:0]             clk;
   input [1:0]		   cs;		   
   input                   ras, cas, we;
   input [(bank_width-1):0] ba;
   input [(addr_width-1):0] addr;
   input [7:0]		   cs_sel;

   // inouts
   inout [63:0] dataq;
   inout [7:0] 		   ecc; 		   
   inout [(dqs_width-1):0]  dqs, dm_rdqs;

   // Local variables

   integer datah, ecch;	// Handles for memory model
   parameter colm_width = 11;
   parameter total_width = bank_width + addr_width + colm_width;
   parameter bank_count = (1 << bank_width);
   parameter depth = 31;
   parameter dly = 400;
   
   // wires

   wire [3:0] ReadLat, ReadLat1, WriteLat;

   // Registers

   reg [(colm_width-1):0]	ColAddr;
   reg [63:0]			dataq_out;
   reg [63:0]			dataq_d;
   reg [7:0]			ecc_out;
   reg [7:0]			ecc_d;
   reg [depth:0]	read_queue;
   reg [depth:0]	write_queue;
   reg [3:0]		AlignLat, BurstLen, CasLat;

   reg [(total_width-1):0]	rd_addr_queue [depth:0];
   reg [(total_width-1):0]	wr_addr_queue [depth:0];
   reg [(addr_width-1):0]	RowAddr [(bank_count-1):0];
   reg [5:0]			dv_cnt;

   reg dataq_oe;
   reg dqs_oe;
   reg dqs_out;

   // Delayed versions of the inputs

   reg [1:0]		 cs_d;		   
   reg                   ras_d, cas_d, we_d;
   reg [(bank_width-1):0] ba_d;
   reg [(addr_width-1):0] addr_d;

   integer n;

//----------------------------------------------------------------------
// Drive outputs
//----------------------------------------------------------------------

  assign dataq = (dataq_oe == 1'b1) ? dataq_out : {64{1'bz}};
  assign ecc = (dataq_oe == 1'b1) ? ecc_out : {8{1'bz}};
  assign dqs = (dqs_oe == 1'b1) ? {dqs_width{dqs_out}} : {dqs_width{1'bz}};
  assign dm_rdqs = (dqs_oe == 1'b1) ? {dqs_width{dqs_out}} : {dqs_width{1'bz}};

//----------------------------------------------------------------------
// Model setup
//----------------------------------------------------------------------
  initial
   begin
	if (!$value$plusargs("SYSTEM_DV_MATCH=%d", dv_cnt)) begin
	    dv_cnt = 2 ;
        end
        dv_cnt = dv_cnt-1;
   end

  `ifdef SYSTEM_DV_MATCH
	assign		 ReadLat = AlignLat+CasLat+dv_cnt; // set DV_CNT = 2 
	assign		 ReadLat1= AlignLat+CasLat;
	assign		 WriteLat = ReadLat1-1;
  `else
	assign		 ReadLat = AlignLat+CasLat;
	assign		 WriteLat = ReadLat-1;
  `endif

//----------------------------------------------------------------------
// Registered / Delayed versions of inputs
//----------------------------------------------------------------------
   always @ (posedge clk[0])
   begin
     ba_d	<= #dly ba;
     addr_d	<= #dly addr;
     cs_d	<= #dly cs;		   
     ras_d	<= #dly ras; 
     cas_d	<= #dly cas; 
     we_d	<= #dly we;
   end
   always @ (posedge dqs[0] or negedge dqs[0])
   begin
     dataq_d	<= #dly dataq;
     ecc_d	<= #dly ecc;
   end
//----------------------------------------------------------------------
// Positive edge clock
//----------------------------------------------------------------------

   always @ (posedge clk[0])
   begin

     if ({cs_d[0], ras_d, cas_d, we_d} == 4'b0101) // Read 
     begin
`ifdef DIMM_DEB
	$display("%d: %m dimm read addr %x",$time,addr_d);
`endif
	ColAddr = {addr_d[colm_width:11],addr_d[9:0]};
	for (n=0; n<BurstLen; n=n+1) begin
	    read_queue[2*ReadLat+n] <= #dly 1'b1;
            rd_addr_queue[2*ReadLat+n] <= #dly {RowAddr[ba_d], ColAddr[10:2], ba_d,
			ColAddr[1:0] + n[1:0]};
	end
     end
     else if ({cs_d[0], ras_d, cas_d, we_d} == 4'b0100) // Write 
     begin
`ifdef DIMM_DEB
	$display("%d: %m dimm write addr %x",$time,addr_d);
`endif
	ColAddr = {addr_d[colm_width:11],addr_d[9:0]};
	for (n=0; n<BurstLen; n=n+1) begin
	    write_queue[2*WriteLat+n+1] <= #dly 1'b1;
            wr_addr_queue[2*WriteLat+n+1] <= #dly 
		{RowAddr[ba_d], ColAddr[10:2], ba_d, ColAddr[1:0] + n[1:0]};
	end
     end
     else if ({cs_d[0], ras_d, cas_d, we_d} == 4'b0011) // RAS 
     begin
`ifdef DIMM_DEB
	$display("%d: %m dimm act addr %x ba %x",$time,addr_d,ba_d);
`endif
	RowAddr[ba_d] = addr_d;
     end
     else if ({cs_d[0], ras_d, cas_d, we_d} == 4'b0000) // Setup 
     begin
`ifdef DIMM_DEB
	$display("%d: %m dimm Setup addr %x ba %x",$time,addr_d,ba_d);
`endif
	if (ba_d == 0) 
	begin
	    BurstLen = (1 << addr_d[2:0]);
	    CasLat = addr_d[6:4];
`ifdef DIMM_DEB
	    $display("%d: %m dimm BurstLen %x CasLat %x",$time,BurstLen,CasLat);
`endif
	end 
	else if (ba_d == 1)
	begin
	    AlignLat = addr_d[5:3];
`ifdef DIMM_DEB
	    $display("%d: %m dimm AlignLat set %x",$time,AlignLat);
`endif
	end
     end

   end // always

//----------------------------------------------------------------------
// Positive and Negative Edge for DDR
//----------------------------------------------------------------------
   always @ (posedge clk[0] or negedge clk[0])
   begin
	for (n=0; n<depth; n=n+1)
	begin
	    read_queue[n] = read_queue[n+1];
	    rd_addr_queue[n] = rd_addr_queue[n+1];
	    wr_addr_queue[n] = wr_addr_queue[n+1];
	    write_queue[n] = write_queue[n+1];
	end

	if (read_queue[2] == 1'b1) dqs_oe = 1'b1;
	else if (read_queue[0] == 1'b0)
	begin
	    dqs_out = 1'b0;
	    dqs_oe = 1'b0;
	end

	if (read_queue[0] == 1'b1)
	begin
	    {ecc_out,dataq_out} = Read_mem(rd_addr_queue[0]);
	    dataq_oe = 1'b1;
	    dqs_out = ~dqs_out;
	    dqs_oe = 1'b1;
	end else begin
	    dataq_oe = 1'b0;
	end

	if (write_queue[0] == 1'b1)
	begin
	    Write_mem(wr_addr_queue[0],{ecc_d,dataq_d});
	end

   end
//----------------------------------------------------------------------
// Read function
//----------------------------------------------------------------------
   function [71:0] Read_mem;

     input [(total_width-1):0] faddr;
     reg [71:0] data;

     begin
	$read_mem(datah,	data[3:0],	faddr, cs_sel);
	$read_mem(datah+1,	data[7:4],	faddr, cs_sel);
	$read_mem(datah+2,	data[11:8],	faddr, cs_sel);
	$read_mem(datah+3,	data[15:12],	faddr, cs_sel);
	$read_mem(datah+4,	data[19:16],	faddr, cs_sel);
	$read_mem(datah+5,	data[23:20],	faddr, cs_sel);
	$read_mem(datah+6,	data[27:24],	faddr, cs_sel);
	$read_mem(datah+7,	data[31:28],	faddr, cs_sel);
	$read_mem(datah+8,	data[35:32],	faddr, cs_sel);
	$read_mem(datah+9,	data[39:36],	faddr, cs_sel);
	$read_mem(datah+10,	data[43:40],	faddr, cs_sel);
	$read_mem(datah+11,	data[47:44],	faddr, cs_sel);
	$read_mem(datah+12,	data[51:48],	faddr, cs_sel);
	$read_mem(datah+13,	data[55:52],	faddr, cs_sel);
	$read_mem(datah+14,	data[59:56],	faddr, cs_sel);
	$read_mem(datah+15,	data[63:60],	faddr, cs_sel);
	$read_mem(ecch,		data[67:64],	faddr, cs_sel);
	$read_mem(ecch+1,	data[71:68],	faddr, cs_sel);

        Read_mem = data;
`ifdef DIMM_DEB
	$display("%d: %m dimm Read_mem addr %x Data %x \n",$time,faddr,data);
`endif
     end

   endfunction


//----------------------------------------------------------------------
// Write task
//----------------------------------------------------------------------
   task Write_mem;
     input [(total_width-1):0] faddr;
     input [71:0] data;

     begin
	$write_mem(datah,	data[3:0],	faddr, cs_sel);
	$write_mem(datah+1,	data[7:4],	faddr, cs_sel);
	$write_mem(datah+2,	data[11:8],	faddr, cs_sel);
	$write_mem(datah+3,	data[15:12],	faddr, cs_sel);
	$write_mem(datah+4,	data[19:16],	faddr, cs_sel);
	$write_mem(datah+5,	data[23:20],	faddr, cs_sel);
	$write_mem(datah+6,	data[27:24],	faddr, cs_sel);
	$write_mem(datah+7,	data[31:28],	faddr, cs_sel);
	$write_mem(datah+8,	data[35:32],	faddr, cs_sel);
	$write_mem(datah+9,	data[39:36],	faddr, cs_sel);
	$write_mem(datah+10,	data[43:40],	faddr, cs_sel);
	$write_mem(datah+11,	data[47:44],	faddr, cs_sel);
	$write_mem(datah+12,	data[51:48],	faddr, cs_sel);
	$write_mem(datah+13,	data[55:52],	faddr, cs_sel);
	$write_mem(datah+14,	data[59:56],	faddr, cs_sel);
	$write_mem(datah+15,	data[63:60],	faddr, cs_sel);
	$write_mem(ecch,	data[67:64],	faddr, cs_sel);
	$write_mem(ecch+1,	data[71:68],	faddr, cs_sel);

`ifdef DIMM_DEB
	$display("%d: %m dimm Write_mem addr %x Data %x \n",$time,faddr,data);
`endif
     end

   endtask

//----------------------------------------------------------------------
// Initialization
//----------------------------------------------------------------------
  initial begin
    dataq_oe = 0;
    dqs_oe = 0;
    dqs_out = 1'b0;
    dataq_out = 64'b0;
    ecc_out = 8'b0;
    for (n=0; n<depth; n=n+1)
    begin
        read_queue[n] = 1'b0;
        rd_addr_queue[n] = {total_width{1'b0}};
        wr_addr_queue[n] = {total_width{1'b0}};
        write_queue[n] = 1'b0;
    end
  end
//----------------------------------------------------------------------

endmodule 
