// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: bw_iodll_code_adjust.v
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
//    Unit Name:  bw_iodll_code_adjust (Adjusts loop controller code by a certain percent)
//    Block Name:  DLL
//    Files that must be included:  none
//
// ***********************************************************************************************************


module bw_iodll_code_adjust (/*AUTOARG*/
        // Outputs
         s_percent_ctrl_out, so,
        // Inputs
        bypass_data, ddr_clk_in, delay_ctrl, io_dll_bypass_l, iodll_reset_l, s_controller_out, se, si
        );

	input [4:0]	bypass_data;
        input           ddr_clk_in;
        input [2:0]     delay_ctrl;
        input		io_dll_bypass_l;
        input           iodll_reset_l;
        input [4:0]     s_controller_out;
        input           se;
        input           si;

        output [4:0]    s_percent_ctrl_out;
        output          so;

        reg    [4:0]    s_percent_ctrl_out;
        reg    [4:0]    s_interim_out;		


always @(posedge ddr_clk_in or negedge iodll_reset_l)
begin

	if(~iodll_reset_l) 
        begin
		// Initialize all registers & variables.
 		s_percent_ctrl_out = 5'b00000;
                s_interim_out = 5'b00000;
        end
	else
	if(~io_dll_bypass_l)

		s_percent_ctrl_out = bypass_data;

	else
        begin
		if(bypass_data[0] == 1'b1)
		begin
			// Manipulate SLAVE DELAY LINE s_controller_out depending on delay_ctrl bits which are programmable.
                	case(delay_ctrl)  
                                        3'b111 : begin  // This is for 24% delay point.

							// First recover orig slave_ctrl_code and call it s_interim_out
							// Note s_controller_out will never be less than 3 as we have added +3 bits
							// in the loop controller, except in an underflow condition.
							// However, Only exception is during reset. Just after reset, loop controller
							// which operates at ddr_clk_by8 is still holding all 0s, but will not add 
							// + 3 bits utill next ddr_clk_by8 edge. However this block operates at 
							// ddr_clk_in edge and will see the all zeros. Better handle this condition.
                                                        if (s_controller_out == 5'b11111) // This also handles potential overflow condition.
                                                                s_interim_out = s_controller_out - 5'b00001;
                                                        else 
							if (s_controller_out == 5'b00000) // Handling the loop contoller reset condition.
											  // This also handles potential underflow condition.
								s_interim_out = s_controller_out;
							else
                                                                s_interim_out = s_controller_out - 5'b00011;
							// End Recovery part							

							// Subtract 1 if s_interim is between 31 and 2 else do not subtract anything
							
							if ( s_interim_out == 5'b00000 || s_interim_out == 5'b00001 )	
 								s_percent_ctrl_out = s_interim_out;
							else
								s_percent_ctrl_out = s_interim_out - 5'b00001;
                                                 end

					3'b110 : begin // This is for 23% delay point.
							
							// First recover orig slave_ctrl_code and call it s_interim_out
							// Note s_controller_out will never be less than 2 as we have added +2 bits
                                                        // in the loop controller, except in an underflow condition.
                                                        // However, Only exception is during reset. Just after reset, loop controller
                                                        // which operates at ddr_clk_by8 is still holding all 0s, but will not add
                                                        // + 2 bits utill next ddr_clk_by8 edge. However this block operates at
                                                        // ddr_clk_in edge and will see the all zeros. Better handle this condition.

							if (s_controller_out == 5'b11111) // This also handles potential overflow condition.
                                                                s_interim_out = s_controller_out - 5'b00001;
							else
                                                        if (s_controller_out == 5'b00000) // Handling the loop contoller reset condition.
                                                                                          // This also handles potential underflow condition.
                                                                s_interim_out = s_controller_out;
                                                        else    
								s_interim_out = s_controller_out - 5'b00010;
							// End Recovery part
        
                                                        //  if s_interim is between 31 and 20, then subtract 3
							//  else if s_interim is between 19 and 9, then subtract 2
							//  else if s_interim is between 8 and 1, then subtract 1
							//  else if s_interim = 0, do not subtract anything.
							
							if ( s_interim_out <= 5'b11111 && s_interim_out >= 5'b10100 )
								s_percent_ctrl_out = s_interim_out - 5'b00011;
							else
							if( s_interim_out <= 5'b10011 && s_interim_out >= 5'b01001)
								s_percent_ctrl_out = s_interim_out - 5'b00010;
							else
							if( s_interim_out <= 5'b01000 && s_interim_out >= 5'b00001 )
								s_percent_ctrl_out = s_interim_out - 5'b00001;
							else
								s_percent_ctrl_out = s_interim_out;
						 end

        				3'b101 : begin // This is 21% delay point.

                                                        // First recover orig slave_ctrl_code and call it s_interim_out
                                                        // Note s_controller_out will never be less than 1 as we have added +1 bits
                                                        // in the loop controller, except in an underflow condition.
                                                        // However, Only exception is during reset. Just after reset, loop controller
                                                        // which operates at ddr_clk_by8 is still holding all 0s, but will not add 
                                                        // + 2 bits utill next ddr_clk_by8 edge. However this block operates at 
                                                        // ddr_clk_in edge and will see the all zeros. Better handle this condition. 
                                                        
                                                        if (s_controller_out == 5'b00000) // Handling the loop contoller reset condition.
											  // This also handles potential underflow condition.
                                                                s_interim_out = s_controller_out;
                                                        else
								s_interim_out = s_controller_out - 5'b00001;

							// End Recovery part

                                                        //  if s_interim is between 31 and 24, then subtract 6
                                                        //  else if s_interim is between 23 and 17, then subtract 5
                                                        //  else if s_interim is between 16 and 12, then subtract 4
                                                        //  else if s_interim is between 11 and 6, then subtract 3
                                                        //  else if s_interim is between 5 and 2, then subtract 2
							//  else if s_interim = 1, then subtract 1
                                                        //  else if s_interim = 0, do not subtract anything.

							if ( s_interim_out <= 5'b11111 && s_interim_out >= 5'b11000 )
                                                                s_percent_ctrl_out = s_interim_out - 5'b00110;
                                                        else
                                                        if ( s_interim_out <= 5'b10111 && s_interim_out >= 5'b10001 )
                                                                s_percent_ctrl_out = s_interim_out - 5'b00101;
                                                        else
                                                        if ( s_interim_out <= 5'b10000 && s_interim_out >= 5'b01100 )
                                                                s_percent_ctrl_out = s_interim_out - 5'b00100;
                                                        else
                                                        if ( s_interim_out <= 5'b01011 && s_interim_out >= 5'b00110 )
                                                                s_percent_ctrl_out = s_interim_out - 5'b00011;
                                                        else
                                                        if ( s_interim_out <= 5'b00101 && s_interim_out >= 5'b00010 ) 
                                                                s_percent_ctrl_out = s_interim_out - 5'b00010;
                                                        else
							if ( s_interim_out == 5'b00001 )
								s_percent_ctrl_out = s_interim_out - 5'b00001;
							else
                                                        if ( s_interim_out == 5'b00000 )
                                                                s_percent_ctrl_out = s_interim_out;
                                                 end

					3'b100 : begin // This is 25% delay point.
							// Just pass s_controller_out straight thru !!
							
							s_interim_out = s_controller_out;							

							s_percent_ctrl_out = s_interim_out; 
                                        
                                                 end
					
					3'b011 : begin // This is 26% delay point.
						       // First recover orig slave_ctrl_code and call it s_interim_out
						       // Note we don't have to worry about s_controller_out being 31, (except overflow condition.)
						       // as this will never happen as loop controller always subtracts 1 bit delay.				
                                                        if(s_controller_out == 5'b00000 || s_controller_out == 5'b11111) 
							// Note: Reset case is automatically handled here and so is overflow case.     
                                                                s_interim_out = s_controller_out;
                                                        else
                                                                s_interim_out = s_controller_out + 5'b00001;
                                                        // End Recovery part
            
	                                                //  if s_interim is either 0 or 1 or 31, then add 0
                                                        //  for all other cases add 1
                                                        if ( s_interim_out == 5'b00000 || s_interim_out == 5'b00001 || s_interim_out == 5'b11111 )
                                                                s_percent_ctrl_out = s_interim_out;
							else
								s_percent_ctrl_out = s_interim_out + 5'b00001;

						 end

					3'b010 : begin // We don't do any processing here for this case.
				                       // Just pass s_controller_out straight thru 
                                                       // Note: Reset case is automatically handled here.   

                                                        s_interim_out = s_controller_out;                                                 
                                                        
                                                        s_percent_ctrl_out = s_interim_out;

                                                 end

                                        3'b001 : begin // We don't do any processing here for this case.
                                                       // Just pass s_controller_out straight thru  
						       // Note: Reset case is automatically handled here.   

                                                        s_interim_out = s_controller_out;                                                  
                                                        
                                                        s_percent_ctrl_out = s_interim_out;
                                                        
                                                 end    

					3'b000 : begin // This is 22% delay point 
                                                        // First recover orig slave_ctrl_code and call it s_interim_out
                                                        // No additions or subractions necessary to recover.
                                                        
                                                                s_interim_out = s_controller_out;

                                                        // End Recovery part
                                                        
                                                        //  if s_interim is between 31 and 26, then subtract 5
                                                        //  else if s_interim is between 25 and 19, then subtract 4
                                                        //  else if s_interim is between 18 and 11, then subtract 3
                                                        //  else if s_interim is between 10 and 2, then subtract 2
                                                        //  else if s_interim = 1, then subtract 1
                                                        //  else if s_interim = 0, do not subtract anything.
                                                        
                                                        if ( s_interim_out <= 5'b11111 && s_interim_out >= 5'b11010 )
                                                                s_percent_ctrl_out = s_interim_out - 5'b00101;
                                                        else
                                                        if ( s_interim_out <= 5'b11001 && s_interim_out >= 5'b10011 )
                                                                s_percent_ctrl_out = s_interim_out - 5'b00100;
                                                        else
                                                        if ( s_interim_out <= 5'b10010 && s_interim_out >= 5'b01011 )
                                                                s_percent_ctrl_out = s_interim_out - 5'b00011;
                                                        else
                                                        if ( s_interim_out <= 5'b01010 && s_interim_out >= 5'b00010 )
                                                                s_percent_ctrl_out = s_interim_out - 5'b00010;
                                                        else
                                                        if ( s_interim_out == 5'b00001 )
                                                                s_percent_ctrl_out = s_interim_out - 5'b00001;
                                                        else
                                                        if ( s_interim_out == 5'b00000 )   
                                                                s_percent_ctrl_out = s_interim_out;
						
						 end				
			endcase			
	
		end
        	else
        	if(bypass_data[0] == 1'b0)
			// Bypassing new block!!
			s_percent_ctrl_out = s_controller_out;

	end


end

endmodule
