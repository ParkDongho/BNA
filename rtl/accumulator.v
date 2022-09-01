`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/20 21:07:14
// Design Name: 
// Module Name: accumulator
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


module accumulator
#(
  ACCUM_DATA_WIDTH = 32,
  ACCUM_ADDR_WIDTH = 8,
  BIAS_ROM_ADDR = 8
)
(
  input wire clk, rst_n,
  input wire rd_en_i, wr_en_i, bias_mode_i,
  input wire i_bias_data_fifo_wr_en,
  input wire [ACCUM_ADDR_WIDTH-1:0] accum_addr_i,

  input wire i_prepare_weight, i_set_bias,
  
  input wire [ACCUM_DATA_WIDTH-1:0] accum_0_i,  accum_1_i,  accum_2_i,  accum_3_i,
  input wire [ACCUM_DATA_WIDTH-1:0] accum_4_i,  accum_5_i,  accum_6_i,  accum_7_i,
  input wire [ACCUM_DATA_WIDTH-1:0] accum_8_i,  accum_9_i,  accum_10_i, accum_11_i,
  input wire [ACCUM_DATA_WIDTH-1:0] accum_12_i, accum_13_i, accum_14_i, accum_15_i,
  input wire [ACCUM_DATA_WIDTH-1:0] accum_16_i, accum_17_i, accum_18_i, accum_19_i,
  input wire [ACCUM_DATA_WIDTH-1:0] accum_20_i, accum_21_i, accum_22_i, accum_23_i,
  input wire [ACCUM_DATA_WIDTH-1:0] accum_24_i, accum_25_i, accum_26_i, accum_27_i,
  input wire [ACCUM_DATA_WIDTH-1:0] accum_28_i, accum_29_i, accum_30_i, accum_31_i,

  output wire [ACCUM_DATA_WIDTH-1:0] accum_0_o,  accum_1_o,  accum_2_o,  accum_3_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_4_o,  accum_5_o,  accum_6_o,  accum_7_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_8_o,  accum_9_o,  accum_10_o, accum_11_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_12_o, accum_13_o, accum_14_o, accum_15_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_16_o, accum_17_o, accum_18_o, accum_19_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_20_o, accum_21_o, accum_22_o, accum_23_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_24_o, accum_25_o, accum_26_o, accum_27_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_28_o, accum_29_o, accum_30_o, accum_31_o,

  input wire  i_execute_out_fifo_wr_en, //final data
  input wire  i_execute_out_fifo_rd_en,
  output wire o_execute_out_fifo_empty,
  output wire o_execute_out_fifo_full,

  //Load Weight In/////////////////////////////////////////////////////////////////
  input   wire [7:0]                 i_load_weight_data_0_a,
  input   wire [7:0]                 i_load_weight_data_0_b,
  input   wire [7:0]                 i_load_weight_data_0_c,
  input   wire [7:0]                 i_load_weight_data_0_d,

  input   wire [7:0]                 i_load_weight_data_1_a,
  input   wire [7:0]                 i_load_weight_data_1_b,
  input   wire [7:0]                 i_load_weight_data_1_c,
  input   wire [7:0]                 i_load_weight_data_1_d,

  input   wire [7:0]                 i_load_weight_data_2_a,
  input   wire [7:0]                 i_load_weight_data_2_b,
  input   wire [7:0]                 i_load_weight_data_2_c,
  input   wire [7:0]                 i_load_weight_data_2_d,

  input   wire [7:0]                 i_load_weight_data_3_a,
  input   wire [7:0]                 i_load_weight_data_3_b,
  input   wire [7:0]                 i_load_weight_data_3_c,
  input   wire [7:0]                 i_load_weight_data_3_d,

  input   wire [7:0]                 i_load_weight_data_4_a,
  input   wire [7:0]                 i_load_weight_data_4_b,
  input   wire [7:0]                 i_load_weight_data_4_c,
  input   wire [7:0]                 i_load_weight_data_4_d,

  input   wire [7:0]                 i_load_weight_data_5_a,
  input   wire [7:0]                 i_load_weight_data_5_b,
  input   wire [7:0]                 i_load_weight_data_5_c,
  input   wire [7:0]                 i_load_weight_data_5_d,

  input   wire [7:0]                 i_load_weight_data_6_a,
  input   wire [7:0]                 i_load_weight_data_6_b,
  input   wire [7:0]                 i_load_weight_data_6_c,
  input   wire [7:0]                 i_load_weight_data_6_d,

  input   wire [7:0]                 i_load_weight_data_7_a,
  input   wire [7:0]                 i_load_weight_data_7_b,
  input   wire [7:0]                 i_load_weight_data_7_c,
  input   wire [7:0]                 i_load_weight_data_7_d,

  input   wire [7:0]                 i_load_weight_data_8_a,
  input   wire [7:0]                 i_load_weight_data_8_b,
  input   wire [7:0]                 i_load_weight_data_8_c,
  input   wire [7:0]                 i_load_weight_data_8_d,

  input   wire [7:0]                 i_load_weight_data_9_a,
  input   wire [7:0]                 i_load_weight_data_9_b,
  input   wire [7:0]                 i_load_weight_data_9_c,
  input   wire [7:0]                 i_load_weight_data_9_d,

  input   wire [7:0]                 i_load_weight_data_10_a,
  input   wire [7:0]                 i_load_weight_data_10_b,
  input   wire [7:0]                 i_load_weight_data_10_c,
  input   wire [7:0]                 i_load_weight_data_10_d,

  input   wire [7:0]                 i_load_weight_data_11_a,
  input   wire [7:0]                 i_load_weight_data_11_b,
  input   wire [7:0]                 i_load_weight_data_11_c,
  input   wire [7:0]                 i_load_weight_data_11_d,

  input   wire [7:0]                 i_load_weight_data_12_a,
  input   wire [7:0]                 i_load_weight_data_12_b,
  input   wire [7:0]                 i_load_weight_data_12_c,
  input   wire [7:0]                 i_load_weight_data_12_d,

  input   wire [7:0]                 i_load_weight_data_13_a,
  input   wire [7:0]                 i_load_weight_data_13_b,
  input   wire [7:0]                 i_load_weight_data_13_c,
  input   wire [7:0]                 i_load_weight_data_13_d,

  input   wire [7:0]                 i_load_weight_data_14_a,
  input   wire [7:0]                 i_load_weight_data_14_b,
  input   wire [7:0]                 i_load_weight_data_14_c,
  input   wire [7:0]                 i_load_weight_data_14_d,

  input   wire [7:0]                 i_load_weight_data_15_a,
  input   wire [7:0]                 i_load_weight_data_15_b,
  input   wire [7:0]                 i_load_weight_data_15_c,
  input   wire [7:0]                 i_load_weight_data_15_d,

  input   wire [7:0]                 i_load_weight_data_16_a,
  input   wire [7:0]                 i_load_weight_data_16_b,
  input   wire [7:0]                 i_load_weight_data_16_c,
  input   wire [7:0]                 i_load_weight_data_16_d,

  input   wire [7:0]                 i_load_weight_data_17_a,
  input   wire [7:0]                 i_load_weight_data_17_b,
  input   wire [7:0]                 i_load_weight_data_17_c,
  input   wire [7:0]                 i_load_weight_data_17_d,

  input   wire [7:0]                 i_load_weight_data_18_a,
  input   wire [7:0]                 i_load_weight_data_18_b,
  input   wire [7:0]                 i_load_weight_data_18_c,
  input   wire [7:0]                 i_load_weight_data_18_d,

  input   wire [7:0]                 i_load_weight_data_19_a,
  input   wire [7:0]                 i_load_weight_data_19_b,
  input   wire [7:0]                 i_load_weight_data_19_c,
  input   wire [7:0]                 i_load_weight_data_19_d,

  input   wire [7:0]                 i_load_weight_data_20_a,
  input   wire [7:0]                 i_load_weight_data_20_b,
  input   wire [7:0]                 i_load_weight_data_20_c,
  input   wire [7:0]                 i_load_weight_data_20_d,

  input   wire [7:0]                 i_load_weight_data_21_a,
  input   wire [7:0]                 i_load_weight_data_21_b,
  input   wire [7:0]                 i_load_weight_data_21_c,
  input   wire [7:0]                 i_load_weight_data_21_d,

  input   wire [7:0]                 i_load_weight_data_22_a,
  input   wire [7:0]                 i_load_weight_data_22_b,
  input   wire [7:0]                 i_load_weight_data_22_c,
  input   wire [7:0]                 i_load_weight_data_22_d,

  input   wire [7:0]                 i_load_weight_data_23_a,
  input   wire [7:0]                 i_load_weight_data_23_b,
  input   wire [7:0]                 i_load_weight_data_23_c,
  input   wire [7:0]                 i_load_weight_data_23_d,

  input   wire [7:0]                 i_load_weight_data_24_a,
  input   wire [7:0]                 i_load_weight_data_24_b,
  input   wire [7:0]                 i_load_weight_data_24_c,
  input   wire [7:0]                 i_load_weight_data_24_d,

  input   wire [7:0]                 i_load_weight_data_25_a,
  input   wire [7:0]                 i_load_weight_data_25_b,
  input   wire [7:0]                 i_load_weight_data_25_c,
  input   wire [7:0]                 i_load_weight_data_25_d,

  input   wire [7:0]                 i_load_weight_data_26_a,
  input   wire [7:0]                 i_load_weight_data_26_b,
  input   wire [7:0]                 i_load_weight_data_26_c,
  input   wire [7:0]                 i_load_weight_data_26_d,

  input   wire [7:0]                 i_load_weight_data_27_a,
  input   wire [7:0]                 i_load_weight_data_27_b,
  input   wire [7:0]                 i_load_weight_data_27_c,
  input   wire [7:0]                 i_load_weight_data_27_d,

  input   wire [7:0]                 i_load_weight_data_28_a,
  input   wire [7:0]                 i_load_weight_data_28_b,
  input   wire [7:0]                 i_load_weight_data_28_c,
  input   wire [7:0]                 i_load_weight_data_28_d,

  input   wire [7:0]                 i_load_weight_data_29_a,
  input   wire [7:0]                 i_load_weight_data_29_b,
  input   wire [7:0]                 i_load_weight_data_29_c,
  input   wire [7:0]                 i_load_weight_data_29_d,

  input   wire [7:0]                 i_load_weight_data_30_a,
  input   wire [7:0]                 i_load_weight_data_30_b,
  input   wire [7:0]                 i_load_weight_data_30_c,
  input   wire [7:0]                 i_load_weight_data_30_d,

  input   wire [7:0]                 i_load_weight_data_31_a,
  input   wire [7:0]                 i_load_weight_data_31_b,
  input   wire [7:0]                 i_load_weight_data_31_c,
  input   wire [7:0]                 i_load_weight_data_31_d,

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

  wire rd_en_0_o, rd_en_1_o, rd_en_2_o, rd_en_3_o;
  wire rd_en_4_o, rd_en_5_o, rd_en_6_o, rd_en_7_o;
  wire rd_en_8_o, rd_en_9_o, rd_en_10_o, rd_en_11_o; 
  wire rd_en_12_o, rd_en_13_o, rd_en_14_o, rd_en_15_o;

  wire accum_wr_en;
  wire wr_en_0_o, wr_en_1_o, wr_en_2_o, wr_en_3_o;
  wire wr_en_4_o, wr_en_5_o, wr_en_6_o, wr_en_7_o;
  wire wr_en_8_o, wr_en_9_o, wr_en_10_o, wr_en_11_o; 
  wire wr_en_12_o, wr_en_13_o, wr_en_14_o, wr_en_15_o;
  
  wire bias_mode_0_o,  bias_mode_1_o,  bias_mode_2_o,  bias_mode_3_o;
  wire bias_mode_4_o,  bias_mode_5_o,  bias_mode_6_o,  bias_mode_7_o;
  wire bias_mode_8_o,  bias_mode_9_o,  bias_mode_10_o, bias_mode_11_o;
  wire bias_mode_12_o, bias_mode_13_o, bias_mode_14_o, bias_mode_15_o;

  wire [ACCUM_ADDR_WIDTH-1:0] rd_addr_0_o,  rd_addr_1_o,  rd_addr_2_o,  rd_addr_3_o;
  wire [ACCUM_ADDR_WIDTH-1:0] rd_addr_4_o,  rd_addr_5_o,  rd_addr_6_o,  rd_addr_7_o;
  wire [ACCUM_ADDR_WIDTH-1:0] rd_addr_8_o,  rd_addr_9_o,  rd_addr_10_o, rd_addr_11_o;
  wire [ACCUM_ADDR_WIDTH-1:0] rd_addr_12_o, rd_addr_13_o, rd_addr_14_o, rd_addr_15_o;

  wire execute_out_fifo_wr_en;
  wire execute_out_fifo_wr_en_0, execute_out_fifo_wr_en_1, execute_out_fifo_wr_en_2, execute_out_fifo_wr_en_3;
  wire execute_out_fifo_wr_en_4, execute_out_fifo_wr_en_5, execute_out_fifo_wr_en_6, execute_out_fifo_wr_en_7;
  wire execute_out_fifo_wr_en_8, execute_out_fifo_wr_en_9, execute_out_fifo_wr_en_10, execute_out_fifo_wr_en_11;
  wire execute_out_fifo_wr_en_12, execute_out_fifo_wr_en_13, execute_out_fifo_wr_en_14; 

  wire set_bias_0,  set_bias_1,  set_bias_2,  set_bias_3;
  wire set_bias_4,  set_bias_5,  set_bias_6,  set_bias_7;
  wire set_bias_8,  set_bias_9,  set_bias_10, set_bias_11;
  wire set_bias_12, set_bias_13, set_bias_14, set_bias_15;

  wire execute_out_fifo_empty_0,  execute_out_fifo_empty_1,  execute_out_fifo_empty_2,  execute_out_fifo_empty_3;
  wire execute_out_fifo_empty_4,  execute_out_fifo_empty_5,  execute_out_fifo_empty_6,  execute_out_fifo_empty_7;
  wire execute_out_fifo_empty_8,  execute_out_fifo_empty_9,  execute_out_fifo_empty_10, execute_out_fifo_empty_11;
  wire execute_out_fifo_empty_12, execute_out_fifo_empty_13, execute_out_fifo_empty_14, execute_out_fifo_empty_15;

  wire execute_out_fifo_full_0,  execute_out_fifo_full_1,  execute_out_fifo_full_2,  execute_out_fifo_full_3;
  wire execute_out_fifo_full_4,  execute_out_fifo_full_5,  execute_out_fifo_full_6,  execute_out_fifo_full_7;
  wire execute_out_fifo_full_8,  execute_out_fifo_full_9,  execute_out_fifo_full_10, execute_out_fifo_full_11;
  wire execute_out_fifo_full_12, execute_out_fifo_full_13, execute_out_fifo_full_14, execute_out_fifo_full_15;
  
  variable_length_shift_register
  #(
    .DATA_WIDTH(2),
    .DELAY(7) 
  ) accum_wr_delay
  (
    .clk(clk),
    .rst_n(rst_n),
    .i_data({wr_en_i, i_execute_out_fifo_wr_en}),
    .o_data({accum_wr_en, execute_out_fifo_wr_en})
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_0
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n), 
    .rd_en_i(rd_en_i), 
    .wr_en_i(accum_wr_en),
    .bias_mode_i(bias_mode_i),
    .data_in_0(accum_0_i), 
    .data_in_1(accum_1_i),
    .rd_addr_i(accum_addr_i), 
    .rd_en_o(rd_en_0_o), .wr_en_o(wr_en_0_o),
    .bias_mode_o(bias_mode_0_o),
    .o_accum_data_0(accum_0_o), 
    .o_accum_data_1(accum_1_o),
    .rd_addr_o(rd_addr_0_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_0),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_0),
    .o_execute_out_fifo_full(execute_out_fifo_full_0),

    .i_load_weight_data_a_0(i_load_weight_data_0_a),
    .i_load_weight_data_b_0(i_load_weight_data_0_b),
    .i_load_weight_data_c_0(i_load_weight_data_0_c),
    .i_load_weight_data_d_0(i_load_weight_data_0_d),

    .i_load_weight_data_a_1(i_load_weight_data_1_a),
    .i_load_weight_data_b_1(i_load_weight_data_1_b),
    .i_load_weight_data_c_1(i_load_weight_data_1_c),
    .i_load_weight_data_d_1(i_load_weight_data_1_d),

    .o_load_weight_data_a_0(o_load_weight_data_0_a),
    .o_load_weight_data_b_0(o_load_weight_data_0_b),
    .o_load_weight_data_c_0(o_load_weight_data_0_c),
    .o_load_weight_data_d_0(o_load_weight_data_0_d),

    .o_load_weight_data_a_1(o_load_weight_data_1_a),
    .o_load_weight_data_b_1(o_load_weight_data_1_b),
    .o_load_weight_data_c_1(o_load_weight_data_1_c),
    .o_load_weight_data_d_1(o_load_weight_data_1_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_1
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_0_o), .wr_en_i(wr_en_0_o),
    .bias_mode_i(bias_mode_0_o),
    .data_in_0(accum_2_i), 
    .data_in_1(accum_3_i),
    .rd_addr_i(rd_addr_0_o), 
    .rd_en_o(rd_en_1_o), .wr_en_o(wr_en_1_o),
    .bias_mode_o(bias_mode_1_o),
    .o_accum_data_0(accum_2_o), 
    .o_accum_data_1(accum_3_o),
    .rd_addr_o(rd_addr_1_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_0),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_1),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_1),
    .o_execute_out_fifo_full(execute_out_fifo_full_1),

    .i_load_weight_data_a_0(i_load_weight_data_2_a),
    .i_load_weight_data_b_0(i_load_weight_data_2_b),
    .i_load_weight_data_c_0(i_load_weight_data_2_c),
    .i_load_weight_data_d_0(i_load_weight_data_2_d),

    .i_load_weight_data_a_1(i_load_weight_data_3_a),
    .i_load_weight_data_b_1(i_load_weight_data_3_b),
    .i_load_weight_data_c_1(i_load_weight_data_3_c),
    .i_load_weight_data_d_1(i_load_weight_data_3_d),

    .o_load_weight_data_a_0(o_load_weight_data_2_a),
    .o_load_weight_data_b_0(o_load_weight_data_2_b),
    .o_load_weight_data_c_0(o_load_weight_data_2_c),
    .o_load_weight_data_d_0(o_load_weight_data_2_d),

    .o_load_weight_data_a_1(o_load_weight_data_3_a),
    .o_load_weight_data_b_1(o_load_weight_data_3_b),
    .o_load_weight_data_c_1(o_load_weight_data_3_c),
    .o_load_weight_data_d_1(o_load_weight_data_3_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_2
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_1_o), .wr_en_i(wr_en_1_o),
    .bias_mode_i(bias_mode_1_o),
    .data_in_0(accum_4_i), 
    .data_in_1(accum_5_i),
    .rd_addr_i(rd_addr_1_o), 
    .rd_en_o(rd_en_2_o), .wr_en_o(wr_en_2_o),
    .bias_mode_o(bias_mode_2_o),
    .o_accum_data_0(accum_4_o), 
    .o_accum_data_1(accum_5_o),
    .rd_addr_o(rd_addr_2_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_1),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_2),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_2),
    .o_execute_out_fifo_full(execute_out_fifo_full_2),

    .i_load_weight_data_a_0(i_load_weight_data_4_a),
    .i_load_weight_data_b_0(i_load_weight_data_4_b),
    .i_load_weight_data_c_0(i_load_weight_data_4_c),
    .i_load_weight_data_d_0(i_load_weight_data_4_d),

    .i_load_weight_data_a_1(i_load_weight_data_5_a),
    .i_load_weight_data_b_1(i_load_weight_data_5_b),
    .i_load_weight_data_c_1(i_load_weight_data_5_c),
    .i_load_weight_data_d_1(i_load_weight_data_5_d),

    .o_load_weight_data_a_0(o_load_weight_data_4_a),
    .o_load_weight_data_b_0(o_load_weight_data_4_b),
    .o_load_weight_data_c_0(o_load_weight_data_4_c),
    .o_load_weight_data_d_0(o_load_weight_data_4_d),

    .o_load_weight_data_a_1(o_load_weight_data_5_a),
    .o_load_weight_data_b_1(o_load_weight_data_5_b),
    .o_load_weight_data_c_1(o_load_weight_data_5_c),
    .o_load_weight_data_d_1(o_load_weight_data_5_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_3
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_2_o), .wr_en_i(wr_en_2_o),
    .bias_mode_i(bias_mode_2_o),
    .data_in_0(accum_6_i), 
    .data_in_1(accum_7_i),
    .rd_addr_i(rd_addr_2_o), 
    .rd_en_o(rd_en_3_o), .wr_en_o(wr_en_3_o),
    .bias_mode_o(bias_mode_3_o),
    .o_accum_data_0(accum_6_o), 
    .o_accum_data_1(accum_7_o),
    .rd_addr_o(rd_addr_3_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_2),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_3),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_3),
    .o_execute_out_fifo_full(execute_out_fifo_full_3),

    .i_load_weight_data_a_0(i_load_weight_data_6_a),
    .i_load_weight_data_b_0(i_load_weight_data_6_b),
    .i_load_weight_data_c_0(i_load_weight_data_6_c),
    .i_load_weight_data_d_0(i_load_weight_data_6_d),

    .i_load_weight_data_a_1(i_load_weight_data_7_a),
    .i_load_weight_data_b_1(i_load_weight_data_7_b),
    .i_load_weight_data_c_1(i_load_weight_data_7_c),
    .i_load_weight_data_d_1(i_load_weight_data_7_d),

    .o_load_weight_data_a_0(o_load_weight_data_6_a),
    .o_load_weight_data_b_0(o_load_weight_data_6_b),
    .o_load_weight_data_c_0(o_load_weight_data_6_c),
    .o_load_weight_data_d_0(o_load_weight_data_6_d),

    .o_load_weight_data_a_1(o_load_weight_data_7_a),
    .o_load_weight_data_b_1(o_load_weight_data_7_b),
    .o_load_weight_data_c_1(o_load_weight_data_7_c),
    .o_load_weight_data_d_1(o_load_weight_data_7_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_4
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_3_o), .wr_en_i(wr_en_3_o),
    .bias_mode_i(bias_mode_3_o),
    .data_in_0(accum_8_i), 
    .data_in_1(accum_9_i),
    .rd_addr_i(rd_addr_3_o), 
    .rd_en_o(rd_en_4_o), .wr_en_o(wr_en_4_o),
    .bias_mode_o(bias_mode_4_o),
    .o_accum_data_0(accum_8_o), 
    .o_accum_data_1(accum_9_o),
    .rd_addr_o(rd_addr_4_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_3),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_4),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_4),
    .o_execute_out_fifo_full(execute_out_fifo_full_4),

    .i_load_weight_data_a_0(i_load_weight_data_8_a),
    .i_load_weight_data_b_0(i_load_weight_data_8_b),
    .i_load_weight_data_c_0(i_load_weight_data_8_c),
    .i_load_weight_data_d_0(i_load_weight_data_8_d),

    .i_load_weight_data_a_1(i_load_weight_data_9_a),
    .i_load_weight_data_b_1(i_load_weight_data_9_b),
    .i_load_weight_data_c_1(i_load_weight_data_9_c),
    .i_load_weight_data_d_1(i_load_weight_data_9_d),

    .o_load_weight_data_a_0(o_load_weight_data_8_a),
    .o_load_weight_data_b_0(o_load_weight_data_8_b),
    .o_load_weight_data_c_0(o_load_weight_data_8_c),
    .o_load_weight_data_d_0(o_load_weight_data_8_d),

    .o_load_weight_data_a_1(o_load_weight_data_9_a),
    .o_load_weight_data_b_1(o_load_weight_data_9_b),
    .o_load_weight_data_c_1(o_load_weight_data_9_c),
    .o_load_weight_data_d_1(o_load_weight_data_9_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_5
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_4_o), .wr_en_i(wr_en_4_o),
    .bias_mode_i(bias_mode_4_o),
    .data_in_0(accum_10_i), 
    .data_in_1(accum_11_i),
    .rd_addr_i(rd_addr_4_o), 
    .rd_en_o(rd_en_5_o), .wr_en_o(wr_en_5_o),
    .bias_mode_o(bias_mode_5_o),
    .o_accum_data_0(accum_10_o), 
    .o_accum_data_1(accum_11_o),
    .rd_addr_o(rd_addr_5_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_4),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_5),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_5),
    .o_execute_out_fifo_full(execute_out_fifo_full_5),

    .i_load_weight_data_a_0(i_load_weight_data_10_a),
    .i_load_weight_data_b_0(i_load_weight_data_10_b),
    .i_load_weight_data_c_0(i_load_weight_data_10_c),
    .i_load_weight_data_d_0(i_load_weight_data_10_d),

    .i_load_weight_data_a_1(i_load_weight_data_11_a),
    .i_load_weight_data_b_1(i_load_weight_data_11_b),
    .i_load_weight_data_c_1(i_load_weight_data_11_c),
    .i_load_weight_data_d_1(i_load_weight_data_11_d),

    .o_load_weight_data_a_0(o_load_weight_data_10_a),
    .o_load_weight_data_b_0(o_load_weight_data_10_b),
    .o_load_weight_data_c_0(o_load_weight_data_10_c),
    .o_load_weight_data_d_0(o_load_weight_data_10_d),

    .o_load_weight_data_a_1(o_load_weight_data_11_a),
    .o_load_weight_data_b_1(o_load_weight_data_11_b),
    .o_load_weight_data_c_1(o_load_weight_data_11_c),
    .o_load_weight_data_d_1(o_load_weight_data_11_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_6
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_5_o), .wr_en_i(wr_en_5_o),
    .bias_mode_i(bias_mode_5_o),
    .data_in_0(accum_12_i), 
    .data_in_1(accum_13_i),
    .rd_addr_i(rd_addr_5_o), 
    .rd_en_o(rd_en_6_o), .wr_en_o(wr_en_6_o),
    .bias_mode_o(bias_mode_6_o),
    .o_accum_data_0(accum_12_o), 
    .o_accum_data_1(accum_13_o),
    .rd_addr_o(rd_addr_6_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_5),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_6),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_6),
    .o_execute_out_fifo_full(execute_out_fifo_full_6),

    .i_load_weight_data_a_0(i_load_weight_data_12_a),
    .i_load_weight_data_b_0(i_load_weight_data_12_b),
    .i_load_weight_data_c_0(i_load_weight_data_12_c),
    .i_load_weight_data_d_0(i_load_weight_data_12_d),

    .i_load_weight_data_a_1(i_load_weight_data_13_a),
    .i_load_weight_data_b_1(i_load_weight_data_13_b),
    .i_load_weight_data_c_1(i_load_weight_data_13_c),
    .i_load_weight_data_d_1(i_load_weight_data_13_d),

    .o_load_weight_data_a_0(o_load_weight_data_12_a),
    .o_load_weight_data_b_0(o_load_weight_data_12_b),
    .o_load_weight_data_c_0(o_load_weight_data_12_c),
    .o_load_weight_data_d_0(o_load_weight_data_12_d),

    .o_load_weight_data_a_1(o_load_weight_data_13_a),
    .o_load_weight_data_b_1(o_load_weight_data_13_b),
    .o_load_weight_data_c_1(o_load_weight_data_13_c),
    .o_load_weight_data_d_1(o_load_weight_data_13_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_7
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_6_o), .wr_en_i(wr_en_6_o),
    .bias_mode_i(bias_mode_6_o),
    .data_in_0(accum_14_i), 
    .data_in_1(accum_15_i),
    .rd_addr_i(rd_addr_6_o), 
    .rd_en_o(rd_en_7_o), .wr_en_o(wr_en_7_o),
    .bias_mode_o(bias_mode_7_o),
    .o_accum_data_0(accum_14_o), 
    .o_accum_data_1(accum_15_o),
    .rd_addr_o(rd_addr_7_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_6),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_7),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_7),
    .o_execute_out_fifo_full(execute_out_fifo_full_7),

    .i_load_weight_data_a_0(i_load_weight_data_14_a),
    .i_load_weight_data_b_0(i_load_weight_data_14_b),
    .i_load_weight_data_c_0(i_load_weight_data_14_c),
    .i_load_weight_data_d_0(i_load_weight_data_14_d),

    .i_load_weight_data_a_1(i_load_weight_data_15_a),
    .i_load_weight_data_b_1(i_load_weight_data_15_b),
    .i_load_weight_data_c_1(i_load_weight_data_15_c),
    .i_load_weight_data_d_1(i_load_weight_data_15_d),

    .o_load_weight_data_a_0(o_load_weight_data_14_a),
    .o_load_weight_data_b_0(o_load_weight_data_14_b),
    .o_load_weight_data_c_0(o_load_weight_data_14_c),
    .o_load_weight_data_d_0(o_load_weight_data_14_d),

    .o_load_weight_data_a_1(o_load_weight_data_15_a),
    .o_load_weight_data_b_1(o_load_weight_data_15_b),
    .o_load_weight_data_c_1(o_load_weight_data_15_c),
    .o_load_weight_data_d_1(o_load_weight_data_15_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_8
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_7_o), .wr_en_i(wr_en_7_o),
    .bias_mode_i(bias_mode_7_o),
    .data_in_0(accum_16_i), 
    .data_in_1(accum_17_i),
    .rd_addr_i(rd_addr_7_o), 
    .rd_en_o(rd_en_8_o), .wr_en_o(wr_en_8_o),
    .bias_mode_o(bias_mode_8_o),
    .o_accum_data_0(accum_16_o), 
    .o_accum_data_1(accum_17_o),
    .rd_addr_o(rd_addr_8_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_7),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_8),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_8),
    .o_execute_out_fifo_full(execute_out_fifo_full_8),

    .i_load_weight_data_a_0(i_load_weight_data_16_a),
    .i_load_weight_data_b_0(i_load_weight_data_16_b),
    .i_load_weight_data_c_0(i_load_weight_data_16_c),
    .i_load_weight_data_d_0(i_load_weight_data_16_d),

    .i_load_weight_data_a_1(i_load_weight_data_17_a),
    .i_load_weight_data_b_1(i_load_weight_data_17_b),
    .i_load_weight_data_c_1(i_load_weight_data_17_c),
    .i_load_weight_data_d_1(i_load_weight_data_17_d),

    .o_load_weight_data_a_0(o_load_weight_data_16_a),
    .o_load_weight_data_b_0(o_load_weight_data_16_b),
    .o_load_weight_data_c_0(o_load_weight_data_16_c),
    .o_load_weight_data_d_0(o_load_weight_data_16_d),

    .o_load_weight_data_a_1(o_load_weight_data_17_a),
    .o_load_weight_data_b_1(o_load_weight_data_17_b),
    .o_load_weight_data_c_1(o_load_weight_data_17_c),
    .o_load_weight_data_d_1(o_load_weight_data_17_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_9
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_8_o), .wr_en_i(wr_en_8_o),
    .bias_mode_i(bias_mode_8_o),
    .data_in_0(accum_18_i), 
    .data_in_1(accum_19_i),
    .rd_addr_i(rd_addr_8_o), 
    .rd_en_o(rd_en_9_o), .wr_en_o(wr_en_9_o),
    .bias_mode_o(bias_mode_9_o),
    .o_accum_data_0(accum_18_o), 
    .o_accum_data_1(accum_19_o),
    .rd_addr_o(rd_addr_9_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_8),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_9),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_9),
    .o_execute_out_fifo_full(execute_out_fifo_full_9),

    .i_load_weight_data_a_0(i_load_weight_data_18_a),
    .i_load_weight_data_b_0(i_load_weight_data_18_b),
    .i_load_weight_data_c_0(i_load_weight_data_18_c),
    .i_load_weight_data_d_0(i_load_weight_data_18_d),

    .i_load_weight_data_a_1(i_load_weight_data_19_a),
    .i_load_weight_data_b_1(i_load_weight_data_19_b),
    .i_load_weight_data_c_1(i_load_weight_data_19_c),
    .i_load_weight_data_d_1(i_load_weight_data_19_d),

    .o_load_weight_data_a_0(o_load_weight_data_18_a),
    .o_load_weight_data_b_0(o_load_weight_data_18_b),
    .o_load_weight_data_c_0(o_load_weight_data_18_c),
    .o_load_weight_data_d_0(o_load_weight_data_18_d),

    .o_load_weight_data_a_1(o_load_weight_data_19_a),
    .o_load_weight_data_b_1(o_load_weight_data_19_b),
    .o_load_weight_data_c_1(o_load_weight_data_19_c),
    .o_load_weight_data_d_1(o_load_weight_data_19_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_10
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_9_o), .wr_en_i(wr_en_9_o),
    .bias_mode_i(bias_mode_9_o),
    .data_in_0(accum_20_i), 
    .data_in_1(accum_21_i),
    .rd_addr_i(rd_addr_9_o), 
    .rd_en_o(rd_en_10_o), .wr_en_o(wr_en_10_o),
    .bias_mode_o(bias_mode_10_o),
    .o_accum_data_0(accum_20_o), 
    .o_accum_data_1(accum_21_o),
    .rd_addr_o(rd_addr_10_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_9),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_10),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_10),
    .o_execute_out_fifo_full(execute_out_fifo_full_10),

    .i_load_weight_data_a_0(i_load_weight_data_20_a),
    .i_load_weight_data_b_0(i_load_weight_data_20_b),
    .i_load_weight_data_c_0(i_load_weight_data_20_c),
    .i_load_weight_data_d_0(i_load_weight_data_20_d),

    .i_load_weight_data_a_1(i_load_weight_data_21_a),
    .i_load_weight_data_b_1(i_load_weight_data_21_b),
    .i_load_weight_data_c_1(i_load_weight_data_21_c),
    .i_load_weight_data_d_1(i_load_weight_data_21_d),

    .o_load_weight_data_a_0(o_load_weight_data_20_a),
    .o_load_weight_data_b_0(o_load_weight_data_20_b),
    .o_load_weight_data_c_0(o_load_weight_data_20_c),
    .o_load_weight_data_d_0(o_load_weight_data_20_d),

    .o_load_weight_data_a_1(o_load_weight_data_21_a),
    .o_load_weight_data_b_1(o_load_weight_data_21_b),
    .o_load_weight_data_c_1(o_load_weight_data_21_c),
    .o_load_weight_data_d_1(o_load_weight_data_21_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_11
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_10_o), .wr_en_i(wr_en_10_o),
    .bias_mode_i(bias_mode_10_o),
    .data_in_0(accum_22_i), 
    .data_in_1(accum_23_i),
    .rd_addr_i(rd_addr_10_o), 
    .rd_en_o(rd_en_11_o), .wr_en_o(wr_en_11_o),
    .bias_mode_o(bias_mode_11_o),
    .o_accum_data_0(accum_22_o), 
    .o_accum_data_1(accum_23_o),
    .rd_addr_o(rd_addr_11_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_10),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_11),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_11),
    .o_execute_out_fifo_full(execute_out_fifo_full_11),

    .i_load_weight_data_a_0(i_load_weight_data_22_a),
    .i_load_weight_data_b_0(i_load_weight_data_22_b),
    .i_load_weight_data_c_0(i_load_weight_data_22_c),
    .i_load_weight_data_d_0(i_load_weight_data_22_d),

    .i_load_weight_data_a_1(i_load_weight_data_23_a),
    .i_load_weight_data_b_1(i_load_weight_data_23_b),
    .i_load_weight_data_c_1(i_load_weight_data_23_c),
    .i_load_weight_data_d_1(i_load_weight_data_23_d),

    .o_load_weight_data_a_0(o_load_weight_data_22_a),
    .o_load_weight_data_b_0(o_load_weight_data_22_b),
    .o_load_weight_data_c_0(o_load_weight_data_22_c),
    .o_load_weight_data_d_0(o_load_weight_data_22_d),

    .o_load_weight_data_a_1(o_load_weight_data_23_a),
    .o_load_weight_data_b_1(o_load_weight_data_23_b),
    .o_load_weight_data_c_1(o_load_weight_data_23_c),
    .o_load_weight_data_d_1(o_load_weight_data_23_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_12
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_11_o), .wr_en_i(wr_en_11_o),
    .bias_mode_i(bias_mode_11_o),
    .data_in_0(accum_24_i), 
    .data_in_1(accum_25_i),
    .rd_addr_i(rd_addr_11_o), 
    .rd_en_o(rd_en_12_o), .wr_en_o(wr_en_12_o),
    .bias_mode_o(bias_mode_12_o),
    .o_accum_data_0(accum_24_o), 
    .o_accum_data_1(accum_25_o),
    .rd_addr_o(rd_addr_12_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_11),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_12),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_12),
    .o_execute_out_fifo_full(execute_out_fifo_full_12),

    .i_load_weight_data_a_0(i_load_weight_data_24_a),
    .i_load_weight_data_b_0(i_load_weight_data_24_b),
    .i_load_weight_data_c_0(i_load_weight_data_24_c),
    .i_load_weight_data_d_0(i_load_weight_data_24_d),

    .i_load_weight_data_a_1(i_load_weight_data_25_a),
    .i_load_weight_data_b_1(i_load_weight_data_25_b),
    .i_load_weight_data_c_1(i_load_weight_data_25_c),
    .i_load_weight_data_d_1(i_load_weight_data_25_d),

    .o_load_weight_data_a_0(o_load_weight_data_24_a),
    .o_load_weight_data_b_0(o_load_weight_data_24_b),
    .o_load_weight_data_c_0(o_load_weight_data_24_c),
    .o_load_weight_data_d_0(o_load_weight_data_24_d),

    .o_load_weight_data_a_1(o_load_weight_data_25_a),
    .o_load_weight_data_b_1(o_load_weight_data_25_b),
    .o_load_weight_data_c_1(o_load_weight_data_25_c),
    .o_load_weight_data_d_1(o_load_weight_data_25_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_13
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_12_o), .wr_en_i(wr_en_12_o),
    .bias_mode_i(bias_mode_12_o),
    .data_in_0(accum_26_i), 
    .data_in_1(accum_27_i),
    .rd_addr_i(rd_addr_12_o), 
    .rd_en_o(rd_en_13_o), .wr_en_o(wr_en_13_o),
    .bias_mode_o(bias_mode_13_o),
    .o_accum_data_0(accum_26_o), 
    .o_accum_data_1(accum_27_o),
    .rd_addr_o(rd_addr_13_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_12),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_13),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_13),
    .o_execute_out_fifo_full(execute_out_fifo_full_13),

    .i_load_weight_data_a_0(i_load_weight_data_26_a),
    .i_load_weight_data_b_0(i_load_weight_data_26_b),
    .i_load_weight_data_c_0(i_load_weight_data_26_c),
    .i_load_weight_data_d_0(i_load_weight_data_26_d),

    .i_load_weight_data_a_1(i_load_weight_data_27_a),
    .i_load_weight_data_b_1(i_load_weight_data_27_b),
    .i_load_weight_data_c_1(i_load_weight_data_27_c),
    .i_load_weight_data_d_1(i_load_weight_data_27_d),

    .o_load_weight_data_a_0(o_load_weight_data_26_a),
    .o_load_weight_data_b_0(o_load_weight_data_26_b),
    .o_load_weight_data_c_0(o_load_weight_data_26_c),
    .o_load_weight_data_d_0(o_load_weight_data_26_d),

    .o_load_weight_data_a_1(o_load_weight_data_27_a),
    .o_load_weight_data_b_1(o_load_weight_data_27_b),
    .o_load_weight_data_c_1(o_load_weight_data_27_c),
    .o_load_weight_data_d_1(o_load_weight_data_27_d)
  );

  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_14
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_13_o), .wr_en_i(wr_en_13_o),
    .bias_mode_i(bias_mode_13_o),
    .data_in_0(accum_28_i), 
    .data_in_1(accum_29_i),
    .rd_addr_i(rd_addr_13_o), 
    .rd_en_o(rd_en_14_o), .wr_en_o(wr_en_14_o),
    .bias_mode_o(bias_mode_14_o),
    .o_accum_data_0(accum_28_o), 
    .o_accum_data_1(accum_29_o),
    .rd_addr_o(rd_addr_14_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_13),
    .o_execute_out_fifo_wr_en(execute_out_fifo_wr_en_14),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_14),
    .o_execute_out_fifo_full(execute_out_fifo_full_14),

    .i_load_weight_data_a_0(i_load_weight_data_28_a),
    .i_load_weight_data_b_0(i_load_weight_data_28_b),
    .i_load_weight_data_c_0(i_load_weight_data_28_c),
    .i_load_weight_data_d_0(i_load_weight_data_28_d),

    .i_load_weight_data_a_1(i_load_weight_data_29_a),
    .i_load_weight_data_b_1(i_load_weight_data_29_b),
    .i_load_weight_data_c_1(i_load_weight_data_29_c),
    .i_load_weight_data_d_1(i_load_weight_data_29_d),

    .o_load_weight_data_a_0(o_load_weight_data_28_a),
    .o_load_weight_data_b_0(o_load_weight_data_28_b),
    .o_load_weight_data_c_0(o_load_weight_data_28_c),
    .o_load_weight_data_d_0(o_load_weight_data_28_d),

    .o_load_weight_data_a_1(o_load_weight_data_29_a),
    .o_load_weight_data_b_1(o_load_weight_data_29_b),
    .o_load_weight_data_c_1(o_load_weight_data_29_c),
    .o_load_weight_data_d_1(o_load_weight_data_29_d)
  );


  accumulator_dual
  #(
    .ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator_dual_15
  (
    //input
    //control signals
    .clk(clk), .rst_n(rst_n),
    .rd_en_i(rd_en_14_o), .wr_en_i(wr_en_14_o),
    .bias_mode_i(bias_mode_14_o),
    .data_in_0(accum_30_i), 
    .data_in_1(accum_31_i),
    .rd_addr_i(rd_addr_14_o), 
    .rd_en_o(rd_en_15_o), .wr_en_o(wr_en_15_o),
    .bias_mode_o(bias_mode_15_o),
    .o_accum_data_0(accum_30_o), 
    .o_accum_data_1(accum_31_o),
    .rd_addr_o(rd_addr_15_o), 

    .i_prepare_weight(i_prepare_weight),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    .i_set_bias(i_set_bias),

    .i_execute_out_fifo_wr_en(execute_out_fifo_wr_en_14),
    .o_execute_out_fifo_wr_en(),
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(execute_out_fifo_empty_15),
    .o_execute_out_fifo_full(execute_out_fifo_full_15),

    .i_load_weight_data_a_0(i_load_weight_data_30_a),
    .i_load_weight_data_b_0(i_load_weight_data_30_b),
    .i_load_weight_data_c_0(i_load_weight_data_30_c),
    .i_load_weight_data_d_0(i_load_weight_data_30_d),

    .i_load_weight_data_a_1(i_load_weight_data_31_a),
    .i_load_weight_data_b_1(i_load_weight_data_31_b),
    .i_load_weight_data_c_1(i_load_weight_data_31_c),
    .i_load_weight_data_d_1(i_load_weight_data_31_d),

    .o_load_weight_data_a_0(o_load_weight_data_30_a),
    .o_load_weight_data_b_0(o_load_weight_data_30_b),
    .o_load_weight_data_c_0(o_load_weight_data_30_c),
    .o_load_weight_data_d_0(o_load_weight_data_30_d),

    .o_load_weight_data_a_1(o_load_weight_data_31_a),
    .o_load_weight_data_b_1(o_load_weight_data_31_b),
    .o_load_weight_data_c_1(o_load_weight_data_31_c),
    .o_load_weight_data_d_1(o_load_weight_data_31_d)
  );

assign o_execute_out_fifo_empty = execute_out_fifo_empty_0;
assign o_execute_out_fifo_full  = execute_out_fifo_full_0;
endmodule
