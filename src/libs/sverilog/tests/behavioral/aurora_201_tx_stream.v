///////////////////////////////////////////////////////////////////////////////
//
//      Project:  Aurora Module Generator version 2.8
//
//         Date:  $Date: 2007/09/28 12:50:37 $
//          Tag:  $Name: i+HEAD+134158 $
//         File:  $RCSfile: tx_stream.ejava,v $
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
//  TX_STREAM
//
//
//  Description: The TX_STREAM module converts user data from a streaming interface
//               to Aurora Data, then sends it to the Aurora Channel for transmission.
//               To perform streaming with Aurora, it starts an infinite frame after
//               channel up and performs opporunistic clock correction automatically
//
//               This module supports 1 2-byte lane designs
//

`timescale 1 ns / 10 ps

module aurora_201_TX_STREAM
(
    // Data interface
    TX_D,
    TX_SRC_RDY_N,
    TX_DST_RDY_N,


    // Global Logic Interface
    CHANNEL_UP,
    
    
    //Clock Correction Interface
    DO_CC,
    WARN_CC,


    // Aurora Lane Interface
    GEN_SCP,
    GEN_ECP,
    TX_PE_DATA_V,
    GEN_PAD,
    TX_PE_DATA,
    GEN_CC,


    // System Interface
    USER_CLK


);

`define DLY #1


//***********************************Port Declarations*******************************


    // LocalLink PDU Interface
    input   [0:15]     TX_D;
    input              TX_SRC_RDY_N;

    output             TX_DST_RDY_N;


    // Global Logic Interface
    input              CHANNEL_UP;
    
    
    //Clock Correction Interface
    input              DO_CC;
    input              WARN_CC;


    // Aurora Lane Interface
    output             GEN_SCP;
    output             GEN_ECP;
    output             TX_PE_DATA_V;
    output             GEN_PAD;
    output  [0:15]     TX_PE_DATA;
    output             GEN_CC;


    // System Interface
    input              USER_CLK;


//************************External Register Declarations***********

    reg                GEN_CC;


//************************Register Declarations********************

    //State registers
    reg                rst_r;
    reg                start_r;
    reg                run_r;
    
    reg                tx_dst_rdy_n_r;        
    
    
//*********************************Wire Declarations**********************************

    //FSM nextstate signals
    wire               next_start_c;
    wire               next_run_c;


//*********************************Main Body of Code**********************************



    //____________________________  Data Interface Signals__________________________
    

    // Data interface is ready when the channel is up and running and not forcing a cc
    always @(posedge USER_CLK)
        tx_dst_rdy_n_r  <= `DLY !CHANNEL_UP || !run_r || DO_CC;
        
         
     assign  TX_DST_RDY_N           =   tx_dst_rdy_n_r;   
    
    
    
    //____________________________  Aurora Lane Interface Signals __________________

    
    // Generate CCs whenever DO_CC is asserted. Register the signal to line it up
    // with the cycle when TX_DST_RDY_N is deasserted
    always @(posedge USER_CLK)
        GEN_CC  <=  DO_CC;                                
    
    
    // Send an SCP to start the infinite frame
    assign  GEN_SCP         =   start_r;
    
    
    // Never send ECPs or PADs
    assign  GEN_ECP         =   1'b0;
    assign  GEN_PAD         =   1'd0;

    
    
    
    // Send the user's data directly to the Aurora Lane 
    assign  TX_PE_DATA      =   TX_D;
    
    
    // The data is valid if it is written when the channel is ready and TX_SRC_RDY_N is asserted
    assign  TX_PE_DATA_V    =   !tx_dst_rdy_n_r && !TX_SRC_RDY_N;




    
    
    //_______________  State machine to start infinite frame ______________
    

    // After channel up, the tx stream module  sends an SCP character
    // to start the inifinite frame that will carry the data stream, then 
    // goes to the run state.


    //Control state machine state registers
    always @(posedge USER_CLK)
        if(!CHANNEL_UP) 
        begin
            rst_r       <=  `DLY    1'b1;
            start_r     <=  `DLY    1'b0;
            run_r       <=  `DLY    1'b0;
        end
        else
        begin
            rst_r       <=  `DLY    1'b0;
            start_r     <=  `DLY    next_start_c;
            run_r       <=  `DLY    next_run_c;
        end


    //Nextstate logic
    
    // After reset, send the SCP character to open the infinite 
    // frame 
    assign  next_start_c    =   rst_r;

    
    // After the start state, go to normal operation 
    assign  next_run_c      =   start_r ||
                                run_r;
      
            

endmodule
