`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/22 22:30:59
// Design Name: 
// Module Name: Activation
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


module Activation
#(
  parameter ACCUM_DATA_WIDTH = 32,
  parameter EXPONENT_WIDTH = 8,
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter PARAM_ROM_ADDR_WIDTH = 8
)
(
  input  wire                            clk, 
  input  wire                            rst_n,
  //Contorl Signal=============================================================
  //alu control 
  input  wire [3:0]                      vetor_unit_op,
  input  wire                            i_prepare_weight,
  input  wire                            i_set_param,
  input  wire                            i_param_data_fifo_wr_en,
  //=============================
  //activation accum fifo control
  output wire                            o_activation_accum_fifo_empty, 
  output wire                            o_activation_accum_fifo_full,
  input  wire                            i_activation_accum_fifo_rd_en, 
  input  wire                            i_activation_accum_fifo_wr_en,
  //=============================
  //activation final fifo control
  output wire                            o_activation_out_fifo_full,
  output wire                            o_activation_out_fifo_empty,
  input  wire                            i_activation_out_fifo_wr_en,
  input  wire                            i_activation_out_fifo_rd_en,
  //==========================================================================
  
  //Data
  input  wire [ACCUM_DATA_WIDTH-1:0] vector_0_i,  vector_1_i,  vector_2_i,  vector_3_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] vector_4_i,  vector_5_i,  vector_6_i,  vector_7_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] vector_8_i,  vector_9_i,  vector_10_i, vector_11_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] vector_12_i, vector_13_i, vector_14_i, vector_15_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] vector_16_i, vector_17_i, vector_18_i, vector_19_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] vector_20_i, vector_21_i, vector_22_i, vector_23_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] vector_24_i, vector_25_i, vector_26_i, vector_27_i,
  input  wire [ACCUM_DATA_WIDTH-1:0] vector_28_i, vector_29_i, vector_30_i, vector_31_i,

  output wire [ACCUM_DATA_WIDTH-1:0] vector_0_o,  vector_1_o,  vector_2_o,  vector_3_o,
  output wire [ACCUM_DATA_WIDTH-1:0] vector_4_o,  vector_5_o,  vector_6_o,  vector_7_o,
  output wire [ACCUM_DATA_WIDTH-1:0] vector_8_o,  vector_9_o,  vector_10_o, vector_11_o,
  output wire [ACCUM_DATA_WIDTH-1:0] vector_12_o, vector_13_o, vector_14_o, vector_15_o,
  output wire [ACCUM_DATA_WIDTH-1:0] vector_16_o, vector_17_o, vector_18_o, vector_19_o,
  output wire [ACCUM_DATA_WIDTH-1:0] vector_20_o, vector_21_o, vector_22_o, vector_23_o,
  output wire [ACCUM_DATA_WIDTH-1:0] vector_24_o, vector_25_o, vector_26_o, vector_27_o,
  output wire [ACCUM_DATA_WIDTH-1:0] vector_28_o, vector_29_o, vector_30_o, vector_31_o,

  //Load Weight Out/////////////////////////////////////////////////////////////////
  input  wire [7:0]                  i_load_weight_data_0_a_param,
  input  wire [7:0]                  i_load_weight_data_0_b_param,
  input  wire [7:0]                  i_load_weight_data_0_c_param,
  input  wire [7:0]                  i_load_weight_data_0_d_param,

  input  wire [7:0]                  i_load_weight_data_1_a_param,
  input  wire [7:0]                  i_load_weight_data_1_b_param,
  input  wire [7:0]                  i_load_weight_data_1_c_param,
  input  wire [7:0]                  i_load_weight_data_1_d_param,

  input  wire [7:0]                  i_load_weight_data_2_a_param,
  input  wire [7:0]                  i_load_weight_data_2_b_param,
  input  wire [7:0]                  i_load_weight_data_2_c_param,
  input  wire [7:0]                  i_load_weight_data_2_d_param,

  input  wire [7:0]                  i_load_weight_data_3_a_param,
  input  wire [7:0]                  i_load_weight_data_3_b_param,
  input  wire [7:0]                  i_load_weight_data_3_c_param,
  input  wire [7:0]                  i_load_weight_data_3_d_param,

  input  wire [7:0]                  i_load_weight_data_4_a_param,
  input  wire [7:0]                  i_load_weight_data_4_b_param,
  input  wire [7:0]                  i_load_weight_data_4_c_param,
  input  wire [7:0]                  i_load_weight_data_4_d_param,

  input  wire [7:0]                  i_load_weight_data_5_a_param,
  input  wire [7:0]                  i_load_weight_data_5_b_param,
  input  wire [7:0]                  i_load_weight_data_5_c_param,
  input  wire [7:0]                  i_load_weight_data_5_d_param,

  input  wire [7:0]                  i_load_weight_data_6_a_param,
  input  wire [7:0]                  i_load_weight_data_6_b_param,
  input  wire [7:0]                  i_load_weight_data_6_c_param,
  input  wire [7:0]                  i_load_weight_data_6_d_param,

  input  wire [7:0]                  i_load_weight_data_7_a_param,
  input  wire [7:0]                  i_load_weight_data_7_b_param,
  input  wire [7:0]                  i_load_weight_data_7_c_param,
  input  wire [7:0]                  i_load_weight_data_7_d_param,

  input  wire [7:0]                  i_load_weight_data_8_a_param,
  input  wire [7:0]                  i_load_weight_data_8_b_param,
  input  wire [7:0]                  i_load_weight_data_8_c_param,
  input  wire [7:0]                  i_load_weight_data_8_d_param,

  input  wire [7:0]                  i_load_weight_data_9_a_param,
  input  wire [7:0]                  i_load_weight_data_9_b_param,
  input  wire [7:0]                  i_load_weight_data_9_c_param,
  input  wire [7:0]                  i_load_weight_data_9_d_param,

  input  wire [7:0]                  i_load_weight_data_10_a_param,
  input  wire [7:0]                  i_load_weight_data_10_b_param,
  input  wire [7:0]                  i_load_weight_data_10_c_param,
  input  wire [7:0]                  i_load_weight_data_10_d_param,

  input  wire [7:0]                  i_load_weight_data_11_a_param,
  input  wire [7:0]                  i_load_weight_data_11_b_param,
  input  wire [7:0]                  i_load_weight_data_11_c_param,
  input  wire [7:0]                  i_load_weight_data_11_d_param,

  input  wire [7:0]                  i_load_weight_data_12_a_param,
  input  wire [7:0]                  i_load_weight_data_12_b_param,
  input  wire [7:0]                  i_load_weight_data_12_c_param,
  input  wire [7:0]                  i_load_weight_data_12_d_param,

  input  wire [7:0]                  i_load_weight_data_13_a_param,
  input  wire [7:0]                  i_load_weight_data_13_b_param,
  input  wire [7:0]                  i_load_weight_data_13_c_param,
  input  wire [7:0]                  i_load_weight_data_13_d_param,

  input  wire [7:0]                  i_load_weight_data_14_a_param,
  input  wire [7:0]                  i_load_weight_data_14_b_param,
  input  wire [7:0]                  i_load_weight_data_14_c_param,
  input  wire [7:0]                  i_load_weight_data_14_d_param,

  input  wire [7:0]                  i_load_weight_data_15_a_param,
  input  wire [7:0]                  i_load_weight_data_15_b_param,
  input  wire [7:0]                  i_load_weight_data_15_c_param,
  input  wire [7:0]                  i_load_weight_data_15_d_param,

  input  wire [7:0]                  i_load_weight_data_16_a_param,
  input  wire [7:0]                  i_load_weight_data_16_b_param,
  input  wire [7:0]                  i_load_weight_data_16_c_param,
  input  wire [7:0]                  i_load_weight_data_16_d_param,

  input  wire [7:0]                  i_load_weight_data_17_a_param,
  input  wire [7:0]                  i_load_weight_data_17_b_param,
  input  wire [7:0]                  i_load_weight_data_17_c_param,
  input  wire [7:0]                  i_load_weight_data_17_d_param,

  input  wire [7:0]                  i_load_weight_data_18_a_param,
  input  wire [7:0]                  i_load_weight_data_18_b_param,
  input  wire [7:0]                  i_load_weight_data_18_c_param,
  input  wire [7:0]                  i_load_weight_data_18_d_param,

  input  wire [7:0]                  i_load_weight_data_19_a_param,
  input  wire [7:0]                  i_load_weight_data_19_b_param,
  input  wire [7:0]                  i_load_weight_data_19_c_param,
  input  wire [7:0]                  i_load_weight_data_19_d_param,

  input  wire [7:0]                  i_load_weight_data_20_a_param,
  input  wire [7:0]                  i_load_weight_data_20_b_param,
  input  wire [7:0]                  i_load_weight_data_20_c_param,
  input  wire [7:0]                  i_load_weight_data_20_d_param,

  input  wire [7:0]                  i_load_weight_data_21_a_param,
  input  wire [7:0]                  i_load_weight_data_21_b_param,
  input  wire [7:0]                  i_load_weight_data_21_c_param,
  input  wire [7:0]                  i_load_weight_data_21_d_param,

  input  wire [7:0]                  i_load_weight_data_22_a_param,
  input  wire [7:0]                  i_load_weight_data_22_b_param,
  input  wire [7:0]                  i_load_weight_data_22_c_param,
  input  wire [7:0]                  i_load_weight_data_22_d_param,

  input  wire [7:0]                  i_load_weight_data_23_a_param,
  input  wire [7:0]                  i_load_weight_data_23_b_param,
  input  wire [7:0]                  i_load_weight_data_23_c_param,
  input  wire [7:0]                  i_load_weight_data_23_d_param,

  input  wire [7:0]                  i_load_weight_data_24_a_param,
  input  wire [7:0]                  i_load_weight_data_24_b_param,
  input  wire [7:0]                  i_load_weight_data_24_c_param,
  input  wire [7:0]                  i_load_weight_data_24_d_param,

  input  wire [7:0]                  i_load_weight_data_25_a_param,
  input  wire [7:0]                  i_load_weight_data_25_b_param,
  input  wire [7:0]                  i_load_weight_data_25_c_param,
  input  wire [7:0]                  i_load_weight_data_25_d_param,

  input  wire [7:0]                  i_load_weight_data_26_a_param,
  input  wire [7:0]                  i_load_weight_data_26_b_param,
  input  wire [7:0]                  i_load_weight_data_26_c_param,
  input  wire [7:0]                  i_load_weight_data_26_d_param,

  input  wire [7:0]                  i_load_weight_data_27_a_param,
  input  wire [7:0]                  i_load_weight_data_27_b_param,
  input  wire [7:0]                  i_load_weight_data_27_c_param,
  input  wire [7:0]                  i_load_weight_data_27_d_param,

  input  wire [7:0]                  i_load_weight_data_28_a_param,
  input  wire [7:0]                  i_load_weight_data_28_b_param,
  input  wire [7:0]                  i_load_weight_data_28_c_param,
  input  wire [7:0]                  i_load_weight_data_28_d_param,

  input  wire [7:0]                  i_load_weight_data_29_a_param,
  input  wire [7:0]                  i_load_weight_data_29_b_param,
  input  wire [7:0]                  i_load_weight_data_29_c_param,
  input  wire [7:0]                  i_load_weight_data_29_d_param,

  input  wire [7:0]                  i_load_weight_data_30_a_param,
  input  wire [7:0]                  i_load_weight_data_30_b_param,
  input  wire [7:0]                  i_load_weight_data_30_c_param,
  input  wire [7:0]                  i_load_weight_data_30_d_param,

  input  wire [7:0]                  i_load_weight_data_31_a_param,
  input  wire [7:0]                  i_load_weight_data_31_b_param,
  input  wire [7:0]                  i_load_weight_data_31_c_param,
  input  wire [7:0]                  i_load_weight_data_31_d_param
);
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_0
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_0_i), 
    .data_in_1(vector_1_i),
    .fifo_empty(o_activation_accum_fifo_empty), 
    .fifo_full(o_activation_accum_fifo_full),
    .o_activation_out_fifo_empty(o_activation_out_fifo_empty),
    .o_activation_out_fifo_full(o_activation_out_fifo_full),
    .data_out_0(vector_0_o), 
    .data_out_1(vector_1_o),

    .i_load_weight_data_a_0(i_load_weight_data_0_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_0_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_0_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_0_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_1_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_1_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_1_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_1_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_1
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_2_i), 
    .data_in_1(vector_3_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_2_o), 
    .data_out_1(vector_3_o),

    .i_load_weight_data_a_0(i_load_weight_data_2_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_2_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_2_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_2_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_3_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_3_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_3_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_3_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_2
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_4_i), 
    .data_in_1(vector_5_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_4_o), 
    .data_out_1(vector_5_o),

    .i_load_weight_data_a_0(i_load_weight_data_4_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_4_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_4_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_4_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_5_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_5_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_5_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_5_d_param)
  );

  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_3
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_6_i), 
    .data_in_1(vector_7_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_6_o), 
    .data_out_1(vector_7_o),

    .i_load_weight_data_a_0(i_load_weight_data_6_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_6_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_6_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_6_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_7_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_7_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_7_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_7_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_4
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_8_i), 
    .data_in_1(vector_9_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_8_o), 
    .data_out_1(vector_9_o),

    .i_load_weight_data_a_0(i_load_weight_data_8_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_8_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_8_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_8_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_9_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_9_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_9_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_9_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_5
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_10_i), 
    .data_in_1(vector_11_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_10_o), 
    .data_out_1(vector_11_o),

    .i_load_weight_data_a_0(i_load_weight_data_10_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_10_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_10_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_10_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_11_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_11_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_11_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_11_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_6
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_12_i), 
    .data_in_1(vector_13_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_12_o), 
    .data_out_1(vector_13_o),

    .i_load_weight_data_a_0(i_load_weight_data_12_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_12_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_12_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_12_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_13_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_13_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_13_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_13_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_7
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_14_i), 
    .data_in_1(vector_15_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_14_o), 
    .data_out_1(vector_15_o),

    .i_load_weight_data_a_0(i_load_weight_data_14_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_14_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_14_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_14_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_15_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_15_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_15_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_15_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_8
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_16_i), 
    .data_in_1(vector_17_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_16_o), 
    .data_out_1(vector_17_o),

    .i_load_weight_data_a_0(i_load_weight_data_16_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_16_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_16_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_16_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_17_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_17_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_17_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_17_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_9
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_18_i), 
    .data_in_1(vector_19_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_18_o), 
    .data_out_1(vector_19_o),

    .i_load_weight_data_a_0(i_load_weight_data_18_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_18_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_18_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_18_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_19_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_19_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_19_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_19_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_10
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_20_i), 
    .data_in_1(vector_21_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_20_o), 
    .data_out_1(vector_21_o),

    .i_load_weight_data_a_0(i_load_weight_data_20_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_20_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_20_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_20_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_21_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_21_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_21_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_21_d_param)
  );
  
    programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_11
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_22_i), 
    .data_in_1(vector_23_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_22_o), 
    .data_out_1(vector_23_o),

    .i_load_weight_data_a_0(i_load_weight_data_22_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_22_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_22_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_22_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_23_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_23_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_23_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_23_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_12
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_24_i), 
    .data_in_1(vector_25_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_24_o), 
    .data_out_1(vector_25_o),

    .i_load_weight_data_a_0(i_load_weight_data_24_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_24_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_24_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_24_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_25_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_25_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_25_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_25_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_13
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_26_i), 
    .data_in_1(vector_27_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_26_o), 
    .data_out_1(vector_27_o),

    .i_load_weight_data_a_0(i_load_weight_data_26_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_26_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_26_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_26_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_27_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_27_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_27_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_27_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_14
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    .data_in_0(vector_28_i), 
    .data_in_1(vector_29_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_28_o), 
    .data_out_1(vector_29_o),

    .i_load_weight_data_a_0(i_load_weight_data_28_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_28_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_28_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_28_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_29_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_29_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_29_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_29_d_param)
  );
  
  programable_vector_unit_dual
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .PARAM_ROM_ADDR_WIDTH(PARAM_ROM_ADDR_WIDTH)
  ) programable_vector_unit_dual_15
  (
    .clk(clk), 
    .rst_n(rst_n),
    .rd_en_i(i_activation_accum_fifo_rd_en), 
    .wr_en_i(i_activation_accum_fifo_wr_en),
    .i_activation_out_fifo_rd_en(i_activation_out_fifo_rd_en),
    .i_activation_out_fifo_wr_en(i_activation_out_fifo_wr_en),
    .vetor_unit_op(vetor_unit_op),
    .i_prepare_weight(i_prepare_weight),
    .i_param_data_fifo_wr_en(i_param_data_fifo_wr_en),
    .i_set_param(i_set_param),
    
    .data_in_0(vector_30_i), 
    .data_in_1(vector_31_i),
    .fifo_empty(), 
    .fifo_full(),
    .data_out_0(vector_30_o), 
    .data_out_1(vector_31_o),

    .i_load_weight_data_a_0(i_load_weight_data_30_a_param),
    .i_load_weight_data_b_0(i_load_weight_data_30_b_param),
    .i_load_weight_data_c_0(i_load_weight_data_30_c_param),
    .i_load_weight_data_d_0(i_load_weight_data_30_d_param),

    .i_load_weight_data_a_1(i_load_weight_data_31_a_param),
    .i_load_weight_data_b_1(i_load_weight_data_31_b_param),
    .i_load_weight_data_c_1(i_load_weight_data_31_c_param),
    .i_load_weight_data_d_1(i_load_weight_data_31_d_param)
  );
endmodule

