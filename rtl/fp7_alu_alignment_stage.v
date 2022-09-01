`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:26:58
// Design Name: 
// Module Name: fp7_alu_alignment_stage
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


module fp7_alu_alignment_stage
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISSA_WIDTH = 24
) (
  input  wire clk, //controll signal in
  input  wire i_exponent_big_a,
  input  wire signed [EXPONENT_WIDTH:0] exponent_diff,
  input  wire signed [MANTISSA_WIDTH-1:0] mantissa_big_in, mantissa_small, 
  output reg  o_exponent_big_a,
  output reg  signed [MANTISSA_WIDTH-1:0] mantissa_big_out, mantissa_aligned
);

  always @(posedge clk)
  begin
    mantissa_aligned <= mantissa_small >>> exponent_diff; //arthmetic shift right
    mantissa_big_out <= mantissa_big_in;
    o_exponent_big_a <= i_exponent_big_a;
  end
  
endmodule
