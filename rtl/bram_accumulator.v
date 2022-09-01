`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/21 05:41:22
// Design Name: 
// Module Name: bram_accumulator
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


module bram_accumulator
#(
  parameter ADDR_WIDTH = 8,
  parameter DATA_WIDTH = 64
)
(
  input wire clk,
  input wire i_rd_en,
  input wire i_wr_en,
  
  input wire [ADDR_WIDTH-1:0] i_rd_addr,  
  input wire [ADDR_WIDTH-1:0] i_wr_addr,
  
  input wire [DATA_WIDTH-1:0] i_data,
  output wire [DATA_WIDTH-1:0] o_data
);

    
  simple_dual_port_ram
  #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  )simple_dual_port_ram_accumulator(
    .clk(clk), 
    .rd_en(i_rd_en),
    .wr_en(i_wr_en),
    .wr_addr(i_wr_addr),
    .data_i(i_data),
    .rd_addr(i_rd_addr),
    .data_o_r(o_data)
  );
endmodule
