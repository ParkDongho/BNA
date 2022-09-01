`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/03/16 16:23:31
// Design Name: 
// Module Name: SRLC_shift_register
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


module SRLC_shift_register
#(
  DELAY = 32 
)
(
  input  wire    clk,
  input  wire    rst_n,
  input  wire    i_data,
  output wire    o_data
);

reg [DELAY-1:0] data;

  always @(posedge clk)
  begin
    if(rst_n==1'b0)
    begin
      data[DELAY-1] <= 'd0;
    end
    else
    begin
      data[DELAY-1] <= data[DELAY-2];
    end
    data[DELAY-2:0] <= {data[DELAY-3:0], i_data};
  end
  assign o_data = data[DELAY-1];
endmodule
