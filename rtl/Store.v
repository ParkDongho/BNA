`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/23 00:25:45
// Design Name: 
// Module Name: Store
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


module Store
#(
  parameter AXI_WIDTH_USER =1,              // Master ID
  parameter AXI_WIDTH_ID   =4,              // ID width in bits
  parameter AXI_WIDTH_AD   =32,             // address width
  parameter AXI_WIDTH_DA   =32,             // data width
  parameter AXI_WIDTH_DS =(AXI_WIDTH_DA/8), // data strobe width

  parameter AXI_LITE_WIDTH_AD   =32,        // axi lite address width
  parameter AXI_LITE_WIDTH_DA   =32,        // axi lite data width
  parameter AXI_LITE_WIDTH_DS =(AXI_LITE_WIDTH_DA/8), // data strobe width
  
  parameter ACCUM_DATA_WIDTH = 32,
  parameter EXPONENT_WIDTH = 8,
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  
  parameter SYST_ARRAY_WIDTH = 32,

  parameter QUNATIZED_FP_LSB = ACCUM_DATA_WIDTH-QUNATIZED_MANTISSA_WIDTH-EXPONENT_WIDTH
)
(
  input  wire clk, rst_n,
  input  wire store_data_reg_wr_en,
  input  wire [4:0] sel_store_data,

  input  wire [ACCUM_DATA_WIDTH-1:0] stor_0_i,  stor_1_i,  stor_2_i,  stor_3_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_4_i,  stor_5_i,  stor_6_i,  stor_7_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_8_i,  stor_9_i,  stor_10_i, stor_11_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_12_i, stor_13_i, stor_14_i, stor_15_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_16_i, stor_17_i, stor_18_i, stor_19_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_20_i, stor_21_i, stor_22_i, stor_23_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_24_i, stor_25_i, stor_26_i, stor_27_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] stor_28_i, stor_29_i, stor_30_i, stor_31_i,
    
  //write back
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] wb_mantissa_0_o,  wb_mantissa_1_o,  wb_mantissa_2_o,  wb_mantissa_3_o,
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] wb_mantissa_4_o,  wb_mantissa_5_o,  wb_mantissa_6_o,  wb_mantissa_7_o,
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] wb_mantissa_8_o,  wb_mantissa_9_o,  wb_mantissa_10_o, wb_mantissa_11_o,
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] wb_mantissa_12_o, wb_mantissa_13_o, wb_mantissa_14_o, wb_mantissa_15_o,
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] wb_mantissa_16_o, wb_mantissa_17_o, wb_mantissa_18_o, wb_mantissa_19_o,
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] wb_mantissa_20_o, wb_mantissa_21_o, wb_mantissa_22_o, wb_mantissa_23_o,
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] wb_mantissa_24_o, wb_mantissa_25_o, wb_mantissa_26_o, wb_mantissa_27_o,
  output wire [QUNATIZED_MANTISSA_WIDTH-1:0] wb_mantissa_28_o, wb_mantissa_29_o, wb_mantissa_30_o, wb_mantissa_31_o,
  output wire [EXPONENT_WIDTH-1:0] wb_exponent_o,

  // AXI MASTER 
  output wire [AXI_WIDTH_DA-1:0]      m_axi_memory_bus_WDATA
);

  fp_to_bfp_converter
  #(
    .SYST_ARRAY_WIDTH(SYST_ARRAY_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .EXPONENT_WIDTH(EXPONENT_WIDTH)
  ) fp_to_bfp_converter
  (
    .clk(clk),
      .bfp_converter_data_0_i(stor_0_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_1_i(stor_1_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_2_i(stor_2_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_3_i(stor_3_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_4_i(stor_4_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_5_i(stor_5_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_6_i(stor_6_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_7_i(stor_7_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_8_i(stor_8_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_9_i(stor_9_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_10_i(stor_10_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_11_i(stor_11_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_12_i(stor_12_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_13_i(stor_13_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_14_i(stor_14_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_15_i(stor_15_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_16_i(stor_16_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_17_i(stor_17_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_18_i(stor_18_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_19_i(stor_19_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_20_i(stor_20_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_21_i(stor_21_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_22_i(stor_22_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_23_i(stor_23_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_24_i(stor_24_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_25_i(stor_25_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_26_i(stor_26_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_27_i(stor_27_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_28_i(stor_28_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_29_i(stor_29_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_30_i(stor_30_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      .bfp_converter_data_31_i(stor_31_i[ACCUM_DATA_WIDTH-1:QUNATIZED_FP_LSB]),
      
      .bfp_converter_data_0_o(wb_mantissa_0_o),  .bfp_converter_data_1_o(wb_mantissa_1_o),  
      .bfp_converter_data_2_o(wb_mantissa_2_o),  .bfp_converter_data_3_o(wb_mantissa_3_o),
      .bfp_converter_data_4_o(wb_mantissa_4_o),  .bfp_converter_data_5_o(wb_mantissa_5_o),  
      .bfp_converter_data_6_o(wb_mantissa_6_o),  .bfp_converter_data_7_o(wb_mantissa_7_o),
      .bfp_converter_data_8_o(wb_mantissa_8_o),  .bfp_converter_data_9_o(wb_mantissa_9_o),  
      .bfp_converter_data_10_o(wb_mantissa_10_o), .bfp_converter_data_11_o(wb_mantissa_11_o),
      .bfp_converter_data_12_o(wb_mantissa_12_o), .bfp_converter_data_13_o(wb_mantissa_13_o), 
      .bfp_converter_data_14_o(wb_mantissa_14_o), .bfp_converter_data_15_o(wb_mantissa_15_o),
      .bfp_converter_data_16_o(wb_mantissa_16_o), .bfp_converter_data_17_o(wb_mantissa_17_o), 
      .bfp_converter_data_18_o(wb_mantissa_18_o), .bfp_converter_data_19_o(wb_mantissa_19_o),
      .bfp_converter_data_20_o(wb_mantissa_20_o), .bfp_converter_data_21_o(wb_mantissa_21_o), 
      .bfp_converter_data_22_o(wb_mantissa_22_o), .bfp_converter_data_23_o(wb_mantissa_23_o),
      .bfp_converter_data_24_o(wb_mantissa_24_o), .bfp_converter_data_25_o(wb_mantissa_25_o), 
      .bfp_converter_data_26_o(wb_mantissa_26_o), .bfp_converter_data_27_o(wb_mantissa_27_o),
      .bfp_converter_data_28_o(wb_mantissa_28_o), .bfp_converter_data_29_o(wb_mantissa_29_o), 
      .bfp_converter_data_30_o(wb_mantissa_30_o), .bfp_converter_data_31_o((wb_mantissa_31_o)),
      .bfp_converter_data_expoent_o(wb_exponent_o)
  );

m_axi_write
#(
  .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
  
  .AXI_WIDTH_USER(AXI_WIDTH_USER),              // Master ID
  .AXI_WIDTH_ID(AXI_WIDTH_ID),              // ID width in bits
  .AXI_WIDTH_AD(AXI_WIDTH_AD),             // address width
  .AXI_WIDTH_DA(AXI_WIDTH_DA),             // data width
  .AXI_WIDTH_DS(AXI_WIDTH_DS), // data strobe width
  .AXI_LITE_WIDTH_AD(AXI_LITE_WIDTH_AD),        // axi lite address width
  .AXI_LITE_WIDTH_DA(AXI_LITE_WIDTH_DA),        // axi lite data width
  .AXI_LITE_WIDTH_DS(AXI_LITE_WIDTH_DS) // data strobe width
)m_axi_write
(
  .clk(clk), 
  .store_data_reg_wr_en(store_data_reg_wr_en),
  .sel_store_data(sel_store_data),
  //Floating Point Data in
    .stor_0_i(stor_0_i),   .stor_1_i(stor_1_i),   .stor_2_i(stor_2_i),   .stor_3_i(stor_3_i),
    .stor_4_i(stor_4_i),   .stor_5_i(stor_5_i),   .stor_6_i(stor_6_i),   .stor_7_i(stor_7_i),
    .stor_8_i(stor_8_i),   .stor_9_i(stor_9_i),   .stor_10_i(stor_10_i), .stor_11_i(stor_11_i),
    .stor_12_i(stor_12_i), .stor_13_i(stor_13_i), .stor_14_i(stor_14_i), .stor_15_i(stor_15_i),
    .stor_16_i(stor_16_i), .stor_17_i(stor_17_i), .stor_18_i(stor_18_i), .stor_19_i(stor_19_i),
    .stor_20_i(stor_20_i), .stor_21_i(stor_21_i), .stor_22_i(stor_22_i), .stor_23_i(stor_23_i),
    .stor_24_i(stor_24_i), .stor_25_i(stor_25_i), .stor_26_i(stor_26_i), .stor_27_i(stor_27_i),
    .stor_28_i(stor_28_i), .stor_29_i(stor_29_i), .stor_30_i(stor_30_i), .stor_31_i(stor_31_i),
  
  // AXI MASTER 
    .m_axi_memory_bus_WDATA(m_axi_memory_bus_WDATA)
);
endmodule