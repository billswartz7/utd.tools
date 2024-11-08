// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: mb2cpx.v
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
 * mb2cpx.v:  An interface file to connect the CPX interface of the SPARC
 *		core with the MicroBlaze FSL FIFO.  This is for data moving
 *		from the MicroBlaze core I/O subsystem to the SPARC core.
 *		The MicroBlaze core will be simulating an L2 Cache and
 *		memory/I/O subsystem, and returning simulated cache packets
 *		back to the SPARC core.
 *
 * $Id: $
 ***************************************************************************/

// Global header file includes


// Local header file includes

`include "ccx2mb.h"


module mb2cpx (
	// Outputs
	cpx_spc_data_rdy_cx2,
	cpx_spc_data_cx2,

	cpx_fsl_s_read,

	// Inputs
	rclk,
	reset_l,

	fsl_cpx_s_exists,
	fsl_cpx_s_control,
	fsl_cpx_s_data
	);

    parameter CPX_GEAR_RATIO = (((`CPX_WIDTH+1-1)/`FSL_D_WIDTH)+1);
    parameter CPX_FSL_EXTRA_BITS  = (`FSL_D_WIDTH * CPX_GEAR_RATIO) -
				    (`CPX_WIDTH+1);

    //=============================================
    // Outputs

    // SPARC/CPX interface
    output                  cpx_spc_data_rdy_cx2;
    output [`CPX_WIDTH-1:0] cpx_spc_data_cx2;

    // MicroBlaze FSL Interface
    output cpx_fsl_s_read;

    //=============================================
    // Inputs
    input rclk;
    input reset_l;

    // MicroBlaze FSL Interface
    input                    fsl_cpx_s_exists;
    input                    fsl_cpx_s_control;
    input [`FSL_D_WIDTH-1:0] fsl_cpx_s_data;

    //=============================================
    // Wire definitions for outputs

    // SPARC/CPX interface
    wire                  cpx_spc_data_rdy_cx2;
    wire [`CPX_WIDTH-1:0] cpx_spc_data_cx2;

    // MicroBlaze FSL Interface
    wire cpx_fsl_s_read;


    wire atomic_txn;
    wire cpx_shift_out;
    reg [CPX_GEAR_RATIO*`FSL_D_WIDTH-1:0] fsl_input_reg;
    reg [`CPX_WIDTH-1:0] cpx_output_reg;

    // Atomic transaction indicator is MSB of the first packet
    assign atomic_txn = fsl_cpx_s_data[`FSL_D_WIDTH-CPX_FSL_EXTRA_BITS-1];

    // Input Shift Register:  Shift 32-bit chunks into wider shift register
    always @(posedge rclk) begin
	fsl_input_reg <= (fsl_cpx_s_exists && cpx_fsl_s_read) ?
		{fsl_input_reg[(CPX_GEAR_RATIO -1)*`FSL_D_WIDTH-1:0],
			fsl_cpx_s_data} :
		fsl_input_reg;
    end

    // Output register
    always @(posedge rclk) begin
	cpx_output_reg <= cpx_shift_out ? fsl_input_reg[`CPX_WIDTH-1:0] :
			cpx_output_reg;
    end

    assign cpx_spc_data_cx2 = cpx_spc_data_rdy_cx2 ? cpx_output_reg : {`CPX_WIDTH{1'b0}};

    //=============================================
    // State Machine Instance
    mb2cpx_sm cpx_sm (
	// Outputs
	.cpx_fsl_s_read(cpx_fsl_s_read),
	.cpx_shift_out(cpx_shift_out),
	.cpx_spc_data_rdy_cx2(cpx_spc_data_rdy_cx2),

	// Inputs
	.rclk(rclk),
	.reset_l(reset_l),

	.fsl_cpx_s_exists(fsl_cpx_s_exists),
	.fsl_cpx_s_control(fsl_cpx_s_control),
	.atomic_txn(atomic_txn)
	);

endmodule
