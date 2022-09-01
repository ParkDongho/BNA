`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/21 04:12:16
// Design Name: 
// Module Name: SRLC_RTL
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


module SRLC_RTL
#(
  ADDR_WIDTH = 5
)
(
  input wire clk,
  input wire wr_en,
  input wire i_data,
  input wire [ADDR_WIDTH-1:0] addr,
  output wire o_data
);
  reg [2**ADDR_WIDTH-1:0] data;
  always @(posedge clk)
  begin
  if(wr_en)
      data <= {data[2**ADDR_WIDTH-2:0], i_data};
  end
  
  assign o_data = data[addr];
endmodule
