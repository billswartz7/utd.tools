//-----------------------------------------------------
// Design Name : dff_async_reset
// File Name   : dff_async_reset.sv
// Function    : D flip-flop async reset
// Coder      : Deepak Kumar Tala
//-----------------------------------------------------
module dff_async_reset (
input  wire data  , // Data Input
input  wire clk   , // Clock Input
input  wire reset , // Reset input 
output reg  q       // Q output
);
//-------------Code Starts Here---------
always_ff @ ( posedge clk iff reset == 1 or negedge reset)
if (~reset) begin
  q <= 1'b0;
end else begin
  q <= data;
end

endmodule //End Of Module dff_async_reset
