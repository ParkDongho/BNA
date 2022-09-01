`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:11:12
// Design Name: 
// Module Name: fp7_alu
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


module fp7_alu
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISSA_WIDTH = 7,
  parameter ACCUM_DATA_WIDTH = 32
) (
  input  wire clk,
  input  wire alu_op,
  input  wire [ACCUM_DATA_WIDTH-1:0] alu_data_a_i, alu_data_b_i,
  output wire [ACCUM_DATA_WIDTH-1:0] alu_data_o
);

  wire [EXPONENT_WIDTH-1:0] alu_exponent_a_in, alu_exponent_b_in;
  wire [MANTISSA_WIDTH-1:0] alu_mantissa_a_in, alu_mantissa_b_in;
  wire alu_exponent_big_a;

  wire [EXPONENT_WIDTH:0]   compare_exponent_diff;
  wire [MANTISSA_WIDTH-1:0] compare_mantissa_big, compare_mantissa_small;
  wire compare_exponent_big_a;

  wire compare_mantissa_o;
  wire [MANTISSA_WIDTH-1:0] align_mantissa_big_out, align_mantissa_aligned;
  wire align_exponent_big_a;
  
  assign {alu_exponent_a_in, alu_mantissa_a_in} 
       = alu_data_a_i[ACCUM_DATA_WIDTH-1:ACCUM_DATA_WIDTH-EXPONENT_WIDTH-MANTISSA_WIDTH];
  assign {alu_exponent_b_in, alu_mantissa_b_in}
       = alu_data_b_i[ACCUM_DATA_WIDTH-1:ACCUM_DATA_WIDTH-EXPONENT_WIDTH-MANTISSA_WIDTH];
  
  //Stage 1 : Compare
  fp7_alu_compare_stage #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISSA_WIDTH(MANTISSA_WIDTH)
  ) fp7_alu_compare_stage(
    //input
    .clk(clk),
    .exponent_a(alu_exponent_a_in), // exponent_a : from accumulator
    .exponent_b(alu_exponent_b_in), // exponent_b : from systolic array
    .mantissa_a(alu_mantissa_a_in), // mantissa_a : from accumulator
    .mantissa_b(alu_mantissa_b_in), // mantissa_b : from systolic array
    //output
    .exponent_big_a(alu_exponent_big_a),
    .exponent_diff(compare_exponent_diff), 
    .mantissa_big(compare_mantissa_big),
    .mantissa_small(compare_mantissa_small)
  );

  //Stage 2 : Alignment
  fp7_alu_alignment_stage #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISSA_WIDTH(MANTISSA_WIDTH)
  ) fp7_alu_alignment_stage(
    //input
    .clk(clk), //controll signal in
    .i_exponent_big_a(alu_exponent_big_a),
    .exponent_diff(compare_exponent_diff), //data in
    .mantissa_big_in(compare_mantissa_big), 
    .mantissa_small(compare_mantissa_small),
    //output
    .o_exponent_big_a(compare_exponent_big_a),
    .mantissa_big_out(align_mantissa_big_out), 
    .mantissa_aligned(align_mantissa_aligned)
  );

  //Stage 3 : Compare
  fp7_alu_add_stage #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MANTISSA_WIDTH(MANTISSA_WIDTH)
  ) fp7_alu_add_stage(
    .clk(clk), //controll signal in
    .i_exponent_big_a(compare_exponent_big_a),
    .mantissa_big_in(align_mantissa_big_out),
    .mantissa_aligned(align_mantissa_aligned),
    .o_exponent_big_a(align_exponent_big_a),
    .compare_mantissa_o(compare_mantissa_o)
  );

  //Stage 4 : 
  fp7_alu_select_stage #(
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH)
  ) fp7_alu_select_stage(
    .clk(clk),
    .i_exponent_big_a(align_exponent_big_a),
    .alu_op(alu_op),
    .select_data(compare_mantissa_o),
    .alu_data_a_i(alu_data_a_i),
    .alu_data_b_i(alu_data_b_i),
    .alu_data_o(alu_data_o)
  );
endmodule