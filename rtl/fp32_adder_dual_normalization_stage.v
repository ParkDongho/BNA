`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/20 23:05:37
// Design Name: 
// Module Name: fp32_adder_dual_normalization_stage
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


module fp32_adder_dual_normalization_stage
#(
  parameter EXPONENT_WIDTH = 8,
  parameter MANTISA_WIDTH = 24
) (
  input  wire clk,//controll signal
  input  wire signed [EXPONENT_WIDTH-1:0] exponent_big_0_in, exponent_big_1_in,
  input  wire signed [MANTISA_WIDTH:0] add_0_in, add_1_in,
  output reg  signed [EXPONENT_WIDTH-1:0] result_exponent_0, result_exponent_1,
  output reg  signed [MANTISA_WIDTH-1:0] result_mantissa_0, result_mantissa_1
);

  wire signed [MANTISA_WIDTH:0] norm_result_0, norm_result_1;

  reg [4:0] lzc_0_out, lzc_1_out;
  reg signed [EXPONENT_WIDTH-1:0] exponent_big_0, exponent_big_1;
  reg signed [MANTISA_WIDTH:0] add_0, add_1;

  assign norm_result_0 = add_0 << lzc_0_out;
  assign norm_result_1 = add_1 << lzc_1_out;

  always @(posedge clk) 
  begin
    exponent_big_0 <= exponent_big_0_in + 1;
    exponent_big_1 <= exponent_big_1_in + 1;
    add_0 <= add_0_in;
    add_1 <= add_1_in;

    result_mantissa_0 <= norm_result_0[MANTISA_WIDTH:1];
    result_exponent_0 <= exponent_big_0 - lzc_0_out;
    result_mantissa_1 <= norm_result_1[MANTISA_WIDTH:1];
    result_exponent_1 <= exponent_big_1 - lzc_1_out;
  end

  //Leading Zero Counter 0
  always @(posedge clk)
  begin
    casex(add_0_in[MANTISA_WIDTH]?~add_0_in[MANTISA_WIDTH-1:0]:add_0_in[MANTISA_WIDTH-1:0])
      24'b000000000000000000000001 : lzc_0_out <= 'd23;
      24'b00000000000000000000001x : lzc_0_out <= 'd22;
      24'b0000000000000000000001xx : lzc_0_out <= 'd21;
      24'b000000000000000000001xxx : lzc_0_out <= 'd20;
      24'b00000000000000000001xxxx : lzc_0_out <= 'd19;
      24'b0000000000000000001xxxxx : lzc_0_out <= 'd18;
      24'b000000000000000001xxxxxx : lzc_0_out <= 'd17;
      24'b00000000000000001xxxxxxx : lzc_0_out <= 'd16;
      24'b0000000000000001xxxxxxxx : lzc_0_out <= 'd15;
      24'b000000000000001xxxxxxxxx : lzc_0_out <= 'd14;
      24'b00000000000001xxxxxxxxxx : lzc_0_out <= 'd13;
      24'b0000000000001xxxxxxxxxxx : lzc_0_out <= 'd12;
      24'b000000000001xxxxxxxxxxxx : lzc_0_out <= 'd11;
      24'b00000000001xxxxxxxxxxxxx : lzc_0_out <= 'd10;
      24'b0000000001xxxxxxxxxxxxxx : lzc_0_out <= 'd9;
      24'b000000001xxxxxxxxxxxxxxx : lzc_0_out <= 'd8;
      24'b00000001xxxxxxxxxxxxxxxx : lzc_0_out <= 'd7;
      24'b0000001xxxxxxxxxxxxxxxxx : lzc_0_out <= 'd6;
      24'b000001xxxxxxxxxxxxxxxxxx : lzc_0_out <= 'd5;
      24'b00001xxxxxxxxxxxxxxxxxxx : lzc_0_out <= 'd4;
      24'b0001xxxxxxxxxxxxxxxxxxxx : lzc_0_out <= 'd3;
      24'b001xxxxxxxxxxxxxxxxxxxxx : lzc_0_out <= 'd2;
      24'b01xxxxxxxxxxxxxxxxxxxxxx : lzc_0_out <= 'd1;
      default: lzc_0_out <= 'd0;
    endcase
  end

  //Leading Zero Counter 1
  always @(posedge clk)
  begin
    casex(add_1_in[MANTISA_WIDTH]?~add_1_in[MANTISA_WIDTH-1:0]:add_1_in[MANTISA_WIDTH-1:0])
      24'b000000000000000000000001 : lzc_1_out <= 'd23;
      24'b00000000000000000000001x : lzc_1_out <= 'd22;
      24'b0000000000000000000001xx : lzc_1_out <= 'd21;
      24'b000000000000000000001xxx : lzc_1_out <= 'd20;
      24'b00000000000000000001xxxx : lzc_1_out <= 'd19;
      24'b0000000000000000001xxxxx : lzc_1_out <= 'd18;
      24'b000000000000000001xxxxxx : lzc_1_out <= 'd17;
      24'b00000000000000001xxxxxxx : lzc_1_out <= 'd16;
      24'b0000000000000001xxxxxxxx : lzc_1_out <= 'd15;
      24'b000000000000001xxxxxxxxx : lzc_1_out <= 'd14;
      24'b00000000000001xxxxxxxxxx : lzc_1_out <= 'd13;
      24'b0000000000001xxxxxxxxxxx : lzc_1_out <= 'd12;
      24'b000000000001xxxxxxxxxxxx : lzc_1_out <= 'd11;
      24'b00000000001xxxxxxxxxxxxx : lzc_1_out <= 'd10;
      24'b0000000001xxxxxxxxxxxxxx : lzc_1_out <= 'd9;
      24'b000000001xxxxxxxxxxxxxxx : lzc_1_out <= 'd8;
      24'b00000001xxxxxxxxxxxxxxxx : lzc_1_out <= 'd7;
      24'b0000001xxxxxxxxxxxxxxxxx : lzc_1_out <= 'd6;
      24'b000001xxxxxxxxxxxxxxxxxx : lzc_1_out <= 'd5;
      24'b00001xxxxxxxxxxxxxxxxxxx : lzc_1_out <= 'd4;
      24'b0001xxxxxxxxxxxxxxxxxxxx : lzc_1_out <= 'd3;
      24'b001xxxxxxxxxxxxxxxxxxxxx : lzc_1_out <= 'd2;
      24'b01xxxxxxxxxxxxxxxxxxxxxx : lzc_1_out <= 'd1;
      default: lzc_1_out <= 'd0;
    endcase
  end
endmodule
