`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:18:09
// Design Name: 
// Module Name: fp32_multiplier_add_mul
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


module fp32_multiplier_add_mul_stage
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISSA_A_WIDTH = 24,
  parameter MANTISSA_B_WIDTH = 18
) (
  input  wire clk,
  input  wire signed [EXPONENT_WIDTH-1:0] exponent_a_in, exponent_b_in,
  input  wire signed [MANTISSA_A_WIDTH-1:0] mantissa_a_in,
  input  wire signed [MANTISSA_B_WIDTH-1:0] mantissa_b_in,
  output reg  signed [EXPONENT_WIDTH:0] exponent_add_mul_out,
  output reg  signed [MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-1:0] mantissa_add_mul_out
);

  always @(posedge clk)
    begin
      exponent_add_mul_out <= exponent_a_in + exponent_b_in;
      mantissa_add_mul_out <= mantissa_a_in * mantissa_b_in;
    end
endmodule
