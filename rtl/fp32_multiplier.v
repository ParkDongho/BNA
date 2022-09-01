`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:10:39
// Design Name: 
// Module Name: fp32_multiplier
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


module fp32_multiplier
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISSA_A_WIDTH = 24,
  parameter MANTISSA_B_WIDTH = 18,
  parameter QUNATIZED_MANTISSA_WIDTH = 7
) (
  input  wire clk, mul_op,
  input  wire signed [EXPONENT_WIDTH+MANTISSA_A_WIDTH-1:0] mul_data_a_i,
  input  wire signed [EXPONENT_WIDTH+MANTISSA_B_WIDTH-1:0] mul_data_b_i,
  output wire signed [EXPONENT_WIDTH+MANTISSA_A_WIDTH-1:0] mul_data_o
);

  wire signed [MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-1:0] mul_mantissa_add_mul_out, mul_mantissa_norm_out;
  wire signed [EXPONENT_WIDTH:0] mul_exponent_add_mul_out, mul_exponent_norm_out;

  wire signed [EXPONENT_WIDTH-1:0] mul_exponent_a_in, mul_exponent_b_in;
  wire signed [MANTISSA_A_WIDTH-1:0] mul_mantissa_a_in;
  wire signed [MANTISSA_B_WIDTH-1:0] mul_mantissa_b_in;

  assign {mul_exponent_a_in, mul_mantissa_a_in} = mul_data_a_i;
  assign {mul_exponent_b_in, mul_mantissa_b_in} = mul_data_b_i;
  
  fp32_multiplier_add_mul_stage
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISSA_A_WIDTH(MANTISSA_A_WIDTH),
    .MANTISSA_B_WIDTH(MANTISSA_B_WIDTH)
  ) fp32_multiplier_add_mul_stage(
    //control signal in
    .clk(clk),
    //data in
    .exponent_a_in(mul_exponent_a_in), 
    .exponent_b_in(mul_exponent_b_in),
    .mantissa_a_in(mul_mantissa_a_in),
    .mantissa_b_in(mul_mantissa_b_in),
    //data out
    .exponent_add_mul_out(mul_exponent_add_mul_out),
    .mantissa_add_mul_out(mul_mantissa_add_mul_out)
  );
    
  fp32_multiplier_norm_stage
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISSA_A_WIDTH(MANTISSA_A_WIDTH),
    .MANTISSA_B_WIDTH(MANTISSA_B_WIDTH)
  )fp32_multiplier_norm_stage
  (
    //control signal in
    .clk(clk),
    //data in
    .exponent_norm_in(mul_exponent_add_mul_out),
    .mantissa_norm_in(mul_mantissa_add_mul_out),
    //data out
    .exponent_norm_out(mul_exponent_norm_out),
    .mantissa_norm_out(mul_mantissa_norm_out)
  );

  fp32_multiplier_rounding_stage
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISSA_A_WIDTH(MANTISSA_A_WIDTH),
    .MANTISSA_B_WIDTH(MANTISSA_B_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH)
  ) fp32_multiplier_rounding_stage(
    //control signal in
    .clk(clk),
    .mul_op(mul_op),
    //data in
    .exponent_round_in(mul_exponent_norm_out),
    .mantissa_round_in(mul_mantissa_norm_out),
    //data out
    .i_mul_data(mul_data_a_i),
    .o_mul_data(mul_data_o)
  );
  
endmodule

