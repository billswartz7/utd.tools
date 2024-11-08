// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_cl_ddr_ddr.v
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
module bw_clk_cl_ddr_ddr (/*AUTOARG*/
   // Outputs
   so, rclk, dbginit_l, cluster_grst_l, 
   // Inputs
   si, se, grst_l, gdbginit_l, gclk, cluster_cken, arst_l, arst2_l,
   adbginit_l, ddr_rclk
   );

   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output               cluster_grst_l;         // From cluster_header0 of cluster_header.v
   output               dbginit_l;              // From cluster_header0 of cluster_header.v
   output               rclk;                   // From cluster_header0 of cluster_header.v, ...
   output               so;                     // From cluster_header1 of cluster_header.v
   // End of automatics
   
   input           	ddr_rclk ;

   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input                adbginit_l;             // To cluster_header0 of cluster_header.v
   input                arst_l;                 // To cluster_header0 of cluster_header.v
   input                arst2_l;                 // To cluster_header0 of cluster_header.v
   input                cluster_cken;           // To cluster_header0 of cluster_header.v, ...
   input [1:0]          gclk;                   // To cluster_header0 of cluster_header.v, ...
   input                gdbginit_l;             // To cluster_header0 of cluster_header.v
   input                grst_l;                 // To cluster_header0 of cluster_header.v
   input                se;                     // To cluster_header0 of cluster_header.v, ...
   input                si;                     // To cluster_header0 of cluster_header.v
   // End of automatics

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   // End of automatics

   /* cluster_header_dup AUTO_TEMPLATE (
    .gclk                               (gclk[@]),
    .so                                 (so),
    ); */
   cluster_header_dup cluster_header0
   (/*AUTOINST*/
    // Outputs
    .dbginit_l                          (dbginit_l),
    .cluster_grst_l                     (cluster_grst_l),
    .rclk                               (rclk),
    .so                                 (so),              	 // Templated
    // Inputs
    .gclk                               (gclk[0]),               // Templated
    .cluster_cken                       (cluster_cken),
    .arst_l                             (arst_l),
    .grst_l                             (grst_l),
    .adbginit_l                         (adbginit_l),
    .gdbginit_l                         (gdbginit_l),
    .si                                 (si),
    .se                                 (se));

   /* cluster_header_dup AUTO_TEMPLATE (
    .so                                 (),
    .gclk                               (gclk[@]),
    .si                                 (1'b1),
    .gdbginit_l                         (),
    .cluster_grst_l                     (),
    .dbginit_l                          (),
    .arst_l                             (arst2_l),
    .grst_l                             (1'b1),
    .adbginit_l                         (1'b1),
    .gdbginit_l                         (1'b1),
    ); */
   cluster_header_dup cluster_header1
   (/*AUTOINST*/
    // Outputs
    .dbginit_l                          (),                      // Templated
    .cluster_grst_l                     (),                      // Templated
    .rclk                               (rclk),
    .so                                 (),			 // Templated
    // Inputs
    .gclk                               (gclk[1]),               // Templated
    .cluster_cken                       (cluster_cken),
    .arst_l                             (arst2_l),                // Templated
    .grst_l                             (1'b1),                  // Templated
    .adbginit_l                         (1'b1),                  // Templated
    .gdbginit_l                         (1'b1),                  // Templated
    .si                                 (1'b1),                  // Templated
    .se                                 (1'b0));

endmodule // bw_clk_cl_ddr_ddr

// Local Variables:
// verilog-library-directories:("../../../common/rtl")
// verilog-auto-sense-defines-constant:t
// End:
