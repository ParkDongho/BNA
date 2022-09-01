`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:26:58
// Design Name: 
// Module Name: fp7_alu_add_stage
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


module fp7_alu_add_stage
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISSA_WIDTH = 24
) 
(
  input  wire clk, //controll signal in
  input  wire i_exponent_big_a,
  input  wire signed [MANTISSA_WIDTH-1:0] mantissa_big_in, mantissa_aligned,
  output reg  compare_mantissa_o,
  output reg  o_exponent_big_a
);
  wire signed [MANTISSA_WIDTH:0] compare_mantissa_tmp;
  assign compare_mantissa_tmp = mantissa_big_in - mantissa_aligned;

  always @(posedge clk) 
  begin
    compare_mantissa_o <= compare_mantissa_tmp[MANTISSA_WIDTH];
    o_exponent_big_a <= i_exponent_big_a;
  end
endmodule