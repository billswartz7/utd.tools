// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: iobdg_int_mondo_addr_dec.v
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
//  Module Name:	iobdg_int_mondo_addr_dec
//  Description:	Logic to generate address to
//                      index the mondo data table.
*/
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////
`include	"sys.h" // system level definition file which contains the 
			// time scale definition
`include        "iop.h"


////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////
// Interface signal list declarations
////////////////////////////////////////////////////////////////////////
module iobdg_int_mondo_addr_dec (/*AUTOARG*/
   // Outputs
   creg_mdata0_dec, creg_mdata1_dec, creg_mbusy_dec, mondo_data_addr, 
   addr_invld, 
   // Inputs
   addr_in, thr_id_in
   );
   
////////////////////////////////////////////////////////////////////////
// Signal declarations
////////////////////////////////////////////////////////////////////////
   input [`IOB_ADDR_WIDTH-1:0]         addr_in;
   input [`IOB_CPUTHR_INDEX-1:0]       thr_id_in;
   
   output 			       creg_mdata0_dec;
   output 			       creg_mdata1_dec;
   output 			       creg_mbusy_dec;
   output [`IOB_MONDO_DATA_INDEX-1:0]  mondo_data_addr;

   output 			       addr_invld;
   
   wire 			       creg_mdata0_alias_dec;
   wire 			       creg_mdata1_alias_dec;
   wire 			       creg_mbusy_alias_dec;
   wire 			       creg_mdata0_proper_dec;
   wire 			       creg_mdata1_proper_dec;
   wire 			       creg_mbusy_proper_dec;
   wire 			       use_thr_addr;

   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   // Assertion: Decode signals should be mutually exclusive.
   /*****************************************************************
    * Decode for Mondo Data0, Mondo Data1, Mondo Busy access
    * Assumption: addr_in is within the IOB_INT_CSR range
    *****************************************************************/
   // Decode alias address (what software normally uses)
   assign 		 creg_mdata0_alias_dec =
   			 (addr_in[`IOB_LOCAL_ADDR_WIDTH-1:0]
			  == `IOB_CREG_MDATA0_ALIAS);
   
   assign 		 creg_mdata1_alias_dec =
   			 (addr_in[`IOB_LOCAL_ADDR_WIDTH-1:0]
			  == `IOB_CREG_MDATA1_ALIAS);
   
   assign 		 creg_mbusy_alias_dec =
			 (addr_in[`IOB_LOCAL_ADDR_WIDTH-1:0]
			  == `IOB_CREG_MBUSY_ALIAS);

   // Decode proper address (what the TAP has to use)
   assign 		 creg_mdata0_proper_dec =
   			 ((addr_in[`IOB_LOCAL_ADDR_WIDTH-1:0] & `IOB_THR_ADDR_MASK)
			  == `IOB_CREG_MDATA0);
   
   assign 		 creg_mdata1_proper_dec =
   			 ((addr_in[`IOB_LOCAL_ADDR_WIDTH-1:0] & `IOB_THR_ADDR_MASK)
			  == `IOB_CREG_MDATA1);
   
   assign 		 creg_mbusy_proper_dec =
			 ((addr_in[`IOB_LOCAL_ADDR_WIDTH-1:0] & `IOB_THR_ADDR_MASK)
			  == `IOB_CREG_MBUSY);

   // Combine proper and alias decode results
   assign 		 creg_mdata0_dec = creg_mdata0_proper_dec | creg_mdata0_alias_dec;
   assign 		 creg_mdata1_dec = creg_mdata1_proper_dec | creg_mdata1_alias_dec;
   assign 		 creg_mbusy_dec = creg_mbusy_proper_dec | creg_mbusy_alias_dec;
   
	  
   assign 		 use_thr_addr = creg_mdata0_alias_dec |
			                creg_mdata1_alias_dec |
			                creg_mbusy_alias_dec;

   // Use thread ID as index into array if request comes from software
   // Use the address directly if request comes from TAP
   assign 		 mondo_data_addr = use_thr_addr ? thr_id_in :
			                                  addr_in[`IOB_MONDO_DATA_INDEX-1+3:3];

   
   /*****************************************************************
    * Assert address invalid if no register address match
    *****************************************************************/
   assign 		 addr_invld = ~creg_mdata0_dec &
			              ~creg_mdata1_dec &
			              ~creg_mbusy_dec;
   
   
endmodule // iobdg_int_mondo_addr_dec



