`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/03/16 15:33:35
// Design Name: 
// Module Name: variable_length_shift_register
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


module variable_length_shift_register
#(
  DATA_WIDTH = 32,
  DELAY = 32 
)
(
  input  wire                     clk,
  input  wire                     rst_n,
  input  wire [DATA_WIDTH-1:0]    i_data,
  output wire [DATA_WIDTH-1:0]    o_data
);
  genvar i;

  generate
    for(i=0; i<DATA_WIDTH; i = i + 1)
    begin
      SRLC_shift_register
      #(
        .DELAY(DELAY) 
      ) SRLC_shift_register
      (
        .clk(clk),
        .rst_n(rst_n),
        .i_data(i_data[i]),
        .o_data(o_data[i])
      );
    end
  endgenerate
endmodule
