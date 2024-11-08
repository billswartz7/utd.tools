// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram_addr_gen_lo.v
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
module dram_addr_gen_lo(/*AUTOARG*/
   // Outputs
   addr_err, rank_adr, stack_adr, bank_adr, ras_adr, cas_adr, addr_parity,
   // Inputs
   addr_in, config_reg, rank1_present, two_channel_mode, eight_bank_mode
   );

input [39:4]	addr_in;
input [8:0]	config_reg;
input		rank1_present;
input		eight_bank_mode;
input		two_channel_mode;

output		addr_parity;
output		addr_err;
output		rank_adr;
output		stack_adr;
output [2:0]	bank_adr;
output [14:0]	ras_adr;
output [13:0]	cas_adr;

//////////////////////////////////////////////////////////////////
// WIRE
//////////////////////////////////////////////////////////////////
wire [14:0]	ras_adr_cas12;
wire [14:0]	ras_adr_cas11;

//////////////////////////////////////////////////////////////////
// Mux the RAS address 
//////////////////////////////////////////////////////////////////
				
assign ras_adr_cas12[14:0] = two_channel_mode ? (
	eight_bank_mode ? (
		rank1_present ? (config_reg[0] ? addr_in[36:22] : addr_in[35:21]) : 
				(config_reg[0] ? addr_in[35:21] : addr_in[34:20])) :
	(rank1_present ? (config_reg[0] ? addr_in[35:21] : addr_in[34:20]) : 
				(config_reg[0] ? addr_in[34:20] : addr_in[33:19])) ) :
	(eight_bank_mode ? (
	rank1_present ? (config_reg[0] ? addr_in[37:23] : addr_in[36:22]) : 
				(config_reg[0] ? addr_in[36:22] : addr_in[35:21])) :
	rank1_present ? (config_reg[0] ? addr_in[36:22] : addr_in[35:21]) : 
				(config_reg[0] ? addr_in[35:21] : addr_in[34:20]));

assign ras_adr_cas11[14:0] = two_channel_mode ? (
	eight_bank_mode ? (
		rank1_present ? (config_reg[0] ? addr_in[35:21] : addr_in[34:20]) : 
				(config_reg[0] ? addr_in[34:20] : addr_in[33:19])) :
	(rank1_present ? (config_reg[0] ? addr_in[34:20] : addr_in[33:19]) : 
				(config_reg[0] ? addr_in[33:19] : addr_in[32:18])) ) :
	(eight_bank_mode ? (
	rank1_present ? (config_reg[0] ? addr_in[36:22] : addr_in[35:21]) : 
				(config_reg[0] ? addr_in[35:21] : addr_in[34:20])) :
	rank1_present ? (config_reg[0] ? addr_in[35:21] : addr_in[34:20]) : 
				(config_reg[0] ? addr_in[34:20] : addr_in[33:19]));

