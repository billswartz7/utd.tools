// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_clk_cl_efc_jbus.v
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
////////////////////////////////////////////////////////////////////////
/*
//  Module Name:        bw_clk_cl_efc_jbus (efc clock cluster header)
//  Description:        This block contains efc clock cluster header.
*/
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////
`include "sys.h"    // system level definition file which contains the
                    // time scale definition
`include "iop.h"    // definitions common at the iop level

////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Interface signal list declarations
////////////////////////////////////////////////////////////////////////
module bw_clk_cl_efc_jbus (/*AUTOARG*/
    // Outputs
    dbginit_l, cluster_grst_l, rclk, so, 
    // Inputs
    gclk, cluster_cken, arst_l, grst_l, adbginit_l, gdbginit_l, si, 
    se
    );
    
    ////////////////////////////////////////////////////////////////////
    // Local defines
    ////////////////////////////////////////////////////////////////////
    
    ////////////////////////////////////////////////////////////////////
    // Interface signal type declarations
    ////////////////////////////////////////////////////////////////////
    // Outputs
    output                                       dbginit_l;
    output                                       cluster_grst_l;    
    output                                       rclk;    
    output                                       so;    
        
    // Inputs
    input                                        gclk;    
    input                                        cluster_cken;    
    input                                        arst_l;    
    input                                        grst_l;    
    input                                        adbginit_l;    
    input                                        gdbginit_l;    
    input                                        si;
    input                                        se;
    
    ////////////////////////////////////////////////////////////////////
    // Code start here 
    ////////////////////////////////////////////////////////////////////    
    cluster_header cluster_header (/*AUTOINST*/
                                   // Outputs
                                   .dbginit_l(dbginit_l),
                                   .cluster_grst_l(cluster_grst_l),
                                   .rclk(rclk),
                                   .so  (so),
                                   // Inputs
                                   .gclk(gclk),
                                   .cluster_cken(cluster_cken),
                                   .arst_l(arst_l),
                                   .grst_l(grst_l),
                                   .adbginit_l(adbginit_l),
                                   .gdbginit_l(gdbginit_l),
                                   .si  (si),
                                   .se  (se));
    
endmodule // bw_clk_cl_efc_jbus
// Local Variables:
// verilog-library-directories:("." "../../common/rtl/")
// End:
