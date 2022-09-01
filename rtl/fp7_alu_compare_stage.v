`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:26:58
// Design Name: 
// Module Name: fp7_alu_compare_stage
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


module fp7_alu_compare_stage
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISSA_WIDTH = 24
) (
  input  wire clk, //controll signal
  input  wire signed [EXPONENT_WIDTH-1:0] exponent_a, exponent_b, // exponent_a : from accumulator, exponent_b : from systolic array
  input  wire signed [MANTISSA_WIDTH-1:0] mantissa_a, mantissa_b, // mantissa_a : from accumulator, mantissa_b : from systolic array
  output reg                             exponent_big_a,
  output reg  signed [EXPONENT_WIDTH:0]  exponent_diff,
  output reg  signed [MANTISSA_WIDTH-1:0] mantissa_big, mantissa_small
);
  reg signed [EXPONENT_WIDTH:0] tmp_exponent_diff, tmp_exponent_diff_n;
  reg signed [MANTISSA_WIDTH-1:0] mantissa_a_tmp, mantissa_b_tmp;

  always @(posedge clk) 
  begin
    exponent_diff <= tmp_exponent_diff[EXPONENT_WIDTH] ? tmp_exponent_diff_n : tmp_exponent_diff;//compare expoent
    mantissa_big <= tmp_exponent_diff[EXPONENT_WIDTH] ? mantissa_a_tmp : mantissa_b_tmp;
    mantissa_small <= tmp_exponent_diff[EXPONENT_WIDTH] ? mantissa_b_tmp : mantissa_a_tmp;
    exponent_big_a <= tmp_exponent_diff[EXPONENT_WIDTH];
    mantissa_a_tmp <= mantissa_a;
    mantissa_b_tmp <= mantissa_b;
    tmp_exponent_diff <= exponent_b - exponent_a;
    tmp_exponent_diff_n <= exponent_a - exponent_b;
  end

endmodule

