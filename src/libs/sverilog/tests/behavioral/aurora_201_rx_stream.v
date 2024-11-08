///////////////////////////////////////////////////////////////////////////////
//
//      Project:  Aurora Module Generator version 2.8
//
//         Date:  $Date: 2007/09/28 12:50:36 $
//          Tag:  $Name: i+HEAD+134158 $
//         File:  $RCSfile: rx_stream.ejava,v $
//          Rev:  $Revision: 1.2 $
//
//      Company:  Xilinx
//
//   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
//                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
//                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
//                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
//                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
//                APPLICATION OR STANDARD, XILINX IS MAKING NO
//                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
//                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
//                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
//                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
//                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
//                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
//                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
//                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
//                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
//                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
//                PURPOSE.
//
//                (c) Copyright 2004 Xilinx, Inc.
//                All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////
//
//  RX_STREAM
//
//
//  Description: The RX_LL module receives data from the Aurora Channel,
//               converts it to a simple streaming format. This module expects
//               all data to be carried in a single, infinite frame, and it 
//               expects the data data in lanes to be all valid or all invalid
//
//               This module supports 1 2-byte lane designs.
//
//

`timescale 1 ns / 10 ps

module aurora_201_RX_STREAM
(
    // LocalLink PDU Interface
    RX_D,
    RX_SRC_RDY_N,


    // Global Logic Interface
    START_RX,


    // Aurora Lane Interface
    RX_PAD,
    RX_PE_DATA,
    RX_PE_DATA_V,
    RX_SCP,
    RX_ECP,


    // System Interface
    USER_CLK


);

`define DLY #1


//***********************************Port Declarations*******************************


    // LocalLink PDU Interface
    output  [0:15]     RX_D;
    output             RX_SRC_RDY_N;


    // Global Logic Interface
    input              START_RX;


    // Aurora Lane Interface
    input              RX_PAD;
    input   [0:15]     RX_PE_DATA;
    input              RX_PE_DATA_V;
    input              RX_SCP;
    input              RX_ECP;


    // System Interface
    input              USER_CLK;




//************************Register Declarations********************
    
    reg                infinite_frame_started_r;



//***********************Main Body of Code*************************
    
    
    //Don't start presenting data until the infinite frame starts
    always @(posedge USER_CLK)
        if(!START_RX)
            infinite_frame_started_r    <=  `DLY 1'b0;
        else if(RX_SCP > 1'd0)
            infinite_frame_started_r    <=  `DLY 1'b1;
        
        
    assign  RX_D     =   RX_PE_DATA;
    
    assign  RX_SRC_RDY_N   =   !(RX_PE_DATA_V && infinite_frame_started_r);
    
    
    
endmodule
