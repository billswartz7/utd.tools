/////////////////////////////////////////////////////////////
// Created by: Bill Swartz to check TRAP
// Version   : v.0001
// Date      : Sat Jul  1 15:23:00 CDT 2017
/////////////////////////////////////////////////////////////


module smoke ( clk, reset, sel1, data, out1 ) ;
  input clk ;
  input reset ;
  input sel1 ;
  input data ;
  output out1 ;

  S_DFF level1Q ( .D(level1bar), .CLK(clk), .R(reset), .Q( level1 ) );

  INV level1not ( .A(level1), .O(level1bar) );

  S_DFF level2Q ( .D(level2bar), .CLK(level1), .R(reset), .Q( level2 ) );
  INV level2not ( .A(level2), .O(level2bar) );

  S_DFF level3Q ( .D(level3bar), .CLK(level2), .R(reset), .Q( level3 ) );
  INV level3not ( .A(level3), .O(level3bar) );

  S_DFF level4Q ( .D(level4bar), .CLK(level3), .R(reset), .Q( level4 ) );
  INV level4not ( .A(level4), .O(level4bar) );

  MUX m1 ( .B(reset), .A(data), .S(sel1), .O(out1) ) ;

endmodule

