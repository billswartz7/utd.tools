// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: pcx2mb.v
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
 * pcx2mb.v:	An interface file to connect the PCX interface of the SPARC
 *		core with the MicroBlaze FSL FIFO.
 *
 *		NOTE:  Pipeline stages from SPARC point of view are
 *			PQ	Initial Request
 *			PA	Data sent for request.
 *			PX	Grant returned, Request sent to cache
 *			PX2	Data sent to cache
 *
 * $Id: pcx2mb.v,v 1.8 2007/07/18 16:58:53 tt147840 Exp $
 ***************************************************************************/

// Global header file includes


// Local header file includes

`include "ccx2mb.h"


module pcx2mb (
	// Outputs
	pcx_spc_grant_px,
	pcx_fsl_m_control,
	pcx_fsl_m_data,
	pcx_fsl_m_write,

	// Inputs
	rclk,
	reset_l,

	spc_pcx_data_pa,
	spc_pcx_atom_pq,
	spc_pcx_req_pq,

	fsl_pcx_m_full
	);

`ifdef PCX2MB_5_BIT_REQ
    parameter PCX_REQ_WIDTH = 5;
`else
    parameter PCX_REQ_WIDTH = 2;
`endif

    parameter PCX_GEAR_RATIO = (((`PCX_WIDTH+PCX_REQ_WIDTH)/`FSL_D_WIDTH)+1);
    parameter PCX_FSL_EXTRA_BITS  = (`FSL_D_WIDTH * PCX_GEAR_RATIO) -
				    (`PCX_WIDTH+PCX_REQ_WIDTH+1);

    //=============================================
    // Outputs

    // SPARC/PCX interface
    output [4:0] pcx_spc_grant_px;

    // PCX/FSL interface
    output                    pcx_fsl_m_control;
    output [`FSL_D_WIDTH-1:0] pcx_fsl_m_data;
    output                    pcx_fsl_m_write;

    //=============================================
    // Inputs
    input rclk;
    input reset_l;

    // SPARC/PCX interface
    input [`PCX_WIDTH-1:0] spc_pcx_data_pa;
    input                  spc_pcx_atom_pq;
    input [4:0]            spc_pcx_req_pq;

    // PCX/FSL interface
    input fsl_pcx_m_full;


    
    //=============================================
    // Wire definitions for outputs
    // SPARC/PCX interface
    wire [4:0] pcx_spc_grant_px;

    // PCX/FSL interface
    wire                    pcx_fsl_m_control;
    wire [`FSL_D_WIDTH-1:0] pcx_fsl_m_data;
    wire                    pcx_fsl_m_write;


    wire any_req_pq;
    wire any_req_pa;
    reg  any_req_px;
    wire [4:0] req_dest_pq;
    reg  [4:0] req_dest_pa_raw;
    wire [4:0] req_dest_pa;
    reg  [4:0] req_dest_px;
    reg  req_atom_pa;
    reg  req_atom_px;
    wire [4:0] request_mask_pa;

    // PCX has 5 different request lines for 5 different destinations.
    // The core may send up to three transactions per destination.  The third
    // transaction for a given destination is sent speculatively.  It must be
    // dropped if the grant for the first transaction is not available on the
    // cycle that the third transaction is requested.  The counters below
    // enforce this.

    pcx2mb_link_ctr dest_ctr_0 (
	    .request_mask_pa(request_mask_pa[0]),

	    .rclk(rclk),
	    .reset_l(reset_l),

	    .pcx_req_pa(req_dest_pa[0]),
	    .pcx_req_px(req_dest_px[0]),
	    .pcx_atom_px(req_atom_px),

	    .pcx_grant_px(pcx_spc_grant_px[0])
	    );

    pcx2mb_link_ctr dest_ctr_1 (
	    .request_mask_pa(request_mask_pa[1]),

	    .rclk(rclk),
	    .reset_l(reset_l),

	    .pcx_req_pa(req_dest_pa[1]),
	    .pcx_req_px(req_dest_px[1]),
	    .pcx_atom_px(req_atom_px),

	    .pcx_grant_px(pcx_spc_grant_px[1])
	    );

    pcx2mb_link_ctr dest_ctr_2 (
	    .request_mask_pa(request_mask_pa[2]),

	    .rclk(rclk),
	    .reset_l(reset_l),

	    .pcx_req_pa(req_dest_pa[2]),
	    .pcx_req_px(req_dest_px[2]),
	    .pcx_atom_px(req_atom_px),

	    .pcx_grant_px(pcx_spc_grant_px[2])
	    );

    pcx2mb_link_ctr dest_ctr_3 (
	    .request_mask_pa(request_mask_pa[3]),

	    .rclk(rclk),
	    .reset_l(reset_l),

	    .pcx_req_pa(req_dest_pa[3]),
	    .pcx_req_px(req_dest_px[3]),
	    .pcx_atom_px(req_atom_px),

	    .pcx_grant_px(pcx_spc_grant_px[3])
	    );

    pcx2mb_link_ctr dest_ctr_4 (
	    .request_mask_pa(request_mask_pa[4]),

	    .rclk(rclk),
	    .reset_l(reset_l),

	    .pcx_req_pa(req_dest_pa[4]),
	    .pcx_req_px(req_dest_px[4]),
	    .pcx_atom_px(req_atom_px),

	    .pcx_grant_px(pcx_spc_grant_px[4])
	    );


    // This block routes to only 1 destination, so OR together the bits for
    // request

    assign any_req_pq = | (spc_pcx_req_pq &
	    ~(request_mask_pa & ~pcx_spc_grant_px));
    assign req_dest_pq = spc_pcx_req_pq;
    assign req_dest_pa = req_dest_pa_raw & ~request_mask_pa;
    assign any_req_pa = | req_dest_pa;

    always @ (posedge rclk) begin
	req_dest_pa_raw <= req_dest_pq;
	req_atom_pa <= spc_pcx_atom_pq;

	any_req_px <= any_req_pa;
	req_dest_px <= req_dest_pa;
	req_atom_px <= req_atom_pa;
    end
    
    // Variable definitions for the transaction entries

    wire [`PCX_WIDTH+PCX_REQ_WIDTH:0] entry2_data;
    wire       entry2_active;
    wire [4:0] entry2_dest;
    wire       entry2_atom;
    assign    entry2_atom = entry2_data[`PCX_WIDTH];

    wire [`PCX_WIDTH+PCX_REQ_WIDTH:0] entry3_data;
    wire       entry3_active;
    wire [4:0] entry3_dest;

    wire [`PCX_WIDTH+PCX_REQ_WIDTH:0] entry4_data;
    wire       entry4_active;
    wire [4:0] entry4_dest;

    wire [`PCX_WIDTH+PCX_REQ_WIDTH:0] entry5_data;
    wire       entry5_active;
    wire [4:0] entry5_dest;

    wire [`PCX_WIDTH+PCX_REQ_WIDTH:0] entry6_data;
    wire       entry6_active;
    wire [4:0] entry6_dest;

    wire [`PCX_WIDTH+PCX_REQ_WIDTH:0] entry7_data;
    wire       entry7_active;
    wire [4:0] entry7_dest;

    wire [`PCX_WIDTH+PCX_REQ_WIDTH:0] entry8_data;
    wire       entry8_active;
    wire [4:0] entry8_dest;

    wire [`PCX_WIDTH+PCX_REQ_WIDTH:0] entry9_data;
    wire       entry9_active;
    wire [4:0] entry9_dest;

    wire [`PCX_WIDTH+PCX_REQ_WIDTH:0] entry10_data;
    wire       entry10_active;
    wire [4:0] entry10_dest;

    // The first entry is also a shift register.
    reg [PCX_GEAR_RATIO*`FSL_D_WIDTH-1:0] entry1;
    wire      entry1_active;
    reg       entry1_active_d1;
    reg [4:0] entry1_dest;

    wire load_data;
    wire shift_data;

    // Instantiate 10 copies of a pcx entry register

    // Entry 2
    pcx2mb_entry #(PCX_REQ_WIDTH) i_entry2 (
	    .rclk(rclk),
	    .reset_l(reset_l),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .req_dest_pa(req_dest_pa),
	    .req_atom_pa(req_atom_pa),
	    .any_req_px(any_req_px),
	    .req_dest_px(req_dest_px),
	    .req_atom_px(req_atom_px),
	    .load_data(load_data),

	    .prev_data(entry3_data),
	    .prev_active(entry3_active),
	    .prev_dest(entry3_dest),

	    .next_active(entry1_active & entry1_active_d1),

	    // Output signals
	    .e_data(entry2_data),
	    .e_active(entry2_active),
	    .e_dest(entry2_dest)
    );
    // Entry 3
    pcx2mb_entry #(PCX_REQ_WIDTH) i_entry3 (
	    .rclk(rclk),
	    .reset_l(reset_l),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .req_dest_pa(req_dest_pa),
	    .req_atom_pa(req_atom_pa),
	    .any_req_px(any_req_px),
	    .req_dest_px(req_dest_px),
	    .req_atom_px(req_atom_px),
	    .load_data(load_data),

	    .prev_data(entry4_data),
	    .prev_active(entry4_active),
	    .prev_dest(entry4_dest),

	    .next_active(entry2_active),

	    // Output signals
	    .e_data(entry3_data),
	    .e_active(entry3_active),
	    .e_dest(entry3_dest)
    );
    // Entry 4
    pcx2mb_entry #(PCX_REQ_WIDTH) i_entry4 (
	    .rclk(rclk),
	    .reset_l(reset_l),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .req_dest_pa(req_dest_pa),
	    .req_atom_pa(req_atom_pa),
	    .any_req_px(any_req_px),
	    .req_dest_px(req_dest_px),
	    .req_atom_px(req_atom_px),
	    .load_data(load_data),

	    .prev_data(entry5_data),
	    .prev_active(entry5_active),
	    .prev_dest(entry5_dest),

	    .next_active(entry3_active),

	    // Output signals
	    .e_data(entry4_data),
	    .e_active(entry4_active),
	    .e_dest(entry4_dest)
    );
    // Entry 5
    pcx2mb_entry #(PCX_REQ_WIDTH) i_entry5 (
	    .rclk(rclk),
	    .reset_l(reset_l),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .req_dest_pa(req_dest_pa),
	    .req_atom_pa(req_atom_pa),
	    .any_req_px(any_req_px),
	    .req_dest_px(req_dest_px),
	    .req_atom_px(req_atom_px),
	    .load_data(load_data),

	    .prev_data(entry6_data),
	    .prev_active(entry6_active),
	    .prev_dest(entry6_dest),

	    .next_active(entry4_active),

	    // Output signals
	    .e_data(entry5_data),
	    .e_active(entry5_active),
	    .e_dest(entry5_dest)
    );
    // Entry 6
    pcx2mb_entry #(PCX_REQ_WIDTH) i_entry6 (
	    .rclk(rclk),
	    .reset_l(reset_l),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .req_dest_pa(req_dest_pa),
	    .req_atom_pa(req_atom_pa),
	    .any_req_px(any_req_px),
	    .req_dest_px(req_dest_px),
	    .req_atom_px(req_atom_px),
	    .load_data(load_data),

	    .prev_data(entry7_data),
	    .prev_active(entry7_active),
	    .prev_dest(entry7_dest),

	    .next_active(entry5_active),

	    // Output signals
	    .e_data(entry6_data),
	    .e_active(entry6_active),
	    .e_dest(entry6_dest)
    );
    // Entry 7
    pcx2mb_entry #(PCX_REQ_WIDTH) i_entry7 (
	    .rclk(rclk),
	    .reset_l(reset_l),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .req_dest_pa(req_dest_pa),
	    .req_atom_pa(req_atom_pa),
	    .any_req_px(any_req_px),
	    .req_dest_px(req_dest_px),
	    .req_atom_px(req_atom_px),
	    .load_data(load_data),

	    .prev_data(entry8_data),
	    .prev_active(entry8_active),
	    .prev_dest(entry8_dest),

	    .next_active(entry6_active),

	    // Output signals
	    .e_data(entry7_data),
	    .e_active(entry7_active),
	    .e_dest(entry7_dest)
    );
    // Entry 8
    pcx2mb_entry #(PCX_REQ_WIDTH) i_entry8 (
	    .rclk(rclk),
	    .reset_l(reset_l),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .req_dest_pa(req_dest_pa),
	    .req_atom_pa(req_atom_pa),
	    .any_req_px(any_req_px),
	    .req_dest_px(req_dest_px),
	    .req_atom_px(req_atom_px),
	    .load_data(load_data),

	    .prev_data(entry9_data),
	    .prev_active(entry9_active),
	    .prev_dest(entry9_dest),

	    .next_active(entry7_active),

	    // Output signals
	    .e_data(entry8_data),
	    .e_active(entry8_active),
	    .e_dest(entry8_dest)
    );
    // Entry 9
    pcx2mb_entry #(PCX_REQ_WIDTH) i_entry9 (
	    .rclk(rclk),
	    .reset_l(reset_l),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .req_dest_pa(req_dest_pa),
	    .req_atom_pa(req_atom_pa),
	    .any_req_px(any_req_px),
	    .req_dest_px(req_dest_px),
	    .req_atom_px(req_atom_px),
	    .load_data(load_data),

	    .prev_data(entry10_data),
	    .prev_active(entry10_active),
	    .prev_dest(entry10_dest),

	    .next_active(entry8_active),

	    // Output signals
	    .e_data(entry9_data),
	    .e_active(entry9_active),
	    .e_dest(entry9_dest)
    );
    // Entry 10
    pcx2mb_entry #(PCX_REQ_WIDTH) i_entry10 (
	    .rclk(rclk),
	    .reset_l(reset_l),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_data_pa(spc_pcx_data_pa),
	    .req_dest_pa(req_dest_pa),
	    .req_atom_pa(req_atom_pa),
	    .any_req_px(any_req_px),
	    .req_dest_px(req_dest_px),
	    .req_atom_px(req_atom_px),
	    .load_data(load_data),

	    .prev_data({`PCX_WIDTH+PCX_REQ_WIDTH+1{1'b0}}),
	    .prev_active(1'b0),
	    .prev_dest(5'b00000),

	    .next_active(entry9_active),

	    // Output signals
	    .e_data(entry10_data),
	    .e_active(entry10_active),
	    .e_dest(entry10_dest)
    );




    // State machine to control the shifting out of the data.

    pcx2mb_sm shft_state (
	    .load_data(load_data),
	    .shift_data(shift_data),
	    .entry1_active(entry1_active),
	    .pcx_fsl_m_control(pcx_fsl_m_control),
	    .pcx_fsl_m_write(pcx_fsl_m_write),
	    .pcx_spc_grant_px(pcx_spc_grant_px),

	    .rclk(rclk),
	    .reset_l(reset_l),

	    .any_req_pq(any_req_pq),
	    .any_req_pa(any_req_pa),
	    .spc_pcx_atom_pq(spc_pcx_atom_pq),
	    .entry1_dest(entry1_dest),
	    .entry2_active(entry2_active),
	    .entry2_atom(entry2_atom),

	    .fsl_pcx_m_full(fsl_pcx_m_full)
	    );


    // Define a shift register to shift data out into the narrower FSL bus

    always @(posedge rclk) begin
	if (!reset_l) begin
	    entry1 <= {PCX_GEAR_RATIO*`FSL_D_WIDTH{1'b0}};
	    entry1_dest <= 5'b00000;
	end
	else if (shift_data) begin
	    entry1 <= entry1 << `FSL_D_WIDTH;
	    entry1_dest <= entry1_dest;
	end
	else if (load_data && entry2_active) begin
	    entry1 <= { {PCX_FSL_EXTRA_BITS{1'b0}},entry2_data};
	    entry1_dest <= entry2_dest;
	end
	else if (load_data) begin
`ifdef PCX2MB_5_BIT_REQ
	    entry1 <= { {PCX_FSL_EXTRA_BITS{1'b0}},
			req_dest_pa[4:0], req_atom_pa, spc_pcx_data_pa};
`else
	    entry1 <= { {PCX_FSL_EXTRA_BITS{1'b0}}, req_dest_pa[4],
			(|req_dest_pa[3:0]), req_atom_pa, spc_pcx_data_pa};
`endif
	    entry1_dest <= req_dest_pa;
	end
	else begin
	    entry1 <= entry1;
	    entry1_dest <= entry1_dest;
	end
    end

    always @(posedge rclk) begin
	entry1_active_d1 <= entry1_active;
    end

    // Output Data
    assign pcx_fsl_m_data = entry1[PCX_GEAR_RATIO*`FSL_D_WIDTH-1:(PCX_GEAR_RATIO-1)*`FSL_D_WIDTH];

endmodule
