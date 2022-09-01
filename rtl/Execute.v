`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Dongho Park
// 
// Create Date: 2021/02/17 14:45:16
// Design Name: 
// Module Name: Execute
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


module Execute
#(
  parameter AXI_WIDTH_DA = 32,
  
  parameter QUNATIZED_MANTISSA_WIDTH = 7,
  parameter EXPONENT_WIDTH = 8,
  parameter MAC_ACC_WIDTH = 48,
  parameter BUFFER_ADDR_WIDTH = 15,
  
  parameter ACCUM_DATA_WIDTH = 32,
  parameter ACCUM_ADDR_WIDTH = 8,
  parameter BIAS_ROM_ADDR = 8
)
(
  input  wire clk, rst_n,
  
  //Execute Control Signals=====================================================================================
  //Write Buffer Control
  input  wire                            buffer_wr_en_i, 
  input  wire [BUFFER_ADDR_WIDTH-1:0]    buffer_wr_addr_i, 
  input  wire                            select_wb,
  
  //Execute Control
  input  wire                            set_weight_i, 
  //input  wire                            i_weight_data_fifo_wr_en,
  input  wire                            activation_rd_en_i,
  input  wire [BUFFER_ADDR_WIDTH-1:0]    buffer_rd_addr_i,

  //Accumulator Control
  input  wire                            i_set_bias,
  input  wire                            i_bias_data_fifo_wr_en,
  input  wire                            accum_rd_en_i, 
  input  wire                            accum_wr_en_i, 
  input  wire                            bias_mode_i,
  input  wire [ACCUM_ADDR_WIDTH-1:0]     accum_addr_i, 

  //Accumulator FIFO Control
  output wire                            o_execute_out_fifo_full, //final data
  input  wire                            i_execute_out_fifo_wr_en, //final data
  output wire                            o_execute_out_fifo_empty, //to activation control
  input  wire                            i_execute_out_fifo_rd_en, //to activation control
  //==============================================================================================================

  //////////////////////////////////////////////////////////////////////////////////
  //Load Weight Control Signals/////////////////////////////////////////////////////
  //
  input wire                         i_load_weight_data_reg_wr_en,          
  input wire [4:0]                   i_sel_load_weight_data,
  input wire                         i_prepare_weight,
  /////////////////
  //AXI MASTER READ
  //
  input wire [AXI_WIDTH_DA-1:0]      m_axi_weight_memory_bus_RDATA,
  //////////////////////////////////////////////////////////////////////////////////

  //Load Data(AXI Master Read)
  input  wire [QUNATIZED_MANTISSA_WIDTH-1:0] 
    execute_load_data_0_i,  execute_load_data_1_i,  execute_load_data_2_i,  execute_load_data_3_i,
    execute_load_data_4_i,  execute_load_data_5_i,  execute_load_data_6_i,  execute_load_data_7_i,
    execute_load_data_8_i,  execute_load_data_9_i,  execute_load_data_10_i, execute_load_data_11_i,
    execute_load_data_12_i, execute_load_data_13_i, execute_load_data_14_i, execute_load_data_15_i,
    execute_load_data_16_i, execute_load_data_17_i, execute_load_data_18_i, execute_load_data_19_i,
    execute_load_data_20_i, execute_load_data_21_i, execute_load_data_22_i, execute_load_data_23_i,
    execute_load_data_24_i, execute_load_data_25_i, execute_load_data_26_i, execute_load_data_27_i,
    execute_load_data_28_i, execute_load_data_29_i, execute_load_data_30_i, execute_load_data_31_i,
  
  input  wire [EXPONENT_WIDTH-1:0] load_exponent_i,

  //Write Back Data
  input  wire [QUNATIZED_MANTISSA_WIDTH-1:0] 
    execute_write_back_data_0_i,  execute_write_back_data_1_i,  execute_write_back_data_2_i,  execute_write_back_data_3_i,
    execute_write_back_data_4_i,  execute_write_back_data_5_i,  execute_write_back_data_6_i,  execute_write_back_data_7_i,
    execute_write_back_data_8_i,  execute_write_back_data_9_i,  execute_write_back_data_10_i, execute_write_back_data_11_i,
    execute_write_back_data_12_i, execute_write_back_data_13_i, execute_write_back_data_14_i, execute_write_back_data_15_i,
    execute_write_back_data_16_i, execute_write_back_data_17_i, execute_write_back_data_18_i, execute_write_back_data_19_i,
    execute_write_back_data_20_i, execute_write_back_data_21_i, execute_write_back_data_22_i, execute_write_back_data_23_i,
    execute_write_back_data_24_i, execute_write_back_data_25_i, execute_write_back_data_26_i, execute_write_back_data_27_i,
    execute_write_back_data_28_i, execute_write_back_data_29_i, execute_write_back_data_30_i, execute_write_back_data_31_i,
  input  wire [EXPONENT_WIDTH-1:0] write_back_exponent_i,
  
  //Accumulator
  //Data
  output wire [ACCUM_DATA_WIDTH-1:0] accum_0_o,  accum_1_o,  accum_2_o,  accum_3_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_4_o,  accum_5_o,  accum_6_o,  accum_7_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_8_o,  accum_9_o,  accum_10_o, accum_11_o, 
  output wire [ACCUM_DATA_WIDTH-1:0] accum_12_o, accum_13_o, accum_14_o, accum_15_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_16_o, accum_17_o, accum_18_o, accum_19_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_20_o, accum_21_o, accum_22_o, accum_23_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_24_o, accum_25_o, accum_26_o, accum_27_o,
  output wire [ACCUM_DATA_WIDTH-1:0] accum_28_o, accum_29_o, accum_30_o, accum_31_o,

  //Load Weight Out/////////////////////////////////////////////////////////////////
  output  wire [7:0]                 o_load_weight_data_0_a_param,
  output  wire [7:0]                 o_load_weight_data_0_b_param,
  output  wire [7:0]                 o_load_weight_data_0_c_param,
  output  wire [7:0]                 o_load_weight_data_0_d_param,

  output  wire [7:0]                 o_load_weight_data_1_a_param,
  output  wire [7:0]                 o_load_weight_data_1_b_param,
  output  wire [7:0]                 o_load_weight_data_1_c_param,
  output  wire [7:0]                 o_load_weight_data_1_d_param,

  output  wire [7:0]                 o_load_weight_data_2_a_param,
  output  wire [7:0]                 o_load_weight_data_2_b_param,
  output  wire [7:0]                 o_load_weight_data_2_c_param,
  output  wire [7:0]                 o_load_weight_data_2_d_param,

  output  wire [7:0]                 o_load_weight_data_3_a_param,
  output  wire [7:0]                 o_load_weight_data_3_b_param,
  output  wire [7:0]                 o_load_weight_data_3_c_param,
  output  wire [7:0]                 o_load_weight_data_3_d_param,

  output  wire [7:0]                 o_load_weight_data_4_a_param,
  output  wire [7:0]                 o_load_weight_data_4_b_param,
  output  wire [7:0]                 o_load_weight_data_4_c_param,
  output  wire [7:0]                 o_load_weight_data_4_d_param,

  output  wire [7:0]                 o_load_weight_data_5_a_param,
  output  wire [7:0]                 o_load_weight_data_5_b_param,
  output  wire [7:0]                 o_load_weight_data_5_c_param,
  output  wire [7:0]                 o_load_weight_data_5_d_param,

  output  wire [7:0]                 o_load_weight_data_6_a_param,
  output  wire [7:0]                 o_load_weight_data_6_b_param,
  output  wire [7:0]                 o_load_weight_data_6_c_param,
  output  wire [7:0]                 o_load_weight_data_6_d_param,

  output  wire [7:0]                 o_load_weight_data_7_a_param,
  output  wire [7:0]                 o_load_weight_data_7_b_param,
  output  wire [7:0]                 o_load_weight_data_7_c_param,
  output  wire [7:0]                 o_load_weight_data_7_d_param,

  output  wire [7:0]                 o_load_weight_data_8_a_param,
  output  wire [7:0]                 o_load_weight_data_8_b_param,
  output  wire [7:0]                 o_load_weight_data_8_c_param,
  output  wire [7:0]                 o_load_weight_data_8_d_param,

  output  wire [7:0]                 o_load_weight_data_9_a_param,
  output  wire [7:0]                 o_load_weight_data_9_b_param,
  output  wire [7:0]                 o_load_weight_data_9_c_param,
  output  wire [7:0]                 o_load_weight_data_9_d_param,

  output  wire [7:0]                 o_load_weight_data_10_a_param,
  output  wire [7:0]                 o_load_weight_data_10_b_param,
  output  wire [7:0]                 o_load_weight_data_10_c_param,
  output  wire [7:0]                 o_load_weight_data_10_d_param,

  output  wire [7:0]                 o_load_weight_data_11_a_param,
  output  wire [7:0]                 o_load_weight_data_11_b_param,
  output  wire [7:0]                 o_load_weight_data_11_c_param,
  output  wire [7:0]                 o_load_weight_data_11_d_param,

  output  wire [7:0]                 o_load_weight_data_12_a_param,
  output  wire [7:0]                 o_load_weight_data_12_b_param,
  output  wire [7:0]                 o_load_weight_data_12_c_param,
  output  wire [7:0]                 o_load_weight_data_12_d_param,

  output  wire [7:0]                 o_load_weight_data_13_a_param,
  output  wire [7:0]                 o_load_weight_data_13_b_param,
  output  wire [7:0]                 o_load_weight_data_13_c_param,
  output  wire [7:0]                 o_load_weight_data_13_d_param,

  output  wire [7:0]                 o_load_weight_data_14_a_param,
  output  wire [7:0]                 o_load_weight_data_14_b_param,
  output  wire [7:0]                 o_load_weight_data_14_c_param,
  output  wire [7:0]                 o_load_weight_data_14_d_param,

  output  wire [7:0]                 o_load_weight_data_15_a_param,
  output  wire [7:0]                 o_load_weight_data_15_b_param,
  output  wire [7:0]                 o_load_weight_data_15_c_param,
  output  wire [7:0]                 o_load_weight_data_15_d_param,

  output  wire [7:0]                 o_load_weight_data_16_a_param,
  output  wire [7:0]                 o_load_weight_data_16_b_param,
  output  wire [7:0]                 o_load_weight_data_16_c_param,
  output  wire [7:0]                 o_load_weight_data_16_d_param,

  output  wire [7:0]                 o_load_weight_data_17_a_param,
  output  wire [7:0]                 o_load_weight_data_17_b_param,
  output  wire [7:0]                 o_load_weight_data_17_c_param,
  output  wire [7:0]                 o_load_weight_data_17_d_param,

  output  wire [7:0]                 o_load_weight_data_18_a_param,
  output  wire [7:0]                 o_load_weight_data_18_b_param,
  output  wire [7:0]                 o_load_weight_data_18_c_param,
  output  wire [7:0]                 o_load_weight_data_18_d_param,

  output  wire [7:0]                 o_load_weight_data_19_a_param,
  output  wire [7:0]                 o_load_weight_data_19_b_param,
  output  wire [7:0]                 o_load_weight_data_19_c_param,
  output  wire [7:0]                 o_load_weight_data_19_d_param,

  output  wire [7:0]                 o_load_weight_data_20_a_param,
  output  wire [7:0]                 o_load_weight_data_20_b_param,
  output  wire [7:0]                 o_load_weight_data_20_c_param,
  output  wire [7:0]                 o_load_weight_data_20_d_param,

  output  wire [7:0]                 o_load_weight_data_21_a_param,
  output  wire [7:0]                 o_load_weight_data_21_b_param,
  output  wire [7:0]                 o_load_weight_data_21_c_param,
  output  wire [7:0]                 o_load_weight_data_21_d_param,

  output  wire [7:0]                 o_load_weight_data_22_a_param,
  output  wire [7:0]                 o_load_weight_data_22_b_param,
  output  wire [7:0]                 o_load_weight_data_22_c_param,
  output  wire [7:0]                 o_load_weight_data_22_d_param,

  output  wire [7:0]                 o_load_weight_data_23_a_param,
  output  wire [7:0]                 o_load_weight_data_23_b_param,
  output  wire [7:0]                 o_load_weight_data_23_c_param,
  output  wire [7:0]                 o_load_weight_data_23_d_param,

  output  wire [7:0]                 o_load_weight_data_24_a_param,
  output  wire [7:0]                 o_load_weight_data_24_b_param,
  output  wire [7:0]                 o_load_weight_data_24_c_param,
  output  wire [7:0]                 o_load_weight_data_24_d_param,

  output  wire [7:0]                 o_load_weight_data_25_a_param,
  output  wire [7:0]                 o_load_weight_data_25_b_param,
  output  wire [7:0]                 o_load_weight_data_25_c_param,
  output  wire [7:0]                 o_load_weight_data_25_d_param,

  output  wire [7:0]                 o_load_weight_data_26_a_param,
  output  wire [7:0]                 o_load_weight_data_26_b_param,
  output  wire [7:0]                 o_load_weight_data_26_c_param,
  output  wire [7:0]                 o_load_weight_data_26_d_param,

  output  wire [7:0]                 o_load_weight_data_27_a_param,
  output  wire [7:0]                 o_load_weight_data_27_b_param,
  output  wire [7:0]                 o_load_weight_data_27_c_param,
  output  wire [7:0]                 o_load_weight_data_27_d_param,

  output  wire [7:0]                 o_load_weight_data_28_a_param,
  output  wire [7:0]                 o_load_weight_data_28_b_param,
  output  wire [7:0]                 o_load_weight_data_28_c_param,
  output  wire [7:0]                 o_load_weight_data_28_d_param,

  output  wire [7:0]                 o_load_weight_data_29_a_param,
  output  wire [7:0]                 o_load_weight_data_29_b_param,
  output  wire [7:0]                 o_load_weight_data_29_c_param,
  output  wire [7:0]                 o_load_weight_data_29_d_param,

  output  wire [7:0]                 o_load_weight_data_30_a_param,
  output  wire [7:0]                 o_load_weight_data_30_b_param,
  output  wire [7:0]                 o_load_weight_data_30_c_param,
  output  wire [7:0]                 o_load_weight_data_30_d_param,

  output  wire [7:0]                 o_load_weight_data_31_a_param,
  output  wire [7:0]                 o_load_weight_data_31_b_param,
  output  wire [7:0]                 o_load_weight_data_31_c_param,
  output  wire [7:0]                 o_load_weight_data_31_d_param


);

  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_0_o,  mac_acc_0_b_0_o,  mac_acc_0_c_0_o,  mac_acc_0_d_0_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_1_o,  mac_acc_0_b_1_o,  mac_acc_0_c_1_o,  mac_acc_0_d_1_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_2_o,  mac_acc_0_b_2_o,  mac_acc_0_c_2_o,  mac_acc_0_d_2_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_3_o,  mac_acc_0_b_3_o,  mac_acc_0_c_3_o,  mac_acc_0_d_3_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_4_o,  mac_acc_0_b_4_o,  mac_acc_0_c_4_o,  mac_acc_0_d_4_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_5_o,  mac_acc_0_b_5_o,  mac_acc_0_c_5_o,  mac_acc_0_d_5_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_6_o,  mac_acc_0_b_6_o,  mac_acc_0_c_6_o,  mac_acc_0_d_6_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_7_o,  mac_acc_0_b_7_o,  mac_acc_0_c_7_o,  mac_acc_0_d_7_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_8_o,  mac_acc_0_b_8_o,  mac_acc_0_c_8_o,  mac_acc_0_d_8_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_9_o,  mac_acc_0_b_9_o,  mac_acc_0_c_9_o,  mac_acc_0_d_9_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_10_o, mac_acc_0_b_10_o, mac_acc_0_c_10_o, mac_acc_0_d_10_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_11_o, mac_acc_0_b_11_o, mac_acc_0_c_11_o, mac_acc_0_d_11_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_12_o, mac_acc_0_b_12_o, mac_acc_0_c_12_o, mac_acc_0_d_12_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_13_o, mac_acc_0_b_13_o, mac_acc_0_c_13_o, mac_acc_0_d_13_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_14_o, mac_acc_0_b_14_o, mac_acc_0_c_14_o, mac_acc_0_d_14_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_0_a_15_o, mac_acc_0_b_15_o, mac_acc_0_c_15_o, mac_acc_0_d_15_o;
  
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_0_o,  mac_acc_1_b_0_o,  mac_acc_1_c_0_o,  mac_acc_1_d_0_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_1_o,  mac_acc_1_b_1_o,  mac_acc_1_c_1_o,  mac_acc_1_d_1_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_2_o,  mac_acc_1_b_2_o,  mac_acc_1_c_2_o,  mac_acc_1_d_2_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_3_o,  mac_acc_1_b_3_o,  mac_acc_1_c_3_o,  mac_acc_1_d_3_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_4_o,  mac_acc_1_b_4_o,  mac_acc_1_c_4_o,  mac_acc_1_d_4_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_5_o,  mac_acc_1_b_5_o,  mac_acc_1_c_5_o,  mac_acc_1_d_5_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_6_o,  mac_acc_1_b_6_o,  mac_acc_1_c_6_o,  mac_acc_1_d_6_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_7_o,  mac_acc_1_b_7_o,  mac_acc_1_c_7_o,  mac_acc_1_d_7_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_8_o,  mac_acc_1_b_8_o,  mac_acc_1_c_8_o,  mac_acc_1_d_8_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_9_o,  mac_acc_1_b_9_o,  mac_acc_1_c_9_o,  mac_acc_1_d_9_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_10_o, mac_acc_1_b_10_o, mac_acc_1_c_10_o, mac_acc_1_d_10_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_11_o, mac_acc_1_b_11_o, mac_acc_1_c_11_o, mac_acc_1_d_11_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_12_o, mac_acc_1_b_12_o, mac_acc_1_c_12_o, mac_acc_1_d_12_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_13_o, mac_acc_1_b_13_o, mac_acc_1_c_13_o, mac_acc_1_d_13_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_14_o, mac_acc_1_b_14_o, mac_acc_1_c_14_o, mac_acc_1_d_14_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_1_a_15_o, mac_acc_1_b_15_o, mac_acc_1_c_15_o, mac_acc_1_d_15_o;
  
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_0_o,  mac_acc_2_b_0_o,  mac_acc_2_c_0_o,  mac_acc_2_d_0_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_1_o,  mac_acc_2_b_1_o,  mac_acc_2_c_1_o,  mac_acc_2_d_1_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_2_o,  mac_acc_2_b_2_o,  mac_acc_2_c_2_o,  mac_acc_2_d_2_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_3_o,  mac_acc_2_b_3_o,  mac_acc_2_c_3_o,  mac_acc_2_d_3_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_4_o,  mac_acc_2_b_4_o,  mac_acc_2_c_4_o,  mac_acc_2_d_4_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_5_o,  mac_acc_2_b_5_o,  mac_acc_2_c_5_o,  mac_acc_2_d_5_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_6_o,  mac_acc_2_b_6_o,  mac_acc_2_c_6_o,  mac_acc_2_d_6_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_7_o,  mac_acc_2_b_7_o,  mac_acc_2_c_7_o,  mac_acc_2_d_7_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_8_o,  mac_acc_2_b_8_o,  mac_acc_2_c_8_o,  mac_acc_2_d_8_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_9_o,  mac_acc_2_b_9_o,  mac_acc_2_c_9_o,  mac_acc_2_d_9_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_10_o, mac_acc_2_b_10_o, mac_acc_2_c_10_o, mac_acc_2_d_10_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_11_o, mac_acc_2_b_11_o, mac_acc_2_c_11_o, mac_acc_2_d_11_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_12_o, mac_acc_2_b_12_o, mac_acc_2_c_12_o, mac_acc_2_d_12_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_13_o, mac_acc_2_b_13_o, mac_acc_2_c_13_o, mac_acc_2_d_13_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_14_o, mac_acc_2_b_14_o, mac_acc_2_c_14_o, mac_acc_2_d_14_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_2_a_15_o, mac_acc_2_b_15_o, mac_acc_2_c_15_o, mac_acc_2_d_15_o;

  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_0_o,  mac_acc_3_b_0_o,  mac_acc_3_c_0_o,  mac_acc_3_d_0_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_1_o,  mac_acc_3_b_1_o,  mac_acc_3_c_1_o,  mac_acc_3_d_1_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_2_o,  mac_acc_3_b_2_o,  mac_acc_3_c_2_o,  mac_acc_3_d_2_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_3_o,  mac_acc_3_b_3_o,  mac_acc_3_c_3_o,  mac_acc_3_d_3_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_4_o,  mac_acc_3_b_4_o,  mac_acc_3_c_4_o,  mac_acc_3_d_4_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_5_o,  mac_acc_3_b_5_o,  mac_acc_3_c_5_o,  mac_acc_3_d_5_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_6_o,  mac_acc_3_b_6_o,  mac_acc_3_c_6_o,  mac_acc_3_d_6_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_7_o,  mac_acc_3_b_7_o,  mac_acc_3_c_7_o,  mac_acc_3_d_7_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_8_o,  mac_acc_3_b_8_o,  mac_acc_3_c_8_o,  mac_acc_3_d_8_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_9_o,  mac_acc_3_b_9_o,  mac_acc_3_c_9_o,  mac_acc_3_d_9_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_10_o, mac_acc_3_b_10_o, mac_acc_3_c_10_o, mac_acc_3_d_10_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_11_o, mac_acc_3_b_11_o, mac_acc_3_c_11_o, mac_acc_3_d_11_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_12_o, mac_acc_3_b_12_o, mac_acc_3_c_12_o, mac_acc_3_d_12_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_13_o, mac_acc_3_b_13_o, mac_acc_3_c_13_o, mac_acc_3_d_13_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_14_o, mac_acc_3_b_14_o, mac_acc_3_c_14_o, mac_acc_3_d_14_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_3_a_15_o, mac_acc_3_b_15_o, mac_acc_3_c_15_o, mac_acc_3_d_15_o;
  
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_0_o,  mac_acc_4_b_0_o,  mac_acc_4_c_0_o,  mac_acc_4_d_0_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_1_o,  mac_acc_4_b_1_o,  mac_acc_4_c_1_o,  mac_acc_4_d_1_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_2_o,  mac_acc_4_b_2_o,  mac_acc_4_c_2_o,  mac_acc_4_d_2_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_3_o,  mac_acc_4_b_3_o,  mac_acc_4_c_3_o,  mac_acc_4_d_3_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_4_o,  mac_acc_4_b_4_o,  mac_acc_4_c_4_o,  mac_acc_4_d_4_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_5_o,  mac_acc_4_b_5_o,  mac_acc_4_c_5_o,  mac_acc_4_d_5_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_6_o,  mac_acc_4_b_6_o,  mac_acc_4_c_6_o,  mac_acc_4_d_6_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_7_o,  mac_acc_4_b_7_o,  mac_acc_4_c_7_o,  mac_acc_4_d_7_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_8_o,  mac_acc_4_b_8_o,  mac_acc_4_c_8_o,  mac_acc_4_d_8_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_9_o,  mac_acc_4_b_9_o,  mac_acc_4_c_9_o,  mac_acc_4_d_9_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_10_o, mac_acc_4_b_10_o, mac_acc_4_c_10_o, mac_acc_4_d_10_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_11_o, mac_acc_4_b_11_o, mac_acc_4_c_11_o, mac_acc_4_d_11_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_12_o, mac_acc_4_b_12_o, mac_acc_4_c_12_o, mac_acc_4_d_12_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_13_o, mac_acc_4_b_13_o, mac_acc_4_c_13_o, mac_acc_4_d_13_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_14_o, mac_acc_4_b_14_o, mac_acc_4_c_14_o, mac_acc_4_d_14_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_4_a_15_o, mac_acc_4_b_15_o, mac_acc_4_c_15_o, mac_acc_4_d_15_o;
  
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_0_o,  mac_acc_5_b_0_o,  mac_acc_5_c_0_o,  mac_acc_5_d_0_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_1_o,  mac_acc_5_b_1_o,  mac_acc_5_c_1_o,  mac_acc_5_d_1_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_2_o,  mac_acc_5_b_2_o,  mac_acc_5_c_2_o,  mac_acc_5_d_2_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_3_o,  mac_acc_5_b_3_o,  mac_acc_5_c_3_o,  mac_acc_5_d_3_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_4_o,  mac_acc_5_b_4_o,  mac_acc_5_c_4_o,  mac_acc_5_d_4_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_5_o,  mac_acc_5_b_5_o,  mac_acc_5_c_5_o,  mac_acc_5_d_5_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_6_o,  mac_acc_5_b_6_o,  mac_acc_5_c_6_o,  mac_acc_5_d_6_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_7_o,  mac_acc_5_b_7_o,  mac_acc_5_c_7_o,  mac_acc_5_d_7_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_8_o,  mac_acc_5_b_8_o,  mac_acc_5_c_8_o,  mac_acc_5_d_8_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_9_o,  mac_acc_5_b_9_o,  mac_acc_5_c_9_o,  mac_acc_5_d_9_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_10_o, mac_acc_5_b_10_o, mac_acc_5_c_10_o, mac_acc_5_d_10_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_11_o, mac_acc_5_b_11_o, mac_acc_5_c_11_o, mac_acc_5_d_11_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_12_o, mac_acc_5_b_12_o, mac_acc_5_c_12_o, mac_acc_5_d_12_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_13_o, mac_acc_5_b_13_o, mac_acc_5_c_13_o, mac_acc_5_d_13_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_14_o, mac_acc_5_b_14_o, mac_acc_5_c_14_o, mac_acc_5_d_14_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_5_a_15_o, mac_acc_5_b_15_o, mac_acc_5_c_15_o, mac_acc_5_d_15_o;
  
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_0_o,  mac_acc_6_b_0_o,  mac_acc_6_c_0_o,  mac_acc_6_d_0_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_1_o,  mac_acc_6_b_1_o,  mac_acc_6_c_1_o,  mac_acc_6_d_1_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_2_o,  mac_acc_6_b_2_o,  mac_acc_6_c_2_o,  mac_acc_6_d_2_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_3_o,  mac_acc_6_b_3_o,  mac_acc_6_c_3_o,  mac_acc_6_d_3_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_4_o,  mac_acc_6_b_4_o,  mac_acc_6_c_4_o,  mac_acc_6_d_4_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_5_o,  mac_acc_6_b_5_o,  mac_acc_6_c_5_o,  mac_acc_6_d_5_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_6_o,  mac_acc_6_b_6_o,  mac_acc_6_c_6_o,  mac_acc_6_d_6_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_7_o,  mac_acc_6_b_7_o,  mac_acc_6_c_7_o,  mac_acc_6_d_7_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_8_o,  mac_acc_6_b_8_o,  mac_acc_6_c_8_o,  mac_acc_6_d_8_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_9_o,  mac_acc_6_b_9_o,  mac_acc_6_c_9_o,  mac_acc_6_d_9_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_10_o, mac_acc_6_b_10_o, mac_acc_6_c_10_o, mac_acc_6_d_10_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_11_o, mac_acc_6_b_11_o, mac_acc_6_c_11_o, mac_acc_6_d_11_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_12_o, mac_acc_6_b_12_o, mac_acc_6_c_12_o, mac_acc_6_d_12_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_13_o, mac_acc_6_b_13_o, mac_acc_6_c_13_o, mac_acc_6_d_13_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_14_o, mac_acc_6_b_14_o, mac_acc_6_c_14_o, mac_acc_6_d_14_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_6_a_15_o, mac_acc_6_b_15_o, mac_acc_6_c_15_o, mac_acc_6_d_15_o;

  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_0_o,  mac_acc_7_b_0_o,  mac_acc_7_c_0_o,  mac_acc_7_d_0_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_1_o,  mac_acc_7_b_1_o,  mac_acc_7_c_1_o,  mac_acc_7_d_1_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_2_o,  mac_acc_7_b_2_o,  mac_acc_7_c_2_o,  mac_acc_7_d_2_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_3_o,  mac_acc_7_b_3_o,  mac_acc_7_c_3_o,  mac_acc_7_d_3_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_4_o,  mac_acc_7_b_4_o,  mac_acc_7_c_4_o,  mac_acc_7_d_4_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_5_o,  mac_acc_7_b_5_o,  mac_acc_7_c_5_o,  mac_acc_7_d_5_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_6_o,  mac_acc_7_b_6_o,  mac_acc_7_c_6_o,  mac_acc_7_d_6_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_7_o,  mac_acc_7_b_7_o,  mac_acc_7_c_7_o,  mac_acc_7_d_7_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_8_o,  mac_acc_7_b_8_o,  mac_acc_7_c_8_o,  mac_acc_7_d_8_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_9_o,  mac_acc_7_b_9_o,  mac_acc_7_c_9_o,  mac_acc_7_d_9_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_10_o, mac_acc_7_b_10_o, mac_acc_7_c_10_o, mac_acc_7_d_10_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_11_o, mac_acc_7_b_11_o, mac_acc_7_c_11_o, mac_acc_7_d_11_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_12_o, mac_acc_7_b_12_o, mac_acc_7_c_12_o, mac_acc_7_d_12_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_13_o, mac_acc_7_b_13_o, mac_acc_7_c_13_o, mac_acc_7_d_13_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_14_o, mac_acc_7_b_14_o, mac_acc_7_c_14_o, mac_acc_7_d_14_o;
  wire [MAC_ACC_WIDTH-1:0] mac_acc_7_a_15_o, mac_acc_7_b_15_o, mac_acc_7_c_15_o, mac_acc_7_d_15_o;
  
  wire [QUNATIZED_MANTISSA_WIDTH*4-1:0] 
    buffer_data_0_i, buffer_data_1_i, buffer_data_2_i, buffer_data_3_i,
    buffer_data_4_i, buffer_data_5_i, buffer_data_6_i, buffer_data_7_i;
  wire [EXPONENT_WIDTH-1:0] buffer_exponent_i;
  
  wire [BUFFER_ADDR_WIDTH-1:0] 
    buffer_rd_addr_0_o, buffer_rd_addr_1_o, buffer_rd_addr_2_o, buffer_rd_addr_3_o,
    buffer_rd_addr_4_o, buffer_rd_addr_5_o, buffer_rd_addr_6_o, buffer_rd_addr_7_o;
  
  wire set_weight_0_o, set_weight_1_o, set_weight_2_o, set_weight_3_o;
  wire set_weight_4_o, set_weight_5_o, set_weight_6_o, set_weight_7_o;
  
  wire buffer_rd_en_0_o, buffer_rd_en_1_o, buffer_rd_en_2_o, buffer_rd_en_3_o;
  wire buffer_rd_en_4_o, buffer_rd_en_5_o, buffer_rd_en_6_o, buffer_rd_en_7_o;

  //mac array output 
  wire [ACCUM_DATA_WIDTH-1:0] mac_acc_0_o,  mac_acc_1_o,  mac_acc_2_o,  mac_acc_3_o;
  wire [ACCUM_DATA_WIDTH-1:0] mac_acc_4_o,  mac_acc_5_o,  mac_acc_6_o,  mac_acc_7_o;
  wire [ACCUM_DATA_WIDTH-1:0] mac_acc_8_o,  mac_acc_9_o,  mac_acc_10_o, mac_acc_11_o; 
  wire [ACCUM_DATA_WIDTH-1:0] mac_acc_12_o, mac_acc_13_o, mac_acc_14_o, mac_acc_15_o;
  wire [ACCUM_DATA_WIDTH-1:0] mac_acc_16_o, mac_acc_17_o, mac_acc_18_o, mac_acc_19_o;
  wire [ACCUM_DATA_WIDTH-1:0] mac_acc_20_o, mac_acc_21_o, mac_acc_22_o, mac_acc_23_o;
  wire [ACCUM_DATA_WIDTH-1:0] mac_acc_24_o, mac_acc_25_o, mac_acc_26_o, mac_acc_27_o;
  wire [ACCUM_DATA_WIDTH-1:0] mac_acc_28_o, mac_acc_29_o, mac_acc_30_o, mac_acc_31_o;

  //select load from ddr / write back
  assign buffer_data_0_i = select_wb ? {execute_write_back_data_0_i, execute_write_back_data_1_i, execute_write_back_data_2_i, execute_write_back_data_3_i} 
        : {execute_load_data_0_i, execute_load_data_1_i, execute_load_data_2_i, execute_load_data_3_i};
  assign buffer_data_1_i = select_wb ? {execute_write_back_data_4_i, execute_write_back_data_5_i, execute_write_back_data_6_i, execute_write_back_data_7_i} 
        : {execute_load_data_4_i, execute_load_data_5_i, execute_load_data_6_i, execute_load_data_7_i};
  assign buffer_data_2_i = select_wb ? {execute_write_back_data_8_i, execute_write_back_data_9_i, execute_write_back_data_10_i, execute_write_back_data_11_i} 
        : {execute_load_data_8_i, execute_load_data_9_i, execute_load_data_10_i, execute_load_data_11_i};
  assign buffer_data_3_i = select_wb ? {execute_write_back_data_12_i, execute_write_back_data_13_i, execute_write_back_data_14_i, execute_write_back_data_15_i} 
        : {execute_load_data_12_i, execute_load_data_13_i, execute_load_data_14_i, execute_load_data_15_i};
  assign buffer_data_4_i = select_wb ? {execute_write_back_data_16_i, execute_write_back_data_17_i, execute_write_back_data_18_i, execute_write_back_data_19_i} 
        : {execute_load_data_16_i, execute_load_data_17_i, execute_load_data_18_i, execute_load_data_19_i};
  assign buffer_data_5_i = select_wb ? {execute_write_back_data_20_i, execute_write_back_data_21_i, execute_write_back_data_22_i, execute_write_back_data_23_i} 
        : {execute_load_data_20_i, execute_load_data_21_i, execute_load_data_22_i, execute_load_data_23_i};
  assign buffer_data_6_i = select_wb ? {execute_write_back_data_24_i, execute_write_back_data_25_i, execute_write_back_data_26_i, execute_write_back_data_27_i} 
        : {execute_load_data_24_i, execute_load_data_25_i, execute_load_data_26_i, execute_load_data_27_i};
  assign buffer_data_7_i = select_wb ? {execute_write_back_data_28_i, execute_write_back_data_29_i, execute_write_back_data_30_i, execute_write_back_data_31_i} 
        : {execute_load_data_28_i, execute_load_data_29_i, execute_load_data_30_i, execute_load_data_31_i};
  assign buffer_exponent_i = select_wb ? write_back_exponent_i : load_exponent_i;

  //Load Weight Data
  wire [7:0] load_weight_data_0_a_0;
  wire [7:0] load_weight_data_0_a_1;
  wire [7:0] load_weight_data_0_a_2;
  wire [7:0] load_weight_data_0_a_3;
  wire [7:0] load_weight_data_0_a_4;
  wire [7:0] load_weight_data_0_a_5;
  wire [7:0] load_weight_data_0_a_6;
  wire [7:0] load_weight_data_0_a_7;
  wire [7:0] load_weight_data_0_a_expo;
  wire [7:0] load_weight_data_0_a_bias;

  wire [7:0] load_weight_data_0_b_0;
  wire [7:0] load_weight_data_0_b_1;
  wire [7:0] load_weight_data_0_b_2;
  wire [7:0] load_weight_data_0_b_3;
  wire [7:0] load_weight_data_0_b_4;
  wire [7:0] load_weight_data_0_b_5;
  wire [7:0] load_weight_data_0_b_6;
  wire [7:0] load_weight_data_0_b_7;
  wire [7:0] load_weight_data_0_b_expo;
  wire [7:0] load_weight_data_0_b_bias;

  wire [7:0] load_weight_data_0_c_0;
  wire [7:0] load_weight_data_0_c_1;
  wire [7:0] load_weight_data_0_c_2;
  wire [7:0] load_weight_data_0_c_3;
  wire [7:0] load_weight_data_0_c_4;
  wire [7:0] load_weight_data_0_c_5;
  wire [7:0] load_weight_data_0_c_6;
  wire [7:0] load_weight_data_0_c_7;
  wire [7:0] load_weight_data_0_c_expo;
  wire [7:0] load_weight_data_0_c_bias;

  wire [7:0] load_weight_data_0_d_0;
  wire [7:0] load_weight_data_0_d_1;
  wire [7:0] load_weight_data_0_d_2;
  wire [7:0] load_weight_data_0_d_3;
  wire [7:0] load_weight_data_0_d_4;
  wire [7:0] load_weight_data_0_d_5;
  wire [7:0] load_weight_data_0_d_6;
  wire [7:0] load_weight_data_0_d_7;
  wire [7:0] load_weight_data_0_d_expo;
  wire [7:0] load_weight_data_0_d_bias;


  wire [7:0] load_weight_data_1_a_0;
  wire [7:0] load_weight_data_1_a_1;
  wire [7:0] load_weight_data_1_a_2;
  wire [7:0] load_weight_data_1_a_3;
  wire [7:0] load_weight_data_1_a_4;
  wire [7:0] load_weight_data_1_a_5;
  wire [7:0] load_weight_data_1_a_6;
  wire [7:0] load_weight_data_1_a_7;
  wire [7:0] load_weight_data_1_a_expo;
  wire [7:0] load_weight_data_1_a_bias;

  wire [7:0] load_weight_data_1_b_0;
  wire [7:0] load_weight_data_1_b_1;
  wire [7:0] load_weight_data_1_b_2;
  wire [7:0] load_weight_data_1_b_3;
  wire [7:0] load_weight_data_1_b_4;
  wire [7:0] load_weight_data_1_b_5;
  wire [7:0] load_weight_data_1_b_6;
  wire [7:0] load_weight_data_1_b_7;
  wire [7:0] load_weight_data_1_b_expo;
  wire [7:0] load_weight_data_1_b_bias;

  wire [7:0] load_weight_data_1_c_0;
  wire [7:0] load_weight_data_1_c_1;
  wire [7:0] load_weight_data_1_c_2;
  wire [7:0] load_weight_data_1_c_3;
  wire [7:0] load_weight_data_1_c_4;
  wire [7:0] load_weight_data_1_c_5;
  wire [7:0] load_weight_data_1_c_6;
  wire [7:0] load_weight_data_1_c_7;
  wire [7:0] load_weight_data_1_c_expo;
  wire [7:0] load_weight_data_1_c_bias;

  wire [7:0] load_weight_data_1_d_0;
  wire [7:0] load_weight_data_1_d_1;
  wire [7:0] load_weight_data_1_d_2;
  wire [7:0] load_weight_data_1_d_3;
  wire [7:0] load_weight_data_1_d_4;
  wire [7:0] load_weight_data_1_d_5;
  wire [7:0] load_weight_data_1_d_6;
  wire [7:0] load_weight_data_1_d_7;
  wire [7:0] load_weight_data_1_d_expo;
  wire [7:0] load_weight_data_1_d_bias;


  wire [7:0] load_weight_data_2_a_0;
  wire [7:0] load_weight_data_2_a_1;
  wire [7:0] load_weight_data_2_a_2;
  wire [7:0] load_weight_data_2_a_3;
  wire [7:0] load_weight_data_2_a_4;
  wire [7:0] load_weight_data_2_a_5;
  wire [7:0] load_weight_data_2_a_6;
  wire [7:0] load_weight_data_2_a_7;
  wire [7:0] load_weight_data_2_a_expo;
  wire [7:0] load_weight_data_2_a_bias;

  wire [7:0] load_weight_data_2_b_0;
  wire [7:0] load_weight_data_2_b_1;
  wire [7:0] load_weight_data_2_b_2;
  wire [7:0] load_weight_data_2_b_3;
  wire [7:0] load_weight_data_2_b_4;
  wire [7:0] load_weight_data_2_b_5;
  wire [7:0] load_weight_data_2_b_6;
  wire [7:0] load_weight_data_2_b_7;
  wire [7:0] load_weight_data_2_b_expo;
  wire [7:0] load_weight_data_2_b_bias;

  wire [7:0] load_weight_data_2_c_0;
  wire [7:0] load_weight_data_2_c_1;
  wire [7:0] load_weight_data_2_c_2;
  wire [7:0] load_weight_data_2_c_3;
  wire [7:0] load_weight_data_2_c_4;
  wire [7:0] load_weight_data_2_c_5;
  wire [7:0] load_weight_data_2_c_6;
  wire [7:0] load_weight_data_2_c_7;
  wire [7:0] load_weight_data_2_c_expo;
  wire [7:0] load_weight_data_2_c_bias;

  wire [7:0] load_weight_data_2_d_0;
  wire [7:0] load_weight_data_2_d_1;
  wire [7:0] load_weight_data_2_d_2;
  wire [7:0] load_weight_data_2_d_3;
  wire [7:0] load_weight_data_2_d_4;
  wire [7:0] load_weight_data_2_d_5;
  wire [7:0] load_weight_data_2_d_6;
  wire [7:0] load_weight_data_2_d_7;
  wire [7:0] load_weight_data_2_d_expo;
  wire [7:0] load_weight_data_2_d_bias;


  wire [7:0] load_weight_data_3_a_0;
  wire [7:0] load_weight_data_3_a_1;
  wire [7:0] load_weight_data_3_a_2;
  wire [7:0] load_weight_data_3_a_3;
  wire [7:0] load_weight_data_3_a_4;
  wire [7:0] load_weight_data_3_a_5;
  wire [7:0] load_weight_data_3_a_6;
  wire [7:0] load_weight_data_3_a_7;
  wire [7:0] load_weight_data_3_a_expo;
  wire [7:0] load_weight_data_3_a_bias;

  wire [7:0] load_weight_data_3_b_0;
  wire [7:0] load_weight_data_3_b_1;
  wire [7:0] load_weight_data_3_b_2;
  wire [7:0] load_weight_data_3_b_3;
  wire [7:0] load_weight_data_3_b_4;
  wire [7:0] load_weight_data_3_b_5;
  wire [7:0] load_weight_data_3_b_6;
  wire [7:0] load_weight_data_3_b_7;
  wire [7:0] load_weight_data_3_b_expo;
  wire [7:0] load_weight_data_3_b_bias;

  wire [7:0] load_weight_data_3_c_0;
  wire [7:0] load_weight_data_3_c_1;
  wire [7:0] load_weight_data_3_c_2;
  wire [7:0] load_weight_data_3_c_3;
  wire [7:0] load_weight_data_3_c_4;
  wire [7:0] load_weight_data_3_c_5;
  wire [7:0] load_weight_data_3_c_6;
  wire [7:0] load_weight_data_3_c_7;
  wire [7:0] load_weight_data_3_c_expo;
  wire [7:0] load_weight_data_3_c_bias;

  wire [7:0] load_weight_data_3_d_0;
  wire [7:0] load_weight_data_3_d_1;
  wire [7:0] load_weight_data_3_d_2;
  wire [7:0] load_weight_data_3_d_3;
  wire [7:0] load_weight_data_3_d_4;
  wire [7:0] load_weight_data_3_d_5;
  wire [7:0] load_weight_data_3_d_6;
  wire [7:0] load_weight_data_3_d_7;
  wire [7:0] load_weight_data_3_d_expo;
  wire [7:0] load_weight_data_3_d_bias;


  wire [7:0] load_weight_data_4_a_0;
  wire [7:0] load_weight_data_4_a_1;
  wire [7:0] load_weight_data_4_a_2;
  wire [7:0] load_weight_data_4_a_3;
  wire [7:0] load_weight_data_4_a_4;
  wire [7:0] load_weight_data_4_a_5;
  wire [7:0] load_weight_data_4_a_6;
  wire [7:0] load_weight_data_4_a_7;
  wire [7:0] load_weight_data_4_a_expo;
  wire [7:0] load_weight_data_4_a_bias;

  wire [7:0] load_weight_data_4_b_0;
  wire [7:0] load_weight_data_4_b_1;
  wire [7:0] load_weight_data_4_b_2;
  wire [7:0] load_weight_data_4_b_3;
  wire [7:0] load_weight_data_4_b_4;
  wire [7:0] load_weight_data_4_b_5;
  wire [7:0] load_weight_data_4_b_6;
  wire [7:0] load_weight_data_4_b_7;
  wire [7:0] load_weight_data_4_b_expo;
  wire [7:0] load_weight_data_4_b_bias;

  wire [7:0] load_weight_data_4_c_0;
  wire [7:0] load_weight_data_4_c_1;
  wire [7:0] load_weight_data_4_c_2;
  wire [7:0] load_weight_data_4_c_3;
  wire [7:0] load_weight_data_4_c_4;
  wire [7:0] load_weight_data_4_c_5;
  wire [7:0] load_weight_data_4_c_6;
  wire [7:0] load_weight_data_4_c_7;
  wire [7:0] load_weight_data_4_c_expo;
  wire [7:0] load_weight_data_4_c_bias;

  wire [7:0] load_weight_data_4_d_0;
  wire [7:0] load_weight_data_4_d_1;
  wire [7:0] load_weight_data_4_d_2;
  wire [7:0] load_weight_data_4_d_3;
  wire [7:0] load_weight_data_4_d_4;
  wire [7:0] load_weight_data_4_d_5;
  wire [7:0] load_weight_data_4_d_6;
  wire [7:0] load_weight_data_4_d_7;
  wire [7:0] load_weight_data_4_d_expo;
  wire [7:0] load_weight_data_4_d_bias;


  wire [7:0] load_weight_data_5_a_0;
  wire [7:0] load_weight_data_5_a_1;
  wire [7:0] load_weight_data_5_a_2;
  wire [7:0] load_weight_data_5_a_3;
  wire [7:0] load_weight_data_5_a_4;
  wire [7:0] load_weight_data_5_a_5;
  wire [7:0] load_weight_data_5_a_6;
  wire [7:0] load_weight_data_5_a_7;
  wire [7:0] load_weight_data_5_a_expo;
  wire [7:0] load_weight_data_5_a_bias;

  wire [7:0] load_weight_data_5_b_0;
  wire [7:0] load_weight_data_5_b_1;
  wire [7:0] load_weight_data_5_b_2;
  wire [7:0] load_weight_data_5_b_3;
  wire [7:0] load_weight_data_5_b_4;
  wire [7:0] load_weight_data_5_b_5;
  wire [7:0] load_weight_data_5_b_6;
  wire [7:0] load_weight_data_5_b_7;
  wire [7:0] load_weight_data_5_b_expo;
  wire [7:0] load_weight_data_5_b_bias;

  wire [7:0] load_weight_data_5_c_0;
  wire [7:0] load_weight_data_5_c_1;
  wire [7:0] load_weight_data_5_c_2;
  wire [7:0] load_weight_data_5_c_3;
  wire [7:0] load_weight_data_5_c_4;
  wire [7:0] load_weight_data_5_c_5;
  wire [7:0] load_weight_data_5_c_6;
  wire [7:0] load_weight_data_5_c_7;
  wire [7:0] load_weight_data_5_c_expo;
  wire [7:0] load_weight_data_5_c_bias;

  wire [7:0] load_weight_data_5_d_0;
  wire [7:0] load_weight_data_5_d_1;
  wire [7:0] load_weight_data_5_d_2;
  wire [7:0] load_weight_data_5_d_3;
  wire [7:0] load_weight_data_5_d_4;
  wire [7:0] load_weight_data_5_d_5;
  wire [7:0] load_weight_data_5_d_6;
  wire [7:0] load_weight_data_5_d_7;
  wire [7:0] load_weight_data_5_d_expo;
  wire [7:0] load_weight_data_5_d_bias;


  wire [7:0] load_weight_data_6_a_0;
  wire [7:0] load_weight_data_6_a_1;
  wire [7:0] load_weight_data_6_a_2;
  wire [7:0] load_weight_data_6_a_3;
  wire [7:0] load_weight_data_6_a_4;
  wire [7:0] load_weight_data_6_a_5;
  wire [7:0] load_weight_data_6_a_6;
  wire [7:0] load_weight_data_6_a_7;
  wire [7:0] load_weight_data_6_a_expo;
  wire [7:0] load_weight_data_6_a_bias;

  wire [7:0] load_weight_data_6_b_0;
  wire [7:0] load_weight_data_6_b_1;
  wire [7:0] load_weight_data_6_b_2;
  wire [7:0] load_weight_data_6_b_3;
  wire [7:0] load_weight_data_6_b_4;
  wire [7:0] load_weight_data_6_b_5;
  wire [7:0] load_weight_data_6_b_6;
  wire [7:0] load_weight_data_6_b_7;
  wire [7:0] load_weight_data_6_b_expo;
  wire [7:0] load_weight_data_6_b_bias;

  wire [7:0] load_weight_data_6_c_0;
  wire [7:0] load_weight_data_6_c_1;
  wire [7:0] load_weight_data_6_c_2;
  wire [7:0] load_weight_data_6_c_3;
  wire [7:0] load_weight_data_6_c_4;
  wire [7:0] load_weight_data_6_c_5;
  wire [7:0] load_weight_data_6_c_6;
  wire [7:0] load_weight_data_6_c_7;
  wire [7:0] load_weight_data_6_c_expo;
  wire [7:0] load_weight_data_6_c_bias;

  wire [7:0] load_weight_data_6_d_0;
  wire [7:0] load_weight_data_6_d_1;
  wire [7:0] load_weight_data_6_d_2;
  wire [7:0] load_weight_data_6_d_3;
  wire [7:0] load_weight_data_6_d_4;
  wire [7:0] load_weight_data_6_d_5;
  wire [7:0] load_weight_data_6_d_6;
  wire [7:0] load_weight_data_6_d_7;
  wire [7:0] load_weight_data_6_d_expo;
  wire [7:0] load_weight_data_6_d_bias;


  wire [7:0] load_weight_data_7_a_0;
  wire [7:0] load_weight_data_7_a_1;
  wire [7:0] load_weight_data_7_a_2;
  wire [7:0] load_weight_data_7_a_3;
  wire [7:0] load_weight_data_7_a_4;
  wire [7:0] load_weight_data_7_a_5;
  wire [7:0] load_weight_data_7_a_6;
  wire [7:0] load_weight_data_7_a_7;
  wire [7:0] load_weight_data_7_a_expo;
  wire [7:0] load_weight_data_7_a_bias;

  wire [7:0] load_weight_data_7_b_0;
  wire [7:0] load_weight_data_7_b_1;
  wire [7:0] load_weight_data_7_b_2;
  wire [7:0] load_weight_data_7_b_3;
  wire [7:0] load_weight_data_7_b_4;
  wire [7:0] load_weight_data_7_b_5;
  wire [7:0] load_weight_data_7_b_6;
  wire [7:0] load_weight_data_7_b_7;
  wire [7:0] load_weight_data_7_b_expo;
  wire [7:0] load_weight_data_7_b_bias;

  wire [7:0] load_weight_data_7_c_0;
  wire [7:0] load_weight_data_7_c_1;
  wire [7:0] load_weight_data_7_c_2;
  wire [7:0] load_weight_data_7_c_3;
  wire [7:0] load_weight_data_7_c_4;
  wire [7:0] load_weight_data_7_c_5;
  wire [7:0] load_weight_data_7_c_6;
  wire [7:0] load_weight_data_7_c_7;
  wire [7:0] load_weight_data_7_c_expo;
  wire [7:0] load_weight_data_7_c_bias;

  wire [7:0] load_weight_data_7_d_0;
  wire [7:0] load_weight_data_7_d_1;
  wire [7:0] load_weight_data_7_d_2;
  wire [7:0] load_weight_data_7_d_3;
  wire [7:0] load_weight_data_7_d_4;
  wire [7:0] load_weight_data_7_d_5;
  wire [7:0] load_weight_data_7_d_6;
  wire [7:0] load_weight_data_7_d_7;
  wire [7:0] load_weight_data_7_d_expo;
  wire [7:0] load_weight_data_7_d_bias;


  wire [7:0] load_weight_data_8_a_0;
  wire [7:0] load_weight_data_8_a_1;
  wire [7:0] load_weight_data_8_a_2;
  wire [7:0] load_weight_data_8_a_3;
  wire [7:0] load_weight_data_8_a_4;
  wire [7:0] load_weight_data_8_a_5;
  wire [7:0] load_weight_data_8_a_6;
  wire [7:0] load_weight_data_8_a_7;
  wire [7:0] load_weight_data_8_a_expo;
  wire [7:0] load_weight_data_8_a_bias;

  wire [7:0] load_weight_data_8_b_0;
  wire [7:0] load_weight_data_8_b_1;
  wire [7:0] load_weight_data_8_b_2;
  wire [7:0] load_weight_data_8_b_3;
  wire [7:0] load_weight_data_8_b_4;
  wire [7:0] load_weight_data_8_b_5;
  wire [7:0] load_weight_data_8_b_6;
  wire [7:0] load_weight_data_8_b_7;
  wire [7:0] load_weight_data_8_b_expo;
  wire [7:0] load_weight_data_8_b_bias;

  wire [7:0] load_weight_data_8_c_0;
  wire [7:0] load_weight_data_8_c_1;
  wire [7:0] load_weight_data_8_c_2;
  wire [7:0] load_weight_data_8_c_3;
  wire [7:0] load_weight_data_8_c_4;
  wire [7:0] load_weight_data_8_c_5;
  wire [7:0] load_weight_data_8_c_6;
  wire [7:0] load_weight_data_8_c_7;
  wire [7:0] load_weight_data_8_c_expo;
  wire [7:0] load_weight_data_8_c_bias;

  wire [7:0] load_weight_data_8_d_0;
  wire [7:0] load_weight_data_8_d_1;
  wire [7:0] load_weight_data_8_d_2;
  wire [7:0] load_weight_data_8_d_3;
  wire [7:0] load_weight_data_8_d_4;
  wire [7:0] load_weight_data_8_d_5;
  wire [7:0] load_weight_data_8_d_6;
  wire [7:0] load_weight_data_8_d_7;
  wire [7:0] load_weight_data_8_d_expo;
  wire [7:0] load_weight_data_8_d_bias;


  wire [7:0] load_weight_data_9_a_0;
  wire [7:0] load_weight_data_9_a_1;
  wire [7:0] load_weight_data_9_a_2;
  wire [7:0] load_weight_data_9_a_3;
  wire [7:0] load_weight_data_9_a_4;
  wire [7:0] load_weight_data_9_a_5;
  wire [7:0] load_weight_data_9_a_6;
  wire [7:0] load_weight_data_9_a_7;
  wire [7:0] load_weight_data_9_a_expo;
  wire [7:0] load_weight_data_9_a_bias;

  wire [7:0] load_weight_data_9_b_0;
  wire [7:0] load_weight_data_9_b_1;
  wire [7:0] load_weight_data_9_b_2;
  wire [7:0] load_weight_data_9_b_3;
  wire [7:0] load_weight_data_9_b_4;
  wire [7:0] load_weight_data_9_b_5;
  wire [7:0] load_weight_data_9_b_6;
  wire [7:0] load_weight_data_9_b_7;
  wire [7:0] load_weight_data_9_b_expo;
  wire [7:0] load_weight_data_9_b_bias;

  wire [7:0] load_weight_data_9_c_0;
  wire [7:0] load_weight_data_9_c_1;
  wire [7:0] load_weight_data_9_c_2;
  wire [7:0] load_weight_data_9_c_3;
  wire [7:0] load_weight_data_9_c_4;
  wire [7:0] load_weight_data_9_c_5;
  wire [7:0] load_weight_data_9_c_6;
  wire [7:0] load_weight_data_9_c_7;
  wire [7:0] load_weight_data_9_c_expo;
  wire [7:0] load_weight_data_9_c_bias;

  wire [7:0] load_weight_data_9_d_0;
  wire [7:0] load_weight_data_9_d_1;
  wire [7:0] load_weight_data_9_d_2;
  wire [7:0] load_weight_data_9_d_3;
  wire [7:0] load_weight_data_9_d_4;
  wire [7:0] load_weight_data_9_d_5;
  wire [7:0] load_weight_data_9_d_6;
  wire [7:0] load_weight_data_9_d_7;
  wire [7:0] load_weight_data_9_d_expo;
  wire [7:0] load_weight_data_9_d_bias;


  wire [7:0] load_weight_data_10_a_0;
  wire [7:0] load_weight_data_10_a_1;
  wire [7:0] load_weight_data_10_a_2;
  wire [7:0] load_weight_data_10_a_3;
  wire [7:0] load_weight_data_10_a_4;
  wire [7:0] load_weight_data_10_a_5;
  wire [7:0] load_weight_data_10_a_6;
  wire [7:0] load_weight_data_10_a_7;
  wire [7:0] load_weight_data_10_a_expo;
  wire [7:0] load_weight_data_10_a_bias;

  wire [7:0] load_weight_data_10_b_0;
  wire [7:0] load_weight_data_10_b_1;
  wire [7:0] load_weight_data_10_b_2;
  wire [7:0] load_weight_data_10_b_3;
  wire [7:0] load_weight_data_10_b_4;
  wire [7:0] load_weight_data_10_b_5;
  wire [7:0] load_weight_data_10_b_6;
  wire [7:0] load_weight_data_10_b_7;
  wire [7:0] load_weight_data_10_b_expo;
  wire [7:0] load_weight_data_10_b_bias;

  wire [7:0] load_weight_data_10_c_0;
  wire [7:0] load_weight_data_10_c_1;
  wire [7:0] load_weight_data_10_c_2;
  wire [7:0] load_weight_data_10_c_3;
  wire [7:0] load_weight_data_10_c_4;
  wire [7:0] load_weight_data_10_c_5;
  wire [7:0] load_weight_data_10_c_6;
  wire [7:0] load_weight_data_10_c_7;
  wire [7:0] load_weight_data_10_c_expo;
  wire [7:0] load_weight_data_10_c_bias;

  wire [7:0] load_weight_data_10_d_0;
  wire [7:0] load_weight_data_10_d_1;
  wire [7:0] load_weight_data_10_d_2;
  wire [7:0] load_weight_data_10_d_3;
  wire [7:0] load_weight_data_10_d_4;
  wire [7:0] load_weight_data_10_d_5;
  wire [7:0] load_weight_data_10_d_6;
  wire [7:0] load_weight_data_10_d_7;
  wire [7:0] load_weight_data_10_d_expo;
  wire [7:0] load_weight_data_10_d_bias;


  wire [7:0] load_weight_data_11_a_0;
  wire [7:0] load_weight_data_11_a_1;
  wire [7:0] load_weight_data_11_a_2;
  wire [7:0] load_weight_data_11_a_3;
  wire [7:0] load_weight_data_11_a_4;
  wire [7:0] load_weight_data_11_a_5;
  wire [7:0] load_weight_data_11_a_6;
  wire [7:0] load_weight_data_11_a_7;
  wire [7:0] load_weight_data_11_a_expo;
  wire [7:0] load_weight_data_11_a_bias;

  wire [7:0] load_weight_data_11_b_0;
  wire [7:0] load_weight_data_11_b_1;
  wire [7:0] load_weight_data_11_b_2;
  wire [7:0] load_weight_data_11_b_3;
  wire [7:0] load_weight_data_11_b_4;
  wire [7:0] load_weight_data_11_b_5;
  wire [7:0] load_weight_data_11_b_6;
  wire [7:0] load_weight_data_11_b_7;
  wire [7:0] load_weight_data_11_b_expo;
  wire [7:0] load_weight_data_11_b_bias;

  wire [7:0] load_weight_data_11_c_0;
  wire [7:0] load_weight_data_11_c_1;
  wire [7:0] load_weight_data_11_c_2;
  wire [7:0] load_weight_data_11_c_3;
  wire [7:0] load_weight_data_11_c_4;
  wire [7:0] load_weight_data_11_c_5;
  wire [7:0] load_weight_data_11_c_6;
  wire [7:0] load_weight_data_11_c_7;
  wire [7:0] load_weight_data_11_c_expo;
  wire [7:0] load_weight_data_11_c_bias;

  wire [7:0] load_weight_data_11_d_0;
  wire [7:0] load_weight_data_11_d_1;
  wire [7:0] load_weight_data_11_d_2;
  wire [7:0] load_weight_data_11_d_3;
  wire [7:0] load_weight_data_11_d_4;
  wire [7:0] load_weight_data_11_d_5;
  wire [7:0] load_weight_data_11_d_6;
  wire [7:0] load_weight_data_11_d_7;
  wire [7:0] load_weight_data_11_d_expo;
  wire [7:0] load_weight_data_11_d_bias;


  wire [7:0] load_weight_data_12_a_0;
  wire [7:0] load_weight_data_12_a_1;
  wire [7:0] load_weight_data_12_a_2;
  wire [7:0] load_weight_data_12_a_3;
  wire [7:0] load_weight_data_12_a_4;
  wire [7:0] load_weight_data_12_a_5;
  wire [7:0] load_weight_data_12_a_6;
  wire [7:0] load_weight_data_12_a_7;
  wire [7:0] load_weight_data_12_a_expo;
  wire [7:0] load_weight_data_12_a_bias;

  wire [7:0] load_weight_data_12_b_0;
  wire [7:0] load_weight_data_12_b_1;
  wire [7:0] load_weight_data_12_b_2;
  wire [7:0] load_weight_data_12_b_3;
  wire [7:0] load_weight_data_12_b_4;
  wire [7:0] load_weight_data_12_b_5;
  wire [7:0] load_weight_data_12_b_6;
  wire [7:0] load_weight_data_12_b_7;
  wire [7:0] load_weight_data_12_b_expo;
  wire [7:0] load_weight_data_12_b_bias;

  wire [7:0] load_weight_data_12_c_0;
  wire [7:0] load_weight_data_12_c_1;
  wire [7:0] load_weight_data_12_c_2;
  wire [7:0] load_weight_data_12_c_3;
  wire [7:0] load_weight_data_12_c_4;
  wire [7:0] load_weight_data_12_c_5;
  wire [7:0] load_weight_data_12_c_6;
  wire [7:0] load_weight_data_12_c_7;
  wire [7:0] load_weight_data_12_c_expo;
  wire [7:0] load_weight_data_12_c_bias;

  wire [7:0] load_weight_data_12_d_0;
  wire [7:0] load_weight_data_12_d_1;
  wire [7:0] load_weight_data_12_d_2;
  wire [7:0] load_weight_data_12_d_3;
  wire [7:0] load_weight_data_12_d_4;
  wire [7:0] load_weight_data_12_d_5;
  wire [7:0] load_weight_data_12_d_6;
  wire [7:0] load_weight_data_12_d_7;
  wire [7:0] load_weight_data_12_d_expo;
  wire [7:0] load_weight_data_12_d_bias;


  wire [7:0] load_weight_data_13_a_0;
  wire [7:0] load_weight_data_13_a_1;
  wire [7:0] load_weight_data_13_a_2;
  wire [7:0] load_weight_data_13_a_3;
  wire [7:0] load_weight_data_13_a_4;
  wire [7:0] load_weight_data_13_a_5;
  wire [7:0] load_weight_data_13_a_6;
  wire [7:0] load_weight_data_13_a_7;
  wire [7:0] load_weight_data_13_a_expo;
  wire [7:0] load_weight_data_13_a_bias;

  wire [7:0] load_weight_data_13_b_0;
  wire [7:0] load_weight_data_13_b_1;
  wire [7:0] load_weight_data_13_b_2;
  wire [7:0] load_weight_data_13_b_3;
  wire [7:0] load_weight_data_13_b_4;
  wire [7:0] load_weight_data_13_b_5;
  wire [7:0] load_weight_data_13_b_6;
  wire [7:0] load_weight_data_13_b_7;
  wire [7:0] load_weight_data_13_b_expo;
  wire [7:0] load_weight_data_13_b_bias;

  wire [7:0] load_weight_data_13_c_0;
  wire [7:0] load_weight_data_13_c_1;
  wire [7:0] load_weight_data_13_c_2;
  wire [7:0] load_weight_data_13_c_3;
  wire [7:0] load_weight_data_13_c_4;
  wire [7:0] load_weight_data_13_c_5;
  wire [7:0] load_weight_data_13_c_6;
  wire [7:0] load_weight_data_13_c_7;
  wire [7:0] load_weight_data_13_c_expo;
  wire [7:0] load_weight_data_13_c_bias;

  wire [7:0] load_weight_data_13_d_0;
  wire [7:0] load_weight_data_13_d_1;
  wire [7:0] load_weight_data_13_d_2;
  wire [7:0] load_weight_data_13_d_3;
  wire [7:0] load_weight_data_13_d_4;
  wire [7:0] load_weight_data_13_d_5;
  wire [7:0] load_weight_data_13_d_6;
  wire [7:0] load_weight_data_13_d_7;
  wire [7:0] load_weight_data_13_d_expo;
  wire [7:0] load_weight_data_13_d_bias;


  wire [7:0] load_weight_data_14_a_0;
  wire [7:0] load_weight_data_14_a_1;
  wire [7:0] load_weight_data_14_a_2;
  wire [7:0] load_weight_data_14_a_3;
  wire [7:0] load_weight_data_14_a_4;
  wire [7:0] load_weight_data_14_a_5;
  wire [7:0] load_weight_data_14_a_6;
  wire [7:0] load_weight_data_14_a_7;
  wire [7:0] load_weight_data_14_a_expo;
  wire [7:0] load_weight_data_14_a_bias;

  wire [7:0] load_weight_data_14_b_0;
  wire [7:0] load_weight_data_14_b_1;
  wire [7:0] load_weight_data_14_b_2;
  wire [7:0] load_weight_data_14_b_3;
  wire [7:0] load_weight_data_14_b_4;
  wire [7:0] load_weight_data_14_b_5;
  wire [7:0] load_weight_data_14_b_6;
  wire [7:0] load_weight_data_14_b_7;
  wire [7:0] load_weight_data_14_b_expo;
  wire [7:0] load_weight_data_14_b_bias;

  wire [7:0] load_weight_data_14_c_0;
  wire [7:0] load_weight_data_14_c_1;
  wire [7:0] load_weight_data_14_c_2;
  wire [7:0] load_weight_data_14_c_3;
  wire [7:0] load_weight_data_14_c_4;
  wire [7:0] load_weight_data_14_c_5;
  wire [7:0] load_weight_data_14_c_6;
  wire [7:0] load_weight_data_14_c_7;
  wire [7:0] load_weight_data_14_c_expo;
  wire [7:0] load_weight_data_14_c_bias;

  wire [7:0] load_weight_data_14_d_0;
  wire [7:0] load_weight_data_14_d_1;
  wire [7:0] load_weight_data_14_d_2;
  wire [7:0] load_weight_data_14_d_3;
  wire [7:0] load_weight_data_14_d_4;
  wire [7:0] load_weight_data_14_d_5;
  wire [7:0] load_weight_data_14_d_6;
  wire [7:0] load_weight_data_14_d_7;
  wire [7:0] load_weight_data_14_d_expo;
  wire [7:0] load_weight_data_14_d_bias;


  wire [7:0] load_weight_data_15_a_0;
  wire [7:0] load_weight_data_15_a_1;
  wire [7:0] load_weight_data_15_a_2;
  wire [7:0] load_weight_data_15_a_3;
  wire [7:0] load_weight_data_15_a_4;
  wire [7:0] load_weight_data_15_a_5;
  wire [7:0] load_weight_data_15_a_6;
  wire [7:0] load_weight_data_15_a_7;
  wire [7:0] load_weight_data_15_a_expo;
  wire [7:0] load_weight_data_15_a_bias;

  wire [7:0] load_weight_data_15_b_0;
  wire [7:0] load_weight_data_15_b_1;
  wire [7:0] load_weight_data_15_b_2;
  wire [7:0] load_weight_data_15_b_3;
  wire [7:0] load_weight_data_15_b_4;
  wire [7:0] load_weight_data_15_b_5;
  wire [7:0] load_weight_data_15_b_6;
  wire [7:0] load_weight_data_15_b_7;
  wire [7:0] load_weight_data_15_b_expo;
  wire [7:0] load_weight_data_15_b_bias;

  wire [7:0] load_weight_data_15_c_0;
  wire [7:0] load_weight_data_15_c_1;
  wire [7:0] load_weight_data_15_c_2;
  wire [7:0] load_weight_data_15_c_3;
  wire [7:0] load_weight_data_15_c_4;
  wire [7:0] load_weight_data_15_c_5;
  wire [7:0] load_weight_data_15_c_6;
  wire [7:0] load_weight_data_15_c_7;
  wire [7:0] load_weight_data_15_c_expo;
  wire [7:0] load_weight_data_15_c_bias;

  wire [7:0] load_weight_data_15_d_0;
  wire [7:0] load_weight_data_15_d_1;
  wire [7:0] load_weight_data_15_d_2;
  wire [7:0] load_weight_data_15_d_3;
  wire [7:0] load_weight_data_15_d_4;
  wire [7:0] load_weight_data_15_d_5;
  wire [7:0] load_weight_data_15_d_6;
  wire [7:0] load_weight_data_15_d_7;
  wire [7:0] load_weight_data_15_d_expo;
  wire [7:0] load_weight_data_15_d_bias;


  wire [7:0] load_weight_data_16_a_0;
  wire [7:0] load_weight_data_16_a_1;
  wire [7:0] load_weight_data_16_a_2;
  wire [7:0] load_weight_data_16_a_3;
  wire [7:0] load_weight_data_16_a_4;
  wire [7:0] load_weight_data_16_a_5;
  wire [7:0] load_weight_data_16_a_6;
  wire [7:0] load_weight_data_16_a_7;
  wire [7:0] load_weight_data_16_a_expo;
  wire [7:0] load_weight_data_16_a_bias;

  wire [7:0] load_weight_data_16_b_0;
  wire [7:0] load_weight_data_16_b_1;
  wire [7:0] load_weight_data_16_b_2;
  wire [7:0] load_weight_data_16_b_3;
  wire [7:0] load_weight_data_16_b_4;
  wire [7:0] load_weight_data_16_b_5;
  wire [7:0] load_weight_data_16_b_6;
  wire [7:0] load_weight_data_16_b_7;
  wire [7:0] load_weight_data_16_b_expo;
  wire [7:0] load_weight_data_16_b_bias;

  wire [7:0] load_weight_data_16_c_0;
  wire [7:0] load_weight_data_16_c_1;
  wire [7:0] load_weight_data_16_c_2;
  wire [7:0] load_weight_data_16_c_3;
  wire [7:0] load_weight_data_16_c_4;
  wire [7:0] load_weight_data_16_c_5;
  wire [7:0] load_weight_data_16_c_6;
  wire [7:0] load_weight_data_16_c_7;
  wire [7:0] load_weight_data_16_c_expo;
  wire [7:0] load_weight_data_16_c_bias;

  wire [7:0] load_weight_data_16_d_0;
  wire [7:0] load_weight_data_16_d_1;
  wire [7:0] load_weight_data_16_d_2;
  wire [7:0] load_weight_data_16_d_3;
  wire [7:0] load_weight_data_16_d_4;
  wire [7:0] load_weight_data_16_d_5;
  wire [7:0] load_weight_data_16_d_6;
  wire [7:0] load_weight_data_16_d_7;
  wire [7:0] load_weight_data_16_d_expo;
  wire [7:0] load_weight_data_16_d_bias;


  wire [7:0] load_weight_data_17_a_0;
  wire [7:0] load_weight_data_17_a_1;
  wire [7:0] load_weight_data_17_a_2;
  wire [7:0] load_weight_data_17_a_3;
  wire [7:0] load_weight_data_17_a_4;
  wire [7:0] load_weight_data_17_a_5;
  wire [7:0] load_weight_data_17_a_6;
  wire [7:0] load_weight_data_17_a_7;
  wire [7:0] load_weight_data_17_a_expo;
  wire [7:0] load_weight_data_17_a_bias;

  wire [7:0] load_weight_data_17_b_0;
  wire [7:0] load_weight_data_17_b_1;
  wire [7:0] load_weight_data_17_b_2;
  wire [7:0] load_weight_data_17_b_3;
  wire [7:0] load_weight_data_17_b_4;
  wire [7:0] load_weight_data_17_b_5;
  wire [7:0] load_weight_data_17_b_6;
  wire [7:0] load_weight_data_17_b_7;
  wire [7:0] load_weight_data_17_b_expo;
  wire [7:0] load_weight_data_17_b_bias;

  wire [7:0] load_weight_data_17_c_0;
  wire [7:0] load_weight_data_17_c_1;
  wire [7:0] load_weight_data_17_c_2;
  wire [7:0] load_weight_data_17_c_3;
  wire [7:0] load_weight_data_17_c_4;
  wire [7:0] load_weight_data_17_c_5;
  wire [7:0] load_weight_data_17_c_6;
  wire [7:0] load_weight_data_17_c_7;
  wire [7:0] load_weight_data_17_c_expo;
  wire [7:0] load_weight_data_17_c_bias;

  wire [7:0] load_weight_data_17_d_0;
  wire [7:0] load_weight_data_17_d_1;
  wire [7:0] load_weight_data_17_d_2;
  wire [7:0] load_weight_data_17_d_3;
  wire [7:0] load_weight_data_17_d_4;
  wire [7:0] load_weight_data_17_d_5;
  wire [7:0] load_weight_data_17_d_6;
  wire [7:0] load_weight_data_17_d_7;
  wire [7:0] load_weight_data_17_d_expo;
  wire [7:0] load_weight_data_17_d_bias;


  wire [7:0] load_weight_data_18_a_0;
  wire [7:0] load_weight_data_18_a_1;
  wire [7:0] load_weight_data_18_a_2;
  wire [7:0] load_weight_data_18_a_3;
  wire [7:0] load_weight_data_18_a_4;
  wire [7:0] load_weight_data_18_a_5;
  wire [7:0] load_weight_data_18_a_6;
  wire [7:0] load_weight_data_18_a_7;
  wire [7:0] load_weight_data_18_a_expo;
  wire [7:0] load_weight_data_18_a_bias;

  wire [7:0] load_weight_data_18_b_0;
  wire [7:0] load_weight_data_18_b_1;
  wire [7:0] load_weight_data_18_b_2;
  wire [7:0] load_weight_data_18_b_3;
  wire [7:0] load_weight_data_18_b_4;
  wire [7:0] load_weight_data_18_b_5;
  wire [7:0] load_weight_data_18_b_6;
  wire [7:0] load_weight_data_18_b_7;
  wire [7:0] load_weight_data_18_b_expo;
  wire [7:0] load_weight_data_18_b_bias;

  wire [7:0] load_weight_data_18_c_0;
  wire [7:0] load_weight_data_18_c_1;
  wire [7:0] load_weight_data_18_c_2;
  wire [7:0] load_weight_data_18_c_3;
  wire [7:0] load_weight_data_18_c_4;
  wire [7:0] load_weight_data_18_c_5;
  wire [7:0] load_weight_data_18_c_6;
  wire [7:0] load_weight_data_18_c_7;
  wire [7:0] load_weight_data_18_c_expo;
  wire [7:0] load_weight_data_18_c_bias;

  wire [7:0] load_weight_data_18_d_0;
  wire [7:0] load_weight_data_18_d_1;
  wire [7:0] load_weight_data_18_d_2;
  wire [7:0] load_weight_data_18_d_3;
  wire [7:0] load_weight_data_18_d_4;
  wire [7:0] load_weight_data_18_d_5;
  wire [7:0] load_weight_data_18_d_6;
  wire [7:0] load_weight_data_18_d_7;
  wire [7:0] load_weight_data_18_d_expo;
  wire [7:0] load_weight_data_18_d_bias;


  wire [7:0] load_weight_data_19_a_0;
  wire [7:0] load_weight_data_19_a_1;
  wire [7:0] load_weight_data_19_a_2;
  wire [7:0] load_weight_data_19_a_3;
  wire [7:0] load_weight_data_19_a_4;
  wire [7:0] load_weight_data_19_a_5;
  wire [7:0] load_weight_data_19_a_6;
  wire [7:0] load_weight_data_19_a_7;
  wire [7:0] load_weight_data_19_a_expo;
  wire [7:0] load_weight_data_19_a_bias;

  wire [7:0] load_weight_data_19_b_0;
  wire [7:0] load_weight_data_19_b_1;
  wire [7:0] load_weight_data_19_b_2;
  wire [7:0] load_weight_data_19_b_3;
  wire [7:0] load_weight_data_19_b_4;
  wire [7:0] load_weight_data_19_b_5;
  wire [7:0] load_weight_data_19_b_6;
  wire [7:0] load_weight_data_19_b_7;
  wire [7:0] load_weight_data_19_b_expo;
  wire [7:0] load_weight_data_19_b_bias;

  wire [7:0] load_weight_data_19_c_0;
  wire [7:0] load_weight_data_19_c_1;
  wire [7:0] load_weight_data_19_c_2;
  wire [7:0] load_weight_data_19_c_3;
  wire [7:0] load_weight_data_19_c_4;
  wire [7:0] load_weight_data_19_c_5;
  wire [7:0] load_weight_data_19_c_6;
  wire [7:0] load_weight_data_19_c_7;
  wire [7:0] load_weight_data_19_c_expo;
  wire [7:0] load_weight_data_19_c_bias;

  wire [7:0] load_weight_data_19_d_0;
  wire [7:0] load_weight_data_19_d_1;
  wire [7:0] load_weight_data_19_d_2;
  wire [7:0] load_weight_data_19_d_3;
  wire [7:0] load_weight_data_19_d_4;
  wire [7:0] load_weight_data_19_d_5;
  wire [7:0] load_weight_data_19_d_6;
  wire [7:0] load_weight_data_19_d_7;
  wire [7:0] load_weight_data_19_d_expo;
  wire [7:0] load_weight_data_19_d_bias;


  wire [7:0] load_weight_data_20_a_0;
  wire [7:0] load_weight_data_20_a_1;
  wire [7:0] load_weight_data_20_a_2;
  wire [7:0] load_weight_data_20_a_3;
  wire [7:0] load_weight_data_20_a_4;
  wire [7:0] load_weight_data_20_a_5;
  wire [7:0] load_weight_data_20_a_6;
  wire [7:0] load_weight_data_20_a_7;
  wire [7:0] load_weight_data_20_a_expo;
  wire [7:0] load_weight_data_20_a_bias;

  wire [7:0] load_weight_data_20_b_0;
  wire [7:0] load_weight_data_20_b_1;
  wire [7:0] load_weight_data_20_b_2;
  wire [7:0] load_weight_data_20_b_3;
  wire [7:0] load_weight_data_20_b_4;
  wire [7:0] load_weight_data_20_b_5;
  wire [7:0] load_weight_data_20_b_6;
  wire [7:0] load_weight_data_20_b_7;
  wire [7:0] load_weight_data_20_b_expo;
  wire [7:0] load_weight_data_20_b_bias;

  wire [7:0] load_weight_data_20_c_0;
  wire [7:0] load_weight_data_20_c_1;
  wire [7:0] load_weight_data_20_c_2;
  wire [7:0] load_weight_data_20_c_3;
  wire [7:0] load_weight_data_20_c_4;
  wire [7:0] load_weight_data_20_c_5;
  wire [7:0] load_weight_data_20_c_6;
  wire [7:0] load_weight_data_20_c_7;
  wire [7:0] load_weight_data_20_c_expo;
  wire [7:0] load_weight_data_20_c_bias;

  wire [7:0] load_weight_data_20_d_0;
  wire [7:0] load_weight_data_20_d_1;
  wire [7:0] load_weight_data_20_d_2;
  wire [7:0] load_weight_data_20_d_3;
  wire [7:0] load_weight_data_20_d_4;
  wire [7:0] load_weight_data_20_d_5;
  wire [7:0] load_weight_data_20_d_6;
  wire [7:0] load_weight_data_20_d_7;
  wire [7:0] load_weight_data_20_d_expo;
  wire [7:0] load_weight_data_20_d_bias;


  wire [7:0] load_weight_data_21_a_0;
  wire [7:0] load_weight_data_21_a_1;
  wire [7:0] load_weight_data_21_a_2;
  wire [7:0] load_weight_data_21_a_3;
  wire [7:0] load_weight_data_21_a_4;
  wire [7:0] load_weight_data_21_a_5;
  wire [7:0] load_weight_data_21_a_6;
  wire [7:0] load_weight_data_21_a_7;
  wire [7:0] load_weight_data_21_a_expo;
  wire [7:0] load_weight_data_21_a_bias;

  wire [7:0] load_weight_data_21_b_0;
  wire [7:0] load_weight_data_21_b_1;
  wire [7:0] load_weight_data_21_b_2;
  wire [7:0] load_weight_data_21_b_3;
  wire [7:0] load_weight_data_21_b_4;
  wire [7:0] load_weight_data_21_b_5;
  wire [7:0] load_weight_data_21_b_6;
  wire [7:0] load_weight_data_21_b_7;
  wire [7:0] load_weight_data_21_b_expo;
  wire [7:0] load_weight_data_21_b_bias;

  wire [7:0] load_weight_data_21_c_0;
  wire [7:0] load_weight_data_21_c_1;
  wire [7:0] load_weight_data_21_c_2;
  wire [7:0] load_weight_data_21_c_3;
  wire [7:0] load_weight_data_21_c_4;
  wire [7:0] load_weight_data_21_c_5;
  wire [7:0] load_weight_data_21_c_6;
  wire [7:0] load_weight_data_21_c_7;
  wire [7:0] load_weight_data_21_c_expo;
  wire [7:0] load_weight_data_21_c_bias;

  wire [7:0] load_weight_data_21_d_0;
  wire [7:0] load_weight_data_21_d_1;
  wire [7:0] load_weight_data_21_d_2;
  wire [7:0] load_weight_data_21_d_3;
  wire [7:0] load_weight_data_21_d_4;
  wire [7:0] load_weight_data_21_d_5;
  wire [7:0] load_weight_data_21_d_6;
  wire [7:0] load_weight_data_21_d_7;
  wire [7:0] load_weight_data_21_d_expo;
  wire [7:0] load_weight_data_21_d_bias;


  wire [7:0] load_weight_data_22_a_0;
  wire [7:0] load_weight_data_22_a_1;
  wire [7:0] load_weight_data_22_a_2;
  wire [7:0] load_weight_data_22_a_3;
  wire [7:0] load_weight_data_22_a_4;
  wire [7:0] load_weight_data_22_a_5;
  wire [7:0] load_weight_data_22_a_6;
  wire [7:0] load_weight_data_22_a_7;
  wire [7:0] load_weight_data_22_a_expo;
  wire [7:0] load_weight_data_22_a_bias;

  wire [7:0] load_weight_data_22_b_0;
  wire [7:0] load_weight_data_22_b_1;
  wire [7:0] load_weight_data_22_b_2;
  wire [7:0] load_weight_data_22_b_3;
  wire [7:0] load_weight_data_22_b_4;
  wire [7:0] load_weight_data_22_b_5;
  wire [7:0] load_weight_data_22_b_6;
  wire [7:0] load_weight_data_22_b_7;
  wire [7:0] load_weight_data_22_b_expo;
  wire [7:0] load_weight_data_22_b_bias;

  wire [7:0] load_weight_data_22_c_0;
  wire [7:0] load_weight_data_22_c_1;
  wire [7:0] load_weight_data_22_c_2;
  wire [7:0] load_weight_data_22_c_3;
  wire [7:0] load_weight_data_22_c_4;
  wire [7:0] load_weight_data_22_c_5;
  wire [7:0] load_weight_data_22_c_6;
  wire [7:0] load_weight_data_22_c_7;
  wire [7:0] load_weight_data_22_c_expo;
  wire [7:0] load_weight_data_22_c_bias;

  wire [7:0] load_weight_data_22_d_0;
  wire [7:0] load_weight_data_22_d_1;
  wire [7:0] load_weight_data_22_d_2;
  wire [7:0] load_weight_data_22_d_3;
  wire [7:0] load_weight_data_22_d_4;
  wire [7:0] load_weight_data_22_d_5;
  wire [7:0] load_weight_data_22_d_6;
  wire [7:0] load_weight_data_22_d_7;
  wire [7:0] load_weight_data_22_d_expo;
  wire [7:0] load_weight_data_22_d_bias;


  wire [7:0] load_weight_data_23_a_0;
  wire [7:0] load_weight_data_23_a_1;
  wire [7:0] load_weight_data_23_a_2;
  wire [7:0] load_weight_data_23_a_3;
  wire [7:0] load_weight_data_23_a_4;
  wire [7:0] load_weight_data_23_a_5;
  wire [7:0] load_weight_data_23_a_6;
  wire [7:0] load_weight_data_23_a_7;
  wire [7:0] load_weight_data_23_a_expo;
  wire [7:0] load_weight_data_23_a_bias;

  wire [7:0] load_weight_data_23_b_0;
  wire [7:0] load_weight_data_23_b_1;
  wire [7:0] load_weight_data_23_b_2;
  wire [7:0] load_weight_data_23_b_3;
  wire [7:0] load_weight_data_23_b_4;
  wire [7:0] load_weight_data_23_b_5;
  wire [7:0] load_weight_data_23_b_6;
  wire [7:0] load_weight_data_23_b_7;
  wire [7:0] load_weight_data_23_b_expo;
  wire [7:0] load_weight_data_23_b_bias;

  wire [7:0] load_weight_data_23_c_0;
  wire [7:0] load_weight_data_23_c_1;
  wire [7:0] load_weight_data_23_c_2;
  wire [7:0] load_weight_data_23_c_3;
  wire [7:0] load_weight_data_23_c_4;
  wire [7:0] load_weight_data_23_c_5;
  wire [7:0] load_weight_data_23_c_6;
  wire [7:0] load_weight_data_23_c_7;
  wire [7:0] load_weight_data_23_c_expo;
  wire [7:0] load_weight_data_23_c_bias;

  wire [7:0] load_weight_data_23_d_0;
  wire [7:0] load_weight_data_23_d_1;
  wire [7:0] load_weight_data_23_d_2;
  wire [7:0] load_weight_data_23_d_3;
  wire [7:0] load_weight_data_23_d_4;
  wire [7:0] load_weight_data_23_d_5;
  wire [7:0] load_weight_data_23_d_6;
  wire [7:0] load_weight_data_23_d_7;
  wire [7:0] load_weight_data_23_d_expo;
  wire [7:0] load_weight_data_23_d_bias;


  wire [7:0] load_weight_data_24_a_0;
  wire [7:0] load_weight_data_24_a_1;
  wire [7:0] load_weight_data_24_a_2;
  wire [7:0] load_weight_data_24_a_3;
  wire [7:0] load_weight_data_24_a_4;
  wire [7:0] load_weight_data_24_a_5;
  wire [7:0] load_weight_data_24_a_6;
  wire [7:0] load_weight_data_24_a_7;
  wire [7:0] load_weight_data_24_a_expo;
  wire [7:0] load_weight_data_24_a_bias;

  wire [7:0] load_weight_data_24_b_0;
  wire [7:0] load_weight_data_24_b_1;
  wire [7:0] load_weight_data_24_b_2;
  wire [7:0] load_weight_data_24_b_3;
  wire [7:0] load_weight_data_24_b_4;
  wire [7:0] load_weight_data_24_b_5;
  wire [7:0] load_weight_data_24_b_6;
  wire [7:0] load_weight_data_24_b_7;
  wire [7:0] load_weight_data_24_b_expo;
  wire [7:0] load_weight_data_24_b_bias;

  wire [7:0] load_weight_data_24_c_0;
  wire [7:0] load_weight_data_24_c_1;
  wire [7:0] load_weight_data_24_c_2;
  wire [7:0] load_weight_data_24_c_3;
  wire [7:0] load_weight_data_24_c_4;
  wire [7:0] load_weight_data_24_c_5;
  wire [7:0] load_weight_data_24_c_6;
  wire [7:0] load_weight_data_24_c_7;
  wire [7:0] load_weight_data_24_c_expo;
  wire [7:0] load_weight_data_24_c_bias;

  wire [7:0] load_weight_data_24_d_0;
  wire [7:0] load_weight_data_24_d_1;
  wire [7:0] load_weight_data_24_d_2;
  wire [7:0] load_weight_data_24_d_3;
  wire [7:0] load_weight_data_24_d_4;
  wire [7:0] load_weight_data_24_d_5;
  wire [7:0] load_weight_data_24_d_6;
  wire [7:0] load_weight_data_24_d_7;
  wire [7:0] load_weight_data_24_d_expo;
  wire [7:0] load_weight_data_24_d_bias;


  wire [7:0] load_weight_data_25_a_0;
  wire [7:0] load_weight_data_25_a_1;
  wire [7:0] load_weight_data_25_a_2;
  wire [7:0] load_weight_data_25_a_3;
  wire [7:0] load_weight_data_25_a_4;
  wire [7:0] load_weight_data_25_a_5;
  wire [7:0] load_weight_data_25_a_6;
  wire [7:0] load_weight_data_25_a_7;
  wire [7:0] load_weight_data_25_a_expo;
  wire [7:0] load_weight_data_25_a_bias;

  wire [7:0] load_weight_data_25_b_0;
  wire [7:0] load_weight_data_25_b_1;
  wire [7:0] load_weight_data_25_b_2;
  wire [7:0] load_weight_data_25_b_3;
  wire [7:0] load_weight_data_25_b_4;
  wire [7:0] load_weight_data_25_b_5;
  wire [7:0] load_weight_data_25_b_6;
  wire [7:0] load_weight_data_25_b_7;
  wire [7:0] load_weight_data_25_b_expo;
  wire [7:0] load_weight_data_25_b_bias;

  wire [7:0] load_weight_data_25_c_0;
  wire [7:0] load_weight_data_25_c_1;
  wire [7:0] load_weight_data_25_c_2;
  wire [7:0] load_weight_data_25_c_3;
  wire [7:0] load_weight_data_25_c_4;
  wire [7:0] load_weight_data_25_c_5;
  wire [7:0] load_weight_data_25_c_6;
  wire [7:0] load_weight_data_25_c_7;
  wire [7:0] load_weight_data_25_c_expo;
  wire [7:0] load_weight_data_25_c_bias;

  wire [7:0] load_weight_data_25_d_0;
  wire [7:0] load_weight_data_25_d_1;
  wire [7:0] load_weight_data_25_d_2;
  wire [7:0] load_weight_data_25_d_3;
  wire [7:0] load_weight_data_25_d_4;
  wire [7:0] load_weight_data_25_d_5;
  wire [7:0] load_weight_data_25_d_6;
  wire [7:0] load_weight_data_25_d_7;
  wire [7:0] load_weight_data_25_d_expo;
  wire [7:0] load_weight_data_25_d_bias;


  wire [7:0] load_weight_data_26_a_0;
  wire [7:0] load_weight_data_26_a_1;
  wire [7:0] load_weight_data_26_a_2;
  wire [7:0] load_weight_data_26_a_3;
  wire [7:0] load_weight_data_26_a_4;
  wire [7:0] load_weight_data_26_a_5;
  wire [7:0] load_weight_data_26_a_6;
  wire [7:0] load_weight_data_26_a_7;
  wire [7:0] load_weight_data_26_a_expo;
  wire [7:0] load_weight_data_26_a_bias;

  wire [7:0] load_weight_data_26_b_0;
  wire [7:0] load_weight_data_26_b_1;
  wire [7:0] load_weight_data_26_b_2;
  wire [7:0] load_weight_data_26_b_3;
  wire [7:0] load_weight_data_26_b_4;
  wire [7:0] load_weight_data_26_b_5;
  wire [7:0] load_weight_data_26_b_6;
  wire [7:0] load_weight_data_26_b_7;
  wire [7:0] load_weight_data_26_b_expo;
  wire [7:0] load_weight_data_26_b_bias;

  wire [7:0] load_weight_data_26_c_0;
  wire [7:0] load_weight_data_26_c_1;
  wire [7:0] load_weight_data_26_c_2;
  wire [7:0] load_weight_data_26_c_3;
  wire [7:0] load_weight_data_26_c_4;
  wire [7:0] load_weight_data_26_c_5;
  wire [7:0] load_weight_data_26_c_6;
  wire [7:0] load_weight_data_26_c_7;
  wire [7:0] load_weight_data_26_c_expo;
  wire [7:0] load_weight_data_26_c_bias;

  wire [7:0] load_weight_data_26_d_0;
  wire [7:0] load_weight_data_26_d_1;
  wire [7:0] load_weight_data_26_d_2;
  wire [7:0] load_weight_data_26_d_3;
  wire [7:0] load_weight_data_26_d_4;
  wire [7:0] load_weight_data_26_d_5;
  wire [7:0] load_weight_data_26_d_6;
  wire [7:0] load_weight_data_26_d_7;
  wire [7:0] load_weight_data_26_d_expo;
  wire [7:0] load_weight_data_26_d_bias;


  wire [7:0] load_weight_data_27_a_0;
  wire [7:0] load_weight_data_27_a_1;
  wire [7:0] load_weight_data_27_a_2;
  wire [7:0] load_weight_data_27_a_3;
  wire [7:0] load_weight_data_27_a_4;
  wire [7:0] load_weight_data_27_a_5;
  wire [7:0] load_weight_data_27_a_6;
  wire [7:0] load_weight_data_27_a_7;
  wire [7:0] load_weight_data_27_a_expo;
  wire [7:0] load_weight_data_27_a_bias;

  wire [7:0] load_weight_data_27_b_0;
  wire [7:0] load_weight_data_27_b_1;
  wire [7:0] load_weight_data_27_b_2;
  wire [7:0] load_weight_data_27_b_3;
  wire [7:0] load_weight_data_27_b_4;
  wire [7:0] load_weight_data_27_b_5;
  wire [7:0] load_weight_data_27_b_6;
  wire [7:0] load_weight_data_27_b_7;
  wire [7:0] load_weight_data_27_b_expo;
  wire [7:0] load_weight_data_27_b_bias;

  wire [7:0] load_weight_data_27_c_0;
  wire [7:0] load_weight_data_27_c_1;
  wire [7:0] load_weight_data_27_c_2;
  wire [7:0] load_weight_data_27_c_3;
  wire [7:0] load_weight_data_27_c_4;
  wire [7:0] load_weight_data_27_c_5;
  wire [7:0] load_weight_data_27_c_6;
  wire [7:0] load_weight_data_27_c_7;
  wire [7:0] load_weight_data_27_c_expo;
  wire [7:0] load_weight_data_27_c_bias;

  wire [7:0] load_weight_data_27_d_0;
  wire [7:0] load_weight_data_27_d_1;
  wire [7:0] load_weight_data_27_d_2;
  wire [7:0] load_weight_data_27_d_3;
  wire [7:0] load_weight_data_27_d_4;
  wire [7:0] load_weight_data_27_d_5;
  wire [7:0] load_weight_data_27_d_6;
  wire [7:0] load_weight_data_27_d_7;
  wire [7:0] load_weight_data_27_d_expo;
  wire [7:0] load_weight_data_27_d_bias;


  wire [7:0] load_weight_data_28_a_0;
  wire [7:0] load_weight_data_28_a_1;
  wire [7:0] load_weight_data_28_a_2;
  wire [7:0] load_weight_data_28_a_3;
  wire [7:0] load_weight_data_28_a_4;
  wire [7:0] load_weight_data_28_a_5;
  wire [7:0] load_weight_data_28_a_6;
  wire [7:0] load_weight_data_28_a_7;
  wire [7:0] load_weight_data_28_a_expo;
  wire [7:0] load_weight_data_28_a_bias;

  wire [7:0] load_weight_data_28_b_0;
  wire [7:0] load_weight_data_28_b_1;
  wire [7:0] load_weight_data_28_b_2;
  wire [7:0] load_weight_data_28_b_3;
  wire [7:0] load_weight_data_28_b_4;
  wire [7:0] load_weight_data_28_b_5;
  wire [7:0] load_weight_data_28_b_6;
  wire [7:0] load_weight_data_28_b_7;
  wire [7:0] load_weight_data_28_b_expo;
  wire [7:0] load_weight_data_28_b_bias;

  wire [7:0] load_weight_data_28_c_0;
  wire [7:0] load_weight_data_28_c_1;
  wire [7:0] load_weight_data_28_c_2;
  wire [7:0] load_weight_data_28_c_3;
  wire [7:0] load_weight_data_28_c_4;
  wire [7:0] load_weight_data_28_c_5;
  wire [7:0] load_weight_data_28_c_6;
  wire [7:0] load_weight_data_28_c_7;
  wire [7:0] load_weight_data_28_c_expo;
  wire [7:0] load_weight_data_28_c_bias;

  wire [7:0] load_weight_data_28_d_0;
  wire [7:0] load_weight_data_28_d_1;
  wire [7:0] load_weight_data_28_d_2;
  wire [7:0] load_weight_data_28_d_3;
  wire [7:0] load_weight_data_28_d_4;
  wire [7:0] load_weight_data_28_d_5;
  wire [7:0] load_weight_data_28_d_6;
  wire [7:0] load_weight_data_28_d_7;
  wire [7:0] load_weight_data_28_d_expo;
  wire [7:0] load_weight_data_28_d_bias;


  wire [7:0] load_weight_data_29_a_0;
  wire [7:0] load_weight_data_29_a_1;
  wire [7:0] load_weight_data_29_a_2;
  wire [7:0] load_weight_data_29_a_3;
  wire [7:0] load_weight_data_29_a_4;
  wire [7:0] load_weight_data_29_a_5;
  wire [7:0] load_weight_data_29_a_6;
  wire [7:0] load_weight_data_29_a_7;
  wire [7:0] load_weight_data_29_a_expo;
  wire [7:0] load_weight_data_29_a_bias;

  wire [7:0] load_weight_data_29_b_0;
  wire [7:0] load_weight_data_29_b_1;
  wire [7:0] load_weight_data_29_b_2;
  wire [7:0] load_weight_data_29_b_3;
  wire [7:0] load_weight_data_29_b_4;
  wire [7:0] load_weight_data_29_b_5;
  wire [7:0] load_weight_data_29_b_6;
  wire [7:0] load_weight_data_29_b_7;
  wire [7:0] load_weight_data_29_b_expo;
  wire [7:0] load_weight_data_29_b_bias;

  wire [7:0] load_weight_data_29_c_0;
  wire [7:0] load_weight_data_29_c_1;
  wire [7:0] load_weight_data_29_c_2;
  wire [7:0] load_weight_data_29_c_3;
  wire [7:0] load_weight_data_29_c_4;
  wire [7:0] load_weight_data_29_c_5;
  wire [7:0] load_weight_data_29_c_6;
  wire [7:0] load_weight_data_29_c_7;
  wire [7:0] load_weight_data_29_c_expo;
  wire [7:0] load_weight_data_29_c_bias;

  wire [7:0] load_weight_data_29_d_0;
  wire [7:0] load_weight_data_29_d_1;
  wire [7:0] load_weight_data_29_d_2;
  wire [7:0] load_weight_data_29_d_3;
  wire [7:0] load_weight_data_29_d_4;
  wire [7:0] load_weight_data_29_d_5;
  wire [7:0] load_weight_data_29_d_6;
  wire [7:0] load_weight_data_29_d_7;
  wire [7:0] load_weight_data_29_d_expo;
  wire [7:0] load_weight_data_29_d_bias;


  wire [7:0] load_weight_data_30_a_0;
  wire [7:0] load_weight_data_30_a_1;
  wire [7:0] load_weight_data_30_a_2;
  wire [7:0] load_weight_data_30_a_3;
  wire [7:0] load_weight_data_30_a_4;
  wire [7:0] load_weight_data_30_a_5;
  wire [7:0] load_weight_data_30_a_6;
  wire [7:0] load_weight_data_30_a_7;
  wire [7:0] load_weight_data_30_a_expo;
  wire [7:0] load_weight_data_30_a_bias;

  wire [7:0] load_weight_data_30_b_0;
  wire [7:0] load_weight_data_30_b_1;
  wire [7:0] load_weight_data_30_b_2;
  wire [7:0] load_weight_data_30_b_3;
  wire [7:0] load_weight_data_30_b_4;
  wire [7:0] load_weight_data_30_b_5;
  wire [7:0] load_weight_data_30_b_6;
  wire [7:0] load_weight_data_30_b_7;
  wire [7:0] load_weight_data_30_b_expo;
  wire [7:0] load_weight_data_30_b_bias;

  wire [7:0] load_weight_data_30_c_0;
  wire [7:0] load_weight_data_30_c_1;
  wire [7:0] load_weight_data_30_c_2;
  wire [7:0] load_weight_data_30_c_3;
  wire [7:0] load_weight_data_30_c_4;
  wire [7:0] load_weight_data_30_c_5;
  wire [7:0] load_weight_data_30_c_6;
  wire [7:0] load_weight_data_30_c_7;
  wire [7:0] load_weight_data_30_c_expo;
  wire [7:0] load_weight_data_30_c_bias;

  wire [7:0] load_weight_data_30_d_0;
  wire [7:0] load_weight_data_30_d_1;
  wire [7:0] load_weight_data_30_d_2;
  wire [7:0] load_weight_data_30_d_3;
  wire [7:0] load_weight_data_30_d_4;
  wire [7:0] load_weight_data_30_d_5;
  wire [7:0] load_weight_data_30_d_6;
  wire [7:0] load_weight_data_30_d_7;
  wire [7:0] load_weight_data_30_d_expo;
  wire [7:0] load_weight_data_30_d_bias;


  wire [7:0] load_weight_data_31_a_0;
  wire [7:0] load_weight_data_31_a_1;
  wire [7:0] load_weight_data_31_a_2;
  wire [7:0] load_weight_data_31_a_3;
  wire [7:0] load_weight_data_31_a_4;
  wire [7:0] load_weight_data_31_a_5;
  wire [7:0] load_weight_data_31_a_6;
  wire [7:0] load_weight_data_31_a_7;
  wire [7:0] load_weight_data_31_a_expo;
  wire [7:0] load_weight_data_31_a_bias;

  wire [7:0] load_weight_data_31_b_0;
  wire [7:0] load_weight_data_31_b_1;
  wire [7:0] load_weight_data_31_b_2;
  wire [7:0] load_weight_data_31_b_3;
  wire [7:0] load_weight_data_31_b_4;
  wire [7:0] load_weight_data_31_b_5;
  wire [7:0] load_weight_data_31_b_6;
  wire [7:0] load_weight_data_31_b_7;
  wire [7:0] load_weight_data_31_b_expo;
  wire [7:0] load_weight_data_31_b_bias;

  wire [7:0] load_weight_data_31_c_0;
  wire [7:0] load_weight_data_31_c_1;
  wire [7:0] load_weight_data_31_c_2;
  wire [7:0] load_weight_data_31_c_3;
  wire [7:0] load_weight_data_31_c_4;
  wire [7:0] load_weight_data_31_c_5;
  wire [7:0] load_weight_data_31_c_6;
  wire [7:0] load_weight_data_31_c_7;
  wire [7:0] load_weight_data_31_c_expo;
  wire [7:0] load_weight_data_31_c_bias;

  wire [7:0] load_weight_data_31_d_0;
  wire [7:0] load_weight_data_31_d_1;
  wire [7:0] load_weight_data_31_d_2;
  wire [7:0] load_weight_data_31_d_3;
  wire [7:0] load_weight_data_31_d_4;
  wire [7:0] load_weight_data_31_d_5;
  wire [7:0] load_weight_data_31_d_6;
  wire [7:0] load_weight_data_31_d_7;
  wire [7:0] load_weight_data_31_d_expo;
  wire [7:0] load_weight_data_31_d_bias;



  Load_Weight
#(
  .AXI_WIDTH_DA(AXI_WIDTH_DA)
) Load_Weight
(
  .clk(clk),
  //////////////////////////////////////////////////////////////////////////////////
  //Load Weight Control Signals/////////////////////////////////////////////////////
  //
  .i_load_weight_data_reg_wr_en(i_load_weight_data_reg_wr_en),          
  .i_sel_load_weight_data(i_sel_load_weight_data),
  //////////////////////////////////////////////////////////////////////////////////
  //AXI MASTER READ/////////////////////////////////////////////////////////////////
  //
  .m_axi_weight_memory_bus_RDATA(m_axi_weight_memory_bus_RDATA),
  //////////////////////////////////////////////////////////////////////////////////
  //Load Weight Out/////////////////////////////////////////////////////////////////
  .o_load_weight_data_0_a(load_weight_data_0_a_0),
  .o_load_weight_data_0_b(load_weight_data_0_b_0),
  .o_load_weight_data_0_c(load_weight_data_0_c_0),
  .o_load_weight_data_0_d(load_weight_data_0_d_0),

  .o_load_weight_data_1_a(load_weight_data_1_a_0),
  .o_load_weight_data_1_b(load_weight_data_1_b_0),
  .o_load_weight_data_1_c(load_weight_data_1_c_0),
  .o_load_weight_data_1_d(load_weight_data_1_d_0),

  .o_load_weight_data_2_a(load_weight_data_2_a_0),
  .o_load_weight_data_2_b(load_weight_data_2_b_0),
  .o_load_weight_data_2_c(load_weight_data_2_c_0),
  .o_load_weight_data_2_d(load_weight_data_2_d_0),

  .o_load_weight_data_3_a(load_weight_data_3_a_0),
  .o_load_weight_data_3_b(load_weight_data_3_b_0),
  .o_load_weight_data_3_c(load_weight_data_3_c_0),
  .o_load_weight_data_3_d(load_weight_data_3_d_0),

  .o_load_weight_data_4_a(load_weight_data_4_a_0),
  .o_load_weight_data_4_b(load_weight_data_4_b_0),
  .o_load_weight_data_4_c(load_weight_data_4_c_0),
  .o_load_weight_data_4_d(load_weight_data_4_d_0),

  .o_load_weight_data_5_a(load_weight_data_5_a_0),
  .o_load_weight_data_5_b(load_weight_data_5_b_0),
  .o_load_weight_data_5_c(load_weight_data_5_c_0),
  .o_load_weight_data_5_d(load_weight_data_5_d_0),

  .o_load_weight_data_6_a(load_weight_data_6_a_0),
  .o_load_weight_data_6_b(load_weight_data_6_b_0),
  .o_load_weight_data_6_c(load_weight_data_6_c_0),
  .o_load_weight_data_6_d(load_weight_data_6_d_0),

  .o_load_weight_data_7_a(load_weight_data_7_a_0),
  .o_load_weight_data_7_b(load_weight_data_7_b_0),
  .o_load_weight_data_7_c(load_weight_data_7_c_0),
  .o_load_weight_data_7_d(load_weight_data_7_d_0),

  .o_load_weight_data_8_a(load_weight_data_8_a_0),
  .o_load_weight_data_8_b(load_weight_data_8_b_0),
  .o_load_weight_data_8_c(load_weight_data_8_c_0),
  .o_load_weight_data_8_d(load_weight_data_8_d_0),

  .o_load_weight_data_9_a(load_weight_data_9_a_0),
  .o_load_weight_data_9_b(load_weight_data_9_b_0),
  .o_load_weight_data_9_c(load_weight_data_9_c_0),
  .o_load_weight_data_9_d(load_weight_data_9_d_0),

  .o_load_weight_data_10_a(load_weight_data_10_a_0),
  .o_load_weight_data_10_b(load_weight_data_10_b_0),
  .o_load_weight_data_10_c(load_weight_data_10_c_0),
  .o_load_weight_data_10_d(load_weight_data_10_d_0),

  .o_load_weight_data_11_a(load_weight_data_11_a_0),
  .o_load_weight_data_11_b(load_weight_data_11_b_0),
  .o_load_weight_data_11_c(load_weight_data_11_c_0),
  .o_load_weight_data_11_d(load_weight_data_11_d_0),

  .o_load_weight_data_12_a(load_weight_data_12_a_0),
  .o_load_weight_data_12_b(load_weight_data_12_b_0),
  .o_load_weight_data_12_c(load_weight_data_12_c_0),
  .o_load_weight_data_12_d(load_weight_data_12_d_0),

  .o_load_weight_data_13_a(load_weight_data_13_a_0),
  .o_load_weight_data_13_b(load_weight_data_13_b_0),
  .o_load_weight_data_13_c(load_weight_data_13_c_0),
  .o_load_weight_data_13_d(load_weight_data_13_d_0),

  .o_load_weight_data_14_a(load_weight_data_14_a_0),
  .o_load_weight_data_14_b(load_weight_data_14_b_0),
  .o_load_weight_data_14_c(load_weight_data_14_c_0),
  .o_load_weight_data_14_d(load_weight_data_14_d_0),

  .o_load_weight_data_15_a(load_weight_data_15_a_0),
  .o_load_weight_data_15_b(load_weight_data_15_b_0),
  .o_load_weight_data_15_c(load_weight_data_15_c_0),
  .o_load_weight_data_15_d(load_weight_data_15_d_0),

  .o_load_weight_data_16_a(load_weight_data_16_a_0),
  .o_load_weight_data_16_b(load_weight_data_16_b_0),
  .o_load_weight_data_16_c(load_weight_data_16_c_0),
  .o_load_weight_data_16_d(load_weight_data_16_d_0),

  .o_load_weight_data_17_a(load_weight_data_17_a_0),
  .o_load_weight_data_17_b(load_weight_data_17_b_0),
  .o_load_weight_data_17_c(load_weight_data_17_c_0),
  .o_load_weight_data_17_d(load_weight_data_17_d_0),

  .o_load_weight_data_18_a(load_weight_data_18_a_0),
  .o_load_weight_data_18_b(load_weight_data_18_b_0),
  .o_load_weight_data_18_c(load_weight_data_18_c_0),
  .o_load_weight_data_18_d(load_weight_data_18_d_0),

  .o_load_weight_data_19_a(load_weight_data_19_a_0),
  .o_load_weight_data_19_b(load_weight_data_19_b_0),
  .o_load_weight_data_19_c(load_weight_data_19_c_0),
  .o_load_weight_data_19_d(load_weight_data_19_d_0),

  .o_load_weight_data_20_a(load_weight_data_20_a_0),
  .o_load_weight_data_20_b(load_weight_data_20_b_0),
  .o_load_weight_data_20_c(load_weight_data_20_c_0),
  .o_load_weight_data_20_d(load_weight_data_20_d_0),

  .o_load_weight_data_21_a(load_weight_data_21_a_0),
  .o_load_weight_data_21_b(load_weight_data_21_b_0),
  .o_load_weight_data_21_c(load_weight_data_21_c_0),
  .o_load_weight_data_21_d(load_weight_data_21_d_0),

  .o_load_weight_data_22_a(load_weight_data_22_a_0),
  .o_load_weight_data_22_b(load_weight_data_22_b_0),
  .o_load_weight_data_22_c(load_weight_data_22_c_0),
  .o_load_weight_data_22_d(load_weight_data_22_d_0),

  .o_load_weight_data_23_a(load_weight_data_23_a_0),
  .o_load_weight_data_23_b(load_weight_data_23_b_0),
  .o_load_weight_data_23_c(load_weight_data_23_c_0),
  .o_load_weight_data_23_d(load_weight_data_23_d_0),

  .o_load_weight_data_24_a(load_weight_data_24_a_0),
  .o_load_weight_data_24_b(load_weight_data_24_b_0),
  .o_load_weight_data_24_c(load_weight_data_24_c_0),
  .o_load_weight_data_24_d(load_weight_data_24_d_0),

  .o_load_weight_data_25_a(load_weight_data_25_a_0),
  .o_load_weight_data_25_b(load_weight_data_25_b_0),
  .o_load_weight_data_25_c(load_weight_data_25_c_0),
  .o_load_weight_data_25_d(load_weight_data_25_d_0),

  .o_load_weight_data_26_a(load_weight_data_26_a_0),
  .o_load_weight_data_26_b(load_weight_data_26_b_0),
  .o_load_weight_data_26_c(load_weight_data_26_c_0),
  .o_load_weight_data_26_d(load_weight_data_26_d_0),

  .o_load_weight_data_27_a(load_weight_data_27_a_0),
  .o_load_weight_data_27_b(load_weight_data_27_b_0),
  .o_load_weight_data_27_c(load_weight_data_27_c_0),
  .o_load_weight_data_27_d(load_weight_data_27_d_0),

  .o_load_weight_data_28_a(load_weight_data_28_a_0),
  .o_load_weight_data_28_b(load_weight_data_28_b_0),
  .o_load_weight_data_28_c(load_weight_data_28_c_0),
  .o_load_weight_data_28_d(load_weight_data_28_d_0),

  .o_load_weight_data_29_a(load_weight_data_29_a_0),
  .o_load_weight_data_29_b(load_weight_data_29_b_0),
  .o_load_weight_data_29_c(load_weight_data_29_c_0),
  .o_load_weight_data_29_d(load_weight_data_29_d_0),

  .o_load_weight_data_30_a(load_weight_data_30_a_0),
  .o_load_weight_data_30_b(load_weight_data_30_b_0),
  .o_load_weight_data_30_c(load_weight_data_30_c_0),
  .o_load_weight_data_30_d(load_weight_data_30_d_0),

  .o_load_weight_data_31_a(load_weight_data_31_a_0),
  .o_load_weight_data_31_b(load_weight_data_31_b_0),
  .o_load_weight_data_31_c(load_weight_data_31_c_0),
  .o_load_weight_data_31_d(load_weight_data_31_d_0)
);
  
  processing_element_noadder
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) processing_element_0(
    .clk(clk), 
    .rst_n(rst_n),
    //Write Buffer Control
    .prepare_weight(i_prepare_weight),
    .buffer_wr_en_i(buffer_wr_en_i),
    .buffer_wr_addr_i(buffer_wr_addr_i),
    
    //Execute Control
    .set_weight_i(set_weight_i),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(activation_rd_en_i),
    .activation_rd_en_o(buffer_rd_en_0_o),
    .buffer_rd_addr_i(buffer_rd_addr_i),
    .buffer_rd_addr_o(buffer_rd_addr_0_o),
    
    .buffer_data_i(buffer_data_0_i),
  
    //mac array
    //mac array output
    .mac_acc_a_0_o(mac_acc_0_a_0_o),   .mac_acc_b_0_o(mac_acc_0_b_0_o),   .mac_acc_c_0_o(mac_acc_0_c_0_o),   .mac_acc_d_0_o(mac_acc_0_d_0_o),
    .mac_acc_a_1_o(mac_acc_0_a_1_o),   .mac_acc_b_1_o(mac_acc_0_b_1_o),   .mac_acc_c_1_o(mac_acc_0_c_1_o),   .mac_acc_d_1_o(mac_acc_0_d_1_o),
    .mac_acc_a_2_o(mac_acc_0_a_2_o),   .mac_acc_b_2_o(mac_acc_0_b_2_o),   .mac_acc_c_2_o(mac_acc_0_c_2_o),   .mac_acc_d_2_o(mac_acc_0_d_2_o),
    .mac_acc_a_3_o(mac_acc_0_a_3_o),   .mac_acc_b_3_o(mac_acc_0_b_3_o),   .mac_acc_c_3_o(mac_acc_0_c_3_o),   .mac_acc_d_3_o(mac_acc_0_d_3_o),
    .mac_acc_a_4_o(mac_acc_0_a_4_o),   .mac_acc_b_4_o(mac_acc_0_b_4_o),   .mac_acc_c_4_o(mac_acc_0_c_4_o),   .mac_acc_d_4_o(mac_acc_0_d_4_o),
    .mac_acc_a_5_o(mac_acc_0_a_5_o),   .mac_acc_b_5_o(mac_acc_0_b_5_o),   .mac_acc_c_5_o(mac_acc_0_c_5_o),   .mac_acc_d_5_o(mac_acc_0_d_5_o),
    .mac_acc_a_6_o(mac_acc_0_a_6_o),   .mac_acc_b_6_o(mac_acc_0_b_6_o),   .mac_acc_c_6_o(mac_acc_0_c_6_o),   .mac_acc_d_6_o(mac_acc_0_d_6_o),
    .mac_acc_a_7_o(mac_acc_0_a_7_o),   .mac_acc_b_7_o(mac_acc_0_b_7_o),   .mac_acc_c_7_o(mac_acc_0_c_7_o),   .mac_acc_d_7_o(mac_acc_0_d_7_o),
    .mac_acc_a_8_o(mac_acc_0_a_8_o),   .mac_acc_b_8_o(mac_acc_0_b_8_o),   .mac_acc_c_8_o(mac_acc_0_c_8_o),   .mac_acc_d_8_o(mac_acc_0_d_8_o),
    .mac_acc_a_9_o(mac_acc_0_a_9_o),   .mac_acc_b_9_o(mac_acc_0_b_9_o),   .mac_acc_c_9_o(mac_acc_0_c_9_o),   .mac_acc_d_9_o(mac_acc_0_d_9_o),
    .mac_acc_a_10_o(mac_acc_0_a_10_o), .mac_acc_b_10_o(mac_acc_0_b_10_o), .mac_acc_c_10_o(mac_acc_0_c_10_o), .mac_acc_d_10_o(mac_acc_0_d_10_o),
    .mac_acc_a_11_o(mac_acc_0_a_11_o), .mac_acc_b_11_o(mac_acc_0_b_11_o), .mac_acc_c_11_o(mac_acc_0_c_11_o), .mac_acc_d_11_o(mac_acc_0_d_11_o),
    .mac_acc_a_12_o(mac_acc_0_a_12_o), .mac_acc_b_12_o(mac_acc_0_b_12_o), .mac_acc_c_12_o(mac_acc_0_c_12_o), .mac_acc_d_12_o(mac_acc_0_d_12_o),
    .mac_acc_a_13_o(mac_acc_0_a_13_o), .mac_acc_b_13_o(mac_acc_0_b_13_o), .mac_acc_c_13_o(mac_acc_0_c_13_o), .mac_acc_d_13_o(mac_acc_0_d_13_o),
    .mac_acc_a_14_o(mac_acc_0_a_14_o), .mac_acc_b_14_o(mac_acc_0_b_14_o), .mac_acc_c_14_o(mac_acc_0_c_14_o), .mac_acc_d_14_o(mac_acc_0_d_14_o),
    .mac_acc_a_15_o(mac_acc_0_a_15_o), .mac_acc_b_15_o(mac_acc_0_b_15_o), .mac_acc_c_15_o(mac_acc_0_c_15_o),  .mac_acc_d_15_o(mac_acc_0_d_15_o),
  
    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_0),
    .i_load_weight_data_0_b(load_weight_data_0_b_0),
    .i_load_weight_data_0_c(load_weight_data_0_c_0),
    .i_load_weight_data_0_d(load_weight_data_0_d_0),

    .i_load_weight_data_1_a(load_weight_data_1_a_0),
    .i_load_weight_data_1_b(load_weight_data_1_b_0),
    .i_load_weight_data_1_c(load_weight_data_1_c_0),
    .i_load_weight_data_1_d(load_weight_data_1_d_0),

    .i_load_weight_data_2_a(load_weight_data_2_a_0),
    .i_load_weight_data_2_b(load_weight_data_2_b_0),
    .i_load_weight_data_2_c(load_weight_data_2_c_0),
    .i_load_weight_data_2_d(load_weight_data_2_d_0),

    .i_load_weight_data_3_a(load_weight_data_3_a_0),
    .i_load_weight_data_3_b(load_weight_data_3_b_0),
    .i_load_weight_data_3_c(load_weight_data_3_c_0),
    .i_load_weight_data_3_d(load_weight_data_3_d_0),

    .i_load_weight_data_4_a(load_weight_data_4_a_0),
    .i_load_weight_data_4_b(load_weight_data_4_b_0),
    .i_load_weight_data_4_c(load_weight_data_4_c_0),
    .i_load_weight_data_4_d(load_weight_data_4_d_0),

    .i_load_weight_data_5_a(load_weight_data_5_a_0),
    .i_load_weight_data_5_b(load_weight_data_5_b_0),
    .i_load_weight_data_5_c(load_weight_data_5_c_0),
    .i_load_weight_data_5_d(load_weight_data_5_d_0),

    .i_load_weight_data_6_a(load_weight_data_6_a_0),
    .i_load_weight_data_6_b(load_weight_data_6_b_0),
    .i_load_weight_data_6_c(load_weight_data_6_c_0),
    .i_load_weight_data_6_d(load_weight_data_6_d_0),

    .i_load_weight_data_7_a(load_weight_data_7_a_0),
    .i_load_weight_data_7_b(load_weight_data_7_b_0),
    .i_load_weight_data_7_c(load_weight_data_7_c_0),
    .i_load_weight_data_7_d(load_weight_data_7_d_0),

    .i_load_weight_data_8_a(load_weight_data_8_a_0),
    .i_load_weight_data_8_b(load_weight_data_8_b_0),
    .i_load_weight_data_8_c(load_weight_data_8_c_0),
    .i_load_weight_data_8_d(load_weight_data_8_d_0),

    .i_load_weight_data_9_a(load_weight_data_9_a_0),
    .i_load_weight_data_9_b(load_weight_data_9_b_0),
    .i_load_weight_data_9_c(load_weight_data_9_c_0),
    .i_load_weight_data_9_d(load_weight_data_9_d_0),

    .i_load_weight_data_10_a(load_weight_data_10_a_0),
    .i_load_weight_data_10_b(load_weight_data_10_b_0),
    .i_load_weight_data_10_c(load_weight_data_10_c_0),
    .i_load_weight_data_10_d(load_weight_data_10_d_0),

    .i_load_weight_data_11_a(load_weight_data_11_a_0),
    .i_load_weight_data_11_b(load_weight_data_11_b_0),
    .i_load_weight_data_11_c(load_weight_data_11_c_0),
    .i_load_weight_data_11_d(load_weight_data_11_d_0),

    .i_load_weight_data_12_a(load_weight_data_12_a_0),
    .i_load_weight_data_12_b(load_weight_data_12_b_0),
    .i_load_weight_data_12_c(load_weight_data_12_c_0),
    .i_load_weight_data_12_d(load_weight_data_12_d_0),

    .i_load_weight_data_13_a(load_weight_data_13_a_0),
    .i_load_weight_data_13_b(load_weight_data_13_b_0),
    .i_load_weight_data_13_c(load_weight_data_13_c_0),
    .i_load_weight_data_13_d(load_weight_data_13_d_0),

    .i_load_weight_data_14_a(load_weight_data_14_a_0),
    .i_load_weight_data_14_b(load_weight_data_14_b_0),
    .i_load_weight_data_14_c(load_weight_data_14_c_0),
    .i_load_weight_data_14_d(load_weight_data_14_d_0),

    .i_load_weight_data_15_a(load_weight_data_15_a_0),
    .i_load_weight_data_15_b(load_weight_data_15_b_0),
    .i_load_weight_data_15_c(load_weight_data_15_c_0),
    .i_load_weight_data_15_d(load_weight_data_15_d_0),

    .i_load_weight_data_16_a(load_weight_data_16_a_0),
    .i_load_weight_data_16_b(load_weight_data_16_b_0),
    .i_load_weight_data_16_c(load_weight_data_16_c_0),
    .i_load_weight_data_16_d(load_weight_data_16_d_0),

    .i_load_weight_data_17_a(load_weight_data_17_a_0),
    .i_load_weight_data_17_b(load_weight_data_17_b_0),
    .i_load_weight_data_17_c(load_weight_data_17_c_0),
    .i_load_weight_data_17_d(load_weight_data_17_d_0),

    .i_load_weight_data_18_a(load_weight_data_18_a_0),
    .i_load_weight_data_18_b(load_weight_data_18_b_0),
    .i_load_weight_data_18_c(load_weight_data_18_c_0),
    .i_load_weight_data_18_d(load_weight_data_18_d_0),

    .i_load_weight_data_19_a(load_weight_data_19_a_0),
    .i_load_weight_data_19_b(load_weight_data_19_b_0),
    .i_load_weight_data_19_c(load_weight_data_19_c_0),
    .i_load_weight_data_19_d(load_weight_data_19_d_0),

    .i_load_weight_data_20_a(load_weight_data_20_a_0),
    .i_load_weight_data_20_b(load_weight_data_20_b_0),
    .i_load_weight_data_20_c(load_weight_data_20_c_0),
    .i_load_weight_data_20_d(load_weight_data_20_d_0),

    .i_load_weight_data_21_a(load_weight_data_21_a_0),
    .i_load_weight_data_21_b(load_weight_data_21_b_0),
    .i_load_weight_data_21_c(load_weight_data_21_c_0),
    .i_load_weight_data_21_d(load_weight_data_21_d_0),

    .i_load_weight_data_22_a(load_weight_data_22_a_0),
    .i_load_weight_data_22_b(load_weight_data_22_b_0),
    .i_load_weight_data_22_c(load_weight_data_22_c_0),
    .i_load_weight_data_22_d(load_weight_data_22_d_0),

    .i_load_weight_data_23_a(load_weight_data_23_a_0),
    .i_load_weight_data_23_b(load_weight_data_23_b_0),
    .i_load_weight_data_23_c(load_weight_data_23_c_0),
    .i_load_weight_data_23_d(load_weight_data_23_d_0),

    .i_load_weight_data_24_a(load_weight_data_24_a_0),
    .i_load_weight_data_24_b(load_weight_data_24_b_0),
    .i_load_weight_data_24_c(load_weight_data_24_c_0),
    .i_load_weight_data_24_d(load_weight_data_24_d_0),

    .i_load_weight_data_25_a(load_weight_data_25_a_0),
    .i_load_weight_data_25_b(load_weight_data_25_b_0),
    .i_load_weight_data_25_c(load_weight_data_25_c_0),
    .i_load_weight_data_25_d(load_weight_data_25_d_0),

    .i_load_weight_data_26_a(load_weight_data_26_a_0),
    .i_load_weight_data_26_b(load_weight_data_26_b_0),
    .i_load_weight_data_26_c(load_weight_data_26_c_0),
    .i_load_weight_data_26_d(load_weight_data_26_d_0),

    .i_load_weight_data_27_a(load_weight_data_27_a_0),
    .i_load_weight_data_27_b(load_weight_data_27_b_0),
    .i_load_weight_data_27_c(load_weight_data_27_c_0),
    .i_load_weight_data_27_d(load_weight_data_27_d_0),

    .i_load_weight_data_28_a(load_weight_data_28_a_0),
    .i_load_weight_data_28_b(load_weight_data_28_b_0),
    .i_load_weight_data_28_c(load_weight_data_28_c_0),
    .i_load_weight_data_28_d(load_weight_data_28_d_0),

    .i_load_weight_data_29_a(load_weight_data_29_a_0),
    .i_load_weight_data_29_b(load_weight_data_29_b_0),
    .i_load_weight_data_29_c(load_weight_data_29_c_0),
    .i_load_weight_data_29_d(load_weight_data_29_d_0),

    .i_load_weight_data_30_a(load_weight_data_30_a_0),
    .i_load_weight_data_30_b(load_weight_data_30_b_0),
    .i_load_weight_data_30_c(load_weight_data_30_c_0),
    .i_load_weight_data_30_d(load_weight_data_30_d_0),

    .i_load_weight_data_31_a(load_weight_data_31_a_0),
    .i_load_weight_data_31_b(load_weight_data_31_b_0),
    .i_load_weight_data_31_c(load_weight_data_31_c_0),
    .i_load_weight_data_31_d(load_weight_data_31_d_0),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(load_weight_data_0_a_1),
    .o_load_weight_data_0_b(load_weight_data_0_b_1),
    .o_load_weight_data_0_c(load_weight_data_0_c_1),
    .o_load_weight_data_0_d(load_weight_data_0_d_1),

    .o_load_weight_data_1_a(load_weight_data_1_a_1),
    .o_load_weight_data_1_b(load_weight_data_1_b_1),
    .o_load_weight_data_1_c(load_weight_data_1_c_1),
    .o_load_weight_data_1_d(load_weight_data_1_d_1),

    .o_load_weight_data_2_a(load_weight_data_2_a_1),
    .o_load_weight_data_2_b(load_weight_data_2_b_1),
    .o_load_weight_data_2_c(load_weight_data_2_c_1),
    .o_load_weight_data_2_d(load_weight_data_2_d_1),

    .o_load_weight_data_3_a(load_weight_data_3_a_1),
    .o_load_weight_data_3_b(load_weight_data_3_b_1),
    .o_load_weight_data_3_c(load_weight_data_3_c_1),
    .o_load_weight_data_3_d(load_weight_data_3_d_1),

    .o_load_weight_data_4_a(load_weight_data_4_a_1),
    .o_load_weight_data_4_b(load_weight_data_4_b_1),
    .o_load_weight_data_4_c(load_weight_data_4_c_1),
    .o_load_weight_data_4_d(load_weight_data_4_d_1),

    .o_load_weight_data_5_a(load_weight_data_5_a_1),
    .o_load_weight_data_5_b(load_weight_data_5_b_1),
    .o_load_weight_data_5_c(load_weight_data_5_c_1),
    .o_load_weight_data_5_d(load_weight_data_5_d_1),

    .o_load_weight_data_6_a(load_weight_data_6_a_1),
    .o_load_weight_data_6_b(load_weight_data_6_b_1),
    .o_load_weight_data_6_c(load_weight_data_6_c_1),
    .o_load_weight_data_6_d(load_weight_data_6_d_1),

    .o_load_weight_data_7_a(load_weight_data_7_a_1),
    .o_load_weight_data_7_b(load_weight_data_7_b_1),
    .o_load_weight_data_7_c(load_weight_data_7_c_1),
    .o_load_weight_data_7_d(load_weight_data_7_d_1),

    .o_load_weight_data_8_a(load_weight_data_8_a_1),
    .o_load_weight_data_8_b(load_weight_data_8_b_1),
    .o_load_weight_data_8_c(load_weight_data_8_c_1),
    .o_load_weight_data_8_d(load_weight_data_8_d_1),

    .o_load_weight_data_9_a(load_weight_data_9_a_1),
    .o_load_weight_data_9_b(load_weight_data_9_b_1),
    .o_load_weight_data_9_c(load_weight_data_9_c_1),
    .o_load_weight_data_9_d(load_weight_data_9_d_1),

    .o_load_weight_data_10_a(load_weight_data_10_a_1),
    .o_load_weight_data_10_b(load_weight_data_10_b_1),
    .o_load_weight_data_10_c(load_weight_data_10_c_1),
    .o_load_weight_data_10_d(load_weight_data_10_d_1),

    .o_load_weight_data_11_a(load_weight_data_11_a_1),
    .o_load_weight_data_11_b(load_weight_data_11_b_1),
    .o_load_weight_data_11_c(load_weight_data_11_c_1),
    .o_load_weight_data_11_d(load_weight_data_11_d_1),

    .o_load_weight_data_12_a(load_weight_data_12_a_1),
    .o_load_weight_data_12_b(load_weight_data_12_b_1),
    .o_load_weight_data_12_c(load_weight_data_12_c_1),
    .o_load_weight_data_12_d(load_weight_data_12_d_1),

    .o_load_weight_data_13_a(load_weight_data_13_a_1),
    .o_load_weight_data_13_b(load_weight_data_13_b_1),
    .o_load_weight_data_13_c(load_weight_data_13_c_1),
    .o_load_weight_data_13_d(load_weight_data_13_d_1),

    .o_load_weight_data_14_a(load_weight_data_14_a_1),
    .o_load_weight_data_14_b(load_weight_data_14_b_1),
    .o_load_weight_data_14_c(load_weight_data_14_c_1),
    .o_load_weight_data_14_d(load_weight_data_14_d_1),

    .o_load_weight_data_15_a(load_weight_data_15_a_1),
    .o_load_weight_data_15_b(load_weight_data_15_b_1),
    .o_load_weight_data_15_c(load_weight_data_15_c_1),
    .o_load_weight_data_15_d(load_weight_data_15_d_1),

    .o_load_weight_data_16_a(load_weight_data_16_a_1),
    .o_load_weight_data_16_b(load_weight_data_16_b_1),
    .o_load_weight_data_16_c(load_weight_data_16_c_1),
    .o_load_weight_data_16_d(load_weight_data_16_d_1),

    .o_load_weight_data_17_a(load_weight_data_17_a_1),
    .o_load_weight_data_17_b(load_weight_data_17_b_1),
    .o_load_weight_data_17_c(load_weight_data_17_c_1),
    .o_load_weight_data_17_d(load_weight_data_17_d_1),

    .o_load_weight_data_18_a(load_weight_data_18_a_1),
    .o_load_weight_data_18_b(load_weight_data_18_b_1),
    .o_load_weight_data_18_c(load_weight_data_18_c_1),
    .o_load_weight_data_18_d(load_weight_data_18_d_1),

    .o_load_weight_data_19_a(load_weight_data_19_a_1),
    .o_load_weight_data_19_b(load_weight_data_19_b_1),
    .o_load_weight_data_19_c(load_weight_data_19_c_1),
    .o_load_weight_data_19_d(load_weight_data_19_d_1),

    .o_load_weight_data_20_a(load_weight_data_20_a_1),
    .o_load_weight_data_20_b(load_weight_data_20_b_1),
    .o_load_weight_data_20_c(load_weight_data_20_c_1),
    .o_load_weight_data_20_d(load_weight_data_20_d_1),

    .o_load_weight_data_21_a(load_weight_data_21_a_1),
    .o_load_weight_data_21_b(load_weight_data_21_b_1),
    .o_load_weight_data_21_c(load_weight_data_21_c_1),
    .o_load_weight_data_21_d(load_weight_data_21_d_1),

    .o_load_weight_data_22_a(load_weight_data_22_a_1),
    .o_load_weight_data_22_b(load_weight_data_22_b_1),
    .o_load_weight_data_22_c(load_weight_data_22_c_1),
    .o_load_weight_data_22_d(load_weight_data_22_d_1),

    .o_load_weight_data_23_a(load_weight_data_23_a_1),
    .o_load_weight_data_23_b(load_weight_data_23_b_1),
    .o_load_weight_data_23_c(load_weight_data_23_c_1),
    .o_load_weight_data_23_d(load_weight_data_23_d_1),

    .o_load_weight_data_24_a(load_weight_data_24_a_1),
    .o_load_weight_data_24_b(load_weight_data_24_b_1),
    .o_load_weight_data_24_c(load_weight_data_24_c_1),
    .o_load_weight_data_24_d(load_weight_data_24_d_1),

    .o_load_weight_data_25_a(load_weight_data_25_a_1),
    .o_load_weight_data_25_b(load_weight_data_25_b_1),
    .o_load_weight_data_25_c(load_weight_data_25_c_1),
    .o_load_weight_data_25_d(load_weight_data_25_d_1),

    .o_load_weight_data_26_a(load_weight_data_26_a_1),
    .o_load_weight_data_26_b(load_weight_data_26_b_1),
    .o_load_weight_data_26_c(load_weight_data_26_c_1),
    .o_load_weight_data_26_d(load_weight_data_26_d_1),

    .o_load_weight_data_27_a(load_weight_data_27_a_1),
    .o_load_weight_data_27_b(load_weight_data_27_b_1),
    .o_load_weight_data_27_c(load_weight_data_27_c_1),
    .o_load_weight_data_27_d(load_weight_data_27_d_1),

    .o_load_weight_data_28_a(load_weight_data_28_a_1),
    .o_load_weight_data_28_b(load_weight_data_28_b_1),
    .o_load_weight_data_28_c(load_weight_data_28_c_1),
    .o_load_weight_data_28_d(load_weight_data_28_d_1),

    .o_load_weight_data_29_a(load_weight_data_29_a_1),
    .o_load_weight_data_29_b(load_weight_data_29_b_1),
    .o_load_weight_data_29_c(load_weight_data_29_c_1),
    .o_load_weight_data_29_d(load_weight_data_29_d_1),

    .o_load_weight_data_30_a(load_weight_data_30_a_1),
    .o_load_weight_data_30_b(load_weight_data_30_b_1),
    .o_load_weight_data_30_c(load_weight_data_30_c_1),
    .o_load_weight_data_30_d(load_weight_data_30_d_1),

    .o_load_weight_data_31_a(load_weight_data_31_a_1),
    .o_load_weight_data_31_b(load_weight_data_31_b_1),
    .o_load_weight_data_31_c(load_weight_data_31_c_1),
    .o_load_weight_data_31_d(load_weight_data_31_d_1)  
  );

  processing_element
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) processing_element_1(
    .clk(clk), 
    .rst_n(rst_n),
    //Write Buffer Control
    .prepare_weight(i_prepare_weight),
    .buffer_wr_en_i(buffer_wr_en_i),
    .buffer_wr_addr_i(buffer_wr_addr_i),
    
    //Execute Control
    .set_weight_i(set_weight_i),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(buffer_rd_en_0_o),
    .activation_rd_en_o(buffer_rd_en_1_o),
    .buffer_rd_addr_i(buffer_rd_addr_0_o),
    .buffer_rd_addr_o(buffer_rd_addr_1_o),
    
    .buffer_data_i(buffer_data_1_i),
  
    //mac array
    //mac adder input
    .mac_acc_a_0_i(mac_acc_0_a_0_o),   .mac_acc_b_0_i(mac_acc_0_b_0_o),   .mac_acc_c_0_i(mac_acc_0_c_0_o),  .mac_acc_d_0_i(mac_acc_0_d_0_o),
    .mac_acc_a_1_i(mac_acc_0_a_1_o),   .mac_acc_b_1_i(mac_acc_0_b_1_o),   .mac_acc_c_1_i(mac_acc_0_c_1_o),  .mac_acc_d_1_i(mac_acc_0_d_1_o),
    .mac_acc_a_2_i(mac_acc_0_a_2_o),   .mac_acc_b_2_i(mac_acc_0_b_2_o),   .mac_acc_c_2_i(mac_acc_0_c_2_o),  .mac_acc_d_2_i(mac_acc_0_d_2_o),
    .mac_acc_a_3_i(mac_acc_0_a_3_o),   .mac_acc_b_3_i(mac_acc_0_b_3_o),   .mac_acc_c_3_i(mac_acc_0_c_3_o),  .mac_acc_d_3_i(mac_acc_0_d_3_o),
    .mac_acc_a_4_i(mac_acc_0_a_4_o),   .mac_acc_b_4_i(mac_acc_0_b_4_o),   .mac_acc_c_4_i(mac_acc_0_c_4_o),  .mac_acc_d_4_i(mac_acc_0_d_4_o),
    .mac_acc_a_5_i(mac_acc_0_a_5_o),   .mac_acc_b_5_i(mac_acc_0_b_5_o),   .mac_acc_c_5_i(mac_acc_0_c_5_o),  .mac_acc_d_5_i(mac_acc_0_d_5_o),
    .mac_acc_a_6_i(mac_acc_0_a_6_o),   .mac_acc_b_6_i(mac_acc_0_b_6_o),   .mac_acc_c_6_i(mac_acc_0_c_6_o),  .mac_acc_d_6_i(mac_acc_0_d_6_o),
    .mac_acc_a_7_i(mac_acc_0_a_7_o),   .mac_acc_b_7_i(mac_acc_0_b_7_o),   .mac_acc_c_7_i(mac_acc_0_c_7_o),  .mac_acc_d_7_i(mac_acc_0_d_7_o),
    .mac_acc_a_8_i(mac_acc_0_a_8_o),   .mac_acc_b_8_i(mac_acc_0_b_8_o),   .mac_acc_c_8_i(mac_acc_0_c_8_o),  .mac_acc_d_8_i(mac_acc_0_d_8_o),
    .mac_acc_a_9_i(mac_acc_0_a_9_o),   .mac_acc_b_9_i(mac_acc_0_b_9_o),   .mac_acc_c_9_i(mac_acc_0_c_9_o),  .mac_acc_d_9_i(mac_acc_0_d_9_o),
    .mac_acc_a_10_i(mac_acc_0_a_10_o), .mac_acc_b_10_i(mac_acc_0_b_10_o), .mac_acc_c_10_i(mac_acc_0_c_10_o), .mac_acc_d_10_i(mac_acc_0_d_10_o),
    .mac_acc_a_11_i(mac_acc_0_a_11_o), .mac_acc_b_11_i(mac_acc_0_b_11_o), .mac_acc_c_11_i(mac_acc_0_c_11_o), .mac_acc_d_11_i(mac_acc_0_d_11_o),
    .mac_acc_a_12_i(mac_acc_0_a_12_o), .mac_acc_b_12_i(mac_acc_0_b_12_o), .mac_acc_c_12_i(mac_acc_0_c_12_o), .mac_acc_d_12_i(mac_acc_0_d_12_o),
    .mac_acc_a_13_i(mac_acc_0_a_13_o), .mac_acc_b_13_i(mac_acc_0_b_13_o), .mac_acc_c_13_i(mac_acc_0_c_13_o), .mac_acc_d_13_i(mac_acc_0_d_13_o),
    .mac_acc_a_14_i(mac_acc_0_a_14_o), .mac_acc_b_14_i(mac_acc_0_b_14_o), .mac_acc_c_14_i(mac_acc_0_c_14_o), .mac_acc_d_14_i(mac_acc_0_d_14_o),
    .mac_acc_a_15_i(mac_acc_0_a_15_o), .mac_acc_b_15_i(mac_acc_0_b_15_o), .mac_acc_c_15_i(mac_acc_0_c_15_o),  .mac_acc_d_15_i(mac_acc_0_d_15_o),
    //mac array output
    .mac_acc_a_0_o(mac_acc_1_a_0_o),   .mac_acc_b_0_o(mac_acc_1_b_0_o),   .mac_acc_c_0_o(mac_acc_1_c_0_o),   .mac_acc_d_0_o(mac_acc_1_d_0_o),
    .mac_acc_a_1_o(mac_acc_1_a_1_o),   .mac_acc_b_1_o(mac_acc_1_b_1_o),   .mac_acc_c_1_o(mac_acc_1_c_1_o),   .mac_acc_d_1_o(mac_acc_1_d_1_o),
    .mac_acc_a_2_o(mac_acc_1_a_2_o),   .mac_acc_b_2_o(mac_acc_1_b_2_o),   .mac_acc_c_2_o(mac_acc_1_c_2_o),   .mac_acc_d_2_o(mac_acc_1_d_2_o),
    .mac_acc_a_3_o(mac_acc_1_a_3_o),   .mac_acc_b_3_o(mac_acc_1_b_3_o),   .mac_acc_c_3_o(mac_acc_1_c_3_o),   .mac_acc_d_3_o(mac_acc_1_d_3_o),
    .mac_acc_a_4_o(mac_acc_1_a_4_o),   .mac_acc_b_4_o(mac_acc_1_b_4_o),   .mac_acc_c_4_o(mac_acc_1_c_4_o),   .mac_acc_d_4_o(mac_acc_1_d_4_o),
    .mac_acc_a_5_o(mac_acc_1_a_5_o),   .mac_acc_b_5_o(mac_acc_1_b_5_o),   .mac_acc_c_5_o(mac_acc_1_c_5_o),   .mac_acc_d_5_o(mac_acc_1_d_5_o),
    .mac_acc_a_6_o(mac_acc_1_a_6_o),   .mac_acc_b_6_o(mac_acc_1_b_6_o),   .mac_acc_c_6_o(mac_acc_1_c_6_o),   .mac_acc_d_6_o(mac_acc_1_d_6_o),
    .mac_acc_a_7_o(mac_acc_1_a_7_o),   .mac_acc_b_7_o(mac_acc_1_b_7_o),   .mac_acc_c_7_o(mac_acc_1_c_7_o),   .mac_acc_d_7_o(mac_acc_1_d_7_o),
    .mac_acc_a_8_o(mac_acc_1_a_8_o),   .mac_acc_b_8_o(mac_acc_1_b_8_o),   .mac_acc_c_8_o(mac_acc_1_c_8_o),   .mac_acc_d_8_o(mac_acc_1_d_8_o),
    .mac_acc_a_9_o(mac_acc_1_a_9_o),   .mac_acc_b_9_o(mac_acc_1_b_9_o),   .mac_acc_c_9_o(mac_acc_1_c_9_o),   .mac_acc_d_9_o(mac_acc_1_d_9_o),
    .mac_acc_a_10_o(mac_acc_1_a_10_o), .mac_acc_b_10_o(mac_acc_1_b_10_o), .mac_acc_c_10_o(mac_acc_1_c_10_o), .mac_acc_d_10_o(mac_acc_1_d_10_o),
    .mac_acc_a_11_o(mac_acc_1_a_11_o), .mac_acc_b_11_o(mac_acc_1_b_11_o), .mac_acc_c_11_o(mac_acc_1_c_11_o), .mac_acc_d_11_o(mac_acc_1_d_11_o),
    .mac_acc_a_12_o(mac_acc_1_a_12_o), .mac_acc_b_12_o(mac_acc_1_b_12_o), .mac_acc_c_12_o(mac_acc_1_c_12_o), .mac_acc_d_12_o(mac_acc_1_d_12_o),
    .mac_acc_a_13_o(mac_acc_1_a_13_o), .mac_acc_b_13_o(mac_acc_1_b_13_o), .mac_acc_c_13_o(mac_acc_1_c_13_o), .mac_acc_d_13_o(mac_acc_1_d_13_o),
    .mac_acc_a_14_o(mac_acc_1_a_14_o), .mac_acc_b_14_o(mac_acc_1_b_14_o), .mac_acc_c_14_o(mac_acc_1_c_14_o), .mac_acc_d_14_o(mac_acc_1_d_14_o),
    .mac_acc_a_15_o(mac_acc_1_a_15_o), .mac_acc_b_15_o(mac_acc_1_b_15_o), .mac_acc_c_15_o(mac_acc_1_c_15_o),  .mac_acc_d_15_o(mac_acc_1_d_15_o),



    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_1),
    .i_load_weight_data_0_b(load_weight_data_0_b_1),
    .i_load_weight_data_0_c(load_weight_data_0_c_1),
    .i_load_weight_data_0_d(load_weight_data_0_d_1),

    .i_load_weight_data_1_a(load_weight_data_1_a_1),
    .i_load_weight_data_1_b(load_weight_data_1_b_1),
    .i_load_weight_data_1_c(load_weight_data_1_c_1),
    .i_load_weight_data_1_d(load_weight_data_1_d_1),

    .i_load_weight_data_2_a(load_weight_data_2_a_1),
    .i_load_weight_data_2_b(load_weight_data_2_b_1),
    .i_load_weight_data_2_c(load_weight_data_2_c_1),
    .i_load_weight_data_2_d(load_weight_data_2_d_1),

    .i_load_weight_data_3_a(load_weight_data_3_a_1),
    .i_load_weight_data_3_b(load_weight_data_3_b_1),
    .i_load_weight_data_3_c(load_weight_data_3_c_1),
    .i_load_weight_data_3_d(load_weight_data_3_d_1),

    .i_load_weight_data_4_a(load_weight_data_4_a_1),
    .i_load_weight_data_4_b(load_weight_data_4_b_1),
    .i_load_weight_data_4_c(load_weight_data_4_c_1),
    .i_load_weight_data_4_d(load_weight_data_4_d_1),

    .i_load_weight_data_5_a(load_weight_data_5_a_1),
    .i_load_weight_data_5_b(load_weight_data_5_b_1),
    .i_load_weight_data_5_c(load_weight_data_5_c_1),
    .i_load_weight_data_5_d(load_weight_data_5_d_1),

    .i_load_weight_data_6_a(load_weight_data_6_a_1),
    .i_load_weight_data_6_b(load_weight_data_6_b_1),
    .i_load_weight_data_6_c(load_weight_data_6_c_1),
    .i_load_weight_data_6_d(load_weight_data_6_d_1),

    .i_load_weight_data_7_a(load_weight_data_7_a_1),
    .i_load_weight_data_7_b(load_weight_data_7_b_1),
    .i_load_weight_data_7_c(load_weight_data_7_c_1),
    .i_load_weight_data_7_d(load_weight_data_7_d_1),

    .i_load_weight_data_8_a(load_weight_data_8_a_1),
    .i_load_weight_data_8_b(load_weight_data_8_b_1),
    .i_load_weight_data_8_c(load_weight_data_8_c_1),
    .i_load_weight_data_8_d(load_weight_data_8_d_1),

    .i_load_weight_data_9_a(load_weight_data_9_a_1),
    .i_load_weight_data_9_b(load_weight_data_9_b_1),
    .i_load_weight_data_9_c(load_weight_data_9_c_1),
    .i_load_weight_data_9_d(load_weight_data_9_d_1),

    .i_load_weight_data_10_a(load_weight_data_10_a_1),
    .i_load_weight_data_10_b(load_weight_data_10_b_1),
    .i_load_weight_data_10_c(load_weight_data_10_c_1),
    .i_load_weight_data_10_d(load_weight_data_10_d_1),

    .i_load_weight_data_11_a(load_weight_data_11_a_1),
    .i_load_weight_data_11_b(load_weight_data_11_b_1),
    .i_load_weight_data_11_c(load_weight_data_11_c_1),
    .i_load_weight_data_11_d(load_weight_data_11_d_1),

    .i_load_weight_data_12_a(load_weight_data_12_a_1),
    .i_load_weight_data_12_b(load_weight_data_12_b_1),
    .i_load_weight_data_12_c(load_weight_data_12_c_1),
    .i_load_weight_data_12_d(load_weight_data_12_d_1),

    .i_load_weight_data_13_a(load_weight_data_13_a_1),
    .i_load_weight_data_13_b(load_weight_data_13_b_1),
    .i_load_weight_data_13_c(load_weight_data_13_c_1),
    .i_load_weight_data_13_d(load_weight_data_13_d_1),

    .i_load_weight_data_14_a(load_weight_data_14_a_1),
    .i_load_weight_data_14_b(load_weight_data_14_b_1),
    .i_load_weight_data_14_c(load_weight_data_14_c_1),
    .i_load_weight_data_14_d(load_weight_data_14_d_1),

    .i_load_weight_data_15_a(load_weight_data_15_a_1),
    .i_load_weight_data_15_b(load_weight_data_15_b_1),
    .i_load_weight_data_15_c(load_weight_data_15_c_1),
    .i_load_weight_data_15_d(load_weight_data_15_d_1),

    .i_load_weight_data_16_a(load_weight_data_16_a_1),
    .i_load_weight_data_16_b(load_weight_data_16_b_1),
    .i_load_weight_data_16_c(load_weight_data_16_c_1),
    .i_load_weight_data_16_d(load_weight_data_16_d_1),

    .i_load_weight_data_17_a(load_weight_data_17_a_1),
    .i_load_weight_data_17_b(load_weight_data_17_b_1),
    .i_load_weight_data_17_c(load_weight_data_17_c_1),
    .i_load_weight_data_17_d(load_weight_data_17_d_1),

    .i_load_weight_data_18_a(load_weight_data_18_a_1),
    .i_load_weight_data_18_b(load_weight_data_18_b_1),
    .i_load_weight_data_18_c(load_weight_data_18_c_1),
    .i_load_weight_data_18_d(load_weight_data_18_d_1),

    .i_load_weight_data_19_a(load_weight_data_19_a_1),
    .i_load_weight_data_19_b(load_weight_data_19_b_1),
    .i_load_weight_data_19_c(load_weight_data_19_c_1),
    .i_load_weight_data_19_d(load_weight_data_19_d_1),

    .i_load_weight_data_20_a(load_weight_data_20_a_1),
    .i_load_weight_data_20_b(load_weight_data_20_b_1),
    .i_load_weight_data_20_c(load_weight_data_20_c_1),
    .i_load_weight_data_20_d(load_weight_data_20_d_1),

    .i_load_weight_data_21_a(load_weight_data_21_a_1),
    .i_load_weight_data_21_b(load_weight_data_21_b_1),
    .i_load_weight_data_21_c(load_weight_data_21_c_1),
    .i_load_weight_data_21_d(load_weight_data_21_d_1),

    .i_load_weight_data_22_a(load_weight_data_22_a_1),
    .i_load_weight_data_22_b(load_weight_data_22_b_1),
    .i_load_weight_data_22_c(load_weight_data_22_c_1),
    .i_load_weight_data_22_d(load_weight_data_22_d_1),

    .i_load_weight_data_23_a(load_weight_data_23_a_1),
    .i_load_weight_data_23_b(load_weight_data_23_b_1),
    .i_load_weight_data_23_c(load_weight_data_23_c_1),
    .i_load_weight_data_23_d(load_weight_data_23_d_1),

    .i_load_weight_data_24_a(load_weight_data_24_a_1),
    .i_load_weight_data_24_b(load_weight_data_24_b_1),
    .i_load_weight_data_24_c(load_weight_data_24_c_1),
    .i_load_weight_data_24_d(load_weight_data_24_d_1),

    .i_load_weight_data_25_a(load_weight_data_25_a_1),
    .i_load_weight_data_25_b(load_weight_data_25_b_1),
    .i_load_weight_data_25_c(load_weight_data_25_c_1),
    .i_load_weight_data_25_d(load_weight_data_25_d_1),

    .i_load_weight_data_26_a(load_weight_data_26_a_1),
    .i_load_weight_data_26_b(load_weight_data_26_b_1),
    .i_load_weight_data_26_c(load_weight_data_26_c_1),
    .i_load_weight_data_26_d(load_weight_data_26_d_1),

    .i_load_weight_data_27_a(load_weight_data_27_a_1),
    .i_load_weight_data_27_b(load_weight_data_27_b_1),
    .i_load_weight_data_27_c(load_weight_data_27_c_1),
    .i_load_weight_data_27_d(load_weight_data_27_d_1),

    .i_load_weight_data_28_a(load_weight_data_28_a_1),
    .i_load_weight_data_28_b(load_weight_data_28_b_1),
    .i_load_weight_data_28_c(load_weight_data_28_c_1),
    .i_load_weight_data_28_d(load_weight_data_28_d_1),

    .i_load_weight_data_29_a(load_weight_data_29_a_1),
    .i_load_weight_data_29_b(load_weight_data_29_b_1),
    .i_load_weight_data_29_c(load_weight_data_29_c_1),
    .i_load_weight_data_29_d(load_weight_data_29_d_1),

    .i_load_weight_data_30_a(load_weight_data_30_a_1),
    .i_load_weight_data_30_b(load_weight_data_30_b_1),
    .i_load_weight_data_30_c(load_weight_data_30_c_1),
    .i_load_weight_data_30_d(load_weight_data_30_d_1),

    .i_load_weight_data_31_a(load_weight_data_31_a_1),
    .i_load_weight_data_31_b(load_weight_data_31_b_1),
    .i_load_weight_data_31_c(load_weight_data_31_c_1),
    .i_load_weight_data_31_d(load_weight_data_31_d_1),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(load_weight_data_0_a_2),
    .o_load_weight_data_0_b(load_weight_data_0_b_2),
    .o_load_weight_data_0_c(load_weight_data_0_c_2),
    .o_load_weight_data_0_d(load_weight_data_0_d_2),

    .o_load_weight_data_1_a(load_weight_data_1_a_2),
    .o_load_weight_data_1_b(load_weight_data_1_b_2),
    .o_load_weight_data_1_c(load_weight_data_1_c_2),
    .o_load_weight_data_1_d(load_weight_data_1_d_2),

    .o_load_weight_data_2_a(load_weight_data_2_a_2),
    .o_load_weight_data_2_b(load_weight_data_2_b_2),
    .o_load_weight_data_2_c(load_weight_data_2_c_2),
    .o_load_weight_data_2_d(load_weight_data_2_d_2),

    .o_load_weight_data_3_a(load_weight_data_3_a_2),
    .o_load_weight_data_3_b(load_weight_data_3_b_2),
    .o_load_weight_data_3_c(load_weight_data_3_c_2),
    .o_load_weight_data_3_d(load_weight_data_3_d_2),

    .o_load_weight_data_4_a(load_weight_data_4_a_2),
    .o_load_weight_data_4_b(load_weight_data_4_b_2),
    .o_load_weight_data_4_c(load_weight_data_4_c_2),
    .o_load_weight_data_4_d(load_weight_data_4_d_2),

    .o_load_weight_data_5_a(load_weight_data_5_a_2),
    .o_load_weight_data_5_b(load_weight_data_5_b_2),
    .o_load_weight_data_5_c(load_weight_data_5_c_2),
    .o_load_weight_data_5_d(load_weight_data_5_d_2),

    .o_load_weight_data_6_a(load_weight_data_6_a_2),
    .o_load_weight_data_6_b(load_weight_data_6_b_2),
    .o_load_weight_data_6_c(load_weight_data_6_c_2),
    .o_load_weight_data_6_d(load_weight_data_6_d_2),

    .o_load_weight_data_7_a(load_weight_data_7_a_2),
    .o_load_weight_data_7_b(load_weight_data_7_b_2),
    .o_load_weight_data_7_c(load_weight_data_7_c_2),
    .o_load_weight_data_7_d(load_weight_data_7_d_2),

    .o_load_weight_data_8_a(load_weight_data_8_a_2),
    .o_load_weight_data_8_b(load_weight_data_8_b_2),
    .o_load_weight_data_8_c(load_weight_data_8_c_2),
    .o_load_weight_data_8_d(load_weight_data_8_d_2),

    .o_load_weight_data_9_a(load_weight_data_9_a_2),
    .o_load_weight_data_9_b(load_weight_data_9_b_2),
    .o_load_weight_data_9_c(load_weight_data_9_c_2),
    .o_load_weight_data_9_d(load_weight_data_9_d_2),

    .o_load_weight_data_10_a(load_weight_data_10_a_2),
    .o_load_weight_data_10_b(load_weight_data_10_b_2),
    .o_load_weight_data_10_c(load_weight_data_10_c_2),
    .o_load_weight_data_10_d(load_weight_data_10_d_2),

    .o_load_weight_data_11_a(load_weight_data_11_a_2),
    .o_load_weight_data_11_b(load_weight_data_11_b_2),
    .o_load_weight_data_11_c(load_weight_data_11_c_2),
    .o_load_weight_data_11_d(load_weight_data_11_d_2),

    .o_load_weight_data_12_a(load_weight_data_12_a_2),
    .o_load_weight_data_12_b(load_weight_data_12_b_2),
    .o_load_weight_data_12_c(load_weight_data_12_c_2),
    .o_load_weight_data_12_d(load_weight_data_12_d_2),

    .o_load_weight_data_13_a(load_weight_data_13_a_2),
    .o_load_weight_data_13_b(load_weight_data_13_b_2),
    .o_load_weight_data_13_c(load_weight_data_13_c_2),
    .o_load_weight_data_13_d(load_weight_data_13_d_2),

    .o_load_weight_data_14_a(load_weight_data_14_a_2),
    .o_load_weight_data_14_b(load_weight_data_14_b_2),
    .o_load_weight_data_14_c(load_weight_data_14_c_2),
    .o_load_weight_data_14_d(load_weight_data_14_d_2),

    .o_load_weight_data_15_a(load_weight_data_15_a_2),
    .o_load_weight_data_15_b(load_weight_data_15_b_2),
    .o_load_weight_data_15_c(load_weight_data_15_c_2),
    .o_load_weight_data_15_d(load_weight_data_15_d_2),

    .o_load_weight_data_16_a(load_weight_data_16_a_2),
    .o_load_weight_data_16_b(load_weight_data_16_b_2),
    .o_load_weight_data_16_c(load_weight_data_16_c_2),
    .o_load_weight_data_16_d(load_weight_data_16_d_2),

    .o_load_weight_data_17_a(load_weight_data_17_a_2),
    .o_load_weight_data_17_b(load_weight_data_17_b_2),
    .o_load_weight_data_17_c(load_weight_data_17_c_2),
    .o_load_weight_data_17_d(load_weight_data_17_d_2),

    .o_load_weight_data_18_a(load_weight_data_18_a_2),
    .o_load_weight_data_18_b(load_weight_data_18_b_2),
    .o_load_weight_data_18_c(load_weight_data_18_c_2),
    .o_load_weight_data_18_d(load_weight_data_18_d_2),

    .o_load_weight_data_19_a(load_weight_data_19_a_2),
    .o_load_weight_data_19_b(load_weight_data_19_b_2),
    .o_load_weight_data_19_c(load_weight_data_19_c_2),
    .o_load_weight_data_19_d(load_weight_data_19_d_2),

    .o_load_weight_data_20_a(load_weight_data_20_a_2),
    .o_load_weight_data_20_b(load_weight_data_20_b_2),
    .o_load_weight_data_20_c(load_weight_data_20_c_2),
    .o_load_weight_data_20_d(load_weight_data_20_d_2),

    .o_load_weight_data_21_a(load_weight_data_21_a_2),
    .o_load_weight_data_21_b(load_weight_data_21_b_2),
    .o_load_weight_data_21_c(load_weight_data_21_c_2),
    .o_load_weight_data_21_d(load_weight_data_21_d_2),

    .o_load_weight_data_22_a(load_weight_data_22_a_2),
    .o_load_weight_data_22_b(load_weight_data_22_b_2),
    .o_load_weight_data_22_c(load_weight_data_22_c_2),
    .o_load_weight_data_22_d(load_weight_data_22_d_2),

    .o_load_weight_data_23_a(load_weight_data_23_a_2),
    .o_load_weight_data_23_b(load_weight_data_23_b_2),
    .o_load_weight_data_23_c(load_weight_data_23_c_2),
    .o_load_weight_data_23_d(load_weight_data_23_d_2),

    .o_load_weight_data_24_a(load_weight_data_24_a_2),
    .o_load_weight_data_24_b(load_weight_data_24_b_2),
    .o_load_weight_data_24_c(load_weight_data_24_c_2),
    .o_load_weight_data_24_d(load_weight_data_24_d_2),

    .o_load_weight_data_25_a(load_weight_data_25_a_2),
    .o_load_weight_data_25_b(load_weight_data_25_b_2),
    .o_load_weight_data_25_c(load_weight_data_25_c_2),
    .o_load_weight_data_25_d(load_weight_data_25_d_2),

    .o_load_weight_data_26_a(load_weight_data_26_a_2),
    .o_load_weight_data_26_b(load_weight_data_26_b_2),
    .o_load_weight_data_26_c(load_weight_data_26_c_2),
    .o_load_weight_data_26_d(load_weight_data_26_d_2),

    .o_load_weight_data_27_a(load_weight_data_27_a_2),
    .o_load_weight_data_27_b(load_weight_data_27_b_2),
    .o_load_weight_data_27_c(load_weight_data_27_c_2),
    .o_load_weight_data_27_d(load_weight_data_27_d_2),

    .o_load_weight_data_28_a(load_weight_data_28_a_2),
    .o_load_weight_data_28_b(load_weight_data_28_b_2),
    .o_load_weight_data_28_c(load_weight_data_28_c_2),
    .o_load_weight_data_28_d(load_weight_data_28_d_2),

    .o_load_weight_data_29_a(load_weight_data_29_a_2),
    .o_load_weight_data_29_b(load_weight_data_29_b_2),
    .o_load_weight_data_29_c(load_weight_data_29_c_2),
    .o_load_weight_data_29_d(load_weight_data_29_d_2),

    .o_load_weight_data_30_a(load_weight_data_30_a_2),
    .o_load_weight_data_30_b(load_weight_data_30_b_2),
    .o_load_weight_data_30_c(load_weight_data_30_c_2),
    .o_load_weight_data_30_d(load_weight_data_30_d_2),

    .o_load_weight_data_31_a(load_weight_data_31_a_2),
    .o_load_weight_data_31_b(load_weight_data_31_b_2),
    .o_load_weight_data_31_c(load_weight_data_31_c_2),
    .o_load_weight_data_31_d(load_weight_data_31_d_2)
  );

  processing_element
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) processing_element_2(
    .clk(clk), 
    .rst_n(rst_n),
    //Write Buffer Control
    .prepare_weight(i_prepare_weight),
    .buffer_wr_en_i(buffer_wr_en_i),
    .buffer_wr_addr_i(buffer_wr_addr_i),
    
    //Execute Control
    .set_weight_i(set_weight_i),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(buffer_rd_en_1_o),
    .activation_rd_en_o(buffer_rd_en_2_o),
    .buffer_rd_addr_i(buffer_rd_addr_1_o),
    .buffer_rd_addr_o(buffer_rd_addr_2_o),
    
    .buffer_data_i(buffer_data_2_i),
  
    //mac array
    //mac adder input
    .mac_acc_a_0_i(mac_acc_1_a_0_o),   .mac_acc_b_0_i(mac_acc_1_b_0_o),   .mac_acc_c_0_i(mac_acc_1_c_0_o),  .mac_acc_d_0_i(mac_acc_1_d_0_o),
    .mac_acc_a_1_i(mac_acc_1_a_1_o),   .mac_acc_b_1_i(mac_acc_1_b_1_o),   .mac_acc_c_1_i(mac_acc_1_c_1_o),  .mac_acc_d_1_i(mac_acc_1_d_1_o),
    .mac_acc_a_2_i(mac_acc_1_a_2_o),   .mac_acc_b_2_i(mac_acc_1_b_2_o),   .mac_acc_c_2_i(mac_acc_1_c_2_o),  .mac_acc_d_2_i(mac_acc_1_d_2_o),
    .mac_acc_a_3_i(mac_acc_1_a_3_o),   .mac_acc_b_3_i(mac_acc_1_b_3_o),   .mac_acc_c_3_i(mac_acc_1_c_3_o),  .mac_acc_d_3_i(mac_acc_1_d_3_o),
    .mac_acc_a_4_i(mac_acc_1_a_4_o),   .mac_acc_b_4_i(mac_acc_1_b_4_o),   .mac_acc_c_4_i(mac_acc_1_c_4_o),  .mac_acc_d_4_i(mac_acc_1_d_4_o),
    .mac_acc_a_5_i(mac_acc_1_a_5_o),   .mac_acc_b_5_i(mac_acc_1_b_5_o),   .mac_acc_c_5_i(mac_acc_1_c_5_o),  .mac_acc_d_5_i(mac_acc_1_d_5_o),
    .mac_acc_a_6_i(mac_acc_1_a_6_o),   .mac_acc_b_6_i(mac_acc_1_b_6_o),   .mac_acc_c_6_i(mac_acc_1_c_6_o),  .mac_acc_d_6_i(mac_acc_1_d_6_o),
    .mac_acc_a_7_i(mac_acc_1_a_7_o),   .mac_acc_b_7_i(mac_acc_1_b_7_o),   .mac_acc_c_7_i(mac_acc_1_c_7_o),  .mac_acc_d_7_i(mac_acc_1_d_7_o),
    .mac_acc_a_8_i(mac_acc_1_a_8_o),   .mac_acc_b_8_i(mac_acc_1_b_8_o),   .mac_acc_c_8_i(mac_acc_1_c_8_o),  .mac_acc_d_8_i(mac_acc_1_d_8_o),
    .mac_acc_a_9_i(mac_acc_1_a_9_o),   .mac_acc_b_9_i(mac_acc_1_b_9_o),   .mac_acc_c_9_i(mac_acc_1_c_9_o),  .mac_acc_d_9_i(mac_acc_1_d_9_o),
    .mac_acc_a_10_i(mac_acc_1_a_10_o), .mac_acc_b_10_i(mac_acc_1_b_10_o), .mac_acc_c_10_i(mac_acc_1_c_10_o), .mac_acc_d_10_i(mac_acc_1_d_10_o),
    .mac_acc_a_11_i(mac_acc_1_a_11_o), .mac_acc_b_11_i(mac_acc_1_b_11_o), .mac_acc_c_11_i(mac_acc_1_c_11_o), .mac_acc_d_11_i(mac_acc_1_d_11_o),
    .mac_acc_a_12_i(mac_acc_1_a_12_o), .mac_acc_b_12_i(mac_acc_1_b_12_o), .mac_acc_c_12_i(mac_acc_1_c_12_o), .mac_acc_d_12_i(mac_acc_1_d_12_o),
    .mac_acc_a_13_i(mac_acc_1_a_13_o), .mac_acc_b_13_i(mac_acc_1_b_13_o), .mac_acc_c_13_i(mac_acc_1_c_13_o), .mac_acc_d_13_i(mac_acc_1_d_13_o),
    .mac_acc_a_14_i(mac_acc_1_a_14_o), .mac_acc_b_14_i(mac_acc_1_b_14_o), .mac_acc_c_14_i(mac_acc_1_c_14_o), .mac_acc_d_14_i(mac_acc_1_d_14_o),
    .mac_acc_a_15_i(mac_acc_1_a_15_o), .mac_acc_b_15_i(mac_acc_1_b_15_o), .mac_acc_c_15_i(mac_acc_1_c_15_o),  .mac_acc_d_15_i(mac_acc_1_d_15_o),
    //mac array output
    .mac_acc_a_0_o(mac_acc_2_a_0_o),   .mac_acc_b_0_o(mac_acc_2_b_0_o),   .mac_acc_c_0_o(mac_acc_2_c_0_o),   .mac_acc_d_0_o(mac_acc_2_d_0_o),
    .mac_acc_a_1_o(mac_acc_2_a_1_o),   .mac_acc_b_1_o(mac_acc_2_b_1_o),   .mac_acc_c_1_o(mac_acc_2_c_1_o),   .mac_acc_d_1_o(mac_acc_2_d_1_o),
    .mac_acc_a_2_o(mac_acc_2_a_2_o),   .mac_acc_b_2_o(mac_acc_2_b_2_o),   .mac_acc_c_2_o(mac_acc_2_c_2_o),   .mac_acc_d_2_o(mac_acc_2_d_2_o),
    .mac_acc_a_3_o(mac_acc_2_a_3_o),   .mac_acc_b_3_o(mac_acc_2_b_3_o),   .mac_acc_c_3_o(mac_acc_2_c_3_o),   .mac_acc_d_3_o(mac_acc_2_d_3_o),
    .mac_acc_a_4_o(mac_acc_2_a_4_o),   .mac_acc_b_4_o(mac_acc_2_b_4_o),   .mac_acc_c_4_o(mac_acc_2_c_4_o),   .mac_acc_d_4_o(mac_acc_2_d_4_o),
    .mac_acc_a_5_o(mac_acc_2_a_5_o),   .mac_acc_b_5_o(mac_acc_2_b_5_o),   .mac_acc_c_5_o(mac_acc_2_c_5_o),   .mac_acc_d_5_o(mac_acc_2_d_5_o),
    .mac_acc_a_6_o(mac_acc_2_a_6_o),   .mac_acc_b_6_o(mac_acc_2_b_6_o),   .mac_acc_c_6_o(mac_acc_2_c_6_o),   .mac_acc_d_6_o(mac_acc_2_d_6_o),
    .mac_acc_a_7_o(mac_acc_2_a_7_o),   .mac_acc_b_7_o(mac_acc_2_b_7_o),   .mac_acc_c_7_o(mac_acc_2_c_7_o),   .mac_acc_d_7_o(mac_acc_2_d_7_o),
    .mac_acc_a_8_o(mac_acc_2_a_8_o),   .mac_acc_b_8_o(mac_acc_2_b_8_o),   .mac_acc_c_8_o(mac_acc_2_c_8_o),   .mac_acc_d_8_o(mac_acc_2_d_8_o),
    .mac_acc_a_9_o(mac_acc_2_a_9_o),   .mac_acc_b_9_o(mac_acc_2_b_9_o),   .mac_acc_c_9_o(mac_acc_2_c_9_o),   .mac_acc_d_9_o(mac_acc_2_d_9_o),
    .mac_acc_a_10_o(mac_acc_2_a_10_o), .mac_acc_b_10_o(mac_acc_2_b_10_o), .mac_acc_c_10_o(mac_acc_2_c_10_o), .mac_acc_d_10_o(mac_acc_2_d_10_o),
    .mac_acc_a_11_o(mac_acc_2_a_11_o), .mac_acc_b_11_o(mac_acc_2_b_11_o), .mac_acc_c_11_o(mac_acc_2_c_11_o), .mac_acc_d_11_o(mac_acc_2_d_11_o),
    .mac_acc_a_12_o(mac_acc_2_a_12_o), .mac_acc_b_12_o(mac_acc_2_b_12_o), .mac_acc_c_12_o(mac_acc_2_c_12_o), .mac_acc_d_12_o(mac_acc_2_d_12_o),
    .mac_acc_a_13_o(mac_acc_2_a_13_o), .mac_acc_b_13_o(mac_acc_2_b_13_o), .mac_acc_c_13_o(mac_acc_2_c_13_o), .mac_acc_d_13_o(mac_acc_2_d_13_o),
    .mac_acc_a_14_o(mac_acc_2_a_14_o), .mac_acc_b_14_o(mac_acc_2_b_14_o), .mac_acc_c_14_o(mac_acc_2_c_14_o), .mac_acc_d_14_o(mac_acc_2_d_14_o),
    .mac_acc_a_15_o(mac_acc_2_a_15_o), .mac_acc_b_15_o(mac_acc_2_b_15_o), .mac_acc_c_15_o(mac_acc_2_c_15_o),  .mac_acc_d_15_o(mac_acc_2_d_15_o),
    
    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_2),
    .i_load_weight_data_0_b(load_weight_data_0_b_2),
    .i_load_weight_data_0_c(load_weight_data_0_c_2),
    .i_load_weight_data_0_d(load_weight_data_0_d_2),

    .i_load_weight_data_1_a(load_weight_data_1_a_2),
    .i_load_weight_data_1_b(load_weight_data_1_b_2),
    .i_load_weight_data_1_c(load_weight_data_1_c_2),
    .i_load_weight_data_1_d(load_weight_data_1_d_2),

    .i_load_weight_data_2_a(load_weight_data_2_a_2),
    .i_load_weight_data_2_b(load_weight_data_2_b_2),
    .i_load_weight_data_2_c(load_weight_data_2_c_2),
    .i_load_weight_data_2_d(load_weight_data_2_d_2),

    .i_load_weight_data_3_a(load_weight_data_3_a_2),
    .i_load_weight_data_3_b(load_weight_data_3_b_2),
    .i_load_weight_data_3_c(load_weight_data_3_c_2),
    .i_load_weight_data_3_d(load_weight_data_3_d_2),

    .i_load_weight_data_4_a(load_weight_data_4_a_2),
    .i_load_weight_data_4_b(load_weight_data_4_b_2),
    .i_load_weight_data_4_c(load_weight_data_4_c_2),
    .i_load_weight_data_4_d(load_weight_data_4_d_2),

    .i_load_weight_data_5_a(load_weight_data_5_a_2),
    .i_load_weight_data_5_b(load_weight_data_5_b_2),
    .i_load_weight_data_5_c(load_weight_data_5_c_2),
    .i_load_weight_data_5_d(load_weight_data_5_d_2),

    .i_load_weight_data_6_a(load_weight_data_6_a_2),
    .i_load_weight_data_6_b(load_weight_data_6_b_2),
    .i_load_weight_data_6_c(load_weight_data_6_c_2),
    .i_load_weight_data_6_d(load_weight_data_6_d_2),

    .i_load_weight_data_7_a(load_weight_data_7_a_2),
    .i_load_weight_data_7_b(load_weight_data_7_b_2),
    .i_load_weight_data_7_c(load_weight_data_7_c_2),
    .i_load_weight_data_7_d(load_weight_data_7_d_2),

    .i_load_weight_data_8_a(load_weight_data_8_a_2),
    .i_load_weight_data_8_b(load_weight_data_8_b_2),
    .i_load_weight_data_8_c(load_weight_data_8_c_2),
    .i_load_weight_data_8_d(load_weight_data_8_d_2),

    .i_load_weight_data_9_a(load_weight_data_9_a_2),
    .i_load_weight_data_9_b(load_weight_data_9_b_2),
    .i_load_weight_data_9_c(load_weight_data_9_c_2),
    .i_load_weight_data_9_d(load_weight_data_9_d_2),

    .i_load_weight_data_10_a(load_weight_data_10_a_2),
    .i_load_weight_data_10_b(load_weight_data_10_b_2),
    .i_load_weight_data_10_c(load_weight_data_10_c_2),
    .i_load_weight_data_10_d(load_weight_data_10_d_2),

    .i_load_weight_data_11_a(load_weight_data_11_a_2),
    .i_load_weight_data_11_b(load_weight_data_11_b_2),
    .i_load_weight_data_11_c(load_weight_data_11_c_2),
    .i_load_weight_data_11_d(load_weight_data_11_d_2),

    .i_load_weight_data_12_a(load_weight_data_12_a_2),
    .i_load_weight_data_12_b(load_weight_data_12_b_2),
    .i_load_weight_data_12_c(load_weight_data_12_c_2),
    .i_load_weight_data_12_d(load_weight_data_12_d_2),

    .i_load_weight_data_13_a(load_weight_data_13_a_2),
    .i_load_weight_data_13_b(load_weight_data_13_b_2),
    .i_load_weight_data_13_c(load_weight_data_13_c_2),
    .i_load_weight_data_13_d(load_weight_data_13_d_2),

    .i_load_weight_data_14_a(load_weight_data_14_a_2),
    .i_load_weight_data_14_b(load_weight_data_14_b_2),
    .i_load_weight_data_14_c(load_weight_data_14_c_2),
    .i_load_weight_data_14_d(load_weight_data_14_d_2),

    .i_load_weight_data_15_a(load_weight_data_15_a_2),
    .i_load_weight_data_15_b(load_weight_data_15_b_2),
    .i_load_weight_data_15_c(load_weight_data_15_c_2),
    .i_load_weight_data_15_d(load_weight_data_15_d_2),

    .i_load_weight_data_16_a(load_weight_data_16_a_2),
    .i_load_weight_data_16_b(load_weight_data_16_b_2),
    .i_load_weight_data_16_c(load_weight_data_16_c_2),
    .i_load_weight_data_16_d(load_weight_data_16_d_2),

    .i_load_weight_data_17_a(load_weight_data_17_a_2),
    .i_load_weight_data_17_b(load_weight_data_17_b_2),
    .i_load_weight_data_17_c(load_weight_data_17_c_2),
    .i_load_weight_data_17_d(load_weight_data_17_d_2),

    .i_load_weight_data_18_a(load_weight_data_18_a_2),
    .i_load_weight_data_18_b(load_weight_data_18_b_2),
    .i_load_weight_data_18_c(load_weight_data_18_c_2),
    .i_load_weight_data_18_d(load_weight_data_18_d_2),

    .i_load_weight_data_19_a(load_weight_data_19_a_2),
    .i_load_weight_data_19_b(load_weight_data_19_b_2),
    .i_load_weight_data_19_c(load_weight_data_19_c_2),
    .i_load_weight_data_19_d(load_weight_data_19_d_2),

    .i_load_weight_data_20_a(load_weight_data_20_a_2),
    .i_load_weight_data_20_b(load_weight_data_20_b_2),
    .i_load_weight_data_20_c(load_weight_data_20_c_2),
    .i_load_weight_data_20_d(load_weight_data_20_d_2),

    .i_load_weight_data_21_a(load_weight_data_21_a_2),
    .i_load_weight_data_21_b(load_weight_data_21_b_2),
    .i_load_weight_data_21_c(load_weight_data_21_c_2),
    .i_load_weight_data_21_d(load_weight_data_21_d_2),

    .i_load_weight_data_22_a(load_weight_data_22_a_2),
    .i_load_weight_data_22_b(load_weight_data_22_b_2),
    .i_load_weight_data_22_c(load_weight_data_22_c_2),
    .i_load_weight_data_22_d(load_weight_data_22_d_2),

    .i_load_weight_data_23_a(load_weight_data_23_a_2),
    .i_load_weight_data_23_b(load_weight_data_23_b_2),
    .i_load_weight_data_23_c(load_weight_data_23_c_2),
    .i_load_weight_data_23_d(load_weight_data_23_d_2),

    .i_load_weight_data_24_a(load_weight_data_24_a_2),
    .i_load_weight_data_24_b(load_weight_data_24_b_2),
    .i_load_weight_data_24_c(load_weight_data_24_c_2),
    .i_load_weight_data_24_d(load_weight_data_24_d_2),

    .i_load_weight_data_25_a(load_weight_data_25_a_2),
    .i_load_weight_data_25_b(load_weight_data_25_b_2),
    .i_load_weight_data_25_c(load_weight_data_25_c_2),
    .i_load_weight_data_25_d(load_weight_data_25_d_2),

    .i_load_weight_data_26_a(load_weight_data_26_a_2),
    .i_load_weight_data_26_b(load_weight_data_26_b_2),
    .i_load_weight_data_26_c(load_weight_data_26_c_2),
    .i_load_weight_data_26_d(load_weight_data_26_d_2),

    .i_load_weight_data_27_a(load_weight_data_27_a_2),
    .i_load_weight_data_27_b(load_weight_data_27_b_2),
    .i_load_weight_data_27_c(load_weight_data_27_c_2),
    .i_load_weight_data_27_d(load_weight_data_27_d_2),

    .i_load_weight_data_28_a(load_weight_data_28_a_2),
    .i_load_weight_data_28_b(load_weight_data_28_b_2),
    .i_load_weight_data_28_c(load_weight_data_28_c_2),
    .i_load_weight_data_28_d(load_weight_data_28_d_2),

    .i_load_weight_data_29_a(load_weight_data_29_a_2),
    .i_load_weight_data_29_b(load_weight_data_29_b_2),
    .i_load_weight_data_29_c(load_weight_data_29_c_2),
    .i_load_weight_data_29_d(load_weight_data_29_d_2),

    .i_load_weight_data_30_a(load_weight_data_30_a_2),
    .i_load_weight_data_30_b(load_weight_data_30_b_2),
    .i_load_weight_data_30_c(load_weight_data_30_c_2),
    .i_load_weight_data_30_d(load_weight_data_30_d_2),

    .i_load_weight_data_31_a(load_weight_data_31_a_2),
    .i_load_weight_data_31_b(load_weight_data_31_b_2),
    .i_load_weight_data_31_c(load_weight_data_31_c_2),
    .i_load_weight_data_31_d(load_weight_data_31_d_2),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(load_weight_data_0_a_3),
    .o_load_weight_data_0_b(load_weight_data_0_b_3),
    .o_load_weight_data_0_c(load_weight_data_0_c_3),
    .o_load_weight_data_0_d(load_weight_data_0_d_3),

    .o_load_weight_data_1_a(load_weight_data_1_a_3),
    .o_load_weight_data_1_b(load_weight_data_1_b_3),
    .o_load_weight_data_1_c(load_weight_data_1_c_3),
    .o_load_weight_data_1_d(load_weight_data_1_d_3),

    .o_load_weight_data_2_a(load_weight_data_2_a_3),
    .o_load_weight_data_2_b(load_weight_data_2_b_3),
    .o_load_weight_data_2_c(load_weight_data_2_c_3),
    .o_load_weight_data_2_d(load_weight_data_2_d_3),

    .o_load_weight_data_3_a(load_weight_data_3_a_3),
    .o_load_weight_data_3_b(load_weight_data_3_b_3),
    .o_load_weight_data_3_c(load_weight_data_3_c_3),
    .o_load_weight_data_3_d(load_weight_data_3_d_3),

    .o_load_weight_data_4_a(load_weight_data_4_a_3),
    .o_load_weight_data_4_b(load_weight_data_4_b_3),
    .o_load_weight_data_4_c(load_weight_data_4_c_3),
    .o_load_weight_data_4_d(load_weight_data_4_d_3),

    .o_load_weight_data_5_a(load_weight_data_5_a_3),
    .o_load_weight_data_5_b(load_weight_data_5_b_3),
    .o_load_weight_data_5_c(load_weight_data_5_c_3),
    .o_load_weight_data_5_d(load_weight_data_5_d_3),

    .o_load_weight_data_6_a(load_weight_data_6_a_3),
    .o_load_weight_data_6_b(load_weight_data_6_b_3),
    .o_load_weight_data_6_c(load_weight_data_6_c_3),
    .o_load_weight_data_6_d(load_weight_data_6_d_3),

    .o_load_weight_data_7_a(load_weight_data_7_a_3),
    .o_load_weight_data_7_b(load_weight_data_7_b_3),
    .o_load_weight_data_7_c(load_weight_data_7_c_3),
    .o_load_weight_data_7_d(load_weight_data_7_d_3),

    .o_load_weight_data_8_a(load_weight_data_8_a_3),
    .o_load_weight_data_8_b(load_weight_data_8_b_3),
    .o_load_weight_data_8_c(load_weight_data_8_c_3),
    .o_load_weight_data_8_d(load_weight_data_8_d_3),

    .o_load_weight_data_9_a(load_weight_data_9_a_3),
    .o_load_weight_data_9_b(load_weight_data_9_b_3),
    .o_load_weight_data_9_c(load_weight_data_9_c_3),
    .o_load_weight_data_9_d(load_weight_data_9_d_3),

    .o_load_weight_data_10_a(load_weight_data_10_a_3),
    .o_load_weight_data_10_b(load_weight_data_10_b_3),
    .o_load_weight_data_10_c(load_weight_data_10_c_3),
    .o_load_weight_data_10_d(load_weight_data_10_d_3),

    .o_load_weight_data_11_a(load_weight_data_11_a_3),
    .o_load_weight_data_11_b(load_weight_data_11_b_3),
    .o_load_weight_data_11_c(load_weight_data_11_c_3),
    .o_load_weight_data_11_d(load_weight_data_11_d_3),

    .o_load_weight_data_12_a(load_weight_data_12_a_3),
    .o_load_weight_data_12_b(load_weight_data_12_b_3),
    .o_load_weight_data_12_c(load_weight_data_12_c_3),
    .o_load_weight_data_12_d(load_weight_data_12_d_3),

    .o_load_weight_data_13_a(load_weight_data_13_a_3),
    .o_load_weight_data_13_b(load_weight_data_13_b_3),
    .o_load_weight_data_13_c(load_weight_data_13_c_3),
    .o_load_weight_data_13_d(load_weight_data_13_d_3),

    .o_load_weight_data_14_a(load_weight_data_14_a_3),
    .o_load_weight_data_14_b(load_weight_data_14_b_3),
    .o_load_weight_data_14_c(load_weight_data_14_c_3),
    .o_load_weight_data_14_d(load_weight_data_14_d_3),

    .o_load_weight_data_15_a(load_weight_data_15_a_3),
    .o_load_weight_data_15_b(load_weight_data_15_b_3),
    .o_load_weight_data_15_c(load_weight_data_15_c_3),
    .o_load_weight_data_15_d(load_weight_data_15_d_3),

    .o_load_weight_data_16_a(load_weight_data_16_a_3),
    .o_load_weight_data_16_b(load_weight_data_16_b_3),
    .o_load_weight_data_16_c(load_weight_data_16_c_3),
    .o_load_weight_data_16_d(load_weight_data_16_d_3),

    .o_load_weight_data_17_a(load_weight_data_17_a_3),
    .o_load_weight_data_17_b(load_weight_data_17_b_3),
    .o_load_weight_data_17_c(load_weight_data_17_c_3),
    .o_load_weight_data_17_d(load_weight_data_17_d_3),

    .o_load_weight_data_18_a(load_weight_data_18_a_3),
    .o_load_weight_data_18_b(load_weight_data_18_b_3),
    .o_load_weight_data_18_c(load_weight_data_18_c_3),
    .o_load_weight_data_18_d(load_weight_data_18_d_3),

    .o_load_weight_data_19_a(load_weight_data_19_a_3),
    .o_load_weight_data_19_b(load_weight_data_19_b_3),
    .o_load_weight_data_19_c(load_weight_data_19_c_3),
    .o_load_weight_data_19_d(load_weight_data_19_d_3),

    .o_load_weight_data_20_a(load_weight_data_20_a_3),
    .o_load_weight_data_20_b(load_weight_data_20_b_3),
    .o_load_weight_data_20_c(load_weight_data_20_c_3),
    .o_load_weight_data_20_d(load_weight_data_20_d_3),

    .o_load_weight_data_21_a(load_weight_data_21_a_3),
    .o_load_weight_data_21_b(load_weight_data_21_b_3),
    .o_load_weight_data_21_c(load_weight_data_21_c_3),
    .o_load_weight_data_21_d(load_weight_data_21_d_3),

    .o_load_weight_data_22_a(load_weight_data_22_a_3),
    .o_load_weight_data_22_b(load_weight_data_22_b_3),
    .o_load_weight_data_22_c(load_weight_data_22_c_3),
    .o_load_weight_data_22_d(load_weight_data_22_d_3),

    .o_load_weight_data_23_a(load_weight_data_23_a_3),
    .o_load_weight_data_23_b(load_weight_data_23_b_3),
    .o_load_weight_data_23_c(load_weight_data_23_c_3),
    .o_load_weight_data_23_d(load_weight_data_23_d_3),

    .o_load_weight_data_24_a(load_weight_data_24_a_3),
    .o_load_weight_data_24_b(load_weight_data_24_b_3),
    .o_load_weight_data_24_c(load_weight_data_24_c_3),
    .o_load_weight_data_24_d(load_weight_data_24_d_3),

    .o_load_weight_data_25_a(load_weight_data_25_a_3),
    .o_load_weight_data_25_b(load_weight_data_25_b_3),
    .o_load_weight_data_25_c(load_weight_data_25_c_3),
    .o_load_weight_data_25_d(load_weight_data_25_d_3),

    .o_load_weight_data_26_a(load_weight_data_26_a_3),
    .o_load_weight_data_26_b(load_weight_data_26_b_3),
    .o_load_weight_data_26_c(load_weight_data_26_c_3),
    .o_load_weight_data_26_d(load_weight_data_26_d_3),

    .o_load_weight_data_27_a(load_weight_data_27_a_3),
    .o_load_weight_data_27_b(load_weight_data_27_b_3),
    .o_load_weight_data_27_c(load_weight_data_27_c_3),
    .o_load_weight_data_27_d(load_weight_data_27_d_3),

    .o_load_weight_data_28_a(load_weight_data_28_a_3),
    .o_load_weight_data_28_b(load_weight_data_28_b_3),
    .o_load_weight_data_28_c(load_weight_data_28_c_3),
    .o_load_weight_data_28_d(load_weight_data_28_d_3),

    .o_load_weight_data_29_a(load_weight_data_29_a_3),
    .o_load_weight_data_29_b(load_weight_data_29_b_3),
    .o_load_weight_data_29_c(load_weight_data_29_c_3),
    .o_load_weight_data_29_d(load_weight_data_29_d_3),

    .o_load_weight_data_30_a(load_weight_data_30_a_3),
    .o_load_weight_data_30_b(load_weight_data_30_b_3),
    .o_load_weight_data_30_c(load_weight_data_30_c_3),
    .o_load_weight_data_30_d(load_weight_data_30_d_3),

    .o_load_weight_data_31_a(load_weight_data_31_a_3),
    .o_load_weight_data_31_b(load_weight_data_31_b_3),
    .o_load_weight_data_31_c(load_weight_data_31_c_3),
    .o_load_weight_data_31_d(load_weight_data_31_d_3)  
  );

  processing_element
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) processing_element_3(
    .clk(clk), 
    .rst_n(rst_n),
    //Write Buffer Control
    .prepare_weight(i_prepare_weight), 
    .buffer_wr_en_i(buffer_wr_en_i),
    .buffer_wr_addr_i(buffer_wr_addr_i),
    
    //Execute Control
    .set_weight_i(set_weight_i),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(buffer_rd_en_2_o),
    .activation_rd_en_o(buffer_rd_en_3_o),
    .buffer_rd_addr_i(buffer_rd_addr_2_o),
    .buffer_rd_addr_o(buffer_rd_addr_3_o),    
    
    .buffer_data_i(buffer_data_3_i),
  
    //mac array
    //mac adder input
    .mac_acc_a_0_i(mac_acc_2_a_0_o),   .mac_acc_b_0_i(mac_acc_2_b_0_o),   .mac_acc_c_0_i(mac_acc_2_c_0_o),  .mac_acc_d_0_i(mac_acc_2_d_0_o),
    .mac_acc_a_1_i(mac_acc_2_a_1_o),   .mac_acc_b_1_i(mac_acc_2_b_1_o),   .mac_acc_c_1_i(mac_acc_2_c_1_o),  .mac_acc_d_1_i(mac_acc_2_d_1_o),
    .mac_acc_a_2_i(mac_acc_2_a_2_o),   .mac_acc_b_2_i(mac_acc_2_b_2_o),   .mac_acc_c_2_i(mac_acc_2_c_2_o),  .mac_acc_d_2_i(mac_acc_2_d_2_o),
    .mac_acc_a_3_i(mac_acc_2_a_3_o),   .mac_acc_b_3_i(mac_acc_2_b_3_o),   .mac_acc_c_3_i(mac_acc_2_c_3_o),  .mac_acc_d_3_i(mac_acc_2_d_3_o),
    .mac_acc_a_4_i(mac_acc_2_a_4_o),   .mac_acc_b_4_i(mac_acc_2_b_4_o),   .mac_acc_c_4_i(mac_acc_2_c_4_o),  .mac_acc_d_4_i(mac_acc_2_d_4_o),
    .mac_acc_a_5_i(mac_acc_2_a_5_o),   .mac_acc_b_5_i(mac_acc_2_b_5_o),   .mac_acc_c_5_i(mac_acc_2_c_5_o),  .mac_acc_d_5_i(mac_acc_2_d_5_o),
    .mac_acc_a_6_i(mac_acc_2_a_6_o),   .mac_acc_b_6_i(mac_acc_2_b_6_o),   .mac_acc_c_6_i(mac_acc_2_c_6_o),  .mac_acc_d_6_i(mac_acc_2_d_6_o),
    .mac_acc_a_7_i(mac_acc_2_a_7_o),   .mac_acc_b_7_i(mac_acc_2_b_7_o),   .mac_acc_c_7_i(mac_acc_2_c_7_o),  .mac_acc_d_7_i(mac_acc_2_d_7_o),
    .mac_acc_a_8_i(mac_acc_2_a_8_o),   .mac_acc_b_8_i(mac_acc_2_b_8_o),   .mac_acc_c_8_i(mac_acc_2_c_8_o),  .mac_acc_d_8_i(mac_acc_2_d_8_o),
    .mac_acc_a_9_i(mac_acc_2_a_9_o),   .mac_acc_b_9_i(mac_acc_2_b_9_o),   .mac_acc_c_9_i(mac_acc_2_c_9_o),  .mac_acc_d_9_i(mac_acc_2_d_9_o),
    .mac_acc_a_10_i(mac_acc_2_a_10_o), .mac_acc_b_10_i(mac_acc_2_b_10_o), .mac_acc_c_10_i(mac_acc_2_c_10_o), .mac_acc_d_10_i(mac_acc_2_d_10_o),
    .mac_acc_a_11_i(mac_acc_2_a_11_o), .mac_acc_b_11_i(mac_acc_2_b_11_o), .mac_acc_c_11_i(mac_acc_2_c_11_o), .mac_acc_d_11_i(mac_acc_2_d_11_o),
    .mac_acc_a_12_i(mac_acc_2_a_12_o), .mac_acc_b_12_i(mac_acc_2_b_12_o), .mac_acc_c_12_i(mac_acc_2_c_12_o), .mac_acc_d_12_i(mac_acc_2_d_12_o),
    .mac_acc_a_13_i(mac_acc_2_a_13_o), .mac_acc_b_13_i(mac_acc_2_b_13_o), .mac_acc_c_13_i(mac_acc_2_c_13_o), .mac_acc_d_13_i(mac_acc_2_d_13_o),
    .mac_acc_a_14_i(mac_acc_2_a_14_o), .mac_acc_b_14_i(mac_acc_2_b_14_o), .mac_acc_c_14_i(mac_acc_2_c_14_o), .mac_acc_d_14_i(mac_acc_2_d_14_o),
    .mac_acc_a_15_i(mac_acc_2_a_15_o), .mac_acc_b_15_i(mac_acc_2_b_15_o), .mac_acc_c_15_i(mac_acc_2_c_15_o),  .mac_acc_d_15_i(mac_acc_2_d_15_o),
    //mac array output
    .mac_acc_a_0_o(mac_acc_3_a_0_o),   .mac_acc_b_0_o(mac_acc_3_b_0_o),   .mac_acc_c_0_o(mac_acc_3_c_0_o),   .mac_acc_d_0_o(mac_acc_3_d_0_o),
    .mac_acc_a_1_o(mac_acc_3_a_1_o),   .mac_acc_b_1_o(mac_acc_3_b_1_o),   .mac_acc_c_1_o(mac_acc_3_c_1_o),   .mac_acc_d_1_o(mac_acc_3_d_1_o),
    .mac_acc_a_2_o(mac_acc_3_a_2_o),   .mac_acc_b_2_o(mac_acc_3_b_2_o),   .mac_acc_c_2_o(mac_acc_3_c_2_o),   .mac_acc_d_2_o(mac_acc_3_d_2_o),
    .mac_acc_a_3_o(mac_acc_3_a_3_o),   .mac_acc_b_3_o(mac_acc_3_b_3_o),   .mac_acc_c_3_o(mac_acc_3_c_3_o),   .mac_acc_d_3_o(mac_acc_3_d_3_o),
    .mac_acc_a_4_o(mac_acc_3_a_4_o),   .mac_acc_b_4_o(mac_acc_3_b_4_o),   .mac_acc_c_4_o(mac_acc_3_c_4_o),   .mac_acc_d_4_o(mac_acc_3_d_4_o),
    .mac_acc_a_5_o(mac_acc_3_a_5_o),   .mac_acc_b_5_o(mac_acc_3_b_5_o),   .mac_acc_c_5_o(mac_acc_3_c_5_o),   .mac_acc_d_5_o(mac_acc_3_d_5_o),
    .mac_acc_a_6_o(mac_acc_3_a_6_o),   .mac_acc_b_6_o(mac_acc_3_b_6_o),   .mac_acc_c_6_o(mac_acc_3_c_6_o),   .mac_acc_d_6_o(mac_acc_3_d_6_o),
    .mac_acc_a_7_o(mac_acc_3_a_7_o),   .mac_acc_b_7_o(mac_acc_3_b_7_o),   .mac_acc_c_7_o(mac_acc_3_c_7_o),   .mac_acc_d_7_o(mac_acc_3_d_7_o),
    .mac_acc_a_8_o(mac_acc_3_a_8_o),   .mac_acc_b_8_o(mac_acc_3_b_8_o),   .mac_acc_c_8_o(mac_acc_3_c_8_o),   .mac_acc_d_8_o(mac_acc_3_d_8_o),
    .mac_acc_a_9_o(mac_acc_3_a_9_o),   .mac_acc_b_9_o(mac_acc_3_b_9_o),   .mac_acc_c_9_o(mac_acc_3_c_9_o),   .mac_acc_d_9_o(mac_acc_3_d_9_o),
    .mac_acc_a_10_o(mac_acc_3_a_10_o), .mac_acc_b_10_o(mac_acc_3_b_10_o), .mac_acc_c_10_o(mac_acc_3_c_10_o), .mac_acc_d_10_o(mac_acc_3_d_10_o),
    .mac_acc_a_11_o(mac_acc_3_a_11_o), .mac_acc_b_11_o(mac_acc_3_b_11_o), .mac_acc_c_11_o(mac_acc_3_c_11_o), .mac_acc_d_11_o(mac_acc_3_d_11_o),
    .mac_acc_a_12_o(mac_acc_3_a_12_o), .mac_acc_b_12_o(mac_acc_3_b_12_o), .mac_acc_c_12_o(mac_acc_3_c_12_o), .mac_acc_d_12_o(mac_acc_3_d_12_o),
    .mac_acc_a_13_o(mac_acc_3_a_13_o), .mac_acc_b_13_o(mac_acc_3_b_13_o), .mac_acc_c_13_o(mac_acc_3_c_13_o), .mac_acc_d_13_o(mac_acc_3_d_13_o),
    .mac_acc_a_14_o(mac_acc_3_a_14_o), .mac_acc_b_14_o(mac_acc_3_b_14_o), .mac_acc_c_14_o(mac_acc_3_c_14_o), .mac_acc_d_14_o(mac_acc_3_d_14_o),
    .mac_acc_a_15_o(mac_acc_3_a_15_o), .mac_acc_b_15_o(mac_acc_3_b_15_o), .mac_acc_c_15_o(mac_acc_3_c_15_o),  .mac_acc_d_15_o(mac_acc_3_d_15_o),

    
    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_3),
    .i_load_weight_data_0_b(load_weight_data_0_b_3),
    .i_load_weight_data_0_c(load_weight_data_0_c_3),
    .i_load_weight_data_0_d(load_weight_data_0_d_3),

    .i_load_weight_data_1_a(load_weight_data_1_a_3),
    .i_load_weight_data_1_b(load_weight_data_1_b_3),
    .i_load_weight_data_1_c(load_weight_data_1_c_3),
    .i_load_weight_data_1_d(load_weight_data_1_d_3),

    .i_load_weight_data_2_a(load_weight_data_2_a_3),
    .i_load_weight_data_2_b(load_weight_data_2_b_3),
    .i_load_weight_data_2_c(load_weight_data_2_c_3),
    .i_load_weight_data_2_d(load_weight_data_2_d_3),

    .i_load_weight_data_3_a(load_weight_data_3_a_3),
    .i_load_weight_data_3_b(load_weight_data_3_b_3),
    .i_load_weight_data_3_c(load_weight_data_3_c_3),
    .i_load_weight_data_3_d(load_weight_data_3_d_3),

    .i_load_weight_data_4_a(load_weight_data_4_a_3),
    .i_load_weight_data_4_b(load_weight_data_4_b_3),
    .i_load_weight_data_4_c(load_weight_data_4_c_3),
    .i_load_weight_data_4_d(load_weight_data_4_d_3),

    .i_load_weight_data_5_a(load_weight_data_5_a_3),
    .i_load_weight_data_5_b(load_weight_data_5_b_3),
    .i_load_weight_data_5_c(load_weight_data_5_c_3),
    .i_load_weight_data_5_d(load_weight_data_5_d_3),

    .i_load_weight_data_6_a(load_weight_data_6_a_3),
    .i_load_weight_data_6_b(load_weight_data_6_b_3),
    .i_load_weight_data_6_c(load_weight_data_6_c_3),
    .i_load_weight_data_6_d(load_weight_data_6_d_3),

    .i_load_weight_data_7_a(load_weight_data_7_a_3),
    .i_load_weight_data_7_b(load_weight_data_7_b_3),
    .i_load_weight_data_7_c(load_weight_data_7_c_3),
    .i_load_weight_data_7_d(load_weight_data_7_d_3),

    .i_load_weight_data_8_a(load_weight_data_8_a_3),
    .i_load_weight_data_8_b(load_weight_data_8_b_3),
    .i_load_weight_data_8_c(load_weight_data_8_c_3),
    .i_load_weight_data_8_d(load_weight_data_8_d_3),

    .i_load_weight_data_9_a(load_weight_data_9_a_3),
    .i_load_weight_data_9_b(load_weight_data_9_b_3),
    .i_load_weight_data_9_c(load_weight_data_9_c_3),
    .i_load_weight_data_9_d(load_weight_data_9_d_3),

    .i_load_weight_data_10_a(load_weight_data_10_a_3),
    .i_load_weight_data_10_b(load_weight_data_10_b_3),
    .i_load_weight_data_10_c(load_weight_data_10_c_3),
    .i_load_weight_data_10_d(load_weight_data_10_d_3),

    .i_load_weight_data_11_a(load_weight_data_11_a_3),
    .i_load_weight_data_11_b(load_weight_data_11_b_3),
    .i_load_weight_data_11_c(load_weight_data_11_c_3),
    .i_load_weight_data_11_d(load_weight_data_11_d_3),

    .i_load_weight_data_12_a(load_weight_data_12_a_3),
    .i_load_weight_data_12_b(load_weight_data_12_b_3),
    .i_load_weight_data_12_c(load_weight_data_12_c_3),
    .i_load_weight_data_12_d(load_weight_data_12_d_3),

    .i_load_weight_data_13_a(load_weight_data_13_a_3),
    .i_load_weight_data_13_b(load_weight_data_13_b_3),
    .i_load_weight_data_13_c(load_weight_data_13_c_3),
    .i_load_weight_data_13_d(load_weight_data_13_d_3),

    .i_load_weight_data_14_a(load_weight_data_14_a_3),
    .i_load_weight_data_14_b(load_weight_data_14_b_3),
    .i_load_weight_data_14_c(load_weight_data_14_c_3),
    .i_load_weight_data_14_d(load_weight_data_14_d_3),

    .i_load_weight_data_15_a(load_weight_data_15_a_3),
    .i_load_weight_data_15_b(load_weight_data_15_b_3),
    .i_load_weight_data_15_c(load_weight_data_15_c_3),
    .i_load_weight_data_15_d(load_weight_data_15_d_3),

    .i_load_weight_data_16_a(load_weight_data_16_a_3),
    .i_load_weight_data_16_b(load_weight_data_16_b_3),
    .i_load_weight_data_16_c(load_weight_data_16_c_3),
    .i_load_weight_data_16_d(load_weight_data_16_d_3),

    .i_load_weight_data_17_a(load_weight_data_17_a_3),
    .i_load_weight_data_17_b(load_weight_data_17_b_3),
    .i_load_weight_data_17_c(load_weight_data_17_c_3),
    .i_load_weight_data_17_d(load_weight_data_17_d_3),

    .i_load_weight_data_18_a(load_weight_data_18_a_3),
    .i_load_weight_data_18_b(load_weight_data_18_b_3),
    .i_load_weight_data_18_c(load_weight_data_18_c_3),
    .i_load_weight_data_18_d(load_weight_data_18_d_3),

    .i_load_weight_data_19_a(load_weight_data_19_a_3),
    .i_load_weight_data_19_b(load_weight_data_19_b_3),
    .i_load_weight_data_19_c(load_weight_data_19_c_3),
    .i_load_weight_data_19_d(load_weight_data_19_d_3),

    .i_load_weight_data_20_a(load_weight_data_20_a_3),
    .i_load_weight_data_20_b(load_weight_data_20_b_3),
    .i_load_weight_data_20_c(load_weight_data_20_c_3),
    .i_load_weight_data_20_d(load_weight_data_20_d_3),

    .i_load_weight_data_21_a(load_weight_data_21_a_3),
    .i_load_weight_data_21_b(load_weight_data_21_b_3),
    .i_load_weight_data_21_c(load_weight_data_21_c_3),
    .i_load_weight_data_21_d(load_weight_data_21_d_3),

    .i_load_weight_data_22_a(load_weight_data_22_a_3),
    .i_load_weight_data_22_b(load_weight_data_22_b_3),
    .i_load_weight_data_22_c(load_weight_data_22_c_3),
    .i_load_weight_data_22_d(load_weight_data_22_d_3),

    .i_load_weight_data_23_a(load_weight_data_23_a_3),
    .i_load_weight_data_23_b(load_weight_data_23_b_3),
    .i_load_weight_data_23_c(load_weight_data_23_c_3),
    .i_load_weight_data_23_d(load_weight_data_23_d_3),

    .i_load_weight_data_24_a(load_weight_data_24_a_3),
    .i_load_weight_data_24_b(load_weight_data_24_b_3),
    .i_load_weight_data_24_c(load_weight_data_24_c_3),
    .i_load_weight_data_24_d(load_weight_data_24_d_3),

    .i_load_weight_data_25_a(load_weight_data_25_a_3),
    .i_load_weight_data_25_b(load_weight_data_25_b_3),
    .i_load_weight_data_25_c(load_weight_data_25_c_3),
    .i_load_weight_data_25_d(load_weight_data_25_d_3),

    .i_load_weight_data_26_a(load_weight_data_26_a_3),
    .i_load_weight_data_26_b(load_weight_data_26_b_3),
    .i_load_weight_data_26_c(load_weight_data_26_c_3),
    .i_load_weight_data_26_d(load_weight_data_26_d_3),

    .i_load_weight_data_27_a(load_weight_data_27_a_3),
    .i_load_weight_data_27_b(load_weight_data_27_b_3),
    .i_load_weight_data_27_c(load_weight_data_27_c_3),
    .i_load_weight_data_27_d(load_weight_data_27_d_3),

    .i_load_weight_data_28_a(load_weight_data_28_a_3),
    .i_load_weight_data_28_b(load_weight_data_28_b_3),
    .i_load_weight_data_28_c(load_weight_data_28_c_3),
    .i_load_weight_data_28_d(load_weight_data_28_d_3),

    .i_load_weight_data_29_a(load_weight_data_29_a_3),
    .i_load_weight_data_29_b(load_weight_data_29_b_3),
    .i_load_weight_data_29_c(load_weight_data_29_c_3),
    .i_load_weight_data_29_d(load_weight_data_29_d_3),

    .i_load_weight_data_30_a(load_weight_data_30_a_3),
    .i_load_weight_data_30_b(load_weight_data_30_b_3),
    .i_load_weight_data_30_c(load_weight_data_30_c_3),
    .i_load_weight_data_30_d(load_weight_data_30_d_3),

    .i_load_weight_data_31_a(load_weight_data_31_a_3),
    .i_load_weight_data_31_b(load_weight_data_31_b_3),
    .i_load_weight_data_31_c(load_weight_data_31_c_3),
    .i_load_weight_data_31_d(load_weight_data_31_d_3),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(load_weight_data_0_a_4),
    .o_load_weight_data_0_b(load_weight_data_0_b_4),
    .o_load_weight_data_0_c(load_weight_data_0_c_4),
    .o_load_weight_data_0_d(load_weight_data_0_d_4),

    .o_load_weight_data_1_a(load_weight_data_1_a_4),
    .o_load_weight_data_1_b(load_weight_data_1_b_4),
    .o_load_weight_data_1_c(load_weight_data_1_c_4),
    .o_load_weight_data_1_d(load_weight_data_1_d_4),

    .o_load_weight_data_2_a(load_weight_data_2_a_4),
    .o_load_weight_data_2_b(load_weight_data_2_b_4),
    .o_load_weight_data_2_c(load_weight_data_2_c_4),
    .o_load_weight_data_2_d(load_weight_data_2_d_4),

    .o_load_weight_data_3_a(load_weight_data_3_a_4),
    .o_load_weight_data_3_b(load_weight_data_3_b_4),
    .o_load_weight_data_3_c(load_weight_data_3_c_4),
    .o_load_weight_data_3_d(load_weight_data_3_d_4),

    .o_load_weight_data_4_a(load_weight_data_4_a_4),
    .o_load_weight_data_4_b(load_weight_data_4_b_4),
    .o_load_weight_data_4_c(load_weight_data_4_c_4),
    .o_load_weight_data_4_d(load_weight_data_4_d_4),

    .o_load_weight_data_5_a(load_weight_data_5_a_4),
    .o_load_weight_data_5_b(load_weight_data_5_b_4),
    .o_load_weight_data_5_c(load_weight_data_5_c_4),
    .o_load_weight_data_5_d(load_weight_data_5_d_4),

    .o_load_weight_data_6_a(load_weight_data_6_a_4),
    .o_load_weight_data_6_b(load_weight_data_6_b_4),
    .o_load_weight_data_6_c(load_weight_data_6_c_4),
    .o_load_weight_data_6_d(load_weight_data_6_d_4),

    .o_load_weight_data_7_a(load_weight_data_7_a_4),
    .o_load_weight_data_7_b(load_weight_data_7_b_4),
    .o_load_weight_data_7_c(load_weight_data_7_c_4),
    .o_load_weight_data_7_d(load_weight_data_7_d_4),

    .o_load_weight_data_8_a(load_weight_data_8_a_4),
    .o_load_weight_data_8_b(load_weight_data_8_b_4),
    .o_load_weight_data_8_c(load_weight_data_8_c_4),
    .o_load_weight_data_8_d(load_weight_data_8_d_4),

    .o_load_weight_data_9_a(load_weight_data_9_a_4),
    .o_load_weight_data_9_b(load_weight_data_9_b_4),
    .o_load_weight_data_9_c(load_weight_data_9_c_4),
    .o_load_weight_data_9_d(load_weight_data_9_d_4),

    .o_load_weight_data_10_a(load_weight_data_10_a_4),
    .o_load_weight_data_10_b(load_weight_data_10_b_4),
    .o_load_weight_data_10_c(load_weight_data_10_c_4),
    .o_load_weight_data_10_d(load_weight_data_10_d_4),

    .o_load_weight_data_11_a(load_weight_data_11_a_4),
    .o_load_weight_data_11_b(load_weight_data_11_b_4),
    .o_load_weight_data_11_c(load_weight_data_11_c_4),
    .o_load_weight_data_11_d(load_weight_data_11_d_4),

    .o_load_weight_data_12_a(load_weight_data_12_a_4),
    .o_load_weight_data_12_b(load_weight_data_12_b_4),
    .o_load_weight_data_12_c(load_weight_data_12_c_4),
    .o_load_weight_data_12_d(load_weight_data_12_d_4),

    .o_load_weight_data_13_a(load_weight_data_13_a_4),
    .o_load_weight_data_13_b(load_weight_data_13_b_4),
    .o_load_weight_data_13_c(load_weight_data_13_c_4),
    .o_load_weight_data_13_d(load_weight_data_13_d_4),

    .o_load_weight_data_14_a(load_weight_data_14_a_4),
    .o_load_weight_data_14_b(load_weight_data_14_b_4),
    .o_load_weight_data_14_c(load_weight_data_14_c_4),
    .o_load_weight_data_14_d(load_weight_data_14_d_4),

    .o_load_weight_data_15_a(load_weight_data_15_a_4),
    .o_load_weight_data_15_b(load_weight_data_15_b_4),
    .o_load_weight_data_15_c(load_weight_data_15_c_4),
    .o_load_weight_data_15_d(load_weight_data_15_d_4),

    .o_load_weight_data_16_a(load_weight_data_16_a_4),
    .o_load_weight_data_16_b(load_weight_data_16_b_4),
    .o_load_weight_data_16_c(load_weight_data_16_c_4),
    .o_load_weight_data_16_d(load_weight_data_16_d_4),

    .o_load_weight_data_17_a(load_weight_data_17_a_4),
    .o_load_weight_data_17_b(load_weight_data_17_b_4),
    .o_load_weight_data_17_c(load_weight_data_17_c_4),
    .o_load_weight_data_17_d(load_weight_data_17_d_4),

    .o_load_weight_data_18_a(load_weight_data_18_a_4),
    .o_load_weight_data_18_b(load_weight_data_18_b_4),
    .o_load_weight_data_18_c(load_weight_data_18_c_4),
    .o_load_weight_data_18_d(load_weight_data_18_d_4),

    .o_load_weight_data_19_a(load_weight_data_19_a_4),
    .o_load_weight_data_19_b(load_weight_data_19_b_4),
    .o_load_weight_data_19_c(load_weight_data_19_c_4),
    .o_load_weight_data_19_d(load_weight_data_19_d_4),

    .o_load_weight_data_20_a(load_weight_data_20_a_4),
    .o_load_weight_data_20_b(load_weight_data_20_b_4),
    .o_load_weight_data_20_c(load_weight_data_20_c_4),
    .o_load_weight_data_20_d(load_weight_data_20_d_4),

    .o_load_weight_data_21_a(load_weight_data_21_a_4),
    .o_load_weight_data_21_b(load_weight_data_21_b_4),
    .o_load_weight_data_21_c(load_weight_data_21_c_4),
    .o_load_weight_data_21_d(load_weight_data_21_d_4),

    .o_load_weight_data_22_a(load_weight_data_22_a_4),
    .o_load_weight_data_22_b(load_weight_data_22_b_4),
    .o_load_weight_data_22_c(load_weight_data_22_c_4),
    .o_load_weight_data_22_d(load_weight_data_22_d_4),

    .o_load_weight_data_23_a(load_weight_data_23_a_4),
    .o_load_weight_data_23_b(load_weight_data_23_b_4),
    .o_load_weight_data_23_c(load_weight_data_23_c_4),
    .o_load_weight_data_23_d(load_weight_data_23_d_4),

    .o_load_weight_data_24_a(load_weight_data_24_a_4),
    .o_load_weight_data_24_b(load_weight_data_24_b_4),
    .o_load_weight_data_24_c(load_weight_data_24_c_4),
    .o_load_weight_data_24_d(load_weight_data_24_d_4),

    .o_load_weight_data_25_a(load_weight_data_25_a_4),
    .o_load_weight_data_25_b(load_weight_data_25_b_4),
    .o_load_weight_data_25_c(load_weight_data_25_c_4),
    .o_load_weight_data_25_d(load_weight_data_25_d_4),

    .o_load_weight_data_26_a(load_weight_data_26_a_4),
    .o_load_weight_data_26_b(load_weight_data_26_b_4),
    .o_load_weight_data_26_c(load_weight_data_26_c_4),
    .o_load_weight_data_26_d(load_weight_data_26_d_4),

    .o_load_weight_data_27_a(load_weight_data_27_a_4),
    .o_load_weight_data_27_b(load_weight_data_27_b_4),
    .o_load_weight_data_27_c(load_weight_data_27_c_4),
    .o_load_weight_data_27_d(load_weight_data_27_d_4),

    .o_load_weight_data_28_a(load_weight_data_28_a_4),
    .o_load_weight_data_28_b(load_weight_data_28_b_4),
    .o_load_weight_data_28_c(load_weight_data_28_c_4),
    .o_load_weight_data_28_d(load_weight_data_28_d_4),

    .o_load_weight_data_29_a(load_weight_data_29_a_4),
    .o_load_weight_data_29_b(load_weight_data_29_b_4),
    .o_load_weight_data_29_c(load_weight_data_29_c_4),
    .o_load_weight_data_29_d(load_weight_data_29_d_4),

    .o_load_weight_data_30_a(load_weight_data_30_a_4),
    .o_load_weight_data_30_b(load_weight_data_30_b_4),
    .o_load_weight_data_30_c(load_weight_data_30_c_4),
    .o_load_weight_data_30_d(load_weight_data_30_d_4),

    .o_load_weight_data_31_a(load_weight_data_31_a_4),
    .o_load_weight_data_31_b(load_weight_data_31_b_4),
    .o_load_weight_data_31_c(load_weight_data_31_c_4),
    .o_load_weight_data_31_d(load_weight_data_31_d_4)  
  );

  processing_element
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) processing_element_4(
    .clk(clk), 
    .rst_n(rst_n),
    
    //Write Buffer Control
    .prepare_weight(i_prepare_weight),
    .buffer_wr_en_i(buffer_wr_en_i),
    .buffer_wr_addr_i(buffer_wr_addr_i),
    
    //Execute Control
    .set_weight_i(set_weight_i),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(buffer_rd_en_3_o),
    .activation_rd_en_o(buffer_rd_en_4_o),
    .buffer_rd_addr_i(buffer_rd_addr_3_o),
    .buffer_rd_addr_o(buffer_rd_addr_4_o),        
    
    .buffer_data_i(buffer_data_4_i),
  
    //mac array
    //mac adder input
    .mac_acc_a_0_i(mac_acc_3_a_0_o),   .mac_acc_b_0_i(mac_acc_3_b_0_o),   .mac_acc_c_0_i(mac_acc_3_c_0_o),  .mac_acc_d_0_i(mac_acc_3_d_0_o),
    .mac_acc_a_1_i(mac_acc_3_a_1_o),   .mac_acc_b_1_i(mac_acc_3_b_1_o),   .mac_acc_c_1_i(mac_acc_3_c_1_o),  .mac_acc_d_1_i(mac_acc_3_d_1_o),
    .mac_acc_a_2_i(mac_acc_3_a_2_o),   .mac_acc_b_2_i(mac_acc_3_b_2_o),   .mac_acc_c_2_i(mac_acc_3_c_2_o),  .mac_acc_d_2_i(mac_acc_3_d_2_o),
    .mac_acc_a_3_i(mac_acc_3_a_3_o),   .mac_acc_b_3_i(mac_acc_3_b_3_o),   .mac_acc_c_3_i(mac_acc_3_c_3_o),  .mac_acc_d_3_i(mac_acc_3_d_3_o),
    .mac_acc_a_4_i(mac_acc_3_a_4_o),   .mac_acc_b_4_i(mac_acc_3_b_4_o),   .mac_acc_c_4_i(mac_acc_3_c_4_o),  .mac_acc_d_4_i(mac_acc_3_d_4_o),
    .mac_acc_a_5_i(mac_acc_3_a_5_o),   .mac_acc_b_5_i(mac_acc_3_b_5_o),   .mac_acc_c_5_i(mac_acc_3_c_5_o),  .mac_acc_d_5_i(mac_acc_3_d_5_o),
    .mac_acc_a_6_i(mac_acc_3_a_6_o),   .mac_acc_b_6_i(mac_acc_3_b_6_o),   .mac_acc_c_6_i(mac_acc_3_c_6_o),  .mac_acc_d_6_i(mac_acc_3_d_6_o),
    .mac_acc_a_7_i(mac_acc_3_a_7_o),   .mac_acc_b_7_i(mac_acc_3_b_7_o),   .mac_acc_c_7_i(mac_acc_3_c_7_o),  .mac_acc_d_7_i(mac_acc_3_d_7_o),
    .mac_acc_a_8_i(mac_acc_3_a_8_o),   .mac_acc_b_8_i(mac_acc_3_b_8_o),   .mac_acc_c_8_i(mac_acc_3_c_8_o),  .mac_acc_d_8_i(mac_acc_3_d_8_o),
    .mac_acc_a_9_i(mac_acc_3_a_9_o),   .mac_acc_b_9_i(mac_acc_3_b_9_o),   .mac_acc_c_9_i(mac_acc_3_c_9_o),  .mac_acc_d_9_i(mac_acc_3_d_9_o),
    .mac_acc_a_10_i(mac_acc_3_a_10_o), .mac_acc_b_10_i(mac_acc_3_b_10_o), .mac_acc_c_10_i(mac_acc_3_c_10_o), .mac_acc_d_10_i(mac_acc_3_d_10_o),
    .mac_acc_a_11_i(mac_acc_3_a_11_o), .mac_acc_b_11_i(mac_acc_3_b_11_o), .mac_acc_c_11_i(mac_acc_3_c_11_o), .mac_acc_d_11_i(mac_acc_3_d_11_o),
    .mac_acc_a_12_i(mac_acc_3_a_12_o), .mac_acc_b_12_i(mac_acc_3_b_12_o), .mac_acc_c_12_i(mac_acc_3_c_12_o), .mac_acc_d_12_i(mac_acc_3_d_12_o),
    .mac_acc_a_13_i(mac_acc_3_a_13_o), .mac_acc_b_13_i(mac_acc_3_b_13_o), .mac_acc_c_13_i(mac_acc_3_c_13_o), .mac_acc_d_13_i(mac_acc_3_d_13_o),
    .mac_acc_a_14_i(mac_acc_3_a_14_o), .mac_acc_b_14_i(mac_acc_3_b_14_o), .mac_acc_c_14_i(mac_acc_3_c_14_o), .mac_acc_d_14_i(mac_acc_3_d_14_o),
    .mac_acc_a_15_i(mac_acc_3_a_15_o), .mac_acc_b_15_i(mac_acc_3_b_15_o), .mac_acc_c_15_i(mac_acc_3_c_15_o),  .mac_acc_d_15_i(mac_acc_3_d_15_o),
    //mac array output
    .mac_acc_a_0_o(mac_acc_4_a_0_o),   .mac_acc_b_0_o(mac_acc_4_b_0_o),   .mac_acc_c_0_o(mac_acc_4_c_0_o),   .mac_acc_d_0_o(mac_acc_4_d_0_o),
    .mac_acc_a_1_o(mac_acc_4_a_1_o),   .mac_acc_b_1_o(mac_acc_4_b_1_o),   .mac_acc_c_1_o(mac_acc_4_c_1_o),   .mac_acc_d_1_o(mac_acc_4_d_1_o),
    .mac_acc_a_2_o(mac_acc_4_a_2_o),   .mac_acc_b_2_o(mac_acc_4_b_2_o),   .mac_acc_c_2_o(mac_acc_4_c_2_o),   .mac_acc_d_2_o(mac_acc_4_d_2_o),
    .mac_acc_a_3_o(mac_acc_4_a_3_o),   .mac_acc_b_3_o(mac_acc_4_b_3_o),   .mac_acc_c_3_o(mac_acc_4_c_3_o),   .mac_acc_d_3_o(mac_acc_4_d_3_o),
    .mac_acc_a_4_o(mac_acc_4_a_4_o),   .mac_acc_b_4_o(mac_acc_4_b_4_o),   .mac_acc_c_4_o(mac_acc_4_c_4_o),   .mac_acc_d_4_o(mac_acc_4_d_4_o),
    .mac_acc_a_5_o(mac_acc_4_a_5_o),   .mac_acc_b_5_o(mac_acc_4_b_5_o),   .mac_acc_c_5_o(mac_acc_4_c_5_o),   .mac_acc_d_5_o(mac_acc_4_d_5_o),
    .mac_acc_a_6_o(mac_acc_4_a_6_o),   .mac_acc_b_6_o(mac_acc_4_b_6_o),   .mac_acc_c_6_o(mac_acc_4_c_6_o),   .mac_acc_d_6_o(mac_acc_4_d_6_o),
    .mac_acc_a_7_o(mac_acc_4_a_7_o),   .mac_acc_b_7_o(mac_acc_4_b_7_o),   .mac_acc_c_7_o(mac_acc_4_c_7_o),   .mac_acc_d_7_o(mac_acc_4_d_7_o),
    .mac_acc_a_8_o(mac_acc_4_a_8_o),   .mac_acc_b_8_o(mac_acc_4_b_8_o),   .mac_acc_c_8_o(mac_acc_4_c_8_o),   .mac_acc_d_8_o(mac_acc_4_d_8_o),
    .mac_acc_a_9_o(mac_acc_4_a_9_o),   .mac_acc_b_9_o(mac_acc_4_b_9_o),   .mac_acc_c_9_o(mac_acc_4_c_9_o),   .mac_acc_d_9_o(mac_acc_4_d_9_o),
    .mac_acc_a_10_o(mac_acc_4_a_10_o), .mac_acc_b_10_o(mac_acc_4_b_10_o), .mac_acc_c_10_o(mac_acc_4_c_10_o), .mac_acc_d_10_o(mac_acc_4_d_10_o),
    .mac_acc_a_11_o(mac_acc_4_a_11_o), .mac_acc_b_11_o(mac_acc_4_b_11_o), .mac_acc_c_11_o(mac_acc_4_c_11_o), .mac_acc_d_11_o(mac_acc_4_d_11_o),
    .mac_acc_a_12_o(mac_acc_4_a_12_o), .mac_acc_b_12_o(mac_acc_4_b_12_o), .mac_acc_c_12_o(mac_acc_4_c_12_o), .mac_acc_d_12_o(mac_acc_4_d_12_o),
    .mac_acc_a_13_o(mac_acc_4_a_13_o), .mac_acc_b_13_o(mac_acc_4_b_13_o), .mac_acc_c_13_o(mac_acc_4_c_13_o), .mac_acc_d_13_o(mac_acc_4_d_13_o),
    .mac_acc_a_14_o(mac_acc_4_a_14_o), .mac_acc_b_14_o(mac_acc_4_b_14_o), .mac_acc_c_14_o(mac_acc_4_c_14_o), .mac_acc_d_14_o(mac_acc_4_d_14_o),
    .mac_acc_a_15_o(mac_acc_4_a_15_o), .mac_acc_b_15_o(mac_acc_4_b_15_o), .mac_acc_c_15_o(mac_acc_4_c_15_o),  .mac_acc_d_15_o(mac_acc_4_d_15_o),
    
    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_4),
    .i_load_weight_data_0_b(load_weight_data_0_b_4),
    .i_load_weight_data_0_c(load_weight_data_0_c_4),
    .i_load_weight_data_0_d(load_weight_data_0_d_4),

    .i_load_weight_data_1_a(load_weight_data_1_a_4),
    .i_load_weight_data_1_b(load_weight_data_1_b_4),
    .i_load_weight_data_1_c(load_weight_data_1_c_4),
    .i_load_weight_data_1_d(load_weight_data_1_d_4),

    .i_load_weight_data_2_a(load_weight_data_2_a_4),
    .i_load_weight_data_2_b(load_weight_data_2_b_4),
    .i_load_weight_data_2_c(load_weight_data_2_c_4),
    .i_load_weight_data_2_d(load_weight_data_2_d_4),

    .i_load_weight_data_3_a(load_weight_data_3_a_4),
    .i_load_weight_data_3_b(load_weight_data_3_b_4),
    .i_load_weight_data_3_c(load_weight_data_3_c_4),
    .i_load_weight_data_3_d(load_weight_data_3_d_4),

    .i_load_weight_data_4_a(load_weight_data_4_a_4),
    .i_load_weight_data_4_b(load_weight_data_4_b_4),
    .i_load_weight_data_4_c(load_weight_data_4_c_4),
    .i_load_weight_data_4_d(load_weight_data_4_d_4),

    .i_load_weight_data_5_a(load_weight_data_5_a_4),
    .i_load_weight_data_5_b(load_weight_data_5_b_4),
    .i_load_weight_data_5_c(load_weight_data_5_c_4),
    .i_load_weight_data_5_d(load_weight_data_5_d_4),

    .i_load_weight_data_6_a(load_weight_data_6_a_4),
    .i_load_weight_data_6_b(load_weight_data_6_b_4),
    .i_load_weight_data_6_c(load_weight_data_6_c_4),
    .i_load_weight_data_6_d(load_weight_data_6_d_4),

    .i_load_weight_data_7_a(load_weight_data_7_a_4),
    .i_load_weight_data_7_b(load_weight_data_7_b_4),
    .i_load_weight_data_7_c(load_weight_data_7_c_4),
    .i_load_weight_data_7_d(load_weight_data_7_d_4),

    .i_load_weight_data_8_a(load_weight_data_8_a_4),
    .i_load_weight_data_8_b(load_weight_data_8_b_4),
    .i_load_weight_data_8_c(load_weight_data_8_c_4),
    .i_load_weight_data_8_d(load_weight_data_8_d_4),

    .i_load_weight_data_9_a(load_weight_data_9_a_4),
    .i_load_weight_data_9_b(load_weight_data_9_b_4),
    .i_load_weight_data_9_c(load_weight_data_9_c_4),
    .i_load_weight_data_9_d(load_weight_data_9_d_4),

    .i_load_weight_data_10_a(load_weight_data_10_a_4),
    .i_load_weight_data_10_b(load_weight_data_10_b_4),
    .i_load_weight_data_10_c(load_weight_data_10_c_4),
    .i_load_weight_data_10_d(load_weight_data_10_d_4),

    .i_load_weight_data_11_a(load_weight_data_11_a_4),
    .i_load_weight_data_11_b(load_weight_data_11_b_4),
    .i_load_weight_data_11_c(load_weight_data_11_c_4),
    .i_load_weight_data_11_d(load_weight_data_11_d_4),

    .i_load_weight_data_12_a(load_weight_data_12_a_4),
    .i_load_weight_data_12_b(load_weight_data_12_b_4),
    .i_load_weight_data_12_c(load_weight_data_12_c_4),
    .i_load_weight_data_12_d(load_weight_data_12_d_4),

    .i_load_weight_data_13_a(load_weight_data_13_a_4),
    .i_load_weight_data_13_b(load_weight_data_13_b_4),
    .i_load_weight_data_13_c(load_weight_data_13_c_4),
    .i_load_weight_data_13_d(load_weight_data_13_d_4),

    .i_load_weight_data_14_a(load_weight_data_14_a_4),
    .i_load_weight_data_14_b(load_weight_data_14_b_4),
    .i_load_weight_data_14_c(load_weight_data_14_c_4),
    .i_load_weight_data_14_d(load_weight_data_14_d_4),

    .i_load_weight_data_15_a(load_weight_data_15_a_4),
    .i_load_weight_data_15_b(load_weight_data_15_b_4),
    .i_load_weight_data_15_c(load_weight_data_15_c_4),
    .i_load_weight_data_15_d(load_weight_data_15_d_4),

    .i_load_weight_data_16_a(load_weight_data_16_a_4),
    .i_load_weight_data_16_b(load_weight_data_16_b_4),
    .i_load_weight_data_16_c(load_weight_data_16_c_4),
    .i_load_weight_data_16_d(load_weight_data_16_d_4),

    .i_load_weight_data_17_a(load_weight_data_17_a_4),
    .i_load_weight_data_17_b(load_weight_data_17_b_4),
    .i_load_weight_data_17_c(load_weight_data_17_c_4),
    .i_load_weight_data_17_d(load_weight_data_17_d_4),

    .i_load_weight_data_18_a(load_weight_data_18_a_4),
    .i_load_weight_data_18_b(load_weight_data_18_b_4),
    .i_load_weight_data_18_c(load_weight_data_18_c_4),
    .i_load_weight_data_18_d(load_weight_data_18_d_4),

    .i_load_weight_data_19_a(load_weight_data_19_a_4),
    .i_load_weight_data_19_b(load_weight_data_19_b_4),
    .i_load_weight_data_19_c(load_weight_data_19_c_4),
    .i_load_weight_data_19_d(load_weight_data_19_d_4),

    .i_load_weight_data_20_a(load_weight_data_20_a_4),
    .i_load_weight_data_20_b(load_weight_data_20_b_4),
    .i_load_weight_data_20_c(load_weight_data_20_c_4),
    .i_load_weight_data_20_d(load_weight_data_20_d_4),

    .i_load_weight_data_21_a(load_weight_data_21_a_4),
    .i_load_weight_data_21_b(load_weight_data_21_b_4),
    .i_load_weight_data_21_c(load_weight_data_21_c_4),
    .i_load_weight_data_21_d(load_weight_data_21_d_4),

    .i_load_weight_data_22_a(load_weight_data_22_a_4),
    .i_load_weight_data_22_b(load_weight_data_22_b_4),
    .i_load_weight_data_22_c(load_weight_data_22_c_4),
    .i_load_weight_data_22_d(load_weight_data_22_d_4),

    .i_load_weight_data_23_a(load_weight_data_23_a_4),
    .i_load_weight_data_23_b(load_weight_data_23_b_4),
    .i_load_weight_data_23_c(load_weight_data_23_c_4),
    .i_load_weight_data_23_d(load_weight_data_23_d_4),

    .i_load_weight_data_24_a(load_weight_data_24_a_4),
    .i_load_weight_data_24_b(load_weight_data_24_b_4),
    .i_load_weight_data_24_c(load_weight_data_24_c_4),
    .i_load_weight_data_24_d(load_weight_data_24_d_4),

    .i_load_weight_data_25_a(load_weight_data_25_a_4),
    .i_load_weight_data_25_b(load_weight_data_25_b_4),
    .i_load_weight_data_25_c(load_weight_data_25_c_4),
    .i_load_weight_data_25_d(load_weight_data_25_d_4),

    .i_load_weight_data_26_a(load_weight_data_26_a_4),
    .i_load_weight_data_26_b(load_weight_data_26_b_4),
    .i_load_weight_data_26_c(load_weight_data_26_c_4),
    .i_load_weight_data_26_d(load_weight_data_26_d_4),

    .i_load_weight_data_27_a(load_weight_data_27_a_4),
    .i_load_weight_data_27_b(load_weight_data_27_b_4),
    .i_load_weight_data_27_c(load_weight_data_27_c_4),
    .i_load_weight_data_27_d(load_weight_data_27_d_4),

    .i_load_weight_data_28_a(load_weight_data_28_a_4),
    .i_load_weight_data_28_b(load_weight_data_28_b_4),
    .i_load_weight_data_28_c(load_weight_data_28_c_4),
    .i_load_weight_data_28_d(load_weight_data_28_d_4),

    .i_load_weight_data_29_a(load_weight_data_29_a_4),
    .i_load_weight_data_29_b(load_weight_data_29_b_4),
    .i_load_weight_data_29_c(load_weight_data_29_c_4),
    .i_load_weight_data_29_d(load_weight_data_29_d_4),

    .i_load_weight_data_30_a(load_weight_data_30_a_4),
    .i_load_weight_data_30_b(load_weight_data_30_b_4),
    .i_load_weight_data_30_c(load_weight_data_30_c_4),
    .i_load_weight_data_30_d(load_weight_data_30_d_4),

    .i_load_weight_data_31_a(load_weight_data_31_a_4),
    .i_load_weight_data_31_b(load_weight_data_31_b_4),
    .i_load_weight_data_31_c(load_weight_data_31_c_4),
    .i_load_weight_data_31_d(load_weight_data_31_d_4),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(load_weight_data_0_a_5),
    .o_load_weight_data_0_b(load_weight_data_0_b_5),
    .o_load_weight_data_0_c(load_weight_data_0_c_5),
    .o_load_weight_data_0_d(load_weight_data_0_d_5),

    .o_load_weight_data_1_a(load_weight_data_1_a_5),
    .o_load_weight_data_1_b(load_weight_data_1_b_5),
    .o_load_weight_data_1_c(load_weight_data_1_c_5),
    .o_load_weight_data_1_d(load_weight_data_1_d_5),

    .o_load_weight_data_2_a(load_weight_data_2_a_5),
    .o_load_weight_data_2_b(load_weight_data_2_b_5),
    .o_load_weight_data_2_c(load_weight_data_2_c_5),
    .o_load_weight_data_2_d(load_weight_data_2_d_5),

    .o_load_weight_data_3_a(load_weight_data_3_a_5),
    .o_load_weight_data_3_b(load_weight_data_3_b_5),
    .o_load_weight_data_3_c(load_weight_data_3_c_5),
    .o_load_weight_data_3_d(load_weight_data_3_d_5),

    .o_load_weight_data_4_a(load_weight_data_4_a_5),
    .o_load_weight_data_4_b(load_weight_data_4_b_5),
    .o_load_weight_data_4_c(load_weight_data_4_c_5),
    .o_load_weight_data_4_d(load_weight_data_4_d_5),

    .o_load_weight_data_5_a(load_weight_data_5_a_5),
    .o_load_weight_data_5_b(load_weight_data_5_b_5),
    .o_load_weight_data_5_c(load_weight_data_5_c_5),
    .o_load_weight_data_5_d(load_weight_data_5_d_5),

    .o_load_weight_data_6_a(load_weight_data_6_a_5),
    .o_load_weight_data_6_b(load_weight_data_6_b_5),
    .o_load_weight_data_6_c(load_weight_data_6_c_5),
    .o_load_weight_data_6_d(load_weight_data_6_d_5),

    .o_load_weight_data_7_a(load_weight_data_7_a_5),
    .o_load_weight_data_7_b(load_weight_data_7_b_5),
    .o_load_weight_data_7_c(load_weight_data_7_c_5),
    .o_load_weight_data_7_d(load_weight_data_7_d_5),

    .o_load_weight_data_8_a(load_weight_data_8_a_5),
    .o_load_weight_data_8_b(load_weight_data_8_b_5),
    .o_load_weight_data_8_c(load_weight_data_8_c_5),
    .o_load_weight_data_8_d(load_weight_data_8_d_5),

    .o_load_weight_data_9_a(load_weight_data_9_a_5),
    .o_load_weight_data_9_b(load_weight_data_9_b_5),
    .o_load_weight_data_9_c(load_weight_data_9_c_5),
    .o_load_weight_data_9_d(load_weight_data_9_d_5),

    .o_load_weight_data_10_a(load_weight_data_10_a_5),
    .o_load_weight_data_10_b(load_weight_data_10_b_5),
    .o_load_weight_data_10_c(load_weight_data_10_c_5),
    .o_load_weight_data_10_d(load_weight_data_10_d_5),

    .o_load_weight_data_11_a(load_weight_data_11_a_5),
    .o_load_weight_data_11_b(load_weight_data_11_b_5),
    .o_load_weight_data_11_c(load_weight_data_11_c_5),
    .o_load_weight_data_11_d(load_weight_data_11_d_5),

    .o_load_weight_data_12_a(load_weight_data_12_a_5),
    .o_load_weight_data_12_b(load_weight_data_12_b_5),
    .o_load_weight_data_12_c(load_weight_data_12_c_5),
    .o_load_weight_data_12_d(load_weight_data_12_d_5),

    .o_load_weight_data_13_a(load_weight_data_13_a_5),
    .o_load_weight_data_13_b(load_weight_data_13_b_5),
    .o_load_weight_data_13_c(load_weight_data_13_c_5),
    .o_load_weight_data_13_d(load_weight_data_13_d_5),

    .o_load_weight_data_14_a(load_weight_data_14_a_5),
    .o_load_weight_data_14_b(load_weight_data_14_b_5),
    .o_load_weight_data_14_c(load_weight_data_14_c_5),
    .o_load_weight_data_14_d(load_weight_data_14_d_5),

    .o_load_weight_data_15_a(load_weight_data_15_a_5),
    .o_load_weight_data_15_b(load_weight_data_15_b_5),
    .o_load_weight_data_15_c(load_weight_data_15_c_5),
    .o_load_weight_data_15_d(load_weight_data_15_d_5),

    .o_load_weight_data_16_a(load_weight_data_16_a_5),
    .o_load_weight_data_16_b(load_weight_data_16_b_5),
    .o_load_weight_data_16_c(load_weight_data_16_c_5),
    .o_load_weight_data_16_d(load_weight_data_16_d_5),

    .o_load_weight_data_17_a(load_weight_data_17_a_5),
    .o_load_weight_data_17_b(load_weight_data_17_b_5),
    .o_load_weight_data_17_c(load_weight_data_17_c_5),
    .o_load_weight_data_17_d(load_weight_data_17_d_5),

    .o_load_weight_data_18_a(load_weight_data_18_a_5),
    .o_load_weight_data_18_b(load_weight_data_18_b_5),
    .o_load_weight_data_18_c(load_weight_data_18_c_5),
    .o_load_weight_data_18_d(load_weight_data_18_d_5),

    .o_load_weight_data_19_a(load_weight_data_19_a_5),
    .o_load_weight_data_19_b(load_weight_data_19_b_5),
    .o_load_weight_data_19_c(load_weight_data_19_c_5),
    .o_load_weight_data_19_d(load_weight_data_19_d_5),

    .o_load_weight_data_20_a(load_weight_data_20_a_5),
    .o_load_weight_data_20_b(load_weight_data_20_b_5),
    .o_load_weight_data_20_c(load_weight_data_20_c_5),
    .o_load_weight_data_20_d(load_weight_data_20_d_5),

    .o_load_weight_data_21_a(load_weight_data_21_a_5),
    .o_load_weight_data_21_b(load_weight_data_21_b_5),
    .o_load_weight_data_21_c(load_weight_data_21_c_5),
    .o_load_weight_data_21_d(load_weight_data_21_d_5),

    .o_load_weight_data_22_a(load_weight_data_22_a_5),
    .o_load_weight_data_22_b(load_weight_data_22_b_5),
    .o_load_weight_data_22_c(load_weight_data_22_c_5),
    .o_load_weight_data_22_d(load_weight_data_22_d_5),

    .o_load_weight_data_23_a(load_weight_data_23_a_5),
    .o_load_weight_data_23_b(load_weight_data_23_b_5),
    .o_load_weight_data_23_c(load_weight_data_23_c_5),
    .o_load_weight_data_23_d(load_weight_data_23_d_5),

    .o_load_weight_data_24_a(load_weight_data_24_a_5),
    .o_load_weight_data_24_b(load_weight_data_24_b_5),
    .o_load_weight_data_24_c(load_weight_data_24_c_5),
    .o_load_weight_data_24_d(load_weight_data_24_d_5),

    .o_load_weight_data_25_a(load_weight_data_25_a_5),
    .o_load_weight_data_25_b(load_weight_data_25_b_5),
    .o_load_weight_data_25_c(load_weight_data_25_c_5),
    .o_load_weight_data_25_d(load_weight_data_25_d_5),

    .o_load_weight_data_26_a(load_weight_data_26_a_5),
    .o_load_weight_data_26_b(load_weight_data_26_b_5),
    .o_load_weight_data_26_c(load_weight_data_26_c_5),
    .o_load_weight_data_26_d(load_weight_data_26_d_5),

    .o_load_weight_data_27_a(load_weight_data_27_a_5),
    .o_load_weight_data_27_b(load_weight_data_27_b_5),
    .o_load_weight_data_27_c(load_weight_data_27_c_5),
    .o_load_weight_data_27_d(load_weight_data_27_d_5),

    .o_load_weight_data_28_a(load_weight_data_28_a_5),
    .o_load_weight_data_28_b(load_weight_data_28_b_5),
    .o_load_weight_data_28_c(load_weight_data_28_c_5),
    .o_load_weight_data_28_d(load_weight_data_28_d_5),

    .o_load_weight_data_29_a(load_weight_data_29_a_5),
    .o_load_weight_data_29_b(load_weight_data_29_b_5),
    .o_load_weight_data_29_c(load_weight_data_29_c_5),
    .o_load_weight_data_29_d(load_weight_data_29_d_5),

    .o_load_weight_data_30_a(load_weight_data_30_a_5),
    .o_load_weight_data_30_b(load_weight_data_30_b_5),
    .o_load_weight_data_30_c(load_weight_data_30_c_5),
    .o_load_weight_data_30_d(load_weight_data_30_d_5),

    .o_load_weight_data_31_a(load_weight_data_31_a_5),
    .o_load_weight_data_31_b(load_weight_data_31_b_5),
    .o_load_weight_data_31_c(load_weight_data_31_c_5),
    .o_load_weight_data_31_d(load_weight_data_31_d_5)  
  );

  processing_element
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) processing_element_5(
    .clk(clk), 
    .rst_n(rst_n),

    //Write Buffer Control
    .prepare_weight(i_prepare_weight), 
    .buffer_wr_en_i(buffer_wr_en_i),
    .buffer_wr_addr_i(buffer_wr_addr_i),
    
    //Execute Control
    .set_weight_i(set_weight_i),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(buffer_rd_en_4_o),
    .activation_rd_en_o(buffer_rd_en_5_o),
    .buffer_rd_addr_i(buffer_rd_addr_4_o),
    .buffer_rd_addr_o(buffer_rd_addr_5_o),       
    
    .buffer_data_i(buffer_data_5_i),
  
    //mac array
    //mac adder input
    .mac_acc_a_0_i(mac_acc_4_a_0_o),   .mac_acc_b_0_i(mac_acc_4_b_0_o),   .mac_acc_c_0_i(mac_acc_4_c_0_o),   .mac_acc_d_0_i(mac_acc_4_d_0_o),
    .mac_acc_a_1_i(mac_acc_4_a_1_o),   .mac_acc_b_1_i(mac_acc_4_b_1_o),   .mac_acc_c_1_i(mac_acc_4_c_1_o),   .mac_acc_d_1_i(mac_acc_4_d_1_o),
    .mac_acc_a_2_i(mac_acc_4_a_2_o),   .mac_acc_b_2_i(mac_acc_4_b_2_o),   .mac_acc_c_2_i(mac_acc_4_c_2_o),   .mac_acc_d_2_i(mac_acc_4_d_2_o),
    .mac_acc_a_3_i(mac_acc_4_a_3_o),   .mac_acc_b_3_i(mac_acc_4_b_3_o),   .mac_acc_c_3_i(mac_acc_4_c_3_o),   .mac_acc_d_3_i(mac_acc_4_d_3_o),
    .mac_acc_a_4_i(mac_acc_4_a_4_o),   .mac_acc_b_4_i(mac_acc_4_b_4_o),   .mac_acc_c_4_i(mac_acc_4_c_4_o),   .mac_acc_d_4_i(mac_acc_4_d_4_o),
    .mac_acc_a_5_i(mac_acc_4_a_5_o),   .mac_acc_b_5_i(mac_acc_4_b_5_o),   .mac_acc_c_5_i(mac_acc_4_c_5_o),   .mac_acc_d_5_i(mac_acc_4_d_5_o),
    .mac_acc_a_6_i(mac_acc_4_a_6_o),   .mac_acc_b_6_i(mac_acc_4_b_6_o),   .mac_acc_c_6_i(mac_acc_4_c_6_o),   .mac_acc_d_6_i(mac_acc_4_d_6_o),
    .mac_acc_a_7_i(mac_acc_4_a_7_o),   .mac_acc_b_7_i(mac_acc_4_b_7_o),   .mac_acc_c_7_i(mac_acc_4_c_7_o),   .mac_acc_d_7_i(mac_acc_4_d_7_o),
    .mac_acc_a_8_i(mac_acc_4_a_8_o),   .mac_acc_b_8_i(mac_acc_4_b_8_o),   .mac_acc_c_8_i(mac_acc_4_c_8_o),   .mac_acc_d_8_i(mac_acc_4_d_8_o),
    .mac_acc_a_9_i(mac_acc_4_a_9_o),   .mac_acc_b_9_i(mac_acc_4_b_9_o),   .mac_acc_c_9_i(mac_acc_4_c_9_o),   .mac_acc_d_9_i(mac_acc_4_d_9_o),
    .mac_acc_a_10_i(mac_acc_4_a_10_o), .mac_acc_b_10_i(mac_acc_4_b_10_o), .mac_acc_c_10_i(mac_acc_4_c_10_o), .mac_acc_d_10_i(mac_acc_4_d_10_o),
    .mac_acc_a_11_i(mac_acc_4_a_11_o), .mac_acc_b_11_i(mac_acc_4_b_11_o), .mac_acc_c_11_i(mac_acc_4_c_11_o), .mac_acc_d_11_i(mac_acc_4_d_11_o),
    .mac_acc_a_12_i(mac_acc_4_a_12_o), .mac_acc_b_12_i(mac_acc_4_b_12_o), .mac_acc_c_12_i(mac_acc_4_c_12_o), .mac_acc_d_12_i(mac_acc_4_d_12_o),
    .mac_acc_a_13_i(mac_acc_4_a_13_o), .mac_acc_b_13_i(mac_acc_4_b_13_o), .mac_acc_c_13_i(mac_acc_4_c_13_o), .mac_acc_d_13_i(mac_acc_4_d_13_o),
    .mac_acc_a_14_i(mac_acc_4_a_14_o), .mac_acc_b_14_i(mac_acc_4_b_14_o), .mac_acc_c_14_i(mac_acc_4_c_14_o), .mac_acc_d_14_i(mac_acc_4_d_14_o),
    .mac_acc_a_15_i(mac_acc_4_a_15_o), .mac_acc_b_15_i(mac_acc_4_b_15_o), .mac_acc_c_15_i(mac_acc_4_c_15_o),  .mac_acc_d_15_i(mac_acc_4_d_15_o),
    //mac array output
    .mac_acc_a_0_o(mac_acc_5_a_0_o),   .mac_acc_b_0_o(mac_acc_5_b_0_o),   .mac_acc_c_0_o(mac_acc_5_c_0_o),   .mac_acc_d_0_o(mac_acc_5_d_0_o),
    .mac_acc_a_1_o(mac_acc_5_a_1_o),   .mac_acc_b_1_o(mac_acc_5_b_1_o),   .mac_acc_c_1_o(mac_acc_5_c_1_o),   .mac_acc_d_1_o(mac_acc_5_d_1_o),
    .mac_acc_a_2_o(mac_acc_5_a_2_o),   .mac_acc_b_2_o(mac_acc_5_b_2_o),   .mac_acc_c_2_o(mac_acc_5_c_2_o),   .mac_acc_d_2_o(mac_acc_5_d_2_o),
    .mac_acc_a_3_o(mac_acc_5_a_3_o),   .mac_acc_b_3_o(mac_acc_5_b_3_o),   .mac_acc_c_3_o(mac_acc_5_c_3_o),   .mac_acc_d_3_o(mac_acc_5_d_3_o),
    .mac_acc_a_4_o(mac_acc_5_a_4_o),   .mac_acc_b_4_o(mac_acc_5_b_4_o),   .mac_acc_c_4_o(mac_acc_5_c_4_o),   .mac_acc_d_4_o(mac_acc_5_d_4_o),
    .mac_acc_a_5_o(mac_acc_5_a_5_o),   .mac_acc_b_5_o(mac_acc_5_b_5_o),   .mac_acc_c_5_o(mac_acc_5_c_5_o),   .mac_acc_d_5_o(mac_acc_5_d_5_o),
    .mac_acc_a_6_o(mac_acc_5_a_6_o),   .mac_acc_b_6_o(mac_acc_5_b_6_o),   .mac_acc_c_6_o(mac_acc_5_c_6_o),   .mac_acc_d_6_o(mac_acc_5_d_6_o),
    .mac_acc_a_7_o(mac_acc_5_a_7_o),   .mac_acc_b_7_o(mac_acc_5_b_7_o),   .mac_acc_c_7_o(mac_acc_5_c_7_o),   .mac_acc_d_7_o(mac_acc_5_d_7_o),
    .mac_acc_a_8_o(mac_acc_5_a_8_o),   .mac_acc_b_8_o(mac_acc_5_b_8_o),   .mac_acc_c_8_o(mac_acc_5_c_8_o),   .mac_acc_d_8_o(mac_acc_5_d_8_o),
    .mac_acc_a_9_o(mac_acc_5_a_9_o),   .mac_acc_b_9_o(mac_acc_5_b_9_o),   .mac_acc_c_9_o(mac_acc_5_c_9_o),   .mac_acc_d_9_o(mac_acc_5_d_9_o),
    .mac_acc_a_10_o(mac_acc_5_a_10_o), .mac_acc_b_10_o(mac_acc_5_b_10_o), .mac_acc_c_10_o(mac_acc_5_c_10_o), .mac_acc_d_10_o(mac_acc_5_d_10_o),
    .mac_acc_a_11_o(mac_acc_5_a_11_o), .mac_acc_b_11_o(mac_acc_5_b_11_o), .mac_acc_c_11_o(mac_acc_5_c_11_o), .mac_acc_d_11_o(mac_acc_5_d_11_o),
    .mac_acc_a_12_o(mac_acc_5_a_12_o), .mac_acc_b_12_o(mac_acc_5_b_12_o), .mac_acc_c_12_o(mac_acc_5_c_12_o), .mac_acc_d_12_o(mac_acc_5_d_12_o),
    .mac_acc_a_13_o(mac_acc_5_a_13_o), .mac_acc_b_13_o(mac_acc_5_b_13_o), .mac_acc_c_13_o(mac_acc_5_c_13_o), .mac_acc_d_13_o(mac_acc_5_d_13_o),
    .mac_acc_a_14_o(mac_acc_5_a_14_o), .mac_acc_b_14_o(mac_acc_5_b_14_o), .mac_acc_c_14_o(mac_acc_5_c_14_o), .mac_acc_d_14_o(mac_acc_5_d_14_o),
    .mac_acc_a_15_o(mac_acc_5_a_15_o), .mac_acc_b_15_o(mac_acc_5_b_15_o), .mac_acc_c_15_o(mac_acc_5_c_15_o),  .mac_acc_d_15_o(mac_acc_5_d_15_o),
    
    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_5),
    .i_load_weight_data_0_b(load_weight_data_0_b_5),
    .i_load_weight_data_0_c(load_weight_data_0_c_5),
    .i_load_weight_data_0_d(load_weight_data_0_d_5),

    .i_load_weight_data_1_a(load_weight_data_1_a_5),
    .i_load_weight_data_1_b(load_weight_data_1_b_5),
    .i_load_weight_data_1_c(load_weight_data_1_c_5),
    .i_load_weight_data_1_d(load_weight_data_1_d_5),

    .i_load_weight_data_2_a(load_weight_data_2_a_5),
    .i_load_weight_data_2_b(load_weight_data_2_b_5),
    .i_load_weight_data_2_c(load_weight_data_2_c_5),
    .i_load_weight_data_2_d(load_weight_data_2_d_5),

    .i_load_weight_data_3_a(load_weight_data_3_a_5),
    .i_load_weight_data_3_b(load_weight_data_3_b_5),
    .i_load_weight_data_3_c(load_weight_data_3_c_5),
    .i_load_weight_data_3_d(load_weight_data_3_d_5),

    .i_load_weight_data_4_a(load_weight_data_4_a_5),
    .i_load_weight_data_4_b(load_weight_data_4_b_5),
    .i_load_weight_data_4_c(load_weight_data_4_c_5),
    .i_load_weight_data_4_d(load_weight_data_4_d_5),

    .i_load_weight_data_5_a(load_weight_data_5_a_5),
    .i_load_weight_data_5_b(load_weight_data_5_b_5),
    .i_load_weight_data_5_c(load_weight_data_5_c_5),
    .i_load_weight_data_5_d(load_weight_data_5_d_5),

    .i_load_weight_data_6_a(load_weight_data_6_a_5),
    .i_load_weight_data_6_b(load_weight_data_6_b_5),
    .i_load_weight_data_6_c(load_weight_data_6_c_5),
    .i_load_weight_data_6_d(load_weight_data_6_d_5),

    .i_load_weight_data_7_a(load_weight_data_7_a_5),
    .i_load_weight_data_7_b(load_weight_data_7_b_5),
    .i_load_weight_data_7_c(load_weight_data_7_c_5),
    .i_load_weight_data_7_d(load_weight_data_7_d_5),

    .i_load_weight_data_8_a(load_weight_data_8_a_5),
    .i_load_weight_data_8_b(load_weight_data_8_b_5),
    .i_load_weight_data_8_c(load_weight_data_8_c_5),
    .i_load_weight_data_8_d(load_weight_data_8_d_5),

    .i_load_weight_data_9_a(load_weight_data_9_a_5),
    .i_load_weight_data_9_b(load_weight_data_9_b_5),
    .i_load_weight_data_9_c(load_weight_data_9_c_5),
    .i_load_weight_data_9_d(load_weight_data_9_d_5),

    .i_load_weight_data_10_a(load_weight_data_10_a_5),
    .i_load_weight_data_10_b(load_weight_data_10_b_5),
    .i_load_weight_data_10_c(load_weight_data_10_c_5),
    .i_load_weight_data_10_d(load_weight_data_10_d_5),

    .i_load_weight_data_11_a(load_weight_data_11_a_5),
    .i_load_weight_data_11_b(load_weight_data_11_b_5),
    .i_load_weight_data_11_c(load_weight_data_11_c_5),
    .i_load_weight_data_11_d(load_weight_data_11_d_5),

    .i_load_weight_data_12_a(load_weight_data_12_a_5),
    .i_load_weight_data_12_b(load_weight_data_12_b_5),
    .i_load_weight_data_12_c(load_weight_data_12_c_5),
    .i_load_weight_data_12_d(load_weight_data_12_d_5),

    .i_load_weight_data_13_a(load_weight_data_13_a_5),
    .i_load_weight_data_13_b(load_weight_data_13_b_5),
    .i_load_weight_data_13_c(load_weight_data_13_c_5),
    .i_load_weight_data_13_d(load_weight_data_13_d_5),

    .i_load_weight_data_14_a(load_weight_data_14_a_5),
    .i_load_weight_data_14_b(load_weight_data_14_b_5),
    .i_load_weight_data_14_c(load_weight_data_14_c_5),
    .i_load_weight_data_14_d(load_weight_data_14_d_5),

    .i_load_weight_data_15_a(load_weight_data_15_a_5),
    .i_load_weight_data_15_b(load_weight_data_15_b_5),
    .i_load_weight_data_15_c(load_weight_data_15_c_5),
    .i_load_weight_data_15_d(load_weight_data_15_d_5),

    .i_load_weight_data_16_a(load_weight_data_16_a_5),
    .i_load_weight_data_16_b(load_weight_data_16_b_5),
    .i_load_weight_data_16_c(load_weight_data_16_c_5),
    .i_load_weight_data_16_d(load_weight_data_16_d_5),

    .i_load_weight_data_17_a(load_weight_data_17_a_5),
    .i_load_weight_data_17_b(load_weight_data_17_b_5),
    .i_load_weight_data_17_c(load_weight_data_17_c_5),
    .i_load_weight_data_17_d(load_weight_data_17_d_5),

    .i_load_weight_data_18_a(load_weight_data_18_a_5),
    .i_load_weight_data_18_b(load_weight_data_18_b_5),
    .i_load_weight_data_18_c(load_weight_data_18_c_5),
    .i_load_weight_data_18_d(load_weight_data_18_d_5),

    .i_load_weight_data_19_a(load_weight_data_19_a_5),
    .i_load_weight_data_19_b(load_weight_data_19_b_5),
    .i_load_weight_data_19_c(load_weight_data_19_c_5),
    .i_load_weight_data_19_d(load_weight_data_19_d_5),

    .i_load_weight_data_20_a(load_weight_data_20_a_5),
    .i_load_weight_data_20_b(load_weight_data_20_b_5),
    .i_load_weight_data_20_c(load_weight_data_20_c_5),
    .i_load_weight_data_20_d(load_weight_data_20_d_5),

    .i_load_weight_data_21_a(load_weight_data_21_a_5),
    .i_load_weight_data_21_b(load_weight_data_21_b_5),
    .i_load_weight_data_21_c(load_weight_data_21_c_5),
    .i_load_weight_data_21_d(load_weight_data_21_d_5),

    .i_load_weight_data_22_a(load_weight_data_22_a_5),
    .i_load_weight_data_22_b(load_weight_data_22_b_5),
    .i_load_weight_data_22_c(load_weight_data_22_c_5),
    .i_load_weight_data_22_d(load_weight_data_22_d_5),

    .i_load_weight_data_23_a(load_weight_data_23_a_5),
    .i_load_weight_data_23_b(load_weight_data_23_b_5),
    .i_load_weight_data_23_c(load_weight_data_23_c_5),
    .i_load_weight_data_23_d(load_weight_data_23_d_5),

    .i_load_weight_data_24_a(load_weight_data_24_a_5),
    .i_load_weight_data_24_b(load_weight_data_24_b_5),
    .i_load_weight_data_24_c(load_weight_data_24_c_5),
    .i_load_weight_data_24_d(load_weight_data_24_d_5),

    .i_load_weight_data_25_a(load_weight_data_25_a_5),
    .i_load_weight_data_25_b(load_weight_data_25_b_5),
    .i_load_weight_data_25_c(load_weight_data_25_c_5),
    .i_load_weight_data_25_d(load_weight_data_25_d_5),

    .i_load_weight_data_26_a(load_weight_data_26_a_5),
    .i_load_weight_data_26_b(load_weight_data_26_b_5),
    .i_load_weight_data_26_c(load_weight_data_26_c_5),
    .i_load_weight_data_26_d(load_weight_data_26_d_5),

    .i_load_weight_data_27_a(load_weight_data_27_a_5),
    .i_load_weight_data_27_b(load_weight_data_27_b_5),
    .i_load_weight_data_27_c(load_weight_data_27_c_5),
    .i_load_weight_data_27_d(load_weight_data_27_d_5),

    .i_load_weight_data_28_a(load_weight_data_28_a_5),
    .i_load_weight_data_28_b(load_weight_data_28_b_5),
    .i_load_weight_data_28_c(load_weight_data_28_c_5),
    .i_load_weight_data_28_d(load_weight_data_28_d_5),

    .i_load_weight_data_29_a(load_weight_data_29_a_5),
    .i_load_weight_data_29_b(load_weight_data_29_b_5),
    .i_load_weight_data_29_c(load_weight_data_29_c_5),
    .i_load_weight_data_29_d(load_weight_data_29_d_5),

    .i_load_weight_data_30_a(load_weight_data_30_a_5),
    .i_load_weight_data_30_b(load_weight_data_30_b_5),
    .i_load_weight_data_30_c(load_weight_data_30_c_5),
    .i_load_weight_data_30_d(load_weight_data_30_d_5),

    .i_load_weight_data_31_a(load_weight_data_31_a_5),
    .i_load_weight_data_31_b(load_weight_data_31_b_5),
    .i_load_weight_data_31_c(load_weight_data_31_c_5),
    .i_load_weight_data_31_d(load_weight_data_31_d_5),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(load_weight_data_0_a_6),
    .o_load_weight_data_0_b(load_weight_data_0_b_6),
    .o_load_weight_data_0_c(load_weight_data_0_c_6),
    .o_load_weight_data_0_d(load_weight_data_0_d_6),

    .o_load_weight_data_1_a(load_weight_data_1_a_6),
    .o_load_weight_data_1_b(load_weight_data_1_b_6),
    .o_load_weight_data_1_c(load_weight_data_1_c_6),
    .o_load_weight_data_1_d(load_weight_data_1_d_6),

    .o_load_weight_data_2_a(load_weight_data_2_a_6),
    .o_load_weight_data_2_b(load_weight_data_2_b_6),
    .o_load_weight_data_2_c(load_weight_data_2_c_6),
    .o_load_weight_data_2_d(load_weight_data_2_d_6),

    .o_load_weight_data_3_a(load_weight_data_3_a_6),
    .o_load_weight_data_3_b(load_weight_data_3_b_6),
    .o_load_weight_data_3_c(load_weight_data_3_c_6),
    .o_load_weight_data_3_d(load_weight_data_3_d_6),

    .o_load_weight_data_4_a(load_weight_data_4_a_6),
    .o_load_weight_data_4_b(load_weight_data_4_b_6),
    .o_load_weight_data_4_c(load_weight_data_4_c_6),
    .o_load_weight_data_4_d(load_weight_data_4_d_6),

    .o_load_weight_data_5_a(load_weight_data_5_a_6),
    .o_load_weight_data_5_b(load_weight_data_5_b_6),
    .o_load_weight_data_5_c(load_weight_data_5_c_6),
    .o_load_weight_data_5_d(load_weight_data_5_d_6),

    .o_load_weight_data_6_a(load_weight_data_6_a_6),
    .o_load_weight_data_6_b(load_weight_data_6_b_6),
    .o_load_weight_data_6_c(load_weight_data_6_c_6),
    .o_load_weight_data_6_d(load_weight_data_6_d_6),

    .o_load_weight_data_7_a(load_weight_data_7_a_6),
    .o_load_weight_data_7_b(load_weight_data_7_b_6),
    .o_load_weight_data_7_c(load_weight_data_7_c_6),
    .o_load_weight_data_7_d(load_weight_data_7_d_6),

    .o_load_weight_data_8_a(load_weight_data_8_a_6),
    .o_load_weight_data_8_b(load_weight_data_8_b_6),
    .o_load_weight_data_8_c(load_weight_data_8_c_6),
    .o_load_weight_data_8_d(load_weight_data_8_d_6),

    .o_load_weight_data_9_a(load_weight_data_9_a_6),
    .o_load_weight_data_9_b(load_weight_data_9_b_6),
    .o_load_weight_data_9_c(load_weight_data_9_c_6),
    .o_load_weight_data_9_d(load_weight_data_9_d_6),

    .o_load_weight_data_10_a(load_weight_data_10_a_6),
    .o_load_weight_data_10_b(load_weight_data_10_b_6),
    .o_load_weight_data_10_c(load_weight_data_10_c_6),
    .o_load_weight_data_10_d(load_weight_data_10_d_6),

    .o_load_weight_data_11_a(load_weight_data_11_a_6),
    .o_load_weight_data_11_b(load_weight_data_11_b_6),
    .o_load_weight_data_11_c(load_weight_data_11_c_6),
    .o_load_weight_data_11_d(load_weight_data_11_d_6),

    .o_load_weight_data_12_a(load_weight_data_12_a_6),
    .o_load_weight_data_12_b(load_weight_data_12_b_6),
    .o_load_weight_data_12_c(load_weight_data_12_c_6),
    .o_load_weight_data_12_d(load_weight_data_12_d_6),

    .o_load_weight_data_13_a(load_weight_data_13_a_6),
    .o_load_weight_data_13_b(load_weight_data_13_b_6),
    .o_load_weight_data_13_c(load_weight_data_13_c_6),
    .o_load_weight_data_13_d(load_weight_data_13_d_6),

    .o_load_weight_data_14_a(load_weight_data_14_a_6),
    .o_load_weight_data_14_b(load_weight_data_14_b_6),
    .o_load_weight_data_14_c(load_weight_data_14_c_6),
    .o_load_weight_data_14_d(load_weight_data_14_d_6),

    .o_load_weight_data_15_a(load_weight_data_15_a_6),
    .o_load_weight_data_15_b(load_weight_data_15_b_6),
    .o_load_weight_data_15_c(load_weight_data_15_c_6),
    .o_load_weight_data_15_d(load_weight_data_15_d_6),

    .o_load_weight_data_16_a(load_weight_data_16_a_6),
    .o_load_weight_data_16_b(load_weight_data_16_b_6),
    .o_load_weight_data_16_c(load_weight_data_16_c_6),
    .o_load_weight_data_16_d(load_weight_data_16_d_6),

    .o_load_weight_data_17_a(load_weight_data_17_a_6),
    .o_load_weight_data_17_b(load_weight_data_17_b_6),
    .o_load_weight_data_17_c(load_weight_data_17_c_6),
    .o_load_weight_data_17_d(load_weight_data_17_d_6),

    .o_load_weight_data_18_a(load_weight_data_18_a_6),
    .o_load_weight_data_18_b(load_weight_data_18_b_6),
    .o_load_weight_data_18_c(load_weight_data_18_c_6),
    .o_load_weight_data_18_d(load_weight_data_18_d_6),

    .o_load_weight_data_19_a(load_weight_data_19_a_6),
    .o_load_weight_data_19_b(load_weight_data_19_b_6),
    .o_load_weight_data_19_c(load_weight_data_19_c_6),
    .o_load_weight_data_19_d(load_weight_data_19_d_6),

    .o_load_weight_data_20_a(load_weight_data_20_a_6),
    .o_load_weight_data_20_b(load_weight_data_20_b_6),
    .o_load_weight_data_20_c(load_weight_data_20_c_6),
    .o_load_weight_data_20_d(load_weight_data_20_d_6),

    .o_load_weight_data_21_a(load_weight_data_21_a_6),
    .o_load_weight_data_21_b(load_weight_data_21_b_6),
    .o_load_weight_data_21_c(load_weight_data_21_c_6),
    .o_load_weight_data_21_d(load_weight_data_21_d_6),

    .o_load_weight_data_22_a(load_weight_data_22_a_6),
    .o_load_weight_data_22_b(load_weight_data_22_b_6),
    .o_load_weight_data_22_c(load_weight_data_22_c_6),
    .o_load_weight_data_22_d(load_weight_data_22_d_6),

    .o_load_weight_data_23_a(load_weight_data_23_a_6),
    .o_load_weight_data_23_b(load_weight_data_23_b_6),
    .o_load_weight_data_23_c(load_weight_data_23_c_6),
    .o_load_weight_data_23_d(load_weight_data_23_d_6),

    .o_load_weight_data_24_a(load_weight_data_24_a_6),
    .o_load_weight_data_24_b(load_weight_data_24_b_6),
    .o_load_weight_data_24_c(load_weight_data_24_c_6),
    .o_load_weight_data_24_d(load_weight_data_24_d_6),

    .o_load_weight_data_25_a(load_weight_data_25_a_6),
    .o_load_weight_data_25_b(load_weight_data_25_b_6),
    .o_load_weight_data_25_c(load_weight_data_25_c_6),
    .o_load_weight_data_25_d(load_weight_data_25_d_6),

    .o_load_weight_data_26_a(load_weight_data_26_a_6),
    .o_load_weight_data_26_b(load_weight_data_26_b_6),
    .o_load_weight_data_26_c(load_weight_data_26_c_6),
    .o_load_weight_data_26_d(load_weight_data_26_d_6),

    .o_load_weight_data_27_a(load_weight_data_27_a_6),
    .o_load_weight_data_27_b(load_weight_data_27_b_6),
    .o_load_weight_data_27_c(load_weight_data_27_c_6),
    .o_load_weight_data_27_d(load_weight_data_27_d_6),

    .o_load_weight_data_28_a(load_weight_data_28_a_6),
    .o_load_weight_data_28_b(load_weight_data_28_b_6),
    .o_load_weight_data_28_c(load_weight_data_28_c_6),
    .o_load_weight_data_28_d(load_weight_data_28_d_6),

    .o_load_weight_data_29_a(load_weight_data_29_a_6),
    .o_load_weight_data_29_b(load_weight_data_29_b_6),
    .o_load_weight_data_29_c(load_weight_data_29_c_6),
    .o_load_weight_data_29_d(load_weight_data_29_d_6),

    .o_load_weight_data_30_a(load_weight_data_30_a_6),
    .o_load_weight_data_30_b(load_weight_data_30_b_6),
    .o_load_weight_data_30_c(load_weight_data_30_c_6),
    .o_load_weight_data_30_d(load_weight_data_30_d_6),

    .o_load_weight_data_31_a(load_weight_data_31_a_6),
    .o_load_weight_data_31_b(load_weight_data_31_b_6),
    .o_load_weight_data_31_c(load_weight_data_31_c_6),
    .o_load_weight_data_31_d(load_weight_data_31_d_6)  
  );
  
  processing_element
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) processing_element_6(
    .clk(clk), 
    .rst_n(rst_n),
    
    //Write Buffer Control
    .prepare_weight(i_prepare_weight),
    .buffer_wr_en_i(buffer_wr_en_i),
    .buffer_wr_addr_i(buffer_wr_addr_i),
    
    //Execute Control
    .set_weight_i(set_weight_i),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(buffer_rd_en_5_o),
    .activation_rd_en_o(buffer_rd_en_6_o),
    .buffer_rd_addr_i(buffer_rd_addr_5_o),
    .buffer_rd_addr_o(buffer_rd_addr_6_o),   
    
    .buffer_data_i(buffer_data_6_i),
  
    //mac array
    //mac adder input
    .mac_acc_a_0_i(mac_acc_5_a_0_o),   .mac_acc_b_0_i(mac_acc_5_b_0_o),   .mac_acc_c_0_i(mac_acc_5_c_0_o),  .mac_acc_d_0_i(mac_acc_5_d_0_o),
    .mac_acc_a_1_i(mac_acc_5_a_1_o),   .mac_acc_b_1_i(mac_acc_5_b_1_o),   .mac_acc_c_1_i(mac_acc_5_c_1_o),  .mac_acc_d_1_i(mac_acc_5_d_1_o),
    .mac_acc_a_2_i(mac_acc_5_a_2_o),   .mac_acc_b_2_i(mac_acc_5_b_2_o),   .mac_acc_c_2_i(mac_acc_5_c_2_o),  .mac_acc_d_2_i(mac_acc_5_d_2_o),
    .mac_acc_a_3_i(mac_acc_5_a_3_o),   .mac_acc_b_3_i(mac_acc_5_b_3_o),   .mac_acc_c_3_i(mac_acc_5_c_3_o),  .mac_acc_d_3_i(mac_acc_5_d_3_o),
    .mac_acc_a_4_i(mac_acc_5_a_4_o),   .mac_acc_b_4_i(mac_acc_5_b_4_o),   .mac_acc_c_4_i(mac_acc_5_c_4_o),  .mac_acc_d_4_i(mac_acc_5_d_4_o),
    .mac_acc_a_5_i(mac_acc_5_a_5_o),   .mac_acc_b_5_i(mac_acc_5_b_5_o),   .mac_acc_c_5_i(mac_acc_5_c_5_o),  .mac_acc_d_5_i(mac_acc_5_d_5_o),
    .mac_acc_a_6_i(mac_acc_5_a_6_o),   .mac_acc_b_6_i(mac_acc_5_b_6_o),   .mac_acc_c_6_i(mac_acc_5_c_6_o),  .mac_acc_d_6_i(mac_acc_5_d_6_o),
    .mac_acc_a_7_i(mac_acc_5_a_7_o),   .mac_acc_b_7_i(mac_acc_5_b_7_o),   .mac_acc_c_7_i(mac_acc_5_c_7_o),  .mac_acc_d_7_i(mac_acc_5_d_7_o),
    .mac_acc_a_8_i(mac_acc_5_a_8_o),   .mac_acc_b_8_i(mac_acc_5_b_8_o),   .mac_acc_c_8_i(mac_acc_5_c_8_o),  .mac_acc_d_8_i(mac_acc_5_d_8_o),
    .mac_acc_a_9_i(mac_acc_5_a_9_o),   .mac_acc_b_9_i(mac_acc_5_b_9_o),   .mac_acc_c_9_i(mac_acc_5_c_9_o),  .mac_acc_d_9_i(mac_acc_5_d_9_o),
    .mac_acc_a_10_i(mac_acc_5_a_10_o), .mac_acc_b_10_i(mac_acc_5_b_10_o), .mac_acc_c_10_i(mac_acc_5_c_10_o), .mac_acc_d_10_i(mac_acc_5_d_10_o),
    .mac_acc_a_11_i(mac_acc_5_a_11_o), .mac_acc_b_11_i(mac_acc_5_b_11_o), .mac_acc_c_11_i(mac_acc_5_c_11_o), .mac_acc_d_11_i(mac_acc_5_d_11_o),
    .mac_acc_a_12_i(mac_acc_5_a_12_o), .mac_acc_b_12_i(mac_acc_5_b_12_o), .mac_acc_c_12_i(mac_acc_5_c_12_o), .mac_acc_d_12_i(mac_acc_5_d_12_o),
    .mac_acc_a_13_i(mac_acc_5_a_13_o), .mac_acc_b_13_i(mac_acc_5_b_13_o), .mac_acc_c_13_i(mac_acc_5_c_13_o), .mac_acc_d_13_i(mac_acc_5_d_13_o),
    .mac_acc_a_14_i(mac_acc_5_a_14_o), .mac_acc_b_14_i(mac_acc_5_b_14_o), .mac_acc_c_14_i(mac_acc_5_c_14_o), .mac_acc_d_14_i(mac_acc_5_d_14_o),
    .mac_acc_a_15_i(mac_acc_5_a_15_o), .mac_acc_b_15_i(mac_acc_5_b_15_o), .mac_acc_c_15_i(mac_acc_5_c_15_o),  .mac_acc_d_15_i(mac_acc_5_d_15_o),
    //mac array output
    .mac_acc_a_0_o(mac_acc_6_a_0_o),   .mac_acc_b_0_o(mac_acc_6_b_0_o),   .mac_acc_c_0_o(mac_acc_6_c_0_o),   .mac_acc_d_0_o(mac_acc_6_d_0_o),
    .mac_acc_a_1_o(mac_acc_6_a_1_o),   .mac_acc_b_1_o(mac_acc_6_b_1_o),   .mac_acc_c_1_o(mac_acc_6_c_1_o),   .mac_acc_d_1_o(mac_acc_6_d_1_o),
    .mac_acc_a_2_o(mac_acc_6_a_2_o),   .mac_acc_b_2_o(mac_acc_6_b_2_o),   .mac_acc_c_2_o(mac_acc_6_c_2_o),   .mac_acc_d_2_o(mac_acc_6_d_2_o),
    .mac_acc_a_3_o(mac_acc_6_a_3_o),   .mac_acc_b_3_o(mac_acc_6_b_3_o),   .mac_acc_c_3_o(mac_acc_6_c_3_o),   .mac_acc_d_3_o(mac_acc_6_d_3_o),
    .mac_acc_a_4_o(mac_acc_6_a_4_o),   .mac_acc_b_4_o(mac_acc_6_b_4_o),   .mac_acc_c_4_o(mac_acc_6_c_4_o),   .mac_acc_d_4_o(mac_acc_6_d_4_o),
    .mac_acc_a_5_o(mac_acc_6_a_5_o),   .mac_acc_b_5_o(mac_acc_6_b_5_o),   .mac_acc_c_5_o(mac_acc_6_c_5_o),   .mac_acc_d_5_o(mac_acc_6_d_5_o),
    .mac_acc_a_6_o(mac_acc_6_a_6_o),   .mac_acc_b_6_o(mac_acc_6_b_6_o),   .mac_acc_c_6_o(mac_acc_6_c_6_o),   .mac_acc_d_6_o(mac_acc_6_d_6_o),
    .mac_acc_a_7_o(mac_acc_6_a_7_o),   .mac_acc_b_7_o(mac_acc_6_b_7_o),   .mac_acc_c_7_o(mac_acc_6_c_7_o),   .mac_acc_d_7_o(mac_acc_6_d_7_o),
    .mac_acc_a_8_o(mac_acc_6_a_8_o),   .mac_acc_b_8_o(mac_acc_6_b_8_o),   .mac_acc_c_8_o(mac_acc_6_c_8_o),   .mac_acc_d_8_o(mac_acc_6_d_8_o),
    .mac_acc_a_9_o(mac_acc_6_a_9_o),   .mac_acc_b_9_o(mac_acc_6_b_9_o),   .mac_acc_c_9_o(mac_acc_6_c_9_o),   .mac_acc_d_9_o(mac_acc_6_d_9_o),
    .mac_acc_a_10_o(mac_acc_6_a_10_o), .mac_acc_b_10_o(mac_acc_6_b_10_o), .mac_acc_c_10_o(mac_acc_6_c_10_o), .mac_acc_d_10_o(mac_acc_6_d_10_o),
    .mac_acc_a_11_o(mac_acc_6_a_11_o), .mac_acc_b_11_o(mac_acc_6_b_11_o), .mac_acc_c_11_o(mac_acc_6_c_11_o), .mac_acc_d_11_o(mac_acc_6_d_11_o),
    .mac_acc_a_12_o(mac_acc_6_a_12_o), .mac_acc_b_12_o(mac_acc_6_b_12_o), .mac_acc_c_12_o(mac_acc_6_c_12_o), .mac_acc_d_12_o(mac_acc_6_d_12_o),
    .mac_acc_a_13_o(mac_acc_6_a_13_o), .mac_acc_b_13_o(mac_acc_6_b_13_o), .mac_acc_c_13_o(mac_acc_6_c_13_o), .mac_acc_d_13_o(mac_acc_6_d_13_o),
    .mac_acc_a_14_o(mac_acc_6_a_14_o), .mac_acc_b_14_o(mac_acc_6_b_14_o), .mac_acc_c_14_o(mac_acc_6_c_14_o), .mac_acc_d_14_o(mac_acc_6_d_14_o),
    .mac_acc_a_15_o(mac_acc_6_a_15_o), .mac_acc_b_15_o(mac_acc_6_b_15_o), .mac_acc_c_15_o(mac_acc_6_c_15_o),  .mac_acc_d_15_o(mac_acc_6_d_15_o),
    
    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_6),
    .i_load_weight_data_0_b(load_weight_data_0_b_6),
    .i_load_weight_data_0_c(load_weight_data_0_c_6),
    .i_load_weight_data_0_d(load_weight_data_0_d_6),

    .i_load_weight_data_1_a(load_weight_data_1_a_6),
    .i_load_weight_data_1_b(load_weight_data_1_b_6),
    .i_load_weight_data_1_c(load_weight_data_1_c_6),
    .i_load_weight_data_1_d(load_weight_data_1_d_6),

    .i_load_weight_data_2_a(load_weight_data_2_a_6),
    .i_load_weight_data_2_b(load_weight_data_2_b_6),
    .i_load_weight_data_2_c(load_weight_data_2_c_6),
    .i_load_weight_data_2_d(load_weight_data_2_d_6),

    .i_load_weight_data_3_a(load_weight_data_3_a_6),
    .i_load_weight_data_3_b(load_weight_data_3_b_6),
    .i_load_weight_data_3_c(load_weight_data_3_c_6),
    .i_load_weight_data_3_d(load_weight_data_3_d_6),

    .i_load_weight_data_4_a(load_weight_data_4_a_6),
    .i_load_weight_data_4_b(load_weight_data_4_b_6),
    .i_load_weight_data_4_c(load_weight_data_4_c_6),
    .i_load_weight_data_4_d(load_weight_data_4_d_6),

    .i_load_weight_data_5_a(load_weight_data_5_a_6),
    .i_load_weight_data_5_b(load_weight_data_5_b_6),
    .i_load_weight_data_5_c(load_weight_data_5_c_6),
    .i_load_weight_data_5_d(load_weight_data_5_d_6),

    .i_load_weight_data_6_a(load_weight_data_6_a_6),
    .i_load_weight_data_6_b(load_weight_data_6_b_6),
    .i_load_weight_data_6_c(load_weight_data_6_c_6),
    .i_load_weight_data_6_d(load_weight_data_6_d_6),

    .i_load_weight_data_7_a(load_weight_data_7_a_6),
    .i_load_weight_data_7_b(load_weight_data_7_b_6),
    .i_load_weight_data_7_c(load_weight_data_7_c_6),
    .i_load_weight_data_7_d(load_weight_data_7_d_6),

    .i_load_weight_data_8_a(load_weight_data_8_a_6),
    .i_load_weight_data_8_b(load_weight_data_8_b_6),
    .i_load_weight_data_8_c(load_weight_data_8_c_6),
    .i_load_weight_data_8_d(load_weight_data_8_d_6),

    .i_load_weight_data_9_a(load_weight_data_9_a_6),
    .i_load_weight_data_9_b(load_weight_data_9_b_6),
    .i_load_weight_data_9_c(load_weight_data_9_c_6),
    .i_load_weight_data_9_d(load_weight_data_9_d_6),

    .i_load_weight_data_10_a(load_weight_data_10_a_6),
    .i_load_weight_data_10_b(load_weight_data_10_b_6),
    .i_load_weight_data_10_c(load_weight_data_10_c_6),
    .i_load_weight_data_10_d(load_weight_data_10_d_6),

    .i_load_weight_data_11_a(load_weight_data_11_a_6),
    .i_load_weight_data_11_b(load_weight_data_11_b_6),
    .i_load_weight_data_11_c(load_weight_data_11_c_6),
    .i_load_weight_data_11_d(load_weight_data_11_d_6),

    .i_load_weight_data_12_a(load_weight_data_12_a_6),
    .i_load_weight_data_12_b(load_weight_data_12_b_6),
    .i_load_weight_data_12_c(load_weight_data_12_c_6),
    .i_load_weight_data_12_d(load_weight_data_12_d_6),

    .i_load_weight_data_13_a(load_weight_data_13_a_6),
    .i_load_weight_data_13_b(load_weight_data_13_b_6),
    .i_load_weight_data_13_c(load_weight_data_13_c_6),
    .i_load_weight_data_13_d(load_weight_data_13_d_6),

    .i_load_weight_data_14_a(load_weight_data_14_a_6),
    .i_load_weight_data_14_b(load_weight_data_14_b_6),
    .i_load_weight_data_14_c(load_weight_data_14_c_6),
    .i_load_weight_data_14_d(load_weight_data_14_d_6),

    .i_load_weight_data_15_a(load_weight_data_15_a_6),
    .i_load_weight_data_15_b(load_weight_data_15_b_6),
    .i_load_weight_data_15_c(load_weight_data_15_c_6),
    .i_load_weight_data_15_d(load_weight_data_15_d_6),

    .i_load_weight_data_16_a(load_weight_data_16_a_6),
    .i_load_weight_data_16_b(load_weight_data_16_b_6),
    .i_load_weight_data_16_c(load_weight_data_16_c_6),
    .i_load_weight_data_16_d(load_weight_data_16_d_6),

    .i_load_weight_data_17_a(load_weight_data_17_a_6),
    .i_load_weight_data_17_b(load_weight_data_17_b_6),
    .i_load_weight_data_17_c(load_weight_data_17_c_6),
    .i_load_weight_data_17_d(load_weight_data_17_d_6),

    .i_load_weight_data_18_a(load_weight_data_18_a_6),
    .i_load_weight_data_18_b(load_weight_data_18_b_6),
    .i_load_weight_data_18_c(load_weight_data_18_c_6),
    .i_load_weight_data_18_d(load_weight_data_18_d_6),

    .i_load_weight_data_19_a(load_weight_data_19_a_6),
    .i_load_weight_data_19_b(load_weight_data_19_b_6),
    .i_load_weight_data_19_c(load_weight_data_19_c_6),
    .i_load_weight_data_19_d(load_weight_data_19_d_6),

    .i_load_weight_data_20_a(load_weight_data_20_a_6),
    .i_load_weight_data_20_b(load_weight_data_20_b_6),
    .i_load_weight_data_20_c(load_weight_data_20_c_6),
    .i_load_weight_data_20_d(load_weight_data_20_d_6),

    .i_load_weight_data_21_a(load_weight_data_21_a_6),
    .i_load_weight_data_21_b(load_weight_data_21_b_6),
    .i_load_weight_data_21_c(load_weight_data_21_c_6),
    .i_load_weight_data_21_d(load_weight_data_21_d_6),

    .i_load_weight_data_22_a(load_weight_data_22_a_6),
    .i_load_weight_data_22_b(load_weight_data_22_b_6),
    .i_load_weight_data_22_c(load_weight_data_22_c_6),
    .i_load_weight_data_22_d(load_weight_data_22_d_6),

    .i_load_weight_data_23_a(load_weight_data_23_a_6),
    .i_load_weight_data_23_b(load_weight_data_23_b_6),
    .i_load_weight_data_23_c(load_weight_data_23_c_6),
    .i_load_weight_data_23_d(load_weight_data_23_d_6),

    .i_load_weight_data_24_a(load_weight_data_24_a_6),
    .i_load_weight_data_24_b(load_weight_data_24_b_6),
    .i_load_weight_data_24_c(load_weight_data_24_c_6),
    .i_load_weight_data_24_d(load_weight_data_24_d_6),

    .i_load_weight_data_25_a(load_weight_data_25_a_6),
    .i_load_weight_data_25_b(load_weight_data_25_b_6),
    .i_load_weight_data_25_c(load_weight_data_25_c_6),
    .i_load_weight_data_25_d(load_weight_data_25_d_6),

    .i_load_weight_data_26_a(load_weight_data_26_a_6),
    .i_load_weight_data_26_b(load_weight_data_26_b_6),
    .i_load_weight_data_26_c(load_weight_data_26_c_6),
    .i_load_weight_data_26_d(load_weight_data_26_d_6),

    .i_load_weight_data_27_a(load_weight_data_27_a_6),
    .i_load_weight_data_27_b(load_weight_data_27_b_6),
    .i_load_weight_data_27_c(load_weight_data_27_c_6),
    .i_load_weight_data_27_d(load_weight_data_27_d_6),

    .i_load_weight_data_28_a(load_weight_data_28_a_6),
    .i_load_weight_data_28_b(load_weight_data_28_b_6),
    .i_load_weight_data_28_c(load_weight_data_28_c_6),
    .i_load_weight_data_28_d(load_weight_data_28_d_6),

    .i_load_weight_data_29_a(load_weight_data_29_a_6),
    .i_load_weight_data_29_b(load_weight_data_29_b_6),
    .i_load_weight_data_29_c(load_weight_data_29_c_6),
    .i_load_weight_data_29_d(load_weight_data_29_d_6),

    .i_load_weight_data_30_a(load_weight_data_30_a_6),
    .i_load_weight_data_30_b(load_weight_data_30_b_6),
    .i_load_weight_data_30_c(load_weight_data_30_c_6),
    .i_load_weight_data_30_d(load_weight_data_30_d_6),

    .i_load_weight_data_31_a(load_weight_data_31_a_6),
    .i_load_weight_data_31_b(load_weight_data_31_b_6),
    .i_load_weight_data_31_c(load_weight_data_31_c_6),
    .i_load_weight_data_31_d(load_weight_data_31_d_6),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(load_weight_data_0_a_7),
    .o_load_weight_data_0_b(load_weight_data_0_b_7),
    .o_load_weight_data_0_c(load_weight_data_0_c_7),
    .o_load_weight_data_0_d(load_weight_data_0_d_7),

    .o_load_weight_data_1_a(load_weight_data_1_a_7),
    .o_load_weight_data_1_b(load_weight_data_1_b_7),
    .o_load_weight_data_1_c(load_weight_data_1_c_7),
    .o_load_weight_data_1_d(load_weight_data_1_d_7),

    .o_load_weight_data_2_a(load_weight_data_2_a_7),
    .o_load_weight_data_2_b(load_weight_data_2_b_7),
    .o_load_weight_data_2_c(load_weight_data_2_c_7),
    .o_load_weight_data_2_d(load_weight_data_2_d_7),

    .o_load_weight_data_3_a(load_weight_data_3_a_7),
    .o_load_weight_data_3_b(load_weight_data_3_b_7),
    .o_load_weight_data_3_c(load_weight_data_3_c_7),
    .o_load_weight_data_3_d(load_weight_data_3_d_7),

    .o_load_weight_data_4_a(load_weight_data_4_a_7),
    .o_load_weight_data_4_b(load_weight_data_4_b_7),
    .o_load_weight_data_4_c(load_weight_data_4_c_7),
    .o_load_weight_data_4_d(load_weight_data_4_d_7),

    .o_load_weight_data_5_a(load_weight_data_5_a_7),
    .o_load_weight_data_5_b(load_weight_data_5_b_7),
    .o_load_weight_data_5_c(load_weight_data_5_c_7),
    .o_load_weight_data_5_d(load_weight_data_5_d_7),

    .o_load_weight_data_6_a(load_weight_data_6_a_7),
    .o_load_weight_data_6_b(load_weight_data_6_b_7),
    .o_load_weight_data_6_c(load_weight_data_6_c_7),
    .o_load_weight_data_6_d(load_weight_data_6_d_7),

    .o_load_weight_data_7_a(load_weight_data_7_a_7),
    .o_load_weight_data_7_b(load_weight_data_7_b_7),
    .o_load_weight_data_7_c(load_weight_data_7_c_7),
    .o_load_weight_data_7_d(load_weight_data_7_d_7),

    .o_load_weight_data_8_a(load_weight_data_8_a_7),
    .o_load_weight_data_8_b(load_weight_data_8_b_7),
    .o_load_weight_data_8_c(load_weight_data_8_c_7),
    .o_load_weight_data_8_d(load_weight_data_8_d_7),

    .o_load_weight_data_9_a(load_weight_data_9_a_7),
    .o_load_weight_data_9_b(load_weight_data_9_b_7),
    .o_load_weight_data_9_c(load_weight_data_9_c_7),
    .o_load_weight_data_9_d(load_weight_data_9_d_7),

    .o_load_weight_data_10_a(load_weight_data_10_a_7),
    .o_load_weight_data_10_b(load_weight_data_10_b_7),
    .o_load_weight_data_10_c(load_weight_data_10_c_7),
    .o_load_weight_data_10_d(load_weight_data_10_d_7),

    .o_load_weight_data_11_a(load_weight_data_11_a_7),
    .o_load_weight_data_11_b(load_weight_data_11_b_7),
    .o_load_weight_data_11_c(load_weight_data_11_c_7),
    .o_load_weight_data_11_d(load_weight_data_11_d_7),

    .o_load_weight_data_12_a(load_weight_data_12_a_7),
    .o_load_weight_data_12_b(load_weight_data_12_b_7),
    .o_load_weight_data_12_c(load_weight_data_12_c_7),
    .o_load_weight_data_12_d(load_weight_data_12_d_7),

    .o_load_weight_data_13_a(load_weight_data_13_a_7),
    .o_load_weight_data_13_b(load_weight_data_13_b_7),
    .o_load_weight_data_13_c(load_weight_data_13_c_7),
    .o_load_weight_data_13_d(load_weight_data_13_d_7),

    .o_load_weight_data_14_a(load_weight_data_14_a_7),
    .o_load_weight_data_14_b(load_weight_data_14_b_7),
    .o_load_weight_data_14_c(load_weight_data_14_c_7),
    .o_load_weight_data_14_d(load_weight_data_14_d_7),

    .o_load_weight_data_15_a(load_weight_data_15_a_7),
    .o_load_weight_data_15_b(load_weight_data_15_b_7),
    .o_load_weight_data_15_c(load_weight_data_15_c_7),
    .o_load_weight_data_15_d(load_weight_data_15_d_7),

    .o_load_weight_data_16_a(load_weight_data_16_a_7),
    .o_load_weight_data_16_b(load_weight_data_16_b_7),
    .o_load_weight_data_16_c(load_weight_data_16_c_7),
    .o_load_weight_data_16_d(load_weight_data_16_d_7),

    .o_load_weight_data_17_a(load_weight_data_17_a_7),
    .o_load_weight_data_17_b(load_weight_data_17_b_7),
    .o_load_weight_data_17_c(load_weight_data_17_c_7),
    .o_load_weight_data_17_d(load_weight_data_17_d_7),

    .o_load_weight_data_18_a(load_weight_data_18_a_7),
    .o_load_weight_data_18_b(load_weight_data_18_b_7),
    .o_load_weight_data_18_c(load_weight_data_18_c_7),
    .o_load_weight_data_18_d(load_weight_data_18_d_7),

    .o_load_weight_data_19_a(load_weight_data_19_a_7),
    .o_load_weight_data_19_b(load_weight_data_19_b_7),
    .o_load_weight_data_19_c(load_weight_data_19_c_7),
    .o_load_weight_data_19_d(load_weight_data_19_d_7),

    .o_load_weight_data_20_a(load_weight_data_20_a_7),
    .o_load_weight_data_20_b(load_weight_data_20_b_7),
    .o_load_weight_data_20_c(load_weight_data_20_c_7),
    .o_load_weight_data_20_d(load_weight_data_20_d_7),

    .o_load_weight_data_21_a(load_weight_data_21_a_7),
    .o_load_weight_data_21_b(load_weight_data_21_b_7),
    .o_load_weight_data_21_c(load_weight_data_21_c_7),
    .o_load_weight_data_21_d(load_weight_data_21_d_7),

    .o_load_weight_data_22_a(load_weight_data_22_a_7),
    .o_load_weight_data_22_b(load_weight_data_22_b_7),
    .o_load_weight_data_22_c(load_weight_data_22_c_7),
    .o_load_weight_data_22_d(load_weight_data_22_d_7),

    .o_load_weight_data_23_a(load_weight_data_23_a_7),
    .o_load_weight_data_23_b(load_weight_data_23_b_7),
    .o_load_weight_data_23_c(load_weight_data_23_c_7),
    .o_load_weight_data_23_d(load_weight_data_23_d_7),

    .o_load_weight_data_24_a(load_weight_data_24_a_7),
    .o_load_weight_data_24_b(load_weight_data_24_b_7),
    .o_load_weight_data_24_c(load_weight_data_24_c_7),
    .o_load_weight_data_24_d(load_weight_data_24_d_7),

    .o_load_weight_data_25_a(load_weight_data_25_a_7),
    .o_load_weight_data_25_b(load_weight_data_25_b_7),
    .o_load_weight_data_25_c(load_weight_data_25_c_7),
    .o_load_weight_data_25_d(load_weight_data_25_d_7),

    .o_load_weight_data_26_a(load_weight_data_26_a_7),
    .o_load_weight_data_26_b(load_weight_data_26_b_7),
    .o_load_weight_data_26_c(load_weight_data_26_c_7),
    .o_load_weight_data_26_d(load_weight_data_26_d_7),

    .o_load_weight_data_27_a(load_weight_data_27_a_7),
    .o_load_weight_data_27_b(load_weight_data_27_b_7),
    .o_load_weight_data_27_c(load_weight_data_27_c_7),
    .o_load_weight_data_27_d(load_weight_data_27_d_7),

    .o_load_weight_data_28_a(load_weight_data_28_a_7),
    .o_load_weight_data_28_b(load_weight_data_28_b_7),
    .o_load_weight_data_28_c(load_weight_data_28_c_7),
    .o_load_weight_data_28_d(load_weight_data_28_d_7),

    .o_load_weight_data_29_a(load_weight_data_29_a_7),
    .o_load_weight_data_29_b(load_weight_data_29_b_7),
    .o_load_weight_data_29_c(load_weight_data_29_c_7),
    .o_load_weight_data_29_d(load_weight_data_29_d_7),

    .o_load_weight_data_30_a(load_weight_data_30_a_7),
    .o_load_weight_data_30_b(load_weight_data_30_b_7),
    .o_load_weight_data_30_c(load_weight_data_30_c_7),
    .o_load_weight_data_30_d(load_weight_data_30_d_7),

    .o_load_weight_data_31_a(load_weight_data_31_a_7),
    .o_load_weight_data_31_b(load_weight_data_31_b_7),
    .o_load_weight_data_31_c(load_weight_data_31_c_7),
    .o_load_weight_data_31_d(load_weight_data_31_d_7)  
  );

  processing_element
  #(
    .QUNATIZED_MANTISSA_WIDTH(QUNATIZED_MANTISSA_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) processing_element_7(
    .clk(clk), 
    .rst_n(rst_n),

    //Write Buffer Control
    .prepare_weight(i_prepare_weight),
    .buffer_wr_en_i(buffer_wr_en_i),
    .buffer_wr_addr_i(buffer_wr_addr_i),
    
    //Execute Control
    .set_weight_i(set_weight_i),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(buffer_rd_en_6_o),
    .activation_rd_en_o(buffer_rd_en_7_o),
    .buffer_rd_addr_i(buffer_rd_addr_6_o),
    .buffer_rd_addr_o(buffer_rd_addr_7_o), 
    
    .buffer_data_i(buffer_data_7_i),
  
    //mac array
    //mac adder input
    .mac_acc_a_0_i(mac_acc_6_a_0_o),   .mac_acc_b_0_i(mac_acc_6_b_0_o),   .mac_acc_c_0_i(mac_acc_6_c_0_o),  .mac_acc_d_0_i(mac_acc_6_d_0_o),
    .mac_acc_a_1_i(mac_acc_6_a_1_o),   .mac_acc_b_1_i(mac_acc_6_b_1_o),   .mac_acc_c_1_i(mac_acc_6_c_1_o),  .mac_acc_d_1_i(mac_acc_6_d_1_o),
    .mac_acc_a_2_i(mac_acc_6_a_2_o),   .mac_acc_b_2_i(mac_acc_6_b_2_o),   .mac_acc_c_2_i(mac_acc_6_c_2_o),  .mac_acc_d_2_i(mac_acc_6_d_2_o),
    .mac_acc_a_3_i(mac_acc_6_a_3_o),   .mac_acc_b_3_i(mac_acc_6_b_3_o),   .mac_acc_c_3_i(mac_acc_6_c_3_o),  .mac_acc_d_3_i(mac_acc_6_d_3_o),
    .mac_acc_a_4_i(mac_acc_6_a_4_o),   .mac_acc_b_4_i(mac_acc_6_b_4_o),   .mac_acc_c_4_i(mac_acc_6_c_4_o),  .mac_acc_d_4_i(mac_acc_6_d_4_o),
    .mac_acc_a_5_i(mac_acc_6_a_5_o),   .mac_acc_b_5_i(mac_acc_6_b_5_o),   .mac_acc_c_5_i(mac_acc_6_c_5_o),  .mac_acc_d_5_i(mac_acc_6_d_5_o),
    .mac_acc_a_6_i(mac_acc_6_a_6_o),   .mac_acc_b_6_i(mac_acc_6_b_6_o),   .mac_acc_c_6_i(mac_acc_6_c_6_o),  .mac_acc_d_6_i(mac_acc_6_d_6_o),
    .mac_acc_a_7_i(mac_acc_6_a_7_o),   .mac_acc_b_7_i(mac_acc_6_b_7_o),   .mac_acc_c_7_i(mac_acc_6_c_7_o),  .mac_acc_d_7_i(mac_acc_6_d_7_o),
    .mac_acc_a_8_i(mac_acc_6_a_8_o),   .mac_acc_b_8_i(mac_acc_6_b_8_o),   .mac_acc_c_8_i(mac_acc_6_c_8_o),  .mac_acc_d_8_i(mac_acc_6_d_8_o),
    .mac_acc_a_9_i(mac_acc_6_a_9_o),   .mac_acc_b_9_i(mac_acc_6_b_9_o),   .mac_acc_c_9_i(mac_acc_6_c_9_o),  .mac_acc_d_9_i(mac_acc_6_d_9_o),
    .mac_acc_a_10_i(mac_acc_6_a_10_o), .mac_acc_b_10_i(mac_acc_6_b_10_o), .mac_acc_c_10_i(mac_acc_6_c_10_o), .mac_acc_d_10_i(mac_acc_6_d_10_o),
    .mac_acc_a_11_i(mac_acc_6_a_11_o), .mac_acc_b_11_i(mac_acc_6_b_11_o), .mac_acc_c_11_i(mac_acc_6_c_11_o), .mac_acc_d_11_i(mac_acc_6_d_11_o),
    .mac_acc_a_12_i(mac_acc_6_a_12_o), .mac_acc_b_12_i(mac_acc_6_b_12_o), .mac_acc_c_12_i(mac_acc_6_c_12_o), .mac_acc_d_12_i(mac_acc_6_d_12_o),
    .mac_acc_a_13_i(mac_acc_6_a_13_o), .mac_acc_b_13_i(mac_acc_6_b_13_o), .mac_acc_c_13_i(mac_acc_6_c_13_o), .mac_acc_d_13_i(mac_acc_6_d_13_o),
    .mac_acc_a_14_i(mac_acc_6_a_14_o), .mac_acc_b_14_i(mac_acc_6_b_14_o), .mac_acc_c_14_i(mac_acc_6_c_14_o), .mac_acc_d_14_i(mac_acc_6_d_14_o),
    .mac_acc_a_15_i(mac_acc_6_a_15_o), .mac_acc_b_15_i(mac_acc_6_b_15_o), .mac_acc_c_15_i(mac_acc_6_c_15_o),  .mac_acc_d_15_i(mac_acc_6_d_15_o),
    //mac array output
    .mac_acc_a_0_o(mac_acc_7_a_0_o),   .mac_acc_b_0_o(mac_acc_7_b_0_o),   .mac_acc_c_0_o(mac_acc_7_c_0_o),   .mac_acc_d_0_o(mac_acc_7_d_0_o),
    .mac_acc_a_1_o(mac_acc_7_a_1_o),   .mac_acc_b_1_o(mac_acc_7_b_1_o),   .mac_acc_c_1_o(mac_acc_7_c_1_o),   .mac_acc_d_1_o(mac_acc_7_d_1_o),
    .mac_acc_a_2_o(mac_acc_7_a_2_o),   .mac_acc_b_2_o(mac_acc_7_b_2_o),   .mac_acc_c_2_o(mac_acc_7_c_2_o),   .mac_acc_d_2_o(mac_acc_7_d_2_o),
    .mac_acc_a_3_o(mac_acc_7_a_3_o),   .mac_acc_b_3_o(mac_acc_7_b_3_o),   .mac_acc_c_3_o(mac_acc_7_c_3_o),   .mac_acc_d_3_o(mac_acc_7_d_3_o),
    .mac_acc_a_4_o(mac_acc_7_a_4_o),   .mac_acc_b_4_o(mac_acc_7_b_4_o),   .mac_acc_c_4_o(mac_acc_7_c_4_o),   .mac_acc_d_4_o(mac_acc_7_d_4_o),
    .mac_acc_a_5_o(mac_acc_7_a_5_o),   .mac_acc_b_5_o(mac_acc_7_b_5_o),   .mac_acc_c_5_o(mac_acc_7_c_5_o),   .mac_acc_d_5_o(mac_acc_7_d_5_o),
    .mac_acc_a_6_o(mac_acc_7_a_6_o),   .mac_acc_b_6_o(mac_acc_7_b_6_o),   .mac_acc_c_6_o(mac_acc_7_c_6_o),   .mac_acc_d_6_o(mac_acc_7_d_6_o),
    .mac_acc_a_7_o(mac_acc_7_a_7_o),   .mac_acc_b_7_o(mac_acc_7_b_7_o),   .mac_acc_c_7_o(mac_acc_7_c_7_o),   .mac_acc_d_7_o(mac_acc_7_d_7_o),
    .mac_acc_a_8_o(mac_acc_7_a_8_o),   .mac_acc_b_8_o(mac_acc_7_b_8_o),   .mac_acc_c_8_o(mac_acc_7_c_8_o),   .mac_acc_d_8_o(mac_acc_7_d_8_o),
    .mac_acc_a_9_o(mac_acc_7_a_9_o),   .mac_acc_b_9_o(mac_acc_7_b_9_o),   .mac_acc_c_9_o(mac_acc_7_c_9_o),   .mac_acc_d_9_o(mac_acc_7_d_9_o),
    .mac_acc_a_10_o(mac_acc_7_a_10_o), .mac_acc_b_10_o(mac_acc_7_b_10_o), .mac_acc_c_10_o(mac_acc_7_c_10_o), .mac_acc_d_10_o(mac_acc_7_d_10_o),
    .mac_acc_a_11_o(mac_acc_7_a_11_o), .mac_acc_b_11_o(mac_acc_7_b_11_o), .mac_acc_c_11_o(mac_acc_7_c_11_o), .mac_acc_d_11_o(mac_acc_7_d_11_o),
    .mac_acc_a_12_o(mac_acc_7_a_12_o), .mac_acc_b_12_o(mac_acc_7_b_12_o), .mac_acc_c_12_o(mac_acc_7_c_12_o), .mac_acc_d_12_o(mac_acc_7_d_12_o),
    .mac_acc_a_13_o(mac_acc_7_a_13_o), .mac_acc_b_13_o(mac_acc_7_b_13_o), .mac_acc_c_13_o(mac_acc_7_c_13_o), .mac_acc_d_13_o(mac_acc_7_d_13_o),
    .mac_acc_a_14_o(mac_acc_7_a_14_o), .mac_acc_b_14_o(mac_acc_7_b_14_o), .mac_acc_c_14_o(mac_acc_7_c_14_o), .mac_acc_d_14_o(mac_acc_7_d_14_o),
    .mac_acc_a_15_o(mac_acc_7_a_15_o), .mac_acc_b_15_o(mac_acc_7_b_15_o), .mac_acc_c_15_o(mac_acc_7_c_15_o),  .mac_acc_d_15_o(mac_acc_7_d_15_o),

        
    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_7),
    .i_load_weight_data_0_b(load_weight_data_0_b_7),
    .i_load_weight_data_0_c(load_weight_data_0_c_7),
    .i_load_weight_data_0_d(load_weight_data_0_d_7),

    .i_load_weight_data_1_a(load_weight_data_1_a_7),
    .i_load_weight_data_1_b(load_weight_data_1_b_7),
    .i_load_weight_data_1_c(load_weight_data_1_c_7),
    .i_load_weight_data_1_d(load_weight_data_1_d_7),

    .i_load_weight_data_2_a(load_weight_data_2_a_7),
    .i_load_weight_data_2_b(load_weight_data_2_b_7),
    .i_load_weight_data_2_c(load_weight_data_2_c_7),
    .i_load_weight_data_2_d(load_weight_data_2_d_7),

    .i_load_weight_data_3_a(load_weight_data_3_a_7),
    .i_load_weight_data_3_b(load_weight_data_3_b_7),
    .i_load_weight_data_3_c(load_weight_data_3_c_7),
    .i_load_weight_data_3_d(load_weight_data_3_d_7),

    .i_load_weight_data_4_a(load_weight_data_4_a_7),
    .i_load_weight_data_4_b(load_weight_data_4_b_7),
    .i_load_weight_data_4_c(load_weight_data_4_c_7),
    .i_load_weight_data_4_d(load_weight_data_4_d_7),

    .i_load_weight_data_5_a(load_weight_data_5_a_7),
    .i_load_weight_data_5_b(load_weight_data_5_b_7),
    .i_load_weight_data_5_c(load_weight_data_5_c_7),
    .i_load_weight_data_5_d(load_weight_data_5_d_7),

    .i_load_weight_data_6_a(load_weight_data_6_a_7),
    .i_load_weight_data_6_b(load_weight_data_6_b_7),
    .i_load_weight_data_6_c(load_weight_data_6_c_7),
    .i_load_weight_data_6_d(load_weight_data_6_d_7),

    .i_load_weight_data_7_a(load_weight_data_7_a_7),
    .i_load_weight_data_7_b(load_weight_data_7_b_7),
    .i_load_weight_data_7_c(load_weight_data_7_c_7),
    .i_load_weight_data_7_d(load_weight_data_7_d_7),

    .i_load_weight_data_8_a(load_weight_data_8_a_7),
    .i_load_weight_data_8_b(load_weight_data_8_b_7),
    .i_load_weight_data_8_c(load_weight_data_8_c_7),
    .i_load_weight_data_8_d(load_weight_data_8_d_7),

    .i_load_weight_data_9_a(load_weight_data_9_a_7),
    .i_load_weight_data_9_b(load_weight_data_9_b_7),
    .i_load_weight_data_9_c(load_weight_data_9_c_7),
    .i_load_weight_data_9_d(load_weight_data_9_d_7),

    .i_load_weight_data_10_a(load_weight_data_10_a_7),
    .i_load_weight_data_10_b(load_weight_data_10_b_7),
    .i_load_weight_data_10_c(load_weight_data_10_c_7),
    .i_load_weight_data_10_d(load_weight_data_10_d_7),

    .i_load_weight_data_11_a(load_weight_data_11_a_7),
    .i_load_weight_data_11_b(load_weight_data_11_b_7),
    .i_load_weight_data_11_c(load_weight_data_11_c_7),
    .i_load_weight_data_11_d(load_weight_data_11_d_7),

    .i_load_weight_data_12_a(load_weight_data_12_a_7),
    .i_load_weight_data_12_b(load_weight_data_12_b_7),
    .i_load_weight_data_12_c(load_weight_data_12_c_7),
    .i_load_weight_data_12_d(load_weight_data_12_d_7),

    .i_load_weight_data_13_a(load_weight_data_13_a_7),
    .i_load_weight_data_13_b(load_weight_data_13_b_7),
    .i_load_weight_data_13_c(load_weight_data_13_c_7),
    .i_load_weight_data_13_d(load_weight_data_13_d_7),

    .i_load_weight_data_14_a(load_weight_data_14_a_7),
    .i_load_weight_data_14_b(load_weight_data_14_b_7),
    .i_load_weight_data_14_c(load_weight_data_14_c_7),
    .i_load_weight_data_14_d(load_weight_data_14_d_7),

    .i_load_weight_data_15_a(load_weight_data_15_a_7),
    .i_load_weight_data_15_b(load_weight_data_15_b_7),
    .i_load_weight_data_15_c(load_weight_data_15_c_7),
    .i_load_weight_data_15_d(load_weight_data_15_d_7),

    .i_load_weight_data_16_a(load_weight_data_16_a_7),
    .i_load_weight_data_16_b(load_weight_data_16_b_7),
    .i_load_weight_data_16_c(load_weight_data_16_c_7),
    .i_load_weight_data_16_d(load_weight_data_16_d_7),

    .i_load_weight_data_17_a(load_weight_data_17_a_7),
    .i_load_weight_data_17_b(load_weight_data_17_b_7),
    .i_load_weight_data_17_c(load_weight_data_17_c_7),
    .i_load_weight_data_17_d(load_weight_data_17_d_7),

    .i_load_weight_data_18_a(load_weight_data_18_a_7),
    .i_load_weight_data_18_b(load_weight_data_18_b_7),
    .i_load_weight_data_18_c(load_weight_data_18_c_7),
    .i_load_weight_data_18_d(load_weight_data_18_d_7),

    .i_load_weight_data_19_a(load_weight_data_19_a_7),
    .i_load_weight_data_19_b(load_weight_data_19_b_7),
    .i_load_weight_data_19_c(load_weight_data_19_c_7),
    .i_load_weight_data_19_d(load_weight_data_19_d_7),

    .i_load_weight_data_20_a(load_weight_data_20_a_7),
    .i_load_weight_data_20_b(load_weight_data_20_b_7),
    .i_load_weight_data_20_c(load_weight_data_20_c_7),
    .i_load_weight_data_20_d(load_weight_data_20_d_7),

    .i_load_weight_data_21_a(load_weight_data_21_a_7),
    .i_load_weight_data_21_b(load_weight_data_21_b_7),
    .i_load_weight_data_21_c(load_weight_data_21_c_7),
    .i_load_weight_data_21_d(load_weight_data_21_d_7),

    .i_load_weight_data_22_a(load_weight_data_22_a_7),
    .i_load_weight_data_22_b(load_weight_data_22_b_7),
    .i_load_weight_data_22_c(load_weight_data_22_c_7),
    .i_load_weight_data_22_d(load_weight_data_22_d_7),

    .i_load_weight_data_23_a(load_weight_data_23_a_7),
    .i_load_weight_data_23_b(load_weight_data_23_b_7),
    .i_load_weight_data_23_c(load_weight_data_23_c_7),
    .i_load_weight_data_23_d(load_weight_data_23_d_7),

    .i_load_weight_data_24_a(load_weight_data_24_a_7),
    .i_load_weight_data_24_b(load_weight_data_24_b_7),
    .i_load_weight_data_24_c(load_weight_data_24_c_7),
    .i_load_weight_data_24_d(load_weight_data_24_d_7),

    .i_load_weight_data_25_a(load_weight_data_25_a_7),
    .i_load_weight_data_25_b(load_weight_data_25_b_7),
    .i_load_weight_data_25_c(load_weight_data_25_c_7),
    .i_load_weight_data_25_d(load_weight_data_25_d_7),

    .i_load_weight_data_26_a(load_weight_data_26_a_7),
    .i_load_weight_data_26_b(load_weight_data_26_b_7),
    .i_load_weight_data_26_c(load_weight_data_26_c_7),
    .i_load_weight_data_26_d(load_weight_data_26_d_7),

    .i_load_weight_data_27_a(load_weight_data_27_a_7),
    .i_load_weight_data_27_b(load_weight_data_27_b_7),
    .i_load_weight_data_27_c(load_weight_data_27_c_7),
    .i_load_weight_data_27_d(load_weight_data_27_d_7),

    .i_load_weight_data_28_a(load_weight_data_28_a_7),
    .i_load_weight_data_28_b(load_weight_data_28_b_7),
    .i_load_weight_data_28_c(load_weight_data_28_c_7),
    .i_load_weight_data_28_d(load_weight_data_28_d_7),

    .i_load_weight_data_29_a(load_weight_data_29_a_7),
    .i_load_weight_data_29_b(load_weight_data_29_b_7),
    .i_load_weight_data_29_c(load_weight_data_29_c_7),
    .i_load_weight_data_29_d(load_weight_data_29_d_7),

    .i_load_weight_data_30_a(load_weight_data_30_a_7),
    .i_load_weight_data_30_b(load_weight_data_30_b_7),
    .i_load_weight_data_30_c(load_weight_data_30_c_7),
    .i_load_weight_data_30_d(load_weight_data_30_d_7),

    .i_load_weight_data_31_a(load_weight_data_31_a_7),
    .i_load_weight_data_31_b(load_weight_data_31_b_7),
    .i_load_weight_data_31_c(load_weight_data_31_c_7),
    .i_load_weight_data_31_d(load_weight_data_31_d_7),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(load_weight_data_0_a_expo),
    .o_load_weight_data_0_b(load_weight_data_0_b_expo),
    .o_load_weight_data_0_c(load_weight_data_0_c_expo),
    .o_load_weight_data_0_d(load_weight_data_0_d_expo),

    .o_load_weight_data_1_a(load_weight_data_1_a_expo),
    .o_load_weight_data_1_b(load_weight_data_1_b_expo),
    .o_load_weight_data_1_c(load_weight_data_1_c_expo),
    .o_load_weight_data_1_d(load_weight_data_1_d_expo),

    .o_load_weight_data_2_a(load_weight_data_2_a_expo),
    .o_load_weight_data_2_b(load_weight_data_2_b_expo),
    .o_load_weight_data_2_c(load_weight_data_2_c_expo),
    .o_load_weight_data_2_d(load_weight_data_2_d_expo),

    .o_load_weight_data_3_a(load_weight_data_3_a_expo),
    .o_load_weight_data_3_b(load_weight_data_3_b_expo),
    .o_load_weight_data_3_c(load_weight_data_3_c_expo),
    .o_load_weight_data_3_d(load_weight_data_3_d_expo),

    .o_load_weight_data_4_a(load_weight_data_4_a_expo),
    .o_load_weight_data_4_b(load_weight_data_4_b_expo),
    .o_load_weight_data_4_c(load_weight_data_4_c_expo),
    .o_load_weight_data_4_d(load_weight_data_4_d_expo),

    .o_load_weight_data_5_a(load_weight_data_5_a_expo),
    .o_load_weight_data_5_b(load_weight_data_5_b_expo),
    .o_load_weight_data_5_c(load_weight_data_5_c_expo),
    .o_load_weight_data_5_d(load_weight_data_5_d_expo),

    .o_load_weight_data_6_a(load_weight_data_6_a_expo),
    .o_load_weight_data_6_b(load_weight_data_6_b_expo),
    .o_load_weight_data_6_c(load_weight_data_6_c_expo),
    .o_load_weight_data_6_d(load_weight_data_6_d_expo),

    .o_load_weight_data_7_a(load_weight_data_7_a_expo),
    .o_load_weight_data_7_b(load_weight_data_7_b_expo),
    .o_load_weight_data_7_c(load_weight_data_7_c_expo),
    .o_load_weight_data_7_d(load_weight_data_7_d_expo),

    .o_load_weight_data_8_a(load_weight_data_8_a_expo),
    .o_load_weight_data_8_b(load_weight_data_8_b_expo),
    .o_load_weight_data_8_c(load_weight_data_8_c_expo),
    .o_load_weight_data_8_d(load_weight_data_8_d_expo),

    .o_load_weight_data_9_a(load_weight_data_9_a_expo),
    .o_load_weight_data_9_b(load_weight_data_9_b_expo),
    .o_load_weight_data_9_c(load_weight_data_9_c_expo),
    .o_load_weight_data_9_d(load_weight_data_9_d_expo),

    .o_load_weight_data_10_a(load_weight_data_10_a_expo),
    .o_load_weight_data_10_b(load_weight_data_10_b_expo),
    .o_load_weight_data_10_c(load_weight_data_10_c_expo),
    .o_load_weight_data_10_d(load_weight_data_10_d_expo),

    .o_load_weight_data_11_a(load_weight_data_11_a_expo),
    .o_load_weight_data_11_b(load_weight_data_11_b_expo),
    .o_load_weight_data_11_c(load_weight_data_11_c_expo),
    .o_load_weight_data_11_d(load_weight_data_11_d_expo),

    .o_load_weight_data_12_a(load_weight_data_12_a_expo),
    .o_load_weight_data_12_b(load_weight_data_12_b_expo),
    .o_load_weight_data_12_c(load_weight_data_12_c_expo),
    .o_load_weight_data_12_d(load_weight_data_12_d_expo),

    .o_load_weight_data_13_a(load_weight_data_13_a_expo),
    .o_load_weight_data_13_b(load_weight_data_13_b_expo),
    .o_load_weight_data_13_c(load_weight_data_13_c_expo),
    .o_load_weight_data_13_d(load_weight_data_13_d_expo),

    .o_load_weight_data_14_a(load_weight_data_14_a_expo),
    .o_load_weight_data_14_b(load_weight_data_14_b_expo),
    .o_load_weight_data_14_c(load_weight_data_14_c_expo),
    .o_load_weight_data_14_d(load_weight_data_14_d_expo),

    .o_load_weight_data_15_a(load_weight_data_15_a_expo),
    .o_load_weight_data_15_b(load_weight_data_15_b_expo),
    .o_load_weight_data_15_c(load_weight_data_15_c_expo),
    .o_load_weight_data_15_d(load_weight_data_15_d_expo),

    .o_load_weight_data_16_a(load_weight_data_16_a_expo),
    .o_load_weight_data_16_b(load_weight_data_16_b_expo),
    .o_load_weight_data_16_c(load_weight_data_16_c_expo),
    .o_load_weight_data_16_d(load_weight_data_16_d_expo),

    .o_load_weight_data_17_a(load_weight_data_17_a_expo),
    .o_load_weight_data_17_b(load_weight_data_17_b_expo),
    .o_load_weight_data_17_c(load_weight_data_17_c_expo),
    .o_load_weight_data_17_d(load_weight_data_17_d_expo),

    .o_load_weight_data_18_a(load_weight_data_18_a_expo),
    .o_load_weight_data_18_b(load_weight_data_18_b_expo),
    .o_load_weight_data_18_c(load_weight_data_18_c_expo),
    .o_load_weight_data_18_d(load_weight_data_18_d_expo),

    .o_load_weight_data_19_a(load_weight_data_19_a_expo),
    .o_load_weight_data_19_b(load_weight_data_19_b_expo),
    .o_load_weight_data_19_c(load_weight_data_19_c_expo),
    .o_load_weight_data_19_d(load_weight_data_19_d_expo),

    .o_load_weight_data_20_a(load_weight_data_20_a_expo),
    .o_load_weight_data_20_b(load_weight_data_20_b_expo),
    .o_load_weight_data_20_c(load_weight_data_20_c_expo),
    .o_load_weight_data_20_d(load_weight_data_20_d_expo),

    .o_load_weight_data_21_a(load_weight_data_21_a_expo),
    .o_load_weight_data_21_b(load_weight_data_21_b_expo),
    .o_load_weight_data_21_c(load_weight_data_21_c_expo),
    .o_load_weight_data_21_d(load_weight_data_21_d_expo),

    .o_load_weight_data_22_a(load_weight_data_22_a_expo),
    .o_load_weight_data_22_b(load_weight_data_22_b_expo),
    .o_load_weight_data_22_c(load_weight_data_22_c_expo),
    .o_load_weight_data_22_d(load_weight_data_22_d_expo),

    .o_load_weight_data_23_a(load_weight_data_23_a_expo),
    .o_load_weight_data_23_b(load_weight_data_23_b_expo),
    .o_load_weight_data_23_c(load_weight_data_23_c_expo),
    .o_load_weight_data_23_d(load_weight_data_23_d_expo),

    .o_load_weight_data_24_a(load_weight_data_24_a_expo),
    .o_load_weight_data_24_b(load_weight_data_24_b_expo),
    .o_load_weight_data_24_c(load_weight_data_24_c_expo),
    .o_load_weight_data_24_d(load_weight_data_24_d_expo),

    .o_load_weight_data_25_a(load_weight_data_25_a_expo),
    .o_load_weight_data_25_b(load_weight_data_25_b_expo),
    .o_load_weight_data_25_c(load_weight_data_25_c_expo),
    .o_load_weight_data_25_d(load_weight_data_25_d_expo),

    .o_load_weight_data_26_a(load_weight_data_26_a_expo),
    .o_load_weight_data_26_b(load_weight_data_26_b_expo),
    .o_load_weight_data_26_c(load_weight_data_26_c_expo),
    .o_load_weight_data_26_d(load_weight_data_26_d_expo),

    .o_load_weight_data_27_a(load_weight_data_27_a_expo),
    .o_load_weight_data_27_b(load_weight_data_27_b_expo),
    .o_load_weight_data_27_c(load_weight_data_27_c_expo),
    .o_load_weight_data_27_d(load_weight_data_27_d_expo),

    .o_load_weight_data_28_a(load_weight_data_28_a_expo),
    .o_load_weight_data_28_b(load_weight_data_28_b_expo),
    .o_load_weight_data_28_c(load_weight_data_28_c_expo),
    .o_load_weight_data_28_d(load_weight_data_28_d_expo),

    .o_load_weight_data_29_a(load_weight_data_29_a_expo),
    .o_load_weight_data_29_b(load_weight_data_29_b_expo),
    .o_load_weight_data_29_c(load_weight_data_29_c_expo),
    .o_load_weight_data_29_d(load_weight_data_29_d_expo),

    .o_load_weight_data_30_a(load_weight_data_30_a_expo),
    .o_load_weight_data_30_b(load_weight_data_30_b_expo),
    .o_load_weight_data_30_c(load_weight_data_30_c_expo),
    .o_load_weight_data_30_d(load_weight_data_30_d_expo),

    .o_load_weight_data_31_a(load_weight_data_31_a_expo),
    .o_load_weight_data_31_b(load_weight_data_31_b_expo),
    .o_load_weight_data_31_c(load_weight_data_31_c_expo),
    .o_load_weight_data_31_d(load_weight_data_31_d_expo)  
  );
  
  bfp_to_fp_converter
  #(
    .EXPONENT_WIDTH(EXPONENT_WIDTH),
    .MAC_ACC_WIDTH(MAC_ACC_WIDTH),
    .ACCUMULATOR_DATA_WIDTH(ACCUM_DATA_WIDTH),
    .BUFFER_ADDR_WIDTH(BUFFER_ADDR_WIDTH)
  ) bfp_to_fp_converter
  (
    .clk(clk), 
    .rst_n(rst_n),
    
    //Write Buffer Control
    .prepare_weight(i_prepare_weight),
    .buffer_wr_en_i(buffer_wr_en_i),
    .buffer_wr_addr_i(buffer_wr_addr_i),
    
    //Execute Control
    .set_weight_i(set_weight_i),
    //.i_weight_data_fifo_wr_en(i_weight_data_fifo_wr_en),
    .activation_rd_en_i(buffer_rd_en_7_o),
    .buffer_rd_addr_i(buffer_rd_addr_7_o),
    
    .buffer_data_i(buffer_exponent_i),//
  
  //mac array
  //mac adder input
    .mac_acc_a_0_i(mac_acc_7_a_0_o),   .mac_acc_b_0_i(mac_acc_7_b_0_o),   .mac_acc_c_0_i(mac_acc_7_c_0_o),   .mac_acc_d_0_i(mac_acc_7_d_0_o),
    .mac_acc_a_1_i(mac_acc_7_a_1_o),   .mac_acc_b_1_i(mac_acc_7_b_1_o),   .mac_acc_c_1_i(mac_acc_7_c_1_o),   .mac_acc_d_1_i(mac_acc_7_d_1_o),
    .mac_acc_a_2_i(mac_acc_7_a_2_o),   .mac_acc_b_2_i(mac_acc_7_b_2_o),   .mac_acc_c_2_i(mac_acc_7_c_2_o),   .mac_acc_d_2_i(mac_acc_7_d_2_o),
    .mac_acc_a_3_i(mac_acc_7_a_3_o),   .mac_acc_b_3_i(mac_acc_7_b_3_o),   .mac_acc_c_3_i(mac_acc_7_c_3_o),   .mac_acc_d_3_i(mac_acc_7_d_3_o),
    .mac_acc_a_4_i(mac_acc_7_a_4_o),   .mac_acc_b_4_i(mac_acc_7_b_4_o),   .mac_acc_c_4_i(mac_acc_7_c_4_o),   .mac_acc_d_4_i(mac_acc_7_d_4_o),
    .mac_acc_a_5_i(mac_acc_7_a_5_o),   .mac_acc_b_5_i(mac_acc_7_b_5_o),   .mac_acc_c_5_i(mac_acc_7_c_5_o),   .mac_acc_d_5_i(mac_acc_7_d_5_o),
    .mac_acc_a_6_i(mac_acc_7_a_6_o),   .mac_acc_b_6_i(mac_acc_7_b_6_o),   .mac_acc_c_6_i(mac_acc_7_c_6_o),   .mac_acc_d_6_i(mac_acc_7_d_6_o),
    .mac_acc_a_7_i(mac_acc_7_a_7_o),   .mac_acc_b_7_i(mac_acc_7_b_7_o),   .mac_acc_c_7_i(mac_acc_7_c_7_o),   .mac_acc_d_7_i(mac_acc_7_d_7_o),
    .mac_acc_a_8_i(mac_acc_7_a_8_o),   .mac_acc_b_8_i(mac_acc_7_b_8_o),   .mac_acc_c_8_i(mac_acc_7_c_8_o),   .mac_acc_d_8_i(mac_acc_7_d_8_o),
    .mac_acc_a_9_i(mac_acc_7_a_9_o),   .mac_acc_b_9_i(mac_acc_7_b_9_o),   .mac_acc_c_9_i(mac_acc_7_c_9_o),   .mac_acc_d_9_i(mac_acc_7_d_9_o),
    .mac_acc_a_10_i(mac_acc_7_a_10_o), .mac_acc_b_10_i(mac_acc_7_b_10_o), .mac_acc_c_10_i(mac_acc_7_c_10_o), .mac_acc_d_10_i(mac_acc_7_d_10_o),
    .mac_acc_a_11_i(mac_acc_7_a_11_o), .mac_acc_b_11_i(mac_acc_7_b_11_o), .mac_acc_c_11_i(mac_acc_7_c_11_o), .mac_acc_d_11_i(mac_acc_7_d_11_o),
    .mac_acc_a_12_i(mac_acc_7_a_12_o), .mac_acc_b_12_i(mac_acc_7_b_12_o), .mac_acc_c_12_i(mac_acc_7_c_12_o), .mac_acc_d_12_i(mac_acc_7_d_12_o),
    .mac_acc_a_13_i(mac_acc_7_a_13_o), .mac_acc_b_13_i(mac_acc_7_b_13_o), .mac_acc_c_13_i(mac_acc_7_c_13_o), .mac_acc_d_13_i(mac_acc_7_d_13_o),
    .mac_acc_a_14_i(mac_acc_7_a_14_o), .mac_acc_b_14_i(mac_acc_7_b_14_o), .mac_acc_c_14_i(mac_acc_7_c_14_o), .mac_acc_d_14_i(mac_acc_7_d_14_o),
    .mac_acc_a_15_i(mac_acc_7_a_15_o), .mac_acc_b_15_i(mac_acc_7_b_15_o), .mac_acc_c_15_i(mac_acc_7_c_15_o), .mac_acc_d_15_i(mac_acc_7_d_15_o),
  //mac array output
    .mac_acc_0_o(mac_acc_0_o),   .mac_acc_1_o(mac_acc_1_o),   .mac_acc_2_o(mac_acc_2_o),   .mac_acc_3_o(mac_acc_3_o),
    .mac_acc_4_o(mac_acc_4_o),   .mac_acc_5_o(mac_acc_5_o),   .mac_acc_6_o(mac_acc_6_o),   .mac_acc_7_o(mac_acc_7_o),
    .mac_acc_8_o(mac_acc_8_o),   .mac_acc_9_o(mac_acc_9_o),   .mac_acc_10_o(mac_acc_10_o), .mac_acc_11_o(mac_acc_11_o),
    .mac_acc_12_o(mac_acc_12_o), .mac_acc_13_o(mac_acc_13_o), .mac_acc_14_o(mac_acc_14_o), .mac_acc_15_o(mac_acc_15_o),
    .mac_acc_16_o(mac_acc_16_o), .mac_acc_17_o(mac_acc_17_o), .mac_acc_18_o(mac_acc_18_o), .mac_acc_19_o(mac_acc_19_o),
    .mac_acc_20_o(mac_acc_20_o), .mac_acc_21_o(mac_acc_21_o), .mac_acc_22_o(mac_acc_22_o), .mac_acc_23_o(mac_acc_23_o),
    .mac_acc_24_o(mac_acc_24_o), .mac_acc_25_o(mac_acc_25_o), .mac_acc_26_o(mac_acc_26_o), .mac_acc_27_o(mac_acc_27_o),
    .mac_acc_28_o(mac_acc_28_o), .mac_acc_29_o(mac_acc_29_o), .mac_acc_30_o(mac_acc_30_o), .mac_acc_31_o(mac_acc_31_o),

    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_expo),
    .i_load_weight_data_0_b(load_weight_data_0_b_expo),
    .i_load_weight_data_0_c(load_weight_data_0_c_expo),
    .i_load_weight_data_0_d(load_weight_data_0_d_expo),

    .i_load_weight_data_1_a(load_weight_data_1_a_expo),
    .i_load_weight_data_1_b(load_weight_data_1_b_expo),
    .i_load_weight_data_1_c(load_weight_data_1_c_expo),
    .i_load_weight_data_1_d(load_weight_data_1_d_expo),

    .i_load_weight_data_2_a(load_weight_data_2_a_expo),
    .i_load_weight_data_2_b(load_weight_data_2_b_expo),
    .i_load_weight_data_2_c(load_weight_data_2_c_expo),
    .i_load_weight_data_2_d(load_weight_data_2_d_expo),

    .i_load_weight_data_3_a(load_weight_data_3_a_expo),
    .i_load_weight_data_3_b(load_weight_data_3_b_expo),
    .i_load_weight_data_3_c(load_weight_data_3_c_expo),
    .i_load_weight_data_3_d(load_weight_data_3_d_expo),

    .i_load_weight_data_4_a(load_weight_data_4_a_expo),
    .i_load_weight_data_4_b(load_weight_data_4_b_expo),
    .i_load_weight_data_4_c(load_weight_data_4_c_expo),
    .i_load_weight_data_4_d(load_weight_data_4_d_expo),

    .i_load_weight_data_5_a(load_weight_data_5_a_expo),
    .i_load_weight_data_5_b(load_weight_data_5_b_expo),
    .i_load_weight_data_5_c(load_weight_data_5_c_expo),
    .i_load_weight_data_5_d(load_weight_data_5_d_expo),

    .i_load_weight_data_6_a(load_weight_data_6_a_expo),
    .i_load_weight_data_6_b(load_weight_data_6_b_expo),
    .i_load_weight_data_6_c(load_weight_data_6_c_expo),
    .i_load_weight_data_6_d(load_weight_data_6_d_expo),

    .i_load_weight_data_7_a(load_weight_data_7_a_expo),
    .i_load_weight_data_7_b(load_weight_data_7_b_expo),
    .i_load_weight_data_7_c(load_weight_data_7_c_expo),
    .i_load_weight_data_7_d(load_weight_data_7_d_expo),

    .i_load_weight_data_8_a(load_weight_data_8_a_expo),
    .i_load_weight_data_8_b(load_weight_data_8_b_expo),
    .i_load_weight_data_8_c(load_weight_data_8_c_expo),
    .i_load_weight_data_8_d(load_weight_data_8_d_expo),

    .i_load_weight_data_9_a(load_weight_data_9_a_expo),
    .i_load_weight_data_9_b(load_weight_data_9_b_expo),
    .i_load_weight_data_9_c(load_weight_data_9_c_expo),
    .i_load_weight_data_9_d(load_weight_data_9_d_expo),

    .i_load_weight_data_10_a(load_weight_data_10_a_expo),
    .i_load_weight_data_10_b(load_weight_data_10_b_expo),
    .i_load_weight_data_10_c(load_weight_data_10_c_expo),
    .i_load_weight_data_10_d(load_weight_data_10_d_expo),

    .i_load_weight_data_11_a(load_weight_data_11_a_expo),
    .i_load_weight_data_11_b(load_weight_data_11_b_expo),
    .i_load_weight_data_11_c(load_weight_data_11_c_expo),
    .i_load_weight_data_11_d(load_weight_data_11_d_expo),

    .i_load_weight_data_12_a(load_weight_data_12_a_expo),
    .i_load_weight_data_12_b(load_weight_data_12_b_expo),
    .i_load_weight_data_12_c(load_weight_data_12_c_expo),
    .i_load_weight_data_12_d(load_weight_data_12_d_expo),

    .i_load_weight_data_13_a(load_weight_data_13_a_expo),
    .i_load_weight_data_13_b(load_weight_data_13_b_expo),
    .i_load_weight_data_13_c(load_weight_data_13_c_expo),
    .i_load_weight_data_13_d(load_weight_data_13_d_expo),

    .i_load_weight_data_14_a(load_weight_data_14_a_expo),
    .i_load_weight_data_14_b(load_weight_data_14_b_expo),
    .i_load_weight_data_14_c(load_weight_data_14_c_expo),
    .i_load_weight_data_14_d(load_weight_data_14_d_expo),

    .i_load_weight_data_15_a(load_weight_data_15_a_expo),
    .i_load_weight_data_15_b(load_weight_data_15_b_expo),
    .i_load_weight_data_15_c(load_weight_data_15_c_expo),
    .i_load_weight_data_15_d(load_weight_data_15_d_expo),

    .i_load_weight_data_16_a(load_weight_data_16_a_expo),
    .i_load_weight_data_16_b(load_weight_data_16_b_expo),
    .i_load_weight_data_16_c(load_weight_data_16_c_expo),
    .i_load_weight_data_16_d(load_weight_data_16_d_expo),

    .i_load_weight_data_17_a(load_weight_data_17_a_expo),
    .i_load_weight_data_17_b(load_weight_data_17_b_expo),
    .i_load_weight_data_17_c(load_weight_data_17_c_expo),
    .i_load_weight_data_17_d(load_weight_data_17_d_expo),

    .i_load_weight_data_18_a(load_weight_data_18_a_expo),
    .i_load_weight_data_18_b(load_weight_data_18_b_expo),
    .i_load_weight_data_18_c(load_weight_data_18_c_expo),
    .i_load_weight_data_18_d(load_weight_data_18_d_expo),

    .i_load_weight_data_19_a(load_weight_data_19_a_expo),
    .i_load_weight_data_19_b(load_weight_data_19_b_expo),
    .i_load_weight_data_19_c(load_weight_data_19_c_expo),
    .i_load_weight_data_19_d(load_weight_data_19_d_expo),

    .i_load_weight_data_20_a(load_weight_data_20_a_expo),
    .i_load_weight_data_20_b(load_weight_data_20_b_expo),
    .i_load_weight_data_20_c(load_weight_data_20_c_expo),
    .i_load_weight_data_20_d(load_weight_data_20_d_expo),

    .i_load_weight_data_21_a(load_weight_data_21_a_expo),
    .i_load_weight_data_21_b(load_weight_data_21_b_expo),
    .i_load_weight_data_21_c(load_weight_data_21_c_expo),
    .i_load_weight_data_21_d(load_weight_data_21_d_expo),

    .i_load_weight_data_22_a(load_weight_data_22_a_expo),
    .i_load_weight_data_22_b(load_weight_data_22_b_expo),
    .i_load_weight_data_22_c(load_weight_data_22_c_expo),
    .i_load_weight_data_22_d(load_weight_data_22_d_expo),

    .i_load_weight_data_23_a(load_weight_data_23_a_expo),
    .i_load_weight_data_23_b(load_weight_data_23_b_expo),
    .i_load_weight_data_23_c(load_weight_data_23_c_expo),
    .i_load_weight_data_23_d(load_weight_data_23_d_expo),

    .i_load_weight_data_24_a(load_weight_data_24_a_expo),
    .i_load_weight_data_24_b(load_weight_data_24_b_expo),
    .i_load_weight_data_24_c(load_weight_data_24_c_expo),
    .i_load_weight_data_24_d(load_weight_data_24_d_expo),

    .i_load_weight_data_25_a(load_weight_data_25_a_expo),
    .i_load_weight_data_25_b(load_weight_data_25_b_expo),
    .i_load_weight_data_25_c(load_weight_data_25_c_expo),
    .i_load_weight_data_25_d(load_weight_data_25_d_expo),

    .i_load_weight_data_26_a(load_weight_data_26_a_expo),
    .i_load_weight_data_26_b(load_weight_data_26_b_expo),
    .i_load_weight_data_26_c(load_weight_data_26_c_expo),
    .i_load_weight_data_26_d(load_weight_data_26_d_expo),

    .i_load_weight_data_27_a(load_weight_data_27_a_expo),
    .i_load_weight_data_27_b(load_weight_data_27_b_expo),
    .i_load_weight_data_27_c(load_weight_data_27_c_expo),
    .i_load_weight_data_27_d(load_weight_data_27_d_expo),

    .i_load_weight_data_28_a(load_weight_data_28_a_expo),
    .i_load_weight_data_28_b(load_weight_data_28_b_expo),
    .i_load_weight_data_28_c(load_weight_data_28_c_expo),
    .i_load_weight_data_28_d(load_weight_data_28_d_expo),

    .i_load_weight_data_29_a(load_weight_data_29_a_expo),
    .i_load_weight_data_29_b(load_weight_data_29_b_expo),
    .i_load_weight_data_29_c(load_weight_data_29_c_expo),
    .i_load_weight_data_29_d(load_weight_data_29_d_expo),

    .i_load_weight_data_30_a(load_weight_data_30_a_expo),
    .i_load_weight_data_30_b(load_weight_data_30_b_expo),
    .i_load_weight_data_30_c(load_weight_data_30_c_expo),
    .i_load_weight_data_30_d(load_weight_data_30_d_expo),

    .i_load_weight_data_31_a(load_weight_data_31_a_expo),
    .i_load_weight_data_31_b(load_weight_data_31_b_expo),
    .i_load_weight_data_31_c(load_weight_data_31_c_expo),
    .i_load_weight_data_31_d(load_weight_data_31_d_expo),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(load_weight_data_0_a_bias),
    .o_load_weight_data_0_b(load_weight_data_0_b_bias),
    .o_load_weight_data_0_c(load_weight_data_0_c_bias),
    .o_load_weight_data_0_d(load_weight_data_0_d_bias),

    .o_load_weight_data_1_a(load_weight_data_1_a_bias),
    .o_load_weight_data_1_b(load_weight_data_1_b_bias),
    .o_load_weight_data_1_c(load_weight_data_1_c_bias),
    .o_load_weight_data_1_d(load_weight_data_1_d_bias),

    .o_load_weight_data_2_a(load_weight_data_2_a_bias),
    .o_load_weight_data_2_b(load_weight_data_2_b_bias),
    .o_load_weight_data_2_c(load_weight_data_2_c_bias),
    .o_load_weight_data_2_d(load_weight_data_2_d_bias),

    .o_load_weight_data_3_a(load_weight_data_3_a_bias),
    .o_load_weight_data_3_b(load_weight_data_3_b_bias),
    .o_load_weight_data_3_c(load_weight_data_3_c_bias),
    .o_load_weight_data_3_d(load_weight_data_3_d_bias),

    .o_load_weight_data_4_a(load_weight_data_4_a_bias),
    .o_load_weight_data_4_b(load_weight_data_4_b_bias),
    .o_load_weight_data_4_c(load_weight_data_4_c_bias),
    .o_load_weight_data_4_d(load_weight_data_4_d_bias),

    .o_load_weight_data_5_a(load_weight_data_5_a_bias),
    .o_load_weight_data_5_b(load_weight_data_5_b_bias),
    .o_load_weight_data_5_c(load_weight_data_5_c_bias),
    .o_load_weight_data_5_d(load_weight_data_5_d_bias),

    .o_load_weight_data_6_a(load_weight_data_6_a_bias),
    .o_load_weight_data_6_b(load_weight_data_6_b_bias),
    .o_load_weight_data_6_c(load_weight_data_6_c_bias),
    .o_load_weight_data_6_d(load_weight_data_6_d_bias),

    .o_load_weight_data_7_a(load_weight_data_7_a_bias),
    .o_load_weight_data_7_b(load_weight_data_7_b_bias),
    .o_load_weight_data_7_c(load_weight_data_7_c_bias),
    .o_load_weight_data_7_d(load_weight_data_7_d_bias),

    .o_load_weight_data_8_a(load_weight_data_8_a_bias),
    .o_load_weight_data_8_b(load_weight_data_8_b_bias),
    .o_load_weight_data_8_c(load_weight_data_8_c_bias),
    .o_load_weight_data_8_d(load_weight_data_8_d_bias),

    .o_load_weight_data_9_a(load_weight_data_9_a_bias),
    .o_load_weight_data_9_b(load_weight_data_9_b_bias),
    .o_load_weight_data_9_c(load_weight_data_9_c_bias),
    .o_load_weight_data_9_d(load_weight_data_9_d_bias),

    .o_load_weight_data_10_a(load_weight_data_10_a_bias),
    .o_load_weight_data_10_b(load_weight_data_10_b_bias),
    .o_load_weight_data_10_c(load_weight_data_10_c_bias),
    .o_load_weight_data_10_d(load_weight_data_10_d_bias),

    .o_load_weight_data_11_a(load_weight_data_11_a_bias),
    .o_load_weight_data_11_b(load_weight_data_11_b_bias),
    .o_load_weight_data_11_c(load_weight_data_11_c_bias),
    .o_load_weight_data_11_d(load_weight_data_11_d_bias),

    .o_load_weight_data_12_a(load_weight_data_12_a_bias),
    .o_load_weight_data_12_b(load_weight_data_12_b_bias),
    .o_load_weight_data_12_c(load_weight_data_12_c_bias),
    .o_load_weight_data_12_d(load_weight_data_12_d_bias),

    .o_load_weight_data_13_a(load_weight_data_13_a_bias),
    .o_load_weight_data_13_b(load_weight_data_13_b_bias),
    .o_load_weight_data_13_c(load_weight_data_13_c_bias),
    .o_load_weight_data_13_d(load_weight_data_13_d_bias),

    .o_load_weight_data_14_a(load_weight_data_14_a_bias),
    .o_load_weight_data_14_b(load_weight_data_14_b_bias),
    .o_load_weight_data_14_c(load_weight_data_14_c_bias),
    .o_load_weight_data_14_d(load_weight_data_14_d_bias),

    .o_load_weight_data_15_a(load_weight_data_15_a_bias),
    .o_load_weight_data_15_b(load_weight_data_15_b_bias),
    .o_load_weight_data_15_c(load_weight_data_15_c_bias),
    .o_load_weight_data_15_d(load_weight_data_15_d_bias),

    .o_load_weight_data_16_a(load_weight_data_16_a_bias),
    .o_load_weight_data_16_b(load_weight_data_16_b_bias),
    .o_load_weight_data_16_c(load_weight_data_16_c_bias),
    .o_load_weight_data_16_d(load_weight_data_16_d_bias),

    .o_load_weight_data_17_a(load_weight_data_17_a_bias),
    .o_load_weight_data_17_b(load_weight_data_17_b_bias),
    .o_load_weight_data_17_c(load_weight_data_17_c_bias),
    .o_load_weight_data_17_d(load_weight_data_17_d_bias),

    .o_load_weight_data_18_a(load_weight_data_18_a_bias),
    .o_load_weight_data_18_b(load_weight_data_18_b_bias),
    .o_load_weight_data_18_c(load_weight_data_18_c_bias),
    .o_load_weight_data_18_d(load_weight_data_18_d_bias),

    .o_load_weight_data_19_a(load_weight_data_19_a_bias),
    .o_load_weight_data_19_b(load_weight_data_19_b_bias),
    .o_load_weight_data_19_c(load_weight_data_19_c_bias),
    .o_load_weight_data_19_d(load_weight_data_19_d_bias),

    .o_load_weight_data_20_a(load_weight_data_20_a_bias),
    .o_load_weight_data_20_b(load_weight_data_20_b_bias),
    .o_load_weight_data_20_c(load_weight_data_20_c_bias),
    .o_load_weight_data_20_d(load_weight_data_20_d_bias),

    .o_load_weight_data_21_a(load_weight_data_21_a_bias),
    .o_load_weight_data_21_b(load_weight_data_21_b_bias),
    .o_load_weight_data_21_c(load_weight_data_21_c_bias),
    .o_load_weight_data_21_d(load_weight_data_21_d_bias),

    .o_load_weight_data_22_a(load_weight_data_22_a_bias),
    .o_load_weight_data_22_b(load_weight_data_22_b_bias),
    .o_load_weight_data_22_c(load_weight_data_22_c_bias),
    .o_load_weight_data_22_d(load_weight_data_22_d_bias),

    .o_load_weight_data_23_a(load_weight_data_23_a_bias),
    .o_load_weight_data_23_b(load_weight_data_23_b_bias),
    .o_load_weight_data_23_c(load_weight_data_23_c_bias),
    .o_load_weight_data_23_d(load_weight_data_23_d_bias),

    .o_load_weight_data_24_a(load_weight_data_24_a_bias),
    .o_load_weight_data_24_b(load_weight_data_24_b_bias),
    .o_load_weight_data_24_c(load_weight_data_24_c_bias),
    .o_load_weight_data_24_d(load_weight_data_24_d_bias),

    .o_load_weight_data_25_a(load_weight_data_25_a_bias),
    .o_load_weight_data_25_b(load_weight_data_25_b_bias),
    .o_load_weight_data_25_c(load_weight_data_25_c_bias),
    .o_load_weight_data_25_d(load_weight_data_25_d_bias),

    .o_load_weight_data_26_a(load_weight_data_26_a_bias),
    .o_load_weight_data_26_b(load_weight_data_26_b_bias),
    .o_load_weight_data_26_c(load_weight_data_26_c_bias),
    .o_load_weight_data_26_d(load_weight_data_26_d_bias),

    .o_load_weight_data_27_a(load_weight_data_27_a_bias),
    .o_load_weight_data_27_b(load_weight_data_27_b_bias),
    .o_load_weight_data_27_c(load_weight_data_27_c_bias),
    .o_load_weight_data_27_d(load_weight_data_27_d_bias),

    .o_load_weight_data_28_a(load_weight_data_28_a_bias),
    .o_load_weight_data_28_b(load_weight_data_28_b_bias),
    .o_load_weight_data_28_c(load_weight_data_28_c_bias),
    .o_load_weight_data_28_d(load_weight_data_28_d_bias),

    .o_load_weight_data_29_a(load_weight_data_29_a_bias),
    .o_load_weight_data_29_b(load_weight_data_29_b_bias),
    .o_load_weight_data_29_c(load_weight_data_29_c_bias),
    .o_load_weight_data_29_d(load_weight_data_29_d_bias),

    .o_load_weight_data_30_a(load_weight_data_30_a_bias),
    .o_load_weight_data_30_b(load_weight_data_30_b_bias),
    .o_load_weight_data_30_c(load_weight_data_30_c_bias),
    .o_load_weight_data_30_d(load_weight_data_30_d_bias),

    .o_load_weight_data_31_a(load_weight_data_31_a_bias),
    .o_load_weight_data_31_b(load_weight_data_31_b_bias),
    .o_load_weight_data_31_c(load_weight_data_31_c_bias),
    .o_load_weight_data_31_d(load_weight_data_31_d_bias) 
  );
  
  accumulator
  #(
    .ACCUM_DATA_WIDTH(ACCUM_DATA_WIDTH),
    .ACCUM_ADDR_WIDTH(ACCUM_ADDR_WIDTH),
    .BIAS_ROM_ADDR(BIAS_ROM_ADDR)
  ) accumulator
  (
    .clk(clk), 
    .rst_n(rst_n),
    .bias_mode_i(bias_mode_i),

    .rd_en_i(accum_rd_en_i),
    .wr_en_i(accum_wr_en_i),
    
    .i_prepare_weight(i_prepare_weight),
    .i_set_bias(i_set_bias),
    .i_bias_data_fifo_wr_en(i_bias_data_fifo_wr_en),
    
    .accum_addr_i(accum_addr_i),
    .accum_0_i(mac_acc_0_o),   .accum_1_i(mac_acc_1_o),   .accum_2_i(mac_acc_2_o),   .accum_3_i(mac_acc_3_o),
    .accum_4_i(mac_acc_4_o),   .accum_5_i(mac_acc_5_o),   .accum_6_i(mac_acc_6_o),   .accum_7_i(mac_acc_7_o),
    .accum_8_i(mac_acc_8_o),   .accum_9_i(mac_acc_9_o),   .accum_10_i(mac_acc_10_o), .accum_11_i(mac_acc_11_o),
    .accum_12_i(mac_acc_12_o), .accum_13_i(mac_acc_13_o), .accum_14_i(mac_acc_14_o), .accum_15_i(mac_acc_15_o),
    .accum_16_i(mac_acc_16_o), .accum_17_i(mac_acc_17_o), .accum_18_i(mac_acc_18_o), .accum_19_i(mac_acc_19_o),
    .accum_20_i(mac_acc_20_o), .accum_21_i(mac_acc_21_o), .accum_22_i(mac_acc_22_o), .accum_23_i(mac_acc_23_o),
    .accum_24_i(mac_acc_24_o), .accum_25_i(mac_acc_25_o), .accum_26_i(mac_acc_26_o), .accum_27_i(mac_acc_27_o),
    .accum_28_i(mac_acc_28_o), .accum_29_i(mac_acc_29_o), .accum_30_i(mac_acc_30_o), .accum_31_i(mac_acc_31_o),
  
    .accum_0_o(accum_0_o),   .accum_1_o(accum_1_o),   .accum_2_o(accum_2_o),   .accum_3_o(accum_3_o),
    .accum_4_o(accum_4_o),   .accum_5_o(accum_5_o),   .accum_6_o(accum_6_o),   .accum_7_o(accum_7_o),
    .accum_8_o(accum_8_o),   .accum_9_o(accum_9_o),   .accum_10_o(accum_10_o), .accum_11_o(accum_11_o),
    .accum_12_o(accum_12_o), .accum_13_o(accum_13_o), .accum_14_o(accum_14_o), .accum_15_o(accum_15_o),
    .accum_16_o(accum_16_o), .accum_17_o(accum_17_o), .accum_18_o(accum_18_o), .accum_19_o(accum_19_o),
    .accum_20_o(accum_20_o), .accum_21_o(accum_21_o), .accum_22_o(accum_22_o), .accum_23_o(accum_23_o),
    .accum_24_o(accum_24_o), .accum_25_o(accum_25_o), .accum_26_o(accum_26_o), .accum_27_o(accum_27_o),
    .accum_28_o(accum_28_o), .accum_29_o(accum_29_o), .accum_30_o(accum_30_o), .accum_31_o(accum_31_o),

    .i_execute_out_fifo_wr_en(i_execute_out_fifo_wr_en), //final data
    .i_execute_out_fifo_rd_en(i_execute_out_fifo_rd_en),
    .o_execute_out_fifo_empty(o_execute_out_fifo_empty),
    .o_execute_out_fifo_full(o_execute_out_fifo_full),

    //Load Weight In/////////////////////////////////////////////////////////////////
    .i_load_weight_data_0_a(load_weight_data_0_a_bias),
    .i_load_weight_data_0_b(load_weight_data_0_b_bias),
    .i_load_weight_data_0_c(load_weight_data_0_c_bias),
    .i_load_weight_data_0_d(load_weight_data_0_d_bias),

    .i_load_weight_data_1_a(load_weight_data_1_a_bias),
    .i_load_weight_data_1_b(load_weight_data_1_b_bias),
    .i_load_weight_data_1_c(load_weight_data_1_c_bias),
    .i_load_weight_data_1_d(load_weight_data_1_d_bias),

    .i_load_weight_data_2_a(load_weight_data_2_a_bias),
    .i_load_weight_data_2_b(load_weight_data_2_b_bias),
    .i_load_weight_data_2_c(load_weight_data_2_c_bias),
    .i_load_weight_data_2_d(load_weight_data_2_d_bias),

    .i_load_weight_data_3_a(load_weight_data_3_a_bias),
    .i_load_weight_data_3_b(load_weight_data_3_b_bias),
    .i_load_weight_data_3_c(load_weight_data_3_c_bias),
    .i_load_weight_data_3_d(load_weight_data_3_d_bias),

    .i_load_weight_data_4_a(load_weight_data_4_a_bias),
    .i_load_weight_data_4_b(load_weight_data_4_b_bias),
    .i_load_weight_data_4_c(load_weight_data_4_c_bias),
    .i_load_weight_data_4_d(load_weight_data_4_d_bias),

    .i_load_weight_data_5_a(load_weight_data_5_a_bias),
    .i_load_weight_data_5_b(load_weight_data_5_b_bias),
    .i_load_weight_data_5_c(load_weight_data_5_c_bias),
    .i_load_weight_data_5_d(load_weight_data_5_d_bias),

    .i_load_weight_data_6_a(load_weight_data_6_a_bias),
    .i_load_weight_data_6_b(load_weight_data_6_b_bias),
    .i_load_weight_data_6_c(load_weight_data_6_c_bias),
    .i_load_weight_data_6_d(load_weight_data_6_d_bias),

    .i_load_weight_data_7_a(load_weight_data_7_a_bias),
    .i_load_weight_data_7_b(load_weight_data_7_b_bias),
    .i_load_weight_data_7_c(load_weight_data_7_c_bias),
    .i_load_weight_data_7_d(load_weight_data_7_d_bias),

    .i_load_weight_data_8_a(load_weight_data_8_a_bias),
    .i_load_weight_data_8_b(load_weight_data_8_b_bias),
    .i_load_weight_data_8_c(load_weight_data_8_c_bias),
    .i_load_weight_data_8_d(load_weight_data_8_d_bias),

    .i_load_weight_data_9_a(load_weight_data_9_a_bias),
    .i_load_weight_data_9_b(load_weight_data_9_b_bias),
    .i_load_weight_data_9_c(load_weight_data_9_c_bias),
    .i_load_weight_data_9_d(load_weight_data_9_d_bias),

    .i_load_weight_data_10_a(load_weight_data_10_a_bias),
    .i_load_weight_data_10_b(load_weight_data_10_b_bias),
    .i_load_weight_data_10_c(load_weight_data_10_c_bias),
    .i_load_weight_data_10_d(load_weight_data_10_d_bias),

    .i_load_weight_data_11_a(load_weight_data_11_a_bias),
    .i_load_weight_data_11_b(load_weight_data_11_b_bias),
    .i_load_weight_data_11_c(load_weight_data_11_c_bias),
    .i_load_weight_data_11_d(load_weight_data_11_d_bias),

    .i_load_weight_data_12_a(load_weight_data_12_a_bias),
    .i_load_weight_data_12_b(load_weight_data_12_b_bias),
    .i_load_weight_data_12_c(load_weight_data_12_c_bias),
    .i_load_weight_data_12_d(load_weight_data_12_d_bias),

    .i_load_weight_data_13_a(load_weight_data_13_a_bias),
    .i_load_weight_data_13_b(load_weight_data_13_b_bias),
    .i_load_weight_data_13_c(load_weight_data_13_c_bias),
    .i_load_weight_data_13_d(load_weight_data_13_d_bias),

    .i_load_weight_data_14_a(load_weight_data_14_a_bias),
    .i_load_weight_data_14_b(load_weight_data_14_b_bias),
    .i_load_weight_data_14_c(load_weight_data_14_c_bias),
    .i_load_weight_data_14_d(load_weight_data_14_d_bias),

    .i_load_weight_data_15_a(load_weight_data_15_a_bias),
    .i_load_weight_data_15_b(load_weight_data_15_b_bias),
    .i_load_weight_data_15_c(load_weight_data_15_c_bias),
    .i_load_weight_data_15_d(load_weight_data_15_d_bias),

    .i_load_weight_data_16_a(load_weight_data_16_a_bias),
    .i_load_weight_data_16_b(load_weight_data_16_b_bias),
    .i_load_weight_data_16_c(load_weight_data_16_c_bias),
    .i_load_weight_data_16_d(load_weight_data_16_d_bias),

    .i_load_weight_data_17_a(load_weight_data_17_a_bias),
    .i_load_weight_data_17_b(load_weight_data_17_b_bias),
    .i_load_weight_data_17_c(load_weight_data_17_c_bias),
    .i_load_weight_data_17_d(load_weight_data_17_d_bias),

    .i_load_weight_data_18_a(load_weight_data_18_a_bias),
    .i_load_weight_data_18_b(load_weight_data_18_b_bias),
    .i_load_weight_data_18_c(load_weight_data_18_c_bias),
    .i_load_weight_data_18_d(load_weight_data_18_d_bias),

    .i_load_weight_data_19_a(load_weight_data_19_a_bias),
    .i_load_weight_data_19_b(load_weight_data_19_b_bias),
    .i_load_weight_data_19_c(load_weight_data_19_c_bias),
    .i_load_weight_data_19_d(load_weight_data_19_d_bias),

    .i_load_weight_data_20_a(load_weight_data_20_a_bias),
    .i_load_weight_data_20_b(load_weight_data_20_b_bias),
    .i_load_weight_data_20_c(load_weight_data_20_c_bias),
    .i_load_weight_data_20_d(load_weight_data_20_d_bias),

    .i_load_weight_data_21_a(load_weight_data_21_a_bias),
    .i_load_weight_data_21_b(load_weight_data_21_b_bias),
    .i_load_weight_data_21_c(load_weight_data_21_c_bias),
    .i_load_weight_data_21_d(load_weight_data_21_d_bias),

    .i_load_weight_data_22_a(load_weight_data_22_a_bias),
    .i_load_weight_data_22_b(load_weight_data_22_b_bias),
    .i_load_weight_data_22_c(load_weight_data_22_c_bias),
    .i_load_weight_data_22_d(load_weight_data_22_d_bias),

    .i_load_weight_data_23_a(load_weight_data_23_a_bias),
    .i_load_weight_data_23_b(load_weight_data_23_b_bias),
    .i_load_weight_data_23_c(load_weight_data_23_c_bias),
    .i_load_weight_data_23_d(load_weight_data_23_d_bias),

    .i_load_weight_data_24_a(load_weight_data_24_a_bias),
    .i_load_weight_data_24_b(load_weight_data_24_b_bias),
    .i_load_weight_data_24_c(load_weight_data_24_c_bias),
    .i_load_weight_data_24_d(load_weight_data_24_d_bias),

    .i_load_weight_data_25_a(load_weight_data_25_a_bias),
    .i_load_weight_data_25_b(load_weight_data_25_b_bias),
    .i_load_weight_data_25_c(load_weight_data_25_c_bias),
    .i_load_weight_data_25_d(load_weight_data_25_d_bias),

    .i_load_weight_data_26_a(load_weight_data_26_a_bias),
    .i_load_weight_data_26_b(load_weight_data_26_b_bias),
    .i_load_weight_data_26_c(load_weight_data_26_c_bias),
    .i_load_weight_data_26_d(load_weight_data_26_d_bias),

    .i_load_weight_data_27_a(load_weight_data_27_a_bias),
    .i_load_weight_data_27_b(load_weight_data_27_b_bias),
    .i_load_weight_data_27_c(load_weight_data_27_c_bias),
    .i_load_weight_data_27_d(load_weight_data_27_d_bias),

    .i_load_weight_data_28_a(load_weight_data_28_a_bias),
    .i_load_weight_data_28_b(load_weight_data_28_b_bias),
    .i_load_weight_data_28_c(load_weight_data_28_c_bias),
    .i_load_weight_data_28_d(load_weight_data_28_d_bias),

    .i_load_weight_data_29_a(load_weight_data_29_a_bias),
    .i_load_weight_data_29_b(load_weight_data_29_b_bias),
    .i_load_weight_data_29_c(load_weight_data_29_c_bias),
    .i_load_weight_data_29_d(load_weight_data_29_d_bias),

    .i_load_weight_data_30_a(load_weight_data_30_a_bias),
    .i_load_weight_data_30_b(load_weight_data_30_b_bias),
    .i_load_weight_data_30_c(load_weight_data_30_c_bias),
    .i_load_weight_data_30_d(load_weight_data_30_d_bias),

    .i_load_weight_data_31_a(load_weight_data_31_a_bias),
    .i_load_weight_data_31_b(load_weight_data_31_b_bias),
    .i_load_weight_data_31_c(load_weight_data_31_c_bias),
    .i_load_weight_data_31_d(load_weight_data_31_d_bias),

    //Load Weight Out/////////////////////////////////////////////////////////////////
    .o_load_weight_data_0_a(o_load_weight_data_0_a_param),
    .o_load_weight_data_0_b(o_load_weight_data_0_b_param),
    .o_load_weight_data_0_c(o_load_weight_data_0_c_param),
    .o_load_weight_data_0_d(o_load_weight_data_0_d_param),

    .o_load_weight_data_1_a(o_load_weight_data_1_a_param),
    .o_load_weight_data_1_b(o_load_weight_data_1_b_param),
    .o_load_weight_data_1_c(o_load_weight_data_1_c_param),
    .o_load_weight_data_1_d(o_load_weight_data_1_d_param),

    .o_load_weight_data_2_a(o_load_weight_data_2_a_param),
    .o_load_weight_data_2_b(o_load_weight_data_2_b_param),
    .o_load_weight_data_2_c(o_load_weight_data_2_c_param),
    .o_load_weight_data_2_d(o_load_weight_data_2_d_param),

    .o_load_weight_data_3_a(o_load_weight_data_3_a_param),
    .o_load_weight_data_3_b(o_load_weight_data_3_b_param),
    .o_load_weight_data_3_c(o_load_weight_data_3_c_param),
    .o_load_weight_data_3_d(o_load_weight_data_3_d_param),

    .o_load_weight_data_4_a(o_load_weight_data_4_a_param),
    .o_load_weight_data_4_b(o_load_weight_data_4_b_param),
    .o_load_weight_data_4_c(o_load_weight_data_4_c_param),
    .o_load_weight_data_4_d(o_load_weight_data_4_d_param),

    .o_load_weight_data_5_a(o_load_weight_data_5_a_param),
    .o_load_weight_data_5_b(o_load_weight_data_5_b_param),
    .o_load_weight_data_5_c(o_load_weight_data_5_c_param),
    .o_load_weight_data_5_d(o_load_weight_data_5_d_param),

    .o_load_weight_data_6_a(o_load_weight_data_6_a_param),
    .o_load_weight_data_6_b(o_load_weight_data_6_b_param),
    .o_load_weight_data_6_c(o_load_weight_data_6_c_param),
    .o_load_weight_data_6_d(o_load_weight_data_6_d_param),

    .o_load_weight_data_7_a(o_load_weight_data_7_a_param),
    .o_load_weight_data_7_b(o_load_weight_data_7_b_param),
    .o_load_weight_data_7_c(o_load_weight_data_7_c_param),
    .o_load_weight_data_7_d(o_load_weight_data_7_d_param),

    .o_load_weight_data_8_a(o_load_weight_data_8_a_param),
    .o_load_weight_data_8_b(o_load_weight_data_8_b_param),
    .o_load_weight_data_8_c(o_load_weight_data_8_c_param),
    .o_load_weight_data_8_d(o_load_weight_data_8_d_param),

    .o_load_weight_data_9_a(o_load_weight_data_9_a_param),
    .o_load_weight_data_9_b(o_load_weight_data_9_b_param),
    .o_load_weight_data_9_c(o_load_weight_data_9_c_param),
    .o_load_weight_data_9_d(o_load_weight_data_9_d_param),

    .o_load_weight_data_10_a(o_load_weight_data_10_a_param),
    .o_load_weight_data_10_b(o_load_weight_data_10_b_param),
    .o_load_weight_data_10_c(o_load_weight_data_10_c_param),
    .o_load_weight_data_10_d(o_load_weight_data_10_d_param),

    .o_load_weight_data_11_a(o_load_weight_data_11_a_param),
    .o_load_weight_data_11_b(o_load_weight_data_11_b_param),
    .o_load_weight_data_11_c(o_load_weight_data_11_c_param),
    .o_load_weight_data_11_d(o_load_weight_data_11_d_param),

    .o_load_weight_data_12_a(o_load_weight_data_12_a_param),
    .o_load_weight_data_12_b(o_load_weight_data_12_b_param),
    .o_load_weight_data_12_c(o_load_weight_data_12_c_param),
    .o_load_weight_data_12_d(o_load_weight_data_12_d_param),

    .o_load_weight_data_13_a(o_load_weight_data_13_a_param),
    .o_load_weight_data_13_b(o_load_weight_data_13_b_param),
    .o_load_weight_data_13_c(o_load_weight_data_13_c_param),
    .o_load_weight_data_13_d(o_load_weight_data_13_d_param),

    .o_load_weight_data_14_a(o_load_weight_data_14_a_param),
    .o_load_weight_data_14_b(o_load_weight_data_14_b_param),
    .o_load_weight_data_14_c(o_load_weight_data_14_c_param),
    .o_load_weight_data_14_d(o_load_weight_data_14_d_param),

    .o_load_weight_data_15_a(o_load_weight_data_15_a_param),
    .o_load_weight_data_15_b(o_load_weight_data_15_b_param),
    .o_load_weight_data_15_c(o_load_weight_data_15_c_param),
    .o_load_weight_data_15_d(o_load_weight_data_15_d_param),

    .o_load_weight_data_16_a(o_load_weight_data_16_a_param),
    .o_load_weight_data_16_b(o_load_weight_data_16_b_param),
    .o_load_weight_data_16_c(o_load_weight_data_16_c_param),
    .o_load_weight_data_16_d(o_load_weight_data_16_d_param),

    .o_load_weight_data_17_a(o_load_weight_data_17_a_param),
    .o_load_weight_data_17_b(o_load_weight_data_17_b_param),
    .o_load_weight_data_17_c(o_load_weight_data_17_c_param),
    .o_load_weight_data_17_d(o_load_weight_data_17_d_param),

    .o_load_weight_data_18_a(o_load_weight_data_18_a_param),
    .o_load_weight_data_18_b(o_load_weight_data_18_b_param),
    .o_load_weight_data_18_c(o_load_weight_data_18_c_param),
    .o_load_weight_data_18_d(o_load_weight_data_18_d_param),

    .o_load_weight_data_19_a(o_load_weight_data_19_a_param),
    .o_load_weight_data_19_b(o_load_weight_data_19_b_param),
    .o_load_weight_data_19_c(o_load_weight_data_19_c_param),
    .o_load_weight_data_19_d(o_load_weight_data_19_d_param),

    .o_load_weight_data_20_a(o_load_weight_data_20_a_param),
    .o_load_weight_data_20_b(o_load_weight_data_20_b_param),
    .o_load_weight_data_20_c(o_load_weight_data_20_c_param),
    .o_load_weight_data_20_d(o_load_weight_data_20_d_param),

    .o_load_weight_data_21_a(o_load_weight_data_21_a_param),
    .o_load_weight_data_21_b(o_load_weight_data_21_b_param),
    .o_load_weight_data_21_c(o_load_weight_data_21_c_param),
    .o_load_weight_data_21_d(o_load_weight_data_21_d_param),

    .o_load_weight_data_22_a(o_load_weight_data_22_a_param),
    .o_load_weight_data_22_b(o_load_weight_data_22_b_param),
    .o_load_weight_data_22_c(o_load_weight_data_22_c_param),
    .o_load_weight_data_22_d(o_load_weight_data_22_d_param),

    .o_load_weight_data_23_a(o_load_weight_data_23_a_param),
    .o_load_weight_data_23_b(o_load_weight_data_23_b_param),
    .o_load_weight_data_23_c(o_load_weight_data_23_c_param),
    .o_load_weight_data_23_d(o_load_weight_data_23_d_param),

    .o_load_weight_data_24_a(o_load_weight_data_24_a_param),
    .o_load_weight_data_24_b(o_load_weight_data_24_b_param),
    .o_load_weight_data_24_c(o_load_weight_data_24_c_param),
    .o_load_weight_data_24_d(o_load_weight_data_24_d_param),

    .o_load_weight_data_25_a(o_load_weight_data_25_a_param),
    .o_load_weight_data_25_b(o_load_weight_data_25_b_param),
    .o_load_weight_data_25_c(o_load_weight_data_25_c_param),
    .o_load_weight_data_25_d(o_load_weight_data_25_d_param),

    .o_load_weight_data_26_a(o_load_weight_data_26_a_param),
    .o_load_weight_data_26_b(o_load_weight_data_26_b_param),
    .o_load_weight_data_26_c(o_load_weight_data_26_c_param),
    .o_load_weight_data_26_d(o_load_weight_data_26_d_param),

    .o_load_weight_data_27_a(o_load_weight_data_27_a_param),
    .o_load_weight_data_27_b(o_load_weight_data_27_b_param),
    .o_load_weight_data_27_c(o_load_weight_data_27_c_param),
    .o_load_weight_data_27_d(o_load_weight_data_27_d_param),

    .o_load_weight_data_28_a(o_load_weight_data_28_a_param),
    .o_load_weight_data_28_b(o_load_weight_data_28_b_param),
    .o_load_weight_data_28_c(o_load_weight_data_28_c_param),
    .o_load_weight_data_28_d(o_load_weight_data_28_d_param),

    .o_load_weight_data_29_a(o_load_weight_data_29_a_param),
    .o_load_weight_data_29_b(o_load_weight_data_29_b_param),
    .o_load_weight_data_29_c(o_load_weight_data_29_c_param),
    .o_load_weight_data_29_d(o_load_weight_data_29_d_param),

    .o_load_weight_data_30_a(o_load_weight_data_30_a_param),
    .o_load_weight_data_30_b(o_load_weight_data_30_b_param),
    .o_load_weight_data_30_c(o_load_weight_data_30_c_param),
    .o_load_weight_data_30_d(o_load_weight_data_30_d_param),

    .o_load_weight_data_31_a(o_load_weight_data_31_a_param),
    .o_load_weight_data_31_b(o_load_weight_data_31_b_param),
    .o_load_weight_data_31_c(o_load_weight_data_31_c_param),
    .o_load_weight_data_31_d(o_load_weight_data_31_d_param) 
  );
endmodule
