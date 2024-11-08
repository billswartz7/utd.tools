// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: pcx2mb_sm.v
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
 * pcx2mb_sm.v:	State machine to control shifting out of data.
 *
 *		NOTE:  Pipeline stages from SPARC point of view are
 *			PQ	Initial Request
 *			PA	Data sent for request.
 *			PX	Grant returned, Request sent to cache
 *			PX2	Data sent to cache
 *
 *  $Id: /import/bw-rainbow/rainbow_cvs/niagara/design/sys/iop/ccx2mb/rtl/pcx2mb_sm.v,v 1.5 2007/05/30 22:56:06 tt147840 Exp $
 ***************************************************************************/

// Global header file includes


// Local header file includes
`include  "ccx2mb.h"


module pcx2mb_sm (
	// Outputs
	load_data,
	shift_data,
	entry1_active,
	pcx_fsl_m_control,
	pcx_fsl_m_write,
	pcx_spc_grant_px,

	// Inputs
	rclk,
	reset_l,

	any_req_pq,
	any_req_pa,
	spc_pcx_atom_pq,
	entry1_dest,
	entry2_active,
	entry2_atom,

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

    parameter [2:0] PCX_START_COUNT = PCX_GEAR_RATIO - 1;

    parameter pFLS_IDLE   = 0,
    	      pFLS_LOAD   = 1,
	      pFLS_SHIFT  = 2,
	      pFLS_LDWAIT = 3,
	      pFLS_WAIT   = 4;

    parameter FLS_IDLE   = 5'b00001,
	      FLS_LOAD   = 5'b00010,
	      FLS_SHIFT  = 5'b00100,
	      FLS_LDWAIT = 5'b01000,
	      FLS_WAIT   = 5'b10000;

    output load_data;
    output shift_data;
    output entry1_active;
    output pcx_fsl_m_control;
    output pcx_fsl_m_write;
    output [4:0] pcx_spc_grant_px;

    input rclk;
    input reset_l;

    input any_req_pq;
    input any_req_pa;
    input spc_pcx_atom_pq;
    input [4:0] entry1_dest;
    input entry2_active;
    input entry2_atom;

    input fsl_pcx_m_full;

    wire pcx_fsl_m_control;
    wire pcx_fsl_m_write;

	    // State machine to control the shifting out of the data.
    reg  [4:0] curr_state;
    reg  [4:0] next_state;
    reg  [2:0] curr_count;
    reg  [2:0] next_count;
    reg        data_write;
    reg        next_data_write;
    reg  [4:0] pcx_spc_grant_px;
    reg        next_grant;
    reg        atomic_first;		// First part of an atomic txn
    reg        atomic_second;		// Second part of an atomic txn
    reg        next_atomic_first;
    reg        next_atomic_second;
    reg        atomic_second_d1;
    reg [4:0]  entry1_dest_d1;
    reg        data_control;
    reg        next_control;

    always @ (posedge rclk) begin  // Start with a synchronous reset
	if (!reset_l) begin
	    curr_state <= 5'b00001;
	    curr_count <= 3'b000;
	    data_write <= 1'b0;
	    pcx_spc_grant_px <= 5'b00000;
	    atomic_first <= 1'b0;
	    atomic_second <= 1'b0;
	    data_control <= 1'b0;
	end
	else begin
	    curr_state <= next_state;
	    curr_count <= next_count;
	    data_write <= next_data_write;
	    pcx_spc_grant_px <= {5{next_grant}} & entry1_dest_d1;
	    atomic_first <= next_atomic_first;
	    atomic_second <= next_atomic_second;
	    data_control <= next_control;
	end
    end

    always @(posedge rclk) begin
	atomic_second_d1 <= atomic_second;
	entry1_dest_d1 <= entry1_dest;
    end


    always @ (curr_state or any_req_pq or any_req_pa or entry2_active or
	    curr_count or spc_pcx_atom_pq or atomic_first or atomic_second or
	    atomic_second_d1 or fsl_pcx_m_full or data_write or entry2_atom)
    begin
	case (1)
	    curr_state[pFLS_IDLE] : begin
		next_count = 3'b000;
		next_data_write = 1'b0;
		next_grant = atomic_second_d1;
		next_atomic_second = 1'b0;
		next_control = 1'b0;
		
		if (any_req_pq) begin
		    next_state = FLS_LOAD;
		    next_atomic_first = spc_pcx_atom_pq;
		end
		else begin
		    next_state = FLS_IDLE;
		    next_atomic_first = 1'b0;
		end
	    end

	    curr_state[pFLS_LOAD] : begin
		next_state = FLS_SHIFT;
		next_count = PCX_START_COUNT;
		next_grant = atomic_second_d1;
		next_atomic_first = atomic_first;
		next_atomic_second = atomic_second;
		next_data_write = 1'b1;
		next_control = 1'b1;
	    end

	    curr_state[pFLS_SHIFT] : begin
		if (fsl_pcx_m_full) begin
		    next_state = FLS_SHIFT;
		    next_count = curr_count;
		    next_grant = atomic_second_d1 && !atomic_second;
		    next_atomic_first = atomic_first;
		    next_atomic_second = atomic_second;
		    next_data_write = 1'b1;
		    next_control = (curr_count == PCX_START_COUNT);
		end
		else if (curr_count > 3'd1) begin
		    next_state = FLS_SHIFT;
		    next_count = curr_count-3'b1;
		    next_grant = atomic_second_d1 && !atomic_second;
		    next_atomic_first = atomic_first;
		    next_atomic_second = atomic_second;
		    next_data_write = 1'b1;
		    next_control = 1'b0;
		end
		else if (entry2_active || any_req_pa || any_req_pq) begin
		    next_state = FLS_LDWAIT;
		    next_count = curr_count-3'b1;
		    next_grant = 1'b0;
		    next_atomic_first = atomic_first;
		    next_atomic_second = atomic_second;
		    next_data_write = 1'b1;
		    next_control = 1'b0;
		end
		else begin
		    next_state = FLS_WAIT;
		    next_count = curr_count-3'b1;
		    next_grant = 1'b0;
		    next_atomic_first = atomic_first;
		    next_atomic_second = atomic_second;
		    next_data_write = 1'b1;
		    next_control = 1'b0;
		end
	    end

	    // The last beat of the transaction, and a load is ready
	    // But we can't load until we know the last beat of the last
	    // txn has been accepted
	    curr_state[pFLS_LDWAIT] : begin
		if (fsl_pcx_m_full) begin
		    next_state = FLS_LDWAIT;
		    next_count = curr_count;
		    next_grant = 1'b0;
		    next_atomic_first = atomic_first;
		    next_atomic_second = atomic_second;
		    next_data_write = 1'b1;
		    next_control = 1'b0;
		end
		else begin
		    next_state = FLS_SHIFT;
		    next_count = PCX_START_COUNT;
		    next_grant = !atomic_first;
		    next_atomic_first = entry2_atom;
		    next_atomic_second = atomic_first;
		    next_data_write = 1'b1;
		    next_control = 1'b1;
		end
	    end

	    // The last beat of the transaction:  Don't go to IDLE or
	    // give grant to SPC until we know the beat was accepted.
	    curr_state[pFLS_WAIT] : begin
	        next_control = 1'b0;

		if (fsl_pcx_m_full &&
			(entry2_active || any_req_pa || any_req_pq) ) begin
		    next_state = FLS_LDWAIT;
		    next_count = curr_count;
		    next_grant = 1'b0;
		    next_atomic_first = atomic_first;
		    next_atomic_second = atomic_second;
		    next_data_write = 1'b1;
		end
		else if (fsl_pcx_m_full) begin
		    next_state = FLS_WAIT;
		    next_count = curr_count;
		    next_grant = 1'b0;
		    next_atomic_first = atomic_first;
		    next_atomic_second = atomic_second;
		    next_data_write = 1'b1;
		end
		else if (entry2_active || any_req_pa || any_req_pq) begin
		    next_state = FLS_LOAD;
		    next_grant = !atomic_first;	// No grant on first atomic
		    next_atomic_first = 1'b0;
		    next_atomic_second = atomic_first;
		    next_count = curr_count-3'b1;
		    next_data_write = 1'b0;
		end
		else begin
		    next_state = FLS_IDLE;
		    next_grant = 1'b1;
		    next_atomic_first = 1'b0;
		    next_atomic_second = 1'b0;
		    next_count = curr_count-3'b1;
		    next_data_write = 1'b0;
		end
	    end

	    default : begin
		next_state = FLS_IDLE;
		next_data_write = 1'b0;
		next_count = 3'b000;
		next_grant = 1'b0;
		next_atomic_first = 1'b0;
		next_atomic_second = 1'b0;
		next_control = 1'b0;
	    end
	endcase
    end

    // Outputs of the state machine
    assign load_data = curr_state[pFLS_LOAD] || 
	    (curr_state[pFLS_LDWAIT] && !fsl_pcx_m_full);
    assign shift_data = curr_state[pFLS_SHIFT] && !fsl_pcx_m_full;
    assign entry1_active = !curr_state[pFLS_IDLE] ||
			    (data_write && fsl_pcx_m_full);
    assign pcx_fsl_m_write = data_write && !fsl_pcx_m_full;
    assign pcx_fsl_m_control = data_control;

endmodule
