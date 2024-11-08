// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ccx_arbdp.v
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
///////////////////////////////////////////////////////////////////////
/*
//
//  Module Name:  ccx_arbdp.v 
//	Description:	Datapath portion of arbiter
*/
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////

`include	"sys.h" // system level definition file which contains the 
			// time scale definition

`include "iop.h"


////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////


// Code start here 
//

module ccx_arbdp(/*AUTOARG*/
   // Outputs
   arb_dp_grant_a, arb_src7_grant_a, arb_src6_grant_a, 
   arb_src5_grant_a, arb_src4_grant_a, arb_src3_grant_a, 
   arb_src2_grant_a, arb_src1_grant_a, arb_src0_grant_a, 
   ccx_dest_data_rdy_a, ccx_dest_atom_a, req_pkt_empty, grant_a, 
   inreg_req_vld_d1, 
   // Inputs
   src7_arb_atom_q, src6_arb_atom_q, src5_arb_atom_q, 
   src4_arb_atom_q, src3_arb_atom_q, src2_arb_atom_q, 
   src1_arb_atom_q, src0_arb_atom_q, src7_arb_req_q, src6_arb_req_q, 
   src5_arb_req_q, src4_arb_req_q, src3_arb_req_q, src2_arb_req_q, 
   src1_arb_req_q, src0_arb_req_q, reset_d1, qfull, direction, 
   stall_a, fifo_req_sel, current_req_sel, input_req_sel, 
   input_req_sel_d1, fifo_bypass, fifo_bypass_l, wrptr_l, rdptr, 
   fifo_sel15_12, fifo_sel11_8, fifo_sel7_4, fifo_sel3_0, fifo_valid, 
   arbctl_atom, rclk, se
   );
   

//Primary outputs to ccx datapaths
   output [7:0] arb_dp_grant_a; //to ccx datapath
		 
//Output to source: sparc or sctag grant flops
   output 		      arb_src7_grant_a;
   output 		      arb_src6_grant_a;
   output 		      arb_src5_grant_a;
   output 		      arb_src4_grant_a;
   output 		      arb_src3_grant_a;
   output 		      arb_src2_grant_a;
   output 		      arb_src1_grant_a;
   output 		      arb_src0_grant_a;
   
