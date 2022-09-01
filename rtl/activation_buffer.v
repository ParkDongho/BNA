`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/16 21:20:58
// Design Name: 
// Module Name: activation_buffer
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


module activation_buffer
#(
  parameter DATA_WIDTH = 7,
  parameter MAC_ACC_WIDTH = 48,
  parameter BUFFER_ADDR_WIDTH = 15
) (
  input  wire clk,
  //Buffer
  input  wire activation_rd_en_i, buffer_wr_en_i,
  input  wire [BUFFER_ADDR_WIDTH-1:0] buffer_rd_addr_i, buffer_wr_addr,
  input  wire [DATA_WIDTH*4-1:0] buffer_data_i,
  output reg activation_rd_en_o,
  output reg [BUFFER_ADDR_WIDTH-1:0] buffer_rd_addr_o,
  output reg [DATA_WIDTH*4-1:0] buffer_activation_data_o
);

  wire [DATA_WIDTH*4-1:0] buffer_activation_data;
  reg [BUFFER_ADDR_WIDTH-1:0] buffer_rd_addr;
  reg activation_rd_tmp_en;
  
  always @(posedge clk)
  begin
    activation_rd_tmp_en <= activation_rd_en_i;
    buffer_rd_addr <= buffer_rd_addr_i;
    activation_rd_en_o <= activation_rd_tmp_en;
    buffer_rd_addr_o <= buffer_rd_addr;
    buffer_activation_data_o <= buffer_activation_data;
  end

  simple_dual_port_ram
  #(
    .ADDR_WIDTH(BUFFER_ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH*4)
  ) dual_port_ram(
    .clk(clk), 
    .rd_en(activation_rd_en_i),
    .wr_en(buffer_wr_en_i),
    .wr_addr(buffer_wr_addr),
    .data_i(buffer_data_i),
    .rd_addr(buffer_rd_addr_i),
    .data_o_r(buffer_activation_data)
  );
endmodule
