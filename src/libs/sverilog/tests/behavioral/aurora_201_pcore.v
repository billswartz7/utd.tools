///////////////////////////////////////////////////////////////////////////////
//
//      Project:  Wrapper for aurora_201 core
//
//         Date:  8/4/2008
//
//
`timescale 1 ns / 10 ps
module aurora_201_pcore #
(

     parameter   SIM_GTPRESET_SPEEDUP=   0,      // Set to 1 to speed up sim reset
     parameter   C_EXT_RESET_HIGH = 0
)
(
    // User IO
    RESET,
    USER_CLK,
    HARD_ERROR,
    SOFT_ERROR,
    LANE_UP,
    CHANNEL_UP,
    INIT_CLK,
    PMA_INIT,
    // Tx Stream interface
    TX_D,
    TX_SRC_RDY,
    TX_DST_RDY,
    // RX Stream interface
    RX_D,
    RX_SRC_RDY,
    // Clocks
    GTPD4_P,
    GTPD4_N,
    // GTP I/O
    RXP,
    RXN,
    TXP,
    TXN
);
//***********************************Port Declarations*******************************
    // User I/O
    input              RESET;
    output             USER_CLK;
    input              INIT_CLK;
    input              PMA_INIT;
    output             HARD_ERROR;
    output             SOFT_ERROR;
    output             LANE_UP;
    output             CHANNEL_UP;

    //   TX Stream Interface
    input   [0:15]     TX_D;
    input              TX_SRC_RDY;
    output             TX_DST_RDY;

    // RX Stream Interface
    output  [0:15]     RX_D;
    output             RX_SRC_RDY;
    
    // Clocks
    input              GTPD4_P;
    input              GTPD4_N;
    // GTP I/O
    input              RXP;
    input              RXN;
    output             TXP;
    output             TXN;
//**************************External Register Declarations****************************
    reg                HARD_ERROR;
    reg                SOFT_ERROR;
    reg                FRAME_ERROR;
    reg                LANE_UP;
    reg                CHANNEL_UP;
//**************************Internal Register Declarations****************************
    reg     [0:3]      reset_debounce_r;
    reg     [0:3]      debounce_pma_init_r;
//********************************Wire Declarations**********************************

    wire   [255:0]    ila_data_i;
    wire   [35:0]     icon_ila_i;
    // Stream TX Interface
    wire    [0:15]     tx_d_i;
    wire               tx_src_rdy_n_i;
    wire               tx_dst_rdy_n_i;
    // Stream RX Interface
    wire    [0:15]     rx_d_i;
    wire               rx_src_rdy_n_i;
    // GTP Reference Clock Interface
    wire               GTPD4_left_i;
    // Error Detection Interface
    wire               hard_error_i;
    wire               soft_error_i;
    // Status
    wire               channel_up_i;
    wire               lane_up_i;
    // Clock Compensation Control Interface
    wire               warn_cc_i;
    wire               do_cc_i;
    // System Interface
    wire               dcm_not_locked_i;
    wire               user_clk_i;
    wire               sync_clk_i;
    wire               reset_i;
    wire               power_down_i;
    wire    [0:2]      loopback_i;
    wire               tx_lock_i;
    wire               tx_out_clk_i;
    wire               buf_tx_out_clk_i;
    wire               init_clk_i;
    wire               pma_init_r; 
    //Frame check signals
//*********************************Main Body of Code**********************************
//_______________________________Clock Buffers_________________________________
 IBUFDS IBUFDS
 (
 .I(GTPD4_P),
 .IB(GTPD4_N),
 .O(GTPD4_left_i)
 );
 BUFG BUFG
 (
  .I(tx_out_clk_i),
  .O(buf_tx_out_clk_i)
 );
/*
  assign buf_tx_out_clk_i = tx_out_clk_i;
*/
    // Instantiate a clock module for clock division.
    aurora_201_CLOCK_MODULE clock_module_i
    (
        .GTP_CLK(buf_tx_out_clk_i),
        .GTP_CLK_LOCKED(tx_lock_i),
        .USER_CLK(user_clk_i),
        .SYNC_CLK(sync_clk_i),
        .DCM_NOT_LOCKED(dcm_not_locked_i)
    );

//____________________________Register User I/O___________________________________
// Register User Outputs from core.

    always @(posedge user_clk_i)
    begin
        HARD_ERROR      <=  hard_error_i;
        SOFT_ERROR      <=  soft_error_i;
        LANE_UP         <=  lane_up_i;
        CHANNEL_UP      <=  channel_up_i;
    end

//____________________________Invert ready signals_______________________________
    assign tx_src_rdy_n_i = ~TX_SRC_RDY;
    assign TX_DST_RDY = ~tx_dst_rdy_n_i;
    assign RX_SRC_RDY = ~rx_src_rdy_n_i;
    assign tx_d_i = TX_D;
    assign RX_D = rx_d_i;
    assign USER_CLK = user_clk_i;

//____________________________Tie off unused signals_______________________________
        // System Interface
    assign  power_down_i        =   1'b0;
    assign  loopback_i          =   3'b000;

//_________________Debounce the Reset and PMA init signal___________________________
// Simple Debouncer for Reset button. The debouncer has an
// asynchronous reset tied to PMA_INIT. This is primarily for simulation, to ensure
// that unknown values are not driven into the reset line

    always @(posedge user_clk_i or posedge pma_init_r)
        if(pma_init_r)
            reset_debounce_r    <=  4'b1111;    
        else
            reset_debounce_r    <=  {RESET,reset_debounce_r[0:2]}; //Note: Using active low reset
    assign  reset_i =   &reset_debounce_r;

// Assign an IBUFG to INIT_CLK
/*
    IBUFG init_clk_ibufg_i
    (
        .I(INIT_CLK),
        .O(init_clk_i)
    );
*/
   assign init_clk_i = INIT_CLK;

// Debounce the PMA_INIT signal using the INIT_CLK
    always @(posedge init_clk_i)
        debounce_pma_init_r <=  {PMA_INIT,debounce_pma_init_r[0:2]};
    assign  pma_init_r  =   &debounce_pma_init_r;

//___________________________Module Instantiations_________________________________
    aurora_201 #
    (
        .SIM_GTPRESET_SPEEDUP(SIM_GTPRESET_SPEEDUP)
    )
    aurora_module_i
    (
        // Stream TX Interface
        .TX_D(tx_d_i),
        .TX_SRC_RDY_N(tx_src_rdy_n_i),
        .TX_DST_RDY_N(tx_dst_rdy_n_i),
        // Stream RX Interface
        .RX_D(rx_d_i),
        .RX_SRC_RDY_N(rx_src_rdy_n_i),
        // GTP Serial I/O
        .RXP(RXP),
        .RXN(RXN),
        .TXP(TXP),
        .TXN(TXN),
        // GTP Reference Clock Interface
        .GTPD4(GTPD4_left_i),
        // Error Detection Interface
        .HARD_ERROR(hard_error_i),
        .SOFT_ERROR(soft_error_i),
        // Status
        .CHANNEL_UP(channel_up_i),
        .LANE_UP(lane_up_i),
        // Clock Compensation Control Interface
        .WARN_CC(warn_cc_i),
        .DO_CC(do_cc_i),
        // System Interface
        .DCM_NOT_LOCKED(dcm_not_locked_i),
        .USER_CLK(user_clk_i),
        .SYNC_CLK(sync_clk_i),
        .RESET(reset_i),
        .POWER_DOWN(power_down_i),
        .LOOPBACK(loopback_i),
        .PMA_INIT(pma_init_r),
        .TX_LOCK(tx_lock_i),
        .TX_OUT_CLK(tx_out_clk_i)
    );
    aurora_201_STANDARD_CC_MODULE standard_cc_module_i
    (
        // Clock Compensation Control Interface
        .WARN_CC(warn_cc_i),
        .DO_CC(do_cc_i),
        // System Interface
        .DCM_NOT_LOCKED(dcm_not_locked_i),
        .USER_CLK(user_clk_i),
        .CHANNEL_UP(channel_up_i)
    );

  //-----------------------------------------------------------------
  //
  //  ICON core wire declarations
  //
  //-----------------------------------------------------------------
  wire [35:0] control0;

  //-----------------------------------------------------------------
  //
  //  ICON core instance
  //
  //-----------------------------------------------------------------
//  icon i_icon
//    (
//      .control0(control0)
//    );

  //-----------------------------------------------------------------
  //
  //  ILA Core wire declarations
  //
  //-----------------------------------------------------------------
//  wire [47:0] trig0 = 
//    {HARD_ERROR, SOFT_ERROR, FRAME_ERROR, LANE_UP, CHANNEL_UP, PMA_INIT,
//     tx_dst_rdy_n_i, tx_d_i, rx_src_rdy_n_i, rx_d_i, 
//     6'd0, tx_lock_i, dcm_not_locked_i
//    };

  //-----------------------------------------------------------------
  //
  //  ILA core instance
  //
  //-----------------------------------------------------------------
//  ila i_ila_0
//    (
//      .control(control0),
//      .clk(user_clk_i),
//      .trig0(trig0)
//    );

endmodule

//-------------------------------------------------------------------
//
//  ICON core module declaration
//
//-------------------------------------------------------------------
module icon 
  (
      control0
  );
  output [35:0] control0;
endmodule


//-------------------------------------------------------------------
//
//  ILA core module declaration
//
//-------------------------------------------------------------------
module ila
  (
    control,
    clk,
    trig0
  );
  input [35:0] control;
  input clk;
  input [47:0] trig0;
endmodule





