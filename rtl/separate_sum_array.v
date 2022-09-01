`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/19 17:24:15
// Design Name: 
// Module Name: separate_sum_array
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


module separate_sum_array
#(
  parameter EXPONENT_WIDTH = 8,
  parameter WEIGHT_RAM_ADDR_WIDTH = 4,
  parameter MAC_ACC_WIDTH = 48,
  parameter ACCUMULATOR_DATA_WIDTH = 32,
  parameter BUFFER_ADDR_WIDTH = 15
) (
  input  wire clk, rst_n,
  
  //Write Buffer Control
  input  wire prepare_weight,
  //input  wire i_weight_data_fifo_wr_en,
  
  //Execute Control
  input  wire set_weight_i,
  
  //activation/weight mantissa in
  input  wire [EXPONENT_WIDTH-1:0] mac_exponent_activation_i,
  
  //mac array
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
  //mac array output
  output wire [ACCUMULATOR_DATA_WIDTH-1:0] mac_acc_0_o,  mac_acc_1_o,  mac_acc_2_o,  mac_acc_3_o,
  output wire [ACCUMULATOR_DATA_WIDTH-1:0] mac_acc_4_o,  mac_acc_5_o,  mac_acc_6_o,  mac_acc_7_o,
  output wire [ACCUMULATOR_DATA_WIDTH-1:0] mac_acc_8_o,  mac_acc_9_o,  mac_acc_10_o, mac_acc_11_o,
  output wire [ACCUMULATOR_DATA_WIDTH-1:0] mac_acc_12_o, mac_acc_13_o, mac_acc_14_o, mac_acc_15_o,
  output wire [ACCUMULATOR_DATA_WIDTH-1:0] mac_acc_16_o, mac_acc_17_o, mac_acc_18_o, mac_acc_19_o,
  output wire [ACCUMULATOR_DATA_WIDTH-1:0] mac_acc_20_o, mac_acc_21_o, mac_acc_22_o, mac_acc_23_o,
  output wire [ACCUMULATOR_DATA_WIDTH-1:0] mac_acc_24_o, mac_acc_25_o, mac_acc_26_o, mac_acc_27_o,
  output wire [ACCUMULATOR_DATA_WIDTH-1:0] mac_acc_28_o, mac_acc_29_o, mac_acc_30_o, mac_acc_31_o,

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

  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_0_o,  mac_exponent_activation_0_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_1_o,  mac_exponent_activation_1_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_2_o,  mac_exponent_activation_2_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_3_o,  mac_exponent_activation_3_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_4_o,  mac_exponent_activation_4_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_5_o,  mac_exponent_activation_5_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_6_o,  mac_exponent_activation_6_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_7_o,  mac_exponent_activation_7_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_8_o,  mac_exponent_activation_8_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_9_o,  mac_exponent_activation_9_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_10_o, mac_exponent_activation_10_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_11_o, mac_exponent_activation_11_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_12_o, mac_exponent_activation_12_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_13_o, mac_exponent_activation_13_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_14_o, mac_exponent_activation_14_o;
  wire [EXPONENT_WIDTH-1:0] mac_exponent_weight_15_o, mac_exponent_activation_15_o;
 
  wire [WEIGHT_RAM_ADDR_WIDTH-1:0] weight_ram_rd_addr[15:0];
  wire set_weight [15:0]; 
  
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .EXPONENT_WIDTH(EXPONENT_WIDTH)
  ) separate_sum_unit_0
  (
    .clk(clk), 
    .rst_n(rst_n),

    //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
        
    .mac_exponent_activation_i(mac_exponent_activation_i),
  
    .mac_acc_a_i(mac_acc_a_0_i), 
    .mac_acc_b_i(mac_acc_b_0_i), 
    .mac_acc_c_i(mac_acc_c_0_i), 
    .mac_acc_d_i(mac_acc_d_0_i),

    .mac_exponent_activation_o(mac_exponent_activation_0_o),
    
    .mac_acc_result_a_o(mac_acc_0_o), 
    .mac_acc_result_b_o(mac_acc_1_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_1
  (
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i), 
    
    .mac_exponent_activation_i(mac_exponent_activation_0_o),
  
    .mac_acc_a_i(mac_acc_a_1_i),
    .mac_acc_b_i(mac_acc_b_1_i), 
    .mac_acc_c_i(mac_acc_c_1_i), 
    .mac_acc_d_i(mac_acc_d_1_i),

    .mac_exponent_activation_o(mac_exponent_activation_1_o),
    
    .mac_acc_result_a_o(mac_acc_2_o), 
    .mac_acc_result_b_o(mac_acc_3_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_2
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
        
    .mac_exponent_activation_i(mac_exponent_activation_1_o),
  
    .mac_acc_a_i(mac_acc_a_2_i), 
    .mac_acc_b_i(mac_acc_b_2_i), 
    .mac_acc_c_i(mac_acc_c_2_i), 
    .mac_acc_d_i(mac_acc_d_2_i),

    .mac_exponent_activation_o(mac_exponent_activation_2_o),
    
    .mac_acc_result_a_o(mac_acc_4_o), 
    .mac_acc_result_b_o(mac_acc_5_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_3
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
        
    .mac_exponent_activation_i(mac_exponent_activation_2_o),
  
    .mac_acc_a_i(mac_acc_a_3_i), 
    .mac_acc_b_i(mac_acc_b_3_i), 
    .mac_acc_c_i(mac_acc_c_3_i), 
    .mac_acc_d_i(mac_acc_d_3_i),
    
    .mac_exponent_activation_o(mac_exponent_activation_3_o),
    
    .mac_acc_result_a_o(mac_acc_6_o), 
    .mac_acc_result_b_o(mac_acc_7_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_4
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
        
    .mac_exponent_activation_i(mac_exponent_activation_3_o),
  
    .mac_acc_a_i(mac_acc_a_4_i), 
    .mac_acc_b_i(mac_acc_b_4_i), 
    .mac_acc_c_i(mac_acc_c_4_i), 
    .mac_acc_d_i(mac_acc_d_4_i),

    .mac_exponent_activation_o(mac_exponent_activation_4_o),
    
    .mac_acc_result_a_o(mac_acc_8_o), 
    .mac_acc_result_b_o(mac_acc_9_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_5
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
        
    .mac_exponent_activation_i(mac_exponent_activation_4_o),
  
    .mac_acc_a_i(mac_acc_a_5_i), 
    .mac_acc_b_i(mac_acc_b_5_i), 
    .mac_acc_c_i(mac_acc_c_5_i), 
    .mac_acc_d_i(mac_acc_d_5_i),

    .mac_exponent_activation_o(mac_exponent_activation_5_o),
    
    .mac_acc_result_a_o(mac_acc_10_o), 
    .mac_acc_result_b_o(mac_acc_11_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_6
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
        
    .mac_exponent_activation_i(mac_exponent_activation_5_o),
  
    .mac_acc_a_i(mac_acc_a_6_i), 
    .mac_acc_b_i(mac_acc_b_6_i), 
    .mac_acc_c_i(mac_acc_c_6_i), 
    .mac_acc_d_i(mac_acc_d_6_i),

    .mac_exponent_activation_o(mac_exponent_activation_6_o),
    
    .mac_acc_result_a_o(mac_acc_12_o), 
    .mac_acc_result_b_o(mac_acc_13_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_7
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
        
    .mac_exponent_activation_i(mac_exponent_activation_6_o),
  
    .mac_acc_a_i(mac_acc_a_7_i), 
    .mac_acc_b_i(mac_acc_b_7_i), 
    .mac_acc_c_i(mac_acc_c_7_i), 
    .mac_acc_d_i(mac_acc_d_7_i),

    .mac_exponent_activation_o(mac_exponent_activation_7_o),
    
    .mac_acc_result_a_o(mac_acc_14_o), 
    .mac_acc_result_b_o(mac_acc_15_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_8
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
        
    .mac_exponent_activation_i(mac_exponent_activation_7_o),
  
    .mac_acc_a_i(mac_acc_a_8_i), 
    .mac_acc_b_i(mac_acc_b_8_i), 
    .mac_acc_c_i(mac_acc_c_8_i), 
    .mac_acc_d_i(mac_acc_d_8_i),

    .mac_exponent_activation_o(mac_exponent_activation_8_o),
    
    .mac_acc_result_a_o(mac_acc_16_o), 
    .mac_acc_result_b_o(mac_acc_17_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_9
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
        
    .mac_exponent_activation_i(mac_exponent_activation_8_o),
  
    .mac_acc_a_i(mac_acc_a_9_i), 
    .mac_acc_b_i(mac_acc_b_9_i), 
    .mac_acc_c_i(mac_acc_c_9_i), 
    .mac_acc_d_i(mac_acc_d_9_i),

    .mac_exponent_activation_o(mac_exponent_activation_9_o),
    
    .mac_acc_result_a_o(mac_acc_18_o), 
    .mac_acc_result_b_o(mac_acc_19_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_10
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
    
    .mac_exponent_activation_i(mac_exponent_activation_9_o),
  
    .mac_acc_a_i(mac_acc_a_10_i), 
    .mac_acc_b_i(mac_acc_b_10_i), 
    .mac_acc_c_i(mac_acc_c_10_i), 
    .mac_acc_d_i(mac_acc_d_10_i),
  
    .mac_exponent_activation_o(mac_exponent_activation_10_o),
    
    .mac_acc_result_a_o(mac_acc_20_o), 
    .mac_acc_result_b_o(mac_acc_21_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_11
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
    
    .mac_exponent_activation_i(mac_exponent_activation_10_o),
  
    .mac_acc_a_i(mac_acc_a_11_i), 
    .mac_acc_b_i(mac_acc_b_11_i), 
    .mac_acc_c_i(mac_acc_c_11_i), 
    .mac_acc_d_i(mac_acc_d_11_i),
  
    .mac_exponent_activation_o(mac_exponent_activation_11_o),
    
    .mac_acc_result_a_o(mac_acc_22_o), 
    .mac_acc_result_b_o(mac_acc_23_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_12
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
    
    .mac_exponent_activation_i(mac_exponent_activation_11_o),
  
    .mac_acc_a_i(mac_acc_a_12_i), 
    .mac_acc_b_i(mac_acc_b_12_i), 
    .mac_acc_c_i(mac_acc_c_12_i), 
    .mac_acc_d_i(mac_acc_d_12_i),
  
    .mac_exponent_activation_o(mac_exponent_activation_12_o),
    
    .mac_acc_result_a_o(mac_acc_24_o), 
    .mac_acc_result_b_o(mac_acc_25_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_13
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
    
    .mac_exponent_activation_i(mac_exponent_activation_12_o),
  
    .mac_acc_a_i(mac_acc_a_13_i), 
    .mac_acc_b_i(mac_acc_b_13_i), 
    .mac_acc_c_i(mac_acc_c_13_i), 
    .mac_acc_d_i(mac_acc_d_13_i),
  
    .mac_exponent_activation_o(mac_exponent_activation_13_o),
    
    .mac_acc_result_a_o(mac_acc_26_o), 
    .mac_acc_result_b_o(mac_acc_27_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_14
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
    
    .mac_exponent_activation_i(mac_exponent_activation_13_o),
  
    .mac_acc_a_i(mac_acc_a_14_i), 
    .mac_acc_b_i(mac_acc_b_14_i), 
    .mac_acc_c_i(mac_acc_c_14_i), 
    .mac_acc_d_i(mac_acc_d_14_i),
  
    .mac_exponent_activation_o(mac_exponent_activation_14_o),
    
    .mac_acc_result_a_o(mac_acc_28_o), 
    .mac_acc_result_b_o(mac_acc_29_o),

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
  
  separate_sum_unit
  #(
    .WEIGHT_RAM_ADDR_WIDTH(WEIGHT_RAM_ADDR_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH)
  ) separate_sum_unit_15
  (
    //input
    //control signal in
    .clk(clk), 
    .rst_n(rst_n),
    
     //Write Buffer Control
    .prepare_weight(prepare_weight),  
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
      
    //Execute Control
    .set_weight_i(set_weight_i),
    
    .mac_exponent_activation_i(mac_exponent_activation_14_o),
  
    .mac_acc_a_i(mac_acc_a_15_i), 
    .mac_acc_b_i(mac_acc_b_15_i), 
    .mac_acc_c_i(mac_acc_c_15_i), 
    .mac_acc_d_i(mac_acc_d_15_i),
  
    .mac_exponent_activation_o(mac_exponent_activation_15_o),
    
    .mac_acc_result_a_o(mac_acc_30_o), 
    .mac_acc_result_b_o(mac_acc_31_o),

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
