// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ccx2mb.v
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
/***************************************************************************
 * ccx2mb.v:	An interface that connects the CCX interface of the SPARC
 *		core with the MicroBlaze FSL FIFO.  This block contains an
 *		interface for each direction:
 *		    1.  A processor/cache interface (PCX) to FSL block.
 *		    2.  An FSL to cache/processor interface (CPX) block.
 *
 * $Id: $
 ***************************************************************************/

// Global header file includes


// Local header file includes

`include "ccx2mb.h"


module ccx2mb (
	// Outputs
	pcx_spc_grant_px,
	pcx_fsl_m_control,
	pcx_fsl_m_data,
	pcx_fsl_m_write,

	cpx_spc_data_rdy_cx2,
	cpx_spc_data_cx2,

	cpx_fsl_s_read,

	// Inputs
	gclk,
	reset_l,

	spc_pcx_data_pa,
	spc_pcx_atom_pq,
	spc_pcx_req_pq,

	fsl_pcx_m_full,

	fsl_cpx_s_exists,
	fsl_cpx_s_control,
	fsl_cpx_s_data
	);

    parameter C_EXT_RESET_HIGH = 0;
   
    //=============================================
    // Outputs

    // SPARC/PCX interface
    output [4:0] pcx_spc_grant_px;

    // PCX/FSL interface
    output                    pcx_fsl_m_control;
    output [`FSL_D_WIDTH-1:0] pcx_fsl_m_data;
    output                    pcx_fsl_m_write;

        // SPARC/CPX interface
    output                  cpx_spc_data_rdy_cx2;
    output [`CPX_WIDTH-1:0] cpx_spc_data_cx2;

    // MicroBlaze FSL Interface
    output cpx_fsl_s_read;

    //=============================================
    // Inputs
    input gclk;
    input reset_l;

    // SPARC/PCX interface
    input [`PCX_WIDTH-1:0] spc_pcx_data_pa;
    input                  spc_pcx_atom_pq;
    input [4:0]            spc_pcx_req_pq;

    // PCX/FSL interface
    input fsl_pcx_m_full;

    // MicroBlaze FSL Interface
    input                    fsl_cpx_s_exists;
    input                    fsl_cpx_s_control;
    input [`FSL_D_WIDTH-1:0] fsl_cpx_s_data;

    //=============================================
    // Wire definitions for outputs
    // SPARC/PCX interface
    wire [4:0] pcx_spc_grant_px;

    // PCX/FSL interface
    wire                    pcx_fsl_m_control;
    wire [`FSL_D_WIDTH-1:0] pcx_fsl_m_data;
    wire                    pcx_fsl_m_write;

    // SPARC/CPX interface
    wire                  cpx_spc_data_rdy_cx2;
    wire [`CPX_WIDTH-1:0] cpx_spc_data_cx2;

    // MicroBlaze FSL Interface
    wire cpx_fsl_s_read;

    wire  reset_l_int;
    reg   reset_l_sync;
    reg   sync;
    // Synchronize the incoming reset net into the gclk domain
    always @(posedge gclk) begin
       {reset_l_sync, sync} <= {sync, reset_l};
    end
    assign reset_l_int = C_EXT_RESET_HIGH ? ~reset_l_sync : reset_l_sync;
   
    //=============================================
    // Do we need to put a clock cluster header here?
    // For now, we will have no clock gating.
    wire rclk;
    assign rclk = gclk;


    //=============================================
    // Instantiate pcx2mb

    pcx2mb pcx (
	    // Outputs
	    .pcx_spc_grant_px(pcx_spc_grant_px),
	    .pcx_fsl_m_control(pcx_fsl_m_control),
	    .pcx_fsl_m_data(pcx_fsl_m_data),
	    .pcx_fsl_m_write(pcx_fsl_m_write),

	    // Inputs
	    .rclk(rclk),
	    .reset_l(reset_l_int),

	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .spc_pcx_atom_pq(spc_pcx_atom_pq),
	    .spc_pcx_req_pq(spc_pcx_req_pq),

	    .fsl_pcx_m_full(fsl_pcx_m_full)
	);

    //=============================================
    // Instantiate mb2cpx

    mb2cpx cpx (
	    // Outputs
	    .cpx_spc_data_rdy_cx2(cpx_spc_data_rdy_cx2),
	    .cpx_spc_data_cx2(cpx_spc_data_cx2),

	    .cpx_fsl_s_read(cpx_fsl_s_read),

	    // Inputs
	    .rclk(rclk),
	    .reset_l(reset_l_int),

	    .fsl_cpx_s_exists(fsl_cpx_s_exists),
	    .fsl_cpx_s_control(fsl_cpx_s_control),
	    .fsl_cpx_s_data(fsl_cpx_s_data)
	);

endmodule
