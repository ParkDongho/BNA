`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/20 23:05:37
// Design Name: 
// Module Name: fp32_adder_dual_add_stage
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


/*(* use_dsp48 = "yes" *) */module fp32_adder_dual_add_stage
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISA_WIDTH = 24
) (
  input  wire clk,//controll signal in
  input  wire signed [EXPONENT_WIDTH-1:0] exponent_big_0_in, exponent_big_1_in,
  input  wire signed [MANTISA_WIDTH-1:0] mantissa_big_0_in, mantissa_aligned_0,
  input  wire signed [MANTISA_WIDTH-1:0] mantissa_big_1_in, mantissa_aligned_1,
  
  output reg  signed [EXPONENT_WIDTH-1:0] exponent_big_0_out, exponent_big_1_out,
  output reg  signed [MANTISA_WIDTH:0] add_0_out, add_1_out
);

  always @(posedge clk) 
  begin
    //DSP48e1 SIMD mode
    add_0_out <= mantissa_big_0_in + mantissa_aligned_0; 
    add_1_out <= mantissa_big_1_in + mantissa_aligned_1;
    exponent_big_0_out <= exponent_big_0_in;
    exponent_big_1_out <= exponent_big_1_in;
  end
endmodule
