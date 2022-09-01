`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/20 23:05:37
// Design Name: 
// Module Name: fp32_adder_dual_alignment_stage
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


module fp32_adder_dual_alignment_stage
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISA_WIDTH = 24
) (
  input  wire clk, //controll signal in
  input  wire signed [EXPONENT_WIDTH:0] exponent_diff_0, exponent_diff_1,
  input  wire signed [EXPONENT_WIDTH-1:0] exponent_big_0_in, exponent_big_1_in,
  input  wire signed [MANTISA_WIDTH-1:0] mantissa_big_0_in, mantissa_small_0,
  input  wire signed [MANTISA_WIDTH-1:0] mantissa_big_1_in, mantissa_small_1,
  
  output reg  [EXPONENT_WIDTH-1:0] exponent_big_0_out, exponent_big_1_out,
  output reg  [MANTISA_WIDTH-1:0] mantissa_big_0_out, mantissa_aligned_0,
  output reg  [MANTISA_WIDTH-1:0] mantissa_big_1_out, mantissa_aligned_1
);

  always @(posedge clk)
  begin
    mantissa_aligned_0 <= mantissa_small_0 >>> exponent_diff_0; //arthmetic shift right
    mantissa_aligned_1 <= mantissa_small_1 >>> exponent_diff_1; //arthmetic shift right
    mantissa_big_0_out <= mantissa_big_0_in;
    mantissa_big_1_out <= mantissa_big_1_in;
    exponent_big_0_out <= exponent_big_0_in;
    exponent_big_1_out <= exponent_big_1_in;
  end
endmodule

