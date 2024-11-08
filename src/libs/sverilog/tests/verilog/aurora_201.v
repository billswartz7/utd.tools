///////////////////////////////////////////////////////////////////////////////
//
//      Project:  Aurora Module Generator version 2.8
//
//         Date:  $Date: 2007/09/28 12:50:36 $
//          Tag:  $Name: i+HEAD+134158 $
//         File:  $RCSfile: stream_top_gtp.ejava,v $
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
//  aurora_201
//
//
//  Description: This is the top level module for a 1 2-byte lane Aurora
//               reference design module. This module supports the following features:
//
//               * Supports GTP 
//


`timescale 1 ns / 10 ps

module aurora_201 #
(
     parameter   SIM_GTPRESET_SPEEDUP=   0      // Set to 1 to speed up sim reset
)
(
    // TX Stream Interface
    TX_D,
    TX_SRC_RDY_N,
    TX_DST_RDY_N,

    // RX Stream Interface
    RX_D,
    RX_SRC_RDY_N,

    //Clock Correction Interface
    DO_CC,
    WARN_CC,
    
    //GTP Serial I/O
    RXP,
    RXN,
    TXP,
    TXN,

    //GTP Reference Clock Interface
   GTPD4,
    //Error Detection Interface
    HARD_ERROR,
    SOFT_ERROR,

    //Status
    CHANNEL_UP,
    LANE_UP,

    //System Interface
    DCM_NOT_LOCKED,
    USER_CLK,
    SYNC_CLK,
    RESET,
    POWER_DOWN,
    LOOPBACK,
    PMA_INIT,
    TX_LOCK,
    TX_OUT_CLK
);

`define DLY #1


//***********************************Port Declarations*******************************

    // TX Stream Interface
    input   [0:15]     TX_D;
    input              TX_SRC_RDY_N;
    output             TX_DST_RDY_N;

    // RX Stream Interface
    output  [0:15]     RX_D;
    output             RX_SRC_RDY_N;

    // Clock Correction Interface
    input              DO_CC;
    input              WARN_CC;
    
    //GTP Serial I/O
    input              RXP;
    input              RXN;
    output             TXP;
    output             TXN;

    //GTP Reference Clock Interface
    input              GTPD4;

    //Error Detection Interface
    output             HARD_ERROR;
    output             SOFT_ERROR;

    //Status
    output             CHANNEL_UP;
    output             LANE_UP;

    //System Interface
    input              DCM_NOT_LOCKED;
    input              USER_CLK;
    input              SYNC_CLK;
    input              RESET;
    input              POWER_DOWN;
    input   [2:0]      LOOPBACK;
    input              PMA_INIT;
    output             TX_LOCK;    
    output             TX_OUT_CLK;


//*********************************Wire Declarations**********************************

    wire               ch_bond_done_i;
    wire               channel_up_i;
    wire               en_chan_sync_i;
    wire               ena_comma_align_i;
    wire               gen_a_i;
    wire               gen_cc_i;
    wire               gen_ecp_i;
    wire    [0:1]      gen_k_i;
    wire               gen_pad_i;
    wire    [0:1]      gen_r_i;
    wire               gen_scp_i;
    wire    [0:1]      gen_v_i;
    wire    [0:1]      got_a_i;
    wire               got_v_i;
    wire               hard_error_i;
    wire               lane_up_i;
    wire               raw_tx_out_clk_i;
    wire               reset_lanes_i;
    wire               rx_buf_err_i;
    wire    [1:0]      rx_char_is_comma_i;
    wire    [1:0]      rx_char_is_k_i;
    wire    [2:0]      rx_clk_cor_cnt_i;
    wire    [15:0]     rx_data_i;
    wire    [1:0]      rx_disp_err_i;
    wire               rx_ecp_i;
    wire    [1:0]      rx_not_in_table_i;
    wire               rx_pad_i;
    wire    [0:15]     rx_pe_data_i;
    wire               rx_pe_data_v_i;
    wire               rx_polarity_i;
    wire               rx_realign_i;
    wire               rx_reset_i;
    wire               rx_scp_i;
    wire               soft_error_i;
    wire               start_rx_i;
    wire               system_reset_c;
    wire               tied_to_ground_i;
    wire    [47:0]     tied_to_ground_vec_i;
    wire               tied_to_vcc_i;
    wire               tx_buf_err_i;
    wire    [1:0]      tx_char_is_k_i;
    wire    [15:0]     tx_data_i;
    wire               tx_lock_i;
    wire    [0:15]     tx_pe_data_i;
    wire               tx_pe_data_v_i;
    wire               tx_reset_i;
    

