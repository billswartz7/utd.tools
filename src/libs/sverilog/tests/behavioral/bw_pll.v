// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_pll.v
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
//
//    Unit Name:  bw_pll (phase-locked loop)
//    Block Name: PLL
//
//-----------------------------------------------------------------------------

`include "sys.h"

`define DEFAULT_JMHZ 200
`define DEFAULT_JDIV 31

`define OSC_DLY      10
`define PLL_START_UP_DLY 50000 

//`define SLOW_CLK_MULT        256

`define SLOW_PLL_WIDTH       100000
`define RAW_CLK_OUTPUT_DLY   300
`define PHASE_LOCK_THRESHOLD 5     // num of matches to detect for 'phase lock'
`define FREQ_STEP_COUNT      3     // ref-clocks spent to step from slow to target freq
`define VCO_OUT_DLY          50    // ps dly vco_reg->vco_out (to guarantee fb dly is non-zero)
`define FEEDBACK_DLY_MAX     10000 // ps dly pll_clk_out->feedback

module bw_pll (

// Inputs:

  pll_sys_clk ,      // Differential System Clock Inputs
  pll_bypass ,       // 0: PLL Output, 1: Bypass Clock
  pll_arst_l ,       // PLL Asynchronous Reset, active low
  l2clk ,            // Feedback Clock from l2clk Grid
  pll_clamp_fltr ,   // Multiplexed Pin. Default=0
  pll_div1 ,         // Frequency Divider 1 : Input Reference, cnt=div1+1
                     // For Niagara div1=0, => divide by 1
  pll_div2 ,         // Frequency Divider 2 : Feedback Clock , cnt=div2+1
                     // Program div2 to desired VCO frequency. 
                     // Ex. sys_clk=200MHz, div2=7, vco=1.6GHz, clk_out=1.6GHz
  pll_div3 ,         // Frequency Divider 3 : Clocktree Drive, cnt=div3+1
                     // For Niagara div3=0, => divide by 1
  vdd_pll ,          // Vdd for PLL
  pll_char_in ,      // Characterization In. Default=0
  testmode ,         // PLL Test Mode. Default=0
  vreg_seldb_l ,     // Default=0

// Outputs:
  pll_raw_clk_out ,  // Raw Clock Output from Differential Reciever
  pll_vco_out ,      // VCO Output
  pll_clk_out ,      // PLL Clock Output to CTU Digital
  pll_clk_out_l ,    // PLL Clock Output to CTU Digital, Invert of cktree_drv
  pll_char_out       // Characterization Output to IO
);

  input [1:0] pll_sys_clk;
  input       pll_bypass;
  input       pll_arst_l;
  input       l2clk;
  input       pll_clamp_fltr;
  input [5:0] pll_div1;
  input [5:0] pll_div2;
  input [5:0] pll_div3;
  input       vdd_pll;
  input       pll_char_in;
  input       testmode;
  input       vreg_seldb_l;
 
  output       pll_raw_clk_out;
  output       pll_vco_out;
  output       pll_clk_out;
  output       pll_clk_out_l;
  output [1:0] pll_char_out;

//synopsys translate_off

  wire  [4:0] jdiv ;  // driven by env. meaningful range is 4 to 24
  reg   [7:0] jmhz ;  // computed here, to be used by env

  integer     ref_clk_last_edge ;
  integer     ref_clk_this_edge ;
  integer     ref_clk_width ;
  reg         ref_clk_vld ;

  reg         slow_ext_clk_reg ;

  reg         fast_ext_clk_reg ;
  integer     fast_ext_clk_jdiv;
  integer     fast_ext_clk_width;

  reg         fast_int_clk_reg ;
  integer     fast_int_clk_jdiv ;
  integer     fast_int_clk_width ;
  integer     fast_int_clk_residue ;

  reg         osc_reg0;
  reg         osc_reg1;
  reg         osc_reg2;
  reg         osc_reg3;
  reg         osc_out;
   
  integer     osc_dly0;
  integer     osc_dly1;
  integer     osc_dly2;
  integer     osc_dly3;

  reg         osc_dly0_set;
  reg         osc_dly1_set;
  reg         osc_dly2_set;
  reg         osc_dly3_set;

  reg         vco_reg;
  reg         vco_off;
  wire        vco_out;

  integer     freq_step_ctr;
  wire        freq_locked ;
  reg         phase_locked;
  reg         edge_locked;
  integer     phase_match_ctr;
  integer     sync_errors;

  wire        ref_clk  = pll_sys_clk[0] ;
  wire        feedback = l2clk ; 

  integer     beg_time, end_time ;

  wire        pll_clk_free ;

  wire        pll_lock = freq_locked && phase_locked &&
                         (phase_match_ctr>`PHASE_LOCK_THRESHOLD) &&
                         (sync_errors==0) ;

  reg         pll_raw_clk_reg ;
   
  // PLL Characterization Ports
  assign pll_char_out[0] =  pll_char_in; // Like this to check connections
  assign pll_char_out[1] = ~pll_char_in; // Like this to check connections

  // PLL Bypass Mux
  assign pll_clk_out   =  pll_bypass ? pll_sys_clk[0] : vco_out ;
  assign pll_clk_out_l = ~pll_clk_out;

  assign pll_clk_free  =  pll_bypass ? fast_ext_clk_reg : osc_out ;
   
  assign pll_vco_out     = vco_out;
  assign pll_raw_clk_out = pll_raw_clk_reg ;

  initial pll_raw_clk_reg = 1'b0 ; 

  always @(pll_sys_clk[0]) begin
    #(`RAW_CLK_OUTPUT_DLY)
    pll_raw_clk_reg = pll_sys_clk[0];
  end

