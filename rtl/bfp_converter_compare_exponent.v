`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/25 02:24:19
// Design Name: 
// Module Name: bfp_converter_compare_exponent
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bfp_converter_compare_exponent
#(
  EXPONENT_WIDTH = 8
) (
  input  wire clk,
  input  wire signed [EXPONENT_WIDTH-1:0] exponent_a, exponent_b, 
  output reg signed [EXPONENT_WIDTH-1:0] exponent_big,
  output reg  [EXPONENT_WIDTH-1:0] exponent_diff_a, exponent_diff_b
);
  wire [EXPONENT_WIDTH-1:0] exponent_diff;
  
  always @(posedge clk)
  begin
    if(exponent_diff[EXPONENT_WIDTH-1])
    begin
      exponent_diff_a <= -exponent_diff;
      exponent_diff_b <= 'd0;
      exponent_big <= exponent_b;
    end
    else
    begin
      exponent_diff_a <= 'd0;
      exponent_diff_b <= exponent_diff;
      exponent_big <= exponent_a;
    end
  end
  assign exponent_diff = exponent_a - exponent_b;
endmodule
