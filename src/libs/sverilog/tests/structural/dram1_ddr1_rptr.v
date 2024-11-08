// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: dram1_ddr1_rptr.v
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
module dram1_ddr1_rptr( /*AUTOARG*/
   // Outputs
   io_dram_data_valid_buf, io_dram_ecc_in_buf, io_dram_data_in_buf, 
   dram_io_cas_l_buf, dram_io_channel_disabled_buf, dram_io_cke_buf, 
   dram_io_clk_enable_buf, dram_io_drive_data_buf, 
   dram_io_drive_enable_buf, dram_io_pad_clk_inv_buf, 
   dram_io_pad_enable_buf, dram_io_ras_l_buf, dram_io_write_en_l_buf, 
   dram_io_addr_buf, dram_io_bank_buf, dram_io_cs_l_buf, 
   dram_io_data_out_buf, dram_io_ptr_clk_inv_buf, 
   // Inputs
   io_dram_data_valid, io_dram_ecc_in, io_dram_data_in, 
   dram_io_cas_l, dram_io_channel_disabled, dram_io_cke, 
   dram_io_clk_enable, dram_io_drive_data, dram_io_drive_enable, 
   dram_io_pad_clk_inv, dram_io_pad_enable, dram_io_ras_l, 
   dram_io_write_en_l, dram_io_addr, dram_io_bank, dram_io_cs_l, 
   dram_io_data_out, dram_io_ptr_clk_inv
   );

/*OUTPUTS*/
output 		io_dram_data_valid_buf;
output [31:0]	io_dram_ecc_in_buf;
output [255:0]	io_dram_data_in_buf;

output		dram_io_cas_l_buf;
output		dram_io_channel_disabled_buf;
output		dram_io_cke_buf;
output		dram_io_clk_enable_buf;
output		dram_io_drive_data_buf;
output		dram_io_drive_enable_buf;
output		dram_io_pad_clk_inv_buf;
output		dram_io_pad_enable_buf;
output		dram_io_ras_l_buf;
output		dram_io_write_en_l_buf;
output [14:0]	dram_io_addr_buf;
output [2:0]	dram_io_bank_buf;
output [3:0]	dram_io_cs_l_buf;
output [287:0]	dram_io_data_out_buf;
output [4:0]	dram_io_ptr_clk_inv_buf;

/*INPUTS*/
input 		io_dram_data_valid;
input [31:0]	io_dram_ecc_in;
input [255:0]	io_dram_data_in;

input          dram_io_cas_l;
input          dram_io_channel_disabled;
input          dram_io_cke;
input          dram_io_clk_enable;
input          dram_io_drive_data;   
input          dram_io_drive_enable;   
input          dram_io_pad_clk_inv;     
input          dram_io_pad_enable;    
input          dram_io_ras_l;
input          dram_io_write_en_l;
input [14:0]   dram_io_addr;
input [2:0]    dram_io_bank;
input [3:0]    dram_io_cs_l;
input [287:0]  dram_io_data_out;
input [4:0]    dram_io_ptr_clk_inv;


/************************* CODE *********************************/

assign io_dram_data_in_buf                   = io_dram_data_in[255:0]; 
assign io_dram_data_valid_buf                = io_dram_data_valid;   
assign io_dram_ecc_in_buf                    = io_dram_ecc_in[31:0]; 

assign dram_io_addr_buf                      = dram_io_addr[14:0];   
assign dram_io_bank_buf                      = dram_io_bank[2:0];    
assign dram_io_cas_l_buf                     = dram_io_cas_l;       
assign dram_io_channel_disabled_buf          = dram_io_channel_disabled; 
assign dram_io_cke_buf                       = dram_io_cke;          
assign dram_io_clk_enable_buf                = dram_io_clk_enable;   
assign dram_io_cs_l_buf                      = dram_io_cs_l[3:0];    
assign dram_io_data_out_buf                  = dram_io_data_out[287:0]; 
assign dram_io_drive_data_buf                = dram_io_drive_data;   
assign dram_io_drive_enable_buf              = dram_io_drive_enable; 
assign dram_io_pad_clk_inv_buf               = dram_io_pad_clk_inv;  
assign dram_io_pad_enable_buf                = dram_io_pad_enable;   
assign dram_io_ptr_clk_inv_buf               = dram_io_ptr_clk_inv[4:0]; 
assign dram_io_ras_l_buf                     = dram_io_ras_l;        
assign dram_io_write_en_l_buf                = dram_io_write_en_l;   

endmodule
