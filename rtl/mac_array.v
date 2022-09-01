`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/16 22:45:57
// Design Name: 
// Module Name: mac_array
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


module mac_array
#(
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter MAC_ACC_WIDTH = 48,
  parameter BUFFER_ADDR_WIDTH = 15
) (
  input  wire clk, rst_n,

  //Write Buffer Control
  input  wire prepare_weight,
  //input  wire i_weight_data_fifo_wr_en,
  
  //Execute Control
  input  wire set_weight_i,

  //mac activation in
  input  wire [QUNATIZED_MANTISSA_WIDTH-1:0] mac_mantissa_activation_a_i, mac_mantissa_activation_b_i, mac_mantissa_activation_c_i, mac_mantissa_activation_d_i,

  //mac adder input
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_0_i, mac_acc_b_0_i, mac_acc_c_0_i, mac_acc_d_0_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_1_i, mac_acc_b_1_i, mac_acc_c_1_i, mac_acc_d_1_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_2_i, mac_acc_b_2_i, mac_acc_c_2_i, mac_acc_d_2_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_3_i, mac_acc_b_3_i, mac_acc_c_3_i, mac_acc_d_3_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_4_i, mac_acc_b_4_i, mac_acc_c_4_i, mac_acc_d_4_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_5_i, mac_acc_b_5_i, mac_acc_c_5_i, mac_acc_d_5_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_6_i, mac_acc_b_6_i, mac_acc_c_6_i, mac_acc_d_6_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_7_i, mac_acc_b_7_i, mac_acc_c_7_i, mac_acc_d_7_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_8_i, mac_acc_b_8_i, mac_acc_c_8_i, mac_acc_d_8_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_9_i, mac_acc_b_9_i, mac_acc_c_9_i, mac_acc_d_9_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_10_i, mac_acc_b_10_i, mac_acc_c_10_i, mac_acc_d_10_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_11_i, mac_acc_b_11_i, mac_acc_c_11_i, mac_acc_d_11_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_12_i, mac_acc_b_12_i, mac_acc_c_12_i, mac_acc_d_12_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_13_i, mac_acc_b_13_i, mac_acc_c_13_i, mac_acc_d_13_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_14_i, mac_acc_b_14_i, mac_acc_c_14_i, mac_acc_d_14_i,
  input  wire [MAC_ACC_WIDTH-1:0] mac_acc_a_15_i, mac_acc_b_15_i, mac_acc_c_15_i, mac_acc_d_15_i,
  //mac adder output
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_0_o, mac_acc_b_0_o, mac_acc_c_0_o, mac_acc_d_0_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_1_o, mac_acc_b_1_o, mac_acc_c_1_o, mac_acc_d_1_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_2_o, mac_acc_b_2_o, mac_acc_c_2_o, mac_acc_d_2_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_3_o, mac_acc_b_3_o, mac_acc_c_3_o, mac_acc_d_3_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_4_o, mac_acc_b_4_o, mac_acc_c_4_o, mac_acc_d_4_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_5_o, mac_acc_b_5_o, mac_acc_c_5_o, mac_acc_d_5_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_6_o, mac_acc_b_6_o, mac_acc_c_6_o, mac_acc_d_6_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_7_o, mac_acc_b_7_o, mac_acc_c_7_o, mac_acc_d_7_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_8_o, mac_acc_b_8_o, mac_acc_c_8_o, mac_acc_d_8_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_9_o, mac_acc_b_9_o, mac_acc_c_9_o, mac_acc_d_9_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_10_o, mac_acc_b_10_o, mac_acc_c_10_o, mac_acc_d_10_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_11_o, mac_acc_b_11_o, mac_acc_c_11_o, mac_acc_d_11_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_12_o, mac_acc_b_12_o, mac_acc_c_12_o, mac_acc_d_12_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_13_o, mac_acc_b_13_o, mac_acc_c_13_o, mac_acc_d_13_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_14_o, mac_acc_b_14_o, mac_acc_c_14_o, mac_acc_d_14_o,
  output wire [MAC_ACC_WIDTH-1:0] mac_acc_a_15_o, mac_acc_b_15_o, mac_acc_c_15_o, mac_acc_d_15_o,

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

  wire [QUNATIZED_MANTISSA_WIDTH-1:0] mac_mantissa_activation_a [15:0], mac_mantissa_activation_b [15:0], mac_mantissa_activation_c [15:0], mac_mantissa_activation_d [15:0];
  reg  set_weight_tmp;

  
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_0(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),

    //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),

    //data in
    //mac activation
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a_i), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b_i), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c_i), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d_i),
    
    .mac_acc_a_i(mac_acc_a_0_i), 
    .mac_acc_b_i(mac_acc_b_0_i), 
    .mac_acc_c_i(mac_acc_c_0_i), 
    .mac_acc_d_i(mac_acc_d_0_i),
  
    //output 
    
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[0]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[0]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[0]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[0]),
    
    .mac_acc_a_o(mac_acc_a_0_o), 
    .mac_acc_b_o(mac_acc_b_0_o), 
    .mac_acc_c_o(mac_acc_c_0_o), 
    .mac_acc_d_o(mac_acc_d_0_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_1(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[0]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[0]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[0]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[0]),
    
    .mac_acc_a_i(mac_acc_a_1_i), 
    .mac_acc_b_i(mac_acc_b_1_i), 
    .mac_acc_c_i(mac_acc_c_1_i), 
    .mac_acc_d_i(mac_acc_d_1_i),
  
    //output 
    
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[1]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[1]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[1]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[1]),
    
    .mac_acc_a_o(mac_acc_a_1_o), 
    .mac_acc_b_o(mac_acc_b_1_o), 
    .mac_acc_c_o(mac_acc_c_1_o), 
    .mac_acc_d_o(mac_acc_d_1_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_2(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[1]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[1]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[1]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[1]),
    
    .mac_acc_a_i(mac_acc_a_2_i), 
    .mac_acc_b_i(mac_acc_b_2_i), 
    .mac_acc_c_i(mac_acc_c_2_i), 
    .mac_acc_d_i(mac_acc_d_2_i),
  
    //output 
    
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[2]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[2]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[2]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[2]),
    
    .mac_acc_a_o(mac_acc_a_2_o), 
    .mac_acc_b_o(mac_acc_b_2_o), 
    .mac_acc_c_o(mac_acc_c_2_o), 
    .mac_acc_d_o(mac_acc_d_2_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_3(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[2]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[2]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[2]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[2]),
    
    .mac_acc_a_i(mac_acc_a_3_i), 
    .mac_acc_b_i(mac_acc_b_3_i), 
    .mac_acc_c_i(mac_acc_c_3_i), 
    .mac_acc_d_i(mac_acc_d_3_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[3]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[3]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[3]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[3]),
    
    .mac_acc_a_o(mac_acc_a_3_o), 
    .mac_acc_b_o(mac_acc_b_3_o), 
    .mac_acc_c_o(mac_acc_c_3_o), 
    .mac_acc_d_o(mac_acc_d_3_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_4(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[3]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[3]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[3]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[3]),

    .mac_acc_a_i(mac_acc_a_4_i), 
    .mac_acc_b_i(mac_acc_b_4_i), 
    .mac_acc_c_i(mac_acc_c_4_i), 
    .mac_acc_d_i(mac_acc_d_4_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[4]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[4]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[4]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[4]),
    
    .mac_acc_a_o(mac_acc_a_4_o), 
    .mac_acc_b_o(mac_acc_b_4_o), 
    .mac_acc_c_o(mac_acc_c_4_o), 
    .mac_acc_d_o(mac_acc_d_4_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_5(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
    //data in
    //mac activation     
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[4]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[4]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[4]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[4]),

    .mac_acc_a_i(mac_acc_a_5_i), 
    .mac_acc_b_i(mac_acc_b_5_i), 
    .mac_acc_c_i(mac_acc_c_5_i), 
    .mac_acc_d_i(mac_acc_d_5_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[5]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[5]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[5]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[5]),
    
    .mac_acc_a_o(mac_acc_a_5_o), 
    .mac_acc_b_o(mac_acc_b_5_o), 
    .mac_acc_c_o(mac_acc_c_5_o), 
    .mac_acc_d_o(mac_acc_d_5_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_6(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[5]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[5]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[5]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[5]),
    
    .mac_acc_a_i(mac_acc_a_6_i), 
    .mac_acc_b_i(mac_acc_b_6_i), 
    .mac_acc_c_i(mac_acc_c_6_i), 
    .mac_acc_d_i(mac_acc_d_6_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[6]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[6]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[6]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[6]),
    
    .mac_acc_a_o(mac_acc_a_6_o), 
    .mac_acc_b_o(mac_acc_b_6_o), 
    .mac_acc_c_o(mac_acc_c_6_o), 
    .mac_acc_d_o(mac_acc_d_6_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_7(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[6]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[6]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[6]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[6]),
    
    .mac_acc_a_i(mac_acc_a_7_i), 
    .mac_acc_b_i(mac_acc_b_7_i), 
    .mac_acc_c_i(mac_acc_c_7_i), 
    .mac_acc_d_i(mac_acc_d_7_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[7]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[7]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[7]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[7]),
    
    .mac_acc_a_o(mac_acc_a_7_o), 
    .mac_acc_b_o(mac_acc_b_7_o), 
    .mac_acc_c_o(mac_acc_c_7_o), 
    .mac_acc_d_o(mac_acc_d_7_o),

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

  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_8(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
    
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[7]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[7]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[7]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[7]),
    
    .mac_acc_a_i(mac_acc_a_8_i), 
    .mac_acc_b_i(mac_acc_b_8_i), 
    .mac_acc_c_i(mac_acc_c_8_i), 
    .mac_acc_d_i(mac_acc_d_8_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[8]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[8]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[8]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[8]),
    
    .mac_acc_a_o(mac_acc_a_8_o), 
    .mac_acc_b_o(mac_acc_b_8_o), 
    .mac_acc_c_o(mac_acc_c_8_o), 
    .mac_acc_d_o(mac_acc_d_8_o),

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
  
    mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_9(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[8]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[8]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[8]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[8]),
    
    .mac_acc_a_i(mac_acc_a_9_i), 
    .mac_acc_b_i(mac_acc_b_9_i), 
    .mac_acc_c_i(mac_acc_c_9_i), 
    .mac_acc_d_i(mac_acc_d_9_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[9]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[9]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[9]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[9]),
    
    .mac_acc_a_o(mac_acc_a_9_o), 
    .mac_acc_b_o(mac_acc_b_9_o), 
    .mac_acc_c_o(mac_acc_c_9_o), 
    .mac_acc_d_o(mac_acc_d_9_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_10(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[9]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[9]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[9]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[9]),
    
    .mac_acc_a_i(mac_acc_a_10_i), 
    .mac_acc_b_i(mac_acc_b_10_i), 
    .mac_acc_c_i(mac_acc_c_10_i), 
    .mac_acc_d_i(mac_acc_d_10_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[10]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[10]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[10]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[10]),
    
    .mac_acc_a_o(mac_acc_a_10_o), 
    .mac_acc_b_o(mac_acc_b_10_o), 
    .mac_acc_c_o(mac_acc_c_10_o), 
    .mac_acc_d_o(mac_acc_d_10_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_11(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[10]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[10]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[10]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[10]),
    
    .mac_acc_a_i(mac_acc_a_11_i), 
    .mac_acc_b_i(mac_acc_b_11_i), 
    .mac_acc_c_i(mac_acc_c_11_i), 
    .mac_acc_d_i(mac_acc_d_11_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[11]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[11]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[11]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[11]),
    
    .mac_acc_a_o(mac_acc_a_11_o), 
    .mac_acc_b_o(mac_acc_b_11_o), 
    .mac_acc_c_o(mac_acc_c_11_o), 
    .mac_acc_d_o(mac_acc_d_11_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_12(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[11]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[11]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[11]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[11]),
    
    .mac_acc_a_i(mac_acc_a_12_i), 
    .mac_acc_b_i(mac_acc_b_12_i), 
    .mac_acc_c_i(mac_acc_c_12_i), 
    .mac_acc_d_i(mac_acc_d_12_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[12]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[12]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[12]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[12]),
    
    .mac_acc_a_o(mac_acc_a_12_o), 
    .mac_acc_b_o(mac_acc_b_12_o), 
    .mac_acc_c_o(mac_acc_c_12_o), 
    .mac_acc_d_o(mac_acc_d_12_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_13(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[12]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[12]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[12]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[12]),
    
    .mac_acc_a_i(mac_acc_a_13_i), 
    .mac_acc_b_i(mac_acc_b_13_i), 
    .mac_acc_c_i(mac_acc_c_13_i), 
    .mac_acc_d_i(mac_acc_d_13_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[13]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[13]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[13]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[13]),
    
    .mac_acc_a_o(mac_acc_a_13_o), 
    .mac_acc_b_o(mac_acc_b_13_o), 
    .mac_acc_c_o(mac_acc_c_13_o), 
    .mac_acc_d_o(mac_acc_d_13_o),

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
  
  mac_quad
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_14(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
  
  
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[13]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[13]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[13]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[13]),
    
    .mac_acc_a_i(mac_acc_a_14_i), 
    .mac_acc_b_i(mac_acc_b_14_i), 
    .mac_acc_c_i(mac_acc_c_14_i), 
    .mac_acc_d_i(mac_acc_d_14_i),
  
    //output 
    //data out
    //mac activation
    
    .mac_mantissa_activation_a_o(mac_mantissa_activation_a[14]), 
    .mac_mantissa_activation_b_o(mac_mantissa_activation_b[14]), 
    .mac_mantissa_activation_c_o(mac_mantissa_activation_c[14]), 
    .mac_mantissa_activation_d_o(mac_mantissa_activation_d[14]),
    
    .mac_acc_a_o(mac_acc_a_14_o), 
    .mac_acc_b_o(mac_acc_b_14_o), 
    .mac_acc_c_o(mac_acc_c_14_o), 
    .mac_acc_d_o(mac_acc_d_14_o),

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
  
  mac_quad_nomantissaout
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) mac_quad_15(
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
  
    //Execute Control
    .set_weight_i(set_weight_i),
    //data in
    //mac activation    
    .mac_mantissa_activation_a_i(mac_mantissa_activation_a[14]), 
    .mac_mantissa_activation_b_i(mac_mantissa_activation_b[14]), 
    .mac_mantissa_activation_c_i(mac_mantissa_activation_c[14]), 
    .mac_mantissa_activation_d_i(mac_mantissa_activation_d[14]),
    
    .mac_acc_a_i(mac_acc_a_15_i), 
    .mac_acc_b_i(mac_acc_b_15_i), 
    .mac_acc_c_i(mac_acc_c_15_i), 
    .mac_acc_d_i(mac_acc_d_15_i),
  
    //data out
    .mac_acc_a_o(mac_acc_a_15_o), 
    .mac_acc_b_o(mac_acc_b_15_o), 
    .mac_acc_c_o(mac_acc_c_15_o), 
    .mac_acc_d_o(mac_acc_d_15_o),

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
endmodule
