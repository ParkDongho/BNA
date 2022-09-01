`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/20 00:24:11
// Design Name: 
// Module Name: exponent_buffer
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


module exponent_buffer
#(
  parameter DATA_WIDTH = 8,
  parameter BUFFER_ADDR_WIDTH = 15
) (
  input  wire clk, rst_n,
  //Buffer
  input  wire activation_rd_en_i, buffer_wr_en_i,
  input  wire [BUFFER_ADDR_WIDTH-1:0] buffer_rd_addr_i, buffer_wr_addr,
  input  wire [DATA_WIDTH-1:0] buffer_data_i,
  output reg [DATA_WIDTH-1:0] buffer_activation_data_o
);

  wire [DATA_WIDTH-1:0] buffer_activation_data;
  reg                            activation_rd_en_0;
  reg                            activation_rd_en_1;
  reg [BUFFER_ADDR_WIDTH-1:0]    buffer_rd_addr_0;
  reg [BUFFER_ADDR_WIDTH-1:0]    buffer_rd_addr_1;


  always @(posedge clk)
  begin
    activation_rd_en_0 <= activation_rd_en_i;
    activation_rd_en_1 <= activation_rd_en_0;
    buffer_rd_addr_0 <= buffer_rd_addr_i;
    buffer_rd_addr_1 <= buffer_rd_addr_0;
    buffer_activation_data_o <= buffer_activation_data + 2;
  end

  true_dual_port_ram
  #(
    .ADDR_WIDTH(BUFFER_ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) dual_port_ram(
    .clk(clk), 
    .activation_rd_en_i(activation_rd_en_1),
    .wr_en(buffer_wr_en_i),
    
    .wr_addr(buffer_wr_addr),
    .data_i(buffer_data_i),
    .rd_addr(buffer_rd_addr_1),
    .buffer_activation_data_o(buffer_activation_data)
  );
  endmodule
