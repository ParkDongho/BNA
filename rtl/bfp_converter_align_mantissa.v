`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Dongho Park
// 
// Create Date: 2021/02/25 02:25:07
// Design Name: 
// Module Name: bfp_converter_align_mantissa
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


module bfp_converter_align_mantissa
#(
  QUNATIZED_MANTISSA_WIDTH = 6,
  EXPONENT_WIDTH = 8
) (
  input  wire clk,
  input  wire [EXPONENT_WIDTH-1:0] exponent_diff,
  input  wire signed [QUNATIZED_MANTISSA_WIDTH-1:0] mantissa_data_in,
  output reg  signed [QUNATIZED_MANTISSA_WIDTH-1:0] mantissa_alligned
);
  always @(posedge clk)
  begin
    mantissa_alligned <= mantissa_data_in >>> exponent_diff;
  end
endmodule