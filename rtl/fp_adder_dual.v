`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/20 23:02:37
// Design Name: 
// Module Name: fp_adder_dual
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


module fp32_adder_dual
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISA_WIDTH = 24
) (
  input clk, bias_mode,
  input  wire [EXPONENT_WIDTH-1:0] exponent_acc_0, exponent_bias_0, exponent_b_0, 
  input  wire [EXPONENT_WIDTH-1:0] exponent_acc_1, exponent_bias_1, exponent_b_1, 
  input  wire [MANTISA_WIDTH-1:0] mantissa_acc_0, mantissa_bias_0, mantissa_b_0, 
  input  wire [MANTISA_WIDTH-1:0] mantissa_acc_1, mantissa_bias_1, mantissa_b_1, 
  output [EXPONENT_WIDTH-1:0] exponent_0_out, exponent_1_out,
  output [MANTISA_WIDTH-1:0] mantissa_0_out, mantissa_1_out
);

  wire [EXPONENT_WIDTH:0] compare_exponent_diff_0, compare_exponent_diff_1;
  wire [EXPONENT_WIDTH-1:0] compare_exponent_big_0_out, compare_exponent_big_1_out;
  wire [MANTISA_WIDTH-1:0] compare_mantissa_big_0, compare_mantissa_small_0, compare_mantissa_b_0_out;
  wire [MANTISA_WIDTH-1:0] compare_mantissa_big_1, compare_mantissa_small_1, compare_mantissa_b_1_out;

  wire [EXPONENT_WIDTH-1:0] align_exponent_big_0_out, align_exponent_big_1_out;
  wire [MANTISA_WIDTH-1:0] align_mantissa_big_0_out, align_mantissa_aligned_0, align_mantissa_b_0_out;
  wire [MANTISA_WIDTH-1:0] align_mantissa_big_1_out, align_mantissa_aligned_1, align_mantissa_b_1_out;
  
  wire [EXPONENT_WIDTH-1:0] add_exponent_big_0_out, add_exponent_big_1_out;
  wire [MANTISA_WIDTH-1:0] add_mantissa_b_0_out, add_mantissa_b_1_out;
  wire [MANTISA_WIDTH:0] add_add_0_out, add_add_1_out;
  
  //Stage 1 : Compare
  fp32_adder_dual_compare_stage #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISA_WIDTH(MANTISA_WIDTH)
  ) fp32_adder_dual_compare_stage(
    //input
    .clk(clk),
    .bias_mode(bias_mode),
    .exponent_acc_0(exponent_acc_0), //exponent_acc_0 : from accumulator
    .exponent_bias_0(exponent_bias_0), //exponent_bias_0 : from bias memory
    .exponent_b_0(exponent_b_0), // exponent_b_0 : from systolic array
    .exponent_acc_1(exponent_acc_1), //exponent_acc_1 : from accumulator
    .exponent_bias_1(exponent_bias_1), //exponent_bias_1 : from bias memory

    .mantissa_acc_0(mantissa_acc_0),
    .mantissa_bias_0(mantissa_bias_0),
    .mantissa_b_0(mantissa_b_0), // mantissa_b_1 : from systolic array
    .mantissa_acc_1(mantissa_acc_1),
    .mantissa_bias_1(mantissa_bias_1),
    .exponent_b_1(exponent_b_1), // exponent_b : from systolic array

    .mantissa_b_1(mantissa_b_1), // mantissa_b : from systolic array
    //output
    .exponent_diff_0(compare_exponent_diff_0), 
    .exponent_big_0_out(compare_exponent_big_0_out),
    .mantissa_big_0(compare_mantissa_big_0), 
    .mantissa_small_0(compare_mantissa_small_0), 
    .exponent_diff_1(compare_exponent_diff_1), 
    .exponent_big_1_out(compare_exponent_big_1_out),
    .mantissa_big_1(compare_mantissa_big_1), 
    .mantissa_small_1(compare_mantissa_small_1)
  );

  //Stage 2 : Alignment
  fp32_adder_dual_alignment_stage #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISA_WIDTH(MANTISA_WIDTH)
  ) fp32_adder_dual_alignment_stage(
    //input
    //control signal in
    .clk(clk), 
    //adder 0
    .exponent_diff_0(compare_exponent_diff_0),
    .exponent_big_0_in(compare_exponent_big_0_out),
    .mantissa_big_0_in(compare_mantissa_big_0), 
    .mantissa_small_0(compare_mantissa_small_0),
    //adder 1
    .exponent_diff_1(compare_exponent_diff_1),
    .exponent_big_1_in(compare_exponent_big_1_out),
    .mantissa_big_1_in(compare_mantissa_big_1), 
    .mantissa_small_1(compare_mantissa_small_1),
    //output
    //adder 0
    .exponent_big_0_out(align_exponent_big_0_out),
    .mantissa_big_0_out(align_mantissa_big_0_out), 
    .mantissa_aligned_0(align_mantissa_aligned_0),
    //adder 1
    .exponent_big_1_out(align_exponent_big_1_out),
    .mantissa_big_1_out(align_mantissa_big_1_out), 
    .mantissa_aligned_1(align_mantissa_aligned_1)
  );

  //Stage 3 : Add
  fp32_adder_dual_add_stage #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISA_WIDTH(MANTISA_WIDTH)
  ) fp32_adder_dual_add_stage(
    //input
    //control signal
    .clk(clk), 
    //adder 0
    .exponent_big_0_in(align_exponent_big_0_out),
    .mantissa_big_0_in(align_mantissa_big_0_out),
    .mantissa_aligned_0(align_mantissa_aligned_0),
    //adder 1
    .exponent_big_1_in(align_exponent_big_1_out),
    .mantissa_big_1_in(align_mantissa_big_1_out),
    .mantissa_aligned_1(align_mantissa_aligned_1),
    //output
    //adder 0
    .add_0_out(add_add_0_out),
    .exponent_big_0_out(add_exponent_big_0_out),
    //adder 1
    .add_1_out(add_add_1_out),
    .exponent_big_1_out(add_exponent_big_1_out)
  );

  // Normalization
  fp32_adder_dual_normalization_stage #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISA_WIDTH(MANTISA_WIDTH)
  ) fp32_adder_dual_normalization_stage(
    //input
    //control signal
    .clk(clk),
    //adder 0
    .add_0_in(add_add_0_out),
    .exponent_big_0_in(add_exponent_big_0_out),
    //adder 1
    .add_1_in(add_add_1_out),
    .exponent_big_1_in(add_exponent_big_1_out),
    //output
    //adder 0
    .result_exponent_0(exponent_0_out),
    .result_mantissa_0(mantissa_0_out), 
    //adder 1
    .result_exponent_1(exponent_1_out),
    .result_mantissa_1(mantissa_1_out)
  );
endmodule