//Output to arb control logic
   output 		      ccx_dest_data_rdy_a;
   output 		      ccx_dest_atom_a;
   output 		      req_pkt_empty;
   output [7:0]               grant_a;      
   output 		      inreg_req_vld_d1;
   
		 //Primary inputs from sources		 
		 input 	      src7_arb_atom_q;//indicates 2 packet transaction
		 input 	      src6_arb_atom_q;
		 input 	      src5_arb_atom_q;
		 input 	      src4_arb_atom_q;
		 input 	      src3_arb_atom_q;
		 input 	      src2_arb_atom_q;
		 input 	      src1_arb_atom_q;
		 input 	      src0_arb_atom_q;
		 
		 
		 input 	      src7_arb_req_q;//indicates request from source
		 input 	      src6_arb_req_q;
		 input 	      src5_arb_req_q;
		 input 	      src4_arb_req_q;
		 input 	      src3_arb_req_q;
		 input 	      src2_arb_req_q;
		 input 	      src1_arb_req_q;
		 input 	      src0_arb_req_q;
		 
		 //Primary inputs from destinations

		 //Primary inputs from arbiter control logic
		 input        reset_d1; //reset latched in ctl
		 input [7:0]  qfull;
		 input 	      direction;
                 input        stall_a; //stall input driven from control
		 input 	      fifo_req_sel, current_req_sel;
		 input 	      input_req_sel, input_req_sel_d1;
		 input        fifo_bypass, fifo_bypass_l;//selects for fifo byp mux
                 input [15:0]  wrptr_l; //write pointer for fifo.
		 input [15:0]  rdptr;
		 input         fifo_sel15_12, fifo_sel11_8, fifo_sel7_4, fifo_sel3_0;
                 input       fifo_valid;
                 input [7:0]  arbctl_atom;
   
		 //Global signals
		 input        rclk;
                 //input 	      tmb_l;
                 input 	      se ;
   
		 //Wires between FIFO and PE sections
                 wire [7:0]   req_q, atom_q;
   
		 wire [7:0]   fq_req, fq_atomic;//fq-> fifo or qual from 
		 wire 	      fq_dir;            //     current packet
		 wire [7:0]   qual_req, qual_atomic,qual_atomic_d1;//fq-> qual from 
		 wire 	      qual_dir;            //     current packet
		 wire [7:0]   fifo_req, fifo_atomic;//fq-> from fifo 
		 wire 	      fifo_dir;            //     
		 wire [7:0]   req_fifo_a, atom_fifo_a;
		 //Wires within PE section
                 wire [7:0]   fq_atomic_a, fq_req_a;
		 wire [7:0]   grant_asc, grant_des, grant_a;
		 wire [7:0]   qfull_a;
		 wire [7:0]   req_a, atom_a;
		 wire [7:0]   req, atom;
		 wire         dir_a;
   wire 		      dira, dird;//asc & desc PE selects
   
		 //Wires within FIFO section
		 //write data
		 wire [8:0]  fifo_wdata;
		 //read data
		 wire [8:0]  fifo_rdata15;
		 wire [8:0]  fifo_rdata14;
		 wire [8:0]  fifo_rdata13;
		 wire [8:0]  fifo_rdata12;
		 wire [8:0]  fifo_rdata11;
		 wire [8:0]  fifo_rdata10;
		 wire [8:0]  fifo_rdata9;
		 wire [8:0]  fifo_rdata8;
		 wire [8:0]  fifo_rdata7;
		 wire [8:0]  fifo_rdata6;
		 wire [8:0]  fifo_rdata5;
		 wire [8:0]  fifo_rdata4;
		 wire [8:0]  fifo_rdata3;
		 wire [8:0]  fifo_rdata2;
		 wire [8:0]  fifo_rdata1;
		 wire [8:0]  fifo_rdata0;
		 wire [8:0]  fifo_rdata15_12;
		 wire [8:0]  fifo_rdata11_8;
		 wire [8:0]  fifo_rdata7_4;
		 wire [8:0]  fifo_rdata3_0;
		 wire [8:0]  fifo_rdata15_0;
                 wire [8:0]  fifo_rdata;
   
		 //gated clocks
		 wire [15:0]  clk_fifo_write;

		 

		 
assign atom_q[7:0] = { src7_arb_atom_q,
			src6_arb_atom_q,
			src5_arb_atom_q,
			src4_arb_atom_q,
			src3_arb_atom_q,
			src2_arb_atom_q,
			src1_arb_atom_q,
			src0_arb_atom_q };



assign req_q[7:0] =    { src7_arb_req_q,
			src6_arb_req_q,
			src5_arb_req_q,
			src4_arb_req_q,
			src3_arb_req_q,
			src2_arb_req_q,
			src1_arb_req_q,
			src0_arb_req_q };
 //BEGIN FIFO SECTION
		 assign req_fifo_a[7:0] = ~qfull_a[7:0] & req_a[7:0] ;
		 assign atom_fifo_a[7:0] =  ~qfull_a[7:0] & req_a[7:0] & atom_a[7:0] ;
//		 assign fifo_wdata[16:0] = {dir_a,atom_fifo_a[7:0], req_fifo_a[7:0]};
		 assign fifo_wdata[8:0] = {dir_a, req_fifo_a[7:0]};

		 //create gated clocks

