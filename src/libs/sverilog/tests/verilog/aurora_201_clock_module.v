///////////////////////////////////////////////////////////////////////////////
//
//      Project:  Aurora Module Generator version 2.8
//
//         Date:  $Date: 2007/09/28 12:50:35 $
//          Tag:  $Name: i+HEAD+134158 $
//         File:  $RCSfile: clock_module_gtp.ejava,v $
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
//  CLOCK_MODULE
//
//
//  Description: A module provided as a convenience for desingners using 2-byte 
//               lane Aurora Modules. This module takes the GTP reference clock as
//               input, and produces a divided clock on a global clock net suitable
//               for driving application logic connected to the Aurora User Interface.
//

`timescale 1 ns / 10 ps

module aurora_201_CLOCK_MODULE
(
    GTP_CLK,
    GTP_CLK_LOCKED,
    USER_CLK,
    SYNC_CLK,
    DCM_NOT_LOCKED

);

`define DLY #1


//***********************************Port Declarations*******************************

    input       GTP_CLK;
    input       GTP_CLK_LOCKED;
    output      USER_CLK;
    output      SYNC_CLK;
    output      DCM_NOT_LOCKED;

//*********************************Wire Declarations**********************************

    wire    [15:0]  not_connected_i;
    wire            gtp_clk_not_locked_i;
    wire            clkfb_i;
    wire            clkdv_i;
    wire            clk0_i;
    wire            locked_i;




//*********************************Main Body of Code**********************************


    // Invert gtp clock locked
    assign  gtp_clk_not_locked_i    =   !GTP_CLK_LOCKED;


    // Instantiate a DCM module to divide the reference clock.
    DCM #
    (
        .CLKDV_DIVIDE               (2.0),
        .DFS_FREQUENCY_MODE         ("LOW"),
        .DLL_FREQUENCY_MODE         ("LOW")
    )
    clock_divider_i
    (        
        .CLK0                        (clk0_i),                 // 0 degree DCM CLK ouptput
        .CLK180                      (not_connected_i[0]),     // 180 degree DCM CLK output
        .CLK270                      (not_connected_i[1]),     // 270 degree DCM CLK output
        .CLK2X                       (not_connected_i[2]),     // 2X DCM CLK output
        .CLK2X180                    (not_connected_i[3]),     // 2X, 180 degree DCM CLK out
        .CLK90                       (not_connected_i[4]),     // 90 degree DCM CLK output
        .CLKDV                       (clkdv_i),                // Divided DCM CLK out (CLKDV_DIVIDE)
        .CLKFX                       (not_connected_i[5]),     // DCM CLK synthesis out (M/D)
        .CLKFX180                    (not_connected_i[6]),     // 180 degree CLK synthesis out
        .LOCKED                      (locked_i),               // DCM LOCK status output 
        .PSDONE                      (not_connected_i[7]),     // Dynamic phase adjust done output
        .STATUS                      (not_connected_i[15:8]),  
        .CLKFB                       (clkfb_i),                // DCM clock feedback 
        .CLKIN                       (GTP_CLK),                // Clock input (from IBUFG, BUFG or DCM)
        .DSSEN                       (1'b0),
        .PSCLK                       (1'b0),                   // Dynamic phase adjust clock input
        .PSEN                        (1'b0),                   // Dynamic phase adjust enable input
        .PSINCDEC                    (1'b0),                   // Dynamic phase adjust increment/decrement
        .RST                         (gtp_clk_not_locked_i)    // DCM asynchronous reset input	
    );

   // The DCM_NOT_LOCKED signal is created by inverting the DCM's locked signal.
    assign  DCM_NOT_LOCKED  =   ~locked_i;

    // BUFG for the feedback clock.  The feedback signal is phase aligned to the input
    // and must come from the CLK0 or CLK2X output of the DCM.  In this case, we use
    // the CLK0 output.
    BUFG feedback_clock_net_i
    (
        .I(clk0_i),
        .O(clkfb_i)
    );


    assign  SYNC_CLK =   clkfb_i;


    // The User Clock is distributed on a global clock net.
    BUFG user_clk_net_i
    (
        .I(clkdv_i),
        .O(USER_CLK)
    );


 

endmodule