//*********************************Main Body of Code**********************************


    //Tie off top level constants
    assign          tied_to_ground_vec_i    = 64'd0;
    assign          tied_to_ground_i        = 1'b0;
    assign          tied_to_vcc_i           = 1'b1;

    
    //Connect top level logic
    assign          CHANNEL_UP  =   channel_up_i;
    assign          system_reset_c = RESET || DCM_NOT_LOCKED || !tx_lock_i ;



    
    //Connect the TXOUTCLK of lane 0 to TX_OUT_CLK
    assign  TX_OUT_CLK  =   raw_tx_out_clk_i;
    
    
    //Connect TX_LOCK to tx_lock_i from lane 0
    assign  TX_LOCK =   tx_lock_i;   
    
    
    //_________________________Instantiate Lane 0______________________________


    assign          LANE_UP =   lane_up_i;
    

    aurora_201_AURORA_LANE aurora_lane_0_i
    (

        //GTP Interface
        .RX_DATA(rx_data_i[15:0]),
        .RX_NOT_IN_TABLE(rx_not_in_table_i[1:0]),
        .RX_DISP_ERR(rx_disp_err_i[1:0]),
        .RX_CHAR_IS_K(rx_char_is_k_i[1:0]),
        .RX_CHAR_IS_COMMA(rx_char_is_comma_i[1:0]),
        .RX_STATUS(tied_to_ground_vec_i[5:0]),
        .TX_BUF_ERR(tx_buf_err_i),
        .RX_BUF_ERR(rx_buf_err_i),
        .RX_REALIGN(rx_realign_i),
        .RX_POLARITY(rx_polarity_i),
        .RX_RESET(rx_reset_i),
        .TX_CHAR_IS_K(tx_char_is_k_i[1:0]),
        .TX_DATA(tx_data_i[15:0]),
        .TX_RESET(tx_reset_i),
        
        
        //Comma Detect Phase Align Interface
        .ENA_COMMA_ALIGN(ena_comma_align_i),


        //TX_LL Interface
        .GEN_SCP(gen_scp_i),
        
        .GEN_ECP(gen_ecp_i),
        .GEN_PAD(gen_pad_i),
        .TX_PE_DATA(tx_pe_data_i[0:15]),
        .TX_PE_DATA_V(tx_pe_data_v_i),
        .GEN_CC(gen_cc_i),


        //RX_LL Interface
        .RX_PAD(rx_pad_i),
        .RX_PE_DATA(rx_pe_data_i[0:15]),
        .RX_PE_DATA_V(rx_pe_data_v_i),
        .RX_SCP(rx_scp_i),
        .RX_ECP(rx_ecp_i),


        //Global Logic Interface
        .GEN_A(gen_a_i),
        .GEN_K(gen_k_i[0:1]),
        .GEN_R(gen_r_i[0:1]),
        .GEN_V(gen_v_i[0:1]),
        .LANE_UP(lane_up_i),
        .SOFT_ERROR(soft_error_i),
        .HARD_ERROR(hard_error_i),
        .CHANNEL_BOND_LOAD(),
        .GOT_A(got_a_i[0:1]),
        .GOT_V(got_v_i),


        //System Interface
        .USER_CLK(USER_CLK),
        .RESET(reset_lanes_i)
    );



    //_________________________Instantiate GTP Wrapper______________________________
 
    aurora_201_GTP_WRAPPER #
    (
         .SIM_GTPRESET_SPEEDUP(SIM_GTPRESET_SPEEDUP)
    )

    gtp_wrapper_i

    (
   
        //Aurora Lane Interface
        .RXPOLARITY_IN(rx_polarity_i),
        .RXRESET_IN(rx_reset_i),
        .TXCHARISK_IN(tx_char_is_k_i[1:0]),
        .TXDATA_IN(tx_data_i[15:0]),
        .TXRESET_IN(tx_reset_i),
        .RXDATA_OUT(rx_data_i[15:0]),
        .RXNOTINTABLE_OUT(rx_not_in_table_i[1:0]),
        .RXDISPERR_OUT(rx_disp_err_i[1:0]),
        .RXCHARISK_OUT(rx_char_is_k_i[1:0]),
        .RXCHARISCOMMA_OUT(rx_char_is_comma_i[1:0]),
        .RXREALIGN_OUT(rx_realign_i),
        .RXBUFERR_OUT(rx_buf_err_i),
        .TXBUFERR_OUT(tx_buf_err_i),


      // Phase Align Interface
        .ENMCOMMAALIGN_IN(ena_comma_align_i),
        .ENPCOMMAALIGN_IN(ena_comma_align_i),
        .RXRECCLK1_OUT(),
        .RXRECCLK2_OUT(),
           


        //Global Logic Interface
        .ENCHANSYNC_IN(en_chan_sync_i),
        .CHBONDDONE_OUT(ch_bond_done_i),


        //Serial IO
        .RX1N_IN(RXN),
        .RX1P_IN(RXP),
        .TX1N_OUT(TXN),
        .TX1P_OUT(TXP),


        // Clocks and Clock Status
        .RXUSRCLK_IN(SYNC_CLK),
        .RXUSRCLK2_IN(USER_CLK),
        .TXUSRCLK_IN(SYNC_CLK),
        .TXUSRCLK2_IN(USER_CLK), 


        .REFCLK(GTPD4),

        .TXOUTCLK1_OUT(raw_tx_out_clk_i),
        .TXOUTCLK2_OUT(),
        .PLLLKDET_OUT(tx_lock_i),


        //System Interface
        .GTPRESET_IN(PMA_INIT),
        .LOOPBACK_IN(LOOPBACK),
        .POWERDOWN_IN(POWER_DOWN)
    );


    //__________Instantiate Global Logic to combine Lanes into a Channel______


    aurora_201_GLOBAL_LOGIC    global_logic_i
    (
        //GTP Interface
        .CH_BOND_DONE(ch_bond_done_i),
        .EN_CHAN_SYNC(en_chan_sync_i),


        //Aurora Lane Interface
        .LANE_UP(lane_up_i),
        .SOFT_ERROR(soft_error_i),
        .HARD_ERROR(hard_error_i),
        .CHANNEL_BOND_LOAD(ch_bond_done_i),
        .GOT_A(got_a_i),
        .GOT_V(got_v_i),
        .GEN_A(gen_a_i),
        .GEN_K(gen_k_i),
        .GEN_R(gen_r_i),
        .GEN_V(gen_v_i),
        .RESET_LANES(reset_lanes_i),


        //System Interface
        .USER_CLK(USER_CLK),
        .RESET(system_reset_c),
        .POWER_DOWN(POWER_DOWN),
        .CHANNEL_UP(channel_up_i),
        .START_RX(start_rx_i),
        .CHANNEL_SOFT_ERROR(SOFT_ERROR),
        .CHANNEL_HARD_ERROR(HARD_ERROR)
    );



    //_____________________________Instantiate TX_STREAM___________________________

    
    aurora_201_TX_STREAM tx_stream_i
    (
        // Data interface
        .TX_D(TX_D),
        .TX_SRC_RDY_N(TX_SRC_RDY_N),
        .TX_DST_RDY_N(TX_DST_RDY_N),


        // Global Logic Interface
        .CHANNEL_UP(channel_up_i),


        //Clock Correction Interface
        .DO_CC(DO_CC),
        .WARN_CC(WARN_CC),
        
        
        // Aurora Lane Interface
        .GEN_SCP(gen_scp_i),
        .GEN_ECP(gen_ecp_i),
        .TX_PE_DATA_V(tx_pe_data_v_i),
        .GEN_PAD(gen_pad_i),
        .TX_PE_DATA(tx_pe_data_i),
        .GEN_CC(gen_cc_i),


        // System Interface
        .USER_CLK(USER_CLK)
    );



    //_____________________________ Instantiate RX_STREAM____________________________
    
    
    aurora_201_RX_STREAM rx_stream_i
    (
        // LocalLink PDU Interface
        .RX_D(RX_D),
        .RX_SRC_RDY_N(RX_SRC_RDY_N),
    
    
        // Global Logic Interface
        .START_RX(start_rx_i),
    
    
        // Aurora Lane Interface
        .RX_PAD(rx_pad_i),
        .RX_PE_DATA(rx_pe_data_i),
        .RX_PE_DATA_V(rx_pe_data_v_i),
        .RX_SCP(rx_scp_i),
        .RX_ECP(rx_ecp_i),
    
   
        // System Interface
        .USER_CLK(USER_CLK)
    );

 

endmodule
