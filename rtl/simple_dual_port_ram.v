`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/16 21:27:12
// Design Name: 
// Module Name: simple_dual_port_ram
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


module simple_dual_port_ram
#(
  parameter ADDR_WIDTH = 15,
  parameter DATA_WIDTH = 28 //7bit*4
) (
  input  wire clk,
  input  wire rd_en, wr_en,
  input  wire [ADDR_WIDTH-1:0] wr_addr,
  input  wire [DATA_WIDTH-1:0] data_i,
  input  wire [ADDR_WIDTH-1:0] rd_addr,
  output reg  [DATA_WIDTH-1:0] data_o_r
);
  
  // signal declaration
  reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
  
  // body
  always @(posedge clk) 
  begin
    if(wr_en) //write operation
      ram[wr_addr] <= data_i;
    if(rd_en)
      data_o_r <= ram[rd_addr];
  end
endmodule
