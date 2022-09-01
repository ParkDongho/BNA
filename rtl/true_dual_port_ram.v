`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/24 22:47:09
// Design Name: 
// Module Name: true_dual_port_ram
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


module true_dual_port_ram
#(
  parameter ADDR_WIDTH = 15,
  parameter DATA_WIDTH = 28 //7bit*4
) (
  input wire clk,
  input wire activation_rd_en_i, wr_en,
  input wire [ADDR_WIDTH-1:0] wr_addr,
  input wire [DATA_WIDTH-1:0] data_i,
  input wire [ADDR_WIDTH-1:0] rd_addr,
  output reg [DATA_WIDTH-1:0] buffer_activation_data_o
);
  
  // signal declaration
  reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];

  
  // body
  always @(posedge clk) 
  begin
    if(activation_rd_en_i) //read opearation
      buffer_activation_data_o <= ram[rd_addr];
    if(wr_en) //write operation
      ram[wr_addr] <= data_i;
  end
endmodule
