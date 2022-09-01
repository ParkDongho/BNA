`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:24:09
// Design Name: 
// Module Name: fp32_multiplier_rounding_stage
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


module fp32_multiplier_rounding_stage
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISSA_A_WIDTH = 24,
  parameter MANTISSA_B_WIDTH = 18,
  parameter QUNATIZED_MANTISSA_WIDTH = 6
) (
  input  wire                                         clk,                        
  input  wire                                         mul_op,
  input  wire signed [EXPONENT_WIDTH:0]                      exponent_round_in,
  input  wire signed [MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-1:0] mantissa_round_in,
  input  wire signed [MANTISSA_A_WIDTH+EXPONENT_WIDTH-1:0]   i_mul_data,
  output  reg signed [MANTISSA_A_WIDTH+EXPONENT_WIDTH-1:0]   o_mul_data
);

  reg  signed [MANTISSA_A_WIDTH+EXPONENT_WIDTH-1:0]          mul_data_0;
  reg  signed [MANTISSA_A_WIDTH+EXPONENT_WIDTH-1:0]          mul_data_1;
  reg  signed [MANTISSA_A_WIDTH+EXPONENT_WIDTH-1:0]          mul_data_2;
  wire signed [MANTISSA_A_WIDTH-1:0]                         quantized_mantissa_out; //quantized output

  always @(posedge clk)
  begin
    if(mul_op)
    begin
      o_mul_data <= {exponent_round_in[EXPONENT_WIDTH-1:0], quantized_mantissa_out}; //rounding (4bit)
    end
    else
    begin
      o_mul_data <= mul_data_2;
    end
    mul_data_0 <= i_mul_data;
    mul_data_1 <= mul_data_0;
    mul_data_2 <= mul_data_1;
  end
  
  assign quantized_mantissa_out = mantissa_round_in[MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-1:MANTISSA_B_WIDTH]
                                                 + |mantissa_round_in[MANTISSA_B_WIDTH-1:MANTISSA_B_WIDTH-4];
endmodule