//assign #(`RAW_CLK_OUTPUT_DLY) pll_raw_clk_out = pll_sys_clk[0];
   
  // slow_ext_clk is a free running clock whose frequency is specified by
  // plusarg. This signal is not used internally, but is expected to be
  // tapped externally to drive reference clk
  initial begin
    if (! $value$plusargs("jmhz=%d", jmhz)) jmhz = `DEFAULT_JMHZ ;
    ref_clk_width = 1000000/(2*jmhz) ; // ps
    slow_ext_clk_reg = 1'b0 ;
    forever begin
      #(ref_clk_width) slow_ext_clk_reg = ~slow_ext_clk_reg ; 
    end
  end

  // fast_ext_clk is a free running multiple of slow_ext_clk.
  // It is generated such that exactly 'jdiv' periods of it fit within each
  // of the high or the low windows of slow_ext_clk. 
  // 'jdiv' is a dynamic value which can be driven by the environment at any
  // time, but its value is sampled on every rising edge of slow_ext_clock.
  // Since the period of slow_ext_clk may not divisible by jdiv, the low
  // period of fast_ext_clk just before an edge of slow_ext_clk is stretched
  // if necessary, so that an edge of slow_ext_clk is always coincident with
  // a rising edge of fast_ext_clk.
  // Note that this signal is not used internally. It is expected to be
  // tapped externally to drive vera interface.
  initial begin
    fast_ext_clk_jdiv = `DEFAULT_JDIV ;
    forever begin
      @(jdiv) @(negedge slow_ext_clk_reg) #1
      fast_ext_clk_jdiv = jdiv ;
    end    
  end

  initial begin
    fast_ext_clk_reg = 1'b0 ;
    forever begin
      @(slow_ext_clk_reg)
      fast_ext_clk_reg = 1'b1 ;
      fast_ext_clk_width = ref_clk_width/(2*fast_ext_clk_jdiv) ;
      repeat ((2*fast_ext_clk_jdiv)-1)
        #(fast_ext_clk_width) fast_ext_clk_reg = ~fast_ext_clk_reg ;
    end
  end

  // ref_clk is expected to be driven externally such that its shape exactly
  // matches that of ext_slow_clk (adding a delay is acceptable).
  // The following logic continuously measures period of ref_clk by comparing
  // its width to the expected value.
  initial begin
    ref_clk_vld = 1'b0 ;
    @(posedge ref_clk) ref_clk_last_edge = $time ;
    @(negedge ref_clk) ref_clk_this_edge = $time ;
    forever begin
      @(ref_clk)
      ref_clk_last_edge = ref_clk_this_edge ;
      ref_clk_this_edge = $time ;
      if ((ref_clk_this_edge-ref_clk_last_edge) == ref_clk_width)
        ref_clk_vld = 1'b1 ; 
      else
        ref_clk_vld = 1'b0 ;
    end
  end

  // fast_int_clk is similar to fast_ext_clk except that it is synchronized
  // to ref_clk. It runs at twice the steady state frequency of PLL.
  initial begin
    fast_int_clk_jdiv = `DEFAULT_JDIV ;
    forever begin
      @(jdiv) @(negedge ref_clk) #1
      fast_int_clk_jdiv = jdiv ;
    end    
  end

  initial begin
    fast_int_clk_reg = 1'b0 ;
    #1
    forever begin
      @(ref_clk)
      fast_int_clk_reg = 1'b1 ;
      fast_int_clk_width  = ref_clk_width/(2*fast_int_clk_jdiv) ;
      fast_int_clk_residue= ref_clk_width%(2*fast_int_clk_jdiv) ;
      repeat ((2*fast_int_clk_jdiv)-1)
        #(fast_int_clk_width) fast_int_clk_reg = ~fast_int_clk_reg ;
    end
  end

  // osc_out is the same as fast_int_clk, with a dyamic amount of delay
  // added in. The delay is set to zero at assertion of pll_arst, and
  // then programmed by locking logic. The purpose of this is  to fine
  // tune the edge of the final pll_clk_out.
  // Because the needed delay can be more than fast_int_clk period, it
  // is injected in four smaller chunks.
  initial begin
    osc_reg0 = 0;
    osc_reg1 = 0;
    osc_reg2 = 0;
    osc_reg3 = 0;
    osc_out  = 0;
    osc_dly0 = 0;
    osc_dly1 = 0;
    osc_dly2 = 0;
    osc_dly3 = 0;
    osc_dly0_set = 0;
    osc_dly1_set = 0;
    osc_dly2_set = 0;
    osc_dly3_set = 0;
  end

  always @(negedge pll_arst_l) begin
    osc_dly0 = 0;
    osc_dly1 = 0;
    osc_dly2 = 0;
    osc_dly3 = 0;
    osc_dly0_set = 0;
    osc_dly1_set = 0;
    osc_dly2_set = 0;
    osc_dly3_set = 0;
  end

  always @(posedge fast_int_clk_reg) begin
     #(osc_dly0) osc_reg0 = 1'b1;
  end

  always @(negedge fast_int_clk_reg) begin
     #(osc_dly0) osc_reg0 = 1'b0;
  end
 
  always @(posedge osc_reg0) begin
     #(osc_dly1) osc_reg1 = 1'b1;
  end

  always @(negedge osc_reg0) begin
     #(osc_dly1) osc_reg1 = 1'b0;
  end
 
  always @(posedge osc_reg1) begin
     #(osc_dly2) osc_reg2 = 1'b1;
  end

  always @(negedge osc_reg1) begin
     #(osc_dly2) osc_reg2 = 1'b0;
  end
 
  always @(posedge osc_reg2) begin
     #(osc_dly3) osc_reg3 = 1'b1;
  end

  always @(negedge osc_reg2) begin
     #(osc_dly3) osc_reg3 = 1'b0;
  end
 
  always @(posedge osc_reg3) begin
     #(`OSC_DLY) osc_out = 1'b1;
  end

  always @(negedge osc_reg3) begin
     #(`OSC_DLY) osc_out = 1'b0;
  end

  // freq_step_ctr is used to the divide osc_out to produce pll_clk_out.
  // The value of counter is dynamic. On deassertion of pll_arst_l, the
  // counter counts down towards zero, resulting in a continuously
  // speeding up pll_clk_out. When freq_step_ctr reaches zero, pll is
  // producing its target frequency, and 'frequency is locked'.
  // Note that freq_step_ctr loaded on assertion of pll_arst_l. This is
  // to turn off freq_locked signal.
  reg vco_pump_up ;
   
  initial begin
    freq_step_ctr = `FREQ_STEP_COUNT;
    vco_pump_up   = 1'b1 ;
    #1
    forever begin
      @(pll_arst_l)
      if ( pll_arst_l===0 ) begin
        freq_step_ctr <= `FREQ_STEP_COUNT;
        vco_pump_up   = 1'b0 ;
      end
      else if ( pll_arst_l === 1 ) begin
        #(`PLL_START_UP_DLY); 
        if( pll_arst_l === 1 ) // could be deasserted while waiting
          vco_pump_up = 1'b1 ;
      end
    end
  end
   
  always @(posedge ref_clk) begin
    if ( (freq_step_ctr>0) && (vco_pump_up==1'b1) )
      freq_step_ctr <= freq_step_ctr-1;
  end

  assign freq_locked = (freq_step_ctr===0) ;

  // vco_reg: is same as osc_out, subject to division by freq_step_ctr.
  // -while pll_arst_l is asserted,   vco_reg is low
  // -after pll_arst_l is deasserted, vco_reg steps up to target
  // frequency
  initial begin
    vco_reg = 1'b0;
    vco_off = 1'b0;
  end

  always begin
    if (pll_arst_l === 1'b0) begin
      vco_reg = 1'b0;
      vco_off = 1'b1;
      @(posedge pll_arst_l) ;  
      vco_off  = 0;
    end
   
    else if (vco_pump_up === 1'b0) begin
      @(posedge vco_pump_up or negedge pll_arst_l) ; 
    end

    else begin
       repeat (freq_step_ctr+1) @(posedge osc_out) ;
       vco_reg = ~vco_reg ;
    end
  end

  // vco_out: This is vco_reg subject to shut off by phase locking logic
  // as described below
  assign vco_out = vco_reg & ~vco_off;

  // phase_locking: this logic starts after frequency is locked.
  // There are two components:
  // -gross adjustement: the loop periodically shuts off pll output.
  //  This 'stretch' of pll_clk_out causes a stretch on feedback, and
  //  the edge of feedback gets closer to ref_clk. The proccess
  //  continues until feedback is within one PLL period of ref_clk.
  // -fine adjustment: when  feedback is within one PLL period of
  //  ref_clk, the delay between them is measured, and the value is
  //  injected in the osc_out path. This is done is four steps.
  initial begin
    phase_locked = 0;
    edge_locked  = 0;
  end

  always begin

    if (pll_bypass===1'b1) begin
      @(negedge pll_bypass); 
    end

    else if (pll_arst_l===1'b0) begin
      phase_locked = 0;  
      edge_locked  = 0;
      @(posedge pll_arst_l);        
    end

    else if (freq_locked===1'b0) begin
      @(posedge freq_locked)
      #(`FEEDBACK_DLY_MAX) ;
    end

    else if (phase_locked===1'b0) begin
      @(posedge feedback) beg_time = $time ;
      @(posedge ref_clk)  end_time = $time ;

      if ((end_time-beg_time)<(4*fast_int_clk_width+fast_int_clk_residue)) begin
        phase_locked= 1'b1 ;
      end
           
      else begin
        // skip 1st osc pulse after next edge of ref_clk
        @(ref_clk)
        @(negedge vco_reg)
        #1 // just past the edge
        vco_off <= 1'b1;
        @(vco_reg)
        @(vco_reg)
        #1 // just past the edge
        vco_off <= 1'b0;
        #(`FEEDBACK_DLY_MAX) ; 
      end
    end
     
    else if (edge_locked===1'b1) begin
      @(negedge pll_arst_l) ;
    end

    else if ( osc_dly0_set === 1'b0 ) begin    
      osc_dly0 = (end_time-beg_time)/4;
      osc_dly0_set = 1'b1 ; 
      #(`FEEDBACK_DLY_MAX) ;
    end

    else if ( osc_dly1_set === 1'b0 ) begin    
      osc_dly1 = (end_time-beg_time)/4;
      osc_dly1_set = 1'b1 ; 
      #(`FEEDBACK_DLY_MAX) ;
    end

    else if ( osc_dly2_set === 1'b0 ) begin    
      osc_dly2 = (end_time-beg_time)/4;
      osc_dly2_set = 1'b1 ; 
      #(`FEEDBACK_DLY_MAX) ;
    end

    else if ( osc_dly3_set === 1'b0 ) begin    
      osc_dly3 = (end_time-beg_time) - (osc_dly0+osc_dly1+osc_dly2) ;
      osc_dly3_set = 1'b1 ; 
      #(`FEEDBACK_DLY_MAX) ;
    end

    else begin
      edge_locked = 1;
    end

  end // always begin
   

   
//always @(negedge pll_arst_l) begin
//  vco_off  = 1;
//  phase_locked = 0;  
//  @(posedge pll_arst_l)
//  vco_off  = 0;
//  if (pll_bypass==1'b0) begin
//    @(posedge freq_locked)
//    #(`FEEDBACK_DLY_MAX) ;
//    while (phase_locked==0) begin
//      @(posedge feedback) beg_time = $time ;
//      @(posedge ref_clk)  end_time = $time ;
//      if ((end_time-beg_time)>(4*fast_int_clk_width+fast_int_clk_residue)) begin
//        // skip 1st osc pulse after next edge of ref_clk
//        @(ref_clk)
//        @(negedge vco_reg)
//        #1 // just past the edge
//        vco_off <= 1'b1;
//        @(vco_reg)
//        @(vco_reg)
//        #1 // just past the edge
//        vco_off <= 1'b0;
//        #(`FEEDBACK_DLY_MAX) ; 
//      end
//      else begin
//        osc_dly0 = (end_time-beg_time)/4;
//        #(`FEEDBACK_DLY_MAX) ; 
//        osc_dly1 =  osc_dly0 ;
//        #(`FEEDBACK_DLY_MAX) ; 
//        osc_dly2 =  osc_dly0 ;
//        #(`FEEDBACK_DLY_MAX) ; 
//        osc_dly3 = (end_time-beg_time) - (3*osc_dly0) ;
//        #(`FEEDBACK_DLY_MAX) ; 
//        phase_locked = 1;
//      end
//    end // while (phase_locked==0)
//  end // if (pll_bypass==1'b1)
//end
   
  // phase match tracking: The following logic continuously compares the
  // ref_clk and feedback, and keeps track of consecutive matches.
  // 'pll_lock' requires the count to reach a certain threshold.
  // Mismatch after pll_lock is considered an error.
  initial begin
    phase_match_ctr = 0;
    sync_errors     = 0;
  end

  always @(negedge pll_arst_l) begin
    phase_match_ctr = 0;          
    sync_errors     = 0;
  end

  always @(posedge ref_clk or posedge feedback) begin

      #1 // to go past both edges, when they occur in coincidence
                       
      if ( ref_clk==feedback ) begin
        phase_match_ctr <= phase_match_ctr+1;
      end

      else begin
        // phase mismatch after pll-lock is recorded as error
        if (pll_lock==1) sync_errors <= sync_errors+1;
        phase_match_ctr <= 0;          
      end

  end // always @ (ref_clk or feedback)


  ///////////////////////////////////////////////////////////////////
  // error checkers for signals that should not be changing
  // #10 delay allows for initialization at time 1 by environment
  ///////////////////////////////////////////////////////////////////

  initial begin
    #10 if ( vreg_seldb_l !== 1'b0 )
	`ifdef MODELSIM
      $display("bw_pll", "%m vreg_seldb_l not low at t=1\n" );
	`else  
      $error("bw_pll", "%m vreg_seldb_l not low at t=1\n" );
	`endif  

    forever begin @ ( vreg_seldb_l )    
	`ifdef MODELSIM
      $display("bw_pll", "%m vreg_seldb_l changing during sim\n" );
	`else  
      $error("bw_pll", "%m vreg_seldb_l changing during sim\n" );
	`endif  
    end
  end

  initial begin
    #10 if ( pll_clamp_fltr !== 1'b0 )
	`ifdef MODELSIM
      $display("bw_pll", "%m pll_clamp_fltr not low at t=1\n" );
	`else  
      $error("bw_pll", "%m pll_clamp_fltr not low at t=1\n" );
	`endif
	
    forever begin @ ( pll_clamp_fltr )    
	`ifdef MODELSIM
      $display("bw_pll", "%m pll_clamp_fltr changing during sim\n" );
	`else  
      $error("bw_pll", "%m pll_clamp_fltr changing during sim\n" );
	`endif
    end
  end

//  initial begin
//    #10 if ( testmode !== 1'b0 )
//      $error("bw_pll", "%m testmode not low at t=1\n" );
//
//    forever begin @ ( testmode )    
//      $error("bw_pll", "%m testmode changing during sim\n" );
//    end
//  end

  initial begin
    #10 if ( pll_div1 !== 6'b000000 )
	`ifdef MODELSIM
      $display("bw_pll", "%m pll_div1 not low at t=1\n" );
	`else
      $error("bw_pll", "%m pll_div1 not low at t=1\n" );
	`endif  	

    forever begin @ ( pll_div1 )    
	`ifdef MODELSIM
      $display("bw_pll", "%m pll_div1 changing during sim\n" );
	`else
      $error("bw_pll", "%m pll_div1 changing during sim\n" );
	`endif
    end
  end

  initial begin
    #10 if ( pll_div2 !== 6'b000000 )
	`ifdef MODELSIM
      $display("bw_pll", "%m pll_div2 not low at t=1\n" );
	`else  
      $error("bw_pll", "%m pll_div2 not low at t=1\n" );
 	`endif
	
    forever begin @ ( pll_div2 )    
	`ifdef MODELSIM
      $display("bw_pll", "%m pll_div2 changing during sim\n" );
	`else  
      $error("bw_pll", "%m pll_div2 changing during sim\n" );
	`endif  
    end
  end

  initial begin
    #10 if ( pll_div3 !== 6'b000000 )
	`ifdef MODELSIM
      $display("bw_pll", "%m pll_div3 not low at t=1\n" );
	`else  
      $error("bw_pll", "%m pll_div3 not low at t=1\n" );
	`endif
    forever begin @ ( pll_div3 )    
	`ifdef MODELSIM
      $display("bw_pll", "%m pll_div3 changing during sim\n" );
	`else  
      $error("bw_pll", "%m pll_div3 changing during sim\n" );
	`endif
    end
  end
             
//synopsys translate_on

endmodule    

