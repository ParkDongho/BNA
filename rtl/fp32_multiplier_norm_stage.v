`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/21 17:19:43
// Design Name: 
// Module Name: fp32_multiplier_norm_stage
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


module fp32_multiplier_norm_stage
#(
  parameter EXPONENT_WIDTH  = 8,
  parameter MANTISSA_A_WIDTH = 24,
  parameter MANTISSA_B_WIDTH = 18
)
(
  input  wire clk,
  input  wire signed [EXPONENT_WIDTH:0] exponent_norm_in,
  input  wire signed [MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-1:0] mantissa_norm_in,
  output reg  signed [EXPONENT_WIDTH:0] exponent_norm_out,
  output reg  signed [MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-1:0] mantissa_norm_out
);
  reg [5:0] lzc_out;
  reg [5:0] lzc_out_reg;
  reg signed [MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-1:0] mantissa_norm;
  reg signed [EXPONENT_WIDTH:0] exponent_norm;
    
  always @(posedge clk)
  begin
    mantissa_norm <= mantissa_norm_in;
    exponent_norm <= exponent_norm_in + 2;
    lzc_out_reg <= lzc_out;
    mantissa_norm_out <= mantissa_norm << lzc_out_reg;
    exponent_norm_out <= exponent_norm - lzc_out_reg;
  end

//Leading Zero Counter
  always @(*)begin
    casex(mantissa_norm_in[MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-1]
         ?(~mantissa_norm_in[MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-2:0])
         :(mantissa_norm_in[MANTISSA_A_WIDTH+MANTISSA_B_WIDTH-2:0]))
      41'b00000000000000000000000000000000000000001 : lzc_out = 'd40;
      41'b0000000000000000000000000000000000000001x : lzc_out = 'd39;
      41'b000000000000000000000000000000000000001xx : lzc_out = 'd38;
      41'b00000000000000000000000000000000000001xxx : lzc_out = 'd37;
      41'b0000000000000000000000000000000000001xxxx : lzc_out = 'd36;
      41'b000000000000000000000000000000000001xxxxx : lzc_out = 'd35;
      41'b00000000000000000000000000000000001xxxxxx : lzc_out = 'd34;
      41'b0000000000000000000000000000000001xxxxxxx : lzc_out = 'd33;
      41'b000000000000000000000000000000001xxxxxxxx : lzc_out = 'd32;
      41'b00000000000000000000000000000001xxxxxxxxx : lzc_out = 'd31;
      41'b0000000000000000000000000000001xxxxxxxxxx : lzc_out = 'd30;
      41'b000000000000000000000000000001xxxxxxxxxxx : lzc_out = 'd29;
      41'b00000000000000000000000000001xxxxxxxxxxxx : lzc_out = 'd28;
      41'b0000000000000000000000000001xxxxxxxxxxxxx : lzc_out = 'd27;
      41'b000000000000000000000000001xxxxxxxxxxxxxx : lzc_out = 'd26;
      41'b00000000000000000000000001xxxxxxxxxxxxxxx : lzc_out = 'd25;
      41'b0000000000000000000000001xxxxxxxxxxxxxxxx : lzc_out = 'd24;
      41'b000000000000000000000001xxxxxxxxxxxxxxxxx : lzc_out = 'd23;
      41'b00000000000000000000001xxxxxxxxxxxxxxxxxx : lzc_out = 'd22;
      41'b0000000000000000000001xxxxxxxxxxxxxxxxxxx : lzc_out = 'd21;
      41'b000000000000000000001xxxxxxxxxxxxxxxxxxxx : lzc_out = 'd20;
      41'b00000000000000000001xxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd19;
      41'b0000000000000000001xxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd18;
      41'b000000000000000001xxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd17;
      41'b00000000000000001xxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd16;
      41'b0000000000000001xxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd15;
      41'b000000000000001xxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd14;
      41'b00000000000001xxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd13;
      41'b0000000000001xxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd12;
      41'b000000000001xxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd11;
      41'b00000000001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd10;
      41'b0000000001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd9;
      41'b000000001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd8;
      41'b00000001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd7;
      41'b0000001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd6;
      41'b000001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd5;
      41'b00001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd4;
      41'b0001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd3;
      41'b001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd2;
      41'b01xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx : lzc_out = 'd1;
      default: lzc_out = 'd0;
    endcase
  end
endmodule