assign ras_adr[14:0] = (config_reg[4:1] == 4'hc) ? ras_adr_cas12[14:0] : ras_adr_cas11[14:0];

wire [7:0] upper_addr_cas12 = two_channel_mode? (
		eight_bank_mode ? (
			rank1_present ? (
				config_reg[0] ? (
					(config_reg[8:5] == 4'hf) ? {5'h0,addr_in[39:37]} :
					(config_reg[8:5] == 4'he) ? {4'h0,addr_in[39:36]} : {3'h0,addr_in[39:35]}) :
				(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:36]} :
                                        (config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:35]} : {2'h0,addr_in[39:34]}) :
			(config_reg[0] ? (
				(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:36]} :
				(config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:35]} : {2'h0,addr_in[39:34]}) :
			(config_reg[8:5] == 4'hf) ? {3'h0,addr_in[39:35]} :
                               	(config_reg[8:5] == 4'he) ? {2'h0,addr_in[39:34]} : {1'h0,addr_in[39:33]})) :
		(rank1_present ? (
			config_reg[0] ? (
				(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:36]} :
				(config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:35]} : {2'h0,addr_in[39:34]}) :
			(config_reg[8:5] == 4'hf) ? {3'h0,addr_in[39:35]} :
                                (config_reg[8:5] == 4'he) ? {2'h0,addr_in[39:34]} : {1'h0,addr_in[39:33]}) :
		(config_reg[0] ? (
			(config_reg[8:5] == 4'hf) ? {3'h0,addr_in[39:35]} :
			(config_reg[8:5] == 4'he) ? {2'h0,addr_in[39:34]} : {1'h0,addr_in[39:33]}) :
		(config_reg[8:5] == 4'hf) ? {2'h0,addr_in[39:34]} :
                       	(config_reg[8:5] == 4'he) ? {1'h0,addr_in[39:33]} : addr_in[39:32]))) :
	eight_bank_mode ? (
		rank1_present ? (
			config_reg[0] ? (
				(config_reg[8:5] == 4'hf) ? {6'h0,addr_in[39:38]} :
				(config_reg[8:5] == 4'he) ? {5'h0,addr_in[39:37]} : {4'h0,addr_in[39:36]}) :
			(config_reg[8:5] == 4'hf) ? {5'h0,addr_in[39:37]} :
                        	(config_reg[8:5] == 4'he) ? {4'h0,addr_in[39:36]} : {3'h0,addr_in[39:35]}) :
		(config_reg[0] ? (
			(config_reg[8:5] == 4'hf) ? {5'h0,addr_in[39:37]} :
			(config_reg[8:5] == 4'he) ? {4'h0,addr_in[39:36]} : {3'h0,addr_in[39:35]}) :
		(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:36]} :
               		(config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:35]} : {2'h0,addr_in[39:34]})) :
	(rank1_present ? (
		config_reg[0] ? (
			(config_reg[8:5] == 4'hf) ? {5'h0,addr_in[39:37]} :
			(config_reg[8:5] == 4'he) ? {4'h0,addr_in[39:36]} : {3'h0,addr_in[39:35]}) :
		(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:36]} :
                        (config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:35]} : {2'h0,addr_in[39:34]}) :
	(config_reg[0] ? (
		(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:36]} :
		(config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:35]} : {2'h0,addr_in[39:34]}) :
	(config_reg[8:5] == 4'hf) ? {3'h0,addr_in[39:35]} :
               	(config_reg[8:5] == 4'he) ? {2'h0,addr_in[39:34]} : {1'h0,addr_in[39:33]})) ;

wire [8:0] upper_addr_cas11 = two_channel_mode? (
		eight_bank_mode ? (
			rank1_present ? (
				config_reg[0] ? (
					(config_reg[8:5] == 4'hf) ? {5'h0,addr_in[39:36]} :
					(config_reg[8:5] == 4'he) ? {4'h0,addr_in[39:35]} : {3'h0,addr_in[39:34]}) :
				(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:35]} :
                                        (config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:34]} : {2'h0,addr_in[39:33]}) :
			(config_reg[0] ? (
				(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:35]} :
				(config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:34]} : {2'h0,addr_in[39:33]}) :
			(config_reg[8:5] == 4'hf) ? {3'h0,addr_in[39:34]} :
                               	(config_reg[8:5] == 4'he) ? {2'h0,addr_in[39:33]} : {1'h0,addr_in[39:32]})) :
		(rank1_present ? (
			config_reg[0] ? (
				(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:35]} :
				(config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:34]} : {2'h0,addr_in[39:33]}) :
			(config_reg[8:5] == 4'hf) ? {3'h0,addr_in[39:34]} :
                                (config_reg[8:5] == 4'he) ? {2'h0,addr_in[39:33]} : {1'h0,addr_in[39:32]}) :
		(config_reg[0] ? (
			(config_reg[8:5] == 4'hf) ? {3'h0,addr_in[39:34]} :
			(config_reg[8:5] == 4'he) ? {2'h0,addr_in[39:33]} : {1'h0,addr_in[39:32]}) :
		(config_reg[8:5] == 4'hf) ? {2'h0,addr_in[39:33]} :
                       	(config_reg[8:5] == 4'he) ? {1'h0,addr_in[39:32]} : addr_in[39:31]))) :
	eight_bank_mode ? (
		rank1_present ? (
			config_reg[0] ? (
				(config_reg[8:5] == 4'hf) ? {6'h0,addr_in[39:37]} :
				(config_reg[8:5] == 4'he) ? {5'h0,addr_in[39:36]} : {4'h0,addr_in[39:35]}) :
			(config_reg[8:5] == 4'hf) ? {5'h0,addr_in[39:36]} :
                        	(config_reg[8:5] == 4'he) ? {4'h0,addr_in[39:35]} : {3'h0,addr_in[39:34]}) :
		(config_reg[0] ? (
			(config_reg[8:5] == 4'hf) ? {5'h0,addr_in[39:36]} :
			(config_reg[8:5] == 4'he) ? {4'h0,addr_in[39:35]} : {3'h0,addr_in[39:34]}) :
		(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:35]} :
               		(config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:34]} : {2'h0,addr_in[39:33]})) :
	(rank1_present ? (
		config_reg[0] ? (
			(config_reg[8:5] == 4'hf) ? {5'h0,addr_in[39:36]} :
			(config_reg[8:5] == 4'he) ? {4'h0,addr_in[39:35]} : {3'h0,addr_in[39:34]}) :
		(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:35]} :
                        (config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:34]} : {2'h0,addr_in[39:33]}) :
	(config_reg[0] ? (
		(config_reg[8:5] == 4'hf) ? {4'h0,addr_in[39:35]} :
		(config_reg[8:5] == 4'he) ? {3'h0,addr_in[39:34]} : {2'h0,addr_in[39:33]}) :
	(config_reg[8:5] == 4'hf) ? {3'h0,addr_in[39:34]} :
               	(config_reg[8:5] == 4'he) ? {2'h0,addr_in[39:33]} : {1'h0,addr_in[39:32]})) ;

wire [8:0] upper_addr = (config_reg[4:1] == 4'hc) ? {1'b0, upper_addr_cas12} : upper_addr_cas11;

wire addr_err = |upper_addr[8:0];

//////////////////////////////////////////////////////////////////
// Mux the CAS address 
//////////////////////////////////////////////////////////////////

assign cas_adr[13:0] = two_channel_mode ? (
	(eight_bank_mode) ? ( 
		(rank1_present) ? ( 
			(config_reg[0]) ? ( 
				(config_reg[4:1] == 4'hc) ? 
				{1'h0,addr_in[21:20],1'b1,addr_in[19:12],addr_in[5:4]} : 
				{2'h0,addr_in[20],1'b1,addr_in[19:12],addr_in[5:4]}) : 
        		((config_reg[4:1] == 4'hc) ? 
				{1'h0,addr_in[20:19],1'b1,addr_in[18:11],addr_in[5:4]} : 
				{2'h0,addr_in[19],1'b1,addr_in[18:11],addr_in[5:4]}) ) :
		(config_reg[0]) ? ( 
			(config_reg[4:1] == 4'hc) ? 
			{1'h0,addr_in[20:19],1'b1,addr_in[18:11],addr_in[5:4]} : 
			{2'h0,addr_in[19],1'b1,addr_in[18:11],addr_in[5:4]}) : 
        	((config_reg[4:1] == 4'hc) ? 
			{1'h0,addr_in[19:18],1'b1,addr_in[17:10],addr_in[5:4]} : 
			{2'h0,addr_in[18],1'b1,addr_in[17:10],addr_in[5:4]}) ) :
	((rank1_present) ? ( 
		(config_reg[0]) ? ( 
			(config_reg[4:1] == 4'hc) ? 
			{1'h0,addr_in[20:19],1'b1,addr_in[18:11],addr_in[5:4]} : 
			{2'h0,addr_in[19],1'b1,addr_in[18:11],addr_in[5:4]})  :
        	((config_reg[4:1] == 4'hc) ? 
			{1'h0,addr_in[19:18],1'b1,addr_in[17:10],addr_in[5:4]} : 
			{2'h0,addr_in[18],1'b1,addr_in[17:10],addr_in[5:4]}) ) :
	(config_reg[0]) ? ( 
		(config_reg[4:1] == 4'hc) ? 
		{1'h0,addr_in[19:18],1'b1,addr_in[17:10],addr_in[5:4]} : 
		{2'h0,addr_in[18],1'b1,addr_in[17:10],addr_in[5:4]}) :
        ((config_reg[4:1] == 4'hc) ? 
		{1'h0,addr_in[18:17],1'b1,addr_in[16:9],addr_in[5:4]} : 
		{2'h0,addr_in[17],1'b1,addr_in[16:9],addr_in[5:4]})) ) :
	((eight_bank_mode) ? ( 
		(rank1_present) ? ( 
			(config_reg[0]) ? ( 
				(config_reg[4:1] == 4'hc) ? 
				{1'h0,addr_in[22:21],1'b1,addr_in[20:13],addr_in[5:4]} : 
				{2'h0,addr_in[21],1'b1,addr_in[20:13],addr_in[5:4]}) : 
        		((config_reg[4:1] == 4'hc) ? 
				{1'h0,addr_in[21:20],1'b1,addr_in[19:12],addr_in[5:4]} : 
				{2'h0,addr_in[20],1'b1,addr_in[19:12],addr_in[5:4]}) ) : 
		(config_reg[0]) ? ( 
			(config_reg[4:1] == 4'hc) ? 
			{1'h0,addr_in[21:20],1'b1,addr_in[19:12],addr_in[5:4]} : 
			{2'h0,addr_in[20],1'b1,addr_in[19:12],addr_in[5:4]}) : 
        	((config_reg[4:1] == 4'hc) ? 
			{1'h0,addr_in[20:19],1'b1,addr_in[18:11],addr_in[5:4]} : 
			{2'h0,addr_in[19],1'b1,addr_in[18:11],addr_in[5:4]}) ) : 
	((rank1_present) ? ( 
		(config_reg[0]) ? ( 
			(config_reg[4:1] == 4'hc) ? 
			{1'h0,addr_in[21:20],1'b1,addr_in[19:12],addr_in[5:4]} : 
			{2'h0,addr_in[20],1'b1,addr_in[19:12],addr_in[5:4]}) : 
        	((config_reg[4:1] == 4'hc) ? 
			{1'h0,addr_in[20:19],1'b1,addr_in[18:11],addr_in[5:4]} : 
			{2'h0,addr_in[19],1'b1,addr_in[18:11],addr_in[5:4]}) ) :
	(config_reg[0]) ? ( 
		(config_reg[4:1] == 4'hc) ? 
		{1'h0,addr_in[20:19],1'b1,addr_in[18:11],addr_in[5:4]} : 
		{2'h0,addr_in[19],1'b1,addr_in[18:11],addr_in[5:4]})  :
        ((config_reg[4:1] == 4'hc) ? 
		{1'h0,addr_in[19:18],1'b1,addr_in[17:10],addr_in[5:4]} : 
		{2'h0,addr_in[18],1'b1,addr_in[17:10],addr_in[5:4]})) ); 


wire rank_adr = two_channel_mode ? (
		eight_bank_mode ? (
			rank1_present ? (config_reg[0] ? addr_in[11] : addr_in[10]) : 1'b0) : 
			rank1_present ? (config_reg[0] ? addr_in[10] : addr_in[9]) : 1'b0) :
		(eight_bank_mode ? (
			rank1_present ? (config_reg[0] ? addr_in[12] : addr_in[11]) : 1'b0) : 
			rank1_present ? (config_reg[0] ? addr_in[11] : addr_in[10]) : 1'b0 ); 

assign stack_adr = two_channel_mode ? (
		eight_bank_mode ? (config_reg[0] ? addr_in[10] : 1'b0) : 
			config_reg[0] ? addr_in[9] : 1'b0) :
		(eight_bank_mode ? (config_reg[0] ? addr_in[11] : 1'b0) : 
			config_reg[0] ? addr_in[10] : 1'b0); 

assign bank_adr[2:0] = two_channel_mode ? (
			eight_bank_mode ? addr_in[9:7] ^ addr_in[20:18] ^ addr_in[30:28] :
                        config_reg[0] ? { stack_adr, addr_in[8:7] ^ addr_in[19:18] ^ addr_in[29:28] } :
                                rank1_present ? {rank_adr, addr_in[8:7] ^ addr_in[19:18] ^ addr_in[29:28] } :
                                {1'b0, addr_in[8:7] ^ addr_in[19:18] ^ addr_in[29:28] }) :
                        (eight_bank_mode ? addr_in[10:8] ^ addr_in[20:18] ^ addr_in[30:28] :
                                config_reg[0] ? { stack_adr, addr_in[9:8] ^ addr_in[19:18] ^ addr_in[29:28]} :
                                rank1_present ? {rank_adr, addr_in[9:8] ^ addr_in[19:18] ^ addr_in[29:28] } :
                                {1'b0, addr_in[9:8] ^ addr_in[19:18] ^ addr_in[29:28] });

wire addr_parity = two_channel_mode ? ^(addr_in[39:7]) : ^(addr_in[39:8]);

endmodule

// Local Variables:
// verilog-library-directories:("." "../../../common/rtl")
// End:

