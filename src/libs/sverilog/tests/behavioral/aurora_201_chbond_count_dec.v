///////////////////////////////////////////////////////////////////////////////
//
//      Project:  Aurora Module Generator version 2.8
//
//         Date:  $Date: 2007/09/28 12:50:35 $
//          Tag:  $Name: i+HEAD+134158 $
//         File:  $RCSfile: chbond_count_dec_gtp.ejava,v $
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
//  CHBOND_COUNT_DEC
//
//
//  Description: This module decodes the GTP's RXSTATUS signals. RXSTATUS[5] indicates
//               that Channel Bonding is complete
//
//               * Supports GTP
//

`timescale 1 ns / 10 ps

module aurora_201_CHBOND_COUNT_DEC (

    RX_STATUS,
    CHANNEL_BOND_LOAD,
    USER_CLK

);

`define DLY #1

//******************************Parameter Declarations*******************************

    parameter CHANNEL_BOND_LOAD_CODE = 6'b100111;  // Status bus code: Channel Bond load complete

//***********************************Port Declarations*******************************


    input   [5:0]   RX_STATUS;
    output          CHANNEL_BOND_LOAD;

    input           USER_CLK;


//**************************External Register Declarations****************************

    reg             CHANNEL_BOND_LOAD;

//*********************************Main Body of Code**********************************

    always @(posedge USER_CLK)
        CHANNEL_BOND_LOAD <= (RX_STATUS == CHANNEL_BOND_LOAD_CODE);

endmodule
