`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/20 23:05:37
// Design Name: 
// Module Name: fp32_adder_dual_compare_stage
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


module fp32_adder_dual_compare_stage
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISA_WIDTH = 24
) (
  input  wire clk, bias_mode, //controll signal
  input  wire signed [EXPONENT_WIDTH-1:0] exponent_acc_0, exponent_bias_0, exponent_b_0, 
  input  wire signed [EXPONENT_WIDTH-1:0] exponent_acc_1, exponent_bias_1, exponent_b_1, 
  input  wire signed [MANTISA_WIDTH-1:0] mantissa_acc_0, mantissa_bias_0, mantissa_b_0, 
  input  wire signed [MANTISA_WIDTH-1:0] mantissa_acc_1, mantissa_bias_1, mantissa_b_1, 
  
  output reg  signed [EXPONENT_WIDTH:0] exponent_diff_0, exponent_diff_1,
  output reg  signed [EXPONENT_WIDTH-1:0] exponent_big_0_out, exponent_big_1_out,
  output reg  signed [MANTISA_WIDTH-1:0] mantissa_big_0, mantissa_small_0,
  output reg  signed [MANTISA_WIDTH-1:0] mantissa_big_1, mantissa_small_1
);
  wire signed [EXPONENT_WIDTH:0] tmp_exponent_diff_0, tmp_exponent_diff_1;
  reg signed [EXPONENT_WIDTH-1:0] exponent_a_0, exponent_a_1; 
  reg signed [MANTISA_WIDTH-1:0] mantissa_a_0, mantissa_a_1;
  
  reg signed [EXPONENT_WIDTH-1:0] exponent_b_0_reg, exponent_b_1_reg; 
  reg signed [MANTISA_WIDTH-1:0] mantissa_b_0_reg, mantissa_b_1_reg;
  
  always @(posedge clk) 
  begin
    //adder 0
    exponent_diff_0 <= tmp_exponent_diff_0[EXPONENT_WIDTH] ? (exponent_a_0 - exponent_b_0_reg) : tmp_exponent_diff_0;//compare expoent
    exponent_big_0_out <= tmp_exponent_diff_0[EXPONENT_WIDTH] ? exponent_a_0:exponent_b_0_reg;
    mantissa_big_0 <= tmp_exponent_diff_0[EXPONENT_WIDTH] ? mantissa_a_0 : mantissa_b_0_reg;
    mantissa_small_0 <= tmp_exponent_diff_0[EXPONENT_WIDTH] ? mantissa_b_0_reg : mantissa_a_0;
    //adder 1
    exponent_diff_1 <= tmp_exponent_diff_1[EXPONENT_WIDTH] ? (exponent_a_1 - exponent_b_1_reg) : tmp_exponent_diff_1;//compare expoent
    exponent_big_1_out <= tmp_exponent_diff_1[EXPONENT_WIDTH] ? exponent_a_1:exponent_b_1_reg;
    mantissa_big_1 <= tmp_exponent_diff_1[EXPONENT_WIDTH] ? mantissa_a_1 : mantissa_b_1_reg;
    mantissa_small_1 <= tmp_exponent_diff_1[EXPONENT_WIDTH] ? mantissa_b_1_reg : mantissa_a_1;
    
    {exponent_a_0, mantissa_a_0} <= bias_mode ? {exponent_bias_0, mantissa_bias_0} : {exponent_acc_0, mantissa_acc_0};
    {exponent_a_1, mantissa_a_1} <= bias_mode ? {exponent_bias_1, mantissa_bias_1} : {exponent_acc_1, mantissa_acc_1};
    
    {exponent_b_0_reg, mantissa_b_0_reg} <= {exponent_b_0, mantissa_b_0};
    {exponent_b_1_reg, mantissa_b_1_reg} <= {exponent_b_1, mantissa_b_1};
  end
  assign tmp_exponent_diff_0 = exponent_b_0_reg - exponent_a_0;
  assign tmp_exponent_diff_1 = exponent_b_1_reg - exponent_a_1;
endmodule
