`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/16 00:50:34
// Design Name: 
// Module Name: simple_dual_port_no_rden
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


module simple_dual_port_no_rden
#(
  parameter ADDR_WIDTH = 15,
  parameter DATA_WIDTH = 28 //7bit*4
) (
  input  wire clk,
  input  wire wr_en,
  input  wire [ADDR_WIDTH-1:0] wr_addr,
  input  wire [DATA_WIDTH-1:0] data_i,
  input  wire [ADDR_WIDTH-1:0] rd_addr,
  output wire [DATA_WIDTH-1:0] data_o_r
);
  
  // signal declaration
  reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
  
  // body
  always @(posedge clk) 
  begin
    if(wr_en) //write operation
      ram[wr_addr] <= data_i;
  end
  assign data_o_r = ram[rd_addr];
endmodule
