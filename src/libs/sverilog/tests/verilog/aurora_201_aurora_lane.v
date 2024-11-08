///////////////////////////////////////////////////////////////////////////////
//
//      Project:  Aurora Module Generator version 2.8
//
//         Date:  $Date: 2007/09/28 12:50:34 $
//          Tag:  $Name: i+HEAD+134158 $
//         File:  $RCSfile: aurora_lane_gtp.ejava,v $
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
//  AURORA_LANE
//
//
//  Description: The AURORA_LANE module provides a full duplex 2-byte aurora
//               lane connection using a single GTP.  The module handles lane
//               initialization, symbol generation and decoding as well as
//               error detection.  It also decodes some of the channel bonding
//               indicator signals needed by the Global logic.
//
//               * Supports GTP
//

`timescale 1 ns / 10 ps

module aurora_201_AURORA_LANE
(
    // GTP Interface
    RX_DATA,
    RX_NOT_IN_TABLE,
    RX_DISP_ERR,
    RX_CHAR_IS_K,
    RX_CHAR_IS_COMMA,
    RX_STATUS,
    RX_BUF_ERR,
    TX_BUF_ERR,
    RX_REALIGN,
    RX_POLARITY,
    RX_RESET,
    TX_CHAR_IS_K,
    TX_DATA,
    TX_RESET,

    // Comma Detect Phase Align Interface
    ENA_COMMA_ALIGN,

    // TX_LL Interface
    GEN_SCP,
    GEN_ECP,
    GEN_PAD,
    TX_PE_DATA,
    TX_PE_DATA_V,
    GEN_CC,

    // RX_LL Interface
    RX_PAD,
    RX_PE_DATA,
    RX_PE_DATA_V,
    RX_SCP,
    RX_ECP,

    // Global Logic Interface
    GEN_A,
    GEN_K,
    GEN_R,
    GEN_V,
    LANE_UP,
    SOFT_ERROR,
    HARD_ERROR,
    CHANNEL_BOND_LOAD,
    GOT_A,
    GOT_V,

    //System Interface
    USER_CLK,
    RESET
);

//***********************************Port Declarations*******************************


    // GTP Interface
    input   [15:0]  RX_DATA;                // 2-byte data bus from the GTP.
    input   [1:0]   RX_NOT_IN_TABLE;        // Invalid 10-bit code was recieved.
    input   [1:0]   RX_DISP_ERR;            // Disparity error detected on RX interface.
    input   [1:0]   RX_CHAR_IS_K;           // Indicates which bytes of RX_DATA are control.
    input   [1:0]   RX_CHAR_IS_COMMA;       // Comma received on given byte.
    input   [5:0]   RX_STATUS;              // Part of GTP status and error bus.
    input           RX_BUF_ERR;             // Overflow/Underflow of RX buffer detected.
    input           TX_BUF_ERR;             // Overflow/Underflow of TX buffer detected.
    input           RX_REALIGN;             // SERDES was realigned because of a new comma.
    output          RX_POLARITY;            // Controls interpreted polarity of serial data inputs.
    output          RX_RESET;               // Reset RX side of GTP logic.
    output  [1:0]   TX_CHAR_IS_K;           // TX_DATA byte is a control character.
    output  [15:0]  TX_DATA;                // 2-byte data bus to the GTP.
    output          TX_RESET;               // Reset TX side of GTP logic.

    // Comma Detect Phase Align Interface
    output          ENA_COMMA_ALIGN;        // Request comma alignment.

    // TX_LL Interface
    input           GEN_SCP;                // SCP generation request from TX_LL.
    input           GEN_ECP;                // ECP generation request from TX_LL.
    input           GEN_PAD;                // PAD generation request from TX_LL.
    input   [0:15]  TX_PE_DATA;             // Data from TX_LL to send over lane.
    input           TX_PE_DATA_V;           // Indicates TX_PE_DATA is Valid.
    input           GEN_CC;                 // CC generation request from TX_LL.

    // RX_LL Interface
    output          RX_PAD;                 // Indicates lane received PAD.
    output  [0:15]  RX_PE_DATA;             // RX data from lane to RX_LL.
    output          RX_PE_DATA_V;           // RX_PE_DATA is data, not control symbol.
    output          RX_SCP;                 // Indicates lane received SCP.
    output          RX_ECP;                 // Indicates lane received ECP.

    // Global Logic Interface
    input           GEN_A;                  // 'A character' generation request from Global Logic.
    input   [0:1]   GEN_K;                  // 'K character' generation request from Global Logic.
    input   [0:1]   GEN_R;                  // 'R character' generation request from Global Logic.
    input   [0:1]   GEN_V;                  // Verification data generation request.
    output          LANE_UP;                // Lane is ready for bonding and verification.
    output          SOFT_ERROR;             // Soft error detected.
    output          HARD_ERROR;             // Hard error detected.
    output          CHANNEL_BOND_LOAD;      // Channel Bonding done code recieved.
    output  [0:1]   GOT_A;                  // Indicates lane recieved 'A character' bytes.
    output          GOT_V;                  // Verification symbols received.


    // System Interface
    input           USER_CLK;               // System clock for all non-GTP Aurora Logic.
    input           RESET;                  // Reset the lane.


//*********************************Wire Declarations**********************************

    wire            gen_k_i;
    wire    [0:1]   gen_sp_data_i;
    wire    [0:1]   gen_spa_data_i;
    wire            rx_sp_i;
    wire            rx_spa_i;
    wire            rx_neg_i;
    wire            enable_error_detect_i;
    wire            do_word_align_i;
    wire            hard_error_reset_i;

//*********************************Main Body of Code**********************************

    // Lane Initialization state machine
    aurora_201_LANE_INIT_SM lane_init_sm_i
    (
        // GTP Interface
        .RX_NOT_IN_TABLE(RX_NOT_IN_TABLE),
        .RX_DISP_ERR(RX_DISP_ERR),
        .RX_CHAR_IS_COMMA(RX_CHAR_IS_COMMA),
        .RX_REALIGN(RX_REALIGN),

        .RX_RESET(RX_RESET),
        .TX_RESET(TX_RESET),
        .RX_POLARITY(RX_POLARITY),

        // Comma Detect Phase Alignment Interface
        .ENA_COMMA_ALIGN(ENA_COMMA_ALIGN),

        // Symbol Generator Interface
        .GEN_K(gen_k_i),
        .GEN_SP_DATA(gen_sp_data_i),
        .GEN_SPA_DATA(gen_spa_data_i),

        // Symbol Decoder Interface
        .RX_SP(rx_sp_i),
        .RX_SPA(rx_spa_i),
        .RX_NEG(rx_neg_i),

        .DO_WORD_ALIGN(do_word_align_i),

        // Error Detection Logic Interface
        .HARD_ERROR_RESET(hard_error_reset_i),

        .ENABLE_ERROR_DETECT(enable_error_detect_i),

        // Global Logic Interface
        .LANE_UP(LANE_UP),

        // System Interface
        .USER_CLK(USER_CLK),
        .RESET(RESET)

    );


    // Channel Bonding Count Decode module
    aurora_201_CHBOND_COUNT_DEC chbond_count_dec_i
    (
        .RX_STATUS(RX_STATUS),
        .CHANNEL_BOND_LOAD(CHANNEL_BOND_LOAD),
        .USER_CLK(USER_CLK)
    );


    // Symbol Generation module
    aurora_201_SYM_GEN sym_gen_i
    (
        // TX_LL Interface
        .GEN_SCP(GEN_SCP),
        .GEN_ECP(GEN_ECP),
        .GEN_PAD(GEN_PAD),
        .TX_PE_DATA(TX_PE_DATA),
        .TX_PE_DATA_V(TX_PE_DATA_V),
        .GEN_CC(GEN_CC),

        // Global Logic Interface
        .GEN_A(GEN_A),
        .GEN_K(GEN_K),
        .GEN_R(GEN_R),
        .GEN_V(GEN_V),

        // Lane Init SM Interface
        .GEN_K_FSM(gen_k_i),
        .GEN_SP_DATA(gen_sp_data_i),
        .GEN_SPA_DATA(gen_spa_data_i),

        // GTP Interface
        .TX_CHAR_IS_K({TX_CHAR_IS_K[0],TX_CHAR_IS_K[1]}),
        .TX_DATA({TX_DATA[7:0],TX_DATA[15:8]}),

        // System Interface
        .USER_CLK(USER_CLK)
    );


    // Symbol Decode module
    aurora_201_SYM_DEC sym_dec_i
    (
        // RX_LL Interface
        .RX_PAD(RX_PAD),
        .RX_PE_DATA(RX_PE_DATA),
        .RX_PE_DATA_V(RX_PE_DATA_V),
        .RX_SCP(RX_SCP),
        .RX_ECP(RX_ECP),

        // Lane Init SM Interface
        .DO_WORD_ALIGN(do_word_align_i),

        .RX_SP(rx_sp_i),
        .RX_SPA(rx_spa_i),
        .RX_NEG(rx_neg_i),

        // Global Logic Interface
        .GOT_A(GOT_A),
        .GOT_V(GOT_V),

        // GTP Interface
        .RX_DATA({RX_DATA[7:0],RX_DATA[15:8]}),
        .RX_CHAR_IS_K({RX_CHAR_IS_K[0],RX_CHAR_IS_K[1]}),
        .RX_CHAR_IS_COMMA({RX_CHAR_IS_COMMA[0],RX_CHAR_IS_COMMA[1]}),

        // System Interface
        .USER_CLK(USER_CLK),
        .RESET(RESET)
    );


    // Error Detection module
    aurora_201_ERROR_DETECT error_detect_i
    (
        // Lane Init SM Interface
        .ENABLE_ERROR_DETECT(enable_error_detect_i),

        .HARD_ERROR_RESET(hard_error_reset_i),

        // Global Logic Interface
        .SOFT_ERROR(SOFT_ERROR),
        .HARD_ERROR(HARD_ERROR),

        // GTP Interface
        .RX_BUF_ERR(RX_BUF_ERR),
        .RX_DISP_ERR({RX_DISP_ERR[0],RX_DISP_ERR[1]}),
        .RX_NOT_IN_TABLE({RX_NOT_IN_TABLE[0],RX_NOT_IN_TABLE[1]}),
        .TX_BUF_ERR(TX_BUF_ERR),
        .RX_REALIGN(RX_REALIGN),

        // System Interface
        .USER_CLK(USER_CLK)
    );

endmodule