//replace tmb_l w/ ~se
wire  se_l ;
assign se_l =  ~se ;


   clken_buf ck0(
      .clk               (clk_fifo_write[0]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[0]),
      .tmb_l               (se_l));
   clken_buf ck1(
      .clk               (clk_fifo_write[1]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[1]),
      .tmb_l               (se_l));
   clken_buf ck2(
      .clk               (clk_fifo_write[2]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[2]),
      .tmb_l               (se_l));
   clken_buf ck3(
      .clk               (clk_fifo_write[3]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[3]),
      .tmb_l               (se_l));
   clken_buf ck4(
      .clk               (clk_fifo_write[4]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[4]),
      .tmb_l               (se_l));
   clken_buf ck5(
      .clk               (clk_fifo_write[5]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[5]),
      .tmb_l               (se_l));
   clken_buf ck6(
      .clk               (clk_fifo_write[6]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[6]),
      .tmb_l               (se_l));
   clken_buf ck7(
      .clk               (clk_fifo_write[7]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[7]),
      .tmb_l               (se_l));
   clken_buf ck8(
      .clk               (clk_fifo_write[8]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[8]),
      .tmb_l               (se_l));
   clken_buf ck9(
      .clk               (clk_fifo_write[9]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[9]),
      .tmb_l               (se_l));
   clken_buf ck10(
      .clk               (clk_fifo_write[10]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[10]),
      .tmb_l               (se_l));
   clken_buf ck11(
      .clk               (clk_fifo_write[11]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[11]),
      .tmb_l               (se_l));
   clken_buf ck12(
      .clk               (clk_fifo_write[12]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[12]),
      .tmb_l               (se_l));
   clken_buf ck13(
      .clk               (clk_fifo_write[13]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[13]),
      .tmb_l               (se_l));
   clken_buf ck14(
      .clk               (clk_fifo_write[14]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[14]),
      .tmb_l               (se_l));
   clken_buf ck15(
      .clk               (clk_fifo_write[15]),
      .rclk              (rclk),
      .enb_l               (wrptr_l[15]),
      .tmb_l               (se_l));



   

 //create flop memory
 dff_s #(9) dff_ccx_arb_fmem15(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata15[8:0]),
	.clk            (clk_fifo_write[15]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		

 dff_s #(9) dff_ccx_arb_fmem14(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata14[8:0]),
	.clk            (clk_fifo_write[14]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem13(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata13[8:0]),
	.clk            (clk_fifo_write[13]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		

 dff_s #(9) dff_ccx_arb_fmem12(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata12[8:0]),
	.clk            (clk_fifo_write[12]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		

//Read mux 15-12

 mux4ds #(9) mux4ds_ccx_arb_fmem15_12(
	    .dout            (fifo_rdata15_12[8:0]),
	    .in0             (fifo_rdata15[8:0]),		    	    
            .in1             (fifo_rdata14[8:0]),
	    .in2             (fifo_rdata13[8:0]),
	    .in3             (fifo_rdata12[8:0]),
	    .sel0            (rdptr[15]),
	    .sel1            (rdptr[14]),
	    .sel2            (rdptr[13]),
            .sel3            (rdptr[12]));
		 
 dff_s #(9) dff_ccx_arb_fmem11(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata11[8:0]),
	.clk            (clk_fifo_write[11]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem10(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata10[8:0]),
	.clk            (clk_fifo_write[10]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem9(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata9[8:0]),
	.clk            (clk_fifo_write[9]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem8(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata8[8:0]),
	.clk            (clk_fifo_write[8]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		

//Read mux 11 to 8
 mux4ds #(9) mux4ds_ccx_arb_fmem11_8(
	    .dout            (fifo_rdata11_8[8:0]),
	    .in0             (fifo_rdata11[8:0]),		    	    
            .in1             (fifo_rdata10[8:0]),
	    .in2             (fifo_rdata9[8:0]),
	    .in3             (fifo_rdata8[8:0]),
	    .sel0            (rdptr[11]),
	    .sel1            (rdptr[10]),
	    .sel2            (rdptr[9]),
            .sel3            (rdptr[8]));


 dff_s #(9) dff_ccx_arb_fmem7(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata7[8:0]),
	.clk            (clk_fifo_write[7]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem6(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata6[8:0]),
	.clk            (clk_fifo_write[6]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem5(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata5[8:0]),
	.clk            (clk_fifo_write[5]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem4(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata4[8:0]),
	.clk            (clk_fifo_write[4]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		

//Read mux 7 to 4		 
 mux4ds #(9) mux4ds_ccx_arb_fmem7_4(
	    .dout            (fifo_rdata7_4[8:0]),
	    .in0             (fifo_rdata7[8:0]),		    	    
            .in1             (fifo_rdata6[8:0]),
	    .in2             (fifo_rdata5[8:0]),
	    .in3             (fifo_rdata4[8:0]),
	    .sel0            (rdptr[7]),
	    .sel1            (rdptr[6]),
	    .sel2            (rdptr[5]),
            .sel3            (rdptr[4]));
		 
 dff_s #(9) dff_ccx_arb_fmem3(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata3[8:0]),
	.clk            (clk_fifo_write[3]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem2(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata2[8:0]),
	.clk            (clk_fifo_write[2]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem1(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata1[8:0]),
	.clk            (clk_fifo_write[1]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
 dff_s #(9) dff_ccx_arb_fmem0(
	.din            (fifo_wdata[8:0]),
	.q              (fifo_rdata0[8:0]),
	.clk            (clk_fifo_write[0]),
	.se             (1'd0),
	.si             (9'd0),
	.so             ());		
//Read mux 3 to 0
 mux4ds #(9) mux4ds_ccx_arb_fmem3_0(
	    .dout            (fifo_rdata3_0[8:0]),
	    .in0             (fifo_rdata3[8:0]),		    	    
            .in1             (fifo_rdata2[8:0]),
	    .in2             (fifo_rdata1[8:0]),
	    .in3             (fifo_rdata0[8:0]),
	    .sel0            (rdptr[3]),
	    .sel1            (rdptr[2]),
	    .sel2            (rdptr[1]),
            .sel3            (rdptr[0]));

//Read mux 15 to 0
 mux4ds #(9) mux4ds_ccx_arb_fmem15_0(
	    .dout            (fifo_rdata15_0[8:0]),
	    .in0             (fifo_rdata15_12[8:0]),		    	    
            .in1             (fifo_rdata11_8[8:0]),
	    .in2             (fifo_rdata7_4[8:0]),
	    .in3             (fifo_rdata3_0[8:0]),
	    .sel0            (fifo_sel15_12),
	    .sel1            (fifo_sel11_8),
	    .sel2            (fifo_sel7_4),
            .sel3            (fifo_sel3_0));

 assign fifo_rdata = (fifo_sel15_12 | fifo_sel11_8 | fifo_sel7_4 | fifo_sel3_0)  ? fifo_rdata15_0[8:0] : 9'd0;
//   mux2ds #(17) mx2ds_ccx_arb_bypmx(
//	    .dout            ({fifo_dir,fifo_atomic[7:0],fifo_req[7:0]}),
//	    .in0             ({fifo_rdata[8],arbctl_atom[7:0],fifo_rdata[7:0]}),		    	    
//            .in1             ({fifo_wdata[8],atom_fifo_a[7:0],fifo_wdata[7:0]}),
//	    .sel0            (fifo_bypass_l),
//	    .sel1            (fifo_bypass));

   mux2ds #(9) mx2ds_ccx_arb_bypmx(
	    .dout            ({fifo_dir,fifo_req[7:0]}),
	    .in0             ({fifo_rdata[8:0]}),		    	    
            .in1             ({fifo_wdata[8:0]}),
	    .sel0            (fifo_bypass_l),
	    .sel1            (fifo_bypass));

//End flop memory section 


  //BEGIN PE SECTION		 

dff_s #(8) dff_ccx_arb_newreq(
	.din           (req_q[7:0]),
	.q             (req_a[7:0]),
	.clk           (rclk),
	.se            (1'd0),
	.si            (8'd0),
	.so            ());

dff_s #(8) dff_ccx_arb_newatom(
	.din           (atom_q[7:0]),
	.q             (atom_a[7:0]),
	.clk           (rclk),
	.se            (1'd0),
	.si            (8'd0),
	.so            ());
		 
dff_s  dff_ccx_arb_newdir(
	.din           (direction),
	.q             (dir_a),
	.clk           (rclk),
	.se            (1'd0),
	.si            (1'd0),
	.so            ());

dff_s #(8) dff_ccx_arb_qfull_l(
	.din           (qfull[7:0]),
	.q             (qfull_a[7:0]),
	.clk           (rclk),
	.se            (1'b0), 
	.si            (8'd0),
	.so            ());

//  mux3ds #(17) mx3ds_ccx_arb_l(
//	.dout            ({fq_dir,fq_atomic[7:0], fq_req[7:0]}),
//	.in0             ({qual_dir,qual_atomic[7:0],qual_req[7:0]}),		    	    
//	.in1             ({fifo_dir,fifo_atomic[7:0],fifo_req[7:0]}),
//	.in2             (17'd0),
//	.sel0            (current_req_sel),
//	.sel1            (fifo_req_sel),
//	.sel2            (input_req_sel));

  mux3ds #(9) mx3ds_ccx_arb_l(
	.dout            ({fq_dir,fq_req[7:0]}),
	.in0             ({qual_dir,qual_req[7:0]}),		    	    
	.in1             ({fifo_dir,fifo_req[7:0]}),
	.in2             (9'd0),
	.sel0            (current_req_sel),
	.sel1            (fifo_req_sel),
	.sel2            (input_req_sel));



 dff_s #(9) dff_ccx_arb_fqreg(
	.din           ({fq_dir,fq_req[7:0]}),
	.q             ({fq_dir_a,fq_req_a[7:0]}),
	.clk           (rclk),
	.se            (1'd0),
	.si            (9'd0),
	.so            ());

   //see if any valid requests in flopped request packet.
   assign inreg_req_vld_d1 = |((req_a[7:0] & ~qfull_a[7:0])) ;

assign req[7:0] = (input_req_sel_d1 ? (~qfull_a[7:0] & req_a[7:0]) : 8'd0) | fq_req_a[7:0];

//assign atom[7:0] = (input_req_sel_d1 ? ~qfull_a[7:0] & req_a[7:0] & atom_a[7:0] : 8'd0) | fq_atomic_a[7:0];
//assign atom[7:0] = (input_req_sel_d1 ? ~qfull_a[7:0] & req_a[7:0] & atom_a[7:0] : 8'd0) | arbctl_atom[7:0];
assign atom[7:0] = input_req_sel_d1 ? ~qfull_a[7:0] & req_a[7:0] & atom_a[7:0] : arbctl_atom[7:0];

assign dira = ((input_req_sel_d1 & dir_a) | fq_dir_a) & ~stall_a & ~reset_d1;
assign dird = ~((input_req_sel_d1 & dir_a) | fq_dir_a) & ~stall_a & ~reset_d1;

// dir signal selects between asc and des PEs, and also reduces both PE
// outputs to '0' when stalled.

//Ascending priority encoder
   assign grant_asc[0] =  req[0]&dira;
   assign grant_asc[1] = ~req[0]& req[1]&dira;
   assign grant_asc[2] = ~req[0]&~req[1]& req[2]&dira;
   assign grant_asc[3] = ~req[0]&~req[1]&~req[2]& req[3]&dira;
   assign grant_asc[4] = ~req[0]&~req[1]&~req[2]&~req[3]& req[4]&dira;
   assign grant_asc[5] = ~req[0]&~req[1]&~req[2]&~req[3]&~req[4]& req[5]&dira;
   assign grant_asc[6] = ~req[0]&~req[1]&~req[2]&~req[3]&~req[4]&~req[5]& req[6]&dira;
   assign grant_asc[7] = ~req[0]&~req[1]&~req[2]&~req[3]&~req[4]&~req[5]&~req[6]& req[7]&dira;

//Descending priority encoder.
   assign grant_des[7] =  req[7]&dird;
   assign grant_des[6] = ~req[7]& req[6]&dird;
   assign grant_des[5] = ~req[7]&~req[6]& req[5]&dird;
   assign grant_des[4] = ~req[7]&~req[6]&~req[5]& req[4]&dird;                                  
   assign grant_des[3] = ~req[7]&~req[6]&~req[5]&~req[4]& req[3]&dird;                          
   assign grant_des[2] = ~req[7]&~req[6]&~req[5]&~req[4]&~req[3]& req[2]&dird;                    
   assign grant_des[1] = ~req[7]&~req[6]&~req[5]&~req[4]&~req[3]&~req[2]& req[1]&dird;        
   assign grant_des[0] = ~req[7]&~req[6]&~req[5]&~req[4]&~req[3]&~req[2]&~req[1]&req[0]&dird;

//Final select & generation of data_ready signal.
   assign grant_a[7:0] = grant_asc[7:0] | grant_des[7:0];

   assign ccx_dest_data_rdy_a = |(grant_a[7:0]);
//   assign ccx_dest_atom_a = |(grant_a[7:0] & atom[7:0]);
   assign ccx_dest_atom_a = |(grant_a[7:0] & atom[7:0] & ~qual_atomic_d1[7:0]);

/*
*/

   assign arb_src7_grant_a = grant_a[7];//Outputs to sources eg. sparc/sctag
   assign arb_src6_grant_a = grant_a[6];
   assign arb_src5_grant_a = grant_a[5];
   assign arb_src4_grant_a = grant_a[4];
   assign arb_src3_grant_a = grant_a[3];
   assign arb_src2_grant_a = grant_a[2];
   assign arb_src1_grant_a = grant_a[1];
   assign arb_src0_grant_a = grant_a[0];

   assign arb_dp_grant_a[7:0] = grant_a[7:0];//outputs to ccx datapath.

// Logic to determine if req packet was drained in current cycle

//   assign qual_req[7:0] = (req[7:0] & ~grant_a[7:0]) | (req[7:0] & atom[7:0]) ;
   assign qual_req[7:0] = (req[7:0] & ~grant_a[7:0]) | 
                          (atom[7:0] & grant_a[7:0] & ~qual_atomic_d1[7:0]) ;
//                          (req[7:0] & atom[7:0] & grant_a[7:0] & ~qual_atomic_d1[7:0]) ;

   assign req_pkt_empty  = ~(|(qual_req[7:0]));

//   assign qual_atomic[7:0] = atom[7:0] & ~grant_a[7:0];
//   assign qual_atomic[7:0] = (req[7:0] & atom[7:0] & grant_a[7:0] & ~qual_atomic_d1[7:0]) | // set
   assign qual_atomic[7:0] = (atom[7:0] & grant_a[7:0] & ~qual_atomic_d1[7:0]) | // set
			     (~{8{reset_d1}} & ~grant_a[7:0] & qual_atomic_d1[7:0]);	// hold if l2stall=1 after 1st atomic packet

   assign qual_dir = ((input_req_sel_d1 & dir_a) | fq_dir_a) & ~reset_d1;
   
 dff_s #(8) dff_qual_atomic_d1(
	.din           (qual_atomic[7:0]),
	.q             (qual_atomic_d1[7:0]),
	.clk           (rclk),
	.se            (1'd0),
	.si            (8'd0),
	.so            ());

endmodule

// Local Variables:
// verilog-library-directories:("." "../../../../common/rtl" "../../common/rtl")
// End:




















