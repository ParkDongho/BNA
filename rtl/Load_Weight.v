`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/13 15:48:29
// Design Name: 
// Module Name: Load_Weight
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


module Load_Weight
#(
  parameter AXI_WIDTH_DA   =32             // data width
)
(
  input wire                         clk,
  //////////////////////////////////////////////////////////////////////////////////
  //Load Weight Control Signals/////////////////////////////////////////////////////
  //
  input wire                         i_load_weight_data_reg_wr_en,          
  input wire [4:0]                   i_sel_load_weight_data,
  //////////////////////////////////////////////////////////////////////////////////
  //AXI MASTER READ/////////////////////////////////////////////////////////////////
  //
  input wire [AXI_WIDTH_DA-1:0]      m_axi_weight_memory_bus_RDATA,
  //////////////////////////////////////////////////////////////////////////////////
  //Load Weight Out/////////////////////////////////////////////////////////////////
  output  wire [7:0]                 o_load_weight_data_0_a,
  output  wire [7:0]                 o_load_weight_data_0_b,
  output  wire [7:0]                 o_load_weight_data_0_c,
  output  wire [7:0]                 o_load_weight_data_0_d,

  output  wire [7:0]                 o_load_weight_data_1_a,
  output  wire [7:0]                 o_load_weight_data_1_b,
  output  wire [7:0]                 o_load_weight_data_1_c,
  output  wire [7:0]                 o_load_weight_data_1_d,

  output  wire [7:0]                 o_load_weight_data_2_a,
  output  wire [7:0]                 o_load_weight_data_2_b,
  output  wire [7:0]                 o_load_weight_data_2_c,
  output  wire [7:0]                 o_load_weight_data_2_d,

  output  wire [7:0]                 o_load_weight_data_3_a,
  output  wire [7:0]                 o_load_weight_data_3_b,
  output  wire [7:0]                 o_load_weight_data_3_c,
  output  wire [7:0]                 o_load_weight_data_3_d,

  output  wire [7:0]                 o_load_weight_data_4_a,
  output  wire [7:0]                 o_load_weight_data_4_b,
  output  wire [7:0]                 o_load_weight_data_4_c,
  output  wire [7:0]                 o_load_weight_data_4_d,

  output  wire [7:0]                 o_load_weight_data_5_a,
  output  wire [7:0]                 o_load_weight_data_5_b,
  output  wire [7:0]                 o_load_weight_data_5_c,
  output  wire [7:0]                 o_load_weight_data_5_d,

  output  wire [7:0]                 o_load_weight_data_6_a,
  output  wire [7:0]                 o_load_weight_data_6_b,
  output  wire [7:0]                 o_load_weight_data_6_c,
  output  wire [7:0]                 o_load_weight_data_6_d,

  output  wire [7:0]                 o_load_weight_data_7_a,
  output  wire [7:0]                 o_load_weight_data_7_b,
  output  wire [7:0]                 o_load_weight_data_7_c,
  output  wire [7:0]                 o_load_weight_data_7_d,

  output  wire [7:0]                 o_load_weight_data_8_a,
  output  wire [7:0]                 o_load_weight_data_8_b,
  output  wire [7:0]                 o_load_weight_data_8_c,
  output  wire [7:0]                 o_load_weight_data_8_d,

  output  wire [7:0]                 o_load_weight_data_9_a,
  output  wire [7:0]                 o_load_weight_data_9_b,
  output  wire [7:0]                 o_load_weight_data_9_c,
  output  wire [7:0]                 o_load_weight_data_9_d,

  output  wire [7:0]                 o_load_weight_data_10_a,
  output  wire [7:0]                 o_load_weight_data_10_b,
  output  wire [7:0]                 o_load_weight_data_10_c,
  output  wire [7:0]                 o_load_weight_data_10_d,

  output  wire [7:0]                 o_load_weight_data_11_a,
  output  wire [7:0]                 o_load_weight_data_11_b,
  output  wire [7:0]                 o_load_weight_data_11_c,
  output  wire [7:0]                 o_load_weight_data_11_d,

  output  wire [7:0]                 o_load_weight_data_12_a,
  output  wire [7:0]                 o_load_weight_data_12_b,
  output  wire [7:0]                 o_load_weight_data_12_c,
  output  wire [7:0]                 o_load_weight_data_12_d,

  output  wire [7:0]                 o_load_weight_data_13_a,
  output  wire [7:0]                 o_load_weight_data_13_b,
  output  wire [7:0]                 o_load_weight_data_13_c,
  output  wire [7:0]                 o_load_weight_data_13_d,

  output  wire [7:0]                 o_load_weight_data_14_a,
  output  wire [7:0]                 o_load_weight_data_14_b,
  output  wire [7:0]                 o_load_weight_data_14_c,
  output  wire [7:0]                 o_load_weight_data_14_d,

  output  wire [7:0]                 o_load_weight_data_15_a,
  output  wire [7:0]                 o_load_weight_data_15_b,
  output  wire [7:0]                 o_load_weight_data_15_c,
  output  wire [7:0]                 o_load_weight_data_15_d,

  output  wire [7:0]                 o_load_weight_data_16_a,
  output  wire [7:0]                 o_load_weight_data_16_b,
  output  wire [7:0]                 o_load_weight_data_16_c,
  output  wire [7:0]                 o_load_weight_data_16_d,

  output  wire [7:0]                 o_load_weight_data_17_a,
  output  wire [7:0]                 o_load_weight_data_17_b,
  output  wire [7:0]                 o_load_weight_data_17_c,
  output  wire [7:0]                 o_load_weight_data_17_d,

  output  wire [7:0]                 o_load_weight_data_18_a,
  output  wire [7:0]                 o_load_weight_data_18_b,
  output  wire [7:0]                 o_load_weight_data_18_c,
  output  wire [7:0]                 o_load_weight_data_18_d,

  output  wire [7:0]                 o_load_weight_data_19_a,
  output  wire [7:0]                 o_load_weight_data_19_b,
  output  wire [7:0]                 o_load_weight_data_19_c,
  output  wire [7:0]                 o_load_weight_data_19_d,

  output  wire [7:0]                 o_load_weight_data_20_a,
  output  wire [7:0]                 o_load_weight_data_20_b,
  output  wire [7:0]                 o_load_weight_data_20_c,
  output  wire [7:0]                 o_load_weight_data_20_d,

  output  wire [7:0]                 o_load_weight_data_21_a,
  output  wire [7:0]                 o_load_weight_data_21_b,
  output  wire [7:0]                 o_load_weight_data_21_c,
  output  wire [7:0]                 o_load_weight_data_21_d,

  output  wire [7:0]                 o_load_weight_data_22_a,
  output  wire [7:0]                 o_load_weight_data_22_b,
  output  wire [7:0]                 o_load_weight_data_22_c,
  output  wire [7:0]                 o_load_weight_data_22_d,

  output  wire [7:0]                 o_load_weight_data_23_a,
  output  wire [7:0]                 o_load_weight_data_23_b,
  output  wire [7:0]                 o_load_weight_data_23_c,
  output  wire [7:0]                 o_load_weight_data_23_d,

  output  wire [7:0]                 o_load_weight_data_24_a,
  output  wire [7:0]                 o_load_weight_data_24_b,
  output  wire [7:0]                 o_load_weight_data_24_c,
  output  wire [7:0]                 o_load_weight_data_24_d,

  output  wire [7:0]                 o_load_weight_data_25_a,
  output  wire [7:0]                 o_load_weight_data_25_b,
  output  wire [7:0]                 o_load_weight_data_25_c,
  output  wire [7:0]                 o_load_weight_data_25_d,

  output  wire [7:0]                 o_load_weight_data_26_a,
  output  wire [7:0]                 o_load_weight_data_26_b,
  output  wire [7:0]                 o_load_weight_data_26_c,
  output  wire [7:0]                 o_load_weight_data_26_d,

  output  wire [7:0]                 o_load_weight_data_27_a,
  output  wire [7:0]                 o_load_weight_data_27_b,
  output  wire [7:0]                 o_load_weight_data_27_c,
  output  wire [7:0]                 o_load_weight_data_27_d,

  output  wire [7:0]                 o_load_weight_data_28_a,
  output  wire [7:0]                 o_load_weight_data_28_b,
  output  wire [7:0]                 o_load_weight_data_28_c,
  output  wire [7:0]                 o_load_weight_data_28_d,

  output  wire [7:0]                 o_load_weight_data_29_a,
  output  wire [7:0]                 o_load_weight_data_29_b,
  output  wire [7:0]                 o_load_weight_data_29_c,
  output  wire [7:0]                 o_load_weight_data_29_d,

  output  wire [7:0]                 o_load_weight_data_30_a,
  output  wire [7:0]                 o_load_weight_data_30_b,
  output  wire [7:0]                 o_load_weight_data_30_c,
  output  wire [7:0]                 o_load_weight_data_30_d,

  output  wire [7:0]                 o_load_weight_data_31_a,
  output  wire [7:0]                 o_load_weight_data_31_b,
  output  wire [7:0]                 o_load_weight_data_31_c,
  output  wire [7:0]                 o_load_weight_data_31_d
);
  reg [31:0] axi_weight_brodcaster [31:0];



  always @(posedge clk)
  begin
    if(i_load_weight_data_reg_wr_en)
    begin
      case(i_sel_load_weight_data)
        5'b00000 : axi_weight_brodcaster[0] <= m_axi_weight_memory_bus_RDATA;
        5'b00001 : axi_weight_brodcaster[1] <= m_axi_weight_memory_bus_RDATA;
        5'b00010 : axi_weight_brodcaster[2] <= m_axi_weight_memory_bus_RDATA;
        5'b00011 : axi_weight_brodcaster[3] <= m_axi_weight_memory_bus_RDATA;
        5'b00100 : axi_weight_brodcaster[4] <= m_axi_weight_memory_bus_RDATA;
        5'b00101 : axi_weight_brodcaster[5] <= m_axi_weight_memory_bus_RDATA;
        5'b00110 : axi_weight_brodcaster[6] <= m_axi_weight_memory_bus_RDATA;
        5'b00111 : axi_weight_brodcaster[7] <= m_axi_weight_memory_bus_RDATA;
        5'b01000 : axi_weight_brodcaster[8] <= m_axi_weight_memory_bus_RDATA;
        5'b01001 : axi_weight_brodcaster[9] <= m_axi_weight_memory_bus_RDATA;
        5'b01010 : axi_weight_brodcaster[10] <= m_axi_weight_memory_bus_RDATA;
        5'b01011 : axi_weight_brodcaster[11] <= m_axi_weight_memory_bus_RDATA;
        5'b01100 : axi_weight_brodcaster[12] <= m_axi_weight_memory_bus_RDATA;
        5'b01101 : axi_weight_brodcaster[13] <= m_axi_weight_memory_bus_RDATA;
        5'b01110 : axi_weight_brodcaster[14] <= m_axi_weight_memory_bus_RDATA;
        5'b01111 : axi_weight_brodcaster[15] <= m_axi_weight_memory_bus_RDATA;
        5'b10000 : axi_weight_brodcaster[16] <= m_axi_weight_memory_bus_RDATA;
        5'b10001 : axi_weight_brodcaster[17] <= m_axi_weight_memory_bus_RDATA;
        5'b10010 : axi_weight_brodcaster[18] <= m_axi_weight_memory_bus_RDATA;
        5'b10011 : axi_weight_brodcaster[19] <= m_axi_weight_memory_bus_RDATA;
        5'b10100 : axi_weight_brodcaster[20] <= m_axi_weight_memory_bus_RDATA;
        5'b10101 : axi_weight_brodcaster[21] <= m_axi_weight_memory_bus_RDATA;
        5'b10110 : axi_weight_brodcaster[22] <= m_axi_weight_memory_bus_RDATA;
        5'b10111 : axi_weight_brodcaster[23] <= m_axi_weight_memory_bus_RDATA;
        5'b11000 : axi_weight_brodcaster[24] <= m_axi_weight_memory_bus_RDATA;
        5'b11001 : axi_weight_brodcaster[25] <= m_axi_weight_memory_bus_RDATA;
        5'b11010 : axi_weight_brodcaster[26] <= m_axi_weight_memory_bus_RDATA;
        5'b11011 : axi_weight_brodcaster[27] <= m_axi_weight_memory_bus_RDATA;
        5'b11100 : axi_weight_brodcaster[28] <= m_axi_weight_memory_bus_RDATA;
        5'b11101 : axi_weight_brodcaster[29] <= m_axi_weight_memory_bus_RDATA;
        5'b11110 : axi_weight_brodcaster[30] <= m_axi_weight_memory_bus_RDATA;
        5'b11111 : axi_weight_brodcaster[31] <= m_axi_weight_memory_bus_RDATA;
      endcase
    end
  end

  assign {o_load_weight_data_0_a, o_load_weight_data_0_b, o_load_weight_data_0_c, o_load_weight_data_0_d} = axi_weight_brodcaster[0];
  assign {o_load_weight_data_1_a, o_load_weight_data_1_b, o_load_weight_data_1_c, o_load_weight_data_1_d} = axi_weight_brodcaster[1];
  assign {o_load_weight_data_2_a, o_load_weight_data_2_b, o_load_weight_data_2_c, o_load_weight_data_2_d} = axi_weight_brodcaster[2];
  assign {o_load_weight_data_3_a, o_load_weight_data_3_b, o_load_weight_data_3_c, o_load_weight_data_3_d} = axi_weight_brodcaster[3];
  assign {o_load_weight_data_4_a, o_load_weight_data_4_b, o_load_weight_data_4_c, o_load_weight_data_4_d} = axi_weight_brodcaster[4];
  assign {o_load_weight_data_5_a, o_load_weight_data_5_b, o_load_weight_data_5_c, o_load_weight_data_5_d} = axi_weight_brodcaster[5];
  assign {o_load_weight_data_6_a, o_load_weight_data_6_b, o_load_weight_data_6_c, o_load_weight_data_6_d} = axi_weight_brodcaster[6];
  assign {o_load_weight_data_7_a, o_load_weight_data_7_b, o_load_weight_data_7_c, o_load_weight_data_7_d} = axi_weight_brodcaster[7];
  assign {o_load_weight_data_8_a, o_load_weight_data_8_b, o_load_weight_data_8_c, o_load_weight_data_8_d} = axi_weight_brodcaster[8];
  assign {o_load_weight_data_9_a, o_load_weight_data_9_b, o_load_weight_data_9_c, o_load_weight_data_9_d} = axi_weight_brodcaster[9];
  assign {o_load_weight_data_10_a, o_load_weight_data_10_b, o_load_weight_data_10_c, o_load_weight_data_10_d} = axi_weight_brodcaster[10];
  assign {o_load_weight_data_11_a, o_load_weight_data_11_b, o_load_weight_data_11_c, o_load_weight_data_11_d} = axi_weight_brodcaster[11];
  assign {o_load_weight_data_12_a, o_load_weight_data_12_b, o_load_weight_data_12_c, o_load_weight_data_12_d} = axi_weight_brodcaster[12];
  assign {o_load_weight_data_13_a, o_load_weight_data_13_b, o_load_weight_data_13_c, o_load_weight_data_13_d} = axi_weight_brodcaster[13];
  assign {o_load_weight_data_14_a, o_load_weight_data_14_b, o_load_weight_data_14_c, o_load_weight_data_14_d} = axi_weight_brodcaster[14];
  assign {o_load_weight_data_15_a, o_load_weight_data_15_b, o_load_weight_data_15_c, o_load_weight_data_15_d} = axi_weight_brodcaster[15];
  assign {o_load_weight_data_16_a, o_load_weight_data_16_b, o_load_weight_data_16_c, o_load_weight_data_16_d} = axi_weight_brodcaster[16];
  assign {o_load_weight_data_17_a, o_load_weight_data_17_b, o_load_weight_data_17_c, o_load_weight_data_17_d} = axi_weight_brodcaster[17];
  assign {o_load_weight_data_18_a, o_load_weight_data_18_b, o_load_weight_data_18_c, o_load_weight_data_18_d} = axi_weight_brodcaster[18];
  assign {o_load_weight_data_19_a, o_load_weight_data_19_b, o_load_weight_data_19_c, o_load_weight_data_19_d} = axi_weight_brodcaster[19];
  assign {o_load_weight_data_20_a, o_load_weight_data_20_b, o_load_weight_data_20_c, o_load_weight_data_20_d} = axi_weight_brodcaster[20];
  assign {o_load_weight_data_21_a, o_load_weight_data_21_b, o_load_weight_data_21_c, o_load_weight_data_21_d} = axi_weight_brodcaster[21];
  assign {o_load_weight_data_22_a, o_load_weight_data_22_b, o_load_weight_data_22_c, o_load_weight_data_22_d} = axi_weight_brodcaster[22];
  assign {o_load_weight_data_23_a, o_load_weight_data_23_b, o_load_weight_data_23_c, o_load_weight_data_23_d} = axi_weight_brodcaster[23];
  assign {o_load_weight_data_24_a, o_load_weight_data_24_b, o_load_weight_data_24_c, o_load_weight_data_24_d} = axi_weight_brodcaster[24];
  assign {o_load_weight_data_25_a, o_load_weight_data_25_b, o_load_weight_data_25_c, o_load_weight_data_25_d} = axi_weight_brodcaster[25];
  assign {o_load_weight_data_26_a, o_load_weight_data_26_b, o_load_weight_data_26_c, o_load_weight_data_26_d} = axi_weight_brodcaster[26];
  assign {o_load_weight_data_27_a, o_load_weight_data_27_b, o_load_weight_data_27_c, o_load_weight_data_27_d} = axi_weight_brodcaster[27];
  assign {o_load_weight_data_28_a, o_load_weight_data_28_b, o_load_weight_data_28_c, o_load_weight_data_28_d} = axi_weight_brodcaster[28];
  assign {o_load_weight_data_29_a, o_load_weight_data_29_b, o_load_weight_data_29_c, o_load_weight_data_29_d} = axi_weight_brodcaster[29];
  assign {o_load_weight_data_30_a, o_load_weight_data_30_b, o_load_weight_data_30_c, o_load_weight_data_30_d} = axi_weight_brodcaster[30];
  assign {o_load_weight_data_31_a, o_load_weight_data_31_b, o_load_weight_data_31_c, o_load_weight_data_31_d} = axi_weight_brodcaster[31];

endmodule
