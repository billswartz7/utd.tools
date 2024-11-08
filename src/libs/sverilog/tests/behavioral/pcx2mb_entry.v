/***************************************************************************
 * pcx2mb_entry.v:	A single buffer entry for the SPARC PCX to MicroBlaze
 *		FSL Fifo.  This register entry will be instantiated 9 times.
 *
 *		NOTE:  Pipeline stages from SPARC point of view are
 *			PQ	Initial Request
 *			PA	Data sent for request.
 *			PX	Grant returned, Request sent to cache
 *			PX2	Data sent to cache
 *
 * $Id: /import/bw-rainbow/rainbow_cvs/niagara/design/sys/iop/ccx2mb/rtl/pcx2mb_entry.v,v 1.2 2007/04/12 00:08:31 tt147840 Exp $
 ***************************************************************************/

// Global header file includes


// Local header file includes

`include "ccx2mb.h"


module pcx2mb_entry (
	// Outputs
	e_data,
	e_active,
	e_dest,

	// Inputs
	rclk,
	reset_l,

	any_req_pa,
	spc_pcx_data_pa,
	req_dest_pa,
	req_atom_pa,
	any_req_px,
	req_dest_px,
	req_atom_px,
	load_data,

	prev_data,
	prev_active,
	prev_dest,

	next_active
	);

`ifdef PCX2MB_5_BIT_REQ
    parameter PCX_REQ_WIDTH = 5;
`else
    parameter PCX_REQ_WIDTH = 2;
`endif


    output [`PCX_WIDTH+PCX_REQ_WIDTH:0] e_data;
    output       e_active;
    output [4:0] e_dest;

    input rclk;
    input reset_l;

    input                  any_req_pa;
    input [`PCX_WIDTH-1:0] spc_pcx_data_pa;
    input [4:0]            req_dest_pa;
    input                  req_atom_pa;
    input                  any_req_px;
    input [4:0]            req_dest_px;
    input                  req_atom_px;
    input                  load_data;

    input [`PCX_WIDTH+PCX_REQ_WIDTH:0] prev_data;
    input       prev_active;
    input [4:0] prev_dest;

    input       next_active;


    reg [`PCX_WIDTH+PCX_REQ_WIDTH:0] e_data;
    reg       e_active;
    reg [4:0] e_dest;


    // Code for entry here.  If a new request is received while the next entry
    // is active, and this entry is not active, it will be placed into this one.

    always @(posedge rclk) begin
	if (!reset_l) begin
	    e_data <= {`PCX_WIDTH+PCX_REQ_WIDTH+1{1'b0}};
	    e_active <= 1'b0;
	    e_dest <= 5'b00000;
	end
	else if (load_data && prev_active) begin
	    e_data <= prev_data;
	    e_active <= prev_active;
	    e_dest <= prev_dest;
	end
	else if (any_req_pa && (
		    (next_active && !load_data && !e_active) ||
		    (next_active && load_data && e_active && !prev_active)))
	begin
`ifdef PCX2MB_5_BIT_REQ
	    e_data <= { req_dest_pa[4:0], req_atom_pa, spc_pcx_data_pa};
`else
	    e_data <= { req_dest_pa[4], (|req_dest_pa[3:0]), req_atom_pa,
		    	spc_pcx_data_pa};
`endif
	    e_active <= 1'b1;
	    e_dest <= req_dest_pa;
	end
	else if (any_req_px && req_atom_px && (
		    (next_active && !load_data && !e_active) ||
		    (next_active && load_data && e_active && !prev_active)))
	begin
`ifdef PCX2MB_5_BIT_REQ
	    e_data <= { req_dest_px[4:0], req_atom_px, spc_pcx_data_pa};
`else
	    e_data <= { req_dest_px[4], (|req_dest_px[3:0]), 1'b0,
			spc_pcx_data_pa};
`endif
	    e_active <= 1'b1;
	    e_dest <= req_dest_px;
	end
	else begin
	    e_data <= e_data;
	    e_dest <= e_dest;
	    
	    if (load_data && e_active) begin
		e_active <= 1'b0;
	    end
	    else begin
		e_active <= e_active;
	    end
	end
    end

endmodule
