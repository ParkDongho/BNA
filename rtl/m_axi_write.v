`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/25 03:19:59
// Design Name: 
// Module Name: m_axi_write
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


module m_axi_write
#(
  parameter ACCUM_DATA_WIDTH = 32,
  
  parameter AXI_WIDTH_USER =1,              // Master ID
  parameter AXI_WIDTH_ID   =4,              // ID width in bits
  parameter AXI_WIDTH_AD   =32,             // address width
  parameter AXI_WIDTH_DA   =32,             // data width
  parameter AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width
  parameter AXI_LITE_WIDTH_AD   =32,        // axi lite address width
  parameter AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8) // data strobe width
)
(
  input  wire clk,
  input  wire store_data_reg_wr_en,
  input  wire [4:0] sel_store_data,

  //Floating Point Data in
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_0_i,  stor_1_i,  stor_2_i,  stor_3_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_4_i,  stor_5_i,  stor_6_i,  stor_7_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_8_i,  stor_9_i,  stor_10_i, stor_11_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_12_i, stor_13_i, stor_14_i, stor_15_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_16_i, stor_17_i, stor_18_i, stor_19_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_20_i, stor_21_i, stor_22_i, stor_23_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_24_i, stor_25_i, stor_26_i, stor_27_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_28_i, stor_29_i, stor_30_i, stor_31_i,
  
  // AXI MASTER 
  output reg  [AXI_WIDTH_DA-1:0]      m_axi_memory_bus_WDATA
);

  reg   [ACCUM_DATA_WIDTH-1:0] stor_0_reg,  stor_1_reg,  stor_2_reg,  stor_3_reg;
  reg   [ACCUM_DATA_WIDTH-1:0] stor_4_reg,  stor_5_reg,  stor_6_reg,  stor_7_reg;
  reg   [ACCUM_DATA_WIDTH-1:0] stor_8_reg,  stor_9_reg,  stor_10_reg, stor_11_reg;
  reg   [ACCUM_DATA_WIDTH-1:0] stor_12_reg, stor_13_reg, stor_14_reg, stor_15_reg;
  reg   [ACCUM_DATA_WIDTH-1:0] stor_16_reg, stor_17_reg, stor_18_reg, stor_19_reg;
  reg   [ACCUM_DATA_WIDTH-1:0] stor_20_reg, stor_21_reg, stor_22_reg, stor_23_reg;
  reg   [ACCUM_DATA_WIDTH-1:0] stor_24_reg, stor_25_reg, stor_26_reg, stor_27_reg;
  reg   [ACCUM_DATA_WIDTH-1:0] stor_28_reg, stor_29_reg, stor_30_reg, stor_31_reg;

  always@(posedge clk)
  begin
    begin
      stor_0_reg <= stor_0_i;
      stor_1_reg <= stor_1_i;
      stor_2_reg <= stor_2_i;
      stor_3_reg <= stor_3_i;
      stor_4_reg <= stor_4_i;
      stor_5_reg <= stor_5_i;
      stor_6_reg <= stor_6_i;
      stor_7_reg <= stor_7_i;
      stor_8_reg <= stor_8_i;
      stor_9_reg <= stor_9_i;
      stor_10_reg <= stor_10_i;
      stor_11_reg <= stor_11_i;
      stor_12_reg <= stor_12_i;
      stor_13_reg <= stor_13_i;
      stor_14_reg <= stor_14_i;
      stor_15_reg <= stor_15_i;
      stor_16_reg <= stor_16_i;
      stor_17_reg <= stor_17_i;
      stor_18_reg <= stor_18_i;
      stor_19_reg <= stor_19_i;
      stor_20_reg <= stor_20_i;
      stor_21_reg <= stor_21_i;
      stor_22_reg <= stor_22_i;
      stor_23_reg <= stor_23_i;
      stor_24_reg <= stor_24_i;
      stor_25_reg <= stor_25_i;
      stor_26_reg <= stor_26_i;
      stor_27_reg <= stor_27_i;
      stor_28_reg <= stor_28_i;
      stor_29_reg <= stor_29_i;
      stor_30_reg <= stor_30_i;
      stor_31_reg <= stor_31_i;
    end

    if(store_data_reg_wr_en)
    begin
      case(sel_store_data)
        5'b00000 : m_axi_memory_bus_WDATA <= stor_0_reg;
        5'b00001 : m_axi_memory_bus_WDATA <= stor_1_reg;
        5'b00010 : m_axi_memory_bus_WDATA <= stor_2_reg;
        5'b00011 : m_axi_memory_bus_WDATA <= stor_3_reg;
        5'b00100 : m_axi_memory_bus_WDATA <= stor_4_reg;
        5'b00101 : m_axi_memory_bus_WDATA <= stor_5_reg;
        5'b00110 : m_axi_memory_bus_WDATA <= stor_6_reg;
        5'b00111 : m_axi_memory_bus_WDATA <= stor_7_reg;
        5'b01000 : m_axi_memory_bus_WDATA <= stor_8_reg;
        5'b01001 : m_axi_memory_bus_WDATA <= stor_9_reg;
        5'b01010 : m_axi_memory_bus_WDATA <= stor_10_reg;
        5'b01011 : m_axi_memory_bus_WDATA <= stor_11_reg;
        5'b01100 : m_axi_memory_bus_WDATA <= stor_12_reg;
        5'b01101 : m_axi_memory_bus_WDATA <= stor_13_reg;
        5'b01110 : m_axi_memory_bus_WDATA <= stor_14_reg;
        5'b01111 : m_axi_memory_bus_WDATA <= stor_15_reg;
        5'b10000 : m_axi_memory_bus_WDATA <= stor_16_reg;
        5'b10001 : m_axi_memory_bus_WDATA <= stor_17_reg;
        5'b10010 : m_axi_memory_bus_WDATA <= stor_18_reg;
        5'b10011 : m_axi_memory_bus_WDATA <= stor_19_reg;
        5'b10100 : m_axi_memory_bus_WDATA <= stor_20_reg;
        5'b10101 : m_axi_memory_bus_WDATA <= stor_21_reg;
        5'b10110 : m_axi_memory_bus_WDATA <= stor_22_reg;
        5'b10111 : m_axi_memory_bus_WDATA <= stor_23_reg;
        5'b11000 : m_axi_memory_bus_WDATA <= stor_24_reg;
        5'b11001 : m_axi_memory_bus_WDATA <= stor_25_reg;
        5'b11010 : m_axi_memory_bus_WDATA <= stor_26_reg;
        5'b11011 : m_axi_memory_bus_WDATA <= stor_27_reg;
        5'b11100 : m_axi_memory_bus_WDATA <= stor_28_reg;
        5'b11101 : m_axi_memory_bus_WDATA <= stor_29_reg;
        5'b11110 : m_axi_memory_bus_WDATA <= stor_30_reg;
        5'b11111 : m_axi_memory_bus_WDATA <= stor_31_reg;
      endcase
    end
  end
  
endmodule
